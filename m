Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A52471D14;
	Mon,  7 Sep 2026 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778328; cv=fail; b=rLhr1egCD75QXm6KCq+rA9+5OKeZC+AopSO5bwR3gbjU/NMtHAg3+a5AeGhh+ERnqljviwE4wrR5pdP6gq4wvIFL6cgJ6SKp9o6TrC0Hg3V/qhkGv1MpfbdPR4aWHhBL+EBWOoT2kbSmXPt3W7/edlfztDyji7tTR6znv4621wY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778328; c=relaxed/simple;
	bh=VrWyFA0ezpBF8OUbwISN6vP09cuyyb+Pp97YX/ONFgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PvY+eImD7g24o9M8nS86B50K7QpQnNbos949J9QW7X91OTVJf2vC4tAYSr16oqg7eC5poz1XX7Gfe9WKI6zzDBjfIkmu5YnaK6PxPHVfMKNIN8t+L1LMwfUhdnElOiF35xa6ZEajdJIwJyByS8O78LXLsnlSgwEEzFfTbOYL5Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FCiL9FUi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y34MTKDn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FCiL9FUi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y34MTKDn"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6872hQQ9474184;
	Mon, 7 Sep 2026 10:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ny0BNd2Hakio3U8vUiUCEaAg3K4HmbzrQRuJLK/o+Nw=; b=
	FCiL9FUi5leX6hf4gGDJUeXGS7QYjLNVm8/hsEZY+FApxAOfq2A/AFvlYnbBM0uE
	pUqkyUxmvSdqmDe8Dgjd5gmgB9cyfk/XSsSNVY7ko6kZ/EDhq1m/w2Oh0lk7UuzE
	RtgVjAko3SHLEXi65b2IPnTJgJVsawTkSGwAAuHFV8frTwHgZ6KRHtqFF3T8evte
	RB4PkxSG8nLk6PyJiEgRzMpiOwF5LGNxRK3s+9d7fhc4Keo8XGxpFgolR4gWOZUC
	Ajqp5rpc61W9hO3+nq1nFmwlfoBsq6k9OQcajumi4BPUcdtQK48O3wpHjxVXfZxO
	ypa2ldgDL9hMy6YjSL604w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbhuht0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfI019106;
	Mon, 7 Sep 2026 10:51:19 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yi4xccNciL2EefP7PePfu7mQdnIzA7STE0jJRrThjGO5CsHc1Z0+SvxaNEz63lm5dYfHDzSdNxxXC+VivEcxmGPuN4/MPCOm17jwCIzbjC7HK1jLTz3odbhGoQ5XwlB+xiqRJyKUXdxqAXHglIGW8Vao3b9GwikhfF3TDNIbKqi/TlrgCCF/LVeUMINzCrYSGV2bjshKK39tKjnqSfsMp71xw4JLCo9jWRmdBz/HlnNsRZvHI1h9t+//cMDoNI2KExzrHJy2KL6V2B21zHet3OfTJ4LIoyebD7639SsbQdhXNzCZBrBd3aBDUVMTQNjdTqsXoMPRnBVXIKBJfBrN+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny0BNd2Hakio3U8vUiUCEaAg3K4HmbzrQRuJLK/o+Nw=;
 b=mGQT6TyAxrAzFl2b49lx8MmR6h7aecrWyq49ueG+H/spEv5gw4ZQQi9/OgCUJCWkcytJm97rYGQJxiXRUE2hHhBdIg2KdI5B/UEByTIMvK4LL84IeOaJ9O1RR4gRhLYj/oLmbGrMAQTggkyhoVEnTNugaViwY0Y2zyI2JwezEslafDCGhRaOlSvcF+mPAyke78rI7B9vx+Q/WmQ6lgBg42my++BdyTd5SIpdhOYTu4tbfcN4VEn2VdMR9t6ZyAh6Mn84WeAfXp9wWFhwA5PS6GmPqmVNuh139UswLiHauMRDUoYA4T2IgiAWT21cLTAQuLJL+iDUqdwdWX4FPbNQog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0BNd2Hakio3U8vUiUCEaAg3K4HmbzrQRuJLK/o+Nw=;
 b=y34MTKDnq+C5+13/g8BENfxf5gFPr387vFhNHUxcuJmyB+92yl6OowA4haKDbS2+p+k8HFrj2hYsrqCW+w1FIOd6Up5FF8ZDQlqmcfBWQ4VYhQ+e4FHD2DCYZGCXtFOH59jWmxk6vq3N7brNjuqqsYDW3stnE+B1AP55l0SSLRU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 16/27] scsi-multipath: clear path when device is blocked
Date: Mon,  7 Sep 2026 10:50:10 +0000
Message-ID: <20260907105021.1763236-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 22336eb2-4c69-4b3f-9322-08df0ccdebae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iqaPixgFO6qtqJUpxIeUCM/nl0XbnPQJu+rc8sx447W8WbEWy+fbOsgOScPWJ94C3eDT0fzFKxW3gUyO2iFHherkrPQzpA4MxN4xcwNiH2UTfCb073Ah5YR1DgOqRa4J/sq2jB1FyDXnYcuwYU535vrZV1GcQKLfpX4NtC3jDw4u3952KZqfGWf+SsIWgFaUZ7XnXBugd7PylkIKnUy9lYeTxMMg8Tqg9aIjvEUiK8O0IzlLrITsaYuSrapCB7W3Y6v4juXP6iOQFeHLqvIo45Hy/2gU0DjhUMGHB+567zHpyDyR6K/EDv7OfT8nQp6k4sWrN2x4SpMaWAm5lK5m4laMCDlMR8weRErSpUxARpbLSFYhmXdxPqO7taDhXG3Dnkvqw/dQMA9DTLPg507KGdevd+uw+2docpO+JbBdLsrJAK6bLDvKa3dR+TGxhrCYXDxukkrX5bXR8v4nvDtgKcOdb6kMOD4y6LxSx9WKF2ztM7ENJYCPfYPEiWUwm6kYgkqRLr2Z6mvrIOscxDkUjfjAoH2zHvyJ1cXvKb+gZW6/a9fTDX19xcAvSHGN4J3HHNcxNgt6QLITI+1JHHAWoIkDDbzpRtMGdEmscTFwPdrJcMk9JxoPdVnXF3JnU9NrKKrzl+mDmg/0/4GPr+oqA3cLHZWf4ksXOICaA4eLuF4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lp03bO8WlExAh20XVk6658T/drmBlYRRmvNZ74xfgorFWSzjWHe29FhnT+td?=
 =?us-ascii?Q?6dzJ4xlqwxTxngeIF7AvyJx4Eripggbr8fg4HkOU+umYnPOCOv70cfPWk5yg?=
 =?us-ascii?Q?dQisFttHeEfYExPwZ4wdndlc/Dd1LiBJGRI1QHO8/hS4iL6zpM8fFT3YcVzF?=
 =?us-ascii?Q?3KxeGfXQCMpUmkiUX6dfT3gjEzpzRq4NoZkHFACR20VqtCPIykbLJaaqcR0z?=
 =?us-ascii?Q?aD4fM4e8YRNnVfDuHIqZ7ghSCg0X6NCEVl4qvD9Pq4sTEBRerr6m39UH5nM6?=
 =?us-ascii?Q?SILY2UgAuoD6oH3Ylh6HCqLJ5lJoT4Es3Uhr0F7gUf0I+FGLzStQ8zOslCqb?=
 =?us-ascii?Q?00WbZmCotS9TU9+Ud1GAQjUWzDKbLkpsjvSmXDK5c/xJJHq0ajkW85Bi/Ynw?=
 =?us-ascii?Q?b6QjbZSkVdcXsKy3sDRyQRIvr6znBtxLyJhk0+o68etawIGdWNlra7y0IMh0?=
 =?us-ascii?Q?/dpjG6QW1K/ZzAFq3Q+1iR8zIk4F44t6OYtgY5A5HjxfKsoGc5WCrcZ3B9i+?=
 =?us-ascii?Q?WnRLsZerN1Bgw/IMBEMTgaCYSgznIe+L1O87wuVUrkYcuyJ+oRkYCZe57nmA?=
 =?us-ascii?Q?6QnBdVbAaPrg3UoIOsX3Y81VOGi7uAhbw92V0UrkrqmJCJu71NBFYgwKIjz4?=
 =?us-ascii?Q?u+983DBO/IEE2ehxlwbJ7DYJYOiYousTXrJk08gy8jYfMqc00k2L813DKSoN?=
 =?us-ascii?Q?qZP4NGJXH9YaBfwKn2C1fs7KeOfHj8z9x5d30C+5EtLF+uewiBPzPu8fCNxi?=
 =?us-ascii?Q?RPrgf6NLttpltGUZOo2eT8zkynPJlCjuRddgNILdfa8eMS2Zh/5QTaKCSqW6?=
 =?us-ascii?Q?CIkRd2KcH6HO1F0vAOf5cYfafyxtuLUHwaqOpoRgBIcvT6ciSCpcp5Ejej5k?=
 =?us-ascii?Q?Q9qYJkEpoGtBHI5tZAwTqftkAu5na+gTsu0LaU8YNBlEXNhpm6FpuroHE4xD?=
 =?us-ascii?Q?HoUbeVGOr8THoVL0NDxIzWCKribt/kR5Dd4QwHZejzGbLEns1FoBZDHRIJOQ?=
 =?us-ascii?Q?+F3rPZoIfw/yxstDSxxINoys2PT4h6z5SJJnrzq9sqt93hZlLy8hXe89Z28l?=
 =?us-ascii?Q?8rgw0Nz660STQ5qi/J2zS9wPotyrZuIarl78xBQwcrYmZ7B4f7UlwaEqjN4S?=
 =?us-ascii?Q?b5n17Ed6wGxNxbMxu3rfWLPDLGu0YhVUpV4ExwpQ1JT4JXz2iDCTwiS+Q7bn?=
 =?us-ascii?Q?k8kdCCWde8WrqbivkVHuKniqPjHOJYoEjxEYfS5du06+de2hRNF5XGkTNAnP?=
 =?us-ascii?Q?hXPu8j9xOPlWq4CV/g2zJ53JFsXIMwpkk11MuNW4yUQkWy8e0Vumf3UKL24w?=
 =?us-ascii?Q?wRcw7F4FFCr/NxPZE6u3pn065VKPeKp6vYado3fSaUHjrLIhQWfOy7duCj38?=
 =?us-ascii?Q?Ly+WZbxUxY+VnR1tMEMBbUTngz0A8VmevXEkPkJ2BX7L6zJLZl1V7/Ii323t?=
 =?us-ascii?Q?v1/DQO1mhVb4id6du0E4vpQlmbxTldARKK0XetOkGZCxGHDu4Mno6Wqq0VPc?=
 =?us-ascii?Q?ygRUbmKWNzGtFKXPWMbsFGi0aqmO9WzmGNMtR2lWbv+y9ZDYoN+AMdrBWEfF?=
 =?us-ascii?Q?zD9DbG2nGDZ8z/WEfVSPrJquXCb0t0Q8iJmVlBUgoOaTOh9MD/QoUQraw8KN?=
 =?us-ascii?Q?W2Jkilp3N18Xb5K117DvckYm4vg/JCHGXzkmdeKYlnseABTK78Yt/dUDUbEB?=
 =?us-ascii?Q?8R+CPXufukDa/VGSI3MwxhgrmVldRg2QaNbDnel+XC+GZ+mkpkkHBmNj49Eq?=
 =?us-ascii?Q?5SGKUURusA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	iroNbptE1P57UKxhFCl3jn2V1vyYi2utbmclYAwbHwLbnlQULKnACq5XxGJSKIlSEeGQQAyi32QEXRUedlhF68kzE8Ru/Rc1WfSnslXxmQtV8bxmIfqYyEBvWbCw3jAA+gZa3I+CToHeYhuo3zRQgwdJmjjvvXJGwvPpYI2Yt+xngcRRPWd7kl8YKzv+OEvx6kHFxCKnaIcVduvRgyMkUvonwY0ZSeeFQ3VwDYEG8SM3h04RmfbqlNDCdQdndHhbsBcUDqgJiHszI0mSQ64z24uLRJWFB/KGxTEAziHcjFFJGYjFvyoVM1Ua+QQbQJe2ygCINsIiew6XeWhJkxIstQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FR8hmJ83AykQ5uub/bkUQT/eMRcHiWVBEXCVmhyCz5FOQsCaOvfES/AVbukt6UOSfKK3OGixwMAJsygQnT7uzcjDz5o/EGVbwfGEd+NfMunlsmEQySWP1ciA2uGp8FzttIBWVJQmgtqk9owJmm/2Pvc25PqhSMC7FFnalgSDTrLtSFlEkPvxhR053fc/CPjSgUnUCPgSuA5XLKiXQ8VTWvyqDh2BXlZxTz5Xb+9q3B0+SDPOgErQHu3FFM801b4vy/29WteYixpG93553f9Ey9B+ovQ02f0VENeIL4siH7KQcvQJpMmwI858LNfPd8+MFi87HPOx640k67g59DIJtQWyCca2GJ7a+eagg0IsU/SCXGffKFBk4BViVBFcKnpyqa4nibsYwRr/pKMEn8kITeIhAb3XSAoJqFKSqoYeliOzYNuiUVf6/kCwzkOTBvxkmeSUxM5d61zrew1hKQPdGEnJTO2YcSH4o/rJozsvkCP3QKBrnh5mGVUDj5H0TbKNbPmGXbjg0RrRKzTAS5nLC1uUNCDdkQouhSSzwvqe17aVYzoN6sii0GkeSyeauopw6496ZoZq/XCth1ZTCER/FmaEEPjxkPdoJDU6kOfjXuE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22336eb2-4c69-4b3f-9322-08df0ccdebae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:07.3568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFNTShgTeI4t//XL8BYxv6Uj8qj8XojHq4BnTYqX/VmBfmsCM5VloN2m2YnqB4CkpxA1PTO7vMn687suprK09Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: X4D69Pk38fS1dYVaf1zQE_Ya_3r-IOjD
X-Proofpoint-ORIG-GUID: X4D69Pk38fS1dYVaf1zQE_Ya_3r-IOjD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX7bRUPSkd33Gr
 NNzQ4uf6kQlj7+aUkmxv9eaEfUEB38R+xYhhUgYN94XlvyLfMbxC2qboxGlPGdZjB8Bkl19NgZP
 Vvn3c557ct+e3NuHPHmwpNp9wieHl4Uo6L/QdqSQxXh2j8AaPsxwnWJ8mPbpN5AlOxxXl/dUOjL
 OpmNEhYWtektZ1lDqk/UfeW2omqNXIp6YWT7/dQMkX9dKJsSZ74DGORz1FAUPFMy3PhrICBNvIz
 ahv4FS8YRpqjiMooJ3Rz1j/Y72u3uJ+jIpj10Kb4CboXIX9nQQMorBPayT8ezUEOFxwMxptSsot
 ySsIb1iIgnFm6GBOURkpYWuJ9RwIIZIYVZ2Ud11av5G//9v2aBsz8qfS0OVtyZkx74LqrPVzXdi
 ARdUMyVp++u0Ewlna1bMrgtnlqDZxPiBUzyPSt/uSmkVGe9a4lsOQaEqNIjNRC74y4WMExW84BP
 1K4emNj00MfuYn+5vSQ==
X-Authority-Analysis: v=2.4 cv=S4HpBosP c=1 sm=1 tr=0 ts=6a9e9728 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=dGdLxrnxUM9qrin9hOsA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX/zaYNquKeCTR
 q+qXteG4E2yBtdbRtCspM2pppGzsDpxb163vXK25NMYoKGgwgA6MncSIkpAoMlVGeroI61iPnzV
 mQTrxwcVEk/zaMKa4/3QesP7t9oKarCISP/KFBobkm5SDoOc/3FH

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 10 ++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 48aab0df30b76..56200a7f5c748 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_multipath.h>
 
 #include <trace/events/scsi.h>
 
@@ -3009,6 +3010,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 		scsi_stop_queue(sdev);
 
 	mutex_unlock(&sdev->state_mutex);
+	if ((err == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 
 	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
 		  __func__, dev_name(&sdev->sdev_gendev), state);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 68fe50f62158c..b16fe6a55fa73 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -238,6 +238,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       if (mpath_clear_current_path(mpath_device))
+               mpath_synchronize(mpath_head);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d2ef94ebd29af..2064a3e922748 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -55,6 +55,7 @@ int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -99,5 +100,9 @@ static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
 {
 }
+static inline
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

