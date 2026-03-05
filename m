Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29C12749ED;
	Thu,  5 Mar 2026 09:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703574; cv=fail; b=sZPA7smb1s7ouwRbxhXZ1xiObu+62O2ZhjvShKwu55wHojFHMmu4GrLN4LU8B+F88j/ZxSNJ1sunDGcH7vLSnnBlr2D+TqEo0Pr+wqplQPxjBiVFM+JG10N9addDeUYilCpoIHZyz9QUtzdgOIHNfKgJLxgA8qGLe0hxlyws3OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703574; c=relaxed/simple;
	bh=1iJmHmzWIj7ydbWIIanQwVPbV1m+mhKTS0wHuyHKT+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rT/gNUPK5CzNpy+GZXFarJuu57EL5RQavRwzvUxRtOArsxi96EUUQtZmTUJ6oAwli7uodINa+/mxfHOrD7PruLzxkfk4bCNRzaEL/vTghcML6FaZ6nsD2jz/Yk5qR3ZNca989WIngHflTVK0gbaZBICKet6ffiABZqjfgN4nRmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=d1wtylG4; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Fw/+elGs; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="d1wtylG4";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Fw/+elGs"
X-UUID: 32a98652187711f1bcd7499a721e883d-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=1iJmHmzWIj7ydbWIIanQwVPbV1m+mhKTS0wHuyHKT+g=;
	b=d1wtylG40KIG/s+ZU1rs17MzAHjT7FB59ZVVNEcqtckUM7ho+T7y9BtBczzmw1Ihz3dwhZb+X+coADwhYB1tLJTVeQbCmMGNOcgBOj8SZ1bfbvYS57wWW58IJU9PBlZJLZ0ynPKcfJGLuKOF4sFb3E0hl5RXugXPF5pAFnc2RC4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:ac497c2c-80c6-479a-af5e-f893ecd07ebc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:39e5e45b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32a98652187711f1bcd7499a721e883d-20260305
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1305763538; Thu, 05 Mar 2026 17:39:25 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 17:39:24 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 17:39:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPaWfr+QG5eVLwW5MgucOCa5btkn2v5SLdd5sORv255eGdCCJGCAFkL0w+Js7sVwIGrAcQ66BeULhiwU2e9LQpmQ1CW44ks4ls3fuRrJIzIxJIQWoHdeeAcR7gZCFQ4Mr3hp58QXBaKwJ1QIcfY+IdLgP5DbqZp+Kf1fvgWjMx3hMi0ukvWzNbeO21A4rlhQJu2vqSHak0bdt6vTC7N9rLQG4yXuPnP2D2WUp72fWmGDRMX/WxMBII0M6aC01fUpyb7MqXYhKj8VC1Hs9Dbi/qSAXiCdbe8ExOAlM8PRnEHtISiFISimVKdldtnaEaABuH0PqOASpdSVZJJ2+BxV5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iJmHmzWIj7ydbWIIanQwVPbV1m+mhKTS0wHuyHKT+g=;
 b=fO9MveMPg/YDS4WJ+bQrzVUVvn1x51lhvcjCmuy06vK/489i3iucC+vzVY6SDGFjilode4HxcAiV+QOxAu5fxiWkNbUP1WHoVcB67hJ/Kmub1G5F79W3g80EDPSPvT2VeHD80m1GccY4m1TFoih4Xkwg2qfrWqAzBcm5Z6VGYt1/u+PXGrib9wH08sFfKENwT8xKDHUKbkVNdDsQOid44t990PUWsmanoozGxkyAiZY+jBpflAQoPSvtBxBZEH7Xv4Vddu6/NkOjTi76sQCE2aryBgvf2JMWMbF0K9BHmt5H/E5Q4BorPtEtwD+KBhLiF1B3zLbxyr2obPC9en05Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iJmHmzWIj7ydbWIIanQwVPbV1m+mhKTS0wHuyHKT+g=;
 b=Fw/+elGssoKcxFABJTqeZSlb0+yX0Rk8ZHEGYcugPFs3ATkdJZiSsdI+x3GboCM4OyDJwMlp+VlXFcnTu9AecDb3ldPVUGbpb9IUGFTVS1Lxp1x2UGWzJRFUYZQoL23QyuZuhJ8EO3DnpiwSIIq9KOD+VXm85EVCMGFcx0xy+9Q=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8822.apcprd03.prod.outlook.com (2603:1096:820:144::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 09:39:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 09:39:21 +0000
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
Subject: Re: [PATCH v8 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Topic: [PATCH v8 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Index: AQHcq+cF2cnBq3nuRUSLS7+9UR1t9rWfsBQA
Date: Thu, 5 Mar 2026 09:39:21 +0000
Message-ID: <7b85028c529ce1b4ab33d2cc3e385dcefd51a1d4.camel@mediatek.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
	 <20260304-mt8196-ufs-v8-20-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-20-5b0eac23314f@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8822:EE_
x-ms-office365-filtering-correlation-id: c9ebb213-5bad-4310-b521-08de7a9b143a
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: CJGDIjX+Xrt//Hw9PgNIEGuTArH/fltC54kXCK7bll2daJTkDtA25JczGd/symxgJxvlR37jgcIXXFINV/0U5GTdqyJldBiwxGzOHakry/6d21zQCYrpDkOi9U3PFp2MAqnTQxdmVhzYwvGhHwvTQ5+cfdxPPwt3QOMMvbmDxH0Kf+cIlpgapucqcMvLi9DrqwMeCVv2wbt01rXWW/L7iV9mBJhjSbMPBfVd6guNocAzBEpnTF445SL0RzPYpc70Wl7ZktR5jcnxmWoMIl9jvnbFc4cP+C+vFPdHRx6h1RxLMbuIM/f4QA8Thcik/BC16X0lRHJWQi/1IdLTDtWLEocXEd63Aez0dTuOaA9SUze4nIYJFSJNSTEkV6kIpQbvGvTlpM4GVkugJ6Y145a9y5nUP6G8zfh7vr5gYxjBBhtIhEvVsDlrnbt8U4AZGNXRwmarJUdMHknah43F1TbtGQ/i4u7yMGJiZK45LMqzWZGaZybFGUBS3CIbavOoazl02FQHZ5FfYDvie5nhuuLdFjWHslOoZhuJzRpDc8UYyBuAeI1lTRe1YOGMqrZ5++TpiIvZ9rnL0rIeMY+Hto1q1tFz5T25vdh3D7oo+Ax6QAwKGbW6XFt0VVFC06klxnc7jfR47uRNyFSJUx6a1ppvqUy1vyoL4qYPx5/jJM2uB7EBMWBDt3E5JOgQVocgGO2JDSjou5MPYejj/HdeMSQuI+k0KnsvoDTS5S0F3YRlTOZzgZ/ascv7Mncft9nD/c+8G/po9MYXaAj6r+Cxkp0pkDzwCZVkFi4GOLt9Xel7ZFO02GRS7Nb8QSn8o7to/4o2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFVrb1dyM2hSNklFSC8xZVdhclI3cW4vdm0xRjhSNEpkR0EzVS9ycG1SU3VO?=
 =?utf-8?B?UWE1S0E2VnJHRlhHUURoM3lkMVdIMGs2L2FMSURhelNwR3VSbHNGRjNCa3JO?=
 =?utf-8?B?TFpYNUUzN2puSmpTa1BPVGFzdkU4Rm15b2pQVU14dDNpeDRKekNBTGFjbE50?=
 =?utf-8?B?MndZRTNzVWwzbEQ3Qk1rL2didkFwa29kUG9oS3B2bEp6QkJibHdMWW1JSWNJ?=
 =?utf-8?B?Y3g2c2xFZ0JERkR0cXNrY09uTWMxeDRxREVyWVhUUDljZ3ByS0lUQjh2ZEhk?=
 =?utf-8?B?a0VFYzJESUtYVUNRQ0RDNExLVnk0WVl0emljOXJad011UUpuN0xRcFFsekEy?=
 =?utf-8?B?emhBbGNGNkErYnVVOWtDdTA1dnlnbTZqSE9neDdueFAwTWtyaTVMd2t5UkVV?=
 =?utf-8?B?U2krRWc4M2ZUQys1eWNLdWVyVEVTOWl6NWdKaW5XWmtRMjdnWGk5aDdHTEZa?=
 =?utf-8?B?N3lKek82Y1Q2OGtDUVgrNGFkbFR2ZW8wL3R3dmhiL1ZrU2xFT2hpMmtJcVZM?=
 =?utf-8?B?NkVUMUx4ZzNqTndjQ3J4M1A0S2RwT1pNUis2cWhaTlMxN0tOakZoUWxKcHpn?=
 =?utf-8?B?eG1lYUN0dzg2NDVYV0JFUkQrcjNUdVJRYk10QUt0TEc1ZXNjVFBMNHN2U0ZX?=
 =?utf-8?B?MFJ4cWlhT2UyNmJoa1g5S2VSSWJEM3Nkdks0VW4yMXpFWE1GZkltUCtwTlhT?=
 =?utf-8?B?dVpFeTFkK0JaQjVDd0ZSMk9UNmVaN1gyTnlVSDM0OXdmMnpRZkUySmplcG5o?=
 =?utf-8?B?elNqeU1pcThNR3ZSV3R0SWlMZTNITDRLRE40SitRSjArZ20wK0pPK1NuSVZP?=
 =?utf-8?B?cDNkMHJ0R1llWUljRGhDdTBOOS9oMjU2bmh5aXFLenp1OEg0bjltbFpCMXFv?=
 =?utf-8?B?bk54RXpIcE1BSVRZRzlKWjRON0dOTUZWQ2htblltTXhSYVlIUjM4TWNRWlFV?=
 =?utf-8?B?MC8wK01uMEx3aWpNaDI3WkxPU0QrdjJqQXpZVGd3bEFoOFhsRVRZUmE3RHhT?=
 =?utf-8?B?RFEvSXFnOFkwZ0ljYThHT1FjNGRnNE1vSnljSkVnS1FwRGcwU3JwTEMxSjJF?=
 =?utf-8?B?dS8zVVJPeWdBeGVxOU83K2s2UXhxbWllYlorUmtZeU5yRDl0Y3ovM3Q3R2NK?=
 =?utf-8?B?cTh4R0RSY3AyNkhkR1ZJOGRFNXlEL0tDVnQ3VDVLbnpEbEw3ajhMUWprQ3Bn?=
 =?utf-8?B?T1BMWC9kSGNDVFpPeExYOXQxbGx2M0Q5MVQ1ZlhESGQycW9WZjJPRmREdFJx?=
 =?utf-8?B?c1JESVpYeWZpSjBJelRtUU1vL1NhbFBMcGtyOWFLSEoxdWxPS0JmV3Z6VHdl?=
 =?utf-8?B?aG54dkYxajhGY1R3RTd2SnBuU0ZFdG5xSnA1Uk9oTHBVc2VwRDNlUWZ4N2Ey?=
 =?utf-8?B?SGF3K25wQjlqcjY4V1ViR2E4VDVmMktobjdMb2htSFltdmxWRXZDQ0JCMGNz?=
 =?utf-8?B?TGpEcVV2amF2VnE2UU95S2dtdTNNQXNBRXVhM2VwOFlCVlltNmtFMll6SW9R?=
 =?utf-8?B?cVpjRkdiOGh2cmJ1a2pRbXBWTEs4S0ZtQnJGYk1RYTNzMmFjOGM4NGJYYmFS?=
 =?utf-8?B?aFljbXNZN21JZVVYdnh3bzJYWTBqZmI2VnVRcXltL2E0OEJna2VrdzhkanVH?=
 =?utf-8?B?YmRjV2R4TGptdHRxWG9tRWtVWlZrVHFBQXU2cGI1ZGRhdjM1RTFVcGdwOVFX?=
 =?utf-8?B?SUErdkdweDEwSURhbW9obGJ0MlZtWllxak5UV0VBU3cwckhTeCs2bzN3Wlo4?=
 =?utf-8?B?RDdvZzJBUWJrYVFBbGlqTWorWlBQWUt3Y2tBUzYwVS9NUjdyd2ZiOCtYTFhG?=
 =?utf-8?B?TTlQRnI0ZGJ6U3dZODFsdmZSVEJTWXVrWDkyT3VYUFNWb0JQM0s4RFZBOUlJ?=
 =?utf-8?B?UDU5eHU4ekV2QW93OWhJZzFIV24yVHVtS0pUV2dCQlNXSCtZekNheFdjRCtV?=
 =?utf-8?B?eDd5VU9zWFZVTVY2cGRYTHB3MFpXU0h4c01oUndScTg5MzBxNU0yWkQ0SzU0?=
 =?utf-8?B?d0ozRGlwOElXYng0Rk5KYW5wUVRZd09qMmpxUVZpbVFvZXdtVHpIT3BnV2F0?=
 =?utf-8?B?dUQ3T1ZId2ZsVUt5UVRhcVVLVCszcGRBTEhpMFQ2b29ZK0pyTnhpZGg3QmVQ?=
 =?utf-8?B?REsxNlJiVzcrVjZWTlpxOUU0emtYeHZSbnB4WVN1N0F1RlZmb1JHWUdqRmUw?=
 =?utf-8?B?cUZHVlFPRWlQM21Xdmd4dWVRMXhJRVU1cE81WUd3OHI2REdHcUtudUw2L2g5?=
 =?utf-8?B?SzJvSXNyUWZXbDR4RVc5alJyRitKQXhsSzlLNTdaTlpFTFVsK3FmMEtTUDFH?=
 =?utf-8?B?Z0F4eS9OS1pUazRURXBLb01ibHVRWUQwVG1sMFBCbTIrN01IaVRjQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81C892C81748AD49BA31EF4593CEBA22@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: IrRyVrHCEI8Fsn06mX5RVud67ncO9BqVbcI9TiEwbMJhJau7BGMe6l/0OPoxNrg+YXCMt9s5yyldeLWRpg15CxHX72S9rtp2Nv/ZGLkB/mY6UXUk3tc2G7cMlY1BbfK92QyQreHzbp7u/RhOKOcSiABxUS1gEp4PxIspgkklTSeOqLjlvMGSMl7ehv6uGgQpalO9t08+fJ5g48kDtUixKN66GzU3eghgB3vx826ddKQdBmXA5uMpkG/CWSZTngDJhYmJ0Jiwh+UhbvLhW/am313CczVylPEkl0wiLpyNZ2bUS2CATHGPuvQFM8rZp3ABOQyEqxiYqv/PrKzpBRj6+g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ebb213-5bad-4310-b521-08de7a9b143a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 09:39:21.0907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hiw3LDi00L8Y3IQQh6oKjxYnkyGm1bw0JADOxd3h2yR7IwwJG+40oE0sn7yIklUQfT++AV4my0f7AsouVfs0Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8822
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDE1OjUzICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEBAIC0xODcsNiArMTg3LDcgQEAgc3RydWN0IHVmc19tdGtfaG9zdCB7DQo+IMKgCXUx
NiByZWZfY2xrX2dhdGluZ193YWl0X3VzOw0KPiDCoAl1MzIgaXBfdmVyOw0KPiDCoAlib29sIGxl
Z2FjeV9pcF92ZXI7DQo+ICsJdTMyIGhpYmVybmF0ZV9pZGxlX3RpbWVyOw0KPiDCoA0KDQpTYW1l
IGFzIGluIHBhdGNoIFY3LCB0aGlzIHZhcmlhYmxlIGlzIG5vdCBjbGVhciB0byBtZS4NClBsZWFz
ZSBkbyBub3Qgb21pdCAiYXV0byIgb3IgY29uc2lkZXIgdXNpbmcgImFoaXQiIGFzIA0KaXMgY3Vz
dG9tYXJ5IGluIHRoZSBVRlMgY29tbXVuaXR5Lg0KDQpUaGFua3MNClBldGVyDQo=
