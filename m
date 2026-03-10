Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABE2389DF0;
	Tue, 10 Mar 2026 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143402; cv=fail; b=A2QqQZ+yMMZxdbRs8IufTgajOiobh78CQLrodu1SIAUE/AtfHWrh0+efpUXnGgvDgpM8Vb1jjCYB7vc8ed3pdFn3UCx1SEpomPJDALOUvaYUGtZKHqsFCUARkB+80xGwzqfRyzbJ0l6ruSOPJ4vYJ2/50dBmcIM+B4AS5WIKWTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143402; c=relaxed/simple;
	bh=9M+9w/7CyQCXWwCIIHDiW1VDBLJO0rrFLt5zMtCOaB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fW/GZJV82jbf2ULwoZfTAzfJm9kvotLqsb+pE57boDIL7/rX2tm+K9qyRXUvC+Ni+Rf/Y46l4GH08NhhXkfOoFU3PlPlTTLDiFBqDbHs8kPDs34FkqRAtM4Xj2zB7+sll6GK57QkjhHcFXAhXzAPpJ8BUgiaw26W8dKw6q1MDsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZivzrpSJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bhpPBETU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZivzrpSJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bhpPBETU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9x68M2773031;
	Tue, 10 Mar 2026 11:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xAbkqLrf+uC9Lx0N220c6MkeLQrExdg45lJWiAHXKyg=; b=
	ZivzrpSJcePEcNt9kw2mLpUWQYqi/JaAS0MipmsN9fM6haVm1TB55wvCHIJRMO7c
	WRV5ARlrvk7Ee9L66QpOAVRMiWO5y0P98oCtA37wQIB7CPSvtFNQ5HMfS8DOTe3t
	VxrPh5c771EEsvIGfsmTPDHYu33oRPf+VURFWAyUgoB7GZADKJ/6jfgYshn0Uj8a
	IXeUAWvBI+80IOHagwC6fAjOFIQzqigbQcZATofMbGyq74jKsnRq92PvoEg922XY
	XG//4JAR/+CDvysm/B4mgPncVUvlMt0FDHDKRctKkl45LUUU2764+gM5wMoIJKkz
	rBOCdW5KY0yiAYUrVZmxfA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csjnujpag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AAxAXw014780;
	Tue, 10 Mar 2026 11:49:44 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafe84yn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5kACnJJIp34/osWHF8PBuL8oopOWzAB1sVfXghRQkgy6Vs5Fd6WviqJqJb6GikwDQDIlOhPrBlE+JSHqhHBneJwCZpOtdE+T2p8wvYgCupG1hTehe4pyLQ8pav7QtX5ISgpBEFfZ9sKB4x4D2ftPjkywpPo/yxEi9B1JMp52Heft1PHPW6cqqBBOxsLU+U+8s543uR7LX3Shpr003cf5YVUWWJZ4EIFfjS2LlsdX+g+IhKGiz1QDpvhtu83IWVaviY9ySYG4NlOgrQv2RlTQy4WnPIDYyD3SG+m2HDpIcZ1Ic+cb73D0pCT+PKqShRpjS7DEcuNt3pfT7c+Po8dFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAbkqLrf+uC9Lx0N220c6MkeLQrExdg45lJWiAHXKyg=;
 b=dPISEplcqYXvoa33ZC4poVFXQ/CjdOspC+lnq/h2O3KYq1JhZDccBH59+RIPUH0RPNs973RYz2V1hflnUEIteW7B2Pe4IzIfDkReTANF4YhlwIJcPEyhrZmVh2FFtOE7RL2cYv0lM0ufn/UWEFh9yHijfFBbm75rg9tIiwmhN9Nop1LBzq1ldyKkRwbwDtj6qDNlSP+eCwvqc0ALXiiueX9zIA4xSs9NxXkpcgGVfbNyg1yncCOhiu5fLjOeXvErc4LZ/HPoJJ0B4MUQ6mlcvEJS8a5/P8d92OZewhEf9Jj9/BBrzUgYY8jXaUpytuGmN5AwxhVqo3p6ss06rxAcSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAbkqLrf+uC9Lx0N220c6MkeLQrExdg45lJWiAHXKyg=;
 b=bhpPBETU7yHpbungsOb1oM6EnJ772Xz4Ix5o7NOhsjJpMLdDjenjPKnulRM9C3AdEg77TwDD/+T0bFj92U1ZD+Wq2ZnP7zi9N3c3f/9HCAHcZPps+rkcQJuyhwXFIjue3muMNqjIFIkVyqhTHqcYXs9x0DBgk8MSSnE1Hl67SF4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4519.namprd10.prod.outlook.com
 (2603:10b6:510:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:49:41 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/8] libmultipath: add mpath_call_for_all_devices()
Date: Tue, 10 Mar 2026 11:49:18 +0000
Message-ID: <20260310114925.1222263-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aa3367e-133c-4d13-706a-08de7e9b1db2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	MActuxkEp+WqI8iUXY7QZsRpO8g+1dyOGiKNd4XEUQA7K/XttatO/7FNjk0PY9Iwdo8fnQfvMre0bddpPd+HOxY/49Rm94IWXyAEN/TiSnx48QDZrlbe4Jst95icuXpWZWbpVp9N+JQq8ZkjjkMV+tzzuyctaWrGYbRDMj51xGXXeE6aTaLk4mZzYhJrX2h5ftcZJitYvDv35dmFOjexKO6+0KY8RAqf0Db8SbadnX9NaGFx2sdy5AJg9WJwe4N9751H9hLhQJipnqzkW7n0nxa3X0LHFJB81Ug8xCERlZH3/BawcUkaGL7QpMWjPIbVugIzX1Extk0Eyk7MfnN5m6zUPmSS8gCMF8U4qky8dJFMf2W9fvQnMBNiUHpE9Zq4khI7mjEpUjMEvrrJBjZcJsPl7Vo754wUvGS2xQCqefdmfQbpCndYJgpUq6gkQosEqbmZ6KOTGlY1Q2woiXamYwoTu1mRoKIsNvrnS+Cu/Tj+97ZGYc2DQFYbv6x1QBLdKjQNQn+YqKgH4JZlKzxH6SKUIfLvk+/kg8kxKzY3ebnZbhrrYOHjOaw4ktJIX4ppfU/tIp8p6vy7g7JumfUN42Xi0aVBv4eVmwnNMoOY6uR1X/jKPph03dooCNkyHk0XXNWZcFMG4rt3q1rJzKDq1X89+uy+HV5FQ8WxCWmVdaGI4mAZDVx0554hsWPKjiMx6Rz8IDmuhBZzGh8E4QLPTqgninTOgcVp8ZrKu/NXHWU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JrbyVYlt9TN7PHtCSRa2sFvR1neTcXDUkLWWEhQOAdH23mSED0hhtP+9Y7EH?=
 =?us-ascii?Q?I2P7zkTlH1Xg/oL+O3Otygq+JhhQGWnm3jYo8NjBuMb4wmj0gX6bVQQOelmL?=
 =?us-ascii?Q?66gTtjnBdVlcr6SWKcw96j9Z6pkAdMkw94KAVTr8HdqzSPXc71vagyrBbhWs?=
 =?us-ascii?Q?pFwjugJZe1NwnBa0Uj4OIRruRTCs8O92jVJOy8B+kzmrfsuYVqt+A1vzm2pg?=
 =?us-ascii?Q?l5is0qaSA6RpmIFL+558FrkhRr8GEqvL3P9I1h3cfoqF95/0EwMjC/tgAT9E?=
 =?us-ascii?Q?0KF5BRZiCL88TOg27zLvJuw5KzrdPHpRZjpgd6XcCnGamtV/uCvPpaHoqCCL?=
 =?us-ascii?Q?KY75CqxvGBg8eqBjZkP01XOoIlfGLT9KJtxIM07d0BYIanGuBQ9tmWO57tl+?=
 =?us-ascii?Q?8AN0YYu8XWxa8NXriDUegVdw2GcKJbuDL8P790npknC1kLyuJrmmSf9qFT/9?=
 =?us-ascii?Q?BN0QYFpvXCf283uE+/zftJ2mDSh1BLjy2TlAIgUpDA4g6NjRT0GFV9cQcrz7?=
 =?us-ascii?Q?jrEw/anWtUoyiWzEEyKnRNV3W1cO3Pd9CpS1feaJa+9t7h+iR1Jfre3pata9?=
 =?us-ascii?Q?D5ZD5Fie1L7vUP72W1/r2y1dxZHxdKaqPQY6T39fVoaSmHiCUYfYTuyxEMN8?=
 =?us-ascii?Q?PT/noT09FhywTQ94nLw9ea507H7PIa4vjoyWY+X0EokWaed7fr9xOeFo3lmn?=
 =?us-ascii?Q?bkKuB2AviWRyo7SDitJRxuKolJONN0WE+JI21c/chkFj2quCQxiJrPAESHei?=
 =?us-ascii?Q?I7ibnXIqgemEY24cOzR5XWp2XBU1G6rGNyksaxX/WFX1oomAIOvLnEFWcnju?=
 =?us-ascii?Q?XbVCtUTzZt7hNbdbeXmWQHZHB+7NA5fjBF9o0LG1Yg/W/iG+ICwijsoiVbgU?=
 =?us-ascii?Q?etbFzeHhqw18bGB/3Wrexpp+t3uxu6Na5jyw8+bij5Euf2onm9S9Bp68qcaE?=
 =?us-ascii?Q?rvccdLUl+p2BX5s/jB5sqLA/IpEWBJAa62Gh/NtpAoOe76MCHr4du4b77Aj6?=
 =?us-ascii?Q?3Iul/U0xpyaKA09FqT/gHjo46a8S9s4ivnRYXQeMMhm7PTbF5UL5/4CwVdO3?=
 =?us-ascii?Q?aeXxjChMGd1we5C5NLbdGlUMnHvgpXuTDFJlB7MmSDz3rytqTk9sSzE5s79q?=
 =?us-ascii?Q?NwjAYAOdf54/+5Y4vrgCVhDH08Rn2Q16k1swzMgrRTnILSA6j7Ot6FmdlYJa?=
 =?us-ascii?Q?l3awae8whg7nWZaUaE29VoXdowR/XmtRMaRk6xtdladpghQspkBobeFpUINF?=
 =?us-ascii?Q?bkaFmVZc8rBrymMWX6UPiOwlrXlW9iUx6YbSmgacTXrCMpfkg3e7EVn7cdCH?=
 =?us-ascii?Q?jBpjCw5MlhKT6Xvh0e1QZ+8vf774t5J1b9M06hZ+miJRR8fToO71SpQYM1oU?=
 =?us-ascii?Q?f6VunrV+zknr9o+MVG59AqPfwrACvsCPLpAc2WzxWABuIjNXYsD5gOkm7uBv?=
 =?us-ascii?Q?xuSIIyXA+JyObdNQz5Wh22WJiRTAa7ia2zfSXx0OZNdUG0+tf4Y6KUx8Lrso?=
 =?us-ascii?Q?iyT5WXF0xy88CK4o04gZyetA1wx49dgTtHBxjXGMkPFAJNBTm0UZ8Awfg/IK?=
 =?us-ascii?Q?NINl5ZhjlLZ8a91ggPoNuFkWuwPdXi6TpuqCELmMDqVAQ7vpbof8EFpUHCY1?=
 =?us-ascii?Q?KLBl/MtPC+lUe4rakZ0WX621ojJxgytfgIN9Ht8+a0dIlu47Qc/UcHYAOZcq?=
 =?us-ascii?Q?vZ7l7VwOKUVrVDSIdOpKTj+CwwWTaz4k6wlRz6QBhhp5yj8rp+/6NnjrQ0Rw?=
 =?us-ascii?Q?DxwGJS5yeAXl81+EKDqcjjoQdhir75E=3D?=
X-Exchange-RoutingPolicyChecked:
	IQ39IS6VEx6TcdIs63xQ/w/2v8s54+TjwH+SGiFUzFNmofqu7c/x49OvYVdIku98fY4rNvt0BZG6UCX7JcDOzJ4lZATfuZVTwGma4HIOuJsyDQH6twRod4+yeWRYIs8TAv1ZhWPFr1HCWlP0Fxe7JmnGsAaHEWVsj3lO8BtV5hVMDMEqX2DNZWTTZjMjDXyqIUm++CWL0hsWLXMWPU5PJxNVP50YH/gkoO00SD8NSB5oDsKDQWzhRu/0STogCDphmmuJ2EmAaSAxC7CmtJWgsOoIuzs1kmx99WKImxBlQ5k6ykjXeLBGPViWG6x1rGO09TsJ54auDU5FtLtleyXTkA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a4KrPkEipR7WzCzKEkk0H8P1Te92IlU/5ijPRsY6ULCMw5SW4NICgiHKCmtfRQstxZVMp3UKgeWcIi8xFCp7oF3rbAGLvvBPn+5Z6HXPDUjX9XAIK0lUPzU8rsbqihBwtSXAmq/Pyp5CzrcTdJQx3ex3lyRtJSnf4cnPsSKdZINn3g5j3qXynoD2pXwxYdYqpNnJVWI7aOHuuFsQc5yvMa4V8qvcallWDGhaGZ52PzGHOao3aKa8b6C11P/OiM3qBfR34jXxc4vjffC6r3ML2ny+shxcxoFp+m7h9U4arULSRku3/4GUrlOvmQVQx+RTjV+GMP4TOWtyZPK+ks5IJ/5JipQjNpQIBuGvb80DZ0gJI+w3crdvjF4/EOfy2gDJYSplQRuJPPSY04eO7WvmZfOMtZmx643TwgJfUpdtAcA/C7/1AZX86CajIB21NWrVhCYiSd1JN8N5Tgs5unLSEGLewihSFT+6cY40pYyC5pttc5UxhSbNMw0Du+QF/GphWl6T0jE9WKtAkEaYaC/qqXOmAXKezMbajkoxvF+0CE9VZap644voualcfRzMLNqimCbOPtA7skltJhdjdwp6lgnMLTlKR+GUQX1OvHztiX0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa3367e-133c-4d13-706a-08de7e9b1db2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:41.8016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G39gUvSFkHorckmHL7DmXpVb7WgFd2N3/mH0qp7H54HzqlC/LPqyqUUU1DyRZcIrd8uT5rr/AFP24A5EvrLqfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Proofpoint-GUID: QNhHc8aChU6qfAoJEb-sJ2fxhVqJEMSK
X-Authority-Analysis: v=2.4 cv=c7WmgB9l c=1 sm=1 tr=0 ts=69b00558 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=hzjjRfHtLLWBCNXZrtkA:9 cc=ntf
 awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfX81OOlcemPlB7
 pQ4kWjrTi345A/a4x781TIRxBc5c6QjjRZ2KFVCul74FO3WevrKX9FKyTJn2hrn/uObWMA/8GaN
 KUsjW2DHpog/vwAcR8oVKf+K+TmmGOGIeMrRFV8Cc08KFg83SI6zg/Q+GgscrHo4OmJvFiIMlvW
 MH05tDYPs8+RsmTs6g8HF6xrSyFDaeUQJMEHOy1WjdIeZ8nl6fJwdUIdqw1EpqSXlsL1R2ovj7V
 gyIwN1wIK5q3jk+ew1/u5DuI4/QnS73YlSBWMY9y+TcLhK1TiqGPLP4Cd58cgaUWWPu6PqjLFdm
 ZhBKWCgDUFgJNadvD5dd2yxWlZ28OBHT+qSCm8JVzDg70tPi3ekpChFTXHTKBBwDruleSSULH7d
 GiWRsI8erKtekFOYKHatkGUBO3P9/kooFTlte507FPL8aD77HxWxNDYS0GdvJgC3i1IIE8NsQ95
 MO1r5hafp7dUlFncK0sX3M9QuNBkOLIV+k/MAKjI=
X-Proofpoint-ORIG-GUID: QNhHc8aChU6qfAoJEb-sJ2fxhVqJEMSK

Add mpath_call_for_all_devices(), which iteratively calls a CB function
for all devices.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  2 ++
 lib/multipath.c           | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 1aa70ae11a195..153eb4c0258ef 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -153,6 +153,8 @@ void mpath_delete_device(struct mpath_head *mpath_head,
 			struct mpath_device *mpath_device);
 int mpath_call_for_device(struct mpath_head *mpath_head,
 			int (*cb)(struct mpath_device *mpath_device));
+void mpath_call_for_all_devices(struct mpath_head *mpath_head,
+			void (*cb)(struct mpath_device *mpath_device));
 void mpath_clear_paths(struct mpath_head *mpath_head);
 void mpath_revalidate_paths(struct mpath_disk *mpath_disk,
 	void (*cb)(struct mpath_device *mpath_device, sector_t capacity));
diff --git a/lib/multipath.c b/lib/multipath.c
index bba13b18215ee..96c6730680729 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -105,6 +105,21 @@ int mpath_call_for_device(struct mpath_head *mpath_head,
 }
 EXPORT_SYMBOL_GPL(mpath_call_for_device);
 
+void mpath_call_for_all_devices(struct mpath_head *mpath_head,
+			void (*cb)(struct mpath_device *mpath_device))
+{
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		cb(mpath_device);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_call_for_all_devices);
+
 bool mpath_clear_current_path(struct mpath_head *mpath_head,
 			struct mpath_device *mpath_device)
 {
-- 
2.43.5

