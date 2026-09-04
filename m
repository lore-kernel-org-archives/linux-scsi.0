Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A743905F5;
	Fri,  4 Sep 2026 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534947; cv=fail; b=kb+3m6utlxMvRuxUcf/MO0MzdyjthRshXG8henoSwVBl9zEGv2xJuUVdAXKvtCa0hXJtzaC3kuZoOc67KchIHnjs5T6/YTVLTj2H/SaLI+GY0+QCWtPEFLwpXUtwHVhaMi6lUIuvA+EGcjcXBR8/SEyhcQokb62rlzDS2yyB9W8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534947; c=relaxed/simple;
	bh=qUB4Jae69nX6vnt/y+gA++6iHeenU+wx33NMtxn6KRg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c72E6pJpDN0TkuxSaCmilBPkaL94cwQCKT3X0YC5zFfWPuYXai5q+HqixQ9HGyN5TxHjVt1Qyetn29qA6pvodlobLosCwgspcPKkuUFQkXk3w6b/3GtZR3AfBdHyLhd6i7EiuYlqdOLwY95lOs7jq8gpaSqcd60cZCdtsBqBPBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=vXuOBvZ2; arc=fail smtp.client-ip=52.101.57.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="vXuOBvZ2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TNy5h5rBYOOQZ7Qzm9DuwTlJpivXf45jRi5RswINO38pLlV0ABC7ByP0bMsdN6M2wOLH0si8ok/+89strDS/cuwQz+7k6a4xKvyIN0BOLYrBM+NWp8n3JhmAZSCTvOpe4TbhIvcgDu1z3pjCm99wWpiCXErJdvWNHrJjI++v5AImiXTc9pbaSx5j0Uw2gzpLDmM75q7OMVMK/t8H+NaVGDKEFf0zuytUYxuuaWIQP8BWtaa87OH5YVhJ2iCDROtclkc27kxJCY/g/lLwvPNs33xaA8kWnZPsk6mN6PjJO1hEWIYhaef68KxdjNHMYlc6P1XdeYgGdKqOZJBriFIhMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUB4Jae69nX6vnt/y+gA++6iHeenU+wx33NMtxn6KRg=;
 b=vcsyG2L2V09bnxKljdBpLa96qa08kZSUNIJ/LgptqO+7a+ZaKu22bKtcahBGmchRJ7BgoAQV1EeGDK0Y59WcgUB5kAm/axQOWxOo+dwwe/ZAjadbzBSfDScXSkEVSbeOvu3FkynV4PSGoCwh3vWW/fxLcEDrjYqDGjKO5zMm/0nI2Bc89Kfz19LuCtpcXLOj146EKEwnizRhc0peFlKKT3INRdEvS5sN0tLp99zqRzhgWEpxMoeG7ww4zzr1H9Z4Fefw4w+nmEfFYXgOTot94dyqPNsIqe2R2AUhDWiF4/TLZ36uRyz6AP+/39OSwtnRrL24t+adPbHRar3KqbgBZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUB4Jae69nX6vnt/y+gA++6iHeenU+wx33NMtxn6KRg=;
 b=vXuOBvZ2hPoGS3hF/SxtNEW9yGjUWIGsH/FXoSkWyrfYo9EZgPyV10nd4vhmTboXjBgouCXwpROCeufykEhpJXx96+IG8OLvAFpXWpWZhGxO+BOVkohlG8Fr7zfNkidmo77ABHcPixfOOPUiimkA3R7bWpYL3ZpVaKsJIOr/FHGJ01kuQlyMgOWL6OrJb7KfmXTZq+YlB2KY2Q8pPVN6sDOhJzrXm150h6FKgfYuSU4XqXFAw/uDrcziyPE8I9fK8disByHKVH5lQd/nTalWoUSE2wwx61feZOcsDI9H6aeIUTXDdJEkWqHK6Xr0jLHQ85utmBFe4BPHoDJR3J6+NA==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DS0PR11MB7736.namprd11.prod.outlook.com (2603:10b6:8:f1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:15:35 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%4]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:15:34 +0000
From: <Don.Brace@microchip.com>
To: <dlemoal@kernel.org>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <linux-scsi@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <cassel@kernel.org>,
	<linux-usb@vger.kernel.org>, <stern@rowland.harvard.edu>,
	<gregkh@linuxfoundation.org>, <linux-s390@vger.kernel.org>,
	<hca@linux.ibm.com>
Subject: Re: [PATCH v3 23/40] scsi: smartpqi: use 16-bits defined sense codes
Thread-Topic: [PATCH v3 23/40] scsi: smartpqi: use 16-bits defined sense codes
Thread-Index: AQHdPAR1+loG+loI60SSNTqTCsJ227a+h5aN
Date: Fri, 4 Sep 2026 15:15:34 +0000
Message-ID:
 <SJ2PR11MB8369F086768CD321855436C6E1B52@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-24-dlemoal@kernel.org>
In-Reply-To: <20260904002644.157668-24-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DS0PR11MB7736:EE_
x-ms-office365-filtering-correlation-id: 6f381d36-2189-42c7-8021-08df0a975e4f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|38070700021|921020|4143699003|10067099003|11063799006|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 TccbC6l33VZ6KqlBx6tj4vQoqBGTtwXEj3AaJYHkp9FE0er4/6mZNmkWVFTZiwtETil/4H8iCvwM1/k9Dg/bSd6Wryrdl6tuHBlLC3psrHLQAWI2Udaju8PQ1er0D3Z81Cx3Q0p/bwJAwX2jWZfDiLNHWmez/VoKosTF6u9ykZAJ87qkylE8shfy1GywYnYPkmq9XRwOA5XhIdj57JQAPMV09/hLPMLa2vQ9jnF835N4kbqiKYYYXgdvEed97i9+EKqOlUqSALNHqQg8ZKdmzDgfeMA8+bo9vMaKQAJ0OwbYrV0qXqx2aV+obioXiV7xwVIvy3SsmpU8g1PtGtYqpw/M6xYn3jkAC4uTWi/6fZFlQ+SZBtd+N+h/fk9wWRYppfIAJuTYkXyUiFHrQx79HG6JeYTWk3qgzNhBiU7GiP9xHF98Zq4y5ipaG7skBcM1tX33whtH2rBcnSOKFDffS6gZVOcu0y2o8zVVIhhH8JH1yKXlV49ShNmXwrT6YbSOHSBdqgS6kjUhq83Z2HSV7xioLqeKcMLv+Xb3RlLR2TpJSRUFvh6HwHdXMiKxV19kGxtY1Bpd05iN2tnKEufqVIG0KMXPWfHc6BIeJvomfu9jMqF+Swqrgmy0rhfbHx2JLhtjccn9MoJ1B10uw/9I0Do98e8Ay2qcjLg1G3mRCQpXpoSL/AF7CLmvy4uveQIj
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(38070700021)(921020)(4143699003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?IvRUxXX9Je4cwR4r14Y0B1SQeyPP5KjkE2e+qajbPZOnlm1uvnhmgzw8rq?=
 =?iso-8859-1?Q?uesjpauI637CDYyUsMC1UF/OpAaOlugaqn1371H5sBO36OApfNXHZtmh8Q?=
 =?iso-8859-1?Q?3Kp5nyzrjoz/A0RPshE4nc3/ReSe5HFixJOC25lypzBX/YAWWI7uH0jro7?=
 =?iso-8859-1?Q?Ue9iCDvUHEWV2iaY5+s/ovuCa79gjKwnsSoPZV0pXoi6GqEiaCm9l4PPW6?=
 =?iso-8859-1?Q?4P5OjsB3D+NeRIsImH8Lv5aL+jr5gSTL7uVFOZV5iDl+bmcUlWwPaf78Nj?=
 =?iso-8859-1?Q?4Ju1sh4gBPcsh7X04xOx9WBSmk8H9aG+h6HwkMwVLXjPvz5kLPzbBCXHl1?=
 =?iso-8859-1?Q?mgaOdSeQjE/a3Ng680UDO4xotq32PASo8wlm3mjc/DLu4PGe2lnzK7wkJ/?=
 =?iso-8859-1?Q?irZPtgwCCBnnBnTP4JXYs0+NFCy2cE9ci0qYeFqmYiKiIFUD1kvF12t7Wh?=
 =?iso-8859-1?Q?d7CI+VKzlsiu8Zt5PNJq7+e2kRGl1xj8sKjFiLZpeSoSTbt8RPi4tyJIQ4?=
 =?iso-8859-1?Q?30b2GZrFWoX/5mOQ9X/MYGFm0YMT/4ihpwZnfDjStE/WEVP+CyMRy10ywZ?=
 =?iso-8859-1?Q?2nkW6fmSIHXTXMyxyLg1qUj23SbQ3Ij4RmZ+hTR20944yK9PTzSD/e6KOa?=
 =?iso-8859-1?Q?b831Ee0luEUomi7SyWuXByJLjqzf3o5yLun48b4r0K0W7u4DoSB4fqWjPS?=
 =?iso-8859-1?Q?BHkUvFhq4nSRXQTrK5fd+7Emm7bZzIDeZwagoCHGO89lMpF5/G8/QwiDGq?=
 =?iso-8859-1?Q?e0wkb3gEeK+hbctXmAoX6xa0ZqO5KRinktRK8WnczMJy7MZeNH8Eh6wfc+?=
 =?iso-8859-1?Q?j/8/wzKA+TSWoJ6wMzKFbchOeEc60OJPxy9IykCF07vY4e9OhejumL4pL/?=
 =?iso-8859-1?Q?XPssImTHb252KOJYQhBMwHO+V/ih6IwEKImudkKrgjteFTH8+gOOhq1fIM?=
 =?iso-8859-1?Q?/Adc3xVjAVEhgXla1/j9ZwfehpRa103H0SPql1qcJyDqH7hjVQ9JeIKWIL?=
 =?iso-8859-1?Q?AIc6MYUhH0nhuBVUvF1aY7koCdRmPwUB+S9d0IVopa1jOwo3jvPIgT6GwJ?=
 =?iso-8859-1?Q?xZMhJbpMEsbrDBJWIFNfitFxPc9HGfC+KG4EcxxUYZTl04PsxhkJ9JdxZa?=
 =?iso-8859-1?Q?vDiGQ+/0Ra5J9nybI/HI8yGrvCSUqwhFhAwsAdyeXzYVluDN6APQHxXVXD?=
 =?iso-8859-1?Q?DBZZeyMInPJygZPlK/yZU9eKXGb9lKvO7wVq17L7Z6bzdkjG5vWZ41xJRP?=
 =?iso-8859-1?Q?OzgHIQNNwpeAtyGgviMvUaU3POMRH/zW4vTY3sj/FDZlhsq+tb17EWj/yN?=
 =?iso-8859-1?Q?x4TyEtQ6tAdk1BMT5c5kcaAf35zMp/iC3b9Qv1jWit6k/Jv/vmvpphZ4ds?=
 =?iso-8859-1?Q?q1mhaMamQTeUgOE6WWuMbtHiMZrcKR5l5yfUZoHvdezr56CAMQ8F+OWKIh?=
 =?iso-8859-1?Q?zzYhMi3cVT5xgrvdcMvK2ryT/cCXrFbZAq2vy8kMMK/z9OdY2XVlEKgcQD?=
 =?iso-8859-1?Q?Rh72EfuZhnW1uIZVeUCWXo98iLEoWa0FztWfRl+t6INtd5bdpzsTxpHUS/?=
 =?iso-8859-1?Q?PzLOr32Mo64ymdEZ30buxa/zCzCQLz/WHE9s6K4sh77M6TCVZuMFFQXMd4?=
 =?iso-8859-1?Q?qcCNorOVfniADRXAQGbcYYDoc8O4Z66Yyp8S2tnvdoEGqb7m5q113z5ndN?=
 =?iso-8859-1?Q?15TXtb9zSsbP8GkjJw3sohsbwp9IrIVjeRXVRp2keqkZI22bBGk5lRoSCU?=
 =?iso-8859-1?Q?TpXJvW6SJf97yyBttABgQ0lAfyp7fpCsomxyufdvubgQWClPhK6MagZ75V?=
 =?iso-8859-1?Q?fhzLJXXQ0g=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f381d36-2189-42c7-8021-08df0a975e4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 15:15:34.8345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nt9qvvbd20+5/uz6WIAPn/hIfEgrZtvId4WtX8pKrZBHx/tBZKdwx+mBAKj/6U3Fdz5qk/7V/cSqOgc3hvYwgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7736

=0A=
_______________________________________=0A=
From: Damien Le Moal <dlemoal@kernel.org>=0A=
Sent: Thursday, September 3, 2026 7:26 PM=0A=
To: Martin K . Petersen <martin.petersen@oracle.com>; James E . J . Bottoml=
ey <James.Bottomley@HansenPartnership.com>; linux-scsi@vger.kernel.org <lin=
ux-scsi@vger.kernel.org>; linux-ide@vger.kernel.org <linux-ide@vger.kernel.=
org>; Niklas Cassel <cassel@kernel.org>; linux-usb@vger.kernel.org <linux-u=
sb@vger.kernel.org>; Alan Stern <stern@rowland.harvard.edu>; Greg Kroah-Har=
tman <gregkh@linuxfoundation.org>; linux-s390@vger.kernel.org <linux-s390@v=
ger.kernel.org>; Heiko Carstens <hca@linux.ibm.com>=0A=
Subject: [PATCH v3 23/40] scsi: smartpqi: use 16-bits defined sense codes=
=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
Refactor the smartpqi driver to use the 16-bits sense_code field of=0A=
struct scsi_sense_hdr and replace all hard-coded additional sense codes=0A=
and additional sense code qualifiers with the enum values defined in=0A=
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes=
=0A=
being processed are easier to test and self-documented.=0A=
=0A=
No functional change intended.=0A=
=0A=
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>=0A=
=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
Thanks for your patch.=0A=
---=0A=
=A0drivers/scsi/smartpqi/smartpqi_init.c | 31 ++++++++++++++++-----------=
=0A=
=A01 file changed, 18 insertions(+), 13 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c=0A=
index 140e8a6addbe..d8d0fe915805 100644=0A=
--- a/drivers/scsi/smartpqi/smartpqi_init.c=0A=
+++ b/drivers/scsi/smartpqi/smartpqi_init.c=0A=
@@ -3249,15 +3249,15 @@ static void pqi_process_raid_io_error(struct pqi_io=
_request *io_request)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense=
_data_length =3D sizeof(error_info->data);=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (scsi_status =3D=3D SAM_ST=
AT_CHECK_CONDITION &&=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_no=
rmalize_sense(error_info->data,=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 sense_data_length, &sshdr) &&=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 sshdr.sense_key =3D=3D HARDWARE_ERROR &&=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 sshdr.asc =3D=3D 0x3e) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_normalize_sens=
e(error_info->data,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense_data_length, &sshdr) &&=
=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sshdr.sense_key =3D=
=3D HARDWARE_ERROR &&=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_sense_asc(&ssh=
dr) =3D=3D ASC_LU_HAS_NOT_SELF_CONFIGURED_YET) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struc=
t pqi_ctrl_info *ctrl_info =3D shost_to_hba(scmd->device->host);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struc=
t pqi_scsi_dev *device =3D scmd->device->hostdata;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 switch =
(sshdr.ascq) {=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case 0x=
1: /* LOGICAL UNIT FAILURE */=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 switch =
(sshdr.sense_code) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case LU=
_FAILURE:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 if (printk_ratelimit())=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scmd_printk(KERN_ERR, scmd, "rec=
eived 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ctrl_inf=
o->scsi_host->host_no, device->bus, device->target, device->lun);=0A=
@@ -3265,10 +3265,15 @@ static void pqi_process_raid_io_error(struct pqi_io=
_request *io_request)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 host_byte =3D DID_NO_CONNECT;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 break;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 default=
: /* See http://www.t10.org/lists/asc-num.htm#ASC_3E */=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 default=
:=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 /* include/scsi/scsi_sense.h */=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 if (printk_ratelimit())=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scmd_printk(KERN_ERR, scmd, "rec=
eived unhandled error %d from controller for scsi %d:%d:%d:%d\n",=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sshdr.as=
cq, ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun=
);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scmd_printk(KERN_ERR, scmd,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "receive=
d unhandled error %d from controller for scsi %d:%d:%d:%d\n",=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_sen=
se_ascq(&sshdr),=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ctrl_inf=
o->scsi_host->host_no,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 device->=
bus, device->target,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 device->=
lun);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 break;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
@@ -3286,11 +3291,11 @@ static void pqi_process_raid_io_error(struct pqi_io=
_request *io_request)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense_data_length &&=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_normalize_sense(error_info->data, se=
nse_data_length, &sshdr) &&=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sshdr.sense_key =3D=3D ILLEGAL_REQUEST &&=
=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sshdr.asc =3D=3D 0x26 &&=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sshdr.ascq =3D=3D 0x0) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sshdr.sense_code =3D=3D INVALID_FIELD_IN_PA=
RAMETER_LIST) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 host_byte =3D DID_NO_CONNECT;=
=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pqi_take_device_offline(scmd-=
>device, "AIO");=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_build_sense_buffer(0, scmd=
->sense_buffer, HARDWARE_ERROR, 0x3e, 0x1);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_set_sense_buffer(0, scmd->=
sense_buffer, HARDWARE_ERROR,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 LU_FAILURE);=0A=
=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 scmd->result =3D scsi_status;=0A=
@@ -3380,7 +3385,7 @@ static void pqi_process_aio_io_error(struct pqi_io_re=
quest *io_request)=0A=
=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 if (device_offline && sense_data_length =3D=3D 0)=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_build_sense(scmd, 0, HARDW=
ARE_ERROR, 0x3e, 0x1);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_set_sense(scmd, 0, HARDWAR=
E_ERROR, LU_FAILURE);=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 scmd->result =3D scsi_status;=0A=
=A0=A0=A0=A0=A0=A0=A0 set_host_byte(scmd, host_byte);=0A=
--=0A=
2.55.0=0A=
=0A=
