From: Kurt Garloff <garloff@suse.de>
Subject: Re: SCSI reserve/release
Date: Thu, 27 Feb 2003 23:53:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030227225334.GB14200@nbkurt>
References: <20030227205135.31139.qmail@web14612.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030227205135.31139.qmail@web14612.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Linda Lee <lindaclee2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linda,

On Thu, Feb 27, 2003 at 12:51:35PM -0800, Linda Lee wrote:
> I'd like to simulate the SCSI-3 Persistent Group
> Reservation of Solaris on Linux using Linux
> reserve/release mechanism.  My understanding is that
> to make reservation on the device on Linux, I can
> issue ioctl() with SCSI_IOCTL_SEND_COMMAND along with
> SCSI command "RESERVE" as part of the input data. It
> is similar for the release mechanism.  Instead of
> "RESERVE" command in the ioctl, put "RELEASE" instead.
>=20
> Regarding the SCSI reset, I can issue ioctl() with
> SG_SCSI_RESET.
>=20
> Is my approach correct?  Does anyone had done this
> before?

You can do this. But note that you will lose the reservation
on a reset of the SCSI bus which can occur due to error handling
of your box (or another one). As long as the kernel does not
keep track of reservation states (or you invent some notification
mechanism for SCSI resets to user space), you can't handle this
reliably.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2-rc1-SuSE (GNU/Linux)

iD8DBQE+XpbuxmLh6hyYd04RAnXYAJsFlahV6rM8X6/6KY9rzAYL2tag9wCfeNDm
VlGZ4mXTxfh8lSwSfhGNp8o=
=JO/V
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
