Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B94352018;
	Fri, 29 May 2026 07:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040734; cv=fail; b=s3FgujS5fueRyJgB3Oqq7A0mIM/9TXOz1AoTh0PKvOxi8CnjP6xf01x/W76p6PcXnWiG+9gT1RWTZLCXUFMKmAO6XL0xfDe2qOquYGovp9Q9xb4wPHp0GXm/8vsV/AysFiTJ4zVqWZUaIPjsyzlWSJxaEZNer0Sy6d5H6o+rmtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040734; c=relaxed/simple;
	bh=m+LO6dGdTlcHe8HRovLS6jMgohbAueXIbvs+khBwmKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IzQdx/sDH2lYi43txR3yRlVG3HZH9/QoiNsUVJjSIcATopQ2cPgJhAU9hb+KlFuN3bXyccLavJJcx25V0N7itX5ediewOk8XMgMBf/VtDNdKiicqK0Zi4iDBGs/rQSCMCtaDmeDexZ27ZGvkBR9VAYdVuT7PSta/QL8hffXNmCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gUT19h5Z; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=d6WO18IN; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gUT19h5Z";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="d6WO18IN"
X-UUID: 59f98d945b3211f18dc8c9802ae25ab1-20260529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=m+LO6dGdTlcHe8HRovLS6jMgohbAueXIbvs+khBwmKU=;
	b=gUT19h5Zq52lwroFW5qf98dr/2z8xOYvHEXeTWmZmL7FZX1Q3YumIYKwGO05QUFGHS/Ag47nlF1Lhiqr/JHcr93/8pppkUJ9JCC4eeh3q4EKrNI9b+nvNdJqptBCnx2dixiKD142Xs3M4ev04SaLRoo4KdDDCQc6ncIszMmsH+M=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:06060d38-95f7-4c37-a142-f5e3ea5230e6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:1cfac34a-0449-4a87-afcf-cdef1b1bea20,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|136|836|865|
	888|898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,Q
	S:nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 59f98d945b3211f18dc8c9802ae25ab1-20260529
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1853095386; Fri, 29 May 2026 15:45:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 29 May 2026 15:45:22 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 29 May 2026 15:45:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1Lz+8ajZmF9wgKod+k5iD6zczL+h38IdoO4Y67nIqQxjgStVg/kZEl3vWyTetHFJCDismuoyFD82w9QiDTUc9mpV90muHqPmiD4eVy242W+46xVm/hU5DICm5nf7U5Fi963avuPIwY4ECMKTPQx0hNS8rpqAdJFro1Cpdexl5kFzTF9dOrk1pZ7celJkQUNhc7t+wV8VFjxtsbpD2AXIhZyQJajE2XRqST4xJaPyv06RGo3DljGS8f4ZCo/OQUwSDm8jEa+HpMs2OGdSciKVyj3gxQIsg20DpIHFiidWDl3NeuHL75y1lAd4EqeWGBiSeyOd3pO4kvzw+OpsUrKxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+LO6dGdTlcHe8HRovLS6jMgohbAueXIbvs+khBwmKU=;
 b=mC0U85q5rQS5uxIWsozjc+gubKzf+hculbm0dCy/7VInwgNsLMEzZwyi0FAvB847D8SZShio7dGjiMOQzj/Mg3qIDs4gk2OzxRcoX2U+P6r7YNWTl7d0vemZxeZgGmHNJyAKn0ILjUdlZPZ3/K00P+AGtrJ2AR+xroYxAOGjxsATGLwCqbAN33pUkg42KIaqUuBE8rQumlnYPuWS36oPBcFNcZa0xcEBgatK1KLCTsmVCElcLNnzGtU+CMp+tmi7PFDy0Wrqc9DU3TAESkDZxi0bMOiM0m+riVZevGP8u3TytVtqiDVBeH26D0fV81+cZBSg5bmn07AgkTIR8HzbXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+LO6dGdTlcHe8HRovLS6jMgohbAueXIbvs+khBwmKU=;
 b=d6WO18IN3Jq6JxuYv3RPRVl/UDpZzMnDfbHBFDH/aSJqtvnJ6cnJcPOyln9OT3ZAKH6Yr1R6ugkY4CNavf8iJ14swUNUN5AJXW+iFC4hxlpeRo6E0FcT2NgeVXYfObdKd08Fz6JIWhOYXVfTd0Z0g57GJIjApR3ZlS7jS/0XcSM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYNPR03MB10153.apcprd03.prod.outlook.com (2603:1096:405:3c6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.4; Fri, 29 May 2026
 07:45:20 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.004; Fri, 29 May 2026
 07:45:20 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "zhml@posteo.com"
	<zhml@posteo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"robh@kernel.org" <robh@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Thread-Topic: [PATCH v5 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Thread-Index: AQHc7wiaaOVK/QWcZEaefePZloua0bYkoCCA
Date: Fri, 29 May 2026 07:45:20 +0000
Message-ID: <501287b3891c9be481cc7201a1c9478c73f9825d.camel@mediatek.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
	 <20260529011421.462046-2-can.guo@oss.qualcomm.com>
In-Reply-To: <20260529011421.462046-2-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYNPR03MB10153:EE_
x-ms-office365-filtering-correlation-id: a540a3fe-0727-416f-a158-08debd563bd0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700021|22082099003|18002099003|4143699003|56012099006|11063799006;
x-microsoft-antispam-message-info: Zhjx0wn23juwEC2R1m+GQuAsvmpXeUMqmoKDV8NNXwsD9/OrdMhChzrVQjLEKwwlDEm710xQ6AbY798hPRuiu/kIKWz7XMPvKHVjOF/NCTMyrodpM2GxV1nupC2Sa2VDJbTySXBQNW/dqtlwH/qajnJqQgzroAIraWWClnMdYvRn1p9XpGvuvGAZjbmGPR3EbXZeHm+Ek/LnG5rE4hHWYQ+0V/TKepYUE1NMwz0IUl1zsg+bI6pUaFgVq7TWVnVdJ8bZ4eyeFtGLGN4xVmLCumBIGR6RtJY2f2ZbC2wULkgTKcXGi8h8lwwjozsGxpkB8GTWbpp4W9mE//ohZG8Q8K0nuMBkZXAT0BpnP65lIdlY5ZO3HLmhX1VbDlk7y58KySIxDTc4bA1t4g90spriXQ6F2nCina3AISKIobicyupOr50YEYFHywM52ILvlgAgL9zFZYFvWLxz95REe/0Nv2VrslBnvUjKtx2wnxWfmq6kMO2RsFLdk5Gwb8vMrwp1dyQjN40bgFXG6J35KIMzXQmGK/B6Ogm6LxWBrlDPlhze7HQPVEWyVqR1/gsqaqlDp6Yac2XR6cgsVT5+zi0VgbOyZe6EmcPlHTKLXF836ySxOlMrdcMI0L+b1+vLPuTYW6Qe1TLFaFO//IGquBfWa1ytDP71Dzz0+nQYTrCHjDa9G6tFEPhEAKdWEUhEXN1RjNYFlYDenaH1cz9euT4yzAzDyrV+0JHj+LPNxXYMNy8A6f3xyXxgtJg3oqHTrRaA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700021)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmlPWU93ZHJKWEJ0djg4TmdqMzlzRTkwMFNqRkdtaTZWUEptOGNEblJyRTU5?=
 =?utf-8?B?ZG4zZENrbFg3VytualExY2ZoakNMamNWWEoxWWdsenF5UHAwNzNLZ1VUckpY?=
 =?utf-8?B?a3IwVGdEQVkvaXlKMytkRHVuc3RlZGRBUFdSYzBwNXhNVjlVU0NFVXpxc0Z6?=
 =?utf-8?B?YzhjZkhDaGtUdk5pQU1QeklyNXl4N3VFYVJQMWY0eU90Y2ZZRWFmRkpYZSto?=
 =?utf-8?B?b20vTHJpTnZHL1lscm01V053RUc2QU4wTDIrQU4yTkNNMFlhOWtVamg4OFIr?=
 =?utf-8?B?cGRjc3JleTZUL3RlRVh3UnNnZGZ5VFpHQ3N1Nk0zckY0ayt0UlNRcU1XSm9B?=
 =?utf-8?B?eXZMVklyeThkczFkcCtTdXAxbmNGMmFXS1dMbHRqMTBaYTlnMllHYTExSFVQ?=
 =?utf-8?B?YkphSGZleW1TL2w4MGU5b0dSWWYwOTJXZG1NT0EyNlZ3WUhNdjgzUGFPR3h0?=
 =?utf-8?B?SUNIbHNWK2R3T1RDSyt4bGpEUitFSFlOYlFYczBFRWpwWGR3VXFoMThlZ0tL?=
 =?utf-8?B?eWlMemF4QXU4d2pIOWF2UEt2VzFnTkhvS1Q0R0I3dFZmN3JFRnNCV28reVZG?=
 =?utf-8?B?b3JhSTZ2K0twYzA2N0M0cWw4TjhsVFQrcWo0ZnQyTVFCY3VJSDVPMlR3dXNn?=
 =?utf-8?B?aWZoNVZWVXlrYkowVFRhQVduM3VQYmNhRVM3Z3ZFQkdQUDg4aVRHY2JEMmUy?=
 =?utf-8?B?dzJpQXVLUFptbUlZUnR0ZjdJdWNvY1c1Q1VYUVZTVVpZSmVvNHJkdlFuVEMw?=
 =?utf-8?B?VStxMUxVdmtvclF0WWNhd0tYVG1ONkpNc3FEU1dSRURUbzVQS1A5OFVpQnFT?=
 =?utf-8?B?SFpqOUpZN1FjTytRdTZ3M3BNbzMwQTRveG92cmovUkVRZHNEVU9IVDBteWh0?=
 =?utf-8?B?Vy9vWkF6eHNLRXU5WUN0QjljcFcwZkU0NzUyeW9nOGFwdlVORUY5NFdtakE0?=
 =?utf-8?B?ME9LOG9jb1hCOXVjTUJqYk5GN0ZNck1YbEg1UDZTMW1ZZ2xBa2RtMStuT3ln?=
 =?utf-8?B?M3FyYTh2eSs1My8xNDROdkJUTVRncjhnWk51QzAvUUszcDJWbG1aNitZQUh1?=
 =?utf-8?B?a0pFSjVuNXJwTWVHRGNZenB2YitwdTF5Q0tmc0VLYmNmUnFUeHd5TS9kamVs?=
 =?utf-8?B?YWFyTkFWYVVxMUVwTmI3UDZQc0daTDc3cTZrSndtdUpMdldtQi9Sc1NNNkt3?=
 =?utf-8?B?eU1BNDlsZldYR0lFVEdjNzc3eGNRazY2U1d5YlhZaVVKT2Q5anJtYTdMZytI?=
 =?utf-8?B?QXRGblZLYnl6aklKSkw2ZDk5VzRESHpOYk9KMDkyZGZPSmVkSE5DY1h2RUtR?=
 =?utf-8?B?aFpWSHFrZEwvSXZnK1NDdWV1WUFyU25MeWx4STlZUkN0NGNkcS9acXhlQUt0?=
 =?utf-8?B?cnB2M2xFUjdJVDFHYi9KaG5kdXhDN0VPTXBIMXEwbi9TcW9xK2NsbFlxMUpS?=
 =?utf-8?B?VldBMkYyd21MdTZSeHhuQm0xUXZ3ZjBRUStzV1dUTlZZMmhBdFRMMXFwWE9K?=
 =?utf-8?B?cWdpWStlQUZsZFMwajRBRWtxQytSUktPMXZwMnZNN01Ed212MDAzcTFKcGlL?=
 =?utf-8?B?MDFpY1RGWHNKYW9qZHFnMHljUUJLV3FNYWdtVkd3RlpPamZJK0FUQnp3K0dO?=
 =?utf-8?B?c1FnQVBwTUluemFGWVRBcFgraXhsbFphN0gwOHg4cUQ1cWEvYWRKZmdwYitP?=
 =?utf-8?B?a3hwdFMxZ1U5VldXUkFjUCtSZjdqNDBoQVZZbmgyS1dlY3FMQlNoNjdwOVpa?=
 =?utf-8?B?c0RZNGxId2VkQ0NORzRGMGRPSWpDZ2VkTGFLYnIrR1ZreFpHbDUveUtUbDA4?=
 =?utf-8?B?eVpDSWVjZEVnM25TLzV2QXhKNlN0STcvZDZzRXorcWtQVCtXcUZjQmVVL004?=
 =?utf-8?B?RHJZcURORVVMakxZZmNncVc3TjhSbjFXVHFPTU82RTJFeURTTnFBcUh3T2k0?=
 =?utf-8?B?a2p4KzNYL2lzZStXMWovajBPS2ppUlZHK2hLVTVTNSsxWXV4NStycHVnUjNS?=
 =?utf-8?B?YWFpTmp5ZXQySW1OZTNob3I1SGxKanVHYjhXTW13RnkyYkhDT0R6R0pWNTR6?=
 =?utf-8?B?MlQ1UkpkTU12bFlubnQzTElWNURFOXpNa3BPY0xpcVZzdnZ3Y2JXcWRyWUhM?=
 =?utf-8?B?dE9wdnBKNDFQelJuSmEvWDdpN2U4cHJWb1lpZC9NNkJNckFuYjQxNlFpWDJa?=
 =?utf-8?B?S1NkNlJZdVRZaFgrU21BL0tHQjBNakNoU001S05MVitJOU1QdHR6YktTbm9O?=
 =?utf-8?B?QUVrb3g5M2RDR0RpUTU5bjhsRndxbUFDYkwvb1BRMElObENNOHhSdFV3WGFG?=
 =?utf-8?B?VUl6ZVhkM0VaN21LWWgwRWRPL1p0ckQwYlk5bjNjM0pXc21YTHNha2haeEZh?=
 =?utf-8?Q?hsKutNyqvyjg+SKY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <627A4478E180F54DAB193EC514389E2D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: S7wqrcnv4kjC6nqoeFO9/2fZNqhfubYUdz3d6hYJ7UGJqudJOsgFtU7nsq+dyna42v5I5k6t+fUZDEawwCNyi3FdOYZky+fbE7ahzKF50CgI7/FL5tPAnZB90J4vRgQzd4Xtp43EiliIFFDYbHHEa4a4FjiMN8oBYfNLSQ+gPvSWU6HDIbu+/yEcorqc28nw4GXEL5uxwVPpz+HcYJDr02rXE8zCjZCTPEWEmPFyYxk+bovQp/bOMsUa86+jqfqob869QCbdN2mUelGLXn8a/SjvuyoaeGmXehHJTMYLTDogaROMz6gBFFhQTCp9GzNSgqDG0h0fCjc9lvCvb8fLqQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a540a3fe-0727-416f-a158-08debd563bd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2026 07:45:20.0632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dI5el0hbX2ZyFcjWbIDGJu7ccuRAHK6S64tMXI8V+V0MHh0WhGsVCPi/4IyT2o0atcBTi1i7dtUgjAAPubF3Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYNPR03MB10153
X-MTK: N

T24gVGh1LCAyMDI2LTA1LTI4IGF0IDE4OjE0IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBVRlMg
djUuMC9VRlNIQ0kgdjUuMCBhZGQgSFMtRzYgc3VwcG9ydCAoNDYuNiBHYnBzL2xhbmUpIHZpYSBV
bmlQcm8NCj4gdjMuMA0KPiBhbmQgTS1QSFkgdjYuMC4gSW4gdGhlc2Ugc3BlY3MsIFRYIEVxdWFs
aXphdGlvbiBpcyBkZWZpbmVkIGZvciBhbGwNCj4gSGlnaA0KPiBTcGVlZCBHZWFycyAobm90IG9u
bHkgSFMtRzYpIHRvIGNvbXBlbnNhdGUgY2hhbm5lbCBsb3NzIGFuZCBpbXByb3ZlDQo+IHNpZ25h
bA0KPiBpbnRlZ3JpdHkgYXQgaGlnaCBzcGVlZCBvcGVyYXRpb24uDQo+IA0KPiBGb3IgSFMtRzYs
IE0tUEhZIHVzZXMgUEFNNCAxYjFiIGxpbmUgY29kaW5nLCBQcmUtQ29kaW5nIG1heSBhbHNvIGJl
DQo+IHJlcXVpcmVkIGRlcGVuZGluZyBvbiBjaGFubmVsIGNoYXJhY3RlcmlzdGljcy4NCj4gDQo+
IEFkZCB2ZW5kb3ItbmV1dHJhbCBEVCBwcm9wZXJ0aWVzOg0KPiANCj4gLSBwYXR0ZXJuUHJvcGVy
dGllcyBmb3IgdHhlcS1wcmVzaG9vdC1nWzEtNl0gYW5kIHR4ZXEtZGVlbXBoYXNpcy1nWzEtDQo+
IDZdDQo+IC0gZml4ZWQgcHJvcGVydHkgdHgtcHJlY29kZS1lbmFibGUtZzYNCj4gDQo+IEVhY2gg
cHJvcGVydHkgaXMgYSB1aW50MzIgYXJyYXkgb2YgcGVyLWxhbmUgdHVwbGVzOg0KPiA8SG9zdF9M
YW5lMCBEZXZpY2VfTGFuZTA+LCBbPEhvc3RfTGFuZTEgRGV2aWNlX0xhbmUxPl0NCj4gDQo+IEFj
Y2VwdCAyIG9yIDQgdmFsdWVzICh4MS94MiBsYW5lIGNvbmZpZ3MpLiBQcmVTaG9vdCBhbmQgRGVF
bXBoYXNpcw0KPiB2YWx1ZXMNCj4gYXJlIDAuLjcuIFByZWNvZGUgZW5hYmxlIHZhbHVlcyBhcmUg
MC8xIGFuZCBvbmx5IGFwcGxpY2FibGUgdG8gSFMtRzYuDQo+IA0KPiBBY2tlZC1ieTogTWFuaXZh
bm5hbiBTYWRoYXNpdmFtIDxtYW5pQGtlcm5lbC5vcmc+DQo+IFJldmlld2VkLWJ5OiBCZWFuIEh1
byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW4uZ3Vv
QG9zcy5xdWFsY29tbS5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0
ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
