Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E26F3DA7D0;
	Wed, 25 Feb 2026 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033854; cv=fail; b=FgaEY5pUMbEwmDQcB1XXOjDUHTRE3pMPwOp27Iul44jvEyAGfjqqjFUTbrNP3iYSEPgUPAuy4JNJzv7uUhAedCpfVmscOlGbK6d9vxFP0V7LAOLSN3p7BddfbeGxlOBdmSYB7rzC0r4iX5il00JyLx8MrGz7LXk6igRnwcXPEXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033854; c=relaxed/simple;
	bh=QYWYeEM+A61uilzUX995xY8uRtkN8HAsOVdH7MyFQg0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FygJIpUtWh0fao0rgfMqGNmbj6vCznWHtQFiAC76tHyNnw90Vb1yUyYxav3hSWx5ONITXoxCAom8tM54SP4axzSG6Aj7NHl2xFDN+OLuXXPV8pSxyLmN21yChxqSOxu5HKlK5M7K9Nt/E/qnHbFAI/yJzrhT/4pipWB7aqEO9z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L8sUkibd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Iifeqxjb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L8sUkibd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Iifeqxjb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9k0xB817477;
	Wed, 25 Feb 2026 15:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=sZ/Tl1rNVhMydW8w
	2+t628I9KWRFhQk+oIhuZ/AxxyE=; b=L8sUkibdfw5l2l2hCT5J2o3KYDF55cev
	Yu5Y2iKJz0AtHNTHslUDgBb5zXK7As8OspINnquoSggCPtCKVpDVLKhd5efReUok
	JtVrRuqwH9yllHM+8kOxntMNJe7HIlXqNcz/Ee+HVuzho3BzXRoDI79D43607Xuz
	7oQV7PzTv6e3l+LNYi4JCoa5wdv6FyvgdjqM6GxM/BOhwMtXo/2ISpw6HJgNk+3S
	6tapwv2j7tPwDbFgiHDtMnAHOl8157UCD/ad0Lwr/OPUiffuV7heKD5OKigNOnEo
	7vyBhJqch61/xqOQO121tWw4lbtk3nhU2VopGxpBPkskzeKsl5936A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areen6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PESt00028497;
	Wed, 25 Feb 2026 15:37:13 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7hfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qaD6dvSKgEoGbESznXcT03/gs9iTzuhrHNJMVtRWY63qEzTwY+pvXEIZDWgkjzqb0kv53jdmPdT5FxFww+5LAeAcx6Q/yU4RAXa8iVCoBf/Vog4F6QQAO4rCS5GureogoDLpP22fxi9/Syi5oP/ACnVrh+HanPbzKrjz0m3Bh5l7gqvgZHtWCfkPXK+s/cN164J5593b2Ot73u4jz3hduLoIust9FWPuK9OTN3D2kzij9lNWzxpCKAvWqA6LJWk6Chr+PdfLN4/F6QQ2sSe9nso6meuL5ZGa4LO8iZ/P6kwJQMJXHIzbEMf4d3bGfu4A8jJDKNOY6HNjvBO1JYE/vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZ/Tl1rNVhMydW8w2+t628I9KWRFhQk+oIhuZ/AxxyE=;
 b=pjxvSocXQcHqKz/bFL5z578s08MxyOVeXyw+Lm0oTLjdOTtXtuOzADHSDWkpph81NaEy8JWkIaw13JLTZ99NruEbWYw5vYM0d7Az0GWXzGTEZq7IsaxEa+GjVyKAyTiTQKzyYawkaj7CngsTisu9E6/QV2a3xtHauFez0Q3+MLubIvC3B3jPEC06MxFD40lu59wBz8JRyiIWv2de/391YwsBZwG0IJmDg5IGIf5cL/ub/BhkcZEVX4uGgpNPizmEIE5wZus8ofh3aC67WFEzOj7YVOQKMAZOtzb671c+xLoSaOWtzHM0jq+CkLvXYvxFhGaNnDQ7bvjp85ujVXm1eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZ/Tl1rNVhMydW8w2+t628I9KWRFhQk+oIhuZ/AxxyE=;
 b=IifeqxjbipwQtyp5xSOU56FIXnH5Gk/rxotfND5ICc8Hr3aDU0ZwBVh56mF9WJXp7GixUp72Br9BfwcrbTppSPhUUmxDs75sDPJbxJMTbLGA050WxB4n/IjX+FgY6aAlWYNq7f57WNGqXoTR1ANjhSA0r1PDJlsbEcWIyqs1Skw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:41 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 00/24] Native SCSI multipath support
Date: Wed, 25 Feb 2026 15:36:03 +0000
Message-ID: <20260225153627.1032500-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0031.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:348::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: e18a4b80-d7fe-4ec6-6ee5-08de7483aba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	klLjOxvRu0xG3D7kpv3HAL/XOeTVlpGw/S2V7Z8KfTeSc5jaBaaLqG3iqsiaxA+mOuVNx5vIQ2eVF6SUZ0YM4VGQz2uoAvmlh5MSX5OkVrZNJ8856micsvJ3g0hbiKo3FkzGJwWuKauZ2KQZ4fIJN2r4IRMCtaCuIhHW2WL5zEJFylE+0mslSXlkp3mHZW70v8Vu1Imq/qx15CldpxntuTKarCfkbOBtakfL33X5vLILoRyFul5+wD1uwCCiRVp8YBs79/yUraRk8CQEBJ2nZw0U1vjyz9RPvI9LwFcg5FZqsZD7upgx/BTOtI9HBRzFXVQG7BvcJSdufPcCdAoQ7Px8QvsSzp8DwPlVbXn2kiOe8XjITRaD3l9+vM8VBX/c95NWO+0WZZXNWfvrwixnGnCFqU/x8t++jBXsHTi42pU7gl5BpWnKBkpf2MDkNO6N8zdUyV6K+7+OEwBLKhyVi/MwCGBw2/svQZZfaLD/BHmoDWu+tUmRsdpyqu2y+OaTsVss5b3HZT/Iw5fZC7yzOP+s0wz7ivhnlMS1AqHJF7EY3wNWrz4KSJZhu/BLxEJLsMp9WnxGZO4DztOxmWKEEQY9jqNdW+2+UKWwVVcM2Igk6/Z6ph7lPVveRLIugH65A7kAD5iOKwD99N0C9Xe8Pw0FQ1XqFhO0PFlEvLZpfbHk+ts/kihbfp2JNVRuJR6fxjEOPiKnP8gCMnv/cFdzjzb3pmK+AiTBABPSjlt6wr8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3fjJpdaatD6UOzFVHjSgbuCxoi1BlfvgClsB6XbpscrvB+60VWVNuYTnRFhK?=
 =?us-ascii?Q?Z0ajQ2n90v1cUmmWzmv+rfeFeeQovxxFRt4mKdygfDL5tVepAR0BpYKI3cej?=
 =?us-ascii?Q?FSnJL7A0/0c2EQCAuVBm+6WhggSDIJ8ysXvGp4HcIRVgNxXfeX6qC3dGYWcS?=
 =?us-ascii?Q?Edfu0+k4+kaChO3wEOi98m+4cC05sq7LQX1xFSJ1DvlOW7Hkl2yCe/t0xsGX?=
 =?us-ascii?Q?wei9sTQurNARGA5Xi/95sg29smkRaTdTDAuMmw+8Nr1MFzmyJCP/FggFApEm?=
 =?us-ascii?Q?3TKXJmE7xZtS2K0DPMvjbSRFodvzH6UEgkf25BaigZZo7NHMd2qiiBVqaw1N?=
 =?us-ascii?Q?M6FFsgplLOcwLKuNb8fyt7dhSlPDeI6pfBACQhPxVqxPH+nkpN19KQpfQj/u?=
 =?us-ascii?Q?68qbNnRPpFXQ0sTlwR41R/Jvy0Pj53sekPfXI+cDwcsWQjnXbiU5BW5uOvAQ?=
 =?us-ascii?Q?0SA1ozi1i4yggwQEu4OqGWo7XKIcUZdZOVaThEB/IyXkJhLMuTwscNRrthmy?=
 =?us-ascii?Q?WhqFSeQ4pSosL+RK/G+13LLv7hvxghBRf14XxbT+r7sl0fyy536BgJutWeH0?=
 =?us-ascii?Q?hbmsLnGdw408HtKxnWyFWpU9bUiqyvWA0vUZavKyckFWMNn0lgoGIjKgXCBl?=
 =?us-ascii?Q?Zq9HfXajb4Rt0YUQabQmx3gEB6v2XHg98ou1QwjCT3ADpN2dHDQrxxmk9gMW?=
 =?us-ascii?Q?UGlJjXywW7RJHE/gUJV4CXUCf6O02X0CBeVYoP3fjhO6cLWU2khm1M5G7Lqp?=
 =?us-ascii?Q?iX+f1YW7nyac2ZYRnazHxw2/VdE/40uLVwsDWZHLmNHgLafT+tprd6/oOjUa?=
 =?us-ascii?Q?C1lzxl8PXv7iCfQ80lCuOns+2UubexXnbrHQVx8ANXZwuI13CvNFYnA0ZD6K?=
 =?us-ascii?Q?VCegToCpyW1aWabrG8NykuODe757ZHSGt6+WsA+Hig67VjcpCytEyywMlnyH?=
 =?us-ascii?Q?z8jyd21Zw7VNEY2le94ymeBnuJrAsV8bvKwjs30kq4E2Ph03wPIhFLMOVhSU?=
 =?us-ascii?Q?JnGOL4gPcKY5LU5ns+ALcoxfo4Ka+yhLdiOSekkOswcnPCUjxOavNxOc9/zD?=
 =?us-ascii?Q?Ac74TpAJkFH4ETfUC03uxR/NsWZ6h9FNLUM2ZO2bByIVuTASeUWqRj9O0L3Z?=
 =?us-ascii?Q?nv7JtXW/eK9EIxMDLD99gURs2ZU94EeD4ly//4c82EVu7+SVmGivQm1WtRv7?=
 =?us-ascii?Q?zVSkk+aFw8FI1CA2mA9JYljs29f/9DTsDX6vx3/y5bckvxzaeflRA0jFOBVR?=
 =?us-ascii?Q?BzAv1t1gh/VkDZVSiZdalQ/Pmu1IefkayC9ytQ468D4Yr6no5ooG/BFhYcv1?=
 =?us-ascii?Q?y+XAKGsXEkYFt0+1cpN+u0WkxIvl6rvLrEeNZIioM1p/IZ8avltrZ2yRhIwI?=
 =?us-ascii?Q?h0DxNQE15M0S0B8cnx/v5qL/7JlkoD1lToJklrpo7FaWLQ72rsoNWAbjm+IG?=
 =?us-ascii?Q?9ZMzsFyM/jMXQYtcBudFVVJzq3Vmu6H/XDvoS0DH6ff2jbzLzOBd99hSF/k0?=
 =?us-ascii?Q?zDeQ50R2sbWDqgDuO5GI4gWuNKo1ODzlS08XKZmxvpepH8lP5P+ehBFwCxtQ?=
 =?us-ascii?Q?bQA3Mrxtl0L0JcurgUyx+aZS/o51n/ubgGN24cs2lGNTHFfcdMECFm61NWoN?=
 =?us-ascii?Q?pHy/hHi4CICHzIajzdONSrtCdpgE+o8XK4kfwleYEvZgzK+g7T5Cv0GBuuWe?=
 =?us-ascii?Q?J7/uYo3jRhTEu6vDSFxyOgeajsAAavcCLP+369TcUQxah+Tp/TK1jp+Wfygw?=
 =?us-ascii?Q?AZZeHSsVXvOpTBMd8UyxvEt4g2UQCEs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eoW3vex/MG0W0G92WiiRQmRiQ+r2o8RzCfevX3VicX3vMxxZHzNIFIQJg6ycj//+oC6qdWarZUSx0jb3NGCAYoYwCD8rMsW3w3QqYLfW2f9Ooa70JnQSvbZ3LtwlBRe9RuNOZ9SzbSQPX69DuGuIXUoe4UUGBFzMLRwV/CAkOEPBVGe9ZwAdCHaid0fv7DqryCTiUjXWDnv3QBHKhbDMUnWRXNpxU8++Q/6IOKTnA8RgmzxxH0T/aPXRlmH0zKG/590Tmy8maRNKE2YKfLwUD5nnytSfarqCGzBPAgUbK2Pe1VPIAgoCk+6s45xS4gPqm0OfrcTUAZWYTgIO0XO/hHg6up32wHDEmoi7REysSc5qxS5ov+/fXnWQjFbkF9ESZUwDTAxJJh4TM7JXtbu2tp6JM5jB2uLKtQ21EuNTguCFTVXybakTLT9sPbapisYlBTu5BHku0z5yQxqsbnw+CVVcZC3XAuL8ntAYimRoVG8ighG2RVmMtX9FgX6929WEcgvkalUCHRs68sf8HzTs1Ut9bCxPAiZl2D4j71nGWdnmVFBNi1OH0VlBzTzv+KiGlZr5pybUUuC88og5+ZGvD3X1ketT5c60VD9VbV6/Ci8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e18a4b80-d7fe-4ec6-6ee5-08de7483aba6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:40.6104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NFi5LEFdHhLg1zEQPnMkHHFT9Qef2LIMPmxS/7NophqbFwf914OIXk1FAHNk9/BGo7lNUSxjYcf8Ph68VLoQWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f172a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=I1szGjnkSsxvwyLXp7gA:9
X-Proofpoint-ORIG-GUID: YG9eAZi_hNXeVUObdUG7xn491Pq25VQ-
X-Proofpoint-GUID: YG9eAZi_hNXeVUObdUG7xn491Pq25VQ-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX0p462Z1aZkic
 I4CBRdPOFn0rAhIKpKn4247vKxSVHKWcmbwaXDcbxtIdaGM/zDbUbutVLECDnadEjQTp42Ys32Y
 rmo433xBVyU+EhS2TbyPLwGL/zJGQaywg00WRoZMugz5RlTNkrNDmntZof4/CygKRGi/8jD8Vnk
 PUgQdtVH5UeHjoLc4WMav19E8jwlpbwmplWXUAMuqeVr/8EE4NBzFFI3BNW8D3p5Qgp04NHtPm9
 4SdEv3GAaHD5gyDyYbANE3ksCH3sr2ep/LNhRw8Cqk3VraISasQ7zGiGPYiGyGucTkYNBfp3hIf
 LfpVHpzsV0eHZbgLCfcriseSW2w8v3zRbBntAH50rTilaCALG7G6czTu2MzE3lxKpXe+ACBLm2Y
 2MveZoPa6CWddwzgHcyaAg3u7823THSwrYglbXYtvPkMzfuv6ulyC73PGjiHymz/QgWZHzzZQqg
 Iu2qyD3n54udpdlIg8A==

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series does not support ALUA. That is because the initial upfront
work here is very large, and detangling the ALUA support from SCSI DH code
is a lot effort at this point. ALUA support will be added once consensus
is agreed on for other aspects of the design.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 wwid
$ ls -l /sys/class/scsi_mpath_device/0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/0/wwid
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

I am not too happy about the naming/indexing of the new devices, so
suggestions welcome for alternatives.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full.

Series also available at https://github.com/johnpgarry/linux/commits/scsi-multipath-pre-7.0-upstream/

John Garry (24):
  scsi: core: add SCSI_MAX_QUEUE_DEPTH
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: introduce scsi_mpath_device_class
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when decide is blocked
  scsi-multipath: failover handling
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: add scsi_mpath_ioctl()
  scsi-multipath: provide callbacks for path state
  scsi-multipath: set disk device_groups
  scsi-multipath: add PR support
  scsi: sd: refactor PR ops
  scsi: sd: add multipath disk class
  scsi: sd: add sd_mpath_{start,end}_command()
  scsi: sd: add sd_mpath_ioctl()
  scsi: sd: add multipath PR support
  scsi: sd: add sd_mpath_to_disk()
  scsi: sd: support multipath disk
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |  10 +-
 drivers/scsi/scsi_error.c     |  12 +
 drivers/scsi/scsi_lib.c       |  16 +-
 drivers/scsi/scsi_multipath.c | 789 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h      |   2 +
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 731 +++++++++++++++++++++++++++++--
 drivers/scsi/sd.h             |   3 +
 include/scsi/scsi.h           |   1 +
 include/scsi/scsi_cmnd.h      |   5 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   8 +
 include/scsi/scsi_multipath.h | 156 +++++++
 16 files changed, 1720 insertions(+), 40 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

-- 
2.43.5

