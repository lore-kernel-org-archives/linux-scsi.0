From: "Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
Date: Tue, 8 Jul 2008 15:53:36 +0200 (CEST)
Message-ID: <14162.84.245.32.19.1215525216.squirrel@secure.samage.net>
References: <Pine.LNX.4.44L0.0806241032490.2160-100000@iolanthe.rowland.org>
    <13988.84.245.32.19.1215522030.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13988.84.245.32.19.1215522030.squirrel-SDEzVqVlFnWIX31SJU4CB16hYfS7NtTn@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Indan Zupancic <indan-1J6HnF7K7zE@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB development list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, July 8, 2008 15:00, Indan Zupancic wrote:
> Any idea why my cardreader doesn't work in the first place though?

In case it's useful, an usbmon dump can be found at http://pastebin.org/49630
This is the log of plugging in the thing and unplugging it again after it failed.
Corresponding dmesg output with USB and usb-storage debugging enabled at
http://pastebin.org/49631. This is on 2.6.26-rc9 with Alan's patch applied.

Regards,

Indan


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
