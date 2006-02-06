From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: cpqfc gone - all compay RA4X00 Array now useless in linux?
Date: Mon, 6 Feb 2006 19:23:26 +0100
Message-ID: <200602061923.31944@bilbo.math.uni-mannheim.de>
References: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4379742.xtMj3YIHro";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:166 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932275AbWBFSXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 13:23:40 -0500
Received: from mp-pc92.informatik.uni-mannheim.de ([::ffff:134.155.64.118]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2006 19:23:35 +0100
In-Reply-To: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ingo Flaschberger <if@xip.at>

--nextPart4379742.xtMj3YIHro
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 6. Februar 2006 18:46 schrieben Sie:
>Hey,
>
>I'm very very sorry that the cpqfc driver is gone because it was the
>_only_ one which supported the now very cheap Compaq FiberChannel Array
>RA4X00.
>
>With all other FC HBA's the logical volumes (LUN's) are not visible.
>---snip---
>5. Compaq RA4x00 firmware version 2.54 and later supports SSP (Selective
>Storage Presentation), which maps LUNs to a WWN.  If RA4x00 firmware prior
>2.54 (e.g. older controller) is used, or the FC HBA is replaced (another W=
WN
>is used), logical volumes on the RA4x00 will no longer be visible.
>---snap---
>
>So... there are 3 possibilities:
>1. Repair the cpqfc driver and but it again into linux?

The driver is a horrible hack lacking too many of really needed error=20
handling.

>2. Find out, how to get the RA4x00 arrays with othet HBA's running; I
> 	searched about 1 week in Google, no way..

We're working on it. The RA4x00 do things normal arrays don't or so. I'm no=
t=20
yet familiar enough with this to know exactly what is needed to beat this t=
o=20
work again.

>3. Aeh.. use... 2.4, use... other OS?

The 2.4 might work. And I might have some patches for you to make it a bit=
=20
less broken. But don't expect too much from it.

>Hope to find a way... and not only kicking a working driver because of not
>as nice code and to much stack memory.

It was not really working, at least not when I (remotely via IRC) tested it=
=20
last time (some month ago).

Eike

--nextPart4379742.xtMj3YIHro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBD55QjXKSJPmm5/E4RAhbXAKCWfOKfeEAXnwHEZD2e6ncV1NSEhQCePjhw
AUNm9Wfy7zjN865JDPwHrZM=
=C3yH
-----END PGP SIGNATURE-----

--nextPart4379742.xtMj3YIHro--
