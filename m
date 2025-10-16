Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84A331CA54;
	Thu, 16 Oct 2025 12:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760616461; cv=pass; b=B+mdG30KY2QQEUzGvsfqJY48hm2VEpsXGBN3Gg6r1hs7DFvHNTKP+ONEX+T4jE6dlS0HN+KueeFUUX1c6Xzvg7z4vADPQypj6SKbhk/+4kcLKr6kDYJ8lOcAS9zrxxSjsUEP+XGh4C6cIG6wK5DkfLDrsMb6sN/r3JzYdynlZb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760616461; c=relaxed/simple;
	bh=DZ8uq7AQ0yZbN6t+lKEQ1G2VhlmTqYqMfoJ/IlracsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WGFztaV8tVjJHrKj5NYNy7+d/Wg7W6gILl/+X2bbpsuRx1/dylaiyVSLvXaBwr+z5KmmwlwVIIeSH0SGkz8rI4eaVLxm8v/tBRSaQYYIFLrBYbjxMCBfU7tepSiRixrZCtrtkEsh678Zlb/gWjEX7h5V/4uIiAQSn8m+vDyjzKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=VSDd1xyN; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="VSDd1xyN"
ARC-Seal: i=1; a=rsa-sha256; t=1760616428; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Gps3gdPN0wf1vXdvJMn1HJsrtcUCc7feEG9wL7BpDyVRK0tDfdJQeXAx14NwMIsjHNkdjGAL2tsEHes0Y/BHRte/6qGJF5421WzkABGmd3JAi5Qf0714NR230eP05rZn3WButNMc2Ee8n/ou79QcpLdYXQebDV8TZgsxRwLUJ1s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760616428; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=en2S0n7RpYJ/LIUTLWPrUDX8ECNOoEPUnk7XNj7DySo=; 
	b=kEUPEYuICqqbFBg9BWvQ77t9HcTJfeoiqkS+ck/uDQnDC+3FVuBcNiXv05fzh1s5hG9qrdXvnXoEGmgrdqCvBSijiNeebWec4BrBgPyA2+5wgw5kg6iCetv+eVfLCrESZXjKMF6PZuI9MiVJc51kjYUzie9K+F+XNSO42/78ohk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760616428;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=en2S0n7RpYJ/LIUTLWPrUDX8ECNOoEPUnk7XNj7DySo=;
	b=VSDd1xyNEQxXUmMtjnC8a4HZ/7sxKA+/rcofBLoKySAjRq2amx8JwwgqmYTxDBca
	Hna3ca4Ecaj173cShPQ7Rwb9EAF641PGDbcFLfTL/PnEqg4qeN3MYROijUNZDWVcMbd
	KO3A+j/65q16IrJeQzhpTc4xhkc0j9cFjby7DzV4=
Received: by mx.zohomail.com with SMTPS id 1760616426377151.95253961670778;
	Thu, 16 Oct 2025 05:07:06 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 16 Oct 2025 14:06:44 +0200
Subject: [PATCH v2 2/5] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251016-mt8196-ufs-v2-2-c373834c4e7a@collabora.com>
References: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
In-Reply-To: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

The MediaTek MT8196 SoC includes an M-PHY compatible with the already
existing mt8183 binding.

However, one omission from the original binding was that all of these
variants may have an optional reset.

Add the new compatible, and also the resets property, with an example.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .../devicetree/bindings/phy/mediatek,ufs-phy.yaml        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
index 3e62b5d4da61..f414aaa18997 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
@@ -26,6 +26,7 @@ properties:
       - items:
           - enum:
               - mediatek,mt8195-ufsphy
+              - mediatek,mt8196-ufsphy
           - const: mediatek,mt8183-ufsphy
       - const: mediatek,mt8183-ufsphy
 
@@ -42,6 +43,10 @@ properties:
       - const: unipro
       - const: mp
 
+  resets:
+    items:
+      - description: Optional UFS M-PHY reset.
+
   "#phy-cells":
     const: 0
 
@@ -65,5 +70,16 @@ examples:
         clock-names = "unipro", "mp";
         #phy-cells = <0>;
     };
+  - |
+    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
+    ufs-phy@16800000 {
+        compatible = "mediatek,mt8196-ufsphy", "mediatek,mt8183-ufsphy";
+        reg = <0x16800000 0x10000>;
+        clocks = <&ufs_ao_clk 3>,
+                 <&ufs_ao_clk 5>;
+        clock-names = "unipro", "mp";
+        resets = <&ufs_ao_clk MT8196_UFSAO_RST0_UFS_MPHY>;
+        #phy-cells = <0>;
+    };
 
 ...

-- 
2.51.0

