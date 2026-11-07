Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794045061;
	b=5bV5RP8OdoRgF4JJzUr7mP3FH5VtItFVjkXV6IxQPbgMSYXMu3A/cfyu4SY+WUP17bj2
	 A9w+Z6EbtL2++jqU6+K9cU0xH2d+KzCSTLVIF75Gm91m/O1D41nFEWEL6dM0wC2ti0qD2
	 DJiaJrB/L5nVVCc1hmfotPAlbdj64f4KqipZkAR31uOv5hJ5S0uWGdXP7BH0DrFdoHDsN
	 llU0/eQ7lkLKuRai+AUG41J5mZGAqtnU0IhAQ4+HVA/UkxIHPr3vHqEt5iRGbRbecczmX
	 S6tw2QvulGB5B4hAhNH1vBE/3q1xndCeW6u8PSf5U+gvKslwMEYdrL+DO0Mr3Mxiccg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045061;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
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
	bh=oRRJj4TBZq42b4s1938hetFBMCUni4396BJKC/dt5V8=;
	b=L86I2qxtLswxdBRJsftGRw8Nx7Pd6oCSghAnVyHjek51V2nec6t2OTZqfCgOqFuoLVMb
	 a3Xb4F7V68X8fXaGlzp73u/tz0VhuKleA/GVtkddj8CNdHzqQypz9dPC7wLodE5t6eZDr
	 aQcQYSQ8WcXQjWvRQqMkaHd4+ochfgVq/NpZqmZ4fFjxn7G+TzMbhVGyO6UZM1qCaiQlu
	 TIKys+8G4DmtiTwrCjV4vF7ceAsgwXypuOWFxcNDsTjScdbV3rywAJR5hPXC6+mjxqqt4
	 xOEoYU3tHbhqAIsk3pJmBcbb2/CRpuJljLrvrT36A5BeftiKQY///8t8u+xX/CHR1ww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=p7u0qiwq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.32
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazolkn19011032.outbound.protection.outlook.com [52.103.13.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A3A606A32D;
	Sat,  7 Nov 2026 09:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1A3A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=p7u0qiwq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqgZeLGlnFrZGMVslPAnhGXmBjn1d/hHVarMO3Z1GnEoEBTJSa/stBNjI21S2kisPWnIyPjso5THb9aPfP9qUHO3RWHOrMxEhnRO/hdFaYfLXQxzgvV+Uc+V/r7mNz9WGKetkIpMjRznHhWSPoyZNTaw46/FPG5YZbtf28oe0Xxrcq6JReiC4I3TcILIFK8QJFo2tIXhjgnExT2cPn2JYZYVP+hW232OqoPtbI1LuW8+vzWUL9Pvq1ZP1gy054f46qGatki2DaLSgCVdEw3OW6D4p81OjIg9T7XwkU2cESGYc4m/kdwVOqR8degmAh2n9z2DudS4SNKk2NR9seXhGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=oRRJj4TBZq42b4s1938hetFBMCUni4396BJKC/dt5V8=;
 b=x10VIE7Iwrzn49pCMxQgO53Rc4Wsw/OcP+YftlBvp+/2J55PgOcpitrlzx2ItKxYa9WKpA02ERH2HcG0lEGCS/EJ/rDNyX7gMpUMSK9W9uOxd+9jpUGNfDW8Zr+xXva64+JeTAl03V5Vf24UesJmG58n+mA2tIyPmMt6tvk78Nu9ptqTpABCqMUyc0WEk3BFkuFHeMuZPAEQcZjLTpuilI/wfmSdxeggox4o6Mgy443lnH3H982D7TCSQMr3jQBx3T8B7s9avUEbznWBvhuCgH6nPrf+0uCGpWNiDLNj2eieuepl6rmNl+6d8miXSumnRIEddN55J7aISk+vcEIL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRRJj4TBZq42b4s1938hetFBMCUni4396BJKC/dt5V8=;
 b=p7u0qiwqjNSJIqsj+KnLr+Y/jbD/rWh8NU+uugmtZEuDUSmNt6V6SBpeoPQWfdjXNhd+n77B9pop8BomEy8gmOBiMpAYZWsRNRkAhT6iFwH8dVspC5k163/FejzoPaScY12XiOfhtexQ73rql8+9OCqx+1rCIRm+ya9Zoethq7NIebmmr40SwTEGpCOgtTNBj9ZMjQ/bRE4BmFcmGoyQCW3U9mk63PBEc4d1qHshIiQk7Vn/36s7w1unm6bYXaY2130KdvrpFZf+UeFrEYNzIFQpmGlgaMkkKzK2zwV5E75vMv9w5myzqKAw8JrqPwIOWrH8OO+Fg/KeV36KBUuLRg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SA6PR05MB10700.namprd05.prod.outlook.com
 (2603:10b6:806:409::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 09:50:26 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0592.010; Sat, 7 Nov 2026
 09:50:26 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
CC: Yingjie Wang <x-professor@outlook.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, Yang
 Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>, Pavel
 Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 2/6] scsi: core: release legacy ioctl request before
 user copyback
Thread-Topic: [RFC PATCH v3 2/6] scsi: core: release legacy ioctl request
 before user copyback
Thread-Index: AQHdbp1pRh19jG/BgU2WpjwRSLwEDw==
Date: Sat, 7 Nov 2026 09:50:25 +0000
Message-ID:
 <82b83de378231fc4c5504758d1d3a981106ef900.1794045010.git.x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com>
In-Reply-To: <cover.1794045010.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA6PR05MB10700:EE_
x-ms-office365-filtering-correlation-id: bffc61e0-6009-46bf-65b5-08df3cb48d13
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|19110799012|24021099003|41001999006|31061999003|22091999003|24121999003|15080799012|8062599012|38102599003|4140399003|25010399006|16041099003|10035399007|12091999003|1602099012|40105399003|53005399003|102099032|3412199025|440099028|4302099013|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?WDF5cWgzWG15QWNlT1FIU0U3SFgvdUJNMXJUb2lRNWJjV3VMYnYrNmtoZ3J2?=
 =?utf-8?B?ZUNrNkJOY1Z3TGVwcDNaNkhNZWc2S2pTOVpvb1FKQm4ybmZKNEFDQkU0Vlpq?=
 =?utf-8?B?aTBTZ05QT0xST0x5VXN0NURYVmN4b3JiSmZ0ZlozajFkYTZ6aXozZnlNbE9U?=
 =?utf-8?B?TDhMdk43M01vTytTTkxsb056RTBtMnBjQzBweVhGZmtqOFBJbDE5cU91S0R5?=
 =?utf-8?B?MDU1YjdncXc1Zmt0Q0Z2aWIzZlpVUEFESjdXOTZGTHlhdlZZL1I1MHBoNmtZ?=
 =?utf-8?B?R1RYbFRacmNXVExISVdDNnBqb2dkMEtOTmpBZTR6VllZM2M5b1JRNk9GL0pF?=
 =?utf-8?B?VDF0OTVMYWdoVmtJU0hPc1BXUHRiaW9TODM2dXZqUFNHMlNUa2xKN1ozTm9w?=
 =?utf-8?B?cUc4bDk3Z1Q5TW9WWTVwZmNvc0FUS2RnWXVrMldURjJXUmNFZzJSWXpVNm5v?=
 =?utf-8?B?UzkvTitNSXFXcXk5TUNFdjRmRExaRnNTMk03ZkRsTFBJdWpDWGE0WWhFSU42?=
 =?utf-8?B?bitiMnoxOUpoOWgwMy9DUW54WnlHaG9lMyt0ZHdaZmluSWF2WWtoT1A4YmEr?=
 =?utf-8?B?V2Q2VmJUcjBWZlFnTHdidjZoWk9XRDhGSkJqTDVIMy9jY2xFSHlIeStlRm5n?=
 =?utf-8?B?bnlTWVpIaE85azdNKzFGRHdHWG9XTEhOM3F2d3dGTURpSUZ0SGY1dzJrb0V6?=
 =?utf-8?B?SXkwTTAyQnlyNU52Y2tlN1lRRFRFWFZ0dng5NEwwTVhpeUMway9sbEUvQmtT?=
 =?utf-8?B?Z1IyZVErM3VHVjZIMWt4VGFjdU04T1ZVSGFVZWdwMm9YenZiZmRUc0dFK3pw?=
 =?utf-8?B?dERWUXFOanpsTnZaYzc4SlZ5Skh3bU9XU2tib2ZYUjNZOEdyUm0wenM1VWVo?=
 =?utf-8?B?MVI4Y0NKb1Z0ZUp3S00rRng4ZkN0dkhyNzhNN0JBejlaM3lJaUY0UjR4Rm5C?=
 =?utf-8?B?L0tyTHF4NE9WR21GSmxuNXVZbkFtZjVLaFRhVmxka21iZm1wN1F6OEJtZjg5?=
 =?utf-8?B?UmNGVm1NcjlNK3BuREMzdmo4R05QbzZnU0NQeitFcW9HdEprYktCNWd0L1BN?=
 =?utf-8?B?WFczUmprZ3VyOEtUc3pLZGpMYTNMcWhLWTRUcC9lL0I3aTRwdjdacUpvQTN2?=
 =?utf-8?B?TlRBQ0s5OExZdnB0M3B0dGpUVm5nYnZwemN1Q3h0a3czeUNQbXV3NjJvRUt0?=
 =?utf-8?B?dEplZjdQdk1IaU9sdU5VZlA3dlh4NHU0SnFzYmUzMTRsSHljUXdtdmlmMjVl?=
 =?utf-8?B?MHFsWnp2WkdvM3pvZ2JobUJjL09SdTh1YmUxVVl4VlZzVU95UWZYSDJjRjl5?=
 =?utf-8?B?R2xMS3Z4R3Fyb3RQWlRxWHZYTU85OC9XUlIyM3VxcTk2d2ZxdDhyVlh2VDZJ?=
 =?utf-8?B?SHZ4T21VTTB6UXZkNUMyb05laUxuR2xWckh3RHlpSkhLRmdzekpzWVk0RDBJ?=
 =?utf-8?B?dXY3dTA1RE44MmVhdHFFbW5QamIyMWUzWDJPS3dZL1kvVkpvVWRHeXN6OWpz?=
 =?utf-8?B?TmpHUEVzWi9yY2FsYU9rc2ZOK1h5WFpBRk9OVTVoTDVHdXRkaytKdUpEeS9i?=
 =?utf-8?B?bzl2YTg1TXJ6QWdyM1BRaVpvUHJNNDRWeitUTWxHM2NKTmhBcm56YUpNbHZC?=
 =?utf-8?Q?a9KLWW49denZlwoQIkIGD7s3yEmlXIBzMDFbC6k4cv5c=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aFYvZFN6czFrTW4rdmw0VzNhcTVNM2hBeWNyRVgzc1E0WDR4aHJVL2M5azFL?=
 =?utf-8?B?SUhVazlUZEtWREtuV2JBSHdHZFh4UDZqSEdzYjNGdVB2RkdtSHNvY2xNTkl6?=
 =?utf-8?B?Y0t5WkNDallHbHp6Snp3SDNHZEZFMUZwUG93NG5GakZIRG9NWTNjU3d3aTZR?=
 =?utf-8?B?QXNacWlaUm1MMkJFaXVxYTIzaFpEMFljUVYrOGlkQml3VlRBdm5Cci81bHl0?=
 =?utf-8?B?Uk5xYkFKL2dtbVVBV1B4cnlyKzUvZWlZWm1vQ1p4QXN2YnpqY2wvM2loaWo2?=
 =?utf-8?B?WkJoOVBTeE9VMnhqMnIvYVJGSFA0SXh2d2lNYWhqU2Q4S0tHaXFYQUZXMVpr?=
 =?utf-8?B?T3NIb29PMGg5KzQxR2N0L0Nua24zSENSTWUycmFvKzllWnBsSFdLaldPWWlG?=
 =?utf-8?B?TTF3cmVicUJOMnh3Y2xuTkxnZXBVQ2RlY2MvaWVWME9JVHdSc0hRRm45bGg3?=
 =?utf-8?B?ZHJPYU5XRy8wOGttb1l0bnNYSFNWdXYzSlA5Y01IbGxnbWFKSE55MUhtbjFF?=
 =?utf-8?B?Wkd6SWxLOFh0b2p3SjVPQ3hub2RSV1U5aDV0eEhCZW1GQlJIMFVGS28rVWZo?=
 =?utf-8?B?d2xkS2tzTG9FaHpWQk5DWFRLNHlaMmFUUW1PZkR5MzQrRU4zbjEva280b0Zl?=
 =?utf-8?B?a2ZSSGxEVVRuVUVKdW1GbElYS0VXU05PeTBhVHBIZ2NJVUNpd1ZmbkhHMHRt?=
 =?utf-8?B?bDhzWVZLUUJNT2VYc0RuRnh4RUE1YzY3RE9zMjBCdHNoN0k3aWQwcHU1aW1F?=
 =?utf-8?B?dU5VMjRLSWkrb3F3SDUrVHMxMEtLOFNsVDM2bnJnOHVUQ2ZHNXp0WEJHNVd6?=
 =?utf-8?B?d25ZSUllbHIyRmlaNk9QN2dIUlNLNUtLSUFMOFlSL1dXVm15WnpzS3VUZ0du?=
 =?utf-8?B?d2VZSnBSa0lLUnV0Vi9lT2trcUgyTThpb2ZhZUxoZkhDbkRkdlF1RFRHbU0r?=
 =?utf-8?B?K1g2N0NOazVoUUgza2hHcVNQWU5jMHQ5ZGdEZ24rSTMxbDZWVG1mbXV3bWhv?=
 =?utf-8?B?L0JhRUc1TXpvL3l1S2M4UG8wSlVYb01nNmY3Mm1icDlFYWliem1pZU5BSVNG?=
 =?utf-8?B?S0hBU0E4c2kxV1pkdjRIeHdCa29pckNkM1dwTlNBWmNkSnBzQUZ4a1RycWlO?=
 =?utf-8?B?c2tFZ0FURnQrTW9IUElhUmFyWjZMNkx6SDZ6cnJTZ1c4bEQ5Nkkwd2p3bWJ0?=
 =?utf-8?B?Z0xCVFdZWVF2WVFoeGdiSTJJMlh4VGZpc3FtWEdDdndzZFc0SW52UTg4dzQx?=
 =?utf-8?B?aDFwdTc3V0p5cFlaMzBTYjY0a1JvSHVzZDZiOXY5cjQ3dFBqcWJSdnM3SlZw?=
 =?utf-8?B?S0RFTkdwekw5N0hXS2FKWlFla3IrNmJwMnc1Q0hDak95b1Nsays5aEE0eVFI?=
 =?utf-8?B?d2E3NXdqZXNzTGVvTXREOURld0xHRjBVdm9OUDU5YTV1NVczdndCL0orcm12?=
 =?utf-8?B?RW02U0xDa2pyU0xOSlBNV3FCd3VLczk3cFpxbHFJMnIxa3JzUmJWNDZYcWhX?=
 =?utf-8?B?YWExSzVNZ1ArYUU3NW9wL1AyYVdVK2VmVHB1dXNGZGVSMkNhaGRmUkhJbXRF?=
 =?utf-8?B?Mm44eXYrNkxiNDB2QmVkamthTE9CajFFdDRqRUsxcFNUUXdMakkxT1dTSnVt?=
 =?utf-8?B?YW4yeHBJbG5HRzYwWkdBR0JnQTNRUFlXV2E2QXF0cTR6SUNyOHJyWkltdjZh?=
 =?utf-8?B?eTBXVGk2UCtnOFFMZms3bGhGRTVncXBsSzVCNFd1OFZhUURCd050Y1Bqb29T?=
 =?utf-8?B?SmJERzVtM3JWQmlUMmsvQVQzYjhMVHNmOGd5SHlRV2h1Z3JobThMTlhMYUpG?=
 =?utf-8?B?OEFKNjltckZlYTNpenlMNTk1Mmc0YUZKeVhuaVJMeHc1bmJnWkd4TmlEbmdB?=
 =?utf-8?Q?OD4tVhAWLIAqo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
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
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: bffc61e0-6009-46bf-65b5-08df3cb48d13
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2026 09:50:25.1898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR05MB10700

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KClNDU0lfSU9DVExf
U0VORF9DT01NQU5EIGNvcGllcyBzZW5zZSBvciBjb21tYW5kIGRhdGEgdG8gdXNlcnNwYWNlIHdo
aWxlCnRoZSBjb21wbGV0ZWQgcmVxdWVzdCBzdGlsbCBvY2N1cGllcyBpdHMgcXVldWUgdGFnLiBB
IGZhdWx0IHRoYXQgbmVlZHMKdGhlIHNhbWUgcXVldWUgY2FuIHRoZXJlZm9yZSB3YWl0IGZvciBh
IHJlc291cmNlIGhlbGQgYnkgdGhlIGlvY3RsLgoKU2F2ZSB0aGUgY29tbWFuZCBzdGF0dXMgYW5k
IHRoZSBjb21wYXRpYmlsaXR5LWxpbWl0ZWQgc2Vuc2UgZGF0YSwgdGhlbgpyZWxlYXNlIHRoZSBy
ZXF1ZXN0IGJlZm9yZSBjb3B5aW5nIHRvIHVzZXJzcGFjZS4gVGhlIGRhdGEgYnVmZmVyIGlzIGEK
c2VwYXJhdGUgYWxsb2NhdGlvbiBhbmQgcmVtYWlucyB2YWxpZCB1bnRpbCB0aGUgZXhpc3Rpbmcg
YnVmZmVyIGNsZWFudXAuCktlZXAgdGhlIHBvc2l0aXZlIFNDU0kgc3RhdHVzIGFuZCAtRUZBVUxU
IHJldHVybiBjb252ZW50aW9ucyB1bmNoYW5nZWQuCgpUaGlzIGNvbXBsZW1lbnRzIHRoZSBTR19J
TyBmaXggYnkgY292ZXJpbmcgdGhlIGxlZ2FjeQpTQ1NJX0lPQ1RMX1NFTkRfQ09NTUFORCBwYXRo
LgoKRml4ZXM6IGQyODUyMDNjZjY0NyAoInNjc2k6IGFkZCBzdXBwb3J0IGZvciBhIGJsay1tcSBi
YXNlZCBJL08gcGF0aC4iKQpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMDIy
LnNjc2ktY29weWJhY2stcmV2aWV3LjMxYjhkNmE3MGY0Y0BvdXRsb29rLmNvbQpDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHgtcHJvZmVzc29y
QG91dGxvb2suY29tPgotLS0KIGRyaXZlcnMvc2NzaS9zY3NpX2lvY3RsLmMgfCAxOCArKysrKysr
KysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2lvY3RsLmMgYi9kcml2ZXJzL3Nj
c2kvc2NzaV9pb2N0bC5jCmluZGV4IGI1ODhhYTkwNTllMy4uNGY5NzUxNmM3OTVjIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5jCisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2lv
Y3RsLmMKQEAgLTUzOCw2ICs1MzgsOCBAQCBzdGF0aWMgaW50IHNnX3Njc2lfaW9jdGwoc3RydWN0
IHJlcXVlc3RfcXVldWUgKnEsIGJvb2wgb3Blbl9mb3Jfd3JpdGUsCiAJCXN0cnVjdCBzY3NpX2lv
Y3RsX2NvbW1hbmQgX191c2VyICpzaWMpCiB7CiAJc3RydWN0IHJlcXVlc3QgKnJxOworCXU4IHNl
bnNlX2J1ZmZlclsxNl07CisJdW5zaWduZWQgaW50IHNlbnNlX2xlbiA9IDA7CiAJaW50IGVycjsK
IAl1bnNpZ25lZCBpbnQgaW5fbGVuLCBvdXRfbGVuLCBieXRlcywgb3Bjb2RlLCBjbWRsZW47CiAJ
c3RydWN0IHNjc2lfY21uZCAqc2NtZDsKQEAgLTYyNiwxNyArNjI4LDIxIEBAIHN0YXRpYyBpbnQg
c2dfc2NzaV9pb2N0bChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgYm9vbCBvcGVuX2Zvcl93cml0
ZSwKIAlibGtfZXhlY3V0ZV9ycShycSwgZmFsc2UpOwogCiAJZXJyID0gc2NtZC0+cmVzdWx0ICYg
MHhmZjsJLyogb25seSA4IGJpdCBTQ1NJIHN0YXR1cyAqLworCWlmIChlcnIgJiYgc2NtZC0+c2Vu
c2VfbGVuICYmIHNjbWQtPnNlbnNlX2J1ZmZlcikgeworCQkvKiBsaW1pdCBzZW5zZSBsZW4gZm9y
IGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgKi8KKwkJc2Vuc2VfbGVuID0gbWluKHNjbWQtPnNlbnNl
X2xlbiwgc2l6ZW9mKHNlbnNlX2J1ZmZlcikpOworCQltZW1jcHkoc2Vuc2VfYnVmZmVyLCBzY21k
LT5zZW5zZV9idWZmZXIsIHNlbnNlX2xlbik7CisJfQorCWJsa19tcV9mcmVlX3JlcXVlc3QocnEp
OworCiAJaWYgKGVycikgewotCQlpZiAoc2NtZC0+c2Vuc2VfbGVuICYmIHNjbWQtPnNlbnNlX2J1
ZmZlcikgewotCQkJLyogbGltaXQgc2Vuc2UgbGVuIGZvciBiYWNrd2FyZCBjb21wYXRpYmlsaXR5
ICovCi0JCQlpZiAoY29weV90b191c2VyKHNpYy0+ZGF0YSwgc2NtZC0+c2Vuc2VfYnVmZmVyLAot
CQkJCQkgbWluKHNjbWQtPnNlbnNlX2xlbiwgMTZVKSkpCi0JCQkJZXJyID0gLUVGQVVMVDsKLQkJ
fQorCQlpZiAoc2Vuc2VfbGVuICYmIGNvcHlfdG9fdXNlcihzaWMtPmRhdGEsIHNlbnNlX2J1ZmZl
ciwgc2Vuc2VfbGVuKSkKKwkJCWVyciA9IC1FRkFVTFQ7CiAJfSBlbHNlIHsKIAkJaWYgKGNvcHlf
dG9fdXNlcihzaWMtPmRhdGEsIGJ1ZmZlciwgb3V0X2xlbikpCiAJCQllcnIgPSAtRUZBVUxUOwog
CX0KKwlnb3RvIGVycm9yX2ZyZWVfYnVmZmVyOwogCiBlcnJvcjoKIAlibGtfbXFfZnJlZV9yZXF1
ZXN0KHJxKTsKLS0gCjIuNDMuMAoK
