Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF0A2E11C7;
	Thu, 30 Apr 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562630; cv=fail; b=rWPg4GMtiqsBMDwoV94xV9BSz2YC2UUCWzLJufNYjvWE8riA2insOAI5msSShv/H9wmZXSnCxCtxo1WQJadCNsNfEZW1GrxyIQlYak0X8+6yA8yn0u4aaPEaLvtdF9EmpwNwxZhnNpRWPCWyqp927v6YK33gtrvTBtQ6IoxZIes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562630; c=relaxed/simple;
	bh=bSkN2pH6H8f6rMg3z+LF8rXfZWLqNh16M4zr3yXTm8U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ROynySx3jrdLSb/YjiueOxjjhqpcUEC7EPqMjib6wVwZ0BTMLYJhQfV0zC7mNjdSyRDUAJLB4xJeMUf+m/EdzrYf9pmFnVl50j3DSpdy0B1oY8L9NkEpCv02srwGoEBBWuyulaSSSx4MRgNypk7Kvn8R8RvTv4txFgRyACxhBNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y9xXY6as; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xxcWTLZr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y9xXY6as";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xxcWTLZr"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCff40838683;
	Thu, 30 Apr 2026 15:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=w8hjWZJMolD4zIl8pK
	KYtJigDQZJkSOJt8OYrKs8gao=; b=Y9xXY6asczT8bsiMwZVHnGbvfA4qp38yct
	EonowUS1GNF8/HFtSUQEkb4s4Vp1pjGgQLFFpiQnZiwFMe3gvmp7knIEtbWZU0br
	bQgbSqlkDgSMrVMtEJFeGO/zaeZfhlauTDFfFYrlbSyDJ9rKSm8Jt2jm14GttGkQ
	L1DY5dNGHT9B1iL/yXyZcJY22YAfVdspVafW42BQydkGunmzKDmKdQo2KP9TBMfj
	VRZv0kgw24UL215v6Sv0tCc9H2dsyRKV7sFTex120yRE2f1oAeyQTrqsn2ArpCM8
	6KSYDfN33524vNy7Ys+vBEUABtTaUpkp16VGUO5TS0gJk60nBoGA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmhadp7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 15:23:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UFLQ11005041;
	Thu, 30 Apr 2026 15:23:31 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010025.outbound.protection.outlook.com [52.101.61.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2nuntc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 15:23:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SCrBNG98EFooANzHdEzBMcLd12bA2YYx/V0hC3Ql2ynsq/J9B6ZFoqTis+RLuhXXgPm5SwniPev2GskyMboRtE3jqNPPhhMhK5OK3JAMJk2LuH/ZIlqArtKOfViiQemdySBeCZdaVmkkDDqWIw5gGWsgJoGUvymt5XV/CZSsz9q/CBo6Oi69pqbbxpzJlY3nG37RDSScEGJxl2lA3bPKF7vYcYvJ+m72paLIhbr3OcGpjYk/7Mhd46M/F2lM+d5DPNSyvoIqDpOIgQAr+6vR+qaTckMmHeqi6Xk9ahDOOLS+oC0GZnlGcyo1GMH9yWNJeGt2OyUaXRKb0ufxBPRo7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8hjWZJMolD4zIl8pKKYtJigDQZJkSOJt8OYrKs8gao=;
 b=FwuzGlfPVPbwU9F6+Imw+eqYwpoM+R8hnKyL5eY3+Fndp1+176/bNb5REjuP7qx1MdORBHwk0+m2v/pc8pSWNriOr5M46ePZtEJkhUT8cOmCBlEd7oAbSLDdtRh/fNUgS+cpuFA22ZRA2BLqVxYvrXHe1io9jl6DYLhkldyO0Ypqf2s1zPdYGzV2QM+k7qHbnIJIkvAlQkxsLmDgE9Nbuv7aFFB/G0CpaagqHqYEY5FBp9xUtb5tUV3UhKUTY3mt09vKNeFwTjsTXYXDYKmnTUF7PEFEor6z8N2oEkpVh/D5+1Ovk8tFvxjL/+Yw9VMHSfqAnCArUKeIYiQlmzk50g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8hjWZJMolD4zIl8pKKYtJigDQZJkSOJt8OYrKs8gao=;
 b=xxcWTLZrml6vKsM3s8hUBewM3qsyMYsjr3s7KymT7iSpjYEOUFeHZxv29twhH2ZTNjljYsmf46I11VLpjq9GDuvJjtGDHzsIOOB9tT1bNkbHrTcT0V+nuDwvdONfYtX/fi3fe8s4YH2fUxAl5EWsFPlPEzlYkvyR3MJKaaGBzfM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7234.namprd10.prod.outlook.com (2603:10b6:610:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.22; Thu, 30 Apr
 2026 15:23:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 15:23:27 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox
 <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
        Jens Axboe
 <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Johannes Thumshirn
 <johannes.thumshirn@wdc.com>,
        John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: advansys: drop ISA_DMA_API remnants
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260429151623.3899875-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Wed, 29 Apr 2026 17:15:37 +0200")
Organization: Oracle Corporation
Message-ID: <yq18qa4fp5q.fsf@ca-mkp.ca.oracle.com>
References: <20260429151623.3899875-1-arnd@kernel.org>
Date: Thu, 30 Apr 2026 11:23:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:8:55::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7234:EE_
X-MS-Office365-Filtering-Correlation-Id: 88dd9d5c-2e89-4783-9cae-08dea6cc6d68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vlhwm+9AC+RBLsILUKdGdyRtLBqj/w98fTp8v2OjW24PCunzsvRFPCcxw1SfWOZHg1Pu5l50V9NdO/UDIAYJ00l3C0yyVI2lSTLVVrpovvw+DV+UCh20zYpOBiGkthhAQe18pqfwxjqx7iebbOnzrmby/Vc/GbcOZORant3KojUqwM/b/F73Z6v3z9A0OcJfRq//QgqtSVCoSE7FNZxhLlr7grlelJMBRW2kTXswtrFcqR0HRg8fguGwILnhl+G2mApJDNbQ46DjJ19NS5DoDLXt6OeSlkajL7wkMBo6NIq2+WP9IAmaYmA0Wso1DZlrQJr2hVyFVLLu/WpNA3rvFnNP7JXiY9jeJm6LszdpOlXvCdoywQ4XPXpB+RY2M+HTQ/BYtOiTUixk1gYAs2G62FqUXd6BqY/b+7vRILgT6se2euQXDPqBwIvqLXAcJLUekB8+PRRQvC5CdA47pBorrANCJvit8SvsawHCEJSbtsP9a+DUPzxVtwDDJkNqnLhhq1GRsqkrZSl4+/P2lYYQOZxzNIIeK/sYO+JIlwrr556dWcZG50M6JL1R44H+YyB+bpfvTWdcdSlUlAktAbh2vKkhbYg/DkOrPGpHWr2zVqBFEUkws7A6sOxsmfiobT10T1925pzY+AunXQsXUDIYVMEVEIpPK8L/m/pQt3v9Qzws8IXdJoz4l+E1hhVSYNKWxlfSRAp5z3/RGjla3lFEGPSj4ru6IVHvDSqR4EdrjVE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZDyGqY5xMjNVAG0HQ8Bz6awYKWMSDnubWgCEAdIW2OyI3khEF+HYkaLDAw/b?=
 =?us-ascii?Q?VQdTtmo0e+qWfYPN0AiWRbWQN+34SxPdBg1ZC2pOAsoa69xr1PlMidf3pS6G?=
 =?us-ascii?Q?a8Zu4OL6KOKSwkCiUgiTHWlpOYT3rEJapJGmEGill6wv0iwl3cESFQR34LAN?=
 =?us-ascii?Q?ziG+yugRbsxm7EcV1TQYa8ivaNk7GOV7krlBUj7xSxHyjViYCilUoY3yAXGt?=
 =?us-ascii?Q?YzCEfgJ2MYdJVjKI6rjLeXU9yYwHp5tyH3k7kRk24Hnq7Iaw+7mbNiN7x92A?=
 =?us-ascii?Q?5k44XsC5W88676wn5gE5f7bFPUlP7TGBDBSyDud2HOgRoTUVBbn2OVUICJLC?=
 =?us-ascii?Q?HF/0ihoXQhz+cPN09h4pluwT08eiqi/ocPIdEmcDf/ZIZGS0Gf/E6SiH2VN5?=
 =?us-ascii?Q?qfsGQiAdhCHA7wNw31ElXERsBlk+rOV1D8EeHWdG+EJbLTfE8+NwzIBWiwCs?=
 =?us-ascii?Q?d7PLVXHDn9gQLktO2ki0lDk9wpqoPXmolOsiImnBIv+vgB3N+1zSQwjPuLV5?=
 =?us-ascii?Q?SwVuiC8HpQs/K6rXfzLU9UOJItMxaYqwW9ivHHsAfERiI0zt7OIFMWZJwYmT?=
 =?us-ascii?Q?HbiZezdZhNQCucImSiaNdlSSCwT2FD1g7AaI8D9OyUWz+knSOhMEE/vHIP5O?=
 =?us-ascii?Q?Fq8Oy81319F/Ev3hY12I+FvFlD1TJYBGWMarhweRI6i6j/rejhzw+t2o+FnC?=
 =?us-ascii?Q?I5DtrsoaViUp5dHrQJrJqidpAEq5o2nuTtIN9rf74oMIN4ZM0Dn8CJd0Yupy?=
 =?us-ascii?Q?LYCgyvKe4Sdvebq3Iq/bJXfIlv2Ou73kxuiWprCYwe/g8yotOpU1TAgYZLQn?=
 =?us-ascii?Q?Qt4h4K2smJ5neYwbCjVvY3w20HmBpSMthw1Jxc29RNBqcXUthhQImJCeOW+I?=
 =?us-ascii?Q?CDKX2myUuytI86ogHqrAWALsFJTPaioPNOT3wEotZwLiDN8CKG7SuoUjueyb?=
 =?us-ascii?Q?OEr6ymnR5dajTIKsAmW3Vyldy8HfwNge8PwB+J4HdAPtmQI/Way79GOYo9SL?=
 =?us-ascii?Q?wduNBGdZlbn6s311Xm1GBx2ieTDZMX6R0QVbEV7lbBBOp8BLSLyMUAhWv3og?=
 =?us-ascii?Q?oB+t5JdIB2LDVo5myoP3nV9l7PF8c1RrxXGnzSLv+PU6ZEYm/EymfzoxGA3e?=
 =?us-ascii?Q?54ggvNpCsoqJOIpLgKWrBx+tC9ZUOiWmdWxndZNEGommzUwXnN7PfJGAreDx?=
 =?us-ascii?Q?C2xh9zj8I3+deGvyC3YOa9moomftUGsWZqdjJ17FKtIO3v6uvhK8GMizeq5A?=
 =?us-ascii?Q?hWxs4Cpi0RdkeIFTSMM+90igMAIgK5ZLByQIuuxH3Zq0Jvn6bGOtDkubnGEV?=
 =?us-ascii?Q?27vIIN0ZmZa+QZTGY2U+7vb7pa/QAwJPhWppkh4x39yhL1ymP3uCp4gJ4/5b?=
 =?us-ascii?Q?0jxpsJRsh02Rn4jsX2rUTWci0OZJrsGsrG0ABkuYgqHy4hQ1hmrh8DY5YVr4?=
 =?us-ascii?Q?QyxuVmBluoTjDqKIIDxur1bXpp834FwLXE/UhRqXTLf4tLkBoMv2Ce6KzZaM?=
 =?us-ascii?Q?1skHJ5StaIvgGHnyQdTXxeDw3gj5hb90RQ4LmhFuR3A8AJwzK7LR3ZJCzvgr?=
 =?us-ascii?Q?J0K95BEL3hf/yb0DV23h/SojioK1M2hUZdMI2/gGTklK9X4rsYIIYy2PBAgr?=
 =?us-ascii?Q?F+BrjTg7yW92/oStT+4LRXvmJK6k2udFVqNpmgDxGMxJgs6hsBnvd+Pklwkp?=
 =?us-ascii?Q?At3ZLASfYKlbMzdBtJAISydMhO1F5P5zPE0uKBczItcGHsvqGwPHeCfzyY0p?=
 =?us-ascii?Q?TWBjC2osqcNa2x2dLyfOK3jMxHbuOVo=3D?=
X-Exchange-RoutingPolicyChecked:
	jvkEK2fryfVEASzb7nKhmRWiHydCLTe+QHguvNLCpVQ6lRNlEm6WHe39a013gyUXrzIoFjYu3e9cmMOR8MC60aB+o8Jl6pEwXxfa8bDVKMvnKoRPgfVKBeZVzaEnu29NFN/l2IEdrIuzr9WuJKUiDuLu6IzJfynPsrZn3AcyOLk4Ko4altl9TUQ4Qs018ilpq1tn3XYSuqOsFr30KmUuPWYSXHz6Ncpips7iZHjCbwF9LwllYnBaJO5/gU4VvmHt+OqSbaJk1/wjmANf1cRuxNHM2Px6ridmqDNSs/VSLoz9ym83Hwfgo8vUpEpfOoOX98v24b+6K9QFFL7RQGPLNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sh8HR0No0FTf5JfYbf0BUgPjnD1V/rvLoTw3L9kYuW1LIbtCuDlHsN3DrZEULuQNe4hYj651egbR2rs504Ou4bMdz2z/+6OxYmmi/s0MU7rwSWbuNge2/mMPA1pT3muoR2HM71hO+QABEZdC7JDs41dzIoc75cWNpsJlFSXwtxDrCf+r69cKfAaOuusGlq+56RXhA81fll7GoSyZ/ZIetn9TOoc0VlZ4+VkjdUwzfH7/xOueb61BxAXyj9Z0Z6K6TlmD3d8a6JrURtukrWQhCbsvbrAfqFsbudMZTR6iotIYVNo7oEHQeoT0NnsaVSNe1YikKjEWXR9aNK/ptzVE2HpaNJEOh57lNy5uqgPsLxiiu9U3UhJh+YymCKg4hdr5wK0GCrlpZeW3knOwbcLSXcIV9TMtEvFk3J2G+Q3z7COqGA+buueY8rHClyVK/Cfz/gE09MBzrBz/unqPs+3M6AUTst/hxpHSK930CD97SraBNwIqtaOTFQme1H17U16Nb+nyZ5o0hFEwnFobzVWPSxdIEWuMzo+IqxHNbk38qW+SDTafCHXtG3PCqDJc62whLa6IDusaC6dvOkT5kFz9PWYkEk+O1qEYpMgZfpKSI0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88dd9d5c-2e89-4783-9cae-08dea6cc6d68
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:23:27.3606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gsoVygIRcIdLcUAOpb1ICyYIGJXPgFW4ZpsxVvi3V+CtiVzmAGd0s9C0SqOUQ8k7kV2NB8qzaHpImIibPcBqYFfIRl6DkY8lmS05p5M9Rss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7234
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=561 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604300158
X-Proofpoint-GUID: ZTcFpl0-mQKTz4HNJrIvDgI9RfuPC573
X-Proofpoint-ORIG-GUID: ZTcFpl0-mQKTz4HNJrIvDgI9RfuPC573
X-Authority-Analysis: v=2.4 cv=CrOPtH4D c=1 sm=1 tr=0 ts=69f373f4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=JK-S3ZpVlL6AxdlREH8A:9 cc=ntf awl=host:12309
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE1OCBTYWx0ZWRfX9ps42Wfuh9b/
 +MDZ8WkXkBUX3X3N3F1mgXF5cxT1cKLTfE4dCQOYznYYxzB6isKu6oLVNURUVZRtWI/RXu0C5Ur
 zB9eisEzW4bZiy1u0NjudeDKr9GAfZKS5YU81Th4G8h/zeyecQTK5nTSyc39KYe+BDMWjjs4EXE
 OH0pE/6ASZsRep1e4BVMkdvuoVaCi4IXKrrv2Lxve4XnTgIU2ANCntR1Uo6q6r8MPRZ8PN+rOSG
 S3dgTpE8Lr9qNatX55NC3UrLlLpql4AqmHvcAhF6k5HTis+lEQZkoiyKHdRmGTkAv2hCsQVTKH2
 RxHoIPDxlkS6bw9uU++Jdw+nfOUk0pPQA9eTnTv3PpVV6jrtQUYNqHjVHCs74JxKRVie27JQnVd
 WGQcXXAoYUktsWYWVudVTrYRqcTaF5edbH6TFtAkSWyaR+Opu+WskKMPt24fjgRoIBGiwSg54Aw
 9kS3yR7f7m0dxBOQ+y9YMN60Tiq/RJ59ZLbtpa60=


Arnd,

> Support for ISA bus mastering was removed a few years ago, and the VLB
> mode does not use the ISA DMA API, so drop the dependency and the
> header inclusion.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
