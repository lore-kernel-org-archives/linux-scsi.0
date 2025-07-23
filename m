Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C579019C54B;
	Wed, 23 Jul 2025 09:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753263253; cv=fail; b=uRVwlk4HAFtvgcnSB1B4QIfflFKBdkohWfgagzqr9ld+Pp452T8BeXYTGtN/iut7z3cKSUZr9iikPLILx1LtE9ADYF4/bk8s7Rl0O7Jz+ActF90EkGZl/kjgl4kgi7CmhtfV5/Xzramx5sKAFDpGOq2dBv3/D7UdpA/m9ajdd/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753263253; c=relaxed/simple;
	bh=YNphrEziXknCBPF9wFsXhgGVQwvNw+lvtV+0rRVUps4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dyrJwIN7pL/QRcV+VLdg0M85iHzorybUIjhkXWWfYaPZFEluY+XSy7xWoZJYntCyfdq34yZkMEOcY97cTe8N2SMUf1ic6uBd8b8qYq/xYAGYPANGpcJ73IPXjOv0xCnsgO/E61fOYvNQuUSru62rcv60qrK8CBdYuYk1r6uGfSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XLVNmGq9; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Z7SC05Wh; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XLVNmGq9";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Z7SC05Wh"
X-UUID: 2bd87e3067a811f08b7dc59d57013e23-20250723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YNphrEziXknCBPF9wFsXhgGVQwvNw+lvtV+0rRVUps4=;
	b=XLVNmGq99VMMyUw+YhNfvQDKKzJ1DKM39Bx6eI6ENif9AXUdTRwWa0ZCgJRv9buo7kf/UeupypCbXbfbtTrVPY6Kjl0Z1JelXjIcm5FLuXh/PiY62n9uY0/niSyYyRphQzF9T75gkCktIQNXgOoyctVHsSHwSflYyijc7x8w9jA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:50cfbe46-97e2-4902-8cf3-7e2d127a2e9b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:affd160f-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2bd87e3067a811f08b7dc59d57013e23-20250723
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 246575302; Wed, 23 Jul 2025 17:34:03 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Jul 2025 17:34:01 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Jul 2025 17:33:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hNWORnU3vrP9xCsfaQVORdybv4T+9KTmPt2l87tzim1qvqweUtPWWXMmvhmq1lafUn7Ln3Ow7HpJQoeqR7sALeCHtZMN49EoVQ1T+wi3Qg27VEOoGrFWcB8voWqlajnyapBS64f7A+MZ85q5f8QXNZTD8vubddvBLr+lomdttqAcoz2qWqVCTAO6I+2t9w+buGMaeIms6nOigOdnat5/yjD4tjQ8vc6KJCBQ47//RiI/aKfDp/ADkgdSsyrcZwaQ003JWjI2ceTQsySkxQFGVST0N+HEjWnpEEGNwKaHc7pSKYzpzvVDF1zZQxFHtKuyW32hGi32QGsscNrsDHHOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNphrEziXknCBPF9wFsXhgGVQwvNw+lvtV+0rRVUps4=;
 b=WSkMSztF31Msp6Dgb/s+dv0Y4lncdUeoc5fgVtHMzxruPC6KcH/KeK0aB5IB0HXcFOib7DzsfbrkLW77U9VGa8O1F7bqMqZ0UYTYkMs3xhWl03iF1fSX4pCXpywUKYMKXiypb1cbEZkNAFHaCJPCzcjzEC0qqylzo/KyboYQG1ZMaVWGZwUOcuRVJ6lNQRcfb+jhV8cZEWsKDoQBTAwg1bZ5i5+XBhasiQyO4Tj/T597ol4/ZMxFfkZVifkrlKtLPoIhDVwRoGcV2BPSgaNAsaoQFmOYThX5vEhwFOepZN7F2kgyqsUe9xKsPmDOi/xqbfyg8paRBaRhQ5MFPLJEJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNphrEziXknCBPF9wFsXhgGVQwvNw+lvtV+0rRVUps4=;
 b=Z7SC05WhKcgJOZO0jNNYY4G23cr1Kcl6Y0JVljcF98yrv7dh1lLeuwRZEC+f2o5l/l0zD6odolF7qCOWmrIw7Rqv56gASug3eYJkAczpGmXyl+/qvYYm1/770WOXmlN+rC6M5IMrLJXSLsS333KeXOBlh6njnI7gJqWBsdtsR4I=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7709.apcprd03.prod.outlook.com (2603:1096:400:421::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 09:33:59 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 09:33:59 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?=
	<Macpaul.Lin@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "macpaul@gmail.com" <macpaul@gmail.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, =?utf-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?=
	<pablo.sun@mediatek.com>, Project_Global_Chrome_Upstream_Group
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?utf-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
	=?utf-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>
Subject: Re: [PATCH v2 2/4] dt-bindings: ufs: mediatek,ufs: add
 ufs-disable-mcq flag for UFS host
Thread-Topic: [PATCH v2 2/4] dt-bindings: ufs: mediatek,ufs: add
 ufs-disable-mcq flag for UFS host
Thread-Index: AQHb+ubX71wq+ibKQ0mngqG4aIZ29LQ/dAYA
Date: Wed, 23 Jul 2025 09:33:59 +0000
Message-ID: <4241894298ef926736fbf25fe6b2a3f51197f001.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-2-macpaul.lin@mediatek.com>
In-Reply-To: <20250722085721.2062657-2-macpaul.lin@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7709:EE_
x-ms-office365-filtering-correlation-id: b2f3917b-8f45-49cf-d9aa-08ddc9cc0d57
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WmQ2TzBBUVBlQ3lKd2Z5N3hId2p4TWxiUTA1d1Q1Z01OV3hVNGhFdUZjRTNm?=
 =?utf-8?B?RGZLdWgzaStLdVVBVDhBSkoxSEhNYW9HdU5ncFUvYTdkR3NNYUtXb2s2Z0Q4?=
 =?utf-8?B?OFpSc09VTnNndzhRNUV1T2RucTQxUkh1TzBTM1ZhQWthMjdiOHNLVk16bjgv?=
 =?utf-8?B?YnNhZXJGTk5ZU0Q0VGJpT1N5dzZkTENOaGpvK1ZBVUoxdUtEWTN3TThkUnRS?=
 =?utf-8?B?d0hoZGhiR3hsaHVSZ1dwd0xpUzlZTzFneVoyTFhmSmtLVXRzUGRCUFh5M3l1?=
 =?utf-8?B?dHVJR0xscjFyYnBacWN5blAwNTZjUDhzOG9wZmxkS0RlRjZXc0VMb0ZTMFVI?=
 =?utf-8?B?WXplM1lUK2xYU2gyVkxUQkJHenBaQTRHck9DSmEzQnROY1NaNmRmNWpxak5j?=
 =?utf-8?B?V3dkRFJtMW1HNk1RMlRGZUdyaHNwb3lxT2VENUZjVGxNbzUrU1BtVTlNV3Zt?=
 =?utf-8?B?Wjc5YXVCTWNTYUM3b3p6NUNnRFkxSE5WRm5Fc05vQmlYNnRuUFBxc0VLUmto?=
 =?utf-8?B?MWtBRjl6ME82aWYvNTJuTWx6ZnZ1QkJuWktWYVJXMXRYVkFzUVdMT1Zid1M3?=
 =?utf-8?B?aFU5bjlRTU5mQUlVN211QmFPQWp6RnR4RnViaEFSMS9vTWduZkZkbUNLYmNi?=
 =?utf-8?B?ZFVORjk0SjBuN3JkdkpnOEVKVHQvdWs5VVF4dnpDZTBQamcvNUNPeXlIMVgw?=
 =?utf-8?B?dFM2YzRodXUvMElicFRTWEVrdXVvNmxrVnBzc0hES05aOXFmcTJlQ2pEUzd6?=
 =?utf-8?B?ZExwTzdQazg5d1hCTFhVd210dVpaZTNZU1VxWFl3NTFwRkJzN2ViZmdSRmgv?=
 =?utf-8?B?OEJVMVp4dmg1L1FUeXdzV3dhZ24xeUVhRTFaKzU0aFBkZk9uaUx4U0V0Z25Y?=
 =?utf-8?B?bXA0SmRXU3VPTTJSc3hINzRMVTRXUER0b25EaE8wWFRTRklXQlovR3RNVElZ?=
 =?utf-8?B?YzJuVkFnRTlnSjZuUW5qNWRJZzJjN0wzZzhMQ01TWmdUQ05Ib2tqaVdMeE5E?=
 =?utf-8?B?aHY4cm04dVI0NGZlUEpxTk1PVElRUWIxMmFaUG9EWlJPb1hmZFNpTHNVT3RG?=
 =?utf-8?B?Q3U2OWZyQUNORFFDS1FqeWlud3UvT002UEZvYmdsUXIwVmVVaW5lZjJWYVl4?=
 =?utf-8?B?WldZZDIyYm9CcU5ieWtoZVp2VlVUalR3TU1vb09sWjdLYVVJajhvN3ZlT3JD?=
 =?utf-8?B?TkM4UkpENGNya0F2Ylpmd2hHMnUrUFViSVV4WGtlOEZXV1hiU0tKU05xL3ZT?=
 =?utf-8?B?Smp1OHZFM24yVDJkS2xqc3dWaTFoNnVnVkV0c1NXejkrL0o1OWtUelV0Q2Q3?=
 =?utf-8?B?Y3NTNmVLaW1UK2ZhUHkwTE5ML2JvUzBrRDdsekFVSU85UDRmcmhCUHMxY2xq?=
 =?utf-8?B?a0JtZWtTOW40emZqVysvNnYzRWVHSFU3Skk2MnczdXUzVTluWjJjcXN0Y2V2?=
 =?utf-8?B?anRFZXRSOVo3ZW1UdEhPMWp2b3hSS1FTL3pZT2ljb1NBQytvTlB2NDd0bCtJ?=
 =?utf-8?B?Z1E2TmdEMUVMOTlidVlDMUJNbmVLU0ovdllJWnNzRTdUSlMxay9MVDBZS216?=
 =?utf-8?B?aWh0ZitHNlI4NkVMRVNQUnlHREk3NnVJZVpjK1R5N29VZTJGdjR5YWYrcTk4?=
 =?utf-8?B?T0FRK3NZYjVaV2NuL0JqZWpZaVhhU3M4OXMrbnlvVk9zcVk4OTd2dUlvSUUw?=
 =?utf-8?B?aHlYSlNDcldSL0VFaWFqM29UemxYRlRQeTlmcHR2OTBNaFBGYUF6Tjh5dVFp?=
 =?utf-8?B?VHJwN0c2N1BBME9TQmY4d1o4YjVwcjRJMDlXSENTVmJPZ1BtdUpETWgrTlUw?=
 =?utf-8?B?Z1lYNHBNd0ZjWG1vOHRSSmVwNmx6SjBBMko1czdIVWVJU0dHSGZSRFRSWWxS?=
 =?utf-8?B?V01xUWhUUW8rYXNxN09FZFJsZDZlRnBXbG9NWUc1blY0MElkNFF3c2pMZnNw?=
 =?utf-8?B?eGdXSGlSejZNZVR6Z2FwRklwM21kclNjcGI3Rk9McE9OWEdEZDNGWU9VRHY0?=
 =?utf-8?Q?uxoaMvMOBTkFppHbznrvUVecmCYEjA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTk0MUdBQk0vQ2VubWZpY0cvZE1DR3k5OXFiS25Cek1TSTV1cncrTFh3SjVF?=
 =?utf-8?B?SlBzb0VkUVBGVVc0c0dXY0kxSS9sbStGS3pmcS9BQWJCaEs4cXQzL3E1QnQ0?=
 =?utf-8?B?MTB3cGVKWGpmRGwrZ3AwZjlYc1V0N1JBUVBwenRCTUh3Q2p5MzV3c1E3ZGx3?=
 =?utf-8?B?TFAvc3haNnJjU0dDTHFlMEs4L2FvTit2b0VaZUp0VmtsbDErTnIyVmtqaEdl?=
 =?utf-8?B?ZXJWbVdScG5vUXRHcDVjSWdiOUdrMEwxam9BclZnd24rZjRHYWFzS3gwZXpy?=
 =?utf-8?B?N1RpYzhhT1VpZUdka2s3SzZWMHV0OENNQnlTWXFOYk51cUh3ajVlMlZ2NkJx?=
 =?utf-8?B?endrNXMzTjBQRGxzUXNBN2NoM0ZFeWM5dXNpNEpoWGNlcjBTUERBbnJ3SXND?=
 =?utf-8?B?R2RkOGVQbkhyMXBsVUhId1BMc0ZtR3RMajk5WEZSREhzQWtqQS9tQzRmcTRS?=
 =?utf-8?B?T1RmZUhhSVhNV0g4QzNlUEZtS0xuRjBhZE1sbGt0MWFQaGltNENvcDBWOWZW?=
 =?utf-8?B?RlJJVTFEOHdBTWFvRU9wV2JOM1gxUnd4eVBHeGNnT2NLREsvdnBobTdma3Er?=
 =?utf-8?B?YmZJb3h3K28xeENvaDNCeFBxQitQTWZQNDFTSE9YSS9tcWZlbGUrS0RHbG5S?=
 =?utf-8?B?MkplYzl3L281c1J6NHpocjN3OGJ4OGdidDJ6MHVFL2JkYXlCWVZmRTNOYm5T?=
 =?utf-8?B?emlEeWpRK0R6WjlvOHBxUjYrTmJLcEloYnFJVnhOS1BoblBnRXdJVHR2YXp0?=
 =?utf-8?B?UE9mM28xWGhBZlppYnNLUHZ4eGlMdGl2QzBhSW5QZTgwTTNKOWpBemRydXdy?=
 =?utf-8?B?b1NrK1JqQUVDbnlSV1hURWU4enRseTVYRkd6LzhCMEVrSE1CSlVTQjR4TC9C?=
 =?utf-8?B?eDcrUTUxdjdacUYxSHc5YkZ6b3ZwVlFhdlVZaWU0V3NCbkl1MGFwQWZMVUFQ?=
 =?utf-8?B?ZlZ3Ykllb3J5MFlydGtaR1IzWll1dlJZWHlUMFZZL3FTZUxqalpkaGRiT3J5?=
 =?utf-8?B?dyt4Qy8wdWdiWHZFVU9UVlNJTUFyUy8ySTg1bUZBbTdtbml0dEFrSXhtcFNK?=
 =?utf-8?B?RCtjMUNkMDVHS2kyZkpFN2VXRnl6bGYzVnJzUEpKcUpiT0tIOXp0UDFHb0Jv?=
 =?utf-8?B?V0o0WSsxa1dqRGtYWitOckgrVlRQT2NESTBlbGFEWXdYY0tSZDlQU0lZN0xS?=
 =?utf-8?B?dGtEYU1DZGpLRjRZQ24vdlI0TU54aTRDc084eWc1WlhrQzIzc1JoOGdwT2pG?=
 =?utf-8?B?cUIvem9zblZXSDBRTExKdk5yMkU4amhiSlp3b0xhS1dFNmRYVkh5U21DYnpX?=
 =?utf-8?B?VE84VDA2VGhRWEw2cTR2bENmeUNwaENyM3JKRWozL0MrcUxqSERyQ3M0aEFo?=
 =?utf-8?B?eUFxaXVuR1RSSndUK1d6TG80T0NQMnZZVWg5eEFwbXhjam1VTEV4cWF0aWtL?=
 =?utf-8?B?M241eElCOGFBc2dmMTBVbWYxNFByZVJBUGNkRDczVG05THRnSUZVSnZPS0xF?=
 =?utf-8?B?TVJOYlRQQi9oVkhENVNkd1BsVVJFODFwcEpZdTZya0NHYnlvVGkwMk9oMlIy?=
 =?utf-8?B?eGY4L1lCa0Y3MlJVZXNTQVlQSFNDM0hJcnFuR1JmV3NZN0ZWK3lZMnRSdGNU?=
 =?utf-8?B?bDNmemU3TStHRGorc2o1RndMVFBUMW5UbkJVVXl1eitKa05xYksrU0p2NHhI?=
 =?utf-8?B?SmE2UHF2alBQdms2bEJWVm5EM1plcU9XWmtMejBJSThVS29jUW40WkFwNm1s?=
 =?utf-8?B?elFXUGdTSWtyNDVmTkZUcktHalBDVTEzS3Eza3l1b1hVbEtBUTBPTklDOENM?=
 =?utf-8?B?Rk1MMU1idGRDY3VmdDFVL1NiOWhIQzMrbUNLeDdsTWc1LzZHcUtxTzNJejk1?=
 =?utf-8?B?YjN5aFdPRlpDLzhiWVh2T0cwWDFhc2lJVHlzbG03elRISnhmRWlBelNHYXpD?=
 =?utf-8?B?NStObzJKZDdYaVNmY3R2WWlxQlNCQUxUTHpPalkrTkdOVVU2WmJLSnJnSExL?=
 =?utf-8?B?YWNucWZneEVKVGF6bnA0MS9nK2RIRE9YcnlxNUg0c3ZEWDl6VmROMDVsdWRG?=
 =?utf-8?B?aEFSSlNmbGRFZ05PUFloSDN6Q3NpK0tKZDZKUTJyNlo2WTBMeThPZlhiMzhI?=
 =?utf-8?B?Rk05cjhRZzB6RTNQS1JGdERJUHJ0RWV1dkd3ZUwxU3ZERWFTeTkrV1Uwb09P?=
 =?utf-8?B?Mnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1217D081FC0CB94DA2F241F677A7151D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f3917b-8f45-49cf-d9aa-08ddc9cc0d57
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 09:33:59.0272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ALURaVeH+OnPLzeEZqfooKOSOXBLaSOP4+tkbkPEilny/eSgMAMcB5eZm3hcDH700LwP4SXkdstzMY5wB3uNVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7709

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDE2OjU3ICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
QWRkIHRoZSAnbWVkaWF0ZWssdWZzLWRpc2FibGUtbWNxJyBwcm9wZXJ0eSB0byB0aGUgVUZTIGRl
dmljZS10cmVlDQo+IGJpbmRpbmdzLiBUaGlzIGZsYWcgY29ycmVzcG9uZHMgdG8gdGhlIFVGU19N
VEtfQ0FQX0RJU0FCTEVfTUNRIGhvc3QNCj4gY2FwYWJpbGl0eSByZWNlbnRseSBpbnRyb2R1Y2Vk
IGluIHRoZSBVRlMgaG9zdCBkcml2ZXIsIGFsbG93aW5nIGl0DQo+IHRvIGRpc2FibGUgdGhlIE11
bHRpcGxlIENpcmN1bGFyIFF1ZXVlIChNQ1EpIGZlYXR1cmUgd2hlbiBwcmVzZW50Lg0KPiBUaGUg
YmluZGluZyBzY2hlbWEgaGFzIGFsc28gYmVlbiB1cGRhdGVkIHRvIHJlc29sdmUgRFRCUyBjaGVj
aw0KPiBlcnJvcnMuDQo+IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBGaXhlczog
NDZiZDNlMzFkNzRiICgic2NzaTogdWZzOiBtZWRpYXRlazogQWRkDQo+IFVGU19NVEtfQ0FQX0RJ
U0FCTEVfTUNRIikNCj4gU2lnbmVkLW9mZi1ieTogTWFjcGF1bCBMaW4gPG1hY3BhdWwubGluQG1l
ZGlhdGVrLmNvbT4NCj4gLS0tDQo+IMKgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L3Vmcy9tZWRpYXRlayx1ZnMueWFtbCB8IDQgKysrKw0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKykNCj4gDQo+IENoYW5nZXMgZm9yIHYyOg0KPiDCoC0gU3BsaXQgbmV3IHByb3Bl
cnR5IGZyb20gdGhlIG9yaWdpbiBwYXRjaC4NCj4gwqAtIEFkZCBkZXBlbmRlbmN5IGRlc2NyaXB0
aW9uLiBTaW5jZSB0aGUgY29kZSBpbiB1ZnMtbWVkaWF0ZWsuYw0KPiDCoMKgIGhhcyBiZWVuIGJh
Y2twb3J0IHRvIHN0YWJsZSB0cmVlLiBUaGUgZHQtYmluZGluZ3Mgc2hvdWxkIGJlDQo+IGJhY2tw
b3J0DQo+IMKgwqAgdG8gdGhlIHNhbWUgc3RhYmxlIHRyZWUgYXMgd2VsbC4NCj4gDQo+IGRpZmYg
LS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21lZGlhdGVrLHVm
cy55YW1sDQo+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRl
ayx1ZnMueWFtbA0KPiBpbmRleCAzMmZkNTM1YTUxNGEuLjIwZjM0MWQyNWViYyAxMDA2NDQNCj4g
LS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMu
eWFtbA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21lZGlh
dGVrLHVmcy55YW1sDQo+IEBAIC0zMyw2ICszMywxMCBAQCBwcm9wZXJ0aWVzOg0KPiDCoA0KPiDC
oMKgIHZjYy1zdXBwbHk6IHRydWUNCj4gwqANCj4gK8KgIG1lZGlhdGVrLHVmcy1kaXNhYmxlLW1j
cToNCj4gK8KgwqDCoCAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy9mbGFn
DQo+ICvCoMKgwqAgZGVzY3JpcHRpb246IFRoZSBtYXNrIHRvIGRpc2FibGUgTUNRIChNdWx0aS1D
aXJjdWxhciBRdWV1ZSkgZm9yDQo+IFVGUyBob3N0Lg0KPiArDQo+IMKgcmVxdWlyZWQ6DQo+IMKg
wqAgLSBjb21wYXRpYmxlDQo+IMKgwqAgLSBjbG9ja3MNCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdh
bmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0K
