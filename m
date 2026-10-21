Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578252;
	b=0e8Yy5YXPezIBeC1X2ljf6aFDojgJgXVH1NMwlCN931fNnAA7XfpzH1PCx95R0aF0MN3
	 OgIq47pmXjn+qiVODGuDbCb7m4QfEHfZV+2KbKMQ62pFpUuQwFQNQfNkp0V2t5XyhYUgv
	 RLk2q18oY/j2U8XHt3QAK/5JrrVPUf7VglU2vBdQgPtVFEk6PDwiIbb0aqU8RIqGpvKAd
	 otdiTjf/wByrOx9o/d363G1sYOv+0Z1IvN3N073QTNk2ffvDo3s617tRu0nps/c0ypepb
	 IUTWsfmfTtwCulEQhsxypRPxYSrKLbQ1qFmbCG2KpB8fTbR2nxrbrtnvpQwUKKnXqgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578252;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=udlvEC2ua49uuIoifpZw/y2VMoNWBqe/7/qB2sIvEY8=;
	b=2IV9vSy8FCv5gpDBjDvMjDFNzFqso60f4l5Lbo0YOG/robuB+JeGS3y1W9x8wOLfcZVz
	 18LTFFQmTIDChVLo7ZP3fmOjGg7vKnMKAthdSjApl7FvSuMKAJN30ku7wdNVw+d2NAZQa
	 jA4fseqZvM+wtIJppMh8v8ZmnYUN/VRUMioLRvRceL+nIcsxdW4CK48EtZfMuPANvbijt
	 OBwbjf9YijEG+PyYDEIB1wE6O7COhwOdgulaa2MPHwqTqZaLKTPIkZeXlq7bf3fiWrp6b
	 BDneJnIz34YJku/lZ7Tdu0tgcrHxAGQkSR/BVtWs8/OB7fQCroCa4X/lDqkcys5VlAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b="XLwVm/b0";
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EB0606A31F
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:24:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63EB0606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=XLwVm/b0
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5mx32174161;
	Wed, 21 Oct 2026 03:24:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	dlvEC2ua49uuIoifpZw/y2VMoNWBqe/7/qB2sIvEY8=; b=XLwVm/b0o6dCvCpBS
	APaOzg1yvNZ8mzfgVjXFiCBlbV6DHseVq93vJ0EeIkwFgK8CEU08Vi/zhoSpwBhE
	bWzgMFAoSFcOPrecTCFrMCC1En7GGGa9US+6u/K+0XN6Ftv3wVDEb7khcDNV8aV/
	Be3KVYgfE5FpxEgLyK24XPRrA039xXft2NhpZ0XcgnPRCZtMJKt5LkbPh21yeyPW
	Mtks2OhgH3qLMyquxoKo8TC+WFc97SHfKAOvHPbLlSQkNCp7QCUcbU93XZa1wnJS
	dqfC3Wo6EpeZG9pvhTQAgdPCl66HvpPb5nUIvypl/Tvlk5nEWbItHbWN3Md08629
	4G/mQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hemfbsppk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:24:08 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:24:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:24:07 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 86D253F709E;
	Wed, 21 Oct 2026 03:24:05 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 12/14] scsi: qla2xxx: Yield work_lock in fabric scan path
Date: Wed, 21 Oct 2026 15:53:08 +0530
Message-ID: <20261021102310.3854868-13-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20261021102310.3854868-1-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
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
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=AvJ7T+9P c=1 sm=1 tr=0 ts=6ad892c8 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=C3qKPiBBBnVxIbkOQ_wA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: oVIg74y-OJR8_KmFG6egfkKqRrYggdyc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX+Kz1rM+7o8ax
 12lOkGbretoxGHJKqi4GRPpUUGmHDHsTPQl7R/5Gj9W4DQaLojOpKdT8E4PzQWCtVrahpL6CZB7
 YyrsB+O++arZqNOKfRoEWhyNEo0Jas8=
X-Proofpoint-GUID: oVIg74y-OJR8_KmFG6egfkKqRrYggdyc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXwKbU3pp+VfUx
 6nzUCR65wArsgk7juE2xkr+sJ2HREWjYbexl/XbF35XXmIWvo/tLsdwpZJ9XHcnmAQy4jYVIx4F
 hzdyaO75EwZL2+B0+XTG8XF9QAIkRTz+wQP+gg42MeEWor59qtw3B6d3vYRMdQmqvpn0Y6WitM2
 v55N04gyWniyNQvaXdgvBJcZJWaJvK0eSKTe6dssOKI+5QQJ+MJBDDLXm+CV3eZ8TXYSMUPcik9
 JWg3nqMufUypnhXh3pNAwRxU/AgO+Ji2ZNqjVnzr97k2C/51a7BwC8mKRGLa2hXaPKNEbdbALUW
 Kirv5i+q7ajT2yeve7vtrXvZoeTRKSkCfmly9oRo079F59h5TglsX14KLYU08zwSLcl/LbVBVFC
 jV6jeExjjIpQ0khuFFs1UzyCuCU2KsFeqi5XaPX6+PEzuuwrnS6czj91+wwiCZE84SELrnSnD9y
 svhtBUg8mmefBw9u7KQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

A hard lockup was observed in the fabric scan path after multiple
iterations of vport delete, with the work queue worker spinning on
work_lock in qla_fab_scan_finish() while another path held it.

 NMI watchdog: Watchdog detected hard LOCKUP on cpu 38
 Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2xxx]
 RIP: 0010:native_queued_spin_lock_slowpath+0x5f/0x1c0
 RSP: 0018:ffffb9a88faafd58 EFLAGS: 00000002
 RAX: 0000000000000101 RBX: 0000000000000202 RCX: 0000000000000800
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff98b149ff6488
 RBP: ffff98b803e60a58 R08: 000000000086742c R09: 0000000000000000
      R10: 2100000eddd08241 R11: 0000000000000000 R12: 000000000000c000
      R13: ffffb9a8a4555000 R14: 0000000000000000 R15: 2100000eddd08241
     FS:  0000000000000000(0000) GS:ffff98b7def80000(0000) knlGS:0000000000000000
     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
     CR2: 00007f5da15934c0 CR3: 000000033ee10000 CR4: 0000000000350ee0
     Call Trace:
      _raw_spin_lock_irqsave+0x34/0x40
      qla_fab_scan_finish+0x527/0x700 [qla2xxx]
      qla2x00_do_work+0x390/0x490 [qla2xxx]
      ? __switch_to_asm+0x43/0x80
      ? __switch_to+0x10c/0x450
      ? finish_task_switch+0x86/0x2e0
      qla2x00_iocb_work_fn+0x42/0x80 [qla2xxx]
      process_one_work+0x1a7/0x360
      ? create_worker+0x1a0/0x1a0

In the scan-finish cleanup path, replace the blocking
spin_lock_irqsave(&vha->work_lock) with a spin_trylock_irqsave() +
cond_resched() yield loop so the worker yields instead of spinning if the
lock is held, avoiding the hard lockup.

Cc: stable@vger.kernel.org
Fixes: f352eeb75419 ("scsi: qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index efe98609c149..31308a614858 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3386,7 +3386,9 @@ void qla_fab_scan_finish(scsi_qla_host_t *vha, srb_t *sp)
 	recheck = 1;
 out:
 	qla24xx_sp_unmap(vha, sp);
-	spin_lock_irqsave(&vha->work_lock, flags);
+	/* Avoid hard lockup: yield if work_lock is held instead of spinning */
+	while (!spin_trylock_irqsave(&vha->work_lock, flags))
+		cond_resched();
 	vha->scan.scan_flags &= ~SF_SCANNING;
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 
-- 
2.52.0

