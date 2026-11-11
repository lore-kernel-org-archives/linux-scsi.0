Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794419698;
	b=XODjHFXaNaYxpDDW4a6mtSGLNFHnhKrPKNCCWlvBd5AmirR7nVzgTpWVyYY3PmOZMUq1
	 PHUJ9R2YxZ8x5oX3/K9gYek38YvWAA9Na8E+sxuSzoRtGS+MZNunh7xXU7v4lZQMuZ99/
	 58+8Umwx1egsH3e+9WAnGULCrRoZaso1B03mJ0UhK4hLoholEXQu9oJGLTAVBZp7Q9XSC
	 cip/mTSKtlYXLCiFKrDXKsVkdr3sRTDC6cnz8i3n/6LoJERg1PToYjVCy5Jo8qy3ybFgd
	 Fv1nI4obp2ppQlK53/dvplx2dmGUPfmRmt9eJorMhOQovmwKldqqzLtQnilH14CBAsw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419698;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5TfeXJgqxgoRFHKMC8wwxTp07/KY6IrnEhB21DSJecQ=;
	b=zArKLWeqBCUHU4mY9WjM4pc6D7Rb4wn5FXpgwWYetXJEFVbcb/JnNfG3MdK55VO+AzmM
	 RKfn/HwzCuuggNMEBaFD50CSNpMqdvRxB8ry1QiV2Eh+QII3xJRaFp4aOjpto+JxqGRGn
	 34bC1f3jSWeOivEkg+HMap01uaMGpdxmLPE6ptz1tYJDDAORP0qkyKlOMBAfqg5TiaNMc
	 aETDujBC/U9cNO6bfNwzEae3dzDSv13B4SUcpTuq6B7laPX/+G6jsh/W7nJQjPdBbaTHk
	 fpXX3Z6D6TqXKalyT8SoOpgftplHy/l4sxZJcPr6VkC1uvH01adlhu9R1y+Xu3LW4uQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fplAvh4W;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B495606A335;
	Wed, 11 Nov 2026 17:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fplAvh4W
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794419698;
	b=vvkmaWkgRgYKM3Oa4FdtESPMNa+eMWBq70WqWO2k54mDAgkwq+y96UXqSIXBYCLVkzox
	 ralkBNsfvQH9UyPBFShi8yRA7nSb9qPVzBWrwnJpSVE/IlYoFMfnjTwGhMT6042m0+pbn
	 LDjKfAc8NfMY/c96CBEygRdBeCzBmemBmgecCzIBD4WNfP467kCXjdlG4yB/6GpRw1DrM
	 hohPjbwUgOrD/sWrnRZiwJZxIOY9vEP/s174L02D4cQh9nvV1DQ6B6bvXA2ALLZ+LFcjS
	 NrUKp53ZcuXeuX1EivzMP/IJAGHxLRRDGkOFu5UqMe9oaIPmpHMOKwPKSAvAaW3xz6Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794419698;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5TfeXJgqxgoRFHKMC8wwxTp07/KY6IrnEhB21DSJecQ=;
	b=tYTK21Dgl2p6uqFxsrA7ApcLQxcxSp2rpsWWSeDwPDpnfDK5tVq/Oq3hc+CUT+P3icxG
	 YEgR8iANu3X97WBo2P+lNc/QD0F0NSMiMey0IyLYDd49AsQzVj942DWCaqH9UxYTnrnJk
	 4EF/KtUWUtXrDjXTNqe8RmI4VgewiCBpSeVmPdcAhIUG0SGckP7jDAwSCjtlPPdNWzpVd
	 FfKbmbff7SolsTbs2ARloKJD5cIubLq2KbTcvG+hnxh/8ES8A488/ciwz/DhsqL5CARdf
	 U+DVwXg0lq/uSpvpLA9RWRX5vhByqgzKG2c0LXkOBmy5Yrf2Qz0HmpxRFXgZUI2vGuQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 984C61F00A07;
	Wed, 11 Nov 2026 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794419698;
	bh=5TfeXJgqxgoRFHKMC8wwxTp07/KY6IrnEhB21DSJecQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fplAvh4W5zJzbpK5iabchgIzA1Lo3FE3XYSE0oUOKAGRuUmIL42OE6/QSYEV0JQLj
	 saY61rVLGoFT7i0MTeFyj95TXqzY5g19UWzbX1gkKkZJazXrQtldoH7Z2Ssdt+5P7B
	 pNHkYt9DWsAJN5mctHbbLCqIiiC052NirZNSd+JRwh+RfKjd7f7XXwRqVc8GPjxXhY
	 y9EpnZPfK5DSZ+SMCg6zfmtlxzmkZxL4o3xhMI3aJ4eTasGpK7/XG1ufnyl3iYEOzt
	 rg9dcqINHqooS8/QbCMz6gYlOHJOAkhHppJ9gqoticm89mi4MYKkHkUzZDlKaSToD2
	 MOi3rObmhVK4Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1F3434907A;
	Wed, 11 Nov 2026 17:54:57 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 11 Nov 2026 17:53:22 +0000
Subject: [PATCH v4 2/3] dt-bindings: ufs: qcom: classify sm8150-ufshc as
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
Message-Id: <20261111-sm8150-ice-rfc-v4-2-0311eac35609@andrewgigena.dev>
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
 linux-scsi@vger.kernel.org, Andrew Gigena <mail@andrewgigena.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419696; l=3635;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=FS7Osahusmu8N0/dDWHi/whzavzMhLE9W6HGDRPIxVE=;
 b=1RgxFyQEX5ixoaib1a+Rz6YLvEbJgQ7NF+6htF1K53masaniU4KW1VivCpVOlfawJKFoThV/3
 bPIMobs0swfBOL+YZoPVuPlUX9uRar9YvPYddquHeIwM1QCdQs9X7pq
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

This tightens the schema for qcom,sm8150-ufshc: the standalone-ICE
binding allows one reg entry and eight clocks, while existing DTs
still use the embedded-ICE layout. This causes a transient,
validation-only dtbs_check warning until those DTs are converted
(sm8150.dtsi follows in the next patch); existing DTBs still boot.

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


