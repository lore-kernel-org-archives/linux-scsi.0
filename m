Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938164;
	b=HhW46ADR4cwOVPNFdWMZ9fECYvv180byPnau1wtGBM1MOa5I20WUNmLIYmd+g46A7M31
	 RQaKPzC5DH6YVA5RlsMhg0J54FJ3/bymgT7LwXkZ/ANYg+YTFYFFdCyW7dWCWTSFetvmY
	 fCVuqFDVAPwVf1hXwUAJDJiXW3pK1sABdnr2IJJUG57dwDGKpEUkGrew7BZfeaTWHL3ya
	 vVoT0qapCKm2hW5/vGAY9IBNfO9onX4LLaMq3kbAq/vEJhXu0GpPvCmbgk4cwbLh8TxkI
	 oDGJKx1JrK/uSdJstuwVu3h8oFsbBLsxz8iqMFw5ZoClLQmRhPm2OJx4IwDITKt4c7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938164;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=T8O9pwUGQ2brZ8j9a0QlxNmuyzXqnR/QIbOa8Ct2Gyg=;
	b=I0Ugn+nzJAqEeIyzMmive//kvrbY5CGlF2/hGvkAO+/68kB8cdcE0vEEuo2FO5SNEGO2
	 WRd4b2DmL7lLsznvARB9VZBssYfa9P5cBHXUwKlm7VhLAcjD3BeHxS0Ch8nixzs+Er1qm
	 jZ45RMB4JbhAGtR9XI9ZuERS4eluGJevO7IJrbs+FB2dJJf7GcX0Fe/Q0yjd/GapUd3Lv
	 dQWIrGXPO1nv+H+BS7h0Lbyi9qliO35tMJjF/rhueqlC7Ew/plpLIK54vTfYJHtNSWmJS
	 lJCVYcLGsCHdAqfNFa45XCKW0ptD/c/joVP0CIaVJ4V0pKCwcpJTaL25iQzCHtw5Vbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=a9jSBfIT;
	arc=none smtp.remote-ip=209.85.160.69
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A99606A32F
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 17:56:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0A99606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=a9jSBfIT
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-451d80641efso116292fac.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 09:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794938162; x=1795542962; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T8O9pwUGQ2brZ8j9a0QlxNmuyzXqnR/QIbOa8Ct2Gyg=;
        b=a9jSBfITwQrefrS6i2LBTXcmgaEFNI6udlXDHZq820TD6v0mghurhUXWf0A2bgN8he
         bn4bFLE2/i2ZbJEZxiOcj8Fjwr/H6dnV6yVkpCFjujPR9CHdOxS4UoLQr0eCPvt5sfma
         H3LX2OtAjf3gyW7OD986HdAXNDEM2KIykD0sk/Idtbqn8yOVDM6AO4rT7hTp4Q5NhNzr
         k9Mv3186fNPb1Ij3FV4NdLYVvYpnHlfgavpAkLX2vRRrmeUv99oSa9ogHQmHI33AkqbZ
         FPbHIIDgtWdwBVj+QGfzg7nJ8bdLl5bEG9TcyWkfQgD9ZpVYA2tqPH+VO0DOdITHIpGo
         z6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794938162; x=1795542962;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T8O9pwUGQ2brZ8j9a0QlxNmuyzXqnR/QIbOa8Ct2Gyg=;
        b=EV0OH323/3trgmfAN/rD98lLxpMp1lrX+IdGx04ex7bHkS4o46qj1cLMQfi9ipbBUj
         zwJ4xWY2kL64KFGt1FNi1sHdY9ToFDTXIbw1D7Ohfm5XCiFYMGqLUN3URUvpJq4SZU0a
         cUOwzh4FaYJu2fgUvc0CkPZx19WCbFMMCYnEQOgcxMGlQI7jwRurOAwDh5jNdDjJ1Aur
         7WHe2zSlTgxTnZKc3JdGwKm6Ugt0uenab70vosobgXyzpPxV4NcKi66PWn7lk4iPXNXW
         xPTmhXZnVw3GngAgzEtare6M/TgYv3a2+7SFSZ17Tdd4+eTvK/+kNxS7+jqnJEX2guRL
         oAWw==
X-Forwarded-Encrypted: i=1; AL+hErEh6q8fsX7dBeMQ3asG6mP6maRF7R9T9M7jP1NqPCTasdaJBPjAjgGyRM1lLMc+WthJgiIH8lnnPuJX@vger.kernel.org
X-Gm-Message-State: APuU4Z/qYuVNhBPRVJPpSZyTmFYH91936PPIA8w27BF9Q97k7f+nLRhJ
	MpaHfUG+qxNvvCLTBJlA+coaD/L9Op+qi3EAxDYubZgZ7pIFd3nlj1ShIaExkHe72PY1cJghHuN
	e2EVr0ZxjrQvGIw==
X-Received: from ilbdv26-n1.prod.google.com ([2002:a05:6e02:401a:10b0:544:45eb:2ab])
 (user=tadamsjr job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1784:b0:4dd:18c7:5448 with SMTP id 5614622812f47-5773db2cd83mr507794b6e.56.1794938162043;
 Tue, 17 Nov 2026 09:56:02 -0800 (PST)
Date: Tue, 17 Nov 2026 09:55:58 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
Message-ID: <20261117175558.4146151-1-tadamsjr@google.com>
Subject: [PATCH v2] scsi: pm8001: Offset hardware queue index for MSI-X pre-vector
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, John Garry <john.garry@linux.dev>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Terrence Adams <tadamsjr@google.com>

When MSI-X interrupt vectors are configured in pm8001_setup_msix(), the
driver requests vector affinity with .pre_vectors = 1 to reserve Vector
0 for non-affinitized housekeeping interrupts.

blk_mq_map_hw_queues() maps hardware queues (hwq 0 to nr_hw_queues - 1)
with an offset of 1, mapping hwq 0 to Vector 1, hwq 1 to Vector 2, etc.

However, pm80xx_chip_get_q_index() retrieves the queue index directly
from blk_mq_unique_tag_to_hwq(tag) without adding 1 for the pre-vector
offset. Consequently, commands on hwq 0 are issued with responseQueue 0
(firing unmanaged Vector 0 on CPU 0), while hwq k fires Vector k (the
CPU affinitized to hwq k-1).

This results in 100% of I/O completion interrupts being delivered to the
wrong CPU core, causing heavy cross-CPU IPIs, cache line bouncing, and
increased kernel and IRQ CPU processing overhead.

Define PM8001_PRE_VECTORS for the reserved housekeeping vector and use
it consistently across MSI-X vector allocation, hardware queue setup and
mapping, and queue index lookup. Update pm80xx_chip_get_q_index() to
accept pm8001_ha and add PM8001_PRE_VECTORS to
blk_mq_unique_tag_to_hwq() whenever multi-queue is enabled
(number_of_intr > PM8001_PRE_VECTORS), routing completion interrupts to
their affinitized CPU cores.

Fixes: 42f22fe36d51 ("scsi: pm8001: Expose hardware queues for pm80xx")
Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
Changes in v2:
- Define PM8001_PRE_VECTORS in pm8001_defs.h instead of hardcoding 1 and
  use it consistently across pm8001_setup_msix(), pm8001_pci_probe(),
  pm8001_map_queues(), and pm80xx_chip_get_q_index() (Bart Van Assche).

v1: https://lore.kernel.org/all/20261116224811.3362188-1-tadamsjr@google.com/

LLM assisted with drafting the fix, v2 refactor, and commit message.

 drivers/scsi/pm8001/pm8001_defs.h |  1 +
 drivers/scsi/pm8001/pm8001_init.c | 15 +++++++++------
 drivers/scsi/pm8001/pm80xx_hwi.c  | 13 +++++++++----
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index a9605ca317f3..ef7b6257cc8b 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -178,6 +178,7 @@ enum port_type {
 #define	PM8001_MAX_INB_NUM	 64
 #define	PM8001_MAX_OUTB_NUM	 64
 #define	PM8001_CAN_QUEUE	 508	/* SCSI Queue depth */
+#define PM8001_PRE_VECTORS	 1	/* non-affinitized housekeeping vector */
 
 /* Inbound/Outbound queue size */
 #define IOMB_SIZE_SPC		64
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 5af81c73a8f8..b1788788b7ed 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -104,8 +104,9 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
-	if (pm8001_ha->number_of_intr > 1) {
-		blk_mq_map_hw_queues(qmap, &pm8001_ha->pdev->dev, 1);
+	if (pm8001_ha->number_of_intr > PM8001_PRE_VECTORS) {
+		blk_mq_map_hw_queues(qmap, &pm8001_ha->pdev->dev,
+				     PM8001_PRE_VECTORS);
 		return;
 	}
 
@@ -977,10 +978,11 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		 * include in the affinity spreading.
 		 */
 		struct irq_affinity desc = {
-			.pre_vectors = 1,
+			.pre_vectors = PM8001_PRE_VECTORS,
 		};
 		rc = pci_alloc_irq_vectors_affinity(
-				pm8001_ha->pdev, 2, PM8001_MAX_MSIX_VEC,
+				pm8001_ha->pdev, PM8001_PRE_VECTORS + 1,
+				PM8001_MAX_MSIX_VEC,
 				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc);
 	}
 
@@ -1183,8 +1185,9 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	PM8001_CHIP_DISP->chip_post_init(pm8001_ha);
 
-	if (pm8001_ha->number_of_intr > 1) {
-		shost->nr_hw_queues = pm8001_ha->number_of_intr - 1;
+	if (pm8001_ha->number_of_intr > PM8001_PRE_VECTORS) {
+		shost->nr_hw_queues = pm8001_ha->number_of_intr -
+				      PM8001_PRE_VECTORS;
 		/*
 		 * For now, ensure we're not sent too many commands by setting
 		 * host_tagset. This is also required if we start using request
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d2572dd66071..1d4f5ee861c1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4328,14 +4328,19 @@ static int check_enc_sat_cmd(struct sas_task *task)
 	return ret;
 }
 
-static u32 pm80xx_chip_get_q_index(struct sas_task *task)
+static u32 pm80xx_chip_get_q_index(struct pm8001_hba_info *pm8001_ha,
+				   struct sas_task *task)
 {
 	struct request *rq = sas_task_find_rq(task);
 
 	if (!rq)
 		return 0;
 
-	return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq));
+	if (pm8001_ha->number_of_intr > PM8001_PRE_VECTORS)
+		return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq)) +
+		       PM8001_PRE_VECTORS;
+
+	return 0;
 }
 
 /**
@@ -4371,7 +4376,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
 		       task->ssp_task.cmd->cmd_len);
-	q_index = pm80xx_chip_get_q_index(task);
+	q_index = pm80xx_chip_get_q_index(pm8001_ha, task);
 
 	/* Check if encryption is set */
 	if (pm8001_ha->chip->encrypt &&
@@ -4510,7 +4515,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 
-	q_index = pm80xx_chip_get_q_index(task);
+	q_index = pm80xx_chip_get_q_index(pm8001_ha, task);
 
 	if (task->data_dir == DMA_NONE && !task->ata_task.use_ncq) {
 		ATAP = 0x04; /* no data*/

base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
2.56.1.703.gf848ed807c-goog

