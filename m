From: Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Fri, 19 Sep 2008 09:17:48 +0200
Message-ID: <20080919091748.9438726b.ospite@studenti.unina.it>
References: <Pine.LNX.4.44L0.0808271447260.17771-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.0809051533280.4482-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Sep_2008_09_17_48_+0200_hNqZWjTs8/A3uXkb"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0809051533280.4482-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Fri__19_Sep_2008_09_17_48_+0200_hNqZWjTs8/A3uXkb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 5 Sep 2008 15:35:13 -0400 (EDT)
Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:

> On Wed, 27 Aug 2008, Alan Stern wrote:
>=20
> > This patch (as1133) fixes a bug in the interaction between
> > scsi_end_request() and scsi_io_completion().  The bug was triggered by
> > recent changes to accomodate USB drives can't access their last few
> > sectors using multi-sector transfers (the so-called last_sector_bug
> > flag).
> >=20
> > The bug shows up when a multi-sector I/O request has been broken up
> > into single-sector commands.  If one of those commands gets an error,
> > the remainder of the request never gets completed.  This is because
> > the "bytes" value passed to scsi_end_request() is completely wrong; it
> > is the transfer size of the current command, not the total transfer
> > size of the request.
>=20
> There hasn't been any reply to this patch submission.  For reference,
> the original message is at
>=20
> 	http://marc.info/?l=3Dlinux-scsi&m=3D121986305201166&w=3D2
>=20
> Has it been accepted, rejected, or did it fall through the cracks?
>=20
> Alan Stern
>

Hi again,

anything new about this patch? Alan, I'll keep reminding about it from
time to time, until it is accepted or rejected.

Thanks,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Fri__19_Sep_2008_09_17_48_+0200_hNqZWjTs8/A3uXkb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjTUhwACgkQ5xr2akVTsAEfdQCeKG4cqMMz37pJrWj1cTqzWNiE
1l4AnA9B5Lpudd9TeGeMolCj/I/BaXJr
=+syN
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Sep_2008_09_17_48_+0200_hNqZWjTs8/A3uXkb--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
