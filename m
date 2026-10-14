Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012026.outbound.protection.outlook.com [52.101.126.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BEF1FF1DA;
	Wed, 14 Oct 2026 02:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791944453; cv=fail; b=WVkazXrLWHPcx0J48q0PVsiLTOuGSFO+pHP/5IVrR+6p4DsPHgyUH6XO02UYi2FnVqg7KzxcrmRIALusr2++4uJjv6/0o9DqQ0aWYfP8Hqw5ohbPFk0LY5qH4qmp85gUybI9pBkKp9EBqsR4lTD7X+TsptcJ+zIxSFO3K5lQD1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791944453; c=relaxed/simple;
	bh=a7SYUxRyhyQwwQODR/9ktn+F0GYFw6Uuv6ZKoxIFiG0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gAXTTYRKv0D3w09w16htVqBJXys5zcd2tbSt2fqwMO2KAobBkhfvJ+TZpBEsbG4Lpm5EyimvtVn91xDaYV4gDcIpx5skvnMyWLlOE+WEOJuNehRjoj7mdBiHlWPZRDqiAIdqna5Vyngq+0oUeIU4Ug/K7JvtrzJffUm7Dw/7g2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=X9nlu0yJ; arc=fail smtp.client-ip=52.101.126.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="X9nlu0yJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUi9A89HHvwucePUvkLGaTuSLJZq1b2+tX4V9MocQaOoeWwduBNQ5DqJmba/PGVJQu65Km1RLGjvxb4RGV7DQzudpPli9SuulJmhHejKdfptwSTqZUyG0Ac4mAvE0b8u2qAkK16kfqe2HBizFSRSE8bx0tFHKwVzqbav1kRh7rYf7DLZCRkQh3bKCWotC10a77YGG4fGU/L9HAUT+dU7OkOb8x13MOtLJqsB2+FFumlQJ9Y/7xFy0xlCbpASte8H0XiMkt97SHHkJC+/5q5A2cIa99ETarqVJSP0gNCsVbPa6y9WTydf83NBaKnYMFPUL0ie1uoHezLD509c4x0GcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7SYUxRyhyQwwQODR/9ktn+F0GYFw6Uuv6ZKoxIFiG0=;
 b=SDQboPih64+itWFZiZ4qyWnhjOuhboh+Tj99vEmimifJEi+JbOryWASqZ7QavEqOL+Szs4qKAcqL/q/QcxQSUBhbXbc7fmV8JOIZaw171+OLT6BNzWOHTqKAFbUuV2DC4R6j3IIv82jpJqoj1dc1S5bqjlXp/iOZv5N9nTvDkDFNtO2cboLtu09CHv9eOTaiOXfQwyrProewx3BEdHIFFctd0cglabnjk1DHUimfCRIRBang3goNvc5upULYY4hvIGxfv0fRkUJV28QLfb2SmzD5DbcspIf6LVFFkCdJrVVnRcrZRw4k7NDStLow1YqX5A9k9iNVSbqUCkQ7cuV1jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7SYUxRyhyQwwQODR/9ktn+F0GYFw6Uuv6ZKoxIFiG0=;
 b=X9nlu0yJsu2qC2MYu9d0wH1Jht5omS6HhJUL9iDqXzbQN9vd0UuACQvwC5TslFDB5fj3wlvj9sJiW3HYimPDDccL+h68j3Gs3rxxCSIc8HDGJwFS7l7ARL4I8oPuLHfpe8TnjIyykaSUw4dBgCiuht0XKdQREWMBbnGZ9keH4PQRE00ct7BqoBODcuI3zeIQRyW0JxPyMbmF1WqhjSWpmNXyqi0XscSA1fGVOaSlHWRIMJrKYnEIlZg0SWnLG7gt/fPWeZx/mS9M1DxgT0juUGBMKa7ZicrtNjVwtTcTvK/NlvlVTH/5I2o4EyumNPQ25PetYkaQlZqhYVEake1LJg==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by TY2PPFCBACDA68A.apcprd06.prod.outlook.com (2603:1096:408::7a8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 02:20:45 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 02:20:44 +0000
From: =?utf-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, Hannes
 Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>, Damien
 Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject:
 =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSCB2NSAxLzJdIHNjc2k6IHNkOiBtYXJr?=
 =?utf-8?B?IGRpc2sgZGVhZCBvbiBzdXJwcmlzZSBob3N0IHJlbW92YWwgdG8gYXZvaWQg?=
 =?utf-8?Q?I/O_hang?=
Thread-Topic:
 =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjUgMS8yXSBzY3NpOiBzZDogbWFyayBkaXNrIGRl?=
 =?utf-8?Q?ad_on_surprise_host_removal_to_avoid_I/O_hang?=
Thread-Index: Ad1X4Nn5DvzfrXBnSoCZVyBu705+6gCeASuAABfIUFAAG63OgAAVJJUA
Date: Wed, 14 Oct 2026 02:20:44 +0000
Message-ID:
 <TYUPR06MB62173975C70E0BBCE434475ED29D2@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <20261012144923.GA10852@lst.de>
 <TYUPR06MB62172FD04314EFE34D8091EAD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <9c28fbe7-089f-4d72-86be-5805bfebb213@acm.org>
In-Reply-To: <9c28fbe7-089f-4d72-86be-5805bfebb213@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|TY2PPFCBACDA68A:EE_
x-ms-office365-filtering-correlation-id: 9c998dc8-ad46-494e-1d7a-08df2999c06e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|1800799024|366016|376014|7416014|23010399003|18002099003|10067099003|22082099003|3023799007|4143699003|11063799006|261009223027099003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 N+XrlQyDxc3LPGI2wv5AhDui1PoFShp2ywctOf1BlcjhL7J5H8MdR100+tNgfMD3BCrg7RDIc22Tzp50QGa0StfkFqUQcrMgTzbA6WJ9JDiZtIumfVtXaXCZoHB3wuEqi3HEaSBnNwL4pkCy5Ihd27oQ0J2tGsCNn+EC7cJq7/3zp77YEMJbKfvYglTx6BemDYMpJN8AGd+ek+/PrqZW6WvaQ9sb7OVctaWEFZ9rcVD+Epl9r75ghO2XLQS1Z4A4jbw4NSzyM43wF8PiWiVAcRekP3kCB6ejL6iKA1tV53XnlVKevCM2mKuU9w1RyOV0LPJ5LuG36vLRga844FC1SkfjQ2vU7XPs0qaNADr9aU+F5ggSxRK0JGmDvx3srvy5ldt0phqoWPc22XRhxfpmlAoeA5/fGKSoIgtVUrVYQWp5Ot7IYJek1Fc1DxqLZZBFZAjh44ZlymjcxpmKr51jV7ofqBRlRSYupgafWS4wfT9217b8FU+4IVGed1EReJiaZHu/wkNkzoNJtmimf9vMKFoulNxj90SPFWIQHHL3fL/sfX+GkY6V+0AA3zv+POL96pMV2SiDqKJob749WJK6Vvroa6UhpO0zfM4zTHJ0oGt+Mz9xVxBE4a+Pgpy+NwBmm1/8Pa2TohrHlZYSmf4M9oPs+eVxx3wsPMAkWO4LiHMQnwaUSromu3Gb7F+9Ng3+3Vi5Rr3kwKgfRGmT2DzKphv3CbNLIY+IVq631tp9vyU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(10067099003)(22082099003)(3023799007)(4143699003)(11063799006)(261009223027099003)(38070700021)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aEowQkRxVVN4QzBBTVhGUHIzTVpoWjdyQkllZlJUSXR1SWZFak9Tajd6dnpt?=
 =?utf-8?B?OUcyUGNQVDBZaVlBWXVXa2hReUpqL3lHbTdIRVVLUC9jZTZ2NmVyUmphR1hL?=
 =?utf-8?B?OUNodkZCSHhQbTNNR3pIc3hxMGl0Q0Q4Q0x3V1k3U2NTbUlCOGFGTUo4dXlk?=
 =?utf-8?B?ditEUDdHamtUeGpiTzhUeWhXaCtyQUYwU2RvbkpNaDArWmZxdkZMWGNPUUJW?=
 =?utf-8?B?Y1NPODF2b042VXVjNGQ2SVd2NDFpeDlEM2ZNOXJtQkduYmxScTdkenhOdE9v?=
 =?utf-8?B?RGd4cnZyRThwb1o5dEttSGQ1bE05dFppN3Y3c3pnNXNjVHlEYkd0Y3ROMGlC?=
 =?utf-8?B?WmlpS2N6M0Zla2REZHdwTlpKYm9NTEo4RHU2MjJ3RzM4YlVaTmNhcldZQkNn?=
 =?utf-8?B?cFBKMExka083d3BEOHBhdXRDb1lXR1NDV1NZdzVTRW1zaGQxYkw5NkdtN3cz?=
 =?utf-8?B?aHZEVThPL3BaaWVqaDUvT1p6VHdGSVRjMG9MMVd5OEpGTkMzalFLdzZBcCtO?=
 =?utf-8?B?QVBFMkUvYW9EQUYwQXRDV1p3azhDYjRlMUtjU2s0R3BLU3N5aGJJcHlPN1RS?=
 =?utf-8?B?OVRCajVUdTZlRWxlSWRmYSsyLzJvYnFuVC9OUm9Ga1dFYmxiSEFWSkFCQ2dM?=
 =?utf-8?B?Rlg5cUNoREVEZUFaTDdDVWRzcFg0bjZMU1pCSnBiUG9HZ2pVODZraUlQakJr?=
 =?utf-8?B?cXNMNlhnRDY5L2RyT2tuMUttN2Ura2pkaEY1bDlBdTIvV1ZtTnJ4NTlpdDVV?=
 =?utf-8?B?TG5qSTFLdWdVZk9kdnh6dGxWeGNMcHc2L3IwWXpNeGFOZW9Qb0tXZThZMWtq?=
 =?utf-8?B?c3BsYXhkSDc0RU1sNlZuZUNvaE42dTFlMHJ0Tml1azl4OXVMMGREVDFvWFJP?=
 =?utf-8?B?U3VMb0ZCd0xWSW94YitNSWk2ZW1US3JrTjJUdG5aakk3RVl0L3U4WDZSeEJT?=
 =?utf-8?B?SkZzTDJuNitnSU1jR2x1VVBiTDN0aDdPTnNGZjNaYTV3RXJtbTVjR2tMRmhr?=
 =?utf-8?B?TVl2SUtzRGhZeWxBNzZxVHpQV0RBUE8zVk0rek5zTlFOZkdhUFFGSGJhNk9K?=
 =?utf-8?B?ekxVYVJXNGxXVlhIZ3U3cllvaHBpVzZmTXB0WnhOYkFBa1dlN1k3RmVuck5x?=
 =?utf-8?B?SnVJYzVIekNHelFDc09PSiswUDdrVlB4dmh1STJramlsQ3d5NWdFT2pPdUdZ?=
 =?utf-8?B?NkNvejZmc2UvRTRRRTNXYkd4cVpOU0ZwMVl3cjhNLy9CNDhySWJZYTMrbWJk?=
 =?utf-8?B?SkZ4SDQwUDBUdDltWVFnZjJoaktRK2VwUGs1N3ErQkN1YVkycm5DTE1vbEx4?=
 =?utf-8?B?OUhvSGFUbjFReVpBWVc1MmFqZThZcCt0VGtsRm1BYnBTOGVhMFFjcU9FUm16?=
 =?utf-8?B?eHo5NDlHazU1dU1HK2p3NTJFemVSRCtpVFdFMjlIeURvanU4WktjNE1ad2R2?=
 =?utf-8?B?eVlSTEdGNnF6UW9MbmtCRE8rTjlBYWd3dkdPMy9ZeUZzSG4zTmJJYzI1RTB2?=
 =?utf-8?B?czFuUXk0Ykg1K21ueTkwY09Ib3NVeGJrQ0FWK0JCbjUySDE2cUI0YVJtZFdE?=
 =?utf-8?B?YVFrcDdiY3NORjdwL3AzMEY0QmdsUmlpNlVPN2NMTHFZSUF0ZFJFeGdybW5N?=
 =?utf-8?B?c0p4NEUwYktkY09HUkNGbGlHT0ozWmhpZkFXLzNaSzZDN1I3MitzUHY5RzB5?=
 =?utf-8?B?cWE5Vm5iYllPLzcxZzh4QW9CUkxrYzdLZnB0NjYyKy81OGVESjduNlFSbHpU?=
 =?utf-8?B?dExra0M1OUNrZENTT2Zha0RyQmQwUGtCTlNjUlhMY2FFQVhkblRnNWxVK2lS?=
 =?utf-8?B?MCsyT09BNkJrUEZnWDVaT1ZtMElyUTNnZHBjTmo1NVRVRG8ySENwRHVoNXdP?=
 =?utf-8?B?RWNPMWRqMkF3WGZNTTVacGpXRHpBdjF6N2I3UmQrci8xRDF0WE5TRGxRdHcv?=
 =?utf-8?B?RGY3ZkY1d1FUNTdKQmcxUUw1ckxrZ1JMZEdwNkhLTWV1Y2xySkVEZWs3amRu?=
 =?utf-8?B?cmVlSXBwSWVrYi93Q1Nha3pMK0hjd2dBdlVtY1lRc1h6TkU4SnNYbk45NWJP?=
 =?utf-8?B?dktVaE91a3hTZXhOQnhIdERRU3h6K2wycUE0eGovaVY5MlJOdGRGQXdNOEF5?=
 =?utf-8?B?RzZUdm1XbVdKblZ3SUdKdUZkenB5TmdpMGEzdlNMc3FiQ2VPUE5POFNGamsy?=
 =?utf-8?B?bDFuK3M1V1NnbmNJNXJ3dEJmU3RWMDVNS09ZbENzclhUd1Fmam9GYjlMWldH?=
 =?utf-8?Q?PthB71p12xih/vc0SMLEd8RPlr4ijlh5JmHzw9ymlQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYUPR06MB6217.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c998dc8-ad46-494e-1d7a-08df2999c06e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 02:20:44.4614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: szwmulRExvqv/s82WIL33ihE7iw1HZx+9jr8ThAgYF5G3r/hXTvBLBAwiJf5SZSnfxu5VdRW3ouudXlEwrviQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPFCBACDA68A

SGkgQmFydCwNCg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zdG9yYWdlL3VzYi5jIGIv
ZHJpdmVycy91c2Ivc3RvcmFnZS91c2IuYw0KPiA+IGluZGV4IDA2NGM3ZmM4ZTM2OC4uM2E1YTBj
YWMyYjc4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdXNiLmMNCj4gPiAr
KysgYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VzYi5jDQo+ID4gQEAgLTkzMCw2ICs5MzAsOSBAQCBz
dGF0aWMgdm9pZCBxdWllc2NlX2FuZF9yZW1vdmVfaG9zdChzdHJ1Y3QgdXNfZGF0YSAqdXMpDQo+
ID4gICAJaWYgKHVzLT5wdXNiX2Rldi0+c3RhdGUgPT0gVVNCX1NUQVRFX05PVEFUVEFDSEVEKSB7
DQo+ID4gICAJCXNldF9iaXQoVVNfRkxJRFhfRElTQ09OTkVDVElORywgJnVzLT5kZmxhZ3MpOw0K
PiA+ICAgCQl3YWtlX3VwKCZ1cy0+ZGVsYXlfd2FpdCk7DQo+ID4gKw0KPiA+ICsJCS8qIERldmlj
ZSBpcyBwaHlzaWNhbGx5IGdvbmUsIGNhbm5vdCBoYW5kbGUgSS9PICovDQo+ID4gKwkJc2V0X2Jp
dChTSE9TVF9TVVJQUklTRV9SRU1PVkFMLCAmaG9zdC0+ZmxhZ3MpOw0KPiA+ICAgCX0NCj4gV2h5
IGlzIGEgbmV3IG1lbWJlciB2YXJpYWJsZSBpbnRyb2R1Y2VkIGluIHN0cnVjdCBTY3NpX0hvc3Qg
aW5zdGVhZCBvZg0KPiBlLmcuIGNoYW5naW5nIHRoZSBzdGF0ZSBvZiBhbGwgU0NTSSBkZXZpY2Vz
IHRoYXQgYXJlIGFzc29jaWF0ZWQgd2l0aCB0aGUNCj4gaG9zdCB0byBTREVWX09GRkxJTkU/DQo+
IA0KDQpUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLCBpdCdzIGEgZ29vZCBwb2ludC4gSSBkaWQg
bG9vayBpbnRvIHVzaW5nDQpTREVWX09GRkxJTkUsIGJ1dCByYW4gaW50byBhIGZldyBkaWZmaWN1
bHRpZXM6DQoNCjEuIFRoZSBoYW5nIGlzIGluIHRoZSBibG9jayBsYXllciwgbm90IHRoZSBTQ1NJ
IGxheWVyLiBUaGUgaGFuZyBvY2N1cnMNCiAgIGluIGRlbF9nZW5kaXNrKCkgLT4gc3luY19maWxl
c3lzdGVtKCkgLT4gX19iaW9fcXVldWVfZW50ZXIoKS4NCiAgIFNERVZfT0ZGTElORSBpcyBhIFND
U0ktbGF5ZXIgY29uY2VwdCBhbmQgY2Fubm90IHByZXZlbnQgdGhlIGJsb2NrDQogICBsYXllciBm
cm9tIGF0dGVtcHRpbmcgdGhlIHN5bmMuIFdlIHN0aWxsIG5lZWQgYmxrX21hcmtfZGlza19kZWFk
KCkNCiAgIHRvIHNldCBHRF9ERUFEIHNvIHRoYXQgZGVsX2dlbmRpc2soKSBza2lwcyBzeW5jX2Zp
bGVzeXN0ZW0oKS4NCg0KMi4gU3RhdGUgb3ZlcnJpZGU6IEV2ZW4gaWYgd2Ugc2V0IGRldmljZXMg
dG8gU0RFVl9PRkZMSU5FIGJlZm9yZQ0KICAgc2NzaV9yZW1vdmVfaG9zdCgpLCBfX3Njc2lfcmVt
b3ZlX2RldmljZSgpIHdpbGwgdHJhbnNpdGlvbiB0aGVtIHRvDQogICBTREVWX0NBTkNFTCBiZWZv
cmUgc2RfcmVtb3ZlKCkgaXMgY2FsbGVkLiBTbyBzZF9yZW1vdmUoKSBjYW5ub3QNCiAgIGRpc3Rp
bmd1aXNoIHN1cnByaXNlIHJlbW92YWwgZnJvbSBvcmRlcmx5IHJlbW92YWwgYmFzZWQgb24gZGV2
aWNlDQogICBzdGF0ZSBhbG9uZS4NCg0KR2l2ZW4gdGhlc2UsIEkgd2VudCB3aXRoIFNIT1NUX1NV
UlBSSVNFX1JFTU9WQUwgYXMgYSBtb3JlIHRhcmdldGVkDQphcHByb2FjaC4gSWYgeW91IHRoaW5r
IFNERVZfT0ZGTElORSBpcyB2aWFibGUsIEknZCBiZSBoYXBweSB0byBleHBsb3JlDQppdCBmdXJ0
aGVyLg0KDQpSZWdhcmRzLA0KTGlhbnFpbg0K
