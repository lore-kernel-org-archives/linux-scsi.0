Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B60A38F91;
	Thu,  2 Jan 2025 21:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735852196; cv=fail; b=WBax8VB+cB+choP8TgOKOwingGRKVYaDuy3Ep+uT0z9PcUh8SFJpHPQ6nnGJ91irbOkeUAmsEWosAd6EOZUVqbUM2w1aFEBXWp13+rrQCx9wo8U9BjYSeQXVa5Ar/C1S2gEJriArf4va+ab+b73UY7ac95pvfGhKhqDLBV+vvys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735852196; c=relaxed/simple;
	bh=lJeBYWbKn0U/FNbcIFfKadUfbiVXtpm2f2Y5MvAoD8k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Xuj/w6Yw/TRl5woEum4Eb6+LHJIiy2xKwPKSA7LZwLNLGaU8sgSWHuVZIjLkh5pRgd2MU8Dd/vpJ7PCdMnY+GVKDBs74DHAztgsKU2rru+wL2nX8b/FgiHMSmwG4YPjOU7jyYkp5v/8A86tIoDuYJ2QUPgZviJv8Sy+PX/2JG3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mMwh+5kO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sJb6wHEP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mMwh+5kO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sJb6wHEP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502KfuIP015268;
	Thu, 2 Jan 2025 21:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=/V1o0TEQt3QrHs+Uyl
	lVEqHX5QI+chGoCbf8DIYBqps=; b=mMwh+5kOZZMeF7XfPkK/lRgjolxJ+0QdRQ
	kRiwFRA6ZRkdYC0FcTu/1fYFlMN8+qxbnmwugCCUt9UWLHYh4lW2kf8wh79qnJYF
	hTWtzXJp58rStytcp61pOp25+PRPM9wZoWqTlJ3CaW0KB5tosdR6yfbpBOn2Ovbp
	sIgA3s96X0DBQzCrTnmHlHEgKB7xs27oGDnMy5CIq2A0i+FxOnoNvNYC2g2QQmZB
	iGumCC4vq05XcfusR35ldy+wa2Ihwjm7oDyNRm4IOXK/uiTsKyT/vI+RUoHnZf72
	qo4mgJQ59SLds3NujGGe3lDaAM4NqFFr13uUbNlKLsf2v+dyRg0Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t88a79gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:09:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502JDTK9012556;
	Thu, 2 Jan 2025 21:09:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s93d0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:09:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mwAElmOucFvai9sxu/+KQ0X+jesUyfBTJbOU8oLSgfRZ7hO+FsJDAnRZIRcF7so7tu5GMuDHuB1sPVvEkBpfm4qk3LISEnU42n4Kx5NZBfYMft+yk2xnpfHyr3q7Sh8da35Tghih1e3f75/bUgfff11HJaxAcvLWG/5y2zZ4GbiK9ksd2rvf+I3hWMixXayWikp/ZLJP4Z8dI0JYCvmB8QJZ+jEn3UzVYjxampc54qzgnePmjHAjFAI1L3cxiw+/QebMNtS5TfGe9n9BYWsJsw4dbhGPC4/xE8e6RjWMZrRGkshzjUSkn1LUR6tB9dKG1+8lxQiSDMc7tC93RFUeKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/V1o0TEQt3QrHs+UyllVEqHX5QI+chGoCbf8DIYBqps=;
 b=hpGWUGzmMMgvTx4XZaPS1k68SjQrUKlglsDE1zLMRIg94wZa5MLQK5yjGRfMPIMCsX3hdFWvnUXZDV91k+/+kr6vEABMGSnQOn2v7OQZM0k8EOmBDf1pTTJB9OUK0FvtRrPHNiI30+ro0HD6vwKxUgjqYX40yCqk6BsnpCpMTwCp0BJLv+tE73GQtWPq67nMugeTaznXIt3hSWu6N3K2i0Ou+dDoWrBoBnjWW34qhWu6GcoKOtCwhebxEfR6bIViSdwufTnDLXbmWM9W7BAqSU9haJCp4rNAZqlZw+TqxZlKfWxH6XDZOznYAAX8nRI/PwstNIHpTaMuClCkLQSeNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/V1o0TEQt3QrHs+UyllVEqHX5QI+chGoCbf8DIYBqps=;
 b=sJb6wHEPQ/7pu7ASlHjDykbmjGSGu/cFmN/GE9Ptvy7hqaJ5vFOhAnVX4cetpI3HdyyCy8IQmFGfyhrh1MsOU6foJJdkFmaYBPigciKENUcpxBeFhnnW0MSNERJdgMgShR4y07knlRjgHPLm257p9wKYgfjPB0aSRnkWPojmfHk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8059.namprd10.prod.outlook.com (2603:10b6:408:290::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 21:09:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 21:09:43 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
        aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/15] Introduce support for Fabric Discovery and...
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241212020312.4786-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Wed, 11 Dec 2024 18:02:57 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ed1kexdh.fsf@ca-mkp.ca.oracle.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
Date: Thu, 02 Jan 2025 16:09:40 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:a03:60::36) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8059:EE_
X-MS-Office365-Filtering-Correlation-Id: b46da6a6-57e2-427f-cae7-08dd2b71c78d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dqGi6MpLQc/q72EFa0nI7NYlAe1HBiO6hIWzU/7jXazTOIZOKUiZeTpLMq9J?=
 =?us-ascii?Q?bDmbWJJJY602K1UBg7cDjv+8FynYugENpxaooRNYB1cjZT0M1U3GcS8jbY1t?=
 =?us-ascii?Q?/ZbeYPm17SkoQlhPUQ6JvUdsJmx16aBytEYLAdFNOmof/BMczYhL9S8SQlVf?=
 =?us-ascii?Q?w5STwQCxIOQGnORE/yXrlbM74ok525JqtZMg3qdO0uNoKVxex0+OVBhe5VMN?=
 =?us-ascii?Q?Heo9IpdZtjvQNs/ybdyRWfJDTabS/mS4jO7tUzW3Umsts8vk5xhBY39TZ/eI?=
 =?us-ascii?Q?Jg1EAwkzkr/u60hTzRancBQc+1oS6iSD04iGHurUy2CPvtsvXgHF86qHxig3?=
 =?us-ascii?Q?fDJN6spkmdxl8IJumdiDHPFvANnhzqhxn4oW7sBYJu50N8z4Eh4p+rZn9dBZ?=
 =?us-ascii?Q?ToTxdoK6srTHEt7WXAKZkccHYkBsMTprM/+rwvNWEiKo/je7bZfFVmK5lDDR?=
 =?us-ascii?Q?rvCcFkt4reA/eBZU1KadvXcp5fk25dj40YP99kP+hKBmHsL1st9eCauweqO7?=
 =?us-ascii?Q?1QKXb65LKFt0G0Skox9YkQq/JkXYXAiVho/l+t2yePRKdHrs2+tt9zFgRarT?=
 =?us-ascii?Q?+OokyAcBO1gOY0Bvtf2yk3ZsyLN+B/LdGtyTrnawwEpJMkVmvOM1gXULBDoB?=
 =?us-ascii?Q?Pt2jYQErD3u0ApHJa7Fy2f6UVaypNlHVO4IdOkD0Qd1ifTd8pf9ZKgY4iIrp?=
 =?us-ascii?Q?SAni7XygDhgo1LHnLmhauRi8g5PiUKPtpOMJ5vdJdLwmqbEpG/vJOQ/vcL87?=
 =?us-ascii?Q?syawg6dfHA7xSkF8tR2grUuzFEmrhL7n9HQPVtetaC41DRBaHDq1SGCKmQDZ?=
 =?us-ascii?Q?A06H+zTpr/Ov6PmviiqONJzlpL+0RlGTDz6U3kgl5jvOlAymif9bOEsO70pD?=
 =?us-ascii?Q?/FVesksSMqo+b3wmiJBSP70M5epEsyfVY5H3Q81UqLcYJcRyH8qO5QoAN9Im?=
 =?us-ascii?Q?di6XcI9BByFS1a+0vDeC0ly5muXstb+0PTV0L+X0pqCj2oCcMT4F6DXzQVLx?=
 =?us-ascii?Q?A/dgn+5Nu2gF+pGTRp6NARPjiRofEUWQPtJROL6VRTIh1qxo+W4wigp7ysd9?=
 =?us-ascii?Q?KWRu/5UbYjqBwlZciS7l8kdXgIVig76I/VedzDAueF+SCprk28T7JwxI64qb?=
 =?us-ascii?Q?wFlE+7dntz/H3OwsnhxSudQ6oXGTcG7wOeUJ6EPy6GOqWpBatVas8hjHF8FV?=
 =?us-ascii?Q?4uaQs+NoUU4i/8D2Ycw7Yn4N3XPo9zwegOdeNnPkX6X71zyiGSijA7pROsbu?=
 =?us-ascii?Q?clfVm030xVA6tyOtTXOpj/KpvvXnBIgBNyf/woArfQ84KAmKuCALZBcEAWhc?=
 =?us-ascii?Q?B6KSIUT9mGHVWsg8bg5DOoH445SzRdaz3GiVgvQuqMr7fZhXfQl5PET3MfJy?=
 =?us-ascii?Q?4wbAY0o2eUBHdmLxmgRJ/AqNFqDK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QqFi3OhUVGFmQIf6tgrNtWIS/+Y7UwrR4vhXZV52ziZ3zQdETB/B4qxyA+F0?=
 =?us-ascii?Q?mwX6DHrLlIFoxrXppPeSfF8xR1Orkogbfh7VeKuvVOMhjoQ0r5pDo0nyeV3b?=
 =?us-ascii?Q?YXKQD958ZtBIuDdTiFX5ZU6ucov6IiyYiJAImIAJEMtZ99u6ngx7i1d4alO0?=
 =?us-ascii?Q?pXXtntIy2lseb4etf8JejqvCzP2y65en+u59m1F7Tx99kIuyFP2c4ClgcsuP?=
 =?us-ascii?Q?Mxec/0MKFSdYSuv9ZmN8xlGCR/y6/+asbdf6ybXD7xShC8cQzI+Lk1/Y0pch?=
 =?us-ascii?Q?+LJrqydQf12u17V69rnY8ikNSADbfxmUEfSd5+XDUwLJskPu1Ike7MGsdKzS?=
 =?us-ascii?Q?OnpPWSd+t0M2BmckAYQwvVR3beRQDmGHW/kYEATiMr8D6xzjO2QeE8piTQsY?=
 =?us-ascii?Q?rjvD7LyxmNgASUaIyETg5sTkcRPzUFmFlaDMFX+jHoVe5KQga9l48WaKZerd?=
 =?us-ascii?Q?44akZ//5gTH5GjIQWtjTGuTn3tIagG2rXEckCyGiVkT7a/la8w/iCticFWKm?=
 =?us-ascii?Q?Z8O6KSOAY9vwuOoBYWc7IkMVilUC31ylIkHljPmTj0vUJQHb4kWCxo9af/Br?=
 =?us-ascii?Q?2J1kgk8WfgEBCRJiKRbPMOdXyDwLBRY+n25WzRAj+iBZ/K877z2lcbHNhAy7?=
 =?us-ascii?Q?wQ5rsVNhIZzN6OKNBi7HuYL2UcXsLpKILeE67aVmZUyXTJw6zTWo1hYlOOda?=
 =?us-ascii?Q?rd7EaEYdw5V3p/EDoe773uGOHmW+0pOH6mWeqZUL2X7vQsafrHY7WXiG8Eh4?=
 =?us-ascii?Q?kJrX0HBAZMDRg7dMXgMurmKW3wwDZqNi761CMj2GhylePBn4qihwUC3M97YK?=
 =?us-ascii?Q?GkKaLtzx/P1LbZpJKNWxkLHqRUS3DOxWtOtl41z4EoTz4BjtifphClEgEYDs?=
 =?us-ascii?Q?Wv50gBMtSFhbeYVxHYLXsxiGX7YYqH5oRxk0E/9eJ77joe/4wUDvATzowdvu?=
 =?us-ascii?Q?51ptiMjUjKKOanH7UAFRVy8UVItBNwZ/a6blRq7ruk7Pj8O+/rwQMVMbpgCg?=
 =?us-ascii?Q?ODNKeezIHlpsQ0xlL2KnVPF0z6es0t48e7ODzPZrGWAjADZFcCifB5CciTta?=
 =?us-ascii?Q?v3agXfdXVxsTlmG7OPn0ojN3SchLPWn3KbinYNO2qRqL4J5jz5ze70aTsQJj?=
 =?us-ascii?Q?xYHZi4KIL050D1jzLbhmW8zVj/w0oLtiOBr/rGV5jseT/f2KG3luuQEXk6h2?=
 =?us-ascii?Q?2FYd5odgKiJzjpxUaun2xuIKRPFR0N+xFXQ9YyH74iimxaRd1Ld5QWJ2ffFU?=
 =?us-ascii?Q?gDFO8wQQIZf/ilrO/daKQ8URjhEzNLPAIZwZemCpdG1TAtoR1fO2QcbHWQ2B?=
 =?us-ascii?Q?8pDavgw0wxTba9PNtceSgYxAhlDkzuRoPmBARE5c1TfW9PLnUVRb0S/0ZWJ8?=
 =?us-ascii?Q?k9HhgfGQkVTlqr7N9dacKCtjEhqx8IPeTu9FNBJxSJE3ztxy9PnQ/ayZmEj/?=
 =?us-ascii?Q?WxMDT19T6S7HNFvAwIKyX7COuftQNI1BEl8z0LBvrY2l8xIiRp/t5uFz4imC?=
 =?us-ascii?Q?YbI0nWeOCOH18UVVOJ/68BRpci4fcOHKK6ZorTjkGXTWOTXuXkgk7S7XtlTT?=
 =?us-ascii?Q?2ImTvvHlCt226uYuBP53NmmxZZlMrES0SDx5eH53/bV3f608yIjjn8vTV6yQ?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8hJdlKlGF8YxqGFA2+PtwPOcXVPTCJMeaa2bJflKY4YF0BfJIGzlJmYAkc03c6k3yZYE1mvIraGF36MGayO9eWFOCIXDoLIwpZMVEazAzMihcac5x+r97irMQoPikEfRCVotiDjI4p8cEoMiJY+/4uiUC6+KTdwQPAr9QB9+5JTrs4UYUtadlHfm0fUgoPgIaJJE1RXlkiZytetPJOfCDR7YkUXdDwOI1bXHr3UQDydSqOG1SiFQsD2zS8U0vp6TOzaliaufw0zhe9PJBDt8LS8lTq2PwdxalQF5qcVYtH8WDr3Sk7/QJ7EpIsSHNu6wyAOOPpypaAP0Upq5BA4EUUF94Vz0K7payy0U2FT/pQ55h3boSg6cj3i8ASk6P2LsPQaHP0W+fZjyAzuOU5nP0ce2SioJE64ck+1ecN7Ay+D3IdAHtKyHiVYcr0WTBX6DZwfs8HVABIwCDyNUIsGVCIAPnSfcjupND1rgytnCQxpoUq9FwntVdWqH70qEsvwAR3P2R2dUS5DThe8T14eDA1WSIHzqMvPN6eozUmorEWHzAX7CrJWl/RCnFR16XEbanJeGc+lAc6770H42w9ecrXQAOmmH7MOebWUPWi7N0FU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46da6a6-57e2-427f-cae7-08dd2b71c78d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 21:09:43.7754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LVNuGJ5p585IbbJAGngq8C2aaDs/TgkEoCEPCBb13e2cWNZ4KvmgsNGNd3o20zOslyj0nKZXa6Vp5XN54ZpaZKG5czWqJF/Pja6vWhjtdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=942 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020184
X-Proofpoint-GUID: ICIDNvpsYFGf8yUjHGMUxp5G-cTLAL8r
X-Proofpoint-ORIG-GUID: ICIDNvpsYFGf8yUjHGMUxp5G-cTLAL8r


Karan,

> This cover letter describes the feature: add support for Fabric
> Discovery and Login Services (FDLS) to fnic driver.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
