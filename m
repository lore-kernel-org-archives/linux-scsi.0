From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 19:39:31 -0700 (PDT)
Message-ID: <20060518023931.23450.qmail@web31806.mail.mud.yahoo.com>
References: <1147874968.3463.5.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:59005 "HELO
	web31806.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751229AbWERCjc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 22:39:32 -0400
In-Reply-To: <1147874968.3463.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-05-16 at 17:25 -0700, Luben Tuikov wrote:
> > Erm, no, actually, I'm not talking about a SAM nexus.  I'm talking
> > about
> > the nexus established between SCSI Core and LLDD when SCSI Core called
> > queuecommand().  This nexus exists until the LLDD calls done().
> 
> So you want the mid layer to have a different view of the nexus from
> SAM?  I really think we should be following SAM unless there's a very
> good reason not to.
> 
> So, in this case, what's the reason the mid-layer should preserve a
> nexus SAM says (and the LLD knows) has been terminated?

Apparently you have no detailed knowlege of the implementation of
SCSI storage stacks, for example: driver->fw->interconnect->device.

You also fail to understand who the "I" and "T" could be in an
I_T_x_x nexus at each stage of an implementation.

You also fail to understand that a SAM nexus is not necessarily established
when queuecommand() is called. 

I hope you're pretending that you don't understand, on purpose or
as a joke.  The alternative would simply be too scary.

Good luck!
     Luben


