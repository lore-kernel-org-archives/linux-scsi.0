Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA04D46DFEF;
	Wed, 29 Jul 2026 10:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322496; cv=fail; b=V7jCUbh3SIJsevA6FmTtH3yqUdB1YjzY/yqqoNz7YZwWjRxUMxFIfKRzGTXIj0tuwVonkWKf59m4Ng9FLHCdJwREFo5WI3rQGFaeNxJK7FKys32uv9k6GrplkY56GOe3Ri6xjbvhflYfZSHJzKfvPRfWr3aO5/yYbi3OxGqAPkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322496; c=relaxed/simple;
	bh=/pt0IjQ+U4EMOE+5dhbpO3VfwjoxPoqaRai6tXiWoV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UI+RM3iswTvEwT78JvBBmpG+jjVwfiz8pmQ2Eg1CQRC8ADzUDY+vOwp+YD/L9YYLJLN3Dfa/hHauBlJhrCLIqBTnilZW71SnfMXmxnXO7uEOgEs57qHQvwWYoE0EaX+8ndBhrCYCGQ6SBSY5qiS5ZBtDacUv5gDo5QX1XT1cOPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RXdyQBSn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ODH4jY/9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RXdyQBSn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ODH4jY/9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T3jX872192167;
	Wed, 29 Jul 2026 10:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6EsSHRJJbEc8Gm9GBlY4MOLPgzuzhWl6f2h9c7TUhzU=; b=
	RXdyQBSnE43Dy0NneESr70jD8ebPM+OwhDZBM2JCJQgIeanh9KjpAJASVTLeYELW
	P5VY0v9jWiXG6HALLaEKzM6N7vIxAfW8egDp3pvAH4EFSGre4zMo5HP9lfiVfDfA
	lddQMMMkqnDOV3VjdPuAC7ntaxtezJ97NNMOVDazGprH6WN0ckDh9NQs9wXDt0Tw
	M2qRLD2gD5w/1+s17K7FxO3Mtq3L5u5Xq7wGogIAV4X51XXuRm+Tfc81IUXc+uzT
	QBq7DhVcpkiNqbj6EpJN0jur/hYLMFhFuEiVdD2nBwxaKYNKcUr3OyfzpOauPNN5
	2JFEKsTX0JWDGotmbI4c3w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pnmxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAeVT2022350;
	Wed, 29 Jul 2026 10:52:03 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013028.outbound.protection.outlook.com [40.93.201.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6qt93s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irUcTsm0oPeSCgXKOGYUyscKmHGjOl8Vk4Ywue6GI0orf5o28GlDTvqTHVLLG8aH9rzG0K5vmwRHs3Ts69AXFpwct9N10nyb/uRcGBBdhkjPurVeVFTD4fSh0tZNAdUDdTMhtSebYy5K5FKtNS/AAEHk/pMOI2wQaz1rxjB79MhJm/NTnZNW9cueKejut1g30eKTme9Hv6WFCTPiUf9dhuMsj+tuBbqtbr7DPhQlmf+1evgS8jMfhLVATw4sej5y9xmxKTX1XeaSyy/AKNhBOqvFinB+BGR6SDsHLKtchVmIMeYMQ+P8BOxrOMCM2Vj8ptLlbA9WQsOyatJFpgigvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EsSHRJJbEc8Gm9GBlY4MOLPgzuzhWl6f2h9c7TUhzU=;
 b=UbDaxJBdbuEmw8MStT5Dke4U0W4lVf3Z800pHOk7PI4yGZ4mlKhYNXgJNbqFTUR6WiRX7nfE9m05oKZnDN6YJPNVvYM/lu3gjhrWeJIxLBQF5X9gL6y0OQKqsZONB1++o3wjzNG1IBuQJRrs4h/kL3eULsSLjP8wF4smK1zD5XticRQlqOoaMds52qrpQYrFPZOfFdaSq8I9tQjY7F/6HTfQ9Ii5oG+ca8aaLEULJMhEFW9jbqWLez3Gegb4lKmkVEHc3h+c71pQUOVnO8Z2FHC6Raq9/1FoGivmp9Ldl8gnIwlv37GIhha6BWJUkpmxmo3fAMh8SYIBHvT46aEMTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EsSHRJJbEc8Gm9GBlY4MOLPgzuzhWl6f2h9c7TUhzU=;
 b=ODH4jY/9whol4SOAQjZ803BA2rJ9TignoEh0MBck7wya0IDbgFsHYytd5sPwI6T6x1zSznao/QQqISGCW0TuJI8n4zVtOMuD7OJrdiIvXh2iK7DoECDSXrt00zTXXt97b1zzVM1ea9YqUZfe3HsqsYTWhn3AiEXANf/h0DoHgoQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:51:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 13/27] scsi-multipath: provide sysfs link from to scsi_device
Date: Wed, 29 Jul 2026 10:50:53 +0000
Message-ID: <20260729105107.255712-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::31) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: ce6f9b0a-fe99-4a49-9856-08deed5f69a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UeOY+JlmqA+30xrvlc78X5g8PU7k/Ni/D8mf5dV5tLWuEop7X2ydHiZ8aK936cCwpR6qxIxPlelsReBJa8WkUwWDKUiyKwPxrSYGc4IAEc/0wqGUgSqL2YNeY3++8pZkWd+uZuzoIyZ+Pwg9GF4zhiXWfdq8FrJHSvcPY7FQETmppG+z8ieHGUFIU+sDJLfLWEmU0t6jO+W3W4ayNYRh6znoE+uZQDbGVMzhgl8mDmodwnZ3cXq4FOg1s+WQyMhcCsYbYHDnU2+HociqjrM58y0BCsJHvXZG/RaoNICJnlltrsHyMIvpwO6F9uMtpjiwdTCD7CS05e7o+NpZr3ls7gtPvPscuwhiJlDvd41IvD2WcJ2T6WuGoUy/t2ICg1Jl4d9bqwsovCPczEGPk4dD3NQWujhK48owpXeuwry11ucu5HwtibshX0hwspbJGjGIGpEHKFzedEC3DdmoXwurSCjqavk+9YIa7VddEXsT9RQJ4R5z8dEnRoKrJkGPGTfxU4IykgTV+cBhNUb2MZl8zUpavLKINLBmwPHGhadkjkSL6f7nT8KkVwufcOuVZ5UJml4X8UiL3kurOWEstMYtcMPWDkJavmMdTVSIi4oi/UxUcEKBP5wMiMoiQ+wtW6fpFt3/oStecEAOVRL6/ISI0HQR3o7EE6DSMrmOD43556Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RB1xqqviS+mFcm60qNbdTqOGSZkOa9uD9EZ8eNB4bl3tMfbuc7WDk9w56NqM?=
 =?us-ascii?Q?Vjm8atA7adFMzvzNcgDZMKIWrdcql0gnnpC4VGwaVisyYlqRGLqgD3RhoaCZ?=
 =?us-ascii?Q?7MW4gD9TKRrCeF1CLqYstwdovWzoVeNPQ4bQ3Pi32iJFVak4jecyLw0mKlea?=
 =?us-ascii?Q?aMtE9wIjBKMybWPApvLMgQ9yDy5ixg/j1f5DZiT4Yyc+/a+TjyQrovI6X1pY?=
 =?us-ascii?Q?tcMGlJgUfLCqD4LJEe61ta2GRBkMaQANI+Sax0yBsSEcKOSyohRaHtrsnm22?=
 =?us-ascii?Q?nXhnTHIm+Jih+Ba4IFcJ2Y0xjrL0oT1UCMn/0KjKu2zOYx1j/Z/uOx4I6EjU?=
 =?us-ascii?Q?s3Hg9VjczjzmTq+LrEgu5U3HaHlB2macwK7QBjj6B0eYS5Lx+aRcpNIG+E0+?=
 =?us-ascii?Q?uJ4JNNFwYz0QaE115ov4J9GcPbulk2Vl1aoFoBT9Da8r3Syq0N/t9s97F8TQ?=
 =?us-ascii?Q?we9sfVmnM9WoCsAh1sFumaP40MZAo2MhoEujm3FL1+fxuU+ieol3Z2lQzwux?=
 =?us-ascii?Q?YXu+TB1wm7BSNr7Jt414IB1Vxpt3GSfRPo5iyyrtWHwYCoPl5Xn6LHV3s1/Q?=
 =?us-ascii?Q?PhenGL1cPGUTsXFbbVe+hxrhOGuBC8v+etrptUn7Z1A+ftPc8tfjAXq3+8HK?=
 =?us-ascii?Q?uEqkSRHnzAwRziep6tohKWge7n+NicSeSSvc4YUI3tEcL0zc7hB2mHS1iuVm?=
 =?us-ascii?Q?bO8flWVBxF+1EWuRhslBc1swxX1+omK1Z43rMY8OOtHJX0yIq19uwuRl9aZY?=
 =?us-ascii?Q?98sayfvYpdqMInrbqrzu4m8FbtKDHlXlJyKGqi5y5vatq9rDJSflY2hd+qyV?=
 =?us-ascii?Q?bQa1j5GkZaE72gTO1wNhuYkyv6KMmMGnr55JX5WkT8jF6KNYCdtUxejFM+fc?=
 =?us-ascii?Q?rLu3/kPY60ALKScUysd1l6e0tAQeVSceYp5RglCA/noMfejJfa0IjZxA5Yvh?=
 =?us-ascii?Q?R9WUo/G3W3kCHOqwCI/TLMvFK89eDNLnO4sPg0cnHH2Aog/lKOf4W7ALtb/E?=
 =?us-ascii?Q?7TpdpLAIp8ENw47q8thMrYF1QbXYptIytXAKvsqU+E3KH8i/swvvSzv8aXNc?=
 =?us-ascii?Q?WA8Ha4Hn2TKZZvaG6mjTv1TspP33mPscuSf2fvkK7LNRESabH5fAUCSAdyDo?=
 =?us-ascii?Q?aWJPvtRN4kG2qYVUVg/kruNt0eGhXmyB0EN/qEP2x2SWRAb6l3rK/tqj/wdd?=
 =?us-ascii?Q?4ephM6Jsrc/KO9d4bE1PyyQ5ZO3WUaV51i9FpYCXrYQOG3vOaLp7lfyoinze?=
 =?us-ascii?Q?e6Lvxj2oPsfQvYckg9QrUfdzrxoL0qsbkB5OHfpZsmX4r1mh+XnKRIsFG8dc?=
 =?us-ascii?Q?bAiPDL7WKGIVBabL/vBTeY+LUUXLhzU0I74eHp9Z0AEav8zakwJ06s2Kin8E?=
 =?us-ascii?Q?rMIhRMDdNMoeZhGiIDV4Za6MHK155PE66q7bq60GFS9r7NBIlB0lR+YBqa8V?=
 =?us-ascii?Q?QfD7UXDrg5bLNp4vFiMvX6ONwBVECKg/fgHJ+wqObYTArfOo8EW6Dw+qv1tM?=
 =?us-ascii?Q?OAZh5gYUUtcZrIv1V8TR8QGRHuNMrkKOh0y7F2tWWgHdejQ6AAyo8FQviu9V?=
 =?us-ascii?Q?gvTBD/ybyHvKtuiucW6fk2lHh37DaNWXU7SPRgdkDx8C06FbzUPfVraZ1dAR?=
 =?us-ascii?Q?g+O3tyDP5nqcb+pqafOuSllQnLxCoJONXPDhh4uonDKpTu28xg7H51FTdgFN?=
 =?us-ascii?Q?Jk6ZZH+rDixPn9UUovwkqNa1hl3iJ6r3gEn6+x1qO5fVbtWOHWYz9AO5dy+l?=
 =?us-ascii?Q?VEENKaTSJA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	TeeYwHNXLE1zfz4WXnB2USv4csx2P749qBCM34d5idgJRj+9+nSLxYA4wz9ZiTW+PiVnJUIZlUzAEmOapI1gB9jLBEjLWN3yikGz+gpSlQG17p8vqpFLSCQbPQa6rv/LO9a7eeU4M4OHKvDGituvox2cAJL1RV79DK4epeBxMvWBvH55Nm8kX/49j/fj52bInVNvmO9CNqrK09iFq9M46o9E7MsZ8L0wu88kj7Wfl4x3Hu2q90W6bRpgYsuRRqH4GwZub+zwOEUAae6fxsZukS7Gg/ka1r1H+uJqvR5GMF7IyKIW3iquvJRmguAjbwGkLf6bemfDEAaEGNsMwmQTNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RlTfpgPBR7UnhopRbLOISsT70mUfGQijX0UI993aMsp221ASdgIQugM2YKpOAWDyPsb85wKkXxLgjh6NEZ0UfAPQPx6boYQ/APohlgaVw3reRl4qx/zTSe5SKMuzatBPAE9sE2FzsHYKPlTdZ6GkZOY6/v3WbRpKe/BzmSLP3XreU/s46qpYuSjSJVDcCaYqhG98yg8MwthAUXWjQw2+Fel26MzjcuFlU0Cesu6radnJxCFlbB7eqm5NYmbOY5UZXuHzreFjnKaMVUbC8I1rmSXd+rIRO4h9iUGLZYBeSdcrrOPuIFkutIyAdBEjGfIOOUw/XcAwd9lYvW03faiQA9TzSr9ERO8xuS5eGV6PyV8ILO/zDpQCyAej5K36Zg4X+nwpXDDlN61nlp51QfgpdCFlTd6Rjrgp4gUIfYYwmRLVtO+DjEBCWQaSWn3dr93hjQ0sdx/QzSWM8SObdIjupUi9qPQBhSLif7Jyp4bPmDHXAWvSHKr5P/r0aoLU6mEU27CEBt6J0TEeTKp92V9vZsS+9rJv/Z9fZ5NV308JavQ/LcQAjUpl3bUR7VpiRpIVjbVVVolBDcE+Lb6VRDSH6p4Q1NjpjaNz8C2S2cysxhQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6f9b0a-fe99-4a49-9856-08deed5f69a3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:58.5333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzuqoScqANEqXOl4vcfjb0MnKBXjHGfb/zq39+tChtyN+nenIMWePQLuQ91TN0ZfiREvVdqQDPA4cUBkYFqaFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290088
X-Proofpoint-GUID: OWoTQaBVVoMUowTGXxwgiy9O36Gjjuhn
X-Proofpoint-ORIG-GUID: OWoTQaBVVoMUowTGXxwgiy9O36Gjjuhn
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a69db54 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=ZbQ-JUxe3OK3M8wTWUQA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX5uK51gPiJ8Md
 JcY8IBgK2e2eO13bR20Y3Qeij320qAD82x8sDIsSlkLMEh24YOljO4w2Bsmz09hulx1DbXe1lKL
 C1lfK1KVZqD6NrySBWCMX36PiYOE4R6UwTHNYFTklUyoodr1b5BVgYdnRP50LmMyfsV8BALiAJ4
 9z45ZJfyn+yuosMI0ffBvpEjbhDsBtxD0blIr/TuKdF/3BW3COAyEj9oYBEpj4f4HgZTcZAmp9c
 Vu/rOx+qz7Xivg1Ss3YVVJg5/jddr1CupF7CxozaRWdEYSFsovQLGCQhM/CopSC83WSeBSVrUGL
 Y7EZygYcywxDBdXI35b7rptcNKMn3XDQLB81Qnt8OJOXfvuuMtZn+jttD71/xQCm/Xg8sMIAYMX
 NNipszWf7hu/aoWf2AR1fWLsmwGvYLXo7dP7TJKO8CnPCipyBInATGZvm2tIKTsU2jatUtoQQz5
 +e7OAhEzdP3rTLKepspxuFXF0jU47DT2prxDSNkY=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX2ylHnwEWCgau
 Y7cHpU/UNIRcLnNVCsVdK7xEJOLk37Mfs3JnSTQLRR0l9bpKLWCTNR/ygu0u0Tew7bYmDDNpIvT
 9VYg7H5BLl9yMlBA+bIcH0O0XmsUy4cgCJE7o9mY+ZIOSox5Xux+

From: John Garry <john.garry@linux.dev>

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 43 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  8 +++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 30a2d01be8aaf..1ec7bf1835de0 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -114,11 +114,54 @@ static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 }
 DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
+
 static const struct attribute_group *scsi_mpath_device_groups[] = {
 	&scsi_mpath_device_attrs_group,
+	&scsi_mpath_attr_group,
 	NULL
 };
 
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+	int error;
+
+	error = sysfs_add_link_to_group(&source->kobj, "multipath",
+			&target->kobj, dev_name(target));
+	if (error) {
+		sdev_printk(KERN_INFO, sdev, "Failed to create mpath sysfs link, error=%d\n",
+				    error);
+	}
+}
+
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+
+	sysfs_remove_link_from_group(&source->kobj, "multipath",
+		dev_name(target));
+}
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 799569b74b535..ce51fcc002bbf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1443,6 +1443,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1495,6 +1498,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 50298056181f9..a9fd02bc42371 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -46,6 +46,8 @@ void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
@@ -82,5 +84,11 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+}
+static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

