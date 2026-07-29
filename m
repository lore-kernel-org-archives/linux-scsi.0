Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC1B3B4E8A;
	Wed, 29 Jul 2026 10:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322334; cv=fail; b=tRPWQ0PJ5TUk4NzTG1EmWW51f8QMaxEaXvnFK/h0ES/K/OC+KW81E9F5zuvUm2AgkxnT7pgXpU5X6nt6rRrCitSX2MnauJmwxEoCUco9bMcAUsrjtdC2a3oB43uxKVMYMGXKbPguCESqeftvAhp3qiIWdHktpD1KB2vSIRkX+1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322334; c=relaxed/simple;
	bh=MmGRjzmNoyTY5bP4PLuM/ZRH0fud3T53DhUKDgjvMic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fp+Sro412jJVVmM9JVjyvxu3owsu3FNORDivezZIhPlEAqvAC50jJwNPTDeAVB9myYNkWlO4Yg/V60b7bD5qQEzXWjM8zWNB7mxFsGoV8xMEOdEcWkIDaGfmd5c2uZmfzwqzzZXKRoVcBraVsFRicEeSw2ZolQb/oUouhLdnnvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YZn17oYY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dnGGr9mi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YZn17oYY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dnGGr9mi"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9OM5I1094334;
	Wed, 29 Jul 2026 10:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NENXx4FIWi62ApXODxQZ/NHmWrRn28Gv94EIyjA1Njc=; b=
	YZn17oYYJuJUtutM2hYNqCj/tlIBzTo97vrWEb54nlkchmKuezt7AbQIKbk+ih5J
	9RM5AaDAWqE0lN0agUJ6eKneuTUKm1IRvNb/JeFIM4U7nVV+R5y4JtlJVjwH8nzq
	fsf7f/kfjK6mm9uLngYz8pDL5dOkWuu+h5xAlb3XCD1D19ElEvxkVgR2KV3satx1
	SFiqZGkGDdJN+mcPoYLZIKPkyzUyBJ9kh4V6oZy4dsKzPF8kgKueNNb+3esVWyGx
	D2oAq4KpTNBKkyOZ+CDxAiDYuXmIKuflezILSksIC6HMFjGVD31G1IxwBWlTLCo9
	llbqQ1h6YNnZCYWlvDGHwQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5k5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5eA040026;
	Wed, 29 Jul 2026 10:51:41 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk0k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fM6frFoAoeuILjWGHcEL33a6Go/iAOR1HXtu5psoIcOPFCDVE4CRYXBo5yrCBvjT6DhYw1SXFJhaCKNzxWFvtzvVhfwVnf6ZTTeNk08NZAjWs7Uwyo96VmjaqtZkW38Q4g3Fdp59LcyKzsNRkipb+RNsV1Dr0PTqftDCVgjJzfaSG4ixQXJa5YFwLABU0g0Nhiu76YZRUP3FwliRGFnHdUhQbHx1GiCqnxM991tmsLms1+mZ/odTqU7KaF6BDTOuY0G4gg1sjc8OecmKi3JmP4LqGBQv7jVXcz5XW129rtQE7pky+mlCVHEX9rj3r8gUbEVALvtjGX5t0k9ha8ivEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NENXx4FIWi62ApXODxQZ/NHmWrRn28Gv94EIyjA1Njc=;
 b=fQv6ucm83vX34jEiQi4gFUWKG6aRroDEEVPIkf7XiYbZo3fvP1XbVbswr0dZVYNwYQR4xaOZ5lagfzfl3Ld0NVxADl28zj6IIq8/AEnK4ZIqzttEXN8zcDT5SMVUkyeu4LmZwXcu7oylGoO3Rv83DVWdJNTm3jZbsSupByg0aRzRhjadiNjQwKtgU7JlLZiY6LvEIKRhKTGtUFqJtB6hKz5ps2qyU/TTIF+eGkNd1WbTWYwa1W05spBivr9Y6knDLkeyNe5FAF9Ow8+lky9nAh+yo7BBJDDwEtkH8PsB1/i58kcew6Yxa8aUIzNNjoo6gfh7ZDNFoP1sZFRKM+vFFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NENXx4FIWi62ApXODxQZ/NHmWrRn28Gv94EIyjA1Njc=;
 b=dnGGr9miszZh3ArEf64sGxrPwUjPCNO8MOtDAc+Uqqa/4keQBimFw2qgMPusniKRLbUGdHKjmYKxQHvrLWd7iPmsmkOx0JdxiKDmcI/p8jLsz8Zb9MzTzeVVaPVjnGl/giSmhHBQxi6azQUUFDzcaC0cQRhXaEIu3S/1cUDSLKA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:37 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:37 +0000
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
Subject: [PATCH v6 01/27] libmultipath: Add initial framework
Date: Wed, 29 Jul 2026 10:50:41 +0000
Message-ID: <20260729105107.255712-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0129.namprd07.prod.outlook.com
 (2603:10b6:5:330::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c9b477-91d6-44c9-f502-08deed5f5cbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|5023799004|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2XqLM1u0t36m1U80FWCgSevJpDhYu7Thm1bUZ6E72JXSrZAcsknuflvVp4VXVNkcPSN0tN0+hPtywoqdVvF4Oe+uJ5gFKo/dBX/BNd9keJ0VK9CSfA163altHFKqEMCutiri5IGwM6evyDfASicwxmeEcVRpEC39g+WXNAnNG8J60taUXzEDyIsJYdNSQUMf238SDlJeaILTMm4tHRcefavaFkA2S0JO55Ed7KuYtdlSSmBXpLJvrVhZ+DtrYUbmIYay9kVB7CFT0f1JvV3yggkIZ+e6GRcY3/sa7E5ynmfO4xFpWCkMwT1CpWAwkrt727EI/UJh1Yrj+qoGCueYu3j6dC/3zioQG7nhWd9HRr9kWOGjQ/SZmmh2DLlGixouI/hB/RT4G4Zi5UDb3CH92qz4IsGF/P7CSxbUAh9FI2TP2PZHctdpjS8apBpBNR1dRU17tPlm3iqq3W9v9PKmUFg4oiAqcNYst/Ym7IHyPedFasYGMkGCJxwF5VzQKngea3oaaY+NV60YJZB3hlHQr66dBP3PV8/9yvS+DR2ZPmP897KZqOW2XR9+ailJ7mhKjConYj/GZGwEOjl6DPdWExl4jo0F6j5IGBxoHoKoPGaLRmW2nlkbrY2+XdM4zi/9J8JZKKrTBNURE3o1K8d4gJQDNheUsT6Qsyzj9BLMrpk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(5023799004)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CiSs8/OnFKP68CVny+UIICW/PpCqWK8+L8+M0BRtJUyYbCa0l2clHq8CQItF?=
 =?us-ascii?Q?fFdV6TXugjVqDLZmM26ah96mxc29gmY7PWvy3Kmc1DSTi4FaXiE3P5TzcD9l?=
 =?us-ascii?Q?Viy04q+o+tVPEUdEe+xUBhOGaKUZKSzz/cUkrfXYfoogwL3D5JUYJY0AN8Iq?=
 =?us-ascii?Q?XD8mvWfQn4MzOR+bBfDA4vrVWoph2T2dISjxFLctBuxCA8YK5sBe5ZR44ueV?=
 =?us-ascii?Q?UiDor7DuSJgAY/yqwi7KJeE2whAmvWqueszcayhsfsqLcWiWqj0HVDk4HJsE?=
 =?us-ascii?Q?y/RHxtgMXbXBGZ8xAORKR1+6qVi+XHtTEzHJnNF7s/AwBwC/MhYNYqUCdTqk?=
 =?us-ascii?Q?axNQqqVtATUpPPsWsFB2c9XMys7U5UZ5/t6eQtRkcwnn8jj9lywQ85D1NdFv?=
 =?us-ascii?Q?bEljKVXdbIqcxkzkbiRyl9WB3m/cpa1PbY0GeYwBblCzWdLCvCgJRPaH/Vv0?=
 =?us-ascii?Q?fFTJQluYKxxUaSGZUE23wAssk+Rxwwl8n3DR7xSOItn5yc28PtdePtUR8PfF?=
 =?us-ascii?Q?zB99EMpJWIW45oTskojFvtiKUxjx6ds/97PL3kN7ppW4HGYULNIMD/4e8AEE?=
 =?us-ascii?Q?MS8aI8+nCykCodrQbh3Ro02Q6fAFV1vbQEgJGs4L9WOz78xP3IoVzGmPxbi/?=
 =?us-ascii?Q?ICGTEicRmApQgqhRINKLPHtopx+G+WJzv09q7DFvSYKMJI8jAQO6bTkp1725?=
 =?us-ascii?Q?v5VSLBucwT41N+c46t4w9hGmDFm7FFgsVdWiGsI/S1qtVXjr4N09EuN3Hyzw?=
 =?us-ascii?Q?EoaA2YL74HgnM1V0eN6jJWPAYttX7kECYXKxwTWi49ptsYEg2U+kSJtRE3Q5?=
 =?us-ascii?Q?yfMF56M+iIV4dPCD/28cZw5HvXkyHDagRCZSxxKdpnub4M2WUicFhODj4A6P?=
 =?us-ascii?Q?bzi16IEZm6TEW/2rOvTOgmBNyFx7DeprHEFU7CXjZVt6mtaNOFQ2IE7ZCNEJ?=
 =?us-ascii?Q?FydhJB1hgA1lSPEgOPXOphfkAhbYqav6RtrWXy8+KyEiwEiHkOdMCedHAtdj?=
 =?us-ascii?Q?LY2fO5ACiTwyspwFK6/tHGdSJLR0UcfjXtGnOO1z9j2R0AzNwIwS/LLqmB71?=
 =?us-ascii?Q?AUXPUV+QgB0ohiIGMusWkuZixTHd71/w11rjGDx3BQI9Azm0eT6qLfiDy594?=
 =?us-ascii?Q?zA9IKSOpFmVew1FZBVByor/yG+bJqbAoIGQKnrcrTNavLo2pcdB1yG15QzQ6?=
 =?us-ascii?Q?kt5wFWDw4WlYkyTfjmBSNDIqhBzQextS+SYVJ1bEncz8mTofCNHcKFpLaU8e?=
 =?us-ascii?Q?5lGksuVwCd7EuqeMuVPru3JONp8Bwlx5q8DfUaG70Y1cLXilmALLf6BRVmet?=
 =?us-ascii?Q?BZRJG3ps6crzTcIYFgzI+oGTCvAr52Q25kb1/4IV/5Y7pTgxX0JtUEqp4+f5?=
 =?us-ascii?Q?cCn/NkyEZNCLQwOF3wR4uxZu/M4m01P4dSfbIdYYGk0J0nd9gN4XW/VakmUr?=
 =?us-ascii?Q?p5/F+tEByyiqV4s6IzDIDhlgNOYYb1ZUO4642HE1six8YYLvv5clQq/+G7h+?=
 =?us-ascii?Q?KVVh1rpq2drdQBHla7ouoTd6r6ph6OjRJ0YRbet1jLrP3sSyksp919rT1XMu?=
 =?us-ascii?Q?DdJSU2Rl4S/McreDDHGKQlMGqbepaEVNBOIDwwE+9Xvk2YusZy1SdLTuWZg0?=
 =?us-ascii?Q?24/9ZC06VwqvAkpgs8WxIvqsy0GSc9nqG12SEY6DZaOp7JsC0S1sejCfV68Y?=
 =?us-ascii?Q?8qWhEy3MDQYubn6mjV/od9b6h5N6HGIV+0qmLE0IDyVZQF0Ldz1u5fOfaxff?=
 =?us-ascii?Q?VdXBx2niXEV0UtOSLgTuCBNDT+qKoo4=3D?=
X-Exchange-RoutingPolicyChecked:
	DuOF4AHFs8Usc9lCkpfE2uObgwSWe0PgC6aHgjLgWN9XWriS1odRDDTfeC+X5FAViMZ1OlACrEQ8d0WnEEZkrG7f0m29TNbOehGO8GfgUCiaU95y24SqTqVqYCXAjq3TA1O6TSNwdyvv3a5uxvGKlIX2SC2bOS0Y9Zuw4Otc8IcHrFgSab+QIDKea25Qj7h2Wy9LowEWiVRP7TLlDYZqomvDaClrXC684TWQ9v7EJUJOWB4waGqoHl2dvNXb37yx6C1YIW+ML+UGQNauZuCO7H7aBwi8SuGOLYTcKa6Ryw+5/d5nbw4TlYTSCQ4wW7FSbIzmJaJpxnbRM0E9Xsicsg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OFv9ZOq4Rwk5SYVFxA0NIObhMacsx6iXNVZCjd3QInF8VGI5oZ7wIOhw7TMje5esVzaIg/loryigc2Ua7/iX6qPXgHE3VlwGVChYGojlJtjt1JlYu6XeY4Zv/52jbirHjywHVbfz6s4typzVX8TzGi0TDYkJWQHCI8+nVgBmHOZCc/3nw5hQKVWPtl8EmnWcc2wCiWq2YQiqah3IeCoytFDuqqVMfvBp/czG2aumrX0y6PyYYlvnffWt4YDhCOsGW1fK4pOVVLd2Isv2SfJ5IqeskUaBXU1OR0c+NWAIwmyWF2LTLZ/cxXtMTaxkLm66hVAckKiPvdy4O+1S6c8/Z09hAkVKoG5nbYx4hgrHEyMDaqCqSQWEI1+gTIzYaahGslx50QCGaAUfAXjuM3KBSHt+igSTYizgkH7ll7imxEL9QqIuZ9gnQtWLHsTmCxnPcJJz3KCcFWY5BSjOSlkTxCpRM+vx03kL9re3j07LOHi7OgbGXf+sv9hn+WLwBffGgvqITiD9vRvg26Q/tQwQ6lmtGsZj7X7DbMxqmkiKSofatze/Zex6cIMC8EAZhIHXUd5R8PLvoMRXeVuAORyP/bzMlYw3pFBf8qifxemUHrc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c9b477-91d6-44c9-f502-08deed5f5cbe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:37.0759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVqJnaz/+xLbxF6zv7oMZlLzoqt7f4fe1FuwT2XN+l5O2z0/Vdtk7sLmmaAD/d3o0JC9nNT24+YaW6HqU88F8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX52Ydtb49fojb
 FCUk1Qiy4R+CehP9Ew6QI13pf4ewrJoftVGaWt4rEgAW5G/TsCw+XkTtoV4Xmn7hthDvzhPDyJU
 q5jRr4nBTx9GQmWzpAk+88jKm6Arm7pmz/1seFpQ7CxS86DqtWwx
X-Proofpoint-ORIG-GUID: WVr-L-9vmAvpSLM7rhQVzuAjGwzxKvl8
X-Proofpoint-GUID: WVr-L-9vmAvpSLM7rhQVzuAjGwzxKvl8
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69db3e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=IMLwmY2krkRuQTCR-eYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX13dzIJ4J5TXy
 kvnH53UBXjnL24zvTN4swUqKXf48+18dVoKVNK6H1oMxcQ3qfrQhf1OJ5BqbwHsK9krqDBnBZBf
 RXhvx3QO5DUxYDiniIQkk6r2TCJd/lJbhztd0OY9ThZv0DHuC+9/x8AVfta3hXg0rUzznUqlapK
 hU97VdZHajDbksKIFNGaG02h2FMXCLkea1Fi0mCZjgMV6cZ4DPSW18csPtliWIcFDlNwivYzJ5i
 pTdxViSeL5zFI04WshhI+zWuu9Vcp4h0EbDEPjnwaba7wY1sb9gV9mZsssaMisSppMKmay5+PGT
 RBOI0Krk8ARNxLMrJJloiUIPoR51nxK4kLDiVvTJ0nlSxFpETPy2ABKxyEJXdgf/txYyT9//VUK
 QER2ildalH/ysoPry1Yb8aCSaTa2aF8i/SrsrcBy1PYcM7ouWxLVrtp7fhNK6vdmt8ELnnrkucz
 Q92tMZ2IgQfy6xElX5Q==

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
 include/linux/multipath.h | 28 ++++++++++++++++
 lib/Kconfig               |  6 ++++
 lib/Makefile              |  2 ++
 lib/multipath.c           | 67 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+)
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
index 0000000000000..f7b26c66eac7c
--- /dev/null
+++ b/lib/multipath.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2017-2018 Christoph Hellwig.
+ * Copyright (c) 2026 Oracle and/or its affiliates.
+ */
+#include <linux/module.h>
+#include <linux/multipath.h>
+#include <linux/wait_bit.h>
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

