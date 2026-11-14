Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794627511;
	b=WKLwtEkwZWYZJK4JQiTQTDUjvR5s9dZbHZt+T4fr86qdpxqG6x3EJtNxr5Gg1Ss+/upC
	 uwWojvyUJef/xsDfCU8Hq1yewmwznEUfdPHZjaVQfz00d6DVvmXMcEU8kEZ6dPGBSEwVX
	 zyj9UtY/5HqAjFAPiWGMBR9Nzm71GMIdXeT8XiIyuATyvJFW6D1lP0+z8pgabLV2BhXw1
	 TcWg6YS2XK3RCAYY8RIzbCURTqxnaiGA43YsQyyfODUWhOBV/ia2Ea4gTAbU/zOIAPALk
	 lYFpUXmxGpF+k50aDsOrcqD54o815rOtoh3dpwkJVgSi1hYEmbADCUdi154cNfHESIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794627511;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RMKShAqwQ8QmOnYWmrOpdePr1A2OrFNasBeIi1/KCB8=;
	b=R6LaZK0oHcCyJDufYrp28jzreaNnX1cD1HetlHa9Qjkb4wT+MCPSsZ/XTYt6rkVV8iej
	 Kl82E4hjrp4QTvgxJpiwIowXGroGwdoctOrEy8iAIDkgWH24k0BDBo5BtFklB05KBfAGO
	 AH4QbqhUCv7hUNq70doKO8+dCOAVI4DscUvQGfHF+1y9M8MJL1AycjAYMZncgQqFHoik4
	 fj7+L2zd6FdGqdWt1KIsfN5/E6MTg5qnenihjk2UpJ0EFOn8urJwbIEioAGG5dKpqfnwz
	 19UMDC0nnurTLPalNPBusM5peF6KsVjyGNhWMl2Ory2yJsEaAX3Q+5DQ2mTP55PfhaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aXS2FxWR;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C95606A880
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 03:38:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0C95606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aXS2FxWR
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cdb1199bfd8so691908a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 19:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794627510; x=1795232310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RMKShAqwQ8QmOnYWmrOpdePr1A2OrFNasBeIi1/KCB8=;
        b=aXS2FxWRXIHSwmbrmL55zAAKauX3ScgylHJ0IJpWAl6gQMpBqUXWe1DRpc3WYofGiB
         pZg8ShFxsCsJl2fLoH5NCUgnJZbI2WqRpSHIgWnf5pJnAzsD2l2It/A4LpvaWxBHeGPB
         bGwXmYP1Eis4LJiD3xmXATmJXHEp+suo/7IFXNeChwSKbpYLayY0huMf0oxjZ8wnQ9zU
         025HdC7wcStOhukc2E3ICNT1SJiA6c7Ga8Eu50bEHdQc+LYicDVOKIZj1VrjuwzeSj/e
         w8cgXy4WMgn1v65tkoS5GeNxu1g/Ed9nBr29hdQIP16P0AF+E/oX4vX75MjQnWHOkRmt
         l31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794627510; x=1795232310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RMKShAqwQ8QmOnYWmrOpdePr1A2OrFNasBeIi1/KCB8=;
        b=NDSf6XVDTkE1ZeAbBokhZcU8rnnZ9lRXLb4s5bFmDos6ozlfLGxnqD7aeq+4f7Jeb9
         31CmD97MMDHlaRAJ6I0eLd/507irVXPcry5/5a6OQjCa5iP/2VaZpjzQL4G1WbsXfw1E
         NquZPsHG4v3JRa69najAHNx9UryTo6Hgc0HET/XGGful5YziIrX7yj0kY/8f+gOrAUBf
         Fo+8haSi0Ir2Vt0rera0QEPS4yclZQr2K9yFbqTh7JNRkc+hs5WGhAKu0yXNrrNUp7h9
         NlnNcyyl1kFEUzdcdr3u2gDqpdQTGS36Fqd6ueqEuA2Tyzh1vEfenfSIjS85UvzcDUqv
         k+Qw==
X-Gm-Message-State: APuU4Z/iff6GN6PPhKc2qm+vocquI2mdoyKHyXpQhWdd0MZXCeUDRTRe
	2OZFA/9ubb4wTvEWg1X+XAkEdui6WZXKdzNan5IL0QXlbrCAETm7xEwvgaGUoNU6QiU=
X-Gm-Gg: AYBFou1HN0psLUwqlr2/eMSrmK/x5TsEHzu9bDdt17lupXzMiJzz8aIo2Ul6SMxyzob
	trQbP2z0GzI5IAbF8m64Do+AdNWPhzbIuk50RHGD+JSDCYayUqbu+wiUXQy11a+TeW9LBYypDc9
	4TJnVyeRQ5P0jx10uy8em+mXzQ0lICdO/t0BHBSTluMeOi14/ch5JpFkAHIwa/5t/XkkJlZhgru
	VSyPGwkO5gCdBqULtZIZPcngPb2JS6V0BYKwHOmKprjkqewOqB3U/vC8+LT7y1F+6/OYZ2BNbGu
	9ljCcm5YDHbcHZKNl9p6Y44zYQoZbnugbVDur3GaWIdRCXdxoDQOgDmAtcV5YssXz93GhKGY1r9
	qvzxnnNKgqYoU8YRjqo9yxMM7g83sTafY8qyKKqC3FREalS7DpPI7prmAaL+JIRGYXk1I9Xi/pH
	FY4VkhmBmeU7BITYSRGkbr7ztrHYzWW+tuqpJ/guEwPicLXt95YRMyGIwgZfpB5pipBHdKwVr1G
	J6BscrOgIG9X3xD4UPKf1G9zP3l4KPW9lPQxsFsfnoljB4v3rp3SjbUcWhjxLjSiacW1OUujBab
	te9NPzmHWsX2CTdkZNDSfAK7AohAsFIQcBM1g3CVyG1iiHGnW39/KLZF7YEChxEacon9a+sUt74
	NdW8VJRLkr8FvkZQuJjBJMfpd8gKD04THNAtK6g==
X-Received: by 2002:a17:90b:4ad0:b0:3ac:b3ff:b476 with SMTP id 98e67ed59e1d1-3b1b0b52e13mr4690294a91.38.1794627509809;
        Fri, 13 Nov 2026 19:38:29 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3a21769sm3412380a91.4.2026.11.13.19.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 19:38:29 -0800 (PST)
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
Subject: [PATCH v4 2/4] scsi: arcmsr: check the completion index the adapter reports
Date: Sat, 14 Nov 2026 12:38:08 +0900
Message-ID: <20261114033810.549787-3-yhlee@isslab.korea.ac.kr>
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

On adapter types E and F the adapter reports a completed command by
writing its slot number into the completion queue, and the driver turns
that number straight into an array subscript:

	cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
	ccb = acb->pccb_pool[cmdSMID];

cmdSMID is a uint16_t taken from DMA memory the adapter writes, so it
can be anything up to 65535.  Nothing compares the two.

arcmsr_drain_donequeue() cannot stand in for the missing check: it
starts by reading pCCB->acb and pCCB->startdone, so by the time it can
notice anything the bad pointer has already been loaded and
dereferenced.  arcmsr_hbaF_postqueue_isr() rejects the single value
0xffff because that is its queue-empty sentinel, which leaves
1024..65534 accepted.

Reject an index the driver never handed out, in the two interrupt
handlers and in the polling path.

Bound against acb->maxFreeCCB rather than ARCMSR_MAX_FREECCB_NUM.  The
array has ARCMSR_MAX_FREECCB_NUM entries but arcmsr_alloc_ccb_pool()
only fills [0, maxFreeCCB), and shrinks maxFreeCCB further if the pool
has to stop early at a 4GB boundary, so everything from maxFreeCCB up is
a NULL pointer.  Comparing against the array size would let those
indices through to be dereferenced.

Also clamp maxFreeCCB to the array in arcmsr_get_firmware_spec().  It is
derived from the host_can_queue module parameter and gets 64 added to it
when it is below ARCMSR_MAX_FREECCB_NUM, so with can_queue in
[961, 1023] it ends up above the array it indexes -- which the pool loop
itself then walks past.  With the clamp in place, maxFreeCCB is both the
populated range and a valid bound.

In the interrupt handlers, release the entry and step the queue index
before continuing, the same way the accepted path does.  Stopping at the
bad entry instead would leave the consumer index behind the producer,
so the adapter would re-raise the interrupt on an entry the driver has
already refused and the completions queued behind it would never be
reaped.

Measured with a KASAN build and a crafted completion queue.  struct
AdapterControlBlock is 17504 bytes with pccb_pool at offset 496, so a
reported slot of 60000 reads 480496 bytes in, past the end of the
controller block entirely:

  BUG: KASAN: use-after-free in arcmsr_hbaE_postqueue_isr+0x242/0x2d0 [arcmsr]
  Read of size 8 at addr ffff88800bf354f0 by task init/1

and the pointer it picked up then faults in arcmsr_drain_donequeue:

  RIP: 0010:arcmsr_drain_donequeue+0x27/0x360 [arcmsr]
  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

A slot inside the array but above maxFreeCCB, such as 200 with the
default maxFreeCCB of 192, loads a NULL entry and faults in the same
place:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000003: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:arcmsr_drain_donequeue+0x27/0x360 [arcmsr]

Both are refused with the check in place, a queue holding a rejected
entry followed by a good one drains to the producer index and the good
completion is reaped, and valid slot numbers are accepted unchanged.

Fixes: 235090241c55 ("scsi: arcmsr: Add code for ACB_ADAPTER_TYPE_E")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 255f1d898079f6..e635b76daae9a0 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2677,6 +2677,14 @@ static void arcmsr_hbaE_postqueue_isr(struct AdapterControlBlock *acb)
 	pmu = acb->pmuE;
 	while ((readl(&pmu->reply_post_producer_index) & 0xFFFF) != doneq_index) {
 		cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
+		if (cmdSMID >= acb->maxFreeCCB) {
+			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
+					   acb->host->host_no, cmdSMID);
+			doneq_index++;
+			if (doneq_index >= acb->completionQ_entry)
+				doneq_index = 0;
+			continue;
+		}
 		ccb = acb->pccb_pool[cmdSMID];
 		error = (acb->pCompletionQ[doneq_index].cmdFlag
 			& ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
@@ -2706,6 +2714,15 @@ static void arcmsr_hbaF_postqueue_isr(struct AdapterControlBlock *acb)
 		cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
 		if (cmdSMID == 0xffff)
 			break;
+		if (cmdSMID >= acb->maxFreeCCB) {
+			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
+					   acb->host->host_no, cmdSMID);
+			acb->pCompletionQ[doneq_index].cmdSMID = 0xffff;
+			doneq_index++;
+			if (doneq_index >= acb->completionQ_entry)
+				doneq_index = 0;
+			continue;
+		}
 		ccb = acb->pccb_pool[cmdSMID];
 		error = (acb->pCompletionQ[doneq_index].cmdFlag &
 			ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
@@ -3572,6 +3589,8 @@ static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 	acb->maxFreeCCB = acb->host->can_queue;
 	if (acb->maxFreeCCB < ARCMSR_MAX_FREECCB_NUM)
 		acb->maxFreeCCB += 64;
+	if (acb->maxFreeCCB > ARCMSR_MAX_FREECCB_NUM)
+		acb->maxFreeCCB = ARCMSR_MAX_FREECCB_NUM;
 	return rtn;
 }
 
@@ -3880,6 +3899,11 @@ static int arcmsr_hbaE_polling_ccbdone(struct AdapterControlBlock *acb,
 			doneq_index = 0;
 		acb->doneq_index = doneq_index;
 		spin_unlock_irqrestore(&acb->doneq_lock, flags);
+		if (cmdSMID >= acb->maxFreeCCB) {
+			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
+					   acb->host->host_no, cmdSMID);
+			continue;
+		}
 		pCCB = acb->pccb_pool[cmdSMID];
 		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
 		/* check if command done with no error*/
-- 
2.43.0

