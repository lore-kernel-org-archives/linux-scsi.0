From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH]
	fusion update to current APIs)
Date: Tue, 15 Jun 2004 09:57:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087286269.2710.13.camel@laptop.fenrus.com>
References: <20040531115229.GA16143@lst.de>
	 <20040612003608.GA152454@sgi.com>
	 <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk>
	 <20040612051353.GA152829@sgi.com>
	 <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk>
	 <20040615060811.GA178857@sgi.com> <40CE9D31.6050606@pobox.com>
	 <20040615075012.GB179379@sgi.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C79xlBvWk17Js5LmRnKi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50647 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265353AbUFOH6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 03:58:32 -0400
In-Reply-To: <20040615075012.GB179379@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org


--=-C79xlBvWk17Js5LmRnKi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> For those new to the thread, the idea is to remove the direction
> overrides from various host drivers and centralize them in sg.  If
> we remove the direction overrides from the host drivers and do not
> add this code to sg, then several apps that use the sg v1 and v2
> interfaces will suddenly break.

can we add a printk to mark the v1 and v2 interfaces deprecated please ?

--=-C79xlBvWk17Js5LmRnKi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAzqv9xULwo51rQBIRAnedAJ9iN1e2QXMaTcYWhoEyI+qcE5OXvACfePiH
5y1EwAYfGuZMGAA9/vzQZBw=
=mDj4
-----END PGP SIGNATURE-----

--=-C79xlBvWk17Js5LmRnKi--

