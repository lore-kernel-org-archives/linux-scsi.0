From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patches for SCSI scanning
Date: Wed, 21 Apr 2004 15:52:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421135247.GR28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420092650.A7749@beaverton.ibm.com> <20040420164238.GT4356@tpkurt.garloff.de> <20040420104408.B8602@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WjWU9mUuKzTKEtBb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:20632 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262584AbUDUNyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 09:54:25 -0400
Content-Disposition: inline
In-Reply-To: <20040420104408.B8602@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>


--WjWU9mUuKzTKEtBb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2004 at 10:44:08AM -0700, Patrick Mansfield wrote:
> Again that is not compatible with the current 2.6.x code, users with
> non-black listed single lun devices will get failures if we default to
> max_scsi_luns > 1.

Failure is good sometimes.=20
They can work around with default_dev_flags=3D1 or better with=20
dev_flags=3DVendor:Model:1 or in the worst case with max_luns=3D1.

I suggest to not accept any more FORCELUN entries for now and
remove them all in 2.7.

I still think expecting multi lun devices to work with max_luns=3D1
(aka CONFIG_SCSI_MUiLTI_LUN=3Dn) is just a configuration error.
I don't like fixing sysadmins' mistakes by adding blacklist entries.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--WjWU9mUuKzTKEtBb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhnyuxmLh6hyYd04RAqYbAJsGpYqjtetaWl55SVV5gkSbw8AUmACgyiYi
QPm10Eo+fjikqoVpTsBs2ho=
=Kf3K
-----END PGP SIGNATURE-----

--WjWU9mUuKzTKEtBb--
