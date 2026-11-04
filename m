Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794202;
	b=I+BFnczQQTjmHcmZ5Khs5uFD3eC3Nih+l5v9h91PzotO/pZpTWTNm3lVeyJQ2pv2uJiO
	 1QOVG4aDpAlX9oL8adX+jleQnUZBynOz1iiK3m0Qa/L6KaNSMf1sP1XYwzhmaVY3vhzcr
	 wH5epQT8FW9PiKfzESTt8h1imUAWyuypuBRIsfsmphVwdOb3MDUN3Sjxy7ErqQwlSp0Rr
	 syzpm9AEONiDp1aYIOidMHLuex1NRDiPJkW0MJKRLIiMKaVQuMwNyoYmorQh33DXBclJp
	 8MWYlwMUYn6oGK7pfCJBG+e8pODjCWlaeAuigFCbMRQPQEZf53sX3e5ZGVnr0s0qE7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794202;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=1rFGev2MK+/6P1u104TnEw4yef0uRLxw/k6IqH9SfO4=;
	b=01fKDl0mV++aUR1qVSpnicJSpGXg2DfsonqJfcYsCRvUeXAZlYlAPgiLMOgpnC/idwRA
	 eMYM0FJXR1YzbUVyxAaDZdaxd2tNOLcw2iLHhquFs62kS1brzGCzEDDe9j4Ais5oDaPKj
	 VtID/QNQvuMBqRC8CuxhbiiHogwOUuv82pagERIXTzpY/b2NQzVCgzpaTJYabV7FloDFS
	 C8HhnMgo991lrAmZXgfiG2upJjkvvSED2HlmJ0ZZYeGKUDpgrpsbDTbTd4b3nfsALYjxB
	 eW5sDf65JK5Ak0uYHSeMdbNOn+3qFrR+7m7TakyZqaAv2HUxniFjszb/V5WqbGDQyuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OPSXpE2+;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5347606A32C
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5347606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OPSXpE2+
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd3310348d2so791997a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794201; x=1794399001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1rFGev2MK+/6P1u104TnEw4yef0uRLxw/k6IqH9SfO4=;
        b=OL1P28HvZmqvB2KJZja1irvM3LcZ4jJBqiirD2ioQRI6y9IRjKFhfEzj57MgLgzHSa
         IWSzKMHtKXzzA8fa6GgbSn+p5Bny6YRidhq1aCP4gQ/qXvH50hlXWSqcadiwJk/dl/z3
         6JY+FEuZzF4kXuqQGLoW1WU8SHC4Nc5a4Us2zfmyrASTrdCeCxaN9R+MHESJHaH2SAgc
         7c5rX7YZE9rSztvqUNJq70H/TstDMeIQiHu1h1epuhXE0R5HKX3uOj+tQW5txKcGUddI
         qIbGH49jzluo6DBrcq0zB1mllmkB/kKWxw0tXdE1nTffmVQLMIFQ/SRbeDbsbFDz9GRC
         i0yA==
X-Gm-Message-State: APuU4Z+dfPXWhgHmVGfwQZFNCGOmhO++k4FvyzsHDkFESbcq7U5+c4Gf
	jPUroKToCYQA8xLZ8E6AhHKwmHMIQmfQsji7NO2hNVGibBJBPE/ll7graSZPY5kURDHuLzSlzxG
	yDz+/I9Y66l3iKDG90WkTB8U8Aksf6YrCkoxonpY5mQF1S+2qv0Lk5j4gJePDmp1K7Y6TBSZK9x
	M6Pca2/NmgnVgGQUSxgy84fY+bkXtYr93/RfmCXsttq0U/ujm+T33xpWKI4DRIsfBSVq347Ud+/
	OZqY2Z+VxGmF9hT
X-Gm-Gg: AYBFou24TjY3/efgbXJaXL+FxLMF/pxiNpqvCFcB+4sub84gINwX8aSJcZDtIG6U8TK
	tK1qWRgGGeWUjIcGVXOXCqBfAB5m4SY2dIBxd7hYZsWkx3N6/l5K50HYoOBT+RFiHFl21cGs+gK
	4EpaVjNv+8gzMViEAEBQFHSqFkreFFgcHCSmBAzkhWm1EcZ4miy/Are045PvdVtGPVEhLYOm3CJ
	ZlM2zfwBeml1Y3ehRAd5pjBdtLtVADDUplgu4QRjo+hivW5A1VHr3H9nbqX6eJcLUQ1nDDlm2Qg
	+Twrt5IU/uCuYWa7Ovuk6JkIBqdBCfWG6GC3IPOo9uykrwsBP0E3Fl6wsW2icKzKHz67BLNa0MG
	DeurBrWctZ1xZwbCrIQTFpaB0Ax8G5jsNOdgc0vEm7WbNrxwXpegKdu5ayVZOnPUTIohbPGPrit
	fvsmPx+SKjrkqjlWge/k5tyQeQecjWIAQC7d8=
X-Received: by 2002:a17:90b:5848:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3ae8974a413mr8071182a91.23.1793794201071;
        Wed, 04 Nov 2026 04:10:01 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09453d7f1sm1721965a91.4.2026.11.04.04.10.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:01 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36d2d353a5aso379954eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794199; x=1794398999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1rFGev2MK+/6P1u104TnEw4yef0uRLxw/k6IqH9SfO4=;
        b=OPSXpE2+a6zMxg9GbHFnSCQoxtP4PZ1OuCsj3ktjSYs6gBoKhq/dZ7nr58pLv9YmXm
         BM/Wpe3pDMYVP8vz9BrJ9hGLXpJXF5MqxuYIowekQi9A2YacSlMXeh6GirfFe9HsVHi7
         Etf4sgdsk7N7X9IRpKopuFezagJbXEp2nuqKs=
X-Received: by 2002:a05:701b:455a:20b0:1b2:42db:8a5d with SMTP id a92af1059eb24-1b242db8f34mr5152808c88.3.1793794199347;
        Wed, 04 Nov 2026 04:09:59 -0800 (PST)
X-Received: by 2002:a05:701b:455a:20b0:1b2:42db:8a5d with SMTP id a92af1059eb24-1b242db8f34mr5152748c88.3.1793794198553;
        Wed, 04 Nov 2026 04:09:58 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:09:57 -0800 (PST)
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
Subject: [PATCH 05/21] scsi: mpi3mr: Fix reposting of invalid reply address on the admin queue
Date: Wed,  4 Nov 2026 17:30:46 +0530
Message-ID: <20261104120103.503871-6-ranjan.kumar@broadcom.com>
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

An admin reply whose reply frame address is not one of the driver's reply
buffers is still reposted to the hardware reply free queue. Clear the
address when the lookup fails so it is not reposted, as the operational
reply queues already do.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=7
Closes: https://sashiko.dev/#/patchset/20260805110634.346670-1-ranjan.kumar@broadcom.com?part=5
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f0d3cd398dd0..eb3f41f50649 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -402,8 +402,15 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		addr_desc = (struct mpi3_address_reply_descriptor *)reply_desc;
 		*reply_dma = le64_to_cpu(addr_desc->reply_frame_address);
 		def_reply = mpi3mr_get_reply_virt_addr(mrioc, *reply_dma);
-		if (!def_reply)
+		if (!def_reply) {
+			ioc_err(mrioc, "def_reply is NULL, invalid reply_frame_address\n");
+			/*
+			 * Do not let the caller repost an address that
+			 * failed virt-addr lookup back to the hardware.
+			 */
+			*reply_dma = 0;
 			goto out;
+		}
 		host_tag = le16_to_cpu(def_reply->host_tag);
 		ioc_status = le16_to_cpu(def_reply->ioc_status);
 		if (ioc_status &
-- 
2.47.3

