Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794627519;
	b=VZe30yVc55srHlVG4QIGMrXt1Ug2l1ZNUPJ+N5Wzjdg5iJAsr+KEkfJ8qUWXbAZgFa8u
	 ghWTZJxX5sjWZWJxmtGd7bhceaZ3R6PpsX7Dahh/I2YZIoldNJ1ET68ipqK5HHaU1biJ6
	 LmVT2pXEdiMTFUPQDUnTfDcJvJsCv4n/jviRsJpneHey7OyuzmO+G9G8umIs54YXhJ2e5
	 0UDxPrgjnbEsr6lcARYU8f319aB8+0uzpGUfAHjr0ff7O8Ec06IgJziJ1Bwkbd502biA+
	 cBlbll3xPSMbCJwEL13n2Q4CJ+IMKdR9zz9/wM+HLuHDEbMDhIDwSXisVIpTdB+93Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794627519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8ZrBMx2p46ztA81BaQoTlOSOcAkVM5aJlSZl64zAlIw=;
	b=cacOEWz8cpQooC9j6CticQksAixjdpT9t8dt+Y7AYSIS6UGe0cWeH9LZHPvMbLgrJ8hv
	 lInPeDRujCQqKLDY+Uo2l0bQKDWoUBaCVxJgN0MXwY9NXyNpPnaktvVIaM5C2QqBISu0+
	 u7gw3o05DVHdhtuERMnzfrDbeiyZNHVJNrpSrwxS+fjW6ygtHocanMB/zXC7uK2hBBBJ3
	 8rSyjuMnBpURD1yi0rYgpXVE5BwZVV+YIFKQPgzVQ5XB78i7C4KGYP1V9dL0rXVnWNODS
	 CgtmL2JUiabivZlfQzGWiWyP5P5HXvMUoLXUGsAoPWjm819hUksovf5YcPAxfg18UxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mnWSqeFz;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CA5606A33E
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 03:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28CA5606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mnWSqeFz
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb2893531bso1542946a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 19:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794627518; x=1795232318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ZrBMx2p46ztA81BaQoTlOSOcAkVM5aJlSZl64zAlIw=;
        b=mnWSqeFztL32vQilgOCnYjSde+DRUCNeW3taaZdjkJ9qYDI8azdkYW3bi2vzXFD5n5
         pA4vS+b7OAYfko9pHPIh8+JWSL4azZ5a3IkLvJvm0PRYMDSG70NJ90ML3xBQxDpBnwPT
         w5tD8I48+/kKU26RUx68dEnxAb86qp16wuF/nPaCgwE3OorylUtpEZ/QzDJCUY/Jlbu/
         0KAf9IqestjRGcjr2ttY8AHejFeGLC9UiRURGbNegn4/VHMGs1tc6aeVl8zvcKWf7FVc
         /1E5PclUS07MDltdrbQ9/Zqx8uc7VkBeFgbRqGAVcYQeFk+8IKbh4zvj3jIXru6b+eGS
         6BHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794627518; x=1795232318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8ZrBMx2p46ztA81BaQoTlOSOcAkVM5aJlSZl64zAlIw=;
        b=1apwEtK4Jclrix/NHggfvhAPWBLEt3aHMTWPtDB9KkVzjHxl6TMdM9jzzZpEjg0f07
         +dW0tJmxCMJPmdBQAo6k2C2BnP+389/+qS4C2Af+B021DnkhrfM4IqnkjjClt6+YdLHn
         kTmVUbsjO0/YaPSOAi7DFvXyoEALKLZbTE2pNODVtc007rVibC5PQtTb6r0THvGWSGCR
         BxZlsWfA2V55mF5+uBf2JF9A7jXZERYupm5JUq2/QfUTIACC8W/JTPjy5Cpvxg+tMNXz
         1zrIE7MQYNbKwoevYJj7WwLgXKj0Ycuegx0bLZ3/QGCCtDGJzygb/q4u9OM/+HGpVVeJ
         PtQg==
X-Gm-Message-State: APuU4Z/GNN8qjNR2uFWsyZhbia77OmyQ/mj2gySUzeXSR0PAhd5GHnvX
	SgKddUWCNPpahzKHGoLKXofdMRWq038xnYD0DOYy0xBwXCfPs2I6njOB5Funp7DtTbQ=
X-Gm-Gg: AYBFou1HE7DoRhtgpJwHMG3ZXfVrHEmctPMSRloVu1JnH2JjEUhjks6b0MCGIx9w0+Q
	sRrimWdrK2YVoj4numa/ItpePtt0Ng4kPn0ZJWbc+ZL3LMh7jYaH23syukZqacfjhxBIyMNaRub
	JozN6uYG+1gvuHsYt8IZ4SYtx/4T/9EfHfe0KYQAtWsmcBBBs1upPy0Sqs7usJgAhvUhBHMv9WJ
	Gz1l9APXmPO6mwJiqCGFzkozauBNiKccnQJ7BHiF1f9hOzKdj+EDLIE2wavZzL5LU2hwC6ZIprB
	jT0uToLjw/luKeFMkfrZG9mYWxRONgKsfxeReBwEqZhbfMgMi0+Q4PCdccsZQSN8XbpUrAOllUr
	eBQyZLkEnFcMAIjhVUScUEP1zN/9qZ/BYkmwhMis8lmkUrYQkWoMQdGvs8FLz9mtPhp3IGdOE4g
	0FnB6m74PiFYngz1W6rC5U/X2JDOhHjpc2GwRf5fq5t7aqs0cIUp1R9U9mmOhopWRORYgi8vbsY
	6AxyqEHjbV8XKqq3T/3qdCHvqOD1BLy2qlhGii4ufibYwifHpIHRaM8aCjMugDX9CTkXiXUf+yd
	NkvK/H9EapqoR4TEhBIFJaAJO3+Crp4GaIjON95JjQosCOMkHn3BJiPEuQNdyy8QGla3xzD1sY8
	qzaKzjtHna9Tqd8wO3m1sZVA6bo8oPfGzplWFVg==
X-Received: by 2002:a17:90b:4e8c:b0:3ac:9d14:fe9f with SMTP id 98e67ed59e1d1-3b1b0ba3320mr4120173a91.31.1794627518086;
        Fri, 13 Nov 2026 19:38:38 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3a21769sm3412380a91.4.2026.11.13.19.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 19:38:37 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	erich@areca.com.tw,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 4/4] scsi: arcmsr: serialise the type B completion ring
Date: Sat, 14 Nov 2026 12:38:10 +0900
Message-ID: <20261114033810.549787-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114033810.549787-1-yhlee@isslab.korea.ac.kr>
References: <20261114033810.549787-1-yhlee@isslab.korea.ac.kr>
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

Type B keeps its completion ring in shared memory and consumes it from
arcmsr_hbaB_postqueue_isr(), from arcmsr_hbaB_polling_ccbdone() by way of
arcmsr_abort(), and from arcmsr_done4abort_postqueue().  None takes
acb->doneq_lock, and all three read reg->doneq_index and
reg->done_qbuffer[] with no other synchronisation, so two can fetch the
same entry.  arcmsr_abort() masks the outbound interrupts first, but that
only stops the next one; a handler already running on another CPU keeps
going and nothing waits for it.  The interrupt side clears the slot and
advances the index only after arcmsr_drain_donequeue() has run, so a
polling loop inside that window reads the same index and the same entry,
and the startdone test both consult is a plain read: both can reach
arcmsr_ccb_complete(), which means two scsi_dma_unmap() calls, two
scsi_done() calls and the command on ccb_free_list twice.  It needs no
misbehaving adapter, only a command timing out as it is completed.

A harness that plants one entry and runs the two consumers over it, on a
KASAN and lockdep kernel, has both take it in 5 of 5 runs and none in 5
runs with this patch.  I have no arcmsr hardware.

Take acb->doneq_lock in all three, as types D, E and F already do:
across the drain in the interrupt handler and in the reset sweep, and
across the index-and-entry step only in the polling loop, which must not
hold it while it completes a command.  Types A and C read completions
from a hardware queue port where each read pops a different entry, so
they are left alone.

Fixes: 1a4f550a09f8 ("[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other fixes")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
This touches the two lines patch 3 touches.

 drivers/scsi/arcmsr/arcmsr_hba.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d13bd0febb81ac..9b2a7053f1823f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1552,8 +1552,11 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
+		unsigned long flags;
+
 		/*clear all outbound posted Q*/
 		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* clear doorbell interrupt */
+		spin_lock_irqsave(&acb->doneq_lock, flags);
 		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
 			flag_ccb = reg->done_qbuffer[i];
 			if (flag_ccb != 0) {
@@ -1570,6 +1573,7 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 		}
 		reg->doneq_index = 0;
 		reg->postq_index = 0;
+		spin_unlock_irqrestore(&acb->doneq_lock, flags);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
@@ -2566,8 +2570,9 @@ static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 	struct ARCMSR_CDB *pARCMSR_CDB;
 	struct CommandControlBlock *pCCB;
 	bool error;
-	unsigned long cdb_phy_addr;
+	unsigned long cdb_phy_addr, flags;
 
+	spin_lock_irqsave(&acb->doneq_lock, flags);
 	index = reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
 	while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
 		cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
@@ -2582,6 +2587,7 @@ static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;
 		reg->doneq_index = index;
 	}
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);
 }
 
 static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
@@ -3664,16 +3670,18 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 	uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
 	int index, rtn;
 	bool error;
-	unsigned long ccb_cdb_phy;
+	unsigned long ccb_cdb_phy, flags;
 
 polling_hbb_ccb_retry:
 	poll_count++;
 	/* clear doorbell interrupt */
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	while(1){
+		spin_lock_irqsave(&acb->doneq_lock, flags);
 		index = reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
 		flag_ccb = reg->done_qbuffer[index];
 		if (flag_ccb == 0) {
+			spin_unlock_irqrestore(&acb->doneq_lock, flags);
 			if (poll_ccb_done){
 				rtn = SUCCESS;
 				break;
@@ -3691,6 +3699,7 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 		/*if last index number set it to 0 */
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;
 		reg->doneq_index = index;
+		spin_unlock_irqrestore(&acb->doneq_lock, flags);
 		/* check if command done with no error*/
 		ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
 		if (acb->cdb_phyadd_hipart)
-- 
2.43.0

