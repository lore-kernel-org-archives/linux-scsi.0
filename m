Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975017;
	b=mMDKHNEMQN3Mw/ORBzLMbliwrO8i/GR4n1HqbirAHlJQXUesgHwqwKQ81bTnwAm1Q0S4
	 KYTeMnDVaaMOA/wloaXfrPiTdm6rn+yPoJngeHIMhwLR1UNCXreh+q1Wqhwh+UzBP1xCB
	 USSyoVUCj0ir6ROKNY7TaTIuS/1FfIpMYJJKOxDinZNBwHBCV2CC2tOi62ovMguqXeoDp
	 jyCjWYO/F2OMxp5ofRmrWNUcCHnrkW/mn1YaHhgv4u7tUqSOYpB9TD2Tr8RQceGMwjUxV
	 L90LhTqygvPACMsBQ2ekoAO2QAV9J02F23dx+y6DkLMmpS9b0J/VfELRtqn4LdneVOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975017;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=IuVBrJy3IT9uGscS88OHXyn0c9PxaMdAypLaDZCyPiQ=;
	b=3AG2O1LPA0ShFoDANPX1s84RUdZHl/NNir5zHSsPAK57+S1W08FlQVoZbxlTbF63DnHy
	 +xVSLz5FWB25St2IL1KevBQHlCOcf+jnCVZhSF142soE7KG+GVMQ2iLy+QmshlvX0x70f
	 1P+QXSoeVYiUFs17LBuTbYU6hJRHhtqSoweGYtE6f2i7Hs0GKKHzsrVDO2X54ULxZvSAf
	 ynPVueZLTOD0j0imM1DMdjkrMZrzysEIw42vVC5ogfb9MOZsblNHItwYmO5hTUOlWk44f
	 gLIShyKtZOjiDtlpOuhOhC1+XePslOjahz4XgXRW1a4t1GfN6LDnbUe6U/1CMf8aEvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OkjmENBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2572F606A31C;
	Wed, 18 Nov 2026 04:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OkjmENBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0501F000C4;
	Wed, 18 Nov 2026 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794975016;
	bh=IuVBrJy3IT9uGscS88OHXyn0c9PxaMdAypLaDZCyPiQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=OkjmENBCcxWY/6zKwEp/3tzin90bgfBVNIpxl8afMQCUR3QQe+4/o2ZmzYHisP+F7
	 zX9P5pnbXIDXiygqECj93faHPyjsdYRfg2G7Nx6pqaDkkbkmFoFhBKFLjhSrE8c8Ud
	 xPEs/1Trjs/YQKpmZasnRI6/8a7gTPBGpqKVOFud2Cs7BbG0zTOnBV8NwVD+beXwkq
	 xhpsaXcnsXpYLHP44FeR6M0INDIxvfW+C1C/nR2748JdATxm0mG2Vus0Cj4L6P4iIg
	 HJTS7UrgwADDUZD9HmpDJYcQtl2mza8elB66qgdqfkZ4hhb9F5BOxb6zzx+A4yZbrp
	 GtL/V+0wcoarg==
To: mail@andrewgigena.dev
Cc: Abel Vesa <abelvesa@kernel.org>,  Herbert Xu
 <herbert@gondor.apana.org.au>,  "David S. Miller" <davem@davemloft.net>,
  Rob Herring <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,
  Conor Dooley <conor+dt@kernel.org>,  Manivannan Sadhasivam
 <mani@kernel.org>,  Alim Akhtar <alim.akhtar@samsung.com>,  Bart Van
 Assche <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>,  Stanley Jhu
 <stanleyjhu@google.com>,  Bjorn Andersson <andersson@kernel.org>,  Andy
 Gross <agross@kernel.org>,  Konrad Dybcio <konradybcio@kernel.org>,
  linux-arm-msm@vger.kernel.org,  linux-crypto@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 2/3] dt-bindings: ufs: qcom: classify sm8150-ufshc as
 standalone ICE
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261111-sm8150-ice-rfc-v4-2-0311eac35609@andrewgigena.dev>
Message-ID: <yq1h5hesru0.fsf@mail.kernel.org>
References: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
	<20261111-sm8150-ice-rfc-v4-2-0311eac35609@andrewgigena.dev>
Date: Tue, 17 Nov 2026 23:10:15 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Andrew,

> SM8150 UFS uses a standalone ICE node, so its compatible belongs to
> the standalone-ICE binding rather than the embedded-ICE one.
>
> This tightens the schema for qcom,sm8150-ufshc: the standalone-ICE
> binding allows one reg entry and eight clocks, while existing DTs
> still use the embedded-ICE layout. This causes a transient,
> validation-only dtbs_check warning until those DTs are converted
> (sm8150.dtsi follows in the next patch); existing DTBs still boot.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
