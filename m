From: Paul Blazejowski <paulb@blazebox.homeip.net>
Subject: Re: Linux [2.6.0-test3/mm1] aic7xxx problems.
Date: Mon, 11 Aug 2003 13:39:36 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1060623576.2826.9.camel@blaze.homeip.net>
References: <1060543928.887.19.camel@blaze.homeip.net>
	 <2425882704.1060622541@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dbGIbpTobs9p7O/A5Ox4"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <2425882704.1060622541@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-dbGIbpTobs9p7O/A5Ox4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-08-11 at 13:22, Justin T. Gibbs wrote:

> > On a side note, the same aic7xxx drivers version 6.2.8 and 6.2.36 works
> > with 2.4.21 and 2.4.22-rc1/rc2 series of kernel with above hardware.
>=20
> I don't think that any of the changes between 6.2.35 and 6.2.36 will
> make a difference for you, but you could try upgrading.  The source
> files are here:
>=20
> http://people.FreeBSD.org/~gibbs/linux/SRC/
>=20

Tried those already on both 2.4.21/22 and 2.6.0-test1,2,3.
While the 2.4 driver compiles and works fine the 2.5 sources does not
play nice with 2.6.0-test* kernel.I had to change the includes to blkdev
in the source and then there was few compile warnings.I can try to
provide the exact ones, unless there's a driver that applies to
2.6-test* cleanly.Once i had it compiled the kernel would just panic.

> The console output you've provided makes me think that interrupts are
> not working correctly in your system.
>=20

Is this due to my mainboard (nforce2),cpu,ACPI,devfs,sysfs...or all
these together?

I tried swapping the SCSI controller card in various PCI slots,used new
and original working cables,changed the BIOS IRQ's...etc

I start running of ideas here, is there other options to fully debug the
problem? What else can i try? I would appreciate any pointers.

I would like to get things working with 2.6.0 kernels...right now only
aic7xxx_old is somehow working but that's not the solution to the
problem.

> --
> Justin
>=20
>=20

Thank you for your time.

Paul



--=-dbGIbpTobs9p7O/A5Ox4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/N9TYIymMQsXoRDARAtZpAJ9AQWIpy0PqqRakKYIx11LWbEDepACfcgEk
4FziIJQo/BN6OGgCs0uYiQ0=
=R+EV
-----END PGP SIGNATURE-----

--=-dbGIbpTobs9p7O/A5Ox4--
