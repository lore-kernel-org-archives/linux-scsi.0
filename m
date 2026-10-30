Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793358659;
	b=zkn1bKcqkDRoA0eGWG4uIAQl96yTC8uD9EYywyw6DSa9Q/aoy4tfnK7AuRL4N5o3dk3p
	 CQARK9tUZeP9ePz/rXuBFyDIe0G5d7y6V3Yfz9rexxrl69g3VPaWkGBR3qusZLhYu8vHm
	 yZF+DvJsIVYIm0ozuHsHhOhlaqVeZ26N+ZC6LV54xRWAu3zy3iht9rrgrWJh2MnLZY8Yp
	 KU+hSVHkrEZQ0dqz5XZFGufvnWaBa+F3AA88VxLSBb4xyicYf15So+/7v6fj062stm1dp
	 f+QBQurx+ft3KSTNeF1NUsDCXf63K3XLrBT3h5T7DEtAi5lvEQI0D5X6x1WKrYg8YjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793358659;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=SY4wxRo5GhJ45am6vNPa4jgHWsz5BB1NdrAbB4X90Uk=;
	b=naFnQ4yH6HwYJA5ENFJn9Wt+jQ1WQwi2kOvKHIae60ME6TgQxGaO1RmvD2KVbtVgGYOB
	 U0NbJrJDEEeRHg0Dq8oK7oI7vW4pjUHoXaWI3Wr11fhSbxhkiIeE0Rg82o8/fvUxp2QA+
	 AisMAhB+9I5P25dcyTphjAnwUzYWT8zfFUle/o15AdIoaHZX78fMnrtTiL8plF5tp/6uS
	 aS/I/FrfFh2sazBoKh8IyWoEMVg9d5JqWomQXvoCunE8J+5W1rbBFZL1siXF+x8n2mUJE
	 4Dj3T1hSc80iqFDPENy7YdymniJIQjo2PhlRu32HXtok6+muDWj6yRgzpmUrSrQpQ1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=WuVsOsho;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B5F606A321
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 11:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78B5F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=WuVsOsho
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261030111053epoutp042a89e1193e930744246a291e8242f848~jSjGFxHX70493204932epoutp044
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 11:10:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261030111053epoutp042a89e1193e930744246a291e8242f848~jSjGFxHX70493204932epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793358653;
	bh=SY4wxRo5GhJ45am6vNPa4jgHWsz5BB1NdrAbB4X90Uk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=WuVsOshoTwpDilGuOk+yYKZ+QaJtFkyWyg4zQqIuGT0J9hEx1xdYog4XrQ179vH7u
	 zH0kf8sQmyCtkk94m3OtY7k+6lD+pHw/8L2wKj1HbOEnneKzPJBSdGcHiL/agNiSwo
	 UopOKbipVzjiUb1EEWUN/b6sCalAeiSVGOqcvS4M=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261030111051epcas2p1739d8d51872fed66f46b0d03aac8c37e~jSjE70Cls2221722217epcas2p1H;
	Fri, 30 Oct 2026 11:10:51 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.212]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jGJLM48MZz3hhT7; Fri, 30 Oct
	2026 11:10:51 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261030111051epcas2p225fb4eb84bfbd747782b5641f3831053~jSjEFl-1I2427424274epcas2p27;
	Fri, 30 Oct 2026 11:10:51 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261030111050epsmtip197593379bee8be86f3c259c6c18b1e03~jSjD9Mf1Y2560625606epsmtip11;
	Fri, 30 Oct 2026 11:10:50 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	hy50.seo@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v3] ufs: mcq: fix dev cmd abort path and add OCS poll after
 sq cleanup
Date: Fri, 30 Oct 2026 20:10:45 +0900
Message-ID: <20261030111045.982094-1-kwmad.kim@samsung.com>
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
X-CMS-MailID: 20261030111051epcas2p225fb4eb84bfbd747782b5641f3831053
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261030111051epcas2p225fb4eb84bfbd747782b5641f3831053
References: <CGME20261030111051epcas2p225fb4eb84bfbd747782b5641f3831053@epcas2p2.samsung.com>

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
Changes since v2:
- Use read_poll_timeout() for the OCS poll in ufshcd_mcq_sq_cleanup().
  The open-coded loop did not re-read the OCS after the timeout, so it
  could return a false -ETIMEDOUT if the OCS was updated while sleeping
  in the last iteration (Sashiko).

Link: https://lore.kernel.org/linux-scsi/sashiko-outbox-190791@kernel.org/T/#t

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

Link: https://lore.kernel.org/linux-scsi/sashiko-outbox-190714@kernel.org/T/#t
---
 drivers/ufs/core/ufs-mcq.c | 21 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c  |  4 ++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..7c2aa0e9466a 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -550,6 +550,13 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
 	return err;
 }
 
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
@@ -609,6 +616,20 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
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

