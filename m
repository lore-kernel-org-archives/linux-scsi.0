Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC6C1448E0;
	Wed, 21 May 2025 01:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747790930; cv=fail; b=Xp1P/Y4FOJ8OcVTYJfOVRXpli3oCnH6+Y53yWl3tc6ZHeBg3jJmbQqTMZvOuqqypN5jILe9jeKtKdbTStKO+Qz77BN5ynum+rqeEpb0FGNgWr68QylmGachX3cCpKf1hsHbGNMcnlB1XTbshMPDv8kC46Kbsnom5lzhBd0Ss0Y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747790930; c=relaxed/simple;
	bh=3miu/2TeLpeU5RB8ezhr3f28YIF/bhd+mNGtSpQcQvs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sAyH9jMUm/vzXpLl3qBn3vJYQN+oyKHQx1YGYQ+6v3oPSyFs9CNujT1kBCp/27BB1DURQOTaqCN1M5jb98HhnH62212JCMS2UYiFFr4YE7v4VNKznLJ6Q1mo6ORQzxBqK6yJz9TGSuaLEroCqDlVsS/xdtFf/Xud1QoDTxGZV7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SshstGiQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vGMyEUEr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SshstGiQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vGMyEUEr"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L0gYJm006192;
	Wed, 21 May 2025 01:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qiuovh8rvfuQuhphF0
	XtUoUWnw/k74SsWz47pZlNdRw=; b=SshstGiQmA5TtuZD5czcfNijdfW/1q6umW
	lTP8TnXTwPMIz4zCorEnwCYl6FLinDm519FDHf33BpvQsAQldZ2qcMb2v9L873oY
	Er+GksCjtHEp41hlYDo5ArsxibC2l5Dr6j3pAosCbW353pGAfX8Tj8Yz4Ze3G9kM
	sLQqwAJq6rz28jSe1SnfU+tTqnJJBl3AJHx01BX1C5cHz93NSW9mAQMQ6I5YbeA0
	MwnfsriYppMDWENXKTKZf1zlFIBrBIyKAENkJ08BGWd+wVI2k7wTn6orRDjIAIVt
	hb8vQ/KPLtVD6/2UyBn49hPPZUiR4/usBQ3vln+QFy7GYUKLNHtw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s4h102r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:28:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1A2CV033067;
	Wed, 21 May 2025 01:28:42 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46rwemr6ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:28:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PVH4WWmIGM7VQwjOE0UIf2k9G4s31rEH9OLXzmPipWQZblwJ62knq1X1coxzsU8MtHgL8DZ8HjYDmV2Xtxx1VdHYUMhIrzDCsGeovdvgycWo12fuqfFY1LDzII5fLM1Hiy/WaCfSfSnIWbn9y50PsdX7loNtZfGNhR9I7iXVS+M5lx7ShO5qMHJdmCxVRxHl0MGurxEzh0pM1chPy4sk9uwfnlCP+nhiD0vae1+DaqFsNd9KI4YPj+E9A3XFwVNUoOLFS44ip3arh2oLWJyR4gDkXna2U1cNNiAFdTM40U81zGRktn5dplTiAdeAhuqeA0l5PaEQV/oGMztZ0aaV9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiuovh8rvfuQuhphF0XtUoUWnw/k74SsWz47pZlNdRw=;
 b=gt2J0mq9M8+ed/yzBgcocXVDO9I41LNCM3HUm9JzATXKMeVsEyE3il24rVCFs/LPlIdTQsCztTk2MLmP/q0j6Ik8CRfl6EDhTdAIzivx0DxCLDN/kZBRVhio0TlULv/5K+XfR5fsnKGqeg6BDkgiJjUW9QFNm/Z29GStHyJV8h3xp1eYCvMZpiDC3pg4kCw3FT2VgFNYbIsmvwYpW1oZN0lRIKZ+lMx6yd5eovPq/hEkJ5CLWvWr+LzJh3juPHeyXxZMoPofjZYEJTK5fRSHJoz6L/nAWpLd/1LZdhCp3V/rsoS6SaLuQ9rqeMa4Xq6HoMj7egBnPjRCt9wDs+o8nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiuovh8rvfuQuhphF0XtUoUWnw/k74SsWz47pZlNdRw=;
 b=vGMyEUEr4OnA5BSRGznUWYOaxgpc7UjbVNrz2XJUrqAMe0fttht6XazwecObLR5qMheAW1cGAmUf+gJBm6SIBpuHGP3JwyQNullZS78d3B0XovALqy0ViVmqs1uU1xHvl9BMr7MHEKmtjTDpTd3yNwF/h+vOaAP4qoDEUMEB2sg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PR10MB7945.namprd10.prod.outlook.com (2603:10b6:0:47::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 01:28:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 01:28:39 +0000
To: Chen Ni <nichen@iscas.ac.cn>
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Replace memset with eth_zero_addr
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250519085457.918720-1-nichen@iscas.ac.cn> (Chen Ni's message
	of "Mon, 19 May 2025 16:54:57 +0800")
Organization: Oracle Corporation
Message-ID: <yq1a576n45g.fsf@ca-mkp.ca.oracle.com>
References: <20250519085457.918720-1-nichen@iscas.ac.cn>
Date: Tue, 20 May 2025 21:28:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:208:32b::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PR10MB7945:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e21b2d3-5ef4-42b1-6567-08dd9806d04b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iTf3pgaTe1gVGQLbYP0LFYGGrsnzwjAktv0ny762E18keG0u34W6on2tsZt4?=
 =?us-ascii?Q?We8Altmyu26rl3yWMPs5zBcyVI/TZpMpXHMKf7lhzHUPhV96dxCK/gr7tWBX?=
 =?us-ascii?Q?0F1nnbtpPvBpYedYqQ379v8UhUM9VbLgQTsfhUWX1mfi6Jl3HGQnoJrdSmPH?=
 =?us-ascii?Q?euKApjZ578C0ZCOVSbhr05jY8+SJmLQ87vI6k5ucpe1sjAowfN+iJgvA/hqD?=
 =?us-ascii?Q?d66/YYl9z9lubGFiITARjb1zjyE5ce07oGTxhPRDAshDsIiKPqzyROmigA6s?=
 =?us-ascii?Q?28PuqgFhNoRi7AgFyD+ej/p28YSTRYR2aqxUe04z81jRmkU2LY6Yu1sTJMp1?=
 =?us-ascii?Q?YHhRVsnKf6Y4jSuXHbxLDpx3pwPSgGDADiLC1QJX01S2r0mefv4dwPiils1n?=
 =?us-ascii?Q?nI3SSQ/jZnRvcnvTuMeTc3eQBj8QMRoc57GCUHJwdBdzYokp/sfBkOv0qGe+?=
 =?us-ascii?Q?C61uUKkw0wMvqp0p+i5r6ZWWR8rR9HWF/+e/+z7UDXYbsrPgW/4BxJ1KzB7G?=
 =?us-ascii?Q?OGcUO1WNUScJbHv8UR2CJSL3WxOQalGd+qavmi8a/QzIIu4ZiKq0XYFQMmi6?=
 =?us-ascii?Q?i70JMQClOfzOrE+Z3Mjc0kjLiy/MipiBMbxEfhXL4JKYQx+ZwJf4hwPiPDUo?=
 =?us-ascii?Q?qowIBW7XMyxHAguZ0oFLLCPYm1dxgysrOxW5ae7a35CVYr6FnKvQgsSv8/iM?=
 =?us-ascii?Q?ogH3y/P0obbOGAVxRY6SEORKiMA8KSURPV7EFwenKxSiilVVVKznpBWlnNDg?=
 =?us-ascii?Q?4nVq927NzcFMzjmJd/WdF6AtSnxgU9swPoRX2wyD96H3/C/VFNysPWdkiSva?=
 =?us-ascii?Q?dcnIYIScwNp/F8tklLucn/Kv341wJP6me+MK+icv+rhfxeh9ioKec3SJI5Zg?=
 =?us-ascii?Q?ZNoqtZAnBj0JKz1gXZQOBKbC7dWXj5TyYkevutKKwhR+TZR7DVozl2bfeYzU?=
 =?us-ascii?Q?KrOGSbAEDhbNULRXJ3IWGwicpHTBqiZ7IECf/z+hBuPwpr2fU2mUYacN77aH?=
 =?us-ascii?Q?ImLPXagdScNQMUTc3OwG7jx3NyUOxhLaD83TPPrnfS4VvrmM+h0xGb81PwpG?=
 =?us-ascii?Q?hNEIwnfzlWg9iKc/CHrpC326oUDqG3O5o/tmMdfBhEnplvMxM8W9fp87t1kU?=
 =?us-ascii?Q?85gjWmhxOGjBsizU8Bd4tm04fY6qJvKwX/+PFdjvZemDBLt3YKt1W/0ewSd+?=
 =?us-ascii?Q?5b+hnd++s+An2421hZEJpAxp3VonXaGt7WoKRxrVE/dUm2/SZrbuvyNk1Ce2?=
 =?us-ascii?Q?oqm2DMt+KZ8TdzvsJcwkliGnMdrRgRjKQERNbbTO5FcRhqe030wsqe1zhLI4?=
 =?us-ascii?Q?lS3Hx61x5Jcn8QGyY/l5n9PmjjzMx2hzg5aMfj3AfFqrr2RD2ze8+SHCs5HP?=
 =?us-ascii?Q?jxVB7AgTHDfLaVSyZFlwPD/lW1Y0TpIIQ6zxFnoM3zoQ8bTCcsmbUsyhUAFJ?=
 =?us-ascii?Q?16/08ILF2ME=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FXnSKkWHDcNy/eEVedIJ3CAC+i2H2Lf/6BoOftvJUO947uvGxw/MTIK7Gs3l?=
 =?us-ascii?Q?kXBjXgsHKvU5G6Uxg991QcjkOgUtzlRqeBAl2j0rR5zbCiLh64r26923HYSw?=
 =?us-ascii?Q?WpfwK6Tx6jh/FEB5zkCL0wVIpxWPVVTCvICwwWOiuNGoX/iEf2e5eM0kYFgt?=
 =?us-ascii?Q?+wDY0m5R561BU5l2tJ0AYfJpsYszcHZ6KuJjMcFkjPdrplFzdT7ex1RDljQ0?=
 =?us-ascii?Q?gURvtfEMz+CzZhImWLYoXwfQiALAtvp2zS1Wvv7xtMnl/NoSmARpY1F+Mg9/?=
 =?us-ascii?Q?DlSVxzzWZauBz2pYeNK/ccTPUvlT64OMympvsY/8qlX4U4ByM/SyBt2ykpXU?=
 =?us-ascii?Q?s1+OgIpk99jlBiW2yU4aKftJEJJLc2MJgGUrzw1S7kXEaExi97M8Yq/6hEky?=
 =?us-ascii?Q?tf0lozb/ViZUKQIICgIg4DhmshKW35T0AytabDjfvavqw1NMIwjRoa+948yT?=
 =?us-ascii?Q?/XaZicRyyeo0t9ZvJTBV7eJYCqc+2sN6XDqdz32V70Jw9olbQ5pA1HSIWU4t?=
 =?us-ascii?Q?npd1a9dRbBsMGK2pRxc6qEFvTSyLTy80jVp5pK82HVfqxja6vnlrtxOz877q?=
 =?us-ascii?Q?w55AWGftSoPg2ulRrBXwQpsk2eVGk0lsJZe5nNipIFyv1G/0RpINIrWM19C6?=
 =?us-ascii?Q?VJ8Kb7nHtuqPG5ptftDHJgUHajdAWRQ66HJHxJMnD3kC2ePhtsGdiF0POMmD?=
 =?us-ascii?Q?NTkZbE5jfca3mbuA/g4MOw4BA+QTuqTS84nnvD0hxpUUSuzTgg46ywKuYlU0?=
 =?us-ascii?Q?IenMwvmxNzCISOy2clZU+Xw/OBAU5uNnFNDIWVQnhVdEbXVLNBgVC7yttcla?=
 =?us-ascii?Q?r5vVMTOrUJGyFmjcO2rrMiHbov4fxl4Nc71+IV8D0nHR9cFJhFELIuO53YVE?=
 =?us-ascii?Q?cEpviFQ8w3tZNBreGNsalR4zy18iooUkHoti5iyAvaP94oJskfN+4hu1or4n?=
 =?us-ascii?Q?D3We6qT2IQ+oG2fTEpX/vKio6xwc4YhH0WXOhxtHKx5bUxlhTrFFTCIeCGEI?=
 =?us-ascii?Q?pE48n5AHFbA9Fy7aHvgrfawwLdmnF+5/hMHDypXK04wv2hknuHiaFrKAWsuJ?=
 =?us-ascii?Q?Aqz19j3kFPtLKZLGuVCg0FLpIomCjigSmE5aN13a79R8tQS9AGBgzN3WpfIS?=
 =?us-ascii?Q?uv8c6sEwqPjosC/MB7X6jB5yD+AOOaU4hqYVXGvsbXn/mtBcZ/FPtgqNoD4q?=
 =?us-ascii?Q?kO5cIZ2RRTh3ZYc0uqP0zHPOcWEPfKjUbzFM2KeRe8x5zZJ2qkNTLUHG/CHZ?=
 =?us-ascii?Q?lIe0WXJK9khavs7YU47voGYCAMJo8snxMwLMkC0SDWfv4rJ9UpXB3CTXHJ2x?=
 =?us-ascii?Q?mUARXFeZuVixHtF61oOEw/59MZip3MBBE1wjTZ2LHWjosCZz6HniTaQADm/4?=
 =?us-ascii?Q?IhAyK90HyYNo491aMwyNi4t+7FaEh4b09ZrUuXqk9AvyBo0Y+WtM/YS7Jn6N?=
 =?us-ascii?Q?eVKTAz4jOgi/syXT/EuczHR765KEsRsX/dRVSWCZ6qEu1CzlP6wpoY32tjfP?=
 =?us-ascii?Q?hf7bt/QlLq2zSU9RfmIiVtJBbnybgotDvps5S27Hg6yXhyS22RIEvUBH1ubE?=
 =?us-ascii?Q?G/nav8Xa4G+fYbyPaxiRXgLdxjvuxvgIQ7uKLT1ATnwD3WOa2y5Anhr2i6BT?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C8fLHdT/5uJ52JSwSAZnRPbDrsGgyfQbc4A7EMeAu+MW7lkmI7m21ysFnnNtKS/kTgEDO57Hfp3owu3oh3HpJK28aFZiHwb+3jQB6pCpVrkokKHujdMAJFd6Zzw+xSc6dU+CUbni28mB957FlRP96ogAJ6FF7neFWDvADaTYTLqH4p7qSHqJDRQRqSWVelBGlW+ZwkSm1aV55n/Xiep813nFU8z5DDiHrGfAZIXMc/d+tZ0n3fgNDsJUakaU4fnAwWYce9NCiSBhX6tDFX4dd8dCCdwnf0rG1EohlMaqjkCNYwNApiqnH3BKM+9hu+6+qqdHHPTBDABJDquRlQQxCUo5aQa+TAynWboGCx7pkN6CVQ2LPeq4LqLqkRUvg88rQZsDeB7hw265RaE+gdFjvatSv4YSVIXWY12u2eVBgvH9aEyA/maG+JTcqXqVI/zm7CmzRTQnmHaxCVULwWZ+9hPpQ7mSsOB7PlxoZvo9xvBg0AJAYSb/iA6hHYqqXBGrvUiGivglJQK4bvArOJkleyM2hGXOetXpAsAF/LrS+V6hR4fTauyvUhwT0phoDuTW/mgmtWyGPnNIGEiJH1dyzjaVYjyrJgeOdj8j4vLrBMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e21b2d3-5ef4-42b1-6567-08dd9806d04b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 01:28:39.0345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfuFmNNVpHZa+jYUDhpn8DqLSKPF7vcPnxyHYDXq1zZevNa5CT9WGFMK4pSFNaMoc8l4BGx0hrqGS0Q+9vr/0SV8wC+v1XRqCz18mA8AdAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=616
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210013
X-Proofpoint-ORIG-GUID: EjE_VbJZRnt6ru3rmxYW_NpLXR9QdkU5
X-Authority-Analysis: v=2.4 cv=d/b1yQjE c=1 sm=1 tr=0 ts=682d2c4b b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-GUID: EjE_VbJZRnt6ru3rmxYW_NpLXR9QdkU5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxMyBTYWx0ZWRfX9dCWUuSS9T+N SZH5IiGvy8ajC6GkVyeZecsOEntFiO2uZCZVBZnSFSs2weaJvkHvbsiFOslgrf66eyTeF7gij2m cJKrTPm6Iks9FTcG1tba1ggf5a0YY/BGp0D+shpqLJ8h6G5jrie/exld/4SSUKXXiWpqth7ZCM2
 lv1Ud6zN5UbZHg7V0vv6YBU3sOszEELC9209bWKn7qtDfd1DffIVSXaCIaBM6lFu8KuETv30yLX R6YVfaZxYMJyx+C7pLTxdneBRqOzi2qtat5q1DzniJ1CyuPvu8G6u6rqnSDY0ZiKoKQ8SJBv0a1 6OB4d4n98wr1dCXrZ/VgE3ht7HDojJMofbR5nUFVfCfZG9Zwwdx0/r4pnnLNf/BHaZgEE42UBA9
 9c4rifMKBDJPbvfnOlcpNbybBBCWjBCHEmDkOgG+SudekJ3l0LTSYPz9kojO+kTZg5JJKp6Z


Chen,

> Use eth_zero_addr to assign the zero address to the given address
> array instead of memset when second argument is address of zero.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
