Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C333346A8;
	Sun, 26 Jul 2026 20:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785098910; cv=fail; b=HnhkiAwIxMf2XVNtcdH1INK8ckPdE/V/LammARDRFxWyOeLwscShErnCSnVA8yJcRbd5/ipr7XNdmDlEpITK+vcIE0FnEGfXFAcnt2HZfbJ33dT9N/oGvzafZzLx2lkGLHU1X7aYhfMLima147oVB+zg+QJL65sMEj7P3EIUTG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785098910; c=relaxed/simple;
	bh=Oe/oneJ18uiCCRWjYnNV5G6Bj7Izy3Q6nJSUmABvTa4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hm8fUu9umW+IcK1BWSR7grT289adERqKTepbAeTo45kO+dlyeZi5rlwZ6+n3GHzhVnGy6buQXkVmg4Sv4532OvYku1F3BMLybqft2cFfP5UMtGNud12Rl2VJEcbsNduXLlQLolgFtXLEUBNVxO/s9mYVcUfEtbRZir8r+8gQPjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZbjED52j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UqCndLGF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZbjED52j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UqCndLGF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QKjhsD513875;
	Sun, 26 Jul 2026 20:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=23iq1iAXaXPsDERu7S
	XZ14S9SrTn/TPrMr6Qkqm+jj0=; b=ZbjED52jzxNyd1atvJ1jLBWt4/yZPNED6M
	E1hwWoABebPS5JttmW/PRuOOGTeZpwD3DiK6UD/sBylFUHAu7CKCv5El63AaMWsP
	3BYzdZcPA4WpkhHgKxepA/sXYK6Vbw36cTNIhRQQcmedqTWlfx88bQaoA0qZqaUM
	i+V9lTHsM/bG+KY+NHbfKLaMvqzZtvD5HhC3azGpoXsqSmj8Q5ILuH1jZvWVHEmN
	BvYqY/6jBKV25Qbxz1PppVg+/E4OFMlNsScPxrBplQylbgen3aBjW6KBA5khVd+m
	EdTLHmFy5SwcwJWEZfpCYAcVz/LXqrPjpL3oz8VbHvquRMRyLGoQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xs06y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 20:48:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QKj1sH014546;
	Sun, 26 Jul 2026 20:48:18 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhegfsxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 20:48:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dqv+R7NdiOh8q5N6R9d0+to1u+Bie3TIHg04llCq5MdOaMqOJk7EVsRhHXIhGV3PVlv2bC2+tA4/SJV8eFv/ZMBr0mtdF0eCQQjKp5Jx/ezFyvHVQThcjCvWmjzsU8TdfFzL0JBHNYhYsvgEBClhAgbRvGfT4oaHSkh3YrTdZBxElWoraxZyMyK9CSbgOqJKYe7T2Az05eIS3ZlVUyKqXwpKOnGAYoMnBtS6Xc7ItHYTdHi3i4Y63yRPE69qqE+I8381IrjNkFoe3u1q/qIzFhPkOaOzFTG52Pl2zutw6B+HgffcdQLb9p0DsTG8Z/3HlMcS6eKw/w0SzEsveDyelQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23iq1iAXaXPsDERu7SXZ14S9SrTn/TPrMr6Qkqm+jj0=;
 b=yCP349IyWjoZutm5tvjmCT/7uAC2EOYDdiGJsC20aH0xnu0ysFU8+CAcO8JLLMASD/x1NrJVV5OmYphmJDcAWt4WO3bCxphwGOX8YhZSMR3byZ4VX6ecm/n3IY6ogbRTD1nLbAq3hodR0NRNWbKgWTpVZj4GAPqhlV/vIcp5NRVQ8OAR6W8Cdr23h/SsQ1Mm2Bx5oqs349CYENV7bV+TY/lNHSZhu7hYTVBu5ZKhmLz6KQ8ggDc06uvE0mUf3dZnSmTy6IsiYV/pxgcSCSc5BI6icAvDCMSXPInnBX4c57gTaaE/DzRApPCgzBJ2K/pWUSoNJTr/G2LsdEEKyFUVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23iq1iAXaXPsDERu7SXZ14S9SrTn/TPrMr6Qkqm+jj0=;
 b=UqCndLGFDmaZW0F73cA0LNG0w28fmcbammkD8aBNzi0fT2sJneX9fmcCNM/nP2O9FOS5xA7VVEuCfJvuxuD0iiaqkKMwrPgjDV8yMfwlad50zcnuekPqGRef3cZfJl/laZpa5jfWT7k5/yzC6HbC8pV3ogHtcIRczes6Fis4yAA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 20:48:15 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 20:48:14 +0000
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
Subject: Re: [PATCH v2 00/33] ibmvfc: NVMe/FC support over IBM Virtual FC
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
	message of "Wed, 22 Jul 2026 17:01:16 -0700")
Message-ID: <yq1se55zddo.fsf@ca-mkp.ca.oracle.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Date: Sun, 26 Jul 2026 16:48:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: b695b7cd-892a-4efd-6b58-08deeb573667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	JDQ8klSS1wM64soQiEUlbJazy/7POsb97Hdkr2qehIYivYdIU8HnV4qGrQZ4+Hw1FVj533PI9QspGjE6bGnQ8kg0Us5ebihbx8k0ZeDvDSjqw8ci/BGRhJ2i1K4pZdHpZCuASJyFy5TglcDbyZ8p76fpiFtJggWUWqJirUYBAzbBzR1ZAOErzaDHmNpclHyVGL9yiGbxiYhJ0o4iyRo2QuTxs22TtPI1JJWQqjkj1/rGNkf9aLX7kEdlOWTbFOX4WuuoZA16RCaNGsul15kzCTSwr5PjUHzFMrMaTAsYJdE/z75OaBiaWuzysxwovlnsmBGyIFlRWb4hsDYYn24/bPkTTHfpftb5lwmiSTkZsRJnd9skO0aHHHzHhvcYrlIwDLb+eCY4JZDDVSwhFM/w8aFh/7aKpOFTu7z4ywv7aVxdoReBNzQ3SbXFca8jFRemwY6reMFn9y6U6LxxsqfEXABqemOgfQ1QkO5XkiqXM/TpVWeZiIcR4B3pmakI6B+ttcuPIIaJnbCtqdkDbXpMWPQYnBnwAjzx+h/NIScQw1idJBdMaKpLyOPBfvrlOlfTDL6QbXrry1Uu4xCmp8NENbA752Kz7pknOxd8cWN+sK6abORlK0TzdgmsZfH8OaQpjokkn6RcXjqurSAkGAGqXAHRndluYc254OdltPA2PY0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sVfrQWvLGCv7gCrPqTgh3CBQFuDubqfBefLEcGD+Xiz3hRwHw0lFIE3hJDfw?=
 =?us-ascii?Q?IF5CsqA51z6pgN24sLrW2iNe9yaMSw56fxPTk6eMoC17RA0BdghBwOXTZ4JH?=
 =?us-ascii?Q?V1kmT+3tFD6BrIwf8o4KMFAQDd6uc5WsSbthFttuIljb+zUQeN4hYuHxxsIN?=
 =?us-ascii?Q?Do6Y1NWY0JWG49fBQ4Dsq5tKIb1dcP7chNlxTawC3A6Uan3CjAiCbawc4QpG?=
 =?us-ascii?Q?ZuuLEMPtVD5vS07lPgBysodYq+iQcs1Ul4KThrXe7O5IIrl/KyEevN2rWEs6?=
 =?us-ascii?Q?+ycvG7ZS0CYD9nmpYu9W4Vttybw+mLJ0LRjzFqEsMVMp2qpcBp6w7SnMVtk5?=
 =?us-ascii?Q?0kfNJgg0tbI5ql0gEoNl8FjE30GXJiniRMrBjxC6skMFtQZPZHs2I4RSD9hT?=
 =?us-ascii?Q?Qb5u3V5+d1hKU0N9A/3ucElT/7spdtAZ95YhnMeT90KFZdD8TLKvQt0NUYNm?=
 =?us-ascii?Q?IdWHmZIxwUuU8Y8jK4bwxu7d1IfDDkQQYsP8AtHn24b58X6b8Y2d2kKTp0Ye?=
 =?us-ascii?Q?IRutpXqUI7c1jVFEx6x8H+pdZVdC9ZvD+xRMtbmQI/vnC5q1MKyqOtuScW84?=
 =?us-ascii?Q?9Zi1WOnVbc/gD2Xl+nTHRjbNOf6lhlZEVy3XxILWyhBMz8sdgIIiXeNKmzpR?=
 =?us-ascii?Q?TeKRBbci/7V6CSIyRp7XzYmmfUcHKgBojs+UB4LievSfMaeKmG1p8YG+t1Y2?=
 =?us-ascii?Q?uIkLi25n0WFMg1tuMDaw6nOYVEYMTNpNdxQefo23zVZ4PD8nAnwufK/CrEGf?=
 =?us-ascii?Q?EE5L/mmGlws/z//CIwvhYkmuxCiRAx8L2K/EiHJDErQBdEo49GUezlgxtR4y?=
 =?us-ascii?Q?2OZgR9Wgh//bH+C0UrFkD5j4kfr+ODSgVJ+Wz9f1Eu7vIQ6uc+eNFGgpCjF0?=
 =?us-ascii?Q?QOiHIJqFDV0eosdwfg9cuV7EG0UaNZJlZy7GF2XmNAWC2Su4JKplXq457gjs?=
 =?us-ascii?Q?dRRebVoSzjBbj10uv6gQBG5y5z4iAAo7MY4Tu5Cfy1ovxKiOR6XbBtMyEF36?=
 =?us-ascii?Q?RxqzQSBe5HfBkdLDZCpvoH3JEmwn5jHGFQxaqt8BocoHAT4Ae6XJLtu/i41G?=
 =?us-ascii?Q?OmVCOolh8L2zr7YlOPnUoIF/D+Xpnkt0VHS3mJbbGmkOHfWKiyEpkdhZuBR8?=
 =?us-ascii?Q?mM2LpE/jtJo25xJoXLnmgR6cw86fDB1MdV0KJupiE+cr/4LDxQJaRItv8e16?=
 =?us-ascii?Q?uPNi17ikA+OreClHASIy2/bwOIIIfICJ6uASVgrWghfuv2Isq25J70jTwOor?=
 =?us-ascii?Q?7pQ66fkguJ0+bbTXgoZQ4JY2IL7Fb5VFdyO4cfLbrArsf4Vpl4C+U3xrbUbs?=
 =?us-ascii?Q?+WnApEDqh7eIcVO/JCh4ZNhiwrZMxk7hpc9PV7V5WfpUVa80NCselpWm70of?=
 =?us-ascii?Q?+hZhkQ7wVeo5bfKCyh6l+vnpzO0l+hPI855YSmhCEkQn9YBTOVp1euNdGFi7?=
 =?us-ascii?Q?cv+REipBJi6GDzTzcUOu3Kuf6ERGgBoE94BTEGSENUvpQCkCnfgqAjLi7ZyT?=
 =?us-ascii?Q?Ew+AXqCQgNrqxhMtiMipah0LDERHYlNnxZgtaLZ0o1SrPLDrhcsRfkTacBzo?=
 =?us-ascii?Q?eFMiUZ+Qlu9cYXtWT/cnsUCISdWzzuQF6Iop931vTUB0OfFP+HnoO6cAttGY?=
 =?us-ascii?Q?LMsZ4dNPQNmYG+jAvcFOnzsbnq8XprFdF1Pu8ObVDHtkukzQ0alLhdqyqL/G?=
 =?us-ascii?Q?DJphR1pN7kNA0U0AMxMUjoBSUtQ9wMBzJN5yqx81KLuzzH/gCpMdZ12/2bii?=
 =?us-ascii?Q?n2UtEskXiF2GRYdwZdb9tZ0TTt0DOec=3D?=
X-Exchange-RoutingPolicyChecked:
	n4PtrZ3FYyECAGdGI81gsfQjZ59wUHoov0BCSfo3wWCp0X6Tf5HmLASwRncpyCsb4Bh/CUN6E0MyEA0ALdvci2YcmW6UFGmF6q7z3wdUPKrYQHYdNq9fejlNAR9uqaoPeLyklUjihSQE/vlBO+kaoNPfT+Qu8KxxEfjn9P4c5TSZbogYlsnx8OBzEeIiMH2Z5YDo6xTkwPBwuR1N9i/tuDzNQ0B4OG/RaPr0xXkn8zTVqltnI9dNU56CbozZUS9I8nlYFFHxyG2ysMA3idgJRlgqXVwvyrEvbMMnFsUfuGsYnHwwtYgaytO/+PFACxPmrX4hVJzWPWJjWRD3A1aZwA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ElSCCFkiWiZPiaPiTBFQRkdPZKNp0HdX1acaYQcjt/66SDKDZmrRmOPU0T7lNRGsdmSGNGqAufTeKMeNHkeGCOc80B6Hd0v6Rvh+vinfefVx7qL57mnnYru3uRm61k9I8hF3uNlGcaxq1ZvdUwqxfWDjab2ghx7P+u9o40tj+bmQJ6YCFmvPA0b2RvS9Q5SEjH/tSfjAeNe65UbSk6ChNMjMzHyDdzRfQ4wLwSdsVpn3HrIBrbEXtklnsXjodNv5nQpvWd85dxev8aa1K2VzxiEVxEgRkrDk1bD4AdjhJbxshdPMWLnee2BY6d38c7zgtmO7q+cgIIk62GHQPff1NKa2CW8TzxqFG5FF9sDUO/QiI77afH600nWvQslPYNrb19x4Xy4g7pFT4/7VaF6wED99nBt/YN7xj6PLMvurcDZDGrgueGjGoq1cO4Dr2n1j1eEWWu23MAsTQK8oQq48ZLv4C7NCexyYRWZ3YSB7rkGqepl6iO/wgCrLyFGGWEkNRs2eCgLuVR2SXwDHOKBPtOMzCQOVseA7UrmzxcGrSBs/BZ56Lr/aDlT7WwZzkowj0O4rsU8I/AhemsKD1D0pbz3GMBs8/nWtdyBFJSWZFSI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b695b7cd-892a-4efd-6b58-08deeb573667
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 20:48:14.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5W0nfPw9wJ6JfvtMrsZFi4Lp4ifVCLtDj9eclNf1JQNHUxjkpzqNxCwyie9CPPj4pu6MzGkQm68w17/ssWYzCE5xIpEpqYa1wcYgUAWQgas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=777
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260210
X-Proofpoint-ORIG-GUID: te9e8I0FK6u7kQxr2LfT8JEBskGQNwQq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIxMCBTYWx0ZWRfX6mzrfjgUHMBv
 YNYSduIXdepHl6TuMhcmy1Q4N3ZWi1h6kqDf6IVWRq23y3WYp9NeZefQsz6Yepo9bMIzFNZxe5k
 L7OZwclzpEZoduz/gh5ZKL7YevEqWE6VSewCaszp3d7Fxu5TgIOXpWzZFRzDxXZJGGhL+NRTAz0
 vOIF6m3Cz9jIwIU22XRpCu9jVjfincUUlZNXvVxxuxCYTtADGZY5gvHUZwpRjzZEFU7yFG3201p
 htafbEgjw/JgavJAKaSdmO9DrBgKgSJXsNctBNFFDsrnWm0dUsQhDCeoOTheROqoL5A+aRyMULU
 /Xk96Zc3YASX5SoT6tKzrt8VRMpdUutLk0kbdpSMCCggfS1bMxrpmv0X+kdC9xzHEi2CwwVjNyW
 ZIrHu+5ct8rpVD1yCPzbpBM+qSQ42kBZgYRJyv3vqIt0il+xcgy4LjmxrbHlCh4Mb60esNOiUhK
 +O6YAE74lBfd4hZw+tQ==
X-Proofpoint-GUID: te9e8I0FK6u7kQxr2LfT8JEBskGQNwQq
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a667292 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=_pUgLgvJtE4f3i4Bk0QA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIxMCBTYWx0ZWRfX7+weIRUfRmhq
 slqbRtlIDZRx+YkJMFr8rVo9dXC3s8elui/LzeK4hiASqZOp1VoEsCPB9OKlW0/4is+t8Ub/IAb
 MPnaYH8gbhLKQQJTLtM7PMjU9xvbqkK1NH9ts5veRckEweM1qN/F


Tyrel,

> This series adds NVMe/FC initiator support to the ibmvfc driver,
> enabling IBM POWER virtual machines to discover and use NVMe
> namespaces presented by the IBM Virtual I/O Server (VIOS) over the
> existing NPIV transport.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
