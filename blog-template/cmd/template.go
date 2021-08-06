package cmd

import (
	"github.com/urfave/cli/v2"
)

type TemplateCmd *cli.Command

var mdArticleTemplate = `
---
title: "{{.Title}}"
date: 2017-08-30T15:43:48+08:00
lastmod: 2017-08-30T15:43:48+08:00
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
			println(ctx.String("title"))
			return nil
		},
	}
}
