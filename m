Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973F5443C1C;
	Mon, 14 Sep 2026 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385955; cv=none; b=FzmFXV0B1ByTm+qGkU9uPyYWd8lOjmzCUSkp0/lIB1LacXTbXm0UuTj7071s4Sq/1Q580Jv0wL/ZZKeU2E57+ynw2++csUaDNyUYijUkcs+fYEODMiyro4APQu0xGrp1BK3Hk4V26nc/YcCUwJO7PggypKczbbEk279eeNeJ7Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385955; c=relaxed/simple;
	bh=yCxfvuw4TigVRIT+6VjM1NwL4ye7ClP2pRpWLskgBas=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qPV/VWiYonvKeJNmLrEhnes1gpz+raFy6LKDztZ1qxmdd9FUkmAXQslFz0ZDt33V1XvwhcE8PgD8zaWyrN3oJHTAcdq7AftJyH2Nx3D4Ldvdnt0rNj0j4UuhNSOGMdoeaJaLKbTO/0Jyhfbnc71/zuzLOestQNiNIonUTS0QEcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=OlX0+C2O; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="OlX0+C2O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1789385951;
	bh=yCxfvuw4TigVRIT+6VjM1NwL4ye7ClP2pRpWLskgBas=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OlX0+C2OAautghSpOM8E64pgptXfqaZ+n0NekJ1JJKqA6gLPBdv906tDNn4Lgl8JX
	 45tOfmXG1TGmiOb0N7hn0F2pkaZ0y4roeKk6II5roELroSAkWNmIljF6xnAAHYY1C6
	 s+yMq2Wxp6f4zrXXT2fx5LuIMkECYZCZ0VyhkdKLceD309GFl0Xa7WsvkP85NOVdhV
	 HIHVr6iY2JtdyZBZrBGPPaWp1Kd4FYeARzKdg+kgWQou4/gikLQET1jniTLW/JHpJx
	 dj9N4SJ2BYjLg/xpg1kCv6gje3B0lRvjGYVbY8M+cjeQQ+LUACv+YVw+mUqARIr1K4
	 F1Tv+/kv9g+Hg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E782917E091A;
	Mon, 14 Sep 2026 13:39:09 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Mon, 14 Sep 2026 13:38:49 +0200
Subject: [PATCH v12 03/24] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-mt8196-ufs-v12-3-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
In-Reply-To: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
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
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789385943; l=2407;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=2uW9ZmL2dUd2ijjEcXjW25ZrX/C9ujwAw0nz3p3HPkk=;
 b=b/gsxIf4usCbuYoePBbDUFjbYW0pBZkCoHNaZIjPP7XQ5LOyNEGQQ7ESLNETQSddF7CgSQdDq
 Ols7obny22QAreBmQatoOXjSKw1/FG4NyCf3PstSkHBb7bC66s2Jwb6
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
2.55.0

