Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643C4825B0;
	Fri, 16 Oct 2026 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154017; cv=none; b=KBifpkFSiIHAaD3dmFIFF8iYoBI8StlLKMSS6sRnUEX+z1tuu8De303djiDo7qgF8Qq5bVrJKRUnvZxPv7ji8ikDiuvHaszplTa0JylKVbGP0pGOkF2t+Ccon6kg8KhWixqEHLTJGLhZXT3eYUq+t7JBPgLv+4qojRLe4arPFMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154017; c=relaxed/simple;
	bh=m5hJfIrVYgzyNoAPyhFPMGOJ7BJWLS/eKC+SWXbrdVE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lskUxJjH6REssb6nzJ0uah1uxhWOArHYeQHnUyVmYctuPckWMUJECauDy0zgMLXMnUFi3jGMntxLM97gmJvabTcQXyrKqqKJvGoa8Px5auXSEfb8Umrd8AuoKIGiJZNwr9Dh8lLpnL/QDaS5caeHF8VtkOP1eV60M2aHco7Z+1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=dVEfJGNW; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="dVEfJGNW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154014;
	bh=m5hJfIrVYgzyNoAPyhFPMGOJ7BJWLS/eKC+SWXbrdVE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dVEfJGNWzq86haeY9ndZyivAyUvzSqrI57+Ovmd8GZceHLiUa/R4V3STE4rK0Vq0b
	 gHXr96h2dv1eudtBhGCb1PR3A7GPDnEGmhOsXOUq4XWPZooem0J030HOp4M51o5i7J
	 nKV7tIaSjq2z9dTztaLeRseclDh4iXv/zyi2k0jsZ0H2TFNaQXQmsJHc8ntN1h+iI+
	 HsDXkC/Ez2fpXqtzcR1KltZHWeZ5r8wzufH/EiIKoZqTAy8MivPlmaRMEP6v2zjMCH
	 hABCcc8W8mnnEg+ZiZJylgON7BfHpI07DbPYpTn58CsBTzb0hHw0tKTUYTYz+zO4Qi
	 EqHu4CwSMdIRQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 29B6217E1509;
	Fri, 16 Oct 2026 14:33:33 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:32:55 +0200
Subject: [PATCH v14 03/23] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-3-e8d565e0cd45@collabora.com>
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
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=2540;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=Fu9MfrHRxOqGq0SuEgCjBQkvUm2tW9NvFGGI8VG1HyQ=;
 b=1/2z1sYlEqYqWvUjCr1bFKPYOg+fGPuR+qxM0EZDMaRkQhteiSyfOGvcrTpF7IuvlDPu870EN
 gSReGPSA1l+BxbjNpGO5YlgIZ6KdbTvprRO2e3se/wH9KohmybDbpTY
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The MediaTek MT8196 SoC's UFS controller uses a different set of supplies.
It is therefore not compatible with the MT8195. It also have an additional
0.9V supply pin (AVDD09_UFS_1), that is specific to this SoC, thus not
currently described in the binding.

Add a compatible for this SoC and new property for the additional supply,
and modify the binding correspondingly.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml       | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 945cb986b06b..99181ec9dda0 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -16,6 +16,7 @@ properties:
       - mediatek,mt8183-ufshci
       - mediatek,mt8192-ufshci
       - mediatek,mt8195-ufshci
+      - mediatek,mt8196-ufshci
 
   clocks:
     minItems: 1
@@ -60,6 +61,9 @@ properties:
   avdd09-supply:
     description: Phandle to the 0.9V supply powering the AVDD09_UFS pin
 
+  avdd09-1-supply:
+    description: Phandle to the 0.9V supply powering the AVDD09_UFS_1 pin
+
   avdd12-supply:
     description: Phandle to the 1.2V supply powering the AVDD12_UFS pin
 
@@ -104,6 +108,7 @@ allOf:
         clock-names:
           items:
             - const: main
+        avdd09-1-supply: false
         avdd12-ckbuf-supply: false
   - if:
       properties:
@@ -119,6 +124,7 @@ allOf:
           minItems: 3
           maxItems: 3
         avdd09-supply: false
+        avdd09-1-supply: false
   - if:
       properties:
         compatible:
@@ -131,6 +137,21 @@ allOf:
         clock-names:
           minItems: 10
         avdd09-supply: false
+        avdd09-1-supply: false
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt8196-ufshci
+    then:
+      properties:
+        clocks:
+          minItems: 10
+        clock-names:
+          minItems: 10
+        avdd18-supply: false
+      required:
+        - operating-points-v2
 
 examples:
   - |

-- 
2.56.0

