Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793353020;
	b=2DkwWwpKPagV3nUyFuy0V3DJHz3xbozsMGmammNl1V7DR7JENSCaGIC+7dpTP3Fu9cFY
	 KQXQytUvmi1c/Bab8B1tIqSKNepCF5u+aMdKPF88orT+Gd10d3REJ9859j4sItuvEaVEv
	 XDRt8+Eob3hYhfnkW9t2+sXFlRgkINYj4eVdiLskg4k+t7F3FY8kk71mmAhv6opaYJnXF
	 5Bl7tU5hpV2Jr8zGJgJcXS6JvyOieGnxbAfTE0/tGS9Bi0DyzdIzkPXrW6lAgsCCt4L6h
	 4z0tf1HzKMwF+IoWf7h3GjfBE50m8GrpKzaaQvaa6gJeRC7SGuHAVcMxH9pCcAMB0GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793353020;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=lRezFi2aEYM5pYBhR9QtMA9MM0OoaYfh5KLn9jOB7hk=;
	b=p+rvrVXOpz6Yy6C1Cs8PhGHCg6k064mfUyvzgwncEdnilNRXtxZJu81fvWJlJY2rDkLo
	 cnwq56z7WNKDf7x0+NMfWUQlrGa96zLtnezpXGmSkVp/arXJ+kQxKylx1uVvu82xz/pBS
	 R3Bag3d198/OvtA0bYxoNRzl8U3ZehNyBP54ys2uxyBWOmIJ9tWvoeP4WgV55LO9xDFbU
	 B17f3FYp6XaBmftXchSgnhUrYFhs8EwpS0oUfG2guF8MvuHNRXAzCggXIJF9un315BgWq
	 V+8gYgnDo66FRuIE4xUs3ZpuYZh9ahWe9IPVfwfq9dL/G48o9RJI6ydPqtKPkmiuV2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=DPuRfTgc;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ABB606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 09:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4ABB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=DPuRfTgc
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261030093655epoutp02a5d578504a3fe66dc00249688b67150c~jRRDxF5IV3104331043epoutp02x
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 09:36:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261030093655epoutp02a5d578504a3fe66dc00249688b67150c~jRRDxF5IV3104331043epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793353015;
	bh=lRezFi2aEYM5pYBhR9QtMA9MM0OoaYfh5KLn9jOB7hk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=DPuRfTgcoK0rSHIuqviT8PmBt8riCIydZmdpB8keBJRkGMZ31xzSH7f6K1rN6ndLR
	 fp0SAIPJnnn8Nj5VDFG2y1GyI2XvIbpJQRWpaEja2WOWKJIwSYL3XilSeGqvIFTITp
	 zVtl8cOfkp+m8c8em2VDxC0pxnGekXbgdL6+B7hk=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261030093654epcas2p4309772af20fcf1fe55022e80892c6834~jRRCouh4Z2118421184epcas2p4w;
	Fri, 30 Oct 2026 09:36:54 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.206]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jGGFy12FKz3hhT8; Fri, 30 Oct
	2026 09:36:54 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261030093653epcas2p329f2bb351b051a118edad4211b4b3470~jRRB2HGzA0937409374epcas2p33;
	Fri, 30 Oct 2026 09:36:53 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261030093653epsmtip1a1b610c9add5241128c785d63eabe859~jRRBvEDKL3236332363epsmtip1c;
	Fri, 30 Oct 2026 09:36:53 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	hy50.seo@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v2] ufs: mcq: fix dev cmd abort path and add OCS poll after
 sq cleanup
Date: Fri, 30 Oct 2026 18:36:45 +0900
Message-ID: <20261030093645.790159-1-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.43.0
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
X-CMS-MailID: 20261030093653epcas2p329f2bb351b051a118edad4211b4b3470
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261030093653epcas2p329f2bb351b051a118edad4211b4b3470
References: <CGME20261030093653epcas2p329f2bb351b051a118edad4211b4b3470@epcas2p3.samsung.com>

In MCQ mode, ufshcd_mcq_abort() falls through to ufshcd_try_to_abort_task()
for all timed-out commands. However, device management commands (query, NOP)
use reserved requests and are not SCSI I/O commands. The ABORT TASK task
management function is designed for SCSI I/O UPIUs and is not applicable to
device management UPIUs.

Fix this by checking ufshcd_is_scsi_cmd() in ufshcd_try_to_abort_task(). When
the request is a reserved (device management) command, skip the TM path and
call ufshcd_clear_cmd() directly instead.

Additionally, extend ufshcd_mcq_sq_cleanup() to poll the OCS field in the
UTRD of a device management command after a successful SQ_CUS poll. UFSHCI
does not specify the order between the OCS update and the SQ_CUS update, so
OCS may still be stale when cleanup returns. Without this poll, a late
response to a timed-out query can arrive while a retry is already in flight,
leaving the host with two query contexts and raising IS.UTPES.

The poll is limited to device management commands because
ufshcd_compl_one_cqe() copies the OCS from the CQE into the UTRD only for
them. For SCSI commands, the OCS in the UTRD stays
OCS_INVALID_COMMAND_STATUS, so polling it would always time out.

The poll waits until OCS is no longer OCS_INVALID_COMMAND_STATUS or
MCQ_POLL_US elapses. -ETIMEDOUT is returned only if OCS is still
OCS_INVALID_COMMAND_STATUS after the poll. Any other value, such as
OCS_ABORTED reported by the host controller for the cleaned-up request,
means the cleanup has completed.

--
Here is the timeline of an actual case for this that happened with kernel 6.18.
1. The host sent a query but the device didn't respond with it for a long time.

[ 7384.156142] [4:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_mcq_sq_cleanup, hwq 0: cleanup return code (RTC) 0
[ 7384.156154] [4:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_query_flag: Sending flag query for idn 14 failed, err = -11

2. So after the query was timed out, the driver did SQ cleanup.
Then the host updated CQ update and raised IS.CQES,
Unfortunately, complete() was called the driver's ISR afterward.

3. The driver started to retried the query. In the meantime, it set OCS to 0xF.
Then the driver didn't wait for completion due to the previous complete() call,
and just checked OCS.

[ 7384.156163] [4:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_query_flag: Sending flag query for idn 14 failed, err = 15

5. The driver retried the query again, but the device didn't return anything,
so the query was also timed-out.

[ 7385.660108] [3:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_query_flag: Sending flag query for idn 14 failed, err = -11

6. A few seconds later, the device returned the response of the 1st query,
but since the host was holding two query contexts and couldn't handle it,
it raised IS.UTPES.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>

---
Changes since v1:
- Limit the OCS poll in ufshcd_mcq_sq_cleanup() to device management
  commands. ufshcd_compl_one_cqe() copies the OCS from the CQE into the
  UTRD only for them, so for SCSI commands the poll always ran for
  MCQ_POLL_US and then failed with -ETIMEDOUT (Sashiko).
- Return -ETIMEDOUT only if OCS is still OCS_INVALID_COMMAND_STATUS
  after the poll. OCS_ABORTED, which the host controller reports for
  the cleaned-up request, is no longer treated as a cleanup failure
  (Sashiko).
- Update the commit message to match.

Link: https://lore.kernel.org/linux-scsi/20261030083311.602909-1-kwmad.kim@samsung.com/
---
 drivers/ufs/core/ufs-mcq.c | 25 +++++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c  |  4 ++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..4f42b502d159 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -609,6 +609,31 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 			 __func__, id,
 			 FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
 
+	/*
+	 * For device management commands, there is no order guaranteed between
+	 * OCS update and CUS update, which is why we need to wait here. SCSI
+	 * commands are excluded because the OCS in their UTRD is not updated
+	 * from the CQE.
+	 */
+	if (!err && blk_mq_is_reserved_rq(rq)) {
+		enum utp_ocs ocs;
+		ktime_t start = ktime_get();
+
+		do {
+			unsigned long flags;
+
+			spin_lock_irqsave(&hwq->cq_lock, flags);
+			ocs = READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
+			spin_unlock_irqrestore(&hwq->cq_lock, flags);
+			if (ocs != OCS_INVALID_COMMAND_STATUS)
+				break;
+			usleep_range(20, 50);
+		} while (ktime_us_delta(ktime_get(), start) < MCQ_POLL_US);
+
+		if (ocs == OCS_INVALID_COMMAND_STATUS)
+			err = -ETIMEDOUT;
+	}
+
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err = -ETIMEDOUT;
 
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

