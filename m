From: Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 16:53:06 +0000
Message-ID: <20081027165306.GA3875@bit.office.eurotux.com>
References: <20081027151818.GA4044@bit.office.eurotux.com> <Pine.LNX.4.44L0.0810271134530.15462-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810271134530.15462-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Linux-Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 27, 2008 at 11:38:13AM -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, Luciano Rocha wrote:
>=20
> > Hm, where in the code can I change it to return less that what it t=
hinks
> > is the last sector?
>=20
> I can write a patch to do that for you.  However I'm more interested =
in=20
> solving the "infinite-retry" problem first.
>=20
> I did write some patches which might help.  They weren't meant as bug=
=20
> fixes exactly, more as infrastructure cleanup.  But you ought to try=20
> them out, because they do affect the logic in this area.
>=20
> The patches are here:
>=20
> 	http://marc.info/?l=3Dlinux-scsi&m=3D122443015406309&w=3D2
>=20
> They are based on 2.6.27, not 2.6.28-rc.

I've tested them (on 2.6.27.4), but I still get the bug. That email men=
tions:
"Neither patch addresses the infinite-retry problem; I wanted
to keep the issues separate."

So am I missing some other patch?

2.6.28-rc2 is also buggy.

Thanks,
Luciano Rocha

--=20
Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
