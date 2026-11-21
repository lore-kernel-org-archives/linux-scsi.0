Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249639;
	b=UIr9Zg6E5GCHR3ZFSjD5LJBpnOK99IKYCZgM1E8iEAaZWEbIryXCRjm3GQo6qkCVwHbd
	 ocKkxzaYoVtCjwQi9RNtHngAEFKjd8e3n7aW06h91TA6ysVhoRmCa0igSUMMqry3WElNo
	 hQIhve/XfL/ALEeBNEnO4j/7NGzUu8vqFG2t7AShnkvWB8vhTTW30cBEVx2gwPyOMYQer
	 hAqpp1Y1AlzxteihH5h5gweKC8yYIX7qjD0EISoR9ZMHDOLM1mtaOmT9+BDkcOOpj6+ou
	 tWh4+sWmcP3kBNvgsanBtqHZx0VQBWFORnrIsbPPvuBWiDi3dSOFFAN2ijgV2qIV7eg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249639;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=74tOjCtKeIMxUASANk7BpPJNEAHM+qu0b6DHWwJuzDo=;
	b=4VheHiW/c59rAICTAhDZLvlQvDIJMgJL+t89oK/LugI/07FpPeeqGYr4W2gPr1a5RgrS
	 9m3cNE++21YdB8h6p1o3cT3k06+bAzMEg2OYSCKaCnjdpN+6g/aimAd1XLE+AGMR9MSCO
	 o8Z6uHmJPFcZL034Xz5ZnlEU9MqCIkQtrQyEMAXxpjwPxwYSd0urT7J9883ErmrPa5LMA
	 1m+Z7P0TI7YQ1tcea117xqLRK4e19qweZDWC32dSQG6BoMQf6LDsXJ/3ToX85U/mA2XAw
	 GXvEvFVJYxPXdpQVGzwrGJJN8xgp7VodR//T7yKO1AazhLLCVn/prL04BTOhzbZlhQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=rzCOrkFL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.3
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011003.outbound.protection.outlook.com [52.103.1.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1901A606A320;
	Sat, 21 Nov 2026 08:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1901A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=rzCOrkFL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CipgHFd2HWciOa9SgAmZuIzyxf1ddV5rzLQFdkhAK6otbLFSxJdc+keZc59y3+RVsk2NJLCfOXVSRyXbz8JAlQJXufpV+cHBIn2KJz7Jv2YGgEKUDjQYnMqoKmdxCrluSIew5MQjrhEHxdBFJDUZsS5l6xr0mz/V0B1CjbV9gFiCZ3ogcXFeC1oXXNrmsaXSnQygsvvCbLMc8ZkGwEw3vnupFQuhbB9tU8ZpgtLxEcauRwJg0lpcekNM140UqtzDadXoMTHS/dcFA9GzpT1+m/7qwGSb6fPherXHyWW6bhLEyFaMmxaRmZCeWkt55OByHRcq1rbWPqcDJbOybT4DAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=74tOjCtKeIMxUASANk7BpPJNEAHM+qu0b6DHWwJuzDo=;
 b=YbmidfrUUoKqS2kDf9t7N+8oerwYJFcgqgbxRyqqdHSrcp95lwN+vvgszIGdM6R7Ud29raT8XMGY0dzDto3Xg/KNUMtwelcKQiDSzrSw2ckSX1NjiGCfbsBE0wZEFohFmyAyz3DP7TYFTe0TvmkhhT/yUAxMEVXscKQpfcduQ8RLpPoDJxdOAYCc7CGXPYHWmmh1VLOYwem/Ptf1Li0A8jqgObEC5sZZMx5pd4BFZiqxbnv1CLKUj8nupa2ikXf/Y3PkAfljcaSrWhYlSyavu9iH4z2VujgZfJ0BozwqCpvfEcoEqheO5w7GxYKR+8Xa9TgQhzV/GgO2xwig/i6kJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74tOjCtKeIMxUASANk7BpPJNEAHM+qu0b6DHWwJuzDo=;
 b=rzCOrkFLia0Vt68fLyb/HEJHZEE0Z3sQLvswLGMdbReJ3vOjVdclIM9Z2vbQPE4uklADKFn+K+HuM7QV7Sbk//UhH2JTwDxccnnfRwyeGqp0Y+rXsktmSOonV44Q86k3tyDtkPu4OEFQqCe914Gv5+Q3rqfJ2ZuqFM03xNQm4ZKn4a/wTXoninBFu7sUbQ6hr/T05HxsQNVapmKLy4jGWeBBiGAOB0++s2nZpPfYajY7R35S9VIh/uvzzD1Y+GCadKgJzan5FWPiOr6wOmt/9hnWaf0GRvoTZQjOqdt7oGFRoYoxWLIhq80MoEgHk4/lD5qwB9CA4NvbjgLFfSpZkw==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:27:15 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:27:14 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v5 0/4] scsi: Release completed passthrough requests before
 user copyback
Thread-Topic: [PATCH v5 0/4] scsi: Release completed passthrough requests
 before user copyback
Thread-Index: AQHdeZIctKffuvl30UKRvR4GtWkG0w==
Date: Sat, 21 Nov 2026 08:27:14 +0000
Message-ID: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: e47694e4-fafc-4cae-981e-08df47a93f2f
x-ms-exchange-slblob-mailprops:
 a+H6FLLcF3oArmUeIqZHaFYD1WEyA+laWyW/SwYsakV56wbexpceh5i88rD2apyuChZelwN4MnqLpAfWwXiy8aA6U8uMQmNb1UqwfEbYgJsOcxV1wESkD4BPTiTYcLdITQA01JCOljuynv8KVsAabnfPX6Bha+GXXusbZz8Eosl9LflopaQmJkin50QV9spJNMrJusaIwHaKLJ7SY5Ruyv+ImUh8Irs7asPyp6dWEoM03iBMWLYTxrnkxaEdWCzvekXMfMmHf3dTGOUpJ5ImsYjmRc7Q0u6X8JrMLFiiWQXT9cfBmChteoHNbrmNQUaMVhDUOP41X4+UwLWSqVctSGqb/Ibj1zYPdKRR1Xcx5IdRN+h/ostd/MtDSoxvKBzRfc0WlmNMOuVA1jIRt2z0Y/C0YJ5v5+QBGQJ6lI/bA0xQyJPbRrtFwS5aPAPXoxx3MUuiMT/gBdSlm8/b+/XbXsWDM/IL+0MeuaaUNxGqAeKdWQQtN7yJr7wAoUusCh3e1YpR4LkZKCMK/BXv+Swo7XLVAxb44L1A8oTXDkeMQK7+PtgtxSqPaFwGazLuLXR4uatoFbstEPiQaWKhl/NHxklueDLtlz95YOSQes3MNVnZ+MP5UXC8XmMmPoP11uJe0C2vA/XnHd1pTrsJnD9aNIjTGER7Y4LsXycbrWLOJWHkICNgLs7janYL7IvlMd28wgqANXKSG8gE6kL5syOFde36rMakFb2HeyEIhTWibecy60e4XSFhkQgZ0xxaF2dOW4qDlEONYNIiPtHRYAv9lPRVw6s9rHZqnPskfbgOt3qGOumk35DbZRP4Izz+TuwW
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|5062599005|19110799012|4140399003|25010399006|8062599012|8060799015|24021099003|31061999003|440099028|3412199025|4302099013|102099032|1602099012|12091999003|10035399007|19061999003|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?p7OzDu51xLKjgZ6QnhUdiaaX6jih6ENIxO2Km4Vv/Hy2y7wQ58jE+QJ7o2?=
 =?iso-8859-1?Q?0kOb6hGFNvCJatte0Z+m95Wx0NAr2pUVk0EQ1ttYSt7hS3B1plCDHD24PU?=
 =?iso-8859-1?Q?wwlcd3YwfnGM5gogPbcxQpmooGbnKBMo2SV8m+8iU7yvv5mxexKlCepMLZ?=
 =?iso-8859-1?Q?CI9aow+aaK5LzixLWmZ/m0Jk47WNr+/cs0sNTF8GSiVSj+g476KTjfRGra?=
 =?iso-8859-1?Q?KZzMFmSCJmma8xwRc9XfBXo7mV3LVE+CGDBrSColNxBOHiR7zGCxOLSagt?=
 =?iso-8859-1?Q?M/7bcmhzT/f/yCNu8+EHuPdl2tvKGlSjhrLeu3WLrPI1Kliay16fQhsChz?=
 =?iso-8859-1?Q?h55Vyfn4z1P4P0yybHZLt1gAO/dh3s6SyrOMuJokTJeJFmcwTrDcnSsE7K?=
 =?iso-8859-1?Q?bm6b6DhAp5Pj2/ISiY7Olti+SVOzzHZGT50I6PAJ2kEAyeD8Xj46ESj5G8?=
 =?iso-8859-1?Q?2EpuAKsEX/TObTHCP5Y8u0T1aMq1qEx8X4H1s6hbYwN8CFWxixFtyTz9dP?=
 =?iso-8859-1?Q?ClSwhES1OJPgNxdqftsRQBYCetZa7HV9mjoS09VJkelJaHkDE10c3DuFkK?=
 =?iso-8859-1?Q?tzBBJr18u8Ykjp/ttYUGBGJTnLi2z5zyImiYmVznNq55Odjwh207jB8vaC?=
 =?iso-8859-1?Q?C0k//0XMPhAWKO0rehYVjdZuCyQhK7nqT6Oke8+xmenR0QjOX5txD7W2iV?=
 =?iso-8859-1?Q?PIImC0Q4IXq3cx/xTB5MYnvNEx/wA7kB2ntwJMnJ1e7cj9WTnKkE0uk0kg?=
 =?iso-8859-1?Q?q0ViHSpxDYtZvJU0pZg2tet1G4YdU61WNefej3tcKTWLY8A1SNLvBcieN0?=
 =?iso-8859-1?Q?TRxTYw3ZV+xFLBdiyfX59QC0kkD43JADrkoMlIm352qqf8831WJw8Jgox4?=
 =?iso-8859-1?Q?CWQssJ25ajrplS0olYgnh2RvU+pAG7YGXBS3vIbe57kvEzu9TKiWNkWyeG?=
 =?iso-8859-1?Q?Ba2P9h7buzcjBMObnnkmbGb9eawqvj8cFRAboiyjoDCaGNXnttT3cJkrki?=
 =?iso-8859-1?Q?UrLAZyKNwzWhRnTujW4AwF6mzpC01IfoOqkYGlSLmkViVDhTkIElvUFmgU?=
 =?iso-8859-1?Q?QdMnDaJL/a+im6DTXLf5FOCHdRfUEnmCta9UdNavy/ILLK5BnDb8eH5TP0?=
 =?iso-8859-1?Q?/1VEPXMMgU9KvVUSsSU1u1aEYagRmbYCrPaORoCqlc+H50fS1EYyRhTdCH?=
 =?iso-8859-1?Q?MBKEhkVsfDai04sfvynut4P01NbyaEIiHKTza2UuOja/8TKYwDQlETA8ta?=
 =?iso-8859-1?Q?53+KHJbWrXoZDwbRacNxo2vpSzcmHho6Xg25WY+94=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?TN1BkigcqWrcpp5qh9K/mqs47I322nrfMwPR2bwJ31lmFwl2L2x2UHjgpR?=
 =?iso-8859-1?Q?b0j3+GLchHtXQE32NZqxFL+hqOS3bZCSRdFst++7GwSPTyCN2wA1a2i1Ya?=
 =?iso-8859-1?Q?HUUrEcMwBw4APwOyyUToJD8xu2kuVetRSSAyBgPh+LcGYzoK64VAlx+IWA?=
 =?iso-8859-1?Q?v7M3f8RNjmx/8exclSKUs1t0svj1v0TeqsKgUO/5BV8GlJFkJCDnRvYYm9?=
 =?iso-8859-1?Q?9bx1QO15kc88jghhP9KuKMG1m5ixjEoYJexgKjevwljqsnu2qbi0pMgOJz?=
 =?iso-8859-1?Q?fiUP1XEqIxESS4Sn1VlVCrTaL/lMgAM8vwsvb5LfhOkMlqNuFTgdtGb0c0?=
 =?iso-8859-1?Q?2L0xJN8BT3txKrF2Dr0eFoTs+3D3OxCTO8WthTp3pBzzgJKty3yzkmvrSF?=
 =?iso-8859-1?Q?tskV+S9YvTFhDZtBlQMGB7kwRyZssgyWCbpGG5jK6Mzw8hyHdn5Wq9m78c?=
 =?iso-8859-1?Q?K0F48hcPdaSBauC+yu5a/B3spTabfQZ9yfXnJ1lWZRNR5DyO7pUG1QB+Tn?=
 =?iso-8859-1?Q?tCV5GoAHD2iVgtWn6Aqfxqi+nD1EfdVZ8G2q2xV2QXqAGhjnGLHKVNFSbZ?=
 =?iso-8859-1?Q?Zg94MtnRRiAjD8/RMfYQu0UEVVKZuoOQwDfjCdX/gYctYR8QggtL8e7vz4?=
 =?iso-8859-1?Q?HJzf979wdSVYD3W5Jz9WFU2VFIyFhlB4SHWmxYaCQowb8oSI4PHp2yaN44?=
 =?iso-8859-1?Q?yNTDkZy9ICtb7eXh66yO3rfQxd7cPkqz5mxaB0n0buqCnTa2bjpSD+bian?=
 =?iso-8859-1?Q?JoEKy2yTLWXoOxWyP2pyqS5Alkzppcrw7ZAPCnQMNx1bCL+iBDeFO2M7Wb?=
 =?iso-8859-1?Q?Opy2b9b5ZM6ff7GTRxcBYEjngNZiytm2tnJ9nXXN3esvXzQiVO9cEiPlSd?=
 =?iso-8859-1?Q?+X5S4NbA9xylaQJtzY5TxQ0FCYQLPrBhtpF0Z0RIitK0WZoiVSDOev0YbZ?=
 =?iso-8859-1?Q?baMFNwosNhoPGxkuH8c/jDRbEjAiHJgoEzYUBuGS63nRgmeQeE04dm7kjR?=
 =?iso-8859-1?Q?csTXopeFHhU9S1kLlHv5bPD+xzhSK4MfCwmumpJW+aEWjmJf+xQqRN1bGS?=
 =?iso-8859-1?Q?Fyn5zo5XnAU2+qGBKXrC1DGimODlP8hqrjuHUuD16kFhkFWFspBcg8f4sG?=
 =?iso-8859-1?Q?1M9KtnZuA70DZE/VSMgNcoFwmoK6CwIAkSTaSNOMIYj5fBRp1fHZLMq7De?=
 =?iso-8859-1?Q?ANqf9fklVTgXrHOwzVBCWcFgV628LkJp1RjMVyuF/Z3kTV8+QDI4L0Ytjg?=
 =?iso-8859-1?Q?Zyblt6+uywLNuiFm06qAfA8MkpfAwXje4uT4PiD0TXOmuP9LqrCw2uZKZq?=
 =?iso-8859-1?Q?jHJmO5IGiOqDUmwPyayQfWjffaoZBqkRrFjUHtqgyYbdchspT491MM1sBU?=
 =?iso-8859-1?Q?nwluhRKo2k3N5n8pAC7ueRNC41s/5mnGFdfm3yTw8Ze+2D0ucmJVvZOweE?=
 =?iso-8859-1?Q?nOZ5DoMHoVO+k6Xk?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e47694e4-fafc-4cae-981e-08df47a93f2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:27:14.4604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

Four synchronous SCSI passthrough paths copy data to userspace, or unmap=0A=
a user buffer that needs copyback, while they still hold the completed=0A=
request. If that access faults and needs I/O from the same queue, the=0A=
task can wait for a tag held by the request it would release only after=0A=
the fault returns.=0A=
=0A=
Each patch saves the completion state needed for copyback, releases the=0A=
request, then performs the user access:=0A=
=0A=
  1/4  SG_IO on a SCSI block device=0A=
  2/4  the legacy SCSI_IOCTL_SEND_COMMAND ioctl=0A=
  3/4  CDROMREADAUDIO through sr_read_cdda_bpc()=0A=
  4/4  the synchronous BSG ioctl=0A=
=0A=
This series addresses the completion side only. As Bart pointed out,=0A=
these paths also access user memory after allocating a request and=0A=
before submitting it. Without an I/O scheduler, that request already=0A=
holds a driver tag, so a fault needing I/O from the same exhausted tag=0A=
pool can encounter a similar dependency. The submission-side ordering=0A=
is unchanged here.=0A=
=0A=
Moving CDB copies before request allocation would not address faults=0A=
in blk_rq_map_user*(), which needs an allocated request. Addressing=0A=
that dependency requires a different approach and is outside this=0A=
series.=0A=
=0A=
Changes in v5:=0A=
- Document that scsi_complete_sghdr_rq() frees its request, as requested=0A=
  by Bart Van Assche.=0A=
- Set rq to NULL after the legacy ioctl's early free and use conditional=0A=
  cleanup, removing the extra success-path goto, as suggested by Bart.=0A=
- Clarify the completion-side scope and tag dependency. Patches 3 and 4=0A=
  have no functional changes.=0A=
=0A=
Tested on 9f9e0b1e5399 with QEMU, a virtio-scsi disk and CD-ROM,=0A=
KASAN and lockdep. The base and v5 each passed 960 regression checks,=0A=
including 220 synchronous checks. Tracing covered 100 synchronous=0A=
windows: 80 showed v5 releasing the request before unmapping, while=0A=
the base retained it; 20 checked legacy ioctl execution and release.=0A=
CDDA coverage exercised EIO and release ordering, not successful audio=0A=
extraction. The unchanged io_uring path still retained its request=0A=
until task work, as expected. No page-fault deadlock was reproduced.=0A=
=0A=
Each patch passed an x86_64 W=3D1 build of the affected objects. Kernel=0A=
selftests were not run.=0A=
=0A=
The BSG io_uring completion fix remains a separate two-patch series,=0A=
which applies on top of these four patches.=0A=
=0A=
v4: https://lore.kernel.org/r/cover.1794990780.git.x-professor@outlook.com=
=0A=
RFC v3: https://lore.kernel.org/r/cover.1794045010.git.x-professor@outlook.=
com=0A=
Bart's scope question:=0A=
https://lore.kernel.org/r/3dcb1a44-6e99-4d34-9b49-675d98c90da1@acm.org=0A=
=0A=
Yingjie Wang (4):=0A=
  scsi: core: Release SG_IO request before user copyback=0A=
  scsi: core: Release legacy ioctl request before user copyback=0A=
  scsi: sr: Release CDDA request before user copyback=0A=
  scsi: bsg: Release synchronous request before user copyback=0A=
=0A=
 drivers/scsi/scsi_bsg.c   | 23 ++++++++++++++--------=0A=
 drivers/scsi/scsi_ioctl.c | 41 ++++++++++++++++++++++++++++-----------=0A=
 drivers/scsi/sr.c         |  3 +++=0A=
 3 files changed, 48 insertions(+), 19 deletions(-)=0A=
=0A=
=0A=
base-commit: 9f9e0b1e5399045982788a954d3461de894e40c7=0A=
-- =0A=
2.43.0=0A=
=0A=
