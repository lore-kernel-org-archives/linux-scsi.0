From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Fri, 28 May 2004 19:39:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085765950.4343.1.camel@laptop.fenrus.com>
References: <40B74725.90403@torque.net>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hKOaTVZTLN/Mf1VLGGXc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59533 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263750AbUE1RjR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 13:39:17 -0400
In-Reply-To: <40B74725.90403@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-hKOaTVZTLN/Mf1VLGGXc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> that are broken by the "forcing" nature of this change (e.g.
> mtx).

users seem to say that mtx works as long as you point it to the right
device.... after all the ioctls are the same

THe only big difference seems to be that the generic ioctl does enforce
queue limits while sg does "something else" when it an
invalid-for-the-device IO gets issued..

--=-hKOaTVZTLN/Mf1VLGGXc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAt3k9xULwo51rQBIRAk+DAJ4g+9n+0Lnc/tSO0xQLd5pLiSl+QQCfVyOA
sp5RKrGF2MRiYqFDWyqgTNU=
=tDxy
-----END PGP SIGNATURE-----

--=-hKOaTVZTLN/Mf1VLGGXc--

