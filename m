Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793817506;
	b=hjp908MtymIpP6MikpIAnn1YET3as29HH9iVj8HW8OWcz+BjWBsJa7cfRKxef8zctjoo
	 Cqw5gIwy9RqqTHABpIZmENuN+DBSONJP2V4JGKghvs2o294PIcZO5yKgc5cdaAn2xqcN8
	 7x5Sn1qJOass32+bPuZrDo3BNsQnFZMMGbdZ3EbmaF+sHtqjmnRp7dAocc2xex3kw9QTX
	 nVGSYQtWvkkyxnlNGPFNFbdlw2eF7hPLQOYlJxPUVVquKPgX/lju92j1pywvDGuzv4eY6
	 acY5sUVYcZEtuTa6g5O8XLR7eNeP9YmW+QhoQjqXgtCpZTH4KPL7QfzPBj8aLZC/0WA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817506;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+1f7Rzra7x85jb5eSs0HoWde3I/rDsurattuUDX1lxY=;
	b=dQivOtjCNSmk1SB+XbZ0LYm5WBaagWR3yGLiVpGP55DUmpzGRQbExqVSSpq4vZBjcCsp
	 3yqHOTgfzGlU0epdNnl/+n0PFA3XMFXq0FJOQ1Pr786PcCXiVp588a+sT43vjv/IBXCOV
	 6pvzbBaebqID7LEt/Yot3xolDaoOdkzMfnX9nPbut6veW6raA5CM5jUa8cbvrqX8wuFDY
	 gLCSsbLTFttanTITANP6/lxo0Ntn1IV3Pmp6ekv7l1mVuq6giX/fOiLSUYqD5bO1qRI0a
	 +1oUqOtYqYN80DRTIXKA2ItY+SFjZd5nF/gJSJ7rretiWtzrAsWGE6qbyBMcdCCKswg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jOW2LVsw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22FE606D806;
	Wed,  4 Nov 2026 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jOW2LVsw
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793817505;
	b=ieT9UmWeRjBKIZR2tK75c8o9u8dzWde1kzSySMl8t75sCkoCoAhlLYHvWxokHRTfE7Z/
	 ETJXVBUpxuoKkUspMLapNkAG/763eLeVZwU7RSOgNgtVr3CGHhfmdrXCgGFSe8Y40tR2+
	 VLDcR0rxNucB0ba4Mv1WQECsmaDwAVxFhmKgX+CV/5d8y/uSNwloWvKGDFmwQ+lzKLRtR
	 jgz7B7Iw79rPBRTGHtWLGX2uyS3JqQytu/q3CmfPjWXgAjfIG/O5lgPeSNFXzwcfoa3tF
	 +0tbm36aEtfjekAB25YQyWyvcgizY5QoEEJEDUm+2S7AcKaUzv1U5HyOy9Ob6uhSeIw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793817505;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+1f7Rzra7x85jb5eSs0HoWde3I/rDsurattuUDX1lxY=;
	b=w68rM7VcL8mE06en+N5DB1//b0WKpc342FLP4NHraMWFWHoQvEhnAg8oRHVpRg3QoVds
	 GhPBu2Qo7JJKLVATFNL8BSa5KLNIkZczZQk5WcBfjLAqKTxK4Wq4eUTE8yJ+Y/eWQtRr3
	 qsXom2IS0nDqgFUi8/ViMXOGQ667GafF7NzzZ0f5GaGt3xQ788ue5P4h9BB+kQP7C34a/
	 bYYH0dbY0l6UOBR5gG+6yKk0cZK93PJUla/63pDWeQGSAzj7TbUHnqxdSXriphkAo2Z/q
	 U+6ZgXkICe+SoNthJqXO7XmBWm2baoTWpvdQHJi4z/vDM1LYff702KZe9fnRcb3wJjQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 618051F00A15;
	Wed,  4 Nov 2026 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817505;
	bh=+1f7Rzra7x85jb5eSs0HoWde3I/rDsurattuUDX1lxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jOW2LVswIT6eg6NKfTW9BLGu3fWkzUrGoEJ6sFxvrNiUZkTJ0ockRXQKXqmn8orvQ
	 jTBVkj5OJtRuelv0O3Us32F/a2G5OCsufFsLGNrXHedHUhy1NGEr3JAwpDm5G51j0m
	 HM8/+0icQOMkMRerYYYZ4BzhcUVYikhUMN7bp85KSy/43zkkS9vT4AIip+uA/mrfG4
	 pIuSit5p8SAsFU/nrq7DlfOEsI4ny7XEqfdN0LUEO1y3nU4MVSFT4u52UjH6w/0H+Y
	 0fO72kgBbAgroqhhBlyw3iDJDcmM5GG1DOmODm6Vd9K+LFBLzbJGrt3p/bodDsOKZM
	 aFkKZujZn6Pyg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C9E4546F30;
	Wed,  4 Nov 2026 18:38:23 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 04 Nov 2026 18:38:12 +0000
Subject: [PATCH v2 1/2] dt-bindings: crypto: ice: Document sm8150 inline
 crypto engine
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
Message-Id: <20261104-sm8150-ice-rfc-v2-1-d697bbce0278@andrewgigena.dev>
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
In-Reply-To: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793817503; l=4322;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=mRCpiAcaklHlABHeMaju4dyvg4yCGxIDPGZCXtGntFY=;
 b=9CGO1iYKSfbbBha6rQDoLKsEQY0u4YVtWuY71pAiX3vzQtZhQBMdqNKDSYscGQFHM3KYDXuzJ
 /rNvlzjrlsPBAA1HGof+ml9C8+q8iddLBv/7yR9C9cHJLcgDRceHUYY
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

Document the compatible used for the inline crypto engine found on
SM8150.

SM8150 UFS uses a standalone ICE node referenced via qcom,ice, so move
qcom,sm8150-ufshc from the legacy embedded-ICE UFS binding to the
standalone-ICE UFS binding. Update the legacy binding example to use
qcom,sdm845-ufshc, which still uses the embedded ICE representation.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
---
 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
 Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml  |  2 ++
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml           | 11 ++++-------
 3 files changed, 7 insertions(+), 7 deletions(-)

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
diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index 3c407426d697..572eec814a60 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -23,6 +23,7 @@ select:
           - qcom,sc7280-ufshc
           - qcom,sc8180x-ufshc
           - qcom,sc8280xp-ufshc
+          - qcom,sm8150-ufshc
           - qcom,sm8250-ufshc
           - qcom,sm8350-ufshc
           - qcom,sm8450-ufshc
@@ -48,6 +49,7 @@ properties:
               - qcom,sc7280-ufshc
               - qcom,sc8180x-ufshc
               - qcom,sc8280xp-ufshc
+              - qcom,sm8150-ufshc
               - qcom,sm8250-ufshc
               - qcom,sm8350-ufshc
               - qcom,sm8450-ufshc
diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 516bb61a4624..ef4d1d055169 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -23,7 +23,6 @@ select:
           - qcom,sm6115-ufshc
           - qcom,sm6125-ufshc
           - qcom,sm6350-ufshc
-          - qcom,sm8150-ufshc
   required:
     - compatible
 
@@ -38,7 +37,6 @@ properties:
           - qcom,sm6115-ufshc
           - qcom,sm6125-ufshc
           - qcom,sm6350-ufshc
-          - qcom,sm8150-ufshc
       - const: qcom,ufshc
       - const: jedec,ufs-2.0
 
@@ -69,7 +67,6 @@ allOf:
             enum:
               - qcom,sdm845-ufshc
               - qcom,sm6350-ufshc
-              - qcom,sm8150-ufshc
     then:
       properties:
         clocks:
@@ -175,10 +172,10 @@ unevaluatedProperties: false
 
 examples:
   - |
-    #include <dt-bindings/clock/qcom,gcc-sm8150.h>
+    #include <dt-bindings/clock/qcom,gcc-sdm845.h>
     #include <dt-bindings/clock/qcom,rpmh.h>
     #include <dt-bindings/gpio/gpio.h>
-    #include <dt-bindings/interconnect/qcom,sm8150.h>
+    #include <dt-bindings/interconnect/qcom,sdm845.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
     soc {
@@ -186,7 +183,7 @@ examples:
         #size-cells = <2>;
 
         ufs@1d84000 {
-            compatible = "qcom,sm8150-ufshc", "qcom,ufshc",
+            compatible = "qcom,sdm845-ufshc", "qcom,ufshc",
                          "jedec,ufs-2.0";
             reg = <0x0 0x01d84000 0x0 0x2500>,
                   <0x0 0x01d90000 0x0 0x8000>;
@@ -207,7 +204,7 @@ examples:
             vccq-max-microamp = <1200000>;
 
             power-domains = <&gcc UFS_PHY_GDSC>;
-            iommus = <&apps_smmu 0x300 0>;
+            iommus = <&apps_smmu 0x100 0xf>;
 
             clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
                      <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,

-- 
2.56.0


