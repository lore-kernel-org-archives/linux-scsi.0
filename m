Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20703282F13;
	Sun, 26 Jul 2026 19:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785094221; cv=fail; b=b5BGy+DESfwGjNdYn4sA03F2zBE/tvDQt4uyi5WhF8mJiZ2mbtgrCt0Fx8fKwviDsDLJDqF5ySU4HlyD+c6vqg2hc+1d3aOgh/hhX1rLKACvFfBTdCoQAiXaf/FoGE0VM3MLZnT2sio36d9pd5wPNCq1YD6H/bo7v8w5E59uIqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785094221; c=relaxed/simple;
	bh=q/aFk11FPUuOWbN4eFEasTnWjplmu7Uk9j7UUE2zRWE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ue09zTiD7DrQ3xwRYrI1LluVL4h0B2XtcwDzg87ASe/uKwfoacZ66MvkGErEtyBn0k6KWlqe9TVldFW5iKDS7Bqp7RdLLCH0SQZS3OR5XeU63BQSG8LFoXo1saUGuo2ZQhvjinLQbPmszSjO7ePneYhF2OIrNiquO72vg7r1cts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QUsiTdIB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jEgSMsvo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QUsiTdIB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jEgSMsvo"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QIj2An1254891;
	Sun, 26 Jul 2026 19:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4ZZK6EcBKsfYBnc0Bj
	0ZVNdsZEk+FexLdzwz2a0fcX4=; b=QUsiTdIBWb3EPBLBUfpJ7RH0jqGhzCQzJ6
	f1CGakYdpugnna1wV5dhJ8DhLvr2bxJd7P7GRW48x+uOEQTy8epAPtVTemDW6fXB
	qiEhxTcwteU5TO5ekxL0NSTpbBwXRh22MKVp3PhJfZvlRU0Ec/U2Xth3V5jKDDU1
	3ypaKQLfZL5LUjWIUhGz6JIFMJG+gS4TF8KXa+KcdIOFnJkocXmfAgzkEdiciadQ
	+IeGyTDHE0SqAFTAu10B/O+8BKfAGbgHpTHJbS8T1b0I0SdR4Vd3AAbw9OBykrcs
	zPjll03CTWuNtBhRbY1LIVzmgpBUC0YeT15gZIaHXOtQRpIqhSRw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyy8y5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 19:30:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QJU3V9009070;
	Sun, 26 Jul 2026 19:30:04 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010053.outbound.protection.outlook.com [52.101.46.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87dqjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 19:30:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ygrwIrBZ5IAsO+AEd5fWUQecq7oX+mP0G1ynRd9Nn/UZa1H0cLVZqeDiPob0LictTnBTaoiIX2Wvo83Z4BKkq+W1P5LlXuCcM8Eor12QRY4L+65NsLXj+Z08MmSCkUJGIF8CSmqSz3VDgXrUKNXEcMn6q69S7SrQFk4wHSMzZer0NrpPkHO0qlyIxtQSYME0jcKvXITxvYukEHR6Ufs9jAa72znL3XfLlafdyURJ5TkX2JMDaYP/4odghjrq4MdXzrnlysIIZ3A7OMEM601cR6EJQDb98StNeWRFFsBzzse+mMP0tc9qNI/a9ePL5XPQ/WGutjVxJHYk1lqjXUbZLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZZK6EcBKsfYBnc0Bj0ZVNdsZEk+FexLdzwz2a0fcX4=;
 b=Nx/OMnXjrv1nF3ebV5uieM3djE4Wm8ZQ9ZvW9tVkGmgums7o/njCyKf2PBPRcLzXVjjXt4AtolfmjlZABHc0qLWlRCPMyeCtikGVY2u6LwHxICRd6TuwM7YXAXoCFyjbp8TR6fG7skJ2JvPwDVR/saoMvD3QmVIMUQ7JUyIYvpTIL/2ssBIIE4MhIhwqQGVmZDQ/zLtAEj+KnJTjpXvadEdDAFsjE/LX4U7iAt0doCI476dfVwsptlmGF4THYQE4Z0DmyNuaP8OFSGP2DjfnGEByhfQx2NsxC81mRrqRPdqe8ScJ1rDGA2AIl99Te9o260wdXmz7W6p3skjr+22yug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZZK6EcBKsfYBnc0Bj0ZVNdsZEk+FexLdzwz2a0fcX4=;
 b=jEgSMsvozW9DosB7uKVnjtOCzlyiFLIGWR1JjuyeKTr4B5xaiGGedbBI1GKN1e0QPrwUx3961GiKPW/y+5THX3RKDy1ur2VX+6xf99d/jC7MrBlH7AnTLPRpl8XCVeOEBAvxivNc63tn5qPZjx1k8KK1fmRV7UaoxnsmCf7A5Qs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB998047.namprd10.prod.outlook.com (2603:10b6:806:211::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 19:29:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 19:29:40 +0000
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: alim.akhtar@samsung.com, avri.altman@sandisk.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Shawn Guo
 <shengchao.guo@oss.qualcomm.com>
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
	(Manivannan Sadhasivam's message of "Thu, 23 Jul 2026 14:47:33 +0200")
Message-ID: <yq1fr151red.fsf@ca-mkp.ca.oracle.com>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 15:29:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0025.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB998047:EE_
X-MS-Office365-Filtering-Correlation-Id: fd50c107-ebd1-475b-b222-08deeb4c3c8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u9KfTroP2Ksv3LL/gz2gw5tzVypK77vXG77iuyigKlUFFD2hsySJH1ewzoSbkgMq5QlkQNjl2r5teDqFqBbB7J1ghBp2NjUIDk+u1hu7yTVpWYcbKwl04teQpjaEqowkLnWmx5hCsUz0vitxDIR0HyprcqfQ5cSlYeMaKxp6I49yJYQG3t9wFuCpadf1C4Kwnff9CoDmQSb5jSU6R1pEIN7P0KMqxdZyUiZl+SAC+ZWi++IRWYZR1a+L780gsmwA/A8X8ENZj5fsQUxEkPWbrHIBz7kuVmNxuBIK8THMeyxZL+iSgMjtBVE1rdvSUYVisygHgVgdTEBsOZg42rdudhaRBpmD84BL1LHTPXay6c5yy8m0Z/kprnNMC+jJAOGEyg/WyoNsRfJIlZ+1PQSD6boEidLwws3zg97R4nUFgdcpzcWkl7qTci2xtco2KvvjMehPq8BfAc6psMW1q6S4REIHTw5OzzkxekxHUDYZL4hcJKraUa2eboXxHhHGD1XWsvl5oePyRIbwp8hW0tEIPfrf+GGprVMz5f2dfQBfOPM329a/Y7coeX0LX8PNthPFBkoFXKhUtgVBgRUBtDC+p1g2rfsAC4AP9RkY91+P1m3lCspA72SoYPExRaE+JBLMGksww4ZUq/115iCgozAPPvTXEQeuWzyvdGIHxhAotkA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rS5/l/UR3/O82VSHVt8TCv3f09E9SuMLwF9TOIjpqNMZ0wb6FuFipJ6kvfka?=
 =?us-ascii?Q?r4JImkXEK8peRAS0ekbOPV9L/6RTJkkgKO63x9tfnqLpq63n5qSh2x/a/MKK?=
 =?us-ascii?Q?wbbfdWWtjwrIxp+/VWQ8vcf+2JIzeSzO3BplRmVENvQ0GoS4V2WSBV3X1Gg3?=
 =?us-ascii?Q?AtaCSih0I2IuptOrMmcaWzKl3XyQzczOXVoEnbHV4pZFwblZE/DckHN7AFSj?=
 =?us-ascii?Q?BNPlgBP6e7Ztwha/EdgKC1uipDab6Af2Oyk42sRLGbFLXsOjm+8Mh+4LeFWr?=
 =?us-ascii?Q?JEJPa82sFH/LAJM9W1rgCzAeni+0+p809MoieIOFfO0qyW23KflAuKRx4KHq?=
 =?us-ascii?Q?8ODcJL8bU/zD0lHxnnlLL91Ua5xg2KujaKEV1n23lodgJLkkTrHVNauQFCEg?=
 =?us-ascii?Q?0A9/M2MPGw6vSzG8OvB52P6f1huvFuaoU4yG40PKiVHLC+ngilaM3Mrdf/g4?=
 =?us-ascii?Q?3cApfa3fnRD29N/XzSa6LfGXX85YNBi0YNX1tnMjRhTzmE3hLE5CXm/xs6Y3?=
 =?us-ascii?Q?C0xKBPBe0rapBuqd1gUAtyqnJ9Mc4DZn8OI+SjI9C6WLBI0agwzWEbTk+RsI?=
 =?us-ascii?Q?8jIm2vyFmYJPpwomK9K7VtlLqGBsmswfVOSbSHwGAAjuBeA0SKWPjKI1bp26?=
 =?us-ascii?Q?ZCAaMkRo9eLuXIgx/Jvbd4w3WcZzIznHujYPUkprZ2JWCUXr6frgl1FYOY59?=
 =?us-ascii?Q?07W3T4+otD0kBNg/xzmY9kqoBCPJ0HYiC7/Kd/SZ0B5zSOxvM2eEK9006leu?=
 =?us-ascii?Q?XJjDZvxA8cWVVwWloOJ2mSz3ArKPPaLQzC4uNnDDdTP8bQpPu0d5GxHQKlyu?=
 =?us-ascii?Q?1b0P1f4kckfCEe/Y1qMAWEDmZPz5RNqzqJYUW6KXVQkIzpM/LDio/jIHMJr/?=
 =?us-ascii?Q?341wTwHmyKWEs648sRcqZqszx0pV9U9EVPX72Qa2XBGo6kgwi51jzCPVo6Ro?=
 =?us-ascii?Q?OWV3eg9FRDsdPTWq1AlFxGtedRQxomBGS3f046dKDOl86c70W0ZrnyHmEE/7?=
 =?us-ascii?Q?GZA+A1hgXKtTzkEt08sBN0a1Lz3eastTPRoQoEVIpTh1jO/XB6ymrexKlMV9?=
 =?us-ascii?Q?cCIglZxOdAj2b5oAkkUrd7v1kz8slbTI0+HipdhceVWLsKaqwnS1vtCeTuw9?=
 =?us-ascii?Q?owbxTOk5FsGTXZEABJTiV0eDXCoYHL+7KXcc3waZDxTx+qrAqYWpfv2ks3OB?=
 =?us-ascii?Q?h94/Iton0ujWpEXe1fCAWSkhyJwZFrd7CAr5pr9uWwf2aMXf5pU5+wzkxAL6?=
 =?us-ascii?Q?6IHRTUUtA9uzArHep68kTyvzHawSWBIDR9vn8lwgmAykOZEKD9yBE2AWe626?=
 =?us-ascii?Q?LDzEFZOt1Sx4LjXHTO1g9TzgY2eXoFAVCm2r+tACx1jn9RttWDV48mcAtm3k?=
 =?us-ascii?Q?vbl1OOH3FkF7GLHmMYWfK30s/jFx9tvieCmPJ5BaH2wHwAZjkXq3ErPL5Ffi?=
 =?us-ascii?Q?peuXqDveyAymOP+Xhhsvwj1Wkf++lQjJUtY1JzZio+wLcdF/cdMF0IfaWloQ?=
 =?us-ascii?Q?mWRt5QiVZwvOCJH6bktCf5T2yJxymgzbcbP/AGoTbNhBNRRh7/wKWKUjG8jT?=
 =?us-ascii?Q?HcFZZ4koaR6cR9ZRxaj8xmu9fPVv7kRf9Zji9M1yCIvbjdeScuNZli2Qlxa0?=
 =?us-ascii?Q?TSUlqcYnmhBYvXgWgq9jx4LLAZOHvBwo3ETkD2u0wR0bEGSpp4JP2MXZDVVx?=
 =?us-ascii?Q?vacEs6XJZAteQWyBzvApKL6okfL7fDcolZcTc/L7hnD+uTJheBZWwfraraWo?=
 =?us-ascii?Q?1TlMsPw22XIbB7r6iePry42Lew8+QZI=3D?=
X-Exchange-RoutingPolicyChecked:
	p0z/18qW8WJAuv35NHvFwPBjCMN9AvsOHFKvVdXipUZR+2rqkYPoIBMwkPY0pSOX46XlI4tM+4EW8wx6vusxzeCaUmAbKie5tjSyR2DxzyQBz7DR9iEDz9ZRrV+KVtlkEtLT1IxS2lxZmKHJOBSLrPcfTMWHCyGKEbeb2BvkI4AgiYDBSWtaGMszbO2xx7IxgdlbVH61RaxSBmleSrB1aT0YiuVLm1mAo/u8DzuYSjSFDo1dWWXMclt4MR+z0IfSk6fq3sla7AseHTfsP6GPIhgCunByR9dDRtR3+x3bp7o29XmLQC967RbUpsqGqOPJ6Za6Z+NkRGa2ijqnYijcsQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tX97jomSR7PNkgV9aqHs+f0CUIisVY6VvVBq5xZd5fgfmdl8YFflFSPdBtHtuwxgY+gnw8U9N+LmVTLSL21DM57z9lCVJtW3ayRSE7grwSzQfQb0S8/6n8LEreWZyN08Zsd66f4NzoJlO/7xe/7h//VYBDLY2xzcc32ktXIBxrAHKlY3kVpBmg9CdA0fGZXPxuHW2YUQ5+G8/cGos7m0k1yo1sQ4IDEIWPUlR9J7rxCyfGOLbjaK7zcTSPbF9wKYiP8IFv3G8JWkYdaLzWI6dfDePrSHNrK3RXWBfGDgJsNwmJKf10FruV0qbY3yTiyyCd22AZM+a2r6NsePcVh7nvchjaYiyfu/qtxdYjTgNg7iqkX7RflbbjoP0vuK87OTCP4187//AWuQsjxU0mYfhjorfehvw19VewraLHtnGoIbCPUAOvPMFlBFfq/792Q6EeO+UGuzHzzd5ae+5/Uv3ig7y8RHwlbIxAk4ixXU0QxZFIZHNu48be4q05wJ4yFCWFeXAR4fb3w7JJzFKI4LVyVKzLRh0KuQGxouJUAIfMDzDdsywG49tWt7d+N1RublZnpnzPwTtUesifkiUq0QVAIotVTO4mOWwn5jlSgDxUU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd50c107-ebd1-475b-b222-08deeb4c3c8c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 19:29:40.0172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BhPtqd2JB2dVXBR74a8wCHEVtOJylgOL/bt2LAif6rApZpVARUFD3gJddf8SoDesueIbqPQir/c7gbxRL5vCKiaNf1HiEueoTxZn0uckODk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB998047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=886 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260198
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE5OCBTYWx0ZWRfX+DclpadQCIuA
 sKRzgnzLHMwv2OkD1Dww05hsv7YJp6p01b5UBr1mksqN8eKJX6nzJhfbddkpMl8p/qbAgI4sVVz
 I4pzYcI8TEbQvfFCScv54Lyer/i0PID4CNDpRDg70QEW5OjNJr44
X-Proofpoint-GUID: O0nvwCB06FGWAd1EXOmzkCvd0eTtohLI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE5OCBTYWx0ZWRfXwoUalo972O3S
 ZYz06nO/s3DYekZ11VDbBKo/Uyhz1WJSPjGrTNfXRq2e1vdGSFovGxBINvbwFRakkLpLIW1UBHd
 XC4QyhbJeuUeIQTFGwh4/3xVlmobQvnvpSeR/EkqIVkIuGayZQa+OR0I6npxl3F/Yn3D+nVrpEb
 gthdtWWqtOGWdcy3d+WqWjZF4ZVIvNJjJ2iNLGAe/9+Cpiv22gh1MJhC2yVNa/VT/VYg79FG+vt
 7ZiWlkrpq9x3SlM/91NywSw7/YRrJf2UZkZisYI75OPuc71WpgePaIXHysLPylG+ZMmgweRrbeG
 pJni7M+GOtuhYZOILqSovS6qgbi0A9FRvBPl/DAPNxfdee0v3EBJXQ6Ycqs7c/oZv7/VB+H0opd
 4mGvC65+YClSmpgSqmpLKVHeWDR0XaQG2tsCQ0gCB777ITLTvZvr01UuxxjcgPyoY4NQ43QzXVZ
 o32WQocTsXPTtSyCSSQ==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a66603e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=2i_018KbvZ7d290h6EEA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: O0nvwCB06FGWAd1EXOmzkCvd0eTtohLI


Manivannan,

> This reverts commit 85b2b966285498e1b551ac85f02c79cd06c0cff0.
>
> Qcom UFS Host Controllers do not support scaling clocks when the
> traffic is ongoing. But the offending commit removed the block I/O
> quiesce in the clock scaling path, which causes below UFS failures
> during clock scaling:

Dropped from 7.3/scsi-queue.

Thanks!

-- 
Martin K. Petersen
