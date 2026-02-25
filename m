Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA16C3921FC;
	Wed, 25 Feb 2026 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033690; cv=fail; b=h2IEMGgB7Jr15ri11WKV0D5yZhwsdAMLzSVgBTbDayJl/r0JmMTGT9tetSS5jcEg/ltv2UtVv291uO8giNzypsyk4z4BtCprjI0HHGulvABEz9X0mxWo6Ne77I9mNpClzcxiiaB/+4pI8CXEkh62YPmB7umEaYP5m7L8os8PUdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033690; c=relaxed/simple;
	bh=eg3E7knL45WpbrRoXRHb5W0TxWZvvev5o3rh7LKJWlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L+Y0t0LOpLdP5QjUbsG5cpR6hXMHOhG+EcmsqM2OgVhpzbJi253W36oV380TcFHWLCs+nXF3SSER8hR1+vUNvoO3YIO6QmxPBdqQ/epVaXkZRH5g41Hf5PuypQpNXf+XA+2gTfTq87+26p1iX2qudkqdHTnM+7kXyT1wSeTQ6rg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H9nPUqp3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VngltbtT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H9nPUqp3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VngltbtT"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9TrFR1959902;
	Wed, 25 Feb 2026 15:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t+4v5/q0Wif+JxoAXxp1VL3U66W4APvpKrTun90r7xM=; b=
	H9nPUqp3fUzqMY7jYxtcLrUdrGwi/4tyoZTjkr1j0yWC5jJ0V70v/NXsf+KK4SIy
	RVL15ZuE071ObQbwA1JA223Rr9NcjWN6V2pGne22RPuGgOssmCUm/lfoN4APftOS
	h9dvnNABCRb5WHvaDPE4hnV5oODwgL+yKR09asEZqONofiLnsOYi3x9VnAZoQpQc
	yuJM4uyffQmXK9ojk+3ACYlDtsZuynt9tGs622CNtJb7DFUF3V5fIW6FT4erPhkB
	3lgO7ztIfBXc0u0oIvC/aKnghe2p95Waq4rUK1QawHGKac5fhwA7Dc9YbwKucVhP
	ApoN724OwHSddyh6fDz1/w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbeg9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF0tiv006261;
	Wed, 25 Feb 2026 15:33:13 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg537-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iVM8h8HqHQsv6oYBSvZKBqqOCD09MDbz5FmJXag5F1PMiCppMsFF6ZAA0VwjT4XC4E7CxHwlvxbhmEKz8JMlCry6nc7ijfr40c7x6e0WBT0oKCtKkMXfWnBCu24kj4WM0v3u7p0LnJRBS3pFnxmD/gn3fVPIaVoo1bexGG0DDzkbcGA+PNy3HIowzo32O+qXn/gvnnemPGgOQRNPeGdaIJqxqzQ0LqrrQlfqSN9rnfrGKl2jcO67Ib/sZPmF9tnBiWB+PzPXrlzD1/MlSgnihjeyO7sNDPHPbEAats/dBHqdFZxtk9Z2puRg1AkWu/QsbODYWgUmhOCsyeIrESeBSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+4v5/q0Wif+JxoAXxp1VL3U66W4APvpKrTun90r7xM=;
 b=xiwfKaqVDEACN4Xc1kMGQetXdqdVaQj+JC0nkIEPE0dTSQiZva0ss6wKHlEOrUsxF++1VkFACuGwYMf1mLih1WXdiaN1H56k+yQueQb4l6iNcpQzf1A1l+zrtPLwGDXgmL+1QRaEWwWR/IZbsrOnnarzuGjUAuuLuaTzZod3amNOEuFAkEG6cFf8DecigvS9psHOyr71GyzMBWQ/CspWbMHCdp9PLjjE9DJClXqrh3o4na5uxvlRZk2lk6/eLkJMQC/zNxwuUat6aD4E/JRcfQpHcMJ71z9hLWgC+u4sxM7nKxAchh/pAm9gUKRw+bmgZjf82T9baK8zhTE6Dt4Zfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+4v5/q0Wif+JxoAXxp1VL3U66W4APvpKrTun90r7xM=;
 b=VngltbtTVLdoJPJgxU3HtMQoz95oCeVfk2iJ2jBHXe3I95/aoQIx9fVkGV5OUs2eL6Fuc8c8+lG0GnkMwI4c0vQt2a4/zDrX1SZdjZI9ao8VL5l2nWqHdyMZptKR2+bD1qufEMWDsRf7hxTv7wNbx97Z1B64lsUtIrgqOcS9UD4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:09 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:09 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 11/13] libmultipath: Add support for block device IOCTL
Date: Wed, 25 Feb 2026 15:32:23 +0000
Message-ID: <20260225153225.1031169-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0011.namprd19.prod.outlook.com
 (2603:10b6:610:4d::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f3f2a3e-713b-463f-5cd1-08de74832d9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	Yx8BniJzWo+R16V5+OrQIzU8gI+4wfUNF07WWLmvOGPYbeFp+yw56LHPAjyhLljriUWyWqmfv/lK1SzU/TDS4OQnY1Dq/B3bWCNOi5l/X1x6hmmbN6fHOKBmzctG2OlNUYacKEtlX0DmCine4Kc2ZR6kKxIsNzOVzcVKaGSdKzE0Wl1Is/PEgX9drX2U7bc2QjqYebuwBfjdcwybfYf+Phe5fuKSfpw/VZHZNKK/ls00IehtzT4713rKuMC648yoSmfREEXziw5uBddlx7mp4ASvp5bh1O27iI+Oh2JM5NzKcjYpAcYTYCRZkUqsG6rbjl6v41X7w/2RHM34zldeUi5rI3KavUt+ZKCtuBoMhFQMQdgm8H0jZws0tr10op8n5v4XcYipXOlnGfpy04m1syqitTJfD9Y8oel0tD1XEf80KZR2K+cM0V340v0dMxBV4roai1/tCri9CyJts57Wr50PLgOxgAcLfqsOb0dt2cZ+/lWwpUs2gj8NSm5d/PS7yAiA6uouPfgja2XBOovI7CyRHlOqfXQu0U3NJ+qbcaAZieEAbFjMrN8jzHVVrX/PoBzH09xxj5Iy5yMaL+MHtxujqw2oYHHByVlZphUuihKDtzPPefrf5p2cct7CuiMGCJ0fvvMEzyBYXOMDOFDoSyCxrUSjxVJGUMfymBMMtt61xg9dS6VGfCcz4L/F8G87ZkxO0kMubhrB9VLJEht/haBRfIo5nUYMD/RpsSdnDOA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?63kmcYKEkv3o0ZCVZkYua6KMVqx6UztZL+rgtGrZEzNNq02ZzVP/fk2hBxHv?=
 =?us-ascii?Q?xwjmHS0xiQPHA7y1mgGFhfz8Wrlo/rQqXSkaBc9o+QYtxUtsGC/YgHrfi9V6?=
 =?us-ascii?Q?9rMAArDk+seo7/xWJCfUixslTB1e+xCR+k3LfNh/0qAyjNIM2ejFJMU/uOq5?=
 =?us-ascii?Q?0BUhCRcnXTx5vnfEGkQnNY9BeS7La4lAofIE+zFFk6qAhGu0fKVITRL8El6e?=
 =?us-ascii?Q?xhuO8/SJl6YLYN3vfaWdmEZ/vreHBF7Psq0cjajUoS5cfT+jBWXjUh6lIYBR?=
 =?us-ascii?Q?/XK/5PmyJELKBB73SNkyEasTcPxrttRfymrrOCDOzPS/eAKDGiHyGh9730XO?=
 =?us-ascii?Q?bfwnWo5NajeAOR+/dZnESsdz1ynuUe193Au+iXjPH+JCR/ZKrZ/6bTHg3eBE?=
 =?us-ascii?Q?3SoPzJdG5FP8Yclerfmu7ntI0omsAOw6lkgmHew4WQyDySFv2XLcdPkdWLZN?=
 =?us-ascii?Q?/LQn6enuJZLCsUjhMqVkz3klXbfkyt94d7GnKDf3aRQs52l31WGWvSlTTpSZ?=
 =?us-ascii?Q?V/XaKVoU3THtqo2KfcM723F6xUNmK5yL1ZwVHyqC7O9UDFJE/Ice7FHFeI8J?=
 =?us-ascii?Q?KdAUUhX/s7VX9sVL4s7HmJjAGzTT4cUgzg9pnlybhJjzMkUJzOmk5WY+yjC1?=
 =?us-ascii?Q?H/V5BToiQE54oo0JsAHUXurDyWHJ2e/04WFRfTofp8Rx9MejqZPq0tZzECkt?=
 =?us-ascii?Q?vaVPGGVpnzsYaARbOIQJpZ75zMXK3pejwraYWihNDqLpbG5UizxAvZFME3qU?=
 =?us-ascii?Q?Ow9YhCH3tBZ97RkpiNNDkCLSxAsAXtSz0B4lznwukImBbDDJU3OlYYfHLLTm?=
 =?us-ascii?Q?k/PNAXUzKxjMHjnkgbfnzMgN5iRumK4/KWfoeb7HvW+dp3Slt9SPQ83ZrFgy?=
 =?us-ascii?Q?yGIxSuqe0hRzF3xeJlqeBRTKBui3Un7KDC47nkRvkJfldGLgSbL8m1fzp4ps?=
 =?us-ascii?Q?+0t8+VkzO9F8OjXd0SrYURxBah18nisgOsiM6PLwMfQfmJB4acqDK4WAG042?=
 =?us-ascii?Q?Pps4YGTDHNXUX3GfLR9p4w3j5cC7q6g+Sft2v3GV+Csl13//Q3JQXo5y4/2h?=
 =?us-ascii?Q?6NBuqQITOxtKMFDMextDcEtwdV9vtKvYxG2WHBKaZxYcpbouQRg9yOadM7Vr?=
 =?us-ascii?Q?m7UuNmOs8SutgvMIaEgILYE128YkyfI375iOmAUjiYJshMYoSxZLabVCrOSu?=
 =?us-ascii?Q?U1XSXLAmN4tiQUjZS8Tcg72vGuk7wgL5I3XkxYp/xfY39dAezr17zhhFRDmS?=
 =?us-ascii?Q?iqiAyb99fHDFxBCybd/ATGHCmIx7sHWUhbtIWt2WAXHQLkhM+VEB3tn34PbJ?=
 =?us-ascii?Q?CQhFrcfrnbFLSxCo4VWQ+FgAihO3pKyN5zxaqSdy8XltCh0a0+7AoTlj9qpJ?=
 =?us-ascii?Q?qMNfV/HSBDqFNukyoZhbOhuGn2fZsCpaO5LZu95Qie1MwkzZDnPi52pOnM2o?=
 =?us-ascii?Q?HDQhBsEDdQjKqIJpjyPOU9l2r35TjwBC9L4yphcLALR4uY3s5qTe6qM6MyxK?=
 =?us-ascii?Q?zMcAVDpj40zEkzCkNMBYnwU/PLEPI3W5zGHt6QKfmvjMMGa/eKgeHkKQSPJJ?=
 =?us-ascii?Q?QliKsi27MHp3GwoNGEOpDZY/SK9IjGVn3UugWwOPJmsZtc3WadSIZ/pcgCs+?=
 =?us-ascii?Q?rkkSZZuih/Mk1/2ypSvMNsm1R+G8wCdkZNw9wT1veSL0Ha4mCWTbdeyCtTUo?=
 =?us-ascii?Q?dTW4PKx2ZoPQF1n0FrrAiXBRNiAHwPbx+HRq2IHUQzHY/lVzo85Wx7mvAfI+?=
 =?us-ascii?Q?c/8bltm552HHVhoWUuNoxG8qNmhz1w0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+48MwOQwv+4ColK4v6pndL9pdoGXJy+expxfnBuKRtMiAT29dz0biS0afO0vX1OvLiY0c6mIoqRa+pkjmO3rF7c68GqcvD4dQvzWfkxRvtrfCQTodkBD2xj/+nVnN74KhvJlt9H2AcJooYQzNf6ezvBMmKSDfR+pbmEhLNX9KPeKjHJFHokDaj1CJOqW25wjV5vWOUkHtUU9foKu9EAA3UDPna4xzRB4kNrarrD7XSf54geBEOBCfoBH291tuUVJkw0/Nq+Bt3zqW1zUI29t8hMI8hx5jB6JxdSK2Ufwnm0/ViKVIcLwQn8rTcuREyJGiAl7yOY7LI9MWNEjNj/YipKNN+gNmbXILvKVf0mQMfzpPkCrP3f4C9c0aMqVGHrx+gB1X7EI23h5VO78pVcNUkLMIAS0I0lQzud6Ck1XAVVd7wxSpwojUJfLLHd8S9LSrfBatKOvAS/pTLAvVV0RwQbrYIuv9HViig+yeQCpq5BTWKgTuGLJFGbHXJBT4lyt8oPswSPxygT7i+XBW1rV2b0gp0pr8Ks34CGSb6LEtF51cGjnBuKeZu0KYc0/PWzJCd02wxsI7Qy8mh/2XQJX4jYd7gwqKNSC2Xh+IYO4gFs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3f2a3e-713b-463f-5cd1-08de74832d9f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:08.9624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MaNfTlxxUkaCigJutFBQ+mA/gB61cP/UbC6yGosC0at0sCAA5pkwcfCt57r15Oux72yrwk0lrU03VThzd17xJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX0DKYFqoKOt4U
 zAb9hUXaqNIu2Sk+o9ewsrquaqRhyOtOQiWbK8mOa4hCMyGcWLP8SKDMW3vPjpL7tBIyxUrXPEX
 esFIiHkmCqOMhc2ap1Cfs/hBwP7FBVSMwnofNesvZ6pi7s5gbt+bX0bTx0/FYH0MxRg2yl1FQRw
 lyaVNdpmyTwEvKPdFIaxczll2EQafEN75L/4TdAmaOSvjPURx6d5DWv/HKpSx09AfW/ijesphED
 bferz/FltFwqkpK7LOJd4Med3EjG4A+7LdbmdZWGgnZANsiDcit/RLUHDkVeTNZ4kDJo1aUN2+2
 BB9kv/pN8qkHH9AxL26sReMlbJmOZDgourZwWLo7yBsh8H9baWW9cAk4Z4oQW3F1cIm5k5bT9tV
 WAqVXEV+KYrPQdQwwYn5TqWQc/HUPcb0jQ0EO3MOa0zAPqZaSRNDwADcPyjjebR3t/1BwUfFXL0
 gnW1/zZulWsVWvaD+Gg==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f163a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=cwoSvNeAA6Kl3ZbOCS8A:9
X-Proofpoint-ORIG-GUID: sZBe3weaB449HnxzEyqA1_AN9E4i14L-
X-Proofpoint-GUID: sZBe3weaB449HnxzEyqA1_AN9E4i14L-

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into driver mpath_head_template.ioctl handler.

It is expected that the .ioctl handler will unlock the SRCU read lock,
as this is what NVMe requires - see nvme_ns_head_ctrl_ioctl(). As such,
export a handler to unlock, mpath_head_read_unlock().

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  4 ++++
 lib/multipath.c           | 42 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 3846ea8cfd319..40dda6a914c5f 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -72,6 +72,9 @@ struct mpath_head_template {
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	enum mpath_access_state (*get_access_state)(struct mpath_device *);
+	int (*bdev_ioctl)(struct block_device *bdev, struct mpath_device *,
+			blk_mode_t mode, unsigned int cmd, unsigned long arg,
+			int srcu_idx);
 	int (*cdev_ioctl)(struct mpath_head *, struct mpath_device *,
 			blk_mode_t mode, unsigned int cmd, unsigned long arg, int srcu_idx);
 	int (*report_zones)(struct mpath_device *, sector_t sector,
@@ -154,6 +157,7 @@ void mpath_revalidate_paths(struct mpath_disk *mpath_disk,
 void mpath_add_sysfs_link(struct mpath_disk *mpath_disk);
 void mpath_remove_sysfs_link(struct mpath_disk *mpath_disk,
 				struct mpath_device *mpath_device);
+void mpath_head_read_unlock(struct mpath_head *mpath_head, int srcu_idx);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 void mpath_requeue_work(struct work_struct *work);
diff --git a/lib/multipath.c b/lib/multipath.c
index 4c57feefff480..537579ad5989e 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -496,6 +496,46 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_disk(mpath_disk);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_disk *mpath_disk = mpath_gendisk_to_disk(disk);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO)) {
+		err = -ENOIOCTLCMD;
+		goto out_unlock;
+	}
+
+	/* ->ioctl must always unlock */
+	err = mpath_head->mpdt->bdev_ioctl(bdev, mpath_device, mode, cmd,
+				arg, srcu_idx);
+	lockdep_assert_not_held(&mpath_head->srcu);
+	return err;
+
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
+void mpath_head_read_unlock(struct mpath_head *mpath_head, int srcu_idx)
+__releases(&mpath_head->srcu)
+{
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_head_read_unlock);
+
 static int mpath_pr_register(struct block_device *bdev, u64 old_key,
 			u64 new_key, unsigned int flags)
 {
@@ -646,6 +686,8 @@ const struct block_device_operations mpath_ops = {
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.report_zones	= mpath_bdev_report_zones,
 	.pr_ops		= &mpath_pr_ops,
 };
-- 
2.43.5

