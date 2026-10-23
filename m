Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792772584;
	b=KiXYAYNBQInqPmo9iH1banWVut3n9HoLdQwgnn5SYSWjsMNANVA5d+MczrGturH71clB
	 zdwAq1zNjz0HQ2df2NnOVnwYdThffqghw7nIvkx7j5+NLT8M7pU2Z0FZ5t00Hpl9i2lUF
	 CXPsZPwb7Vf4WCqO4jqjKXt2lvrN42HTZTTX/np88W0DKQ6iEk59R/EWuPrLKa+PgpRWy
	 qPJotb5xqres7Nr1pCk/lDe0co02PkYeytVcVnhkoQYQC6gL+ZfZNPhknLux2Rpn/ABON
	 Fz9vfEArtrulEVvWgWcAdi004iKN/jwYGt7KWhXI0tUgY1Yj2kMgce3Azg/NZzcNoyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792772584;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=dpTV0U03UqSqTemxXAztj9xwbqIaaeV29yjRrjYKapw=;
	b=1BAq4hoxr4ozlMZH7lnyLoS9oPGdLIx+NEehwsYwJyioj96WFv/iD5FDWSqIldN47CIi
	 VteN/Ijsh7/VbV362mYABFxT4JJQfh1KKDNZhB+1v2GU7PhV+USd6MqOpLn+Op84KPBRh
	 8/l47MbTPTZ7WBaf8UqLDwyeAPBXMVGfwl2o1kFHhfELRxKN+hxGm9Ko9uLaZnV6xAmfH
	 9I+dNdCk1bOWgZ2Bd7iiqVz7kCVN4cQ4FgUR3R6ArYB8XkVcMqTC0+WHwkPpM0jjcRl2x
	 5Vnjk5BjbOTtOl+SJYeeW1/CNBRGFUYEDdwEPjwDhdwOpsVwATlAE8gzRy8/O0BoZzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=dGx5YxsJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.25
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazolkn19011025.outbound.protection.outlook.com [52.103.14.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50932606A31B;
	Fri, 23 Oct 2026 16:23:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50932606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=dGx5YxsJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOLdRSQ/EQ+/wbXF6DcB8+8rWwzIFZKp8MI/2sFeaxFDmtWc3kP7ew94Q2PqOonOq4jGT3ZxUZ2ARDegzxTYf6LgV/cRuiB75HjLbnnNYKWkEhcdG7DToxgR9BGc5rvUGQr/KHnP2R1wB64jubcuS/xjkRbqdFo+6SkHp1vp5ikxBryZfv3oQXp3BOLdTltatmNOOW4geUsCm4sDUfSOPJn1vOvsjUWo9VG93InwA/kyWkcb/2GpGAQjsqcNTlTXBa1eCebpjEEG8Qdq599X/bN1Foz3/AAlNmGy1CV1fej2Vfw1nEYwtAN19O+xot6nyQlgmTaD/88JR+n5GibXkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=dpTV0U03UqSqTemxXAztj9xwbqIaaeV29yjRrjYKapw=;
 b=oNNK1GKYdoJpk7ko7+yL7hwevaSAK+KaUk0WNaLkMRzhqOeC4fQB/iioGqJzjltp4IHqHIAbYYcWV6lC++f0GX5iF5gkUbQKouSrEqanIiFQ9zc4ZYvVSoNx/3bFb0g4+J1SdK//lRLsoXfpjSxbsaYtf7auCCU5ITsXzvJ7zAd2V3AlgXrk7fWacJY0NX2M3hLVras8wclhS8UDU2fL8TqUZWeG+UoBCEDzuwF9Z09vpv+dOBHFQ9Q10C7SoyuaHLBWLYV+kRKptahLQDrtvlCB7Bk6tF0zl39pYuyL3niliwR/49XRo+anuzdmBB8yqFnGeuYtRNi1pfqjcE+hhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpTV0U03UqSqTemxXAztj9xwbqIaaeV29yjRrjYKapw=;
 b=dGx5YxsJ5jdTemmdUdwBCAqkqP+KbjaY2MzqcjlO36jsmLM3LxO02qBvMFeej2IhbTEz3Ijry9BnPbdd2hJqBpnpYoyGhh0rmEgVJxmQDksNdUdNUTETe3gaF4Hn6tieXJkkZGHiXXTmk+PWId+9qpvMurNX7XIgatji38IVfpv+3flcUFwUqOR3L8g10GMQQJ8LWxAqpWPbGSQB/KrNb7kqn2Rs8YvdTXwS2ALlZGkqoURMiteppTMPf01/1/2GIce6ashP1H2lSeaCgd0LCECQw0svr8LHkTXIDSFoLqYr0d40ZUXLnVqS5e9F2dyAvehfjf2uCnzKP9M6xFIYrg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by IA0PR05MB10120.namprd05.prod.outlook.com
 (2603:10b6:208:3df::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 16:23:02 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 16:23:02 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Bart Van Assche
	<bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Yang Xiuwei
	<yangxiuwei@kylinos.cn>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yingjie Wang <x-professor@outlook.com>
Subject: [PATCH v2 0/2] scsi: bsg: report data copyback failures
Thread-Topic: [PATCH v2 0/2] scsi: bsg: report data copyback failures
Thread-Index: AQHdYwrGup1JSqp51UubmKCeQTV6jw==
Date: Fri, 23 Oct 2026 16:23:01 +0000
Message-ID: <cover.1792772194.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|IA0PR05MB10120:EE_
x-ms-office365-filtering-correlation-id: bf969614-cc04-466c-f701-08df3121e8cf
x-microsoft-antispam:
 BCL:0;ARA:14566002|41001999006|38102599003|22091999003|25010399006|8062599012|31061999003|8060799015|19110799012|24121999003|5062599005|15080799012|8022599003|24021099003|1602099012|10035399007|26121999007|3071699003|102099032|440099028|4302099013|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?TjZoVkw5M09nTC92N1BXWE55bnJmWFdNRkhoMURib3JMaE1rYnRiQmZHbDVa?=
 =?utf-8?B?VDR6Y0h6WUxPZUM4MjhaNzQ0STkyZ3ZNYnpodTNMVlFNZU9yRHkwS3JZcmNP?=
 =?utf-8?B?NEZWNyswenpNTHlrQWZyd0NHV1pOSmZNVVpoUHNGRXlBaHBzYWVZL0pKVExQ?=
 =?utf-8?B?YXVHYVRQOHJFdmNVdGY2M3c2YUtWb3V6MHh2M3lZcXQrUXY0THVEZFQ3UHZS?=
 =?utf-8?B?YXpNSW40TlRveE1kMG1VVWVkNW1Lc2dNMzFhWk54c254cnNuby9ZclNkZW11?=
 =?utf-8?B?b1dNMXZ3aEtGMGlmWitoWXdhNlJKTmtOK2gzS1VPQ2FKT0VYV3JwMWZYbCtL?=
 =?utf-8?B?c3ZZS2ozQTN5K25oNHkwZzVQZjI3NWhxc0lMQ056dU55OE5ZK0tZd1p5alNH?=
 =?utf-8?B?NkFKUEwwakVGRVFXejU5S1A4dkorQWVzVEt2UEZuZ1c3RytyWk9WdGVRN2xZ?=
 =?utf-8?B?QmpYNHYyK2xBaHBDZTY1czluMi9SQUhLVmc2a2I5SHRKOGVWd0xrMW9rVC80?=
 =?utf-8?B?MkRpK2k2ZlBFMlM4WEtWbmVqejN6bDRlRmlwbnkrSWd2c2JZbFlPZmc5VnZy?=
 =?utf-8?B?aDQvNFZoVVRtU1hQOHU4VnlhaEVham95RGpzZC85ZlcwRGJ1eFNsT1dTQjZv?=
 =?utf-8?B?MzJHL3hFY1Z3T05mZXluQXJBaW1SMlhFN1FhRjh5RCtPRUcxM2NEaU9iNEhr?=
 =?utf-8?B?NUlBTVZrMEhGTEhWUytlN2pFSFVjT050aFVOQnowMnRUalRqQjI0Vk1tWVd1?=
 =?utf-8?B?L01icUZPSHVuSWVRelJremh5NEk5cll2VVpLV0pobzhzZFdtaThtVFEzODVG?=
 =?utf-8?B?WGo1MExaZzBWczMxbE1WVDFWTkUzdm1JZXF2cUhOOVQvNnlteHBGaHdxS2lX?=
 =?utf-8?B?dXplRVNHNFo3TFE1SkJROFNicVFVRnI0RHU3ZW8rc05nWTB6R2l4VnF6Uno5?=
 =?utf-8?B?aTFTWWtKN0lrbEp1MHFDdjVsMS80a01abXVYUGdnYjhoR1VuT1FmS3lXZ2tO?=
 =?utf-8?B?SlRkM3hFbVdlNmhoY1V2eVlmY1N4Ukl4SXBXL3FKRHk1NEJLSXpoNXZ6NndL?=
 =?utf-8?B?dGNZS3dKazI4SUFDVG5JMU5ja2t6VGo1UDhpdG9lcitGM0VvRjNMY1pHVWo3?=
 =?utf-8?B?SW5LMnBjQnoyaHZyN0tmL2FtaERJazlKczd3LzJRTWtaN3o5SklwZzBaQnN2?=
 =?utf-8?B?Q3A4RkZZV3VqVk52aG4rNDU0bWF0aXQ2SGJyMlpIK3hRVm5LSzJCUTBDWWpI?=
 =?utf-8?B?eWxVeGFqNkl5NEJVdStzTXNCM2NNanJZTGRaWHNNUnBoMlVuVjhYQm1VekV5?=
 =?utf-8?B?U2twUGdRbGROQ2hZOFRDZEhaRXFGVVR3eWZta3lSNVRsc3ZCM0tMUDZMakVB?=
 =?utf-8?B?blhMSW1kQk1ieU5DREZWVTVCQWdqb2NsRm5YVHB6ZzBYWWJTYmtXYkpXVWlt?=
 =?utf-8?B?dnFpdTgvTW5jYzNuQWxzQzI2cFVMcTllTkRRS3VUYjZjV2hSV0tQSklrc1Vz?=
 =?utf-8?B?MzRmRzBYNEFvZkJycFc4WW5pRitzRC80SCt5S2xWbTZrdlhsMHBIdmJVcHVt?=
 =?utf-8?Q?OW8vr9a7R1cyPAVDQI9jicR+sGWDFwW2d4z4shY7qjaKuM?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MUk3TkZHOU0vcDVLTmxKVWM3N09GbnBDaDJ4V0szTXhCcmpCaXZJMXNQOVdt?=
 =?utf-8?B?enl0c1c0dU5tYkcvd21hcUxmY0swenZjMERPSitiZE5pODVIV3IvaVNjREVR?=
 =?utf-8?B?SE9meTJZeEtGM3I2VGljWXNvaSsySUxucUxrVzBUL1VNcklvM2xzWFk3d1h2?=
 =?utf-8?B?NmZqRmpmbmQzWmFjRFZZakdEWEJ5YU5EVzNFdndsOG51RWg2bm0xZkZpM2Jn?=
 =?utf-8?B?dGxQRlB3NXVmVXh0bFNnUkJublhJSVBBSU1BTHM5TVJSUGxjdE81QzhnL3pT?=
 =?utf-8?B?RCtncXlmaldaNTdVb05XUWlwSEpYcC8xcGZqdkhQaTB1VDZJZTdTV0xvT21a?=
 =?utf-8?B?Mko4WnF6dW1JM0xQUStTUGtmVGd2dmhSOTd2MXp0U2VtWCtwdTV2UHBoTWV3?=
 =?utf-8?B?SDc1Z0pINk9SdGUxSnptbFFKUXVGak1mMENXR0c4R3F0KzhQYjdHNkdPU1k0?=
 =?utf-8?B?dTlpQU1WcVo1ZE80R1VQWWErYytwSDJpdkkybVpRWnJoZHZ6MTIxaHh6UU1t?=
 =?utf-8?B?WHd2eE9YL2JvMmhETkl1WWdYOFZYOWRVWU50R0ltOXphMkduQUdObWl5NUcz?=
 =?utf-8?B?WkV4U2xhZERJZFNMRnpxMTgyN0NwaHhWdG9PRWdCKzkyZmtCTjlJdzZoZ1Rh?=
 =?utf-8?B?NlRURElzM1AybXNrYUF1WHNEZkF5QzNhcytRMWs1eDFndGNwYnFkUzZDU2FW?=
 =?utf-8?B?Yk15NFkzcGZteFJwNzdXUUhoUmFEVU5Vd1g3RVRYS01qNXorZVc5T3YvWW5p?=
 =?utf-8?B?ellWZzVCQlZjZncrTUlBN3BIN3Y1a09zb2hxRTNxYjkzbXgrb3BFclV6c1VJ?=
 =?utf-8?B?Unp5TDRJQldHc3pYVkduV2VuUy91Qjk5WWcyWmxKZnMxaTUrWkloekk4cDdU?=
 =?utf-8?B?RzhuM2hjSCt1UUdqNjA5VmVWWFJ4WXd5QUc2VG9wQng2RkFhcW1LdkZIbjFX?=
 =?utf-8?B?VVNJeS80cDEra3dTL0Z0TDZ1NTVVQi92azlmMEo4MUVlZlpMTytaaTBnQmE4?=
 =?utf-8?B?aUpRQXBYRzJBMXVLMXpCV3hubmpFRjdlSERKamNqMEc3M0p2am51UzUxbXov?=
 =?utf-8?B?RWhBd1E5TDQwTkp5RTBhbytVb01sYjk4cnBtTEhOcnZLZjBPZzdNeFJvMGw1?=
 =?utf-8?B?YzJmcUdwVjg3WlY3MHg1aHRXdE4rUCtxSXY5TFNERUxGdFlDTkUxYzZudmdM?=
 =?utf-8?B?cGxvYVQ0eEhjTVlKSHdJZDlqWGhSNWRNWEh2dDh4SGRsZFBvT0FydG5mV1dG?=
 =?utf-8?B?bXJ6Q0EzV3JxV2NORC9aeW5pVkovQ05oQ29lUS9ud0FzZ3k4bi8yc0h2bkEr?=
 =?utf-8?B?bU5Lek81UGdCWFQ3UmQrWnY0NFYwWmFrdWJTb0Ztc2JSaWJ1SDNSZUxyamN0?=
 =?utf-8?B?WEZQS0QrT0VDVE93U2crLzVhRyttMEk4OElvUDBvZVkvS1ZhZEZoUFRqTkl6?=
 =?utf-8?B?Wms3bFN3V1QxVVU3NkJnQXFkV0xmZGw0MGRIWTJKUTVLZlp6dXNKR0pmeTI5?=
 =?utf-8?B?b0dvV0dkNS9WWTNpN3J1a0k5c2lGdmh0NUZrbTdnVDFXdHo1WXg3R2pESmFT?=
 =?utf-8?B?NlYxMWtDWjZSeTJkdUpTYXk4bjJCMFhPQW9aUTZxUGhRQ2FqQTBDbXpUMndW?=
 =?utf-8?B?d0pZcU5GaDZXejA0WUFDeTJFejlrbExqcnE1UGh2ck9Rai9nUzJGNEtaYUVm?=
 =?utf-8?B?WU9zejJPTWdJSkF6VVJwcDJGRUJMc2Z3Q2ttL2dRaXMxS2p6YUxvQm1mcGNl?=
 =?utf-8?B?b0RDdmo5VlhpK3llVWRvcFlFZEo5ckhiSnRGOGx1WGhZTG8raDJYR0Zodkxv?=
 =?utf-8?B?K0g2cUVWL3lCOW45V3locVkxVTlmN1FoUERQdnJKYkE0YVQzZTZkbjMwZ1lT?=
 =?utf-8?Q?Vxl2Jte/tTGPe?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bf969614-cc04-466c-f701-08df3121e8cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 16:23:01.9331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR05MB10120

VGhlIHN5bmNocm9ub3VzIGFuZCBpb191cmluZyBTQ1NJIEJTRyBjb21wbGV0aW9uIHBhdGhzIGRp
c2NhcmQgdGhlIHJldHVybgp2YWx1ZSBmcm9tIGJsa19ycV91bm1hcF91c2VyKCkuIEZvciBkYXRh
LWluIGNvbW1hbmRzIHRoYXQgdXNlIGEgYm91bmNlCmJ1ZmZlciwgdW5tYXBwaW5nIGNvcGllcyB0
aGUgY29tcGxldGVkIGRhdGEgYmFjayB0byB1c2Vyc3BhY2UuIEEgZmFpbHVyZQpkdXJpbmcgdGhh
dCBjb3B5YmFjayBpcyB0aGVuIGxvc3QsIHNvIFNHX0lPIGNhbiByZXR1cm4gc3VjY2VzcyBhbmQK
aW9fdXJpbmcgY2FuIHBvc3QgYSBDUUUgd2l0aCByZXMgPT0gMCBkZXNwaXRlIHRoZSBjb3B5YmFj
ayBmYWlsdXJlLgoKUHJvcGFnYXRlIHRoZSB1bm1hcCByZXN1bHQgd2hpbGUgcHJlc2VydmluZyBl
eGlzdGluZyBzZW5zZS1jb3B5IGVycm9yCnByZWNlZGVuY2UuIFRoZSB0d28gZml4ZXMgYXJlIGlu
ZGVwZW5kZW50IGFuZCBjYW4gYmUgYXBwbGllZCBzZXBhcmF0ZWx5LgoKVGhpcyBpcyB2MiBvZiB0
aGUgdHdvIGVycm9yLXByb3BhZ2F0aW9uIHBhdGNoZXMgZnJvbSB0aGUgc2l4LXBhdGNoIHNlcmll
cwpwb3N0ZWQgYXQ6CgpodHRwczovL2xvcmUua2VybmVsLm9yZy9yL2NvdmVyLjE3OTIyMzczNDEu
Z2l0LngtcHJvZmVzc29yQG91dGxvb2suY29tCgpDaGFuZ2VzIGluIHYyOgoKLSBTcGxpdCB0aGVz
ZSB0d28gZXJyb3ItcHJvcGFnYXRpb24gZml4ZXMgZnJvbSB0aGUgcmVxdWVzdC1yZWxlYXNlIGNo
YW5nZXMKICBmb2xsb3dpbmcgQmFydCBWYW4gQXNzY2hlJ3MgcmV2aWV3LgotIFJlYmFzZSBvbnRv
IDczNGJlZjU0OGE5NiAoTWVyZ2UgdGFnICduZXQtbmV4dC03LjQnKS4KLSBSZWNoZWNrIHRoZSBz
eW5jaHJvbm91cyBGaXhlcyB0YWcuIFRoZSBTR19JTyB2NCBjb21wbGV0aW9uIGhlbHBlcgogIGFs
cmVhZHkgZGlzY2FyZGVkIGJsa19ycV91bm1hcF91c2VyKCkgZXJyb3JzIHdoZW4gMTBlODg1NWI5
NDUxCiAgaW50cm9kdWNlZCB0aGUgaW9jdGwgcGF0aC4KLSBSZXJ1biB0aGUgZm9jdXNlZCBidWls
ZCBhbmQgdGhlIHN5bmNocm9ub3VzIGFuZCBpb191cmluZyBRRU1VIHRlc3RzIG9uCiAgdGhlIG5l
dyBiYXNlIGFuZCBmaW5hbCB0cmVlcy4KClZhbGlkYXRpb24gb24geDg2XzY0IHVzZWQgUUVNVSA4
LjIuMiBhbmQgYSB2aXJ0aW8tc2NzaSBkaXNrLiBPbiB0aGUgYmFzZQp0cmVlLCBpb2N0bCgpIHJl
dHVybmVkIDAgYW5kIHRoZSBpb191cmluZyBDUUUgaGFkIHJlcyA9PSAwIGluIDIwLzIwIHJ1bnMK
ZGVzcGl0ZSB0aGUgY29weWJhY2sgZmFpbHVyZS4gV2l0aCB0aGlzIHNlcmllcyBhcHBsaWVkLCBp
b2N0bCgpIHJldHVybmVkCi0xIHdpdGggZXJybm8gRUZBVUxUIGluIDIwLzIwIHJ1bnMsIGFuZCB0
aGUgaW9fdXJpbmcgQ1FFIGhhZApyZXMgPT0gLUVGQVVMVCBpbiAyMC8yMCBydW5zLiBXcml0YWJs
ZSBjb250cm9scyBzdWNjZWVkZWQgaW4gMjAvMjAgcnVucwppbiBib3RoIHRyZWVzLCBhbmQgdGhl
IGd1ZXN0IGxvZ3MgY29udGFpbmVkIG5vIEJVRywgV0FSTklORywgS0FTQU4sClVCU0FOLCBvciBw
YW5pYyBkaWFnbm9zdGljcy4KClRoZSBiYXNlIGFuZCBmaW5hbCB0cmVlcyBhbHNvIGNvbXBsZXRl
ZDoKCiAgbWFrZSBPPTxidWlsZC1kaXI+IC1qMjQgVz0xIENPTkZJR19XRVJST1I9IGJ6SW1hZ2UK
ClRoZSBjb21tYW5kIHVzZWQgQ09ORklHX1dFUlJPUj0gYmVjYXVzZSB0aGUgc2F2ZWQgY29uZmln
dXJhdGlvbiBlbmFibGVzCldFUlJPUiBhbmQgdGhlIGZ1bGwgVz0xIGJ1aWxkIHJlcG9ydHMgcHJl
LWV4aXN0aW5nIHdhcm5pbmdzIGluIHVucmVsYXRlZApmaWxlcy4gTm8gd2FybmluZyB3YXMgZW1p
dHRlZCBmb3IgZHJpdmVycy9zY3NpL3Njc2lfYnNnLmMuCgpBbiBBSSBjb2RpbmcgYXNzaXN0YW50
IHdhcyB1c2VkIHRvIGluc3BlY3QgdGhlIHJldmlld2VkIHNlcmllcywgdmVyaWZ5IHRoZQpoaXN0
b3J5IGFuZCBjYWxsIHBhdGhzLCBhbmQgcHJlcGFyZSB0aGlzIHJlcm9sbC4gVGhlIGNvZGUgYW5k
IHRlc3QgcmVzdWx0cwphcmUgcHJvdmlkZWQgZm9yIGh1bWFuIHJldmlldy4KCllpbmdqaWUgV2Fu
ZyAoMik6CiAgc2NzaTogYnNnOiByZXBvcnQgc3luY2hyb25vdXMgZGF0YSBjb3B5YmFjayBmYWls
dXJlcwogIHNjc2k6IGJzZzogcmVwb3J0IGlvX3VyaW5nIGRhdGEgY29weWJhY2sgZmFpbHVyZXMK
CiBkcml2ZXJzL3Njc2kvc2NzaV9ic2cuYyB8IDggKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgoKYmFzZS1jb21taXQ6IDczNGJlZjU0OGE5
NmU4Nzc0ZDZlZWY1ZGZhMjAyNmM2ZWRjNGU4MGIKLS0gCjIuNDMuMAoK
