From: Kurt Garloff <garloff@suse.de>
Subject: Re: bus:id:lun to device name
Date: Tue, 8 Jul 2003 16:50:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708145007.GQ2601@nbkurt.garloff.de>
References: <1057159447.825.68.camel@lt-sv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yFH6hwN92mUA4HK5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([213.95.15.193]:9997 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267368AbTGHOgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2003 10:36:41 -0400
Content-Disposition: inline
In-Reply-To: <1057159447.825.68.camel@lt-sv>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Cc: linux-scsi@vger.kernel.org


--yFH6hwN92mUA4HK5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Wed, Jul 02, 2003 at 05:24:08PM +0200, Stefan Voelkel wrote:
> I want to convert a bus:id:lun triple to something like "/dev/sda".
>=20
> From userspace I can ioctl() /dev/s[d|cd|...]* or parse /proc/scsi/scsi.

Plain /proc/scsi/scsi does not help you.
You may want to have a lok at the scsi-many patches that export this
information via /proc/scsi/scsi though.
http://www.suse.de/~garloff/linux/scsi-many/

Host: scsi3 Channel: 00 Id: 10 Lun: 00
  Vendor: IBM      Model: DDYS-T18350N     Rev: S84D
  Type:   Direct-Access                    ANSI SCSI revision: 03
  Attached drivers: sde(b:08:40) sg5(c:15:05)

> I do not like any of those solutions.

For non-removable harddisks, the ioctl() just works fine, BTW.
I see no reason to dislike it.

Another option is to use scsidev
http://www.garloff.de/kurt/linux/scsidev/
where the device nodes are dynamically created and (by default) have=20
names which contain this information.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--yFH6hwN92mUA4HK5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2-rc1-SuSE (GNU/Linux)

iD8DBQE/CtofxmLh6hyYd04RAsWoAJ9jg9KxcWk3jpJJ3sQcN2jx4v6BigCfWDPO
6BBAbsU2h6xlwaR5O7TMmCY=
=Q16i
-----END PGP SIGNATURE-----

--yFH6hwN92mUA4HK5--
