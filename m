From: Ryan Anderson <ryan@autoweb.net>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid
	PERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 16:41:41 -0500
Message-ID: <1101246101.26294.76.camel@ryan2.internal.autoweb.net>
References: <20041028005302.753a2d52.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i0EwhZOPerjNQh105hkh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.autoweb.net ([198.172.237.26]:35599 "EHLO mail.autoweb.net")
	by vger.kernel.org with ESMTP id S261367AbUKWVlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 16:41:55 -0500
In-Reply-To: <20041028005302.753a2d52.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org


--=-i0EwhZOPerjNQh105hkh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-10-28 at 00:53 -0700, Andrew Morton wrote:
> Subject: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/D=
i Container goes offline
>=20
>=20
> http://bugme.osdl.org/show_bug.cgi?id=3D3651
>=20
>            Summary: dell poweredge 4600 aacraid PERC 3/Di Container goes
>                     offline
>     Kernel Version: 2.6.10-rc1, 2.6.9, 2.6.8, 2.6.7, 2.6.6
>             Status: NEW
>           Severity: high
>              Owner: andmike@us.ibm.com
>          Submitter: oliver.polterauer@ewave.at
>                 CC: oliver.polterauer@ewave.at

Is there any update on this problem?
To reiterate my particular hardware involved that can trigger this
problem:

Dell 2650, Dual 2.4Ghz Xeon processors (hyperthreading no, though the
problem occured in 2.4.20 without hyperthreading disabled via "noht")

4 GB of ram
Only load is PostgreSQL related (i.e, network queries, plus twice daily
dumps of the database to a NFS store, and a rsync back to the server for
a second copy)

Under load, I repeatedly saw containers go offline.

Dell's recommended hardware diagnostics do not turn up anything (at
all!)

The harddrive are Fujitsu drives, so the Seagate Firmware issue should
not affect them.

I have since taken this server out of production.  Unfortunately, this
makes the error much harder to trigger (i.e, I have failed so far to
trigger it, even with multiple bonnie++ runs)

Suggestions, diagnostics, etc, would be greatly appreciated.


--=20

Ryan Anderson               =20
AutoWeb Communications, Inc.=20
email: ryan@autoweb.net=20

--=-i0EwhZOPerjNQh105hkh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBo66VvV/uNaz8d+gRAuVZAJ94N4zKkU1dn0/EEiKMJ8a1voTRmACfem3/
+fTO3WYOGxIxoFBkyZUkd50=
=LHOE
-----END PGP SIGNATURE-----

--=-i0EwhZOPerjNQh105hkh--
