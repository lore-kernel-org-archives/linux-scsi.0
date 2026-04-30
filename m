Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77C234D4CC;
	Thu, 30 Apr 2026 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566565; cv=fail; b=KIN6clprR2sYeiiA2ngbWmM5FspCXBBoJEndSVfWH8abIbGnPeFNKXmqilcj7R6x9t9LOXjsvlX5CYrcPDhX6arztXiu58ZGYBTV1sdpnFovDwv6PB2ac8mIcw5cfx6G0kYajp81L41rNSmPwpqajpUn1eie9ap5t+L8bpB08hI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566565; c=relaxed/simple;
	bh=zmqSx1Gm/fkfJpMqZCOTINzBGEgDAoqU0HrXcxGnlpI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Fd8hT/rfsMep6httjKSG5Z00tKcTGeJKZlEy7ShT3NAE6Desc+/pvAfL6VXdJIAGjFBGfBlrvUpvr6h0yqS8+k6lrfDufdYD0H8MHAV/2VhP/7R3Uin93/sptMEQGQSdzsiFQQUurQ43oQXiUpqAUQsC0mlG7Ks9trjcIBo7KOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g4ToCUr/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bOkkOKED; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g4ToCUr/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bOkkOKED"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCfPPU3325595;
	Thu, 30 Apr 2026 16:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=khUsNb0pFrac0LiyXv
	8o8VOrnUUPCkTTZ5/CwOhpjk8=; b=g4ToCUr/c5XcxXD9xFBB3UDzeIEElfDJzy
	EYnTKfyyqdw/derf/QaxChhVLkyqAhvQnxz2a2DPF52qEwwqdM0cFuvYdnoRj7Vu
	lx/HLRzawAEzzoRGBPklbV55LsPpTkfKyw7dhTg7aCDypC+pBCYi8qD8nXNIimT5
	gFN283t4rc63T0Pwy54n77Xk+8dqA/H5Ki6rt6rXI3Q1xlK7eZ58FyXqm3RuAo1w
	o1nYbMg3ZB3ODg4FFvwdeu+3Xs2YLbX+aEJG513cBmMxTQI+h5OzSiEhgKRuJ5E5
	VaynwxtwrmZvWIbYuaSl7s4zW6gpgErXiWghSH8RAUkwC1xJ+r2Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnenqjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:29:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UGQGKj024416;
	Thu, 30 Apr 2026 16:29:12 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2nxk69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:29:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyC8Y5LB4OZtWQiT9acyyZDbTkj+SgTdPvytkk/wz9CIrploSstMX1/H4SrZArePzbHe9uoGBRgqBCky4Pt/6guuDdWpGwmYYfxztknRhmIUI5mVyEH9LZEx8SQpKHGBZAroowT2otLCyIeoiFPobk8t8XlG86VuLJAZYNOakqDEbaEMdU87dimp0z8pKISNIKWo0LeaWSikvLTpSFc22puAIfGiHF86hRGiRaJtjoERxIpvkLZdr/zgvlwuumAvWtICg24FyVaHYuZdeq7XJqGg477sVmDlDb5IqfoLqPyTweyGWPxCqOYmX6zmfkC/ZhMXuRq6fGAZqAxWzNhaHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khUsNb0pFrac0LiyXv8o8VOrnUUPCkTTZ5/CwOhpjk8=;
 b=dsN9ZPpNsdHND1lX3gXiE9rTPfheGMuhQmWCmqLvWAzvPxQd41lWWKGnR72Qr+jeGOGP4NfohXvWwRDODhgVDIcWdEVHjaiD30hwwAZi4iY+u3fLODfFIJnf+baDhGKD84ST4Rsu4+zukAjEIw0VUUSuI8q2LgnGqv8UYVinGeOyMgXEVyyfwiGzIkQEDRF9dV3whmDUCratHqtiktk7C2y9Pv73G3UA4CFwINYyBFbk0DryiPQSQL1Un3ba/N6Ms6M/kDs+0ncnHOOiuzZ6SuHVj+X3HbPTfwnS72zId71Df6OjhaOUvcItq3bEBME3CCZbJuCoohmeDaQAzPcXng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khUsNb0pFrac0LiyXv8o8VOrnUUPCkTTZ5/CwOhpjk8=;
 b=bOkkOKED1TwipupE8UgDVEvwmWCkeN7qcXze0V7x6S4Y4XQdYGkBs8j74TrsTbumPpT9tWf2I2HDOGSP9t83qJGf6H86zj7R9zEy0dqGmiyuFZTTxMNhVBhjtvrsXbK/zSx64S9RZgamVDq8TRwbbdII2Uesoqi81u4MUfzBodI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4267.namprd10.prod.outlook.com (2603:10b6:5:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.22; Thu, 30 Apr
 2026 16:29:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 16:29:09 +0000
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, robh@kernel.org,
        martin.petersen@oracle.com, krzk+dt@kernel.org, sowon.na@samsung.com,
        peter.griffin@linaro.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] add ufs support for Exynosautov920 SoC
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260417121452.827054-1-alim.akhtar@samsung.com> (Alim Akhtar's
	message of "Fri, 17 Apr 2026 17:44:48 +0530")
Organization: Oracle Corporation
Message-ID: <yq14ikse7k5.fsf@ca-mkp.ca.oracle.com>
References: <CGME20260417115813epcas5p40234b872c221ce28981b17e42ca48139@epcas5p4.samsung.com>
	<20260417121452.827054-1-alim.akhtar@samsung.com>
Date: Thu, 30 Apr 2026 12:29:07 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0099.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a21cf1-c1cf-48d3-7b42-08dea6d59b02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	p1F5RqORJw6Pn/O0kVm457Hm1i+bKVy9Ucg3orudIR9ynXegpfWtB6iWGwCKUV10Znd21EGwiRsK0Qj8FdmX/my2rij8tOhJRKzYTML6JRm4dOeVlYnNqQuP5SQXlTyfylUexkFRpW26ouIFTQsDyUuzrL8fqxx69nGue3pjkfaPlU/FWxc3IosXOL5BUzxIBB/AqmaecsrzMojE3ommumdk5NGyf1S+PmXK+9QY1hkT4blGWofiIWjDLK//xT4Yc0R4Lb0NA/Csqf4QvbcTiinVv3hnJOUD8qi613AIejRN7r3FHJ+whYL3t7K+Czbbo+O9dQaaSBPE1t/B0L1OfSGCVvdA6GbfEkDFCpPCcfG2ZDmTNUkfklZ+bFLfM2Lrv1yXV/VSybCZz3NYGsD/f0HtgNj1QyljCQtiCH4rJnNY0TWJgrMqYUIPW3URVnXQ0a7WTNVxq6Q4NSFrxWbY+ydoYPc3utQXaSVnduUViWUYDHpTRqxjUBS6s1mNa9nUqofErKvonT4lolo5t+x3FKa85+qZqcNi4QVB3BmxX5ZwRobAYt7T4+E9C3pH+JEZq/W2W1/z0HxMjl731P9I2BTGufULRvcwU3lxccBc5ySXmw9WNgA06PIcysrRNWyObE0lAbm/KS3qDvKRJUiMPn2fAx11WZuIF9RW2Zg66VCtJdpq20lULAK1kcXBhS0JOxbMQICeXVhCP/83nmKGFDMNnzxsGCC5GjzSvByTbro=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sj/vnOy3EOopig/o1CZDhaeKLI6NxKCXxSG6XqL19lB4/rYAB3/ZCGe60te2?=
 =?us-ascii?Q?XS9ZaPFdCVHifrHR85islQnw3PHoIBE53qWLo+nOWWQXp1RT3vxmIaw1JExw?=
 =?us-ascii?Q?Ioo0isTD4wCBWiDCQHXLoBKeln5zWdap1xPckFTZg/yZpDOsqG4bWej/rLzF?=
 =?us-ascii?Q?8m0jW4BQ+EZMPNz4yZcaWk3TvgjDmWrl5kA4+nfbx9cxkdSYFPWHDfBKD6cs?=
 =?us-ascii?Q?amjQxwuceIHqblsTviLPICoLOAravkPvPY/gn9sX+LjghoIMc9Umu2/J0sZK?=
 =?us-ascii?Q?xGL9m1jk7qFdvnuTSXkgcI9KA2OAqUgpCLtBdtnwt8oqHOpMMTf0UDaFy5B6?=
 =?us-ascii?Q?buH8ScZOLhcGWAZ0mX1cal9z7k2CjDofGroT17fwxn/caWi8A9VXCRgvFFQj?=
 =?us-ascii?Q?uE4OtEcPBFeNLGlP0H90+3rimezZMyTPgz1p6R7vCs4gTC/ASxcquaRCJ1fz?=
 =?us-ascii?Q?LKTlG/tFUxhlPcMogRXtK+jjYKOCjrWQmoVkJZi/64SUHzCliNC62G6YUJQc?=
 =?us-ascii?Q?Exs22NA4l7HZbnM9cPymdUEvW0iafD9j+Ch27uC3BMDmsOYQDYk4kFH2p9Iw?=
 =?us-ascii?Q?FBKrGYyQe+r8pxnGFaQ86vu1cICUDG47v5esdyhRm+U0dZIpU3T5G+AXS2gN?=
 =?us-ascii?Q?T5lLi0pRf/LSC6v6LOdcTHF+gfA4+/IphEcWw9+dpBX2t6saUPnDs6Qyw9rI?=
 =?us-ascii?Q?rLkQ0rBme+IB1hg4m8bPV17wscOh2lxNsKCJz+hLB3lcYnvx7lm4VkLvBj1P?=
 =?us-ascii?Q?0TmXl05we+3DhgLuONlDjdwrNJLXlN76AYBtSgFHbkzrtXImO6koAY/R1jrN?=
 =?us-ascii?Q?D50ZNKOAJTlzCMqPdLlWfep4qjx8/B+/XaCgZO0MVcbxt3wAHlFcq5lkbPV4?=
 =?us-ascii?Q?ouVHiP3kBr4qWWIm37nHEQbMDAD2jPg3u+GIgBeRzC9/RDlWjX9uPUdo9Adu?=
 =?us-ascii?Q?1p+JJIXSlKAF17LpRwzdYaekvWRDsnno6g4cQs2O2TdNT6pdbduUx1fF6KYo?=
 =?us-ascii?Q?iE2BrX0OeZZ764ToQzZYYPBe4LpB8fsjvMr4yuinHFdu6I5LotkyS1iecsON?=
 =?us-ascii?Q?gq7Z1AYPmaxuLoLxJOwj0NcE99yU/qrA3R8NGOEDlIE+TrX7bpIdlVG9F+EX?=
 =?us-ascii?Q?v9Xkb7hyJZrCsi8SsYBUXfibHx0iO+/B39cHuENl+hY1GvLmL+JLi+xRZG6K?=
 =?us-ascii?Q?NrrEvdFz5Yk01F5KwJox+Xsu352oYJy1aiX3djGDCpO97586kIxus1EIRrzt?=
 =?us-ascii?Q?i0XV6buDPuASIV5ArcitKcB9Uz3qHhcOdDsiU9M4G99IUw/zJI5ImySQ3ZIv?=
 =?us-ascii?Q?2NRFU2qnNpgzisfJ1hHylEL8YllBuwlduLBEFcy08D0eHnawzLIAAw5MNnXc?=
 =?us-ascii?Q?6meepPE4LemS96tTp6N5Mg/QeW2CIWkmFBr4ub+q/4GtOTYUsETbqkxcZefQ?=
 =?us-ascii?Q?+uOZaW/RW0Cb3GwjOVHY/DlVsEZtDT8qVxRYmilm/OWPQA4O9dcKV5YgZrDx?=
 =?us-ascii?Q?ezpzKBcLihtHHYnrHrJAh96YJdUZpvAL7XADGL1KTuRO3Ul2uGzLfTxQZpg2?=
 =?us-ascii?Q?2Oln/N+8t2pu41l7sTmUDL5ZBL/HgPy4naJdKxNRCYHrsBUeEh0I0SekbYtr?=
 =?us-ascii?Q?Utm17Pe4/0y5emgf63CPMhJdL9sFWtzpHIIpBrGnVGmbriQV2lBKDiT+/2p9?=
 =?us-ascii?Q?gJ5PeV2Pe7cIBHTcZa2T8kJ57eiqKJusnyfQyPy3WIElrBxrnOYOfDfHNOtB?=
 =?us-ascii?Q?7Muh6kpDtu5gBDXR0a6AgGfRC/CZI6c=3D?=
X-Exchange-RoutingPolicyChecked:
	PWSfuI3khRsQ0pgp8g11fKcKZ60VQF20rHFs3j23vS/99IOyG4cudS5dtd3YJuU6ENr8pOnrXDQeHAA4X3eCH/gwkw5Uluqv3uRNMkz6IA3ITiZq0WqFXExawEk9Wp8lp2dW8ZWkvWpNw9+EqwL34RI4bFR8QpdtGAi8xM4LJ5gP4MzohPOc8mAFUQaisGIVValGqtfcUK4Xu99REW03GaUNGuOl5dhi1tmhRAOQcRi9dP5YQEjZBCxNk20MxGEBhQaKdFI3aTZKHn73ApDC+1+i47UhdhI+Sd1ptxJq1pSecCv/LoAux/+sL0ShgnKugBLNvKaPXrug8N4TnQ29QA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z23pT9rI+heCwK+Q62X8oNysa2IMe8SGf/G4mPDqc8JuSljCIv59yiLum/hZmwvgoeRuWt8yBS3MfaIs+L88IllqUTkWiJC4S0LghDT12ajhSt7WIBNia5dMLYHk0wIHDlcVEvoRVlLMmIyicL24deoDy0055L1eja8XkvjxywCb9xZweiQcZ1IfkCE8801GqUOCCgO57poXibnudyyiMhtnCNVhxGEziWiCCez6+YUYBDHWzm/gcQHBfCT1P1s4+KiSRa/RKHgzKa3WDzQaqCVCKGlRDQUQmQXq1vDca+z8a+prW+hPfrW2qfbdVh2rQ/xOvzzGy426jtmKJw84t6lBShIWb/kZffwxCiPpX/Ob8mnLjhBr9ynAxNaYozWTDKJzVwvwUnE+8wrKP3lkXmrslYODBK0C3yGuZ5cf8Ys7cBMl2BtDnLm+GHjGwAM4B/s1sidid/eUUgTAecAFMoB7wweTJ/7D/vVGbVN84WOXrrFIVZHf/1y/dwhSXEpX8f1KGs2HeNTkWGfk3dIOxaAq55iX30Jf8uuXVEM+2rr1G76JuFDc1ehfiuP+6jnkchBm/uSefwjF9GDCrJl2mF+tLot+20k8Henru/9Fk1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a21cf1-c1cf-48d3-7b42-08dea6d59b02
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 16:29:09.3394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MJoOd0qgF1GxC3wEwg6xVfib7/dF7XcfGcJNyYgYmFdw+XGsWBecQxP0L3p1LZ0ZZYeXEytDqpGFSp9JV8KeMhb5JkK9ZV71EKcDv+xYgNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4267
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=703 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604300170
X-Proofpoint-GUID: mM-qSmEtDAkYfbtYsOyrZHihmlo2bjhu
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f38359 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=v6dcgs_D_w9mjYzB0UEA:9 cc=ntf awl=host:12309
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE3MCBTYWx0ZWRfXxZQ0FvjelLta
 vzlng98ZbEy3pbhFItJPnAyM+UNN9gB+FK+mV96WwSM0oK1jyxngTi++FBSzWpS4iLaecCQB90i
 RcFR+NTjzaTboxGxiuOrzJaBZp0r4ZpNaFntRwa5zZ0+u44y/320NaylNTbx8BgrqWqqRTFgT8c
 0E4a+0WuEgYO5/AuqgjNJh+E5rFUAvVVjNYwLB+/V7qmi6mW4mUp9o+fafnqiaobsy/Wjn6lwF3
 cmiG5heIfXGM96ANqw3w23oufhBwjOX0Ffo6u124A5C3pcI2Jl5/0O2T3sDRPbqZ+4vHUrRCCm9
 slbnv0kV9IaRyl43XcdXqAv4lQO0e7h4hbVBROBqvL+gACH4OYs22F8rqo3DOTzDRy4fJI0URQA
 VCckBpXfXcw7w8q30PhEOupAsPGZzQQAynBqX3QSlZ9bmDywOlT5m1nupKy3VRfuMcZ1EtguAov
 XA4jsAeBQtz6Lrf6YQJcXRaizSm7xohe02Z0l2f4=
X-Proofpoint-ORIG-GUID: mM-qSmEtDAkYfbtYsOyrZHihmlo2bjhu


Alim,

> This series adds ufs driver support for ExynosAutov920,
> ExynosAutov920 has the UFSHCI 3.1 compliant UFS controller.

Applied #2 + #3 to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
