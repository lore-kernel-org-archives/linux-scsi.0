Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2081.outbound.protection.outlook.com [40.92.102.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52DD23BE;
	Sat,  6 Jul 2024 12:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720270582; cv=fail; b=YeqSIKdMvwaiWysvkO2RIDqOd/1A0l/3iBfc3mruf2DyyWuK7YsW8M99eriSPRk8lAaCxCY0GXXHskHf79E5swJ26RTXti23jcNREhO+MmxpO7BV0wLyDZNT2cNsIED2evYlBgol2aihBPcpAcJAl9SVNcZWQ75K3s6FuSSbTBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720270582; c=relaxed/simple;
	bh=QWNBRCb7JbXWO2xGWDsp3WrYX6YbvrpK3aNJdDamE+s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uwpICcdlcKcys2RJYLB0hbctpqqOH6M4laawT1htF8MfoWCaM0kdt/9uLRq6W77js57iVR+Tzq6ucRfwnvZS0x2UDMioTGb/Rap0pS1zOC0VTF395u3pCuwsIyZmSuldxfySlSbZjLXDwcUP1FeFJrlFATA8gPdSQ2wSghtwEqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=Y7TJ9JCu; arc=fail smtp.client-ip=40.92.102.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="Y7TJ9JCu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2GWtUNg2M3cI0QPASBLynzcENmLun6g3IkHoIdXiQNKOsdf1rfOBqZPFDIg0zzwuiwEsVPpNmb8q4Re7K+PPcQAJLIlcpExFwrR3KSIBZwE0kJ23/f7I1cyW+xqDFBaNmNur/rm8Haue6L5o/8Zr/lpvJU2Me1dtW0DFNo38ItMB0IawL6+W/tDgzSp88jnQpza1ORTTj25X5f71HBavqZr6ELlaSy/raTkuZm3RGEtUb34pBFt3R8vu86YwJ494iBgnVp8rJpMULOdk9MnIiBqSqSX61QeKUIACOdWAegnIhKorMGHlOM7S5PmNuI/5rjgXeGHXnsgrP3ivIc/Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWNBRCb7JbXWO2xGWDsp3WrYX6YbvrpK3aNJdDamE+s=;
 b=n0gFp0pGfiXys5iQLNJA3Z+aU2kKY9nQJI/UgB/A9vHEWsA68gA/RaWupOCGjRBshMhcHu/7QmSm1vJTEDytvK7Orjwph0CgA3b153Ko+bVrZskQ/zcV00MhGaH8Ym8G8IlHQ/msZtOp3qoQ4n9vZh3kM+qDidBs3nGSffXfxU9tfwl6m5bPcr6GrnPxAXmK3JXIeaKrF4Nk/bh4Uzy1fzwu+gMlcSMa8NGl6T0Qsi354FFlepbITOoprnfcI3zYLeBRZZOuyD437jz5Q1d6J0UJv8qI+dNVu8AHESkTU4aF3TYzG4R9k/X4DGo/2OJTIyvzGKXA+YYn9TbvlcFJEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWNBRCb7JbXWO2xGWDsp3WrYX6YbvrpK3aNJdDamE+s=;
 b=Y7TJ9JCuhWcO9Af+93NVcInNvONvNUXJWUbSir9Hm5Rk2Hmd9ZDcKTUfK40E5dkbGUOEhOrBsEfWvfVL5i6HqkQOW0k6w/c6FTG0IuFALbGkDLP//hFn1ycTJieR3lYiq2CYNOUbC2jeErFZEq5EpdrxRDCq6gtvk13LmcYeXwp3V+Dk6fWntFL9Pkig+AwL8fpQmQlp/+sBfigBoelJb324TMOCQIsdhJQCOk5PFRFPGEWRwNDfBt+3DUv6I2D3wgFkjEK0j6TQf+VFWdMru51YfbHpX88NRwHlSoa6FRUw5Xf/UQqVEib6oEcPAJswGILI2C/8ydUWNm8p9SKj8Q==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN3P287MB0789.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:174::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.31; Sat, 6 Jul 2024 12:56:15 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 12:56:15 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>, Kerem Karabay <kekrby@gmail.com>, Orlando
 Chamberlain <orlandoch.dev@gmail.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH v3 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH v3 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHaz5yAS+i+TdTeKU6c11DkRXEKIrHpoxgAgAACioCAAALZgA==
Date: Sat, 6 Jul 2024 12:56:13 +0000
Message-ID: <7CF44361-A11B-4C30-B2F7-A66C986D3143@live.com>
References: <58227E2C-1886-40AD-8F80-7C618EF2D8F2@live.com>
 <7AAC1BF4-8B60-448D-A3C1-B7E80330BE42@live.com>
 <2024070612-squealer-wackiness-c885@gregkh>
 <1E1BF62B-E8F6-411F-B06C-4A28C96B4897@live.com>
In-Reply-To: <1E1BF62B-E8F6-411F-B06C-4A28C96B4897@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [Qoeu7CdgzfrwjYO7YijztYGtA3DtNBvetGnIGEVvsJcGHW4212a+xtyWck0CgThV]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN3P287MB0789:EE_
x-ms-office365-filtering-correlation-id: 8c5696dd-35fc-4d76-50ae-08dc9dbb0448
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|461199028|3412199025|4302099013|440099028|1602099012|102099032;
x-microsoft-antispam-message-info:
 GSUpfrP89OQR5qh9pnY4AIl0UNFVzMdrKS6ahE5pLJt9Ps1ofhWuQvdlDQi/PwETz/NL3ay6H8k0bk6DBOPRTYN7QRcaehAGpr1g0aA8RqcdQdic3R2ZQLKL/5VhSlN8Pxb9Ga+2gp0nhY3FAly30HjDEn45bFUke81ykUgY9xGUEfoc2SkRUURV70MpYjgKRSVfVyM3JiFOtOKzboMHR3LTtTbJsxByxJc1Z/YdOhlcbOUGYLKGeu2qfi+eS0C71PAfGdNcW5I92fqoUjh11Zlfv+LgT+rBSLWnEfMl9aec6iC0O843QCiToUqUURNfjG2xp74AAjQKWolqOcJfxQ6wPEYt6yLK02Mu1KkVJnQUi0buCH3x9hsP/fPU/T3yttQlDqLenXLqlm+pxqEH0LuefTTWcpGSP3FYgVS1Xed+oLEJ5TIbeE4zoER1fLIK+YVEZ1+YsuOc/scEUr39i80WgnmtnG1dB22qR3PangGRYfUVdzTRwq1oHxpsI/mLjZZyoOmJW1y9UuVigJ5lEIioXjmbOpCXMD6fj5t1MjMKuyR6QdLX5Pnm5Eaoo1fxU4hs6zDHvzLZLdv9nG4ygfIqPnTBIQa/xvR85o/70X19qx7/8Zg8vpcqZedIxwlI3kzya7rDc3sleDyxvJMjXmslVu6MHChlgY81AeXkrUMB4l8PGgjTIfxfA1FOGdrJEsF7kU8rANOZn7nIwSTmYKr5Li+LSb/rqxKZ/vJqZXQg//UJZJ5FF3/7ltLtUq6Ve2UxXnnoP09eRDYxlP2ilQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aFRRNmJOQWtRdS9ZRnFTVzZ1dEJZdDNLekQ0NlFxV0ViTEs4QnZ0VXdHMjhz?=
 =?utf-8?B?enNCNFl1dmxSNE9zMnNqK2NwdzNGVEwxZTk5ak9VdGxmUndqamEwMHExdXdU?=
 =?utf-8?B?REVOSHBjWkJHQjZYakQ4YzRFUlYrbDJmTWs2alN5cjRqcXhtR09Vbm5UMkdy?=
 =?utf-8?B?MG5BU1lhSGhlRWVwRFJ0RFA2WnNUcVNoazBPTC9iWVdIQzRHSEJmUVRhQWpK?=
 =?utf-8?B?ajhTL1dDcjB0RnpXM1lkb2Z6OEpQRTA4aWdFSDZVM0JqVUZmNzRvUWY4dlhy?=
 =?utf-8?B?L1BPekczU2Z2bEhERnNUWWFXTURqeDRYbGV4WTZWMHAzNVpuZmluSHl3eUM5?=
 =?utf-8?B?ZmFLK1gxNi8wRHpiSWM2bzdPNjZOVUVFaENJc2p3UnRuZnhyN0tkMytxYWR6?=
 =?utf-8?B?Yzcwd1d1SzVHeEhHTVdrMjZhSmNFdWxaQVE5Smd5Z2diTWx5MktCeEZqRUVV?=
 =?utf-8?B?ekhxc0lwS3JoUXNUdzVoQm01TndjbEVkdXI3ZUVtK21RYkpaRVBXQW8veWtk?=
 =?utf-8?B?VzhaQTY2SnNTSE1RRkd3b3pUWlc2UGh2THhQKzVZTDRaOTRDaTRFczloRXA0?=
 =?utf-8?B?M3RCZHRzL2hLRTVWaXEybGNGdXR0cnRIL0tRd3ovZTZzYUlSWlRnTWtVTnhi?=
 =?utf-8?B?UWh6V09DQ01hYlFUYUNyam5sWlZ3ME40aUhDc2ZxZEJLM3FoYm5HZ2FsSU4w?=
 =?utf-8?B?c2hSRXZiQ2k1VFpBMWc3bkdINlY4UzZQWXRQTW5XNzF0djZ1eTJzQ3BJc0s2?=
 =?utf-8?B?VWVrYlFRVmZhUFFIMzVMN011aEs3bWNLdnNQVnYvWFRaZ1ZyWHQ4eit3d0wr?=
 =?utf-8?B?NDFWNTl4UVN3bUEzUUh0ak5KbG04UitZS0NQSGU4TUhYNmhNell4ZUpvdWIv?=
 =?utf-8?B?SlJmaGtoWm9pajNLM1JYKzl3UUFneEhON1Vsc2IyV2tmOFh4eVVleG5Rb0Rq?=
 =?utf-8?B?ZlNsL2VsNU5mM0ZlQVVIK2RVd0RVamJ0NUJ2M3RrQ01jbDhaVmlRTjlrbXNv?=
 =?utf-8?B?dFpBTnVuV2Rrb0VJNWFqVHNobUtDZmJMTEhsdlBERElvV3g0bmRzTldJOUtV?=
 =?utf-8?B?Ujd6MDN4ckIyTzB6bGQrV0pZL0J2MHA1alpiQVo5dnVaanJsaFFrdnoxOUFp?=
 =?utf-8?B?aGNaVHY4VnNIQlduQ2x2VjQ5Y1VvQ3ViZHEwS0Q4bkwrN1pjY2dYRWpGRnU2?=
 =?utf-8?B?YU42T0RjRXoxekR3b2wraklSdXZQTFlvZXlWUlpXa1UzRUlwWjExTHNsVFVz?=
 =?utf-8?B?L0hqZUMrdmZweUhuQkR0Qk5tc1V2WVFScDRNV0NjZWJjS2IwYVN6NEFIRXJV?=
 =?utf-8?B?MGJKa0pNbmNtYUtubWxxeHNjTTlyT3RnQzg5WUFRQ3grM0NiellzTnlyMFVs?=
 =?utf-8?B?WFVvSnNVMXNySzJKTUFnTHgvQ05lck9VNjBCZG1YSDBNbS90NVdxV2xHWFJa?=
 =?utf-8?B?NnZqc01BZ1ovNmtkYlpGbjhaTStibStIQk90OGRxSjRuaWViWDdrSUtLeThj?=
 =?utf-8?B?d0hpRWVCREkrcDFOZVFPNEhtK09ncjEyeXBzZkFNamdkazd5SnNuZ25rQXFi?=
 =?utf-8?B?UnhPYUNVOUZnYjRtS0dFYmVnYXZyemgxSzhIU2hqQVdORE5ucFpoWEZYK01D?=
 =?utf-8?B?dmFmQ241ZkZhVTdrMFV6bUtibnBwZW03dkc4L2loTDdJVy94K0FxWFZGRXRU?=
 =?utf-8?B?KzU4RDdjcUozMGEvZmkwaXpSRENXNVlQL1E1ZmNEUXIxaG9pTElWZUtReVND?=
 =?utf-8?Q?qTx+91PyC5KiFOOpHxBrBq9wNuJyH4cH9Qc90ep?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EED9A1C0EE4A34AB199B9B3403048F9@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5696dd-35fc-4d76-50ae-08dc9dbb0448
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 12:56:13.6017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3P287MB0789

DQoNCj4gT24gNiBKdWwgMjAyNCwgYXQgNjoxNeKAr1BNLCBBZGl0eWEgR2FyZyA8Z2FyZ2FkaXR5
YTA4QGxpdmUuY29tPiB3cm90ZToNCj4gDQo+IA0KPiANCj4+IE9uIDYgSnVsIDIwMjQsIGF0IDY6
MDbigK9QTSwgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmcgd3JvdGU6DQo+PiANCj4+IE9uIFNh
dCwgSnVsIDA2LCAyMDI0IGF0IDEyOjAzOjIzUE0gKzAwMDAsIEFkaXR5YSBHYXJnIHdyb3RlOg0K
Pj4+IEZyb206IEtlcmVtIEthcmFiYXkgPGtla3JieUBnbWFpbC5jb20+DQo+Pj4gDQo+Pj4gQ3Vy
cmVudGx5IHRoZXJlIGlzIG5vIHN0YW5kYXJkaXplZCBtZXRob2QgZm9yIFVTQiBkcml2ZXJzIHRv
IGhhbmRsZQ0KPj4+IHNodXRkb3duIGV2ZW50cy4gVGhpcyBwYXRjaCBzaW1wbGlmaWVzIHJ1bm5p
bmcgY29kZSBvbiBzaHV0ZG93biBmb3IgVVNCDQo+Pj4gZGV2aWNlcyBieSBhZGRpbmcgYSBzaHV0
ZG93biBjYWxsYmFjayB0byB1c2JfZHJpdmVyLg0KPj4+IA0KPj4+IFNpZ25lZC1vZmYtYnk6IEtl
cmVtIEthcmFiYXkgPGtla3JieUBnbWFpbC5jb20+DQo+PiANCj4+IFdoZXJlIGRpZCBLZXJlbSBk
byB0aGlzIHdvcms/ICBBbnkgcmVhc29uIHdoeSB0aGV5IGFyZW4ndCBzdWJtaXR0aW5nDQo+PiB0
aGVzZSB0aGVtc2VsdmVzPyAgTm90IHRoYXQgdGhpcyBpcyBhIHByb2JsZW0sIGp1c3QgdHJ5aW5n
IHRvIGZpZ3VyZSBvdXQNCj4+IHdoYXQgd2VudCB3cm9uZyB3aXRoIHRoZSBkZXZlbG9wbWVudCBw
cm9jZXNzIGhlcmUuDQo+IA0KPiBJIHdvcmsgYXQgaHR0cHM6Ly90MmxpbnV4Lm9yZy8sIGEgcHJv
amVjdCBhaW1lZCB0byBicmluZyBMaW51eCB0byBUMiBNYWNzLg0KPiANCj4gS2VyZW0gaGVscGVk
IGluIGRldmVsb3BpbmcgdGhlIGRyaXZlciBmb3IgdGhlIFRvdWNoIEJhciBvbiB0aGVzZSBNYWNz
Lg0KPiBEdXJpbmcgZGV2ZWxvcG1lbnQsIGhlIGRpZCBzb21lIGltcHJvdmVtZW50cyB0byB0aGUg
SElEIGNvcmUsIFVTQiBjb3JlDQo+IGFuZCBEUk0sIHdoaWNoIGFyZSBub3Qgc3BlY2lmaWMgdG8g
dGhlIE1hY3MsIGJ1dCBhcmUgdXNlZCBpbiB0aGUgZHJpdmVyLg0KPiANCj4gQXMgdG8gd2h5IGhl
IGRpZG4ndCBzdWJtaXQgaGltc2VsZiwgdW5mb3J0dW5hdGVseSBLZXJlbSBzZWVtcyB0byBoYXZl
IGxlZnQNCj4gdGhlIHByb2plY3QgYW5kIGlzIG5vdCBjb250YWN0YWJsZSBhdCBhbGwuIEZvcnR1
bmF0ZWx5LCB0aGUgcGF0Y2hlcyBoZSBjb250cmlidXRlZA0KPiB3ZXJlIHNpZ25lZCBvZmYgYnkg
aGltLiBTaW5jZSB3ZSBoYXZlIGhpcyBTaWduZWQtb2ZmLWJ5IGFuZCB0aGUgY29kZSBpcyBHUEwy
LA0KPiBJTU8sIEkgY2FuIGxlZ2FsbHkgc3VibWl0IHRoaXMuDQo+IA0KPiBMaW5rIHRvIG91ciBw
YXRjaHNldDogaHR0cHM6Ly9naXRodWIuY29tL3QybGludXgvbGludXgtdDItcGF0Y2hlcw0KDQpZ
b3UgY2FuIGFsc28gZmluZCBoaXMgbGludXggdHJlZSB3aXRoIHRoZSBkcml2ZXIgb3ZlciBoZXJl
Og0KaHR0cHM6Ly9naXRodWIuY29tL2tla3JieS9saW51eC10Mi90cmVlL3RvdWNoYmFyDQoNCj4+
IA0KPj4gdGhhbmtzLA0KPj4gDQo+PiBncmVnIGstaA0KDQoNCg==
