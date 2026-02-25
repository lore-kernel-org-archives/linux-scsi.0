Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BAA36A006;
	Wed, 25 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033689; cv=fail; b=PdWuDYmBlaro6bU7UMMvtSScUbj/qFWc7bImTVJ9h0suJsE3fHdVwzMnjrCOkZrMm7sn+V9JR94d+/TbL27FFqujmdPdaBnHwqHKwRTKQ9lgwaPDEUj/heeHh+NCrsEUYDyQr+6Ku4OELMgScO0FYGdjslhk11QqIiNVxz+3VfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033689; c=relaxed/simple;
	bh=8ug8DxoJHvDOuNuFDRrcraslloW76BUQTAp7XkUr3MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=imhPpo4U7lJ2na5oySbwHSDwknrGoraCAWCEAQvgJ4DOpGSTpNsq2YDl6Z7Nom70wstBCJIej/DiMI373zNXOe/daBoHqX8cjI1MOTA2sKglZ7E4b/2MwZkG6CDjeC0hA+NZawgfr+/VfuBk9HdHesuS2u5BZmDPrPOvmakRaxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mQKjk6Ks; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=spKCRMWh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mQKjk6Ks";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="spKCRMWh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PA19vI4019364;
	Wed, 25 Feb 2026 15:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WY9+DSmr6dD4IV6pnHm2HbrQaWIr91Df3hFgiBaU4ng=; b=
	mQKjk6KsuP4cta+07oHZ6V4fc/1s0g52EkBHXrj1eOg9UbgoFkxsQRedg01OI3nf
	tvWYzZ+mJpgio3WJn9FKoT50IXDKH859dFrtyosRdjv1SonHHEnN1TiRGKSaFkkQ
	Qlp92qC0yXk4CwDnS9C/u5GsOW62dG5pNMu/+RY4GFeydn8QLVpuy8f+IhES/x36
	AJnWHyf4TgwALTvnoVuMONZ8GGGIbEQgl5AoZXV1QPItX2DWiXvefntpJsBK9STv
	rdr01gfd304laVm+c6WvLvKRtO9Peqd4w/UnGgpTvX5iZEwTGFoY5aHwfV/ugZTs
	XxU2F1dM1WCMLeE7Woag2Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a06gwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PET33a038418;
	Wed, 25 Feb 2026 15:33:09 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfkr0-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IO8v6ZZSJNRAhLUOAsPeMhWpTsjM//kUMfWHfij32UgsatjUr2U6B5rSfQ+w8Wztt+aQC7JkfiW8kYXK2+ExggY1g0icBRNOl9bafgU6LSVXq0e1qwoxBta18bTproDpOrjrXkxuezKiubr7xQQR1Al8glHvVimqdAfcO4TBI+/jKZio1QWcIAha0Gzu1Q/Kbn6DdJOMXrHubELiHl+6479EqPuu2GqeoTeGSjc5MyFeif52uLzscME3NPZfIdEOjcoxkAitJkVBcd1rjL60nhbtGNIVzKrmzDr/iX7ezjECF0Dlr/Pr8k9nHd6A6RvGc6iUhtpKLikqFY0UjmdbhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WY9+DSmr6dD4IV6pnHm2HbrQaWIr91Df3hFgiBaU4ng=;
 b=hmaiLiE6+rUHEt43z3jw7d/CbhpqKVf2KXlrdfBY1ckdCCECvDSum+/9DPWHwz/mn4JNZ/i1DRvUbs9aNx0kE1xEZrk7l8WDJSAcY2Onbyf5AMiwVIbtaTHBPmblXkN/kU5uL90xt/xkw9x6FfaxDGyZ28A2Y5Ol++mRPpYLMh5Xev0anztY3g3UL78yRGTamkZKJRjXIWJiYwe1gJYK7PlFcMHs7h0kJxl7zf0ShQd2Z3YRXJopkhyIqlEeW6D+zephNmIULjXIjjh/pGhAtqPzaqZnEzcMyb7yPruDME0VdRooKzyxTMFGIl2IijSgD2g6xEZgXOhD/T6E1+c7sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY9+DSmr6dD4IV6pnHm2HbrQaWIr91Df3hFgiBaU4ng=;
 b=spKCRMWhRMFhef4gf4YpivSlTeZ+zxX1/P5pJMHaQe+u3iiWRGGZcn/F2OScnfmK6pgj4KggRZRTHUyPcgF+qYwiSNmIsuqyRJYjhqYmn3pCJ08cbvo6ZTrp8gyImqmLbsWE6j7ijA6LrLGXWbW96TbesRdrgEMQfhBiUBVz5Ws=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5017.namprd10.prod.outlook.com
 (2603:10b6:610:c3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:06 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 09/13] libmultipath: Add PR support
Date: Wed, 25 Feb 2026 15:32:21 +0000
Message-ID: <20260225153225.1031169-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:610:11a::24) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: a56d918c-fabd-46a4-4407-08de74832bef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	T+w3g2EyJbFmeYU7wQNGJ+Yi7T4KFxbQFiZY5/k0+JFSJMymVEVLEsEVTzQIXiLRLa9GqzGrprPlRd7feta6ZxVfYgkBrVJ5606vGl1WY1wbDWZa/BUvDqr/JWinihJgt3xdkzEErT3UgrpLHH7Z2zzd2pIrX8UymtnUOsDi4OhFd7ny4SeixXW1kRI5iIyJYsINpYJJ3Lku5bNt2s2/SMHK344dEm6aaCIqbABQoNSbTcBsRzgb3TAPtAcvv35H3yCP5hude0teY3YWK3WyDAWoH2Mj/iEEevDPI6SPmnwIpNk3iH0jY8nMehEybRzYini98ifjEWaRCE1O+CTuVaGzBrkOVWM2xI6jZEgGuryPMnKeqhslUKIeB2QxsJR6sB4Ghs5GhajqERXBYBua2IhL/RhCHVApUE12Ege+ehPeUznS+OIMffohw0oXuf0h0Fj6UvSO8QFm4JvCNbS1FwN0kEAhM/+tH7u7Io7hOXJU4pnqrcaPOWeDEUc8IP1tbUafvwmoFQFvJSB6tKTUr3tmfZWl2JTOn/CGNxaOzdik67i+lwZ1E0qY2WsQ01NhoWuHecwr+q26pAmqk20atJKNQFQbaUBmZ9QVw/fcXhmpTGRWxlbCtRpAK8woAFGfypP07z116tN0fKJc50zdX/iblJP+RgJSVrfl0GkFUYOkhOSkoWIugqHMUt+j9i5O4S/6lOOuevldzixkqBexLw+ZlH12ScKQL39gcTYj/64=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AoT9zzdflGzVId04zEYG6R5+/fOIe+EU/PhPEjLeGfURVn14/9lBgg5xUJg8?=
 =?us-ascii?Q?KLSaHsBVOz0fyTQtwF16nndOZXzENz8urI7iwnaYRX6xDZxL2GIa+Iussey+?=
 =?us-ascii?Q?8aekHD2GjwDnX6R8KofqG8BRowbUM/kp8u1eXhvV2N829/Jvz6VP9vKLBPl7?=
 =?us-ascii?Q?qBpyerOFG8ZNGIzyY0TJSefJplL+yVO/gMo6fSQUJFor7ClxQWBB7PwIJ73n?=
 =?us-ascii?Q?vvNCwdOAUaghU6dYfkOnrHGZBGxG63XnVgDwDK2NAJ3v763IkY2jVxi60mVB?=
 =?us-ascii?Q?QRlcUPS44ZI1YqIcvF5I6CZJVH5MB+bj/MIpZz5aAn0cmR95uZCVmbwljVTN?=
 =?us-ascii?Q?PBSc57pre1GiDbsXkYwVUa5B0mQ7Y1JQLdb8BilFWwoqzmfr9Dm1gYbaFpVT?=
 =?us-ascii?Q?Yo19f7c0/Sc/S6Ds7178XQ3Qs/J+zTfTmTiNNRDb21AjOnPRHcVZLMu82uSz?=
 =?us-ascii?Q?hFx5Oi+D4JDJeMRYUhlbeJWAzQi14Lv3Iej2gPsXjR+KXuUSQzeIpxLicECx?=
 =?us-ascii?Q?FySibPqYK1hjo1OyipAYW25CUbDjrqYW1NQiDpWsQukG9DhefBViI/umpcD1?=
 =?us-ascii?Q?Jy5I3OUrtYhinkVbHtU54rX7KHsiyEENy8232LoxAfodGhbdNT1xcKOReNMx?=
 =?us-ascii?Q?6Vm55ZkVFak4r5m+CLVduc9vMKQV3+w5CMcGYVTLN5NP1EXoDPXtD8vefKfB?=
 =?us-ascii?Q?OlYPu930zeVghH399Bn0KkAKya5zUmFUm+R/k545TxoEr4zHrs5gaUiNnqJY?=
 =?us-ascii?Q?gP5zhM42/1r4I1ejp8g8Ft1i1B5LmOyaaLaG2Mev/eBY9H7ZfW7BAUIhgmy5?=
 =?us-ascii?Q?CHQari6cY3w288al69ru8hgJUjAzw/qsC5JdapkoweCNLRddQ9dN2zdImpTt?=
 =?us-ascii?Q?5HiZ1aEot8VRR6bVgOaMom8srhhsntCbyNulo0o37iUh+GRbQ8Dp/MAqM42k?=
 =?us-ascii?Q?p/2gZ1tkHBCgljSfHpnJ79TXYNKPQCj8cqN1xfNpKtxn3nLgMOMON0Kv846S?=
 =?us-ascii?Q?ogHvXDkoUlMZh4kAIjCQ8rkQOgnuFblnUOz6nwugaVwJ67UfYf0br6VWcHRq?=
 =?us-ascii?Q?e5MLcoHOhVu2/+ySVIYPv4HNr0pCB2vCDBYnR7zKXrl06K3E+byvqcC8JWoK?=
 =?us-ascii?Q?gchnZaa4e30JFrglsH6uXoZCnG9V702e4h4JNQ8m9NV+9q97uS5cyzk/Gr0C?=
 =?us-ascii?Q?9kxBGsjr8tMFFnSl6Q3WEOwsHSGhKKhuIdFnmroONFFzygUeWBhXyXXu3YPx?=
 =?us-ascii?Q?XrIyBFRMJ8JSkDsXAE+LFpTkSJo/lDieQBi5uwaSRzMzsg4e8txznXq3VXMM?=
 =?us-ascii?Q?S1ARPuERlryRcFT7WERxn0D6RTRRgh8K03FKro6BxU+An8uok+rE0xD+mYEA?=
 =?us-ascii?Q?Ix+GnvIWtbkoJ8IXW5AWdUZ51S/gDoiJQ0jGg1uqLb0wmsLLiABt4oeM5m4S?=
 =?us-ascii?Q?x3XXTYNUkOACTkZed/TLREJ4dvoJlF5Wq/f2YJSGgXBN+YdiPHGmYT/Lde9O?=
 =?us-ascii?Q?Z+qFm8+/Z6GDUeVg1YTwvH4tRJvn9o3rYcgwm4311rlyl5jcJucBD/pNW1au?=
 =?us-ascii?Q?lE/+TQWbqFjxmAnvzIP0IynUUJW2Vs2fiaIj13cxqC24dyek21h2r1tT9DpD?=
 =?us-ascii?Q?eD2boH/xRHD9G802nzIwKnm92bj/NZGR6bEDdSAvxdj++LB9uQ5vd0JOuJR3?=
 =?us-ascii?Q?ZEsiC8Y3cufjd8wjr4iBnjM3022obHkpUho4JfyMSAvJMktS12q/Tv9ACRvN?=
 =?us-ascii?Q?AGLEGRA0o7ZBGNfPtTofp4O9MuIGMpM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pAwUAQqrgSR2hlBW5F3fkYB4MVcYl08NNyoljBkig6U7BGQPVNHI6F7IvGzk4aY22plyRWn87i0qb45pbLcAezaLpwGn3Q+Lxzh8DOUg7KcSDD5yey/aHP1WZfVuBwI+oZAeOG0vTbnBFpYo4MKKCNeNqBPU9Zd5ix/OL2PRwApv3VB0gP57IEJEVs30O5z7Rpdoe5PHbMETgr/XEIlak7DMM+7COfxU6if5FRd294UmLubnkMNSe4QN+g6rHTr/wzEB2mua/pPcmuFwG1wqvheiTyGzzaJ0e2p5TjWFU11hXceg7KB6FGyl7Oss1IGDyzSqLHJ2h3ywvCTLMyvD7fJMQAR14pb0HNg/x3DOy/UprvApMpyt+3LePFmMhofSXYtoIbssIzs+fbnWVopP+qv1UWjafr6P6RGDx9TZxbJUz4QPPxABGOwyZBt2im+TARhFSrTSG37gj8jNRTJR+gPDmsCTw2DXaIebebhm6sFE/louG6PYmk4pm+vH8i2YxJrphlprBSNTPUr7CANcjN81AR1Do8HufePR1+0XzTsi//tvJINHtKVF1o7lBOCsIWMTkSsMNTsCcqF3xqCKZw9to5NPYOuWw6DKTdQc8pg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56d918c-fabd-46a4-4407-08de74832bef
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:06.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJTXTCuXaHDdr6IosbRGxhU5izQrP8LliY21QRMArNvk6mMhhTQbRESY1oVb2LUt5l9RLPdKGZv72SFCYeN5JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699f1636 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=1b2vl6qibDn9V8LZfFgA:9 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: vI0NzMzja29FrAsWUny05eEEJ7o43KZ8
X-Proofpoint-GUID: vI0NzMzja29FrAsWUny05eEEJ7o43KZ8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX7XX7pI73xXsH
 zhIuNioQDi6MkDqcuUEzx4F9XKwVL/1NNVoTXlywXOuWinjJnlBSn6tBuiW5Uy7cinVK4bWbQ8M
 2vxGU2M42Ve+6uCY0sL6Xskl03ZKhYVrtpIIbl7NMN0gHXRp6NyunzQjhrtJRs8kD9H2rsJTPtU
 RZZBKKR1epT8IR37CuALS9BU0q7qpnqAHBO6Jp0UdDJjYOOZVYLgeirsFa7DLkOB0ftD9+Rs/wu
 qJhZw247LPbYKqeNtr4YRJYsoFk5uWg92tp0V8e/V5unRqX45FnXfkH0WB+o61kYEelCPZeKtlR
 /ObRNBWr4lFOTOTA6TwGA5HfI+wEy4m4YR3KMEHRmvZQiRxShnUizwLyec1opJMSrU+LsOxRx9V
 ctJzUY5REboUMVRPhSz2MwZqWRAk31CN4J/nZ1bKpx0+ULpUNxytfWMjqfDxhCc3jm1B0C3Aitx
 QW/ikbbqav7wzpsd84UePcE4LEL3rpYx4eL57Co4=

Add support for persistent reservations.

Effectively all that is done here is that a multipath version of pr_ops is
created which calls into the driver version of the callbacks for the
mpath_device selected.

Structure mpath_pr_ops is introduced, which must be set by the driver for
PR callbacks.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  18 +++++
 lib/multipath.c           | 146 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 9122560f71778..454826c385923 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,6 +5,7 @@
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
 #include <linux/cdev.h>
+#include <linux/pr.h>
 #include <linux/srcu.h>
 #include <linux/io_uring/cmd.h>
 
@@ -48,6 +49,22 @@ struct mpath_device {
 	int			numa_node;
 };
 
+struct mpath_pr_ops {
+	int (*pr_register)(struct mpath_device *mpath_device, u64 old_key,
+			u64 new_key, u32 flags);
+	int (*pr_reserve)(struct mpath_device *mpath_device, u64 key,
+			enum pr_type type, u32 flags);
+	int (*pr_release)(struct mpath_device *mpath_device, u64 key,
+			enum pr_type type);
+	int (*pr_preempt)(struct mpath_device *mpath_device, u64 old_key,
+			u64 new_key, enum pr_type type, bool abort);
+	int (*pr_clear)(struct mpath_device *mpath_device, u64 key);
+	int (*pr_read_keys)(struct mpath_device *mpath_device,
+			struct pr_keys *keys_info);
+	int (*pr_read_reservation)(struct mpath_device *mpath_device,
+			struct pr_held_reservation *rsv);
+};
+
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *, bool *);
 	int (*add_cdev)(struct mpath_head *);
@@ -64,6 +81,7 @@ struct mpath_head_template {
 				 unsigned int poll_flags);
 	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
 	struct bio *(*clone_bio)(struct bio *);
+	const struct mpath_pr_ops *pr_ops;
 	const struct attribute_group **device_groups;
 };
 
diff --git a/lib/multipath.c b/lib/multipath.c
index c05b4d25ca223..8ee2d12600035 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -472,11 +472,157 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_disk(mpath_disk);
 }
 
+static int mpath_pr_register(struct block_device *bdev, u64 old_key,
+			u64 new_key, unsigned int flags)
+{
+	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device)
+		ret = mpath_head->mpdt->pr_ops->pr_register(mpath_device,
+				old_key, new_key, flags);
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (mpath_device)
+		ret = mpath_head->mpdt->pr_ops->pr_reserve(mpath_device, key,
+				type, flags);
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+{
+	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (mpath_device)
+		ret = mpath_head->mpdt->pr_ops->pr_release(mpath_device, key,
+				type);
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (mpath_device)
+		ret = mpath_head->mpdt->pr_ops->pr_preempt(mpath_device, old,
+				new, type, abort);
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_clear(struct block_device *bdev, u64 key)
+{
+	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (mpath_device)
+		ret = mpath_head->mpdt->pr_ops->pr_clear(mpath_device, key);
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info)
+{
+	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (mpath_device)
+		ret = mpath_head->mpdt->pr_ops->pr_read_keys(mpath_device,
+				keys_info);
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (mpath_device)
+		ret = mpath_head->mpdt->pr_ops->pr_read_reservation(
+				mpath_device, resv);
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static const struct pr_ops mpath_pr_ops = {
+	.pr_register	= mpath_pr_register,
+	.pr_reserve	= mpath_pr_reserve,
+	.pr_release	= mpath_pr_release,
+	.pr_preempt	= mpath_pr_preempt,
+	.pr_clear	= mpath_pr_clear,
+	.pr_read_keys	= mpath_pr_read_keys,
+	.pr_read_reservation = mpath_pr_read_reservation,
+};
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.5

