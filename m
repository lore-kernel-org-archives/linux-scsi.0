From: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [Bug 11589] New: Mass-storage USB Device does not show up when CONFIG_SCSI_MULTI_LUN is set
Date: Thu, 18 Sep 2008 19:40:54 -0700
Message-ID: <20080919024054.GA5878@one-eyed-alien.net>
References: <bug-11589-11613@http.bugzilla.kernel.org/> <20080918191231.f714eb04.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080918191231.f714eb04.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, nico-riGpqtv0zD4+dr1hVOte4A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2008 at 07:12:31PM -0700, Andrew Morton wrote:
> On Thu, 18 Sep 2008 18:22:23 -0700 (PDT) bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org=
 wrote:
>=20
> > When CONFIG_SCSI_MULTI_LUN is set, the memory card does not show up as =
it
> > should, I only see /dev/sdd but not /dev/sdd1 - it's unable to mount it=
 that
> > way.
> > When CONFIG_SCSI_MULTI_LUN is not set, it does show up as /dev/sdd1 but=
 gives
> > me loads of warnings like "attempt to access beyond end of device", see=
 dmesg
> > for that. This way it is mountable and works fine except the warnings.

If /dev/sdd shows up but not /dev/sdd1, then this is probably actually the
partition parsing code.  There was a change to reject badly formed
partitions; I believe someone is trying to revert that change.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Pitr!  That's brilliant!  Funded by Microsoft refunds.  What sweet irony!
					-- A.J.
User Friendly, 2/15/1999

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFI0xE2HL9iwnUZqnkRAuiUAKCqb98JrqPxb5BWrKi/Qg1hj1ZdBACdEA8f
ubkXK8GKIicQ3FAb2uJRrpo=
=84mV
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
