Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2051.outbound.protection.outlook.com [40.92.103.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0016150246;
	Sat,  6 Jul 2024 12:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720267597; cv=fail; b=QJezmF5H21mPvhqWTK0Bq41TgoL/cfS9YR6f/ZuVI+JkQkT/W9ql6rVhSWxXzPK/SayWEhal/xpT/m+JegK4ptDCN4H+pHCmPdGnaBncNlquK9ueabT5guV1ar45pnZQoBt/kriHthIWc8S4Z1ilaTl7Cos81FHplRGzRmJ222g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720267597; c=relaxed/simple;
	bh=AVS05Pk84k8Yf8DGIYGyW3B4JeQKI7+SgXNHVyaOZIs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GYIFVI3IXQ+o93U0I08X/41d3ei/8jKsqTYAv1HqZVqVnyrwxNfki5/14pCRhBcpuzf+7o+RkEoUj5zl8RJWxiMJepz0xXJyU5T3lAwbSSFCarPPu4s1YjutGyPGDdG8mOzhWU1QJTRnP6CPnxEdIZy/6eV3Rv6ZtWshq/iOfHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=Yqpvf4nz; arc=fail smtp.client-ip=40.92.103.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="Yqpvf4nz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1Dxbw+9QjRS7MsMkd+m+zCzCtUQ/D/dvXsmdmQ4qW8Kk6J6GsJ+FEpR7/vj6RdV6wYxHUa66i7UtJcmB6qOTbsQwur4anU0lXzDRz2z1jTQGRPkdmZKpOIx738I52RU/uvtz/jNykJ4mnB1tzGDJXcUxp8kZMYCobYUrf1AXtUrHhVzikjg3E57p774f8K1vis4VEU9p43iuEqFm3JwzmzxJahRmuteHkG6gVjzRchvwF0ZcbmG1IXjZzyezOGfpRSfVNogM6vPP1irWe4yi+lcnGc3ZCws2DPzLD4dL0aNzdmrNhDox7lI504ht5BM1Sso02jCT2JyHKJy9BWG4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVS05Pk84k8Yf8DGIYGyW3B4JeQKI7+SgXNHVyaOZIs=;
 b=g/HKUw1/nVGzHUYq/ea8IkF9jHUtM//78YjrCOCctRtahZoLhNNt+aNwrRL/qhN7KlovMvuzXoE+35wbXQYNa5G3rVHahbO6tKqfE6Rf7LDJlOxJsvD7Ac9XIlbTjNPVxwBa2AcUPSKKy3+7X1pdqlnn3TaB0DHhw/l204p2tikEE/Dvp4LkAJewITrubn2BvEvogz1kwTeZVv7k4isqOGiCvnN3IC7VFaFJtca7MjyLNgYhvwNfdYETQa5ghpjT1UH4sAIErAh5rTVTDwYfHkSNXYqgxpQjKZZTcUnFMaHv8Gr+R20USxjOrlo7+a0teoWEDH0gYnbUzZqqML6eqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVS05Pk84k8Yf8DGIYGyW3B4JeQKI7+SgXNHVyaOZIs=;
 b=Yqpvf4nzmBw4mHbMigZOo3lzBDvad9OlwPf2Bf5Rw92uCy+O1mjLls6dpgcPqInMHiXQAXJrsiM/HSkSQBnBaUT6LglQ0DvOrTDRdRxz4R03Z4eNyNV6Wc3rpu4wvDpQaVmRgnkbEu41lfkLJdeQnutuoFTNXS+Us77JeBzSrGXI0IkratvQzP33xA6Qvo8KS3lVaid8Jg1ZmzCdpjyy0zu3LgFUDnR9UpicWSZp0GibCixQwTGZbX4j6W4Zmb/UozF5JIbs00V5IxvQemrCB1mzDnduBTrx2AGbfoj0yMi0+Fnc+3KMIbUVr7kgMnIm0cwgcWMQ9EpPyCtaTdYBqQ==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 MAZP287MB0611.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:10b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.31; Sat, 6 Jul 2024 12:06:24 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 12:06:23 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>, Kerem Karabay <kekrby@gmail.com>, Orlando
 Chamberlain <orlandoch.dev@gmail.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH v2 2/2] scsi: usb: uas: Implement the new shutdown
 callback
Thread-Topic: [PATCH v2 2/2] scsi: usb: uas: Implement the new shutdown
 callback
Thread-Index: AQHaz4t+8wEhfBXSYkeB85QpAZZdlrHpegEAgAAgsIA=
Date: Sat, 6 Jul 2024 12:06:23 +0000
Message-ID: <C2389234-19D5-4967-B63D-82E5AE102A1C@live.com>
References: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
 <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
 <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>
 <2024070603-deniable-slang-f93d@gregkh>
In-Reply-To: <2024070603-deniable-slang-f93d@gregkh>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [xYYHve9iU0ad75yOyBrn8yCI35ymZ2ZzWgYgMFLam2k9Pq3E7tKB6Saz0ncIFxbEhCJpJ14hTWY=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|MAZP287MB0611:EE_
x-ms-office365-filtering-correlation-id: 7c33ee84-f09c-42bc-a9c1-08dc9db40e0c
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|8060799006|19110799003|102099032|3412199025|440099028|4302099013|1602099012;
x-microsoft-antispam-message-info:
 z0kcBevtXHpeKKBXayRJuauSuiXx8qtDjGrc+U25uoTovXF+NpLdCVdNqSLvHku8we9upUPOZJDlZJ9m5L8O7NP2fG01WeinTaSD+IET97Ykp/2doYpGKnqKOtRhOTRtdymjj6TCjtpZi0dEinyb2ytYz+e99BCBQYRiYRyRmkID7eetAkKj4bCm92vqLn/S9m3NVJBkwr+8hn1J6h8aUOq33icM8CwOOpz54vHjwChAm1ON7bfvQe7VIeqn/D8/gCNcz/445aujP/by7bfpAmwTIeiwS/xeg0DZI/bAA2Z3jZVW+Pd+kclHGNjOwB1083t8ag5oXDSrVwj8E9gYbyPe5khzj8fdS6av27NrSfdkree7TcgkAAlraVYf3BDGE09qWvUTiRkFVUc70hR7ZxVtYyFLcwKiXWcAIxgDA4n5Xm83fNRM8HMtNKrQhonIBoluqac37gam1mo9Cia4z+2k4yi0fxGa3UsIPsS0vLYoog7PQfEm5kaNLdx9WBgTMIPuzD/b+21IOU579BbFqBGDBnYMGG5YI0rYGlzQxeznkQDqayBZMhMitZ76KUYvjS3Ui/1cFl1ypBFomG0oPGzV7v9vCnjnuDPy+O9rbzz7yv4+VwYDbQpH6toSBmrAbMhi1whPuMsygeQgxRJ+mRnFskDyCeSWwCMZ9+Y9PH4hwrR8oruNCjhmU5njTqrLh3OtxlVo0yaTR6k2BD3jJgmTdoT1gLLsvY8iKy9M7xEx1UN3FJaKgrR4niDxFYp+
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cm12a1IyeGlqcE1UWjVHa2tQT2hQMThhd1k4aVg5dlJvK0Rmd0ltL3FQcVFt?=
 =?utf-8?B?S0xGQlhEblkyUHVMalQwWHpMb25lbDZvU2ROSW56S1pSZWFIVkJoOTNFaUMw?=
 =?utf-8?B?TkZmRlQ4U0s5NUtYY1MzWngreWJQN3FZSFBFVUZiUVpkL0xZU29sRXdibVFT?=
 =?utf-8?B?cVpXYWo3bzZzanEzaTQ5VTZmNDFJNStCaVY2Y1dmWTVZc1hYOUlyNVUxZVFv?=
 =?utf-8?B?dlFSTGZNZUJlRVF5WXBWdXVOa0EyQkp0MHRqcHIxY0I0eTMxeFU1QkxCR2du?=
 =?utf-8?B?dWxkYmF2QmhQbENiU21DdGNsNVN3YU1JZHk4dHVrdkR4VWlRYUdGckNXTTJr?=
 =?utf-8?B?TG40VFN3cVorUitZYU1lbmd5czhjWnlGNVJaZTFMYnRraFpuRDdqd09QSXMw?=
 =?utf-8?B?VDJpMmN4Ym1NZFpURTRJcWZFbzJqaU9QN3dkbno3QVhudFpJMFN3c2R1YXlB?=
 =?utf-8?B?eWVuK2JYeHlnU0krdjliNm1OeGxncTdBeGprUUlYUVZtNGYyUmswVzR0Nkk3?=
 =?utf-8?B?SCtHZ3djVGh3RWxvVkZ0Z0xUTHkweHcrT1Rnb2JPd3VrN2N2cW9kWmdRT3dK?=
 =?utf-8?B?UHdqZ0V2d05Ca1BGWW9xdnpJTFZ2UUpoVjAvbUVaamptWWJGZE9PUmNkUEs2?=
 =?utf-8?B?bmIveHlLS1Vhck1PUm5aTytkekR1YVE3ZG91UnJnUEVnbEwxazdsMFlBWjcr?=
 =?utf-8?B?OU5mS29NaEV4SGN0clhQWnBLOVFBRDNQWFBQQUJoWFE2Uk9RWkpWdXJ2NENv?=
 =?utf-8?B?TEtpSndTMTg5Q0hjNnFsanhzL0JmSy9OZ29YL2lFYVRXZVB3d2pGRERaNGV3?=
 =?utf-8?B?UnVROUNORzBFM1FDMDlRZmlLY0tMaDNIZXdCUHVvL2owZXV6QVk0NHVBSE4w?=
 =?utf-8?B?WEM5bWIxUldEaHpkeERxaW1FRDBkL0hja3QzWUNyMEZ4Q3E5bnRyUUdZOHIz?=
 =?utf-8?B?c0E4QkpnT0lLUWF0VTZBY2g3dmVuajc4bGR1eE4rcEFnR1Y3Q0sxRVFGTzBJ?=
 =?utf-8?B?RVMrWmZaM2d0aVVtcFJxeXl4UXpieENVdjRzWGFoTHNnUVozeEdGbHBaMVNT?=
 =?utf-8?B?YmdPTTBTRWIxYTNBNVlBcUdlRXpIVGhRcGhmOXlLVm1PSml4VG1qMFYwT01s?=
 =?utf-8?B?MlA2T0JObE1KcVdQK2VDU0d3eFBlMmpOUGRvVDRrZStxS25yOVgvRDNNRTRF?=
 =?utf-8?B?V3hOQktkb2s0WjMzRXpCeUFVcVhYcVRRUms3MVpQNXdHeTEzaUluNXdNL0dR?=
 =?utf-8?B?R0p6dTY1VDlVRloyeDVDa2RTRHZRRy9KdUJFWnh0ZWlaN1A4SVlLMllNblZj?=
 =?utf-8?B?WDMzV0F3ZzFiSUttUk51L0IzN01xTUo0MnByTHJpR0U0SGxRaVFKL2hneGVH?=
 =?utf-8?B?VVBhc203OUtNbElEVVM2ekxCSlRjc2p4T3I5ZGpOeUhtVDJ3Wm9idzRlSllD?=
 =?utf-8?B?elAyQVNkb3E1eVNsbWswU2d3Tnpxd3d1ckptM2QzdmxBRHN5dzRyWHlVaFNq?=
 =?utf-8?B?dGg3c3QyTE5mVWkwUHZIWm5jMUlPSnVCVnNEcjQ2TDBTM2QySndydDlhcElW?=
 =?utf-8?B?WXI4QTg1SFJidzVQQU9IZXhvaHNrU0IwOUc1a0REc0ZMUWc5WFV4S1Y5bzZo?=
 =?utf-8?B?S1Bhemh3Tk5zT2xvYktDcmFIdk4rU1dydklLaGJmUWRpeXlFVVBnQllBd3VG?=
 =?utf-8?B?TXQ1MXlsWTIxY2NSMm1PeHo1VWMyWWIyYmpiOEFyNTczUlR0bVFNQUNtVWE2?=
 =?utf-8?Q?cxoM7f2U50VlRtFfkFynP4zKoiETC4rh62ASsJP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <450EFD3AD0D144478D18F23D7C511D8E@INDP287.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-7719-20-msonline-outlook-24072.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c33ee84-f09c-42bc-a9c1-08dc9db40e0c
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 12:06:23.4896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZP287MB0611

DQoNCj4gT24gNiBKdWwgMjAyNCwgYXQgMzozOeKAr1BNLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gDQo+IE9uIFNhdCwgSnVsIDA2LCAyMDI0IGF0IDEwOjAxOjM4QU0gKzAw
MDAsIEFkaXR5YSBHYXJnIHdyb3RlOg0KPj4gRnJvbTogS2VyZW0gS2FyYWJheSA8a2VrcmJ5QGdt
YWlsLmNvbT4NCj4+IA0KPj4gVGhpcyBwYXRjaCBpbXBsZW1lbnRzIHRoZSBuZXcgc2h1dGRvd24g
Y2FsbGJhY2sgbWV0aG9kIGFkZGVkIHRvDQo+PiB1c2JfZHJpdmVyIG9uIHRoZSBVQVMgZHJpdmVy
Lg0KPiANCj4gQWdhaW4sIHNheXMgd2hhdCBpdCBkb2VzLCBidXQgbm90IHdoeS4NCj4gDQoNClNl
bnQgYSB2MzoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzU4MjI3RTJDLTE4ODYtNDBB
RC04RjgwLTdDNjE4RUYyRDhGMkBsaXZlLmNvbS9ULyN0DQoNCg0K
