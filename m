From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: increasing host numbers
Date: Tue, 24 Jun 2003 09:04:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624090402.A19535@one-eyed-alien.net>
References: <3EF808FA.5020503@torque.net> <20030624124327.A8155@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:12808 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262955AbTFXPuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 11:50:12 -0400
Content-Disposition: inline
In-Reply-To: <20030624124327.A8155@infradead.org>; from hch@infradead.org on Tue, Jun 24, 2003 at 12:43:27PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2003 at 12:43:27PM +0100, Christoph Hellwig wrote:
> On Tue, Jun 24, 2003 at 06:16:58PM +1000, Douglas Gilbert wrote:
> > It seems as though host numbers are no longer re-used.
> > This pattern started in lk 2.5.73:
>=20
> So far this was intentional, so I'd call it a feature.  If you think
> this is not good we can add some kind of bitmap to get free host number.

Is there any danger of 'running out'?  i.e is rollover handled properly?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I need a computer?
					-- Customer
User Friendly, 2/19/1998

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE++HZyIjReC7bSPZARAmyxAKDR98jvhBL2iKV8Zv3Y6wLneiLMuACgxfnl
n3ETm1Hu9wTMoY0HLuHdndc=
=JkVp
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
