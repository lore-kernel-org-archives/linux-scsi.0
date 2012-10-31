From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49821] New: Random Call traces when using tape device.
Date: Wed, 31 Oct 2012 19:23:17 +0000 (UTC)
Message-ID: <bug-49821-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51909 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759729Ab2JaTXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2012 15:23:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C278B205E4
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 19:23:19 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7C910205E8
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 19:23:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49821

           Summary: Random Call traces when using tape device.
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.2.29
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: ilovequake@tlen.pl
        Regression: No


Created an attachment (id=85361)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=85361)
dmesg, lsmod, lspci, irqs

Hello,

Sorry if I posted in bad section.
When i'm using my tape device to save the data i'm getting this message:
[ 8914.751464] Call Trace:
[ 8914.751469]  [<c1485e23>] ? printk+0x1d/0x1f
[ 8914.751472]  [<c109c419>] __report_bad_irq+0x29/0xd0
[ 8914.751475]  [<c12b3625>] ? add_interrupt_randomness+0x125/0x150
[ 8914.751477]  [<c109c6d5>] note_interrupt+0x175/0x1c0
[ 8914.751478]  [<c125b04c>] ? intel_idle+0xdc/0x130
[ 8914.751480]  [<c109a5aa>] handle_irq_event_percpu+0xaa/0x1d0
[ 8914.751482]  [<c109a702>] handle_irq_event+0x32/0x60
[ 8914.751484]  [<c109cee0>] ? unmask_irq+0x30/0x30
[ 8914.751486]  [<c109cf2b>] handle_fasteoi_irq+0x4b/0xd0
[ 8914.751487]  <IRQ>  [<c148f7b2>] ? do_IRQ+0x42/0xc0
[ 8914.751490]  [<c148f6f0>] ? common_interrupt+0x30/0x38
[ 8914.751493]  [<c10400e0>] ? task_times+0x60/0xa0
[ 8914.751494]  [<c125b04c>] ? intel_idle+0xdc/0x130
[ 8914.751497]  [<c139e0a6>] ? cpuidle_idle_call+0xb6/0x210
[ 8914.751498]  [<c1001757>] ? cpu_idle+0x97/0xe0
[ 8914.751500]  [<c14731ba>] ? rest_init+0x62/0x68
[ 8914.751502]  [<c16437a9>] ? start_kernel+0x36d/0x373
[ 8914.751504]  [<c16431c1>] ? loglevel+0x2b/0x2b
[ 8914.751505]  [<c164311a>] ? reserve_ebda_region+0x67/0x69
[ 8914.751507]  [<c16430ac>] ? i386_start_kernel+0xac/0xb3
[ 8914.751508] handlers:
[ 8914.751516] [<f8465e90>] mpt_interrupt
[ 8914.751517] Disabling IRQ #17

There is no difference after changing the slot of my PCI controller.

Slackware-current, Linux zonk 3.2.29-smp #1 SMP Mon Sep 17 13:02:10 CDT 2012
i686 Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz GenuineIntel GNU/Linux

If you need more info about my pc/soft. please ask.

Thanks.
Marek

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
