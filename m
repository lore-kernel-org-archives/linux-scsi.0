From: Arjan van de Ven <arjanv@redhat.com>
Subject: RE: [PATCH] dead code and missing statics in lpfc
Date: Thu, 10 Jun 2004 16:43:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086878631.2733.13.camel@laptop.fenrus.com>
References: <3356669BBE90C448AD4645C843E2BF28034F9495@xbl.ma.emulex.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BbmA2EVgb486cwy05U85"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:62342 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261396AbUFJOoA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 10:44:00 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9495@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org


--=-BbmA2EVgb486cwy05U85
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>=20
>  Many would consider including this content, for no
> "standard" purpose, is another way to add crud to the driver.  Making
> symbols available was a means to avoiding this latter issue.

a separate .c file that conditionally compiles into the driver is in my
opinion far less "crud" than blind hooks. The former allows for a
cleaner implementation I'm sure, AND has the benefit of being able to
see what is being done, so that any restructuring can 1) take it into
account and 2) fix it up on the go.



--=-BbmA2EVgb486cwy05U85
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAyHOnxULwo51rQBIRAmwiAKCBPzYm7YBlz+b6qzy11a153HLtegCeMcJn
+N1lZ+jwq07FcWgjKYB/lkU=
=KQv4
-----END PGP SIGNATURE-----

--=-BbmA2EVgb486cwy05U85--

