Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794990789;
	b=LEPEFs74v5UcM3i73mrHv3NyXVYQzYNZgWinCg3DZpeqQfM7V5NZeLA2rLJtW4ZopbMk
	 6HxpAxEGKzt2+ZIRWIMu/f7bhOFQW8OSJhiWay2vJRFwRaPdGrVCrhx3xzSwOsv4idChn
	 T8SbvP7Zha6YRPSSO/q5bRrMDLKU1xulj3GAks4s/EUzIMIIWGT9V1rDy7pNEJKXAn6LQ
	 nDLlOWm03wFOmlU5XQcwsSEuXuvkqaz4LHw2cpWIat82FLqtsY2UjfwYiW8jQ5d0kEHKv
	 mhHEdCNvljALSdFoXwGiKgLiiEn+oc5EwdoT0NYrsBfFi8hbvufa9U3suo+xpKMtpoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990789;
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
	bh=0Lnzd5uWCl9542w1pcVRvoR1uWWsjXeKOqRw+5QJIEQ=;
	b=gxLD0da33r2PierVWmnJgTt07zL36wvIG3H2o6B2a03xFF1QRNytdjep+piQgZC9a7e6
	 7YfEoN5ExqJSqPxpK1M/WuMYGoTBAMdAG3Ji1YAX781AhS/kdQ/1dzJ2sVPXqmtrb+qSd
	 nzihCGd8HQvajmQrQoJ5oTKE43IoXH7L1vhmg02tdSOO4v1+w/66qywU1mPzzjbmcm94z
	 OIJvoUBeDigyZ5Ji/MrR/o+Kpw0/na8zbXSMzIv7vtPXqXd8W0mbn02BeWR1vRIq2Kgu0
	 kgPZ5khkMJ1N7QHnd5Pgo5oyzEdp1UaWBqYr2tpx0pkxVkeKzM4GNyhiMwyBlwFRNwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=C+lnzkCb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010005.outbound.protection.outlook.com [52.103.12.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D14F606A336;
	Wed, 18 Nov 2026 08:33:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D14F606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=C+lnzkCb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U4D9JN7A1BLzx4YWDU+R3AAjG8MktTXOo2TsiMAF/9UMVd6QZvkdLoLbR8tooYuMRLaN7++3N5PtiGfRTF5N/xFwQZ7YEa2qIm71OWkVQGcdK5g6s8ZRhQ2aXQtClyCpgL0i4psKqrFzCSxMGYC5+ht5JAlsK6RwSGcc0H/q7gIMMJDVWZOH+Gc9NEXMrYhMdJdqGymRLpJF3QIu2dgrU/OU6Kvyyr6TWbAB8AnhJmd8hvkjkXH8wSQ0IQR0eXnODwyQ48gaon8RSRYJ75sdx9YVusNJ1vQM7enVQhsN0z4F8GC2EbwgG7tUM4L/P6ChquB0kowTWbgHBqyFJeV0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=0Lnzd5uWCl9542w1pcVRvoR1uWWsjXeKOqRw+5QJIEQ=;
 b=fsKOj7NVorjJZLy4qG6od2vD3RGwedmTQH5jgpYD/nMrAha1WIVSU7j7HxGPbleTRMEuFdY+MTJQDwecAE6m3dbZBCjIG7oBNFwWXrXIN6YVMLHDUOMtzsqfzxJO4X0U5I13LKpIpC8pZ3yK2QZjVj9w9ks490JlpXwsBPdKJZrp9aUK39mzjg1diAETYBq6eucFuFFxYNdc2M35db4uBrVgGUT38SxuIhLzkZuT7pV/O7UU9XUezQxOEb9CFsF1uJ4dDpTyUQYsWKk1SHlkgglwCo/8WuL1Ri9LocHmUnylH19HKkepx5OKZq5UJafCRC/WAd5g9BGXgHHP29HKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Lnzd5uWCl9542w1pcVRvoR1uWWsjXeKOqRw+5QJIEQ=;
 b=C+lnzkCbyaFFFsRrZgVQTUCcbzRfGZoIOLFarKDb1uN+WigW+THGjDZkN3qKqS6JHgKLOvxvTILAWueEpTYpr5pWw8evcf5AAhcV3hrw7XWegJSccN1tOUOfDqjx6nsohuhXuZq6Yw/zKc+sP4JglJJXXSUq0ZHUfVL4wZyVDJ6G7imf4GEF6ARF7r79uuMbOOttBlHcpW40eJOWMv6XVobP1aVeCGQ/JwEkW0Smkym8vfitB9skbC92/nVMvWJYD0EE2FqBoVg4Vv2k+xaGVspcwUpApgybJoAYjctq2EtgmccUMPNSTDs7DyRzs0cOS8+fbACo3vq2qFGpGTO7ZA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB999481.namprd05.prod.outlook.com
 (2603:10b6:510:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 08:33:06 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 08:33:06 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/4] scsi: release completed passthrough requests before
 user copyback
Thread-Topic: [PATCH v4 0/4] scsi: release completed passthrough requests
 before user copyback
Thread-Index: AQHddzdvbZO/d09CckCvHeHhQD8Jtg==
Date: Wed, 18 Nov 2026 08:33:06 +0000
Message-ID: <cover.1794990780.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB999481:EE_
x-ms-office365-filtering-correlation-id: 72076dd9-ec94-4335-6f15-08df454e91b4
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|25010399006|4140399003|38102599003|24121999003|5062599005|22091999003|8060799015|8062599012|31061999003|19110799012|15080799012|12121999013|19061999003|3412199025|4302099013|440099028|102099032|10035399007|1602099012|53005399003|40105399003|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?NjZUcU1ZSHd6aXVVMFEwRWpacFN3ZCtQZlJpb2xCWnpra25oN1R6NjJ1dXo4?=
 =?utf-8?B?Qy8yak04V2JFU1NHbWlHM2RMVXFQRHR6ODZnNXlzYVRSVjY1R0dnd3hZdS9W?=
 =?utf-8?B?akFwZDhZaERoaExkbHgyT0pJT3JtSHpMQ041ek54WDFMaDRnVFU3dytJMW5L?=
 =?utf-8?B?V0hoN3ZuVTBxOFliYnVDbXZERm4wa3BVdENRcEp5YmdmNjlkRW1iZDJ5bWd6?=
 =?utf-8?B?OTJuWDVWKzNoZEFPNWJiM0RCZnNIbnpwZUdsaHhuZndDaHl3dWY4WE5UbTFX?=
 =?utf-8?B?Z2dtbHpabkg5MUIxNHppQzZlb1lvVEdKaHhzMXp2YTRsSGNYcCs0dklJbE9l?=
 =?utf-8?B?MnVGWk1ya1FLeUNWY0Nwa2w2UzJ3aXN4Tk8xUlJsNFdxRUswT1hhd2RVQmFT?=
 =?utf-8?B?R1VuRXRSbGpsMUxOQzRXeFNJRHRRNWZPTW5HdnlVMCtCUjVjUVgwa0N3aUZi?=
 =?utf-8?B?akZwbjhPb2sxYklkYURFRFE1ZUR4MFd3OW9HeVEwUGpKS2NjbDhMQ0hMN0Ft?=
 =?utf-8?B?eGRDUDVyRm1veS9kSFJkeUFsYVc4RGlHQlpITk1idWh3eHhqeUlmL3ZyVEhY?=
 =?utf-8?B?aTNHK3FkaS9SMS9tbXJmUVRyTXBmYkwwTDFUL2hGWXU2eXVGa1RxaHE0UmFi?=
 =?utf-8?B?Q2lwVytiUHZRUDI1RkkrTVhmblNYamhSOGlMeXZ3T3huNkEvaFMyakd6c0V1?=
 =?utf-8?B?NTVsYjdzRXpOb2kveTNoWGk5ejhndFVXQmFSQ3hPOUNzUHRUdElqSzU5RzBo?=
 =?utf-8?B?WXlUMUJHZ094SU9IVkhvWlRtSlVXZ2pXeEdZMmFnK00vT25FRnRCRldnWVV2?=
 =?utf-8?B?RXRhTEE4R2l1QVpPUnhxWVR0ck5lTkF0U2JYKzRFZXpiUDM0SGx5VUpTQTcr?=
 =?utf-8?B?c2RGbmpqaTlZWFpMME04VVdBWkdMemsxNUM2dlVDRWVmUTlXVjcvUjRDakZL?=
 =?utf-8?B?dWd1L3BpLzh4TWhZUElHakhHbkI5NnRjNG1tblVZd2cyaXA3cUp6VS84Q3g1?=
 =?utf-8?B?K0EvcGFSSlkyeGRnR3FzVHhFTmd1bkxvUVdVLzJTQ3FqVlBMZ2pXcEFvZnMz?=
 =?utf-8?B?NWx2K0YzUGV6cjBsK3pxdjk5WDI3WHZTSXhwOGFvYnFMLy9ROXlCUmJoVmFp?=
 =?utf-8?B?eTlDVVMxbU9UdEZmNnpVUFY5U2R2Wlp0aGY4VkdjS3dOMGlMZ09tU1dKWVF6?=
 =?utf-8?B?M0lBaGhJS2lJUFVRRjk5RFUyMkFCRnRZRzM1NmFjbHJIV0dYQjNuNWNyRVZ5?=
 =?utf-8?B?MXp1OXgrcXZDTmx1YkRMNEpWdUprWXRubTBOQWREdE5ZRlZ1Y2hCMWdoVFZ1?=
 =?utf-8?B?TE9kZThOOWVLMjUwcXZxOU1URHE2ekVOMnFJdy90T3A3dTMvUFczM3ZqTHlV?=
 =?utf-8?B?Y2IyYUd1NERQNkFVNnExQ0RQVkpRMkRpQnd5VTZvblVpOWtZRzVCaFdMQklQ?=
 =?utf-8?B?R1BTc3dXckEwK0hnQW1uQS8rM205QXAwT2twR1hjMVlMV0s1Y005UWZ1S3ND?=
 =?utf-8?B?ZVZibjBXT3pkUVBoMzhrVTl6b3ptSnFtWmxIdGFzUW9BV2U2OFA2d2JGbUYv?=
 =?utf-8?Q?hYIHwt2yfLRZ7CXWx2tyPQEMgjjo4djsAPWIFbzyF53Q+V?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R01JZmJmN3Vkb2tkNmFUY0prK2twWTZLL0U2TEJQU05yVms1YVNRTkNvSk5M?=
 =?utf-8?B?NXBRRVlTUXlUZUNwdWNBRFpnVFNWMWtNM096SXVqekh1NXlwNkkxZE5PWGhv?=
 =?utf-8?B?aEovZTBuMUVIWGlaMXlpRXljZERFbXFPVHdjaWFrbnhZWmI3cFE1U0kzbE5K?=
 =?utf-8?B?b2U3NU5nTDU0OXduUjJVMHhWVzFRci8xMDU5UU80aElFY3B0djR3VDMya1dn?=
 =?utf-8?B?RFRqY0p3bGtkU0FtS2pWNldLS3Z6ZDcxdzVyUUMzOXpiQlIvUnk0WUNINGVC?=
 =?utf-8?B?TzR5ZUo4YWJGamRlZk5FblFZdThWU2g5NHcyL1RqQmdLOW1LTENPWkpxMmJ0?=
 =?utf-8?B?YzhnQ2FLdVZ2cjU1T1c2a0JuWm5CalYrcjlVU0s4UHlKUUpsSkxDUlV3cnJo?=
 =?utf-8?B?L1JQYmpKbzR1cGFWejlFRmN4b2tnR2xIczQwYU94TDlMbXRsMThOaUlRMVVJ?=
 =?utf-8?B?U3Q2dUI4Q1I0RTZPcFhuNE96cnpuL2Ivc3ZnZUVBQTV5ZVN6TnE4K0t5eDB5?=
 =?utf-8?B?SkJyUlpSTGlRNE1VMllZUDJUeVVuOWtqQlZvem0wS0F6SHluQkVIa1YrU0hl?=
 =?utf-8?B?R1ZLclp1M3NaRk9aNi83SFU0bzRCMU8yU0tLdzVqMW1zWk1CdXJpU0luaStT?=
 =?utf-8?B?dkFIRU1HMzJRR0pReW54OUJLbVhrTUh0bXhtK3RQN2g3OXhjZVlDUzFab3lU?=
 =?utf-8?B?cDVQbU9xV0FFdTdZbkFVQ0h5Mk5Qb25RZ3RKNGN0a1lOZDNKcHY0OE11dDVS?=
 =?utf-8?B?ajA3emxnUUlabEJLbE9mMk1XUExYR0NFQlJGNE5nS2g5eGJOS1NqL2ZaQ3kr?=
 =?utf-8?B?YVhFS0pranR4NzhKUEVEQm9oNGRXT1ZvRW1NT2JYYzBWNTdlRW9MT2o2M1Mr?=
 =?utf-8?B?ZlpqM2YyNTNjNUovRlRPTGZoeVJsUWVIQ1VwOFhOdGdZeUFwd3dUTnRJZmlB?=
 =?utf-8?B?djN3QVdjak8raC9LejlMSnMrNGtwRnliYlBIQjNCUDBNQ25lazBZVVcwQmta?=
 =?utf-8?B?SWhWSGx5Y1BPNjNsVXFDeEJlRnJMWG96V1RGb2RFdnJubExRTUozYnRtTlNE?=
 =?utf-8?B?dks1ZEV6aWl1eExLSWxhaGJjY2RmQXZQcFNBckFudmlnUVFoLytJZGYrSWFn?=
 =?utf-8?B?QUZwcERNMkdpVzRwT2VnaVlBbXpoUkxjbGFVcGE3Y1dDdWo2T29zQ0Rra1l6?=
 =?utf-8?B?N3lQUW13RWhRaHlJOFcydExhR1BDQzhnMzk1blBNSXpRSHJMV2Zmd2plWkF6?=
 =?utf-8?B?WUphS3FSa3JvSFFFbnhPVjhkMjJPN3ZzVGQyQzd0UXorejU0bEhLSnRpTnZ6?=
 =?utf-8?B?SndoZmJIcjhNcHJmK1F2L2Y4dUFQaC8rdTZwa0ZsVDlST0c4cjczNkNGOTBx?=
 =?utf-8?B?bjVHSWRNQndVaVZ4ZmN3M2srdjlsejdqcElGajUzNGhkSms3OE5NVm13dkEr?=
 =?utf-8?B?S3NRYWgyUTUrd2xJa1dERjYwc043ZXhRSlQ0QXQwK3JqVDQ1L2dlVzE2Z1Jq?=
 =?utf-8?B?bmlQNXJBdmx1MFQxVmp2QmtDOU8rbGl3M1ExaTVBUkhrTmtXR0pXRjZzcmVX?=
 =?utf-8?B?QUhCVkdCbUIwUjVUSmdBM3hFeFZCc3FDbVB6OHlVbmxPa1pBZDgwczhtcWZ4?=
 =?utf-8?B?NE9WOFROR29pMzJFZk5HU2xmWUVvN1d5aXZqc1BISkZyV2dDZENhcEhraVQx?=
 =?utf-8?B?UUd5UGtPUlFXT0V1bDFQWE9kck5SL3pqenJELzhzSUt6QnN4TWE1U0JuMUth?=
 =?utf-8?B?emJZR29rVjlDdlUxdXBqclY4NUZwS1lBTkFzeHhKTEdXM1lVR2htNGhaQUdt?=
 =?utf-8?B?YWNRRENMTW9HdndsSzZBZlI3czFPbDUyYktsc2tiTG5mejk5YkpMcjJjbm1a?=
 =?utf-8?Q?15NqoIdsCwUZd?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 72076dd9-ec94-4335-6f15-08df454e91b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 08:33:06.3247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB999481

Rm91ciBzeW5jaHJvbm91cyBTQ1NJIHBhc3N0aHJvdWdoIHBhdGhzIGNvcHkgZGF0YSB0byB1c2Vy
c3BhY2UsIG9yIHVubWFwCmEgdXNlciBidWZmZXIgdGhhdCBuZWVkcyBjb3B5YmFjaywgd2hpbGUg
dGhleSBzdGlsbCBob2xkIHRoZSBjb21wbGV0ZWQKcmVxdWVzdC4gIElmIHRoYXQgdXNlciBhY2Nl
c3MgZmF1bHRzIGFuZCB0aGUgZmF1bHQgbmVlZHMgSS9PIGZyb20gdGhlCnNhbWUgcXVldWUsIHRo
ZSB0YXNrIGNhbiB3YWl0IGZvciBhIHRhZyBoZWxkIGJ5IHRoZSByZXF1ZXN0IGl0IHdvdWxkCm9u
bHkgcmVsZWFzZSBhZnRlciB0aGUgZmF1bHQgcmV0dXJucy4KCkVhY2ggcGF0Y2ggc2F2ZXMgd2hh
dCB0aGUgY29weWJhY2sgc3RpbGwgbmVlZHMgKHRoZSByZXN1bHQsIGJvdW5kZWQKc2Vuc2UgZGF0
YSBhbmQsIHdoZXJlIGEgdXNlciBidWZmZXIgaXMgbWFwcGVkLCB0aGUgQklPIGNoYWluIHNhdmVk
IGF0Cm1hcHBpbmcgdGltZSksIHJlbGVhc2VzIHRoZSByZXF1ZXN0LCBhbmQgdGhlbiBwZXJmb3Jt
cyB0aGUgdXNlcgpjb3B5YmFjazoKCiAgMS80ICBTR19JTyBvbiBhIFNDU0kgYmxvY2sgZGV2aWNl
IChzY3NpX2lvY3RsLmMpCiAgMi80ICB0aGUgbGVnYWN5IFNDU0lfSU9DVExfU0VORF9DT01NQU5E
IGlvY3RsIChzY3NpX2lvY3RsLmMpCiAgMy80ICBDRFJPTVJFQURBVURJTyB0aHJvdWdoIHNyX3Jl
YWRfY2RkYV9icGMoKSAoc3IuYykKICA0LzQgIHRoZSBzeW5jaHJvbm91cyBCU0cgaW9jdGwgKHNj
c2lfYnNnLmMpCgpDaGFuZ2VzIHNpbmNlIFJGQyB2MzoKCi0gRHJvcHBlZCB0aGUgUkZDIHRhZyBh
bmQgdGhlIGlvX3VyaW5nIGhhbGYuICBSRkMgdjMgNS82IGFuZCA2LzYKICBjaGFuZ2VkIHRoZSBh
c3luY2hyb25vdXMgQlNHIHBhdGg7IGFmdGVyIHJldmlldyB0aGV5IGFyZSBiZWluZwogIHJld29y
a2VkIHRvIHVzZSBhIGNvbXBsZXRpb24tYnVmZmVyIHBvb2wgb3duZWQgYnkgYnNnIGFuZCB3aWxs
IGJlCiAgcG9zdGVkIGFzIGEgc2VwYXJhdGUgc2VyaWVzLgotIDEvNCB0byA0LzQgYXJlIFJGQyB2
MyAxLzYgdG8gNC82LCB1bmNoYW5nZWQgYXBhcnQgZnJvbSByZWJhc2luZyBvbnRvCiAgOWY5ZTBi
MWU1Mzk5IGZyb20gNy40L3Njc2ktZml4ZXMsIHdoaWNoIGFwcGxpZWQgd2l0aG91dCBlZGl0cy4K
ClRlc3Rpbmcgb24gdGhpcyB0aXAgYW5kLCBmb3IgY29tcGFyaXNvbiwgb24gdGhlIHVucGF0Y2hl
ZCBiYXNlLCBib3RoCndpdGggS0FTQU4gYW5kIGxvY2tkZXAsIGluIFFFTVUgd2l0aCBhIHZpcnRp
by1zY3NpIGRpc2sgYW5kIENELVJPTToKCi0gMjAgaXRlcmF0aW9ucyBvZiB0aGUgZXhpc3Rpbmcg
cmVncmVzc2lvbiBwYXNzIDk2MCBhc3NlcnRpb25zIG9uIGJvdGgKICBrZXJuZWxzIHdpdGggbm8g
a2VybmVsIHdhcm5pbmdzOiAyMjAgZm9yIHRoZSBzeW5jaHJvbm91cyBwYXRocwogIChTR19JTywg
U0NTSV9JT0NUTF9TRU5EX0NPTU1BTkQsIEJTRyBhbmQgQ0REQSkgYW5kIDc0MCBmb3IgdGhlCiAg
aW9fdXJpbmcgcGF0aCwgd2hpY2ggdGhpcyBzZXJpZXMgZG9lcyBub3QgY2hhbmdlLgotIFRyYWNp
bmcgdGhlIDgwIFNHX0lPLCBCU0cgYW5kIENEREEgY29tbWFuZHMgdGhhdCBtYXAgYSB1c2VyIGJ1
ZmZlcgogIHNob3dzIHRoZSByZXF1ZXN0IGZyZWVkIGJlZm9yZSBibGtfcnFfdW5tYXBfdXNlcigp
IG9uIHRoaXMgdGlwLCBhbmQKICBhZnRlciBpdCBvbiB0aGUgYmFzZSBrZXJuZWwsIGluIGV2ZXJ5
IGNhc2UuICBUaGUgbGVnYWN5IGlvY3RsIGhhcyBubwogIHVzZXIgbWFwcGluZyB0byB0cmFjZSwg
c28gaXQgaXMgY292ZXJlZCBieSB0aGUgZnVuY3Rpb25hbCBhc3NlcnRpb25zCiAgb25seS4gIFRo
ZXNlIHRlc3RzIGNoZWNrIHRoZSByZWxlYXNlIG9yZGVyLCBub3QgdGhlIGhhbmcgaXRzZWxmLgot
IFRoZSBDRERBIGNhc2VzIGV4ZXJjaXNlIHRoZSB2aXJ0dWFsIENELVJPTSdzIGV4cGVjdGVkIGVy
cm9yIHBhdGgsIG5vdAogIGF1ZGlvIGV4dHJhY3Rpb24gZnJvbSByZWFsIG1lZGlhLgotIEVhY2gg
Y29tbWl0IGJ1aWxkcyB3aXRoIFc9MSBvbiB4ODYtNjQ7IHRoZSB0aXAgYWxzbyBidWlsZHMgb24g
aTM4NiwKICB3aGljaCB3YXMgbm90IGJvb3RlZC4KCkFsbCBmb3VyIHBhdGNoZXMgY2FycnkgRml4
ZXM6IGQyODUyMDNjZjY0NyAoInNjc2k6IGFkZCBzdXBwb3J0IGZvciBhCmJsay1tcSBiYXNlZCBJ
L08gcGF0aC4iKSBhbmQgQ2M6IHN0YWJsZS4KCnYxOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9y
L2NvdmVyLjE3OTIyMzczNDEuZ2l0LngtcHJvZmVzc29yQG91dGxvb2suY29tCnYyOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9yL2NvdmVyLjE3OTMwMDMzNjMuZ2l0LngtcHJvZmVzc29yQG91dGxv
b2suY29tClJGQyB2MzogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci9jb3Zlci4xNzk0MDQ1MDEw
LmdpdC54LXByb2Zlc3NvckBvdXRsb29rLmNvbQoKWWluZ2ppZSBXYW5nICg0KToKICBzY3NpOiBj
b3JlOiByZWxlYXNlIFNHX0lPIHJlcXVlc3QgYmVmb3JlIHVzZXIgY29weWJhY2sKICBzY3NpOiBj
b3JlOiByZWxlYXNlIGxlZ2FjeSBpb2N0bCByZXF1ZXN0IGJlZm9yZSB1c2VyIGNvcHliYWNrCiAg
c2NzaTogc3I6IHJlbGVhc2UgQ0REQSByZXF1ZXN0IGJlZm9yZSB1c2VyIGNvcHliYWNrCiAgc2Nz
aTogYnNnOiByZWxlYXNlIHN5bmNocm9ub3VzIHJlcXVlc3QgYmVmb3JlIHVzZXIgY29weWJhY2sK
CiBkcml2ZXJzL3Njc2kvc2NzaV9ic2cuYyAgIHwgMjIgKysrKysrKysrKysrKystLS0tLS0tLQog
ZHJpdmVycy9zY3NpL3Njc2lfaW9jdGwuYyB8IDM0ICsrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0KIGRyaXZlcnMvc2NzaS9zci5jICAgICAgICAgfCAgMyArKysKIDMgZmlsZXMgY2hh
bmdlZCwgNDEgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCgoKYmFzZS1jb21taXQ6IDlm
OWUwYjFlNTM5OTA0NTk4Mjc4OGE5NTRkMzQ2MWRlODk0ZTQwYzcKLS0gCjIuNDMuMAoK
