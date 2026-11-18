Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794990793;
	b=WEbOkjrsjS+BjsanjovfvB6SOR6qY4bIrrmeehUgutNC+t7Tb6nIzuvtNh44eijwtcZ7
	 ARgZrE5w7oSsFhUrJOQ7WVt7HxcuWfsmyhPUGKFpZQdIemEzHgqUujL+51hrZF7l5c29A
	 twSlzIKJC8AyR2QiB3gl1aFDihMh9zX0Tw1DFMw54r+WQD5XcoADwIGQ1yCQlLl+H3Bmr
	 yFIki9X66sW1oKfW58YdldNjEyDi7h1cXeWWwzgJPjnSlJZqBwKUv87aZv7Qyer8yf+Lb
	 lI1s2Af6cDuOFvedp4WcZLNCHDS8SjkRsA8CbRkYWHmxIZ7Jhg8lMfdk5uMzb7Yz7YQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990793;
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
	bh=KPUHtdYQMbFgzpItn4i2pnnQ+aZIVOWjRB9ku2hYfEY=;
	b=JKAYGkvkKs+8WiBKdJkrnu/WS3TdE0vDVbVjzh6E1zxcymQTNvBO4ftmLWhZRkrJ3r5y
	 u+7chkN29EvYSCJV+w3mix9CLTzBV+Ug8R+5ElgHes4rMwPZdJdmPUoK1nLRbvV9ST3ex
	 MULMUel9Dv7a2ANEp73NOHFLdCPXcJeW91AeLHbS2mHsuT+oliUvWyfRwrYnBurcayZue
	 axyC+GmB82OalcPB3+ddVNTvHO6OE9+ADJk5Dm23P+1K+9C+4OMBniahD7U6Zjt4rE4Tt
	 uHtyJRlVNTkI8S6vTHlD0V5mOoCkzNEKxO7B5zoCzBgogOAbF0HGCZdB15wHghS4EfQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Yui0i8E6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010005.outbound.protection.outlook.com [52.103.12.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB10760A2603;
	Wed, 18 Nov 2026 08:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB10760A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Yui0i8E6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkpdElOD5gh4zYYLJD4729HcDhk0qzPh/kEaH/jmn97bD00ocsIBiVMVcHOoWBw1iPXa3O5rR8oIspxHxsNGIdY8XstSjnQMQ+pMeFqz+t04eFo29nJhJpbL+kC13cGLQyLYEGUUWre4vZ4DtpaRv4BZHEyvc1xbn9vPqh2Zj3NmFeWh9AuOmyAOn99QTYHjKwu838q1mM4Awd6yxtzZLZ0jU7gWvoYBc+vBr5LYFLzAgqL22MndBBwPJA720Bx0R5agbdAsJPtGYljWiM0f+4dE5b8LSg3IyhrnOqi8AxubW7Iv1eD+/65P8QCrwDc4cXBVhEjdXroVBJTSJ7xp6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=KPUHtdYQMbFgzpItn4i2pnnQ+aZIVOWjRB9ku2hYfEY=;
 b=X+KS616UpDEa5gOBmmimtv80+hiPyS28pcHEGk9Ju+JjKxQ8rZZImbVT/P004fmSYTMYaFESRRrG4KibWiQBYgNgabCPljT5PpzIxEWf/lqy3pylnufVe8sFLsS0N5yovxseE7pGbKoSDi/h0ofAPP4BVdxoOuaDPvsdDWfCuTlhKfn/246nZF3CUDB1WOKSoebod6risFENRoZLmy1dSpA+HNbAKO6/tNYT63HcLro9SdR3S6drHkIluWYdD3SlWMtTR6W4E5kh7/wpBH66V7jdP4wdEyOYPdu+3Yic0Un6EpnHBQcKZOMw8rqn8v5EMD1EhZBzd/reuDRzXThtyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPUHtdYQMbFgzpItn4i2pnnQ+aZIVOWjRB9ku2hYfEY=;
 b=Yui0i8E6wv3UPEJdRCiusOcgxkd+PrhTzv3NDtldWmS5mczpuzQ3NjBdDcGiOpbLQ/6wPufHL/478FCNh8keoVUYg123ibrvNnncgoE7t7wlm7QQwCtUSVfXJr4lsARArKePFzQLmB+zBJkRFvaN3kAhwC3Y993nADBvP4Ek9f1XoAyZdQq4cxat8mdbp0/wnvSSnYGLZYotqdjoB6jR9Ocw7LcHcYDBTNsE6Vpa8wLWSeQgkvTZR359ZU2lLx1qdOUEdqVQm+OWWqOr88oDxYQSauvBJcBBtuA9Vs+MvMg1Ba0Y54M5LshSsve7gGny6d9z6XIUCeZkF/TxQF+h9w==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB999481.namprd05.prod.outlook.com
 (2603:10b6:510:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 08:33:10 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 08:33:10 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 3/4] scsi: sr: release CDDA request before user copyback
Thread-Topic: [PATCH v4 3/4] scsi: sr: release CDDA request before user
 copyback
Thread-Index: AQHddzdxExsm/Hte6kGPRTFFGaDCXg==
Date: Wed, 18 Nov 2026 08:33:10 +0000
Message-ID:
 <e9916537db797cda88f00744bbec10e87cdcf190.1794990780.git.x-professor@outlook.com>
References: <cover.1794990780.git.x-professor@outlook.com>
In-Reply-To: <cover.1794990780.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB999481:EE_
x-ms-office365-filtering-correlation-id: 26234402-2e59-452d-9281-08df454e9430
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|25010399006|4140399003|41001999006|38102599003|24121999003|22091999003|8060799015|8062599012|31061999003|19110799012|15080799012|3412199025|4302099013|440099028|102099032|10035399007|12091999003|1602099012|53005399003|40105399003|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?L0VMQ0RXY2Y2VFkwSmJ1eEdrSTNabVFwWVpzb3laL1ZWNlMvVTl5UXRHVUc2?=
 =?utf-8?B?dVpaUGVpbWUzOGtjemY2VHovU2QxMm9mOXVMM2pLdHdkNldjVzVXUXdqUURJ?=
 =?utf-8?B?Rk9obVp1Y3h2UjFmNU05RzZidWU1N1hBMnZZWUhyMW9Udk85K2Q5RzA4TkFz?=
 =?utf-8?B?eWxDeTdiOHkxTzFIcUhTem1IRjhLRjFBTzVQY0l4N3M1Z1lZdEdKT0psOHlx?=
 =?utf-8?B?L2VkVWlIWVNzRU4xdzJrOFpZenYxZGU4aGZTVkl4OE9CNWFKOUp0L0thT3J3?=
 =?utf-8?B?NmhybzdDVFdhUmdIVTJCM1V3QVgybXQyMitIa1VuN0M1eDZ2Z0g1NXFUam1o?=
 =?utf-8?B?N1IrbktQUDhGK1E0T0dRUG5EM21yeFJibUtXaHVWQy9Hd1pQYm92dEY5dHBm?=
 =?utf-8?B?SFltL29sRXMwZjlmbHNEeFlrQU5jUFhwdnA0c3F0cEZlT2EydEQzTlViYW03?=
 =?utf-8?B?cm5NaGFxa2dXdDdnSlhkTmw4a3ZqbTZsQTB3Tmp5UEUrdGpEQlRYQXpBR2lj?=
 =?utf-8?B?UmVCMlRwTUJ5RUk1eWplQ2szZGlmK3cyM2YxVkRFYXFSMVRDY0EzcTR2c2Nz?=
 =?utf-8?B?N0tkdldaOS9tWU0wSzM1M0gvR3o3QjRjS1VYN3ZzeTFjT1EzTzJ0UlV4NmtK?=
 =?utf-8?B?Q1BzRU9vaDlVVWIwUTlIMXM4dnd3KytDQkdIYVlFY0oxakVPK01uTVJxY3Bh?=
 =?utf-8?B?UmR6ZDF3NENBd0tqRWNTVFVHQUtvZ2Nwc0J5VU1uWVBwb0lJZVJOT0pRQlVp?=
 =?utf-8?B?bkpNVGVMTlBCZlBPdDJBWDRONkxldVBQVjQ3ZjFFdklKK0VkNG1IdUFEeXdu?=
 =?utf-8?B?bEpSNHIwbkZyaTFmb3BwOCtpdVVQN2FaOFUvSUJKZVNnQ1MzdjRQZTNURFBH?=
 =?utf-8?B?ZUlNUm5Tc2tXejJ6cE1VYlFxZUJqM0NSZ2NwZ0FpVWJONDYrMlMwS1pzSDFj?=
 =?utf-8?B?Ty9JV0dHWUtUZzdTK2FkQi9oZkNXdzZrdVBXZUJRR0lGK3RSM3FFZk5MY2da?=
 =?utf-8?B?N0tjano2d2ZuMWc3bTE3RnVNeGpuWnNwUXNUc09uTnoxeDBtdmNYdnE5RlpN?=
 =?utf-8?B?UU85OVB0U3I2eXo3SWl0QVhGbFFQeTZoRHNrTmpqV2NKaFo5T2NmbU11eU5s?=
 =?utf-8?B?eFR4L2IvVWhzcFN1R0lscFlTNWtPaGNXNno2Z1FZNi8yOTFDczVHZkl3d3JI?=
 =?utf-8?B?OEc3MTQvbTByYk83RWF3MGF3VTJoWVpKVzNBTk1ralBMY0VHZ1lvTndINEY2?=
 =?utf-8?B?NDdubjc4cngxQ0NCVk5XL2N0aWxyT0JRcEFncXFSMGZVYzM3c3ZlU0VtdWFp?=
 =?utf-8?B?Q2kvejk2OE1hVVhZQTFETnpiZGpvYlBDK3dRSDR1M3ZjbmkvRkJNOXAvTzEz?=
 =?utf-8?B?T25jMTlWZ1FaN2U1Vi9HNFZFd2xFZHpyOXVQWmY2MUEwdXVMeXhoWWw4R3Nw?=
 =?utf-8?B?SlBIZ1RXYUFaN0FFU3ErMWJrQTlrVm9VQ0RJNEhwdU5rMVB2cElVanFqVTBS?=
 =?utf-8?B?bTJjakc4THl4bUpJYlFLN1VZeXozeUNBOTdjb3EzaXNuVlVkeVIzRVMwQmF5?=
 =?utf-8?Q?+IoE0/hW5xZ766JDCuGQouG0M=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1hoQ0NkL1Z6SWFVdThpUWplSUozRXB1QnRsbVFNR2FSTDE1djMxdmt0NVNU?=
 =?utf-8?B?Q3RnOUVPUWwzRnRuemlvbENYWU9xQmNXWDJ5OXFMNHBUZGpBS2xNbzRJZlRX?=
 =?utf-8?B?R3VqdEhXenV3eDdiZzdOZnZwR244QTBsanZuRklnNVZacFJ4aVdtcjZJSHhz?=
 =?utf-8?B?VWFKQ081V2pSejVVZ01xUHFyd01qdy9WL2k1SDBFNHZNRFIvMEw2Tk5VcXhF?=
 =?utf-8?B?Sk02SUJKaXBHMUhFOGVtQ2IyL2tZdWc3clpqSVpyem5iVkNxOGs2UGx2TzhF?=
 =?utf-8?B?SmkxU2lJM2V2TkpoZkZpYjhpTVd0WnpxU3BqS0xoZWFWejhVZSt0T0ZRWWxO?=
 =?utf-8?B?ZnUzdEJPcHg3NS9SSzA3MzdCOWFhTVB1Z01OUmNDNE1XUWNsRTBmQzZ4YmVy?=
 =?utf-8?B?U1BWNnJxWmVxZXI3OVBxNEt0eURnb0cvelh6VVNJUXRXOTZDNGR5RnBJUU5B?=
 =?utf-8?B?SVVXRFZWbWFFYjA1eHRvaWJwanZOeWlMRms0cUx2Rm1oMnZ6Yk1lbXNmbEY0?=
 =?utf-8?B?Q2V1TlVtTCtjL3VWRE5ucHRvV2NqQUxDRzVaU2Ntanl0SzdPQzVNZHBnOUo2?=
 =?utf-8?B?eVVoNVZ5TGdDQlgzYnFWaFpwQjRDcWNsK3NuU0J3N1JQTUNRTGY1bjhNb1Zi?=
 =?utf-8?B?dWtpa2hheDFjSGR4emt1UHNmSlVPcE1CaG1NYWY2djUzUU9Nbnp5Uk1BMi9x?=
 =?utf-8?B?bFJVaEYvYi9NcUtab2FDSmNTVkl0VUFnMHl6bE9CaVl2THY1K24rdEZyTUhp?=
 =?utf-8?B?QUZqc2VrVGNOWllsMnZSUUhTMzQyRWl5QS9BUDRPQ1pzRGZmbThTN0E4N1lB?=
 =?utf-8?B?VXVxa3h0Y09Yc3hndGoxbWVPNmtod2psVHdCNEFveXAxd0NrT2tQbzlOdFdC?=
 =?utf-8?B?OXMvQkxuUlNyWkJuN1Y4RHBvSEtaK0o3bVZzbE5zTi93TDFBY2NvVmVUVWNK?=
 =?utf-8?B?eGdJU0VJWlc5a0pOVzBxZ2NIRkZLSzVhOXd6WUhOVnUwR1VQMnoxbldXZVZj?=
 =?utf-8?B?clN6WXNaQ3kyQ3g3V25WNHZYSUFTRHlYSm5IZFdvc3ZIQ3VnYlQ4VGNHMnhx?=
 =?utf-8?B?aDVaTk1tVzhrTjFqRU5LUnNmMlh2VjdVZ2hPd0djME5SZTdseWl1RkY5cXVM?=
 =?utf-8?B?VnBLRUNJLzB5Um5KTTVMTk5UVU9IOFpweTJSN2Z4cWsyQyt2UmtjdkVpRUM0?=
 =?utf-8?B?MjNob2hrN3grT0NwbTNKZHVtREtkM0hWaElwNmJNa0VFYlg0ZDVueEZMaGc5?=
 =?utf-8?B?ZGtFVEgxWjU2QVd5a29YeGRwMjNJNjU2dG1LVmNQWXlINTEzUDkrQm9zR0tZ?=
 =?utf-8?B?TitiZ1hqVmVrd3pIUW1aYjN6UzFpeEJick5JOXY0elNrai9nbDNJQmt5dGhI?=
 =?utf-8?B?TjFJQ2IwVmRDUVVwYUtncU9kM1BkamtnTFUzbE45L1RQTGpqZkwvTGJUdWIz?=
 =?utf-8?B?V1JqVWtSWE5LSHc1SXBCS1NBKzBmRFZKeXV0eDdCWUdONno2Um1kWUhqdS9o?=
 =?utf-8?B?c2FzQjJSTHBJaFdKMDdoWnIrRlRnRmxyOE9UeVlFeWtDdHpZeENCbVNoUGtk?=
 =?utf-8?B?aGhid0VqNllZM0JYWGdBM2ZCTU1HNy9DTzZFRWJWWklycmY1SjRDbkhRSXJI?=
 =?utf-8?B?V0g5N250b1pUUE4xMnUvWlM4eFNVZ3MvbklNTkJoZTA5UTZwbitBVG9yY3JM?=
 =?utf-8?B?bnd5MXg1dUwvZTh3MzVjZVdlQlUyb0JMZUVnVzBLVGo4bEhrU0tKYzMyU0lh?=
 =?utf-8?B?ZzdiYWV5L1pCQUJKQWJIMFNVdndUVjQ2SUdZMCs2TEp1anUrMlBudWE4a0pV?=
 =?utf-8?B?K1EzdERKUVBoaVd5ZXBPejlVaERQUjRXdENKczd5RTQ3NVhwditwSE4xQUVV?=
 =?utf-8?Q?Xwk4kmZaGTjJz?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 26234402-2e59-452d-9281-08df454e9430
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 08:33:10.4324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB999481

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KCnNyX3JlYWRfY2Rk
YV9icGMoKSByZXRhaW5zIGl0cyBjb21wbGV0ZWQgcmVxdWVzdCB3aGlsZSB1bm1hcHBpbmcgdGhl
IHVzZXIKYnVmZmVyLiBGb3IgYSBib3VuY2VkIGRhdGEtaW4gbWFwcGluZywgdW5tYXBwaW5nIGNh
biBjb3B5IHRvIHVzZXJzcGFjZQphbmQgZmF1bHQuIEEgZmF1bHQgdGhhdCBuZWVkcyBJL08gZnJv
bSB0aGUgc2FtZSBxdWV1ZSBjYW5ub3QgcHJvZ3Jlc3MgaWYKdGhlIGNvbXBsZXRlZCByZXF1ZXN0
IHJldGFpbnMgdGhlIGF2YWlsYWJsZSB0YWcuCgpSZWxlYXNlIHRoZSByZXF1ZXN0IGFmdGVyIGNv
bnN1bWluZyBpdHMgY29tbWFuZCByZXN1bHQgYW5kIHNlbnNlIGRhdGEsCmJlZm9yZSB1bm1hcHBp
bmcgdGhlIG9yaWdpbmFsIEJJTyBjaGFpbiBzYXZlZCBhdCBzdWJtaXNzaW9uLiBObyByZXF1ZXN0
Cm9yIFNDU0kgY29tbWFuZCBmaWVsZCBpcyBhY2Nlc3NlZCBhZnRlciB0aGUgcmVsZWFzZS4gVGhl
IG1hcHBpbmcncyBCSU8KcmVmZXJlbmNlcyByZW1haW4gb3duZWQgYnkgYmxrX3JxX3VubWFwX3Vz
ZXIoKS4KClRoZSBzY3NpLW1xIHJlcXVlc3QgcG9vbCBpbnRyb2R1Y2VkIHRoaXMgdGFnIGRlcGVu
ZGVuY3kuIFRoZSBsYXRlciBtb3ZlCm9mIHRoZSBDRERBIGltcGxlbWVudGF0aW9uIGZyb20gZHJp
dmVycy9jZHJvbSBpbnRvIHNyIHdhcyBhIHJlbG9jYXRpb24uCgpGaXhlczogZDI4NTIwM2NmNjQ3
ICgic2NzaTogYWRkIHN1cHBvcnQgZm9yIGEgYmxrLW1xIGJhc2VkIEkvTyBwYXRoLiIpCkxpbms6
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyNjEwMjIuc2NzaS1jZGRhLWxpZmV0aW1lLjhm
MzFhMmM5N2I0MkBvdXRsb29rLmNvbQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQt
b2ZmLWJ5OiBZaW5namllIFdhbmcgPHgtcHJvZmVzc29yQG91dGxvb2suY29tPgotLS0KIGRyaXZl
cnMvc2NzaS9zci5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc3IuYyBiL2RyaXZlcnMvc2NzaS9zci5jCmluZGV4IDRm
MmU4ZDFiZTZkYS4uYzY0YzI1ZTlmNDA0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc3IuYwor
KysgYi9kcml2ZXJzL3Njc2kvc3IuYwpAQCAtOTY5LDggKzk2OSwxMSBAQCBzdGF0aWMgaW50IHNy
X3JlYWRfY2RkYV9icGMoc3RydWN0IGNkcm9tX2RldmljZV9pbmZvICpjZGksIHZvaWQgX191c2Vy
ICp1YnVmLAogCQlyZXQgPSAtRUlPOwogCX0KIAorCWJsa19tcV9mcmVlX3JlcXVlc3QocnEpOwog
CWlmIChibGtfcnFfdW5tYXBfdXNlcihiaW8pKQogCQlyZXQgPSAtRUZBVUxUOworCXJldHVybiBy
ZXQ7CisKIG91dF9wdXRfcmVxdWVzdDoKIAlibGtfbXFfZnJlZV9yZXF1ZXN0KHJxKTsKIAlyZXR1
cm4gcmV0OwotLSAKMi40My4wCgo=
