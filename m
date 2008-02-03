From: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Sun, 3 Feb 2008 13:09:54 -0800
Message-ID: <20080203210954.GA14573@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0802031025180.12447-100000@netrider.rowland.org> <47A5EBC0.3060401@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <47A5EBC0.3060401-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

One more comment on the patch...

On Sun, Feb 03, 2008 at 06:28:48PM +0200, Boaz Harrosh wrote:
> +	/* Check for overflow */
> +	if (buflen > scsi_bufflen(srb)) {

This really should have an unlikely() around it.  This is an often-executed
code path, and we want to optimize it as much as possible.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Type "format c:"  That should fix everything.
					-- Greg
User Friendly, 12/18/1997

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHpi2iHL9iwnUZqnkRAqzZAJ9TIjZUp43Ew0xMRvnJg4jfV0VS2wCgtZxr
+Jt4DcqJAttxkOPM5pslkFw=
=LNYT
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
