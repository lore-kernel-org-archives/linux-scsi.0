From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: segfault the use xen and multipath devices
Date: Tue, 15 Nov 2011 14:00:38 +0400
Message-ID: <CACaajQvxCnXNTKcgF=wYfQsRyJOJAhT9vjB=GT3DvkSfvNBdQw@mail.gmail.com>
References: <CACaajQtfbG=qs5c3RKQUUQ4d5UhQ=mB6o78rQw7hBMpQ0WD8tg@mail.gmail.com>
 <CAO+b5-r2j2DykAQ3vK06FO7=4nEhRsrC-gwGpUv-=8_zFhXKXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45223 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab1KOKAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2011 05:00:55 -0500
Received: by wyh15 with SMTP id 15so6832893wyh.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2011 02:00:54 -0800 (PST)
In-Reply-To: <CAO+b5-r2j2DykAQ3vK06FO7=4nEhRsrC-gwGpUv-=8_zFhXKXg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org

2011/11/10 Bart Van Assche <bvanassche@acm.org>:
> On Thu, Nov 10, 2011 at 10:52 AM, Vasiliy Tolstov <v.tolstov@selfip.ru> wrote:
>> and in dmesg i see segfault: BUG: unable to handle kernel NULL pointer
>> dereference at 0000000000000038
>>
>> afte that scsi doing offline second target: scsi 5:0:0:1: Device
>> offlined - not ready after error recovery
>>
>> after that i see: invalid opcode: 0000 [#2] SMP
>>
>> Does this messages says, that in kernel scsi subsystem not works fine
>> or they says about xen related problems?
>
> Does this patch help: http://marc.info/?l=linux-scsi&m=131680195721932 ?
>
> Bart.
>

Provided patch not solve my problem, another die:
[ 1116.770956] scsi host3: SRP abort called
[ 1116.776450] device-mapper: multipath: Failing path 8:16.
[ 1116.780413] device-mapper: multipath: Failing path 8:0.
[ 1116.784288] device-mapper: multipath: Failing path 8:32.
[ 1116.788277] device-mapper: multipath: Failing path 8:80.
[ 1116.792256] device-mapper: multipath: Failing path 8:48.
[ 1116.796324] device-mapper: multipath: Failing path 8:64.
[ 1116.820330] end_request: I/O error, dev dm-0, sector 0
[ 1116.820442] Buffer I/O error on device dm-0, logical block 0
[ 1116.820545] Buffer I/O error on device dm-0, logical block 1
[ 1116.820652] Buffer I/O error on device dm-0, logical block 2
[ 1116.820727] end_request: I/O error, dev dm-0, sector 0
[ 1116.820733] Buffer I/O error on device dm-0, logical block 0
[ 1116.820739] Buffer I/O error on device dm-0, logical block 1
[ 1116.820811] end_request: I/O error, dev dm-0, sector 3515228760
[ 1116.820819] Buffer I/O error on device dm-0, logical block 878807190
[ 1116.820854] end_request: I/O error, dev dm-0, sector 3515228760
[ 1116.820858] Buffer I/O error on device dm-0, logical block 878807190
[ 1116.820904] end_request: I/O error, dev dm-0, sector 0
[ 1116.820908] Buffer I/O error on device dm-0, logical block 0
[ 1116.820917] Buffer I/O error on device dm-0, logical block 1
[ 1116.821000] end_request: I/O error, dev dm-0, sector 0
[ 1116.821003] Buffer I/O error on device dm-0, logical block 0
[ 1116.822043] end_request: I/O error, dev dm-0, sector 24
[ 1116.826036] end_request: I/O error, dev dm-1, sector 0
[ 1116.826193] end_request: I/O error, dev dm-1, sector 0
[ 1116.826375] end_request: I/O error, dev dm-1, sector 2929357400
[ 1116.826518] end_request: I/O error, dev dm-1, sector 2929357400
[ 1116.826671] end_request: I/O error, dev dm-1, sector 0
[ 1116.826851] end_request: I/O error, dev dm-1, sector 0
[ 1116.827051] end_request: I/O error, dev dm-1, sector 24
[ 1116.830046] end_request: I/O error, dev dm-2, sector 0
[ 1116.830218] end_request: I/O error, dev dm-2, sector 0
[ 1116.830387] end_request: I/O error, dev dm-2, sector 3515228760
[ 1116.830545] end_request: I/O error, dev dm-2, sector 3515228760
[ 1116.830716] end_request: I/O error, dev dm-2, sector 0
[ 1116.830890] end_request: I/O error, dev dm-2, sector 0
[ 1116.831064] end_request: I/O error, dev dm-2, sector 24
[ 1116.869530] end_request: I/O error, dev dm-0, sector 0
[ 1116.869694] end_request: I/O error, dev dm-0, sector 0
[ 1116.869884] end_request: I/O error, dev dm-0, sector 3515228760
[ 1116.870048] end_request: I/O error, dev dm-0, sector 3515228760
[ 1116.870209] end_request: I/O error, dev dm-0, sector 0
[ 1116.870400] end_request: I/O error, dev dm-0, sector 0
[ 1116.870574] end_request: I/O error, dev dm-0, sector 24
[ 1116.874661] end_request: I/O error, dev dm-1, sector 0
[ 1116.874823] end_request: I/O error, dev dm-1, sector 0
[ 1116.874998] end_request: I/O error, dev dm-1, sector 2929357400
[ 1116.875167] end_request: I/O error, dev dm-1, sector 2929357400
[ 1116.875385] end_request: I/O error, dev dm-1, sector 0
[ 1116.875615] end_request: I/O error, dev dm-1, sector 0
[ 1116.875774] end_request: I/O error, dev dm-1, sector 24
[ 1116.878236] end_request: I/O error, dev dm-2, sector 0
[ 1116.878398] end_request: I/O error, dev dm-2, sector 0
[ 1116.878563] end_request: I/O error, dev dm-2, sector 3515228760
[ 1116.878707] end_request: I/O error, dev dm-2, sector 3515228760
[ 1116.878864] end_request: I/O error, dev dm-2, sector 0
[ 1116.879043] end_request: I/O error, dev dm-2, sector 0
[ 1116.879200] end_request: I/O error, dev dm-2, sector 24
[ 1119.831908] scsi host2: ib_srp: failed send status 12
[ 1119.832014] scsi host2: ib_srp: failed send status 5
[ 1119.832113] scsi host3: ib_srp: failed send status 12
[ 1119.832212] scsi host2: ib_srp: failed send status 5
[ 1119.832310] scsi host3: ib_srp: failed send status 5
[ 1119.832407] scsi host2: ib_srp: failed send status 5
[ 1119.832505] scsi host3: ib_srp: failed send status 5
[ 1121.770852] scsi host3: SRP abort called
[ 1121.770949] scsi host3: SRP abort called
[ 1121.771048] scsi host3: SRP reset_device called
[ 1121.771144] scsi host3: SRP reset_device called
[ 1121.771239] scsi host3: SRP reset_device called
[ 1121.771337] scsi host3: ib_srp: SRP reset_host called state 0 qp_err 1
[ 1141.774844] scsi host3: SRP abort called
[ 1141.774943] scsi host3: SRP reset_device called
[ 1141.775039] scsi host3: ib_srp: SRP reset_host called state 0 qp_err 1
[ 1142.770859] scsi host2: SRP abort called
[ 1142.770956] scsi host2: SRP abort called
[ 1142.771050] scsi host2: SRP abort called
[ 1142.771143] scsi host2: SRP abort called
[ 1142.771235] scsi host2: SRP abort called
[ 1142.771333] scsi host2: SRP reset_device called
[ 1142.771429] scsi host2: SRP reset_device called
[ 1142.771524] scsi host2: SRP reset_device called
[ 1142.771621] scsi host2: ib_srp: SRP reset_host called state 0 qp_err 1
[ 1149.904557] scsi host2: ib_srp: Got failed path rec status -22
[ 1149.904675] scsi host2: ib_srp: Path record query failed
[ 1149.904780] scsi host2: ib_srp: reconnect failed (-22), removing target port.
[ 1149.906138] scsi host3: ib_srp: Got failed path rec status -22
[ 1149.906258] scsi host3: ib_srp: Path record query failed
[ 1149.906359] scsi host3: ib_srp: reconnect failed (-22), removing target port.
[ 1149.950999] scsi: killing requests for dead queue
[ 1149.983013] scsi: killing requests for dead queue
[ 1150.015030] scsi: killing requests for dead queue
[ 1150.046977] scsi: killing requests for dead queue
[ 1150.079151] scsi: killing requests for dead queue
[ 1150.111163] scsi: killing requests for dead queue
[ 1151.778872] scsi 3:0:0:2: Device offlined - not ready after error recovery
[ 1151.779003] invalid opcode: 0000 [#1] SMP
[ 1151.779202] last sysfs file:
/sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/host3/target3:0:0/3:0:0:2/block/sdf/uevent
[ 1151.779347] CPU 15
[ 1151.779485] Modules linked in: dm_round_robin sd_mod crc_t10dif
nls_utf8 cifs bonding ip6table_filter ip6_tables iptable_filter
ip_tables ebtable_nat ebtables x_tables xen_evtchn xenfs dm_multipath
dm_mod scsi_dh ib_sdp ib_srp scsi_transport_srp scsi_tgt ib_ipoib
ib_umad rdma_ucm rdma_cm ib_cm iw_cm ib_addr ib_sa ib_uverbs mlx4_ib
ib_mad ib_core md_mod snd_pcm ata_generic snd_timer snd evdev
soundcore ata_piix snd_page_alloc tpm_tis libata tpm pcspkr tpm_bios
scsi_mod serio_raw button processor acpi_processor squashfs loop
aufs(C) ide_generic ide_core mlx4_en uhci_hcd ehci_hcd usbcore
nls_base mlx4_core igb thermal dca thermal_sys
[ 1151.783206] Pid: 5368, comm: scsi_eh_3 Tainted: G         C
2.6.32-5-xen-amd64 #1 ProLiant DL170h G6
[ 1151.783338] RIP: e030:[<ffffffff8147b595>]  [<ffffffff8147b595>]
0xffffffff8147b595
[ 1151.783513] RSP: e02b:ffff8801110f5d28  EFLAGS: 00010086
[ 1151.783605] RAX: 00000000ffc7b7f9 RBX: ffff8801035818f0 RCX: ffff880103581a10
[ 1151.783702] RDX: ffff880103581a10 RSI: ffff8801035818f0 RDI: ffff88012f251a70
[ 1151.783800] RBP: ffff88012f251a70 R08: ffff88012f251a70 R09: 0000000000000000
[ 1151.783897] R10: 0000160000000000 R11: ffff8801110f5ea0 R12: ffff88012f251a70
[ 1151.783995] R13: ffff880135129800 R14: ffff880103488000 R15: ffff8801090be828
[ 1151.784095] FS:  00007f8eccbb17a0(0000) GS:ffff880028212000(0000)
knlGS:0000000000000000
[ 1151.784223] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1151.784316] CR2: 00000000025cf178 CR3: 00000001352c5000 CR4: 0000000000002660
[ 1151.784414] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1151.784512] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1151.784610] Process scsi_eh_3 (pid: 5368, threadinfo
ffff8801110f4000, task ffff88011101c600)
[ 1151.784738] Stack:
[ 1151.784818]  ffffffff811782f5 0000000000000200 0000000000000200
0000000000001057
[ 1151.785053] <0> ffffffffa010dd13 000000002f251a70 0000000000000000
ffff8801035818f0
[ 1151.785407] <0> ffff880135129800 0000000000000000 ffff8801035818f0
0000000000080000
[ 1151.785834] Call Trace:
[ 1151.785923]  [<ffffffff811782f5>] ? elv_requeue_request+0x53/0x6d
[ 1151.786023]  [<ffffffffa010dd13>] ? __scsi_queue_insert+0xbe/0xe5 [scsi_mod]
[ 1151.786125]  [<ffffffffa010e125>] ? scsi_io_completion+0x3eb/0x3fa [scsi_mod]
[ 1151.786227]  [<ffffffffa010abb0>] ? scsi_eh_flush_done_q+0xe3/0x104
[scsi_mod]
[ 1151.786356]  [<ffffffffa010bdc3>] ? scsi_error_handler+0x3cb/0x5b5 [scsi_mod]
[ 1151.786458]  [<ffffffffa010b9f8>] ? scsi_error_handler+0x0/0x5b5 [scsi_mod]
[ 1151.786558]  [<ffffffff81065c69>] ? kthread+0x79/0x81
[ 1151.786653]  [<ffffffff81012baa>] ? child_rip+0xa/0x20
[ 1151.786745]  [<ffffffff81011d61>] ? int_ret_from_sys_call+0x7/0x1b
[ 1151.786841]  [<ffffffff8101251d>] ? retint_restore_args+0x5/0x6
[ 1151.786937]  [<ffffffff8100ef4f>] ? xen_restore_fl_direct_end+0x0/0x1
[ 1151.787033]  [<ffffffff81012ba0>] ? child_rip+0x0/0x20
[ 1151.787124] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 e0 c1 47 81 ff ff ff ff 40 c6 47 81 ff ff ff ff 0d
79 17 81 ff <ff> ff ff b0 b5 47 81 ff ff ff ff 00 00 00 00 00 00 00 00
00 00
[ 1151.790294] RIP  [<ffffffff8147b595>] 0xffffffff8147b595
[ 1151.790432]  RSP <ffff8801110f5d28>
[ 1151.790519] ---[ end trace 0facc831a040d284 ]---
[ 1152.774945] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000038
[ 1152.775190] IP: [<ffffffff811782e4>] elv_requeue_request+0x42/0x6d
[ 1152.775350] PGD 0
[ 1152.775488] Oops: 0000 [#2] SMP
[ 1152.775683] last sysfs file:
/sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/host5/scsi_host/host5/local_ib_port
[ 1152.775827] CPU 11
[ 1152.775965] Modules linked in: dm_round_robin sd_mod crc_t10dif
nls_utf8 cifs bonding ip6table_filter ip6_tables iptable_filter
ip_tables ebtable_nat ebtables x_tables xen_evtchn xenfs dm_multipath
dm_mod scsi_dh ib_sdp ib_srp scsi_transport_srp scsi_tgt ib_ipoib
ib_umad rdma_ucm rdma_cm ib_cm iw_cm ib_addr ib_sa ib_uverbs mlx4_ib
ib_mad ib_core md_mod snd_pcm ata_generic snd_timer snd evdev
soundcore ata_piix snd_page_alloc tpm_tis libata tpm pcspkr tpm_bios
scsi_mod serio_raw button processor acpi_processor squashfs loop
aufs(C) ide_generic ide_core mlx4_en uhci_hcd ehci_hcd usbcore
nls_base mlx4_core igb thermal dca thermal_sys
[ 1152.780034] Pid: 5365, comm: scsi_eh_2 Tainted: G      D  C
2.6.32-5-xen-amd64 #1 ProLiant DL170h G6
[ 1152.780174] RIP: e030:[<ffffffff811782e4>]  [<ffffffff811782e4>]
elv_requeue_request+0x42/0x6d
[ 1152.780351] RSP: e02b:ffff8801386ddd30  EFLAGS: 00010002
[ 1152.780443] RAX: 0000000000000000 RBX: ffff880102863110 RCX: ffff880102863230
[ 1152.780541] RDX: ffff880102863230 RSI: ffff880102863110 RDI: ffff88012f250000
[ 1152.780638] RBP: ffff88012f250000 R08: ffff88012f250000 R09: 0000000000000000
[ 1152.780736] R10: 0000160000000000 R11: 0000000000000001 R12: ffff88012f250000
[ 1152.780834] R13: ffff880135bb3c00 R14: ffff8801093d8000 R15: ffff8801090b9c28
[ 1152.780934] FS:  00007f1fcf595700(0000) GS:ffff88002819a000(0000)
knlGS:0000000000000000
[ 1152.781062] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1152.781155] CR2: 0000000000000038 CR3: 0000000001001000 CR4: 0000000000002660
[ 1152.781252] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1152.781350] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1152.781448] Process scsi_eh_2 (pid: 5365, threadinfo
ffff8801386dc000, task ffff88011101db00)
[ 1152.781576] Stack:
[ 1152.781656]  0000000000000200 0000000000000200 0000000000001057
ffffffffa010dd13
[ 1152.781892] <0> 000000002f250000 0000000000000000 ffff880102863110
ffff880135bb3c00
[ 1152.782245] <0> 0000000000000000 ffff880102863110 0000000000080000
ffffffffa010e125
[ 1152.782672] Call Trace:
[ 1152.782760]  [<ffffffffa010dd13>] ? __scsi_queue_insert+0xbe/0xe5 [scsi_mod]
[ 1152.782862]  [<ffffffffa010e125>] ? scsi_io_completion+0x3eb/0x3fa [scsi_mod]
[ 1152.782964]  [<ffffffffa010abb0>] ? scsi_eh_flush_done_q+0xe3/0x104
[scsi_mod]
[ 1152.783093]  [<ffffffffa010bdc3>] ? scsi_error_handler+0x3cb/0x5b5 [scsi_mod]
[ 1152.783195]  [<ffffffffa010b9f8>] ? scsi_error_handler+0x0/0x5b5 [scsi_mod]
[ 1152.783295]  [<ffffffff81065c69>] ? kthread+0x79/0x81
[ 1152.783389]  [<ffffffff81012baa>] ? child_rip+0xa/0x20
[ 1152.783482]  [<ffffffff81011d61>] ? int_ret_from_sys_call+0x7/0x1b
[ 1152.783577]  [<ffffffff8101251d>] ? retint_restore_args+0x5/0x6
[ 1152.783673]  [<ffffffff8100ef4f>] ? xen_restore_fl_direct_end+0x0/0x1
[ 1152.783769]  [<ffffffff81012ba0>] ? child_rip+0x0/0x20
[ 1152.783859] Code: 01 74 04 a8 10 74 35 25 01 00 04 00 ff c8 0f 95
c0 83 e0 01 48 05 ec 00 00 00 ff 4c 85 04 f6 43 48 20 74 18 48 8b 45
18 48 8b 00 <48> 8b 40 38 48 85 c0 74 08 48 89 de 48 89 ef ff d0 81 63
48 ff
[ 1152.787020] RIP  [<ffffffff811782e4>] elv_requeue_request+0x42/0x6d
[ 1152.787162]  RSP <ffff8801386ddd30>
[ 1152.787247] CR2: 0000000000000038
[ 1152.787333] ---[ end trace 0facc831a040d285 ]---

-- 
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
