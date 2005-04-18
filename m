From: folkert@vanheusden.com
Subject: Re: [ANNOUNCE] sdparm 0.90
Date: Mon, 18 Apr 2005 21:52:47 +0200
Message-ID: <20050418195245.GV30729@vanheusden.com>
References: <4263B56B.2010905@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="finhkSr2yyrWw3ow"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from keetweej.xs4all.nl ([213.84.46.114]:49080 "EHLO
	keetweej.vanheusden.com") by vger.kernel.org with ESMTP
	id S262186AbVDRTwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 15:52:49 -0400
Content-Disposition: inline
In-Reply-To: <4263B56B.2010905@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org


--finhkSr2yyrWw3ow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

oh wait, 2.6 yes?
then forget my bugreport (running 2.4.26-NANO)

On Mon, Apr 18, 2005 at 11:26:03PM +1000, Douglas Gilbert wrote:
> sdparm is a new command line utility designed to get and set
> SCSI disk parameters (cf hdparm for ATA disks). More generally
> it gets and sets mode page information on SCSI devices or devices
> that use a SCSI command set (e.g. CD/DVD drives (any transport)
> and SCSI tape drives).
>=20
> The elements within mode pages are addressed via acronyms
> (e.g. "WCE" for "write cache enable" in the caching mode
> page). There is also numeric addressing of the form:
> <start_byte>:<start_bit>:<num_bits>
> This symbolic or numeric addressing should be more
> convenient for changing parameters than the techniques used
> by scsiinfo, sginfo and sg_wr_mode.
>=20
> A GUI wrapping sdparm would be a useful extension.
> It could show the mode page as found in the standard or
> the vendor's product manual with attributes such as
> "changeable" represented by colour or shading.
>=20
> I hope to add VPD pages in the future. sdparm shares some
> code with sg3_utils but is currently independent; they may
> share a library (libsgutils) in the future.
>=20
> A tarball, rpms and a "deb" can be found on
> http://www.torque.net/sg .
> Currently, the most complete documentation is in the
> man page.
>=20
>=20
> Examples (taken from the man page):
> To list the common (mode) parameters of a disk:
>=20
>     sdparm /dev/sda
>=20
> To see all parameters for the caching control mode page:
>=20
>     sdparm --page=3Dca /dev/sda
>=20
> To get the WCE values (current changeable default and
> saved) in hex:
>=20
>     sdparm -g WCE -H /dev/sda
>   0x01 0x00 0x01 0x01
>=20
> To get the WCE current value in hex:
>=20
>     sdparm -g WCE=3D1 -H /dev/sda
>   0x01
>=20
> To set the "write cache enable" bit in the current page:
>=20
>     sdparm --set=3DWCE /dev/sda
>=20
> To set the "write cache enable" bit in the current and
> saved page:
>=20
>     sdparm --set=3DWCE --save /dev/sda
>=20
> To set the "write cache enable" and clear "read cache
> disable":
>=20
>     sdparm --set=3DWCE --clear=3DRCD --save /dev/sda
>=20
> The previous example can also by written as:
>=20
>     sdparm -s WCE=3D1,RCD=3D0 -S /dev/sda
>=20
> To re-establish the manufacturer?s defaults in the
> current and saved caching control mode page:
>=20
>     sdparm --page=3Dca --defaults -save /dev/sda
>=20
> If an ATAPI cd/dvd player is at /dev/hdc then its common
> (mode) parameters could be listed with:
>=20
>           sdparm /dev/hdc
>=20
>=20
> Comments, suggestions and patches welcome.
>=20
>=20
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Folkert van Heusden

Auto te koop, zie: http://www.vanheusden.com/daihatsu.php
Op zoek naar een IT of Finance baan? Mail me voor de mogelijkheden.
--------------------------------------------------------------------
 UNIX admin? Then give MultiTail (http://vanheusden.com/multitail/)=20
 a try, it brings monitoring logfiles to a different level! See    =20
 http://vanheusden.com/multitail/features.html for a feature-list. =20
--------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE
Get your PGP/GPG key signed at www.biglumber.com!

--finhkSr2yyrWw3ow
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iIMEARECAEMFAkJkEA08Gmh0dHA6Ly93d3cudmFuaGV1c2Rlbi5jb20vZGF0YS1z
aWduaW5nLXdpdGgtcGdwLXBvbGljeS5odG1sAAoJEDAZDowfKNiuTcUAn39Ofe2H
khmNr7GT4QfyT0HsRwmDAJ4kZaAf1/l/WmRgrgUPLXkR6DvHlg==
=I9gT
-----END PGP SIGNATURE-----

--finhkSr2yyrWw3ow--
