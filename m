Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC6240DB49;
	Mon, 27 Jul 2026 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163430; cv=fail; b=JgYSgUEFzCK45zq9nxBGa/ya5kDY2Cz/MTPQTH51VJ92nGVDhlptaAi8qpKOLqpyBfpuWT5C8LDFniOpPU9tF8R37Nb8MlpRLqsuzkXGdoL9tsYCSqS1Vs6gAE4Ru6KWf9N2edR5y35vNS4qUXw8FZcIDB1opgFnyzwtMCBBucY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163430; c=relaxed/simple;
	bh=Ve+4xQaM7I9om6cr8bZucTZRVom0DQqx20pLTbC85nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rB49jeV6+l2j6zpujbTCjt3qpl0B9JnS7w6wUthofsHpgZNIMgShwuyJ/pbDL1C+rHE6kFFvZQYoLaCXM1LTnxC9JipAZxvlpdxCNqBYZwaQOaJhHPHXAvAPbKNs84xhfEFtRhExAhRIYIw/KZDoZtsVlKTN/GWc09OeKhhRyBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Doffq3WU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L3FUbT3L; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Doffq3WU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L3FUbT3L"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUCKe2052536;
	Mon, 27 Jul 2026 14:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B2PEWJdnMEz3M+QMus7PnsKTlZuarbRbmsN51ms/jwA=; b=
	Doffq3WUGuolQMWSfUMV2go8LlXDfpG1Kv4b/0DVzpoU0XagigbBcscGOKGe6LxY
	G5Di3cqz9oJnu5NzkNbcPfnke8jJdSPzjduKkh0UNNS6uEVUvIpahfKP7ryZTB9v
	UWdv476Y9UGJA1TOGNttTLuNYdKRc5sMWWqaN4DvKKO4qn6u75q4vIHGaJ+xOB2e
	0YsABrQHKLvNKQc/2d8Bc8UuYKXVD3rsDwjNBl6W6Y5k4PnuFL04AtnyjFx8mwYS
	YTIMx7XezJV9x+79sMI+h60b7b4qrVJx4BGW3Wg1kZ1rRVeTFFEWAh5gVjhWpwZV
	BS5FE5+ZSrepMthTh5dngw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1d9xhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REegOj011163;
	Mon, 27 Jul 2026 14:43:02 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012024.outbound.protection.outlook.com [52.101.53.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6bgxnu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c/PTRZcMuVERTWM8zLDx7t+ufcSeaHqvrLIqaapwdvzO+8ZfKtTnOkhH28diZEsL50ktSH6IpHDyu3eDGj6pov57C3g3ZGdXpZO9cTTco/8GE9GkYH6OAxh/BBA6pxugeJBTlle5nTXeRkjqlNG74zOjCGB7MefBN2rljvaMkrigIHDAPWWp06DCKHWK73CmT1477Rit0wXHIK7cBAgNUAa45X+2b2LxWYql7L7W+ZIMbLKIb66Hjx+h1WOQ/a68BRPjajiDOP+HGhUrjLrxIInSjleJb8cwSmq3s8/uv9pI0bh0+0pZSLw9yN60/tYJoMIkAV1iNo/m0LIn5YCiQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2PEWJdnMEz3M+QMus7PnsKTlZuarbRbmsN51ms/jwA=;
 b=MgQ1zMWgKpv1MbIhDMUTgLX/w63Qt8Js7MeAu2Jmmu9yah3bwvfncHtsy0fah2gGhx2/GLUYRX6MDmyCNeFkXUUoro4H1IV1PKbd0R62T/THwCKzbHpY8n7li7i/Ov27qrYQqJfCtjM0ppQQ0cGzvriF9gAmTw1PwqpWQAeBIgL0GTa69GGu6h9XYSS0QhKsdkVxXierSXj7VoxOqtrxx6IUIrd9ek7vwIv/hojg08yC7kvWD/wvw6RVYVuKKS7yle6ZDy6SPC/s3UQDbNcKigmILWpGCy4xNJ3O+gExVB8bQGRRKC7IfAKfHQe4BZLL+GtEo3p0Bjf4dQX3eGwr5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2PEWJdnMEz3M+QMus7PnsKTlZuarbRbmsN51ms/jwA=;
 b=L3FUbT3LSjg9QQDz9W8v+ZSWeqKphwhiZaWzihNWIFUGzcevwlYnVMg84VOInXdGhGLGSdBiyCNYwnJ+2aJBvq8k+1UtnuvMmlV0H4QHB2QrXS3ptIbRkxuI4/EZymqcf9+73ehE6knX9eEgMjpcvzLMM/7lyAqyiuUIV21HYZo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH3PR10MB6810.namprd10.prod.outlook.com (2603:10b6:610:140::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 14:42:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:42:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v5 01/27] libmultipath: Add initial framework
Date: Mon, 27 Jul 2026 14:42:08 +0000
Message-ID: <20260727144234.3802948-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH3PR10MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: dd54e4c4-d79c-470b-eef7-08deebed595e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|7416014|56012099006|10067099003|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wSt7f1Dk/TMrkhsCemZRWSoUHk4SOZz4XNozNi6KsXWDyCGvJF6tEOrsw56WPuCOGwr3DSD9oT3H79NPIMRot3yD8v0DQdKdHpQuZEKmwly1I8KM5FFN6GGCcmQJDqWWKsXf/YRYO6bZCJNCmJXyeYXOShUQqYWZ/ctUB06TELaEegbv46OkEJYL/6MK/qlwu2ZkswpcXE5A0onirlSfSM8fryNsYN5YXduHlJGIQhekXfJln1RQWOEjNLMyg7qftlyd9vMjTGK0meVCREderjKcaUNtHwTeTHcvvBmGi1UFeSkH0wkN/uynctdv/h/6HptwUWR9Ee+bwuIo/MowrESxiLjiFEe2k+mpKoMvPeekhCRzs/A8BUFLHuYGGVuhvACi4mmOomzylJ/s44PNlzCGbgyiwiQSrL9lDvRZwkqcX+7d2LiHnMm+YpaMwCrWWsGCSYItum5Ad9sjOQ3UU8U2w28EL0UgatuXEOw9KxHU4jSCE+hi2NizrIJ3AjKq0OeGn8/WVrx9y58BQKTH3WqZ/aVCmIwLxZr2dflXIefy7tZ/ZLmew8CtcTAFNSSbA1hUDjTPBkBD4Y8eOWvYtSwBEXUdEVuVaKZ9aRj8YEPps+WllXTn+Jqj8FxReBGX7eJndYPWiubQw/6NAVx0Wz/8LLEkN2B5bFUCFk7Ab68=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(7416014)(56012099006)(10067099003)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/je1dApgWQAqdiGMuBHhIypZC8Dv2WwWX20ntMKjenTfJ1Qrq5XB9lRGRZIm?=
 =?us-ascii?Q?DomZ96nv7te1LsQ/VeuN+Y6RAbOQW/4C37ISOA4QPHhdRRuTFfBDEqSc3ENB?=
 =?us-ascii?Q?GRZUA/Lvb3WDx/PlW0GlCUBRs6gOZChdPyIlEbrlE1mtiGZfOEi55yjIIgAc?=
 =?us-ascii?Q?dCOVcDN5QKF3Y3DN94GpijZQrCNidkyG5ZoU5CRD2626CD24PtsZ353jVHQ8?=
 =?us-ascii?Q?9ntE7ElOmwFFPc3/VxD3heqpf27bPPGOTK4xyu4HYAYtvudrsQSAxPzGeqIP?=
 =?us-ascii?Q?tQ2M9q80pZcoJKOmqMy1c769XOW1U1zKkun6GXKoclCEOe7oktxSSldw7ygC?=
 =?us-ascii?Q?xpMlQ6WKmErWJbvJrl2vO2TljNfrDWpAWkPCx4P2YfPTI7DAPGeQ7VD8IRf6?=
 =?us-ascii?Q?K+bx3gSZbYyYWQsHn9NNA3lpIO7eo1mWYvbuyOXxAr+AC01E77hEfwD/GjOK?=
 =?us-ascii?Q?k2x3MWrzc5AjGuWpQHTXqUX1uLuaUhjEpvcujF91hyDmgo3noOPCuPif4I3Y?=
 =?us-ascii?Q?VZaRKVBsJEF/4GbGTgfmwFawo/Cxr3BLJkMQu3N3EeNhEHNvh6RrvttI2ege?=
 =?us-ascii?Q?iTi7QbnwvU8cq3d9Sfs79x9QstsGHj2qZYnkPMsuKHrjTDpIWL0k7KyfkjbQ?=
 =?us-ascii?Q?LyzUZTuKcU627ajLUtfDlzi21ZHgEb24rYg5du45tkJbm8gHGNh4KTANZUfw?=
 =?us-ascii?Q?iucsrXEY2GKGBYc57WrifHsXG474YD7Lh7xwveH7X0pzjc1GXbuQ+GzCmECJ?=
 =?us-ascii?Q?1JKEeK90X9yY91nwinsp61kaVrprycw7JGo/FyynfOKpY43sINv6vuKji7BI?=
 =?us-ascii?Q?JYlgDvYz9D8fxn2ebg8uXI4lfl3ivjK3nrO83Jtj6j/zV+AbxISjZ8BA5P3t?=
 =?us-ascii?Q?JKxuLlhLsRfJFj9Pl1ZCHtieYGUIjgPBJJOT5F5k172lxEeWEqUBclrFtq6j?=
 =?us-ascii?Q?6iByQgKUo3EGMMxPbkCQSzlcJkyP6OSXnhAVyYSRn10ApPB6i9A/Gw8xwAao?=
 =?us-ascii?Q?L4q59jRpT7OHvQTgfGYhnvD3TYtWpgNR9n69Vtvt1yJEEhQJ6rBOn8laLups?=
 =?us-ascii?Q?Bu8ByunmUyKEdcsiEHWsKzSqFjkWbShFjBHcZBhI3B5k52Q+3wvbAjVRWsZm?=
 =?us-ascii?Q?4BaBtOhYIiUaLpXGt1sOxJJd/fkQYB/wnU52rTQCuizm/FypOSjS98PgchYB?=
 =?us-ascii?Q?osgiAqCIMn8qDpY3cMOI0aIK+Ry8itbvcCcq+Y89ScuYzHfcU1dP+oQYtx2z?=
 =?us-ascii?Q?IDJE6l6wH0v2ZRkAEEsyMw4Q+x+NBHUdr3CMcuQ6SRycUDx8O6W6uAvlj8xX?=
 =?us-ascii?Q?TT9ahOrWGbPO1wlqb/WUgm15/QTik3tO3g28LTaNIgk9J/moqRQSaofvEX3l?=
 =?us-ascii?Q?nHF2k62xOiwT5CpR1R5o1GPdmRTw4eccLjJ7AiFsv7dvWzWE6uiTPuvGpkcO?=
 =?us-ascii?Q?t4LFoa8M3xSaQsOjhtFDdSSCnSn+AxGhNxBXEzZRgi1THQEkhT4Q+C5JYPEc?=
 =?us-ascii?Q?F3321DQSK1tva3VJVuIPJcLd44hi6H2SKVANlnf+ymB+DC1ckcmtTm14ygKj?=
 =?us-ascii?Q?n9vkquSspQ4cPvjRw5d/tXRjCsXyJpcEYSFEVY08gegJatGAMGBnKq30iI/6?=
 =?us-ascii?Q?I/N2ypZgvAzE+TFzDrPPEpYclrLXiRjnWfxgcO0NZCNbmGR+0x5Je+bH+gdb?=
 =?us-ascii?Q?gVD9AaMbbVzEXJlPXTtt0lOZRz751ds8eU7Len3DjtsAbfYHnrmS0KAp37km?=
 =?us-ascii?Q?KnXgpFRxTZO8E+Z1FuFX44jmeI5XSZM=3D?=
X-Exchange-RoutingPolicyChecked:
	GLPhOGg1i+LJnR4jGX1iXM5TvkpS0sfDJbsaFOi2C2Eaabawl75ikK7R0L8YebP8TRp4MCqB7Dfc89S6eaZyPYILl8eXAAHkPbGmPGsCMYyvajCOUlGkHpc/3MQR/8/N0AG5eGgcxO71YxGRIQ5lBhd7nkugZqmY7+Xd278JIeZQOt7kDK5mWcyitfAgqkArHn9gFdbK7Di0oc2F7MYCiO1jlEh72v45/XarXCct7ZspGkSbyVAKAD2bC++YF/OwO7sHceHf9taHJFLUAL8rM7gfJDOeAeQpjadtnuk2wpHLYecRCjvtmZcdb1GeYuqGH/4+6h1tb9tbtRqnqfHQ2g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BT8TRjUsEuWUOe7aSkj253JfAUEa9lVVZRz22AlOiE48vXfDFt9USAqh7KPgFZv9WtPiFFDMG4fIKA7dCJse7HeAxdTTlVQ+Pf/JMOWiLtWJK1BEZazya904UOBOSQ4CLHojt+nUivWsGEsagco38sDcY86XbcMIKHNClTzhcsu+/88BbknmPn9tfKsSLFr/5KonDlJi/Cft+/SQvMnpm4Nzlciy42AAhUCyhJvA4waXlyWCP1djCfPffVYiFNy+PtVwgVCjXWfV5ctYekReLwIZ09zL5Q4woUpeZ0Gl40QlXKYqixKQN0iufva7/8Uj2cwEGmYq8DNvrjjRt2dlX6vIWzyKGcUfjFSmXgCBsz1kvaMpktLP7Z1A8sqSY+IpzQp38eFxpmOlS4/G7JQpWQIryJthFOoObg2IDVI9jjl9dg2jmZsbbcoEcrroyPcmisjXyEI+5I7O5pIdHeNThZoqeIEKQKoDaasJbHgB7ZEFGmxIwCxjcjb+VVRCm0cID4apCY8rticiy5tNJtTPs+m3wDj6Asiyxktv1OqTC3IuAVKfkbHp4jcxnjLCmSV3J/PWWw+y6hDjg68TQRIfwWVhkVYFKa0KjUsGXq+0PsE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd54e4c4-d79c-470b-eef7-08deebed595e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:42:57.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0OCvBV9/MDAyx7zRh1WHYQqAcjhntQUTquhBtK2sdpuiaaDX6IsartBJEluoUX3Qpa1y6SRS7khKOez2NyqEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-GUID: cXXo_E2qH8V2gd76uqd0hcRKnR7P1l9d
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a676e77 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=IMLwmY2krkRuQTCR-eYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13523
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX32LS6MIuHsjr
 9947boXAWydP9mu7IF7FJu5Pf2B/yFkCZQMR99rw3z3QJ6GzfgBTkpxk5uBGLDwOIcR4m1+4l0+
 nWDCNo9OcdyYvVCMu7LOfEKbeTbur42aLYGzjjiwSenLx3PPMvOu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX9ioMZ0p2AaGl
 Bzn3s+pSEU5degYIjauNzOxWuc2+y4vql9FYcUqAgbWWR1ZTAgVtCSwfStcLUISouUd7rwu12Fw
 BO4ziO1BUkegSLTYToecRBN6LGa/wRkviM1/tEbFbRqB5boKgFQ52h8O5rtA8XI3N7Jbexo8pCs
 T96SY45QxUQikDew1A71G64+Oi+WKdiJ6yFTYj6fKtAMSBExd65+tA6tYexRGUR5xna2yqkDo6Q
 kjrNxGkTGQtPFrpWod+kWdpgm1+IZTj70pqYh2NnJANW+32aU9K3JHXSI/NxfKG8ipDlt6EaRYX
 HoAF7rDCEUKoeDbjCoOGS6sMdbtnP+cpGWX1q5O+ekEVwCvfMsbIUnQ/ErULbDarVEi1fec9n8B
 5YL8APXrKrfSajTDz6gy+eWI+Ao2DWBzpTJwg1ciBLuRQxGR9EH7sOwKh1s6q7XohjFmcwA6Hlp
 whIYwtqyAZ2IBF3CwKnv9+g2JvyUsZze4jcMTmsI=
X-Proofpoint-ORIG-GUID: cXXo_E2qH8V2gd76uqd0hcRKnR7P1l9d

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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
index 0000000000000..407d985cd31f5
--- /dev/null
+++ b/include/linux/multipath.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
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

