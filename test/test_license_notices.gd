extends GutTest


func test_full_text_mentions_gut() -> void:
	assert_string_contains(LicenseNotices.full_text(), "GUT")


func test_full_text_mentions_unityroom() -> void:
	assert_string_contains(LicenseNotices.full_text(), "unityroom")


func test_full_text_mentions_mit() -> void:
	assert_string_contains(LicenseNotices.full_text(), "MIT")


func test_full_text_mentions_kosugi_maru() -> void:
	assert_string_contains(LicenseNotices.full_text(), "Kosugi Maru")
