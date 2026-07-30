Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE32541A922;
	Thu, 30 Jul 2026 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405035; cv=none; b=pF8rpzqhjh09rnrTjoQTCpFCiYJVZzWNCpQsBeZ3F2+z15g35bSiDKapJyajLc38ceD16Oy01kQGEI1Bl2bd9sEI5/7Kb8TYc6hVXzF9MzvejI3vA4AxCiyzty6B9i/Kbe9x53CPbrgpyb7ZsCQxH07hup/AAvtbdl1BmY+4yqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405035; c=relaxed/simple;
	bh=OziOb+FsEmp5/9DGqnKkZWUGGpg9PAiZr6kaXN8cN5g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MvUYgJOKvMUlC6uawNcnzVqnQP8sDzCLIOWuSxlwXuu+YapC8KkzggPvx/sPeLiVmoLOsRopJMjYtrTvRl2SOEpUlxN9Zk8mYrj+bWq46Ff39GE8XSSkns06Bg2bd1sr///VK9vmhB6UiYkFMOlltxahIHu6NZE+d2DmG/o9xL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=gHWixjy0; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="gHWixjy0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405031;
	bh=OziOb+FsEmp5/9DGqnKkZWUGGpg9PAiZr6kaXN8cN5g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gHWixjy0VGFdmf4AlcH5nxADZAxDYkpBWYrDlnXSwgZy0L8OyN8PRfJT1cHf4aLWz
	 2zdTwXihjyZgwYqoMccxIkDv0Dk291qZa7FHfOfjLf5+gCUe/z1WbtP1BCaFbvmV+I
	 Hn3Eix7//jedtOgAVjPCMjxzr7BE3HNuXCs0ul5SnoHfWtMXQc9IpdgY4UeLbaLTZ+
	 4kmsDUTplrHQpQ8i+HhI/GKu6rDtKcH9M8TxDLMjP8xb1iKVKMkP+QX12/wrUfKsGE
	 F3AFBZeA5sINygUiZRHecW3zcyRHbO/5mVrP7QZNorpvfmB/gtOmgi7BMIi9M8S5Vm
	 N1+jl3YNjasbg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9025017E0984;
	Thu, 30 Jul 2026 11:50:30 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:20 +0200
Subject: [PATCH v10 24/26] arm64: dts: mediatek: mt8195: Align ufshci node
 to dt-bindings changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-24-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
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
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=2310;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=OziOb+FsEmp5/9DGqnKkZWUGGpg9PAiZr6kaXN8cN5g=;
 b=WvQIc7rx7/cUucLoeSpzM/mTXZPNa2xB23FKnfB/OWX2CUe5WCaxrDNGO/a3vjhSJoAEy8CX0
 sM1DrQFr7tKDG+oSjdZ6qzC03261GP54OyrJ4CECHDrFh+FdyAXx4rH
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

The MT8195 UFS host controller dt bindings now describe several extra
required clocks that were previously missing from clock description
and deprecates the freq-table-hz property use in favour of
operating-points-v2 instead.

Currently, the ufshci node declares the freq-table-hz property but all
values contained in the array are zero, thus converting it to an OPP
table is not needed.

So, add in ufshci node the rx_symbol clocks in clock list and remove
freq-table-hz property.
Also reorder properties in node.

Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 9aaf8b6edcb5..5ff7b7e543b7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1472,8 +1472,7 @@ mmc2: mmc@11250000 {
 		ufshci: ufshci@11270000 {
 			compatible = "mediatek,mt8195-ufshci";
 			reg = <0 0x11270000 0 0x2300>;
-			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH 0>;
-			phys = <&ufsphy>;
+
 			clocks = <&infracfg_ao CLK_INFRA_AO_AES_UFSFDE>,
 				 <&infracfg_ao CLK_INFRA_AO_AES>,
 				 <&infracfg_ao CLK_INFRA_AO_UFS_TICK>,
@@ -1481,15 +1480,15 @@ ufshci: ufshci@11270000 {
 				 <&infracfg_ao CLK_INFRA_AO_UNIPRO_TICK>,
 				 <&infracfg_ao CLK_INFRA_AO_UFS_MP_SAP_B>,
 				 <&infracfg_ao CLK_INFRA_AO_UFS_TX_SYMBOL>,
-				 <&infracfg_ao CLK_INFRA_AO_PERI_UFS_MEM_SUB>;
-			clock-names = "ufs", "ufs_aes", "ufs_tick",
-					"unipro_sysclk", "unipro_tick",
-					"unipro_mp_bclk", "ufs_tx_symbol",
-					"ufs_mem_sub";
-			freq-table-hz = <0 0>, <0 0>, <0 0>,
-					<0 0>, <0 0>, <0 0>,
-					<0 0>, <0 0>;
-
+				 <&infracfg_ao CLK_INFRA_AO_PERI_UFS_MEM_SUB>,
+				 <&topckgen CLK_TOP_UFS_RX_SYMBOL>,
+				 <&topckgen CLK_TOP_UFS_RX_SYMBOL1>;
+			clock-names = "main", "aes", "tick", "unipro_sysclk",
+				      "unipro_tick", "unipro_mp_bclk",
+				      "tx_symbol", "mem_sub", "rx_symbol0",
+				      "rx_symbol1";
+			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH 0>;
+			phys = <&ufsphy>;
 			mediatek,ufs-disable-mcq;
 			status = "disabled";
 		};

-- 
2.55.0

