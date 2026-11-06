Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938387;
	b=QsbMua1sibx+/dCdmQBe+OkFHVdXSjcdSrDb9MTwg/qcMzEVIog9Jkt4wRMXs3c68Ab7
	 RAAZj+yhp4h06jkpUsrQqt1qeRjd9jBiUnprg2lJWaScWerFPuot6XjUgIkTq2mxIAs5H
	 HppwZhPqL8sJ4WZg7m4DX+mq5uAWpm+Qq6sRrg/Nihfl0sKoGopy3Lj0bvHwmU3VXR367
	 9iNhfcfGuj3rKqnUt9dLta2JTQwhkxH8vEc1wB/Nh6Sg/3svd2ukOZTlo4ZVDPY28QwgS
	 zUD6ikl9XH5qL7EaeyvRSPwQMLuryQMJuiSspjXs0xVlAm0ybqJI2DBzdv/fv7WWgag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938387;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=vCRGOPgiM/gBtAq94+3k6mg+/fapC6nO6h4gscjyIGw=;
	b=i6nu3QcXzYiXjzfGmru53dOhxUCZqIISLreFy/W86L+sMd2IjR8dehRQwfprPPWKk9hy
	 OcUqh6LSuP3jyi53iNIfdRLVurLzxmqC2jLwI5st+CwR7CPDlLemn/huS7NpVQpQ89bSV
	 shmGyDyRACIGKPL7QwgZdOaCvZp6LSFleA61cDF23It0hJ0yyPQyjhVjL6+986EsjCXuA
	 PytRPxBB0lIqKh6FVEUStYxEPdbGkZHM6Lqp4RDvc5JuX8TOJw4ky0OrZzbpA2k1UvX9b
	 LffXw6WANQgVD5AXnvV24SosCCVXaSNPuUKUCZdoHidi4TKJdMCjFFKxdJ8rEyRvmsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=eRAJA7wE;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1117606A332
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 04:13:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1117606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=eRAJA7wE
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261106041304epoutp03b242d52bdcf664cf83387775721b9ace~lWXTNVCBW2835328353epoutp03Y
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 04:13:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261106041304epoutp03b242d52bdcf664cf83387775721b9ace~lWXTNVCBW2835328353epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793938384;
	bh=vCRGOPgiM/gBtAq94+3k6mg+/fapC6nO6h4gscjyIGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRAJA7wER5w75ji7zR82BDuGnqcx9Lhn+k5sRGsLYpdAiqIQY7IcgpTWIRyzE8tS6
	 DsNDYbyREHHcStrz/wg8lRKxuhHy0SG2VE1JLvrKs+VUbLv3x6J8YAscxm/V5BZBOj
	 EERF+kb+tzDCWa5YsTyl+PyMqpoxGFf2v1uX8RgI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261106041304epcas2p1fe52624ac1f5f10981e7cf748f0fa8be~lWXSi9JHe2326223262epcas2p1y;
	Fri,  6 Nov 2026 04:13:04 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.205]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jLQl34vs1z6B9m5; Fri,  6 Nov
	2026 04:13:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106041303epcas2p19b0c317d409503c833ae125ba91fe053~lWXRnLONx2770927709epcas2p16;
	Fri,  6 Nov 2026 04:13:03 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106041302epsmtip1781cb810fe73631e09043871d87522c1~lWXRfec8s2894828948epsmtip1e;
	Fri,  6 Nov 2026 04:13:02 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v7 2/2] scsi: ufs: mcq: poll OCS after sq cleanup for device
 management commands
Date: Fri,  6 Nov 2026 13:12:47 +0900
Message-ID: <a1af44cd90dca0dd8a9a06d09a254a4e7e0861b2.1793938245.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1793938245.git.kwmad.kim@samsung.com>
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
X-CMS-MailID: 20261106041303epcas2p19b0c317d409503c833ae125ba91fe053
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106041303epcas2p19b0c317d409503c833ae125ba91fe053
References: <cover.1793938245.git.kwmad.kim@samsung.com>
	<CGME20261106041303epcas2p19b0c317d409503c833ae125ba91fe053@epcas2p1.samsung.com>

Extend ufshcd_mcq_sq_cleanup() to poll the OCS field in the UTRD of a
device management command after a successful SQ_CUS poll. UFSHCI does not
specify the order between the OCS update and the SQ_CUS update, so OCS may
still be stale when cleanup returns. Without this poll, a late response to
a timed-out query can arrive while a retry is already in flight, leaving
the host controller with two query contexts and raising IS.UTPES.

Here is the timeline of an actual case I found with kernel 6.18:

1. The driver sent a query but the device didn't respond to it
   for a long time.

[ 7384.156142] [4:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_mcq_sq_cleanup, hwq 0: cleanup return code (RTC) 0
[ 7384.156154] [4:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_query_flag: Sending flag query for idn 14 failed, err = -11

2. So after the query timed out, the driver did SQ cleanup. Then
   the host controller updated the CQ tail and raised IS.CQES.
   Unfortunately, complete() was called by the driver's ISR afterward.

3. The driver started to retry the query. In the meantime,
   it set OCS to 0xF. Then the driver didn't wait for completion due to
   the previous complete() call, and just checked OCS.

[ 7384.156163] [4:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_query_flag: Sending flag query for idn 14 failed, err = 15

4. The driver retried the query again, but the device didn't
   return anything, so the query also timed out.

[ 7385.660108] [3:  kworker/u40:5:10671] exynos-ufs 38300000.ufs: ufshcd_query_flag: Sending flag query for idn 14 failed, err = -11

5. A few seconds later, the device returned the response of
   the first query, but since the host controller was holding
   two query contexts and couldn't handle it, it raised IS.UTPES.

The same problem exists in the current code. If the query times out, the
SCSI error handler calls ufshcd_abort() -> ufshcd_mcq_abort() ->
ufshcd_mcq_sq_cleanup(), the request is finished, and the retry reuses the
same reserved tag, struct scsi_cmnd and devman UCD. A late CQE for the
first query then maps to the same tag and completes the retry by calling
scsi_done() too early. The retry then returns the OCS of the first query
and, if that OCS is OCS_SUCCESS, its response as well. Hence
ufshcd_mcq_sq_cleanup() must not return until the CQE of the cleaned-up
request has been processed.

The poll is limited to device management commands because
ufshcd_compl_one_cqe() copies the OCS from the CQE into the UTRD only for
them. For SCSI commands, the OCS in the UTRD stays
OCS_INVALID_COMMAND_STATUS, so polling it would always time out.

The poll waits until OCS is no longer OCS_INVALID_COMMAND_STATUS or
MCQ_POLL_US elapses. -ETIMEDOUT is returned only if OCS is still
OCS_INVALID_COMMAND_STATUS after the poll. Any other value, such as
OCS_ABORTED reported by the host controller for the cleaned-up request,
means the cleanup has completed.
The UFSHCI specification says "The host controller shall free up
any resources associated to the nexus, and shall post
a Completion Queue entry with OCS = ABORTED if clean up successful."

Each poll iteration reaps the CQ with ufshcd_mcq_poll_cqe_lock() before
reading the OCS, as ufshcd_clear_lu_cmds() does after ufshcd_clear_cmd().
This removes the dependency on interrupt delivery. Otherwise the OCS is
only updated once the interrupt handler processes the CQE, and a delayed
or lost interrupt would make the poll time out and escalate to a host
reset although the request has already been cleaned up.

The OCS is still read under hwq->cq_lock because the interrupt handler may
reap the CQE between the reap and the read. ufshcd_compl_one_cqe() updates
the OCS under that lock before it sets cmd->result and calls scsi_done().
Without the lock, cleanup could observe the new OCS and return while the
completion is still running. The abort could then finish the command and
a retry could reuse the same reserved request before the pending
scsi_done() call, which would then complete the retry prematurely.

Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ abort")
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..889f0b78034c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -550,6 +550,23 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
 	return err;
 }
 
+/*
+ * Reap the CQ directly so that progress does not depend on interrupt
+ * delivery. ufshcd_compl_one_cqe() updates the OCS under cq_lock before
+ * calling scsi_done(). Holding cq_lock while reading the OCS makes sure that
+ * the completion has finished once the updated OCS is observed, even if the
+ * CQE was reaped by the interrupt handler.
+ */
+static enum utp_ocs ufshcd_mcq_poll_ocs(struct ufs_hba *hba,
+					struct ufs_hw_queue *hwq,
+					struct ufshcd_lrb *lrbp)
+{
+	ufshcd_mcq_poll_cqe_lock(hba, hwq);
+
+	guard(spinlock_irqsave)(&hwq->cq_lock);
+	return READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
+}
+
 /**
  * ufshcd_mcq_sq_cleanup - Clean up submission queue resources
  * associated with the pending command.
@@ -609,6 +626,23 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
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
+		err = read_poll_timeout(ufshcd_mcq_poll_ocs, ocs,
+					ocs != OCS_INVALID_COMMAND_STATUS, 20,
+					MCQ_POLL_US, false, hba, hwq, lrbp);
+		if (err)
+			dev_err(hba->dev, "%s: OCS not updated. hwq=%d, tag=%d err=%d\n",
+				__func__, id, task_tag, err);
+	}
+
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err = -ETIMEDOUT;
 
-- 
2.43.0

