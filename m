From: Matthew Jacob <mjacob@feral.com>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 16:21:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123162034.K95542-100000@wonky.in0.lcl>
References: <200301240107.36977.oliver@neukum.name>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200301240107.36977.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Steven Dake <sdake@mvista.com>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

> I want:
> LLDD to SCSI: device is gone
> SCSI to LLDD: Ok. I'll handle from here on.
> LLDD: OK. I am gone. And won't have any contact until the next device is
> plugged in.
>
> The process can be somewhat more complicated, under some conditions:
> - it never fails
> - it is done within a finite, bounded, reasonable time

Could this time limit be fixed (or parameterized) known to all LLDDs?
This would allow one to try and avoid flooding SCSI with detach/reattach
events for the 'same' device.

