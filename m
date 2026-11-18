Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036522;
	b=Q6IGkb6eM3ePpkhXtAhWRGBnOvi2tFZu9fRRU5S+lXJh+p4rhK4noT4wpkzNqyqsHaIs
	 SFVk0i2mCvbhsXmUFE5A7vGuSzHGfZgmD5Gs/9bbICKeqhYnPo4U8z7Jtd0qNvksak22t
	 20NDlz9OXM533srwRwiTcaTT6JxwO/GD5pciv++WI50jWC3Z1Qqyr+xqfZjQ4OVFWWiI1
	 X55xPsDB2qLD27/fpOsDy41NRuRkr2vYXlsbnaCCZIDaItWrF7N0eCAvIdMaXaOC8ORYa
	 ZAm6qn6k2SLwsyT+jNWt6kEcDLBp/6rBdcSTS1aKr4nqbs9vd/mNx0J6QT9cGJBpHmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036522;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35MopraF3C+XS9oIkKzwdK1L6EY4ZqyO/LOySOhAuGw=;
	b=qzBN3/jTL1U/YM6hAFpZDrdUV88iqi/JNnBUuyfqZ4CN8TVNZOX/j0wzMGldhUVSNXli
	 I7ou5+F1g6EhdaswUXeVqF+dQAc3ae/pLpKgpNS6R7kn3eaBOSq9eZxi2tiS+siH/JDBg
	 refElM/+Me6AmFAfX4JePLxcg9320jPL9ujIkwie+WD/W5jTpXxX7Q6WxJyS3j8KWg5me
	 rAsUnNThR52XzRRs27Rd3F6ymF7bCSmdUhb4eX7FKEEJNQlfEcwY2u5Ok+vAf4q48ZpL3
	 mFwV1vUx/aiWlpH40V5kswbGXIRAJ6BUxEeEbvvgDrOtsy4S8OuU7fmgTfb0HlYJcVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="P/+xaXkp";
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F6F60A2617
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 21:15:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41F6F60A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=P/+xaXkp
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b3fb193c03so61553a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 13:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795036520; x=1795641320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=35MopraF3C+XS9oIkKzwdK1L6EY4ZqyO/LOySOhAuGw=;
        b=P/+xaXkp9pckOlHvDvygWEt3vRNwV+QRhUqvK0VlWTe6WHKaACdxvKlUvQOCfJqblJ
         mdqHUOR3nfIg3m2ZhYqVIy4PEQiZAqXKncOTZ56XvF6vc2QG1j+YYk2d71fqdpByGfcc
         RhB9xfFOxSJOcgsz1vJ/+tnrq3LEHtW31sdLRVqTjf5+wjq0TRUXlq5jyfD1JoaQVbhu
         uHA4PwbUTXVp10/iYcB0vd/+txY2jyKuL9kp9/JztqO6XtmGt4sAy6PVQpy9yE8RAK0S
         wVNOeINZKtc7oBUL0P+EHmvoMmPqVZiYYie1O98L6lgYku1PuEkPGA/80kW8bo4THwb8
         iGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036520; x=1795641320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=35MopraF3C+XS9oIkKzwdK1L6EY4ZqyO/LOySOhAuGw=;
        b=l9RmmURYPiGTgFuWtFcfPXlXjNopL7LMLzWFfR579rBp2H87POzi8shNt+X7kbCVSb
         kAwKXPCo+hntJNSPdbQRKc1IBJymYKoL4dbDrE4oG38fr+OvoYkzUmFIzRmXK479h9gn
         udaezdkkmaHitVU5URPx8oXYLWGh5HuZlEdk2keQbzt6U5EgunohPdFRjE5Qrdip2DEv
         qndtbj7PkNsgpG1865rA3Mg6sxx9WXEmPVwTGTE4LbUadkSf4pVKDP1Gtov4m3h7qWvr
         F/f7OiagY+/ecsEnNlJwq5K7AJ26pJsCCt87sFGQiQiu1T5aV/MV3nQLyrJW0fio3Uuu
         ueYQ==
X-Forwarded-Encrypted: i=1; AL+hErFDRV5FbYvHSFNWDgKG9lfNlFnKPy77C1JM3nMdm0DWXFFN5/7H7l8a7rkhnTua8jrWu2//3KeiGWBo@vger.kernel.org
X-Gm-Message-State: APuU4Z+IbK5xQauzf6QjIdiJbkjXnxHO732j7gmN/bllDKvm44wAcdLE
	MbflxbRWuygDxCOF5JRK+drekEsBv7olA/vytf18kZcLcCLsT6XQvA4InLUQWmyix2o=
X-Gm-Gg: AZFdTZdgYKRxXzsqzAAp+gSiAwl348KyxIS8/K9/Q9RXEAePqxCHFR6lIrq9JaNeAXt
	c48btzLl5bug6CJQzLfyxxwYhOAfbR2upwYf1xfod2QlN/AZ/a6hdhvbh/OeSWIBeri7UfNwNCt
	DGg5Sz+t6pyV1M4VViKMdFVm0fqEI3KWC23fWi7YVE2Mh9qV7l/bX7kgFp6kOvUELnuTjR/Bv8q
	j1vHLwvWB2Hc5L/oneVh0mVEPVap/Fnl/cUBhVocYjjbhHB53QUyWKH9KxLj3+UwEHzeY8xw02T
	BZfeEk196BTptYVYHxfk12yLRNt+KEmRuFF5crAgWSDkpYd4aI0qD+DUJz38h7TJWolo1S/CWZE
	IBNbLH5NVibPZye5EtXJpUgkH+x2NioffAfZgx6n5PgHpCmgK2Wu9f6H5Wm5ASywTyNl9UW+kCh
	ykna01p9a2K3L1gYIp/Vd7gbZ58TyFyULR7QlZNdWnhlwh4uur/Xvlc+MZA393DAC374Jmjyxux
	QCOFguoW++Xvc82453SsTXiaVHBwduzmp48Rr/RRzWy6eJvO6wdkHt4pJh7yuNCaDY4cX5oU8wV
	cAeYKY/uQlgH6XdKo6AJbhGg404I6kbkwZGNzMi9t1vQMSN2jYf3ICdSyW8z7rtpqDFY1elzp30
	4li29CaQzfQMRCcRccC9x6FcNnehrLC1X0bV8UQ==
X-Received: by 2002:a17:90b:1dcb:b0:3b3:af8e:ea98 with SMTP id 98e67ed59e1d1-3b3d07d3d1cmr3327654a91.37.1795036520552;
        Wed, 18 Nov 2026 13:15:20 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d5689adasm2611719a91.1.2026.11.18.13.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:15:20 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] IB/isert: finish a Reject the target core allocated itself
Date: Thu, 19 Nov 2026 06:15:02 +0900
Message-ID: <20261118211503.2526705-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
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

iscsit_add_reject() builds the Reject from a command of its own, with
iscsit_allocate_cmd(), and iscsit_allocate_cmd() zeroes sizeof(struct
iscsit_cmd) plus the transport's priv_size.  For iSER that zeroes struct
isert_cmd too, so conn, iscsit_cmd and rx_desc are all NULL where
isert_allocate_cmd() would have filled them in.  The command then reaches
the tx thread like any other, and two things go wrong with it.

isert_put_reject() hands the NULL descriptor to isert_post_recv(), which
dereferences it.  One PDU after login is enough:
iscsit_check_dataout_hdr() answers a Data-Out whose DataSegmentLength
exceeds conn_ops->MaxXmitDataSegmentLength that way, and it does so
before it looks the ITT up, so there is no SCSI command involved.  With
TargetRecvDataSegmentLength negotiated down to 512 and one Data-Out
declaring and carrying 1024 bytes, 5 boots out of 5:

  [    3.657391] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000484: 0000 [#1] SMP KASAN NOPTI
  [    3.660192] KASAN: probably user-memory-access in range [0x0000000000002420-0x0000000000002427]
  [    3.661302] CPU: 0 UID: 0 PID: 168 Comm: iscsi_ttx Not tainted 7.4.0-rc2-RJ7A-00716-g23c62304dde2 #15 PREEMPT(lazy)
  [    3.662601] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    3.664015] RIP: 0010:isert_post_recv+0x98/0x210
  [    3.664623] Code: 89 f8 48 c7 44 24 48 00 00 00 00 48 c7 44 24 50 00 00 00 00 48 c1 e8 03 48 c7 44 24 58 00 00 00 00 48 c7 44 24 60 00 00 00 00 <0f> b6 04 10 84 c0 74 06 0f 8e 2c 01 00 00 31 ed 80 be 20 24 00 00
  [    3.666840] RSP: 0018:ffff888109437c10 EFLAGS: 00010206
  [    3.667470] RAX: 0000000000000484 RBX: 1ffff11021286f83 RCX: 0000000000000001
  [    3.668323] RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000002420
  [    3.669134] RBP: ffff888109440480 R08: 00000000000002ac R09: 0000000000000001
  [    3.669943] R10: ffff888104f99447 R11: 00000000a4c8e811 R12: ffff888109404000
  [    3.670752] R13: ffff888109404000 R14: ffff888104d8e000 R15: ffff888109440000
  [    3.671552] FS:  0000000000000000(0000) GS:ffff88817605d000(0000) knlGS:0000000000000000
  [    3.672458] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    3.673086] CR2: 00007fe324237000 CR3: 0000000104f45002 CR4: 0000000000770ef0
  [    3.673857] PKRU: 55555554
  [    3.674160] Call Trace:
  [    3.674442]  <TASK>
  [    3.674686]  ? __pfx_isert_post_recv+0x10/0x10
  [    3.675178]  isert_post_response+0x85/0x1b0
  [    3.675632]  ? __pfx_isert_post_response+0x10/0x10
  [    3.676163]  ? isert_response_queue+0x91d/0x19a0
  [    3.676664]  iscsi_target_tx_thread+0x3de/0x6f0
  [    3.677163]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.677694]  ? _raw_spin_lock_irq+0x10/0xe0
  [    3.678155]  ? __pfx_autoremove_wake_function+0x10/0x10
  [    3.678697]  ? __pfx_kthread_affine_node+0x10/0x10
  [    3.679195]  ? __kthread_parkme+0x88/0x170
  [    3.679617]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.680142]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.680663]  kthread+0x2c8/0x3b0
  [    3.681011]  ? recalc_sigpending+0x15c/0x1e0
  [    3.681457]  ? __pfx_kthread+0x10/0x10
  [    3.681851]  ret_from_fork+0x36e/0x5a0
  [    3.682244]  ? __pfx_ret_from_fork+0x10/0x10
  [    3.682687]  ? __switch_to+0x572/0xdc0
  [    3.683085]  ? __pfx_kthread+0x10/0x10
  [    3.683481]  ret_from_fork_asm+0x1a/0x30
  [    3.683900]  </TASK>
  [    3.684139] Modules linked in:
  [    3.684552] ---[ end trace 0000000000000000 ]---

The tx thread dies there, and the teardown that follows walks into the
connection it was using: a KASAN slab-use-after-free in do_send_sig_info()
from iscsit_cause_connection_reinstatement(), a refcount warning in
iscsit_close_connection() and a second Oops in kthread_stop().

The Reject also stays on conn->conn_cmd_list until it is sent, so the core
can hand it to isert_immediate_queue() with ISTATE_REMOVE instead, where
isert_put_cmd() reads isert_cmd->iscsit_cmd and isert_cmd->conn and finds
the same two NULL pointers.  Before the first patch of this series that
happened on these very two PDUs, because a NOP-Out with a reserved ITT and
TTT 0 matched the Reject on its tag alone.

So fill the two back pointers in where the core hands a command over -
isert_immediate_queue() and isert_response_queue(), which covers every
state including ISTATE_REMOVE - and let isert_post_recv() accept a
command that has no receive descriptor, beside the already-reposted case
it tolerates today.  For a command isert allocated the stores write back
what isert_allocate_cmd() already put there; rx_desc is not touched, so a
command that owns a descriptor keeps it.  isert_put_cmd()'s
ISCSI_OP_REJECT arm is already written for a command whose se_cmd was
never set up - it releases one through iscsit_release_cmd() - it was
simply never reached.

The unsolicited NOP-In is the same shape, from iscsit_add_nopin(), and is
kept off iSER by the previous patch.

Filling the back pointers in for a command that did not come through
isert_allocate_cmd() is David Jeffery's idea, from a 2022 series that was
not applied; it did it in isert_put_nopin().

Link: https://lore.kernel.org/all/20220311175713.2344960-2-djeffery@redhat.com/
Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index efa8d7b7844c97..b7dcfc5f88b916 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -758,7 +758,8 @@ isert_post_recv(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc)
 	struct ib_recv_wr rx_wr;
 	int ret;
 
-	if (!rx_desc->in_use) {
+	/* A command the target core allocated itself has no descriptor. */
+	if (!rx_desc || !rx_desc->in_use) {
 		/*
 		 * if the descriptor is not in-use we already reposted it
 		 * for recv, so just silently return
@@ -1028,6 +1029,18 @@ isert_rx_login_req(struct isert_conn *isert_conn)
 	queue_delayed_work(isert_login_wq, &conn->login_work, 0);
 }
 
+/*
+ * A command the target core allocated itself does not come through
+ * isert_allocate_cmd(), so the tx path has to fill these in.
+ */
+static void
+isert_init_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn,
+	       struct iscsit_cmd *cmd)
+{
+	isert_cmd->conn = isert_conn;
+	isert_cmd->iscsit_cmd = cmd;
+}
+
 static struct iscsit_cmd
 *isert_allocate_cmd(struct iscsit_conn *conn, struct iser_rx_desc *rx_desc)
 {
@@ -1041,8 +1054,7 @@ static struct iscsit_cmd
 		return NULL;
 	}
 	isert_cmd = iscsit_priv_cmd(cmd);
-	isert_cmd->conn = isert_conn;
-	isert_cmd->iscsit_cmd = cmd;
+	isert_init_cmd(isert_cmd, isert_conn, cmd);
 	isert_cmd->rx_desc = rx_desc;
 
 	return cmd;
@@ -2201,6 +2213,8 @@ isert_immediate_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int stat
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	int ret = 0;
 
+	isert_init_cmd(isert_cmd, conn->context, cmd);
+
 	switch (state) {
 	case ISTATE_REMOVE:
 		spin_lock_bh(&conn->cmd_lock);
@@ -2226,6 +2240,8 @@ isert_response_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int state
 	struct isert_conn *isert_conn = conn->context;
 	int ret;
 
+	isert_init_cmd(iscsit_priv_cmd(cmd), isert_conn, cmd);
+
 	switch (state) {
 	case ISTATE_SEND_LOGOUTRSP:
 		ret = isert_put_logout_rsp(cmd, conn);
-- 
2.43.0

