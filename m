From: Matthew Jacob <mjacob@feral.com>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Fri, 24 Jan 2003 07:26:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124072104.N2379-100000@beppo>
References: <3E30F0E7.1040707@pacbell.net>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E30F0E7.1040707@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Oliver Neukum <oliver@neukum.name>, Steven Dake <sdake@mvista.com>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> >>...
> >
> >
> > Could this time limit be fixed (or parameterized) known to all LLDDs?
> > This would allow one to try and avoid flooding SCSI with detach/reattach
> > events for the 'same' device.
>
> And what exactly is the "same" device?  And who's keeping history
> about devices that have previously been attached?  And, says the guy
> who's full of questions, didn't Linus want to get rid of such history?

Hrmm. That's a damned good point. I was going to say things like "the
FC HBA driver knows that device XYX left the fabric and now has
returned", but if XYZ left the fabric, why am I keeping track of it
still? Once gone, it's gone. I had convinced myself that if an FC device
(re)appears, it's not up to the HBA to say it's the same (the content
may have been changed even if the container tag is the same).

Hrm.


