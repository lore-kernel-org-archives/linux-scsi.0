From: Willem Riede <wrlk@riede.org>
Subject: ide-scsi in 2.5.51
Date: Sat, 14 Dec 2002 15:22:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021214202254.GH3664@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gBEKMsC29686
	for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2002 15:22:54 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In my efforts to make osst work on 2.5.51 I've been pretty successful with
the SC-30 (scsi) and the FW-30 (ieee1394). But the ide-scsi is giving me
trouble with the DI-30 (Atapi). I get the same problem with another ide
connected tape drive and st, by the way, so I am taking a closer look at
ide-scsi. When I load the module I get:


Dec 14 14:50:55 fallguy kernel: Badness in kobject_register at lib/kobject.c:113
Dec 14 14:50:55 fallguy kernel: Call Trace:
Dec 14 14:50:55 fallguy kernel:  [<c01c7c88>] kobject_register+0x58/0x70
Dec 14 14:50:55 fallguy kernel:  [<c01db442>] bus_add_driver+0x82/0xd0
Dec 14 14:50:55 fallguy kernel:  [<c022bd00>] ide_drive_remove+0x0/0x30
Dec 14 14:50:55 fallguy kernel:  [<c022bdec>] ide_register_driver+0xbc/0xf0
Dec 14 14:50:55 fallguy kernel:  [<c0133f6a>] sys_init_module+0x1ba/0x1d0
Dec 14 14:50:55 fallguy kernel:  [<c010b643>] syscall_call+0x7/0xb
Dec 14 14:50:55 fallguy kernel: 
Dec 14 14:50:55 fallguy kernel: scsi HBA driver idescsi didn't set max_sectors, please fix the template
<3>ERROR: SCSI host `ide-scsi' has no error handling
Dec 14 14:50:55 fallguy kernel: ERROR: This is not a safe way to run your SCSI host
Dec 14 14:50:55 fallguy kernel: ERROR: The error handling must be added to this driver
Dec 14 14:50:55 fallguy kernel: Call Trace:
Dec 14 14:50:55 fallguy kernel:  [<c023687d>] scsi_register+0x2cd/0x2e0
Dec 14 14:50:55 fallguy kernel:  [<c02368be>] scsi_register_host+0x2e/0xe0
Dec 14 14:50:55 fallguy kernel:  [<c0133f6a>] sys_init_module+0x1ba/0x1d0
Dec 14 14:50:55 fallguy kernel:  [<c010b643>] syscall_call+0x7/0xb
Dec 14 14:50:55 fallguy kernel: 
Dec 14 14:50:55 fallguy kernel: scsi4 : SCSI host adapter emulation for IDE ATAPI devices


So it seems that ide-scsi hasn't kept up with the evolving 2.5 kernel.
If no-one else is working on this, I'm prepared to take a stab at it,
but to get me jump-started any advise / hint will be most welcome.

Thanks, Willem Riede.
