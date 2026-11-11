Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794371724;
	b=bjyBNtC1UknCshrob84PevOwpghWMjYJ9ZgZedIKFbzh1lACn9S5+BbHLvuEhvGkk4XI
	 fjFNs4RPyJ6dcTc7hTX00c6eavprnjOwKKDksycbwlg+PxGrUSTOPwSxFRK5bV83Uavxg
	 Nt8/HPkhdamVJO6H6Xv2CZlxGsDCyBqU/XYk8UBXZBaO90lw3X6zikW5DJEF2ay01ntx7
	 LsFQfdx+wkzXnC8IY/WINbjCInYTJAMLEmw3Rf6+lhSwFPL5TQbyKaO0K3Ep3SrctVut4
	 oX85scQXFmTwseM6WsKnEVjCICrCBlqORDVEboW/0X7jo+ksFf4N6MJyaDoPW4jjN7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794371724;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aqhm8xM2X96PqIZ9tqXE+P+Q89EVeGW8jdqalCMQXBo=;
	b=w2MPa3t3y6wNDsvY5ipjpJ6wXvT4SVpe8gOjXH2AAxxqNgfl9NeHDOPZFQ/BWrLI/x8l
	 5RQBN6qa1QvcSHzHKubfiuh6wm0i7Lr0M5Bfo7ErNldGSPiW1tBvWAH1uuRtUWCTQu4y6
	 LKFpcP/Th+VLlcmOqAjLEoeWVRzw4NsT/dO/h5bYGLTvIRW0B0REJU6uZxkEXWOmUn7WV
	 8nQyoPFSgVMIj9aXFi+mjRMQpSGA/awJePFs0+tCJUSro2c9nWtadMj3BsoYaNkZQlSAv
	 rck1usnMNuYDVBZDljMrekppRmgXFDpCo226hA46JdM7ywsuY8ngwtf7BZi88oN3hxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1jQgEio;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D40F606A31C;
	Wed, 11 Nov 2026 04:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1jQgEio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60021F0089F;
	Wed, 11 Nov 2026 04:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794371723;
	bh=aqhm8xM2X96PqIZ9tqXE+P+Q89EVeGW8jdqalCMQXBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B1jQgEioZO6F0Zq8tMe/+Sax/zKz9Msn6hHOez2aNiPqsj9FIGmmSkVHv3/+yC6t0
	 j2C8A6gsmx48q20hqGLau+6Tj4qGPTBQqKCiXYDiR2ES4mDYukpV3v2aEBmxpvsRT3
	 8+2XYzSu86hgHGUJGA701VYhQCcpM4nBubhRtuFrzA8zLUjJbu/K5kI72ysUlBqy3b
	 EC7JzmQSXxqUeGWWFiLYJ4WowCnw/oAQXq+5BfNvocRps/pFbm9ngHGyxTqsQVIaNq
	 0yHolvsdjij0FHD+Z4STOOL1PoZ1f4jHsFbxOKY9381ChnDM/t07Ulcs1KTncEywes
	 p/nLLa+mQWF/w==
Message-ID: <sashiko-outbox-208298@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] dt-bindings: ufs: qcom: classify sm8150-ufshc as
 standalone ICE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Gigena" <mail@andrewgigena.dev>, "Abel Vesa" <abelvesa@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Manivannan Sadhasivam" <mani@kernel.org>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, "Bart Van Assche" <bvanassche@acm.org>, "Bean
 Huo" <beanhuo@micron.com>, "Stanley Jhu" <stanleyjhu@google.com>, "Bjorn
 Andersson" <andersson@kernel.org>, "Andy Gross" <agross@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261111-sm8150-ice-rfc-v3-2-f9d5a806fc95@andrewgigena.dev>
References: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
 <20261111-sm8150-ice-rfc-v3-2-f9d5a806fc95@andrewgigena.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 04:35:22 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] dt-bindings: ufs: qcom: moving sm8150-ufshc breaks existing
  2-reg/9-clock DTs
--

commit 830241ce50cfd60c40fb1ab69965eff9ecfda73c
Author: Andrew Gigena <mail@andrewgigena.dev>

dt-bindings: ufs: qcom: classify sm8150-ufshc as standalone ICE

This commit moves the qcom,sm8150-ufshc compatible from
Documentation/devicetree/bindings/ufs/qcom,ufs.yaml to
Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml and updates
the example in qcom,ufs.yaml to use qcom,sdm845-ufshc.

> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml=
 b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> index 3c407426d6972..572eec814a604 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> @@ -23,6 +23,7 @@ select:
>            - qcom,sc7280-ufshc
>            - qcom,sc8180x-ufshc
>            - qcom,sc8280xp-ufshc
> +          - qcom,sm8150-ufshc
>            - qcom,sm8250-ufshc
>            - qcom,sm8350-ufshc
>            - qcom,sm8450-ufshc
> @@ -48,6 +49,7 @@ properties:
>                - qcom,sc7280-ufshc
>                - qcom,sc8180x-ufshc
>                - qcom,sc8280xp-ufshc
> +              - qcom,sm8150-ufshc
>                - qcom,sm8250-ufshc
>                - qcom,sm8350-ufshc
>                - qcom,sm8450-ufshc

[Severity: Medium]
As reported by Krzysztof Kozlowski on v2 [1], does moving
qcom,sm8150-ufshc to qcom,sc7180-ufshc.yaml break dtbs_check for existing
SM8150 and SA8155P device trees?

qcom,sc7180-ufshc.yaml restricts reg to maxItems: 1 and clocks to
maxItems: 8, rejecting the second ice register region and the ninth
ice_core_clk clock used by the embedded-ICE representation (supported
since 462c5c0aa798 ("dt-bindings: ufs: qcom,ufs: convert to dtschema")).
Later commit "arm64: dts: qcom: sm8150: use standalone ICE for UFS" in
this series converts the in-tree sm8150.dtsi to use a standalone ICE node,
but dtbs_check fails at this commit (and across subsystem trees if UFS
bindings and QCOM DTS changes are merged separately) and schema backwards
compatibility with existing 2-reg/9-clock DTBs is broken.

[1] https://lore.kernel.org/r/20261106-offbeat-hawk-of-purring-50a8aa@quoll

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-sm8150-ice=
-rfc-v3-0-f9d5a806fc95@andrewgigena.dev?part=3D2
