Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794313481;
	b=uHWJlBMvzb+ktaoKtUCRgAz0wDMn4Xf/u+MDgSVX0TUmyKtPR5GupM/K2efhVLLeKV3F
	 5G+HMryZ60XL1BMC0IQoZ7dWDdYxvq9SS6XZmFK04LeZaF7q2Cxgak7cY2s7jTHqId+KI
	 bgE5TNTz6kEGXXmdmIB3097kgnySJqqPsGaYHDER9dqG4ZPCiruNKAM55KW4K9rP99q12
	 Lyyxrhg71PPdD0S3YGVB5u1nI7x02kE7rRkCnbxeoSJw1RI7uDEhNbL1NCKe9cwI/itZ5
	 f/FGMGGa32Rbk+eLFMsLtoheECkIxDPGqHByDigH0aUfqj0d//YSfYI5zxLB4AUryeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313481;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
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
	bh=xDOIdpaCx9QY4p1FOgufA3xlzxKio9Xq87xYhvhitV4=;
	b=BZP9a4Wac4Ui5ETV+GgfX+9SSdRzjjQ6c7k249jTnXNjQI1Od3jjMKo+Np/PiMzgFDuq
	 MbfhEkvqGzarO9lq0NbKrqYtCQ78JBjZweR+n1DEme7AiRllbbS1TxEzgCaueYL7ZlnVp
	 4D+0eW3yEYEqYIx04qVe/PPKzOGuUtzMoBE/w7dt9qc05mXI2Z4iKMrgk+T9QtM8HSm1L
	 u5RLBDd/Asf3eAQNbJ2GM4HydAqx0CuPPOiZ6tnq6cl9T+aDGiKZ3+onw9Wb5lg6sJKUF
	 irt1q98WkOkAEQKTAaEXGyjfyH5usrFwql+B0//lj1Nf/cR/4JJHWZc+QsvrmPYSLzA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=I2D1k0kP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.69
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19011069.outbound.protection.outlook.com [52.103.23.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24356606A31C;
	Tue, 10 Nov 2026 12:24:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24356606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=I2D1k0kP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VT7vzpeEItI744ABovFTnr+WVYnEbznfxkcXIJl7+NsUfslo6smrBd5rtbMLdefWlXVLsMhhxfWI0CNkNFDSCS6m3lGh5UYhe+XRMhA5WiOYGhMq/9sj0l6HRVuzau381aNe0pFY8KA5eHM/ndP0jXcnoiR2Coq1VMjskuQKWB+jkabc/Wn7lOWOCUIj7SaAMbVMi45lTNLIFZiCIdY7H0PThaSZLW9kCbJBGLjJRP4pQV6TajfzgwF7U+9h+7wjywMlhAiXU4bPIk2PlDDEMUvELIoSC13dV6hAtnfMjczcA3OgAh/OArjOVU5JC6cCjr0By8kOofjR4MwpmWyMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=xDOIdpaCx9QY4p1FOgufA3xlzxKio9Xq87xYhvhitV4=;
 b=Z3E6c6oBWb7zhQELcW9idVwLC0C+X9b/FXsYZ99a4HHJDswPUyWdxOjocxoNjxNCNQD939nlMRINzoK2txW7WqxMSRYOz5C1N/gf0HgXnSj1JT3EZfBWYlpy+LGhkEitk6dstZe1ES7QTawkmhtEIyJQQ432hVbjxWA0SGEbIfk4YhNBJ7nLSUYrvejZyYFDSeO+EYJqGXNoO56kY/e4melMzDC5cggLJQwtYbhnS+0AB4k58v9mdoU0wbW+i77npWJ7DU5tAp10cmaNdSO/W7IbzuOOTK1RBx/q8EGT07zUy6EteVOfoxpRUr3ErctyqLF23oz729/apv6+Wk/eNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDOIdpaCx9QY4p1FOgufA3xlzxKio9Xq87xYhvhitV4=;
 b=I2D1k0kPufVrPjkSDffoBrn5lgAs7vQ4PYbEReRDfuwF+P7tynx3d8ZrIyVMhbCJW+O8kjHQLyCYlnLMDnqnmNT/jqvFJ2iFiz66GLz0FtEAfovse+6rJjMk0SwfnT5XMSg6LnUg44hlqcJegf8uCJJF14dHhG9/N3PH9G54UTTs9wC8hR13E/vcpgRYUSDICl9q8fUuYklzwRagzjY//oNGela110K3odLw4CJW7uMUOz8udeKVCNj+qYn4KcU7jaOxioQJWWTe63meauSDXc01fpr/r/zRpLkdEbf0wT1IS8I1NDtpqjkDziouOeSguFKMgMk/bHh+YXQTu1n2tg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SJ0PR05MB7532.namprd05.prod.outlook.com
 (2603:10b6:a03:2ec::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 12:24:38 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 12:24:38 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>
CC: "mkp@kernel.org" <mkp@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "jthoughton@google.com"
	<jthoughton@google.com>, "asml.silence@gmail.com" <asml.silence@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 5/6] io_uring/cmd: allow reusing SQE storage for
 completion data
Thread-Topic: [RFC PATCH v3 5/6] io_uring/cmd: allow reusing SQE storage for
 completion data
Thread-Index: AQHdbp1r/IUM1KiQW0u7BqizLWiRsQ==
Date: Tue, 10 Nov 2026 12:24:38 +0000
Message-ID: <20261110122434.4144043-1-x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com>
 <a4ec8431c2f36172348449b872faf26d7d6d4d7a.1794045010.git.x-professor@outlook.com>
 <20261109025114.433681-1-yangxiuwei@kylinos.cn>
In-Reply-To: <20261109025114.433681-1-yangxiuwei@kylinos.cn>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SJ0PR05MB7532:EE_
x-ms-office365-filtering-correlation-id: 772229fa-9495-4d15-7870-08df3f2596de
x-microsoft-antispam:
 BCL:0;ARA:14566002|4140399003|24021099003|25010399006|31061999003|16041099003|38102599003|8060799015|19110799012|8062599012|12121999013|24121999003|22091999003|15080799012|12091999003|53005399003|40105399003|26121999007|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?utf-8?B?dmtyajN5cmdNNFJWcDVHZmU1SHF4aWx3QjhFRVVKQXA1N2Q4TE5XZmkzWHc3?=
 =?utf-8?B?dWNCMWtCdzJpZUNyVXQzTURnMU5kVi83N2ttMEYyeitVS2l3aFlsWUluei9a?=
 =?utf-8?B?ZCtwM3hSbjI1dTJtNTRXbCsxVzEzdXhqSXZsSmgwZGdEa2VlSTNsNWZaclNs?=
 =?utf-8?B?dzVaMXNhQnBXYWt1VkR6OVlqVlZtY1UycWc0RkZjdkVENlNDTjJzUzQ5TWgz?=
 =?utf-8?B?c3Q0VlVVSU9taTdYRi9pZWRCSXFVaGEzdUR6bzBzOVVsWkcvS0VmRG5NTVFI?=
 =?utf-8?B?MEtibkJwWkwzVFViTktEU1VQMUFMdkNUOW02dzZtaXBwU2ErbmFYUkhpZjRP?=
 =?utf-8?B?SGxEVzJqYVZxSGtVTzZaeDljSWtPM1hZUlh4NWdFQms2TThyaHpyWGlEQ3o0?=
 =?utf-8?B?Nm5Od0NIUHhkQnVEdDhqM1hjd1BTRTM5YVNyTXdLMHdNbmVibm5TMUtVcm9y?=
 =?utf-8?B?VjRKTm1tVzZkU205RGRlRFBMSnBmVmpLQlFuS1BWbHFvV1RuVTRDbGJTYzRl?=
 =?utf-8?B?a2NnUTV5ZlIrVTRiZE5BTFpUQzhiZjdMWlA3b3NzcGt0NEhOcFZHUW1KSUll?=
 =?utf-8?B?VnNyZEY1NGtBUDcvaCtNTklCVWoyT1BPNDR4SHVZZ0pEOGo5K3dvbzFtUmhN?=
 =?utf-8?B?U0t0YjJ4MGI4TUt0MGk1S2V6b3kyV3pIOUNER3YzZDdqblQ0T1hQRFdhZlQ1?=
 =?utf-8?B?eHRvd1Q1S3BrL1pZcEVyaHVSZFdSbnNwNURxTHVkemR0S3NnYVVlKzdCaGQr?=
 =?utf-8?B?S0ZKRkE2MVJ2RkJsQkF4dU0wOXRHRXZUTnVKZXg3azd6bTZ1YUdZYkR4dXph?=
 =?utf-8?B?NWI4bzdKVXkyTndBS01BWG12RXZadzZUVlduZVUxVElHbnB1NUhJWHluR0gy?=
 =?utf-8?B?TlU3OUlCTCtRT2FCMWFzSVE3VCtPdmFSMnhrcFNNaVdhNHBYTGVWT2dLRC9w?=
 =?utf-8?B?aXhpUkg2TDU2dTh5Qm0xVVREems4NGZtTnRWaDUwMldDYmtJajNzeEVTRklT?=
 =?utf-8?B?Yy9JV082SDMzbEQxb1FZM3JUYU55QzNUaUZJT2grQ0dlZE52NGpxbXZ5WlRm?=
 =?utf-8?B?c25CcEZXNytsQkJYVHZWU1pyS1ZUZlJvcjNwL3Y1Q1FmYklqT2IxVVpWT3lN?=
 =?utf-8?B?YWJpdmp0YzNjWDNOYmJyN0UrK0tXM0JIMXVYTXFCM1hiek5CclRUQTJ6a1F2?=
 =?utf-8?B?UUZVWVpXcTRPaVpzdjNFTFVwd21WaS9JM3lGT2ptS0NiVVo2UTNac1FCSG9t?=
 =?utf-8?B?NWRZU0RRUVVwZ3k1OVYxUWVBeEY4amNiQWFsVWV3MTlRbS80a2VuRFA1RWdu?=
 =?utf-8?B?cEcwTE9VR0NPU0RIQUh5YzJXUkYrKzE4Mjd4bS9CL2hiSEZyaWROcXBrN1Zz?=
 =?utf-8?B?MU5HSlFEREo1c1p5K3JSMXVleUl5YXYrbUlWdlI5ZlN0L0ZIMko3ZVJXYTQ4?=
 =?utf-8?B?RzlWV1pubTVMTVYwbGUxby9kSXJNUWxmY2tBYVZjbXk2NTVOdndxUHVNUlJk?=
 =?utf-8?B?MDd1cVNnaDBYd1B1WGJEWld1aTRSY25FdU9UVzF6Y1AwSFlUWURqcjN4Mmcr?=
 =?utf-8?Q?Xzexb5sqJ7PW6S8HnfysGVchg=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RzkrRkVGOENEaWpEanQ4Tm5zcnp4NnBmaFNVbUs0N2FyVDFOQ2xYUUZQV1Mw?=
 =?utf-8?B?QU14MVVzM201TUpkaEY4dG5qaDJxNEdpOCtBd3NYcjlHbG9uL01Ob2d3MEx5?=
 =?utf-8?B?UDVMTnlTVFBzdUxuTjluYUduMitEeVFINmdCWExFbGRZa3ZaUWN4MHZ5R0xu?=
 =?utf-8?B?YUZSMmdTSnZ3azdpRDBNKzkwWER3YSswNHNITlRwWExTWmt1bEUyVDBSNE84?=
 =?utf-8?B?bVFNZ2NRVXlqbk1CNWRxL2lSN3NWRXI3cXl2cksrRDJkODFOTzVlSjJZTVMw?=
 =?utf-8?B?aVBiR1BXTHNkN0FYZjFuMittZHBQN1lMTExQWTlMUWRhUllGWjhQdVRvSnl3?=
 =?utf-8?B?M0JsM0xBYUtMbjAzaFF1b0NSeHRGdmlrMmp5SDZqU055TjM2Q2hENUJGUElo?=
 =?utf-8?B?bzNNb0xqV3RlR2dwTms5bkRYVGxmZEdqOTVheU1xM1VxUWgrQVRxS0JZNzlO?=
 =?utf-8?B?MEMzMTN3MHo1MFpVMTRjUzgrK0dhY3JERHFwZUI0TEZMM1VlY2VIMXhkRVdu?=
 =?utf-8?B?MS90OE5GQ1dmVzA2UVlBc0Q3cTd6c2RLRko4Y0pQWFNNMnFPQ2RONzAzT2NH?=
 =?utf-8?B?bElvNTc0a3pNd0JlTjM3Vk5YRGxUcHlkbFZQUTAvZGdlajUwdmhmZzR3M05Y?=
 =?utf-8?B?cFRaTEdzcWZPMWc3QzRKdmxFam1jM3BFWC81ejJ2eHgyeGNtNDRTQlg2Yk9C?=
 =?utf-8?B?NGg1Vzc0eXc4QW1tV1hzbW90c0FKNzQ0c3VKbmxFTTVENVVoNWx1d1h2bnZR?=
 =?utf-8?B?YWJvcmtNazh6blpDYUQrcE1hVkUwcnF0NzlrWFRXN1NSTHJ0aDRCZkUrOGNC?=
 =?utf-8?B?Ky9lU0ppU3FTTnBMTkZEWmIvNFZoYS9xT3FKRFFkc3hPdFRjcUM3WEZNdG9p?=
 =?utf-8?B?L0t3Q1dKbTRSUzloYVZlY2RyeXBnNmFJZDBTclp1N3Z6czU0S3RRVXlqSzV2?=
 =?utf-8?B?d0EyVVRMOTFpY2dpdkpKemRuUDR3cHBHY01rcUd5N1ppQWIyaUxNc0c1WHlw?=
 =?utf-8?B?aEFhNXJKMU5mbjhxc2Fka1VGaUllcWF5TlJweE4rTFcyU083VG1IdmY2RHpF?=
 =?utf-8?B?aW05ZG5PZnM2Z1htaC9XM1RaRElNeHpSN0JvMlJCYi94YUhwQU1VVVZ6b1ZV?=
 =?utf-8?B?ZHI5QlpGaE80dmJ4dDdwZXpWTnVVZlFLeGZSQ2wrUG5qYkNmdloyU3V1aThi?=
 =?utf-8?B?ZWlIQ0JWSUludHEvSnNMd3NlbUhLV2NQdms2L2hHR1Arenk0VmxWTlQ5NXQ0?=
 =?utf-8?B?MGZOWk5LN0x2ZXFIN3lpaDBDcDZGVzJxQk1adG9tR2Y5aERNQXAzS3A1Q0R0?=
 =?utf-8?B?RGZMMDNGVUsvVzM2NWVzZTk5SE1kWUhoNmJUTnNGSWlCdTY2UkJ6RnpvemFu?=
 =?utf-8?B?WTU4UXN6K2dtcitKR0NKZUFpUHpsVXRHdURoTjZyc21zOE04RnV6bGd4OUhm?=
 =?utf-8?B?UmwxbG0xM29RTWZVOHMwNU5HcW1qZVNEOGZ4QklQRzF3andmWWszRHFMTGdR?=
 =?utf-8?B?anhwZU5EK2VZN2RqNW5YdE9kQVNzMXlhVlFJcnBva3JnbnEyNnZHcktLc01N?=
 =?utf-8?B?TXJ4T1hsaVFvOHI1L3BiUUgwSG1OMjZFNFZSZ1Rha3M5NjExcE5zUUJoRE1G?=
 =?utf-8?B?cDFidFAzWDkvWTlPMzdLaGI1YnhTWE84eHRNSHYwbTVTMVVjdnIrL2Z6bmMz?=
 =?utf-8?B?WEVHU3BWTkpsZ29Obi80L2g5WnZNQjlzUno0Z2dXQ00ydjREbTVkSExmNStj?=
 =?utf-8?B?bElzV0t0eThMdDBGaFpjSi9vdndYVHNVR2s2ajQ2Y2Yya1dpaldDNTlXbW9W?=
 =?utf-8?B?bWlvSmM1OFA3ZlpvbWJtbmFtd3hLZjMybXlyaVVKcmxHQ3RJeExGTmNnNTRR?=
 =?utf-8?Q?yvhh5nh4PAnRy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51F20E9E6C155046A168A91C47568143@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 772229fa-9495-4d15-7870-08df3f2596de
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 12:24:38.6878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7532

T24gTW9uLCA5IE5vdiAyMDI2LCBZYW5nIFhpdXdlaSB3cm90ZToKPiBpb19hc3luY19jbWQgaXMg
aW9fdXJpbmcncyBvd24gYXN5bmMgc3RhdGUuIHNxZXNbXSBpcyB3aGF0Cj4gaW9fdXJpbmdfY21k
X3NxZV9jb3B5KCkgcG9pbnRzIGlvdWNtZC0+c3FlIGF0LiBHaXZpbmcgdGhhdCBidWZmZXIgdG8K
PiBzY3NpX2JzZyBjb3VwbGVzIHRoZSBkcml2ZXIgdG8gdGhlIGlvX3VyaW5nIGxheW91dCBhbmQg
bGlmZXRpbWUuCgpIaSBZYW5nLAoKVGhhbmtzIGZvciB0aGUgcmV2aWV3LiBzY3NpX2JzZyBwYXNz
ZXMgdGhlIHJlcXVpcmVkIHNpemUgdG8gdGhlIGhlbHBlcgphbmQgZ2V0cyBhIHBvaW50ZXIgdG8g
dGhlIHN0b3JhZ2UgYmFjazsgaXQgZG9lcyBub3QgYWNjZXNzIGlvX2FzeW5jX2NtZApvciBzcWVz
W10gZGlyZWN0bHkuIEhvd2V2ZXIsIEkgYWdyZWUgdGhhdCB0aGUgaGVscGVyIGNvbnN0cmFpbnMg
aG93CmlvX3VyaW5nIGNhbiByZXVzZSB0aGF0IGludGVybmFsIHN0b3JhZ2UuCgpUaGUgcHJvcG9z
ZWQgY29udHJhY3QgaXMgdGhhdCwgYWZ0ZXIgYSBzdWNjZXNzZnVsIGNhbGwsIHRoZSByZXF1ZXN0
ZWQKc3RvcmFnZSByZW1haW5zIHZhbGlkIHVudGlsIGlvX3VyaW5nX2NtZF9kb25lKigpLiBCU0cg
cmVxdWVzdHMgOTYgYnl0ZXM7CnRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGNhbiBwcm92aWRl
IHVwIHRvIDEyOCBieXRlcy4gVGhlIGNhbGxlcgptdXN0IGFsc28gc3RvcCB1c2luZyB0aGUgU1FF
IGFuZCBtdXN0IG5vdCByZWlzc3VlIHRoZSBjb21tYW5kLCBhbmQKbXVsdGlzaG90IGNvbW1hbmRz
IGNhbm5vdCB1c2UgdGhlIGhlbHBlci4KCkplbnMsIFBhdmVsLCB3b3VsZCBzdWNoIGEgY29tcGxl
dGlvbi1zdG9yYWdlIGNvbnRyYWN0IGJlIGFjY2VwdGFibGUKZm9yIHVyaW5nX2NtZCwgb3Igd291
bGQgeW91IHByZWZlciB0aGUgc3RvcmFnZSB0byBiZSBkcml2ZXItb3duZWQ/Cgo+IFByZWFsbG9j
YXRpbmcgdGhlIGJ1ZmZlciBpbiBic2cgaXRzZWxmIG1heSBiZSBhIGJldHRlciBmaXQuCgpXaGlj
aCBvYmplY3QgZGlkIHlvdSBoYXZlIGluIG1pbmQgZm9yIHRoZSBidWZmZXI/IFdpdGggNi82LCBl
bmQtSS9PCmZyZWVzIHRoZSByZXF1ZXN0LCBhbmQgdGhlIHRhZyBjYW4gYmUgcmV1c2VkIGJlZm9y
ZSB0YXNrIHdvcmsgY29waWVzCnRoZSBzZW5zZSBkYXRhLiBTdG9yYWdlIHRoYXQgaXMgcmV1c2Vk
IGFsb25nIHdpdGggdGhlIHJlcXVlc3Qgb3IgdGFnCndvdWxkIHRoZXJlZm9yZSBoYXZlIHRoZSBz
YW1lIGxpZmV0aW1lIHByb2JsZW0gYXMgc2NtZC0+c2Vuc2VfYnVmZmVyLgoKUXVldWUgZGVwdGgg
YWxvbmUgYWxzbyBkb2VzIG5vdCBib3VuZCB0aGUgbnVtYmVyIG9mIGNvbXBsZXRlZApjb21tYW5k
cyB3YWl0aW5nIGZvciB0YXNrIHdvcmsgb25jZSB0aGVpciB0YWdzIGhhdmUgYmVlbiByZWxlYXNl
ZC4KQSBCU0ctb3duZWQgcG9vbCB3b3VsZCBuZWVkIGEgc2l6aW5nIGFuZCBleGhhdXN0aW9uIHBv
bGljeS4KYnNnX29wZW4oKSBjdXJyZW50bHkgYWxsb2NhdGVzIG5vIHBlci1maWxlIHN0YXRlLgoK
SWYgZHJpdmVyLW93bmVkIHN0b3JhZ2UgaXMgcHJlZmVycmVkLCBJIGNhbiBpbnZlc3RpZ2F0ZSBh
IHBlci1maWxlCnBvb2wgZm9yIHY0LiBJIHdvdWxkIG5lZWQgdG8gY2hlY2sgdGhhdCB3YWl0aW5n
IGZvciBhIGZyZWUgYnVmZmVyCmNhbm5vdCBwcmV2ZW50IHRoZSB0YXNrIHdvcmsgdGhhdCByZXR1
cm5zIGJ1ZmZlcnMgZnJvbSBydW5uaW5nLgoKVGhhbmtzLApZaW5namllCg==
