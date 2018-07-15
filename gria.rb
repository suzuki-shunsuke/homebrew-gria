# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Gria < Formula
  @@repo = "suzuki-shunsuke/gria"
  def self.parse_checksum(c)
    for line in c.split("\n") do
      k = line.slice(0, 64)
      v = line.slice(66..-1)
      if v.include?("darwin")
        return k
      end
    end
    raise "checksum is not found: #{c}"
  end

  def self.get_sha256
    if @sha256.nil?
      u = "https://github.com/#{@@repo}/releases/download/v#{version}/gria_#{version}_checksums.txt"
      @sha256 = parse_checksum(`curl -L -s #{u}`)
    end
    @sha256
  end

  def self.latest
    if @latest.nil?
      json = JSON.parse(`curl -L -s "https://api.github.com/repos/#{@@repo}/releases/latest"`)
      if json['message'] =~ /API rate limit exceeded/
        raise json['message']
      end

      if !json.key?('assets')
        raise "Could not find any assets"
      end
      @latest = json
    end
    @latest
  end

  def self.get_version
    if version.nil?
      return latest['name'].sub(/^v/, "")
    end
    version.sub(/^v/, "")
  end

  def install
    bin.install "gria"
  end

  def self.init
    desc "CLI tool for golang's test code scaffolding"
    homepage "https://github.com/#{@@repo}"
    version get_version
    url "https://github.com/#{@@repo}/releases/download/v#{version}/gria_#{version}_darwin_amd64.tar.gz"
    sha256 get_sha256
  end
  init
end
