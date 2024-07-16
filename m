Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33BAAD24;
	Tue, 16 Jul 2024 02:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721095666; cv=fail; b=IU0M3Cn1Bp5tbv7114rHIVaKXpnPj1/F+GW41ajbJeRPQdbHZUiUfxND7xWVP5vCl0HMW7o7MM9Zskp0ZTQemWE7XQnhRNH7fxCAs4q2NiwKgLYhS22ivhICYAK8xSb9wmQIttSRDdA+qJmE58sgrn0HIHl57CPrwksGmXbIuRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721095666; c=relaxed/simple;
	bh=wc7TqNc5Tzex0YgAWwPnUSckcvyyeh8mbN3cFdZu0xc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BZAKGelRmy5BfdzKIjd6jxjw/1pVdJirIB9KySkPBrMT1RC38R2YmOyMUL+s6GFvL4sLHHIP0L/rKkKVk4kRZVKX54BOWbQZpp7gKqU3zdnbN/zDOrPs+2fLe5eL8t3WLnPOjLeNa26wYic6H+S8V0jyFZwDoOswzmhMTOjZSpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P7QMsUFu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D3yO6bd9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P7QMsUFu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D3yO6bd9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FKuj8p022605;
	Tue, 16 Jul 2024 02:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=i/K4fR/tFK9y5V
	PjlxGtk1aYOSIgjw+mgSdbv4vuvh4=; b=P7QMsUFuryrJN+nl3kqPCGko00xFRR
	jdKvJ0fZNhOrTOYS21Es3MC2XV7qWbmvAY5F7FCxIrmDnzOw0wG9vIy3J+TEdGFL
	+YZ9v5pUC8SGilJEv4FnQnbeOgfQXejqz5ehAuIXASEBbFCVdwBqL+Y3ex0YqxH4
	I1Ojo/ihIkW+qtVpffq5sgIGHluDBnlt5vzGAGLLL/5iw5p3+t75Za+PkWb7Uzhr
	kcni+zZxo54xaU+tPoC0a8vzXasEcPCJ9nRsjJVvoMPyuo201lVb0Qc6fCNTxQqf
	9KwmFx7pp3JViaSbSKEb9uGLv7RnDlmzLSsV06fLZGminqsE/VTvVyqA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bj4tmbb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:07:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G1P42q040561;
	Tue, 16 Jul 2024 02:07:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40bg18pgu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ggjcrdc/XNiQwC7EAX9ngS7BzXkpkjlo/qxs98kvOUkS+P2j8BGw4QmDVi/rUg0mpZFgGZUZUzYL48gvG1USKemcnBHugch2JZA/f059BXLRPlb9ots6vcbmGgjAcvYlvMtSs0+mzzZXcETqOjQUfohvg/rnUkU1ZcDHqIgdjzLyLGr/kjMrQPS1SFmO264qkdAmufmUpm22syIq69j28ccmwl055NAom+mlX+7F3xPDayZcJF+LOV1bHL/UQDdmVbd+kmtZmDCZOVOsrsOmO0rl8mBRmTJqpS1FmNbVYv3YKhNLjj2pU9Cf7FFUrmJrSpUTElGrQbuu8mhne5IMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/K4fR/tFK9y5VPjlxGtk1aYOSIgjw+mgSdbv4vuvh4=;
 b=rFFBqRTGwDByMBgLwwjv4Cjl0zhSuK4DWXM7I7f6tU7AJKmtKexi0mxZI/wyW/KOvh0aTwOzOEXp/er1IZPNG3bHcCUScdi7EQTBzmxVsUIa+1I9NGrBS64fn6RiSs5TVg3CEZkUXajP3WXSsrKnqap62SLZxLxguCmz9JExiRkS20nBaHsF6lQ4ovtSN4p9VmmP++6w2id7VlpfFcBKkosDAWNh4dQvIbKHGAtZh3JwtK0Dpysl1BMxA+OcgUdSN6U819dlfqfSCULAqDfAQfdRIHIZWq6MtMAET70cHe2oCfeeTRIDdNndE2ucv82QYXbx8+dd7MlkkzzItd8J0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/K4fR/tFK9y5VPjlxGtk1aYOSIgjw+mgSdbv4vuvh4=;
 b=D3yO6bd90T1Ian9J5NWNxNjUvWrq0kf5+8xt1cm9nitiLJhRaSZw5Z+j7HEmdmHBPwSlTYH3o255+q7D1PSq7wFcQGskRh8Q7xofmPyqQVfuL3WEYp9c+rtJURVYFGWbuGSDdEVnQCpNXqDwlls52OUeMwOfi3I8VED4SkWm8Bk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4363.namprd10.prod.outlook.com (2603:10b6:5:21e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Tue, 16 Jul
 2024 02:07:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 02:07:27 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kanchan Joshi
 <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711054224.GA4331@lst.de> (Christoph Hellwig's message of
	"Thu, 11 Jul 2024 07:42:24 +0200")
Organization: Oracle Corporation
Message-ID: <yq1cynektsx.fsf@ca-mkp.ca.oracle.com>
References: <20240705083205.2111277-1-hch@lst.de>
	<yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com> <20240709071604.GB18993@lst.de>
	<yq1h6cy3r3f.fsf@ca-mkp.ca.oracle.com> <20240711054224.GA4331@lst.de>
Date: Mon, 15 Jul 2024 22:07:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4363:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ad2200-0989-4cf7-f4b7-08dca53c0a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?mCkRD8B2NIRyVN+cxLA6xpqqhUkrsFHYsw1h/EL1/nayRKV+YexMmYlWZ88e?=
 =?us-ascii?Q?+MHd/voboGa3meqkLQlstpKsCxQAMR/5HCyDit1C2WI2PF+Djjmiwn32LsHj?=
 =?us-ascii?Q?IcykIUe/tLJhvCLGBn5JFAIRzbHILhNLhoioYjCj90vn6rfsD98srPFjVZt2?=
 =?us-ascii?Q?RjJnlr6lFGY55m6tNHObbnsKAdmPZaBh9JErRBx3sgt3giDZGniNJuartKa5?=
 =?us-ascii?Q?M9q6GOx+BWilLVXTg1hj5FU1S6YWTQj7QzThDQq7ZbKxq6uDE2xr797/a9Iv?=
 =?us-ascii?Q?qSvSQREEQFKFYnn3BxwXa4RHAQFMDyZFzXWc/Czs3Edwjqvf7BVttL+YacpR?=
 =?us-ascii?Q?BOnF/V5W2FFA1lo678ojLJVXZmY2dBskE6ettvfxvytPg32wLQBw/7nSFkCF?=
 =?us-ascii?Q?brwXZ0SSJkyN7hgS1IZckdN289aJRB5D9ReAiBheEvrS+b5DxIsk5XEtZtAz?=
 =?us-ascii?Q?N/5tLEyJHbJh2KQlXy5scqeQIP2ONZuoZOdovqO88+JGM+vDa2m1H5w9M1I0?=
 =?us-ascii?Q?cXo+qGTbQJxoWcVNwH9bQF0XhowtMyot8KCY/WXPFfCpzdveeum4PU9OPHqV?=
 =?us-ascii?Q?mtEJVC2G+G3psqiXfMo2JbiMeOV6CWpZxld914slXHMAGugSwbU89fMin2Ac?=
 =?us-ascii?Q?z00My5pyJCkkwAKz6cnS1SJabmrtRpWIkwvskjmQC0hEl+BO24X2NY8tPJft?=
 =?us-ascii?Q?K8ErTnUqN+c0lzAzv1pFwzsaZ0AN/Mq1JYODS/99RPz6sroP0zK/KlloletP?=
 =?us-ascii?Q?7BEajiwCDtvQ/RBHAEBOLhISPiOS5VzTBtHau+7hptcpv5Fo8CUXiHOjPUDy?=
 =?us-ascii?Q?xXyyCoLzk/oHKaYURqUixkUUghLyxEcV6FH536U4zHZscLhaNX8z84hhotjR?=
 =?us-ascii?Q?6WmbgnrktKmsNafg1FeM/dUL9s5UuJHtWWYxSPiql8WSFdbcwY3HazIlszHS?=
 =?us-ascii?Q?0zgCrBJlg1PjNexoHcezb7IpBoePwFHFg0ALGBD+SzjPZ2ft+aXX7AMurXuY?=
 =?us-ascii?Q?2t/DDxZRULZsGt0TYeGnp2/78ptqlnHss1iYDhMsQdzzkiH3uYYaNFCpSwMw?=
 =?us-ascii?Q?AuICOQYC1ejSjGBTchK+zP82mPj49ueGHBwkVOOFVwzOksB9Za7pyBZPrL6v?=
 =?us-ascii?Q?fUujhVObe0nXFp4lWdAZrpCu7qOouMRt66UoBn2TzdaRODaUJZDLCM7voNls?=
 =?us-ascii?Q?bN3IK3PMlDLo1VkC5OZiR88yA+oykXDt/z8wnzEHb2fQp3ZJgPTdjuINyKuV?=
 =?us-ascii?Q?MQjjoAFCTMfQy8SHZFxrXkyTTKcNBJJQsWdPsDGe4bWBpnwJ59nHsQqWrT2P?=
 =?us-ascii?Q?g28r0e1s/Q800qFn3ogPf+oiXcCK2wDs56rDBoe0BGMbpQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4ZpuLADQRrXyaexxr8nKcJyvQTwOstdbCcmqW1uAdt4s897YqMICwobaqiLC?=
 =?us-ascii?Q?A26fke65HOvNcDHf+/PP0ro2WGYWVxW2Tocxq9Vu3FmDA3BcgFefw8qP6oU3?=
 =?us-ascii?Q?7YgApsmt4Nqnqvx0R6pg0qk1WiHWjuzpWHCbjwlHqjQ90Ofc9z4N+rFJWF8z?=
 =?us-ascii?Q?NTxjxfkx0/GjWSDlvNPGM7lfq/ftzvsV4DbuEFqerE4DzFncfUSwOj4SLHMQ?=
 =?us-ascii?Q?bxYs2HwFCrYEcnIp8B0XeIxP0kNA0vJpECjzD1XYPXurk/Hk6ASQDzpnDimL?=
 =?us-ascii?Q?7WI9hoerwUwr7ULbKv0Sin5II2GK4aN2nmsRG46CRssHZTzNhFyNRYIk5jQO?=
 =?us-ascii?Q?KwNkxpR6N7mMX0EhUgRa1DLzinWVtKwD+NU7TE3DdVOb5M58YWCXVfuK0U4t?=
 =?us-ascii?Q?+VJxYU2KS7e9yrUj7AGB2W3x+6pE+CgEvR6s/9X3MtcKqziv145oJunzpBss?=
 =?us-ascii?Q?NUQkA097vvFp83kdsVvb7M5zMDjJCBgxHA7WdSU4a9eQdJMz4KXNMKZ1BqG0?=
 =?us-ascii?Q?8jMLtKVBSNchcEAIaPKLjCtPrH6h5WpHTlmbCD/pqI/HgSvZA8x/Iy8t7gKY?=
 =?us-ascii?Q?Feea1u/u4p71puCbjPHDqJrvk/ObuvZLJxIKf99EJITlJbWacekclwaGmHl6?=
 =?us-ascii?Q?4KxvBTHC2NoXYXsx337r2DSEEITI2Ysus7TmhvJm1xqpGgP4odqQbTf1Tsds?=
 =?us-ascii?Q?lB8OHKHF1OsuR06xk/WQ6cclt5Yj5HiddhF0B7RvFqOaCw+3NDz1ccq8NLNz?=
 =?us-ascii?Q?PWHGD+g1TjvE4ySrr8Sw90bI0A533NI/rqA6GLykLRLQm0lp3U3tdn6ZZD+s?=
 =?us-ascii?Q?K6KsgSioFwED6FwLfgJ95jVXdgZfQGV+c5gZ5V3onrxjW3f2tnEJm03+mIgS?=
 =?us-ascii?Q?GtZ96IxsrKpMusza9vd6aotpI/xlnICbdmTFBefeCEEP5tpqKoWAGue7fSsK?=
 =?us-ascii?Q?o/zh9NbXp87qL4mF4djTvqP4m0mNKFKSU6UZQGLbpXGLSAdXfBVnZ3B4qKTt?=
 =?us-ascii?Q?uD8Z04402kVsJBWJCMz/cJYgclfWVdIjijUvCWV8RjlL7dLLYXSn0xsr7AMG?=
 =?us-ascii?Q?6FmMkokMYAwrgPUHkDoJss85pAz7hz/fa6L0vP3rIcG5GwzETu8F3TO3ZsFI?=
 =?us-ascii?Q?OzBJ0ZvhN+0RLRU15HB2fWl3gu/FHhCrMosZ2u/kfeVMAAZWxFpoMCQwRgh8?=
 =?us-ascii?Q?MSTWi7FHlGHbH8Ujlz+W9q4UylbUoDi1aGgh7mMIfW6S9eUugkl5HvHKReBS?=
 =?us-ascii?Q?Y+35t4FbALgnXR+cE6XxxXv2RzBOWK4O+vuhVCP/W6eRo8Jtq39cbiNLpgGN?=
 =?us-ascii?Q?2BLaOxwYHaJLowpsNAQUL/rK2gseCzeXBfjx6KEYlKF4dW473QiAHVguiziL?=
 =?us-ascii?Q?Z06EFMsDcZlYqfvfynnmOFLFFy2N4rloxReB7rlGkdJmsI9+rQ4ChCIlg5+O?=
 =?us-ascii?Q?xliqbKjUnaaLWStjZ4pUtEB4ifK5zY/5a4rhBkCOOy+oBe2Jz9Me4NNHLgCE?=
 =?us-ascii?Q?gEK25PlT23VrL8iY/XgqALik9uXgweOg93CZiUrajPslQqBAGhs+rdcZLWYw?=
 =?us-ascii?Q?8tLGHyESAe+AgMwkLbYjZn1vR5H9QhuigiGZQK11FHDlnNVu396hRSPxujyP?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	2WstPhLX47KFnXXstSbk1oaaqEnZvpedZtTdwJCMgt1kZBSFWRkSz6NJRDGsYD+4diASSz23xGowzjm0VrWTndWr912/58UAIzq0BDCQCcEfskqIB3epiTEBuvqDbbwITpZmKtx/y6uFfKr6zgK/bpHLS3j/Gls/1/uKsvGgqnQDrdFUPNQdINpV/c5a1NazBsyqNdHpsMr90nPQoXTIRdkrsGLl035nCss7ApaznVszsDoVtB+J4lkyT0UClywBjkjEvkocuPE1pyQTz+6tuuaUzd8dg/BV+0+MxfYiugMUhXh3QMk2/j2AzuBdd+b3kuxZjNuRNboiuuIov6+f7OtWM0ldGwAmZ12NSFpqh0yktE6XfTD8dj7G9uS8dsp3DuN2aJLq4fzYWA+4akvXSNRjg8O/o2+hc/QUGL61inZJQMrF/pFSG8h8q1Hcy5bUwA1X9z2iGUd9cn9UO17rZvdPEscprA9jLeSnDLB00KWt0E+T7IadVEv7zx4FmpzGZqmfoZOeihrUpAKNDx3Ji+UTTCtC9dFZD3IegDzQLKwtRNUdWf927uzjEehZx1J2bszjIR9iPxbxQ1gsa+DRwKmH0ELNxHupwOUJVvyhRm0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ad2200-0989-4cf7-f4b7-08dca53c0a5c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 02:07:27.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dElv9AwzzFr+oOYHOpgcKmZ11ecnPfq/VR34t/1Tgjtfz7wiE5kf2jH9lOyGQe2WSBBQBNCeB4YqD+O7GipJDTCBuhDJ6NZDwXHYazY01qQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=508 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407160015
X-Proofpoint-ORIG-GUID: ZLP0RxJhCwmt5bOyBLAWj_6Qm8tEavqI
X-Proofpoint-GUID: ZLP0RxJhCwmt5bOyBLAWj_6Qm8tEavqI


Christoph,

> I really hate an API that is basically exposes a completely different
> set of flags for SCSI vs NVMe.

I don't disagree.

It is unfortunate that PI in NVMe was defined at a time when PCIe was
the only transport and therefore it didn't make sense to have a
distinction between controller and target. In our experience there is a
lot of value in being able to identify where exactly the corruption
happened, we use it all the time.

In an ideal world we'd be able to have multiple orthogonal protection
envelopes as envisioned in the SNIA efforts. But with NVMe only
supporting one envelope and the SCSI host-target envelope being wonky, I
sadly don't see that happening.

That said, I don't particularly like the idea of removing existing
functionality to match whichever subset of PI/DIX/AMDI that NVMe decided
to adopt.

I am OK in principle with the idea of the user API only describing the
first envelope as long as I have a different way of controlling the
second envelope on a per-I/O basis. It is fine to require this use case
to be explicitly configured and enabled. Many PI devices require
configuration prior to testing anyway.

> Can we figure out a way to do these as error injection points in scsi
> or something similar so that we don't have to overload the user
> interface with it?

I'm experimenting with a few different approaches...

-- 
Martin K. Petersen	Oracle Linux Engineering
