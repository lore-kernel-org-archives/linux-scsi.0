Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794613193;
	b=lH3QrEw15PDpekr1fLNYkI6HnxCcA+CCVqHwfLm/qs+u5jNuQ4sTGOhgUpGnz44mNiVM
	 9zxfofS0mllQXo2N8dTwgkEir2J20TiPa+9W1qhEcEz/wE//nOVkH0+QUT6lDzNEm6gTR
	 UYM49Y8+PDBtRPjmQ2EX+5tPXHPQObTUrvG4A8IRsfQIEsenHHGzhtYCXAtp5Q4cINYgt
	 q9X4xCoQhJxqLKYUaKZ1ZPpSlLM3AYEIuGzvWUo0BojUjtnrBM55eu0xIfRl9SYdzAFId
	 zhGcJ0gxdhsCF3Gg8Xpew3yKwHryazcNvch1FGaEmX8O7uazWe7PR7yPSfMXd77dTtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794613193;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1Qd9x+J1eIaXuCJAsAB7CRRR0cB1orwqsyPjYoZaMx8=;
	b=PC6CGp+PaiyFrNm/Oxi3+M6Rt5gy/M0buPM/hxwCt7KBn+5f5LTL/5sLrSHNtwwLGiuE
	 cw81mIEIfNxV0uTA4JW3Rxpw/VZ7jmSiNI9FSKANQHPFb11U9ZFBtynKQJWUEG0Z5sDt0
	 ryAqaUlKaTb/O/LuxW+Y+ptWHEg8Mw10uYYqk67ZEpUsIGpi44o2jFr9BEEed7/CMLQOi
	 pM/3tip3lOmT/u6cKRyuoFMjy825hYE1J1wgW8pZdpXo3UBn3PBOoMGaHNt62QyRDhtKq
	 0xqo3kNHk/PGK23av69lugEpER4hmXTyu64efnMzcCMBzqYarx0GzI7KZph+bSt5G7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="JYJmG/AP";
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4628606A33E
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 23:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4628606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JYJmG/AP
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso815574a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 15:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794613192; x=1795217992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Qd9x+J1eIaXuCJAsAB7CRRR0cB1orwqsyPjYoZaMx8=;
        b=JYJmG/APAZk0iV3FuHOPSIaH9QTXobY2QEvCnegQ9DuML5p4trKr/DUt2pFX+G2HrT
         vKc/pAzc0k+N/hDyJLunlA5RTyrS5eFMQloCkHVLgbPq6B+9kga6sg6I06UVpM9pwiJF
         tLPG5De7s0vYsY4J/Z86vKXjeB02EMRr3QRfSR0f+HyLcPgnNO44SzFJ5fwb2NP/H+qO
         C/NMMpecyKrw8kizU9VV7PaZaINzQOxDdqr9/edTpp+PVs5TNjaO01JiDynZBe3hnZda
         q3mepNAjiPdMHyPzlYZjC7F3ID8bDTLGZ7tLVj48je1oTiNkhMvuv2C7F9D1JMRVpCXY
         UNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613192; x=1795217992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1Qd9x+J1eIaXuCJAsAB7CRRR0cB1orwqsyPjYoZaMx8=;
        b=Y9ZTUgNudPJ7shNOLslyjK3jQ83v4SKBVgFFz6VQz1JXNCVacaqHO++pDTHi+jBiJ/
         2K1sdZtd+H3+HXFNfz1FR3ku14M5+IIS7sdllHrPV+SHxzix7evJiZk0BRJPMA92vn0j
         b7gYebUwsaxeaLgZd219S7LkLxfh2dYkA61sPI+cCCBzRjq1OrmHZweT5Sdjc3fGgcpv
         o0yYJK7XFzLVJBwC1gjsrhk0sGfiwDsDakCcsQQ840T6FpdVduFb1anCS2bWS1t2lUAd
         sxLVy7kWTPCqrbMqxD7rPMMxBq/Zta3JRDWQTuRXwx6RzKyxVV8mJ0mV4sb5VqYxFtiY
         r8Pw==
X-Gm-Message-State: APuU4Z+mDxHw2Zsh5nb6S3FDhMA3wQwx4UMGpvTXHjYAEVgPJDyI4V5E
	IKcBQpc9D5UjdW8liBp5l7jhHIbfmDfHxXdnEoSCxcT9Q24mIOvGp/OPunb32u+QON8=
X-Gm-Gg: AYBFou35+laBq2QnxL/T5X6JByA75WZBgaPDJjcYn0V7K5arnsjhvl7IqOEuPA5HUeM
	5aLpAuc3c1s/DydVExa4iWn9Ggz2KujxyNr+5MqbGXy8qxs3LavjnsOAtQMhA4ZI8Kml53aQ4OG
	kj2BoO41FluCAXn6E8V19mqyjWp78gldZ3UlPmjE1PhmcUeYkGE9aB0KLpO11dIYD5tO0J7VC+y
	fFEEbdmtdtCb8xbPv7gsmBq/8XYYM0dYEHFS/xY+JXxzJgOHdUuHMutvfPY1thW52795vqGn1DA
	W7ubspi8vpsbG6J1nVy8O5OyRItXQHxzJO36ItN762M1UVP1r7t8N8yMDWe3C/o4uEWB9zk+Nov
	pU04U8rqmsrY6FzgxgHXOibPicFoG+lNm29idM3SW4ghscUBWy/WH6tNvBrlAkaJWW6AdNvr2Sp
	T8X42fRqU83WNEqoptsvqSc5XE8zrdqC6JP0RoxxBfSkZC7gV9mWzPFId7FIjjBPFnEWdNPyLpf
	aAC3asK6Bz5MMbGGm8+lzYIw1f8htXZawj4dy9aOjjyLZPHzEqcXifJEl7kTgDCA3784MC5U2/N
	LiYiTT9EO0J7GsS0cLRyCIONKK2Xg0sUHFzFlnTlJehvfcO2nSm1Gq+uOzmzvRLGhQ6HvN0XHcF
	+D8fLFEgtf38PnmSMSw+UVZyOT9/twLYsNy1L6A==
X-Received: by 2002:a17:90b:1846:b0:3ae:8106:6074 with SMTP id 98e67ed59e1d1-3b1b0a42a3bmr3398345a91.16.1794613192095;
        Fri, 13 Nov 2026 15:39:52 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aeb3d2d4sm6442462a91.7.2026.11.13.15.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:39:51 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: libiscsi: only complete a task that has been sent
Date: Sat, 14 Nov 2026 08:39:37 +0900
Message-ID: <20261113233938.397415-2-yhlee@isslab.korea.ac.kr>
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

The RX path looks a management response or a Reject up by ITT and
completes the task if it is neither free nor a SCSI command.  That also
accepts two kinds of slot that were never sent:

- a management task still waiting on conn->mgmtqueue in
  ISCSI_TASK_PENDING.  Completing it returns the slot to the pool while
  it is still linked on the queue, so the xmit worker and the next
  allocation both use it.
- a slot that iscsi_alloc_task() is still filling in.  It stores
  ISCSI_TASK_PENDING before task->conn and task->sc under frwd_lock,
  while the RX check runs under back_lock, so a fresh slot is seen with
  a NULL task->conn.

The target chooses the ITT and the pool index is small, so either needs
nothing but timing.

Reproduced with test-only delays that hold each window open and a
target that sends a Reject naming the slot.  For a queued task the
unpatched driver freed it in 8 of 8 attempts inside the window, this
patch in 0 of 5.  KASAN reported nothing; the xmit worker hit:

[    7.309467] ------------[ cut here ]------------
[    7.309469] WARNING: drivers/scsi/libiscsi.c:1552 at iscsi_xmit_task+0x36c/0x470, CPU#1: kworker/u8:2/42
[    7.311388] Modules linked in:
[    7.311730] CPU: 1 UID: 0 PID: 42 Comm: kworker/u8:2 Not tainted 7.4.0-rc2-00471-g9ab317b63171-dirty #3 PREEMPT(lazy)
[    7.312825] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    7.314002] Workqueue: iscsi_q_2 iscsi_xmitworker
[    7.314512] RIP: 0010:iscsi_xmit_task+0x36c/0x470
[    7.315011] Code: 74 24 0c 48 8b 4c 24 10 f0 0f b1 31 0f 85 8d 00 00 00 8b 44 24 38 85 c0 78 37 89 c6 83 c6 01 78 30 85 c0 0f 85 2f fd ff ff 90 <0f> 0b 90 45 31 e4 e9 3d fe ff ff 31 f6 4c 89 f7 e8 af 2e 16 ff e9
[    7.316897] RSP: 0018:ffffc900002c7b38 EFLAGS: 00010246
[    7.317450] RAX: 0000000000000000 RBX: ffff88800c30a378 RCX: ffff88800c0b1878
[    7.318192] RDX: ffffed1001816310 RSI: 0000000000000000 RDI: ffff88800c0b1878
[    7.318928] RBP: ffff88800c0b1800 R08: 0000000000000000 R09: ffffed100181630f
[    7.319668] R10: ffff88800c0b187b R11: 0000000000000000 R12: ffff88800c305440
[    7.320410] R13: 1ffff92000058f6a R14: 0000000000000000 R15: ffff88800c30a400
[    7.321146] FS:  0000000000000000(0000) GS:ffff8880e56a8000(0000) knlGS:0000000000000000
[    7.321978] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.322589] CR2: 00007f1933873000 CR3: 000000000b73b004 CR4: 0000000000770ef0
[    7.323340] PKRU: 55555554
[    7.323633] Call Trace:
[    7.323902]  <TASK>
[    7.324162]  ? iscsi_sw_tcp_pdu_init+0x81e/0xb00
[    7.324635]  ? __pfx_iscsi_xmit_task+0x10/0x10
[    7.325088]  ? iscsi_prep_mgmt_task+0x381/0x590
[    7.325570]  iscsi_xmitworker+0x258/0xab0
[    7.325997]  process_one_work+0x697/0x1060
[    7.326441]  ? __pfx___schedule+0x10/0x10
[    7.326872]  ? __pfx_process_one_work+0x10/0x10
[    7.327365]  ? _raw_spin_lock_irq+0x81/0xe0
[    7.327816]  ? __pfx_iscsi_xmitworker+0x10/0x10
[    7.328308]  ? assign_work+0x11d/0x370
[    7.328689]  worker_thread+0x45b/0xd10
[    7.329075]  ? __pfx_worker_thread+0x10/0x10
[    7.329514]  kthread+0x2c8/0x3b0
[    7.329848]  ? recalc_sigpending+0x15c/0x1e0
[    7.330298]  ? __pfx_kthread+0x10/0x10
[    7.330683]  ret_from_fork+0x36e/0x5a0
[    7.331069]  ? __pfx_ret_from_fork+0x10/0x10
[    7.331506]  ? __switch_to+0x572/0xdc0
[    7.331889]  ? __pfx_kthread+0x10/0x10
[    7.332278]  ret_from_fork_asm+0x1a/0x30
[    7.332676]  </TASK>
[    7.332909] ---[ end trace 0000000000000000 ]---
[    7.333687] refcount_t: underflow; use-after-free.

For the allocation window, under KASAN, 7 of 7 unpatched and 0 of 5
patched:

[    7.293597] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
[    7.295946] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
[    7.296860] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.4.0-rc2-00471-g33481dfad534-dirty #1 PREEMPT(lazy)
[    7.298097] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    7.299457] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x4e/0x170
[    7.300200] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 fd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c8 00 00 00 48 8b 45 60 48 39 c3 74 55 48 b8 00
[    7.302531] RSP: 0018:ffffc90000006b58 EFLAGS: 00010206
[    7.303213] RAX: dffffc0000000000 RBX: ffff888009e2a000 RCX: 0000000000000000
[    7.304126] RDX: 000000000000000c RSI: ffffc90000006c10 RDI: 0000000000000060
[    7.305037] RBP: 0000000000000000 R08: 0000000000000080 R09: 0000000000000000
[    7.305948] R10: ffffc9000000679f R11: 000000000000004d R12: ffff88800c70c440
[    7.306858] R13: 0000000000000000 R14: ffffc90000006c10 R15: 0000000000000000
[    7.307766] FS:  0000000000000000(0000) GS:ffff8880e55a8000(0000) knlGS:0000000000000000
[    7.308794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.309541] CR2: 0000559011da8ef8 CR3: 000000000be2c005 CR4: 0000000000770ef0
[    7.310472] PKRU: 55555554
[    7.310838] Call Trace:
[    7.311173]  <IRQ>
[    7.311455]  __iscsi_complete_pdu+0x1acf/0x2390
[    7.312054]  ? iscsi_dbg_trace+0xcc/0x100
[    7.312583]  ? iscsi_dbg_trace+0xcc/0x100
[    7.313112]  ? __pfx___iscsi_complete_pdu+0x10/0x10
[    7.313748]  ? __pfx__raw_spin_lock+0x10/0x10
[    7.314327]  iscsi_complete_pdu+0x5c/0x80
[    7.314855]  iscsi_tcp_data_recv_done+0xf4/0x250
[    7.315459]  iscsi_tcp_recv_skb+0x31e/0xec0
[    7.316007]  ? __tcp_transmit_skb+0x2ec9/0x4720
[    7.316602]  ? __pfx_iscsi_tcp_recv_skb+0x10/0x10
[    7.317217]  ? __pfx_iscsi_dbg_trace+0x10/0x10
[    7.317800]  ? __pfx_selinux_parse_skb.constprop.0+0x10/0x10
[    7.318539]  ? __alloc_skb+0x342/0x890
[    7.319041]  iscsi_sw_tcp_recv+0x12f/0x390
[    7.319576]  ? __pfx_iscsi_sw_tcp_recv+0x10/0x10
[    7.320182]  ? __pfx_selinux_netlbl_sock_rcv_skb+0x10/0x10
[    7.320891]  __tcp_read_sock+0x1ab/0x810
[    7.321407]  ? __pfx_iscsi_sw_tcp_recv+0x10/0x10
[    7.322012]  ? __pfx___tcp_read_sock+0x10/0x10
[    7.322593]  iscsi_sw_tcp_data_ready+0x18b/0x510
[    7.323199]  ? __pfx_iscsi_sw_tcp_data_ready+0x10/0x10
[    7.323864]  ? tcp_try_rmem_schedule+0x17f/0x1390
[    7.324476]  ? tcp_event_data_recv+0x36a/0x7b0
[    7.325061]  tcp_data_queue+0x1f2d/0x4b70
[    7.325587]  ? __pfx_tcp_data_queue+0x10/0x10
[    7.326162]  ? tcp_try_undo_loss+0x670/0x730
[    7.326721]  ? kvm_clock_get_cycles+0x19/0x40
[    7.327300]  tcp_rcv_established+0x8a8/0x3990
[    7.327876]  ? security_sock_rcv_skb+0x2b/0x40
[    7.328460]  ? sk_filter_trim_cap+0x400/0x980
[    7.329036]  ? __pfx_tcp_inbound_hash+0x10/0x10
[    7.329629]  ? __pfx_tcp_rcv_established+0x10/0x10
[    7.330255]  ? __pfx_sk_filter_trim_cap+0x10/0x10
[    7.330869]  ? _raw_spin_lock+0x80/0xe0
[    7.331373]  tcp_v4_do_rcv+0x45b/0x970
[    7.331872]  ? tcp_v4_fill_cb+0x26/0x400
[    7.332385]  tcp_v4_rcv+0x223d/0x3b90
[    7.332874]  ? __kasan_unpoison_pages+0x2c/0x40
[    7.333466]  ? __pfx_tcp_v4_rcv+0x10/0x10
[    7.333996]  ? __pfx_raw_local_deliver+0x10/0x10
[    7.334598]  ? get_stack_info_noinstr+0x16/0xe0
[    7.335197]  ? get_stack_info+0x2a/0x90
[    7.335703]  ip_protocol_deliver_rcu+0x61/0x2e0
[    7.336302]  ip_local_deliver_finish+0x329/0x4b0
[    7.336910]  ip_local_deliver+0x18f/0x2d0
[    7.337436]  ? __pfx_ip_local_deliver+0x10/0x10
[    7.338033]  ? ipv4_dst_check+0x10a/0x160
[    7.338557]  ? ip_rcv_finish_core+0x1d0c/0x1dd0
[    7.339160]  ip_sublist_rcv_finish+0x138/0x1b0
[    7.339743]  ip_sublist_rcv+0x3ae/0x670
[    7.340252]  ? kasan_save_stack+0x42/0x60
[    7.340775]  ? kasan_save_track+0x14/0x30
[    7.341301]  ? __pfx_ip_sublist_rcv+0x10/0x10
[    7.341876]  ? __alloc_skb+0x11e/0x890
[    7.342371]  ? net_rx_action+0x8f1/0xfb0
[    7.342891]  ? handle_softirqs+0x1b3/0x600
[    7.343427]  ? __irq_exit_rcu+0xfc/0x160
[    7.343943]  ? common_interrupt+0x7f/0x90
[    7.344467]  ? __asan_memset+0x23/0x50
[    7.344968]  ? ip_rcv_core+0x4e9/0xce0
[    7.345462]  ? common_startup_64+0x13e/0x158
[    7.346028]  ip_list_rcv+0x266/0x380
[    7.346503]  ? csum_partial+0xc/0x20
[    7.346981]  ? __pfx_ip_list_rcv+0x10/0x10
[    7.347517]  __netif_receive_skb_list_core+0x5c3/0x860
[    7.348186]  ? tcp4_gro_receive+0x54a/0x15c0
[    7.348746]  ? __pfx___netif_receive_skb_list_core+0x10/0x10
[    7.349480]  ? inet_gro_receive+0x719/0x1190
[    7.350049]  ? kmalloc_reserve+0x103/0x2b0
[    7.350584]  netif_receive_skb_list_internal+0x553/0xbb0
[    7.351271]  ? dma_map_phys+0xb0/0x290
[    7.351768]  ? __pfx_netif_receive_skb_list_internal+0x10/0x10
[    7.351998] TESTWIN close itt 1
[    7.352946]  ? e1000_alloc_rx_buffers+0x32c/0xd70
[    7.353561]  ? gro_receive_skb+0x279/0x960
[    7.354103]  napi_complete_done+0x1ab/0x7f0
[    7.354648]  ? __pfx_napi_complete_done+0x10/0x10
[    7.355264]  ? __pfx_e1000_clean_rx_irq+0x10/0x10
[    7.355880]  e1000_clean+0x816/0x25a0
[    7.356364]  ? schedule_timeout+0x1cd/0x200
[    7.356916]  ? tmigr_requires_handle_remote_up+0x49/0x160
[    7.357614]  ? kvm_sched_clock_read+0x11/0x20
[    7.358189]  ? sched_clock+0x11/0x30
[    7.358665]  ? sched_clock_cpu+0x6c/0x4c0
[    7.359197]  ? __walk_groups_from+0x40/0x150
[    7.359757]  ? __pfx_e1000_clean+0x10/0x10
[    7.360294]  ? __pfx_sched_clock_cpu+0x10/0x10
[    7.360881]  ? sched_balance_trigger+0xc7/0xf20
[    7.361474]  __napi_poll+0x9c/0x520
[    7.361942]  net_rx_action+0x8f1/0xfb0
[    7.362437]  ? kvm_clock_get_cycles+0x19/0x40
[    7.363012]  ? ktime_get+0xe6/0x160
[    7.363478]  ? __pfx_net_rx_action+0x10/0x10
[    7.364043]  ? timerqueue_linked_add+0x1f4/0x3d0
[    7.364646]  ? _raw_spin_lock+0x80/0xe0
[    7.365156]  handle_softirqs+0x1b3/0x600
[    7.365670]  ? __pfx_handle_softirqs+0x10/0x10
[    7.366255]  __irq_exit_rcu+0xfc/0x160
[    7.366748]  common_interrupt+0x7f/0x90
[    7.367256]  </IRQ>
[    7.367547]  <TASK>
[    7.367840]  asm_common_interrupt+0x26/0x40
[    7.368388] RIP: 0010:pv_native_safe_halt+0xf/0x20
[    7.369013] Code: 04 ce 00 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 93 44 18 00 fb f4 <e9> 8c 39 02 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
[    7.371276] RSP: 0018:ffffffff85607d10 EFLAGS: 00000216
[    7.371952] RAX: ffff8880e55a8000 RBX: ffffffff85614700 RCX: ffffffff846d0c6b
[    7.372863] RDX: ffffed100d8862a3 RSI: 0000000000000004 RDI: 000000000000480c
[    7.373768] RBP: fffffbfff0ac28e0 R08: 0000000000000001 R09: ffffed100d8862a2
[    7.374675] R10: ffff88806c431513 R11: 0000000000000002 R12: 0000000000000000
[    7.375584] R13: 0000000000000000 R14: 1ffffffff0ac0fa6 R15: dffffc0000000000
[    7.376474]  ? ct_kernel_exit.constprop.0+0x9b/0xc0
[    7.377078]  default_idle+0x9/0x10
[    7.377533]  default_idle_call+0x39/0x60
[    7.378051]  do_idle+0x37b/0x560
[    7.378485]  ? __pfx_do_idle+0x10/0x10
[    7.378983]  cpu_startup_entry+0x4f/0x60
[    7.379497]  rest_init+0x186/0x1b0
[    7.379956]  ? __pfx_acpi_read_bit_register+0x10/0x10
[    7.380584]  ? __pfx_rest_init+0x10/0x10
[    7.381074]  ? __pfx_kernel_init+0x10/0x10
[    7.381579]  ? acpi_enable_subsystem+0x24b/0x470
[    7.382154]  start_kernel+0x354/0x3b0
[    7.382635]  x86_64_start_reservations+0x18/0x30
[    7.383242]  x86_64_start_kernel+0x111/0x120
[    7.383771]  common_startup_64+0x13e/0x158
[    7.384290]  </TASK>
[    7.384590] Modules linked in:
[    7.385018] ---[ end trace 0000000000000000 ]---

Mark a task ISCSI_TASK_RUNNING with a release once it is ready to go
out, and accept a response only for a task in that state, read with an
acquire.  A response can only follow a transmission: attempts that
arrived after the window closed were still accepted, 24 of 24 unpatched
and 9 of 9 patched.

Fixes: 659743b02c41 ("[SCSI] libiscsi: Reduce locking contention in fast path")
Fixes: 5923d64b7ab6 ("scsi: libiscsi: Drop taskqueuelock")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: unchanged from v1, resent as part of this series:
https://lore.kernel.org/all/20261113145140.282504-1-yhlee@isslab.korea.ac.kr/

Follow-up to a promise made in
https://lore.kernel.org/all/20261007031737.639431-1-yhlee@isslab.korea.ac.kr/
- assigning the state last is not enough: a fully set-up task waiting on
conn->mgmtqueue is PENDING too.  The mgmtqueue half was pointed out in
https://lore.kernel.org/all/sashiko-outbox-176224@kernel.org/

 drivers/scsi/libiscsi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2d04448432a772..83d726043d3e8d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -429,7 +429,8 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
-	task->state = ISCSI_TASK_RUNNING;
+	/* Pairs with the acquire in the RX task lookups. */
+	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
@@ -702,7 +703,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
 		session->state = ISCSI_STATE_LOGGING_OUT;
 
-	task->state = ISCSI_TASK_RUNNING;
+	/* Pairs with the acquire in the RX task lookups. */
+	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
 	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
 			  "datalen %d]\n", hdr->opcode & ISCSI_OPCODE_MASK,
 			  hdr->itt, task->data_count);
@@ -1174,7 +1176,8 @@ static int iscsi_handle_reject(struct iscsi_session *session,
 			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
 				task = iscsi_itt_to_task(session, conn,
 							 rejected_pdu.itt);
-			if (!task || task->state == ISCSI_TASK_FREE ||
+			/* Pairs with the release when the task is prepared. */
+			if (!task || smp_load_acquire(&task->state) != ISCSI_TASK_RUNNING ||
 			    task->sc) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
@@ -1314,7 +1317,9 @@ int __iscsi_complete_pdu(struct iscsi_session *session, struct iscsi_conn *conn,
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 	case ISCSI_OP_NOOP_IN:
 		task = iscsi_itt_to_task(session, conn, hdr->itt);
-		if (!task || task->state == ISCSI_TASK_FREE || task->sc)
+		/* Pairs with the release when the task is prepared. */
+		if (!task || smp_load_acquire(&task->state) != ISCSI_TASK_RUNNING ||
+		    task->sc)
 			return ISCSI_ERR_BAD_ITT;
 		break;
 	default:
-- 
2.43.0

