Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937AF433AD;
	Wed, 29 Jul 2026 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336496; cv=none; b=PdgGBo/d0e0US9o4ttzNZbDwP91WXQpU3LdhYZ4jhXkvQje3MWSHYf2DXzPKZOVdP3OOVq4jC3gsVixzXMHHllc+L5zfIpS94BDWvYlLC09savJdtvtHQ5jBmUeEEAVAnZYjEuCLIRiQ+N2qGjLZRGgs0FHdM1MYGl4KDmhA20k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336496; c=relaxed/simple;
	bh=5KQs6lVgx7nHnAl6zlwM7WqNXnj8hl1UH/WZAKjAySw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orxoeie70JD3r2cJB6B6h5eqpQ8JmNBAryhH0/WUxRkRRMyi+ZuveReFq7yNfZVZJ+s1AWNrnivBQJEeDYgNG/omO5N8T4WWVtJm9obZPOC6L9eb4fJVZ88aPgKOfbmTQ5OvSJWv/i3NzpEqLFbJyCT+jCnvzSq1u4g3EKhKVBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=vPoMIDSo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=myxWvwUb; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="vPoMIDSo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="myxWvwUb"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id A65E2EC0087;
	Wed, 29 Jul 2026 10:48:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 29 Jul 2026 10:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1785336493; x=
	1785422893; bh=DVp5cApcg9CHrgZH3g5czh0ZFy8hODO/GysuHs6vWvw=; b=v
	PoMIDSo4jPge5QyIC3j6g95+PPIg/0GEwqu1I7iGMw32J5vICvq1sRSWFbP1iKe3
	PMIxWFsnNAHKbxlzr+KyGZ9sMw2715u6OvF7uMCDm1pp/b9lFTxn/r8R0dj86ZqA
	YfCsbJc6jbCi+0GegxebtgnbUw+JchDCFjyBU5KxbGYjTskrFp0iBAXDCIvd9gwr
	NFbitt0VqmXfk4Sqi0rTzmXK9u6XWBZxCZgACsZpnHDXZn7+itvr2/BIIzlUKc7M
	NzvwrTykVe+ceghgdte03S3t+JbPXIKSfLfngEHHUzZ21x6+PVTShvJO8qwsRfb7
	GnITh84YBwrf0P50FO16w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1785336493; x=1785422893; bh=D
	Vp5cApcg9CHrgZH3g5czh0ZFy8hODO/GysuHs6vWvw=; b=myxWvwUbU45TM8Tmu
	4GBKiW+beMRibtfdCXD++qPLJLwpdx5m3jVuotZDv7S/K1dUTbXSuDsV+hxqWPUe
	uT5rzQNIhW09LJi9oY81WTDHDCYohDKAuOHnNKd/bfnWj0F6HW5DSiiVLyMb33MA
	BxBw5QvtbOBYyEFFHEHhRhxHxxEmorwmEkZoeboLbm1HfMAwCdf5wAu9uvtM0hel
	hm/llj0cg4QodoAmTNaIYiMmQbP1Y4iy42Crv9V/M9jJ2qYqx115zvBFX0ASI+KV
	hTdVuasJCHFroxbp9XqBbYygNQBsD/BYm8yCoEWCbiOMSCjRxiLg/p3Uo3RGD2kc
	3N/2A==
X-ME-Sender: <xms:rRJqahgZfi6U1fZYUzBLpvALQRLi2Qbeyn6ufDcUd6HparFtUBZHdA>
    <xme:rRJqamf1_RkT7-89AljXLCH9098pY4RQ8pQgcCxKeK70zB7ca-fOFkhSOeUpdJ--9
    lyXZ2TuUyrhT6NnPwAIf81r91oe6qzTsXpiClLvI82yUYDJoFhxZCE>
X-ME-Received: <xmr:rRJqahwDl5Hj06ppoobv1UlqLcZ7JA9QaSd2BuPXF0vWC87oXL6EuV11fpo>
X-ME-Proxy-Cause: dmFkZTE5wi+MJyxorOdh+JrXF7qz5KRVreYk35RR2Kg6L8Et7FGxNH+4pMHnx93nafKHyg
    mv2tR7lAEbIoRz1AaZsSvvlPQKJK7bt33Sz3Aow9iVuGPdr4i9KQQtJnM4PD+2PoSaNouj
    65yuTZA7PqrcryfwhUlBNGkxFv/vYmJ+B8BoPCKGKAejbleK+5nBVPZAoNLs8FcOCFrg6A
    r5QKWS+pYvCbxGzqyJjj5ybN05UdgNV57Oa2ThEkCzTW9P9tRm25QrASBpOKsEs92hpXn1
    Vq7jFlXxxKOMHt692f9GUyIun7LeiMce8N6zKO3+Nmo5qUk0E5elX2yTQ8fFB7zbZyJnr+
    rmIdW0kO6RzzoiPIcpPbdMDCv3SP07YOpPpRLJBjJQIS5zmn9CMfueCqLJLgzSN1BmoOEq
    DiVRBcTrAoD+VGoH9/bOVSO9voP4xik5ruHvhpGnF8YylFTQ6uRtH4ltYj2i3PWbnFoIO1
    wAcUzBOgxHUlkyS3YlbPdNfvmhuEg+79gMYKFwh0KwaB85ahxJvAQNNd/HBpHDeYZmv5a9
    8khy/vYsiCrP9RTz73v0eomewNjDY2E61IwMcLTwLNHOzOWLah5n9gR9PrQxy3Y7Vnchhe
    ihga8UdBB7p31qoVw22UqkbYF/s4miuARg7tgN25e2gQ0ub0N6N7DvzVQm6w
X-ME-Proxy: <xmx:rRJqat1hs0e1qmXYaqBVWiIYp2tptY0B5bL8G3WYV1SSx7C7W6DGag>
    <xmx:rRJqavxxrwLD-MHGPAnnu5CJpVVvD3lu6KBD5wLgtvdAb_aJcJXPpw>
    <xmx:rRJqaqXx4JGoN4eZEY2qFVXXVDJ8hZKQy4trCQFcey7v1hsqnWuAHg>
    <xmx:rRJqaj_5GmzhM9po3DbjiB8dfieZlL30s9DK4G1kF8BuPieIGmzBvg>
    <xmx:rRJqalqqKPFISwcNIPBJy8SXsnC1y1CqX54SlKY91UwUXGGTHBuonR3q>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 10:48:12 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 4/5] scsi: lpfc: Replace strlcat() with seq_buf in the debugfs dump helpers
Date: Wed, 29 Jul 2026 09:46:16 -0500
Message-ID: <20260729144617.1388646-5-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144617.1388646-1-icb@fastmail.org>
References: <20260729144617.1388646-1-icb@fastmail.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for removing the strlcat() API[1], replace its uses in
lpfc_debugfs_multixripools_data(), lpfc_debugfs_scsistat_data() and
lpfc_debugfs_hdwqstat_data().

Each helper accumulates a variable number of lines into the debugfs
buffer, which is what seq_buf is for. The intermediate tmp buffers and
the per fragment overflow checks become unnecessary. Once a seq_buf
overflows, later writes to it do nothing, so dropping the early exits
does not change the produced bytes. Each loop that appends keeps one
seq_buf_has_overflowed() exit, so a full buffer stops the iteration.

lpfc_debugfs_multixripools_data() and lpfc_debugfs_hdwqstat_data()
append to whatever the buffer already holds, so their seq_buf is
anchored at the current end of the string. All three helpers keep
returning strnlen() because seq_buf_used() reports the full buffer
size after an overflow.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
The differential harness compared 90000 randomized cases, including
full range counter values, prefilled buffers for the two anchored
helpers and undersized buffers, and found byte identical output and
return values everywhere. The KUnit corpus confirmed the same as
compiled kernel code.

Notes on the loop exits. Each loop checks seq_buf_has_overflowed()
once per iteration because every iteration makes several appends.
seq_buf itself writes nothing after an overflow, so the exits change
no bytes, which the harness verified. A userspace timing comparison
of the old and new function bodies, extracted verbatim from the two
trees, measured the conversion 1.2 to 2 times faster than the old
code at every queue and CPU count up to the driver maximums, with or
without the exits. The strlcat() rescans dominate the old cost. The
exits bound the remaining iteration work once the buffer is full.
That is measurable only for lpfc_debugfs_hdwqstat_data() at maximum
queue and CPU counts, where the per CPU walk is the largest loop.

 drivers/scsi/lpfc/lpfc_debugfs.c | 202 +++++++++++++------------------
 1 file changed, 87 insertions(+), 115 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 052023fc1733..30e3cc050aaa 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -27,6 +27,7 @@
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/kthread.h>
+#include <linux/seq_buf.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
@@ -462,7 +463,8 @@ lpfc_debugfs_multixripools_data(struct lpfc_hba *phba, char *buf, int size)
 	struct lpfc_pvt_pool *pvt_pool;
 	struct lpfc_pbl_pool *pbl_pool;
 	u32 txcmplq_cnt;
-	char tmp[LPFC_DEBUG_OUT_LINE_SZ] = {0};
+	size_t used;
+	struct seq_buf s;
 
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return 0;
@@ -475,6 +477,9 @@ lpfc_debugfs_multixripools_data(struct lpfc_hba *phba, char *buf, int size)
 		return i;
 	}
 
+	used = strnlen(buf, size);
+	seq_buf_init(&s, buf + used, size - used);
+
 	/*
 	 * Pbl: Current number of free XRIs in public pool
 	 * Pvt: Current number of free XRIs in private pool
@@ -484,10 +489,8 @@ lpfc_debugfs_multixripools_data(struct lpfc_hba *phba, char *buf, int size)
 	 * pbl_empty: Incremented by 1 when all pbl_pool are empty during
 	 *            IO submission
 	 */
-	scnprintf(tmp, sizeof(tmp),
-		  "HWQ:  Pbl  Pvt Busy  HWM |  pvt_empty  pbl_empty ");
-	if (strlcat(buf, tmp, size) >= size)
-		return strnlen(buf, size);
+	seq_buf_printf(&s,
+		       "HWQ:  Pbl  Pvt Busy  HWM |  pvt_empty  pbl_empty ");
 
 #ifdef LPFC_MXP_STAT
 	/*
@@ -501,25 +504,17 @@ lpfc_debugfs_multixripools_data(struct lpfc_hba *phba, char *buf, int size)
 	 * othPbl_hit: Incremented by 1 if successfully get a batch of XRI from
 	 *             other pbl_pool
 	 */
-	scnprintf(tmp, sizeof(tmp),
-		  "MAXH  above_lmt  below_lmt locPbl_hit othPbl_hit");
-	if (strlcat(buf, tmp, size) >= size)
-		return strnlen(buf, size);
+	seq_buf_printf(&s, "MAXH  above_lmt  below_lmt locPbl_hit othPbl_hit");
 
 	/*
 	 * sPbl: snapshot of Pbl 15 sec after stat gets cleared
 	 * sPvt: snapshot of Pvt 15 sec after stat gets cleared
 	 * sBusy: snapshot of Busy 15 sec after stat gets cleared
 	 */
-	scnprintf(tmp, sizeof(tmp),
-		  " | sPbl sPvt sBusy");
-	if (strlcat(buf, tmp, size) >= size)
-		return strnlen(buf, size);
+	seq_buf_printf(&s, " | sPbl sPvt sBusy");
 #endif
 
-	scnprintf(tmp, sizeof(tmp), "\n");
-	if (strlcat(buf, tmp, size) >= size)
-		return strnlen(buf, size);
+	seq_buf_printf(&s, "\n");
 
 	hwq_count = phba->cfg_hdw_queue;
 	for (i = 0; i < hwq_count; i++) {
@@ -531,36 +526,32 @@ lpfc_debugfs_multixripools_data(struct lpfc_hba *phba, char *buf, int size)
 		pvt_pool = &multixri_pool->pvt_pool;
 		txcmplq_cnt = qp->io_wq->pring->txcmplq_cnt;
 
-		scnprintf(tmp, sizeof(tmp),
-			  "%03d: %4d %4d %4d %4d | %10d %10d ",
-			  i, pbl_pool->count, pvt_pool->count,
-			  txcmplq_cnt, pvt_pool->high_watermark,
-			  qp->empty_io_bufs, multixri_pool->pbl_empty_count);
-		if (strlcat(buf, tmp, size) >= size)
-			break;
+		seq_buf_printf(&s,
+			       "%03d: %4d %4d %4d %4d | %10d %10d ",
+			       i, pbl_pool->count, pvt_pool->count,
+			       txcmplq_cnt, pvt_pool->high_watermark,
+			       qp->empty_io_bufs,
+			       multixri_pool->pbl_empty_count);
 
 #ifdef LPFC_MXP_STAT
-		scnprintf(tmp, sizeof(tmp),
-			  "%4d %10d %10d %10d %10d",
-			  multixri_pool->stat_max_hwm,
-			  multixri_pool->above_limit_count,
-			  multixri_pool->below_limit_count,
-			  multixri_pool->local_pbl_hit_count,
-			  multixri_pool->other_pbl_hit_count);
-		if (strlcat(buf, tmp, size) >= size)
-			break;
-
-		scnprintf(tmp, sizeof(tmp),
-			  " | %4d %4d %5d",
-			  multixri_pool->stat_pbl_count,
-			  multixri_pool->stat_pvt_count,
-			  multixri_pool->stat_busy_count);
-		if (strlcat(buf, tmp, size) >= size)
-			break;
+		seq_buf_printf(&s,
+			       "%4d %10d %10d %10d %10d",
+			       multixri_pool->stat_max_hwm,
+			       multixri_pool->above_limit_count,
+			       multixri_pool->below_limit_count,
+			       multixri_pool->local_pbl_hit_count,
+			       multixri_pool->other_pbl_hit_count);
+
+		seq_buf_printf(&s,
+			       " | %4d %4d %5d",
+			       multixri_pool->stat_pbl_count,
+			       multixri_pool->stat_pvt_count,
+			       multixri_pool->stat_busy_count);
 #endif
 
-		scnprintf(tmp, sizeof(tmp), "\n");
-		if (strlcat(buf, tmp, size) >= size)
+		seq_buf_printf(&s, "\n");
+
+		if (seq_buf_has_overflowed(&s))
 			break;
 	}
 	return strnlen(buf, size);
@@ -1261,13 +1252,14 @@ lpfc_debugfs_scsistat_data(struct lpfc_vport *vport, char *buf, int size)
 	u64 data1, data2, data3;
 	u64 tot, totin, totout;
 	int i;
-	char tmp[LPFC_MAX_SCSI_INFO_TMP_LEN] = {0};
+	struct seq_buf s;
 
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_FCP) ||
 	    (phba->sli_rev != LPFC_SLI_REV4))
 		return 0;
 
-	scnprintf(buf, size, "SCSI HDWQ Statistics\n");
+	seq_buf_init(&s, buf, size);
+	seq_buf_printf(&s, "SCSI HDWQ Statistics\n");
 
 	totin = 0;
 	totout = 0;
@@ -1280,21 +1272,18 @@ lpfc_debugfs_scsistat_data(struct lpfc_vport *vport, char *buf, int size)
 		data3 = cstat->control_requests;
 		totout += (data1 + data2 + data3);
 
-		scnprintf(tmp, sizeof(tmp), "HDWQ (%d): Rd %016llx Wr %016llx "
-			  "IO %016llx ", i, data1, data2, data3);
-		if (strlcat(buf, tmp, size) >= size)
-			goto buffer_done;
+		seq_buf_printf(&s, "HDWQ (%d): Rd %016llx Wr %016llx IO %016llx ",
+			       i, data1, data2, data3);
+
+		seq_buf_printf(&s, "Cmpl %016llx OutIO %016llx\n",
+			       tot, ((data1 + data2 + data3) - tot));
 
-		scnprintf(tmp, sizeof(tmp), "Cmpl %016llx OutIO %016llx\n",
-			  tot, ((data1 + data2 + data3) - tot));
-		if (strlcat(buf, tmp, size) >= size)
-			goto buffer_done;
+		if (seq_buf_has_overflowed(&s))
+			break;
 	}
-	scnprintf(tmp, sizeof(tmp), "Total FCP Cmpl %016llx Issue %016llx "
-		  "OutIO %016llx\n", totin, totout, totout - totin);
-	strlcat(buf, tmp, size);
+	seq_buf_printf(&s, "Total FCP Cmpl %016llx Issue %016llx OutIO %016llx\n",
+		       totin, totout, totout - totin);
 
-buffer_done:
 	len = strnlen(buf, size);
 
 	return len;
@@ -1704,28 +1693,23 @@ lpfc_debugfs_hdwqstat_data(struct lpfc_vport *vport, char *buf, int size)
 	uint32_t tot_xmt;
 	uint32_t tot_rcv;
 	uint32_t tot_cmpl;
-	char tmp[LPFC_MAX_SCSI_INFO_TMP_LEN] = {0};
+	size_t used = strnlen(buf, size);
+	struct seq_buf s;
 
-	scnprintf(tmp, sizeof(tmp), "HDWQ Stats:\n\n");
-	if (strlcat(buf, tmp, size) >= size)
-		goto buffer_done;
+	seq_buf_init(&s, buf + used, size - used);
 
-	scnprintf(tmp, sizeof(tmp), "(NVME Accounting: %s) ",
-		  (phba->hdwqstat_on &
-		  (LPFC_CHECK_NVME_IO | LPFC_CHECK_NVMET_IO) ?
-		  "Enabled" : "Disabled"));
-	if (strlcat(buf, tmp, size) >= size)
-		goto buffer_done;
+	seq_buf_printf(&s, "HDWQ Stats:\n\n");
 
-	scnprintf(tmp, sizeof(tmp), "(SCSI Accounting: %s) ",
-		  (phba->hdwqstat_on & LPFC_CHECK_SCSI_IO ?
-		  "Enabled" : "Disabled"));
-	if (strlcat(buf, tmp, size) >= size)
-		goto buffer_done;
+	seq_buf_printf(&s, "(NVME Accounting: %s) ",
+		       (phba->hdwqstat_on &
+		       (LPFC_CHECK_NVME_IO | LPFC_CHECK_NVMET_IO) ?
+		       "Enabled" : "Disabled"));
 
-	scnprintf(tmp, sizeof(tmp), "\n\n");
-	if (strlcat(buf, tmp, size) >= size)
-		goto buffer_done;
+	seq_buf_printf(&s, "(SCSI Accounting: %s) ",
+		       (phba->hdwqstat_on & LPFC_CHECK_SCSI_IO ?
+		       "Enabled" : "Disabled"));
+
+	seq_buf_printf(&s, "\n\n");
 
 	for (i = 0; i < phba->cfg_hdw_queue; i++) {
 		tot_rcv = 0;
@@ -1744,62 +1728,50 @@ lpfc_debugfs_hdwqstat_data(struct lpfc_vport *vport, char *buf, int size)
 			    !c_stat->rcv_io)
 				continue;
 
-			if (!tot_xmt && !tot_cmpl && !tot_rcv) {
-				/* Print HDWQ string only the first time */
-				scnprintf(tmp, sizeof(tmp), "[HDWQ %d]:\t", i);
-				if (strlcat(buf, tmp, size) >= size)
-					goto buffer_done;
-			}
+			/* Print HDWQ string only the first time */
+			if (!tot_xmt && !tot_cmpl && !tot_rcv)
+				seq_buf_printf(&s, "[HDWQ %d]:\t", i);
 
 			tot_xmt += c_stat->xmt_io;
 			tot_cmpl += c_stat->cmpl_io;
 			if (phba->nvmet_support)
 				tot_rcv += c_stat->rcv_io;
 
-			scnprintf(tmp, sizeof(tmp), "| [CPU %d]: ", j);
-			if (strlcat(buf, tmp, size) >= size)
-				goto buffer_done;
-
-			if (phba->nvmet_support) {
-				scnprintf(tmp, sizeof(tmp),
-					  "XMT 0x%x CMPL 0x%x RCV 0x%x |",
-					  c_stat->xmt_io, c_stat->cmpl_io,
-					  c_stat->rcv_io);
-				if (strlcat(buf, tmp, size) >= size)
-					goto buffer_done;
-			} else {
-				scnprintf(tmp, sizeof(tmp),
-					  "XMT 0x%x CMPL 0x%x |",
-					  c_stat->xmt_io, c_stat->cmpl_io);
-				if (strlcat(buf, tmp, size) >= size)
-					goto buffer_done;
-			}
+			seq_buf_printf(&s, "| [CPU %d]: ", j);
+
+			if (phba->nvmet_support)
+				seq_buf_printf(&s,
+					       "XMT 0x%x CMPL 0x%x RCV 0x%x |",
+					       c_stat->xmt_io, c_stat->cmpl_io,
+					       c_stat->rcv_io);
+			else
+				seq_buf_printf(&s,
+					       "XMT 0x%x CMPL 0x%x |",
+					       c_stat->xmt_io, c_stat->cmpl_io);
+
+			if (seq_buf_has_overflowed(&s))
+				break;
 		}
 
+		if (seq_buf_has_overflowed(&s))
+			break;
+
 		/* Check if nothing to display */
 		if (!tot_xmt && !tot_cmpl && !tot_rcv)
 			continue;
 
-		scnprintf(tmp, sizeof(tmp), "\t->\t[HDWQ Total: ");
-		if (strlcat(buf, tmp, size) >= size)
-			goto buffer_done;
+		seq_buf_printf(&s, "\t->\t[HDWQ Total: ");
 
-		if (phba->nvmet_support) {
-			scnprintf(tmp, sizeof(tmp),
-				  "XMT 0x%x CMPL 0x%x RCV 0x%x]\n\n",
-				  tot_xmt, tot_cmpl, tot_rcv);
-			if (strlcat(buf, tmp, size) >= size)
-				goto buffer_done;
-		} else {
-			scnprintf(tmp, sizeof(tmp),
-				  "XMT 0x%x CMPL 0x%x]\n\n",
-				  tot_xmt, tot_cmpl);
-			if (strlcat(buf, tmp, size) >= size)
-				goto buffer_done;
-		}
+		if (phba->nvmet_support)
+			seq_buf_printf(&s,
+				       "XMT 0x%x CMPL 0x%x RCV 0x%x]\n\n",
+				       tot_xmt, tot_cmpl, tot_rcv);
+		else
+			seq_buf_printf(&s,
+				       "XMT 0x%x CMPL 0x%x]\n\n",
+				       tot_xmt, tot_cmpl);
 	}
 
-buffer_done:
 	len = strnlen(buf, size);
 	return len;
 }
-- 
2.47.3

