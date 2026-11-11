Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794370674;
	b=3Tc0kq++tRojUY3Syn0u6+vsrIzDRt58X/9MGsPhtmMAKC0UMaGTZLGnsqp7+wjXakwe
	 hlirEJPZXWfxuxFuvhwAjG1HEX5XcMaw2liPQjK06UTQhQUdyaWRUN5UzadAefmphExNP
	 UMlFdFjTWfFRxugM7XWoN1HGwn+rbw7zFVzsTdM8hTTO7v0QTPpzi3JaTxuG/kuYXbZww
	 obk8X/QH/k1UnUkOe+oX5d1/8pvjaybMO7DNl64MPUGkD2W05Z0yqgQzag0mAxGwG32fP
	 FpAeOCke+6Q3gQueJq1JTyxwakeSu/gNu+cX17OkD77o65HkCaw4r9wJTJ4Yswpa4Mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794370674;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NZhZC6HQSe7OjY4J2KWMsqkj/aPZyobgiC5sniceWsw=;
	b=zsWk68vtBVAi2JR6IxcbuuzDn6eiDTNgbtEMJvV2IjEej/slMPFqwswrWY5hxB/euCr1
	 AH1rSJu6ZnaR1FT2CpjG2e71Nf/CfviB8o6beKp16xCM6/yqVYRDDOT8t4Whv9pi11FQR
	 EBdWquuERFrRcUQAsotzTBcKX5K/Ae94sNwPQOg6tLG/26cXNN38BAYar19hoNAn3qOUQ
	 oCc0PFGcIyArXGJ1aGQ1gYzFHVF87DuiIjIopBTjDLQ6ba9FlXSQrX+hqeKdDq89b/r46
	 Sp9wRWWH6vMk5QVH0OeNVEZiAmUOqj6NH77DykEoodgy0wPfRwlW267kc/VES/6EgiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVveG9K3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B14606A31C;
	Wed, 11 Nov 2026 04:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVveG9K3
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794370673;
	b=zttvMh0S60ylQ7qv9IfBX9XcR4v2RApmVUHfjMBnjO/dB4NOYvF4NP3mOci3rRM0iGOh
	 k3zRqN1bC2oBdABa3RsrWF349WpVFz9Kg7z/X+ytHwC4cLQ2htDTOuvodxZLodXyOMl+Z
	 /0RXLwWE19+NTYbrq6tWfcaw66LWaumcr79bpjpZz3JQgtMdcvbdxPyG2AJOgQo53d2An
	 haRZ8GwG7c2Hg6pGtFDmlpKiuJ5c/qd7s3Nh5jAj9ED2QO0VaEPBoX32bpwNmS67CQWOD
	 wDy886ks+slP67Zg/kEaH2ZrNAPl631YCJGEBsaHupox7AWSm2J7CZc45pd1nazcnJQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794370673;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NZhZC6HQSe7OjY4J2KWMsqkj/aPZyobgiC5sniceWsw=;
	b=3etvGsfak+jIyc9cTFvlOl+3ZzWuDeIdcVQy//ILyB7fO74iLus/z583BtKwFTddznRp
	 B1YJUQiqhoYDu9zlgpB5aWiahIydIbMDW+Gxa7nwf6bK0VjQ4anenQFH0mpCqRO/qFnR7
	 zv2g05RCXkdao8NxBbFKaq5E8lh1K2qSFdqiM7VWZJQ0DViXPLUvxOZ2J13pX6tKEYtL+
	 5juiJVuT16CG6QYWAgkWpbtXfEhk4iNiGGwuiqCXKKFVkBMDe9ciBail30RMwDfp97MmR
	 XFsGG3gV3F2zsxmLn3xVcWEXjNOeVSFximvZYD+60ul3K1ibCMCEOEbvR/DfBlxnQ4g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1FDE01F00A00;
	Wed, 11 Nov 2026 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794370673;
	bh=NZhZC6HQSe7OjY4J2KWMsqkj/aPZyobgiC5sniceWsw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gVveG9K3mjJUzp9wOya+2tkwGKLn9lJLUD+ID24qNx1GqbtoVUriKh+eXvPGvMjCd
	 2IHqIM3uMrGEwOfY66EAgDRkGvyQxKcYGiUl/5LJBZIY8vA0uELplegp0wRJIHM8ge
	 dslvNZE6d2D+2xVJpED4EVLKSLgWorMtWjppFzekEZdLy9ZVHiM4vtXUTsC1mrSWzL
	 twZUinAAiq0B9qmPMEDN/UanZJ2wC7h9ECehiK1xmRVNlhqnwLro1k/i80N2lHzag1
	 w6jaGtf4VYhnMDUk0lTugRKpW4G/hTNxgMKILL+IHnCjOW8vvEBjp5CXHkezTX2eLj
	 0GgJxAvqjInlg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 88D1F48D70;
	Wed, 11 Nov 2026 04:17:52 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 11 Nov 2026 04:17:49 +0000
Subject: [PATCH v3 1/3] dt-bindings: crypto: ice: document sm8150
 compatible
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
Message-Id: <20261111-sm8150-ice-rfc-v3-1-f9d5a806fc95@andrewgigena.dev>
References: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
In-Reply-To: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, Andrew Gigena <mail@andrewgigena.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794370671; l=980;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=TylC11tIr/olBjevmtNzWVdD5KAHWrG8qL4HP0giPGg=;
 b=HnTG05fK7rGw4JWnwvMA4kDUL569dPxGokrF4fewhAzXmJ5JXR6RyMLSZ/O3xQ0MWTVy4ECWS
 Y54Xt6btNroCILGFMj/isZUUn9wSvdk456F2qlD2m1PBw1Hcjahdn3T
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

SM8150 uses a standalone ICE node, so its compatible must be listed.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b9fa..0d73e4581e6e 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -24,6 +24,7 @@ properties:
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
           - qcom,shikra-inline-crypto-engine
+          - qcom,sm8150-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine

-- 
2.56.0


