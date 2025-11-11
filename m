Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0180F3358A6;
	Tue, 11 Nov 2025 09:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762851810; cv=fail; b=VoCdMV5eWK0YsxigoySKxQ1F04tC85K7AkHME1Cwpf1jcxeuhGu4FJbNOx07/csdp77sj81Lg7D77SrfcOQwAAk1LBHcycaTsljOGLblxJXsR6aKAi2sm6QSkxFj8xssXFlbSSNmV4cI4h47KSQwh4gZ29jGEIt1IrhmRcWvvdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762851810; c=relaxed/simple;
	bh=SqhEbdhsL4yGnx0ZfvRcFPLhBfDiNnNp667zMcMLOBU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JtMv7AU3Efnl+F3qc/1gzgUxKCk9QOgCY11mxsbm/0wxdcnZseH9bR/SMYEvfEGq+2ml2gtxDJEaGK1hUSGocG0BkRQXyzEWmiKOGH7QHgrO9+9iSY5i0V7Kv84BFmTz7XPBNEPgzXJi++ha6pJUJ/dqqcoMa4TH4IzrqFU53Zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hI4U/jiK; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Z/3YYCmk; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hI4U/jiK";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Z/3YYCmk"
X-UUID: 44f497aabedd11f0b33aeb1e7f16c2b6-20251111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=SqhEbdhsL4yGnx0ZfvRcFPLhBfDiNnNp667zMcMLOBU=;
	b=hI4U/jiKTbQzc5C8FrG48Lz8O3zySwi/D+02PH4A60LvNz96+2ezwPhr/4hvp2fwPAIzW7pN5vgMizDbmi//KZ07Ai1Y0JcbtJ98EZudUMgB7JHMMDtXpZNKkzg5ZzMOQcH0nEHqUVKauEZwOddoJz5ac0WGZZuhcD7zUCChvcY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:4891df6c-e8f6-4dcb-b1a6-a4c4ac84a007,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:815a8582-b6af-4b29-9981-6bf838f9504d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 44f497aabedd11f0b33aeb1e7f16c2b6-20251111
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 757307135; Tue, 11 Nov 2025 17:03:20 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 11 Nov 2025 17:03:18 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 11 Nov 2025 17:03:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7cjTWRpK7loPnb5o6GJkcwvWh9CxF2KXzu/A1nCkevGm0aD13DO4feAff5mXzvD5JoDUS+Dt1mgUKr2/V3JI6rZI6rJWpLKcPN1WaZusTCofy05fNZUEKtWfrqRXGnFhHwLC8YbraeFAdi0n3YBodGUBpIod10fJ81xUaFZ/2VqV0/LaGcuRG/J/UDoqdCD6OhFXLzNPU+jrWe/vsWHeQwPUAz9kwUnuboHTGG0T7qZh+JiL8mvpPZjboqiW9vERhVFk5VHEvITE8PVf2ZDe6a9RJP3r7a2hb+69IWXuTwILX1jCHsYsR8B8YRNWgDR7DvaeY9hdDGF3YI7VXLMiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqhEbdhsL4yGnx0ZfvRcFPLhBfDiNnNp667zMcMLOBU=;
 b=uKYhklTSiCZIXWz3XFxux85JUXOpmKTtSBhe3thmFWRQ0dD8AJlSg4BrcjX2qlgIDlPPqB09B9G/B7ieKx8Mhvg45jQP83yRzNc/3NMU0IL9VqeFHPcu/U3htP5WRjQrDbHpABphYGjcLnq2SjyMeAdEDu/qXKOV2UmcUNvR1gKQZU1EugS5pCYodmIcpWBm6fyKFObbryuOuzPQhHSdOTtSellR6rMaDV6ZxRkwVtY+7ygRTCQCxJcQH04yfVNDNN9+Sgxnj+oNwAmzH/4jNtdsYsCYze+acjODI/kFIhHPs/K9xyi5AnxvIYUqanBDvZlGI/XOUXfNDTuLwIbaaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqhEbdhsL4yGnx0ZfvRcFPLhBfDiNnNp667zMcMLOBU=;
 b=Z/3YYCmke2lI105U2+YKl+98kE0n7QZ0HJubQG9wlIEShqMA4JJCXjDKyKpisDPa/egY8OGZP6hMZEdJrqj/yr5m9jfZnZCI+RC2aZytvWY1JXr1aAWEXCOZAWv9McxiY5L97hFvSq5z0NY020Cj7FSoHaOqa3F/ODUyPXiFGUI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6757.apcprd03.prod.outlook.com (2603:1096:4:1ec::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 09:03:09 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 09:03:08 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "sh043.lee@samsung.com"
	<sh043.lee@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"storage.sec@samsung.com" <storage.sec@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Topic: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAA==
Date: Tue, 11 Nov 2025 09:03:08 +0000
Message-ID: <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
In-Reply-To: <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6757:EE_
x-ms-office365-filtering-correlation-id: 33f9f10b-73b6-41fa-1279-08de21012255
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MTJ3TEFrUWZvKzlZSXdRK1dsWkFaN3Q2TWN1WUJmM2xPZmpJMFJGSkNPa0Fn?=
 =?utf-8?B?MjFDaHFGSUpwakVqRkNVWHRNZVhUcHI4aUhJV2JERHZ0SCtQUWFiTWpBK3Bt?=
 =?utf-8?B?aDhmY2VPY1M5cHdjWmZUM01ua2NXQmJBSmkwYmQ4NlgyV1ozNC9aczUrajJ1?=
 =?utf-8?B?Tmt2UjNVQUhIM0l3ZWxzQ1orOHRrRWRaS1VoellXK3VUcG1WekVydkZUTjcx?=
 =?utf-8?B?WVBuYU1Ld2VuSUdPWTJadEhRdGNObXBhMCtjN21RUEtkbExpWXNPMjd2cW16?=
 =?utf-8?B?dWRpa2pJTFduTmtpVDRKQnFIa2JuaVlRSEcwSjdWQnRIWHhMVTNMM3NRQm5t?=
 =?utf-8?B?ZUlwcVRuTUh4Slhra2V0TmtxNTF4ZUp2dXRqSUFrR1ZnNkdXbWNuL2kyYlJX?=
 =?utf-8?B?YzZHckFVUEkxR2tmTlhXZzdrNENXZm9uTHNaaVRuam9IZWZud1NZZkw5ZGNz?=
 =?utf-8?B?NkdKNUNCbzFuN0lleHpIcUcwUk9GN0ExdGh4d29ZaTJrRHJIc1VLWndCYm16?=
 =?utf-8?B?UmRnOUNDM05kU1YrdXZhbFVQWk9FajFTTUNTclIxZHUwRUlsc0NpZS9jU21G?=
 =?utf-8?B?L04zcGlBU1JLWURneFA5Y3Q0TkwwS0RaRmJvVHhCbEJIOU4yaGdXZzlsbVZV?=
 =?utf-8?B?MHlOMWNvVWo2WTJaR0d6Vmh6aUZsc2tJZ0VablZpdUJYeFpOT093b0hrZUUw?=
 =?utf-8?B?NUhCSlE5emlDNGwramRacUFJeHIrTjRYUDhqVE1vcnVtdE1qNFdhNW10Nkl3?=
 =?utf-8?B?MVQraU82eklIMHRmZ2tkRzRqQ1ZldGJkamRWWGtWQmxKS1loTEo3WjZ0ZUVr?=
 =?utf-8?B?OHA2RTFlUkZadDc3clNvb21jTkZ5TkYwcUVRbWZCTGJKTVk5QnNDYTNYUDU3?=
 =?utf-8?B?eDU2K3JEU0RjTUEvT1lyTUpVek1jcE1oNlRLNytBOStyMWZESFErV29kM1pa?=
 =?utf-8?B?SjBnaFg5RnA0TCtZQnd1NzdhUlMyeWUvOER3d0prcXEwcW95dDdNSlZUSzdx?=
 =?utf-8?B?YlVWWHA5Q3hNL1RCRnYzeU13MHY5R2lMNG5EOUhGTHZGQUtwbzhzU1g5RHpZ?=
 =?utf-8?B?U0cwTE5JM3l1RTJTQlhtNEljYyt1U0RkTURlV3dlOEtZMlBsNkQwSEhXbUQ0?=
 =?utf-8?B?VFFQSzhVeUlYalpKTkZzVzJsMFRsa0xEUW80WjhyODRKR2s0V1IvdEljQ3cy?=
 =?utf-8?B?UW1ObTJpMWx4bC9ITlBnWmhxdjFCUnNIcWViWDd5eWZSMkdlb0g2VFJ6ODFt?=
 =?utf-8?B?ZEFPblluenRhNDdYWEkyeDk3bTB4WHFTckFyVGpqV1FiMFc5ejZVNlpUVUN5?=
 =?utf-8?B?S1lpQlpoOE9qWU1LSVI2ZnpieTRXMDR6aFU0L2ZJNnF0UWcrY2M2NFU3QWVN?=
 =?utf-8?B?MXUxeXF2WmVETWZyR1Y5VlROSnkxbzIxQVZGR0k5dXlSdm54Tm1VdFE2MGhF?=
 =?utf-8?B?cUtiTGxJM3JwVmw4SXVHWDk0cG8xZWI5eFhqdC9kdTljUFh3cmd5aGpEYW4x?=
 =?utf-8?B?bUpHamVYb2tjL3ZWdHJGY0lZR0xZeUlFR0d0dUVuVngycFZYZm1wWk9nMHBU?=
 =?utf-8?B?ZlBYb296QkN2ZzNGMThlb0s1Z0d6Q1RZNGNMY0RjWXhEeFVUNzB4T1lzREw3?=
 =?utf-8?B?YThITjdIcVhSY0lRaXJTYUNMRTZ5RmNhNWpMb2dGM2U1azJYekpMak95Nllk?=
 =?utf-8?B?UlpLRlpoMDJZNUR1bFhaQXZsMlRyS084U2EvSDdUM25zMjlzaXFMRE9mVFJ0?=
 =?utf-8?B?cUxkRFFaWmNWZUxwdnFyeFdkVDVNVnVCN0JWSCtIVU54L1lWcExkaitlV1B2?=
 =?utf-8?B?VFljTGVBQkNocmh6NVZmZkp0cTQxdnBOcitvVlRxM25oL1lPUGhTaFp6QW44?=
 =?utf-8?B?QlZ1NFVqY2I0V3F2MlNKZUZXbkRORTFLdVN0WnJVVWYyL3R1YkxxQ0FyMVo2?=
 =?utf-8?B?eWVhMVBVeFFXWDg3ZkxPRFZMd1VQS3B4am9RTXFIaUtVdGNMc2trc1RZdk1P?=
 =?utf-8?B?RkZtNjVzY1JtbjVtL1g0V21yMkhUMHU1dmtqejM4UjBFQzQ2aUhrWE5yQ29s?=
 =?utf-8?B?bFYzNFdDUU1yZmM0SEk1aGQrNjRMRVRpd3RsUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU0zK2Z1T0l5bzlEYUpKUDRqTjc3ek1UQ1ZvYXczL3kzaklhekFobml6bys5?=
 =?utf-8?B?WmI0Q0xscXphalI2ZDdVM1lubTE1dkhTbG5ZQ0djd0lZbHJnZEhkdERROExC?=
 =?utf-8?B?ZThSbmZOSU5wOVZSU3E3WmJvTUZ0WWVuQ1MycUFTMkhrRUw2Vit0aHViTWY0?=
 =?utf-8?B?eHRIM2JEZ2hXRExHWnFUSjRJSG01ZVpxWFV6TXhROS9nWnpaOUlSRWNFcHlQ?=
 =?utf-8?B?c25vMUhMRm92NE1kdnhIbFMvbTJMU2xjYmdqcG5LUzlhUU85THl4R2hISW1w?=
 =?utf-8?B?Z2NQSHZaUlBlRFdxcDQvK2lrVm5qYTViUk9TMVEycDYxT3NJb1JhTWh4dVFl?=
 =?utf-8?B?dUxOd01ON09TR1VhV0ZheU9EYmt1ZG9GNnNvQmp5WUxVaXVBd1NGSFp6aEZp?=
 =?utf-8?B?YmxVUU9CWGZqVmc4M21Ea281Ni85aFdDT3g4YnFxb0ZkUy9tUVArY3J0YjZr?=
 =?utf-8?B?MXpTSkpXaExHRm9VeW1uclNVenFNZUlmTi9hMVN6T01naC9NUS8yNmRnR0VB?=
 =?utf-8?B?ZjdxSVp6cWtWVDJiUEhSVnhmS3hhTnZqdS81dW4wUzJQZTZvdXZGWm43aEJ2?=
 =?utf-8?B?eXk4ZUJNV1Y0NEFXZUI0cElYTXJvaldmNFp6ZTFhZjhXclVRMnpjTFpCcXZu?=
 =?utf-8?B?SzgxMXBEdUNDaVIrL1hEVk15dEdPTlFQV24xb0c2TnJsaVN1WWcvMks0NW8r?=
 =?utf-8?B?THNncSt5WGtVMFJPcXBuWHlWWUNsREJYN3lUSkU4Tkh1MHg1QlBrdE9EQ0F1?=
 =?utf-8?B?YksyQkZIajBwUTRHeWdtY2g2VkhZcVhtcDViaFBIaU5RVDUrSXhUQVg5Q2Jl?=
 =?utf-8?B?NUFqbFc3YlNLbEo3bGVtK2RQVGRoUVd4SGxoT2FMRkg4ekI0dkVrYTJpQXJZ?=
 =?utf-8?B?ck9lOTNOVjF5bXNRMHdyeTZJVENpQXBxNkhCa0xYQkl6ZnpxNERvQmV6S1Ar?=
 =?utf-8?B?SzhHdkdqWG90LzFjaUhTRmhxTnhkcXdUYlFHMGp3SjdJcTFTL25IOHFvTXFo?=
 =?utf-8?B?bVVVby9ZV0VDNy96MU0yM3oxdzRrcnpCMzVlNWVHWVNvMFFSMkNFTDU0YVBU?=
 =?utf-8?B?ZlNWRFBhc3R5M09kc2pwRFcycjdNd1VqNVBnb1YwMzFzZy9McHhWM2IwWFl1?=
 =?utf-8?B?YzA0bm9MdExDZkMrQkN4bVNVSmt3OTBKa3RVR3VnL2pXTU1GMmlmK1BQRG4y?=
 =?utf-8?B?eUJXZm96TG84cnd2YnRGL24rMHMvcGtYV2RXY3pJY2g4MmY1d1lpVFlYVzdz?=
 =?utf-8?B?M2FWUjVoR1hyclByS2crNDV3VnpXTERMOVY3QzlLNjV3T3JrNVg2c2xsbXlu?=
 =?utf-8?B?VjgvZExxbWR6UmlqWDdyOUt2UVZwc1hVa0N1KzAxV2dKZXBVeHJNWWdtcnBn?=
 =?utf-8?B?aHh1NklQNFFTYTlSVm16UytWeHYxaXJsTXF5YkxqdTlCNVU4NE5hSXNHankx?=
 =?utf-8?B?NTJKblNKVVRpWHVFL0J2NVU3aklmYlVIWjJabERHNis3aFRUTll1K1c4czN6?=
 =?utf-8?B?OXNqRFBaSndZbi91R3Z6bFE4SFpGSW9RZDRHVC92eHFBcHhMaEhyR2dTZmVK?=
 =?utf-8?B?N1RWUkFCWnBaSWNiKzNHNDZzQ0hNdkY4TW1FQW1aVGt1Nlk2ZHVVYjJPVmtE?=
 =?utf-8?B?bzVUV3JKL0tWcHVUK1JMMmpZYzFEYXd4K1FFZ1NCYmdEbGdSaHAydUdwUUNB?=
 =?utf-8?B?NXRqUlBBc0FUSGxHT0VwL24rNHNmUEhIV2pFT0xUU2UvaVRUMVdWWDFHVi8r?=
 =?utf-8?B?a05Nbm50R01KZWNvU1ZsRUp4UnJXbXc1VllkUDIyc1A2MVZyWW4wT1A2MVc3?=
 =?utf-8?B?MVhvaGdTZWp2dmE4V1pCRlc4WXpQTVIzZkFIR2pBMDlnSEZhVllmUEpqM2ds?=
 =?utf-8?B?dWQwM0hNWWhQcDNxbEMvRHBQRFhuSzNIRXNVeHBBVWZ2dml2UUdRTnFaRlZz?=
 =?utf-8?B?L0ZjTTFRaTRSa2dVYzJzb0R6K2hETHhUV2dNV2V5S3k5ZlBqWTM0TFQxOFNY?=
 =?utf-8?B?NS9OVStDNS9BRUQzZ05wdjhHbHhzRXlrZklzSVI4TWg1ajQ1TmV6SSt5Z1VJ?=
 =?utf-8?B?aG51YjdncHoyU3h1MElueTk5SXNqTUV4ZTl3V2ZFMXhLNGlYOU85dnplaks4?=
 =?utf-8?B?eGdSTi9uTDVsZVVuUnRvOERlOEhDVnhrODR0bHZZOVd2TzVrbW5zajQ2Nm4y?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F3360E7F1214146AFCA16BA35E7A5B8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f9f10b-73b6-41fa-1279-08de21012255
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 09:03:08.7634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8TM4RUkhCZrAme5ybc0UpQrJMiCSjFKGha2EckQ8Bvk02oJTEPei0GYVR7KY/MwKrs1J1Usys0bYsio8T20BUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6757

T24gVHVlLCAyMDI1LTExLTExIGF0IDE3OjQ0ICswOTAwLCBTZXVuZ2h1aSBMZWUgd3JvdGU6Cj4g
Cj4gCj4gVGhhbmsgeW91IGZvciB5b3VyIGtpbmQgb3Bpbmlvbi4KPiBBcyB5b3Uga25vdywgaXQn
cyBub3QgZWFzeSB0byBtb2RpZnkgZGVmYXVsdCB2YWx1ZS4KPiBCZWNhdXNlIGl0IGVmZmVjdHMg
YWxsIGRldmljZXMuCj4gCj4gU2hvdWxkIEkgcmVhZCB0aGUgdG1fY21kX3RpbWVvdXQgZnJvbSBk
dCBwcm9wZXJ0eT8KPiBXaGF0IGRvIHlvdSB0aGluaz8KPiAKPiAqIGRyaXZlcnMvdWZzL2hvc3Qv
dWZoY2QtcGx0ZnJtLmMKPiAKPiBzdGF0aWMgdm9pZCB1ZnNoY2RfaW5pdF90bV9jbWRfdGltZW91
dChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQo+IHsKPiDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZGV2aWNl
ICpkZXYgPSBoYmEtPmRldjsKPiDCoMKgwqDCoMKgwqDCoCBpbnQgcmV0Owo+IAo+IMKgwqDCoMKg
wqDCoMKgIHJldCA9IG9mX3Byb3BlcnR5X3JlYWRfdTMyKGRldi0+b2Zfbm9kZSwgInRtX2NtZF90
aW1lb3V0IiwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICZoYmEtPnRtX2NtZF90aW1lb3V0KTsKPiDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KSB7Cj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9kYmcoaGJhLT5kZXYsCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIiVz
OiBmYWlsZWQgdG8gcmVhZCB0bV9jbWRfdGltZW91dCwKPiByZXQ9JWRcbiIsCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX19m
dW5jX18sIHJldCk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGhiYS0+dG1fY21k
X3RpbWVvdXQgPSBUTV9DTURfVElNRU9VVDsKPiDCoMKgwqDCoMKgwqDCoCB9Cj4gfQo+IAo+IFRo
YW5rcywKPiBTZXVuZ2h1aSBMZWUuCj4gCgpIaSBTZXVuZ2h1aSwKCkl0IHNlZW1zIHRoYXQgdGhl
cmUgaXMgbm8gbm9kZSBpbiB0aGUgRFRTIHRvIGRlc2NyaWJlIHRoZQpVRlMgZGV2aWNlLiBUaGUg
VUZTIGhvc3Qgbm9kZSBpcyBub3Qgc3VpdGFibGUsIGJlY2F1c2UgdGhlCnRpbWVvdXQgdmFsdWUg
ZGVwZW5kcyBvbiB0aGUgVUZTIGRldmljZSBpdHNlbGYuCgpTaW5jZSB5b3UgZm91bmQgdGhhdCBz
b21lIGRldmljZXMgbWF5IGhhdmUgVE0gY29tbWFuZCAKdGltZXMgZXhjZWVkaW5nIDEwMG1zLCB3
aHkgbm90IGFkZCBhIGRldmljZSBxdWlyayBhbmQgY2hhbmdlIAp0aGUgdGltZW91dCB2YWx1ZSBv
bmx5IGZvciB0aG9zZSBkZXZpY2VzPwoKQWx0ZXJuYXRpdmVseSwgeW91IGNvdWxkIGNvbnNpZGVy
IHVzaW5nIGEgbW9kdWxlIHBhcmFtZXRlciwgCnNpbWlsYXIgdG8gdWljX2NtZF90aW1lb3V0IGFu
ZCBkZXZfY21kX3RpbWVvdXQuCgpUaGFua3MuClBldGVyCg==
