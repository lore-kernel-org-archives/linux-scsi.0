From: Frederik Schueler <fs@lowpingbastards.de>
Subject: Re: new qla2xxx driver breaks SAN setup with 2 controllers
Date: Thu, 25 Aug 2005 13:42:30 +0200
Message-ID: <20050825114230.GP5564@mail.lowpingbastards.de>
References: <20050823112535.GB13391@mail.lowpingbastards.de> <20050823200040.GA8310@us.ibm.com> <20050824095520.GD13391@mail.lowpingbastards.de> <20050824100112.GA27216@infradead.org> <20050824124803.GE13391@mail.lowpingbastards.de> <20050824125022.GA29817@infradead.org> <20050824130823.GF13391@mail.lowpingbastards.de> <20050824170352.GA16652@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from defiant.lowpingbastards.de ([213.178.77.226]:3492 "EHLO
	mail.lowpingbastards.de") by vger.kernel.org with ESMTP
	id S964946AbVHYLnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 07:43:23 -0400
Content-Disposition: inline
In-Reply-To: <20050824170352.GA16652@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Frederik Schueler <fs@lowpingbastards.de>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

your patch works!

first a box booting from a gdth:

a01:~# lsscsi=20
[0:0:0:0]    disk    ICP      Host Drive  #00        /dev/sda
[0:2:6:0]    process SUPER    GEM318           0     -      =20
[1:0:0:10]   disk    IFT      A16F-R1211       334B  /dev/sdb
[1:0:0:12]   disk    IFT      A16F-R1211       334B  /dev/sdc
[1:0:0:14]   disk    IFT      A16F-R1211       334B  /dev/sdd
[1:0:1:9]    disk    IFT      A16F-R1211       334B  /dev/sde
[1:0:1:11]   disk    IFT      A16F-R1211       334B  /dev/sdf
[1:0:1:13]   disk    IFT      A16F-R1211       334B  /dev/sdg


and this is one of the cluster nodes, wich boots from san:

s06:~# lsscsi=20
[0:0:0:3]    disk    IFT      A16F-R1211       334B  /dev/sda
[0:0:0:10]   disk    IFT      A16F-R1211       334B  /dev/sdb
[0:0:0:12]   disk    IFT      A16F-R1211       334B  /dev/sdc
[0:0:0:14]   disk    IFT      A16F-R1211       334B  /dev/sdd
[0:0:1:9]    disk    IFT      A16F-R1211       334B  /dev/sde
[0:0:1:11]   disk    IFT      A16F-R1211       334B  /dev/sdf
[0:0:1:13]   disk    IFT      A16F-R1211       334B  /dev/sdg


it finds everything on bootup.


Best regards
Frederik Schueler

--=20
ENOSIG

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDa6m6n7So0GVSSARAiklAKCM1/yO4I/Td3J9jA3ZJEOvuK9L4QCfUdBO
SffmbjPQE011iHE2+2pIFis=
=FuJg
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
