From: Matthew Jacob <mjacob@feral.com>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 13:16:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123131039.P95542-100000@wonky.in0.lcl>
References: <3E30595C.5070808@mvista.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E30595C.5070808@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


Oh, well. I've pulled my camera in the middle of reads and just got the
usual whininess.

I think I was reacting to your "get what they deserve" comment. The end
goal of USB should probably *be* an alert that said "oh, dear, that
wasn't helpful- please put that memory stick back so I can finish
writing  it". The message "die, heathen dog luser!" is not exactly the
right idea.

In the matrix of outcomes of pulling a disk (or a fibre channel cable)
in the middle of I/O, there are many entries that are not recoverable,
many entries are hard to recover from, and many that are easy. This
should be irrelevant to the basic policy decision as to how you want
your system to be used- do you want it to require intervention so that
it is "safe" to change h/w? do you want I/O to autorestart after
(temporary) h/w topology changes? Have these questions been answered or
can they be answered via policies?



On Thu, 23 Jan 2003, Steven Dake wrote:

> I cant speak about OS/X, but I have crashed windows several times (BSOD)
> while hot removing a USB SCSI CDROM.  As you will notice, when you run
> windows and attach a device, there is a program that is started that
> allows you to notify the os of the removal so that it may properly
> remove the device from the OS instead of it being yanked.
>
> Thanks
> -steve
>
> Matthew Jacob wrote:
>
> >>The key is that the removal request should come from the top, not the
> >>bottom.  If someone is stupid enough to surprise remove a device (ie:
> >>unplug their USB SCSI device while the device is in use by the OS), they
> >>get what they deserve (I/O errors, dirty OS data, queued up requests
> >>which never shut down).  If they tell the OS that the device is going to
> >>be removed, so it may flush the device and shut down I/O to the device,
> >>the request should be granted on all accounts (expected removal).
> >>
> >>
> >>
> >
> >Hmm? Windows and OS/X cope with this just fine.
> >
> >
> >
> >
> >
> >
>
>

