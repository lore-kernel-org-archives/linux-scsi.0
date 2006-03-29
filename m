From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH 2/3] Better log messages for PQ3 devs
Date: Thu, 30 Mar 2006 00:12:48 +0200
Message-ID: <20060329221248.GK7919@tpkurt.suse.de>
References: <20060329201020.GG7919@tpkurt.suse.de> <20060329201247.GI7919@tpkurt.suse.de> <20060329203009.GC13590@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+eiC+3eBSP0wAgz0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33153 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751028AbWC2WMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 17:12:22 -0500
Content-Disposition: inline
In-Reply-To: <20060329203009.GC13590@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>


--+eiC+3eBSP0wAgz0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

On Wed, Mar 29, 2006 at 01:30:09PM -0700, Matthew Wilcox wrote:
> On Wed, Mar 29, 2006 at 10:12:47PM +0200, Kurt Garloff wrote:
> >  		 */
> > -		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
> > -					"scsi scan: peripheral qualifier of 3,"
> > -					" no device added\n"));
> > +		SCSI_LOG_SCAN_BUS(2, printk(KERN_INFO "scsi scan: periph.qual. of 3,"
> > +				" device %s not added\n",
> > +				sdev->sdev_gendev.bus_id));
>=20
> You seem to be suffering from long-line-itis, probably as a result of
> too much exposure to ia64 code.  How about:a

Indeed, my terminals are all more than 80 chars wide these days :-)
If that's the only concern, I'm happy to address it.

Thx,
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--+eiC+3eBSP0wAgz0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEKwZgxmLh6hyYd04RAjzqAKCVIRWdb7rMXHUVESM0VUh0nUnP8QCeJtyy
kdk3Pu8dAvqcdWO3rW4Fc/E=
=Om4o
-----END PGP SIGNATURE-----

--+eiC+3eBSP0wAgz0--
