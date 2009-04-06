From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 2/6] mpt fusion: Firmware Event implementation using
 seperate WorkQueue
Date: Mon, 6 Apr 2009 14:36:52 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410F4CA6A@inbmail01.lsi.com>
References: <20090403115025.GC17721@lsi.com> <49D9C0DA.6000908@krogh.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:38594 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZDFJHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 05:07:03 -0400
In-Reply-To: <49D9C0DA.6000908@krogh.cc>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Krogh <jesper@krogh.cc>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Jesper,
None of the changes are related to problem you have reported for bad irq.

Thanks
Kashyap


-----Original Message-----
From: Jesper Krogh [mailto:jesper@krogh.cc] 
Sent: Monday, April 06, 2009 2:14 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 2/6] mpt fusion: Firmware Event implementation using seperate WorkQueue

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
