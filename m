From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 21/24][RFC] scsi_tgt: use of sense accessors
Date: Tue, 05 Feb 2008 12:28:30 -0500
Message-ID: <47A89CBE.6040301@garzik.org>
References: <1202147595-5400-1-git-send-email-bharrosh@panasas.com>	<20080205162133.GC1931@osc.edu> <20080206015308F.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51275 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYBER37 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 12:29:59 -0500
In-Reply-To: <20080206015308F.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: pw@osc.edu, bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>

FUJITA Tomonori wrote:
> On Tue, 5 Feb 2008 11:21:33 -0500
> Pete Wyckoff <pw@osc.edu> wrote:
> 
>> bharrosh@panasas.com wrote on Mon, 04 Feb 2008 19:53 +0200:
>>>   FIXME: I need help with this driver (Pete?)
>>>     I used scsi_sense() in a none const way. But since
>>>     scsi_tgt is the ULD here, it can just access it's own sense
>>>     buffer directly. I did not use scsi_eh_cpy_sense() because
>>>     I did not want the extra copy. Pete will want to use a 260
>>>     bytes buffer here.
>>>
>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>>> Need-help-from: Pete Wyckoff <pw@osc.edu>
>> FYI, I never use scsi_tgt.  Only just pure userspace on the target,
>> and a dumb ethernet NIC that does not know it is speaking any form
>> of SCSI.
> 
> Seems that many people misunderstand STGT iSCSI (and iSER), FCoE, and
> SRP (not implemented yet) software target drivers. They don't use the
> tgt kernel module. They just run in user space like user-space nfs
> daemon.

FWIW, some AHCI and other SATA chips implement ATA target mode.  I'm 
watching this SCSI work with interest, hoping that many of the concepts 
(and code?) can be applied to SATA as well.

If for no other reason than I can build a cheap ATA protocol analyzer, 
or bridge.

	Jeff



