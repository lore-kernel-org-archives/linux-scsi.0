Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0297ADDA9;
	Fri, 25 Jul 2025 01:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753408324; cv=fail; b=foq1jlpVBw5XjxwyZ+9260YW2sIavnFxoU+/nI2MZMxadGsWB3iL8n8tb4j03AsGo59Z1YM6eVFNMh73OBAVsCoChAdHrX7G7LmMuyFrJnB/robNlCbh3busK6Zrysu2786HcidG+u8OzZBqxI37rlwFfHNMTjoWlbo0uvi4CD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753408324; c=relaxed/simple;
	bh=f9fRXQcqCOoSzE0PDedTbgn/rP5PuAHOuTYOwVAmgmc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gPYRLl8i01NqXl2yq0sxYTgJoGcOtdnlMm7xZdxdv4Ls+l6oMcfJDseCPXXgnJpKkAC0Yjo3BOLG8vnsj1qALNd6bZaO2821raAU4wFVHsugvC2BBAC0fk27dYDXipzx+3xYoT2sj39Z3Ste5a4S8mILBnUXCufSGKGGOWMmQao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WDj6wmPz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0AiVW3GG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WDj6wmPz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0AiVW3GG"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLp3Cq008763;
	Fri, 25 Jul 2025 01:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hXySDClMxwl0aifskH
	jUelTsfFtNp1j455RvliohdJA=; b=WDj6wmPzwnT/XmM5H0pXJtqlNcBlv8Tz/s
	Wl3KC7NVgMAwazlEY6u0tYz0ON97wPhpfejS6OF5AC92jKt6ONmKpwMKd/7iGviD
	yK9r2BW6Os16eRFmRRcCIZZiHgi8ygQVvBdUsDV3/jTe4rjy9YZNavtwd9r+JsYz
	NxuADyn9KprSOP6XAMaW0u73CjELqY64EvUlg6QGUqIG6zLFTEWdMPhoDWTkswvI
	h/2Td9XnYOC0/hfSW09NI+6C//QBES1gDCmGdmBpH1M9byYVCGRaRJEkHxqZ8XxS
	dpQEyR9uv07WkqZXDp0m79Gknu53NjxNrOqPjiPNUU+bGXfzZ7Ag==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w3wg6k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:52:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P19hkj011402;
	Fri, 25 Jul 2025 01:51:59 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012064.outbound.protection.outlook.com [40.93.200.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcg714-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:51:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EANiACmRHJuIwZpRKxC3Yz6XQ5yB2AlYyNuoqPEbZiLsg5aHtcwRcgSxAmloGh3kQiBxVrTeCCAaKsdhzr+2/zxrvfWmQRrTxNUu4KEciJqEYuaXBtNy5gjBNdQ8GxaSTHT5iHJ3SnWfX+fXPKrLqm+TzR58PlEtLu7Jk8KxxrV0m0qGMiZG/l+8aJAeSy397oBcXun/JXe5jckd/7pk05UoNhkbKSCr8RsrgSozrBeMQtbexKqiwbaU/tFA7FI46WdSIJd5t62CpXINCZ45S82x71gXpf19lBxfm0jfxPr4E6c3OKqv7TXT/fAm6GoZQqp7LsDQcyDATIPU8wMTLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXySDClMxwl0aifskHjUelTsfFtNp1j455RvliohdJA=;
 b=rigMuTj8i1GtJzNRLTXcUTdt2VLpz/mA5L1OlpNFkzXF5ApbIFpUw3peB+//QlSKGzfIJigVV3ZBvxecqFFkr3QRYhHq6jBAJxl3hyaSYD0y0bYPngYRpztH9IYlbpmJ02QXOki5cxk2Z4mdXuWiNxWtE9nATsRHujPPDkCBwdwNQJiajC1vvQoF/eg9WhkFL5tvsZRpgV+8kvR1UaF99m8nz1thVwwIZMVrNDSSBDgGX5usFBppZwEackAglyecOAxIwTnfoEjJWHYGKMXeKCOzCLYs7Nb6ulykGdRKqlZ7c2rsLvNyxzXCPqZe+G8Vl4iGmk/jeU25KZhtk23zdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXySDClMxwl0aifskHjUelTsfFtNp1j455RvliohdJA=;
 b=0AiVW3GGMBVv+Mf7TH/Ci5U5Zpzug7TOzrnF8s4tZg6yYf8ytQbbIriYOybl/GutUU1kva6rBDhvDP5sn/JTBqIv50rjBfn6Tdg5koPb8tzx36FRTyCGehM/YHaFWn3/J+oRj1vr+ASkKdDX1uC8jN6bN2KIytzYJnf1TGrDbKY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7035.namprd10.prod.outlook.com (2603:10b6:510:275::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 01:51:57 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:51:57 +0000
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] target/core: replace strncpy with strscpy
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250706092522.9298-1-pranav.tyagi03@gmail.com> (Pranav Tyagi's
	message of "Sun, 6 Jul 2025 14:55:22 +0530")
Organization: Oracle Corporation
Message-ID: <yq1bjp9rqh5.fsf@ca-mkp.ca.oracle.com>
References: <20250706092522.9298-1-pranav.tyagi03@gmail.com>
Date: Thu, 24 Jul 2025 21:51:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0020.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 20e34f3e-4142-485e-863f-08ddcb1dd6cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xfgjrYYTzlulm9deJXmSwYcy3gDORmietQZVw4w7ldbyW1onaORGQ+tY9rqI?=
 =?us-ascii?Q?e0APxID+MisN4a64JGhum2v71yUGDAiKHz4y75pf4zoENWhwKOh/P/r9Sxer?=
 =?us-ascii?Q?olN5RbbhlDZYSD0sW+3msbLnk72o6W7TrbJp/t8Na+M7Murdaq9vIkvk1Us4?=
 =?us-ascii?Q?jmuuItsA1S+nUvMhFesGbghUwzs6U7FwpJJ4N0W9UHrnz7DUW9aRn6dg3cLg?=
 =?us-ascii?Q?mKhfT/NddMvJSxeZObYZYwmldxBUOi/k3UXqVIoqexdRPIuqxVIJbTr7g25c?=
 =?us-ascii?Q?9qF2Qhx31SnNzO0TxZUh9Mz9zB5E0KwJPq5krhhtvgycYh1IomPJDJTSs612?=
 =?us-ascii?Q?kIeG4aBeYxVL1EqwRMkmQmAzBWooH3WcEQfihYt+WNJXZQyd6G0n5L625DYf?=
 =?us-ascii?Q?fg50XQclhrBY6bVvj1x8KaJlxh0Xh4QmrFRPr1jKzWVYw9IKbENAtMBatJ3f?=
 =?us-ascii?Q?bQcBHEE7MpYsvgDdd3V7qoX9UD0cLLP05oIsXvtsYAoez1M/iqbsKZcBl6rS?=
 =?us-ascii?Q?h8c0Kk5VzQ3tI7uTh7UOCp+22JlcOeWIIs3YGYb1tef+bw2DFcVL9t0KJOjT?=
 =?us-ascii?Q?/DDyM/VnUn/NLZcQCMGgipc435vit9IW2Ec3HlRoqHkEp6jeJdVgTMgScItG?=
 =?us-ascii?Q?YC4dup/vK5LoWt2bo/sO1Vi7qAkM4UXL2saWgAqKwPucB/oDf3dU0p5Svp9z?=
 =?us-ascii?Q?NuZfeckWWuvKMYH2GpPksBp3HYKZwTQakQzmuslYEhv80h7vjGikp6mteYKS?=
 =?us-ascii?Q?CuDUo2TeXcaHd/mVtaOemW8QxNyQ86YzQ2ncSz2EvAP1eW6hmRe59JWIRjT1?=
 =?us-ascii?Q?wr40mgUssIJVqAKzTMa8IN96wa3KTTMXlZB713YJidaS/gBGX3mL0d/AbTWI?=
 =?us-ascii?Q?Qbx53/glcxpfhPR0s3BK6/dJRO2QAbLFaZGWHvdJJizn69LujRAkVkGO8jaw?=
 =?us-ascii?Q?i8cpwBQaFz2UXp0v7l4gldrpWqnzBKSFWN4J3/LqgAiH9RET2QyS8+34Mlky?=
 =?us-ascii?Q?OzTU1NxXpHCe3YGu6+D804gzJsNc1I4bGbwlR2TsOIQWLqw32pNmLMRcGrVx?=
 =?us-ascii?Q?lwf3voHhumJRKmYws3Rc9JV1f2dIx5/WxZqodsxF4K854Xdl2cy9A3ruucsp?=
 =?us-ascii?Q?5f4d1eMK11ZWpjujkiviRm+yw4EZlIJQsXACeqCDjif2Zp90caW9gC1zyVV7?=
 =?us-ascii?Q?8AYw4ty2etTnBBPcVpaZNBUZyz37g+6kdMebD9BV96fIKKRzWeP3AimFsJLN?=
 =?us-ascii?Q?ekiu2mEseHK0f9Gva6LLXT5kN7aPGqrKCIJKYCcPJswGUUZwfI0a1r/kvFHs?=
 =?us-ascii?Q?p6SGWtJeTzICaHCIxGOXpbTmZ03kkbUWCSzReLidENHlKB6a6zvTm57B97L1?=
 =?us-ascii?Q?fXQ5oV3bqkEd2/NaIn+1nBp3mJ2etILo26ZtsZTa04v55zWQxG4PBXUdvwQR?=
 =?us-ascii?Q?NhEqKfWAvFg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EbGpoiLDq+iIdrIE02qGyv01ZaSjwirQfhmrg7/CFT+CKcech1s0yIIbXj9I?=
 =?us-ascii?Q?gUiS3ZIczfgiMfsEvLaYuq/RNOZaYxd0Za5r9asxRVHyWPR/P3NfdeBmUMUp?=
 =?us-ascii?Q?z5LI9WFjh/ICdiHFhif/iR6iNQNxoNoDwBp7LOVJWsBfS0vkQtQqZN2tm2Co?=
 =?us-ascii?Q?qnyi7ERkyy2zIIMJazrGheBHNF1NnE/I4EQIuEM7eLiAAw95QhEbNvQxcOp+?=
 =?us-ascii?Q?3pkhVj//4qEh8OQ5B/x+ubuHzMfg5ng8VKd0cdtGal9DK2yD5z9Z73umhDdh?=
 =?us-ascii?Q?PM2MHcMufYS/7a6HfLdW2+4L3bxpCU2TT0XmFHE0/zCVfOuflcsNcSt5qtgr?=
 =?us-ascii?Q?Rd3fsEOql6wn5Wswhp7dYlepr730Gx2p4ZjdOoadX3Rdt0PSfOdaSk4qyqVJ?=
 =?us-ascii?Q?R3IQLBDgHD3PeuLNFNM+WWXG8oE0UaLvn95iPfKMW43JkeJkJlTJBH33GHtj?=
 =?us-ascii?Q?kwJDZfEO0HHs/F9pxgqT9IG1j0q1RliTsKQLd+/2ocTYYm2Dso6sInwemwtl?=
 =?us-ascii?Q?yYsT5ePYoV3rRQ1F28t+LpIofrmsY9LwPEzqDPP9tOQaHVsakLItAB440U7s?=
 =?us-ascii?Q?VosoLW19A9BDjIPMSZW0RxpPRUn+18Ori+Y4rouakoQ5XrxihR0RCiB3G7U3?=
 =?us-ascii?Q?hZ/U6tGAwZGdllCKhgGjz2Dq9E1C2fYKfkdAqhnoC2VtqV5w/t7o9Dw6JuHO?=
 =?us-ascii?Q?Y93Z3XqP+Bu9Ue+UmmB0q84fTYOt/EhTVSc6LYHonW55I1HqmneIAD9ZOcgW?=
 =?us-ascii?Q?+jwOOmmQGTc0aVJ4QsOif5K9AMSUc9/1KnU0yvW/kNVULGCButKryZL+LVzQ?=
 =?us-ascii?Q?uEhgtxaQdBC4MAsAsCNsGBE3AOgEM3Z1dNdOM+Bt3F3SHt624KOSqJlVXTxr?=
 =?us-ascii?Q?XQpFEGzvSnWA/7tp0CrRNNGG1E8kehAP/aRRg6kVmB1fyakB/ic5C+aX++jN?=
 =?us-ascii?Q?SJLzh7OH4kXCBZ7fGb7vOKBup8uRc5rHIR4khQZZeppUEcjl0AdvfIvhMtiW?=
 =?us-ascii?Q?abnwRczkPPo3J2KtC48NuTRmfn0TytLkwRy+iKYy4FFCY+S+tv2eH4DsqLes?=
 =?us-ascii?Q?TiRULfwG577bOUs/XP0q/gLnFsCw5+Nb5Ah3FPO1LlcTjtzzhZYni70AHKVz?=
 =?us-ascii?Q?jgQjh1p8NTEUFZkrB5uS8bTioibbFHPW8dEHBUvq3jcoRqPZi7XSsqEY01Fx?=
 =?us-ascii?Q?5ZMrlAyWC7Nv6/KxfDwvYt1or4F9y1iMe6ob58ykZ8JmWTJTz6z+GyCF7ejC?=
 =?us-ascii?Q?nUjXksizu9BQqz6fjfnOndvF6H1b1tsBMZQmurXEsKpYU3Df7SZQDxPXiTcP?=
 =?us-ascii?Q?T8n2m683YiEzqKEZf97jAuTEaPL/z7Bfqqtc8mMrofHR9eHlkQ0BMwhP/IRc?=
 =?us-ascii?Q?vSDv1PKo9FxYjaP82T5S3hwbnau8Q9mZHnRcG5n2rFa3x+CUQYkBJoHekaKD?=
 =?us-ascii?Q?2b1QIGnJXST79veTuE50hcS+8tfZNN7FYVKcqxMJ04AtouPcpMfinX4sZAdo?=
 =?us-ascii?Q?uA7Ojj9YIzZfg7a2qPR9nO0m//V/TdSzjF3AQBghowhelvq5YRzyQUCTUcXn?=
 =?us-ascii?Q?sFC/FW6Q6lf+0t0wjCWmxGYMyJmaiKqwBthfU1IXrKDDSWKpb4H2bETzecPS?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a0vZhkCRlfMnOAfhPbd9pEHWNuBJBT0vr7PpcTH63g8y8UQOS22HffdP7nwbej7E3ZbSG7an1di7hJCFUKpph/9DzhcK94a2ZnXsN9sZVRCtwQ+K1okkX4/tZKmM6PlaPXm0/4QcZwvDiEYm+fA2i/vRWd9y8fmPn/v1lvfZcselc+od8/Ajb3v9NO9sriynACWAFA6YueDMLiSuQO/MhHJxzAKhXuNPEY7kejBrvmOdK60BgeQf8xHCv7pSZAWlCr8UG/0QL/URvR1wcC5048cEwNvlh1nmzLoNI2qkPi2OItWb0sCo5PBdY7VazzORtvdsYZyQTlnavQL1RMbf5BZ9qdDGEwdyAzerzOXsuJ8zNmNBbYbLwERVOXT3dGwGxK3HxP062U+PK873PjiMGyEOJnT10ckY3EvkZzx33UAQQzloNybLJ1Xa9upu3PmCMEWwkurE8psSDxkKs8c8CUYEplLD2UQGKnmgPvkYEYb80+YWrgqWzVRtQjoiwKqheZTehN4bj+fW0GNi1jpSB7I9R6JbmiIq56Ob8x75VOvG3zmPthVekb7f5Nkol97aYQ6PZKv+a6Vv4EuJMSVo8cUnGEfnWjsamoNUtQB+EZw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e34f3e-4142-485e-863f-08ddcb1dd6cd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:51:57.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mo5jnZiu8965+8x/99HxP1t0cWNP6mCxMpGYDf/YSOFxBvlie7RrOHN8VIWnHz55qFMsvo2zQ/X5WUvsq6X0JXYTUrdWY5bQJpK+22fImVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250013
X-Proofpoint-ORIG-GUID: WAbXkbGSV4RLjNnn039QwNTQiq86HOan
X-Proofpoint-GUID: WAbXkbGSV4RLjNnn039QwNTQiq86HOan
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAxMyBTYWx0ZWRfX7inrX3DGCFz3
 V4Ip5Vrnhot2pepnn3fFv5H6O2mxXqQd+IngS3YgvAUlAsJd/IJja6zHnZ9iUsmj0NogrBN288d
 XtOx94cxvB6fX2TxhIOh+jHrGE8rrG9cZx4fEe3rzu+OgweGvCpMwx+QC+U2ffH/upgEfqIairV
 Gvs12qTEnDixEPmT2a9qeWHuqtw+MwY7j1yYKisByejtkL5B2uZLNi3b4X8MAuNsUVt2ecV2not
 4vzU1S8jH7pzsEa8bjGjXlz7bkH/1oGHI2yfoKKHokvvYPk9fGmJXeRT9nfJlP4Iq6EryqufNhq
 QtQCA9DP8G2i+1keRzNJtAkD/tg0CKxUXoqEGCkL+F0pSlE8ZRdF2bzNYCtp3dv5DxVjLilTLtJ
 f0w4AnQYKaOTZ3tgdqCigQoHsWu2KrrFhHmUFJEGaOwWSvOWWk5e7mBPeBM2aO4tZlqoO4dR
X-Authority-Analysis: v=2.4 cv=Jt7xrN4C c=1 sm=1 tr=0 ts=6882e340 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=P80SZndxHWruEk8dvCQA:9


Pranav,

> strncpy() is deprecated and its use is discouraged. Replace strncpy()
> with safer strscpy() as the p_buf buffer should be NUL-terminated,
> since it holds human readable debug output strings.

If you must do this, please change all the similar occurrences of
strncpy() in that file instead of just one of them.

However, given the fixed size of the buffer and the length of all the
defined static strings, what is the actual problem you are fixing?

-- 
Martin K. Petersen
