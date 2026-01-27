Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F0A2D060C;
	Tue, 27 Jan 2026 02:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769479630; cv=fail; b=Z+EYJeNKM4KNwKFAQWh/KBeomb0x6l7DxMMO9gtvKkTF8YZ8mnMOYAfYMbKdiYOkILkH3UXGZYg5rbhmgOBovcuUfUjHFfo0i2jBM30x2UX/ndD0rxEfqArnFOtdePQXhZ0HaeOCnm6dzsmGaAhiP+9XIewo0NcXCRVwGu6bzDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769479630; c=relaxed/simple;
	bh=ZU89rq68Q8a4Cooue5jjYdx3V3h+d1hEJeZrqjw7UbQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s3V2ymNgBrY0kI9N84PsXuZhJOLRFCU+x+MDFOz76/9NYH7vNraIjDA2aUrsqEiSBTO21pxg1t6BtFs39rYuyZGdaJZuoGrmuLNpmn2FtQP4OLtiZJv/gg1jAGgE/CmXLnaw28Q+CSFKxgGrXkgkobrdEugkQU1MI+jIHp779OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YGj0RDrJ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=QhBXNMSb; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YGj0RDrJ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="QhBXNMSb"
X-UUID: d457fc24fb2411f0b7fc4fdb8733b2bc-20260127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZU89rq68Q8a4Cooue5jjYdx3V3h+d1hEJeZrqjw7UbQ=;
	b=YGj0RDrJFVe0vY/3ct6BkfB9aFRM2zzEUWhBZWbl3hRuSiDiTtzO/A7iuHSQ8Gdy9ttbbSw9uIsqMOiJ6h/re/LIy682LNHFBPkgoB7sT8z0X3yGGQnPG3mFv13rmGWF84uea2BrTrtNUXtpB0bsVitPdkB0/Z41s8bBTd5Q/C4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:c2639f91-1997-4361-ae33-34760f0c2c1a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:df27feef-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d457fc24fb2411f0b7fc4fdb8733b2bc-20260127
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1945040785; Tue, 27 Jan 2026 10:06:44 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 27 Jan 2026 10:06:43 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 27 Jan 2026 10:06:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AsyR1z+CKldgYKp/tkpcbaHs2qPZC8Ewfa8xRr8P1K22kYp3/lFX1tzdAC3ADDWIliwC2OLCNPuBB7A9SB3zVCwJSC+HBTR3XX11hBm59iCaZZhkYG7zvDY276Hy77s3SoG2D+dY4Unflk8tMONG7vUdZuZCorrh1IYj2USUggLE6+6bueP0XtMR7WqhiYud6HRflGBOMF/Qr6VKCcIK8i0A38K+kOrLfMe7YuM9lBsR8sOFuTJYoFvzLgnrDvXprup3/Bm3CGKZEGJa2IV15tGOdygo1RZfAK06+wVSxW4DiQnYKhUFpL4aVluLmmy9o7rK6gwHpAQNOXEVptP8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZU89rq68Q8a4Cooue5jjYdx3V3h+d1hEJeZrqjw7UbQ=;
 b=FJ3F/LVY1WrR0A6sy9I1eXxfDgpia7MIzNYkf8xjgt7ALagaVFBcKdcYicHHVXfEBkQQaSPKlka3ou1Nvfb/fAPNUhRw0Cs30ikddL9xhDnXwaO7/ua2XDuOys967EZGmdZ10vGf5rNJG6Igic1nMzTf0OEHIjbX3DWKDHM7MqtCRDzHFw4ebD3mulYP0FPf1nNiMqvnX4TLdopEBKzYpvSByne8/tbipqW4Mi7amhOjVm2948WU9fOwigbdBOsRdv598gwh9DgT8yz/Fp85qM5RWwpSwg9bhtUHWQDLdVHdTcc73zJ7Pyrm2naH03bW70PEyvw7nsrVQ5qu5zsIpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZU89rq68Q8a4Cooue5jjYdx3V3h+d1hEJeZrqjw7UbQ=;
 b=QhBXNMSb1jwwr8P4gM369M6+UOQsVXXEzKc5pclWFi5/cKM51xgtZ/1zEUes/OfvZ2IOAMAGxwCKa5JqVa3pZKrmtmfKqzBawcJHABUyYar9PoIhSnUNYRcoj+EKAkLfojdivvFlCrMK2PnJAbO1ckvcdurLAzCY3ivH9RiHu1E=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6714.apcprd03.prod.outlook.com (2603:1096:101:7e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 02:06:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 02:06:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "thomasyen@google.com" <thomasyen@google.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
Thread-Topic: [PATCH v2 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
Thread-Index: AQHcjywmzQnR3LRde0Soz964PNc8nbVlRMkA
Date: Tue, 27 Jan 2026 02:06:37 +0000
Message-ID: <4cb7b0c51d81f8e9959b0c50f12f1ca1416885a7.camel@mediatek.com>
References: <20260127012700.3311649-1-thomasyen@google.com>
In-Reply-To: <20260127012700.3311649-1-thomasyen@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6714:EE_
x-ms-office365-filtering-correlation-id: 065bc92f-bdad-46a8-9698-08de5d48b425
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MW54MmFMazJOUitzMkhRK0V4OUxpcCtKRHJKN1poaXBXUnlpNHJJMXJHL3lV?=
 =?utf-8?B?Nlg0SUVqMDVMNGR4ODNCdFdtN05BbmtSa2s0N3R5RXpwTUlzNFc4Z3Q4MURp?=
 =?utf-8?B?YURjRWI0MjFEdnMveGxYZEEyWUtnV01PRnlXRkQ1dGJCTm9JdDR0MmxJUHdG?=
 =?utf-8?B?MGtuK2s5MjNkblJJOTBlNUkyUXdJNFdyWWMvRjFxTW9OQ0JtVEJDWjRRSFND?=
 =?utf-8?B?RUp5NjJFa1l2VXJmcytkV1dzVkh6c1RPcWZzb3N5dXVhZTZtSHVtQkxwMm8y?=
 =?utf-8?B?RDRNdTVmaGlyZ2oxZFU2QzREYk5YbmlBanNIRU1BbHN3dDhBQVozazM5MVh3?=
 =?utf-8?B?dTc3d2xTMVd5dzI4Z1BZdWJOUytxcmNkVE9vL1I4emtaQTVRWUVVVzhtSjli?=
 =?utf-8?B?TnBzbFNrcjZFdklqYS9xWW91bDJwd3dHd2JQcGZhWmlMM2g0MmNPQ0RFVXI2?=
 =?utf-8?B?YmsrRis4NUgwSHcxeGNuSUZsSTZRYmdBbldjbUl0Njd2TFoxT1VZQWFiTks0?=
 =?utf-8?B?WXB1dVRzNDlWRldCdUtUMkR0QmY5c0hoRjNzTDBWci96MUJJRlZRSkJXK25H?=
 =?utf-8?B?cnJ4U3BHZERIaVNVNWNaRjRpU1d6SGloUllXSmdVZTRONDhTN2xpblBVWGZ5?=
 =?utf-8?B?V2VQV0thU2tOalEraU1GUlZXZXFFRnJ5bythQUtOQjR1Nytrd3M4dWs0cVRZ?=
 =?utf-8?B?SlJRSndZcEJMUWlvb2pXUGhNdHhVN3VmVWVvMVdmYWNYeXNtZkMvV1VyQ2Rh?=
 =?utf-8?B?TnRSNkFET2xUL0EyVWFVclUxNDJvZ1pDYmJsRmVzTkpWZFRac3B6b0xoWkFo?=
 =?utf-8?B?aVk3VlJRemlqdjdTWnhRZ2xZaHVGNFpveG1DYTNtL3F6S3RwdllBYjVWQ3VQ?=
 =?utf-8?B?amlLQ2dsckZxdUhVNXFuZjB1UGxOZStRTGZpU3BldThnL3FzNTlTNHJGV3Bi?=
 =?utf-8?B?Vjc5ZFFCRU94bXRZRktJQkNXZ0dia2VEZjdNU1gvUDF2ejFtZ1dGSmFyNUlD?=
 =?utf-8?B?bW1XNW1wdDZOQlhlU25xcXhGOWxoU2swNHBxT0doc1pWdDhCY0VpQ0hCaVJM?=
 =?utf-8?B?Z0ZTK05FSkdkVmJoVFZnQkVsZjRzRDRNcDFzOG80VzVpSHhuQ2NiTWVXb2hp?=
 =?utf-8?B?RmVTaTRIV05YWlNoaGJFQ2t4UzJ4QkpQRjNuZnR5MDJHeElNTnNzYmErLzRq?=
 =?utf-8?B?ZFNoWVFtWVZhKzRWbjI4VjljaUoxbklCSDIyVjZlN3pQelRkMlhxbE90SWJJ?=
 =?utf-8?B?RE51KzdvK1dOeFpVSk9nMTdTcnRwSjBwUDA3RVdVdE1VaWdyNkF0bGZZT0xH?=
 =?utf-8?B?REJjbGxWS3IyYjVUVTZVb1liWnVUeWJLTkhsWkNmRnhaWmwwZ0swdnZUeFRG?=
 =?utf-8?B?VG5oMDVFMDBJQW9Udk83L1oxeEhDbVd3Ri9YODdxVHBzSFljVEpMWWVnMi9o?=
 =?utf-8?B?MDVwVE5LQmxET25aUU1sZUNvYVpxMzhXK3Z5TUhPQmJHYUR3SHVtWm8rKzQy?=
 =?utf-8?B?TjA2OW90MUp6Wjc3a1JsaXpuOW11Wmk2RlNvVk5XYmRpT0ZVWjMyNHNmZVZk?=
 =?utf-8?B?ZWpEWkFSSU0rMTVqVzlZNkZ2Z2lGNzRYZTVMR2NQQkZadzVuZzBzZlQ1Qjl2?=
 =?utf-8?B?YnlhMytKUjJzeGFRQTl2d1ZucGpEckozOE9LbzFPY0oydnQyN1F6aExxMkRu?=
 =?utf-8?B?bnQ0aUt2YWYyekFGY09VcCt0cmQ1akc0S1lCT0k3QUk3OUZxRVJzSUtTWlBp?=
 =?utf-8?B?YUxIRGxhaCtZMkQzem8vSEJzZlBLMjRoK2lXd3RKR0M3NlVSZ2hnN3kveDhU?=
 =?utf-8?B?L2F0UnZOR3pkMWNMdjBBMUcwc2hWemxIWmE3NkJrOWZYZ29ZSkgzYXd0djFx?=
 =?utf-8?B?amVsNCt3U2FiUXhob3FTdjVNWkJIWG04WS9ERURhZnc2RjZ5Y0NsQTgyK1Mw?=
 =?utf-8?B?NVdtZnMySGQxNzhieDJjU3Y2Njk3WDBuQlg3ZnhldVlHaXRoMTRvK01IejRR?=
 =?utf-8?B?Mmg2YWYwdW1SWmFBYmJySDl6S29DeXVXT3hveVlsN21kd0x2aDhWZVNYa1lD?=
 =?utf-8?B?aGF5QnFZdUNmSlJGSVJiL1pudXZQL3NkU3BGaERYMVU2MXVrOEs5RUc1THNw?=
 =?utf-8?B?K25SLzRKTnZwVHNKeUliOHU0Ni9qMjBxdDljSkc4QzVJWHBwdzlFaVZsMlB5?=
 =?utf-8?Q?V4is89NrXRfSpJo8YWnQ+IQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1RvUUhEVlFVTnhjMWIybTZlb2x0UDdmbTljbk43ekgrTnRrY0FsRUgvU3hr?=
 =?utf-8?B?a0UvYXhySmU5d1dwcWxKZnRvV2JMTUg0TVFuOXBXSlk4Y3p2NzRmZ0MwZUd1?=
 =?utf-8?B?MDN4bXBxeTRVQ0dBWDY3OHloYmZhRnltVDkyclpNNTdyRG5aTDVGS0gzNldV?=
 =?utf-8?B?MWEyWlBXY05WcUxOeFllbm5Da2EvcHBjVzE1NzFrb3NtNVJOOEk4dlI2djFt?=
 =?utf-8?B?RVl6S25pa2o3cURkQ2Z5aXdPTGhFQ3VSREl3Qi9GY0xkU0ZpbFA2UVBrWUlx?=
 =?utf-8?B?ajNobWV1bEVZMThQeHR1RkhVcFFrblBvRGd0elBOV0g5SzBLVWd6WTV1VkNP?=
 =?utf-8?B?bi9IelhaRTFMUmh4NU9kUG5nUE9IWDlqblBmeVMvOWxlQXpDT05tUGljUS9z?=
 =?utf-8?B?NzR3TXl4bnJZbzcwU2JjUCtab3dybEJ0Yk85RzdkYVd0VThGUUhVRzZKY0JJ?=
 =?utf-8?B?d3VDc0VvRzJWVzA3dUhSUU9EUWJ1aitlRXd5TG9FRC9kVHVXdGU0c21sZTFj?=
 =?utf-8?B?MVNLbGtxR1JHMjM1aE9JemJlSTlFSjY4VzkwZHBmVUZlWlVHNjF4anBiZmNq?=
 =?utf-8?B?QXllcEhoRmFadG5tbEwvR29zd2NZYnBpemIyakxta0k2Si9kamNZNEU4cTRy?=
 =?utf-8?B?TFJpZnpJSk9KbjBYQUdkMkx3RHdTM3lhU1pBNWlWblgwbTNBbHAzdW55NEdj?=
 =?utf-8?B?UzJ6NlFwaU9GMUJKQkFCUVQ1ZS9EZ2Q4bEJlelFjTS94WHM0VUhpVHFmaGpZ?=
 =?utf-8?B?NDhrS0Yxc3NBOXQwTUJQazZjcEhESmZwVDZzd081WXVEbVNqeCttVnBGR0FL?=
 =?utf-8?B?SHhOcUNDY2g5bXhOYk9ia1BIWjRpbVc4RUpub0taVHRnNTlqYWFKcnR5Q0xG?=
 =?utf-8?B?dThHeGt4bGJhTUhkTytBakMvL3EzTi9xSFlpajVNb3E2b0FGRXBZRVNrVWhn?=
 =?utf-8?B?Q2luRlFJaWNZMWcyZXRDd3UzZEVQQ1JVSzZaRFVzVE5jM3ZwSmIyY2swaHM1?=
 =?utf-8?B?VDExUmtMdGlTQjFiYU00ZUd1UmF5ODY4ZWcvQm9DTjRuamhoTW1zVEI2Zjgx?=
 =?utf-8?B?TFUvb2k5aTArQ2tPdGhKcXhLYXAwZUx2b2dtRTlmY2cyUndGZ0FRUDd2dnBu?=
 =?utf-8?B?SGttaVZPWVZoMjhBUFl2Y0JuZGJYaDR2NVRFK1lMK1E1RlBBeWRSZzdzTWZW?=
 =?utf-8?B?b21OdmpRQkJZaVlBbmxpTVBQcGFYZDBlbjQ2QThJVENvMEp3SlFpQjZqZG5L?=
 =?utf-8?B?d05JMFRqRmFBN25yNUN4NnM3U0REa21hR3k0STkzYVc5c1B5QlBxS0dvWSt6?=
 =?utf-8?B?bk8rUzBIYk02Rzk0a1IyN0J6b2h3Y3YvR3cxQVZNb1JpVFd1NFFlV1d4ZXVU?=
 =?utf-8?B?a0lDZmZhOXRxRmZjdHpOWVZwUnUxMGIxSUhWYS92Rm52Z01QcGlUaTN5QXRx?=
 =?utf-8?B?NnduWCtta1Jrc3h6bE9nWEtVQW1sRFlrY3pkanlXY25KUmlodmNEbkJZNmdE?=
 =?utf-8?B?KzRLcW5WVzNxcEl4YXFyTFJ0TDJmOUJtb2NLbjJmd1NBWW5GejhhdTJPSjZD?=
 =?utf-8?B?d0lQTnhhSFp1V2thb2JkdXYyZmRlRkZBeE1IN0txbjJxZ0hCOE9IM2xNSjRt?=
 =?utf-8?B?ek9Gd21vSTQrRGhNeGdyNzllTzhIK29Bdm5CTjZ5SVpLY0UzMjZyMW9EWU5S?=
 =?utf-8?B?R0lWaW1FSjM3alpHOERJZVNuWnlhY1pncW9ETC9IR2I1N2UwU1ZJSVBUcGw3?=
 =?utf-8?B?bFBKd29rYXhHZmtuK3BQdzdvdUM2MmhqVEdQTWhGRi9hWWx3YmZMazkwR0FT?=
 =?utf-8?B?eHcwSVE5bTJwN3lrSHRaaHlTUjhwclJhcE5FYUdiOXZpaDMyRllWU3hsSGFn?=
 =?utf-8?B?N0Jvcm94YS9tWU55eG00K24xY1JjOTdqWHdzWGdYNzd0YnN5d2lwemVEMS9B?=
 =?utf-8?B?OGx2VHk1bzQwT2N0YnZ3cGhBcGlkVjVYOFJWODlmRTJqTFNjdjVFemVlc3I3?=
 =?utf-8?B?blJCL3VvaVU4UmZHMWFvL3J4VytmMXRSOHl5ZWNPMFgxYjQ3Y2NNdjBuVm5G?=
 =?utf-8?B?bStmbkMyNGxKa2syNnNmUHRFM05vL01VWm8xZXBNRTh6N2p1MWZMUTgyWmRY?=
 =?utf-8?B?Vm90dEpLK1IySkJpKzZVM3NiODFVaXVvc1lSakt5Tk5CWXlsSTJxZkRDY2Vy?=
 =?utf-8?B?Mjc3cU54UUtlenZadzhxQlo3LzMybFpydG4rc2hGVWRPUUJaOC9IMXVzNnhF?=
 =?utf-8?B?Z1lTSmJoeUhlWTduei83SW1EcXZzMlhBSGF6TnhGL0JFR1dRb0tCc1F0VG5R?=
 =?utf-8?B?Sm5WcmdocGxnOXYwVHM0aS9tMC9PK095ejYzRStRUHpFSUFCM0pOYjhEZEta?=
 =?utf-8?Q?IlnU8yGgMWgqzm1g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51E6965279812740A332037A15FA5062@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065bc92f-bdad-46a8-9698-08de5d48b425
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 02:06:37.4452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HJoZjcYrcTQ8CSRgIxLimnPMDUkne8uPv1c7abvV0U2EqjX5SRnhEweyqiH6m3iQq9A5PLWMqL/ihHuuXPxaHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6714
X-MTK: N

T24gVHVlLCAyMDI2LTAxLTI3IGF0IDA5OjI2ICswODAwLCBUaG9tYXMgWWVuIHdyb3RlOg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMNCj4gaW5kZXggMDM2OTA0M2NhMDEwLi4zYTBlNmM5YmE4NmEgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiBAQCAtOTk5Nyw2ICs5OTk3LDcgQEAgc3RhdGljIGludCBfX3Vmc2hjZF93bF9z
dXNwZW5kKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiDC
oA0KPiDCoAlpZiAocmVxX2Rldl9wd3JfbW9kZSA9PSBVRlNfQUNUSVZFX1BXUl9NT0RFICYmDQo+
IMKgCQkJcmVxX2xpbmtfc3RhdGUgPT0gVUlDX0xJTktfQUNUSVZFX1NUQVRFKSB7DQo+ICsJCWZs
dXNoX3dvcmsoJmhiYS0+ZWVoX3dvcmspOw0KPiANCg0KSGkgVGhvbWFzLA0KDQpTaG91bGQgZGlz
YWJsZSBhdXRvIGJrb3AgYmVmb3JlIGZsdXNoIGVlIHdyb2tlcj8NCk9yIHRoZSBldmVjcHRpb24g
Y291bGQgc3RpbGwgaGFwZWVuIGFmdGVyIGZsdXNoPw0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg==
