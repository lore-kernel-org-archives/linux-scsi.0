Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013004.outbound.protection.outlook.com [52.101.127.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9E53290B7;
	Mon, 14 Sep 2026 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367930; cv=fail; b=boSQMtRtMwEs3ZKO5qHZcwUBwS1gzPaclYjKq3bMUYR8sZHba0tNbqaEQjABINiwVQaBFE6yUFXnp2H951ecO40ydB7bdcIfNyYevwik/irwk+6fRrd8i9L9MT4LVqQVlgyqplwENkp2Zcv5V0v0IgFyxV5ebGwNOJbk0O/pCZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367930; c=relaxed/simple;
	bh=9J97DsYIfj0aG0N3ZZiKIw4GQ3aOiGriVoUQgbE5ZLo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U7DBS6joIv9wlsME2XoFd+cVpfAbnEfbWrehQaGRr+kTqFkClPwf+pZ6hCLEY9KbW60SkMLQAK8xqimxgCkrgL2iOgphcIihkOZMlQRAZUdfrfqBK2oyDFzBaIjC0l1NY8r3b5KG8mr62eCmQMCPA5x7JKuWRj12hgFYMDEalbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=YKnN0jxF; arc=fail smtp.client-ip=52.101.127.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="YKnN0jxF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X5hPRffd+Tzj5VCEAcAvIcrhXte9thW7acOjcV4YieUVLtdSRucajQ8vB849LeRZH0CI+bqiTrljJ84aJrqc1vHhfXCHnh3zDhajoHUx/aQH5+MtrcxIYpUrK33qDRXIZXYFZ12jMfKTdPlr4QLElrTXckaeygDOEyXhsbB2Gy7VnMCaGNB8KwwAzasjrc2TEfNKo5h2iZHaqdK86YTpUz7WTPdEJgtQIq4joz5oPMZIuckiGQEarkKV48kTE4ItdIz6HFtld8Rl2w4dx0mbQUFEYYCfYR7Paawoq1L29yVx692qU2OqXL2tDga//2idxznH8r6fyW7bqNvM1OLXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9J97DsYIfj0aG0N3ZZiKIw4GQ3aOiGriVoUQgbE5ZLo=;
 b=KqiNC1zXQtdIrYwxpDPE9KCM0a+2kR+H/96IDQ5AyactQXao1d6+GHOGuqa1paF1JwoLYmwvKaYP9fqZAo0eCu4OKitakPr5EPMcCuFrYt+S1Vz94jOpw9sSAnaDNtWLUoYRkDvCDfVBBPMDrlg/lTTvBV6hjgGPyIYkWxGWa041z5E5Pe9iHNIgyzua2N8k8FxBP7jmQbrWSZ90Fq8RpPE+Fx6l/s64gpCT2jLlj4r1OkFbM07fi+vRMUsQlMoflaigin22sfytjfvr/isu0bP3Yp2LN/2uSRNACh3WV/P97CZNymb5FCCPQQB0vswtmoHjOKgiEjwErsptG46z9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9J97DsYIfj0aG0N3ZZiKIw4GQ3aOiGriVoUQgbE5ZLo=;
 b=YKnN0jxF7D5qMPgHoDNVDhKkCcIztKkWK0Z93fzuh+yEBMZtiRjKco44m/wdbUjJV40T3dEbUsCtynfSEDHCvp7X2rZaeOOJLOd5mN96MwbaWvgk7XqJ/SHV5gNND2q4ok9YB/Wxi7gvFPnWnXz7BWR1afeYvVIId3GW2aLy6se0prG+skWZn2xcxXFN9zToYQJBIdMMcC0x12HLgresQZXgjeXzhtHHXWc0Kfa0x0q0Gd0orc9XyTZT74JkVAVGGCiRNB2SNd0WYc8uZMnuEqGBPkFDbdjSvHCuXRoGzr/DXGDFBYH7FnNz7E7crmWmDNd7W2Co9yQ+bVP/ggq/MA==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by PUZPR06MB6188.apcprd06.prod.outlook.com (2603:1096:301:116::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 06:38:42 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 06:38:42 +0000
From: =?gb2312?B?uvrBrMfa?= <hulianqin@vivo.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>
CC: "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de"
	<hch@lst.de>
Subject:
 =?gb2312?B?tPC4tDogW1BBVENIIHYzXSBzY3NpOiBzZDogbWFyayBkaXNrIGRlYWQgb24g?=
 =?gb2312?Q?surprise_host_removal_to_avoid_I/O_hang?=
Thread-Topic: [PATCH v3] scsi: sd: mark disk dead on surprise host removal to
 avoid I/O hang
Thread-Index: Ad0498L2lTsPnQZSRp243d53DEDriQLGuf/w
Date: Mon, 14 Sep 2026 06:38:41 +0000
Message-ID:
 <TYUPR06MB6217DE2CF920F158B36243C0D2BB2@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <TYUPR06MB62177178F9305DF5C1A7D046D2A92@TYUPR06MB6217.apcprd06.prod.outlook.com>
In-Reply-To:
 <TYUPR06MB62177178F9305DF5C1A7D046D2A92@TYUPR06MB6217.apcprd06.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|PUZPR06MB6188:EE_
x-ms-office365-filtering-correlation-id: c0200af3-bc27-4796-83c2-08df122ad154
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|42112799006|38070700021|5023799004|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003;
x-microsoft-antispam-message-info:
 CHTzIEUH0IFmFfHvq+wLk/5QufHA0LUHhXqdTpLcJaWkH97dvEsg4G68F3tyOSH4eg3zf1eErrK4N6U/lnLEFXKFES00ETJUbu4Y5ukPQCDFcugISAYp1+VUr8TJlmVPBbG4C4XT51iH5HRLG6AO5LvOBsjAyWTe+FUv6viNk5giNG8AXfTrsbnMIn7p80LljatM9W4QL0wcdBfcIDt2R9jCZHJyzAhIJGGksoOKG3Qp/LmKJgptphGmXpmDoxoZtk/Oz416cjlqoHObQvY6x4BdYZQGNJbPTjHBpCR8TyoG3Z+m7BnIpFEn9EijGOlAWl8NOZINszlQDSurAmJT/jqLMJb2Q9DXNOSaKDVGAjUrY3Wavi/EURbahcv5QHsCMqA0dHcFtSy8A+SlsXtoc+gFrZ+5sXs7R/ddfEN2ouoQ4k2nqZBnYjUr1qHhaSbYi4rE6BxUnrxRsVPSf2FaMWm6Yrnzic00fthywvyncgRm5KPTEWWc0hxcUV1ZepS2chc35+7ABd5X1BMw1FtTynysTG7HYNVFdlW7Rvk7olat9yJjFFOq68u0jeMgG+MvIQgyhnIMtMqaWP21003DhykYXhHuu9zEqYqNim1ggpN35qTXlsDAZmquxkpYKlvGLEVFmH93N9jKFF9qv2/KAYDttGNx/PKwb8aeN7TwMTTjvonoJrmUYz6yBJZ+JTp+YbzoalJEGHBFSRuTPy0Hf10D7CC+V6A3d0jfn8x4COA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(42112799006)(38070700021)(5023799004)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?MUlEU29HS0hvM2NqanRhdkExU1RYdzZWOXBQWjVxTDJuSUxRNE9FK0tSRUgz?=
 =?gb2312?B?ZUtLRUlhMnhCK2IzODJoa1ZZTGVxRXoxYWZEVEtocW1rNTk3RHdBMzJVYTNj?=
 =?gb2312?B?QS82RjR6KzVHMC9IM3dubm5NbTcybU5vdENnR04xQkhRM1BiNXZkaDgzejhB?=
 =?gb2312?B?d2p3ZkJnU2IvVFVXQVY5TWd0YTRoQ0xFdW93ck43ZVRCMEtveUlsWHl6Q3Q3?=
 =?gb2312?B?bTd5a1E5cWROY0xxVVArYkxGMklBaUIwdmpXWlNXY0RFc2FSbVkwelJneVY4?=
 =?gb2312?B?VmtUeWNtNDBubjBocXJCby9uNVhKVzNMSVVMejk3Y3RUY3hTc1V4bmV6VHBY?=
 =?gb2312?B?eUR5VzdKdmpHTDdvb2RVSU9JUGthQUY2Ym5PQU1NdlhidHlWM0xpZSszZDNF?=
 =?gb2312?B?UzhwUlQwSHFxSUxPa2k3WDA1ZncyVmJtNWNGUVZJWVZPZ3BXYmFjeHY0UGtG?=
 =?gb2312?B?L05HOHZBeFFDdzA3MEE3Y0NISUhBUTlXVkxWZkJjZy9VVlFZOG5xWGtjM1NT?=
 =?gb2312?B?aXA1WWZVTjdNam0rdDJub0VvNmpZS1Z1M3d0VE8zd1lUakI3MCtIQ01YUkpo?=
 =?gb2312?B?UFVadnRwZ3B5WWRpT1pDVVpJclFWSlJvZE1leStyVk0wVDFSN2R5ME9oeXow?=
 =?gb2312?B?dHRyMlFmSjMwWmt3ckI4UFVMRFB2aHRnVlJha3NBUmhNNU5DSWJvZTRmbGJS?=
 =?gb2312?B?M0tRZXJidzZWRUEwek9sUUwrSk9HbkJCQ0RCRS9NdGV2QXhPc0FvajlCdFJM?=
 =?gb2312?B?MWorSWlYMk15UjhtcmNUdHZVMDgrRGtlRHQvWGVlbDZaeFBLeHVUa3JxbTNj?=
 =?gb2312?B?RlNaZ21IalBLR1ZMSUNFRkREZk5ZMmFhMVZ4Q2dicWxrd3JUL2Q5VFIrRnBK?=
 =?gb2312?B?Z3Y5eUkzQ1R2aHZJYk9JSGZ6OVprMHlPTVQxNENKMWJCbURWdFZQOHU2Q1dS?=
 =?gb2312?B?NkZvVWtxZ1lZd3d0cUFlWFhJR0x5MDQ0ZU5YTTg3VTl4b2RCTndzY2xMNzF6?=
 =?gb2312?B?b0xlSkhOTjgxaWVJU3RNTmd5bUJQUS9qdlJHVzc5cTh6dXUvcWhnQysxYTZv?=
 =?gb2312?B?QXhYajR3WXQ5QjFQa1hyb1pPMzhzZlZQd2VUckJrcmc0L2FnakNTakJWMmpM?=
 =?gb2312?B?YjZRVEk3VW9SMkR2YlpGY0UwaHFkZVorTkYxcXhKRGlwUFVsQkVlb3lIMmVw?=
 =?gb2312?B?NktCQi84U2QrMWsrYlRRdTdWQjN0MGZCcks5WmJSUG9GNnpBVUhweGpmTHgr?=
 =?gb2312?B?SU11UFZVc0wwUG9GcnJNbkdINkVlaFNoTXFSdTRjMERzcnBsMXoyNjJEZk1I?=
 =?gb2312?B?MSszdXg5bDZ6Ykh0alR6NkJXbVlac29KOFBlZDB1ZWU3U2lZQ3dVRXJleU9O?=
 =?gb2312?B?WWZIVmxQYjZTYWVwQXhnNFZQQkxldWd5K2lST2toVmlMd2VyV09yY3p2YWdY?=
 =?gb2312?B?cDdYRHRLTUdISXE2cWhkT3dTTHBoUTN1QjRxUkhmZzUwU0V5ZjBWeTVYRmg1?=
 =?gb2312?B?UEE2TzRtVklJa3hVQlRtMTd5dEs1K3R5bEJlcjhNdWZraTN1ejBVd2dWUHlL?=
 =?gb2312?B?eEN0d2VmYm9BNk1IWmJ5cEJDZzdtMThIUEQ3cnl1Y0gyRno2LzQzcVF0MkVI?=
 =?gb2312?B?eU0vL08reXpvekxtYWg3T2dXVklCaGExVVd1SnAwVUViZ1ZJSlhiYm1PSXB2?=
 =?gb2312?B?aTk1ZUx4YUlYR2Y2dElWdW9ENXZaZUYyZFZsbU85Zjg1dmRBMXN4eVV6M3dj?=
 =?gb2312?B?TG83V3hMMGpYS3Z3UWZGN2hSQzZKbjI0cVU5Q1poNDBvb0ZuZHNnaUkwS2VK?=
 =?gb2312?B?b1R2akJDc3lOa0VFY0hSNGJhUmZ6RFluNXBrZmxhYm1VYWRmZDNEL210K2gr?=
 =?gb2312?B?dWQ2WUt4UnhmdzFmaFcvbTJSS1BhZlM2YjR4YkxEUWhHbmRxVWthSzlERld4?=
 =?gb2312?B?TFpjTjN3TGxXVWMyVHp0NFliNEVDMmN0eDF5RGJBeWhoUitNenBEQ05DODRI?=
 =?gb2312?B?Mm1BYWxvOWt2aGZ4SmY2Zko5ajRJTk5yekNGMWwrMmMvSlNqQk5TSGVZK0xs?=
 =?gb2312?B?dUpWM2Z1TERlUXQrRXZiVU5QSkRBMDcrd0hQN1ZFdlBQVVNuaUlaZkdhNG5E?=
 =?gb2312?B?ZTc0Z0Mramd4bUF1RWV6VWdKQ25JZUhDUzZKTkI0eDF6QTZjVTBtOStKdXBv?=
 =?gb2312?B?V3U0WnJsR0F3RGtuQjNQczNuUkRrdEdDOU5Cak9LRGtjK0J4elNJY3VFRE5m?=
 =?gb2312?B?M004V3ZWeENMSkgyNzUwdGhFZ3ZmbFo4c002aVNmNDlwak1MZ2o3WWVmeStE?=
 =?gb2312?Q?dcVYmEG29wFHs4t3I5?=
Content-Type: text/plain; charset="gb2312"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c0200af3-bc27-4796-83c2-08df122ad154
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2026 06:38:41.9560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8VsBDs5IYqRpUSJ7RwpXvVTKIxFcP2jRufbw2bsr2Aewe5bxRHbyWjttDxAu8w24xa2rVMzNG0hIux0i58jl1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6188

PiAgZHJpdmVycy9zY3NpL3NkLmMgICAgICAgIHwgMTAgKysrKysrKysrKw0KPiAgaW5jbHVkZS9z
Y3NpL3Njc2lfaG9zdC5oIHwgIDggKysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTggaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZC5jIGIvZHJpdmVy
cy9zY3NpL3NkLmMNCj4gaW5kZXggNTk5ZTc1ZjMzMzM0Li5mYjUwODY0NjVhMjMgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvc2NzaS9zZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zZC5jDQo+IEBA
IC00MjU3LDYgKzQyNTcsMTYgQEAgc3RhdGljIHZvaWQgc2RfcmVtb3ZlKHN0cnVjdCBzY3NpX2Rl
dmljZSAqc2RwKQ0KPiANCj4gIAlzY3NpX2F1dG9wbV9nZXRfZGV2aWNlKHNka3AtPmRldmljZSk7
DQo+IA0KPiArCS8qDQo+ICsJICogSWYgdGhlIGhvc3QgaXMgYmVpbmcgdG9ybiBkb3duIChlLmcu
IFVTQiBzdXJwcmlzZSByZW1vdmFsKSwNCj4gKwkgKiB0aGUgZGV2aWNlIGNhbm5vdCBoYW5kbGUg
SS9PIGFueW1vcmUuDQo+ICsJICogTWFyayB0aGUgZGlzayBkZWFkIGJlZm9yZSBkZWxfZ2VuZGlz
aygpIHNvIHRoYXQgbmV3IEkvTyBpcw0KPiArCSAqIHJlamVjdGVkIGltbWVkaWF0ZWx5IGFuZCBz
eW5jX2ZpbGVzeXN0ZW0oKSBpbiBkZWxfZ2VuZGlzaygpDQo+ICsJICogaXMgc2tpcHBlZCwgYXZv
aWRpbmcgYSBoYW5nIHdhaXRpbmcgZm9yIEkvTyB0aGF0IGNhbiBuZXZlcg0KPiArCSAqIGNvbXBs
ZXRlLg0KPiArCSAqLw0KPiArCWlmIChzY3NpX2hvc3RfaW5fY2FuY2VsKHNka3AtPmRldmljZS0+
aG9zdCkpDQo+ICsJCWJsa19tYXJrX2Rpc2tfZGVhZChzZGtwLT5kaXNrKTsNCj4gIAlkZXZpY2Vf
ZGVsKCZzZGtwLT5kaXNrX2Rldik7DQo+ICAJZGVsX2dlbmRpc2soc2RrcC0+ZGlzayk7DQo+ICAJ
aWYgKCFzZGtwLT5zdXNwZW5kZWQpDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3Njc2kvc2NzaV9o
b3N0LmggYi9pbmNsdWRlL3Njc2kvc2NzaV9ob3N0LmgNCj4gaW5kZXggZjZiMjg2ZmE1OWYyLi4w
MzUyM2FkMzI4NGQgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvc2NzaS9zY3NpX2hvc3QuaA0KPiAr
KysgYi9pbmNsdWRlL3Njc2kvc2NzaV9ob3N0LmgNCj4gQEAgLTc5Niw2ICs3OTYsMTQgQEAgc3Rh
dGljIGlubGluZSBpbnQgc2NzaV9ob3N0X2luX3JlY292ZXJ5KHN0cnVjdCBTY3NpX0hvc3QgKnNo
b3N0KQ0KPiAgCQlzaG9zdC0+dG1mX2luX3Byb2dyZXNzOw0KPiAgfQ0KPiANCj4gK3N0YXRpYyBp
bmxpbmUgYm9vbCBzY3NpX2hvc3RfaW5fY2FuY2VsKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0KQ0K
PiArew0KPiArCWVudW0gc2NzaV9ob3N0X3N0YXRlIHN0YXRlID0gc2NzaV9nZXRfaG9zdF9zdGF0
ZShzaG9zdCk7DQo+ICsNCj4gKwlyZXR1cm4gc3RhdGUgPT0gU0hPU1RfQ0FOQ0VMIHx8DQo+ICsJ
CXN0YXRlID09IFNIT1NUX0NBTkNFTF9SRUNPVkVSWTsNCj4gK30NCj4gKw0KPiAgZXh0ZXJuIGlu
dCBzY3NpX3F1ZXVlX3dvcmsoc3RydWN0IFNjc2lfSG9zdCAqLCBzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
Kik7DQo+ICBleHRlcm4gdm9pZCBzY3NpX2ZsdXNoX3dvcmsoc3RydWN0IFNjc2lfSG9zdCAqKTsN
Cj4gDQo+IC0tDQo+IDIuMzkuMA0KDQoNCkZyaWVuZGx5IHBpbmcuDQoNClRoZSBibG9jayBjb3Vu
dGVycGFydCBvZiB0aGlzIGZpeCBoYXMgYmVlbiBtZXJnZWQgYXMgN2U5YTQ2MDA0YjQ3DQooImJs
b2NrOiBzZXQgUVVFVUVfRkxBR19EWUlORyB1bmNvbmRpdGlvbmFsbHkgaW4gYmxrX21hcmtfZGlz
a19kZWFkKCkiKQ0KdmlhIEplbnMnIHRyZWUsIHdpdGggUmV2aWV3ZWQtYnkgZnJvbSBDaHJpc3Rv
cGguDQoNCkhvd2V2ZXIsIHRoaXMgU0NTSSBwYXJ0IGlzIHN0aWxsIG5lZWRlZCB0byBmdWxseSBm
aXggdGhlIGhhbmcuDQpXaXRob3V0IGl0LCBzZF9yZW1vdmUoKSBjYWxscyBkZWxfZ2VuZGlzaygp
IGRpcmVjdGx5LCB3aGljaCBpbnZva2VzDQpibGtfcmVwb3J0X2Rpc2tfZGVhZChkaXNrLCBmYWxz
ZSkgoaogd2hlcmUgc3VycHJpc2UgaXMgZmFsc2UgoaogYmVmb3JlDQpHRF9ERUFEIGlzIGV2ZXIg
c2V0LiBUaGlzIHJlYWNoZXMgZnNfYmRldl9tYXJrX2RlYWQoKSCh+g0Kc3luY19maWxlc3lzdGVt
KCkgofogX19iaW9fcXVldWVfZW50ZXIoKSBhbmQgYmxvY2tzIGluZGVmaW5pdGVseSwNCnNpbmNl
IFFVRVVFX0ZMQUdfRFlJTkcgaXMgbm90IHlldCBzZXQgYXQgdGhhdCBwb2ludC4NCg0KVGhpcyBw
YXRjaCBjYWxscyBibGtfbWFya19kaXNrX2RlYWQoKSBiZWZvcmUgZGVsX2dlbmRpc2soKSB3aGVu
IHRoZQ0KaG9zdCBpcyBpbiBTSE9TVF9DQU5DRUwgLyBTSE9TVF9DQU5DRUxfUkVDT1ZFUlksIHNv
IHRoYXQgR0RfREVBRA0KYW5kIFFVRVVFX0ZMQUdfRFlJTkcgYXJlIHNldCBlYXJseSBhbmQgZGVs
X2dlbmRpc2soKSBza2lwcyB0aGUNCmJsa19yZXBvcnRfZGlza19kZWFkKGRpc2ssIGZhbHNlKSBj
YWxsIGVudGlyZWx5IKGqIG1hdGNoaW5nIHRoZSBOVk1lDQpzdXJwcmlzZSByZW1vdmFsIGJlaGF2
aW9yLg0KDQpCYXJ0LCBzaW5jZSB5b3UgcmVjZW50bHkgdG91Y2hlZCBzY3NpX2hvc3QuaCAoNGM0
NjFlZTJiMmE1KSwgY291bGQNCnlvdSB0YWtlIGEgbG9vaz8NCg0KVGhlIHBhdGNoIHN0aWxsIGFw
cGxpZXMgY2xlYW5seSBvbiB0b3Agb2YgY3VycmVudCBsaW51eC1uZXh0IChvbmx5DQpjb250ZXh0
IGxpbmUgb2Zmc2V0cykuDQoNClRoYW5rcyBmb3IgeW91ciB0aW1lLg0KDQoNCg0K
