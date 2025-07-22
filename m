Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31462D9EDD;
	Tue, 22 Jul 2025 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753174673; cv=none; b=Kb7H9xhXdcnpYrNAcUksQWDyamokVALTM59aiH9/oTFcyxnt5TAhFtHoE3En6rBUbz25tTHco16PJZmzsu5vo0Kas15w44mDJEDDQWXD85gwf1yjBznFFUQ88aLdLNgISNdqIH2YXb4SJEJyTKRoaYCu7s/B3JhGAnCqAnK3UgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753174673; c=relaxed/simple;
	bh=Sp8lWPsikUC57yu8J606FlIkaIy/0ubDMpbf6WukWFo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AShO5qb0VmAFKqSFE9I968EMwN7cKMJeFUNVTu+xNlDKxnWrFRxvNbd78KfsCpnZ0GhjCMUvMvMaTLIVargFg+Bh7u6zBG8OkbRFLSUetAEJqS24w+xh/x3S3a3Vs9AqBWuVRMxelI3KQLk9U0/sphCjyHJAFOjHNzoG+Sv2nB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WNxFC8J3; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WNxFC8J3"
X-UUID: ebe67fc666d911f08b7dc59d57013e23-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=3R1eimp2sVIaoNWgM9ROE/GHiObjuM6mSUl62HDbHkw=;
	b=WNxFC8J34uAD/cnf5awdv75YsHKUebD/PNq/HTmaefrzYSDNlb0dU/KSglWpYDMMM+/6oxOktScWJ9moWYdkSVx5p30YySlRpbmUpdks1bRl24FejLvVk3MgUClTjFvIc/xDCY1DhA/V4+r1QWqLX4RZ0TFlSXaNtsTWR8pLMuk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:2bed02e7-3ca5-4f48-ad8d-f846a6f34895,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:9eb4ff7,CLOUDID:1b641f50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ebe67fc666d911f08b7dc59d57013e23-20250722
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 81661351; Tue, 22 Jul 2025 16:57:40 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 16:57:36 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 16:57:36 +0800
From: Macpaul Lin <macpaul.lin@mediatek.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Peter Wang
	<peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>
CC: Bear Wang <bear.wang@mediatek.com>, Pablo Sun <pablo.sun@mediatek.com>,
	Ramax Lo <ramax.lo@mediatek.com>, Macpaul Lin <macpaul.lin@mediatek.com>,
	Macpaul Lin <macpaul@gmail.com>, MediaTek Chromebook Upstream
	<Project_Global_Chrome_Upstream_Group@mediatek.com>
Subject: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195 compatible and update clock nodes
Date: Tue, 22 Jul 2025 16:57:19 +0800
Message-ID: <20250722085721.2062657-3-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

Add MT8195 UFSHCI compatible string.
Relax the schema to allow between one to eight clocks/clock-names
entries for all MediaTek UFS nodes. Legacy platforms may only need
a few clocks, whereas newer devices such as the MT8195 require
additional clock-gating domains. For MT8195 specifically, enforce
exactly eight clocks and clock-names entries to satisfy its hardware
requirements.

Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml | 42 ++++++++++++++++---
 1 file changed, 36 insertions(+), 6 deletions(-)

Changes for v2:
 - Remove duplicate minItems and maxItems as suggested in the review.
 - Add a description of how the MT8195 hardware differs from earlier
   platforms.

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 20f341d25ebc..1dec54fb00f3 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -9,21 +9,20 @@ title: Mediatek Universal Flash Storage (UFS) Controller
 maintainers:
   - Stanley Chu <stanley.chu@mediatek.com>
 
-allOf:
-  - $ref: ufs-common.yaml
-
 properties:
   compatible:
     enum:
       - mediatek,mt8183-ufshci
       - mediatek,mt8192-ufshci
+      - mediatek,mt8195-ufshci
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 8
 
   clock-names:
-    items:
-      - const: ufs
+    minItems: 1
+    maxItems: 8
 
   phys:
     maxItems: 1
@@ -47,6 +46,37 @@ required:
 
 unevaluatedProperties: false
 
+allOf:
+  - $ref: ufs-common.yaml
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - mediatek,mt8195-ufshci
+    then:
+      properties:
+        clocks:
+          minItems: 8
+        clock-names:
+          items:
+            - const: ufs
+            - const: ufs_aes
+            - const: ufs_tick
+            - const: unipro_sysclk
+            - const: unipro_tick
+            - const: unipro_mp_bclk
+            - const: ufs_tx_symbol
+            - const: ufs_mem_sub
+    else:
+      properties:
+        clocks:
+          maxItems: 1
+        clock-names:
+          items:
+            - const: ufs
+
 examples:
   - |
     #include <dt-bindings/clock/mt8183-clk.h>
-- 
2.45.2

