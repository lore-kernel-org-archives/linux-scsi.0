From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly
 resolved
Date: Thu, 21 Feb 2008 15:02:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802211501570.5473-100000@iolanthe.rowland.org>
References: <47BDD455.9090909@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47BDD455.9090909-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Feb 2008, Andrew Buehler wrote:

> > It sounds like an old version of a Novell product is making a newer
> > kernel spit out a warning message.
> 
> Originally that was all that it was, but now I am seeing the product in
> question not even see the hard drive despite the fact that it is
> mountable with standard utilities. Whether the failure is in the program
> or elsewhere I don't know, but I'm hoping it's in the program, because
> if it's elsewhere I have a *lot* of tedious digging and testing ahead of
> me and little real idea of where to start.

You could start by running the program under strace.  That should give 
you a good idea of where the problem begins.

Alan Stern
