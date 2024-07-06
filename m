Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2082.outbound.protection.outlook.com [40.92.102.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFC24778B;
	Sat,  6 Jul 2024 10:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720261228; cv=fail; b=UFoUzbJ1TZVDH90ngizTyLSuOlOGIvzBzBlMyZ/jlvJZBxzZ5OxLJB1sRf/MV8k63SQdYF1DzyYHI0W7gNA/yHvDrF7ebmV+brDfle4MANmMW51GRMc0IOVMS34VBiA5WYdQqAw0MehjCts6WVr7NURRmzZRjiX0d/oupYnfQe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720261228; c=relaxed/simple;
	bh=rlL78uf3WWpFVGUar9FgoIvnHGYgtsKaElJmotAtGYA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mt0uuaoKzygCcidG6SYTNDkt3wehdU7J+YfnHl14oh9377LQQvr986cigaTW2JS/C0P01sqmjFmIvtK7kHA1DOt9eFd7UcUflAE4t8VUea+sRkc+IEjcxV5R7sa/u5er3J0CNoBAeh17aKhqpuKqI1ylgAwVNH2RP4vX8CZSqk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=ISiQhMA8; arc=fail smtp.client-ip=40.92.102.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="ISiQhMA8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvjbTFwfi6NdqMZcQstbEoOgEZ1AeBXd+ZtCKZawRgXRJB1zYlZyV8oYtlhQ67RFAjDivXdO8kfVQ8OtT7x1h1I4xIu/pkWTFgKpvq5eHV5vxayEUVQRuv4i16O0OBizRjHCEsIGwU9rWU/eeYDaIUpaJ8GYKdLjoJvXGKbD4MuR9/bEQqLl86w5LOH73XYUphBmGDC3pCeI0hUOzHNKrp8uTCpVc2ej9GrZUqeslqlwIHDBE0BUC5irUyCCejh1QW9IKAhdFeUjhS/BXbZU1TYiVr6uKuMVpl2/4+nJKZzio6x5vtEQzhfX/I1XmrF7p2l8C3Y/FerXQMV+DLT4Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlL78uf3WWpFVGUar9FgoIvnHGYgtsKaElJmotAtGYA=;
 b=WV45zinfDa+gDn3kSfg9LmbJtwoCK26g4kd9fonpBhFQLj0IeHiA+puLcfhylyXDuMKrNloA2wPgLyZFJJ1uXpt2gLVLZ4ZWuZdSS9x8znmQKyxRxJ/suIA4gy6adzps2sziR1yZbYSezBJ8o8PvQuLxeBXDD3kOyQfLUlJEHezx34ZIh1C10nnguyVhJQtTjJJHLWmJL/g6af8A3h0RCXxZTrJ/C9wcjJPweVImR0ZFLFv40RgvFonWLQt4Ugta1FHncGCr2Lt2B14unmuvnHtnyu/VKj+e4ncAAzrbrCBQoTpF4AmMhM76ES+3YVp1VOmi/NdTaAHGMe9mxLdycg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlL78uf3WWpFVGUar9FgoIvnHGYgtsKaElJmotAtGYA=;
 b=ISiQhMA8WFaK6tdKXXbJfXSjn+j9A4kVIt1re2QGBq4LCBhmt21m5dDmhg8iXSHGuzaqf9zRMu+BLkP/xxPMY+fjjnZEBOHDvMSIvXK9gEuSXtNTqj8gLxpikcRKz1ckVhZwY/lhGzEuelPDq4jHVrlRbRmi1ZE1cNaWx2S0T9tj+mBSAJJY5Nu8Kf1cJy9cNtwOZf59b9hKrLui3HtF7jXlt6VnF3m91Z0yhgS62jY5GD01hTp7GjTj9lwxhNf/4a9Qb9E1SLDCjO8OarHGkq1cVDIL+Umo9y6WiFBzcdIdysCmc/aml12L5oXgjOtL3mtNJ1RJMemh/405H1ZvcQ==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PNXP287MB0029.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:c7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.33; Sat, 6 Jul 2024 10:20:19 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 10:20:19 +0000
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
Thread-Index: AQHaz4t+8wEhfBXSYkeB85QpAZZdlrHpegEAgAADHJ8=
Date: Sat, 6 Jul 2024 10:20:19 +0000
Message-ID:
 <MA0P287MB02174EF48B5319A27F256AE4B8D82@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
References: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
 <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
 <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>
 <2024070603-deniable-slang-f93d@gregkh>
In-Reply-To: <2024070603-deniable-slang-f93d@gregkh>
Accept-Language: en-IN, en-US
Content-Language: en-IN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [vAE37WoZTL6DDLNidmVWwD1FPqnyOESleG/EgTt/F2+8EgBnpvTPq8C77JPIV7fE8LlpNlhD9Go=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PNXP287MB0029:EE_
x-ms-office365-filtering-correlation-id: b36ad4b5-e496-4dcd-c620-08dc9da53cc7
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|461199028|19110799003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 hoGhT4KjgxkgXaKbSzxBvFv6nVJIJmA7JDjMZWMfUrfWXZ/nXMXybUiJjdqnxJO7R4TeVM4RqMyI7MKbarxPlfEmVlARhrWmnsYedwCpaFEL/AByL2QYdPMOb/ibiAjpOYRDm7NMpWzTlCj5XJYd2UVj0KQJe1T6jZkdWN1GPyKpqhEpLh/PIeuUYFX8H7Xi/52aeYEbtnWOBrX5h61v6ggscq5WOD0j1/jPIb+Mi8n0zEjDGpFB+8eG5Rn/KtPbDhm4FHF0EHEcVcmbpESvv45Iy6NVhTnMfGM6kQFhKXsSh/Plzz15P9WYrqnbr3MdN7pG7jIjyibyZPQg9l7NUZbR3xClqldK8Db6jhRN8eB9hyriZoiMPNs4MtPYg2hzWoAoVv7V3USfrwozenYKCMXzrbDm/UItM9YCTG9e1UPF3XagAzEtsj7ZUCFIfyK7D7gK7GjuO/YAnQeieozTVmqiF+MgbFPZeqe/ihJt5pBJgUpSLeQy5bqb1Grs5pM0yd9UFLHGuQ1b5C0Jcw7KNOtB1TGeO3qKu1uau/VIk329xEznFbYXas4mwECgdHtCqB3IgdjRg3tu9ALBQpY1YdFemzv8JdEKaaQvm55rCHUKsX4kk4rjlitLP93/wUt366XUQcE0/w2Uce0aB79R0A==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUZDY1lxRkY3UlZFbElNeWdIdGZ6dTE4d1dmem5GSmpQYWhycnJkdUpKZTlS?=
 =?utf-8?B?NU5EV1E5bFdCQVNUTUg1YWR1OWFuVVBlMEE0LzB3RTF1ZXA2UkVvMVRYWi9S?=
 =?utf-8?B?dk40RlY4ZFNGMU9DcU5RSEY3NzlZeE9xMjUwdS9iL2pBL1dNcmFBeDVQcW9P?=
 =?utf-8?B?WjNyZGIwREZURHliMXlzc0ttRUNSa2l2bWlwaHV5VTh5UmlyYUFnZEpWWS9L?=
 =?utf-8?B?cGtBWWZMZS92Lys0NWRUamlsTmZMRjdiSkFoNHpxak1jdUJjWjBKZ1lqbmRn?=
 =?utf-8?B?RU5wWXhPdlU2V3pibk00TjNMWVpobDIvSWxWam1hYVR3TElUZUpRU2JBUVFx?=
 =?utf-8?B?NEJzeGQwcW13SkFQd3ErNnExUkhvbVM4Mm1ZSk1hVC83ZFdpTitMai85cHFF?=
 =?utf-8?B?RkNhTTh6Q3Y2R1lSY1ljMGF6KzJUd0tKakNaM21BK0diSUszK1Fzb1pMSnF6?=
 =?utf-8?B?T2hXU2xTbXFESnpGc2VJRHhPRjN3anE2R3lJUjkwSmF6TXNrRzlDdVR4YTd5?=
 =?utf-8?B?Q3Jwek0ybzJCM256K3RsZ214UGk4VHdwcTVzVWE2Z1dUZmlXbFFscmhBeVdE?=
 =?utf-8?B?SVlTUy83ZFg5WElpWjJBNUJPK2daVkMrdnlrQkFCbjVGaHFvZUxLVUFLY0Fm?=
 =?utf-8?B?andrV3lTUitwZHdSb0pTaGtjYzRFS1YzUTVTRjcvc3phbk90emx0V1Q5YVhW?=
 =?utf-8?B?MjljZ0VmOHhsd3JaNFJlZHZ0N3UyQVJkUjRweTJSdG1WdFVmMmFZMzQ2MStF?=
 =?utf-8?B?YitxMFVpZnN5TWtEaXgxR2xZbmdpeTRnRUFPbFRwTDBHM29SSHQvTndWNzBZ?=
 =?utf-8?B?T255bGdiRThXQjUzRUZCYWhWS0JYc1JyK2pYYXcwNnlkeTF3ajdSL0JMSVRK?=
 =?utf-8?B?cXBaK01TMVhGVmgwYmkrWEcybHh1YzJQak80RzZwVDBJdnl5b0d0Uk44ZmtC?=
 =?utf-8?B?N0x1bU5HdVUvSjZ4TVk1a2xoMllEZHRXa2d5ejExRVNtZlhRSXN0UCtPbDh4?=
 =?utf-8?B?RnVacTFIMSswMXB1bXZIQjJuRUhuTlNEUnh5YjBNUmsxUUpSUVFqTXA0bjdj?=
 =?utf-8?B?QkxzV241bFZmbXUxbHVpZ001cEhxUmpvZDdFSGNlN2lvblNmTjhQZnpDdjFy?=
 =?utf-8?B?YjdpUW50N1MzbjZDR2hkMkRhVHUwdXNSeXpuWHlHLzdRL3BiRzZ2a1VxYkRY?=
 =?utf-8?B?WWkvZlZ2VGNEVlJGeWNzK1puTUNmUlpzanVqMHBYbEZuU0VoVDRqQk9peGVn?=
 =?utf-8?B?SHhvTFVjckNkaEdhRGdFQ29JeE9rTWtlVU1xN05qaVlvTUtHVVlHc3FTVUZj?=
 =?utf-8?B?L3A2K2RwcnVSN3NvbnNVVERZQzVHdHBGY2lxWmYxTmJUSGRzRHRuSTcwRzdv?=
 =?utf-8?B?V08wbmdPc3VtbUd6aGdKWENyRk5CVzV2SFJzN204Vzlwd29RSTZOUnQ3Szlo?=
 =?utf-8?B?N3MyZFlXZC85R3JsMndsS0NQRXhqWVM5YkdUZ1dxZnlpZ2JtRFBqcWx4RXNR?=
 =?utf-8?B?a0VBRGRWeHFvK1pMN1BtRGZ3a1lNNmRmL3dBOFRacWhCWmtRV3dLZEVqeHlE?=
 =?utf-8?B?ajJBdytjQjA2NkpadzJLeU81TDkvOGUrb1MvUnQ4QkdaUWRuYkw0YUtvbkU4?=
 =?utf-8?B?Qjh1YktPekZKNDFrL1d0VjBrUjhjUWo5MGMxUUc1MTBlbFRxTVNkSzdCWFJl?=
 =?utf-8?B?WGRZMk9leCt6TGVid0tyMmJjem1KQnMzckdKd2w4ZnJlL3MxQmtsc1c1WGt5?=
 =?utf-8?Q?t5yBaLpX3wzi43SoDw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b36ad4b5-e496-4dcd-c620-08dc9da53cc7
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 10:20:19.4604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNXP287MB0029

DQoNCj4gT24gNiBKdWwgMjAyNCwgYXQgMzozOeKAr1BNLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gDQo+IO+7v09uIFNhdCwgSnVsIDA2LCAyMDI0IGF0IDEwOjAxOjM4QU0g
KzAwMDAsIEFkaXR5YSBHYXJnIHdyb3RlOg0KPj4gRnJvbTogS2VyZW0gS2FyYWJheSA8a2VrcmJ5
QGdtYWlsLmNvbT4NCj4+IA0KPj4gVGhpcyBwYXRjaCBpbXBsZW1lbnRzIHRoZSBuZXcgc2h1dGRv
d24gY2FsbGJhY2sgbWV0aG9kIGFkZGVkIHRvDQo+PiB1c2JfZHJpdmVyIG9uIHRoZSBVQVMgZHJp
dmVyLg0KPiANCj4gQWdhaW4sIHNheXMgd2hhdCBpdCBkb2VzLCBidXQgbm90IHdoeS4NCj4gDQoN
CkEgc3RhbmRhcmQgaW1wbGVtZW50YXRpb24gb2Ygc2h1dGRvd24gY2FsbGJhY2sgaGFzIGJlZW4g
aW1wbGVtZW50ZWQNCmZvciBVU0IgZHJpdmVycy4gU2luY2UgdGhlIFVBUyBkcml2ZXIgaW1wbGVt
ZW50cyBhIHNodXRkb3duIGNhbGxiYWNrDQp0aGlzIHBhdGNoIGVuYWJsZXMgaXQgdG8gdXNlIHRo
ZSBuZXcgc3RhbmRhcmQgaW1wbGVtZW50YXRpb24uDQoNCk5vdyBsb29rcyBmaW5lPw0KDQpJcyB0
aGUgYm9keSBvZiB0aGUgZmlyc3QgcGF0Y2ggZmluZT8=
