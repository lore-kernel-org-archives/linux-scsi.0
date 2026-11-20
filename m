Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186375;
	b=FB3vitWxgHfRsYC1aTD2qhuJtgfEjg9a5P3flYV95LUCC0eUqaNsk2Es/gRBY/kdZl54
	 BhvTyNbdnbBUrw0qSgvGQJK3YUHeYNZGqz+eMEREEOgSM7ZBD1SKMOV234IF6DC9hS+mZ
	 iQs9xX5AcobtczOKF6LQifHVky5rlA7o16GgwXGroncRgMe/JebFnVPfFoZhGFKVMqn7S
	 iMdVCtkykRmC0DACPsPGXo0uF0/qDIB3/OwHRLZCFd6BfJ0m6Jof+bzMaQWQlaQkynmzg
	 0eLmE9b3ABd107cImaYbsyFScjaya2Gcegyf5GtTn/WwhcNg0fVWavyK2Hcr1wXmHhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186375;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=w+FVy673x+oTragde9PzcsSOA9zSMUs8PCGZhkAnfZM=;
	b=lQcE+yo7J+Ubi888cHGUtjXAAie0Z0lFwHfEkCp8+Pxtw7cfBD9dgZMYg0cbqg3gbMBk
	 3evVwbAfbrDtHTkRDYgFOEIsBLUjtWlcS/QvSWKeQWOlDUsH0+ubxE1wDSXTNQYvejph3
	 sL65aSYX6SSmFmyMAKb9FIfRvTSlL1Vk/kRdSI/E4IVAv5HsDAJKxyrtt1Rpy5AsAm+pn
	 0m6rRAKHQAN3cSffxg4shZvGvbRz1Ds37m1GU+0vRS4eVTf5xhHE66Fli8mV25O5mokhD
	 xie6kXZJSlwBOaCwDTlEMTZh7RNEFHQzNmfhKRFlIoCQCiwBKx+kRVaSuHExKVhufug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ic4MztMH;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEF9606A325
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AEF9606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ic4MztMH
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso781372a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186373; x=1795791173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w+FVy673x+oTragde9PzcsSOA9zSMUs8PCGZhkAnfZM=;
        b=Ic4MztMHptOIsDCMQqbVa+Xu76N+Elf2OZmcRurVlAPxUDwfYj/N+ha8MvK25nLC1j
         ylEq+T2shrUyjStG04zn22aweKuNb9XM3eJMckP2s0Z80ndtWLSTl1/zHP/ySKHIUxsc
         xEB5C9AxOF182LNDeo8etbHAdsGtMW1ElZ8QQXXo7Ey5tpavWIw4TgyM0tZYcezqzQuD
         KttwsP7Ld/fBvDGqZRk+G88IbfcE4Yz7zIqOVeFBVhxtDjOnRDJl2tiddgy8JbyE0Ml3
         5VkMBYJvPGQ1/kZ5pjiWgDBOdGqXE6XWI8ycTnbTVu/zzn9GDoH4hu4j3thMrI7O5jWq
         tbfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186373; x=1795791173;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w+FVy673x+oTragde9PzcsSOA9zSMUs8PCGZhkAnfZM=;
        b=1zbrwrcWWmZczFTuYzmt/EG2bNeAlWOLiDzuFnRKzPovr7vPrpaqX7mCjCpZpjtzBl
         qBAyj8P/HJS77Swzwflcf3ksHqUP8J1mbnIQ6Ao27TWQpVlUwjwApD8ZYyLD8w7AbWFu
         hfllOKxz4AEAoEcoVWK6D6gh1VJ+Gadw6y3HNs/skJZYBSZZ778abRsDLUGBkafHwIa6
         bBL8Meumeybg+yEqEyCgybSVfTXc7lwNC3VXknewO1x756KiF5CyGZIZPMQCs9C2ZSmk
         e9Yzj1zIKp6iIe4D/C+o4ZOi+lI2Fhi3+pVAHUTKgsRUBPZHTdDyq+Vdu0F6AtkS34dD
         1rIA==
X-Gm-Message-State: APuU4Z9Pp8lGrx5cbECCzLZx+ZERnYVdFJPr9iP3td+DU7GiCyfZCZ1H
	cc/14FERY5DocXtyZy9/dp16/Ay5uySH4ZDo+dCALBQJ0mP/kb8VvRdQ5qGIOfaZq3jVPH36eE2
	ahM8zxq4=
X-Gm-Gg: AZFdTZfjjidjXRq6Mhvq26lmZJrZT/rqQ/3ZdfRHctqaKsgwdYvYKAxKQ/q3GbOBHMA
	ZPebN+BWM940/eMBx6acVtrMM3KbrzK6tZUDMYYb2/7QO/B1lwfB1770kZxyu1aT29ZYsfg0aq2
	fhh+YTeS2jO3kJ+qVAyS3N/jK1hr6I6DrJJ8iNaKQpg3nvDC0bzK1S23gcsKRggsI1HC16oSxN8
	WR4aF+d+4NVgrmgn9u6EVjLPed5qPvI3UZ8xTw2TxFn/rozMDU6y0guzchHqcOGcHJjQVljMszg
	VBAZRjo7lhLfZiGwLjFMdGg1ihxU0Ol5PDlEMXK6ii+4RuI/9uhR0T534YxhSHWofyc2zAKiRB5
	vB+z9zHvUJpe5MKGG5D6jRn3IWELGHtUX0nU3lv+6Dx8UANGCBzznTo4t9xxd1ddd0uadInIGjQ
	w2GNbbVmYnkY3hCo3TWRPrCrYDPUQT466RBKr1R2YZvFhoGWob9Btt/Unn6gf/E6q9JVEUYPV6c
	KzWoibN2EOTZ2nLIciCe31fkU0g/7Biq7+LBmOpzT9fms/QJOelTcNd9FjJOWhinYSuOiQvNUle
	8h26p/7o3sl1Pa0F7pEjyc8YV7uW8EU8R54elJHIGz30QhAjhqOQIedBH7g3sAF3ZBoP/B20JUx
	ZRqmHdZFDt3h9PHVClqu/scoGVa4qRuQaC2lZ
X-Received: by 2002:a17:90b:1802:b0:3b3:cae0:2b6c with SMTP id 98e67ed59e1d1-3b41c92c569mr3478020a91.34.1795186373173;
        Fri, 20 Nov 2026 06:52:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41aab4729sm4643064a91.0.2026.11.20.06.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:52:52 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libiscsi_tcp: hold back_lock across the copy of a Data-In
Date: Fri, 20 Nov 2026 23:52:43 +0900
Message-ID: <20261120145243.3124991-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

iscsi_tcp_hdr_dissect() aims the receive segment at a command's
scatterlist and drops back_lock, and the copy itself then runs once per
skb in iscsi_tcp_recv_skb() with nothing held:

	rc = iscsi_segment_seek_sg(&tcp_conn->in.segment, sdb->table.sgl,
				   sdb->table.nents, ...);
	spin_unlock(&session->back_lock);

The SCSI error handler finishes a task while such a copy is pending, and
it leaves the receive side running on purpose while it does.
iscsi_eh_abort() says so itself:

	/*
	 * we do not stop the recv side because targets have been
	 * good and have never sent us a successful tmf response
	 * then sent more data for the cmd.
	 */

iscsi_eh_device_reset() and iscsi_eh_target_reset() do the same, calling
iscsi_suspend_tx() and not iscsi_suspend_rx() before they fail the tasks.
fail_scsi_task() and fail_scsi_tasks() complete the task the receive path
is copying into, iscsi_free_task() hands the command back with
scsi_done(), and its scatterlist returns to the sg mempool while
tcp_conn->in.segment still points into it.

Looking the command up again before each round of copying would not help.
The error handler can fail the task between the lookup and the copy, and
a lookup cannot tell the command apart from its successor either:
task->itt is the index of a preallocated slot and is fixed for the life
of the session, so the next command to take that slot carries the same
ITT and the same session age, and iscsi_itt_to_ctask() returns it as
running while segment->sg still points into the freed scatterlist.

So let the lock that releases a command also guard the copy into it.
iscsi_tcp_cleanup_task() already runs from iscsi_free_task() with
back_lock held, immediately before the command is handed back, so
remember which command a Data-In is being copied into and drop that
pointer there.  iscsi_tcp_recv_skb() then holds back_lock for the whole
of the copy and refuses the rest of the PDU with ISCSI_ERR_BAD_ITT if the
pointer is gone, as it does one step earlier.  Cleanup and copy now
exclude each other, and a slot cannot be reused before the cleanup that
invalidated the pointer has run.  Only a Data-In pays for this: it is the
only receive segment aimed at a scatterlist, every other one is a linear
buffer that belongs to the connection.

The lock is dropped again before segment->done(), which for a Data-In is
iscsi_tcp_process_data_in() and takes back_lock itself.  Holding it over
the copy is bounded by one skb and adds no sleeping call; the copy maps
its pages with kmap_atomic().  It is taken with _bh because the receive
path is not only a softirq: iscsi_sw_tcp_recv_data_work() runs it from a
work item with softirqs enabled when iscsi_recv_from_iscsi_q is set, and
every process context that takes back_lock in libiscsi takes it that way.

A target that holds part of a Data-In until the command's LUN has been
reset, and then sends the rest, gets the copy to run through the freed
scatterlist and KASAN to report it:

  BUG: KASAN: slab-use-after-free in iscsi_tcp_segment_done+0xe4b/0x1490
  Read of size 4 at addr ffff88800d44cc8c by task swapper/0/0

  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G    B               7.4.0-rc2-00478-ga189f19ef663 #10 PREEMPT(lazy)
  Tainted: [B]=BAD_PAGE
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Call Trace:
   <IRQ>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   kasan_report+0xce/0x100
   iscsi_tcp_segment_done+0xe4b/0x1490
   iscsi_tcp_recv_skb+0x924/0x15f0
   iscsi_sw_tcp_recv+0x12f/0x390
   __tcp_read_sock+0x1ab/0x810
   iscsi_sw_tcp_data_ready+0x18b/0x510
   tcp_data_queue+0x1f2d/0x4b70
   tcp_rcv_established+0x8a8/0x3990
   tcp_v4_do_rcv+0x45b/0x970
   tcp_v4_rcv+0x223d/0x3b90
   ip_protocol_deliver_rcu+0x61/0x2e0
   ip_local_deliver_finish+0x329/0x4b0
   ip_local_deliver+0x18f/0x2d0
   ip_sublist_rcv_finish+0x138/0x1b0
   ip_sublist_rcv+0x3ae/0x670
   ip_list_rcv+0x266/0x380
   __netif_receive_skb_list_core+0x5c3/0x860
   netif_receive_skb_list_internal+0x553/0xbb0
   gro_complete.constprop.0+0x3ed/0x5c0
   dev_gro_receive+0xa31/0x23c0
   gro_receive_skb+0x279/0x960
   e1000_clean_rx_irq+0x602/0x1160
   e1000_clean+0x7eb/0x25a0
   __napi_poll+0x9c/0x520
   net_rx_action+0x8f1/0xfb0
   handle_softirqs+0x1b3/0x600
   __irq_exit_rcu+0xfc/0x160
   common_interrupt+0x7f/0x90
   </IRQ>

  Allocated by task 75:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_slab_alloc+0x6e/0x70
   kmem_cache_alloc_noprof+0x10e/0x340
   mempool_alloc_noprof+0xcd/0x180
   __sg_alloc_table+0x23e/0x410
   sg_alloc_table_chained+0x47/0x180
   scsi_alloc_sgtables+0x17f/0xc50
   sd_init_command+0x20e/0x2e70
   scsi_queue_rq+0x1070/0x2f60
   blk_mq_dispatch_rq_list+0x390/0x2100
   __blk_mq_sched_dispatch_requests+0xa7a/0x1550
   blk_mq_sched_dispatch_requests+0xa7/0x140
   blk_mq_run_work_fn+0x105/0x150
   process_one_work+0x697/0x1060
   worker_thread+0x45b/0xd10
   kthread+0x2c8/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

  Freed by task 130:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kmem_cache_free+0xba/0x3a0
   mempool_free+0xbd/0x110
   __sg_free_table+0xa8/0x170
   scsi_end_request+0x329/0x5d0
   scsi_io_completion+0x4b0/0xda0
   blk_complete_reqs+0xa4/0xe0
   handle_softirqs+0x1b3/0x600
   do_softirq+0x3d/0x60
   __local_bh_enable_ip+0x6a/0x70
   iscsi_eh_device_reset+0x7f1/0xa10
   scsi_ioctl_reset+0x3a8/0x5b0
   scsi_ioctl+0x7ac/0x1360
   blkdev_ioctl+0x385/0x520
   __x64_sys_ioctl+0x134/0x1c0
   do_syscall_64+0xdf/0x4c0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  The buggy address belongs to the object at ffff88800d44cc80
   which belongs to the cache sgpool-16 of size 512
  The buggy address is located 12 bytes inside of
   freed 512-byte region [ffff88800d44cc80, ffff88800d44ce80)

Fixes: da32dd681f7a ("[SCSI] iscsi_tcp: rewrite recv path")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---

Reproduced against a userspace target reached through a proxy that holds
a 64 KiB read's whole Data-In, lets a LUN reset through, and then sends
the header with the first 2048 bytes and the remaining 63488 bytes after
a gap.  A test-only delay parks the receive path for 20 ms once it has
reached the copy, and the reset path waits for that park before it fails
the tasks, so that the command is given back inside the window.  The
receive softirq is kept on one cpu and the reader and the reset on
others.  Every boot is a fresh one, under KASAN.

Measured on top of the series named below.  Without this patch all 3
boots report, 51 reports each, of which 4 name the freed scatterlist and
the rest are the copy writing through it and into the freed data pages.
With it none of 5 do: the reset waits on back_lock until the copy has
finished, the 63488 bytes land in the command's own buffer, and the reset
then fails the command as it asked to.  A 64 KiB read through the same
proxy with the injection turned off is unaffected in both arms.  Ten
32 MiB direct reads, on kernels built without the test delays and without
KASAN, take 1.23 to 1.39 s without the patch and 1.23 to 1.34 s with it,
three boots of three measurements each per arm.

The report above is the first one that names the scatterlist.  The boot's
first report is the same copy writing into a freed data page, which is
also what set the taint.

This is a follow-up to "scsi: libiscsi_tcp: do not accept a Data-In for a
finished command", which refused a Data-In whose command had already gone
but argued that while a copy is pending only the receive path can finish
the task.  The error handler does too, which is what this patch answers.

  https://lore.kernel.org/r/20261117101500.1894608-5-yhlee@isslab.korea.ac.kr

Sashiko raised the same case on that patch:

  https://lore.kernel.org/all/sashiko-outbox-218654@kernel.org/

Applies on its own, and on top of that series, to mkp-scsi/for-next
(08fec21faae4), origin/master (65e4fd942f72) and next/master
(adcad7f4e6332c).

 drivers/scsi/libiscsi_tcp.c | 37 +++++++++++++++++++++++++++++++++++++
 include/scsi/libiscsi_tcp.h |  7 +++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index eeb853c6b66d49..79489793b076d7 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -442,9 +442,17 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
  */
 void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 {
+	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_r2t_info *r2t;
 
+	/*
+	 * Runs under back_lock just before the command is given back, and
+	 * the receive path copies into its scatterlist under the same lock.
+	 */
+	if (tcp_conn->in.datain_task == task)
+		tcp_conn->in.datain_task = NULL;
+
 	/* nothing to do for mgmt */
 	if (!task->sc)
 		return;
@@ -745,6 +753,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 				      tcp_task->data_offset,
 				      tcp_conn->in.datalen);
 			task->last_xfer = jiffies;
+			tcp_conn->in.datain_task = task;
 			rc = iscsi_segment_seek_sg(&tcp_conn->in.segment,
 						   sdb->table.sgl,
 						   sdb->table.nents,
@@ -908,8 +917,10 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_segment *segment = &tcp_conn->in.segment;
+	struct iscsi_session *session = conn->session;
 	struct skb_seq_state seq;
 	unsigned int consumed = 0;
+	bool copy_locked = false;
 	int rc = 0;
 
 	ISCSI_DBG_TCP(conn, "in %d bytes\n", skb->len - offset);
@@ -926,6 +937,26 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 		return 0;
 	}
 
+	/*
+	 * Hold back_lock across a Data-In copy so the command cannot be
+	 * given back while it runs.  _bh: this also runs from a work item.
+	 */
+	if (segment->sg) {
+		struct iscsi_task *task;
+
+		spin_lock_bh(&session->back_lock);
+		task = tcp_conn->in.datain_task;
+		if (!task || task->state != ISCSI_TASK_RUNNING) {
+			spin_unlock_bh(&session->back_lock);
+			iscsi_conn_printk(KERN_ERR, conn,
+					  "Data-In for a command that is gone\n");
+			*status = ISCSI_TCP_CONN_ERR;
+			iscsi_conn_failure(conn, ISCSI_ERR_BAD_ITT);
+			return 0;
+		}
+		copy_locked = true;
+	}
+
 	if (offloaded) {
 		segment->total_copied = segment->total_size;
 		goto segment_done;
@@ -958,6 +989,10 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	}
 
 segment_done:
+	if (copy_locked) {
+		spin_unlock_bh(&session->back_lock);
+		copy_locked = false;
+	}
 	*status = ISCSI_TCP_SEGMENT_DONE;
 	ISCSI_DBG_TCP(conn, "segment done\n");
 	rc = segment->done(tcp_conn, segment);
@@ -970,6 +1005,8 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	/* The done() functions sets up the next segment. */
 
 skb_done:
+	if (copy_locked)
+		spin_unlock_bh(&session->back_lock);
 	conn->rxdata_octets += consumed;
 	return consumed;
 }
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index ef53d4bea28a07..70967bd936e0bd 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -45,6 +45,13 @@ struct iscsi_tcp_recv {
 	struct iscsi_hdr	*hdr;
 	struct iscsi_segment	segment;
 
+	/*
+	 * The command a Data-In is being copied into.  Set when the segment
+	 * is aimed at its scatterlist and cleared when it is given back, both
+	 * with the session back_lock held.
+	 */
+	struct iscsi_task	*datain_task;
+
 	/* Allocate buffer for BHS + AHS */
 	uint32_t		hdr_buf[64];
 
-- 
2.43.0

