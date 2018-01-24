From: Meelis Roos <mroos@linux.ee>
Subject: Re: qla2xxx UBSAN warning in 4.14-rc1
Date: Wed, 24 Jan 2018 22:35:18 +0200 (EET)
Message-ID: <alpine.LRH.2.21.1801242234360.28967@math.ut.ee>
References: <alpine.LRH.2.21.1709181335450.628@math.ut.ee> <79E0683A-42C7-4784-9B6A-1F7C120CA69A@cavium.com> <alpine.LRH.2.21.1711091058150.7113@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:38967 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932072AbeAXUfW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 15:35:22 -0500
In-Reply-To: <alpine.LRH.2.21.1711091058150.7113@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> Hello again.

And again...
> 
> > > On Sep 18, 2017, at 3:49 AM, Meelis Roos <mroos@linux.ee> wrote:
> > > 
> > > Hello, I decided to widen the coverage of my kernel testbed and put some 
> > > FC cards into servers. This one is a PCI-X QLA2340 in HP Proliant DL 380 
> > > G4 (first 64-bit generation of Proliants). I got a UBSAN warning from 
> > > qla2xxx before probing for the firmware.
> > > 
> > > This is reproducible with or without firmware being available.
> > > 
> > > [    3.905570] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 10.00.00.01-k.
> > > [    3.905977] qla2xxx 0000:06:02.0: PCI IRQ 78 -> rerouted to legacy IRQ 18
> > > [    3.906172] qla2xxx [0000:06:02.0]-001d: : Found an ISP2312 irq 18 iobase 0xffffc90000139000.
> > > [...]
> > > [    4.180117] ================================================================================
> > > [    4.180300] UBSAN: Undefined behaviour in drivers/scsi/qla2xxx/qla_isr.c:275:14
> > > [    4.180464] shift exponent 32 is too large for 32-bit type 'int'
> > > [    4.180576] CPU: 0 PID: 138 Comm: systemd-udevd Not tainted 4.14.0-rc1-00009-g0666f560b71b #27
> > > [    4.180741] Hardware name: HP ProLiant DL380 G4, BIOS P51 07/19/2007
> > > [    4.180849] Call Trace:
> > > [    4.180961]  dump_stack+0x4e/0x6c
> > > [    4.181072]  ubsan_epilogue+0xd/0x3b
> > > [    4.181179]  __ubsan_handle_shift_out_of_bounds+0x112/0x14c
> > > [    4.181290]  ? try_to_del_timer_sync+0x44/0x68
> > > [    4.181440]  qla2x00_mbx_completion+0x1c5/0x25d [qla2xxx]
> > > [    4.182683]  qla2300_intr_handler+0x1ea/0x3bb [qla2xxx]
> > > [    4.182827]  qla2x00_mailbox_command+0x77b/0x139a [qla2xxx]
> 
> [...]
> 
> > we’ll take a look at this
> 
> How is it going? 4.14 is almost here but it is still unfixed?

4.15 is almost here but nothing seems to have chanmged?

-- 
Meelis Roos (mroos@linux.ee)
