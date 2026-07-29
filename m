Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FB546DFE8;
	Wed, 29 Jul 2026 10:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322389; cv=fail; b=EdeRjUPQuz11MngCDluvpYZT8aRY0baNVAV0gKTq+Vxy6La1b1Z2WywGOmhOEVOzhkXrIWQV7tNWglUnHIjxkXVz1037wpdHMK4ZksoIfAnVLPOyhoejUknNWi6ta5do1lVFlQGSsBYR0oI03ARaNjOkXBcQanl4hmjZmizU4o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322389; c=relaxed/simple;
	bh=+tALX9sWDlvpFY0RMRIV2Q4RPgD1rccMWkoz5MbnCXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DCRSXswClU00r1voP1shK442cfOmFC0y302AX9fdTjRK0UtVRoKKH/qnOFVBI/i+nghQNiuFzzrOB7XamCv/Wn4TY9GsgO873mZNa95D0tb1vtVqwStjDhNH/6lcbEPkGsfJkDCYo//6d11yjnMUJLaFblwz1oOQKPuj898qv+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sGJTJjBO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lWbQz36I; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sGJTJjBO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lWbQz36I"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TA3d721074546;
	Wed, 29 Jul 2026 10:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JswCgC9bYrvyTaBQ7NNy+cSqdgz2WlFT+r8RReVFahk=; b=
	sGJTJjBOdI/GSsSonSc7WUliyD8t7alDT+56fMhkprnXcH2NyKDRyhmYP75fOwd2
	8+eD72ZBhQXjOvBFphkR5jW4JG+L7ve6yNsayuWMDfZxgS3Y8kj5ez1P8/WlxkHK
	alLqPUjekEqpuvCF6wATUjT188RwGvw4DQkGpWtq5otkZLgxS3mTOzCnKIBm7mT/
	ZLSaoEtSMTKQbP8uHfPtQuuaSbkypsug6w87ZyDfU0fDrD3tJihkOdOv3cucrVcT
	DR141BzqNceEnz0rFVh6qj2T20O2nt1ypV3cPMMTPcAlFwUVwdAsH0ENU5eLEgUo
	cSPQG8CCHY8uJMblkFXytw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq5kdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo6SA029959;
	Wed, 29 Jul 2026 10:52:17 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh882kkh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AYz4C5KYY6g5Vx550KZDhtTWZNHkS8eMEmM7cyuvXw6WEIlU5Rv7KT4gz5ig2GCIUp/hN+acKARgkPQg2qYJbTs/4nSvMEij5E7M9MVJecW3dO8rp4GHCU49rgOFleimWye+Ra0JHowefzFDzAyttleGnH5q5XaqI01p6lz9LDq0cXzGi6wQ45Tm/IHOpE9xSht2I21fXWVZS0jD5A22zWip7maxzLXdylcH0YCwxnYFpvGkkYblkCfTz2WG1lSesdJuWf04Ke6ApV4Vi2mQcDKDD81tdn0qOHTWesUfND0+qSqZcwGpm9chMLbWXU7eKy5cueLrn2oZFJ4cEB66Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JswCgC9bYrvyTaBQ7NNy+cSqdgz2WlFT+r8RReVFahk=;
 b=fYDZq5qrJbsVS45xLYNx6I3qnJCkswulOq+JZqmYkuLAJ4kjUwahUCVNtSMEMxdK67ei1an4NZyz9JLcqAdY5JI8h1HrbFWFcxsfChluFfwZiWX05YJ83OrLa6q2HROfbrQ2jrpQgXLOgKe6obAHx7zh5B+/G5QcaNISi5WRRHFndHYP77cmCu3krxAqObCHu+8PfR2BHxRVMOMgVxL2e5SJTlZmYJOBLUKcm6aPAwFxCESi7QFNPeIzyuXM+z5WV/0JQr/wLmKvY6xnwFWhPv0WDPfnJ9a1uc7iG3d2iqLXV3bJ7Eg3fYT4H4BJj1CRrxLRgnhWsVC1VDAs2hSClA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JswCgC9bYrvyTaBQ7NNy+cSqdgz2WlFT+r8RReVFahk=;
 b=lWbQz36IXSUiDCKafxNuIv6R10edtycOusxsP5KTPgN4IA/DeGpKzt9m59elsd7WvjZBY3xVFPoa5JKu0dg7+sSCS2+MyiCksSDVvuz5ftg3wuKEQ3zBLw3LtAGUhh2VIWdqJ/m8NTjPx4fvZnB4yHPhmM2qrumNPzDDHMBecnI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:10 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 18/27] scsi-multipath: failover handling
Date: Wed, 29 Jul 2026 10:50:58 +0000
Message-ID: <20260729105107.255712-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132EA.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::2e) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 991b148f-cae7-4a00-692c-08deed5f7073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Jmhcm/WP3OkCH2W8UtraSknnRnkVzOBNdUyDKeiEfKRKsh0M9EXmdDYYxVS0QI4dTpDt2vinrJKWGa1uzoFPoKNdP3DKIDUk4oBrM74fZUTlPMUC5Eadtgp6dD88PTeU0yDToW/1W/y2PH1aeg2hhXCW64iWaUrPkROPRW3cUPzpXtSHypsrwLb1XjRC+EVmlJpAccWhssnOUSPNDTqBW3n1SVd9wSvFmWEI3Fw1o7YE16YPtsGa6gEN34/Xu7ybaUNFG7AoZ7kbNcSdCr9KTF+eHKVOSWrYL1n3DiSqbB7ilUOO563B/sO+dJRn0Ol2OsxBr49hCnwHTc5hRqNky+1VZaQ/JIW4K6r9wpu1ofA3lJdZesImDauHOH21xxDBb1UQTu0Ft48PeFL/oleo5lZGUq8nq1n+Qv6Q6Jj9B4dsoqZjRy9n+kP39hSa+QkKWiLgZxe/0++VmUdhrIJEZodijG11dzQ+2W3cQClXwkH0Keu3fVvGVj4EZRQUl59OgAoQ2phCBLFernPVVMlGUnH/lirdrTa8ORX5ycLwNQKWM4rSWU0ooBWF/DmBzJicfdqF1YG8nkeqSSvlDetfPCpmbF1b+FSeBi+44nSey5gZetbrP41h+6F7ZPgfuCQ+vQ0m6lWerbxQj4z/qvyVzSBWTKgXaOJZkMbxR0gzYsg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aetSH0KXHfE7mgDVaiKwBeeHvcMhoO8D75q+r11troegdqntNmz1HznfJ6s7?=
 =?us-ascii?Q?cxAU4hDmuy6Hv+cIH96gSoeL1kwbDjqnbBNnm6/8Yo0f50H3CUJvq6hIsRIz?=
 =?us-ascii?Q?5Ay87UgkmgEzcb3jI4OGmDFuhQeJWuYeu4MtCvf2Rs0gwL5imXnUe4shAoeP?=
 =?us-ascii?Q?scqnZiYadAo8n9sPdCFX2i8sCbf+IAHjrWnjA/3PApmtkzogT+evNX/I79/5?=
 =?us-ascii?Q?dTiM5nnBODNhvTrOoxyvmYaRiaiUY96xfyWhMaW59PONmC7MmpORW5DA9MWs?=
 =?us-ascii?Q?7g2fLT2Y8+2LocUQIYwMknfhfM5gjVNczNsHE/Lxwi+J6+aH5QCwxDF4tv2C?=
 =?us-ascii?Q?K4rJBlOGwINKIjZOSViRAkXEhHNB/9PV/9V4+Jkm2dyUjfL7P/dwHB15D880?=
 =?us-ascii?Q?4tnfE5NWnILfqoTiovfqaCi7AS+9kpoG003XrvxTXt41e/P/ToXgB5hb1hXq?=
 =?us-ascii?Q?ncx8cpu0ZUZR3v9EEvEVGbNlcyHH2zYMl1jYzokktyTQaFo1rfR52qWGg/2T?=
 =?us-ascii?Q?4jufBxvCeZ6QOU/ZYxrjsaQY84LVJn/JTSuuoeo3ePPq1wAHjIb7EnF3lYxq?=
 =?us-ascii?Q?WjGcKt6ra+REQXhdyY8isbQFQif6KKUSiTv+/BVUI6BraOiavSnPawHIPabT?=
 =?us-ascii?Q?AJWplQcFwTiRmKA6qdcabwOOeYlOWLGUqKBzYadgXUADeIYR+dN2ciAsXc5y?=
 =?us-ascii?Q?06rvnFe0HS4b1V7R7Yeh7E6q35cK81fday1ffDatppJRwY8GCAjVpNPM7Q/v?=
 =?us-ascii?Q?6IRim37VMr+ka272BOVvdfnDiDvlCeN/LqvQWYJiDGrgq+gRnE5WZxkdDLfl?=
 =?us-ascii?Q?NYOSYXPsZQl2BJvBnz5ovrLT6AR3LNYUR4RUc/hKTTsnfZanmp9qNf+7/Kn+?=
 =?us-ascii?Q?3bBsh+vLJTGREiw0pHPcl8JLZG+EKcijqq0AtXa6n94USqVDode0FZgnvxFa?=
 =?us-ascii?Q?lnVmnXC7tL6/5pzZuTGEKy3R5l189jI1w0JUW+ChFvJ4NPKg1URpStvdhlpc?=
 =?us-ascii?Q?+6RHky1Slwv3nxpoKOYBkAoX2JSsaER6K7CFZunyJcEjVdQO+qd+HcrX+Akz?=
 =?us-ascii?Q?PSTItRhCrcTLCj4pB4847DYSGTJBEv/SyOVh1GArL6xh1RUfbaDMVEOgYJlu?=
 =?us-ascii?Q?DqabAYXx4HmymWR9jttwaylzk7a7LWD7H0FDIdSmpENf5H1OnDoc2MluTcBg?=
 =?us-ascii?Q?DX8Yd/5ysp9FCoymMJLlpiHWlWn/NicdrgXW6tBXui11PjJVoncchluUgiwI?=
 =?us-ascii?Q?s7j7qWCtvgIgEF9Mx+M/+GJEXD2O6nX8X7yqtA6V3HCXfoQ2X+UrulrD3OIx?=
 =?us-ascii?Q?p15JLc8L9Lcqn0zuuCkGKMnJpBvEQRPSr9p5b7MqjmpOpLuI//NZbeb6oMOT?=
 =?us-ascii?Q?XlLHa4v9q0uniooS+PFthgexJw43+Sy5u6j5z4b98x4K4oxLV55hJ6AkrYWF?=
 =?us-ascii?Q?lDDv+4rH66ybZWzIKmjLt3AswzUCWq81B2YJJkhFVZ1SoRV6Ozak5PYBC/fM?=
 =?us-ascii?Q?/MiCHUzjtruTlKfGNM/wGObBMv9hzupfEdp93VQNuaSO8RTPentbu2gsE7+i?=
 =?us-ascii?Q?5EHgN1072E0unbcQ/+QXp6mbiHjCUh3+dEMEhptN+bkMR2wMc/szdO6wNlx/?=
 =?us-ascii?Q?gBQ89sU+BFQ3iyoIIOmEyEFIW5tLHzNXdbXYdK+NvrI9YTtxwJy+DwFd8i+O?=
 =?us-ascii?Q?sJtfT819xOOyxyYoyTGvirsfkx7663tKOwzqjlpAn+G7Q6QyCUIm+rE0K5Fm?=
 =?us-ascii?Q?tq4Vr6LgPA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Cub9CangaLtry8e/9Bg1FvmwMiXPfw0QnBkoJgVji5SDic1MS/VsQgyS1QGSpZdXj9//jodEANzz8ODRQcKdk6+ot+U7MQpZU7ITYQyHJi6lBd2NHFI22TEpddFip2XZpqBaCiIBmhLHtfEnYZwpdeBZz31b7aouA10fiJoIq5THKAxAMFH9ldRv4vjbxI+Bvas5A3scX6QA6fAApqyhKcDLNMEDO+St9DD4PkyCT0eZrqyuHjtI6Dc7P6hYyer9+jnzFweq0atRvb16x9u4Vc8RxvtjT6v5ZnSuJ1hH0XzVYzMq/O+ACENHE9gFZX6Cvnc0Bbl4y9vlQtox1ZaBiw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r0U7R7AyRn3xlSnjo99EAUpng41pKt4t8P7e7zTKtNDZSb0j3uFCA69B4VGQR3SZek/FqO1n9GreqxpcmZpDOt4pHmDX4YMS5Q8U+B31JBLFbQ69sI6nne/c5Tyq0aEW1ut3s7vUXBNMlcybOABvmXI6pftPJDUk13+K3Tfw25oZOgYh4iSC9AEhNkU5c1HsyLghSn54XI61HaKFpezVw85f4kFpnP2VBP4Gf90uT/YKE3xN4Uo8fSnsu3kSRrGkbApdZW7urColKga8i2/IaRTlwKNbvr83r0plpKFzh/cBpEu/PMZ2OE8/GogLY4ywT/PjeraH6YmFP7YvLkFZq24R9OQuuJn/AXw4JxyCSL/MdNHF4xgLAHpJ8dDlprp2NiU/jS9kwCKW9TfP5VsWzW6bjlJ56TrvXqWcUYJL8QDNcYy6i57jXrSpitsZ41qfqIM8gZTsAFwnNgXI3BeTbm8ORRfpxwwv+XV5UjZJft4FXtJ2FQHebxMOfslVs6XrIqigR1/f6CEq/lFNxOU6hjoPOqkBguXBxwjpu/sJqGIm1N9ySaBIQsdXWW0uvGvcnZ/qoEfpJCYsErK2GYIpeZJsNpXtps660smHKHEdlTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991b148f-cae7-4a00-692c-08deed5f7073
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:10.1475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OT3Ls8pVD/BllkmEdMCH+tf8hBOp4W9ZLXQn1AnzTXHdceK3O4UAJpa0wj4vn9SBYeg4/dJ4B76daTiOW/vAKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX4FkFAFttgKHT
 7kHibjfCZ9o/kEFEwdMmSW1KYmkDB/lYNcVz2Pb/bvCv2ZgODQCrz1/kwZ1ViYgiMcARQ3m1STd
 OFyYzB1FKP2TfbfUarMly9swaDlFkVGebeSy/14NiaUUbMGi5d/p71eVt4FK7MAAYYTa1ePOF0M
 UgRPKxB5o63hZ+2QHi78jfRhq4s+CRJsAHAck0UWHl6Vxvvf0YZ+PocVmkmPtI5W7EcJtSLG7UJ
 3KY30N3V/IbOftq1XHbBYRBOwhsl7v4yQkrWdzIIzZvbAnIdcoTCTqp5HA909/Kz6L2ErRONrNQ
 t32GyucRhgDhtzOAcdMVkKIdrIE3qQF1ibXxROE2L31zvS528Nes7ni1HzvjL5UG2ISnWkxw94a
 q9nGpF9JASyFB651RijWJbP4njxI7ewquNrApUr950ZbbL3QVfCGcuCq97jn5NkXghbH8y3+SqM
 +8rN0xaTGPiYPCz0BXQ==
X-Proofpoint-GUID: h2wg7a6UhNflMXyeIAnWLNaPp34rNASO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX0EiqNmSuxR+1
 b9yBPlDWHVXnQ7dE0JkMO299tS1wHmGPp9kVw0M+573+WV5CBpyzIFnKEzyPJAtSWsYtpsOXnOj
 WJx2xtgBk4+qvoZE7+SsUBoqsnnFcHPOXVrMtGAtBuojvq/LW1TK
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a69db63 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=KFrTxiSEMK9J-XJLMaMA:9
X-Proofpoint-ORIG-GUID: h2wg7a6UhNflMXyeIAnWLNaPp34rNASO

From: John Garry <john.garry@linux.dev>

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occuring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 12750621a7fc0..6ced89576368c 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -256,10 +256,49 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
                mpath_synchronize(mpath_head);
 }
 
+static inline void bio_list_add_clone(struct bio_list *bl,
+				struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+	bl->tail = master_bio;
+	bio_put(clone);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct block_device *bi_bdev = clone->bi_bdev;
+		struct request_queue *q = bi_bdev->bd_queue;
+		struct scsi_device *sdev = scsi_device_from_queue(q);
+		struct scsi_mpath_device *scsi_mpath_dev;
+		struct mpath_device *mpath_device;
+		struct mpath_head *mpath_head;
+		unsigned long flags;
+
+		if (!sdev)
+			goto end_bio;
+
+		scsi_mpath_dev = sdev->scsi_mpath_dev;
+		mpath_device = &scsi_mpath_dev->mpath_device;
+		mpath_head = mpath_device->mpath_head;
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add_clone(&mpath_head->requeue_list, clone);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+
+		mpath_schedule_requeue_work(mpath_head);
+		put_device(&sdev->sdev_gendev);
+		return;
+	}
+
+end_bio:
 	master_bio->bi_status = clone->bi_status;
 	bio_put(clone);
 	bio_endio(master_bio);
-- 
2.43.7

