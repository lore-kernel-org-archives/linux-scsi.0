Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036519;
	b=V0Q/thyertfx65L4qmp50D2W9/8IxcdOoiprBpEipsg54s803dsfPZ6niXQj2i8+nmZg
	 6g0e3ZzsSstahOBZ21dCNxZv6/kMBNQog3/1fdwNRrW/3wEmCKgJL0Ztjg6oeZJaIKWGL
	 pnGbvuebvW77weiV18rRyg8ZBjbg6kgGTq7Ok430crSPM/hPzpVTeFAUXpYqaYLIYyTud
	 u+QJsFjidgzCMhATYHcqxPvTPsTMEPsAq55w5Tq9dV4c6q9S3OQmniAgwqp5FNWksh89G
	 e8mqoYRcWiEAH4cShmh8la6D3+NeAoYt2x8NatWvh+KAxE8W6JgYDQNmeF5bHTKLlAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15VdoL05IShO2LRiE8I+6q/X77xVipKQFiV0gA1lDh8=;
	b=cbYO6zd82t5nwOKlhls146WqYdbGjGqLOww9FkhLvKI4TuWeerhz5rfkK4ccl0Ny/8Rt
	 rCcOWpN/bwi00iDzF2Oi6NZVsQxf4PNRUVLQdKxB55zLRoWtN7vM80oFlyFuNoL4w4tnW
	 0MuG/cDXCI7VIKBN+asPoCbzUFlj197HKG+h2OV7hFuyWQVAYtEJURGH6IMlgCVt6s6uZ
	 iejYL0T4T6elc2DduLeNU7osSnucWWEKW3/6IACa4LEP6KikLj1snf4jnvxIbG5Nvso7Z
	 FH44R7paDcKy5+8uZOAg+W1cG+XqrSXgPL6oI+rCuWRP0X+TTD3msE4gkFJyF5fVr5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=c1gsnI6r;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937A7606A33A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 21:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 937A7606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=c1gsnI6r
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so908996a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 13:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795036518; x=1795641318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=15VdoL05IShO2LRiE8I+6q/X77xVipKQFiV0gA1lDh8=;
        b=c1gsnI6rI57Vj7Mk18GJz7wc32QvdumEg1uO+wGpv2LUlFW4ByV3WYZL5y+264fizt
         yui7TKOIRLxvHHo1qsXHgBEy9aY2u97TTv0ZJIVzoY8pG0d9lxmQAScfRWWcaFFZz/QT
         7j8LRaQhIjo9rfGJIoIwbxViX66Ltmvxb+4ODCDGg+6FiZSNSYPCF7pkBYBOZA50TZFJ
         6iBfgSXr5SNQaxKA4+5Q3NWiIerj+ro0gNsn1/KvD5bt2CTM9d6Rn6It28df6ZiGvdhw
         Ea6NmFNf7gjgyYFp3kmKxC+SheBaV9agN3kWAiprI3QNl92eEnNe1wh7J3D7nOuF47ak
         Dxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036518; x=1795641318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=15VdoL05IShO2LRiE8I+6q/X77xVipKQFiV0gA1lDh8=;
        b=c6lVExVKN0c4BpHKekgMxJ2P/8IZCEQSeGU25tg9Q6iSH0EMMj+GgZLzDgRaQpNhtc
         yV30IaC7Q0advbb4Oswb2NCojgoGRJKhhRijqDKGorYsWwGwKQGLt134YtzHaaTV/xKX
         Lc3gvILnrMZ8fUScZ3zgzIXy6tzdeFKihVMtketWwY4i8KTxkNYOCPSHtIw3NECcgl1m
         vl3pXIK5XT6z+4epVkYXofdBy/qnMIscJjMVeUCWXmdlDfEe9yI6E2axECywsT2SMvDk
         CW56ntk8ZW64wfCuMV9l9kF46Qr3qBydivB0PFG3dEBhLkbQW97tFFhFviFQZ3a0qt50
         Zu4A==
X-Forwarded-Encrypted: i=1; AL+hErGNTtrx9qkST4BWA25CYjA+i5RID/0s5WGayKQU/zqL0k0M0oNgUS/nVjkPCsWyMEtl0kmyphBCmvt+@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZDqBeB8PKSOL3Tr1j9mR866ml2uZ/pPYa0lFJ0Jhze7mt912L
	1deHDhU4SmpjkGmbFJPTGHSKrJG+/NhR9SP79aBGWsGESFW/SojCa5TJ1hozJbvlVzE=
X-Gm-Gg: AZFdTZfujl+oMjS4PHnXw65W2ar0NcsDuHZsuAiOqZlhU40//kE2DyJD5tkSeCX95uT
	Zx/duQYJ0yQfQAh8+y/GKGT06IfverLd758sRfIRP6KMqdpz3pEqh+BZMCC2EKUFcebD9FVLWAe
	3x6Hu1h3yeboEBUCU7xa9XH1VgxhCPraGNOh0l4RbaGS1qVL3LUnT7Niw0OMQIb9g0XVlpWTadm
	urThTG2+VQMv6daMBHcW/l1/acnMKN3gCGemXjRXBrcw8irSI0bXS4WwWdWbR1c3IFfHXu2dANt
	eNrXjeAsWWDq1ZyJ1doMce76+Yk3J+o3XMi5RjL03lE+TLVKayXo6QZbdBXmBFWXFzB9YVGyQLt
	eXuYWxDjDLbdh4Tn2XBEQ6Xg5USYJJfvm2czikR2tRZ+l+7tKZL7OCh6wGfMIcPrce0fd5gPttE
	OIba34pbm5X6V8/mxlr4b5mgkBOu8+UjkFGuoM+D/XJFTW+OHDwajJTi5TLYqeen0ZmFa8sK4EV
	SKADgoTIruNprFqhMMOknYGFVOmslHUq1aAs5FnkE3Y8p/K5kFU/b6FgibJ+vqpiarDUl6khbbM
	JAamQby9fY+a5+TTF1dM3mD8yux+NKyLYLmAL25RwusM0Lj5GBORk0lB/OvXEOKOvtwKboopJ+E
	XyosRZuIQAn2/Hltj8k8fXk61G9UMWimSLj1U3Q==
X-Received: by 2002:a17:90b:2ccf:b0:3b3:cb22:72d0 with SMTP id 98e67ed59e1d1-3b3d07656e8mr4253797a91.29.1795036517627;
        Wed, 18 Nov 2026 13:15:17 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d5689adasm2611719a91.1.2026.11.18.13.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:15:17 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] scsi: target: iscsi: do not arm the nopin timer on an iSER connection
Date: Thu, 19 Nov 2026 06:15:01 +0900
Message-ID: <20261118211503.2526705-3-yhlee@isslab.korea.ac.kr>
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

iscsi_post_login_start_timers() does not arm the nopin timer for
ISCSI_INFINIBAND, under a FIXME that says unsolicited NOP-In is not
supported there.  It is the only place that looks at the transport, and it
runs once, at login.  Two other sites arm the same timer for a connection
that is already logged in: iscsit_process_nop_out() after a NOP-Out
response, and iscsit_na_nopin_timeout() for every logged-in connection of
an ACL whose nopin_timeout is written from 0 to a non-zero value.

So an iSER connection does get unsolicited NOP-Ins, and iscsit_add_nopin()
builds them from a command of its own.  Writing nopin_timeout 0 and then 3
on the ACL of a logged-in iSER session kills the target on unmodified
mainline: struct isert_cmd is all zero for such a command, and
isert_put_nopin() hands the NULL receive descriptor to isert_post_recv(),
which dereferences it.  That part is a bug in isert and is fixed two
patches on.

  [    7.760642] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000484: 0000 [#1] SMP KASAN NOPTI
  [    7.763622] KASAN: probably user-memory-access in range [0x0000000000002420-0x0000000000002427]
  [    7.765384] CPU: 0 UID: 0 PID: 175 Comm: iscsi_ttx Not tainted 7.4.0-rc2-RJ7A-00716-g23c62304dde2 #15 PREEMPT(lazy)
  [    7.767152] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    7.768831] RIP: 0010:isert_post_recv+0x98/0x210
  [    7.769516] Code: 89 f8 48 c7 44 24 48 00 00 00 00 48 c7 44 24 50 00 00 00 00 48 c1 e8 03 48 c7 44 24 58 00 00 00 00 48 c7 44 24 60 00 00 00 00 <0f> b6 04 10 84 c0 74 06 0f 8e 2c 01 00 00 31 ed 80 be 20 24 00 00
  [    7.771842] RSP: 0018:ffff888104f67c10 EFLAGS: 00010206
  [    7.772484] RAX: 0000000000000484 RBX: 1ffff110209ecf83 RCX: 0000000000000000
  [    7.773332] RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000002420
  [    7.774172] RBP: ffff888104f8c980 R08: 00000000000002bc R09: 0000000000000001
  [    7.775024] R10: ffff888104f26447 R11: 000000005436c6f6 R12: ffff888104af8000
  [    7.775843] R13: ffff888104af8000 R14: ffff888104b55000 R15: ffff888104f8c500
  [    7.776657] FS:  0000000000000000(0000) GS:ffff88816105d000(0000) knlGS:0000000000000000
  [    7.777558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    7.778220] CR2: 00007f221cf10000 CR3: 0000000104e1f005 CR4: 0000000000770ef0
  [    7.779031] PKRU: 55555554
  [    7.779360] Call Trace:
  [    7.779654]  <TASK>
  [    7.779916]  ? __pfx_isert_post_recv+0x10/0x10
  [    7.780460]  isert_post_response+0x85/0x1b0
  [    7.780928]  ? __pfx_isert_post_response+0x10/0x10
  [    7.781455]  ? isert_put_nopin+0xcb/0x3d0
  [    7.781898]  iscsi_target_tx_thread+0x33c/0x6f0
  [    7.782411]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    7.782983]  ? _raw_spin_lock_irq+0x10/0xe0
  [    7.783461]  ? __pfx_autoremove_wake_function+0x10/0x10
  [    7.784043]  ? __pfx_kthread_affine_node+0x10/0x10
  [    7.784574]  ? __kthread_parkme+0x88/0x170
  [    7.785024]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    7.785577]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [    7.786120]  kthread+0x2c8/0x3b0
  [    7.786487]  ? recalc_sigpending+0x15c/0x1e0
  [    7.786980]  ? __pfx_kthread+0x10/0x10
  [    7.787404]  ret_from_fork+0x36e/0x5a0
  [    7.787831]  ? __pfx_ret_from_fork+0x10/0x10
  [    7.788303]  ? __switch_to+0x572/0xdc0
  [    7.788725]  ? __pfx_kthread+0x10/0x10
  [    7.789137]  ret_from_fork_asm+0x1a/0x30
  [    7.789573]  </TASK>
  [    7.789824] Modules linked in:
  [    7.790190] ---[ end trace 0000000000000000 ]---

What cannot be fixed there is the answer.  isert releases a command when
its Send completes - isert_send_done() ends in isert_put_cmd() for every
state it does not special-case - so by the time the initiator's NOP-Out
arrives the NOP-In is no longer on conn->conn_cmd_list, and
iscsit_find_cmd_from_ttt() cannot match it:

  Unable to locate TTT: 0x00000000 on CID: 0
  Did not receive response to NOPIN on CID: 0, failing connection for
  I_T Nexus iqn.2026-07.repro:init,...

The nopin response timer then expires and the connection is reinstated,
once per nopin_timeout, in 5 boots out of 5.  Keeping the command alive
across the Send completion is isert's business and is more than a
dereference fix, so until it is done, make the transport check hold for
the whole life of the connection instead of only at login: move it into
__iscsit_start_nopin_timer(), which all three arming sites go through.

David Jeffery's 2022 series went the other way - it wanted the unsolicited
NOP-In on isert, for a different reason, and did the rest of the work for
it - but it was not applied, and even that series does not cover the
want_response case the nopin timer produces.

Link: https://lore.kernel.org/all/20220311175713.2344960-1-djeffery@redhat.com/
Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/iscsi/iscsi_target_login.c |  5 -----
 drivers/target/iscsi/iscsi_target_util.c  | 10 ++++++++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index c282b6a7029684..08da40534d2e77 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -587,11 +587,6 @@ int iscsi_login_post_auth_non_zero_tsih(
 static void iscsi_post_login_start_timers(struct iscsit_conn *conn)
 {
 	struct iscsit_session *sess = conn->sess;
-	/*
-	 * FIXME: Unsolicited NopIN support for ISER
-	 */
-	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
-		return;
 
 	if (!sess->sess_ops->SessionType)
 		iscsit_start_nopin_timer(conn);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index c1888c42afdd5e..687de3bb611858 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -962,6 +962,16 @@ void __iscsit_start_nopin_timer(struct iscsit_conn *conn)
 
 	lockdep_assert_held(&conn->nopin_timer_lock);
 
+	/*
+	 * FIXME: Unsolicited NopIN support for ISER
+	 *
+	 * iscsit_add_nopin() builds the NOP-In from a command the core
+	 * allocated itself, and isert releases such a command on the send
+	 * completion, so the answer could not be matched back to it.
+	 */
+	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
+		return;
+
 	/*
 	* NOPIN timeout is disabled.
 	 */
-- 
2.43.0

