From: Kurt Garloff <kurt@garloff.de>
Subject: Re: SCSI-ID persistence query...
Date: Wed, 19 May 2004 22:20:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040519202045.GA367@tpkurt.garloff.de>
References: <20040513110021.36867.qmail@web51006.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41864 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264656AbUESWZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 18:25:57 -0400
Content-Disposition: inline
In-Reply-To: <20040513110021.36867.qmail@web51006.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Shobhit Mathur <shobhitmmathur@yahoo.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 13, 2004 at 04:00:21AM -0700, Shobhit Mathur wrote:
> Hello,
>=20
> I have a few basic questions pertaining to SCSI-id
> numbering & persistence :
>=20
> * How do SCSI targets/LUNs get numbered ? My view is
>   that the OS numbers them as it receives cmd-response.
> * If the above observation is correct, a disk with a
>   particular id during one boot, will not have the same
>   id during the next boot, which can have other=20
>   consequences...
>=20
>   My question is: How is SCSI numbering done and how is
>   it persistent across boots ?

It's not persistent by default.
The SCSI devices are just enumerated in the order of detection.

If you look for more persistent device name for 2.4 and 2.6, have a=20
look at scsidev.

For 2.6, another option is to have your hotplug scripts call udev=20
call scsi_id.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAq8GdxmLh6hyYd04RAo1SAJ0VBxggrfkexxt/9NlfD71jdoEvoACglN+f
5LFg1uAWwcj9o79fwfd23Qo=
=tnqj
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
