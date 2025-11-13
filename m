Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775082DF3FD;
	Thu, 13 Nov 2025 10:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028388; cv=fail; b=R9jJSe5aHiVB6mbclkqFG9PRWyIJQaAuiJYCHxhWA/AJvw7lSp7jXxMCmI1vkF+SkOEqdIf6hRgWMpYsZpWkSdCvDJsl3KTe1dDZOAmmhwzgS1f7F8Bi7uDhzLWRF/tOv8BsaqoTZSdlBbyRFUNomkn2w85GdWo+FMLAuwBGWnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028388; c=relaxed/simple;
	bh=k4AiBDfCYmFeLZMBBJrIDe3nmtKFXTGJgh9iHX4/CF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZWvDvdtDpuZSpaXRLoBXFDIEvzMew+KO12oPdD7w7YI635YwPOLEMpSfqIIYqt/XzmZwf3V+atZAa+nkWBbcsJwqwKDCrEw/WQBW5ZmU29OVRogNBvIyn3GYMkZtk14IDwA+hy/ktc4B65q3uZ+l2np9dmgFGQqCmwtKXuHFQFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rVrtBAt2; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=WEAn8pct; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rVrtBAt2";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="WEAn8pct"
X-UUID: 66b8bbc2c07811f0b33aeb1e7f16c2b6-20251113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=k4AiBDfCYmFeLZMBBJrIDe3nmtKFXTGJgh9iHX4/CF4=;
	b=rVrtBAt27DqXOf2uvA9bgkXtEwQ5Ut0e3YoIrbGQLS8962n/9RqL7TT30AaTASakwx5E9Gp/Wu24k4b/Oz1HG43em82J1/e05BgLqBtTcTLQuDngax1g2xUKRO7IMJu4dKBE/g7y1+bWyy/HDnsfczMfyrUjAOZxC41OnEEKMEQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:4ec572e0-a896-4072-adb9-7257572e41e2,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:1bc26592-7fd3-4c6a-836a-51b0a70fa8fb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 66b8bbc2c07811f0b33aeb1e7f16c2b6-20251113
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1681624520; Thu, 13 Nov 2025 18:06:20 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 13 Nov 2025 18:06:18 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Thu, 13 Nov 2025 18:06:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KX12zFZHpbr2/NUGxyRJ4aYlY7gIJP7JmzcAJaukef7cIlSHimW1gGhCWb/Bf8YeccfgyPCOI5JM4UKaDqCBZkluYwtq0Ng0Z+R3xZ3gmcl3HRyDNG1LJEoY/6/Yd+5lisVo+O8Owi5odF8ezn9+f/hnNn1PkFW08qQk4frq2FOJPBnodSQJRL1h0Q6HyMWgLkMdVHvgheKyWHSi+kvudvmKX1GQtKGERAKLvLNLNPtdlecJaLdz1djXb4vE83vU+hL512lYgm+PjFjL13JDv+KUOIJRlJl0Wjn1sud/CCTfyCukAK922bejTccFZTQINCnTp2/840ZMI1cNGzXLiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4AiBDfCYmFeLZMBBJrIDe3nmtKFXTGJgh9iHX4/CF4=;
 b=VvxK64cUmyYswLJWla/WHkyqn3ZCZXodIL2HBme5jL6IeCCsSGkkq7VkU3f0ScKj7lqpaGbAh0BXYwXdooYaOCotPk8k81Y8gAVWJbTbRBZALgMzeGNj8Sb8oLt2QcJlHNrOgtVgOZC40sjI2s6F+uH5Nq96M8GNT/OPuQ6DMJE98OLYYLFk72/ervcGmxFyGi//bBi90N9fuFZGXWNKInmDTAjIsmmhlp8SDulNtqZaOJH2V1eKjRTdrKixpm3O4o9wZdZ/esabHvZEIx/62cjfJfqDy2sTzcvDhou5Y/bfLMWr1tmoFSwQjWVZIiYQ1CaE0kC/juqPxy2vyyyABQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4AiBDfCYmFeLZMBBJrIDe3nmtKFXTGJgh9iHX4/CF4=;
 b=WEAn8pct8qOmmxtDKP/yyjagVSoQzYtZBylUTpLYOXSUs/NKsPXyWNi7xu5+5nQ73zlpiT9hve9UaRLQVFSpCB5Y5ndljyxhQhaVuKnFFIiKYd8babzTCMYBckwPeaJfyDgdOCSuCR9aQeWYpGVx1PbSjB0ek1IXmBx7N7bC4Tk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6452.apcprd03.prod.outlook.com (2603:1096:400:1bf::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 10:06:15 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 10:06:15 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "powenkao@google.com" <powenkao@google.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Topic: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Index: AQHcU55F6G16JbOQOEePCVKNWnq4HrTuslIAgAARGoCAAZ+hAA==
Date: Thu, 13 Nov 2025 10:06:15 +0000
Message-ID: <c4bd6532b003089fedf518db878a3843c516217c.camel@mediatek.com>
References: <20251112063214.1195761-1-powenkao@google.com>
	 <7d964e31162bf93f583e6e78a3044152894ecb94.camel@mediatek.com>
	 <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com>
In-Reply-To: <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6452:EE_
x-ms-office365-filtering-correlation-id: 0206b657-5502-450d-65b4-08de229c480e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZEV3Q1dWWkNtazFkTTRrcmdzYUdKcm9hMzFtOWpDL29kYWIrcWlZQVUvb1Ir?=
 =?utf-8?B?UVlXSkpDL1NjM3ltN1NVam5BNjRCQ3JPa0lyb25yNmNpRkhOSFYrekdSTzU0?=
 =?utf-8?B?MnQwZmdrNndFaWE1NmIzbEs5OUtVUGdQaGQ3blJsYUtIRlBkcGV2WWQ2Z0xx?=
 =?utf-8?B?NlpyT1IzRWpTMHFlb2trMGk5SlBnZ3lvYisyOU9BSW1WbXB1Skxaa1RvSkkx?=
 =?utf-8?B?V0QyM3YxWitUWGRxS1FvdzI3ZTBDZmp0K3dweTZxZjVVY1FiRGVhYkd6eGtP?=
 =?utf-8?B?TWpiM2xtU0w1WndGM2ozRnA0T1JNTDgwMTE3N1pCLzg1RUJEL1hDZjFpa2Jm?=
 =?utf-8?B?NkRoSUI5cFJrMFlPWUk0WmF2R0xjUFNITStyL0hvb3pnaTNBSzRsOGhiamVZ?=
 =?utf-8?B?eUM0Z3ZyZzV4NUI4YUY2bWZsaFlCL2tpSXZpMHpESnhmUzlkaWh5b1RiM0V0?=
 =?utf-8?B?WE9DSXBwWkN0OTZVeDQ5aEJ5SUMxK2xVT0l3YXhERUF1TTRhcG80SEs4VUUz?=
 =?utf-8?B?MTNMTmcwU2hxVHUrbXNJUUxTeWJrSjdFVWlFVXRqV3NXUytlb0NjYk4weE5I?=
 =?utf-8?B?S1FySXM5VTVJdldZNVYzOXJycHIrSmhaNlhzaTNRY0grSEhHbTJ1MG9TT0Iv?=
 =?utf-8?B?VWYwcXplcTBUa1o2MWlIYmZZbmxQVkhaTVRPTDU0aktWaFNnM3FhREcySFhG?=
 =?utf-8?B?MTNCditSdFNHMytITEFEZmVuQ1YvcVJRRUs4VzhsWnlWSmZ5TzVLdFVWUHFy?=
 =?utf-8?B?WXFUdFJCUnNaMDVlWjdsR21HcVpWU3FlNWtyZFA1SmdvbG9sTXA5MXNYYzNx?=
 =?utf-8?B?REZOeHR1ZHpwZ09PSXI4eGVXbGVVTmlBMWJWTUdJSXBHQmJXblhyUkpKeEJi?=
 =?utf-8?B?dEkzVHIrbGp1NkRmM1FBSDlwV3FaSWlLMEFqMmhkTitoeXkwNm9YSU0yR2dm?=
 =?utf-8?B?MVVsR2RLV3hQaDFlZG5jbGp0cm9pVm14MEtMTmtrVTNIcDJBMjdqaGNPMXN4?=
 =?utf-8?B?ZTRrRXJFQUlhK1dRY3FiYU1SZkIzT0ZkSHBSNndvK0JGeXM2S3ZyY1RpRmc5?=
 =?utf-8?B?endSTFRvSTZYOG1SSW1jbHluaU5sMU8zMk4rbEtmbitZY3o3cC9qWmFpYWsv?=
 =?utf-8?B?VHZGRHgzS3AzNWsrcG5JTjVNT0ZPalBEdGQyREozb2Z0UExwOVFEZnl5cmZs?=
 =?utf-8?B?UVhNRnIrektTN3BQL0k2Q01YdGl1TlZ4ZmJ6SjBZUVFJZXNMVU84U1A4S1VV?=
 =?utf-8?B?Y2dNQ1JOZ0ZzRzVFcWRMc1lWNjlaVk50Z1FPS3RibEdrTlZYdzE2QnVvVmRu?=
 =?utf-8?B?ci9WZTM4ckEvRDFIbUVzZEVWSE9yUFdHZGZXZUJnYm9WTWhuUlNST01xU3BF?=
 =?utf-8?B?WFFPbjZLMk9aNzh3NlRqZXZtU0NLTThPS2REc1c3U0JwQkwwSDJHU2Y2cFVw?=
 =?utf-8?B?djlmakN4WE9oelM4TFpncTZqbnltNCtoWXNRUzlZNUh2emRkSkMzdFFLOUFV?=
 =?utf-8?B?ZkdVRFIyaG5GUHhQRWJoSlZBZDhGSUZpb255aFluYTJMYTN2NTZDL1lUeFd6?=
 =?utf-8?B?bmEyMUtBTXYrUDkrcmFFTFdxTHBDekw4eERlR1Nrd2lyeEN6dWxTNUZ0Ny9Y?=
 =?utf-8?B?cCsxTmNyT1R1UDVhemRVZUk3aUFvSTBZMjdUNDBtbVFXdFpvcGwvSjRKNnlz?=
 =?utf-8?B?empvM2grS1YzTy94VFNiRTNIOUpOUjZOelpvbDZ6MWs5NVNYNGdQVnhlZlow?=
 =?utf-8?B?a1JQcHhJRWczYjVpNUs1QW9LQlJTM2pHclZ3VStUR1oybTduT0VCRTNUaS9j?=
 =?utf-8?B?L2tncGR1TnVNM2wzdDFobTREbWxnSnJ3d29rbCtRN0tQQTZUakttQ1VtVkJz?=
 =?utf-8?B?UUlOWlkyb243VUtNTXVxQlFlZWROTGw1TTJaYzF2MDJpcGJQYlpyMDkzc01D?=
 =?utf-8?B?Q1gwZFRWWmNBRWVrb09rWGd4SURJN1dvczVla3dBQmNsRUNLTzkxYlZEWUlJ?=
 =?utf-8?B?OGlJeUFuclFnUkJJVmEzU2FDdXFwMGNQTWRybC9KK1B4NzJnRHhOU0ZDMkJi?=
 =?utf-8?Q?ELFHXT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmhUSVprSTJqdmdBZXpnM1hNU2cyQUkxcVJwanFvQXNPQmlBZG9VcTBBM3lE?=
 =?utf-8?B?RFE3NllBSzhwSU04NFd1d2RPTjNZQ25LMUlqWmJBRlc3azFJczFLbnlsY3hj?=
 =?utf-8?B?SktPK1lCcGtOOENIUVpUck44cEdZRzJCTDVvRndpNHhIK0pDVjdmUC95NnB4?=
 =?utf-8?B?ei9HbUZKa3d0aTlWZk9CWHptZDR6NUlpUDRJRWI2UmpsdnVtaU43UG5EdmtM?=
 =?utf-8?B?dHRjZEpoT242UnYwb0Nub1RtM1FNUVAza3U1eE4xZTNXRU1ocThJb3Y5YnhP?=
 =?utf-8?B?REpIV0ROOGc5YjVPcCtvQk9TSzViRWRLRXFRUG1hZTdDc2dTdk9Yd2RaZ1J2?=
 =?utf-8?B?VnRsMGhzZTZJTHkwYlRQdS9nZkc5QlQzZFpITnk4K29CdjEwT1BUOEhZVWhl?=
 =?utf-8?B?RkFOSjRFeExOOXdzZkZveVptOTdRWXkvWEw3TGF5YVNQQ2lCV08vNjloODQ5?=
 =?utf-8?B?SmFHWnY2TlVzSFN4a1hYaE1ac2hOTVRMdHMvaDIydTE5T1JFTWtGcTd2MUhV?=
 =?utf-8?B?MG9OSktYZ0gwK3lYK1pHWnB1MUI2NllXSGdGLzYwT3lmaWxPNlEyRHM1VWZN?=
 =?utf-8?B?TkVpVVBFZS82WEtyM0c3TmYrcEJDbFZwR1VVWFg4UHRpN3ZLdGdnUmgrdHRT?=
 =?utf-8?B?TXBHc2tYNkFxWGxRN3d5Z2N4WXI1ZjQrcGdCWUJ6cHBaOFBKMkVheFZhQWda?=
 =?utf-8?B?MmVva1VudlIvYjNJMHhKMGRvVHN6M0JnTmdhakxwWjhVaUtwWXJ3R3dOUzlp?=
 =?utf-8?B?SjBHWVhHcjF1VVpQcU42RlAzNVkxbGI2aWxPeUtvalhRL1ViYmJCU04zS2Z2?=
 =?utf-8?B?dGF6Q3ZnY0Z4MVgxSU03a05xK05kWUtrSEJGZzBrRGx3TnBFb3VqeWFnM0t3?=
 =?utf-8?B?c3RsUDhlNWFhSWhHRHpYOHRuWmlzUVJTNXhHUWdaaXJ5UjNGVnJWdU5yZXV6?=
 =?utf-8?B?aEdvNUJKQnk0d2RvcHpyNlh1Nyt3c25YUEhMMHk1L0xnajRrS00wMkJsQXFD?=
 =?utf-8?B?NEd5c3Q2M3laNFBGcnJhTkl6amk4bDV0R21VQ3oyUU9zSU0wM25EK1l1Z2Ra?=
 =?utf-8?B?RmpOTEk4c0ZESDZqQ0J2WThJVTFINDU0N0d4elhhZENqSk5ONEVKZEhzMG5Y?=
 =?utf-8?B?OUxucWN3ZjhCemhtMkVPMjA5TjVLNlk3bEdtWDQyenJXazM4T1hwd0lxSVdK?=
 =?utf-8?B?a3JZcHFhNktFSGtVSlYxcEx3S2I5RWROK0JDVFpDZGdsZ3JsQjNCR1VmWitU?=
 =?utf-8?B?NHJhN1FuY2s1YTl3VFpOc3d5eGxrVCticVNMUDZoZ1QraWlKbzE0UjBjZCtk?=
 =?utf-8?B?NVVtVUF1d2s1dnM4R0JxSjN2dncxS2ROMGFXVzg1WUVUd1hScVoxbThxdXdh?=
 =?utf-8?B?Z0ZDbWFpVDNBQ3RGRmFYbXJjM0RzY0UrbFRRaEtQSHR1MHN6WTFUMTk5T1hU?=
 =?utf-8?B?TjgyMWtWR29HNHRlb3J0U2VXU3ZLcXpJSk5kTExKYmZzb3JUK3dZYUFRejJP?=
 =?utf-8?B?TlVORnNFVXljWW94TVdoY2hXK0ZNWVd2Q2xBTU11UlhlTm5YQk1yLzhqTlYz?=
 =?utf-8?B?L0RPK09lSkZHZ2VSbXdsYkZRYm1sMkk4NUdoYVkrUDRLWmpkUnhpbVpVa3Jo?=
 =?utf-8?B?MjNVT2RpYjhLaXJ1MlZTYmtGQ0NmS3UvaTZhc1JDMVdWYWdMWHQvVTMySHZ3?=
 =?utf-8?B?ZUlnVzBEL0ovcjcrUXYzTVl2Ni9Ma1VKM1Bydkg4MFNWT0lOd0gxVXNRQ0FC?=
 =?utf-8?B?Y0V0N0FQUmcxbnRkS1FXOWJDcW1lRCtYNFNDQmZFZGxvMnNlekVTT0JxdlM2?=
 =?utf-8?B?RlBldUlHeTRsdGplc3I1eUwzMWRWZWpWcHh1REhRYVkxSDI2di9RRThRT0NS?=
 =?utf-8?B?K1VDWjNCZEFmUWR6cFpGdnBQT0VlK0ZPK2ZPdnAyQXVyNHNBT3RtQjAxeFM2?=
 =?utf-8?B?ZklxblB0OGhKNFAycjdvKzB6QlF2NTdzUUIwRzJQMjQ0QWJLTW1VWXNWd3o2?=
 =?utf-8?B?dGVqVzEvUU5uOEVUN09xWTU5a3Z4YitFdnhUTWx3VGhLR0tWRzRvbFYxeG9u?=
 =?utf-8?B?MkpyNmgrRDJibGlBOUpPUTViVU1obXBxWWlTN2cvVWxoYlpDVXdOc0tobWZ3?=
 =?utf-8?B?RGpmN0huRTljQmNlT0tUaUJCemFUN1dIUU1QRmdvaGRPb1lSb1YrbEo2dzRi?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1F73C2D61F04346A9B27C222622058B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0206b657-5502-450d-65b4-08de229c480e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 10:06:15.2242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLgVi6PNoHxeiRhfFR/AyzOq+H5OIsJy+Ec+FviKRuZ20QkmSn3MxN/VlHu88b1HvrKyAhj7LmDEycJRPICyVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6452

T24gV2VkLCAyMDI1LTExLTEyIGF0IDE3OjE4ICswODAwLCBCcmlhbiBLYW8gd3JvdGU6DQo+IFRo
aXMgbG9nIGFjdHVhbGx5IGlzIHRyaWdnZXJlZCBieSBmYXVsdCBpbmplY3Rpb24gd2hlbiB3bHVu
IGlzDQo+IHN1c3BlbmRlZA0KPiBlY2hvIDB4ZiA+IC9zeXMva2VybmVsL2RlYnVnL3Vmc2hjZC8z
YzJkMDAwMC51ZnMvc2F2ZWRfdWljX2Vycg0KPiANCj4gSW4gYSByZWFsLXdvcmxkIHNjZW5hcmlv
LCB0aGlzIHNpdHVhdGlvbiBjYW4gb2NjdXIgd2hlbiBhbiBlcnJvcg0KPiBpbnRlcnJ1cHQgY2Fs
bHMgYHVmc2hjZF9jaGVja19lcnJvcnMoKWAsIHdoaWNoIHNjaGVkdWxlcyB0aGUgZXJyb3INCj4g
aGFuZGxlciBiZWZvcmUgdGhlIHN5c3RlbSByZWFjaGVzIGB1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9k
ZSgpYC4NCg0KSGkgQnJpYW4sDQoNCldoZW4gdWZzaGNkX3N1c3BlbmQgaXMgY2FsbGVkLCBpdCBk
aXNhYmxlcyBJUlFzIGJ5IGNhbGxpbmcNCnVmc2hjZF9kaXNhYmxlX2lycS4gU28sIGluIGEgcmVh
bC13b3JsZCBzY2VuYXJpbywgaXQgc2hvdWxkDQpub3QgYmUgcG9zc2libGUgZm9yIHRoZSBVRlMg
dG8gYmUgc3VzcGVuZGVkIGFuZCB0aGUgZXJyb3INCmhhbmRsZXIgd29yayB0byBiZSB0cmlnZ2Vy
ZWQgYnkgYW4gSVJRLg0KDQpGYXVsdCBpbmplY3Rpb24gdXNpbmcgc2F2ZWRfdWljX2VyciBjb3Vs
ZCBjcmVhdGUgdGhpcyBzaXR1YXRpb24sDQpidXQgaWYgdGhpcyBjYW5ub3QgaGFwcGVuIGluIHJl
YWxpdHksIHdlIHNob3VsZCBjb25zaWRlciB3aGV0aGVyDQp0aGlzIGlzIGEgcmVhc29uYWJsZSB0
ZXN0IGNhc2U/IElmIGl0IGlzLCB0aGVuIEkgdGhpbmsgdGhpcyBwYXRjaA0KbG9va3MgZ29vZCB0
byBtZS4gSWYgbm90LCBtYXliZSB3ZSBzaG91bGQgZ2V0IHRoZSBydW50aW1lIFBNIHN0YXRlDQpp
biB0aGUgZmF1bHQgaW5qZWN0aW9uIGFuZCByZW1vdmUgdGhpcyByZWR1bmRhbnQgcmVjb3Zlcnkg
Y29kZS4NCldoYXQgZG8geW91IHRoaW5rPw0KDQpUaGFua3MNClBldGVyDQoNCg==
