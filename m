Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794045062;
	b=wgh+3/ZwKBm5OE+nDYqIWmdsJLzeV3gRZhkKwJ8A9IfI6Fvfa8I7tAU5MPIBtxfIpcZk
	 6qTEHpfTCsYItOYKqxnS5OIICYM1ljBikkyCTrWboiWGwdMCbN/ucdn6ii7i9ODjUV3jU
	 tT+hRB0UmXif2IIt7w1eDVjwylvEXAtDCPaqIJIiv9geiqIQ1j2Cw5LYVN0w8hukf23r2
	 SMg96vY33AyhbbJh07IY8CwD+4AF8pl+kTvfZrA1LS3ZiKbdzjNQRGasQ6DJ+AEICTFjE
	 TnIPg/jr/ujL87VnlKcL8Qxakk2XCg89euhYlDYAcLo99DnBGZYnh+EjCp6Va2mbSEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045062;
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
	bh=ndSg9fR/ScWidKzYqVP2QAUMSNTvgLXeQsbvOyTCWSE=;
	b=lABHBHo5Jj4/D8bjHsXAsiHavMZgQdT7amgy9EpE7gYSDCZiplGNhi291HH+SyfnUSfq
	 LIZn0s+E+w1MX4l29Yv/YLpHBURM9pi1MlKDJAKEi/BzLPBHIvNqFGsTS4PAXHMI1IuYE
	 SsWe29FdVCLk9hKIxo7Z7bOi+igHsxA9eSgpItOWv0WrmBCtZCmN2eB+w+0UCDX9EQ/+u
	 Ee/FCfWgnE3flPjAw5ZovKhpitfwIi5ngpcLgPh1hshifPBl9r/b2jUk51fXmYvoNN1RQ
	 hpMIHS5h/+yMPQmm/+STns6Y/EMlyqU7wSdxm2LZ7HzbDtPJDu79m+7/yx1fEL5ul9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Qlajm8Oc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.68
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012068.outbound.protection.outlook.com [52.103.14.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663D1606A337;
	Sat,  7 Nov 2026 09:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 663D1606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Qlajm8Oc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXv66Si7viPTneiKVyntPJM6eAmmC6xxUT3P7Gd8zh80pSX6o+nWQADwwKKh2w/mxwTb8U93DVGIuf/wDcEfk3UHky5hQljXlOFQGzds+FPr1nptIkSWz86xVCdEY/Uqy+hLDyCzXqtG9/5zbOnRsXTQAvCFOzyzkq0HCM7GY2xq+g4LCJcFUwCJfWy2nbqz8QIUdTJSgVmi3Gb1i6UPng8JVJfcgbllXYM8ELC6+oZu+tTJZqVYy4JrnvU8ySQtqqtIsdqifpJDW59gNKUKondNd7lOMozg54x9Pa61UVwA0DRoWUTLDLAGoytl14WN7q+p7auyRCj7zGMyRRCSHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ndSg9fR/ScWidKzYqVP2QAUMSNTvgLXeQsbvOyTCWSE=;
 b=pdQx6lp6QDZ6ZqKPuDKdvyMGOawWWnQBF8DjdqIXo2MoJSvzUOhm8hm/nx5h62zvAnMJAIUJiWdDuKz59hNSsKl5eD9KDvulfL56wWwE5Oh1XYBz0qIHFaOj6xCU6Zns0QyhAPJpufSkBP61Rv43xMfOrYr5p8vIeUCkHDGWXIQUofyZhKRC0iiGe2cVyCNDFfoqPsMFjtjCO6Rm+PR9fEojDtCPQbUv3vUyey/eegNGkfZdw+W8Z+F5t4BYSP/p7LVhKEGJmOgj4WRSfwEu45FgTICIvy5lYqxbwDTZSwE9d69rIGa5MT8i3P7NFL30lMa/RjtG7/ARxPWJJY6HHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndSg9fR/ScWidKzYqVP2QAUMSNTvgLXeQsbvOyTCWSE=;
 b=Qlajm8OcrI1RAfwXekf7dXYbY//gT7t5ZsMVa0tOS6olvVQimscPv4YZpwLEXVx0zxdwRctpjok7rEFxTJgKr+YVGX63ImxTS1HNdYwJh7n1DVqyPHK81z9shhgX56vnDs8/ZoPygoC78YWfcGmrF2f301ksLIkN+7MPn9ZbcTx/hIeSSEribVFL4eXZfyoriPprampgP8VJFHMxDL+FKCozqwbJO0V1t6jLI2WMNeTS5vCslTPtRz6F6ZPvYfDkEvb0FLQgwAi12U/5D9bSdX6zOXjDt4xlfwA0marDD8/vSBx2HUT0RCrqVinf2xzrAjMvQYjg+HYkHiK/q7o97Q==
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
Subject: [RFC PATCH v3 5/6] io_uring/cmd: allow reusing SQE storage for
 completion data
Thread-Topic: [RFC PATCH v3 5/6] io_uring/cmd: allow reusing SQE storage for
 completion data
Thread-Index: AQHdbp1r/IUM1KiQW0u7BqizLWiRsQ==
Date: Sat, 7 Nov 2026 09:50:28 +0000
Message-ID:
 <a4ec8431c2f36172348449b872faf26d7d6d4d7a.1794045010.git.x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com>
In-Reply-To: <cover.1794045010.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA6PR05MB10700:EE_
x-ms-office365-filtering-correlation-id: aa3761ab-2c13-4aca-fe2c-08df3cb48ee0
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|19110799012|24021099003|41001999006|31061999003|22091999003|24121999003|15080799012|16051099003|8062599012|12121999013|38102599003|4140399003|25010399006|40105399003|53005399003|102099032|3412199025|440099028|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?cEFOREZJODlCRjZSeStMRllYYm4vMTgveWxIekxLczVWRENNVE5lVWZGMzNZ?=
 =?utf-8?B?bnBDSFdCMzd1NEEvTHhselZEbkdGeThxRnd6Ukpabm4yQXRHdVRGMHFBR1RM?=
 =?utf-8?B?akpzTXh4TFVpaFIrRGdteks3b3VuYWdMcFhtcmlWR2o0VUUvYk1OM0ttQ28v?=
 =?utf-8?B?ZFcxZmN0VDVWd0h0VEhDZlE0MXQ0T3BQVHRIdVN4NEMvaUp5NEs1ZEpzanJv?=
 =?utf-8?B?em01THBjUEJXZ0ZDM29JK29adExXYUJ4ZGk4QjdOMjVwK3RJY09Jd0dkUFh1?=
 =?utf-8?B?dTBPZldTZ2xGZHAyRVlVcWpYUkMzRE9KdVJkRlFxOVROcDJJMzZMSW05S2Rv?=
 =?utf-8?B?d0dSUExxSTZhTUQvNllYZFVLQ1lzMldrNTJINGhtZHFmRnNYL2xVSTlNVDE2?=
 =?utf-8?B?SW5uOUx4QkM0ZXNHM0plQ1hRb25uNGRuY3o4T1dlOWNLa2IxZVZQN3ZER2t1?=
 =?utf-8?B?eDJqMThJdWRSS0tNdVVxRDBzSHRrRzFwQ2NkOWhTdGtKZi9ZWWpRYUhmTmtL?=
 =?utf-8?B?MHlEUkpYZlIxT29TYzRxV283T0YxWGp1ZE0zZ2pnV1lCbFhaWFRaK29seElX?=
 =?utf-8?B?RHdoR1YvYnRrYjRiUnRhak1oUE9SL1AvcjB3aUdmdkg0N0FjdmdhVU1aY2V1?=
 =?utf-8?B?R2pab2tRdDdQTU91b0VWWC9Zdit6bWtIMklIaUdoMTdSVDFFMWJmak40aWF5?=
 =?utf-8?B?dWw2V1FBVTEySy9MMUdBOUtubnhwQ2Fia3JzcU82cXNRL2FmWlB1RXRjV2Fr?=
 =?utf-8?B?QS9BNFo1cG9MY3VnYms4RmdsY0V5VzgweE5HOFVESTNDM3NVaFFpeVNON0RZ?=
 =?utf-8?B?VmJob21Xbm9HSm9GbXFrcnM5YUtOMkRxOWJ5cTk5dzBJaWhDdmMzM0dVVE9l?=
 =?utf-8?B?QzhWb0xnektkUVVaYkhRRXhUc24wVGhCMUlKN3ppdXJsMG1ySFhwM0xlSHZ3?=
 =?utf-8?B?TXRXa20zTnpoaC9pTjFJUU5IVFlaMFpFUkVSQllzcXFNUlVnRWlEd043aU1Y?=
 =?utf-8?B?SWZmL3FUcGhxd3YwUHZ0aThnWHhVMWRnRDJVRHJqeUIyQmxWS0RnRzVtNWx5?=
 =?utf-8?B?b3JsbmZwajJPSFpzWUx4UUg2SVdqT1J0ZnpiRjBFa2c3VFFGWElXbENZT0pi?=
 =?utf-8?B?MTJ0ZGtPcUovZGVZejJNdGVObklZOE40akVsTU5uOXdmdTJjTDVDUWJZN3dV?=
 =?utf-8?B?dlMyM0xlbERaQldxdWZ0K25MU0hpd3pCaGhaR002MzJabCtVNXFKbEdNa041?=
 =?utf-8?B?aFo4ckk1b3ptQmV6TklWNUhDK1h4TTZCaFlUYnA0RzVURmNXdFFuK1BzYVg3?=
 =?utf-8?B?aTIxVThENXBaRWVMemw2T2FOeUNZME1xR2FYTHhqN1kwUWg0Mi9IY0h6K3pW?=
 =?utf-8?B?UDhNWEVSQTBacGM4SXA0aW5IZnNOb0RnMUFRZjUwRloydldmMDc5Wmk4V2xG?=
 =?utf-8?B?a29NSXJpWEM1TGN4ZHJod2pnTVQ1eVpGblpEcGNydVB1ZHM1Mzlpak9RalBG?=
 =?utf-8?B?RWVmVTRmakZQdDdDMGNqZ3J6ZVB4T3JIZ2RUQnkxKzZCbFpmbndTQk5VelM5?=
 =?utf-8?Q?D0A2P1UCRY1Vcu3ZD43GnH+0o3m0RekjNxnzcpXmll6c2Z?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c05hTHovMEhQN3UwaW90cHdoRmhlZm1HazdDaEZtYlhCdXpPMjVxU202Y3FE?=
 =?utf-8?B?RElJV1BVMlI0WitNREpNclBuTUpMM1FTWDQvbHZQQ2ZaY3FJTFJQZk9KYTN4?=
 =?utf-8?B?WnZ4THBrQjBhK09VdHBCQitucG5BQmY3Q1A0ck1KMVpoOTJ0cWRHVkYvdmM1?=
 =?utf-8?B?WDdVQnU5T2kzUVEvaDg0U0F2dTNwRUNNbEpla3h4YXhBYnJ5QnN5eEpSOElo?=
 =?utf-8?B?QlMrOVlSbU84em9NcUZlLzdScit4cXY5Z0pjM29PKzRZaGtERUUrTERZSVJm?=
 =?utf-8?B?MU91bjNlazdzR2NCcy9DTFowZUM4cThLd2ZCdU55M0VBVkFxZUY4dGZ0dFJj?=
 =?utf-8?B?T3NwdTJsd2ZlZDRwRXQvYzFrWVFoaWVObnFiVExwSGpxdVVIa0o0ZTVuaUs5?=
 =?utf-8?B?NjBMK3V5UkxJTlFuSDNBRXFrYjFrUW0yOEJyV21WYVZuK2tSelo5Ym1yZUV2?=
 =?utf-8?B?ZkUxSXVqSXU4ODJBWDR3L1p3TjM0clBQLzUycmVDT0h4QzVjUWNCbDhLbVVP?=
 =?utf-8?B?NGhORkxoWjlDLzJBTWIwMmhadTRNZ0ttTUU3MXp4T2l2NFVvQnNmL0VlSi9J?=
 =?utf-8?B?clFhYTgvZit2Q1dVclNEeXRwbERiWUJMTXN6Z1dDcE9aZlRybXNadk1ubk5h?=
 =?utf-8?B?c3AxSlEvQ0JTY0V4MDB3WmRad1VSWTBVcWpwOWZWWVIzTU1RR1dsMUZqVEJB?=
 =?utf-8?B?Rk5oWjFzTFRmL09kc1BDRVQ0SjB2Y1ZQajE5RnA0N0VtcXBvRUlmUmtURk02?=
 =?utf-8?B?OW1wZUcrbTRUT21tUW50bU41VUxXVEJESThoTzBOZHNJSHl5OTZ4YkpOVEJ0?=
 =?utf-8?B?RlNrREZvZEEwdUVMQVU2MmhsUi8rNytKUEhpUkJaWUQyYzZNUUxlbE9ndE8z?=
 =?utf-8?B?Um5DR004am93a2ZMNmVKY3RPVkEyMW9MNWxScWd2aUgyQlpwdERlQ0tWUnhj?=
 =?utf-8?B?OENyN3kyaER0VHRrTkRGUHk2Y3paVjFmS1I2d1pMK2RyeUxkdlA3M1RRYVVj?=
 =?utf-8?B?VS9BUi9ocTJLSVFDTUt6RVgzelUxSDFwTDBxVUM5Ry90cEd5Q09oK0dnVC9L?=
 =?utf-8?B?TEdDb3QwWjB5N0dpWFdpSy8veHJvam40Mkc1bUZTcFVCK2VDNXJNRG45M0hP?=
 =?utf-8?B?UEhpZ3Nvb1VTc1g0Q1FRWEpuUncwd0hEV3A3dmw5MHNFRmsxbllwbUo3RGpB?=
 =?utf-8?B?MzBlU1BRY3F3TTdnUlFZbWpwQlRVUkRXZ2tVMUV4cXBCRXR2eVFiUHU4M3Ew?=
 =?utf-8?B?eThSNGNCNnd4d2pJRG5qYTVMV0VLcXBHYzA5V2pWZGdNSE1aT0RXMzVYY2xH?=
 =?utf-8?B?OS94VGFTbmpMajRxRDg4YmliL3M0cDFxR2NnQUtWTE1kUkpTMVAvUDNOVGx6?=
 =?utf-8?B?UFBud21yNE1KNTlGbzZtSjYyZ2Z2M0xhNkhXNDc0cDJWRlpQOFBBc2pTNzl2?=
 =?utf-8?B?djBFQXhSSjdVMnVmOTJUTS8wWUtuZzJITUdES1E2M2Y2bWh1NDBCSmNXeFV0?=
 =?utf-8?B?NytpTTdIZHhVTDFzZmk5cWpmcCtGT0R3dzVSSGVUaG9RcjdIT3UyNTQrM1BH?=
 =?utf-8?B?SUM4Tk9DSStzK0pvUWVIcG9hVlVHSDZ2UU03eElIU3ByaDdGRXVzRHdjK2c2?=
 =?utf-8?B?dlJHSjhiejVnWFJ5dGFseEFNcVVOdzJ3TVBhenQzVnA2QVJJSU9JT0duQVFG?=
 =?utf-8?B?RWRmdG9lWGc2cFB2NWpPaW42ZThwVEFtYklYZ3huQWY4MDFJUVl2MDJEZWdj?=
 =?utf-8?B?NXhJYUJ1MVBWRGFDbXlJVlFpV3JXRlNwUzBHaDhHeG5NVTRKNEovRGp0RkdE?=
 =?utf-8?B?Ynk4aGs4MnFRNDA2WEZVZjVIN05GYnVDZDFCc0xiZlg1RnJnOXhmYjdvV1R1?=
 =?utf-8?Q?/hwVyTZPk+NZn?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3761ab-2c13-4aca-fe2c-08df3cb48ee0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2026 09:50:28.8437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR05MB10700

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KCnVyaW5nX2NtZCBy
ZXF1ZXN0cyBhbHJlYWR5IGFsbG9jYXRlIGVub3VnaCBhc3luY2hyb25vdXMgc3RhdGUgdG8gaG9s
ZCBhCmNvcGllZCAxMjgtYnl0ZSBTUUUuIE9uY2UgYSBkcml2ZXIgaGFzIGNvbnN1bWVkIGV2ZXJ5
IFNRRSBmaWVsZCBhbmQKY29tbWl0dGVkIHRvIGFzeW5jaHJvbm91cyBjb21wbGV0aW9uLCB0aGF0
IHN0b3JhZ2UgaXMgbm8gbG9uZ2VyIG5lZWRlZC4KCkFkZCBhIGhlbHBlciB0aGF0IHRyYW5zZmVy
cyB0aGUgc3RvcmFnZSB0byB0aGUgZHJpdmVyIHVudGlsIGNvbW1hbmQKY29tcGxldGlvbiB3aXRo
b3V0IGdyb3dpbmcgdGhlIHJlcXVlc3Qgb3IgYWRkaW5nIGFuIGFsbG9jYXRpb24uIEludmFsaWRh
dGUKdGhlIFNRRSBwb2ludGVyIG9uIHRyYW5zZmVyIGFuZCBmYWlsIGEgc3Vic2VxdWVudCAtRUFH
QUlOIHJldHVybiB3aXRoIC1FSU8Kc28gYSBjb21tYW5kIGNhbm5vdCBiZSByZWlzc3VlZCBhZnRl
ciBvdmVyd3JpdGluZyBpdHMgU1FFIGNvcHkuCgpTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcg
PHgtcHJvZmVzc29yQG91dGxvb2suY29tPgotLS0KIGluY2x1ZGUvbGludXgvaW9fdXJpbmcvY21k
LmggfCAyNCArKysrKysrKysrKysrKysrKysrKysrKysKIGlvX3VyaW5nL3VyaW5nX2NtZC5jICAg
ICAgICAgfCAyMiArKysrKysrKysrKysrKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDQ2IGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oIGIv
aW5jbHVkZS9saW51eC9pb191cmluZy9jbWQuaAppbmRleCBlMThkNGFmNjJlMWEuLjZhOWMwNmJj
Y2NjNiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pb191cmluZy9jbWQuaAorKysgYi9pbmNs
dWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oCkBAIC04LDYgKzgsNyBAQAogI2luY2x1ZGUgPGxpbnV4
L2Jsay1tcS5oPgogCiAvKiBvbmx5IHRvcCA4IGJpdHMgb2Ygc3FlLT51cmluZ19jbWRfZmxhZ3Mg
Zm9yIGtlcm5lbCBpbnRlcm5hbCB1c2UgKi8KKyNkZWZpbmUgSU9SSU5HX1VSSU5HX0NNRF9TUUVf
Q09OU1VNRUQJQklUKDI5KQogI2RlZmluZSBJT1JJTkdfVVJJTkdfQ01EX0NBTkNFTEFCTEUJKDFV
IDw8IDMwKQogLyogaW9fdXJpbmdfY21kIGlzIGJlaW5nIGlzc3VlZCBhZ2FpbiAqLwogI2RlZmlu
ZSBJT1JJTkdfVVJJTkdfQ01EX1JFSVNTVUUJKDFVIDw8IDMxKQpAQCAtODIsNiArODMsMjIgQEAg
aW50IGlvX3VyaW5nX2NtZF9pbXBvcnRfZml4ZWRfdmVjKHN0cnVjdCBpb191cmluZ19jbWQgKmlv
dWNtZCwKICAqLwogdm9pZCBfX2lvX3VyaW5nX2NtZF9kb25lKHN0cnVjdCBpb191cmluZ19jbWQg
KiwgdW5zaWduZWQgaXNzdWVfZmxhZ3MpOwogCisvKioKKyAqIGlvX3VyaW5nX2NtZF9nZXRfY29t
cGxldGlvbl9kYXRhIC0gcmV1c2UgdGhlIGNvbW1hbmQncyBTUUUgY29weSBzdG9yYWdlCisgKiBA
aW91Y21kOiBjb21tYW5kIHRoYXQgaGFzIGNvbnN1bWVkIGFsbCBvZiBpdHMgU1FFIGZpZWxkcwor
ICogQGxlbjogYW1vdW50IG9mIGNvbXBsZXRpb24gc3RvcmFnZSByZXF1aXJlZAorICoKKyAqIFRy
YW5zZmVyIHRoZSBwZXItcmVxdWVzdCBzdG9yYWdlIHJlc2VydmVkIGZvciBhbiBTUUUgY29weSB0
byB0aGUgY29tbWFuZC4KKyAqIEFmdGVyIGEgc3VjY2Vzc2Z1bCBjYWxsLCBAaW91Y21kLT5zcWUg
aXMgaW52YWxpZCBhbmQgdGhlIGNvbW1hbmQgbXVzdCBub3QgYmUKKyAqIHJlaXNzdWVkLiBUaGUg
cmV0dXJuZWQgc3RvcmFnZSByZW1haW5zIHZhbGlkIHVudGlsIGlvX3VyaW5nX2NtZF9kb25lKigp
LgorICogTXVsdGlzaG90IGNvbW1hbmRzIGNhbm5vdCB1c2UgdGhpcyBoZWxwZXIuCisgKgorICog
UmV0dXJuOiBjb21wbGV0aW9uIHN0b3JhZ2Ugb24gc3VjY2Vzcywgb3IgTlVMTCBpZiBpdCBpcyB1
bmF2YWlsYWJsZSBvciB0b28KKyAqIGxhcmdlLgorICovCit2b2lkICppb191cmluZ19jbWRfZ2V0
X2NvbXBsZXRpb25fZGF0YShzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3VjbWQsCisJCQkJICAgICAg
IHNpemVfdCBsZW4pOworCiB2b2lkIF9faW9fdXJpbmdfY21kX2RvX2luX3Rhc2soc3RydWN0IGlv
X3VyaW5nX2NtZCAqaW91Y21kLAogCQkJICAgIGlvX3JlcV90d19mdW5jX3QgdGFza193b3JrX2Ni
LAogCQkJICAgIHVuc2lnbmVkIGZsYWdzKTsKQEAgLTE0MCw2ICsxNTcsMTMgQEAgc3RhdGljIGlu
bGluZSB2b2lkIF9faW9fdXJpbmdfY21kX2RvbmUoc3RydWN0IGlvX3VyaW5nX2NtZCAqY21kLAog
CQkJCSAgICAgICB1bnNpZ25lZCBpc3N1ZV9mbGFncykKIHsKIH0KKworc3RhdGljIGlubGluZSB2
b2lkICoKK2lvX3VyaW5nX2NtZF9nZXRfY29tcGxldGlvbl9kYXRhKHN0cnVjdCBpb191cmluZ19j
bWQgKmlvdWNtZCwgc2l6ZV90IGxlbikKK3sKKwlyZXR1cm4gTlVMTDsKK30KKwogc3RhdGljIGlu
bGluZSB2b2lkIF9faW9fdXJpbmdfY21kX2RvX2luX3Rhc2soc3RydWN0IGlvX3VyaW5nX2NtZCAq
aW91Y21kLAogCQkJICAgIGlvX3JlcV90d19mdW5jX3QgdGFza193b3JrX2NiLCB1bnNpZ25lZCBm
bGFncykKIHsKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3VyaW5nX2NtZC5jIGIvaW9fdXJpbmcvdXJp
bmdfY21kLmMKaW5kZXggYjU0ODZiNTZlZTBjLi44N2IxYjMwMGFlMjAgMTAwNjQ0Ci0tLSBhL2lv
X3VyaW5nL3VyaW5nX2NtZC5jCisrKyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jCkBAIC0xNjYsNiAr
MTY2LDIzIEBAIHZvaWQgX19pb191cmluZ19jbWRfZG9uZShzdHJ1Y3QgaW9fdXJpbmdfY21kICpp
b3VjbWQsIHVuc2lnbmVkIGlzc3VlX2ZsYWdzKQogfQogRVhQT1JUX1NZTUJPTF9HUEwoX19pb191
cmluZ19jbWRfZG9uZSk7CiAKK3ZvaWQgKmlvX3VyaW5nX2NtZF9nZXRfY29tcGxldGlvbl9kYXRh
KHN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCwgc2l6ZV90IGxlbikKK3sKKwlzdHJ1Y3QgaW9f
a2lvY2IgKnJlcSA9IGNtZF90b19pb19raW9jYihpb3VjbWQpOworCXN0cnVjdCBpb19hc3luY19j
bWQgKmFjID0gcmVxLT5hc3luY19kYXRhOworCisJaWYgKCFhYyB8fCAhaW91Y21kLT5zcWUgfHwK
KwkgICAgaW91Y21kLT5mbGFncyAmIChJT1JJTkdfVVJJTkdfQ01EX01VTFRJU0hPVCB8CisJCQkg
ICAgIElPUklOR19VUklOR19DTURfU1FFX0NPTlNVTUVEKSB8fAorCSAgICBsZW4gPiBzaXplb2Yo
YWMtPnNxZXMpKQorCQlyZXR1cm4gTlVMTDsKKworCWlvdWNtZC0+ZmxhZ3MgfD0gSU9SSU5HX1VS
SU5HX0NNRF9TUUVfQ09OU1VNRUQ7CisJaW91Y21kLT5zcWUgPSBOVUxMOworCXJldHVybiBhYy0+
c3FlczsKK30KK0VYUE9SVF9TWU1CT0xfR1BMKGlvX3VyaW5nX2NtZF9nZXRfY29tcGxldGlvbl9k
YXRhKTsKKwogaW50IGlvX3VyaW5nX2NtZF9wcmVwKHN0cnVjdCBpb19raW9jYiAqcmVxLCBjb25z
dCBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpCiB7CiAJc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91
Y21kID0gaW9fa2lvY2JfdG9fY21kKHJlcSwgc3RydWN0IGlvX3VyaW5nX2NtZCk7CkBAIC0yNTcs
MTEgKzI3NCwxNiBAQCBpbnQgaW9fdXJpbmdfY21kKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNp
Z25lZCBpbnQgaXNzdWVfZmxhZ3MpCiAKIAlyZXQgPSBmaWxlLT5mX29wLT51cmluZ19jbWQoaW91
Y21kLCBpc3N1ZV9mbGFncyk7CiAJaWYgKHJldCA9PSAtRUFHQUlOKSB7CisJCWlmIChpb3VjbWQt
PmZsYWdzICYgSU9SSU5HX1VSSU5HX0NNRF9TUUVfQ09OU1VNRUQpIHsKKwkJCXJldCA9IC1FSU87
CisJCQlnb3RvIGRvbmU7CisJCX0KIAkJaW91Y21kLT5mbGFncyB8PSBJT1JJTkdfVVJJTkdfQ01E
X1JFSVNTVUU7CiAJCXJldHVybiByZXQ7CiAJfQogCWlmIChyZXQgPT0gLUVJT0NCUVVFVUVEKQog
CQlyZXR1cm4gcmV0OworZG9uZToKIAlpZiAocmV0IDwgMCkKIAkJcmVxX3NldF9mYWlsKHJlcSk7
CiAJaW9fcmVxX3VyaW5nX2NsZWFudXAocmVxLCBpc3N1ZV9mbGFncyk7Ci0tIAoyLjQzLjAKCg==
