Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794990791;
	b=p5qY+bbzDr27fwkiIuilwETZ53w7CPp1Z6TJ7tZ3IOXucwiw1Z0Gqk0MQwYgCH4Y/z0D
	 kHh9tGgAU9iHM0+F80RrBB151hOfdejbGERBmniCQgHG7t28cBA9auDp7vq02aozQSo6K
	 fQof8fU8JniWcRAOH2exQTh+TYFKlxffBFR7AJz7pUb+V824AcU+eu0SMMwLrV+t5Nqqc
	 OnEtb/Jx161z6sVOcL7p87nacydOFMeXId7CccXkIOqlLRbAj3C5RhktUzeP0Vr/n1K5R
	 6tZZFJ8MYohuvR7bzV+E3fvRc4WXG8eJ7Dq9+jW9ZBH5n0I1MAyWLTB5Zo4X4u8ke5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990791;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=XkxkvofG2CwwVPUpKe4K4+isPaNUJBz8gLauoUUuOJU=;
	b=syFOJzSSIzLQi31ixlj/dqindm7Ip6WdEgaDxsGy9zXiTThZl2Zjj2DTDhIpvfIRZyGS
	 I1plLJUB/PjX2y/tuxfgRYxcd2xJH9vlZpGlbD72wKQutFlQ1kopg66PLksc7jMxeaK9K
	 T/OU2ucjW+DbmGrhSQX11MDsU7VOftwT9MivOq+hUAaS+4xq/UrRZglYiBRBCSvMBFUXH
	 SFngEV97+zEpyalBCFPYpW9mOZdy5mptmr7GQ5yQ9nU81as3QsnblWaTb2qItxZTHlmSG
	 KAG12e/NQy2hQ/z70ipy1PrIOEWWWrMG/KSg7apEp+ofvD0JhMUbXEjeO0tjNofLuEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=hQaqUt0E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.20
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010020.outbound.protection.outlook.com [52.103.12.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4F4606A8AF;
	Wed, 18 Nov 2026 08:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C4F4606A8AF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=hQaqUt0E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=asB/g8p6QDr3yCghZqN8kp5bHJ6g3MCiWrK1OsTm+2XAGiGN6pAlz0kfi2+FFo430tBQMDJPcni6f/a+u0SKjNukZ8TJET8dS8fhHbZ43kW8vtxcfxEDIUk/7W5uxK66n9KULOHZQuAy10mNSsB6yoEBkvo0czmgARJuIteC3m7h5xpnajeJnR2tzzUIEWk02YmTVa2Pg7N+fUY6tImjP9bK0E3Iu25Dt88zJpH/6GeKgP9rPajFCS4cTSyiVGG1P3tfvfL3t1c2j3FkEg4M+ldkXWSMyAnM4lzo2bKhG48/+oA7LcmKYHudKEc793bYGD2n1xpfV4+pGn5jUfETPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=XkxkvofG2CwwVPUpKe4K4+isPaNUJBz8gLauoUUuOJU=;
 b=iJ/CGL6Q4/alVLWGPIQUW/BTBdWymKcH0PVkOAgevllugk0qO4I1Fr9O/4R3hdvra4EVZqYYZSglCPnRNKpPMFse7c9Cf3SWisqtu0Vfxt8JcJgh2Fvhl54J6M5R/EpebmPKfFV7dcSxkVw/t3OGPiZnNr9KrhJpAiVOeAjtPKPBhDoXFqIqYuYIJF9vIc87qCcdTeEh6Lf6wtlXQrj7J74/CZ5WmN0yfxsO4VYRWibhiuvF2pEIOnn7Wbr2rZFEs3b6g1oEOBI8N8+B84zrHCPFHVo2wRlKiJsCjsk0Ed21yqogb6WwQHDjduUgPW4h0Ma3bI+A15PIEOOZxoI3ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkxkvofG2CwwVPUpKe4K4+isPaNUJBz8gLauoUUuOJU=;
 b=hQaqUt0ENSs9qpLVzJhgrBkJ6H5nly/m/1YdUhY4AlIM7xF9qSNTlWwobpNzDaWK1HRBckFUfEA4p+3ghE3dPavIEBW1r9VyLRwq+mrQmhHKclW/sB2xN9XqUClxqfS7NkdIsE4LAzsdZLt9CcKhbBg0fW/0NjHW6SHgwbjzlftDsQs0XTxw/0Rmw602mI+UmjECz7uafpdsGtk6vFn6SgDhbT9yae+mlORAs3CxQESmsOM0djdPDNK7Tt5AADWvWeu/iJaNbOraCr3U37rTEkQ+UQdtqDEz2ARMjL7AvhfRANdhX0k7gtNResE7BZzyjWkRmFFyZgd6l+0fQAIe5A==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB999481.namprd05.prod.outlook.com
 (2603:10b6:510:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 08:33:09 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 08:33:09 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/4] scsi: core: release legacy ioctl request before user
 copyback
Thread-Topic: [PATCH v4 2/4] scsi: core: release legacy ioctl request before
 user copyback
Thread-Index: AQHddzdw0H96QCXZk0y5Fc7t8YdQEg==
Date: Wed, 18 Nov 2026 08:33:09 +0000
Message-ID:
 <26e7d8d4f0648e572e6042c0ae14c1c36a83e850.1794990780.git.x-professor@outlook.com>
References: <cover.1794990780.git.x-professor@outlook.com>
In-Reply-To: <cover.1794990780.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB999481:EE_
x-ms-office365-filtering-correlation-id: bfad6cbb-3932-49d6-a6f3-08df454e9351
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|25010399006|4140399003|41001999006|38102599003|24121999003|22091999003|8060799015|8062599012|31061999003|19110799012|15080799012|3412199025|4302099013|440099028|102099032|10035399007|12091999003|1602099012|53005399003|40105399003|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?by9TMm9WM2dHRXMwY1VTRjcvWUFzNWNNSHMyYmo2Y3hZMzlLbllpMG9wcE8z?=
 =?utf-8?B?RmErS1lKNzkrSzQ0Y3pPZElrbjdaVlh1N0x2VmlhNDZTbTNqOGxmanBnUUdF?=
 =?utf-8?B?Ny9XR0xxeFFPZ0VmbnRmam9DQlJ3blJTZXJyVUQ2a0ZCUU5SS3NmdVBISmpu?=
 =?utf-8?B?QTE4VmxDZVhGb0hsY0oyQU5WV2FISFVSTkVlNDkvcjdvRzFiang2Zyt3TktI?=
 =?utf-8?B?S0RQREVXc3ZTYWVRL0ozcHowbC93Q1ZuTWZac0krdFdEczFsZ2tGQndBaWpi?=
 =?utf-8?B?R05hZVVTUG9zR2pOZnQ2VjZFYW5XeCt0eFREMVhybE4yc0hucnlGQms1L1Ez?=
 =?utf-8?B?Qzhqc016QW9oekttVmRQMStTcjQrVHBIZGpJZ0ZMaDE4WnlreUhNV3VjMG9D?=
 =?utf-8?B?RGcwY0lnQytyOGhWMjNvNExnMHN3Ti9SbTg0Q0Q4ZDRXMWlPa1NTK1lUOVgx?=
 =?utf-8?B?S2ZzYUpCaXp1Y2loNm9paC81aWk2WEkwMXN0eDN4SFJRVXYwMHJvWjV5RWJQ?=
 =?utf-8?B?NEZxNEYybS9YQ202VzV6OE80WFpCek4xajRIdEszVlgyZkZ1Q3dkcW1yeGJ3?=
 =?utf-8?B?ZVdzdkdtZ0c3VjIzQlEvaGNuWHBpTyt5dUNNdVRRbHZiU2xKQ3p6aTFmWkJ4?=
 =?utf-8?B?ajJQZkdkZDJBRlNHcnVSSXhTdkRub1VnZGdGZGN3S1cvWGVNWkRNYVRpY2RI?=
 =?utf-8?B?TW5IMGFudEd2b1pyMU1wMkpMeXZLaW4rWkVuUW1WSm5ROVJTTWpxdFNuQnBF?=
 =?utf-8?B?Q1V3VFpVa3Vkb0xua3pBWnN0aEQ3d1ZFbUNNYUk1NFVBNW9yYk9PZXJVZk9y?=
 =?utf-8?B?ZSs0TkpqdHpTL1ZZV054OXBtcVI3blBuS1Fud010eVhXOVFYNmM1cVRXTWtW?=
 =?utf-8?B?WENKVUgzaG55YkhIUVlMYmhnb2lKQVFBRTdIQm5pZ3ZlQlFKU3V0V2hyRm9L?=
 =?utf-8?B?a3hYOUhpUHcxK2ZFelVscDhQUzBSUjBVeWQvdWw4OWxlKzJ3emJYMkJoR3Ex?=
 =?utf-8?B?R0RoQnZWUk5ZN0hKQlpFU25JRDk2ODBmcXJ1ZlBHWDJjY09EZ21FYVNtR2dB?=
 =?utf-8?B?VmI3SExZMUE3SXFSbnlSaHd3OEJSTlNNN2piSXFTUUFCQzZKOERRRHp4L2E0?=
 =?utf-8?B?a3pZRmRGV2hROEJYbGo2THFmNzl6cFg0M0Rvb2pBL1IyQlFqOFNsSzhVTjEw?=
 =?utf-8?B?a0xxdXlWakpRblB0TUlTMWxhYUNRSmVzczlxYm1BcS83amhMNnNNTXpTQjRt?=
 =?utf-8?B?YWNUWEZsK1dsWmMvNGM0ZEJyaWt5NFl5aVZEczN4aE02MFJTWFZ6YnBDZEp2?=
 =?utf-8?B?Y0VhRXhnb0tyT2R5SkZEQTMreGNjR3IzZ2kyOWZ5RG91RVBpKzFqNmJTem15?=
 =?utf-8?B?dUEyY0FnSnJUeVlFa1VUQWlTdC9Oc0ZiUnRBRmhyNjViYk8xQkVEZnFrTVYw?=
 =?utf-8?B?dXVvRHBJWGNlYnVsUi9Vd3d1T25KRDM0KzgyVS9qZmlNeWc3VXRoSVZtejZN?=
 =?utf-8?B?eTVKTW52bmIxcnFsVXMvaGY4clJSMmV0RjZZYjlyTUVsa3JoSEd2ZnBKZk8v?=
 =?utf-8?Q?eaopYjR6M9r4TWVuHzxOvYgh4=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bkhodUUrTUNSNFJkNThxL2NSeHpPY01jYk9KUzdNZUovekVXd3oyK0NTaVF2?=
 =?utf-8?B?cFRTclBNeG9KTnhHbDZESWxLYVNBSTNmcDJyZm4xK1R4N25OcE1nRWRRNXFo?=
 =?utf-8?B?eVM4eXErcmlQV0JQcjBXS2lXNlZZUURvYmF6NG85N01SeDFCZWNsM3FheDRH?=
 =?utf-8?B?VEUwVW83S09vdXArR214VzJZcDhUTVRQQyt6TDR4VnJ2T0JmV3k2VllNWlFt?=
 =?utf-8?B?dG1sYlpnSlcvNGFJak9DTUVUNDVucWowZTFGNmFLVDhWNjdZbS9qSDlyaUVU?=
 =?utf-8?B?bjFIbEVCK0poZU1JSmFsVGxUUDQ5bWRLclovMWlSaDd2WU0wSFBPeHZuT0hJ?=
 =?utf-8?B?cERqWGw0alhObG5oYy85VkthcGhSWWtwaGU2SlRnTGhMODRtanF6UDhNQkIv?=
 =?utf-8?B?anBGY0I3TmRnUDd2RUtwSklBS0UwTXd5V0NPYU1IeFpST1Jwb2RGWHp3M1Nx?=
 =?utf-8?B?MFVueGorU0c0cmhraDJvdlo3YUZ5T3EyeEZITHV4WjZQekJ4TjRyRCtwVjdT?=
 =?utf-8?B?aEE5V0Y1NTN4cUkzMUNkVlJXOXZIUC9IT1g4Z29NTXRxL3JidmJFM2tUS0Nz?=
 =?utf-8?B?V092d1dTb1U5RmNneWdPYWZHd0xtZWtObFpMd2FsVUYxVW05bU9ZK082VjZW?=
 =?utf-8?B?RDNJK2QrMW9NaXgvYTdjdHlLZzBJZGwvS3NLS3dMOElzcVBPRWRsclcvZldu?=
 =?utf-8?B?TzFPZDZtL016bERJUWttWmFvYVlhcTN3dVRiTllkNXI3RlV6a1ZnVVR1WGlQ?=
 =?utf-8?B?UWRCMnZWT25jZTh3QUZrM3BaTW05MkI1TzN4SUI0N2FLMGo3eU9tTjZ4b203?=
 =?utf-8?B?UWhkZEdmcmU5eXpwdHlGYWVmeHllaGd2QjdLVmpWN3hXbVo5VUlHb3NIbXMw?=
 =?utf-8?B?K3d0TmJySk9BZ3VRSm1rMTRLZW9PQ1RLUkVpbjgrbXl3czllbzltWUs1bGU0?=
 =?utf-8?B?YVB1YWZMT3B1dU9xY2I4NElsZ3liS1p6L0ljRnJUMFJ3SU4wSlNpSzlEZ3lS?=
 =?utf-8?B?clRubDM5V1Z4M0tEUHdhY011TkRWNnJDQlFIZ2xkM3FzV0czdG9VTEYzN3k2?=
 =?utf-8?B?dG1pQzBlSWV5c2tiQ0lHUkFGSTVLU2w3M0d4N0x4aWliYzJ6ZEplM3dHZzZm?=
 =?utf-8?B?Skc0Mmt6dmpDaXdsZEl5V0JGNWs0cXYzd3c3U2NyZHAzWDd0MVdmTzlZR2Fp?=
 =?utf-8?B?NHBpN3RadDliZWswUThBTFl5UWQ1ME9PREpoVUhDTkZQbDRMYnFtL3pNSWxP?=
 =?utf-8?B?NitZbkxVbisxTkVNRVovbE9CT0N5YkswTUIwZWg5a2NCRjdwSk1Yb2lBNkIy?=
 =?utf-8?B?NDhiRlBNdWNRMUwrdUlIRTR0NFFGeFVkcXVFMFowcDloT0I1RG45RldXMVh4?=
 =?utf-8?B?dXpVM2pNTFdUa0RPMmFoZ251OGZkdGlvaFBBWnhHNGkyK2c3UFVHUitRc1ZV?=
 =?utf-8?B?YVFXNmF0NGNMVnVPSnJDRUlocUxoTEtMQWUvVlZSemo2QWI1Vjk2b1I4cGhM?=
 =?utf-8?B?bGVyd2tZWXFld01HN091Zm5TS0pINnFIcXIwVEJ6SFd2d0lsaHRjV1IydGM1?=
 =?utf-8?B?bi9rZm5wNDJ3ejBYL2UvQlZaeU50aTZzVlBjN1hMdmYyalQ2SE5yZnRVOGRn?=
 =?utf-8?B?V1hKYzgvUEpzbmc0RnlDNmRWRkUzVjVPMGZlUmZPU2s5NDJmQThETE0xY01D?=
 =?utf-8?B?dWdPUk5BVmtieXpXN01WU1hvVHNiT2h0bXlka3ZvSHJzdVRKR1RMVVBhd3VV?=
 =?utf-8?B?YTZSQnFQR0gvYWtTcGlVYmxFaVVJUERQWjYyNWhuZFg2NkcwTVllYk1WZVd2?=
 =?utf-8?B?aVYwVHJLbHFSa0w4cGJESGF6RzdIaCtESDN2VWFCdC9kQjR0WW45WkloWFpF?=
 =?utf-8?Q?kkFxZW9jQGnHj?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bfad6cbb-3932-49d6-a6f3-08df454e9351
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 08:33:09.0335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB999481

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KClNDU0lfSU9DVExf
U0VORF9DT01NQU5EIGNvcGllcyBzZW5zZSBvciBjb21tYW5kIGRhdGEgdG8gdXNlcnNwYWNlIHdo
aWxlCnRoZSBjb21wbGV0ZWQgcmVxdWVzdCBzdGlsbCBvY2N1cGllcyBpdHMgcXVldWUgdGFnLiBB
IGZhdWx0IHRoYXQgbmVlZHMKdGhlIHNhbWUgcXVldWUgY2FuIHRoZXJlZm9yZSB3YWl0IGZvciBh
IHJlc291cmNlIGhlbGQgYnkgdGhlIGlvY3RsLgoKU2F2ZSB0aGUgY29tbWFuZCBzdGF0dXMgYW5k
IHRoZSBjb21wYXRpYmlsaXR5LWxpbWl0ZWQgc2Vuc2UgZGF0YSwgdGhlbgpyZWxlYXNlIHRoZSBy
ZXF1ZXN0IGJlZm9yZSBjb3B5aW5nIHRvIHVzZXJzcGFjZS4gVGhlIGRhdGEgYnVmZmVyIGlzIGEK
c2VwYXJhdGUgYWxsb2NhdGlvbiBhbmQgcmVtYWlucyB2YWxpZCB1bnRpbCB0aGUgZXhpc3Rpbmcg
YnVmZmVyIGNsZWFudXAuCktlZXAgdGhlIHBvc2l0aXZlIFNDU0kgc3RhdHVzIGFuZCAtRUZBVUxU
IHJldHVybiBjb252ZW50aW9ucyB1bmNoYW5nZWQuCgpUaGlzIGNvbXBsZW1lbnRzIHRoZSBTR19J
TyBmaXggYnkgY292ZXJpbmcgdGhlIGxlZ2FjeQpTQ1NJX0lPQ1RMX1NFTkRfQ09NTUFORCBwYXRo
LgoKRml4ZXM6IGQyODUyMDNjZjY0NyAoInNjc2k6IGFkZCBzdXBwb3J0IGZvciBhIGJsay1tcSBi
YXNlZCBJL08gcGF0aC4iKQpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMDIy
LnNjc2ktY29weWJhY2stcmV2aWV3LjMxYjhkNmE3MGY0Y0BvdXRsb29rLmNvbQpDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHgtcHJvZmVzc29y
QG91dGxvb2suY29tPgotLS0KIGRyaXZlcnMvc2NzaS9zY3NpX2lvY3RsLmMgfCAxOCArKysrKysr
KysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2lvY3RsLmMgYi9kcml2ZXJzL3Nj
c2kvc2NzaV9pb2N0bC5jCmluZGV4IGQzNzAxNzBmOTI3MC4uZjA2NGQ5MmI4NzUxIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5jCisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2lv
Y3RsLmMKQEAgLTU1Miw2ICs1NTIsOCBAQCBzdGF0aWMgaW50IHNnX3Njc2lfaW9jdGwoc3RydWN0
IHJlcXVlc3RfcXVldWUgKnEsIGJvb2wgb3Blbl9mb3Jfd3JpdGUsCiAJCXN0cnVjdCBzY3NpX2lv
Y3RsX2NvbW1hbmQgX191c2VyICpzaWMpCiB7CiAJc3RydWN0IHJlcXVlc3QgKnJxOworCXU4IHNl
bnNlX2J1ZmZlclsxNl07CisJdW5zaWduZWQgaW50IHNlbnNlX2xlbiA9IDA7CiAJaW50IGVycjsK
IAl1bnNpZ25lZCBpbnQgaW5fbGVuLCBvdXRfbGVuLCBieXRlcywgb3Bjb2RlLCBjbWRsZW47CiAJ
c3RydWN0IHNjc2lfY21uZCAqc2NtZDsKQEAgLTY0MCwxNyArNjQyLDIxIEBAIHN0YXRpYyBpbnQg
c2dfc2NzaV9pb2N0bChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgYm9vbCBvcGVuX2Zvcl93cml0
ZSwKIAlibGtfZXhlY3V0ZV9ycShycSwgZmFsc2UpOwogCiAJZXJyID0gc2NtZC0+cmVzdWx0ICYg
MHhmZjsJLyogb25seSA4IGJpdCBTQ1NJIHN0YXR1cyAqLworCWlmIChlcnIgJiYgc2NtZC0+c2Vu
c2VfbGVuICYmIHNjbWQtPnNlbnNlX2J1ZmZlcikgeworCQkvKiBsaW1pdCBzZW5zZSBsZW4gZm9y
IGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgKi8KKwkJc2Vuc2VfbGVuID0gbWluKHNjbWQtPnNlbnNl
X2xlbiwgc2l6ZW9mKHNlbnNlX2J1ZmZlcikpOworCQltZW1jcHkoc2Vuc2VfYnVmZmVyLCBzY21k
LT5zZW5zZV9idWZmZXIsIHNlbnNlX2xlbik7CisJfQorCWJsa19tcV9mcmVlX3JlcXVlc3QocnEp
OworCiAJaWYgKGVycikgewotCQlpZiAoc2NtZC0+c2Vuc2VfbGVuICYmIHNjbWQtPnNlbnNlX2J1
ZmZlcikgewotCQkJLyogbGltaXQgc2Vuc2UgbGVuIGZvciBiYWNrd2FyZCBjb21wYXRpYmlsaXR5
ICovCi0JCQlpZiAoY29weV90b191c2VyKHNpYy0+ZGF0YSwgc2NtZC0+c2Vuc2VfYnVmZmVyLAot
CQkJCQkgbWluKHNjbWQtPnNlbnNlX2xlbiwgMTZVKSkpCi0JCQkJZXJyID0gLUVGQVVMVDsKLQkJ
fQorCQlpZiAoc2Vuc2VfbGVuICYmIGNvcHlfdG9fdXNlcihzaWMtPmRhdGEsIHNlbnNlX2J1ZmZl
ciwgc2Vuc2VfbGVuKSkKKwkJCWVyciA9IC1FRkFVTFQ7CiAJfSBlbHNlIHsKIAkJaWYgKGNvcHlf
dG9fdXNlcihzaWMtPmRhdGEsIGJ1ZmZlciwgb3V0X2xlbikpCiAJCQllcnIgPSAtRUZBVUxUOwog
CX0KKwlnb3RvIGVycm9yX2ZyZWVfYnVmZmVyOwogCiBlcnJvcjoKIAlibGtfbXFfZnJlZV9yZXF1
ZXN0KHJxKTsKLS0gCjIuNDMuMAoK
