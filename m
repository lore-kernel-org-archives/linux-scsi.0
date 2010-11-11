From: Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 10:49:46 -0800
Message-ID: <20101111184946.GC20296@one-eyed-alien.net>
References: <20101111174322.GB20296@one-eyed-alien.net> <673670.8195.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <673670.8195.qm-n6NU40r8ZaqvuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 11, 2010 at 10:27:11AM -0800, Luben Tuikov wrote:
> The patch uses SCSI functions to abstract the sense information irrespect=
ive of the type of format of sense data.

Looks reasonable.  The underlying SCSI functions seem to all have the tests
to distinguish between sense format types.  Let's just hope there are no
devices out there which can confuse those tests, or we'll be buried in
regressions.

ACKed-by: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

My mother not mind to die for stoppink Windows NT!  She is rememberink=20
Stalin!
					-- Pitr
User Friendly, 9/6/1998

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFM3DrK3gL8qCooyc4RAky0AJ9lH9VGKO2/jkDqQKrcloV5a4TJWgCeILba
VjOrIrVK99RYWvEj1e5qzhY=
=PSWE
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
