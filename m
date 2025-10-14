Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F49F293B75;
	Tue, 14 Oct 2025 15:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454783; cv=pass; b=apL0CTZj4RMecrdqnBGDeDlH6E59Xcs/U8Uz2FmDAAXJzFHuR8YafCx+Ue3BHPQq2vog6El2MYVxownFW9iH9JKN4W1w+eq5JOnhvWTkffvU8SUyGUQolWXh0geX01gDzDTam12Eb+5JuvUK4MuLPYtHYvMh9Ekmsja506Qixhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454783; c=relaxed/simple;
	bh=sOK0treD2Cs2K5bgcmg+JxqQwU93mbWRtjbQCZCe8M0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SKmcABW1CIHeuuKHHc5Q0F3bOjorCWEymmB/kdP865XUS9UGIvkMUWgkmRCJrIdPHxrp8GdSQjmBNyxyCNbitKjFowNJunlJjSwI4xlSzVXjoCABspcq0b1Ko/k07fNdQy1hkCmxAsJLnhqYiXh/DGJTjx58XTWzWhiuqGyETvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=SkvXYBaC; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="SkvXYBaC"
ARC-Seal: i=1; a=rsa-sha256; t=1760454634; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YFesbeUwlkzD1QphTliZ9lmVeXUHPW9hLQj9rgLnOw0yoDOOfrclGyZGyp4vrXoT+lGGBz6cohrQH2R0rABTY8Nlkp+s4NQ3zr56+pdVuVnC7o/x14M3HzU3EhXzCZ+y2XR4E3uw7MFs6iJjLpk2C876kO+IsW1itFUuZ1Kblbk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760454634; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6Gff7G1g/GqG8/Cg1a6daJvkf1hEhtYTLHsqf3G+mlM=; 
	b=bK1Jys7bgxokaalWMIKr5axRapsTOsIDtb0wd+gEyRjBYPRbpV4MAFcxt/+ZLV4c/aJGsW0WgCEOw9TFpc2p+2XQSX7RoSxrSXi+nYwIkCfuu8rIlMpJxj/N8rjsSrh+dsBBEZk6gt3K5cBSsFDwsVbBobxR8mykXbVD2cfDYMw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760454634;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=6Gff7G1g/GqG8/Cg1a6daJvkf1hEhtYTLHsqf3G+mlM=;
	b=SkvXYBaC48Q1+OmzERbolE3fIu4xG1Ao/KReZN4R1gLtO/KsGKyA7GSd6r7SBEMj
	f5lElPmfYtPM0SHn/o2Vvrc2iTA5jxn8cUaXJCxGQKsrL9iANW/QvIBOFJkfW1TYKRq
	3KCAIw5OIPcDsLKEOnTWjk9FWEBXD0kC1+nH2ACg=
Received: by mx.zohomail.com with SMTPS id 1760454632840287.65577737972126;
	Tue, 14 Oct 2025 08:10:32 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Tue, 14 Oct 2025 17:10:06 +0200
Subject: [PATCH 2/5] dt-bindings: phy: Add mediatek,mt8196-ufsphy variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251014-mt8196-ufs-v1-2-195dceb83bc8@collabora.com>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
In-Reply-To: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Stanley Chu <stanley.chu@mediatek.com>, 
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

