Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001958;
	b=qJ+ePneKY0p2wLy7KSS7M9bSsMNmWs8OkumofG4VqJUEQ3+/Zwlxa+XrozZaEAFGAUmp
	 2SdbhuEIV8FOrJqsSf8NpWuRqpsqRyfow2t0E+3c9RxkvVgC9kLfX2O8NJaUS8aKW3XEp
	 jTALA+R5DajM1bHKlzzVyRblqa1ntwIIH8Dimf5AL7GJsV0PRg7a9bvT7Qhf4kLI/UZ9A
	 srmStgNTcGmV3P73634r3erIgusbs6/6M+SxuAfHH9la89awIAjLqhVRT3O6fCeluFAfY
	 MexhClt/5X2f9LYl0Xn/goXGXBfNm1shzmr7E0YoM7ggIljvJuPNGNTOlH801uFIjeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001958;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+kdwEfmree7Bsdte7aArB/ykhaO2+XpLvUMQT5Wi2E=;
	b=lCJQKHItjYBPRSKLKFA1U6AohcGe1GTW26q708MB8ekC3KezKFAfIGgYyNinIm+RVwWv
	 L/d4qYekHnNCgHiAJMvLF+D8AFeCxCJ6jJezRcGd0gdjLrawAk/yhdaNJ7xWtpeohE7be
	 9/sqimrGvwvDyNrmRZLgeVKZurn6N2mMUDh9pMJFLtUfi3M8ioI99EzVwM8UBjM3Lh60N
	 pVOmpGAgBhbioCnYkEbb+GGH7XxBwlceGmm9k1R2yHKxpVtKQjxqq+vN8U1FZH6nu3MCK
	 V+xbubFkwcSXeiCVO4mmwPyyptUiLH4DhPvuCG818cNMdbMfzdX/Vh+nrh3fPpwYBmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OOQdVk8n;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28ED606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 11:39:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A28ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OOQdVk8n
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a3c08d6928so1275251c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 03:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795001957; x=1795606757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1+kdwEfmree7Bsdte7aArB/ykhaO2+XpLvUMQT5Wi2E=;
        b=OOQdVk8ns4bemUbO+PkfiXAygXCEjjXd/DUUA8TWYhrPxsVUK1dXfugUpXCo929mMI
         BzuMtmajgrwI/9abfGHVMCpuadlAilciuMpLOg0vYhtqXqM8oRJO7zkAsLf8RtyYzZ/U
         NkGUjaCuN44rOIf8XMILLaJ7KUQchKjJuaPPGyXTwMyqCnZwMiiZlzITdoP5yqwaVDtm
         6jdX8jyGl0d7+7nf9MeLKX1poXLq73hB0y/cvQETfbsL6Lqd9u6YhzAQ6yMhghoVNbYs
         hU6mtB9ySgpUncPqMYLosjHS1D7k8yGRXyR71Ut/kUCXwERCQ3B1W+z+vFQ1yLgbmIbB
         hYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001957; x=1795606757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1+kdwEfmree7Bsdte7aArB/ykhaO2+XpLvUMQT5Wi2E=;
        b=gGf9aYZnFV6yWp5KUulzzOkaA78SU0O7QSnPQPfDFLbY9thO+NGvi8nbVygKvnLrRK
         tljZ+Hb3sqfLk14blAWTsmFhtXXJWg8CAUeoHdiRLnUCAF6GAsrcCFxQJlWbjnrj7EFh
         kG0P4tAqtf9NfcWSnZhXoIAZWjWAww3Or4wh0GvGFcpZRWftsghIb5e2q431hHApZyJv
         eequNvwAl2cZi0xKs2iVQ45nEKb2BQLvy7Y21ysIsAtvurwELl4ZD8tIBsBo/8quQJVf
         9/ZbmgT9mPIzFzrPBhHO7SXn8pKq7wbkZw3OKmAQHqgPJcbvadFiIwsCtnup+HKUlByB
         YBJQ==
X-Forwarded-Encrypted: i=1; AL+hErEHCNq9/XrphMp39nA49TcOLXSh9fyIgYl/CArqfvBIcNOdZZ4+CIf/Eanmzc36MwIe3lHUBAIJEPLx@vger.kernel.org
X-Gm-Message-State: APuU4Z/cFHhCJkx2oORzo2jX5TCIfpn1wDUDHK+IWNauPVkTpPRwyClB
	8IcCwCOn9UyUUr7O9znEEgCfsmQtnaVjvU+sdF+GvjDc1cwFuSWjB6mmO6D7S02gyYw=
X-Gm-Gg: AYBFou3RkaMVIxjPt8StvEFDEeBA/Hvd4jb9K0WdN8Clw1TSyK6A19ukrEGDEwjZHTl
	7O/NIqhwoWM5GVU7gYdsWq7/cA4TvGFWE+2gMbCz9ldR/yqmSg40BWNFgDz4RhIjEEKCAX3u3Dz
	4hSuYUx+R8qcZ1bK8L0FFmiSLiuxCFHRsYdyb0kuDraoS1g7wJjohZxy9O1lKKlOLr6tX3nt33h
	zDS3H3dZxT5Bs+g+qQWRK51qswXOzGuRBhWvLMZWF5vWvvqwVPBVc915E7f95ZFQVD+siSNaTpv
	VSOfcRbuQERc8KsF+ig/Kp5EfpLLtGZQivjcPo61z7Z07h4idFZYcXRjhF7BDiJ+Y7zV/cDhVvG
	6LA+fx7AI712kBFxnYMsc2SDeNAGiR7HxWXM7/eT+F1JVuw7xCQs+an8s9951Jxs6Oq7WkYlbwc
	qb5+Foi8LlyPVEb/muVBj4KczOhmMg71jSbA0HGdXqsyF5rsYVCPPciOUabcZ3RUB+Fdvk0g8+S
	QI4m9JrMqFwUyJ6dZLd8uSdWeCwEVjIv1nu5caWOuT60L9kZsxzteLqeWvvNgDDAS/hZv33SY3g
	r+ntjOfP6zw+nBADBHHnuq/VrZkoSV/nuiAf6++eIlmDGwuEIjOx6xgwsZB38LatRA9xb+nYzSX
	KtssbJaFgvwGYPiSEOdVcHVW6GhttqO/gmjpJqg==
X-Received: by 2002:a05:7023:888:b0:144:c123:4036 with SMTP id a92af1059eb24-1b543d0696emr2400351c88.35.1795001956659;
        Wed, 18 Nov 2026 03:39:16 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5446f954dsm6044662c88.2.2026.11.18.03.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:39:16 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] scsi: target: iscsi: match a NOP-In by opcode as well as by tag
Date: Wed, 18 Nov 2026 20:39:02 +0900
Message-ID: <20261118113905.2361969-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
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

iscsit_find_cmd_from_ttt() returns the first command on the connection
whose targ_xfer_tag matches, whatever kind of command it is.  Its two
callers each want one kind: iscsit_process_nop_out() wants the NOP-In the
target sent, so that a NOP-Out carrying its TTT retires it, and
iscsit_handle_data_ack() wants the SCSI command a Data-In belongs to.

A Reject the target core allocates itself is zeroed by
iscsit_allocate_cmd(), so its targ_xfer_tag is 0, and it is on
conn_cmd_list before it is sent.  A NOP-Out with a reserved ITT and TTT 0
is therefore given that Reject, and iscsit_process_nop_out() queues it
with ISTATE_REMOVE on the immediate queue.  The rx thread does that; the
tx thread is what takes the command off conn_cmd_list and frees it, so a
second such NOP-Out can be given the same command before the tx thread
has got to the first one, and it is freed twice.  Such a command has no
se_cmd, so iscsit_free_cmd() releases it on the spot.

An initiator reaches this over plain iscsi_tcp one PDU after login.
iscsit_check_dataout_hdr() rejects a Data-Out whose DataSegmentLength
exceeds MaxXmitDataSegmentLength without dumping the payload, and
iscsit_handle_data_out() throws away the error it returns, so the receive
loop reads on and takes the next 48 bytes on the wire as the next BHS.
Twenty Data-Out/NOP-Out pairs in one write give 19 or 20 KASAN reports,
in 5 boots out of 5:

  [   10.546883] ==================================================================
  [   10.546895] BUG: KASAN: double-free in iscsit_release_cmd+0xff/0x390
  [   10.546957] Free of addr ffff88800e5d1680 by task iscsi_ttx/140
  [   10.546964]
  [   10.546976] CPU: 0 UID: 0 PID: 140 Comm: iscsi_ttx Not tainted 7.4.0-rc2-RJ9TA-00716-g23c62304dde2 #1 PREEMPT(lazy)
  [   10.546989] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [   10.546997] Call Trace:
  [   10.547002]  <TASK>
  [   10.547008]  dump_stack_lvl+0x66/0xa0
  [   10.547023]  print_report+0xd0/0x630
  [   10.547040]  ? iscsit_release_cmd+0xff/0x390
  [   10.547049]  ? iscsit_release_cmd+0xff/0x390
  [   10.547057]  ? __virt_addr_valid+0x209/0x3f0
  [   10.547071]  ? iscsit_release_cmd+0xff/0x390
  [   10.547079]  ? iscsit_release_cmd+0xff/0x390
  [   10.547087]  kasan_report_invalid_free+0xb8/0xe0
  [   10.547100]  ? iscsit_release_cmd+0xff/0x390
  [   10.547110]  ? iscsit_release_cmd+0xff/0x390
  [   10.547119]  check_slab_allocation+0xd9/0x100
  [   10.547131]  kfree+0x163/0x510
  [   10.547147]  iscsit_release_cmd+0xff/0x390
  [   10.547156]  iscsit_immediate_queue+0x17a/0xa90
  [   10.547167]  ? kmem_cache_free+0x1fe/0x500
  [   10.547176]  ? iscsit_get_cmd_from_immediate_queue+0x189/0x210
  [   10.547187]  iscsi_target_tx_thread+0x34d/0x700
  [   10.547201]  ? __kthread_parkme+0x9f/0x1f0
  [   10.547213]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [   10.547227]  ? __pfx_autoremove_wake_function+0x10/0x10
  [   10.547241]  ? __kthread_parkme+0xac/0x1f0
  [   10.547251]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [   10.547263]  kthread+0x300/0x400
  [   10.547274]  ? __pfx_kthread+0x10/0x10
  [   10.547285]  ret_from_fork+0x52e/0x780
  [   10.547297]  ? __pfx_ret_from_fork+0x10/0x10
  [   10.547307]  ? __switch_to+0x572/0xdd0
  [   10.547321]  ? __pfx_kthread+0x10/0x10
  [   10.547332]  ret_from_fork_asm+0x1a/0x30
  [   10.547352]  </TASK>
  [   10.547357]
  [   10.547359] Allocated by task 141:
  [   10.547366]  kasan_save_stack+0x33/0x60
  [   10.547379]  kasan_save_track+0x14/0x30
  [   10.547388]  __kasan_kmalloc+0x8f/0xa0
  [   10.547397]  __kmalloc_node_track_caller_noprof+0x26d/0x680
  [   10.547409]  kmemdup_noprof+0x20/0x50
  [   10.550518]  iscsit_add_reject+0x99/0x2b0
  [   10.550532]  iscsit_check_dataout_hdr+0x26d/0x360
  [   10.550542]  iscsit_get_rx_pdu+0x5da/0x35d0
  [   10.550552]  iscsi_target_rx_thread+0x132/0x2f0
  [   10.550563]  kthread+0x300/0x400
  [   10.550573]  ret_from_fork+0x52e/0x780
  [   10.550582]  ret_from_fork_asm+0x1a/0x30
  [   10.550593]
  [   10.550596] Freed by task 140:
  [   10.550603]  kasan_save_stack+0x33/0x60
  [   10.550615]  kasan_save_track+0x14/0x30
  [   10.550623]  kasan_save_free_info+0x3b/0x60
  [   10.550631]  __kasan_slab_free+0x43/0x70
  [   10.550640]  kfree+0x2e5/0x510
  [   10.550651]  iscsit_release_cmd+0xff/0x390
  [   10.550659]  iscsit_immediate_queue+0x17a/0xa90
  [   10.550669]  iscsi_target_tx_thread+0x34d/0x700
  [   10.550679]  kthread+0x300/0x400
  [   10.550688]  ret_from_fork+0x52e/0x780
  [   10.550696]  ret_from_fork_asm+0x1a/0x30
  [   10.550706]
  [   10.550710] The buggy address belongs to the object at ffff88800e5d1680
  [   10.550710]  which belongs to the cache kmalloc-64 of size 64
  [   10.550719] The buggy address is located 0 bytes inside of
  [   10.550719]  64-byte region [ffff88800e5d1680, ffff88800e5d16c0)
  [   10.550729]
  [   10.550734] The buggy address belongs to the physical page:
  [   10.550743] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xe5d1
  [   10.550753] flags: 0x100000000000000(node=0|zone=1)
  [   10.550763] page_type: f5(slab)
  [   10.550776] raw: 0100000000000000 ffff888008c428c0 dead000000000100 dead000000000122
  [   10.550785] raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
  [   10.550790] page dumped because: kasan: bad access detected
  [   10.550794]
  [   10.550796] Memory state around the buggy address:
  [   10.550801]  ffff88800e5d1580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
  [   10.550808]  ffff88800e5d1600: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
  [   10.550813] >ffff88800e5d1680: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  [   10.550818]                    ^
  [   10.550823]  ffff88800e5d1700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  [   10.550829]  ffff88800e5d1780: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  [   10.550834] ==================================================================

The same shape was reported in 2015 and fixed by taking one holder of
TTT 0 away rather than by looking at the kind of command.  A Test Unit
Ready left at TTT 0 was being matched to the session's first NOP-In and
queued for removal twice, so every non-READ SCSI command was given
0xFFFFFFFF instead:
commit 9547308bda29 ("target/iscsi: Fix double free of a TUR followed by a solicited NOPOUT").
The Reject and the first READ of a session still carry TTT 0.

Pass the opcode the caller is after and compare it too.  The test belongs
in the loop rather than at the caller: at the caller, a Reject or a first
READ standing earlier on conn_cmd_list would mask a NOP-In holding the
same TTT, and its answer would be dropped.

Link: https://lore.kernel.org/all/1437516477-30554-4-git-send-email-sbaugh@catern.com/
Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/iscsi/iscsi_target.c      | 3 ++-
 drivers/target/iscsi/iscsi_target_erl1.c | 2 +-
 drivers/target/iscsi/iscsi_target_util.c | 6 ++++--
 drivers/target/iscsi/iscsi_target_util.h | 4 +++-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e759..2762a60ec3b33d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1821,7 +1821,8 @@ int iscsit_process_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	 * This was a response to a unsolicited NOPIN ping.
 	 */
 	if (hdr->ttt != cpu_to_be32(0xFFFFFFFF)) {
-		cmd_p = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
+		cmd_p = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt),
+						 ISCSI_OP_NOOP_IN);
 		if (!cmd_p)
 			return -EINVAL;
 
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index d8ca06e697d63f..74dc218716f2ad 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -536,7 +536,7 @@ int iscsit_handle_data_ack(
 {
 	struct iscsit_cmd *cmd = NULL;
 
-	cmd = iscsit_find_cmd_from_ttt(conn, targ_xfer_tag);
+	cmd = iscsit_find_cmd_from_ttt(conn, targ_xfer_tag, ISCSI_OP_SCSI_CMD);
 	if (!cmd) {
 		pr_err("Data ACK SNACK for TTT: 0x%08x is"
 			" invalid.\n", targ_xfer_tag);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index c1888c42afdd5e..9ee1b5fcf5059f 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -383,13 +383,15 @@ EXPORT_SYMBOL(iscsit_find_cmd_from_itt_or_dump);
 
 struct iscsit_cmd *iscsit_find_cmd_from_ttt(
 	struct iscsit_conn *conn,
-	u32 targ_xfer_tag)
+	u32 targ_xfer_tag,
+	u8 iscsi_opcode)
 {
 	struct iscsit_cmd *cmd = NULL;
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
-		if (cmd->targ_xfer_tag == targ_xfer_tag) {
+		if (cmd->iscsi_opcode == iscsi_opcode &&
+		    cmd->targ_xfer_tag == targ_xfer_tag) {
 			spin_unlock_bh(&conn->cmd_lock);
 			return cmd;
 		}
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 7ae48a8a5cbf0b..56487d15ed80d4 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -25,7 +25,9 @@ extern int iscsit_sequence_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			       unsigned char * ,__be32 cmdsn);
 extern struct iscsit_cmd *iscsit_find_cmd_from_itt_or_dump(struct iscsit_conn *,
 			itt_t, u32);
-extern struct iscsit_cmd *iscsit_find_cmd_from_ttt(struct iscsit_conn *, u32);
+extern struct iscsit_cmd *iscsit_find_cmd_from_ttt(struct iscsit_conn *conn,
+						   u32 targ_xfer_tag,
+						   u8 iscsi_opcode);
 extern int iscsit_find_cmd_for_recovery(struct iscsit_session *, struct iscsit_cmd **,
 			struct iscsi_conn_recovery **, itt_t);
 extern void iscsit_add_cmd_to_immediate_queue(struct iscsit_cmd *, struct iscsit_conn *, u8);
-- 
2.43.0

