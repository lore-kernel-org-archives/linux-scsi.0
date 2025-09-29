Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACAE1D6BB;
	Mon, 29 Sep 2025 20:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759178955; cv=fail; b=aUAnWSWqC+MUKWtJTHfAK5GpxKti+3Fbclec5WFII20Q4fTjw5uj19A5hFf5Fzs5MDwR2ytqDrKIG3yOJvDlcpolrPNKKVtjOwFk/USttLYnxV2SxMidT1P2frBVDP87R4WgmCxeBUSlQQHVkv4XLo70YWMwSnecsPLH7PfQtWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759178955; c=relaxed/simple;
	bh=1IsyvV5TSp8qBw3bNTvtkujoclAKx0k8edgd0/WwA0M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=C9SvYbf5o0mIWFcxnHeaW3zPYJOUx/abnsS4RH1dgZnHdwono0q4nGuLfK1xlyiwTDzEHm1HByNvLZZjiEmwcs/o2n5an0X/ZiU0NNijgO3E4gJS+G6gLqDs6gmEqRiRPdrDLiZbQhnBaQCHhgrhmcjnb5FjgDdDY8Oh4eabMrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XqcUVlMt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Nr1tnQLa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XqcUVlMt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Nr1tnQLa"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58TKZBrX002699;
	Mon, 29 Sep 2025 20:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aQ+3EIljaPvb9kA605
	QhIx2RvtWGidMs2iAn/61PO7M=; b=XqcUVlMto3F1rILJzGmWM7by8+mUQ0VCKW
	ukV0+8ueOVYAhYJAh657fgvaRsbsV3T0bMsJOl+qk8Ynw3JCn1jTTwNLyTXNFOCr
	bXmnVesY+nvUlrP4syyxRejoQz0zFlzXuwVfZeK5EuPONR+ShHw3FVwsdO1T33HY
	E+mXP4hQNv+sVvuXLYAGcEBVUBy6q57SNaID/CA5jdDcu3YcYJLHcj3W3YJ3B1vL
	DINU41SPiZdGXh0jdCO/TssllYijEB7Vtk1yuAZslwn4ym+Bg2r34a72aNyjI0Sg
	oUwHWfdxDH24KfZjEIOki6CAFD/8MK4aJR4+/gB/DRfwTZPcOrTw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g18yr0tw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 20:49:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TK7XcN001991;
	Mon, 29 Sep 2025 20:49:08 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cdfetd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 20:49:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nYB9M5CTf/JteIMzKSCiFsYNe8C0OTETH3JS2kfeMwfEs8CPADGfe+ppeZTpXEuHtiRqs5zZFfKby0Sx3UGBwztC+OLMX13PUHvtIULcqDKzOSaqqns67/7r0NXs6UBUwO1Dh8VMwBUl+hmjB5A1VnVQVLbIr62QjojxoNkJ7cjw/6wNy4z/dzJdzqIq15AYvvSV/j1eOOUtWU4bYRkwA6vuicQH8WHrVTrH826qCeSRXTdQq9XhqQ2RLxPSXSVaBcDmrCkzz3yPZK811sbyw9u8L2pR/JeimN2rJfaRfl9YLrXOK0YBOvZvB6dsE49lpPFMcaGXkqTooNJWKlfu9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQ+3EIljaPvb9kA605QhIx2RvtWGidMs2iAn/61PO7M=;
 b=Y3dDXp0OLRbjru7RVH4l0LH4m0arw0tIYgoAVJpUTss15s/uGa39z6BfbWY0Ch/It58LoshNNDSVs8VyltGth33e5pSoOzrFEs655goS4qsq1Lp/HaDMPHD81udve4djIcuamqbndE+K1OjABJWs6I/MJLwRNy0pURea6FOe0ydMSMIAz5y3JZdxnZFQGYTooeNd0jZepYsg5TWYmGkXvwatP9uzNF0P8v5dvCxlz0J+v4jPPcJDswNbEc1YtaFnaEJgKLfvHLTI+6rK13w6g31OuhDTMowMw7jHuzsLKGXksKIL9aYvUKGCVUNO1jzmnF6mZLqknXx06Nx3j/DXwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQ+3EIljaPvb9kA605QhIx2RvtWGidMs2iAn/61PO7M=;
 b=Nr1tnQLauXfRkJADa1yPdLGVsbGAw5a2bBdIjdq8nfOYs07ut4PArwz0u4MPRLPivbMuJo8TmXykAtIrcASb5f7jGMJZghAakkICYYH+gYbw7P+JCGzVUumVuobV510qZf6pRnZ4k323S41kLb6IbSmhKgWcmKOOFc11ZPzO0vo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5592.namprd10.prod.outlook.com (2603:10b6:806:207::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Mon, 29 Sep
 2025 20:49:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 20:49:04 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anil Gurumurthy
 <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru
 <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: Replace kzalloc + copy_from_user with
 memdup_user
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <F0B8FDF9-027D-4CCD-A5CA-91E7B2FF4950@linux.dev> (Thorsten Blum's
	message of "Thu, 25 Sep 2025 20:13:09 +0200")
Organization: Oracle Corporation
Message-ID: <yq1jz1hnggp.fsf@ca-mkp.ca.oracle.com>
References: <20250918144031.175148-2-thorsten.blum@linux.dev>
	<yq1ikh7qo5u.fsf@ca-mkp.ca.oracle.com>
	<F0B8FDF9-027D-4CCD-A5CA-91E7B2FF4950@linux.dev>
Date: Mon, 29 Sep 2025 16:49:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0186.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: bc146f95-cecc-4b32-0726-08ddff99a06c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GCLk1Cro3C8N7sfhWD2AouE0OxPZ43kGN4xVWqgG1Fef7TBETr7H8k3XDWNe?=
 =?us-ascii?Q?A7tUURn/7abD0K4yOpnS7KncKXavQNrwbCLB855ocOIwEkJbNuN0f2ubQ+ZE?=
 =?us-ascii?Q?/0nf9+bekt8YkHz09fTLMQlR6aCi2NrWi6Myl428fHw20VeBae/613/vNyUE?=
 =?us-ascii?Q?2gGfCkPyoz5PAHzuGlZroHB/JgWlDC9E/BmlKVrAa9yLS5AjnuCXVh1cdZBO?=
 =?us-ascii?Q?FnZ3uHCmdd6ex2Q0jnqQKtIdtW7Jf+3n29ffF3U+v4I5bMDdVwNscJ/z0wkf?=
 =?us-ascii?Q?LUhooDwuMg/rrZ455MxZuHXM/tJWONm5zWDYyO8rG6T8vIKqG7B1tjeEAyxw?=
 =?us-ascii?Q?fsDdD6KT4SQQGfKX36LsaLOxVxf730jFueTtL13xDX6XJQi3hqe8a7RoAp2Z?=
 =?us-ascii?Q?BKKvRQLlflW/K/Zli2R0liAloUevZFFF9310WTiLsxtiIbLSXbA4Yz1W8xZB?=
 =?us-ascii?Q?kO+h06mKLU2l/uNoSvVLlIYDN/7rA/SVV6IPNLYiIwajTOEB8Hs99U49ZVXT?=
 =?us-ascii?Q?O8cu6f9p5UrTz12K8nrRdg42VGOxiiRqbQg6iGP0b9FaOVyADlxWhoqNf/QS?=
 =?us-ascii?Q?aPsiZ6W93cNMPbYqWURdOlFjbYWrvdK0ln42ttcyY3SmTamVOvj3v+XW8eAv?=
 =?us-ascii?Q?OaM1DXOj8lbS5OLwS1z0CB6b97wkmHF5lRIW+6inYzEI25WbRSdQIkbVYk9i?=
 =?us-ascii?Q?oihNQz8y/TiiL2okEEQBfMmqrRvRhWUCqlbdeoZMBYqIV8xA26HqV9xpNHJb?=
 =?us-ascii?Q?5LRo0nMxELJ9UvoK80Z6TxT/1nPg0hNuBp5NHlkNAWB3H+J71VEXooWj3Gd3?=
 =?us-ascii?Q?QcW74umyX+sRncdSYZlgbjk9RgsAm7W2sTQ49HZHvfX+t2bS37+T1DxGnd2W?=
 =?us-ascii?Q?UAxnXC+qkXCKdHcLezxnw1WwsqzeKZwnvpVbGmCZeDakt2MdOF00m907XAFL?=
 =?us-ascii?Q?Ueg+5ph5KFUviVPOfeDS28xxFC7rt4WFo/ER89ydFW0XOhjHp4FsxKPaQkZx?=
 =?us-ascii?Q?8y1iQ1y/JuJbQA7yrN9MebJVkYoXU96cXADbp5j0j9/1UrE+0J+2TcsJ1QNt?=
 =?us-ascii?Q?wsDclSiisO030FdafOzac77QTUc//+BsdS8Nus58vmItK/58SseOXOHkheyP?=
 =?us-ascii?Q?Y/wn4ojrADgTQM9T9cThQL9AyqBlvmyILAu1VKxlq+nGhHbkVdEYkex8eb99?=
 =?us-ascii?Q?P0kFUkpHTHxTe8NpV6CJzQ80egx4SmQaRND61Fin2Zc4J5uwBNlZT2arKigS?=
 =?us-ascii?Q?bs8XuNLVNA7iQgwpBbCyZ7HfVhStXNYUVqNqZj7xpDhJVp1AtR539fcTy2Wx?=
 =?us-ascii?Q?GqIesPLI4We9kTDWv5+ZNOlcz3RbmDKcs2rKx4ydqEr7q97tLmYW42hG5lOG?=
 =?us-ascii?Q?n+i2s2WBmwwmx/0rZ6krvMrAFsoxeRJ7NfS2XhJc6+DMRopp0lgSWNKs0nvT?=
 =?us-ascii?Q?Af7ft/e9IkGogUZJus9/0uzTFSplA6Fi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l4xslWR9uay/RIB6d0X1Bx83r5R8Hf34FAoIDY2/dkLdzbZHIOuc8i5+4yK4?=
 =?us-ascii?Q?HclFa9RCzo3u7CKihs2J3l/oeO4vv/c2AaGLggwhc8snCHIiLmcjEdxzEhLL?=
 =?us-ascii?Q?Qf+MYN9BOQp9mTsKeHKvpfUgHdWwOXYYAdnXiTJzZoWDNhTgInaZSKpoU6om?=
 =?us-ascii?Q?ZwSh1rx7doeJ+Wrwytmsb136yslDkN8jHr3hOK5gmnqcAKfGl3wDw1xE4aYG?=
 =?us-ascii?Q?oJRETlxX3JlbCtlqkgSVi8gn3TqsHOmLwiaAawS0GFHDxclblj6nPVAiYhlw?=
 =?us-ascii?Q?wobiCuqQwnbUNS6H0iBfSgvnwRkhtHm/C+9SBRVbPA+z9fXWwECdzb6P1KIQ?=
 =?us-ascii?Q?lE5QsfDTPzK/RB7Hf2KwhGs6uKCuupuF9gmdThKNgHF8wyzjQ1N6LotoIQs5?=
 =?us-ascii?Q?fGr/DBygKGGVKC5Fdrww2eTAODud94hDHtMEnbvf91wpSdS6scxu70/pFatL?=
 =?us-ascii?Q?LYwhr78KJ/hs1tmgU+3ZrySQpxG8lktv03paM4I/GYKMs9w0bi9haNkpyft1?=
 =?us-ascii?Q?Z7XL3ZcoyfVWP9QCGq4juwsL+QmLECj0uF7Rop/IgSAhDN1YSMw3kJAKhQe/?=
 =?us-ascii?Q?qvRGtmk7f05QmJOI8pdJi+4Si6OAX4EAwkhG/mHXF/nvbP34vQNHBfGs+MFw?=
 =?us-ascii?Q?QDDiHX0TXu/8ZjzotjmiHyzrwPJEhBmef9DlBfEZq/vlyo3wMm7yFinqmoXx?=
 =?us-ascii?Q?2uZJVpMaaLqKFVJXgaLHr2uaJItn+3cxPmMC3KDS2HTnk9eNED29k/viqHMq?=
 =?us-ascii?Q?GptdK0WGoIGVYBMOaCqMyqpuuItrKNau0pwgiWU6Wxt2QdU/4Z4M6dd0hA/w?=
 =?us-ascii?Q?BTqbutNqyHPTzEd47e+Nt2NALa3kFnNboiBHL3/U8K2FAPrw4IiUYr0Eg8FT?=
 =?us-ascii?Q?+LIc94Nops9DzllehSe1LaAh7AKKLtmcPjctO8UkpFpxVGnY9k+dxxdfNKPg?=
 =?us-ascii?Q?o93x4A0BVo3VZXuvVhGIpUN2p8zi8TUkOr5tMQRnWFv9lkGa5h0GsCzj5FwC?=
 =?us-ascii?Q?O97tLfyP73t5tz2KKvdGEaid8dzrMQOkeNDpbuaxoCfrnERTJT8hOmw+x1Fs?=
 =?us-ascii?Q?lQPt1nrKosfDMh5CZaKlN5uWZQD7VBnYGan50MPD2VRJ+uVNyNlWglh+xNW6?=
 =?us-ascii?Q?2XvFBbFUlKiuRSUcwY2raFrTmHn9/zZ/NHG9j2GnFQYcy0sEqmPR+bCSQOeU?=
 =?us-ascii?Q?mPF2iPdNKpG8kByq8sXuyYYOKkLdIWR1FPDXgiH//uUjnpL6Mdct6jsKh2Y7?=
 =?us-ascii?Q?EcUMuaGDFmlBQemfA/m57Bu8Ih9nqYJ/eogUU62zMPgN7EEBz8SFfv3+GXaK?=
 =?us-ascii?Q?bPw2CTNVE+yKYYPvELDkIsAQaoy8ei5Q19HMZilYX6XPmyDy9WBaDLRyJ4zx?=
 =?us-ascii?Q?3UdiLDNAqNkb3clHkK2jv5xzAWAd8Y0NUffoIZvMIAiJrHWnOcMHcpJjUksm?=
 =?us-ascii?Q?cwNyOsBRWnKXIHj5erfdgc3/Ieur+wnxLyb2q6nTTwVBYp/2GZLuRT+nIHkV?=
 =?us-ascii?Q?zcnWn4ta0Qk0RCFIkJ8yRhGc51O5K3eqp7NvWg02Ch8Ni9M7Gl4An7Fpn9yV?=
 =?us-ascii?Q?OE8elgkykBts+4Fxme7AYlUpL9DZfrG4sk/8cojBKFOtTuzdZaVDIZqP4A9f?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0YnbDqNLwGPFcCYxEjtKFMhP339M89+gD5YIjVk57AieCj6dZ3Ip553lAVNf1/M33kBn1AtQsfCvGR2QlSEgjYq2rlp86CkseeJY0kLDWp6jFJBBPl56W2jtlUH1Wx+f1jPnC/gHvd/JE/XSqWG419CPO2aXafkJAWcLr1Ytk8KMUwbzRZCyEQKzUbEoKaENvUxvtcPfbFqR0hBz0m6Y1+ANQ8x3ZSd7MGIWVIC++RLIMP1kn9uYh+06HmEtqJcv8lfBOt6HXSu+bpNKeLY/y2qQ2iSa9oOijTNyNkGpbD3FmVWYAa72BBhLr3HplckXuG50Gh2kAYAXxbWlmque5vtJgRLex0rFVNPBKO9UrksoIBWchYJaumhKr/gJU3hdk0+oUwEWHLDflnOWEga7WFIHAQob1zOgVc/p+od2tY+nNPDKEfEQxr8lmpESiZrtuKZmBnLl7jsxfXVeNt/lnojS+7UMuK1JYAmAhyz7IABrAH7b1vJ5/CbVqc0XEUUaVeY65BI0+QNoHhatm0oRm6njFFCNX5DKjSAHfaaHSwd1rA9R3l2N4SnNsUwzNaCuSZ1/KcKu1gB9wvsSsG2q1+FVsN28qw9RaYEgbuw5d98=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc146f95-cecc-4b32-0726-08ddff99a06c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 20:49:04.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMj3VRStYh5AqjyULTa1qkQDj6FboOKEm9OP5xZaNPwb8D0TLVxsX4WG6Dj6wbuvpOVqg2WR9/bhFbCRH+hnRkCd8USvG9b9J6XeqMlsNrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=590
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290193
X-Proofpoint-GUID: 47be4596EwR3d7uucQ_xcy-uDxj1iaj8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE5MSBTYWx0ZWRfX5bCFATWnQHkk
 6W7JC5CtlxfczYRkrO0CdiWc01Bk3X0XtJBfTcuvmqvV3QibhFFhNE5fay7f32Ug0U/9vROL05X
 5GLUCX/awWLbVHSmVmgrF5qlzA48Tnf0Hw+I2O1wfifborK4BplPYiAZheufMqFE9jKtj0Ed3fu
 91KLOSeH9X1PQfGmxteMfUbi2WM8pwx0X8aOkHyG51QbzuKsvk12es+AqO6h+dQ1kKQFpN0Df29
 JBCcdXXkTZW5p6NcRv/NL59JkxTjuqGkwt4YKYGfyoc/Lbq6MKDApT2fmazPHxlLwT6IktA+6zI
 WzsIzFyyY/g7Bq1AI27y967afgBPxVDBxr/DD1aHlYtcgqLlwmowf+IyY6lIQQyMMmjHBg5L/Ym
 Dgw4SlxvehuvE5qDLV1TbnYfOHuYBzK+Qm3kvemCHwrPiDZJIdQ=
X-Proofpoint-ORIG-GUID: 47be4596EwR3d7uucQ_xcy-uDxj1iaj8
X-Authority-Analysis: v=2.4 cv=MuRfKmae c=1 sm=1 tr=0 ts=68daf0c5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=uMNSs-q845GS6wTYzroA:9 cc=ntf awl=host:12089


Hi Thorsten!

>>> No functional changes intended other than returning the more
>>> idiomatic error code -EFAULT.
>> 
>> How can we be sure that this doesn't break existing applications?
>
> I guess we can't because the error code is returned to userspace as
> the result of a bsg_job? That wasn't immediately obvious to me.

Correct. And with little chance of having the associated management
utilities updated, it's best to leave things as they are.

-- 
Martin K. Petersen
