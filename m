Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056E842B326;
	Thu, 23 Jul 2026 09:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799537; cv=fail; b=M8llfe1jUU6WSqvaRLg38JKLkkTdidrcn+1YZeypaCn65iKfE0LKWNvfhsC+J0i9aoutCk9VG9r8r6pXW9Gves7/VI/TWzUF8ldE4m3xKeoxhKsv2jqYOkyEWyaaWtVTtH3By8LAK3PtzgU4DgCeICPWtcjknIpT6n1fxEnXspQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799537; c=relaxed/simple;
	bh=DV2jCK0NukbLJP5clvvimPyH7EFK2mF96MXN0oiRvOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MA7J/Kjug3T9w3GeZ4WdODiyo1/naV7aqhJcptr95pBUNyfqkQxKqHtCdRBEKMtLzTpF9mvksObm2haZsCtDcgGeQXYoL034MWVYZ+LIUVTNf5VIAQEctwCbYItSQVy7tXElZh1dAHEiOwk9YGmzat1ouXG8LV5pG9AX5WooTB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HLxDG64d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xbKmWPQ2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HLxDG64d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xbKmWPQ2"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MNtJcj3766698;
	Thu, 23 Jul 2026 09:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mk47meL/284dtNW3gJHBJg7x7HNt+T/k6ONWFKyLy9g=; b=
	HLxDG64dZ/DjvNjKcSpHhTWhKkEQE9U85MBlqiijpf/G3ChezOfLm4UV5ltevzAE
	flaTEs7M/CFkCucgquB9tWoBSy7CVhAOdIF99k3jtF1HfHfFydRSIfDS2/sg1KUj
	chUECLxfqerrbIqQbLeaCzne601sNLJYGieodWpR4XDlomSLKtiSf3+95rhoDuTL
	UGK0VUcl7t/nrDiLA3wu9zgpKoHbUG+r275XvaGewPB/vGIVd/+KmOsag8IRI/LT
	YMu36tqvDFqzT6gmsLbsC9Jtd9sxDk0XBsNGjf7MOIGJ2jFlOStwL2tmlvtQ4NXW
	IXB+rnNW/zVHXSfprUq+5g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6mvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XVeT029862;
	Thu, 23 Jul 2026 09:37:17 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010000.outbound.protection.outlook.com [52.101.193.0])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs5xku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkoBiYfmPbf6Suja2mW75uilkZ3hr5CHU411tWJxh42QoTf+2F/ln9kgyGx4mw63f5T3oDfIn3wS/gzlmXfiWH6cTYoB5ELKQgxSoLh/Hvzo4tR148FnDmtIy+6zOujCjxMxr0nYSLhouY3TFa1uGo+Pz7k6X6u1im6fHQEypVdG35CPzHWNu+iaCZ/gErMCF9B4eQ6AH/wh0UExugsJu5PRdZf63RgDtXnoMiZkz97dQth7haS1JT6q/dl1HmngB4zbTKiGkvbeePLaSVxgpO50fCHaS7VTAZbdu2F1F8Jp8qVrTT53Dw5W7DB9+GIIGRfwv8kvsrv8jQIkA/94Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mk47meL/284dtNW3gJHBJg7x7HNt+T/k6ONWFKyLy9g=;
 b=iDOdx26ML27wDzQAXImoiQNIkxAn1Wq0qWZhXJijUFe78pNR1/RI+jaHUeh9Yh194XJLHIVsgUGdXOW8d/7XMV8ASfhG6zYeuAnK4k9wtrSgwibaCBcoIdqTJS9fdV+Uminvn31+e6NvPbGexvShqDg6hizyIC9uVBOhf8n7ygBfAGhHWnfLQW67rk85DUM3kxHPm51mzpVHBGjmLRstiOU1juBnEF8ogJllxKoX2VmxrCl+Qo/cfVrFKpuuoZ2SGQePgkjyeCqQNyXKxB/weyv+JO1tAouNnKUCIb0rvdMtCDNTweRI3WwcqO/1LmfnjSowkQg3mVr2wkZFNlD0jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mk47meL/284dtNW3gJHBJg7x7HNt+T/k6ONWFKyLy9g=;
 b=xbKmWPQ2nPq+0uiw8oHJTTgtHKyj00DCbYw4qQVVu1HEwlMoqv7fJxtEP6/6lEDQEePNPa0c9wO6+oVnVIMWSaC7KAcdKKHrDptMk81WqUFsPEX4UiZf/FJnj/m6tsJigS0t7sze+BxNprWc8l8tTdpwz0eO36f5jy60p6BBU5c=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:13 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 16/28] scsi-multipath: clone each bio
Date: Thu, 23 Jul 2026 09:36:14 +0000
Message-ID: <20260723093627.2327456-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0391.namprd03.prod.outlook.com
 (2603:10b6:610:11b::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dba31e8-6ebb-4ab4-dcea-08dee89df99e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TQOGkEzyw0mLjDyS29l5MGeCccajYU5VzH1T6fnHgUXy/WP6zpHmpD7Igg0SN2FfijsfBgYbMCGunygCx4RdmnUlQ1PM985hEIGi9JQ+IVQxP3deZIXnXKHYubfxRa3NuwHsOXRqVYuUmWHY34jzv7w7IRRoJOQ8Ucj6ZvUDtgMjHCVqRJgvEwKY/KoWQzYVBZpuxbfEglnx1ia7ABFFqeqX7LXFiTV3mt9KIZUYJv0guqCy/unhQQUpceZCkxIi7Wd00xWcqOD9N3SaUFbbtC+6VEc2wOfWhkFu9upMT6mIDAKjLfoowIlEJM7smRWrMIDxjOV2bmXeS7kyG0X8AYmI67T7HRpr+6aydoTDCKwmKGRvpDbrTUOE2I8gBarz6HkpWTbp55h17kdAs3T1PZcGa+FNmVRl3BHC+3f16b2tC9zsSxUpEBjX2nANxJH1xoN8Es/9bLR0yFe2uVLJxhHKMrWvooG2n+uXalXuNUnkqHIXfifWGKXWlTVEDN+orZ/nFScM5suXQKGzLvtv6vMuOtzoP0CVWCw1UDoNcW/2Jt138JJ+4MgjrJeuFKmTQ+553A03F7yY/7IqdoujyfVaHQa65EMSWWXIyz2FjlfHhnCjfs4rHohXMBJBq15j2SgBtYott4j64Df6bLVvzMPDnkV3xP7YBZOXZoFmaqI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WwcIQxk0GYfovD29BdlYCkqdZ+1ImbdSLefMxRgxtYYXDt3f3CLqhDsHe2af?=
 =?us-ascii?Q?jSOgTv4toR23+AHV3iJSKzyZyr+hGNFGb3+TFg8Q4DDWNyS7lRwMkhAyp1ey?=
 =?us-ascii?Q?oCKn8V1wb5gsoj01cOUjfgBvSFKA4P7USLPYEUqIDSy2yANQaGhE8PHH85sm?=
 =?us-ascii?Q?7ytNAyUCoNAJPJZ1WNHKOA58JBfhR+9I85Fu+8Enf266DFLjDvO2cQkcjaHT?=
 =?us-ascii?Q?yFZO8PX0R9UJgoUEBvPFfpvP92wbilPapvdjLW4E9dQZmCxIgJHCKCDUteKX?=
 =?us-ascii?Q?GrLDu7kvecb16VAhd4NNg/0dVceZdUdIIFX2MEyHnOTjB3YboEC7l+AlTIqH?=
 =?us-ascii?Q?1oF8W2BK9Ak2EGkq93SgjqsfIcA5hiv60C81FOUAIf1aUoQ/cx72bfMeZkEd?=
 =?us-ascii?Q?iGJdi+dLJw4GAOaKhtPlORsHP0nZNVIc9GHChkPVlMhfbl2mL0vXWBdzSVol?=
 =?us-ascii?Q?dh2/0gbyZtstRo8li+6Jmsz7sO/iqiVNlwuvE4gEz6VOL3tok02zAnCxGoni?=
 =?us-ascii?Q?rb5mwoQ1qiU6bwi+eZL4954m+APcPOFCry/tWcOTqW6473dN5+MkIUCxkAWf?=
 =?us-ascii?Q?bT5WquCMIs+BZgL6w3RkXWdADOh0up34RimH8iL9jOV/vZYc/58M2osHyWC9?=
 =?us-ascii?Q?yb3+Fvs2UjndSQkx8rYzSlYy5USZLBb7ZSqEoRsb+RMV9TZreiNmQzpUiHUM?=
 =?us-ascii?Q?ZGCeM6I4TV1ZclR20ri6hAYsPxhlYimBTXraxk37rHbf/LNfIilnyCGQZ0LD?=
 =?us-ascii?Q?AFJ/TRr6Jwn4PC87gN9KgM1b1f8UsCR+0pytUXqH2AZFlphPp7AtA5MT+vOu?=
 =?us-ascii?Q?FJ3zbOJXpaOuGOSI9ytBC8yLqJ93Xb4HnYBtMUX1bi08/XVzKAsVzx19HPab?=
 =?us-ascii?Q?3hQVVBVEK47y/Eif7hBkZb6YtUtBGRp65Hu1tv07X569wgm9RCuUQKjqJq4z?=
 =?us-ascii?Q?At9QaiIsjVgE0wHSaKYFQANL4dAQw7ShKbwCwQ6g3ID0QcSeF+74lqZM0Kvz?=
 =?us-ascii?Q?da7U47D8SsG8ReEYK7r1HKJDo/cXc1qF5eH0MEge8d2qM47ZdFbm/fczvf4V?=
 =?us-ascii?Q?kr+beZq5StU/MQOQcIi0o3lb+iJG1Ixqo7VGCJgphObI22nUG2LwULUx8Om3?=
 =?us-ascii?Q?g/kWWYvY7yMbD/5Ru72KkKO64OFfsoL+9yfN95p2VsOtkIgG0ZO42T0RmaiZ?=
 =?us-ascii?Q?yO/FoAVhUj/3m8rQCGwxSdHQIFCJpJZ9G+LuergQQV0QFk+RkKOA4hEDc1d9?=
 =?us-ascii?Q?K94ngIlSYrnNEfRjo3zBgkZswROKVJ/CuVM6cy/2ZfAZ4XtwYBwfCVsbKiPi?=
 =?us-ascii?Q?Eeh042oOJDLE23cTgPPLXs7rRB2VUHMtLwW0nMtiqDgkuM80Jxr6Qsla6oms?=
 =?us-ascii?Q?n08cbeyeyh7Y5cc9YLgInM6HCN9bpytd1hhRdokX/JGerkfNkti/zzd9Xqig?=
 =?us-ascii?Q?aodz2POOgSINjk5ts3Z+Ax7Lv1Ocmfiei35yBl5io2VWfljSC+fGD4Qr3dqS?=
 =?us-ascii?Q?y1WeqH8S+sTAhK8T+KOD+3/ZbNo8q1lMeLGlYbQxHAu2ieMibxdZNa1hZ5Pi?=
 =?us-ascii?Q?P2KmpY0cwJfY/PnIw8uYba2R16veWln8oORmBgZhSao2i9sbfRLZzcuie9Go?=
 =?us-ascii?Q?3nsrbHJkzT1OarpzKNsCMEnS1zImcl/GsaFfRkCaNsQDOlW3A729TQobTyD/?=
 =?us-ascii?Q?poPx4IqF4EPTQmqeFQxkR/4SWJNqqkWSqCl44LF3UAqLt8atNGRHG2uDbhpV?=
 =?us-ascii?Q?P2tFP3wXVwVqlvLybudlig7JB6z/ujs=3D?=
X-Exchange-RoutingPolicyChecked:
	iV10dB8tgpmR8gLtzDxFHUMpN7lSMA2sqhIWJZuqfC1gV179IINFY+9cFg3JcGUecr7USd8+CvFmGsjqpoxfeABF/t5TEzIby/+b7B1l6+Yq9ZDbnChGG8GgBefNPiMsyzBWkdYkYgjj0UqRIj3cgSq1EzSfI0p402vWsqfsTMqJloBE3p9mMH5Gb/7eXpBIryLQduYBABxFsOzCvLk5dYvg+yRXLrlIjbaINdJymQu0mc6FJpydfslnWChtpTypOhcLjxBRtrcq43uIXr1Sf7vDmTzEti3FewPjyR0m6zlNObKzOpayrR3JbPpbg9kP93zdZ0taxaO/pMkcIDRalg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eto76t0UU+QLkFllEFwNmYQwiu2czOgJ5Kq+9PdtNg5NUPvKMk478owjbmnNag2aVUmLjevrtwyJkV6FLOAQ+dat7KoQTxGwr9TvhI3gQuhrNrV8hjAueCFZKDhDNwG/30rRVLM/7KBkegKDx+jaRNT79uwX6yNeb1M8QJT7Msl53O65oP8MBfn6fZnj8VP8HapcE12jy9DEGND31f1PYGS1YMZ62zfIBRfr6a39aYdU2aoG25TGtIByap8PGg18HWTYB2iYNxIoVSLCYwLuHfj34Y4LpPn3geZNkw0VBTSQSkYbiBXsW+5lFGiVTua+UEh12xzbcWIGVHuDWR3NxceiWWGpkSV7ZdRFYmlbjhkBEZ5HioKcqUsbO1SSrboTgJHvFExIk8gjt8xvpmAlR+snZIOS4gQ+NiZaBfmGvRijkWsJ/U9/IPWkS/9B6Iuv9SheeQqRyWZ0ee1fdglfyvCz7P3MTdn3Zw5Yv7XwE9Q+mbWlZ/ZMFLDiOzJJykss2g5/OMSBn88A/KHwZxzxU7rFPNl2U4HQv4BPvHk+ftdnF2IMvWakCAV+hRy+gqaT18UCxVIfeNGusT3gjnCRIyqoBt+JKM078OuorKC5cUk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dba31e8-6ebb-4ab4-dcea-08dee89df99e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:13.0596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xc4BGW8t7BQuK/0G4KlEckPXYnVD/aAQjmmL1Mvwlk9BipsEYOqt63iRsXtjF8Q9lkXPVbEltJFcGOE5xtTPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX6cuowHqIHM/B
 gghkxYDSuRSKAFTfzBawEVfkt2rStqhd/GRdtP+L1SgvAHUgxIA/rB2tQqur8wwCklE10X3q2hf
 fGMRgJYmGsDvgeUit/oyzAS50PFa+QU0RZZi0C8ONWvyO79WaacBqen42gPp1Ak0i7rhCCA51ew
 Az8qtNY2bL8L4kp/HEE6e+PWm0GB2y2QrLpE3YW/qRn7pNxSnPSCPummHafXkMyBBLRfIU2UbAa
 v+bvEfD6CWshJMDx9+/dlbntccrPJhOQd9F1e9zLrebRvWVll2/9YEtNu4eZJHMqXCLfrVanZu8
 tzeOjkWDzEGB3mqht+TlkclkTmvSyTsblid8GqwGtPldLlKHKjCzR7u73kmPBFOS8psdwFDWQ3f
 W2OrN6l1Ggmke6ZbQV/XCJaI5cBCAmoe3MoBsro1MF+3KgFWRhEEU3wBYclIsn49rba32W9lKnL
 +vxn2SHdIHlhFjkuDP/+fTgNiB3noRhFo4hStsOE=
X-Proofpoint-GUID: gplpqVz2ouNMk_cKhG9rJ6QsITkSggli
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXyDA+by6rDMvN
 zFhjAcor1kylfwyT83rqx2AN3vkSm2o9PjZpXUzeCF/y65Oz0DVn1iLE9EWqMTmTLVLCeHG0IzL
 CNFrxA2H8OICwOHQ1Dz3iNAH0CXKCTJMT+by/GVT33Crr5JaGFzI
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61e0ce b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=PbwEKb89bYuBhGpDIggA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: gplpqVz2ouNMk_cKhG9rJ6QsITkSggli

From: John Garry <john.garry@linux.dev>

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 6228ff4be4ff7..9a4b35c597778 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -97,6 +97,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	mpath_head_uninit(mpath_head);
 	kfree(scsi_mpath_head);
@@ -229,7 +230,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static struct mpath_head_template smpdt = {
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
@@ -252,6 +280,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
 		goto out_uninit_head;
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
+		goto out_ida_free;
 	kref_init(&scsi_mpath_head->ref);
 
 	device_initialize(&scsi_mpath_head->dev);
@@ -271,6 +302,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 
 	return scsi_mpath_head;
 
+out_ida_free:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_uninit_head:
 	mpath_head_uninit(&scsi_mpath_head->mpath_head);
 out_free:
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 2dc02313b0496..5cc37acaa664f 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	enum mpath_iopolicy_e	iopolicy;
+	struct bio_set		bio_pool;
 	struct device		dev;
 	int			index;
 };
-- 
2.43.7

