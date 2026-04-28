Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF55421EF6;
	Tue, 28 Apr 2026 11:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374964; cv=fail; b=HPtfmIO0/ueQ4e/LYdLStoqkqThmnllVL1Wm2+lQSSaGekwUFyqj5JcCEakzOP1SN07TgMjp++LAr8UcMJIWPDl0RWefoooqt4/MesXgE9rm0qywS7tXk5t4crMvguzLyk5GKSfBkOFGMhGgRBm28F+TIu+2v3WvbZDARK9G0dk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374964; c=relaxed/simple;
	bh=My2fYdZsmOkvZC8oZvvfrlACXzUfBLCDwNx2l3FgrUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dod/T9BztzDMHk17Pk6B2X+iuSb9SOj69QtILwJQG6bc5fCgABpQyQ+EXj3R4nq+FIu981sB3hCX34o+oOVcUnVe2xh5rK3Klv8ETl4k2KmaQLd+cfaBajJB5EtS/8U5Kvq4qbxziFMWxrRvw+/cQtvI8NDWXixFSUiUqgStryk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NsYoB1jl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tX5/zOAA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NsYoB1jl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tX5/zOAA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9pvla1905709;
	Tue, 28 Apr 2026 11:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HH1lsDmGARiNwvrFyrjikRpDdEGY5WQgzBAYUadmrio=; b=
	NsYoB1jlOzPKS3uCxahvITaYs7mk9whkrChU/CBe2lb8iThqhORHF7NQb5OMmU24
	OMb236rXKRR9kPo6ipEMfxXd9A/MUkdgo+fRWYiwJUPyQ/h4+LXymTtXzKP8h7Kz
	YcVMFsIxxXkp0YRZhnz/KHxtf/4nH55rFp8l0hzAT6Szy44bTolgeDzCsWb/hSUy
	4KGop9mxPFokjcwrjNEPWwl054rB2z925iqkRJQ/f7H+qf8j6DvotRuXd24ACp41
	nw413++yX1gtM0Qv/ce2WXH1gQO7IvsbCzHSnXyKHr+m6F5r4jYAy2VLKOCGRODu
	RC4NgRrDKnZ4MQKi3TEwoQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drng8fctf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmVd038802;
	Tue, 28 Apr 2026 11:15:41 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccner-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=spVULhIJ9o5+bX/AEp56gYbRMIm9PbM/PqS5nNV+TPuUs9AuuiJ/b1luOmKHCTTkhXg8H3Z6SqHJ2/prg2ZXLdavuDXBc2rot2u1atLlZZx7AEUZns1t2R5U6dNok0iBMVu5ckDXuVT+DRcARRtYiyZiWY/DjeSg6XWe2+pZglbQYe3gVVVhXlN7d/jp8soD8H+mt245X+VMgDqKqkCLwzrwYhOYckslJmq34dOBpu+Nt9mYanXhYfybFKZVu2zXlHhDpvVNOcMIEoVFbQIh96yUZU7qYHeE4XJByiVI5eF/bZsQgmJFIEdZQvPpmotAABWSySRgxduiwbOXAMmpaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HH1lsDmGARiNwvrFyrjikRpDdEGY5WQgzBAYUadmrio=;
 b=pzJmLGpHSQKm/0J2ts6//vD5OCJEd8HORM19JGdYe1kBQe/hwQAfKnF9RMUGFLw9zn48bM94oGgIJYTmtMK/qTQlA/eTLHYvxzoL076xf2rr4qJcOQ4Dt2MY2IaEzX5ZJl3C7I5seKOhPxHynVEFOvBPXszP+PZ/o7DWg9U6orBgXteYLbseFL1MSCPW5xiJX3Ik/n7Pzd4nXTcgZQDbxF7aBiQrj+68u4zOGeVVxIjLLN65FlBpapQq93N0hzRyV7klSkJCqBRvrdGLShjWZKn47EZpwEfTawHy0JC4/bzpo2Y0T5AeO1mNFDZta6u6jcaAXjnughWD7dRLD0xHXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HH1lsDmGARiNwvrFyrjikRpDdEGY5WQgzBAYUadmrio=;
 b=tX5/zOAAByoHMT04DjUgs8Ju2rUNykroRXcFIImpufkydTnHMogeg5vQgU4KKIdf9k7wndM1HOKMssRGy3F/c8b+6Dsb4OrE7RCeXLXwP9+/P8YNCyRAYbpQKurqTlDxW6xfcoClBCr17k9FvmQ06SYJlaPQUFuAaXPGO9FeyAU=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:29 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 14/18] scsi: sd: support multipath disk
Date: Tue, 28 Apr 2026 11:14:43 +0000
Message-ID: <20260428111447.1779062-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::29) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: d1faa71b-6153-4e7b-de5b-08dea51774da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003|20046099003;
X-Microsoft-Antispam-Message-Info:
	Y1VHIkzrnI06/aClQWjmy69i6YraI17G90/2g5mIW0oJLzte1e84Z8UQJFjwuTAL096TVwbfKDoRn9cn5kX3kn/8UHS+OgNlxLkXlHovfKNwSOzgosmELVaec9ChUo/Vn02jYWBTIJitxgW2SyC1DRs7UzIxT4mRQxkjeKWG19xfCazbu7J1N0nxvc1wzQD5ZWvwbyBdLiSTJxuO0XZD3orsp1CRqTPhmqt4z2RK/BJewUWwQ4frvl0QL5OjdbsPDccT1M3aSz184eFRK+4bdltAPeIZ4prv0ecc3TdxfOLqxT81ymxIl6CHXXeLNGgV0a+HgfF+HDRxaujp3i7fUBdeYPju+olUWc5no4vN3jkXwA1skApnVPg+n33vD8+B7H2FqMzv+muNVVNZg2K9ybcVpTFrqmBtXYRzdnwMA5cUXDqRk6JIjtNXOG/+4WQOyinqnrrMAlglVHALe8+kcyR57h3EH2HFPH1xVIzEuYto6+cV2wGHbPFP9pwsXOyohnyA2PRXiuvpXMq4sbzJy91tKUCH2WDYXuB+nZc2e0qhOdo4SgrVmYThFdgcFRfrg575HlGqWSS2kWVR50nc3yF8XlxDl825Z2Op2FQ0MbFxKCCBfcyR0U45Gw7owaXy0vIMIZDBy/xhjgL2regBZpP/dXZY/N5tdDuApPXIiUEuJG2HXtm7PEhkSfGlSvyxxJyl/mVODmgp4WXvRyjaDKojqHZ9Dcu6nwva3oSvuBI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003)(20046099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0PIEgiw2Iht6+dzUdNAyLYUZuZnNkNGSHxSof4kPnnxW1FH6b8wDSFp8wPSA?=
 =?us-ascii?Q?vjf0QmvgLBqMTxNdOB6IszQ2y52lHIHvcLXRHQx7NR7ih3/ddkl5yFgpQKgU?=
 =?us-ascii?Q?KbU6X3JmbWiH2O41Um0qk5PAT/VdFQDCMJROz2QhsyOJl/9R91S3ZmFBzy2i?=
 =?us-ascii?Q?rIKxPZ+B2WqL0rRYhklChkUfKW5OWSv9KTg7by6ihRXYC1dSLmWxmD/+Ov1S?=
 =?us-ascii?Q?ENhl2JdVkNSUHQ3paPEBeMjRQFEl98mixXm0Eoveje19ifThqNXsoPperwLL?=
 =?us-ascii?Q?Q5S23wRtkh/+DaytBlxFJvIdTAX0aD87+I1+dOhqpup4eRcit5bn2/6G0SBO?=
 =?us-ascii?Q?iOL2VgMLtPM+6o1GpBXMMJOCzUtAcUOxcytjL9y4qWC8KrLGB9E61THz7ZKy?=
 =?us-ascii?Q?MINdy63mSU6JoBbQipkgx+kLLJp+PDUg55Jz7ZkiJDyFQF9JCEzxQgFqlaKJ?=
 =?us-ascii?Q?ydyjTBQzH60oG65AG95yQMIE7Ik+vAY7BZIzX8IwU2vvnViQOSxA5+ZjpnP2?=
 =?us-ascii?Q?EsPNhfdpg6fSrFowrQ/BG8a7MM7YAoOU1fhteirhn5oRgthAUbipgfdEKuJx?=
 =?us-ascii?Q?Lsylj8V7gqRORVB2pqSRiHtvt0YJzKDw2eG9fEziYWMCEhRoxomIkSQ6k3Sg?=
 =?us-ascii?Q?pMx2xAJWB3mMMq2MzTaa/Gjzo0PIwrp/CXamUFZ7xu8YnrQs1p0jOHn0swMP?=
 =?us-ascii?Q?jeGOpiUU3rpfwupolhUVWhsLXNK9lwDsu/iE1/yrzGEfLu/+VHzQdSAbCCRB?=
 =?us-ascii?Q?/ksNEUikeUKrmeKo8zHzaeg/zPnFLrpA1MRs5IJVapFyKYjxyeJTP9nQZ/rA?=
 =?us-ascii?Q?iuBAcHg/gIvRgFQxQ1NzcVyt9IT/T3c2yOulzAsXf4ocX+9t6mWnZI0J5sbg?=
 =?us-ascii?Q?vf7MtNiEzjjNCLHNsU/vYh7cq26ApjTS13JfURWHUjMWdi7xlIoDqOTeJhcy?=
 =?us-ascii?Q?XWZAalg02RJbVcyNid3+bmOCj90TY553wYi09TJRlRCM2eJy3H8tWM01uyL/?=
 =?us-ascii?Q?dynfssRBzsNe5m7mdLPPSCIs9l9akkUV/QIdsGhO0nHaWxSc7AbH+EoA0Sgz?=
 =?us-ascii?Q?jZDG1OUDG6FnbQvs11e7V2bs+D0f8sjqTCauxLFiN1sn15Qi2WkNIBH3KAME?=
 =?us-ascii?Q?vK/RKIvsjMp2uFJ/iCFiuB4wRj7VMIvapvKNw2qU8eN1o1rbRgOpLo4WMWLL?=
 =?us-ascii?Q?SqIGBFDSCkUUV5HZjX8fGNRXREF+3rBQ4bJfonGip5wHK3DgxVEziwOaxBQQ?=
 =?us-ascii?Q?xH87pK0nlPU/WstKapISOwhfDjKGnt7Bii8FcoVF6H88IOvTXCpMccQNyC7s?=
 =?us-ascii?Q?YbBUztU+yUyAzwgro/qBGAdn/lbiGyZzA61lgshemUJDmBrL4nTLWpR0GWnv?=
 =?us-ascii?Q?Hqu5D9G+W5zyjN7QhGUAyJ694CPu1vOARmXk9klvPhPsaDJlpllvrMHQXNmT?=
 =?us-ascii?Q?UzqNEry14Q9TGWg7NDlFP9QtSHL8KG8wy8Z2/6G+nMl641PW88q5djADYuD2?=
 =?us-ascii?Q?KGZKzt1/QBm3NGVdK95X1UpMAkbp6dlRdlb/ZPTtH7Or6O04Lb12cw/C3Nh4?=
 =?us-ascii?Q?oisoi50d7hau1UvbFAD76GYxkDdJ6ApWd7uGbAMSKJ9s+CDikZzHwmNFiPX9?=
 =?us-ascii?Q?p5HRT8WMw01jXHnENWE+t8JUNT3AWMdw4kLgm/brmWDhgZt2sV/JYSo0Nr2s?=
 =?us-ascii?Q?Ps9HOt2ho2CA525TLNMkyHfk09rt+FsH0GNak4KZ9/0bCvq2T/3fqYLUwOzf?=
 =?us-ascii?Q?3Uhsq1ElKsK6zq96XlePwFu4aKCbamA=3D?=
X-Exchange-RoutingPolicyChecked:
	otTD57vFzmdNoKLWkkOpTZ3dQ0HGTEF8atoPk5o8eq9wzyyGqvARPrERpAb7UJBn3095SW2JRe/k+oZC1NbNKVfd1FkycLQKsQTzodRjcff9O/9djCIM3cZA6MTXz6UsnGu3SRLRzrA5qrRIA7m+0dhaS1H0wv9hW8X5oW/mcVvsldYwFpXXkhIoFXVq5aA/vGGmcvKtTPtSGj8xBIL7QqT4IL5Vwc/n4U4gnqYagTKiT/GW64baFxlgO/wQvX4xYgcFJY5YjxhQh1nPapPQ3arLz8pcwFr9NU/Xa4ShQK7AA3G7DB2jf4UShpvpRW+U5V+ZjyXVXK6wVH4o86FCXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qNbEyqFGHR9P03J60KEUSpE4WXAFkCpptYEIMppRGLGxHAIu+b1C6Czouxdm+1BATczKrwAxpHUEj6WtXRorF4J+yOiExGxLDA6bbivhm/92PtbA6gwMtdmfWQJEgpKJDgx11Y0skAooqnGsTR0ZftCEbaWEl5/EbjjZ9euGE+r8ZNYBc+m347DEe5NIz+J4IUWU3XUx3nyQVXhADsr1Gxzp2pxUl6egpYVDJcANTAbwFQun+LMS+P2ZcmR1cV7sUhAlaBBQGrWUXf46hhcwjcUscAIsyxUtlGvEE2XFi5cyCeuEkOxBDT46HpWj6ZACJItfeFU2jnAbQii1SbUjAHxEuQCgh/CS586mj82WNmLBeXZSlGxb+0bdREwQOFMO+h0j+WIzEbosjmcXqOFTRB5N4Hp4sq2cMSlrqOGu9P/7pQVyE+srEr9aUZo1lW5Y9DrpmMRJa9OtTe61wSIqNIyob9ks068X9rAxD+DUYceuupLY3Io2rLX0qiiZ8PdPgz1kT8m1Z8ScnAnvBq8YylkM+OhCJ44lVU7vdzx5Sfz0Z34WIp5IZg23QQuKtXYQJ6JHVpNHdLqF/DtUzDKt5ulFBHJ9eK4MKDGtbKXoYXU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1faa71b-6153-4e7b-de5b-08dea51774da
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:29.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFe2oBA3KxFK0EQ7s6i2TgQkQfoVLlqcgD8WVru28VhuO1cidYMqMsvAU7pC6P3tSGxUeeMtmFr6bQ71DiJ1kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=69f096de b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=fl1--RqHDNO2UjKtE9IA:9 cc=ntf
 awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXyhFJOSVpkBQQ
 uD0djqesf/CYbPto5sL16FxM78ifscR/aU71XKO9hOH/EiEjq8AE2sGYWcudibRd9QGvHstMZq5
 C6vieMq7YWmm52Kqowd5PlwouOyBf0rM72rGmutQzkzbObHE+rRdtZb+XpXH8/wCQigHxrW3B3C
 e4ElecvZDRBhisihuAhFqSkPSgjcEFmTVyFwKVjY47F/w/mwCdgynB2aGqp+7RWx4xIuJ8Vd7D3
 o8jXJeW3amdS4o1wPkQalTwr14ZAVxrkxC12dc9849P7XGWKYXKZTpCpFd9EfjTVwELnDXD3v9C
 FdYEjSYK/5ypKL8ocqGNtVBjimzHDq77T/a0oFeKMBNjF8CVM/YSks+5SeIwJNjmyEl+L0JlcU3
 8kS7CyYHr4njtIZNH1oT2u/ylHL4l8hYPqv1JaOzNbd0JOMXKUhnxWCzQkoR8ZVPjvJGSlx1AIs
 PwXfpN8V6syGWqgnE8fo3aX2oxRhQw9vKRJUgmGU=
X-Proofpoint-GUID: M9q4zslz6XajoBlgEXKbt4BI6nBHPNOl
X-Proofpoint-ORIG-GUID: M9q4zslz6XajoBlgEXKbt4BI6nBHPNOl

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1


$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2


$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.g.garry@oracle.com>

---
 drivers/scsi/sd.c | 396 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 378 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c74f336f8cba9..ca20f9430b4ac 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -112,12 +112,30 @@ static DEFINE_IDA(sd_index_ida);
 static mempool_t *sd_page_pool;
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
 	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	mpath_put_disk(mpath_head);
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -787,7 +805,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
@@ -3964,6 +3983,322 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(
+			struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+
+		if (sd_mpath_disk->scsi_mpath_head == scsi_mpath_head)
+			return sd_mpath_disk;
+
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static void sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	mpath_device->disk = sdkp->disk;
+	mpath_device->numa_node = dev_to_node(sdp->host->dma_dev);
+	mpath_add_device(mpath_head, mpath_device);
+	mpath_device_set_live(mpath_device);
+}
+
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	char disk_name[DISK_NAME_LEN - 2];
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (sd_mpath_disk) {
+		error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+		if (error < 0) {
+			/*
+			 * Should not happen as would fail for the same when
+			 * allocating the sd_mpath_disk
+			 */
+			sd_mpath_put_disk(sd_mpath_disk);
+			mutex_unlock(&sd_mpath_disks_lock);
+			return error;
+		}
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+	device_initialize(&sd_mpath_disk->dev);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	error = mpath_alloc_head_disk(mpath_head, &lim,
+				dev_to_node(dma_dev));
+	if (error)
+		goto out_free_disk;
+	disk = mpath_head->disk;
+
+	mpath_head->parent = &sd_mpath_disk->dev;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+	if (error < 0)
+		goto out_free_index;
+
+	error = dev_set_name(&sd_mpath_disk->dev, "scsi_mpath_disk%d",
+				scsi_mpath_head->index);
+	if (error)
+		goto out_free_index;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+	scsi_mpath_head->mpath_head->drv_module = THIS_MODULE;
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		disk_name, scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(mpath_head);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_device);
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_remove_sysfs_link(mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *dev = &scsi_mpath_head->dev;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk) {
+		dev_warn(dev, "could not find mpath disk\n");
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	list_del_init(&sd_mpath_disk->entry);
+	mutex_unlock(&sd_mpath_disks_lock);
+
+	device_del(&sd_mpath_disk->dev);
+	mpath_remove_disk(mpath_head);
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_head *scsi_mpath_head;
+	struct mpath_head *mpath_head;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	mpath_head = scsi_mpath_head->mpath_head;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+}
+#endif
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4016,22 +4351,33 @@ static int sd_probe(struct scsi_device *sdp)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4051,16 +4397,13 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		goto out;
 	}
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4078,6 +4421,12 @@ static int sd_probe(struct scsi_device *sdp)
 
 	sd_revalidate_disk(gd);
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4092,11 +4441,15 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_add_disk(sdkp);
+
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4110,7 +4463,8 @@ static int sd_probe(struct scsi_device *sdp)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4238,6 +4592,9 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
+
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->disk_dev);
@@ -4403,6 +4760,9 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+	#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_remove_head	= sd_mpath_remove_head,
+	#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
-- 
2.43.5

