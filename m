From: Arjan van de Ven <arjanv@redhat.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Wed, 10 Nov 2004 09:12:01 +0100
Message-ID: <1100074321.4084.8.camel@laptop.fenrus.org>
References: <91888D455306F94EBD4D168954A9457C37672A@nacos172.co.lsil.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vynPdiZvtnInQB8QlJGh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44433 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261569AbUKJIMZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 03:12:25 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C37672A@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Stephens, Larry" <larry.stephens@lsil.com>


--=-vynPdiZvtnInQB8QlJGh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-11-09 at 17:26 -0700, Moore, Eric Dean wrote:
> This sas device list is being used in the driver, and we do
> have actual users of it; and they are HP, DELL, SUN, and others.=20
> The CSMI IOCTLs are temporarily removed from the driver as you have=20
> rejected it even though I know of nobody else so far that has complained
> about this.

then let me jump in and say that I consider such an ioctl solution
disgusting as well.

> Ok - your suggestion is not going to work.  We only know whether IU is
> enabled or not through domain validation, which is done in the context
> of scsi_scan_host.  Our SCSI firmware only supports packetized at U320
> speeds, and the issue came about when some device with SPARSELUN set
> negotiated at Fast 80.  This implementions solves the issue reported=20
> by Redhat and their customers, and will be avaliable in RHEL3 Update 4. =20
> Its not clear to me why your wanting to break this?

It's "Red Hat" not "Redhat".

Also while it may be ok for a vendor to put a hack in, Christoph is
right in wanting a real solution for the kernel.org kernel. In addition
you are talking about 2.4 kernels (RHEL3) while this is about the 2.6
scsi mid layer; if the midlayer has some behavior that would cause this
to go wrong we have to fix/extend the mid layer; putting hacks in
drivers almost never is the right answer.


--=-vynPdiZvtnInQB8QlJGh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBkc1Qpv2rCoFn+CIRAoM3AJ0YcLW9QxB6LDHtLvjrZLzL753vfgCfRbPT
n6HQvVpNk+Tnj6ELe4bL6zw=
=p7A1
-----END PGP SIGNATURE-----

--=-vynPdiZvtnInQB8QlJGh--

