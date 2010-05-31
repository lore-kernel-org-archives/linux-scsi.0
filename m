From: Tedheadster <tedheadster@gmail.com>
Subject: aha1542 oops
Date: Mon, 31 May 2010 10:03:17 -0400
Message-ID: <AANLkTilB661W9H9IPxn9TGBvv-omVnAh43r3XR5uM58m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52916 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0EaODT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2010 10:03:19 -0400
Received: by vws9 with SMTP id 9so778549vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2010 07:03:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm reliably getting this oops:

Configuring Adaptec (SCSI-ID 6) at IO:334, IRQ 10, DMA priority 6
BUG: sleeping function called from invalid context at mm/slub.c:1598
in_atomic(): 0, irqs_disabled(): 1, pid: 4782, name: modprobe
Pid: 4782, comm: modprobe Not tainted 2.6.30.10-105.2.23.RODATA.fc11.i586 #1
Call Trace:
 [<c0469e58>] ? request_threaded_irq+0x85/0x145
 [<c0422ab7>] __might_sleep+0xc4/0xc9
 [<c04a4322>] kmem_cache_alloc_notrace+0x29/0xb0
 [<c0469e58>] request_threaded_irq+0x85/0x145
 [<d086439c>] ? do_aha1542_intr_handle+0x0/0x2be [aha1542]
 [<d08696aa>] aha1542_detect+0x631/0x76f [aha1542]
 [<d0869841>] init_this_scsi_driver+0x59/0xc7 [aha1542]
 [<d08697e8>] ? init_this_scsi_driver+0x0/0xc7 [aha1542]
 [<c040114b>] do_one_initcall+0x51/0x13f
 [<c0451111>] sys_init_module+0x8b/0x192
 [<c0403535>] syscall_call+0x7/0xb
scsi5 : Adaptec 1542
