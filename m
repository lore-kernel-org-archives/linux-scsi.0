From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Tue, 30 Jul 2002 21:29:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020730212909.A1546@one-eyed-alien.net>
References: <UTC200207272248.g6RMm3h14110.aeb@smtp.cwi.nl> <20020727195503.C3121@one-eyed-alien.net> <3D437918.EFD1473A@torque.net> <20020729222451.A2243@one-eyed-alien.net> <3D46973C.6641E9B2@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D46973C.6641E9B2@torque.net>; from dougg@torque.net on Tue, Jul 30, 2002 at 09:40:12AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Andries.Brouwer@cwi.nl, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2002 at 09:40:12AM -0400, Douglas Gilbert wrote:
> Matthew Dharm wrote:
> >=20
> > Out of curiosity... which value does the sg interface pass through?  It
> > collects both the buffer length and the requested transfer length, if my
> > memory serves...
>=20
> Matt,
> The sg driver does not attempt to decode SCSI commands (and,
> for example, calculate allocation lengths) but simply passes
> them through. In the sg_io_hdr interface what the user gives
> as dxfer_len becomes the 4th argument to scsi_do_req() and
> hence becomes Scsi_Request::sr_bufflen in the mid and lower
> levels. The cumulative length of the elements in scatter gather=20
> list built by sg (or the single buffer) is greater than or
> equal to dxfer_len.

Hrm....

Are you saying then that the sum of the sg segments can be greater than the
requested length?

After some discussions with Linus and others, I was under the impression
that this was a no-no...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Department of Justice agent.  I have come to purify the flock.
					-- DOJ agent
User Friendly, 5/22/1998

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9R2eVIjReC7bSPZARAgLKAJ4/aEUDkiFvRjexZI7IHRHk3EEKSQCfXr6n
3Y2D+dSiQ6JQl4nrPrZHjm8=
=kZ3Y
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
