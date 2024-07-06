Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2074.outbound.protection.outlook.com [40.92.102.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF29222EF2;
	Sat,  6 Jul 2024 08:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720256172; cv=fail; b=B+7NrtzwHeCikHxMWBeqm+r4DpU3GoC7Zcm06hPbWSY9iZ3k52KtfyxFiaiO/Z2BQL2fSBvTiouxW1UdmnASKBAIiF/zqHqbACTaQZpVJtJWzAUTBnZjkXnyO8ve1jDykpTG5QUG868agjQuoqo76xVB9Sqf5wxUucVOWf6FuGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720256172; c=relaxed/simple;
	bh=3rn1boqzI9zsf5w0UTwRP/bFKB9pINv8F26QP4ydFkc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZecBoFvzTSkcaRsOqsPPU7sVdOOh8rTURYuwgGPYsruvMT1uj6nDRD8RCog8zKS+6pZDYXkO9L7YqRgLBh3f9tLO543kNwDKlaApIW29d81+gUPkD/tHPG4BChVDLgWIakJX8ecDjNi+Jdr93OVAx1+A7Qq4b5+HtPaK/xQosCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=HIRhDWVJ; arc=fail smtp.client-ip=40.92.102.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="HIRhDWVJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRcMV2ymQ7FuMZR/H5+ZPqKQS4hWv2Yd2Ss7/hA+yVyQr5HtwLPD2JyMX3l/J1vwD2r9QLsZTB/r6fFfyMUDBSR3izQm6lEMV/Nn1HH8syglmoXgbar3noOQRTuHO8j89kh5hAIKmiM6zub0V4LVFPCCt6Ao66oHoVNDhLzyuvDYbZPTamdhFJI2bzsRheyoh+EIRbYdZPtSicfgPpyMkF5Jz+oWRQJqC/BS5cdxeCGhKsdMShLTnJMmcW8Sr5nz5lwFCb75cqmAtWzQLUTLeMDZZSp4haIpwcyto6I29NmkwolyYMtJ7fZvBP8+KCb2xd+ikgIW8JtdPvcD9PlaUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rn1boqzI9zsf5w0UTwRP/bFKB9pINv8F26QP4ydFkc=;
 b=CmMyCozDlFqkCZEAltKXQ11TA61sAcX8TgyN3XPd41LK3SEESRH2zqzGahiIWlnTEO+7DeohcQiJWJPI0kdE5UGffDgT7rw42MM1BHykGsX3L+bEjp3TK+8Mz1qighrmogwBqUPv4jk6ckk1pIP32DXB2U3u+px6qjkE+TiDHATE/A2jUOLqaIgTKAxFmzsJmVVHunc+doDXoNkwu8h4uQuitZ9lBlZ5JgkJ7F5+bZhCokrghFG+84U6Qcnzw7RQvSk97wz5RbBes9J94b2eS7ljtSxjcB9lrOpcZXsAL9ncZOAfYHWK5sthAHvi2yCHXVY9tvvbpzSI014PwDxz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rn1boqzI9zsf5w0UTwRP/bFKB9pINv8F26QP4ydFkc=;
 b=HIRhDWVJgLHVf+9I1wUNGZqWyhI24QESKandBdTZgklopGKXcqtLBbma7kCd1DEhV9rWasyD3rIUsF/vQNiJzDUGBNViRmGQfsZLZjejVXVNJW88sZK7TnyTUTO+rwFSBTg2WaKoYRbo0BpgoONdT92mmt+3n7FDRWt8vXhFY70sOLtECjd1/myYnne+eGjUiFyeLid2G0EMk67JC35oatJTRKsXeQBdWYTFzesmsHXMnUWie5L24IR03XTaLFLYGi9Hem+IDSF43Vw+Fn28SbkyQEX/Bk73LYX6dgbEZS2x92k05HNz9FPViyE9ycC7WKjpyUNXnkSrVXsMtw8C0w==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN0P287MB0229.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:e4::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.33; Sat, 6 Jul 2024 08:56:05 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 08:56:05 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, Kerem Karabay <kekrby@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>
Subject: Re: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHazs1tjVgoALhhKk+BKEcu0nmxn7HpWxaAgAAL54A=
Date: Sat, 6 Jul 2024 08:56:05 +0000
Message-ID: <C5231A8D-C529-4BAC-9E2D-32F00321A294@live.com>
References: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
 <2024070649-nuzzle-movable-f383@gregkh>
In-Reply-To: <2024070649-nuzzle-movable-f383@gregkh>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [GPdUZXT4asxpZ3LfBHSn2wtR0HYZrIStz1K2baa59zewK8SE1SdoXoqmj0ci7Yls]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN0P287MB0229:EE_
x-ms-office365-filtering-correlation-id: d0140784-d1b8-4839-9011-08dc9d99787f
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|8060799006|19110799003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 tdHD0PBtb/6VECBsjwqHtvzvyxAudiuU1Kc+CUdpIqm/6DrENUAHzsflVQU9pNjCBC9XUI60h4BKfM7P6yxylVp3n/luYp+CnmkgUMdB4DHXwPDbJVayKV7XrkKJxGlLUs9kmnDdfBFAKqO1gqn5l5mLOwpqXnqUAZ4yVe0y7C26fz0gN+4A+bk7yIFuyC7jj9Nt/NuAOdEoHJm8b6URVkyzb90QkBqEvp+BSdNDwzCPshWaExFx8RMknkgbqz9XIr6HJhHAGTFgCfovB9UGldS8Xsbq8Wd7LYfFI+ygdFZ+Jdwjd7pfTamb6bi4aK54fb7sLeidBYOBVZuZkQBjwKtp16VE1FG1prwA+0a63L2RFg6mvDSHBStCS/UCcp7jOoZOpzvu4ct89LZTPiSx03x0GkEslqRwKbXvcZpUOUI5FWDIZRjUlGnwmTVE6UtHSpDqzqTlGfd9KkphXoPp/jv+aE1PANVQSJv5VXaw9wI3CeMU3l7EjpyiU374O0i1UR+xjJLBhGoYnM6futj9HldWSZr+SfAsnv0J9ySDCVXyoc8uafZfH0dDPIGCSdeS3NxdYnahasFBB+a/uOPozY8FTj8Xt3egg9lgP7CMnPRosjHwAhCB5jq5RK8xyT7qgMxszfPwrwx8pWfOItdzFw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N3hyMmx2Z1YxMVFXenJpVHJnbElUUG5ldEY0MjN1TUFNU3NHRG4yK3FrQXE3?=
 =?utf-8?B?YU1vVy8rWHYyODRRVXNPR0Rwb2hzRU5RdWxFbjBBRmJub2ppUUh1R0xtRW44?=
 =?utf-8?B?U0RiNCtydkVYRnQzcHVYUDBsZUZ0ZWJNVHI3MmNYSnpvNmRuQWJsN3hvVWFF?=
 =?utf-8?B?UUsvSW1UQnI4Uk9XT2ZNZ0FmUWZ3OTFaTGV1ZFRMV2JEdHo2b2wxcGtsQmdr?=
 =?utf-8?B?YWR2QUZ6dVlzQ1JHSWR3dVA4by9VSHlraDBGUHNNei96R1dCQWJjQnFvNXpM?=
 =?utf-8?B?K0NGVFBEcURyaFJBa1poeG5RWXJJMTZmMFhrZmVMYmZPbnNKMWEvNC94U3Bv?=
 =?utf-8?B?QkdFYlBMQWxINFdDS0xyaGhIbC9nKzd0Y1QvUWpzczBjeHhwbkhiY1hYTVBo?=
 =?utf-8?B?TjFzb0o2U0VPN3VGVHhvMDBxTTdDcFpKVHpJTk1BYTlyQlp3Wi82RTZpeDJS?=
 =?utf-8?B?MVkyNVV0WW5xd21tY1hCSmhhWmRDenlqaGZPMC9zaGFWVitvWVZHb0lzMmta?=
 =?utf-8?B?d25jd3RuZU1vL1VKMnZsdEI0V3RzS1R2aGluT0hOVE9OUm1aVm5GNkRTVWlJ?=
 =?utf-8?B?MFdzVmlORXQvbFNudVdLTWRQRVVQUU1UaUtkWDV4MGJSYXV5Uk1yZnFpaDlH?=
 =?utf-8?B?eEFVdGVJMG55ejl6bUJGRnFINjRBSExtMmRHNVo5TXdBMFptbll5NUV4b1NG?=
 =?utf-8?B?bXliVDYzamI4QWowRURHWDlRQ0ZqMnRzd1Z4WFRQbi9vZU9qM1IvQmpkVnZN?=
 =?utf-8?B?ZVJDbzZjZS9EQ0FjUUI1N3ZlSVBtWnhvUnhNQ2ZmaUtuZWV3UktYT2FIV3dr?=
 =?utf-8?B?OEYzajRnRFpaT0hmb296NlV5bFFiVmliRHZSQWoyZTJUbFk3V0lxWHZjbUNO?=
 =?utf-8?B?NUttSUQ1ZXN3K2lXb0FtYkZDN2JaY0lrM01DQ253Y0hhTzlaWUx5QXZRa2o3?=
 =?utf-8?B?SWgrNE5iakoyZElJTDZqeGlPQjljeXZSeUJEVkZZQ2I5Y0NEdEEwVjAvTTFq?=
 =?utf-8?B?bzE2THhneUNIMkhjT1U0WXFSZHhPOG1lQXRadWF4bGJCOWNHSGVPT0hta2dN?=
 =?utf-8?B?MXozWWJ2MDI1djdoTGlQMmRPQWlpUkREN2tjVXBXckROZEZaUVY3YTRrblVC?=
 =?utf-8?B?aElXUXJObFlrY1ozZ3NVL2p4TmJrQ21NcW1xb3VGbjZoZEZSVGhld3J0WlZk?=
 =?utf-8?B?U0Fka0ZHNkdyNmNJSnhoUHRaYXNhSGR4TnVRNlBkWlB3aWVXUXprU2xCeDlG?=
 =?utf-8?B?dnpKR2VwMys5M0xUWnYvM0lZQVEwU1lQYVJYb1pVTGhGK2p3L3VYVFVzeWI4?=
 =?utf-8?B?RGNKN20vRC92dkg1Y1dBUFpxNDZEQStxRzhzQ0QydWJXU2hqcW1WbE1Scklw?=
 =?utf-8?B?M3FBbVlGeFRFaEVRTnhOVk9JV2ZPalBrRUN5NmRtNVZvQ1Zob1JPeGpNMGRU?=
 =?utf-8?B?dWlYVGFET2tkeDFVL3hFb0tVenE0TjkvRVF0cmFXMWc5d3ljZHMwcDVsMmJo?=
 =?utf-8?B?T2JzWFZSKzdqbUJiU1lsTDQwaVE1T3MvV1FBSmozWUtyaHE3YjV3UUgxVEoz?=
 =?utf-8?B?eGh4dCt3RFhrcWZ1MythTjE4aHUwQVp6ajkrNlhjS1Yycm0ySkF4TUhSUWJI?=
 =?utf-8?B?eExsZXB3TEJvbGxVUjdNaEJPTlpJSlhzaHlSQjJRODRsZG9yRnB3azhyS2VY?=
 =?utf-8?B?ZDN3c29MaHpoOTJWSWppZXByM1QxcExXSFhlVllOWkE1NGpWSUZvWmd4V0Y4?=
 =?utf-8?Q?wQF5sztplswYFBn2GtGC7R9eqA1bRnXqF5na/S4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6BF59FDACC424478C0EA70C174B669A@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d0140784-d1b8-4839-9011-08dc9d99787f
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 08:56:05.6904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN0P287MB0229

DQpIaSBHcmVnDQoNCj4gT24gNiBKdWwgMjAyNCwgYXQgMTo0M+KAr1BNLCBncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZyB3cm90ZToNCj4gDQo+IE9uIEZyaSwgSnVsIDA1LCAyMDI0IGF0IDExOjIx
OjA2QU0gKzAwMDAsIEFkaXR5YSBHYXJnIHdyb3RlOg0KPj4gRnJvbTogS2VyZW0gS2FyYWJheSA8
a2VrcmJ5QGdtYWlsLmNvbT4NCj4+IA0KPj4gVGhpcyBzaW1wbGlmaWVzIHJ1bm5pbmcgY29kZSBv
biBzaHV0ZG93biBmb3IgVVNCIGRyaXZlcnMuDQo+PiANCj4gDQo+IFNvcnJ5LCBidXQgdGhpcyBk
b2VzIG5vdCBleHBsYWluIHdoeSB0aGlzIGlzIG5lZWRlZCBhdCBhbGwgOigNCj4gDQo+IFdoZXJl
IGRpZCB0aGlzIGNoYW5nZSBjb21lIGZyb20/ICBXaGF0IHByb2JsZW0gZG9lcyBpdCBzb2x2ZT8g
IFdoeQ0KPiBzaG91bGQgd2UgdGFrZSBpdD8NCj4gDQoNCkN1cnJlbnRseSB0aGVyZSBpcyBubyBz
dGFuZGFyZGl6ZWQgbWV0aG9kIGZvciBVU0IgZHJpdmVycyB0byBoYW5kbGUNCnNodXRkb3duIGV2
ZW50cy4gVGhpcyBwYXRjaCBzaW1wbGlmaWVzIHJ1bm5pbmcgY29kZSBvbiBzaHV0ZG93biBmb3Ig
VVNCDQpkZXZpY2VzIGJ5IGFkZGluZyBhIHNodXRkb3duIGNhbGxiYWNrIHRvIHVzYl9kcml2ZXIu
IEl0IGFsc28gaW1wbGVtZW50cyB0aGUNCm5ldyBtZXRob2QgdG8gZXhpc3RpbmcgIlVTQiBBdHRh
Y2hlZCBTQ1NJ4oCdIGRyaXZlciB0aGF0IHJlcXVpcmVkIHNodXRkb3duDQoNCklzIHRoaXMgZ29v
ZCBlbm91Z2g/DQo+IEkgdGhpbmsgSSBrbm93IHRoZSBhbnN3ZXJzIHRvIHRoZXNlIHF1ZXN0aW9u
cywgYnV0IHlvdSBuZWVkIHRvIGRvY3VtZW50DQo+IGl0IGhlcmUgYXMgdG8gd2h5IGl0IGlzIG5l
ZWRlZCAocGxlYXNlIHJlYWQgdGhlIGtlcm5lbCBkb2N1bWVudGF0aW9uIGZvcg0KPiBob3cgdG8g
d3JpdGUgYSBnb29kIGNoYW5nZWxvZyB0ZXh0IGFuZCBzdWJqZWN0IGxpbmUuKQ0KDQpUaGUgc3Vi
amVjdCBsb29rcyBmaW5lIHRvIG1lLiBJZiB5b3UgdGhpbmsgaXQgY2FuIGJlIGltcHJvdmVkLCBz
dWdnZXN0aW9ucyBzaGFsbCBiZSBhcHByZWNpYXRlZC4NCg0KVGhhbmtzDQpBZGl0eWENCg0K
