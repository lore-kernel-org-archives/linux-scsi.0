Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794613196;
	b=NEGRu4FLhPKibw2+YgYnukjEW/LH64GDWyla/kJmi8WrKxkYcaiD7/m7EDUxWPMPV7Fo
	 OCTbxpNjentAwGQdqi4Rn54wQDb20WIyLeCZGGM9eYJzWi7rTSAb0nYQJRQPDKZh+auUg
	 1rhXjxBQUCYpvvHUTC7NjXDxRcsuL7WoLFJ87+nme3wlAS/WM2NNeF2I2Vke1EqUeP7Ew
	 OALOz1ChKrtZMMXxU3laTF9i2AJoku+4lE1yI+6zUItnk5vtmx6ligypqNqqn0N+G4b9M
	 5KFPaS2jl/80MRO6WGg172FXjFtRFBkjneul1KsbA63y8l0h0Q9oIiMAx0/KYIp4DCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794613196;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=d1YJTyGepk3eI94VpMClp0iOOw7oSudDD5fG9CWlLkQ=;
	b=kqgkZZMV8V7405rRMHZ5kEgMLB+349zpvMygKajY5mGezZklmHO5JqLQ6DtA2W8+Ipw+
	 3Xxw/8KEc+WZNf06/GoNXYP5uTgA7mrJDywh8DSOIufeqSDcrnTwNFED4FV48uMW3PSMs
	 EfCvWwEMcLRM0DDGqjJ5WtEJzpA6ZkL23fLReogTK3hqyJacgjHja/OSnq40vNDqB0ge5
	 f2zPQo/7MstDMtlj2kvcX20eiwUhVXNvMdVBqXp10aQ1Uv4IF55R2NXrjTBuHBUGKSTUv
	 9BUWMTHCNRBglCHlagbrVOypYiqvmuZZg2kIcPC9X7u3cWWWsLd0eXd0pHyGQifowlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="lN/+bIyK";
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D5E606A89E
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 23:39:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12D5E606A89E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lN/+bIyK
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so1752868a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 15:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794613195; x=1795217995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d1YJTyGepk3eI94VpMClp0iOOw7oSudDD5fG9CWlLkQ=;
        b=lN/+bIyKX7BVvrfS94hqWF1bmEDYiIM72UwOcUckXGuO6t8TMlthwMA5+fGm6nkUSw
         QmsNszhhDDHYzRCeQoxDYlmbBrFMPXTliFurODWI76O4nfMeGV20Q1zJpO6jiJkGXQ+g
         o6SzHylMR8g+54FdDb95u07WKxp1rMelQ9UMMq4fbo/FMFxOQBBqDN9XOpYEmo4AFjgl
         KXHUXco6QaszFitGcTjRfWoz+6sOv1hnqZB8sYOfTnAqgsJ9E3qAsyxzShhC9I5l41VG
         NHmvmaEJdSqr6xllzaTZ1Hi2ZPt0O6YnXefFULxdOpXMPin+9k8WkTmhbVKiGOEHDfO1
         /lmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613195; x=1795217995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d1YJTyGepk3eI94VpMClp0iOOw7oSudDD5fG9CWlLkQ=;
        b=phA/Unt/oGl6aJFEUDKeB2kGc39pqfRf+4DQwu5CQQbOGtvRMF3+V3gllcUZtDgk00
         vpeekrGSZq2/X6W3XV3+EVDMhoWrgg+Iirx9JzanDqmQ/kRf9ejZgEk2eHYR63a4lV+h
         VcApsBO21X492mhYX5GkNUToGIFp3RvrzF15bZ99Ghio4oLcPeT/YGQwp4hjiuGGoPOU
         s51tX/ySLWU3mM5lzc1rI7Yl4U6R8Fgq+zLw4pDDnPvtn3gJujeQ9OZiTSXIFAGYibpp
         70xZ1tElB27BRjDFD3VE28DyESV0cu8+Lr0iytibh1ILj8ZVUvQs+nSAEe7tNixPSO1p
         EJcQ==
X-Gm-Message-State: APuU4Z8RhQd+p3MF2tme4Vq5T9A7sXH14d5pqNxCg91Xaz1f0FMTpKth
	p5GHlPcwGfRND8+sc7X/dJmCNTVRJ588TggM4FyPJ4+z7+dz82YRu3US6466xU80XEU=
X-Gm-Gg: AYBFou13FFhI2b6mAFNYhvsdmGiDkMehQhG7JbyI+kyrofVSOu/zkOb9CnMKYBoIE14
	vH/2HQK0ihhux6yc4JJmgMM2dIvnC+dVwppJhQdIT+HF+FZppFO/D6WVTtYrGq602N6iX58QA3d
	8z3qclWfngFVGulccpw1I3yJff+rTXOZgoHfmRKMkcLTcFxoXZxYOSyr5j+ZjSkVmqs1vrTChS2
	UWSffiC10hrgRVVi5sIidQN0q/58QUnB4mkqP3SWJD9RFjTV//+fGsbAPGsStgVwF9flMkGxBki
	dUV8BEC9xC+Zh8MbroPWsEVKIdEadtRO7cO4EumSIl7JuAUKyoFF2vamwWbKiitOAFxekOIEPVV
	6u2R3jeZyQqATHQ1uSw8gUoX9DE5aARfvsFEt9L3ia+ZhHWtpybY5MkqLSKpe85mZ1Cy4DLK9Zu
	Ka0rY3KKkDBTDLoxdxedq306zLNH7IlKC6vq2FPqh5vUM6FowLq/sufdiTyMIdaVrbVWdgwGkgs
	9200ep6TPiQyis63Hc8nQa3pXQ6ZobOWlHqp2sWyBh/HQVCXoPCs4mWg4UYXL2tdP0XKeELCj+x
	InxE/QCLFnym/RX4W+2NkQOeGg96hYic/UKNNdkf7H6vqGkqU2EaMuKrZF7A+/hpRErHD8j1W85
	78HfeQfQZwB8X5PovVvtvKbPkr2/0gQik8eSLDQ==
X-Received: by 2002:a17:90b:1c07:b0:3a4:ad5c:d48a with SMTP id 98e67ed59e1d1-3b1b0dd0b7emr3784658a91.67.1794613195331;
        Fri, 13 Nov 2026 15:39:55 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aeb3d2d4sm6442462a91.7.2026.11.13.15.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:39:54 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: libiscsi: do not complete a task sent with a reserved ITT
Date: Sat, 14 Nov 2026 08:39:38 +0900
Message-ID: <20261113233938.397415-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113233938.397415-1-yhlee@isslab.korea.ac.kr>
References: <20261113233938.397415-1-yhlee@isslab.korea.ac.kr>
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

A NOP-Out sent in answer to a target NOP-In carries RESERVED_ITT.
iscsi_send_nopout() puts RESERVED_ITT in the header and
iscsi_alloc_mgmt_task() keeps it there, because the build_itt() assignment
is skipped for a reserved ITT, so nothing that identifies the task ever
reaches the wire.  No response is expected for such a PDU, so the one
reference the task holds belongs to the transport, which drops it once the
PDU has been sent: libiscsi_tcp and iser do that from their transmit
completion, bnx2i and qedi from their local NOP completion.

task->itt is not touched by any of this.  It stays the task-pool index, so
session->cmds[] still names the task, and iscsi_itt_to_task() looks a task
up by that index alone.  A management response or a Reject PDU naming the
index therefore finds a task that is ISCSI_TASK_RUNNING with no scsi_cmnd
attached, passes both tests, and reaches iscsi_complete_task(), which drops
the reference the transport is about to drop as well.  The window opens
when iscsi_prep_mgmt_task() publishes ISCSI_TASK_RUNNING and closes when
the transport has sent the PDU, and a target that stops reading holds it
open for as long as it likes: iscsi_xmit_task() keeps the task in
conn->task with an extra reference while the transmit keeps failing with
-EAGAIN.

A Task Management Function Response naming the pool index was accepted in
all 11 runs of a KASAN kernel whose window was held open for 200 ms, and
every one of them ended in:

  ------------[ cut here ]------------
  refcount_t: underflow; use-after-free.
  WARNING: lib/refcount.c:37 at refcount_warn_saturate+0xad/0xe0, CPU#0: kworker/u8:4/50
  Modules linked in:
  CPU: 0 UID: 0 PID: 50 Comm: kworker/u8:4 Not tainted 7.4.0-rc2-00472-g76215e83dc82-dirty #1 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: iscsi_q_2 iscsi_xmitworker
  RIP: 0010:refcount_warn_saturate+0xad/0xe0
  Code: a9 9b b7 03 67 48 0f b9 3a 5b 5d c3 cc cc cc cc 48 8d 3d a6 9b b7 03 67 48 0f b9 3a 5b 5d e9 1a 11 33 02 48 8d 3d a3 9b b7 03 <67> 48 0f b9 3a 5b 5d e9 07 11 33 02 48 8d 3d a0 9b b7 03 67 48 0f
  RSP: 0018:ffffc90000347b18 EFLAGS: 00010246
  RAX: 0000000000000003 RBX: ffff88800a74a878 RCX: ffffffff823c2735
  RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffff85f3c370
  RBP: 0000000000000003 R08: 0000000000000001 R09: ffffed10014e950f
  R10: ffff88800a74a87b R11: ffff88800c8f26e8 R12: 0000000000000000
  R13: 1ffff92000068f6b R14: ffff88800c75c5c8 R15: ffff88800c8f2400
  FS:  0000000000000000(0000) GS:ffff8880e55a8000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f10f26585f0 CR3: 0000000005672002 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   iscsi_xmit_task+0x1c8/0x770
   ? iscsi_sw_tcp_pdu_init+0x268/0xb00
   ? __pfx_iscsi_xmit_task+0x10/0x10
   ? _raw_spin_lock_bh+0x84/0xe0
   ? iscsi_prep_mgmt_task+0x381/0x600
   iscsi_xmitworker+0x1c8/0x8b0
   process_one_work+0x697/0x1060
   ? __pfx___schedule+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_iscsi_xmitworker+0x10/0x10
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdc0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  ---[ end trace 0000000000000000 ]---

The slot is back in the task pool by then, so a concurrent allocation can
hand it out while iscsi_xmit_task() is still working on it.

Refuse such a task in both receive-side lookups.  A task whose
task->hdr->itt is RESERVED_ITT is one the target was never told about, so
no response can name it legitimately.  The test is on the task the lookup
returned rather than on the received ITT, and iscsi_alloc_mgmt_task()
copies the caller's header for every transport, so task->hdr->itt is
RESERVED_ITT there and nowhere else.  It is evaluated last, after the state
test, so it only runs on a task that has been prepared.  With it in place
the same injection was refused in all 10 runs, and a target NOP-In, the
NOP-Out answering it and the initiator's own pings are unaffected.

Fixes: 3e5c28ad0391 ("[SCSI] libiscsi: merge iscsi_mgmt_task and iscsi_cmd_task")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: unchanged from v1, now sent with the patch it depends on so it applies:
https://lore.kernel.org/all/20261113232322.395246-1-yhlee@isslab.korea.ac.kr/

The review that pointed this out is

  https://lore.kernel.org/all/sashiko-outbox-213058@kernel.org/

It raises a second issue as well - the window between the state store in
iscsi_prep_mgmt_task() and iscsi_get_task() in iscsi_xmit_task() - which
this patch does not address.  Closing that one means taking the transmit
reference before the state is published, which is a different change.

The 200 ms window above was held open by a test-only module parameter that
is not part of this patch.
 drivers/scsi/libiscsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 83d726043d3e8d..220e89d541af68 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1177,8 +1177,9 @@ static int iscsi_handle_reject(struct iscsi_session *session,
 				task = iscsi_itt_to_task(session, conn,
 							 rejected_pdu.itt);
 			/* Pairs with the release when the task is prepared. */
+			/* A reserved ITT means the transport owns the task. */
 			if (!task || smp_load_acquire(&task->state) != ISCSI_TASK_RUNNING ||
-			    task->sc) {
+			    task->sc || task->hdr->itt == RESERVED_ITT) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");
@@ -1318,8 +1319,9 @@ int __iscsi_complete_pdu(struct iscsi_session *session, struct iscsi_conn *conn,
 	case ISCSI_OP_NOOP_IN:
 		task = iscsi_itt_to_task(session, conn, hdr->itt);
 		/* Pairs with the release when the task is prepared. */
+		/* A reserved ITT means the transport owns the task. */
 		if (!task || smp_load_acquire(&task->state) != ISCSI_TASK_RUNNING ||
-		    task->sc)
+		    task->sc || task->hdr->itt == RESERVED_ITT)
 			return ISCSI_ERR_BAD_ITT;
 		break;
 	default:
-- 
2.43.0

