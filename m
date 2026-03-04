Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40553B3C1E;
	Wed,  4 Mar 2026 14:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636055; cv=pass; b=coltuv6DieZMweY1nAnr+qX85+4cN+rBegwFVeQ20MxBNTF7zw2Q7wS5AmoDhq03UYZEOE6x0eI8SwcZWSM0VTe/jfgV7xArbkNUIag79Uz2KxPp5ijsXng7+roNxjO5Mi+9LtF2TDirNSyu9nO1VaHWIuP/TeQV91oT3J9kDp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636055; c=relaxed/simple;
	bh=bE8Xjdh+qD2hKCVS3R6Ibjmp6FN47WTS4rwoXhIkxfM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rLRRlLDUpNmlH0fFBfrRmhDizAnvqoMF+b2twizyoDTuaBZEvyEp0HrLBlxCVbg1sbFSwPwQJvtxZQK1BwC27S2izQu/BPjFLoX7bwNo3oP2Vf4ubtkgFXTN6j4Jufz8lN7tvPOQTtmc7WnVtxMYOITeDwoGwpt4qBqGNR9R760=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=g4jTD4l0; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="g4jTD4l0"
ARC-Seal: i=1; a=rsa-sha256; t=1772636022; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=b2o+YSmtKQ2KEfZgRhtWGUucUnQ3micjgG/cboq0xIz9ieJXTGxHTpEXp+AInGslV2lczIXfatiEqgv1JYPjCdEORW8ciXj/YX+YLtLak0xBtYNcjYxE2yROx9u4++Skw3BkH9hsYlBYpdUhQBfRvhQ615tWu+mbT8pymoOOcf4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772636022; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qu2Q6/LCZyt91jxZTOJF6/yJsqMfQ4a6hX3+v18jMDA=; 
	b=cqbDKZvr17xbwccrMbWfoeAmHJ1nji4Bg/zYr7/Li1RqNRSuQhlBMyTKmad5s/wtTNwWSoYxNOQrkZIFTo5bBg5gn5xI7XiSI7nnarxbi9zrEVo93EXcrQuDPn0gyE6OqXuhAfvcQ6rnKcS3O9EgwnXgci8d9NwRs4C2gmLs/Hw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772636022;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=qu2Q6/LCZyt91jxZTOJF6/yJsqMfQ4a6hX3+v18jMDA=;
	b=g4jTD4l0jHugO/lMY2CPUUsAa/G2CizeHGFV3hackIYXFaohO9JVdwJd8VHXk8zc
	qUVYPk1zACL4e7psbgn5pmrZDyks5YWCHGM8IBu1PiXQrDOiJKJ4JvpEqH2Uc9Br8PE
	3YQ4dqB0RCnijKbMTOAIiLcjkG3UVFKkY6+EGcJQ=
Received: by mx.zohomail.com with SMTPS id 1772636019904730.5079693332189;
	Wed, 4 Mar 2026 06:53:39 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Wed, 04 Mar 2026 15:53:07 +0100
Subject: [PATCH v8 02/23] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-mt8196-ufs-v8-2-5b0eac23314f@collabora.com>
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

As it stands, the mediatek,ufs.yaml binding is startlingly incomplete.
Its one example, which is the only real "user" of this binding in
mainline, uses the deprecated freq-table-hz property.

The resets, of which there are three optional ones, are completely
absent.

The clock description for MT8195 is incomplete, as is the one for
MT8192. It's not known if the one clock binding for MT8183 is even
correct, but I do not have access to the necessary code and
documentation to find this out myself.

The power supply situation is not much better; the binding describes one
required power supply, but it's the UFS card supply, not any of the
supplies feeding the controller silicon.

No second example is present in the binding, making verification
difficult.

Disallow freq-table-hz and move to operating-points-v2. It's fine to
break compatibility here, as the binding is currently unused and would
be impossible to correctly use in its current state.

Add the three resets and the corresponding reset-names property. These
resets appear to be optional, i.e. not required for the functioning of
the device.

Move the list of clock names out of the if condition, and expand it for
the confirmed clocks I could find by cross-referencing several clock
drivers. For MT8195, increase the minimum number of clocks to include
the crypt and rx_symbol ones, as they're internal to the SoC and should
always be present, and should therefore not be omitted.

MT8192 gets to have at least 3 clocks, as these were the ones I could
quickly confirm from a glance at various trees. I can't say this was an
exhaustive search though, but it's better than the current situation.

Properly document all supplies, with which pin name on the SoCs they
supply. Complete the example with them.

Also add a MT8195 example to the binding, using supply labels that I am
pretty sure would be the right ones for e.g. the Radxa NIO 12L.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 117 ++++++++++++++++++---
 1 file changed, 100 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 15c347f5e660..e0aef3e5f56b 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -19,11 +19,28 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 8
+    maxItems: 13
 
   clock-names:
     minItems: 1
-    maxItems: 8
+    items:
+      - const: ufs
+      - const: ufs_aes
+      - const: ufs_tick
+      - const: unipro_sysclk
+      - const: unipro_tick
+      - const: unipro_mp_bclk
+      - const: ufs_tx_symbol
+      - const: ufs_mem_sub
+      - const: crypt_mux
+      - const: crypt_lp
+      - const: crypt_perf
+      - const: ufs_rx_symbol0
+      - const: ufs_rx_symbol1
+
+  operating-points-v2: true
+
+  freq-table-hz: false
 
   phys:
     maxItems: 1
@@ -31,8 +48,36 @@ properties:
   reg:
     maxItems: 1
 
+  resets:
+    items:
+      - description: reset for the UniPro layer
+      - description: reset for the cryptography engine
+      - description: reset for the host controller
+
+  reset-names:
+    items:
+      - const: unipro
+      - const: crypto
+      - const: hci
+
+  avdd09-supply:
+    description: Phandle to the 0.9V supply powering the AVDD09_UFS pin
+
+  avdd12-supply:
+    description: Phandle to the 1.2V supply powering the AVDD12_UFS pin
+
+  avdd12-ckbuf-supply:
+    description: Phandle to the 1.2V supply powering the AVDD12_CKBUF_UFS pin
+
+  avdd18-supply:
+    description: Phandle to the 1.8V supply powering the AVDD18_UFS pin
+
   vcc-supply: true
 
+  vccq-supply: true
+
+  vccq2-supply: true
+
   mediatek,ufs-disable-mcq:
     $ref: /schemas/types.yaml#/definitions/flag
     description: The mask to disable MCQ (Multi-Circular Queue) for UFS host.
@@ -54,29 +99,41 @@ allOf:
       properties:
         compatible:
           contains:
-            enum:
-              - mediatek,mt8195-ufshci
+            const: mediatek,mt8183-ufshci
     then:
       properties:
         clocks:
-          minItems: 8
+          maxItems: 1
         clock-names:
           items:
             - const: ufs
-            - const: ufs_aes
-            - const: ufs_tick
-            - const: unipro_sysclk
-            - const: unipro_tick
-            - const: unipro_mp_bclk
-            - const: ufs_tx_symbol
-            - const: ufs_mem_sub
-    else:
+        avdd12-ckbuf-supply: false
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt8192-ufshci
+    then:
       properties:
         clocks:
-          maxItems: 1
+          minItems: 3
+          maxItems: 3
+        clocks-names:
+          minItems: 3
+          maxItems: 3
+        avdd09-supply: false
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt8195-ufshci
+    then:
+      properties:
+        clocks:
+          minItems: 13
         clock-names:
-          items:
-            - const: ufs
+          minItems: 13
+        avdd09-supply: false
 
 examples:
   - |
@@ -95,8 +152,34 @@ examples:
 
             clocks = <&infracfg_ao CLK_INFRA_UFS>;
             clock-names = "ufs";
-            freq-table-hz = <0 0>;
 
             vcc-supply = <&mt_pmic_vemc_ldo_reg>;
         };
     };
+  - |
+    ufshci@11270000 {
+        compatible = "mediatek,mt8195-ufshci";
+        reg = <0x11270000 0x2300>;
+        interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
+        phys = <&ufsphy>;
+        clocks = <&infracfg_ao 63>, <&infracfg_ao 64>, <&infracfg_ao 65>,
+                 <&infracfg_ao 54>, <&infracfg_ao 55>,
+                 <&infracfg_ao 56>, <&infracfg_ao 90>,
+                 <&infracfg_ao 93>, <&topckgen 60>, <&topckgen 152>,
+                 <&topckgen 125>, <&topckgen 212>, <&topckgen 215>;
+        clock-names = "ufs", "ufs_aes", "ufs_tick",
+                      "unipro_sysclk", "unipro_tick",
+                      "unipro_mp_bclk", "ufs_tx_symbol",
+                      "ufs_mem_sub", "crypt_mux", "crypt_lp",
+                      "crypt_perf", "ufs_rx_symbol0", "ufs_rx_symbol1";
+
+        operating-points-v2 = <&ufs_opp_table>;
+
+        avdd12-supply = <&mt6359_vrf12_ldo_reg>;
+        avdd12-ckbuf-supply = <&mt6359_vbbck_ldo_reg>;
+        avdd18-supply = <&mt6359_vio18_ldo_reg>;
+        vcc-supply = <&mt6359_vemc_1_ldo_reg>;
+        vccq2-supply = <&mt6359_vufs_ldo_reg>;
+
+        mediatek,ufs-disable-mcq;
+    };

-- 
2.53.0

