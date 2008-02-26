From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: Advansys regression between 2.6.23.8 and 2.6.24.2
Date: Tue, 26 Feb 2008 15:55:40 +0100
Message-ID: <20080226155540.653222cc@crazy>
References: <20080214161024.2a0c0f17@crazy>
	<1203004258.3189.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/j1nMJvKKn4W265C2vvvIZ0m";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.191.46.45]:3253 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYBZPPy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Feb 2008 10:15:54 -0500
In-Reply-To: <1203004258.3189.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, gregkh@suse.de, chrisw@sous-sol.org

--Sig_/j1nMJvKKn4W265C2vvvIZ0m
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi James,

Le Thu, 14 Feb 2008 09:50:58 -0600,
James Bottomley <James.Bottomley@HansenPartnership.com> a =C3=A9crit :

> Yes, it's already on its way to stable.  The process requires the fix
> to be committed upstream first.  There's an automated script that
> sends these commits back to stable once they're upstream (provided
> they're tagged correctly).

I might be wrong, but I don't see this patch in 2.6.24.3, which has
just been released.

Sincerly,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/j1nMJvKKn4W265C2vvvIZ0m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxChs9lPLMJjT96cRAoyTAJ9AE6paCW/oNHo5zjNK/WWknGObwwCfbfm3
I7RTFcCTQ/2LAkMe+TCGMj4=
=/vCi
-----END PGP SIGNATURE-----

--Sig_/j1nMJvKKn4W265C2vvvIZ0m--
