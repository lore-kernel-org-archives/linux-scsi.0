Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794370674;
	b=0cDMWb6Rc/vUqzH4I4VmFvS7qd6RUFr2meznKdZsrvZii+ZnOE6FXtD+Pxjk01go+LNI
	 Jxd1nmlaISByimskhkTEya+TtQmUA2ojqWm4BAkdz1LKRewzGCYqBCol9DhzI2P/oAMQN
	 QI6tiRnShzNaa0MFOnunEYkil1OZQLpIQvf71dFRHOvrbxemtdSWw80u2GyomdGbVzKJb
	 RJGdwUfM0k98NviCInf96M35p9G9Xirzwua3dp3EiXw8KJlphLq4sEdMphqP18nmc5GNl
	 Id+KbrCYqVd4mg+aCRtClQE7xa723F2maMAnRbxU1yc68tHb/TZDzvdU7KHoUatTwuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794370674;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Uh+Vk7mbmhtzM6Dp3dsHD1Ju9bx6TzwXVnCJR0uuwbo=;
	b=IgKYRz6SQEcaXG1+YBUEqJ58xk5jRi2QDy/wLeePOK/L/sKw33UymwGXGeY3pk0WTOpD
	 wsEkHBVHJPgDNBK/WwUuI4+f5zn1o6tP/iakTvQCRlFNvLtoCYC59rr9gI3Jn7cPavrgf
	 mw/RyE/64XmRrz3iID2o3W9F6LlhKOJlkoKw+OGXzb1s27yraoe/Dtj28K7de8HYh0wtZ
	 hSSOtJ29vQswSdUllbyG/XTemST9sfbIdaudpPdbGYpL2QPM0+j4ayn340Z1qQagh1j9s
	 JiVZ7j6Sh0iglVqqlVOY0ugHi78zYr3r43ySO3w9MmiG5Zb9gW3fV3/7WDVhZ3hRCug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tymx1nax;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E18606A337;
	Wed, 11 Nov 2026 04:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tymx1nax
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794370674;
	b=I+3eNoBffs6EkHUhxdmBJ4DkDS5ofLZShXeE81HtJCxR/k4dlJijFCr291qWnwKnCtdI
	 nrPYK1TLMeghEWVSU2a8OQ9sYhBMGJhY2I/+TkPxkJXPlU+H/bb7AAmrWnPDk0E+rNdPn
	 vf9ACvIDnOW8JY6H4becgqOSn8tA4xAK4AmdEYN1ky3un4xQAugO9tC1GnTM0aY/a0vf7
	 i4x/N9ML+YmanyULy32+o0l8zmyGg9MzHF12RDwUgH8V8gFqccJIrBTyliybTsRTXJlLE
	 NHXxHaSzQWl7AGReAYpTS3WpH3fUaPAwxtszn498EhLLA7/GG52ps1xr7sdz3w4bQ0A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794370674;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Uh+Vk7mbmhtzM6Dp3dsHD1Ju9bx6TzwXVnCJR0uuwbo=;
	b=Mpbkjedcm+YGfKBp2fKvt1OHWoWy6zFll3Y/XQ5RUYMHHtnBEc3eFXldw9sW1YzgKa4B
	 I/+ZN5tZ5K9+pxZBuy6z+AuvvqUtDjMgra7L6RJHJiWsFBmdVUWzwyd7tJHl64BL9TS1t
	 W/2nJo1yefuwzc8JiI6SpOBJXScfbYPZYT0E9p/eFVKI+YZPW12/6I3HtR7shZQnFkj9u
	 yxLY6Zei71AA8ZoeJeXm+EsdFTNJ0dr/aqy3SWnNM7rriYSHM+6yAoBOk1uMOS+HtwuQP
	 7cdRaeqzeh8WP1JIDI20GgY+rxyztjvVc4UL01WkbmKmGC+SWPjXP14x5McpG1pVB4Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1FC8D1F0093C;
	Wed, 11 Nov 2026 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794370674;
	bh=Uh+Vk7mbmhtzM6Dp3dsHD1Ju9bx6TzwXVnCJR0uuwbo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Tymx1naxjfuQ9BE+JU8e3ZJOJuoiQPQFbCOW6y77C1UuA0LPgiLTIysjfsQSd2hZC
	 33Vbjs6rRoPcdbK6cZFOtJzagf92eze5zUT8n/uIHtq04/TgSaxdlEaD1cw5PF4St7
	 6WfDU1EPYhCbFmiWWU0Gl3UEOeURwr23gedCC40rr6Aj8UR3tYE4rxN3SJXYKFRqEY
	 tMpQs/TzRJ4q8HLIiPrBrme6miurnNTe+RdBMKNo4o8DHN5X9C+TpppQFvKuSlKwy1
	 t1A4CqXxrEsRfO2WryMIKjyn5Ka+Lsx/wQR5ZJvwlhMV+w4Ai8byOW/LyD4m9kcYpb
	 3fdCDP+ztHxjg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9C6CA48D78;
	Wed, 11 Nov 2026 04:17:52 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 11 Nov 2026 04:17:50 +0000
Subject: [PATCH v3 2/3] dt-bindings: ufs: qcom: classify sm8150-ufshc as
 standalone ICE
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
Message-Id: <20261111-sm8150-ice-rfc-v3-2-f9d5a806fc95@andrewgigena.dev>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794370671; l=3303;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=um317s7SwNuXS9cpZHu3oF3R2T/4rDqhpUaOv3O7yfw=;
 b=HOY6WH5dJoIQV/02opNZZi8icx3u0Pla5SAaDYTSU6TbEjjGsZJTlafaN+w2k2c7W+S42zuMS
 MnOuaOc8yglCwlxDP6YFPkCUSNg/87JbPHWtD52jTeGoPIG/6CqJwbj
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

SM8150 UFS uses a standalone ICE node, so its compatible belongs to the
standalone-ICE binding rather than the embedded-ICE one.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
---
 Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |  2 ++
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml          | 11 ++++-------
 2 files changed, 6 insertions(+), 7 deletions(-)

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


