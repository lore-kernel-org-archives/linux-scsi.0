Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45894430;
	Wed, 21 May 2025 02:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747794161; cv=fail; b=KEd8B4w/fMiT8pqyqYwGEmbichVISDVbhvgRV9PRchVpqNBl2wftrZ9DIWonO+RdU4Fb9q7PIttnejoeP4akpdmJE67elH1m34XbMcGNOVAC0AvQ+z4+W1mn7giZc9/Af0+cUVEeUf5OcVsxO0pQ8DEUG6vBj39ZLe1Y5JTSxPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747794161; c=relaxed/simple;
	bh=thicPF4dILCNEUelysrgjI5HNIo+D0NKaePW1K5iNSk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bj1EQRqyaADAfwJqqYxT26YZUevD8mg23fXvDncEiO+nfua4S3H7QmxCnK5PmDpPprz4/45puwdSkuOqfx5CEE4GiIieJkZESmE3nOexOW4YsbaaW48mdpjjVIW0TS7ePjsZIShclxEtT2UdADifWbI1fOhahRf0ua3vyIPDgZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=p909tSl9; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=uBt2y9Qo; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="p909tSl9";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="uBt2y9Qo"
X-UUID: 71eb0e8c35ea11f082f7f7ac98dee637-20250521
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=thicPF4dILCNEUelysrgjI5HNIo+D0NKaePW1K5iNSk=;
	b=p909tSl9dVzkQUuKoRi3Ze4iszv48s45CoaaGsonJ/k8uCnDVixJjXoAQwwuKUFIhryS/20rrWopRGW09aFvEH+96PZLdNAWUkZ8LP2SJ3MJXcRPT6gtvK1tYraNafs9KH3bTI2t91SLaD3Z1Tgyw3P8xYMObLXe9yCqlU9wWco=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:57812628-4eeb-4ca0-931f-4fa43978834a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:b9753b9b-cfa6-45d4-9e0a-a16476a41b8a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 71eb0e8c35ea11f082f7f7ac98dee637-20250521
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 371495989; Wed, 21 May 2025 10:22:29 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 21 May 2025 10:22:27 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 21 May 2025 10:22:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=klSlULSAW3f8ZHXHYfoDqwd76z9WyAIX8gdzZLmxC2b9xogKdP7eENiUV0YZWt15s8qJGgRF9B1fMSv970f4O2ScyTKvfCNYFjZ6/oWLtY3hFJ/fZxtYM8ZGadtOamgL/FrwWQvgdCjawo18j7KT5Gqy0oMjSvqcvXKRP2RO2TxssUdw/ZGN4oD+1YgVdMo6ageXyVzkTv2jPnE9okqo8w4qW/B2WNNzMVf6gaA2dKzR56l09lEtPxX/NwIdRMMlhwUWvMNkQFaEaWuw/ZGfN+JYwqMq81sI9QJMDV1Vo+4H/13CvlGoyKF57QhwVq7BHeubriaMnurM1HkunXt/0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thicPF4dILCNEUelysrgjI5HNIo+D0NKaePW1K5iNSk=;
 b=OjagIiL/b/ZPC8s4jXRSFVvXhT//7WPklVKvrVZgibZ19yASai74mXnSnlixwPSHuao7xkiYZ2DrQ31HVh7CHWAiDROqEH2dToxQPpuyRNOT5ycjK1M9QWT20c2Ti+0wnLV/Ghl1ZAw5qkY/UnzYIyGUXU85JwzZ60TpOHhSxYw2Xj3Hr77Wu2tz3iblJfEMYDztw37geDRc4f8qAQIU24v5RjXYXHh5QJFqtaLuw0GJX0OkzY5k+sN9r+dvPjzh2b0AHomTte2ognpO4jAhxmw8oe145l7jtcfVBTratb7/8MVmVq+hI3x3ZtLafo7Qs4/mh0qC3vr233nKBojBkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thicPF4dILCNEUelysrgjI5HNIo+D0NKaePW1K5iNSk=;
 b=uBt2y9Qon7VdLybuOxJbAr09Z8uicZradLPGcfioQCzka5x1bSalStFQVk47F/Gv+lHN4XJNUQtr0TAbO7PhSYJl9VuEEfM2Lg9svjFu8eBSgxXOZC9fPwIolEik8QmRl3S/f5qlZVyGhcaljdfljWMQE4KJcYTYU0iWj7Parqc=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by TYSPR03MB8682.apcprd03.prod.outlook.com (2603:1096:405:93::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 02:22:23 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 02:22:23 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "AngeloGioacchino Del
 Regno" <angelogioacchino.delregno@collabora.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "luhongfei@vivo.com" <luhongfei@vivo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>,
	"wenxing.cheng@vivo.com" <wenxing.cheng@vivo.com>
Subject: Re: [PATCH v5] ufs: core: Add HID support
Thread-Topic: [PATCH v5] ufs: core: Add HID support
Thread-Index: AQHbyWthn7PGWIdsckicQEY+2V08FbPbf26AgAB1KoCAAGbwgA==
Date: Wed, 21 May 2025 02:22:23 +0000
Message-ID: <8c547bfaf0c4553760e8c4980f1d2b27d43ded3c.camel@mediatek.com>
References: <20250520094054.313-1-tanghuan@vivo.com>
	 <ab468bb26dafca673d7ffca7dff519b7cf024cdc.camel@mediatek.com>
	 <3ba29109-86d8-4bc1-8f2f-49fa2e56673e@acm.org>
In-Reply-To: <3ba29109-86d8-4bc1-8f2f-49fa2e56673e@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|TYSPR03MB8682:EE_
x-ms-office365-filtering-correlation-id: 2a0d1364-1892-44b2-ff9b-08dd980e5286
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cEZ0YXBjN1doVytrem9vRVp0eEdzQllLb2daZ210ZHM3MHdSRVc1THZDN1R5?=
 =?utf-8?B?REplNUQxMDZOUWltSDIyUFVhcGRVcFdYZWlWUVVGeHREKytHMmYzSjZVVlIx?=
 =?utf-8?B?ck5qZ1RvaGUyUE9VcTRHUE16Zm1YUzlUVkdqd2pRd243aGZvdEd4QUN2ZU5G?=
 =?utf-8?B?dXpBM3dhcXZrRStLN0Z6SVdvT1hDd0tGN2I1Q2IwVWJFc2xNdUNhcCtqelpG?=
 =?utf-8?B?KzA0K0NaRWxZajdCUmFLRFhEMmNZeXl5VWRHMkhmczFwbjZxTTlsdFpJZXRR?=
 =?utf-8?B?VlJ6RzVsdmtmZ3hqOUluUFQwVzhzelpYb2NhWG9scnRLVlYxT0JrelVJMm04?=
 =?utf-8?B?R3NWKzlIWVFTQ3V3TFNTcTFDWi91QVRqNGtMTVFlRWg3YXFKdmZCQ0w4SWlD?=
 =?utf-8?B?Wk81N2d2QVpTUDkvem5EcGNORUhzbG9scllxd0w0RlJ4Y2x6QVhWeXJ5d3Va?=
 =?utf-8?B?elNsY2xnMitjSFpvNnlsV3hQUXNkQjV5UnFoSU1wdXJ6WXY5WEdqb3hQSE5l?=
 =?utf-8?B?SEhWTjhrVFJWbGJ5MzMyNDZRb2l6NzFTSG9iMHZCdmFueVBOT3RMaTR4VHpn?=
 =?utf-8?B?bDVobHBrSFZHVkZ2akNaSk5VMEpyWGJ2VUlhSG1tZnRLMnpza3hadnI4eHZJ?=
 =?utf-8?B?MnZnNVhJelNvSml5OWlHSFFrZ3AzRXhTdjl6eHBURGswaW5hSi82WWxEVnBi?=
 =?utf-8?B?TU9TY1BNbTBMdm9XRkNQMFRIVEhqa2NLbngrdU40T2tiYnd4YUcvRkh1eXNa?=
 =?utf-8?B?ZVpjTmYwYUg3cWpZK2FweHJSUi93OVNoZjVvcHdDcGp2YUlXQXNtY1JXMEdL?=
 =?utf-8?B?aFA4T3c2VzcwQTI4bWpza1hIdEt5bHhXVnBPWXdmYW1ZNUlvY296MlJMTXo4?=
 =?utf-8?B?U1hlZmRRdVpqKzNrV2paOFRrdzFFTmg1eklRK2hoak9VNmVXYXdqQjVDcmp2?=
 =?utf-8?B?aXhyK2VsQWdSVDFHakpDNVgzY0NwbFJKTW5RRVg3UXBxUkE3bUJmUUl1QU1V?=
 =?utf-8?B?dWlHMGNYMktwb1VSbml4ZDdtOWhsRmxtK2tnREg2b1RWc1VVZE5WOUlSa2xw?=
 =?utf-8?B?QmZqQmt0cU5OWG1xQ3NqNU5RNXowWDR2MEpTRGZxZGhlUS92QXJBK0U0bHhK?=
 =?utf-8?B?U0FSOTFrY0VYSFEvbWtIU3pkZzNFcFlOcm94b3gwZjlZREV0VExyc1Y3NGsz?=
 =?utf-8?B?c0NVaWxzMWZLMDhJUTFvS1JsL3F1Q0dHS2dlVE1SVXBYYWFIK0xHTzZvUTdD?=
 =?utf-8?B?Y2NPVW50b1FhTzFPZmpyN3Myb0UwUVQ2cFMxOXVKNUZWRUtBQWEwUk9RbjZ1?=
 =?utf-8?B?M3E1VkFjK1NpVSs0dEorcklmV0pFcFFMQkp5NXg2SnJBSXp0ZFFUQW51ZVJa?=
 =?utf-8?B?M3pJbGdLQlpQK0FHa2RhSHIrYmgzMkZCU1lBNU4wMC9JbVdZWGgrSmsxVzZG?=
 =?utf-8?B?N2lRVVU0VGZKU3ZkbWRSeWdTL1BxNENZd0djdUhYeC8yR1JuK3VDNWJvOXMz?=
 =?utf-8?B?L2wxSmhYbzB1MDlWdjI3MFBXRFp5d2hKdHhtZGJOMDMxWEtleVR5RmlHSXFN?=
 =?utf-8?B?TE51a3lGYWQxTWttVEMyR3dMVzZ6Mm9wZXdhQkIvNXpNeEZRSDJoc3JDUGVj?=
 =?utf-8?B?eURjQnVNWDBEbmc2OTdDYWEweUthNWErQlc3d0FaNjRBK05NNHRTOGxVbmVB?=
 =?utf-8?B?SWRmWjM3bG1idU1qaFJRb2VCMnVTSUhMYmsyeXdLKzk3OFlKS1k5L0FQRnVR?=
 =?utf-8?B?SGpWS3hDaEIvNnZ2L3JWaVRwT2RyVlQ1ZVBjOWsyNlRUNk1pdWFaTFhHTDVo?=
 =?utf-8?B?d2tlemJhWGRQOWJxbDhLOTdmZktJTGRPeE9WR1JQK0tQVjNUV29wS0J1anVN?=
 =?utf-8?B?MUhjdjNlWWl1bUxlQ3NETlFpZXNnVlpYOS8rNklpa0JJNlYxQi9iZW14UG9l?=
 =?utf-8?B?WnYrQzJzNlprbERRQXl3VzN4cXJnVkVrcjMzaVIwaFFlVitUV1puUExzRi95?=
 =?utf-8?Q?2rRmlWFXecVRNKIyS1lpoWEq1AoOkU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TExubDJ2Z2FWU3d2cjdLN2xpeUkzR0JaRmZyTGFtak5vazh6VlNUSlNMdXIz?=
 =?utf-8?B?aEJ3Q0xISWRMMERCdEo4SDdSdnE2WC9NdWJ4SjJhclI1ZDVpTzJMN2JaN3h3?=
 =?utf-8?B?M2JBbDQ3MzRNOFkrZXZ2eEtTWU5nTDFJcE1PWkhlWjF4ZU4zRVhtRkZ2cDd3?=
 =?utf-8?B?N0Fta1o4cHQ3NVFVU2d2MDNrY1pqd1h5V1lwN21VSzZzaEx2UDlWVFlkZUZH?=
 =?utf-8?B?RHUwMzE3anVoTXJJSkF3RUpjUG9JSTQ1eWxDOEtMMStLcHdOR2pBcTg3dmRv?=
 =?utf-8?B?SkRETnhjWThPTTY5QXY3dkNudHV0ejg5VnJ0MTM2TkJvNS82YjUreExTSXFI?=
 =?utf-8?B?MlMwNEVWc0ZtSjk2OG9UeXM4NFBuV2pQUWsrQkZxamlSTHRJL3Z6aTBDdWdF?=
 =?utf-8?B?M3dqcEpBRWhyZ29CVEp5alNxZVdnZFpSZjY3VkE2enpJVFZqMWJjcTF5SFRa?=
 =?utf-8?B?YWZhQjVOMVhtNmV2YytteDVzSXFseXlQNzdSNzZRSndUeHJkUERBbUFBLy9w?=
 =?utf-8?B?b1FYZGhZaEdudENLUTBsNU5weXh2TFd4cnhWS2NMT2FkV3o1YmQ5ZmJscisx?=
 =?utf-8?B?Zm41LzBlSE9SVFcyY1FMblRIVzdwOUlOeWZtdS9jQ0pzRVhVK0JBQk9vd0ZY?=
 =?utf-8?B?NFN2TTZqVWVCWWw1Q0lvNUx1VVdrQWswODROWUJqVkM2K2lGNEVRT3JvQWtF?=
 =?utf-8?B?RWZUd2R4ajVHRmh2VGN4MzNTRUpCTGZ0aEFFL09VQmI0WU5CVkIrVWROQXcw?=
 =?utf-8?B?N2w3aTdyeWVPNDhoWmsxS2tOV2Y2M3RjUUZoUURuWWd4QlljYnQzeW80NnFy?=
 =?utf-8?B?Sjh0aGF1Rmp5ZUJLT0tSMGUxMzdvNzhPZU95YjFMbmY0ajhjSjF5NVNrOG1j?=
 =?utf-8?B?dlRzN0J0VFlLYVQ2YkVIZWZrc3hLbW1aZWtxaEgvVUU2cDBQY0JLamdaNTM2?=
 =?utf-8?B?bXZ1REJpNnMveGdOVHRmWWNIeFZWYzdhRStTVHFhWUJNZTZ1ckFiaGpNTE1S?=
 =?utf-8?B?Y0g3K0lOdG9HSXRiTHhHYXAwL1Y4L3ptQkU2MnBGbE5TZVNWN0tlS0RZMzJI?=
 =?utf-8?B?bTBlM3RjbUkwanRNZ2VOMnZYdEl5Qy9ISVRsVDdjK3RlbC9CU0gzMkhibmYv?=
 =?utf-8?B?K0MrUWVPcVpSdXdFK1ljRWpBUW1ueVF4QTJTMThQV3oxeDFiSENOYTRXMHVH?=
 =?utf-8?B?UVB1VHNGNGFPRlJXV0FHemNoVjFvTDlwWnhjZk1tVW5FRHcyN0wwTDRMWUI0?=
 =?utf-8?B?R0VCN2VyZnRGR1BhRk5kNkQ4bnhNZlB0MUh2Vk1saHo4cUhvd2hiQ2pwV0ZB?=
 =?utf-8?B?M3MvcGVpeEg0NE5LODk2UGZHbjF0SzhJbjR3UzNEZkVDMFRaUmtQY2tPSE81?=
 =?utf-8?B?RTRNclRjWWxuQ3A1VndDYVNjQUxvUnk4cTNEQmh4endqcTFGb3B4SzRFV2VT?=
 =?utf-8?B?OTZaTDZGb3RQV21tY3YwQnBIcFNSc0psVUFrdVpvcEZUb1V6ekdic2tFR3Ey?=
 =?utf-8?B?bUExRzlrOWQwSEQyazhubEZqOEs0dnZabzVodENQZTBrSE1ESDh4K2pDaHNZ?=
 =?utf-8?B?RTV6MFJBNm9WNVk5S1gxblN6ZlVlWVM4Zm5qaWdHc1JNdTQ2NEFhVU4vZjBU?=
 =?utf-8?B?U0Q3VGdHV3p6aDkzM1JsZ2JSbGJOZUczSkplc0JnNmFlUFFsWkZ0cklCUUlp?=
 =?utf-8?B?bHBSbFI2dGZpeFlTZldlUDlSMHMxelJsdTJrd2F6RXlUUzZLbW9iRHErMlVn?=
 =?utf-8?B?WVlwdkhDOWUvd2lLT3ZkR1prMTdtNTlucFljRkx1VUw2QW9UcWFDRE16Z0Vj?=
 =?utf-8?B?WUROVS9zV3RUZ0Y2dFVmbnZ4ekpvc2VMUjdOZHRGQ1NJMzlocENjK092dzRS?=
 =?utf-8?B?N2VTYnJsR25zaTZ0K2R5dFJOVUQ3dGloRXhCMzVlUHI4Zm5QQWJjaFVyY0Uw?=
 =?utf-8?B?M2lySmdZelhQeWNKc081dWNEYmNGdjdxTDZtTCtmaGsrZytydGc1UDY1bW5W?=
 =?utf-8?B?QllralJDSkthVEsxYmxpU3E4SDh6ZzJuVlVWUHhDR0d4NkVURjUzSlYycUhs?=
 =?utf-8?B?TytXZVpJRVF1RllDRk1wM2h5YU15cE0zeUd3ZDVtQ3VlR1VOb0l5dUVDM0RB?=
 =?utf-8?B?RXpkdUhRV2JkancyRFh4LzUzUUcxSU4xSDNKWlU5TFAycjBQc0d3RXg1aDJ0?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <762F32607BC68A41A10F6504CD14B7EB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a0d1364-1892-44b2-ff9b-08dd980e5286
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2025 02:22:23.7376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iW8J8gm7SFtNgjDdXaafLMZ5/wUNWJV/luwlYE/hKy9X8zc9Kr5cdX2JHM/ERpb90tmMAc+Q9isrkl76oAjkIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8682

T24gVHVlLCAyMDI1LTA1LTIwIGF0IDEzOjEzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDUvMjAvMjUgNjoxNCBBTSwgUGV0ZXIgV2FuZyAo546L
5L+h5Y+LKSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjUtMDUtMjAgYXQgMTc6NDAgKzA4MDAsIEh1
YW4gVGFuZyB3cm90ZToNCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hj
ZC5jDQo+ID4gPiBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiA+IGluZGV4IDNlMjA5
N2U2NTk2NC4uOGNjZDkyM2E1NzYxIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29y
ZS91ZnNoY2QuYw0KPiA+ID4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ID4g
QEAgLTgzOTAsNiArODM5MCwxMCBAQCBzdGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3Ry
dWN0DQo+ID4gPiB1ZnNfaGJhDQo+ID4gPiAqaGJhKQ0KPiA+ID4gDQo+ID4gPiDCoMKgwqDCoMKg
wqDCoCBkZXZfaW5mby0+cnR0X2NhcCA9IGRlc2NfYnVmW0RFVklDRV9ERVNDX1BBUkFNX1JUVF9D
QVBdOw0KPiA+ID4gDQo+ID4gPiArwqDCoMKgwqDCoMKgIGRldl9pbmZvLT5oaWRfc3VwID0gZ2V0
X3VuYWxpZ25lZF9iZTMyKGRlc2NfYnVmICsNCj4gPiA+ICsNCj4gPiA+IERFVklDRV9ERVNDX1BB
UkFNX0VYVF9VRlNfRkVBVFVSRV9TVVApICYNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVUZTX0RFVl9ISURfU1VQUE9S
VDsNCj4gPiA+ICsNCj4gPiA+IA0KPiA+IA0KPiA+IENvdWxkIGFkZCB0aGUgZG91YmxlIG5lZ2F0
aW9uICghISkgZW5zdXJlcyB0aGUgdmFsdWUgaXMgZXhhY3RseSAwDQo+ID4gb3IgMS4NCj4gPiBk
ZXZfaW5mby0+aGlkX3N1cCA9ICEhKGdldF91bmFsaWduZWRfYmUzMihkZXNjX2J1ZiArDQo+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIERFVklDRV9ERVNDX1BBUkFNX0VYVF9VRlNfRkVBVFVS
RV9TVVApICYNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVUZTX0RFVl9ISURfU1VQUE9S
VCk7DQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IEkgZG8gbm90IGFncmVlIHRoYXQgdGhpcyBjaGFu
Z2UgaXMgcmVxdWlyZWQuIHVmc19kZXZfaW5mby5oaWRfc3VwIGhhcw0KPiB0eXBlIGJvb2wgYW5k
IGhlbmNlIHRoZSBjb21waWxlciB3aWxsIGNvbnZlcnQgdGhlIHJlc3VsdCBvZiB0aGUNCj4gYmlu
YXJ5DQo+IGFuZCBvcGVyYXRpb24gaW1wbGljaXRseSBpbnRvIGEgYm9vbGVhbiB2YWx1ZSAoMC8x
KS4gRnJvbSB0aGUgQzIzDQo+IHN0YW5kYXJkOiAiV2hlbiBhbnkgc2NhbGFyIHZhbHVlIGlzIGNv
bnZlcnRlZCB0byBib29sLCB0aGUgcmVzdWx0IGlzDQo+IGZhbHNlIGlmIHRoZSB2YWx1ZSBpcyBh
IHplcm8gKGZvciBhcml0aG1ldGljIHR5cGVzKSwgbnVsbCAoZm9yDQo+IHBvaW50ZXINCj4gdHlw
ZXMpLCBvciB0aGUgc2NhbGFyIGhhcyB0eXBlIG51bGxwdHJfdDsgb3RoZXJ3aXNlLCB0aGUgcmVz
dWx0IGlzDQo+IHRydWUuIg0KPiANCj4gQSBkb3VibGUgbmVnYXRpb24gZG9lcyBub3Qgb2NjdXIg
ZWxzZXdoZXJlIGluIHRoZSBrZXJuZWwgaWYgYW4NCj4gaW50ZWdlcg0KPiB2YWx1ZSBpcyBhc3Np
Z25lZCB0byBhIGJvb2xlYW4gdmFyaWFibGUgc28gSSB0aGluayB0aGF0IGl0IHNob3VsZG4ndA0K
PiBiZQ0KPiBhZGRlZCBoZXJlIGVpdGhlci4NCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNClll
cywgdGhpcyBpcyBub3Qgc3RyaWN0bHkgbmVjZXNzYXJ5Lg0KRm9yIG1lLCB0aGlzIGp1c3QgbWFr
ZXMgaXQgaW1tZWRpYXRlbHkgY2xlYXIgdGhhdCANCmhpZF9zdXAgaXMgYSBib29sLiBCdXQgSSB1
bmRlcnN0YW5kIHRoYXQgeW91IG1pZ2h0IA0KdGhpbmsgaXQgcmVkdW5kYW50IGFuZCBzb21lIHBl
b3BsZSB3aWxsIGZlZWwgY29uZnVzZWQgDQp3aGVuIHJlYWRpbmcgdGhpcyBjb2RlLg0KDQpJdCBk
b2Vzbid0IGFmZmVjdCB0aGUgY29ycmVjdG5lc3Mgb2YgdGhpcyBwYXRjaCwgYW5kIGl0IGlzIA0K
dG90YWxseSBmaW5lIGV2ZW4gaWYgbm8gY2hhbmdlcyBhcmUgbWFkZSBhdCBhbGwuIA0KSGVuY2Ug
SSd2ZSBhZGRlZCBteSByZXZpZXcgdGFnLg0KDQpUaGFua3MNClBldGVyDQo=
