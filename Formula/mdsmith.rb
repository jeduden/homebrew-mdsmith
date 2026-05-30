class Mdsmith < Formula
  desc "Fast Markdown linter and formatter with cross-file integrity checks"
  homepage "https://mdsmith.dev"
  version "0.27.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.27.0/mdsmith-darwin-arm64"
      sha256 "2040421b2a098d61b6b833a1904af973931babcbfb19330ff402107b7174e2f8"
    end
    on_intel do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.27.0/mdsmith-darwin-amd64"
      sha256 "87b3a661132c74236ca5eda5d0ecdd577d205fc0443dee2ff01ad6069f41c4d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.27.0/mdsmith-linux-arm64"
      sha256 "8d483827491cf7674f0817a145ae4c7e84ef972d38883911c9f602b9274f9b69"
    end
    on_intel do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.27.0/mdsmith-linux-amd64"
      sha256 "3329edfc0fc019014af3c2a52e5e575f9907e5b5425e0f8aff3b7199e474b3f0"
    end
  end

  def install
    # Each platform block downloads exactly one raw binary; rename
    # whatever was staged to the canonical command name.
    bin.install Dir["*"].first => "mdsmith"
  end

  test do
    assert_match "mdsmith v#{version}", shell_output("#{bin}/mdsmith version")
  end
end
