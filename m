Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4964273FD;
	Tue,  7 Oct 2025 07:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759820661; cv=fail; b=FjIR0AhcaTJYqrfYD15HIEp5/uYXWQxPIZFNNwMVmqR1veyBJ4/huprapmDX+YISvDMSgHtPcvumyEgc5SDQiC2r8TMNkvtYGZeT0AjQ61AFiAYCqmQ1tYcM61DcjRiPZW30ff01yX0vYRTvM1bvqdPDgHzCrPOkYTiyl/8apkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759820661; c=relaxed/simple;
	bh=RhQSGVAEElxXtvbtw4w+tjiJuR0zuKgxpVQXm6VIvyA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VPy+8OXmIXlhuqATLSkeYgO6ou/1o18FFRInATe2BMKzD0JoAAme7bPqAXIS5zomR0AUZ30xratFFfA2pTNXlt8dxxr1vNx63aE7mhsQpJCny6e0oVNQzuFNDFknejc6XrmBrY3GnW0KXpyxHU44KnDk/vrzFEKDSqJrut6SBSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QaTvYVL+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=s5k/jWr2; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QaTvYVL+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="s5k/jWr2"
X-UUID: d518f0b8a34b11f0b33aeb1e7f16c2b6-20251007
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=RhQSGVAEElxXtvbtw4w+tjiJuR0zuKgxpVQXm6VIvyA=;
	b=QaTvYVL++OTCwIS0F1GHndzOt9fNet4W2upwZYnIJgp3Kx14G5W4E7yPdrXVv9ti9JzWmh5PxuZf3nydZCTZTrUxPEq8I2f16M91vzhXN4fO8RfOcz6LFLmhZQrXoJ2CCEcNK+RuexBjFNVAs42d8TFokj4btDnXFGdK5/r3f54=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e78951b2-6dc1-45c6-92a6-7c4db62a1897,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:48e74e6d-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d518f0b8a34b11f0b33aeb1e7f16c2b6-20251007
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 316700232; Tue, 07 Oct 2025 15:04:14 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 7 Oct 2025 15:04:12 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 7 Oct 2025 15:04:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rnHuf61Pn4lq5gsc41qRjwSg+4hFOw+gDUxS0uB+/0Enr/06onSjMqvM7Cw7Nct+95Hn0I9oE2oGBVQAGP7Oa/etkSC1t6fAuJSsO4Gc24mu7qbbgdnFxIXfa6RrVTv1xEWnlUxUHJHYT1rzOsxrITHf7RUnJ805XoHLAAdcu5Iq4PWlVXAPwi6/LhAneSUP0fmMutPVNgLyzRUrpH/ndnIVuOoIKF6Fr6Wvq9eVinPm7XJfKgnGf1TkL+hMlyFQ7DNdCU3/FGbFvP2x9R3N+MO9AnAgRjFkalI0dZeBJisgxu8WjRADOxkLbLF3zl03Nzjl6o4EJEziyMrVC/seWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhQSGVAEElxXtvbtw4w+tjiJuR0zuKgxpVQXm6VIvyA=;
 b=iAU+4xWcD51xzAYXcg7v/LWvksfkmfQdUi6RKHtZ+MYDzSxrVG9Fr4ue4HqF3/QpE1flcXiWomfL/frUhJxOGtlP9XaKwibU8IAAzEA0aWK6JFzmbXKU7CX2biFYkHk7wmNJDHuonDyWNswboWl/b9uO/cPbEZpORzTrWltzCb9RhyftlqGhvK3lv7N1FHo3hvk7q3bC931NpuvgTcYvk1hOtQ9pWWIr1Rf592ZrWOECSzGUNq+8W+tPbU8CqDGoqnEwPQa1Vlg4uGanmlRjcHmx3TmZrEhv6HX1WfY7y+Eb3SDfKf9gvNyI3kcLDDK57aXYbHqAJz8RbGWdW42yfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhQSGVAEElxXtvbtw4w+tjiJuR0zuKgxpVQXm6VIvyA=;
 b=s5k/jWr2ja/r1C8DMMSkw4zdi6AJR0Wu3LdksLSmtz/+geVaDGZQbtEb1arRRHutnRmSjLzX4vjxfNM7tZEtjNP5naQxZ7bF9SgJrUV2Vh4DfcqMRCApf76piUyszI/9tQJwqsofsT3WqeGah7VG7kN+FWkiphMC9YqYYO/rvuA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB8330.apcprd03.prod.outlook.com (2603:1096:405:1a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 07:04:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 07:04:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Topic: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Index: AQHcMxYfazcJy3COe0ibj/0v49XMcbSufr+AgAC4nACAAIkrAIABMksAgAVYKoA=
Date: Tue, 7 Oct 2025 07:04:10 +0000
Message-ID: <85bce5dc28293f48e32b64eed5591d66c54c9e69.camel@mediatek.com>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
	 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
	 <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
	 <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
	 <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
	 <234a5185-d7f3-fe81-9c02-7895691c1fbd@quicinc.com>
In-Reply-To: <234a5185-d7f3-fe81-9c02-7895691c1fbd@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB8330:EE_
x-ms-office365-filtering-correlation-id: 34431c70-73ce-4e93-26e5-08de056fb6e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RC9mVnFIL3dnMUg2d1NLM25oYkY3UnNTYUVNNWdOMzlWWkwxU0tEY3NLZDIv?=
 =?utf-8?B?R0Q1Z0J1ZEpkbTF5akljdFUva25GTEExT05UYTZuZEh6WHk1SnJNS0d1bWJy?=
 =?utf-8?B?QlY4b2RYU0Y3R05UT2RYK3V1YjlrNTJOOWpTMzZDOWxqL0VHdW55TmJ6U3dz?=
 =?utf-8?B?VCtWajdQNDVwdkxzdXU0UVNGOXg4cjlZSnNoOEFEWHhzWlNjQUxNbkJhT0ky?=
 =?utf-8?B?WjNTZGQ1Yy9sVTJOT0hVejhIQU1PUFVBR3h2R1NRVUh2TDhRYktwcUl2UWFl?=
 =?utf-8?B?dUVsQlRZRXE4WjZUeFdidEo3U0lJVDRueGo1NjJwUVlrRTIwM2J5RmwydTc4?=
 =?utf-8?B?WWRIQmpTNis5WDk0dy9hRnlqVk9tVVN1QUpYajVKajQ4SFNscm9SN0tSNEt0?=
 =?utf-8?B?Sy92L20yWHMyelBZcFIxQ0J6SUJuU3dHeHZJa29udTJLODM0VENMM1RyRnRm?=
 =?utf-8?B?RTJhTGN0dU1zODVNdHczbit1S20xNVRrTXo3T3VXQy8xT3BqYWRHelJnNk5K?=
 =?utf-8?B?bTlGRkN3YW9GVGg0SkgwSHcyZmJDaXkyNE50ck81MWplbXRNejQwMk1SMGtF?=
 =?utf-8?B?bmdMSk5zM01ibWNzZ0JDanBNM1JTRjhwd1pUQS9GYUdPWUJqTHVhK01PMm1u?=
 =?utf-8?B?MnpEU3haODUyL1U3SGRsaER1UmdqNnhYNFU2c2JwYUp5SmV2SWpVeWhNS1gw?=
 =?utf-8?B?V05PcG9CUG03d2h0UDZpeXh4TmdOVUl5V3pxdHArQkszZkMzZTRGWm9qKzdr?=
 =?utf-8?B?ODlWdVBPUmt1UzhwSERoMVVZMFVjVzA5V0xSK2xEblJZbWJDQ2d5NVNYUDVW?=
 =?utf-8?B?MkFheCtuVUdSZXJERWtVemIxbGFIWUphWWk5bFNDeEJMQkJIOXNDcGlQdzI5?=
 =?utf-8?B?SEdBODRhQkwzcW5mS2pWNzF2RjRYUFBIcEl6TGExc05HWUpLUklCdm1KT1ov?=
 =?utf-8?B?d2l3aytueDh0dmVzKzgzKzJwMWpyNVl3OXFjYmxPWDBuVFZ6K2duTmF2L1ZB?=
 =?utf-8?B?VXNaZ0xjUW8xNXh1cWtzZ1BReHhXejBERlNnUVcwMitrQk1VcDNMZ1FhT3gr?=
 =?utf-8?B?cG9TRVF6V0V4RmlwLy9xNGI5Yng4WXBjbFRiOVhhMnlVWTY1OFpYVTJZRElL?=
 =?utf-8?B?MEkzUlB1U1F1QWExTDc4ZDlkZ29TNlB1WmlTYnhEMWZDTDVNNHhOelNxaENP?=
 =?utf-8?B?ZERCTHJoNzJpMUJUSEJpaGlzU04wZmFxOUtoUGFpSCtyZlU3dGYxdm5sZnJP?=
 =?utf-8?B?QTZhMm13VFZ1Uk45NVFhSmM0MCtDR3RsOWdSSHcvKzJGMWJPY2xudVl0UDdZ?=
 =?utf-8?B?LzdPdmRkL1VnRkprWlQzRVJuMVV3YnEwUFFHTVo0bG5iTmw1K0VkdVNZR0c2?=
 =?utf-8?B?ZHdNME1mYzI0ME1OSmhYWFNqdG53MTRJakw4Z3Z5R2pqRWliZU5sN3NHaU03?=
 =?utf-8?B?WTRrT3haeVhneHU2VEJROVFsM3o5dGFMQnJMMjZsNWtIaC9qR1NUTS9xOHZI?=
 =?utf-8?B?TXJ0bU50WjUzOENWN0pMMUw0UkNtLzhGc3lzMXQ3T1ZEczA1NFYzVE9NOUUw?=
 =?utf-8?B?emsrOWVETTluci9KWVR5T0hlVXVSRnZUaTZ2RTFGenBxd3N4UHNTalRjalhi?=
 =?utf-8?B?MHFQNTFMVWxIK3lscStzSmlCUnp0VXB3eEZiWnNJMmJyZVdaRS83a1pWOG84?=
 =?utf-8?B?L2d6OTNIVGNnVzdvK1Zub0xmbHlIUVBNUkphR2NFR3JMTGJZWm1BbW5tczF0?=
 =?utf-8?B?SFdQNEZJNmtOQSttT0hWNElWZDJ1ejMzdEtxaEVNZzhYZGRqTFlaNVJ0MG5O?=
 =?utf-8?B?OUNMTWF6VjYvM0JQMXNtRDhhVC9ibUZGbjhxbkphZkUzUkR4UmdDSVc1azM2?=
 =?utf-8?B?R1pIOXRwUE5wTnFNa1R4aWVjVldLR2FiU2lYTEFLNWNxN2RZUWhCdzZSN2Zh?=
 =?utf-8?B?YnkzUUcxRlRnN0tRdUdYeWJGRjVKMVhZOXNkWHFsWElkL3R2UnlKOWxpMjRO?=
 =?utf-8?B?R0FNYzZ2SHg0VFJ0UGRQZnozUDVraEpmdWtPYWkzMmQxRFVPR0xYVjdTN3Mz?=
 =?utf-8?Q?zPU47Q?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFNjeWJWaEVIUE0wYVV5ZVVSL0pwTDFyRm1jWlAwc2ppVlNieUJJZjZRVDlv?=
 =?utf-8?B?QmNpNktHZGxhYkI4eDRpcXg2NFR3QkFMTXc3TysyRndtUm9acmZ4S0t1Y1Bm?=
 =?utf-8?B?bXpPZzQrbjJ2QTN5c2w4dnhnam5uVmZmSjZmYUhvVTJ2anFzUFdhcG9rc0Ir?=
 =?utf-8?B?WkJsSXpMRTgwM1ZKNEp5SWdXTDNmY3YyS2RrcllYc3VVVVZ5eUNkaVlpNkJx?=
 =?utf-8?B?cXBoM1lNcUVmdUlvSzV2bzduR2ZWUzByYzE2UEJEMEx0cW91Zk5hQUE0T0d1?=
 =?utf-8?B?RXZRNHFzZlB6Y0dHV1JtaDc2TnlFNEM3UU1hUmdWcm1LMW5hUi9XZ3BiNFlq?=
 =?utf-8?B?WXBnTFRFc0hBVHQ1WHZ0UW9ZaUpVSXpQTnl0RHdTQjg0cnUzK0JSK25rVzFJ?=
 =?utf-8?B?YW9TalZMQXE1RE43byt3RWxBbkJoVms0Q0kzWGdtQ2lJRkRERU9JTFFDQjk5?=
 =?utf-8?B?ekxGazlsc3oya0VTNFJlZVRqeG9RYTlFNW1NV3VKUDV1NUtnV09JRGd3c1Vq?=
 =?utf-8?B?OGo2TWRHSWV0NjlvTURiNXBCT01XNk9UOWU0eWpMYnNmY2tPeEx4Z0pXTmM3?=
 =?utf-8?B?NlpjcWtOOW9pUSsyS3FZdnlZWVFCTWlMK01JMUxYbXVHaFlxbG5jcjBmZUNF?=
 =?utf-8?B?SVNEelNJOVlaVWR2QytVcno1SExocjdQN1pZWkRRRHZHditSVEh4LzFnRjBm?=
 =?utf-8?B?dHhGUGFOalhnc2JOT2h6dUlpTkEwZUE0UGZHWEpoa0Y1eDZ5VmZYN1NlTk5I?=
 =?utf-8?B?WHo0ZVhMTjh2WkJzbldmT2JCR2pnSkhmcTByS29UUjlYbTVPZkdPZDdsRm45?=
 =?utf-8?B?a3p2QXdQaEVwQ05lZDUxT1F0MjlObnh1M2RVMTQwaFR4cnk1eGorZHFPcGJ5?=
 =?utf-8?B?ZWdoYjFNaVdlazZ1VDJZN2xzWHVBWXkyM1JSeklhb3N1S1M0dVI3ZTdNRkUv?=
 =?utf-8?B?R3RtdWRsbVBtVDUrM2JhL3FPN2J4YlQ1Sm54WHpVVDhMN09JNmlLSTV0MVlK?=
 =?utf-8?B?MHVnVytiOVdOa2Y2ekRaRUhTNDhVZmF6ZFl3Q0NMQzNHRlZ6WHpSZE5NQzJm?=
 =?utf-8?B?QndCeXpuZGlWS1k4NkhjUmovYlU3eW5qNi9qMVlnZUtTT29XWThNUE1rbnZq?=
 =?utf-8?B?M3BoV0gzbE5HY2hOTjlqVWpmU2hxcW4xNk4rcW9jazRWVnQ2T044RE8xM24w?=
 =?utf-8?B?azZUdTJDNjBTbzdtTThHSzc3NGFCRGpnWWhwZnd2Qzl6N2hsQVJNaGI5WXNV?=
 =?utf-8?B?eXpKYXZWWlVzamgxYkttUWd5VERSQ0VnekJzMFFFOE8zUjFMMHhTVlpBdmw0?=
 =?utf-8?B?U2djYVlUekVuY0s0bXc0NVIyUXhBWjUyaVRydFdjMFM3elZ2VzZPRlI3VUhH?=
 =?utf-8?B?VWFjN1Nlbm5tRlRPb0x6STltbWdKRXFoZEZuNEtxQjdycG9KSDQyNTZBbDBh?=
 =?utf-8?B?N0VhczcvMmpidlh5SkNJdkU0UnJjdFl3MFRBUW40aGNPWW1sSWZ0dVF3Rkgz?=
 =?utf-8?B?YU1YeGRDNFZqMmVhblhob0JXdEZMVW1kYjdPNThWTElKc0podjZlNENra3I2?=
 =?utf-8?B?TzNlNFdwNEJSVU5rZlJpV09wS3d6ZGoxWmxDbXpJZnpEZXBYYWdpcXlKN09M?=
 =?utf-8?B?UldKczg3azJhVmI1WHo3Nnl3aDJOQlR1WEVHaWM3VWJhSmlVQi9aTkpYZktJ?=
 =?utf-8?B?aXEvYVlDNTM3MVYvK1hRbkx6TFZOU243WkloRWdLcFZKUDg5cyttcnJhVlo3?=
 =?utf-8?B?c2FZN0szZ09UcWZhdUNaNHFkOGdlZ2JYdnlzQXdUdzhTa3FRdU5XUVVVNnZo?=
 =?utf-8?B?MGg0TlZzK3R0bHVPKzFLV3kySlF0N1hsL1hiRjl0Vk5SNnN6UXEwbENnMGVm?=
 =?utf-8?B?Z000UTlxR2xxaTZTTlJzZ3MyV0x6d2JIclBjS1E1a2NFR2M1WURmazh3QitN?=
 =?utf-8?B?ZDFORXBNcTI0cWhGSVdyYkJHOXFrMlZQdHhhWVhBcU5FbEp0ditZZW1oL2hp?=
 =?utf-8?B?SXVpSjlYWUNmQm5sQmRrem96R2xLQUFQaVZHUUNrc21aRGxZa256Vnk5bEFX?=
 =?utf-8?B?TkhqM2dZTGtjWVp3bEk3Q2ExSE5Xc3d3cFNHS2lDTnNMa1BveXFzRStUSTNV?=
 =?utf-8?B?TkdqUFFvZFRIUEhsMm1ST3hIV2hZWTUvTlNYb2JqN1pMend6bUJSdUdpcTRB?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A48E2851D25604E9D99C5D26A14D386@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34431c70-73ce-4e93-26e5-08de056fb6e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2025 07:04:10.0642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oYwRlZVciisj62Ju/X3T/O8RUBzmX3AKoMROYuR7CeSr9yV/kkWRjyO9buPYJrBFyQrYvc4YDXrrLgXIbVBKmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB8330

T24gRnJpLCAyMDI1LTEwLTAzIGF0IDE0OjI3IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiBXaXRoIHRoZSBjdXJyZW50IG9yIHJlY2VudCBvZmZlcmluZ3Mgb2YgdWZzIGRldmljZXMgaW4g
dGhlIG1hcmtldCwNCj4gdGhlDQo+IHJlcXVpcmVtZW50IGlzIDFtcy4gRm9yIGV4YW1wbGUsIHRo
ZSBLaW94aWEgZGF0YXNoZWV0IHNheXMgIlZjYyBzaGFsbA0KPiBiZQ0KPiBrZXB0IGxlc3MgdGhh
biAwLjNWIGZvciBhdCBsZWFzdCAxbXMgYmVmb3JlIGl0IGdvZXMgYmV5b25kIDAuM1YNCj4gYWdh
aW4iLg0KPiBTaW1pbGFybHkgb3RoZXIgdmVuZG9ycyBoYXZlIHRoaXMgMW1zIHJlcXVpcmVtZW50
LiBTbyBJIGJlbGlldmUgdGhpcw0KPiBpbmRpY2F0ZXMgdGhlIHdvcnN0IGNhc2Ugc2NlbmFyaW8u
DQo+IEkgdW5kZXJzdGFuZCB0aGVyZSBtYXkgYmUgdmVyeSBvbGQgZGV2aWNlcyB0aGF0IGFyZSB1
cGdyYWRpbmcgdGhlDQo+IGtlcm5lbA0KPiBvbmx5LiBJbiB0aGF0IGNhc2UgSSBkb24ndCBrbm93
IHRoZSBzcGVjaWZpY3MgZm9yIHRoZXNlIG9sZCB1ZnMgcGFydHMNCj4gYXMNCj4gbWVudGlvbmVk
Lg0KPiANCj4gVGhhbmtzLCBCYW8NCj4gDQoNCkhpIEJhbywNCg0KUGxlYXNlIGNvbnNpZGVyIHVz
aW5nIG1vZHVsZV9wYXJhbV9jYiB0byBzZXQgdGhlIGRlZmF1bHQgDQpkZWxheSB0byAybXMob3Ig
MW1zKS4gQXQgdGhlIHNhbWUgdGltZSwgd2Ugc2hvdWxkIGtlZXAgdGhlDQpmbGV4aWJpbGl0eSBm
b3IgZGV2aWNlcyB0aGF0IG1heSByZXF1aXJlIGEgbG9uZ2VyIGRlbGF5IGJ5DQphbGxvd2luZyB0
aGVtIHRvIGV4dGVuZCB0aGUgZGVsYXkgdGhyb3VnaCBhIG1vZHVsZSBwYXJhbWV0ZXIuDQoNClRo
YW5rcw0KUGV0ZXINCj4gDQo=
