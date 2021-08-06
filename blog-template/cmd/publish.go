package cmd

import (
	"github.com/urfave/cli/v2"
)

type PublishCmd *cli.Command

func NewPublishCmd() PublishCmd {
	return &cli.Command{
		Name:    "publish",
		Aliases: []string{"pub"},
		Usage:   "发布文章 eg: ./app publish --path=~/sdf.md",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:     "path",
				Aliases:  []string{"p"},
				Usage:    "path eg:~/workspace/sdf.md",
				Required: true,
			},
		},
		Action: func(ctx *cli.Context) error {
			println(ctx.String("path"))
			return nil
		},
	}
}
