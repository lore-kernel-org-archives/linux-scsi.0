Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231447;
	b=v3qQ7qOv17klAqUB5dabUnOvExXFBsPaQ9bHje8sKM1SANqYhlaN2V5ldNS1/isniboC
	 hjBBhQ1rhZ2w9HmrUEeZ3aTdhzXN1eNoARUoPdJxkIuHl6zCIygKU2xjOVJZv6WbVO1ew
	 Vei0E91elkDiO4AztfGhk3W9quY/gMuUZ5gWIVGFNC9eztY7v4onTwFA8qLxM676nzLGK
	 in5yG55j+nCatPFwDWAd524U7AuacQ6E70Z04+e33iZ5P8gW7wca94ogCajb9qNKxTSDS
	 0o39rY7Om9vSmLi0MHT4lDDtHhEEEatbR2DKLniy8ayNDKhq+XOqskfauHpPUgmcbwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=M5oQMz3eWRy/XlxHpXatnlnGAT1nSJUv6i3im2SaIOM=;
	b=r6bHCs9/2DSNGHk7rTHdTlNlAOH4oaHli6uNzaownY/oQ5mt1600ohEsb7HKycAy0PuB
	 7fDw3XUS1GN486ukJbd+mHU+hkgVNDgk5nA7vOXreR5BKJ/pN9WIPfeJkhSDur1D11Yrz
	 q1Od5OBIZ34xU/+ZXEqq3pSGZ0Lzyd6COcfmiV8pCG0vU4zl3Ewv7g4klKL1S1yFpXtVZ
	 folQBMN9FwXJtJeZ1hjGda+yWK2ae54LrWd8rUzyx8hyIHgUSU/jzyxO4QtOd4TgemeCp
	 zgaPZf4rLA74XAPaR95qlXPoRrrQ3hViHZVFUyYhdM3BAfOinCGW5Qm/RZsPRqAU4Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cp0iNqbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A48606A69C;
	Sat, 21 Nov 2026 03:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cp0iNqbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D884F1F000C0;
	Sat, 21 Nov 2026 03:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231447;
	bh=M5oQMz3eWRy/XlxHpXatnlnGAT1nSJUv6i3im2SaIOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cp0iNqbQzWYEtYQ0L9H9NfF3jkeAZdDMWUvRRN5j+HxRVtVOjxNV+bSBmqUUf9Kvr
	 1iWAjbJiZFUz+1WrojHIeS+kOk8IdxrVXARjyMqROFDrD4IswyMP0+kbCB4Awe9sVt
	 zwNvBr/WgZWii/Tz75U+lrmEeAjpsu5bdrBsK85NQnsPFQkOkHDfJxcZrorjCeiA73
	 Nb/0KlkbwXA9U6nqIY+nWPCn0X0VNJYcwzW1DIEqJ9ykr3J4u2DGVaFkoYYTbPhTQg
	 qmLfDcdWNvjUgM/Bu8aq3mWamM94/k17qxJrQACbJ7OqLYNsoOJ/x/Q/5OyR16Ockk
	 xaBGIWLOwtk7Q==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Abel Vesa <abelvesa@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Andy Gross <agross@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Andrew Gigena <mail@andrewgigena.dev>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v4 0/3] arm64: dts: qcom: sm8150: Add standalone ICE node for UFS
Date: Fri, 20 Nov 2026 22:23:58 -0500
Message-ID: <179523138191.420037.17319388952000740063.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
References: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 11 Nov 2026 17:53:20 +0000, Andrew Gigena wrote:

> This series adds standalone ICE support to SM8150 (Snapdragon 855),
> matching newer Qualcomm platforms.
> 
> Patch 1 documents the sm8150 ICE compatible.
> Patch 2 moves sm8150-ufshc to the standalone-ICE UFS binding.
> Patch 3 converts the UFS node to use a dedicated ICE node.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[2/3] dt-bindings: ufs: qcom: classify sm8150-ufshc as standalone ICE
      https://git.kernel.org/mkp/scsi/c/08fec21faae4

-- 
Martin K. Petersen
