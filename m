From: Andre Noll <maan@systemlinux.org>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Thu, 28 Feb 2008 10:46:20 +0100
Message-ID: <20080228094620.GD29468@skl-net.de>
References: <20080226174314.GA30767@skl-net.de> <47C45B80.6090907@redhat.com> <20080227101143.GC30767@skl-net.de> <47C5C048.9080704@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:59565 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbYB1Jst (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2008 04:48:49 -0500
Content-Disposition: inline
In-Reply-To: <47C5C048.9080704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Snook <csnook@redhat.com>
Cc: adam radford <aradford@gmail.com>, Tony Battersby <tonyb@cybernetics.com>, Johannes =?iso-8859-1?Q?W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:55, Chris Snook wrote:

> Does the machine become unresponsive during the single-threaded test, or=
=20
> only when doing the rsync?

It takes noticably longer to ssh into the machine also in the
single-threaded case (using dd to write to the device), but the
system remains usable. When the rsync job is running, it becomes
unusable quickly.

However, reducing the queue depth with

	echo 16 > /sys/block/sda/device/queue_depth

as suggested by Adam, solves all problems.

Thanks all for your help.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHxoLsWto1QDEAkw8RAoAHAJ0TFMt26ioLR/WskxAUW5Td+OqmRQCeNcH3
EDQQFgyymODIGTVteQrHULA=
=nnxa
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
