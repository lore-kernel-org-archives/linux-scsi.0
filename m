From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 00:06:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014000602.F30278@one-eyed-alien.net>
References: <20021014054035.GA10686@codepoet.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="1Y7d0dPL928TPQbc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014054035.GA10686@codepoet.org>; from andersen@codepoet.org on Sun, Oct 13, 2002 at 11:40:35PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: linux-scsi@vger.kernel.org, USB Storage List <usb-storage@one-eyed-alien.net>


--1Y7d0dPL928TPQbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well... dang.  I've been hoping this would appear for quite some time.  I'm
just not good enough with the SCSI layer to really make this stable.

How stable is this?  I'd love to see this in 2.5 before the Oct 31 feature
freeze, so USB Mass Storage can use this.  Stability is my major concern --
someone has to agree to work on this to make it stable to use, and work out
any possible corner-cases and race conditions.

But, heck.. this is 2.5 -- I say let's include it, use it, and then shake
the bugs out.

Matt

On Sun, Oct 13, 2002 at 11:40:35PM -0600, Erik Andersen wrote:
> Using the following patch I am able to make ieee1394 properly
> connect and disconnect SBP-2 devices to/from the SCSI subsystem.
> Without this patch, firewire devices are only registered with the
> SCSI subsystem if they are connected when the host adaptor is
> registered, and are only unregistered from the SCSI subsystem
> when the firewire driver modules are removed from the kernel.
> This is far from desirable...
>=20
> This patch works by exporting within the kernel the functionality
> already provided to userspace via /proc/scsi/scsi, i.e.:
> 	echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
> and=20
> 	echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
> is exported within the kernel as scsi_add_single_device() and=20
> scsi_remove_single_device().  A separate patch to the sbp2 driver
> then uses these interfaces when devices are plugged or unplugged.
> After looking though the current code, there does not seem to be
> any other way to accomplish the same thing using the current SCSI
> infrastructure.  Anyone have any objections to such a patch?  For
> 2.4.x?  Comments?=20
>=20
> Please CC me as I am not subscribed to linux-scsi, thanks,
>=20
>  -Erik

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  Why are you upgrading to NT?
AJ: It must be the sick, sadistic streak that runs through me.
					-- Chief and A.J.
User Friendly, 5/12/1998

--1Y7d0dPL928TPQbc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qmzaIjReC7bSPZARArSpAKC4zJ1RlTBtdpHUjeQBTszsUuQXngCbBOpV
hlmrsKoWh2Knh5PNlLcwkOg=
=wkb7
-----END PGP SIGNATURE-----

--1Y7d0dPL928TPQbc--
