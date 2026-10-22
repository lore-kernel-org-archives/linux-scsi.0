Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.148.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792684424;
	b=UkA+f0lqqAjMnkv226LelGJbP88JEZNi+A1vdK5L81rixO7QJ1caRAzXQ/gOaFO3DF7J
	 r7gBW/yD59wcpnzCAmf9EBbdKXlj27b7oEn/T0NTC7/34oF/RtTDkCQh6U0Bjx7c+B9U1
	 Y2doef/xVda0NxZQWS2MxxrXTRfA/KiNanSy1YSL4jik7Ghz6oPuO9XELKDKxUt+JMKco
	 VnGMSLLIJDWt727haiRnT4aw0B8sp2sKyjpxfTR9h1p10jVqgTTAUL96UN2U1PCw5j3eq
	 KiOqhL6ok/GNTQrCCORruRZztnMX9qVUuPKoEywVRT68keRqX7M626uGCywyXLBLeWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684424;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:From:
	 To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=xbsK34nYXhgEv3T3Yi3epHykPLeP4w5zLMg+cxie/04=;
	b=Kpm+Q1bYvN3GxwEew3knkt9aBpyWHT6dhvFYJyTf8v+A9g0gjrRB0hmHNvCCpu87+MhW
	 NhB92ajK1rK6bLWoxRK8Gkgjbxfl1rTdEj1pIVXFVash4A9mTm7/po9QLdAy5OvhIKoVJ
	 69eg8if2b1kja9gCSqd+vkKF9TCsiC4cWtSMMCWSFeI45pkPE+61aHDYwELoOeYmpGQt3
	 wtie7oown8aQKHFy7I4NYeYJ7xtGo5kdZ+0arrPful6x3mj511ZKvO395g1ryZu4aBLjE
	 XgvPR1U+PdCaUHHtMWAd0NMqhVrDS3bJMOT6Izsq70EAxYKv9BAXCeYN7Aa+IdVmhBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=PanDudUM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77562606A325
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 15:53:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77562606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=PanDudUM
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEEibD836227;
	Thu, 22 Oct 2026 08:53:32 -0700
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021092.outbound.protection.outlook.com [52.101.62.92])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hf9a7ccxu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 08:53:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MBFK1h1AuqjorIXFc7pB1OlRXRN2abr7KwcSM1zXCq+HAIPsFOzxKDH4+oeiUs4pb1JJss8bCeFMlXH9RDgChZot4ioMjmc9GczxNiiLrfaTA6IO61S7kLTAA34Fa/cbbp6HC8XMbkI9fuZISN07Gu/Z/5DfY2gVaW71ioELf3XSynz1SjYRY5PnbI0QXPMdOVD30a1MhRWnKqxViIRwiT1MdntdDKpqo2TM54Ngcyz6WyCMLT/unJgoUD8dRUhmRJ0AfdQvzQY64r1ZRBWySaGRaovqpjWX+sBu4ow1f1BmAV4mvVSMT7qArgESBkSpS6k3KEOlWZUHe/9AgIiFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbsK34nYXhgEv3T3Yi3epHykPLeP4w5zLMg+cxie/04=;
 b=kuxuYtGY5MuOSDXWswxWjSlAgQcxUPGCOy4DRFtUiXrYI1CFlLsi002AwvfpixiCJW6VNsvyMVVKabbprME5ljlA7qee2gi8L0St8l04x7L2jz5LykKc2ZhF/SCa0XAFNPEnx1LL0c7KjGkphqtYvexQOqbdZDAuEqmKZ+yuT9q4tOpuHR9aps7IohoVeuVE99Eso2zmSyu2TENQLl4rFRa3MechDuzBk9iX8ZsLiV1p2aW8UyKu6AGT4sQUlNqtSnn2cCIQUEDf/hrogDYtn4SusMqtXpQ9sedqIZbc8dlIxou5DinkH8bNQNsOPHvRwtQs5ZjcJfDDCnOojxqSsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbsK34nYXhgEv3T3Yi3epHykPLeP4w5zLMg+cxie/04=;
 b=PanDudUMtEOoL6IYWv+CA1LI+W+Ygd+s7IoMk/0HN/D52zwyiobzZG6+myGt89F3OBXMcMD4hZzzPrcCZ9pfeDSOTUw7frQB4ruD6bNhHfQO+q6sMZIw4ONGy9J/3kPQLzir60BaoZ/hNytNvxnn5kXpnkP3yZcso28EcEqrjkA=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by DS0PR18MB5456.namprd18.prod.outlook.com (2603:10b6:8:155::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Thu, 22 Oct
 2026 15:52:09 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%4]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 15:52:08 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-FC-Storage-Upstream <GR-FC-Storage-Upstream@marvell.com>
Subject: RE: [EXTERNAL] upstream bug found during backporting?
Thread-Topic: [EXTERNAL] upstream bug found during backporting?
Thread-Index: AQHdYT+krOWBs1zvkke1WtNgan+TXLcJt1+Q
Date: Thu, 22 Oct 2026 15:52:08 +0000
Message-ID:
 <CO6PR18MB45009257952FA733B294B5E7AF652@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <aeeb1af3-8672-4f6d-bec8-1a8e29e5414d@suse.de>
In-Reply-To: <aeeb1af3-8672-4f6d-bec8-1a8e29e5414d@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|DS0PR18MB5456:EE_
x-ms-office365-filtering-correlation-id: 84754d37-8713-4a13-01f0-08df30546d7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|23010399003|261009223027099003|261021130227099003|261021123027099003|261021121427099003|10067099003|56012099006|3023799007|6133799003|18002099003|22082099003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 xVDGgxfiSLqfufGytzKOUeI+k6Q3l9XdCrRPjzjb5tZl8sEdEa6ZgOFVujS4Ig0EvUoAeUqHX4+gDH9l+jl1qOLIPxZ0bSGL2Q2m5hGk8Up4rVdHCwxSS6zN9RIaBG20bEqhyTb2lV7s4BaKUxL7fvIt9a7Nq3QIfiHAhpC0I5+xVOh0GrL1mFHkLjoura0rEzkjG131fEsy1tZTgA77RtTKMXcHf9ltRJFitWe2iNOsmE86xQk21FTiBo8ilV9KJBwU9kOV5h/f6V2Nq5rM0W9AF9HQIM2XjP6oyBt6+Ne5rm5DZSMgzRjVjI3Z10VH8WrknXlSLywsS6voXQP7eya+4b9XiY0Rtaf5q8jLVvYLhAc0TaRgns7PhnO3ya8371UTTO4zFrU9O8/qsiU717Lqj1IHswUFnKeoWSV7zH1++VtHeWR4DOW4tAHMBl8WQ1skAPAHuymOUClS1+VIE9of6wVeD3PeqPzAVMl2EF4WfnJtyQYxxy38x7dHmr5B/2Y55IdXw42deZJxa0Rx3uGfQ/32LKUZDDdncfwGgX9ST+lV7i1+1bXgE6ZqNmdMvVNtDWE2hqRQb5FgZ7873wslSuW3ESN8ADbg4/A8wp4LJ/Wz81C9vsrXWO3ReImV2UnIMv9ZvNq9Q/THfIrUTkXzM7a4kOBjoyaTYnvNWwdnagVSZR9Ss8CeSjNhxYWjAwKYAS0UrKsdqjp2rrouWOzdAZlghpQGAUid2Mt3qHE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(23010399003)(261009223027099003)(261021130227099003)(261021123027099003)(261021121427099003)(10067099003)(56012099006)(3023799007)(6133799003)(18002099003)(22082099003)(11063799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K05FSVhSOURGYlJGTmVBVnN6KzdWVUgxV0ZYQVBVckpTcG9LUklwVWNvVEJV?=
 =?utf-8?B?ZkorWnRCOU11Sm9xNFZxR29yR1FvbDhFd2tZNHM5K3RodzdMT0FLaVYvME9p?=
 =?utf-8?B?MytkNnVUUXZRVXNxVEhxcEJMVnJiSjFJazR3MXgxcjBtL1Z6dWtObkU1MXNG?=
 =?utf-8?B?Z2Vqd0t5TWN4MGNIQU1IdkZCL0RPYXlEZWhsMWRiVlBaTkphQThNOFlXby9T?=
 =?utf-8?B?WXNoRXJZS2ViYXZZZ0FQQmR5enVsdUNBQmZ3OHplUnVJVjVIb05HWmIvTFA5?=
 =?utf-8?B?eXNUVFdKdW1NS1JLWkNsZ1JQV3M5MWMzamN4Z2lBV0d1T3FRMG5kc0o0d21v?=
 =?utf-8?B?U3NXM0hGL0dST3dPSDBOcFdBd3pwYUFTcytLMlh5RzlTWEI3ZVFOVXpuaWdE?=
 =?utf-8?B?TFYxVDFLUjZpMEJRbkxKRlkyT09YYm5lWjNpQ3RkR2s2dCtKUFVHQVZTU1Vn?=
 =?utf-8?B?UGlLN2FLYUpBTHNPd2kxemlyY3F6YU1LU2JwK2lta3ZMemlReXhvSmx6WGNx?=
 =?utf-8?B?ckozTy9QeXUvREdleDBERFR0Q1U3YWRwR29yRTNNZVJjbkp0QUJRZWNORk9G?=
 =?utf-8?B?MUh1bEZ4NTA4enlQa2RielVvMnRJVDM2ZFk1d3Buc0o1bGxKTEl4eUpPSmQy?=
 =?utf-8?B?bWZjUlYrUmExL255WnRxQzV6ZzZZZzc1d0dqWi9OK2FQdUZPSHJ0Ny9Rd3FH?=
 =?utf-8?B?U21rTmp4aUwvN2NXUUJzR0gvRDFwMlMvZmt2NDdhVTZFdzAySzN0d2tKWkRI?=
 =?utf-8?B?d2Y4ckphT1k1VGdtUk1IYlhJWjlrNnVQT3d1T2tVcWxwZTkwRmhWSVNMM1M0?=
 =?utf-8?B?WUtoNnNrWmFrQXRUbXpRRHlNRStySkZOeC8wRlBmamRzOG1QTk5pVTJNOU56?=
 =?utf-8?B?Z2dIYWE2dGNEekt2N1dxNzdCMTdjNFhNVTZqQkdtYkdMYnByM05uTjFTejNr?=
 =?utf-8?B?N0tqUWdUY3UrOXNzbzM1bWVlOEgvZnR4S3lKRUgxTzlIaXpheFVHWHprNXRt?=
 =?utf-8?B?QjFILzdsdlBXa21MSUNOeGJLZWJZZTJDWWtWb1VZUk9Td1FzY3didElBZVhl?=
 =?utf-8?B?cFBLUDdrQ0pvcWJqYVBUR2JEMU9BODg2T0Z1eG1BNGtRczcwQVZ2Y01JQTRQ?=
 =?utf-8?B?aDZUVzBzT004WmVMdTc5RXo2TXhqZXBiVkxNclhwRjNhY0c5ck1UZm1Zb09v?=
 =?utf-8?B?ZHJuNENIYW4xbHZHYjRMUHVKR3NvL2RyVWhXRzVWYkpzdzJXVHE4RDNXUnRv?=
 =?utf-8?B?SW9HWXFXdHdYWVd5RGFNa0xXMStNa0drd0ticFVkcm5NRXV1VHZjcTRUMjRH?=
 =?utf-8?B?bUhKYW5ma0pSTUhFOCtIZG8vQm5EQTVGZjc3T0hISzZVNzkyLzVNRmwwU25J?=
 =?utf-8?B?NXhaN2d2enlzcTVFV205bVdHNytyQ0xISlhzTllLN3pLdVJFWms1NE9YOElQ?=
 =?utf-8?B?UVo1TlJRSy9BdFAwaFVhanNXa3BiMjBlZmMzV21ubHM4bDNnSE5ML1VkVTdH?=
 =?utf-8?B?Y2NmUWJjbnBTaXRFd044NnplOUR1VDdZV2RaMi9qK0Q0MEt1RVVXMkpuaEx3?=
 =?utf-8?B?QmRnamFlRWhva3Q3Y3Q1ZHZGMTVZdTJielNaVHBIOXBHRmFaZEUycmYxOVly?=
 =?utf-8?B?ZGJpa0NJeEJnSmkzTW1ZM1FJU08zM3pLTi9JQUhSQjhGVDVTS0xCSjllMmtF?=
 =?utf-8?B?SE1iNU9kQzFISis0TEdCenlyV0wvSWpvUzdKRG1PakFzc1g4RTNkVC9lLzM1?=
 =?utf-8?B?V0ZDQUdKQ0pBdm4wbnFTcDR3UEE2WFpPdFB5N3BQUXAvUGJhL3hMNjA5dTBa?=
 =?utf-8?B?RHJtdjd6UC9vMUhiU1dYRGowZG8yVWR0cm1qN3FzQlRVc05mWU41K3pMK29D?=
 =?utf-8?B?REZqTjQwMHY3NW5BTHp4UnBCSTVlWjFJbEdqenpBS1RTRGdNRUM4WlNXSmNm?=
 =?utf-8?B?RkUzaFB1NWErbldYUVFKODlaTzJOR09VRDB4cXFkdzRGZ0NiVUxyWmp4Mndv?=
 =?utf-8?B?SzVwWGZ1cXd6TjJ6bEVKTlVJY0lsWTlsRkJDeElWZUlhWXdWM2lXSlEwdTRK?=
 =?utf-8?B?Q3lEcnIrUnFieWFoU2FTa1M5Mm5nZjlKWEgvVE42MlZuZnFuYTBCa1czUDk3?=
 =?utf-8?B?ZXZ0emhRbDFqOEZFb3lUYng5OXBpb0w0djQwU244UFlNclVObVlwTDM1T3c2?=
 =?utf-8?B?YlpiVXI0TDFVMXlOZWEyS1FRNCtiZy9nMFFUS2d2TWhRSkU4a3J0KzdqODNs?=
 =?utf-8?B?QjdHOUZ3MENNVnB3THBaRWluakVuM01tT3FtZWdsVUcxUW10SnBBLzg5RVFv?=
 =?utf-8?B?WjRSUEs4M1BTZXp4NEJZSWE3T1BkSitOZWlKeVlydGk3Z2JsNjB6enJGUTFJ?=
 =?utf-8?Q?auIHMyP2Vqd2i4GtZkBQBXzPKIyJD2L57Kp17?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	PL686xNW0F3Vb1MlXhj9P4ylFlnbxXv9f0617lqSVLcW6eb0Ez1v0WOi4kwYFqBIWOIApY0LyYk3FjBxkhcHkkjcSZE22+Dlax5nGQ+lsnjEuOCvZhl0P6HRWZ3LF2OfIO7uXWrwrtQkKNdXH7gWRWSdAFHf1KmCrviNrGAhKZ/5F/zmJx0SHxMn8ojPjYUW1D3EHM/NMXcTMhySBNZXe9mI9Sl/gE4zATPR2q0M32t646tUfRVpykI6nSkpGBiugzs9x6y1oa3kaxrnbjEjXoiKR5406IEKt4llYtqYRH2USCf1S/+PhGKXYvfLbxZQg82FcPlEvrzM8loeHRMhkw==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84754d37-8713-4a13-01f0-08df30546d7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 15:52:08.1571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /agB1vL2u1Z/F6nDINmNFi1yw6sqaDf9hzxVkughK8ZjmprH0JpeUoR0ityCCrIr/Bv1d5W0YBbCpuyQQv7Sxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5456
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA2MyBTYWx0ZWRfX/eqqhU+VpzB6
 xxAo10cbNCAJZhHGaYS8eP9mez3OqSbKdSNsLyA+X0IMSujZNthm4hEWmtpbPjSzoctZ0dZZRLC
 vk6qc4s05BG95KE5CeqKtqfYBBVjW6unwL9OuDqB94Oug9TwIGzQCSXuwAJOqGmZfQFkrzlVuuk
 D38SoDJQcOWF9At2ajvOFHl3r9IjASwN3hO1NUXKi+EOpblhLLG8yy9T3CBfJEwNVq/ZiGCvXXO
 1VyQCkBJqFOXaQBRcvPSNqtBlvb1z2mAgls7O7K/tbOWy/S8+872Rwo4t+52fhoTrAhmPEQluBN
 HU4hxYKto62i0iaIVlinqAIgCLtF1xHS7MtFUiItjAK2kg70Pz7cydvsZQjD/1SdPcO0OvaL7De
 nAsz8VJ+E80NWyUb7BcsCxkFaMvpjMzU5OTQhITrncm520jxJgtoAgWn0BBxI+eBY+W+Id60SPM
 zptwg+6+RHvx1Okm1Bg==
X-Authority-Analysis: v=2.4 cv=RcIFmFtv c=1 sm=1 tr=0 ts=6ada317c cx=c_pps
 a=v2TZfKysXdkZaZqPd8ZU/g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=RpNjiQI2AAAA:8
 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=kl9hUh7SPXlW1E-DkMAA:9 a=lqcHg5cX4UMA:10
 a=PRpDppDLrCsA:10 a=QEXdDO2ut3YA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: et20YMrXLy0WOSa5Qm_A7Gn-sTaGlw6N
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA2MyBTYWx0ZWRfXwh7Y7AC4gHFi
 Q3L/OA4ByVQrqTqYDVOC2IDX2Kpt6vljYm6AKpnZ8aIFrkm4NTnkD9Wf+J1LqUlaiCXhyce7sZJ
 yEJW01qbq54vl9IqV6LsrR24qsCnnLs=
X-Proofpoint-GUID: et20YMrXLy0WOSa5Qm_A7Gn-sTaGlw6N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_05,2026-10-21_02,2025-10-01_01

SGkgRGFuaWVsLA0KDQpUaGUgaXNzdWUgcmVwb3J0ZWQgaXMgdmFsaWQgaG93ZXZlciBTUkJfRlhJ
T0NCX0JDTUQgaXMgc2tpcHBlZCBtYXliZSBkdWUgdG8gdW5zdXBwb3J0ZWQgYWRhcHRlci4NCg0K
VGhhbmtzLA0KTmlsZXNoDQoNCkZyb206IERhbmllbCBXYWduZXIgPGR3YWduZXJAc3VzZS5kZT4g
DQpTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMjEsIDIwMjYgMzowNiBQTQ0KVG86IE5pbGVzaCBK
YXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQpDYzogR1ItUUxvZ2ljLVN0b3JhZ2UtVXBzdHJl
YW1AbWFydmVsbC5jb207IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbRVhU
RVJOQUxdIHVwc3RyZWFtIGJ1ZyBmb3VuZCBkdXJpbmcgYmFja3BvcnRpbmc/DQoNCkhpIE5pbGVz
aCwgSkZZSSwgb3VyIGludGVybmFsIHJldmlldyBib3QgcmVwb3J0ZWQgYW4gaXNzdWUgb24gYzQ0
OWI0MTk4NzAxICgic2NzaTogcWxhMnh4eDogVXNlIFFQIGxvY2sgdG8gc2VhcmNoIGZvciBic2ci
KS4gTm90IHN1cmUgaWYgaXQgaXMgdmFsaWQuIFRoYW5rcywgRGFuaWVsIGNvbW1pdCAwYzc2NzRk
M2Q2NWExYjJiMTc4ZThmNjY0OTVlNzliMDQ4YWVlODM0IEF1dGhvcjogRGFuaWVsIFdhZ25lciA8
ZHdhZ25lckDigIpzdXNlLuKAimRlPg0KWmpRY21RUllGcGZwdEJhbm5lclN0YXJ0DQpQcmlvcml0
aXplIHNlY3VyaXR5IGZvciBleHRlcm5hbCBlbWFpbHM6IA0KQ29uZmlybSBzZW5kZXIgYW5kIGNv
bnRlbnQgc2FmZXR5IGJlZm9yZSBjbGlja2luZyBsaW5rcyBvciBvcGVuaW5nIGF0dGFjaG1lbnRz
IA0KwqDCoGh0dHBzOi8vdXMtcGhpc2hhbGFybS1ld3QucHJvb2Zwb2ludC5jb20vRVdUL3YxL0NS
Vm1Ya3FXIXRlM1R2MVgtNGxfd05Hd2R1UjI2TFlRVXpZNE4taGM3d08yQmJMRnNiWDV2c3NfQklL
ZVNTUktoU1RwVnRnc3l2dF9ieGNaREpGdjg4VkhDOWNTWTAzNHh6MzVXYnckwqDCoOKAjCANCg0K
DQpaalFjbVFSWUZwZnB0QmFubmVyRW5kDQpIaSBOaWxlc2gsDQoNCkpGWUksIG91ciBpbnRlcm5h
bCByZXZpZXcgYm90IHJlcG9ydGVkIGFuIGlzc3VlIG9uIGM0NDliNDE5ODcwMSAoInNjc2k6DQpx
bGEyeHh4OiBVc2UgUVAgbG9jayB0byBzZWFyY2ggZm9yIGJzZyIpLiBOb3Qgc3VyZSBpZiBpdCBp
cyB2YWxpZC4NCg0KVGhhbmtzLA0KRGFuaWVsDQoNCg0KY29tbWl0IDBjNzY3NGQzZDY1YTFiMmIx
NzhlOGY2NjQ5NWU3OWIwNDhhZWU4MzQNCkF1dGhvcjogRGFuaWVsIFdhZ25lciA8bWFpbHRvOmR3
YWduZXJAc3VzZS5kZT4NCkNvbW1pdHRlcjogRGFuaWVsIFdhZ25lciA8bWFpbHRvOmR3YWduZXJA
c3VzZS5kZT4NCg0Kc2NzaTogcWxhMnh4eDogVXNlIFFQIGxvY2sgdG8gc2VhcmNoIGZvciBic2cN
Cg0KZGlzdHJvLWNvbW1pdDogMGE1NzlkMDAwMDQyNTFhYWEwMzQ0MzI5YjVmMTI0NzhiNWJjNDcz
Zg0KR2l0LWNvbW1pdDogYzQ0OWI0MTk4NzAxZDgyOGU0MGQ2MGEyYWJkMzA5NzBiNzRhMWQ3NQ0K
QmFja3BvcnQtdXBzdHJlYW06IGM0NDliNDE5ODcwMQ0KQmFja3BvcnQtc3RhdHVzOiBjbGVhbg0K
DQpSZS12ZXJpZmllZDogMSBjb25maXJtZWQgaXNzdWUuIFRoZSB0eXBlIGNoZWNrIGZvciBTUkJf
RlhJT0NCX0JDTUQgd2FzIA0KaW5hZHZlcnRlbnRseSBvbWl0dGVkIHdoZW4gcmVmYWN0b3Jpbmcg
cWxhMjR4eF9ic2dfdGltZW91dCgpIGludG8gDQpxbGFfYnNnX2ZvdW5kKCkuIElmIGEgQlNHIGpv
YiBvZiB0eXBlIFFMX1ZORF9GWDAwX01HTVRfQ01EIHRpbWVzIG91dCwgaXQgDQppcyBub3QgbWF0
Y2hlZCBpbiBxbGFfYnNnX2ZvdW5kKCksIHNvIGl0IGlzIG5ldmVyIGFib3J0ZWQgb3IgY2xlYW5l
ZCB1cCANCmZyb20gcmVxLT5vdXRzdGFuZGluZ19jbWRzW10sIGxlYWRpbmcgdG8gYSByZXNvdXJj
ZSBsZWFrIGFuZCBwb3RlbnRpYWwgDQp1c2UtYWZ0ZXItZnJlZSB3aGVuIHRoZSBjb21tYW5kIGNv
bXBsZXRlcyBvciB0aW1lcyBvdXQuIFRoaXMgYnVnIHdhcyANCmludHJvZHVjZWQgaW4gdXBzdHJl
YW0gY29tbWl0IGM0NDliNDE5ODcwMSBhbmQgcmVtYWlucyB1bmZpeGVkIGluIA0Kb3JpZ2luL1NM
RTE1LVNQNy4NCg0KUmV2aWV3LW1vZGVsOiBxd2VuMy44LTI3Yg0KUmV2aWV3LXRpbWU6IDU2Mi40
OSBzZWNvbmRzDQpJbnB1dC10b2tlbnM6IDMzNzk1DQpPdXRwdXQtdG9rZW5zOiAxMTYzMw0KVG90
YWwtdG9rZW5zOiA0NTQyOA0KDQo9PT0gRmluZGluZ3MgPT09DQoNCj09PSBGaW5kaW5nIDEgPT09
DQpDYXRlZ29yeTogQ0hBTkdFLTQNClR5cGU6IHJlc291cmNlLWxlYWsNClNldmVyaXR5OiBtZWRp
dW0NCkNvbmZpZGVuY2U6IDAuOTUNCg0KTWVzc2FnZToNClNSQl9GWElPQ0JfQkNNRCB3YXMgcmVt
b3ZlZCBmcm9tIHRoZSB0eXBlLWNoZWNrIGluIHFsYV9ic2dfZm91bmQoKS4gSWYgYSBic2cNCmpv
YidzIGFzc29jaWF0ZWQgU1JCIGhhcyB0eXBlIFNSQl9GWElPQ0JfQkNNRCwgaXQgd2lsbCBubyBs
b25nZXIgYmUgZm91bmQNCmR1cmluZyB0aW1lb3V0LiBUaGUgZnVuY3Rpb24gd2lsbCBmYWxsIHRo
cm91Z2ggdG8gdGhlICdTUkIgbm90IGZvdW5kJyBwYXRoDQpyZXR1cm5pbmcgLUVOWElPLCBidXQg
dGhlIFNSQiByZW1haW5zIGluIHJlcS0+b3V0c3RhbmRpbmdfY21kc1tdIGFuZCBpcyANCm5ldmVy
DQpyZW1vdmVkIG9yIGFib3J0ZWQgYnkgdGhpcyBwYXRoLiBUaGUgY29tbWFuZCB3aWxsIG9ubHkg
YmUgY2xlYW5lZCB1cCB3aGVuDQpmaXJtd2FyZSBldmVudHVhbGx5IHRpbWVzIGl0IG91dCB2aWEg
dGhlIG5vcm1hbCBjb21wbGV0aW9uIHBhdGguIFRoaXMgaXMgYQ0KYmVoYXZpb3JhbCByZWdyZXNz
aW9uIGlmIHN1Y2ggY29tbWFuZHMgY2FuIGV4aXN0Lg0KDQpFdmlkZW5jZToNCk9sZCBjaGVjazoN
CiAgIHNwLT50eXBlID09IFNSQl9DVF9DTUQgfHwNCiAgIHNwLT50eXBlID09IFNSQl9FTFNfQ01E
X0hTVCB8fA0KICAgc3AtPnR5cGUgPT0gU1JCX0VMU19DTURfSFNUX05PTE9HSU4gfHwNCiAgIHNw
LT50eXBlID09IFNSQl9GWElPQ0JfQkNNRA0KDQpOZXcgY2hlY2sgKFNSQl9GWElPQ0JfQkNNRCBy
ZW1vdmVkKToNCiAgIHNwLT50eXBlID09IFNSQl9DVF9DTUQgfHwNCiAgIHNwLT50eXBlID09IFNS
Ql9FTFNfQ01EX0hTVCB8fA0KICAgc3AtPnR5cGUgPT0gU1JCX0VMU19DTURfSFNUX05PTE9HSU4N
Cg==
