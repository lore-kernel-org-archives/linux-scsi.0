From: Kurt Garloff <garloff@suse.de>
Subject: Re: TMSCSIM [2.6]
Date: Mon, 24 Nov 2003 00:29:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031123232916.GH24247@tpkurt.garloff.de>
References: <Pine.LNX.4.44.0311230024300.1354-100000@poirot.grange> <m365haomqt.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jHkwA2TBA/ec6v+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:8910 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263528AbTKWXaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 18:30:16 -0500
Content-Disposition: inline
In-Reply-To: <m365haomqt.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org


--9jHkwA2TBA/ec6v+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthias,

On Sun, Nov 23, 2003 at 09:26:02PM +0100, Matthias Andree wrote:
> Out if interest: Why "try_sync_nego =3D 0"?

It's just the default for this variable.
It's later set to 1 if we're issueing an INQUIRY or if we're talking to
LUN0, the target did report to support SyncTransfers and the Sync=20
Negotiation has not beend done yet and we're issueing a REQUEST_SENSE.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--9jHkwA2TBA/ec6v+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/wULLxmLh6hyYd04RAiN6AJ9cpwvs/0o/BybBDqpmagRUdVLwBwCgtQy6
dP92ASEtBgPQm45h1ciWpdw=
=vLDl
-----END PGP SIGNATURE-----

--9jHkwA2TBA/ec6v+--
