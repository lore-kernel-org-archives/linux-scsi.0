Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E494534B2;
	Thu, 30 Apr 2026 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564619; cv=fail; b=TA+FKIGca5kgKK6crQ55iaWXcKyaaHQ1wqEYzEiCAcoBjoJteTEc/lqm17dQTcrk8V85yRYUUIETa9spyrDwOVMzzEJYRrlMZMF+x3T2l2jePY+4gTfthHXv4uS2W8WhQp/eI/WOepxGCecfVC0c6uug1JHm2SR9MfjO6K31pKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564619; c=relaxed/simple;
	bh=XVi8dhcyMd437J9xJN5ehTlh/MlZOqrszNQiLLqj6OE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sxSR85VDMOw5LXUffahVLzppqWVSnFYEvlqCp3n3ORBarPTrmNJjFUqieJaj5li6JzoHrFnWH77tsjJUTbo24NfsBesTUcV1WENjg1ECPB799LtaseYzNvyQeg7wTiQeXGtYPKSPTJS5RZqblduO4ovcjVZZq8usYW8rJH0gEEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WaMAqvjh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cHCLaCAr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WaMAqvjh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cHCLaCAr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCgSqD3913436;
	Thu, 30 Apr 2026 15:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u4zrItANfM1wMNbI/e
	QYVTBs30uneCKfafh0X0a1BU0=; b=WaMAqvjhS+ZfUbwFPN9MXbpCEzqweE4We2
	E1yyAFoKEQ0nWA7L7MpOXg2K4PsOXZep1epda7lGniwWPjzeWl3I9sPFAEq4pr9R
	TTCm/aX052DzZ5ulE0/aMjHNpXSLfkMdo9KQ77dpMvXioiJKsSvhTLwbYmc/UgqA
	ZKbXW705B14Ek81TwBb/yWhrTlYcbEiRUezVKUyOhHrILPidQ+GpMrgJpKwtO6c8
	+FWWdYzQsaPEkDbKwOT3McFpDBMouIDY80Q9+qCZhJaPbrRHj1GcaMqlPWURZWiA
	kpypgVJ89HAIVb+ZpaDyGO9iw2JVK9b6MCNGgwgcncughotAiHZQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm705sr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 15:56:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UFuHuq002940;
	Thu, 30 Apr 2026 15:56:53 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013046.outbound.protection.outlook.com [40.93.196.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2g4he4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 15:56:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8fQyNkgy2bafD+jbveQ9ubR+rXN5Une7mb7xoi/KxuVrwlYz4gaZQvH4SEDm8dRL0rgT0jxLxODCbx0VEl1BzhfF8l/6ETitQ4knRAocIvci/jPt8HgEUOi1Vy5WvbtbUbjgunr0sU3hgVXjP6HetTkljaPN3kHDfAubPbns/7vr94OXlffjtDmfmSLj1rWJtcE4sq7ZQX6XryiewKoT9ouAqN3fjLYUKf//Y681Jn1K3GcQxyliI0SScZffokBEqdPKjS6sqMU6KwEoDW4oCoQahxn1iDMQu73WEnH062+xcKTyZoVaVNjiTOYj8OCJ/7e0gy8Q7pywVW3AV4VfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4zrItANfM1wMNbI/eQYVTBs30uneCKfafh0X0a1BU0=;
 b=KS+ybnfn9GKVaNz5f21Rl8tFhSNOHSYggZ65+ZntIxTCbqrIavtPIAk63HO0Zq3ewGESz514xw3s0gsxSOAaXkuhNAOMh61RGn1tee/BnUQ2ANdgRNjMGgMkvB18bj/3qdH9NUJ7Q2zvTDbaSneChtgphviV0hfV3SPGus6tYYmEhUwmzjezTe9vyFWY3U2G/Jdkp8pYR3289kUZUWKwrkW4W0/wv1J5c/0yjoDV+vKN/o4JTdJ2mhS3fiT4q8WY9uSLwuXKljC0c8rQD8+Zn+j3c76Dxr+WPV22aR6MNNul59DRZVoy9Hpy6FYUYSNrpspPjpMcwkXwmAP3E5u5Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4zrItANfM1wMNbI/eQYVTBs30uneCKfafh0X0a1BU0=;
 b=cHCLaCArcew7huepE8r1sr2JJPQAtujZ9B+LMKPlo1u7HB0RHgvyYXNIfeX7UZirp0p0S8BV3Y7sx8w/tTW0LIlCBQHhJqpWjZBHpWAPF36D7naUCwDEg4rlkWBLopsUKekaUIh//twAzc+JwQNQ4gWIEWhJ3tM9Jacn4YOauvc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4641.namprd10.prod.outlook.com (2603:10b6:303:6d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.22; Thu, 30 Apr
 2026 15:56:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 15:56:49 +0000
To: Sasha Levin <sashal@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ncr53c8xx: Drop CONFIG_ prefix from
 Zalon-specific compiler defines
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260426000330.56137-1-sashal@kernel.org> (Sasha Levin's message
	of "Sat, 25 Apr 2026 20:03:30 -0400")
Organization: Oracle Corporation
Message-ID: <yq1wlxoe91m.fsf@ca-mkp.ca.oracle.com>
References: <20260426000330.56137-1-sashal@kernel.org>
Date: Thu, 30 Apr 2026 11:56:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4641:EE_
X-MS-Office365-Filtering-Correlation-Id: abaae4a6-47e9-487c-20c8-08dea6d11683
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4Ebt9e3OV6Djhr18WsytI3kSr8S1oNiZnNN+xoeDVa5ylCThpsnnNFJ3/jFeKAxOc0WpskQRZz2hJOdF6RioMff2Ipx6CSah7/SQQ+aLuJrHdVtuzDqwZ76v8Q1SjbNma7YXMToFrz6u4U20NDnTLegnbh2B0i5PhQ3GTGenSjby0/yhr6jZKzdodeUg6rL9LU9B4g7yekcV/dFrYADQGXL9Xt/pHkPE8R3kkDWrYyrVfalz5XLMcAKxPO13wp+1eDSh+huRFkJGLXcb3smrNmf5ws+PX1PagJ2DMNa7zFBYIJUqyhju/Lb6EiRlgXF7MTe2XArwJUF9BK+Kd2O03138oLI/V0JrGdBVxwGvKn1eHR3dSY1uEDPH3mQFvJG1sN91QIVIzuEadm1iuENyVVB4TTF7wOenaSrMDme34Cw56wxPbtpuGKBOkcpfcLyJvSCYkiDqqPpwLLdK6dOkWFIHS3p7LCbfItMbq/fURDEFYFNfXc47xhBxG4HYLA4afmv14jeoY7jkMHT+hJAaYNfBHAP2Fxsbsa4Z2jXUpYqoN4qdvq7ySljmS20lQtCPVcAXeObwOAAiVxWgRqhAsD4h3P8uxvFxSfx4qsF0gX0aVH9zwvdQf1W+ZdTwHqtCgskcSOFwQW2ZPJduJMPsG/494zHt+TD7JGrdgooOsd7gYcCrjUuH7phJhgFptXGdb01UmGV5Tq7N4QVJ0NuFahB/y+cx7rRpKDNW8klZMOk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HuwGhQyO79caimWifrIVGQcOi2eDXLEKnX8QumW6Na4xVxooyYnpfc0FdgTL?=
 =?us-ascii?Q?nYbBl02OJUWOnuPYY5M4KayxXNKRROI2Xk1Q8nrrDigC67dA16/B8nqVEJXZ?=
 =?us-ascii?Q?lCuF9dPHLUHLXzF0zatt8gAwS5D9NIo0bRishYitvJVonzEr3N1jLIdXKzw1?=
 =?us-ascii?Q?4FeicJ2Ox6Uase/7RWKm/axmn9ht5m/uCllpkaZxRRewIgIYC//zZm3fkRBj?=
 =?us-ascii?Q?UFdkhJ+qJ7MxTBjSnurJPcnxtcbtJDub/gyctz91EL+1vZlAkevDv2lEGJw7?=
 =?us-ascii?Q?SxLwWylG4NhulNONlj0B3C9c8+AuYsRmHfvtX9hPnRnTfFd3SHcaR/9++h1y?=
 =?us-ascii?Q?Hs1mUSNNyfikwHBtElhl9SYkEqhNUoP4AR64gZ/Jjl0RWllYfyZIPiQgYWKf?=
 =?us-ascii?Q?v1E1/8Z4gmtNQcmZQG/FKnhFqr+5zVIs4PVTiPFQMT310xbsGpy5lrkMky+V?=
 =?us-ascii?Q?kepcZ51gasnV9Og6ekAvRzNaf7mRen64+AE4qdJhP9UF9zyB466lJb05WXBi?=
 =?us-ascii?Q?QkFFN0lXmbh6LgmzIhuq2FF6c2MxXZDXW8JXSGYkyL/6L+UivKXeaH0rGotC?=
 =?us-ascii?Q?cb6L3V9NspvvTlVlDNW/67Sm1Fqqv3pSuNcyfd+eFDdROygUYFihfQlrGrL2?=
 =?us-ascii?Q?rnFEk1TrJHa+J/Ox0Wa6qf4edTfsVz7/zsvgPTwGdVqoE7PbRpbbs2hAZGrB?=
 =?us-ascii?Q?f6aeVZvblZAABnFMm3FE/wPj1O2S0Ps1xe9pBzUw55xGonfjTYCvmVqJmvdV?=
 =?us-ascii?Q?QwLMNh5HaiDgIWVopLtwGmkhqzED6Iq+eVhEkQ3CQPApbrlJFKgu/EhcsYvA?=
 =?us-ascii?Q?8/UPnebR43s6RF5lcNui7j6e6zbNHJ2aiqVMhgcsUypoLd+vlg7EKiBKR+OL?=
 =?us-ascii?Q?mMd+lyTokSZSmGKlZQAHeUDptLVDrFfX3l1EXQrF8vZOP4kKBx0AQvTaZNhe?=
 =?us-ascii?Q?rhaikwJeybymcKhBsfIkluyvWv9B6b2bvzArYtFTxuovQx0RDy5Ysf255AHA?=
 =?us-ascii?Q?/GHMz1sOBsTDNPsVQUwkTGEyeDFYm7nTOQErJvm+1L3c2IUFI5NV7iXAMImR?=
 =?us-ascii?Q?7A3MoP05H4yoMxGJW0kOXTUCg3JBS79nNYcKiJZ3b/H6x6gIwLRPtdccxOS2?=
 =?us-ascii?Q?rkmXhTkSVfI4DvzUMRd7OCcfwqiHZ8m5xKQyiD6lHDJL8SQ9PFNQTUmGbWtm?=
 =?us-ascii?Q?uJDx9hEOysR7k7YdHdK/pQiiBLnQHVexGEyrpCUs5XHi1Ek9GmluD1bwv/mY?=
 =?us-ascii?Q?6RK50KmCfXZKZCExLTl5EStudQBVIZKpbmzC3h4mJmd9Gh+t69+uJg5PCW5j?=
 =?us-ascii?Q?fsvybICI7ice/XDNsTJoUQvGPmbz/UY1Z3S2Iz1gRBFrg6zf0nty19PX7P8E?=
 =?us-ascii?Q?nOEOVVPw7UhkwA9cIzU85iJQ5cJMhyLjr2AgvB+w9eUhFWZ7y5ksZynNsR3x?=
 =?us-ascii?Q?DoELM0V+V5rUYPxtfxRxOVEzyeCHQIq/Kn7Wh1QrkhI3mLhL7NqOVkmgQg1q?=
 =?us-ascii?Q?9c3fq1b40l39IJTu1p6mgQGcGTkYsaVxh7QctU6knMnmiWU4OqxXWSTnKF9V?=
 =?us-ascii?Q?KdVnloBnOvI2g0cdN+fKJ83SZi5dd1A80YtmWqD/FM8nyXA/jlibThX1d+vM?=
 =?us-ascii?Q?Agzicy3xcY/OM+3j8UwWe27dwDRyQK/UNIrWMAgSvP56sLFNtasTWz84/fZo?=
 =?us-ascii?Q?mTHAmkQMTpkQtp6OmNixsVRRz4pxxmiwskLOQmnRq6W7JxAmLO9HrPzRpBnQ?=
 =?us-ascii?Q?doxdDC2Noxk808Nm6MqAnnjemukMJU4=3D?=
X-Exchange-RoutingPolicyChecked:
	SnAVZlJGSCWUfzObsGzhWcAlfhZMZghPleL6vgVODzbmE0njL0XF1qt/+mRIQTOmbOJ0j7qrmcLi6oh8m+eVUbK51Qotmp9JWZ1y6HUiEmRirEvbU4JfXwahgleHJkd6nA/REUw5A+mcQyXnTT0DGjdZsFpLjJlIBOqE/fT/yANlKkUy09fWGKt8ylej2r4gxtfqE6mYJxfqj9np0swMrF1+7r2r+ccSvO+yKSutre3uq7SbL1OnYs2B2QFgBp77tbKMJiqeofKCWw2mH6GvDh/Nejvy2vAik3TjZ5cXhGNpYgLd1mRuxXriF66Yp4+fL99Bhcn0EaWp8Vy007Ec9Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gQ/JMqvcVMGB+aQ/c2rwd8P8PhKATHvjUCeedlnOYzV4RY3fBiXSiLU1rkiMZb3kxeO6jPHElWLtrNz0HsWR1DSsnErIRSw4DRzwh6qB/MLLqLsVvKEToFAu6Sjf0bEmasH0fOUxVnSpk/Qau3nafdoR469yOW2bgO4QD7YZN0+J85k9ARR+YOBc6QeVc3rLc1WYzAuuN//az/KyIA39umXZCRmPNlikcsKzgFeubQGPMtpiiIcuZW4zrwO4+DmTZtZDzOr2W+n4ipkrDHpqnMH9r51wPAzDybLHyVJ4fpn+5gX2sCXZw7hdmyEZChW7bhrnUg5K3y0BkxueZyAt3Rq7qE99k/6c54Nd7UvSfm0zhBB1k2jqZ0rKgL6tOHa0NzZqJGFuEbnTmvznc+jx9+l+4EtkFJcTu3x597iNqe4iNm9sEtUd4KK2SS9RA33RZWJsRVjiQDl3JvrLCf4xGSgaeKzPVGZ6LppkQZ/BGztwezseM/6W3PUWyQaVhrXP/FeFiL3MQq+8HZO/WF7ur4Ns5Ah76fLU8M4nQiNrr+1NbvLCW+d+mHqk4EzecNzClcrS/Vv3DcSWLxq5fkTrZ0H4oEYXqoUQP97Ct2VwyNI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abaae4a6-47e9-487c-20c8-08dea6d11683
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:56:49.0572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykUcjUC9/NL2vQRvKAsOGwUEqXNwpt5+G99K8EnkLlcS03/mAw9iXnermX824xSqXkE7o2gkPG7OncHxecT5rYfYk2oSmNcThKbQVlR+Z/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4641
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=956 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604300165
X-Proofpoint-GUID: jOTf4stD5KI-L4ie6Xuol8N5qPQk41BX
X-Proofpoint-ORIG-GUID: jOTf4stD5KI-L4ie6Xuol8N5qPQk41BX
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f37bc5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=3bGs5ERHum-b-X5uikgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE2NSBTYWx0ZWRfX0/5qgxgQ+ui1
 DXyqSUlJYPiOfRXEHeoSu4zXmJBxsEM3xbg34KBD0xLBHuV7Y2Gg1HEDhhzhDO8JtO0HQPrb5Lq
 f23VxqkS5GSnaTll9UOcoikfg7KPX9LhVx8SXHoBQyR04Ctu674jcQuVmCzh2VGnINHMaJd6AVd
 1X8sFqaVPjAKU0RHU4XRNLkzY1E5RgjmrKyFslFtLEB6d41iAevf5DUFtDhFr5/RIoczr0VpQjk
 wZbfI7xdZKvKZIeXpiyUofY2PZrPRhI90YQeymsxg/IEeZUWyZSVqf6RLIfLY+Py41PjRtriHGm
 SvJMtLi8c/2YcIytMedfqHzDVWeFqN83tvr3F9YzHYhpBMnicp2F6q3ntHuuae7P9qpa2ozmBwB
 VZWcI05zsHZ5/CPfvn0Op9khNc64dRKYNA3wGLAZ2lU1CHdSrOfP3pJbgbM6zfiio2zUbHt95Qy
 EsHRcfeTZ1C4w6Cehmw==


Sasha,

> kconfiglint reports:
>
>   X001: CONFIG_NCR53C8XX_PREFETCH referenced in Makefile but not
>         defined in any Kconfig
>   X001: CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS referenced in Makefile
>         but not defined in any Kconfig

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
