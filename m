Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAB73E9F8D;
	Wed, 25 Feb 2026 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034046; cv=fail; b=AHvijllfUGohMoO5kd/WZmz0TqU8pXWNxP1wlA2KYAftJa+WTS51LbPojocr9Hc8nLhHEWJAekBdFLV1LolRsXXUVqBG+rwLhZhi48q9P1IzMgj7sLkGgQVjUR+40mw8qWPqy1VyTiGwBquZddL/ViyY+kWBlQjKcV3rh58E/AM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034046; c=relaxed/simple;
	bh=f1AOHp8yqgubT0tFiYGGFno58A84kWfEJ8L1DxqXsHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L1aEOYXmQudGpzbyJYHWaRhGB8Ak68Q0Cuh1FKNY+4NfciOYYbqk8fzk77lWGQXsFdvUNk4xBngoWEcjWHREanznfKaNBTxFDQu7ESnIAz6Y39cO/lEqa/budWvDsE+Ig0ZPMC4cd7pzS0l90bpw1du9e0DeK+kZi9HDD0PpigE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BpqhEe1N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r83ZQW7b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BpqhEe1N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r83ZQW7b"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PASJNP817877;
	Wed, 25 Feb 2026 15:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cP+zhrZkUAu5wNZbMTyzGLTQcPnbQJbSBS6B9u5YGX0=; b=
	BpqhEe1N/lTTSlfiF8RE9Mc7bw3M+6o+Qop6PHmfk5WK2H7AvNytLftasnc82zja
	LRxnZKsUqxkZXnP7fTHLMJjK1EcwIPaYC5YkWxXydu1oVe9+S4YyTizeHJPuB00k
	I0YVfv08TeoyZM9vkMuAHxiE2HjHAygXt6FxJwr/wzCwQDSQIHnaeDeTmK8Nurum
	60cMLAFqTy9LlPEyvODXAmNghTf48+va3fLXfvKzda9h/NMwznIKeCE3n7zspqkd
	dkfj1tpkqH43ggMB5WfIuF7N0FG+p69MaF1u3sFBPoiVRS7JM0s2IegWiR58JXbq
	aAbcPF4W6wUUVYp+cM4QoQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areet7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE699J027955;
	Wed, 25 Feb 2026 15:40:31 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35g8xgs-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vl0tAlO8Evwnym0WnUodbuqyxAz0UfItP8XH+ZxckhcRynEGIrdVJy49Ov4J+82M7hoWA1JcHQRb2ZND7p4QHv+nlCKlKexE8n5H80KzyZxc0ALfyPY6Esg6KOf8lfqkb+GacWGURvzCtm6okyDereiuxoqH8CQ6qWrJTbdv1VWDAKalOd4x6FJLz4CbG1d24xgtNuSRk7MQjFKbJv3sIjhbd4WlxU3AkQlMoVjitF8H40y+/gnlgM2cgmfjJPktrk/fcupQLBm7LbQWQMbGsq2UmdysLnaCdf5sfeVgD57ewYHRYV5eReIo0dW2TsiBfRXdiR1UqolDiE17BoBBsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cP+zhrZkUAu5wNZbMTyzGLTQcPnbQJbSBS6B9u5YGX0=;
 b=Zc+OcII0ZDoO8ESxNeVUqMPjaAmGlu/n8+/EdTTCnS+FcUTQp5Y3T/G7mhjT5GLEuvZN4g5RNLWh6ahqeMsEINDzE1MVzyZ8jZN841MbXVtkE6JWMkqL5BCa9HvbezRNYCBP2/PooCfY+JRGdtJkh9mRffAz2uRs7MkiuSP7+HSJwW3LDqyPpKbrSSH3ZsuwQRD6/ewb5L7P1Jb6FO9r5BXbKQVMGhKGWhikiqJgTWxbfpKv8I0D8Na+WgAFbfqVuSsVJ1l2OJzqIq/OEBw4OoTpKN0FLdJuTP/sarDBBiIz4HYqeTXvhCpt+MdYgiwEY50Pq+HPRhW+FtFl2s0Rug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cP+zhrZkUAu5wNZbMTyzGLTQcPnbQJbSBS6B9u5YGX0=;
 b=r83ZQW7bmRK2ZvmGUWkscsUlaPx6GdGXn+2n63AVAhU8x1c9XsGxCOQT8nfRMLlRHgAx3qg3NvC9MgwA/2Tu59bBfhmJLnJZbm1UePIq0vu5nWL2s4XYYADD/bL7+PfOzceV7Rlh3OHNs5uTIZltOQcBtbsUrct9C+vx38khj+o=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB6319.namprd10.prod.outlook.com
 (2603:10b6:806:252::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:40:28 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 04/19] nvme-multipath: add initial support for using libmultipath
Date: Wed, 25 Feb 2026 15:39:52 +0000
Message-ID: <20260225154007.1033735-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::28) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 9318d984-6d92-41f3-9377-08de748433c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	4wQkNAWdc0GZKL9Q3GQw7BtPoVxCkBIiDH0jRlzf+h6v9xzam5KrUi37totqM5TSlkPsii/MEcO9+iFLlzY8PapXynd/YfjoiglEpZeZrpCXcQvMRSKIpPV4M/6UEMdAwLA1jF7FGrDXEWdYOSCigkZNB8dCb+FkYjoYIpPFWVxwIjt39h4JuEd06q9oxs9lTGD8soOyYU8kjhHyR2XnVyvGYvZGNyUgGMPhYT1QGZ0Rltdv9BPZa45ZMcgLACtijscLK1Zij1l/SZRzpvTYesXFHxgYpJLE1NTPOFd561s28kUmPbflDM/+rBVMxdN4VZtJdtpPyR8p2cVPHQfLFlvOUzUIXQZ1cWhe6U6UQ03nqjNqAt32j8op5QgHTzD8uq3nVCY1aLb7gly+1of89lrQ8kx/rI8//5hgb2BZLwU5fjMifcdO1v66181MbJzgOokULbzgK3I83TIx9+edlekMDA9w6/2t/Fy3xweQblk+l1F1Rsyi6nbmbn/nFdFM7+QUsdhFRes6AHZsAxowZGhFvzP5Tm4dFQNh5CaqIFHjlGNbSRjvuxbmQ9WWPDj8QUBaPQSfJ8ARXEWSp/L0LrPlK0e0vANNp9CnLuAPaaTbJrYBZSZxU4AkSTYRN+4+k+4U9K5H4V3lHEQoDJSr8YLnIdzGQ7GLI6ydvU8KtvUVjIQd456B9Hz2e2DuoAyJdT0EsMqHTDxXnQcMjRj67glyYPoByzNX6xGAYzcDXFE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GQTNamHX0NAymZ2TKI7zNQkxK/wmuR/nprxQS4KZes7cWH0sO1p2iWNaB7m9?=
 =?us-ascii?Q?/icaet3iKS6vNoA3YjtDEELL3Ha6Fg2SZr0t4kB9OeCI9xp3vLOuKzzLjv1q?=
 =?us-ascii?Q?r55G3AWixklGupjE3t/Ka5tbsYg8asozEnIdcT3xfpuEDw2X4Eev08OPrl5E?=
 =?us-ascii?Q?V9e6niBmzWrIsiFSy2y9it9di5kYlYofaLFoWTEPDMm2pHkYWhoiEva6yIYE?=
 =?us-ascii?Q?TPAh2OExsCTblh9LA7ffYaQ00lsQljx8EsoxEyACMucyufATQnEzHS8yVikn?=
 =?us-ascii?Q?b6kFgLWRJ5FqEREfir0+I9RCHC/BVPOFJAUsRbB7wC3+Bv6W5y4mpL/xCLyw?=
 =?us-ascii?Q?FuzIjAlc9jfZOIq/TK+zADvMEh/W5169HFTx2Ft6YEgTq8ynbxP4jAOZ/Ova?=
 =?us-ascii?Q?1+IIaYnfSSYgHdVlrtcWXgF+t6NceXPVZUHe4ZKwp2a7OPjY/2me6MdDdqxV?=
 =?us-ascii?Q?1pBDsxJtU/1wsBZ9pw0HJiwpL++zWImR+PQylXPrxT7cQbSC3ISOCFP2H/OL?=
 =?us-ascii?Q?1hXowul3VwJblT3RqedMNW2fIrO+LNAoLtnEVmgP+UQ331c6R6tPOBVBq0jz?=
 =?us-ascii?Q?2FTDDXy0WLc1f0Bw03djvXd+0Gy/k/wEoQ+JDzHZ64ZyyZcwkwocNbTWgeqS?=
 =?us-ascii?Q?cL84AJOtS0MdfNHxevPO6kQn1f+H4Myi7CRU/uMqQbCLcPH/cKt/HbLb/ahX?=
 =?us-ascii?Q?l85p6TuHJ1uwlV+wyS81f/EAP3uH6uFMCKoUnSjuxFX9aJtGYQa+88AWarMD?=
 =?us-ascii?Q?yrrgU2XkBEp/XhiP7bjRvqbC2j3nZiDdkiAj4NH3M103rPVppdjwjElVDd5m?=
 =?us-ascii?Q?4v1G3pZ7n2ClDapvq3/CH6ZhAzjkAi+iRTDdiF8wADEJdRd7yx/8TG4kwBu5?=
 =?us-ascii?Q?Ha3xnfbP1XYVeTD0sdD7ecCWZEVqICJLYRO3Ha/4oGBvrDF9W3xsDBMmzPg1?=
 =?us-ascii?Q?2CJkQRUV+RisOHH9raBVj9/g4c4/6pLqOm0RWavOIVFeFIWwtyscmOBAzRMk?=
 =?us-ascii?Q?GEE/ANBeSXKdg4AzKORG9Yz+A81O4lmtHsQ2N9kmQT+wOHGvlMDnu3pYWS2R?=
 =?us-ascii?Q?TaC52lJny5kfh/mJEQ9WxIQN6WtqvnkHtLzcUDV4YBggibKu5yP/x+heTFZ9?=
 =?us-ascii?Q?SCEaNHI0IVGP8JR35XTnGcRECEjTMy/z+87wra2DRuzRmpURRnCiR/faEnys?=
 =?us-ascii?Q?X/vLda1l/yf+yfro5tKWgGBldw2PbzUAi3ftBwnpx+Sf9hz7KEFWZ51JNXhb?=
 =?us-ascii?Q?n6trycOrkl6dOUyTQ64G3D5MC/M3Hv/fqaORqr6uSZu1dioIRqd8g/Hb9eSK?=
 =?us-ascii?Q?MMRyuHCmrrwVsF++gzUk/NCzRsU8Y3k+lUkN6QWklnIMNrCC6h+EHX8PCuG4?=
 =?us-ascii?Q?tE3vFumfTaEshnE0AiMKLxPfbW3eyB3AML+B18j4b80MBRLsx3YTY8Yyjvec?=
 =?us-ascii?Q?X5UnAwWC+LgYrKXeV7hZsqJ5xMcmPLdeqfxMRyk1uJT5XRNMXby5mLOoQaTg?=
 =?us-ascii?Q?iTIUE/okg3iRl0XabbB/mLxKsnx0dftBCF3GN7nH5aBAuuTIzSATl2jZNymT?=
 =?us-ascii?Q?ItNPsPp3ndbq/j+tawYLYqkVhuS3tQpR0ApEqB84Up2NHoQrBCGsygHrnBIn?=
 =?us-ascii?Q?qKp37YTrtG6pOirx3cGE2/vxBLMo1jqmQ6mI9ZVOo40TCkVUymYEyqKI9Vk3?=
 =?us-ascii?Q?WxLNg39JP1gieX+/zdaUhwkmKnNIA8cfvibYC1vmuHer6lu80r8ESJcJpc4U?=
 =?us-ascii?Q?Lfve5V7paTxaw1om0NvLm2Iycs/y3Y8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+SuGtYCRX4LzE3pxG5QO3V/XsxRdqclBY6Xsr0ClNJasTHqbTamU5g5jasAkYI2PsdIC8mM/8S3/BVm6p/gTeKyZ9j+cxLINMHorK6/8VewEJQD9S62YgPbhrH+7E37mBijGsVj4txiymSlL4jdHVVGLWEjeAdI0mGwETHfJHtb0+CLlwfnbwEfuGfvhCiaPvxPb4EZtna6aviNK6rHgfg9Bjx8N76oBScHTk3Vz8ocx9KZcWScYC/vAlq51ZnVKuaQzuRFkCocrHFJVw78VH22GsxaLRoz8TDdcBHM22fLkNaiamn0WCxGXY54mlGAB9PZaj4pIRiqZfyfEG9E9oN/vXiG+ofDPfGXo44uJuRbTPbOA4XRtgK/RAw7fo/CCZURWhVfwuhvPVBaee/wDpMxpeajisoUkoWyyP6BHS43bBq2KD/uzD35wvcbVCtVxF9shCkkQweRs/Ao1QofM5rRStUM7RuRUNp527eVV8Qo6WeIJ2RmchtF3ZiZA1PD2NcO782+fk3kSEzH3CvCnj8tEMr2nV9zFWmhd3u24FZsPmQXtlngoZOCrWh8pYLjENJzibHDXmcjf0VPLQzD6t7yqSLI4idD5OPOCnulEHFI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9318d984-6d92-41f3-9377-08de748433c4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:28.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyM6ocHdecET+V6l8ZBnXUpPZsVB9gLQY4eeUaM9nPeg75kLmvGZ+GylZCZMQytFMs9uLQLXQ87ha310AIH+Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f17f0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=iqRKemep2BTn628LUkAA:9 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: iav8nN_hWX-yCnVDNtzHnLfNouMjT6QJ
X-Proofpoint-GUID: iav8nN_hWX-yCnVDNtzHnLfNouMjT6QJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX16kiOx1DQ6sz
 ZxbYH2n/qb5uy9fVur+sUM538AjVYuEkjuj4t7l6Yr/mm2BVwpNv52XWHrzKTBciZ9GkFO5mGIB
 eFMAgZZ4qvb5z4hdPNc+PN9vSJB+LY4L3KOgqfdUtc5U81nrrAaaU19Y0P9E83SAZdTkpuaTA5U
 ZDECDwwrHY/DdUdDmh7mI4jd6XpXA0o9v0sGbdiMS3pj9xiv7STPNaCLb6euUUVGMXipm6F7cki
 mjL2LJ2e1V06ih2cgzM/I4ogCZDBAYjSm2rWHSZlPd5Ukf9ReDXWkGwIp4iAnga1ZQlf3HL6HoL
 aQ07OOKYRsVk0WKyadTjznwAo9ZqREVXoQJmrw6/mvZttyNZYNz+L3E1F/RJT1xBT/w0Qf5zam6
 W5kX801lDI2AGE23FHoFfRMHzJjCLZT342rTHZzBR3QX2NC7WJo3RF7k41zkJdk6A+Bheezlqsl
 SpWufXhUgyyuUBZGtT2KhNuXs1MZXHQ56Sd9z9yM=

Add initial support, as follows:
- Add mpath_head_template
- Add mpath_device in nvme_ns
- Add mpath_disk pointer to head structure

Initially all the functionality which mpath_head_template points to will be
unused, until the driver fully switches to libmultipath. Otherwise it's
hard to do so in a step-wise fashion without breaking functionality.

Many of the libmultipath-based function added will reference the
ns mpath_device, so add that now. Also add the NS head disk pointer for the
same reason.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/Kconfig     | 1 +
 drivers/nvme/host/multipath.c | 6 ++++++
 drivers/nvme/host/nvme.h      | 6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 31974c7dd20c9..fc6e75fe8cbfe 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -17,6 +17,7 @@ config BLK_DEV_NVME
 config NVME_MULTIPATH
 	bool "NVMe multipath support"
 	depends on NVME_CORE
+	select LIBMULTIPATH
 	help
 	  This option controls support for multipath access to NVMe
 	  subsystems. If this option is enabled support for NVMe multipath
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 0d540749b16ee..390a1d1133921 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -12,6 +12,8 @@
 bool multipath = true;
 static bool multipath_always_on;
 
+static const struct mpath_head_template mpdt;
+
 static int multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	int ret;
@@ -1407,3 +1409,7 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 	ctrl->ana_log_buf = NULL;
 	ctrl->ana_log_size = 0;
 }
+
+__maybe_unused
+static const struct mpath_head_template mpdt = {
+};
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 6b5977610d886..c48efbfb46efc 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -13,6 +13,7 @@
 #include <linux/blk-mq.h>
 #include <linux/sed-opal.h>
 #include <linux/fault-inject.h>
+#include <linux/multipath.h>
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
@@ -555,6 +556,8 @@ struct nvme_ns_head {
 
 	u16			nr_plids;
 	u16			*plids;
+
+	struct mpath_disk	*mpath_disk;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
@@ -582,6 +585,7 @@ enum nvme_ns_features {
 };
 
 struct nvme_ns {
+	struct mpath_device mpath_device;
 	struct list_head list;
 
 	struct nvme_ctrl *ctrl;
@@ -608,6 +612,8 @@ struct nvme_ns {
 	struct nvme_fault_inject fault_inject;
 };
 
+#define nvme_mpath_to_ns(d) container_of(d, struct nvme_ns, mpath_device)
+
 /* NVMe ns supports metadata actions by the controller (generate/strip) */
 static inline bool nvme_ns_has_pi(struct nvme_ns_head *head)
 {
-- 
2.43.5

