Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B09F3F4122;
	Fri,  3 Jul 2026 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074924; cv=fail; b=eZnFZv2og6IGewKpQd20I4IDruUrgPRDgeaIZUfC3kAzGsFJlgQYcf83EjE3YuYN0QAhjBukTFEJWIb2N50LJAtDb6MptL2tddB/vrb3cTn0EJhO5uSTkOmpfNsN/BHbroInlAyMmBRfg9AdFrTuHbnhsBWPIMSkbHhREiQq4dY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074924; c=relaxed/simple;
	bh=FZ/gXiyO7N+i22q3NMaq3VOdu8Z411Hia7DgtohmoOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fETzVJqhlBIcx9t6pRBQSr52H5xQQiy7ZrtoLkCZEwMwEc8RR18hUBh2prUXxhY+574ID1iW/DbsAeraP3aOEJsWf3P1i7dc7IEe/IPaI4ap3swMOvSU35LvzsBc5+jGFbQZwBnuyG0YuTu9Jf32es7UJKKE48f1q8iBFJYQD4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sR7SpTWF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DNb9/0Zd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sR7SpTWF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DNb9/0Zd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfOe3062719;
	Fri, 3 Jul 2026 10:35:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tatUw4ZEuhSrDTsfvaix4YExuT117AzgETaW6UTkBtQ=; b=
	sR7SpTWFgxNIheHZ8zx4FPCzD6UTPkb3KbNZzqyYyno4lkdI+ZmVq4Ol3UnZMhVb
	cE28NpDtKBuUuIWO7vK4uKOPs9laNitGsUlg9Otvy3PGOe6s2SeBWAZhzcYvLPbU
	nWxgXT42Qf6MHD4+6g7b5lqQ+9MLrWU1QUd8VvgpySW51v2LMifCI0FrVf/AJxUh
	RY9avsyTuEQ6vJav+PgDfK2l+lzVzOka0BkZqWlTiSKyZf30nLJcXU7JAG1N0RIN
	Nhs55Dxqlj7+9cfrSDcVc2kIt0DK8Nm/0nbOIMsTIsb/+3YkhbUrM5hpm9wR4VM8
	8YrvV9JPgZvKx4gtpx7P7Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1aede-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXUws036904;
	Fri, 3 Jul 2026 10:35:01 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011023.outbound.protection.outlook.com [52.101.62.23])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u20fu62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vpSDsyyUcrHX6wcwfThsZHKsfF7C7UB8vHqMf/s4NVyWz3KDcZNwx0GfomqtgmoMmkcbUtoDcnhW44dxUAcbI5BPq+cXntOaxiET/IXK0SmzpI69OVogAHEuM2f4INGy3hKVVOl/YOpAKT/EbNZ+HTqs6xbHOwaqfdoO00MzLQacPrK4FTw4s9MfPhLY+/Wt35ZYXSa0G0VoVwuEFNVfVjt4DxZUOvOvCDx65thFUC4E5C8fKY1VR6a4U8SZrRK7N26Pbx4vT3Qm8PdX0lWfiAoCWJbZmhBHDjlamZnGa2E/yCdtZry+M9EAK3jpoTboxuwBt5kuQvNlkkn4BgxTRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tatUw4ZEuhSrDTsfvaix4YExuT117AzgETaW6UTkBtQ=;
 b=QY1QQiECyxmyLHjWhTpqgCX0QoqMtO86uVsZXl/0XDtAnA3fsBglip1AKp60th3bC20EDtncvauEB9Tf+coB3RVW0IVn9L64byRu6nIo5NJLbSxM+NKyJ1jxJcnGvidtA+f0S2/61QcomKVvpOMOco6WMg3bQxVNvULMCfOl/poiSWn/a6vQA/Ojx1wfjKEHLddbFlSJq6u9yeuXAphLookQsPTUNdBpjoRP/wy4OaJqXAN4Pj5Dkjvfz1JQhJfeF6st/IQnDln31Q95WCm1FaJOLhx9mgJDNfqso+b0cp13hIO6Ao9Naf6CNox2p/fUo8lVcaCD7ncOd74sNLVOYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tatUw4ZEuhSrDTsfvaix4YExuT117AzgETaW6UTkBtQ=;
 b=DNb9/0ZdOEsq3cuE+Z/MMZRyAYnTbMI1gsfYgZnC6k5wxPObD7aQHFKIRFTWE5Q7drOinrTnMmlPAn7gNL0U5A3KLdiHWH4LGIFqX5k+GAOaU3MxburOwQPeXiDqPAU3XZdPgL2coJGKDx4D6th7Mxr+m5wonIsL++QO6ElU+xY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Fri, 3 Jul 2026 10:34:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 13/17] scsi: sd: support multipath disk
Date: Fri,  3 Jul 2026 10:33:58 +0000
Message-ID: <20260703103402.3725011-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:510:2da::28) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 427a4881-4db1-4048-28b9-08ded8eeba56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|5023799004|56012099006|20046099003|18002099003|22082099003|6133799003|10063799003;
X-Microsoft-Antispam-Message-Info:
	ZZpo6+aVE5Hoq7vaJUHZExzx0AQSRnsltWx3wAqXK1VxZzzaiJA+VqYq490qk9HEWzG577oYP3HbErr0fy7vmulilsBF98txREHxTKz0/D1eu8x3AyhWGVkmUeTrK/IivGwFuXUc8FoU1A9RH5Ddky65oltXABtuRTfkQkwn0xf6VZlrzybzilLKxQUDY2APdrkayvziA99/ZtUJL/rY+/oEfCkRwreYVERI7tjSXiprt/1PmaR+PMBa8VCI1t85nUiAnLb8pfGXtO9TmMakWLNJdZph/fGR6HRQ9e3/8V/dzbjCDle9JeOyL5eg+UiuUsXC6wFXAd6cJYIlw8qa5be9gxPMB9Elg/aE0enTJWkVpLWV+Hp7gXOs9ashTYg3JB50/7opgzb1JXU14FMgzbwiQPylEVOMd56vLqXx9LYI7VBzUWXa2ePu7jf86tDoHxUNwwc09Ebh2U4/Fsfr6DlObYeqUoask3/HcJyU4M+0gSf89xQIGkAwbDqH65947j6PcvCZ9DAUZXGoanzRf3gCFVrsl/BkOBLX/T2tu/Vz/PbYkbxqhB9q/NJWqVdrOZKkAxxPB91QO2zvtgSSStAR5ftZmpm0yQdwTKviJ7anKmkCQKyZqZ0jP7NJxW+ACA+nTiU4SqZOPWP0ZNu/YzPRa+9PgWiRb+wa1yNjbrY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(5023799004)(56012099006)(20046099003)(18002099003)(22082099003)(6133799003)(10063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KqbvGBm/st99sLomJKh5Ha8qFEaf4T5Fkk2n+dLKLVMbL3Qb687dRnXQIIH0?=
 =?us-ascii?Q?ZenXJ1vPrIDSz1Ew72SL4qxTW8hTEZMyuuqW12RDWD8UOi0fz5WLtJ6onbGJ?=
 =?us-ascii?Q?vy+cB8sCI8VIkd2/c3VV4EVoeDKsRkyWKF5YbVeBpWu+h7pkX6bWvHNJ11iT?=
 =?us-ascii?Q?1+gTjUY9RMh+GxqNZlrSLnwzB/4879xJ2RkdK5opYzchY6nknqdqtO8vSMvj?=
 =?us-ascii?Q?tiSDEEB+8ybCC3T7Gh0G08fK2ULGs1W/VjwAoHoEyhZbXIKK9Lp3sq8C1O5N?=
 =?us-ascii?Q?80Ab3ITz9AzJfASn2gq0mpHo+r6M5jwknowq2czkjphN1luNUV74p0b5OGOr?=
 =?us-ascii?Q?+8GWSjyyJf9PZXF+CcWK5BsHrME2lNbF4/nDE2VbDeKBhZSJT54EL7VhlWIO?=
 =?us-ascii?Q?CwN8stEVXGHAKbvWnG2dElxBunNmFEGgZYqan/OEtEVyyyXiRifYtvRgzSUH?=
 =?us-ascii?Q?oI6J6lIvroUWTDh5sLQy4gkYQPxdDFwrCeiwgrBDSKqapYpKxUOWdro+8YZ+?=
 =?us-ascii?Q?/SORD89YE8bHMBkUlcszEfSkFRZfxngWYBUeqb57Nx16D5t3nAYNHIrajfEw?=
 =?us-ascii?Q?aUxRNdd5QMidh3DgbPt8jNaYMQ/qlCveqD9c7Kwl+6tFmALZ4/TcvVcS+r6A?=
 =?us-ascii?Q?F1mZ4+amWxZU8ZQ1fbD8GZ2WnvvWLKwAScCvXDKzD0TxlSKSd85iDmVGYsTX?=
 =?us-ascii?Q?sxiwaskSzPWwkgov5XVgYaw0pXNm6HqAN0FCwAuJLkNBSVztXULFFpXr5Gnb?=
 =?us-ascii?Q?i+JGtAVoh/0sJHIlcpaDcV+YKWj3Ocf4KDm6Sg/U8Er1M7chEIAhiTHjpsMh?=
 =?us-ascii?Q?jLovTU2CU74ajZh4UmdNoot8nCquWUKWbgMZ1ukzboO037JawWbhKroddRTU?=
 =?us-ascii?Q?ZCVy+DQV7PsbCA5uyHK02tMKprgqvmBmZGNnXOTTypoHXaN0sJ4nMhItdlwB?=
 =?us-ascii?Q?NHm7ah6nEJdyAOVzC3JwKYVgevdzWzXss/KeGnvbVjfUcu9YJ2TQLLtGmy5N?=
 =?us-ascii?Q?KQP7Grlx12nN+l98blf2UwdrCSsJ78P15pA1xOTIjNbOOysg3jOVE/FMPP7x?=
 =?us-ascii?Q?N2QzgewC4g50GKcBBUUIEADnsi5WTG44/u36O1bDUrgmulNAihn0xCUplQDH?=
 =?us-ascii?Q?GwsW6AVOhhRLBdUHPF5kgtT1aENdIibdPPK+TjWgpc+ba8JPeoOyFpwxXQJZ?=
 =?us-ascii?Q?vub5cOTW1XYbza9P69L13FxosNLJceK0unwsl2fLkfLL/+FnKYLj1ECUIeWC?=
 =?us-ascii?Q?6yRXB++yPz+uc14U6hA8pTPix6VMCu5fzrDciLzvUIThsU+px+2U/W8k+JY3?=
 =?us-ascii?Q?feNSp8oeKCSjcKWgZtR7iG4IZ8waN/mg+62TMQbfuJ9znSUwnjvyk6HaBOQn?=
 =?us-ascii?Q?nsBjzlOU/ZjX3s7A9py+LIH2Onw1slSgCp4DgvaeTK4SS4EWd37k1cEyHW9O?=
 =?us-ascii?Q?uHu2WqydKwlFNsXzaeqotZQ2ltGbwbHh0/p8hAmqyvqYvYJB7dS9WEV7oJgQ?=
 =?us-ascii?Q?j/EKxk7Z0WyswGrKK0SAFONfNCZuR+4ldTpyEwLuXhuACSqZwDiwQRqzQ17x?=
 =?us-ascii?Q?StIzjxzCI/0sXI9Tz4QJbr2ptE/RQxAEn7Lp9MLC5qnVoKizEptdc2Af48Jc?=
 =?us-ascii?Q?FuJ0qZZy9cC8X3DARZcxJt2eJBlaJt6+ZAekr5Z8/SsEB5rF0icGVRy6q8zh?=
 =?us-ascii?Q?1Y+o+O8OeVR2aePr3E3+hf0xRnaqYPbxqLosDhOCHG5KFmH1ORxdhPTfZQht?=
 =?us-ascii?Q?tCqynpWgiHUwLGG/v49AeFuV+9Z7O2c=3D?=
X-Exchange-RoutingPolicyChecked:
	M8yKxLEhEqv0Yix+5Ped53UZ6EXwsdVuzw19DT/2to1vmo319if+AdqtHumF9MPrjBKsLnu5d2R7EFCZJRphryDEobn9zslZJ9r5q5RPXk+8lH/1x3gFMXgFO3A6ON3Y9hdcmF5AkkbH1i3a1xNl7jeaFjGH9cCTxyJM2ftFADL6Ne+UvYZfM3W4ILLnqPcY5XBuV41vBJodVVL62TOBTRwWV5QHRHHEq54u2EKvKwN/W1IPcYZMk/s5qz2L4Oga9d9kypbyvn0tPhuSINifinePbpIzaswrmHaF6M3xgpNWeOxwKaiW/ZRSf/exPo4+f0BzdSkl6/HRlhbG4npt/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7AIMsGTPNoKPvR74nObF3PmR8qGj0Wtvi+c39HacCwEdkro7FIs4YjI0j6uaJZGOSsO+9I9HuA9IInl1B9I6iiuCHENC0SHlwiy28Jbz2RWvdKup6DF6F6tYceSNJJl1QVg20eo57DvPbSUbuhKG1WGdZPhqT/cQERn0gdRmWvuX8Yg5AxFEDr77Q6+fNGvuvHMEpfY8VUnY++PLDbPzfC/8oqpOaWYqvSkaaBpnyEVxDzFL03ZFkrhLM8X3Pody+yCRMT0zNT8/5j6d9rxomHpRvBUfG+5pqqzl9CpJmki08JjCGRlAXqMzGkr3SITTHhcCli7tzZG42xiQv21VD1UEfJdcRVOGcQSmdRUif7HkGqFj1WlEClT0WVnks/c4L/5a9apDvCLd2AwxXwg8Y23OatxbAiuoCcn6RiLcEUWsgnCibRTpr9VuICXQ1cfrSJg83rzN2lQl1NY3hIkh7BdtLlq2Eec8kbvYBmwnp/NNEH0n4l2HmE9X1/w9lmvZG9VaMIhh7AdAxLq2SPVEkOrzIa2//TMIMpEY+HrSHO+T5zFFUMEqURJrgLVZ6Br1oO49J7/52exXms9DJPDrsE1LjLPJ9MtTmSRVIKzMFt0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427a4881-4db1-4048-28b9-08ded8eeba56
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:57.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VB0+SaxfYz5lUn+OXyjKmqZdeqlQayI42DB/97Ohkf1u68ynr2/rnhxWnRPyHsP15YCI2ztiunIZAzlTNmNQsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-GUID: JhZ-l6zvZrAVeWxjVx9SkfUC7C4ZA4Z1
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a479056 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=fl1--RqHDNO2UjKtE9IA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-ORIG-GUID: JhZ-l6zvZrAVeWxjVx9SkfUC7C4ZA4Z1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX7WYdG8EyfkAi
 Dlw9KKsLOMYgVMaA1wO+4TRMAN+j777mKa2AyjRrw9dRCV1Bdzlh42vPBEqdxw67lTNT67ItbdK
 R0hQu9Ag/+g1raF9Alt/6ibK7lolaaz55BzIaNlVeG4w0VBhWhxw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX7ImApkEk46WV
 m4t6ZxL/72vogwQd02sjP0ByDYYqPxhfHGyf9SV/N7X9wJGMu/HWOGS29JH7dYlw2r+Rvk7dtHR
 pWp3wirwVYwZThFK6nJ7rfCOW/TYVoF4imx09xXbZN52VpVA8xCgqxzOjUJrMjefB1Y/1gWUovx
 UewuTpdVFVdRJwwjRcmcUxQ8Wo7pzlXFyqaSbXFeV8f12ae8872LC5F9DGDXgIwMu988/TpDusV
 Zfhg2XG24XNXYDHipkJryFlvoiWPu0AiGzMTm1QJG2uSvhoPwvWzFU//TIAsSaS9gc86FIauUwZ
 fqF6bq1w5oGwTYCt0I+XPPImim4VNKcEADpK+w9sm9qWFAJ3ROm8cDjz+pcVoIoW0wKsdgXZFHp
 M6CxQMsCJii3zvRDvdE9Qe6BiGktAjxYysFazs6V0UitlKmpvRCa31qR9UbUpsgPdCfgNk2wjee
 Ins1+D040iXMU6/qkFYGj3P/SdEPTzgBY7QP3+uA=

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1


$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2


$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 395 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 377 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 242a15bc2c5bb..3df70b24b688e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
 	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	mpath_put_disk(mpath_head);
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -817,7 +835,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
@@ -4006,6 +4025,321 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(
+			struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+
+		if (sd_mpath_disk->scsi_mpath_head == scsi_mpath_head)
+			return sd_mpath_disk;
+
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static void sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head =
+				sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	mpath_add_device(mpath_device, mpath_head, sdkp->disk,
+		dev_to_node(sdp->host->dma_dev), &sdp->host->mpath_nr_active);
+	mpath_device_set_live(mpath_device);
+}
+
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	char disk_name[DISK_NAME_LEN - 2];
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (sd_mpath_disk) {
+		error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+		if (error < 0) {
+			/*
+			 * Should not happen as would fail for the same when
+			 * allocating the sd_mpath_disk
+			 */
+			sd_mpath_put_disk(sd_mpath_disk);
+			mutex_unlock(&sd_mpath_disks_lock);
+			return error;
+		}
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+	device_initialize(&sd_mpath_disk->dev);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	mpath_head->parent = &sd_mpath_disk->dev;
+	mpath_head->drv_module = THIS_MODULE;
+	error = mpath_alloc_head_disk(mpath_head, &lim,
+				dev_to_node(dma_dev));
+	if (error)
+		goto out_free_disk;
+	disk = mpath_head->disk;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+	if (error < 0)
+		goto out_free_index;
+
+	error = dev_set_name(&sd_mpath_disk->dev, "scsi_mpath_disk%d",
+				scsi_mpath_head->index);
+	if (error)
+		goto out_free_index;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		disk_name, scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(mpath_head);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_device);
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_remove_sysfs_link(mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *dev = &scsi_mpath_head->dev;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk) {
+		dev_warn(dev, "could not find mpath disk\n");
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	list_del_init(&sd_mpath_disk->entry);
+	mutex_unlock(&sd_mpath_disks_lock);
+
+	device_del(&sd_mpath_disk->dev);
+	mpath_remove_disk(mpath_head);
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_head *scsi_mpath_head;
+	struct mpath_head *mpath_head;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	mpath_head = &scsi_mpath_head->mpath_head;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+}
+#endif
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4058,22 +4392,33 @@ static int sd_probe(struct scsi_device *sdp)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4093,6 +4438,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
@@ -4100,10 +4446,6 @@ static int sd_probe(struct scsi_device *sdp)
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4127,6 +4469,12 @@ static int sd_probe(struct scsi_device *sdp)
 		}
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4141,6 +4489,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		if (sdp->sector_size > PAGE_SIZE)
@@ -4148,6 +4497,9 @@ static int sd_probe(struct scsi_device *sdp)
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_add_disk(sdkp);
+
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4161,7 +4513,8 @@ static int sd_probe(struct scsi_device *sdp)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4289,6 +4642,9 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
+
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->disk_dev);
@@ -4457,6 +4813,9 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+	#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_remove_head	= sd_mpath_remove_head,
+	#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
-- 
2.43.7

