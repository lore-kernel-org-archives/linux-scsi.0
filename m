From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: PATCH [0/8]  qla2xxx: Summary of changes...
Date: Tue, 07 Sep 2004 08:00:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094536856.2801.3.camel@laptop.fenrus.com>
References: <20040907042603.GA29557@praka.san.rr.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GablBUfSZEXTeYgPFy+B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:30366 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265207AbUIGGBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 02:01:11 -0400
In-Reply-To: <20040907042603.GA29557@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>


--=-GablBUfSZEXTeYgPFy+B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-09-07 at 06:26, Andrew Vasquez wrote:
> James,
>=20
> Please apply the following patches I'm about to send to update the
> qla2xxx driver.  A summary of the patches can be found towards the end
> of this message.


Hi,

I found a "funky" bug the other day with this driver; I was testing on a
RAID device of which I won't mention the vendor, but it had the habit of
returning QUEUE FULL when it's internal queue was full, with multiple
luns active that could even be on a lun which had exactly zero
outstanding IO already. The qlogic driver happily takes the number of
outstanding commands (0) and subtracts 1 from it to guestimate the
max... needless to say that didn't go down to well :-) Sounds like a
bound check would make sense here...

Greetings,
   Arjan van de Ven

--=-GablBUfSZEXTeYgPFy+B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBPU6YxULwo51rQBIRAsoMAJ9jd8HcuCC8ZYwkkItwvndZeAKRDACfR0o2
sG4hSDotxIkDEcI7E+Eal/0=
=IGw2
-----END PGP SIGNATURE-----

--=-GablBUfSZEXTeYgPFy+B--

