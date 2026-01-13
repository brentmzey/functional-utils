// Test script to verify signing configuration

val signingKeyId = System.getenv("SIGNING_KEY_ID")
val signingKey = System.getenv("SIGNING_KEY")
val signingPassword = System.getenv("SIGNING_PASSWORD")

println("Checking signing configuration...")
println("SIGNING_KEY_ID present: ${signingKeyId != null && signingKeyId.isNotEmpty()}")
println("SIGNING_KEY present: ${signingKey != null && signingKey.isNotEmpty()}")
println("SIGNING_KEY length: ${signingKey?.length ?: 0}")
println("SIGNING_PASSWORD present: ${signingPassword != null && signingPassword.isNotEmpty()}")

if (signingKeyId != null && signingKey != null && signingPassword != null) {
    println("✅ All signing variables are set")
} else {
    println("❌ Missing signing variables")
}
