Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794823879;
	b=Rk2AJkn4RdrARMH4+QsXM46OGxIAP7dS/ChSOOWQ2ni/asGH6O6vn9oHs/f8gW5jLkLK
	 QeeA++7z1AeFlAR8MWvNBh9SbXOwdNAVRMBNDcE77efuEs9AuAo9uASw/0mg1yE00hoS9
	 nY4H33nOvPB57iX/Oe0lvv7V/aKeeeObPF83Q+TuOcjwG9YSTlKHsg/7zo4jRvEDL1Rke
	 xRVJlb4TrlkNMVi0G1+Uzo5ZlJn12GCbkVxbUATK1bwV49AsCJ31hKpTvEhucZ3TSLQDX
	 HRQ0t3VpzZ+dbEQQ5ifRlZ3erPmwv0cIkNawtY5vYRRWC9nwNEfj7yjv2UNKOY3HbVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794823879;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QE03JjsA5wc1tp/JULiyA+UuuhZYB+y5OpcGtEQNS4k=;
	b=QHWYJKH9MZS0JLr4AZ8U1ByCe2CrEocktmM2Q0Sw3C8PP6Jxx/bdeHzddg6iyUqg4DhC
	 DE+7GrjH6OPJf5hsyUmfSStYzT+wXhFUacgNkRKyYOlNh547oYRj2C2oLmqjmv7yo2jJ7
	 5MEZfhAxxU7Hz/mlYLRee5yM91o0wd0Wu+UmyeNyl22potetOXSYPdSRpOChPGRSWAgpS
	 0iP0GdomcCil8zUjrZHtfDJ54twAjioxTB/VS7dOuFakh3f22GnSvDcqKOvBEvOGvIsY2
	 VU6nM3hUksl9l7pcqCOG49CC7Hgc/jfxHcW9Px7OCd17ceGWdeE1iqzOufK7i6SRVZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ewrIJd5I;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40105606A32F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 10:11:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40105606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ewrIJd5I
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ee2072d1e7so8095775ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 02:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794823877; x=1795428677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QE03JjsA5wc1tp/JULiyA+UuuhZYB+y5OpcGtEQNS4k=;
        b=ewrIJd5IOV5QAQjwRH6IEXZnmh7bPfUHn9DUcx2zsC6hdbrlWH9yEYyPEohe8mFv9/
         U/2kPd4Z2bA8U/czFRK4f+sZXTwhKmdIdnpunjcGZA1X2fohpnIdXYkY9hudUeBHFqQY
         6wQebEg6oAtUFeOIKXmzo6c5Chqt/ZK8ptolYOVVIitHpt1BozjzMtdNjCZ3HO2kaGPL
         rZy/pADqnrF7sv/VuhpiLXeO+dB21LxNcIr6fzeXVbUT0uqNUXPkQFOQk+Bd9+Bxpu1H
         hswdaGudvlrj8/5fvFBgfXgyDBqtnsv1WBh6HaFaYnzk4R2P1olTTU5rDe7WHILUai8Z
         aygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794823877; x=1795428677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QE03JjsA5wc1tp/JULiyA+UuuhZYB+y5OpcGtEQNS4k=;
        b=R0J4OXVZrWVjbRxNiBtPukAOaIK0Cp+FDKPjqpD0z0OPC5yF/8w2Wo+rTkrenuTUlE
         4klJwJ2Hiv5j96SImIf0dCGFGwVY6rrop4tINh7LZW50ET6i2AHZqM/q23zf4DyzKM7u
         lddVdt1XT9sY8FLhhYg0yFhvmeWYjIGHVdUADU5oqHhzUFwO0SlolQPYikw4oF35onk1
         vDJWbexmPgMioJYnw5lEueHW90rVm1LWkFChzpK2JWE+6nUaPkDOdKAJyHXICGyOel1W
         d90lL6OPLt5AhYHQ0hM6QGFUblU17dzMQCnnjRW8/xX1uD8m6bOKpczML7NWW0cnztUM
         H+pw==
X-Forwarded-Encrypted: i=1; AL+hErEI4XowM3FWD6xBTMPeVN1TRZ8WyvnJ6VeEylqhktaTYkUQjFlOQgA/zkgSRjltjR9YYmBGjFG7h03K@vger.kernel.org
X-Gm-Message-State: APuU4Z+CDYIuOOoLT1AFqS+NZBMcKEodYpmEEI0C9NRlGFXqn1GNCcIm
	nVkqgqYO5RXAkzg2EaW2mU/ueBDjcZZI9oRDrMfM1pczM2jTbcdBTXlleCu3tSh9a0dU8W/Xox+
	r7dTiCvs=
X-Gm-Gg: AZFdTZe8VHGo80U1BrzBDKA/1mxvVAybBqyeuR4nMmcDZ0eTnIasRTNFg9Ip4KCqQln
	/9U+72hCqTdpWQ8hz86S0rDL2Pai6ba9P2gGehJ+pCk50kbAwWMWw4W/mKTKqRe4w909ADVSDow
	6ORYCMkMnc3ROPeasYUzCnlozwIpDLOL1DT5iT6WT8EloKXM5X4dTdDFZkNlU03qjF9/WHFP0FZ
	vGfbfRurYsZ9sGH8WeSsFt4nE/FW4xQmfk1VJAeBUEssmLseQ1X0qOlRPYPUjVkJQ5xaKkDlWaq
	pdyRloaPDxIbMJmYgiVrtbLx3daOdp97926Pul12sHJ580IP6Ccf7BVGd4fDIom5M9FokyilmPU
	yh8BVa5Hk1lH7FWRJoewdj9NiiJB3HL2ZcSyHKRQH17LRQ0Aj/CORX+ih3sn7+7btBmNTvIpYiF
	2zy8vOoWtPuDgduZbDKepNqP5wmKsJqhknp0cnfoEJmdJb/PiEIimt6ShYTsYNVHjJcfVLDAnVl
	XE/WHyPbiUoMuLykr5z6GsmD3aDLX6L6JnjXLo+EMEh78o/XpM4NRo9slsaTQeujC1MWatrnes9
	IhUTI3FMlfN6jFuyK5F/KvQphmoS9ik2l3vCXILx/JByYRNp9nLqtksku2IoIxvMw3F29v3R2bm
	AcPJ04b4I3vEjafTsA1GllcFW5oaDt9lpR2ttAQ==
X-Received: by 2002:a17:903:3c6d:b0:2eb:3522:99f9 with SMTP id d9443c01a7336-2ee0da7bf19mr92720105ad.17.1794823877256;
        Mon, 16 Nov 2026 02:11:17 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7e5055sm35533795ad.39.2026.11.16.02.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:11:16 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] IB/isert: finish a Reject the target core allocated itself
Date: Mon, 16 Nov 2026 19:11:07 +0900
Message-ID: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
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

iscsit_add_reject() builds the Reject from a command of its own, with
iscsit_allocate_cmd(), and iscsit_allocate_cmd() zeroes sizeof(struct
iscsit_cmd) plus the transport's priv_size.  For iSER that zeroes struct
isert_cmd too, so conn, iscsit_cmd and rx_desc are all NULL where
isert_allocate_cmd() would have filled them in.  The target's tx thread
then takes that command through isert_response_queue() ->
isert_put_reject() -> isert_post_response(), which hands the NULL
descriptor to isert_post_recv() and dereferences it.

One PDU after login is enough.  iscsit_check_dataout_hdr() answers a
Data-Out whose DataSegmentLength exceeds
conn_ops->MaxXmitDataSegmentLength with iscsit_add_reject(), and it does
so before it looks the ITT up, so there is no SCSI command involved.
Against a LIO target with an iSER portal over soft-RoCE, with
TargetRecvDataSegmentLength negotiated down to 512 and one Data-Out
declaring and carrying 1024 bytes, 5 boots out of 5:

  [    3.750347] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000484: 0000 [#1] SMP KASAN NOPTI
  [    3.752656] KASAN: probably user-memory-access in range [0x0000000000002420-0x0000000000002427]
  [    3.753703] CPU: 0 UID: 0 PID: 168 Comm: iscsi_ttx Not tainted 7.4.0-rc2-RJ6A-00716-g23c62304dde2 #1 PREEMPT(lazy)
  [    3.755172] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    3.756829] RIP: 0010:isert_post_recv+0x98/0x210
  [    3.757519] Code: 89 f8 48 c7 44 24 48 00 00 00 00 48 c7 44 24 50 00 00 00 00 48 c1 e8 03 48 c7 44 24 58 00 00 00 00 48 c7 44 24 60 00 00 00 00 <0f> b6 04 10 84 c0 74 06 0f 8e 2c 01 00 00 31 ed 80 be 20 24 00 00
  [    3.759855] RSP: 0018:ffff888104ecfc10 EFLAGS: 00010206
  [    3.760580] RAX: 0000000000000484 RBX: 1ffff110209d9f83 RCX: 0000000000000001
  [    3.761476] RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000002420
  [    3.762376] RBP: ffff888109625380 R08: 000000000000029d R09: 0000000000000001
  [    3.763288] R10: ffff888104d95447 R11: 00000000eb6dcbe3 R12: ffff888104af8000
  [    3.764184] R13: ffff888104af8000 R14: ffff888104b4f000 R15: ffff888109624f00
  [    3.765076] FS:  0000000000000000(0000) GS:ffff88816b45d000(0000) knlGS:0000000000000000
  [    3.766100] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    3.766830] CR2: 00007f5dc1281000 CR3: 0000000104baf004 CR4: 0000000000770ef0
  [    3.767739] PKRU: 55555554
  [    3.768091] Call Trace:
  [    3.768407]  <TASK>
  [    3.768679]  ? __pfx_isert_post_recv+0x10/0x10
  [    3.769233]  isert_post_response+0x85/0x1b0
  [    3.769745]  ? __pfx_isert_post_response+0x10/0x10
  [    3.770338]  ? isert_response_queue+0x91d/0x19a0
  [    3.770898]  iscsi_target_tx_thread+0x3de/0x6f0
  [    3.771460]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.772062]  ? _raw_spin_lock_irq+0x10/0xe0
  [    3.772546]  ? __pfx_autoremove_wake_function+0x10/0x10
  [    3.773148]  ? __pfx_kthread_affine_node+0x10/0x10
  [    3.773714]  ? __kthread_parkme+0x88/0x170
  [    3.774196]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.774775]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    3.775352]  kthread+0x2c8/0x3b0
  [    3.775733]  ? recalc_sigpending+0x15c/0x1e0
  [    3.776236]  ? __pfx_kthread+0x10/0x10
  [    3.776671]  ret_from_fork+0x36e/0x5a0
  [    3.777109]  ? __pfx_ret_from_fork+0x10/0x10
  [    3.777604]  ? __switch_to+0x572/0xdc0
  [    3.778041]  ? __pfx_kthread+0x10/0x10
  [    3.778482]  ret_from_fork_asm+0x1a/0x30
  [    3.778937]  </TASK>
  [    3.779201] Modules linked in:
  [    3.779592] ---[ end trace 0000000000000000 ]---

The tx thread dies there, and the teardown that follows walks into the
connection it was using: a KASAN slab-use-after-free in do_send_sig_info()
from iscsit_cause_connection_reinstatement(), a refcount warning in
iscsit_close_connection() and a second Oops in kthread_stop().

So let isert_post_recv() accept a command that has no descriptor, beside
the already-reposted case it tolerates today, and fill in the two
back-pointers the completion path needs, which isert_put_cmd() is
already written for - its ISCSI_OP_REJECT arm releases a command whose
se_cmd was never set up.

The unsolicited NOP-In is the same shape and is already kept away from
iSER: iscsit_add_nopin() allocates its command the same way, and
iscsi_post_login_start_timers() does not arm that timer for
ISCSI_INFINIBAND.

Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index efa8d7b7844c97..81164881dcc241 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -758,7 +758,8 @@ isert_post_recv(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc)
 	struct ib_recv_wr rx_wr;
 	int ret;
 
-	if (!rx_desc->in_use) {
+	/* A command iscsit_add_reject() allocated has no descriptor. */
+	if (!rx_desc || !rx_desc->in_use) {
 		/*
 		 * if the descriptor is not in-use we already reposted it
 		 * for recv, so just silently return
@@ -1958,6 +1959,9 @@ isert_put_reject(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 	struct iscsi_reject *hdr =
 		(struct iscsi_reject *)&isert_cmd->tx_desc.iscsi_header;
 
+	isert_cmd->conn = isert_conn;
+	isert_cmd->iscsit_cmd = cmd;
+
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
 	iscsit_build_reject(cmd, conn, hdr);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
-- 
2.43.0

