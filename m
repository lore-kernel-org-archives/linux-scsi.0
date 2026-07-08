Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBE43C8C55;
	Wed,  8 Jul 2026 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783539636; cv=fail; b=JUDlj43YgeU6fqm5e2/N40JisMY/SHtRlGbv/4bYaq9YhRGRc/N3Rd50xyaKe84guA9F3zd5zPLbul2BL9jLvoaPEBJM6vZ3Gk/GsRC7YOWBqli2C8rVIRnaK7vtBhJmMXe/icPc6zsH5VYZXuZZDZj+QYu03Pic7ISX51se6DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783539636; c=relaxed/simple;
	bh=auDgUFWZAsgjvBaItHmW1uVOTw863do6Xz834/sTVY8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tQlnxcNq0MmxpjH23haLDOnQydK2KQQyDm3bHL79q2dyF0mfZsayoWZgy5IQaI6sWJTQKjKA2fD5HPFODo0E+JfSzaR/Agbevp+lPLdfivUhp85AAwY0I69ccQf77MhSS5wAhQUAgKu6g3icBIiG5tSK37mGDJlvj43YbUS/x84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=egejndba; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="egejndba"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4Cet/zyV6uoF7u+tAd6Lj0WxGN/ji/8mB9e47HX2gSmswiRj56bpdjgEhm7tMJeBQkG5IovmsVvll/fp0DyzraMl6UsY/AZiYZ+moXtCQrgRZfl2BUqmVS1cE8g91TZtXwNy8lvQJuo53gPH6WJ8qpYqSAxAfMYuFHX1I9iNj/BrYuJO11sqEZepv9AEgWswKoOdGMkhsm7Jy0Jz6gat5v6ERI3H1jJIo/Y5RJLAKSh/SZbJlDATKMk1K+kRR/t2kzYICIPpw1S+vcw7BHz8DhIxgeokP3FDe4BkEo4sVaMXEAiqNc3zV6vOx6N3yundChaKIrX3dj8Jan0eR/btw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auDgUFWZAsgjvBaItHmW1uVOTw863do6Xz834/sTVY8=;
 b=smgaNpu8ZSClWz7jd5DyaQ6NXtQuuWG+hmhx9qweiaJTdomB5KSVk8m2J81S9ZZ6bOEh4xXuV4uxJd2KWzWXq2OUDvxLV0hhaOeSnfkfiFPfbchuwEMJneClY4f6OT9UWAw3A8KwyxC2h6NLUGs1BYfMcwij089sYawcQ5hLpTEih/6uX8qRpvT0ZNk9wLs0XWfxrGTQR8CQ0UVg6gYVQARLXi5jTMLoLYeKG10a2TRacYEhP+GbdJoKwUE+OEYHONHzcZSpFW8XvJIXSQM4N7e4+gMF2j+aLPe3lgtOOQokdBZgORNK2lre0Pk9p5OiXsssOprRHxGU0SWTPiH5Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auDgUFWZAsgjvBaItHmW1uVOTw863do6Xz834/sTVY8=;
 b=egejndbaPHyW0g+9zgjghZR2ojk5/xizf4NKLHlomr8UEF88ctjvDT5sTLyjm5aj30lTyCN0jAeQWj3A19YE0Jw84q9YQtNJkz+DUEXNRoSF4sfw+C/CahDgU/lD9CkVW2Zs9VjghjnBIuTggOoKzYHQM9KHPwpdXpkn8G2SBi8n0NlcYc3qc3pChGVkpnn3WlzmX2xWXgXwp7tOOwr3DH8n7r57yaXxL+zBUqF/DxQ/2S3GJ+SSaiZxlQbso3tXM7IMYEE+ZyWufq30pmZQOfZ14fwPgksor2JlJhVr7msGVxLbJGT3ihD8HWR8LSnwQU1uqyF4Bv0GqMAfrbGyFg==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 19:40:28 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 19:40:28 +0000
From: <Don.Brace@microchip.com>
To: <loberman@redhat.com>, <mateusz.nowicki@posteo.net>
CC: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
Thread-Topic: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
Thread-Index: AQHc3WDg78fpqGHAHUOQRv7RACSNAbYNm/gQgFac5wCAAC5XJA==
Date: Wed, 8 Jul 2026 19:40:28 +0000
Message-ID:
 <SJ2PR11MB8369EB3741A8AB8F28C8C84AE1FF2@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
	 <SJ2PR11MB8369F3008C15A2E56DB7B429E1072@SJ2PR11MB8369.namprd11.prod.outlook.com>
 <b3baf6f6e9151078c21de67228f8f84e4ca090c7.camel@redhat.com>
In-Reply-To: <b3baf6f6e9151078c21de67228f8f84e4ca090c7.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|BL1PR11MB6051:EE_
x-ms-office365-filtering-correlation-id: 6705d9b4-4e71-4af1-29b4-08dedd28c39e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|11063799006|18002099003|22082099003|38070700021|4143699003;
x-microsoft-antispam-message-info:
 qys0jLyBnI6bRuKIHXh5599VDYmvc9KLOm+EECy2JE4OOJt3a+wAfYHgECHazK40nTHrZJmewXXk36Xcy6GsnvghK/A16cEjjv4+bZIDp9lRt8O0w023Ztou6m3dwD/zxfcnx95e5HaFd+/CbbpHwGQd3s+rcRUzihSXaJjDwO5S6pGX8CQfp5f+6aFscmC709Vin42MPzjYGXed/JH2pSdqKuB7nlj5k8AYyeFgAE7l8jGpG2OcKkexk6P6OEdZ8EHlYUlKLInHYtQKv+GP+Hrk/uHO3d10s3PQrFl+vEbGXb+aIYVORW6x/JrhU8XvdVWO9ypOpKd92GzifuBmT/sx58b5AVIoWWhrHaa6dbLMzknpiXWgbFqOBZhHcOMHgVsHjTHY4gmbWIBR/WTvhN3/QXKPjn6yzhfAa5iMVHprD2Qn71vYZxinqsNdN+6tMxadPqoOV2C5OkDVRHDX5V1ZFKsJ++5pp1ddhKw+42a1ILBDoWnuu9dM659aDQ7yjHvIkqoe1sFmzwZyNScIbZlKJs+mlWEL1CXH3wtxUf/PtRqtz2/2jNw01e5S5ogc2F2XNf02JKduu3NgUCTJKQiLGw6xe9X9tU0Y5YxnyKzkB8rl7qU3QEJO9QTPSow3Fet7uI47e5haQ+NbQKLEAvXra+OCvuzGUvamcHdqVxKm2NqnCaOv4IHJLEOSdO5aLIqHKLAbgmEQJ+Ltt71EZTlDR8A4uiz4uMY4IHqiKrY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(11063799006)(18002099003)(22082099003)(38070700021)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?NCY/PEQlbhvVOhKEPehvcfjEFvVL1Zm1wQ0+bC8nsG2IvvCO8Kjm2xRe?=
 =?Windows-1252?Q?GfLpe0qYD0KY5jW72mBn/U8F+RhQMJ91pZfy3qW1pNkD0snxWRk/sKg1?=
 =?Windows-1252?Q?1l8773ZCgler9NNmFd4VrhVlzWwcjmAMiAA3utTnT+yQKCL8kmPZLXeg?=
 =?Windows-1252?Q?qAeNCCZ5o4Lz6RY7xiSXKVrIVZ0YJaW3/k+b7Gbzo3mNhiquIrRX5499?=
 =?Windows-1252?Q?9c0CkdJGTh3ahA18t11rM8rgXUMuN9J+xurGACIiuHAaSs2+gA6wpwTA?=
 =?Windows-1252?Q?fGH41VSft/08KXxFJ2lAGF5FElR9P++x/kaxGtS0x/Cfcx4YknQj9OOQ?=
 =?Windows-1252?Q?NTAGMP8qWh7rZAwuQG7AWxKAE5bASidcQJi6tk29+cswAUMxd1bdZ3op?=
 =?Windows-1252?Q?qxFjS3AiXi19DNvvZ2RyIhkc33QYjDPY3jztMnMjXotSsbiFrI9JKwGO?=
 =?Windows-1252?Q?tRXS5fhtFzafHwodcgS7NAeXMQeXQNaji2punyhAyvQK/BYm2ror8IfD?=
 =?Windows-1252?Q?lUUC6VAnLtKqiP+wS+SYG99UOO5hV2T19F//u7x1skTzlykj2vrcNS9f?=
 =?Windows-1252?Q?6y0K0Sn+ROCJeyeM3AT6j309vv9oJTYYdP0cQDL7z3XYuoedvOGGfMqV?=
 =?Windows-1252?Q?Zdysgs/1RfI/KdM1RhPaTIZOSuicsQ6Xe7OXASaBWM80OatMt8CvtK0t?=
 =?Windows-1252?Q?SrRD8vtJpnE3IJvGEYVYhzT41FR0rP9sscaq3veUL3w/0yCobtVVbWGP?=
 =?Windows-1252?Q?fFmS4PQwXhVnY1FC6+kwBeloyK5GUZzpel397KdmN4GKfR+whIcO4qwG?=
 =?Windows-1252?Q?oFndtq7eOlBcqFb6TnCEACFfPkneo3dlW02WWKhZ+jK8xb9eF/N/0+Sp?=
 =?Windows-1252?Q?cn8jX6xL57OprrXJq/hSEzeUJvUK2mZQ7UiDnfipSvu0dVhJxCRR0+E5?=
 =?Windows-1252?Q?SUXibzUyCtFwTQzWJAAGtEdoZRJ1s5zQ6RX5JZ/9Q7Vsyyezrbv6YvIi?=
 =?Windows-1252?Q?dCzrqk5N1I+82iKFMiZsUmhXaxuUFMhPJZppabSf0aXk29aX5HMgA0zr?=
 =?Windows-1252?Q?fI3V6n2CkO68k63T2jS3nzD7dH2k/zCx/qbtL+j/taeEZ2sEaeJ1K78K?=
 =?Windows-1252?Q?tpfyYtQw9DY4MaGjkUEWydLsC/ZU93Oc+sqO3B4EQ9/JZavJNQyzKsj1?=
 =?Windows-1252?Q?2gekwnC6WBaE6NuIdpANPp73c0lolbP78YrXaB4AcdYxBB+2BiWA7YV1?=
 =?Windows-1252?Q?O1Kle+ezeEst8xTHBE3FlK/elqLyiMhN/V+QtxwJ7xlEHOVPNUtmEita?=
 =?Windows-1252?Q?NLqjJFAX/z8BWpv9YYWX4czuQFlbICn9GUxHy61nn7BkP2VzKVhEFXlV?=
 =?Windows-1252?Q?tOtV1fiq2PiTATdTMeEB6YRkrR4QiwNfNXFL6Q7pR43IGroTABAycrO3?=
 =?Windows-1252?Q?pHlgLLBkCkJJDFV/4YK+Rv0NbhlpqqNfkuNoq334ggUTyWyvemuQLlPz?=
 =?Windows-1252?Q?qePmh6TiK/VOTZProUF28QttL3snMOwcYQjODl5PFQZOZyCb/1vVA00O?=
 =?Windows-1252?Q?JJxvSFJ5Ybblsq16hW08BTJH/VvBx/wH/TGQKYv0vQ8LelA4GmjSKEgh?=
 =?Windows-1252?Q?cJNR/5XRk/3FrJUetx/tW89bpZIUawytM/fSGoN85tIOu6zS+ULxSO4b?=
 =?Windows-1252?Q?/hiP+e0uQr4BH2QgJKL8DII7NSWuOtdF73suwbEwYGcjICy7q9kfdL3N?=
 =?Windows-1252?Q?DGNs2S97QkfIWCxMAouojE7hi0atxjlIPaoMxd8AqZH+2fZJYlRYWvO5?=
 =?Windows-1252?Q?VV55nLgz3Fj/9/VsITu5A6Jyzk0nCGIvJzGBck1C0K/8VNvKgzxdwNBk?=
 =?Windows-1252?Q?HDCdhzNfUxvszA=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6705d9b4-4e71-4af1-29b4-08dedd28c39e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2026 19:40:28.3056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zl1I8NJTMh/EcwkuD6ZoeGJgDkQFjwkMhXzW8foVuhhu5/obeOZOHpAaKJWFCvXo41KwoK92yOVlPCh3oWCyPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051

Subject:=A0Re: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery=0A=
=A0=0A=
=0A=
> A PCIe bus reset (e.g. "echo 1 > /sys/bus/pci/devices/<bdf>/reset")=0A=
> on a=0A=
> controller without FLR support leaves the HPE SR932i-p Gen10+=0A=
> unusable=0A=
> until reboot: smartpqi registers no pci_error_handlers, so the driver=0A=
> is not notified, firmware reverts to SIS mode, and all queue mappings=0A=
> are dropped while the driver still drives PQI.=0A=
>=0A=
> Patch 1 adds .reset_prepare / .reset_done reusing=0A=
> pqi_ofa_ctrl_quiesce() / _unquiesce() / pqi_ctrl_init_resume().=0A=
>=0A=
> Patch 2 raises SIS_CTRL_READY_RESUME_TIMEOUT_SECS from 90s to 180s,=0A=
> matching the cold-boot path; without this patch 1 fails at the SIS=0A=
> ready check because firmware boot after reset takes ~125s on the=0A=
> SR932i-p Gen10+.=0A=
>=0A=
> Tested on HPE SR932i-p Gen10+ against Linus' master at 74fe02ce122a.=0A=
>=0A=
> Thanks for the patch.=0A=
> NAK for now.=0A=
>=0A=
> Before we ack, we want to run this through internal regression on the=0A=
> SR-series=0A=
> =97 particularly the OFA + bus-reset interaction in patch 1 and whether=
=0A=
> the 180s timeout in patch 2 should apply universally or=0A=
>=A0=A0=A0=A0=A0 be controller-gated. This may lead to changes in your patc=
hes.=0A=
>=0A=
>=0A=
>=0A=
>=0A=
> Hi Don, Where are we with the testing you wanted to do.=0A=
=0A=
Regards=0A=
Laurence=0A=
=0A=
Sorry, we were in the middle of a release.=0A=
These have been added for our upcoming sprint.=0A=
Results will be a while longer.=0A=
=0A=
Thanks=0A=
Don=
