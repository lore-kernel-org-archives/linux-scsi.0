Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794910521;
	b=IvsSL3FgwKqiE0kBnK4vRmBAEuw4SYErIiLuyyMf8u0wkKFTzjLtFD54Ad0RhZX3uOND
	 E26skTgg9Jrciz8dtJ5miDooF236kELkQ5G7kuVsobSflGW3TPW1e/LfWAEMnLO839Bz/
	 53NwgxLsPgaZozQBqFUNZn2YoMPDVTMWrcu9tu94GwRaZ7yvvC82D8jZ4CiXS5owqUqrz
	 DueTMRvUlK/VYtMQ7q4qpIakrEt9nDM2HdaXgzc2LKXktdVtZAMO+HBZ4M0VRdSWX0VWK
	 FbiwB4kRc8EW2BmH2rjZEAMqJ/8vf2iP1T2X1d4uQ+kpCFhdaSbCH8mqtUPjFdUJJ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910521;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yoswokMSE2+p37K+PFvtRqKoa8vKZdGiVdI8IOK5pvU=;
	b=0qi48Blhk0BrOkjAqf5p6BW4nUJjI+UsCiaGuP/pUPlmJKkOyhAzmXWHnMkNkmyL7ahq
	 kXc9RFxtpJTz8A5UmA1lUGuTUtqldLSHnJW2FHJH0EiSJOrcSbUF9eTAg1ixxr+ebvnmj
	 mX+MD3Gdp0C1RIEgSYnb26n6ltcTIVPicNletUXhYX7fI39tKlTKvZvWBILlhpr3ZH+lu
	 wdXi9g+WMZFi9bAENEjrfYV39CpUuJpYxRpRVwc5w6MZ/PKYLmj7kt45ACbt9qfBpEL8O
	 3yLDXlix2XmKBB+bPERtQMkhG2bvl90cBMOY1PszgWUMcL/ev5e2x17TAoxidV4lqAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CW+3g1Ks;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BABE606A33A
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 10:15:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BABE606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CW+3g1Ks
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-15ea896ddc8so6929577c88.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 02:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794910519; x=1795515319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yoswokMSE2+p37K+PFvtRqKoa8vKZdGiVdI8IOK5pvU=;
        b=CW+3g1Ks5tZjHa++RVOVvKM2LhlZMzeDDrvqFSHawq72SHq/GEtO+IN4Eb884eeWkK
         fTVK3545h0pRy2uJrk76aAwfxBP8aRUh7lsheFRl0BcIZW5QpByMYL6X3Qe3Is5Gt1+u
         1CYViZmx2WfhThJ0IZEUCcoXKY5ejfhWHOkIlpulkd50BKYeyl+mjqZGUABV3/vFUoiH
         FQuHEw9zTTgAFMGLwPPLO4H0iNMKuQeyoqw0ciDfyA3r91wX/9EDOcdf6kCjdCp8JKXx
         HJoYKvwkhJCf3pydxmCirZZHkxx5tTaHOaFNuRsjJI/2I5mHonlZdWIGZjz8+EUH2YM8
         e8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910519; x=1795515319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yoswokMSE2+p37K+PFvtRqKoa8vKZdGiVdI8IOK5pvU=;
        b=Vs2mv9qVXRomUS9hTco6e44xql8LWiPV9Nyvrza+GbO9CnI5ci/8rxoi4zu0O0JaBz
         E8LOSRr2Jz2I69MQ81nXaWeDZBAhlMnV6umBkFDa6UE6/87++/TARz6RwU/L7gdYvxvO
         ZvQXYxK8StCrR04K8eTS8EU6xFcCPiBTiIQ2dBcZjFwDJt/EsrvF0eakKsIJdeqEgGF1
         O4NhDSzpJBQllpt479WMQ3QX79oNZK582tEXVXukd7dvwlKyd21gOjiwLeGntokQjLnP
         iHa9IgGFWI6wRoukhnXVf7SNfy3k9ITSUC4oj8cBGB2BusdtWwL5z6gSTfiPZMwTUaAW
         7f5Q==
X-Gm-Message-State: APuU4Z8E4Q5/NM3YTFZMTcpQmhOzva6LxdCNVKmLjK1I0nWbm2rG/HSh
	5JirMcz9ksyq6Dg+7OGggyrYPehrBFsgcmvTYG4idTh7b9UPUKIDKdeaI28fmLrGEwZAJe8bHaZ
	3SQRM8b8=
X-Gm-Gg: AYBFou0F+JKe2mWkG1RMeSJ50jwK6s+lL0x34tuTfNnvm2rDKWEDQjjkYSmmp1xZQpf
	5gV3SfQ/SDAS2AdSARVWMXx7LEaf8mXGt9OCSd+paMGL+/ATqvVmmf8oAa3wwGsW222Lmiw+c1g
	ayUA17pUS5PMAWlye9w8saKzOMpM+dxCVKUXiBVNOxFSEJ2uvHLGedoWwo/R77zYfYFQtSnrj8W
	0a1+vszeuqJGsNIFpvUM0WdZ+kRu8drwH/Dc0CbyTs6D3QcgyMs9MoWm+43rPCCDtCyaaoi6sri
	Z481wEzilAxSmG8toLlzqXrNSoQNsp8dRnDcVxGkgxybfEA0+rPBOl1NXFLvC8t68xYY7GpuKZw
	vhNl7L3M43WzVOIB3Hnn7Ta5jzmENQ5SODe/gVWF2ge9sqV536K1P1tNd0tcnuw4n7AkE/7TmzU
	OMxYh6cT3fyqfI2XFOVhTr2+NnjUeQTZzQDrk+ztUsL3EsDEUWeACJT1zfeyXdnYomU+p2LXx+o
	ltg3MhMhhnuDtAua9/2e2AwVM0RPMWn3qo1qqho/OhcHDXhn3FvfKwCMH795pyvLoRzJlYZnqsF
	jU8C9sE95Pvg1YhOpIq9MvseO8gIeDxPV5kVvsIyF9HMivSbklqtn8bwWPzRWZG/FOrhfF+TQK0
	jzscUY15IdisXkKSER+kqk4fXPfK12wTmbgRBGA==
X-Received: by 2002:a05:701b:2912:b0:1b2:490b:6fdd with SMTP id a92af1059eb24-1b5030ad368mr13073556c88.24.1794910519452;
        Tue, 17 Nov 2026 02:15:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:cd44:de10:449c:756c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316e008sm39965539c88.6.2026.11.17.02.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:15:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] scsi: libiscsi_tcp: do not accept a Data-In for a finished command
Date: Tue, 17 Nov 2026 19:15:00 +0900
Message-ID: <20261117101500.1894608-5-yhlee@isslab.korea.ac.kr>
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

iscsi_tcp_hdr_dissect() aims the receive segment at a command's
scatterlist and drops back_lock before any of the data has been copied:

	struct scsi_data_buffer *sdb = &task->sc->sdb;
	...
	rc = iscsi_segment_seek_sg(&tcp_conn->in.segment, sdb->table.sgl,
				   sdb->table.nents, ...);
	spin_unlock(&session->back_lock);

The copy itself runs in iscsi_tcp_recv_skb(), once per skb, so a Data-In
that does not arrive in one piece leaves the receive path with a pointer
into the command.  The lookup never asks whether that command is still
there to be written into: it tests only whether the slot has been sent.
A target that keeps sending data after it has sent the status is
therefore believed, and the copy lands in a scatterlist that
iscsi_free_task() has already given back with scsi_done().

The SCSI Response arm of __iscsi_complete_pdu() has the same hole
without the copy: iscsi_scsi_cmd_rsp() writes sc->result and the sense
buffer before iscsi_complete_task() absorbs the duplicate, so a second
response can report a command that succeeded as having failed.

So refuse a Data-In whose task is not running, and refuse a response for
a task that has already been completed.  Testing the state is enough,
because while a copy is pending only the receive path can finish the
task: a SCSI Response and the TMF response of an abort both arrive on
this connection behind the unfinished Data-In, and on iscsi_tcp a
connection stop suspends the receive side before it fails the tasks -
iscsi_sw_tcp_release_conn() calls iscsi_suspend_rx() and only then does
iscsi_conn_stop() call fail_scsi_tasks().

iscsi_tcp_r2t_rsp() is deliberately left alone: it looks a completed task
up in order to ignore the R2T rather than fail the connection, which is
why the tests are at these two call sites and not in
iscsi_itt_to_ctask().

Reproduced against a userspace target reached through a proxy that sends
one more Data-In for a read it has already answered, split in two with a
gap, and a test-only delay that holds the transmit thread's reference
until that gap.  Every boot is a fresh one, under KASAN.

The extra Data-In was accepted and the copy resumed into the freed
scatterlist in 8 of the 8 boots where the injection reached the measured
read and the window opened; with this patch, in 0 of 5, the PDU being
refused with ISCSI_ERR_BAD_ITT and the session recovering.  Boots where
the window did not open - the receive softirq landed on the cpu the
delay was holding, or the proxy named a different read - are counted
separately: 10 of 18 and 3 of 8.  The first report without this patch:

[   23.283180] BUG: KASAN: slab-use-after-free in iscsi_tcp_segment_done+0xe4b/0x1490
[   23.283185] Read of size 4 at addr ffff88800d7ccc8c by task swapper/0/0
[   23.283190]
[   23.283192] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G    B               7.4.0-rc2-00474-g07fe4a1940c5-dirty #9 PREEMPT(lazy)
[   23.283200] Tainted: [B]=BAD_PAGE
[   23.283202] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   23.283205] Call Trace:
[   23.283207]  <IRQ>
[   23.283209]  dump_stack_lvl+0x53/0x70
[   23.283214]  print_report+0xd0/0x630
[   23.283220]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[   23.283227]  ? iscsi_tcp_segment_done+0xe4b/0x1490
[   23.283232]  kasan_report+0xce/0x100
[   23.283238]  ? iscsi_tcp_segment_done+0xe4b/0x1490
[   23.283243]  iscsi_tcp_segment_done+0xe4b/0x1490
[   23.283248]  ? kasan_check_range+0x105/0x1b0
[   23.283256]  iscsi_tcp_recv_skb+0x5d8/0xec0
[   23.283262]  ? __pfx_iscsi_tcp_recv_skb+0x10/0x10
[   23.283266]  ? __pfx_iscsi_dbg_trace+0x10/0x10
[   23.283275]  ? kernel_text_address+0xa7/0x130
[   23.283282]  ? __pfx_selinux_parse_skb.constprop.0+0x10/0x10
[   23.283292]  iscsi_sw_tcp_recv+0x12f/0x390
[   23.283297]  ? __pfx_iscsi_sw_tcp_recv+0x10/0x10
[   23.283303]  ? __pfx_selinux_netlbl_sock_rcv_skb+0x10/0x10
[   23.283309]  __tcp_read_sock+0x1ab/0x810
[   23.283316]  ? __pfx_iscsi_sw_tcp_recv+0x10/0x10
[   23.283321]  ? __pfx___tcp_read_sock+0x10/0x10
[   23.283328]  iscsi_sw_tcp_data_ready+0x18b/0x510
[   23.283333]  ? __pfx_iscsi_sw_tcp_data_ready+0x10/0x10
[   23.283339]  ? tcp_try_rmem_schedule+0x17f/0x1390
[   23.283344]  ? tcp_grow_window+0xd6/0x7e0
[   23.283348]  ? tcp_event_data_recv+0x36a/0x7b0
[   23.283354]  tcp_data_queue+0x1f2d/0x4b70
[   23.283361]  ? __pfx_tcp_data_queue+0x10/0x10
[   23.283367]  ? __pfx_tcp_urg+0x10/0x10
[   23.283373]  ? kvm_clock_get_cycles+0x19/0x40
[   23.283380]  tcp_rcv_established+0x8a8/0x3990
[   23.283387]  ? security_sock_rcv_skb+0x2b/0x40
[   23.283395]  ? sk_filter_trim_cap+0x400/0x980
[   23.283402]  ? __pfx_tcp_inbound_hash+0x10/0x10
[   23.283409]  ? __pfx_tcp_rcv_established+0x10/0x10
[   23.283416]  ? __pfx_sk_filter_trim_cap+0x10/0x10
[   23.283421]  ? _raw_spin_lock+0x80/0xe0
[   23.283427]  tcp_v4_do_rcv+0x45b/0x970
[   23.283433]  ? tcp_v4_fill_cb+0x26/0x400
[   23.283438]  tcp_v4_rcv+0x223d/0x3b90
[   23.283456]  ? __pfx_raw_local_deliver+0x10/0x10
[   23.283462]  ? __pfx_tcp_v4_rcv+0x10/0x10
[   23.283468]  ? ip_protocol_deliver_rcu+0x61/0x2e0
[   23.283477]  ? __pfx_raw_local_deliver+0x10/0x10
[   23.283482]  ? get_stack_info_noinstr+0x16/0xe0
[   23.283488]  ? get_stack_info+0x2a/0x90
[   23.283493]  ip_protocol_deliver_rcu+0x61/0x2e0
[   23.283502]  ip_local_deliver_finish+0x329/0x4b0
[   23.283510]  ip_local_deliver+0x18f/0x2d0
[   23.283518]  ? __pfx_ip_local_deliver+0x10/0x10
[   23.283525]  ? get_stack_info_noinstr+0x16/0xe0
[   23.283531]  ? get_stack_info+0x2a/0x90
[   23.283536]  ? ipv4_dst_check+0x10a/0x160
[   23.283542]  ? ip_rcv_finish_core+0x1d0c/0x1dd0
[   23.283550]  ip_sublist_rcv_finish+0x138/0x1b0
[   23.283558]  ip_sublist_rcv+0x3ae/0x670
[   23.283567]  ? __pfx_ip_sublist_rcv+0x10/0x10
[   23.283574]  ? common_startup_64+0x13e/0x158
[   23.283582]  ? __asan_memset+0x23/0x50
[   23.283590]  ? ip_rcv_core+0x4e9/0xce0
[   23.283598]  ip_list_rcv+0x266/0x380
[   23.283605]  ? __kasan_mempool_poison_object+0xac/0x150
[   23.283611]  ? __pfx_ip_list_rcv+0x10/0x10
[   23.283618]  ? e1000_clean+0x7eb/0x25a0
[   23.283623]  ? handle_softirqs+0x1b3/0x600
[   23.283628]  ? __irq_exit_rcu+0xfc/0x160
[   23.283633]  ? common_interrupt+0x7f/0x90
[   23.283638]  ? asm_common_interrupt+0x26/0x40
[   23.283643]  ? pv_native_safe_halt+0xf/0x20
[   23.283650]  __netif_receive_skb_list_core+0x5c3/0x860
[   23.283658]  ? __pfx___netif_receive_skb_list_core+0x10/0x10
[   23.283667]  netif_receive_skb_list_internal+0x553/0xbb0
[   23.283674]  ? dma_map_phys+0xb0/0x290
[   23.283682]  ? __pfx_netif_receive_skb_list_internal+0x10/0x10
[   23.283689]  ? e1000_alloc_rx_buffers+0x32c/0xd70
[   23.283696]  ? gro_receive_skb+0x7aa/0x960
[   23.283705]  napi_complete_done+0x1ab/0x7f0
[   23.283712]  ? __pfx_napi_complete_done+0x10/0x10
[   23.283719]  ? __pfx_e1000_clean_rx_irq+0x10/0x10
[   23.283724]  e1000_clean+0x816/0x25a0
[   23.283732]  ? __pfx_e1000_clean+0x10/0x10
[   23.283737]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[   23.283744]  ? call_timer_fn+0x29/0x230
[   23.283752]  __napi_poll+0x9c/0x520
[   23.283758]  ? __pfx_tcp_orphan_update+0x10/0x10
[   23.283766]  net_rx_action+0x8f1/0xfb0
[   23.283774]  ? __pfx_net_rx_action+0x10/0x10
[   23.283781]  ? sched_balance_domains+0x260/0xc20
[   23.283788]  ? _raw_spin_lock+0x80/0xe0
[   23.283794]  handle_softirqs+0x1b3/0x600
[   23.283800]  ? __pfx_handle_softirqs+0x10/0x10
[   23.283806]  __irq_exit_rcu+0xfc/0x160
[   23.283811]  common_interrupt+0x7f/0x90
[   23.283817]  </IRQ>
[   23.283819]  <TASK>
[   23.283821]  asm_common_interrupt+0x26/0x40
[   23.283826] RIP: 0010:pv_native_safe_halt+0xf/0x20
[   23.283833] Code: 04 ce 00 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 93 44 18 00 fb f4 <e9> 8c 39 02 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
[   23.283838] RSP: 0018:ffffffff85607d10 EFLAGS: 00000216
[   23.283841] RAX: ffff8880e53a8000 RBX: ffffffff85614700 RCX: ffffffff846d0c6b
[   23.283844] RDX: ffffed100d8462a3 RSI: 0000000000000004 RDI: 000000000000d50c
[   23.283847] RBP: fffffbfff0ac28e0 R08: 0000000000000001 R09: ffffed100d8462a2
[   23.283850] R10: ffff88806c231513 R11: 0000000000000002 R12: 0000000000000000
[   23.283853] R13: 0000000000000000 R14: 1ffffffff0ac0fa6 R15: dffffc0000000000
[   23.283857]  ? ct_kernel_exit.constprop.0+0x9b/0xc0
[   23.283865]  default_idle+0x9/0x10
[   23.283873]  default_idle_call+0x39/0x60
[   23.283880]  do_idle+0x37b/0x560
[   23.283888]  ? __pfx_do_idle+0x10/0x10
[   23.283896]  cpu_startup_entry+0x4f/0x60
[   23.283904]  rest_init+0x186/0x1b0
[   23.283912]  ? __pfx_acpi_read_bit_register+0x10/0x10
[   23.283921]  ? __pfx_rest_init+0x10/0x10
[   23.283931]  ? __pfx_kernel_init+0x10/0x10
[   23.283939]  ? acpi_enable_subsystem+0x24b/0x470
[   23.283947]  start_kernel+0x354/0x3b0
[   23.283951]  x86_64_start_reservations+0x18/0x30
[   23.283959]  x86_64_start_kernel+0x111/0x120
[   23.283966]  common_startup_64+0x13e/0x158
[   23.283976]  </TASK>
[   23.283978]
[   23.283980] Allocated by task 26:
[   23.283984]  kasan_save_stack+0x33/0x60
[   23.283989]  kasan_save_track+0x14/0x30
[   23.283993]  __kasan_slab_alloc+0x6e/0x70
[   23.283998]  kmem_cache_alloc_noprof+0x10e/0x340
[   23.284006]  mempool_alloc_noprof+0xcd/0x180
[   23.284015]  __sg_alloc_table+0x23e/0x410
[   23.284021]  sg_alloc_table_chained+0x47/0x180
[   23.284030]  scsi_alloc_sgtables+0x17f/0xc50
[   23.284037]  sd_init_command+0x20e/0x2e70
[   23.284048]  scsi_queue_rq+0x1070/0x2f60
[   23.284054]  blk_mq_dispatch_rq_list+0x390/0x2100
[   23.284064]  __blk_mq_sched_dispatch_requests+0xa7a/0x1550
[   23.284072]  blk_mq_sched_dispatch_requests+0xa7/0x140
[   23.284078]  blk_mq_run_work_fn+0x105/0x150
[   23.284084]  process_one_work+0x697/0x1060
[   23.284093]  worker_thread+0x45b/0xd10
[   23.284099]  kthread+0x2c8/0x3b0
[   23.284105]  ret_from_fork+0x36e/0x5a0
[   23.284111]  ret_from_fork_asm+0x1a/0x30
[   23.284119]
[   23.284120] Freed by task 71:
[   23.284123]  kasan_save_stack+0x33/0x60
[   23.284127]  kasan_save_track+0x14/0x30
[   23.284131]  kasan_save_free_info+0x3b/0x60
[   23.284138]  __kasan_slab_free+0x43/0x70
[   23.284142]  kmem_cache_free+0xba/0x3a0
[   23.284149]  mempool_free+0xbd/0x110
[   23.284154]  __sg_free_table+0xa8/0x170
[   23.284159]  scsi_end_request+0x329/0x5d0
[   23.284164]  scsi_io_completion+0xa3/0xda0
[   23.284171]  blk_complete_reqs+0xa4/0xe0
[   23.284175]  handle_softirqs+0x1b3/0x600
[   23.284180]  do_softirq+0x3d/0x60
[   23.284185]  __local_bh_enable_ip+0x6a/0x70
[   23.284190]  process_one_work+0x697/0x1060
[   23.284197]  worker_thread+0x45b/0xd10
[   23.284203]  kthread+0x2c8/0x3b0
[   23.284208]  ret_from_fork+0x36e/0x5a0
[   23.284213]  ret_from_fork_asm+0x1a/0x30
[   23.284219]
[   23.284220] The buggy address belongs to the object at ffff88800d7ccc80
[   23.284220]  which belongs to the cache sgpool-16 of size 512
[   23.284226] The buggy address is located 12 bytes inside of
[   23.284226]  freed 512-byte region [ffff88800d7ccc80, ffff88800d7cce80)
[   23.284232]
[   23.284233] The buggy address belongs to the physical page:
[   23.284236] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88800d7ccf00 pfn:0xd7cc
[   23.284241] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   23.284245] flags: 0x100000000000240(workingset|head|node=0|zone=1)
[   23.284250] page_type: f5(slab)
[   23.284255] raw: 0100000000000240 ffff888007254640 ffff888007f2c110 ffff888007f2c110
[   23.284260] raw: ffff88800d7ccf00 0000000000190006 00000000f5000000 0000000000000000
[   23.284265] head: 0100000000000240 ffff888007254640 ffff888007f2c110 ffff888007f2c110
[   23.284269] head: ffff88800d7ccf00 0000000000190006 00000000f5000000 0000000000000000
[   23.284274] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
[   23.284278] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   23.284281] page dumped because: kasan: bad access detected
[   23.284283]
[   23.284284] Memory state around the buggy address:
[   23.284287]  ffff88800d7ccb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   23.284290]  ffff88800d7ccc00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   23.284294] >ffff88800d7ccc80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   23.284297]                       ^
[   23.284299]  ffff88800d7ccd00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   23.284303]  ffff88800d7ccd80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   23.284305] ==================================================================

Baseline behaviour is unchanged: discovery, login, write, read-back
compare, a 1 MiB O_DIRECT read, NOP pings and logout pass on iscsi_tcp
and on iSER, and so does an abort TMF driven by swallowing a write
response.  Cutting the connection in the middle of a Data-In, with the
copy pending, leaves no report and no stuck command either: the slot
goes back inside a millisecond of the connection error and the read is
retried once the session is back.  cxgbi needs vendor hardware and was
not run; its path through iscsi_tcp_recv_skb() was followed in the
source only.

Fixes: da32dd681f7a ("[SCSI] iscsi_tcp: rewrite recv path")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/libiscsi.c     | 2 +-
 drivers/scsi/libiscsi_tcp.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index af454454c08699..f8b3b597d0154a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1312,7 +1312,7 @@ int __iscsi_complete_pdu(struct iscsi_session *session, struct iscsi_conn *conn,
 	case ISCSI_OP_SCSI_CMD_RSP:
 	case ISCSI_OP_SCSI_DATA_IN:
 		task = iscsi_itt_to_ctask(session, conn, hdr->itt);
-		if (!task)
+		if (!task || task->state == ISCSI_TASK_COMPLETED)
 			return ISCSI_ERR_BAD_ITT;
 		task->last_xfer = jiffies;
 		break;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 20ec3ba45067f8..eeb853c6b66d49 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -713,7 +713,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	case ISCSI_OP_SCSI_DATA_IN:
 		spin_lock(&session->back_lock);
 		task = iscsi_itt_to_ctask(session, conn, hdr->itt);
-		if (!task)
+		/* The copy below outlives back_lock, so the command must be live. */
+		if (!task || task->state != ISCSI_TASK_RUNNING)
 			rc = ISCSI_ERR_BAD_ITT;
 		else
 			rc = iscsi_tcp_data_in(conn, task);
-- 
2.43.0

