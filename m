From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 18:08:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113180837.H30194@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068766632.2851.142.camel@patrh9> <20031113162401.A29775@beaverton.ibm.com> <1068774856.2851.259.camel@patrh9>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:20231 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264487AbTKNCIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:08:46 -0500
Content-Disposition: inline
In-Reply-To: <1068774856.2851.259.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 06:54:16PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: patmans@us.ibm.com, stern@rowland.harvard.edu, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 06:54:16PM -0700, Pat LaVarre wrote:
> > From: Matthew Dharm ...
> > ... I think we're basically at a point where
> > the only problematic command is MODE_SENSE and
> > MODE_SENSE_10, so I say blacklisting them from
> > USB devices should be fine.
>=20
> Lost me sorry help?
>=20
> If we eat those commands, how then can write-protect work in Linux for
> that rare case of an actually compliant device with a write-protectab;e
> disk (like the device firmware I remember shipping myself 1994..2003)?

Presumeably, when the send a WRITE command to the device, it will refuse
with meaningful sense data.

> > > If we check after the open for a write failure
> > > to read only media, we cannot keep the same
> > > open semantics (return EROFS on open).
>=20
> Without mode sense, we will see the open for write pass thru, and we
> will have to teach the fs (ext3, fat, fat32, udf, ...) to recover
> gracefully from a late write error, yes?

This should already be in place.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We've made a business out of making money from annoying and stupid people.
I think you fall under that category.
					-- Chief
User Friendly, 7/11/1998

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tDklIjReC7bSPZARAhwBAJ9Hc6EJQZfd5N+fYG6aak4zO45BHwCdHfpm
AFBQHc0KwYO/5Zi3AOQ6o1U=
=77Z4
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
