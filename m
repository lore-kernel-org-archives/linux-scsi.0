Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DA346D2AA;
	Fri, 16 Oct 2026 12:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154015; cv=none; b=ZG9Sfb8m6n1cmHWvLmUJBaM0XsLv5grhtqWk4X89mIt+thVAWc9nyHmJ5+s/qULCpuvGfqUybxjXSj2b+IT0Qv0v5UeKInFtgjzJYNsSnPdFfrmKfWr61/cAviaEHq0d0rYosvqEErZryto3Lk8LRUWu38nEMd7wrLBbhZXj1tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154015; c=relaxed/simple;
	bh=1lUaK5hN/IF0S3Grrs4vV6++3p9/90FoHuhs0z+reyg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LHdJdgwBd3U3H4FnJSuNcD3o7KoNpRzhnCmtO1kBg873gYJwVrTRlqRVUgc+Oze6OcVm5OLYrxj8nGuhBaQNKcNZyLxVezp4N9vJF65Zs4XYdbdNOuRdb9koc95XO3qWMbzuyoejE9tDZoOFDZTVKIbfLTLMdxRfhkZep7K3Ivk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=OWum3iXc; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="OWum3iXc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154011;
	bh=1lUaK5hN/IF0S3Grrs4vV6++3p9/90FoHuhs0z+reyg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OWum3iXcC9mXrbSFmboZB4AEyZtdqHB68NSy6BUs3yw9/gHJWD2RMqYmd6wrKrKQ7
	 gzUYt5zaZci4fWYepObMBdwcG0OqLWQ5bX3AT1PcYbKguUoS7B1HBZvx91zIKsNiCO
	 PzvOaqUbbTr6UmntATKaBpIS9zaczWDrMspN8K9sixfCqhue0gjdgfevPZ/6T9DLJO
	 ulli33uGbN7Vcwg4UG4TESMyRIgKlClNN8Z0FSZ70FlGlvJGpq+gmqB6n2RZrGiRf0
	 iDXHD9Aa7CsL2+Wm65gwkdJvSIxv7GKsBYZpUAmfSy9S5PQR86vrlG4AKCrszYGiZN
	 nGgmGR/gNTXyg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E53B317E05D6;
	Fri, 16 Oct 2026 14:33:30 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:32:53 +0200
Subject: [PATCH v14 01/23] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-1-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
In-Reply-To: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=2063;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=4tciUbFB2HMiH9ffvziK6C0JBisBVNsNdL+4utx+2vg=;
 b=eyyNkQZ4YH4wShDx/ZhPkMbV5WxWOdcygzX47YN9Eqocd6JmenDkpve76rBziPxQExpr7MCJK
 tBeuyQBFJJjDWO4Gnz5+oThvMXV6RCtcBGTnVAwItfgaA4txieq0o2I
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

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
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
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
2.56.0

