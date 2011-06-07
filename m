From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] isci: towards the v3.0 merge candidate
Date: Tue, 7 Jun 2011 15:20:54 +1000
Message-ID: <20110607152054.910ae0df.sfr@canb.auug.org.au>
References: <1307408765.11482.40.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Jun_2011_15_20_54_+1000_KlsqJnM_IYnxj/_1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:48604 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab1FGFVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2011 01:21:06 -0400
In-Reply-To: <1307408765.11482.40.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Jeff Garzik <jeff@garzik.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, David Milburn <dmilburn@redhat.com>, hare@suse.de

--Signature=_Tue__7_Jun_2011_15_20_54_+1000_KlsqJnM_IYnxj/_1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Jun 2011 18:06:05 -0700 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> [ copying sfr to get his opinion on having exposure of this tree in
> -next for a few weeks before  it hits James' tree.  isci.git#master
> never rebases so I don't expect conflicts once scsi-misc.git starts
> carrying the same ]

I am happy with that idea as long as James thinks it is a good one.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Jun_2011_15_20_54_+1000_KlsqJnM_IYnxj/_1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7bU2AAoJEDMEi1NhKgbsxW0H/Rajmyq9NmnkWOcw3naOHPGU
J1rjTfjzcL1LA+I1h5pGoWb0mMVYM06UdA43q7zcNBDoNvJ9NH8tr7vaEeuoyISX
Y6417OAkGknvuldyrOVKzYX2oZ2I6SDoB5CuvNLAIecZ1MFd3bfrp8UMzoBeWw4B
yepKO+SX1YLbdsE8Y9HQcTZ+yYk2oBt2jzG+920lq2v78xSyJrF+LvJz0WYtaljZ
5lOuVr3CyjFEKMR3viXodXqAo0NV6xRe8GYXlvZSAwukLEMgEa8D+I7d08ixq2EY
kUEdj1Ix+G4F/iuMCr8xxdzueRa75PX9b1lx8HFrj/1SuhcN1sFCdAvb8HKmRr8=
=KalI
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jun_2011_15_20_54_+1000_KlsqJnM_IYnxj/_1--
