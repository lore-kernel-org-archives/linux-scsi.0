Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B21E27FD5D;
	Thu, 26 Feb 2026 07:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772089251; cv=fail; b=NOGV0r1D3JlygaznHfqrDR3NY25N1HcbZIUB18pADSzeSPQN1MNxek8POFUU2tYieNrwE3w3FRVkiA6g6ELFkoFNb6kTh5RVDiohy4G0e26Ogfh58ZPiT2OcWkhnv3VTM6FvzK3Xv8Ddr3KfLNScTtZJT8jadZq+bGTIs4LkNvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772089251; c=relaxed/simple;
	bh=wMxz8fsvEWnGxJLcMBH5QNiaxFmbHIw4SHnEZoohws0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D7O14qWFx/L3H+HkFcnKozrjy95vHqHhT6+mBLiTo6s0wxQSQN2L6jO0m5R23pxfZZVE9IpqvlRXuouiIQTCS7Q8eDcNEXcsnbL5X1oXNdR2O08pxXuQr0kW0HzhcLnST/6uHJsKfNM5H1N7cvWhUNd4miLnghWX0E/LooXazKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nZUW9+Eb; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=m8WJhJt/; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nZUW9+Eb";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="m8WJhJt/"
X-UUID: dd6dc50e12e011f1bcd7499a721e883d-20260226
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wMxz8fsvEWnGxJLcMBH5QNiaxFmbHIw4SHnEZoohws0=;
	b=nZUW9+EbVXgIf21tTEQWvE0jl4Y2y1h7hFPP25OiTZmXFK9uuDW35V5aNu9Nwv34ZmcDvYV7r46QAHVAeGsuoFqb3FK55V7wV2AeFnILW3d0DPeV9KEuKhCJUHtdA33wHxNrb8QRRgys4ScbdNvIQ2HW+90Xq2BZF4XLof8WINM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:33e5fb38-a45a-4845-8a7d-793b383edbf2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:197003ea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dd6dc50e12e011f1bcd7499a721e883d-20260226
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1017106502; Thu, 26 Feb 2026 15:00:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 26 Feb 2026 15:00:40 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 26 Feb 2026 15:00:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H53gAMSbfCnr+dGfFaxzxJLxsY+1OD+vELVrz7JAGFlp4PoGTYLZafrBLFj0q4GFW+xFsgsiohCw1XWvo+/lIgqGQKHT5edD7OdyoLyhNY6lJQ3aHoWlyuV0wjMa3BjCeHLtFOWGiXh/+otOy4V+9RyYXe7LO+o9CbKv+XITZjkRtPzlQsMLknqUVwbi9nDtMX3YA7M2Dhl3jgtHjm8jHpPCWpODCpVAEj/7sceVCwnBC6DE/IDB/rBymD+dYsdQzHFGFKwlWx+JvjzK98MIPS2bTHOaHIPMzvqyqPMmIhHU8mnrZvFOIMIt0RqZVx1SCvVb8sJoskF0lodcKtnepA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMxz8fsvEWnGxJLcMBH5QNiaxFmbHIw4SHnEZoohws0=;
 b=UpC6xXTJBnCGr2f3xjJHR5ItNb2I8Nld6T5tt1uUaPlIUb+pAZHi0dg+qrnNAMwYBKAzHrhu8+uDCPi5Lm/6HmhFJcSK4PBDQzfdbk5VYVBYtc+459JwKBuYluaa81kuEvtjyxjhL3N/VFrVeeBs1T7F90QCD2Hb9PQPuzPXfWUAMrC5gGG9W9+L3NTpqNyvG4LYX+fCWdb8U3UsoUc5jsEGXIm1Zsg9GfEdrOVJAr2FMDn8pI8ykAuB3vW/weAvg3LRpg7yQrI/D6QTXyXkLGd6zycVo/zLDkoWGyWhqxiDcI/u6jZnLxlXvjKUDr+A+WSZQQAdCJZRT02UTAio6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMxz8fsvEWnGxJLcMBH5QNiaxFmbHIw4SHnEZoohws0=;
 b=m8WJhJt/314JRZYVH/sQQIiSsELNmsHh9Yl4cueEduWLoWYbbIOiFcY5YNznJ2VKaa965qF5gOe3ssx/x9+A1GGDh6YTvNuo8glpxQvqyDJ+drYoWoL5oim+OXpidz0TqapTzo0uKpUwrSc3nBTpal0ldX9/Uyh7JRd/vA6bnn8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7983.apcprd03.prod.outlook.com (2603:1096:990:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 07:00:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 07:00:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org"
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
Subject: Re: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Topic: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Index: AQHcn0ncDWW9D+zkUUupEOV+hOFhPrWR2OKAgAGXfYCAAAN1gIABKM8A
Date: Thu, 26 Feb 2026 07:00:37 +0000
Message-ID: <259b24885e5e721ae562d27dd761b02e6a68c971.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-16-b5f2907c6da7@collabora.com>
	 <c333898413d249c017430d4ae98bc7be3bf33a64.camel@mediatek.com>
	 <2575185.irdbgypaU6@workhorse>
	 <f0e97a38-a11b-4e69-902a-e0ccd0dc4540@collabora.com>
In-Reply-To: <f0e97a38-a11b-4e69-902a-e0ccd0dc4540@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7983:EE_
x-ms-office365-filtering-correlation-id: 5da26ada-0fc0-43ee-2cba-08de7504bead
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: 9mWXTEwQI55GIvnvMEIlgxcMRI2uqr38Pb0iZ5LJxXDRT1EjpXh9Dea4fDY86eInwmpBxVY9BOGp293gMoHVD0QrJudKEYw4WdKcPLJO1WiwxQ/Uu1M7dt5xc0dOzb/3L2Cf1zQBJZ6R9Kwe2O3TvheRM8mEN6n80Rjua7pd51ffSoU3iXhYbrTj56P73p00pi4vdi7JFP/rwpz0YXwlEpZxxBqoKkpN2kkbMCvO3Gs1B+M+P7mDiA7dJMAH6FSBjL4E6UWBdwpADx62SYBZZo3y58RW8IOc6UbTSdV0JEBd6XYpOMzUePXJQEd7JjJw2aun2uGAFsdMCPqHvyU254mRCJXBK1+qx516U0nNYLPjpi1452Qw69kpoQIO7CA+UTCU4+Qb5RGOpM916T7soAUvVRl+RNa+kLRV/7cXtaCa9FYvDhnpcXLkxVQGfqxVg2Qir4F9isuQHAxgrcWDZgFzh6/40P+NCf4yUT/AWtMLHkduuNoW0WFpmpJC0IwbNP0OqlJ87upCswTMPAdBLDoAexi4RRVWhDyQDPwUgKlNTZA5To4r0iLZGuh/kqNu/jVK+lovu0bN/va7WNBfD2U4el7NQwoTWZNeflRmXrsS3JD+LzDx+zJpXZ1gEphZxSoCQtLe0ffg322VGoF5txTCmYGIcokInfVMVnlHG1MzxOmkyF8dQRqSxvLjS6GdNlWaO20CKkqVopJjQGkJxcz9z7CeXup2tYCRXW9nn9Za39KXPwETc7S/SIJlxBCu3GY8dvF5JtZmV8nlOxPKT/O1uZhbsC4q5smCV4NkMe0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFk5ZWllQXR4YXBkMlIvZmRnemJZdDhiVGZqRFBrY3dWQjBLRFBpV1hkTGZi?=
 =?utf-8?B?RHFGMEs0WHpqeXN0UHRqdnJvL004QnNmREFqb3NQcndHNGh1OUNZUDBZRS9X?=
 =?utf-8?B?WjNPdXJHRUxvT1E1RDRCOG5LZStseXFXdTh1MzlYU05HTWREZ2t6cTlSNVhE?=
 =?utf-8?B?VFpwKzlneUxRNjN1bjFqZ0tSd0xTTGpSVXI0NkZaNkc3ZVFHblRMOTJhZjNS?=
 =?utf-8?B?NXBZWnJZTE1KeWRXVmdJd25haGRURk1obGdxb0VoWU8yUEJNNXBTKy9oL29N?=
 =?utf-8?B?dCttcDlnSVhYYVVQSUF5M3dSNFJUeXowS0taUkJwcGx4SGhDOUFvOU5BOGJ6?=
 =?utf-8?B?cmJMNE9YNElJbkRDSW5tN2dXMmZoZU9KczRKYjA2S1JscUJIMmhpWXR4UkF3?=
 =?utf-8?B?Zlh2RmR4cnNFUEkwOG92dU1Vb0xDOW1MUVcxdjFYT2pSVHFDR2dPVm03L2c1?=
 =?utf-8?B?ZFh0a2R3ZlJNRUw4djc0NzN3S3pPbzd0c1MvNWc3TThHZ3JIaTQvRmh2SStT?=
 =?utf-8?B?RysrQXZEcEJjSjU0M0p5azlJOVYrbDRNUjF0MHdwVEJYeXlhZFh6ZTNiblVK?=
 =?utf-8?B?UGQ5VE5uVi9NM3RZQTQvTHpUOEp5U3k2ditrTzdCLzNrZndGTDNXNStUV3ow?=
 =?utf-8?B?UjFpeENYTUFYM0hIdnVvWlBUU0ZreVlDTktvdjdHaVhCZGh0dDJxVFBLa2hl?=
 =?utf-8?B?YXdjTzhlOHpXNjkxTWZaZUNUUWkvd3J5dWRteVBoam9OVzZLYWJtb1cvRTB0?=
 =?utf-8?B?S0RHdGtUQlkrV25vVmZNcmt5ZFN3NnBCc1NxOGc0Um9FVlBlcXBEQkNLdzVa?=
 =?utf-8?B?emNyLzhxSm1KZ1U4bGhFcjRRSml3TU0xZG1hL0h3d2VCLy9tK3RDN3VyNlNz?=
 =?utf-8?B?QXppVHZIMXRBUU1ZQ0ZGU3RVVHgxTVVQY1hzeHZESHBUZWozUThxcHR2cEhN?=
 =?utf-8?B?dThjUFp6Z2tyMW45MzdCTGlQem41RzFjNWVjTnBVYmREZWpyay9WcHBnRTJx?=
 =?utf-8?B?Y2tJdkVvUmZVOE9tUnRlNjcvc3FMU3Yyb3BGdzZiT01BVkYrN0grdVhDZXh3?=
 =?utf-8?B?eEx5NE5lVmxtalN4QXArTmNGRVpOU1JOWkhFSElhYmZmZEpQWHVxM1BFNUlI?=
 =?utf-8?B?K20vdE1NQWs0V0VPczlCdmU4ZmhVdzg1TGdZUDhxRXhPM0sxRE1GVkxxbWM5?=
 =?utf-8?B?MUJ5TWlZS1pLbHhwTkhXcEwwcmVITVZ5ZER4MDVGTGQ5SWdpcHVObzhHekNX?=
 =?utf-8?B?TWVJdTd0NnIreUZldzMzN3BaRUpPdzQ3NWJ1b2Y1Sk92WHJ5Qk9JbzRxS3JT?=
 =?utf-8?B?NENyMG5lRUgyclMwOFdSMk0wRTBwM2p1SzQ5cDVCVlhONklSN3RUei9ZanBI?=
 =?utf-8?B?aDlRVGhEQ0w0VVpBQ1JWY3huSkV3V1hlaVZqb0F4Q09KNkZ2bi9EYi9DNmln?=
 =?utf-8?B?WEhGVmV6Y3RMeXRnWnBldGxJcVVPWGJlU1ZCNm92VlpvQWFiZ1ZiK1MxeW45?=
 =?utf-8?B?aTBFREc4QUk5RlJWTTE5VUd6OXhmVHNCNGdKbUJJdW9HWC9kcUFRV2IwZHBP?=
 =?utf-8?B?QjlBVmJ1UHU3dHk3RTFyRHhyLzQ4RlBOSzNQdEpYWTg0RmpyRk53MmFqVzFY?=
 =?utf-8?B?aDgzaXhOOGNtS0hXRjJ2cVd1VXVxTXdwQ1l3NFpVTk5FeXBra3VHdkJxazRF?=
 =?utf-8?B?OUZOK21GU2VSVUdFTFBMMGpld1NsbU1oaG8vR3I2U0ZQb24xSGtjNVVzcDNQ?=
 =?utf-8?B?NFMyd285K0N5djh3ZmNXZmVOam5oZHllT1BacFlVSm0yT0tqRi9UU2dtay80?=
 =?utf-8?B?OHVkRVh0enNPbDBnc2J0Vm85SDF4djJSQ1ZkUUNwMGpwVHZBTzA5OWh2Qnhx?=
 =?utf-8?B?TnU3SlBQZ20xNzYyZzFyWE8xYld4eFZ6S0ZJSENsdVQ5OUM2dk9wMHRTelhs?=
 =?utf-8?B?VzhpT0hFVlVUTUR0LzhDcTk2a0w0VW9ubGY4aUtlSnJ1WkZoY1NwcXVMTHlh?=
 =?utf-8?B?R3JlNTA1NVFsVnAwSVBNcXdsRzZJSUJtb2MwWEVyMlBCVHM5bldMMmswaTBX?=
 =?utf-8?B?OGtYeE9BRkRURVRDdGd2c0pHdDBpU1gxVWN5ZzVtQit4SkZmN1EwVjNrcnov?=
 =?utf-8?B?QzhNY1NteEMwSGJESHNYaWtsL1RXN2hJYmxydjBqSnlFMFpxMDBXSEEwbGdk?=
 =?utf-8?B?cHcvdFFGWC9KL1k2bCtXK0F3eHFkZ2pCMjFvRTVzMWZZOVRHTllCN2hSdVNN?=
 =?utf-8?B?VUZROGtzZy9qMDNUOU9PKzBsNHZmSWlVYWE5cGUrUzFkdkRnemJyWDlIbE9Y?=
 =?utf-8?B?Z216ZXBrYmVsTzBobE9LY1dYajZ4MFd1R0dsQ0dQVHh2cWZiZkRqdWl6TExi?=
 =?utf-8?Q?+yN/Y4YlGT1RoP5s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69C6AE0F372A6A4EA1CB7DD3A805E515@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: vqmr79tWS0MEJA49SrP4hWGONB7+q7DnplvmfZXt/lEOMUUhjnhE17Bn/IVyxc3CVsMvelRO+TASJAgtPe8g6bkWEHf3Likwb0Rh/PWaKSDGBZVnyluQtGySzLO2ZDzDyswM1wrSQl1UqylQGI4ScQTx0Utj5JciAV1liHMB7rpHz2O1xEKwBg50/7fdjRQdpm6l9E9O7YvrIehrZzrYFOZtHPQdEokf78JKXp1iSycSB6nE1VrwQy8ADeiw6CkseYAlaDr/HisPXIbHY6L5cbkgG9qlGZMo6etmrdXgCDCyAqf42PHwmGvddwK7HU2rAVY5psBGVJ0AtIPHo4qmZw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da26ada-0fc0-43ee-2cba-08de7504bead
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 07:00:37.1944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E27mS9SCewYWNyRXGOzhjXcm7W6k/jLqm+nDyj3L52nNImXJDGBAlJ/5Nu+3ZKm0dh7Dpx+IwAJGaEUlh2x7rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7983
X-MTK: N

T24gV2VkLCAyMDI2LTAyLTI1IGF0IDE0OjE4ICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gPiBEZXBlbmRzIG9uIHlvdXIgdmlldyBvZiB3aGF0J3MgdXNlZnVsIGlu
Zm9ybWF0aW9uIGZvciB0aGUgdXNlci4NCj4gPiANCj4gPiBJIGNhbiBjaGFuZ2UgYm90aCBvZiB0
aGVzZSBiYWNrIHRvIF9pbmZvIGlmIEkgaGF2ZSB0byBzZW5kIG91dCBhDQo+ID4gbmV4dA0KPiA+
IHJldmlzaW9uLCBqdXN0IHRvIGdldCB0aGlzIHRocm91Z2ggdGhvdWdoLg0KPiA+IA0KPiANCj4g
RGVmaW5pdGVseSBkb24ndCBjaGFuZ2UgdGhhdCBiYWNrIHRvIGRldl9pbmZvKCkgYXMgdGhpcyBp
cyBkZWJ1Z2dpbmcNCj4gaW5mb3JtYXRpb24NCj4gdGhhdCBzcGFtcyB0aGUga2VybmVsIGxvZyBm
b3Igbm8gcmVhc29uLg0KPiANCj4gVGhpcyBoYXMgdG8gYmUgZGV2X2RiZygpLg0KPiANCj4gUmVn
YXJkcywNCj4gQW5nZWxvDQo+IA0KPiA+IA0KDQpIaSBBbmdlbG9HaW9hY2NoaW5vLCBOaWNvbGFz
LA0KDQpBdCBsZWFzdCwgImRldmljZSByZXNldCBkb25lIiBpcyBpbXBvcnRhbnQgaW5mb3JtYXRp
b24gdGhhdA0KdXNlcnMgd291bGQgY2FyZSBhYm91dCwgYW5kIGl0IHNob3VsZCBub3Qgc3BhbSB0
aGUga2VybmVsIGxvZy4NCllvdSB3b3VsZG4ndCBleHBlY3QgZGV2aWNlIHJlc2V0cyB0byBvY2N1
ciByZXBlYXRlZGx5LCB3b3VsZCB5b3U/DQoNClRoYW5rcw0KUGV0ZXINCg0K
