Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF709472760;
	Wed, 29 Jul 2026 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322370; cv=fail; b=e2mVFr1Ajz2llt/jqrjw7qYDiIMD4woX6HntA+HzcBdYDmsVEQ67ZZcuoXfdhx87+HMhsUOxNOqo0yqODoSudJxgfkOO+wSlYfMyA65ilsyvkJrRpA4sxVBp9oR4sSTGc1N3YvklSkNPorx+4H7K6qcMGjN9vy4D7dVstFFiPyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322370; c=relaxed/simple;
	bh=6YEX+UGvwwjiYw3Cxlw6g8cycQhP0CifnMSkK93Wlh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T+ZD0MTJhX6usDUJDa9cpaIstAg1ZpUgaZnjLFFcUxrG9it5B4ShGySKibfudm7iK1xw5PIXFZOcH+py/fBtxGTbbpghnsi6qisMVF7P8PqtzYSGqTxtWRbYrbImgy642LBNra/hgS9Uk5y8oCifmZwbmddYZNl3SezrL58Uv9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P6+8rnDf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d52Kke8+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P6+8rnDf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d52Kke8+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TADFsr1120904;
	Wed, 29 Jul 2026 10:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ws669kiheucgSQuiamF6ZEGZzc/maRbIcAMoDgCkDIs=; b=
	P6+8rnDfS5hZqqEECozL5gKX5ueoQLRv2LK6y6c6dKyIuK6s2MydXBcRiMrQL4Bb
	4M3GOD3Zlfgg1iZB+pQp4NmRxCvznKvTMrZbQRn9tuPXVA21txsW17BBHDdDL82K
	h2whDuhxhXVMTlLX95I+ZihsrCBPX43LHFWW7wb2XkLCT3lIJTYbQHEsRDaY9OJq
	kKhyj0hBrQoTqAnpyF1247ENWmVLM+OgsoS1GpUyT7GlkEn3sZIyaqu/MYxB7xe2
	JLTYf39HCRehLM8o5v8w29MqDUC1rKkyL7wFauhJ7WYmWYsw8ilUJjhgKlGILUj4
	6/O4wGzmWjV6hBabYThXCQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nnmga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAeVG9022351;
	Wed, 29 Jul 2026 10:52:07 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013013.outbound.protection.outlook.com [40.93.201.13])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6qt958-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYcfEBKFp0YyEEMTzS9OA5bKVpRRDReHn25qbJoSNu2OsluT11dRu60tUddcviZ/6l6Dh+oCIX1pzt95H0S1OxEJuFOf6LSLlw6rde9Bly6oQzknya3WvkoJhNDlsImxzT+E8mFjOobqDvWZR5y86TuaAZ7sHjNBVvSRPF/GzHtykIP/SBMqzjXFreIn+kJxURZlAvzs6tAB8PU7xuVi4JRHxTMxEVAB7b+5TGc7VJdwzuPng+tEcq9PSNeEPiGPOdPvJoTWdVVBmFEIVKa5E9hamtJN6IsskI/N3D6k9UpGIG/tL4V7ehwSDCO82e5Fgx2UMuN+p8dRH1ZmG0wgOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws669kiheucgSQuiamF6ZEGZzc/maRbIcAMoDgCkDIs=;
 b=yFuhwfvkOSBsOP1MErRgztJHGTZMLDkegB18hAGWiJyMoWg3R0gC96WSk/0ccD5SB+j5Gozq6PgYgqcOIQOcFpq+PMxYvFQ1cXcTV9/sbLZfxEJZ1r13fPbyMOU5K8XObR0ZO65odkosXtD7H/6YVWXPjBdeqChYXsRMC7ujSFDPYWAZ/WutxBC6iTRzJnsC2R9RdtPneeOa+lRIwD5lRFGfL6sm0obUNzktl8thQihF+WsrR6LtdW0sP7BIMO84M75CMq0sWALIjNGWfAhpkv8ig9SMdufXg6uBkcf4chgHzVrpqbtlrY7eFwd/R7v6xgf/Msf9J6l8SvbEo9EL0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws669kiheucgSQuiamF6ZEGZzc/maRbIcAMoDgCkDIs=;
 b=d52Kke8+mQdGxS8wK6tMhyTFzFupuH8wNgppVz+uK4Wl5Kz2xsFMbIPceCmG0q0P8D0iYMxU8NLCPOValCdtxCC/5TPNAtq5jCOGY0sWRZ2Ja5SejuHMUu4ruxgOzTKNKycofDsjgCEO5JJ3aHUXURub6CqrmJBZGH3HPoaaXtE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 15/27] scsi-multipath: clone each bio
Date: Wed, 29 Jul 2026 10:50:55 +0000
Message-ID: <20260729105107.255712-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132E8.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::28) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b38ee5-5b50-4e21-8346-08deed5f6c89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sI7n5EDTc6LH4XFT/5Lt8LCmRNGsrE1PHsE3yg1XqbpiISlO/V8lOzqw1Hu78QePWs1MziFtXok4d10Hj2UODTf6qHeKcj/F7HG1agDfweV1nwhX6SUZoXuwWbsuiIvfZS6CQrUe11/SvW2DsxVjJtbE8DivQGSbZAhuTkAa7Wv6+VUaNaOF+LaQFiQgQGjoi7z57y06Nyz6e0p8//9bjbm0vSFtJx7r1AgsVh8jQuTEpEVH9KpC61a2edZ7fhHbnFrE8GdrQJGwjeC0ypXS5OJgg6IEnpyoTzFccEYOCtr4dRvsIS+S1yswXXmDXS1UFKUQmagBroQn6oUX90zgM5JDZ7gzAOo1ZAZfD/Ci7I6T+RCaZJWgZHEugbKndqM1CnxPUrSzyCGXmAaajSW4hd1AKTkfA/RMKIBfr3ulD7ISkwqqFLduYXCU037BxIGB8yG7dRmxaZEjq0WQDiq9KDk77IliiuLeNoOmq48gnUavKUzKk19j/FxcYjWhgbaPs9T/knBrDY4TmNRI7l5FngAdACUhpqV3qCTx39/PVQjZynytS9yxF3Kkr3RPDsJIXJnDM4g/mwaVZSvZGEhlYM60jeGaaw55AC+0/5KFvKpoXYYqAVKnDuyt5IfjcByiCVwWcg3NjB5aartaQeWJ6frMCfnEDLgK+etO07Oq1RU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CC3QbxT8DquBwGtjzDoXTqAL7tOk3VE4gXTIZtOrBreCm5ijUlPt4K/9kttk?=
 =?us-ascii?Q?OOk9LZkmEGnLlqj8uDDgRpMWwZjsPqnnZ2goGMAAFMS3Zd5IlucV2HCWY69E?=
 =?us-ascii?Q?WN2ZjkKTLRNsglPgIZxh7K/KDQgoahZ2DgRgdc0XEjddE1mLQRMC1vhdQcOz?=
 =?us-ascii?Q?HZY0Y9oLgMLfMFFLL96dh3bBR66gZ8Dzl+31+6Cods4VxSPifxQbfQd7F0D/?=
 =?us-ascii?Q?zl1wpE3SjhruBLLQTeg6EHi8Q4nuuSTQb0XjeFyp3njloSTKCg3EsQo07j6I?=
 =?us-ascii?Q?KQZE8AgzDqz36pScYDMenQpYt89LKbkDf/mUsa+Xrr/Rm19j1Iz1yWl+iGvv?=
 =?us-ascii?Q?e95mGxo6+yoLlnW2SPYVFNKhmzKGLt/noMIncG8YA5BFwdZksD/Udrb/Sisz?=
 =?us-ascii?Q?SCxcdqDHcjYN6ZNyfxnodBV37e9UOb/a19BtIo2QxjLvJ7RcAMoaprwfJHvt?=
 =?us-ascii?Q?GwRDDc54Q1pnfpyKxT73eOzwPDO7eAY/SL8r96os2Gxb8jK3wjoIhnNW6etZ?=
 =?us-ascii?Q?IKb6RsgrGI/Twl2kG18TeRd7PiLLZxUwHvZGXj9Gb4NeaOYmDahxvNKZUpvQ?=
 =?us-ascii?Q?0pUqCEsRxEITpiG2zGTjf2gSutYCwACOAJGEGtCjoWIM4BFBJM8JilGNWOIY?=
 =?us-ascii?Q?XbSMcJl4oM0fq4jAUDxyeVnp8MlXQdqTqsa4lUV98TeiXlT87sxPdevtAtPK?=
 =?us-ascii?Q?w08iH/T4wLw4X6bZOhpXckYMAX8v0LwZk3e1Z5gNYf24A8drdy2hEMWa6Dwz?=
 =?us-ascii?Q?6jmP5dlGw5230+PCpjj3kEw9r8ncehCf5iJvBgIKgkbdyslanvH28YlmIMb+?=
 =?us-ascii?Q?8synTIPMWNTR4UHZvgMU8ycavduDY9aXx0zseXCiLa/I4ED21TA3W5//12jq?=
 =?us-ascii?Q?K4etesBT+GmGFb8LI4hy15hEQ5Ji5fnmXqoEgCnAawonygmv3lhbvdb0H48z?=
 =?us-ascii?Q?1Gwe6Uoqg/uwTPWnD+o+0K154oZzRew1j433n8AMS5HD5XFlUgJCPcYuC07/?=
 =?us-ascii?Q?8Myb7b4VJVgTMyFBESEjRZtOfg5vsItZNB5p6uo+XGi7ElOLEew5qcZ3Lu0W?=
 =?us-ascii?Q?3+wVI+fW3/4n+jGeuRii3BitmlYRObELSO9A9EqHn5a9H4alnQnohZIxHs5k?=
 =?us-ascii?Q?hiRxz3q9KsmMh1veIaR+vmZE+MZW+6WtClX5cty56PLz4fUOEft5eT7OWfId?=
 =?us-ascii?Q?q5x31YGnpop99pNAb8tKR606DRK4uS0IBUqyG9P27binJLPj1bzEQg9Hu/r9?=
 =?us-ascii?Q?u3LiywYPm1eBQStGabEaknll+e9FRUb64cADcPq9VlI+3n4BsqlNkcJtaxqd?=
 =?us-ascii?Q?tJ0k3H262wSOI+9knnRhuq5d76AbjryOWfH5ZAfo1R2RIl0NejInBw+/63uZ?=
 =?us-ascii?Q?KEZXILtL66HgLFj+LujOa3Pu3da7YnEFnaze1N6gN0C+eWCnjYzpxGIYjK3j?=
 =?us-ascii?Q?ubfu2J7pucW0UGJqPGmYxZky4vUf7QiQS5iobqexUWHvkaJWdctRB/AZYSSt?=
 =?us-ascii?Q?69BkOcaQ2r3iwPcS/VbOxh8w5BLb8ufF3wgYq2E0P3i+V1yAOhMhOEx6cP5C?=
 =?us-ascii?Q?fVxCppAMvs1gK2d5sjfy7nQwMXq3lgv+MAott9T5SY0jFEJyCxeOozlWHxKm?=
 =?us-ascii?Q?cmSDkgIcBBvfspq4MaaUGx8r+yDhIflLvp46hod1VrNtg7DJoxFCZJsm/ELp?=
 =?us-ascii?Q?4YId1x+qrMHwAt4aChlA/XnZZX9ThiYNm5+pgiMnwrEfnKJTFfY4XFIn+uPo?=
 =?us-ascii?Q?GOXGsyO5MQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	psS88xUFZE8h0mIissq88onPd9/gmXkCxAppz4SmYMFTWzic+i0tsYYchTn9X8X2kRvXcJhgZBqC93McWqwzpG3uANg65ec6ufS1UhB0sbNq3/H444EnUb8RgtrJgROoFxBE6CnMLwbdjnyVtw7aa+frwI76Ai5gspkEfnkAAgZ72HcB6UbxD+AX2RVRJeb3z9FKHXuWJ7BWRPIHyP7p7FN0439BrZmVJyjikEi2SYc+rFSYQ+eKlLB6uA9nsq0K80Cs8szMAQLrheBS54rpM0Rhtj6en+GX691EICKrtO4W/GpKfU5TClFNmzcpxIcPWLuaxomuBrsZIsWcBX8iWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jnv39JvC22zMUDc1OXMewddYVyq3tM5ssd1DoQp+p+tGMedcIl6LEi6Vc4zIABPOIB5ePsu2qYBWgMJ7Ml7oHSj04e6z5iRekzBrcpHE/ldaWzfxX9D+2Htp1fwSjGBQI2pEMjQORspgbCFoGZT6oQcvVoxMx3uMCdIq/TG6g/1Zw8usOO7UGb5xIfJyZ9Ody+SWxhGPPmahAR5nBaEowUubmjzgASRrdXquMWQggyXMdSyy5ft5jvjFKpueAJHM5XjPHRjokdkOw5gizPJKH0yrphmv2NK7zLJn12I30rgZb4VGxDWIzBRYYWoW+d/bVkJT0RoWhUPKX9+IpUssWTZ9HlzVAoktdQoNOkDJB2N9UXkVD9HyNd7K82N+fOThoOQqVpBdYrxs3NwTRE6xhKIAqIWWCpcOpD0+vFIi+amXsvjpu9dLL+ebwTRbIakLp9iDJNe9qJA+80un+mPN1n0oPbD2jtPjtbhEU0xi8ZznYGY57IHKgVKHsFszBvprLF/Tw8fNxfSiZERmjHg4v58tn6pXjI3iXMe+mYiPYpZ32pP+88uKy0Fd6PuLhwt9KqNl757LpCEh6K2KNVIK91G7eRxKXvBDay+veIAc1XQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b38ee5-5b50-4e21-8346-08deed5f6c89
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:03.4164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpe7H+/INlrolfWZ47MiynOn0JCkGlwBp2vg3vDkCQm/BVXif+lLQM/tEyakIE/GwXXKBUc/cnnNX0JlycngWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290088
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a69db58 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=PbwEKb89bYuBhGpDIggA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-ORIG-GUID: ZzeXELoigfpJiOOCQb1X-4TE-hjM5Nzw
X-Proofpoint-GUID: ZzeXELoigfpJiOOCQb1X-4TE-hjM5Nzw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX3aKjV+OHMiWF
 M5iOMi01LHng8KW1Z3I/Ktv62o4t/aCo2hJCYN6BVUPkU581eLdxUIb0WhJeqgeQKWZqkCTSayn
 nKFhh3dSyAA/cTI87mGRypVo9rZIBLkcmlPxPsOagWoGxoH7bPi1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX1UGiTzPKczvi
 BKK7AQ35IykOWiwERyjsBRZUK9RV+bDQz0gMT0fjIgdeG3o00RHvZUohXQBuBefzVUMupMinriL
 hQ/rgUnCjBuaFUspgMOhMUxCzCLKWl/RreafXFJo1Pqq8lyxpDLtmfvjU30JsVRDZF6oaqAOKX6
 TMyIOEbsgGXT7s5z4235FV6bv3MUOpaDvlZLYk9fTNv9cSCHbyRr705JOepeOQ278Z8L/eFWu29
 UwnlIcdBkdGoWvNE/mLpbMMTJ4LRKzxy35mPbxLb72fMRX0GHg6ORmZ94mT/Gw9RZE8s2UXyZSw
 vChnoQvi+ZIr7iEKEc8OQqlwNyZlrsKjwGQO5VDegEgnpdYCL4v09T6SBemk0tWdEKTaUDhJrJx
 y31uK7ZX+RcZPeYqBj/FDUt5HhjhSey4PdSn+KzNe7P7LKKMjM133QHP8gZGwdVBcPaGNEPCc+m
 7ijxKE2I2/GoycLUYRxhg/7/GDX7ZKrf7+kq2Xws=

From: John Garry <john.garry@linux.dev>

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 593f94aac70e9..0d439cac6447a 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -99,6 +99,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	ida_destroy(&scsi_mpath_head->ida);
 	mpath_head_uninit(mpath_head);
@@ -237,7 +238,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static struct mpath_head_template smpdt = {
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
@@ -263,6 +291,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
 		goto out_uninit_head;
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
+		goto out_ida_free;
 	kref_init(&scsi_mpath_head->ref);
 
 	device_initialize(&scsi_mpath_head->dev);
@@ -282,6 +313,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 
 	return scsi_mpath_head;
 
+out_ida_free:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_uninit_head:
 	mpath_head_uninit(&scsi_mpath_head->mpath_head);
 out_free:
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 2dc02313b0496..5cc37acaa664f 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	enum mpath_iopolicy_e	iopolicy;
+	struct bio_set		bio_pool;
 	struct device		dev;
 	int			index;
 };
-- 
2.43.7

