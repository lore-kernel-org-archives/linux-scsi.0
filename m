From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH][SQUASHME] osdblk is dependent on SCSI_OSD_ULD
Date: Wed, 17 Jun 2009 23:49:19 +1000
Message-ID: <20090617234919.dd6e5983.sfr@canb.auug.org.au>
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
	<4A37CC79.5000907@oracle.com>
	<4A38E55E.7050006@panasas.com>
	<20090617231250.4aefe5e8.sfr@canb.auug.org.au>
	<4A38F15C.5050204@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_23_49_19_+1000_+6aQ7i/TNBnA+MS/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:47783 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbZFQNtX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 09:49:23 -0400
In-Reply-To: <4A38F15C.5050204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

--Signature=_Wed__17_Jun_2009_23_49_19_+1000_+6aQ7i/TNBnA+MS/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

On Wed, 17 Jun 2009 16:36:28 +0300 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> Stephen Rothwell wrote:
> When
> CONFIG_BLK_DEV_OSD=3Dy
> CONFIG_SCSI_OSD_INITIATOR=3Dy
> \# CONFIG_SCSI_OSD_ULD is not set

Actually it was Randy Dunlap.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_23_49_19_+1000_+6aQ7i/TNBnA+MS/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko49F8ACgkQjjKRsyhoI8yU/wCfaV0LpwpZKTraLrgXmBm8CPWO
o1QAn02zYblA05SsQfAE24HmmmAYyoi5
=zoTO
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_23_49_19_+1000_+6aQ7i/TNBnA+MS/--
