From: Kurt Garloff <garloff@suse.de>
Subject: Re: Pb with external RAID controller in lk 2.4
Date: Fri, 24 May 2002 19:55:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020524195516.A5850@gum01m.etpnet.phys.tue.nl>
References: <3CEA83AE.1DCAB7BC@cri74.org> <3CEB4D6D.92C207EE@cri74.org> <20020522100339.A268@eng2.beaverton.ibm.com> <20020524191733.N28936@gum01m.etpnet.phys.tue.nl> <20020524104450.B22142@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020524104450.B22142@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org, Lorraine Suschetet <lorraine@ext.cri74.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

On Fri, May 24, 2002 at 10:44:50AM -0700, Patrick Mansfield wrote:
> On Fri, May 24, 2002 at 07:17:33PM +0200, Kurt Garloff wrote:
> > If you have a FC device (or whatever device that supports LUNs > 7) that
> > reports as SCSI-2, you can flag it with BLIST_LARGELUN in scsi_scan.c
> > to get it treated as SCSI-3.
> > (New in 2.4.18)
>=20
> I don't see that in 2.4.18, is it in a 2.4.19-pre? (I can't get to
> any kernel.org or a mirror right now.)

You're right. Sorry! When I submitted to Marcelo for 2.4.18 inclusion it was
too late already. But it was in Alans tree for some time and got merged by
Marcelo in 2.4.19pre, indeed.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE87n6DxmLh6hyYd04RAvCyAJ0fAIUPT0HzQIFG99Qf1+M3zF6NKACdFnhU
iIBnE2B9eHhGD0pQRR1i1sY=
=Of45
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
