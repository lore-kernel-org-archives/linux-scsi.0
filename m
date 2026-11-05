Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793839438;
	b=JO+rMsvWUx0CX7DeypHwVBS5YP1nrchpKRCQ7bdTyMMx64ZxJPpvAPfsjG0Li5cwYWjY
	 keimgiOnZkw1Nz3GmaUiHQp4dB3bqTz6dU06Bq6DvswVrWocYjzvtF3uKGUgv3Gj9A48b
	 9yIqs9WuVsmKhYbdrem1hOic+9e9L17FLEwmiTt5nMh5yvmgjDHf6oZHDGZX+WyNcPcWg
	 F3i7oje7wYxjwNW6+4FqzJx3EbXLEIPv/FJzyFI2+iMQyUEBhZpNeboKGzmkY296YaGye
	 wvhXyUyzWfSZdxm4K9thQGqS/4bzPaeYnouopHzDPl/WA6PX6a9oNDcpXQPl1d7NhIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839438;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=op8fE5/kODJq5uwPkW013cLOLSpSEKh3HwrWjMp4c9k=;
	b=C89o6vmgU+ByMd3IvP5jqWd56MF0NdyTQ1XweqcESwyU5w1yVdJ/jFyzXkAhZ04IOFHQ
	 AD3jeEWlXertz1DzKIYuK17cV7vGfp2qWjgr4S6Zltx8afGDxJYOnF6GyRqUEr+kM+ORy
	 u/Shfj9uQZ6wfe8LTFI3HBkjmgLJ/1FLmYTFoX12KIF3UZr1xg/zDtFW1T/k+0X/zRGwA
	 8XNKg8uW7AiUg+zZlTO6a5Yn+WN0S+PeyvDqhTsTVPOdaHULqtFLuyulH8DVZdBd//wy5
	 0Zqa1cvw63Hrdp8xUr7rMZYNsQN8Fuo3F/vv5k7AgDpIsXqBW3cOHbPSZ7dDbGB+BTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=t1NBt9kj;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADF8606A332
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:43:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AADF8606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=t1NBt9kj
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261105004354epoutp0288479a04177a46609dd12bcf78dcd8b5~k-3YpMfq73216832168epoutp02h
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:43:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261105004354epoutp0288479a04177a46609dd12bcf78dcd8b5~k-3YpMfq73216832168epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793839434;
	bh=op8fE5/kODJq5uwPkW013cLOLSpSEKh3HwrWjMp4c9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1NBt9kjoGETIBgyoFqpRQ4GMSik8uA0352QcmfA6yhHzS3x/XjK4Ccy0LzlAFY3C
	 li4Pjr7+t/tMIR07rLGgVGSl/sH9eyRAR+oe4xlXEjIFxq5TKyV6jWCxY/Vyfr9OSv
	 mdATZI4CS0+RT7ovFIPoQHTVO5L75rfS9HthCoyg=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105004354epcas2p1d7a3206ac45965d3f8eaa3a7d2fa8240~k-3YND8Zx2090420904epcas2p1I;
	Thu,  5 Nov 2026 00:43:54 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.204]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jKk895QTlz2SSKf; Thu,  5 Nov
	2026 00:43:53 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd~k-3XSUoji2090420904epcas2p1D;
	Thu,  5 Nov 2026 00:43:53 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261105004352epsmtip2f4fadb5ac88cdc8a9cf27df9dcca85db~k-3XGTE280751407514epsmtip2t;
	Thu,  5 Nov 2026 00:43:52 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v6 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
Date: Thu,  5 Nov 2026 09:43:33 +0900
Message-ID: <20261105004333.1097899-3-kwmad.kim@samsung.com>
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
X-CMS-MailID: 20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
	<CGME20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd@epcas2p1.samsung.com>

Extend ufshcd_mcq_sq_cleanup() to poll the OCS field in the UTRD of a
device management command after a successful SQ_CUS poll. UFSHCI does not
specify the order between the OCS update and the SQ_CUS update, so OCS may
still be stale when cleanup returns. Without this poll, a late response to
a timed-out query can arrive while a retry is already in flight, leaving
the host with two query contexts and raising IS.UTPES.

The poll is limited to device management commands because
ufshcd_compl_one_cqe() copies the OCS from the CQE into the UTRD only for
them. For SCSI commands, the OCS in the UTRD stays
OCS_INVALID_COMMAND_STATUS, so polling it would always time out.

The poll waits until OCS is no longer OCS_INVALID_COMMAND_STATUS or
MCQ_POLL_US elapses. -ETIMEDOUT is returned only if OCS is still
OCS_INVALID_COMMAND_STATUS after the poll. Any other value, such as
OCS_ABORTED reported by the host controller for the cleaned-up request,
means the cleanup has completed.

The OCS is read under hwq->cq_lock. ufshcd_compl_one_cqe() updates the
OCS under that lock before it sets cmd->result and calls scsi_done().
Without the lock, cleanup could observe the new OCS and return while the
completion is still running. The abort could then finish the command and
a retry could reuse the same reserved request before the pending
scsi_done() call, which would then complete the retry prematurely.

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

4. The driver retried the query again, but the device didn't return anything,
so the query was also timed-out.

[ 7385.660108] [3:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_query_flag: Sending flag query for idn 14 failed, err = -11

5. A few seconds later, the device returned the response of the 1st query,
but since the host was holding two query contexts and couldn't handle it,
it raised IS.UTPES.

Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ abort")
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..44214616d9db 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -550,6 +550,18 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
 	return err;
 }
 
+/*
+ * ufshcd_compl_one_cqe() updates the OCS under cq_lock before calling
+ * scsi_done(). Holding cq_lock here makes sure that the completion has
+ * finished once the updated OCS is observed.
+ */
+static enum utp_ocs ufshcd_mcq_read_ocs(struct ufs_hw_queue *hwq,
+					struct ufshcd_lrb *lrbp)
+{
+	guard(spinlock_irqsave)(&hwq->cq_lock);
+	return READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
+}
+
 /**
  * ufshcd_mcq_sq_cleanup - Clean up submission queue resources
  * associated with the pending command.
@@ -609,6 +621,23 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
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
+
+		err = read_poll_timeout(ufshcd_mcq_read_ocs, ocs,
+					ocs != OCS_INVALID_COMMAND_STATUS, 20,
+					MCQ_POLL_US, false, hwq, lrbp);
+		if (err)
+			dev_err(hba->dev, "%s: OCS not updated. hwq=%d, tag=%d err=%d\n",
+				__func__, id, task_tag, err);
+	}
+
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err = -ETIMEDOUT;
 
-- 
2.43.0

