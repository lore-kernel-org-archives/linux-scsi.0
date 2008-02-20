From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly
 resolved
Date: Wed, 20 Feb 2008 10:50:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802201048410.4828-100000@iolanthe.rowland.org>
References: <47BB3DA1.8040001@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47BB3DA1.8040001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 19 Feb 2008, Andrew Buehler wrote:

> With those two problems out of the way, what is left is the hard-drive
> issue, and that is also halfway fixed by enabling ACPI. Specifically, it
> is "fixed" in that the kernel sees the hard drive and I can mount it,
> but it is not fixed in that the program we need to use in this
> environment does not see the drive.

What do you mean by "does not see the drive"?

> I have a config from a boot disc running 2.6.5 (that's not a typo) under
> which the program in question *does* see the drive, but there are
> massive differences between that config and the one I am using now, and
> narrowing the critical difference down is likely to be somewhat
> difficult - particularly since some of the "differences" are merely
> renamed config symbols (i.e. the CONFIG_SCSI_SATA_*->CONFIG_SATA_*
> switchover), and I have limited ability to tell which without intensive
> investigation. Are there any established techniques for simplifying this
> kind of comparison?

The only established technique is to run various kernels intermediate 
between the one that works and the one that fails.

Alan Stern
