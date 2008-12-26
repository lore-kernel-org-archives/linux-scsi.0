From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: USB HD: No Sense / Info fld=0x0 and read corruption
Date: Fri, 26 Dec 2008 11:37:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812261134090.16258-100000@netrider.rowland.org>
References: <4954B40E.80403@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4954B40E.80403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ludovico Cavedon <ludovico.cavedon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 26 Dec 2008, Ludovico Cavedon wrote:

> A question:
> If I rewrite these sectors I can fix these errors (at least
> temporarily). I also noticed that when the "check condition" bit is set
> some data is also tranferred. Is there get these partial data (e.g. with
> dd)?

Not the way you're thinking.  I believe wireshark is able to monitor 
USB packets, so you could see the raw data that way.

Also there are tools like the sg-utils package or plscsi, which
provide a way for you to send specific SCSI commands to a device and
see exactly what the results are.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
