Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794370674;
	b=RB4T3X5ulnTGIC1Lh+QwDC5Bbqwz6Q47wZdgEOPKm//xhvZ4cgdaDOOeebkF3Q3uJ2XH
	 5/fksyxejEiCl6fvIi4N2vLsWjZU5XXRzrA3uoydgb1x2TSHKnKDGu6erol9I++NIGP2u
	 rDJuhSNDomDkh9zsl/gUsZFe1hdvmnNxqcfO0ERzM7ClbowAxO4oZkr+mqnPdnleRoJav
	 p42NDVtLELjX9oKRS6VPaQbcF3ZF8BMX4pCRzM/owEzG4Asl9uwyLKSMABGKNdnhchD+x
	 4EjJznBAIxaDI1DSFG9FJCpB8HjQqdaQ060xM7I+Anvt53Yl8G7g5Hmx+obCc63m2CA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794370674;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=/cR59Yv29TsITGNcRsgyr2aLZ2L/PtbwWYrD5Ot77ME=;
	b=ivZQoWpo6hSXjEMaYay0bJ6SC+Y9aZ6ie2QZLdxzgBC0/qG5J04ac8TjHoRCnCKv7i2B
	 RIm289aKUrkdaTXtllO7VX5liLcxMvwMKGsRV5vC2zTVAB8LmTUuFXHMLeCXu/s/WRnF5
	 5sXpgkQYobUPa4PkY3ljBXzIlGxy0l0jnv3tXw/GBOewzo496w9vQ1KrEmsku1BnW1qSZ
	 4IL+bBQKTy5Q03eqWm3IGcSfyBNei4DVl5lL3CmrJn4XdveAM+srCrvXzHYtyR03OQgHD
	 wtLC4hGuqzgHKn+AI2wE4KMEitJZ+A8mBCIho9JLA88LxwFql2SVKT6TOgFIVKHhTdQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VccpjWd4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F465606A32A;
	Wed, 11 Nov 2026 04:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VccpjWd4
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794370674;
	b=gjvFXW4+fFnMeeOgUTxm0DoEbNDACa7X3hcEHmA9XK4X9wD6SeR50ujrJHi+3hc8/+jd
	 0eEG4bVOhDd0ATq8dHNdph8bkONyqmz1Cw1emJ9I7p7UDNo1rjnW9Q3R8B4KWpAAJgM18
	 C6R/qxoJ3HJsD6oj6m0DuQk93q1sY+XZ+hmYAZdW2V4R+OlhGCebi4vAZdgBOfsoHbjSi
	 KOG3c7YWTHCSD2MiliAuClwExceHBktAyAsU0UkvFUEnHwMDU39N/TTy5KE/qCVTF+7k1
	 7gID38aAIDeGin17oOAknPZJNz/q8i54n/y1d0btALW9R9ne9OTUvye7nk8HmtVHgJA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794370674;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=/cR59Yv29TsITGNcRsgyr2aLZ2L/PtbwWYrD5Ot77ME=;
	b=BddVZYmztkAGUArZSS90QhrohzHf8zk1sPRsK4l8TkWybDPweRE9GvwU+dl1klV6YXSD
	 96tjDl+mczEWvyqTpNQ6PeTnPr3AXOUBAU36WXGA3MIOsyzAYKElk9e13d9rVFr+4ghvk
	 zuhXOk3yLEaE+bGT74dO6DSAenwKymUwz3QeMtiJcnCI+NYS4ypMJ5ngCRmns2VTGF9c/
	 HJsBsIN72NMykFMadSrzF91jBAIVf4vFp0GPuWejq7I7iBx2WT/zaEmvvOtxVEMzzVaDX
	 JILtQDxuluaejDTh3NLc9w+EfhcEprAGVAkTjNnzW6pqo/ztbfaKl8X4J08caZxl5Vw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1FC771F0089F;
	Wed, 11 Nov 2026 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794370674;
	bh=/cR59Yv29TsITGNcRsgyr2aLZ2L/PtbwWYrD5Ot77ME=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=VccpjWd4uqGuWEr762LfiwnbUnyI3BKr/SuYeOLL9rDAlCzaY4jWxnLHpUz7U57Kb
	 R5ATyWnUjDTDzywpu9mrRhNCHJMWtaSwnTis1rAbsdjecTFuotyBPY/ddKldkPX49x
	 ZQkBkapzX5b4We0lcn8p6b1Epq8WtdGz8VZkmn/bwGr/tBc4BTUwXpygDAAJ5t8r0e
	 SHUxzl6VAnov1lWcWVC0R960TzdrPUmANmnVS3urBaM0RqpkOQRT46wRM7N7vD1lBj
	 TNj4bDMTEQ7sCImVaWtxTUVgcl7H35AYWXhOtCkQxUKnIdd+a8VCZBHNsANIXcvWG5
	 ddjz9s+AP7gqg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 72CBB48D74;
	Wed, 11 Nov 2026 04:17:52 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Subject: [PATCH v3 0/3] arm64: dts: qcom: sm8150: Add standalone ICE node
 for UFS
Date: Wed, 11 Nov 2026 04:17:48 +0000
Message-Id: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33NzQ7CIBAE4FcxnMUs9IfqyfcwHsqybTGRGqioa
 fruQr2qx0lmvplZIG8psMNmZp6iDXZ0KRTbDcOhdT1xa1JmEmQtBJQ8XBtRAbdI3HfIQZdaIhQ
 VNcDS6Oaps88VPJ0/Odz1hXDKSm4MNkyjf62PUeTeTzwKDrxShdI1SkKEY+uMp0dve3LtzlBk+
 SPK/4pMiqn3SmskkKr5oizL8gZT9hPeCwEAAA==
X-Change-ID: 20261104-sm8150-ice-rfc-0b4b2c035e80
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794370671; l=1616;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=NHGynmgOiipnILRN3zymO9/V/g0czzvFXIX8dUVTA7I=;
 b=EobBK5mlbAGMRTZuxz4hOl8C39fcDlZ4QOSoLYV0HNQre/Zg1i9DwCqxNZ5pjw0hp5SqaGOeC
 9OWrgWkOK7tBbpHuOXLqPlQLLuYUMG3ZS5NFUZ56ouzykTgCnAYUWm+
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev

Hi everyone,

This series adds standalone ICE support to SM8150 (Snapdragon 855),
matching newer Qualcomm platforms.

Patch 1 documents the sm8150 ICE compatible.
Patch 2 moves sm8150-ufshc to the standalone-ICE UFS binding.
Patch 3 converts the UFS node to use a dedicated ICE node.

Tested on a Google Pixel 4 (google-flame): AES-256-XTS advertised,
ext4 encryption supported, ICE self-test passes.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>

Changes in v3:
- Split bindings into two commits (compatible + standalone-ICE move).
- Drop author Tested-by from DTS patch.
- Link to v2: https://patch.msgid.link/20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev

Changes in v2:
- Move sm8150-ufshc to the standalone-ICE binding.
- Keep the ICE compatible sorted.
- Link to v1: https://patch.msgid.link/20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev

---
Andrew Gigena (3):
      dt-bindings: crypto: ice: document sm8150 compatible
      dt-bindings: ufs: qcom: classify sm8150-ufshc as standalone ICE
      arm64: dts: qcom: sm8150: use standalone ICE for UFS

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |  2 ++
 .../devicetree/bindings/ufs/qcom,ufs.yaml          | 11 ++++------
 arch/arm64/boot/dts/qcom/sm8150.dtsi               | 25 ++++++++++++++--------
 4 files changed, 23 insertions(+), 16 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261104-sm8150-ice-rfc-0b4b2c035e80

Best regards,
--  
Andrew Gigena <mail@andrewgigena.dev>


