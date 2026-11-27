Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.166.238
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795783775;
	b=R4VfNAR1FI0dbq1dNIy6YuxsVvKQtd+XEXjAI7s5bAMM4LAuof7FSzXtypg6xAPdZ+Gh
	 ZXIUJLNxHewmr/0f0hoDMnwUU6o7CygzjPEli2k3RL1X/hQU23Cd5Kzp4ALOwmEwH1KZe
	 o9v65eRykBba2yy2UGo7gh2HcgpKPFDCluhMhGmC5ET6d+2kuA7Rm/ovsc9IMhaI4yGvv
	 5K0SJlsyv/okae5urq3NvrgsA6QJg5JexEwJz//sSpJOCrbnN+ipxC2BPc0X95VeQNRP7
	 An49glbbQgePFVtSXkRTTA4giSfmNWWn5WwLzp0hSFGRvXgpW4FS1NPvShsv+eaAMlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783775;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qX2QxydGOWQ0foSOYe+aF/9HCH/m0/YglsA+X/KctSA=;
	b=5XnJQCu2tv+TQyljhifRJhy5KywqtghGCsxPYdnFBXDDTju+6/8XHAttALR2lx8OR9oV
	 louJg8v04EnGdHo9La1gKmBPvXbvPoNSB4d55JuY9mp7mDu+lA7xkf2xGCx47wdqpTRlN
	 OE6ZZZ09vbAXQiLVxWFxjLpAAvXlEI5mu0YzmQY+95ovEWTmIZpRVH8I4jjkk3dHeUJV7
	 S1kgoK90k9/hZXJnqud7s/ZZa8dvx5YZaRELeEJgMfORQgi++Ey8viyg/0Y3ZlW72SCfr
	 y9KOYr9opHt+wtiiaSRFRxG8G4MVwbnIRpQiIr/vboU9lcbHJRorOUIQwn4td9kebIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=windriver.com;
	spf=pass smtp.mailfrom=windriver.com;
	dkim=pass header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=WRREZ3ml;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.166.238
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C2E606A31F;
	Fri, 27 Nov 2026 12:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5C2E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=WRREZ3ml
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARCgDoo1163933;
	Fri, 27 Nov 2026 04:48:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=qX2QxydGOWQ0foSOYe+aF/9HCH/m0/YglsA+X/KctSA=; b=
	WRREZ3mlLgJuhE69lh/foBz11vZ1iap0BfINWFbeDwzueE6Xz9VkMBPMR3vM+KhQ
	UYlbbUV7j7KLVmcMukJwbEI3QBWoqwQ4PGzm3XdbZXHBVEMKHsHFne1ANokkeLVq
	SmZpldINhsYROCqUXjMNXaqB8fBa5Y7k04/pBAjrlrZiYJlbANxcMwyNdLo1YhEC
	SPw6eskYeZ6/CShMMqOuitoNatPoto7w0zAXNZ5uLxaIvk2VtZqVQg3BUq22GUhh
	Y5tcX32s4nNnD7dTBXH2zOwUic5oLfVwPqVdi96xmGoRxUhAy+ufsevtkyYv7SFN
	gprF0+WkWuBUvUlmDMoVlA==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020089.outbound.protection.outlook.com [52.101.61.89])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4j516x05jm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 04:48:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpeDPCRt4WxwVqiFF9NpjwNAYNBq87EX235wHoK6WksweuBsBaPEQ2yuQS9HLNQMp9TAsf93hC9QI5bXIFqiH779jc1a5pGzIe5VwPM/MSBOk3HcUmpJE8m9Qg6jnXxwZkVH3dJJS6Aoo0CjRntQrgt92V4X4NR2Kw3UUOdZljvYmuQORQXkswGpDz4JZ0aYY9Ux8SLhIs30PhAoC/TIpZWMpcivQR8UizfLUsU84AVWMUUPtwBAFKaje9Kv6z8i/Dc09NAXx4hBCrNpPRf7oWsXzhr0XUnSLx0cFGayJ4NERe2rF/RuT3iCqh/L88Vy6JKRxyUqGX+GN9mqFI87RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qX2QxydGOWQ0foSOYe+aF/9HCH/m0/YglsA+X/KctSA=;
 b=mhEpsMHF4rtJzw4nCDzGXGbJVSh2T/wyE9pp0lu4q/J9JmJobSYIBMO7fVGA8HvQdbOeFIsIzUVUMSq96VXZc5RyCcjNXKTEoh7bojpQdc2HfdbarlFRVtazLsu2FOzyWEHnU/e7FPAXfyq+U4W1sZoBTXnFnVS/N9tpWWaAZrkdj38A+qG4+uQR6Cpf+kZn6lsfI8CkuPN+jJ+ajI5kFTfQ9sBQ4vBf0j3at1MC34A5WR2lZ5eUVlsFf5eeL80zQXArbl7Bu+TYodTXYy5U2p4/t9ml6ZMbCYnt5qPReHCJrMmqYUfxraTEzQg+Q+aROsoXNOT3mdAEJOtIoEbgTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by DM6PR11MB4642.namprd11.prod.outlook.com (2603:10b6:5:2a2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Fri, 27 Nov
 2026 12:48:44 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 12:48:43 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, bigeasy@linutronix.de, corbet@lwn.net,
        frederic@kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, marco.crivellari@suse.com,
        mingo@redhat.com, mkp@kernel.org, neelx@suse.com, peterz@infradead.org,
        tglx@kernel.org, vincent.guittot@linaro.org, wagi@kernel.org,
        Ionut Nechita <ionut.nechita@windriver.com>
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Date: Fri, 27 Nov 2026 14:48:16 +0200
Message-ID: <20261127124817.15699-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <rfppj6h3dfwsyvstju6k62cigzicdhoqy7j6yo7fnne7tcy3no@fvjpn5glg73m>
References: <rfppj6h3dfwsyvstju6k62cigzicdhoqy7j6yo7fnne7tcy3no@fvjpn5glg73m>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VIUP296CA0040.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:34d::18) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|DM6PR11MB4642:EE_
X-MS-Office365-Filtering-Correlation-Id: a43e2ed9-4da5-4993-7c20-08df4c84c525
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|52116014|23010399003|38350700014|10067099003|11063799006|56012099006|261021121427099003|261102123227099003|261026140227099003|261022075727099003|261022105027099003|261028144727099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	cIw+/Bfw5bpGDGLwIsXnqOYwPhmfoz6n2wkXQ7NkOizXEN9jmMVUKEnK6oQO7JFUlIwOj/IWSPQfXC7jqIfa8vOPSTA9Sk7xbqqjskXGJevQhSfiy1uLASvPUQk2pJvu3ueMwoo9ZtuvG8LJFDdSkTDg4UHmyw7ai6Ir2m65B/AVfAbVAojL6IyGhS8OZ+gSgQp3UbMAxbiANwbobYLfqvmkJbjoXO6c4nxWFkPpC9/EWWOhU3fByFY2A1/E9Oz5jNPNl9Yb5zyTUdNoG9BdJqqqo7V1Rc8xa9TzuBwj9h5QVL76k7IyTLbefL/RLYfnMpYJI5fLBB3iTGD+Hpop8LPyBwCpMtQLvteLJJTR2e108J0Y2ataid5DdUU1VFvijNB8RA5XV03XMI6eAa637nhkZl6iE+i8zb3dnJhI5zgr8MU8eXZBKJAMl8aerOy1RiEocwnXPZrUAAzVD8qKdEtdhor+pZa7EsKqXDdqYH//TtVVPKKKhNAi4K7Ve5PyoEgaegOTp1grNkN0fHFPp3sO/jC1JL16CO4hKK63U537oB3oAmQr1NEa7mgRjisQ6YeZIKJ42CzUs3vrz+jVtpnweArcQ2MgURPFjpVmMMk2FJfCOREj3O8mBM+kUObWjCusLwC6gZkIHkDLKuYfxLnXBmhyTkvM/ocv0E7ZjQuFa/7UDTeBe0FOTJ1XfOi90F77lRe6IkBLgn0pL68PpzNk2muxiTHHONxncK3cNgE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(52116014)(23010399003)(38350700014)(10067099003)(11063799006)(56012099006)(261021121427099003)(261102123227099003)(261026140227099003)(261022075727099003)(261022105027099003)(261028144727099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X05ZTiSkyDqOfdvBN6JWJbwInRKM4iDvLHOcscgoDgQQdYovnComDxR6gaWE?=
 =?us-ascii?Q?ILTKJgaBnahZbh5We76XB4hlUJwj26jTcBpgnr0pZ+JbrzAWnUfmEiZVIPT1?=
 =?us-ascii?Q?BCy4CWAorFjRCtkGyOfjo8LWKcGLX0UqzMRxTTfM8pC/FlomeHBATD08+HNo?=
 =?us-ascii?Q?pr0YxFFemfsD67bmC/nfcjZ2SDc57T5Z75b0xPYZog32H2M0cW2xE82A7xB3?=
 =?us-ascii?Q?qMYmxbC2/wPdC6hVce5e9mJrKq0dusrAV+Bek7DnSqI8oto+AUxUGtjJ/Kaq?=
 =?us-ascii?Q?zbzG4yb1/YrEKCbKfIX6/t/yKmHroJVJ41SIPn4hf013srN32Xuu8fsP1/g6?=
 =?us-ascii?Q?/z5+M3neROLWSQf9Ap+ThrvQRxro13ZU0NtZ525duSdVhcTWDzc9isGpWM09?=
 =?us-ascii?Q?PlrdLqRLk5zBO2+6sHTMgihm/FCz44RAo1USsrIRg8uR5SRcmwfHwjMl4OAw?=
 =?us-ascii?Q?4NAdbQywKP+Os1p/lU15ghcHWw+cCmIvnRHeWy2GE5RlB0u0N7+XsdWDY8ka?=
 =?us-ascii?Q?Ai9ofCSR4BrKKPPiHdHt1V1LcZgfqVsOtGCLB66JFPgu0ifpxUJwIDOfGjmy?=
 =?us-ascii?Q?Uw9HojNj1Vh4AXTkfeN65xdvHKvoKxvMTr0s5PoyXpBfdhUxJGio3JOm86M+?=
 =?us-ascii?Q?zz1NFmLL4oCZtqVTlfHVVT7NeICwzSi5uruSAiu9WYmmJ4w8iDKPPfoXQPNB?=
 =?us-ascii?Q?AlBLnltiok0xD96uvSM4VInqPUgm8pfQu0lQXDEljcpJy69cWpqEkxCuT0My?=
 =?us-ascii?Q?PN7t/5IKeo1V5aaKtuIkSl8WhTcrZkmrJDmR5vfbk59EGpx07uInsocUyEai?=
 =?us-ascii?Q?e6qk6WId1LAf37+YYHQVOSt8SLzLaM8P+V/72lXODGmLmhE9spz83IOXLdzN?=
 =?us-ascii?Q?So1oOxBWDaIsLxyblDsKJD1Qz5F/W4cH6EbBrgsoLksF6XOuTbHoLbltVZHg?=
 =?us-ascii?Q?0pZ2qGn3gr6QmlJsBhsYKNn6dc5ms+PM5S+XnnF2xEhHIhezqetncmrEeTOc?=
 =?us-ascii?Q?WZEUWV1wQC5SyK4sS28GBS8qAKpWl+dXYzUXsypelAP1/bvF3+Z8neRT+N52?=
 =?us-ascii?Q?AF1XLpUTlyoXbjj1eyOLAibQlIj67VL/tOJgvjhBM/IGaWTjLKKzUCstbD5r?=
 =?us-ascii?Q?5qGiM8NhmikSqlSvfnH/ZExQjOF1KKsYqGY0YE3dgn1YwLjDgjxstukB5o4i?=
 =?us-ascii?Q?14ixbKA9Xr2xapouBVuLY0qGtgLeBEDyrYNvovQAYmar7lNRV7ChJ3CDY+tk?=
 =?us-ascii?Q?wN+MmoFG4AFJcJ8ti3tNtJbr8YNRM01mpJJ8LbdN/RSpNvYqmxEYrDyRdEmc?=
 =?us-ascii?Q?VlJh5IDFpspORFw56wRUCeKVUOPMX8LaMR/V1VGSO7HGss732YJbI7TlWK7s?=
 =?us-ascii?Q?F1dWlCnfUOpXtNaCk2THCbuKc8REYq67rSHdtywEmuYsBo+/yij94mTQjvMz?=
 =?us-ascii?Q?R+LkLVHJoBKs6qD/Euqcyfk5b4fcgXfC7ZS7U9NItHo6oWoqfMQJ8C5E1KWg?=
 =?us-ascii?Q?fookWnGiM+0wjOI4mP5BhJA8W8RFQbHNhPC/bkWgZJpWSLJWOyP90A3Vj11A?=
 =?us-ascii?Q?yxtnsnj47RLOS7B3CaPz+3JoTK/lpCYWZGslhkOZOQmXR3JulMn0yV+qWyRA?=
 =?us-ascii?Q?agaTVwk6BRBqxEVIXauAFbFMYANeT7UhWmrypfCvcEd98PohQkou+7qBj4Jf?=
 =?us-ascii?Q?9rXrcdfXVj/3882KsfYGw5L/iQc1hC0d2G9qtq79A2QzTbPoG8A2AoL0YlZr?=
 =?us-ascii?Q?WXLVr8zNhXZ6aXKPbAYIogz5xAi/6YY=3D?=
X-Exchange-RoutingPolicyChecked:
	eroycWP/X43IENP94kZ8DZCkxwoey2wlr7Z/9xWKUBS24gQsV8jdCA35ZAMfRypkbMObeelSTBsTFApPK6CNL2SmMpvt3Ar0LtS2MWXVPKmD3zJLYAAPCyKNi0e3kBs2JWZSZ9Tjfsa1C5zfM+nSHDEV9NB7ms5CmUZbJeR0FM7dOBA1Vk8RmlUaAdSzyV3pFHOW6mocum1i1Okfnf5KoV6gHKK7xwRpnsHECrFKfPTVbrblDT56++buJ8Vk2ipB7kVZ7u50fkMhfbYTe2DxhN3PlRhgmUf/nl+2qonK9pgZOA47sLts0fIwP1R7cVMoaSgWsZpbtbMJ9LTAOrv7IA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43e2ed9-4da5-4993-7c20-08df4c84c525
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 12:48:43.9230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvdd7RPzSIhuyQNLy9l309PF42UxPSwoFkOiR5cW1pa/yyuTcv75NApNAb6M0rcnz8ktHd28I4MFPXvJW7aJWn03P4HXAqhCrTwzOvv6oSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4642
X-Proofpoint-ORIG-GUID: cEjXajEMjIPfAiI1n_2pgOxMan2oPiKV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA1MCBTYWx0ZWRfX6dsfyOFgvFkP
 TJRaS1MrOs63N3RVBZficCneyW2TApeivjY+ADFFwIdKs3yIJ61NLjFBA/aPRpcSe4ia15T1JNp
 ruYXp2W5s3u2qXA2LxjniXxW6w1nIW4vuubWBsKLMifsQDiOZPLh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA1MCBTYWx0ZWRfXzKWcYSyFzAWC
 BmP0WluyIxj7+vvimeix9s/I6f3qWeSbhsNbCI6sHfmZNsPr239fPoaXBHlTrAXD3EJK/d2TVC2
 A6xyzp1+E/jOOLMMe+tSahcoviA8B06QDnBxyzGOx1K/5g6KTooIqvXyEIELBW08hAbvOwTjQpq
 UBhrztXjA1HAQPFvpJvLLZucwDbkWvxFa+MRBXhPiieSBrroqXP3ZmRwlb1mx2A79UosEw4P4tr
 ccwjeXW+9g+maFGJAT/I3uucUNZuaQBzzatfM+8GkJ4lorj29AAoZhutE6riEggc2mjA3t1CuHH
 egukvlvg/QStJUXUAmxkU9M9WNXRGJUp3K0KLC+IwknQab6fYGWi+1oYkQXnt211qpABG89mbQs
 8jkkbfiHqpcv8y/RA7z78K3ROYI3MXpyfWtunBcJw4RirZloqxbZ9qxp8hbJKfDiBxdf9iO9MH4
 FVBG/a2JbND1gdRkXog==
X-Authority-Analysis: v=2.4 cv=bofZl0ai c=1 sm=1 tr=0 ts=6b097c2f cx=c_pps
 a=Od3vHKP1JmY3AU3jrO4qiQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8
 a=CY6fKGm0NjnL2UNsXdoA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: cEjXajEMjIPfAiI1n_2pgOxMan2oPiKV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270050

On Thu, Nov 26, 2026 at 03:23:31PM -0500, Aaron Tomlin wrote:
> It is worth noting why configuration (B) gave isolated CPU 2 its own
> disjoint hardware context (ctx61) in the first place. With 120 queues
> distributed across 128 CPUs under the legacy post-allocation
> "isolcpus=managed_irq" behaviour, group_cpus_evenly() assigned hctx61's
> managed interrupt affinity mask solely to isolated CPUs.

Hi Aaron,

Thanks a lot for the detailed answer and for your help throughout this
series.

Good point on (B). I had treated it as the healthy baseline, but as you
say it only avoided etcd because hctx61's completion interrupt stayed
on the isolated CPU, which is the isolation failure the series fixes.
So the comparison really shows the cost of correct isolation on a
shared slow disk, not something the series should avoid.

An update from our side: the v16 managed_irq_strict backport is now in
our extended test cycle, on the PREEMPT_RT platform builds. For the
control-plane I/O case we are handling it on the host side, as you
suggest, starting with the I/O scheduler on the controller root disk.

> Also, following discussions at the Linux Plumbers Conference, the
> consensus is to drop the separate "managed_irq_strict" flag and instead
> upgrade "isolcpus=managed_irq" directly in place to enforce strict
> pre-allocation queue and interrupt confinement.

That works for us. My preference for a separate flag was only about
not changing behaviour silently for existing users. With the Plumbers
discussion and the OpenShift side on board, fixing managed_irq in place
is the simpler result. We will move our command line back to plain
managed_irq when we pick up v17.

> I will also fold in your pre/post reserved vector patch under
> HK_TYPE_MANAGED_IRQ in the next iteration.

Thanks. A question on attribution for that part: would you add a
Co-developed-by for me on patch 8, or keep it as a separate patch? I'm
fine either way. For Co-developed-by, you can use:

Co-developed-by: Ionut Nechita <ionut.nechita@windriver.com>
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>

Once v17 is out I'll test it on 6.18-rt and 7.3-rt (PREEMPT_RT), on
the same machines as for v16 (the Granite Rapids NVMe box and the dual
Ice Lake MegaRAID box). I'll rerun the queue mapping, effective
affinity, hotplug guard and completion locality checks. I'll also
cover the negative control I still owe you: the same isolcpus= with and
without managed_irq, on the same kernel, to show the difference. I'll
report back with a Tested-by.

Thanks,
Ionut
