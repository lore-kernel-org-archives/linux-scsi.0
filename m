From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 19:47:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117184737.GA21846@devserv.devel.redhat.com>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org> <20040117165226.GA29531@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47292 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266146AbUAQSr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 13:47:58 -0500
Content-Disposition: inline
In-Reply-To: <20040117165226.GA29531@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 17, 2004 at 05:52:26PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 16, 2004 at 12:02:50PM -0800, Andrew Vasquez wrote:
> > Now from a development and maintenance standpoint, I can understand
> > the reluctance of having to accept a 100K file for each ISP type.
> > But, let me just say QLogic is looking into other ways of distributing
> > firmware images.  Finally, given the addition of some new binary-load
> > user->kernel space facilities (namely request_firmware()) the space
> > issue becomes moot.
>=20
> If we go to request_firmware the frontend modules are mood and we should
> just kill all of them.

the "problem" for now is booting from qlogic; initrd's in current distros
don't work with request_firmware yet... while I'm sure this is a temporary
inconvenience, it is a real one. And it's not like the frontend modules are
THAT huge to keep around for a while until enough distros have this working
well.

Greetings,
    Arjan van de Ven

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFACYNJxULwo51rQBIRAvMkAJ9ibBtr/whwsyB+K1CdhYgHO4HK+gCeJb41
eRJPi5OWbS56GLj5knSTFNk=
=MjiN
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
