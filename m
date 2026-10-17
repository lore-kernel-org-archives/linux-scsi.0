Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19011070.outbound.protection.outlook.com [52.103.23.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96053363C40;
	Sat, 17 Oct 2026 08:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.23.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226764; cv=fail; b=Fm+800HLv4c4m/uj9cwTQ6FPs8tUQYWX1p8cwONV8eKQ77YqaNL2gNAh2rt8NM8ABF4N+56Haau+r5qVERQYq3q/wdHLHbCV66sUXt6eisBIjaQxrq72d19kQiShEQyAlU4CtLw/o3koP/l2z4dGYLtZ1eAxvMywzDe//PJqbg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226764; c=relaxed/simple;
	bh=tfUxumpML/F774vp3frD8Q9XNlNpoMxg/QzVCLm1iwE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fQXM1NkCyHwSG7feHCRjh1bDRhI+Ry3Jz/aFkFiZ2UuzOUAiRl4mAz2uKkMjI2Kvgfhisg6ONtvu+fhq9lJSL5E2QrgHv05FS4ENVymoFCRCrj4DOuz+gSeDn6K21iLy+EqeDPIy4kBGmFkLdfDXkRWj+EJg9PSa9MZhoTG85NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=dZmhuG54; arc=fail smtp.client-ip=52.103.23.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="dZmhuG54"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2niGrA1m00t/zSsl0tfDUv0zi/dBJdBJ52hlu1b/KGU19/iJhpesMy/ewr6TXwwB/lylX45FKwmzfbKUwwYq/TTHG7Eg9csQWMLCq2lv13a8VBjONttSGWmHhWfY4Dn9INKQsnzDpSFZfVB21aIB3eUU6pahuIUwtOQUKBz3x9yIvE33jNFDRkN0lB5Gz/zSfEZ8OgyDR3OXzc8ASyMAaX48AkN83cG+EpoUriZZX8IIj9hL+fZwsY0gj1mzd0qOCW99UwXtAllY48lLKog4WB3cc9cvZ3S2TMea8zOKHYlm282lwfK3teHdO2wGTTV5LgiwqbVkuxlXfVybwJkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=tfUxumpML/F774vp3frD8Q9XNlNpoMxg/QzVCLm1iwE=;
 b=aRTZHOwBW/RAduMk4RveGMmRnhyQM52+g19KIqsKd6EGAHM+FZX7HPBuFTjWF/6YikhcZ5cSCJu1RXpFPnMA0tXdaUoNagC7HfRQekuimPKzs+vY07LnXlg4t5zQwpjO7B0nY/bff6X+h9UGNx8GqKlvyO7etd0dWnxdP74PIZ0xm2cSPcCXAGODcKb4sFfoZU+lnsTGg+NbL0W3OWSJC/rX4/YZFgHxIuSmB8bPvD5Fjewg3TUXMMBCqZsoZBn7dChKskxHO7u+bhC9YuyqcX4hX+vqqmbK1Y0/3RZaBd6Q3mX7r1ha51vwJlvMc5bNb3tGEeeiJZEKScYN5cWxyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfUxumpML/F774vp3frD8Q9XNlNpoMxg/QzVCLm1iwE=;
 b=dZmhuG54NcrNA0s4j/Tq9Z8KidoB1lsCXYhEng6s4+WSpm7B9pcRbE2Rk/K6oJG7MIb1t8VSjV/daqU2LYrqw6PDAp/zoqTT6CNl2SkyR7CSuu7cyj/C3SvMCFdltygfz8x0SZmUH7qK8Vgd4zELPT+TEHI0JF+l7ABP2Eb+Z5I8DY+8113uaWZ7ej9U0cbbpKaQBASPwGrHHeIDVN9HNXFteMgBNhKeqZyeefvniqVEst2NyoC7qrFw8ypLvYR3lyua6GiAB0qoThmPqR2AHWt7l/qhiPGUrVigbUg2wuB9OkfeIz/mX8CYXKvZIxz1YBdmrcBGFxcxfjUarxZTxA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by LVWPR05MB998850.namprd05.prod.outlook.com
 (2603:10b6:408:3c2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.17; Sat, 17 Oct
 2026 08:46:00 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.013; Sat, 17 Oct 2026
 08:45:59 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "mkp@kernel.org" <mkp@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: reject negative SG_SET_TIMEOUT values
Thread-Topic: [PATCH] scsi: reject negative SG_SET_TIMEOUT values
Thread-Index: AQHdXhPuhyn+OUhXA0G5zzrA0hoC1A==
Date: Sat, 17 Oct 2026 08:45:59 +0000
Message-ID: <20261017084547.2880694-1-x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|LVWPR05MB998850:EE_
x-ms-office365-filtering-correlation-id: 489e120e-3ff5-4293-bc90-08df2c2b117b
x-ms-exchange-slblob-mailprops:
 AlkLxVwsndm0VyxXF8Qt58maZsxVls0a2I5fzvdgN3RZoKuTUPsxVZ+nHL9CG65WHcWN2cNJSWBRV9vaKNUxwkwyp9BNtVu2uSEjsn6V9XX9RKWfTovXAbTNJuiQWvhuk32eBMgoP/KefI2meOg5Fdmp7PsyEgzejbqfK8u7qVsqrpz/r7gs/+5JLxztkx7xK/P8vOwq5dV7bPxj+qrdkcaGRI8vVcA+ybOekbHQD9nx37jy1ZL5uNPCsxSeE/H6Gn8HWDs6m1cz0a8FF2J0U5BaiXid3yu/6olnbTMK9qeyY7qHHknNBn03yaFlYFh66fs1qw/D2ALNwSxrRq3HkvaAiMtabnwVwgf7wM8dxwGKGvHZMcNDkjxF8X3pYX5/4TCo+X/0uV9aURl9tbhErNsbocPxQ6+714hWCv8YUZSf18iK3mTavWEyGfWqE0P1uwxlzzUtaMM5UTNwGsaa8FRl7KR3UsDLlR0jLa62UgwKrGeJnaPDlUJQ5FcvIG5KYFXEh3tkurSjOED/G74WGV8fp+VXu4727PkBjrE+RHNnl/K8wQX8WEn13Gj6nRIPi4SLVvmmgwnlyRXnXGfQVb8eObAjFipNHtgj4ozZrQGvdUdQAud7WK07pl8gCHvxavLRv7PTL1GQN1bcRh1ajxQEtrWi3KtbIkxqHmvaT789X/JqLfyDuIydYJz9chufOZnQHiDoGSwlloXSsSZ3ad9xSGqEHoF8VfaD2cMUH6rl+ZICWlIBRBWSnywr8ce29lpFYhu0fSxfZY0YZVgYz2cEZttWIuQB
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|15080799012|24121999003|39105399006|22091999003|5062599005|24071999003|19110799012|8060799015|31061999003|8062599012|24021099003|20031999006|4140399003|41001999006|6050399003|102099032|440099028|3412199025|40105399003|26121999007|3430499035;
x-microsoft-antispam-message-info:
 =?utf-8?B?djBaZ0lseWZRQmJGclI0L1lyWXN3OTJqampOSVJYeStJUndDMlJkb25QMFF4?=
 =?utf-8?B?Qzc4RWs1N1h6U2hYT0lWR0ZmdGVBY2VFVnhJYkk0ZEQrWjUxMTJaVkVyaTFp?=
 =?utf-8?B?VzdzSXIvVUVwa2p0WGdZVUdPS1RhcXJtUmpyY1NBQk9DZmVYRk5uWmU2Nk1E?=
 =?utf-8?B?ejE4U0FDc04wMDFZUVZYSHFLWU5SZzZxeTVxNmlKSzF2eFRRNWlsNTdpOEFu?=
 =?utf-8?B?TU9pdjJJL1krZGgvTVF1ODRkWnVveTNVa0VyWWRrL09XTVBwZlNYeVpvdk1l?=
 =?utf-8?B?bUtOWENRWmZuaEtrMHJrKys2QmgraXMyOUUyUWI5Y0xMVkNUanIySXhESDJy?=
 =?utf-8?B?UzJUWkZBMmZiY1N6QU5uSXhYWm5pSHBKQ1JQOXpHeFVjbHRyOUlJTW9iQzAy?=
 =?utf-8?B?ZmRSdUNXS2g0bzB4aVBpQkxUcExvOHFoM0swTmxvVVpEQXBVSFlwdS9PbWo1?=
 =?utf-8?B?MnhBeXY2NllGSDl6Z2RQVzdQWG42cjF4cEVDQkZrQzFaQ01DcExYajhtK1Ru?=
 =?utf-8?B?VEN5M0Z0cHFZcUwrZ25qMzFnWm9NdGc4ZTlrTURHdUN3bmNjN3MrOXQvdDhO?=
 =?utf-8?B?WkVNbXJpMmYyQmlDbEJCKzY3ai9QZ1VobjlmSVBsQWZRS01GOU9VbVJDVm8w?=
 =?utf-8?B?YTh0dzFEaVdTc29jcmVKdE43Q0Z4cnhwRjUrdjZ1K2laaTRkSWVmUU45cEhw?=
 =?utf-8?B?WnlqRDJmdXEzdHNzUmNNcTZZNjRDTHYrUEFMTVBoNml2R0dGWTdpeTBxbXl3?=
 =?utf-8?B?Umh6U3JzQi9IeERteDE5YkNTYUtsWGhTMG1yRUhwSUdMYVpNb0VMUCtyUk90?=
 =?utf-8?B?NlFLcnVwZWpIVktzOU8rNnBITnZBZmtWcmZnRTVKTHgvcENVVm5vNzJVMFFr?=
 =?utf-8?B?MlVLM2d1QWZsTzB0U1R0Nm1XeVZMcC90U1VEN1REbUh1RDV1ZmUvTGZBVjh2?=
 =?utf-8?B?RTFoaVFnK0tCVlVqckZ2bkE5bGtvUXZQeWJ5UW9scXZSU3BibUF3d3gySnJt?=
 =?utf-8?B?eEJ6MEJnMDN1eHltaEVFNU55d0Z0QzVXZG5zUmQ5ZlRhaENZUEp5YzhjNndn?=
 =?utf-8?B?c05nNFU2SGFBTFlXTmsrbXVHUEVZYXNuRFlMRzQ1UXJvMW1reUFNOUZTQXJY?=
 =?utf-8?B?akNyUGtCRFhYMU5VQ3BQOVBzWkFaZHhyM2FmUjhLcmdqSU1uaFZCQkZaVjY5?=
 =?utf-8?B?WlRLbjM3aXlldGQyNUZBYzUwRUFhbGVKc3RTck5mRmxQYThJengzT2dJMGxp?=
 =?utf-8?B?MFF2U1VHbjhCTC9hSUh2VUVuRGt2MEZIUDVzcVVKaU9kN2I2bnM2aHVSTU94?=
 =?utf-8?B?WHgyM2FuMldqck91cTMwdEN1TzBwWkpndU9vTXIzR2VIVTRGS2FVbUFtK0kv?=
 =?utf-8?B?UGVaTU5kMGp6emc3dlRDOVphZzlwRUNXZXhXVElRTUczbU1hZ3htWXB4TGUx?=
 =?utf-8?B?YTViV2FlY0h4aVBoejJlcnVZcEIxUkIvSVlDT2puUzRBU0dLaExBSi8vSmNC?=
 =?utf-8?B?M1NXb0JYYXRIY1o0Y3ZwOUdFUVcxbDI1N3hSRWRPQUZIZkhVTzlidGo5QjJa?=
 =?utf-8?Q?htBokl88hJ+PnoJAuWDIgjZH45LCaiy6ZyUACTByQziVoh?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aitSVXdKRFJBTjlHbDV3RzBlK0FzSWtkTWZoVXBRTXRLNEI0ekNZQjVSem90?=
 =?utf-8?B?dHJWZzVQSXQxYXp1NU5ZUEhDZDkxQkNkTjJoc1E2S2l4VDNvMnExcEozdHJ5?=
 =?utf-8?B?YmMyWTNScjFNK20yWkZoQmRsUnZqb0FiSDBuM2pvYkZHWElPTjExbVJIZktW?=
 =?utf-8?B?YTYzK0l0M1l6Wk5sNzl6RExOYXpLWnJSY2sydzROWU5HNmNmek9pc1pyOStC?=
 =?utf-8?B?Z3BFeG42bFpIQThYdm5sRnpRNy9OeUxUaXJteFJndkVsOWtxUDB3OVJHdVpp?=
 =?utf-8?B?TlJnRlhRdDJ1eW5MVkxMNnZHRmJIOGdNT1dmdXZEbE43djBsL0xvUm1WN1I5?=
 =?utf-8?B?UG1CR3E5cWFUT25rRVRpcFN4cGJra3B3RXFLd0VOYjBTRVF1Vk1lYWRuNEhD?=
 =?utf-8?B?ZlhBb1VXT3JZRnBSL0tOY1FBWE1nZEt0cGd4dTNoVldIQ2REb1BrcFk2UzFI?=
 =?utf-8?B?TnVRbHZrZzZtS1dqSlh6bkxkMjFiL0c5WHIvYXdHL0FhZDIrUC96TnVxZzJ3?=
 =?utf-8?B?enFIb0JQNHZheFZEOHRrZDJ1T2F1YWNGVkpQUGY5NCtUUW9JQU81N3R3QTA5?=
 =?utf-8?B?Y0U4U0ZkbGRPWEI5T2tDa3JUdmdJV0NVdkg0WEk3ZnBGN3ZDaWlneUVyeGVQ?=
 =?utf-8?B?aDIvb1R3UHFHNWl0NmpTQjVacmg0SEkyZldUTi84Q3JlNkdXRHUwRE85bzdy?=
 =?utf-8?B?QnpRMEZ3UkdUZ1B6bGY0dFR3WFFmTVZqOU8zUlJna3NRYkNjSm8yemE3U1gz?=
 =?utf-8?B?MjlZV2JSMWg4TE1VWTNRd05BU2VqNnlCTjJQcHRmeURRQi9kbzkvZk1SdUNt?=
 =?utf-8?B?dUo3SjlZbUc5dEQrZ2FFRUhNamd2cnB5WjRxQ3ZidWQ3WFRIVGhzbDlya3Rq?=
 =?utf-8?B?WnVMUUNmSjBZYkN0cHVMbGUzSTdrdEpFM2VMeHJNM0FyTDFacGVqRUNLa0NM?=
 =?utf-8?B?c2x2UElYaHBJalYwd1owVUpKR0lDa3l4NTdIeU53SEhhaDJINDBVVGtRK1Jt?=
 =?utf-8?B?WkE3ZGxsdGRDcjlvcFhmOWlROW9IMzhDWWlnU1ZpOENvbEE4OHFLbHErc080?=
 =?utf-8?B?dGhPVzk4NDhyQ2dVaTRhZll4NWNQdnlCdjc3K0Y4YnY5OWNjaVpHNGNxV1R6?=
 =?utf-8?B?UmdVMlNvMkU3YW9SQ3hLMzJudTZ2QmsxSk1icUhnalg0eTZkSThlQmxUTXVP?=
 =?utf-8?B?VkVaUXJJcFl5WE52L01CWWkwWDNXYm1LVllydm1IL1NYUUhHdkIyZ2R5VWVn?=
 =?utf-8?B?TTZRa21CdEkxVDF5aWVGZXVBSjBsWmg1cENOWFhXTkpLTVA3REVvU2MvYWov?=
 =?utf-8?B?V1c5Z0ZJSE11VXRaR2VpU1A5aGhJbjJPY2drblNkaU1qTFZIcHh3M1prc3du?=
 =?utf-8?B?VkkzR1JXK0FFcXZXUUxZU0FiRlQ3MS9rcnhxdTdkcEVJVjUramNuRDFlUkk0?=
 =?utf-8?B?OUoxYkJVeE1DSHFJWW9td3JENGdINVJ1M25lZ3JSTTNHRHRVNkp0WTh2QU00?=
 =?utf-8?B?dUlIV1BJTWN3bUZBTTQyZGZObXVqenZYNnowZDFBUEZZTDdkZHZmOWZTRHJI?=
 =?utf-8?B?eGl6dUh4N2ZBMmY3WDZVa1FXSG9aRExNY0VzRlRON3NQZmhBdkxpOWt6cndm?=
 =?utf-8?B?Tmx2ci9MU2J2WGhNNHZyOVhOMzBmcUlSdDRFUkF5eEhhTzk3Z1lQVGxXanpo?=
 =?utf-8?B?REJreEgrYnFOY3VjckRxb05uRFlmTmFDajRkdXEzZTNHWW9EbkhMakxxemN3?=
 =?utf-8?B?ckVqdWNPNkV3Z2xjQ1lBTk8rOVovV0FWQ0lOR04rM08zNG5NUmpRZERJMFZj?=
 =?utf-8?B?MUwxSVJIQkRUVE53aHRUZ2FFU1VHYXhSeG8zd2s4MnhZZkxDY0laMTY4VlVz?=
 =?utf-8?Q?b8RJ5gqdVVfLo?=
Content-Type: text/plain; charset="utf-8"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 489e120e-3ff5-4293-bc90-08df2c2b117b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2026 08:45:59.7862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVWPR05MB998850

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KClNHX1NFVF9USU1F
T1VUIHJlYWRzIGl0cyBhcmd1bWVudCBhcyBhIHNpZ25lZCBpbnQgaW4gVVNFUl9IWiB1bml0cy4g
VGhlCnNnIGNoYXJhY3RlciBkZXZpY2UgcmVqZWN0cyBuZWdhdGl2ZSB2YWx1ZXMsIHdoaWxlIHRo
ZSBibG9jayBTQ1NJIGlvY3RsCmFuZCBCU0cgcGF0aHMgcGFzcyB0aGVtIHRvIGNsb2NrX3RfdG9f
amlmZmllcygpLCB3aGljaCB0YWtlcyBhbiB1bnNpZ25lZApsb25nLgoKT24gYSA2NC1iaXQgc3lz
dGVtIHdpdGggSFo9MTAwMCwgcGFzc2luZyAtNSBmaXJzdCBjb252ZXJ0cyBpdCB0byBhIGxhcmdl
CnVuc2lnbmVkIHZhbHVlLCBjYXVzaW5nIGNsb2NrX3RfdG9famlmZmllcygpIHRvIHJldHVybiBV
TE9OR19NQVguClN0b3JpbmcgdGhhdCByZXN1bHQgaW4gc2Rldi0+c2dfdGltZW91dCBvciBiZC0+
dGltZW91dCB0cnVuY2F0ZXMgaXQgdG8KVUlOVF9NQVguIFNHX0dFVF9USU1FT1VUIHRoZW4gcmVw
b3J0cyA0Mjk0OTY3MjkgdGlja3MsIGFuZCBhbiBTR19JTwpyZXF1ZXN0IHdpdGggYSB6ZXJvIHBl
ci1yZXF1ZXN0IHRpbWVvdXQgaW5oZXJpdHMgYSB0aW1lb3V0IG9mIGFib3V0CjQ5LjcgZGF5cy4K
ClJlamVjdCBuZWdhdGl2ZSB2YWx1ZXMgaW4gYm90aCBwYXRocyB3aXRoIC1FSU8sIG1hdGNoaW5n
IHRoZQpsb25nc3RhbmRpbmcgYmVoYXZpb3Igb2YgdGhlIHNnIGNoYXJhY3RlciBkZXZpY2UuCgpU
aGUgYmxvY2sgU0NTSSBwYXRoIHByZWRhdGVzIEdpdCBoaXN0b3J5LiBUaGUgQlNHIHBhdGggaGFz
IGV4cG9zZWQgdGhlCnNhbWUgYmVoYXZpb3Igc2luY2UgQlNHIHdhcyBpbnRyb2R1Y2VkLgoKRml4
ZXM6IDNkNjM5MmNmYmQ3ZCAoImJzZzogc3VwcG9ydCBmb3IgZnVsbCBnZW5lcmljIGJsb2NrIGxh
eWVyIFNHIHYzIikKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogWWlu
Z2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KLS0tCiBibG9jay9ic2cuYyAgICAg
ICAgICAgICAgIHwgMiArKwogZHJpdmVycy9zY3NpL3Njc2lfaW9jdGwuYyB8IDkgKysrKysrLS0t
CiAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9ibG9jay9ic2cuYyBiL2Jsb2NrL2JzZy5jCmluZGV4IDgyYWFmM2NlZTU4Mi4uNjgx
ZGE3OWE1YmEyIDEwMDY0NAotLS0gYS9ibG9jay9ic2cuYworKysgYi9ibG9jay9ic2cuYwpAQCAt
MTMyLDYgKzEzMiw4IEBAIHN0YXRpYyBsb25nIGJzZ19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZSwg
dW5zaWduZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpCiAJY2FzZSBTR19TRVRfVElNRU9V
VDoKIAkJaWYgKGdldF91c2VyKHZhbCwgaW50cCkpCiAJCQlyZXR1cm4gLUVGQVVMVDsKKwkJaWYg
KHZhbCA8IDApCisJCQlyZXR1cm4gLUVJTzsKIAkJYmQtPnRpbWVvdXQgPSBjbG9ja190X3RvX2pp
ZmZpZXModmFsKTsKIAkJcmV0dXJuIDA7CiAJY2FzZSBTR19HRVRfVElNRU9VVDoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9zY3NpX2lvY3RsLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5j
CmluZGV4IGMxNGY4MTQwM2EwOS4uMTYyYTIxMTEyZDQ5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Nj
c2kvc2NzaV9pb2N0bC5jCisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2lvY3RsLmMKQEAgLTE5NSwx
MCArMTk1LDEzIEBAIHN0YXRpYyBpbnQgc2dfc2V0X3RpbWVvdXQoc3RydWN0IHNjc2lfZGV2aWNl
ICpzZGV2LCBpbnQgX191c2VyICpwKQogewogCWludCB0aW1lb3V0LCBlcnIgPSBnZXRfdXNlcih0
aW1lb3V0LCBwKTsKIAotCWlmICghZXJyKQotCQlzZGV2LT5zZ190aW1lb3V0ID0gY2xvY2tfdF90
b19qaWZmaWVzKHRpbWVvdXQpOworCWlmIChlcnIpCisJCXJldHVybiBlcnI7CisJaWYgKHRpbWVv
dXQgPCAwKQorCQlyZXR1cm4gLUVJTzsKIAotCXJldHVybiBlcnI7CisJc2Rldi0+c2dfdGltZW91
dCA9IGNsb2NrX3RfdG9famlmZmllcyh0aW1lb3V0KTsKKwlyZXR1cm4gMDsKIH0KIAogc3RhdGlj
IGludCBzZ19nZXRfcmVzZXJ2ZWRfc2l6ZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsIGludCBf
X3VzZXIgKnApCgpiYXNlLWNvbW1pdDogNTgxNjFlYWQyOWU1MGQ3MGEzMTdlYTI2YjQ3MmUwYzc1
MDhlNjlkYQotLSAKMi40My4wCgo=
