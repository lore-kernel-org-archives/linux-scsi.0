From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] scsi_dh_rdac: Fix error path
Date: Sun, 18 Dec 2011 15:42:23 +0100
Message-ID: <4EEDFBCF.4040802@nod.at>
References: <1321577067-26332-1-git-send-email-richard@nod.at> <47D23AD8469A2B448F33C24BD7A39BD9108C7178@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig35DB04A0A08F01CA45C45A81"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:55706 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab1LROmd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2011 09:42:33 -0500
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9108C7178@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: JBottomley@parallels.com, Somasundaram.Krishnasamy@lsi.com, yanling.qi@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig35DB04A0A08F01CA45C45A81
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 18.11.2011 15:34, schrieb Moger, Babu:
> Looks good to me..
>=20
>> -----Original Message-----
>> From: Richard Weinberger [mailto:richard@nod.at]
>> Sent: Thursday, November 17, 2011 6:44 PM
>> To: JBottomley@parallels.com
>> Cc: Moger, Babu; Somasundaram.Krishnasamy@lsi.com; yanling.qi@lsi.com;=

>> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Richard
>> Weinberger
>> Subject: [PATCH] scsi_dh_rdac: Fix error path
>>
>> If create_singlethread_workqueue() failes, rdac_init should fail too.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c
>> b/drivers/scsi/device_handler/scsi_dh_rdac.c
>> index 1d31279..2802394 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
>> @@ -934,6 +934,8 @@ static int __init rdac_init(void)
>>  	if (!kmpath_rdacd) {
>>  		scsi_unregister_device_handler(&rdac_dh);
>>  		printk(KERN_ERR "kmpath_rdacd creation failed.\n");
>> +
>> +		r =3D -EINVAL;
>>  	}
>>  done:
>>  	return r;
>> --
>> 1.7.7.3
>=20

James,

can you please pickup this patch?

Thanks,
//richard



--------------enig35DB04A0A08F01CA45C45A81
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJO7fvUAAoJEN9758yqZn9eLw0IANYEkKJRhX7wSk4BDFj5nT6I
sPRhglcdP/G5CFjU1yXsFWEZ+EhIB8SuWooY7ue257wLa+M5ZX2IH90GYGNBBIVu
30vAAor5uizpMP1wlhr6VPKMhnSGfSe8Ef0tcW5viL+iGS0eO78K9ay0rnBKHYdJ
JzROcIAXYbklRHKlBBp+r4obLz1+G2cNmjHFbcmA3pLPwGBazLZ/X6EB/j7QmeH9
rF8Vlr0FpXs0vPm/9D4X5ZVxqU+CvNNZJQkR7gUPaosPkLKSMYrRPo7ro7R1SEIJ
PzXJybp8UQwn+vEt872uhw9UdPK5onaBnIR0fNH+UG0KCLASO4kgU/H0q1bG60Y=
=6YMG
-----END PGP SIGNATURE-----

--------------enig35DB04A0A08F01CA45C45A81--
