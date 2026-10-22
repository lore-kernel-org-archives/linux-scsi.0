Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=60.244.123.138
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792660044;
	b=4jvHebNFa+tWMJjhTNawx/iKltXOlWNIwfMgRxck05CMQfOgpPeAOtX8unERe/WAHfRY
	 iy+MjpDP//uOOQpDE/u+ZiwAZrq+eu4eODt8uBsUO9OfZRASDpXmQ7i+ow2jhSj9aVNrl
	 dgVRHVvgRlHDerVjiZge9C3XHQ3BfEmbOmP8RouS//Gr9IkTCu5WG7mLC/CH0BAZn3dtJ
	 agkm2fvZjNfuROZjxzJSEZqt8SuAxUJ3neCW1CQsHmSOlXMaVaQ5URZz5ZHqJwvAfdZMM
	 QXn3Q4mWxd7PxPEmz8NuxTgfnPucsy/spaaDkYs4t/kJYvRHYhwG074okluX1fjvo0Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660044;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-MTK;
	bh=MazLPJ3DBsJN9RFanmB667ow/OtQiJQmfY1WDQOZoLo=;
	b=Yob8DHqc5MWMc0s0fCibRhGziI/dF/Y59s9upYTgm4Offj0CtcvDDMcqqsEGg9dS+U8I
	 pA1/3xNNJElVz41UCzsDLL7PbPkqwRSUT6wnEK5XsoSLgEruhNhVCmP52lHOq7lNPwMMF
	 x+WoyI+Xt1wLWi1OPbxupSSA4rJd7WLu9UBYFP+XsD1TsF8opexzAysA0+fFnzCPj/rRl
	 XBIAP+FjxcU+tcXPoG7KvDRwKqrkx8PbxiHIJCXS0RVxKebPSdOYIv8qhB5D5Ep5O6vL/
	 NPZP5vwQlbHJmHo2U2t/5xXf7dwNmpknnchr9VI6PIxo711hdTws6PTq20YWZPMAD0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=bYDbZoNV;
	dkim=pass header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=DH54D0ZP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (mailgw01.mediatek.com [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA210606A31D;
	Thu, 22 Oct 2026 09:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA210606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=bYDbZoNV;
	dkim=pass (1024-bit key, unprotected) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=DH54D0ZP
X-UUID: f46fe0f2cdf711f1b1788b6acf885367-20261022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:Message-ID:Date:Subject:CC:To:From; bh=MazLPJ3DBsJN9RFanmB667ow/OtQiJQmfY1WDQOZoLo=;
	b=bYDbZoNV+vjq1LhbtD2VBwM6QfEZ/IfSakTipjw/rAZ3NI1ZiGl4I/erhA97FqZm0yO4e9/lseU5GcoTQDWf7rdTaoewEfkRfk63J/5sSVXUgpZJSaNnxa4IoWWgkReLmru4Xk4DKoKyT+4wGy4g+IBFCfNbkalzoL3sxXK8itM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:4f88f15a-d3e2-45a7-9b86-cbcb1ecea315,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:cec63102-b530-47c2-8ade-3ac31d914949,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f46fe0f2cdf711f1b1788b6acf885367-20261022
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 590412274; Thu, 22 Oct 2026 17:07:06 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 22 Oct 2026 17:07:05 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 22 Oct 2026 17:07:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ywOb25wJKwL+FrP+gl0PQ2kruhT8chFhIOV9k+t9BxEzIdNDvkNj38cQfpHa1zNCUrDLZc4T9v7HsGIbppV/ns7QpJrTIJ4LSa6hh7mWOR0hkqWRY2Y76Qv7wllFQILzHSQ6IcmU4nIh/3tMvOMePQBMPi/sikG80GuJ7YQrADdUSZGwJF5lBg9gKZz4ZVgKmE6EjgUrr06+ibL29qIHmeAwzJDmvy5jcwjpY3mQ1fnHfVyxHGMiKxMtSMH956jq645YgiUvkfcwxLDMF10KpOtsa10QGoyXDRQTQ60rZJk3zVTRoR2XtVJO13jVavreW590pfiFZvfOybkkIV1cGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MazLPJ3DBsJN9RFanmB667ow/OtQiJQmfY1WDQOZoLo=;
 b=taj1EMLXYGmXxj5lmc98yerdqmz/s5+XPYTWpjwdIYmuVqVIEWctueRFI/AbLud/0dolNczTqQb+RaDJVVVBHrvCOM/PpsepilazxUGoFkNY8hqygOL6B9ogJ4J5i2PhAqST4Z7HiUIc2ymm+Id6r+OsjqwPUw2aD2NJWcMzBwB8DKhGoHwdTUeN8qnXiiAzS3pqEiisATCrw17CvJZEAmLYjiX0my7UKfiyjyVuzrYFGdIzYKkV5GtuBK3ALXDnw+O6XcbM11TPcTCVoCFCirt9lN8loOif5SO05ArJKp2I4laalY273UgFyJpsm1aL4T5rOmF5A+vKtOeyKY3wrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MazLPJ3DBsJN9RFanmB667ow/OtQiJQmfY1WDQOZoLo=;
 b=DH54D0ZP1gIey6mBTSsqoAmCOsQwjL4ihqoLOT2H++9/Vr59iiYAKxQTJ3/DTcDiPWTzpF10uZCGVmmUcgOK/cgkct+D95/jnC0d+WcFUeH2iQtdY+B6m8+CLt/0tK948G+E5J2T7u31LciuxSk80JSr0/ZeWdzinxGKWfvit5Q=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9389.apcprd03.prod.outlook.com (2603:1096:405:2b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 09:07:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 09:07:03 +0000
From: =?big5?B?UGV0ZXIgV2FuZyAopP2rSKTNKQ==?= <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>
CC: "Martin K . Petersen" <mkp@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@hansenpartnership.com>, Bart Van Assche
	<bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo
	<beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] scsi: ufs: core: Fix double release in
 ufshcd_abort()
Thread-Topic: [PATCH v4 5/6] scsi: ufs: core: Fix double release in
 ufshcd_abort()
Thread-Index: AQHdYgSzcOsG1OT80kmrUp6ujTsEtw==
Date: Thu, 22 Oct 2026 09:07:03 +0000
Message-ID: 7069e97abca491cf0604cf4942a07558fe8232a0.camel@mediatek.com
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9389:EE_
x-ms-office365-filtering-correlation-id: a6c9fc80-21bf-4686-68f9-08df301bd694
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|10067099003|18002099003|11063799006|261009223027099003|56012099006|38070700021;
x-microsoft-antispam-message-info: ECE3DEGKoyjW47SIgZkxzH6x6AHcsKcMgaJfNEX9T8fPZ7Y87bMdjqllArkt0XNKX/CMLS9Z4G5bIvm3g9/d6ifwtHT08hSjOTy7NY0yam8MhoP4eVD2kFJ4B4rznI0sywNkpFYDTVqPUPvC09a+4UaLi4cHnleziZfcKhGXfT5dP2DF4BV3JJ4yAbXA+19wpESScZIZhvdmOiuuLk878P6LWGT6FfCk+j+v+BS9JqJ7vCJf9bPXym51HknwPWZMfcKDTseAn700v8iKXe5LVMwpb2ffT8W2Ym3Ci5Jok4l1EWSjkTcf8laBO+4ciAudyIfnAo2AABbiUJ8ehnBqV7bCJyW08wKbjkpA/eRIngd6DXApp5KyeOUpOTvBsdLpKceRLc7j8aOjfoLHiOxnsYxAangj+rv64HZEkMHYPIX0XLkPxZd9tP2idwhYlSiNzGPCS9XrZJj9RG0uBqlMAiLRilSGWysEyiWMwlpdGNo2qyyLE2I+AwZ0bHk/b3idef8T9DvJlcH+UXioE2E9X82eULpF+qntIMG7uWrXQGzvKOLqlk3/KWqxAK2DBv6BhsmBOc9P/9XnX2BSyMz8ZNNTkB85haV4qFzE2QL43kLlG1UGxoDpyuxc1hS1rbjj6FebyLlhU47SQ/zqJErUcW83jN2EslVfuZKGWwx64dL9jeKJSATiiKSSV2AFYRXZaeN/gSADAOGFS0ZUdfBLE2VWV+t74Nkj9PaoyUFhgsg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?TlFObS9UTU8wQXFXZVNNNHRpTmZBalJPcjE0K1E3eUU1Z1JoM0xoVUUxYnhpT0U1?=
 =?big5?B?MlhQMWt3cVVQM2lod3JudEFFejhJRU52Z2N3RUN4enptZzlJMVc2YVppR1p0QVRB?=
 =?big5?B?UE8rcFlqcWxKbm14OENjVzNucHlPVmkwekpiSDRFcnZWdExTVVhlUzhEU0JPNUNi?=
 =?big5?B?NG91UkQ2cXlDdjQxeXBNMjhMejI0Wkd1OTVBay9SL2U1SUE1SFNYZ0RVUXRqOWND?=
 =?big5?B?NmxBRXZ6ekg2K0t1R0VHc3hPWEdUbVJZa1JnVG9kb1VFNExKcE5hZmdyS1F2bTJ2?=
 =?big5?B?a2t6ZUVoY1AyYTAvMm5PaFZ1eGdpcU9NU1J2V3R6VjNYUHhFVG9tamRSWStRS0FM?=
 =?big5?B?eERDU2lUaDlQNDF4N0hNVlk5TW9XbWkxL0EraGJJWE4xeEVoY2JpalBkSHJHcTJV?=
 =?big5?B?Tm8yaURIaVpvMlJmQTVsc0NsamdrNktDTmVlaXBxdjZEamdtLzF5OHRDblhJNmJV?=
 =?big5?B?MWhNYW1nN3JNMWhxWjNuTENSWElRM1lRWHFzZzJ4YzE3eS9jdlY4cVlrL3k1Zlow?=
 =?big5?B?QTFQSndQWVUyTy9ZTVVySDRDalN1RjlDYjJBRGdybTgzSi9hR0JFd0JWYnROQ2JK?=
 =?big5?B?a0t3VytUNFdKaC95amV3QjNCbFRyYlZGU1NsMDU2dnhBc3FQZkNINHU0RWxCM0N1?=
 =?big5?B?UktXWmFTcXJoTW14SE9rMUZoc1lOdEdzZGpiQUZXdUwrK0dRdUlSL28rWG1CTDNz?=
 =?big5?B?a3pCWk04TU5CSnUzU05GRWVTRWM3QVdVSWszd3RYRVVYK09EZkRFbW9UWlh4b2xa?=
 =?big5?B?ZUVIVjQ0QndnNFE2dG5ZemV6cW13YnBESk5aZmpNL01iZFlsWmVSUVd6YmsyQ2dn?=
 =?big5?B?V29xeU1PQkY2bDBORDR4SWpMNThjcjNwd1JsUnREaTdCQ3FwbytxQXlYZDhDdHl4?=
 =?big5?B?Q2xwZTNSVWVtcEwveWYySHpwSTRETFI3aHFXWk91dmpkek8zUVRZUjY0NnhZT0Zt?=
 =?big5?B?Zm50Z2VVYnorRUhld1J3TkhLbEk1T1B0OXFEMDhtWkRpeHEyRFlZN0VyREVBS3ZP?=
 =?big5?B?TCtZbFU0NDFOSHhZTGs0dmt6MGNabUg3N21lS3JwcmhQU2RBZlMydW1rV0ZRRGlC?=
 =?big5?B?d0xTTHRGa3dCQXdFTjd3UHYzOXNCTGUvUW9aU09kYk0wQ0JjOU9JSlpnajM5aEM5?=
 =?big5?B?S0J6RzBlVnB3VGY0K3RUZVJwT2JsRkRsdEZxeUFEejBISVJRMDJQQ3dwZERrQXNu?=
 =?big5?B?NWJCUWszNTdiUVRINXN0SVRoNjhJa1dMS0lsbVY4YmphY3RZSGFrYWxmNWlNenlP?=
 =?big5?B?VHRkNHFrWEx0aHJ3eUJYT2RJNW1kaElYeVVZWnBsVkhDTHYyaUNXNmFpM1Foazd3?=
 =?big5?B?ZWdOWWFkYmd4OFpLZHZjMG90bE1Db3E0eUlxcjZJdVluQmVOUXMwMzBSczdlTGEr?=
 =?big5?B?eE13WUNSVVZ5SXUrV0U5aU52QmtlM09RNGI5SW9EWTZneXduV0Y5RHBNQVU4UUI2?=
 =?big5?B?ekpTa3R0TkloVHE2U01rVmlXRWZPTWI0U2prZVM5cTc2eWhremt0K1EwMzczRW5S?=
 =?big5?B?NXFlaUU1eXhraHRGTGFqOTVPZ0M0UnBIZHZ3VFFZREhiT1hTVjN4SDcyVlJOS3RS?=
 =?big5?B?YkZjakVtOHNwRFN4QjUySHZ1U0NGSHQvT21Kb0VOVzNtTlJobFVkY1M1dGtrcFV0?=
 =?big5?B?bWtmWUZ3Q003ZzlZRTBNak5ocE1xNWdGTENpcFZWY2hla05rRjBrcHhPOVV5NWJ3?=
 =?big5?B?eUh0ZnoyL0dJaERoNWxRQTkwMkJ3TzN5U3I0dkVGU0VGWXBjTTErZVdKSm53Y09W?=
 =?big5?B?U0hVWGFKZEZjNS96UFBOZngzdUdGZlJGZElSc1dkZ21qVFc0VHdsYjlhdDlablFk?=
 =?big5?B?SVlwZHJXeXFBaktpKzBHc2MwNWZvRmYwS2U5WER5OG42NG40ODkrOGlIWkZIby9J?=
 =?big5?B?UWlHdkxoL282R21DUGRBUmtQSytpNDJ6N2hFdkpqR3ZVR2F5QzdNaGZ2YXdyU0s0?=
 =?big5?B?d3EzZk5lRDZqb1R1MGhlL2VrcGFpY0xQdTJVUmxiR3Q3YUNPYUhHalRUL1M2YTB2?=
 =?big5?B?UlNQdzh3SEh5Q3gwTW4vcnhHbFd6cDRjajd2aVNUY2JXbEtqUEU3NEdkb1VxQVV6?=
 =?big5?B?SFBiUkF3QUQ4aEx1Zmh5eWxLa2RuVGN4TVVBYm1pWWJBUS92UFBCZGxWNWlqVUFq?=
 =?big5?B?bUJDUGFsc1k4N0hsc3ZOUlZJdWcycU5UeEFjQm1uUFJsWXNiUzFnWS9hNnErUXZa?=
 =?big5?B?M0VpTTAxeS9HZDdUbDV2QmxlZU1EUT09?=
Content-Type: text/plain; charset="big5"
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
X-Exchange-RoutingPolicyChecked: jJqh3ANgNalae5WQ/tgKqLszat2YTnBeSjRcnjmwgRr18GKciEqk/mT+mUNoeLypIZHay7DhyrjE0lQaMkhBDnoTE3XfYbHQLUHu65zNDxbQsunDGVpE1DkwyNlxNOZPYItxM7Z+G8FxcucGeXXRiVUCKXLUyINNCHbHV5QSxah/eRBXm8bupyq2M2N/3D0UTj9avVvg2DWQPeqH90FzqH68a07fgLU1s7ey709jToEaRhoVwEuV8a2aYq4bo9uK8cb9iLRruMxyf0F9fpwLuYrD3aZ3LuILjB3u6gEPCFjFH9cfvaAl81IpE2tMKY5RX6M9ZtKPydaPIIL8qUJDJQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c9fc80-21bf-4686-68f9-08df301bd694
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 09:07:03.2050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BD1gSDPIvSLrstEcDkdm7b1SFmvuvKswbxTAbwzd7RP6/vBSW+4GIBQdkHlhA0emUU61RwAwncBQksImpsW0lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9389
X-MTK: N

T24gV2VkLCAyMDI2LTEwLTIxIGF0IDA4OjI4IC0wNTAwLCBTdGFubGV5IEpodSB3cm90ZToKPiBP
biBXZWQsIDIwMjYtMTAtMjEgYXQgMjE6MTIgKzA4MDAsIFBldGVyIFdhbmcgd3JvdGU6Cj4gPiBJ
ZiB1ZnNoY2RfY2xlYXJfb3V0c3RhbmRpbmdfcmVxcyhoYmEsIEJJVCh0YWcpKSByZXR1cm5zIDAs
Cj4gPiBzaG91bGQgd2UgYWxzbyBzZXQgZXJyID0gU1VDQ0VTUz8gU2luY2UgdGhlIHRhZyBpcyBh
bHJlYWR5IGRvbmUKPiA+IKFYIGVpdGhlciBieSB0aGUgSVNSIG9yIGJ5IHVmc2hjZF9hYm9ydCCh
WCBzaG91bGRuJ3QgYm90aCBjYXNlcwo+ID4gYmUgdHJlYXRlZCB0aGUgc2FtZT8KPiAKPiBBIHJl
dHVybiB2YWx1ZSBvZiAwIGhlcmUgbWVhbnMgdGhlIGNvbXBsZXRpb24gcGF0aCwgcmF0aGVyIHRo
YW4KPiB0aGlzIGFib3J0IHBhdGgsIGhhcyBjbGFpbWVkIHRoZSB0YWcgYW5kIG1heSBzdGlsbCBi
ZSBydW5uaW5nCj4gdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKSBhZnRlciBpdCBkcm9wcGVkIG91
dHN0YW5kaW5nX2xvY2suCj4gU1VDQ0VTUyB0ZWxscyB0aGUgU0NTSSBlcnJvciBoYW5kbGVyIGl0
IGNhbiByZXRyeSBvciBmaW5pc2ggdGhlCj4gY29tbWFuZCByaWdodCBhd2F5LCBzbyBhIHJldHJ5
IGNvdWxkIG1hcCB0aGUgc2FtZSBjb21tYW5kIGFnYWluCj4gd2hpbGUgdGhlIGNvbXBsZXRpb24g
cGF0aCBpcyBzdGlsbCB1bm1hcHBpbmcgaXQuCj4gCj4gUmV0dXJuaW5nIEZBSUxFRCBoZXJlIGFs
c28gbWF0Y2hlcyB0aGUgY2hlY2sgYXQgdGhlIHRvcCBvZgo+IHVmc2hjZF9hYm9ydCgpLCB3aGlj
aCBhbHJlYWR5IHJldHVybnMgRkFJTEVEIHdoZW4gdGhlIHRhZyBpcyBubwo+IGxvbmdlciBzZXQg
aW4gaGJhLT5vdXRzdGFuZGluZ19yZXFzLgo+IAo+IFRoYW5rcywKPiBTdGFubGV5CgpPa2F5LCB0
aGF0IGlzIGNvcnJlY3QuIFRoYW5rcyBmb3IgdGhlIGV4cGxhbmF0aW9uLgoKUGV0ZXIK
