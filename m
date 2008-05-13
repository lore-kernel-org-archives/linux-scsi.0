From: Ingo Saitz <Ingo.Saitz@stud.uni-hannover.de>
Subject: Re: PROBLEM: 2.6.25: sr0 cdrom does not change medium size on
	medium change
Date: Tue, 13 May 2008 18:09:10 +0200
Message-ID: <20080513160910.GA2554@schwan.zoo>
References: <20080508112108.GA2744@schwan.zoo> <20080512203422.GA2641@schwan.zoo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:43888 "EHLO
	studserv.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756568AbYEMQJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2008 12:09:19 -0400
Received: from schwan.zoo (ingo@localhost [127.0.0.1])
	by studserv.stud.uni-hannover.de (8.13.8/8.13.8) with ESMTP id m4DG9CgM019041
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2008 18:09:13 +0200 (MEST)
Received: from ingo by schwan.zoo with local (Exim 4.69)
	(envelope-from <ingo@schwan.zoo>)
	id 1Jvx3u-0000h3-ND
	for linux-scsi@vger.kernel.org; Tue, 13 May 2008 18:09:10 +0200
Content-Disposition: inline
In-Reply-To: <20080512203422.GA2641@schwan.zoo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Maybe this is related to a change in the logic of CDROM_DRIVE_STATUS.
Using test.c from http://marc.info/?l=linux-scsi&m=120231922209420&w=2
there is a big difference in the responses from 2.6.24 (working) and
2.6.25 (broken):

		2.6.25		2.6.24
empty drive	CDS_NO_DISC	CDS_TRAY_OPEN
opening tray	CDS_TRAY_OPEN	CDS_TRAY_OPEN
inserting disc	CDS_NO_DISC	waits for drive to settle, then CDS_DISK_OK
drive setteled	CDS_DISK_OK	CDS_DISK_OK

Please tell me if you need more data...

    Ingo

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKb0m4XrXtQkN2NURAlD0AJ0ZlOkgnYzMEyJwWQvY6Ve7f0jznwCeM4+0
rqsvrdYErrSZRpHUNogdXig=
=9IoF
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
