Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF10246BA8;
	Wed,  8 Oct 2025 06:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759903723; cv=fail; b=IzV0l3fMZVPY/FKRJdfS9I9SkuZMM3lLNAC6a3MiQ4Mwr7L28Avkqx9Ey4E1JUt8zBEp1iq1t/sqdzmr7Q+pkUqWCHgT6QzqMSDCXAwbrseJk7Aezw/fDo/LrE1zTtNhX3rpL/fqtLAVnK6XeYwVcB8HTKTQeeeHz2X33ulesnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759903723; c=relaxed/simple;
	bh=1OdT0774rjxg469+Nj4ZrSNeuI/ox9THX/XPOjITv20=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mje+hZHfxHa3i+0AJWFBd1fkNNwerGWyzUnAotZRx2G54vAEya1fhyxDSRqgZjpyOcj+YYZSA8iGpIIlYb4UDgZCN2YvQUbof4+Mt9Zk0pjslzxtnlnFnsEn/Mv5LtTT9JbzBKstdPzM/TFS5BUkzAkb1r3LDYdCY/qT1lZl6tI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=e1+TsHYR; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZrHlX3f0; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="e1+TsHYR";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZrHlX3f0"
X-UUID: 36ccb83ca40d11f08d9e1119e76e3a28-20251008
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=1OdT0774rjxg469+Nj4ZrSNeuI/ox9THX/XPOjITv20=;
	b=e1+TsHYR4VBSyGfHQtXV/UqdkrmNwOFEhw9l1raw+Pccgt6tWc2bPsfgg/8DMyfKCmMrZxww4aypAGdDiL+ZD3J5Oc74JyXbaEQF7voMeWBkN6dsJqC+DIjVfBViC6ixMem8FS4XdnqC1ZIbN8nHhXsYedUy3o/NR8rmRiVzOXY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:fff8bfe7-758e-4fa4-9496-968195be9aee,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:f87b4e0d-cc8a-4e53-aa28-1b6b12a69d6c,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 36ccb83ca40d11f08d9e1119e76e3a28-20251008
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 795604043; Wed, 08 Oct 2025 14:08:30 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 8 Oct 2025 14:08:29 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 8 Oct 2025 14:08:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AB71gzE+tDGfHjm3BGMRxTQ6Gd66JAu+8xAWPrevXMgIi6ZmLuJVDVk3yV+JQ/2rCNExA1ptg7nvfR4pbyg7jHoO/XGUuSXFXsi+aw5LUIxRJILrcxPfCzCGHayxV1/0fT+WYc34+PkwqNVND/oewAY23zPWNy+LzHgPwt+lKBebHj8ZTERknR+9uFJDP7o8qnyFJqW94YmGHJUySJ8g6e1/Dkjlvdba2UDGop+p8qVgfzQTzPuPUcdr2P84/KYgKk15+dPvCP7l43BqXCgGgeIRzohZFrex+9Ykxhvu3UnMKfOtT0nFZ2/KxSys+S0OeyYiNUtl/HeSCTN/+EegHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OdT0774rjxg469+Nj4ZrSNeuI/ox9THX/XPOjITv20=;
 b=l2mp9fcjguIDw3mYRNnRgQarOrQMPmTqHuGqHG600fW/XuNB1+Id8Pi+Hg0q0ADTCDzfpEegpukvi8TVBDnZfrDIVhPz3/J8m8UI+3wCB3sC3eVHBKPS4UlEAia7NyIvmoCrILR5mL2t56WYabnmiAx3Bd6MvkD0eYus1rdMMnZWvxKsr/5yfgeOr9QdyV03K5+khSnAxnITLeFrSU85aAt62meb55dt9L4xullg4VdbJ/pMaftiT4W6lxF3ILt9Om4Y6iEYV0yIvGjdVSRgBBnYN8kKt9EYVk9f/3xoUb1waZiT12ApFjuDlXWYoh3sed3uINlSOf4BkbBCqukC7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OdT0774rjxg469+Nj4ZrSNeuI/ox9THX/XPOjITv20=;
 b=ZrHlX3f03zT4p5DlNWkdepJoweG3p9JSvPWzNVdBjJ+GO50aOE00M5xVKUK9SEXuus3J37MLzq0hYM+ZZo0ys0WDLQ1mz3QIMThgUb1x1WhXnYE2f8wH235+2vd2Zd8NFiuY3KXJiFeOjeqveShuWi7u1jOjGzWMYM0ULIAo/W8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6617.apcprd03.prod.outlook.com (2603:1096:101:78::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 06:08:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Wed, 8 Oct 2025
 06:08:21 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Topic: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Index: AQHcMxYfazcJy3COe0ibj/0v49XMcbSufr+AgAC4nACAAIkrAIABMksAgAVYKoCAAJs6AIAA54IA
Date: Wed, 8 Oct 2025 06:08:20 +0000
Message-ID: <1a29e4dd7fd6f6df5b533c612d8349c4f6187821.camel@mediatek.com>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
	 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
	 <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
	 <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
	 <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
	 <234a5185-d7f3-fe81-9c02-7895691c1fbd@quicinc.com>
	 <85bce5dc28293f48e32b64eed5591d66c54c9e69.camel@mediatek.com>
	 <2ce08f9f-af8c-4cac-8d66-97517eb18037@acm.org>
In-Reply-To: <2ce08f9f-af8c-4cac-8d66-97517eb18037@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6617:EE_
x-ms-office365-filtering-correlation-id: e3178ad2-babd-418f-6d68-08de06311517
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Z2VXc2JHN3Jvd2YxUG5FT01oTGtVeWZwd2lHdXlpY01rSjdVTFlReUpMU2lL?=
 =?utf-8?B?d0tHZVBDb1NBK2Yvc1FzUkdrdHpEd2pXTFlXaUpyQUNIVnM5WjlaTWtXMFpa?=
 =?utf-8?B?N0lNMjBZSzhuVlVVRWMwNG9YbUIwakdnU2xhaVB1cG5VMC9BNzQ2c2xjbDRV?=
 =?utf-8?B?MzdSaXd2cUM0Y2tiTStKUzNqQythY0FyRVEzbWVOS3NIR3dodXJIdkZlRUhr?=
 =?utf-8?B?VTNpWWxBUVgyclN0a2J3bE5KL1dRUFowcytEa2xaMnBhRExFaStRNHYwN2ZC?=
 =?utf-8?B?M1M0WWo1enZHWGRmQUlLeHk5WmlLNGRpSVRYdjJVenk5UDZvYnVGdC9Oa09C?=
 =?utf-8?B?U1Y5UUMxY20ybGx0OERKYXducTh1VCtyaGFmc3dRUm9VOTBFamllM3V2aWFq?=
 =?utf-8?B?TnY4Njd3LzM4ZU52cjZ2b2lzVnlqZ1VwdzA4a2VRMWRaTlBxUnhDSzlSNTVH?=
 =?utf-8?B?d09lUmRmZDVYRmg0QU1nUDFIdUVZM2RZQ1RadFlTeitGRmJvMlk1ZVNCcVhH?=
 =?utf-8?B?Vk1OOTk3ZEY1eWFpSUs5eUl3V3U0TUdEWDdFREhMazRSZXV4cWpiVTBYRFpD?=
 =?utf-8?B?M3paK0F6akU4dnBPYTRCeFhJdFBrYzEzbnEwdDFoY0ZoKzdob0xNYTdhc2t2?=
 =?utf-8?B?bExqa0dKNU5IK3d3ekNWaXUrVXF0c2F4dHRvMG81TTdObkI2RjFobVJKL1NU?=
 =?utf-8?B?N0dYL2tjeWJqTWNxejBWaHJhWmRQN2h3bmpmWDhIV01UeW5LclV6eVgzbzBF?=
 =?utf-8?B?bXhRQ2Vic0pqN1pZcFRXZ3BnaTJrdUpMS05xWjkybnh0TDUyV2FmS2k5VzFl?=
 =?utf-8?B?b0JKdkVzZlYrNTlIT2xIQVpEMnJjZm1BRTZ1bzUzUWN5dkcxYmh5M3c0bUZS?=
 =?utf-8?B?TGNOTU50b0hENnFyYTlNV3pVWDdRWjZEa0MzckFmclB2OVprSlA2V29EWEFp?=
 =?utf-8?B?RmNCblZPSFlyQ2EwNHF2WnVjQjdkNWJLMUhLb2k1VzFKdkpudHRzbU4xdzgx?=
 =?utf-8?B?MlhRZlp3cDA1UGtVL290SnhkNU5sbk94OUNna3NLSG9tZGFYeDZIaG0zenVB?=
 =?utf-8?B?MlZLbWNzRkI0a3FFQWhRT2VtbmNuc1RSUFJkRnNQQmZ3RmtvK0p1TG0yVXlL?=
 =?utf-8?B?ajRTbTdCdTBVNGRtSDhHVVdsbXNselFtYVpIK3lUdXpqaURWeG1malQ4NUc1?=
 =?utf-8?B?VXh3Sk9lYklwVVNvclM3cEd1T0dEanNvcjM0ME9LWUZnT1psTk81WnVET2tQ?=
 =?utf-8?B?S2NSTGZSWFZzUXpRSjFtSHN4eXk3S3ErSkZNQ0drQmRlbTFHUEFpdThQdGZ1?=
 =?utf-8?B?MjFPRGpNbkh3TmFYRFNwVEZnNFlFakZPZ3Z3MHlSaXc2Y3V3ZHVCNkJyZ3F1?=
 =?utf-8?B?MlUyRGdIMUhJVEdHbWJMRU94b3hTQWxnRjFVbGk3bDRXZ3NYUDJoNVFTYmo4?=
 =?utf-8?B?Y2hMc2xSS2ZpdmRndnRXb0hoaUIwZGpZWTQvZlE1YVRTLzRBeWd1TFIyYThx?=
 =?utf-8?B?YnRKalRjZVlhWDZZODluRGpZYXMrYUFXS1J0WStkSjFMRCs5ZklZejBjOG9W?=
 =?utf-8?B?Q3VNQUlnRUJzMzVYUmMreXgxTE1JTEcvdVF2aDdJT1ZiZ0hnNENWenhpc1d6?=
 =?utf-8?B?VVJoU2VPbGdsMURSaGdXQkRqdUVUNWVtdmc4bnpzaCt0OUxwNHlKNHpqSFI3?=
 =?utf-8?B?SW1heHJ3QUdnZFBSb0k3eGVSZENnU1FuWWowY3UrRDhGLzVBU0ZuMHh1eDdr?=
 =?utf-8?B?SlJCTERSN0R6ZDJHdG5FOGlBVVJySDFxTUtsQ0x5b1pJUE5wbXUxSi9pQjVp?=
 =?utf-8?B?SkJlVWJhT2Eyb1hYZWxPbnNPOXQzamhtTXJoTlE4d3laMkw4U2NLUjJDWDk3?=
 =?utf-8?B?cEsxMWVjTmhZSXhabnhKQ28xUzdSTm5hZXlzUTV6b3MvYzBtL05DNEpSc25x?=
 =?utf-8?B?ZGk1Q0VnQVZqNTNnY1Jwa3VMMHhtUStXdWNPd3RRQTFkOHdDblN3ZDEyd1FE?=
 =?utf-8?B?cFdrUTNUUnZGNDZMT2VNMTUrY1Z6U2dJQkVRZ2cxd3F5WTFUbjN0bDZpWCtH?=
 =?utf-8?Q?Nh4M31?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1kxUHpBRG56N1B5YlAwR2FJeHNETDlySldXaWtmM0IvdUE3ekJkNVY5Nitl?=
 =?utf-8?B?SVR2QUlPWHFXRkIxc2xNZVM1NmRUS1FFNHJOb1FQbExxNldqeFdoMWtrTHRj?=
 =?utf-8?B?Vzd5R0lrcTB3WUtvbE91UTVOMmd5YnlSMXo5d1VFaUc4VW5md2ZnOEcvZG9a?=
 =?utf-8?B?YXJ4YmJzeHBVL1VnQXhqS2paSDRadks1bEM0UXJ0L1FjeFZaZWJzVFdMVlIr?=
 =?utf-8?B?RVRjb3lNT2M3cENOS1NSQWNrNFB5UVo1Sm9OUmF3aExMMnJvM1ZVbHczQUM4?=
 =?utf-8?B?M1l3UGtqajEvTjRnRVY5WjNPRVU4MEFmNHB4NnhDTDM4Nm5SOG5XUDBITWpy?=
 =?utf-8?B?OFNpZHdRTVAyelF0OEpNZUVteVJ4bDlhZVZVbzF6UWF4V3BFV2FIS3FWRXMx?=
 =?utf-8?B?YkhUS3BYY3pHTS9DL2M3UTAwcEZ4eklObXB3UmhHZk85MlBFNlNGbDVwMDMz?=
 =?utf-8?B?OTRHQWRWTTdRei9OZHhQeGkxZStlK0YwU3VvVUQrZmhLYlI4SExKZXloOTBE?=
 =?utf-8?B?Q0ZsU0Y4czZHcUZPaUhnQzkwUHp5bTJzWWh1Nlh0UHhSSXZKR1dZUlJtYm15?=
 =?utf-8?B?SHduY2RkWC9kTURuei9sN3Y1WUdZSlpNK05sL0pSYk5CTmRaTmpnT1FwaTBM?=
 =?utf-8?B?WEZ3ZDk4NHFBUisvckhRZFFWdzU5YnRKUFBYUjNLM2dvQ1gzMkJYL1pYWUxH?=
 =?utf-8?B?OCsvZlhkV3d0aExpQzF6S0xvVlJzNWlxazIxSjdmZWFLU1VYcWZOZWRMd2lD?=
 =?utf-8?B?dDg4OFVrTGRYb2d6TUlPeXZ5ZDJXbGlIVDJQcUgwUnkveGFBbGlBb2QxTWls?=
 =?utf-8?B?cy9sd1E3YW9YRUkyRnNKMStLeHV0YmlUL0JDZ3N2ZWhXNStFaXdBbXhYQVJ1?=
 =?utf-8?B?Z3A0eEJOT1Z1YUdrR3FTNXFmbG9KNnZueWUyVGlVb1Y2d203bUNDUlIwTFJm?=
 =?utf-8?B?R0RqczBoQmdXZWt0MGRPU2FvM1h0SFNTUW8ycWF6YmtEZUhReTNDQnhJY290?=
 =?utf-8?B?MGtjVTZ0MnhHT2lraXQwMGpmQm44NkpmNFpQZHU0Wjk5alp4NUlOSklyYVgv?=
 =?utf-8?B?TE9HREo1cXlEcllYOFJmNjcvdEROWmdXT0tUMTRCUlpQcXpjc3pqdDU0a2x0?=
 =?utf-8?B?N2JUVm0wMWw1M3hXN3MzM3RkU2dUdzAzNXJvOWxDZ3VUc2dGNitVV214Qm9m?=
 =?utf-8?B?NDh1b3pwOUpLWkNBNjRIQnpuS05oOWMvTS81aUVBY3VlY3NmRTlxdWJzU3l1?=
 =?utf-8?B?eVl3R3FlcXNLenRlZzN0Q3RicFYvWlJ3U1ZlNzBLU21ZYk9MTVNTRUxkVTI4?=
 =?utf-8?B?ck9MelMxUEZzazgrMHBHaFFRVzhBWE5qUzNnUDRnWFoxWHo3cFc5SExsdGlY?=
 =?utf-8?B?dkpUb2VHcnNxOE1lWVJZKzZBeE1hNW96cHNjQlQvOU9aV1F3ckF5bU1WaEZl?=
 =?utf-8?B?elVCRlE1cWszL2UralBjQ2FXa0VadUNnNFJiY1NsZkdkc3VhbzV1dDR6ZFBi?=
 =?utf-8?B?L3AwZXFycjd5NUlrRVRSN0JVa0lob2xUREpHeFltZ01wYTREMXE0c0R1WXYz?=
 =?utf-8?B?N3FpTW96eDc1bXVwbzNKbVV2NjZsYng1MWVNSHp3aEtHTEVUdFdBWFZTdGZG?=
 =?utf-8?B?OVpIUHZmN1hVeVdwRmhmVFNRRmx1eFB4MkFJeFkvcFp0N0ppSlRNbFNpdHVl?=
 =?utf-8?B?ZmVDSFkrelYwaUgwNmM3dHBVdGNhMjJ6RSs0THgvQ2hna1pvTDRNZzd2YXVS?=
 =?utf-8?B?d2c5amwwTzJoSWgxaE1BY0JPbkpIWnhGYmRNY2NLWnNpVlB0Tmk4b3ovQmV4?=
 =?utf-8?B?cGJncmwwNzRjU3lBeXFuZDMrN1lDNk5tZnBTcjIyRTFqVE1MNkpjR1RSNGxS?=
 =?utf-8?B?NVh4MUdhVEgyWE5yNTAyOWdNc3dwNnA3RDBSZWlFWHFPb05Tb3ZuOFdZb3dX?=
 =?utf-8?B?eXdGL3VuSTExYU94bVVYZWJtMUZ0M24vVDhGUVErZzdHZFVQODY1b2VMZDJo?=
 =?utf-8?B?cFZlcWRmampFQXVmeU94am4yNEU0Q0pZWTlDQ1ZYS0tQVWJ0Ujc4TDZIY3hZ?=
 =?utf-8?B?bWlqb0xkQTZTQ2ZRV0hDYlI0SG10cFZEUmtVUmdyL3dXL2dtbzg3N1hvQ2ZO?=
 =?utf-8?B?VDNxWlQvM21zWjM0VHo5OG1vcFo5cjNJUHlwOThOR1FxVVJJcU1CSSs1Qlpm?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8357152EF46886419EC277CCCD9DAFD1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3178ad2-babd-418f-6d68-08de06311517
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 06:08:20.9589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4i3W2hosrILjbKgW5wZYJHy8h/w8z10FM0XFduDN7cCsoN9m5IhOhHW30t5USvoyzHWLRRHZsMQQz4j/kjs1dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6617

T24gVHVlLCAyMDI1LTEwLTA3IGF0IDA5OjE5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFdoeSBhIGtlcm5lbCBtb2R1bGUgcGFyYW1ldGVyPyBXaHkgY2FuJ3QgdGhlIGRlZmF1bHQg
ZGVsYXkgYmUgc2V0IGJ5DQo+IHVmc2hjZF92YXJpYW50X29wcy5pbml0KCk/DQo+IA0KPiBUaGFu
a3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpZZXMsIHRoYXQgaXMgYW5vdGhlciBtZXRo
b2QuIFRoZSBtYWluIHBvaW50IGlzIHRoYXQgd2Ugc2hvdWxkDQpoYXZlIHRoZSBmbGV4aWJpbGl0
eSB0byBleHRlbmQgdGhlIGRlbGF5IHRpbWUgaWYgd2UgZmluZCB0aGF0DQoybXMgaXMgbm90IHN1
ZmZpY2llbnQgZm9yIHNvbWUgZGV2aWNlcy4NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
