From: Matthew Jacob <mjacob@feral.com>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 13:07:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123130715.S95542-100000@wonky.in0.lcl>
References: <3E30538F.4080507@mvista.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E30538F.4080507@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

>
> The key is that the removal request should come from the top, not the
> bottom.  If someone is stupid enough to surprise remove a device (ie:
> unplug their USB SCSI device while the device is in use by the OS), they
> get what they deserve (I/O errors, dirty OS data, queued up requests
> which never shut down).  If they tell the OS that the device is going to
> be removed, so it may flush the device and shut down I/O to the device,
> the request should be granted on all accounts (expected removal).
>

Hmm? Windows and OS/X cope with this just fine.


