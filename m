Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C69EAC7;
	Wed, 25 Feb 2026 07:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772003967; cv=fail; b=o57+x7egJsJH31lL+c48mwtCdBRSzaD6mREM0bl7Ns/y/+V8jQ2iM0Yzv+flThESm9iyO0gwIge1gI7rCy1zi5TkoNATDgMXTI1bAN8p55JCdBQl7QMnzKHW5LDvKBwxnXmQtm9/cTZe1huYhaX9dbzknXCE/qIcBv0dpFEJKjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772003967; c=relaxed/simple;
	bh=7gBZBmXwwSUGgGAT028AeBSBL/etFBMomTuNknOtCPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E71BDWSE+2TDmTNpFR24Ge9yZdxrdRF8dGK5hUNxHLYldjDk1rKq8mRWurR/MfeNVjbs7fCxEgF1RnfGDl+NtU9LOgxbpMsIhay+0TwfDqQ9Zxmp7nsgsTEb7JLGQ3ogUGOBrCYECqVknmEDkEPVLWi01ga2+jkR6WlwPUaMOEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kURyF3b1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IXEmXVZn; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kURyF3b1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IXEmXVZn"
X-UUID: 4e01e5a6121a11f1b7fc4fdb8733b2bc-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7gBZBmXwwSUGgGAT028AeBSBL/etFBMomTuNknOtCPA=;
	b=kURyF3b1H9VRR7vKkHV/LEwqWQ/+AXXyot/NO9MCNNuUyLgICgtVjMJ6qRIv+ELeR/GAYUQBrCZ3t29JmpSwL1zkdBWJK3Vw6e4e6anitbfgzOT+5a7qZbX1Yx6qFTUUpYLkdh/d70E/WYnpP5Pv+TbED/yUBEgTh/LPZ4KHihc=;
X-CID-CACHE: Type:Local,Time:202602251518+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:09f5af36-c22c-4881-b2ea-6671cf2fcb9a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:8878f8e9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4e01e5a6121a11f1b7fc4fdb8733b2bc-20260225
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1855766585; Wed, 25 Feb 2026 15:19:21 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 15:19:20 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 15:19:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gs93bJjje09YfN9ex/GHOiYuaXfZapfLOT8HXYylggvsLUFNHKsYjWAiEPmZDi/NKJVTOznEoCqK6JPACWiNIbTYcrMNC3u5GFzsq8WSC4A1jWobg95gyaPvl4rfozKamt3zWSZAMWHrz50yl6QDGrUfVWk9sURwQFNS8zqY7Qb8LooErCkMRDbYEOasQ5MkQrBhKXMQrfiSYbhTWWTRxKzGuGAMUixd1e2YCzlQko/hSXOEvbF/JW9YaUM7VPIdnXTXiKjP/5EoI+O8JpwUSvJjBPOA20tGHrBZLJVfpP/SghHJBPVjHIctBY3GzYq5k2g1dTaCEJbsNNQwCgyHww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gBZBmXwwSUGgGAT028AeBSBL/etFBMomTuNknOtCPA=;
 b=WwvhRnP54VbDV6vSJGH7b77FgmnppKq3O7mk2jOd2IKLz4Op9de3bdVQBCFBHgyqoLyadSlbDyadvliveDoV0vHRe+C86UhP54dLhEr8wU0L5P/M+rB2bl3jOnrjWkc8hhIMwoOdGLWJf5ZtIx9n5gTgVkg5yKXsGxiTLbPp0tyHN/PuV6p/yErjAl4qi357qTsYVGUyFC2MmqFTX4/5sG72ISiAzw0hcDTPWaxtgD0FhNlcAoV09HV1QscTAU0DAR89GqUD2DQfTu3s860maoxabxT0vPM8mJu3hOS9AJ/PpgNB/YFqrPSz/nJ2mWYrBcPZvQV3JcgDA1MMOH29zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gBZBmXwwSUGgGAT028AeBSBL/etFBMomTuNknOtCPA=;
 b=IXEmXVZnx2t/sTgP3+rzF7MN4sBJ7ovQjqHigVghbdeuDVBrIVlwI/rwcEN1awfQbUuaoOxu1ePEWXCldsrTTALGzDEMDqtNLBFmn+oLoSmVTjO85fcC/YQ7e6ZxZR1dAtfhfLBiLX4f7WsfYEa6jaP0Vt7Sl7pYT8EF84akLG4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB9573.apcprd03.prod.outlook.com (2603:1096:405:39c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 07:19:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 07:19:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Topic: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Index: AQHcn0nPvDFB0gw0KE2BmOLle5gC1LWR1niAgAAA2ACAATg0gA==
Date: Wed, 25 Feb 2026 07:19:16 +0000
Message-ID: <945cf4af3f830aafab87c6faae0faad7123f3be1.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
	 <2c7c84a2df19624ba9f207fd3fee47a8bdd9d8dc.camel@mediatek.com>
	 <24445e6d-c308-4df2-8b3e-7ee8a8e3f2fe@collabora.com>
In-Reply-To: <24445e6d-c308-4df2-8b3e-7ee8a8e3f2fe@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB9573:EE_
x-ms-office365-filtering-correlation-id: c65657eb-1011-423d-3847-08de743e2f72
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?ejRsS1ZJZDVqV2dSRmZ0QlFTNEdla0RaK28wSUdNaWhxd0RmWEVtdElDOFhK?=
 =?utf-8?B?YUttR3Z5Tnpwa3FydFhjQWk4ay9STUZhWjd0UFA3QjRyY24yd1Z4VGl2NHE2?=
 =?utf-8?B?SnZDaGNVZmVHdnR0TGV5NlRkV1pvaHcyNjVJeGYzRXY2aHVMalNSME82M2NC?=
 =?utf-8?B?NEMzS1JVZGVxSmRhOHVHNTdmY0RmQmZkSzZsMlJxQWNuWms0OXFtR1kxL01T?=
 =?utf-8?B?cldNYWhyL2ltNGw0ZDEvbGcxNlVuK205YkhoOVY5bUV4MEtmV0RPWHk5Qzha?=
 =?utf-8?B?YXpzWkxWZ0VjOUV1QkdWa3ZVVG44RE5ITVRyVFljeHNxY3NCa1hPZDR5N3Nw?=
 =?utf-8?B?Y1lwSXE2SGxEVmI4SEUxM2w2YlAveFlSdGtwUHlqSEdudDh1cTNDVCtvNDVG?=
 =?utf-8?B?NG5WazJSUXp5aHliOFErSEREVnczeHZ2RUwxZmMrb2ZSLzA3K3lNaGwxdWJS?=
 =?utf-8?B?SExhcFZUcmw5djJ4RFF0V1pQSW0vWHdRaXpBK1p4SitjRWNFNmwvZkQ2Ri9G?=
 =?utf-8?B?Z29MaWtyWTd5blc1bU9MRUJ3dkl2eExJdW5PMTMzcExYdTJFRHNKR1piVFJX?=
 =?utf-8?B?VHRDZUFuYXRKWWtadWdraGN4b0h5Q1l0VVIxOSttZ2hpRXRaTHlQd09NUzlY?=
 =?utf-8?B?UFRPYTdoYnZha2owTFE4RFlYV0l2V1ZWY3ZxbS9SQVQ5MWZ6eUVlKzVrcEhk?=
 =?utf-8?B?Q1puM3NPc281SmNTK28rR1pvUkNNVjJYbnBKVnIyM21Fc01ZVEtCNFQ1UGJD?=
 =?utf-8?B?TEJnSGJLQklHaDF3blhKTUFvekFlaHJvUktQekh6ZXdOcyszNy90Z1FseXla?=
 =?utf-8?B?QmVFMEs2WTJMbk5NR0JyWWI5R0U0Z0p1RlU2SjcvaDl3N2NvMUlRa01GVnNs?=
 =?utf-8?B?R0V2bnA4VlF2N3ExaTRYMGVVZklqUk5KbUhjcGJ1cUJDZm9rMjhTS3FWSU1M?=
 =?utf-8?B?cG9ENHdwWkpLeW1tQjRqVXJOSWpKQlYzUmQrT21iM283UmZtOHk3MnNvWmlq?=
 =?utf-8?B?eU5xYVNCR2lxRkZYRzR1bXlDaHZVV1ZvZVZPMTh4L2o4TXMwemlOT0RHaHdO?=
 =?utf-8?B?UzNaaXg3alg5UnE2ZFlMQ3dUL2VITlhXUHR1QTliTDc2NjNBVDRpWTIvL1dJ?=
 =?utf-8?B?Rk00R3Bwa2VwMzhBMzVTWmRIMnM0VUpZbzE3Z1FJeEc1aUdNNjJZZUxzZjJl?=
 =?utf-8?B?eXYvT2U3TDZZVGdINzBVZkduTzFjRVdDU29DVU9RN1NMcnF0UE1NQzhzMmZN?=
 =?utf-8?B?SUs2RmMxOW1xUmwxSHZHZ0phOXRwamYrNXlKUFZHR2FFVWQ0M3VDbTJBZDZu?=
 =?utf-8?B?OENRMkhWbnpSc29EbHRUT0dSdEU2eE45ZUxJTkJQS2M0cWNUQWlyUGxDb0Qw?=
 =?utf-8?B?ME1SQUViSEZKR21mS3YzYzNXNUpmeXdxYkJKT0hnUHFqSDBPeUZVK3E1S0hS?=
 =?utf-8?B?OTJoTk5MQ1pybGdUTTQ2NEk1aS9WNVRpKzYxM2NBNUk5YnRxdDJpbnVoelA5?=
 =?utf-8?B?aDhNVWZjaGJrbnlLdWgrcXZWbHZCUWtMV1FtODhKNVNMNHUwMVkvdUhtaU83?=
 =?utf-8?B?MUw5Y2VQL0gzYkxqei9QV2FyOStGZWU0U3JpZDNveGNrRUVoU1lsYU5EbzFG?=
 =?utf-8?B?ei8zclJDME5qWXkvQ1lVNjQxK1BqbnFDK3JGc3lZSWNJNlhhMDhwTkFIMlRE?=
 =?utf-8?B?Zjg1YnZ3clR6d3ZsQkgxZVR0c1lnNWRJRnRpWFBGMVJ6S1hpbEpudEFNaXF4?=
 =?utf-8?B?bXprd1IxYm1vd3p1Qm44RDJtdm9jMkZZZDNZS2dGbmxveENOcy9hdmJzWWZS?=
 =?utf-8?B?czdGVjFGMUxmQys5eUVDUHBwQUlka0dqL3dTVWdIdjBSUTF1QXZ5VjFtNGJh?=
 =?utf-8?B?MVpVNnFMK01CeG1kbHltWDRVMEQvSXlkRisrUkNvTGw5bFBJbFhUdi9lWmFO?=
 =?utf-8?B?eUZyTHFKbkRGNC9Jd0xBWmdNVVc3Sy8rM3d1WC9Xc0o3bW1UZUcyeGE2TzRF?=
 =?utf-8?B?bnBscllqKzRweElLc1dFME04ZTN6Y2Q3OStWaVJxY29RK0RhZDZ1VHArdk9m?=
 =?utf-8?B?T1hXRDc1aEd6T3pVTVlBQjNqbFdYYzZYSnZ3MW01Y2VJODA4NlM2MmgzK2Q5?=
 =?utf-8?B?eTgwaTV1SXhTcFZ0ZkdQZFVxK1ZRL1BLVHNHdnVKdlNzTk53WExEOVpnNCtH?=
 =?utf-8?Q?QN1T6ZDw34xLxxzlC4PvciM9zDqwnWssfe6cAu4SsRiW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzB6Wi9tSVVDd1JmR1lJS0FRWlR2K1lSdUQwQXdFZitNSzBNclh4QlhUMnZa?=
 =?utf-8?B?ekN0am1Zdmg2dHllRU1Icm9ud2VMWm1haU1HczJNc3Ftb0lJZnVJb253RXli?=
 =?utf-8?B?RHBNKzJPaVBJWVhhRkxwdklOWXcyVFM3cENZb01UYnhVTmxCVXRzcGw2QTll?=
 =?utf-8?B?MnRoR3VEb2ZTSmZUNmlIZzNRREpjbmFQS3JoclJ4S3R6V0VacUoyajdnb21X?=
 =?utf-8?B?K29nb3NEanZWK1ZRZnJ2bUI4OWxLOXp6VVpnRk13VnlyWWdmSXlvQ0YwZ3dX?=
 =?utf-8?B?UEtCTGpWYlc2RkNwY01GVDNqNUNOakNxYTcvOFI2RmdBOGhyNVZCQ2txU2FX?=
 =?utf-8?B?Yy9yWUtHelFVbndYNnZnUFRCNWVZVFlKUDBDaE9qajhNa0EwSThYK1hyK1lP?=
 =?utf-8?B?RnJKTnlaWlI1c3ppdnRUY3FRck43dElvRnhmWEEvdTE5THg5UnFSZDBFRUJa?=
 =?utf-8?B?NGJsaUpIUzNZN2hSQk1IMVVmbjFSSzJwRXVpRHBtbTlxNWEraGFsamFNNkJL?=
 =?utf-8?B?WkVQV3NFRUxMMDFDK0FQMmpEQmw5NXBKWEhzSXd0ZVFMbDE4NHBBdDFBdjVY?=
 =?utf-8?B?ZFJvK3RiUzZhOWxkRmx1dDV6Q1dQcHlqZ1QvZVlmNmtIS2dNYWV1MEtXR3BC?=
 =?utf-8?B?b0tSUHB1WldGN3RqQnNDOG5BYlR5L0kxanNZdURKWTJXQmo0RU9vWk5GS2xY?=
 =?utf-8?B?N09veG1jNUJuUmtHQ2YxcjdtZW5KZWdjTjl1NWVjYXJHazFZSHBYaERoWTNK?=
 =?utf-8?B?eHloUGxOV1AvaEtuc2FWUkdKemdBcis5SzdCc0dlMFBkamowQW9KNkV2Nmxr?=
 =?utf-8?B?ZmVlcHlTWEdZeVJPWkU4cWFzT1ZZTjM5aTRnZjQzSEg5UVZtQXk2RlpKejlo?=
 =?utf-8?B?eVF1YjZNajdkSDFpT1BFaXQ0VlUxLzR2YlEwQ2lERHY1ZWgrdjhZMEQyQWpP?=
 =?utf-8?B?Y2MzcUxVUVdmcDhSRytkL0tBMG9ld2diZUFHSTJLSHNmOEZQWjRPK1pHcDBv?=
 =?utf-8?B?M09GZm1HQUNqZ3FkVTgxcVBGMjBNNk8yVFhHVFZTUW1qRG9qTkJrcUFzUGUw?=
 =?utf-8?B?SHJsUWZQcTFTNWZjblpkU3JQSUU5SjdLSDZrWGdxN2RYQmVnaFdPdmdaNUhj?=
 =?utf-8?B?L2R0QzBDc1orKzhXMXo5MGduZGtxRUEzbU53M3V0U3pYVUVZaXZjcFhTTGxH?=
 =?utf-8?B?bUhEcDI1M1Q3d1dCNU5MVGdsVUFKSVFJc3h6cGkwbXFZelNLU0Fla3Nwa0M1?=
 =?utf-8?B?ejFnazZES1pYblVoNUt1RTZiUlo4NXlLQ09ZeUxnRjFFVEkvWlJpb24xNExy?=
 =?utf-8?B?MW85SUJCOWdSeEFPZkNDY1lSUDFFeXZROHN4VE1QbmpEUU9ESUhKeUtFTXFo?=
 =?utf-8?B?dEdvUVNlVlF6cElKbGpBeHQ5K0dtU1ZQejRGaS9qakV3ZEIraStaOUo1cnNv?=
 =?utf-8?B?UnVtekx1SWE5Y0hzUEo0QWh3Nkkrcm1ZRktnQmF3YUQ4QjhxZDQ3bmFnelFH?=
 =?utf-8?B?aHc1NmhlNkpOS29kVDg2Wk1uOS9xbWo5N0ErRDZuY1pBNThyaWFaQzFlbUVx?=
 =?utf-8?B?ajJMZytGaVkvQ2FXNXl2U0pJeUg3L2cwT2dvK0dLTUFuZ2dvS1llZjRqZW5H?=
 =?utf-8?B?aXE1M1JPZFBHSWpwN2hvc2lETEQva3VQNEc5aldUTThLZVdOY0dZYmxzZWIr?=
 =?utf-8?B?QXMzV3d0c01ZT1NCR29kcW9hUXV1SGk0d2lmL2xTYjFjU1JEYm5NcWNTd0lT?=
 =?utf-8?B?bVh4U0FqL3kwelYvVUJmdlZ6WDY1ZjFBZDdpdUZDMm9RVXh0WWRZM09ySVAx?=
 =?utf-8?B?dUVFcHpTbzZIZ3NWL0ZPU3pKMVNUYndUV2F5dFlnU05tUDRocGlpQzhXRzNU?=
 =?utf-8?B?R29GQlB2T0QyZzNtL254OGRxMEhIR21uaGpJbElYY2JndHloSEpVZVlQd2Mx?=
 =?utf-8?B?YlU3NUVqOEQ1cklzeTFXdkh2RHZ1L0FyakhQNXlBdG9hdTRDOVd6L3dwM3o2?=
 =?utf-8?B?VElOenZJTnErbUdLTkc0SXVYYW12MW9TQTVyTVdQaUF6ZHR6QjhTV21LWGpo?=
 =?utf-8?B?RHQ0NDgwa1Y2bmhVRlB1bVlaUHNTZlRVR2YxVjZCREZrMGdCeEZYeWQ3ME9y?=
 =?utf-8?B?ZGNDTnRkaG55Y1lnYU92Tm9zbEQwb0FVMll6a0tLK0pIak0yNzlTZVNlN1h0?=
 =?utf-8?B?WGhvQ2h2diszR3FUb2NuS3VHYkNwMDhBS3UwRFlteEVuL3RZaFM4SzkyS0Iw?=
 =?utf-8?B?YnNRbXhjVUNsVjlCQmNvUjd3cmQ2eE9yL0w1dGV2TDdyblZJQXdZYVpUVXR3?=
 =?utf-8?B?UmY0VUZQU3hOQTVrOVZkN3FoMzlwYS9lbGx6cmdFUmowNGQwTmhmc1YrcTRu?=
 =?utf-8?Q?pqv+aEV+/nHPTDC8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <781297082776D94C9B3BEEE7FAC297B2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: OOg3imdqLMh4nV8qI/nFV8/DgWE1LGPvzSPjILCCwM9hdeGitbTkrka6UivzXNXwxzI1KbTUN3wKS505RyB28Cz7cdIAlpheH2mVaVXClFOF36vZHPXwjJnmT+8Kx/9V+0zQ/ZgMrm2r4nnokK4wI8DVRkFs8oM0KgyQ0LyZd/bjNA7vRY/RQ62eR4ls3Qsb7FVbYej1Nn12VygIWZb8qT5u8ufKy0ZXLeZx82djTcpq65Yo4e9sT7ype7aV9fA6B45sMPx9QZGZ1R+/iKSljUx1RW72tooX7A4Ftbvq7ewMzIP2yOkIjrdsws/i9V7USGIcDZfEJiFPzuSoT8apBA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c65657eb-1011-423d-3847-08de743e2f72
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 07:19:16.5414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: giWQsWw51Iu2hLbM916JCBTmB1ZHujFdZBXfl62Yg0p1TUSapsAdQg4bsfNQnjXYit79evPNOCxpskVMzwpISw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB9573
X-MTK: N

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDEzOjQxICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZQ0KPiANCj4gDQo+IEJlY2F1c2U6DQo+IMKgIDEuIFRoZSBVRlMgZHJpdmVyIGhh
cyB0byBhY3F1aXJlIHRoZSBjb3JyZWN0IHN1cHBsaWVzIHJlZ2FyZGxlc3Mgb2YNCj4gdGhlbQ0K
PiDCoMKgwqDCoCBiZWluZyBvbiwgZ3VhcmFudGVlaW5nIGJvdGggYSByZWFkYWJsZSBwb3dlciB0
cmVlDQo+IChzeXNmcy9kZWJ1Z2ZzKSBhbmQNCj4gwqDCoMKgwqAgYSBjb3JyZWN0IGhhcmR3YXJl
IGRlc2NyaXB0aW9uIGluIGRldmljZXRyZWUuDQo+IMKgIDIuIEEgZnV0dXJlIHVwZGF0ZSBtaWdo
dCBnZXQgdGhvc2UgcmVndWxhdG9ycyBkaXNhYmxlZCBkdXJpbmcgZGVlcA0KPiBzbGVlcA0KPiAN
Cj4gUmVnYXJkcywNCj4gQW5nZWxvDQo+IA0KDQpIaSBOaWNvbGFzLA0KDQpPa2F5LCBwcm92aWRp
bmcgY29ycmVjdCBzdXBwbGllcyBhbmQgaGFyZHdhcmUgZGVzY3JpcHRpb25zIGlzIHdlbGNvbWUs
DQpidXQgSSBhbSBhZnJhaWQgdGhlc2UgcmVndWxhdG9ycyBjYW5ub3QgYmUgZGlzYWJsZWQgZXZl
biB3aGVuIGVudGVyaW5nDQpkZWVwIHNsZWVwLg0KDQpUaGFua3MNClBldGVyDQo+IA0K
