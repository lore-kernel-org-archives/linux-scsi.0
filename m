From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: [PATCH] add two SCSI command opcodes
Date: Thu, 19 Apr 2007 17:47:43 +0200
Message-ID: <20070419154743.GA18325@lug-owl.de>
References: <20070419151053.GA10199@localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1766760AbXDSPrp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070419151053.GA10199@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-19 18:10:54 +0300, Dan Aloni <da-x@monatomic.org> wrote:
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5c0e979..dff842a 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -103,6 +103,7 @@ extern const unsigned char scsi_command_size[8];
>  #define READ_12               0xa8
>  #define WRITE_12              0xaa
>  #define WRITE_VERIFY_12       0xae
> +#define VERIFY_12             0xaf
>  #define SEARCH_HIGH_12        0xb0
>  #define SEARCH_EQUAL_12       0xb1
>  #define SEARCH_LOW_12         0xb2
> @@ -111,6 +112,7 @@ extern const unsigned char scsi_command_size[8];
>  #define WRITE_LONG_2          0xea
>  #define READ_16               0x88
>  #define WRITE_16              0x8a
> +#define WRITE_VERIFY_16       0x8e
>  #define VERIFY_16	      0x8f
>  #define SERVICE_ACTION_IN     0x9e
>  /* values for service action in */

Where's the user?

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
  Signature of:                          Zensur im Internet? Nein danke!
  the second  :

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJ48fHb1edYOZ4bsRAru2AJ0WB/UbLueFiJcRZAET/XrpYFt7yACdGyAx
hKrW2X2BOfbJvvX6cmb/YHc=
=IV2Q
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
