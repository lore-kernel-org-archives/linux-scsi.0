From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: MODULE_VERSION for scsi drivers
Date: Tue, 27 Apr 2004 09:59:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427145905.GB20421@lists.us.dell.com>
References: <20040427040923.GA9901@lists.us.dell.com> <32805.4.5.45.142.1083039354.squirrel@www.osdl.org> <20040427131050.GA17777@lists.us.dell.com> <20040427153145.A17739@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:59563 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S264166AbUD0PBR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 11:01:17 -0400
Content-Disposition: inline
In-Reply-To: <20040427153145.A17739@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 27, 2004 at 03:31:45PM +0100, Christoph Hellwig wrote:
> On Tue, Apr 27, 2004 at 08:10:50AM -0500, Matt Domsch wrote:
> > Per include/linux/module.h:
> >   Using this automatically adds a checksum of the .c files and the
> >   local headers to the end.  Use MODULE_VERSION("") if you want just
> >   this.  Macro includes room for this.
> >=20
> > So for modules which don't appear to have their own versioning, we use
> > the "" mechanism to simply generate the checksum for the file.  This
> > still allows tools (ala DKMS eventually) to note if something in the
> > module changed even if the version string didn't.
>=20
> That's totally braindead.  If you want to use a scheme like that talk
> rusty into generating this without needing to add anything to the driver.

Yeah, that thought crossed my mind at 4am too.  I just pinged Rusty,
and will see about doing such myself regardless.=20

Thanks,
Matt

--=20
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAjnU5Iavu95Lw/AkRAiFPAJ9qz5tEglrMhdcOn6NVPEmf9mtFXACeLZc1
mEwpGNASpDZ6fF9UCvhBQbU=
=LIFn
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
