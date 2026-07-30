Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4148D3F8257;
	Thu, 30 Jul 2026 09:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405038; cv=none; b=WsNGWWGXC4qOVLvUM3v4u9qbmzUX0NMaqdEysg7IGn93QeglHvt5FXMumSdNlYSJNEIQWBv/yxk1DL+gy2TZ3sZUBfskRRFAObE8TsXJO9JqYxkRhMtrbw+mSBfssK/+cXXiUARvuMWofUct2Jf1aQRn3LVOgStUB+gTUzJnjEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405038; c=relaxed/simple;
	bh=Iy+VUNXDXW8cWtqhoAcajkOwEmooMeEJCbxXu8rQQOs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=clI7anLNu6f3mWkLb3gw8hjR2bcgJXZsTfH8rdjrfOMqE6foLtTRhGb5C7OErRJHLaQKJXylrIO8KMRpLUBpezLE7xFJA43UQQLmopj3xHprh2rAI2xPA3QDpHmmsviKKRalOBDRWmF4OEDRRCaSMQWCk8AdINa1P5A4fVt4vz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=M6A4pMj0; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="M6A4pMj0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405035;
	bh=Iy+VUNXDXW8cWtqhoAcajkOwEmooMeEJCbxXu8rQQOs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=M6A4pMj0Y651VoP4qsk/HDYB/ouyltMMEHBOvKK9lHthj5nv8IXPVDFRk2bgEvAzh
	 TLtG9k348dUPiIVbZM32DdvpJp9IcAX/l16UunCDOA8WGXCrp18n1N4oyZeZwFBKeY
	 JI1BQKsk+4xzPS3oD6bkHO9sFlGPUg9cauj7xHUpecWIpCTWHZA8AL1XwYmL67/jQd
	 mqfTNGP9z35Y0DMxSeKdyR4v/Gtt59r4WtfUcZXgnMCsSdUUz1Q7lWRHIVOaOYJh7v
	 4ruu9sqUGRvGVdm5H3aAGcnxhbHT9nRNQpai1qBqFu1W/PixDtYetazgXaC/TVKUI8
	 6USFxtDjvJVMg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9F4B917E098E;
	Thu, 30 Jul 2026 11:50:33 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:22 +0200
Subject: [PATCH v10 26/26] arm64: dts: mediatek: mt8395-radxa-nio-12l:
 Complete UFS power supplies
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-26-bc5ecef202dc@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=1050;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=Iy+VUNXDXW8cWtqhoAcajkOwEmooMeEJCbxXu8rQQOs=;
 b=nfGWRi3J0wIO/+Y7GAM+mdM1gCNAi3C9pUwoyTTwK7WSjCpqpHJvmMMAKGcHa72Wmt1UJfVur
 t2UKOFrQ/cyAjk+U/ua73w5EYRl9WXBbbX0XvsHxQdcwIDscy6XTe8V
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

The MT8195 UFS host controller dt binding now describes the power supplies
feeding the host controller, that were previously missing from supply
description.

So, add in the Radxa NIO-12L board devicetree the regulators used to
power MT8395 UFS controller on the board.

Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
index 9cf0315da035..7e9cabdd2825 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
@@ -1184,6 +1184,9 @@ &uart1 {
 };
 
 &ufshci {
+	avdd12-supply = <&mt6359_vrf12_ldo_reg>;
+	avdd12-ckbuf-supply = <&mt6359_vbbck_ldo_reg>;
+	avdd18-supply = <&mt6359_vio18_ldo_reg>;
 	vcc-supply = <&mt6359_vemc_1_ldo_reg>;
 	vccq2-supply = <&mt6359_vufs_ldo_reg>;
 	status = "okay";

-- 
2.55.0

