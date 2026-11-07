Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794045061;
	b=BL9m9fLDLUZTw7C+oH3TXjoiv12ygmYlgtKIf/l0I1Rxo/NHVPCevb1JP8SuXCILafQm
	 XsgD68mVv+CLm4tB4R4QbjMWUWjLpXtGigYKISgTjxOaO9kekH0fEstx2rtMnyi46a4DA
	 CDPubGJ1DjoKeUMu9Yo9wd+NJjZpHXp3O7zCMx/NaK6mZRMbq6/lAJNyT1j+TUSkT5Ylt
	 Hs2o8QeKc1lHoDr+BcUeFB0iyt39QSKVhRhT3kd90thHZj23Q1AZ2XBuYa3xl0Zr721kW
	 ZPutUjZIEVp/nUg05/tDTTFK2eBH56/en8KWD0XsnG95V2AEO9w9Rmjdg8TKjV8cnlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045061;
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
	bh=5PSzULzlH9YdYq5Y+2btzYtaHlnNQtxlnbRgbJMQaUY=;
	b=eIlFpQd4Mydiz+a8da1FFGTNUYpQOU9VD+87K5a+prikEW0Cy4HKGPdz8M4QJJ1D2q19
	 s/eZYtYSSmD0IcPkbsxKh61+idl3KwcL64GiPxCESmpcTMmjQU/MhRqEkAzubtEplvF34
	 9yn2f6lNORpVA/0yPVO+u5t1Sht/vmrmE6syetzOXh4DUsRFTOJQgmxUgERrnlrSbjs8K
	 LN6m9lU76EC8gIuDVr2wtLgySSbz5/yoen87i+9L5ZlsB/frVmZ/9hG3jcHnKiNz3KqkZ
	 kZxMXZpd18qp9lBpvUJ3jH+dC3x3ZByk2zqYurSPH7M1G/jH2r+vS4WThqpVbX9mbNg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=o6+VrlI6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.32
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazolkn19011032.outbound.protection.outlook.com [52.103.13.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57144606A326;
	Sat,  7 Nov 2026 09:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57144606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=o6+VrlI6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJVGtUBbNAU2Ox40UuqTJMgcJDU++1kT8fwJ/Bx8g9MjhWSQxahvDF48ppINnxspa2YdBvPKZDcj8b4raJgXt/9LSuk/lQx3AxtH288k1taiptYi8iEu2Scy6fqcIqjSxmFMQ2BJwFxL2b0qWdXV/vu/DpyEdXxhFbVLGPH9dCuoznMNZGR0BpXC7HHcSkQyO0Iv+y72t5yMnqSMwTarMo+E3vSbxBh1BMlheWzaaJZIVLieSf4UgRD7i9gg0Rpxj2eocVKctMr6vSrWcs4xLzKNEOYwr5LweXraUfMrZH4DNQJ+IPRPW3vfyVImTxU+EYtvKT2UJO2YBnP7g4Sygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=5PSzULzlH9YdYq5Y+2btzYtaHlnNQtxlnbRgbJMQaUY=;
 b=d6lQdvt0Znxw5cdB7UuDH+nmwMYD0l+qI//BuN1YqRHseyFx1EwLArSusCwpb1BgGNQlX1SVeOpmN4lskGDW5PLYSH9uQweqpdq1vLPmP9UM/XdJjk8KNuD2DtULT63R+usoXyYawgl6Ppdq1jOPCGJ0Sk8rigxjkcUr0LXX98aanscaqF2GaW6y00qjAnXj8knXIu6YrMzCVJ+IjisLdU7/mORaEiXouVB1s+2NSOCqP03uPrSigKvDKGkrt1AWZjZFP5/BdR14kwQ0HK5roL7fUXRmZTCo+BBaPzbNbAq0P8PoWKnHl46MAYPUKYyj1B4CJrukgozQNxMiYzcvKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PSzULzlH9YdYq5Y+2btzYtaHlnNQtxlnbRgbJMQaUY=;
 b=o6+VrlI6wLpnjM4ChjAtbdwkBkth+MBpd9LBkVNjtjE6OoUWK+ObjP9sPgk07fOBusl3bSQ43RNFAakP8vqLWi7xo6QEik++iMZ8hcq/EVbO1LACvKrAjIhuRGNuX76Lzi/m3xvhIFel08Sl4VeZZLyNwUt6z7Qo8qei4AT+VXMyEMxq+pF0Mm+vYbYZJbRFQV1xxnBeThikSexmbT6SGPRdYBeMsStcxog49Jt4CiTC23SY6Y8ybU9qA5fELTfO/SEEdX/tJx1eN0gOl+UhaOSJjyK+BVpCWPmlxMO8qxo+Lq0gVngO55xHVpOTyb5nqC8THqK3QN/yhqkNL+5uJw==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SA6PR05MB10700.namprd05.prod.outlook.com
 (2603:10b6:806:409::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 09:50:29 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0592.010; Sat, 7 Nov 2026
 09:50:29 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
CC: Yingjie Wang <x-professor@outlook.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, Yang
 Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>, Pavel
 Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 4/6] scsi: bsg: release synchronous request before user
 copyback
Thread-Topic: [RFC PATCH v3 4/6] scsi: bsg: release synchronous request before
 user copyback
Thread-Index: AQHdbp1rn4zMQM40XU6nmaXzJTQVbA==
Date: Sat, 7 Nov 2026 09:50:27 +0000
Message-ID:
 <03e602e41e0d444730042c71aa6129e72a59add6.1794045010.git.x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com>
In-Reply-To: <cover.1794045010.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA6PR05MB10700:EE_
x-ms-office365-filtering-correlation-id: c879e7c6-5acc-4f74-1dcc-08df3cb48e6d
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|19110799012|24021099003|41001999006|31061999003|22091999003|24121999003|15080799012|16051099003|8062599012|38102599003|4140399003|25010399006|10035399007|12091999003|1602099012|40105399003|53005399003|102099032|3412199025|440099028|4302099013|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?eit1dGhYU1RTQzJXU1VNQzQ4WWtkS0FCZGZFdzZHMnFhbWVVMVY5bStHQnZD?=
 =?utf-8?B?emxETm13Ym1vcmRpNldFa09ZUjhjazc3S016Smphd09wUlcvOC9MaEEvSTgz?=
 =?utf-8?B?ODVlYUY4dUphaGlwdWFoWUJhRG9aZkdUWHp5UEM0UTZZOGUxeUVWcWIwTWhu?=
 =?utf-8?B?SGpnWXV2WkVDTWNKZnFHV0Z4WExFNU9KdUxDQytnTjEvdmJTVnF0YmJvTERP?=
 =?utf-8?B?STBkTWNXZkxmQ1MxUXBCalNFN20wRHgzdlh3V2xmZ2pmQ3g3dHV2YjF0ZWhy?=
 =?utf-8?B?L2xYNGx6LzB5eTBTMS8rTWk2d2NoeWFwSk1tZzFVa1RIdmN5VldSdlk3SUNC?=
 =?utf-8?B?RElUcWxJeEpZRzZOL0w5a05uNEJwaUc1YlZWWjdmS3RRVFZXTDN3T3h2YnNX?=
 =?utf-8?B?QTdZdnhkRGVHcU9QUW1ZVEN1OEMzSWdjQkIyV2FQQ2dNc010ZTJkaFBxc093?=
 =?utf-8?B?MmxGTlg1ckdoRWNJMWZveERpa21rRmFRZFF2Uk9TbGxzcjBxUnhPRno5b3la?=
 =?utf-8?B?SUxhRVJyeDJ3Zis1eDBQbDI5Rnd6WC80RVdDb3k3a2hRaWNxeUFOMU1lYXVC?=
 =?utf-8?B?OTlGanM1aG5YZzBlNUd5SE9XREFoOWtwNnZrUkptYTBpL01jSGFWSSt4Qkt5?=
 =?utf-8?B?SHg4dGo0YURIRUFra2V4dWM1bGgrMkt2UFRaQTVYVkJXRER0VkdoeXV6MEZk?=
 =?utf-8?B?Q1NrWllhMStKdE9uaGQwb2lEK01IMFJHM1I1SnA4Z1kxZW1NTXAwdkhHRzFZ?=
 =?utf-8?B?Y2FacGsxdjVDTlRPbm1jZ3NVSDVXMWNJRk1qV3Y0bEdMR3FqYXlFZlBhTi9p?=
 =?utf-8?B?ckNyNnVtUWIzOXBQbk5BU1NUQzZKUUpITXNESHBPdW00RG41TUZXdUVUbW40?=
 =?utf-8?B?LzZVU1Mzdk15ZkpVdXUvRVhWb1JDZkpGeUhIdFVDQzhWQTIyNDhreGdYNGhu?=
 =?utf-8?B?bkJ4MzdkOUVVYVk0cWNIc0ZDRFVKaVlNRSt6b1pOTHFTYVZ6RDRjaiszWElK?=
 =?utf-8?B?UTRWMW5PVnNYcE92cXVsQ2h6bHFRdXQvMGl3cWtLMnFnOStWcHpGRWs5ekQx?=
 =?utf-8?B?bzJKb0xpa0hjczZGbk1nTDZnU2JhaDhKZXBDV3dYdEJGT0o5WmQwNEcweWJN?=
 =?utf-8?B?cmpjWGNBUHFTajkweUF1Q3pEOWt1QUN2aGxidlJXK1BOeUdIUFpRdmFKWk8v?=
 =?utf-8?B?VHZXRVBhdjJyZEdYVVlBbzhOSWlCUVNlMUhqUWRoY0JkR1A2cGo4bEhPbllV?=
 =?utf-8?B?Z21zam45SXVpUG1oZHNwN2lFMUgzdmh1ZXorQ1M5ZHBXVU5VMHl5Y1ZCSmhX?=
 =?utf-8?B?MVl0aTJPaFI3cGxQZW1rWTRlNkVYSHJ2Wm5SYzQxTmV5ZlVydktMb2drUk5n?=
 =?utf-8?B?TS9UT2wwWWZ5UGxodm9RSVZrSUFtQ3E5WkJ3V2NvT2gzTTlVVVI0ZkNJVmtN?=
 =?utf-8?B?bXM3RXVNZ2NZd2RndWR3UmR1Ri92ZzNVcmtLWldueXNzRWRhLzdiUTRXVzVp?=
 =?utf-8?B?aExUeDJqdFlFWHRXTW13Ymdhbjg1a0Z0M3Vrb2RHS1NjU1FVYnplcHlIYk5Q?=
 =?utf-8?B?TzNPMUMva0dWOFVUdmx5RVJ4K2JLaEZ5QjVVaXFpeWRjTlZucjRDVURHcVJl?=
 =?utf-8?Q?rY/cCAh2DF5+JWRiNf5PXadVb73Pib4muT7Vzowpnrns=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OHE4ckJmdHpvOTZtaHF6eTlJczJabzE3d1AzTDJabUdMNkVTeVc1Rk9CTjQr?=
 =?utf-8?B?a2VmdlBwREh6b0RwdWtoSE5TUEc3T0piamp3RFF6RnVVcFgxMjFja3ppbGVW?=
 =?utf-8?B?U0p5djVxZW5HS2xmbFBBeFE3c21JY21iYWlsUjh0MTEyZ0hFMVEwNGdKSUxi?=
 =?utf-8?B?TVk1c3R0a2w2YTZuK01mc0tUY1kzOVZBeDdBaUY0RlQ1K3VaSmJhWmdiYVFX?=
 =?utf-8?B?K2pKOFAydHNqdjNOb2ZBLzJYeWczUitNUXlJZ3ZMSTZ6KzRsMlpNY0M0NHU1?=
 =?utf-8?B?Z3BzdnJZOGJwZ2hVVTZTdGgxOWxEdkxwczljMWI1dk5rejBUMkNWWDJzemlG?=
 =?utf-8?B?NUR6VytxMDhJcUVZckthZjBKTDhXTUFvb1BRanNzdnIwQkJNeEpVdlZILzAx?=
 =?utf-8?B?ZGZKQTFtWjJ4YVpVZTZ4NTV2clljazZOckM4b05DSDAzTUZrUU01dmtUZlFJ?=
 =?utf-8?B?YWU2SU5meWZadU9veDh1elNCeXVzdmdadVpqdXpwaU9HT1JoSmJSc1YzMDN2?=
 =?utf-8?B?dUNEb2VFeGRFNEZxQkdma3NzcVkzZnZuTUVQTEFNcXpSZE9FODFMT2NoMXZz?=
 =?utf-8?B?QTFXRkNmOWduNXdkZHd5VlBRQXNzalo3OEh6d1Ewa2U0TjJCOXozRTEzc1Yz?=
 =?utf-8?B?Nm1oZldjUHFsWWF2Q3JEUmdsWVFKS1VTVlNzL3pvSHpzcUtHWks5SnhyYTJI?=
 =?utf-8?B?bnUzd0hsVTdBcVl4QUtsak0vaU0zZ0FvNXBQb3hMSEhFaGw2SXh5ZnBCOWtF?=
 =?utf-8?B?Mmc1TklBejF4Zm55WE1HaTI4Rnp2RzdOTUwyWDZSV0tsN3dRelRicjFHOUVQ?=
 =?utf-8?B?Z29qZWc0YWFhVG4xNmtLcWNrdnJncWp5Vk16ZmxNbUtkSTFqcEJuSjQrd2NO?=
 =?utf-8?B?WWk2b1VNRG9TSEY4NjNLdnRXSkRldkVBZkRpRExYbVlqY2xlUFUzNzJITjBZ?=
 =?utf-8?B?SXExN0hPNFFIZW9oYmRRT3NzeGFVNzlCOXEyT2dmTEw2NHpWVFN6dEFidU5I?=
 =?utf-8?B?QmxBQnJQRDQwOTZreWNNVTZQRmxmeHdBNS9wY0xGZFFYbGhVV1RUZTgvUFVV?=
 =?utf-8?B?YnBWQnhBekhORjRIR1dVSW1zUmxBNm5wRjA0SjNPYmVZMU1TWUQ4c3Z5T1dH?=
 =?utf-8?B?bEdwU3VsMS90S1lpSW9TblpvZXZQWGVNU0JUbGI1L28vUys3S1ZNOVEwZEpL?=
 =?utf-8?B?N3EwWWcybVFWeEFOdzhpL0RGQ1p0Y0tUQ05wejJXVWx3YUU0TDl2OTdUZUgw?=
 =?utf-8?B?UmJueDhBVEQzb3hUSTBTVTRFcGlVZWUrSjlublArVkRhWGVxMXBtZlhMakxs?=
 =?utf-8?B?aTArcTl5bjZzNXBFNEU5NTFXQ3YrOXRvWWxDc3pYTnptNGZpU0hOOXdBc05R?=
 =?utf-8?B?Zjc1MU53eERBY09DNkYxTk9MOWJKc2JQVVRmdzE2RURvZmNLbFQvWWlyaW90?=
 =?utf-8?B?QVZiR1hyUWFleGFmcDZITURISjIyS0cwYW9KOHdsd1ZlT0FzNXVVcytQU2Na?=
 =?utf-8?B?ZWwvQnEwZ2Qvckg2V3pMTW0wN0g2WDF6aWczSnJHUDVaMk1xVlYwT1lwTVRz?=
 =?utf-8?B?RkpvZXlzbmJ3cEJsb2lhclB5Tk9QYitmYU1PVzdxWndMOWRrd25VeWYrdHhh?=
 =?utf-8?B?eW1NaEdyaEhMOG9ESUJIa1I1eXVibEtOR1B0eW5pRHFXNHo4L1U3ZERVTjRH?=
 =?utf-8?B?cCthWDR3WGxOZDc1SEZ6R3pQUmthamlsbnpuZ3RmQ2JLb003RitHUEpNSHNv?=
 =?utf-8?B?MTFPVW9qQmtSYko0bVNpOTN5MGI0RFlGSDJnNVlENFhwNDk1ZHNQdXRXSGF3?=
 =?utf-8?B?Q2hQOUIwek91TDkyK0dzUHY0aGU4cmE1YWlzbVFldUVlSzZ5MnRWb1pCSzBh?=
 =?utf-8?Q?vd63+CN3xjiT5?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c879e7c6-5acc-4f74-1dcc-08df3cb48e6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2026 09:50:27.6934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR05MB10700

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KClRoZSBzeW5jaHJv
bm91cyBTQ1NJIEJTRyBpb2N0bCBjb3BpZXMgc2Vuc2UgZGF0YSBhbmQgdW5tYXBzIGl0cyB1c2Vy
CmRhdGEgYnVmZmVyIHdoaWxlIHJldGFpbmluZyB0aGUgY29tcGxldGVkIHJlcXVlc3QuIENvcHli
YWNrIGNhbiBmYXVsdAphbmQgbmVlZCBJL08gZnJvbSB0aGUgc2FtZSBxdWV1ZSwgd2hpY2ggY2Fu
bm90IHByb2dyZXNzIHdoZW4gY29tcGxldGVkCnJlcXVlc3RzIHJldGFpbiB0aGUgYXZhaWxhYmxl
IHRhZ3MuCgpGaWxsIHRoZSBrZXJuZWwtcmVzaWRlbnQgb3V0cHV0IGZpZWxkcyBhbmQgc2F2ZSB0
aGUgYm91bmRlZCBzZW5zZSBkYXRhCmJlZm9yZSByZWxlYXNpbmcgdGhlIHJlcXVlc3QuIFBlcmZv
cm0gYm90aCB1c2VyIGNvcGllcyBhZnRlcndhcmQsIHVzaW5nCnRoZSBvcmlnaW5hbCBCSU8gY2hh
aW4gc2F2ZWQgYXQgbWFwcGluZyB0aW1lLiBQcmVzZXJ2ZSB0aGUgY29weWJhY2sKZXJyb3IgcHJl
Y2VkZW5jZSBlc3RhYmxpc2hlZCBieSB0aGUgc2VwYXJhdGUgZXJyb3ItcHJvcGFnYXRpb24gZml4
LgoKVGhlIFNHX0lPIHY0IGltcGxlbWVudGF0aW9uIHByZWRhdGVzIHNjc2ktbXEuIFRoZSBmaXhl
ZCBzY3NpLW1xIHJlcXVlc3QKcG9vbCBpbnRyb2R1Y2VkIHRoaXMgZGVwZW5kZW5jeTsgbW92aW5n
IHRoZSBjYWxsYmFjayBpbnRvIHNjc2lfYnNnLmMKZGlkIG5vdCBjaGFuZ2UgaXRzIG93bmVyc2hp
cCBvcmRlcmluZy4KCkZpeGVzOiBkMjg1MjAzY2Y2NDcgKCJzY3NpOiBhZGQgc3VwcG9ydCBmb3Ig
YSBibGstbXEgYmFzZWQgSS9PIHBhdGguIikKTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
ci8yMDI2MTAyMi5zY3NpLWNvcHliYWNrLXJldmlldy4zMWI4ZDZhNzBmNGNAb3V0bG9vay5jb20K
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogWWluZ2ppZSBXYW5nIDx4
LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvc2NzaV9ic2cuYyB8IDIy
ICsrKysrKysrKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCsp
LCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2JzZy5jIGIv
ZHJpdmVycy9zY3NpL3Njc2lfYnNnLmMKaW5kZXggM2NmMWNhYWQwMmY3Li41ZmZiZDE4NDM4NjEg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX2JzZy5jCisrKyBiL2RyaXZlcnMvc2NzaS9z
Y3NpX2JzZy5jCkBAIC0yMDcsNiArMjA3LDggQEAgc3RhdGljIGludCBzY3NpX2JzZ19zZ19pb19m
bihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHNnX2lvX3Y0ICpoZHIsCiAJc3RydWN0
IHNjc2lfY21uZCAqc2NtZDsKIAlzdHJ1Y3QgcmVxdWVzdCAqcnE7CiAJc3RydWN0IGJpbyAqYmlv
OworCXU4IHNlbnNlX2J1ZmZlcltTQ1NJX1NFTlNFX0JVRkZFUlNJWkVdOworCXVuc2lnbmVkIGlu
dCBzZW5zZV9sZW4gPSAwOwogCWludCByZXQsIHVubWFwX3JldDsKIAogCWlmIChoZHItPnByb3Rv
Y29sICE9IEJTR19QUk9UT0NPTF9TQ1NJICB8fApAQCAtMjY2LDI0ICsyNjgsMjggQEAgc3RhdGlj
IGludCBzY3NpX2JzZ19zZ19pb19mbihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHNn
X2lvX3Y0ICpoZHIsCiAJaGRyLT5yZXNwb25zZV9sZW4gPSAwOwogCiAJaWYgKHNjbWQtPnNlbnNl
X2xlbiAmJiBoZHItPnJlc3BvbnNlKSB7Ci0JCWludCBsZW4gPSBtaW5fdCh1bnNpZ25lZCBpbnQs
IGhkci0+bWF4X3Jlc3BvbnNlX2xlbiwKLQkJCQlzY21kLT5zZW5zZV9sZW4pOwotCi0JCWlmIChj
b3B5X3RvX3VzZXIodXB0cjY0KGhkci0+cmVzcG9uc2UpLCBzY21kLT5zZW5zZV9idWZmZXIsCi0J
CQkJIGxlbikpCi0JCQlyZXQgPSAtRUZBVUxUOwotCQllbHNlCi0JCQloZHItPnJlc3BvbnNlX2xl
biA9IGxlbjsKKwkJc2Vuc2VfbGVuID0gbWluMyhoZHItPm1heF9yZXNwb25zZV9sZW4sIHNjbWQt
PnNlbnNlX2xlbiwKKwkJCQkgc2l6ZW9mKHNlbnNlX2J1ZmZlcikpOworCQltZW1jcHkoc2Vuc2Vf
YnVmZmVyLCBzY21kLT5zZW5zZV9idWZmZXIsIHNlbnNlX2xlbik7CiAJfQogCiAJaWYgKHJxX2Rh
dGFfZGlyKHJxKSA9PSBSRUFEKQogCQloZHItPmRpbl9yZXNpZCA9IHNjbWQtPnJlc2lkX2xlbjsK
IAllbHNlCiAJCWhkci0+ZG91dF9yZXNpZCA9IHNjbWQtPnJlc2lkX2xlbjsKKwlibGtfbXFfZnJl
ZV9yZXF1ZXN0KHJxKTsKKworCWlmIChzZW5zZV9sZW4pIHsKKwkJaWYgKGNvcHlfdG9fdXNlcih1
cHRyNjQoaGRyLT5yZXNwb25zZSksIHNlbnNlX2J1ZmZlciwgc2Vuc2VfbGVuKSkKKwkJCXJldCA9
IC1FRkFVTFQ7CisJCWVsc2UKKwkJCWhkci0+cmVzcG9uc2VfbGVuID0gc2Vuc2VfbGVuOworCX0K
IAogCXVubWFwX3JldCA9IGJsa19ycV91bm1hcF91c2VyKGJpbyk7CiAJaWYgKCFyZXQpCiAJCXJl
dCA9IHVubWFwX3JldDsKKwlyZXR1cm4gcmV0OwogCiBvdXRfcHV0X3JlcXVlc3Q6CiAJYmxrX21x
X2ZyZWVfcmVxdWVzdChycSk7Ci0tIAoyLjQzLjAKCg==
