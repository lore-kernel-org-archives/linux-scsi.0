From: Jesper Krogh <jesper@krogh.cc>
Subject: Re: [PATCH 2/6] mpt fusion: Firmware Event implementation using seperate
 WorkQueue
Date: Mon, 06 Apr 2009 10:44:10 +0200
Message-ID: <49D9C0DA.6000908@krogh.cc>
References: <20090403115025.GC17721@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:47415 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbZDFJD3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Apr 2009 05:03:29 -0400
In-Reply-To: <20090403115025.GC17721@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Kashyap, Desai wrote:
> 1) 	Now Firmware events are handled by firmware event queue.
> 	Previously it was handled in interrupt context/WorkQueue of Linux.
> 	Firmware Event handling is restructured and optimized.
> 2.)	Test Unit Ready will be used by driver to make sure device is
> 	already come up before indicating Device Add to Scsi subsystem.

Quick question.. are these changes (in 2.6.29) related to this one i got 
only on 2.6.29:

[248240.137978] Pid: 9225, comm: mdrun_mpi.openm Not tainted 2.6.29 #30
[248240.137978] Call Trace:
[248240.137978]  <IRQ>  [<ffffffff8027231e>] __report_bad_irq+0x1e/0x80
[248240.137978]  [<ffffffff80272502>] note_interrupt+0x182/0x1d0
[248240.137978]  [<ffffffff80272f69>] handle_fasteoi_irq+0x89/0xe0
[248240.137978]  [<ffffffff8020e73e>] do_IRQ+0x7e/0x110
[248240.137978]  [<ffffffff8020cc93>] ret_from_intr+0x0/0xa
[248240.137978]  <EOI> <3>handlers:
[248240.137978] [<ffffffffa014c920>] (mpt_interrupt+0x0/0x5f0 [mptbase])
[248240.290859] Disabling IRQ #19


-- 
Jesper
