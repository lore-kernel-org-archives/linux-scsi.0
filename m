Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0C3E316C;
	Fri,  3 Jul 2026 10:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074826; cv=fail; b=YB1i9KJYxZ7UMRhZScJmYeS8QelDkIrc8v0xdVR3suQrydLYOCdORMHmsW7jhKuNfONO0/NuXrMbGzO41FqQPWfn4QJzTYDidvzvIUBETNcIstwc0+2jDlERWBGfT/u7idwva6ThYmbFEX+wMnDZ2wxm9zcv8Lw3sktxEUE4mC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074826; c=relaxed/simple;
	bh=Cd+/m6fTDWOS08F/GympRXJLs8DC4MgK4db2Y/tYqOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d4c/z2kmdMRO/qL981ZSquKIRzEien7SDZeavm5pr/SQpYUStv4JlBRJdVYPwX95BEi/N86egiUxCGEVP1SaXoI0X1qL9EQZEiMxsBf+QWYKvpIn6GA0/zJrZ2Y4Cg8lAh8ME5udPwc9Dsz6uSGddSYqwcwMAvLJ8Rps3qe0yC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MFtSqpiJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V7rb8H9/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MFtSqpiJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V7rb8H9/"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tf233016255;
	Fri, 3 Jul 2026 10:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PokNPMKieU1z+l3TAYFv84A3cGprOdu1bxXF6ZK+4WQ=; b=
	MFtSqpiJ/AyhzaagFxEAcrfQtHPMmUSX42fItpk6o5kj+a9CgLj0oPO7aqXDzwed
	6qxx/KnzYaP2piebfeoTWqegXRY4WMTMVb9MDl3jKmpVQNqVPhZ2Hd5mxldAnToQ
	vhx3bVF7sK657ha8kCbTyL8+17hJH885otsmGyfSCI51nffEncDWs/gibV/9RCoh
	cn/ANoly2a48j6OR8u5M0ZUEHDIX/ZZe1vJ91osV6DjgH1wcgv+D+HLXX9S5gyC6
	DJ1Ytjxemp26NzaNUi1iMr/pNvBO33XoWA3/wkJ2q+U0PAPR7hFzqrv6xVPuvxh7
	v2/03xlIlaKL/W843fwEqw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qtded-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7gE013121;
	Fri, 3 Jul 2026 10:32:24 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvrrk-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fIlv0MkONXl8wYRO4dCkH9Yt6bGf2nrX2aTv1iyGR4IdjBUibsqbmIo328smP2tolN7paMbyMTLtrX7p99x4UgaXd7+eYZBcvnoAyRFSdfsYjXWPdqSNIwwAqAzoAHO/cH0CtRL+3BFZO+GaQeVksjphItshubqdt3QhnX1c2hGHSOa6NQQ/cqn2TQIIPxjaOwAXxSAYKoNEyRAsNEd50s8aUIZO1gbaxTLM6XUvpBWgekgF1sM/n7oHAqEMz5wqql5LdQz4Tq+KAuw7iVhzfZg2yFMYHb1RYmrDLJWQmwKQYc5iz4LcS0eF+bA3X3xkItlKSGpkQOiy+ioZ4TZbSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PokNPMKieU1z+l3TAYFv84A3cGprOdu1bxXF6ZK+4WQ=;
 b=hcz4O2OKozHJXSBwLC4zbe9TmEjDB4OtBk0R59u2UJS1jbRHUipDB9bZe0j3Z9gjW1+hLgXtOUIxJZ3+AR99WGjFkW/9kUcv+LT/ceo2AW5HVYFjENWQXo/RZMlsocWdITEeF5im/WhZY+Op3V5BE3t3MhcOcpN9IS3mlkKLkJMqmnH7PnX4vPyTLeamzuEYzNZCmU19tlby8XbkAc6JFMMQFg1q0IQgFvBlyH7QDllw0Q6gAQzoI1qnRZHxkRaRNpUU/RsGYxgDcNz8Uo7APXkOleWBvso2JKBf8HvkiU18MEEz9jiqRDyoTmHLBpvYlKs8+zpu8U36mvfHI/CXuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PokNPMKieU1z+l3TAYFv84A3cGprOdu1bxXF6ZK+4WQ=;
 b=V7rb8H9/7Ew3YA22zZOkm0ARl9pIyt3HASoHTiYkAn8vsqThmF+KrQ0lwrYDAwORjepcMgMM3Lys6Bp5Gu63ekvqyVw0b9CK+ijJYElD2KVxL6zFy7INIrN398ROqomnW9Fmh3IxF/fR2ktZpxcgllBv8n7lohDpC528gYQXukk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:21 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:21 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 05/10] nvme-multipath: add nvme_mpath_cdev_ioctl()
Date: Fri,  3 Jul 2026 10:31:59 +0000
Message-ID: <20260703103204.3724406-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:8:44d::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f6d44a5-440c-4323-8960-08ded8ee5d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	QU22oTcCbFVeQgboK+b+Edala9+VG2GHiZf80i71LSSgjzGz6woN9/pUCHzjqjJX8Xy2hFG0of7wH7zPAZFGa2uktO0nhw2wlM0UmT1dr7vpInCSvuE96X/leVYD/ULyc/KqlHywVxL9NmG62P1p6VZUVSFq+Z2sjmg5xVInywXeUzc86d1IMGF8zaw3ubsrbTU0UdlNc1vmk8XHNVDQvOok/rB0XWHu7KEKfRsZcBIIXELR+umosy8jOs4Tnij+touTxpG8h0JlFvlZXGVl9JFVhs2UmiPMp4j7tFsH7dcOIoO089BCoFGmuUE9YBRyy59f6UIFxlT0zN21PsjZm9E+RHxq5mzpquPNNICXZJ6Sa8qLTNaZgUPynrfthjzeSXzii0iuRiD9vdrYbHTcT5gWnFOTTlv19+QibysNf6nLOkYXHSr+7x2OBHc8y9inLqzPocUY5hy3974gyV7TV5ujvuT6jPAWa8QrJuwb9YQnDBvW5TVDjIgAGZUc9sNbVwNmGLgV2e+ksRUiHttV6eqTgTtAa8KrPdF2WAtjMlBD0nlZTmAZHfuUvYi1ounluWTO1RdhaAUsjGAF1JccZyzbM8qBbeUj7pp6WTbLC40TqqTkri2/jtlNLjEwU5JF+O/gs6kDJG54e3yJtTtHmzkRV1UFKQ0vGoS+ftth6RI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EwNgwUIeHpjTT3cLlrg+qQRc/2cQUXY4ayEEVrZlTYqWVINek76o5OveGXOM?=
 =?us-ascii?Q?sEaUEK7TfiqoEuEifo/No5uUUOWLeXTYLhwahX0gRa2FOsJqd9HR+fXQb9ze?=
 =?us-ascii?Q?QR6cTjVV7qlaAF9FCW2EoQ8HFsNx3Cl4z6Pa77E4iZJ1Gtljk4qD1XLXd40f?=
 =?us-ascii?Q?koPVapmKl35+J50lAIzumonKOBDs5hUariH2T4IkcuyZKfQuBIS/5HoodHKS?=
 =?us-ascii?Q?rPuibUpXz6GuPHbUWgYEZK950EfcQ4sCEtUlzvIlwp0m0Qn1ZXuIs0xPhvjS?=
 =?us-ascii?Q?FUZ9BPZmDL/HCizXjpKCC1caeesFZRprzJO0iPXx2Y0roaU3kgklmwmXg0eX?=
 =?us-ascii?Q?EjNULtq+B0dW6kxTN1MtNjv4ILZKQu5iTGlzcMrcBdnu7UKDHOiadzQ29t32?=
 =?us-ascii?Q?RlMyNzeFYDB3PBgPj2O34Aq4Ffq3+NuvKl4UmQBNxV56vVA9+msZLuFCuCzY?=
 =?us-ascii?Q?9m9H6Vv9dsXgICdjaNMfm2WWTg+BXeRAXvAwhN7F9VMCIe1fGIbUrrWNmIVd?=
 =?us-ascii?Q?EwcSATMa7W3etFe97oGrVAykLm5XjEyDbuN/YjXXYjiPoPgTYG6aAr8WdtXW?=
 =?us-ascii?Q?xfzjGliQEedaDoDizPdM/Sr2qAsh6PFymHCgsMPGES4rsAYr9qg1N91wCg7M?=
 =?us-ascii?Q?vz934vmnpycyhQ8CWPQ7x1/RT46v30vgKB3f6BvwDEC45Pvc9sKr03uoom4F?=
 =?us-ascii?Q?/7ivnaQM/GkTJzUmHrZqxMxk8kCgsmNdIvzj7LMw31M3kRjKcVQahF2rH7Y1?=
 =?us-ascii?Q?qlqPiLM2I7GO5VDujOHy1P5oA7qel8BKPQ5JQnCj10em/FdhRYdpC+c4bNAC?=
 =?us-ascii?Q?XiNZyAVvAcQQ7E5Zp8xskfA2gjBcKRSogiS749AyutmC/Qpqiejp6sq6XUXK?=
 =?us-ascii?Q?JQNItPVuo0dWS4r5jJoWlSOWiwgD1ezZ3iVjrA+rVQTjaVacMtcNPszzsgTN?=
 =?us-ascii?Q?YjU0Ayz/sOAwxLimX6GK37Yujt9WZN+79DZsNTZN3WDEtcl9mvb+xE2krq8X?=
 =?us-ascii?Q?315WTyem9pCUhMRnGUA92gQ8t4eT2+eRUU+VdHGXrF+ehpELj/o4hZkNfHnD?=
 =?us-ascii?Q?9Wy/EFLd1fEC2fStKjkOyxdqQT+zB6QPBqk1ftWRCMIK82s/2zv+KJ6m4cVc?=
 =?us-ascii?Q?RBVKeEaW9niFz0qy+dZjHDCeUAhNDxKvJwWCze2SqwVzqWD/quAL1vim65/L?=
 =?us-ascii?Q?n1t4HYkQiNrEkLFxWb9h2C/wfszUg/iGNV9bQZ518R/0w+Y93h6MOKj5ouGJ?=
 =?us-ascii?Q?BO3HnhxYUKDl49+i4CKxKdVhft9p1Zqgu3Sr1l+6c+hpsu4LTrC0QNDAuScr?=
 =?us-ascii?Q?LvpMRvvQUKhGZcJTBmGP9fQmgdxpe2Qnh4OsFyYrxdyZQTCHf/viNDKOaIEd?=
 =?us-ascii?Q?VCqIv7v3ws3nyxB0n6Li9HjEBX4+SgGc8jTKcDfp0SXIE7BjHUjSsb4fYUm8?=
 =?us-ascii?Q?7mjCb1eH/DT5KE0etTpzISuOuMxf/nf99okqKaYFhSlIsREP5FxDdrESDeWc?=
 =?us-ascii?Q?7jCHKtTn2jnSAUBZdOSM/F4lEh9eUjUOAsUkbbnsURNU+nol4ZopwFh8hWih?=
 =?us-ascii?Q?0P59pbncnhzZo4/4UiRJBuo9bIWIQsGtJcYqpFKUYNTtsrqntzitiwuCHZ/n?=
 =?us-ascii?Q?BugrZ8keSBE19mMfzPXfBs+jQU4Ol+K3KP1q6tE+XoCrqhoPDHrJ6tzKGhUM?=
 =?us-ascii?Q?WpJOsj0wWffinryiaSA+RizbRD6ipXqjXJcyXkcTDZChps94LPtbKr8rn+cj?=
 =?us-ascii?Q?v9CYnqjbKBPLsD49DOAzGYKe+9aT748=3D?=
X-Exchange-RoutingPolicyChecked:
	dnmkdD/7DKI1fOY3z9YG+K62OzmZiLwzSrEI4nl3/SGJske4OgR3MQRrFuW9xvm0J+F5BycPQOMpRSR0nPCf13h7zwvoHR6srkOVIivaS5O25ldkPFe0cj7wpXR1rfHGnx8zPfn1JtHdYrDBN8KA7mjDehCwVOLLl4DlkzwPE1lN2Hb30BNXKjzx3jOWdmqXGGQwkSkeMwku1Lwo+fOWn7aywy9I1pkU6eXEBNr9kCgACUnBvx1zAicHjEcl24vlJ1XEbEHZwOJmEu93nY8EtOCUUhPTDn9xyIpl74cR2B9dnwU8hb3Aq1kmliujVcs7X1iUPSeotoTgFrPkzuI/xw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R5Uhvq8X+czTviCQ7zt6MZ3VsqEakxNn3Y7adtlGNNfQBMDlcE8pfRjAGflVXM2C0PF7AdgviBPDn/FPmgPPbJMygT+vYMaOXUpDWW/6OUdubMY/Z4sRL9BiJCatZ+UdA/0NphfquTvkDgQ/GVZxDfN8wpzS1Edah3XCD0A2rMBxcaXckCCEsfVl9A7KI1HCKVyby9uV3WPSjUcG2yAEt2K4TAuKUY/1NYJrUwiT87aeBv7TkRCK5QkhDMJW1sV9MKRbzsePulO3bUQMSHA6Fhv2Ekzcr+8tLWti39v8B5iub/EEt7XblBTuCZULhjzsFwJbW0teGQThuFq+n5aBa77aTkkwz0cfpvF6yoZN6JHQKLenLCh2iVYAyy8mbQTqydc3/ub5XnODPsyCRrZZ7DT5x7GbOCht58Pggu+fvrv8+ta4piY5mPRvE01IXSpwxlR+lck5GAdDg+TkzrPDjMMSal1HgrpYSEdIydmJXLWZtrCc5g45r1zHuiEC2zH8+lXrB9sZJ5Va49ON/es866daBP/BJc7ERuCVPvS+gNzYFiOAeP6f4cgYLZK1C/wHu/KZMFAaRUewHINxM8DFa+9bB0msYefVi3YMPfatt0g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6d44a5-440c-4323-8960-08ded8ee5d12
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:21.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrgXFz3vHV3EJPZiaqPIiR8p61pwyqdTWB2ezRWDnFo0XgiqfmOxTZF8E4dBh3Qk8eaG3Dn/4SQkDDyseUUuqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: JPqsyGl4TvuKwcm5zCB6jTQUg2n2j--X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX08sUCvyJFmcL
 mdnZKAH7yqU/h6Jy7S3jXvsfxQL/uiA1woyNofagblpdMYvyJzENJH9dT166SyJNSx8JBv1jSF7
 JGPzsIDkoOU9e0D/113viTyHaEHVRbRBf07PKKPfPVtlPNgDNzA38dxO88gya2SWy3I4CU0nEjg
 u241A8VNbdl+DvBdgtM7HCjH2E2ypsvhRT96Qw87hlsdEMXpEJtLoP3P2ahQ9BWCluKp/MBekI9
 ig/M+VbyebTQuVpx6O+eS1b8csJq2Ki1P7FGcnlM34yefprM9PZFvDJ1yJMKm2b7FiEBssNnYhw
 fleRc/5M1lGk+RGfGqLbOZSoIbOcSm4UFHVsi4V9zUHU9HZzN4952XJPop/dEsn+XB4wwuBeSGQ
 ZHJf2DKkf9yfZSZSCFhz6GCibnNIPLvK08xS8u/Vp++//mo7hHa4x1cibN6swy79K/gVoqCcGyb
 As5Qpv2y1KmiOSV3drg==
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a478fb8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=7UCe6NBafOtkRfyzdoIA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: JPqsyGl4TvuKwcm5zCB6jTQUg2n2j--X
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4P6AZHEfP8a4
 6yGwqa1PvPZle0Wh7EJH9gWfqGZpN8g/gL5VlqYcDKA3V86cORmrU1hAvswTyUnTjUx2wLYmDE4
 CP1YhNqK0Q4ow7GiyM4Ucilj87GecRTXfWXOPK7d4WBNCmlPMIfi

Add nvme_mpath_cdev_ioctl(), which does the same as
nvme_ns_head_chr_ioctl()

Also add nvme_mpath_ioctl_begin() and nvme_mpath_ioctl_finish() - they are
special handling for how the SRCU read lock needs to be dropped for the
controller command IOCTL handling. In this, nvme_mpath_ioctl_begin() takes
a reference to the controller, and then mpath_chr_ioctl() will drop the
SRCU read lock before calling nvme_mpath_cdev_ioctl() and finally the
controller reference is dropped in nvme_mpath_ioctl_finish().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/ioctl.c     | 37 +++++++++++++++++++++++++++++++----
 drivers/nvme/host/multipath.c |  3 +++
 drivers/nvme/host/nvme.h      |  6 ++++++
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 664216eece4a6..14ac86b8b1a8a 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -623,11 +623,9 @@ int nvme_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return nvme_ns_ioctl(ns, cmd, argp, flags, open_for_write);
 }
 
-long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long _nvme_ns_chr_ioctl(struct nvme_ns *ns, unsigned int cmd,
+				unsigned long arg, bool open_for_write)
 {
-	struct nvme_ns *ns =
-		container_of(file_inode(file)->i_cdev, struct nvme_ns, cdev);
-	bool open_for_write = file->f_mode & FMODE_WRITE;
 	void __user *argp = (void __user *)arg;
 
 	if (is_ctrl_ioctl(cmd))
@@ -635,6 +633,14 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return nvme_ns_ioctl(ns, cmd, argp, 0, open_for_write);
 }
 
+long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct nvme_ns *ns =
+		container_of(file_inode(file)->i_cdev, struct nvme_ns, cdev);
+
+	return _nvme_ns_chr_ioctl(ns, cmd, arg, file->f_mode & FMODE_WRITE);
+}
+
 static int nvme_uring_cmd_checks(unsigned int issue_flags)
 {
 
@@ -689,6 +695,29 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
 	return 0;
 }
 #ifdef CONFIG_NVME_MULTIPATH
+long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned int cmd,
+					unsigned long arg, bool open_for_write)
+{
+	return _nvme_ns_chr_ioctl(nvme_mpath_to_ns(mpath_device), cmd,
+			arg, open_for_write);
+}
+
+void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
+		unsigned int cmd, void **data)
+{
+	struct nvme_ctrl *ctrl = nvme_mpath_to_ns(mpath_device)->ctrl;
+
+	if (is_ctrl_ioctl(cmd)) {
+		nvme_get_ctrl(ctrl);
+		*data = ctrl;
+	}
+}
+
+void nvme_mpath_ioctl_finish(void *opaque)
+{
+	nvme_put_ctrl(opaque);
+}
+
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
 		bool open_for_write)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 6d3df1775dbeb..9a1703f01ef60 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1551,4 +1551,7 @@ static const struct mpath_head_template mpdt = {
 	.del_cdev = nvme_mpath_del_cdev,
 	.is_disabled = nvme_mpath_is_disabled,
 	.is_optimized = nvme_mpath_is_optimized,
+	.cdev_ioctl = nvme_mpath_cdev_ioctl,
+	.ioctl_begin = nvme_mpath_ioctl_begin,
+	.ioctl_finish = nvme_mpath_ioctl_finish,
 };
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 3e023948015ac..4405e47bfe1d9 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1070,6 +1070,12 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
 
+long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned int cmd,
+			unsigned long arg, bool open_for_write);
+void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
+			unsigned int cmd, void **opaque);
+void nvme_mpath_ioctl_finish(void *opaque);
+
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
-- 
2.43.7

