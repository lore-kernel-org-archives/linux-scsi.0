Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793291972;
	b=LX2RDJe5x95symyHvk1AjSdZkk5/VfKct/hNO1vGj6FQQtubVGv62upIkxcrvNIyenmP
	 pxUXSOs2/46Rze9ZZpgwnafoU5KkiOkuaZn7I360IZUFPeFZLJ285eChqCafvggIhcEXy
	 ltB08tIq2NO0bf5gMCNRiqiIliyMpj+16GA0C7kz3ixLC9Sa1dkkhrrTbDfcE1VWpdtIy
	 RGtoCSqWWtTK/9Rrx2K4/RhlVTx75dxyWIFm8H6FYR9sllD2Qc80QSQ3E/D2OZvYhQz2x
	 Uly1KTDQ6W7AnQGcYBAp0c+Eh0QwyIh3zfc4/Aov4dVq9/oMjMMXbdE+hVe2uOf0xRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291972;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=51uAHD964PNpqQsBGeHpyNzRygYccfzJj5XyKo8ToPU=;
	b=Dk8gLufvaddcf48CHGCqD8StykNHuOtl/AV5F8RoMlFSnyDCx91shJt797PkCfzwgOon
	 m5/aa9NE16Uxeqw0ocpnpJrqd7NwO2s7vaQj0rPyxcd3D4LFSIO7uyXNrf5NNfF37up9K
	 Zsf6bN4rxx93Et0f+Bx72wmG+1nS3X5z3tOJ/eNjChVDDU9NzENDVPlnOK9SY7KiR3uG9
	 GINNCxXcXvNPpd/qLb2wXpRiJyOz2pgGNBg4dIhVvuULlxwatuibGUQHUGS51Z+L/2R21
	 EQ9/1orkYfMUzTZ6KEZBJftLSYrI+yueMaqZur5xt+pL8ZJaa6yF4ZPAzT24KbICVWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=JnnoR1kS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.95
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013095.outbound.protection.outlook.com [52.103.20.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F79606A31E;
	Thu, 29 Oct 2026 16:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11F79606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=JnnoR1kS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YR6UeGl9YygRH23c/tUHUCgpQ6pQK9EdSkemzcUOMfYGwTAnj01jyRONH/tC2VlrnTndZDw4EvzWsN99QYVJGOwyFwwf/EGeixSoE2D02ZhWizHvyWw+MXMr40QNIGjIOwZf7BttxIIA/eJQCtzyNXvM7R5pskAq17bBhLQKoh3XXR6thy/yGfKe/2jsWS6tSh7KEKSGSZ4USMNWRy4df8i7rksByprwXF8ukBN/23gzD55LXLQpCjP4DziV9++X0JpkYY0gP4oQoP3fwjl9BZfiDsy2Rfd/fi8wLA6JnERQcXr/lSwtnpCxeVStS8o4ZB7jael8dkIWjzV6lqdNJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=51uAHD964PNpqQsBGeHpyNzRygYccfzJj5XyKo8ToPU=;
 b=gKgWz+I2Dep1NcBX+fIuxToes/JVo8B8qUmdZTmnuOG/rLTTEGiDqEIyZKxGyHQ+8K+5l5rkuASsWuiN3+kc2ESXOM2uiUD1rD529BpxuzmONKWNdLVrYcYDziXWZWan35guDLOzM2BqkKXHoZz3ZwbP/lvHoZMVqkCsYDQYNkfId5wY9O6l002oOYE4i2KVPr4aYRdDzLRH0tT6lIRhZWlOrF8CJln2A0HamvuNiLWmvgbJ261a6KtS0xwMMvJSLhmvXv+YKz+hDviIUwkblzl7E9SMaf7oKVv4dVxUo9YkSU4xiXeccEfxIRgfus7qNAQUNm+GUvNAFgemC7Rq2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51uAHD964PNpqQsBGeHpyNzRygYccfzJj5XyKo8ToPU=;
 b=JnnoR1kSBWUTAAZEBCu6ZcXv3ZA+bbYblIcfvF0kdgfLme9qLQtOk50gzSdoZnoHZRL0C3NbsVozWug2WRJx5noYmj3YZJYO4GbL8moqLtYhX8NuUmkHXY2TuWhFOWrTcDtlT3VqZTe0Af3niu5L6PGTHji+QDW2QZYgkXm5PoTd12OcO7Ll06xFX72hHV71gqMSsUC0uKCA+vmCterqAJybpJ2w6CCKqs8ETO/7xbBmnSlkUXVfbCXtfyvauGDL5TMBKmhWd7YxB9EJ8Bh1baZc85hpYc+aHTqpnlgsohpZdIRFiZJvwnEJ0gqw0LmbsSOn6VIhv0IpFdqwQrExSA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB8253.namprd05.prod.outlook.com
 (2603:10b6:510:b2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 16:39:28 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0569.008; Thu, 29 Oct 2026
 16:39:28 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, Bart Van Assche <bvanassche@acm.org>
CC: "mkp@kernel.org" <mkp@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"jthoughton@google.com" <jthoughton@google.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] scsi: bsg: release io_uring requests in end-I/O
Thread-Topic: [PATCH v2 6/6] scsi: bsg: release io_uring requests in end-I/O
Thread-Index: AQHdZSQlwL4bxblsuE2dHhgQENbwt7cPkbMAgAGRBQCAA5seAA==
Date: Thu, 29 Oct 2026 16:39:28 +0000
Message-ID: <20261029.scsi-lifetime-v3-plan.7ad5c4111d3b@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com>
 <8f30e238d2b169702308303687e9504c7513ecc8.1793003363.git.x-professor@outlook.com>
 <20261026094010.1324076-1-yangxiuwei@kylinos.cn>
 <20261027093528.477408-1-yangxiuwei@kylinos.cn>
In-Reply-To: <20261027093528.477408-1-yangxiuwei@kylinos.cn>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB8253:EE_
x-ms-office365-filtering-correlation-id: 655517e5-c682-43d5-e64c-08df35db3354
x-microsoft-antispam:
 BCL:0;ARA:14566002|22121099003|15080799012|25010399006|8060799015|4140399003|22091999003|24121999003|8062599012|19110799012|12121999013|2604032031799003|41001999006|38102599003|31061999003|24021099003|39105399006|12091999003|40105399003|26121999007|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 =?utf-8?B?U3FQbHFqazY5K29RbS9QNzcrQk1xZEdFc09LWFJZYTBxblNEYWd1aVVFVC9r?=
 =?utf-8?B?RGJtWTRXUW1jRlVQS05uZXFKODROVGQ5ZlBBWmVDZkFFUkg2dTFzNUdoU1pS?=
 =?utf-8?B?TjFOV0hTM1daS2ozQklqSmJIT3lRS0Vkc1ZJY1lmZWtkb3A3eE9YWEFla1B3?=
 =?utf-8?B?YTFpTnNRNm1va0xNWitkanltRlprazBIRDdXOVByUEhhL25NNXFrK3MrcVFl?=
 =?utf-8?B?OFdzK2U2NVROK0NsUE1nQUJZYWtITHhvUnFoazQ5M1hPZ0ptVUxqTGI2STd2?=
 =?utf-8?B?RDY4dDFaNWdPWVVsVW43UlpxeDNwdmVjR0pXdUY3TkVHTFNHMklKSmN1bWty?=
 =?utf-8?B?QmM3VkkxMWF5N01hWGY5cWZiaDg2b2NlZ2RWaWEzTUdyNVdEY3pBZS9JZzcy?=
 =?utf-8?B?ekJjVGRjUlgrRFhxQ0E3NHJSRGd1YlhxTjFXOVZPYnhoYlJOY1BxZXJoaGdm?=
 =?utf-8?B?Y01wdXl0eWprd091M081WTFDSVducmJoa2dEeUJWZnRqUmFQaW9yc1NpRjFO?=
 =?utf-8?B?dUx6Q2JnaXViK2ZYZ3dvK0tKamMvejZMVnFKdEFreEFDcGdlR0VyZ2RZUVJr?=
 =?utf-8?B?U2pGU3dNd21hUU9PdEJKYldEMUM1ZmlMRlhVaTBoZHREcWlBS0R2U1ZHRFpz?=
 =?utf-8?B?N1B5TGFiZ2txMEZ0SHpOY3VBTFJFVWRCMEZqelBBOXkyem55VHJPRkhnRERG?=
 =?utf-8?B?SFhiOGxTcVZMeFB5WUhFMU9qVzNsWnlNcHVYREhDU3RDQm9uazdqeWVmSk53?=
 =?utf-8?B?YVdIYVBaRngxSWhFN3Bwbm9xUVNCcTdIaGZyaTBMNEUzaThRM3hVTy9TajZl?=
 =?utf-8?B?MFhqY2RsS3l4NHRpOWZ0MC90Szg1Y1lLeGZPSW96K3ZVajRzTE45dkpIWS94?=
 =?utf-8?B?Z2xNNW11YVpUUzk1bWd2L3FZTm5TVUVFNk4wYThqUEEvYThQZ2NRZ29OeXdu?=
 =?utf-8?B?enhEazdHY1JSd2tRY3JzemswaFcxVDNaT1QzdHlpTjFJak9KRmFGMUt4c3hS?=
 =?utf-8?B?K1NFMnVJQjZ2T3Ayb01iZkkwZTl6c0liNElpS0RTOVlyM0hTUEtubDg4dEx6?=
 =?utf-8?B?Z2Z0RnpKNWplWEhGNUdkZjF6S0NjWm40eFRtNG1CL2hZUmRsL3BmUWlLekZZ?=
 =?utf-8?B?bXIvWDdYZEkrbmJPRE1CNlUyY1dJRllWWjliZjVEbTcycnIxSXlaNW1WT0Fq?=
 =?utf-8?B?M0I3ZGVEQlpCamVUMHlsL3p4YjBkMHR3MVhJMnpQeTk1SVcxMVArYWpuZjIz?=
 =?utf-8?B?clZEaTdXRkVRQ0NQZUlhbjR2MjdLTXRybWhIelFmanQySTltZUxFK3hpMThS?=
 =?utf-8?B?QmRzQlpxV1IzYWYzaGZCVjdyU0hDMVllSUFPQURKdit1TDlUcHR1clVRcDBz?=
 =?utf-8?B?Z3NjT211aXU2dVJUN1dEVzZlWFB0MVdTcGhyZDByMnBLYUZNOXl6dkxhNzJ0?=
 =?utf-8?B?dnpVOEZvbHBEVSsxNzFzMWxCL1dEMVpFMnZJWXAwSGd0L1JiMDZmTXdNbjNj?=
 =?utf-8?B?V2ZrTlFEWmswSVkrUitHU3diZ1dxOVpwc1VRY0U2UEYzREhJMGlkazEwMlhi?=
 =?utf-8?B?WmJCYlJSaWJCTzFrSXYxaEJjRURoRFFBVkFrWkE0ZnB1eFJJTGZFWVNpQi96?=
 =?utf-8?Q?jIT3JUQpqCr259+Kv0lcJVd5lOiH/sI7jS80oCxZNOZ4=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z0hzYW5aVDh1eEhRajB4SjBLRHZ6MWR6dmZaSkhSdHBoQlY2Tm1ydm50S1Ja?=
 =?utf-8?B?UEh2RURHRkVYcG1zVzZxZ2hBSmxXUmVTT3ZhTEtRczJxVGdncjBiVWxOdVUw?=
 =?utf-8?B?SVk2REkvUSsvSGt1b3dzWGtLUldiOFQwb2RKYkk0ZUFxOExFcVlCUVdYVVhm?=
 =?utf-8?B?QlBGcVVkY1NFcS9TR3JPbDRHMTZTQzl3VlpHOXFQZksxTjEyQ21XU1JYd3Zj?=
 =?utf-8?B?ZlhtWXpKTklTY2hBSWhPZ1lVdVZOWE01Q1p4MWQ5UHIxL2lpd3dxMysrQ3Fp?=
 =?utf-8?B?OVoxV244ZzNYY3hOdTdYUW0vZVNaVVEwVWxQaTZ0QUp0UlAxdlpKVmlEMlhZ?=
 =?utf-8?B?VW95Ni9RQWFyV2FMVGQxVFB0WkpMcmlnbzZqV04zQ080S0R4WUkzRktlUWRO?=
 =?utf-8?B?cFphZHB4Q3VBeE1UOWN5cE1GVEFRSmo2cENPdzFTSGdFY2lPOWc1dnFBcyti?=
 =?utf-8?B?cCtBOEhYYjhMK0RxRGhORGJqUlF0b0FmVENPa0JZTEQxbTFkQk4zQWJZRkpi?=
 =?utf-8?B?RVVhM2VhYW1IdXNEcXlZSWRtTzc4YU9BYy94MHg2L3N4TDlGUjV1cElvb0hp?=
 =?utf-8?B?UUs0Zy9zN25rM0pOM0NIYWZocnpIWkoxclFNOGdlalBBc1h6TzBiVkJ2ck1y?=
 =?utf-8?B?UnhVL2JzQjFPaUdUanJuS01jVTBabnRYSjYxa3R2U0JVNzhwSk10cWlaODlF?=
 =?utf-8?B?YnhwaWRzUTdVdzhYMXF6NHdNZ2U1a2pTeHFlY2t6SXU2a0E3aTFaL0czVUdh?=
 =?utf-8?B?WmtoQ0E4Y29YY0I4d1NqL1YvbERFVitKUXA4R1ljRW1nSE1SbEkxTkRJbDV1?=
 =?utf-8?B?STFDengxV29mcHBOUG1IbHdoNTczSDZhV3RWc0hpb3BPemNiSS9FK1V3cW1o?=
 =?utf-8?B?NlRQbDg0MjhnZ2NCVTNtZW5Dd3pmZXI5dmErSi9hd2lLejM2aGo2dzdlUlZ3?=
 =?utf-8?B?RTJ5bXRCZTQ4S1NhN2EzakgzT1pGNTVXak0vVGpqYzdqM2oxYjdhTXVoU05R?=
 =?utf-8?B?ZlA2VXpuZUFkeU9veU9OWUt0YlBzWjBRR3lXZEN3MVR6YUtVdVl4eE5xSWdj?=
 =?utf-8?B?UUpUY2xRYVdrckp5QTE1bFg1SXhNc2RHakR0QUVzWlQzOFJoblBFS2phSWg3?=
 =?utf-8?B?cWVCdHEwVTJtQU92MCtCVjB0R0ZIQ1pwNHFraGhNN1I5RWtCeUhnY1h4ZTVT?=
 =?utf-8?B?eXVjSmhUbUlNUHFmQ2lnNlR5NGtiSUs1UERxRU4wOE1mUWcyRkYzQXk3VkJV?=
 =?utf-8?B?dXdjcDFZdEZZY09HRGMwQjEvSlVKeDNFZHBkY3c5L0ZzTHM1Wi9QalhuRDdB?=
 =?utf-8?B?YWtXeEdRaThCOVlKTS8rTkh0Q3J5YWZXYmR4UDJPOWdmS09hSXlGK0NtcjNL?=
 =?utf-8?B?c3p4YmRWaUlLclpJV2ZNWm1vNFQ0eVQ2RzloOUtpS2lrSkZKTUM3T0xabk1Y?=
 =?utf-8?B?Wkd1TjBHNTN4L2lzanpnZTFwbGdKUnJHK3E4MlFJdDAyZnVCTG1KVmlCRDcy?=
 =?utf-8?B?MzZGTFg2d1ZZZ045OE90WjZvQjMwQVVGNWZOZUdNcEI3QS92N1hYMEF5THd2?=
 =?utf-8?B?bWo3SU1UeHFmTXVraW5qM1lVOUh2REVHaGRGUmVZWnAvTzA0UVNlbEZ1dGRx?=
 =?utf-8?B?Q1J0UjlxWnNFRm55ZVJXaStHTGNBUG9odVNrOUtaNmxPMFg1L1FHKzZJNW5X?=
 =?utf-8?B?ckswbEtYNldjNVVieXZCT0UxYnBqUFh1ckV5aXdKanViVG9pK0VOQlVPTXox?=
 =?utf-8?B?SlQvWG9GZTNYV3hEL3l2a0JKd1dJdnFzeEFVSmRaUWpyZnNIbWxTT1R2VWFl?=
 =?utf-8?B?TjNyWnZBeFA1NEJhUExVcDk2NHVvTzMra2theUtDSEI1bFRVQUt1MlJVa0Vt?=
 =?utf-8?Q?4gGUR78Pxj/jS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9294835C98BCF46BD142F6493343DE0@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 655517e5-c682-43d5-e64c-08df35db3354
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2026 16:39:28.4875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB8253

SGkgWWFuZywgQmFydCwKCk9uIFR1ZSwgT2N0IDI3LCAyMDI2LCBZYW5nIFhpdXdlaSB3cm90ZToK
PiBGb3IgcmVmZXJlbmNlOiBzY3NpX21xX2luaXRfcmVxdWVzdCgpIGFscmVhZHkgYWxsb2NhdGVz
IHNlbnNlX2J1ZmZlcgo+IGZyb20gc2NzaV9zZW5zZV9jYWNoZS4gQSBzZWNvbmQgYnVmZmVyIGZy
b20gdGhhdCBjYWNoZSwgYnNnX3NlbnNlLCBjYW4KPiBob2xkIHRoZSBjb3B5LgoKVGhhbmtzIGZv
ciB0aGUgc3VnZ2VzdGlvbi4gSSB0cmllZCBhbGxvY2F0aW5nIGEgc2Vjb25kIGJ1ZmZlciBmcm9t
CnNjc2lfc2Vuc2VfY2FjaGUgaW4gZW5kLUkvTyBmb3IgQ0hFQ0sgQ09ORElUSU9OIHJlc3BvbnNl
cy4gV2l0aCAxNgpjb21tYW5kcyBpbiBmbGlnaHQsIGFsbCByZXR1cm5pbmcgQ0hFQ0sgQ09ORElU
SU9OLCB0aGUgdmFyaWFudCBhZGRlZAo0LjUgdG8gNS4yIHVzIHBlciBjb21tYW5kIG9uIGEgS0FT
QU4ga2VybmVsIGNvbXBhcmVkIHdpdGgga2VlcGluZyB0aGUKcmVxdWVzdCB1bnRpbCB0YXNrIHdv
cmsuIFdpdGhvdXQgZGVidWcgb3B0aW9ucywgdGhlIGRpZmZlcmVuY2Ugd2FzCndpdGhpbiBydW4t
dG8tcnVuIG5vaXNlLgoKRm9yIHYzLCBJIHdpbGwgbGVhdmUgb3V0IHRoZSBhZGRpdGlvbmFsIGFs
bG9jYXRpb24uIEVuZC1JL08gd2lsbCBmcmVlCnJlcXVlc3RzIHRoYXQgZG8gbm90IG5lZWQgYSBz
ZW5zZSBjb3B5LCBhcyBOVk1lIHBhc3N0aHJvdWdoIGRvZXMuIEZvcgpzZW5zZS1iZWFyaW5nIHJl
cXVlc3RzLCB0YXNrIHdvcmsgd2lsbCBzYXZlIHRoZSBzZW5zZSBkYXRhIG9uIHRoZSBzdGFjawph
bmQgZnJlZSB0aGUgcmVxdWVzdCBiZWZvcmUgdXNlciBjb3B5YmFjay4gVGhlIHRhZyB3aWxsIHN0
aWxsIGJlIGhlbGQKdW50aWwgdGhhdCBwb2ludC4KClJlamVjdGluZyBJT1JJTkdfU0VUVVBfREVG
RVJfVEFTS1JVTiB3b3VsZCBub3QgYWRkcmVzcyBmYXVsdHMgZHVyaW5nCm9yZGluYXJ5IHRhc2sg
d29yayBlaXRoZXIuIFRoZSBzZW5zZS1sZW5ndGggZml4IGZyb20gdjIgNS82IGlzIGZvbGRlZApp
bnRvIHYzIDUvNi4KCkkgd2lsbCBhbHNvIGFjY291bnQgZm9yIEphbWVzIEhvdWdodG9uJ3MgY2Fu
Y2VsbGF0aW9uIGZpeCB3aGVuIHJlYmFzaW5nLApzaW5jZSBpdCB0b3VjaGVzIHRoZSBzYW1lIGNh
bGxiYWNrLgoKSSBwbGFuIHRvIHNlbmQgdjMgYWZ0ZXIgLXJjMSwgb25jZSB0aGUgcHJlcmVxdWlz
aXRlcyBhcmUgaW4gcGxhY2UuCgpUaGFua3MsCllpbmdqaWUK
