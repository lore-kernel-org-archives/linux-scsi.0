From: Sebastian Faerber <sebastian.faerber@web.de>
Subject: Adaptec I2O RAID and IRQ Problems
Date: Wed, 23 Feb 2005 22:55:56 +0100
Message-ID: <421CFBEC.9090209@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Received: from smtp06.web.de ([217.72.192.224]:4245 "EHLO smtp06.web.de")
	by vger.kernel.org with ESMTP id S261623AbVBWVza (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 16:55:30 -0500
Received: from [82.135.70.205] (helo=[82.135.70.205])
	by smtp06.web.de with asmtp (WEB.DE 4.103 #192)
	id 1D44Tb-0006nz-00
	for linux-scsi@vger.kernel.org; Wed, 23 Feb 2005 22:55:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

i'm trying to get an Adaptec 2015S Zero Channel Raid Controller up and running in a very new Asus Mainboard (NCL-DS)
with Dual Xeons.
I already tried kernel 2.4.29 and plain 2.6.10 but both just lock up when loading the dpt_i2o driver.
With 2.6.11-rc4-mm1 i could gather the following output while booting:
--
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
ACPI: PCI interrupt 0000:09:01.0[A] -> GSI 11 (level, low) -> IRQ 11
Adaptec I2O RAID controller 0 irq=11
     BAR0 f8880000 - size= 100000
     BAR1 f8a00000 - size= 1000000
BUG: soft lockup detected on CPU#0!
Pid: 1, comm:              swapper
EIP: 0060:[<c011d05e>] CPU: 0
EIP is at __do_softirq+0x2e/0x90
 EFLAGS: 00000246    Not tainted  (2.6.11-rc4-mm1)
EAX: dfcb0000 EBX: 00000022 ECX: 00000022 EDX: 00000000
ESI: c04c8ea0 EDI: 0000000a EBP: 00000246 DS: 007b ES: 007b
CR0: 8005003b CR2: fffcd000 CR3: 004a3000 CR4: 000006d0
 [<c011d0e7>] do_softirq+0x27/0x30
 [<c010472b>] do_IRQ+0x3b/0x70
 [<c0102fba>] common_interrupt+0x1a/0x20
 [<c01362c2>] setup_irq+0xa2/0xf0
 [<c02db930>] adpt_isr+0x0/0x1f0 [more]
 [<c01364a1>] request_irq+0x71/0x90
 [<c02da051>] adpt_install_hba+0x2a1/0x420
 [<c0272993>] bus_add_driver+0xc3/0xd0
 [<c02d9080>] adpt_detect+0x50/0x1e0
 [<c049135a>] init_this_scsi_driver+0x3a/0x100
 [<c04747eb>] do_initcalls+0x2b/0xc0
 [<c0100290>] init+0x0/0xf0
 [<c0100290>] init+0x0/0xf0
 [<c01002b5>] init+0x25/0xf0
 [<c01012d8>] kernel_thread_helper+0x0/0x18
 [<c01012dd>] kernel_thread_helper+0x5/0x18
--
I have several machines running with dpt_i2o raid controller and 2.4.29 for example but they are on older
Tyan boards.

Any suggestions how to get this controller up and running ? I suppose it has something to do with ACPI and/or IRQ routing ?
If you need any additional information just let me know.

Best Regards,

Sebastian Faerber

