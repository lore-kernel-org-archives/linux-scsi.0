From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 14:07:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF3AD2.10107@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154313.GA25397@devserv.devel.redhat.com> <40CF1A5D.30908@adaptec.com> <20040615155716.GA14017@infradead.org> <40CF2381.30707@adaptec.com> <20040615163324.GB27597@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:32688 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265807AbUFOSHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 14:07:21 -0400
In-Reply-To: <20040615163324.GB27597@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> so do explain why the recovery method requires the midlayer to hand over
> timer handling to the driver ?

This is explained in the rest of the message (the part you cut off),
and also very well explained by Doug, another LLDD writer.

> Why does it matter for *recovery* who started
> the timer ???

But that's _exactly_ the point!  It's the different scenarios
of recovery, (hw bugs, sw bugs, vendor recovery logic as is allowable
in specific protocols, etc, etc, etc)  I'm basically repeating the
previous email I posted.

You cannot have an arbitrary timer running alongside LLDD recovery
logic.
 
> Yes I can see the use for the driver to tell the timer handler code "eh please
> give me some more time, I'm configuring stuff for a bit". But that doesn't
> explain why it shouldn't be the midlayer that keeps in charge of timer
> handling and solicits the advice from the driver like this..

But that's exactly what Doug's and my emails explained!  I'm confused!?
Is this some kind of game of asking the same questions in different forms?
It's as if my email wasn't read at all? And just the same question was asked
in a different form?  It wasn't like this 4 years ago.

Again, this is just a non-intrusive _optional_ method, which would allow
capable LLDD (and non-native interconnects) to use if they decide to do so.
As I said, work with a vendor to write a LLDD (especially for newer protocols)
and the _option_ of such a method would be clear.

Any LLDD writers, FC, iSCSI, SAS people, SCSI architects are welcome
to chime in.  This patch was really intended for such a discussion.

-- 
Luben


