From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Tue, 23 Nov 2010 00:43:09 -0800 (PST)
Message-ID: <987735.18126.qm@web31812.mail.mud.yahoo.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--- On Mon, 11/22/10, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org> =
wrote:

> That said, Luben's patch is kinda slick.

Thank you.

> sd-modalready asks for a lot of
> mode page data; it does this so that it's request matches
> the observed
> behavior of a "popular" Redmond, WA-based OS.=A0 Luben's
> patch just searches
> through that data to see if it can find what it is looking
> for, rather than
> rqeuesting a specific mode page later (which may not be
> supported).

Yes, devices wouldn't sense a change in requests. The patch preserves t=
his quality of device discovery.

   Luben

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
