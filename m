From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Wed, 9 Apr 2014 14:02:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1404091358340.28384-100000@netrider.rowland.org>
References: <53458680.4090500@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53458680.4090500-l3A5Bk7waGM@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Andreas Reis <andreas.reis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 9 Apr 2014, Hannes Reinecke wrote:

> > I finally got a chance to try it out.  It does seem to do what we want.
> > I didn't track the flow of control in complete detail, but the command
> > definitely got aborted both times it was issued.
> >
> Good, so it is as I thought. James, can we include this patch instead of 
> your prior solution?

First, we should have the original bug reporter try it out.

Andreas, the patch in question can be found here:

	http://marc.info/?l=linux-usb&m=139627666606597&w=2

Can you try this in place of the 1/3 patch posted by James?  It should 
have the same effect, of preventing your system from crashing when the 
READ command fails.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
