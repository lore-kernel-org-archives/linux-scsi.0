Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794045027;
	b=vyU/y3FvcAZ1Cu71SNBL75s/mrmQ/Wrqq/uupzrcP990CisR4G/EwWxexWn5isuvOnXc
	 XewIyjFuuX4/ZR2SeohbO+Vy/ytJ3ms6TvEYagmKrjtTppq+mEwZ3ZvldrJXCi622urwd
	 xgtupNMCYYjyuVOqOOKLpoo9d49+S0jaIatb9PbL45vY7z0MawnHrSqjE03TkC5gQ5L0Z
	 iZ/o+DFOxX8Lvze92JqCGF7WqGyh/yhy9nhuxOHjRUIltuZor/3d6fgAs95+IgVBs4Smy
	 PN+Anl14pixcfG0zB0IovScnkWlQ8t+lumhM0plQ4tW3mq8nzHqyi/R5ja8Pk4aETbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045027;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=k9nXjdl7t84zf+IpLutETXQ6OvxifO7/ZVNtEnhAyTk=;
	b=m6yHOxJ7fEH1j2Auj2K/UQtQRN29ddSQIaWTXMnd0rK+jnXNSZWCvRsrEmcy0KCe+Cqk
	 BfWZlEPXvErOsYw+nJAESfM0wuW70Q2r17gKribcKDatEgnolOvtW5T9GuADxSPO7IxmZ
	 vFMTj9KXhIXSZ+9NrjRU6Nf/4n/G7ZO5iFmw13gKT1Qy4uxK90ZtP/k7YLmRRNXq5cOPS
	 gLLLSYp+/MJYVUBsbItg7kmiMyhbl9aVp29iMsq+mhyEjFmeIIj93H28QeULgsoYWDm/h
	 moOaPdk4TMrcWl7JazLA6ji9yznNBBdCK+SaG9Q7FdL+inbidp/SdwJKkHwp1V/4obw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=fm89MjOO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.46
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012046.outbound.protection.outlook.com [52.103.23.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A29C606A32C;
	Sat,  7 Nov 2026 09:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A29C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=fm89MjOO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e76Km5aM2uzusYklgJ8wLmJyT+ZvWP07/NsepreTSRndO0yUKOnLGd3vio0JO+fuTgzl723rmjWRZlxE5nLl0fhEk/lWKa91Sz3UEoCRn1/LgM1kx10C5E06/TMDOV0MN7AI/HHjBdTB+sYbjIzLC96cNtdlPu6+C5pVBtv42MspTNID9KcoLi16bicFH+FHO97TC3vP7/ACwwlsA0FVbdGevFaz0/08jw28cCgILOedrPlLu64Sq6JxBdcsc8q1aznaNwMIZXuVRrDj8XdkoqTfFkWdCvRZgHOJa7Tw3cYPvainOQn98bYYPSIBWxOAkFDzZz7e1XcSAyqET2yeMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=k9nXjdl7t84zf+IpLutETXQ6OvxifO7/ZVNtEnhAyTk=;
 b=GP6OfE1g5WN/unZ2fU1PMS8z4Ag5fSmdDl0qGCdlI0SWnIXN2VkOrbEv87m9S+UEOIWxxy0QFsLmEbgk+c3OMTyUyhiKXeAY5D2fA9pcFnyBBxKWmeCsKvDpNt0Nq6yhwoF1eVc5BqNpw2cfUwTifaCPf6ESfX1dxmVGuUmur3N739Nz0OGuoXB/rjvzOz++4YS5sAc1fIO7BF4aJwSoag6234bWqDWBqk/Vn3tZ5RFJi7y1pzdIXohzvtjX2/dDHAl2KkYXbx7UG+w2mevsN5fien3Dz8zA6+2lEpvM1fjVS49zc+BKqobbB9C54PViafz9MN5A+3UsYtXUPa+97A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9nXjdl7t84zf+IpLutETXQ6OvxifO7/ZVNtEnhAyTk=;
 b=fm89MjOOJC+i3KEioUpUU2L/G23jEF49Bm2yika5srNlZyIXsHx8i7d5gJEnZ0imyie2NUN35kyW7vsEx4A9Z9iudkT2o25vREJry4ckdYknNlzxT/vx50iSfoG8wV5eRPrQbDyN/OQ9c8g5MojosCcPmWh8XOOcWAe3au0616cqJL1XUWasaCcpxlREfLlQ0MZYcPcDypRgBLsuXwwMH1HKWbjLlsFoczuMfbzyWM38Tm21AgprPvV76+AaPXLlH+x8rhV5MLpw/zNwEfPBzfr7ULdCerFGok58BLed9GMsiZEcwawIlInu6fvGfpJDzfZSiF8/0GyxiANj0MrreA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SA6PR05MB10700.namprd05.prod.outlook.com
 (2603:10b6:806:409::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 09:50:24 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0592.010; Sat, 7 Nov 2026
 09:50:21 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
CC: Yingjie Wang <x-professor@outlook.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, Yang
 Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>, Pavel
 Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 0/6] scsi: release completed passthrough requests
 before user copyback
Thread-Topic: [RFC PATCH v3 0/6] scsi: release completed passthrough requests
 before user copyback
Thread-Index: AQHdbp1nHAyvIAYETEqxBtgMV2YLJg==
Date: Sat, 7 Nov 2026 09:50:21 +0000
Message-ID: <cover.1794045010.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA6PR05MB10700:EE_
x-ms-office365-filtering-correlation-id: 6c8aee89-e7d1-4b62-40d1-08df3cb48a00
x-microsoft-antispam:
 BCL:0;ARA:14566002|5062599005|8060799015|19110799012|24021099003|41001999006|31061999003|22091999003|24121999003|15080799012|8062599012|12121999013|38102599003|4140399003|25010399006|16041099003|10035399007|12091999003|1602099012|40105399003|53005399003|102099032|3412199025|440099028|4302099013|19061999003|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?TFY2MDl4c0RTZjFZQmhYbGZuMVQ2b0xiQis1SDlQNHExWE1PZ1J0cDRJUnc3?=
 =?utf-8?B?WlBtNG00dXBSWFVaalFtTFNUKzQ4UjBJMmxkV0lMZlFocElnd1VlanArbERx?=
 =?utf-8?B?bEJBSXBPTVhvNVg3NXFxNjVjSEQ0QUdpU0xldnZPa0tWeG5nTUczN1ZzV0hT?=
 =?utf-8?B?eHkwd0g4TU9GOUdEbG9jNDhlL0xpTWpPNGxtZ0ZuNHRPbHhaVWpJaysxUkF2?=
 =?utf-8?B?YWhHczloTEVZSHp6MTZQdEFWdGt0RTBpQ09ISy9YYTQwZldLbjMvRkM4M1hi?=
 =?utf-8?B?QTgrZGpsZ2J3S0VMY3ZhUGVZZGcyT3VpejRZd3VnLzZLdTMwSjVWRGlMVzUy?=
 =?utf-8?B?UEs4c2lCRXdVTUVKVUNWSzJQamdRNkNzUXhZV24vM0RGT2RYTFcyU1doRm1l?=
 =?utf-8?B?cmV6dHF2T0EzKzcyNWRjdDdqdDhtWnFvYjl1R0h4L1ljMzQ5L0pZQnNPb1BM?=
 =?utf-8?B?NG9XOU1JMk9TVHNaekJlYUZOMno4VG1XV05kTURNRlI0MVk5dTF0eWhsYjJQ?=
 =?utf-8?B?OG5CSWRFTUdjUlBUd0NORWJDcSt0MzFPNzlaUm1DWTJUNjV5R2M4RXFtMThx?=
 =?utf-8?B?b0xOdEtjOTY1VG96a1liY0lRU1A0bnJDMGd2Q1dJR3B4azJUVGFHWDIzbkpn?=
 =?utf-8?B?QThJUmpocTR1Y2JrNC9TYUx6Ukw0NEpuVG5LVm1ZcFdkRFhXd1NQdTM1WmtV?=
 =?utf-8?B?WXNMcWhiR09tMWtSWUFxNXBCZm55REpCaEQrZW5jOUZpYXVqRDlVVUh1MS9o?=
 =?utf-8?B?L1Z0b3RKRmVtK0swY240cXd1NUNKNjBvaVBxVG1xSzJSQjU4Z3ZzNWRmdTlt?=
 =?utf-8?B?OHZVS0Y5OG5BaytFalpPMHlNcWZMaWtNcjd6cWJFYTc1UVNQMzBmRDZSdmg3?=
 =?utf-8?B?WHFkQXhOOWRGaFVQdnVXeXByOHo0STdsYzQxSStrY01KUHhQbG1ZRW1tKzhv?=
 =?utf-8?B?ZlRYcmpmakx5NHVGdXByNHh3ci9wSmJlQ3h5MEROY3RUei9mdXlJRCtqVmhm?=
 =?utf-8?B?a3ptV2hCVXFjQzNxVVZtanJPQlpMYmdmRGs5clY1Ly9WbTAxc0J6U2ZJaFdC?=
 =?utf-8?B?eGlldHYxaWpQUlppckNPbDNrUGFaenF6Y2QrVTZPWVRHaCtTdXBLZHZId2hC?=
 =?utf-8?B?OS9kbjJmeTBxaDIwTi94OGZXU1pPdVN1czNyNjExTzFBa3NoUTY4R2pLTUdw?=
 =?utf-8?B?ZXlnVjRSd2dFeG8vS3ovaTZXZ1F0WGtMaGJ0cHpKOUJFaUFzSU1aRENRd0pH?=
 =?utf-8?B?eThBNWZkbWx6WXdQaWxXeWhsT3VDWFkxU0VVUjZhd1VJTTJ0YWZ0NVBHbVRO?=
 =?utf-8?B?LzdBdGVJMzhFODlMaXRsaHFKVTVJQ3llQ0ZYdGNrWmlRb2k2bEVhNk0zQmRk?=
 =?utf-8?B?amdLV3RZbkhucEJHTFQ0YzVrOW9EY3NkZEwvRHJvM0s4NmQzQmo1cW00SmVh?=
 =?utf-8?B?ckcrVXcyL3JkUHpsT0JvTE54ay9WK2ZpTmNEclBZc3BKRjl3WE5xb1pnNG9I?=
 =?utf-8?B?NDZYdE5BQnMrK29PTmhwWGk3emxCL0E4Yzh4bTZ5ang1T0dGeFM1cGZxV1VB?=
 =?utf-8?B?ZndkRHdsSENzbzM3N3g4cm82ZjRtNEM2azBOZGxKVzVVSlcxbnYvb1YxZVJU?=
 =?utf-8?B?WEk5U2RmQ05yT1ZHUTFjb3VCaEZjM3RFZnkxUjVteDdNRmdDN2lteVY2S2VS?=
 =?utf-8?B?Rk5IUFc0UnUyZitwcDhFZGFDeWFONGRnbHRPYUloRjdxTkhJQmZyK0xwNUxr?=
 =?utf-8?Q?13+2PXny7a7USirgkCQnHIzzhqZwP1ZtiIMnpqI?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cCtCcTcwZk9hbnBYNjdyQ1ozdkdxaG9qeVI5ZXVSQ29hZEZVRDJGdnBUaEJV?=
 =?utf-8?B?TTFkWVZidWFPNlZiYStYQ3AvVHUvRHZnVE12a2JUdUVaL24yUmxqaTFxOTNF?=
 =?utf-8?B?TmJMTzE1QVBZeGdIRFRqaXRIM1g4REEwbGZ6Q1oyVXhLMDU5N1dydnFVTXlN?=
 =?utf-8?B?R2J1TXdGN1E1RVppdkJidlgwYmQyb1VBZlMxaDlLUm1LV25yY3p6S2l2clFR?=
 =?utf-8?B?Y1ZlZi9nc1MxeXFqTllrd3lHbEgvM1gxNWt2NDRsYXVzbEJJOVBkVzR3VHI0?=
 =?utf-8?B?RDlGTUE2R2pZQ3ZrSkRuREdkT2xDdVFyQmNhaGZjWWVPdEVQNmt2OTFvQmR3?=
 =?utf-8?B?aG8rNUN2UEVmbDNscmZsNCt6UFAySFE4MEl0c2ZGRGo2dTROT0xMVW9IQUI5?=
 =?utf-8?B?NmVLdUQ1bm53VEJHSVROOE9PSjFNT2c1cE90cmdqdTRIOThpRDRBQjhGa0FK?=
 =?utf-8?B?c1ByK2czclVOUnBCWW5WSE5uUTFVS3hsVlhpcGdNN2F2bmg5bDQ1SjZick9z?=
 =?utf-8?B?ZDlJdHpiY25jZzdyN3Z1cjJpL0ljcVNXVVpOWTlVSklzMlpVbmlLZzV2TDR4?=
 =?utf-8?B?aUhnell5TmE0TVNPUnA4Zm4xdHI3WnNUOE9kcDROK0JoNlErUCtjWHFmSU5Y?=
 =?utf-8?B?SEgwT2hqM21qYjI0TEpKNXNrNjdvN1ZoM1VtY1JSd29QT2pmMDk3citaYjZT?=
 =?utf-8?B?bDlmeko2ZXhTN01HS3ZiUGxoWW5OVGZQVGRXMmdVUkgyQk10RnJMQ2JlcFZt?=
 =?utf-8?B?WVkrWjIzcHpIdG90T3NTN1ZYTWdTNERmUTZmKzI4U2NCbEpUTlBwZXJ6Tzhj?=
 =?utf-8?B?Q0N2TGZScWV2TTZSQUpZdkYyd2xMRnhmTWM5TmluOGFnQms1Y05yb0JoM3Nh?=
 =?utf-8?B?cEhweS9TVHVzVzVWa0VNdkx5RWxMQ0FKRGJid2RqZG9ndHRmZVloMWZKcVNM?=
 =?utf-8?B?SVNKdUh1OE1BbFhWTlVRQU9tcUZtcjlIeHIwL3RaTFNhTUZJelZtTU04OGM4?=
 =?utf-8?B?M2haUGZBd0tQQTNYK3Y4N1N6cVJmUjJsYVFCdUFXd2pZeWNscDE4UDlTR0RC?=
 =?utf-8?B?UVE3eDNJSEEzRnJUMzVDSWw1WDFKb2V5Y2tkZUcrUS8vR25Sc2VpVEk2eHha?=
 =?utf-8?B?d0kzdytVMzdJVFpPSEIrZmppMmE0SkN2VVlhSG5VYVRVZXVBb0JlZnNJczhZ?=
 =?utf-8?B?cXpkZGhWN2djU080Y1dHdmVLUlBUZmZvRmJsalo2NVBBTzU1UU5iNzRrUW9s?=
 =?utf-8?B?Uk5CckVVRVo0QUlqVUJabGVkVTBKbXBRVXlhS2xYYVhMVUh6UHlQcUlrMmRX?=
 =?utf-8?B?bkd3aXgvaDlsdVY3bFgvZS9kQWxPbkRKRzhlUTdoc0xjK1VkNzBwVVNJN3lu?=
 =?utf-8?B?RXNjNDdEUkErOEFWL0NwZDYrWkxjQU0wOXBTMnc1SkE1ckhWMUp5cERKRHdh?=
 =?utf-8?B?TXVSbW51Vy9hd1VOTHZQSVBWa04zVW80cEFXSWt6YTVtK0VkMVQ5c2lyWlZF?=
 =?utf-8?B?b04vMld3ZDBDZDZtRDhYc1FjYS9VeHhzT3MrNkxhVGpZWm5UZjE1VU81U0Zo?=
 =?utf-8?B?K3FTMStNWGhCMEQ4NGxDaGRxYWNsS01sSjgyMGU2SXNzTzljbTNuenhXbzlO?=
 =?utf-8?B?UENYZitLODZtVVY0MDJSVGhXdUdOeGZ3NmcrcldHSDdncTRxVldxVmFTdmZH?=
 =?utf-8?B?clByNVRJSnN1VHVnZzE2QWd6VFVnUUxCc2NnSlJyeUdIYXNYaHp4M2syYS82?=
 =?utf-8?B?KzFNbVhnSWlkQjF6ZkxCR1pCRnFOWldVUkxUN2ZGcHJ1Z2pvK0FvSkYrTVRn?=
 =?utf-8?B?eUoya3lrMWtzWjNVRllVRllBNm8wVUxvVHAxdzUvTjVWTUtKNEZhcmZZQXBk?=
 =?utf-8?Q?gzTmzCAv4WCIC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8aee89-e7d1-4b62-40d1-08df3cb48a00
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2026 09:50:21.6939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR05MB10700

VGhpcyByZXJvbGxzIHRoZSByZXF1ZXN0LWxpZmV0aW1lIHNlcmllcyBhZnRlciB0aGUgdjIgcmV2
aWV3OgoKICBodHRwczovL2xvcmUua2VybmVsLm9yZy9yL2NvdmVyLjE3OTMwMDMzNjMuZ2l0Lngt
cHJvZmVzc29yQG91dGxvb2suY29tCgpUaGUgdHdvIEJTRyBjb3B5YmFjayBmaXhlcyBhbmQgSmFt
ZXMgSG91Z2h0b24ncyBjYW5jZWxsYXRpb24gZml4IHRoYXQgd2VyZQpwcmVyZXF1aXNpdGVzIGZv
ciB0aGUgcHJldmlvdXMgZHJhZnQgYXJlIG5vdyBpbiB0aGUgU0NTSSBmaXhlcyB0cmVlIGFzCmE1
MmYyYWQ0NTcyNiwgZmZiN2I1MzNhNDc5IGFuZCAyYjJiYjU1OTkwY2YuICBUaGlzIHNlcmllcyBp
cyBiYXNlZCBvbgowNGZlYjVmZDJjMjMgZnJvbSB0aGF0IHRyZWUuCgpUaGUgYWZmZWN0ZWQgcGFz
c3Rocm91Z2ggcGF0aHMgY2FuIGNvcHkgZGF0YSB0byB1c2Vyc3BhY2UsIG9yIHVubWFwIGEgdXNl
cgpidWZmZXIgdGhhdCByZXF1aXJlcyBjb3B5YmFjaywgd2hpbGUgc3RpbGwgcmV0YWluaW5nIGEg
Y29tcGxldGVkIHJlcXVlc3QuCklmIHRoYXQgYWNjZXNzIGZhdWx0cyBhbmQgdGhlIGZhdWx0IG5l
ZWRzIEkvTyBmcm9tIHRoZSBzYW1lIHF1ZXVlLCB0aGUgdGFzawpjYW4gd2FpdCBmb3IgYSB0YWcg
aGVsZCBieSB0aGUgcmVxdWVzdCBpdCB3b3VsZCByZWxlYXNlIG9ubHkgYWZ0ZXIgdGhlIGZhdWx0
CnJldHVybnMuCgpDaGFuZ2VzIHNpbmNlIHYyOgoKLSAxLzYgdGhyb3VnaCA0LzYgYXJlIHVuY2hh
bmdlZCBhcGFydCBmcm9tIHJlYmFzaW5nIG9udG8gdGhlIG1lcmdlZAogIHByZXJlcXVpc2l0ZXMu
Ci0gNS82IGFkZHMgYW4gaW9fdXJpbmcgaGVscGVyIHRoYXQgdHJhbnNmZXJzIHRoZSBzdG9yYWdl
IHJlc2VydmVkIGZvciB0aGUKICBjb21tYW5kJ3MgY29waWVkIFNRRSB0byB0aGUgZHJpdmVyIGFm
dGVyIGV2ZXJ5IFNRRSBmaWVsZCBoYXMgYmVlbiBjb25zdW1lZC4KICBUaGUgdHJhbnNmZXIgaW52
YWxpZGF0ZXMgaW91Y21kLT5zcWUsIHJlamVjdHMgbXVsdGlzaG90IHVzZXJzLCBhbmQgbWFrZXMg
YQogIGxhdGVyIC1FQUdBSU4gcmV0dXJuIGZhaWwgaW5zdGVhZCBvZiByZWlzc3VpbmcgYSBjb21t
YW5kIHdob3NlIFNRRSBzdG9yYWdlCiAgaGFzIGJlZW4gb3ZlcndyaXR0ZW4uICBJdCBhZGRzIG5l
aXRoZXIgYW4gYWxsb2NhdGlvbiBub3Igb2JqZWN0IGdyb3d0aC4KLSA2LzYgdXNlcyA5NiBieXRl
cyBvZiB0aGF0IHN0b3JhZ2UgZm9yIHRoZSBib3VuZGVkIFNDU0kgc2Vuc2Ugc25hcHNob3QuCiAg
RW5kLUkvTyBzYXZlcyB0aGUgcmVzdWx0IGFuZCBzZW5zZSBkYXRhLCBxdWV1ZXMgdGFzayB3b3Jr
LCBhbmQgcmV0dXJucwogIFJRX0VORF9JT19GUkVFIGZvciBldmVyeSBjb21wbGV0aW9uLiAgVGFz
ayB3b3JrIG9ubHkgdXNlcyB0aGUgc2F2ZWQgQklPLAogIHJlc3VsdCBhbmQgc2Vuc2UgZGF0YTsg
aXQgbmV2ZXIgYWNjZXNzZXMgdGhlIHJlcXVlc3Qgb3Igc2NzaV9jbW5kLiAgQQogIGNhbmNlbGVk
IHRhc2std29yayBjYWxsYmFjayBvciBmYWlsZWQgc2Vuc2UgY29weSByZXBvcnRzIGEgemVybyBz
ZW5zZQogIGxlbmd0aC4KCkNvbXBhcmVkIHdpdGggdGhlIHYzIHBsYW4gSSBwb3N0ZWQgb24gT2N0
b2JlciAyOSwgdGhpcyByZW1vdmVzIHRoZSByZW1haW5pbmcKc2Vuc2UtYmVhcmluZyBjYXNlIHRo
YXQgd291bGQgaGF2ZSBoZWxkIGl0cyB0YWcgdW50aWwgdGFzayB3b3JrOgoKICBodHRwczovL2xv
cmUua2VybmVsLm9yZy9yLzIwMjYxMDI5LnNjc2ktbGlmZXRpbWUtdjMtcGxhbi43YWQ1YzQxMTFk
M2JAb3V0bG9vay5jb20KCkl0IGFsc28gYXZvaWRzIHRoZSBleHRyYSBwZXItY29tbWFuZCBzZW5z
ZSBhbGxvY2F0aW9uIGRpc2N1c3NlZCBkdXJpbmcgdjIKcmV2aWV3LiAgSSBhbSBtYXJraW5nIHRo
aXMgUkZDIGJlY2F1c2UgdGhlIG5ldyBpb191cmluZyBoZWxwZXIgYW5kIGl0cwpuby1yZWlzc3Vl
IGNvbnRyYWN0IG5lZWQgcmV2aWV3IGZyb20gdGhlIGlvX3VyaW5nIHNpZGUuCgpWYWxpZGF0aW9u
IHVzZWQgdGhlIGV4YWN0IHRpcCBiZWxvdzoKCi0gRWFjaCBvZiB0aGUgc2l4IGludGVybWVkaWF0
ZSBjb21taXRzIGJ1aWxkcyBpbmRlcGVuZGVudGx5IHdpdGggVz0xIG9uCiAgeDg2LTY0LiAgVGhl
IGZpbmFsIHRyZWUgYWxzbyBidWlsZHMgdGhlIGFmZmVjdGVkIG9iamVjdHMgb24gaTM4NiBhbmQg
b24KICB4ODYtNjQgd2l0aCBDT05GSUdfSU9fVVJJTkcgZGlzYWJsZWQgYW5kIFNDU0kgbW9kdWxh
ci4KLSBBIGZ1bGwgeDg2LTY0IEtBU0FOIGFuZCBsb2NrZGVwIGJ6SW1hZ2UgYnVpbGRzIHN1Y2Nl
c3NmdWxseS4KLSBJbiBRRU1VIHdpdGggdmlydGlvLXNjc2kgZGlzayBhbmQgQ0QtUk9NIGRldmlj
ZXMsIDIwIHJlZ3Jlc3Npb24gaXRlcmF0aW9ucwogIHBhc3NlZCA5NjAgYXNzZXJ0aW9ucyBwbHVz
IDYgbGlua2VkLVNRRSBhc3NlcnRpb25zLiAgVGhlIGxpbmtlZCB0ZXN0IHdyb3RlCiAgYSByZWFs
IDE4LWJ5dGUgc2Vuc2Ugc25hcHNob3Qgb3ZlciB0aGUgcmV1c2VkIFNRRSBzdG9yYWdlIGJlZm9y
ZSBjb21wbGV0aW5nCiAgdGhlIGxpbmtlZCBjb21tYW5kLgotIFRyYWNlIHZhbGlkYXRpb24gcGFz
c2VkIDEwMCBzeW5jaHJvbm91cyBhbmQgMjAgZGVmZXJyZWQgbGlmZWN5Y2xlIHdpbmRvd3MuCiAg
RXZlcnkgZGVmZXJyZWQgd2luZG93IHJldGFpbmVkIHplcm8gY29tcGxldGVkIHJlcXVlc3RzIGJl
Zm9yZSB0YXNrIHdvcmsuCiAgVGhlIHJ1biByZWNvcmRlZCA0MCBDRERBIGNhbGxzIGFuZCBubyBC
VUcsIFdBUk5JTkcsIEtBU0FOLCBVQlNBTiBvciBsb2NrZGVwCiAgcmVwb3J0LgotIEZvdXIgaW5k
ZXBlbmRlbnQgZXhhY3QtaW1hZ2UgcGVyZm9ybWFuY2UgcnVucyB3aXRoIHN1Y2Nlc3NmdWwgZGVw
dGgtMTYKICBJTlFVSVJZIGFuZCBhIDk2LWJ5dGUgcmVzcG9uc2UgYnVmZmVyIG1lYXN1cmVkIDEy
LjgyNSB1cy9yZXF1ZXN0IGluIG5vcm1hbAogIG1vZGUgYW5kIDEzLjAwNCB1cy9yZXF1ZXN0IHdp
dGggREVGRVJfVEFTS1JVTi4gIFRoZSBleGlzdGluZyBiYXNlbGluZSB3YXMKICAxMy43MjYgYW5k
IDEyLjU1OSB1cy9yZXF1ZXN0LCB3aGlsZSB0aGUgc2VudCB2MiBhbGxvY2F0aW9uIG1lYXN1cmVk
IDE3LjY0NwogIGFuZCAxNi42NjUgdXMvcmVxdWVzdC4gIFRoZXNlIGRlYnVnLWtlcm5lbCB2aXJ0
dWFsLWRldmljZSBudW1iZXJzIHNob3cgdGhhdAogIHRoZSB2MiBhbGxvY2F0aW9uIG92ZXJoZWFk
IGlzIGFic2VudDsgdGhlaXIgcnVuLXRvLXJ1biBzcHJlYWQgZG9lcyBub3QKICBzdXBwb3J0IGEg
Z2VuZXJhbCBwZXJmb3JtYW5jZSBjbGFpbS4KClRoZSBpMzg2IGNvbmZpZ3VyYXRpb24gd2FzIGJ1
aWxkLXRlc3RlZCBidXQgbm90IGJvb3RlZC4gIENEREEgdGVzdGluZyBjb3ZlcnMKdGhlIHZpcnR1
YWwgZGV2aWNlJ3MgZXhwZWN0ZWQgZXJyb3IgcGF0aCwgbm90IGF1ZGlvIGV4dHJhY3Rpb24gZnJv
bSByZWFsCm1lZGlhLiAgVHJhbnNwb3J0IEJTRyAoYmxvY2svYnNnLWxpYi5jKSByZW1haW5zIG91
dHNpZGUgdGhpcyBzZXJpZXMgYmVjYXVzZQppdCB1c2VzIGEgc2VwYXJhdGUgcXVldWUgYW5kIG5l
ZWRzIGFuIGluZGVwZW5kZW50IGRlcGVuZGVuY3kgYW5hbHlzaXMuCgp2MTogaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvci9jb3Zlci4xNzkyMjM3MzQxLmdpdC54LXByb2Zlc3NvckBvdXRsb29rLmNv
bQpSZXZpZXcgZm9sbG93LXVwOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMDIyLnNj
c2ktY29weWJhY2stcmV2aWV3LjMxYjhkNmE3MGY0Y0BvdXRsb29rLmNvbQpDRERBIHJlcGx5OiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMDIyLnNjc2ktY2RkYS1saWZldGltZS44ZjMx
YTJjOTdiNDJAb3V0bG9vay5jb20KCllpbmdqaWUgV2FuZyAoNik6CiAgc2NzaTogY29yZTogcmVs
ZWFzZSBTR19JTyByZXF1ZXN0IGJlZm9yZSB1c2VyIGNvcHliYWNrCiAgc2NzaTogY29yZTogcmVs
ZWFzZSBsZWdhY3kgaW9jdGwgcmVxdWVzdCBiZWZvcmUgdXNlciBjb3B5YmFjawogIHNjc2k6IHNy
OiByZWxlYXNlIENEREEgcmVxdWVzdCBiZWZvcmUgdXNlciBjb3B5YmFjawogIHNjc2k6IGJzZzog
cmVsZWFzZSBzeW5jaHJvbm91cyByZXF1ZXN0IGJlZm9yZSB1c2VyIGNvcHliYWNrCiAgaW9fdXJp
bmcvY21kOiBhbGxvdyByZXVzaW5nIFNRRSBzdG9yYWdlIGZvciBjb21wbGV0aW9uIGRhdGEKICBz
Y3NpOiBic2c6IHJlbGVhc2UgaW9fdXJpbmcgcmVxdWVzdHMgZnJvbSBlbmQtSS9PCgogZHJpdmVy
cy9zY3NpL3Njc2lfYnNnLmMgICAgICB8IDExNiArKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLQogZHJpdmVycy9zY3NpL3Njc2lfaW9jdGwuYyAgICB8ICAzNCArKysrKysrLS0tCiBk
cml2ZXJzL3Njc2kvc3IuYyAgICAgICAgICAgIHwgICAzICsKIGluY2x1ZGUvbGludXgvaW9fdXJp
bmcvY21kLmggfCAgMjQgKysrKysrKysKIGlvX3VyaW5nL3VyaW5nX2NtZC5jICAgICAgICAgfCAg
MjIgKysrKysrKwogNSBmaWxlcyBjaGFuZ2VkLCAxNTEgaW5zZXJ0aW9ucygrKSwgNDggZGVsZXRp
b25zKC0pCgoKYmFzZS1jb21taXQ6IDA0ZmViNWZkMmMyMzg5NGViYzJjZGFmNGE0Y2MzOGI4NjY3
YjE3YWMKLS0gCjIuNDMuMAoK
