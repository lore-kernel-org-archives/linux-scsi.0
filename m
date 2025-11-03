Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9076B285C8D;
	Mon,  3 Nov 2025 02:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762138121; cv=none; b=nUNkczOyrD4j6l282xjCuWx+UlehUtv/4dVoIqeiWOM4q15y7EPd2IU4UTvuHHR36BqE3cj5lWyxAgBmBAS7It7DrQVIeI0bEHRI6QUXxSIuNyt+d/ako1rAlUBovRzfpJRQvWVxB1Q/tsSRzOkH/PWIs1JcZA7sQr/jlhFsAho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762138121; c=relaxed/simple;
	bh=4NyDXoemm0QScGMxO2aYuLcfNUm1PyUZc4BrYp0m7as=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hp2IwjJWREgTenYg8P6PTt5ycZqsnU60BdHef32L8aPWpYRDSpc6J8wFEsSkcn4prdemKbgwHB8iF7yw89THP71mju0qDeJZbV112eFjnKiDQevY888tv2JxPFdul6BztVuBPuvd4bhR/t161Yx7o4lweTSPNLxmNsDDGUwtKuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=C1KSSDo9; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="C1KSSDo9"
X-UUID: 9681d242b85f11f0b33aeb1e7f16c2b6-20251103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=wI3KVeuMyrhq5/O2srP1k4wZ7VJIeNSmNRwqJ/uquS0=;
	b=C1KSSDo9Z83WBCYei3EeKuhK4MJ/kzYkIvpSrzPJDgDJBoTkMh7no9yRdlYCQJPv7pJEUCjclpDDLdnHOSVOTQenChFQLrr9jXaIDp+d1MhndVhmQAEflO+HAEhBWzJg2zsnZkw3hp3zc8JnyubA90qigNDaw2zn+Tew9uIXzb8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:0e40bd71-519d-46e1-b22f-fcd76bcd213b,IP:0,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:61b40de0-3890-4bb9-a90e-2a6a4ecf6c66,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:11|97|99|83|106|1,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9681d242b85f11f0b33aeb1e7f16c2b6-20251103
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 652736813; Mon, 03 Nov 2025 10:48:33 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 3 Nov 2025 10:48:26 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 3 Nov 2025 10:48:26 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<robh@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<lgirdwood@gmail.com>, <broonie@kernel.org>, <matthias.bgg@gmail.com>,
	<angelogioacchino.delregno@collabora.com>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>, <wenst@chromium.org>,
	<conor.dooley@microchip.com>, <chu.stanley@gmail.com>,
	<chun-hung.wu@mediatek.com>, <peter.wang@mediatek.com>,
	<alice.chao@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<chunfeng.yun@mediatek.com>
Subject: [PATCH v2] dt-bindings: ufs: mediatek: Update maintainer information in mediatek ufs and phy
Date: Mon, 3 Nov 2025 10:47:26 +0800
Message-ID: <20251103024831.3663689-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Replace Stanley Chu with me and Chaotian in the maintainers field,
since his email address is no longer active.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml | 3 ++-
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
index 3e62b5d4da61..6e2edd43fc2a 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
@@ -8,8 +8,9 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: MediaTek Universal Flash Storage (UFS) M-PHY
 
 maintainers:
-  - Stanley Chu <stanley.chu@mediatek.com>
   - Chunfeng Yun <chunfeng.yun@mediatek.com>
+  - Peter Wang <peter.wang@mediatek.com>
+  - Chaotian Jing <chaotian.jing@mediatek.com>
 
 description: |
   UFS M-PHY nodes are defined to describe on-chip UFS M-PHY hardware macro.
diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 1dec54fb00f3..15c347f5e660 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Mediatek Universal Flash Storage (UFS) Controller
 
 maintainers:
-  - Stanley Chu <stanley.chu@mediatek.com>
+  - Peter Wang <peter.wang@mediatek.com>
+  - Chaotian Jing <chaotian.jing@mediatek.com>
 
 properties:
   compatible:
-- 
2.45.2

