From: Kurt Garloff <garloff@suse.de>
Subject: Re: [Patch] dont block device on QUEUE_FULL for last command
Date: Mon, 11 Aug 2003 10:45:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811084517.GP2543@nbkurt.garloff.de>
References: <OF122C5E1B.D9D616EB-ONC1256D78.0050C1BC@de.ibm.com> <20030804154844.GB26775@gtf.org> <20030805060745.GU854@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XG0jWBK27HhJN4nS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([213.95.15.193]:21002 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S272381AbTHKIpT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 04:45:19 -0400
Received: from Hermes.suse.de (Hermes.suse.de [213.95.15.136])
	by Cantor.suse.de (Postfix) with ESMTP id C26FA145F0
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2003 10:45:18 +0200 (MEST)
Content-Disposition: inline
In-Reply-To: <20030805060745.GU854@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--XG0jWBK27HhJN4nS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2003 at 08:07:45AM +0200, Jens Axboe wrote:
> On Mon, Aug 04 2003, Jeff Garzik wrote:
> > For most cases you _should_ block until another command is completed, at
> > the very least.  Retrying the command immediately is _exactly_ the
> > situation one wishes to avoid, when returning a QUEUE_FULL result!
>=20
> Depends very much on who you ask :-)

If there's no more commands, you would wait forever.
The patch is correct and needed IMVHO.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--XG0jWBK27HhJN4nS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/N1edxmLh6hyYd04RAoyUAKCT+NVeGy/vnWYS8Wt+2tLmzqxezwCfbMpJ
PKg1un+t0Nw9jOOpgGr98uo=
=mZUs
-----END PGP SIGNATURE-----

--XG0jWBK27HhJN4nS--
