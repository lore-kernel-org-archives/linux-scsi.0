From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [linux-usb-devel] RE: A different look at block device hotswap in the Linux kernel
Date: Sun, 26 Jan 2003 12:26:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030126112611.GA2814@win.tue.nl>
References: <OF73A095F7.76CA02FF-ON87256CB8.0060AF6A-88256CB8.006323FB@us.ibm.com> <20030124100832.Y1605-100000@wonky.in0.lcl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030124100832.Y1605-100000@wonky.in0.lcl>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, "Cress, Andrew R" <andrew.r.cress@intel.com>, andmike@us.ibm.com, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Steven Dake <sdake@mvista.com>, Alan Stern <stern@rowland.harvard.edu>

On Fri, Jan 24, 2003 at 10:09:32AM -0800, Matthew Jacob wrote:

> > It's like when I pull the power plug because my system is totally hosed and
> > I want to start over.  I know I can cause damage by doing that, but I would
> > be upset if the new system booted back to the broken state it was in when I
> > unplugged it.
> 
> You may want your device to reattach as totally new. You may, on the other
> hand, want your device to resume where you left off. I can see valid
> reasons for wanting either behaviour (but it can't/shouldn't be deduced
> by the OS).

The kernel does not remember this device once it is gone.
If user space thinks it recognizes it, it must have a means to
tell the kernel what it should do. What kind of info?
The only thing that I can think of right now is the name.
User space may tell the kernel under what name a device should
be accessible.

[Today user space can tell the kernel the numbering of the partitions.]

More generally, the question of what "same device" means
depends on the application. Is /dev/fd0 the same device
as /dev/fd0 also when the floppy is different?
Yes, the name is the same. The contents not.

In all cases user space does not tell the kernel "it is the same as ..."
since the kernel does not remember anyway. User space just instructs
the kernel to do certain definite things.

Andries
