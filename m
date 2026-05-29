Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0230C60E;
	Fri, 29 May 2026 09:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045758; cv=fail; b=C6l9eixOT1LHPzgX7+Q4hYTx5U9f5qp4mhjGyX7Kt3ESLGB7vqsMo2OWZTSp8gFiTZZLsrkSeU8Jq3mNRlGMIQIFvlPovZVErJBwYc0sgfv6aRyC/GEwS5c/1BM3AbxGBmCxq0tEzcxsrWqhKD5RMniOz9i+BNBHIRtFES4yYEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045758; c=relaxed/simple;
	bh=2cqh/E1lgFAgHet5HQDpFN21RAAPvO4fbh12KFjB7H4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pTnNUqkAKduW8o7pPE9u6Jf1uT/XyVs7KmiZDeaH/aDpXgRMDTrjeI26zmm4wPMHG4RnoqaNppL5rErttEt/0MQq3P+4LSL0vxEM3tUxvyEGdClMjRCs7rGXfHsIvNBAy3sdhehNSfR+0XTMVQG8qA/3VqJ3to5Tt3nz6d+pXxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=O0o9Zu1V; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Q0XBl+DA; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="O0o9Zu1V";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Q0XBl+DA"
X-UUID: 0f398ce45b3e11f18dc8c9802ae25ab1-20260529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=2cqh/E1lgFAgHet5HQDpFN21RAAPvO4fbh12KFjB7H4=;
	b=O0o9Zu1VedeUgqlG4bYndGXGnEhHKyIYogYSscpZt+B0X4/oymFZ8oVkRlyusqnBnh3GtDpvBWpfmMkZ1pDsR+Gwm0Yv+8t4u2zgqqwy7yXVIzb86sXN3GQutn8PfA+hCTEH1ATOXA2UapWCxg0+tums0P4S0cYSTzIWilji21Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:a0bdfc8a-afe2-44a3-a031-59a8d0d535f1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:3d7c91c9-9273-4096-a0ce-fc7a6a4f85f7,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0f398ce45b3e11f18dc8c9802ae25ab1-20260529
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1796110844; Fri, 29 May 2026 17:09:12 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 29 May 2026 17:09:10 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 29 May 2026 17:09:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcp12J1egO7nTAaXeDDM93H42Nbu5M25YSedaXUVswvRTNxOQpVkt8038djkwS9OHdFZPYG/tALL3IW0ni0FKw8+evFRKMJ42N3vMdQJ6zRJ+NlyQLhESf7Z7dXC47mqTWVxUMADzzju6QBL1b+Lz2HuBgBQFn0RQMB1MXVCwQTDWcMdIQ0aOR5JgSyoRKB9i4iKxc3DFdy1gRzw2CoaBs3Zk5WZrwqWrmtT3QRFPNS1ttRyfHLAe0jeycdM5EkLJ2jP0LAX6O2KdAfkkIg4FT3ABownY1kKAsd4yEqa1SzuGch+vzGFN/OnyK2W3767UOCaT/A/qRRSw4kRU8QZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cqh/E1lgFAgHet5HQDpFN21RAAPvO4fbh12KFjB7H4=;
 b=f/pre8Ou9DyZzr7VEZQH8vOBT02ttQsbwfJGjXYqetmWzGLSDXo/9CjdxHBwtOwR6qaczeGkkVz13apv1ubYtqYO871o0mKVgAz/fNSa4obLBaPbB+awG2sDzz8mBega7HcQEDoM22kX/aVvcaWre3i6WqbxtwnmJGXT2Yo9GxOPvqPjDA3xQybNlAQ2FTx8pz6le7eR4CTDXK3iHtZqbLYh1cXEHNrvtfrAoe3NxzGRuMk+8jrBbjbIF46n1rvbs9FK0ohO40kdaFxeiAcEv3VYObHh5J8pbP+KRkw7RfehC+jeTbhioPbnJfKHZF9NmuSWMguODEZG6lggRcT/2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cqh/E1lgFAgHet5HQDpFN21RAAPvO4fbh12KFjB7H4=;
 b=Q0XBl+DAeknSZk06B5KVJruluxZKtF9ORiY2la0+nesgFFPp4NXJRfvWKy6QfXL8W6KhiRyZYijkQmDRHkj0BNp9n06Rr3wp1KjVQkQ6wuf4wvmlkIWn+R2UU4idj/bgI0+KphiDyNTbExW2yuPUmkkZrqzSafryvFH4L+C+X/Y=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8740.apcprd03.prod.outlook.com (2603:1096:101:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.5; Fri, 29 May 2026
 09:09:07 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.004; Fri, 29 May 2026
 09:09:07 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "vamshigajjela@google.com" <vamshigajjela@google.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "rafael.j.wysocki@intel.com"
	<rafael.j.wysocki@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH] scsi: ufs: Remove unnecessary return in void vops
 wrappers
Thread-Topic: [PATCH] scsi: ufs: Remove unnecessary return in void vops
 wrappers
Thread-Index: AQHc7zKVsFkb4zxC0E2nd/hh/7Y+w7YktzQA
Date: Fri, 29 May 2026 09:09:07 +0000
Message-ID: <08854054d65c86755137acae7171c72fe9cfa360.camel@mediatek.com>
References: <CGME20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf@epcas1p2.samsung.com>
	 <20260529061503.301182-1-cw9316.lee@samsung.com>
In-Reply-To: <20260529061503.301182-1-cw9316.lee@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8740:EE_
x-ms-office365-filtering-correlation-id: fc855922-d08a-4ad8-1a17-08debd61f030
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|18002099003|38070700021|921020|56012099006|11063799006|4143699003|22082099003;
x-microsoft-antispam-message-info: aE1bwEuPFV9/MKBGJKDfaMH9KXOxcrZMfjMn29+MtokOJHXIUitJb1cr8MvJ2DiLbdmFUyU4pIetuOGgkrJXPa1Edx7GdAkH9fLCBqdaLF/GWHoo7CNlLjX6t5f01c5m7NOpGP1DUV1LsxQslpQZm1aVtL+VXL5Wclw1eXBfhtuebopKn+9l9vJbrSSTGVeiIV08q/jmS2lhrs84+9J288mEpU3E+hm9YEnpAqE208Alqa3WCefpZZ9vNqtnUG5hojWT/pnBIuInUKTuwH0tGfzbHZUcqa+CeMbxkVEX73G0UNwps7YKII0iO5ldpJIJkBLQGQOW418ptpnWdkA+a7jPJFkl8zrt8N6pes8xjKntcUWa84el+6vsKaEv/vE9rb+ObCm+dDeoFbnPVGTh95Hj0dTs+w1uurO1fqF/OHdGyccTMADnPwZCAVM74EwWXbzyOph9sKy5y5w7d2cmYHDPsCM4puNhjjd/FXe59I7g2gu9cFy/9Jb4zBUlmtXNuN+hxPufsLb5tR3n9wEQP0D6IdoinOsIht/y8bLEQu7Mb0co67y3lTft6ecYvTg0qroSbRlRD00PfQaq51A3VnLftpX2Lw59AyxZjebg6AxKU5s5igpsercxgoBWzG1wkgiDXujZzO9VCpYgA06Ovk12osDi9WO0r95nNQeIfjQEH1Ie2CNwfgtIkYLpQhefFX1FS22SW1SECeB1ez8rtW4gZCBdRkrK6TeN2hYv/Jto0aAh6BH1V/opBaH9sj+oIevRDqDZZ7vu/3G4fqN+PA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(18002099003)(38070700021)(921020)(56012099006)(11063799006)(4143699003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTRoUloyLzdmSUhSS2h3MnB5K0oyTk53eStSeVJaZXBCYk96cW1jR1ZuTi9G?=
 =?utf-8?B?ZHZ4ZkJQbnNoQWdKcllFZit3aU45T2hCMTNZdDNoSk9lNk9DOUJTaXRuV2hT?=
 =?utf-8?B?MzVMWExKZG9oejZIemhoQlJpeGJEcTY0L3FVN2FmMm01N2M3STRhVys3dnNH?=
 =?utf-8?B?WE9tRWh3cy9IR2RtUVN4UFNiYm5FbGduWWYwazdhbHJBd005YUhzQWZvaHpj?=
 =?utf-8?B?Y01BN1ZFR2ZwZDQzR1dZQ2ltRHVBL0JPQVUxY1FuQXdzeDlvek4rekQrd2d6?=
 =?utf-8?B?V3ZGQkpndTArcmwwSDBrb0I5eDhUNG1hOGFFSTBoOU9FUkh6RGR3M1NPejM2?=
 =?utf-8?B?L2dobHdOd1JhRzB1OEtDQi9QeU53TjhtQUMvZHNTK3l1RWtCU2x0dGc4bEts?=
 =?utf-8?B?K0FkT0NvVkZObTN2Ym9zWXNIQXc5UTFUZUcydFhxZk1haXVEUjBXQ1hDalBM?=
 =?utf-8?B?RUE5aXF0MzA0RCtoU3A1YXNhYjFTbThZZFIvRzU1ZFFqRWkyVnF4Um5BSWht?=
 =?utf-8?B?T01vSFJPajNRSzBvMUFoN0Z4MG1oRTNSZytyZlpSSFdyUmFnK2FtVlJjVVND?=
 =?utf-8?B?TEpBOEdVYzhBZk1TYzZ1YW9qbjdHY0NuNVNaS1QxRHN2TkVzWnRXeklqcVdI?=
 =?utf-8?B?UnJUTnBHOGpsYk5uV0dvSlN2azNicTBqaWNxaDUxYjVWNU1pNGZwdWd4a0pI?=
 =?utf-8?B?SFpHR0ZETmpUK0FzTkpaL3dGenpXWTJ1QUl4SVEyZHBpSEFhN0JvZk1zWlBa?=
 =?utf-8?B?UVNPUUJTZHpGQk1HUGVCMkZyL0VZaXAvOU1yVXdPMGJCRlVRSnpvRlp3K3pX?=
 =?utf-8?B?Ym5sV01LQk5lcjZvVzV5OCs5blVUMFBrbG12NSs4SGQrVjNoYVNnamNqUjNq?=
 =?utf-8?B?Z2dZcXIyR2RydDBNcmEvcFFCU1FMSFdxamxxN3NlaGU4WkNMYVNjQVlQNlNR?=
 =?utf-8?B?Vk9HRFJuNktoNU16ZXRTQ3dnRDZzcmtSdndlYzIvQ1V4ZjA5dk9zL3BoV0wx?=
 =?utf-8?B?bktxYUxNeVowdVRVVjVKaVh1M0RTZ0E4UzM0eEtBc05lQzdLTktxTVozUEVT?=
 =?utf-8?B?cjJuSkc0aTFMOEdwOEp6UlV1SGdIVzhjK0FKb296YzJ6cXBTUFdCNk5MYnRP?=
 =?utf-8?B?WkdwOCt0ZkcwWHkwMzJzNTlOZHZNVklnMVNMYUllRENhZ002RGcvTEhiQ0t5?=
 =?utf-8?B?bm54N0lRTDR6S2RtVmhvYVYzMCs0R3A5YVRMU2ZoWTZGVU44eFd2ejBMbmgz?=
 =?utf-8?B?bFhHQUpEREZ6NDZqbGJ4WDFab0EzaXR2R3NKVGpHR3ZhQ213V2ZnR25hWVRx?=
 =?utf-8?B?UTlEWDBkNy9jTGVycW9LZGcwWkNtNjFzSWZ1Ulk1RHlwOURtYVhLWEFrRWxt?=
 =?utf-8?B?TTlNdThEVDZoUkptZDNSMGxxa2NselZGSnNPMGw0dDIvRzR2cE83d0tmZldp?=
 =?utf-8?B?bnBOUTMrUFFNWXdSMUxiM1dIUlZkOW9IVTBrM0IwbVJEN1FvZENaVzZ6U3I5?=
 =?utf-8?B?SG5JUzVuc0hjRjJ6bC8yY0pPWlRtYUdTU1BYUzkxdlMxL1ZSQUsxMmNjRGdq?=
 =?utf-8?B?TmJaUE9qR2EwcE5qZ0djaWIzTzRhRVRvelg0bmFnUXdyU2tRRkhiSmNQZ3Rz?=
 =?utf-8?B?OWpNaS9rS1lqTG44MXJ6ank5WGd3ZTI0aXk2M2hLVU5peEJ3NlRKdmJpVTZV?=
 =?utf-8?B?dlpBR3FIMEdUVnJmRVlHS2tjYkQybGtKNklBc0VXVk1qQ1VtZ3JMcDVSZnVS?=
 =?utf-8?B?b0pHWUdUWG1tdXV1WDZlR1l3dzRFWnZqK1R4U01Td3haQXZPU1M4OGpOdmRF?=
 =?utf-8?B?MUZwK3RzTDUzTmg0NEhwekw5cEdQN2NCUTBSZWwrUWp0U2pVTytsL2pDR3lo?=
 =?utf-8?B?RnlpbEJIdTk5YTE2VEdHQmRkanJtS0FEbFQ3RGEwcmtOODEyRkh2aXdhRmlM?=
 =?utf-8?B?dEhLM2NPQ0syV2FtaStDRDVYdjZVazRRYi9Nak01QlZHNEIyaTN2UnJwTVh5?=
 =?utf-8?B?anJVdWFKQzNOaWQxa21Jbi9RZGlZOE5KMFRPK1F1bmNBYjRraDBrYkw0WFlQ?=
 =?utf-8?B?NUMwdyszaXJBYy9YN25ONE81WkYyNXhud0h1SGZTN1Q1Vk9CNXNBeFhLTC9V?=
 =?utf-8?B?M1ptemYvUVRYemQvc0IzaU13SU5SeDRIVlZIbFpUdko0SjNlYnZSZ1RpYUVk?=
 =?utf-8?B?YjJpREJqVkpMWWJ4TlNHbnZ5RzdxWTh0NWFEZzVSWmY5S3F1N1A0UXVuVzQ2?=
 =?utf-8?B?dmJ0amg3enYrT2hsNWpWZEx0U3JXbWxGejhmY0NnZUdEc0s5L1YxaGw3bEo2?=
 =?utf-8?B?eE9KRzIxYUFUTk1zM0JpOXVQd3Nxd01MSEZvamFYb3BGTktNVjk1ZHg2N2Rz?=
 =?utf-8?Q?3CuFDX7LOfflKOcs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6312CF2064F254A8E0116DC501B8570@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: DclBqLmCgulEY+mPM4fhtqi+nQRQP3fREEd8s7smaD7k8/+lzextEVYd8vcapXRj2FVmJrgH2mGwsOhB1ETCcPgbQTZXkD77fozubYM/Kq2o0MjUFQlM07TzCrJ6y8TywcbYzLxX/JNBoFVRcpz6PYVO+iBlIAYV8gPfwit3UZ1SQEi5xJWJaCWIgE8vt252+OdMfmJYYgAhtCVKc04vkIv9254wutR3DbxMtdg0537wcTVjWesLCS+0kQNusBjySFP8mxaHNaLI6gVzHtA6jcdRvIsbro0XZQIXxuCUbSOr1bxcM2QHzKe5WHfy6ezq7F45w0vcvdiNZ/Rqj0J76Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc855922-d08a-4ad8-1a17-08debd61f030
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2026 09:09:07.2089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5bXNJwX4yCcW3qxpWEonXzPo/EzNAMw9UmA5xkxUU8ZV6n2+6LY727E0XtVQkoUnp264+JMOWF/i7ecL1k7GlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8740
X-MTK: N

T24gRnJpLCAyMDI2LTA1LTI5IGF0IDE1OjE1ICswOTAwLCBDaGFud29vIExlZSB3cm90ZToNCj4g
dWZzaGNkX3ZvcHNfZXhpdCgpLCB1ZnNoY2Rfdm9wc19zZXR1cF90YXNrX21nbXQoKSwgYW5kDQo+
IHVmc2hjZF92b3BzX2hpYmVybjhfbm90aWZ5KCkgdXNlICdyZXR1cm4gaGJhLT52b3BzLT54eHgo
KScNCj4gd2hpbGUgb3RoZXIgdm9pZCB2b3BzIHdyYXBwZXJzIGNhbGwgd2l0aG91dCByZXR1cm4u
DQo+IFJlbW92ZSB0aGUgdW5uZWNlc3NhcnkgcmV0dXJuIGtleXdvcmRzIGZvciBjb25zaXN0ZW5j
eS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW53b28gTGVlIDxjdzkzMTYubGVlQHNhbXN1bmcu
Y29tPg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+
DQo=
