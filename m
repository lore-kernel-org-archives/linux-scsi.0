From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [dm-devel] Re: Is there a grand plan for FC failover?
Date: Thu, 12 Feb 2004 16:28:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076599721.4442.4.camel@laptop.fenrus.com>
References: <20040128100236.D11527@vienna.EGENERA.COM>
	 <1075309052.2254.6.camel@mulgrave>
	 <20040128130040.E11527@vienna.EGENERA.COM>
	 <20040128124756.A7232@beaverton.ibm.com>
	 <1075328066.2534.10.camel@mulgrave>
	 <20040128165534.A9202@beaverton.ibm.com> <20040130194826.GC31596@reti>
	 <20040131093037.GR11683@suse.de> <20040131115903.A4881@vienna.EGENERA.COM>
	 <20040131174201.GC11683@suse.de> <20040212101705.F27680@vienna.EGENERA.COM>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-agheSmLTDvhDt9surjyE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:7555 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S266478AbUBLP3u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 10:29:50 -0500
In-Reply-To: <20040212101705.F27680@vienna.EGENERA.COM>
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-agheSmLTDvhDt9surjyE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> That size is based on the blocksize? Is there a way to set the block size=
 higher than
> 512 w/o mounting it? I've gotten really bad rawio performance on 2.4. sin=
ce I have a=20
> limit of 32 sg entries. When Rawio uses a 512 byte blocksize IOs are limi=
ted to 16K.=20
>=20
> Will this still be a problem in 2.6?

If you code the driver right, it's not even a problem in 2.4 if you use
a Enterprise Linux distro kernel.....


--=-agheSmLTDvhDt9surjyE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAK5uoxULwo51rQBIRAj91AKCcs8DSo3vZsSbFwyc3TkxZHhr4kgCgmdv9
zYer4zI6zgoAUI4eEY67NIw=
=BM4R
-----END PGP SIGNATURE-----

--=-agheSmLTDvhDt9surjyE--
