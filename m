From: AJ Lewis <alewis@redhat.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take 2
Date: Tue, 7 Sep 2004 10:24:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907152452.GB22719@null.msp.redhat.com>
References: <413557CB.8010008@cs.wisc.edu> <20040901162042.GC26753@null.msp.redhat.com> <20040906143251.GB21646@lst.de> <20040906163336.GE642@parcelfarce.linux.theplanet.co.uk> <413CA924.8030904@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47829 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S268229AbUIGPZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 11:25:32 -0400
Content-Disposition: inline
In-Reply-To: <413CA924.8030904@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 06, 2004 at 11:15:00AM -0700, Mike Christie wrote:
> Matthew Wilcox wrote:
> >On Mon, Sep 06, 2004 at 04:32:51PM +0200, Christoph Hellwig wrote:
> >
> >>On Wed, Sep 01, 2004 at 11:20:42AM -0500, AJ Lewis wrote:
> >>
> >>>Do we want all these attributes in the scsi_host class, or should we p=
ut
> >>>them in the iscsi devices directory?  So in
> >>>/sys/bus/iscsi-sfnet/devices/iscsi1 -
> >
> >
> >Woah, woah, woah.  What's this "iscsi-sfnet" directory in sysfs?  That's
> >just wrong.=20
>=20
> It is only a pseudo bus for the driver from Christoph's suggestion, that's
> just to make probing and removing of the driver's devices easier (it looks
> like a normal scsi driver now).
>=20
> > No way is that crap going into the kernel.  We have to have
> >*one* iscsi infrastructure, not a dozen.
> >
>=20
> Don't worry, there is no way we are going to put transport, scsi or anyth=
ing
> like that there. This driver will use the scsi-ml infrastucture for sysfs
> and this includes using the transport classes. I think this comment from =
AJ,
> was just in error when he was unaware of scsi-ml's transport classes.=20

Yeah - that was me being ignorant of the transport classes.  Speaking of
which, is anyone working on a transport class for iscsi?  I see a patch for
one in the archives
( http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D108033504301079&w=3D2 ),=
 but it
looks like the discussion sort of died off and nothing ever got accepted.  =
I'd
be willing to put together a patch for an iscsi transport class if no one e=
lse
is working on one right now.

Regards,
--=20
AJ Lewis                                   Voice:  612-638-0500
Red Hat Inc.                               E-Mail: alewis@redhat.com
720 Washington Ave. SE, Suite 200
Minneapolis, MN 55414
  =20
Current GPG fingerprint =3D D9F8 EDCE 4242 855F A03D  9B63 F50C 54A8 578C 8=
715
Grab the key at: http://people.redhat.com/alewis/gpg.html or one of the
many keyservers out there...


--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBPdLE9QxUqFeMhxURAoW8AJ0ZNFA1Qe/8vPSCSkwfuUPtGZZQJgCfZC2i
fmABlAc9Inyj7butpDAfO6U=
=J6zj
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
