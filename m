Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazolkn19012052.outbound.protection.outlook.com [52.103.20.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDC443E079;
	Mon, 19 Oct 2026 06:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792391543; cv=fail; b=rZevZq8MbuA19aaVi7+S2VZgvabUFW+X4MgZUthImGrp0xbmm2yhywK5MlIlEOiFSKW69Jyh8dyw7AOr2dvRW+RQ8PArYqXzSv4Zd6rLARUQJvQGVtSnhV479P6/J2IIa6TuGCJ4tWcjsaTifibjaON0Zw6z7/7BBpC1t0ZGQ0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792391543; c=relaxed/simple;
	bh=Ho8+EihAYAWrwcGBXxqpm0OQq5sIFVNHndU0khsjD1c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YGMJ2uxyOPzTtAN7s5nLESstB+r4LuyD12+lgwODKVNPBtCRk8RtkDdlpgMfluLxBMvY546uy1b1x7Lt+dqXLml5jRLgp/QtKWvAveJf2PJfSTgCxiFZRu5jKkDvFSKqVqWQ6IJ6y+wOS5rcgh2srcFtSo+GKfH6N9qXeWBqkoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=RvWf2jgT; arc=fail smtp.client-ip=52.103.20.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="RvWf2jgT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=To/NkNbVvIonbxGZ8bimzGYNW56C4bF0gx3EBPeMjAvlVN/4JfTPxUrAXddrn9Uqk6bl2n8bBxlp+D1nl8Ga8BTMrL9DYUwVTq6obo2U5j8YPwy19r5xLRjjD4lK7MFa+e13bsxS3H6XPJvXuyGbLLcyEGDtAPBViiWUTJtQWn5N1yxIGkt650JNsEuvPPlEcfFPCwHGXhNbzkOg/xvXIdk3pxWL3F+WXOfbM7VVfVjIgZ+TXRgS91Xn9NniJNH82+OoXJHReGOHgMlD8X9YQ/uXILR1971Pa58KqvOM3fK7QOOcRB/JdpWV15TKsjc/U2vAtKo5bbXJsVXwoGWvjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=Ho8+EihAYAWrwcGBXxqpm0OQq5sIFVNHndU0khsjD1c=;
 b=S1nyFe5O53WIfABJNVevCiY5g4vWqgZXwKpGyzfu1XkVzO0XbsjmT3fIxCVjfW7cZRWqs4tvu62ft9ESoab68J/Jyn2OaShUSo5G9K/oTUC5Wfh0SXFDNjlj9ggMZLW2gYLTNVQmvfPbaqm4mHwaUQPkOCriUHGOaw+JwF+3O2eHdFDcbcZQpdh/2gk8Vz4eDWXEGbr8PJNxJZOaKYsx5s/LhjgU9WSiynJPr3NiDC4cauJdHuaGSfPzqcxhxU+8PncBkjvl1dNp7U+hS3C443RiXU5VXcFrBtZUQvy8MjJ+yKkP96oTfh4gZBN6Ft3wofNhNmroK/VjtHwMvNbQpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho8+EihAYAWrwcGBXxqpm0OQq5sIFVNHndU0khsjD1c=;
 b=RvWf2jgT+N/C3kYYAiQBm+yoC9q/gtyrontOFNWB5A4nXw4GekW9TN30dIheIMq0WPr4I68QWQLHg4GxmAr7PiP+jIl4ktUhdFuC1U7SF3fUSvm78IeH0fUaorQjCe/HYKQdVynZWkWIvz+X+Wzp0ev+N4nin83BwOYCOuiAbIAZagjW4ioRgcLsPottOeeAcwzHjR0mE+CocTCZUMN+ZTJ3wO/6iCFXjWwoQHvqwLvVkqL2I02gKjL7VDeb0F8k4hn7Sb58fa7nPG/gFBQ4T72uKHffK9rJIDcuqC4LudtPLHNEyZcLeZmS7KFEmRNOFlo5+nf2OyhEIaVrNjKflA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SA1PR05MB8326.namprd05.prod.outlook.com
 (2603:10b6:806:1d1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Mon, 19 Oct
 2026 06:32:19 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 06:32:19 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] scsi: make SG_IO user copyback failure-safe
Thread-Topic: [PATCH 0/6] scsi: make SG_IO user copyback failure-safe
Thread-Index: AQHdXxcV4d7XNHMimUKXaFSWzkcXt7cDgMwAgADoMYA=
Date: Mon, 19 Oct 2026 06:32:19 +0000
Message-ID: <20261019.scsi-copyback.9d2bf936038d@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
 <cc4cb53d-51e4-472c-8e4f-6243100198d2@acm.org>
In-Reply-To: <cc4cb53d-51e4-472c-8e4f-6243100198d2@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA1PR05MB8326:EE_
x-ms-office365-filtering-correlation-id: c17921cb-f5d5-4ef3-edba-08df2daab9b6
x-ms-exchange-slblob-mailprops:
 YfhX3sd/0TWTq462A1ci1xfPBdi3ebdld6AwI0oSZX2bfd/zJ5AkFNwqO62EkDZYyvxjCrz40IG9GFwMMQ/DWxs/CFDTBrbinPT1pwUkF0LaVU7WT+++NVweXRgiCxkyAVF+HPEnDd0KuxNB5udZ4G9jAuo9vvi+JG9lDDDTDFkldfFLAU9hmqeJQtSIzkBQPqcGKz8f62Wm8IGg08NdZAzBHhkOi4DKiDfDg0dIOfeZV+F8xVrjwpCbR8YonIrSmTklnjTMVFqTvCqkX0UCRddq3acit2IueHhc0RErB8P/yXx1WdUUNvZvtiKlzCuWwYrl5gwPlBeomZLmkqthX4i4iFj+u16d8Ls+xGNrYpH7hAdCK69VaYJCVua1D1s/8h54oBSJDpgh0XKiK6Cm/cNiioiG7IBOGJfdXEJS064U3WMLhy9Tv0/8dO9RCLr9V0uAY4DzJRbtCgqoaxlof2aR3lBpc8uZLLhr7DP4/Nm9HiYu1rhkYBtlobNhUGESD7E8x1W90hH8+Ru4WrWJZOMQjLyaSIR84F6sWYnhXfiVXGsNec/7109SJo1oGVeIWa8IWrkyWW+kilx/OKg93+qhb2eE9jVIg3Yc8240R/szr9tCKKc+8cXGhAPVn7+wGV6BPwzci9bdFP1HF48b+pnxKfK0xJRojuThy/nA2bsr8WLiD0YsYIJ9/whXFv/If76R4Y5fkTI9pyRrzr0Cf2YsFKDcaP4TT5IdeKUd4xo68MFRcgdQRzxjvb+srx8q9wZd3qXGpKNpoKE5CbMrdO6q8f4L4BDX38HlwORttQI=
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|22121099003|31061999003|5040399003|4140399003|24121999003|22091999003|8062599012|8060799015|24021099003|15080799012|19110799012|39105399006|40105399003|3430499035|26121999007|440099028|102099032|3412199025;
x-microsoft-antispam-message-info:
 =?utf-8?B?cWFvajMrc3dyMXAvekh6VEVNQk1LQ1NCQ3J3Q2o0cFA4SG9XU2FGclRZeWxk?=
 =?utf-8?B?SzI1MVpLMDY2dXVmcEN2MzVjLzFWT2ZTcmVRSXF2YnZhNXk0YWtkbkc2aW1B?=
 =?utf-8?B?TFk4SG5yV3ZuNm5QQkdjUDlnRWZTYzROUlJDSVJMakd1c21jMVE2RkNiZmYr?=
 =?utf-8?B?SEo1Nml6RUx6N0lMVEpNYkRVWDB1bmZDM0JoMThHWEZSeFA3c0c3YmJTSmc1?=
 =?utf-8?B?b09ybWVYMVRKL0NNUytTOFZ6bDlaei9hWGlwWE5XeW9rbE5id2duWWhkTzVy?=
 =?utf-8?B?OUtBdlREbEFVY3FSaTNBdTFrdGRDUGVwYWJWeXd5VWM5cFFaS0JPK1A4STdm?=
 =?utf-8?B?ZlpLc1E3TUR6SnRPRmVGNWJIc3prOGJYMlFYd3ZsOXBOdHBCNWhkOVpqaytL?=
 =?utf-8?B?RW5kZ0IrWUxwUEsvV0kxQ1c4eWNiZURtMlJKclpxMzRlV2dEV1U3V1Q5amdZ?=
 =?utf-8?B?cUJkY0dJRU5oMGg5TGNETW1FaFFwWTJrRjZOd2pEb210WTd2WWFlY0ZsZFRv?=
 =?utf-8?B?Q1hybExiWGtBMzU0cUFiaGtyd20xa3czSFh3SS9GejBYOUhuc1lDRS9PSUFu?=
 =?utf-8?B?RngyQnRtSzhpaEhvNWxOL0MwWlFseDEyRlg3NGJvekJUdlBYQmZZRHhEcStV?=
 =?utf-8?B?WDlhSkJVZmNYMXZCUmc3KzM3dkNMa0xkWmxrSkNZZ2c4ejZHejlZUVhBWEsr?=
 =?utf-8?B?Q2hSRGFZdkVTaWtTT0YvcVpxRUQ2akZORVpCTVVZTUR5RjJHV3ZONWM5WlB1?=
 =?utf-8?B?QkVLbzFyOHk4NEtYbVdYNVdCWVBxWSs4bndNSlNpQlJMTmpqQzN6VDNBS1E1?=
 =?utf-8?B?TVo4WU51amo2WWdFMkRXTFdXdDRiMzVSdjNaL0pnbTRBOXozaVcrWG9HKy8x?=
 =?utf-8?B?aVFFTkFuMjIxLzBOeHBkcVZkYThWdTJuam9PdEN2SjJhTWZmNjRSb1k0NUox?=
 =?utf-8?B?aGlZazR3bDMyenpyUnhObkdFQm50M3MvQnRFMTUya1Nia3U0VWJGQjhaNU1s?=
 =?utf-8?B?aWtHcTUzRi9JMXlZT1loaUlqRnlOZmNlZXg4LzE1VUZIWFZUS0ZRYUdWT3VQ?=
 =?utf-8?B?c1dWd3Q4SlFvRzdKc0oyRWVaVDJ5YnRTQkFYTEE5c0FIZWp0cXpxNWgyMlR2?=
 =?utf-8?B?Q0ZsQjZJUjF5b25FNXB6RDRkdTlvb0wyT2tmUTdPaXlZdmNmc3UzY0ZYSjl5?=
 =?utf-8?B?bTZjMktoTDdObE9RRzJ3cTkyOVJtN2puT1RwN1BrUzRmOUdYWmpPSmxVc21z?=
 =?utf-8?B?eVVVMFl6UUsxSjh3SHJGUjY2R1BlTTZFMWlaOWZPaTdCTnhrUElJcVhZRHJq?=
 =?utf-8?B?UzZTdUFVN21lV2t6aFlGcDB1M2o1ZldRNkVTeUdPZXN3aElPYlZZMWJuT3Zz?=
 =?utf-8?B?N2ZURGhXWnBiUTdZbTliZTZQSDVtNlZmYmxyK0Q1WFRhOUt5Y2lBdEpUYW53?=
 =?utf-8?B?OEtCS0orcFNNQkd3TUIvMUR4YktWR0sxTFBnZ0x6SURTcDU5UkM2R0ZGZFJ0?=
 =?utf-8?Q?eXLf3Q=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dU5LL1BtdXlhY3FDVkhtYkw3NXZxeW5BY0ZQUWV0b1hXZVRBVGw2aHk4Wkx1?=
 =?utf-8?B?b3hmZmcrVlp6eHpQQVI4NmZSb2F1VTN2SVhsNEJ5cklXbjZsL3ZTeFBiU0Mw?=
 =?utf-8?B?U1BPU3VZTmFad0tHbXIrUHZ0R05WdWNvN2phdzhQUHMrR0kycEZRQmt3Ly9P?=
 =?utf-8?B?M2xtV1BiMEFyQS9vSDlyQkdLSEhvR2Z1S2FlOCtXVmxlTmEvaVdRVTR6L2lq?=
 =?utf-8?B?UG8rK0l3V3lMMHo1ZVl6bm1MbXc3Y1dhTlNIY0lEM045a1JTRVp6RWx3Ymdz?=
 =?utf-8?B?R1UxRmkrY25LYVJaaXlBRXIrbWoweCtmaEtiWUhYQ1BESGhpZ2dINVhiRzQ4?=
 =?utf-8?B?TDlTMy9mRXAxNWdCd2V3ODF4Q2pLUVBId1RIckZ4MUM2QXRrOU16NEVSZVF3?=
 =?utf-8?B?NzJ2TzFMSHovc1Y3eGNzZnRoeDRnSFRkSDhSSVNDYjhHRTJQTGROcW9zV0E0?=
 =?utf-8?B?WXg3ejlUTDVrM0NhcXlkNlNWMDNJanpETzRzS1F2cUtqUWpOZzZHVnZJUmhO?=
 =?utf-8?B?QzVVWFprUHdUcmppM2NWSzB3eFdMVEJSUHVqNVhBdm5KeTlidDZEVDF1ZFA2?=
 =?utf-8?B?VjhYK0prb212ckVKQlE2aDhNcmc4Tm1OMmEvd1JwZFdsZkF2QWIrKzlzTGNv?=
 =?utf-8?B?VlVQRWhibEhJNS9iVDQyaWltNlA5c0lyT1ZCQ3BHS2ROQVMwMlhqa29tMTNl?=
 =?utf-8?B?L0lTb0RnbnBrWGRzdTRDek9GczJhcnBJRW9TbkJnV0d3MFNYS3NSbTE1TnYy?=
 =?utf-8?B?Vkh1Mk8xRGdpL2RySWVRZDNTMXBBMThRVEFaRHZqZ3kybXdSUEtVaWxQWkNY?=
 =?utf-8?B?aGlyaGk2M0Njd3ZWVXRKYkhHeHk0SVNrd3dHalNUakVjRE04NGc4U2J6d253?=
 =?utf-8?B?aFRZVDc2UGJqYVVMemtKK3kvNk9lbUpzQ1plaVd3VytEbTFHUjRJQUdFYklB?=
 =?utf-8?B?SjJlM3VQZGFscHZPcUk2TEQwZHdtSFhlRlZBRExaR3BySWN6d2lJb1lwMS9M?=
 =?utf-8?B?dHo0cndsYjRic2xoZUdnY0RidUd5U2o3Vmc0TE5MZk5vVHRab2NwTi9seFpY?=
 =?utf-8?B?NmxrQWJ4WUNjaDY2UER3bGJ3OUtWT1k3amx1cE91WXE5UTduTUlwVFYvSWtC?=
 =?utf-8?B?UUxTVEJybGxFT1hlNkdlZzZxTU05ejkwc0UvdlZYbDZLTCtNUnhCVUU5bjF1?=
 =?utf-8?B?enNnTGFLTWlvblpVRi9CWkd0QnFhVWhRTy90c0lmNXpXVFBOWmhSQW1MVTRX?=
 =?utf-8?B?SlVLZGhCT1I5Y0w3SU94RXFQT2FDaVV4dk9DMHZYN3lZOVFkRmhEUFpGUWYz?=
 =?utf-8?B?Z0IrQ0JucXZpeE56RUtrS3RQMFdibVRTbzdpK1JxdHNCT3ZKVTlNQWhxMVBn?=
 =?utf-8?B?MDRaZUpzTHA4MTBxM2F6NjM3cHBxZFl5V0o1NmlBQU1ic25xTkRNSzVxUUFZ?=
 =?utf-8?B?WTdod01UMHZzTlZqNndmSWcxOWQwODZXanZkRElHRFhBV1o2KzNOUHhVUXZK?=
 =?utf-8?B?QVRLY2RoallwK3BCdmtrQXQ1MVRCd3E4Nzc3VHFDR3U0TTdaU0IzdTNLNTI2?=
 =?utf-8?B?KzNFN21YeFdSL3BBczBsR1FJaVA4UlR5Qi83YUcvK0Uvc29RWUJQZ2MvNXRI?=
 =?utf-8?B?aWFqWi9BbkUyY0xXT1JzOUE2OFlGQVBLcDNqd1ZjRjNKa05UMVVFdTk3VVNx?=
 =?utf-8?B?Q1Fsc3BmWXQrU1ZZWWZhbkFUUVR2UHVHUjZvT204TzY3YjhlWUZseG55YU1Z?=
 =?utf-8?B?bUdNTk9HakZuL01qcFRqc2ZBL3VzQXdwSGVJZURsN1JLMTdnTWdvRERJL3pV?=
 =?utf-8?B?YmVPNFdOQVNWMVBjQXRDQUsvbjErOW9zUVlyWXMxVFp3NmNpQ3BCQk02c0lu?=
 =?utf-8?Q?GxClQuxKcSEy8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DCD426405E41F4EBC57F7885D08CF04@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c17921cb-f5d5-4ef3-edba-08df2daab9b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 06:32:19.2886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8326

SGkgQmFydCwKCj4gSG93IGNvbW1vbiBhcmUgb25lLXRhZyBkZXZpY2VzPwoKSSBkb24ndCBoYXZl
IGRlcGxveW1lbnQgZmlndXJlcywgYnV0IHVzYi1zdG9yYWdlIHNldHMgLmNhbl9xdWV1ZSA9IDEg
aW4KdXNiX3N0b3JfaG9zdF90ZW1wbGF0ZS4gVGhlIFFFTVUgcmVwcm9kdWNlciB1c2VkIGFuIElE
RSBDRC1ST00gdGhyb3VnaAphdGFfcGlpeCwgd2hvc2UgaG9zdCB0ZW1wbGF0ZSBhbHNvIGhhcyAu
Y2FuX3F1ZXVlID0gMS4KCj4gSGFzIGl0IGJlZW4gY29uc2lkZXJlZCB0byBkaXNhYmxlIFNHX0lP
Cj4gZm9yIG9uZS10YWcgZGV2aWNlcyBpbnN0ZWFkIG9mIGNvbXBsaWNhdGluZyB0aGUgU0dfSU8g
aW1wbGVtZW50YXRpb24/CgpNeSBjb25jZXJuIHdpdGggZGlzYWJsaW5nIFNHX0lPIGlzIHRoYXQg
aXQgd291bGQgYWxzbyByZWplY3Qgd29ya2luZwpwYXNzdGhyb3VnaCBjb21tYW5kcyBvbiB0aG9z
ZSBkZXZpY2VzLiBGb3IgZXhhbXBsZSwgc21hcnRjdGwgdXNlcyBTR19JTwpvbiBibG9jayBkZXZp
Y2VzIGZvciBTQ1NJL1NBVCBjb21tYW5kcy4gVGhlIGxpZmV0aW1lIGNoYW5nZXMgcHJlc2VydmUg
dGhhdAppbnRlcmZhY2UgYnkgc2F2aW5nIHRoZSByZXF1ZXN0LWJhY2tlZCBjb21wbGV0aW9uIGRh
dGEsIGZyZWVpbmcgdGhlCmNvbXBsZXRlZCByZXF1ZXN0LCBhbmQgdGhlbiBkb2luZyB0aGUgcG90
ZW50aWFsbHkgZmF1bHRpbmcgdXNlciBjb3BpZXMuClRoYXQgZG9lcyByZXF1aXJlIGV4dHJhIHN0
b3JhZ2UgZm9yIHRoZSBjb21wbGV0aW9uIHJlc3VsdHMgYW5kIHNlbnNlIGRhdGEuCgpTZXBhcmF0
ZWx5LCBwYXRjaGVzIDQvNiBhbmQgNi82IGZpeCBsb3N0IGRhdGEtY29weWJhY2sgZXJyb3JzIGFu
ZCBkbyBub3QKZGVwZW5kIG9uIHRoZSBxdWV1ZSBkZXB0aC4gSSBjYW4gc3BsaXQgdGhvc2Ugb3V0
IGlmIHRoYXQgaGVscHMgcmV2aWV3LgoKVGhhbmtzLApZaW5namllCg==
