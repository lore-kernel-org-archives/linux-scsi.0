From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 01:12:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014071252.GB13512@codepoet.org>
References: <20021014054035.GA10686@codepoet.org> <20021014000602.F30278@one-eyed-alien.net>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014000602.F30278@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, USB Storage List <usb-storage@one-eyed-alien.net>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Oct 14, 2002 at 12:06:02AM -0700, Matthew Dharm wrote:
> Well... dang.  I've been hoping this would appear for quite some time.  I=
'm
> just not good enough with the SCSI layer to really make this stable.
>=20
> How stable is this?  I'd love to see this in 2.5 before the Oct 31 feature
> freeze, so USB Mass Storage can use this.  Stability is my major concern =
--
> someone has to agree to work on this to make it stable to use, and work o=
ut
> any possible corner-cases and race conditions.
>=20
> But, heck.. this is 2.5 -- I say let's include it, use it, and then shake
> the bugs out.

I've not tried it with 2.5.x, but in 2.4.x things are 100%
perfectly stable for me and for the several people that I've had
testing it.  If this were included in the kernel, I would not
expect any maintainence to be necessary, since this patch is
mostly just taking existing scsi code and moving it into
standalone functions.

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qm5zX5tkPjDTkFcRAiFBAJ9h8+Lwd8srXPpKQ9TQYn2LHO7MZQCfTrup
/kDw4l6BvLqpNfGa28VBVOs=
=B6kx
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
