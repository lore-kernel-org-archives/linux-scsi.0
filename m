From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: 19 May 2004 09:45:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084981551.3082.80.camel@patibmrh9>
References: <1083116778.3899.7.camel@patibmrh9><1084897080.3746.38.camel@pa
	tibmrh9>  <20040519081534.GE30348@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:6872 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264262AbUESPqG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 11:46:06 -0400
In-Reply-To: <20040519081534.GE30348@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

Jens A:

> Please explain your reasoning for this patch.

I fear to answer fully, because I see I have a history of answering in
ways that make you lose interest.

I see you have not yet volunteered to review the 2.4.26 patch proposed
in this thread 2004-04-23 by John McKell, written to give us CDC_RAM
alone without MRW in 2.4.

Can I help best by updating that patch to become a 2.4.27-pre3 patch?

Pat LaVarre

----- ----- -----

P.S. An alternative, less short reply that I also drafted was:

> > linux-2.4.18/drivers/ide/ide-cd.c
> if we succeed in getting the mode sense capabilities page,
> you force setting og dvd-rom/ram?!
> ...
> > linux-2.4.18/drivers/scsi/sr.c
> Ditto here.

Yes.

I believe 2.4.18 patch actually makes `mount -w` work there by way of
"see all DVD/CD drives as DVD-RAM/ DVD-ROM compatible".

> Please explain your reasoning for this patch.

Sorry I don't understand what you don't understand.

You're clearly far more expert in this area of Linux than I.

I say my 2.4.18 patch works because otherwise cdrom/ ide-cd/ sr older
than 2.6.2 together decide to fail open via EROFS any time a DVD/ CD
drive reports it is mechanically incompatible with DVD-RAM, no matter
what kind of disc is actually inserted at the time.

You knew that already, yes?

How can I have been unclear?

> And do base patches on recent kernels please,
> 2.4.18 is over 2 years old.

Yes I fetch from kernel.org when I write for merge to kernel.org.

For example, my last linux-ide patch posted is against 2.6.6-bk5.

But this 2.4.18 linux-scsi patch I wrote to help when yet another person
offline was hurt by discovering that `mount -w` did not work for DVD/ CD
discs other than DVD-RAM without an upgrade to Linux-2.6.2 or newer.

I now have this patch archived as patches-be.dvd.ram of:

http://sourceforge.net/projects/iomrrdtools/

I expect in time I will rewrite this patch for 2.4.26, 2.4.25, ... and
back thru all the 2.4 now massively redistributed.  The `mount -w` of
2.6.1 thru 2.6.5 also need this patch, but I hope to avoid writing it
there by insisting 2.6 people should begin life with 2.6.5 or better.

Pat LaVarre


