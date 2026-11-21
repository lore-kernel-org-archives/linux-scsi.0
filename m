Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249646;
	b=nNdhRPlE7eG5rjQag+c9EVgjwSf4PUdqp9KwWeX3rOTxRDJl2ujxcTP+a7F301h8JVp8
	 Jv/gu9KNrSwH9QCB9vu8+4GJdmaCmvZmQMLH18tfZpZ9HtpHME/8vxYNPECH4havJGS5b
	 8Rpo9ycQor4lOg+h1v1fjn4qb8zUy3tnGt4yjvKBjYpfSF/XA7xARRYcbrNf44j6VsCpq
	 nI9rWc8sxE0X5lRwauiWpSD+J6tbnQvwUMMZQQWHotruZxsEtdyU5lb7FU6QhNp1ZdQ8W
	 AFEdi+b8U93fQ0ZqEMr0vBOSn6gfSjCMuS5qQguf2jFf27YWqn8LLGl1TCEhelSI8pQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249646;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=/t1EHJdgJObZ1uJWl2NyG1P65mK4WklQcAA6vyXd1Y0=;
	b=Gemqyj+rdOAscJkYvS1IV9RkZaASnWY1i9mAT3UZU2pJdywiApgOkZ+xg9DKFz5mXFFG
	 JF++ymVDY7GZgVQQU9r8ffEbuN3GE/Af4NRHDkR2o3OrhYkxbyzdXWp3K5FXTgevAYhW4
	 fvcJxalVeSAA5Zcz1pAeVvJsFZZcViwN4dIX+oZpWD+tvZ52V4j0UZ5kLHxkbPXBFUPC2
	 QWwbSxrE5zvZmiWxDtXZAwUqLdVNy/lSCyArxhNQvi+frsQ1JJ8vacsjnR7mlVarK1qfB
	 hvAggcOQH9ekNirZOs+M4iQPNeB3BCvikjNJj4B+z1HkrImEHIwnC2SbIQdRCSd+oJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ZYLR+zg3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.8
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011008.outbound.protection.outlook.com [52.103.1.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C99606A333;
	Sat, 21 Nov 2026 08:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61C99606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ZYLR+zg3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ovOl60OJ6NhlkzhUwb5LZwsSojJv0qbYB866eyan6fNejB/5W5UVJN48m5v+DNDJb6H6YRGQu0R+d3LEOCGuzs1T85d9zHgOyR2N5i1YdaIRgjlr7OKp9+RUJIKriX3JdOP5x1aN65O3NwAHHljSraLFqJ6w59VjNoVH9lC2hKzgk6oFHwEOm5jc6NqLJ4u501dJvcQGhNfV9WddiKMY/tqVhFBl92L++DNv/ATPP1R3X6qHQv5QAcKwIbRY1p6UK0gax5+zSgrkT7LFhbJgKu+NA0ao+Cn0/nYVcq0I5N3GzwyS+LQB77g9W/FYObddn3P20yZ8R8mGdIqaAIdvLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=/t1EHJdgJObZ1uJWl2NyG1P65mK4WklQcAA6vyXd1Y0=;
 b=HjBmnYeRHBflkAtIkrXUoAEPgdlU3tckyw7NFnAllZep2czG9/u4cuQbIyoswMRRmq8lDQsnoJB7+rDD5z/ANVpKmgdCihQYQBnRhWYgeIvxLOCfzCN6S7H4ZH3hkF5Cgh7mKl9+9Nq1d8ZMkrau2E6L+outlAlNklLc3BvzEGX8zgiZW5EhZdIXEVjgP7u3o+9djyhtRAdbyD2JOO23LDDP9Ocp1CTCfT29x62rF5BiQ0QqhKRNDX4x3ESqR/yimi9IYKYUpvMk/naMfojTsccNMbaZ2+wPciY0o8OBvzeQ7kDM/yeh/1suhdiBXb3v5y9r/82+QFlSWVh60vE43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/t1EHJdgJObZ1uJWl2NyG1P65mK4WklQcAA6vyXd1Y0=;
 b=ZYLR+zg36oEMQlOL00ZgDzenU6O2LQYa7CwJsoKqTa7ciwHBn9BMnslFIX135gBxK4JrOFeKH+pt347/0RgNy1BHxrDGKw69IKrFKRVamQtWooRAddg7MHhS0D1kKM23vITzh20iCfQfwJfQ1U+Ds0A3h7C7m0P+uGu588pkIhghMPNNl8Jw0m4xdL3qDK17BQJaGCAhvOumM8BE68dU8XFcanajpdlJNl6F9TL9Cor6kuo+Zuf8nbHVPR2UzM32+G3FV9xAQNzUHsntCcKA66TFGn70YUBadofZiNr+xXMjLQT9hvQFWC5hZHkpjON8DpZY4n9k/u9g9k/4IVVOyw==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:27:23 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:27:23 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v5 4/4] scsi: bsg: Release synchronous request before user
 copyback
Thread-Topic: [PATCH v5 4/4] scsi: bsg: Release synchronous request before
 user copyback
Thread-Index: AQHdeZIipZD/R0faFUm/SAFXW9EXeQ==
Date: Sat, 21 Nov 2026 08:27:23 +0000
Message-ID: <scsi-sync-v5.1795249365940711260.4.x-professor@outlook.com>
References: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
In-Reply-To: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: e01db54b-07d7-4349-6fde-08df47a944c1
x-ms-exchange-slblob-mailprops:
 ZILSnhm0P3mCYd7/icPJlj+s+m08RC6krvOKtGwitgl6tTfBxXMO6992twiB4HxDAcUpgReX1k6FbDP/VixyBRyjc0ODCeS/RJ+HV1UpoCG6h2ZKyYc4mxz41qFKCnhCHoXD+zXQFKQ6jRsXXnoW0JXnyB6hgtv2VEV0mPrTWQ9svEY/GLVuU9Kd6kvXoPLNQoFj9UDrdb30n6DoUxPl3/xW1PK+dP17PsSOvnLdcw1eCBlcSDonjOfpWQyUYQzcOd/qnRV7rww5x+IE8dw86WTZGSRLrW5SCxn6pKICOu7lSdFqN8qvLoSEBESxrdLU0T0P3DJS7o2Q8XR36MIXmjE2zIp1Yr4i/8ToHqoYTvswEpn0vPJrFH3Ibh9TM2d1hn7PClDwZwe0yHoofQzgd3g38mn2Thd+XXYl29PN7SZ7TFITf5fcQCQs8yCAgOSmHtBQGUkLP71jgK178pFzYCZ8qmDHZAHwCou3wU6mOmmM33NSNaVBzBooD/ryd8ckqGrEOiSlR64a5I4nbanFgGlkg8pMKC5m7kGXnug6d9T9nD1IUiUIPYTX4AE+M/DRP9jAPLj/+rWYS5LbUeJacRCuQMszbo7y//gFk2mnwjlzXE5k9B1HSDi3EHuPSC04rqFi70QYQ/GpRhnIA0fej1BszH2XlVM2Ni3UJjL7aEW0RrKmgOJFkBgEIvkOOurt6hPjpT6iwJCf7h2pQESg3MoW7DJfY6mv/zy4gypbxrWkVRsP99m/xxv4BZ3hpKcbb0vthPQj6Cqxmlpgbcn6IeVfsuLUI65S
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|19110799012|4140399003|25010399006|8062599012|8060799015|24021099003|31061999003|440099028|3412199025|4302099013|102099032|1602099012|12091999003|10035399007|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?4RzNLD/sse6Ju7KmzqsCucMM4tFQqS6xyd6cEnt1EbfBTyP6Jg6lr79lEd?=
 =?iso-8859-1?Q?HpCdAJdVINyiraJqV3ZR3JliGh+oL1UGlSsny82nEdPO2cZC2LMMb3JIXa?=
 =?iso-8859-1?Q?bWM//bg5NUJoK2Sqoa8KFrlXQvRguhzLRNeF0KFUqB8JPVtgiKvkByAcpR?=
 =?iso-8859-1?Q?CceOZ0JrdfdiVsTJu7E6O7pxwjAYLWM1tmH2ct6IB6R4RmPFFM6nkZRy4Y?=
 =?iso-8859-1?Q?Id8kHzrLapJnELwTUqDKPsKjWLdybzR8wUiWGazHeVmW1OcDeGCwicrZOx?=
 =?iso-8859-1?Q?qrR4HmnPYHrgQKbfl5nZ7nCgI1fKtf7J7zRU1jMusWyuB4nwAUQ9Mjo9yp?=
 =?iso-8859-1?Q?DB/yCJHhoT5P89U13mhEoNL8CUTwK2XeE4RhWlfgGzpST/IFbntpAO9SAH?=
 =?iso-8859-1?Q?F3Uf2/JInXMtBrymD5FogSntxsrlCPMxtxX7XoNks/aCe6WNb2fhS584Vi?=
 =?iso-8859-1?Q?oIopTip28rXUro8/kjVAKxaUv8mGKvUdpw7SgzSZocaIAVnE5IIalLvAU/?=
 =?iso-8859-1?Q?vXFEwj8oJWZ+8BLQYqOSkzkslQylnsz5xE/Pg0K2rfHxzmKQaxWJgDpWEg?=
 =?iso-8859-1?Q?vZ5GRd2oHNOS8iE4pR4JnOny+ahO+TDxYPuX6WwKLe8GY/rCF8wfU7n23k?=
 =?iso-8859-1?Q?od6K2b+7EPU7ghsZakOHvgtGf5MXYlf79Gb5ncOOtbEhKB46ROHgciscrw?=
 =?iso-8859-1?Q?t5pj+KLfCusH7AlYWAgl+/mW6kYiTf9wFaNQmOK3O+dj6XQiuP/vj/f1u7?=
 =?iso-8859-1?Q?hGddmFdGnRLiNi1ZGmMcRbbbFSgteMF4ZUC2Oh837ZPfcsEJmWKhUEh0Rn?=
 =?iso-8859-1?Q?AMMowrGaIfBRqCkfM/mcVLolM4EVYp4iKepb2WVQAP7lG8M1gt0Lj7xbuG?=
 =?iso-8859-1?Q?Fyaic/YN8iBcwJ92HyHBWsfJ2PaCkzFqEJmH7LqznazafBD3lkBZNuNHJq?=
 =?iso-8859-1?Q?2l5eb1cqHBRABjjkV8nBdgrawXMoJpNJchRQvkuAKXDa39fHeQRezTGgeb?=
 =?iso-8859-1?Q?rkGS0bOOXppIkI7mhiWs3GcHJwF9bqVLvKcvKqi8r3eIKQldO8qfFCKzaB?=
 =?iso-8859-1?Q?bnR7mLyn5XP24TnWfPyAiKuhORW8ZjV8wNoxeirF0XHAJYk6zyojMe9/A0?=
 =?iso-8859-1?Q?HnOqEw3K8FkiBRvLYhD8l5XlnUS/1eBnyIpgWp4zZe3GqYK7xENFuEFmIQ?=
 =?iso-8859-1?Q?XlqSV07MZpFvKSATjkO/1BgAc1/mwl2qgnE=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+07pQ7uBjSMcc8zkVmJ+rH1Iyb/NwzFLzGR6qxHTAU0igtp0miZUGQvus+?=
 =?iso-8859-1?Q?3m57WDZkScHKe8l/k5q17ryOilq27gy7Op3Mz3b0QT3Ogv7Wu95s3hGpQL?=
 =?iso-8859-1?Q?HNMQMaKt0d9AqKKY792uKkRHS2DK39LcAX88fux0GNmJck11tFkcLiTCS8?=
 =?iso-8859-1?Q?fw+Zmi0NlbyfrEJodEyi5yUrE71e3GzY060kc4ZVVFK5a7QJPaIKODfwMC?=
 =?iso-8859-1?Q?P+apAc+uwnQztTc/8nbB1C2K0ALAauMXzwbodfn0696DBFXR8oVyv6SPGv?=
 =?iso-8859-1?Q?XLXcsYuHYzAcqFaJqYFGateVmQ3HJPad/Ipz6RyTrTKuFFbI1//+UQaHtj?=
 =?iso-8859-1?Q?8e/fGAGIBqGstwjORB6G2pcLpuGcMrmrs1iV0eHFI4ZP+U6f728a8f2VTu?=
 =?iso-8859-1?Q?ECxLrRDBmFcqoDLa8iZ5B7cbMTgUy69y1HmcQozDmX7GqIJEM0xWZInSCf?=
 =?iso-8859-1?Q?Rxnx7GrrweiKkfOI8iVe00fNKicH/UcBUN0riluBej0758Nn1Avm6j3SBY?=
 =?iso-8859-1?Q?gK5v6aaMv135lsixxEumxrqIicT6Tf3qyx/Q6XwZsWqR1Ux+nA2nxj7Bux?=
 =?iso-8859-1?Q?dEkX8QZIGwX49YhhTi/b0xXKby22LF1OJJCux+7SWsxkhzjdPZCoAmGAjq?=
 =?iso-8859-1?Q?eCTf2lTSS1qn9EC21U8kyA9hSIXFHqYQVSRrZ3J6YrG8buGyHDlkpcDZCV?=
 =?iso-8859-1?Q?ZtwW0q6DVZiF35G1bVN2NFhRF0vcT2mfdxTl2tLDa80INM4B8Z1j1r8Mxe?=
 =?iso-8859-1?Q?B6gJ+bFnNI1iyI7FEYbKveJghJ7TsQIfefyIoHLHIE5sLqxAKy1ep7Gis2?=
 =?iso-8859-1?Q?tONDGQoavSxv2HtaMr+5J2Mt3lEc+izl79Q4aNKTA1hf858uuyXLAPeDTJ?=
 =?iso-8859-1?Q?I9+wbfH6jCo86ISXJckNRkPDzxapYkpfApEQCqEY7LWhxmY+PQgFJz26vZ?=
 =?iso-8859-1?Q?6VZgr4SmE3WjCCv7uGY5pj1XoIOE1cStbV/Zj5Lrh7I2tSBZ0TnE0cDeVX?=
 =?iso-8859-1?Q?Ia6zdvmqZMK0c0sI+n9M06afiRH+nCaYFiOjoWoSsqQUtffGP1O4FF8PEl?=
 =?iso-8859-1?Q?zIhbMCYt51MOQPEK9d+Hbr4LvV1AiiWVdtbZ1rvHOceS1UwL/2j5J9oyHZ?=
 =?iso-8859-1?Q?HH0hffgMVR7z4BKiuUJ39VJM/Tg/1Frc8xuIEhihSiJj4JnwAbQQj1A0uy?=
 =?iso-8859-1?Q?F7mcEMPCaHd/fwUo5FbuhZ/0MIy4gdZLccr1PF8tPHN6742CR639Nk/6HM?=
 =?iso-8859-1?Q?Hixs5tzWfPli/x8ZqiBDSIuhU7wbYUYfuxC5Sdfno+F/GYd+SDnQ0HJ+8s?=
 =?iso-8859-1?Q?AWKWxRxaLSmyG8DALMCEpC6mUv/PktjseujDP5i29NzdPLV47pYxeY42Hu?=
 =?iso-8859-1?Q?SpPzFUERYnauG4lrfGqQxdSeEXzNn2Q6o9dneh+V2mYXIt4S+zz+e21Rla?=
 =?iso-8859-1?Q?IKee2UqxIuU7iLhr?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR05MB3281.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e01db54b-07d7-4349-6fde-08df47a944c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:27:23.8017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

The synchronous SCSI BSG ioctl copies sense data and unmaps its user=0A=
data buffer while retaining the completed request. Copyback can fault=0A=
and need I/O from the same queue, which cannot progress when completed=0A=
requests retain the available tags.=0A=
=0A=
Fill the kernel-resident output fields and save the bounded sense data=0A=
before releasing the request. Perform both user copies afterward, using=0A=
the original BIO chain saved at mapping time. Preserve the copyback=0A=
error precedence established by commit a52f2ad45726 ("scsi: bsg: Report=0A=
synchronous data copyback failures").=0A=
=0A=
The SG_IO v4 implementation predates scsi-mq. The finite number of request=
=0A=
tags introduced by scsi-mq creates this dependency; moving the callback=0A=
into scsi_bsg.c did not change its ownership ordering.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
No functional changes from v4. Clarify the tag dependency and name the=0A=
existing copyback-error fix.=0A=
=0A=
 drivers/scsi/scsi_bsg.c | 23 +++++++++++++++--------=0A=
 1 file changed, 15 insertions(+), 8 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index 3cf1caad02f7..c17cad798326 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -207,6 +207,8 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, s=
truct sg_io_v4 *hdr,=0A=
 	struct scsi_cmnd *scmd;=0A=
 	struct request *rq;=0A=
 	struct bio *bio;=0A=
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];=0A=
+	unsigned int sense_len =3D 0;=0A=
 	int ret, unmap_ret;=0A=
 =0A=
 	if (hdr->protocol !=3D BSG_PROTOCOL_SCSI  ||=0A=
@@ -266,14 +268,9 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, =
struct sg_io_v4 *hdr,=0A=
 	hdr->response_len =3D 0;=0A=
 =0A=
 	if (scmd->sense_len && hdr->response) {=0A=
-		int len =3D min_t(unsigned int, hdr->max_response_len,=0A=
-				scmd->sense_len);=0A=
-=0A=
-		if (copy_to_user(uptr64(hdr->response), scmd->sense_buffer,=0A=
-				 len))=0A=
-			ret =3D -EFAULT;=0A=
-		else=0A=
-			hdr->response_len =3D len;=0A=
+		sense_len =3D min3(hdr->max_response_len, scmd->sense_len,=0A=
+				 sizeof(sense_buffer));=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
 	}=0A=
 =0A=
 	if (rq_data_dir(rq) =3D=3D READ)=0A=
@@ -281,9 +278,19 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, =
struct sg_io_v4 *hdr,=0A=
 	else=0A=
 		hdr->dout_resid =3D scmd->resid_len;=0A=
 =0A=
+	blk_mq_free_request(rq);=0A=
+=0A=
+	if (sense_len) {=0A=
+		if (copy_to_user(uptr64(hdr->response), sense_buffer, sense_len))=0A=
+			ret =3D -EFAULT;=0A=
+		else=0A=
+			hdr->response_len =3D sense_len;=0A=
+	}=0A=
+=0A=
 	unmap_ret =3D blk_rq_unmap_user(bio);=0A=
 	if (!ret)=0A=
 		ret =3D unmap_ret;=0A=
+	return ret;=0A=
 =0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
-- =0A=
2.43.0=0A=
=0A=
