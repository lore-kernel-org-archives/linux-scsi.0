Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2461137AA88;
	Thu,  5 Mar 2026 09:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703476; cv=fail; b=VQCYTQ2SUu8rk93nZzj7PKh+agrDL9hS+R0gm0sySTph/Vu8laPJxUEVCmADJ/tx6zz62drjTehNRbo/IJHEKSUr342Q2diON0OcdsEQnZyK9R9ARIEfOzqdrtYiHQ8dHuv4PI2j52btM8R+MbAPH17Q965D2SPQiHPsz/8V4JY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703476; c=relaxed/simple;
	bh=mUgngtQPjrKHMYXaOseDXxs925fwvCXZOLZbq3nWhE0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X6zURO9r7aBhruLs+n4IdVhIRawDWP7xr4oSPk5DHi4AkkzNT7lWJqConm4TlI5RFShKkTHyyoIqaNHtDDkc01QPLoGcNU/NtIB/zdi+a6glzUsO5oG/dm14s88GE29NFasbzIZr4Ojp8sTnDa93z6P7Q2q0BzLC/FpPteYCcL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hZSoZFii; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=I9+d1Rqj; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hZSoZFii";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="I9+d1Rqj"
X-UUID: f82ed4e6187611f1bcd7499a721e883d-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=mUgngtQPjrKHMYXaOseDXxs925fwvCXZOLZbq3nWhE0=;
	b=hZSoZFii0duhl904pfzxB8+n1qWnMTtLcWS6gqObcce6FTKYZMKXKS3mLsMNVDEUU5cwjdtDB7Fi0zdMtQZ8iwcmppYMaaHUF2gIiyDd8jas1u+1sJU7QsMvBQBFpxIl5R3KuUV+ePjnT/JQjf21nV9CqnbTR9/YwwL05GxGlW0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:9853fc68-70ce-44b6-831e-67f89dd84d9d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:5bc646ea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f82ed4e6187611f1bcd7499a721e883d-20260305
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 50058356; Thu, 05 Mar 2026 17:37:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 17:37:46 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 17:37:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1Q6lgc0bd/jp0FtSQBl5xSauB5nTJyV+IAFq+49TISsicRfDLeLbnu/moByyaQ6TZQ6uCCM/LgJ1VdbL812hxV2FGMVyPDfFY+jdm4IQ324EGr65+cyjeQnS91U7EOj2PM3++Gzf4+XCT2fe6QMYG0cYA6mVtuhVdihrfHjHE0twufVR46K8y4OUapOVpOr0IODKSQvquqIY6iVo910MGvuqSkcRCHdEwBSIgoIEs1Z3c9/wNa+XP2fsFvxoacY3BZdX3vevrmOaAAciTI0rlKxk04Ajz5qg7SiM6gR2JOOzvvRd6kuFo3pN0jf8KHrYhLvOoENCP4CyR4kLLQUUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUgngtQPjrKHMYXaOseDXxs925fwvCXZOLZbq3nWhE0=;
 b=QKELim+pZqx1NgAWJZkRVIOOzzRBFZ/rNlZjLtND4OVWnZWPXqk3otev0BLlAcRMpWGLvRK27gmfbLMdF0L/iSFcc4c0VSXf1aXi23R4zUZWjfXsO+0m/xjD+42hTFukhu7j1ZXNyvszBQoqAi3syaRNRrsC6zFp4PWDy84GR6oaxPv3MZpxZjQ7h4qjsym5FbHKvcOZZmKlukPSgFKLkzieYQPB/F30yuCiZK92RA9wNohEyBBX3bMtBo1BpSXWHMHWr+TGdP39morxup4aMdta9A3WP+QjW+/pqqrOczUHKx88l02RrvOvmnQVHd8XCt9ZcRMeA9l+JN8luiElWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUgngtQPjrKHMYXaOseDXxs925fwvCXZOLZbq3nWhE0=;
 b=I9+d1RqjQcPq0o1rwUFYAsDzAhndRdkz/BZ/eC0cO6Te9g5CcpGDkzGys8soOcFTQaZjNKlGn+EVyWbpXvYvz0Juqf03CvVgQdjK/Ta3bhz/8vIzzfc6HK8EpFow++waIcaS1zI3v3wiyDn7dxicvGFaxyRJALqI7JCRhRM47Gw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8822.apcprd03.prod.outlook.com (2603:1096:820:144::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 09:37:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 09:37:42 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v8 17/23] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Thread-Topic: [PATCH v8 17/23] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Thread-Index: AQHcq+cZXVppKOVsJkaBkhcDhEq4LbWfr52A
Date: Thu, 5 Mar 2026 09:37:41 +0000
Message-ID: <7e94a3acfec6f7d967a66993de81e1d52f1aaa89.camel@mediatek.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
	 <20260304-mt8196-ufs-v8-17-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-17-5b0eac23314f@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8822:EE_
x-ms-office365-filtering-correlation-id: 9eeb4c33-584a-49c5-511b-08de7a9ad92d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: JI1WBJhnr8ymZ5bb3VDPiLKz7ZICKvxTUhdIqquQuRqQbLU0WweOZXLU9p/IDERm95ma9Vq5f4EZUNg62W+uwXzCwAij1nDM/RTSyXTR3CClTqMXhy3JFGWkviuT0aqgksJcuajX+5Qptn8YMNaavWTp42aa91rYRa+fO7DPgV9CCdZWmKN2O9xBcoJqgvDC6Pkpz2JXu4O7z+IKfXAeLW7rfzoce+xRn+6YZicRtqoxiVdSqUBs5q2sZQ35p2As/oKy+nSrWRhEQF+Fzo/9USZKZA1U0+dCJjrr9vC0hTYc5CjNDWVNpJG3BaJbwfxDXARDbj82xCF8NTbcbQarB6WUgQYfgN7N6+vYsz4TgaZRNHdOUTErYyjgLmQRfUcdjILzns3kXdnJyODPu0IDrZnKGvhGw7+re2ARu0gUkkAK87swy1oB7wnjLVbRn6xD2okUBLipY9kSXK3XPVwKaC9w/C729QiaeFymcEcPbSct5RCWrpQgtyDry/QLv376aSEGLtXMIBc/knY2sB4GN9G/Olgn1XU/vAK6UrwWGhCcOjZT/1DFbYf1SHZT54U+jBa7PNK+4yTM4jTWLbdSjVKikPmj6HlYn51J4opQbq5zr4i+6ZZqzv82uFylTP324XNfJSQTm6DZ4C5E94owBCzoeYDvPKSHgZqkEi688DMf262Ye/j+B9Unr+KsG2rQ+8taY/0X+a1aOCx1HWMrfK2U2XksYiswLeuJL91222JZwjHSrsYG1w5UghK+JuaIyU+u1HjCtmENu/L9xGn4Ena3LLgGoig5oOdSBouq7VZbutktk0pR/rQOSh8dlGko
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmlDSmp2Y3l0NFZMcGp1WnVpYWE1SXVLSHJzSkFCTS9JMHpFRjFiUnprQ2hq?=
 =?utf-8?B?SXFsaE5wZWdDdlBaM2xLa2x0MjdBVjhSUTNQdWRQVU8vRU56WE40YVJUejBx?=
 =?utf-8?B?YXRLR25JOUUvQjBVa29iRXZKMERIUlNVWmhkbXRpQUlvNWRSR1VJZkJoOVAw?=
 =?utf-8?B?S0lqM0pNOExPYm02aGJPSVk2TGxZa2ZGbHpwNnBiMG5UM3ZIeUhEZWtmSms4?=
 =?utf-8?B?RlRWWEcrNXFsTjF1TC8xNWFFelVWSzVISi9ZRDBpcG50bXhjekZ2ZGNDZmxt?=
 =?utf-8?B?d3N2c21VcFpmeVplRnNlSEhDL0s2aExUNnNHMnRVeSsxREo5NW9ZY2pwejVU?=
 =?utf-8?B?ZXNEM0ltUlRoMisxTWJ4Z1B4Sm4zZjRFZzA2OENiVitJZ1VPKzUxK1FFUkxT?=
 =?utf-8?B?cnFEVVJ5bFFvZHAwdS9kRVBWS0JUTWVkakN6K0E4VXdDN3M4cjhGZnNsZjlQ?=
 =?utf-8?B?ZTV2Q04rNlJVVHlmc2QxalRJY2krMGozQ2U2bjVQMUlTM0dub1N4MllPaVQ3?=
 =?utf-8?B?eVNLZzkrZUtia2h2TXBmOXhHUElBNU85ZjlzdjJ2OVAra1dESUdtZTdSRnlE?=
 =?utf-8?B?ektVY3J4anpaT1hnZ0FLYXNQY3pBaFdlb2gwUDBWbTROb0lSalNBVXhBRVRV?=
 =?utf-8?B?RWRTRThoMkNwZDlyRzl2RFhVTkhhU3dMT2lUbGdUZTJWTUxKV1B3MmloNXF5?=
 =?utf-8?B?YTI1Q2RvdGVhemF3ZVlLcTNOQzRjdm9pYzI4TkV1YWdBdkVqMEpjRXB6ek9F?=
 =?utf-8?B?RUtqUDVPcythQi9ZZTZSM0JMTXFKUDAzSXZETldvUHNFcG9tQkQ2SkVLdjM2?=
 =?utf-8?B?eko0VEFGZlZGa1lSa2ZNZXZ2YWhKU0RsSkNKK1JkWWU5WG5XVHUrZkZTRW8y?=
 =?utf-8?B?UVRPK3VuMkVpN2I1VlVkNkpNVjJGUTZ3OG5nUGhVK0FCbnQramgvdlE5Sk5W?=
 =?utf-8?B?QWx0cGlvbFZuczhsVTBRQVhad1REU3Nhc2gvRXgrdm5QbG5zek5EZDd3d24w?=
 =?utf-8?B?SFUvbG9wcGcwdFRTVnFCVmlqM0ZXRUt6Z252Tlp2VUQ5SUg2aE1ZMEd5TXQv?=
 =?utf-8?B?T3d0MFA2d1ExdDIxTDRrdktCS09jQ2lSL2grYytjVVRNQ0J0eDQ1bUM3dXNP?=
 =?utf-8?B?NEloTzQzZi9QRUJObzExQkFubUZWVk80K0FyNWx6N25iRDBHVkN1ZWlKUy9I?=
 =?utf-8?B?UDgrS0g5L3l2K1piSVVySndQUXlQL1NhS01rMDY4c1ZGUExGQU9aVlFUaCsr?=
 =?utf-8?B?RndJeDBZRks5cjJWS0dUZTllMGZXRUY5eUpuVDM2azNLYUxlVEs1aHR0KytS?=
 =?utf-8?B?OUhvQ0ZYeDlJYnh6UlA0NEY2aGNLeUtmT2VrWEtuT1FuYitoVWRDbHFEK0tI?=
 =?utf-8?B?dkhMTEFGQWxpdkdJZmh4YklHcVhOeHQ1WGxsNG1FYnBqRlhMQWJDWDdURUlx?=
 =?utf-8?B?aG8zWWZNVTluM0xuQW1MRzU3dXFZVmI0ZlV0a1A5cFZXUXNram5COElDdzNY?=
 =?utf-8?B?dGo1L0V3UHRmc20vbVpLL1hqeDExdUZkNUJwRk41VmRUaXJWZ0dRYkZnZC9Z?=
 =?utf-8?B?REJrQ0JTNHhDVGUyeUNMb3JYaGFmb05WQnZER2drdC80VmY5OUJaOGVrczlW?=
 =?utf-8?B?cHYzU0pxcHdIRERWbXJFM2JCVTl4TFpTVFA1UDRSZVd0K215cEhhZ21najVB?=
 =?utf-8?B?ZGl2MzBFUHRHYmFCZE9wUFRKcHo0MDd1SVpTYndZUWZBZUJGT1paL2lGcUw4?=
 =?utf-8?B?NkJzYmVVVlZJc3BtTlhnOGxFT2pwRmNYamlxYmtja1QyVDdXeTU4aU81UHFs?=
 =?utf-8?B?SDNXNkQyK0hacFAyVVY2M2t1NlhBR2YvR3hmNzNXOFpVblF5QU9WUjJDNS85?=
 =?utf-8?B?VytTTHpkVVI5TFE3N0FPam1QNkNLamJTWkNyUUNWZ2wrdkJPUlY3QnRnQ2VZ?=
 =?utf-8?B?d1dLSmx5RWwyTXBEZ3UzcjdBLzBxTmZWTGJGUHgyamFGSWFuRVJEOHJucDhR?=
 =?utf-8?B?SFVDQTZ1UmZmSVpTOXg2L3hoaXM5RVVXbFNhTU1CSlFncjVLdThtblBHWGtq?=
 =?utf-8?B?cFZyZkMxTlV3YlFxZS9lRXB1eU5jbm5BYk1mY2QwdUNqYnJGbWZHMC9xQnhU?=
 =?utf-8?B?a09yVy9pZ2Rwbm02c05HSDcwU094dHJ1bUlPbW1iL2YweldKM1ljd0d5T2tC?=
 =?utf-8?B?Q280ell4RE5SWnp0SUoyS29UQm55Nzd1YStFaXhvWFNoM0k3SFdCT29POXNu?=
 =?utf-8?B?U1BCell1NVd0MU5TMkZ4eDZRekQ2bm8xd0dzN3lOQWtRUGdVN3M0bnc4bVhx?=
 =?utf-8?B?OEFxM3pkMzZaeExvdDExa2pVdTJCcFo1L0Frdkt4YmRVMVZwQ3FtVSt0TVVp?=
 =?utf-8?Q?OvpQGBx5vDThGdRw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5DBACB299BD664E96C90FE341E7941D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: DliczXiUHikQ8MQW9ii9RVAHoGi/VNexlT1bcMFpBIw/2h4ZfICAAEYhrlPj2cLItNQ5ap+TFao/ntOMwYfvWVmQClVYzGwxxnKOCNdgq3fK3s/s8RvmFZBMhwVnBiZJOamavPEGMXyOSvKqWLTMbGvbnH64Y5kbAyIaLwGBRbgUZMDrEAJ4NmgNnkaA1LrGW5pXy9dI9ESESnrUXTgDHutTY3PhG8kGt2ugd6vEnelpyKy9olS1gPM8yyCaUCxLO0f5XqcWJSGxL5bXvbbut6OCMYO4B9Bokj2ZkvuwZ3J0X8vjx7KoyVOT9ZPE7o0gsLwFJU1SOn8QqVDQ7PodAQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eeb4c33-584a-49c5-511b-08de7a9ad92d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 09:37:41.9966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OOWVSU6BXqSP3OiDyXl9MctyV9bmeeAkGt2ILIuSd4izB+DIp7tLX20b3Z4EoExfgmNAID5CagMXtb5yfOG0Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8822
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDE1OjUzICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFdoaWxlIHVmc19tdGtfd2FpdF9pZGxlIHN0YXRlIGhhcyBzb21lIGNvZGUgc21lbGxz
IGZvciBtZSAodGhlDQo+IFZTX0hDRV9CQVNFIGVhcmx5IGV4aXQgc2VlbXMgcmFjZXkgYXQgYmVz
dCksIGl0IGNhbiBzdGlsbCBiZW5lZml0DQo+IGZyb20NCj4gc29tZSBnZW5lcmFsIGNsZWFudXAg
dG8gbWFrZSB0aGUgY29kZSBmbG93IGxlc3MgY29udm9sdXRlZC4NCj4gDQo+IFVzZSB0aGUgaW9w
b2xsIGhlbHBlcnMsIGZvciBvbmUsIGFuZCBzcGVjaWZpY2FsbHkgdGhlIG9uZSB0aGF0IHNsZWVw
cw0KPiBhbmQgZG9lcyBub3QgYnVzeSBkZWxheSwgYXMgaXQncyBiZWluZyBkb25lIGZvciB1cCB0
byA1bXMuDQo+IA0KPiBUaGUgcmVnaXN0ZXIgcmVhZCBpcyBzcGxpdCBvdXQgdG8gYSBoZWxwZXIg
ZnVuY3Rpb24gdGhhdCBicmFuY2hlcw0KPiBiZXR3ZWVuIG5ldyBhbmQgb2xkIHN0eWxlIGZsb3cu
DQo+IA0KPiBFdmVyeSBjYWxsZWQgdXNlcyB0aGUgc2FtZSA1bXMgdGltZW91dCB2YWx1ZSwgc28g
dGhlcmUgaXMgbm8gcG9pbnQgaW4NCj4gbWFraW5nIHRoaXMgYSBwYXJhbWV0ZXIuIEp1c3QgYXNz
dW1lIGEgNW1zIHRpbWVvdXQgaW4gdGhlIGZ1bmN0aW9uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Tmljb2xhcyBGcmF0dGFyb2xpIDxuaWNvbGFzLmZyYXR0YXJvbGlAY29sbGFib3JhLmNvbT4NCg0K
UmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0K
