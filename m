From: TJ <linux@tjworld.net>
Subject: aacraid: BUG: soft lockup - CPU#0 stuck for 61s!
Date: Sat, 05 Apr 2008 17:01:12 +0100
Message-ID: <1207411272.8003.27.camel@hephaestion.lan.tjworld.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tjworld.net ([67.18.187.6]:34359 "EHLO tjworld.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752432AbYDEQHe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Apr 2008 12:07:34 -0400
Received: from [10.254.252.6] (hephaestion.lan.tjworld.net [10.254.252.6])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tjworld.net (Postfix) with ESMTP id 6D6051813A
	for <linux-scsi@vger.kernel.org>; Sat,  5 Apr 2008 17:01:13 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Please see bug report #10396

http://bugzilla.kernel.org/show_bug.cgi?id=10396


[  152.474463] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
[  152.474463] 
[  152.474463] Pid: 2096, comm: modprobe Not tainted (2.6.25-rc8-custom #1)
[  152.474463] EIP: 0060:[<c0209db0>] EFLAGS: 00000293 CPU: 0
[  152.474463] EIP is at native_read_tsc+0x0/0x10
[  152.474463] EAX: 00000474 EBX: b8fd8e27 ECX: 02a52000 EDX: 0000004a
[  152.474463] ESI: 00000aac EDI: 0142f9cb EBP: f54dda84 ESP: f7c5dd1c
[  152.474463]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  152.474463] CR0: 8005003b CR2: 080f91cf CR3: 37a60000 CR4: 000006d0
[  152.474463] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  152.474463] DR6: ffff0ff0 DR7: 00000400
[  152.474463]  [<c0305067>] ? delay_tsc+0x17/0x20
[  152.474463]  [<c0305016>] ? __delay+0x6/0x10
[  152.474463]  [<f8a5aa40>] ? aac_fib_send+0x220/0x2d0 [aacraid]
[  152.474463]  [<f8a569c4>] ? aac_get_adapter_info+0x74/0x680 [aacraid]
[  152.474463]  [<c021937b>] ? __resched_task+0x5b/0x70
[  152.474463]  [<c021ccda>] ? try_to_wake_up+0x6a/0x100
[  152.474463]  [<f8a5d55a>] ? aac_probe_one+0x23a/0x4a4 [aacraid]
[  152.474463]  [<f8a5af50>] ? aac_command_thread+0x0/0x6d0 [aacraid]
[  152.474463]  [<c0310146>] ? pci_device_probe+0x56/0x80
[  152.474463]  [<c0367948>] ? driver_probe_device+0x88/0x170
[  152.474463]  [<c0367b9e>] ? __driver_attach+0x9e/0xa0
[  152.474463]  [<c0366cea>] ? bus_for_each_dev+0x3a/0x60
[  152.474463]  [<c03100f0>] ? pci_device_probe+0x0/0x80
[  152.474463]  [<c03677c6>] ? driver_attach+0x16/0x20
[  152.474463]  [<c0367b00>] ? __driver_attach+0x0/0xa0
[  152.474463]  [<c0367674>] ? bus_add_driver+0x1a4/0x210
[  152.474463]  [<c0310090>] ? pci_device_remove+0x0/0x40
[  152.474463]  [<c03100f0>] ? pci_device_probe+0x0/0x80
[  152.474463]  [<c0367d3b>] ? driver_register+0x3b/0xf0
[  152.474463]  [<c040b744>] ? _spin_unlock_irqrestore+0x4/0x10
[  152.474463]  [<c031034d>] ? __pci_register_driver+0x3d/0x80
[  152.474463]  [<f890a033>] ? aac_init+0x33/0x74 [aacraid]
[  152.474463]  [<c024696e>] ? sys_init_module+0x13e/0x1c40
[  152.474463]  [<c040d37f>] ? do_page_fault+0x13f/0x670
[  152.474463]  [<c02294ec>] ? irq_exit+0x3c/0x70
[  152.474463]  [<c0204d76>] ? syscall_call+0x7/0xb
[  152.474463]  =======================


