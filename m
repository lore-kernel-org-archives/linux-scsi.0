Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E9FC00A5A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 23:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjAQXea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 18:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjAQXeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 18:34:05 -0500
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF6AA25AA
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 13:12:05 -0800 (PST)
Received: by air.basealt.ru (Postfix, from userid 490)
        id 430602F2022C; Tue, 17 Jan 2023 21:12:04 +0000 (UTC)
Received: from localhost (broadband-188-32-10-232.ip.moscow.rt.ru [188.32.10.232])
        by air.basealt.ru (Postfix) with ESMTPSA id C33E22F2022A;
        Tue, 17 Jan 2023 21:12:02 +0000 (UTC)
Date:   Wed, 18 Jan 2023 00:12:01 +0300
From:   "Alexey V. Vissarionov" <gremlin@altlinux.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        storagedev@microchip.com, Don Brace <don.brace@microchip.com>,
        lvc-project@linuxtesting.org
Subject: Re: [lvc-project] [PATCH] scsi: hpsa: fix allocation size for
 scsi_host_alloc()
Message-ID: <20230117211201.GD15213@altlinux.org>
References: <20230116133140.GB8107@altlinux.org>
 <39006233-ff6f-82ad-b772-e00e789375a5@acm.org>
 <20230117095644.GA12547@altlinux.org>
 <30d3e555-4fb0-23df-abeb-e1c3dc41543e@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KN5l+BnMqAQyZLvT"
Content-Disposition: inline
In-Reply-To: <30d3e555-4fb0-23df-abeb-e1c3dc41543e@ispras.ru>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--KN5l+BnMqAQyZLvT
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-01-17 13:35:54 +0300, Alexey Khoroshilov wrote:

 >>>> Fixes: b705690d8d16f708 ("[SCSI] hpsa: combine
 >>>> hpsa_scsi_detect and hpsa_register_scsi")
 >>> That seems incorrect to me. Shouldn't the Fixes tag be
 >>> changed into the following?
 >>> Fixes: edd163687ea5 ("[SCSI] hpsa: add driver for HP
 >>> Smart Array controllers.")
 >> % git blame -L 5853,+1 -- drivers/scsi/hpsa.c
 >> b705690d8d16f7081 (Stephen M. Cameron 2012-01-19 14:00:53
 >> -0600 5853)
 >> sh =3D scsi_host_alloc(&hpsa_driver_template, sizeof(h));
 >> Is anything wrong here?
 > Yes, this commit just moves
 > sh =3D scsi_host_alloc(&hpsa_driver_template, sizeof(h));
 > from one function to another one.
 > edd163687ea5 ("[SCSI] hpsa: add driver for HP Smart Array
 > controllers.")
 > is the correct commit introducing the bug.

ACK.

2 BVA: please use the correct commit number.


--=20
Alexey V. Vissarionov
gremlin =F0=F2=E9 altlinux =F4=FE=EB org; +vii-cmiii-ccxxix-lxxix-xlii
GPG: 0D92F19E1C0DC36E27F61A29CD17E2B43D879005 @ hkp://keys.gnupg.net

--KN5l+BnMqAQyZLvT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJjxw8hAAoJEFv2F9znRj5KMnUP/0wrCMatHVkAAWWTHqgNtOMI
l3oQpM5WYOmxiani91aMr1oIS9sU6GbG9U7FDgvOZ5M7jcb6o8tC92g0ghYAfoli
T7N+NKhEcQIJRB6c7Xme+fAnK+WJIJnRS+aMrOZ667n7LPW/Q9WNe77pk6FcTipc
umZt2QRJ8C75gJ2q63s8VuYuJ3k5O22PUEgLiB0OB1nlRVNXPvKg0LK/+57a3eJ7
y0phuKbEVGglceBLMPK0MV5lLaehyR++kOsg0kd+OHmiJldaXNyjkeA9G/IzcCK7
DOSw7y4syYiQ0d6xCo4UOhyJV5FGxpjwRD+UOgtUPfvvkNcGsVcCUtdXOSuj8QR0
CKaxaNQn7n81Y2u92qTWwq9zQ2rdmyoQQUSzL8kVmDzAhCBo7LRfVRmX9rnF73XB
KPv2v1GJ1gyhpP/3YyQunuAPwyvI10ASlPA5raHnHN5RWL3uxWzq03rPkfyBulYJ
QrrCao40HDMsFd/15aVnLYO84fVAl7b0rsXIuoyfPe3XVHMzp50vQ6ePQBreDIUB
5Dj2FTOqpUegG5yf5Lnvm9O4Nib1XKMv8gh2tn/uNY21QOvbvJgr1SZbKtY65kQJ
L3oOZzNCb4VDVQJrAN+pVOKhLgGevVyPb8g2VMLFJqz/uiquhk2r1Vxtro8hxZvh
j780cuf785rTsRIdMj9L
=/AIU
-----END PGP SIGNATURE-----

--KN5l+BnMqAQyZLvT--
