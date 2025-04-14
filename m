Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530A719E806;
	Mon, 14 Apr 2025 03:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744602659; cv=fail; b=DzRUGjdYobvZbyMOK7rkk+YU/9JEJLcJyQU/MJBHASZiOcqmFUdUb00ZM0izSezcJUVFcYIbmc8V0yBnh992Qiul+IoxG00/O/cRJXB++HXwXPoiU2i39pA7fFZ9b575fHe70dYZsLBYchDMkvNS0GcaRoGWS/3h6btDYFFp3U0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744602659; c=relaxed/simple;
	bh=0bQjT26/eKF4Cgv3zfjDERd0PSZl0wLbPD147jhcAmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FtmEa7JhZpXDtN+EYFqofxoFJgAFtaxmxc75VTpPLfkxfkLHtXzqPNUp2ynTN81B8B1v4uPTLDsONsg3mPfE05OcWwE4Na/rFnwKqIUz4YxS2a0qRHJC5YWLPIJZ9inRazkYkBZkb9ZIYQHrn/2JQlracn622CQFEWSm4VNVNNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=quuJkljo; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Xrg0r0yF; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="quuJkljo";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Xrg0r0yF"
X-UUID: a90c3dc418e311f0aae1fd9735fae912-20250414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=0bQjT26/eKF4Cgv3zfjDERd0PSZl0wLbPD147jhcAmA=;
	b=quuJkljomfHudrHn+LYmJ9YZNP2bHT+Nd8oE6rPjKasw4ZhMiyKOKDDCAIse6zTR195gExavBR0SwhhawKgswzZGv5OmBnCHj2ngvb5lknn94KEoK5ds3kfMwjONax/pteZWh2pZvi7ak9ut2aT2wZlZ8MWuuGDZoqHDMfX3pj0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:01b34a74-2fea-49c2-a759-7d93b2284bd1,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:ab8809a6-c619-47e3-a41b-90eedbf5b947,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: a90c3dc418e311f0aae1fd9735fae912-20250414
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 505803816; Mon, 14 Apr 2025 11:50:52 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 14 Apr 2025 11:50:50 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 14 Apr 2025 11:50:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/xVZLsh8UUp7Gw5AqBbt68/kKTTNsbzPOs0mMYYYDIAur/hq0Zdg9naka3qEpj74Do1jct/E9KG259YB60g+mV11TqZ8SLzWgQksiRWYk9Er2/tqX/YqjPzzcXPAOgLyjWsudi3BNKne161judkHaa9QNdweCIAr3H3jEU17XFGM6UMcK5E3q2Z0D/YRVfYAXt4lf+l4zk6QNMVwBGT5GJzrKO9p7ajEyrqRqVbJUd1XtbzsxW1gmbjY2/ZBxWgUc+c8oOAi4hH2y2p30quauAS2eiZjE5veZAoKrgSr3jVL8fal76PB6J+gH89kHUSpSGhXjcGdiM43jyV5n9mgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bQjT26/eKF4Cgv3zfjDERd0PSZl0wLbPD147jhcAmA=;
 b=vxo0c2uP13AkRHgzL58CXRvs9K8bnAUW3ehDwqYGbbq1uqdKC9KAsAPPu88D2wtUkNa3pNqWBgksIK7l8lOaX9KVLc7A+BAp4nGIyCzHY3hiXeL9FHks36l0Uj57+hkhF/2mv2g8Z3L4umizRsMO5aClo988FVwSbZHzGgx2QN1rucNNowxszMkDUPzqG0Z2UL6/nfRaX+OSZ+C6NcKv1LhnfLQVyPF9sDkBx9C5kDsivPkHh+cxDSgsvWH76EtkzUJzZ18e6o+87pHdCrGzGMZsF8399IHp6vsLoI3VoJxklQcdA1RkkwHLVb1r13QK8nBOJJMvk1V642xqVdEgFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bQjT26/eKF4Cgv3zfjDERd0PSZl0wLbPD147jhcAmA=;
 b=Xrg0r0yF9U8CDMScKQ2vC5oFBG+ST4HkebGQFTA/JYgnCYXWzv1FOJrGbX25J5Zrk8Q/bLR/XMlfQIoNDEDWKxcJynfNL3RVa+h46V3p5mbAsBalx6xxz4rIM4hcdmGdJ72RhpbPLUHa93r+4Q3Pu6iaObKBzXXGNqbSc3QM7Uk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYUPR03MB7208.apcprd03.prod.outlook.com (2603:1096:400:353::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Mon, 14 Apr
 2025 03:50:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 03:50:48 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?=
	<stanley.chu@mediatek.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Add NULL check in
 ufshcd_mcq_compl_pending_transfer()
Thread-Topic: [PATCH] scsi: ufs: core: Add NULL check in
 ufshcd_mcq_compl_pending_transfer()
Thread-Index: AQHbq+VoIlQQP7DYvEKQTxBzQgJh3LOiiQSA
Date: Mon, 14 Apr 2025 03:50:47 +0000
Message-ID: <4c9069cc0c2ae802232df861abc31d322922b521.camel@mediatek.com>
References: <20250412195909.315418-1-chenyuan0y@gmail.com>
In-Reply-To: <20250412195909.315418-1-chenyuan0y@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYUPR03MB7208:EE_
x-ms-office365-filtering-correlation-id: d02495ef-22fc-4742-bc1d-08dd7b078ace
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Rk42NFJSVzdjMW9yeXdoWk5VOFF2NHMrSW1TbWxqSmQzdlNSRndESUxzekNq?=
 =?utf-8?B?dTRiR2ZlbUhVVHoyZWhMMWxVdE1mK3gwdlZpMmJJUVZsaFE4OFFxY25ER1VH?=
 =?utf-8?B?dExXVVVuSlpUN01PaFJtM1A5RllSWlU1aGx6RXhhOGVyenJqd0ZzZWVkQmlr?=
 =?utf-8?B?TWx6Qm9aN1hVeHl4akNnZHE2L3gyR1lMbWE0SU0rVDdjME1xNHFsLy9sRCs0?=
 =?utf-8?B?b3pBMVRHVlJrRkorUmhkV1JYQmpaRHN4QnpQU1A5ZzkrUlpzRTBWUndMRG96?=
 =?utf-8?B?NldNajJleFJBR2FrYjE2V1FpK01wWlFrdk9BUU8xaEF4UTVrLzQyU1NHenNI?=
 =?utf-8?B?NzQ5VWc2MzdtTUZLQUlhdklPeGltMGZvRzJxeWdMRmxJb1ZVdit0MUV4eVh0?=
 =?utf-8?B?QXp4OTB6bUQxU0Vic3VBTU5kT1VJQzk2ODFYVkFlaWtKUUZaRWNtWXRVZXJn?=
 =?utf-8?B?eGUxMmpZY3JHM1J5em5QMXEyU3RJU2w3cEx1S1d3dHc5cVhPSHViZWxLSkNU?=
 =?utf-8?B?MHp1c2NWUUo4VEZ5YXp3elFsY3dNUjBnR1JzQ2tlV09XU2VrVjdqc2twOFBH?=
 =?utf-8?B?LzVpUndQZUZVclpHTFRxdXFkNWk0U1Zaejc0ZEprT2pEMXJXZzk5aFFqYjBR?=
 =?utf-8?B?ZXNvV2xOTVNIcnN3SnBwSkk3b0VMNnFtcWJLbnNLWHJ5Yk95dndqOXoyS1pH?=
 =?utf-8?B?YXVMelBKdXU1OHU1TXBuelZFeDJxcWI2ZGdXdFc2Qjc2UDE2cGNtMnNZeUVr?=
 =?utf-8?B?bHpZUnFyZ25LeTVhUkw1OFo0OHVtTGxHSzJNWVJDcWwwNy9CdHNrd0NlRjVH?=
 =?utf-8?B?WDlYVTF5NTI3Nk5XSzVvNVZOdDU3aHZVYW16N3R0ZEFjb2tSVDJ5cUxPOFhR?=
 =?utf-8?B?Vy90akkrTGJ6blNCVXFlZ1NRUTFXWCsrR2VGbTIzU2VDYXdpdjFxM1k1dmFq?=
 =?utf-8?B?cmI0YVNFODhzK09ranRCMWx0dkNFTjRoUzFKU1NYWDJpSWlkUmdONVhsWCtx?=
 =?utf-8?B?K1J3SWt4eDVJdFZ0NFhUbWhSYjg1VU5TUm9yRjJPSWZ4Q2F0ejVTVzM5dkRW?=
 =?utf-8?B?dm5tOExHeThVT0hDNkd0aHhzTXY0ZEZRNktyY200a1FqOXlyQnJjM1dYc0dQ?=
 =?utf-8?B?NmNHZ2NWb1BFdFFLTnpmMkFJUlR1dXEwUjcwWVpOVElveFhTcUllYlN2ZTZj?=
 =?utf-8?B?VklEd0FRdFlXbVlmOHVHYytlYnBpVjJOcytBMW1YYzlzNDNsVjNKckFCWUM3?=
 =?utf-8?B?c2xKQTA2aXM1UlZQM3dxWmtnSHl5d0piTmE3OFZFZVdUck1OTzlTTFhBeE9R?=
 =?utf-8?B?YjVSSUJOdmxQKzZNaWZHb1R1VXdjWE9iRzVlOGRva3U5QU1pMHN1M0tKNXdV?=
 =?utf-8?B?NzFxMzdkYXIzKzJNTGhhSXl3cmwyRFlmWXdtUWpEY2FlMWViRG1HS0NRbmQ1?=
 =?utf-8?B?SkNFTHBDVUZpUitYcmRGcU12MmVKVjhkdWJBcUJjR0EyeGcrSGJaWnV3aUJi?=
 =?utf-8?B?cTBMQ1BSTkhDK2VNTjVBdmJCZFJ0RjRlOTRWNU9rOXQyYnFiRVJablRjRWgw?=
 =?utf-8?B?czA3NmliTElQbTBMQ1VGYXZiQ2FTMFBvQmc5UjFQOWROVnhlSmtZNURRYmg5?=
 =?utf-8?B?SDlWTUFWNzRSMGtubnRpVjJDT1pOdHJEcHMvc0JIWXZDTVRxanVlNGhlOFQw?=
 =?utf-8?B?VlA3WHZ3SUM2TjNoZlB1Nk5zSTBrR3BLUEhWeEhib0VpbWVzOFoyOTBMTlRn?=
 =?utf-8?B?MEhCaUw5OTE3akR2c3hKRk96L3dhRWxIc2dMWEhYNlpmRk9NdEpWL2dzMWFa?=
 =?utf-8?B?RjJrTnY4aDlVNGl1ek15a3FSVktVM1dFaUd0bk9sNWNXUDNDRjk0azRubWZ3?=
 =?utf-8?B?SndTOUphQkhxMU1pTlU2SDRMV1RMZHlNTW4wUGU3a0ZVaXFsLzM4SzM5VjJX?=
 =?utf-8?B?akhDbWlpV1R4YlZNN2lROG1kRS9BMVN6dVk1VG5yTjVCOEE1NUtVTGpPN0Fz?=
 =?utf-8?Q?U8xr5CPh4CQzPW6QPwWOrRwMU2XZqU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUpMSFRQNWJ3ZVFKekpreTBiZnN0anYrZXg5NTE2R2xJMXJjUFNWY05haTVL?=
 =?utf-8?B?YU9YZlBFRldvSVUzNmQyWDJ1MXVJUWQ0dDZjeWhjanhVRkNlQkpjUXh2T3V3?=
 =?utf-8?B?RmFKY09YdThlK1FIQ2RwU2xZMkNiZUZIRTduVGhic2FRRFlSL1Vjakk0RFZw?=
 =?utf-8?B?U3VKYlM4UHRIdDJUdzN0QXFwSDV6UmJaREtISkpxQ3o0SHJJaGRoaVFVQ1lk?=
 =?utf-8?B?ZnpPR2ZFa0RkVk9WRmJGQkZCTzAwL0RvY1JNNUlWYTV3R0ZBWjh2MGlXMm01?=
 =?utf-8?B?a3lCSnprTGZ4d2FuQ2JMNC9SYXdxSVZCMDF3eWNDRzR2RWxQeHkva3lJVk5v?=
 =?utf-8?B?V0R0UC9tOXVvY3JycDZsTWxPTHhyQTZCL1ZiQVFaSHdFWDMrRitKT0pNb21T?=
 =?utf-8?B?OXB3WUoyM0UxYjdUWERhcEJLZlhKN0NHWFdsYTVTUk1RU3RtV1pQQlNyZ2J2?=
 =?utf-8?B?ZGx4ZzFSY3ovNDdsZnRqODVLVSttY3dick1VUFhwRWhVZHcyd3cycHRtTEg4?=
 =?utf-8?B?akhpbldxeXVQVklURkZxK2NHQ3JDSll3dmUvWnpwZWw4Y3VPMkJqUXFpeXJO?=
 =?utf-8?B?cmNGSHFUUXVFbGZROExIb1NqTmhnMGFmK0oycVpHbmxRdmR5OVF4cEVEQUdh?=
 =?utf-8?B?UktPbVlzWC8zbkpLWTlkOENrc2xHK0l1dXRraURqa0RWUjBxS0dkaVludnFn?=
 =?utf-8?B?UXIrblRwdnkwYUp1ZGl2NGY2VGNmam5FVmRySU54WWN3NVN6bXJXMklRV3Mr?=
 =?utf-8?B?RmNSVjhoc01hb2Q0OXdwUEFBUk05QVBNYndEYlFHbEFINTczMG90RWtHeXVV?=
 =?utf-8?B?RjEwUER4czdqd29YYjRRSEhITGYzbmx3S3lhMzlXUnQ0d1F5OFhxaG8zSmRR?=
 =?utf-8?B?RFRWUlVXemZzM2lnQVoydDRsOTUvc3NGVVZlTU5rMy9zSUE4NFF2M1FPSi90?=
 =?utf-8?B?TVRRNkxNdGJCUmZPb0hmc2g0aTVQNjE3OWljZnBWMG1GN0lCUGJscGJjYVp2?=
 =?utf-8?B?NUdYUi85OXpPcnJLN3ZLcXZWQlRTNjlaUTFtQ3VPYWNtZ0VuWVdscGZmN2p2?=
 =?utf-8?B?eUpkejNvazMyb0NvWEpDOTIrSmUxSVg0NUloN0FlTHVkcUYrWndzenNwTVo5?=
 =?utf-8?B?bWg3VytmeWJ4ZS94cXRXQ3Y1dVFNZGp5Q1RWZmhJZ2RwVDB3R0Vkak5ub0VU?=
 =?utf-8?B?RW14ZitDV0R3UjVmdjFENE45cU5OUzRUNHN2RldsT0oxL3M0aWxndmZPZ0JV?=
 =?utf-8?B?bW1ma3VSb3lobU4xb0t0QTFiWjErUzVEOHhzbnJXVDM5VzgzMmZ3QVVTZ082?=
 =?utf-8?B?ckVEWkcwdG1Ec0hibnl1R3BaVWtBUUliM0w3alNZTms1clZ1dHBLbjZXRGhJ?=
 =?utf-8?B?OFNIUWE3NUl3eTk2eEJUNDhYUVdrWDR2eVZRZHk5UWtUdTNGemppNlZ2dlhB?=
 =?utf-8?B?UlE1NXhyWE9XbHdMUzR3dE4zNFBwazJySk93WnYycDNkbWY3VTE1Q3VHS21k?=
 =?utf-8?B?ViswSW5jbTJ2VjVSVjlFTFdSYkZ0aTZmbGp4OU1sWGxpdDJmZjdXc1VqNC8w?=
 =?utf-8?B?MWNXME5PRkFITXZpTm5QTnZpYk45YlYzUHlRN24zbzlUWUEzczE3YWFzT2VQ?=
 =?utf-8?B?MldUOG10bmdVaDBrblYxZzhlK0pjcFNmU0I3V3Rrd3lPZ21BdWt3bmp1cjFz?=
 =?utf-8?B?SUV6WnNtL01uUC9nT3BLUkdGd0kyU0xWZnA5VStYZE5URlRyb3R0TWVKUkxQ?=
 =?utf-8?B?MjV6cUd3dHBrbWJaSy9ONWZ2UktqcVViT0tOVDVpYjQwclRUVm9JZnFMa09X?=
 =?utf-8?B?eVhSTmtsaHFJVGZpZGZhcngwLzZXbWsrenpQaStNdEg1Y055Ti8xdnRZZzM3?=
 =?utf-8?B?TzNqd3VKdTBNSGFvNGJNMmlVSWZRL3A4VFIxcTlpZmtFZmQrR1FCVVVjVEFY?=
 =?utf-8?B?cU1XNEhqcUxxVDVLbjk3b3E5dC9haFFKTXNPL2VWYUZ1UzVZNnNmWVFkMC9I?=
 =?utf-8?B?T3B2ajl1QStEL2lLOU8ya3dvcmNXZ1VhdTBab3dyY09ydmFLNHV3MkZzMW5F?=
 =?utf-8?B?dUNRZkVmZWtaNDNQUmxpRmN5ZzBjR1BKdmVDbENvT1dLK1B4NTk2bDdHcno4?=
 =?utf-8?B?QkR4aGk4d3Q0NjAxNFROT2hDenI1NENweU1zRFpMVm9PWkIxSWVsMzhBbHYz?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CA4C7EFF0AF6641B417EA77030633A1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02495ef-22fc-4742-bc1d-08dd7b078ace
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 03:50:47.9754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z5IjdIYALCD25BR3BhZfe/i3O3tNib+dn+DLcnrxiCcSoX3LFtXGnpka3Yo2tK9U3ovbWHhlmKP7kDLt+5X5RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7208

T24gU2F0LCAyMDI1LTA0LTEyIGF0IDE0OjU5IC0wNTAwLCBDaGVueXVhbiBZYW5nIHdyb3RlOgo+
IAo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVudGlsCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0aGUgY29u
dGVudC4KPiAKPiAKPiBBZGQgYSBOVUxMIGNoZWNrIGZvciB0aGUgcmV0dXJuZWQgaHdxIHBvaW50
ZXIgYnkKPiB1ZnNoY2RfbWNxX3JlcV90b19od3EoKS4KPiAKPiBUaGlzIGlzIHNpbWlsYXIgdG8g
dGhlIGZpeCBpbiBjb21taXQgNzQ3MzYxMDNmYjQxCj4gKCJzY3NpOiB1ZnM6IGNvcmU6IEZpeCB1
ZnNoY2RfYWJvcnRfb25lIHJhY2luZyBpc3N1ZSIpLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENoZW55
dWFuIFlhbmcgPGNoZW55dWFuMHlAZ21haWwuY29tPgo+IEZpeGVzOiBhYjI0ODY0M2QzZDYgKCJz
Y3NpOiB1ZnM6IGNvcmU6IEFkZCBlcnJvciBoYW5kbGluZyBmb3IgTUNRCj4gbW9kZSIpCj4gLS0t
Cj4gwqBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgMiArKwo+IMKgMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hj
ZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+IGluZGV4IDA1MzQzOTBjMmEzNS4uZmQz
OWUxMGMyMDQzIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiArKysg
Yi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jCj4gQEAgLTU2OTIsNiArNTY5Miw4IEBAIHN0YXRp
YyB2b2lkCj4gdWZzaGNkX21jcV9jb21wbF9wZW5kaW5nX3RyYW5zZmVyKHN0cnVjdCB1ZnNfaGJh
ICpoYmEsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBj
b250aW51ZTsKPiAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaHdxID0gdWZzaGNk
X21jcV9yZXFfdG9faHdxKGhiYSwKPiBzY3NpX2NtZF90b19ycShjbWQpKTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIWh3cSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4gCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGlmIChmb3JjZV9jb21wbCkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgdWZzaGNkX21jcV9jb21wbF9hbGxfY3Flc19sb2NrKGhiYSwg
aHdxKTsKPiAtLQo+IDIuMzQuMQo+IAoKUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndh
bmdAbWVkaWF0ZWsuY29tPgoK
