Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2088.outbound.protection.outlook.com [40.92.103.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE67F17722;
	Sat,  6 Jul 2024 09:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720256654; cv=fail; b=ah4nYzJFDgT77DGZB6nlp749umNfJCcfG0QPeedcAKMqvAdxS9rOPxEik/eVroSsHlC+XzmqJLLQkak8QgCAYBE/JfnrqTudd5Er+eO6hrCqJjzemty9pxx97o24MlH5XVFKRZtL0kmynjQHnWsGqCBkf4jB2jfmVYWub4ooh4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720256654; c=relaxed/simple;
	bh=jS4jJw01VxTX8HyFXREdngZosP8RrXwT4QPELFimGLg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iPqsVCkdm4S+Yv114ggmznEve+fJ9uFKUCZJqn8anNYm3jf3tWRfLbfiIS2fR3vMq6UHpqMpaSZgOATQi/6Z3msv+dgSSRcGuwJiCiMqxHDJLkvUshO3zvcdJdY3HVwY/QYZ9o87PQBinbHun4fdnjVOovjldA2YJov3LYSDn/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=QtLwKBV/; arc=fail smtp.client-ip=40.92.103.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="QtLwKBV/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tj62jUT+TrETcw6U1F1yAC986Kn4KkaqZPDbtgiCXU6m0XTYl3+ujLtxR32nfyqJ3CZTKZY2rDPPa2Y4PIJ0B+lDBJYfEKlaPB15Ewnyp4BnaX5U7kZREasTcuG6NI0C0FrhZvMdbhoVZGKppHXZSPqGAWy84k/CofgolxyGSWNg18eUb+AugOOwCdmtlbkxmhwtu7UJAdWpW6lpJiN9em7wRGhYj1clqwnivpqw9bKmSP4JK7jRIQal+Q+t7BpVj1hO8dG9ro9Z5yU6rU3FXimgEENXQw8Y+kis3d4ueDRFKnvourulfKpcinE2gAOjIqzkeESKgEZkZp2P3A9AsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jS4jJw01VxTX8HyFXREdngZosP8RrXwT4QPELFimGLg=;
 b=ZgmWqWRxaOm5uPCFYLZP9TEkEFtuVlxm/vfRNnNKD4qzLFC27sYX1sxdlhg/RX0IBlxm5pSSWZsiLXj3WRmA6unsB3PetENjpyo2KZl3pFvdC30liGDUtQdcq48TIRLfanDk0eu4VTW7B3w2qATWpTEqrUDIw9CN1QwFQJpLT2RupYGpc+Y42pjBtHO5KGSeraXiW78wA4qb0wrbtvDfCqIcTDwgoKida2ByWTOS2WJYGqHWU/fuQd27/v5sy6zoop6hKpLh+8me8AQNp9JEN9GU5IflaRfzqF9Te+SRSRnIYgY5wk281I0ZvUHGwKm87wBl9FPJPc48hhF0HKVWEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS4jJw01VxTX8HyFXREdngZosP8RrXwT4QPELFimGLg=;
 b=QtLwKBV/hIDLDLQwnpQ7YzhYuk0MfiKWLDAQ3ZlihE//TPpPD09V193C4yxIX0tY5eMOJUaH5tXtMXgeU05bAhnaq5s1tsd0I3cLO5Q7TY+UT21kWZieJl6gbcZMR1dGXB/pozjlugkTGqIKqSIRC1xN3jEpBTKFKdGxquogRWWjOBl/3IGQ/HHd128EJkfFuk7kvPWeVHaLZUYMc4YyC4j+kcYOH6icIFAULf36sUxT9NyM2H2ghhi6cErV2huXQBwvUNNG8YO7lrxlN/3BO5V0/LvdpJbvbGW8vKBVf/KzFmcgV16xCxu+5Kj5NMD8kSw8wWlk1GRKd/U6pWpWXg==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN2P287MB0303.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:dc::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.31; Sat, 6 Jul 2024 09:04:07 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 09:04:07 +0000
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
Thread-Index: AQHazs1tjVgoALhhKk+BKEcu0nmxn7HpWxaAgAAL54CAAAHQAIAAAIIv
Date: Sat, 6 Jul 2024 09:04:07 +0000
Message-ID:
 <MA0P287MB0217E5151DBF1D0813FAFE00B8D82@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
References: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
 <2024070649-nuzzle-movable-f383@gregkh>
 <C5231A8D-C529-4BAC-9E2D-32F00321A294@live.com>
 <2024070622-alarm-kissable-f446@gregkh>
In-Reply-To: <2024070622-alarm-kissable-f446@gregkh>
Accept-Language: en-IN, en-US
Content-Language: en-IN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [lqkRjXrEypxsS9oRNv+53JSku8/R9Tehff/wunDh91xJ/8tZRng5tmtM/F0mgfcDEyhoZGnXtZ0=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN2P287MB0303:EE_
x-ms-office365-filtering-correlation-id: a0f0f820-18a8-4dfd-8e6a-08dc9d9a9795
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|461199028|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 gIXQC5QFHAK/Mp2hBSKJwQMWSRpO+7c33rdq8bpz8Ey14W0KaPJlDamaodQi8q8BGw9R/IbGFTamwzy11yCuf6HdxOgB4jSU8kHA5BS+WFLQ4+1+EwFqGYkKmzShTFwD+lm5I7ajX3KnubZimNfOH1M4wlNVeJYocMxm/+lmsRnSuTTrgybQPlrHZW+oC3bWkloiOoZXkz0t8x5ktiNJiwwalXyMZZaUocqrn51d4RPp8PVizvo7Q11Miw+5BLe98kRsNcFA2F7vEH8Tf+UzaXZFC/bVnSBywvLA2NGdY4l3yQA3gawG2cs7WixQEdWtpsAxZy4HkZG/qBQtqYc8eXQrtKczFW5XzhHZarSgrhCQ7WahGTnovIjhYCfhcgdpA+PrRuso41foh3p7t0PQetpPlFRxrpGBMw+921WpatwKFl5qhXbWdIe/7v1K0y/ogLdMJQ5OO3cXNqIXMvae/IEAoDL3FoFpnyUICK1IP93Rj6PWWza7Af816FnLdWlCvXlNGey6oN8xNFYg7JcEgCTOQFtdWsB3CvJ7VyiWdlriJcGNjfUbnhgkmypQAn8jXztDRcr150BvUCNarieSPQIfy5gw35VFfCPI/fYnOMY3kqi4JsdScDZNDYFRNGhBHPxFpDnW71cShWpfGSPd4w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WWx0SWtKcU9OanhpZCt5eW8xTGxVTCtHT0YxbnBORHZKcWFtMVkrTCs0Ynd5?=
 =?utf-8?B?c2Q5bHZJSlMrWXpzZTcrVlE2RHJPU1EzZUhNNXA3Wk55ekltZHM2cHRidWZZ?=
 =?utf-8?B?amtINXJKRE8xV29tYUpOOFkzdWNQdkNTK3JmT3IxYkpReHUwcVI2V2R5WXFU?=
 =?utf-8?B?d2JWVk0wRC8vUy9LSktYdUk1WG91bTZ5VzhPczMvNHpZdENMOWk2OGc4d1Ur?=
 =?utf-8?B?YXUwZzJzR3JOamJ1VlpPc0EvVmtRVkt0OUN3alBtWjk2cXlDTW5laUt6Umg1?=
 =?utf-8?B?djF5d3BYdW95V1ZQOTRoZlRpYW9GNWNHakM0Ym5GVjJpNjlLbCswK0tzaVR5?=
 =?utf-8?B?c0psQ2N5UlZYVWpzMFYvRU4vK28rUEMrRGJ6a0FCaVhGWWoyQzhCcGN1YUs1?=
 =?utf-8?B?Rit2OHRzZ3l3TDMyZ0U4WEk2RWVsN2NrQ091d21zMk5HZkRhWk40OERZcEwx?=
 =?utf-8?B?WTBNQk8yMHZTYTZ2ZzFISG8zMFBNQjgxZ0ppeXVqb0RzZGdvekJjdHVCK1I3?=
 =?utf-8?B?Wng3dm5FUmh1TEpXVXlhbUFrQ0o0Qml5dk1qZGIzQkNEcFMxemJhV2R4L1dz?=
 =?utf-8?B?Zm0vbjNJbWpsUnpPKy8vWWd6R1JlbVd1QXZhaXVNVEhxYThxOVp1a3RBOXhi?=
 =?utf-8?B?UVlPYm1Ja2RTRFZuaUFYcjJlajRjTWxFZ25TSENURllNSnNFMlczRkxMTUMx?=
 =?utf-8?B?Lzdpb3hTSjVlMzQxWWNTV2hYZHRiR1BFSTVTZjE1NWIxRU1ZSzRRMlozR2c4?=
 =?utf-8?B?L1NEN2ltaHIwNFkrOFpFa1kzVjhqTmF3LzdYOGUwLzdTNHNDemR0UW0wc1FK?=
 =?utf-8?B?UUVyUDNRTFQ0dVUyOG1GcS9KcEwzSnhOTjgzOURHNnNHTkpSUjJHdllNY1dV?=
 =?utf-8?B?aHhZd2E4SnhJN1pYZ2VUcmRyZlBEV0wvVDZxbVFvTWgwbHN4U0RVMlJrNGNz?=
 =?utf-8?B?alVHQ28vVFpwaDVKUUtJdkovQkhMUG9YcU1yTU15Q1lpbGY3N0NMaDhYRklI?=
 =?utf-8?B?dDNVMjNjQmhwRFVYa3JmbFkreG9ST0cvQTZmMUdVZEVYdnEwbzZtKy9nVW5n?=
 =?utf-8?B?VHpOVDJmTGlGeEVEWmdHY3lDdEhqZnZMMWljaW9pR25ZdGZ1R0FwVFlwTEhu?=
 =?utf-8?B?Y08rODR0L2xQc2UycW81VElUd1J6Q3EwVkhxenZHZ2R3K1RHcU9NU0lkNGov?=
 =?utf-8?B?TDRaQzRUNGVlVG80SEpOdHVYUlJvUjJVdkhHS0RsdCtrRnYwazZMcVpEdjBq?=
 =?utf-8?B?OFFqUy80eng5OUsyQ2dFOHc3TGVLZ1FobFMxZGYzcHNOMGJuWDZYOUdjSm9i?=
 =?utf-8?B?TDVqZ2hIOHVkajgyK3k1TXhlcEl5dXNERFo3TDMzUkRMQTNXNWxmcUJOdzRv?=
 =?utf-8?B?L3daVFNpSkEvUXJZWHEyekxpblN1Z28xVWRPWnhqMmg2ZXlIcTRSNHBITnlU?=
 =?utf-8?B?UERjOHlIVVhDczdrT0M5VitqcHNFQVNYZlBURG9OY3dhU2FvcW5lN1YwRW5x?=
 =?utf-8?B?akt3cnUvRGkyWWNvQm9lRUYvbVpHVFM5N0o5TUdaYmdUUFdkL2hyT3NyN2t1?=
 =?utf-8?B?azE1RlJpN1RSTFkvRDhVdUgvNmRkdmRuMW9tbUUzMk0vMWFETEFvNTJwQWhr?=
 =?utf-8?B?T0hvTGZlZWs1aVd6Rnk2SGllYmFyeTVqM29WZlo5VTdHMDRORkZxdXo0c1Ew?=
 =?utf-8?B?UTduLzFEaENqZVZyYXBwRzlxRUJjYkZHS21PT0FVTWFzVWtQR2JhRkZOek93?=
 =?utf-8?Q?A5VZ4QGqKSnw2zVUGw=3D?=
Content-Type: text/plain; charset="utf-8"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f0f820-18a8-4dfd-8e6a-08dc9d9a9795
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 09:04:07.3159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2P287MB0303

DQoNCj4gT24gNiBKdWwgMjAyNCwgYXQgMjozMuKAr1BNLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gDQo+IO+7v09uIFNhdCwgSnVsIDA2LCAyMDI0IGF0IDA4OjU2OjA1QU0g
KzAwMDAsIEFkaXR5YSBHYXJnIHdyb3RlOg0KPj4gDQo+PiBIaSBHcmVnDQo+PiANCj4+Pj4gT24g
NiBKdWwgMjAyNCwgYXQgMTo0M+KAr1BNLCBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZyB3cm90
ZToNCj4+PiANCj4+PiBPbiBGcmksIEp1bCAwNSwgMjAyNCBhdCAxMToyMTowNkFNICswMDAwLCBB
ZGl0eWEgR2FyZyB3cm90ZToNCj4+Pj4gRnJvbTogS2VyZW0gS2FyYWJheSA8a2VrcmJ5QGdtYWls
LmNvbT4NCj4+Pj4gDQo+Pj4+IFRoaXMgc2ltcGxpZmllcyBydW5uaW5nIGNvZGUgb24gc2h1dGRv
d24gZm9yIFVTQiBkcml2ZXJzLg0KPj4+PiANCj4+PiANCj4+PiBTb3JyeSwgYnV0IHRoaXMgZG9l
cyBub3QgZXhwbGFpbiB3aHkgdGhpcyBpcyBuZWVkZWQgYXQgYWxsIDooDQo+Pj4gDQo+Pj4gV2hl
cmUgZGlkIHRoaXMgY2hhbmdlIGNvbWUgZnJvbT8gIFdoYXQgcHJvYmxlbSBkb2VzIGl0IHNvbHZl
PyAgV2h5DQo+Pj4gc2hvdWxkIHdlIHRha2UgaXQ/DQo+Pj4gDQo+PiANCj4+IEN1cnJlbnRseSB0
aGVyZSBpcyBubyBzdGFuZGFyZGl6ZWQgbWV0aG9kIGZvciBVU0IgZHJpdmVycyB0byBoYW5kbGUN
Cj4+IHNodXRkb3duIGV2ZW50cy4gVGhpcyBwYXRjaCBzaW1wbGlmaWVzIHJ1bm5pbmcgY29kZSBv
biBzaHV0ZG93biBmb3IgVVNCDQo+PiBkZXZpY2VzIGJ5IGFkZGluZyBhIHNodXRkb3duIGNhbGxi
YWNrIHRvIHVzYl9kcml2ZXIuIEl0IGFsc28gaW1wbGVtZW50cyB0aGUNCj4+IG5ldyBtZXRob2Qg
dG8gZXhpc3RpbmcgIlVTQiBBdHRhY2hlZCBTQ1NJ4oCdIGRyaXZlciB0aGF0IHJlcXVpcmVkIHNo
dXRkb3duDQo+PiANCj4+IElzIHRoaXMgZ29vZCBlbm91Z2g/DQo+IA0KPiBJdCdzIGEgZ29vZCBz
dGFydCwgeWVzLg0KPiANCj4gQnV0IGFzIHlvdSBzYXkgImFsc28iIHRoYXQgbWVhbnMgeW91IHNo
b3VsZCBzcGxpdCB0aGlzIHVwIGludG8gYXQgbGVhc3QNCj4gMiBjaGFuZ2VzLCByaWdodD8NCg0K
UGF0Y2ggMSB3aXRoIGNoYW5nZXMgdG8gaGlkIGNvcmUNClBhdGNoIDIgaW1wbGVtZW50aW5nIHRo
ZSBjaGFuZ2UgdG8gdWFzIA0KDQpSaWdodD8NCj4gDQo+Pj4gSSB0aGluayBJIGtub3cgdGhlIGFu
c3dlcnMgdG8gdGhlc2UgcXVlc3Rpb25zLCBidXQgeW91IG5lZWQgdG8gZG9jdW1lbnQNCj4+PiBp
dCBoZXJlIGFzIHRvIHdoeSBpdCBpcyBuZWVkZWQgKHBsZWFzZSByZWFkIHRoZSBrZXJuZWwgZG9j
dW1lbnRhdGlvbiBmb3INCj4+PiBob3cgdG8gd3JpdGUgYSBnb29kIGNoYW5nZWxvZyB0ZXh0IGFu
ZCBzdWJqZWN0IGxpbmUuKQ0KPj4gDQo+PiBUaGUgc3ViamVjdCBsb29rcyBmaW5lIHRvIG1lLiBJ
ZiB5b3UgdGhpbmsgaXQgY2FuIGJlIGltcHJvdmVkLCBzdWdnZXN0aW9ucyBzaGFsbCBiZSBhcHBy
ZWNpYXRlZC4NCj4gDQo+IFdoZW4geW91IHNwbGl0IHRoZSBwYXRjaCB1cCwgdGhlIHN1YmplY3Qg
bGluZXMgd2lsbCBnZXQgYmV0dGVyLg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCg==
