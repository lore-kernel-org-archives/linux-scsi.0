From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 21:12:08 +0100
Message-ID: <201701102112.08656@pali>
References: <Pine.LNX.4.44L0.1701101457390.2462-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12911033.iJUCitiJ0o";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1701101457390.2462-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dainius =?utf-8?q?Masili=C5=ABnas?= <pastas4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--nextPart12911033.iJUCitiJ0o
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 10 January 2017 21:02:09 Alan Stern wrote:
> Quick summary: READ CAPACITY(10) does not include physical sector
> size information whereas READ CAPACITY(16) does.  But the kernel
> uses READ CAPACITY(10) by default for USB drives, because quite a
> few of them die when given a READ CAPACITY(16) command.

Ah :-( Are there lot of "broken" devices for creating blacklist?

> If you can suggest a way to fix this, we'll be glad to hear it.

Tom Yan wrote that smartctl/hdparm "works" because they use the SCSI ATA=20
PASSTHROUGH command. It is not an option for kernel?

=2D-=20
Pali Roh=C3=A1r
pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

--nextPart12911033.iJUCitiJ0o
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlh1QBgACgkQi/DJPQPkQ1LLsQCgyKWaP5dAh8tcA6lavPdMb24g
3CQAoI3KVYojQqin/apnY2uaUzcWT/Ks
=BqmP
-----END PGP SIGNATURE-----

--nextPart12911033.iJUCitiJ0o--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
