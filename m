Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F824A68B8;
	Thu,  1 Oct 2026 08:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790842935; cv=none; b=rBuFkw2R6dfPqOa3disN1OpSjN94C3tg+c0vmxlaozChodJXpFOByKdqh1+xOvajB3aWvSAlBYToG2SIzSn5F5NuoLvxB4vHAZGAy7V0Vr+dRTBeC6bGallBCOYMDwZ22W1chD2DTP0O8aygH/o6Y/A+eM+ekLF1uGPk7K5qnWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790842935; c=relaxed/simple;
	bh=Rbn2DtEXFlBEWZDcTzb5theeUJW+mynrwXMS+uXDbVA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i4MQSuhZGe528xxfcUIdCtm7aMOcOR5E+ffcOnJuV1488wHwtHkV4WY6UlikkOZuAXhhk5PUagmLnnrIWJNhIevSFu4vJuscdSqOCrhpRRSNMXaLHUQ7sN5XKQx8WI2uKovn03DmsYHt0omVDNUqWYCqLygW+2YnIay3RD1xufQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=qe2npKBc; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="qe2npKBc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1790842921;
	bh=Rbn2DtEXFlBEWZDcTzb5theeUJW+mynrwXMS+uXDbVA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qe2npKBcArCOiTEfjdNAVDmHvFWy9JKBq45H9xLN5Q/WGj7cX4PbzreySlGPUJzH/
	 ATkpAMBWk0FfOhU7bATY4fijkxeo+zk2DyJ4Wu8XnqpnAHmA+2bKGdEcVBs6VoOR42
	 LbXa2vE2CEBoS0TcWktB/fiAtOR6iutpZr7Jo+WIt1hw6zqToJi2KpMCiFjKHJxNa3
	 qSXvuZxhWUDIUuyUlzy4XS8f2ffogZJF+camOYWb+OvEO0fVEoD69HbGQOxIUOiZxH
	 7XP5U+dWtXryiapZTS2WUypyikNsiqnQ8KYVwaMBVgyLhCeGcODX6raQAO6y7+JdgT
	 /nXgnbYYyDivQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9826617E056B;
	Thu, 01 Oct 2026 10:22:00 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 01 Oct 2026 10:21:34 +0200
Subject: [PATCH v13 02/24] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-mt8196-ufs-v13-2-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
In-Reply-To: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790842918; l=7040;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=tsSjem3nD/R00+JjWfBrSonrxAzR8P3GQQSGkAiEcwA=;
 b=Xw47aWJlS2LUTfWUY6c5juxvVhfT4A4h5Tg4r3tGayZzzHCxe+pKyl9hkUQhgmk/Zlpogzlee
 gaElpFliPEtBy0Wl9kgT+siszr+3/sgh0eELQ7VgkZHS3C3ma0jxo8Y
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

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
the rx_symbol ones, as they're internal to the SoC and should always
be present, and should therefore not be omitted.

MT8192 gets to have at least 3 clocks, as these were the ones I could
quickly confirm from a glance at various trees. I can't say this was an
exhaustive search though, but it's better than the current situation.

Properly document all supplies, with which pin name on the SoCs they
supply. Complete the example with them.

Also add a MT8195 example to the binding, using supply labels that I am
pretty sure would be the right ones for e.g. the Radxa NIO 12L.

Finally, remove the 'ufs_' prefix from all clock names containing it
and rename 'ufs' clock to 'main'.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 115 +++++++++++++++++----
 1 file changed, 96 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 15c347f5e660..945cb986b06b 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -19,11 +19,25 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 8
+    maxItems: 10
 
   clock-names:
     minItems: 1
-    maxItems: 8
+    items:
+      - const: main
+      - const: aes
+      - const: tick
+      - const: unipro_sysclk
+      - const: unipro_tick
+      - const: unipro_mp_bclk
+      - const: tx_symbol
+      - const: mem_sub
+      - const: rx_symbol0
+      - const: rx_symbol1
+
+  operating-points-v2: true
+
+  freq-table-hz: false
 
   phys:
     maxItems: 1
@@ -31,8 +45,36 @@ properties:
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
@@ -54,29 +96,41 @@ allOf:
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
-            - const: ufs
-            - const: ufs_aes
-            - const: ufs_tick
-            - const: unipro_sysclk
-            - const: unipro_tick
-            - const: unipro_mp_bclk
-            - const: ufs_tx_symbol
-            - const: ufs_mem_sub
-    else:
+            - const: main
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
         clock-names:
-          items:
-            - const: ufs
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
+          minItems: 10
+        clock-names:
+          minItems: 10
+        avdd09-supply: false
 
 examples:
   - |
@@ -94,9 +148,32 @@ examples:
             phys = <&ufsphy>;
 
             clocks = <&infracfg_ao CLK_INFRA_UFS>;
-            clock-names = "ufs";
-            freq-table-hz = <0 0>;
+            clock-names = "main";
 
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
+                 <&infracfg_ao 54>, <&infracfg_ao 55>, <&infracfg_ao 56>,
+                 <&infracfg_ao 90>, <&infracfg_ao 93>, <&topckgen 212>,
+                 <&topckgen 215>;
+        clock-names = "main", "aes", "tick", "unipro_sysclk", "unipro_tick",
+                      "unipro_mp_bclk", "tx_symbol", "mem_sub", "rx_symbol0",
+                      "rx_symbol1";
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
2.55.0

