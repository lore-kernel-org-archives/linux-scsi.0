Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763B93E5ED0;
	Fri,  3 Jul 2026 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074913; cv=fail; b=pL4ROi7x+lelvXXU/Kx+LbVuDYZSrmTGiuc4SGo8Z+2QBaYxhLsLAhY8ZQqiIy7SVlajquM19YAvgOGUUqNrOAfVm7lv4khQKKFJZe0/k7DTBoPi9weAAoEdHMP3iHlsbHZhs71HIjAVZj13BvsraNTs3cCyUt34buwnqzKFCqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074913; c=relaxed/simple;
	bh=AWfXJKYVTrxYTBR3yPIQ+4iJ67Nk6Q6b2gAy+j/tLtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gG0kBbCDQc0Ps8Qjs3soVXBgqU4Y+P4b6wE/Hgs57DQ/coKtU+/RonSZBJ/uA3llJJWzT80pX7IbNVJseMxjvbOhaoKZo4CVqJGfd2Tsl43i5mYCmssClt9eFqJOPe+cI445bDb+DZ7MfLdTbYn4FI32c89oBHGNo5N2RJiQZ8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pKdZ9LuF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fU+8BbCr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pKdZ9LuF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fU+8BbCr"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfuL3080683;
	Fri, 3 Jul 2026 10:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=21+pRlyhKAMojs/ww5ySQKEr4cSHUWH53savf9BSvKI=; b=
	pKdZ9LuFUNiiF+GwPtDF9BVBUNV1ZkKReRrTxdAU/C+FCfUls/++ATne6OrkzjZh
	1/O0SBSfoYBaAqdeKRgrDkeAfoV1lL+Wx1xtN0OadYwc4b9WWbOZSyRnGvt7LMtp
	wysdwL3obMfhL4oXXEI3AffSdS85larS87+iGmVpSp7W2Zn9oclxrD4pTteSF9bj
	8qCoQT83P8AVOKQCfXc716yvBoTL1xpTUBtqMZ5HmszZoFgncrxwZY8xQd+AkYR6
	6IFWkLEtZ6/SmItysaFd4UCMW6YDbCRqltCi0D1sKSDrNRpBVObXaDoHvTSlvtd5
	bR6veYqbg4rVD4gH/HOcQw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXXCp037100;
	Fri, 3 Jul 2026 10:34:51 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010043.outbound.protection.outlook.com [52.101.61.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u20fu3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKcRefSxDL3+ODx9GbpLRSnF06vRFCmkEaxeMwfUOCAfma0h2wQFaH3KKeG/ylsGqENxW7kQSfdv1VAPEyOrjStlCbVlfqJuPLowP4pvDgQwdWGCBaupnAls6MJk4HlJcRenGihdVdjcJB/t3Fc7EFZaaiCN0daXxXooInFrH7mzXgDNZhvfpsNtMb4mbJ6L8YxCTd8UMtf1g7w1TRJulURRlbaEQvkRqLMmaUFwJYh5AwkwEVUIdTLlOni7KIkTA6NQg2w4RMU7Y0tSClxw0T1GBl7c6VxB+DSAL6Th8iImTBIMriP9cq4iZaahB5Kw6yDuE2EZRkCT9qXMIoBxog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21+pRlyhKAMojs/ww5ySQKEr4cSHUWH53savf9BSvKI=;
 b=mqayOwFbu7XkbxiHa7vTe922ymY6de35FaaddeTBQdJVmriqhfxLefVHWAW7IBoSdA2B54mVC4SeYtEdX7qeZ+h+g0meAR2B3LX5CuK+GDXmgj7deqzS7k4quLnG5dBtgy7ThaEjZjg0yy0cP7GLjhpsdXCKSYr7P5jLN0RUI/T68KdEm18rC3FYikEIEfkFa9IyTqZF4HEk6176Jb4JpZnz2E9tbScq5bqSe43UbV1JHpMmtUvdxvbETy0WlDQ+T+/fAKDqjNV6EScyNCCLe2MIkVivuLPR0PgEJRzA+0fgvL20l763XUm+j7aoiaAW9QHbkVkyKlBpM01BSSpbpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21+pRlyhKAMojs/ww5ySQKEr4cSHUWH53savf9BSvKI=;
 b=fU+8BbCrLtNtJ6Dc4MG++w/Nm1o3mbWze1bXoMbNeT1/8LmXPugTF/G83VlV+eIdQAcoFprVm1JzxhibD2aqChI1VBGnH8brkUL9zrY4mLflpbeGyRiNmy58OTNoC0vo1xItIWPv/qyIGSzRsXZhEOyqkWtHSdrdE8oNErKQbvM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:47 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 09/17] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Fri,  3 Jul 2026 10:33:54 +0000
Message-ID: <20260703103402.3725011-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0049.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::32) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: eb7ab62c-862e-4edc-54bc-08ded8eeb3ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|10063799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	DZg1JeHQkLgeDqdf6ATpJr/b1YlgJgp4XKKQf00ryOKs+/pkwCBJoJAkesaAaD/k3t9D+Kh57U3Iidx2SSKUX30M7YUXq3EHkT3lj93ANjFE21N3AztfOrzzS49ra8FeYeNKRwFbZAtAueKE0ybCWH80UKXAUg+ch7q9YLPl+B/7qcgXJWxPUOYSXr3DZvAqtU8jLSp1R/jEBqQcKJMROvl4CT1G8Y8UPDC1+mIfzIutb/TycV4itIjwkv8+dYeomI5EVeAiJoRxcO0ENQXl5rpgfdZ2efk/9OlAL3FtIQRcS+rNVuuV5HMYtwIHvgaqEkbqXsgopz4VQ0Qjbtv702bXS1q1VN7bWa54tw8Pa02JP1U5JNleavARj7EWr6iX13oUj93A/YsrO6Xi2Y3Q6/pNKb2Dz26wjfW3g+Mfk3xnd2pY6hZu2jtABYwNQk4PnBbhFAt9DasuP+qlok64ENhjMpGr3xGtNuHYj/xq5opkMnfoh9q9NhGgFSL0/ryt0vVlitHehS076i5FReRWvtbDHIaYdAkRgP6mAqAygxUuFf2Uxh3bAazZ6YqJz1JTxEPf/Lkw73koAFOIiiKBHkHQmRo5ehiNDKy7E/HH+MWu2l9Tmo6QaxZfXK7Ua9PJWjNGFlrhhdndL5gitYr2EY9Z6EY8dvrVNdZrwYDU5Uw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(10063799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?masNQ6t/Z8EE+O2feYLxIaGPmfDt8gwaXPLXsKMbC2zahcbv+7kYy5sjuHE8?=
 =?us-ascii?Q?pBzZUei8xHvJxPF9Yg06m593HrglMv8RMuN2Z5fyOmgu3SCFeozsjTVR0VNS?=
 =?us-ascii?Q?JjaSONdql+1L84Q8aVvQgjvpXj4N7GWx5V0SGV8Lb65MDdy+j4zysr9PCq8N?=
 =?us-ascii?Q?584bv3lsh0y5IkrEIgIU5g4bkoLT/OnRg78rw8d31EH7Sa43/HqSM390Sfh8?=
 =?us-ascii?Q?uU66kOBq7vqPRPZKGui6ZpYHg+jNZVQnrHFjClt8oK4EmGlu95Kg1Uz9lqEP?=
 =?us-ascii?Q?acC9ZsQpV1zksunpDimaR4oMDEZv8CQoMWOI1dU7ulE5AYm2V8gLVjfbtSCQ?=
 =?us-ascii?Q?vj+bm0bKYLkclvZIu1Y+6ZDsnZ3HSDFWc1JM/hwqqBMz9PYDG4FMXnIatJe8?=
 =?us-ascii?Q?NW9jJrvY5mZVPLTgGlJtQGkPe7zBoSkKrkK6kH0kyw/24ZJbeulRGNECv9br?=
 =?us-ascii?Q?HuFUv5YPni1zJvWLq2B6JKi+cDCsPgntmRI8s0b1pdRYjHKbT2zmOWPNqj2C?=
 =?us-ascii?Q?p6I0oqWi03ZumiRjF0mOkz0GqYbbz8Mf0RYbE12/EV5QG8x52OAUnhVVLNxp?=
 =?us-ascii?Q?YpX+m5CCn2CkHMMCup3vqTnk6spXALH0piFMyJJFYBjMsumUHvmUChoJX0lc?=
 =?us-ascii?Q?PANEduhXdN4Ur+1zFYENZ+5rwGZdQ57e9IjmT4I3L5uhE1OLeLViSAnqDel6?=
 =?us-ascii?Q?sdZX8LOVV/n6BDjafNAyeMVWTpMo3uC6eAklvlpmw4pIIumujKDe2r4wiIB7?=
 =?us-ascii?Q?0sXq1DNbsqTrHTKZnZP3jxzSiYmZO0GyslnaK4Wus0IZsBKgdIppIDyK6gLS?=
 =?us-ascii?Q?Xle7FJjUB559RbncDm8FQVML35/vY2PoRi+rskpzg/dOa1MBBk61NHBz4IRB?=
 =?us-ascii?Q?LYz2H1nFDwTNy0Wl2zTA1blFKeJm086Txxa2VBRWuKNcgwM+9xV0wiqx57dm?=
 =?us-ascii?Q?4Gr8s8s886pK1O8riTqgGCPeKqefvp5YbdSqft05ekfzvqa0vf6/+cA0WdKG?=
 =?us-ascii?Q?JsXxSDuRmWlaE7J3LDN3wGutDrvDL9WY+Up2M/m8wGOBwWJCAiOlgyPu5tTf?=
 =?us-ascii?Q?lI0OZD2vU676uvDJp7BGgqgvKZTXOEAa0IBcIKrMXUNSo40sAvdY2TTLXHdo?=
 =?us-ascii?Q?ehTLkyW8mH/jcInhOGorEp4swIiNMi0PHzKfNVEbbLB5jzVloMw/pWJvlJoU?=
 =?us-ascii?Q?uAAMB57rqvN9y52i3YHGkLUJHz5GNPgoEWmEoS4UDuhWSs/j4RnlURcXQmrm?=
 =?us-ascii?Q?wwai1HvEa4bljscYuWVO5sMl1peHDREVCEQYg/YFLE+TRsBJajdmgmI3bf5o?=
 =?us-ascii?Q?FMqJB+RpnI0eYDUeCRMqebA6CYouuiA4qS62RJlVKaD6wkP5QicxHHDM1ldA?=
 =?us-ascii?Q?3V2aH5SzToNBU2PP4pK61z9pHsZmAgx4VQY0Qjag39z17z2FLKTJgwwl66WZ?=
 =?us-ascii?Q?jJiiG55r+JJUOae1PGrKLxJNSu0Hb80xKg0CWOgNF2K+zGnxeqHxfEEW0Itq?=
 =?us-ascii?Q?rN69FCFMXxi03Yq+WqjsYzzzPoiWxuIZPQPLmORefLEZcE9FQTVP9f050F95?=
 =?us-ascii?Q?Uf8psQim8HJscF7TKNp3PxXPDpTp+zAbFM9gXs87B15a45Yp0JvHNsXGqNN6?=
 =?us-ascii?Q?nIxz+u0p5g6bxsTyMGkJpAQIe9GBknO4C0uftRHk5icpatrGQq0/nBx+lh22?=
 =?us-ascii?Q?k84YQisDzjZOvb/lPgikS4KDdVICTe+4Xo3Qc/pJi6n39zE8AMmJC8o6xezM?=
 =?us-ascii?Q?L9BnE9/K2wVVlESSeFBZpTysHaWm2aU=3D?=
X-Exchange-RoutingPolicyChecked:
	aPqJZewzS6srqn1zbaMQsVryw9IRT3r/4oUkwW6RfCRm9DkcQpXtFvwd4MCCTlja1Cx2mZnHpLhno7SHiDjfzFzG6t1FxePLQheyyGZdDIHQQla1cEDTlkfM+PVm0Ur6My4Bx6duAODxwSHlxUxY1Pu075qn2IMmxvh9AqtNa66CZpqLBZXLpmsolW5kL6s5noW7vRJsTTun0b6ZTYRADM/36gRyG99lEYAtVwX8icTgtE8NN3MN9D7UqgtTTNALAX/mRi8Jtwb0g+bNms532F4rJrHAj2ZnNJNBo5OIT3PN9eC6n2xcYwjWEZQzXPbPXrfewPnoqKMtOc0cJIqDtA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MEtVpHxD+eKODgY4RIcdVJMy75B8SSB/yngQyOIx8Vte4tka+URsfoxEEFDddIEnOL+jbyr4xj7yFqGnBKDSPEik/ERsPSxUD69Wsq+fOnCCQM4hJQMInKIWF5Q0B8xM9tJFB5d7/P5fjgMQHlIIUeA4AbCr3FI+d8f3Jo55d54S1xuZ6H9Zhp2zbPWTfYt5HGv27tvh5sHW3PQPdkymnjHdVLw7BU4wSObVxjkbOsRp02SHD1zmHO/Qx8mHZE9OGlw4POUBuQ2oeTcY7izWNUU08zP31T0CZmVYWFt8idizHXx8gga1kq1mdZdz0kKfurEVJBJZaPXwhNZLpiwEIREzSWPY9JM/c5nqDG/QWZH4iYeIFj/9V+zZgEeH1Et0b/Z0EmTaO4IA6FhuEcL/VGi7v1k+udWCfOd/tuARXB7nErTE/NNHaFIj2YMBWcqcPYdNmSZJwJm8XFO9zVnUXM1RjjiFvfR0oHQoKycVkQo5wPQP4hbNSoE9NaVBO7VHX7FYfVnSsKesAMWYhlh0Msr6WNP5PKW7jiVPePlaLVf2fGTqzb4c6ZjPv9bMGCpmoqV2lUbpUmjzp2R1r0UklfWqsItYNSoDXh/cyGw53lk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb7ab62c-862e-4edc-54bc-08ded8eeb3ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:46.5051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5A7+6DSz0CTnzdMpFm1qKxQNGUCU3PgODNMjybo7EF1b+XB0T8kMPD4J3WOq+SJmQX8DqxEIxTwDMDVUkZBN3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: O8xK3p_Jt1Xk0dUr81GT_56QJb1QtkIr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX1yK3n5FfzTlB
 ua8H7nGVxwCwv9HeJXsFxwrBYkF/JihcR0fc1KB5/0rDZRuQe5PddF31nPJ0XZ6OUj53kKzR4gb
 KXZZVu1O2XW+23TU1+Anu5CqCGGURA/2IXfEOygbAVWO04JHXZZqIRTbxiyEdfLoHqk/eNblDD1
 ls30gF0meIzHdzPMWOuyt3zPSj/NXsbMWbpaGTAUlP8wyGdXaKPoMEwHUdrkllBDqypgv+OXYP5
 hH/YsqhSsux3QlwV4lxNfM+gTSXOokDqic7Lmbed/LF8afV/hDvqA/z+IBPCYOzvOFtl2WNH8oG
 Jduv23JX/wctNXjdgCWkzzSBPf7t1XLPLPj83s4e0DXqRZE1WBzkgb0WpJz58yc7ZU4qfXsrQwm
 7aRuu511YtvPv5LMHyIvcmPTvmtgPMuC/CJsEXUEeOewvSmwAYATmCfqzvAyIOnbXcCvxyznuZR
 2emrI1twPtJYBGg28mBWhQdqRFN7UAr0kX/WK7M0=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXzaXCS3NO4aLP
 JK/mz4dMa7Qnl2Wi3i9sTpEW4aegXpRjRru4y6BAwxr79a2O2zkLhUWV1rSm86aRCxvDPwyc7Xq
 g/P2sGfk73bqjadfkWDJatL2BN7tyYCGI5O9Pp6iqwt9VkwCExkM
X-Proofpoint-GUID: O8xK3p_Jt1Xk0dUr81GT_56QJb1QtkIr
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a47904c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=-3jN5J4PbOmX-KBf5wsA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).


Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  6 +++++
 drivers/scsi/scsi_multipath.c | 51 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  5 ++++
 include/scsi/scsi_host.h      |  4 +++
 include/scsi/scsi_multipath.h |  8 ++++++
 5 files changed, 74 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cc34253c467a2..f8b389fda2537 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -669,6 +669,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
+	if (is_mpath_request(req))
+		scsi_mpath_end_request(req);
+
 	if (blk_update_request(req, error, bytes))
 		return true;
 
@@ -1917,6 +1920,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index d8ea9ffe8942c..61fa2e4cdfdab 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -543,6 +543,57 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (!blk_queue_io_stat(disk->queue) || blk_rq_is_passthrough(req) ||
+	    (scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(disk->part0, req_op(req),
+				jiffies);
+}
+
+void scsi_mpath_end_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev =
+			sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+			scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+	bdev_end_io_acct(disk->part0, req_op(req),
+			 blk_rq_bytes(req) >> SECTOR_SHIFT,
+			 scmd->start_time);
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..c6571a36e577b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -60,6 +60,8 @@ struct scsi_pointer {
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +141,9 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4b..cf4fff3ea1a8e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -753,6 +753,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d8644d6261992..ed5c77d568843 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -55,6 +55,8 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_start_request(struct request *req);
+void scsi_mpath_end_request(struct request *req);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -93,6 +95,12 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline void scsi_mpath_start_request(struct request *req)
+{
+}
+static inline void scsi_mpath_end_request(struct request *req)
+{
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

