From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: How to write a transparent SCSI bridge?
Date: Wed, 30 Jul 2003 12:50:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030730125016.D30339@one-eyed-alien.net>
References: <20030730121310.C30339@one-eyed-alien.net> <Pine.LNX.4.44L0.0307301522300.2990-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:12819 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S272227AbTG3TuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 15:50:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307301522300.2990-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Wed, Jul 30, 2003 at 03:31:16PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2003 at 03:31:16PM -0400, Alan Stern wrote:
> On Wed, 30 Jul 2003, Matthew Dharm wrote:
>=20
> > On Wed, Jul 30, 2003 at 10:38:38AM -0400, Alan Stern wrote:
> > > What I have in mind is something that would receive CDBs and data ove=
r a=20
> > > USB link and would forward them to a standard SCSI device (or more=20
> > > accurately, a host adapter driver), and relay the replies back.
> >=20
> > CDBs?  Just the command bytes, then?  Why not send more of the struct
> > scsi_cmd?
>=20
> I have in mind writing a USB Mass Storage gadget (i.e., slave device)
> driver.  The gadget only receives the CDB, not the entire scsi_cmnd.  Whe=
n=20
> acting as a transparent bridge, the gadget would somehow have to=20
> reconstitute a SCSI request and send it to the actual device driver.

If it's usb-storage compliant, and uses the bulk-only protocol, then it
gets the CBW, which includes transfer length and transfer direction flags.

If you're trying to do CB/I, you're stuck.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I say, what are all those naked people doing?
					-- Big client to Stef
User Friendly, 12/14/1997

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/KCF4IjReC7bSPZARAgeqAJ9DQBigvRxvOWRa2zpylNu4k+cuZQCgq7t0
C1mrNZo1Q2xrKlhpvNB4TFk=
=XSgS
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
