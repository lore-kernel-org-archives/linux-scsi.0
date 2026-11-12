Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794479682;
	b=o/StsA+gqzz76xRMx18YrRaeHxjwnFNEeQ+DHfchzkgCssPotz5dNUCX5Fm2yMUYvTZp
	 7j8earlqcOzSDRx8MeTJQ2gRrz9Nv8zY2ktBpK9XFmI6Rqeb22poEbMK9qzLPCey7mlD9
	 NLexLVTD/1PC3UHY9z1ohPVsqD0XUyVIUz4t1UZqvCtZjGM6UjULdembLKIaS8+nbhsZw
	 vp/ilMIQZpKg0p+0OlZbV7lKKqmFfihWQw+uUx4lO/J6mKcjFaxcNNU+hYP9ll5v6cN3a
	 GU1r1JWFrSuZ54gh/xCIw1rY6fRf46XGgu2JWf5YDc+rBynHt5sfkWVjv5O8dyymMYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794479682;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ohpgN4+opjQnDjtSL+kSbaAiIz3YlR71cEfTblcDyGU=;
	b=bvmHMRp9/zZIsxT+whx12bHIP8wgPPHyRU6WxTEjSjnJLYJa6EufRZJOIDKA4ei14uvU
	 YZXpXw8jUxjcSwTBOMvB3sqTkfW9i2Kj0Klvf8oJxvTlfhLbXpMSLGpYknsz83ZVUJknI
	 6RxolY7LvUNgROP9x1DyoKCwgkw2RiEWTFIWyubXZ12i4MA2OgZ5nKp2fH9n0AQabGVg8
	 sOnR6rb3FOGNlhvqZqjCfwYeFCUYjYexrSBFBrH8cR0zMbNIfTQiZVy2J1r9YL4v9Izeb
	 Xa91Xp9aSI9igjX2JIjgJo4qpW0J10CQsQHSy32OdZJh+K4e9HUEOALxuOSKe25Xm4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CFue/G6q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60C1606A8A2;
	Thu, 12 Nov 2026 10:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFue/G6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D341F00A0A;
	Thu, 12 Nov 2026 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479682;
	bh=ohpgN4+opjQnDjtSL+kSbaAiIz3YlR71cEfTblcDyGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CFue/G6qToiYisnJ2e7yHgTPAbFFrs3f44e30ZRaYC6j16j7W1ZiN6889CpRNh1Fh
	 jf4kw23HgdylMc88ZHQZm0Qidvuka+7yVN7A92p/WRsq7Z4LtxKy94sjriWom+xyTz
	 X5uFbF7wNUMY/aZo8YbKEuj3lWnvglC+Mf+wJykuCb0IF0sAHWeHoUhvtohCv99GHV
	 hCWKacLrtmwMIyF82MAj2Sop1CABqraBTFH3036Ps5eoqZRBy5pctjO/7GdJ1CqMFI
	 xUo4TVAixgX2011W+Bfmyj2FRLND7NUHMb7WSBUeoaLqr2qSV/r7NMRlrPYfEQtVsR
	 LmI/VaY3ymWOQ==
Date: Thu, 12 Nov 2026 11:34:39 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Andrew Gigena <mail@andrewgigena.dev>
Cc: Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 2/3] dt-bindings: ufs: qcom: classify sm8150-ufshc as
 standalone ICE
Message-ID: <20261112-cautious-crimson-lyrebird-1ea53a@quoll>
References: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
 <20261111-sm8150-ice-rfc-v4-2-0311eac35609@andrewgigena.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261111-sm8150-ice-rfc-v4-2-0311eac35609@andrewgigena.dev>

On Wed, Nov 11, 2026 at 05:53:22PM +0000, Andrew Gigena wrote:
> SM8150 UFS uses a standalone ICE node, so its compatible belongs to the
> standalone-ICE binding rather than the embedded-ICE one.
> 
> This tightens the schema for qcom,sm8150-ufshc: the standalone-ICE
> binding allows one reg entry and eight clocks, while existing DTs
> still use the embedded-ICE layout. This causes a transient,
> validation-only dtbs_check warning until those DTs are converted
> (sm8150.dtsi follows in the next patch); existing DTBs still boot.
> 
> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |  2 ++
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml          | 11 ++++-------
>  2 files changed, 6 insertions(+), 7 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

