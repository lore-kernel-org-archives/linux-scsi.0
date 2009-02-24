From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: QLA2xxx on Dell M600
Date: Tue, 24 Feb 2009 12:00:10 +0100
Message-ID: <169201c9966f$0fea9d60$0a00a8c0@ALDI2>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3.igne.de ([82.135.108.119]:50141 "EHLO mail3.igne.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZBXLAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2009 06:00:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org


Hello!

I tried to use the qla2xxx on 2.6.28.7 with Dell Blade M600 and QME2472 
Mezzanine Card, using x86 / 64 bit.
It OOPSes. The OOPS was introduced with 2.6.27.1 (qla2xxx 8.02.01-k7) . The 
older 2.6.26.8 (qla2xxx 8.02.01-k4) works fine.

(Gerald)

[   18.162122] QLogic Fibre Channel HBA Driver: 8.02.01-k9
[   18.162180] qla2xxx 0000:09:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 
18
[   18.162330] qla2xxx 0000:09:00.0: Found an ISP2432, irq 18, iobase 
0xffffc200
1259c000
[   18.162570] qla2xxx 0000:09:00.0: Configuring PCI space...
[   18.162575] qla2xxx 0000:09:00.0: setting latency timer to 64
[   18.195046] qla2xxx 0000:09:00.0: Configure NVRAM parameters...
[   18.205078] usb usb2: suspend_rh (auto-stop)
[   18.206352] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms 
status 0x
301
[   18.230605] BUG: unable to handle kernel NULL pointer dereference at 
00000000
00000000
[   18.231190] IP: [<ffffffff81230ce7>] strncpy+0x9/0x23
[   18.231190] PGD 42bc2a067 PUD 42c139067 PMD 0
[   18.231190] Oops: 0000 [#1] SMP
[   18.231190] last sysfs file: 
/sys/devices/pci0000:00/0000:00:03.0/0000:08:00.
0/host0/target0:1:0/0:1:0:0/type
[   18.231190] CPU 3
[   18.231190] Modules linked in: qla2xxx(+)
[   18.231190] Pid: 1432, comm: modprobe Not tainted 2.6.28.7 #4
[   18.231190] RIP: 0010:[<ffffffff81230ce7>]  [<ffffffff81230ce7>] 
strncpy+0x9/
0x23
[   18.231190] RSP: 0018:ffff88042bccd9f8  EFLAGS: 00010202
[   18.231190] RAX: 00000000000005b0 RBX: 0000000000000010 RCX: 
ffff88042b83ab17
[   18.231190] RDX: 000000000000004f RSI: 0000000000000000 RDI: 
ffff88042b83ab17
[   18.231190] RBP: ffff88042bccd9f8 R08: 0000000000000000 R09: 
ffff88042c130000
[   18.231190] R10: 0000000000000000 R11: ffff88042b838690 R12: 
ffff88042b83ab06
[   18.231190] R13: ffff88042b838690 R14: ffff88042d2851e0 R15: 
0000000000000000
[   18.231190] FS:  00007f95a58606f0(0000) GS:ffff88042e447700(0000) 
knlGS:00000
00000000000
[   18.231190] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   18.231190] CR2: 0000000000000000 CR3: 000000042c18d000 CR4: 
00000000000006a0
[   18.231190] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   18.231190] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   18.231190] Process modprobe (pid: 1432, threadinfo ffff88042bccc000, 
task ff
ff88042cef6cc0)
[   18.231190] Stack:
[   18.231190]  ffff88042bccda28 ffffffffa0003376 ffff88042c130000 
ffff88042b838
690
[   18.231190]  ffff88042d285000 ffff88042b838690 ffff88042bccda78 
ffffffffa0006
764
[   18.231190]  ffff88042bccda78 ffffffffa0015a0f ffff88042c130000 
ffff88042dcd9
1b0
[   18.231190] Call Trace:
[   18.231190]  [<ffffffffa0003376>] qla2x00_set_model_info+0xec/0x121 
[qla2xxx]
[   18.231190]  [<ffffffffa0006764>] qla24xx_nvram_config+0x2da/0x5f1 
[qla2xxx]
[   18.231190]  [<ffffffffa0015a0f>] ? qla24xx_get_flash_version+0x1e5/0x296 
[ql
a2xxx]
[   18.231190]  [<ffffffffa00071a7>] qla2x00_initialize_adapter+0x169/0x388 
[qla
2xxx]
[   18.231190]  [<ffffffff81026697>] ? x86_swiotlb_alloc_coherent+0x1b/0x3c
[   18.231190]  [<ffffffffa001bd71>] qla2x00_probe_one+0xbac/0xefd [qla2xxx]
[   18.231190]  [<ffffffff810bba6d>] ? ifind+0x60/0x78
[   18.231190]  [<ffffffff810bb784>] ? iput+0x2f/0x65
[   18.231190]  [<ffffffff8102f720>] ? task_rq_lock+0x40/0x75
[   18.231190]  [<ffffffff8102f133>] ? task_rq_unlock+0xc/0xe
[   18.231190]  [<ffffffff81034eb9>] ? set_cpus_allowed_ptr+0x10a/0x117
[   18.231190]  [<ffffffff8123e0a0>] ? pci_match_id+0x1f/0x43
[   18.231190]  [<ffffffff8123e8f9>] pci_device_probe+0xb6/0x10f
[   18.231190]  [<ffffffff810f802b>] ? sysfs_create_link+0xe/0x13
[   18.231190]  [<ffffffff812bf922>] driver_probe_device+0xd9/0x169
[   18.231190]  [<ffffffff812bfa14>] __driver_attach+0x62/0x8c
[   18.231190]  [<ffffffff812bf9b2>] ? __driver_attach+0x0/0x8c
[   18.231190]  [<ffffffff812bf9b2>] ? __driver_attach+0x0/0x8c
[   18.231190]  [<ffffffff812bf1a0>] bus_for_each_dev+0x4a/0x79
[   18.246322]  [<ffffffff812bf753>] driver_attach+0x1c/0x1e
[   18.246322]  [<ffffffff812beaf2>] bus_add_driver+0xb5/0x207
[   18.246322]  [<ffffffff812bfca3>] driver_register+0x93/0x10a
[   18.246322]  [<ffffffffa0030000>] ? qla2x00_module_init+0x0/0x131 
[qla2xxx]
[   18.246322]  [<ffffffff8123eb9e>] __pci_register_driver+0x63/0x9d
[   18.246322]  [<ffffffffa0030000>] ? qla2x00_module_init+0x0/0x131 
[qla2xxx]
[   18.246322]  [<ffffffffa0030101>] qla2x00_module_init+0x101/0x131 
[qla2xxx]
[   18.246322]  [<ffffffff81009058>] _stext+0x58/0x139
[   18.246322]  [<ffffffff81021eb2>] ? __send_IPI_dest_field+0x5c/0x64
[   18.246322]  [<ffffffff8101a652>] ? native_smp_send_reschedule+0x3b/0x3d
[   18.246322]  [<ffffffff8102d438>] ? smp_send_reschedule+0xa/0xc
[   18.246322]  [<ffffffff8102ee65>] ? resched_task+0x7b/0x7f
[   18.246322]  [<ffffffff8102f133>] ? task_rq_unlock+0xc/0xe
[   18.246322]  [<ffffffff81032b09>] ? try_to_wake_up+0x218/0x22a
[   18.246322]  [<ffffffff8105d8da>] sys_init_module+0x9f/0x1ad
[   18.246322]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[   18.246322] Code: ff e9 29 ff ff ff 90 90 55 48 89 fa 48 89 e5 8a 06 48 
ff c6
 88 02 48 ff c2 84 c0 75 f2 c9 48 89 f8 c3 55 48 89 f9 48 89 e5 eb 10 <8a> 
06 3c
 01 88 01 48 83 de ff 48 ff c1 48 ff ca 48 85 d2 75 eb
[   18.246322] RIP  [<ffffffff81230ce7>] strncpy+0x9/0x23
[   18.246322]  RSP <ffff88042bccd9f8>
[   18.246322] CR2: 0000000000000000
[   18.255936] ---[ end trace 2127ef5a187ff23f ]---
[   18.257613] modprobe used greatest stack depth: 4128 bytes left 

