Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A492F470E88;
	Wed, 29 Jul 2026 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322391; cv=fail; b=opJLeTXtF2dZPpTeGeCXEn6+shkrgTj0XJHzi/9qU652hodT+D0xqmRRHCg2dJTWO6NOyGeW7w/kbRiV5G9DVLjI5uKec1G2GdoaZKpIwpQ7tupxuTJE2ST0LuX746U2wju4cd+Ob2UdbJTWWO3cUpveKHG6nNwBZYCagu/RqJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322391; c=relaxed/simple;
	bh=H3Fy3O5kzNqaZuaq6QPPEZKHFbbYhJ65sb+k2cNUl/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gCCIjhiE1p/qxPsa+4WpnJRl68UioDAWrycs+q/Sq5pVksw0SR7q8CJ/b9HIRt/iMvcaTj/hOFDhel1alpZh/dsc1Bs3f5+ZofXIVUKCxdLDiMHPF4xYmafib/Y7hl1T5z6ltQKHywNjcH8tgGCgzbOgJbcLoHvvZAQXwBvos3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P3z5fvv/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S9vz0HgN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P3z5fvv/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S9vz0HgN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TA0vhO1094338;
	Wed, 29 Jul 2026 10:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+V6aNNQW9zGvTuPfXuZIL2AnHXVZ9nkvT0DUO0s3Seg=; b=
	P3z5fvv/Cis0H3ee90ivcWZdizhJyWIc94eksbLapItM1T7kQRcd72GlWYHb+muH
	oQFOTCEz+gTlztPq3A9Qr2un16LY8HIxbe3dBXCsGfUsQBOcBdbGFMsQ90vO4OaU
	gT8KufW2UAVjdCJNld6RF38nM+p+SEm3wRkjChX8q71KH4qWTL0Ib6VhyOcOQIWY
	TpwjVuql10r0729gVgS+HNfbsJC9t7CpfPS1TiJM1nG6XeBBW05hZJyGFBLw0Bi6
	RmGXGBRqEkjUH+61cpXQEITEDWWEwQCG1neVjGzSzARxkFF46pv9OroYq8PhiNEt
	qoXjP5GVb4dhxYboeFSDvg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5k7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo66c029952;
	Wed, 29 Jul 2026 10:52:31 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011055.outbound.protection.outlook.com [52.101.62.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh882ksc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xhBTAhDxElGWuyJsML1jNgH6N3C2TaQnsL/NnH/pi38FwR8oFE/+n9SigUID0/X62uCoJY0N0Y1MpWHcodSJrPzB9kAecQ/8kLqaN/K8sXZQ8aaPY7tkJybw3RaDWQgTE3D7LM/Zjz2ljClQf8kYCpV90ppgsQuB1oZ6l2oE5yMsj6mSISpLekpJ6thmKvSxzWhY1VscbwHqxijs1A3S2MlZOFmVGpF7FSzfPheOjZHLy0nkBGDf/18rZVCIrVjjeGFdq5VLwlvQGWW3TfJwGRLa5LnlLZCyjQlH+SRarNOSSUbYONZehXqdmdS2EyCr5JQbep9HCD9hozP4CHTeIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V6aNNQW9zGvTuPfXuZIL2AnHXVZ9nkvT0DUO0s3Seg=;
 b=wVuDupi4wjMf3STzPJoktfl6SdrC6NwvNMBkYuXPHYYx+N8lsn8TPCv0ALf/rnNzpQTOb7DATDXkpW06cNy0DygERFQGslvrBTd/dzHBejpEtEs7oonXU3+I5AK9mmohAUUP4ByfUTTx89dGs4VUacyW2N54kNlX18wxwyaZvNc4bqcb2lfpymuV2RM5zU2+rs4sidq1Q8HmBLvhiKKhIAd7csuHhutH44552vE1L8+6RLHegldouEXjXAGJu4NRx83pdRkNBAEpUlf7XC5ZC5NmIOzwOCQI3GlpBtGRLdcKt2z9lMiGZAVSNBNOsdis+ZBnUUXgZs6WPWA0BYwRYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V6aNNQW9zGvTuPfXuZIL2AnHXVZ9nkvT0DUO0s3Seg=;
 b=S9vz0HgNu6wFWgPCibPJBeOPeJao/rY5IA8nMfiK+IjFcPZWXQFKZETtE7LXExjjlyQlW7ZFyKke9GsbeJv1MagJAw6y8fTPlu3ZFckq4gJC0rbiauA0Q7UnjZ2uTnQtNlsh27NAwvtj4yAReISgPMuSgquIRrXRgFEIGs1hKi8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:26 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 25/27] scsi: sd: add mpath_dev file
Date: Wed, 29 Jul 2026 10:51:05 +0000
Message-ID: <20260729105107.255712-26-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: d55567dd-41ff-4ac1-fe15-08deed5f7a39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	W9nlCNZlTsr0BmG4ZKLVdlJ4C+mNiyxO/3TSyh0gbmWv6NKbmySAaRoOItmSfZN/4g0LzDwVkW63EnQnxUsJpjAgH3HkO7+VwyklwC0YxUWyfKPFrQUDlHm7AHsa4NdweHrzepyRMSCTyEexKmqm2rSRO41htrzTjqm8QemHKiBMl4U7kLB4uMWBU78uJAHxwe27zVJ4LJxmmpd/0vNXi1adRRNFId2gWjMuQB4nT637fTiZOfYjihmuVnM1VXqAiw1PzpFgPlkLkK4M/Wp0nHaAfN/TLtZK8uuf7K3xqzNXA26DieCZXP09apJ9qY9KLbui/aMwOts+mjOpBGAM3OcpkbWstt8cfrDgB+H7WmNxda+gBilt3PSiAEzP+gmzYrRuon22m3kkfe5KQ78OAivyMlxEulD7+MFrFdbH9YMDlEjK7G02ieEAr93+ATkK3K9wk2KCW6BzSSvm4RdzmUtBGK1a912IQps4x2GWAogxOge/35mtw01zlhLroITsGWBQ0IN6ECCuepYe8Hx+VDEclPsJRsqbbAeQHPjqxJG6VKAvPI4gtTf3ipThgbdQD+K4VOYvsumAPLcMN7xMMPuS5pZ7pf17pJ2iRDdwRmBJAwDtgJV0RPSWZfn/tSyp/GqSLVRWCGVPpCS7Ov6ZdoQQhzUaH4dKMTYWz/vuaHk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gju1uyQ6KfIibe0tdHWdy9DG+ZhRqzol9wrMQ2XkFJMnp+SxaFDzDz4zAgFv?=
 =?us-ascii?Q?1cVfJLWdSNNrfSOa339c+aO453lu8Xpez8oKcYoAHiWQx3t5hg0egV0qB4PO?=
 =?us-ascii?Q?OPjO6bpXGftbXDQxjyVuSpqK3+vvJ6f9+q0izfGL+GfhFIf+zPnoZ67x7kgH?=
 =?us-ascii?Q?m6dE/gm6WAcXML4HTy/BHe/vKlfmXXD4B9Slx77Vsz/ahL6KZ94soXjJ5yAw?=
 =?us-ascii?Q?KDfGzskMi7Oz9DqO5xxjMXoSvgzFRB9mZoNsBcnczJnAXe1KlgzFOcQrjFTm?=
 =?us-ascii?Q?ZY1IOzWRkw6ZCpP9lSd5jcDIb4ewFQwcP6hg/YNR45ksUCI4zDiNzL00JThZ?=
 =?us-ascii?Q?n+Q8DSh0ahsVYVPVIMl0sAIWswBW9SPv59F5coYFcTCbza4PuxQpDzwrPBCZ?=
 =?us-ascii?Q?yq21OBQ8POncZvQtIyEz6G4lSUanXBwbu196Ha+NGU+RXjRtHyKqRftw7GDL?=
 =?us-ascii?Q?4SPmOihELy2JG+uDLGb/qAJuFQZvF6ikklVzlEJWqFTARuCG5MeSTCIYDJEV?=
 =?us-ascii?Q?8FoaCQiUs7JT3mbAjXFM8W5cDL+XZSY4pVge+MqRqar1/i1DLEoNfzqkzoJT?=
 =?us-ascii?Q?lom6E9T1RrzxmxJ0ypuCtltupZ4C/dFmnEDQWEXO2QXgDVqLg3pZY0mGXEzE?=
 =?us-ascii?Q?39W05+iYuouZtezfmHp+uCMU7wtjllqPZ+eUz0KoA0QViKSpcloAbPev05YZ?=
 =?us-ascii?Q?UtN8Ahv1bxEd+PcWAqVFsJQpvw7e++nOreYH32qaGiyoLW+7BQajTzFgv6Kq?=
 =?us-ascii?Q?aMvnjme6qX4Sz5VbbKV9bYkorx1KpJftZo1b0Th2I6fNZuU3SdPdKCM2VbP+?=
 =?us-ascii?Q?L0dJzvZBkiUmhKUuIKFOEfQrLkGgtsUxN8n341Oqujcu6rcbTrTOZzIc/cJY?=
 =?us-ascii?Q?+QkK7LeRPe73J4v38Gkdzc1s0zlzHWqZ18ExwjzrvGroUXEdCJBLKLAp4Kx5?=
 =?us-ascii?Q?BotzwGInpoeBcIb5LT58AUG8A9TFqVoo/y2V14QPt79oSCPvqozHGKWtxMOO?=
 =?us-ascii?Q?FfibmyTdbN+o06vEit8Ao035K3qPPEO3JkM/sUH4+/RDXZScdEzs++oL9KPp?=
 =?us-ascii?Q?wU6h3bNr6MSyNKKBHWNBj8WH3Jiz2WRjuRqK4B4Dq18FANlE7Xvsb4UJvfm5?=
 =?us-ascii?Q?TExBesxVdcIYCfol4t0vnOZZigsQTDTY2ob+u2PX96pyhOPRN80MM3/QEgtM?=
 =?us-ascii?Q?QDuEcFeqECrxlQUF7L4/U7d/y9UdXG9ReTkasL16N3SzthTVBBZPo9UbXViD?=
 =?us-ascii?Q?ZeavqHsqU1mqt3NcZMJcS7/JJP27d+DQQCkPbLENzgnEIFTgAFzIl0r9HubP?=
 =?us-ascii?Q?WYVjCGKYldteb4LFu5HeRU6RyeV5SDaWwSegZ6XfNinYE9hwPbo0YWvDrxqd?=
 =?us-ascii?Q?p2uy7kmb7JBIv7Chuj5lRgRp42Nj0PhA47SrKYfCN4TkNJbUVx+1mwab6FAp?=
 =?us-ascii?Q?EQTRZdbWsIyCefGDrsqNYSDCiicRDvSjfKoVg7Y5sQxZwuLstf6qPGYyErR2?=
 =?us-ascii?Q?loKw/L8k0e9lk7twnUmoh+2tGFVBxKL6JkTzIWnmxJT0ORMWh41dWWcTqzU3?=
 =?us-ascii?Q?kF9vHKA3HOu5HLyF/vRar0cYFikPlqq1vq1fSZkDa7CN8WJFg7LW+3HLO8KQ?=
 =?us-ascii?Q?KVTJJ3kXrAQc/EZo+2IoRCzBjXWBzP+MLpc5NkriFenowYPEqIqLc1S4wUzd?=
 =?us-ascii?Q?W22jGxB9JsJYbuVkB5A/oXVtH8Iu9Rx4QlyjiVXseNkiEttsGWmssrFsoasJ?=
 =?us-ascii?Q?+wMDUSBgYQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	iZlHDesvLPQwwjYAJDemMeYh0577K1PoqDm2VrdQUkRp+sJlw4Rca3M3qXCdTV3AiU5aB1qnhcCK28YQFLcbBmCFz39R/l8B3rom5dZS/4uF/gJBk9CRx1zoCajQ6mPoc60GCtbWFoH6ot66fmZ/jhnwufn6mzJ5KoM/gLS5z9ROzyZAkcw+Oxwpxk3TbXgUJlMjSgBrijM2l79lLXq27K885ncfcXlvk9I5CvSuiNkaXJDeAp7t1jE8DeyaUdE4A4KOWSt2Wm+iwK9fPPfqxh8RdWcnA1kapI3gqbMA0EdwOQ3lBJnTaFf/dDJGePk98OOY3g8BP7YywJVJS7BwKg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9kqI6XbTnH15ysNNgZDhuFek1kmnWEH7TWEv9jkgXzVzkMOrPiZBRyOFhSiQE4KhU8b77iKnlp1xmTVK/dgoJm9p8Ux2f9v7DhbkpyRJGA+625re6x4khqvhINAB/uaCZv+18u1AnpxJhG0+lRr2MKmGN9/5p3P98clT9LEzAMmIOcx8IGJD8xM0a8rfEiOlpPEmpaTXFiZtqsybw7T2c1jA2IWhDolU5T6g2N6PU9EmX31WKDihIhCqvk6mUUId0nn6XkL7JlBsO8D5ll2VLUl4NuIIf3/Bvz1yYjPuYWXk9EhGRrj/taiCnNASlN27+swHVWJiG3Gur9Ros6GZe4/6n2yv6AAiylJ7zh8uguib7F9z4Iu2jj7TgUD0Ry3UlCO1j2aXx8sKriK3l+9PDrN3pYwCWXwGBMFjKMv+ldOnimPAoAOvGazz9vlEvn/PeiOd7XuEceL9/nn3NwFpTgf7kY7FyTYOGMVby59EVTyRSvtefk7mgwgRiseYCMJknnzEX3ceZbqBzhhbmVtOPDxeagMv8YlN4r/iMy6lMk1B04CZgcu3hHwpfvTmnmrjJRAw2OCGdQN2ya6DhhlVlZdWq7oqvW8CufanGW/ElLM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55567dd-41ff-4ac1-fe15-08deed5f7a39
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:26.3731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u293pzBCL4DPfSVEtCCkzN6HOd95tiFJv+wF03xJaWI2ORMoRG5GUU1X8q2Ziui4ruPEO3VDpaSu0Fy0RsRkzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX4Wq5AOzR4Q96
 OXU4JilqAf3RaFzKYrf/E6CQjjvJJh1SyC9aBcgYDXEl/J0MwMhE3ppsT/vfpmUMharwTPDyJZW
 zKJEEh2opKlBdi7+PhM8WPpuI8ancCEZFVVCgcwEZsk37YRy49GS
X-Proofpoint-ORIG-GUID: MZtYFKeLaF6DEKXZM7e2GarwazwBDIDC
X-Proofpoint-GUID: MZtYFKeLaF6DEKXZM7e2GarwazwBDIDC
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69db70 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=7RnQmdzTPIgLJ45uHnoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX4X9hyKdJxD8i
 loG0y6RaO6axYp5VcqGD/YZVoeCm1bJ//PcoJz2qgeRbB+/A1dgjbbgPaJAovhpDxRZIRdi0uxw
 K0xWH3rL5gBHWQPwSlWlvK3Z/PpnxK+QMkya0hwfzrcaJSthuM/ig9+3SYWbUSTAXP+wj0UZmxk
 nx+Zs8XvW4zuBpjO2MoarWxZkwXWPvnxjArTSQXkLQc4NJ7wvXBgv8ZS3oPb9bB0DFdwi5R2c4y
 dNXr+N4YcW1oRQWdBcTREbsFBDmJWnItBI2t+ZRKTtkNlNxOMemN/H+eWqQLKotYvy1PNLBkKTl
 K3KW3Sb8yVxeSKpQnewXo6U+T8MoqWMgsLHqaRCyyq8f9W4HhzlroxmEs7y2FolrXi2IsgC6nHn
 MxtlYDi9UvHHzLid18jxfcqlCui8Ym6H9cWr79Om17TZ0Ty964paonl86qCv35aAwh49I0aJsLN
 blWDw2D/rboQ2x1iCLw==

Add a mpath_dev file so that the multipath disk can be looked up from
per-path scsi_disk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_disk is missing.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f044b2dfaa9fd..cb1bf4174248b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4109,6 +4109,77 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
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
@@ -4389,6 +4460,8 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 	return 0;
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 
 /**
@@ -4539,7 +4612,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.7

