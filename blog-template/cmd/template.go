package cmd

import (
	"errors"
	"os"
	"text/template"
	"time"

	"github.com/urfave/cli/v2"
)

type TemplateCmd *cli.Command

var mdArticleTemplate = `
---
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
			fileName := "./data/" + d.Title + ".md"
			// 文件存在不在处理
			_, err := os.Stat(fileName)
			if err == nil {
				return errors.New("File does exist.")
			}

			// 创建文件
			f, err := os.Create(fileName)
			if err != nil {
				return err
			}
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
