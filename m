Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FBF2F60D5;
	Tue, 14 Oct 2025 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454684; cv=pass; b=ER9rXBtuPb7MJSCF2cj4h/Ut8BdtwgmasvtGxl31+IMOvEvJ82MaSFh0260ocISl8daOQXeCH5c+nmyOrRHBeUjyGx6+T+tNqpflawbs3vM3bDInCsfrHJoEvvksOcmwSZ6uiHC6I8KYHROXDCdP1issHTLFnb88+bTG3ICPkoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454684; c=relaxed/simple;
	bh=FT7rwYbfbYv/WUqESExDjKNVuc3tXZAx0bdt5TFToJE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=oBlQ5eBR713jautlfyynvWll6eRsu0q8Ya/WVrqNvd5GgqJ/GaPVuD8I9xlUOLmyxJ0VDdMpDX8tZGWhVp55NWuFrbe3UKJTShk0+iY0MjvKdTCOTUVZV3dMXNLKfp/pEHJFnJYOYMtIg4kJIRjQWuv9NWEQJMxVyftQMGLMhlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Y5B2OAhQ; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Y5B2OAhQ"
ARC-Seal: i=1; a=rsa-sha256; t=1760454622; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=GvHyt0pU9WHVCquV5TD7GVuuvanrQd75qtwSFeAKtRGBdlrqPSRJA5QQQvrIQ/EuPr2s7GgTAXOfKvW01W6VBSsUygIWhVl6Ysx3qWhNsaM+czytxl37wPPebrUoOB0Nc2n3BRhXH+R+Uy+MqzZJtnwMxBJ/sfhC3M0txolELQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760454622; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=sA3fLEM3pMFmQ7m36DJ7taILG17fx4lcHYtgoNT4WgA=; 
	b=EwD/BiKhlBqE//FJon2Zg96AGImNfF2YmXI5iwReKBaQ5p1dSdMToh4tbeEkLpveZrBqR27Fcxr6NIWZDC75NDK4vRTkl42qHF8Tz+A9pO/ELTQZ8b/fg24E1yn7VVLPJdnz6yBlCJYW62Paqft6npnsuPM3sMld3LuwtpkOTMY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760454622;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:To:Cc:Cc:Reply-To;
	bh=sA3fLEM3pMFmQ7m36DJ7taILG17fx4lcHYtgoNT4WgA=;
	b=Y5B2OAhQqVDdnHBPeubHxvlMXvKaO0BkkNVBjF/FuNfK7Zb3Tzvo0jSQ0i8ZoBwr
	Sl1z4kIkbrCekFbg1olcbUHQRRVUGFgBPSmMEZVv4iQk9VOv66jWvhkIfbBoovspdYb
	C5vDltOa7r/4918IQ/YBPa+uKLpsVzJRwNe62PRA=
Received: by mx.zohomail.com with SMTPS id 1760454620674457.63817318714723;
	Tue, 14 Oct 2025 08:10:20 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: [PATCH 0/5] MediaTek UFS Cleanup and MT8196 Enablement
Date: Tue, 14 Oct 2025 17:10:04 +0200
Message-Id: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMxn7mgC/zXMwQ6CMBCE4Vdp9uwmFEEtr0I4lDroHlq0LYaE8
 O42Eo//JPNtlBAFiTq1UcRHksyhhD4pck8bHmC5l6a6qltd6YZ9vmlz4WVK7OCa0VhzRXumcnh
 FTLL+sH44OuK9FDMfI402gd3sveROBayZ/y4N+/4FA4QRLo0AAAA=
X-Change-ID: 20251014-mt8196-ufs-cec4b9a97e53
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Stanley Chu <stanley.chu@mediatek.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

In this series, the existing MediaTek UFS binding is expanded and
completed to correctly describe not just the existing compatibles, but
also to introduce a new compatible in the from of the MT8196 SoC.

The resets, which until now were completely absent from both the UFS
host controller binding and the UFS PHY binding, are introduced to both.
This also means the driver's undocumented and, in mainline, unused reset
logic is reworked. In particular, the PHY reset is no longer a reset of
the host controller node, but of the PHY node.

This means the host controller can reset the PHY through the common PHY
framework.

The resets remain optional.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
Nicolas Frattaroli (5):
      dt-bindings: ufs: mediatek,ufs: Add mt8196-ufshci variant
      dt-bindings: phy: Add mediatek,mt8196-ufsphy variant
      scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to mtk_sip_svc.h
      phy: mediatek: ufs: Add support for resets
      scsi: ufs: mediatek: Rework resets

 .../devicetree/bindings/phy/mediatek,ufs-phy.yaml  |  16 +++
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 134 +++++++++++++++++++--
 drivers/phy/mediatek/phy-mtk-ufs.c                 |  71 +++++++++++
 drivers/ufs/host/ufs-mediatek-sip.h                |   9 --
 drivers/ufs/host/ufs-mediatek.c                    |  67 ++++++-----
 drivers/ufs/host/ufs-mediatek.h                    |   1 -
 include/linux/soc/mediatek/mtk_sip_svc.h           |   3 +
 7 files changed, 251 insertions(+), 50 deletions(-)
---
base-commit: 40a3abb0f3e5229996c8ef0498fc8d8a0c2bd64f
change-id: 20251014-mt8196-ufs-cec4b9a97e53

Best regards,
-- 
Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

