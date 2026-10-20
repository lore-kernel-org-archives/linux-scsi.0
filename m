Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792534555;
	b=KpavHnHJHArJ1oDkt2XWIlu1W2MsyA+3Av/Ujt8xf4eH4ed0S6d7EGkQZR16YWdOgtLJ
	 u4pn6hX1YxJvGR8bDZ0e6VkH1MciPtaXMDVdOE5KWhe640aacl+HgmU95wKFsXEU58t8P
	 15j+Y0hG1CcHgWevrqvpKV8JCBAmRlbB96qNVNqe+twZBaAt48HXIF8c+5QwAlZ6l/uNw
	 cAEJUg3nWo0yNHqb/MiJKq+1aZ77U/eJlLwnY5knlMMYPhDtxTMQ2BtAK3FGkaDeOkYaN
	 Ozy+mnjMAxyQOciHJsexzwV/UqD6PuC3hkRDsA+X2xLjK6Dg9XS4K968lnnbKgqTKEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534555;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BOERBX4irxAK4WKXyDkoVTPC39eehwLpXtOXPRCNgv0=;
	b=u4MsIwyyLPH+47wg2QOKqCsnq3WQZwYip13z+Xrf8ESJOvSpiGbmJJwKf8kz3L8SzuDy
	 /SFgSHUGCagy4lV/DMUZAQ7VreRYQpu2mY23jsiAyPoE7vtqWpTsJq2luA8mcTDwQyhXC
	 Y04eqC9sREl48vO9ApGwS/EN5XKeJUqwXJRt+GSWC17S4asw5B3zRe8MJ6reIxby96Xo4
	 JxgQNUzsDI81xCH6EI58WQlcvCASlpg44jCfqKvGPpjyMYhGjBPjCMe0hUpjWYA0vJYZQ
	 /kAa8K4ePZNX/Y7qSywgYb9m/WnWQQknzqMxXw2W7PwbcqMqs3jzYmfqTZ0xFDJ116Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gDUQ49gJ;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02D3606A31A
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 22:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B02D3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gDUQ49gJ
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e977109392so678095ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 15:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792534554; x=1793139354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BOERBX4irxAK4WKXyDkoVTPC39eehwLpXtOXPRCNgv0=;
        b=gDUQ49gJcOcdn2BoDnxJv0Q4HiSZ2FG9wxgwoSwpwTJyFyZReMKPLgR1gluh+O3L8u
         QuUXz1qTP+x3HK698yGzw2MnRFFhXYkGunXa8ZBKUpPLnmtIkZYieQVxihtjgt+GaGX9
         Us/i/hXHRWJswCsG+zQe9V1HfHNTERNP2yQ8QvucIijkZZZr2ojmKmj7FaCqJESqzgCO
         ZtFkVB8efmLIVoJ1CInYDbf5nNctGcmHGI3C+vlb4kp1pa+6ujzOld4VEsebhI8mcR+P
         t7prJnVpHX2wwFxyy5pQyvF50zVV9b/s5MiV/rCca5MwcpDmzvjvxAAEXOhlSkZq6mCC
         7QqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792534554; x=1793139354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BOERBX4irxAK4WKXyDkoVTPC39eehwLpXtOXPRCNgv0=;
        b=Bu8efyEcMb3Emb6+do8n+xDyYsUEO1vfqrBSim1rcTJfcgAMMRKMfinG8QSkmyWcGb
         wuLD873Wscl+MZAIV0eKiQx+qpCsTchnLR9BEr3HsrrTfkEl7PJliJaQd0w7NWPFk+Y3
         d9gejOUA7lPNCfKTbBXKsAsMV5KtBWVS36sjgQmXfHeRGDze9UrgXMSNPJQ4STcufBQE
         c8GYIcmIzkMEOU1q/s9jvGrC9GI+btt2blFwgJnCYWlBlpdZlX1wkraoR/1zKEEy4qMO
         WVFhN21Oem/Oe0Hp72LGcUTbtUKRJWS6qkBUOdPSu38rUBnAyJXrQ2cepaa+HBTkdu7X
         Q6OQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXfQVKfz/sHrH1AUbJfexjXd61XLUb25mWjwO2hGpk2YWl5A7i0PH7hH0yxpS+BmSCrjpCZ+gmUH7z@vger.kernel.org
X-Gm-Message-State: AFq9FYInokSa3nQqEEXPXM+lF1AHQ2P7kdXdeuYyPUqfuvVTn+Yh7X5t
	qAvejAXwcVDQKfuYF2V9JePcnV97eUKEVL/OSPkokoKPN+O64Z4QGyhA
X-Gm-Gg: AYBFou2pHwhrivrYKObsw1FX8d6LABH8PPQtbkq9H6XP3RzAQElWps2I/PbSEyRPWKG
	yeDtIAt0FFbLQ8SQxm0ZtrcsUPpyqDn94B41OfJUa3l11M2bUZwBVYdnnoIJcuQx5Po6fXvNIcE
	vdTkJvFwmx7fDW8Z9QLfhlgkbmTZwABgiMYyWrVmjvkwrGtSPT/EnAP5NE6r3/6tz529fCfo1yr
	U7j4y6JIW7LWF0ellzfTvJpBIFrtnj/x4gHlP0NjV6eusQc8C194AKCU/IaxXcGAK6zP6um1e9E
	4/U0o0aVsh3mhKCT31tV8jQDKZZs4OBYSlb3m/cr4LqJ88oADjQkzkvHvUOr5Y8h1ISpre92SSF
	1iAgg1oR0vHO8fgOdDgB6ypbeqntt5P0bJL9dO7XZzQ2VQjuxnbSKdLpRSbYU4dYSHluGV16DHG
	OIwyG9VePcfrS7zjLS2X+wPCyYUAWpjTc6KDUy9Ed1aZ/QwNXn5X8Q3nGmxRQ0QmnPofrp/JiDX
	7lZKFwqLhAJEw==
X-Received: by 2002:a17:903:2309:b0:2e6:943:39de with SMTP id d9443c01a7336-2ea43e259cemr964625ad.30.1792534553877;
        Tue, 20 Oct 2026 15:15:53 -0700 (PDT)
Received: from Alienware-m16.lan ([45.153.102.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b410659sm3556285ad.22.2026.10.20.15.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:15:52 -0700 (PDT)
From: Andrew Luebke <andrew.luebke@gmail.com>
To: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Luebke <andrew.luebke@gmail.com>
Subject: [PATCH] scsi: aic79xx: Fix NULL pointer dereference in device reset
Date: Tue, 20 Oct 2026 15:15:30 -0700
Message-ID: <20261020221530.2606178-1-andrew.luebke@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Commit c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when
resetting device") makes ahd_linux_dev_reset() build its TARGET RESET
SCB with io_ctx set to NULL, but the function still calls
ahd_set_residual(reset_scb, 0) a few lines later, which is
scsi_set_resid() on the NULL command. Every call of the device reset
handler therefore oopses and kills the SCSI error handler thread; all
further I/O on that host hangs until the machine is power cycled.

Hit on an Intel SE7501WV2S board (on-board AIC-7902, i686, v7.2.9) when
a failing Ultra320 disk made the error handler escalate to a device
reset. Both disks on that channel then stayed in D state:

  sd 1:0:0:0: [sda] tag#287 Attempting to queue a TARGET RESET message:
  BUG: kernel NULL pointer dereference, address: 0000009c
  #PF: supervisor write access in kernel mode
  EIP: ahd_linux_dev_reset.cold+0xee/0x26e
  Call Trace:
   scsi_eh_ready_devs+0x538/0x8d0
   scsi_error_handler+0x3a2/0x3b0
   kthread+0xd2/0x120
  note: scsi_eh_1[78] exited with irqs disabled

(0x9c is resid_len in struct scsi_cmnd on i386.)

Removing that call alone is not enough. When the target accepts the
reset, ahd_handle_nonpkt_busfree() (or, in packetized mode, the task
management completion) calls ahd_handle_devreset(), and its
ahd_abort_scbs() walks the target's pending SCBs - the reset SCB
included - reading and setting their transaction status and freezing
them through the wrappers in aic79xx_osm.h, which dereference io_ctx.
The same walk runs if the reset times out and the error handler
escalates to a bus reset.

Commit c7f4c5dec651 ("scsi: aic79xx: Fix up NULL command in ahd_done()")
taught ahd_done() about the NULL command, but not these wrappers.

Drop the residual write, and let every wrapper that dereferences io_ctx
accept an SCB without a command: the transaction status reads as
CAM_REQ_INPROG, the SCSI status as SAM_STAT_GOOD, the transfer
direction as DMA_NONE and the residual as 0, while setting a status or
the residual and freezing the SCB do nothing. The reset SCB then
completes through ahd_done() as that commit intended. The SCSI status,
residual and transfer direction wrappers get the same check so that no
wrapper can be handed the reset SCB and crash; the only path from the
reset SCB to them that is apparent is ahd_handle_scsi_status(), should
a packetized LUN RESET end in a status error.

Tested on the SE7501WV2S with the same change applied to v7.2.11
(i686): a device reset sent with SG_SCSI_RESET_DEVICE to a healthy
Seagate ST373453LW logs "Bus Device Reset Message Sent" and "Device
reset returning 0x2002" (SUCCESS), scsi_eh_1 survives and the disk
keeps working. That run goes through ahd_handle_devreset() and
ahd_abort_scbs(), so it exercises the transaction status and freeze
wrappers on the reset SCB. Not tested: the packetized (IU) LUN RESET
path and the bus reset escalation. The oops was not reproduced on
purpose on an unpatched kernel; the crash above came from the failing
disk.

Fixes: c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when resetting device")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrew Luebke <andrew.luebke@gmail.com>
---

Notes:
    This analysis, the patch and this changelog were prepared with an LLM coding
    assistant (Claude Opus 5.5, Anthropic) at my direction; I reviewed them and
    ran the hardware test described above. Build-tested with W=1 for x86_64 and
    i386 on mkp/scsi.git for-next (db8b4d2bf2d3): no new warnings. sparse and
    smatch were not run.

 drivers/scsi/aic7xxx/aic79xx_osm.c |  1 -
 drivers/scsi/aic7xxx/aic79xx_osm.h | 19 ++++++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index feb1707fe..4c603ad63 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -819,7 +819,6 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	reset_scb->io_ctx = NULL;
 	reset_scb->platform_data->dev = dev;
 	reset_scb->sg_count = 0;
-	ahd_set_residual(reset_scb, 0);
 	ahd_set_sense_residual(reset_scb, 0);
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index c6eb2b97e..b47aa6c98 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -508,7 +508,8 @@ void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 static inline
 void ahd_set_transaction_status(struct scb *scb, uint32_t status)
 {
-	ahd_cmd_set_transaction_status(scb->io_ctx,status);
+	if (scb->io_ctx)
+		ahd_cmd_set_transaction_status(scb->io_ctx, status);
 }
 
 static inline
@@ -521,7 +522,8 @@ void ahd_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 static inline
 void ahd_set_scsi_status(struct scb *scb, uint32_t status)
 {
-	ahd_cmd_set_scsi_status(scb->io_ctx, status);
+	if (scb->io_ctx)
+		ahd_cmd_set_scsi_status(scb->io_ctx, status);
 }
 
 static inline
@@ -533,6 +535,8 @@ uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 static inline
 uint32_t ahd_get_transaction_status(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return CAM_REQ_INPROG;
 	return (ahd_cmd_get_transaction_status(scb->io_ctx));
 }
 
@@ -545,6 +549,8 @@ uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 static inline
 uint32_t ahd_get_scsi_status(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return SAM_STAT_GOOD;
 	return (ahd_cmd_get_scsi_status(scb->io_ctx));
 }
 
@@ -566,13 +572,16 @@ u_long ahd_get_transfer_length(struct scb *scb)
 static inline
 int ahd_get_transfer_dir(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return DMA_NONE;
 	return (scb->io_ctx->sc_data_direction);
 }
 
 static inline
 void ahd_set_residual(struct scb *scb, u_long resid)
 {
-	scsi_set_resid(scb->io_ctx, resid);
+	if (scb->io_ctx)
+		scsi_set_resid(scb->io_ctx, resid);
 }
 
 static inline
@@ -584,6 +593,8 @@ void ahd_set_sense_residual(struct scb *scb, u_long resid)
 static inline
 u_long ahd_get_residual(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return 0;
 	return scsi_get_resid(scb->io_ctx);
 }
 
@@ -631,6 +642,8 @@ void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
 static inline void
 ahd_freeze_scb(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return;
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
 		scb->io_ctx->result |= CAM_DEV_QFRZN << 16;
 		scb->platform_data->dev->qfrozen++;

base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de
-- 
2.47.3
