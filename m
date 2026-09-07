Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F6E496914;
	Mon,  7 Sep 2026 10:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778350; cv=fail; b=A5xMVniRSRQOVLyp+C57P6WRxVNA/RDnb+pIEpsOf+wa3+wWXrgpA0Ev+q8wkKYnnoJKxhv2HH4fGwG2U465sIyW8Uu2Wz5JoEED9dKA4FH+WRNqB0/nfRUKYhpWtQItEPRgea7hVdDx6Taj4zUqNzMLybLqR0zIoSMPoeKLuxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778350; c=relaxed/simple;
	bh=fTO2WLhWUq6v2phqO+lJkPKWkecucVSGqCwasWau10Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jnuDWn8CUxWlouXI8956c7Ho9IvN9d2EvSvL0daOl1NARcwoKKg0PXjHhu0hBGiP97OdXqDnlnYtm24WjvCK6sY1IDIBLK2PpIR6nVfUc/ofFMSSVNbvnFqehLQOgm0/qwza6vYhWBT1QdLWdCoqwhp0aabgDa+93FaHHrcv8rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L+OyXJ+U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PbHi6VfB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+OyXJ+U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PbHi6VfB"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870UZ3O186187;
	Mon, 7 Sep 2026 10:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ecFBCAZVZ2Ky9IJq05qUFldwgcwa/osWm5T876zvxqQ=; b=
	L+OyXJ+U0jlIiiLaHqA7QCiztf1aMoXianFfjfRf1ka5oHRhbrNpcZ4bv9RwQMGr
	gIrX1LMIN0s5ChT4i+qZdounoMV8QxFm6J9F9maGQ8a6wHMLtNGGwK0vg8Shy+E4
	yON3rnLFj7O5SP4c+ASgIoijPmRo83oIw6xDmxNKISlZb5aNf23fZ9oRLh4haSa/
	yqP69/4V9DSGCWqvaRRlFI/BLytvNwm4O+rYmw5eXFYYgQI1kDC/rUkFe9jotTYH
	PIc30XlazhXX2zJt3z+GCg9Ivz5idyDPiqJ2vZFbtPPVDAltzCLxD11ep/Z5+47J
	dVvJLHxRcPGC9EO9uEDIJQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbmq9t50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:52:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687ApfQe029304;
	Mon, 7 Sep 2026 10:52:00 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh7aw8bdt-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/KPUvJLE6JOIYTGpLYRWEuW3k+uUpuzAv9wowQl2FA/OOUE9bQfRi0r1egMchU35jLzJWLV5aoHu0oDyn9WPvIYHHLHmV0JgokCEBcubcKw5GcyDOke7gVks7vbklpJbEGq6OrfdMpvoEGH3ZFqxYs0KdgVg7dFWrAH7H+y7mh4AysFPv1PNJOVmjlp/nsl1NBdZwH+pzxFic2GQe58rLCjsvYQbFXblZKHQhs+hAfamvODd2041/AWCb/nTgCM6UG/jrR+yPlDUxdrIN1Trgj1WI6sJtSbL1uiZaqSDNTyRqdH2WPGyROKa7cAyNzxJeSDEvQFuHGIez15z90lUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecFBCAZVZ2Ky9IJq05qUFldwgcwa/osWm5T876zvxqQ=;
 b=xid/D2STtjcpJboZNkkpoL1o4PIt1uGz/h2OowfY325PJHCfelemDG/HydGTUkRnQhahRKYSVTncHYZ6ShioSC/sc91u02XAewDFDJlrC9R20WIiuVGKYoRRbQJdUmx2GYqlbq/+bVUo6p2MjzgUl+W1UyDcW9+ATzEKvlJWCx4/ws5kaeDKfGS/uoMmEUsiEbhr7Qb4Y1w6UFzhNIPsKLyJBw1VG3DfI9V9kRmxpFFNhc4/pKXtV7lJ/Y2ndBNX9yTXhQyc0IcaxVaycFOdPmLeB+iP3wyu2/25h43iPIZPdUbQGNeH9dkqpfyTRehDm1TyaIwCbi1y55vVLLomcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecFBCAZVZ2Ky9IJq05qUFldwgcwa/osWm5T876zvxqQ=;
 b=PbHi6VfBiEgvcDmPcm/83Bhy8ZMrGFHdJ7EHjfQkMdyGqL/Ks177m4W0HVPipU6Mu0/2gR+7zgEwt/VTeLL21tccwO9WbIkLKCcaQzl4GPK44U3OkvAWFRv+zbYS514hq/IzCGxj36DNPsfJmvdiyT+RqJbDrgEn0gbQs20tnXg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6276.namprd10.prod.outlook.com (2603:10b6:510:210::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:25 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 25/27] scsi: sd: add mpath_dev file
Date: Mon,  7 Sep 2026 10:50:19 +0000
Message-ID: <20260907105021.1763236-26-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:610:b2::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: 3774cea2-487c-4529-39b3-08df0ccdf674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	FSudhlOrTaD8RuBXxi65H/IjAH/o4FXdyDFizcm3PA38rJ0xPVQuAuDTFr2WVvIMZWJrlwB+qk2QuMSbyK2mKZLd7vodbLsLs+Z+O/eb4ROfuUl1WnTygM+sUv7WpDsAOD5z4VtSt2zQY0vRATgarzy58PZ5rYFIum0m3D7R02YIr0WT24x3gDXYXCGaYp5oZLnE/br9D83cLMr878A7T3ee4O73dnlcNtXlp2DdkUhTG0pfVcyydId5tuiWumrTG+U1Mk+v7Sacd9nB9Jg9Fez9D6ZjVzmDxdyiNuDfTniKKJEsVaXU4ovYpgCB3Ho+Z1dOOIUGHJdUWWXtFjDt8S71rCOtJ6fx50pjSS5pyirD4bKtpKNb0fWyymCPcjTqqHCMNKP+oe9qtfEVhqy7OfXEz9/ly75bQBGtPUTXR8c9V7nF7X0KZ1YLVvY4zXPqC0fAyZLt3Ni43xOQaXAnjppW5plpu1YR7sFYIhellCNrUlO8nog1m9sccrz9ST6pinPITNpL7Z2ExBryegESs4rODtU0fBDyvNKSSrtkhXtq/kBcMAPYLETiBIktAeJIDEv3UQfn4BgX383tpepQ4wWJnNDLvs2uWsCoYVD1Q1NNp89OrLd553j2iX6bSM/4kQY6b3MhU97Ur99CWjAo9a6R/luqc0H36dn3C6aepPM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RByuo3nhy6dBTllfbM+qP4bhPSo6Yae2LDdoqZGiINolp+UuHCi250rTKUVl?=
 =?us-ascii?Q?B8F7Z05u9IVcRWKt1/DqSOeKoEra9S5RzaG87HYyI2JDfcvCXp3CrwnyrqZC?=
 =?us-ascii?Q?PJ0x6wieXdSyI3CXuEKlXC7f+KIYPqvbrgH8+ZpK8BWxmRn/ljSRYzjdO+N2?=
 =?us-ascii?Q?LwMCou5dpYurrRnJqJ8iyd978Wb6N869A4UGNCBzUetxFQl6BAZsVNVHnRlB?=
 =?us-ascii?Q?gkkZWasaMummA9zA5mZDGCxwct1STbcJey7vgzTD7tk6emaTf18nwHVLDk/m?=
 =?us-ascii?Q?es4yRZzHoB44bLq3qQ/HBZeaePju7+aiAqPLMZQCeBg+bGOkzZJKKbP1KOog?=
 =?us-ascii?Q?gwU9DngfrCF0hWKTtndl01nnoJKfdsL1Gm07iFqyiMfSsMGR25F8gV8n/1SS?=
 =?us-ascii?Q?9l2MJbMiPuQW+4Gc2Z+OvhCBDc1IPcFxLQqGQFlnSWiJlm0YbFEgodtDhRf7?=
 =?us-ascii?Q?4ZXCTHMX4RM65hZdU2rM/INt4UXFmEfZNkcGnNYLE3dwzaRAt22epnxOpc+c?=
 =?us-ascii?Q?Oi0f3UN/tZkuAetaYSvuUFbUu7Jv3+WQ0/ihWGEO4FaH/mIXwnD9YzmwRv+W?=
 =?us-ascii?Q?MjwWAzbuUvK7GC8JvYPW/sffhY/q4BMo/NvRSYKDPog52pNYnXi4P3HhnI/j?=
 =?us-ascii?Q?G3Zj725jLJY1Tkn4nJ06hRmRw1ArA5ISC+Sg4Wm4W6+ez231LGsSEUWBcOOn?=
 =?us-ascii?Q?O7+1A3eXjQjCqVEE0ALtBjZDQAhBhbFbrtFUSifxqYIEL4gwtskYaD/cnBPu?=
 =?us-ascii?Q?BDd144z2pCVbormwAT5iPDVHldSnAydWrKwQjVksQQ9dS+H/LchjIn4jUWT6?=
 =?us-ascii?Q?uEO+MBHUy4IB47s1za99Ea/fXBVdOTKysdmOKiSqyrDAHomQCdwj7p+sNXiO?=
 =?us-ascii?Q?DYfWDyWH0b4mA96PKp9dk8Sy3gEH2uzu4Dc8MqH8Ii0IKnz14qHS/0VcAc6H?=
 =?us-ascii?Q?2WOdv7wgSAOmJR4524f66UkmTqFBXY+nLOqta9r8wkgDYdTQi7XRuFkMleVW?=
 =?us-ascii?Q?MbtrjmPQPd48nY8zoyGAcwN7CJx+FYl+hmY3xfUl6ewL21zrmN0b22x+hoQ/?=
 =?us-ascii?Q?xqk26nMkQ2okYo0f1rjiBsG0JVK1jPxR1BMNO9DzjdPjV/I7oQNFgto5+B8g?=
 =?us-ascii?Q?HCo1gEIMP7iVPn5PTq9y/sAq4dg4kfhyYIStOJ+ynTxUS6MOgbh9SMWt3oj0?=
 =?us-ascii?Q?6VKJiW5hU2qxmIAFMZuKGg1TkOgbcbyWO5UNEesUsMMfGoYk8ka0m4ZQIiyH?=
 =?us-ascii?Q?1wnrInVpre0p3a3o8E4tgAZf4+qm53RJ5XzLmDwo2uc5kSyZcW84T0NLaoPv?=
 =?us-ascii?Q?JIoqGLyJnzCWgwuk3SFnS31QeZBuzXS7gn1MERI03MgSdoxDbxuhlwnZ6YLe?=
 =?us-ascii?Q?qoDQ6zhHzXmeJw144llKVFsO8f4DFp/Mea227EOLDfkGzE/OGGJZuCujgTRS?=
 =?us-ascii?Q?3sPEiqMXh9Zirgl27El5ud/PVsrYuCmZ0UyKhbJP+K8IpdVQb+I0Z97oRk07?=
 =?us-ascii?Q?NzZ99UYpRorLkNNSd+MhF7PAtvJpmPlz3/WvtMOGlwwDKu2Q7TySNhWg6OA3?=
 =?us-ascii?Q?DAMayVHYbQhRl1nK+Qw9lqeu9yAl6KBD4gqNSFGA4Hc8ka4w/+csJrFBbalW?=
 =?us-ascii?Q?nlofWGDb1Bv/4GaSHwEY1/vjVQsB3cC+uvjwU6GmiHQo9CwOh+vd+I8+wa00?=
 =?us-ascii?Q?2OHQJjo8QXaGBH83oVZEQPzkBealmQbQ/rsdGrpUR6k8OTV6jL++WdKrBAF8?=
 =?us-ascii?Q?SlU2OVURtQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	uswsu3awIkPEpYNYS0/KB/mSKv/2ew3lOzm0+vRYcQEYCHhWfZO+uEbER5v4raY9YlDFNIQlu1j2kukPAK3RCCnVDeo0C8Ptr9bPVeU6jPQUsiqPhYm8VZ0EGWl0lUkVo5dZ/hHEBYNaCU3ElW2nAUlplm7Ul8p39ZB0MElyrryBhjGU+3nbZ9QF+a9bpqD9J1mRJPdIYaLjEDaKLLHH/IzvxyYirxjDBnvIVf/+8dVqjRU99z2RPjNrvX86D7aGnqXOMyuIfXsodzoec2yvWTNQz9uWM20p0RgMMcEFqsYbIMg8I4ol0Rx794ohdsgiKYbFkGesda7yknkzfjR0KA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a02BhxxWAkPpOMira/jxgRUirezE4aSKmOr5d8B8dG3NS7eTtk66rqsdJ1f9fh7yHvN5T4RaRKuDjfR9em0Q3cbP9CLLnNDa4vZTVkmpzgTJTdRQ6YAbQfaoe23BkXqbjYvMKrNLSxJ5OfeWgHJFs3OWpfByW2KnaFf1wTykQxqRTCzro5Ssqx9Eo8T2FyjhKSyeUj6sQFtrLpjPBbF942y5Hv2Xb1hBaMdqO9iaSQbPQhN9KlS2ZH+kE4tpqu57NZZG3tSqZFdbiZAfJhwA7dZGrkxfW5yddDLJFteIDgIY18/g/fq9ZB7GuWU1VQ3b/xibDfXlMlt9VYNnxsJ+GeIuSMHP6Q/D0cmU20rx0nRz0hw0KXpqSFkngh8UYs+TmzMwpZpS4/tgdjrXnA2Fr0WMr5JJogHuhizoU+7V8FghIEBH4QyjFL9ShoMlCLfG4fkPd5PEoNRgWN1/aXtFGGgRgXCm3nIKFqv3PEvICUKg0Pg28uW1vDrYLb/odpXLNbXWFa6F6hp4Z7gmI9fy+sOUrTbZtsNvmO3ioS5YSdaidIl9CA0D8hQbG1rnMW/8Tb5/2dsW5MRGm/wP3yKelGKJeHRI2+uUPsIR5zITvAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3774cea2-487c-4529-39b3-08df0ccdf674
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:25.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpwxT2tq33dzzCa4H68heeEG8QxBjvzGmyDxoJKdhT7ZBW6IeXZVCgsq7t6hcHisC5Dt4vuH5njmNGcvuxuAVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6276
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=JYiMa0KV c=1 sm=1 tr=0 ts=6a9e9751 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=7RnQmdzTPIgLJ45uHnoA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX60NT0jnTcQVZ
 dZHWAUp7sdjQdm4miRqxsSvl5An4PI5OzEYa1txmI28C2V+lNM6snDIhzXULQsxNA6Pz8NdB85/
 Zi/jcBqdQOXo6o0HbFzt8cbzX8zW1DFYVpUIVX22v/nopzgrLw1ryroN4HC8kg9k9faN+l5i0jZ
 UMgiQ3/jwPkzfmdzWU5jfTgiCxHtpw/Csszi642MM2EZ2dC9llZrnVWIOJ0u3NLxxsj0Us1gHoU
 2pF1Frz6DdvSP2HslOsKjRV57I8/ubBuiuG0myKo8nmaoe7zJociMqpgf6aW5RXh6JgKss9Lj1p
 yQhgkSSUR9mrb7yH21tNbfOE7zoiW2QXpjoms0z58DkT4Y5B47w+mp4mk37Ac8R+VuGBDSlazT5
 Ll2F+PfI9LVs2gPLHZW2qcd/bSr0YeE46eg1h7AyVgnPgALGbIpoxxkRQFdqxodLrMPrHqiYn/S
 vEwH1VoHiaj1XquN+eLhQld/htW3NPPZMpaS7iog=
X-Proofpoint-ORIG-GUID: 9n26BM_uRrn6c7xpj6LeAAjrtiiAaSb-
X-Proofpoint-GUID: 9n26BM_uRrn6c7xpj6LeAAjrtiiAaSb-
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX0seRdPwbUt6D
 3CbKOFcTSBaOrTYeZjbMLdRi2NPLXovifXHA/jvOt5veTfnfpUd8MDgJgjJ/VlrspbI5RLBQL0w
 /Vjz5z8XWRtm6YYegSSV6Yw3krVabGYW61wrgLSPG5cNyEykV8Wa

From: John Garry <john.garry@linux.dev>

Add a mpath_dev file so that the multipath disk can be looked up from
per-path scsi_disk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_disk is missing.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 27230ecc2337e..f3062fecfcebe 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4122,6 +4122,77 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 	return 0;
 }
 
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct gendisk *disk;
+	char devt_str[13];
+	ssize_t ret = -EINVAL;
+
+	/*
+	 * This attr is for the per-path scsi_disk block device. We need to
+	 * handle the scenario that the multipath disk has been deleted and
+	 * the per-path scsi_disk (and its attr files) is still present.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk)
+		goto out_unlock;
+	if (!sd_mpath_disk->disk_count)
+		goto out_put_disk;
+
+	disk = mpath_head->disk;
+	/* A reference to this disk is held through sd_mpath_disk */
+	if (!disk || !test_bit(GD_ADDED, &disk->state))
+		goto out_put_disk;
+	format_dev_t(devt_str, disk_to_dev(disk)->devt);
+	ret = sysfs_emit(page, "%s\n", devt_str);
+out_put_disk:
+	sd_mpath_put_disk(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return ret;
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4403,6 +4474,8 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 	return 0;
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 
 /**
@@ -4555,7 +4628,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.7

