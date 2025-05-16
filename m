Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38C1922FA;
	Fri, 16 May 2025 09:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747388184; cv=fail; b=OQCC/QVkXFLQpzvfbdOcgT5ydhF9SWTDE0hYZtpylWAjOFGg11zGBkl4qHjdgqYb3n2NHGuNiVRprld8QTADCw0oV2OB28VM3IigRh6rErk3EHx6CJdjauzLIc7H1l8484BJwAEG2QAobw8VLBHzXHvvp/VsPZ0IU6HqBRRo4CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747388184; c=relaxed/simple;
	bh=kOYIjkGO6WJYlVcIgPDiwbxqxZ7sA93dXTFCJtOxguQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h6gj3oh7wvH746iiiKoCPycbpprjOkunzZLKG38yftqXph1g09KNmyPHcbhIJ3FEYNcLpo8db26Bmo0oyfyxK7lP51NKo9AJSkM0i1koWRpk9SXt/Y6q9luxNtNuab2z6JY1P93GPSXL3gSDIiXmLCqvg4wlP64Wc130GIhsIP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=RtYoR2kg; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=AK3ULvNp; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RtYoR2kg";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="AK3ULvNp"
X-UUID: 349725de323911f082f7f7ac98dee637-20250516
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=kOYIjkGO6WJYlVcIgPDiwbxqxZ7sA93dXTFCJtOxguQ=;
	b=RtYoR2kg79aDMgn2dzRFpXVETTRbxUDNqIdg+yzl/hUXx3IckUuEUVEufHRIW9G2Gs8nr4c/aHfdjqEZW+XopJwYJfs8n7/mprg4mhe/aYiHbuDY8FIva8k0GVCINqYpUbF09Ti3XSabwHop3t5pesf3LUtzI+Y0m4I6omkfgqg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:46d3d463-29d9-4ea2-80cf-9f22f696d42c,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:eb8bcd97-7410-4084-8094-24619d975b02,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 349725de323911f082f7f7ac98dee637-20250516
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1226854814; Fri, 16 May 2025 17:36:12 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 16 May 2025 17:36:11 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 16 May 2025 17:36:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=le8lr1QMit27JtVuFEA+zNtHjTX998A05VxKPy8W5LtDv2qCBG8K8PCb60Hjo3n7MUjLi48wQHY3w7UI4tVgkUErD9KzJghEnkjvprnoLq39pe4i4XcUugSxlOx7jjjD76U5FFko+JyLZ3rwCWO3UVv/BifVYDSx3Y1KRS51y4ht0llXY/S1Obdmqjm3IObfsQJuB4lrRt1WZjQmuV3JrQYdzg3wULK1snX9Jr7eu8OMJu4TeuCC/Xa8XHY+1nVVCCjbJ5CpDU9pi2avdc0cnClOSmRzuhDbwNCQcYr85bhecpWJDG5u1Kiz6UgLS9+wiidPf1DU+sDDrHqMbCEGAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOYIjkGO6WJYlVcIgPDiwbxqxZ7sA93dXTFCJtOxguQ=;
 b=PWGWyZgg+tdmCU+qnWhE7/Hm1ijzIyePFCzynaoZn/Pd5eOJ2t/KlseoYL1ya0Uxu3e7LeQS2h9WqNkUOgTikfrA8TlG56xalpQnX11YwwsVdG7xkcn7Ht3sr6U/OBwLS/f7Bn0PqJ2Ibudak31wxYXZAM/tEQUzPCiAoAseuMnR8mcP9w2qGFXnX+7TCkIPgX/nCy9V0B189+lK0QVDVcBBeBzJbzJt37OhfzKyOF9yQCBWmF6NRQOxVIhIXuB7rXSBoi/0tVpK3Z4pMj+EdCN8GUY5R2ucpNa4mIn/amo2939PxZ4H8UyyQ8Tb7Bg37L9QBS1pIVVNaEw//vGDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOYIjkGO6WJYlVcIgPDiwbxqxZ7sA93dXTFCJtOxguQ=;
 b=AK3ULvNpK2YnxDQOZX8XnSLhV1dmkRxaUVoO62SvF6x2MB6gfXifaIAMkoEf23L/QpfEdcZXq7/cXVgTtUXf73whxoHYIc8AB0ag0zyOGNKijDtKprdVlsJG56S67dj4a8mGdVU/k8VZM7NFH/p6BspXqY6foLGK0aKj7drezCI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7937.apcprd03.prod.outlook.com (2603:1096:820:fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 09:36:09 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 09:36:09 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"ping.gao@samsung.com" <ping.gao@samsung.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
Thread-Topic: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
Thread-Index: AQHbxj3K5HN5uDrqc0Gz30U8ePx8yrPU/2sA
Date: Fri, 16 May 2025 09:36:09 +0000
Message-ID: <63c8ec49f738157819568c6e8b4241913543b718.camel@mediatek.com>
References: <CGME20250516083723epcas5p216a21ffb81631d35f0a12f7a583ea248@epcas5p2.samsung.com>
	 <20250516083812.3894396-1-ping.gao@samsung.com>
In-Reply-To: <20250516083812.3894396-1-ping.gao@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7937:EE_
x-ms-office365-filtering-correlation-id: 07cfe1c6-4b97-45b8-e995-08dd945d16d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WFdWRzQzRHRZMnhyWXJMbVpqcTVTSURXdzZnNTNTdnI4Z0U5bzlSZFpxRzFG?=
 =?utf-8?B?Rm1MWFdseFlxb3JWR3FpQjltSEhnZmpBd3lLUGtuVXM0VDVmN1U1enk5R1dD?=
 =?utf-8?B?eS9DSEJ1ZjJsZ0ZHM1BFOVkxSnNFOE9NZ3h5djJ4emZkNkxqUnBBY2UyZHZX?=
 =?utf-8?B?Vi8xRDdOR1F4UUw4QXQyTlZvem1tcUkvcDNxUUZYYmNNT2JYYWJZNzFSTm9I?=
 =?utf-8?B?bEgyVWlEL2NVckJUNkNuR2NxY3QvZ2NreVU2eDJvNm9Qdkk3MytzbnBNcFZF?=
 =?utf-8?B?ODJTMGRKeDJ1ZDRtYjdOaWxrT0tPNzJ4ZXk4NHo5NFNmYUdQMGQySldEVEZj?=
 =?utf-8?B?YmFGMS9MNFVEYVJEc2J2NmpOY0xzOHRvZHEvdTg1Z3VLcjBjUEJYWW1FOE5l?=
 =?utf-8?B?RkliUnZLUGNxZWRhajd0NEw5aFNGbk9xYjltMlRwR1lFTyt6bDNZS2ViODQz?=
 =?utf-8?B?U3daOFFYdG5zandLVGQ4RDZMZ25XY2tSMU9IQmxJNDFGYVF3Y2tFL0NVOWxJ?=
 =?utf-8?B?aVlkKzM0YmZDd0w3Z1dUdGo3eWhiM1lrS0dkTUpaQW9WY3JUdG1nd2RkRU9q?=
 =?utf-8?B?S2RJeFU5VjA3NnRwMlp6MUtDZnBkVTNxTWoxYVliMklrL0RBMmF5K0wxZDYz?=
 =?utf-8?B?QlV2dFZJbk16ZnZRZlFPU2Q3bU1WYmYrMzNwb2dVOVVjak40NXFkWmRVL3lp?=
 =?utf-8?B?TitybGZIL3RTTkkrQUx5b1g0aFFoVVZrZEQ1TU1CTW5XblRzNWdLWnpuZXlY?=
 =?utf-8?B?QllkWGtNRXFpT2dvVmZTRnIydXFzWm0vWitucGlESmpNN3B1T3FIenZWNjBZ?=
 =?utf-8?B?aVZwQVV0MUMvNVQ0Z2krS3pVSHJMT3dyMmJ6U1BWZkFHS2ZKQW9INGYrRnpa?=
 =?utf-8?B?ZnpNdEFTb3d5MWRNd0M2Z1FFOTZYOGJPWGk4VDlpQVNkSytlYkR4RjRvbkpU?=
 =?utf-8?B?MnZrdzF2V3JxZVFOdnRpZDdCM3d6RHZuK1U4V3paNG9MOWRZQnVZN3AxMUJE?=
 =?utf-8?B?VkZUL053a3BXZHlZNHdMRXdGUFBGd25jRHBUUGpBbVEvM2YwQ1oremllV0VF?=
 =?utf-8?B?Rjhvdkk3NG5kd2lXK2hvcUtnL2VveWtOdHJsZDdqSTlPYmFzVEc0WWZKQVN6?=
 =?utf-8?B?bzJOQTl6MEJ5VGpHcUI1QTF2TmFvWjhNN29Ybmo1WHRvTjRidHAyVmRiUFpH?=
 =?utf-8?B?c1kvMnhwaXVyOXBzVXM2N0NkRHlzOEdveFdrZjBsU1hPQ3pFR1hsZTE1NjZa?=
 =?utf-8?B?VVhNVnpRSFIxZUNPNXhPYmsrUDRmeEVZRU1PN2xLM3AxT0IxV0lBN3pRWVVt?=
 =?utf-8?B?MW84RjZKblIwNHJUQmJGSDAxZGtJRVlGR2RrYlpFS1NySHVNWWNVQzNWb0JL?=
 =?utf-8?B?S0NpR1FyVnpBMm1Nb25FOWlzL3kzU2pjZERVaVhFYXE4TlBrY1ZRNHNNM0VF?=
 =?utf-8?B?RVk5aGx0WjBLN0ZqcHYvMW9xejFiLytFUDJWODQySmtXQkxTMTJraHJWYkNX?=
 =?utf-8?B?TmcydVhhSDFtZ3JtOXZhaHFWSHIrekxlcGNac2xDRFp4aStvSTA3c2VvWFVz?=
 =?utf-8?B?cXRxZmhLUmJHaUFEWUNZaCtNWVpkMEoyNXJLNSsrbGxJOEg5RFl2cVgwS1pz?=
 =?utf-8?B?N2JtR3gzUlJjSy82eDdTVHliSHdHM2k4RVM2V2MzMlhsVWdrWG81WmY5UWRs?=
 =?utf-8?B?Mll4eWNUenVjdnVLcDFhczV3VHlOcUVrejF4UUtDSHpHMzJZdUpjUzM4ckMz?=
 =?utf-8?B?a0lXem43dzVvZld0RHB0ajVnenNCNkFlUERlWFhITTB3ckptbk11ZTBlV3Bh?=
 =?utf-8?B?dDVQeW05VVJKQ05JaWQ3Z2xhbDMyZ0JlaGVGMzNsQ2dkdnN5LzJWSGNQWjl3?=
 =?utf-8?B?UXRGZjV1cWRsZVlzcWFoNDNiWEJGWU92U21nZHRkSUhaVWtBalFLeitCYjNG?=
 =?utf-8?B?elp4d2dHRzdwOWEzdjVSSUk3SmlBZEs0OWxycWJHS1ZpVEw1b0s3LzdBL3lF?=
 =?utf-8?Q?1QJC29KTDy4IBcNVtPo0RImuGcNLp0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajFGaDgwcm1PUy9WU0xzVFd6VklnMi8ySzFkN0FTWWR1WWVLZnUvQWhuNjNR?=
 =?utf-8?B?Y1RKUHlQKzRHSERNMGl1VXhnR25IVWUyNS9Ma1U2WU5FMmZKT0dKVHc5V0xN?=
 =?utf-8?B?UEhGc29WR05KS1c4ZnJLY1Vkc0hRZGVoS0NoZkdRTDRyazU3N0RMbWpIOU5V?=
 =?utf-8?B?TFYzTVlReVI3M2Vrbzhqcjh1TUFCZkp4K1Z2VjRtUk9xSXdHUTg4cFdVUm4z?=
 =?utf-8?B?UFpYSkVHdE5OMGpkaFBTWHA0SHBmL0x2U3VpZnRvcVJKNzluNUZDdk80NXJ6?=
 =?utf-8?B?a3NkeTdSVEkzR3NtS2VEdDRzckRrL0NxbjRCRkZOVnBPL3dYc2RsUGpadHZt?=
 =?utf-8?B?Sk1zNklBdWpqdHlNZlBlaEkwb0pDWWh5bWhhZTkrVmppc1NpaEwySzF4K21w?=
 =?utf-8?B?VjU4NjVBeE9xWCtPWThXK29FV2RqUE4yUEFVN0VFUXBZdk1lMlc3aCt6NDRH?=
 =?utf-8?B?NFB6OWdUL1Z5ekZpVGMrNlJZL1hxRndUUXRWYlRGTUt5ZU9UWkRjaHE3Tlpm?=
 =?utf-8?B?SGs2UG9RdEdnaXBzRFhvMkp4aS9rdGc1Zll3ZDVmK1RGdnNVa0srVjFpckRL?=
 =?utf-8?B?dXBlUW5MTVoxemJpQldZL3pwRU5KdXhhWHpVVHdJMXg1ODd1SWVTNFNtTE13?=
 =?utf-8?B?YjErcy83S0Z1eEtpcnIzOUgyRkxZU2RRdmVER2MzMXIvbGVRQWFQdGR3RHp4?=
 =?utf-8?B?L0pobXNXM2Mxc3NPbTBRbXU4UUJHOGEvUGR1SS9nWklLSzZkVjQwdHlqR1JB?=
 =?utf-8?B?SHVGaC9SYW1RR1E4MVVON0lqZzhSUGV6RWxQSERiSnp1ZWNhRzI5eFkyMHVZ?=
 =?utf-8?B?WjlYaXBkaEw5ei9oUXcxTGVIaDRZMFlMY0puclhGZ2lCakZicHpHU2gwYWk0?=
 =?utf-8?B?VlhvR0xaZU9QTzFidFVvOUZBZVFiaDU3WXlTMHM0dDlxZjJiUEhnRzI4UVVB?=
 =?utf-8?B?Ri9FZlh3Y0hYNHNmaktGOEZvZmtGOE0vNStWNDNsdzdZdCt5bzBZZDNNVDV2?=
 =?utf-8?B?K3Vna3AvV1RzT0dpWmQzZTFiMzVnbGlhMWo2eVlNOFFhU3A4VXoxTldoTzNj?=
 =?utf-8?B?ekh5N3U1OE4rdW9pZHZ3SDJVdU1TNHp5d3JGajdBZVNCWjZIM1dnTXdnOFRM?=
 =?utf-8?B?dG1rRVliSXVSUVdPSkJkMDVPRHFiQ1JVdDA2anhvWkhQTXErWU1wM3BjMitZ?=
 =?utf-8?B?N0VqeWJoRVRpUlhRR2cwU2Z1S01KWkVNc29ZT0ZsWXVOcmRNTERyMXBjQ3hW?=
 =?utf-8?B?cEM3NFZjeFdOWER5WUd1N1lVNjB5bVlwTytyODdpWXRIeVNRL0c2MTZMbFRr?=
 =?utf-8?B?Z1JVK3FuQlo5SjVORE80M1FJZUNSTDl2c05WR0Z4S1krbnZhODZGSGZtTTNp?=
 =?utf-8?B?VzlJR3JDU01uRHg1NVZOdFY0WHNkclZZZWtRWEM3QVNQaFR5OVA4LzBmQ3BV?=
 =?utf-8?B?VXNzUjdueEtMajJoTExmdHVkRmFyR2FCYmRGVC80c0JYNEhEQWEyVGhZMnNl?=
 =?utf-8?B?YmpoQXlhVk85Nk8rcXlvQ0M3RUFHNWowS0pLbFNKZGErYXovL3BiNzJ0a3lD?=
 =?utf-8?B?eXVJaCtQdS9hU1hlb1MyV2VQY0RXREZmcjI0UFc3Qm96TXh5RCtwOHRWV1Jx?=
 =?utf-8?B?aWtpNk5WWitsUEIxWTMyRkFqUUV6dzd1RGh4VC9nVEIzUlhGeiszRENBWGxo?=
 =?utf-8?B?UFhmTytUd2hCZ1VFb3FQdU9VeU1Wb2cyK2hVU3BEdW96MWxqMUlubWFCVHJ1?=
 =?utf-8?B?MUMyS1FFQnhraitJL1dXUzhMcTJlcW93M2hub2hlQy8yZUZKaW9ZNWppWmpF?=
 =?utf-8?B?WUFmczRmaW5SVi9hV08rU3ppelRmSkNVbHVlMk94aFJLK0NZdDNuK1pxbitK?=
 =?utf-8?B?N1RDZDFCUnRqRzFlSXBhbTMrSFpZTDRJb2NKalc1cW1MbWdVUmVaZGRzanl2?=
 =?utf-8?B?ek41Q0xLSURRUVQvSUJ2QTI4SGREVklvUzJjR3FFbEIyRi9IOVhuOWMzWkNx?=
 =?utf-8?B?QWlzcDlkSG9zcjY0enpwL3BxZXl1cDdFdUp2VVYxVXIvb3pXTzhWaUdGdjFh?=
 =?utf-8?B?ZElZQmxSTzJUMlYrMTBUd0RZY1liaWZhOWFxSXg0Q2FjSEs3SFV0ZmtoYzY3?=
 =?utf-8?B?aUY2WXBHU08yd0lmZFFpODNCOWNGenpJNzZraFNEQko2bXdHSERUNjQ0eUhX?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC19E9E70C6F444D8C8B944DC4C278D8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cfe1c6-4b97-45b8-e995-08dd945d16d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 09:36:09.1899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64BPS9j4R1MsljvujcZyaHNz7o6YqcUfq3VNIGLs9831lPNyr8y1O2oPN4QEtvHcUSk1oe+ViSPPzlTJigrjMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7937

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDE2OjM4ICswODAwLCBwaW5nLmdhbyB3cm90ZToNCj4gDQo+
IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFj
aG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNvbnRl
bnQuDQo+IA0KPiANCj4gYWZ0ZXIgdWZzIFVGU19BQk9SVF9UQVNLIHByb2Nlc3Mgc3VjY2Vzc2Z1
bGx5ICwgaG9zdCB3aWxsIGdlbmVyYXRlDQo+IG1jcSBpcnEgZm9yIGFib3J0IHRhZyB3aXRoIHJl
c3BvbnNlIE9DU19BQk9SVEVEDQo+IHVmc2hjZF9jb21wbF9vbmVfY3FlIC0+DQo+IMKgwqDCoCB1
ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZA0KPiANCj4gQnV0IGluIHVmc2hjZF9tY3FfYWJvcnQgYWxy
ZWFkeSBkbyB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCwgdGhpcw0KPiBtZWFucw0KPiDCoF9fdWZz
aGNkX3JlbGVhc2Ugd2lsbCBiZSBkb25lIHR3aWNlLg0KPiANCj4gVGhpcyBtZWFucyBoYmEtPmNs
a19nYXRpbmcuYWN0aXZlX3JlcXMgYWxzbyB3aWxsIGJlIGRlY3JlYXNlIHR3aWNlLA0KPiBpdA0K
PiB3aWxsIGJlIG5lZ3RpdmUsIHNvIGRlbGV0ZSB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCBpbg0K
PiB1ZnNoY2RfbWNxX2Fib3J0DQo+IGZ1bmN0aW9uLg0KPiANCj4gc3RhdGljIHZvaWQgX191ZnNo
Y2RfcmVsZWFzZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiB7DQo+IMKgwqDCoCBpZiAoIXVmc2hj
ZF9pc19jbGtnYXRpbmdfYWxsb3dlZChoYmEpKQ0KPiDCoMKgwqDCoMKgwqDCoCByZXR1cm47DQo+
IA0KPiDCoMKgwqAgaGJhLT5jbGtfZ2F0aW5nLmFjdGl2ZV9yZXFzLS07DQo+IA0KPiDCoMKgwqAg
aWYgKGhiYS0+Y2xrX2dhdGluZy5hY3RpdmVfcmVxcyA8IDApIHsNCj4gwqDCoMKgwqDCoMKgwqAg
cGFuaWMoInVmcyBhYm5vcm1hbCBhY3RpdmVfcmVxcyEhISEhISIpOw0KPiDCoMKgwqAgfQ0KPiAN
Cj4gwqDCoMKgIC4uLg0KPiB9DQo+IFNpZ25lZC1vZmYtYnk6IHBpbmcuZ2FvIDxwaW5nLmdhb0Bz
YW1zdW5nLmNvbT4NCj4gLS0tDQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMgfCA1IC0t
LS0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3Eu
Yw0KPiBpbmRleCBmMTI5NGMyOWY0ODQuLjIxMDZjNjNkYjVjYSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNx
LmMNCj4gQEAgLTcxMywxMCArNzEzLDUgQEAgaW50IHVmc2hjZF9tY3FfYWJvcnQoc3RydWN0IHNj
c2lfY21uZCAqY21kKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIEZB
SUxFRDsNCj4gwqDCoMKgwqDCoMKgwqAgfQ0KPiANCj4gLcKgwqDCoMKgwqDCoCBzcGluX2xvY2tf
aXJxc2F2ZSgmaHdxLT5jcV9sb2NrLCBmbGFncyk7DQo+IC3CoMKgwqDCoMKgwqAgaWYgKHVmc2hj
ZF9jbWRfaW5mbGlnaHQobHJicC0+Y21kKSkNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoaGJhLCBscmJwKTsNCj4gLcKgwqDCoMKgwqDCoCBz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZod3EtPmNxX2xvY2ssIGZsYWdzKTsNCj4gLQ0KPiDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gU1VDQ0VTUzsNCj4gwqB9DQo+IC0tDQo+IDIuMjUuMQ0KPiANCg0K
DQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
