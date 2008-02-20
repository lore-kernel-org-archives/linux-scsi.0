From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly
 resolved
Date: Wed, 20 Feb 2008 12:15:12 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802201213260.5630-100000@iolanthe.rowland.org>
References: <47BC5E01.1050902@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47BC5E01.1050902-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 20 Feb 2008, Andrew Buehler wrote:

> > What do you mean by "does not see the drive"?
> 
> Its detect-hardware-and-report mode shows a HD size of 0 (which is what
> it has showed in cases where the kernel has not detected the drive), its
> detect-partitions-and-report mode shows no partitions and no devices
> which can have partitions, and attempting to actually use it to pull
> down a drive image (it's a disk-imaging program) causes it to hang at
> the point where it would begin to write.
> 
> Hmm. One thing which just sprang to mind, in the stab-in-the-dark
> category: in 2.6.24.2, launching the program on some machines gave
> warnings along the lines of "this program is using a deprecated ioctl,
> please convert it to SG_IO" (which I naturally cannot do since it's
> closed and I don't have the source),

You can ask the program's author to update it.

> but IIRC in the 2.5.25-rc2-based
> disc with ACPI enabled no such message appears. If the reason that there
> are no longer such messages is that the ioctl in question has now been
> removed, that might explain why the program does not see the drive.

Could be.  You can use strace to find out what system calls the program 
is making.


> I'm not sure I expressed myself clearly. I do not think the problem is
> with the different kernels. I think the problem is with the different
> configurations. I am asking if there are any established techniques for
> comparing differences between config files from widely different
> kernels.

Not as far as I know.

Alan Stern
