Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DA530CD85;
	Fri, 15 May 2026 01:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810316; cv=fail; b=NzmkswgCb6DsYNnvK7PCfRnmsSoBehNJscYun7xsP67SMSZtzAcDBr4+iztJkBvuxhvdRNMRgPdS/91ZSS4Z63Zw5022kq65iAma0i2LKLxD+kNv59K/nF9L+Oa5f+gbPTfaWdFva4d7J6GoaaanzYLA6RFengsMuBIaPydf+P4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810316; c=relaxed/simple;
	bh=WVv6gARy9WPwxczp3EkWk01Mh6KWhx9NrMmysyyCwX0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=CXi7mDu/3bidI1x1TS73NL1rey9BQlnc0C6DpesyqmJzy1Hg5M9G5NRS27ZB/Cma73NL11lXwxWCOfwgv6xYk2/d/+d16yWWo9FjFcPaelPqUw8vLV5ioSi279UHN9MiBvqmmrxFfLEppk7fL7cVyo1IsAJV3I5Hf3QtecDipWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j7SE0Qgd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Fh4IdgHt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j7SE0Qgd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Fh4IdgHt"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0U3mG1777074;
	Fri, 15 May 2026 01:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sPZ6a4pxrlfkn3SiNd
	DTyE6XFOEPanfM0RRieQ/TcU0=; b=j7SE0Qgdf/WSBLZIaTwhaJgBeCPNa1zDj6
	bMCZIZl2xXGp1T/q08O8aiOpevwIQ/k+53VhesvLuf37S3IOuF6ajclY76m2kCJw
	HQnn/Uw5stGaETCAwzLBhK5wObKfEHNhKTyJrp6IJeF2DZZQp6Gwp6TaZyI5M9Ir
	2RFwcMHKEafxxZqHhFF9KaQ+Mr7pVUoGpavkNiSEZwe2YRkLoWGBFR3fpADx/hdr
	RO76mVpPQNahKULRcVxD0dHmTim9l9Y7ka6XB7MEyGzYUPY6TiraCRedvuUpx207
	RMaErhYdgE4Xk00hGEu/VhmhcXtfaP3eq1fOfkCofnnZPFBPru7A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1rrdgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:58:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F1njES033199;
	Fri, 15 May 2026 01:58:13 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw54rst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:58:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4rkYTpdxSOyQr6aQ713qwIISDD2JLm+e4sn/K/99B5LNA71K87jwIxJvCtTMkvXdtG9YK1gQK9r4PTbww2zMqtFiZtxUdaIPladvxDaldET+2mjDJ7isVJGGaQsKr1Jn5cwlg2Le1ZiJQqrpeewOlOpq1qwSzTa0fNj7aLWpXnaJ9Vx0rQSZcEV7E42odn/C9IEnmMYkiFWCHCE7JfIl+gXIkZq9N7+6WDwi11Ga7/vTAfQbnISJLGtblwx1X6i7FtpCTiZpWCAjPzHRMfz6w4/88YbG3k86EF0LgX7JM3b4PaWLiCKDokXjl9377s454YpTft0C7YKTqWMSnwB0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPZ6a4pxrlfkn3SiNdDTyE6XFOEPanfM0RRieQ/TcU0=;
 b=kDHvCi9msgaLR+U6MZJyAHlNratHOm7WwBO0HxPilxZhrjtBURwRiNfr0YmvJsQmXVkaqIkCJVQe3VV6tMg8wouNBVXerMofhSc04F9VKsqSJ2VOOmE8k8P+nkvS9HKEjHn7cncwQc8D5jvc+vcilE+UzcIAHZZTy1Gl/01ow4xfB79FjazyRiuxwpBWfTvf/t7d3bmouDo9X4Oqb4LuxekJ6x8YkxQ4PyO4C+NQLRa/sKeWBht+C/m6RV3PrwUNLvYs6FZKKTm099sCrLwZ5Q7bqNkTgChCBHOIDWFp7/WP3c5RbYKa5/M0Hihg/q8sZDSDub8D5DQOUTcllAPMlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPZ6a4pxrlfkn3SiNdDTyE6XFOEPanfM0RRieQ/TcU0=;
 b=Fh4IdgHtDf0hcXZX4J48irn6O6CCg2QocXGlyk4IYsIxzOXz9A/Y0WJH0m/9QYRXwVwu8vCOCWir0uthnr8DkbX5w8QKdbM21bDeKuz5qQ/2MxMuBwAuTTCyjQMcjeL1irWDbs4GSJG4A2vSZqH1lG1jJLjCez7gqWiQdVbeDSA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6179.namprd10.prod.outlook.com (2603:10b6:510:1f1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 01:58:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 01:58:06 +0000
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Tejun Heo
 <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic
 Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] scsi: scsi_transport_srp: Move long delayed work on
 system_dfl_long_wq
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260507143410.337267-1-marco.crivellari@suse.com> (Marco
	Crivellari's message of "Thu, 7 May 2026 16:34:10 +0200")
Organization: Oracle Corporation
Message-ID: <yq1qznd8mej.fsf@ca-mkp.ca.oracle.com>
References: <20260507143410.337267-1-marco.crivellari@suse.com>
Date: Thu, 14 May 2026 21:58:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0005.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 69235c60-f050-4d58-a9b8-08deb2256833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Fye5NrWGLAX6KvTZ2C+N5cAiQ99+cG3benBWG3fuWKgDvsl2XswzAMvncViF72VpH1BQG9a0A0gAskG0iHu3ol2Y/6Fk8BiXLZIOx77DL5CHm0G0o0Dor3qKCFq9orn+tLTy8D8Xhqb1QwpcoJX27jjVO7EBCKi05VuZGyoMx2bchKyGZxpm/uLGGMJRdWX+wqUaNHhv4h5YsbSTAUc0RAq3UiXDkVqq3Akop5ekOtFvpWCfoSZi00OWK0axID36cAkiSY5ptRtT7ypwf3Z5nIrpz9oB7+t1F07CzLuYvZz/HZX9bckpgHFXIyaZArkSD9OObixFAvWEfYuQ8gHWg4vOz4D1BkuwcmQhiMHU/IwR9O3Rlo129EIiIzs97Oige2a39p/HLq5IEUV+LZAClpNaPP6lnuCMKtSpOCNTw+ayfdx1Ms52J+qI8k1V3JC++7q7nIGGifmeORagYMxILIN0f49Jm6jrVCb8b1F7vKuOFxWD4khlE99OKRGQoy4KDbh2urxmfOyKZ5JBSv2CF4SYWYdFrWt6yrx/gHsx2wDfS/Ovq35avY/4jEj1RU+1BRN9dpZ/ZbROeJE9UHAh9hHr/xSLVHHtnTc1uruxQuCIZ9lz0ytq1RbCsvyejyxXC+eitoc3cSZACupIHaPuaOnWswH0yGr2gcC39chSZA8mi+EEGsIc3jvNi2V12Uir
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ivzz06SAzSMcIR+o8qCn5Kq6CHHzzkrdsnh1uDa0QyMhp1TfS8jgw6J3b91j?=
 =?us-ascii?Q?4do4id90K2DnAEYgqXb8qc5+opTa613OWElrfG6qr+JK6hioW3fmNoqclmEj?=
 =?us-ascii?Q?ZWTvr46b8LEhhW25Ol6FWcIMytYNdN7Gq/E5ERfeFUuCVnnyRkrX9AH9Jq90?=
 =?us-ascii?Q?UoGNAzBZoFCO02lxkMDDa9OgSQe36HPR5wFOoTnk9pVsfAQzGNdRvGU6hEG5?=
 =?us-ascii?Q?0rGnQ1+Ynf+aMOFk+Ui/L6AdZIrVUXh1MioZij85x4Gq7EdfQwkXsisOuSn5?=
 =?us-ascii?Q?7QL4h+nynPRRdKQ0HCf0EYjNJVtrTv2xCDvbAHFZ8nND8ENHPBHM+tMNpFk0?=
 =?us-ascii?Q?bW56nxU7KhZVE7TTEH08y9mFt3tMAkuqFq0CrBeJnLTwQen3UO6BbsEj1nvz?=
 =?us-ascii?Q?GUTjEQ2PzJWeP3cxhMzhAL8xg2CE/YarNtS8SYe7M1hEFf5WbEUlliplraZ0?=
 =?us-ascii?Q?YHZbpAQbwSTSS70epeZVO3jVNCCufBvMQQLrYVZKL8q9Go+o+YbKarnGa3Jc?=
 =?us-ascii?Q?XU+l4Vww45MH4TsLnU4NQ6I2KRrzM4qZ4OlaBOiWS6wQPMldqZjEc8c/Zo2F?=
 =?us-ascii?Q?Xh14JlZv2enPTZLCXq1j84r0v3KZgRXFEiXLuw69NtHLXW81O+yG3DFmq63D?=
 =?us-ascii?Q?2a1WYptFZZHrYemjWeSz3Y2Je1DRL0ooR3/6p6QK/533Qzr2ChQzMn5VWkE3?=
 =?us-ascii?Q?JeeDQa6eTJuPnrEAIckRXDf9RxLzuFfn+pAcBGhQI81aYj+tfRaAaQz1E+wy?=
 =?us-ascii?Q?oms+i/Xud+h6IdUtxwRm17GEOIpLgUoqaXTBoh08WbBKgeFUUuzeap+cHDZH?=
 =?us-ascii?Q?kS69xJXLCMEj4kgS+56Hx6OPgUZh71dA8nwl7Kvd5g5SnwyZY3dD6I1uhzBW?=
 =?us-ascii?Q?mhYq1vFKtE7746fcAriys9A/DSdAg++Xfoe0mq6YLWYqNS1Prw1DJcQLh6jh?=
 =?us-ascii?Q?OniZaKiCKJL3i1+Ov5KxOMQ0a2FJAUP6CeOt1lQT0PgSunUHx+WdCqf9fET+?=
 =?us-ascii?Q?qygsP0ZJxn2zTdSPTjc0OUIaLSGJGWC/PFdE/x78m5JFFUnn9d+wwDyHIB8o?=
 =?us-ascii?Q?n8rxHYxiHTv52NpnxnO4fx0TLwBqgL+vMDGLIOCMOAOsHU2UE0jKYEMRetgD?=
 =?us-ascii?Q?iMP15l7AfeeqL5b6r/0wudZUezO26ueU5UZgkSCTkw9ho4xEgp6zc8ITPMhx?=
 =?us-ascii?Q?hHYS16DSsdudB1o+QyQCu9DAsPmpZPu/ZTgU++1fjrjmbd+snfo+tSoiMX8F?=
 =?us-ascii?Q?xeUFznvMpuDjEMGGyPYjbBZNjIf4fw7915uLpX5NYa1eLA+5bECZHpd7lWKW?=
 =?us-ascii?Q?jaGgAup6lZPhW9tEqfJXUeAgqIje+jD9KNa40BLDU0QcpIDL03SWt6IJS1qG?=
 =?us-ascii?Q?hfIkHfgdrbmxTcSuD6rkQM6/AnwTtIQH9uFXCos7/q5yFe1Zcgle4St2NNei?=
 =?us-ascii?Q?f4S1Bd63CIrcd5WOTWx0LiHdRBIUp7lru44gVXe0wQS1n85SyPc+FdsqIOqw?=
 =?us-ascii?Q?0zLVdjLRDa4sTPM8gMPRWFvHxc39QHNkt2ysEMVsMr+BUMAx0csrJ/5jfw7U?=
 =?us-ascii?Q?2/k6IDplAL2hE19B5L8KKa4FXkkfr6xYcdO/x8c7zAySSBcZZW2AC+NOaAHq?=
 =?us-ascii?Q?93Ruiu64wEoBegE8ZcdNUnxY4bX9AOoIWpLsYkKRzKHWD7780D82f5RO4zUd?=
 =?us-ascii?Q?Fh6rQ4GFXog5zv4rQw+dziB1j6U/Az0kbhcnG+Tnbu1qNZJBQqgf6kvzB2qO?=
 =?us-ascii?Q?ty+HIOJeE0qnCVUQw6GJ4ss+aG0zQCQ=3D?=
X-Exchange-RoutingPolicyChecked:
	CwYMtU4BqPDItQEGjAonVMn4aqE3MKa7EBZODjtNa8PlmZRtokHzqWYSI+wRICp0FMny3r62m3N2JTtXKTjDzbuIuFc4/QfhsJssej5m/eY+10mO0YzxJu55AR0d5PEnzI5D6+cQAiySx27sCpmwWLzNRWuox8cHuCrl9rEQ20jnHRT55zlSDwUm/7Xouu/Om2ZhAHr9fXctH7u1RNVUcif3RAghiaWGuvhtHMcTfjMlxUYdbf/GWrdAgkxOdEFvmxPKaXX0xqmK71kD8aL/AYq+YWTh9WlMzoNrY6dPHzvr97G4819v8xNinnZg9weU7ngku7lRUO6mUFi4gkW7cA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	58/JeWwiYzCmr82JKUU8Njw/HcUiKaB1b0upJlHXx3wd8rBCGd4hyDZ0d9GA01mhRQr4rcRQQXv3rqlzqXtRFGCSZ8BsEvJHo61kIBsxPOvr2T9+nvjMEibXUiIYst6wXF/tAOKrxyI8m0LeZXgtRWvuITHlX3T/vdRCQRzUNMTBkfo49BWbLpxqnBTFKu5oL1R+yigwQk2zyoXn/PEEtkJ9FMyAKeuN3nE1KAqfffSMSI/InHTL57ksj3bp3OptUdUY4NdALw+3kpdsb6QbQx0OqdinXqTtgyEGN6OdXuASNrKPfIvncBVb4InSFSSu+Md+3FClQmhVnmiaT7wBIW9O+tY0h9JslfY/mRCvygq+ickapPzhoCpSXrietx2s6iVz3Rau3fXmpeCRZmQy2XJDvgxX4/P42QNVe5NqcP/RSs6N1V2izNYGh44xMAvNcQeAFzsXCFJ32jka/xaPPbUcZawrzwBz7OYQwbpPz6VFoxCnjvTxBsABlosk1ssiu9a+QxcNsA61MoMFVszr9wZxvVPZvl9N3m4uQSXbWA0KdCvJ0JawOJeZg2KSjhV/hku9gXgnK8A8/V7H+8tDdt0ZcZbV9scvfLu96/pmQds=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69235c60-f050-4d58-a9b8-08deb2256833
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 01:58:06.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzbK508kdVXTCLCRp+fl1bJDgpSk4un9FbXTn3jr1YDzjRLHeGRA9H77aSe9pmH8yilraeAy10icSj3m6K2OalW3fNyJdI6Xc+/TRV75jmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605150016
X-Proofpoint-ORIG-GUID: 7ZEx7xz_LI-wQDrDg74nHDVom_blqBQI
X-Authority-Analysis: v=2.4 cv=YcaNIQRf c=1 sm=1 tr=0 ts=6a067db6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=Qd_XJmDTjCV-o7kNHBYA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13839
X-Proofpoint-GUID: 7ZEx7xz_LI-wQDrDg74nHDVom_blqBQI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxNyBTYWx0ZWRfX1pWNDnSmuuDG
 5sp3nqTPaEurAeVB955YfZ8reDXBBzdkGFK3UHWgLlDCi5fYzyEosBWPJxZr4Rjxd9qn1l+TVLG
 v/WUuOJLLxWYgrL16JxTqHHgsvmE/eC4lKgn/7Uvboe4N6kFM3Bh36gcz71/nTn9jSdm3kV/ppv
 4YbHIQL3WrhS9KMcELHgnTVwV8ZN7in9deRtMkR0KvDBkMCjsSM/gqgAp5zFiCSCa0r6mY5xkAy
 rdJKrUW0/0UzprUoaVH0JHIT6Lbd1FzT+YdSzVKiqptBLLriW/01YpNt9GJIadAbfJaM230heOe
 DhCCe3m18t7YHxQSwABl4l9PR8pN7jPbu/vSTUsEPpsF8m4/SStaBbYp/8xaTQn+v7EJaFTfq63
 lXUz+BdvuLcv+xwWPSb3IAvWiwzdq/M4fI+7D83R5Plht9CVJv89ADFGEa27L1KTa2S2/4T5aur
 LX5ZbTpbF3DRfclUTUM4Dnlf1BUjBQ6xVthG4AdM=


Marco,

> Currently the code enqueue work items using
> {queue|mod}_delayed_work(), using system_long_wq. This workqueue
> should be used when long works are expected and it is a per-cpu
> workqueue.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
