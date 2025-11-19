Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDE133B6F4;
	Wed, 19 Nov 2025 09:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763544043; cv=fail; b=e1LJ4FsLFGjfL4OIgRHVSVUveGFqN+anjSz5eaAIrNgHqYpyfwCjO4zpEHWH8O3s60RjWM8U/ySAdkuaKEanwu106LRiMEgZBf2OExR6EjZoaZlrFos0yGYfbUPbkWWe7hromjaYrYl65qoiPdbaPZzlh7siUNhZhoVrA9EtHEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763544043; c=relaxed/simple;
	bh=VCp0v1vlI/ba9qKvXhBrEKPtYScOn5QfGs+ylQKrcrY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=emAwbfYdvxj311d8ghpVRnaRQ8QtQApkLKAgU9GvFPb1LFOPUINwS22wVDGaIuK31a8UE6SKQWE+QW8rBuTKO+9pHLEU+5SR4wvvrUrbcvnwRbW/wvY4wciSFFn4Uvl2ebg1P5bDGlh0NZdrmCXlEwmWWq5AIkHPG5VjHMGxgyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uuQl3NMl; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ouwLNKv6; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uuQl3NMl";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ouwLNKv6"
X-UUID: fe80da0cc52811f08ac0a938fc7cd336-20251119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=VCp0v1vlI/ba9qKvXhBrEKPtYScOn5QfGs+ylQKrcrY=;
	b=uuQl3NMl5Hczhd1FH+OGQv4+ilu+aIdXrdqPyu7feTzrvMutEcxOkJtIaRbr6VQb9j/CHtU6Xm5+9CS25fR3jzwhXI+Mk5a+6BkGKuG0FImrLw1VeKQSB4sSQqt6hNPHVwqbxWp1P8e6rUqJfcZ2zp8NCH4eeZeZLmOgtlwRzms=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:ece7bf52-9bd9-4025-8b57-e37a604f1421,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:d979d182-b6af-4b29-9981-6bf838f9504d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fe80da0cc52811f08ac0a938fc7cd336-20251119
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1749316058; Wed, 19 Nov 2025 17:20:30 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 19 Nov 2025 17:20:29 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 19 Nov 2025 17:20:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KHToYEfk0k9UwHkrenmOhpnQKuPS3Dfl1hjRXt7vvJnMQ8V0uu5ju2meGGt6jV5VXa7t+hJbW/SKW6UDdjy9FlT2BNZVE/4GbN4pRCEsgn3UDogFaeZ7GIDkwd0+9+SkuB+XBmJllt+bTVjpwo1OVDg+Q66H1KzAd/7tskv75eSUiS1lj7fwGios9VV8f5QXaSxpK54TFw3EaYCCEUkv/2u0SGBhAcjOOtIZkwrbf4uyCxaIGn3K8tkr1nDs3tDBvmmWjFLmdsZnqlUHje+WmkqLm8wVH4SPB0RznnpfBbaIzbsxUhSg+kGh8mwE1PDl71StwDZLOZ6p25w6ZEplLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCp0v1vlI/ba9qKvXhBrEKPtYScOn5QfGs+ylQKrcrY=;
 b=Z3NIPJzX3LfaeVKYjdmTCMbWCkjtaeIpHAzga4F87+z6iHXLWnV94ntVd9uV+HjWd+NVBZ0qWAF/5xfnIbUmyOq5VxFAXmfHfJ2IyRgub5sOEZdGb4RR+wDlJ1nZDzlTeKfTGmfRwBYOOH/31cfGLpaMM9UoiIGYJjhTSnpNDDXjpL+QfXWAR3N7iSw9lGgLt24zK4c3Rc5ixdHuZCbNyCxDlQdALgWkghhFJFY1UieFQbdg8h2sgddu8lX++n92R2wzFUOczJ0oeDOmcGoCosohwp41wwS4A86iWV8QZYWulwHyhvE1wHoGZ46rZRwDtavWgAKAHwo1Su05O4P5nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCp0v1vlI/ba9qKvXhBrEKPtYScOn5QfGs+ylQKrcrY=;
 b=ouwLNKv6pzhm3Y54BPIMKcnYG7cH+5msZQ5QYzxhzeZsbhvoNxaNLzfW7slyaV1fxUi5XuyB48urCXaVSAAudAi+DK2U8iCQFdFvFNows4EebTMkuN/bVvgaszVH5+VEDbzRRQM6LRosKVriKJvVnABtuV1gq3bwh+ZsqZE4cDY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB6986.apcprd03.prod.outlook.com (2603:1096:301:f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 09:20:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.021; Wed, 19 Nov 2025
 09:20:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Topic: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwCAAOjIgIABIdaAgAYXzICAAJ+/AIAA3X0AgADCgICAAQkBAA==
Date: Wed, 19 Nov 2025 09:20:27 +0000
Message-ID: <e3e79ac7edc24f17db4a6210c854bb374a0744fb.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
	 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
	 <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
	 <e3dcb711-990d-4e4e-a128-8a0cd0ce8886@acm.org>
	 <a89ccf64710deeadfce9cba08e28867f88463c77.camel@mediatek.com>
	 <64bbe1aa-db10-4766-bcde-71a36d853987@acm.org>
In-Reply-To: <64bbe1aa-db10-4766-bcde-71a36d853987@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB6986:EE_
x-ms-office365-filtering-correlation-id: b5874855-70d6-437f-bed0-08de274ce0c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RURxbHZtaW0xMzlOd3NCcXFENzRBcEpDVWg5aFI3MGwrVXpiTnR0MUFyQTFI?=
 =?utf-8?B?ZkRyck9HMm9abEVCV1k3SmdZOHRWa2JkWVJmL3VUd0lselZYKzFEeG5XZkhL?=
 =?utf-8?B?emFMN0hXOUJYbkhkTG5FY0tiSW5JWjVWY0tsa3lZZjV2RFdWM0RueEROYlBG?=
 =?utf-8?B?TTBKbnAvZ1NVUERpUWxTWS80ZGthSjZJQ2lWRkRsM1ZtYUNEWGJWYXR3d3Fm?=
 =?utf-8?B?WjZpNUZOcWtaUEkvZk01R3dJNXFneVJuV09YTUVXVk1pUVh6L0lGMnBhTGwx?=
 =?utf-8?B?eWtJWnNBUTVpZzhUbU43Njd4ZUMydWZ1aHN0Y1Y2L3NTU0hxa0JOQmhyWnpE?=
 =?utf-8?B?MjMwbnpWRjNhdjhCSlBaMDlpN1I1a01QRVFHVzcxTnNCQkphNDBZUE44RnQ2?=
 =?utf-8?B?cEFJemlXVFNpQzhzQWRGdjMyU0VCRVl5VTBRblczYVFudElhamZwbGVBVlpH?=
 =?utf-8?B?T3I1cW02UHlmdUJvYUFGQ2dHcTVxWGIvazJ3aUUwdlBaMmUwL005SjlpZmg3?=
 =?utf-8?B?VGljSG51bUd4SW1zN1lWUEhDNUZOWERPUElIYzdVVFprUC9BY2ZiQnY4QmRG?=
 =?utf-8?B?OWZCZlRBVVBHNHZZMzdEWFliREZkTm42c0UvZVBiSVlmYTlQSzBYbWxsYUpO?=
 =?utf-8?B?N2FtSmtqYkNxTFUvTHRhaTkwZFE2cXBjTlBGdE1aTTRpanNtMjQxQ2QyZVFN?=
 =?utf-8?B?bzZyT09nTWN1ZkM5Q043aFJ2ZnVsZlVNbmJGREFBT3dVRVRoajNZNXdhd2tP?=
 =?utf-8?B?Mjd4MTIwdCtaZnJsSDU5SW1UenhacHZEVTF2VGEycG54cWJiRjlEdmVKUVQw?=
 =?utf-8?B?eG5LVGxWcHlUUzhXSW5kNUh0bWtkTW5iSGc3djEwQ1RFT3R4c29hcTV3VVUv?=
 =?utf-8?B?a3JDYVk4Qmw5RUc5bG0wWUVSUzRXdmhHME52ZWIxSklDRmtMTUZXUVNmelRq?=
 =?utf-8?B?R2Uwb21RckMyVHFjYTdZOE1sV3VVYS9yY1lidStNS1hsNGpoMVV1L2ZiUlRt?=
 =?utf-8?B?dzdha2RVVFdZcS9scVRyT1lUQTVtQWlLSFNpdXhxM245VzVPWHR0b2JBdTlB?=
 =?utf-8?B?UjNDZTBuZm5Bd1RGWUh6OVdEdEZDNFo5VjBqcUVzYmtkWDdlZ2gwVnJLN2ZS?=
 =?utf-8?B?QzI0WHUxSjBZMmU0STZRMHV2aDlUd0tGT1pKUFRObkRMdlVwVjRzOHZXQWNr?=
 =?utf-8?B?VmkvK2dobjg4QUpqVS9oTSt2WU5MbS9oQ2E4bHdWT2lkUkRTZGNtRGpkanho?=
 =?utf-8?B?L2J6RTBNR20xbnhJaU5ySGN3dDlKYVBySlJPL3hqVXdTSjlzdENvZldocWdP?=
 =?utf-8?B?VHdNZTVaU3pTNVlYaFpjSnUzdVhYMWtZK2pqZjliZ0NmWnNsdStsTHZZMWxx?=
 =?utf-8?B?eFh0SFkrZThSK0x4TndrSE9mWkNMS0JSdnZxcll3RW94eFZreUt6Qit2N0NU?=
 =?utf-8?B?bjY1L0kzekw0U2l0OW92VTVWVVkzRWxxNkUwbm5JZ2g2RXI5M00xbmJ0L0kr?=
 =?utf-8?B?TWFlbk9peGR2S2RyeGhYUGRGS3ljQnhxVFI3ekVXRk1XWk9hVjZnSFJyaEJL?=
 =?utf-8?B?TlBFTWxJVEFtREVjOHF5UzMzYmU5VG1WSFcyL1Rod2QzR2d3c0sxRmM5UnpX?=
 =?utf-8?B?MGFEYnkwVHZ4ckVxQ1Q3eTZ5aUZ0Qk9TdnQ3cE5KK1pkMFY3Sk9GL1BGZlJE?=
 =?utf-8?B?QVZtZUtNUVBBWWhhTEUyQk85QVVVWjVKL2FMaDBPYnczMnBhWDlVbUM3eFFJ?=
 =?utf-8?B?dHNMNSt1Y0FJb0gwaWVQMEVCTG9Cb2ZGYmhQYXF1azhsOXZ3MzlxdlFWb0Nx?=
 =?utf-8?B?Ykc4RHE5TDA5YVRpZVN3TWJvc0JPYnJiZXFvR0k1WGloanNvYlhMME1aM1RK?=
 =?utf-8?B?anZoeFlqSGNnR3Q4b0lqd1BoZTErL2hTQzQvMXlVNWF2TmlubWtLTFI3WDBk?=
 =?utf-8?B?UGxYeGdMbGIrS1VYSFdTRmpmdEV0QXFtWUdaRG1kN0d0dENnYTQ2NWE3NGRy?=
 =?utf-8?B?SUFoUXI0a2JFdDJMNE0vRzcyVEJKNWg1OGM0cE8rNlB5dXFYQStDM0Yxaytu?=
 =?utf-8?Q?2T8oGF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnBuSzlRbXBtVWQ3dnd1V3JTZ2lOMjk1cFo0bXJYSWZ0bXl1eHllTWMxMVo3?=
 =?utf-8?B?ZzhDUElrbWQ2bVhGNHNZbTZXNGE3Z0N2Mjl2cGwrVVpiY1JmL2w2ZkZhRkli?=
 =?utf-8?B?LzlIb3lvbFVtOFBZZXBVQ3p4SXhZUmNMVkEwb2hzUnp6M1pDZTA3TE5Qek5O?=
 =?utf-8?B?c0t2ZHZ3OTkwUWpmTTZ6SXRETUU2NTNNOGtjZWpqREhpYUJidDdTQVlmbjJ4?=
 =?utf-8?B?cVhkamxxSVppMENGT3p5aUFNS2FXTFJ1OHBmUEFUejYwZXBkNmtmS0dIZE5C?=
 =?utf-8?B?dzdLSXBiSDNoQnIwQzlvenlBL2NvTTNNZ05LRXhlcTRLUzkrMFQvZlR4QTVP?=
 =?utf-8?B?SW5aUVFibFVFNWd1N3BheUM5cTBlZWUrY09icllmSFVFdmMxU0theVIvZytH?=
 =?utf-8?B?dmkxRVRUdWxJcFdHWUt3MVNlUEVTY0xZa05QdXlzZHJRMEtsNDB3NkJpRWp0?=
 =?utf-8?B?TXBKQXZkcFNoc2NNRnV2aXFmeFB6Q1BPQzU2VjE5QjQwOVM3RjVwQkdNK2Zp?=
 =?utf-8?B?ZC9tUGp1ODdjQk5XenRWa3lyUjJFNzJPYVBpZkZwcSs5dUpHbVpHQnk5eVRn?=
 =?utf-8?B?S3VYNC9OcERLMGpTQjhkb0VOMG9PU3UxTkVkOGV2bVVRMTcwK2UrVjVXcG5m?=
 =?utf-8?B?aG1WY0hmdXNsU2Nnc3BML3FKVzBTZFdsSnpDUVIvdGRUSWppRjZZUTJIUkNE?=
 =?utf-8?B?M0tZTEVIVFQyeDB1Ynh4eGtmVjZ0RkRNVDJpSjJGc05wU1E5YWpRMWd5azdU?=
 =?utf-8?B?U0JxbTJyb0RoZ3lIVDBMSzhySTZDcXltZW0vazN2YmNzQnBEOU51Zm5yZ0ts?=
 =?utf-8?B?SG9zUzBYKzdFdGJlbUVjcmRsYWdrSXRxMjI1UHhDZmc2d05GejM1Wm9BUWZ3?=
 =?utf-8?B?YndhVmJJajBuUUk2elVRc0RRVS9VV0ZDbnNFVGd6NkxoQitDUWFBWWFlWUlR?=
 =?utf-8?B?a3BMQVBTOUhyaVdQdW92cUpyY0srZjE1WEJDcUNaTTdaMWVlL3YyRlVnS0JS?=
 =?utf-8?B?ekRnSFZTeEVUVkdaTEQvdS9ySUpiRTZTcWpPYjIvRjVrRWZ6bEQrS3pHSG1T?=
 =?utf-8?B?SVNraCsrNWZPRXZVL2pac1VXQWZ1bE13akpFSWxwSkFwSzZnOThaTytkWUN2?=
 =?utf-8?B?bWdidmp4bW81SW9uMXVGN0FYU0F5dDFWcWxvdWw5eXg1eGJsdFpqcVFhaGk2?=
 =?utf-8?B?QUdTZjhIelB6RUJ6ZUN2TEUzRmRHdWlKKzczbEh0OFZDUG83ZVZ2bHNKeXJl?=
 =?utf-8?B?TG1lZEkvRTRrWjB3cVlOV09BSEFVWHg5RDdFWUVRR2R2KytCMUl0Z1ZoVklT?=
 =?utf-8?B?amxLK2dQV2hDVWtUL3huZk9pOE9kZjBiVVBLWWM5N1liazY5aUluQTVKcTcz?=
 =?utf-8?B?MVI2MjIrVjE1NjcycGliTmNQRDl5c1krR3E5S0V1cFlWVWlybS9iNXM5Ympm?=
 =?utf-8?B?aXIwQjcyMllzWXRzSTdGNnNhZHRMUDUyamtBZ3JLdHBaaGlhUm1KWk5oeUw2?=
 =?utf-8?B?cWtSN3VvbG5XdUZsUi9sckxuK0hjWmFtVlVoYVN2ZTU3V2d5c1lqaWR4ZkQr?=
 =?utf-8?B?S0ZlWStKY0pNM0UyVjdCcC9wT1B3WG9hVWNOSjBEa29YKy9wQWEzM0dLOWpn?=
 =?utf-8?B?a2xiL0pUWFZFbGRkVHFGUEk3M3VQRlA1SUEvKzJ2V2p0c2wxcHBiN0xJcU94?=
 =?utf-8?B?ei9xN1YrVm9ObzQyL3dZUEpodHZGTGtPUlB4U0lUTHUzN1lVVGQ3ZG90ODZM?=
 =?utf-8?B?eFVxZTFHcit1UElJSHZZMTEzMzhOU1YvYmlUendqS3lLblFBN1IzdG5XOUgx?=
 =?utf-8?B?eld3aFdRQlRxcDZZOGpNS1ZkanE3U2dCMWpEODlQdEhjdENkd1ZHM3lraEpE?=
 =?utf-8?B?V1l3VGV4ZWw3cTFyYWdEbDBhaTZ1YXJKa1RvTmZjZGRMRnhsUFRRMXowVkZ2?=
 =?utf-8?B?Y3lvWjBwNmNEcHVGMVdSTjE5UkdUWlR2R2xvR2g5cUJrT1lpNGo0SWhob2hN?=
 =?utf-8?B?M0VOMGZKV0s4OUd4b09OeG5aRGdMaWhQZzlyVlZGbHZMMEpGTkRMYXNjRVpW?=
 =?utf-8?B?dDlwZHZuWnI5VWkxSXV3Q3BVWHVXVEtuL0taYlgvd3dXUlIwT2JvNmtNYnZN?=
 =?utf-8?B?QjBCd1dSeUY0KzZaQng2bGZ1Z0tZZmtmbmQ2eGZ0NUFYYjJpVDF5OC9kZ0sx?=
 =?utf-8?B?Mnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <412F82F31A207846AFFFC82A8650DA58@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5874855-70d6-437f-bed0-08de274ce0c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 09:20:27.5414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yMx3TdpwHr5zwAE8bLoS0X7d62dvuilusQxqo4KNmCKUnCozExNUuZIQavGH7b3PTd01rjvfVGOdzlm43B5Pbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB6986

T24gVHVlLCAyMDI1LTExLTE4IGF0IDA5OjMxIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDExLzE3LzI1IDk6NTUgUE0sIFBldGVyIFdhbmcgKOeOi+S/oeWPiykgd3JvdGU6DQo+
ID4gSG93ZXZlciwgaW4gZXh0cmVtZSBjYXNlcywgaXTigJlzIHBvc3NpYmxlIHRoYXQgYWZ0ZXIg
YSAzMC1zZWNvbmQNCj4gPiB0aW1lb3V0LCB0aGUgZGV2aWNlIGp1c3Qgc2VuZCBhIHJlc3BvbnNl
LCBhbmQgYXQgdGhlIHNhbWUgdGltZSwNCj4gPiB3aGVuIHRoZSBob3N0IHJlY2VpdmVzIHRoZSBy
ZXNwb25zZSwgdGhlIElSUSBpcyBwZW5kaW5nIGJ5IHN5c3RlbS4NCj4gPiAob3RoZXIgaXJxIGlz
IGV4ZWN1dGluZyBvciBzcGluX2xvY2tfaXJxLCBldGMpDQo+IA0KPiBJdCBpcyBub3QgY2xlYXIg
dG8gbWUgaG93IHRoaXMgY291bGQgaGFwcGVuPyBJZiBhIHJlc3BvbnNlIGlzIG5vdA0KPiByZWNl
aXZlZCBpbiB0aW1lIGZyb20gdGhlIFVGUyBkZXZpY2UsIGFuIGFib3J0IFRNRiBpcyBzZW50LiBJ
ZiB0aGUNCj4gZGV2aWNlIGRvZXMgbm90IHJlc3BvbmQgdG8gdGhlIGFib3J0IFRNRiwgdGhlIFVG
UyBkZXZpY2UgaXMgcmVzZXQNCj4gKHVmc2hjZF9kZXZpY2VfcmVzZXQoKSBpcyBjYWxsZWQgaWYg
dWZzaGNkX2Fib3J0X2FsbCgpIGZhaWxzKS4gVGhpcw0KPiBwcmV2ZW50cyB0aGF0IGEgcmVzcG9u
c2UgY2FuIGJlIHJlY2VpdmVkIGFmdGVyIHRoZSBlcnJvciBoYW5kbGVyIGhhcw0KPiBmaW5pc2hl
ZCwgaXNuJ3QgaXQ/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpU
aGUgVUZTIGRldmljZSBtaWdodCB0YWtlIDMwIHNlY29uZHMgdG8gc2VuZCByZWFkL3dyaXRlIA0K
cmVzcG9uc2UsIGFuZCBhdCB0aGUgc2FtZSB0aW1lLCB0aGUgaG9zdCBzZW5kcyBhIFRNIGNvbW1h
bmQNCnRvIHF1ZXJ5IHRoaXMgcmVhZC93cml0ZSB0YXNrLiBJbiB0aGlzIGNhc2UsIGhvc3Qgd2ls
bCByZWNlaXZlDQp0aGUgZGV2aWNl4oCZcyBUTSByZXNwb25zZTogVVBJVV9UQVNLX01BTkFHRU1F
TlRfRlVOQ19DT01QTC4NCg0KSG93ZXZlciwgaWYgdGhlIElSUSBpcyBkaXNhYmxlZCB3aGVuIHRo
ZSByZWFkL3dyaXRlIHJlc3BvbnNlIA0KYXJyaXZlcywgdGhlIGhvc3QgbWF5IG5vdCBiZSBhYmxl
IHRvIHByb2Nlc3MgdGhlIHJlc3BvbnNlIGluIA0KdGltZS4gVGhlcmVmb3JlLCB3ZSBuZWVkIHRo
aXMgbG9vcCB0byB3YWl0IHVudGlsIHRoZSBob3N0IElSUQ0KaXMgZW5hYmxlZCBhbmQgdG8gY2xl
YXIgdGhlIGluZmxpZ2h0IGNvbW1hbmQuDQoNClRoYW5rcw0KUGV0ZXINCg==
