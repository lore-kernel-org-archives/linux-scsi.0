Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0F144B693;
	Mon,  7 Sep 2026 10:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778414; cv=fail; b=f/Ih10nmIcUrH1krX3faGP7NbXyqMIjstIwZIzrU/suP93eU/7MMgoFft7S2vcHdO6+tXdwq/L+wX678iy/FLW7LqPaOBeQW9N8ZMDPpGwKjx818DgbdCdvP29nLuR+gVJVUaMdCmzxxRrVkey1a3c/ylrzFJtnxRR+rWOQV6LY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778414; c=relaxed/simple;
	bh=bcGOTlhWKWe0jzeTpP/KaFYLU5u4iuxJIHrGzDLJtKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EZSn0lLWFnl770T8KBQmY3exwr2EDBvaDM8AdYS53759LFya1IAZ1gxM7wSx8MSwqt3lNkMnYdB+eGMmLVSPMY+R+wMWjMNbptWZLg9I7Ug4nalkfed7uNWPBWJKCtPMRIydE04chqAMyzaOxZXZ+JrbV7Fk1irlnrHyuF1y+JE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MvL7c4U4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RFUdK42v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MvL7c4U4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RFUdK42v"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6871NBFR287528;
	Mon, 7 Sep 2026 10:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9vZhiDW/lW3ihQBi6XvuhbnyvV4zjUPIhITgvKfCfI8=; b=
	MvL7c4U4Vp/dSQcZlcNzzOJdDFQRoVnGRZ8Dwli94vv0i5jthkH0XcFAkj8MsySq
	Er2CQ7pRbIfM3FUqaxrRG+ZB8Uwu9EyMrQOu4B7M45x0qZM7pfygvs39xW8G1kKK
	U6VYmKNIWNDs3fP4sDryGmO4LAqu1js2mB85DjtWFIDpHnyBs/Mj5VxyFGguil+9
	Gfvjl4XY3KiXq5XDFZNCo/Yr5C4ob6VkIRBugj9/ty0n3YvPFYCRrc79UtLWTytf
	0TO2chvVnkg1ZTebP3k3dveIJCXGLMDjsskndk1uyVHduvotTcVmXfwBg8V/WsM5
	NAjc/WSKpOYtKBdRgtF5pw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdessgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfD019106;
	Mon, 7 Sep 2026 10:51:17 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tz+n0TYljd14b/Q+qXh0vF9RqhLNn2MXKQTR6A8J3TJf1FAQI0OXifaW90bQr7Zk0k62vxkRQUTbE8mZqvkwcTXOZkQ7D45q4NEuI3LwGWViXQGEMaW9MKSwQAPXaxiYtAIzGvbW/mR0YBZibzrik5oeLNDPoWLuPy6IN27hVoTNHNqJOG+Bn5P1wwVVE9AB/FgDgQ5w+toHsTYTxT6LzVrfTAAwcEHfMlkRYhkBCKHEH4Oexz80HezTwSlQSAR8+XYi1nhxqAZ/2NokNhl4DeZJvydRoJIa2QCfFsThI1w/r9KKEfW6YSj0ZsNXaKOkY/MvLmNfbf/kUc2JKwV8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vZhiDW/lW3ihQBi6XvuhbnyvV4zjUPIhITgvKfCfI8=;
 b=X8oxprJf+so7sKLH3ZD4DrYBkl91O8EvHLOok39FmIjqI/6oRNDcAn2D+Zae4NVkB3lY/BZxVG7Sl7wEHykC5IujxqaIiPPfV8q//P/BJfNs/5ZnrNl6eqw3ZiESBGFUpq9U5s93KR1RrK0RmRxBLtORbfLYQ7CcfuE/IM0Jz1+CSF4Vn56oe2IwGIulSQAEwhNW+B5BJuDIhzncg50kyox+B6gsZYqNlbXU/8e8HJNdRQQo6u/BrqKRRVdxaVoqvQb2cEPt3Qs5jYg3QPvs05m0Nk0Oa3qzWOg7fNbVcQx5es232r3E+fKpnIlLtkKN7noEhY751WjBoqGQTbpFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vZhiDW/lW3ihQBi6XvuhbnyvV4zjUPIhITgvKfCfI8=;
 b=RFUdK42vulTmNTHGgGhjbwhtSg7j32426ryB5J4ayhu3Y4IydWd8uJibx2ddDbprMDErZGm/XD0tHvcxarFbpYaa3iTADRfyzpZCrkhEJLM/m9vjgRwwBYz/k/2pnUuHbAO0a3VQY1wp8N+b6VbOtncCN5TpsA2sN9bz1i/L5Ko=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 11/27] scsi-multipath: introduce basic SCSI device support
Date: Mon,  7 Sep 2026 10:50:05 +0000
Message-ID: <20260907105021.1763236-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH2PEPF0000385E.namprd17.prod.outlook.com
 (2603:10b6:518:1::6c) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 81fd0b94-e9d5-49e5-40eb-08df0ccde5a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bZlDFy9dfyTe1vNQodPZHfV5OF46c+GsnPrnNcalGkTLW2Q5/1mESCUfCRC9Qjo8pZyuZ6zyUmi0800Dd5hhzOlyVnEeQy0QXlJRyVoT8jvf4lRz32rR0Q00Dw6pV2NCrFL/yCB3Hb+6gWPHr3gvLeRtOvp9SOU93U+2jW+nFg7TBqATYUGnl+YL3tfrKWW/3wQUsfhy6VUPP5bL8M+gCRUwAk96DsHVdCiexLMJR9tLPb/ujh3AP6m2I5BRwccN2nOHNIK0ph2K51NoBGHTg7REpzGHB8cE1AQwCBW7nv0vsx/I/y1GV5Dv5F+qMkoe7Qzeb7DIzwyP0LwACLgZu9md8kWs6j0aQ26/RjZy7lKRJT+s33poTdPELnXWlq/JzAiobfpCPJdgIdyn4tlE848QvFdfrQ/ZuHAXY2dDoiqHmc720d4YeVa8sH6LPxYOwi2ujVCfdkvL9T1fqTNqf20+e1Fo+YblHfv6s1m7cR/wH00vXrIi5kKkZ7R6NwWD2jNU5jr2XHAVY/gnXJns5e2/JdEqbwmlaiFaSjyfnhcugaSh2B1Py4H4lWSrmixFm75dE1ouS2kaFFFXW9il5GjwKTJIOvIUbL1PVre8xrhXKYli1uEy4SR0qKEjWxrH0OP38HOv9UwZAa8R4n8cuuOMD09f+7dDYp5grWXmEsk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u88xSK6bFFyzf4Vw7ipfJ8Ii7Ze/J5zS3O9f3oYzGiH3j1sfGDXzaHL3rD85?=
 =?us-ascii?Q?4vkNlwLszThaYTZ0ZZsTZy5FQNNiBswGw6CX5vebdwIZg1ugO+ZInwsANdcP?=
 =?us-ascii?Q?N6ysa/3WoWwmra3fg7VXv0jt7ZuT4yoL1A3MOU0Xf4tjyB4WyfAoRZdOdFvy?=
 =?us-ascii?Q?JFu0dowZaudjZNsQwkLXQeoyaHpibg2jXxq9R+7d/Ncyh6VVgqvEov3k0Oy4?=
 =?us-ascii?Q?Iq46wjxTgI3c3uFsnj2tUAHYkZfx6bsAUzvCWW58qunyI8vnV4G/+uRgxlKk?=
 =?us-ascii?Q?OZ97ra4kgWN//FVIOE5GftsiTPSiVsjGtIz/1z69UD97gCOZ3XZSCZELCXpg?=
 =?us-ascii?Q?o9o+ta79/IBiY4pYZ2fxA9nBE6zzf2vv3Q8ZTb3sF9fg2o7kicH7aIrj8QnL?=
 =?us-ascii?Q?iz6RyumM2TuqcKeXnrHrgJIC1z2S1MHsaJ3arEwm+NPxR8XXnjXJNOt5jtsY?=
 =?us-ascii?Q?ixOxvx9JZZv0XYET9eyUmHlh/3ZAVtW0H4vWbTPvtBeYtqoc8AyGgAJkjQ4P?=
 =?us-ascii?Q?46jWi9XRmOljcBZ5S6Vy8AkTbRLx+NVSK4Jn48V+Q4SPhA4D3Rkb0kNFQVlf?=
 =?us-ascii?Q?j25igDkmfbbvbaXHXxX1/ehVkT6gch3Fc4S/fK7GjYVLyj5Lcioi9ZkcdTUo?=
 =?us-ascii?Q?8AngfuT2dvCKDeOBorxakzH/J14Tr5+7NK1CjHYBAZdl3HSRY2FDpeHe04hM?=
 =?us-ascii?Q?+HXFx4LmXaf09y7WCwZ9VH6HWmT7kbNetM8YF9S35pRM2PEMv2ggD77dgc5a?=
 =?us-ascii?Q?WTodpiB/Ul5w1h+FEdu7wEruIwbKUQJ+7EKwMjC4+4Uigvrk1Cco3YEJDLZv?=
 =?us-ascii?Q?ir0gbNM1urEm3rICUihQspGaqbLufMHQZ7BhIeC6CmJP+60nfiSrxN4frNpm?=
 =?us-ascii?Q?iLqFxoeNJp2yVoUp/IfpG7PH2uSHsfSdt/AUALX7exq9KhIZH8NRJKLLRLXm?=
 =?us-ascii?Q?m283oD8gcD8htsz/Hq7ZKoO9pYfokrGqw0JVOdYW5SpyTIgFphUkjPRnjhSC?=
 =?us-ascii?Q?KTEUmJYNgLLZdfRjiHwJlF7WeIHp72iBOzHKxT19EL03pYWYfqPXFw2ukRl0?=
 =?us-ascii?Q?HL/JHRWjE5RJJSDqlF6iL1UaYim+Pw4E2Mi28gO+Pf9zCbS4yEsRjcsOdEVq?=
 =?us-ascii?Q?irzYmbZ/J2LwK4YhzSl5I3Vy+ca7svN84fP+W5HIRp0igEfa0QSTqrGVBeFi?=
 =?us-ascii?Q?TDlejPCiNa/DXdoyVV+A7QWFfeenDBellQyIdyAsZJZEm8ktkjTX0Qlru92f?=
 =?us-ascii?Q?t+m1g4d09/Ip6dlzDOGiHvRgc38ZAbuHYEEfRAC0GReQZ7WCnYMpaRjYzTB1?=
 =?us-ascii?Q?CGi8nCOeDMZTeAh+x07Z8W2MT+Az1WhfNd60Y4H9O5gmeZ/E+07G4KG7n8Ah?=
 =?us-ascii?Q?hFsRiX9r6qGtC14EILscZohDiR7f+GqqtbaqCN1avGamU/ST1TAArSAWvG2Z?=
 =?us-ascii?Q?mu0JykwFn8dPQW1sg6OY37hOWDyRgseLsdsW6k9vRd0TH311DEs8YL/fq0mm?=
 =?us-ascii?Q?4J2glVyTSgQaIILJNbWawIHQP15zpdXnotUd6sNL2djJKyXZyZIRpJTckr35?=
 =?us-ascii?Q?5y9IndyIzb89dX38s6hVhVXONZ/3qJLoXgTnKrZuQ860zAQOR9snAETW5+a1?=
 =?us-ascii?Q?zleUjfL/ohZJ9EeOhtDfyBv9wfmaNLnZN9tbLn2r5wZnc8eu7mY9+Hutq25u?=
 =?us-ascii?Q?Q310K2o7okYU0IDxlUsElegZNkbTVqgMZrs1Ose7sT/OrYODu7YPKEG+9NPQ?=
 =?us-ascii?Q?Go5cNKtHcg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	f2oY8VwBEg3WSBByHuhtUL9g18iIyJ0M21Oix0CLdVYET23AxQmg/H+ohy5w6TeiybxZoQ9CUPN2zns8OPOrWncxdnITKJRsSNb/tlXYwycmlrVSfXKMndZ7Jt7UYfXZu6LmIgaq6e+PvKvFmg/E22aoFUOxX9NM3yEZl6fezSEIJ5ZvPAeWDfPSIXimDPx49UvooHQPsg0+KgEXd2VoIOAG/oJh5Qei67V6iJ3AdzoFpqHO85iFi8rhFyzQucJ5FbobBETfrkW19wpSTVy4M35ULWJS4WZMsrDWM/St3Qz/tMqrAYmHzhVTwXcFizKT76BZx2pd02DYspUryQD8zw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MKpp/YFQDuKw5Gmq5M7QV9OwxybxousJXWLnwN4dUA2QTIQXVML6luUScuijYGTw9MaPEk8AKDmqXLtJh1C8YdGG9UwNGqKT/DRGHygJizpdnszp89jQ5DXjYYf6I6bLEJVMVqYEdoRcc6VxKbXL74rTpYohe0yiT2XffDjJ5AXO7yXf+5qdK6Gk9xHR5RQBQez0Hgyxj2BgJY2jR9Xi9NFs899e2G3DnGezFPBXXnuiZ6FbYzXtCG7ijZ6FlnmqmQpGPXRk+VefxEI5h1sqssTmCsl6nwTAr4XZeYj1NppkdqR31H6J2DCptIbU+LoT/d58kvx8hhAstm1FNHm2YaycDJW3d0OOCkTDVI39F13H66/1uSzre1tUFvyGJ2t2fQIwVK7vYatdxpB2l2x2kAIP+hzPj6GHor5qgtAczSRoa66eBXA8CKdvFQxMbSxQ5AADWM/8kd5B00wz/crq7I7LPvxiR6XiXGpJP0zaf6HFce2LslZMrLIlWgkjXw/UWGPBiivuYi1RXJQuc58PAni+la2N08mGOJ8CPHWNrfgsmdqDNQdE12BdBZf3CacrJiy3LsImDbU8JVW46InSDR7QsOBobUpm4+c7xRgiGBk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fd0b94-e9d5-49e5-40eb-08df0ccde5a5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:57.2800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYoqdaluSjNCYOORzO5dsAbXDri8cGFlt/Yb9ptEEmeVtEzr0y/y6THE/YnbOyg3eOLRnZcxoDQa6VRdcdH/Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: eEYM5aEgTuguJL-D7ho09ZFGihym4FvS
X-Proofpoint-ORIG-GUID: eEYM5aEgTuguJL-D7ho09ZFGihym4FvS
X-Authority-Analysis: v=2.4 cv=R94z39RX c=1 sm=1 tr=0 ts=6a9e9726 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=pCOl5fTshOrEa-n2-VQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX4puzIgAg35Of
 6df0FGAilna0jPvw2BEMXHxzREqEJJMhSlWYXbp8XCaILqe8pWO9fReMhCt7ldQKA5n2+NtZbC/
 iNpg96yVMBLY4c3LgFT8sbyWTu7EQKNc3qpDf6TI5hwUXY+zh6aTlpJ5dkEUz4og9JM5JbbzYGD
 UXYS01BMpj3oCWSrgWNinxLsZBAuxPpqUuPvnMLdUAm09E8Soi//PHtfLN+cxKULkp7EVLc5viD
 3vfYoRz1YEcWNGPjx2zeyUKb1SbVtF/neiEc5Zttpvj63RXp6ArVLl97L7cBx0bU1JUd/GcJf46
 dIAXAy9F48I4mCt3bWqcUqQW0ed+1Eou6aSdZ1yKVgzLDqkHnQRuZckre5mcy1ARKaPsrxIN78N
 b6Br9oQm3OjsH+oZLvtMQuqC06h0ivqG2b3+b2TvzBaJgXS8rmlgfyT2azhz5n8VY1qXtascIc9
 oQ13dYH4+0QgWAnoEbg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX5ekVHQPiX4Iz
 Gfr6bCi1VnkbUoijIo6ku6/Vin6wO0Z4bGERBZoAMQcxe23cM/veACPQz0vOGaQl1fTU8gfwygg
 p/WZF/BSi6lND+nnWEtdgVkyejEB6V/X1/Zj5fI4b+GTd4Nds7NE

From: John Garry <john.garry@linux.dev>

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and implicit ALUA supported and unique ID
  available in VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 148 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 229 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4a2af0f702e1b..ffb7d12664b09 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 533623382eca4..8bf4e548b395e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -192,6 +192,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4e7e7a6b7315b..8cc33348a3637 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..5559e2e8d64a8
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+#define TPGS_MODE_IMPLICIT		0x1
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	int mode;
+
+	if (!val)
+		return -EINVAL;
+	mode = __sysfs_match_string(scsi_multipath_modes,
+		ARRAY_SIZE(scsi_multipath_modes), val);
+
+	if (mode < 0)
+		return mode;
+	scsi_multipath = mode;
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+	else if (ret == 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!(scsi_device_tpgs(sdev) & TPGS_MODE_IMPLICIT) &&
+	    (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0)
+		goto out_uninit;
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return 0;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 96e4065ae8b55..f7a782568faac 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1130,6 +1131,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fe54792ed69e4..6a68da42df913 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -456,6 +457,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8694eeadd753e..1d1356a21c3a5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -280,6 +280,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..d3d410dafd17a
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

