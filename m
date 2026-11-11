Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794419698;
	b=1wzSHEnfXk7E44t0r8zvx9vDV2sYjXaR7iqaLZcefBGDI//H4qxgGTWIrGXiwgkiX4Ih
	 tcuORMF2/CT0aarKqb6pMU6rLQhxALDk0YuuvqedgCdzjE9kT020b19tQcuWVKxHiBoBP
	 5sk3GIHdRPBv3fppk8yyRnTyq744IXXHAn6ne3szYR0pQZr3HjzG43OgO+nAXuVgI/QCm
	 YBrUe5DN2r1MaAXvHvS61CCGliisXymlDkgJqCPPUe8RKRN2bcBSigxGZWIF/B/DOMfv1
	 SzR0ewJoTttRQL2nD8N2CDZ6/WZPjxda9d1YFX34eyI2eWr7Y9RzUY2vgC8gUQrPeIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419698;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PNZei3yoQWs+8pT1lTL39cPsBzqmgIF8XPSXrOQLp+A=;
	b=4mupC5o0bVz5dnY9ufoGLb2Em5Nti1ZMpw93nDHo9UqX5M1J40jH+RJZ4R3doUsjDKXh
	 0Zxjcv+TcFyBJZbY/c/v1Q9oZ2wuv9DntJFEKBSx7jojLDfTO/sy4ezZV7mx2gexoH8DI
	 93pOMXaDKtc3Tdx2yqQW88EVWq7b+IKhuI6NW7W+OpUGGs5T5SKDeFbTLKL3B/MEEscmp
	 zT70+YMGD9IlckocUQ3upjTCRpE3anOWZ7aKCwE8bSB1ixFJ+J3VJGFucaeEM9hAgbTHA
	 MiVmZgHs/lD0v2Dcf09J6zfm9+6lMuDriIUkc6qF5EndcInim4dmLLWGzYHSIEbSUiA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="B9N5St/0";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63519606A332;
	Wed, 11 Nov 2026 17:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9N5St/0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794419698;
	b=19HhjKG9T8tXF7NUBgb5kRlJ2MweJWCoPmuzWyRZdqrT+7c8zGiYMxTRjLYcmKq5jqz+
	 m9fXTioM9YcBzdzTjDxO9Le7tUCJFodP/gh1FAdZDyCsupPmVzjuf2yGmYlcst7GbIONi
	 +6ZoZ/NlTJsDmeOVNtyK5lRZd2028S/X0T1VbSmEzn8usVkmXezWmj94DWX3q0ntqN1/M
	 qYRixm4rPAokWv7/XZqniRV1tTJ8jiRD+ylJOUtJHkrXtZTI03RBdkHj3G9qWdM1XlHLh
	 vypWPURL+6R3YcSubOW8cE1qUwNqqGm7Kxt5qE/KvSsZpvlkPEdoQoqaD6Ba/nX+S5Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794419698;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PNZei3yoQWs+8pT1lTL39cPsBzqmgIF8XPSXrOQLp+A=;
	b=RL01omgYQ1lW90j9JVP0dZS5zJVS/pZu+e9olW0tQSvdYmrNa1g2z2oWvKhQBqX8NknR
	 lj7buI+MAki7qYAX9/tcmQU8hDZ6ifRMx499+GHzrhRjepItohCqZw9pcBH+rjBE0RmMg
	 F6I5QRnkINenOvSmRvxDj8rtTCzuER62HL+AEavwQ/5p01I0pAP16gnIZ2bFqkU5R8OWb
	 pxOPb7hrAol1VO9DBnShORNbc1GzmgIDohy1K9PAhWJPZLu0Brj+JlA1BRTAdQ90gXeHj
	 bk5DzZ5upqsVLN3uaeshMBFQlEjovP5oNRS3g5VOFOuPXH62msxwJL/c+3p5UGN5v6Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 787C21F00A06;
	Wed, 11 Nov 2026 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794419698;
	bh=PNZei3yoQWs+8pT1lTL39cPsBzqmgIF8XPSXrOQLp+A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=B9N5St/03ujvuuRujfmjPWJVNFZuruCGs2GFc5xxNUxJPh3pwGWh5h2YzlDkacWdd
	 hK7G1vqAEDTuuRfME+uveTLQvLt8bv2qCNYM8QTHUQM+jQwDfJyHWVw00IRFQ/iiBj
	 uJ6r6qjCkW3Lhmu2SoQlAP43ayf05oXDRpBAvp6HAYZET68HMEQy9l07+H+J0fMHUL
	 z8dBPgTaTVRd1/ga3K915V4MUQcbw5oW2/3NrdZUO7nA8noVagkJ2SYj75cNMW17d2
	 EpPf18BdCVvGtqTc69X/qzsgtBC5gqrlzAXPdCiFwmaHQmNsxt036M5oB876CyKrln
	 wIjmAflMSlKnw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F153249076;
	Wed, 11 Nov 2026 17:54:56 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 11 Nov 2026 17:53:21 +0000
Subject: [PATCH v4 1/3] dt-bindings: crypto: ice: document sm8150
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
Message-Id: <20261111-sm8150-ice-rfc-v4-1-0311eac35609@andrewgigena.dev>
References: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
In-Reply-To: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
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
 linux-scsi@vger.kernel.org, Andrew Gigena <mail@andrewgigena.dev>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419696; l=1053;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=AZyQa1xPjB5Gxi3pBSVqotBeeabkfFnGEnkOG7wcOK8=;
 b=4uPPTIRqeMpSFoVpWeElmYVc6SgePfgPkOA129L7lfEDmGkeOdycv6NTEheXUtRPpBQqJbhA0
 eedXHFEaXzwDG4pOv3Salt1si5z8GbexYLsWIWsD/CZQG2czw392pkr
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

SM8150 uses a standalone ICE node, so its compatible must be listed.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
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


