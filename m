From: Yves-Alexis Perez <corsac@debian.org>
Subject: Oops: NULL pointer dereference - RIP:
 isci_task_abort_task+0x30/0x3e0 [isci]
Date: Fri, 05 Jan 2018 13:13:48 +0100
Message-ID: <1515154428.30693.43.camel@debian.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-P4/Zy+tmffVGVYvhXMOq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:55888
        "EHLO mail.corsac.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751789AbeAEMX1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 07:23:27 -0500
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e21::1])
        by mail.corsac.net (Postfix) with ESMTPS id 67EF490
        for <linux-scsi@vger.kernel.org>; Fri,  5 Jan 2018 13:13:59 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>


--=-P4/Zy+tmffVGVYvhXMOq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

since kernel 4.11 (sorry it took so long to report) I have a box failing to
boot with a NULL pointer dereference (the box is stuck there afterwards).

The bug has also been reported to the Debian BTS (https://bugs.debian.org/c=
gi-
bin/bugreport.cgi?bug=3D882414) and a suggestion to revert 90965761 has bee=
n
made. I can confirm it fix the boot issue.

I don't have the complete stack trace at hand but there's an example in the
Debian bug. The machine is a Dell Precision T5600 with the following SATA
controllers:

00:1f.2 SATA controller: Intel Corporation C600/X79 series chipset 6-Port S=
ATA
AHCI Controller (rev 05)
05:00.0 Serial Attached SCSI controller: Intel Corporation C602 chipset 4-P=
ort=20
SATA Storage Control Unit (rev 05)

If you need more information or need me to test something, please ask.

Regards,
--=20
Yves-Alexis
--=-P4/Zy+tmffVGVYvhXMOq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8vi34Qgfo83x35gF3rYcyPpXRFsFAlpPa/wACgkQ3rYcyPpX
RFvAvAgAurOS32wT4A9093upO6kCjqM3FDYd+E6N+bSfXslgNCju6p6ZeCPAZJ8W
zyGz+0zwAFjkuS8HXj+bzc5UgCxvEjHBS0al0Y7c0IPdD+AT9Nlruu1i4iray6HH
I2yZUqKjMX9O3p8nYagYm/p6USyEi8d3iv3WCeTNr/uiGc4BQWM8ScUx5G/eY4cf
O39Zt3c7vhcEMSa8dCuZz9fPisaF04pcZzXzTWPdSvdvhqWY99rH8AJ2nlyDPJrg
s+Kvwb6acvr7tkHTwgYbyMWEkC+0cdivunh9SSOlgpUz2pvrQcnw71zF4iDFxPDp
4xHFKxlhEIoG6dV2auwFsamyIJC13w==
=DT8s
-----END PGP SIGNATURE-----

--=-P4/Zy+tmffVGVYvhXMOq--
