From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patches for SCSI scanning
Date: Tue, 20 Apr 2004 18:42:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420164238.GT4356@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420092650.A7749@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OiITrshLgfui8fEl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:49291 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263156AbUDTQmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 12:42:42 -0400
Content-Disposition: inline
In-Reply-To: <20040420092650.A7749@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--OiITrshLgfui8fEl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

On Tue, Apr 20, 2004 at 09:26:51AM -0700, Patrick Mansfield wrote:
> On Tue, Apr 20, 2004 at 09:38:00AM -0500, James Bottomley wrote:
> > Yes, sounds reasonable.  We can do it all with the boot flags now.
>=20
> max_scsi_luns should default to zero to avoid devices that should be black
> listed as single lun.

I strongly disagree.

The target should be to blacklist broken devices not working ones.=20

Devices that have multiple LUNs are not, devices that have only one but
report severals are.

With max_scsi_luns=3D1, we would need to "black"list every single multi lun
device. I very much dislike that idea.

Fortunately, distributors don't do this.

> So how can you remove those and maintain compatibilty? The removal should
> wait for 2.7.

Expecting your multi lun devices to work with max_scsi_luns=3D1 is just
wrong. max_scsi_luns should not default to 1.
Anyways, BLIST_SPARSELUN will have the side-effect of also working
around that misconfiguration.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--OiITrshLgfui8fEl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhVL+xmLh6hyYd04RAtF0AKCOSJSlFz6yY9/I6KQMpfS11sVwHQCgrXFl
l7qSJI4Ps0ZsYx/t5Vc7qJM=
=D29E
-----END PGP SIGNATURE-----

--OiITrshLgfui8fEl--
