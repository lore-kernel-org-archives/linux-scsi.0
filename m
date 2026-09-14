Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFB32FF675;
	Mon, 14 Sep 2026 23:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789427002; cv=fail; b=BTx9cMdGkL+qIBaO4U9Yq/ZDdok+K74DAbv1G7C1QT667ZalBhmCMmamgKkeySU4fBV6XBllqIcgLPJjElkFucXKM5ixQZIqu9+TAJtVRPyDhzAeJWAVnKyJX7ccwCGRmurNjowtLUliq4amCtFE7pCVksTKad22/g6IgvICsdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789427002; c=relaxed/simple;
	bh=zhK4D1K0gx8970Mb6RAU56yDrIhEl4tMBYaEuc3mnP8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HWgfG+bmUvyb0fxqMPPKzyRo1pT8rzYJrd7k1APzuDWqHzropTm4ihS7ZFDOd9IuShh3VoMrFx+BS6MQQvWJe57H4xUjPjVZViKMrhioXZQ0njD9mRaC7zscvLh173C/N+fV0ENK5gtvQp15580tnz3V0tm6s1jHJedm7ZKHupU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jiy+p6Hi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sGz3v2ae; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jiy+p6Hi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sGz3v2ae"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EKNASn2337394;
	Mon, 14 Sep 2026 23:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EW4MhHKOpTZNQj2te245amKer2siAXqJhFLMlffY+io=; b=
	jiy+p6HiSBXcIRrVVFDQs1hEWPu2cH49XGqp0cSSrnr9KWzSbPccprby0V+xwTmU
	yNHrc21BL2h44sUXZ32s+FbP5pKEgA+gxw4IP8o1XLGioeSb6zIZlEX+PhA5IL3W
	BLAP9FugfocNwqwKz/Y6uL0Q3ZEBzZECv2fChdJ40QVsrAiYFtbMZx8XeVbj4kIr
	dvPK8HMDmFDLFcpNJKvDeNChm7UGn0HrnXQdYd2TvTCI0AjSBCTSTWchSeEAWsrS
	vWkFdid6bwt3vWz9bXQSiVBiwtcuhJF3Q/pLeI6qA/KNjK3kg9iVF7/Od4kLEIi/
	30w6gN1HLieRxSabcQ8DVQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7aqd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Sep 2026 23:03:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68EN0N6b024471;
	Mon, 14 Sep 2026 23:03:06 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6bbwqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 14 Sep 2026 23:03:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pmZlsMxmw1yMgvB30wOy8+L86AYK2v51vb1tcNDcBorIcwNd3jAu65H6IZXP29S1C5p6RSYgIhKplTYLwrrtE8appxuyn9UqLGCA4Bap4Rqjfs4dexq26FVtAXia8P9WuN1hAWEOkp8xPiPF7t1sjF4eY52Dv34kNgACnJo8wgzhSg5ESmEfCZbu7iag+IbDPnUhxbtoBDDl0F9AQ7uxBoO4pnL+C2SV/e4lZaZAXBBGpvt/OfFPZOBp5yazCtm/7JSGs4X0b8KGbyyIIEfsFfb8KMN8+APq/FfQOVvToPIWPW8adIRMv6TqEzM8grnuR83vziam9mtcU/lggx/HEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EW4MhHKOpTZNQj2te245amKer2siAXqJhFLMlffY+io=;
 b=G5+VQZjZhBlUiFTI1XVMl2r5VSzruUIipINXB1fB1Qk4+JvLJvKuKkcPa8gbrVOpJIKqHVjn/vnx0jRbTGUqohowBTEmQK4qABNGoosXgROOLUWqYRYOidT5tURz4YZTgbvofDIpPQIgPjYLuvcRjJyi/gNW+TzntZBzDLMozGMnrd3IblzzNjHGahIPvauvR3Vv/fgFvD3kNbEuVF5YaGzZsgd+Pe05K6BRER6xXQovIyCKUTw2BYU5VbAOUcMgLaxl91t7Lg4JfCfp0luXi5kCQtVqbhd18Qk8mRJKEMPunTRImi6f0R00LbrAKygoIp0x0VP8R+lpg2x/u/1sjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW4MhHKOpTZNQj2te245amKer2siAXqJhFLMlffY+io=;
 b=sGz3v2aeGqtjhD4rgsRxWcLWXnH5mfOHPFZRQqVAaoPauzbhJuuIVIefzPAG4T/j/M2lHQxMpW4WtnIJstGTzmMM2jtnKMNnsvB7Evx5hGzkKKqgHL4D3F+s2KXncdamMBk9qMDoIBOc5ujWvMJpHWsMDIS4QRMgiOi2LtgE8xE=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by SN4PR10MB997923.namprd10.prod.outlook.com
 (2603:10b6:806:4fe::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Mon, 14 Sep
 2026 23:03:03 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f%6]) with mapi id 15.21.0428.004; Mon, 14 Sep 2026
 23:03:03 +0000
Message-ID: <48596aaf-28bc-4912-8b86-339848a8c976@oracle.com>
Date: Mon, 14 Sep 2026 18:03:02 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libiscsi_tcp: check the data direction of a Data-In
 PDU
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, lduncan@suse.com,
        cleech@redhat.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260801133635.1986706-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260801133635.1986706-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:5:333::30) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|SN4PR10MB997923:EE_
X-MS-Office365-Filtering-Correlation-Id: 86df64f9-9654-41b4-7652-08df12b45484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	whBBJ+AOvGoQP1FRTwtMm70/jwASsFpRkYB7/TuCn+FLds7twd0JI4tvrYS/CycyCm+rCc2MQgayk1URgwymKK7/YYwHn/03AF0XHor18HDaAuCdQC2VV7fvHO1u0Yp06iiVetXPs82emeelBTr/pha/1+n/JoxJ9k+EM7Sx8TnFKlRw2765Q55n+urxMSa4YBOXikRgCfPj4A3MrmcbMvSS/2dZGS/4qwA6JqUv8Fgfwjou2knKqTIzL5afUTRq/OYhRHUyVlhTGJTKadrigsBVAAGMjAPRzNRCxT9B+Wdd9FxolfaVrnOWhEXKAd0d4tRfe+bDs4SOLZFZ3JWtt3GVRTE/ak+Nj/e6O5f6uVAvfQm890pyMqhbJU72xq+uywqj4ra0CC/Pa0/N5kn9NoO6ED9WcUrUYtkUMxHSV+w3sHs/UNj5KznIbM6QGD43InLQ2lrkDYsIO5FyEbuWt+wtAThHm2mzsb93SDvb+a3x/a2nr7yej3vh10szFIF3tAAnsX/5UwoOP12AaiXNJ5CNsT5vcTrBzvPmf6zM0/xOHOl6mxs8Fv7FfyY0hOmAv8Emul7PBtt4EBx1CzfnzS8LtKnJ0jfYUD8Vhs3L3ZXzrppahlqRGlUGsjicKfcsr1uXVnA67Erxu+M1Itr9mG0PKMQXejHbafdM7+H3C70=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkFUZUxTNjlpdWJoWUpySEM3NUt5N0tlUTJyWTVIdk9mRHd0MjF1Z2VIM2or?=
 =?utf-8?B?S0RabnFscnR0Y1Z2MUVzeWJKaG9tVjI1VkUvNktZR21WUXpSVnNaRVV5QjA0?=
 =?utf-8?B?bS82NnNmOG8zTWhNdE1GMVBrWnNSNHhhRUJNYnl3SVFBN2NuVXdxajFjVGxK?=
 =?utf-8?B?THZxM2tmTlp2bGI5cm1LQjQwc2J5NDJJdk9ZaDYxKzU3d28zNytzVnhPVHFM?=
 =?utf-8?B?c2ZOMW4rWHJvZTF4NWJXZXk2L09tSE9xMElNdDI0Sk05OUlsVVBseEJFNCtY?=
 =?utf-8?B?ci9qV0RBZ2RBbGNkQkFTTlF5NWNvaFp6dDdxKzE2MmFLa0JmanNlVDR0LzZw?=
 =?utf-8?B?OXBTbmR3enhidmE5aHh4SXpPQ2lDMTE1b0p3dXQzU0lEYzVwdXVvb1NKLzYz?=
 =?utf-8?B?aVpQT2lxVXlieUJ5V2g4aVVrVkxZaDZremdTTW80UWRXamphQWNwaTJwZEVo?=
 =?utf-8?B?ZlVPMzBocjRqQWFvQm96cG9ZK3kycFByWlhPWUxxL1NsTURyekM1WFI4M1Zh?=
 =?utf-8?B?N2NLWGUzR01idHp2a2w4L3JzWWVka043b3BCUTZDazVmYXFpOVg3d082aWs5?=
 =?utf-8?B?MmRtdzk5OXhsZ2pRQzlBam5GU080cWpiT2lSVWlqRXhmdkM3SExJUm5tTlFE?=
 =?utf-8?B?RnFHVEVDeGRoRkVONFlIVXduMmR6T0QwdnMxTTRmc3V0UGR5UzBtUWdESXJj?=
 =?utf-8?B?Wk5DVFhXd3hOdWpYdlhuUEdkRm41cTBXclJab3QySE1yRTZBK1BHRDJES2RZ?=
 =?utf-8?B?enJuZU9ncjBkWG0xdFd2eEJlcWFaYzlleGJ4Um00cWNJaG1WSTNTYlpJSWdI?=
 =?utf-8?B?akorWkJyR3E4ekZpaHFIeUsyQ3d3dDZwTGtlK0kzclZhMnNLTUlldHB5N1Uw?=
 =?utf-8?B?RE5lWnBBeWVtWnhyb0EzZEErOXJBajl1TEhhN2lsUnJPaStJeDArNUZWTFR1?=
 =?utf-8?B?RVMxdEl2SWJWbjBHY0JreUpIN2pjSU1tYXhqanhsTENkaFZ3YmNucDREdzF3?=
 =?utf-8?B?VWZBV1Uzc1VPSnFIOU80ekVKa3RGc3k1OE9iR3BRWk9QL2RTWHVNTXZIWFBX?=
 =?utf-8?B?M1V2VTBiMG1HMGRxSmRWZXc5Ry9KM0puUWxEKzNpTDgraEFFbWdYYXhZS1lN?=
 =?utf-8?B?Qm1tNEVydnVwNnpZOXVuQjBCeTNodXBYdGxMRVFCWWM2Znd6WnhBNGxpYjFI?=
 =?utf-8?B?ek1wUTZIQlE4VEFSa3V2MThaNDRqaDFwUWNzYkZOSmlHSVQvOENYNThJTDlk?=
 =?utf-8?B?RmYrS0g1ZjEzTXRLK0VNS3lEcnlWQkZyQW5saHFLQnp3VmxEU3VVYjh6akpo?=
 =?utf-8?B?cWU2a1J2R1FUVy9RSXV5bjhjM3MrOWs1bkUwVFRaWnphZm9qZDlLa1FtMFdO?=
 =?utf-8?B?bWpJUURsT2dWMWhnRTNMalRtKzZIa3JaQVFOU0VqdlBONk0wN2hTRzdtSzlU?=
 =?utf-8?B?Q3o5Y2RjTjgrd3RXRm5WcGkxcG9rYzE5M2ZKNXhzWW0rdnJ2ZnU2V0hSN1p0?=
 =?utf-8?B?NEhiK0l4eldkQmVFL2h3Mk52RHg0SnlidjJ3VDdvR0I5elVOUTAwVWdUa3ox?=
 =?utf-8?B?T1pqd2dPSzY4cmIyUVM3cWIrd0NFL05JL2ZUSzNoTnpyV2VkTGlzRG9pRlFV?=
 =?utf-8?B?b1NUV0pWQ1F4RVhrekk2dE14d2MrYmtJaEdWYXVXMTgzeXZFWVN0Q2JlenRn?=
 =?utf-8?B?QTVtc1MyYVFmU3FLU0dsdmtKL2ZRV2JoM0l3Wmp6ekNUNlo4Rk41TW1GYklh?=
 =?utf-8?B?UEhrNHcxYlRyYVJOTTZqVHBEdm42dEcybzQ0WjFwdVdxSVV1OE5kWFVlQjlv?=
 =?utf-8?B?VnpWemZUdnR2eHhkSUQvRnhRZlB5a0JyYnFieTMrdXNsUXR4N1ZOaTN1bzdP?=
 =?utf-8?B?YW00eTl5d01CWThXV2tPOHllQi9CZjk0TnlEODQ2aWNhVXBmTFhqQnZUM29E?=
 =?utf-8?B?Z3VxSUdzUEFKRmw0OHkxNTlXNVhzMk1hRTdFdXpnMHVJa0pBekNSRTZsa292?=
 =?utf-8?B?eEMzby8yZ1N4VnZpRjNhQ0d1OW9RcW9oemxwZzdkeDdjZTRFQVUzK2ttSWtY?=
 =?utf-8?B?dEQvR0hQOUhVckxKOFV5d1BBSVh5K3pBcTc0V25kakFZOUJCMERzMGtvN3Ny?=
 =?utf-8?B?U3U3U21XTVpsd3h6Y3VqOHFjeVhJdzFYeFA2ZWVhMVNmSEZIUytUZDBmUnl6?=
 =?utf-8?B?aGIrczV2YzJuR0xRUTRMb2VHTks1RGVMaWJ6cVpncU1ZcWpyNVRaZ28xbVJM?=
 =?utf-8?B?L05NTUFCZC9wcWFUdHpRRCtuZkVqSW5QNERzZDVaalN1Nk03TkJUTmtiMU90?=
 =?utf-8?B?akJubUVPSW1nb0syNDZnUjFNUDkyQ3JCUEp0ZXo2WUdGU29LdUp4YnhGZEJs?=
 =?utf-8?Q?obe0ytEEcwqCr0JQ=3D?=
X-Exchange-RoutingPolicyChecked:
	nC5iUNeCK8uwO3IStxzyWYqaa6UtAZtMf7jvOrO+mRyhZ3nwAYHPV9ee57Mdf/F5RnMyXqVF3vpu8vW0+wIc1FVsbdNepOEov3yWMM0TrJVy6HdEv+aa5nmlI8ZCDuogmY+rfmIIHq36OZSSBJMvA1sx5PpkODIEoH4bxWMxfc4xqZaNurTTPlu+Ug/szoMBsNFJ6PKhQ0dXEoueIvf+5OkvftBrGORpG/KcgB3JfavR3c67BMfWYK4gco4tIo+E4cOA6NgkAMNxONrzd6lUNx0/EQRMlfAwgA5uF50evo0Z4zTbbWu7+DtD2hfQZ6SABiNacpk1XEmpOcJ3Zx46sQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qnSaajhnIMDx7cOYgCUDaA8vrsdOHd7Oqg4sfwenPnFXhfKgxnzdmQxoosaW3rnlFAhsIQsQ4NzQvb5vapaqjML4pdSSuXIPhk5PsYzlH1U2S4BnXxSVCZSXhwaBPpr/OQpH9R2C4ntJWtYR55GFYWdW17+si59q1eE2v10IgZI7BM5RZbl4/pjebymhYE9+pAhAObPq0IXQOZtIExq84l7FOjcK13yG6xfZ0IJuF9ayST/Bio1ItNQw7ymZn5XiSDX7hJzkaRFfhozIjwRVPTTpwylj+HSfrG70qFnq86cPyaYN4g8WySgrr1GrRBiv2tgysW1uvOEDCAg2Kq984g7z+3go4C/9wSEzpu57BblgPWokBdufmQWYVuydjuPif30VpSvvD5kvmnZsDtQ920rqRZgjrjS3Jn5nF4b+vCqvtJmjwFOYqKYVnzdDsW5LR/lxHh3vxZ2iCElPqMU3V4s5VL7xq3ZwhyRUnrtjeRoqrISNZsUbQ6pW4nR2ns4rutGsbNLYNYbsNFObHcjhw5gJtB7WRS5FgLyKlwddY6dO6XDz86Ws6lis7XDksetUbnpzIM7SfoNc2g8nCUZfZyh8FL/8EPeNZr2iBVZ06pY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86df64f9-9654-41b4-7652-08df12b45484
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 23:03:03.3388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sC6tpdikGZMBVYkbFbsc3QexoINOXUY/mVJvyHFdyHbVmifx7Z8BmWiQFxh2Xtsuu6LC7n7+A/Vu1FLsJcSSKPF5lVRfFbUkGqS1DJF+g6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB997923
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_05,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609140329
X-Proofpoint-GUID: KGVsufH-8ikLdUNeL_A2dOqyr6DKdZOy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDMzMCBTYWx0ZWRfX+z9Nxqt9zMje
 dhzaWPez2zqjM/DGiWlU7hTHzRjPtIxO98ms7LqFqOMOOHBl0S4nuC0Z1U2ah6NG45FEgmY7Xtx
 7lYJMAuf62ONBQiN4bvexDq7WD/dF5QKHWJN33Z1q4J3ydw1jZXWVOs4tD264j+eO4LoBDdg8N9
 GzVCN/M5MWO8bx5GynZ61j1kw0mW0x1s5QjN86UQm0hgurdLPzOuuJ9bmAV8s1oLgif8yem8mqO
 VUdY2xPzEt2Y0q8KttMT/CfoILhDr2t4RVUozCBKkWrJF+vWHe0awk6cRFdoeWaxEPYuQC5wwvG
 nfPxdPzy9q/FZwi3dJdNr8KmKD6ZNf5IA93Z9y7GzIkDuV48HcnzePcS+IdIejkfrxgL3hRs66y
 lboj1HXNHNk7q5Cs5UAn4ucbWhgWK26v7oruuu/tzWCeIrx4MLPivIVdTTBVWarlYqaGIVGMu9N
 Dtg6T6Wik+DMFonp2uw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDMzMCBTYWx0ZWRfX0QYqbWGSUEYb
 rIM0+oHmf1BrYIYPpyhvedKrSOoBmyeVjHj1agxjBAno0bfLChgbaE6Bc1ogsMlB/L8e++kgL2G
 9xPdHgkahdyIYgmLXLaGvEYE4jKzMFakeZD8I1UBPnLe7vr0WSQj
X-Proofpoint-ORIG-GUID: KGVsufH-8ikLdUNeL_A2dOqyr6DKdZOy
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aa87d2a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=5H6fjn85A0vQyQvfvGoA:9 a=QEXdDO2ut3YA:10

On 8/1/26 8:36 AM, Yehyeong Lee wrote:
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index e90805ba868f..0283c4444cd0 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -480,6 +480,9 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
>  	int datasn = be32_to_cpu(rhdr->datasn);
>  	unsigned total_in_length = task->sc->sdb.length;
>  
> +	if (task->sc->sc_data_direction != DMA_FROM_DEVICE)
> +		return ISCSI_ERR_PROTO;
> +
Sorry for the late response. Looks ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
