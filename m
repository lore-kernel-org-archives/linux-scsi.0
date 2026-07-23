Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F81642BC22;
	Thu, 23 Jul 2026 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799443; cv=fail; b=uekQ86v+jP7N+5h6R6o5n6ipXXvobSK5U+E1YG8sCw7ca0xG8ow7aGaDhTNVsalKrWKHLBQd8R0BmXYxfwoviVvSVnxzy5oMeksu27GfYbYZYoCdc0nuXh+PMx3c4jAm7Y/N0pUO693j9Fo1JZxfRzoqmkyYLJNLwtqtGRJn2R8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799443; c=relaxed/simple;
	bh=QoePIJX2HnJDFyaQMGTdCnUw+op7hc7AqqeJLTlal3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YCvFwnVlODVVUTi0CY+vt2th0HQFwgFO+EXOOgnlckdSEMV+iXfEbSsr0AeVuWkooBDKyx0WVRYGtGurqnWsaOnB3QzlS1rYToKH8TwgoQsfoeIk7WC1IS39+0MSgmkl56kLzX1yBriEphC2lrIryVhHlUTNgMMJmczXRbE6Z1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z9cQaVlc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=viUNgEfu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z9cQaVlc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="viUNgEfu"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtjbd3378004;
	Thu, 23 Jul 2026 09:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j8qaYmuzAwStjbErCgcqVCFHWf+KqY+nSEAd0ZGmBr0=; b=
	Z9cQaVlcHm4R0Eto3gwyEYU9iNey4D4Addls3nEltkoePIT67DAWJjLA5CPyY7Xd
	DuDZ84CCd1/0lf82JcIEyb/SnaMRIgMWESvlkDsBXxtY7wHQTf8q5y/E+gewnWuV
	tdymdX3WAPGMv4/jY19kSWVtOr8E6N1DYPkNaR06Groir+RzOUzWIYZwrQtkDsiL
	sVx7goXw0DhL6ZtaavJL1LMxeytdW8V3q+qjATAzMBDb/qGoq8eC6a24oQEwUIWX
	ebd8tODKQtWMq//5JNinL/y7wLPlxsF2mRnxAPKkoPAduD9cutGYgBgbh1zSui5m
	Rj8h9Cqj2+sx8k6SGh+ZqA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6n9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:36:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XA6P021265;
	Thu, 23 Jul 2026 09:36:54 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y3vu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:36:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NVQmN9dndAQO9mLDSj4vRQUoRI81RrA6+ZhFUwGQBV9StE9XWPA4VSGPcqag0hGFL4DRd8rdUwz9elGn9c49syCrDNPbxcNXbWVs3HUbhyrBObdh4dHKp+zIsoKFj7wwPG9NrfayuubmXcnO6Z9yuANGdKhJGNaBdLRJ4ptew5cJKHbQZ9fSeBI2SzGi8QOFxZgvOp65vViFKKbHcHxnV9o/umW9KghUkmH/icLyMrkvvqvqXzHkvK/HAnTog0G89/RCeoubGhzrKW79V7RXa+4xC2E4+1yOvSXVGYTx7pubA0ZHQh/SIMZTP9tEHawKfXh+kUQoXjaLZnzXpnkupA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8qaYmuzAwStjbErCgcqVCFHWf+KqY+nSEAd0ZGmBr0=;
 b=VGXAfxldvD10m6vfry1vDHt0y8Ym7M/sOgpDXNBJXByRGhEDmpPxYSCChl4DNqDDhnxnob930AOT+PxQ9So/4noJXEFNnlcB1zQ3Hl/R1n71sCoaiIMyMXjQDveZJ80YAt9NKuG7JI7FTShBqKJ37TiGMrUm0G5B265nwK7+BM/bobJf5uEPdcWL3m1E2932GXyNJ6b3xeEV7c7Zql1plNEGuuARSyJkYKZ+Baay81eKK8S06luToyCfJ6jyNRZgry7Qz4iiqcuOKuzFc8Y2ISZYXC9YZCjcJwEe38yNcMNyyvMUFG18c/8ZRXO5s99sS63LSVCgmQwe+H/MybMlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8qaYmuzAwStjbErCgcqVCFHWf+KqY+nSEAd0ZGmBr0=;
 b=viUNgEfuo7VdKQcObiWYPOP5egmJZc6jiCP9b0LJDOQlYcHEt25REEnKBa2ffE0dcjcNUbapnakF+ajLWPb3GvIeQY5awnHSdUND4e6NVc3ObDJ2f60UtQJzqBYDj5mi2cm3glwVtzFws3usMspQEJZqFNZapG0XVzg44vGt3kk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:49 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 01/28] libmultipath: Add initial framework
Date: Thu, 23 Jul 2026 09:35:59 +0000
Message-ID: <20260723093627.2327456-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a976081-2070-480d-7d1a-08dee89deb57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	cr7U1zWXqJo8JpeZUyuMB9QpPpyAPjnd1/8sfN0HTtJ6RgkuzRPcgEeDErh/KO3C9nHQ2iH0Va2cKZirITNymYbmTgeQPp5PTsFyRCW7LZirc36wbO16Uvc8ugrzdovojBSo9Y/52GGNVxGKL5wyhm6UoPPR22e4FJOBSNbnHg4231hhmA65X0xWItsY32SrNC/aqQOPdfr+raE40pdzIF307zreLJrEP3tgW+lETcU6XTXg2KMRAm2p5g2ks4csoe7d+Q0xRhQgORBLOgt2wn07k2hu1Mr1HvolNqB3m/Y67aQkkyg5Cx/YuC46T9kU86Mh3Fac9ZVpuxp57Jf1dzgZGyHdbGi/W06zG4SOx1EfDehybOsrh7jm+2bBS9n8jaWws/TzgYoYN5VWVYsfYUZOmP5bun5pwrIZi4/BzShMvNMuzvn4Z6esbxCx8lrs2wMm8DpNPHJsrOkHBiF9dQLKVMqubHWMEKTJihJxn4C3RFOKsiKExAnnWZAhZDQnTS+0N3wdLNmssMp/OIE3bZyGMtSAJhSG++AojgmfDcUsVesDILZYY8YMyoECe3qVEkMEs2ksQ86pZKGA1EXwq0rZ0R2Ck5nx2DcfsdQ2sQk06TF9lbE2B5w8RvrWvltzXHz8It48OjLmvwj0WJxhsXHCOHxSUEAzOZjKRguQVaI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R/fgenggsgdhqpkVuvZlvM5EbEXPBcJRslaXvqYvJOJanw9tvHvDqnAgHERU?=
 =?us-ascii?Q?Zg+V+jUerd0Ei3OhHqnTonRKaydcuiwT2gTifObK/QiS3CIymlJtfPNoAqxu?=
 =?us-ascii?Q?6dUT5aOLhb6+oY/XjuecYdzP9MeLenKaRmZN4vvx+I3D3LKgFHPQcFvqZV3U?=
 =?us-ascii?Q?LWEs16jwRme9hK10epYZbVp3wR25oOEDA1norBRbRjInNpWi+jySqLrhoDWE?=
 =?us-ascii?Q?t9CcDXr1iSkox3K4aFSceukCSverjmMjG2458rp1Na/MnzoXOkdJiwQXN6d+?=
 =?us-ascii?Q?/l33xpLBERQw9c1tLYzpeA7B2cCB0ZPQZQayLTKdpoQIpuJZelvhlnrsWVTh?=
 =?us-ascii?Q?zAzrC08WIlszVuWioI6Ga1SWPTsFwe+/TFS+WxqwMzAw0KX+vQY9TIQhaMNp?=
 =?us-ascii?Q?hGdAGuP8sO4PsKY/lGre8vHiQz0+vIZDRAbzhkLcFluaYQinYY2MXmKa68Qi?=
 =?us-ascii?Q?yLqYnYvVlfAnaHI1wVc55QZYYKLZoucmNB4q7yiSU88c3XlqG4IyP1C3wl43?=
 =?us-ascii?Q?angWxYV+fmF8SON3LnJ0YS4sWf9pUcmVYexEVFR45xNvfzQxerJGQLQqBNmI?=
 =?us-ascii?Q?kKHafp2U1YF9e09LV5REtlfDz/EP/WsW4vSJyrBQXgB9218nG6Q+C+o2GtPh?=
 =?us-ascii?Q?A5vanwapEElNIPZxk+4SWXkAD6SerXtjY2WHI0WdjNXER3cjI4/0JzfMs3XH?=
 =?us-ascii?Q?ZlTB8iiIcA5JpqnD4KhaVSTDT+cyI6V5N7RbOoTYPQwBnyQTxA24Onbhxkmm?=
 =?us-ascii?Q?MGf1Ig+/qZxL75+K+tb0iQA/5Hsjlcs30Iz4rgEGVoKx65Ar2Etsn7H/80zi?=
 =?us-ascii?Q?xjaMJJtDlWzej8O1NLhtVF0Mpk7ysfjuc+WnKPCJgPgATbS096O0IKZFZqks?=
 =?us-ascii?Q?NG3T96mY8BjXlrySQ5WHFYo1KG/Y0VB1lo3X9IPsJJNfbZGuKlnt3xVs6qJ5?=
 =?us-ascii?Q?4gwSsRWL+k9tzAvdd69ar9E/HL25NIk/9DONmlRxRKnP4sUyyztdNjT9iHch?=
 =?us-ascii?Q?mfVZsQdIrglg3Gh41q/HIXrMQpoMlaOU2FdzSQAGG//qK+tlsZ5li7PJgBWe?=
 =?us-ascii?Q?cfpUUBGe/uwCT8TdsIBdJon7IjZ2lXCG3o4KSfAitDcnGlxV+RqY86BegtQj?=
 =?us-ascii?Q?xG3h2HvZlvzHt0CZ/YK2Az0rJQe5alVmgC+nzSboYxNFqdO/91tESjqsZKQi?=
 =?us-ascii?Q?4fLxsfaKrcjd17+Qw2sqgdwW30t8d43WVo25VavxBgfxiqgHjg1O5wVfhyI2?=
 =?us-ascii?Q?V8OJipUcbiizR8GI0FjN4WUnFs076DLEVjF10rDiR7qd4Z/q9TWqDLhVyc4r?=
 =?us-ascii?Q?SwygnnTnyqUAlvbHTVpvLbNhvktCeNEDkiWilK+KMlVrf4kaMzz/TcqiHkut?=
 =?us-ascii?Q?Qi9r7Xx+cJdy9u3rX4Xr4HnMFmioo5hoGX1d66zxZsYBTpJOdZrWYwRRILDp?=
 =?us-ascii?Q?pDnMHGFFxU7Rxi9Dc+kLkFt/J/fMq8fVa9np5t7pLchqx4OqBKj6l0YpvFAd?=
 =?us-ascii?Q?vdMR6uyUiHiFLLWzo9u2vNw56Eox6XECcUuQuww+Phsu6NY1yH7Vnrl5MbH9?=
 =?us-ascii?Q?8dGhGmTGr1o4zjoX+DZMVFMMlNDGHgm4dt47iuNU212wKLmVjERwjr7zHCYa?=
 =?us-ascii?Q?Ovmg7YPi2eUrSyXtg3f0xRKob8FaOU5LNZo/NKXodFaQMnn6olOLOF57VnBF?=
 =?us-ascii?Q?OHOTk+vxP/hrq+Bw/19mN6yPP1crmfZjbyR8chH4WxaA8h3Ao/zyqhm47E7a?=
 =?us-ascii?Q?B7H+1Oxuxw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	oIhvPObh2iDIhG+8+b32t/q6zyB6KHby+I2CSTbhvztMGXc4rtH8zjnWNRJpiOu94lmaJ+whR3hkcQXMO51MvnI3npJ2JrM+dsUjTdDHyZxgG3Y21fLDCB8BYu1NtmkFdJA4IKc2pJM2NQsjkyIbl975dsfVS1ab+OJxmEs1MEoPYjldySfGjYowpPMnSTfKFxC9ccoIKl3RPesEu7nk+acdJO5HxZQ5K3Nc/DG/nfKG+MUi++NB39lyYyG87sc+Y/rOHPFxcyqWG3bTelaGLNmTSi/IKRSunFe7V3yczvZiTzsiKe7J2filA38KlIIscBYclv+qLuC9a4besXaInQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AEDzp3NEhzpwAB1Dan9R0f9KDBIS2L2arTvhkkBEYP705GaSdrM5pHO/ltfCz6nfEVSkxX2e+S0lIj/HPwaEPnuDqRfS0DXpKNs03zHO32ODwv1cSI5pa9DBXouoGQLAGqVLBjb7okX2Jb/Gy2ADzHHaYwmeC4DoBJravpe/VL/Lyivm1QkisuzCd3XCrCkJmbjG7NQaxII+Yaa+kCjg7PIPXyeo4zBWEBupq2eOueVxPNJnUma2MRfg/pKapLGfekhjjwxa3KNAdEExfHSkQS5Hd+d2/kdq+rsGV5SdIXbg/Y4E3kbn9y+FA7empir2LibUxZkdbJdGXXQ1Y9rDiiuThm484eFwjNOEe4nn7KKWWMWFAvovP1PTUePWsVx7QHBYRCJIsH5gQPOuKZqaLlO0UNeWSBbBMt//zxuurBcGjJx3RlFZEFqKYlBsSBt8AzVHVmYgspCPr2e6rm5CzYGo+bZS8jbAu5DF9GHx1iPqMU6kL69kkgh9xXjrHQnhZWlxcfKqPosa52nS3Hi02jqrwzoQ7eytPfMpdRBHpF2hZHBXdCi9tzgXHNM9ACMW/ToJ7PVBsIHjwUKNYFS9pxLK3J9V5rPTiXw4+CAIPMw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a976081-2070-480d-7d1a-08dee89deb57
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:49.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KoHkBQkMaj4k7TeCKeOGeU3eIV5+Ib/vrHKKvj6WWikvwtEliim+pFglK68RZANfKZgNlaRThbrZgG9oHbvWlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-GUID: Rj-lwq8ZgGhP8m-xXD0rlArdc6nN1qq5
X-Proofpoint-ORIG-GUID: Rj-lwq8ZgGhP8m-xXD0rlArdc6nN1qq5
X-Authority-Analysis: v=2.4 cv=IsYutr/g c=1 sm=1 tr=0 ts=6a61e0b7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=IMLwmY2krkRuQTCR-eYA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX410Fehbj+5k7
 BBJINHp5PPVTAbBkGFazwTdPqZ48g3YWrHY3NDoypOICq3Vf+LnpjdKAFqPaSLOCN6TY1CBIrhY
 fGy13giURzXh0TO+j5ykEj0U2USNMT03/nvGxShBw6TJS+KWRNaR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX3w7pOAkmsLgo
 vFbCXxRrAYw1PzC+KIt8dSJpUkhrdE8WslinMYfIZG7qSWcQRaZaXrVrzptPkv0VSyh7DikXHsT
 vFWe5oiVSgR22XiihPZVuK4cpctv/9vYdE0tcb1Ioc3L41ZY1nPJGn3MlmCgIm1XDkYda4Ymbmm
 V1PAakK/gJAqYhylNwXA/peF619IdZwW8HVoaaRptivgK9o7/HFUbh8hvstad1/FX6AeadbgFVR
 9BVnulTzX3msMV/l3YpTf0Xv5DDWwgpfIq32EF6l9ItJ2HkDN/VMx+YdhDLYQzToncAMaT8yO8q
 lPXGCMA3nFzbwRhqfgEfRlk4PRz9N4ClTBx9XAvc3Mchv+qslFRCHzG2S3KIKWMiFBnV/LG4PKz
 tgxJAtFtGsWOokoumopfIpDzHGLdm+zk6WruoxhQBQUUXfKMgY0zaYq2wC6PBG9U87B6+tz7gEH
 auqNIgfHY4qKsX+dnDg==

Add initial framework for libmultipath. libmultipath is a library for
multipath-capable block drivers, such as NVMe. The main function is to
support path management, path selection, and failover handling.

Basic support to add and remove the head structure - mpath_head - is
included.

This main purpose of this structure is to manage available paths and path
selection. It is quite similar to the multipath functionality in
nvme_ns_head. It also manages the multipath gendisk.

Each path is represented by the mpath_device structure. It should hold a
pointer to the per-path gendisk and also a list element for all siblings
of paths. For NVMe, there would be a mpath_device per nvme_ns.

All the libmultipath code is more or less taken from
drivers/nvme/host/multipath.c, which was originally authored by Christoph
Hellwig <hch@lst.de>.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 28 +++++++++++++++++
 lib/Kconfig               |  6 ++++
 lib/Makefile              |  2 ++
 lib/multipath.c           | 66 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
new file mode 100644
index 0000000000000..e98b4b241020a
--- /dev/null
+++ b/include/linux/multipath.h
@@ -0,0 +1,28 @@
+
+#ifndef _LIBMULTIPATH_H
+#define _LIBMULTIPATH_H
+
+#include <linux/blkdev.h>
+#include <linux/srcu.h>
+
+struct mpath_device {
+	struct list_head	siblings;
+	struct gendisk		*disk;
+};
+
+struct mpath_head {
+	struct srcu_struct	srcu;
+	struct list_head	dev_list;	/* list of all mpath_devs */
+	struct mutex		lock;
+
+	refcount_t		refcount;
+
+	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
+};
+
+int mpath_get_head(struct mpath_head *mpath_head);
+void mpath_put_head(struct mpath_head *mpath_head);
+int mpath_head_init(struct mpath_head *mpath_head);
+void mpath_head_uninit(struct mpath_head *mpath_head);
+
+#endif // _LIBMULTIPATH_H
diff --git a/lib/Kconfig b/lib/Kconfig
index 55748b68714e0..d0258bef374a1 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -636,3 +636,9 @@ config UNION_FIND
 
 config MIN_HEAP
 	bool
+
+config LIBMULTIPATH
+	bool "MULTIPATH BLOCK DRIVER LIBRARY"
+	depends on BLOCK
+	help
+	  If you say yes here then you get a multipath lib for block drivers
diff --git a/lib/Makefile b/lib/Makefile
index 7f75cc6edf94a..7ba5e13be4171 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -334,3 +334,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_LIBMULTIPATH)	+= multipath.o
diff --git a/lib/multipath.c b/lib/multipath.c
new file mode 100644
index 0000000000000..9cc398d266adf
--- /dev/null
+++ b/lib/multipath.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2017-2018 Christoph Hellwig.
+ * Copyright (c) 2026 Oracle and/or its affiliates.
+ */
+#include <linux/module.h>
+#include <linux/multipath.h>
+
+static struct workqueue_struct *mpath_wq;
+
+int mpath_get_head(struct mpath_head *mpath_head)
+{
+	if (!refcount_inc_not_zero(&mpath_head->refcount))
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_get_head);
+
+void mpath_put_head(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (refcount_dec_and_test(&mpath_head->refcount))
+		wake_up_var(refcount);
+}
+EXPORT_SYMBOL_GPL(mpath_put_head);
+
+void mpath_head_uninit(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (!refcount_dec_and_test(refcount))
+		wait_var_event(refcount, !refcount_read(refcount));
+	cleanup_srcu_struct(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_head_uninit);
+
+int mpath_head_init(struct mpath_head *mpath_head)
+{
+	memset(mpath_head, 0, sizeof(*mpath_head));
+	INIT_LIST_HEAD(&mpath_head->dev_list);
+	mutex_init(&mpath_head->lock);
+	refcount_set(&mpath_head->refcount, 1);
+
+	return init_srcu_struct(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_head_init);
+
+static int __init mpath_init(void)
+{
+	mpath_wq = alloc_workqueue("mpath-wq",
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
+	if (!mpath_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit mpath_exit(void)
+{
+	destroy_workqueue(mpath_wq);
+}
+
+module_init(mpath_init);
+module_exit(mpath_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("libmultipath");
-- 
2.43.7

