Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC25409265;
	Thu, 30 Jul 2026 09:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405037; cv=none; b=LqCYB47NyXeIjgAWMn6MLHRt9Z22YOY18wKq1v+B46TM7B/VjHhgkXHZzkdhZAHM84FzManFMZh+voieBG1rmyZTKUeglTlrNy5fO7RWv7LjuD72ynG/FCNDqWrhWntLXPErkIhNTtvqWwp337rz8TzlmuNuNsH3x8vI2XEnurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405037; c=relaxed/simple;
	bh=u5hHq0Z8k4K50Ohjh9lwnjaZVf04Xn7H8lsSwUTpb60=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q7uvWLrPQVatYd/CAyrONf/R1WAAaLIcpQH/VQJy2j78GG1ztDzEJ3axU2S1Giz3iUBvIBzeGSaYK1klaKlbVc8WJOFCzqgyunDKqb6wl1SUO4Kunl4/O/XUd9XTinYuR/h9Yy9ARA8EfoEtNtt3mrVZ+nufxyDNT7ArygZJcek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=WlqyWKki; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="WlqyWKki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405033;
	bh=u5hHq0Z8k4K50Ohjh9lwnjaZVf04Xn7H8lsSwUTpb60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WlqyWKkifk69/EWmDfi+HWpB1XhoD2cAg0nevJvYUvrEmWssrLpq2fGu35NkFOx6q
	 8DE6Blimb5KSi4qYaHuhGOYvCKqf7ujywye/pWUIoNAOJllA4dJfWi3ffC4UG0eUC4
	 fJ6WJ1jGIqUPugT6dRgdhjZrge+iBeOeCWPBdeDAmgzdLKFwWEKgQ8eCIMCm+znCym
	 8PI/whL03m0UZmEW2EQFq1JZWWDaetDVsmXl7CKApiARDjXAGrl2MoxySJ7gZNVy5w
	 l5CwjbBc9juUjCvj3XC8Sf1LSm5E9sJVZNr+9nzr5isAMMCK3HvlX2iIdKiseuDVfh
	 6h+NrQw5oVWGw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1DA3317E0988;
	Thu, 30 Jul 2026 11:50:32 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:21 +0200
Subject: [PATCH v10 25/26] arm64: dts: mediatek: mt8395-genio-1200-evk-ufs:
 Complete UFS power supplies
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-25-bc5ecef202dc@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=1127;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=u5hHq0Z8k4K50Ohjh9lwnjaZVf04Xn7H8lsSwUTpb60=;
 b=gSQyAIf2R+VrX3AV0hyjEXVagbWC+aBQmcf+y1WYwwAnSlcQUjRZJXC3yiINIY4LCNSHzNvkh
 AB4OEJQty1RCk8BdS1BR+nMZLd/vxLhZAVbTfGooN4/qO1UiB8y77bk
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

The MT8195 UFS host controller dt binding now describes the power supplies
feeding the host controller, that were previously missing from supply
description.

So, add in the Mediatek Genio 1200-EVK board devicetree the regulators
used to power MT8395 UFS controller when the board is configured to use
its UFS storage as primary.

Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk-ufs.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk-ufs.dts b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk-ufs.dts
index e09a3ecd8773..f3d839f31918 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk-ufs.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk-ufs.dts
@@ -16,6 +16,9 @@ / {
 
 &ufshci {
 	status = "okay";
+	avdd12-supply = <&mt6359_vrf12_ldo_reg>;
+	avdd12-ckbuf-supply = <&mt6359_vbbck_ldo_reg>;
+	avdd18-supply = <&mt6359_vio18_ldo_reg>;
 	vcc-supply = <&mt6359_vemc_1_ldo_reg>;
 	vccq2-supply = <&mt6359_vufs_ldo_reg>;
 };

-- 
2.55.0

