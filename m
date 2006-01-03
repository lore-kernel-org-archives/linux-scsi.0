From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Tue, 3 Jan 2006 08:51:30 +0100
Message-ID: <200601030851.30624@bilbo.math.uni-mannheim.de>
References: <1135801791.9541.12.camel@gateway.markschaefer.org> <1136168563.3768.3.camel@localhost.localdomain> <yq1oe2u2z6i.fsf@wilson.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10148401.92jI9D1scF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:6310 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751191AbWACHv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 02:51:57 -0500
In-Reply-To: <yq1oe2u2z6i.fsf@wilson.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: linux-scsi@vger.kernel.org

--nextPart10148401.92jI9D1scF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 2. Januar 2006 20:43 schrieben Sie:
>>>>>> "Mark" =3D=3D Mark Schaefer <mark@markschaefer.org> writes:
>
>Mark> 	Also, any info on the Tachyon chips would be helpful.  I have
>Mark> a TS and a HPFC-5000C (32-bit old chip).
>
>HPFC-5000 is the original HP Tachyon design which my driver won't
>support.  It doesn't have FCP support in hardware or anything.  My
>driver only does TachLite.
>
>My aim is to support the following boards:
>
>HP A5156A	HPFC-5100 /2.0	(TL)
>HP A5157A	HPFC-5100B/2.2	(TL) dual port
>HP A5158A	HPFC-5100C/2.3	(TL)
>HP A5158A	HPFC-5100D/3.0	(TL)
>HP A6795A	HPFC-5200C/2.2	(XL2)
>Compaq FC HBA   HPFC-5166A/1.2  (TS)
>
>The Compaq FC HBA is the one that the RA-4x00 people have.  I don't
>have this controller yet but there should be one waiting for me at the
>post office once the world goes out of suspend mode tomorrow...

Ok, can you collect such a list of the "other" cards that your driver does =
not=20
support? And a list of PCI ids that match both lists?

These are the devices supported by the original cpqfc driver:

#define PCI_DEVICE_ID_COMPAQ_TACHYON    0xa0fc
#define PCI_DEVICE_ID_HP_TACHYON        0x1028
#define PCI_DEVICE_ID_HP_TACHLITE       0x1029

I now own a Agilent HHBA-5121. What's that for a thing?

Eike

--nextPart10148401.92jI9D1scF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDui0CXKSJPmm5/E4RAkB8AJ42DTTA9uvEitm1iZdJDqO0gQIMvgCfaY4Z
NNxmct3lnD5SK46Abm42G1o=
=cVnq
-----END PGP SIGNATURE-----

--nextPart10148401.92jI9D1scF--
