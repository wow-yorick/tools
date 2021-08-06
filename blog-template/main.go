package main

import (
	"log"
	"os"

	"github.com/urfave/cli/v2"
	"github.com/wow-yorick/tools/blog-template/cmd"
)

// var (
// 	artPath string
// )
//
// func init() {
// 	flag.StringVar(&artPath, "path", "", "the article file path")
//
// 	flag.Parse()
// 	if artPath == "" {
// 		log.Fatal("文章路径不能为空")
// 	}
// 	_, err := os.Stat(artPath)
// 	if err != nil {
// 		log.Fatal(err)
// 	}
//
// 	file, err := os.Open(artPath)
// 	if err != nil {
// 		log.Fatal(err)
// 	}
// 	_, err = ioutil.ReadAll(file)
// 	if err != nil {
// 		log.Fatal(err)
// 	}
// }

type CmdHandler struct {
	TpCmd  cmd.TemplateCmd
	pshCmd cmd.PublishCmd
}

func NewCmds(h CmdHandler) cli.Commands {
	cs := make([]*cli.Command, 0)
	cs = append(cs, h.TpCmd)
	cs = append(cs, h.pshCmd)
	return cs
}

func main() {
	app := cli.NewApp()
	app.Version = "v0.0.1"
	app.Copyright = "(c) SOLID-10"
	app.Writer = os.Stdout
	cli.ErrWriter = os.Stdout
	app.After = func(context *cli.Context) error {
		return nil
	}
	app.Commands = Initialize()
	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}
}
