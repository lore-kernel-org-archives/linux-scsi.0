From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] sd_many done right (3/5)
Date: Mon, 29 Jul 2002 09:52:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <37560.1327200004$1027929275@news.gmane.org>
References: <OFF035F90D.9958CFF6-ONC1256C05.0027A0C5@de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OFF035F90D.9958CFF6-ONC1256C05.0027A0C5@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@suse.de>, devices@lanana.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Aron,

On Mon, Jul 29, 2002 at 09:22:40AM +0200, Aron Zeh wrote:
> one little thing:
> In the third "if" statement in scsiname_to_kdev_t you search for "scd" but
> set tp to "sr".
> That should also be "scd" I'd guess.

No, it's intended. Internally, I use the name 'sr' for a SCSI CDrom as
that's the name the driver advertises. Some strange distributions out there
seem to prefer the name 'scd' for unknown reasons[*], that's why I map scd =
to
sr in order not to confuse users.

[*] The file name of the driver is sr.c, the module is name sr_mod, it fills
in  the tag 'sr' as driver name (which is reported in /proc/devices).
But for some reason somebody thinks that 'scd' would be more user friendly.
It may seem more intuitive at first sight, but it makes things completely
inconsistent. Unless, of course, we rename everything to 'scd' to make it
consistent again.
It nowadays is even reported as 'scd' (and 'sr' deprecated) in devices.txt,
sigh!=20
Somebody should take an authorative decision and do the renames if necessar=
y!
Or make sure devices.txt is fixed. Jens?

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9RPQuxmLh6hyYd04RAsNGAJ4mFguek7nj+Mb/34bpL+4xEh1rUgCfVPbh
Cy50oJSmSFWL7Sz4TIGxLhc=
=pNf7
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
