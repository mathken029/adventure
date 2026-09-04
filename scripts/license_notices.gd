class_name LicenseNotices
extends RefCounted

const GUT_NOTICE := "GUT (Godot Unit Test)\nCopyright (c) 2018 Tom \"Butch\" Wesley\nLicense: MIT"
const UNITYROOM_NOTICE := "unityroom SDK for Godot\nCopyright (c) 2026 Yusuke Nakada\nLicense: MIT"
const KOSUGI_MARU_NOTICE := "Kosugi Maru (フォント)\nThe Kosugi Maru Project Authors\nLicense: Apache License 2.0"

const MIT_BODY := "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, subject to including the above copyright notice and this permission notice in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND."


static func full_text() -> String:
	return "%s\n\n%s\n\n%s\n\n---\n%s" % [GUT_NOTICE, UNITYROOM_NOTICE, KOSUGI_MARU_NOTICE, MIT_BODY]
