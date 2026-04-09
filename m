Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA75C255F2D;
	Thu,  9 Apr 2026 01:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775699010; cv=fail; b=ZAHCsGzgRUIWJhpniqsMRNl19e2PjEvCGEcafB+mGAnoHGUbL6M7U9lrUoffcCxdGyMykVald3kDIeMqr/t6/rjjKrEZQlgx18oPeZlKuksBiv9Jhhb9cqQzY9rqmuwdxcS8IHnae2BvonX2DvPisHPAEl8mk8G5n1GTycgxqhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775699010; c=relaxed/simple;
	bh=idynJyXqx7HxfpeFboFS3N1E78xvsqld8l/4pswKD1M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kv9ZQtrvAvr5KdjI8Jkmt1z1mdWz/Q4nheVRz5fBfZoxzXrAmNd66huphgqdb+ajDKtBr8LSiMyDbhOyavAlvf8ebx73kKxh5BAX/vDtGRrGF9TfQhuEU2MnMwWHztai4iGM5HfBPtdW405q0ZMWZy08ky6urMcBIYisjn7Tpj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qvgTdWlj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qUBtxbu8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qvgTdWlj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qUBtxbu8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NtS4s794539;
	Thu, 9 Apr 2026 01:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3auZfZIbTymybScQpc
	THsqmLHMkXDnBLoA5CQwvCugY=; b=qvgTdWlj+pK01N8a7ZkUNlYLC5dXGo8enS
	9OiRhF2+t87+prjZsve2wCxJfIkseDYn5M24+JSxDmDa9z6zNUuHFIKprTFq2Utp
	7le9XP7BxbDpTBCVBXVMwlxy3oN+KqYN/qEpGZMlnQfbHMmUxYWXF46klt4sqfWY
	c1OM6j+XsQwoAHjk5O8mbXJK/x8l+01WXbSPAOl6zxacjn6gD/Hp2LmaHmIVJp9g
	jUgoBP0hHWEklYfmuOhaF25UpK27YQ6/W1Hff8l9kiBYvZtBdM94q77qIecA4USN
	/M3tYu8wX4B/MlYoCeVUrheWMYXDxsUQ7LBjWGmihBlmlE3PVodA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqavser-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 01:43:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6391IMfC005196;
	Thu, 9 Apr 2026 01:43:23 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxr7mw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 01:43:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TrZYl4Vr/PCnsHVpKYLrkBjWnnVlHMKP/uXer5hyZ1OWiPIzbvN5tST23aGD732clYEZHfeWIyA8FWiCGsggBkZvEFmiknZ9wN8i0fP4ORQu5e385bGMQqqc2Yp54i60udB1q4vI8OStAdRy8O9rk7DcxPT47PmVdVORS0dc3UIzdilGsMG0MCdGZovh316treKvJ5s9Td4TG4J4MR56USLaAsFgCkQ375Z4dRyH/GkY/lZDmGizJ7y/Chzj8amQ1Q2Il275Afns8vvxKNAmnNqsAihQ8jFOUP99OpumaYXxYdgRGXzK63y6FmMaiTz3ZRShRSSfbN1NyQrpixSAtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3auZfZIbTymybScQpcTHsqmLHMkXDnBLoA5CQwvCugY=;
 b=vIaAWp6xMYhPX99sWzVAtP1LWU0uhqOeu1EhE91bB5WAp0eTDIsyi6Jr17QkBFcJvwij9zBPaCEKZfaSpQ9CHLHYAcFAawaWvSGM760sFQ49TPHUqRKtKM8sQRNvtsSGcrTViLOe7Hh7cZqMYDVkmpDlmWKGTUbNc4jI0RjT3ZHpDsjpBmp170p6DEUcZD7DXdTTGHWRV38dw6BstnHn0CmAo7KH0nlTV8uEY67KOIXJoUcDXqWYzD6oAUs2LBdzNXscMcQU4D+YM2wwfRXD1+2u+20w57SHJaCtHwXUOXvdeB6cTf+Xcdnx+6q3TEObYkskWQlk0ShDHqM7B32RHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3auZfZIbTymybScQpcTHsqmLHMkXDnBLoA5CQwvCugY=;
 b=qUBtxbu8vRx6ZDzTdbaHk6q1KzfbhLAQd2NPK4tpEPAovC+/kr9e4YXAEO58qMu4jeEac5i6TOnCpK6yK9yBMzOhmTB+YoBoe1QhO2mY6oIclbAGg0ZGhRtFE4moDlXxCw/v3oPp04Ej2jQFPUfW3Wk5tw1CtA3n+sVEM1XKU+A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB4966.namprd10.prod.outlook.com (2603:10b6:408:128::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 01:43:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 01:43:18 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi_tcp: Remove unneeded selections of CRYPTO
 and CRYPTO_MD5
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260404203003.33738-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Sat, 4 Apr 2026 13:30:03 -0700")
Organization: Oracle Corporation
Message-ID: <yq14ilkzz6f.fsf@ca-mkp.ca.oracle.com>
References: <20260404203003.33738-1-ebiggers@kernel.org>
Date: Wed, 08 Apr 2026 21:43:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0032.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB4966:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6f93f4-bde2-481a-6a20-08de95d95f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	igQ0OryzoTbtt3ypkN2kOKJqEA/GQEDTfzakfAg5PGgQavQwFfARPo8lJmH9l4GNA11qoY4WSFQO4YXHWtWWTQheQQCb5LxuLFD935Jo5Y+OGi9QKGmZ+g58Qq+fj9UZgu5X/LPIVdSZpXeYfn4EJMM95Q4uNIXdLdVs3tk0n71QGpIz9sGIJW9cmKnZxEaqHuq1GClKY1zcHTP9VFGa5CRKSNZQcSl+jenHGhuQIcnBZwY2ib/TKRNg6iaV2Mz+G9jXiN9GLJOGv4v6eDa3Kv7ujULoEKUc3i50fWytBVlK3P68auD5/d8mnZ2QzytoKMWE6chh06wmMzTGeagDnUl0r9u8C6Q3vBvLZHTU5RV279HWw6RC1WBYHynAd8qIZifuPmBPWsGbZQUiHdwZ25bjPQHvLZrQZvBnjttmvz50cjQH4qJzJCr95zjPPaED+PZcxzhzSPHj8OY3L+u7OLzo84l+lHVUWOzkDU6gjX8DLaCYk8ukZF2wrt2JfqV1CPS0YC719vBmHx/QGxpxVe9xP5E3joih+6GXGsRDHdVYPclTtkOLkiVDj5FzVo3YCaro4pceJK+84IHi8/DCMiJ84g02Q7cqbY9oI/J2Bx68eL9MnKiOQK6B1Dmjt+szLp1MWyHOGA9dy4pZ0G8kyvr0OMwoMSOX3X40Wt4d3QIE23IoxB14g8xqSqsRdAA0lG4+ddDpbpBAAJDSfDvO/TMkWytN764ngM2Gmx1++uc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s6zc6Q2Lr9cQnJW9P5Ec7s47voUerV6yxgk7HPSVvNWJQ6KQKwjayVtSGHpI?=
 =?us-ascii?Q?SRFiX6d2kTAYAGBSZ4iMtj/XGboLscwffAURi/Uyq+vQOIoQPqgUKaNvVgzT?=
 =?us-ascii?Q?+rFb/ZeonXLWde96CHzOdTy/9lFM2O5eRtnMAkOIrHPQTy4I74uAhMkU25j6?=
 =?us-ascii?Q?aidECpTjEtlbvB0JEHf8a8jVzMGDk4MZFjYqkuMQYhFJ9HJ88xZgdjWXwV8c?=
 =?us-ascii?Q?Modc8oAfVXy/AL8yFE4A3dE8oUgNoFFtOFZ3rWpX8ij3cSHkLgdr6eOXWUTu?=
 =?us-ascii?Q?W234eo/JBhsYDTjpEUHV5C/W7xXKQNAlrlR56y32bAJ18NtnogylJ7uSpwfp?=
 =?us-ascii?Q?k0Mf0d1tuAsVq1Pv0c/9IuPSeAW59g3zdqiKAsZL2/x/Gp6Nr3sF1fu6ZYj8?=
 =?us-ascii?Q?bFpILfx2hK5pGs4BoMjmzGLNxCfbEyBtS0wYZNpVhSk+/qcpMgLGBNWKZxT/?=
 =?us-ascii?Q?O8GKkS4dpDYR6s1mKEQj5f9JEfP6Y6xKlD4GSnOtSG+C6JnWL9UnHHxHFoDT?=
 =?us-ascii?Q?mqgjRf9IcvXHOItCsodWetta96cz3cfVMqJ4+ke1cSy4XXjLmiXHOUn0gDUW?=
 =?us-ascii?Q?RwghNpgP+dZWylwzlU44o0OoaGvfgIdiTqLLufBCvDeJQxkIG0ZKz1jOHRCV?=
 =?us-ascii?Q?8tqj8QRLCrvy4yqAiu6Zg0LBBU+a50nnCxt0sH8ULn5rShFlK2PMq/tYM3w2?=
 =?us-ascii?Q?S6hgI9HDc7XQUF5l+k3CWBwd2NYHrVM6hyzBKNJ8PqdeGSR6Ht7kvqNP/Ahc?=
 =?us-ascii?Q?+OfC5Ohi9jQ0vDiumSrHymtdcCHU8dPldVsEpdzmagUmvn44ZmtmBtpPLHnc?=
 =?us-ascii?Q?JhKqcQmyWl+whka3q/Y6dQXqm0fwnMvmdTnompUvk2vQQszlDDNZc7rIU/Jh?=
 =?us-ascii?Q?gQ1LBMOqSXFXbdI3d22E4rp30xp1nMwVe5r23M0pXAxnuvvaU0wKeSpY59cf?=
 =?us-ascii?Q?E/zV/DwddqEZUwDEkuvWyW/eB5OAqLNcXeXl4lKF8Ey+kLG+UB1nCKs81we2?=
 =?us-ascii?Q?M4KjGpqkuphJhnuE0X7lQ+IsV5ERzhthT+fF9ugygmtRqQ2GHqyAQpy0AnHE?=
 =?us-ascii?Q?ml2ohDuxjbwyM05pW14kXfGlPDD0CDN2fXd7QbbwgHaqRkaY66menuksd8yT?=
 =?us-ascii?Q?FXeGGHtMtz49GTb7O4SYFkVSWOqVgC4KR1zTbhahNMmmaqGZfAbbSK5u66VT?=
 =?us-ascii?Q?Wb0DVLnrH2Ecc4hvjhsCwT55yqTcALtQBk3jBRxm1XQzyFwHmCsz0lt2d76w?=
 =?us-ascii?Q?zSzBBs9USAlJXh4yn66YIFp7067RHnKunEJXIb8SVucescK5inLd0HyIeZJd?=
 =?us-ascii?Q?12ftONHz+DSL2O1yan0YsinT19GhqWqfgR0w9UzrnvwLWezikpoDZqzAwH4i?=
 =?us-ascii?Q?Ng1/eV3FHBm35qU7m6yT5Y24ShxWaNNWSn8xlOPHjN46j/Gk/ujFawy3Xe4m?=
 =?us-ascii?Q?JS3YVlgbhTd61Cx57VZyKnQUdVr+6v+ELosf0Asp2LQ0CFVBfQTezxInFaOL?=
 =?us-ascii?Q?QqaBm++7nK3mP5hcR6FG0GJ/Z9/PBbtU8YfxO9w1mlmK3nZV46gvCY0nfulX?=
 =?us-ascii?Q?IYybj8PJ7afNjY3tHBnDSB5lqugN1DraTk7fjieE/7tkp2+mF1U8ydiLo2mW?=
 =?us-ascii?Q?uEQCa5SL+v6fphyunezUUoacLJTbtgOQkUe00YVV4js6C6rdnrJAeuyfm40i?=
 =?us-ascii?Q?ptfU3O21GQmgdMkDlOlvnqZAU4gN0nICG2Su7NY0lqXP7YW9ZDL1nfQ1R7hp?=
 =?us-ascii?Q?s+wvKizuIeXyRq2YQdvf4Qo2xGImYLM=3D?=
X-Exchange-RoutingPolicyChecked:
	c3d2joG7VRgN8TYZecvjxSNJ4JUtpZ6BOUApVL11w57/G5H+Fm4vSPVRPWdldcjgKtD5bI81SR60cS/LdqnHg8GD4fX0J2Mf1ASIey/dDCtF0H7abcHzoPT9Tqs1l09LR/1Xp9JtWtD8TqY1PkHyEgty8Gj1mVe42EdP6MRJKpbAN2EvY+lJDqH3kQcEqVKtXkkqJPKg+MPtucDNWm5wrRdTEBBpqtB9qY5iN4O7STKmoiHBOuW4DseacEnVGBDL8H4yaX+PyfcQAznxUxsdJzaY8ro5KRzKQmgTXDTp6tHZe5+jKj1xks9RmMRiFYzOI7ed/oaoYDT2eK27ey+PRQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uGFND9YSfbJ370g7J2vsK7phpan1Fzs7TdyPOxoHeer72MePJM8MVF3Ouu/zvU8i7vVV15DGFK+TnMM0b4Ecn8/6s8tP/Mdpd1suBIuUK8/DIH//g35syBkWg2wG42OEEMGBI210Mmfe5OXBj0JRLqM3YwIHFYcbENMm+UeIF8Se+eZNJwY2rK3C86qJvJFN9q28+sjm1QaPte7U2ItNnZ0ihqlp9KQwEvbmBNmmLq8PXSL8zy+1RN2quMKj8jIkQx9Vin/YPeMvNQX+69ug9AGBYEOdZi1up4/4QvIloN6sqNwfKPDsZ7eT1GuD7PO43WKoE4v1OnqmtWhPsws8DjxoZ8054MQ3tJNiB7nHnkdkofK/A6oNzFV2r9hFJnALpmwTp6CX2ANaaGjucBNNf1HkewsPvbpmzc3yRTz67nbrQzRyN4m6wuwqXURhtaGAbAn0kU0YAiXXZOwguCexZGuwwIffhlTziBEzvxBKbczBuA2THMoYuvRrick6ygtVzk2nirrCwDnXLtbWvDiBBMBzzxdLurGhnhsqc0Fr5LgmUKvgduvFIninQyCZsZpdk1D7uVf8ErIqK6rGFhJk3kGUXu2l/I7L+l7yfZIWoKo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6f93f4-bde2-481a-6a20-08de95d95f9c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 01:43:17.9889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dSKIwUVD7fv1pi6SP5nSR8E/qG1Yx8mp/thi/o2O30X28c1a39WSYByoTqqHYfNBPCO79cCeyzPMnewDfiqXDHpoezKnXbZe4bzp+nn3w8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4966
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=822 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604090013
X-Proofpoint-ORIG-GUID: xxVR6dbiLjCJTGpEUWwopyS783jk2b84
X-Proofpoint-GUID: xxVR6dbiLjCJTGpEUWwopyS783jk2b84
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAxMyBTYWx0ZWRfX9M/FjYfcnjDv
 PoJw5y9ymhT/hYFf4+n4QcaFii5UbNkOT3J6tBok8l7BCC86yBZk1mn5zjRsqfJDE5Dk688iU5U
 DdhkQlBzYjK7BHNWnCtGXsVl+vjVbKrrpy9KeDTS1qGz7pjBGJRAKtsMS7UgEPw2SDfd7hXubb8
 XZhQ3xR0jBCJ5chZ/68p/LBs3nLtPyoUm+64XZWOHf8Pmu3BboUifleBLQFi+dpZsVvt3aebNCw
 Tjh4M25D3jWzoOg9slZjKdhhtWoI6Jg9wEgB4T+sZpRJPkAvsAKx4mkrc26HXHXG7XBK60muA54
 xdUhb2FnqlVXL7cF88u+UTc8sfQwE+FKdk5P8PiLsnVJJWNkcpXKCii6Omta+egzAHv6c3WGZrR
 9wTBEGZSnQNP31DK4jDtKG1zPK9Qu5FNJFMQ8eGZvayNVfce8vxjT9iiu6o2q+oEveV0acI8lYu
 8opiNxKExASKzxfYpiA==
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d7043c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=bJFmTnUHYrfB9WRSAesA:9


Eric,

> As far as I can tell, CRYPTO_MD5 has been unnecessary here ever since
> it was added by commit c899e4ef96f0 ("[SCSI] open-iscsi/linux-iscsi-5
> Initiator: Kconfig update") in 2005.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
