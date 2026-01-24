Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645BC2DC763;
	Sat, 24 Jan 2026 12:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769256131; cv=pass; b=OC17JbbX13pqqIAGxnS0DXDYNh+a76HqDXUBqwATW15dPdZ7CdA7rEA6sxD8IXxqri0mKbivhBKqZRc2At1rM+jvk4WWzmbPshyLmt96zVpEHc2V/QUMjpoERiAtlnU63J3cTFuh46XWqg8EZ/iLUAW4ybpCcklguo1q/VSh7v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769256131; c=relaxed/simple;
	bh=Tk0oAS6OhREK6lUdo3KbLA7MC7i6rRFzjAfUWj2AeYk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DOsSsdZD5EwzuWIVBGRgj9jflfd5+ALfym+vl6WFaV30nxLyiOdFGPHjGPqOcfKFR7pu1qJfynJe21apdHJlCj4AsPQuXVY3nh+TJj3cnEC0cOAxEObQs03phkxNRcXjQi/jcAZzpQF6q5AVy2yQ7ZhxSOikQ7nFE1mFREqo1Dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=TpyCgCS+; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="TpyCgCS+"
ARC-Seal: i=1; a=rsa-sha256; t=1769256090; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=id5lW9V5YFhUHsbFNwXzvjY4/Cnpl6LoWO54l0uo1hKOzc7GCjt3VeL3P0QAo5T7fa/gRt7BABubNRLPsOqaXljvRtrTzO3bpYGftStqgUCCSTC3EPTZpn8fRmXl6zxTpbeK2gaKbG6erAXH+8qNe9XJQgIBdOdLnollrqzWhuo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769256090; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FX729w6H6Nqv4wBPOyEK7eBO51Uitkvy4i1Pv/OOpY4=; 
	b=CLJPlYMuK+EBiiw/5qcvv/tHorMK7IhD6xID8pTBVWqCS4DML+HhaQRNoVTHl9xIqbE+ihOqv8grbM4GG8fjqss54/orXH4CLEj7299absbGhnXzU3s4aRyFEC35u/ktHRL0Bme9m7HvvbOOAJju02q8pFac/PzXb65BesudHI0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769256090;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=FX729w6H6Nqv4wBPOyEK7eBO51Uitkvy4i1Pv/OOpY4=;
	b=TpyCgCS+399PKYIen3EuUrqU5ApCSqRLIBTANQKzf0zJIreYm5G2ENINfriZj2Vh
	r0LIxXoKYNvsBZgYAcc6MmYXGqbl4zdEDxe5YJ2P5ILqY94jpRUt+F8/2nxY1IMRlNo
	PnXzp1rxujYxJgGUgBmVfhM3WZAEP3iwGbGClX0M=
Received: by mx.zohomail.com with SMTPS id 176925608864459.57718916928752;
	Sat, 24 Jan 2026 04:01:28 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Sat, 24 Jan 2026 13:00:49 +0100
Subject: [PATCH v6 03/24] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260124-mt8196-ufs-v6-3-e7c005b60028@collabora.com>
References: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
In-Reply-To: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
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

The MediaTek MT8196 SoC's UFS controller uses three additional clocks
compared to the MT8195, and a different set of supplies. It is therefore
not compatible with the MT8195.

While it does have a AVDD09_UFS_1 pin in addition to the AVDD09_UFS pin,
it appears that these two pins are commoned together, as the board
schematic I have access to uses the same supply for both, and the
downstream driver does not distinguish between the two supplies either.

Add a compatible for it, and modify the binding correspondingly.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 58 +++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index e0aef3e5f56b..a82119ecbfe8 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -16,10 +16,11 @@ properties:
       - mediatek,mt8183-ufshci
       - mediatek,mt8192-ufshci
       - mediatek,mt8195-ufshci
+      - mediatek,mt8196-ufshci
 
   clocks:
     minItems: 1
-    maxItems: 13
+    maxItems: 16
 
   clock-names:
     minItems: 1
@@ -37,6 +38,9 @@ properties:
       - const: crypt_perf
       - const: ufs_rx_symbol0
       - const: ufs_rx_symbol1
+      - const: ufs_sel
+      - const: ufs_sel_min_src
+      - const: ufs_sel_max_src
 
   operating-points-v2: true
 
@@ -131,9 +135,27 @@ allOf:
       properties:
         clocks:
           minItems: 13
+          maxItems: 13
         clock-names:
           minItems: 13
+          maxItems: 13
         avdd09-supply: false
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt8196-ufshci
+    then:
+      properties:
+        clocks:
+          minItems: 16
+          maxItems: 16
+        clock-names:
+          minItems: 16
+          maxItems: 16
+        avdd18-supply: false
+      required:
+        - operating-points-v2
 
 examples:
   - |
@@ -183,3 +205,37 @@ examples:
 
         mediatek,ufs-disable-mcq;
     };
+  - |
+    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ufshci@16810000 {
+        compatible = "mediatek,mt8196-ufshci";
+        reg = <0x16810000 0x2a00>;
+        interrupts = <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>;
+
+        clocks = <&ufs_ao_clk 6>, <&ufs_ao_clk 7>, <&clk26m>, <&ufs_ao_clk 3>,
+                 <&clk26m>, <&ufs_ao_clk 4>, <&ufs_ao_clk 0>,
+                 <&topckgen 7>, <&topckgen 41>, <&topckgen 105>, <&topckgen 83>,
+                 <&ufs_ao_clk 1>, <&ufs_ao_clk 2>, <&topckgen 42>,
+                 <&topckgen 84>, <&topckgen 102>;
+        clock-names = "ufs", "ufs_aes", "ufs_tick", "unipro_sysclk",
+                      "unipro_tick", "unipro_mp_bclk", "ufs_tx_symbol",
+                      "ufs_mem_sub", "crypt_mux", "crypt_lp", "crypt_perf",
+                      "ufs_rx_symbol0", "ufs_rx_symbol1", "ufs_sel",
+                      "ufs_sel_min_src", "ufs_sel_max_src";
+
+        operating-points-v2 = <&ufs_opp_table>;
+
+        phys = <&ufsphy>;
+
+        avdd09-supply = <&mt6363_vsram_modem>;
+        vcc-supply = <&mt6363_vemc>;
+        vccq-supply = <&mt6363_vufs12>;
+
+        resets = <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_UNIPRO>,
+                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_CRYPTO>,
+                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFSHCI>;
+        reset-names = "unipro", "crypto", "hci";
+        mediatek,ufs-disable-mcq;
+    };

-- 
2.52.0

