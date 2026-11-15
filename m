Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745308;
	b=gpED5jI3cscwo+H0CS/kyABdcKcDrqC0ePTOuPTOsaoeULDFGCwBifMzjYOwe3i+8yn4
	 oP3OW5Y+nvxdObZt1H/kCScB76Y1uI/FdYhS5Zz67A/Amm61PHQlIN8G3Qf5aXV+h6ika
	 kiRCfdtcvsM3I+sJX+UX7qhFox0/ZMqNCMzdaTGw6RMmt4h6nCnlznGXUMNFdpDVDIkwm
	 X0JXJQBJ1dgYvh/OTvx7IA/RI+k+xtWS7aPHfcomr8C06YD1K3D4Fi2do/WYQS8S8RjLd
	 FEeQFji7ejJjNahyHm0eu67SbDs2rH//Mv3YYXmuhPyrcrwLEF2IGq2oVDJILngzYNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745308;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NMGrxZznHawUEjRUZsz9d1aEKxdWjOuKpcNIRmMkMEw=;
	b=jHVP0aMvcUQqcwE0OV5DZRDTkxqJS44/8jOZtqzTpu9AK/RiLKKJwwe25kacjpr9s5Px
	 vyqNhrH7nGcAlYkhwuKvJ61dJIl/ELTNCBSXpbZDfXYbLiWqy51k7Pfy99l04aGdoe+IP
	 R0MplsKSYKsBc8x6EjJlez5dMqE4iTN9tv9afvVnHyKsn603hAzNwsyLsaxAxqc5Z8Tz+
	 MG8CCTYZd/Zvk/Gqx1SN1U/alaJsFoD68+DXvwsAsr5BIVKQOuFkiY2sP+bXYkKC0DxY0
	 Bw/1KEAx6rHcS0GokL4qJu32UunjU/2u96l18Uh32E+dF3mol0+goQNI1Nv675ONPwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qwM71eFw;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24BB606A31F
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:21:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B24BB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qwM71eFw
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b0e61a4decso3130053a91.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 04:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745307; x=1795350107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NMGrxZznHawUEjRUZsz9d1aEKxdWjOuKpcNIRmMkMEw=;
        b=qwM71eFwCnvR5tzLMUMUPdMmkGhdZcju9MPhQHRUkm5eQ6jD5PM+WmcLXyM6upChj5
         tfH1aBTROmZwfnZrunohmeyqbZeK+ItmIF3VQk2phpWsI2Ei1VtSV0Y9sHe6L/aytPxx
         TpTle2T/RiMwEjKN68kJuGnOfjO0QDbpius8gDOj53EsC5stGMaYPiCZvRWS7iL7+qiJ
         JgT7lkKjmIf1BO/K+TBchoQ8FUKqk9UgjTDtutfjSj4wVmN1OptxLteLcpHrqCYKA3ha
         gwS3pkInJuC87cRggFCtHzV/9+AA2n4NMWdi62aWfH4Yz920BsX5vuLAyljf8vPkyYeO
         SaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745307; x=1795350107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NMGrxZznHawUEjRUZsz9d1aEKxdWjOuKpcNIRmMkMEw=;
        b=OieJlVvcg8KdHalZOS8JfqbMYEMw60e8DDSKA9tl9qc6e9i8rvNQaErkDNb/XpdNfC
         69lw5Wsmepjg5olyOxXjra9f2pUs+UQl27He1z+tYdD/eAT2Bk3b9RCgiSF0+pQl+VWy
         +T+RQM8jfwdxeeF9L/bLfQVycBQrtqHn7DEdw+1pyi8+TWHr1qZ3sXl3RN/+h8OY37RS
         UDuyr/SM8R41eE87bfYsxS3x9fYTxddooT2tYnO8bMF5riama+KGfjWrtGd9/ZVRBYgn
         lz05wn+1iQCJQHQgWFRyWubEN/XBrZmZCrPRQnEhtT2Hb2SgbsM5yIGvHpbi734X4gm6
         ut4A==
X-Gm-Message-State: APuU4Z/tQR6PxK7ydgnXmjCJ6+K0g2BjNj4AIdCMqlM5/LO3FprO7ArE
	PrZGkALXrJiRrF5zggMdCfkSt1N2TkysokdhTtnLhA5K6/bn+QC9hB7NDoNC6C+z4kI=
X-Gm-Gg: AYBFou3Qqp4Ts/fn08L257dAn1h3rYn1YrQvJmW3gTJ8lCIzdo7N1aOJlAET7h5VslH
	Zja76I9YusD9NEGRwRf6kf/VNs5g00uUFlRqWR4PiU90ALDJYeQ8X++f+DSqKpm4KzfwtRRBVuj
	gFiV6DCkvCpCDgtkDoGj7G9j9ARVvCXt4GKQUbevbnxZ9MMduQydTLKoSLFK5bwxig8ImeDEwAp
	LRW4vr2X8XwGRAau+ZB3A+84E8dSdEDn8AqKjH3lTJyMza2ur5UixN1GKvgjj3hEVBBvNH4lzfX
	7+UlZeV8H+7eBE10YHF4/2WtcPncNqcl1lrEQffDyBFvx/tTmXQhshW5nUKSEnp2UGfl1HpY/It
	WWZEvQqjXdwVwFnHWoE1IdlhDx37HHO2cojoQ7RBJlJt/1E8XZoSDONyEOUmQ//mdPSwl1RdHzk
	eylEEumpodCOUkQA3z7rKpGnz9gyjRWx12xzeYbjMp9HXq7DydtUdy0a6yHlocWnoTmupPiL3kI
	G16fA+e43u24d0nGcoABfboaSgS+j4JaWAUtBxks8/P3Ze5QQWIDPp3fUGBLlcov6B4kdyqhc7E
	iLxaV1zokidUCQErSdu1NQ+A2mtJ36yyRIIENOvONZ9DtclUbjiENd/1wS8ewljW+tJrLUSBey9
	KOOHctlfnIrAUTUoSo/QKFamk/tyA5jpCEtyBTg==
X-Received: by 2002:a17:90b:3b8a:b0:3ab:a3ee:33ad with SMTP id 98e67ed59e1d1-3b1b0b6679dmr7693566a91.22.1794745306948;
        Sun, 15 Nov 2026 04:21:46 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18736b3sm3301925a12.7.2026.11.15.04.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:21:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] scsi: libiscsi: take a transmit reference before a task is published
Date: Sun, 15 Nov 2026 21:21:22 +0900
Message-ID: <20261115122122.1446791-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115122122.1446791-1-yhlee@isslab.korea.ac.kr>
References: <20261115122122.1446791-1-yhlee@isslab.korea.ac.kr>
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

A task becomes visible to the receive path when its state is stored as
ISCSI_TASK_RUNNING, and the receive path completes it under back_lock
while the transmit path works under frwd_lock.  The transmit path
publishes that state before it owns a reference of its own:

 - iscsi_prep_mgmt_task() and iscsi_prep_scsi_cmd_pdu() store the state
   and the reference is only taken later, in iscsi_xmit_task().  A
   response that lands in between drops the only reference, so the slot
   is back in the pool by the time iscsi_get_task() runs, which then
   warns and drops the PDU.

 - a transport without an xmit workqueue does not call iscsi_xmit_task()
   at all.  iscsi_send_mgmt_task() and iscsi_queuecommand() call
   session->tt->xmit_task() holding only the allocation reference, so
   the slot can be freed and handed out again while the transport is
   still sending from it, and the error path then puts a reference it no
   longer owns.  ihost->workq only exists when iscsi_host_alloc() is
   called with xmit_can_sleep set, which iscsi_tcp and cxgbi do and
   iser, bnx2i, qedi, be2iscsi and qla4xxx do not.

For a SCSI command there is no point publishing the state at all,
because iscsi_itt_to_ctask() does not read it: a task is reachable
through session->cmds[] as soon as iscsi_alloc_task() fills it in, so a
target that answers an ITT it has not been given yet reaches
iscsi_scsi_cmd_rsp() for a command that is still sitting on
conn->cmdqueue in ISCSI_TASK_PENDING.  That drops the only reference,
which returns the pool slot and calls scsi_done() with whatever the
buffer held, and leaves the task on the queue; iscsi_data_xmit() then
builds a PDU from a task whose ->sc has been cleared.

Once session->tt->xmit_task() has failed the task is stored in
conn->task and sent again, without checking whether a response that
arrived while frwd_lock was dropped has completed it in the meantime.
The two senders that have no workqueue report that failure with the
task still ISCSI_TASK_RUNNING, so the receive path can complete it
after back_lock has been dropped and before the caller puts the
reference it was told it still owns.

So: take the transmit reference before the state is stored, in
iscsi_xmit_task() and in the two callers that send a task themselves;
make the SCSI lookup skip a task that has not been sent; finish with a
failed send inside the same back_lock section that tests for it; and do
not hand a task to the transport again once it is no longer running.
The state is read under back_lock, which is where it is written.

Two choices in there are not arbitrary.  The SCSI lookup rejects
ISCSI_TASK_PENDING rather than everything that is not
ISCSI_TASK_RUNNING, because iscsi_eh_abort() deliberately leaves the
receive side running after a successful abort TMF and says so, and a
late response for the ISCSI_TASK_ABRT_TMF task it leaves behind is
absorbed by iscsi_complete_task() today; rejecting it would turn that
into a connection error.  And iscsi_send_mgmt_task(), whose caller
frees the task, parks a failed send in ISCSI_TASK_COMPLETED rather than
ISCSI_TASK_PENDING, because bnx2i_cleanup_task() and
qedi_cleanup_task() read ISCSI_TASK_PENDING as "never sent to us" and
skip their cleanup, and both of those are no-workqueue transports.

All four were reproduced with test-only delays that hold each window
open, in a QEMU guest with KASAN against a userspace target reached
through a proxy that can inject a PDU of its own, and on iSER over
soft-RoCE against an in-guest LIO target.  Every cell is a fresh boot
and each arm was measured five times, with any cell where the window
closed before the response had been processed counted separately.

For the SCSI window the proxy sends a SCSI Response naming a pool index
it has never seen go out, while the command is still on conn->cmdqueue.
Without this patch the slot went back to the pool inside the window in
5 of 5 attempts and the read returned success on a buffer nobody had
written; with it, 0 of 5, because iscsi_itt_to_ctask() refuses the
response and the connection is dropped with ISCSI_ERR_BAD_ITT, which is
what the driver already does with every other unusable ITT.  What the
transmit thread does next with the slot it has lost:

[   14.300338] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
[   14.302897] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   14.303981] CPU: 3 UID: 0 PID: 52 Comm: kworker/u16:2 Not tainted 7.4.0-rc2-00473-g7baa29cbc558-dirty #2 PREEMPT(lazy)
[   14.305403] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   14.306889] Workqueue: iscsi_q_2 iscsi_xmitworker
[   14.307549] RIP: 0010:iscsi_prep_scsi_cmd_pdu+0x2ef/0x2220
[   14.308284] Code: b6 04 02 40 38 f0 7f 08 84 c0 0f 85 c5 0f 00 00 4c 89 e1 41 c6 43 01 01 49 8d 53 08 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 <80> 3c 01 00 0f 85 09 17 00 00 48 b9 00 00 00 00 00 fc ff df 49 8b
[   14.310690] RSP: 0018:ffffc90000397b18 EFLAGS: 00010246
[   14.311388] RAX: dffffc0000000000 RBX: ffff88800cfc1800 RCX: 0000000000000000
[   14.312326] RDX: ffff88800cfc1900 RSI: 0000000000000001 RDI: ffff88800cfc1808
[   14.313265] RBP: ffff88800ce40378 R08: 0000000000000001 R09: ffff88800cfc18f8
[   14.314202] R10: 0000000000000000 R11: ffff88800cfc18f8 R12: 0000000000000000
[   14.315139] R13: ffff88800ce42440 R14: ffff88800cfc1858 R15: ffff88800ce40388
[   14.316077] FS:  0000000000000000(0000) GS:ffff8880e5728000(0000) knlGS:0000000000000000
[   14.317135] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.317904] CR2: 00000000005a46e2 CR3: 0000000005672006 CR4: 0000000000770ef0
[   14.318844] PKRU: 55555554
[   14.319217] Call Trace:
[   14.319564]  <TASK>
[   14.319872]  iscsi_xmitworker+0x56b/0xf20
[   14.320417]  process_one_work+0x697/0x1060
[   14.320979]  ? __pfx___schedule+0x10/0x10
[   14.321522]  ? __pfx_process_one_work+0x10/0x10
[   14.322136]  ? _raw_spin_lock_irq+0x81/0xe0
[   14.322699]  ? __pfx_iscsi_xmitworker+0x10/0x10
[   14.323313]  ? assign_work+0x11d/0x370
[   14.323830]  worker_thread+0x45b/0xd10
[   14.324341]  ? __pfx_worker_thread+0x10/0x10
[   14.324923]  kthread+0x2c8/0x3b0
[   14.325369]  ? recalc_sigpending+0x15c/0x1e0
[   14.325953]  ? __pfx_kthread+0x10/0x10
[   14.326461]  ret_from_fork+0x36e/0x5a0
[   14.326979]  ? __pfx_ret_from_fork+0x10/0x10
[   14.327556]  ? __switch_to+0x572/0xdc0
[   14.328073]  ? __pfx_kthread+0x10/0x10
[   14.328582]  ret_from_fork_asm+0x1a/0x30
[   14.329119]  </TASK>
[   14.329429] Modules linked in:
[   14.329880] ---[ end trace 0000000000000000 ]---

For the state publication, a NOP-Out answered by the target inside the
window, the slot went back to the pool in 5 of 5 attempts without this
patch and 0 of 5 with it, and the xmit worker hit "WARNING:
drivers/scsi/libiscsi.c:1598 at iscsi_xmit_task+0x6e0/0x920" on the
iscsi_get_task() that then fails.  For conn->task, where the target's
own reply to a ping lands in the window, the completed task was handed
to the transport again in 6 of 6 valid attempts without the patch and 0
of 5 with it.  For the no-workqueue path the reference was put twice in
5 of 5 attempts without the patch and 0 of 5 with it, as "refcount_t:
underflow; use-after-free." from iscsi_send_nopout().

Baseline behaviour is unchanged: discovery, login, write, read-back
compare, a 1 MiB O_DIRECT read, NOP pings and logout pass on iscsi_tcp
and on iSER, and so does an abort TMF driven by swallowing a response -
the path that leaves a task in ISCSI_TASK_ABRT_TMF with the receive
side still up.  cxgbi, bnx2i, qedi, be2iscsi and qla4xxx need vendor
hardware and were not run; their paths were followed in the source
only.

Fixes: 659743b02c41 ("[SCSI] libiscsi: Reduce locking contention in fast path")
Fixes: 533ac412fdb4 ("scsi: iscsi: Remove unneeded task state check")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/libiscsi.c | 58 +++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 220e89d541af68..5045f6f5ca01b3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -429,8 +429,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
-	/* Pairs with the acquire in the RX task lookups. */
-	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
@@ -703,8 +701,6 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
 		session->state = ISCSI_STATE_LOGGING_OUT;
 
-	/* Pairs with the acquire in the RX task lookups. */
-	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
 			  "datalen %d]\n", hdr->opcode & ISCSI_OPCODE_MASK,
 			  hdr->itt, task->data_count);
@@ -829,7 +825,20 @@ static int iscsi_send_mgmt_task(struct iscsi_task *task)
 		if (rc)
 			return rc;
 
+		iscsi_get_task(task);
+		/* Pairs with the acquire in the RX task lookups. */
+		smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 		rc = session->tt->xmit_task(task);
+		/* regular RX path uses back_lock */
+		spin_lock_bh(&session->back_lock);
+		/* The RX path completing the task is also a successful send. */
+		if (rc && task->state != ISCSI_TASK_RUNNING)
+			rc = 0;
+		else if (rc)
+			/* Keep the RX path off it; the caller still owns the ref. */
+			task->state = ISCSI_TASK_COMPLETED;
+		__iscsi_put_task(session, task);
+		spin_unlock_bh(&session->back_lock);
 		if (rc)
 			return rc;
 	} else {
@@ -1455,6 +1464,10 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_session *session,
 	if (!task || !task->sc)
 		return NULL;
 
+	/* Pairs with the release in the transmit path. */
+	if (smp_load_acquire(&task->state) == ISCSI_TASK_PENDING)
+		return NULL;
+
 	if (iscsi_cmd(task->sc)->age != session->age) {
 		iscsi_session_printk(KERN_ERR, session,
 				  "task's session age %d, expected %d\n",
@@ -1556,9 +1569,20 @@ static int iscsi_xmit_task(struct iscsi_session *session, struct iscsi_conn *con
 			WARN_ON_ONCE(1);
 			return 0;
 		}
+		if (!was_requeue)
+			/* Pairs with the acquire in the RX task lookups. */
+			smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	} else {
 		/* Already have a ref from when we failed to send it last call */
 		conn->task = NULL;
+		/* The RX path may have completed it while the tx was stopped. */
+		spin_lock_bh(&session->back_lock);
+		if (task->state != ISCSI_TASK_RUNNING) {
+			__iscsi_put_task(session, task);
+			spin_unlock_bh(&session->back_lock);
+			return 0;
+		}
+		spin_unlock_bh(&session->back_lock);
 	}
 
 	/*
@@ -1584,10 +1608,12 @@ static int iscsi_xmit_task(struct iscsi_session *session, struct iscsi_conn *con
 	spin_unlock_bh(&session->frwd_lock);
 	rc = session->tt->xmit_task(task);
 	spin_lock_bh(&session->frwd_lock);
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&session->back_lock);
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer = jiffies;
-	} else {
+	} else if (task->state == ISCSI_TASK_RUNNING) {
 		/*
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
@@ -1596,7 +1622,8 @@ static int iscsi_xmit_task(struct iscsi_session *session, struct iscsi_conn *con
 		conn->task = task;
 	}
 
-	iscsi_put_task(task);
+	__iscsi_put_task(session, task);
+	spin_unlock_bh(&session->back_lock);
 	return rc;
 }
 
@@ -1892,10 +1919,25 @@ enum scsi_qc_status iscsi_queuecommand(struct Scsi_Host *host,
 				goto prepd_fault;
 			}
 		}
-		if (session->tt->xmit_task(task)) {
+		iscsi_get_task(task);
+		/* Pairs with the acquire in the RX task lookups. */
+		smp_store_release(&task->state, ISCSI_TASK_RUNNING);
+		reason = session->tt->xmit_task(task);
+		/* regular RX path uses back_lock */
+		spin_lock_bh(&session->back_lock);
+		/* The RX path completing the task is also a successful send. */
+		if (reason && task->state != ISCSI_TASK_RUNNING)
+			reason = 0;
+		else if (reason)
+			/* Give the command back inside the lock, not after it. */
+			iscsi_complete_task(session, task,
+					    ISCSI_TASK_REQUEUE_SCSIQ);
+		__iscsi_put_task(session, task);
+		spin_unlock_bh(&session->back_lock);
+		if (reason) {
 			session->cmdsn--;
 			reason = FAILURE_SESSION_NOT_READY;
-			goto prepd_reject;
+			goto reject;
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-- 
2.43.0

