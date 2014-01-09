From: walt <w41ter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Wed, 08 Jan 2014 17:22:21 -0800
Message-ID: <52CDF9CD.8010402@gmail.com>
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com> <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com> <20140103232929.GD4193@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140103232929.GD4193@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Laight <david.laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 01/03/2014 03:29 PM, Sarah Sharp wrote:

> I'll let you know when I have some diagnostic patches ready.

Hi Sarah.  I see today gregkh committed the patches you've already sent
me, so I assume someone (other than me) has tested those patches and
discovered some benefit from them?

I'm still wondering if I'm suffering from hardware quirks.  From the
first day I installed my usb3 adapter card and the usb3 disk docking
station I've noticed some quirky behavior.

e.g. I boot the machine with the docking station powered-off, and then
later I power it on, the usb3 disk is not detected at all -- until I
reboot the machine with the docking station still powered on.

Minor stuff, yes, but maybe relevant?  I dunno.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
