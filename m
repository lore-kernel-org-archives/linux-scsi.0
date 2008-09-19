From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Fri, 19 Sep 2008 11:53:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809191152200.2429-100000@iolanthe.rowland.org>
References: <20080919091748.9438726b.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080919091748.9438726b.ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 19 Sep 2008, Antonio Ospite wrote:

> On Fri, 5 Sep 2008 15:35:13 -0400 (EDT)
> Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> 
> > On Wed, 27 Aug 2008, Alan Stern wrote:
> > 
> > > This patch (as1133) fixes a bug in the interaction between
> > > scsi_end_request() and scsi_io_completion().  The bug was triggered by
> > > recent changes to accomodate USB drives can't access their last few
> > > sectors using multi-sector transfers (the so-called last_sector_bug
> > > flag).
> > > 
> > > The bug shows up when a multi-sector I/O request has been broken up
> > > into single-sector commands.  If one of those commands gets an error,
> > > the remainder of the request never gets completed.  This is because
> > > the "bytes" value passed to scsi_end_request() is completely wrong; it
> > > is the transfer size of the current command, not the total transfer
> > > size of the request.
> > 
> > There hasn't been any reply to this patch submission.  For reference,
> > the original message is at
> > 
> > 	http://marc.info/?l=linux-scsi&m=121986305201166&w=2
> > 
> > Has it been accepted, rejected, or did it fall through the cracks?
> > 
> > Alan Stern
> >
> 
> Hi again,
> 
> anything new about this patch? Alan, I'll keep reminding about it from
> time to time, until it is accepted or rejected.

All I can tell you is that I asked James Bottomley at the Linux Kernel
Summit, and he said he has been too busy to look at it but it's got an
"!" on his to-do list.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
