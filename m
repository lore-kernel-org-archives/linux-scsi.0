Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785769;
	b=hihnJQps1QLAGiBDyyWxpt97KjslKl1oB/iFc+x9DVgGjUzzShzoX6GAbORFguqHRIPy
	 Og5vsMjoTja//OER+/hVM64g47FKcJvuVnSgvo9rOZ/uZlnZXSc7h7qLCkW+5y74jkoHZ
	 e3IpK+fWKP49aHacoeBLY/GMkk3YNtpE+cAJc5FsidncsrK5VpMHXgHW4oW6B0xpWR3Yt
	 EDwMkTIEU/BcUTTbsWdqeQfZwEFZRDWdWwDsgi52EqgBrbkoT1MBi782XJ5kQGlce1okc
	 N4bLa9DL8CgZFbmNxWQB3CvINhboZpMZlKhTH1zoK622yE+QrFtxPg2zzmrcugEMPQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785769;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=TRvgzI3qXoA2HIsl7Zv36AwD/K99XeT08hxCxLH0B9A=;
	b=qYlbZe5wsJR2xhY6i5KW/2IH6rxg2fhXLFW3xSZ9kmv2XJ5JNUBxYpPLZBsy87e6Y3rG
	 ijypa2R7w86dzxv3lV02nutqlQPnsvbLfZ3D1wBJEmn43cvzM/6lNxOr6OqhnoKJHYMtr
	 Tvvxx8ilGbbkve0LYRsJ8JYTZPWlPFW4wAT+rEZGPbJsk9tByFHzcDOARkuNOI91l8yPB
	 YrKtTaoiosFiuK6Pb0FbdrUll0MnBMSEhpZyX56TzgpPM4QeefxRxkdwBm1FNz7TfzxDe
	 YKbGWfWLMD5lFAEmFsEOgCHUKff1E2viqb4BUn2IqtWoijB9G8DJ+qgu2/XnrQ/MRpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="Enuw6Be/";
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DBB606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 09:49:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41DBB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Enuw6Be/
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261104094926epoutp01ff2fcebe48fc04aa87bc4b9ba6e3c289~kzqaDnJXN2908729087epoutp01s
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 09:49:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261104094926epoutp01ff2fcebe48fc04aa87bc4b9ba6e3c289~kzqaDnJXN2908729087epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793785766;
	bh=TRvgzI3qXoA2HIsl7Zv36AwD/K99XeT08hxCxLH0B9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Enuw6Be/L+mBjg2oVC5+RSVFKOJwQQccVwFBHQH0k4gaPLc70afM/6qI+AhMXzWup
	 3e6HMBG16SLZHcJyMyxqwVTJnL0HOKl3PRWJ+4cnPkM0iIxjrKU2RzS0t7ejXhYGh8
	 GrjzzIbnxfDJcYg71aLmmYpcQLIKnzvXvs++Lcho=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261104094925epcas2p1e0a2e776fff768fdd0843272e1111a98~kzqZdRQRs2536525365epcas2p19;
	Wed,  4 Nov 2026 09:49:25 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.199]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jKLJ50ynNz6B9m6; Wed,  4 Nov
	2026 09:49:25 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261104094924epcas2p2318e84e3593e6e77e4c933dd3e4adfc6~kzqYNm1OW0383403834epcas2p27;
	Wed,  4 Nov 2026 09:49:24 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261104094924epsmtip1c5ccc89e3fc1e99c0ce0e3ac43ad2fdb~kzqYIF6UC0106301063epsmtip1C;
	Wed,  4 Nov 2026 09:49:24 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>, Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 1/2] ufs: core: skip ABORT TASK for device management
 commands
Date: Wed,  4 Nov 2026 18:49:13 +0900
Message-ID: <20261104094914.180788-2-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104094914.180788-1-kwmad.kim@samsung.com>
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
X-CMS-MailID: 20261104094924epcas2p2318e84e3593e6e77e4c933dd3e4adfc6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261104094924epcas2p2318e84e3593e6e77e4c933dd3e4adfc6
References: <20261104094914.180788-1-kwmad.kim@samsung.com>
	<CGME20261104094924epcas2p2318e84e3593e6e77e4c933dd3e4adfc6@epcas2p2.samsung.com>

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

