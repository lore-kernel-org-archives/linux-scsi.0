From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Sat, 25 Oct 2008 15:50:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810251548300.7245-100000@netrider.rowland.org>
References: <200810252125.44184.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200810252125.44184.rjw-KKrjLPT3xs0@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Cc: Linux-Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:

> [Adding CCs]
> 
> On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > 
> > Hello,
> > 
> > An external HDD, usb-encased, works fine under 2.6.26.5, but under
> > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current]'.

You can use usbmon to capture the details of what happens when you plug
in the drive.  Instructions are in the kernel source file
Documentation/usb/usbmon.txt.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
