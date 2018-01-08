From: Yves-Alexis Perez <corsac@debian.org>
Subject: Re: [PATCHv2] libsas: Check for completed commands before calling
 lldd_abort_task()
Date: Mon, 08 Jan 2018 18:11:36 +0100
Message-ID: <1515431496.3305.62.camel@debian.org>
References: <1515413086-34256-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Lc+lTMxm5g+4J9Q4U22S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:54786
        "EHLO mail.corsac.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbeAHRLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 12:11:43 -0500
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e21::1])
        by mail.corsac.net (Postfix) with ESMTPS id 210FD8F
        for <linux-scsi@vger.kernel.org>; Mon,  8 Jan 2018 18:11:42 +0100 (CET)
In-Reply-To: <1515413086-34256-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


--=-Lc+lTMxm5g+4J9Q4U22S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-08 at 13:04 +0100, Hannes Reinecke wrote:
> The abort handler might be racing with command completion, so the
> task might already be NULL by the time the abort handler is called.

Hi,

I tried the patch on top of 4.15-rc7 (and without the revert of 90965761). =
I
don't have the NULL pointer deref anymore, but the box timeouts after SCSI
init. It's not completely dead, but I don't have any meaningful log from th=
e
kernel.

Regards,
--=20
Yves-Alexis
--=-Lc+lTMxm5g+4J9Q4U22S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8vi34Qgfo83x35gF3rYcyPpXRFsFAlpTpkgACgkQ3rYcyPpX
RFsBUwf/ZrQAKLj0p9jbIR+JtOdhDR3UaPazKPmP8Fn9nDfaDuUhvwB8u4pewrRT
ZYx7y+hiOrPGH6FiunsHiEMW1YIuJ67W8MAjY+7mAK7IXA9aSpVwKMCc3/Pdl0E6
z0Zar5sCzsXkn0RmY6ul1FUH6PCMOLEGlCWqAKzCvLs7P2kV86AWo+oaioa9U+qV
2eL2y3iMJDOm7t+XnsCIAc4zL7UxpPHnEtKMMARl+LQmySoBPmpdftx9wCJe/TVZ
K/xwqHkhP81zPFITospciv7HYAfJNgv8fRI+/D1EfpFPibgsdOrzJiR0EWbXhC8T
41vtzD9B1cIoxMY/u5BM2P0vrDbo1A==
=RfVH
-----END PGP SIGNATURE-----

--=-Lc+lTMxm5g+4J9Q4U22S--
