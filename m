Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EA91C07D9;
	Tue, 20 May 2025 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746897; cv=fail; b=Vq4/h385FF4X6HB3jJNNYDJgNebmVbF+UIgV9HczgoqaTwBpC6UAtBLsVDp0H3S3NHn6MMmDGIe+iYSFDteSl8c6t1eZ9q7u7hJ4kW1N58nJDnxeibBpt9Y8U+Y9WGoJG7xcz7UBR2z5Nxnt7o8Pt+07cOH3c7J2j/XZwQv0YzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746897; c=relaxed/simple;
	bh=cEH2Xrg8vCz4Ae2Ixp/t/hah5DAHfv7kwDCF+H5Tw1g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=odLpWfFc7mHcxnX44CeQ7iesMgqdU6YubPjVCBpuOCcyLpNfOhmSZ4h06L575+D+eUwPn7aDkPf4DWEvpEGFo+dWW720InRxC9BYpAkJJ/B78JzTht9klUocQbBAoSt5rufsTZOSI/tzUwyj9AiDPqkaaXH2+ypipP+mTlpbTxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=E83ARnWs; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=a2tDqUk4; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="E83ARnWs";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="a2tDqUk4"
X-UUID: 64510e2a357c11f082f7f7ac98dee637-20250520
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=cEH2Xrg8vCz4Ae2Ixp/t/hah5DAHfv7kwDCF+H5Tw1g=;
	b=E83ARnWs4VcfJpcy1qUyxy2LdNe1aYh91EcWe93TVHHw1EoF3Mnh9yZWrAdDbP/WamZMdiY3fBsIzp/tL9jzckAUGEV0WuCkQk4AdB2glirJnOVUjTSebaFoS28We2K37SaaJN1a3ykW/iuLzqfgTjtIdfGCA70NJJxNxH76TVI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:0afb1ab6-54e9-483f-b561-bcf5a53c6ae6,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:3d473b0b-116e-44e6-89b4-c2ab29149e30,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 64510e2a357c11f082f7f7ac98dee637-20250520
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1961878669; Tue, 20 May 2025 21:14:42 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 20 May 2025 21:14:40 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 20 May 2025 21:14:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YIWGC/pLI/sy1SkrfWpzFNtfZjt+IZTa6REtz8PZtqdLs0ErQUNdwbW2XaPkMeXtN/ArXrPFTEMv7/5bkuuI/QDKBizsW/tJMwnoVQk87ZriKzoe1DZttM5i0Kx7KhOfoMsb/c9xq4zt3/JVfmqLwXRICjqevDRD40Ammjc5m3P/SIuF3l4XhTnIORYOWqpL/wC85E31refH0Y+e9dCLunDlBTJsvKDXyehaU1WwH5/9gi6uPeTqQ6V5w1B3gGyO7xOxMg3z7GMqoa12cHB8l1mYSI38JBHXExfMk8XDaycl1d1/NouttaNNTNrVxYzHxfB5zAGr8W2hjuLgpTg/Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEH2Xrg8vCz4Ae2Ixp/t/hah5DAHfv7kwDCF+H5Tw1g=;
 b=EvIcIqZEDV1mCRlutxC7hPO7Fj09ug+rtstyFmF3L01STV9r5m9fCRliZvhwvR16qX8LWYr75AI79n14/co/+2rly+D3XMxECtL/bM6I3A0VSykPTVdYyOuP9sjKEP5sx1s6Hmr3C8lVQqKkqAouK1F+08WF6beKSUXSj2gvS0o1S90WZLOqlvV84BEoGYvCTbmjjxY0KgYAem2bIvhEAIz98oxXzMnwi5qBAD+0vc7hw+xVnV9udffGHEfLD7t/VdfKNXrL2T1HKvjW9lhamcUduIzOM+gYDZDBKyQ0s76V9cU+Otse/bknJRhBmNjccKlDGwNf/HdPopHxuLSjRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEH2Xrg8vCz4Ae2Ixp/t/hah5DAHfv7kwDCF+H5Tw1g=;
 b=a2tDqUk4uvY8PNyvNgz4F0DshqozLSSoQHiozSxw4IiZ393vR6+XQhO4PtJEZIPwGAvDkVcDTO/JiE8FXRcFRxVE4VUz6J1XR8hnUyuoLHjZYs13hJnPgTRFRu1LJd5TSoiQtxrBfQ4E9H72NLlZjRQHtWiNDLk9Tu7FPFTzMUQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6593.apcprd03.prod.outlook.com (2603:1096:101:75::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 13:14:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 13:14:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"tanghuan@vivo.com" <tanghuan@vivo.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "luhongfei@vivo.com" <luhongfei@vivo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>,
	"wenxing.cheng@vivo.com" <wenxing.cheng@vivo.com>
Subject: Re: [PATCH v5] ufs: core: Add HID support
Thread-Topic: [PATCH v5] ufs: core: Add HID support
Thread-Index: AQHbyWthn7PGWIdsckicQEY+2V08FbPbf26A
Date: Tue, 20 May 2025 13:14:37 +0000
Message-ID: <ab468bb26dafca673d7ffca7dff519b7cf024cdc.camel@mediatek.com>
References: <20250520094054.313-1-tanghuan@vivo.com>
In-Reply-To: <20250520094054.313-1-tanghuan@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6593:EE_
x-ms-office365-filtering-correlation-id: 1d365adf-b692-419a-acd9-08dd97a045df
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bXVWT2hmVEFRaytHSXhCUm9naGprVGQ3VGgvR1RXQ3ZxNzY5bS9CbHc0VFNu?=
 =?utf-8?B?OE5ocWJzL1R6aExSbWZCb0t0WVB5ejA3MzhxY1hvWlFkQi9hYjdVNncwUWsw?=
 =?utf-8?B?eEcybmZQT0NZZWR6RWlaaG9YYXh5L2UvNFVwbTBtMWl1OUdBWDN1ZTB4VmRJ?=
 =?utf-8?B?cVIvWVdvVEt3ZDEwaUpudDFpMWowc2FOYjVnNDRvNnQrWVpiQlZuK256WkNj?=
 =?utf-8?B?dGdYS2tMMWphWHdJSmZDS21YYkhvREJERzlWb1l6MVJhejhRNUZPamRiczFv?=
 =?utf-8?B?MUZmWkFldjZuZ05QaGhLSTZ4N0liZnhEaFRqcFBOUS9raHlDbnRGc3pRL0JQ?=
 =?utf-8?B?MDYvOTJJYzlTT09NNk9tbWVzd1ZwUTg3aUFZVUpWNUhpZCtPQUdZUWtjSFpu?=
 =?utf-8?B?Zk9lUGV6T2NrTzBxTGVMaXM1MW9oOVJiZnlMU0FmRTVnTVh1ZlN1MWpNdkcv?=
 =?utf-8?B?SXJEK3V6Mmk1ckRrd3BKVzlFV3U1bkdURkxnR3RaT3hDMUNCV1kvbEtnRWNJ?=
 =?utf-8?B?b0U1VzBkcHRzamVzUEg4ZkQzZWM0NHluaHN4Tk5aMXNjeThNdmY2MGppUjF4?=
 =?utf-8?B?Y3BCVVVUTUIvSnVqR2ticmRUK1p0UXZMT0gvb3B3a0FSNzYzeEFrRVZVMkIv?=
 =?utf-8?B?Sm80ZE5xMVJDWm5aZWNvNmZCd1hxZlRaTkM5cGhSNUdEemxjbCttL2pmR2RE?=
 =?utf-8?B?dUNKeUJMbHZOZFN0VzZLTFpEWll1cHM3SllzVXVmbEtZdkFoTW5HS0NiQmND?=
 =?utf-8?B?cnZsYXVyV3hnK2lTYzVWOTcwT3orNVRUb2FNUHk1M0hQanQ3UFJwcGZuRnJ2?=
 =?utf-8?B?YXNuM3FxeFpHMmF6MVp5Y0x2emRoQVRyZk5LUmE1MzRrdFNEN1pid0VJdk4r?=
 =?utf-8?B?My9wRFN2bEVuYzZUL3RCVlJ6OGdCeEg3UkN0L1F6d3pJZWNZeEVKYnhXcnNu?=
 =?utf-8?B?VU9qV1lDZU40Z0hTeHkxTzY1NWo0L3pnNnpkakl4WnNsbk5qQUlKM053Yk5B?=
 =?utf-8?B?Y1poSXRuek5QNkN1MWRENjNUb3g1L0xaTXgwWENlZ1ZjWjBtNlFYRWNicHNl?=
 =?utf-8?B?MTdOVS92R3JhVHUyN2t2OVo0SUhXclpqdnFWaEkyUCsrSEtXMTAzVXpOeUV6?=
 =?utf-8?B?QWs0S2RDcHFWSUx1WmErQXlvTmtEMGRYTndXMWsvSmp2NlRuVC9VVS8xZUpL?=
 =?utf-8?B?d1krc0tpVEdweXdMUXZvM0gwRHhKMy8xT2sxL1QzRnQwWmFySnpGS09rN2c2?=
 =?utf-8?B?dTIrZEVVUzBFZEdpekc4TGl6YWNPWXFBTWhRY0RLTU4rK3VmcWZpNzZNaSs0?=
 =?utf-8?B?bHU5dGw3ZEJ5dTR5VDhTbXc5bmhkQUthS3hFc0pFd1h6SzNVdnVLR2M0akFW?=
 =?utf-8?B?TXBXZVlGeUl4M1pCTGJxcHllR09KdUtHdEtUODRiWXVKcUtmaVpEeUtteGsr?=
 =?utf-8?B?YnRUQnVWeTR0YWxYZmJHMVRvTXEvQ28rTStjM3lLUFJldDlmakcwS1E5UXZa?=
 =?utf-8?B?WTByWi91T0sxR2tpbzlwdmtBOTF2V2hvTjRiWEFkWXVJNGlUSUNuNFdQNXNk?=
 =?utf-8?B?Zyt2N29TemlKUTJ5VWdNOHNoQnVBem84TGM4Z0VZZWpPenJVTG1yaTNYZ09l?=
 =?utf-8?B?L3lJOHZVUlFIdUJVd1JFUjdlYWkwZ2o2VFJlRmZUUUpycUxzWnNHQzh5RFFs?=
 =?utf-8?B?Uk1oRHNkbDZJQm9OUGJxUXJtaEhJdHhYamdKbjcvUW5YVUxXRFlPc2pZYXVV?=
 =?utf-8?B?bXBJY1VOalJSVEEraEFjZDk4NlM5R3NjQ0ErMlNEaXQrZ09OK0IxYjd1VEcr?=
 =?utf-8?B?bkRhTlNyVVdJSys5UXlkL3Z6UW8wT2hycVI1WTUzVFBHNU4vOFNkaWpQRTV3?=
 =?utf-8?B?UWphc09iUWNsQzBST1FtaHVTVytOd1V1SFpSZ3pXdE42Qm1uandLNGVCZ2hv?=
 =?utf-8?B?OU81T3Q5Q1ZEd21yMDMxL2paU0JTaUlBSGNkL0FHSHRaWlZPeW1aVFQvcW42?=
 =?utf-8?Q?vvUnyJmUBj/3P8vKbU8A9Fo78eE+Ww=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEtPTndQNWc2a3JWeGtWNEZLODhJQkVUYzlGSlprdTBlM0xpdi9yaU4ybEd5?=
 =?utf-8?B?bnBqV3hJMThNNy9HMjdqT3p2aDF1NVBUVEYzbHFsTFV0dmNKdXA3TEdaRy9R?=
 =?utf-8?B?TGhuc1VwOHdBV1FiWDBtME9CblRjNTF3WURaaTdXRTd5WjlrQ3pMMzNyTjRq?=
 =?utf-8?B?TDVuK2FWWWpnY2Q0TnRiWHhMQXVEYTlaMWg5QVoyOVNVNUVzL2dUUllEZmpD?=
 =?utf-8?B?UUZGdWNRSFVReUdxOHVlK3FHbDBzRHdXUjUzODU3UFR1YXZnKzdKMStlN0Q0?=
 =?utf-8?B?di9nSWRuSnNoazJjbytlRDBWLzVENnNwdk9BRWQxam9sYlhaU1pMZFdZSG5s?=
 =?utf-8?B?ejNyTzdCK0Z0UldlNnROTVBMTHR0OTA5V0ZFTGhycDJjWWpTUm03VHpWd0ha?=
 =?utf-8?B?b3hZbmYvamo2cStWVFBuSXprQXFOWW55S2RVRTdyWENhWDVmMjZYWVpmQlI0?=
 =?utf-8?B?VGlWdUpURDRnNDZFMElqTFMyQ0xKN2h2UEFoTHBENFVMTGlmQmNUakJSMFls?=
 =?utf-8?B?bzJvOFY0WXAxV2RJQ0doYmhGazRVbXVFdGpZcjdtdk45aW4wRE1jN1RmSlUw?=
 =?utf-8?B?ejFaeEs2SGhjZzdYQWpoNitlYWpCYVlwU200QU4xN0doL3lkNEIzVE9rMEpY?=
 =?utf-8?B?WmgrQnZiRVNTS0RYdm15azRtVk5VWXhzV3NHZVJGYWhZaGo4QVBzbTZjSUh4?=
 =?utf-8?B?MkVFemV3ajJ0cmFmaEdFT2lEbDNiQXNIU3owVXhzWXFVWmlTdE5hTUttcy9X?=
 =?utf-8?B?RnZLekx1ZmNtNkxvT21kSUdRRU1GTUtSQWJMSFFkeVp1cVRsZWdLbnY2dnJF?=
 =?utf-8?B?SXNsNUdyS3czL2FqS3N6NXgzb3RqNVhySndCbVJDRGxUQ0dtUWQzaXFtM1ZR?=
 =?utf-8?B?d2FOZnFVQVZ5bFdqNTR4R1JYbTJXK3U3cTFidjNXK1VZRmdRWkwzNzNXREEv?=
 =?utf-8?B?YTdvOW42aFVjQkc2T0FQOU5lRndVRFgyLzY1eEdMRHNjMG9hdVp1dDVIemhM?=
 =?utf-8?B?NzlLVGZ3WDBvYUtYKzViWTVpTlBqc1NUcmdWRmJhRVBzZDlsUVRvcTNtS0hG?=
 =?utf-8?B?cGUzTkxONWRaeGFTOGNYUWp0VG9CN29KSnRlZ2N4UmZwN1FlMmx6L1ZSYzdi?=
 =?utf-8?B?R0hFUk5TL1E5S1JUSzFEeTFkb05lcU0wNUd4djVZVlltdCs2L1RsL1dzb3Zo?=
 =?utf-8?B?RnNkTlUrZjRmYmxBV0V6ZURSN2tWSGV0VUZORVFrMG9uWVRlSUlaSWNKS2gw?=
 =?utf-8?B?RDhnZ1JXMmRUVDhBSVJyKzl4bFRDaHJ1UjgwMjZDKzRMTGIvcC9Fb0t3RDhr?=
 =?utf-8?B?Z0pGNWxpczJEd0J1SnArQmc0UCtxQnhhTVg5Qk1EbjRlV245N3Z5QmlTVVM3?=
 =?utf-8?B?elZCUWV6aEdoNHZMazVIdFZBbC9JTEs2SzlEZ2VUOXF5cWQyaUZ6L09PTSt4?=
 =?utf-8?B?ZU52Mmxwa0NhVVR4UUQySEFvQU5YMkM2Ui9neGVuNFBDZkZQK1ZNbVBpR2FV?=
 =?utf-8?B?N3FscStJZVpNc2ZIdVlrRjR3ejJ4MURSa1lvS2FiVHY4Q1BCQzVGTEJFRjc2?=
 =?utf-8?B?b1NFcGx5MHFzdlJtaEk3ei9qOG5mM2ZYYk9XNlBIOVBSbVU4M1VPYkkvVVJR?=
 =?utf-8?B?ZTZ5NUVnbXVzTjdtV2RFWTRIekkyN01IZ2RxMGJZYUx4WEtkSHFPc2dyK3FC?=
 =?utf-8?B?VXR3VmQ3OUpHYVhZb0tCcU50M0pyaGZkZENEbW94UEdCV3cyOE03S0tQalph?=
 =?utf-8?B?aVA0MkNmUUw3L1JCSEtwUERiSHcyZGsxL1h3ME4xQ3lJdGJ4Uk1RRXhPTnl3?=
 =?utf-8?B?LzJuTmtpRngyNC9HaE5QNUE4NThwa2dxRjZNaXoxS1JMZnZwUmN4RGZvY0lP?=
 =?utf-8?B?U1BMSXBXL05SWVRBbXppaHZEL21JV0ZEQVZ1OWdScDBtclZRMHZFWkFGSjcr?=
 =?utf-8?B?SEJYckVnTFlxUnpVbjVVRHlFbzNmdnlEbVZ5T3ozU21NbHFkVjVPL2VqcmpO?=
 =?utf-8?B?RlU5dU1HQnk2TWVmSytVM1VRcS92bHVqT0VGY1hqNk92MkJSekJPN1dSOU85?=
 =?utf-8?B?am9WVDJOMGxqa1Nvd3RNYnh6cEwzZXFJVGhjdFdvTGdMRjgxQVkzNndUYXJX?=
 =?utf-8?B?bUFReERaMjZJbTdXRkRSSEFCaGZJNTNaWkdZcHIvakpNSFdINEhPTWlqRG5r?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD690D1BC2C018448DAABDC145DEB6CF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d365adf-b692-419a-acd9-08dd97a045df
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 13:14:37.8826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nyqtHhbm6qMif9geSqCWSORDdCfLO3iQ+16DSuCtVREk04L3WuWYtkuy6cnL7T3r7GGnoTQnoeBgLEIjPmZa2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6593

T24gVHVlLCAyMDI1LTA1LTIwIGF0IDE3OjQwICswODAwLCBIdWFuIFRhbmcgd3JvdGU6DQo+IA0K
PiArc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdCBoaWRfdHJpZ2dlcl9tb2RlW10gPSB7ImRpc2Fi
bGUiLA0KPiAiZW5hYmxlIn07DQo+ICsNCj4gK3N0YXRpYyBzc2l6ZV90IGFuYWx5c2lzX3RyaWdn
ZXJfc3RvcmUoc3RydWN0IGRldmljZSAqZGV2LA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY29uc3QgY2hhciAqYnVmLA0KPiBz
aXplX3QgY291bnQpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqAgc3RydWN0IHVmc19oYmEgKmhiYSA9
IGRldl9nZXRfZHJ2ZGF0YShkZXYpOw0KPiArwqDCoMKgwqDCoMKgIGludCBtb2RlOw0KPiArwqDC
oMKgwqDCoMKgIGludCByZXQ7DQo+ICsNCj4gK8KgwqDCoMKgwqDCoCBtb2RlID0gc3lzZnNfbWF0
Y2hfc3RyaW5nKGhpZF90cmlnZ2VyX21vZGUsIGJ1Zik7DQo+ICvCoMKgwqDCoMKgwqAgaWYgKG1v
ZGUgPCAwKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsN
Cj4gDQoNCkhpIEhhdW4sDQoNCkNvbnNpZGVyIHVzZSBiZWxvdyBjb2Rpbmcgc3R5bGUgZm9yIHJl
YWRhYmlsaXR5Lg0KDQppZiAoc3lzZnNfc3RyZXEoYnVmLCAiZW5hYmxlIikpDQogICAgbW9kZSA9
IC4uLjsNCmVsc2UgaWYgKHN5c2ZzX3N0cmVxKGJ1ZiwgImRpc2FibGUiKSkNCiAgICBtb2RlID0g
Li4uOw0KZWxzZQ0KICAgIHJldHVybiAtRUlOVkFMOw0KDQoNCg0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+
IGluZGV4IDNlMjA5N2U2NTk2NC4uOGNjZDkyM2E1NzYxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4g
QEAgLTgzOTAsNiArODM5MCwxMCBAQCBzdGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3Ry
dWN0IHVmc19oYmENCj4gKmhiYSkNCj4gDQo+IMKgwqDCoMKgwqDCoMKgIGRldl9pbmZvLT5ydHRf
Y2FwID0gZGVzY19idWZbREVWSUNFX0RFU0NfUEFSQU1fUlRUX0NBUF07DQo+IA0KPiArwqDCoMKg
wqDCoMKgIGRldl9pbmZvLT5oaWRfc3VwID0gZ2V0X3VuYWxpZ25lZF9iZTMyKGRlc2NfYnVmICsN
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoA0KPiBERVZJQ0VfREVTQ19QQVJBTV9FWFRfVUZTX0ZFQVRVUkVfU1VQKSAmDQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgVUZTX0RFVl9ISURfU1VQUE9SVDsNCj4gKw0KPiANCg0KQ291bGQgYWRkIHRoZSBkb3VibGUg
bmVnYXRpb24gKCEhKSBlbnN1cmVzIHRoZSB2YWx1ZSBpcyBleGFjdGx5IDAgb3IgMS4NCmRldl9p
bmZvLT5oaWRfc3VwID0gISEoZ2V0X3VuYWxpZ25lZF9iZTMyKGRlc2NfYnVmICsNCiAgICAgICAg
ICAgIERFVklDRV9ERVNDX1BBUkFNX0VYVF9VRlNfRkVBVFVSRV9TVVApICYNCiAgICAgICAgICAg
IFVGU19ERVZfSElEX1NVUFBPUlQpOw0KDQpUaGUgcmVzdCBvZiB0aGUgcGFydHMgbG9va3MgZ29v
ZCB0byBtZS4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tPg0KDQoNClRoYW5rcw0KUGV0ZXINCg==
