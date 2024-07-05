Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2102.outbound.protection.outlook.com [40.92.103.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE5E14BFA3;
	Fri,  5 Jul 2024 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720178569; cv=fail; b=i8JvixfnosB1/b3Bd3Vz4cumyFkn9eOCjVi/YXAM7cq6ZXc0eoiKHa1bG18DTqstW1K8qdRlCYl+aVv9nz0hO8mpI7rNRYwv4N46hp7Dkw4lLTl5ty0Z2P6TMYn+G6eYcgpnzHSYB/mFPZhOjBZP8demnYIPqqC51evgDY+iVK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720178569; c=relaxed/simple;
	bh=qIvlljb+D1ECz2D3UrF/8mHouxS4TQGLM9CC1MJh7cc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QOWx0RwsSqpD2x9d7XSQMhUmiM8Y4hvqaDwR9MKePyQB1tbViasS/qzdpOmEbXeKJ7Y5AyX6M0sPyFgl7L/kS2e2uN4sUY+cICFrNPQV8PLV4thPTJMIVL4peOlxsK9RGM0nHa6YgTR77UPXLUDLJn9oUwnVooL/mzXvosJLCzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=RiJ6Asgg; arc=fail smtp.client-ip=40.92.103.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="RiJ6Asgg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6qzG/HTdHlws6zOCReH1VN0YohWluVy2SJHGX4K2Kr+WJYdT+v6L2tdTCAiocQlotAu4MCy13JJPU0mDMfmIUKpWtx1w2mMP3aqv97WhP8k49XQPGsIb/HzLycixxlj61xmo/ja81iZYlox1YF2Vli/odB7PFo629dTDTcWt2mN/8/v9J1jrsWnNXksZhjM7qLl0q4KRpHJztrZjgoRkQiQ0kVhX7NSGGcFL29oX3wiOupcwub6X/d731Kl6C2S5sJgERv9CKzwrS4+Ufck7hA870EHY8zRNQ7odb1r7GgIH6rNOWJxffxJ606MzXhp4onazyorqLr1ELmlP/0qyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIvlljb+D1ECz2D3UrF/8mHouxS4TQGLM9CC1MJh7cc=;
 b=PUaym+1yHezKgziMCCIK6NMwGwajxH5C9z/JIDbqS2f9q+NNxbv3O0nvbDWHJskyocgTKY7DMX9DqRj3QmuILYoT73jrLX7WM9pbuPAzHWk6eSV6N0m+dNNJj8PZFM00hbC/SlrOyYkvNLvKtbOQ4qGcqXUdU6MBnBFtrlhGv2K7Iufhr0/jVIjibom3hRVMvwnHN++0KHcIrFO8oAGpPzyvdINaCq7Ad7KfM+0/2TAYfwPAnMSreEtpnMj79oxAgSVwJoXHAmHR9EjDPG1iJckybagKYFwyrNKdcA6U7j/D9HSwgpbJPOFHZdcGbwWvHnpx7zOm8pGiOX5QG3uYjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIvlljb+D1ECz2D3UrF/8mHouxS4TQGLM9CC1MJh7cc=;
 b=RiJ6AsggA0iFfjUv4gTB63oTnCyXpsiCoYmS2V0OS1RQLT/LQzzo9L7gL2yZF+hkHkAKIWjDXfWn8N5/+ln8/486CtB9haut+crok3TPXe6gF8D+g9e4lNmGBagFVaoBnGFg0qwHYRPw7oK2c0PB3xkyG1GUKCqSK9h5hHaZP9JDtwRevnGvjUWY7iHIBgEm+B62K5ns/2Fa5jpe5yw8oQeldAIYkEr2pc1k5uWCxbKV1PDCGzWMIQ6HhmNtjQcvfZsexBV8djd10vz5I0XgIjKSZ0uvgTHLM/E+B6heva2pssP1vJZrV0BPdbFT+di80nbbko4fZnOphgPi8WyPxw==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN2P287MB0837.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:154::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.29; Fri, 5 Jul 2024 11:22:41 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.027; Fri, 5 Jul 2024
 11:22:41 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, Kerem Karabay <kekrby@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>
Subject: Re: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHazs1tjVgoALhhKk+BKEcu0nmxn7Hn/aCA
Date: Fri, 5 Jul 2024 11:22:41 +0000
Message-ID: <66B65DF5-489B-4D38-A556-6E076D82565F@live.com>
References: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
In-Reply-To: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [H1IoaqjHoPtcUaCzp0MMCTeS1e5PqR8+S1VWPAN5Yd7hCuQZinGga7Ydo4JNL08D]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN2P287MB0837:EE_
x-ms-office365-filtering-correlation-id: 05a7282e-03ad-4238-9bfe-08dc9ce4c8f1
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|19110799003|8060799006|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 UqArtPlO5zbshNARo9IjfEnPP/H1FR18lHP07O+N5E4uM4ayBMkUGMsT/q3HYBdPlwZb/0nEIyBnGg1Krx1j0D3Cb7D6OK0z94eAfHC7kh7EhE/XvBODCXDlhv7GEElE6Sn5hp7TKgfJLN91FQajVuwvlbhttJ3Swp/qocLAagbDNIPi0Y2JTiOjlyeJ3KcWcBceZjnpdm2Z4QvLbNO5SbY+uvo0QvVVNeT0K+gs52wK9jY3cVyrq8tocOZpwLAJdPFPyutt6NUStKXjZpwRGCG3l4E5zgILnaxGATPLesoTus66JIcrAXW6Ds/FCvZdx7egFNSkAdzXSQx17eK+X+LOLInemh9+udI4Xk/Y5P53OgSxUx5xIKehS8trgt/BkTf/OF9HKT1GLXMiK0Fwck2n99e2KszEUEohHOO9UUKtjFqQJUOl+io7wQPuuQe6B4Z87VDodNoiaOsTHP+f+8Al2/Cfw2QSEBL2ASXIC1I6OKxRaYMX+GFwpq+hH4HF3P8F8Ydwgmip/N4haPaKRalE+MPzMGh4lgWGpm4gMJ2A4+Ij14vi0HJBzE81BUvu7OTbwg8A3aZydFwY3zC4G9DDuh6vU3j+Uf9NGPfCyrt2d7oP3gNhNmA+L3LhSjuJuI7vRXd3xq7mqSLY7EVG0A==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R1F6bEdKUk8wdVh5Yjd1RGw2ZXFld0RhdmVoNUhoQUsxQm9JVURwQ3hiY0pJ?=
 =?utf-8?B?cGFZZittb3lyNWc4VVRRMEpOblVWa2dBTDdOaU1EOVVadVF0NU1VVURZUlZz?=
 =?utf-8?B?NmhJbTVleHhRWjFyRmowTE9qR3ZsRUNhQVNCc1MzbWxGelhLMFRtMUVNYzNy?=
 =?utf-8?B?LzNPUWVIUzUzdmNtcVdqVWs0QUw3aFRPQjBlU3M0Y2MrZHprVW5QdkFoTWhx?=
 =?utf-8?B?VkpObzhVRFdBc3lEUjRPdTB5WVVzaVBPYklnVG05QzVZbXhoNVEwZ1BxQnRF?=
 =?utf-8?B?WlFEVmR3bG1Vdjh4WnduV0xmUmNXUTJ2MkltQnd5Z3pUSjlDTU1RcFljRmVa?=
 =?utf-8?B?NTFTNUlYcXc4WHFLcXVUN20zaFJKU0k2U2syNnZtOU56TXo2OFdORE5IVXU0?=
 =?utf-8?B?WlRqek1raWoyeVVzNGdrbUowcmF0UlhMWFR0KzlVV24xa2M5b2E1cldEQ2tQ?=
 =?utf-8?B?a1JNZzFtTTJCN2w3TTZ5SmZzNWJYaGx2cUtSdUN5enhqM3dsZUpMN0NDZTBG?=
 =?utf-8?B?Y1RwQWNBb1k0Nzd4Ni9pemsrNmE1MEhRcWNYTUlCM2s1Y0dYeEFPcXJyY3Jo?=
 =?utf-8?B?OUcrY1JwSUMwRWsyYUdISTdPdE9XMjR4M0RLbUpQMEdQUnY4MDVtSUV2QTNQ?=
 =?utf-8?B?R1JMVkloZUlqcWxVM1ZmRWxqS01yOE5uTVg4RysrN0V0YUZUOFNLYTdJVVow?=
 =?utf-8?B?MU1QS05aMkkrTVVrZFgrdFlESHQ5Q3piZFdDYjVKSkp3VUNtZmVFM3Y2Mmcv?=
 =?utf-8?B?MGJBNFBkNUpZaG56OTgxTC9BenQyNXZLRnhiZ0pEdSs4UnZQVDJiWk9IbHpv?=
 =?utf-8?B?T2g1VmZabkNMYVQwU1RJUTRuOU1EWG9WUWdpV1ErYUxKMTg2TTZGYURBTW4r?=
 =?utf-8?B?UEc3Wk9LTzFmbnJSWjZyRjlYS3ZKOEhZL3ZBS095RGFCNjJoWGNjYmYwT2Vy?=
 =?utf-8?B?YUVIS3lraHNxMzdPWnE4cmt4MHI0YU9nNFhMaG1iZVI1WkVsdzBnMUpyQk8v?=
 =?utf-8?B?TVY2SW5qbVRCRDRIV2JJQVlLSDhPQVZqNU9zK0ZzdmR0QUpMWStyd3hqMlZM?=
 =?utf-8?B?RGdIbnljU2N5VU90WFgwMzV6b1NucUsrekxhU0syZlVvaFNJU2NRQ2N1MXl1?=
 =?utf-8?B?bXN2VlhzcjBwU1RDVjB0Nk9FUkluQnpDQ1V0YUE2OUI1cUxhd1dFdjhBaWlT?=
 =?utf-8?B?UHpuZ2p2azJVRXJaeEpsUTV1QktwZUh2Z3VZRUcyOUV2QnhRcVlQRnJjeEhu?=
 =?utf-8?B?VGRxb2NrcCtYaDFnYnFyTXY3bTRaOG9VNm00TGdFYWd3MWtsc1BLdGNQSlJP?=
 =?utf-8?B?VnJ5d2xaKy9SOGZtSjcxVlRyZGE4VXNWUC9UTnFLZ0xGZkk0eWI5NGRQMHJt?=
 =?utf-8?B?QktMcEhEaEVaYnZUdUxKaFVHT0RoL3ZmSkpvcUZiZGQwNzhHaVF4MzZXNlJM?=
 =?utf-8?B?RjVQb0h6Wk5UbTVEbXZTbGxmOVdrNWVHOC8vNUJzVHoySURYazdYbEY1VFRZ?=
 =?utf-8?B?bUhjQ3RUaGVkTnVEUVpYT2xJejdVSmJ1ZTlOVEtYenA0Rm5URXJuamdZbXh0?=
 =?utf-8?B?aGdKeXNwL251cnVqQlNRWWVDdUozM0lWYm9YY3dWZERFMFo5NitxYjZ3ZGR6?=
 =?utf-8?B?b1hZUXRZaklWbmsvakVSQnp5RmVhbzZMRGpSZTRqYkRRTU1BZUxWa2JZZmNF?=
 =?utf-8?B?eE0yc1Y2M2w4ME4xdUVBczNqLzkxL0RmODRVby92OG9ucXFXQkRkWU1jUWhO?=
 =?utf-8?Q?7e1YEs1H4OQYkGg3z0dy8ZdRdqpxtMPVPVquim4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A948F03F2E7DBB4190D1EAC68B7C225F@INDP287.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-bafef.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a7282e-03ad-4238-9bfe-08dc9ce4c8f1
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2024 11:22:41.7451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2P287MB0837

UmVwbHlpbmcgdG8gdGhpcyBzaW5jZSBJIGZvcmdvdCB0byBhZGQgdGhlIGF1dGhvciBLZXJlbSBL
YXJhYmF5IHRvIGNjLCBzbyBhZGRpbmcgbm93DQoNCj4gT24gNSBKdWwgMjAyNCwgYXQgNDo1MOKA
r1BNLCBBZGl0eWEgR2FyZyA8Z2FyZ2FkaXR5YTA4QGxpdmUuY29tPiB3cm90ZToNCj4gDQo+IEZy
b206IEtlcmVtIEthcmFiYXkgPGtla3JieUBnbWFpbC5jb20+DQo+IA0KPiBUaGlzIHNpbXBsaWZp
ZXMgcnVubmluZyBjb2RlIG9uIHNodXRkb3duIGZvciBVU0IgZHJpdmVycy4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IEtlcmVtIEthcmFiYXkgPGtla3JieUBnbWFpbC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IEFkaXR5YSBHYXJnIDxnYXJnYWRpdHlhMDhAbGl2ZS5jb20+DQo+IC0tLQ0KPiBkcml2ZXJz
L3VzYi9jb3JlL2RyaXZlci5jIHwgMTQgKysrKysrKysrKysrKysNCj4gZHJpdmVycy91c2Ivc3Rv
cmFnZS91YXMuYyB8ICA1ICsrLS0tDQo+IGluY2x1ZGUvbGludXgvdXNiLmggICAgICAgfCAgMyAr
KysNCj4gMyBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvZHJpdmVyLmMgYi9kcml2ZXJzL3Vz
Yi9jb3JlL2RyaXZlci5jDQo+IGluZGV4IGY1OGEwMjk5Zi4uZGMwZjg2Mzc2IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3VzYi9jb3JlL2RyaXZlci5jDQo+ICsrKyBiL2RyaXZlcnMvdXNiL2NvcmUv
ZHJpdmVyLmMNCj4gQEAgLTUxNCw2ICs1MTQsMTkgQEAgc3RhdGljIGludCB1c2JfdW5iaW5kX2lu
dGVyZmFjZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+IAlyZXR1cm4gMDsNCj4gfQ0KPiANCj4gK3N0
YXRpYyB2b2lkIHVzYl9zaHV0ZG93bl9pbnRlcmZhY2Uoc3RydWN0IGRldmljZSAqZGV2KQ0KPiAr
ew0KPiArCXN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRmID0gdG9fdXNiX2ludGVyZmFjZShkZXYp
Ow0KPiArCXN0cnVjdCB1c2JfZHJpdmVyICpkcml2ZXI7DQo+ICsNCj4gKwlpZiAoIWRldi0+ZHJp
dmVyKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwlkcml2ZXIgPSB0b191c2JfZHJpdmVyKGRldi0+
ZHJpdmVyKTsNCj4gKwlpZiAoZHJpdmVyLT5zaHV0ZG93bikNCj4gKwkJZHJpdmVyLT5zaHV0ZG93
bihpbnRmKTsNCj4gK30NCj4gKw0KPiAvKioNCj4gICogdXNiX2RyaXZlcl9jbGFpbV9pbnRlcmZh
Y2UgLSBiaW5kIGEgZHJpdmVyIHRvIGFuIGludGVyZmFjZQ0KPiAgKiBAZHJpdmVyOiB0aGUgZHJp
dmVyIHRvIGJlIGJvdW5kDQo+IEBAIC0xMDUzLDYgKzEwNjYsNyBAQCBpbnQgdXNiX3JlZ2lzdGVy
X2RyaXZlcihzdHJ1Y3QgdXNiX2RyaXZlciAqbmV3X2RyaXZlciwgc3RydWN0IG1vZHVsZSAqb3du
ZXIsDQo+IAluZXdfZHJpdmVyLT5kcml2ZXIuYnVzID0gJnVzYl9idXNfdHlwZTsNCj4gCW5ld19k
cml2ZXItPmRyaXZlci5wcm9iZSA9IHVzYl9wcm9iZV9pbnRlcmZhY2U7DQo+IAluZXdfZHJpdmVy
LT5kcml2ZXIucmVtb3ZlID0gdXNiX3VuYmluZF9pbnRlcmZhY2U7DQo+ICsJbmV3X2RyaXZlci0+
ZHJpdmVyLnNodXRkb3duID0gdXNiX3NodXRkb3duX2ludGVyZmFjZTsNCj4gCW5ld19kcml2ZXIt
PmRyaXZlci5vd25lciA9IG93bmVyOw0KPiAJbmV3X2RyaXZlci0+ZHJpdmVyLm1vZF9uYW1lID0g
bW9kX25hbWU7DQo+IAluZXdfZHJpdmVyLT5kcml2ZXIuZGV2X2dyb3VwcyA9IG5ld19kcml2ZXIt
PmRldl9ncm91cHM7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zdG9yYWdlL3Vhcy5jIGIv
ZHJpdmVycy91c2Ivc3RvcmFnZS91YXMuYw0KPiBpbmRleCAyNTgzZWU5ODEuLjU5MWZhMDM3OSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy91c2Ivc3RvcmFnZS91YXMuYw0KPiArKysgYi9kcml2ZXJz
L3VzYi9zdG9yYWdlL3Vhcy5jDQo+IEBAIC0xMjIxLDkgKzEyMjEsOCBAQCBzdGF0aWMgdm9pZCB1
YXNfZGlzY29ubmVjdChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikNCj4gICogaGFuZyBvbiBy
ZWJvb3Qgd2hlbiB0aGUgZGV2aWNlIGlzIHN0aWxsIGluIHVhcyBtb2RlLiBOb3RlIHRoZSByZXNl
dCBpcw0KPiAgKiBuZWNlc3NhcnkgYXMgc29tZSBkZXZpY2VzIHdvbid0IHJldmVydCB0byB1c2It
c3RvcmFnZSBtb2RlIHdpdGhvdXQgaXQuDQo+ICAqLw0KPiAtc3RhdGljIHZvaWQgdWFzX3NodXRk
b3duKHN0cnVjdCBkZXZpY2UgKmRldikNCj4gK3N0YXRpYyB2b2lkIHVhc19zaHV0ZG93bihzdHJ1
Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikNCj4gew0KPiAtCXN0cnVjdCB1c2JfaW50ZXJmYWNlICpp
bnRmID0gdG9fdXNiX2ludGVyZmFjZShkZXYpOw0KPiAJc3RydWN0IHVzYl9kZXZpY2UgKnVkZXYg
PSBpbnRlcmZhY2VfdG9fdXNiZGV2KGludGYpOw0KPiAJc3RydWN0IFNjc2lfSG9zdCAqc2hvc3Qg
PSB1c2JfZ2V0X2ludGZkYXRhKGludGYpOw0KPiAJc3RydWN0IHVhc19kZXZfaW5mbyAqZGV2aW5m
byA9IChzdHJ1Y3QgdWFzX2Rldl9pbmZvICopc2hvc3QtPmhvc3RkYXRhOw0KPiBAQCAtMTI0Niw3
ICsxMjQ1LDcgQEAgc3RhdGljIHN0cnVjdCB1c2JfZHJpdmVyIHVhc19kcml2ZXIgPSB7DQo+IAku
c3VzcGVuZCA9IHVhc19zdXNwZW5kLA0KPiAJLnJlc3VtZSA9IHVhc19yZXN1bWUsDQo+IAkucmVz
ZXRfcmVzdW1lID0gdWFzX3Jlc2V0X3Jlc3VtZSwNCj4gLQkuZHJpdmVyLnNodXRkb3duID0gdWFz
X3NodXRkb3duLA0KPiArCS5zaHV0ZG93biA9IHVhc19zaHV0ZG93biwNCj4gCS5pZF90YWJsZSA9
IHVhc191c2JfaWRzLA0KPiB9Ow0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdXNi
LmggYi9pbmNsdWRlL2xpbnV4L3VzYi5oDQo+IGluZGV4IDI1ZjhlNjJhMy4uNWYzYWUyMTg2IDEw
MDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3VzYi5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgv
dXNiLmgNCj4gQEAgLTExOTQsNiArMTE5NCw3IEBAIHN0cnVjdCB1c2JkcnZfd3JhcCB7DQo+ICAq
CXBvc3RfcmVzZXQgbWV0aG9kIGlzIGNhbGxlZC4NCj4gICogQHBvc3RfcmVzZXQ6IENhbGxlZCBi
eSB1c2JfcmVzZXRfZGV2aWNlKCkgYWZ0ZXIgdGhlIGRldmljZQ0KPiAgKgloYXMgYmVlbiByZXNl
dA0KPiArICogQHNodXRkb3duOiBDYWxsZWQgYXQgc2h1dC1kb3duIHRpbWUgdG8gcXVpZXNjZSB0
aGUgZGV2aWNlLg0KPiAgKiBAaWRfdGFibGU6IFVTQiBkcml2ZXJzIHVzZSBJRCB0YWJsZSB0byBz
dXBwb3J0IGhvdHBsdWdnaW5nLg0KPiAgKglFeHBvcnQgdGhpcyB3aXRoIE1PRFVMRV9ERVZJQ0Vf
VEFCTEUodXNiLC4uLikuICBUaGlzIG11c3QgYmUgc2V0DQo+ICAqCW9yIHlvdXIgZHJpdmVyJ3Mg
cHJvYmUgZnVuY3Rpb24gd2lsbCBuZXZlciBnZXQgY2FsbGVkLg0KPiBAQCAtMTI0NSw2ICsxMjQ2
LDggQEAgc3RydWN0IHVzYl9kcml2ZXIgew0KPiAJaW50ICgqcHJlX3Jlc2V0KShzdHJ1Y3QgdXNi
X2ludGVyZmFjZSAqaW50Zik7DQo+IAlpbnQgKCpwb3N0X3Jlc2V0KShzdHJ1Y3QgdXNiX2ludGVy
ZmFjZSAqaW50Zik7DQo+IA0KPiArCXZvaWQgKCpzaHV0ZG93bikoc3RydWN0IHVzYl9pbnRlcmZh
Y2UgKmludGYpOw0KPiArDQo+IAljb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCAqaWRfdGFibGU7
DQo+IAljb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwICoqZGV2X2dyb3VwczsNCj4gDQo+IC0t
IA0KPiAyLjQyLjANCj4gDQoNCg==
