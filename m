Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B687D4DB54D;
	Wed, 29 Jul 2026 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336485; cv=none; b=bJX51iTWsjhtMFElyHyJYg1wtVDqo7Si37DpVdgWxZdJjUbcSKZqVrZa3iVR6n2HsYpWPRkxujULtUft5Ia2FpBN8vGthlleDLMoYFDcY5UeUrh9f/YMD84qsbVHDlWxkbvLdTivlNDJppxD4rfS7Jo8uGuQDHy8Ae6fZiR+SE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336485; c=relaxed/simple;
	bh=0gEUJ40CfYtfNlgTkiVkcl89Qp3XAtA0wUJ95QuyLew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ2rtNXa6i5l0/CNXbsmb2h5z1KjjK9Qfah27xQ5wwMH3UoWLfVBZsDK66VfzE0Sw5YBvdnhoh4i7m7Xg2waicc3S1Y5hLlaHG92bgOtVH8BBENsY42htKZ8VqUQn0MqqIwu0RkA9+e1CF7kYexlI22xXjTcOS0HiwVxaLJLpKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=JWMlryZa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ux4zFOwp; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="JWMlryZa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ux4zFOwp"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id BCD90EC01F6;
	Wed, 29 Jul 2026 10:48:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 29 Jul 2026 10:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1785336482; x=
	1785422882; bh=sb3YMUtQGr9m55xGL3W4Zf4+yxKgBq4/qdt3iz2BD24=; b=J
	WMlryZabgi/HmorpjfRK3zwXC40IT2hVoA1ZEJRLdZUaegnqn44bIDP1qE4hLbaN
	Dyf1niAnvSSrnvrLZ+fEeENGKiIKtK83L5H1Q+mqW2JZtRWmTjmrvy8VkYNc7++M
	Ogl9w/1DQpb0ciidkBWNqWvMfPzw9gMolYAnpwtpSjmb+WxsfPWbGxuF3eRxTHRi
	/S0JH8c4z7CRGg3vtat+LY3t7CcokV1JnXNr1hvaGYJq1GKkmkaLrAJg0IkmEdYc
	lGIavtb1g4Zd+3Q7UHY5ifE1+LfYrylRJYK4UU+CpCGf0NRMa6PzJjM1mZXxR2yz
	rQCCCAOy5qx02/94oY8sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1785336482; x=1785422882; bh=s
	b3YMUtQGr9m55xGL3W4Zf4+yxKgBq4/qdt3iz2BD24=; b=Ux4zFOwpgJyAdRXPc
	zAi/zHK602hi6xMvzdAgwoWy8R2lYBg8m+DBM+kDd8VgGHEr/LJKoQc0n6wIuX3A
	RKR98ZB6l98pOjK2PYv7c9Gp4D42weLdBWGwwAsYLSvBDVnS2IBlCd2MHx8wDrpb
	uMFGlpNFmxaMWeFpmTPs9hRVR24JbGmr3p8dqlZWb/Ce03K2MqQUtNTZXLZjDbCi
	MDZJ5mN8Xsk0N33e+q7ncwOi6K19mSOj02lnEXCJg9OLn6DwpzCBPTEmriEJyLNP
	YhYdzaT8j+LnPvaZm5LPvoyxG4UZgPm9/y7ybIIDecmLD2yOYKPSpwXCZXqGy9RC
	1BG3Q==
X-ME-Sender: <xms:ohJqavofRIvRVPgFHRfg1vxPjqHK4imeAvAeW10Wf90vd6bDEZeZ3A>
    <xme:ohJqarM1O5ALln93hc-2hLcfymxWfqdfeHsl91ckymzA7DZNUDX_TLy-KOf6AiSWv
    A6nBAUz9ja_h6PrccAICSKXZm8Vrvi6ryv35TG0aXUs77YLepaw7Y-5>
X-ME-Received: <xmr:ohJqaiiWRM7ZNDlzBtNbvqtOSQ0NtBQS8NjKq4tGv5QtdWdwxeg-Wjgs1rU>
X-ME-Proxy-Cause: dmFkZTFtOhiOm3KpBvhcLw7jxoOG3HPPAUbOj+HUD2PIj3WkQZgMngYb/zHlwyToc4DWSw
    In6hKjq9SNB4QDuYbq5c+VFSI75N7Y33EPntpUZT9vAlj97S0QPkDGmpkNX4383F6z7N+v
    35K6lqxCG84bAKSoIgP9F+RZwJI/7Xg81XtZHC4BUeK3UThInNrzAITOkV8wZlNNItW6qn
    HoksfxlFjexBeFuvZ73FeeUnbV3bRMtdx+0JymzTCMS+2ySF/PBbrNIiKPlUcDK1PzogUO
    fi+usYI3+NEaup+stegP0FG6DcNEWF479JdqzuAxqxwGCLx4P7GhoogjBVwDqzZxXwz8TF
    L/PJbJqpczoyKTMTH9RSMJsu1a0rF7eCE63YfilcHC/EC0AOBELR3lE+s3ZvViT16GYgjH
    HOVkFPls4u0M6U6Bea2dj2Iwh6lZoxczhm96+hIypDZu2itY47/mIpC1Oy/v4CaV0190jP
    3bt+BT6wUGzWsyKqEu6OnILJqswFq3zG2fPxbPDKDGB8RTOBE+q4kuMoNQFH4omSnWAoRs
    H4HEtQGg6Ju04v3KOhGODvtDIKE2dcqNt/b2NEAy2ULsqi7YPm8e62nHICwdupNGZDzUlQ
    aK/H5Be9nnj+vmGfIb8Ry92HUkbA8M88uF99vVSnMQyBhraJQmZzFvpIpEiQ
X-ME-Proxy: <xmx:ohJqausXogJgv0AxLMpIHVpuc-b-LNosFDMiWHsfX-oMkpBUKjW5Qw>
    <xmx:ohJqamhSmse5UGRFHZYuwbyyXaEfnPqeJCakGDJM1DgEO90sziSCzA>
    <xmx:ohJqakZevCZyTN8HZVea5OUDGe9HgWNK6yrO5YwmewRRJdFxaFvZFQ>
    <xmx:ohJqalZ_cTDwHERrXkoBDyxROp_bTlPQNu-tvuQo-L24tFU6M_0jrw>
    <xmx:ohJqapbDSbM81ncK5ZUrhRTmBPIZW2xQ_hYfAVi8LMTSnlXlSVIHcVfR>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 10:48:02 -0400 (EDT)
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
Subject: [PATCH 3/5] scsi: lpfc: Replace strlcat() with seq_buf in lpfc_rx_monitor_report()
Date: Wed, 29 Jul 2026 09:46:15 -0500
Message-ID: <20260729144617.1388646-4-icb@fastmail.org>
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

In preparation for removing the strlcat() API[1], replace its use in
lpfc_rx_monitor_report().

The function accumulates one line per ring entry, which is what
seq_buf is for. seq_buf tracks the write position, so the per entry
strlen() rescans of the destination are gone. Each record is still
formatted into the tmp buffer. seq_buf_puts() appends it only when
it fits whole, so the output keeps ending at the last complete
record. The loop still stops on overflow without consuming the
current entry, and the returned count and the ring head keep their
old meaning. The produced bytes are unchanged.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
seq_buf_puts() accepts a record under exactly the same condition as
the replaced length check, so truncation keeps ending the output at
the last complete record and a partial record can never reach the
buffer. The differential harness compared 50000 randomized rings
and buffer sizes, including buffers that overflow mid ring, and
found byte identical output, entry counts and ring heads
everywhere. The KUnit corpus reproduced the overflow case with a
populated ring as compiled kernel code and confirmed the same.

 drivers/scsi/lpfc/lpfc_sli.c | 43 ++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 62a30a92b792..cfa4371169f1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/seq_buf.h>
 #include <linux/slab.h>
 #include <linux/lockdep.h>
 #include <linux/dmi.h>
@@ -8109,17 +8110,18 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 	u32 cnt = 0;
 	char tmp[DBG_LOG_STR_SZ] = {0};
 	bool log_to_kmsg = (!buf || !buf_len) ? true : false;
+	struct seq_buf s;
 
 	if (!log_to_kmsg) {
 		/* clear the buffer to be sure */
 		memset(buf, 0, buf_len);
 
-		scnprintf(buf, buf_len, "\t%-16s%-16s%-16s%-16s%-8s%-8s%-8s"
-					"%-8s%-8s%-8s%-16s\n",
-					"MaxBPI", "Tot_Data_CMF",
-					"Tot_Data_Cmd", "Tot_Data_Cmpl",
-					"Lat(us)", "Avg_IO", "Max_IO", "Bsy",
-					"IO_cnt", "Info", "BWutil(ms)");
+		seq_buf_init(&s, buf, buf_len);
+		seq_buf_printf(&s, "\t%-16s%-16s%-16s%-16s%-8s%-8s%-8s%-8s%-8s%-8s%-16s\n",
+			       "MaxBPI", "Tot_Data_CMF",
+			       "Tot_Data_Cmd", "Tot_Data_Cmpl",
+			       "Lat(us)", "Avg_IO", "Max_IO", "Bsy",
+			       "IO_cnt", "Info", "BWutil(ms)");
 	}
 
 	/* Needs to be _irq because record is called from timer interrupt
@@ -8131,24 +8133,27 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 
 		/* Read out this entry's data. */
 		if (!log_to_kmsg) {
-			/* If !log_to_kmsg, then store to buf. */
+			/*
+			 * Drop a record whole if it does not fit, without
+			 * consuming its ring entry.
+			 */
 			scnprintf(tmp, sizeof(tmp),
-				  "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu"
-				  "%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
-				  *head_idx, entry->max_bytes_per_interval,
-				  entry->cmf_bytes, entry->total_bytes,
-				  entry->rcv_bytes, entry->avg_io_latency,
-				  entry->avg_io_size, entry->max_read_cnt,
+				  "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
+				  *head_idx,
+				  entry->max_bytes_per_interval,
+				  entry->cmf_bytes,
+				  entry->total_bytes,
+				  entry->rcv_bytes,
+				  entry->avg_io_latency,
+				  entry->avg_io_size,
+				  entry->max_read_cnt,
 				  entry->cmf_busy, entry->io_cnt,
-				  entry->cmf_info, entry->timer_utilization,
+				  entry->cmf_info,
+				  entry->timer_utilization,
 				  entry->timer_interval);
 
-			/* Check for buffer overflow */
-			if ((strlen(buf) + strlen(tmp)) >= buf_len)
+			if (seq_buf_puts(&s, tmp) < 0)
 				break;
-
-			/* Append entry's data to buffer */
-			strlcat(buf, tmp, buf_len);
 		} else {
 			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 					"4410 %02u: MBPI %llu Xmit %llu "
-- 
2.47.3

