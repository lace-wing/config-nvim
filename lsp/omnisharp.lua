return {
	cmd = {
		"omnisharp",
		"-z",
		"--hostPID", tostring(vim.fn.getpid()),
		"--encoding", "utf-8",
		"--languageserver",
		"-v",
		"FormattingOptions:EnableEditorConfigSupport=true",
		"RoslynExtensionsOptions:EnableImportCompletion=true",
	},
	root_dir = vim.fs.root(0, { ".git", ".editorconfig" }),
	capabilities = {
		workspace = {
			workspaceFolders = false,
		},
	},
	settings = {
		csharp = {
			FormattingOptions = {
				EnableEditorConfigSupport = true,
				OrganizeImports = true,
			},
			RoslynExtensionsOptions = {
				EnableAnalyzersSupport = true,
				EnableDecompilationSupport = true,
				InlayHintsOptions = {
					EnableForParameters = true,
					ForLiteralParameters = true,
					ForIndexerParameters = true,
					ForObjectCreationParameters = true,
					ForOtherParameters = true,
					SuppressForParametersThatDifferOnlyBySuffix = true,
					SuppressForParametersThatMatchMethodIntent = true,
					SuppressForParametersThatMatchArgumentName = true,
					EnableForTypes = true,
					ForImplicitVariableTypes = true,
					ForLambdaParameterTypes = true,
					ForImplicitObjectCreation = true
				}
			},
		}
	}
}
