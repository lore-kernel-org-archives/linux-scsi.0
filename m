Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EBB199D8;
	Tue,  9 Jun 2026 10:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781001546; cv=none; b=O6BJOu4OYa2AeP2QS3QXRKHWl3uIfLA4KPrWi7WbXjlQhKMnjkxxy3V6nJXyH/3r7Nk4q09ukUuKKt8RRm2eLzSL52axQAZ4vzuXQfw/18Z7VLRDSIXCFZh8CD+FOcw+EIekQr0e6p5JCGWVNKxg922rqI4YropHi2jtT5njpd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781001546; c=relaxed/simple;
	bh=8cJvuRbd6ClyesLFVFnAFWhmrf7Edts5Hntjz+P3iq4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JRGmg/P33GlArtYQlDNfzgEURYhMv+2tC72QaVHUcO5T4FPj5LKOFgFct8olR7kEFSHp38h+qqS48BEXc7Kg4co3/fATNOo978o4mMoMx9KWT57bgZ/eb8+SM11OiqtSgs4Fpz/iF7dNLEMZdrrb0V/pV+ZCPfPftJS0CfQdSuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qvcKeHdq; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qvcKeHdq"
X-UUID: 6d25901e63ef11f1b1788b6acf885367-20260609
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=OxZg1HbkTQJaG3rBGBiIsByihp2SXJ3mxZea50kB+9Q=;
	b=qvcKeHdqX271kaSyJCj65IKVqkbEq/5wQQh2AMnAp3yxGmmGOYOWpVRK/T15w3Kc9v8+ULOLkm3anifefZ/KqGnQGXQ7vT4bmt/5MDmw130p2SDHsW6rpazFeTWZa9bwMM//OVAQdmKM9LJaUl7XfrFgdKTCp83uUl3P8vCSQyY=;
X-CID-CACHE: Type:Local,Time:202606091817+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:8fef85b0-5ee2-43f0-8ddd-4fc76847345e,IP:0,U
	RL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e276073,CLOUDID:72aa9030-7784-4a77-a538-47ed6151d81b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|865|888|898,TC:-5,Conten
	t:0|15|50,EDM:2,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OS
	I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6d25901e63ef11f1b1788b6acf885367-20260609
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1795642712; Tue, 09 Jun 2026 18:39:00 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Jun 2026 18:38:59 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 9 Jun 2026 18:38:59 +0800
From: <ed.tsai@mediatek.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>
Subject: [PATCH 0/2] ufs: Add callback for vendor-specific RTT capability
Date: Tue, 9 Jun 2026 18:38:54 +0800
Message-ID: <20260609103856.676222-1-ed.tsai@mediatek.com>
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

The first patch adds the get_hba_nortt() callback to the UFS core layer
and removes the static max_num_rtt field from ufs_hba_variant_ops. This
allows platform vendors to provide dynamic, platform-specific RTT capability
handling.

The second patch implements this callback in the MediaTek UFS driver,
distinguishing between legacy and newer platforms.

Ed Tsai (2):
  ufs: core: Add get_hba_nortt callback for vendor-specific RTT
    capability
  ufs: mediatek: Implement get_hba_nortt callback for RTT capability

 drivers/ufs/core/ufshcd.c       |  9 +++++----
 drivers/ufs/host/ufs-mediatek.c | 12 +++++++++++-
 drivers/ufs/host/ufs-mediatek.h |  4 ++--
 include/ufs/ufshcd.h            |  5 +++--
 4 files changed, 21 insertions(+), 9 deletions(-)

--
2.45.2
