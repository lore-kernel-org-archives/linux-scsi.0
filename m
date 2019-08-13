Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498CBC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 10:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EC15206C2
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 10:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfHMKMK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 06:12:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49681 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfHMKMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 06:12:10 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 188CB8071A; Tue, 13 Aug 2019 12:11:56 +0200 (CEST)
Date:   Tue, 13 Aug 2019 12:12:08 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Frank Steiner <fsteiner-mail1@bio.ifi.lmu.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Dan Murphy <dmurphy@ti.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v3 2/6] scsi: mvsas: rename LED_* enums to SGPIO_LED_*
Message-ID: <20190813101208.GB26337@amd>
References: <1565459703-30513-1-git-send-email-akinobu.mita@gmail.com>
 <1565459703-30513-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <1565459703-30513-3-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-08-11 02:54:59, Akinobu Mita wrote:
> The mvsas driver declares LED_* enums for enum sgpio_led_status. The
> LED_OFF and LED_ON enums cause redeclaration of enumerator with the
> LED subsystem's LED_OFF and LED_ON enums.
>=20
> This adds 'SGPIO_' prefix to these enums in mvsas driver.
>=20
> Cc: Frank Steiner <fsteiner-mail1@bio.ifi.lmu.de>
> Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1SjPgACgkQMOfwapXb+vJtfgCggrF36qSmvQY9Psijznov+tNz
g4AAoLNaTE8k8ljYCuI5fktfarBJ10VZ
=mIgq
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
