From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Notify about errors during initialization
Date: Sun, 4 Jan 2004 18:10:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105021047.GD30408@one-eyed-alien.net>
References: <20031207051634.GB21951@one-eyed-alien.net> <Pine.LNX.4.44L0.0312081101480.1043-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:18315 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265847AbUAECKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2004 21:10:50 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0312081101480.1043-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Did you ever get an answer from the linux-scsi people on this?

Matt

On Mon, Dec 08, 2003 at 11:15:06AM -0500, Alan Stern wrote:
> Cross-posted to the linux-scsi list in the hope that someone there can=20
> confirm this answer...
>=20
> On Sat, 6 Dec 2003, Matthew Dharm wrote:
>=20
> > Question: Are we guaranteed that scsi_scan_host() doesn't return until =
the
> > scanning process is complete?
>=20
> I'm not absolutely certain -- best to check with someone on the linux-scsi
> list.  But a quick look through the call chain in scsi_scan.c indicates
> that scsi_scan_host() doesn't return until the scanning process is indeed
> complete.  The real work is done in scsi_probe_lun() (called from
> scsi_probe_and_add_lun()), and that uses scsi_wait_req().  After all, it
> can't tell whether the LUN is there or not until it gets a reply to the
> INQUIRY!
>=20
> > I recall a problem that we had with the setting of flags and the call to
> > scan the host -- without pre-emption, it worked, but with pre-emption
> > things happened in the wrong order.  Could that happen here?
>=20
> I don't remember that problem.  But I don't think pre-emption would cause=
=20
> any difficulties here.  All the flags should be set before we call=20
> scsi_scan_host().  If you can provide more details or a reference to what=
=20
> you're thinking of, I could reply in more detail.
>=20
> When pre-emption does cause a problem it's generally because of some
> assumption that the current task won't be scheduled out when it calls up()
> or complete() or something like that.
>=20
> Alan Stern
>=20
>=20
>=20
>=20
>=20
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm just trying to think of a way to say "up yours" without getting fired.
					-- Stef
User Friendly, 10/8/1998

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/+MenIjReC7bSPZARAhBaAKCCtymTYwL17eWjAQEmFcayZDfRlACfSWKk
NudlILMhe3T2hIiAh4sG+0s=
=O1rC
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
