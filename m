Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E822C0276;
	Wed,  5 Nov 2025 06:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762324141; cv=fail; b=O/KHDT24o6kYBk1jeSgJE7lcfw2Nox8TmPbz5RDKSKEmT8XlgErX1PXG58B+QVzapmsnRxYfWAWq/QTAh3YxIEkmrIxW2gzouqZ7T7Mp2Z5q+hV6FqadljDTwrg1PMkGzJkwn9+Wb2TWD6nh2Plaap7YjbhHs/mQcvgG+ewSC40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762324141; c=relaxed/simple;
	bh=8E5SqKJJwd/9F6EAQWl3Rjc1m+1w3P+TcQR6fTjf1Qc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lbsqtfgFXnSewUfrbZ4XjXSc3norR6JWgMJYThaM4rgBQSlk5m3DwXNlOI+jy63hpmj+6hyG4EjJ6ceUzfUetyq94Rt6JzstdgH8yig9+JEFHhB2hmXe+SIH4PvGEetAhv5VNFPHhIwsEEk4iwIBAUPhzkdm95kxiE3KQQcWTxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GHa7FV7c; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=kIayuNp6; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GHa7FV7c";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="kIayuNp6"
X-UUID: af37fbceba1011f0b33aeb1e7f16c2b6-20251105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8E5SqKJJwd/9F6EAQWl3Rjc1m+1w3P+TcQR6fTjf1Qc=;
	b=GHa7FV7cSjiqctjdJ+EZM8EZkqdp9ABbA2hVJ8SUKbKLDtTOZ1WQGeH4jzGOOLbzpt/aI6Ta6gjYc8CgwVPptArrTXoy0bmcQrnrL2muxamwg+4WeXc+9Oa6f7WC8CLVhTE9HlZxFzfMlhUkpm/ArMjI72+vn9COnINtFVhnprE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e00c5b03-d4bf-49a5-b355-ada6c43fe7fa,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:55a60e6b-d4bd-4ab9-8221-0049857cc502,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: af37fbceba1011f0b33aeb1e7f16c2b6-20251105
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1228571505; Wed, 05 Nov 2025 14:28:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 5 Nov 2025 14:28:45 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 5 Nov 2025 14:28:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yYVVN2jMzcKDhDae3qQHiiFgMrDsIOFBvUkt6bw2+jcTX1pn7WqQ7twFave4Kz6CRutcjYqnZuJed3aeGOqBw665ONQmoaoatBNjqrE1JcJ5y2EaHQtpZO47ISQ+V9D5He0xTKrpPilhoxZRXYYDn4221vyugJ7+qBqzMvebJ+cjQ1Fw8J5dtBlG3jYaKCFGtzbJj5XjlgCBPaeBFIyMEOumWGhltWRBFwlYrFZCNpmxJgSRQYQRZQu4dsOqUPTctAIWIAxpIneQNODR8AmfOK0FNUCqfJMMfumBvjFFt6jTCfvMqRhf0bzmosO7wicXsM+SVk/7bCnQDMpPE6DnSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8E5SqKJJwd/9F6EAQWl3Rjc1m+1w3P+TcQR6fTjf1Qc=;
 b=eT41PUa8KFGDm90P/xkDxu2IIFAmu2wvLtE/Sn3IMvvpufw2pK2igTYteABOs3Cgc9LWQv9zLjs5rSizk8Et+rXsPW2umAEV2M1Oiz6dBEsndQ3T95Fygb6K2Q2/QxZpsfstiWDmpXXJVcQuCj+wm2qortl8WWUp9+23iqUVowqY22XZ1zdsQJXjZpZWh3zJaEy6LuxexOzsztnP8C+PlBMrTql7zPPfJ8GYVmy3B0AghUH+e5ZZ4a6bjWhr1CAPeAgDpAkz0XU414KB8VBXSzxv2cCcW68oI+C1i83WlzCMPxd8qtwO/le9XWwYpTTDrw2Ms425KhQhhcEUM6VTcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8E5SqKJJwd/9F6EAQWl3Rjc1m+1w3P+TcQR6fTjf1Qc=;
 b=kIayuNp6A1WGvbCAI+AdISoLzFJu0dGk2006TX9+qvy9NnZWtgU4mrtX8ud2oAEVAPp0jT7b3oLzZtXjDjlF6JdON/W3zcH7VyPZVhvFCZRHQjUHgt3zX2bwfDgtNeaxJRy0/4Lja2pDlSYDe5LooDXTi60PinczbVUl5HpwbMk=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by KL1PR03MB7490.apcprd03.prod.outlook.com (2603:1096:820:e3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Wed, 5 Nov
 2025 06:28:40 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7%7]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 06:28:40 +0000
From: =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	=?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"kishon@kernel.org" <kishon@kernel.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "robh@kernel.org" <robh@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"kernel@collabora.com" <kernel@collabora.com>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>
Subject: Re: [PATCH v3 10/24] scsi: ufs: mediatek: Rework probe function
Thread-Topic: [PATCH v3 10/24] scsi: ufs: mediatek: Rework probe function
Thread-Index: AQHcTTo52qYVOWDGg0Ci2OQ7RzAvYbTjoGOA
Date: Wed, 5 Nov 2025 06:28:39 +0000
Message-ID: <90a10fba2e41db4df4c28a72d182c5f0df8c016d.camel@mediatek.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
	 <20251023-mt8196-ufs-v3-10-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-10-0f04b4a795ff@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|KL1PR03MB7490:EE_
x-ms-office365-filtering-correlation-id: 23d902e8-0051-4adc-9ea3-08de1c348f3b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YUd4dmlOQmhGZXR0RTR2T2R6T0JDVUlGU2M3RndEV2ZybFhqVlFvTzRycDBE?=
 =?utf-8?B?WkkwbHk1MkJma0FZOFJwZSt1MWtSOFdCWHlxSGRmQ0dFS3pqUWhLanlpbTc1?=
 =?utf-8?B?SzZXMXErdUlaME9Kei9wN0tjeGNuUUZBR0FORWRBQXc2bGNNTWFVYjBkd3Bi?=
 =?utf-8?B?VFVMOTNWODc2UThLRDlRYWR6cmJLWDVZaUlpbVIvcUYzWXBhWU0xQUpvVGlh?=
 =?utf-8?B?S3pxZDVxODlBK0dYNzFKckNKeFkyT0tDbTRJTXJxUmJCWTNFZFJ6OGtJZzhp?=
 =?utf-8?B?WTd4TFpPRFVuM0x5Vy9IaEI1UDN4Y3BrRGFXL1pzYXE4aWhOSGpkbWZVb3VK?=
 =?utf-8?B?Ty9LK24xTDJURzcvOUdIeTRzRjloTEZDVVlQWi9sckZLcXRRSWIwTDRMRkZM?=
 =?utf-8?B?UHZjb0ZmTU9UWGRNSTNoME84RFdYK3ZpNnFSNUJYSElZNWRSb29JcHg0eUND?=
 =?utf-8?B?Zkd4N3RMYXVseDAxcDFVMVU3ekMwZkFBOHpzdnh5VmhQb2JrWm9KL3BDaHZB?=
 =?utf-8?B?U0h4TTZKOTN3cWVwREt1YXphTktISlhtbW5GVEhXcTNUb0Zoc2VyUHg5MkJB?=
 =?utf-8?B?NU1WV0dwcm5SQzgzeFZ6Y2R4MDlHV1phMmZhdHRoTWNzNjBkaXlBcjRSWFVI?=
 =?utf-8?B?YkdJZjNJZ2JMYTIrY3QyenFaVndBaHNaTkd2Zlk2WVNOY0F5eWsxRXE3UzZl?=
 =?utf-8?B?b2ZkVjhCUVczYmFSSnhTYXI3QlFoZnU3ajc0TGcrWnFwWEwyWEQzMTdNdUhI?=
 =?utf-8?B?YTZFWDNUUW9ER00yeXl6MHUyQ1YwUEJ0dkpFeFl3TDRQV2Y2MDljUURDWCtz?=
 =?utf-8?B?YzlqRG9IbU9saEtoRlY1ZXpCd0EzQ0xnaUR1WFhNQlBxN3RybWpCMUdYV01N?=
 =?utf-8?B?a05DdmsrQnZ1T3pzWW9qeGdlM21pczZyOWNwaDhzYngyYmk3d0VrTzZwS3RP?=
 =?utf-8?B?MUFkck1nSFNnUnZUOHVOUlFkbVNsejZDc0tIRXdOV1NwYkNwYnVod2ZDampR?=
 =?utf-8?B?ODJjQWg5ekM1aTNvODFlbk02VzFkbVZ0TGxLOXVWZXRhb1N6OTkwQlM0WTdK?=
 =?utf-8?B?WHdsOExSTEhhNVAzamQ0dFZORzVnaC82NXhLZVVsYm8zb2NnRU1qQUt6cDFw?=
 =?utf-8?B?b3hHQTU5L2lrY0prck9wTGxRVTFseW9jT3JncWJqRDZHM2UyMGZkaWpLVHBz?=
 =?utf-8?B?TGpIa1NaR0lGZFMzUUs1REFlOG9DS29RMlhHZVRxNXBQUFg4TnRNeHptTXlp?=
 =?utf-8?B?bEtxcEdwNXlsRGVsSXJ0bm1EWlByMjhKQkVqMEZPck9rVmNkVUZHVHcxbzk4?=
 =?utf-8?B?cktSb3pqdk45UFdqWDBkWlRFd1lkdmRMajJPN1NFaHNwQkh0d1JTVWNidXU1?=
 =?utf-8?B?ZzZ4Z090L0R4RkxMZHVadzl2aFZHWlhUWUxtWlRaaHErWGRYenVLL0hPdUxV?=
 =?utf-8?B?YnEzSFBRZHZHcGFKa1I2ZXlNMytIM3VGT0ZKbkhlYnNGZmZLblhxUm80bTAx?=
 =?utf-8?B?aHNMZU1CLzVxRjNmTFZCYmJmdjhoMXduQjlURzBvbnUrZFJmQ3FOL0RkQ3Nt?=
 =?utf-8?B?MWZ1L3phSmdMaVBLbnZsS3J0M2pGMzU4Y3BoK2dWOUJ2T1VHYXdTQmhMb1A4?=
 =?utf-8?B?cDR5MmxpWGdXc0VTeGNKOWIzR2l3bWxIUkZrYVdEamVGWDJrMGUvK3U1UkZz?=
 =?utf-8?B?T2FUWmRyQkl3US9Ma1NOblhRckpyMUZuK0Z0eE52VnlsbUZqdGpObDE3YXgz?=
 =?utf-8?B?MUNzVDdlbEdTTWp0Rngxa2J4WjkrZjVZSk9hU0RwOTEzaGZZNEl0Uk9JOHFp?=
 =?utf-8?B?N2hhMlNnMWNNL2JQa1hydmdxYmtQVGNUUHhzSzV5YUpRWUVNSUMvYnk2cFlV?=
 =?utf-8?B?TzU5Mm1XTGhqNXloWnZpRU5zNnZlVm0vb0MrWnNTNEkrMldpemtGcitxTGp6?=
 =?utf-8?B?MU9GWE1IQm8yK2NnZG5VaUxSQ0dXRjRTZmtnMFl2elhzQi9DYUlPMXVYYjN6?=
 =?utf-8?B?Y2o3ZHdZNW9YODhHWGJHT3lYNGowVkJscmFqd2U5S3Mza3Fma3lEV25Zdnkv?=
 =?utf-8?B?cXRodGFTR3Aybk9nbzk4ZmFHT3IvSThhNndvZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zmc3ZSs1cFFhTGtVV01LQzM0TXoyYjUzWUZWUzVHN25ZSUhvanBuV21QNFlP?=
 =?utf-8?B?QzB1MnRtcWxmMUV4cWFacjEyM2s1aWZGS05DKys0aWx4emdtU2M3UElmSmtE?=
 =?utf-8?B?TXVJK3hLT0l6eHZiQUpXUy9OdWJCUGdVQUZ3N1pmaklJb3Q1SlZzOE5MQzhY?=
 =?utf-8?B?R01BcnhIK2tGWjlSM24rRDFIU2NwcGt1Wk5tbHdxaTJzdTNNQi9Tem9nN1kr?=
 =?utf-8?B?QVZNRXh5bVVCcTdXRlVVcDhaSDlBU2JrUmRTeklvM1FjVzZrUWsvMVFtVWZw?=
 =?utf-8?B?YTV6cUJmOUJBWm9YQlpwMVhJeVl2TXhaT2I0M2FkYUQyRHY4M3I4T29xTHo4?=
 =?utf-8?B?TnR1b1RXMzA5QzdIN242azhtOUtkdHpsV29vdkU4a3ZJNEZIY1B6Um82cWlD?=
 =?utf-8?B?RDMyRHc5RU53UFlhMzVSeWlNMFVQNk5XeFUrWWhpU081UmpBdU1mS1dVQTFX?=
 =?utf-8?B?RUlUWDNPRHRUbzN0a0hRZUtrTVZ5dDFlaWY2Q0VzVEJ4Zi9KTXB1U1ZSQjFR?=
 =?utf-8?B?VXk1aHozc016Sk9vclp5MnFjRm96ajlkRW1aTktsTmdNZS80THR2TE5nb1Vx?=
 =?utf-8?B?VlJSNGREOVQwL0xqK0UvWGFJcHVQRmQ2R29xQ2laNjZIS0ZDL055TmhBcWl4?=
 =?utf-8?B?RDQwSFQraWlHakdMVnRRcjF6ZjFDWk5obEdUK0dWeFdudFZiSlZ4NGhIVGs1?=
 =?utf-8?B?ZGtFbk1YcmNBNmxDbHcxcXM2UnRvaklMWGV4MXlZRzNIQndCTE40eEV4aWMy?=
 =?utf-8?B?ZGtJWlFrRzBEK2NneTlrbkNuZTlMUzBPYW4vYnJSWG9qOWoxYVZIQ1k3VEdq?=
 =?utf-8?B?WVp3WDlRYTVvcTdyUFRZOG1wNWllY243WmpEbzc0aU9KOVRTR0ZpdStPbVBE?=
 =?utf-8?B?anlTbi9WbDdRelpjNXdVOTdLOUZRb1o0M3huSjRlUjNBYmd0Q1FhcTYxcHBr?=
 =?utf-8?B?aFZiVkcyOHkrWGR0dlppNkU4dnk3VUplZlNFZ3U2OW1kd29zVHl4eWRjVXZy?=
 =?utf-8?B?V3liditKeHlCbTM3L1RwRWV0d2NrYjFCdko2eFd1b3NhdmwydmxueStzblht?=
 =?utf-8?B?QmJaQVhKUHJ3S00yTVc5eVhNMTVWRllvaXRjaXlSVDZUcmg1SkZkUlZHeXdI?=
 =?utf-8?B?TE9qc2twVldOUjZzQ2JheENKeXRPcjBkOEtORUxSblA4SERNS0dkZ1daMEFa?=
 =?utf-8?B?T1ZIVURucXJna1lvMXNQa2U1SjNSWDhYM1MvUUNiVzRyZXZuU0RWREhVYzZQ?=
 =?utf-8?B?REtJZEVuWEJTZEM5Q3cwdktSNllUMktoUU5hL2RQS3BLUTNGZTdHb2wybE1M?=
 =?utf-8?B?dW52OUZ3V3VyelJDYituSnltK1hkVEVvcnhJdVNOcm1oeWRvQnJ2OUI3UVNZ?=
 =?utf-8?B?akEvQ21ZUWVxZUVEYjAvbTdiVUFOVlg1a3RxczdCc3kzT0NTaFU4RVRYNHVU?=
 =?utf-8?B?Mk5TNUEybWhNcUc0U3dPby9XUVZBS2tsUEUxelVZTnVpT2JDRFZQVlF3ZGhQ?=
 =?utf-8?B?cktWaGFpTGFIWEZDN2xBenFKRTRjK2JqeDBXc1BKR1ZKcUowMVExSDJaTFVC?=
 =?utf-8?B?QnBNcEE0aUtFWFczeHgvanl5OEltNksxY2lvNmRhZVZRTGxWZVRET3RxWk1U?=
 =?utf-8?B?VzdsbWc3UG14bDFnQkdsdVV6c3FkNEtiV0JSN0tYN2lMbXEranc4eDVDcnZy?=
 =?utf-8?B?OVdqRFA2MEFUMGQxbXAxWFdjc3U0Q1hIOE8rb1pGeU5Tc3BNN0o5cjJIVFI1?=
 =?utf-8?B?K3BGb3RpODRFdkg0ZUtvRGlVVUZNNmgyWEM1eGh2YktlNGk5WTZuUHRCN2hD?=
 =?utf-8?B?QzlzVXBoM2czU1VNQWJGSFZveGtTc243VmVKS0hobUM3Tyt0QUwrZkVka2Zk?=
 =?utf-8?B?RUJ1b0V1MUZjSWZSQnVhWFUzelpwdkEwNVRmcE5qZ0dzVDZDR2ZDQkxvaHJL?=
 =?utf-8?B?QWtoV3dEQkZvWFowdlovR1ViZjdwS0YyMzFvenlubHMrRzFET3ZxMnB4ejRa?=
 =?utf-8?B?RWlEZDltVUg3WXVzV1c1TnVqSHV4Z0lwS1hrSDVxcEJvblVPTGFSQ0h3Q3Zy?=
 =?utf-8?B?UFREdkt2OG9US0FSWW51cWw5anNYWGpYTzYzV2hTVzJZWjdJWTVOc00zajVw?=
 =?utf-8?B?cGVqakZuU0h6dGJmK1lFRHZEY1ZkTkc3ZmxXK2FJS3RXUXg5VkNZYnRRcWIw?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17B0CFC1F56D9A409693F3F7732296F6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d902e8-0051-4adc-9ea3-08de1c348f3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2025 06:28:39.9642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QF3QB+H5y/rvKKcFSY/CqjFTSJZTCZHQpMqjiv+S8wvBnW8OTj88huR+SNB22n7euqC9p1oBYKzv8tAggXVAyoi1WhUapB5CgDxCWrHqkfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7490

T24gVGh1LCAyMDI1LTEwLTIzIGF0IDIxOjQ5ICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFJlbW92ZSB0aGUgdGksc3lzY29uLXJlc2V0IGNydWZ0Lg0KPiANCj4gTWFrZSBQSFkg
bWFuZGF0b3J5LiBBbGwgdGhlIGNvbXBhdGlibGVzIHN1cHBvcnRlZCBieSB0aGUgYmluZGluZyBt
YWtlDQo+IGl0DQo+IG1hbmRhdG9yeS4NCj4gDQp3aHkgbWFrZSB0aGUgUEhZIG1hbmRhdG9yeSA/
IG5vdGUgdGhhdCBub3QgYWxsIG9mIE1lZGlhVGVrIFNvQ3MgaGF2ZQ0KdGhlIFBIWSBub2RlLg0K
PiBFbnRlcnRhaW4gdGhpcyBkcml2ZXIncyBpbnNpc3RlbmNlIG9uIHBsYXlpbmcgd2l0aCB0aGUg
UEhZJ3MgUlBNLCBidXQNCj4gYXQNCj4gbGVhc3QgZml4IHRoZSBwYXJ0IHdoZXJlIGl0IGRvZXNu
J3QgaW5jcmVhc2UgdGhlIHJlZmVyZW5jZSBjb3VudCwNCj4gd2hpY2gNCj4gd291bGQgbGVhZCB0
byB1c2UtYWZ0ZXItZnJlZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9s
aSA8bmljb2xhcy5mcmF0dGFyb2xpQGNvbGxhYm9yYS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91
ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDg3ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0t
DQo+IC0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDU1
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1l
ZGlhdGVrLmMgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCA5
YzBhYzcyZDZlNDMuLjg4OWExZDU4YTA0MSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9z
dC91ZnMtbWVkaWF0ZWsuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5j
DQo+IEBAIC0yMzUzLDc0ICsyMzUzLDQ5IEBAIE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIHVmc19t
dGtfb2ZfbWF0Y2gpOw0KPiAgICovDQo+ICBzdGF0aWMgaW50IHVmc19tdGtfcHJvYmUoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIHsNCj4gLQlpbnQgZXJyOw0KPiAtCXN0cnVjdCBk
ZXZpY2UgKmRldiA9ICZwZGV2LT5kZXYsICpwaHlfZGV2ID0gTlVMTDsNCj4gLQlzdHJ1Y3QgZGV2
aWNlX25vZGUgKnJlc2V0X25vZGUsICpwaHlfbm9kZSA9IE5VTEw7DQo+IC0Jc3RydWN0IHBsYXRm
b3JtX2RldmljZSAqcmVzZXRfcGRldiwgKnBoeV9wZGV2ID0gTlVMTDsNCj4gLQlzdHJ1Y3QgZGV2
aWNlX2xpbmsgKmxpbms7DQo+IC0Jc3RydWN0IHVmc19oYmEgKmhiYTsNCj4gKwlzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwaHlfcGRldjsNCj4gKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmcGRldi0+
ZGV2Ow0KPiArCXN0cnVjdCBkZXZpY2Vfbm9kZSAqcGh5X25vZGU7DQo+ICAJc3RydWN0IHVmc19t
dGtfaG9zdCAqaG9zdDsNCj4gKwlzdHJ1Y3QgZGV2aWNlICpwaHlfZGV2Ow0KPiArCXN0cnVjdCB1
ZnNfaGJhICpoYmE7DQo+ICsJaW50IGVycjsNCj4gIA0KPiAtCXJlc2V0X25vZGUgPSBvZl9maW5k
X2NvbXBhdGlibGVfbm9kZShOVUxMLCBOVUxMLA0KPiAtCQkJCQkgICAgICJ0aSxzeXNjb24tcmVz
ZXQiKTsNCj4gLQlpZiAoIXJlc2V0X25vZGUpIHsNCj4gLQkJZGV2X25vdGljZShkZXYsICJmaW5k
IHRpLHN5c2Nvbi1yZXNldCBmYWlsXG4iKTsNCj4gLQkJZ290byBza2lwX3Jlc2V0Ow0KPiAtCX0N
Cj4gLQlyZXNldF9wZGV2ID0gb2ZfZmluZF9kZXZpY2VfYnlfbm9kZShyZXNldF9ub2RlKTsNCj4g
LQlpZiAoIXJlc2V0X3BkZXYpIHsNCj4gLQkJZGV2X25vdGljZShkZXYsICJmaW5kIHJlc2V0X3Bk
ZXYgZmFpbFxuIik7DQo+IC0JCWdvdG8gc2tpcF9yZXNldDsNCj4gLQl9DQo+IC0JbGluayA9IGRl
dmljZV9saW5rX2FkZChkZXYsICZyZXNldF9wZGV2LT5kZXYsDQo+IC0JCURMX0ZMQUdfQVVUT1BS
T0JFX0NPTlNVTUVSKTsNCj4gLQlwdXRfZGV2aWNlKCZyZXNldF9wZGV2LT5kZXYpOw0KPiAtCWlm
ICghbGluaykgew0KPiAtCQlkZXZfbm90aWNlKGRldiwgImFkZCByZXNldCBkZXZpY2VfbGluayBm
YWlsXG4iKTsNCj4gLQkJZ290byBza2lwX3Jlc2V0Ow0KPiAtCX0NCj4gLQkvKiBzdXBwbGllciBp
cyBub3QgcHJvYmVkICovDQo+IC0JaWYgKGxpbmstPnN0YXR1cyA9PSBETF9TVEFURV9ET1JNQU5U
KSB7DQo+IC0JCWVyciA9IC1FUFJPQkVfREVGRVI7DQo+IC0JCWdvdG8gb3V0Ow0KPiAtCX0NCj4g
LQ0KPiAtc2tpcF9yZXNldDoNCj4gIAkvKiBmaW5kIHBoeSBub2RlICovDQo+ICAJcGh5X25vZGUg
PSBvZl9wYXJzZV9waGFuZGxlKGRldi0+b2Zfbm9kZSwgInBoeXMiLCAwKTsNCj4gKwlpZiAoIXBo
eV9ub2RlKQ0KPiArCQlyZXR1cm4gZGV2X2Vycl9wcm9iZShkZXYsIC1FTk9FTlQsICJObyBQSFkg
bm9kZQ0KPiBmb3VuZFxuIik7DQo+ICANCj4gLQlpZiAocGh5X25vZGUpIHsNCj4gLQkJcGh5X3Bk
ZXYgPSBvZl9maW5kX2RldmljZV9ieV9ub2RlKHBoeV9ub2RlKTsNCj4gLQkJaWYgKCFwaHlfcGRl
dikNCj4gLQkJCWdvdG8gc2tpcF9waHk7DQo+IC0JCXBoeV9kZXYgPSAmcGh5X3BkZXYtPmRldjsN
Cj4gKwlwaHlfcGRldiA9IG9mX2ZpbmRfZGV2aWNlX2J5X25vZGUocGh5X25vZGUpOw0KPiArCW9m
X25vZGVfcHV0KHBoeV9ub2RlKTsNCj4gKwlpZiAoIXBoeV9wZGV2KQ0KPiArCQlyZXR1cm4gZGV2
X2Vycl9wcm9iZShkZXYsIC1FTk9ERVYsICJObyBQSFkgZGV2aWNlDQo+IGZvdW5kXG4iKTsNCj4g
IA0KPiAtCQlwbV9ydW50aW1lX3NldF9hY3RpdmUocGh5X2Rldik7DQo+IC0JCXBtX3J1bnRpbWVf
ZW5hYmxlKHBoeV9kZXYpOw0KPiAtCQlwbV9ydW50aW1lX2dldF9zeW5jKHBoeV9kZXYpOw0KPiAr
CXBoeV9kZXYgPSAmcGh5X3BkZXYtPmRldjsNCj4gIA0KPiAtCQlwdXRfZGV2aWNlKHBoeV9kZXYp
Ow0KPiAtCQlkZXZfaW5mbyhkZXYsICJwaHlzIG5vZGUgZm91bmRcbiIpOw0KPiAtCX0gZWxzZSB7
DQo+IC0JCWRldl9ub3RpY2UoZGV2LCAicGh5cyBub2RlIG5vdCBmb3VuZFxuIik7DQo+ICsJZXJy
ID0gcG1fcnVudGltZV9zZXRfYWN0aXZlKHBoeV9kZXYpOw0KPiArCWlmIChlcnIpIHsNCj4gKwkJ
ZGV2X2Vycl9wcm9iZShkZXYsIGVyciwgIkZhaWxlZCB0byBhY3RpdmF0ZSBQSFkNCj4gUlBNXG4i
KTsNCj4gKwkJZ290byBlcnJfcHV0X3BoeTsNCj4gKwl9DQo+ICsJcG1fcnVudGltZV9lbmFibGUo
cGh5X2Rldik7DQo+ICsJZXJyID0gcG1fcnVudGltZV9nZXRfc3luYyhwaHlfZGV2KTsNCj4gKwlp
ZiAoZXJyKSB7DQo+ICsJCWRldl9lcnJfcHJvYmUoZGV2LCBlcnIsICJGYWlsZWQgdG8gcG93ZXIg
b24gUEhZXG4iKTsNCj4gKwkJZ290byBlcnJfcHV0X3BoeTsNCj4gIAl9DQo+ICANCj4gLXNraXBf
cGh5Og0KPiAgCS8qIHBlcmZvcm0gZ2VuZXJpYyBwcm9iZSAqLw0KPiAgCWVyciA9IHVmc2hjZF9w
bHRmcm1faW5pdChwZGV2LCAmdWZzX2hiYV9tdGtfdm9wcyk7DQo+ICAJaWYgKGVycikgew0KPiAt
CQlkZXZfZXJyKGRldiwgInByb2JlIGZhaWxlZCAlZFxuIiwgZXJyKTsNCj4gLQkJZ290byBvdXQ7
DQo+ICsJCWRldl9lcnJfcHJvYmUoZGV2LCBlcnIsICJHZW5lcmljIHBsYXRmb3JtIHByb2JlDQo+
IGZhaWxlZFxuIik7DQo+ICsJCWdvdG8gZXJyX3B1dF9waHk7DQo+ICAJfQ0KPiAgDQo+ICAJaGJh
ID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7DQo+IC0JaWYgKCFoYmEpDQo+IC0JCWdvdG8g
b3V0Ow0KPiAgDQo+IC0JaWYgKHBoeV9ub2RlICYmIHBoeV9kZXYpIHsNCj4gLQkJaG9zdCA9IHVm
c2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiAtCQlob3N0LT5waHlfZGV2ID0gcGh5X2RldjsNCj4g
LQl9DQo+ICsJaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiArCWhvc3QtPnBoeV9k
ZXYgPSBwaHlfZGV2Ow0KPiAgDQo+ICAJLyoNCj4gIAkgKiBCZWNhdXNlIHRoZSBkZWZhdWx0IHBv
d2VyIHNldHRpbmcgb2YgVlN4ICh0aGUgdXBwZXIgbGF5ZXIgb2YNCj4gQEAgLTI0MjksOSArMjQw
NCwxMSBAQCBzdGF0aWMgaW50IHVmc19tdGtfcHJvYmUoc3RydWN0DQo+IHBsYXRmb3JtX2Rldmlj
ZSAqcGRldikNCj4gIAkgKi8NCj4gIAl1ZnNfbXRrX2Rldl92cmVnX3NldF9scG0oaGJhLCBmYWxz
ZSk7DQo+ICANCj4gLW91dDoNCj4gLQlvZl9ub2RlX3B1dChwaHlfbm9kZSk7DQo+IC0Jb2Zfbm9k
ZV9wdXQocmVzZXRfbm9kZSk7DQo+ICsJcmV0dXJuIDA7DQo+ICsNCj4gK2Vycl9wdXRfcGh5Og0K
PiArCXB1dF9kZXZpY2UocGh5X2Rldik7DQo+ICsNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0KPiAg
DQo+IA0K
