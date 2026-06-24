Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010065.outbound.protection.outlook.com [52.101.201.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9983322D7A9;
	Wed, 24 Jun 2026 14:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310008; cv=fail; b=S10uYNggKUnJcHhHQyZh6dGg5k3i/PNTFB7JhmTcZpGX5PiQ1UuFw2ZRPzVFjRmrB2ZksT+ly1C/Cm6MAEPu5c3etwLxtYdls+c/oxdtr4QxhMmC2PWpKDz93R+QGzZFibL9+nW0nzt/htXOHY6ar+Wiy8d2/4bUf+/Xgm4NiXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310008; c=relaxed/simple;
	bh=3TpzWbRLbscNS4sxTSoRWJ1/wRjkTPp1hc4WN3iZo2c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h8zSdV0YS/D0EGKRN2dmctWnbJR6sel3dR8ds7ln8EiKBMPn+OZ/nZYZ+5fVMNytHWHbpaXlip1D+eum2Zo2c1Q1vDy50yE2Cb0OaA1tpFFiViOhU3nWp8aFEMTo+cuo83R1AiPaieHb3TqD5jIT6wYpqfLGsiCEdQ2R5txilEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=afwN8AZK; arc=fail smtp.client-ip=52.101.201.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="afwN8AZK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewqgq+MYBNmgJ9ggkuin1hBy5Key0aQD9xhFlHGdhzAdNRNKCnEJA5Pg8t8iNMOWVHbmDM9OzuaJOwXZA8hodXpjX/t+WWuFoTWl+z1ypuuFqc/QpEp7AHRmPCzxEXQwGobtm5hdsQR+3xLTQdg/gT2mbWmgYltj8bnymFv5Cr0Ji3PcemBQ3ulwvWic0X2jy1dXJQdK+lkK5XuO8ZvV1/HJpsY5FESwvjj/ma9xl60ujufuFFfBevsVkELvveX4r5TmNVvYSgf2dO8kfF4EfKNhwYtfNZBorioHsPF1Qpg/E6Ln+1JUKEgrD4KzSVbAC65QazrJ7fkz9gtS0Q3x0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TpzWbRLbscNS4sxTSoRWJ1/wRjkTPp1hc4WN3iZo2c=;
 b=DVsd+YoQMwOHi4q+3+EcJr/bpRFQiOOP2gJpwib8xGgxySmILxWpBF8B7WpM/ss/gKXq5Ild5jGSklmNwI4WYdLNxYrQYMP0KNKo0bybplAKzvf7JofYkB68mJfMpCDXbSyYN4SjBeWXyNOmrubJRBNmAeU7t9mDwrY1OSKEDQshkFWi0AYPA6H0SV0vf5tdj3f13nUdEqwrz+09yTykgP3gbgvQhhRAfkdsi+cFFiVQ2X0L8VlCmG5GDiobFea4p+IaRCAS1pqcq/D5Hy6ubWXvu5i4WoS44DirnPzQ11chtsKrTAUt3IhoZdnNTGzljtalhN6Y8JlH1DxcpY+G5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TpzWbRLbscNS4sxTSoRWJ1/wRjkTPp1hc4WN3iZo2c=;
 b=afwN8AZKNU6d4AEm0722lBCfPpFOLHYa5GU0h56SRiws0y0g4QAjbUxiKwvjEoLEZmTLUBDasKQqczSn5yoWkvWyhg+Xbyqq2a4G8QQ0n7gQz7GUdC0sFP+/3UhBOO7TMmiArih1g+k9I+mrWksj33ONtFs8uXIZbj3RXWiU0ece79FGtYHjwfpWflz5l5EWJRft9FjHYFzHGBayFDeeekHtAfWd3sZNc9ULiIAuWLyEpALlms9ja4ToGOKt9LB+dLYSQxUPPUGTZxcgrlaysI6xjqW6bLvyMlR139ftbKlmd6eAp38hoLD+2cH4Z70oEVT461h8FpNsMaYWyOpw3A==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by SA3PR11MB7461.namprd11.prod.outlook.com (2603:10b6:806:319::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Wed, 24 Jun
 2026 14:06:43 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%4]) with mapi id 15.21.0139.018; Wed, 24 Jun 2026
 14:06:43 +0000
From: <Don.Brace@microchip.com>
To: <haoxiang_li2024@163.com>
CC: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<david.carroll@microsemi.com>, <justin.lindley@microsemi.com>,
	<scott.teel@microsemi.com>, <storagedev@microchip.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: Re:Re: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset
 path
Thread-Topic: Re:Re: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2
 reset path
Thread-Index: AQHdAmBjE9j71K4IqkGWSUInwrj2jbZK4SsRgAJabgCAAISIlw==
Date: Wed, 24 Jun 2026 14:06:43 +0000
Message-ID:
 <SJ2PR11MB8369F4ADD8F072D04B62BC5EE1ED2@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260622160028.1240496-1-haoxiang_li2024@163.com>
 <SJ2PR11MB8369CC3A2E487829E96057BAE1EF2@SJ2PR11MB8369.namprd11.prod.outlook.com>
 <3881ced5.4b48.19ef8408558.Coremail.haoxiang_li2024@163.com>
In-Reply-To: <3881ced5.4b48.19ef8408558.Coremail.haoxiang_li2024@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|SA3PR11MB7461:EE_
x-ms-office365-filtering-correlation-id: 32e6e491-b5be-4530-03bb-08ded1f9d1f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|22082099003|18002099003|11063799006|4143699003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 kt1z1o82NrMP4Ha2UExUfNHqoY0aERsqmmjUhz+brkhuh0QdOTk9bKiyndDKc4VpcBlETaAZrEzdfCg1iOYP9DefAknhiPCTK2fUY57Ob9Nnlx7Zy9XKuw45QKy3aVzrmuykSYa1tQBCO0k8MYAa3BtQZi7v1WAGsakZcQBdhCFx98Bk55zUP+EGYcJ5ZYa1vNFTiriJfS61qjQnfaQAk0RCSSYppGa7tqU5CvdjtBy+IcsqS71Qoj0oJLOqLAnnyA+qH/9L66CZqnHCWVgb+WY1/qgw7VazouZxZWyXFHYa/LvRZWslXZR6kWum0xqo0Cptu+PP6usQSRywyaOP41NeJnvmAM7rQ2NIWhrkvx2SitnhDsaJjsG3xCnz3r6oDhyYldEeaMLRlmO/L4YKWrj59MvB3C53YmujPI39cKErJNe3CjnF95JF1JlA2nH4DvcpK1b+uQXcv1YbgeeanNkNdygha/GJYijdeh3FJB1H2N7PbuGU8SdaLz6BnMzuX2HRWzYnhpQ9aOSdXhylaWGmQh7bycZX+xXDatnViz59RMlsyapHtPx0H46CagYK00P79dp9hydAci35HPOO9pbY1u9hNDxRyKqMG1Yi0U2ZL/SgfFpvb49QAWM03KdBhyQj9MR5n6JLUsJ9LRN5d6uSvo2s0ybnRY5bMhP04uNM9GMy+g7thoI74JHFYh2mBnbfcJrgDwZuBAHs4EEfIUALyNeKdL0wcv3ZFs3uTfU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YVVHeitjUm1LUU1OdTZJMDRCWHRtQ3krNTJZUHVSNklTdmhrMHlKOEhrNFl1?=
 =?utf-8?B?RkxnRG1FTmJYSmxsRkVBTWt5dTVXcVhlVjYyY1lTaVg5QTBCSTJ5Um44OGJO?=
 =?utf-8?B?aVBvM2VackJJMWJEWWYvOVZ0cmIyUXBMYjFQTUFoMG03QU8yczFqUVdjK2NI?=
 =?utf-8?B?ZWFuVXdwbWFKcTF2am03MFlyY3hnYVFyWTRMTWFkMU1HSjhXbURRZy9CaFZy?=
 =?utf-8?B?V2xjUVBDR25TK0kwUTdDUGhtRUVoZ25WenpydkdLWVNDeUFSaWRjc2ZCQnYz?=
 =?utf-8?B?V2RNUnpOeG9GSFI0R1FjY2lLV0o2SVZwY1U4WnBFQmhaVzBJQWprSnlLc3RD?=
 =?utf-8?B?dWQyc1k0SXNESjFxSlFTWGVmV3liNTBlczI1S3ZrU2NoZVltcTdKaGtVZDFt?=
 =?utf-8?B?ZE1JNDZGeERzSXVDMEdkMFRmUGlZWE02UHRuRWJkdy9pNS84QWhEZWg1QlBL?=
 =?utf-8?B?YW1oYndaOE9vRTcvTGxpS2hUN0FuYXliVlBmMXhFWVJIcjhGYzhmMVZGZ3J6?=
 =?utf-8?B?dE8wTHhzNW1rNmZVNmtwYzBMOFNscE9LWTN4Rm5tYmNOOGRhRWZxcXA3d3pK?=
 =?utf-8?B?eFQ5eC9KS2NKOVBCaVJRd0JwaWZFRTI3RVI4UkxqWnNQQ3drRDVMZ2UwUXRP?=
 =?utf-8?B?Y0czMkx1aDZ0T2dxbngzVFZhc0VxeFNOS0FCVmZHV3dzZ2FSNEt6TzF0RkZ4?=
 =?utf-8?B?UWFzVklJZjFYRVJwTmxXbStyanJSQlo2aThpTXREMVM5U3J3SGVFUEU0VmNB?=
 =?utf-8?B?VFVCZ2dTWi9sTUxiTzNvZy9yUXc1a1NkWDNTS1h4QkcxQ2xha04ybkFkaWlF?=
 =?utf-8?B?anJDWmw4M3BmbWVJdVBmSW1nbklrdkYzMStCekRIN1JFbXRXa3M0dkJISXVM?=
 =?utf-8?B?cm1DNFRUNWpMZEdiUllWdDBIaVZXSzNUUUJQRUZJdTNjYTN5aExmY2xYZzRx?=
 =?utf-8?B?US91QXdPRDhFZy9rTldKN1lmeEYvTUJ2NDI5bjZmenFNMnlzV0dZemlLZmlO?=
 =?utf-8?B?bkEvVHZOK0dUczBPeWI4TE5EN1czM2JTL240SlhyTjRRbGJpZlhydjB1b2cx?=
 =?utf-8?B?TGIvajdZL1h0cEFJbHRNWCtnSmx0UGx0U0pFbTZCS1ZicWIvMzVBc3RKakNo?=
 =?utf-8?B?dzJEakM2Q29tS3NvenRhT3VXQ0ZHQjlCZzhLMnkyTXAyekEzU0VIdUZDL3JU?=
 =?utf-8?B?WGovS0VvZkVhTjYxYWFSZUtsZ1d6T0V2dE1HT2k2NUFCYTRwOGlYanZvdGJI?=
 =?utf-8?B?cUt4bVcvOE9ISmhrWVZTNEp4TXJtQmZUcERHSitsbWxwWFdUMUFNYWxNVm5r?=
 =?utf-8?B?N1ExUE9kUnZnS0M4b2JwVVBLV0FIQkh0OW1sUzNudjBleFRKWDZ6bjJSM1FB?=
 =?utf-8?B?L2hiS0szY3FKOTJFaHRMOEwwb2lLY2JBanovOE9qQWtxRlJzRUJnNm9aREl6?=
 =?utf-8?B?NkY4cGQyNHNaUHNWSG5BaURqN1lTMlB2c1RXVnJFQWZGUTJuclZsWUMwTDdD?=
 =?utf-8?B?eDN5RjY2b0xBN0YvZnFQNFFqVU5XaG94QkQvNWo1eU9jWFhwNVE3T1R5ZFBS?=
 =?utf-8?B?MTE2cU94aVRLdkd1cEJrUW1GSDkzV29JQ1l3VVNrLzNMUkxoc21XR0xCZU1t?=
 =?utf-8?B?dk52TklrZ2xudW9uVDRXanJHak9SNmEvc24xNkVwZ3h3aHNlL0ZjdDJlOVB2?=
 =?utf-8?B?Y0MrdjNWSkpGRzNyeDVCVnR1S0x2YjJUcDJ6VFZUSDlZTkVwUjI2aTk4QTlh?=
 =?utf-8?B?MGVCWHlKellxaHQ2dERmc0V4TFJ4MXNJR0dhZjdpVEtLWVRDOGhKUmtVclM2?=
 =?utf-8?B?WTNheVptNXU0VTgzNllpVDBqSnVGQlVpTVdMZ1hGR0E4VkxlOEtSczZxWVBB?=
 =?utf-8?B?U2N3MXNtaUJyUU9oVkFtUzV0Rm53SHFPazNFekpsaFFXek9NQ3RKSmVVTU51?=
 =?utf-8?B?ekhqOUVmWVI0ZXBpdHh6U0VsajlVcEs5aS96dnY5N1VKRVZ2U2RzZmVGMW9I?=
 =?utf-8?B?bzc4a25PYlAydkYwWWROVTcxenNmdVVDM1dTWGJrOVIxZllYZi9yQTMvVnlK?=
 =?utf-8?B?Vlk2SDlxa0ZQUlR2ZVg0OW5PcTFjRWxJRnR6eHRUM0E4YlVVUWtKQjZ1ekxr?=
 =?utf-8?B?K24yK1gvRHNiK2VFak1CbndqdFUvUUMyYnZNWFRVZ1RPNSsrRURqSlJ3SWVN?=
 =?utf-8?B?cDVDWmk3WmJkUW5Zb0FsNDdOYVNKeDBoeXlhTTRIU28rcklsOTFvZFhFZGVn?=
 =?utf-8?B?YTlvN2JROEwzd0VNc0kwR3hac0FvdThDMHhEYThTcFNjd1gxQUpHMlpoTGcr?=
 =?utf-8?B?eU5HOGpBVXZmYTZXTUoxVUNjR2JMVzRNYWFKZVpCQ3ZKek9JZnF6QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e6e491-b5be-4530-03bb-08ded1f9d1f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2026 14:06:43.2253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ml3FV3cgl205v/6lfvx1LDWXrE8IHnSrk573smsoz0d7L7OOm1A2W1SqbRgfSZWnYmTpeb9Uw0ZB1i/0XrbWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7461

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpGcm9tOsKgaGFveGlhbmdf
bGkyMDI0IDxoYW94aWFuZ19saTIwMjRAMTYzLmNvbT4KU2VudDrCoFdlZG5lc2RheSwgSnVuZSAy
NCwgMjAyNiAxOjEwIEFNClRvOsKgRG9uIEJyYWNlIC0gQzMzNzA2IDxEb24uQnJhY2VAbWljcm9j
aGlwLmNvbT4KQ2M6wqBKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tIDxKYW1l
cy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tPjsgbWFydGluLnBldGVyc2VuQG9yYWNs
ZS5jb20gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsgZGF2aWQuY2Fycm9sbEBtaWNyb3Nl
bWkuY29tIDxkYXZpZC5jYXJyb2xsQG1pY3Jvc2VtaS5jb20+OyBqdXN0aW4ubGluZGxleUBtaWNy
b3NlbWkuY29tIDxqdXN0aW4ubGluZGxleUBtaWNyb3NlbWkuY29tPjsgc2NvdHQudGVlbEBtaWNy
b3NlbWkuY29tIDxzY290dC50ZWVsQG1pY3Jvc2VtaS5jb20+OyBzdG9yYWdlZGV2IDxzdG9yYWdl
ZGV2QG1pY3JvY2hpcC5jb20+OyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyA8bGludXgtc2Nz
aUB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIDxsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZyA8c3RhYmxlQHZn
ZXIua2VybmVsLm9yZz4KU3ViamVjdDrCoFJlOlJlOiBbUEFUQ0hdIHNjc2k6IGhwc2E6IGZpeCBE
TUEgbWFwcGluZyBsZWFrIG9uIElPQUNDRUwyIHJlc2V0IHBhdGgKwqAKRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0
aGUgY29udGVudCBpcyBzYWZlCgpPbiAyMDI2LTA2LTIzIDAyOjI2OjQy77yMRG9uLkJyYWNlQG1p
Y3JvY2hpcC5jb20gd3JvdGXvvJoKCj5GaXhlczogYzVkZmQxMDY0MTRmICgic2NzaTogaHBzYTog
Y29ycmVjdCBkZXZpY2UgcmVzZXRzIikKPkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj5TaWdu
ZWQtb2ZmLWJ5OiBIYW94aWFuZyBMaSA8aGFveGlhbmdfbGkyMDI0QDE2My5jb20+Cj4KPkFja2Vk
LWJ5OiBEb24gQnJhY2UgPGRvbi5icmFjZUBtaWNyb2NoaXAuY29tCj5UaGFua3MgZm9yIHlvdXIg
cGF0Y2guIENhbiBmaXggcG90ZW50aWFsIHBlcmZvcm1hbmNlIGlzc3VlcyB3aXRoIGRldmljZXMg
dW5kZXJnb2luZyByZXNldHMuCj5XaGF0IGFib3V0IGFub3RoZXIgcGF0Y2ggZm9yIHdoZW4gY2Fs
bCB0byBocHNhX21hcF9pb2FjY2VsMl9zZ19jaGFpbl9ibG9jaygpIGZhaWxzPwo+Cgo+CgpUaGFu
a3MgZm9yIHlvdXIgcmV2aWV3ISBJIGNoZWNrZWQgdGhlIGhwc2FfbWFwX2lvYWNjZWwyX3NnX2No
YWluX2Jsb2NrKCkgZmFpbHVyZSBwYXRoLiBJdAphbHJlYWR5IGRlY3JlbWVudHMgaW9hY2NlbF9j
bWRzX291dCBhbmQgY2FsbHPCoCBzY3NpX2RtYV91bm1hcChjbWQpLiBJIHRoaW5rIHRoaXMgcGF0
Y2gKaXMgZW5vdWdoPwoKWWVzLCBnb29kIGVub3VnaC4KVGhhbmtzIGZvciBjaGVja2luZy4KPi0t
LQo+wqBkcml2ZXJzL3Njc2kvaHBzYS5jIHwgNCArKysrCj7CoDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKykKPgo+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9ocHNhLmMgYi9kcml2ZXJz
L3Njc2kvaHBzYS5jCj5pbmRleCBhMWIxMTZjZDQ3MjMuLjhlZGFkMTgzMGFiZSAxMDA2NDQKPi0t
LSBhL2RyaXZlcnMvc2NzaS9ocHNhLmMKPisrKyBiL2RyaXZlcnMvc2NzaS9ocHNhLmMKPkBAIC01
MDE3LDYgKzUwMTcsMTAgQEAgc3RhdGljIGludCBocHNhX3Njc2lfaW9hY2NlbDJfcXVldWVfY29t
bWFuZChzdHJ1Y3QgY3Rscl9pbmZvICpoLAo+Cj7CoMKgwqDCoMKgwqDCoCBpZiAocGh5c19kaXNr
LT5pbl9yZXNldCkgewo+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNtZC0+cmVzdWx0
ID0gRElEX1JFU0VUIDw8IDE2Owo+K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXRvbWlj
X2RlYygmcGh5c19kaXNrLT5pb2FjY2VsX2NtZHNfb3V0KTsKPivCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHNjc2lfZG1hX3VubWFwKGNtZCk7Cj4rwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAodXNlX3NnID4gaC0+aW9hY2NlbF9tYXhzZykKPivCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBocHNhX3VubWFwX2lvYWNjZWwyX3NnX2NoYWluX2Js
b2NrKGgsIGNwKTsKPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLTE7Cj7C
oMKgwqDCoMKgwqDCoCB9Cj4KPi0tCj4yLjI1LjEKClRoYW5rcywKSGFveGlhbmc=
