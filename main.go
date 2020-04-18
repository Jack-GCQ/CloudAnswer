package main

import (
	"bytes"
	"crypto/des"
	"encoding/base64"
	"errors"
	_ "github.com/astaxie/beego/cache/redis"
	"github.com/gin-gonic/gin"
	"github.com/tidwall/gjson"
	"log"
	"net/http"
	"strconv"
)

const (
	iosDesKey = "!qazxsw@"
)

func main() {
	gin.SetMode(gin.ReleaseMode)
	route := gin.Default()
	route.GET("/getAnswers", GetAnswers)
	route.POST("/getAnswers", GetAnswers)
	route.GET("/decrypt", Decrypt)
	route.POST("/decrypt", Decrypt)
	route.GET("/encrypt", Encrypt)
	route.POST("/encrypt", Encrypt)
	route.GET("/notice", Notice)
	route.POST("/notice", Notice)
	err := route.Run(":9809")
	if err != nil {
		log.Println(err)
	}
}

func Notice(ctx *gin.Context) {
	var listData []interface{}
	listMap := make(map[string]string)
	// 时间原因直接写死，后续做拓展
	listMap["title"] = "使用说明"
	listMap["time"] = "1586793602922"
	listMap["desc"] = "答题使用说明"
	listMap["content"] = "在答题页面\n\n长按标题`正经答题`即可显示答案\n\n双击标题`正经答题`即可一键填写全部答案\n\n点击右上角题目数量即可显示答题卡\n\n单击答题卡页面题号即可跳转到相应的题目"

	listData = append(listData, listMap)
	ctx.JSON(http.StatusOK, gin.H{
		"code": http.StatusOK,
		"msg":  "",
		"list": listData,
	})
}

func Decrypt(ctx *gin.Context) {
	jsonData, err := GetParam("json", ctx, true)
	if err != nil {
		return
	}

	desKey := iosDesKey
	answerJson := gjson.Parse(DecryptDes([]byte(jsonData), desKey))
	if answerJson.String() == "" {
		ctx.JSON(http.StatusOK, gin.H{
			"code": 400,
			"msg":  "解密失败",
		})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"code": http.StatusOK,
		"msg":  "",
		"data": answerJson.String(),
	})
}

func Encrypt(ctx *gin.Context) {
	jsonData, err := GetParam("json", ctx, true)
	if err != nil {
		return
	}

	desKey := iosDesKey
	answerJson := EncryptDes([]byte(jsonData), desKey)
	ctx.JSON(http.StatusOK, gin.H{
		"code": http.StatusOK,
		"msg":  "",
		"data": answerJson,
	})
}

func GetAnswers(ctx *gin.Context) {
	jsonData, err := GetParam("json", ctx, true)
	if err != nil {
		return
	}
	desKey := iosDesKey
	answerJson := gjson.Parse(DecryptDes([]byte(jsonData), desKey))
	if answerJson.String() == "" {
		ctx.JSON(http.StatusOK, gin.H{
			"code": 400,
			"msg":  "解密失败",
		})
		return
	}
	answersMap := make(map[int]map[string]interface{})
	var answersList []interface{}
	for i := 0; i < len(answerJson.Array()); i++ {
		answerMapArray := answerJson.Get(strconv.Itoa(i))
		questionId := answerMapArray.Get("id").String()

		titles := answerMapArray.Get("title").String()

		choiceAs := answerMapArray.Get("choiceA").String()

		choiceBs := answerMapArray.Get("choiceB").String()

		choiceCs := answerMapArray.Get("choiceC").String()

		choiceDs := answerMapArray.Get("choiceD").String()

		choiceEs := answerMapArray.Get("choiceE").String()

		answers := answerMapArray.Get("answers").String()
		questionIdInt, _ := strconv.Atoi(questionId)
		answersMap[questionIdInt] = make(map[string]interface{})
		answersMap[questionIdInt]["uAnswer"] = answers
		answersMap[questionIdInt]["userAnswers"] = answerMapArray.Get("userAnswers").String()
		answersMap[questionIdInt]["id"] = questionId
		answersMap[questionIdInt]["psqId"] = answerMapArray.Get("psqId").String()
		answersMap[questionIdInt]["type"] = answerMapArray.Get("type").String()
		answersMap[questionIdInt]["answers"] = answers
		answersMap[questionIdInt]["title"] = titles
		answersMap[questionIdInt]["choiceA"] = choiceAs
		answersMap[questionIdInt]["choiceB"] = choiceBs
		answersMap[questionIdInt]["choiceC"] = choiceCs
		answersMap[questionIdInt]["choiceD"] = choiceDs
		answersMap[questionIdInt]["choiceE"] = choiceEs
		answersMap[questionIdInt]["questionIndex"] = answerMapArray.Get("questionIndex").String()
		answersList = append(answersList, answersMap[questionIdInt])
	}

	ctx.JSON(http.StatusOK, gin.H{
		"code": http.StatusOK,
		"msg":  "",
		"data": answersList,
	})
}

//获取GET/POST参数
func GetParam(param string, ctx *gin.Context, isRequired bool) (string, error) {
	value := ctx.Query(param)
	if value == "" {
		value = ctx.PostForm(param)
	}
	if isRequired && value == "" {
		ctx.JSON(http.StatusOK, gin.H{
			"code": http.StatusBadRequest,
			"msg":  "缺少参数 " + param,
		})
		return value, errors.New("缺少参数 " + param)
	}

	return value, nil
}

func EncryptDes(data []byte, keys string) string {
	key := []byte(keys)
	block, err := des.NewCipher(key)
	if err != nil {
		return ""
	}
	bs := block.BlockSize()
	data = PKCS5Padding(data, bs)
	if len(data)%bs != 0 {
		return ""
	}
	out := make([]byte, len(data))
	dst := out
	for len(data) > 0 {
		block.Encrypt(dst, data[:bs])
		data = data[bs:]
		dst = dst[bs:]
	}
	outString := base64.StdEncoding.EncodeToString(out)
	return outString
}

func DecryptDes(data []byte, keys string) string {
	data, _ = base64.StdEncoding.DecodeString(string(data))
	key := []byte(keys)
	block, err := des.NewCipher(key)
	if err != nil {
		return ""
	}
	bs := block.BlockSize()
	if len(data)%bs != 0 {
		return ""
	}
	out := make([]byte, len(data))
	dst := out
	for len(data) > 0 {
		block.Decrypt(dst, data[:bs])
		data = data[bs:]
		dst = dst[bs:]
	}
	out = PKCS5UnPadding(out)
	return string(out)
}

func PKCS5Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

func PKCS5UnPadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length-1])
	return origData[:(length - unpadding)]
}
