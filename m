Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606C154C04;
	Tue,  4 Mar 2025 02:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053795; cv=fail; b=jpuG6CIu4X2ndLNUHTkAqMpZnsamG3tck/YHgGMRWtP3W3zG3v4NaH2xs/FG9ull2nZablM/v1xbT470mXJf3A4OFEVvGK7YxLLDvqJ9cz6VM+xzV81kjQhZiHwPJHNgdOj5009ifUp4OX0IL/PrFYeLEkbl6pB7Wp6rMpkDiWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053795; c=relaxed/simple;
	bh=it/jtQrtwxIJ52v5WrpPoT05dkss1ZQASscTL62xIUw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gvzhCGMCsFFNnJ0B504XAR30WAO8ShKXT9M7kyxp+Gk732ff5CGEu3fgNK2UhkhpgXs6ud3AEk0pU4w6kJJTsAoe3lFdAAfLiWaOd1DFm0DJWy8xYFz5xKoiVprAB1c8bBZgZMo0leAWY8jv4gN7GyTc+wbQ3fsnMRFeaJ27x9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aeKks77V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JcKMYbU1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aeKks77V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JcKMYbU1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241OHN0016384;
	Tue, 4 Mar 2025 02:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=bi4JThr3al+d4Q0xPI
	PlSdLEa1G3clwr6nhlrO/HspY=; b=aeKks77VfVDbD+YaYFPlhffgE119n3uHpO
	053Ry0JNB+Uni9Z/KYmpu3FtpGVMxLyQ01jlHeBjMq1ywhcyulYA8OdVI5BcL85n
	p8ljtAx8FRDXgIvZAo6L9a0wm9AQVZLCxXwn+kqAiJfZaMz2QnlOpdnodalo2smD
	UYvvBP6vrRYUGNffD8LjxJLxuHsZgDtIYGA4crmu1/yX0pGhn3/UfygyQ12XYlvh
	uBbRLHSXrypWIinLUCv0MHFckm4EOwwXp0LL33Eke1zDFS+fX7xQ4DVgwWyGjM5l
	kJ99hNxezB30uudIQq5Z6k6qgN9WcawJVtePq6O+i0yAx06hPtdg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453ub741b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:03:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52400XiF022650;
	Tue, 4 Mar 2025 02:03:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rwu943n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOCg8t/2ttzgEeRm6A5QSPteWmUi5Yi3ku8uGMmerqXdqnTk23j/xIQhsNi9GAZzGtt0WyBpESNTY41BADs6hQVUoo1eAdEEDMP/i6U+wkOP60POJrqBmmxBObr38NeOvvkAD4tzY+TW/ZgUL12zsS3OO8nF50X5s8Yte1vJurDjYevVqKVVi07Gs4xbRt4jO+Ngu0xVu/8XmoplNMoP1kPXv8z7GiPcvzO7mZeRSnLvyelzKBMI66gPi1L0b9dWXBlut1E4wAT+ro1b4NdgAk2IjpmWmRmEQYN1BHT2a9/8ef3zBrWIOGl3c0d8TVmLjhoMRDe+A+Ei7f0t63RlNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bi4JThr3al+d4Q0xPIPlSdLEa1G3clwr6nhlrO/HspY=;
 b=uq+Z4INJiomiKOPgOU/3yNf1xqOPWTb4j5Il76nnOGwRqviOgFPirnXR17pHCMSyJCQzh+SbbNaf/WGPEAlZNiMIPEA4DDm6ZDGJYq+QByQ4V6qzXIFhiFXN2p7B690DKwkeIqzSrIFg4UUVMi6Ha/GtatVuHcKj57nb2mNrzpmQDCUxdqFzVnpLy+ao3CzD/YRiAO88O8Ji/ZiDUK2yYj1B4DuG4avx5QQexOOz+ABOJXcKm968EOOWEnywlnSpZ5ydO6DSoeJRMJrYwEM4+SUpB3Vj4CGEQ2bjMEOn6UD8pgnOWaBid6YrRURSclDC1zM+dKlbwID5qiiTDZTCFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bi4JThr3al+d4Q0xPIPlSdLEa1G3clwr6nhlrO/HspY=;
 b=JcKMYbU1EqY5aLz0Hq3DRWm1EI1yIjNNDj8DCXSnVomq+H4ylao6ousbAeO+BkqcUtBzFh9sQco9GIPXU+FiZo/LoKXTA8AiH+tDpoDXzBeseLihhdYmJUWyH0IbRwq4Rp3TrGKVzVeQ1T2VmCvejHvfQNbsqromhtcXwX9Aggg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4220.namprd10.prod.outlook.com (2603:10b6:5:221::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Tue, 4 Mar
 2025 02:02:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:02:53 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Heiko Stuebner
 <heiko@sntech.de>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: rockchip: Fix spelling mistake
 "susped" -> "suspend"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250225101142.161474-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Tue, 25 Feb 2025 10:11:42 +0000")
Organization: Oracle Corporation
Message-ID: <yq11pvdwo1m.fsf@ca-mkp.ca.oracle.com>
References: <20250225101142.161474-1-colin.i.king@gmail.com>
Date: Mon, 03 Mar 2025 21:02:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0422.namprd03.prod.outlook.com
 (2603:10b6:408:113::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: 084a1845-c2f8-4e08-5ce7-08dd5ac0acbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PbwlUHTMtd/DUNbFW3Yy3DYZgWov28A5EbkaDjvP9iMWtL3rhlGezpqKIULE?=
 =?us-ascii?Q?HRNG4CWNbJ3GLC0iy4T50UW5uPwqz60HCRuG9XCMFGlzvz80uSWZP6f76Lrr?=
 =?us-ascii?Q?I/R9oKIK0jOUlgll4zoP8at2IDJ0doycuERrW44P98NKh8/wFEV0nKJkfFnb?=
 =?us-ascii?Q?gxIc4JGu21DE817pSQIHUCkrwa3fWU32oN4SuHaY8U3TE1XABZOT4kDEQN7q?=
 =?us-ascii?Q?64ocNifiQKHuEio1dxaAThw5FcQpEeajkLmWgGF5pSdmBXnaRwyj5SwHEJUS?=
 =?us-ascii?Q?//ylcjUIUgdF/ny9//fa9JfCrTsHpXdFzYuJGlneeRo/19SsstLJo15GEGx7?=
 =?us-ascii?Q?wG8GT0Ilz40O8/OH3zYuPTuWQwx9DFwG9BzDYvrV4UoCluwww5sFJZD9RBiS?=
 =?us-ascii?Q?Y/NoI5IyMvOwcmHR1n3W+cGLmvOVB1yUf88bosnRj2CSU5OMCPTU607zK6cX?=
 =?us-ascii?Q?1vUeCGoTrwlk6WPYbTLLpUDvfsWQGI7H/31OYs2clNJbiYIVp1vYL7J6a+Td?=
 =?us-ascii?Q?Upyd26Nsm8Sce9OMld2ABLpODilnzb1VIhE3MU6k3NC/LEmw1ZAWyOswoVcN?=
 =?us-ascii?Q?be+slwhh6OtuszVigk1iS3SOENS/ptMMrqXctc9UcRjGON11qZLUDPnDTU4T?=
 =?us-ascii?Q?Mq3J5ZtCInoBBSy+BDRS5FGVcxVViCLouU7oqM0rmGFwjykTY6eRp4ZCxC5q?=
 =?us-ascii?Q?lzvri5kGn1eUH7EXgA2A/wlosxRPdEUkYE1KjKEx9LuhCXILYDmyNQzShRXh?=
 =?us-ascii?Q?xa9RfH0U0twt9dddw94d9kgEZYYk3HDY18pwWMcmKuDEibFv7l0GmNzEywsi?=
 =?us-ascii?Q?r3+QdbYW8HlhECtLQTzDeftOVHYGodr1xrnDFyI6/85xS6C+kRxkL9RGvVxM?=
 =?us-ascii?Q?fnVDDySGRmrRqmsJYw3liJ/yLUyGTfV1eYZVlww8u+9vQPIaAzgb6HfYLrOL?=
 =?us-ascii?Q?o1ytjg1W+jjnqZ1JDgBhRgnWYGNDK3dLOxLz+mZ+6xBCOaUIUhDJATPxFgZl?=
 =?us-ascii?Q?RiVx41p9rObX0wKUHFB2FbmK9qfD4pkBRP1YWVA342HfkqhvNjWF+XZOXaGL?=
 =?us-ascii?Q?E9mLAhYE98p8UpxjX6Ct4+DB4GNb6Wxk9o2wPfvUTzsrZQqo1oJBvuidAUPm?=
 =?us-ascii?Q?w4duDMrktmGdEJj/wLinLyz8EOsZxqm+YQW+drWWgNBqNxbuOM9J+eqc0PuD?=
 =?us-ascii?Q?h/xa/oPxamj1EZ3LO4NH8GiRcDAhsOu2wCoN4DgoErEOfzRPTPt7V+yX4i5t?=
 =?us-ascii?Q?nayna0q1YNiJppur+FtkOvW+YnOCaDfqqIyT1YADwY/RgxhUQTK+H0bZan7L?=
 =?us-ascii?Q?fVEQLc5r8flpAVF0Bhc/F5US0WTpCXq71DZj129jyf1ihOb8SMciHTrC2B5c?=
 =?us-ascii?Q?Ij0cLvVu4BdBkxvipfKQQ9tQgU5d?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JM+fAtJIpPSwxB4CBnFJZ2hNsaO9KOUcamGSpPV+KO9PDN/h8vzHQkKmDMjq?=
 =?us-ascii?Q?niuBYwVDNVLP+yvcC4uCjuhKi7mJtE9NzoeMf4mxwaK2Mwg4UdF8h76MIeZZ?=
 =?us-ascii?Q?eWxIHzZF3cV/WGW4tIpvLOOBf/tYbDmFZByRfpPcu9fLqhsxJp2IfenRqCMN?=
 =?us-ascii?Q?5B9ulq3lcE3pn130grk0kJwnan+MnnFOMYwFVE6MzTkUpy+WTwNsB08I2U7Q?=
 =?us-ascii?Q?qqyN5rx0QI9AkNLQGj74IT/ahbAcfY1+Gt0bUkLNX+0rqc35phElfAKXqh3w?=
 =?us-ascii?Q?zf82HYS31vXNxcOtS3EauqU17GHsZCyeqkyKc700Y3EHqv6FRP3DzLlGo6/J?=
 =?us-ascii?Q?nz+ygGDhoXcJ+Avjnka/eUE91adh1Pp1N0QHIqT8KdhSgiqC9HYHFx0xi489?=
 =?us-ascii?Q?RVH2nk5SCWOJ3ZSv7mjoXqUjPbb6Ai/Hk7PjxisPIeKYgsqBHGSKgwybU55G?=
 =?us-ascii?Q?kqEaOHDUC2z2H2xnf+/m/4eYXQS16Mhc5N23Jky7NJio02hI2+wFRHoRnNmY?=
 =?us-ascii?Q?HMzP7cKOBj4/bDfWD2x7Zxuz4HLDLFvbhqS0qC8zD/f+Tckeq/SaDuAGKOZ7?=
 =?us-ascii?Q?3eSC7AC7b9XJnd11EGr8P39wTGSuEowc3iAx9usUCPq75GLexpnAb8fHawbw?=
 =?us-ascii?Q?SPYszwangEtRj5EaGle9wmIcalANUT1CD2e3rpkz5FrG0lSZBViEE9oSgY0G?=
 =?us-ascii?Q?UCrh5LPVXzfKDEkrfcKRBm6tJz+DvPtT/cZQh2iIR9FeR1iQA7e3IYFJN53F?=
 =?us-ascii?Q?bjNy4KUtFvU0fo3rQCLnq8/JZwXYwXTmM1TCmuCsl60N8NVnOQWYHZQPb0m3?=
 =?us-ascii?Q?PG+LRxO8rgaIHQQrQkRiwoxk4Kr0SDnCjJlA/Eqvvyt6VKr1ZDr/1Ekt92xT?=
 =?us-ascii?Q?GkEYQ1s82twDQxqkirWmmkqcO3sCEVS3VKugWk6F5r/eUns8fPOLA4FNp7TX?=
 =?us-ascii?Q?BoyfQNL73JDVwVIiAJjgKYpHqMDWW4zYUwn7R08R2VjkGibb0wSRe1OXj241?=
 =?us-ascii?Q?v4GdwtG+ELjKrMgiLW+HHCDRc6bNqDD9dsDFQV52ORwru7QID1Ukk57fT7Hp?=
 =?us-ascii?Q?HwH14rLkmYuz0bjkyMZVKWXBB/Mp83KrAidtizhcaBcgO8i5dXvrUVyvLi5Q?=
 =?us-ascii?Q?dPv5F4YP7q56bSOfZr0rLwQ10MY1MfFN59TveF4bIYi0pu2fV8CJREH76eoy?=
 =?us-ascii?Q?Udn14Ui2hzdlYb7yn4EvQhaPP+0+Wq0y8gMQfEMCuZ/XYu/ulEXkdiDhyu/I?=
 =?us-ascii?Q?WNgZTfCdqNeWMludIk8BIt2p+QSKvQFJ/qrceS1Bj0mdlbNDanH1+CGdaoW3?=
 =?us-ascii?Q?tVfg7rQpnT9Yx1/kXY0QGqeZR1wrCl2QGgrX5Em75tWtzHGfYySmPEvS9ivk?=
 =?us-ascii?Q?4QhukKQGqAoPfq8IX5+fh05IxxGKaYizZaOAJyXEwBCMGuMqZFvtY5tqvZS+?=
 =?us-ascii?Q?yLU9AuX2oYgBReoU6MDq2xWeLvGBcE8CKLCXf+/r0767QqQdGxvg+pAhqg1X?=
 =?us-ascii?Q?CbfGcj2RGXlQiO002hChVFzJ9qvMHAn9YqWJ7YkzEzH9fb/LNZ54xl0aCfjl?=
 =?us-ascii?Q?YOoTU0KnqNNbhsUe3kfEjdyLYTvrCymQ4SxGvTid7tkRhiYjFQloPtSKls+Z?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aWvR+VZPm1GvOwwmvJTE1HQoEn+P+8tmqetc7fO84tfwh3BU9NsOhQPo17SRIDaaK6kTSQLtooTMkKIcekkc/TbBFLj144UoO6ZwJKIRh1CRKkpwAokMLWm0+XiZxFtd9JGeg6svWevVlJ+trd1twyrw5/fo55B9yHBrf3tCmNeBwfPxGrpTIdnmo6e4vb+JvChuLj346tXMTTtYoXPuW/eF9mJqFCdx9pRWeHY7wYAPQoLjslhGAOiFHzVrlJof5VrXe1OoeqwwAESvZ2gSAxOu4t/PFc/SYPqrqVwOnAYj9v/M+c3G5m+8Mq8D84YC5qiF7vRiiUbx03oSNoCGayDdSHRSkA0pqjtoKJibPWRdnYjCHPHVYukHDTIs+mmJsYjL1r3uEvYfbUGy484vPmpr5xj7RzC4BoskEPpMX18bs6djlga3APwoV8ur68UokI3ZEPyqzIVUH5a/QnmO84/i0rWLDj521mUzwQdeykafrgfD8ht5Y2Ahi5xMe/qUpokzPC7yDSmt5+VbNx8ht4bKrihRWd1Z+eGUSdHJO+I380ynNh/EUik/dIsZtoJZb93VUjd5JCwW56nEZJy/rmctuz2LJ64HwUhwHDO4a6E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 084a1845-c2f8-4e08-5ce7-08dd5ac0acbd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:02:53.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vt1K1s6FrOHihaNgBkTIwGvgSnidKqnxMQEy/YpVJ0U3WZFrj/HmPyFKhCuQLRHNzygvWLNdesZSWV8wV2u6EEQErCbiRaIgEwNJzArMLUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4220
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=947 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2503040016
X-Proofpoint-GUID: XvTRKUD6dej5GX8fSyJ6d7WgwZdrHpvM
X-Proofpoint-ORIG-GUID: XvTRKUD6dej5GX8fSyJ6d7WgwZdrHpvM


Colin,

> There is a spelling mistake in a dev_err message. Fix it.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
