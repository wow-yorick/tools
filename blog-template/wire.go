// +build wireinject

package main

import (
	"github.com/google/wire"
	"github.com/urfave/cli/v2"
	"github.com/wow-yorick/tools/blog-template/cmd"
)

var providerSet = wire.NewSet(
	NewCmds,
	cmd.NewTemplateCmd,
	cmd.NewPublishCmd,
	wire.Struct(new(CmdHandler), "*"),
)

func Initialize() cli.Commands {
	panic(wire.Build(providerSet))
}
