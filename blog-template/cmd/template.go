package cmd

import (
	"errors"
	"io/fs"
	"os"
	"text/template"
	"time"

	"github.com/urfave/cli/v2"
)

type TemplateCmd *cli.Command

var mdArticleTemplate = `---
title: "{{.Title}}"
date: {{.CurrentTime}}
lastmod: {{.CurrentTime}}
draft: false
tags: ["go-lib"]
categories: ["go"]
author: solid-10

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
# comment: false
# toc: false
autoCollapseToc: true
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: '<a href="https://github.com/wow-yorick/articles" rel="noopener" target="_blank">查看源</a>'
# reward: false
# mathjax: false

---

`

type TemplateData struct {
	Title       string
	CurrentTime string
}

func NewTemplateCmd() TemplateCmd {
	return &cli.Command{
		Name:    "template",
		Aliases: []string{"tp"},
		Usage:   "创建文章模板 eg: ./app template --title=荷花",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:     "title",
				Aliases:  []string{"t"},
				Usage:    "title eg:荷花",
				Required: true,
			},
		},
		Action: func(ctx *cli.Context) error {
			d := &TemplateData{
				Title:       ctx.String("title"),
				CurrentTime: time.Now().Format(time.RFC3339),
			}
			if d.Title == "" {
				return errors.New("文章标题不能为空")
			}
			fileName := "./data/" + d.Title + ".md"
			// 文件存在不在处理
			if Exists(fileName) {
				return errors.New("File does exist.")
			}
			// 目录不存在创建
			if !Exists("./data") {
				_ = os.Mkdir("./data", fs.ModePerm)
			}

			// 创建文件
			f, err := os.Create(fileName)
			if err != nil {
				return err
			}
			_ = f.Chmod(fs.ModePerm)
			t, err := template.New(d.Title).Parse(mdArticleTemplate)
			if err != nil {
				return err
			}
			if err = t.Execute(f, d); err != nil {
				return err
			}
			return nil
		},
	}
}

// 判断所给路径文件/文件夹是否存在
func Exists(path string) bool {
	_, err := os.Stat(path) // os.Stat获取文件信息
	if err != nil {
		if os.IsExist(err) {
			return true
		}
		return false
	}
	return true
}
