Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02F8223DE7;
	Wed, 21 May 2025 02:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747793142; cv=fail; b=iVNmsA8M0TBBZlM0bULQy4/CkuMcIXsKJGGpN3LprlBHMA8PcyJisbqHzaRZrI1SrSHa4xC3wIBtEQ6XLFFAQfUiCxadulE7efW7P5IprkyeJ/k1mWM+5mSg1Obyxii7igb8hUSx/T0v7ShajmJMI4ypwgcb4ButdPf69rAgu1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747793142; c=relaxed/simple;
	bh=x/13B6Tu/+1lDbnVXFwLXvIaukoO3IRxhgN0PRX7qCc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sO8kB+hpDEqFPPTuxPyLsrwRLqdQO7Ew6+E8rehk7xCwDS4f+QDvFF84T0EML1c5JTxaHS8vYU1uX+u6TAdl/dyV2hA8mJGjXVCInCHUR6Szx19gokMi1luMzZbrKJ34W+9/RrzQ/wnz9Q76iWAye5kcEDhIVR7QYJCuGOBZ89Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I1kXmwZe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bttiNgdh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I1kXmwZe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bttiNgdh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1aFvl010540;
	Wed, 21 May 2025 02:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CE4o0BthoOa2g32WJO
	kvCkLKkqSi4Rnn595sh5z6Y8Y=; b=I1kXmwZeoRon4oGi4XPU9yOihWzfZ73dk/
	l+BHWJKQY8QiMJZjb10WHaWiuRBeWly9WWtkbXdfF97F3tr09VU0oDQngT24qj+v
	95af0hOBefvYVpKaWdqJq/bWblSV4yq+iQgfhujOAm4X9zMvikDTweLxKFYHkV9k
	1kd+Wk+rC/Y0QZ/IdrZeJeG31Ew0QbSQu6QcYo//5ZOc40gd1b+WwRqsZjQW2wo1
	jcRlJGho/r2+Fa2dG+NpVFwZjQbJYZwPyfGl4kTp4H7dn11YxQ6QW+XbJW1PJGuA
	NqUgVizEbyN7X2pCbfsDB4nHhUuPrNhcLrGnhPpzPlXl+DQVR0QQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s53tg31m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:05:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L23nZ3040718;
	Wed, 21 May 2025 02:05:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwet91ku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:05:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnaqg3cw103tSZsYbiYLV1c7KM6+BpXFMjTps2ecurjy4ZImOlikjaXnvRWabbhvI/4QXjNU42S0HwvDf0T4QeHl5TCsSFExCZSHvxDJwUwlfv56i9+vstC5E15T+aBL+vQLhoifiTgF3ShKY1g2EfO9XQU3/qLW/ClKP5mpliJgkYERfxFtgLM+EaqXMxANOI7R4d6GPqo4+n8CNqjG9IPqJDqa0c+sGkZCP3QVqFNlMse/eDjVAC8pVXcnXcIuHEsEd2Z41QX6IQHYRq2kiMTu8iEMunH8G/Zt1hv0MIluetnT91ZOmI8BrK6inQqfeU/ZLxuhW5X6zoHvhRdhBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CE4o0BthoOa2g32WJOkvCkLKkqSi4Rnn595sh5z6Y8Y=;
 b=nMEA2ELXyuVjBEoG+ns87f4DFEwowom4gTXRBxaDFIalNFde/8jC+qD9Z6Tr7jUWCohMTpIL7VA0c8TcY74pfvjgJeY5Mpdzx0Os1gFMltUqLr8Y8eAZpIkvEEv96xK3ahDTvzh0BJElGMA7DjVtEI3s9NP8TJ0L6CtV54aKFT0Lld6JVbXyzAV71H6VUMkqY1TUNuZntv7taAE1qNFSAkMFUYvxdZrMpk78fEgFZYpgUDgxb1BOr92tNJvgjy1s0Kq+0f7tzNvlJiQ7kxfa0ihIjdXT/og1AZh8fKjdu+cTpYpkozyg1f1+ABXGDrfsZ3RK25izLGLs2XmpuV9JAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CE4o0BthoOa2g32WJOkvCkLKkqSi4Rnn595sh5z6Y8Y=;
 b=bttiNgdhxhm9wPeuxnXTLRK8Alg3Ln5nPzAJovFHO+15+h2QpUDcoRSoRr5ern5H6AyZoxRkvFsJHGMt0DW+auM8v7y4mLCGIJpijLqkgTHzuZ/xMiy2ryVcsEAQ3sBDbyVX4ytH6mQiDdxQ8eeagk+AUHunN/xlXOe9HssAT2Y=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8347.namprd10.prod.outlook.com (2603:10b6:208:57d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Wed, 21 May
 2025 02:05:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 02:05:22 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liuyonglong@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: Re: [PATCH] scsi: hisi_sas: Fix warning detected by sparse
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250515013504.3234016-1-liyihang9@huawei.com> (Yihang Li's
	message of "Thu, 15 May 2025 09:35:04 +0800")
Organization: Oracle Corporation
Message-ID: <yq1zff6k9ba.fsf@ca-mkp.ca.oracle.com>
References: <20250515013504.3234016-1-liyihang9@huawei.com>
Date: Tue, 20 May 2025 22:05:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0186.namprd05.prod.outlook.com
 (2603:10b6:a03:330::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 10f1790e-6440-4ec9-d3b0-08dd980bf18f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NMjCq+ZYxtCFBWrvFonwSj6mqD4bvfN03NpWZAg5yNPXnhszIwxvJD+yfexF?=
 =?us-ascii?Q?qLLsjTboO79g/rgUAzUCDbvw5jHBb4dm6SCJic1P/uB2hMbMSLmTF1a1jn+E?=
 =?us-ascii?Q?yhSiOmnopydGn3eSo9NImpjtZp0+9APA4NP1RJCtbaneR0KMgLm1FuzLaqso?=
 =?us-ascii?Q?o+7wnRCawa0fp+R7/rEkHVqHQ3Dt6pnjimHZmP9M73EREWVSrVkN/chyi6J/?=
 =?us-ascii?Q?TWyL8Vcu9+64TZKjgRCWD1y4wUYGc0fYPL+ZT2L9cHWlQyLYzUraHgY5UMZr?=
 =?us-ascii?Q?0Iyj5UApBiJAIOsFnfEgZDHJOUF8lLZiIVCdo9aFsMmDZpQGt8eHaiuPuohn?=
 =?us-ascii?Q?4zPo81UvAEEEda0b7MJZUEiYWFfBbk1ekpGX5NIlitER+9W8vTDF1h0p91pl?=
 =?us-ascii?Q?El2R+vacqJVEBvYweOUX8IZ1Brwm03yV8iI7SqVxVSTQer3GSdUzx7q7Hi1K?=
 =?us-ascii?Q?IQdMJgSwZhMyunu2oX+RORiGJr2xgElU+xyCIFKmZwUnp8myGSC2ahkeaySb?=
 =?us-ascii?Q?Ia+BmV0pEScw+GEsAJwWMvF/1+DF/WJMqem+o/8200IK2ZE/IcPkwgSqoysp?=
 =?us-ascii?Q?uVGQggOpfCMaZKrPm+pFsoDgsaG8I3VPM8wfGYiVls7PlJkWMR5dZFMB7qNJ?=
 =?us-ascii?Q?POe/9kn9VV9QxMhsikJlMw2yWc2+wLdBtkKUcriVU2D+7wjcyEI3nsoxAGCH?=
 =?us-ascii?Q?w25PMIGv17AGDzc7MrBdi6Fd6FLHPb5SlYqGGYlVNHXx5eAUU1iaO/es7+Tx?=
 =?us-ascii?Q?IAuGoKbXWqHyicLcKCcNQZ52kSfeQ8ZitdWuT6L5hfqrTYjnILBpAze++BE2?=
 =?us-ascii?Q?Iw6GyWB4yuSb2BykDZdptoACufycoxIhWcaS223oAvDueHrF6r/0/RV+2fRB?=
 =?us-ascii?Q?cBYDhGh+94qlyQHOhi85H2fHkrQNBUWymaajqa9cWrzLYGzac3VcA7eS1k4y?=
 =?us-ascii?Q?HuJuAwbXYnV9leziTHC5QWVshqHESZAV4+8/th681+kLTkpNwtetoaMzzDUw?=
 =?us-ascii?Q?SHuWMIOhCG6cDKEBJjcG7QctSeR6PcLuFTuUGq+arYRkzN4uhrxJxpT6zeNo?=
 =?us-ascii?Q?hb8Xe8dMKyqvVmZ66MZ6B7gsY4MmMV8UhFhfTzy/WG2ET/Gbe5sIYDhg4acp?=
 =?us-ascii?Q?glveLosurXZm967meHH1V3rAXz4EL7KMzf61+39kQNPvHAF53aFbFeFkfwMK?=
 =?us-ascii?Q?D/CdtIIH4wjEclPWjRGgFzA+R85shJKSPxkRZ54czvSvuaJPx/XRfWeh3+yl?=
 =?us-ascii?Q?VZdqWYVW/DG6t6HKmP2EIuavRqwEz/BJtamNj3w76jk68viJ/Gh+Rx8MkrkC?=
 =?us-ascii?Q?3i8QpGyBG1DjG4MHf50i+2+Lk5UPFqRaauFwovO8W+iHPw06kl04jExosRxU?=
 =?us-ascii?Q?d0ECLT0g5l2fG8OvV88ulzB3wFbCXg6Gyf7v8cV/yKz6KrECOC43AArOsOPo?=
 =?us-ascii?Q?QnTH8WTW7yU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hHzKFQ3XpP7+eG7kM3ZNf5s/7waPwdTW9tlGqlQTQe75uiA56mUEvHDgq+9c?=
 =?us-ascii?Q?+HfbnziKKP0lxINMUieFis5kGG0vy6CrUKs+scb71W9gR5wITv6iC+vZpbWA?=
 =?us-ascii?Q?kCJ8AJYX6EntTdxaLlEPiOJIfT1Cij5Qi27Iw1ssU8TRNkJMPIHnGU6X7RrI?=
 =?us-ascii?Q?8pAnTZ8ET1gtbjBJlg3pgKSxyUR+o/Q4QuFUCBWNDstaJsV89ddj4H4TL0Zi?=
 =?us-ascii?Q?HzUUWrLqRNjDWHTzitr6WijGSSkA5VQd+XBJQxE0KQGJMlO8h1WTOOCqBgzO?=
 =?us-ascii?Q?K5sIJYPvP8i1QAjlnjnI/X5c1sM6JONRRBp0qVJPo8/gp5NPposXhsTaLY7l?=
 =?us-ascii?Q?s9XFlkxNrlAjYSM00XwT968zTH1iZL/zGqYnqYi/nKTgn8UfRpOduee8+Evm?=
 =?us-ascii?Q?zCn2gyaH/MPEeywqSXMCb9sJfJttl0P3jjZJyjJuCdFP5IsKs6XQ0yQwYVbO?=
 =?us-ascii?Q?DSJ13sab1m15nbicZdrylmzIMfDuRFnq7tcQPOYLI8tGItCi3IrY2UspiNH2?=
 =?us-ascii?Q?wAOr02MgiAMOnY0G8wDEbTSNPhZVcVg5JUuKlIzJfSxbB5JbEQOj6G7vjT22?=
 =?us-ascii?Q?X+HOVSs792//5ge0XTIlDirnd8/Tw3G6/4mzS0SsDXnCSKAcszjMORY04OjF?=
 =?us-ascii?Q?eG9qlBgmaRozPBNlR0b2V4vipzlhWD5K3fYpQQsESQ1tLqjtQ8z5lc77X+0F?=
 =?us-ascii?Q?DAaE1FhH+CZdJGStX8uK2ZxXsmgGULOe/kuXOBIGNDLv1ixlZxNyafkvCVrj?=
 =?us-ascii?Q?kOBfP8ZLvcL2OMFNzEj/qLE85FAQg7z0DXkcYboxb1MFLN+/BuNMRWeJ1353?=
 =?us-ascii?Q?blBgOG9zRdEU/cqImkxMoTU4vdaSK4McD5BLHNaSK7sE6cg5/gvkaC6/Fl4s?=
 =?us-ascii?Q?4LT8zD4otbsZlWhsnmLXZata3w0HVmDC8XtKA9OGaOVT46G/yP5aRLH4NnG3?=
 =?us-ascii?Q?IX9+tZrYYfX8KOsxNTZ9EV4pDZgi2e00aX1Wya7cs+++Fb/oBrMop6L4j9mb?=
 =?us-ascii?Q?yNkH+fWjQUa9cyfJefVQ1y6bIEDV1Hp/ydr1Zzuze8aCXunWHdKITELFXgfe?=
 =?us-ascii?Q?ZkVoHEf5u/rmr8N/bhwhwKQnWeftbAKbv9y8KZ1rebaby5iBxIyCJutzN/Mu?=
 =?us-ascii?Q?hdusTV+TQ6jITvxoAlpm1eP9h0Bl5vfKvinDAMGZ1yI3lg8TICxAIlKs7QXr?=
 =?us-ascii?Q?xA/YEPIvFYWqfcTn2kCzB7e0FJY4xlDCdpg/44zUGKRJuVKSMHW/XgAB7B6q?=
 =?us-ascii?Q?Sb3CLQ1mXINXNY152FMhlrAag75aMvwajxliaUpAplfMKbrLnx1p974Xi89o?=
 =?us-ascii?Q?t4wnx3vc8y/ory4x9Mi5DME3dr5cRBQEtCx/zhVzmmyV18eEUKjQK7L99EnS?=
 =?us-ascii?Q?sQnJi0ZRSBabFAZuA1GP7zyvfpVTn6XBnEHXBxagXYVQZdHYRLvX5THT3tLb?=
 =?us-ascii?Q?J0riIhbUeyownQdAVI5xaH1bcyWAOyQC+6fsIOO+rxniDzh1PEADfxMZB5HO?=
 =?us-ascii?Q?npAiuvAh5cfaOn9eHEr2aMTej3nDL1zNMjKA61F2cTexX6HygSr44mCutMI0?=
 =?us-ascii?Q?D7fwCfLZKTafitTDozoqExTW90HoRnDEQqGEt0+z3GeZ/UzRO+rpV7mXn87p?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uKNqFSDGH3rkCsCxiZH0zneb+de26AnYm5RueBuFNlN9ahHTJkz3wlnnsl+xBAJiIOPPE6mED1H7VYdrLttBFFqACSlCSm12+Y5WS7ZAAdYUFrh0GnpKRc89BFpY0RkKm8DQ3TGmqG9hRK6CbWLZf+lZ40/qqn4kZQEM0xXMTD1SPo+ucX/8M4f2VBnFVbAICM9dUG8eKYrjWDSVifUsD5poHrKnPJt2+D1yeQkSq2a1Q5QUEU1tRsiN+/aioOmCfP5WzR4Rluy1j25pWSAS05srIwNW5Je9MF++II2wQyHWoK+qxgWOeK6oEDmk8Ia/gfltd4uMagC9S2ZppSix0NJ2Hndo76yYjcITJQ1rQCE6Q1PpPs5dD4schN8MBZc//ev32XRj/ltwTTuh9saET+QsP5mWCwP61eklyzrtV8M5M7RVC1H5fH1cCG+m4apwg3VnrugW/0v5cAwdYyL39yMxpzOltmLOceXp1Z0IFO+lZIZaF5OdI0ARTnTCmabW5f5KJAL9uzFeIeq6xtEfSms3CpKKppFEAWNIbcyyvVFqK6eHThC88J4cRUxmLUFDOYBJKZDcU0R6uD6rLByuwzLCBcdkwDkNVySTtp9NUyA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10f1790e-6440-4ec9-d3b0-08dd980bf18f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 02:05:22.4418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KQBX/5VTFgS674248+QSI2muPich7+D5v+vnyAEMVMGsqbHRSQ0BW8+oo9P13BEl6gxBxj0IHzyFsXilVm5FJMvvRQeQuRrvyLmTqA8j34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=699 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxOCBTYWx0ZWRfXwu97oinA30ye 7WfGLsZ53l2/826td1OKw/b0leXzGFrjmXjnDxlE256hS/ZgV+gXUgCQki7M5gtjjJbrkoPvFuj HSJyriwNiOiQuGEOUlia9gB4bZAx6tfcnZe6uLK2fvqyvMlRlIRrMqTxlFmJAD3KeSrCVdqxeD5
 Q0/qDUc2FMHfICHdb0wUiE7Kbwl/pC1r47lULLFKvjY7R9IFelQQpnkAiYsknxrcbQuhHbDV9df hRjFIW6dLsz3yHE9Ilm7+a85qhyqBvNjmZT7+HE4Ev0M1ZwIzRkRm4FfxVlwWWe0IOM9spydR00 g97SMcCbwn7We/5jklsLeESiYBzhXY36zGeva95rMWQwvBqxmM7SGEPhZwphQgKZuG3C6kUfiIP
 LsnivrL5TJCdxGTwOdbi7yVJlMvcYRAnIj22Q65XEMxfTL7O0lv5CJiQ/L0ggKW+JBH1DEb1
X-Authority-Analysis: v=2.4 cv=fI053Yae c=1 sm=1 tr=0 ts=682d34e5 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 cc=ntf awl=host:13189
X-Proofpoint-GUID: -Yju0nYlVlp52nbLPFqGwCmoClPVfd93
X-Proofpoint-ORIG-GUID: -Yju0nYlVlp52nbLPFqGwCmoClPVfd93


Yihang,

> LKP reports below warning when building for RISC-V with randconfig
> configuration.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
