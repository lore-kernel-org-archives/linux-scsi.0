From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 17:47:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014154719.GE21010@nbkurt.casa-etp.nl>
References: <20021014054035.GA10686@codepoet.org> <20021014000602.F30278@one-eyed-alien.net> <20021014071252.GB13512@codepoet.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014071252.GB13512@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Erik Andersen <andersen@codepoet.org>, USB Storage List <usb-storage@one-eyed-alien.net>


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Erik,

On Mon, Oct 14, 2002 at 01:12:52AM -0600, Erik Andersen wrote:
> I've not tried it with 2.5.x, but in 2.4.x things are 100%
> perfectly stable for me and for the several people that I've had
> testing it.  If this were included in the kernel, I would not
> expect any maintainence to be necessary, since this patch is
> mostly just taking existing scsi code and moving it into
> standalone functions.

The split-up in smaller functions should have been done anyway.
Exposing the functions for useful purpose even more so.

There are some scary comments around the scsi add/remove-single-device
code which imply that this stuff only works by accident.=20
I have used this functionality heavily for some time now and have never=20
had a problem. Same for people I talked to.
But it would  probably make sense to review the code for possible
problems.

But I'm all for integrating your patch. It does not introduce new
problems. And if it exposes old ones, because the code is more
heavily used, this can only be good.

Can you create a 2.5 version?

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9qucGxmLh6hyYd04RAu6kAKC1MLLw4i4n/AdFJkKZuVD/TQN4gQCfVHn9
S9+TvWL4+c8+lVQMwlaoIk0=
=GdvX
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
