Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B54239E60;
	Tue, 14 Apr 2026 02:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776134679; cv=fail; b=iQDfqUDAZl1QeTY17J3kLXgfqVM035iSxg9N7L78kXLOCs2YwK2bYuv3cea688k2YQHFDavU/3Uf66e+M4+484lz049QIi40n7dA0rYE9ZKYLIV/FdgE4XwtXruYNG7dtghqfT1AMZQ7cfGCWtP2htzZvz788Queh5/PhwQYGRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776134679; c=relaxed/simple;
	bh=wYSSrspwAuwdPHrOcPDyR1ai3j3FfZ49X7ubhCStMnA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=phk9M5xWZgyLaehM9/bgZaxESVRa/PmAx3VStDtFNaOkdj7OP1uIPYDuNW7nLnwaZdSvzuWYsLRh6gObro4dZxRjeIOGAN4dN3DkoZI4YkXbL1WYqFJZ8/dSn1rVQH9tAMLvpSVU72X/ag5O2TD3luGLBvmG3028WR54xSWfhOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NHO2sglc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h/oL7yer; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NHO2sglc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h/oL7yer"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLAhlb779605;
	Tue, 14 Apr 2026 02:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XgI9beQU4/HEkd2GTE
	Hy07+HXc+pRpgBXJcFM3WNap0=; b=NHO2sglcNEbPCTVZImhwUYJIBCIshGD597
	UjvyTcKH/hT6L9cYhOAup7thBh+W7Euz2/65EBUBCiIGUAPIEO/u4oWIvuzKyH6e
	BypjN3TMDklQz3+AEsOcRHe48kaqdjb3CjUKBSRKgF2S120zOR1ycpQSaCOaBe00
	/WthHDrZGjjRi0R+DI8NttU6A82bG1/0UwNEG8Fu3OJwPOLQxUN/c5tw/V+fEU3/
	pOWEMjIoffrWX29MKAoBb7oD2+SxPrYNMQplh/IU9DYHyzFu/JQbOBXI3AiCUv6/
	qL/yQ1Xbupgox84CiUHG2tx4JPPQvAwsIcRqPuMzegPO/Q+WWJZg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qgcx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:44:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E2iU8J007011;
	Tue, 14 Apr 2026 02:44:35 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nk1e9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:44:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYYG/Y/0x+1Q5Wffd1z0LlnI/QmXEsvLSuEm1tfLjodv1K5eIU+fUA8Rw+eFDviI7fcYD7hYeJVZnqVMHgUAFiUoiMFx9STTk27ORT2BdrL2PtP3ZaPkur0GR9nsAKC0KCKjmXxVEH5FlJesmURnzo0nP2t4kdtNoHSttAyNBtkyOQbZQ6+j769One53sr0TCs/JPFUfrnn1pmcYRhUIovMPRVxvSBGQz0VMPi6JndITJO+jLNj0/TauCQ/OzlAVUi1+18Cj3Fd7sNyyUMvBZpcQEt+pDglKHxV7zmVjkcg2rboAYEUXc0adIu/sFU+E15vPY6CzqjbXluOW7nkLdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgI9beQU4/HEkd2GTEHy07+HXc+pRpgBXJcFM3WNap0=;
 b=xnPMw8xZ1so8ZxoS7zxQJBbmBP46KfCrrMZIu8x6vbhp7OtrSAUEj4IK0XTOywsz7Tb6xxVX9SgSvfQHWDHqpgfWDKnKp21GJNq8nc8+4TJj3rJv7U3OTqqTMQBp2DD681E/BQn8wX4tW/8hxoXrLftDmfKAuG0XWoTOBTg87JeOojlU3rDGnZF3UlC6j8ugVvcJcX+bLSEMFS126sgy93NhlrXxLYwvqLdkNL+QcPIXEb4OSJCr2RgtQclmvCUU0Krc+hXvS7ED8Z88leFiFz5LHISKyQToET0u+BGeS3icsJdf/kjl1yncT6RKUobKuXMS2dVvAMKG1evoELlEIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgI9beQU4/HEkd2GTEHy07+HXc+pRpgBXJcFM3WNap0=;
 b=h/oL7yerOpiOmXsGEuA8+HRO9mUQ7FH8axLBsz6Q0TFsnvIa1xxiyMpQWDKvbjhgj6sGPz9AMUyStU6XVjibP2SQtW4V3js2FKU8N3tT4sADKMwmy85R4t8R7J/KQoZthIzUHOMUIz9/UVlCtEUSkiDajOus231vAw5rQneMN5E=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5561.namprd10.prod.outlook.com (2603:10b6:510:f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.44; Tue, 14 Apr
 2026 02:44:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 02:44:28 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: configfs: bound snprintf return in
 tg_pt_gp_members_show
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <2026041159-garter-theft-3be0@gregkh> (Greg Kroah-Hartman's
	message of "Sat, 11 Apr 2026 14:06:00 +0200")
Organization: Oracle Corporation
Message-ID: <yq17bqatg5f.fsf@ca-mkp.ca.oracle.com>
References: <2026041159-garter-theft-3be0@gregkh>
Date: Mon, 13 Apr 2026 22:44:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5561:EE_
X-MS-Office365-Filtering-Correlation-Id: 2372c19f-a9ef-4f0f-118e-08de99cfbf8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YQSG9qupmzhOZkaNRsoEu+dYpAXq8/50I2EMTiSGEZ2sHoA9cVcuXjcIqMzA8JD6lGRM8sNYmJ7c0fdCl8vgIybu2KcWvurcNy4IKRuK9KQIJIJb8sGUQ0sl5kAGf9XlSMDFyRh2wvLpsHGZEnB/9zCRWTE+ENbnhce5I5as1D/YuesZP8afgOUp9pAIE0aOTGgVndPpPsUdPJCYoltjqXuSrzXITRYDa0lCm1l546NCZSwfD8O+0rEOZ4d7LxTsj7D4SsRDhHYh6iMMe2oaYdympdtKgIaAxLsnAEjadyuWzYTNMRNHUpM/QznpKMePD9kBC/2qIBgJ0w4LUg2Gxizl/kI91Nw2P7UXKr5zrdGunY9Q7ykfdGTcrxGZmyEjYMNaDyKSnrqO7bS9ie7UM14trNk7syuQmSkzzKgDLVTMF0hnv/9QFYN1OVwdgobQ/k0QlM5Jf2kqu8zZOmWKFdTHtQtj9R2olftenRmsGZ83MLF9EzUH8tIgD1b2AKElbs+Qy1Mkxz89W158mH1kz2iWFOm+2I+fJbgqvjjlDX7IrWA6Izh9DEKCVzVeG4ZBVhL3gTYJMBRJY9r4lwArETI/yUerRRE7XxNS7ogNDO+bTaQBC5pRmv5S9QUdL6RGdEHledWNR97UwlABFHocVppCqZJfpFYTvLSDalxzTsj/p3dWIV2DhNvWG5K3BNN8hFjTllC5dAFRcJB6h/h1iEwdqgezNQhQ5eMleQ7FlOo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b+LCn39PlKpSfmerBb9pm8NLQJPIeRF54Y5AmpKTwhnkeBNGUrBLSaHo797b?=
 =?us-ascii?Q?xqT167/hG+183qQ/RmJrobHRaxYeiBW3SHw3jytkt3KMXBuZB7QlX1Moq2qx?=
 =?us-ascii?Q?gBEQFHJ2pzmdugG5ktJzvo40fepajJ6EmT3Le/Lq6koNbSW55tL/dXq8OfNM?=
 =?us-ascii?Q?WLKmQEo6J5d1v9lR5O+QAuiVjq0yx6Lk3MjDo111FmUGipyE6hMlxwaXgo1d?=
 =?us-ascii?Q?XRvMfvzCMwz3QR3Ey11SjT7/05ftNGteLZn70gPeoMXeQ4xqMAp6+jALyecb?=
 =?us-ascii?Q?KXE++e+o0WIK/R+mwJpjkyo+tJ7nkHwTf37M2Ebe3pzDbzhh3M3Rn/ekslED?=
 =?us-ascii?Q?bRxrXdxAekKWsnRy1T312Bg7S4+dlFoQ9tqvFSi6TWkI8EPn3WKcVz9EYGjm?=
 =?us-ascii?Q?dV8XmHGxjw5Xdt/ZqcwqYRNOM/j+7qnAd8Q4gXLJBNLy1+Vj0x5ZCzMvrwNe?=
 =?us-ascii?Q?waW5GCmR6KZitdJa/31KiaPXjD0ktvssvyJI+6bW4piSUR/yLuuhCFxCchwe?=
 =?us-ascii?Q?LDcpowuQI2VDHVcX+UesOTCo1iMGGYrhu58/jbMTlzjQvH2GbtCfTjuSeI4i?=
 =?us-ascii?Q?H2sJF7B+50LqBhniHqbIpjVaF+b/h7KuQc2PYcUEs4SRiTJmwuM55RPuk3WI?=
 =?us-ascii?Q?u1SXfVR+hJAU9rtH57TcKhI7Gem7sS3RJRFEwbIM0bHB57DujWp056guFQk0?=
 =?us-ascii?Q?aucx6LIH4W2V+z+cK0yB+zOfNdjdHKYy5ORRMW+8RYEvdww1wma5CXE15BNU?=
 =?us-ascii?Q?MCpw/jnZ43kTgYwX6hVcw8lLVjpHj3M08lvY5us/0V70AQFM9ofZeuZZItNl?=
 =?us-ascii?Q?Ifb3v7W/V0JqmlRH0lLsnMz1lcvh6EayKW7plElnR7ft7Zyq+sG4sL0VWTvV?=
 =?us-ascii?Q?UMYL17DfnQ9ZzT+xo7qr0xJ0y90lzqvq9nw9bKhX2xvd343plU1HQ3wQFa8s?=
 =?us-ascii?Q?HS+6Lqfr30EcMLlGEMcoI5uJeYFd9RezE2huA6wq02EJWT+LjphTNub13zMj?=
 =?us-ascii?Q?0KqMRoZ6Z0FkgU1JPLeOcUVZseYX1y/x2cHkT7RRZXk432hJhODhUO3xVon2?=
 =?us-ascii?Q?Y5AvJLCfzKOdPBpB04KGcc/FAL6/P5rrsNBJlST4uB5rD+shkU8O17m8uY2q?=
 =?us-ascii?Q?tZjk9hPg8UHaQQ9VH4kinoClOol1bFTTdN83Y5E95XmeMvlCriQZjsMw7IHx?=
 =?us-ascii?Q?HiPtyc730Dnla591qevY+eTDfDWq1RTjYOeG37HzJIcWHMEpVUQ9PCBHgv8E?=
 =?us-ascii?Q?92CXCnUCKbaBzOA5xpJTVAEUUZ3iam2xESbbcU+fjaUOLr+sjbBoI15ztk2P?=
 =?us-ascii?Q?OAgURdf6FVHCAIJw4UZNcLm6Z9QQIIzNq0YFADZaBMBTmAZWfNQlJMozf0Dq?=
 =?us-ascii?Q?TPUf2rkauttJRaRaB+qpbS8kQpC5ewmlj5LK6GD8gYmxsFYzhBwFCNnCerDP?=
 =?us-ascii?Q?z/11z8aUeX4FKMNrmWsKeZkKmYYYf0Vv9t75Xjt4OnuchSPm/QI4CLmw3E9F?=
 =?us-ascii?Q?xiWHQ3HcanlqSKjlklVLDcqrOY/e0Ze1z3X1j4Ic83gGH2S7awzuFwQJjW85?=
 =?us-ascii?Q?zLbTBZa+9pb3HywACLgbYxwcLjPns0CPiqkqVPhONV3FQU78wB1zuIVOxrGy?=
 =?us-ascii?Q?9IUP0kEH43rsJvMy4gte5brWFdQcIXQW9vYJY40kNM69p3YCXrx6jVFhTp0W?=
 =?us-ascii?Q?RGkZtyn09ZqKx1/0VoHPldOAV3oKuRylCyZEyBgDruuySZKeB0ygijG+pOna?=
 =?us-ascii?Q?Z9BqpVjcgL2oJmvMgvzzbNquqqY0Wa8=3D?=
X-Exchange-RoutingPolicyChecked:
	vidxKW/lUYHGE6zyMY2pZZXqVzcMo7Oyiw5pxlv3UNe2a17WWXOmu4wiDENU8uS0KJLKf3ir0XM8VZY/qvRJwV2QGSaAD5Xpp81Bx+1mNq6/dBXjrBiiwd46WA7tgjS5Ckpihru66lZ4OWrWC0OBHxFrq9DLs2DSNHQkR3AAhTRRvXqj+rGV/7jiHDtArw0XeZWG9bo08gZdZuqvzdTYebhGxRXwSM9AO1PcQ/pjHh4RVvQXIFcY3yxp7bzkzoso9k+agWHzoJRo9zYP6vQriQOafrQixC0mRdQuC0TlK2NCRtZhLjHaSsiMMVNgxqVVQhhuRvniZ/SOC7Dul7YPng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PZ+rvm0o2rskSk0nevTDTAtGAeZcJGZ/SYMT7Vg1/QzbtPvIkD83cbd3InAxtWYd+6UlkEHvDk7zXBVKShjk3XAsgvr1QmdxD3ceohKmdzu4Q/YWx4e842UvBqIyWPnC2ih5wG78b6kwaJtiHqtdSUi7WuC/MlGVTStqBIVmonxvd5zVfteL9t+iuUoENyH/wr7fFx8tIPJKqNUMVaqkdKlQyXLIW4CCpfNSgsB71FGVgXiIEJf4sb/kAsGgAYJdR6SsM3P1HOs9GavIUFuL1hfv/oH0r3QtoX6kvcJXZ8UwdhsfJ3X0GbYA8fcwN4s69EK7sAaDiJwYSWehJrOPqhvvWZqd4aQv/N3y4b+3FD+fjESK65OgU9zcQ7QX/ca16Kagngjce4MZCkdv0P+++NLPM58kqvj5TqkX/uLNRfse8nFtxfsmlMBY5hej+sTucUd/9tDG7G8X8rJ2QpTNA5XYlHw74YqdQqLt7+uCmwIRE4sAVN3eRu8muYHEa0G26RXjx7/KhqcGWoxU7VWkPG0J/VeJEqsWyAIvW1NQpt0B0pQ41fqQv/+fVcJ5ZNQ/vtbdnuTP5279yK8EK0N8JKCjDqx/gY3vg2qQJktTjyY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2372c19f-a9ef-4f0f-118e-08de99cfbf8b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 02:44:28.5817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jo1k2okyhCpmaBZkERCRrnwtnoy+ZyxXGwVV9VUHOZqWxyjDPR9TvnjgS4bfxmil+0FRpb2YUvM1MrnwCOh63F2CfzSBN/drFBQq7fuXNKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyNCBTYWx0ZWRfX7rFAjDJoQhRH
 PesJ5rsDGEss+WXnmjt1bX8Z4u0qjxcjfKKwYGVvbCkV0+WF318ClRnuDaC19JtLgsvDrSYAEHJ
 t6ydhQWPVvhrpejyfGhnQX9z3n50KDah5Asr5eS0SrjisiSogjNEgEoh00TY5LL1WgPXKgN8A6x
 dR+4dktiaVcNVtszx20hXwdU4nYa79xWHQQwV6EJiHtr55ThiSJHCxfge3MY1LMANxW99BwqpkE
 5cfydBFFbtNI/G+eFGeXkJSQKNuGdV3Oo92Mzgkd8B7n8/GWf9I+qTmkKhE8s2NvJqCdV2d5r1U
 1gSYkgf+SbRLt8E2S9XOdcB0zvD6jRVRNrGjKJRRE/aIrIeDv7nyhDH+C7UuObjQwNxjn3m05D2
 MXT5UVArJ32N/2GI/aI0NlZcEk5vxNVqk5eovrYnVa/atP9AXGsEw6CIEtG3mg75Xj9yJLq8Nk9
 GuRvKxwsDrAs0xY0fYEWT3mYO/avhTnzGMbVWvT4=
X-Authority-Analysis: v=2.4 cv=Lo6iDHdc c=1 sm=1 tr=0 ts=69ddaa14 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=CMn-KAXjp4Kll-2br0AA:9 cc=ntf awl=host:12292
X-Proofpoint-GUID: KW8Tg5c5KezUX8IwRG10WPPykhEoN5Ft
X-Proofpoint-ORIG-GUID: KW8Tg5c5KezUX8IwRG10WPPykhEoN5Ft


Greg,

> target_tg_pt_gp_members_show() formats LUN paths with snprintf() into
> a 256-byte stack buffer, then will memcpy cur_len bytes from that
> buffer. snprintf() returns the length the output would have had, which
> can exceed the buffer size when the fabric WWN is long because iSCSI
> IQN names can be up to 223 bytes. The check at the memcpy site only
> guards the destination page write, not the source read, so memcpy()
> will read past the stack buffer and copy adjacent stack contents to
> the sysfs reader, which when CONFIG_FORTIFY_SOURCE is enabled,
> fortify_panic() will be triggered.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
