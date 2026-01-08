Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3612DA75C;
	Thu,  8 Jan 2026 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767869440; cv=pass; b=Bxx/K7H2Xb8fcqQifH5zRWCG8YBWDQbgw5OpYOtUmeLHRn6Ei3rHUqEgLGRVZvt+7VfF2BnyT/9YV9ka+WyZlim6G3Y8zPD7/ji8aLfblrOAae3Ke92s6wVtfTEAWpEEHfKNYiCfZ6B7U2zUVPVb6pEYwbisr8BaZvy859A8Fwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767869440; c=relaxed/simple;
	bh=WNEhM1BJ5VBqtLc9zwYWrs8k9OBKuHWoDi6Ou2twFtA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=onJuYY0Dp4fx4GfvuH1BaGj8wdrzkk7x5u63pLQtW3NVQwCBxvE8iveo0HjAltMkVrRHTea5lQ/beOfEbZKqN0RIQo9z8Q6g3+pPdubnlvAbPFSnnIchNnDA6Lao+lN349bTlYurgxe7tYFMvEA34PbqW25Qjbh9KhabMsW9I+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=GvDAdSKP; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="GvDAdSKP"
ARC-Seal: i=1; a=rsa-sha256; t=1767869399; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=oEWONl57XBuz97zesnQfAjIh7Vl3/H90/FH4nOp8ji6s0nbFEMkoixJei+Yx+WG8JJWsWCTRPtjkFT3h+tvWWXqP5spxXzm0VigUI0mL1qNC0iGa16hKvthyYC7cFZOYhoonlEAEPUfWMA5WrkglZr5E/0aUEqg2C+z7bQArlTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767869399; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=q/ASY1Etp9IXhLYDc9pjizpkuHyRR0lGX8YLQb99GLU=; 
	b=oJn1wKo+Q6qpeDquB3GxZDp0b/7m47GEklHzn8KdBk8XNYHrMiwdSdRGOMJHWJf3E/D9efIsAe3Quz6iK7InHD6tSdTQ25AbDAz/DlXPaKST+m6El/qw5APspO1ZlK1lAcRcp+o+ILaB5Ov/XYruqAul1k/CtxoYibdNsp/jPDU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767869399;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=q/ASY1Etp9IXhLYDc9pjizpkuHyRR0lGX8YLQb99GLU=;
	b=GvDAdSKPnTiXg/odfQ49Z85YdhUSaPuWMhAx1TefItl6l6yCtGFR76ztsd6Qf7b/
	iWV5P75SgucQzH+lMV1lZAplwrbFpu8qXU6d85s2i0ufgHdgFr35iexjvTbWUGLg3py
	qfNz5iR+jx9HzHEUtgPYbfffI4a4Uqjt5Lmw2liQ=
Received: by mx.zohomail.com with SMTPS id 1767869396599127.73017578228576;
	Thu, 8 Jan 2026 02:49:56 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 08 Jan 2026 11:49:20 +0100
Subject: [PATCH v5 01/24] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-mt8196-ufs-v5-1-49215157ec41@collabora.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
In-Reply-To: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
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
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Conor Dooley <conor.dooley@microchip.com>
X-Mailer: b4 0.14.3

The MediaTek MT8196 SoC includes an M-PHY compatible with the already
existing mt8183 binding.

However, one omission from the original binding was that all of these
variants may have an optional reset.

Add the new compatible, and also the resets property, with an example.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .../devicetree/bindings/phy/mediatek,ufs-phy.yaml        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
index 6e2edd43fc2a..ee71dfa4e0c0 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
@@ -27,6 +27,7 @@ properties:
       - items:
           - enum:
               - mediatek,mt8195-ufsphy
+              - mediatek,mt8196-ufsphy
           - const: mediatek,mt8183-ufsphy
       - const: mediatek,mt8183-ufsphy
 
@@ -43,6 +44,10 @@ properties:
       - const: unipro
       - const: mp
 
+  resets:
+    items:
+      - description: Optional UFS M-PHY reset.
+
   "#phy-cells":
     const: 0
 
@@ -66,5 +71,16 @@ examples:
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
2.52.0

