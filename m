Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EF53A1E60;
	Wed, 24 Dec 2025 06:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766557008; cv=fail; b=sGD0nxtdcmje8Q8qxKDb58pbzgTmENQbX1V/5dF+ihBfYVzkG2izZ9Ynodu0UuKhXrJK9AQpBMThneHqVAHBux7DWH2L6bTIxXz1JwfbFKCtuihv7spWZoy3eMzeyfwbs8qdeF9FYWm1XjjQElpmMiSLtAtvEMrPzrl6ARwOAc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766557008; c=relaxed/simple;
	bh=Aq/BfPJbGnLe0atDJttZ1vsTlzfzZa+mMRiNqkgPCuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qo+S3ZFpWsxOYjDNI/+bGcMWJpCPAwfi/f0e1akcsA60CnVLgE/X4Olo7LODAeAEo5eRFwbZtKmEr5FN0lOp9Xai2Q0Gy6WffxXa4KBxgKWSEededqPXjGWrivUXsbBWV9l7I5SdWPPrbMHmvBdTtCENRnEXonmk2PlCkk/SU4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=l6mVsEcE; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=HLXjKPAj; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="l6mVsEcE";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="HLXjKPAj"
X-UUID: 1bc434b0e09011f0b33aeb1e7f16c2b6-20251224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Aq/BfPJbGnLe0atDJttZ1vsTlzfzZa+mMRiNqkgPCuQ=;
	b=l6mVsEcEoruu7ZnTl/w+NRxzSWlBHDjM/urXyEQWtsrjQT7ONHSJptPjalw4J7j2Fak82c6m7eEEjHO46Uhre+78Fqo8UMBZRAuKBxb/o3XBqATj1EN4y2NhKAdAqoJfBbhHv02KqGUJOYik7W9JUzsoxvFvhT3s/7QM5Wrl5PU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:299fac5c-d49d-46d0-b6d4-10eebba19368,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:a78c1d03-1fa9-44eb-b231-4afc61466396,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1bc434b0e09011f0b33aeb1e7f16c2b6-20251224
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 471306993; Wed, 24 Dec 2025 14:16:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 24 Dec 2025 14:16:37 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 24 Dec 2025 14:16:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SKyF6oxgS7K2ZcmDFZ+B1sStvm8TUgGAZRafVvpaR4rdwB2Ze0m73C55YiSuq7DuZfDiMvsCptEtOEQvlQUSs3PVwTUnIYHG67R/Xw5cc5UBywwsHU5E2jm6Q5dn17+KEgAYm5dDDEoDytmaVzmJYFnsy1z6OyKA/0Z+npPBXbbzgZIvn/uge3PW1jZXuLwunzK51Rf7KxPY1xwgfDbQYpctZbEVW3gnvmu6cctgkaG+n4wQ/nenZwQ6wSMU8poVIJEWIWfIsK2UYfw4DLgfXJxIBbcClE5wfXM/4jJ/d2DnxR6oWCq1v2UK+JLRwb7UCAkKL+MGSsc5MQXoUcrtkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aq/BfPJbGnLe0atDJttZ1vsTlzfzZa+mMRiNqkgPCuQ=;
 b=r8pqFK3VnSH/f5887LItCbyGWizQGLDQ0tbPsXqmWEUrASN/5sp4IXVSI9q4lt/O2KXaiGBjElfSSB2IyGDiRTb2VoLAmEx2WCgPpwbbXtbNb10iR8yGmNezHa2jPo7361uxQAWcT++DYGI/Wj3DfUAi2LnH6nN7zKhy+l1NR3iEo8MsDtYpigBtk4JY0d+RKgYuf5/VbTLS0nmEGtgHMea5q+TXrM/cnMk9owDzbGG54wtH5mxPRUEbrDkmFQQOxWDqJ4ZX2z6rhuMx3NxpdoUpDHBg5FK2Eq17WHBrf1TJstTdR8aIfuLme+gwf8AQhP7kxn+kzUCLgJ1ZdIzZWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq/BfPJbGnLe0atDJttZ1vsTlzfzZa+mMRiNqkgPCuQ=;
 b=HLXjKPAjCKQgJCf+jLT/wZXDJTEJimCM4AexVb1m/zVx8ELyxqztnrdwkrjlhzgyjFroYPJ1BdG02aOnyEwQD6BrbQ58tWjrQgIgEcUbgQ5p5qVXY3/TZC18uz5VzZRe2rT7GKMOcA6jfYt9lwtnCW2k2qUnscPE3PCUxl9NtBg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE2PPF5449A096D.apcprd03.prod.outlook.com (2603:1096:108:1::499) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 06:16:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9434.009; Wed, 24 Dec 2025
 06:16:35 +0000
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
Subject: Re: [PATCH v4 09/25] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
Thread-Topic: [PATCH v4 09/25] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
Thread-Index: AQHccB3w0gH2KcfnIkajzkZXBJIOR7UwWXgA
Date: Wed, 24 Dec 2025 06:16:34 +0000
Message-ID: <a12f7ffe8448d205a7318219ea7a18f0f722727f.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-9-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-9-ddec7a369dd2@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE2PPF5449A096D:EE_
x-ms-office365-filtering-correlation-id: 0909e051-c4e6-4c73-9872-08de42b3fd59
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?b3JTL1dkV3RlVC9UWEo0cnJUSnA0Y2VrVXdwWVZZcHJLUHpRUzFvekg3UFVE?=
 =?utf-8?B?MFhzekNRQVMzNXlNaXBpbVZUWXVCVHpTcmVENTBweHh3MmwvdDdpYy9xQ3I5?=
 =?utf-8?B?TzF0WnJFS2ZqUS9hRU5jWk1vWG5YdnpQYlB2OTBISnRmMEVJMDEvZGxtYkF3?=
 =?utf-8?B?d0xVMkxrRnJLUERIUExHbjVoUDAzM3hiOHN0bTFKbmlCYWxESVhsOWE1T3Yz?=
 =?utf-8?B?NS9XK3Q2VWtQek92L1M4V1dmcEtQOEtuVDc5TllXSk1ORDJZakhWdUx2Um9B?=
 =?utf-8?B?R1g2SXJKS092a2pOd3pOUGRaTUdsZWY2ZCtxRVR5MGJ5R2VjRktNK3ptMkNa?=
 =?utf-8?B?NWxxSmJWRVd0dWlDRnFUbnZTeHFMZHA2N3dvYWNMUmdPWGdsSzBYMnZEQjFH?=
 =?utf-8?B?UGVOZDBBU2Jid0RUWFVMckg4bUMxTkl5dENpQ2I4ODVESlBkc0JKNEY4U1p1?=
 =?utf-8?B?UC9YaEIvc2ZEYWJ1ZEEyM2hNZTBKMndKTHZXZnhMTVA2Y29kYnAwYVA4NTl2?=
 =?utf-8?B?dllUMHBDekZoSGlGRCtRaUJEdXJLai94eXFuUTdtLzlWQjZtU21vakw2VkYr?=
 =?utf-8?B?VTBuWkJONTVydFR4NzNxNUxBa2JocVhIMXBZcWlQZFZOa2xTWXV2YS8vMnB5?=
 =?utf-8?B?enJtQlVzbm9IYTZhdXdUeGFROWRHR3VFbElJaXkyN2ZyQndWT0YzRTNJa1dK?=
 =?utf-8?B?YS9kMTUxNkFVSzBvOE9BczNUL3dqekdLTTZoWnBBU2M1SGxOU3RkQ3lzWUNX?=
 =?utf-8?B?N3lBT2FiSlVLbGlZcnBYcG9XYnFvTDg5T1ZLM3JSRGpWc3JPZitvMWdZUE5r?=
 =?utf-8?B?ZTR5WmpWWDRrOEgvbTF1alNNN2tnOWY2VThZNTA0R2Z0MU1CRHQ1MEdFT0Z3?=
 =?utf-8?B?eXl3aDkvaUJ5ODRic3dKRi85cVR4SXVvSGV1STV3dTdPa0JCVXMrOXEwY0Qz?=
 =?utf-8?B?aDJwVHpxYjhCMmhKcUNOdFdtL1d3L3FrSnAwMHRZdWdmRlE1bjFtZzllUS95?=
 =?utf-8?B?OUIwVXY1MDhRVHljYThBRXl6YmxZNVl5dG5FZitTUjNSZ2VlTzRnMFg4TU9J?=
 =?utf-8?B?dHNPUHlVT2FDUEg0VC9Zdk9QL2diTE0xTTZieitBaEt4c3ppdDhwNkpvcnNO?=
 =?utf-8?B?cGM1a1luTVhJcjZ5K1VIQXNtSXFsaXdBbE4wLzFPUkY1K0J3OWNONS9Bd2h6?=
 =?utf-8?B?NW5RZGhVZThkZEdBRUlZd0h1SzE4SWtqSDZnZTkrMXBSbEdCeUg5R3p3OUI4?=
 =?utf-8?B?clJaR2JScUZRbWdmenlYc0FWNnJaMktoY2g0TjNWZTJEaU9iM1NQc1diWW9X?=
 =?utf-8?B?Wm5CczRoR1BUaGF1MDEwU2JSNWxLTncyMmgzQStJaWFpaWpvTndwelBjbVFM?=
 =?utf-8?B?bTVVTStDNEQ0Q2xqSG9TKzBZRHRPK1RLcTlRckF5RnYxTXB4dERtdFU2MVJR?=
 =?utf-8?B?WnlCeVNlSkd6L1NCQWY2S3l0RGh3RzB4dng5QVVIanFxQnIyWERsMkJIQWxI?=
 =?utf-8?B?T0p5RnRrUC80N2ZnUnhseURJQmR4UWhuMEMyWnBxVHJ1cXBFSzZDeXNtQjJP?=
 =?utf-8?B?UWN6bElabEoyZU9NQjNOU2t3RUNYLzA2NU1tU1hTSWorQVB0N293NmRZa0hV?=
 =?utf-8?B?ODE3Y3VHKzFNK2lHUlRpM0g3S2czc2RjRXNZZjdGdm1SMjduRDdGQnAxbUNm?=
 =?utf-8?B?OW1JUmZKU0pQaU9odVJKWHhiL0x3SHNCRzZDd0xhdjh4R2crckVwSHdad1Ns?=
 =?utf-8?B?VzdZd3daUytWNnBBLzN1d01NSnlUMWNBeHIwaTZZUWxEUHdZWHJ6MUR0SzdX?=
 =?utf-8?B?dCtLcEl3Vk9qa1EzOSt0V25CSlkvYVhuUDdwd2lzWGlVNzUyWGoxK3pqM0xF?=
 =?utf-8?B?WnI2U2VCTksydFBmSHVBS2FPVjhGZjR3clQ2dnNhYVdGYWxUakRFemt1dnlv?=
 =?utf-8?B?NDJCcjZZVXN5dGc4MHd3SHVCbTF6WlBWaEg5ZC9qNGlkSkdLNHV2SFp5Zzg3?=
 =?utf-8?B?eGlIaCtvbHNPSnJqNlcyUFc4dExMbUZuaG5QcVZtRjk3U2NTYkJicEFTRnBV?=
 =?utf-8?Q?SPAbPe?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTBldDg5cHJoYmVTVElFdUp4SVZ3WWpLbkR6ZFJXYzQ3Q0tGekUzL3lRR05I?=
 =?utf-8?B?WjA5YkROSlVCTWM5NUNBcncyRGMvT05Fek1aRlJzM1IvUWJTcEMwMTYwMXBq?=
 =?utf-8?B?WEV3Z001VkJSRlRoRU5oanVUanFSdEZTT1dvOURIV1ZMb0R2b052bkFsNDda?=
 =?utf-8?B?bEJKVmZMSU9ZaFo3K21JYXAxUUZhSFRGM2lPRmZhVmdMMW9NUWExMjd1WjBv?=
 =?utf-8?B?NTNuQTJmcWdLb2tuTG82cXN3R3dMbUhEa1g4MW5qL3VZME9wYk4wWldidGFI?=
 =?utf-8?B?di9pdVMyQmRtL09wTkdEMkF0dmJFN0R2UTlGRGhySys3M24yVzc1L1o5RDli?=
 =?utf-8?B?ZEtPQnZsV3kyaUJQUk8xdjNBYUhWWXk1c3lFdlVyS004UWF2UWZVelZTYWRM?=
 =?utf-8?B?MmpvL1FTdDBab0FVeFMwQUNsc2Q1Y21sL2ZOTWNRWW40VVlCOU43RjRoc0Jh?=
 =?utf-8?B?djgwbnRKc2NZejVzQlJFVVYrY1RhdTdXWGlIUnM2aVBvclMzeWsrVTZjUGFC?=
 =?utf-8?B?NVhzeXE1VzJyeUc3N2J3aDh5TWNFczlZQXRGSmNwM0ZjamN1K2VpOUNtL2dY?=
 =?utf-8?B?bW9tenlaamxYZkNkRG9nUlI5UFhaMjNoYkZHVnh5cUVZUXhHMmZ0NENxSnZD?=
 =?utf-8?B?dE1IdEhQSHNUYW1jbUNNYldrSi9UVndVQ0FwanFQbVo0QUdNdm04VkJvYWF1?=
 =?utf-8?B?d1NHNy9lemRHU2ZHSmVZYVR0TE9DUUcxNFN5dnYxZ3NxMkplZXpuS0RWcFR4?=
 =?utf-8?B?TjQzUzZNYnlHR1dSNmlNcTZPekg4M0NPb3JmRzIvMTVvT1NEbkpWYVJ5OWJS?=
 =?utf-8?B?QVcxdXJFT0Z1TCtSM05PYUdmQnhiSW1VS0EvOXNkQS9nWE10c0oyZzFmbDJ5?=
 =?utf-8?B?NHByY3BWejc0dXN0dlJsZkZseFg3SGVobU9oLy9xdEdCQU5IcjVlYkRFSjc4?=
 =?utf-8?B?VXRHUUVTNkNJRWZ4SG56RStzaEtEbVpPWGNHUFFtSzRITXJnZVdSeVEwWGZN?=
 =?utf-8?B?N05oeFgxa2JrVGFxby9ZSHhvMk1ZYktjREJjbzI5UDd4NnAvQ3pqTFRwcW55?=
 =?utf-8?B?OUdTV2twSWRJQ1cwb01reXJISWRLVUE1YSt5bWV2WlR6K2lkS0dmRU5EZ01R?=
 =?utf-8?B?THB1YUpYSjBpMmgzaWdoOG5seU5vanhHWTVCUEg2QXRjNWMweEU4YW4xUWhB?=
 =?utf-8?B?NWw0RmwrbWF5VVNhWTArendPMW5hTlZlMHliamMzQzl3b0ZaQUpKMEc1cTZU?=
 =?utf-8?B?V3IwZmJ1Nk9YWk14Qm1QS2VtNCtTTzJkdkNUVnViQ20wY1pPZ0ZVWGdJcnd4?=
 =?utf-8?B?aHlaM1BXQkRrUnkwTElzWTl2M0V1RTlWUVloeWY5WXQ1bkFPa21RQUI2MTU2?=
 =?utf-8?B?QzVzb0p0bDlqMGpjRGM3VjREcHFTa2M1dVdCa2VvenNsMHR1UmNDUHVTdVkv?=
 =?utf-8?B?MlZPVjBidGFJckQ0bTdJS0hTWEpwYmFSUWptUlNOUzdkb0RMYWNxamRGaDFk?=
 =?utf-8?B?T3FjdVg3U2tDckZnejBDT2lxSlE2OXViSll6Q0o5NXNycUcrc2NZWWY0YWdJ?=
 =?utf-8?B?dmhpSzRhQUFQNUMrNnFrNDB1NTI1aHFSRWRPNWplVWNld3pMcVFycHZONkU2?=
 =?utf-8?B?czhzcCthd1oxZDNEaGRDbWxiZjRNblgyTTEzUGF6L3YzK0JPUVdMdlNnQmwz?=
 =?utf-8?B?YVMxbjZ1c1hQMFZpQnVWdjZDWDZuK0RoalA3ODlmZ3JmaVVWK2pPUXdHM1dU?=
 =?utf-8?B?NkJ5TmpBR0s3a3BEWEE4NkNkeGhmWlJpNnVTbEZCOW05dW5aQ2tsK3V0aE9V?=
 =?utf-8?B?M1lnOVdBa0puZExrUG9uSW9yc056T2I5UDZSOVBrenZOWWYySDhHekVxUXk5?=
 =?utf-8?B?MmF0N0QzeEVJVXFWZkRrNDI5QWhHZFVSWSs4Q1hvdGhXanVTL2JXMVlRR2tz?=
 =?utf-8?B?R2VPZEY1cGR1VW5RUjNyTmxCT2tOT2dGMzNSSU1wOEpRUVUvVzIxY2w1MzhR?=
 =?utf-8?B?bW0xaU9tVXJ1aFlkWFZ5M2xmZEk5a1FHY2FiTEhNclBpOE9yVXJacG9EU3RE?=
 =?utf-8?B?SitVQ1REY2lkdFNVTGI3cDRsZTFhUVczdHZxSjBOZGswblhMeStQa2tqRVRP?=
 =?utf-8?B?dm40TE51YVU1alU2cGdnWVlXU0ozdkVQVGVDZitsM2NPRGhhd2VucFJKRXhz?=
 =?utf-8?B?cEtDWnpJVEZDd3diYVordU0xQXMyQ0lYNXlRa0Nsd0ovZkNvR1V4ZVJVdE9m?=
 =?utf-8?B?dU01MjQ3bEhmVnAwYXhEaGpqdzIrUUoyY2ZHamNTNUpKNHdUa21vS0k4SUpj?=
 =?utf-8?B?YXN1bnlORS84RGVubTNSUjdqUEhhMVJhUHRLamlCT3hob0U2VU9HUE9JTm1o?=
 =?utf-8?Q?Pp+Aqo+F4Cp8eVas=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59809BD9EDB0DF47ACAAF115E28B3B91@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0909e051-c4e6-4c73-9872-08de42b3fd59
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2025 06:16:34.9362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5z/9HZ8HOFJ0KnhCrrrrYerizHQe6qrN2YDYImgHcHBYTvidt22Jd58U+f17ARlOPO0ICGMNZujs7PwCcuq7/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPF5449A096D

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDEzOjU0ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6Cj4gLQo+IC1zdGF0aWMgdm9pZCB1ZnNfbXRrX2luaXRfYm9vc3RfY3J5cHQoc3RydWN0IHVm
c19oYmEgKmhiYSkKPiArc3RhdGljIGludCB1ZnNfbXRrX2luaXRfYm9vc3RfY3J5cHQoc3RydWN0
IHVmc19oYmEgKmhiYSkKPiAKCkhpIE5pY29sYXMsCgpQbGVhc2UgZG8gbm90IGNoYW5nZSB0aGUg
cmV0dXJuIHR5cGUgaWYgeW91IGFyZSBub3QgY2hlY2tpbmcgdGhlIHJldHVybgp2YWx1ZS4KCgo+
IMKgewo+IMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2Rf
Z2V0X3ZhcmlhbnQoaGJhKTsKPiDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgdWZzX210a19jcnlwdF9j
ZmcgKmNmZzsKPiDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZGV2aWNlICpkZXYgPSBoYmEtPmRldjsK
PiAtwqDCoMKgwqDCoMKgIHN0cnVjdCByZWd1bGF0b3IgKnJlZzsKPiAtwqDCoMKgwqDCoMKgIHUz
MiB2b2x0Owo+ICvCoMKgwqDCoMKgwqAgaW50IHJldDsKPiAKPiAtwqDCoMKgwqDCoMKgIGhvc3Qt
PmNyeXB0ID0gZGV2bV9remFsbG9jKGRldiwgc2l6ZW9mKCooaG9zdC0+Y3J5cHQpKSwKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIEdGUF9LRVJORUwpOwo+IC3CoMKgwqDCoMKgwqAgaWYgKCFob3N0LT5jcnlwdCkKPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGRpc2FibGVfY2FwczsKPiArwqDCoMKg
wqDCoMKgIGNmZyA9IGRldm1fa3phbGxvYyhkZXYsIHNpemVvZigqY2ZnKSwgR0ZQX0tFUk5FTCk7
Cj4gK8KgwqDCoMKgwqDCoCBpZiAoIWNmZykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVOT01FTTsKPiAKPiAtwqDCoMKgwqDCoMKgIHJlZyA9IGRldm1fcmVndWxhdG9y
X2dldF9vcHRpb25hbChkZXYsICJkdmZzcmMtdmNvcmUiKTsKPiAtwqDCoMKgwqDCoMKgIGlmIChJ
U19FUlIocmVnKSkgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9pbmZvKGRl
diwgImZhaWxlZCB0byBnZXQgZHZmc3JjLXZjb3JlOiAlbGQiLAo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFBUUl9FUlIocmVnKSk7Cj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBkaXNhYmxlX2NhcHM7Cj4gK8KgwqDCoMKgwqDCoCBj
ZmctPnJlZ192Y29yZSA9IGRldm1fcmVndWxhdG9yX2dldF9vcHRpb25hbChkZXYsICJkdmZzcmMt
Cj4gdmNvcmUiKTsKPiArwqDCoMKgwqDCoMKgIGlmIChJU19FUlIoY2ZnLT5yZWdfdmNvcmUpKSB7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycihkZXYsICJGYWlsZWQgdG8g
Z2V0IGR2ZnNyYy12Y29yZTogJXBlIiwgY2ZnLQo+ID5yZWdfdmNvcmUpOwo+IAoKU2hvdWxkIGZy
ZWUgdGhlIGNmZyBtZW1vcnk/Cgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biBQVFJfRVJSKGNmZy0+cmVnX3Zjb3JlKTsKPiDCoMKgwqDCoMKgwqDCoCB9Cj4gCj4gLcKgwqDC
oMKgwqDCoCBpZiAob2ZfcHJvcGVydHlfcmVhZF91MzIoZGV2LT5vZl9ub2RlLCAiYm9vc3QtY3J5
cHQtdmNvcmUtCj4gbWluIiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJnZvbHQpKSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZGV2X2luZm8oZGV2LCAiZmFpbGVkIHRvIGdldCBib29zdC1jcnlwdC12Y29y
ZS1taW4iKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGRpc2FibGVfY2Fw
czsKPiArwqDCoMKgwqDCoMKgIHJldCA9IG9mX3Byb3BlcnR5X3JlYWRfdTMyKGRldi0+b2Zfbm9k
ZSwgIm1lZGlhdGVrLGJvb3N0LQo+IGNyeXB0LXZjb3JlLW1pbiIsCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmY2Zn
LT52Y29yZV92b2x0KTsKPiArwqDCoMKgwqDCoMKgIGlmIChyZXQpIHsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBkZXZfZXJyKGRldiwgIkZhaWxlZCB0byBnZXQgbWVkaWF0ZWssYm9v
c3QtY3J5cHQtCj4gdmNvcmUtbWluOiAlcGVcbiIsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIEVSUl9QVFIocmV0KSk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIHJldDsKPiDCoMKgwqDCoMKgwqDCoCB9Cj4gCj4gLcKgwqDCoMKg
wqDCoCBjZmcgPSBob3N0LT5jcnlwdDsKPiAtwqDCoMKgwqDCoMKgIGlmICh1ZnNfbXRrX2luaXRf
aG9zdF9jbGsoaGJhLCAiY3J5cHRfbXV4IiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmY2ZnLT5jbGtfY3J5cHRfbXV4
KSkKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGRpc2FibGVfY2FwczsKPiAr
wqDCoMKgwqDCoMKgIGNmZy0+Y2xrX2NyeXB0X211eCA9IGRldm1fY2xrX2dldChkZXYsICJjcnlw
dF9tdXgiKTsKPiArwqDCoMKgwqDCoMKgIGlmIChJU19FUlIoY2ZnLT5jbGtfY3J5cHRfbXV4KSkg
ewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9lcnIoZGV2LCAiRmFpbGVkIHRv
IGdldCBjbG9jayBjcnlwdF9tdXg6ICVwZVxuIiwKPiBjZmctPmNsa19jcnlwdF9tdXgpOwo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBQVFJfRVJSKGNmZy0+Y2xrX2NyeXB0
X211eCk7Cj4gK8KgwqDCoMKgwqDCoCB9Cj4gCj4gLcKgwqDCoMKgwqDCoCBpZiAodWZzX210a19p
bml0X2hvc3RfY2xrKGhiYSwgImNyeXB0X2xwIiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmY2ZnLT5jbGtfY3J5cHRf
bHApKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gZGlzYWJsZV9jYXBzOwo+
ICvCoMKgwqDCoMKgwqAgY2ZnLT5jbGtfY3J5cHRfbHAgPSBkZXZtX2Nsa19nZXQoZGV2LCAiY3J5
cHRfbHAiKTsKPiArwqDCoMKgwqDCoMKgIGlmIChJU19FUlIoY2ZnLT5jbGtfY3J5cHRfbHApKSB7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycihkZXYsICJGYWlsZWQgdG8g
Z2V0IGNsb2NrIGNyeXB0X2xwOiAlcGVcbiIsCj4gY2ZnLT5jbGtfY3J5cHRfbHApOwo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBQVFJfRVJSKGNmZy0+Y2xrX2NyeXB0X2xw
KTsKPiArwqDCoMKgwqDCoMKgIH0KPiAKPiAtwqDCoMKgwqDCoMKgIGlmICh1ZnNfbXRrX2luaXRf
aG9zdF9jbGsoaGJhLCAiY3J5cHRfcGVyZiIsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmNmZy0+Y2xrX2NyeXB0X3Bl
cmYpKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gZGlzYWJsZV9jYXBzOwo+
ICvCoMKgwqDCoMKgwqAgY2ZnLT5jbGtfY3J5cHRfcGVyZiA9IGRldm1fY2xrX2dldChkZXYsICJj
cnlwdF9wZXJmIik7Cj4gK8KgwqDCoMKgwqDCoCBpZiAoSVNfRVJSKGNmZy0+Y2xrX2NyeXB0X3Bl
cmYpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycihkZXYsICJGYWls
ZWQgdG8gZ2V0IGNsb2NrIGNyeXB0X3BlcmY6ICVwZVxuIiwKPiBjZmctPmNsa19jcnlwdF9wZXJm
KTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gUFRSX0VSUihjZmctPmNs
a19jcnlwdF9wZXJmKTsKPiArwqDCoMKgwqDCoMKgIH0KPiAKPiAtwqDCoMKgwqDCoMKgIGNmZy0+
cmVnX3Zjb3JlID0gcmVnOwo+IC3CoMKgwqDCoMKgwqAgY2ZnLT52Y29yZV92b2x0ID0gdm9sdDsK
PiArwqDCoMKgwqDCoMKgIGhvc3QtPmNyeXB0ID0gY2ZnOwo+IMKgwqDCoMKgwqDCoMKgIGhvc3Qt
PmNhcHMgfD0gVUZTX01US19DQVBfQk9PU1RfQ1JZUFRfRU5HSU5FOwo+IAo+IC1kaXNhYmxlX2Nh
cHM6Cj4gLcKgwqDCoMKgwqDCoCByZXR1cm47Cj4gK8KgwqDCoMKgwqDCoCByZXR1cm4gMDsKPiDC
oH0KPiAKPiDCoHN0YXRpYyB2b2lkIHVmc19tdGtfaW5pdF9ob3N0X2NhcHMoc3RydWN0IHVmc19o
YmEgKmhiYSkKPiAKPiAtLQo+IDIuNTIuMAo+IAoK
