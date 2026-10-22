Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792655523;
	b=qWXfVegXApJ7OSklxl0Sq5jP8rrU9KwlNuX8A6/Wlp+AtCVhSB0YGjUsCWJzDL9RfkRa
	 8b7xJbp3KFhgA7h9Z6iuWEzU59kf3j5H+9LhSQdlcsFSzgG8k+gQKprzTRj7KFyc+/4db
	 WsvxvhsDo2axpdMQbcdc3tDREEv473sKuNWc2wpIuaZv4brbhNa9xi3IPmpNSRhyo851g
	 OsuSn5UF4m2FRLXtfP2OcpmXs0jFoZDmxaT6VGZWbj2qxAJ3sEpXmenqMxQ8Zj5qOz/01
	 jgZs9eD8U23GJ2CxmzTo7/B4OhNpCNJsuvsFoBEVhO5C+HTDNrArcp2foOxCKHkkHAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655523;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=+181LyluUwUoLBbosbWqlqSAMfgqimhtD0Lc9afAUyU=;
	b=vAsiyYI3afENSi9E0iUOi2bxccdmVtW+uaEyvoLpJS6vNpNSuI2oMpprwtdMgjuwPu6H
	 bXJkxcu9NEfA0pRlPEv1rjbyYWSM1AtmdLp/Dm8Akv8HhLgxMmbBsQB1p7sOCEJjHtGzU
	 cj127XAbZcOUaDC6290eGZCnPEj49mR3lA6o7bg2ZoBT2gErw2SO0zqan7PHdpc5RBWz1
	 QYR3kriSSIGBIp7l1gMiGgX8Ci8L3kiPZVObD0BUAcrZ44zssqma5dzkbZnJhWGHXa2rJ
	 dzEr8uSVpq6P5Auwh7VuKRjsUuJzR6DzSkpeEugEBs1kbdqm/NMKV3PfAPM3gx17lCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=cLRydBY+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.26
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazolkn19011026.outbound.protection.outlook.com [52.103.13.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF1A606A31A;
	Thu, 22 Oct 2026 07:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEF1A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=cLRydBY+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zCVfVn6oxTWdGtI6QdNqAp5TYp58b76V2QPAhek2V9bsoLvhegiYh1kLwCcYdQvNP09haePf60ML/7r0VKLcjDwciD3yhtkBvCED1vHwvkQHg5/DQOLlGlZB26HO/5l+PyfkaN7MYpyaUW6rF3kCzQUPMU1cdPf34PzXf0jk6A1C7Z43iP7bY7+gafXutUydcaxzQe5in7o1GvsdvPslbWnmbkGCGdc/JIS08iyNpGkXxHshMpBAIHPBjCxWGU74tAH+EtSHU/1BbLZoA7JuABeA1M9iAD/J8zTs20/9PugKFKcwdJN4AQSZNojUMMlPY34D3+8iSdptcXpepJnsVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=+181LyluUwUoLBbosbWqlqSAMfgqimhtD0Lc9afAUyU=;
 b=kPeWAy4Rctd0rwr5jmAtnJF5Lp4xh7xQjiOhhvVN0gdvhe6TExIRrOQGGwi/qBruvZarB+t0OQk1cgvPb32xYAFnTj64FGFg1dpN8RnsWMqBDwHkcbx3Eylki49ecp22a3YL3VKFTXgsJdwfcHWV+/+7tAB20uq7EFs3AJgst9MQtZRuoAInR1R2mhKxv7hgT9LI245ICf1JOrL5EVQyGlRSC0Zp7BVmLKFLX/CxVQOJ9ki4FcT1rK1OwNGqpxdPn50ga9dj1osinVRji7djJZKgQwjJ59c23wfwDnLIsoKq0FQqyavXqG4dvcaTkbniVkEUrQCww5nQPNE98Mo2Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+181LyluUwUoLBbosbWqlqSAMfgqimhtD0Lc9afAUyU=;
 b=cLRydBY+8v1LcoDJoKfy115ZjFj453Kk/07kgSIWZeX9qamVcMbYQQrDDfzavxah6GUZmvmdNarl7WFSMB8V4ovJ3agdRx3ALtttW+tYAl9iJ89Fca4ZWFXvio+Rxr5BV1Vrd8arxgNWPcrQBIWR4UFWuEaEwSPV43ge+HD79hfpcUcxLfMyhb1l2dwjfF7YegJu/c/Qi3Gj9qogWW+WnF7dQ/TY3gItm5EHPRqEFteRWE0Gj2pm4MnpYTJflL6vADYY8EhOm8Ar0HGS9Sn1xpAfJYR73IzXAx3NVSjUpEWmNrhjsvhx5/UL0Qch5qfmA+QPGGw7hfkaNPRhhfKoPA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by BY1PR05MB10751.namprd05.prod.outlook.com
 (2603:10b6:a03:5ac::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Thu, 22 Oct
 2026 07:51:53 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 07:51:53 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/6] scsi: sr: release CDDA request before copying to
 userspace
Thread-Topic: [PATCH 2/6] scsi: sr: release CDDA request before copying to
 userspace
Thread-Index: AQHdXxcX460T75kswEWMB4lVopRdp7cFVAYAgAPiMYA=
Date: Thu, 22 Oct 2026 07:51:53 +0000
Message-ID: <20261022.scsi-cdda-lifetime.8f31a2c97b42@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
 <94d7bdf7391f208b74ba98988c2a52c939d689e6.1792237341.git.x-professor@outlook.com>
 <035f0183-a748-4eaa-a6a6-a358944535fa@acm.org>
In-Reply-To: <035f0183-a748-4eaa-a6a6-a358944535fa@acm.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|BY1PR05MB10751:EE_
x-ms-office365-filtering-correlation-id: d5d5559a-894f-422e-bc06-08df3011569b
x-ms-exchange-slblob-mailprops:
 9IecXKUgicApcBHgIkF1u3SRiU/lhwt0sYX8FcwPrx337CMEGB6N3wVZT5uRZp+FsxvBoXDCQINinm07dvGlIiMiZpmuAGtQ3t4sZ1hHKsT9/pxacHmzCbOdzC3nG2G3vXf/Al8RZNrgUNctdNSzgdw7Cju/xwLPU+k6ASbUjHe1nxB0niqSWYx/++gFjf5/QXvVFkHZ3rzqzqMzkiYbB6mPAmrFbYHrjR+BNIFGMoD9BAYJstMtmACR1KT06E+mICwJWqQiuL9Nf7l5vjnDRtQUmwsqHmKQZdMEMkfPnxKaBv/4ZIHrk1c7OxhtUo2fEWPyDQS2UYngBW/phTq6zPswUK7N2BVxBoJ9pDgYuulimn0K9HB1jDWIE6uhSTYujLA2nyVDJLSef7bo1Ui1m9adALz0JDkWwDv6QgDDY9kBCKBRjbj7oqWJtJtr/lXFS6yOPUenSjwExJQ914XoD6P0/DZEvqB7yNYeZZHVUNJKWL+Jqck+An6IlT+CN4W6XQQKJtzPoYto2mla+/TFgoq3UPYkF+ZUHvTDh5H1bed6YTqqx7ONZY6WRxRWbDJhqtXYISK4+AzVCeid4QBFZvFtYK88IGdakNZ1fbrCRDNLPj7YadoRuldzG/bYiHKboOrvIGu5BH/GmctS1J4Gnr3CJTWVlevq9CC8khgMz3u/VOA2v2Ey4BzDqFh+jy7MnP81W6cFK3xoRbbJg1yTauWY62YDYG3Bh3dQKYno7K2MsDF6pNTpzw==
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|39105399006|22121099003|4140399003|25010399006|8060799015|8062599012|19110799012|22091999003|24121999003|15080799012|31061999003|24021099003|12091999003|40105399003|26121999007|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 =?utf-8?B?N281aDNubzR6cU1rSGxOaHdyWDRWRDlJTngrWU9td0NyN3lUQXZoZVQzeEly?=
 =?utf-8?B?YWRMbzdhbFZ3M3Zzd1ErcjZ6eVgvVzFRbjYvQXNtYnAxeElCUHN5Y00xeDFn?=
 =?utf-8?B?RzFwcXUrWGh3UjZueXVUaUlDd21GQ3ZNS2xlMmNTL2c4OWZiS0lkdDI1aXNU?=
 =?utf-8?B?am9oNklFRHh4MktXdkVyNUllUW1WRjYrYmljaC9tSkJmZWpiRUdSbGFPa0tP?=
 =?utf-8?B?UExERi9uVjdhaHJWeUQ3SzF1WFJPM1JzdXE3Wmh2a2RHSGJuZXJaV3ExNXJM?=
 =?utf-8?B?cTgwbTljcTJjK1dYcWJJK2hEUXNycjB6WUxGL3FDcHg1ZndkR2s3NW0rNThq?=
 =?utf-8?B?K0RlVmVyYUE5ZWwxT1plVnpKcytEbG02WktMWE9KWHdjbHVNZ1A0dHUvM3Vh?=
 =?utf-8?B?VEl5NmE4TW9EbE5yRkRDSzhydDZ0WXczaWNrejN6NlR4ZUFYbnBYVkJuSGlY?=
 =?utf-8?B?VlFqdW1mcFhBZlBwakV3bStVUFpwK1lyK3BRbnNLaTF6VGFKclUzck9xaEg1?=
 =?utf-8?B?OGtpbVJwTHpicEJJVlhsVTlyeFlOZTIzTW4zb25sM0dvRGg0QVFvcGRzQVVZ?=
 =?utf-8?B?VVlXOTJkTFVWMStrU202NERhcThPOEFJTVUweUt5SFBzbHZoMy9wZkJZdUYx?=
 =?utf-8?B?dHprVDlZdDhNVXpHMDRUM3VRTTRrRWt1MEhacCs2dzBaYU0zbktwbUtldTRE?=
 =?utf-8?B?MnBTQnJkcWQ5OHJHbkZpWWtGcE5leEx2eUZwbEVHdGhUTnpGcU5zWWpVYWl3?=
 =?utf-8?B?YnMvTlBCSitXUkc3Z0hpUzloYUw0V0xiUXJ3WERCZ2FWRklJTjVzUy9pVFZK?=
 =?utf-8?B?cFVZQXgwdklVamJ4RHFwNDNQQ29nU09pMUtmdjBjb1NrVmx2T25MdHFVM2dE?=
 =?utf-8?B?aVEyenJFVDZVem9kdDhvTndQeG9FendYS0syVjRBNG9KejVmOC9nc1pxYW90?=
 =?utf-8?B?OFc0KzJjclZ0VkFLaHNaMERzcitBanZJZHJiZG52RGwxN1h3U0JxZXlrYXFP?=
 =?utf-8?B?Q3YzNjE4R1lwUldpQ2NqMHBjSkIrTnptdThpNThzRVZ2YVdVQlBiVTJrZ2cw?=
 =?utf-8?B?b2JzMXhId2M0MWg4Z2VSV3lsanh5T3hBS04vRXlJKy9IdlFTQzZqbEhJZm5n?=
 =?utf-8?B?YjdEemF3QnpnMCt2MnBDdDdGeVlZcWsyYm0yTC9VbzdKaHNMaGxBc2dLTVEw?=
 =?utf-8?B?Q3Zlb3M0V2RQN3RlTUJrUTFDVVRiUnNZNjBTam9iS242cWJNcWc5WWFZL2dK?=
 =?utf-8?B?ZVZoc2k0N2FiUFkyMzNiMjBYc24rdUhNQVJlZ3BWMG9WbjBFUlFnc3A3YWJO?=
 =?utf-8?B?aXdnZ1R1VjR5Z2xOY2s4c2xwN1NTR25QaWl2b3VZZ0N6VUZNNm05ZnRlUk11?=
 =?utf-8?B?Tk9MRHQ5Y3Bhc0V6RWpHMHBUd0V2SStUNTZmTVBtSnRMaUl2RUNzZHdCbmE1?=
 =?utf-8?B?UHZ6amIvdmlFM2NpWTRsVDJNeWZTQU43czNGdXZWaXZTejkrNkNFRzRJbzYr?=
 =?utf-8?Q?4BC3fc4YmMWL6SUDaXH44a5lflj?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RnJnWXMyNDFsZjJDeUFnWU51OGlTTnpPSTZ5Q0dkWC9MTHd0UVMzQ08rYmJx?=
 =?utf-8?B?V2lMNHBkZlhxeHExUlVDbVNNUGsvcDhBdzVQWVcwMko2RWdja0JFTU9NRGFZ?=
 =?utf-8?B?Y3ZhRElRbnBLUVlUOFpFd0Y2MUw4SnNJZWE5c09CTWQ2MnVObFU2NEJiM1Bw?=
 =?utf-8?B?VEY4SStkQk1qRHJCcm5JWE5ySlJyMlJ4K1BiZ3k0a1BCdG9GdVh0dlZkeHRr?=
 =?utf-8?B?Unh0UWJmL1BJOXUzSlgzaElVd2FzejFqaGord1c2M1lwQk95ZFY4TlVMZUpK?=
 =?utf-8?B?ZksrNmdza3Z5Vmg2ZnRTWDR5Nng5eWk2VkhwR3VwQldTNHZKQzBnd0drd05P?=
 =?utf-8?B?elZlV3ltUnkvLzI1aE4wOXhsZkI0cFdpZGVvM013QkgwZXY4bHdhZitFcE1t?=
 =?utf-8?B?M0VTbmVrc0swQVRiUUoyYXBxZUp5d2lMRTUyZ2pWL25SaFlLU3RhV1pKbHda?=
 =?utf-8?B?L05lMzdIN3QybVI2VUpLc0R4cWpHNUwwaDQ4QkYzZ01yK2hnVmZTWm90enRt?=
 =?utf-8?B?UG5HeHNCalhDNkc0cVpSZnpwN1UvbC9WODF5dmFKZmFSc0lZYWNPbzZLcnlE?=
 =?utf-8?B?SkJEdVQzS0xoL1FHQkhyaVZDdTVaQm1teC96REdMQzJqNHZxS2NRbUViN3Nz?=
 =?utf-8?B?Vnl1VVpPQm1XWlpGT1BvZFp2bThwYldyMUNoRXd3bGdiN0J0aFUyOG00T2R1?=
 =?utf-8?B?YWlNUmIreDlIZ25TUjgvbXplUmlVemgvalJMUmZFdFZLMWFqVHAvUmQwWlYr?=
 =?utf-8?B?YWlOcWpDYk5KNjVGaVg3bm9yVWkxemFhaDhWVldNdGlZTTVRVHY3SFQxazkv?=
 =?utf-8?B?M2grR2V4T0N1MVJUOElkMWdUZ3BHSkpjQjgyb21xQk1ldEZWQVRTNStLdmVx?=
 =?utf-8?B?K2pwNm5IMGR2c3FlQWg0L0xGQzlQTVVBOThLV2dMSVhXU1VJcDFxcFdHWE9t?=
 =?utf-8?B?K1FJSlpIR0NYbkZ2VklKWW03S0Z4RVlmRGVxNWpIdW05UDFDVGp6ZjNJVVBo?=
 =?utf-8?B?ck56SXk5RzJWbEkvczlsSytlbzJ3ZFBaRDdCSm9tN3RSUm9wM1dxNS9CaUJy?=
 =?utf-8?B?UUpSc3dKWWpPR3Z0UkRyaFBoUDEwY28xdXJ2L0dmRWp4NS9OdGIzclVIS2Qz?=
 =?utf-8?B?N3R3ajVyUFRxVmE1U243Vnh3VWpxLzFsN1l3U09ISUo5eHl4MEZTOE5pT0ZN?=
 =?utf-8?B?U0pxMXJ4UFhUdUU4bklQTUdJOWtoWklsUHRTRVgreTFkU3FnQ1VHajNvaWlO?=
 =?utf-8?B?L1NkYlMzMWxoN1VvRnVuNkxzbncxakFBK1kwaURxYzhyeWdZSi9iMUpGQmkv?=
 =?utf-8?B?bFhPZVBoVm1KV2VWb0tFZ2hMYms5OXRhSVBsMmduZXVzanZsRVZnb1ZHR2pL?=
 =?utf-8?B?UVR5YXlxb254T2YxbWd4a0V0K3pqMko0Z3lBeWhlL2FoeFVrWHRGeGRTdHdY?=
 =?utf-8?B?ODVVOG1PaXFucWxnbUlicDRnNUw0MmpWUllQeFdMMUFCYjMwV01qbVhMTWNj?=
 =?utf-8?B?U1BJc1RiSENkQlFINEQzam5YdWRpNC9RTFVkZ0pRVVRoVnRJdzIyYTZSYjcw?=
 =?utf-8?B?aXRkRUpQaEdBSnVJSVhiOU4rZ0V6NTJxbWVoWVZySkpGRERJaDV2ZlFtcFl6?=
 =?utf-8?B?U0ZhWXBLVEpCMkZpRjdzRlQ0ZW5YbzNJVVVPcFY4TnpnWWFzcW9PNGJPOUhm?=
 =?utf-8?B?YkRiYW9RWG56K2VkMFE0czFjNEo0Nmk2Slljd3V0VG5MbE1sSmRkNlc2bEhT?=
 =?utf-8?B?QnBzV2VYejd5Y203ckR4NXdLN0J6amVNRlFRVVB4M3FZb29QeDg4cmJteFBK?=
 =?utf-8?B?TkowUXNRbDVaRDU2aCsyZkNlZlAvV2tjSGlqai83ajVTUnd4clhXYnpDRjdm?=
 =?utf-8?Q?Ps+fg7cJ2NRAT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51559F32B763334A9966B2E3265B4FCC@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d5559a-894f-422e-bc06-08df3011569b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 07:51:53.5469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR05MB10751

SGkgQmFydCwKCj4gVGhpcyBjaGFuZ2UgdHJpZ2dlcnMgYSB1c2UtYWZ0ZXItZnJlZSBiZWNhdXNl
IGJsa19tcV9mcmVlX3JlcXVlc3QoKQo+IGNhbGxzIGJpb19wdXQoKSwgaXNuJ3QgaXQ/CgpJIGNo
ZWNrZWQgdGhpcyBvbiB0aGUgc2VyaWVzIGJhc2UsIDBmY2IwNWI3MjM0NC4gSW4gdGhpcyBwYXRo
LApibGtfbXFfZnJlZV9yZXF1ZXN0KCkgcmVsZWFzZXMgdGhlIGNvbXBsZXRlZCByZXF1ZXN0LiBJ
dCBkb2VzIG5vdCBwdXQKdGhlIEJJTyBjaGFpbiBzYXZlZCBmcm9tIHJxLT5iaW87IGJsa19ycV91
bm1hcF91c2VyKCkgbGF0ZXIgd2Fsa3MgdGhhdApjaGFpbiBhbmQgcmVsZWFzZXMgaXQuCgpzcl9y
ZWFkX2NkZGFfYnBjKCkgc2F2ZXMgcnEtPmJpbyBiZWZvcmUgYmxrX2V4ZWN1dGVfcnEoKS4gQWZ0
ZXIKY29tcGxldGlvbiwgdGhlIHBhdGNoIHJlYWRzIHNjbWQtPnJlc3VsdCBhbmQsIHdoZW4gbmVl
ZGVkLCBub3JtYWxpemVzCnRoZSBzZW5zZSBkYXRhIGJlZm9yZSBmcmVlaW5nIHRoZSByZXF1ZXN0
LiBBZnRlcgpibGtfbXFfZnJlZV9yZXF1ZXN0KCksIGl0IG9ubHkgY2FsbHMgYmxrX3JxX3VubWFw
X3VzZXIoYmlvKTsgbmVpdGhlciBycQpub3Igc2NtZCBpcyBhY2Nlc3NlZCBhZ2Fpbi4KClRoZSBz
YW1lIG93bmVyc2hpcCBzcGxpdCBpcyB1c2VkIGJ5IHNnX3JxX2VuZF9pbygpLCB3aGljaCBmcmVl
cyB0aGUKcmVxdWVzdCB3aGlsZSByZXRhaW5pbmcgc3JwLT5iaW8gZm9yIGxhdGVyIHVubWFwcGlu
Zy4gVGhlIGRlZmVycmVkCmNvbXBsZXRpb24gYnJhbmNoIG9mIG52bWVfdXJpbmdfY21kX2VuZF9p
bygpIGFsc28gcmV0dXJucwpSUV9FTkRfSU9fRlJFRSB3aGlsZSBsZWF2aW5nIHBkdS0+YmlvIHRv
IGJlIHVubWFwcGVkIGluIHRhc2sgd29yay4KCkJhc2VkIG9uIHRoaXMgb3duZXJzaGlwLCBJIGRv
IG5vdCBzZWUgYSB1c2UtYWZ0ZXItZnJlZSBpbnRyb2R1Y2VkIGJ5CnBhdGNoIDIvNi4gUGxlYXNl
IGxldCBtZSBrbm93IGlmIHlvdSBoYWQgYSBkaWZmZXJlbnQgb3duZXJzaGlwIHBhdGggaW4KbWlu
ZC4KClRoYW5rcywKWWluZ2ppZQo=
