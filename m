From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
Date: Sat, 16 Feb 2008 10:20:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802161013190.3769-100000@iolanthe.rowland.org>
References: <6101e8c40802160632y2723ccc3xb0940b9aebfa20f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6101e8c40802160632y2723ccc3xb0940b9aebfa20f5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 16 Feb 2008, Oliver Pinter wrote:

> On 2/15/08, Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > In my workplace, I use a customized version of Novell's ZENworks imaging
> > boot CD, which is based off of Linux. I have one particular model of
> > laptop - the IBM/Lenovo R61 - on which three different things fail
> > completely in current kernels (tested with 2.6.24.2 and 2.6.25-rc1):
> > USB, AHCI (and thus access to the SATA drive), and networking. As a
> > consequence of all three failing in parallel, I have no practical way to
> > get logs and other information off of the machine to help with tracking
> > down the bugs.

...

To make a long story short, the USB symptoms you describe indicate a
problem with interrupt routing.  This could well explain the other
difficulties too.  There are various kernel parameters you can try
putting on the boot command line to work around it:  acpi=noirq or
acpi=off or pci=noacpi or a few others.

Alan Stern
