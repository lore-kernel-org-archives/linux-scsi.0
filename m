Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794460548;
	b=RltjrMousjXOrtIy+g/RCQn/vH9HXaokKN4bJ/GL7JnaDkdUCOKtUtMiyhMpXEFCN22o
	 loB3iQpbiVr2ZfMzAFKY/5zfYjgZApKn/uRoiY1PQl6O+PU8xmXWlpQ5LgFoR2dSD9oWI
	 dACaGuhB9RGua7llC9OrleoPUAQOJorg8F0gXAfw8ODH3Fqtni/BBl/WkNqf3WZrQElSX
	 OuSVkcMTioxc3vaPSh3IiWR6zFaL1q+syhXxwReHTDE7jHuwsd3mqm+DeFeXxnlLmX157
	 xjkCXW1UfOYiMdkxsqSHucCZ3zrK6WIMTDJJrS+sxTZqh0bCocgH34gP2V7X65aWo9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794460548;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=/euiYumCtsvNbf4xO0nQ78kwGJZBuH9NQyVFpjft41o=;
	b=Mm8X1Fyx+aK6YioJm4TK/hC0AnyLt9iEmYiKH4EwLQrHMDQBaN3LdnZlO+jB47OEGL1X
	 /fVZWnzbnSIxzRkGCFn6P+whyrGEoAjHQHEm86ESPkEnH0+Sox/vUlZ1axtssR+JuRovm
	 VuoriwVmHDuY62Ay6tB5Of26NfT9dGJIXtp0dPOI4Qq9D9/GwjeOcJOS94zluDgebPZIJ
	 +OxHb4pFuVtazY3aTisXI6h4jWdp76p85Y0PV0J7+3exQ/FSxRWhF24/Ed+W6viRR6qpO
	 eBgRLpsYpufAJFFF1+xYPHnTf9/U/426Gxq7AoYRIXPFWQMTA1eZHHGhKHDyZX0VvDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MovcK8iQ;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6373D606A33F
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6373D606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MovcK8iQ
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a0592d4539so5189656b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 21:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794460548; x=1795065348; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/euiYumCtsvNbf4xO0nQ78kwGJZBuH9NQyVFpjft41o=;
        b=MovcK8iQyGvo4HkmSHmzjH3Pn0155+cYq3mT+kf6R/Z76p+4EAfX5wS750nDeBNAlX
         3CIb/IcIrgF1seEhFXoVzAXshDY4MnssnUDs5IGnBW9Mec35r4EvY/tWyYYEovbCUCXu
         U4oYHG3LSSJolvpO/zFHLL7PWWVIHw/FDTPAoW5mgTjv/HzN6ATp5EntQLexv/tC+gh4
         1OTBGA66h2Umo2+TaP4xraND1+m+xGVFTSmFSVImo3nn/9x7CZvpZ7Tyko1KcW95mG5X
         pP30oCgVk02ZRP8f0uIusNgFxa+DzS6rVBH8f31LfxRmFmAVITK8YNMWD580/wLdhCph
         nLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794460548; x=1795065348;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/euiYumCtsvNbf4xO0nQ78kwGJZBuH9NQyVFpjft41o=;
        b=2AcG5owdP24eFrmrNdL4BlRgiKoAF6gr3KbPaOfhVQiwn7UkomTlVWWhvMkO+cPHCI
         Uije5ufiljPemgBXlrl/VUgsRsN2wLegkf4+skwoPmraARGaRJagZQsM/9FHZoV+0nnA
         7cJi+0m/btefMLKGcIlM/81qyx+WE/MRzW17KgfRImPIRPEmAi6WpMc6B2/qBA5hoC2r
         tSMELAv5puU5kQ4gi4gy80VFTtEOixqiFhBz/NDkSF/mKtVYghjU+lwTodvX6UffXcnF
         haoB0z/WHY467705JJWssZI/N8LZvD3mcurdyMn2do/RtSK4+u1q3NIbpIGLEl2vS4PS
         72Mw==
X-Gm-Message-State: APuU4Z/WXgJZ6gewfwlGTpB08UEnJIFor1c1HvmgLq96i+mmfbWNA82j
	bGFj2IjUZ0Ze0oVaa/CMlbTfYi4b6aqdRxwaMjl5VtS47PVw4XyA8nrHAFGeTCqcw5QLigdEUHX
	HibdP1q7nuYDJ9S4ylZrzBwYWauEkZHLbOvQHjxq//rlNfuYYIwY23oSjIliEMAwabGkIwaz+QJ
	EBWEmcqTZerg6sqxfXpcvM1ugMEn/Gg8EpitnpvGTCsQG7dUQeBzlzq/LtTOgFA+E=
X-Received: from pfmu23.prod.google.com ([2002:aa7:8397:0:b0:89e:c160:ca9a])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:9512:b0:899:21db:3f6c with SMTP id d2e1a72fcca58-8bc18874be7mr4415034b3a.1.1794460547415;
 Wed, 11 Nov 2026 21:15:47 -0800 (PST)
Date: Thu, 12 Nov 2026 13:15:34 +0800
In-Reply-To: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112051542.1539779-2-stanleyjhu@google.com>
Subject: [PATCH 1/9] scsi: ufs: core: Do not poll unconfigured MCQ queues in
 the error handler
From: Stanley Jhu <stanleyjhu@google.com>
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>, 
	Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Hongjie Fang <hongjiefang@asrmicro.com>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, HOYOUNG SEO <hy50.seo@samsung.com>, 
	Brian Kao <powenkao@google.com>, Jens Axboe <axboe@kernel.dk>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In MCQ mode, ufshcd_err_handler() can poll completion queues that a
failed reset left unconfigured:

1. The UFS device W-LUN is runtime suspended with the link in hibern8.
   The device stops responding and the host reports a fatal UIC error,
   so the interrupt handler schedules ufshcd_err_handler().
2. ufshcd_err_handler() passes its first stop check and calls
   ufshcd_err_handling_prepare(), which resumes the W-LUN through
   ufshcd_rpm_get_sync().
3. The resume fails to exit hibern8 and calls ufshcd_link_recovery().
   The reset completes all outstanding requests, but link startup fails
   before the MCQ queues are configured, leaving UFSHCD_STATE_ERROR.
4. ufshcd_err_handler() calls ufshcd_complete_requests(), which logs
   "Abnormal CQ entry!" for each empty slot and writes the head pointer
   of each unconfigured queue.
5. Only the second stop check sees UFSHCD_STATE_ERROR and gives up.

Check the stop condition under host_lock right after preparation and
skip ufshcd_complete_requests() when error handling is going to stop.
The failed reset has already completed every outstanding request
and has not set up the completion queues again, so there is nothing
to poll.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 96e25a0a1dbe..e9dcab35a4cd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7093,6 +7093,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	unsigned long flags;
 	bool needs_restore;
 	bool needs_reset;
+	bool stop;
 	int pmc_err;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
@@ -7141,10 +7142,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	spin_lock_irqsave(&hba->host->host_lock, flags);
 	ufshcd_set_eh_in_progress(hba);
+	/* A PM callback in the preparation above may have reset the host. */
+	stop = ufshcd_err_handling_should_stop(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	/* Complete requests that have door-bell cleared by h/w */
-	ufshcd_complete_requests(hba, false);
+	if (!stop)
+		ufshcd_complete_requests(hba, false);
 	spin_lock_irqsave(&hba->host->host_lock, flags);
 again:
 	needs_restore = false;
-- 
2.56.0.567.gdb80ae8cd5-goog

