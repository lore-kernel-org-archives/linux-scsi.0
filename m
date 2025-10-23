Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBAF34F27C;
	Thu, 23 Oct 2025 19:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249185; cv=pass; b=FBpqc6lZbkNg4nuFOslV/YVBFjQusiClRwU+1aObQSHe3jinIHtEyaVSBVovHdHg71nn+f4vgIRvOyOICWuaDXZvwSd2S7AZBeE4Ad9JmftCYPA6oBqaPoMchpTRNLFE66j8Z/IUEDV+Mn+tYkvkHyNKzG3HQxXEw3wRgjHQEUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249185; c=relaxed/simple;
	bh=FX4mCE+hxdcv5ECnbFRkfU3v6MiPQT7ux7M1Cx5lOCU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rFFZ7W0+4FjYnLygrsE1McoqeWHwBM09V4XJZA4u3tIa0yteSobaVE9ykuqjAJ8CKJ92uJuX2B0nnRQ+Xtqy5rdkmtqbyC8pxfTpDfTK6ZbTbXQERZzJ2Ou5G1cnIzR1UXigWvQ2mh7C+hq/l0JxGlGf1FXThSsJe457f4H6vr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=XafQMa2r; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="XafQMa2r"
ARC-Seal: i=1; a=rsa-sha256; t=1761249034; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iaxsZINZ9V/nmFPYEInr5GCpXiUH+3eOngcyKCoIxXHasb0XDkkXyh+CdHNbZqDe2Sgd9ZNzEklbGmyrE4vMNb/NKkVvCkmEfbdXTiiq04fCfpNQyZhnTFP0/GFs5OpOUXVeCek/1yRLHKm46LkOzm4E45jXa2/L6N8WLjNJlSo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249034; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=SBR6EfxFFk1L7wve5twIcSXii79qBsppsVH73aPiyUs=; 
	b=ijtYgxRvBVuPldMyfpApl/CDJtKydMmb6XmqLGbpFsDXwOABaCFn0mrwLNUtlSbvlUzHRprHGUo7TBG7hLsI/QrSxYAY6XYR41xm1SATCRixQnH+P1K66bPCJ/6C4ptE9wPjHHvNAp4mdUMkiXx2vH79M2wfLR8zPOgyCPaERMg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249034;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=SBR6EfxFFk1L7wve5twIcSXii79qBsppsVH73aPiyUs=;
	b=XafQMa2rkiNBfgCvwOX1uWbGUEOs2TQr8IqD1enCGGWO0bl1CDkpHBzkGs7BHL9F
	ImLu5Rn0O6mm5CmNBYeYd1NBQk9IJEpto7SISS5YSQtQHnqLOrmIE8UGIBDbVotJL+j
	xp1jgURj1j2vUQJzlp0wlgew7q8GntooYZDjRlnU=
Received: by mx.zohomail.com with SMTPS id 1761249032125413.17962652903566;
	Thu, 23 Oct 2025 12:50:32 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:21 +0200
Subject: [PATCH v3 03/24] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-3-0f04b4a795ff@collabora.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
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
 Mark Brown <broonie@kernel.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

The MediaTek MT8196 SoC's UFS controller uses three additional clocks
compared to the MT8195, and a different set of supplies. It is therefore
not compatible with the MT8195.

While it does have a AVDD09_UFS_1 pin in addition to the AVDD09_UFS pin,
it appears that these two pins are commoned together, as the board
schematic I have access to uses the same supply for both, and the
downstream driver does not distinguish between the two supplies either.

The pin that vcc-supply goes to is unknown; this is because the only
schematic I have access to is incomplete in this regard. However, from
experiments, I do know that the vemc supply must be turned on for UFS to
work.

Add a compatible for it, and modify the binding correspondingly.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 83 +++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 364672bc65b1..57c944fd0318 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -15,10 +15,11 @@ properties:
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
@@ -36,6 +37,9 @@ properties:
       - const: crypt_perf
       - const: ufs_rx_symbol0
       - const: ufs_rx_symbol1
+      - const: ufs_sel
+      - const: ufs_sel_min_src
+      - const: ufs_sel_max_src
 
   operating-points-v2: true
 
@@ -127,9 +131,28 @@ allOf:
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
+        vcc-supply:
+          description: Must point to a "vemc" supply, unknown which pin it feeds
+      required:
+        - operating-points-v2
 
 examples:
   - |
@@ -178,3 +201,61 @@ examples:
         vccq2-supply = <&mt6359_vbbck_ldo_reg>;
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
+        clocks = <&ufs_ao_clk 6>,
+                 <&ufs_ao_clk 7>,
+                 <&clk26m>,
+                 <&ufs_ao_clk 3>,
+                 <&clk26m>,
+                 <&ufs_ao_clk 4>,
+                 <&ufs_ao_clk 0>,
+                 <&topckgen 7>,
+                 <&topckgen 41>,
+                 <&topckgen 105>,
+                 <&topckgen 83>,
+                 <&ufs_ao_clk 1>,
+                 <&ufs_ao_clk 2>,
+                 <&topckgen 42>,
+                 <&topckgen 84>,
+                 <&topckgen 102>;
+        clock-names = "ufs",
+                      "ufs_aes",
+                      "ufs_tick",
+                      "unipro_sysclk",
+                      "unipro_tick",
+                      "unipro_mp_bclk",
+                      "ufs_tx_symbol",
+                      "ufs_mem_sub",
+                      "crypt_mux",
+                      "crypt_lp",
+                      "crypt_perf",
+                      "ufs_rx_symbol0",
+                      "ufs_rx_symbol1",
+                      "ufs_sel",
+                      "ufs_sel_min_src",
+                      "ufs_sel_max_src";
+
+        operating-points-v2 = <&ufs_opp_table>;
+
+        phys = <&ufsphy>;
+
+        avdd09-supply = <&mt6363_vsram_modem>;
+        vcc-supply = <&mt6363_vemc>;
+        vcc-supply-1p8;
+        vccq-supply = <&mt6363_va12_2>;
+        vccq2-supply = <&mt6363_vufs12>;
+
+        resets = <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_UNIPRO>,
+                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_CRYPTO>,
+                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFSHCI>;
+        reset-names = "unipro", "crypto", "hci";
+        mediatek,ufs-disable-mcq;
+    };

-- 
2.51.1.dirty

