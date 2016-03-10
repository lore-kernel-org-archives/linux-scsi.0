From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] mvsas:Fix possible NULL pointer deference in mvs_dev_found_notify
Date: Wed, 09 Mar 2016 20:18:25 -0500
Message-ID: <111532.1457572705@turing-police.cc.vt.edu>
References: <1457531917-568-1-git-send-email-xerofoify@gmail.com>
 <CAOE4rSzh_ipuuWP1=5Kfu1=9-OqH9Nedko3tscJrC4F-GAG0nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1457572705_2448P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:49521 "EHLO
	omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754349AbcCJBSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 20:18:44 -0500
In-Reply-To: <CAOE4rSzh_ipuuWP1=5Kfu1=9-OqH9Nedko3tscJrC4F-GAG0nQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Cc: Nicholas Krause <xerofoify@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.de>, luisbg@osg.samsung.com, Wilfried.Weissmann@gmx.at, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

--==_Exmh_1457572705_2448P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Mar 2016 22:33:47 +0200, Dāvis Mosāns said:

> About whether mvs_find_dev_mvi can return NULL it looks like it's possible,
> but I'm not sure if it practically happens. I guess it did hence patch.

Or the "bug" was found by incorrect code inspection.  Nick has a history
of submitting patches that are for either non-existent problems or
don't deal with with the issue correctly - bad enough that he's not
allowed to post to the linux-kernel list.

--==_Exmh_1457572705_2448P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVuDLYQdmEQWDXROgAQIieQ/9EPKrSmD/xL/Ffx+TKuLQQ3mU6uH8SE5C
BSZxoXoumz6PjrkV9ph4uPe6lSC9JqM7ptF6rRvKxbicDtCpxnhACFYp12meVPjG
VuKEV3JKOBUfDLj7ZuukY9nNBSS+l1x4wO+GctYNAcRbCSs3AaxZ9xfdiB0hZYz9
dxNDZXipHYc62qmlFm1Pc/6rdOpS03jUSAYDhrBu9QRHjiszv1jp4sFXKkstCbBw
daDlQs4TP7inLyQAANY6Sc4HR9k/FozcQXK99CaSEBecBNq48MULGAy9DF977hp0
y23Jd/xQPReD5D885l088baiI3QTeMwt4UP7PlT7bM3SBQiy9n6ufAUJSYS+SHyO
hZ6qGV+6VRpKlEg2kQcRIo2n9fmcjShnwgiZziYTSmZPXCkMapaEj4GNW97DkKlC
lIATQ3J+5ZBwmA0S9KL6qmjs8kBjknfrXl4VFcAR1jKlPN7mTbx8IcPNO2LDmSGC
TmrRq1i6bpDzYdsRomDlL5Ek+TI0384k12cJFq8BboYqQ+WJ4sMQIOGFo96EfMZA
0mgCd9gnsXc4v/tDHd5pkOEtQoKynPKlTKgLQR/XxclgvKmMhyesum2p5h/An2Ac
9aIOBJXkRFdBH1pcYQVjlGMa7LxBXLptNcFyR170SyKaSrqJLm+me7BG3hjUfDlY
Ou0+rvCyWKM=
=1rf5
-----END PGP SIGNATURE-----

--==_Exmh_1457572705_2448P--
