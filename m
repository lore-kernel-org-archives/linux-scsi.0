From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Sun, 20 Dec 2009 12:26:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0912201221480.24162-100000@netrider.rowland.org>
References: <2f83750a0912200511n76b95489u57f2c4c62471bbd5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2f83750a0912200511n76b95489u57f2c4c62471bbd5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Clemens Fruhwirth <clemens-Yy/aLhJqNSaEi8DpZVb4nw@public.gmane.org>
Cc: Grant Grundler <grundler-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 20 Dec 2009, Clemens Fruhwirth wrote:

> > Can you run USBMON (see Documentation/usb/usbmon.txt) to capture
> > the initialization sequence and post that to linux-usb? (CC'd already)
> 
> I attached the usbmon dump. I hope you can make sense of it.

Here's the relevant part of the usbmon trace:

> f6a3da00 145121701 S Bo:6:002:1 -115 31 = 55534243 49e50000 08000000 80010a25 00000000 00000000 00000000 000000
> f6a3da00 145122669 C Bo:6:002:1 0 31 >
> f042d280 145122683 S Bi:6:002:2 -115 8 <
> f042d280 145123663 C Bi:6:002:2 0 8 = 001d87ff 00000200
> f6a3da00 145123675 S Bi:6:002:2 -115 13 <
> f6a3da00 145124659 C Bi:6:002:2 0 13 = 55534253 49e50000 00000000 00

The reader reports that the card has 0x1d87ff (= 1935359) blocks, each
containing 0x200 (= 512) bytes, yielding a total size slightly under 1
GB.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
