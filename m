Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B6C31691A;
	Fri, 20 Mar 2026 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773970744; cv=fail; b=ORKIzz211ZZJ76rXprIRu9/RzIzbxR2uMEE+6+pa43n9zqSYWqtwC8b3ayOoVqaGYyQye/5ZTYYE1twt+8Vs+wchRjR7GxtIPb+O7J4QzySEBQK4qPzUcuj27SHyXSIZpxHfIXhhLZUXi1v4N2t0GkS6vGGAae2Po7vo2qV18Gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773970744; c=relaxed/simple;
	bh=lX8UhFVmZjGZ9z94KniPQzFKg/2RuRg89Tq217BwbJc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=J1m6uONSGUT9vBfYJs2kJr68ejO1RLzAWZGynPFmB+eOcmxb1bI416WNIJdyjLmjeebpanWh3jIWc1KKe1HJt7IyE9kC4/G+Vt4Gcj77RQuXJ9akW0Mgg1g8OoxAoZXt3cqx0WHB0+b89PRYbeqR2ApNroD/DN28XNbVPtptNV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ppqFVh0o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=skcNBHbR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ppqFVh0o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="skcNBHbR"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JFpE7b313531;
	Fri, 20 Mar 2026 01:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6ACYrrqhn0kPKZ1t5F
	m+ZxRt4oP1aG37LKQNH4tdw7U=; b=ppqFVh0o2JexFi8H3gw02IVJKRIF7tqqER
	EZohIfK7trf1ehLawObsLWX4pHo9NHjC0m2FEwmTZxQu8Vc3iJvToWrMjtRJwKIM
	t3IfA6MsRYJ3ML919glTMz6636u8lFN9SaLUMigp4yyzDbVkSMCS/0N+TLBIRcLs
	MB9Uh4VqzvIYVhdIWIOGbtwRjVyyUKsQCr6eHrKgq6n8yEnRMufx3g6QL4XU6+7G
	ogaW/Jte50HxMKUp1DgpqDcVY2SsaArf/8RqvBCaWvriAMcbOhl5LtKRz2uZpUyx
	ObGogm9YB9jxfXMXlqWSEn7YZXjoZyNI+vCciPvIWlCqjDOCCMQw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvy9s0rf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 01:38:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62JNT3PQ021936;
	Fri, 20 Mar 2026 01:38:42 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4ryyya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 01:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7Ln/23Fq3RB7el3i0asVBI9WBjxhxMMLN2kFe/G7JL20wMJDT9Ui5aIhzfgWw64J75qXwJLB7Cwg5o/8GZAqL5fTSc8jYyZmDflvTxXrPAvvMdaPCs4p7aJNwypEiHYXRrIpzs8/BD05xyC3BkrjFcVmkBqGrdwG6+4webTtHMvY9t8Pjyg0gn2qJYUzIHGI/J+wh2ZW1LTWe6JZ0OP8mupCh6t4VY2zYRXU9zYhzByQtSmj2IjeK7rHuCKwG85CP+ZNK3v/GJ74+ccaCn7ftRxAm1qJiP8/2B0qXpx1xuGEMB8ZS6339Ev0TkBorC4Pzhft/D8zec55RaLLrvh4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ACYrrqhn0kPKZ1t5Fm+ZxRt4oP1aG37LKQNH4tdw7U=;
 b=RbKX5x5UnVyYK0jiB/imKNOVn5WDMWRXlJrqlu52Bt2lPUGBwTxtXZZOthKTN3dHeZ9rtJCKstjCbHYr1W8ky2Eis/rYFIV4FL9BXfhAsp2qYQfzeejA6FQKzAQGgJqbqej9TQR+whvTFhWDLvUigcse4PyElfitVtgm+mlROCEpOM9ZAysDF1A1ywinmseMQP8vyA3TPy4UW61QSbL/QKcZdnuGU6WzzxeIpxgjya5hSUX6DUkO5cJr+HdWeyyotC5giIPhlYYlvdrEsh3IobM5bDz8piOhBUiIizeUpHO/UerweWAxVWkulhYuIjVYDWFX7N3s4oJY0qh99FYy2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ACYrrqhn0kPKZ1t5Fm+ZxRt4oP1aG37LKQNH4tdw7U=;
 b=skcNBHbR407PgwEGcMiPkZner7RwrtMHdOjtmWysEW/rCmTlEbgOibonrhvtVO2d5m5W1HnKbnGZdNBghdm7jxk+ew6rnUcZPfXy3JrmhOe2NUWnyerds7pHXk9bNw9MIgatd/AcUdtPIYTnbaO+mlQTYGdWgZ5dctVd95+axMg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4327.namprd10.prod.outlook.com (2603:10b6:610:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Fri, 20 Mar
 2026 01:38:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 01:38:06 +0000
To: vamshi gajjela <vamshigajjela@google.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        bvanassche@acm.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        peter.wang@mediatek.com, quic_nguyenb@quicinc.com,
        adrian.hunter@intel.com, beanhuo@micron.com,
        arthur.simchaev@sandisk.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: core: Handle MCQ IAG events
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260310190308.2474956-1-vamshigajjela@google.com> (vamshi
	gajjela's message of "Wed, 11 Mar 2026 00:33:08 +0530")
Organization: Oracle Corporation
Message-ID: <yq1qzpfl1qs.fsf@ca-mkp.ca.oracle.com>
References: <20260310190308.2474956-1-vamshigajjela@google.com>
Date: Thu, 19 Mar 2026 21:38:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0027.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::40) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: ce540fa6-79d6-4bb9-5560-08de86215545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OD3WTvIGCmItRqteqI+NH5zG45GxeICQ2URK/rAk2O04FqwN33zEvHQgeIv4dcxv/MdIM4IC0JDOj7HQ1ufkUe0EfBY+8sTmmz0tPoM1RDj+6RxGw4dyUTlzZjq3TAWs2HAz46sthTbTw/4NDoiL//U9JLnA9gcVLlOutDCo46RHp5XFlK4NJQYQ42bjK9EbZRUt8/k63ZoA3V4KFDhucTeAsYb8o+tRqgMw3RNwWNchECadn6uzj2TS955fD9KUsKKLKMQae1Qo5Pig8/SinxtopW+BbzSyoq44UIavK6dMjUJ+WpwhQsg68ZL5iS2x9dR4FsPUGfAlen+y0sLLTapkuqQpghxkJGI1pu/L74iyBCmTyog9ilcDCscaxQqFfa1Ka6DdL1jArn0fz5GUKmV0wuyD0QJj5EWP8HouEA8MSXEFb2VnuO6Yo7secxbwTpxrthPWdjeQqInQaN0UsmNIlSIc7RkSMq6jHzdFLagT2zgQBDZKBnd5L9Ni8ia8/YuRdOEZSAzSLip1xhWoLaOPQNAj+4ImIzf3b5DA7r02j0sO5cJTEJxjxGGGQYtkscZfFa0xvBqublbac59rWdq6wf+/lPYxrTkYG+tl+GE62irD073bpht14EcoH048UZPnxqI93hX5G/sGR+VPRBowy+ELi2Mz7zJ73Z7mBA7VHQ4mR2TTS7sa0UUdgcF7S/Ay9i8lXfPoD1iyfmM19uo7Woa5kIMm0PiD3LWQpzM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?87jhSxmbgWZ+TbnokOFsHWiPElxoLIUkNzOTgyZxR227ComJC5Hwc8fkw0p7?=
 =?us-ascii?Q?YZUzgGvainFLBHL2MZ4SZ5kxbf4HAWXM9pP8jmd1lQ/HltHAxBeqgybnUTH/?=
 =?us-ascii?Q?JEZd84CyGLIZlq4bN6XtrQIGaPkSCrWjURO/vKBevXZMdmH2zID4HvPvavYc?=
 =?us-ascii?Q?4U35Zyu/egbd8KqAmkjaD/Krd5pRa/XNxP816ihpIYMGmF77mYb+2X03oQes?=
 =?us-ascii?Q?TMJHEUZqIOoPjsVKsqTNJvaifPFxbCprJR33wMAMIOTtsKkLtD0rcgo9mJzQ?=
 =?us-ascii?Q?IZpaUpi8KW3oBTHAVDobckDqI2CZXKXOywvT8FGVWYlxJq7e9At+MBLLGAAU?=
 =?us-ascii?Q?xyLMe7+wU3bzpLz4Iq4UwCluMHZM5dOyqY9XchDqmKLYtsq8htpPc7SMKAdJ?=
 =?us-ascii?Q?dWaEeFnZJFKOda6uSUiJMN0BnLVwKy1/mVCXUjxL5pG/OfKAKWG63xRNAzdN?=
 =?us-ascii?Q?BIzrFTKuBzlk+htP3IZqEMOB6DeU6w1LIaUwbkYOe7CSID9eY0fu3wcrflKH?=
 =?us-ascii?Q?BReKwSfRWFxY8GOlJge67xb6pGNmE6IPGZl5TFCCHCdTPmzLH4630JxNNaIt?=
 =?us-ascii?Q?8gakgC1i1I+3CWWuR0AEmvnns4Fa2ne98BSqYTtw+s3TXbx1VQQfN3JH89Oj?=
 =?us-ascii?Q?ZbYhaSzVuexgAdVIWQVn2mJGGbbUt7YPxIJOKQx91zJwnoBg4m34iEJ3uTg4?=
 =?us-ascii?Q?iKH5Sjfw9pIFbSaU/Ig+9KoOnLQxVZ/RvInobSHRDg0TKHNOyjDNMLbOdOO2?=
 =?us-ascii?Q?3gAuqzqhM2TsPxwn4Jkbs1xpIU9D6vTz41Roiq+AM8xZnFAZQ6a+3+DSuEtF?=
 =?us-ascii?Q?VbNQQ1qnEp/3y5nTNASOz6LQ6FLOKMNUtQ91X2hEw2lfnnQl5KVkYPBiV7A2?=
 =?us-ascii?Q?WY9c5sypT/1GrQAacRC6zZGJUfq7g6X4I85KeYlxgKedeNiJ7smoL5Z7d5g6?=
 =?us-ascii?Q?8c6NaJzRp6lDqwuynhTKZO0EB/IBTt8uUFxeabagLqD6Vsrxr9b+keRzGhX7?=
 =?us-ascii?Q?F5AR8rTQy4fiCdWJLSXAAE/xHvY3941pH+eeIRyM3poNOvfqCOb1wzOla9SU?=
 =?us-ascii?Q?bRcZRPZubTjPJqJHDyZLJezGhMilrM2+JfTyabkSsnIxU493SkaNUUC4a9rw?=
 =?us-ascii?Q?B82c/9RwoOz+EFJYL824EL8oEVIBWXKPKNOLk9NbKorX8El0+nAizj96goT+?=
 =?us-ascii?Q?JpgOIs3/45oP3DM4IHcy2VcZQTWbyizGT3XPEZOaZe5kUO8PW8cAyfIic0GJ?=
 =?us-ascii?Q?DdFHZGxMZaOcty/VHuUMnXBXO9dZu90KTxC84WPODyU+jsqkyLSSrKHQl8cf?=
 =?us-ascii?Q?kWuXHEfe8ISxtLCvnQJax2dikecFKO9usiEnX+12TjPJ0XZVyhsNqQdTxuCi?=
 =?us-ascii?Q?ww5t5mHKhxVaF7fe9u5B94b0r+QnjVuu3fskGSqaCfMio/6uqWkSnVok0t6N?=
 =?us-ascii?Q?Fgx8NZgeg+Pz+OZDYv5m062cgHpPF8i45GCKo8lWo66XlkahVn9y4g4eXDhh?=
 =?us-ascii?Q?YzKpQzoTWcX5nBvjQuwYobnnZdAiEJuPwXK70Prr9pKiLXCR58BXyzHmQ7S5?=
 =?us-ascii?Q?raInSsmIMl/1s7VkBKyO2UgHFPwH1lK16cOQTaZ7A2ibaa5R1RYjwWnJVLLO?=
 =?us-ascii?Q?4LZOlEM1tcVAPgA/vXYkU1HJLXd2JsO9bneWqMGmEwA6fVuaLmsWBqZU6Za6?=
 =?us-ascii?Q?eE6zFTvArnprN6/W6l9Iq4hDC1NIzZyJ6BiyyHLYkLCIOCtg0RA7NMgxZrbq?=
 =?us-ascii?Q?ni4hIdRd8r9tZIYMqnsIVtD5ETroOD4=3D?=
X-Exchange-RoutingPolicyChecked:
	cEOw3uUfDyKH0CxLJMVoGuVMNPbI/ofy/szZzPdvcPUzHeiV6xJSwtnxybs/OWGtmC0iBlc6iOn5R0IBe6eJvB/Q6eq01Cu+zh4mk5Weszfzbzogd8d38coJb1A820DmahkkGVLd0NxMFVzr6j0WYezNvzuh9CX4/4HhO7KiWKu4k6cQWpyHPl31qZwgm8fCgW06JMq7Xmv9k5jQrIhIKYxaJ0l6I+nl0WLosLwSwCW/sfYNzUTocd76odgyUx1pmj4Gq+VguZVLI8LYAoFBWyOwDc+hT4IMs4LXN7qbjw/gQUj+r5xifPPjWZbbZjCPhD7TC/R9UMqePv5iA6pzZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gOZ4PsRsm39QNfHtwEyYa+cLpzCxXA9bB+haPSIqv4AC4MGYaPW0+Yi/ZLaHnXFtCGCLxCl+J4MasAPM4hnviKM8L6NyXx5l+M+5NZ0tik1O5CbxNO83mHrt3vejkX7HvALnz0issDbj0BXuj95nk53fcBVrUESPJ9S+6FjRuMMFFmIQGqM70cn+GfLnDg4MHJCg+Ol+oyRjBiXcXi6/X1kLUjEQas7A2C8Anh0F1VMniEYw5JD167X8YzlfOHHg6yQN9rTILot88cvdcax4MSXwz5DMIi7z41SevjaBkGlbAn2xbJfAkYKB3aaijYGglH/1Bf4hB+/nWpyhRkkXc581mp2GAxbsTv3Vj2gNxNnxiS2RT7RC2gkz/xTZ7NyesdhpX5gxV2ahD6PplAH5/JyIbdjFYFLOu4s9SD5709dw8K7ddOOFwrCEboXSC4++5DZVuT9Pp5OIeu8zQrfSqtjjJJBZgBbbRea2CrJti5k2Ziy3Tz3tvniZ/JFGsghHTZT0ES4DBM208oTCGu9JPCYir9YItT6++5kED57B4eMX0ZiKqZkTLD41ytefiG7n5eNO6ylkZmt8lbR/0kglmp2AbWzIgiUcX4FJAmVhzwE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce540fa6-79d6-4bb9-5560-08de86215545
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 01:38:05.7907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tz0t5dgqS3iv2NWM8p/6ZSUp8cF/mlLeJQ9E8hsvQjHFIRNoLSbmqxPs2b9wwMIQHx5iTxhvbrLoBFzVzOM1bfcWVKKvDV/V2eLhK/sxN7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=784 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200011
X-Authority-Analysis: v=2.4 cv=X5Vf6WTe c=1 sm=1 tr=0 ts=69bca523 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=JBNebbC9HC7U5k7cQ9AA:9 cc=ntf awl=host:13824
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxMCBTYWx0ZWRfXwm6RM2tvBVoG
 3Q3KQT5Sow6xl9cLlo2eh09uRx7gI2sTBUtAa1tguCFOVyfoN7YaGYrJ2lzlq+n4o7ghquzVIN2
 kjTwMswqvAP02dOCdTrxUJU8abJJRuplWQxi6t8/lW16NUZgUzQMjv5Hgm/d1EjQKVuMvRQZM89
 Q5l8oB3VfFTtyoON9ftyWCR4BgM8qLk/5QoVJUCEHcniX3MZZqE5uNjtxkFlUbgOHEZ4lDW7N8a
 WjorJpUoUQvzYdvy6Ig0LlVHt9KoVF0lMPde9F4O8Of9BI+pxBGYu3OV2kLnzC+J+Prsa+9ixkm
 JnelvzBpIcdwGF9qLOhZetZLKoQxlxNItc9d2zNIb8Gilp4etr6K8h/he5OOSm2GMdwn58x1VIp
 qzczNgju9K572XpO1COZHCeBSjSYvGRA24r2OEQNKSi1bLUMCyyOQrGwi8Gqpy4jl8vbjFYb2yN
 ncYiUXX2ANN8SCk0ZPeNZ2nvePKgQ0mrQ02jLV/I=
X-Proofpoint-GUID: DvhalFi9yft3KjveKublEQqYSW_hvBmh
X-Proofpoint-ORIG-GUID: DvhalFi9yft3KjveKublEQqYSW_hvBmh


vamshi,

> Add support for handling aggregation-based interrupts when operating
> in MCQ mode.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
