From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Bug: scsi/scsi_transport.h does not know about struct scsi_target
Date: Thu, 23 Mar 2006 12:38:17 +0100
Message-ID: <200603231238.25114@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1933901.cAv2EL4532";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:20397 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751118AbWCWLiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 06:38:24 -0500
Received: from mp-pc92.informatik.uni-mannheim.de ([::ffff:134.155.64.118]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2006 12:38:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

--nextPart1933901.cAv2EL4532
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

If you include <scsi/scsi_transport.h> and do not include <scsi/scsi_device=
=2Eh>=20
you will get the following error:

include/scsi/scsi_transport.h: In function `scsi_transport_target_data':
include/scsi/scsi_transport.h:78: error: dereferencing pointer to incomplet=
e=20
type
include/scsi/scsi_transport.h:79: error: dereferencing pointer to incomplet=
e=20
type
include/scsi/scsi_transport.h: In function `scsi_transport_device_data':
include/scsi/scsi_transport.h:86: error: dereferencing pointer to incomplet=
e=20
type
include/scsi/scsi_transport.h:87: error: dereferencing pointer to incomplet=
e=20
type

I suggest either including scsi_device.h in scsi_transport.h. Patch on=20
request.

Eike

--nextPart1933901.cAv2EL4532
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBEIoixXKSJPmm5/E4RAj/cAJ4/W5RJTqd9Vxi4xv7sxkn5p22qCACfWLI1
5TPzdXTodSrw1UkT3FgULsI=
=xDU5
-----END PGP SIGNATURE-----

--nextPart1933901.cAv2EL4532--
