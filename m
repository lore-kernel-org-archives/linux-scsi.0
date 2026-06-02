Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB621F2380;
	Tue,  2 Jun 2026 01:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365354; cv=fail; b=iV/ASJD0Rz4SgEnWHCoD5m+dVYScvd2KF5+z95WIES8dZBPEPRAxZSMDNu63OvlcOUipO5vpCbP+fqLhPoF0pTAtIOwos9rjEa8YV42APWSMEdY9CQ/QHCSmmnteWeOBr053/PGrvJQkJTraG5VT2OQ1xvBd2TgAvQPYM1Vt/K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365354; c=relaxed/simple;
	bh=wRLg/XzAxSJELe6vrui364sGT+d+2l9jlRr6xYQSDZs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZdxYUgFZSJE1uCC9hyCd87C4FflLUpvHkiXCjOvyV6KZ7OG/mnajRRZRLL/+YmHXQtXaPIc+pJk9HPrBMf1fOSyvScobnJTYeHdyTAawnnbE1LHHbI06DUdwFF77fqLNvGKY4Bk7o76OksYVUfWWe+xYHaD4M6hbXK9l7QTsCNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R4AlsF4A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cod8He3N; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R4AlsF4A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cod8He3N"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651GtUlF3106767;
	Tue, 2 Jun 2026 01:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=N/mRKfmFuMSJYkhLla
	A4dZCh/98Jhd+QMDrKOZ2IJss=; b=R4AlsF4AZOUAdvpvqJMIRQWgwbOMnDz08E
	NlQeJGz7Csb7sfrTSmz6LLcoK5T2TBGf0R8Q0vIBgaonRNd3OoaqduJk6caofkg1
	5IZo9i7n9hPqhs/BV7kteR3PoZlwSwlSNdVsBnckmYgwk3JCTTUHNTKcL+ePB8TR
	2spScld45k8oiNoKZrHpFm/dTi/vbL+BMR/WzklEnANTDywwixsPVpPwLKuHE1rW
	IC9oyZtvYAjskVcj6G+w+Bc+VRA1AjOUMe7AUim3yiJWS/94Fxyk1uQUe9GfEgnv
	vC432W9u/u3RsHBChFmeUqD17wBxBq4EKXCiJ+yQirTCGLlyoZfQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpfxu901-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:55:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521tdlU022168;
	Tue, 2 Jun 2026 01:55:44 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbq36eg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:55:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=htbl/5bDITPnsqwL8PV8vB9jmhvFOHeyqE/SxU469rNZGfxz6U27QU5Ys8dOMPROrkX98dlSUy7QoFVBCvmyrkAAggEIJM3hx4hi3/HNJ6W9+3p9kbKuIXQzlAF53JBFSb2TOqblpmrQef3AH3QFGO7i1z1vHgCOxwbilxCIRhAp6PyBtBBH5/IRDbrYWDu4FpUcBa46wFUEMDgS3o7OVk5tmkg4yMVvuf+tcsq8EtXqDPUAUzuUTUZcezl8lLf5LzgPJb0sqhzAaCC5E/t4fuMo0y/a9Bjt762X7YoBuv50ufZvf9GsdhFUci0pTcUyJNEuTYo2Sgo7oUpH27O8IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/mRKfmFuMSJYkhLlaA4dZCh/98Jhd+QMDrKOZ2IJss=;
 b=spiMGlv5R4jW6Ikj2uQGCst6+PbrAnyFBdWOMi99fhEOfIOxkupJJzZ+IgoA2T7aK1fqzAKPUSfz7ocR1uOBzY7KQmnFQjvEw3ih6jldq4TH6XBvgqZWhMpPw+7q4Zb43mpSTK9wXWxD3rYxavPsXKigbbazzJG52R8F4q0OCIQp2kHW5j+DLFiFUa0znXiy6eH1zAnzZ78wFqX84aFR5Q58lpsiGRJjN3jVHsweXDEq0+CQt3BlLShNKIiR+6p+DAJOvbLtcsOmik7YVkdKM+12XSxJbDn/YBh0crqHegrNEgqwIwTTrQUE7NcHyQ5l3/O5L30+5izBM3UCirLi+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/mRKfmFuMSJYkhLlaA4dZCh/98Jhd+QMDrKOZ2IJss=;
 b=Cod8He3Nv+f3Nd5YiDQjVedn1XkPsPmbRbM1ugMFI8f1ugi2/Al6U35ucgoG5/A+aqJC1LGCskhK5Pm7K+gF5VP7TD8octFNKV4nIQEieG/Fek05+1kgJzSVw2gUr8lSQrMTDFpVRjCkZrkUfdo8xBFqusRgwQ4BUOrReC2vyqI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6729.namprd10.prod.outlook.com (2603:10b6:930:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:55:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:55:35 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Dan
 Carpenter <error27@gmail.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_mbox: avoid double kfree()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260601210216.846809-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Mon, 1 Jun 2026 23:02:04 +0200")
Organization: Oracle
Message-ID: <yq1tsrl904u.fsf@ca-mkp.ca.oracle.com>
References: <20260601210216.846809-1-arnd@kernel.org>
Date: Mon, 01 Jun 2026 21:55:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: a3e4d9fd-b03e-4bc3-b81a-08dec04a09af
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 F7gVff0PFkwpvp7iP+CYuuEnfo/AAr1r8wo7XASMv5u5MA3EhUrZX9+CEsBia9EsONx/W0H7+hWoU3uKJsbzJtW/0sQNnsmpnW+57GCF3/08rRffCdiipI/70IDb1iy1Jsg9GW8HAi3/H201RTJ1bc8fG4FvWGQ44lXN4hhz9UIe33hrH4qqyUbZh+dhRBVQm6KWznq21ugAZ6vLwVyrskRAbZjs5jbbci0PGNddl1FnFETlWRt3XdleUMB8MVg+AoiwdFoPYuldLS1PvSUd/CcQlph7UE1RW+KVjwTXWxTUxjd7YMY4qwJ6VRKMvaiH7up0hmZjYljk9Y+Y84XyoKk4TT16j01Nm41295v5sevO/oA73uVukEsDyIqlsU9UURYzO4TXGsMkcOgpT8hycP0oUYuIug/P2B4E2r9bF1EHjPtsLZWKzGJTZ/k0fC2plraWbkUGC8uOjw1Y8hjFS6S7a/nuENbot4uaEnLgeOXxV/5Pzl3iUxg8YQTp0YHVf51TuZSJZXADRTc94qm4V5cdutrwDYF6S0sJS6qG50yWNHVLXMjo2IhyCJMft1nDaRo1REglGiuvai0ciOjT8Hfk34rhO9nqo6564TM2mqwKDbDwKjrDOCKVdvOJOw1EXFPUGGviE4YxRI+AZMmansCtVRO4hiT2rL4Lh6qLSWkFN64QNVNJMN9i5Liy8OmG
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?8XLC9Ly8SfJw/2Z63Vd3fyI76CAg2XV6yplELwGEKaHTr90S34AlcTbU249c?=
 =?us-ascii?Q?C+trS5I7mZLD+yppQjOR0rNhaKyj3ezFwKqe55URL5uLvuBuUYRsbWppNYP7?=
 =?us-ascii?Q?+HLWR/SMKcq+QU5Kvnc3fmz55uJv52dbbg1NQ+zE9xvmG4nTzAvaz3SjZT8G?=
 =?us-ascii?Q?IJTxvQcQdMlmAH4wEyWPA+l1XcFxV3gV4AC8DHjDo68bzMKTswJecef6VvtW?=
 =?us-ascii?Q?qywVSE8Ip602Ryr8oCk81WQyOgeQ2pnGiz/1R8+pEFuxBHjG9lNxHMWb/slu?=
 =?us-ascii?Q?IsUVEH50txdynz1vmQPo+DHODkrh8jZvk2kOaRCwCN9BvHoOzL8Ivlpa8OFk?=
 =?us-ascii?Q?vm4vpmkZOBML0/fzuEdhTQrsSx0/0g+W5rkkVieHanO0e4hzeg06rPrtpqcR?=
 =?us-ascii?Q?SabGqDSICibmLTfOtdi38lom5+dkLQEigyzkh5urABCF8u22nJrP+FHBzhNm?=
 =?us-ascii?Q?O3HvB1L9aVABsn5SJM1FLO8Qgs0Bsfr7u0LTtpM0LWBcIYBX8bJbG6oRiWos?=
 =?us-ascii?Q?DwW0YTuDf/++EPjcDsXLKMH8BystpEVxf95C5SxjhwMdXtR6iw4leaIAFZ4Q?=
 =?us-ascii?Q?8eoVaRS+kBOxQDZy2AAmRqVzs9FT7rEj9cQGBOyEtpyI2wTg6D8lKhDAkcAf?=
 =?us-ascii?Q?kEuPWFG3UHc/9FRoj7Wt+E9onBw2GUVi5A/n6KSnH30o8/vZ/0JPo3IPQH+y?=
 =?us-ascii?Q?GDjrYLkcwa2MfyZxStQFUr5FEmTxRjoiWlNlnat42fjik+wDRY3+mWSgfB+6?=
 =?us-ascii?Q?D2peldL3do9s02sijSMD3ldWgvf2sCxGtx7x3pY/H0Uw5lCwjHQiii3fZ6y/?=
 =?us-ascii?Q?ufu/jXeJtGKiZtSfUNrEKZ0wXVaKFWc0dzIKpUrVbOQm9RhaZWIoyE8/wOLI?=
 =?us-ascii?Q?1K71y20lcmuWsn58pXwONScpMqsgVFKIvKQC+dtCvqQbFfDl4KJtgOcO3mmK?=
 =?us-ascii?Q?PnuRPuhV8T5xrJoeaVpQuRNoCIqOh7/SX2unMiIETZ2yxvjc1i1bZF7HpiLJ?=
 =?us-ascii?Q?mdij1W9Zzo+PdLgoGzn11Pb3NVeztFQYjBH6LdUgqJBb7wm9vQNYjU7jhGRe?=
 =?us-ascii?Q?VU7o7bNclZ9ib5YxOVmTxi83rXcom9ffIpdZ/wXGCWWZiKB/3C6HScDBM2oI?=
 =?us-ascii?Q?CiM8xdq43iVjh2P/9FeHjEfciKhNF4yNBvDTKY4F1UIACGtYrS9J758v1fRY?=
 =?us-ascii?Q?FoYErccuQ1y+81g7UswsSnJ0SCeBybm0m4eFE6SPzxElSJl0WiwAbUisBRVg?=
 =?us-ascii?Q?1s2PQVieHU3u7BE8nRa9RCmo9zSbGUCH512EWtXuaWATC3XgKabyAan3wePd?=
 =?us-ascii?Q?bf2WXuwj0G7iSHbJ1qRj/uGAPpcImx7vtKmUEidr/iVBq10bZ8Y8P6BuBYMW?=
 =?us-ascii?Q?bEKGpXJBLW87vZJ4QXQcnV57bnzzWYMnkB/eTYr1IFvm13xHnqh3TVAsp8Jb?=
 =?us-ascii?Q?Jo3Yjp9ly7P7Oh6r+D1bucx4VLE4plaVJyAvCSO87otI7b50l+LiCb7MuNRb?=
 =?us-ascii?Q?AeP/kY+xAId/GQBKEvYtQ4UhLeQO9sS+36my8JHriX1VPH08SDw9hHyFsMZH?=
 =?us-ascii?Q?vIxhOiqBS6adQc46i4ttzNKFMiXc9eMjPXrFlvh7oBqQqOL3BbgCsL7DqIAe?=
 =?us-ascii?Q?33kuGIiwG5KIAzOv5gYl9/IWr+AGY9an6cP1rM+W+zu1i4aBsG5Z2SedR/2x?=
 =?us-ascii?Q?CblbwoL/2bYwhMPoNZD8eC5lNjmH9rAJju3S9z5LyAucheugWMHO2J2znGW6?=
 =?us-ascii?Q?SFJtXOKW1Pp4zS7mYOJQMzOAanNnFI8=3D?=
X-Exchange-RoutingPolicyChecked:
	Z1XBRK/cX3w7E3P8jXQEN48L7BAkwMidTbOcy6s9BNrIkZ8lb1tpCvnD0bccGX5QYmmUWkx13WD6+QnjuIDN7xpCTUkrxnUbcsNTqPeK44/BpnMYUEssjK7aKpkk6FL7mVkO95KZ6hx0mSOhDKVd+aEwwHk2MNVXN0s6r/jlmQmTGDUaRxa4cMjcGQLxs2Lc/yFOCYeYNJS8ls+cvMo2IbgAhIVtKfjNuhbqWq9eJ9SX5htpWX6V9XCHtqUTEBd0nXb/EpnXvvXzj4lcYPshAmBpK4X+6GG0N97vYrPyqByHbFur3dFiJKD69Xc81o7z/t2ZfAqRgWDs217/dkXDpA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aqpH1kACtlmrQA8eWTU1xS1zDM157/u5oMVDzkyn9IFH7+wz9KnYvNVDFl+rVtz1pOua2G4aj3JPV68PmVpRfDhioonm8AOAwfxjmbSBsHR2rBDJt+vBi0dO7EQxQO2gL5LMBMmzgQrOptujq79rRZYsnmAS9BqZEn4OoyHEFwj/0ysp1pxV3r4/RNPGbMC46tXsQEypHWt/qAhxsXMrVcWdV10iHsGflCFX60BYW0xtx+Jgp4uXlBCJoHHqMgxuqw5IwPdMaXu9loH+40XvON9wHM7FUzNOFoJWzzHgz4tFG+TuCVKEZr2Eq0ZU8WIB6EEcsTB84OTkyrHVnVlpmVJ6HTrEsw2+S/YHzAht6siCHDu1//ffdeG6Kj2LeJpcl8EGaqV3bgM55xYK8fFuRQjUcG5K5YG/+fqIfSG/cl+ZdmYzz1Tultex0d0OLiX3I+ZQpGjQIQQLBDFnZ+4fB+ZaFJEfTbw4eZU80dPK4O5wZ982vjWP0FDxHTR5W+6lNDH9bJe4VsL8GmSYzvuYa0qr2LRp316L/ceBdeD7xZHGsBKllleHjHJMLfi017ITASXJQ845sEfkTweP4IdSyPTIeG22TwMOmIBaOiE3h8w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e4d9fd-b03e-4bc3-b81a-08dec04a09af
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:55:35.7438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZJwiTMnQ3Curtpp0QcEqgOQSxVJz51Jf/h1T5XEcj0zChH9e+L0cDV9he5fHIgZ4djyigdYTCl8yd3s46Z4+k8qaExU2798qkPdiGTgUok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=671 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020016
X-Authority-Analysis: v=2.4 cv=FOMrAeos c=1 sm=1 tr=0 ts=6a1e3822 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=DMx1oP9MIIDwXaO-esIA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12302
X-Proofpoint-GUID: vL8wukPzppjXfgZCfZoQT5upMCgOg9an
X-Proofpoint-ORIG-GUID: vL8wukPzppjXfgZCfZoQT5upMCgOg9an
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNiBTYWx0ZWRfX2K2BO2zjV+45
 TgtHBwuxCAPxxZlQX2tlu6br62CRx0jaPY23bGWold2JgCh7fJxjNFfWHBWgNK7X5DoAERMC81s
 QoCaFKirzfRF77ld/qB2XTU52MLcJ6Zk14w3mXrX9GIvPPTaPj11p5Ds6r1yO6IMvuhKLDFnJPa
 tmkddpWpP/c8IN6T956oOugbONIR/FA936VWez0yM4FBh6KQ95zkJA/vbNdF+t+IdvzmtdBdGBA
 fiIBPHjDMIS+97uPXrknYBwxdtOgk5VuXI9wV2B/2FF5vzWvn+pconM5l6EFgGbsw3U/WcUuy2D
 nr8cG09y4pB17F9VC5sbwsynMEwbMKEOUGp0IOuga/bWshFVXtwB3PGqrauefppP4TAtIgl2mtJ
 UrVb94kfENkm1wqtmfwyKqV/f0RgqRncbeo01+YXOl04HE4gUm4e9Ko8XLSQeMkt8Kqn0EA1doF
 YeUF7La8c4EDJohKDI7Jd5JvHfpkmGUjaW9X95GI=


Arnd,

> Smatch found a double-free after my recent change:
>
> 	drivers/scsi/megaraid/megaraid_mbox.c:3474 megaraid_cmm_register()
> 	error: double free of 'adp' (line 3468)
>
> Since the object is no longer allocated in megaraid_cmm_register(),
> remove the kfree() as well.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
