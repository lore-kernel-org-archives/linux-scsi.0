Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0444334EEF2;
	Thu, 23 Oct 2025 19:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249148; cv=pass; b=tw9IfNu9dAAak+cVxR3tbvaIJmU6QyxGc72C8KijwQqQ+L0heEir/Un0mA2OPN1SBHqwqIK6TlAbSO/vf61LNzednLOt2btM5ilWp7GpC3f2RHveFX0y9umtPqJp5t6HOJmvs4oPosFeE4F6YrX2YiBR6s6fjxbI12e9TVyD0gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249148; c=relaxed/simple;
	bh=X9Ap6F0nmCQQBL+Gx1ZG1/O5oBTR6MvZxuks/CNJoo0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GXBqR3WfAECzVryUxgiJhx/JkejXGK2kXQoukQNSSIn1mSqgZ33FBdwi837LoiQdy/MBfJ7chmFfaaNknbS2BhMlCii/vCbWRQbxYYHQMbuAT3/7GvlCaw9G4wdC+RVIkj3xfv7/yWy4+GSrxzrcKEWTxrTRSxUbWY3ei8DCH00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=YU8Bib3X; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="YU8Bib3X"
ARC-Seal: i=1; a=rsa-sha256; t=1761249114; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WaxXirPEazk8bjUvbT1e94tfNHkfnDb/YMN6Lh+8h7iQIqONf2p8UL/kaHVTtL+dGSlQXQj3Hm/MCzxmNWIUjEKW7jtmaySiui3pkxKve0skiBPM3uGcodgnkNi2TAGvoe054nV9NHzvZNkGk5PQOvbkD6WpZsHIJhT1uyBO5fw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249114; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wdgnhdw/Mw698xqGaERI0Yc6xoNppjlBNBAYGnT56uY=; 
	b=ZN29Y/9w7GPQWpMo9YB44rSwdNhvnL69YT2fywuEB6dip55GI/ybFOW1CYoHnuGHyIGmBPgCzfXKqpGDyC4+Y/AdQ/INobWAPB5xueMoX5hbZha0pP/oZpG8JBVySJWXCbMrgmZILKgnxk0sefCAfAEfTnMCg/bcWghyJcb2Cys=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249114;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=wdgnhdw/Mw698xqGaERI0Yc6xoNppjlBNBAYGnT56uY=;
	b=YU8Bib3XbAo+fHBH4bkDRlGa0w9eOdrt9oM5pSOBjRws/FuQ3lcbwekorLHJBKNp
	4ACAWBVMMo3kku1XngEHTHyAjuOvlUuPoguY3G//6HXsdYN4MUMUt/MwaDdSu9RP6wu
	q52QTvCQFYSaCa4qNwwFj7lDK91faB4svMEzNmuI=
Received: by mx.zohomail.com with SMTPS id 1761249112427642.1241395414302;
	Thu, 23 Oct 2025 12:51:52 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:34 +0200
Subject: [PATCH v3 16/24] scsi: ufs: mediatek: Add vendor prefix to
 clk-scale-up-vcore-min
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-16-0f04b4a795ff@collabora.com>
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

Device Tree properties other than the standard properties must be
prefixed with the vendor's name. The "clk-scale-up-vcore-min" property,
which this driver uses, and the binding did not previously document,
lacked a vendor prefix.

Add the missing "mediatek," vendor prefix and clean up the error print.
No judgements are made regarding the use the property itself, it may
turn out to be implementing something that it should do through a
different way (e.g. OPPs).

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 7a890302c240..20db25efd634 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -958,9 +958,9 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		return;
 	}
 
-	if (of_property_read_u32(dev->of_node, "clk-scale-up-vcore-min",
+	if (of_property_read_u32(dev->of_node, "mediatek,clk-scale-up-vcore-min",
 				 &volt)) {
-		dev_info(dev, "failed to get clk-scale-up-vcore-min");
+		dev_err(dev, "Failed to get mediatek,clk-scale-up-vcore-min\n");
 		return;
 	}
 

-- 
2.51.1.dirty

