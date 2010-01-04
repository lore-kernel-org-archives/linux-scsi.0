From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI/ibmvscsi: fix a typo in a source code comment
Date: Mon, 04 Jan 2010 10:34:42 -0600
Message-ID: <1262622882.2724.63.camel@mulgrave.site>
References: <200912042043.37328.bart.vanassche@gmail.com>
	 <e2e108261001040819w218b13c1ja7939c6fd3014e1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab0ADQe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jan 2010 11:34:56 -0500
In-Reply-To: <e2e108261001040819w218b13c1ja7939c6fd3014e1d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>

On Mon, 2010-01-04 at 17:19 +0100, Bart Van Assche wrote:
> On Fri, Dec 4, 2009 at 8:43 PM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
> > Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> >
> > diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> > index e475b79..e3a18e0 100644
> > --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> > +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> > @@ -40,7 +40,7 @@
> >  * (CRQ), which is just a buffer of 16 byte entries in the receiver's
> >  * Senders cannot access the buffer directly, but send messages by
> >  * making a hypervisor call and passing in the 16 bytes.  The hypervisor
> > - * puts the message in the next 16 byte space in round-robbin fashion,
> > + * puts the message in the next 16 byte space in round-robin fashion,
> >  * turns on the high order bit of the message (the valid bit), and
> >  * generates an interrupt to the receiver (if interrupts are turned on.)
> >  * The receiver just turns off the valid bit when they have copied out
> 
> Hello James,
> 
> Does anyone have to ack this trivial patch before it can be added to
> the scsi-misc-2.6.git repository ?

It's not required, but it does help.  All patches (however trivial) do
need reviewing before they go in.  My review fifo tends to be long, and
trivial stuff goes right at the end, so if someone else I trust (like
the maintainer) acks it, it can come out of my fifo and go into the
tree.

James


