From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: SCSI IO Errors
Date: Sat, 6 Sep 2003 18:06:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030906160652.GI14376@lug-owl.de>
References: <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pui5YDBJbCQuJ1A1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dvmwest.gt.owl.de ([62.52.24.140]:28877 "EHLO dvmwest.gt.owl.de")
	by vger.kernel.org with ESMTP id S262489AbTIFQGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2003 12:06:53 -0400
Content-Disposition: inline
In-Reply-To: <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--Pui5YDBJbCQuJ1A1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2003-09-06 17:16:22 +0200, Matthias Jaenichen <mj2@percomp.de>
wrote in message <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>:
> I am experiencing IO-errors with my System. This is now for weeks and I a=
m=20
> stuck with debugging.

What SCSI host adaptor do you use? 'lspci' AND 'lspci -n' will help.

What SCSI driver do you use with them ('dmesg' will show)

What HDDs do you use? Eg. 'dmesg' will show the exact name.

> Please advise me where/how to continue with debugging.

Unfortunately, you don't provide any useable infos about your problem.
Possibly, simply your HDDs are gone bad and need to be exchanged.

MfG, JBG

--=20
   Jan-Benedict Glaw       jbglaw@lug-owl.de    . +49-172-7608481
   "Eine Freie Meinung in  einem Freien Kopf    | Gegen Zensur | Gegen Krieg
    fuer einen Freien Staat voll Freier B=FCrger" | im Internet! |   im Ira=
k!
      ret =3D do_actions((curr | FREE_SPEECH) & ~(IRAQ_WAR_2 | DRM | TCPA));

--Pui5YDBJbCQuJ1A1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WgYbHb1edYOZ4bsRAt4pAJ9r/bSb+82/eTSAosJBZ0M7AKJ62gCeJDcx
QSSAUISeWw9Fx8GVhHWhNtc=
=ZnDq
-----END PGP SIGNATURE-----

--Pui5YDBJbCQuJ1A1--
