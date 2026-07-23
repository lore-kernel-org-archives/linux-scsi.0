Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967DE42A788;
	Thu, 23 Jul 2026 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799440; cv=fail; b=MVoPRD1QBBGQacVle/zo+FGqt5MgwgYXQ9dHu/6aq/jWZBXBVGN0Chr7zvC/uL0911tjtIh7ZFq1ypr4DUOwfk+IFzsixEUUb3MeL3e1GpwFYAKbfvOnwo9TbRL0nsBVEhdyk9k/2z/AOlPxEXQrILyxy1fIYDvqgx1vUIEPhe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799440; c=relaxed/simple;
	bh=6rdmxMeECp678pI5yuTHOdVmDuMs0QA58leHz9ItR+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vwt+/yySjTB0A1cMMzjJtZTHbcUCxt3wYL/sKODYEtcPmhauJfiKEBUcdHhjd/fgW3zimmi5mNLQZWsUGJ6bQ0b7/OYz/VKVhJUSamg/dZqDO2R344DzajJ86lU4DRMYVlOtYka9MFR5XFVqe1RCjWBMx6/M0a6kW29c3dbFw4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QijBaa+t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CqKeZ4za; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QijBaa+t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CqKeZ4za"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtl2w3378008;
	Thu, 23 Jul 2026 09:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0cnZQpy5/yiwLPQ6XRScRSBdQlV0F+Oot/KnLV8hd8I=; b=
	QijBaa+t3/DUXV5PAVLXRmUH4uEHjU1HJ93eza03fiW+x8k6G+o/uMphSL44lkMv
	GQpCJlJRJboUijmmQLolJvlydj2+Z7L97ogEKkQsL0ad2xkN2IkgPH4DPc0Z2Jis
	1Hd88N6u0Vd35QaUicIwgkR38KXVIOZlctYteYeV9qcs1d7EYrCx1WqS8ojwo1mD
	QLzHmmNfN1FOsBNXDiyiPJkN3H5IWWhoUbZSo7MkBGmpX2JwmlMAZ8nhIh/81NoI
	MiCorDwYydB/o4kkRIJ87lDEDgYFIzpIvIF/2aKixqWMAtoKio4Vm386OvxM8zV3
	I5m8Arq3XZmgssDkTHK5rg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6na0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:36:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XA6Q021265;
	Thu, 23 Jul 2026 09:36:55 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y3vu-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:36:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MA6MMCUfMjdwf8Mqoj+oRz7OLpGLWN05kswT3w+nrBjjsoTRT1S1/cQYlnKtB26SON2PcCQNks5jCzSoPYmnskwQPDIzCOtOQVBiWlfgHYZ0EOHpbTJ89TW7jONY8omhTg7WU5e1fOZzee2FjJnfEhPuVf1i3sbqXzfmQp0UzQ4GuQo77/P+QpW0IIUyBrwEOye80THi8zjMTyqZbiKDD8oUnDFLdC2Oq3IArfHw8cpCnj312GJ24EsetpQKBoeW32doL2caSaQ4cOEYbXH+oiA56Z8sNi2wIp/3tUeTbuLFWEIQ6MQoOkfMDCiI3cZsfLUJeEWQFtVfxjF1FXHA3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cnZQpy5/yiwLPQ6XRScRSBdQlV0F+Oot/KnLV8hd8I=;
 b=oIU48/wLT4QrFiwdSlJUU+MgPAYaYsopmgOvtzzQa1Le3WM/3JyC4bsEubImuWLovIbSZauBGwc8SxkJxN+GKLHRl8jCHyyMxuy8Ma4vty6tTzJ38LVXyrRZjPdesU6oYqxB1Qk1MhvDY5IhVXYH4F2qU7SF0QmOhQqqfWFdRxogHPp+TG6dGO4o/hcoCbbbp0TdQiKDGC9y+EpN38UCm5qtP6kEse4NHIPKYeP7IDIqR8bHOxnn4Ij9R6UJMsJqBR0644UpF2yAwaz8yBzfvy5+BVMpq0GedLfD0MoReiVHRlwLSuw18Rs0hSv4aHWILoZwDIxStki8OaQc8tL80Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cnZQpy5/yiwLPQ6XRScRSBdQlV0F+Oot/KnLV8hd8I=;
 b=CqKeZ4zaTEbAAvg2kl8rG0TOvFSJAmELvrPC5eYoglBG4W5HGsii88HWl69w+i/Q310XpeFYIRb09RfCsfsoce6z3QU4Cvi6YUulh2ewLvedIa4QVvt16P+/0ZkPNx0j6PdK1SjJ3sLmKDYbbSHlUCzUXbfsC5+vzh+NNkNCqVk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 02/28] libmultipath: Add basic gendisk support
Date: Thu, 23 Jul 2026 09:36:00 +0000
Message-ID: <20260723093627.2327456-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0185.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a33fcc6-5f18-486a-bbfb-08dee89dec88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	aNSy2jLnal9UGu6tO8Ptrh/9nKihsA1k6BFYBLZ32s3HTuyCkQHxVBhmHW3Z1wKq2V9TcjMezDp4FKMUwUnp1rxGf/7CEDmk3xhFlx8X0ur1vj+VPd2KX6GhBRsfOjq6IyLCq83TSYJY5jbgUtN+eYln8DqArljxV9iticXdnh5J92Bw9sXwuGYN1pJxNo1xaQrRW8HB7lQxOmxn5jgunn+OuYhNg2H9MS6wcQs3yjVd6zUmJzkUoEWHaSScsX59wO+KgjUxefgUYW9jYw/aLk3Zus0RSOiiaRhVNvKOuB63aGJPw7rc0v8xGwwag/n4q2aA9lD1s8ffiwbF0B4kY/QurfAw1kBC4OaQXVi4ZiBqGxpAV3pukvCyxlKixyKrWevaDlZfkN01znNgsl/YkOPy0UKo+TU+QHnu1fmTq4yrUuLIT+pvAa9Q3cGMF7pA8djvGcXXqnQoAWTCuKylIFvlZUl5HMEVBtgKqHxu33Olh/8Pel+mpgCnl79CQt1Wbmd41OZ6/JM7a6CR0vMnmQczl0Ezg6CJMOsz6KRB/xrw+jfHp51VCFoBjJwkUqex2HC3P9cM0I0G1oHa4sFJYkZn/0y9Wd4K2vbijy4nzwoUqAix8M1kaRtXTi9tuBLITpXHVG4J2ytn3wokO4XdVxuC6Il9hamIfmfrm3TAfTc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WtK+9JayW1kTw1gLsBfbs43WY6X4SXmmR8ZilSTVqE1TIj+GfpJrE//yZvkn?=
 =?us-ascii?Q?aOyHa994tWYHJ1zc0c75UMbT5x+74h92z8AiEcJmUP75Y7gO+LqCF2DT5Wa1?=
 =?us-ascii?Q?liIkQBH23qo7y8mtI2icOR1OlxOViZHtPQPvPRp9lTjatlRS7uqx9g4lGazi?=
 =?us-ascii?Q?mNB9AV+bUuhXGyIZaoT+FX22Fp+dKwobiI5mnkhs6zRY81qDIB46BPN/6cEw?=
 =?us-ascii?Q?552bPDlkbltTozrKRMCNQXHLRTzmb5yBSDMIvu0hlgRBe8vFK4W0ritqaj+F?=
 =?us-ascii?Q?beHlbK9RX+T2gelKFu0o25M6IxJBbFaSY/vTZceMOpdcnAKwC2uKJPCMqBWO?=
 =?us-ascii?Q?X5Exy8V6DUHX7xd7Nvw4FiTqCAdsPPYY3Uu+d7rxIFIEMKxIZa1pJ+oinoKX?=
 =?us-ascii?Q?USTqywqAQ8IVLyrgSAZn2c7m/Dyq30wsqbPP0dvI/OtVPcLtTxrYW/eQV0Rr?=
 =?us-ascii?Q?hiVl2OEFZ+0WKfY803/0oqDCwveq4q95PyG16ZEFly4YfZDxtt3BwODP47E3?=
 =?us-ascii?Q?SGI/mTqurGUSSu8jsKvMlMxvEqcI2PZ4feCp6Ab2y7PAlZEX47eEAUNFnJGN?=
 =?us-ascii?Q?qUnIGpgdwIg3vUeNCPDflvYpz5ET2lbVcl1FQMbm3FgH5z0Czj1Qt/vH2Cel?=
 =?us-ascii?Q?D27F4JypBFHgwAeouLPUhqdQImVsKlXgDzAchIU6vZn2WB5rJLjpggxwb7u8?=
 =?us-ascii?Q?X1xdEy1KgIQAepYY0Kb96GiwbAIpb6mkwhj9LzBX+qGFyIe4RG/IxKTDejZl?=
 =?us-ascii?Q?68nlos2IDFv8aX1ATePhUuEGtpKoEYyiSb5kawMEqUn782ArQTvV8+fzzqe8?=
 =?us-ascii?Q?KtTutP6KUmqv6xtPCgSCOcrsqaotMS2JXYiePbkVgF0152XEBv1CiaiGLpvi?=
 =?us-ascii?Q?MOHTOzfyc5HR32Y/cI1J2FFSspn5+a1t4bVkjeDREg8WsqfkIBKzLOlUYjGY?=
 =?us-ascii?Q?s+cLvV+wwvGFmsuR/xcDzBfJu7Dkum9a3lPZdQ7DitisaSpQf1hYQMU+Ie1s?=
 =?us-ascii?Q?/AkzGhJdTPRr9R0nfMSBhGpeye3YLmVpNmxceQ9b0464PPaJ8Glk7ClzlFBI?=
 =?us-ascii?Q?WLFmxU5aRLD4iB94m9ZudxZvkyjrOFNoVViF9TDJev4vr7itOFPwadzfuoGk?=
 =?us-ascii?Q?9HhxmtM2EuyuSUu+KkVcaZXZhnGBglqWiJSlwnQRwpmG7zMWUF3xdlVGz6jH?=
 =?us-ascii?Q?BpmPgS0uhVrQqnKJBzq0JIovsf0KlS7fm7lFFSwcDv0eUayNkGw0JS3rntSN?=
 =?us-ascii?Q?D/vOXW++aW6X34Ul87Byc0YR8+4NUdtbcsn/EOF7Cs+Ze7xcinvC6+LX0bhB?=
 =?us-ascii?Q?br3qd9ter/g2zJYIF4505tGfJFywNgaZHl+XfAqTEabigXNxSKL8pce7boav?=
 =?us-ascii?Q?/ci9hidAJ3mAJIqu3belJByezXC8Dk64A8ddDf4f0bW0CjY2O3J0m6wDG2Je?=
 =?us-ascii?Q?RQ3/DzgCjCjHZQTZffYQ+X1xm6cmNT4Pf5dzB1OcqMIsUkjnWOkrhRwzw2q7?=
 =?us-ascii?Q?hHzNxcgcb2mctPKT/mIX+kBSEVoVvwm+9HU4eN6nLCLSx8sdNDNC6hulgmD5?=
 =?us-ascii?Q?TtiSKFEdtAvDzHqoGngB7MNjx2EMe5iRbcTtE5b01Yg4u45YxRiS5g+8nfVr?=
 =?us-ascii?Q?QfbQvAx1RcOvVA96WdOhQlthZdAAHJLetG2WkzOJUdsbydQ2cnLuaaq2Oa6z?=
 =?us-ascii?Q?tCUA83QAPscUwjSZGpP9ZpkUBPlpN/Vn1zhvrNiKJOn2mXEDF+YGcc7g8Z69?=
 =?us-ascii?Q?P/rxd5lt4A=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	DZvsoJw9g+ADOOIfT/IUXvQC8jlDxxyDUZg81gxzCHbLY0QrQFen8kODERpEkabal6uByx3/++EnRk0QAoopDy8dZV7bo/3qMlSXJCsnGBq5vhHpOBXMI6F1jCq9PGWUYfVQbBiutn7csWLkWevssbhbiJpwecTPVRiwD4xkfUuUgXEnyN/uDcOYbTIHAT3x+ZgtHpuy2VehVv5JpnBkPWAYYdSBNTSYfegbgY3A9ihiS1e/gmETdIVs88tyl1OTjFc/sCioiq+7R5UgzCBSsxoa5LYsl870Nfzpa0hgJ8yUfwg05ZLG+0R+Dz9/5UMUF5lsRnp7vQ87AQME0MBKZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vpb81jSXVJcEZHmuAKVjsma0E7+k9a1mvev/pDuAbSXzPJFJpOlxkmEBzCPcQp2qtC1OGsxp3dxxEdbfS638uaOuDl6Vj4WU+YuVPhMQ2LLQ92oFvUA46AE1x4dHBywxnDtEETxxddiy/MJ1tojLb7SuMBVPz1IuC5CPlCKC5GUeu7QixiSi/tSBDjgL3aakCZEmBXPleX5VIY6vQpInULjwYM+BspbmwQCgXgREmheH2dHgplJmar3BSNjrkGwyeMKM+eAp6zYAHFt/N3G/eeulP/aJBfIjh3ZqUaW1pxrfuvy7XtCj/HqeUJpL5rzZkzrReReqh2d4dBOytg5emKip2ImmUSxwcdaZfUrfTbVEpLzrm2Z9UHk7LDCNw9mZuM59jFo9a+JFdqg0sADY6AenITanmw0kePcUxyXGZQzVYYyjhBYBp2YucT1ZUAgRUnfVbqdLEgHyQr/6U4zzjYrmwt6JazXmp5oEljgBUZttJ/eNO2sKy7TTVQmeCTTht6Xhl1/c8+wobLbB2xg9ULuc49v2cnfed28O/eDApY/CVqD1H7rjRHBRRRV52JNvHH7hC44exhGw+xTCFpO9++nAwZqmZXihRGuYLtW/DjY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a33fcc6-5f18-486a-bbfb-08dee89dec88
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:51.1978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2pDgfftcznWrUTD8BjHcVbSNdMfZfYswCwxfUyvOwFw7WVAhG81zW4pWefHAMANmWfrmNlG0txoskxj2ms4Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-GUID: 4ZvaU-IAGkYuHuFR7hQ5gYmfmOWE4t4D
X-Proofpoint-ORIG-GUID: 4ZvaU-IAGkYuHuFR7hQ5gYmfmOWE4t4D
X-Authority-Analysis: v=2.4 cv=IsYutr/g c=1 sm=1 tr=0 ts=6a61e0b8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=B52eoxIPv8yZRAGToxQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX4fChoQkOAruf
 LxxKzj7FtWla3nEnUbB0e0fXgvbXJ6EEzqDW0OkueND6RtX8Rss6OxX9ezKFw3Fv8cb6BdMG1cT
 BBQ+89oPBJQdvqJnkWYMPhDR86WEUpyCmzUGn5XMqoQHNmxKz+c3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX11n2Uutd51sM
 7T3l5MCqHCfRAf9wMFoWtEovW8XG7COCp+BFiJjMfKlkmDWzSaHWe5UrAUHU3LsOeYML6jL1MpK
 EwPNa7gisHMGSuO1nNmwZRosiyXqACk4qLGmb7txK6gjvtCp66NqG7Q3IoOvz/xuUmS63B0Ht5b
 /tLQ28cEMvqwOZHBs0dZYIFtS5Mxevk1O9iHLPTNRRR3C4XjRHEpG2Sco7so8xaQBIee4lmEMbP
 VaFAyGlung+Pvb2beqiOnoGfoY/LNty5Z6YoiwJJzWOh2l2TBqX4JIZw60fNFhfcsHywxuB/mwF
 cEdKrKDi/xJbJHtFbzi701K09oGxOau90IVN3LM11Avv0feNY39cEobh5QRe3mq/oPl5Tb3Orbe
 DF07ULrgUFx+FaWVkxiIYc2HdObX4VM3+HigkUU0rGcQE4+oMWc3zr6/YuG1RJS7x1BIHzQx8dj
 IUrIFz5HVXbEI6a7Unw==

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 38 +++++++++++++++
 lib/multipath.c           | 99 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index e98b4b241020a..ca8589d5cd8b2 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,11 +5,19 @@
 #include <linux/blkdev.h>
 #include <linux/srcu.h>
 
+extern const struct block_device_operations mpath_ops;
+
 struct mpath_device {
+	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
 };
 
+struct mpath_head_template {
+};
+
+#define MPATH_HEAD_DISK_LIVE 			0
+
 struct mpath_head {
 	struct srcu_struct	srcu;
 	struct list_head	dev_list;	/* list of all mpath_devs */
@@ -17,12 +25,42 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	unsigned long		flags;
+	struct gendisk		*disk;
+	struct work_struct	partition_scan_work;
+	struct device		*parent;
+	const struct attribute_group 		**disk_groups;
+	const struct mpath_head_template	*mpdt;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
+{
+	return mpath_bd_device_to_head(disk_to_dev(disk));
+}
+
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
 void mpath_head_uninit(struct mpath_head *mpath_head);
 
+void mpath_put_disk(struct mpath_head *mpath_head);
+void mpath_remove_disk(struct mpath_head *mpath_head);
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node);
+void mpath_device_set_live(struct mpath_device *mpath_device);
+
+static inline bool is_mpath_disk(struct gendisk *disk)
+{
+	#if IS_ENABLED(CONFIG_LIBMULTIPATH)
+	return disk->fops == &mpath_ops;
+	#else
+	return false;
+	#endif
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 9cc398d266adf..916d01a285284 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -35,6 +35,102 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_head_uninit);
 
+static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	return mpath_get_head(mpath_head);
+}
+
+static void mpath_bdev_release(struct gendisk *disk)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	mpath_put_head(mpath_head);
+}
+
+const struct block_device_operations mpath_ops = {
+	.owner          = THIS_MODULE,
+	.open		= mpath_bdev_open,
+	.release	= mpath_bdev_release,
+};
+EXPORT_SYMBOL_GPL(mpath_ops);
+
+static void multipath_partition_scan_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+		container_of(work, struct mpath_head, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &mpath_head->disk->state)))
+		return;
+
+	mutex_lock(&mpath_head->disk->open_mutex);
+	bdev_disk_changed(mpath_head->disk, false);
+	mutex_unlock(&mpath_head->disk->open_mutex);
+}
+
+void mpath_remove_disk(struct mpath_head *mpath_head)
+{
+	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		struct gendisk *disk = mpath_head->disk;
+
+		del_gendisk(disk);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_remove_disk);
+
+void mpath_put_disk(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->disk)
+		return;
+
+	/* make sure all pending bios are cleaned up */
+	flush_work(&mpath_head->partition_scan_work);
+	put_disk(mpath_head->disk);
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	if (!mpath_head->disk_groups || !mpath_head->parent)
+		return -EINVAL;
+
+	mpath_head->disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(mpath_head->disk))
+		return PTR_ERR(mpath_head->disk);
+
+	mpath_head->disk->private_data = mpath_head;
+	mpath_head->disk->fops = &mpath_ops;
+
+	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head_disk);
+
+void mpath_device_set_live(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int ret;
+
+	if (!mpath_head->disk)
+		return;
+
+	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
+		ret = device_add_disk(mpath_head->parent, mpath_head->disk,
+				mpath_head->disk_groups);
+		if (ret) {
+			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
+			return;
+		}
+		queue_work(mpath_wq, &mpath_head->partition_scan_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_device_set_live);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
@@ -42,6 +138,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 	mutex_init(&mpath_head->lock);
 	refcount_set(&mpath_head->refcount, 1);
 
+	INIT_WORK(&mpath_head->partition_scan_work,
+		multipath_partition_scan_work);
+
 	return init_srcu_struct(&mpath_head->srcu);
 }
 EXPORT_SYMBOL_GPL(mpath_head_init);
-- 
2.43.7

