Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB78523BD06;
	Fri,  3 Apr 2026 01:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180838; cv=fail; b=H1vmYN4cxzutxKSG+LGUVgDK3iOjy3DY/uGO1oTxbZiQKxr5gdSpkO/1PYF4z9nB+ApwG3VOG2FQaAd7l9vVmwyCYeLAyxoEY4lFK42eVYoykfyZ1j+aHOdH0/P6jwqqb21Mt+vDeK6L5bWXwYNe6xQx7vlbzOwTANR2HMmCOzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180838; c=relaxed/simple;
	bh=rlOqF/nlq5cNy9A7+WzCpSDAxzbCJVYuTCBLeh3jvlg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dguJ9hPG5SCX3+kX10iUVHXWvl0tMsSJRgp0MXHir8KDfB816B9X5qU3bVuGuZi/CyU1V2aeIv9MfuMIqXPnNdjp7zF6kzwEM17vBx9qKu2jdU8rPEfJWcXsBf2NyEp0/bPEbM5bO/0oMRPXjHglJz7DIpAQOc0y1ecN1aRWGw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yxt700a5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hOi0qJKs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yxt700a5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hOi0qJKs"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632NuEh33161718;
	Fri, 3 Apr 2026 01:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OkQPAX6Zdxp4rj9kSn
	96IFt0XQIapB+K/HWz4D8/Zsc=; b=Yxt700a5a1WBT6nvkDAR9Cj2oaPmyS8zfx
	lV3WMARtQWzV4zFiqKYXPtvewSzLHqM9zUN/bMfKEqb2Ar3yYj+NPhrt17ntDln+
	yzORPxyyeDwATUBKReiZQVX2hOB7ZgzWgmRK4ozI5qHkY6quk2T0h/WItuanBvNR
	cUj+rH9xwmqeT/vIYmb57EyAYBl67O/xAzFvpnC7Vt6HQH4msUUKUq9klawJtdKX
	og/hzrfpLVzwU5y+cdCwZ3hfEKBuy6YiJnzuXZGQeCH8FjsocY6KLk29nIUfcnYN
	dPTDYLDy2Jv6fjoBSwxNC9eJ25nki3Dq+15mKPAvOnivEPReuoIg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65w7hg62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:46:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6330UGha039727;
	Fri, 3 Apr 2026 01:46:08 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010063.outbound.protection.outlook.com [52.101.85.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65em04g5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:46:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcHaMZ6h8YZm/MC9RlBsHzMIlrM+ux3XHWD08O9bKlfqKd0wHDg0cJnVVGixcUj0FEb+a8C14/cc783or0Yn0CqovoFe9YWyp08TLnu6bNubyMM2gbkYEOuVt2mq8N7dPNA3aqW49zaADRbUsG629Pusoa1E2TRTY83syKh9z1kP0vIKsGXu3pXtjJmsMWndj1sbwmlvM9E1TQdVC1stJ8CgyPPRsoQZdLJC8tJ3ttKKbHFeHD/7FjNXm1UeOQ1ODmxo21dwUpwml7l9NxeBBthfVmDbuvVlztpT24hMm6KsSK/pxLdbAvgKvZ3epLJEVVx/sNW4n3JvlHXc/6Xv8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkQPAX6Zdxp4rj9kSn96IFt0XQIapB+K/HWz4D8/Zsc=;
 b=cBCECYG2etRB6mTES50wvFpzCGicm2y/9RaLt9ZqFgRZUGpEl4ENT7lm5heRmxwXGUqCYMkkLa6gTGJe+yweenAWpQ5D2hQzEGZliLgq9g2Z1m967EI3V5QzUELkRsJN+66BH0hxBvRYvgokr1WWwT5VF/gxz/YOpY7I9Vja7S2Uk+YOrPb+HMRKOv0TxrLw/jvYOD2PQd6JKC5pZoxsFQ7WjuoiARE1r/dsWNMBU1ZxEC5XqXJZTuYxCgsTQ8zaSYO0TQ10kuHAiqNax3bUDbcUmmo47OLeX6wcSzHoIBcqPZO/sjeynInWPbJQd0cLyPHf93vBE34dB8btQ+m86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkQPAX6Zdxp4rj9kSn96IFt0XQIapB+K/HWz4D8/Zsc=;
 b=hOi0qJKsSN/U6vDoHf40/HGt828LWzyrbPInYuk+HxeLLKMqAhCJmuGciNfeafOgipqsEjXRGjYX7cNnpDh/h6h0FK5sj65hP7LtXrFG3ooKLPRa9ZLgO5ughjgEAYecSj2o0R7Zcp1ideapIZ4VJ2jIfGsnuGJVfY08ggwxSXo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 01:46:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:46:04 +0000
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: <axboe@kernel.dk>, <kbusch@kernel.org>, <hch@lst.de>, <sagi@grimberg.me>,
        <mst@redhat.com>, <aacraid@microsemi.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <liyihang9@h-partners.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <shivasharan.srikanteshwara@broadcom.com>,
        <chandrakanth.patil@broadcom.com>, <sathya.prakash@broadcom.com>,
        <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>, <ranjan.kumar@broadcom.com>,
        <jinpu.wang@cloud.ionos.com>, <tglx@kernel.org>, <mingo@redhat.com>,
        <peterz@infradead.org>, <juri.lelli@redhat.com>,
        <vincent.guittot@linaro.org>, <akpm@linux-foundation.org>,
        <maz@kernel.org>, <ruanjinjie@huawei.com>, <bigeasy@linutronix.de>,
        <yphbchou0911@gmail.com>, <wagi@kernel.org>, <frederic@kernel.org>,
        <longman@redhat.com>, <chenridong@huawei.com>, <hare@suse.de>,
        <kch@nvidia.com>, <ming.lei@redhat.com>, <steve@abita.co>,
        <sean@ashe.io>, <chjohnst@gmail.com>, <neelx@suse.com>,
        <mproche@gmail.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
        <linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        <megaraidlinux.pdl@broadcom.com>, <mpi3mr-linuxdrv.pdl@broadcom.com>,
        <MPT-FusionLinux.pdl@broadcom.com>
Subject: Re: [PATCH v10 06/13] nvme-pci: use block layer helpers to
 constrain queue affinity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401222312.772334-7-atomlin@atomlin.com> (Aaron Tomlin's
	message of "Wed, 1 Apr 2026 18:23:05 -0400")
Organization: Oracle Corporation
Message-ID: <yq1a4vk3jg1.fsf@ca-mkp.ca.oracle.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
	<20260401222312.772334-7-atomlin@atomlin.com>
Date: Thu, 02 Apr 2026 21:46:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0174.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: d92805f7-67fa-4752-61a3-08de9122c461
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 rQK0pBQNka7Te43NjbvNYAnzmuj4dbHcTYvogUn2mrqrRlkmVJh2DfK71CevZKT/HeAMGI3KBWbXMlQ6VAbUz8EdxPsJXBKZwZYnA34ohaKmSiF2SWdnb3q7TH1UOcoMUAGPANSW6nStXyFqwtwfrM3DYqwmD22xJ6H6vM/c9mvAC1rfFXalVfoWJEX4K1peanOfW14R1U/IxEWVJg+ZgN9TLTURQIjOHsI7M+vFutpYy0X3VmneNWGqbpuDEyFirFqr0jb7u4z62Uw6sbwbd9k8CZMG14Nl3eg6ozZrUa40qPczPTbL6PxKTmEDDzoWroPfy5+4WxWET2tAPP3Z7RCJ6RZ2oAcaNh1mPaVgg0XpfcLAM3j9NHCThCcNWlRKbsMK5DxsvKyvS/fHdRLAjXcGqg+LDCgkfhY9D1Ydf5XE6rav3eI7UkanMVXwEDgVhcfnxwxsIBA4Xn61tEOYXM9Qvx0G7a7nV1Tqrh3kxrGsWdHkYsNGQB+k35JdthrHPRMbM01SBvudboCm5HNDJvOSY+x4kmE1IIYOBUKOm2fJ+p5qnheG2xe1SCE31fS9m6fDrC6CVralSK3VfdU7keuR1KiiZa9qwh1juRvv0xtpgM13CWas2lkjf37GSucWx5odLUb/sr4qHe7SCPhPdM4efXNR5/R5HEGTKosf5LxSpcXIPJtzLSd8fS2eLf5ifuUnOW3n2ysuXWJ+Er9wcc1FgVhdfH0x9HnVP75nCC0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?yTXiR+iX2S5mGxzHbJnrCrhMXdu72if9vQDy8ERGOW4A/r4b4QpAFfXyhLsc?=
 =?us-ascii?Q?TWnZdl1amSwTNxctfcsa+AyBs9n5cMPsAHlQYTuJqqk6KqEIQvYePti856sG?=
 =?us-ascii?Q?HNul4dtqNpleS4AMYmrroUs5RLcfDvSn324gnb+g9BuUaQtv/nrSbzZ9GoPz?=
 =?us-ascii?Q?To4vkkYw49eDjoE0rci8VlN6yRuTEwhYety6g/WyVz6Eg5qaOApGiuXO082t?=
 =?us-ascii?Q?dqyo5QlDwYIXqk23l+sakM+p4qBmVL62UOzz8Oe1+vmi///I7hc1SPK6bya6?=
 =?us-ascii?Q?4xw80jt0WnTWngWUGgpQejmEnQE9DnC3RamOqkNeRZxCTkJXpHKUnP9Lp8KR?=
 =?us-ascii?Q?84EAfqEnDA0r24kn5EM8zbseKSjhfCFf96kUEziYOOl86qIyR7HysZQ6N95H?=
 =?us-ascii?Q?vsq9W/jJbzxugXoxgrngS9t2IwuuVQMnlLoS3wHDOlunA6FCnwNswmLClEgI?=
 =?us-ascii?Q?/JNb47pDerkZmcb5S96v0FBrcJnivvH1eTISnqK7mVlAB6yVR4eRoRV8nXq5?=
 =?us-ascii?Q?H2LavCo7aSruC4RoadWBHAZ2OFtmtwgdI50CfUX8e3qgPdpqJZNjvvQ8i1HJ?=
 =?us-ascii?Q?1p65n7MFNn5YS/1f+XRV+ntYhPygx5/AFjkq8EacG8nl5011TGKbkLxrSD0W?=
 =?us-ascii?Q?PALsbxnnEKFq/Sut6QDwoft4sonUA0mMRRIItIjiWWFw/+LZbxNX9qdJPqxU?=
 =?us-ascii?Q?biP+LzTYqanMHsApeQbnnl8+scLCMa0IcsrXUC4zkkewJr9sD7kehvW1Vx1O?=
 =?us-ascii?Q?KnHCT2q3ThV89C/bpdGi8moHtdDqfFJZICxRywtJfLPNBNvBRbmrOb+hSpw8?=
 =?us-ascii?Q?1d/mReWBLrP/ebPRQlQiKx09bhqzej9HIt+Jb49050VmxjRnOwKZK3BAYf3C?=
 =?us-ascii?Q?FXLsGPJU58xD+6ku4gcux2s64xKN2YwtXskTs2/kq5/NY8Df43IUhTou+U0g?=
 =?us-ascii?Q?XUtxSVlyXQwg/aXf1b1OGBf8RH4FJNgJEIUdVCrvwkCZYZ2fA+SpaiWqR9c0?=
 =?us-ascii?Q?HvOZn47K5BDKg1UrIx0Fv9a1mVWLhrHGHDo4BW55nX9svF5Of2TVNQ6qBNmD?=
 =?us-ascii?Q?0l/1bD4LitS+czY5GaH2AICXmecHSQMgr7Bo7s9pLFWE8PYihvRVdEMhb0kH?=
 =?us-ascii?Q?hK2a+nzA3o38/sNdr57Ox4if4p6et1pw6AEJvyDJyRVHboqDeq+VLDWjFE6h?=
 =?us-ascii?Q?KtAo+AEiJMJrrrDk4M1Sbm8ac40Vt2IlclJJCAZ950SWR0JExzF8Sp50yGAy?=
 =?us-ascii?Q?sybLtzGJXM6Yrd20JxAgfCBNL6ZmqrPnT8cI2rH844xkAIKUbwFWYv9NuAF8?=
 =?us-ascii?Q?QrKp/lgtmbPCePwSRgsFCAFWWbNLPoarc0GM3qmudBKbmC9YaBIK69hagn8l?=
 =?us-ascii?Q?3qNLrhMrZ82Yj8YN30sFGgjz+PHYpPdA7yIMWfKJhYGJQtG+D8hGDoI+rZaL?=
 =?us-ascii?Q?gazWuv/k4qXqkgeSB24l9uSCz3OvD1bejhzMkYg2QHPh66koTLrZD3S7BsjX?=
 =?us-ascii?Q?ATLXH3qfAzxCCAHPz6lvp7IqRVx87FmXPO31jX3VqhMB57R0QJnrrEnY7LDN?=
 =?us-ascii?Q?lY8yiDW21/M6TYOvVybnc6TnYTdZy54pV86yvv1Ar/hhiFysJ1m6cmsymcpn?=
 =?us-ascii?Q?oZahISgxn8llFTO4BgIbvq1NkdYp8CB9AmRiLGSy2fmc7AOe1GJ2s8JQxgBR?=
 =?us-ascii?Q?JKJq5i7BIvWYieEVos9rR6YQDUgTTnXPkP5Ivf5XVclsbRPqSx4OIJt1K0UT?=
 =?us-ascii?Q?RKxRQzPFE88FyAgwa/i+ozdg2PeUWt4=3D?=
X-Exchange-RoutingPolicyChecked:
	Htv4AtHtDoKq0buF+GI7FzG5TTIGYSlQVugUy5EC6BceAvdlEPBM8md+oZN8drh7/0NsBGs42Ad1uRpdZosAE0907UQvXanRVIBiSBDyKB83D1u9JYVmM3ZxcITab7OCuwg87ZlbV226tWJyHaVnRvpg9/t3miNss+xL+9tzcawqyUO1UtLp7oJG2gn8qMaXakoVhyhK5iXjyOiX82PGKsHH/58XKnoP2NF+/wly9FORKky5doJ6f0bUepgPv3FIV7/eUtgftGlxvNlwlmS60TT2UgoppX4An+qQDFCWmmfCZTMASVx4HMQpIHwdZD1sdJ1JKgmW8Q2qsJnxnbA6Dw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5ThYg96H5mRI3kyv2Dik8i7S1frQgRe6R/gRX92PvXcO8T27n4zQNjL9KWZOPkygnnjXBRDiMVaVM5EbGjC1kMAxIZQcVU9JeOL13l+LXLCzaLoZiBwAI5q8qlS9funvc60X5b7St3b2omA8cg/LIdaOQo+w9S/ijKXTnYfSM4wiQW/rvBe4OKI+5s59R1GTGTiownj3ezps3UsN/aMqc9uu25+OCgQt/wOj4oHHAwK/jW6G76DgMqUkeFzz1nGR9RcwCv++obxmyD+ypPDYoIT+r3rVlRuIfPVewgN7LMJDKB0Cch3dIFWkAv6+0fsjHocgT4f+JK9yXaN8cdhf6qpqrkaRI0PgAmThKzeXl/NSKAbuM8LVxV3lJCuu+cSexsxIi2X2VVz8hrICJFghRXgDSnV0O10eWUGIY66jSaZTyiam1j411He2pTki3blougQGNBU6UrhH3ZJOHYXXuKBeTfL2Tpq4/K4wVJE+p9nIFq671H54L43JX9s8+vxYKoocY+W6bXPwl0+tJeke40KvhtbE5zOGgj4juf2K8CZRugsYZukKAGs9Sa61ue+WeHxK5E/qkIaOMCLoYY4SVCxqdxN9dTyIgBkKR3ym7xg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92805f7-67fa-4752-61a3-08de9122c461
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:46:04.4012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDbeaA03xTdRJy6jqslPW9Cf+CeoR8UBseAxfSSOfvd6DVUV9cGDS+H59HLXPz2PAn3XraW0twqc6Px4MsDrkFun85aq93MEOIUNuFshHGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030014
X-Proofpoint-GUID: _BtvULuzNoxM5ta5WkxLZ9eS3EF57_5v
X-Proofpoint-ORIG-GUID: _BtvULuzNoxM5ta5WkxLZ9eS3EF57_5v
X-Authority-Analysis: v=2.4 cv=DKSCIiNb c=1 sm=1 tr=0 ts=69cf1be2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=Ym7BrytTJpxj68NhldQA:9
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12292
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNCBTYWx0ZWRfXxg/oqYmXw+PC
 8g2uEwptwmA1CCRVLuzIv+5JffyVHWzp2Sb+StQAsme81m1kzIAoLQtbgIKzC0brq05equSeyLo
 q5KM3Hi0+DdCouMMen+770A2ZHQEwZ1z5T4aNFJkFoybFsyCyuYZnqaPDQoO6opR1gpvvFEGkAa
 ZurxzfV0A6iUpykbdnzdzNSYL3z7VBOO+SRo+cgcHAHmUchmO9mIa6pNvibquqcA5cNQTTPQdRl
 qmh433DNq2uCSwQ91ouBwRfRSlwRT3qC0/xVHgfvJFH+HjhmVXr5wMCqbenTfa+jNIwQtCfZKo/
 f3UdDiYYZrndgUEm3ewtFySnWkzw9qNcAqMGrFHFKy2aYxCLeI3xpk9JUx1wHOB79h9/mmfJn59
 nTMEtBEWauBuFk0l+CqBXms2oMGsZQ04bK49/h5lPmtR4WjKVkH5ieSJ6yYsCxiHvxvARjGqx52
 I0xAz7p5xljrXRhH0VjamJBYo521Ajr0owEE2SN0=


Aaron,

> Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
> constraints provided by the block layer. This allows the NVMe driver
> to avoid assigning interrupts to CPUs that the block layer has
> excluded (e.g., isolated CPUs).

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
