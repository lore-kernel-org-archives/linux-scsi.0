Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216546;
	b=Hkr1aLfjhCOnwBEG84AG7nG24Ns9kD0cOQncQuw4HXTuTPQ/Hb5JxgX/Rql8iVDT7xkf
	 a/V8v2+L2zOhyk58sKn0t7p8IM3OPuFrT8XKf6hVgCkcBiDnFWrPTeGRCbg7HazVxbBtK
	 quVsSyA1cELxwqD3U2nNn5fbGncX9/JgP1Pc5ZAkRnpEy/bPXJmiQIdZNgRhNHIglX1C1
	 4lRfSGV1RP1JWFrenEmvKrP4n7L6+Us3/dZff5qVu+4Kn7ba/aiXgv+qeFxEUkNQRxAPJ
	 xQ7j5iGNcTxJNrpqb9kwdGXROwI/KIKLzyPncGlg1AmH0dv6fN2hIePC0dy3wwTBADw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216546;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=MyARb3KEA6iSjF4EZM5Y8YwXmyxck6+vtaXhetybbP4=;
	b=rgvZdJARRUD03DAyyM0IIWtKsarLjxO+MUxNPJfVWWSTP+LwgGR87lwXGwcEFQ+zRf7C
	 mnXRiI2P0JA77ghkjSINhl7SSkAUdYhmzp6A9ZgW/XknZNBkNv9d6QWTOJqjFwQGlNmIj
	 WbdXxHkPPiqEWcPRJmeuWLhQYlkJMfMzEKrr3U0r2/ZVA29h0nm/dMpe6P3K6bQ8GOwLc
	 k1hGrKtJ+JjJgvd2p5YG9rP4HSrOqs+etY2OYvJhZmNEUMJTSr5B87VHeHF4vCycvdUE8
	 SbSc2ayb/M389zkT1X3o1bBFFhZpdZb/6TY7pIx+HVj6u4ZkWVdA1dC22JGGHxOt9eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QqkQKJB4;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A976460A3830
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 09:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A976460A3830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QqkQKJB4
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so345028b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 01:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794216545; x=1794821345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MyARb3KEA6iSjF4EZM5Y8YwXmyxck6+vtaXhetybbP4=;
        b=QqkQKJB4Vj0Mbg1mrVqtwnrfpu+0HB05+USP7MCs/Qfv5CEC485g9iAcuvXaoFsejR
         ssSqEbxbsCD1J41D1oOb0WfbcApsdgpBpKzU3CcTVG59E98+1NwbUDlIyMbAPp+vFmQo
         /ZYnCbBCpNWF5JvIKHsJxCTSpKdDspIpoRZZ9f2oh2ZIdleMvjl6OeIy/xYEXsf0R8tx
         XpoKmUmM6AgiyPFohuJyPQ25iDbB3mX3nwkFMmtKF3c61PrhfYA9tZbS/nKQnzR9/JMe
         V3gz2l1yFQeoHRRzaf4rDjEtNKh/WNbXJeOrYS2BrNc88LqLxnMrhfn6kjCT3wIkNQUf
         I+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216545; x=1794821345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MyARb3KEA6iSjF4EZM5Y8YwXmyxck6+vtaXhetybbP4=;
        b=kz/WZ3Jcbp5/bECZ7uuJXOCI+PFUUO55CzLSguUQ8mzdgMmC631Q2+1hZ4bHB1UyCN
         ssvTBxFOtbCnbJNFZ6SCyjL/MYwFN/AMCsQjYDWJk0W4vyf1436NXdLtqpsS26PSBmDE
         gsZurUIIsBWkgdGWyT0lF0ikxNaM4jOcmvsPdCYvBzUj6Hzeo0g5MUpZ36t5DWru9Us3
         MvljHd0hTVQ+3v3pmdNsto5VAHsu3hVk2fjaNL5OPfGXoI2wUX5xN31Kx1n3FS8Zx5Fh
         JwJbyxM6g/1VzmoX5pK7igyxsuKHZAG7WjDvzRyVG9B6P6tAQrJi483ucXXXCnWaO6OW
         wKNw==
X-Gm-Message-State: APuU4Z/zwAizzyt4KXa8OqqnahXcRrnBzn/YRVraijtzKPwaux2nCvXY
	8ddIy2dI1sZrhHymgCdyswgGITdautC4caJDuYKEzkO5Zunh5vNZqvmE
X-Gm-Gg: AYBFou0gaFbYwpdXyzHkiukF58b+GsLBqfLYFX48vjc31dhiWwRBJd7OGv552vxRiax
	gwbMLJ0U1XjM7k9EzcAAIQQ6M90+S/YHFsz4ZaHgX+QN3BEy8M7Lv23FQPG0OXf9y0cbELPssm/
	N96LDdcKL9Ne4XSszfe/K7u9WUgjK78gcEsSRoGETAHPAtK9lYmfIdiOmMhrMDwKdEuP8d6qe2b
	N9ulV15KUokHvV30DvlASpdlFAPXZD/pIy1ExR5vmDs6RR1c3KVCxiHZSyD1xO/7TWQgI/ISovM
	qgSFb3S2h/2zOSh56u+r7a9ddFdWm3YR+e31YmpqwIKP2HNxOiHVkyLVeotJXGKPRvfWfSaDORQ
	qgorYDqCx8ULdPDUIkCDrYYMrWA1MZTxvqBWGJ2dHxJCM0oNFRH9JRdsHJqHY4pFRTmodH4FvOd
	wcECZ3JGswB1NRqpHzoX2IZapYTGktS2xt9i5R8XdGYA9II/JvfPrEzwqF5uNnHm4JiD2IBQ8aT
	U89Jdt+b1kEkShV0cqLhE7HAUM42L6ToVQoqgVWxF3DeKRO+VMJf6/7qz9CL1V+E5lf64KpnVNA
	yKQs4Y5GuT+rdYUplTuh/guT2iM8pFfrUdjc1fRhEw==
X-Received: by 2002:a05:6a00:22d6:b0:8b5:c1f1:e947 with SMTP id d2e1a72fcca58-8b670262dd9mr3166186b3a.50.1794216544797;
        Mon, 09 Nov 2026 01:29:04 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b648e55e85sm1103778b3a.17.2026.11.09.01.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:29:03 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 0/1] scsi: target: Fix zero-length protection SG allocation
Date: Mon,  9 Nov 2026 17:27:35 +0800
Message-ID: <20261109092744.822646-1-pkfxxxing@gmail.com>
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

Hi,

This patch fixes a target-core crash reachable by a logged-in iSCSI
initiator sending a READ(10) command with its TRANSFER LENGTH field set
to zero to a FILEIO LUN with protection information enabled.

The issue was reproduced on upstream Linux commit
f66469d9905b39d2c260a15d7d6db450f4db67c1 (7.4-rc1).

For this command, sbc_check_prot() selects TARGET_PROT_DIN_STRIP while
setting cmd->prot_length to zero. transport_generic_new_cmd() then
allocates an empty protection scatterlist, causing an invalid access in
sg_init_table() and a target-side Oops. The patch skips protection
scatterlist allocation when cmd->prot_length is zero.

The later UAF reports follow the first Oops. The Oops terminates the
iscsi_trx receive thread while processing the command, bypassing the
normal connection-exit handling in iscsi_target_rx_thread(). The
connection retains conn->rx_thread with rx_thread_active still set, even
after the thread's task_struct has been freed.

About 45 seconds later, iscsit_handle_nopin_response_timeout() calls
iscsit_cause_connection_reinstatement(). That function attempts to signal
the receive thread through send_sig(SIGINT, conn->rx_thread, 1), accessing
the freed task_struct. This explains the KASAN slab-use-after-free report
in do_send_sig_info(); the log also records the task allocation and its
subsequent RCU free.

The transmit thread then performs connection teardown through
iscsit_close_connection(), which attempts to stop the same receive thread
with kthread_stop(conn->rx_thread). This accounts for the subsequent
refcount_t addition-on-zero warning and the second Oops in kthread_stop().
These are cascading failures following the initial receive-thread Oops.
Preventing the zero-length protection allocation avoids the initial Oops
and this observed sequence of timeout and teardown failures.

The fix has also been verified to resolve the reported crash.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Full pre-fix crash log from 7.4.0-rc1-gf66469d9905b:

[   31.815230] Oops: general protection fault, probably for non-canonical address 0xdffffc03fffffffe: 0000 [#1] SMP KASAN NOPTI
[   31.818893] KASAN: probably user-memory-access in range [0x0000001ffffffff0-0x0000001ffffffff7]
[   31.821477] CPU: 0 UID: 0 PID: 282 Comm: iscsi_trx Not tainted 7.4.0-rc1-gf66469d9905b #1 PREEMPT(lazy) 
[   31.824355] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   31.827686] RIP: 0010:sgl_alloc_order+0xb6/0x370
[   31.829169] Code: 00 41 83 ef 01 4c 89 e2 31 f6 48 89 c7 e8 82 b6 3e ff 49 c1 e7 05 48 b8 00 00 00 00 00 fc ff df 4d 01 f7 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 84 02 00 00 49 bc 00 00 00 00 00 fc ff df 49 8b
[   31.834896] RSP: 0018:ffff88810a98fa58 EFLAGS: 00010212
[   31.836587] RAX: dffffc0000000000 RBX: 0000000000001000 RCX: 0000000000000000
[   31.838732] RDX: 00000003fffffffe RSI: 0000000000000000 RDI: 0000000000000010
[   31.840806] RBP: 0000000000000000 R08: ffff88810531b3b0 R09: 0000000000000000
[   31.842853] R10: 0000000000000010 R11: 0000000058dd7c11 R12: 0000000000000000
[   31.845214] R13: 0000000000000000 R14: 0000000000000010 R15: 0000001ffffffff0
[   31.847508] FS:  0000000000000000(0000) GS:ffff88819365d000(0000) knlGS:0000000000000000
[   31.849722] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.850832] CR2: 00007f6e328d7000 CR3: 0000000109180000 CR4: 00000000000006f0
[   31.852470] Call Trace:
[   31.853047]  <TASK>
[   31.853523]  transport_generic_new_cmd+0x6e7/0xbd0
[   31.854515]  __target_submit+0x11b/0x340
[   31.855377]  target_submit+0x2f3/0x390
[   31.860068]  iscsit_sequence_cmd+0x195/0x410
[   31.861093]  iscsit_process_scsi_cmd+0x8c/0x300
[   31.862074]  iscsit_get_rx_pdu+0x11f3/0x3a60
[   31.869797]  iscsi_target_rx_thread+0x137/0x2f0
[   31.872248]  kthread+0x2cd/0x3b0
[   31.873698]  ret_from_fork+0x373/0x5b0
[   31.876324]  ret_from_fork_asm+0x1a/0x30
[   31.876850]  </TASK>
[   31.877201] Modules linked in:
[   31.877807] ---[ end trace 0000000000000000 ]---
[   31.878589] RIP: 0010:sgl_alloc_order+0xb6/0x370
[   31.878594] Code: 00 41 83 ef 01 4c 89 e2 31 f6 48 89 c7 e8 82 b6 3e ff 49 c1 e7 05 48 b8 00 00 00 00 00 fc ff df 4d 01 f7 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 84 02 00 00 49 bc 00 00 00 00 00 fc ff df 49 8b
[   31.878596] RSP: 0018:ffff88810a98fa58 EFLAGS: 00010212
[   31.878599] RAX: dffffc0000000000 RBX: 0000000000001000 RCX: 0000000000000000
[   31.878600] RDX: 00000003fffffffe RSI: 0000000000000000 RDI: 0000000000000010
[   31.878602] RBP: 0000000000000000 R08: ffff88810531b3b0 R09: 0000000000000000
[   31.878603] R10: 0000000000000010 R11: 0000000058dd7c11 R12: 0000000000000000
[   31.878604] R13: 0000000000000000 R14: 0000000000000010 R15: 0000001ffffffff0
[   31.878611] FS:  0000000000000000(0000) GS:ffff88819365d000(0000) knlGS:0000000000000000
[   31.878622] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.878623] CR2: 00007f6e328d7000 CR3: 0000000109180000 CR4: 00000000000006f0
[   76.338671] Did not receive res
** replaying previous printk message **
[   76.338671] Did not receive response to NOPIN on CID: 0, failing connection for I_T Nexus iqn.1993-08.org.debian:01:ea1e,i,0x0000002a0001,iqn.2026-11.example:zsp13,t,0x01
[   76.338823] ==================================================================
[   76.338837] BUG: KASAN: slab-use-after-free in do_send_sig_info+0x132/0x160
[   76.338849] Read of size 8 at addr ffff88810aa9c840 by task swapper/0/0
[   76.338857] 
[   76.338862] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G      D             7.4.0-rc1-gf66469d9905b #1 PREEMPT(lazy) 
[   76.338870] Tainted: [D]=DIE
[   76.338872] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   76.338876] Call Trace:
[   76.338879]  <IRQ>
[   76.338881]  dump_stack_lvl+0x53/0x70
[   76.338893]  print_report+0xd0/0x630
[   76.338929]  kasan_report+0xce/0x100
[   76.338937]  do_send_sig_info+0x132/0x160
[   76.338941]  iscsit_cause_connection_reinstatement+0x2b6/0x350
[   76.338953]  iscsit_handle_nopin_response_timeout+0x209/0x440
[   76.338963]  call_timer_fn+0x2e/0x230
[   76.338976]  __run_timers+0x56a/0x8d0
[   76.339015]  timer_expire_remote+0xd8/0x130
[   76.339034]  tmigr_handle_remote_up+0x4e5/0xa60
[   76.339084]  __walk_groups_from+0x45/0x150
[   76.339093]  tmigr_handle_remote+0x22e/0x2c0
[   76.339116]  run_timer_softirq+0x1fa/0x250
[   76.339135]  handle_softirqs+0x1b8/0x600
[   76.339153]  __irq_exit_rcu+0xfc/0x160
[   76.339157]  sysvec_apic_timer_interrupt+0x6b/0x80
[   76.339163]  </IRQ>
[   76.339165]  <TASK>
[   76.339167]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   76.339172] RIP: 0010:pv_native_safe_halt+0xf/0x20
[   76.339178] Code: 8b e8 00 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d e3 78 18 00 fb f4 <c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
[   76.339182] RSP: 0018:ffffffff85e07d10 EFLAGS: 00000212
[   76.339187] RAX: ffff88819365d000 RBX: ffffffff85e14900 RCX: ffffffff84cd053b
[   76.339190] RDX: ffffed10236062cb RSI: 0000000000000004 RDI: 000000000000cd2c
[   76.339195] RBP: fffffbfff0bc2920 R08: 0000000000000001 R09: ffffed10236062ca
[   76.339197] R10: ffff88811b031653 R11: 0000000000000002 R12: 0000000000000000
[   76.339200] R13: 0000000000000000 R14: 1ffffffff0bc0fa6 R15: dffffc0000000000
[   76.339209]  default_idle+0x9/0x10
[   76.339213]  default_idle_call+0x39/0x60
[   76.339217]  do_idle+0x380/0x560
[   76.339228]  cpu_startup_entry+0x54/0x60
[   76.339231]  rest_init+0x18b/0x1c0
[   76.339289]  start_kernel+0x35e/0x3c0
[   76.339299]  x86_64_start_reservations+0x18/0x30
[   76.339307]  x86_64_start_kernel+0x111/0x120
[   76.339311]  common_startup_64+0x13e/0x158
[   76.339349]  </TASK>
[   76.339351] 
[   76.339352] Allocated by task 2:
[   76.339358]  kasan_save_stack+0x33/0x60
[   76.339367]  kasan_save_track+0x14/0x30
[   76.339371]  __kasan_slab_alloc+0x6e/0x70
[   76.339374]  kmem_cache_alloc_node_noprof+0x11f/0x350
[   76.339391]  copy_process+0x556/0x9c10
[   76.339400]  kernel_clone+0x17b/0x730
[   76.339403]  kernel_thread+0xcb/0x110
[   76.339409]  kthreadd+0x331/0x540
[   76.339480]  ret_from_fork+0x373/0x5b0
[   76.339486]  ret_from_fork_asm+0x1a/0x30
[   76.339491] 
[   76.339493] Freed by task 0:
[   76.339497]  kasan_save_stack+0x33/0x60
[   76.339503]  kasan_save_track+0x14/0x30
[   76.339509]  kasan_save_free_info+0x3b/0x60
[   76.339514]  __kasan_slab_free+0x43/0x70
[   76.339518]  kmem_cache_free+0xbf/0x3a0
[   76.339525]  rcu_core+0x55f/0x1830
[   76.339536]  handle_softirqs+0x1b8/0x600
[   76.339540]  __irq_exit_rcu+0xfc/0x160
[   76.339543]  sysvec_apic_timer_interrupt+0x6b/0x80
[   76.339549]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   76.339552] 
[   76.339553] Last potentially related work creation:
[   76.339555]  kasan_save_stack+0x33/0x60
[   76.339562]  kasan_record_aux_stack+0x8c/0xa0
[   76.339566]  __call_rcu_common.constprop.0+0x80/0x240
[   76.339573]  rcu_core+0x55f/0x1830
[   76.339576]  handle_softirqs+0x1b8/0x600
[   76.339580]  __irq_exit_rcu+0xfc/0x160
[   76.339583]  sysvec_apic_timer_interrupt+0x6b/0x80
[   76.339587]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   76.339591] 
[   76.339592] Second to last potentially related work creation:
[   76.339598]  kasan_save_stack+0x33/0x60
[   76.339602]  kasan_record_aux_stack+0x8c/0xa0
[   76.339606]  __call_rcu_common.constprop.0+0x80/0x240
[   76.339610]  __schedule+0x1817/0x4bb0
[   76.339614]  schedule+0x75/0x1f0
[   76.339618]  worker_thread+0x216/0xd20
[   76.339623]  kthread+0x2cd/0x3b0
[   76.339629]  ret_from_fork+0x373/0x5b0
[   76.339633]  ret_from_fork_asm+0x1a/0x30
[   76.339637] 
[   76.339638] The buggy address belongs to the object at ffff88810aa9c000
[   76.339638]  which belongs to the cache task_struct of size 3968
[   76.339642] The buggy address is located 2112 bytes inside of
[   76.339642]  freed 3968-byte region [ffff88810aa9c000, ffff88810aa9cf80)
[   76.339646] 
[   76.339648] The buggy address belongs to the physical page:
[   76.339650] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810aa9d000 pfn:0x10aa98
[   76.339659] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   76.339661] flags: 0x200000000000240(workingset|head|node=0|zone=2)
[   76.339671] page_type: f5(slab)
[   76.339676] raw: 0200000000000240 ffff8881002d6dc0 ffff888100041e90 ffffea000424c810
[   76.339680] raw: ffff88810aa9d000 0000000000080005 00000000f5000000 0000000000000000
[   76.339683] head: 0200000000000240 ffff8881002d6dc0 ffff888100041e90 ffffea000424c810
[   76.339687] head: ffff88810aa9d000 0000000000080005 00000000f5000000 0000000000000000
[   76.339690] head: 0200000000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
[   76.339693] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   76.339695] page dumped because: kasan: bad access detected
[   76.339697] 
[   76.339698] Memory state around the buggy address:
[   76.339700]  ffff88810aa9c700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   76.339703]  ffff88810aa9c780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   76.339705] >ffff88810aa9c800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   76.339707]                                            ^
[   76.339709]  ffff88810aa9c880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   76.339712]  ffff88810aa9c900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   76.339714] ==================================================================
[   76.339832] ------------[ cut here ]------------
[   76.339837] refcount_t: addition on 0; use-after-free.
[   76.339839] WARNING: lib/refcount.c:34 at refcount_warn_saturate+0xc0/0xe0, CPU#0: iscsi_ttx/281
[   76.461888] Modules linked in:
[   76.462274] CPU: 0 UID: 0 PID: 281 Comm: iscsi_ttx Tainted: G    B D             7.4.0-rc1-gf66469d9905b #1 PREEMPT(lazy) 
[   76.463667] Tainted: [B]=BAD_PAGE, [D]=DIE
[   76.464161] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   76.465568] RIP: 0010:refcount_warn_saturate+0xc0/0xe0
[   76.466227] Code: 66 b9 23 04 67 48 0f b9 3a 5b 5d c3 cc cc cc cc 48 8d 3d 63 b9 23 04 67 48 0f b9 3a 5b 5d c3 cc cc cc cc 48 8d 3d 60 b9 23 04 <67> 48 0f b9 3a 5b 5d c3 cc cc cc cc 48 89 df e8 7c 8c 3c ff e9 66
[   76.468449] RSP: 0018:ffff8881099bfbe0 EFLAGS: 00010246
[   76.469115] RAX: 0000000000000000 RBX: ffff88810aa9c028 RCX: 0000000000000000
[   76.470019] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffffff868b9c60
[   76.470911] RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed1021553805
[   76.471866] R10: 0000000000000003 R11: 0000000000000002 R12: ffff88810aa9c028
[   76.472783] R13: ffff8881072c4000 R14: ffff888104b601b8 R15: ffff88810531b480
[   76.473687] FS:  0000000000000000(0000) GS:ffff88819365d000(0000) knlGS:0000000000000000
[   76.474697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.475393] CR2: 0000556bceea9000 CR3: 0000000102fd3000 CR4: 00000000000006f0
[   76.476310] Call Trace:
[   76.476694]  <TASK>
[   76.476960]  kthread_stop+0x319/0x3a0
[   76.477473]  iscsit_close_connection+0x12c9/0x2060
[   76.481047]  iscsit_take_action_for_connection_exit+0x1f3/0x490
[   76.481821]  iscsi_target_tx_thread+0x472/0x6f0
[   76.486657]  kthread+0x2cd/0x3b0
[   76.488112]  ret_from_fork+0x373/0x5b0
[   76.490645]  ret_from_fork_asm+0x1a/0x30
[   76.491112]  </TASK>
[   76.491397] ---[ end trace 0000000000000000 ]---
[   76.492023] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   76.495869] #PF: supervisor write access in kernel mode
[   76.496675] #PF: error_code(0x0002) - not-present page
[   76.497864] PGD 0 P4D 0 
[   76.498183] Oops: Oops: 0002 [#2] SMP KASAN NOPTI
[   76.498764] CPU: 0 UID: 0 PID: 281 Comm: iscsi_ttx Tainted: G    B D W           7.4.0-rc1-gf66469d9905b #1 PREEMPT(lazy) 
[   76.500049] Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
[   76.501456] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   76.502921] RIP: 0010:kthread_stop+0xb5/0x3a0
[   76.503771] Code: 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 91 02 00 00 48 8b ab d0 06 00 00 be 08 00 00 00 48 89 ef e8 6b 7f 63 00 <f0> 80 4d 00 02 48 89 df e8 de f7 ff ff be 08 00 00 00 48 89 df e8
[   76.506397] RSP: 0018:ffff8881099bfbf8 EFLAGS: 00010202
[   76.507061] RAX: 0000000000000001 RBX: ffff88810aa9c000 RCX: 0000000000000000
[   76.507922] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff8881099bfba0
[   76.508800] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed1021553805
[   76.509683] R10: 0000000000000003 R11: 0000000000000002 R12: ffff88810aa9c028
[   76.510546] R13: ffff8881072c4000 R14: ffff888104b601b8 R15: ffff88810531b480
[   76.511386] FS:  0000000000000000(0000) GS:ffff88819365d000(0000) knlGS:0000000000000000
[   76.512390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.513100] CR2: 0000000000000000 CR3: 0000000102fd3000 CR4: 00000000000006f0
[   76.513951] Call Trace:
[   76.514253]  <TASK>
[   76.514546]  iscsit_close_connection+0x12c9/0x2060
[   76.517895]  iscsit_take_action_for_connection_exit+0x1f3/0x490
[   76.518600]  iscsi_target_tx_thread+0x472/0x6f0
[   76.523185]  kthread+0x2cd/0x3b0
[   76.524599]  ret_from_fork+0x373/0x5b0
[   76.527076]  ret_from_fork_asm+0x1a/0x30
[   76.527575]  </TASK>
[   76.527847] Modules linked in:
[   76.528219] CR2: 0000000000000000
[   76.528637] ---[ end trace 0000000000000000 ]---
[   76.529177] RIP: 0010:sgl_alloc_order+0xb6/0x370
[   76.529187] Code: 00 41 83 ef 01 4c 89 e2 31 f6 48 89 c7 e8 82 b6 3e ff 49 c1 e7 05 48 b8 00 00 00 00 00 fc ff df 4d 01 f7 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 84 02 00 00 49 bc 00 00 00 00 00 fc ff df 49 8b
[   76.529189] RSP: 0018:ffff88810a98fa58 EFLAGS: 00010212
[   76.529191] RAX: dffffc0000000000 RBX: 0000000000001000 RCX: 0000000000000000
[   76.529192] RDX: 00000003fffffffe RSI: 0000000000000000 RDI: 0000000000000010
[   76.529193] RBP: 0000000000000000 R08: ffff88810531b3b0 R09: 0000000000000000
[   76.529195] R10: 0000000000000010 R11: 0000000058dd7c11 R12: 0000000000000000
[   76.529196] R13: 0000000000000000 R14: 0000000000000010 R15: 0000001ffffffff0
[   76.529201] FS:  0000000000000000(0000) GS:ffff88819365d000(0000) knlGS:0000000000000000
[   76.529210] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.529211] CR2: 0000000000000000 CR3: 0000000102fd3000 CR4: 00000000000006f0
[   76.529217] note: iscsi_ttx[281] exited with irqs disabled

Regards,
liuyong
360 Vulnerability Research Institute
