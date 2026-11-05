Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793839439;
	b=wgG8ougpRBVesVYuKFR8cbnPMh/RW1287GCLnhgfK3ncbIdmJligfNSsrDoBNQ9TCTYy
	 MzfSbMEmZ1x272SxngRbbgf4TSOR2nBSzPU0qTSg5mBWe8bDEXz8Qwiq3M6zFqOWc6+DJ
	 v8BoTDiVcLGVf47kEzSemnrgzSroDHS/YzLFEbOjRqZu/Xe+mSQ7dhZtLusOBX/hx8ZAM
	 xKGmLOSuRI5x+UdZHpvEAXAgz+11RVgXzb0Sqd4xeS9X+gGngqYkcBOgtmf8DcfS5m4cw
	 6/3gfLNd3cq+WLqZ/dchDC/b39xfBwrdtWr9Ptldk7YF4LbT3aVPHWLt4kiIEAEbVvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839439;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=TRvgzI3qXoA2HIsl7Zv36AwD/K99XeT08hxCxLH0B9A=;
	b=YP5kAAtDwnZMz8F75SnRd9eLjGTipkQidiVfjlrBmOnus6ZpsiGaPKEO2OpRnZs1mQQG
	 SlZI8/KVup5SpTEAZk35NUfoPApF40OJKDwWkJUJSfK+hL9UNxNQx/+4vAakUUHlL/2ZP
	 +LEFBnVVEWSo/e67ugIzBPD7+lRxS9c8ZfffF86dKrJ6kFItKvvfpLK3PaTXfeHK7LWd+
	 FrFYLH5/PcqSl4qTeyeB2zTO6E4PphiMKhjxSG6fNXtWBXddZzacW8pWUQ0VEaKulFGVV
	 6SltgLpOk4U8tt5lY+eAXXFZwtcjXEIL2NbfdeF4bQbr41WcuhmggtRqvS14jzI7Trg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=gEPGYb1k;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AEA606A333
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3AEA606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=gEPGYb1k
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261105004354epoutp01cab48922e8f0795a7ac93e75f071653a~k-3YmVziD2486724867epoutp01Q
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:43:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261105004354epoutp01cab48922e8f0795a7ac93e75f071653a~k-3YmVziD2486724867epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793839434;
	bh=TRvgzI3qXoA2HIsl7Zv36AwD/K99XeT08hxCxLH0B9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEPGYb1ktlGAv1wBW5AoEU3AJgR69HF/eFfsSWPdvxR6xGNkRMaul/NKZHoZsGIvW
	 aeD2GinMhCZZAF0MKXB26AyE7ACehry5fETjciwVdMnvtJq+VwGfDT1hnRnV5GX8iB
	 G45IFo0HOkh9OrWOj2mLDmaSP1g5jVqivEXUf2bo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261105004353epcas2p33c41ad53cd488389d79916ef07439117~k-3X813PC1259112591epcas2p3E;
	Thu,  5 Nov 2026 00:43:53 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.206]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jKk89329Lz6B9mF; Thu,  5 Nov
	2026 00:43:53 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261105004352epcas2p307ea40aadb636015545cee6e79470a03~k-3WU95OM2408824088epcas2p3l;
	Thu,  5 Nov 2026 00:43:52 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261105004351epsmtip209a25c3e4e97031d57f7fa4fb718bd32~k-3WOYWCl0761307613epsmtip2S;
	Thu,  5 Nov 2026 00:43:51 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>, Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 1/2] ufs: core: skip ABORT TASK for device management
 commands
Date: Thu,  5 Nov 2026 09:43:32 +0900
Message-ID: <20261105004333.1097899-2-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105004333.1097899-1-kwmad.kim@samsung.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261105004352epcas2p307ea40aadb636015545cee6e79470a03
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105004352epcas2p307ea40aadb636015545cee6e79470a03
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
	<CGME20261105004352epcas2p307ea40aadb636015545cee6e79470a03@epcas2p3.samsung.com>

In MCQ mode, ufshcd_mcq_abort() falls through to ufshcd_try_to_abort_task()
for all timed-out commands. However, device management commands (query, NOP)
use reserved requests and are not SCSI I/O commands. The ABORT TASK task
management function is designed for SCSI I/O UPIUs and is not applicable to
device management UPIUs.

This is only reachable since device management commands were converted to
scsi_get_internal_cmd(); before that, a timed-out query was handled by
ufshcd_wait_for_dev_cmd() -> ufshcd_clear_cmd() and never reached
ufshcd_try_to_abort_task().

Fix this by checking ufshcd_is_scsi_cmd() in ufshcd_try_to_abort_task(). When
the request is a reserved (device management) command, skip the TM path and
call ufshcd_clear_cmd() directly instead.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reported-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..7fc80926eeec 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8046,6 +8046,9 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 
 	lrbp = scsi_cmd_priv(cmd);
 
+	if (!ufshcd_is_scsi_cmd(cmd))
+		goto clear_cmd;
+
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_QUERY_TASK,
 					  &resp);
@@ -8091,6 +8094,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 		return err;
 	}
 
+clear_cmd:
 	err = ufshcd_clear_cmd(hba, tag);
 	if (err)
 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
-- 
2.43.0

