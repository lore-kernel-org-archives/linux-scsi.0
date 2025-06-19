Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A8B229B29;
	Thu, 19 Jun 2025 12:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750337398; cv=fail; b=Uj3Mpg/bVTkagxmAWslqY8/fQngi3/m2JUSLKiewe+YSNnVu7SXabhBb4kWGKJ6T5wwACKPM5Kxkx/gfM6tNmm3b47w3R5abmhb1YMyJJf7QrLt/KFgM4i3p9HPGTZtW5JFGRAmhC+T3kzmueODDXbW1xpWa+NnqZ+iINebeM8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750337398; c=relaxed/simple;
	bh=oxSrcbl7PBkhiJqT9+n0je3eVCoxjYo/zU7nmZd68yo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iuuinJFkH0JVUnesZUcEZe6Tl5wV9B9GaUimSRfcLYdRSQwqyYqfYSc2yVSOpcJoH/x/MsJTSd4+2X40ECv3SI5ZP/mxnzMaCvsYqopQv2ZweLgJosh/BQzgmbZd8b2Dbh9aD41mS25i1ktWQZBWYDe7/cR4MXpU1r5ZOT2Psn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=exOrzasx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GKLXtBIF; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="exOrzasx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GKLXtBIF"
X-UUID: e11094b64d0b11f0b33aeb1e7f16c2b6-20250619
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=oxSrcbl7PBkhiJqT9+n0je3eVCoxjYo/zU7nmZd68yo=;
	b=exOrzasxlh/BNzFWCulkNHWjyOh7tsRCkVGRkqWTU+g5J0U3y0i00Ew1kVxRD9PdIankpWLT4PsspDCce+fgnJYQu1J2s0U2sV411J4jYuFLOa/9aa3yv4RNoUIgf1neqNrbNT4ohaND4F4HO3ZM1PjfwgXJm9ANhOa2d4YmXRM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.3,REQID:48bea8d2-f539-4413-9124-40d4df2cb01b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:09905cf,CLOUDID:517add58-abad-4ac2-9923-3af0a8a9a079,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|110|111,TC:nil,Content:
	0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e11094b64d0b11f0b33aeb1e7f16c2b6-20250619
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1818568103; Thu, 19 Jun 2025 20:49:46 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 19 Jun 2025 20:49:43 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 19 Jun 2025 20:49:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRNW1aoWt5SJ8yQDa9E0Pe8jLh5MIWCrVfaE3GARb9hYKPFnudz92779DYpVUlWuf0EVVYhC9t0C8RSrpSlmcLd5jCiG7/NYnlH3hKojmha0eUMxk+Cqjoqo5RUhuYCXVLIDFBcXM1MdVafCCLRIcOAnoiFlYJj2Y+uG/QvJt8V+PRKE0vtMz9FzXqSmymdYjvctPmfCZ4ZOZYcZzXjwdkVwY2Z3AXBjWAremBHMjgp15LxY4SAfOCvUdUR2LOcWPWR7opCfURil0dQEFwki6UobFn4kyIkZOAtci3+aO1Gt5h2V7irPog9ZLsaeoIdbs0PihmrCtHw5Mji3M3tu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxSrcbl7PBkhiJqT9+n0je3eVCoxjYo/zU7nmZd68yo=;
 b=APgowbzLv4LAv9x3SxacRcIqDs3/iJ+FprRbLJY+wpaSGNcU2Ra+YrdgpWFAE3iaBiaXBIhXOnCwfKAdfCGOQxeRKNBxlQSe5Oau8fLnmH8VFA/+eq2x1nib4rOpwGxl8MX+GP1J4QmeYJvzhblLlnnw4Agro4CT2ylZ9ya+Jh6cTWY5GC2GDXLs1wZcwRGinh0+RZwlu1IhCgrTM0z8qwdM2ZM8J6DnCS5P4oaD9d0GCq1cGRGK0ls0Up/jVjX6c4/ERfd7OEIDOKm2tHnCXHI0bseDE2RUOlF9Ph5qXb9aRmI1jBVmFgKMgtleJVROhDa10MgPGqQC8QRDNLonCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxSrcbl7PBkhiJqT9+n0je3eVCoxjYo/zU7nmZd68yo=;
 b=GKLXtBIF0MxfqwftrwospxUplpvLdKSb+vY9jTZNxL4RQgODyWfxmW6OUeCPB7J6zeImOaQONDp/JZmGn+Oj/s0nEFzFqhHOSQ44aCanWuHvY1i56h3FNpoEjDOZz85HNyXlgWIXgQSK49O4+m95TEikmFq2e3Xr3ND3u4IwH3s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8274.apcprd03.prod.outlook.com (2603:1096:101:18d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Thu, 19 Jun
 2025 12:49:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8857.021; Thu, 19 Jun 2025
 12:49:42 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "bvanassche@acm.org"
	<bvanassche@acm.org>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "hch@lst.de" <hch@lst.de>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "dlemoal@kernel.org" <dlemoal@kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH v18 12/12] scsi: ufs: Inform the block layer about write
 ordering
Thread-Topic: [PATCH v18 12/12] scsi: ufs: Inform the block layer about write
 ordering
Thread-Index: AQHb4RZfhCr+lc80S0Ss7zplcbuFlbQKbxKA
Date: Thu, 19 Jun 2025 12:49:42 +0000
Message-ID: <efda2d4c27346f03acdd2c7b7d98ad57da7fb332.camel@mediatek.com>
References: <20250616223312.1607638-1-bvanassche@acm.org>
	 <20250616223312.1607638-13-bvanassche@acm.org>
In-Reply-To: <20250616223312.1607638-13-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8274:EE_
x-ms-office365-filtering-correlation-id: b255407e-7729-4b35-db61-08ddaf2fc2c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N0wzYXZYTHlFSG9PVFdDellyQit0anByV3ZyZVNPcS9qSTJIR0dMNGhUNjg0?=
 =?utf-8?B?elF4L2l2NXovSjVJZEk4ZkRBVHJMRGNKajRnbFdLelJPRjcrcWNMcVlWdFpF?=
 =?utf-8?B?TDJxR25FSkpQSkE5NU5abnpsaC9pNkR4QnFiYXB4TS94c21mc2NYTU4rN3RH?=
 =?utf-8?B?NVN1ZUpmdVNPMXdaT2txTFZ6OXlrSDkycmttM0FSRWE4Zml5b2VQNGMrQTZx?=
 =?utf-8?B?eERaMmh0NHQ0akJaVktXMEFCMlJFSFBZaEp3RERpZk4wOVArZHVpdnBMWEZp?=
 =?utf-8?B?M1lIUmtuRjdpa1MzQmM1dmpaSHFPYzI0bk54YUFJU0xEWEJUVll4NU5WRmhz?=
 =?utf-8?B?WEJ6UTFtYVJIeGl0SkNVaWpFUWxQRWI4aTVOdmFHNmRkUVMxTitmZldXQXlh?=
 =?utf-8?B?a25wQ1kvTFV5U1FSSndmRm93MkFmOWxBNEcvUmo3MmlUN0xPVmJRSlp6bGpo?=
 =?utf-8?B?a0lMUHpoRUw0aTdWMmZxcDJmV3AzcWpYNEg4OTZZNlBtdHVxQmExRWtIWXA5?=
 =?utf-8?B?NHkzcW1sUHBuVGduc2pEekorVTl1ZUY0VzE4QU1IbkQ3WXlnYWFHcnBHMzhL?=
 =?utf-8?B?Ti9Ra1BZRktWTkRkVWcraHg3K25GT0JRZlRvQWFGL1pGeW5zbVJhVWhLN0JP?=
 =?utf-8?B?KytZY3VUNGVkVzFwaHhBWWtkK3AvaHpaOE0zWUNzNEJoREd0Y2lLM2FCaXBL?=
 =?utf-8?B?dk1pelZ3VmlNYTc2YTU5aDdaak4yZHd1MjZ1TjNiVGVVbjBxOFhEY3BoRW9T?=
 =?utf-8?B?ZERtMi9iNVlFMm1RTFlNNklxZ0h6UWpqWXpOemxxUi9IeVBHeGY5SmlkUDBx?=
 =?utf-8?B?Sy8zdWU0RDhiNi82dmVRa0d3Q2JwMTF6SlRKdGMzakhlRVMrT1lPS0tybTl6?=
 =?utf-8?B?MlhwbU9GdUYwNkdTT0prM1pJcmMycXVKK2NXRE83QTZKdDZjc0sxaXJoeUZR?=
 =?utf-8?B?NkdGRlN0dWZtQllEdlEzTnhFbDlWblZGTjR5TmJaREk0TThyckVyMGM1bG9h?=
 =?utf-8?B?NHc4OFFOaEFMWTJvK3VpTXhhK0cySFdKa1lRT2JzMVpJTWRWMWd5SkpFeEQw?=
 =?utf-8?B?dkF0aXEvU0pYNTYyRi9uL2g2VGxHNmFjK3RYaHp4TmZYTHBLMkQ2TTZzSk5k?=
 =?utf-8?B?VDdKOGMzaGNZeU9VQzhrTFdKcFNIS1haUjZDTkhHR3FEL1l2MkV4bC9oTDRD?=
 =?utf-8?B?ZmYrdmsyT0NXdEpqWko0TWdCOVJHVU56NlRma1RrSEJPaXpJQTRNdDU5Zm5B?=
 =?utf-8?B?cmJjSUdkNmJ3Z25ieTA3ZWpXSi9aQ3ptSWRsQk9tU0J2SUIwenZwSDJnWG9X?=
 =?utf-8?B?bXV2RnM4Si9yUVNFcmpLbk5MbHYxNVoxODZlNyt6b1dOeWs5d2o4UDlQUjhv?=
 =?utf-8?B?UmVLbmE5NjlWRi9JUDMrK0lNZ1JkZnNVZ05SdFVPWlJVU2xEQTB4cHBRUEJu?=
 =?utf-8?B?b1ZheVA5UElKanlNeWFpQnJmSU9mVHNPME42VTVpUUVVZmV6R2lDWFdMMXZs?=
 =?utf-8?B?cithMlZ3SjlWSXBuY09acDV2eVBReFA2cWFwdUtJcDM2dHA1RnF0cFo3d0ZE?=
 =?utf-8?B?WkxLR2U0cVpzR0Q4OTQ5MkZ3bm9LV0RnVmVQdG5oakQ1S0RSTHF0ZUd2WVo3?=
 =?utf-8?B?OWROdjlVUkZFVFZndmd6Y1VTc2UvYTBORXhkeWFtbm1MblViRFF1cFRuaHI0?=
 =?utf-8?B?SlNLd2c0dkJjWnNKZlpCbzlpb29Ba0swS2EyaXhERmdwZUNBcUhQZFQvcmM2?=
 =?utf-8?B?YWVKbmVIejNGbkthRVY5NFBIeXJHR3UwWFVVSnR0bGVIQ1d4czI1WDRMbTV0?=
 =?utf-8?B?ZWVzR2hGV2ZpY0xhOWMrRGcrL05SLzhYbGszbTJuU3g0bGNtemRiTktSYTBC?=
 =?utf-8?B?K3Mrd2tFQXpmeFZZeDRBeFR0cmhvKyt3SW00d094WDRUMzlrbGdYbk1oZ3J1?=
 =?utf-8?B?dWRNWW5wM1JIQzRTVHdLMUhvUnRaSTRpaS8rMjNXcVM0SUR2RmtNRWlONzM3?=
 =?utf-8?Q?HqBAqwG2wzG4o1vMcc+QY5sV/A7UVc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVpmM0lxa0VPbWd0MzUxUXNQRVpybC9PTjJUUzdQd1ErbHRkZEZZbnpGK2xr?=
 =?utf-8?B?WUp5eitPdGVEbjVSQVowSzBYaXNGY01TWjVOeG8xeFdkRjRFZndoTEFKemFq?=
 =?utf-8?B?OTNQR3ZEeEdGM1BHbHAwdFFZMEpqemc4UHczdjJ5K1lkcU8wd3R6U0ROR0l3?=
 =?utf-8?B?a0FBZ096eWdlc3dwVEgxZUNoVVpOWVVKWnlqODY1NFRBa3AraUJOVWR6d0Zq?=
 =?utf-8?B?allSLzZXQVVWdVk5MU5zdTJEU3ZMRUlCSi9KWW9qZ3BDd0t6SjBJUnlvQUxY?=
 =?utf-8?B?V0V4aG55OWozVjZ5MWNUa1o0MjBQb1BtVUF6VHV2cHdOOXM1Sm95Q1BaMWxv?=
 =?utf-8?B?MDhrT04ySzJFbDBRckRFOHZ4b0IxN0F0L1EveDVXRXVmTHdXNjRRZURpRjh4?=
 =?utf-8?B?cTF0ZUN0Z2NxcmU0WUlKdmgwRnIwaGdxb2ZPdjhWQkFlS3VLSWRDTHhxYktB?=
 =?utf-8?B?ZmlsdmM0SFRYK1h0blVoVmNWQStPbUxTcTRQN3ZPb25YV2xkbnFpQkE1TnFX?=
 =?utf-8?B?U1ltYm1CbHhveUpjWjVUTCtzWVJmT3hUalcySDVsSm0reTdsS1NJWUppYzRz?=
 =?utf-8?B?Zm00YXlZdExSK1pQbUFucG9iZGx0YmNaMUdHcDBWRGxpakVjdXlyWnE0TkFD?=
 =?utf-8?B?U3d1L1BOQk5rNnpKYjRWcVBVM1p1UGhDdlg4ZzVUdE83WWpJK1ZTUk1pK3Jn?=
 =?utf-8?B?WVh1YkhKWXQrT1Z5K05sSHp5MFRlcFhpRDRtQ1J2ZnVXRFI3TktuVTVrQ2dy?=
 =?utf-8?B?QUwwM2xHbVFQSE43amQwdUN3L3JoY0lUbHhVcmxwS1FhbmZmS1hQSnRzUHM4?=
 =?utf-8?B?SlU0a3dnQkM5OWtNMndEQ0xZYUg4QWRRd0tQelNNUlVmSTE4eEJzYmlKVFR6?=
 =?utf-8?B?ZEtTS1pyVmhWWHgzTVNkM3A2WGwrOHg2RXJGTlIwbjFvc0I3QlRteGVEVllx?=
 =?utf-8?B?L0YweVNCWXU3VUFvTVIvSjJQOWZwTzdPRld2TmZ1QjFkbEQxSTRaOVZpbWdR?=
 =?utf-8?B?d3I5cFhlOXRUZE4wS25oS1pzN2Nkam4wSk9oZ1MvSXJUM3R4QXp3SHBtemFV?=
 =?utf-8?B?QlZyV2Zid3dqMWliQzQwVUEwSEFKSzByb0Zwa1ZXckZ2SXNZUFJuMjJXQnRu?=
 =?utf-8?B?M3NndW81alF4NzRoclRKRmJsbXA3cmpQWTJHQWU4MlQ1NEJJeGtBQzZOalhZ?=
 =?utf-8?B?TjhOK1NRcklqN3NRVU0xajdQWlVUMzk1bWxyQ1NGV1NkY3hPYk5mVFRQSmhw?=
 =?utf-8?B?QXREdjZaSGN0Wjd0aTBsZTYxbSt6WUJwbXVQejNsbUwzV2NUdEx0WnUvWDBY?=
 =?utf-8?B?Q2FNSk5mR2ZZdTZidUJBaWZ3cDkvNU1hTTIwWUlpcmdTT0I4MHR0YkMzMTd2?=
 =?utf-8?B?SjZTZ2FhSm5YMWJUUmtFbXNSTGVLVGhReDBwcWlBQUtOazZjL280dURwTDZV?=
 =?utf-8?B?NDQ0MDFkdzNBdFh3bVZ5NnRGQ3VCa0ZpRGV0eXdVbzRFU0ZOMUp5SmY4c2RX?=
 =?utf-8?B?SU5ScWNVQU1nV3hMbzJ1ODRaK3B1SEVQQTM1bXFmd0Z0V3pmOWZ6di9HSFZn?=
 =?utf-8?B?UnU1T21DanRaaHdibHZHeU5BcWVnSTBxQWZlZWZicVFaNzVSeGl3Z3hxU2Q0?=
 =?utf-8?B?TkdjOW0wYWhBZTFCUlNua0F1SDJod2NHQlFrVDVqQkpieGxkM2RzbVIwRkVF?=
 =?utf-8?B?d0ZQVjZxZFlHb3hvWkVjbmNQOXN1cDNNUUlsVHB2RTU4am0rWWdFRUNsNzBk?=
 =?utf-8?B?MjlTUGxDUW1MWGh5bTZYZ2NmOEZuUzlPRkk4QkEyeDI3Q1N5L2NJT2taaTZi?=
 =?utf-8?B?bGt6SWZrTUpxUm5vRUgwUkw1RnQrYWVKTlJMczI3SVp6UVJTbnhMMWcrYktm?=
 =?utf-8?B?T0hDZGJkNVBPOHRZbGwzNTFoS09uVUdBcDFCVGkvZS95andScEJWK2Q4VWJG?=
 =?utf-8?B?SS90YU9Ba2xFSzRwVkIwM0lUMlZTK1pKc3VQOGlDR1ZwOFphTWFGbHRDbUVC?=
 =?utf-8?B?UUtOdWM4MmRvczNsNzk5YkM2bzRNalhGK1Nlak1lWmtmeGNTZTl5ZGl3YVJR?=
 =?utf-8?B?RXdqb0hRNk1CanVNVjNuU2hRemFZWHFwZXk3U3ViKy9KTUVRTXFNbTJ5QkdQ?=
 =?utf-8?B?V1M0eUlCUUNPcFF1NzhmVjJSVWNZTTh3OHZvck9VbjNwWDBmaW9NLzVtWnhv?=
 =?utf-8?B?UUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F16252515656AC46A374614AFB0BA1ED@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b255407e-7729-4b35-db61-08ddaf2fc2c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 12:49:42.2239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wKc6KSYKjzUa2wtTqYe3RoRFxDKaPYyB+W2kmjiaW7pFkh5Ag4p42xn+UuZDpgF3LIke2XCxdK1aZfee2wwHiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8274

SGkgQmFydCwNCg0KSG93IGNhbiB3ZSBlbnN1cmUgdGhhdCB0aGVyZSBpcyBvcmRlcmluZyBhY3Jv
c3MgZGlmZmVyZW50IEhXIHF1ZXVlcz8NCkZvciBleGFtcGxlLCByZXEwIGlzIHNlbnQgdG8gaHdx
MCBhbmQgcmVxMSBpcyBzZW50IHRvIGh3cTEsDQpidXQgcmVxMSBtaWdodCBiZSBkaXNwYXRjaGVk
IGZpcnN0Pw0KDQpUaGFua3MuDQpQZXRlcg0K
