From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Mon, 29 Mar 2010 14:28:53 -0700
Message-ID: <20100329212853.GA6996@xanatos>
References: <4BA9D74F.9040507@gmail.com>
 <4BA7797F.8060605@gmail.com>
 <20100324155917.GA4382@xanatos>
 <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com>
 <20100326184021.GA4350@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100326184021.GA4350@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 26, 2010 at 11:40:21AM -0700, Sarah Sharp wrote:
> On Wed, Mar 24, 2010 at 07:07:58PM +0100, Jonas Schwertfeger wrote:
> > On Wed, Mar 24, 2010 at 4:59 PM, Sarah Sharp
> > <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > > Despite the fact that this device probably won't work for 2.6.31 =
or
> > > 2.6.32, the xHCI driver shouldn't be hanging the system. =A0The r=
eset
> > > device API probably shouldn't be back ported to those kernels, bu=
t I can
> > > allow the USB core to disable the device's port instead.
> >=20
> > In 2.6.31 the drive would show up as /dev/sdb and be mountable. The
> > system froze when I mounted it and then tried to partition it. In
> > 2.6.32 however the drive does not even show up in /dev/. Thus, I
> > cannot reproduce a system hang here.
>=20
> Hmm, ok, I would rather figure out why 2.6.31 is hanging, since 2.6.3=
2
> does not.  Can you compile the latest 2.6.31 stable tree and use
> netconsole to capture the crash with CONFIG_USB_XHCI_HCD_DEBUGGING an=
d
> CONFIG_USB_STORAGE_DEBUG turned on?  (I assume you know how to use
> netconsole, but if you don't, I've posted how I setup netconsole at
> http://sarah.thesharps.us/2010-03-26-09-41)

Ping?  Any luck reproducing the hang on 2.6.31 stable?  I tried with a
different unpartitioned USB 3.0 hard drive (SIIG 2.5" drive) on
2.6.31.12, but I didn't find any issues.

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
