Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF876CA5E;
	Tue, 16 Sep 2025 01:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757987722; cv=fail; b=KleF+h2IANEwc2ydYaotSP0emASgJxjDM1eI5unfIiDNN1LpbOgzGa+Ssham7zcoYrREVfDUVmDgA15tdTeHh+Pv97M5Iq+T1SBc7am5OMdK7hDN/j875lnl4/0gmAWn4XPNX7xQqKjVy3MXxuD07o9yaS4RSNC1SCaUrw1CTJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757987722; c=relaxed/simple;
	bh=CNOigIr4nkJRT25C+xqV+bptPzeuveYrSEIpty0z6Cw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=elvou5lsu/L08u6cbRPr6ekRMi53m+4D9LBaNjje+oglaYoLnhEtmBoxm3tx3yVa/EF/EwqFzfyjUGqCKbzdjJyNNwxTiiiS00Nu7MkJDyJICiIGJ0LrwFmOHiB6OvvjF0X954Ln1Q/iNfesleiXuPB10gmzjaKRGZX1KsVuTwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d30QER4f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RihEBH7x; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d30QER4f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RihEBH7x"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1gIpr002766;
	Tue, 16 Sep 2025 01:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+yprfMsjDiq+iKjgTl
	/Qp547IYehP9d/fn9RDeSdhuc=; b=d30QER4fMF5p7jS79ljq4hrSARUw+Gz5IU
	qvKjf5Xzn9PclsowyBqf8vs7vwwEbdSRFdDc7gFBOJ2xXWXWUgRFELrK7tZu0xZS
	e0VQRpwaeJg71SoXT257APHgkS4DtO90ZjW1s2WLIk7qKX0qpKAu01z075scQ8uu
	mesPhU8J0fB212hQMFUkuRrbIHnSDzVqoNfzwdo3OOaNjwE0TQOAZAYdrtsJ9f42
	jBPVoGp4nU+VZ+2TyYkhZPkZOMH5S3cIymWBaEkWdnCnJZAy0yXabHUec6fDqU+y
	6BBFteikI5n9ofVImks4F0caGlCwMYLghMsZ+6zHfSBWMtNM9Ukg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v3k3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 01:55:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G10H8n028839;
	Tue, 16 Sep 2025 01:55:19 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2br1ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 01:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jyISNkwwwsUIIqXAsDyW88lZEAFtKaQi4peoFUmnr9Stli4D+QRguFmYiYJfmF9ylfm12VrDBw+mCOy6o4GOPo1U1jz+IUX39quO2t3iqplrEM9awQwxYSO9moDnVd4PqpFYrx0gU/4G5NgI3UuFdPYVyH3xO8+VlKiz/86mpq6fxlCO8Uvtvn5Z7VTLPQSYMNPhubSO1FiXFmd8J+AovqjK0xMPixvRL0g6Qu5WaYdgseGOivY6GOLxoPkuvnohHtL+/cJLGT3PLmCQwqvFmfs8cnxeebsLljpnKH5kdsJNBeWDeyBS/8RYF6cQCXYESuC3SxBVILc/uh2rYaXENA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yprfMsjDiq+iKjgTl/Qp547IYehP9d/fn9RDeSdhuc=;
 b=yQbIwfEQB8GzoK5aiiz3pr7HCNFrrhbzzyt6kA3S5h3ERrsif7H1b5DjxmhrFH3pKnoF3kEnvH857WrFbP64oFHQ8qKOF+xSt+oLVpQUsi5O7/RoqEWGeJhGCyFqDwcwHOtL6QsMY8PRxtAkuXopnd9rQTrq4XQEnCkCQrZGO7AQwZvmRoHgFONygKhD3xqpLzgfPwcpzpVe2c51DmW/2jGZPr98uRqwxLVoL+XfqUSwfHTDWB3WdeK+4uIGbeMHv+p/7wICo0zAR5PMYjxV31ttIr+I1B8eb5Oxz+HlZlzmgs+ye861l0jFSMjJOFbuYn2vXGUVYR3T8u+kPG6G+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yprfMsjDiq+iKjgTl/Qp547IYehP9d/fn9RDeSdhuc=;
 b=RihEBH7xpQNr4W0nmc4X4Uwzl99eXuK8f4k/bf+sTE/g+FZMauG1bcywNi7b11zZzrlr+XIO0etszBqrIE//ABHHI11UGZ++v/WAh4qiNa85ZQ20wat8XB3Q/jJITaPBAU5i4SEesezCwH6R28PYMByHpvBjs7oE5byUkRcik2A=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.22; Tue, 16 Sep 2025 01:55:17 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%4]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 01:55:17 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: michael.christie@oracle.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: fix typos and formatting in
 lio_target messages
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250910190728.3783157-1-alok.a.tiwari@oracle.com> (Alok
	Tiwari's message of "Wed, 10 Sep 2025 12:07:20 -0700")
Organization: Oracle Corporation
Message-ID: <yq1frcn2mbp.fsf@ca-mkp.ca.oracle.com>
References: <20250910190728.3783157-1-alok.a.tiwari@oracle.com>
Date: Mon, 15 Sep 2025 21:55:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0253.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::15) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: df203889-6d25-4b2f-3493-08ddf4c415a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k3WspHbWLjnTPNQpZ1FO1O78wZAz8PoWfG95kdU/Guz0nrnOWR7DDAm04+kX?=
 =?us-ascii?Q?S5P7NUNhtHpR/nM6FSblIyJN7vWwcAD/h17S98UaGHa1UeoXMbZzJhg+4Fre?=
 =?us-ascii?Q?whtZJR3Cplq0smFSjtuNIzlmIZ1WPRfFe12zyuIzmzfeeNIwNLZxPKx5j2ZK?=
 =?us-ascii?Q?z67wfYDlTdas7FPOlxXe9eAatcDmN9cQgpH8xTnJmCZKAwQIh1eXLOjU76Th?=
 =?us-ascii?Q?k28euqMovgBB7j+xDvCFrO9XUNaD045NXGqPY/5hkk2+Kj4f4deLZTkBmU4n?=
 =?us-ascii?Q?0Ivd570Wclpec9RpmsJlpjC0CbAdR0PDNkh0T7n1xvrujLUCABgstdbpHrC4?=
 =?us-ascii?Q?Kno30xIo7FJTRd53+u5ilypH/VejAJgrkVpKHOtWHrSDp9nWfTIs5M2274FU?=
 =?us-ascii?Q?PxEfsF7HNltvh+iLtyfn8i87hjxWr0mT9XtRN2XTE9INtqTlfGSYuAhVIzF0?=
 =?us-ascii?Q?WM3V7HGiq7forGRXXK/6LuKKGBFKX/Qb/wGGzmUkAXDIgDq5zdfTjnUXEI53?=
 =?us-ascii?Q?UZl3FZCL2+PcaF0QHCbwMkvIw5HIqgL2sp3DDOsuH939oN72QrPryYMyRzyy?=
 =?us-ascii?Q?gUCpVifuVCy5uArCzgT/veKCDSxGH5QObNLc9vZviB8/jF8hPxiwBhyfGLp4?=
 =?us-ascii?Q?w5IB2lW1n7RSXvq9msRaf5aHFvdjr8biNa2fSe3G91PAbrBAd5cel8AEKB39?=
 =?us-ascii?Q?xn0Ayzu4WIdbLloQU/RfG0LH37esjW8N8M/GyZLeOnrrcl8lD9sMzxoiLveE?=
 =?us-ascii?Q?iiZrWD7PLxbX3BMAIYbPNd3JzROqne3RJQdogL1+72YxHorhGp4vRgABqXMc?=
 =?us-ascii?Q?RBH9aNGgtXSiU+udMcXNfbK5WueIrfTOOLIxKiXz1D83cL7T7L9VhLcjO8EX?=
 =?us-ascii?Q?Xw7TpghppuwEysw+eDZN4BzHzSjnhK4kMrWNlZc15cBwxz0qqRRfs2A8h0jH?=
 =?us-ascii?Q?ZKqWlquk7aWJ/a/+MVxB9+mnX/ebhnAYGzlM8ynplUROfXIFgvCpQmpD1MUg?=
 =?us-ascii?Q?pzaEk4ByCSHVI5xt72Sh/Dz7hM1DMCSMk7WyrPNG+6XBX7nDsiI6aivbi2lX?=
 =?us-ascii?Q?SgXjjIIVvVktsR/UTzyqaymz/tCzfXpltUT6rs2iEGbweEba9Fsq7agwVVT7?=
 =?us-ascii?Q?/kT+0Q1TZ3GqGhhNuladkJTDk/7MYEoPvDaLr06o1WZ2nyIEu/mUlpFwecqH?=
 =?us-ascii?Q?J0U4lKxb+ue5lZ7iW/Jali5rkIgHi7m5to+LgWp/DXtv1QZm7/ddBhWRF7yZ?=
 =?us-ascii?Q?lyxd9zn0gd2YWcHYMoLGY8b8I1Cg6yzZfy5hKV4H+sS/vX+AvDgytXjoNTs0?=
 =?us-ascii?Q?MZiNoPDAb3in5nq4WWAqYG9p5eJ6KwiBA+kb0SDZmO3o3iMrIc2neOXeNAGd?=
 =?us-ascii?Q?yMnC6ka1xIK5ip92wKUtjIoAQrTfqUK000DcoNs6GNlBwZvYGqY4F7nFgSVB?=
 =?us-ascii?Q?6gnh5tcOeCU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6PytRK77ZdxzfEvFD+f7h+nGBCh22o/vB2m+YVEGNKHrB2uwejFysKEfRt+U?=
 =?us-ascii?Q?X3kB11XOclCpOpw3JGYnL88BtV88sN2ZAZWLj1Vqjlt1QmjXyt8AbSRgWwtm?=
 =?us-ascii?Q?eFiTawjhiYgwbmdce/Vp6SxThGPCbj1pBu44ScJwL80e3S1t7Ej5pRQxnaDx?=
 =?us-ascii?Q?QtjnkW+CvGVmjBct2UARF0V2cd+Rqweh7hmEu6yuuu7ZAQYhjcl7nK6Hjayu?=
 =?us-ascii?Q?LMSFtTttcnNZNtP3u+S4koSb/hJOgpMKmXNG4FBh9YrFM4hBDISanl1gt0Db?=
 =?us-ascii?Q?NT4iiRnmN1R6FyYFnOYnP1+FFLUcxB0HrHl51zZIuiBjfH0NZcyScq3E4EK7?=
 =?us-ascii?Q?Enrgt+tuHzG8Vl7I28RT5SbGCSBfgu/PyLdI5rRcAHxBailDPEaHAfkNJo9n?=
 =?us-ascii?Q?e6tsxcQprHYmlidV+5NsPdgnb/QN77J6rCsJx3qJNIT9aMJ6DDculyLQcEp8?=
 =?us-ascii?Q?nhQ/kCAvcI9qa484HmTm5TbG7IghLX3Qjy262GEzetxKxFDy5v7tUBYDDuBd?=
 =?us-ascii?Q?zJapiJrelJTEFYAD228FiWOIZfcZEnxiuKL5Q3ELmWm+xXP8dvovvgJUf3sC?=
 =?us-ascii?Q?vQ0bLjJxJL0/gCpR2j0vlSA1S8xiObZwFiblGWffEflkKFxFNlzpBUQO7Lrh?=
 =?us-ascii?Q?jIQt/oTtdjL2YmH0AMg2+jqcJRDA+ivjrq5q3jZR/GCPHp0tEdPFY4kdEpy/?=
 =?us-ascii?Q?k8TEVq8Tk5Jha0tfCIl4WLTUKBDvDuHvDPaZPMKkN05NvKpjJuEtB8AJQS3U?=
 =?us-ascii?Q?HPNlYaSJd0h1vVcFFzbGB92+lhccAjYqrpS+NudbkMcmtOlSAVpL98UIxT9Y?=
 =?us-ascii?Q?h4quA0Dj1xk2RHiybrShVeMRKH8jr5X0JkT1e3In+JgHYY35Wb2XQIIXIv2v?=
 =?us-ascii?Q?6Dd89kDi/QK+fqbNOfGPy1BvQjXiF0ZEr0uBAuEtM0U6atVSlv67CjZ+n2zs?=
 =?us-ascii?Q?Vw4Oh3RZM4pbxqocRd9moMWlefoE2nilC+Oo18esAgyP0kNbqxwA0LxrdjA6?=
 =?us-ascii?Q?hJ2AlpsVYijTffW8EUm9wBtMxMZHlogLrIM8ANldkcD3iEFCJZaTvuCOcUYT?=
 =?us-ascii?Q?ekU4iES/upD1fCcXVmpzPfkRkw4KGv+qWUn/9Pnhkj5/RtefWSXv05kkSvRm?=
 =?us-ascii?Q?Eg/KvOYeFctMLesaeLt6YjkTxOcnfw23IUcK0etnOBD/b6vIs5AQ3vmUThOn?=
 =?us-ascii?Q?qwPYp9yEwkmks/Pv7NpYyY6+gPaqY10FXJE2Aw60VViVm//meTjekNGTC7Ae?=
 =?us-ascii?Q?FycH8l/vU8/0t91jijNaEOH5EECMrp7o/fn4RYD19HZKoTl7YNL98g5GORTW?=
 =?us-ascii?Q?QrU7RiiCjjpebETzbsxHKiQtK3ZSXR2v1mMiyjWxd69jbzINxk+2FBwuc0j+?=
 =?us-ascii?Q?69jf+gMY+UeWDGhZB9NXWoMb+c76vIaiokxGdIhbszdH1d3rNtJxVpCWfHhO?=
 =?us-ascii?Q?O9UGo9G+jTUUN9HN/1w7D1aevtTXXbpvm3IhtFrHaketdqhaIXHTqleZ3xh+?=
 =?us-ascii?Q?a4eUT9x3k4lhzIt/hmFJksiGuX60Ox+eOv35IFnIPIRmdKFuyQ9e+JwClJjR?=
 =?us-ascii?Q?FoVoIpAnGcPhtgzrAOy577enqsXgRoRGUYdHPLsxQ7+mSQEwm4N6dj4FxPGH?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E5DHntt1fB0QmMc2et9Q6pwNoFAvZy3kg/NOXdG+LarnRARwSr4HnHQia1K2JyItm2JhgKeX2lsUr3t7gMwb5am/CVUO8aXsNv3ZRFDai36WKTWspYuSCaZiOK9lnMEdoPOONhb53DRtvgiJWmFF04eFNI46uq2eaaPk+QsFg6yF06ZySQ5LofRkHbd5DDaVsrVdzoiQi/xqnbjI6QECT7uQmQFmdjKG0vNpGGNdrJzDC7190CMcNk6O8hFaxl57gG3GzoVFVWAwX/8X1a5PSvPURB8VcmY5c7JpoP7MDk0OQCfYo3YlULxbst65xUcxFGAjrgHRha4Uc0ZutJVEaMDneLQkjYs/BD6mai9c+lDmad4Q7JVK7tX/VkJcUI4cqis8V6dEgHjWrrnXdrvoUli859yhFQ5EDQhWUAakJg5y2MMFNw42sZP4GVHxjm+4etB49w5ZVL22x5pjh+jhGwc9ZPHAi5kEi5YmaUqSYzQ5cK/452OmVtYU7or5RKjl3GaMAPweSC0wbN21P7JcIG1+EMDh6XkIMouGWoLWg4KBQEynkyhVfUkogcQpzWesjqEgN/eIE6LCTHtji62TAgJVwMn8rMyiQnC5o++wipo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df203889-6d25-4b2f-3493-08ddf4c415a9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 01:55:17.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vwvu8I+7aFQrL1ZEOAMf9m9+wyv78a8+yq9/F4Le9rjHdtW3N24hzI8CH2QehJ/Ktq8cA9oMEqV6Le3K/ZSG7gpqlak+Yf9hX2o5BnsfDYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_01,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=975 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160017
X-Proofpoint-GUID: ATh52yV2DCCMeH8pVgGIT_2BnnYHRRFY
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c8c388 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=A8grC8wFmQRFXEc_IFkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX/GE7paWawHGI
 ckVieLYpDHJg7wuYFFf5w4BWDLXYemZwA5VeAHow9h5nvbx3DBUgy90qu1AFuG4txj9GaO833vr
 LxFo6PFOc25+D+EcsFgBw2BOCmEcNi2bxcciCNFgqxixqLzUdjSri42hSJt5yYoLeP52lby2Pha
 efkuSKsPKxX/rcrzkiMdR0XzVFv271zMVUia650aH7ndEKZ1uU4DcwgpRvmKixWReEPCtDa683G
 C/+7f0WD48crOYjmi7HBRmsdiFelKLkAO6vU/Swmf0RdS1xSTRoRDOrLV5eeaUCdYOo5yv0MaoB
 tWPa47dUnXhL929JQbU7vADsvBjvxLH/dXecoAgnA6jwCfUzPEA5tpfb8l5VId6oPfqPUit/yhZ
 1vLw1RtO
X-Proofpoint-ORIG-GUID: ATh52yV2DCCMeH8pVgGIT_2BnnYHRRFY


Alok,

> Fix several minor issues in lio_target code and messages:
> - Correct typo "locatel" -> "locate" in error log.
> - Add missing space in pr_debug() message for better readability.
> - Fix comment typo: "contig_item" -> "config_item".

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
