From: AJ Lewis <alewis@redhat.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take 2
Date: Thu, 9 Sep 2004 10:40:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040909154054.GE11300@null.msp.redhat.com>
References: <20040907210520.0251476C56@isis.visi.com> <413E6F8F.3020008@torque.net> <20040908073843.7dbcddb6.rddunlap@osdl.org> <413FA664.6050009@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:64989 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265977AbUIIPnA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2004 11:43:00 -0400
Content-Disposition: inline
In-Reply-To: <413FA664.6050009@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, sferris@acm.org, James.Bottomley@SteelEye.com, mikenc@us.ibm.com, michaelc@cs.wisc.edu, willy@debian.org, hch@lst.de, surekhap@cisco.com, linux-scsi@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 09, 2004 at 10:40:04AM +1000, Douglas Gilbert wrote:
> Probably the best place to start is the diagram at
> http://www.t10.org under the "Architecture" tab near the
> top of the left hand pane. The focus of that diagram is
> the Architectural Model (SAM) of which
> http://www.t10.org/ftp/t10/drafts/sam3/sam3r13.pdf
> is the latest available draft. The transports are
> along the bottom of that diagram and the command sets
> are along the top.

Just FYI in case you haven't seen it, there's an updated draft at:
http://www.t10.org/ftp/t10/drafts/sam3/sam3r13a.pdf=20
though I can't find the revision history in it anywhere, so I don't know how
it differs from sam3r13...

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


--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBQHmG9QxUqFeMhxURAgUzAJ4tJlbvwobkj6Y+KRCH7IKG4a8rWgCfd4Qq
fUHsXMBO1dtkmDB7t7nv94w=
=l7bX
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
