Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794990788;
	b=U1dKNkZaO8nx7g3w/wweahSuSLL08RlX27n1m+dSnmBVhyGV5Lrlxqu+6p/6U5nfuo8e
	 uVTalfC+GUzxd8sKUkaIelOOVOl/FoCmFZuJIvNf+QyIfYUftUxdHo1ds4gPIVMW9qDT+
	 BenSUjTiNg9BNdQ7aEj64BH++hhXUntbPcHjVIvPItUk+Vv5q5iKNCV9O5AVbkCMSivc0
	 KhFviBOHWEWPs43DvtL9x8f5cL0lEaAj3SnO8oZNUXmFiBgFCO+xKjlEqdLePcpwF8hbG
	 Lu6jG58BheLw4eaALZl+TQkcds+gownLYXnBYJcDX+9WXUpcLi0CykzHCccAnGDA/Vw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990788;
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
	bh=BZPAJHJPuxPJGUmiHuYXDqkvHIgT3luyN2815OvFnsU=;
	b=mpRtnh7joBp8oj/fFZ9W37qQXZxDEnQcapCYiLKBzlabCUZIHaqaUjRMLieVo3vjkTDu
	 6BMVI9v6TxIU4+qKCl6+3KCpsICmeEnh7lN5nai+RCVv5X/IW1a5YJe8YeTe3A6QfOdw2
	 fEyzESvyUZnqm/JKL0X6nje5HfPzFxJq/FRNPV34IiBckVYrG1n4pmI7hBosxlvEyAtOB
	 lJ1wP9Z5mXQPND9kXf9YJvmV1XKchvS4SKocf5nhMDhCNaAWOuTmCW/gTQmLX7miYRVum
	 zCYi4kHnBDODgqvHwqoomONgwoQx7tFcavnd2RL6XmLOaouLnTino+N0NFRrM0k1Meg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=QMAri3Oj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010005.outbound.protection.outlook.com [52.103.12.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC586606A88B;
	Wed, 18 Nov 2026 08:33:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC586606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=QMAri3Oj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMbkLn432VhRPgPVS0GOkGhMIZR+hJM1eKvNRWKZyAmaODh6WJrNcGZg/h1JYyNsKs5Y2qWraBjr1GRPUkoZghITlMm2Yz/XYJdZvbbWSu2ofOAydyqcvGRqirgJHA1BDEsfWqt0MrErMOjSPxoVHIzof2fElfhN7UhcjG0gzKFGWBRYma7N9Wtc5iVIaNs2wr2tlE2xnxsVw8839WBDXVhfCOhc3CrnC5fasXUwDg07meZFTdv/VgxVTguoHKY0pTUshpUnYhF9fTyHSltI/+l3BJyp2Whyl/psUMmV/MHCsXC+AhKbN2nNmaKRCiaEsGoVVbFZSojQFzQFl984JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=BZPAJHJPuxPJGUmiHuYXDqkvHIgT3luyN2815OvFnsU=;
 b=OQA/i1a9UCLqjAlWhvC5aOKWdByDRVcH696nzh/OpmWGOPzUweDDBsRH4yixbwZNbHOLfBwmR/aAi8HXb2s/3ztwXadpxQ+P+AVCMLCGGKFi7bKcEYrSiYHqpZkxH4r8+nkH/U5YGkctpfgC6CUEjihkt+8HLN4h07qdTfPx88O+5yYznWoCcaqkJsl7vE4dJMyJ9uLraput2UG+bEqcLHupKtppWCjQloBn/2GceqfOOd+34WyX6eub4CJZmHmJoBhPgCL2QIorgczG2/17t6Su0FZWw7wsc2comZ+DWuIrxGOTmbMoNlcPGy9FielrR1MVQ+wm3ZJdtDNC1KrtYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZPAJHJPuxPJGUmiHuYXDqkvHIgT3luyN2815OvFnsU=;
 b=QMAri3OjLqeoVuptlfP/UKJIyPnY8ZXqMBXur3E5AemKYYvEiwoZXjjk6iJsILc+urt0Xn0Tt1kj/11ZMcyEv+i9Ml5Y9dWkUf4O+FsiULRGrU+T0q3IUzOWD7+DeinFRgkXFxuzfq3ummgwHIb9y7GOAWxsy0iS9jBEQe+YNRy/1C6QNF03FsVmc6DXVR31NADEsQV6zsHCX67wFk7AGBpcD20kc/7StzC/P+qPGYSRsowFgdDjxbbTLnkkRPAtkAve0XpTK8Jnw+WZR6RhwjLNMG68wDmnhs1epuR0D9TNT4XvB2xLvKNPeg3JvM3BeY/RBPvgY0FRQCpzFo4LVA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB999481.namprd05.prod.outlook.com
 (2603:10b6:510:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 08:33:05 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 08:33:04 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
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
Thread-Index: AQHdbp1r/IUM1KiQW0u7BqizLWiRsbcoDEaAgAuFWAA=
Date: Wed, 18 Nov 2026 08:33:04 +0000
Message-ID: <20261118083302.1609502-1-x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com>
 <a4ec8431c2f36172348449b872faf26d7d6d4d7a.1794045010.git.x-professor@outlook.com>
 <20261109025114.433681-1-yangxiuwei@kylinos.cn>
 <20261110122434.4144043-1-x-professor@outlook.com>
 <20261111003655.3678579-1-yangxiuwei@kylinos.cn>
In-Reply-To: <20261111003655.3678579-1-yangxiuwei@kylinos.cn>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB999481:EE_
x-ms-office365-filtering-correlation-id: b68a3ebc-f2a8-41c9-86d5-08df454e90c1
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|25010399006|4140399003|38102599003|24121999003|22091999003|8060799015|8062599012|31061999003|19110799012|15080799012|3412199025|440099028|102099032|12091999003|52005399003|40105399003|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?a0pqUjh0Vk1LNVkva1JEYTFKM0ZWc3hJa0owL3pKRGdDV2E4SVE4T25LYnBw?=
 =?utf-8?B?M2ZWN21vQm5WZUZxVCtMeElXQ01hbnpReWtNQzFkTTJKMEYyZlhFZlcwZStB?=
 =?utf-8?B?cHFOSWpWK043b0V4RXNyTWRjN3hFMDBLYXBBTmRNZDdtMCtFekZVNnZkMzd4?=
 =?utf-8?B?VUtVajgvUEwzdXd2ZVBJcFRuZG9ob1p4QWEyVkN4TUQzRURMRlNZKzhhMjJF?=
 =?utf-8?B?VUJFZ0FnMm8wU2ZmeksvaEJBZ0hFQkFVYjhDOWk4bUpqd1lXajVubHhWWkgy?=
 =?utf-8?B?UEpCWEMvbTRKUFZZR0QyWmkra0hyRFVkVHJ5UGNRa3BSakxjRHJld0dVU2dH?=
 =?utf-8?B?YVZJdytPZXhkQS9DakVMNE9xUUkzbjVHUEh3ZTQ3bXhta0piQTVabkphVmht?=
 =?utf-8?B?M1dWWEpqRjJvdzYwNHVWVkRGeHR0RGU5Z29mcFZtUFh3RUlubjVTb1pBZ2la?=
 =?utf-8?B?eHVRY2lnUHBkK29SVmdSd2JrRkx5RzEwekh0U1R2b2MxaHNBQlNwMDJ6aHFH?=
 =?utf-8?B?dUxyaEJQZzNXMjN1SFQvVVhFT1BwaGtsZldlc1NSWEM5NzIwVnpWb3l2aExF?=
 =?utf-8?B?aEg3S0EvMkRocHJXRmQ0Wi9jTitzRlJ1OCtKZGk0OWxMU05WYzI2M2kvQ25m?=
 =?utf-8?B?ZVRmUmtPU21oWThGZGp5YTNWUjFuT2FhL2daOGsvejVBNWUzSlpLRkI2VFUv?=
 =?utf-8?B?TXp6aU85YTFLR0lDOTFBZ2t3RnBOM2tQcFF4aG5Jd3E4QVdJYnBRbkNWSHpy?=
 =?utf-8?B?aDUwcnJERGV5MHpiMnJ0dlBIVm9lVDY4T250bmhLbU5LZTVuYmxzci9FTngr?=
 =?utf-8?B?VEh0WEZKRDNVRnh1eHN5SUVXa2x6TkxENGI3bjc1UEloTnR2QnpWODFpNUdh?=
 =?utf-8?B?dHR6S2Uwd3dONzVKbkFuRWs4dUZ1ZDFTTTRhL3JrMS9mem1kL3ZrbnZla0tW?=
 =?utf-8?B?Q3NwVDNadjMwdnBSblJ6b0l6dmpsRlMxTk9hZ3Z3dTYxRWxQdkZ5VFBqTm9E?=
 =?utf-8?B?bVo2L0hCc2V2bWpjdmMveEJDZlJOYnZ2VCtSNVE5K3Rsa1lIOUpyUHJEaHEx?=
 =?utf-8?B?OFZkYXZCRE1ZSXJDNWMyZjlSN3hjQWZPOG1GWWRqWmVRcGFRa2cxN2l3aWVl?=
 =?utf-8?B?bnRTa3IvZWdKS3U2VE12WjZ2YU5zWko4SjRpVnQ4UFB0QVgzQTJCekEyODVq?=
 =?utf-8?B?VWd0UGdkbldybnpkRTh1YUFyU1hyQUxQUWN1TlUvVTVnZ3ZZUTZwU2xiZkJW?=
 =?utf-8?B?RFlUdnUyQlBjcEpENWF0NG84amlIU3lGNnRFUjEvVEU3THE5U05SQXpkQUFC?=
 =?utf-8?B?RHRSZzZaZThubDhMcFZnWVRLeFZ3czd3RWxjUklzU05ibzRETHZ3bVhoYWRQ?=
 =?utf-8?B?cFQ4dE9takJndmVEUDBsK05xWUxydEh6OVBCWmVJd1FnQ3RDb3MyWjhHb3kz?=
 =?utf-8?B?NnJqZFdLVkNzNHZtTG90MExZc1FZQ1ZxdGRqOEFnTnFmQ3hSNEpLU3FKczlN?=
 =?utf-8?Q?qAxMrc=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?em9ZREJuV1NNdCt2MjUzUC81WHdCa2FEZmpNS0xSNFA3a0VpNTdPOW11TGpn?=
 =?utf-8?B?UTNTYmlEcjEwTTJpcTVHSE1iaFlRZDJnZlo2L1ZuUUg2eUx0UTZmUkhqRW9o?=
 =?utf-8?B?S3lpcm9pN0ZEdmNkZGZnTjdMbHk2dE9EazVCeWJnOHJLOC9wYVgrQ2JJWG9S?=
 =?utf-8?B?ekZkZlJHV05mRmNoWmc3TWxwdDkyYzdBVkpSbjRuay9qZWpidEdoVFlJT3JW?=
 =?utf-8?B?TXk3MWV5WlVDOHV0T3R5Y3p2QnVJN3VUb1dlanV1Z3d5ZzZ5NVBKMG5WRXpr?=
 =?utf-8?B?ZUg5d1ZDTmljdDNPWFBvR0prU0lCWGdVWVlSbVRQbHVoUzd5Q3JFMExXaGRa?=
 =?utf-8?B?QTFIeEJ5UDhhQzF1M09pZjhnaklob2ZDWkNyaXJqaUJRTEMzeWFLNDU4RDNn?=
 =?utf-8?B?eWpML1NKNjlhWUNQVHc4bVRVKzU2ZURSTGZ6bGV2dTNOSnhYZGJ6Wmd6Tno5?=
 =?utf-8?B?cmRUSEZGZmhBQVBMMnFNTmN1RnhwVGM2Vmc0K3ZlK1kxNVp4R0J4Tk1YZWdY?=
 =?utf-8?B?cXZMcVpaK3BJQjFGTXNoaStwVXoxSkNFOVlqR2QxUlpEV0lad09nOXlmMWt4?=
 =?utf-8?B?NEFEdjJuQVg2YUovbVhJMmNzdGM1MHJyaEIyYWxNSVArNGl1S1Z2YnI1ZXFF?=
 =?utf-8?B?LzFwOWY4dzRrS2tQR3ZSdi8xTkpJYXVydUk4anhINmhOSjl2N253U0JrNVVC?=
 =?utf-8?B?L1hUbW1FT0RNaDdJNExoNERHNkxDb3NxVmloT20xTnVZcGtOQVVzQnU0YlQ5?=
 =?utf-8?B?eUJnYWJLTTQxeWRWU2dnekdvRVBvbUFwUmFFbjFUZFlJL1gzTWp0Sjhwck01?=
 =?utf-8?B?NDlGOVl2T2lCblFYSnFlZ0tQYWJJaGdiQnBkak9nekZzdSttMHBBdUdpeCs5?=
 =?utf-8?B?bmw3cmNwRGdmejhUTmZsRWRJR0dKR2pBbW83UUp3SGV0VmZXQTJiL3Rqd2wv?=
 =?utf-8?B?NjFqSVgzbGxRR05OQXNpRU51S2xNUDl5QmdxamRzU3BZR3B1N3JZUzg2Y0kw?=
 =?utf-8?B?VmpoMzNuM1JFaXNxZnFRclY5VkNCcFMwYmlOTVZnOGZiTlhvY0lvckJGM213?=
 =?utf-8?B?eFNLb3puOFBkN0Q1Kzg1ZGo1a2VTQUUyY3ZUTGZDeFZGMVJCbXhaT3FqS0x6?=
 =?utf-8?B?VGI0ZlBXSHZUNmJLb3NvOXlMVDBQT2xCL1NEN3VaSjExZENMY21TOTZUU1Vq?=
 =?utf-8?B?MVZIY3NUbXVMcWROdnFQRWtLc29KK3RtVWhnM0FkeFMxWWhoRStRRE1hSTRo?=
 =?utf-8?B?UzVyL0ZING5LQmJjdkwydklrWFZLcHhpaFZjY2pyV0xPSDlVZk1VWDVmT3V0?=
 =?utf-8?B?ZFBaWG9CRmdsbXRReityekN6T2x5azc1b1FXU25LRlo1UWNJNFZmeGZHbUFy?=
 =?utf-8?B?MUpkT0Q0Zks5NjNYQVFtODR1MWh4eld3dFpMbFhtWWlQdFBqeVVIZjVxNHht?=
 =?utf-8?B?ZzRoUFdZZFN3ZDdGOTZ1emRqek5zVXZDR1NKZ1Y3Rm5kaTh6WGt1R0N3Y1g0?=
 =?utf-8?B?dUdqa0JIWFBKQ3JnMDdGTi9IM3ZScjk4Z3NVTTY4elEzOHNqME9uYnZPc1hN?=
 =?utf-8?B?RlVCaU14SnZHSnFBK3pNTVlTVEZnZGE4a1RKSVhqRmt3d1FGT1AzQ3JLa05D?=
 =?utf-8?B?KzZyVGhFSU9tZnhlL0tXUzNQcEVMVnBGdkc0ZkRsemNXREhUbmZqV1pORjNi?=
 =?utf-8?B?SzJ0MHhIQ3k3cndrZ1E0c2JWZ0x1Y1dvTWVkZlFDdThldnhkeW1HUmlpdk40?=
 =?utf-8?B?UnVTU2tSV20zUnFwWVBKeXBCNmNZY3JuM3RwTmNkam0yUUpmZDB6d2Jhc1Vu?=
 =?utf-8?B?TDhmRTJhNGtVWUlQSmFjQW1MUmZLTGNtblFINlNrQ1duY3prOS9CakR6eXVQ?=
 =?utf-8?Q?nefcIiR1ADEv6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F16B8566C450944C8AC8C459163AA710@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b68a3ebc-f2a8-41c9-86d5-08df454e90c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 08:33:04.7940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB999481

SGkgWWFuZywKCk9uIFdlZCwgMTEgTm92IDIwMjYsIFlhbmcgWGl1d2VpIHdyb3RlOgo+IE5vdCB0
aGUgcmVxdWVzdCBvciB0aGUgdGFnLiBBIGJ1ZmZlciBvd25lZCBieSBic2csIGZyZWVkIGZyb20g
dGFzawo+IHdvcmsgYWZ0ZXIgdGhlIGNvcHkuIFBlci1maWxlIG9yIHBlci1xdWV1ZSBib3RoIHdv
cmsuCgpUaGFua3MsIHRoYXQgaXMgc2ltcGxlci4gSSdtIGRyb3BwaW5nIHRoaXMgcGF0Y2g7IEkn
dmUgcmV3b3JrZWQgdGhlIGJzZwpzaWRlIHRvIHVzZSBhIHBlci1maWxlIGNvbXBsZXRpb24gYnVm
ZmVyIHBvb2wsIGFsbG9jYXRlZCBhdCBvcGVuKCksCndpdGggLUVBR0FJTiBvbiBleGhhdXN0aW9u
LiBUaGlzIGF2b2lkcyBhbGxvY2F0aW5nIGNvbXBsZXRpb24gYnVmZmVycwpvciB3YWl0aW5nIGZv
ciBhIGZyZWUgb25lIGluIHRoZSBJL08gcGF0aC4gQSBwZXItZmlsZSBwb29sIGtlZXBzIG9uZQpv
cGVuZXIgZnJvbSBleGhhdXN0aW5nIHRoZSBjb21wbGV0aW9uIGJ1ZmZlcnMgYXZhaWxhYmxlIHRv
IG90aGVyCm9wZW5lcnMuCgpKZW5zLCBQYXZlbDogdGhpcyBwYXRjaCBpcyB3aXRoZHJhd24sIHNv
IGl0IG5lZWRzIG5vIHJ1bGluZyBmcm9tIHRoZQppb191cmluZyBzaWRlLgoKUGF0Y2hlcyAxLTQg
b2YgdGhpcyBzZXJpZXMgd2lsbCBiZSBwb3N0ZWQgb24gdGhlaXIgb3duLCBhbmQgdGhlCnJld29y
a2VkIGJzZyBwYXRjaGVzIGFzIGEgc2VwYXJhdGUgdjQuCgpUaGFua3MsCllpbmdqaWUK
