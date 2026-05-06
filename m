Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011010.outbound.protection.outlook.com [52.103.1.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A3412B94;
	Wed,  6 May 2026 00:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.1.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778026481; cv=fail; b=sQ0cM2DjwpyVsTerrbsY8hYVj7EvdrroVtSVQLbMdiMxHsCFGqQ2UMlJbI9BSzYM5WOhVXqtAzKDr1UtDZaqBREM58WaYV6Ae56ngdkXQQadS4Dt6kKn/U9dH1rOPp0QLzAQSbTzn00/gBHFDrmyZ/s3A1SpydlSrzZK4jv/PVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778026481; c=relaxed/simple;
	bh=1MJxZ7l8bUtgNmlTE6HPKlNhtRjDh/aCDbUYvMirAiM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pR9lhgm91Ix+2emPuwFcloRIN7Ay+58B2k2Yi5Zvn5hVwC3AvzcVxtiYntbeYl4kItD7zLq+N7S1d3UcI+SGUNoTNRLxtvG18OlbbBGkmzkPPPhYUEwrQPgE3+muASDWsx7zM6CRLuOYSbXKvJ6qHXm9F93uzUcqTbuHXxGMDdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=vGzWfhqA; arc=fail smtp.client-ip=52.103.1.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="vGzWfhqA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfJ9EzFwIIU3rwBzzbPYkPk0+sYnwPslf8F//W8Wi45olVqfgMe7kS8+arC3HFNb1CLyidVXBUX4NLv9ryY9fvm+aHZEzxxS/nf3fDozC9pJj1aAFr+ws7f8o8qICxdr+2XWgrP0k8tYsS8wykFe/kTGyslqWniR3bm1OzI1aKfDBoaBflouyTZ5qG9eaTvdXHKwn01O8wPw22KRQNqtrKR8QxO2YyrQ6PU3EPf3MNvsX3fy2W/OZrG6UjFKQIc4lX+gl0pR9o0mUnUyYM19sv1Vdy/Dkm3IMBHuGuLyc4E1lIzU8Hom5JYL3HlqRLPKn1av0Tj4xHBFF4lEZN4nzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvnhUxy3+tU2KEnv/Hw/ZFYX/jRYC+PPjoQS0TL8PFs=;
 b=MxVc8Ugqqq8rzDmZaSv5Df85Zxp21l+mRj9zC/GIzYuHwvqCozCd7AERvpwryhgbok3e2lzuTd3kbARqNeQo2LtoJGkLuX4qcQUgKnCY56mp7sLyp4lgO0lAfMGgEy0t3WGYd1qHtd0vr665VkQdlE7dQMM4RSB2MmmcxyOLNHL3tHe18HKXwpgUeAfOIJB54xito6a1l1RfBXpUy2F32NS0iQROXJ8pdupqObqvqyo2QD31ZtTqZ7MIvs9j6f4xeD/o+7QDkD9PYXz6PzV/FOKmsT3WWhVQJC1KB/nFTXfPHnNqWp6rcfciGunW5eeTmZrqI9NbmzlMBIL4OZObrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvnhUxy3+tU2KEnv/Hw/ZFYX/jRYC+PPjoQS0TL8PFs=;
 b=vGzWfhqA+jW/pFfBx0Hlzlh3/w9S2um0BzA6TePZ6oBJPvjlaPFtZhrEXiNjHc2e12aWUWq/gehJUV38l0JSthnm5CmGouxsG9yc5ssTbEex+VNpU++JH/6YAB714p2uPnfYQXVoR96JIAFXfmz1piKfqEuZCSAxUZBtkQRpaR31uqouQCDB6J7IOx7xNixSEy30prqLW6EHBzW0+7zE6PxI5bfhlfmecuLfp1kBQbQVIeo+h7P+aOnGWCSEje69vY6hTHFhELMBRzPRKeQRxqjegAB+muaM9TBxLhXyNVl05UN8y0Cmks1g89oCBZnfylbyFTSX/ONVbJMkjvJHsQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by DS7PR02MB11081.namprd02.prod.outlook.com (2603:10b6:8:269::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 00:14:38 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%6]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 00:14:38 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Md Shofiqul Islam <shofiqtest@gmail.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: "kys@microsoft.com" <kys@microsoft.com>, "haiyangz@microsoft.com"
	<haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"decui@microsoft.com" <decui@microsoft.com>, "longli@microsoft.com"
	<longli@microsoft.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: storvsc: Replace symbolic permissions with octal
Thread-Topic: [PATCH] scsi: storvsc: Replace symbolic permissions with octal
Thread-Index: AQH6sUGBvma/AAyIKU6qzqCBT6dbkbXEdzyg
Date: Wed, 6 May 2026 00:14:37 +0000
Message-ID:
 <SN6PR02MB4157F5F7BF86D25B4B2B4BE2D43F2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20260505225321.6785-1-shofiqtest@gmail.com>
In-Reply-To: <20260505225321.6785-1-shofiqtest@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|DS7PR02MB11081:EE_
x-ms-office365-filtering-correlation-id: a7ff2791-c637-4475-5b30-08deab047601
x-microsoft-antispam:
 BCL:0;ARA:14566002|55001999006|19101099003|13091999003|461199028|31061999003|8022599003|8060799015|8062599012|15080799012|37011999003|19110799012|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?WQcB5EQGf3MpPLhroKHg0P7GsgbNMkQ/JLq3sxxZZi/Qg/r41ITmRWzdkk9A?=
 =?us-ascii?Q?IDXuEoO7PDISxJ1kKBZ17N3Zf2GZgfZG6JhieBOvPdxydUS6L+Ds6JEwAxmt?=
 =?us-ascii?Q?1395ds3zIE1zuzKVkLO4YJWCmRBJJ+S/r6HM4AtPLs8zUs7eg0JmYnRu3rB1?=
 =?us-ascii?Q?NVvHuwfwKNaC9Zi1MnqyOi19rzC/TtG3fItKImWZiKcZ6ea+tP21VSBjJy69?=
 =?us-ascii?Q?62fNrQm+H1dv6efxaEULtCB3KBaJB3UNoUPp35cc+uumsLL8VydzUY3CanZS?=
 =?us-ascii?Q?FQ9y9EJwD52bnsZWrfY4Hfz8F+AM2VbqC1eYORzCrA18onJ+wzxmJy8gO5e/?=
 =?us-ascii?Q?5cS+4lLkFloVgcdZjBEIDhHCARV1EDe26apqBqedPXRmOoWDvzerPdXOlFSH?=
 =?us-ascii?Q?VH7CwHUiK+NoNnCpVXaRT2vJYKDIj9gF58p27v2xwFzbiPp0gW5lXBqaY7ni?=
 =?us-ascii?Q?uqaDp0zsonxpd0zk8k1yQ3iYHzOIUQVhWR0bBDl8CNUOOTEj10p9aUiskj3K?=
 =?us-ascii?Q?WZfat+J1VclD7ph9PdEpbJRPlQoVHIu1C/R665pdA6oBlpIsPbZpvZYCHyuy?=
 =?us-ascii?Q?okBKQuadV2Pne7ejkLJXANzPl5tguVl74yPV1/hUYJ4jfm+5/oi5kZvujctG?=
 =?us-ascii?Q?JOXboX5WUH/rKKS8NYp+Ed+1zqOn1IIefyr8cgeUiFS/g7zgqn4risjoq/ho?=
 =?us-ascii?Q?bN+JTpp3j8mTWcJ1c5cS1bm49MhjK//3OHuylo/Fx4+tRLcr+AALUFPNofqg?=
 =?us-ascii?Q?6j8l22AzL+G10TKvK2ESo1LIAEhdu3aOn0QZtPdDuJ+tjyVicHj8Zhz6Ut8D?=
 =?us-ascii?Q?hH2xNceQlsddaVYzhVh+kmSABqVzG+bWSAbPdHhW2z4YXYs8aHW3mgRFMXyv?=
 =?us-ascii?Q?OvQJa1jjW6nMzh/RydSa7v3wQQzPUWx7TOIw3waZBhZIC805qa3NaBLKIRj8?=
 =?us-ascii?Q?2QGoiAuJozb3QmiBXjuPa/W8MyaVDHxNdtjgpiwLJOCqf695MFIpMEEfnA4D?=
 =?us-ascii?Q?T6Uz?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yfGdK3RKsX6JrlUfQhNMKfSjn6/vnQFZ6mvmP1GsrX1rQ6vMM1OPwomqAjsN?=
 =?us-ascii?Q?n9xFMpn3kr2WVnizwujgZkSIu4dTadLyJd0wv7JIdyw0uSTpoQcz5yWwlyUY?=
 =?us-ascii?Q?Flxu3ONMOHpcVIEUayaECKNwrel8ckmPzebnbiFR6cOJ16m8yZqsMsSZZErN?=
 =?us-ascii?Q?d5CLkxDpNtCtYkU0dJjUwIkKfv1LU0XY+fk3FDv5utyhDi0+DHbPO0VYgJGj?=
 =?us-ascii?Q?ZWTLKYH3WpHNw2dRXuByhUZ/NG2wc9yLJO5Tg1VtkzJzKKvRjC0JUY5wGDcZ?=
 =?us-ascii?Q?oT7hGK7R6Eocs78UYBF4BlPoTl2AEoT/kbCw1Lb1DrrLv6nOtU03sPvEmPE0?=
 =?us-ascii?Q?V3AdhUFxAMGBZ9C+/YTbZKz81lgm2bdNzylq/ySCC4EggO0tNhOf9CMi2CIl?=
 =?us-ascii?Q?l9MeeIcO6GR26fQjZJMaDs68WLM7JhYvM5HO1rHdl15kHuh39N8tJXO8d3Dq?=
 =?us-ascii?Q?l/ywNshcjQY0cmnLIWkFsXBp87y9d/KTOQxJjObH4ypu57aSB73/wzvb8POd?=
 =?us-ascii?Q?rddqfX+xyn6JEchgiuovvh9hCB2O4isl0s62rE7ECfwWiIMq0vwF3MVPqqft?=
 =?us-ascii?Q?OrLBUugWo/wEyDwClFViilQUs4/nOavx3JdgbK9cOUZIDPtFYAO0jFhLAzik?=
 =?us-ascii?Q?HXSl/fKlQ5yhBwYMmAJSR6ILVd8JsNdWiIqGl8AXOVeXK7nrFjcZk+/afZCi?=
 =?us-ascii?Q?iePuleObVlo5Y6GxmICPhi7mgedB3smntZQ+jBwM2hLbGJw4eO3UntHER3BZ?=
 =?us-ascii?Q?BOlG5GNh332ze1eMqX3b34UQ6ziGnc41eE/LZ+PMus5YARviLLelyEp2hREd?=
 =?us-ascii?Q?XKaANiXyYUM7zX9RCULIMcOgnsKRwniVAMsvPppzSkUpQuf+b93xH58EqbQt?=
 =?us-ascii?Q?FJ0Kq77XDGT1d5HtqXy5quR0nW758dSRCcHurAYPUszOWvJhgv6FkMsR+N/4?=
 =?us-ascii?Q?0iNrpdLJvhyc3F9tQzvne4EwWSLyfD9BVU4QDgr1Kfe15Dg8bNBhmWScFD6P?=
 =?us-ascii?Q?u3FLymb9cU/aP/QchWYcURH2OrW0qL/0eYuGmq+/fKVhoGRRKlfERN0MoJ8P?=
 =?us-ascii?Q?SiHMdWSvNEr/sko6aK0xpnnpeMpdE3bMr/cdzSrNdDZ2X1WL/eYyTzmO1zvF?=
 =?us-ascii?Q?irF8NYd0Jh+QGxkyYoiTR40UTBlAWM0d4PJN/H+VFJPd13iwiE3/qfuoLPfr?=
 =?us-ascii?Q?cvEJuwEHPpPg7EpX6mOVXyzaiH9UfmcborvA3MBPW/ZBuK9QzbXqYhFv5PhK?=
 =?us-ascii?Q?JlrrsAdWZ73Iy1ViY5cemls01Nx6TsCJ5Ez6D6Dy8dz5TNYDiauvgaa43Xvp?=
 =?us-ascii?Q?u+LtXkKCWIbv1KFe1gs0YXi+UR1q2HLq9HPx+zaON0VL2PMYFaHOl4ooVxnp?=
 =?us-ascii?Q?HpAQKsE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ff2791-c637-4475-5b30-08deab047601
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2026 00:14:38.1140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR02MB11081

From: Md Shofiqul Islam <shofiqtest@gmail.com> Sent: Tuesday, May 5, 2026 3=
:53 PM
>=20

Since storvsc is the driver for the synthetic SCSI controller
provided by Hyper-V to its guest VMs, I'd suggest including the
linux-hyperv@vger.kernel.org mailing list on To: line. That's the
mailing list for all things related to Hyper-V guests.

Michael

> Symbolic permissions like S_IRUGO and S_IWUSR are deprecated.
> Replace with their octal equivalents as preferred by checkpatch:
>  - S_IRUGO|S_IWUSR -> 0644
>  - S_IRUGO         -> 0444 (3 instances)
> ---
>  drivers/scsi/storvsc_drv.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 6977ca8a0..571ea5491 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -156,7 +156,7 @@ static bool hv_dev_is_fc(struct hv_device *hv_dev);
>  #define STORVSC_LOGGING_WARN	2
>=20
>  static int logging_level =3D STORVSC_LOGGING_ERROR;
> -module_param(logging_level, int, S_IRUGO|S_IWUSR);
> +module_param(logging_level, int, 0644);
>  MODULE_PARM_DESC(logging_level,
>  	"Logging level, 0 - None, 1 - Error (default), 2 - Warning.");
>=20
> @@ -345,17 +345,17 @@ static int storvsc_change_queue_depth(struct scsi_d=
evice
> *sdev, int queue_depth)
>  static int storvsc_vcpus_per_sub_channel =3D 4;
>  static unsigned int storvsc_max_hw_queues;
>=20
> -module_param(storvsc_ringbuffer_size, int, S_IRUGO);
> +module_param(storvsc_ringbuffer_size, int, 0444);
>  MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
>=20
>  module_param(storvsc_max_hw_queues, uint, 0644);
>  MODULE_PARM_DESC(storvsc_max_hw_queues, "Maximum number of hardware
> queues");
>=20
> -module_param(storvsc_vcpus_per_sub_channel, int, S_IRUGO);
> +module_param(storvsc_vcpus_per_sub_channel, int, 0444);
>  MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to
> subchannels");
>=20
>  static int ring_avail_percent_lowater =3D 10;
> -module_param(ring_avail_percent_lowater, int, S_IRUGO);
> +module_param(ring_avail_percent_lowater, int, 0444);
>  MODULE_PARM_DESC(ring_avail_percent_lowater,
>  		"Select a channel if available ring size > this in percent");
>=20
> --
> 2.51.1
>=20

