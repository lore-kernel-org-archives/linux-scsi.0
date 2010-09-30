From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Thu, 30 Sep 2010 08:04:05 +0200
Message-ID: <201009300804.11861.eike-kernel@sf-tec.de>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com> <201009281513.53869.oliver@neukum.org> <20100929005413.GB4689@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1537717.PBWT9tSkvM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:35803 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab0I3GES (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2010 02:04:18 -0400
In-Reply-To: <20100929005413.GB4689@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, greg@kroah.com, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, sarah.a.sharp@linux.intel.com, Matthew Wilcox <matthew.r.wilcox@intel.com>

--nextPart1537717.PBWT9tSkvM
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Matthew Wilcox wrote:
> On Tue, Sep 28, 2010 at 03:13:53PM +0200, Oliver Neukum wrote:
> > Am Dienstag, 28. September 2010, 12:14:56 schrieb Matthew Wilcox:

> > > +	cmnd->result =3D sense_iu->status;
> > > +	if (sdev->current_cmnd)
> > > +		sdev->current_cmnd =3D NULL;
> >=20
> > the condition is absolutely senseless
>=20
> That's not true.  Avoiding dirtying a cacheline is important for
> performance.

Go and tell your processor division to only mark a cacheline as dirty if it=
=20
was actually changed by a write. They are throwing so much resources on thi=
ngs=20
like SSE9 and the hell that they can probably afford doing that sort of=20
optimizations. Or they already do and this condition is absolutely senseles=
s=20
;)

Eike

--nextPart1537717.PBWT9tSkvM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkykKFsACgkQXKSJPmm5/E5D9ACfcb5puun7YL6sXOEPKCOX0N39
sN4An1n0/HIDXM0HlltX8w9UAf+YsbI3
=9bpN
-----END PGP SIGNATURE-----

--nextPart1537717.PBWT9tSkvM--
