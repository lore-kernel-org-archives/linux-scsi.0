From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Tue, 18 Nov 2003 00:28:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117232829.GR30120@tpkurt.garloff.de>
References: <20031117134140.169587af.rddunlap@osdl.org> <Pine.LNX.4.44.0311172331410.2258-100000@poirot.grange> <20031117151431.76083f58.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GcSOTaE82DYSpZPK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:52619 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262118AbTKQX2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 18:28:31 -0500
Content-Disposition: inline
In-Reply-To: <20031117151431.76083f58.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, hch@infradead.org, linux-scsi@vger.kernel.org, gl@dsa-ac.de


--GcSOTaE82DYSpZPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2003 at 03:14:31PM -0800, Randy.Dunlap wrote:
> | DC390: We were just reset and don't accept commands yet!
> | DC390: Insert pSRB c14ec2ec cmd 0 to Waiting
> | DC390: Debug: Waiting queue woken up by timer!
>=20
> Does this say that the IO timed out (timer expired)?
> I.e., the IO isn't happening?

No. If you try to send down commands after a reset, the controller
will queue them for a second before actually trying to send them.
That's controlled by a timer.
(Well, with new queuing we could just refuse I guess.)

> | DC390: INQUIRY: result: 00000000
> | DC390: Remove SRB c14ec2ec from Going
> | DC390: Free SRB c14ec2ec
> | scsi_delete_timer: scmd: c14c8ea8, rtn: 1
> |   Vendor:           Model:                   Rev:
> |   Type:   Direct-Access                      ANSI SCSI revision: 00
> |=20
> | Whereas the 2.4 version fills in correct data for the drive. Any ideas
> | would be appreciated.

Hmm, the INQUIRY did not yield any data :-(
pci_unmap() or at least pci_sync happened at that moment already?=20

All the debug stuff looks completely sane ...

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--GcSOTaE82DYSpZPK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/uVmcxmLh6hyYd04RAu4RAJ9ZHhtLfRcNMny+DVEbjis73zcapACfQRiX
I21lzEozGWe0UiFJcbckqOU=
=3DBT
-----END PGP SIGNATURE-----

--GcSOTaE82DYSpZPK--
