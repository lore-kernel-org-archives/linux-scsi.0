Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D7A2E3701;
	Tue, 22 Jul 2025 03:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154398; cv=fail; b=d++1q+ylsRy3VOUGheD21nwrsuIBfi/PDz1fGIA0JoyPA8r4WvNSXconptIEkntgyRDHcgWjgiRvHRnWBdNHVv6UxioZVFAnghWR7EuM1mpg97D96cgeCmNL5llVciyDOPMGfRI8qoKNfRBfirXBKRc/8PtOI4jnVYI0KndBUR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154398; c=relaxed/simple;
	bh=4NNQ6b3KaClmMJzgwLwCKWC+Fz/jicgnsBDGLV7g6Cc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NhRGy9PlQlFNFQYdR9m/4PJxBfxTJQPch+S8Dx/mLyIm5SuQC4bmiWt28pQymnir6GReWwpIktqiNx4F4UpEiMt06mcxYnbLhfmFyyzAcPnQ2eGtGcBuwNMqnr3M9lNRBGCML5/CSoIbcAwJql14tSYQDmPB3Pe6MeOOAbhNzdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=HW03bXJO; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=rXbkXLba; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HW03bXJO";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="rXbkXLba"
X-UUID: bb11bc6e66aa11f0b33aeb1e7f16c2b6-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=4NNQ6b3KaClmMJzgwLwCKWC+Fz/jicgnsBDGLV7g6Cc=;
	b=HW03bXJOjnGRvQ99z2NWWOhgx4t3SG7MP/xa1PUhBhC2V2Z6L2ZvtlOhpI/FVXfGzrEjXQaev9t/dNmxjPLddLD9Hs3cd8/TW20aztBZ+RCu6xws/GcxE9Fo337CjALs2ZwQbFgusW+q9MtIvL6+wO71PQzxdjpusc0oKaWedZg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:164b154b-f153-4288-966b-9e5a2f7a99ad,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:01ee1b50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bb11bc6e66aa11f0b33aeb1e7f16c2b6-20250722
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 862898432; Tue, 22 Jul 2025 11:19:51 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 11:19:49 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 11:19:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWPbsrfSglPxGQviT5zEZQWtox8ScdJASW/FH3oW13f69BaglAcH09f6HPpviGSVTIRrNLKnM/l68r+qXK/nLkdcJTC4SP23CsIxPszBlBI9RzKQ8jMxl7yITv9kyHe0WxDrxUhwEG/8kHHi6WvTWRTZpOoP+SF2wuolCeuEFeQzp2lvEhXfVCnyAsjCxgMqPUcCcpz1JwjTvavAOlRGZPpOFrl0cPOWtv7IjJZa6ND3/OM/ESHOvrQyV4a2qR9osdl/nRbIigqp6PZHDYyim/YqvOlO144y0wXIu6Uym87iDQbuUYjRCEfXek05KORYqZs8HCzdFEzdP3+rjenRVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NNQ6b3KaClmMJzgwLwCKWC+Fz/jicgnsBDGLV7g6Cc=;
 b=PaFTmGGiLywtsKkhak+5DJzVCW6kHja9am2xY+Xzp7TqiCcpHa7JsGoPPVcsJNFesLkO9op27vrvPTRPygImkYK5LV/UPGT3y8Qvtucazx4bNLbYZg5RYBfRGxhld0iwluadsTYNHzIfj4UWWarWkMOv1EwZI6Go8P48WmXBcb70bETddN75opc7UwwmEWSUwGQcsCgYC5ZudCjB1+6XzWlBcYfJ53HclgnoU6SrppwbVaziGEoAUirKOY3BtFtZS8POhbYlgIlRo7jqMUsxurF4+agfkkeAupcV5U53xCtRXk7ie9yxjNAeMP+I1vlylxhrwmOArhnDcQujRVVN6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NNQ6b3KaClmMJzgwLwCKWC+Fz/jicgnsBDGLV7g6Cc=;
 b=rXbkXLbaylg+vH/JVvYcqk7Yh0bHEEzObhj9b7720PbBJ+TSPy8kKpPsV0Y8qZWqmtQDfGr5umqpdd9o1PCtZry2p4vmsuzi4+X2iHz946er9UuNsyiYldYQzOOp5TwPSkX+0TzZWeD0TCEUH76pVBTNscNqJw+fog/JsNeiqyI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7972.apcprd03.prod.outlook.com (2603:1096:820:f9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 03:19:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 03:19:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "liu.xuemei1@zte.com.cn" <liu.xuemei1@zte.com.cn>,
	"james.bottomley@hansenpartnership.com"
	<james.bottomley@hansenpartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "huobean@gmail.com" <huobean@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"liu.song13@zte.com.cn" <liu.song13@zte.com.cn>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Use str_true_false() helper in
 UFS_FLAG()
Thread-Topic: [PATCH] scsi: ufs: core: Use str_true_false() helper in
 UFS_FLAG()
Thread-Index: AQHb+jdL70EiS2cKG0W1TdjPfNXb+7Q9eoKA
Date: Tue, 22 Jul 2025 03:19:46 +0000
Message-ID: <9142732493135960a169183f801cdabe25bc9638.camel@mediatek.com>
References: <20250721200138431dOU9KyajGyGi5339ma26p@zte.com.cn>
In-Reply-To: <20250721200138431dOU9KyajGyGi5339ma26p@zte.com.cn>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7972:EE_
x-ms-office365-filtering-correlation-id: 2063fd33-d1c4-4bdd-7cca-08ddc8ce9c03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0lveE5XaTJ1MHp5VkRoNWN1a1BaOHA4ZnlyL2NTT3JibjRLZ1ZjSmd5ZElS?=
 =?utf-8?B?S2RFVzZHaEtaS2VSY21KN3dCdzVGM2NBeXY2NWdnT3pQOEw4R1M3MXlBeVJL?=
 =?utf-8?B?OVVhSEU2TWhBZlNmSDRpK3JHOGpLMzhsUG5ISWlXMTl5UFg1Zng5NE1RY2t5?=
 =?utf-8?B?Q1N4OE52YkxJL1B4dENOZjI5RUxtNTZqOXNKdHB1WVBQOEZwZGpCQ01DYUlD?=
 =?utf-8?B?Uko5eHl6WmNKWDlVT2JkT09wbE55OGJvZ0VodDdCb1h3TG1HaFFQVnVFbXE4?=
 =?utf-8?B?S0lqNTM0MSs5STJuVEJSeTByOGhPa3NWUmlLLzlHaHFaTVZYeE5lNWNCNkpr?=
 =?utf-8?B?ZEJ3MGhUbGdMTmZRcnpZcUQ3UDhnbVpzVTFDQWsrOXhNVkpYc1pGa3Vyendk?=
 =?utf-8?B?NzBkeFlFaWxWVVpJeW1DMit2VjdKeXpZUEJEY1hzN1lNZkJLSnBmZGc3d3I1?=
 =?utf-8?B?MmU4RjczMlY3aXBMTk1wTmhyaHFNQ2pMWk82RTJpNEhjUldKemJCTXVXN1hz?=
 =?utf-8?B?NWowajBZeG9iWUJZdGU2RFZIZDNtS1VUVWplazJ4OTk1dmhyZmZNeThLN00z?=
 =?utf-8?B?MUlIMmc4aDd4UGxBU2hpU2ZLU1FPZnk1RkkxNGJUQVFiT3hDZWZJMDA0RSs0?=
 =?utf-8?B?LzhmZG5adXd2RGNwekF6K2tvMkdwSTl5UndyYVRKZFZLdWFYWUJQUVYveklJ?=
 =?utf-8?B?OFJNUG5IMzRNZnViazVTT2dyRk14K2pXcG1YbVAwcW0wVjFybVBxREFJdkNj?=
 =?utf-8?B?T3drQW4zL09oVG1PZm1vNzk2YzBkUDUzQzNFYXlrd2dvQWlrMnZUbnljaHVz?=
 =?utf-8?B?UktCd0d6cGxFNkFBUnd4bWlLOWkyVVpkMGRyZXYyYVVBTDl4UHVjN3Y5dkN6?=
 =?utf-8?B?UTdVU2xOMngxQXlKNzBqN2NqbWZoMzY5Z3ppVVFTbzRKa3Y5MllYOVVUWmxL?=
 =?utf-8?B?SzJnYlVlSUV0NzZ6Z1NqdmZodU9LdE5QQ09rTEpqVzZPM0ZMZG1IRHhuUW5j?=
 =?utf-8?B?K3owa1BhZkZRR1VaWVRhK3hTbDVDaHltSG5SK1g1UTIwVGhkcjVVR2ZGZzNv?=
 =?utf-8?B?bC9qNFFlYldoYUI1VE5ZNGtJeUtHL0lpY0c3SjZMVWFOczl4alZjTDVvdGhj?=
 =?utf-8?B?bDE0MzkwdUhvRzc1RHd1UmszWm5yRjErci9pT0RBSUpMUnZQT0doeWN2MThk?=
 =?utf-8?B?MTJISkJzVlN2dGZUOHJORE9iRDNrcHRoNCt3VHhSaG1sbFhzSG9TYU5mRE4x?=
 =?utf-8?B?SCtvMEttNnlRdkM0ZENJTDYySUdmYk5kbUNDNGgzQ2hwZktmdUZCaDZBa1J6?=
 =?utf-8?B?YjdRb1NtMExKSko1citjeXo3M3Bya3p0cmNFUzlrN0l2NnVkVHpBakJrOFdC?=
 =?utf-8?B?UnhzeHhDblR2eEdRN055WVlPL2gyeDZ3N29TU1IrRndpMGEvL1RJZVd2STRO?=
 =?utf-8?B?U3BGY25uOWFNcnZJbFdIRUJhNE4xRWpxeW1oK3JMSmxZQ01PY3YvcTBuZ0Ru?=
 =?utf-8?B?N2pFVFlOWnFFTlMvSndtcXF3b2lPZmMyZE5ITFFFTG5udGxSUTFFNUtyZElt?=
 =?utf-8?B?OXZqUjBCaHBBY2RYZVFUNnlCUXpyNnVZZmtuRHk4dmxVejBVZmFKWnYwenhW?=
 =?utf-8?B?eTQrbXZrQzJuY1lKN2lHVmVEZ0pudkpmYXFVcEJDOC9IV3JMQUcvNmVJUHcx?=
 =?utf-8?B?Y1BFb0dhaGRnQTMwaDBwODdEaDhaTncvSVNpOTJwL0V2WnRDL3RlckZYYnVv?=
 =?utf-8?B?ejRYWTNPcXpuUXVEZWtWekNjU3dSR0tYdVArNmY3UXZrWHVnMSt4ZUxDSXdw?=
 =?utf-8?B?ZkhZdzhlbXJ0NHBDTGoveE92dTZGSHJ2V1FSMmU3bnpqSEJPdy8xeE0yenpY?=
 =?utf-8?B?MlYrNzJMbkxQLzg0SkYzU1grZzdwandIUmRUZGxxQSt6QkxyekwxbERuNHJ2?=
 =?utf-8?B?RHc4N203YzdvY1ZsNzlvZmwrQ29LVW1hL20zMTdFdUlSeDlNU1M0Wms5VFBQ?=
 =?utf-8?B?aTN6Y2R0UjlBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzFBeGpOZVB5UDRYdWRreGRMaHIyYXhDWWlRTUNmbHJqZFd6MklBSFhuMlpV?=
 =?utf-8?B?ZGttNjBVS0Q2R3hSU0hNSDhqVFA1cVFUYmVHajJReFA0d3Ztb2lqNjYwZE9C?=
 =?utf-8?B?OFIrUEZhMy9EZ1BMQ2hTdFFZZ0xFYVNDem9DSmpCbnNZTkcvaEo2Zll4SEJM?=
 =?utf-8?B?cWx6LzZiZWdtVHBJZWVWQzFXUjdBZ3FINDhmaFc2V0ZPdVlMTUZNcUFhWW1q?=
 =?utf-8?B?UVg0UWRFdVRLSDhscE5WZXlnOXoyNTkrdi9LeEdSTHVRUjllMUZYWkQ4cGhm?=
 =?utf-8?B?aVcvUmVxR3VWVFcwZStlRi9MQkI1NDVVNWVSUHMvV1RqbzFvWDhJQjh0Ynp3?=
 =?utf-8?B?Ri9TY1UvQVZSWmdMZ29IbU5tTzdjNGRhS0wwbXdzdHBwWWhncGpPM0pqcHlr?=
 =?utf-8?B?TzFiaGU5cmh5ZjNJK0N3NkFSaGFab3hDK1NwTVo5SmppSGtyOGxETG1IYkd4?=
 =?utf-8?B?dHVhWG0xT2gyKzVOUytUbkJBd2d0SDQwbENzYnZQTVBPRHFiTjVsMnQ5Uy9J?=
 =?utf-8?B?ZVlKcEFoeTNqMXVoVUs2ZGJMSEIrTXNrODJPWHJhTGgvb01EcFdHNzdudWFz?=
 =?utf-8?B?ZDY2c2dTc201UWVIcUYvR2VOUE9Pbk45SWtDRm9NQkpBNWtDMXlOYmN3dWZq?=
 =?utf-8?B?YXpzR3ZJZ2VmUkdmTkFqQVpGSjNRUG9YY3Azd2dzNnZad1dnTjdTcEx5Vm9p?=
 =?utf-8?B?SjNuYnczYXFtQ0N0THp1RjQvVWJPSVNSVzgraldobVFGSnhxUU9tNmhkNHVW?=
 =?utf-8?B?bndOVVo2d3RKaGc1S2RTOTdBWTQ3QXN1VE9oK1E4SXFYVHV1MFJncU5MWTUv?=
 =?utf-8?B?dVEyMytETEpJd1A4R3ByVkxidXV4YzNUSG9zM1hHQnpuV0g2YlRzVDY2TXZ1?=
 =?utf-8?B?eTJuTUlHZ2hubnJENkN2NXlPWVIvbGxEVmV4ZXFybkJISG1XV2R5WDJKOTh3?=
 =?utf-8?B?SU1FRFhVYUwwYS9UU0s2bVR5RVZWaGJtRFFQM0JUeUxibWlKTWdBMnBSWkdK?=
 =?utf-8?B?TnhTMzNMcEEwRnVWNDdkSFN3TzZHL1JWUlZ1M2NjM2dBZXBvSjk3V2ZVRWsx?=
 =?utf-8?B?Mld5QUVVa05wc0F3UnlrcE92MkNBc1hCeWk4QXVBZGJoU2kxdjBwS3VVUGtx?=
 =?utf-8?B?UWl5QktjeVkzcDJWTllFazBrY2RRS1lteXlBbWdSUjlsanRqaTc5MjBuVTNr?=
 =?utf-8?B?Y0Y1cm9IWC9uRkJvcVI5T3VDa010MG14RTFpL0dDaE45WXhJU3NsM1NFcCti?=
 =?utf-8?B?UWJ6djByYy83czJCMzUvV2svd1FhSElCbEpFbldlKzRvMWJuZ2ZudUphNVlT?=
 =?utf-8?B?ckY0VWV6dzNTQ0N4dStQNVJ4R1FFWkhXSzNTS25lTExMMlp1MVJQMDBiN0Ez?=
 =?utf-8?B?d01MMk1xVVNiMlJPYitGa0RkYUZKLzdXRytmZ0x3Smt5dm80enFRUzR4MENu?=
 =?utf-8?B?UDZvc3J0WlkvVTFjejJnSlRGbWs3TCtmMlNJYWdZeGt3RVlUTFQyQ3RsUXc4?=
 =?utf-8?B?TG5UTVRVYW1HWXNxc3NNeXdPd0pzanFqcjRQRUgyL3F6aithcHVxMzJxOVFQ?=
 =?utf-8?B?bWhFRk84b2hzMzg4L3RJRWYwNWxiZjhQUERNbUFXeXF0OHFEWmJlZnI1MTkr?=
 =?utf-8?B?NDFQVVVrakxaVGpEb0dtWktuczNaRUhEN2pRYnVmalNmR0hTNFBvZjBONVp2?=
 =?utf-8?B?TGtJRUYyOHE5R2lrd3dlVk9uWElFS2MwQ2FNamk4YmZ1QldkZHpJR0o4YjMv?=
 =?utf-8?B?WEx4T0F1T1hUQmFoYWJNbTg2SVdYYkFuQUNkTXVNRWRPb1pFTm1lT1IvQ2Fy?=
 =?utf-8?B?Z1JSUnJuQ3NkU1JqcVV1NmluNUgrVUt6QXNLWWx4cU9IYUJXTzNSVkJlaXdC?=
 =?utf-8?B?aUpMdWdTcUtJUUR6M05YREpocEFjajdzQTJ0ZDkyRWxPSjY0N1doZjhZZ1Zl?=
 =?utf-8?B?Wko1eDdsaGJueklYUzJrcEN6dFNqRStWWmhuNjI0YVVjTVIvaXl1R0hIMGUr?=
 =?utf-8?B?T01CQ1pyRVovWEFycVhpandROTJQd3Vkc2l6eGFBT21abFVXbmJ1TW50bldw?=
 =?utf-8?B?K0RNenVWM1JLYjZIdmNSWTZYeTNrSW1VWkVFU2wzMEpkQ2ZxalFrVVhVbWY0?=
 =?utf-8?B?cXJFbG5WU0lZUHZGY2NGUU9ZRGl0ak5NTG5BS1gvRlZBRTN2b05wSytBS1Fp?=
 =?utf-8?B?NGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <542E61879BDC724BBDE5CCD26F001CA9@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2063fd33-d1c4-4bdd-7cca-08ddc8ce9c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2025 03:19:46.2685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kM++cyysweYfPH8F63sZfjGg45PaRluiqsEdPxy4vf9aFzC0PEuEKea5DCYwSgb54YCzuYnwNe9CL9iNDAp/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7972

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDIwOjAxICswODAwLCBsaXUueHVlbWVpMUB6dGUuY29tLmNu
IHdyb3RlOgo+IAo+IEBAIC0xNTE2LDcgKzE1MTcsNyBAQCBzdGF0aWMgc3NpemVfdCBfbmFtZSMj
X3Nob3coc3RydWN0IGRldmljZQo+ICpkZXYswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldCA9IC0KPiBFSU5WQUw7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8KPiBvdXQ7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgXAo+IMKgwqDCoMKgwqDCoMKgCj4gfcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+IC3CoMKgwqDC
oMKgwqAgcmV0ID0gc3lzZnNfZW1pdChidWYsICIlc1xuIiwgZmxhZyA/ICJ0cnVlIiA6Cj4gImZh
bHNlIik7wqDCoMKgwqDCoMKgwqDCoCBcCj4gK8KgwqDCoMKgwqDCoCByZXQgPSBzeXNmc19lbWl0
KGJ1ZiwgIiVzXG4iLAo+IHN0cl90cnVlX2ZhbHNlKGZsYWcpKTvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIFwKPiDCoG91dDrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IMKgwqAgXAo+IMKgwqDCoMKgwqDCoMKgIHVw
KCZoYmEtCj4gPmhvc3Rfc2VtKTvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwKPiDC
oMKgwqDCoMKgwqDCoCByZXR1cm4KPiByZXQ7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgXAo+IC0tCj4gMi4yNy4wCgpSZXZpZXdlZC1ieTogUGV0ZXIgV2Fu
ZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+CgoK
