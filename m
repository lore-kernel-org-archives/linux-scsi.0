Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794910515;
	b=Nahj2MrR+pnTpsAL2ECloegK3gFfGeWb5Q8gNVFJx0JF5g/9u+5Ocno6SRL3GnmhcUFd
	 IWghyCB8UrtWzW7azhxW8B9ViKintekt90KhQ6oK8tpUBS39JDgmq4XWsbxJ1o95NHHHU
	 6sogFNfrvb3PyptkvmVn6DIRDPmo3KiUucmHr9ERL/GX3Wnca3MAgV5RKECuVUmeOosrt
	 UvNI5Mu2MXu4XZHeeOrO4N61uIqXswVILjLPpgQaEX5EY1qL3ULXbVDGYCa3QisAHr1Mb
	 1jXnhyBHaUv0q/4ax5vXjnZVJPcDEQrUguQgGqrk6RmYIAdmt/Wqf6Zloz3x/p+wv4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910515;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+OgZfYhmN9odpAT2D18mA84jo9wP8hXZA1kyBonxyTU=;
	b=ayYfBXUX4Ouh0zOs6BzdNoV/AMoI/Tw4Hn6xfAFO+/gJqp2qqv4rYAEuuDurQw7nH393
	 ioAvSIRDCNOCMvgfTrZ7bdpOq4LlWmvYr5Qc8qaYpIuBz3Gq8YVunaET+5//tRJDr6cW8
	 A9sfh6g3FN4Gk6dmo13LKTDNNPJsqbWB/u3gRP8FcoVKvBPLbdeR3qeb9HrGoVkNfSuy0
	 xA6ArX4otmU0fR7ps4pApz17HN4C8luKqTkOZqhbRuG/sunekDJzQ++SZHhIEZiXnQU1c
	 m6so24+r+TKZFIjRb7NZyTaSsew8zIfCZzqLMOQnQ4a2ud0Pb1H2P6txzU6py5fj73g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kGVefD1T;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C3606A333
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 10:15:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 446C3606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kGVefD1T
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b3b4bcbfc9so5276213c88.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 02:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794910514; x=1795515314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+OgZfYhmN9odpAT2D18mA84jo9wP8hXZA1kyBonxyTU=;
        b=kGVefD1TK0+5dsY3cYuAVtCMPYoUJ+5cMcYX6yjui2yoLT3enmftrzXjRZ35CeGpQp
         0Yowc35ELTFlZI88lIu0AAOr1Chk7ecbhH9JGwPwHggvzuDX+3/gyOihxy5Q7MxM+rEE
         RTmXMOuZz85NAyxtDfbtGz0CZzHDlxJN27/vY571pksspryfaW8ZZqUoBL6M2qJhahil
         pKnqR6Llh2N6JFRyL3W9SRJLgNlU+KVbOgdVTagXtmEpm4edvlaRTe6uQFuW6J3wwFqM
         vzXxtpdpk0PJCnEV3Bb7q/DQ2293u0u6sXiWlVMVkHE+kX03/gHHggPEOgWmBOY+D7qM
         ya9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910514; x=1795515314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+OgZfYhmN9odpAT2D18mA84jo9wP8hXZA1kyBonxyTU=;
        b=oLf8g7kBqBbXtW1jB12JC/X/xTYJGimATSyZkcN/skkhzJ2dKbDdVx1g/dyjfwFIES
         lMnKf0QnoxrOuxz2rGj/ZEhtuu5ITspbdWHFX/VuoFt3cE9rfKbJJ2bCl1xngO2dgHI5
         AILFtKtbxs9+U2+AWIY2e6IwKLdYyTuM45SH3p3onL3iNTQIPzLdPNUq8wGEW/pXtBXl
         yh208+cF9JV5M1t3p5ki2taSzRbX0je5jroYDn6b62zlU/PFOkb1HhrdzyYm6cQx33vP
         mZ39ol0bxrU3FAmHw8y/jtlTMujd+e8PRU/A+vpfaHl7X2aF6zbhd1yseWPSZDmxQs2V
         40sQ==
X-Gm-Message-State: APuU4Z9ccexN4aimUtqdf0wUsTdQKPKQ8frzUN1dcFK3gVa5HXxx5D23
	FRSqVZf5qROv0zSTnMV5oZXQZiJl/9rr1S2sqL+NQuaHBWG0f66RabungzYjfAZMh4M=
X-Gm-Gg: AYBFou00e3n/GOc+CnacGTihYKmHRC26+JwenzF7oBDoewL+dWUlix+1kGCgGwI8dTQ
	XA3MPGdC+3FTyF1bJcGkrarPspRl7Vegd6d+VzYTD3i1kOrxsuVKp9t0g5boaj0leo4qE7f3ZwM
	y7EMSHU37v7lx05RlUwcz7I0oAUIjBb67H97AHNgBpAcVU7vd/AwvboVOJO/tp4d8irtOubIzeC
	21YHm6kMqkchYKg63+b0MYZ+kxOhCIouyTE4jn4hQ+jzg7jkI2GpD7kSHdk1+x24ue7r/htwTYu
	cka3ONqqx7O/7+NqEu4tnDZHosCUv9EA1HE+O0Ljpwkl71wuOFYNI/fxJaUJXR6FHANbhi2LKmc
	8hYuJC4RoGEPCKZAfrbzlZxzLmC6/1bDzARy3k8zTImpFez4omr3St5aBGC6trjaM72PkqcCSyR
	VdWX614l+U3aiBPfemlxlNSVmz6eSU+FUHH3XK6Sz9ACYKezDjQBsAItLvpscZpca8mfLuzbpYJ
	g2tR24VuJecwvxjgvkTB7w/xl9kCqVhRU+WIHzAN0zv64zgkVghpdkpluS8wVd9E8Kw+b6GHBGe
	IxWmumEe86U5cDk0l4PYHuoDXKUUsUUQR1T8d/0KNZh5z6cMndJvpeg1mt2hHI+dZG738UyrIYw
	FugIXKalXWMTITQSRx8EC9919ISLXUPNVTs/y2nVw0bV5CkfTBb0MzMa2Z4U=
X-Received: by 2002:a05:701b:2810:b0:1b5:58d:fd4f with SMTP id a92af1059eb24-1b5058e03e0mr9808630c88.43.1794910514199;
        Tue, 17 Nov 2026 02:15:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:cd44:de10:449c:756c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316e008sm39965539c88.6.2026.11.17.02.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:15:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] scsi: libiscsi: do not complete a task sent with a reserved ITT
Date: Tue, 17 Nov 2026 19:14:58 +0900
Message-ID: <20261117101500.1894608-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117101500.1894608-1-yhlee@isslab.korea.ac.kr>
References: <20261117101500.1894608-1-yhlee@isslab.korea.ac.kr>
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

