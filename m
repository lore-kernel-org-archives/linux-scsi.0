Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44E53002C8;
	Thu, 11 Jun 2026 23:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781220408; cv=none; b=GC9Vqkr6sbc+HtTb15LWHHTNBF8ikLd1JQhQT+XnK/8cpl8FP5E4xuCMNW2Je5k+0gVFguKVYMp3iUHu8RPQLH33b4TgCu/VJ54lIij/tnSL0Gdsjugzy3gUDG8Ynk/tDHapwwDQFxg6Bz2sxwFZWRLICqWYGqM0t2o60qMxtFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781220408; c=relaxed/simple;
	bh=Wyxs/tfqDW0yyA4Hherq490XeUIIaTCwn8RhOTVrCHw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hF/U9dlEi2rkkewNRoJzk64pICxtR86Qk8nZ54DTx/4kcabi/hd/CEn69xU6DC/3x7+Dk0JD9zDqufsP8ApPn+fX7ZpmdJRI8h7RpmmGUdOPfcroOYu3m9jsemgc3p8gtc3tq7AIowPyLOgGwppJ7GrCnmuwPyX0lSyN7nlR/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PvHma8e+; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PvHma8e+"
X-UUID: 00b734e665ed11f1b1788b6acf885367-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Lu0ccYQsRw99cS5wqcElRVz4QHqtm7tew269NO2xzmI=;
	b=PvHma8e+E4hIujnSbgehEMcWVGVrplr/11X2hbG8pHWW7SxxA5zTZylM/O4uzROWW0CvmSWVhclKl4xtmTBLaQYLYXe9Vxeg+s69GyDV2I8F6XrbYqWOzsCZcbnvLr1HY4S5rktZfqFHgRiD8W4KFiNvgijLIbbwgn0P+ZfZR3U=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:d500d0d1-b224-45e9-b827-d02e9a5ebf43,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:0a617254-902f-47df-afe3-f34f8d753c22,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|865|888|898,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,O
	SI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 00b734e665ed11f1b1788b6acf885367-20260612
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 389950896; Fri, 12 Jun 2026 07:26:41 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 07:26:40 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 07:26:40 +0800
From: <ed.tsai@mediatek.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>
Subject: [PATCH v2 0/3] ufs: Add callback for vendor-specific RTT capability
Date: Fri, 12 Jun 2026 07:26:29 +0800
Message-ID: <20260611232632.2324422-1-ed.tsai@mediatek.com>
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

From: Ed Tsai <ed.tsai@mediatek.com>

The first patch adds the get_hba_nortt() callback to the UFS core layer,
allowing vendor drivers to provide dynamic, platform-specific RTT
capability handling.

The second patch implements this callback in the MediaTek UFS driver,
distinguishing between legacy platforms (which require the RTT to be
limited to 2) and newer MT6995 B0+ platforms (which can use the value
from the capability register directly).

The third patch removes the max_num_rtt field from ufs_hba_variant_ops
as it is now replaced by the get_hba_nortt() callback.

Changes in v2:
- Keep max_num_rtt field in patch 1 to maintain bisectability
- Split removal of max_num_rtt into a separate patch (patch 3)

Ed Tsai (3):
  ufs: core: Add get_hba_nortt callback for vendor-specific RTT
    capability
  ufs: mediatek: Implement get_hba_nortt callback for RTT capability
  ufs: core: Remove max_num_rtt field from ufs_hba_variant_ops

 drivers/ufs/core/ufshcd.c       |  9 +++++----
 drivers/ufs/host/ufs-mediatek.c | 12 +++++++++++-
 drivers/ufs/host/ufs-mediatek.h |  4 ++--
 include/ufs/ufshcd.h            |  4 +++-
 4 files changed, 21 insertions(+), 8 deletions(-)

-- 
2.45.2

