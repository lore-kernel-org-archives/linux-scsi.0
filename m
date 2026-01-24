Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89C52AF1B;
	Sat, 24 Jan 2026 03:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769225132; cv=fail; b=BMwMEWMnhubWEzz5FNWN5V9GmtUgOQL2/TRHmE7bjRHXs7G5w3gyDA2qXYG3dbFMyTZzWz1qeNUj42ySQMvXAvkwBfT488uZQ9FqHnOvsLgI5aXWWlv6BFn586YBM/eTDfXMOW2u55ryeP8cmFTqQN5VTaM/9WUCRH6XJlgX8Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769225132; c=relaxed/simple;
	bh=moJmoCWoDkdh0WFuS3eVuBpBW1GfDP7H/fFvsBPp+5g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u6tv6CIQKaW2qoaOIc1omx6BgDk8+fd9BJaS5ugkcAEjDKuqFCi3DoDPtNVxWX6bYxVEedjzhda9osSlyCoNb864fPpciAjR2D0U8IMNx/vDij/y0kb5dtOuYt+qRm5yQLs68jHDvpwYJ0OIHPg6rBPHJ2Dhs9fiahNXL+pxtKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q91pRYgd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UgyWhsAm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q91pRYgd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UgyWhsAm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O3CwNJ460162;
	Sat, 24 Jan 2026 03:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=r4V5OWf+kkf04fboUI
	l19v8sv1rqQK7ysTXkjmOTL4g=; b=q91pRYgdg5AgKCKOzqvDpHhladyrkbTzbX
	vkPvTDoJPt2O0E8Lh/fwUvITCp9go0ciXU9RvTx3dhKg6RFLNznZBXf32VxQtf+C
	lTguhXfhEISkzoXcK0RVcEnDKjPUjUcxRV2WwObojm68izI/hUpSJljs3cVt67YW
	BVWbfUjo/1kql56vTsdzyYQOvUbzIMbKg+aabHCSWDHu+O9MuP3V8LMfcpL3B8J8
	gXBgUxrU6345ho8wHgldVm7xSd/5iAGPGugrOrSsXK2XKMhcSD39zkY/ICk2Cysy
	0JKckTd6/F7xLqMa2sTzE/o4waDkurhp7Fcenkc8h8fSYvbSC+hg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmgbr1jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:25:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1Xg9Z011083;
	Sat, 24 Jan 2026 03:25:20 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010036.outbound.protection.outlook.com [52.101.46.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh620tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:25:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9L9D2p81HiM6gSyZCtsineCHcP2rBNILx4fuE8TheZVEMiQ4QDnnp1tICLISgBNV4oTMdETjZeNu0GqVahY/WFuKla8hqeQxkqRrddhZWL8YuINxfbBpL/ySeYwLMWJYVqntDJwQTpyQMBqc66Frq6B6++eEXDgZ1bOq0ALb4YiVEAlSu0ORKwG7mB7oozS/N2lr/wuUKsjrO9no8J9NiXMtOISJN20Xz8/GwftN/pOdJziqxzpnCtPj/J+toBeJ8vqWvjhWRgfwOZz/LlDejRcvMWgLdP5sa356uR3minmoLki2tG8tErYeKW4UldCb4J0ocbFsIVC1TjtzcLxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4V5OWf+kkf04fboUIl19v8sv1rqQK7ysTXkjmOTL4g=;
 b=V9Kd9f7qbvdeHxLPgStxigsoaEyDnVD7GIgSVi+q91RMuDUrQYkaVnbmI/IEzteviBpw8DFhxH8RwcQ/cPzxXy4A9yFCayqIh+3rwVOMiM2OAsU1mL8Joi9Fp6E5FYVQP5IZZJaHJAfBv18KRkEPIPaH5/aTBpTmvz1MW7Y7OLUbAaqLDm763xbY4KVA3XX7xza5O9UT15xjlZQZbtHKo/5l7C93TQzL5sj/Zf7Ko0gSY04kdEcVIXA3HRlkxPh3PKf+PHZitubRd01Sp4juy7nN5JDfVhsSTc0Aesr6LXV4G22m66bTkmASvrKz/2RVUNxx+2Ywh3FensHeJ+twmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4V5OWf+kkf04fboUIl19v8sv1rqQK7ysTXkjmOTL4g=;
 b=UgyWhsAmqSdE5A1VtnIScg8k6/LJf3mpnuJBVBMcks9+SxJz8hLdIj+LUN/SMsRcbAd0/7W+SsKGD/xP6Hn3LW4LyyWelLEW6NKmEFODWCLV6FXlERr0ADObrozy7B1rBVpNH1wgnKYc0p79TeK7fJ+oH69dgrh2rzETbRV0lNE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB5965.namprd10.prod.outlook.com (2603:10b6:8:a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Sat, 24 Jan
 2026 03:25:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 03:25:17 +0000
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Tejun Heo
 <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic
 Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>, Nilesh Javali
 <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E
 . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K .
 Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] Add WQ_PERCPU to alloc_workqueue() users
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260113145711.242316-1-marco.crivellari@suse.com> (Marco
	Crivellari's message of "Tue, 13 Jan 2026 15:57:08 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ecnfy9nw.fsf@ca-mkp.ca.oracle.com>
References: <20260113145711.242316-1-marco.crivellari@suse.com>
Date: Fri, 23 Jan 2026 22:25:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0144.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d5640e5-ceb3-4789-fa7c-08de5af831f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?toe2bpB0XK/jOPVkCypjUOnRpIi/koKMKDcXMwQtu/4Xw1VgA8n2/gjdPPnl?=
 =?us-ascii?Q?/+rNwNeO2azd3LgdoL7TeU/WcD3UcM0gVcz8L2N61RQLSmeMLAk+3mR9uUo2?=
 =?us-ascii?Q?nzboI6vzw/96GOKPRQSgt3ZtdX/FgthERdq1mFZclBUR6IfHoO+xYNyBwlPB?=
 =?us-ascii?Q?Or3Eezhnv+Rhl51tgVK0JJQued/6cQvNZVasIrf/UsSs4XrUVDtMMtol2a+i?=
 =?us-ascii?Q?hFCQneB/hEqL188fr2BDPIblPVG982uxvlh/tavW790eIsJuRq+yG38LL/gy?=
 =?us-ascii?Q?eOxpRGcH51eWy1IV928iR6nl0kVQW5cIQTEzTdeGV7FQaRrRzZkYxZ8KN4Fs?=
 =?us-ascii?Q?6gtRqr0Cf1s1bs/wo/NM8N8MlcglbY4oiYNV+ZFNTpCQm5emhQcfwycZNwqI?=
 =?us-ascii?Q?43rEUI9mLiQfx0bbMA9rIhSn/ei3OPQp0kEPyyLYA/RHvfIO3IM+9oinWth/?=
 =?us-ascii?Q?ghtnJwcDdabzZfQy0NCrB4bzyyjDBwpEruxt6PVbe2KFsLO1dqF2oNrNEM8t?=
 =?us-ascii?Q?Fjt7/oU1vFZ/IBZHu/TQXi8fFJ9F9I8sXRVAZgiPF4dnUTF9HYVxNKiKXHd1?=
 =?us-ascii?Q?krQ3xKg4/XtxE9nGTccMOtbpDlxPCvzb/yezqT2ro58eAu3NwExzNCutY/dc?=
 =?us-ascii?Q?MXVwC9Cju8qCxejDvEA2O070AmFwXR2IkbhQeExdjn/9PG12HmcN6zC5qYsB?=
 =?us-ascii?Q?SrWVADrLMWCBrFEPBgK7neWVduBY7y2M59dYbBxzOmsWfvPBrOHIb5Tjzoxs?=
 =?us-ascii?Q?Bdn3kkvFIKJzjKToK0vK550/4YPzPpFc8Widqb8ldIgg2K8vY2/fiC/JzOk2?=
 =?us-ascii?Q?X1n/DdYiXk2UCX+z9x0hVNv92ovgN4uHMh2hJ0KTB27HtxlabZMrtdm9VMvU?=
 =?us-ascii?Q?V3AqRS+wvBNV75waZqhSLR8mqYlSD6bY6GBvrmDv8Qlw5Yncg4Q1ozMlM1v5?=
 =?us-ascii?Q?RXxOSSb0rOmiGyPzzYljZ9z/zzyiCtIy9yHyT9pdsncmF5dUpDv3XIhKTHEP?=
 =?us-ascii?Q?CgVFWPlMeHppLfvFjtGqkO49pHVmhfppAuJ11rFkr98/QzALDVdnhWMFA1GE?=
 =?us-ascii?Q?iBRIwIOXUNIdiq7EqXijtDd1rzevYmei5n5xL8AxQYC4ql7aKvOJrArBkKZ4?=
 =?us-ascii?Q?r7uB8i3pq0aRsokQWcRh3OPVj0UBvg0TcKT29XLbGnbJhdibAK+ByiRwb25u?=
 =?us-ascii?Q?misuWAhI5v7xd4dSZ/u3EpiYwAIvkuTLjZYOXr0grumqoyyfm0nNkucgR6pq?=
 =?us-ascii?Q?K0qlmsd2bMqI5QvCvn9oMitJpGKHBJy5WAeGvLaQ787dXhlUVlcJDxRo3GNT?=
 =?us-ascii?Q?CZrFv7KwS9ooazumGInhAH4P8S3PepaHcQDV4F9gUj+KAW2d/PbG5cHKUIWO?=
 =?us-ascii?Q?GjK08FNTELe8CAl+mW/Qh5v1XZJPpsvVCyTcqrM2PFcq/J4+ZkAkpMsEKbSU?=
 =?us-ascii?Q?G12cSdVbNHG36RL332gteh62jZA1Tn34T2qCsStNxfW3YhBz0bbqQRVZ4q4I?=
 =?us-ascii?Q?2arKRvESvYFV4VXStDhSQG8Z3ttRuiDQs43TTqY/OWCmloXD4n1DGMarnibj?=
 =?us-ascii?Q?pLQW+IfX7PYDPi5Xvo0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2/+dJ2vCp0V8JN0mMHxk2+OqeYcpsAUrmM2zLidwjJeEzjAWbrbTBNnL20Xc?=
 =?us-ascii?Q?iQIW4CSZBmm3d2N6G1z7/4NKNoyFz2pwZbUeJMLFa4+UoYwxdwvnwKR3IeIU?=
 =?us-ascii?Q?aFlTX0lwZfM5RgQ82FzoBBFbOw40xPLe5CUBCaZAF0qBrTL3REKQSDdhB/uc?=
 =?us-ascii?Q?JA9Yf2+f83+VVh6frT/+3S+8Vh3NEyHae4atlPPpnnFCXUjnV5mpeySG93iK?=
 =?us-ascii?Q?0y0RR/J682IJw5nvbfM5IUE2G7zwwa6053+DwrxnhmtCHoppX1VaLROnn8sF?=
 =?us-ascii?Q?j4VIqCn+xyR4kbyhg1JY3SyVeALp3jEVgtoWvNyHHDWf8v0e6ZZVt7FY+S5E?=
 =?us-ascii?Q?w3pmtg/rxrtLfUrHvAY3UkMDsIK0wIpi90gCqTbFt8BGGPLrFi6PBHMciGj3?=
 =?us-ascii?Q?I/ZPqGfpo7Pxd4Uon8LuRlpKNxadm7+A9hy+ZvuvthtrifOctFaUv6zQYrsf?=
 =?us-ascii?Q?XoyFScXI2dYEityhNNIgWE1D1s+KBhDQOUClY2zXfL4tMVRdnQqLNgbExS+h?=
 =?us-ascii?Q?BFMQNc+UEsbz/JpVpSLzyIKfW/Cm1pQYn05PlyryWlKarVpEB5mjeFj1dDlm?=
 =?us-ascii?Q?dpg8A6oC3H3PYOxh2xnV4waHDAlwR0GJNmkF7l6NV4lPJE8scFxQav6W+UrG?=
 =?us-ascii?Q?XIvkKGjCQMd/kLCmgf/nMo2rEqHg+tdkNgdZqHpnZJ69WsUz3HPtLT7HKrFJ?=
 =?us-ascii?Q?ndEns1cLvNjHoZEzdgP1q+Gs6X06FC88e3m3VeM4rRHq/hEwuFKeOUgpNnuK?=
 =?us-ascii?Q?UqB7c50Ed+LsC2kw6+Z4BmzBzdviGFh0rgNHSPwapFSagYm8rhUopqWAHHfI?=
 =?us-ascii?Q?8BJ9RRWMHopZ9CTBmkCDPRSYFw0oF0B8v/KwGBJE6x94A6kTfjo84E0CVrln?=
 =?us-ascii?Q?pp5xEuuiZSlaxeoeROLF5yNRwC6Lo9LtwouTGL+ul0DlSFI1mavQ+uPJBjNQ?=
 =?us-ascii?Q?XNUReTzl/XWGjF/y+Yl1mNbzLBJFEV4lhygWSh6nodP0WhWwlPzWvxANaCWD?=
 =?us-ascii?Q?xIupc8fhbtUj3r6ZVsSm5yzkjOy6qkaBRGi/jO6tkRSjss7XjhbUVmem5UUS?=
 =?us-ascii?Q?pcyMCq1V0AZMcQIhI4WVwNrB8Z4BBSJx1HRPNS9KmOHHaLcZjkyjRmJLsAZy?=
 =?us-ascii?Q?7Ar/0/wdHE7H2xJRC+eNsmdPMDyLI2Rjui/80aUcjfRUNSyB+AfCPDk2vryt?=
 =?us-ascii?Q?SfAcYf/WkB+0hLYS+/vu7zo+JTJCjokePokFfuoMTVeHk+2LEZ1sTKHhPxjt?=
 =?us-ascii?Q?MBB7KjEPrZDa803O3T19JCJTf7yI+Pu91u9i13u8NPmL7M/52ogDaFyhpsxr?=
 =?us-ascii?Q?bDvFh1ve7+82Y6rq5qgU9nhf8FiZPYsyj6VJfNsPGC7UsUklR0Npwn5wLtL/?=
 =?us-ascii?Q?iFqKmzxYC+t/ROz2n6+uHXJ7NKsgWlRKv2lyRP1AXCMoAqGLTpm4x433EB6p?=
 =?us-ascii?Q?vrFj00v7JPdtdbxQIPwm7EGEH8oWTBmu3NBJmIfm1Iu59saCCtl8HnbVrlWF?=
 =?us-ascii?Q?5lfy1ViiP4MPEarVHn55kWo51r3pyZBORqaFyyU6H9vbAftF8E7xBSOTaXdb?=
 =?us-ascii?Q?ug7QIqTfEl2+E3uLAwKIWLoUyBOJ3a+wRzdwADsmGXbFMB+3XxGY0ZNW9LqT?=
 =?us-ascii?Q?ia46iRUs7K8h/cNbKBBAAlPUPfwRx0QPBB2yCZPIsIQJ847857Er9hA+gi1H?=
 =?us-ascii?Q?ZexPr2SY/Tj/T22xuM5agisVvL1EiCqsBVpJQYVtmymsW8u96/s7kKv7Md5W?=
 =?us-ascii?Q?TSqcksoQpqyMZweTth2FOsiOsCGbVQ4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pclH84Tx9lcCIIuNVKVPtJhEfyjTHhHJ9Tvdz2mUIrFCV2sIX871HkeZwo2tPvw2IjyUFHwl8pNvaeUj7dL6jnw3d4YVi7SFw6COG3Z1xrNM7cD1CkWyoyMFSlfGuXCXx8wdMBLIvolJ78Itd1WzmwPLkBP2aJx3S9ecnX0WS6o4qBj4NsNX36YWDh7hj31/gpY9JxrZ3revSXvXjlMg4eD5D8CoYxQbcfcFRi6jzgK4a5lWkddSrPYZx1/VIhfaVHkU8bf9pTfYv1qXmA2jQaPr2FgoVrkLRrWz6d9J9/Se/JPUqtj+XMFp0m3SkAaxH3BU/+p8hkj4d6gOQ2AhFKuS/fvaNoJHovTpx211K2JZQNax6gi1EQsrgc8R9e99w0B20C1TLI6u/qgCsjRnPZ07c7bbmn9KSzOhcvGDBuXrkIZZMDO+usKmpQj1UWNCnYC2ZPt/vo1wAbK74nYvz59QTr1fmgJJtp05d2hlvDkaDAYdNwBLDMVQPP/VQ/SqV1bP3YxnP0yNHvLWTpFb7QlzI5TT/s7YaLkKZCnc5XBiU7T9Zzs26iZEuxq8h+tu0tWsswFLPzsboT3Ic/bkB3kotQ8KQdD7DBzg4ZMEDfg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5640e5-ceb3-4789-fa7c-08de5af831f2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 03:25:17.1624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8t1EtJJuKKKeD9yHorN/53FanmLeeqJXNDaf1tBmMfzwsrXqf308JfhgiEfNg1TyW0FME62jTiU+xN/JOS+JsqfJE46DXV/kZQ5ZgkwmOy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5965
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=937 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601240025
X-Proofpoint-ORIG-GUID: 4srvRZqNkwbuHo3bCHMWAzz2_C8biYtR
X-Proofpoint-GUID: 4srvRZqNkwbuHo3bCHMWAzz2_C8biYtR
X-Authority-Analysis: v=2.4 cv=AqfjHe9P c=1 sm=1 tr=0 ts=69743ba1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNSBTYWx0ZWRfX1mQnXJE8eFwu
 iN60fhb7TZYGleeY5R+nJhEM17/hoNt5Xf2jkQtpQG9EBMScjBu8PnD/puBBO8VXJtKXcS5HDGU
 IwnG3EQdorETq3XCdZZdsW4+i9wrsZ9+Kkada3OkhTS8n8JDUlkw9ZPKEwIaSLCPg70wOuxszjf
 BnJGMbQb/FreoMYd1SI/hYnWbSYMah2rKdbYv2YHU+kpWKpmERbcSWNIUiROLV7P/W0HaSd+MMZ
 3DpS+FYNhTXpjrAn5alCy3RvWPD0R26Y3RF1ReL/JNErZS5SwPlY3a7wNdxIwEbUcsrM7IsW91Q
 EFgy7r5mnl5bv8C1LtP7dZNbMltq9j/PuSzl5UnMnQgZ/rrM1YMrnmSa9z6x6FGxtThE84IRF4j
 oTEz6MrqsdDKqQ41HbQODJ9mMwYHD0IEd/EU5dOoD2n+1tMaojlQ0JN2Hv2M7ymw9ZYh2P5/R/5
 zdBjDwV4Ka5mxqYNutw==


Marco,

> This series continues the effort to refactor the Workqueue API.
> No behavior changes are introduced by this series.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
