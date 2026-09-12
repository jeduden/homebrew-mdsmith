class Mdsmith < Formula
  desc "Fast Markdown linter and formatter with cross-file integrity checks"
  homepage "https://mdsmith.dev"
  version "0.55.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.55.1/mdsmith-darwin-arm64"
      sha256 "78bbf7412431bcc81888bafce2273a9ff15f65ab1c3b3eaa21a47074a83348c7"
    end
    on_intel do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.55.1/mdsmith-darwin-amd64"
      sha256 "cea18ccd0795c959274a173d93e92e1b3c2e6e626650fdb3c66f653611f51df7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.55.1/mdsmith-linux-arm64"
      sha256 "865791e6154afc5a1769c1fd33855e04e6110079e3f181ad0e3a38ff1b4987de"
    end
    on_intel do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.55.1/mdsmith-linux-amd64"
      sha256 "3fe353cdd2318f72b6a5369aab61be224f9ade3af66be5ba62a0628b5f935468"
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
