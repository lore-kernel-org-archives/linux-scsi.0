Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899803ED134;
	Wed, 25 Feb 2026 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033869; cv=fail; b=QE837ncD/QlJUgu685s5mlRrsshACWujkaZS3rHw50TB+f6p/WfFUCagEsl9LRENrKCUEelNdagot10oIJmXCZcomDGfuMixIrdjP2Dt2B6OGCv+vT7voQm1ebR3q43anWozIZVzdvNhc5uCWmH9yA8tvxNu+Q9bJ+XJKdXZUek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033869; c=relaxed/simple;
	bh=FOrb1XVrzP4DUD7aJYD1IcUKp3SmZDVam1/l/nFg67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eXiiCLNkdgtxUnQaU1Y2aj6H+cWRtr+hkZOcs3eTldDfTWtLsZuhgUgK+cqHbhVAEvJZ/ETDt2cvsjLP1vxZIqPFMs7I1zr+lc57BOLFR0RH1PY9KPKadkubCXUzlk5hmeJNuMmliFVN88bybronhMEHT2S05It1X8rOY1p2CGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eUe9lrON; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BuZjVXDQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eUe9lrON";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BuZjVXDQ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9oPvK4019329;
	Wed, 25 Feb 2026 15:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ok9weDdDiohbcjalblAblskCZMXTSURSRTsosW6NZuY=; b=
	eUe9lrONZTzh70UH1Jk2GY69XPKtYZqX9o179YogFx5rmjx+IrXIM19FW/mBAFW5
	83ii76rYIV8WLij5Lf35ZuLziAkO81LRhzWNs0Tkoa5UXqZrtdGn8emf5Ik1TE2t
	084O2yvxW9f6+aOTG/pqlmJCF/6Cn1bz5glFTibclAw1GWxQ+GjE9wpX4lSr9D6Y
	TAOUNoKgDN3PFkAC60QpZYqV21r2cRBL8ticOLG9N+ymi0wXcuZOjp98u+Gl6Rxu
	HUQA/xn8OKuGtZ3RmOBN/oEKhm80TqRP7yqPXIi8gqlE3/fbB037ub4YgesnaLZu
	zxmVXg/amzCg7pUjqAkYYQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a06h9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PESt05028497;
	Wed, 25 Feb 2026 15:37:17 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7hfn-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I84baeNDlFu5H3gVuQUgWivp8o8aUq5L42eC5LqKs0CoMqpjkfQZMHVA8mlB8Jr0Yc0H9HV2iNwpC3WQIec9P/E7EZw3m6XHr+NREb+Ek2uHw/qL7CFt7gN6DAsPCcyGS7eA0UWRKNmRS6m7j3O/QcmQoeIOZhQxAzscgIdTsTqbrC7ZwtWJ3o4P/SW2eX7O8aRFYCrrz0KES0o8frjeLOcugZKZBPZ2ydRp2bC+oCyMlelvokVo1dVnwpnAS4J6CJT8qE2/smxigFGTUe0vZFS9rhvP4nvRxZBqFHCNcgM4oNFASYEBAQpGze/SBXCd/lwcuOf5RnphQDsuv6XOjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ok9weDdDiohbcjalblAblskCZMXTSURSRTsosW6NZuY=;
 b=NpvZ2gjYQgGa0F8e5BlCAeh+Q3Si0kEI5Tbrhwt1o21j+uhkHjRGx0ogyd66zRReLC/In316JNYX2jZamhkVygJQ5Inuz5NjFrIplYXNHq2iNEc5MAbJ8TjqmUmzHkIFxFnnHCO6XLpLTF0xJFF1z1grX4n08itvynzlbJ3Dxtc29Y0MnSY0qLjRw3xzSsidaLvc9ONbTXjQWlSbYMMBQeN7NaFzbXyS0Zzqp83igp5BdQZcdecyzfPJ8ewR21ghwENBEkEJ1O1M1hCw1qF53hbArak1d9oWDKVTlCarXxeecWAolmqOIvMRTDHda03LiL8jJ8kp4U5QBjZwuiBVZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ok9weDdDiohbcjalblAblskCZMXTSURSRTsosW6NZuY=;
 b=BuZjVXDQw1Yw8XIz7SJOP+lpQ+X+TJHbFwMvIcRAOT6GroT0P6LsFwby/6exGH5kP4p5DeppZvnEUkRubpp4g31haZREH4ES0mVPvHgyZhLf53CFPOZG5VpOxCBvA+vff2p6buZ6m2c3BX2Hx7sAVeMLry12m7TO1IRfL2OMpug=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:37:15 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 15/24] scsi: sd: refactor PR ops
Date: Wed, 25 Feb 2026 15:36:18 +0000
Message-ID: <20260225153627.1032500-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0061.namprd17.prod.outlook.com
 (2603:10b6:510:325::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: 37953f0e-8339-464f-8d64-08de7483bfbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	kyCTdd+lCdS3AeFXIh02EBw3QsNHrnU5kjsugDs3udoEhTHDAUs4Rvc7hUYk0QF3iHQ4Xt35+GrMW2SWAugOD6quFiAVuquYGiqQ9jtaHUYjkwDEhY5kxk6WYIrglsCEbZV7WGNL+2rv0F/kdWn+L+231q+KHK5hzh1Ghuvay3vhKhWkqzGbYVJRp0ZXMLDPWRGAiW2XUk3Aa/BiGflm4HQt03MzNiSODuD0GC08YZnpWeeHpDhT2BsLjKrvLILq3sdcS1fQ6rpDLwxKOXgfB+ltgy9dvlwE2GWKcflQXeaD48El6tU5MPJQwwIa9IUovdlsDzUWsa6Z+cH3hADZkrG9cBe5PvcjT1liOw9Qi8mmx3nZ3DZbt7XFjLEKA7CI++0uCQ5aNuMKpnVxzhmgwpdJR8zW6FsL/8k0YG3epQvcgFOC1w2+/ou7UFwPkO5elvNCgAZOMrgss+uUFQ9rQ/xhPqXUMGpu85zW+Wx0bADOy0PR5um05iBRu7x+Y7l5z5XLlL9L5T5Zp5EJ6cqnEt/QFiMUN25YgDbCf8ICIrjFKNsGp9qgnQOA2MnNW0fUAjIM6X+f7CWxgYCN5bSEzKPpwszM+3lYvs1+ErdlEK3d5gOv2mzTVdodN1PKHH/nOnkaDoBw78nHLkrUnY6cltkdX859vLyXR/rO//MCU+I/FIfFVrMJNOAE8N2UwVQW2Fi8z9chFJll1qoLZeP80BmCSy0ojR1NEpvM2uPDhkU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fNBII4kh9zSx74mVHdkLwdvx/R6FnW8XbhpOC3DpDmGxwYeK9K1EGQ0Q4otS?=
 =?us-ascii?Q?o0ce7ohax88EaA1m0UvxfXn1TjNB+/+pfelG/rMmo125VNLJJM1o1C5jz3PO?=
 =?us-ascii?Q?vnm9922raIjvfmDSJ5meNS3kSgvkl7CmvLHKBHV7fst4KNQqASEaun1tsgeR?=
 =?us-ascii?Q?8i6o0PDUkFhOvcecBtvM/HbwMkCyBUCtn32P951n0tZStPk8QN0XwWKPHjVt?=
 =?us-ascii?Q?lZS9bbF81WafcEPIWeRrse77cl0VWSwiM0uBZW+4U9x1xomS782Nu8fLxFXX?=
 =?us-ascii?Q?S5KCwr8dwuzyU3xvsXpN+fm2qmDdX0iw1ZU6Qm+82Ji/BuGhktOBvdcQ3z48?=
 =?us-ascii?Q?IQ69Bx/pOoAcWUTttT4iBAj7jLYf6p1BthJBZ7h4DdTkaN7PJI8sMk29IVZn?=
 =?us-ascii?Q?Ko9/Dl0lvxbOUHLeboXIEjOWTb/URlM59BJmPvlW6wKRrPUv58wNTMn9BzgM?=
 =?us-ascii?Q?W8Q8vnLSKB/z/Uguo0Xtz/bhUXTdh02gm1gxsIw55pI+qWdfwHR4WF9QMEqM?=
 =?us-ascii?Q?K6+T1jfdZihoKsntz2r9UNWX6KFyi0VREHTeIfLbtZAgnp3I3QXZCNixdGww?=
 =?us-ascii?Q?llPeDni4xJj89yTQOpuTsN+F+YH+6k1oylArncS5LrsDHm2NLLseOnilhWYo?=
 =?us-ascii?Q?b/qIpsNJm+2uFZzRu1jyvBEHSPxJ3seFS+A1icP+hR2z7rDzUI9ZkFhMcr8w?=
 =?us-ascii?Q?mzJetdnVSDk3ecoK/PYpK6pV/g9wkIIR5iNRKYde+nWpXN/TYivm4jKp8Xuh?=
 =?us-ascii?Q?jrGW4uzrVwwasQbj8/mKeE9RJGVs5CTYUeMDKnnA9LF/7wlatvM0Ljl+tJVN?=
 =?us-ascii?Q?s/vSLvzH3Gd7/b+/pFlpLO3Ntux92KnCFwM/l2PDpOBUFO6ao/aiQGo8UVyA?=
 =?us-ascii?Q?J5IKZcxk3CG3omst3dZNxKsrpyAk4JjoVEnbcjVCKJNIX/TO94qP7UxyaSPP?=
 =?us-ascii?Q?S5g3cscVX4Wv7vkuUavRnd5Ml/GnzSLGHWAIzNQ85IPDAe6WdH7b9iCf+bvJ?=
 =?us-ascii?Q?Lvuwk7ZLoUOn1HNE2GWCldEkg8N+rWDMhAcM+lcMepjmcEt1j2ONcScprFsb?=
 =?us-ascii?Q?W/GC2v0fZGuUSstYxJXrdvtV9Du+mcyLL00CGb1HB6O8cbrYmIGg4qCW9Ljh?=
 =?us-ascii?Q?qt9oxIQdRORuhgbsGXrFhYAjujl0ZF631lCeeWenGN/MvPo1dVtcDGX8YCMP?=
 =?us-ascii?Q?OzpKpgRxP0cgNDY0Wvo669vSWKTn1YGw6TcUPRBqGbziWZDV53CpNRwVhuEZ?=
 =?us-ascii?Q?sPKwx+QC3kzH6f2MkK8ffBwrb7Hbp/0znQLDDf7kV5aBF5pNXoS7sgb3/eEy?=
 =?us-ascii?Q?GwtXGBoXlHlKsChSWvN49jrvjgLMZrRrAk9rrJK3IcNTo7TbhpI5MEDZn8R9?=
 =?us-ascii?Q?kGP3+rtis2aWSXDOYQZ2ohHIKv98i0eav6dIwaIz9WJV151xNc3NXIecLp2d?=
 =?us-ascii?Q?khHFephvGyZh38rDKUgSNBSArQufPyHL2lMbK49ZyFZx+czvEtSUAXHWvPoE?=
 =?us-ascii?Q?vE+AcquaPqo/LF9J5oJ1+HW6dYoMaBZpmF2ynzkDPySi6uxjdl6jb2OFAZP5?=
 =?us-ascii?Q?0PP+dnXUmjPUpbcZPVQCnfzZn2vAej1vPbFtcxoGNcN2VzIdKBhrXwhQky/b?=
 =?us-ascii?Q?AZJirLkuAFIDGGq6+Th+NWBfzHxcOl4eDk0+C/JpHYsTV2WUVSEUizCEKWGV?=
 =?us-ascii?Q?NaxBFgeNwdtZof2gdFg/nUQSP76ymU/pHTNWsIWYiz54G7bXKgdIEAL5/LV1?=
 =?us-ascii?Q?19WTVGQCcCdTo5FtyZKSvqF0oU87HyY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tCnA0uvTwlULjT94IqswjCsxFmxdrp+vNH8mFVRHn0JiT2iwrvEFWbyVUGrNeoQ4/495GdW4KdHcB2t4EoVqWEYPUjTL1PVhuGGVJUqLFsxtbBeMXqw1ORmEfQbTcq+TFBen4qsDNSoKIKUFKkIaHfd7e/dmw3tTOhzZWSJil677gSBagSIqSv9m18qQouYQF00TFOtnZyUWDJvaLvVUhSY7/o+89SXVvHnciJ9rawkmYKwydGi/6NEHlKvuafjZq6aBS1BHbacGDE4QFNPjJrXUoLVlfq1DzgkpgDAFpBUdcJIh3nZar2l5hmU/VR4/Y17EuDlhT5k+yDIXQErCG3K785AiP/tY2U8qyicEAshYmm5HJpLbnuZXuhKLW2KfVxWWqs9LIW9EzRrRcGuM2zdOFSfiMt5dYcUVbX8P/vc4Wnq4k0hNgeY3PnTLGdr/DuiR3NfQwlYgE15V3T8QpYsv1tCRqEcNuEuw1uwyZ9JR4WGGAfNQy66jp+jdisY+1sM9ISV9jAzIXz94+O08hVTYi8gG/A0DAPn1AvAIWooidN5bu5iL4Ev6/VfN7BEuNN49KLHHeziW8XGRWYjAi/7V3XI/lwmkUihNQECQIbQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37953f0e-8339-464f-8d64-08de7483bfbb
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:14.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WEP2/pIS8ApO+ESUdTfz50+PLJGKCVAyE129JO+yrtBnI1ZyNrkiquA/wh34jVXqHY+RvbgNTG2cB6N4GS/Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699f172e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=8x3ov-SK5ei-yyGZOyUA:9
X-Proofpoint-ORIG-GUID: IOwNfs-iiaZg0tvHM0ZIP0-GW2_UhC46
X-Proofpoint-GUID: IOwNfs-iiaZg0tvHM0ZIP0-GW2_UhC46
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX2yGo5ubWr9Wg
 XvxbOyqclhVMbSvtqsu9FyW/NMw/LVsl/96wvHOOO0zqNjiuLGGx/HVeWUaYzvKUAkJTGsVtOb7
 EyrcfI6qmtIoOs1eBFwfbAR1gliOM/XWky34DU2MgZe4GBXb1t4DetBwNHE8E6OEawCH+lP/4Jg
 sqpd4mqbGK1BdaJ6rLMPbP9xbUZTyfRKyUJprWkcPkQ3j3fUeH+ZhpeZJo133IIZkjB9WtO4RJ3
 JdbNuiM5Os8X52B+1T6919RIsJfjfJqM76XAeeq1JAYv6UZjAlonN6D3uD2H43xDhJpWvhNVyoO
 UGTyVBtiOBxBC6yKShAmJ6F8F3gIryw/v4ajilX0CNqor0oXaSQYk3FQ5E8SHttJswrEhMys5Z6
 cJio4omU/5AaO59KqFXY/LasOjO7LkwRKKECIfJgPMgxzhqc62hwgE8sKYfUt97SYfKF0tqKVkl
 yGNhsu6NI9cdeLvAcHA==

Refactor each PR op into a helper which accepts a scsi_disk, as this is
require for supporting scsi-multipath PR ops. For scsi-multipath, the
multipath PR ops are passed a mpath_device, which can be converted to
a scsi_disk pointer (which we are providing an API for here).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 88 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 71 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f50b92e632018..cea3ab54c4417 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1958,10 +1958,9 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 	}
 }
 
-static int sd_pr_in_command(struct block_device *bdev, u8 sa,
+static int sd_pr_in_command(struct scsi_disk *sdkp, u8 sa,
 			    unsigned char *data, int data_len)
 {
-	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
@@ -2000,7 +1999,8 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	return sd_scsi_to_pr_err(&sshdr, result);
 }
 
-static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info)
+static int sd_pr_read_keys_disk(struct scsi_disk *sdkp,
+			struct pr_keys *keys_info)
 {
 	int result, i, data_offset, num_copy_keys;
 	u32 num_keys = keys_info->num_keys;
@@ -2021,7 +2021,7 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info)
 	if (!data)
 		return -ENOMEM;
 
-	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len);
+	result = sd_pr_in_command(sdkp, READ_KEYS, data, data_len);
 	if (result)
 		goto free_data;
 
@@ -2041,15 +2041,22 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info)
 	return result;
 }
 
-static int sd_pr_read_reservation(struct block_device *bdev,
-				  struct pr_held_reservation *rsv)
+static int sd_pr_read_keys(struct block_device *bdev,
+			struct pr_keys *keys_info)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+
+	return sd_pr_read_keys_disk(sdkp, keys_info);
+}
+
+static int sd_pr_read_reservation_disk(struct scsi_disk *sdkp,
+				  struct pr_held_reservation *rsv)
+{
 	struct scsi_device *sdev = sdkp->device;
 	u8 data[24] = { };
 	int result, len;
 
-	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	result = sd_pr_in_command(sdkp, READ_RESERVATION, data, sizeof(data));
 	if (result)
 		return result;
 
@@ -2070,11 +2077,17 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	rsv->type = scsi_pr_type_to_block(data[21] & 0x0f);
 	return 0;
 }
+static int sd_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 
-static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
+	return sd_pr_read_reservation_disk(sdkp, rsv);
+}
+
+static int sd_pr_out_command(struct scsi_disk *sdkp, u8 sa, u64 key,
 			     u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
-	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
@@ -2123,41 +2136,82 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	return sd_scsi_to_pr_err(&sshdr, result);
 }
 
-static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
+static int sd_pr_register_disk(struct scsi_disk *sdkp, u64 old_key, u64 new_key,
 		u32 flags)
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
+
+	return sd_pr_out_command(sdkp,
+			(flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
 			(1 << 0) /* APTPL */);
 }
 
-static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
+static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		u32 flags)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+
+	return sd_pr_register_disk(sdkp, old_key, new_key, flags);
+}
+
+static int sd_pr_reserve_disk(struct scsi_disk *sdkp, u64 key,
+		enum pr_type type, u32 flags)
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_out_command(bdev, 0x01, key, 0,
+	return sd_pr_out_command(sdkp, 0x01, key, 0,
+				 block_pr_type_to_scsi(type), 0);
+}
+
+static int sd_pr_reserve(struct block_device *bdev, u64 key,
+			enum pr_type type, u32 flags)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+
+	return sd_pr_reserve_disk(sdkp, key, type, flags);
+}
+
+static int sd_pr_release_disk(struct scsi_disk *sdkp, u64 key,
+				enum pr_type type)
+{
+	return sd_pr_out_command(sdkp, 0x02, key, 0,
 				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_out_command(bdev, 0x02, key, 0,
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+
+	return sd_pr_release_disk(sdkp, key, type);
+}
+
+static int sd_pr_preempt_disk(struct scsi_disk *sdkp, u64 old_key, u64 new_key,
+		enum pr_type type, bool abort)
+{
+	return sd_pr_out_command(sdkp, abort ? 0x05 : 0x04, old_key, new_key,
 				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
-	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-				 block_pr_type_to_scsi(type), 0);
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+
+	return sd_pr_preempt_disk(sdkp, old_key, new_key, type, abort);
+}
+
+static int sd_pr_clear_disk(struct scsi_disk *sdkp, u64 key)
+{
+	return sd_pr_out_command(sdkp, 0x03, key, 0, 0, 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
 {
-	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+
+	return sd_pr_clear_disk(sdkp, key);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.43.5

