Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2058.outbound.protection.outlook.com [40.92.102.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471F3A95B;
	Sat,  6 Jul 2024 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720260987; cv=fail; b=jaymKv+YI42o/vO+D4dCnKqdFl6JpKhsrieoVv23Qo1echzBNVZWZj6IR/IY5YdVGIdjnapflnAE+kqwo3tRdRVSV5D9Za6QiKp9o4v5yj5JCEXRMsLwglMTxr3le/YXOQHd4BXQ1kSEBaWUEsxhF9/lQ7InbnbyRAqkc9IKHj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720260987; c=relaxed/simple;
	bh=q8uPmxbEezjNw+MNAG9+Tw/FLfDc4xqkJCSFy31RFkw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qSGCxx7j3nDGpoPXT0U0hil8CkqsRBbwNlXCeNs6gW0D5MKCxzVMkaxPQaUt43iOpp7tF+jQmeWi/uQG6u1WnFp65NJGCyRYRIbBi3rJe57Wr0KY+lauAeVlN51Ja0P88qoQpG44brLBsXkP4kpA1ZSBtcU5na8hs5nF+3RCZM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=QKuC1Kur; arc=fail smtp.client-ip=40.92.102.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="QKuC1Kur"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnC+UxJH919I0NvudFf7NIYzSwHxCH9f27pXWsA2clg1k6i3RRHdx1A64232BJAOaRz0h14U4YtmW0qkVIMqHKmQib575Pn3pTK64jTs07Ot83ffcMFJ6GzMnYxTApBzQpojfcJGzuHSIK6FgpPSS6QmRlKmEr7GuuMlEchc9NaIJozcTaGyPyBRZKTsdDk40dfKEYHMnGO/KALNmyEf9H94kqVrew5QyuLIm5fN+b57x192+aeNg1q/kbwo8uCaYZHOaHER76aP7YwIpLX5shnGEwGnhP9Kp4YWt/uPK0/kmM6bPBCfMN2eKcl8C1/XR7/B5LWZ/5M7611O5zHekA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8uPmxbEezjNw+MNAG9+Tw/FLfDc4xqkJCSFy31RFkw=;
 b=JnVUCmqXeJ0w76R+q42sKiQnLwf1sBO5GZD8WIfNPSK3b558ZFoGzogxGrPTCAJJ1nMUrHTEQ9e+BXW1lIIAyfmog7OcRVijuEAhJl4vCLhMAOTAveuKmoKQTeKbiLlD57TSN45sSptCz33gzSOSPp4EsAGksfLSsyBsGhBAHH/uQBWj4r5b0/T54ydsixL8hB0BvrmnAldrf0fI4n26jU3fPlQFJXUGQ4fnbg3YCHJcOk880+xVeQt5py5u8BCYhPjYjl2h2EmnWJ8CxzEvaK/ikfTzzZVv+w+/A72p/Ky82mCjxf79iVi01nGrDgd+moR755pd7HJ/gsYp6ZzfZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8uPmxbEezjNw+MNAG9+Tw/FLfDc4xqkJCSFy31RFkw=;
 b=QKuC1KurUKJ9ciIzEOReHrAfIJFGzc2UAzvQtXDLQIkca0ChtpCJ2F8nX1JbPlslgZT0RB+ZGnS0PVbxubXbcURimt1QeRgX7TTQaI0icNTexgsRLK3aaZ0ggw+xm0MRMbc3fqNmEvdW5T1u/fY7LXu10iR32XHdX4UAn1SFifspLWeysPplaKRbMR+ZJmk3jPEPQlXU20P/9RhdikzLBUioNroDaNcDdEFL2lOGz78vwdXsMC9nyD4pJirJMmqag4Dq+eTpgN+ih4HDXE5kaWiuqQZ54zW4/58w4zn0rhaYxyX8Zdxqqz3q+Ww/jLgSBPK52vob+yzx0Kgzd0NULw==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN2P287MB0983.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:136::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.33; Sat, 6 Jul 2024 10:16:18 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 10:16:18 +0000
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
Thread-Index: AQHaz4t+8wEhfBXSYkeB85QpAZZdlrHpefEAgAACDYY=
Date: Sat, 6 Jul 2024 10:16:18 +0000
Message-ID:
 <MA0P287MB0217CE452C944EE1093E6081B8D82@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
References: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
 <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
 <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>
 <2024070636-finalize-chop-f98a@gregkh>
In-Reply-To: <2024070636-finalize-chop-f98a@gregkh>
Accept-Language: en-IN, en-US
Content-Language: en-IN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [WfSlyzl8i6PigxKUHH6IPx+3kRat5bKj48IJi/xvkcR1S1hBzG2iGuCS+dj8zReoYiJuSLhG8XM=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN2P287MB0983:EE_
x-ms-office365-filtering-correlation-id: f47eaffd-eddf-4dd3-7659-08dc9da4ad28
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|19110799003|461199028|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 MkRqDl3soWmPaZLZCbbzvvD4Wlr0XCeuAU0tl4Nf8PQqj/ysOPqQZramO+fvZzGrzGp5QTqUvIc1UG9iEI5ObUuFkqgrsYBWQygvCrgu4Xa7LARsHpmjOa+yCFX9CJqtc0I++wQoFdjvsutfoEn8+ft9YVLjChWyEKvcca4EO63Ibl9MTVEh5zOvYmibsO7J8NJYR/wJ4T+SHkuovSC+hko+Yb3kualwgPk1Pl2d7L8VkFVURa8lfhpVKqItWhdDHPWRVA4cf48s85zTz3vV52R2+nmtGwohVCOLinZLyMcar8ym1i2VUf/dU45C68PXQ/l1tCkgs+z5CKiof9JpPGxEihiDjJ9+EYWM0it+A1nEEsDfy4C2hkIo7E2TVg+cuwU7ZZDydyMN69E1awpFMB4Zc+thL6ufv8HgCE2HHqgcg95c26sm6q8hQalpW5K0dswWwW4sFtuk7tMII5HqUzrR4r72wyiNTMOzwkkUFpijD+xYZaEnjTvmthrJiqTZgpIVoriG2tA8TCrx+YM5mGeCUqlyY8LIlMHHZbUD+Sr63BRNjBVVOFtOhY0paV/r801mDPBuOTDaErhEFUry7fnePqRs12VvrbSW/mgcTETNd/djRlULNzqi3qpn4jNbSKlJG8uo58xp0V/nuHmlqA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b2txOTY5T2hpMG9CWVFCYU5xbWpTajErZnNKS1VyT3VSWDg1Q0o5WUxuaVBO?=
 =?utf-8?B?N2Y0bTB3RTZLN0E5dllicFZQbGZFb0I3RHAvaGprbjIyZ0lOWFBxTXQ5MWRS?=
 =?utf-8?B?L0w1WXZoRGF1RDMyUFMxTXA0VzJtemd6VDVXOXE1ZzlpV3Q4QmVYRE1MWmFj?=
 =?utf-8?B?ZEpIVmxrMHBHRlZoUFllODZ6bmNjRnVVQ3BDOS9UdWl6SmhqNHFWM3U2WW9B?=
 =?utf-8?B?SFNwVW9MUlBGbmZDMGxtWUZ5M0VPMG1TVmwrY1JQaDJDb2lHMDdvMlJnUUZF?=
 =?utf-8?B?dGx5QjdiMXF1R0lMY2Ryd2RFdFlocHlaalJqWGRUakZwWnRvcFJ5WlhTeGJp?=
 =?utf-8?B?V1JlNXFhN3RvYTdpK1Z3SmJ2TVZUbnUyMCt1SU0zZWUxSWNUSzJrVlFSZlZh?=
 =?utf-8?B?VkFsQU9NNDZTMDV1TUdHbUpvYnozbnI0Y0VlOTc4K1RWTVJ0TStPV3RNRkhv?=
 =?utf-8?B?NlFqZFRtZDdkZE1rdnhOR0hOQnFGbXl2L1NCdWxONmlkd2lVSlpacXFzbGRJ?=
 =?utf-8?B?WGE0ZU9BS0ZxLzF0dVc4Rm9mb3JPLzFUYkNNR3RiQkczRWY2QjN1YVllaVBs?=
 =?utf-8?B?TlZYZVJrd1JGRllORkVoV1ZLTGJ4UjJIRnZ3emVleFFTT01VU29oVFdhWUl5?=
 =?utf-8?B?MVdrc0hjdno1L1pzWGxlNEZnRXBOUGlRYkxKTFZ5czhEVnFPckRBY0NGSGRt?=
 =?utf-8?B?eTJzRmFzUkpzRlluenhSdENKaTJRTmprTjliQUpycjY2NWprUWpyak5LMHln?=
 =?utf-8?B?L0YyWERTRHN3WjlMMndoc3NrRk1QU3dsV0hHYkF6UW9EL053aUw3QVZiWUFE?=
 =?utf-8?B?VkRwbGRycmFaNjBqZCtWNDQ3ZlRqL09jNFZGdnFZQlJpcG9Yd04yUWRCUVdr?=
 =?utf-8?B?Mi9keWYxWGg5TGtTQkxhSHFhT2ZnQ2N4bmVFbHd4cDhGWHNHdUdGNG1vZEIv?=
 =?utf-8?B?M2xjNSs3ckNxWWVuUEdPdnBqa21VREZvbERUdW1TektjSVZnOWlFaEwxREMy?=
 =?utf-8?B?QktPeGRhdUQ2ZzZNd1JHTmRnZEhHSUJoOWVqUTZnd1ZET0pEQ2VwSEdWY05O?=
 =?utf-8?B?UUg5VXZLK3hCemd0V2FQbjFka2pRcTRmRTMwdDArRE9CQ1FWSHo3K2RhVnJF?=
 =?utf-8?B?b2w0KzJnak9ycnNQWERjR09DTGVxRDFpdWdpWEl5MURYM1VBRHNWM0NmSFlH?=
 =?utf-8?B?djU2clE0UUZZQjBqRStROTVmQkVLb3pFcklNWUYyd2plOExnOXdCOXFURFVX?=
 =?utf-8?B?TG5GYWl0VVlFNkZUZ3hsRG9tcXhQa2VJSVNoK1luaGxjTVlBcnl2VndSTUdH?=
 =?utf-8?B?azdPR3Z3dFdKSmtvU0UyVDBkb0ZyMmJJTDU0UEJkQnh6WG82MkdCaGlUUURG?=
 =?utf-8?B?UHA0cmFVQmltUkgvMGE5elJUeDZtTW1kcTFWelphY0FKSDJDSWI1V1lwN05J?=
 =?utf-8?B?QmQ0T0RWTHhVSUt5VzJyenhlMm5HZTVRTy94VDY5YnhPV1BBaU8xWU1LOTZL?=
 =?utf-8?B?MEZWRGtYbVdOMlJZTTk5OFJSM0hXUGRlcytYbUFmRlNWSTZWQ0lYaFR3Y1VX?=
 =?utf-8?B?c05xamJPYXBZL1RzenZwY1dVNWxZdDJOaVNJMnlpNU9LdTA3L2l0cDh3d0xN?=
 =?utf-8?B?Wk1EYlpya2xHdEQzK0ZCdURBbzhMRGZ3QjBpbWV5RlV2RGp2eHo3Z2xtSDMr?=
 =?utf-8?B?bzU2TzlVTGxjcnJJWSt4STNNc1dnc3hpSEU2ZmFTY1VhQ0hHOVAzU0RtOVgw?=
 =?utf-8?Q?wrK/Wv6wINQs7l3EHg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f47eaffd-eddf-4dd3-7659-08dc9da4ad28
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 10:16:18.4953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2P287MB0983

DQoNCj4gT24gNiBKdWwgMjAyNCwgYXQgMzozOeKAr1BNLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gDQo+IO+7v09uIFNhdCwgSnVsIDA2LCAyMDI0IGF0IDEwOjAxOjM4QU0g
KzAwMDAsIEFkaXR5YSBHYXJnIHdyb3RlOg0KPj4gRnJvbTogS2VyZW0gS2FyYWJheSA8a2VrcmJ5
QGdtYWlsLmNvbT4NCj4+IA0KPj4gVGhpcyBwYXRjaCBpbXBsZW1lbnRzIHRoZSBuZXcgc2h1dGRv
d24gY2FsbGJhY2sgbWV0aG9kIGFkZGVkIHRvDQo+PiB1c2JfZHJpdmVyIG9uIHRoZSBVQVMgZHJp
dmVyLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBLZXJlbSBLYXJhYmF5IDxrZWtyYnlAZ21haWwu
Y29tPg0KPj4gU2lnbmVkLW9mZi1ieTogQWRpdHlhIEdhcmcgPGdhcmdhZGl0eWEwOEBsaXZlLmNv
bT4NCj4+IC0tLQ0KPj4gZHJpdmVycy91c2Ivc3RvcmFnZS91YXMuYyB8IDUgKystLS0NCj4+IDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBXaHkg
dGhlICJzY3NpOiIgb24gdGhlIHN1YmplY3QgbGluZT8gIFRoaXMgaXMgbm90IHRoYXQgZGlyZWN0
b3J5IDooDQo+IA0KDQpJJ2xsIHJlbW92ZSBzY3NpOiBmcm9tIHRoZSBzdWJqZWN0Lg==
