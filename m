Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F1E3174DE;
	Tue,  6 May 2025 02:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746497293; cv=fail; b=brMGq7Lono5S9Rtqzrf847sseP7IroRUXhodPSdAycQSM1C0iXWiXUtQiyu4f6l9afJYA8mFmmxsliKNpksI/CHyCGEY2ztuYnXRy2qFQ1gCHvo+DqIxpPROb4VRPJ9t9bQBo+Ym9osZjIVg07ViBftY1pTdptf/Fsdrf9VL8QY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746497293; c=relaxed/simple;
	bh=C1zMU/dBNNaFoSfp9nXmbyh5cTjKP5yzlXavV+/GSMY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dBiA08bDIEeOU/lwciiYnrp4njPxVM0v/SnPZexMx7FVzzgQT0ybD+1Cq71zCp5JDmVEdq8PU5l7YdqAyG11QdRoCkWzQ2er0SnHIxdCjD307qVrZNgLB2QLQrKzzy+5lt6Q6HdsowRRJomZrW/aQAkicl4d2pUu63/xgTgaNuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WSb7PSqa; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=roilOzmk; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WSb7PSqa";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="roilOzmk"
X-UUID: f19b97642a1e11f0813e4fe1310efc19-20250506
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=C1zMU/dBNNaFoSfp9nXmbyh5cTjKP5yzlXavV+/GSMY=;
	b=WSb7PSqaAxM2qA1tVGmWVmVgES0e/w4y+MYRtZNKTgwo1B6Rdo1EqUeKe/hcikFfXZNw7wzIgXuiywVvoQph4wcli0Cz8CBBfEUVRlaFm4NriBv21LSdYoZlCNVjT/ahoy2ujSLaPf+L4XCsTrzIDe2UaRz68Y8iRMpsEIQeiz4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:463f460b-23c5-4416-83e8-a2c54d105765,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:c313cb2b-be47-4281-8f30-e6479b5e1210,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: f19b97642a1e11f0813e4fe1310efc19-20250506
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 657585842; Tue, 06 May 2025 10:08:03 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 6 May 2025 10:08:02 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 6 May 2025 10:08:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HIy1c60VFKprmYBI8L+kokAp/WNsBQDLvSci4Q3Dh1lvvxlM8oOYzPPhHi5Sutdo8M6n5yEgN/MduPy3ddUeNPmpPZCcZUd6UbXm6w/xHx2/UfFOoe6pKeVM2DA2WibEbysskDXXdPIfeKx0ZT7rE/R5tEJGkQquVpWWctaFvcbkMzZdCnS3ABf0mtcNUCGjSUqhC40MrhNBirhWyYCuelpsqzEz5/mF8TUn4zdBoqyD4IU/5XUQ6rS888IbkkkTiGaaEW7PlvFNZfIJUIPNgHa5h4BioJTMwCaQVxg2YuJT0Jm57Qg5QcVsgFAVdhZCYRjWhCHvI7P1E9vN4PrUtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1zMU/dBNNaFoSfp9nXmbyh5cTjKP5yzlXavV+/GSMY=;
 b=FL4ZS8xGStGD2PjP5D/w4RLCPfEhOrj/Z9gWhcpcjO0uSkh+9sy8BtzqZN8dhgacYDTuTOQrKnI3KW1FbG4PTjKqVODMEAifE7q60nxEr3VxfTe3iYSJbe+abaPA635YNWON9WGBV1jCLAs1/o6QPCGa5OtcZpnpeJtXJDSsNbwW33Yim9GT2SPzZnM2aU+p/pI8qtYnlyYD0MH6RD2r6yCdWucwSwD0bpMRuWnrbSmSrO3GvcRMKXXuUwShgEDydsQEuyhYqFNaU620HSSkwz21er7H7UK0GsCx6gnGo7iD6QYhX4gmVkpKaYywW/GFZwUqX47FEohB968l66MYTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1zMU/dBNNaFoSfp9nXmbyh5cTjKP5yzlXavV+/GSMY=;
 b=roilOzmkGtkvO3cjIUrZypU4zCmF2RXIFMh0uk5dJUdmKQRPCtCQFBj2vwBDGcikEMrEITeSQK3cytM5BENZOwxXBCPOaO5Ap/pJB+Y0jH0TeIp0xniBWkpC25sHyuHj8JSNRUAEmqD5jOJJPxFLZ27wm8xzZUY++SsLgy2hShs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6611.apcprd03.prod.outlook.com (2603:1096:4:1da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.22; Tue, 6 May
 2025 02:08:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8699.031; Tue, 6 May 2025
 02:08:00 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ufs: core: Remove redundant query_complete trace
Thread-Topic: [PATCH] ufs: core: Remove redundant query_complete trace
Thread-Index: AQHbtX5Bk4mH8gPeGEC4dU0Ss7r1ebPE7GSA
Date: Tue, 6 May 2025 02:08:00 +0000
Message-ID: <f62946ef937adc8b30227baf726d0f02752381a4.camel@mediatek.com>
References: <CGME20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
	 <20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
In-Reply-To: <20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6611:EE_
x-ms-office365-filtering-correlation-id: ff30da5c-3168-4a1d-452a-08dd8c42d3bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dVBSdkViQVZiSTR6TDJuUStkd1E4VXIwQjNleXk5ZnJuSGllTTRacGk1S0Yw?=
 =?utf-8?B?MDNSWGhpWUNaY3FKVjdDcTVmcGh2WURnYk41Mi9xeTh0NEVWalJqWGVXUHY3?=
 =?utf-8?B?RTdCVk1zb2RCemlkdEdNcjhMTGprSnd2QzZLb1A2U2IzckV1N2E3QnIvNHRQ?=
 =?utf-8?B?cnhzbTNYYTJFTlFhSElCbkhyQ2Y4Q3haS29oc2FvQWVyK0tCQTdWVUh2OUFk?=
 =?utf-8?B?WkZJd09CdDYrSlJVWlkxa0p0Zit4SDhJSTJxVENNMVh3Vm1BZHlwTTNHNXY0?=
 =?utf-8?B?dXZQM05DZmpadTIrMVdETFBYSXhoVWZLVG9NWVZSZy83T2l2SnArMEYwTVpx?=
 =?utf-8?B?NlY0MEdUQlNwc0tqZ0tPbUZHeU1KRjcwZklkRVZSSko5OFpRcWZSZ1VSTW9k?=
 =?utf-8?B?cGxhWVlJUkh1aVlFa2t5Q2NIeGlTaTkrYWw1cEN3aHFCU3pITUlMcnUyRmFr?=
 =?utf-8?B?YkFvWTR2RTVZbjNrNXZZRk1Hd1dvcDhXQlBGNFpkekVhaGJ5dDUyVVhuV2Vt?=
 =?utf-8?B?UTlyK0hha0FVMUhLU1I2TEVrNkRFTk9zODUreWZyWGdUa2hqOHUrR2lqR0JW?=
 =?utf-8?B?cFQ3SjA1RTA0NjlCNXFObHZoOFV2T0FSVm5MVitqQis2S21vajNqNmIzOStp?=
 =?utf-8?B?UW5LelZpaVBpeG1iWERwWHliaXNkVmQ5RENPZEFldG92TnNLOTNqenJXMndi?=
 =?utf-8?B?K1cwb1hlSGpDdUd6VVdMeEVUZUNMeFg3SjRuNmRvN3IwOGk4YmRKOWpEVXd4?=
 =?utf-8?B?QXFSOTRhWmpwMFZ1NGZFd05rQVZ3OWN4SWJkMWFVZFVTMmYzSENYNUpBOXY3?=
 =?utf-8?B?aFI4aWkyaUQxOUNtWERGbVhGWElKUVRsSTlKNjh4dTU1YU5mUEJmc3VEaTRo?=
 =?utf-8?B?a1Z5WW5seDd3U1R3U0lZZXArUU8vdXN4WkwzOW9HY2s2VUZnUWhhU21uY3RF?=
 =?utf-8?B?aDlZdmN1VkJJTjBqd09xRGtlc0o5cWxUc2dOcU9CWlEyb2htbWlPZ0wwZHh6?=
 =?utf-8?B?TDFYNDV4QlVSS3VSZzF6N2RSQmxkN2RaSDZYTnhaSmpPZk5uMGRjZzlKcERX?=
 =?utf-8?B?MnBwUXBuTVlYYjE4SHJJMUdTOHViS2NXMnFRMWZ4ZkEvUU9QM3ZuV1QvQmNs?=
 =?utf-8?B?QjdqVWduTWNuQnJhdjNEQVMxSHZzcTZVWU5vWW1adTdiUlh5eE5vZmQ3elRu?=
 =?utf-8?B?TmlUejlZdTQ0VDFQQm1OeEJ0WGZMQXJLWkl6MmgxYlJrTmF0cGVSakdKSjZN?=
 =?utf-8?B?YlN1bEJkS2xXUllqeTdzRndUMjlmME5iOC9FcjRQaUZ0VVFrRFdNdEsrejh2?=
 =?utf-8?B?NWRZY0FLU1ZEYTRpdkQ0VHhyYUFrZzlZTkJQTExBUm9LL1FrSEc0ZXNZZUdv?=
 =?utf-8?B?Z3hYTFQ5amhkRFc1MGlENUFMemxCeEJCUXRBMDlrWEttVHREU2h0cTF0djBi?=
 =?utf-8?B?R0FzS25HMzc2azdJbWhDeWFGMU4vQnVUazJBbkl6UTNXK3ZHY3BaTHlneTJN?=
 =?utf-8?B?Wmxsa1NtUnNHa3Bid1NzODZRTXFEb0VqWVA1eUhxQTBITnJHUEVPNlMrR09O?=
 =?utf-8?B?dExjWStrQUZyZXZKOVlNb0FqM1hlMWtWOE4xSGZZOU9VbXl0cU40WEJWclV4?=
 =?utf-8?B?UXhTWUVFWW4yOExYT0pkbTZZMEhFTSszMmwxdlJjdWxoeklkcWVqbzNiTWdO?=
 =?utf-8?B?Q1hLTmtjUFF2WW9pYk8wcnlTWFRadGRQRWkvZ1FuS2VSelZ1NExXUWdBamlG?=
 =?utf-8?B?QSs5QVJuc3dLTml1U3JLVmZEL3lUMDd6dXk3cTd5ZFZQV0hEcHJRRHB6Tml0?=
 =?utf-8?B?c0ROYXhOcitzZ04yRHRZbWV3WVQ2RkYyRGdtSnAxbThvUUU4WlJTdWtDZ2l1?=
 =?utf-8?B?SjRMUzZzUjV5aFl2RGFxYURyQkFXZ2JIdmwzR0NVNFhYTmsxNEczZ29zNU55?=
 =?utf-8?B?TkFlSzNPSERpa28xdE40aGc0MjFHNm5XNmJ4SDJaQ3FiRGZCazFUVFFsaUlN?=
 =?utf-8?Q?n2gdCKTjEACW5O1bc2qHBa+MnNABpI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmdJelZTRWtnNTBjck5wMFYyaHV0NTNzMTlsczYyU0RHWXFCSm9YZ2l3alh5?=
 =?utf-8?B?RXVLc1VBS2tGNmZVL1dkR1ZaT0ozYk5GMWRqSVlwVEQxQ3ora0xkL0pCR0VN?=
 =?utf-8?B?blc2bE15L1RsUlhrbnZKaVBoYjBGQnJDSDdQVHdTaythbHlEVjEwSFN3cXQ0?=
 =?utf-8?B?K2QzeFY3ZUI5eXF0cDlTaUlrU0MyMVpPd2pYR0FvVzg1V0VwNmFRYm1wVFNp?=
 =?utf-8?B?NnZmdklSYkxjREduUUJJWXhjMEcrUzYzL0gwYUNtU2VEbkZrL2NncWVWVitv?=
 =?utf-8?B?TVZqcXozdytSTTFTL3QvcC9QL0JCTEQ2ZDE2anNJY21rV0lHVUlNYlNIRmtC?=
 =?utf-8?B?THdxc0pXUjBEbG5KTEFYelVza0xFd1h2bEErNXJra1VYZUQ0UUp2M1JZWld2?=
 =?utf-8?B?YlEvY3lSNEQza2NBak5VZEtUYklTTU5QTmtFdEpxbllhQm4rOUJRY2hPVVAr?=
 =?utf-8?B?eHdVcFdIVE9kV1REeFVkSWNoRE9zRm1FWUlWZ1dVOGZQQ3JnYlBBUzRYTGpz?=
 =?utf-8?B?THYwRWdnRjZFclh6RE9PZlpScGpBWERpdW9xL2ZUVDRnWlNxSzk0eThmckc2?=
 =?utf-8?B?ZXZBcWFQQVR5dFNLYzBJSko4NHpsQVpQdUI2eTZDY3VYbHNEV1R6TngrOVp5?=
 =?utf-8?B?eE5sSlBrN1FpK05JYzludndVM1lyeGViM0VYSTlLTVhyNkdWenNUNFIydmxM?=
 =?utf-8?B?NDZKbklvVE43eUJ6SHVHNTVyQVhsNHVvVUlKWDhIKzFKdEdqUGVlcnlCRGp6?=
 =?utf-8?B?YmZoWTRGZnF2UzZ6WVVjbGY3VittM2VhbHRjZ1doMVF1M1BkaWNvRC93SjRa?=
 =?utf-8?B?T0IzZThjYWJxOWlVRXJwSEM4OXRDRnlnQkRQeGlnMG1VTWpOUmFFK2dHLy9C?=
 =?utf-8?B?bVo2S0d6YmRrV3lHOEY0OFU5SmtJbGtpbjZseHh3Z2RmL05pTG9UeDNjdnEx?=
 =?utf-8?B?M0MrTnozSXdyVHREbzJZczRNYmM4a1k1TWZUSzFIR1VPbzJnYzVtYVA2UDQ4?=
 =?utf-8?B?NmQ2bVVzVTJtS25VcmZTUytkL1dZTmtaK3BVSDZTZEk0eStEWGFYRjV1dEFw?=
 =?utf-8?B?MHBxRHNUWGJyVEdLNDJjS1Bxa0VvMDk3RThsNm12bUszZ2dFTTROL1pVQ2xG?=
 =?utf-8?B?MXhSQ05RL3NYRi94UTc5OVAxY0FFTnBWbVlvM2ErTkFyNXRkYVdFbERvd2tJ?=
 =?utf-8?B?U3BBYTNyeGRUVDN1Tk56Y3JZL1U2SDg1Z2czZnV4ZzhaZ1B1V0xFTzQ4Y1dt?=
 =?utf-8?B?Y2lCVVNpZFlnL0QzdW9lYkpKc2RNNGdLMm9Zb3ZuWmpGS042aDFrMVJtN2VD?=
 =?utf-8?B?cDlDblh3bmhEVDNWU01oNDFZM0VuUlBMSExzb0lrZHd5cnh3OUxOQUNFMUpS?=
 =?utf-8?B?NG1VQkhXOGFXUzYrZUlBRlVNeUdHdW5GU2NDeUpLUGpCeGw2R1VkdWV6M21w?=
 =?utf-8?B?cGxrcEhxRFRjRXZWcU9FTVNwLzZrSWZUbEl3bTBPSktxTUNsWDduODBsVTJp?=
 =?utf-8?B?UmNmZm1zeUdqTlpWczgyYmtvaGM2THFYYnlVa1E4TU14VWFsRUp4WDlHVGRT?=
 =?utf-8?B?Z2xudmwrSDNkYWozZjR4TGp5QmkrdmZaTmg1OFo2b3dlbDh5YWx3Ni9pVHc3?=
 =?utf-8?B?YjZTVWJPeGYvSHVLV1ZtNGFDL3FWbTkrMDFnVExjaXByMWdaNWRPK2dDQVND?=
 =?utf-8?B?K1JaeVovQ1BuMGM1MlVxWlNrQU9FUDBjK1ZhV05ySENQVWFKQWhtVk83SERj?=
 =?utf-8?B?WmR5MmlXZzZwd3ZxZmVDTTFZNFR1WjAvczJ3c05HYWdkVzNzQlpDdnpkT0ZM?=
 =?utf-8?B?ZVRXbjNralp4d1FsMkFaSzc5TGhVSkJIYnpHTXRtUmhBeDJ5eVdFbkgzVitp?=
 =?utf-8?B?TGJiRG1IdTJRbUNkZExsbEhUYnNvTGJ1NCt5eDJ6VWtDRWk2L2NRY3g4VHRy?=
 =?utf-8?B?bzVoeFk3RlgrL1hvMWdtSlVtenhkRzlBb2V2ZS9VbUY0TXNyQzlvQlNaaVNE?=
 =?utf-8?B?Szd2NHFSM1JlbzBuYTVwRlRPMFQrdDRGZXRuSGFxVlBzYnNmblZSc1FpS0pY?=
 =?utf-8?B?QkZzMlZJYmhSUXdva1Bma0ZiOUhYdmY4UzRnMjdvMlBwekJKOFhzNnkzTG54?=
 =?utf-8?B?MGNsTnNKL21lMXl6V1grSWs1N2NEd012VXhMa09RR2RUbmxaMjJLc3lEUnI4?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDFB02A1A8B67A4E81847834B2AE6827@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff30da5c-3168-4a1d-452a-08dd8c42d3bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2025 02:08:00.4193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QTDjQv3XDQb1rp8JQ3v57O+vyuSeVTcS+QRxVny88TVmO9NfXuFEsBJhiz83GuDMlJr3k3ufhDuc2xV+FvgC1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6611

T24gRnJpLCAyMDI1LTA0LTI1IGF0IDEwOjA2ICswOTAwLCBLZW9zZW9uZyBQYXJrIHdyb3RlOg0K
PiANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0aGUg
Y29udGVudC4NCj4gDQo+IA0KPiBUaGUgcXVlcnlfY29tcGxldGUgdHJhY2Ugd2FzIG5vdCByZW1v
dmVkIGFmdGVyIHVmc2hjZF9pc3N1ZV9kZXZfY21kKCkNCj4gd2FzIGNhbGxlZCBmcm9tIHRoZSBi
c2cgcGF0aCwgcmVzdWx0aW5nIGluIGR1cGxpY2F0ZSBvdXRwdXQuDQo+IA0KPiBCZWxvdyBpcyBh
biBleGFtcGxlIG9mIHRoZSB0cmFjZToNCj4gDQo+IMKgdWZzLXV0aWxzLTc3M8KgwqDCoMKgIFsw
MDBdIC4uLi4uwqDCoCAyMTguMTc2OTMzOiB1ZnNoY2RfdXBpdTogcXVlcnlfc2VuZDoNCj4gMDAw
MDowMDowNC4wOiBIRFI6MTYgMDAgMDAgMWYgMDAgMDEgMDAgMDAgMDAgMDAgMDAgMDAsIE9TRjow
MyAwNyAwMA0KPiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMA0KPiDCoHVm
cy11dGlscy03NzPCoMKgwqDCoCBbMDAwXSAuLi4uLsKgwqAgMjE4LjE3NzE0NTogdWZzaGNkX3Vw
aXU6DQo+IHF1ZXJ5X2NvbXBsZXRlOiAwMDAwOjAwOjA0LjA6IEhEUjozNiAwMCAwMCAxZiAwMCAw
MSAwMCAwMCAwMCAwMCAwMA0KPiAwMCwgT1NGOjAzIDA3IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDA4IDAwIDAwIDAwIDAwDQo+IMKgdWZzLXV0aWxzLTc3M8KgwqDCoMKgIFswMDBdIC4uLi4u
wqDCoCAyMTguMTc3MTQ2OiB1ZnNoY2RfdXBpdToNCj4gcXVlcnlfY29tcGxldGU6IDAwMDA6MDA6
MDQuMDogSERSOjM2IDAwIDAwIDFmIDAwIDAxIDAwIDAwIDAwIDAwIDAwDQo+IDAwLCBPU0Y6MDMg
MDcgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDggMDAgMDAgMDAgMDANCj4gDQo+IFRoaXMg
Y29tbWl0IHJlbW92ZXMgdGhlIHJlZHVuZGFudCB0cmFjZSBjYWxsIGluIHRoZSBic2cgcGF0aCwN
Cj4gcHJldmVudGluZw0KPiBkdXBsaWNhdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtlb3Nl
b25nIFBhcmsgPGtlb3N1bmcucGFya0BzYW1zdW5nLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0K
