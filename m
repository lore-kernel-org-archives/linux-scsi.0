Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3918F303CAB;
	Wed, 29 Jul 2026 10:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322397; cv=fail; b=Rt6vVkilo+mi4Kez7qbh0s3wbuyTndCSHKJeSAxGcsBls8y67+j7itrRpzP+mXgUScuNYTnVQf9jakcmRRIqahdAIvmlf5fIuIolnWwPu5Io7JwAYhlGWecrzsdxiBnCz5tNZ2qh/EwGplzhhXt8jJDTl2A9wsiA2tYQlwW/xB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322397; c=relaxed/simple;
	bh=bQaiQI74wBbJ+OU/POf/MDcs31pUyVBSZjOtdaONQeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UcwDIuSHNRUUM6ccrQJ0ri7snqpipykD8F+VbgHnwLW0ImaQ7m62rJwTKHfLeDSRaGtPVs4ivW6CGUhFHfFMWomtMJgjRdD2qdTXPNSV+EjnRvWSDjmObRmEYDiD8pI/ga2jDxsmvXDoWitIL3mmvwHpmcrpjSO+dkoInpH1GxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=juDmFXt7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dk+hAfiy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="juDmFXt7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dk+hAfiy"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T2egEJ1922615;
	Wed, 29 Jul 2026 10:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lkvXb5htp47+aeSqGxqyHTaOZIb1z/p8IC2R38llpgY=; b=
	juDmFXt74LgwSbQJGv/KTG+5BV6Eoi7TdrqVO/FPDnXfSFuD9seCK6SswG9xQrpR
	1IaRiiPNRhyNS2oJEkO1U/oF9r/IRlDsCezpeD0k/nJZ0+hsMXfvxbb1ekLY4vny
	NCMGPyrFUErYzh2/XahJqczPf+M3QSmL+8ak1I6Ls7D9fe8yrhFDrQJwUG2Fpd8S
	9HktcAfkRYNsveIIdKhAqPDQYZ7FHoIe17PAquH+mWKS8oXYDGxPTge6lUqWO6RZ
	J1p9u8fTv40abKrrjTrbHp1Qy1t7arkbR7qx6mTEddGeCH3atcMDxjPQjThw01r2
	uKf2q6mtiZPer9gyD2kVtw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nnmk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo6tn016801;
	Wed, 29 Jul 2026 10:52:36 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8adyuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iu+taH9qFUSptom8jLA5Fjoc6zvJLKGvPjU6mz8yFO6aF8KgRa3B6Zj9s+rFl2I1+w4rDSRGcy6HHD10pwO8g+quIvMLXda+hHhlS6s8l1AGIxD/o6HuJ520t4vdvYUqfozCZqC0MQrfvJJng77XqVtHItfEs+zmhR9GVapEvBYE5xW8FQFpFKASpovRyZ/W5qFxPQY4T3qT6NqweKEMuyIWhYZnDaniLWeufKq3ta76njgQATnZ6Nt0LKVB89+ywy3kwBJ/eocLFObN1qtaQpbb7SjL0sToU7iusr5k+fPJ7fi/zOtel45bzcmhYm6M5Q9cPLFIOt/l+4xX/OdBBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkvXb5htp47+aeSqGxqyHTaOZIb1z/p8IC2R38llpgY=;
 b=KNSzB6Bw7mFU3ktgsDjy7mepc5UtZ6a/elLNIoPmVnIzqh13FveEOdib/WtFQ//U+IrTgVoHJzOvB3rStZR+AxaqHEodwMqP+EiR6Vp6gFzbboP4nYsyr8DEDwJtHqCS1iqHcZaHH53TDB0CEOjgEtFEgUl3cH+FLyaEtVgYmPjteS8xRFey8axzGXfsHawUn+aHPwXVka2u97zy9Nl1X0QEGjzpFygOBEqzFM/iw9Y0UJC1/5PYh1uiuic+67JtQbdqhAJt86EQILnMKy7xya20jVnYwwUuIb/zBSNziXro0wPKbbTpxMnSz/9Jwlu4zbqd6PbJocTB7yak5nDF+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkvXb5htp47+aeSqGxqyHTaOZIb1z/p8IC2R38llpgY=;
 b=dk+hAfiyATIkmX67qDHTSfZDeZWWXLt68OKbykoIeIFC0pCufkNLXJ/Wl9vQ1Nisu/bMh8t+8E77otWO9DUKZMCqnW2i+XYXcPIc2oh+sLUC3uHASaPjgp7vpnblTH+UW1ZjzTiZn+y5kDcVss/A8bAY/kyt4XW8N2GJHWnGcFQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:30 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 27/27] scsi: sd: add mpath_queue_depth dev attribute
Date: Wed, 29 Jul 2026 10:51:07 +0000
Message-ID: <20260729105107.255712-28-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: b9edcf39-6076-439a-d12a-08deed5f7c9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gUzqLUoVW4noflPmrWR3qjzaMi3odqLr5M2CShY70MaRLf+0+8JfNDifClsWFuxbX6SCb2lFi+U/VUhK8U5C3KFOTnpHkqYxnuKYvGJT0zMlBpIV0FE/gvdgcItQkMkdnXjmIrv/4vWFzhADpNouZzCR/rz0qmS0IJc6PU7raKEXrpwk2Zy6iUJkZ6fscZaoPg9S9OsUgGiQohib52fKzSJwL3Mgd9/95zwtTzo3OXaOYnTxp9DKJQauQk2Kcrvjk1vfc3aaW/K3KDHsi715KuVhW/xuTWCzv2rss1RyqL0Zm4jc51UMBR08g0O8+9M/htRPHKclMAqSsfbTLeC7xEpD7WflGoq0M6k3Y+GP7JMM9N/Ja7aFbGJcp6lGZDe0vqBbAnzWBZIUTf8Gb8kp9g6pBPBzoCDORH3isrtEQICbfLaTjsga5Nr1XCh+D78lNrdeV8qgxCcPoohQviR2vyI8zhcFw5QAsyHjj6fE2qm+uW+N7zfAvoHolDYVwti3rl/mPSt5qceRjnp2gY2/bsEo15IdUHkARr0gz2r1vl0lYUhyiUEGAMdUtw684dwzPBxjfrbFs0AtPx4dEm9Apnbh9j8VXSe82YIXydp51qlE8Ig/kbJMujuDN1Lruqxrjk98c2OcvOSPte34ofmiwCDVC/CeKQ88PQk7WCLHPuk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0YhOIjr58IZJz+ym3hbsyLTC1VLMz+VRLpdyFptgxQp8BZeh4vowhOFTiJQe?=
 =?us-ascii?Q?qTMzCSV8CUhe5fZIY/UgDUN9hyilY7Bk524znhHRDPyEDf9kTnkxZvJ0CmCs?=
 =?us-ascii?Q?J58HdHP+1zE1IHoSHJprACOotWhabRBLyzjyWieZTGH4aS0wLD4ooN2K0cko?=
 =?us-ascii?Q?jbA7mHwo43TyreNGd/J0MFhWri+irVfWFSH7B4w8x0M/1Q16dd4Ony/XGGq6?=
 =?us-ascii?Q?nNtRzZV2adVy2VhwCisV4mKAPUY5S5AcCX7+JxGS5A+Jm6gyHXbRB9OQFNWN?=
 =?us-ascii?Q?StoM0cZzWvVRaxaNilHQ/mkfeVKUmZjQgEapmeg77IGYckdcPDFF4b0UKQ8v?=
 =?us-ascii?Q?e0uHTcBtk4PnxOE/QzgVwTbLu3e0+0zF/y/Ncpwkv5sdDRVh9VZxEzTiJreR?=
 =?us-ascii?Q?mOVs0T7Dh3m/H64tRmmkKyi8hOy1BVijj77U9+89syhv0aBzYQijiJo5uK8F?=
 =?us-ascii?Q?rjrv64TH2kaaYxamkvkotf0qZapfGMf7cgAzE1VMUWQ/w8nMCp3/siOt3QCw?=
 =?us-ascii?Q?VNaPp4fNhPFSjpgoGrBtLiNjwWXMprIg9+kHu6BqvLYFN7pUSDwWwc2uEG+6?=
 =?us-ascii?Q?QCG+OCLkTJ8YyWnr0HQHXsHWwDSQGJxsKnvc0zqlDn5lJ6BM5W/JNnifEe+c?=
 =?us-ascii?Q?7af5FNcod/J0+GFxSWHgR4cJnJo7Eev/vGik5gLMUJXMozOyE0J09ss5bq96?=
 =?us-ascii?Q?BPZ9GBmrtxXgMAnjAqaT7QA35J2rn9x/69GtG1ro9wZwLcp/Z8s41NUyrP1v?=
 =?us-ascii?Q?AwRYhM1fcLw/rWmDK1e4j7b+hxgZmx3jcQuRaotaT4l8Zed5jvOWe3w0E6wB?=
 =?us-ascii?Q?YzPc3BJeXFq1uP+S0YspdlC/qjjWlh2JWtmN2p5zsJISRZ7JMlObVCxeiTD5?=
 =?us-ascii?Q?75lE3tDADlOf6FHL9uA9Kej6JtXFN/xXnzQ2Axiw4AZDDwOAH2qpmXwHu5SN?=
 =?us-ascii?Q?Io14Yy3PGjWN0v6EjMebPQWlIrHEqJE3FWDqX32gYDxS51GL+0/oYkrgodH1?=
 =?us-ascii?Q?evy8suyC+H9ywvFijxXI/4bP+JZ3m41Z73OHFuBrK1X5DO5AFtQwpPMWHyWm?=
 =?us-ascii?Q?P6Q8f87iveCNFaCYcg2vyoNCNtaRjTJxGEvluspTDIm4IeysWlAiM6epxXEh?=
 =?us-ascii?Q?0uuuqHBuuwZTClqL3suxe03OreqehQi3Ite00bjII9e7VhiZGu78VerLV+AW?=
 =?us-ascii?Q?vncDt3OIrXvQJ1oa1moX8OgPSQHMEIhBtZNoSzy9weVNW9GzeSUPTKbPvMbR?=
 =?us-ascii?Q?nStk9qYIej2GlastX1f4edUVM5G/e+E6V4fHp7jxBMeb9eX2Y8PE3na6NIf4?=
 =?us-ascii?Q?PSP/wmgbOr/FUK3Swaxjz78QJkIyqwqHX0TVGWxa/WfFo2+TlL4FlFyb9RzE?=
 =?us-ascii?Q?blrAaT5f1SvvqFumQ0Pt43BrSd/NUtsLWAWptNbH6LLWRW6vaf4kXIUZU9x4?=
 =?us-ascii?Q?u6FQ+CJ3Q0gTJWYtm3zC8Jgoa07oL7H5bj8hqOKUb1kv97u7C+1k46/cpRGh?=
 =?us-ascii?Q?rTZJrv9i2LBy7F2XqXegDL6JRChiLcV6AFbKACBORi01AtxVd4mUJ4wqcoSv?=
 =?us-ascii?Q?6yntnhLKKnHLsbKVo5/BRGFz4Qa4ZStSs07EKQSAAGkWUdzhtRKcCKHuq+XT?=
 =?us-ascii?Q?K1lBaXgoWYaLwlflTTV3J82/tYr3IxcE/sp45XgwK7LBydlM8gZZLghGs+Bi?=
 =?us-ascii?Q?CojU4jm7dy6NpRobTCxbMDNhHjBD1ZZtp8p7K74JEcRKa2SSTbHupx8Qd0RJ?=
 =?us-ascii?Q?InXJli2cgQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	GQl2+9RDVhDwhgiHKyKWvK2rcRip32iuEbudXajVUh2mivmyoCDgMpSXCzCmYUzZovwB1e05kYSwCkf+hfP1P/KH9k4ro6Ei+u1JYdj9x1UO9p6pkYITcGwxlJNLBANO/nbmePwFhVxvf8S1v9rC2Py52FXgcU/fOFpq4Jwm34HPSG9JbcQPNVPTez5/Ci94X8WgWHdcOQE3aFuWvCczg8+RepVv7P1KAknw0+xayP7kx1eOcDG1BlWTYAHod38D1LAjVxZkDLHOGyKWUBHJXh3dvKeAF9dQYIqpvAmGF6LOFjXP6ofr4dyhO9LvKO7Ij0kib0X6+emgVLQI3bnbwA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YSEsUN76oHdZQUiL3fhhBl7OnGys7n3HmSp55Xaay5qUQG5C4d9ButM9lS/I6icZ4xJ6qRzspQmdnAmRdTIe0TZho/L//6tKG0N8nk5F4BtbwjL8/cW1lR3Jdmfo05m3EQiIIz4nIWeWStRJ0nHKkrxwy1CAQdoJnXDsbwSOl67ogTAa/9uq9rLMkT/WP9t7I9MOGP5dgAUacNgZssS5mqqB19Xd0FL6tLG/2PC/SPDIiXAazGRNnjE5bfwRF7gkKN6eIKsLYHpXXoHy+kaibGMMFoVZyI/Qn2rLIEBv+LkpbNhwHflUYhl88Ez5zsDVZ1QHRCwXxwDn4dUMkEbOX0IVDBcdiiDcNBl/9JvFBFbcD5Ft3VKg8eNJRbD/S8fYs+Z6TXsSCmc9l+PU+K3/vljDIIBGZjboNaYvV4/TeD4k5wf8y7SpcGeyCftuCW2z72lSVtbEfFlE6opkPZ5Q0vJAWWdXhK8Suwc72Xip8MXJNgRbk2wOoutE6arNESAZuohFA8XCzoTHtU5fdEzwUmj/+hyuzd47Wz3HtlBhdX2MPgUxTw5Wqc+u7B54GGZo0KkHa2C67m8Pigrw+IhgGu2cJLQLnX6ENQYJg8ukmro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9edcf39-6076-439a-d12a-08deed5f7c9f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:30.3449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tSLT9h5U5L/f+1ZIBEx0oAbesiGKD7rjlhwN5P4zN+2aGd6H2HT8VulQJWI55HSdK2gGXHtAINmkmHzTgaQDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a69db76 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=Cy0tQnv6_IKVRNq15SMA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: FEFw2LiBkJwA-386vU9x3O0uFW4zP8DP
X-Proofpoint-GUID: FEFw2LiBkJwA-386vU9x3O0uFW4zP8DP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX66KzUcCHxn5d
 KU5O74Gyrwno7xv7FtEGcNGFKjA3+K8A4DI4a0Yo2eqZMIKzVFr6fGjHr+2VU/JrdQj29ofFTtx
 fPN/XJTNkekbDQpDyOTZsdluagHtjxcI0dlJIcrp5ZRlhVeSN8DK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX++KHM94qQKz+
 twlYBFGvoS756HPmq3gN+8b5IvkKyJP+BbV9Eme5kkdhTBe4SoV4RAM32JLinDw+0CT+u65uvnh
 gMC0jTreDrnoyA/kBuUVB4xtl5PQO+ZJiQ7PFKC7aKOVLMcvKlvy2UgmvkNM1yuuZ9xhVlK9Yv8
 BRavturzRXY74Hrhj05wr8/x5+H2eYGS/hd2+bHdr3vg7I6PyRvtWWqsld75X1skgSpuqUJPmrM
 zn6AWlUd0JtVmsE9MwNF8ja627AiewEDprUNT5pUdceW92yQkGDG0NBm83OhsuQrY1pWzW+MEbo
 D/V2geKMHWqG/p1C8rN9yaSggjhBSRMkiQ1RMOiPpx5kuNyS1m8s09bqIWEulcA9X9IRb4oFDeF
 pao5NLH+4YIhUNutt9INvtTBajFbr9l4Jg4kvMnOtePStWciNfb5QJ4fcsSbmvVf1dMMjpuDUyA
 pKcQseWwGirPM072eeA==

From: John Garry <john.garry@linux.dev>

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e63a42bc3d134..6713af46f61a6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4163,9 +4163,28 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.7

