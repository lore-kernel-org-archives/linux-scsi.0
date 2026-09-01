Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AED3DAABE;
	Tue,  1 Sep 2026 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277169; cv=none; b=aCfWtaPUtL8v3/hl38sc0+XH64rajq3Dhh3UACVbNv3eBXogWENHQ2f3RItv4o4tgMLR4krNABPFhiyIpmwI5v4+oYkj3tIvyXu9dGFn3mCc+URSE8WioRgnbgbN/LDJquH2eEcwIrwHKlFOWJPhYxK33PZ2xcN/TZEljywjIAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277169; c=relaxed/simple;
	bh=ZEqXV20UfJpPysNADYTF43diSa/57Iv3c2M4KOvi/ko=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PY1zwUwU9KNYv4lkrt25Qrxj9cdYAJ1FzBUfLKKM++EmjYsoPVYNzWU3rQs7ebSn5/yk2WmIj4y2jRjbEgruf883rx75bIVaiywtvSFAbKG/Nj5x3VJ7kx0jaHA7JeqxHGPS0rTbZQD08BiJ4eZZ4ki8rAVoVjDwqwDHkTYCZ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=iqgYIjm6; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="iqgYIjm6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1788277166;
	bh=ZEqXV20UfJpPysNADYTF43diSa/57Iv3c2M4KOvi/ko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iqgYIjm61CaozZO5jGN3+HtNcpIn+Vk44nXqKp6GvsqlMjYGGvE2rNEX6Qq2Bri5z
	 Wflj3/4NTbG+3BB6sINsUSM2CDkAbQYzkVu5Qxew3ZCXiiaYT0pktz3XQVUxVlNt0Q
	 3Axpb2bd7M+fUJHU/L7HQKvhRq5aeZ5MAJRegMo+FRZSuUeNAYKq37bb9FWBQP3sA2
	 tODPOnfppAb3aKY5eaJMBdIg1UPkiCLgd0RFhIhkHPcRvYoyl5ntW+kUqCl9DI7LKj
	 TozqDJQsr22Qe/uIv22LwZVgOt39nrX4A769TIwbZ8XzZ9iRQVx+TQUPW4gFhU1pF1
	 0kRzSeZVOC5oQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 3DF9617E0934;
	Tue, 01 Sep 2026 17:39:25 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Tue, 01 Sep 2026 17:38:49 +0200
Subject: [PATCH v11 01/24] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mt8196-ufs-v11-1-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
In-Reply-To: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788277163; l=2063;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=bk5EtgAp8+Q6dY7h9oTa6fh/C3fcFtiFpYBT06lrORk=;
 b=ABFQXl/Fp4QESUIOE9DMTPfGvegHvTqaguXJG+n54HEydkwuFY4mu6FrGutWkHP95+ZMvFjnL
 8OJICOR7Z3LAb4Apg2SG9y6gnpRm7KjrUgec04owmO33Y9a1Z6eN8XH
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
2.55.0

