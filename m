Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F652737E3;
	Fri,  3 Apr 2026 01:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180892; cv=fail; b=Tydu49fyq/f2HaBU/3U/U7hA5LeZARIxOuF35HqzWngZWMfwC0rEwOsLSOY8ZgqKolXMLwoz5kXhbx16eSFzQ24SCfxuQyB3EUkPRhy05dVhzZdXsj/VuIVB+vvChrBwkONKLgr63X8ozCvVAKQ7rcgzDZGYeX9uk56GRmeayn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180892; c=relaxed/simple;
	bh=iqvuPf5AFej3bOuOL8tNRyhihmKXS6UFmnf8U7owXLY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aRBj7n0cjXRNSeOOhaxrYPSJUnaUfli+cdqBJ1jEs0wh7FeQdcOiPI73RTDp+qePB2xB50fSX2LQKH9fdtcitNu2Bfc6bcGjPHb8/r41kx+dtsEBJBcMuWVeBMdZfFXkqE8seemqhmq68DQnK8/bKfrOqJA2OAzRg1tOoxKyC34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mvcqYh7a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fTOwd7O8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mvcqYh7a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fTOwd7O8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBphA2362943;
	Fri, 3 Apr 2026 01:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=e+qmZwba3RNDV0VGnB
	qPcnWbWMbdNpqP766J4bAq+UM=; b=mvcqYh7ansKzg/JH9Mgw3q50hmbA6eW/7T
	D+SDhz8NaIUvp3+gaih7cqN+L/7kcaKtC6h13a3JZ8a7UmI47mvSeE+9MFyOVN8b
	OKolzK6A1H+ZHulxRJEYbFyP5LRL2OmfI+a6gcBimQfwAYVoF2HZdLbFeGQk/UM0
	DqnVVf4M652dL1VQcmMDu1lhK26Nx6B/JuWChK30YR0OxlxdyYC4qwdkM0tIZVz3
	3E6rABcAvwBt43xdZbYgfbT+Wfbm8pVNh+tWZbkUn5r1MShhvhTBTXP+VAospTOu
	F78Cdgxsj2DFOxotQUE5tzY3W+EjCVtC5fOCvyBdGPZ2Tlo/a7DQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65dahbym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:46:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632NtpGg020205;
	Fri, 3 Apr 2026 01:46:56 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010011.outbound.protection.outlook.com [52.101.61.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65em08b7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:46:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fiRk8z4TKp3xVZlg2KBHDW2yOMOcPDgRyHHIP/Gk/OszJpwcQyQVIr7ltplLZqs0h+ATWzSS8R3i7JQVKrlp8chriHPfdgA6kWJP3xebJbzOHOOKW/3WRBQWDbUwrxCWwRIe16BJZ2JPq1hgyglHmZ7wfwmsAiJIBFKw+o5sPCwBR/DAkTgeHCW95g7jgtlz8tBtHdNhpa8ZvGCl8zy8ht9TUqq5YRoX1IjmgAVd4aV4oB3js2bQls1NGeW7rKpVpxiQO4voVakQBpHCSbkhE1rZ8cywdKqCcU08Hqwq8e7SWZLWFs6jzeh4XqE0KGrJ0fu8d2aiJBbzsDtroIXGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+qmZwba3RNDV0VGnBqPcnWbWMbdNpqP766J4bAq+UM=;
 b=B0T8qaCGVJkPz48/1EzOyS56ZM+46oJR47Iouc8srURsHJW25HsEhsBzQgWnRg45MfhkYwXctg1+5Iqx7YMhCe35yQRDpqPFhdT4rebBOievdzgBRt6qpmrcxkjMPmiBo6unw9n59jPPUP8mfFFlifrrClj4eQtMtFppcLlgFOTNKg1d93V6e62w7xJH1d5Jm6/V4lRa+zE7ibH2QVwd8wHok+jkhLhlpw9zLbn5g8pJsu0418Qd4C2jkpz6bnRtMCC7UaJBP+88ESpKMD+/KcfjmyYoZSQpPL4iapQPLo6UkjpB8Pu+XVM4O8xbZHvouaVGnUlM/oHSqziHbREobQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+qmZwba3RNDV0VGnBqPcnWbWMbdNpqP766J4bAq+UM=;
 b=fTOwd7O8G+A3qWkRYrysud6XZieJjt1RjWIF2GCaN/iTr/PKxG09ANKTjo7t1tU+xRDmGfAUY/h+7z9vehva8LC1Yl7AroMzJ/z8wNQtarFzm/HZOjmEI3ynEtEeTbj0quJ4nx8rzHl2D3xLI7M+N37V1JTHDpXDzh1Dpxlvfac=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 01:46:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:46:52 +0000
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
Subject: Re: [PATCH v10 07/13] scsi: Use block layer helpers to constrain
 queue affinity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401222312.772334-8-atomlin@atomlin.com> (Aaron Tomlin's
	message of "Wed, 1 Apr 2026 18:23:06 -0400")
Organization: Oracle Corporation
Message-ID: <yq14ils3jem.fsf@ca-mkp.ca.oracle.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
	<20260401222312.772334-8-atomlin@atomlin.com>
Date: Thu, 02 Apr 2026 21:46:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:610:33::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 26a2da33-dbb1-433a-233c-08de9122e0b8
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 bJszG2nG+3Z8db45VQR9u/8DNzOAC+Ps/o5axSnePZn/ztkh+5hR/dbyRM4RGzvGNRqgnn1TLV0aAaP9Ndh1bZFCrkcTQtgv4VPwCs2HAglBCa6yy7KoyRYzKrhiLOx7UD8D0rIDWBnutUsrzKyR9wgdQ/R/kG9mI7jsGhNJcK4fCMDoIEl3n/BRSeoYM/q/TL9IbodBSHnxSSLC2EUqaorRtsZC9oDfvWCx3ts61HNmThaQpJCF8DpZ4KCag5MapkFaBmg7+PRWpvgG0fq/Z9m8++0UlIUbeStKlkB7FEDcG9SKuPtv/wKsQDgVo6V322Wnm43xQhH7Uo7eGAuCvDhD2dL7ohk6I+qDoYQHMW674YcyBRsGt2HjDM6kk4eG/DQpPgU9R3XaYj39dRlrkvc685HqMQ2wqcdEZ1C+7i7cIKRptWx4UGf8I9aH2NDV1OO8t+2gAt8q3Ufh0fPHz1Eul4AErPpymQxYsnWKQGGsxhTgdUtTmbQb9L3o81NXjC11NkPcuQM7yDQW1RwpDMR8Fb1Qfyf292PYP7g+u4PX+W03WEu8RqNHSFNF/kwDKVf/iAirlfFsNUHaA0SaFk4Wr1ZJ3p2LDZSREOOSnMBz4iidapTF6fdNj4YcMXEhlC+BX6Az3NLJv4gh4m8CnAkUCnYp5uTUSOJUed9MxBkFaYk8i727vOQ3l3gYzWJV/v67vVuFm6tzmgMvdJw+CIpWrx2c8cHDGEaXrt8KCr4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Fux/OXXYmz6HjHXO3MuJq1fcUwF6HSZezkpLnfq4uI9jR4h947Zu3+sUNpce?=
 =?us-ascii?Q?m0/H7Ke6IZfz3PGNAnLaXtR60u+dJKLmQXDysheEN40gPl7l9VHw0IF6RomO?=
 =?us-ascii?Q?Oj1RhIQ0gq5IfOojW1/xfUq5YrUq6As+hsqGA+RG9GdsyYlw3xmMsa0ZbGSR?=
 =?us-ascii?Q?SDAefsfZWMY5DFLgwtbvhMiwUoEYEmk3UqIDjbB2cbCChqkXS+xD2ECGXUnB?=
 =?us-ascii?Q?89JYx56IAR0KkbVO5RCt48xoLqDcZKJjeEp8FP/3r7wNk6v29xeoyhBQNMRb?=
 =?us-ascii?Q?le69rkZVgQH7a5JqFV8agUpvkcUnFe4IQePr8E+mSV2Ax7DiBD5t97JGi+S7?=
 =?us-ascii?Q?hez4dVqM4/WsDmqnGmHc2D7wANK09EMVkjhyqTCtRmt4Ia5qnvtjK562x2Tg?=
 =?us-ascii?Q?3N9+l09bSuPdCuuBv84NKLmc9YJt5YDJ6jh5oUikyAa+EIevG6wD2PY8hu0C?=
 =?us-ascii?Q?hshFd4vC4jYL2fB4Uu+x9CxrvsSDBy+oOffX7kdMoIBMqadHOIsN3QkimBRb?=
 =?us-ascii?Q?9XVQYi/vRVh+FlPPrVIJW+c3pnTfK0E2kPssgId7WXS/O+MpWmyT+y1xkbVy?=
 =?us-ascii?Q?s6OXziHgC52MNKDNGc+m98wEiVFOT4U6ZN1WJK0EIhRdNv2eFT0DuC1j8Pdj?=
 =?us-ascii?Q?+eXeoIGvSDoCCMXLs5Rwygt2g8ZkRc4+4klvkL8bfKKny+TH0Ug6MFkiyHh6?=
 =?us-ascii?Q?jMFswFYPr3E/v2IUOzdnWRVxrqeKtXjIyz0w8eM8PZaAuvidTi8ta9do0J03?=
 =?us-ascii?Q?yjuG26P+56a6bve2xVYxdIe5BUJc5EUOnof4jz/dq9BXe8rUSdQ+NdpYwI6Y?=
 =?us-ascii?Q?kBavjuFYF6xascWff3u+1CrvzJSQmxCqWl84g2muECWRXXjpRLWNL9pOevMF?=
 =?us-ascii?Q?Tm8UxE81SRJejOEzpH1pmE0bWzqYaJ7l2imPLGhusi+WRHMnXuV9bqgA1mHV?=
 =?us-ascii?Q?7vtKf/J6LdxsZsCCas5NucMAoFKd8J6GPXNFkbSvRBcDd3cYUM/M7dVAoip3?=
 =?us-ascii?Q?/v3665BC1R/9M9dRxt/pA6QsPsSBgdZoaPRP4jo+fUdSVMPsUcZfskNZDZbG?=
 =?us-ascii?Q?9KGIouDSaEs71JYzUXOW0MfEwwHlKPW6js9QznwEdj6DQbalsSk3LBmbXZLd?=
 =?us-ascii?Q?/k/AU97R6P2VBeSb5mkcegvtxGx9cZ5fV1kLhu031JWiSrj+CCpdKqSN6j+o?=
 =?us-ascii?Q?odvOqOMV1kFrNPzfAe7Ww/HWE6HaNu0W+Fh3y2lAs+xg5XkzWu+xx3NMrsE0?=
 =?us-ascii?Q?b9X//5qmcbf/4R13xzHIUjqs59+JVI0OPwGnLYLDDUiOsslvso4kzSslElYW?=
 =?us-ascii?Q?D/C+WVnwka+Gviw3KN6udfQJtXuAf89KkrAUt7iHKdkpl/TNJ7yKQLCTOnbs?=
 =?us-ascii?Q?4uDzf/iZA2bddH0yVTVzr0UIy9y4H1LSZWUaSsTDgHMhRzKUxk1DuGYiR0Qt?=
 =?us-ascii?Q?WjG/HwuVpi6657/MahFBH7rIQPgVaaf0Jn1kQj4OPfvuJHrZVAd9YYguprSb?=
 =?us-ascii?Q?JtuWsMNyPBg1OGPtVl/FXlYjnaCMnnuxjKaHvgud2+Sh2bweuSYGinZXgjBg?=
 =?us-ascii?Q?GC7LJJ4bIkS9TFre5TU7lxVgGqfBktlUE6NbSd3fLr89hbcT5Lx88B5NvF/I?=
 =?us-ascii?Q?+9OPXTMnhpZ8y+ilUVHNk36cywii/swr914g4Gw4KzPvgJaYjZftJ5nE4Hnf?=
 =?us-ascii?Q?v876jdEpqVv7ioqKrd6BCAdAi2nZ6VGTfU4Dz0OdGQidZaWEj2gujtZs+5Jd?=
 =?us-ascii?Q?OKQS/jQBL2Y9k8xGOg0jojqhYEuHgC4=3D?=
X-Exchange-RoutingPolicyChecked:
	oGsK4jxR8eQX8SfGZknU09430sgjwmm1lbZGYJOkRCqbWndYIBzpvoJXxeWH1hCPjf34AfxIa1mzbSP8K2Jmg3ZsSH1tjHwEmk7ymXDAlNf+wkkMOAS2x9zZHbxkMp/xb9XeKgobz9NdenWOLyvaML/9gRgNgtgpjEyH8OcE5WMk1Lg1NR19ZgvbP6c3R/LqOawXEbzE9ceatfbw97a/pA8C6dCHkj4ZNTed3LOQhukzlfrbjdshQM0jXKFey+HS3w3nWv9Iu11SohgbUZijIBmK8rvWeTxjBG7aL6+WkmsoAahW7SLTuxzUPMu1uw6Ea6u4/tBfxB86Yan368GMyA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pbf6wcPcv5lIFovgWhrB6XPZ0zkPCtgOAIGFo6yTE9hugwgHi/Y6KbRvP/NkcAGPmEO5C/4m2Ma/3Yxlt/jxyUJKAPmoSzkDBzRvWLHy6UEwJvc+L+n1ecFUEXmMfc+tn+j3XpbpFmPbF73ddHPiSNIyHzkWcPLZmCdFI+F1QJTnpKbun7YYi0HMM2D9O5mo5kcJ4xwq1gLhMYby1J3C0Z8RxnN6IIqKLvezXMSoYaSWJ9NqZlNKvpr50CC4wrbWthNs1HqVdyv1HPTX5PUIdQzPc0Eyb8QsNdZq/w+yXFXsOh20YnLC1YH1tgD0IGNoZPbnmC2mdPjsm6gcZSx0KMrji4Dda/8bErmPcp5bj6aiyk9JMJXLbcaXj+d/FIg+HMxyrJ1fxkBpDE6kvDxA22Kq+a5mR1Z0OWECGCcW2+UTnT/rRS1vBRoeSftyKrh5wSg0ytY0pR9Hzw6fBw//qIAHYwcammoc2HGhnKSPH4etA+gR/N3TZQ7jqK5VfDpSjG9zXYrdaaDTIGeLRWuAY2+8JmQZmtdBvSyG8p04BpuvVKRQ71kKS3mz7sWu6pXRuj84Fh7aAeqfjGtFwoVRxGC/tQ8LOjQbIm3huFFgc18=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a2da33-dbb1-433a-233c-08de9122e0b8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:46:51.9819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkiVKfEcfN3zOrw8WaxzvKT77+JJ9QDUkNqnR5vndIVTVqPc+Sb2ynfJIlhFeOeKnxVb1HrULAeU//EqNk/mEUTmuVfVlzucPPdQrtuiC4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604030014
X-Authority-Analysis: v=2.4 cv=IPwPywvG c=1 sm=1 tr=0 ts=69cf1c10 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=Ym7BrytTJpxj68NhldQA:9
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13825
X-Proofpoint-ORIG-GUID: wkPK3F6CdxcnPPPo_9daoMQlgacdEgY2
X-Proofpoint-GUID: wkPK3F6CdxcnPPPo_9daoMQlgacdEgY2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNCBTYWx0ZWRfXxLaobuIHK88o
 TNc2AosX5SBJVO5W36tGIf+GeA7opK31pQJj69H81wl/MD69M/3+nOl37eQjXIaH9xVmepEMWfF
 l6OvgbW8N5mQVlzIGX5LtJxecvBydyHnmWYpDqS8tYdlLoG6t3o+xlvQcuEBFqeyq+tKcAp/IdD
 gUq9c81ohXx3IVreskPlqUjzdzjZvda/VV/JBalSa3xT4xZ7GB/hOtNn1aTyq+whpkElmolmPTZ
 T64Qej5XU3BbEM9LLEM22hq1sdLx3u0TXUDtnXN2Al5K7V2ZF9+VLz9ns7kcZNOG3Of29Wy/gbv
 4JenrjGCXC/t70i4RzFWBxzsKs0hvV0UT3b+ffkSwWpbN/R0SN/MLEWaOVGEBlsfKWkoMhRmb1L
 /dJxG9HybYsqiSSrrrqUQA2rgAyWrDSmsAOtMKMMFX3oY3jQzJag+clBp+wPS0ARHYG+HkD3iJ3
 6WSNoYJnZoUrBRrmQGE2afI4NtyLMMqS0fvat6PM=


Aaron,

> Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
> constraints provided by the block layer. This allows the SCSI drivers
> to avoid assigning interrupts to CPUs that the block layer has
> excluded (e.g., isolated CPUs).
>
> Only convert drivers which are already using the
> pci_alloc_irq_vectors_affinity with the PCI_IRQ_AFFINITY flag set.
> Because these drivers are enabled to let the IRQ core code to
> set the affinity. Also don't update qla2xxx because the nvme-fabrics
> code is not ready yet.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
