Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072755;
	b=K1JzoWhnI5D0IvZVUeWZDpwkFJIIqQ/aw31588HxoBN5fY30tkiA7PRMirwfBimA4tlp
	 HXw6DzInzpsOMRZerXKgaWDzD3nSA81LUEiZdqD++3tMg4G3VVtUE2od4Z3BB4Dw1LhQV
	 fdHu+aI7L7PfDEBJWBV+o4zSnjvCXQQh3qrNMNdkxNTN19oBPmSoPjLkJNrzE6I+uyYPB
	 1txLsuKT7nVv3Yp3jQA7SfgdR3pfHzDdsXPnHEIjz+j0+hqMHfYBbWbyhpeWlxRkQJWFQ
	 VR8l2GCp/jHCfl2haW6GT9ri074cVAQClQEYmlEgwIB5kIhZSMbDAIDRY1Iq1cj85tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072755;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=WdGhU9FDUYsLV9maIUKqrOWVjk5AhyXfc3nqsWQxQhk=;
	b=I/6FQz1csicDSuZ7M/ET+Een1mQ/LGEKTj7xRYmpBE823TW3cOm+4u8FZ7jStcrN1M4Z
	 UlyeYh22QC0A0CPy6JiQFp0UChv1TG5SNYwL9hhopHFBhcSvPyVn5N6glWOUFOdgiX95e
	 COfvkZW6JNDudtqBQyFN+EZ36l1U7aN33wRffT4MMxavTh/lLmDEqfqOTxXoAYrBFZD84
	 Ij9T84zVAIlDjM2rIWUA3jmPq/Fxt6sDzus4peTS8qU0waluZZFf7rb3mS9xjeHt4pIFG
	 Y//L/wD952WY1IzdE9ekBL6rHpj5ZawOIOD7++zqtkhpVFZgpNs3YzKlTCMJKxi8PkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=DbtRZ8kj;
	arc=none smtp.remote-ip=209.85.217.98
Received: from mail-vs1-f98.google.com (mail-vs1-f98.google.com [209.85.217.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DCF606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8DCF606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=DbtRZ8kj
Received: by mail-vs1-f98.google.com with SMTP id ada2fe7eead31-7d2eba2b74aso1010756137.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072753; x=1795677553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WdGhU9FDUYsLV9maIUKqrOWVjk5AhyXfc3nqsWQxQhk=;
        b=rNnvLCoVBiT8XweyH05qyUWdLJ3Eez4qdAobrc2vJrczg2sptR/Ww2W3FFTep1hf2f
         kVZGkTSsvdyNz2/jlI6UHtNXJWaWe9UsFAuPmTLVTcQiULxPe1Z0NEj/lI8H7G84d4MH
         QYtcyj5ExMkq3SdRkF9MivcaamVxMxcG6iOEoDIAsydwsubv8f3ANGhBi3JVriGupeBm
         6PqMFub8opAuenNmD3+DcMYNKzM1R4nO6WM/MiKfKqAKf1h7MmtnPSLXofZOdgOFuDxV
         trWPE0/v6lpmUkv4jVG5Oxi52rDIwM8EyQX48NgJs2eSIrBj0w5ZwJujLdZWplQgkrfC
         1BUw==
X-Gm-Message-State: APuU4Z81M6srRW0uvUuBy1XYV5nlDuqWJCZpUsXOZvQXOYpGCamWTiQg
	ZXyQMGEVdeMxt9yDr57Cpi+7ZrWIpA0Wikdvptnzg3g9KTnKA/RHAeBiYRd3ip/V2UeBXGeLs4n
	BNyIZX1LZZzy5FQS56lQjP1BMm2lXhRRcFnVm+KW4V53lOZOGFrtn/I6Dfws2Esez9HuI48qD/D
	9gsug7Tt+ew3+PNbHTZmG5YRiWfiVk9nqHtALhiYrQo6Vv/QhQGdEFUDtRS9ac0cbQQhtd5H5y9
	d6DVeUfqyelOHZR
X-Gm-Gg: AYBFou0eT/TmzljDBDK5Dw1GN79/50g7sYwT4XryOQjCr4GfGFGj72edylVyT4vsVpi
	f41NoMcLgkwqTiqq4xMrfGwqpWP2iG4L78KxAukv3VsXbfy0B2S9voh8ZX3SeyQdzMd2zKIlANC
	4rTyNBbf7SngDP9O1q/UnIWBnNTZgXdM5VQyIhr0qgEXSgOJYWbkBb3jpoQUtC/qfBRLl0LuBkT
	ZPwKz8koyvb9L9Q0mAYvkjit3p4ZHgjKA3vOIgIOXq9I/gZzBBPW0lIToTTvTZD7RymTjqJ7afH
	iURxHN2wWhgiRl0rXo4IfOGSlpYnSe2j0iH2ZMl8V8vgQOzBNlChsKC7C3GH8PLQTSYmFkYkFgv
	gJgWf88SMpYtmEt6AOPvD62mnmw9PQFNUcJ3UCjtpt7jtLe3cTGbvH82kshYsmqg4KWwsPGGMis
	xKxav/XWPKgi7kdpvUHyX1EOaRB1QD0GEhK+DFmA==
X-Received: by 2002:a05:6102:5ccb:b0:7cc:9a7:7b83 with SMTP id ada2fe7eead31-7d6ba42f2f5mr2518403137.15.1795072753565;
        Wed, 18 Nov 2026 23:19:13 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-99e49c3a65dsm483207241.0.2026.11.18.23.19.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:13 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b3ad195a96so2030499a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072752; x=1795677552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdGhU9FDUYsLV9maIUKqrOWVjk5AhyXfc3nqsWQxQhk=;
        b=DbtRZ8kjtdX4DLN8Jt8nvnxcNuWh/fXoZgmmpyr0m8/2QXasC+5ZSv4ZPEBHAyMw+r
         wlZwA/1XiMVopgFL1em2IvTvuKVy4k+6hP3vSSbdJPQ/ShtVMLwdc1j1E8s9fDRXug1F
         I+G8rGrtOMEw/u/M7lf3MV80BN0BD0T60UqNk=
X-Received: by 2002:a17:90b:39cc:b0:3b0:dbc5:c56b with SMTP id 98e67ed59e1d1-3b3d0687a87mr4886139a91.6.1795072752091;
        Wed, 18 Nov 2026 23:19:12 -0800 (PST)
X-Received: by 2002:a17:90b:39cc:b0:3b0:dbc5:c56b with SMTP id 98e67ed59e1d1-3b3d0687a87mr4886109a91.6.1795072751361;
        Wed, 18 Nov 2026 23:19:11 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:10 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 02/20] scsi: mpi3mr: Fix integer wrap in BSG buffer entry lengths
Date: Thu, 19 Nov 2026 12:41:14 +0530
Message-ID: <20261119071133.127282-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The length of each BSG buffer entry is added to a pointer and the result is
compared with the end of the payload. On a 32 bit system a large length
makes the sum wrap around and pass the check, so the driver goes on to use
a buffer much larger than the payload.

Compare each entry length with the number of bytes left in the payload
before the pointer is moved.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=2
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=1
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 35 +++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index ba70226f9cee..6bdd43b05e20 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2379,6 +2379,26 @@ static int mpi3mr_map_data_buffer_dma(struct mpi3mr_ioc *mrioc,
 	drv_buf->num_dma_desc = needed_desc;
 	return 0;
 }
+
+/**
+ * mpi3mr_bsg_is_dout_be - Check if a buffer entry uses the data out buffer
+ * @buf_type: Buffer entry type
+ *
+ * Return: true if the entry is taken from the data out buffer and
+ * false if it is taken from the data in buffer.
+ */
+static bool mpi3mr_bsg_is_dout_be(u8 buf_type)
+{
+	switch (buf_type) {
+	case MPI3MR_BSG_BUFTYPE_RAIDMGMT_CMD:
+	case MPI3MR_BSG_BUFTYPE_DATA_OUT:
+	case MPI3MR_BSG_BUFTYPE_MPI_REQUEST:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * mpi3mr_bsg_process_mpt_cmds - MPI Pass through BSG handler
  * @job: BSG job reference
@@ -2423,7 +2443,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	u8 *din_buf = NULL, *dout_buf = NULL;
 	u8 *sgl_iter = NULL, *sgl_din_iter = NULL, *sgl_dout_iter = NULL;
 	u16 rmc_size  = 0, desc_count = 0;
-	size_t req_min;
+	size_t req_min, buf_left;
 
 	bsg_req = job->request;
 	karg = (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
@@ -2503,6 +2523,19 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	drv_buf_iter = drv_bufs;
 
 	for (count = 0; count < bufcnt; count++, buf_entries++, drv_buf_iter++) {
+		if (mpi3mr_bsg_is_dout_be(buf_entries->buf_type))
+			buf_left = job->request_payload.payload_len -
+			    (sgl_dout_iter - dout_buf);
+		else
+			buf_left = job->reply_payload.payload_len -
+			    (sgl_din_iter - din_buf);
+		if (buf_entries->buf_len > buf_left) {
+			dprint_bsg_err(mrioc, "%s: buffer entry %u exceeds the payload\n",
+			    __func__, count);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
+			rval = -EINVAL;
+			goto out;
+		}
 
 		switch (buf_entries->buf_type) {
 		case MPI3MR_BSG_BUFTYPE_RAIDMGMT_CMD:
-- 
2.47.3

