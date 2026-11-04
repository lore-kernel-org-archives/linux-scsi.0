Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794190;
	b=tXn939W+E3KEwKfDPOSh/QLutWsgj0fcooYuA7lQmg7bnhl+0Uprk5QaABz9veddR/Mt
	 JaaxjKEP8JV0+Oj3ra64EEwxj3mLBcJnhBD5I66XTNqOF52hHSlv3riN3o961sUsIReVe
	 0dYpfdhjbOmbhxUjeKBN1qZrUsGMpLaH0xCo2CilNUZgyedXqKeIuPQ5COONqnnBoacqi
	 fAcS9Xo7EZ2re42yFoT+8ifMVZiev+ekkxYOj1MjCskGCn6cfC5oxScg0opVLDBtHe2WM
	 j3IIkuQL2WfleUEuelquWVaGbcAC978XYtsKMDATwyMjwHUGudFr+v6mx1x1ff44I4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794190;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=WdGhU9FDUYsLV9maIUKqrOWVjk5AhyXfc3nqsWQxQhk=;
	b=fPfrPEBq+7qhhDqv8/LE9jqjhV51nh9s8R7/qwi19QJZxoD7UX+96KNYJ4klKFYEBwbz
	 ClHlfX9Mfq3SLqJsCexyR0SUEuQFOQ32/54uWjZChyhmTXKGnKimPiEWq3lB+Lk77OMVD
	 ZvmT7yfTmxS8IFdZ+4+mzt87nw+bj6FmzytqQUb7aQMGbtcsAqgpoevHhyTvjlefHewQn
	 ZGJ6QY4itBA2nvz5xKJ4onk4BQG4zzfVjjzmh14q/y76MCbtxvK+VI5+7LEFOw43Bdl9T
	 I1Lz04mc6HYrimO279HqY0CJjv8imhVd1HcjrYZn43kPUwWGZ4lqqNlLG/iBSZtJJRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=L5YrCKbS;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F613606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F613606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=L5YrCKbS
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso354356a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794190; x=1794398990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WdGhU9FDUYsLV9maIUKqrOWVjk5AhyXfc3nqsWQxQhk=;
        b=jY5jPZcHhYJKF0WE8nMuckTSu+lTQqEG2+P1PokR2XHrWl+kqqMQ1fXBuNb4eRh82C
         72POizh2Ru5oXwLRt+TRN4ca83FI02A6v9SIEZyA/TH4jHJ9fVMBBPf7zEGXLy0VAVW+
         1G2U6/00Pdpic8oYOZ5aYzl6WCqCHmYd/+Ufgo4OKktHaUbtNoMZszh7hp4wNvqg6AyZ
         yWgHXrz4eHdc/tLK1S9rYqcbiFXjBzJh2Y8a7hAh9IYDI8i4MM/wVrBP/GAUIxaCn+GQ
         4598c6JnIndGJmIISUA46HvGBOpkaA6ux3Dq14+fRHYDx5E9LwIxZFOd1W1PvH/iUSl9
         +Ujg==
X-Gm-Message-State: APuU4Z8rwxTuTG4hjDm7guJUvLJVzG12wlOvg5RVsmk6g3HlDoIlxpiM
	zNC8nyyyTgm1ztVfAMauez14u7fAUNwuUpULFNMcHhipwcZhacMZAKNnA3oSzKuvXizdmlYZp+r
	tL2vjYi/WoRUVFzIv8pvErq/JJJ229/CzTkLuMqxK2LMnNy72QH18PscXPHQTNcPpcQQ5Jp+EOn
	1nI7ac2PZlbHQ/ujguTkrSOvMipGE5v8P2tkmcwks0b+G9K6lMJF6syI/JWC7Y3IHEf1md9ENhu
	G/o3aG58USO9dmO
X-Gm-Gg: AYBFou082GEkq2/Tm7gP0vsAWps7D9/boS7GEHyJYPcYtQFTXwQh83bIV1NtDbmuVPh
	+2yl11LDB2jPCE4YRG3cbDzzhhhqd/2kv6zTc+iQDMGGXAgl5Ymq+gqb/iE9hr7ENZdICEBcYjg
	BQwTG3uYUg9HkGO0ibn5p+2i3dhgXm5+BaV4XALyXQwkU4MpqIOjdikXhk9/KGwV2DXcRlFzec0
	qhHBYMVwCyYPTyW1zm8NSKLx140W3+KPKGpG6X7duA12+NwjM/3CFqBlT3+biFs8tEDuEbBTJYo
	vco0IzG1yWWwL6k5uWIOrmS5GW4KQEgpIVG+FvblclTeG+w8TAJGPDIrDgv4lOyt7iYvSesCgEd
	mo+7spfqPLgP/obeW8Hk5gj6FZivYbvaeSLg/Yc5JbZd25AqbaGIBqMd+QjKSPSxXqUuMwPYfOB
	0jrHF+2bfFZmQhKCztCVWTrqr0VSazdDBdjpg=
X-Received: by 2002:a17:90b:3b51:b0:3ac:d19e:85f1 with SMTP id 98e67ed59e1d1-3ae897dc967mr13084710a91.53.1793794189734;
        Wed, 04 Nov 2026 04:09:49 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09466932dsm1664811a91.6.2026.11.04.04.09.49
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:09:49 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-351788121cfso2829559eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794188; x=1794398988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdGhU9FDUYsLV9maIUKqrOWVjk5AhyXfc3nqsWQxQhk=;
        b=L5YrCKbSmmWu4EHVOIGQfCxbUMNog6OcC234/afVJ+uFZe8Q+qES0nbD3ySax80/Lz
         nfUw78xkkekkiz6WRCZQoeOS7/IdcmSUx/s85yRmXo9Wokq+pfkhW6bHSpCKeHdX4qUw
         t1c1wQv5F/UJGJheAV5RtPUncCvrut5ZCKrFA=
X-Received: by 2002:a05:7022:3717:b0:166:af48:a2ba with SMTP id a92af1059eb24-1ac4fd0136dmr23075385c88.0.1793794187769;
        Wed, 04 Nov 2026 04:09:47 -0800 (PST)
X-Received: by 2002:a05:7022:3717:b0:166:af48:a2ba with SMTP id a92af1059eb24-1ac4fd0136dmr23075317c88.0.1793794186759;
        Wed, 04 Nov 2026 04:09:46 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:09:46 -0800 (PST)
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
Subject: [PATCH 02/21] scsi: mpi3mr: Fix integer wrap in BSG buffer entry lengths
Date: Wed,  4 Nov 2026 17:30:43 +0530
Message-ID: <20261104120103.503871-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
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

