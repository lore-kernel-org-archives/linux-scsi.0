Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039783B4EA8;
	Wed,  4 Mar 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636050; cv=pass; b=Vvt9Yt9DKnx17/gVm8Jp3IkGPGn3roSDFguUJgs9BiMq6CTH18AnaGGPqDG6XVgeKOPYcdCRTCM24aCXdzsB/DVaxL/qlxRQKmD8tD0H9y/rDNADF6yBNwoCTWPmfCHG7WL4IMnaHYZGUUqkM5DoXHivIccUwfaFxeSa1pR4mHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636050; c=relaxed/simple;
	bh=EypgtlfYshILgwlUk3/w02vtCCXWaUCb7oIkiSqhtWQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UrbTGdxYW814oryF4P3oaIurQhoG60mCskh80emPMt26g2F58xs1RzGosrPX6SgI7QpQZDlm3unYl1ufD7lZ3BFQTPA8EK21jaE/bgzjB570Gw1UXKw4w0cDNDl8RtbKXB+dk96hI3J6Wl2S1b/hvfZst/VykL779DG9q1SCf9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Sm5Jqb98; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Sm5Jqb98"
ARC-Seal: i=1; a=rsa-sha256; t=1772636016; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FoPI9w5GQ9MR+obyELlf6irpuMlWNHKCwPMszn64u55yl6zYZADlJwTusDzmSSTGFBPOU+c2L8zhWeSpGH2334sfpc+AjOX2j5lIcrQuBwvayIX+ypMVW+03UJxpjAFO+hiQUIgO+wSixcg9vgohddqahSMSxY+mVqgfyVOZOXg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772636016; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wIUS+P9KTYwp9LndB8yjQ3RjTNoJrePfDlm02gE6g6U=; 
	b=JI/aMSV0fA+u+JVXaVRGN9i4o1HvurhRH33yZt1bj+kEbJ4D+0pb3zf1FmeFPs0U565pFXzQ9vph0ljPPlP5tSRXEJirLv3USonZdxK4ryMCVKKt6ORPxS5lm+ZekOvRgdCjwtQ7jet+/1MohQbLdyI+wpD5NotiqPU/P9t4T4g=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772636016;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=wIUS+P9KTYwp9LndB8yjQ3RjTNoJrePfDlm02gE6g6U=;
	b=Sm5Jqb98JGs2N1IWHZw8+t/3RdPkGtrN8XvF0/jmL/znVuZDOHpAkoghjT+ze3bl
	7seJyreHVRR1yWK3io+x/dnx+Gxx3ZJPHEkZkGS0w513zU38OPy8aQjEc1Tsu//rSOx
	m6Gb7I2VvNUH089OKVN/CiBkCGD8AP68U6wrIozY=
Received: by mx.zohomail.com with SMTPS id 1772636014066884.4766831898646;
	Wed, 4 Mar 2026 06:53:34 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Wed, 04 Mar 2026 15:53:06 +0100
Subject: [PATCH v8 01/23] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-mt8196-ufs-v8-1-5b0eac23314f@collabora.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
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
2.53.0

