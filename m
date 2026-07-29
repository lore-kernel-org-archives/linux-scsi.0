Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9733466B65;
	Wed, 29 Jul 2026 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322391; cv=fail; b=CMT9YyptkRha2ATp10Dg/lFLAa9vuQCogtaTE67qeT5Fxpp8sd6NYK6J/zY3w5AVKdBOnGlnCyz1Z48fqCEu2nxhHlnwsBV3pxvT/V7BBQMYhj7jmx/G3Vrkxl8qMgSN0H6+jS++57zWXko1b00UI3zCwonTNsPtTZis7lMI7vs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322391; c=relaxed/simple;
	bh=tpNDl4SQWxF63/A7+QlX/wlI02oXYhfFVM8bXp5BelU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DXdfi2hMb3te2zwqGd59DyDZgM1XxPjK8BGLFaRWhCTPeZHxf6QfjNnqJUvsPqjQ02TwbNHEYLU/BL/YItqruO1Q5OiYI/C/K5Xw9upp8Lndwpqlw1yhdpDIfJeqepessvb5/+v4hHFfCXWgIpFliNWlkfW3IT58CzSR8yzWVkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bDKxGLVO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XntrqoSQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bDKxGLVO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XntrqoSQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T98oAU1120940;
	Wed, 29 Jul 2026 10:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=H8o0BgEDI/vNlZOJQK1j90w59sigH4IsGi0pXuEcTBg=; b=
	bDKxGLVOaDN9/Q15ajA7WJcEeDZqKGFPhF8G8ssjjnAkhF1e9PJMPKriZVPNvMYn
	rQaq+i0HPNIy1BWgMjQGcJlD0vvoN4OSa/XbyQhI3YSL6tIrbID0cG9zqdVBxKaa
	B04podgmo/rT5mSBfJcZp/dSnTfIROfDybBdsFEEIWjqLbjDo6uoZrTufbbk+wlz
	Qs1lVkuTNb0gpbNML20YDXsy4fkM9ye4WzHCi+1bN37lfHmlBv3xl8CrfOVQeN93
	7JmWPEJDCUBiP9Wl/mrd20Oje7ys2Fe6gS75uEx3cR1o7Mpwltgc1+YaA7BD1769
	tOSFFY2HSd7Pvs1zJAOlOw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nnmjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo66d029952;
	Wed, 29 Jul 2026 10:52:32 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011055.outbound.protection.outlook.com [52.101.62.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh882ksc-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfzv/2cIOmk/767DJQ7ezTOWVVDu+fY+PiGmlXmpRZZmSef3AQ+uofRu8eVcNEyeOuK+Ytzze5NrP4lZajBKGFpS4llk7Oh/tTCMPoPHx03vfuiwP4AZ6UUpW5seXfVH3R0FXmXwF9x2ybEcxsP/9k6UuD0kKu+XaGbcsUWwfigwtv3+oRtQ7e3Sw/IH7DT6LiudpmJ9tprUEn23Um3+8Jsi63WNK1DVZTJP+DPoCngw/06/KD4jrRmWUMVXp1bX/NQLej6R/yIWiObv6U9kRwG53lxTecsh2gXv4iv8ne6huBUT1qdU+OAMjv6EPwRXeHTQobGFivvuoGrqtDmRDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8o0BgEDI/vNlZOJQK1j90w59sigH4IsGi0pXuEcTBg=;
 b=J4Q0AphAcW1opkjIZmwXdvmxmEeqYQ7WJ7PEwvqB9nnjKmPW8T+CaFVrOeBjXpeSOp0sB0yniRJeuebVO89Sl9JX87tFJ9Vf76TcSDILW+MJQs0d7AF0/Q2TdVXr4A7l71O3vV5lyUQBt5iI2sRdxB6yKGC4fmjN8r2066OJB3qtFw+kyd9DOuNz4dOUrJy8HpgQQ2qIZd2fGt5zQdM4Qf0SBU1asIlGimwxb0In66JcKC8119d0Z4SBGe7VvcX+/mAM/93ARELWZGaA6vm6pGggl25hH8aePxeWUWbNDk9jh9siZDfJ83L+VcF/d9DiBh8w6jtIKn/nCvT9QEa2IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8o0BgEDI/vNlZOJQK1j90w59sigH4IsGi0pXuEcTBg=;
 b=XntrqoSQysHWblN0XrwDnPmybjEtzSFsSA6e/Rrv2jgS8+mq/xfVD5m6t0Doh/C/zJ974sczmSMf8pG8g0FlJ+yjsN3y8A2Q0vu79tVm3DdHZYmVARTpfw9C2pVKKaPdM/QleDDtDujmg7//0F5Ug+gSXETY3aTI9I2PxHfr7hQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:28 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 26/27] scsi: sd: add mpath_numa_nodes dev attribute
Date: Wed, 29 Jul 2026 10:51:06 +0000
Message-ID: <20260729105107.255712-27-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::30) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9f1834-f77a-4366-4aa4-08deed5f7b6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yoDmfHcw4qy6mSS/qgD474dRzIdeupVIWlomOn1tkn1vwVtsT2AT3AhnYqR8YuHuFrx2LKkTNHzjr988UzYC9Nn1Bb/8neoqk4fcI2mr2vBZIXcm9aNDLzj/wsM3qSfok8NFmNaXJsVsSCP9n4u3uKquWEluqQjwOXkSih7pWhua3c9psXHdAQf2iSfPlQDYtj9ZouRpeFy5eZIBC6rrw1Tlw9KnmlMWw1w4j82WblK6NmS1WAE04hkg3rN/rOg6r5eGmGMGS0IYbj2Oe8h9N0ZGsxcIO5f6RxIB0hJi61xz2D2tQYk0eDjKlkX+s98pAUF9SUPYFBzb3t6VNBUlTqXRSt12v/IlvJ52T3AN0pl6GTGV+ckyBhKC3+DdCGQSEq47I1oC9ALfCJnG7g/5Uow2nRgzkHnZMroyfqaTBgok3Uf7Vht0npgiK7GdCu60Z+Se4Clu9Pmbm9v6oE9n3uavMLDfVuSEKI/0CrQh3Sl4B2PyLNV+L8272JS/hcpLbtqPBEKwAeH7Iig3y/BOiAcc7wy+2dS8q86nJuScytXmzYVqEa37c/YwrIVXlX0BW3NTL4cuG//sLUMUbwtOY8h/fK0bQbbttRevOlfu8wAFM+2485/ml0Vq8ZzAyxBJIbdI+QxZqZXzaHXQvZ8sfCCgWS1N2RNei+HtDMjxPBk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iIpw/y8ymjmsYrHDqlKiVA5cpQbGQaj9CtHtyqRhRlqze2dC15NRcHrLJ1u8?=
 =?us-ascii?Q?49Oj0QYSoPCy33I0UzhEfIPYS+e391n1dmi3aMuG95Jts1fWJhdTVO0PbYAk?=
 =?us-ascii?Q?EqfpUXoDve3arOzcaEmM2FD/KoQ4pHWaj2wycCyDIMpVUb/XwpsB58kTvJYx?=
 =?us-ascii?Q?GWyYhfiAXTSy+EF192VhPjxeJvbDOyJ8CP2fHn5X5HrG+KuvkRzrJWs6gstz?=
 =?us-ascii?Q?za0VOQ0OkZfPN2B255c67ItfcLdgRH0qyvJUwGQZFnTj19wgjdHdQ9B848Jn?=
 =?us-ascii?Q?btgz47/LUuAfx4tcrdjfqBu7mxd/ioO2eeZFUg0iUjIxkqBpOPR1oiLZKIJy?=
 =?us-ascii?Q?5rmdOm/Y1wBJ2juiniI3f6YIiizeKWg9nBI/oixnOUJEbTRZQ8kkB6CvxNLT?=
 =?us-ascii?Q?LMCGlGGkPNN1Eg2aYliyFp0wA+Rn54lWzWm6XPxH/awlTw5JwGxIMzTi7GoJ?=
 =?us-ascii?Q?pcbEl+Gj63pl841seg6UJXUFltvmDqb2hEABAhGcve4D1/c2tF1InKneb2qr?=
 =?us-ascii?Q?c1mpMjPUL3GQdUz8CTGQt2jiAaPSoj4hTLHcaTYyzLpB9H90YvNEzUj8jKoY?=
 =?us-ascii?Q?7xUUtju91AjhSmZ3NyiJtqgfnZTuKboXdjmIcaeuZtshOU3+wzGVq/YA7lL9?=
 =?us-ascii?Q?N7mfYO+pB7K0DuhSdor2ylxWlyLa6QpUZa9eug2FDGWwfCBHL06gNoGXy95c?=
 =?us-ascii?Q?MPHK4DNcrYBrTIfHR67QxFz9eYPgEaYhJLqlLlQmeGWVn8YpkmRYOnfxjmOJ?=
 =?us-ascii?Q?cJ075ydXD/6w3jkkxbP+3w8RkKglWTT7N28e+4mfIyvLvbOpe3AMwFFur0iD?=
 =?us-ascii?Q?lvKaSjdJ4Ez97ifazsp0S7LfxPpSlfe94N/AJbk/wKGp1i8w+BpKOP/Vvpsm?=
 =?us-ascii?Q?jm2XdZMoKfKJdUJUX/X6gLWhcUkNSo001tBdpSVb4s5NwjA/wutE8ulGYfnf?=
 =?us-ascii?Q?NNgzyS23GPF3Kj4Z1yY30G7606MIzT+eegMKmU8OzoHs9ro9BIqD9ctshvd/?=
 =?us-ascii?Q?PzVvTbHKoAibKEiYUNmHLiPrYXPl38v9yI/wYO5uftxoxYNDEronYZpG8oD7?=
 =?us-ascii?Q?MxdMnhN2L1y4c0Bbax1HYPVrss+BnppWC5e7372oFja8iGgIdCF9E5xYE8iG?=
 =?us-ascii?Q?cixy94rQWEE7I9cUHGoUu8vxrW6fEGAwt1YjutQJ1j7+79Klfenmujo85NHc?=
 =?us-ascii?Q?LX47r8WNS/WxEvKoxXk0pV+XHw0y76/J7R+X0sKKnVGRNcxdU0zS1Gv6AL75?=
 =?us-ascii?Q?4brCGX84LDOEdZY4zRaADwA3xUu0NoQV11iCJXjBSEO7nD+DqVvsy5snNay+?=
 =?us-ascii?Q?l0kxYbKDxF3LdHCkOhMFv5M3tRgR8GZpnTDo2LKuF2IQunLIxD8HMOq5/yfk?=
 =?us-ascii?Q?8UapRbmhL0A1JhWHJxfotsvti7JUjnL0WZBE5gJxAHpZJKjQEL8s1Sm4dHbg?=
 =?us-ascii?Q?62ThzGQywhidajkvgXqh5qTJ3hw7qUR5o1FQ+yHrEZNZwbtfTfRoKr9+V0XM?=
 =?us-ascii?Q?hfL+nAee08Wb/IaInp5B64PvPIsSbixm2RGAcO6Umra3sEPkvmFgL6iFUJ6j?=
 =?us-ascii?Q?v/RFhsxTh1NrEE3uP1BF2uh/ioKLkz0/J3IN0O90fBLhVq6LtlTlQkpNv8rV?=
 =?us-ascii?Q?6rwOwfyDi+eH3ElO66S7ixiF4sJnjm1hnDSPvDo66kbOiVYQDNU+Pzaf5BJv?=
 =?us-ascii?Q?TROAdQpXpCRU9pLljihXuUVni/twM6+0cHc6+8/iDlCLN8aZeN4lkmfMdBxf?=
 =?us-ascii?Q?t3NcmtzW7g=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	glP7sIQSocdxnAhYcuMBmEnWrO6Gf/Momer2YJl8S6f8P1xIjsKDmBJLBlBxyqCcvgDN/lCL0VsrTLI3Tb9Q58xSrbMKc/oeQ4T0J4sj9IVxCWtAAR8AksZC9xTzEQlgT7jb9IZgT93sw3EijPLLfbZTZ3p1umQXYlV9ZGiq6LthsxxD/dXawza12ge57990zn4gSNThCKSXF6xsumYeHDvNtkai3KrWZrD7hojMJDAR6OENAx4Bpd22kCNHcSLznK57Nai5Mnk0YpHLn5k+PbfJNxsqB+fbSahDnGYm8Hf/KZpqvqQXcbHiXCMzTc3vZJN28ova4E3PSgHg1Y35Eg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B3iccPWIiweKMehB8OgbcNF3AlEWGGnQNSoh+XAWs56J00cKbtiE5x6tc4xnwZO97zvWaxnKI7zrAJq0oT8msK5OVI+QJz3GUr/rD9LtvSpy00/zEGEQThr5fV7G7M0Mv6Z7l7gDK6By4y3Mh3f7R3rUnI25VsF6YFwTyCQl6/hNh/Q1R0DdvB/P76HK1IF1AAhjzIifBXnvAKY3GL06Kgy2lqd9OcgwefkKa4H/Olw7l+j7/G2YXGPC2XIuApSC1Bs6x4GLtUpOeGU4GetwYhN0q2Mbq3RlGFeLDszHuQgOLYs++LG6whdPs2cFYm/MPfcNPLsddv0iCTRaReuq/eLEhY0qObz290FzOhw7IuKFcqwGl/U9V2CSwChMtL/4VQK2IobiWUSQl2NiWLkeZRq+iqg1HkV9ABtLPq5O1KjvPqUoLQdVxsf0bznBcpyVsvmKcFnGKAgbZySuysWONLbVG0MJD0LtoOkxu+Cm8y5MQeaTKgoN05dQTtzKzJMfq9m4yX0C9tR/4V1AXzl4iuPOgtBLaiGMX9M6+tgMxBbbBO5ek55pHREKRmCgHw8CjboyU7FvJItLGHA9xTNMQFM71XOO+ivAv3e6tQFC190=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9f1834-f77a-4366-4aa4-08deed5f7b6d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:28.3374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGn0q9P4AMUnCkKwc5NN0EaL7ueyVoAeCoDJCiRshwNEtXwW1AicX0IGDheITCClS/NjPr113kxpmeky2PCAMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a69db71 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=P2_R26dytZ8aPJic-48A:9
X-Proofpoint-ORIG-GUID: NKVYPFMZcUCQLERMSB0Es-V-Yi0HJT-u
X-Proofpoint-GUID: NKVYPFMZcUCQLERMSB0Es-V-Yi0HJT-u
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfXw6pzAESLLnYl
 In/fvlLCyJaMxqDVxevqfhQskb28n2EvIS4bCm43LPwsbn24M3tluL5hefXM+WmMQs/5mtV9yAa
 BlxgdehrPm6fCuwSa5w24+EoaGvaX1ZHdDVfNQMgWVMl2PkubTxL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX8VKtt6LEfoJB
 q3G2yUj3nzcuMAxPGyOBh8zLoyNO4bZu+PYK2PgNOFbUN3sI5uH5uH+KCsWvqxB3nK23ueGxe1+
 jnR2cQRCU2Skd4U9rnsGZ8PEHHV75pIbsc5w4RxwqpyavjGRrgt2JASy1Atq0c4JFCFNn8qjLP4
 YY3BPYFn+0hRPF8f+wDpYMwMOEhgDG28vTwPc3LI72YG7kPQy+uhz8M8U8N6BjVgWlxjCI4jh1x
 VYKge6LvrvoyQRD6nEjd86u8rJjAHG/0yHc+MBf00eRkI+p2UjqtAm2lTR1Lmvw13TPVsA1XVPQ
 j2CJ0mM0v75UvTNIAI/Spox9mFog4oDRozuk3d4Zk1/IGPN/YbJCONNCj3uIp71SyaK1ITu27r8
 3nkhxZFHxp3qz+tlmn3gf4xTUV+Jnk202eXNkc5nDJn13qQOIr5Fjq8qwgRQhA9JzH6ebngt1zd
 pcw+YtU4MIODgZG80Ig==

From: John Garry <john.garry@linux.dev>

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb1bf4174248b..e63a42bc3d134 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4150,8 +4150,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.7

