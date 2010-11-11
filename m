From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 09:07:53 -0800 (PST)
Message-ID: <151524.65160.qm@web31809.mail.mud.yahoo.com>
References: <20101111165717.GA8526@kroah.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101111165717.GA8526-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--- On Thu, 11/11/10, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Nov 11, 2010 at 08:49:51AM
> -0800, Luben Tuikov wrote:
> > --- On Thu, 11/11/10, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
> wrote:
> > > On Fri, Oct 22, 2010 at 02:12:51PM
> > > -0700, Luben Tuikov wrote:
> > > > This patch solves two things:
> > > > 1) Enables autosense emulation code to
> correctly
> > > > interpret descriptor format sense data, and
> > > > 2) Fixes a bug whereby the autosense
> emulation
> > > > code would overwrite descriptor format sense
> data
> > > > with SENSE KEY HARDWARE ERROR in fixed
> format, to
> > > > incorrectly look like this:
> > > >=20
> > > > Oct 21 14:11:07 localhost kernel: sd
> 7:0:0:0:
> > > [sdc]? Sense Key : Recovered Error [current]
> > > [descriptor]
> > > > Oct 21 14:11:07 localhost kernel: Descriptor
> sense
> > > data with sense descriptors (in hex):
> > > > Oct 21 14:11:07 localhost kernel:? ? ?
> > > ? 72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00
> 00
> > > > Oct 21 14:11:07 localhost kernel:? ? ?
> > > ? 00 4f 00 c2 00 50
> > > > Oct 21 14:11:07 localhost kernel: sd
> 7:0:0:0:
> > > [sdc]? ASC=3D0x4 ASCQ=3D0x1d
> > > >=20
> > > > Signed-off-by: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > >=20
> > > I need to get the ack from the usb-storage
> > > maintainer.? Can you get that
> > > so that I can apply this?
> >=20
> > Hi Greg,
> >=20
> > I don't know who the usb-storage maintainer is, as
> I've mostly
> > contributed to linux-scsi. Do you?
>=20
> $ ./scripts/get_maintainer.pl --roles --file
> drivers/usb/storage/usb.c
> Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
> (maintainer:USB MASS STORAGE...)
> Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>
> (supporter:USB SUBSYSTEM)
> linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> (open list:USB MASS STORAGE...)
> usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
> (open list:USB MASS STORAGE...)
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> (open list)
>=20
> Or you can just look in the MAINTAINERS file :)

Oh, and I was looking for the MAINTAINERS file in Documentation/.

Wow! There is actually a "get_maintainer" script!? Unbelievable!

> > I know Alan acked this patch. Is it him? Any reason
> you didn't CC the
> > usb-storage maintainer in this email?=A0 Can you
> reply back to this
> > thread CC-ing him? The only email I have in my address
> book is yours.
>=20
> Please resend your patch to Matthew, and the people and
> lists listed
> above.=A0 I need his ack before I can take it.

Oh, I see. I'll re-post the patch then to Matthew and the people and li=
sts you listed above.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
