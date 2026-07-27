Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71B13FDBEF;
	Mon, 27 Jul 2026 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163446; cv=fail; b=F79rsoY0tDD3z1f/dR8xx/zjzNQzRdnS5VhR9MIzybgg/KgdMRZdJvJbppAmwcS/ig+lNROUkNwr9zyXFrIrUTjKDYgdhOr95kNTI0nqsMhCFTxQiucOiq4fj2DwR8o8+ShcdHqPtFl4mfKNt1vzpwZTQdlRC7p6jXhmEtBLtmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163446; c=relaxed/simple;
	bh=IFXdY+yYnu5+TAZXGKa+7oxT8LYKYw71gA6qu0WWnbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WqT8o9v4S7zoICF7kOlevn03kknPjAiNvkyB9UsoiIF35yKS0cnMrsoJ0uf3ZfWFnor2gR18qgshNGDi+cpNNlKBTrtEzy17QT9G0pHcrySwW6efT9SnwaqPi3MCvHrmSKZcTnMKwp+dRa5/gDZ1K8pCrZ8akFzkIOPsLOUEf80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XUEfqcZM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bt64+M3Y; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XUEfqcZM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bt64+M3Y"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTTS92057116;
	Mon, 27 Jul 2026 14:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C8/zhwVEa8QoyhQNdRwKYe2J6nbhspr5knT/ONacA6g=; b=
	XUEfqcZMXxFmtFyogIiUo2ppqjGG9TcZZF0RWs9iM7cFFi3eoQVN1XXaoKCMEPh6
	nIT01D+pmQHtI2bj5rlhJBVp1u95GRG8+HaDHEWixSbMBAWwvHCiNf7Fne4rOUoq
	JVJSs1Y3FdRkSCXUqMGwvHaTzAEx7FoySDoFQTdX4mkPQRnObWIoaWrbuClPvqNt
	3lkHbaq1goDh9cuB1jE5Gb//pUSCH0Nlq+6k6ztDFglMfQSJ3fIS4mNMXlv5UbYM
	Tk+5FAiDvLUzezCZG+u3huZ0cL6Cpra40LixMMWW9FsxeSr5W7zwEM8JN2Q2Q9xr
	t0KMGlBTayn+55s6oU2fAA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq1xgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeBOb006867;
	Mon, 27 Jul 2026 14:43:08 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehaw70-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XoVyx1wRgoRcrd7lNP69kC83tHCvH9EMTAD70R5/UL45LhuR45+30vdQAhQkRAE7uIpelIVklAPttecY7mq71ouXDpEXDHu9e60Xy2fq8vFSFTv+rtXlf0GHp2AJ6bm+miNiB4E4D3Xxa74B+tP5FEXNeIot5VxClOz/9lBRIt0cd4sG1+TAlwExNLH6kjy6k1/fTZgRE+EPN7odQYaF1OU+ufl/+NIMUx7v0JAR5pBVaQv6kVCN6/VInuWgj6NbDrelXxMsWxo2ZEokP1maX1RnPAThlTIlAcysXJM5OhtkbCdIbdgRd+U7nbk83ZLTwdUuTy/RfdHT/OaQGMSGdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8/zhwVEa8QoyhQNdRwKYe2J6nbhspr5knT/ONacA6g=;
 b=LH1gUHaJ0iL7Bm6bOFoAD844idwkS12rUGm6/+sUxgtgR4BuGObIjhA/5PBmYYixgkdUFJQrU6SQo8yT2Dm8/4COnBdXFo8loUlnaYqi4BvVH7961w96P342LC+RhlclxszqKZzUNcVwVfQvwE9Ej5m7vGlH/219u0MvrqvcHZK6+FnDuhhNAqpFQo6ESmmA5nqv3ZVnY8DPB2z1SnNRlxAeqat7GxckXqVUyx5472HYCKal+ZxrJCJcs23EvpH2yo7TYHWREb8q9sW9RcYVPgl4cXjjdmCCt6h3x8vLki/+9W3mixTCFkffKfxgU0Uhkg78zJKuaFUO5EuVQc9uZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8/zhwVEa8QoyhQNdRwKYe2J6nbhspr5knT/ONacA6g=;
 b=bt64+M3YmNXfjdZxK2t3xGPmoZHJxR3SSoL4e6kCfiLPjX0f0eIayehVHxPwtSG0N/kGtPsbq4EN33+T/mjfGUqKzC9vzHPyEUJfH2CaDs5btxhGCNFLzfYH5krkSTvIHQBJmz/mLONCpMZ8r1Wns6BE+T4dVRy0jnT0Ktggs48=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:05 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:05 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 07/27] libmultipath: Add sysfs helpers
Date: Mon, 27 Jul 2026 14:42:14 +0000
Message-ID: <20260727144234.3802948-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:610:4d::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 65231fb1-f8eb-443b-b4af-08deebed5e31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	L27vqK4ZHX+oNDLIbxfAUsnM1dvzGqApRuCe81mOLwJhLSnaDdVbfua/MJqvaGf4iEaDr0oWDF4g8K9vQ2kDlXq1Uiv+iySAnp1Xs1XFni9QxMC50r9FZ5RSC+RBWTzVhYhsxuboCJoSCd8MzD/nJtOXaQEZ3R/e3fKmmBXJ/vTovzuDg5hrRY6sW+fegerksvFqlIaWvs3ki4HZDymWQ6eu81I1uK7EF8y+7Qb4USyB7qZfpAMSbMpFmkI54483L/YNBo/sjm9/bj4NxvHbkKeRS2DS4+wd8CNJ43CbMqtTLzt74r/Aagg9HIibEW+orCYwFuXd6haFpx8Ld2hNQHMtq6TADDwu1vhAvgGScNRFcW3SyUxQh/GAbO0It+zEjFQU72AQnBtijoSmubwfKpqHVQ0QhOCmYrdHIfeGxLyRM7mIyJNdBKu3bihNrwzcwlh8qM/5ApHnEONLwnbu9EIBCu+D7Q3+l7hL7mEiVZXUeuzI89q4ovw2uG4BZ0GZ8ORymfkdEi1rd67aMRujt+aer6k5kxq0LEYR1Wg/cgO9pOCI4qwuJoSHrHmNWSX+LaqlD2OBVUCs0cL69IKzQKcsUXhtBhChkplyWZOCmWcmwFJRpfGUVFY/8AhAAUsKYEMoMmGp0jtes5CPflRwKRbraDHGl4p0YDgxJJ32zcw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rPa+4AOFVjLEMMf9Lm+lHzcQqmwutDL++CVVvvSd0PohtI8tz2+8Iimot7zh?=
 =?us-ascii?Q?SzCmU6tD9hMtgAe/ZXZGa3EqBRqFBJFcqLNmodK50mJqSnYflxlNIeWWJ/hs?=
 =?us-ascii?Q?rDtFU2iR6Mvz5dlNpUnFqMCxUR0tCkHeCR47us4FmBb2PXy/f0+zVYsQPGpO?=
 =?us-ascii?Q?ZFWCF4X9oVuBCialVXZgv0uJikaSE+wFNBLfH1s9lE8aa4aRGG+FO1BlND79?=
 =?us-ascii?Q?LHBKoc8GfFERDonruJcaUFG3PJFCqLyQHd4SmfS6xZYscYTxixIWvH1gQne4?=
 =?us-ascii?Q?U1c7s/wF6W9rTgwoiUWHzZq3WMxQRhGTJpq1Rp1znTEgr+M87HoUNTIIAGe+?=
 =?us-ascii?Q?8Ag6sKArDP+P1R+vSNNEJprGkQaIiUuxHBY5riQ152TN79inhORw9FzV8QxL?=
 =?us-ascii?Q?Lifw3SwDGSB2GPqFfGHTwvpsgmTFArDUwIhBHU3oPq0mMsxXowZy3dngnpRp?=
 =?us-ascii?Q?rwH2H83HiQU9Fjjo6GfKNzLytxikPu6QI0BCql81952fdJxkb3M1yulllPOb?=
 =?us-ascii?Q?KvX9lXPoRnAo+BEP4KMzJ/oHsTE2CIgU2rxfH2mJQYzEXzZcB9hA6m8X57sv?=
 =?us-ascii?Q?1f9y5WFfoArWqqSU6Tiv+Zv3Pl0bjcuiaZKlv2kOck307cVwvvSiTo5IX73u?=
 =?us-ascii?Q?ZRAmE6MTSpSvblMem/HsmkVVsbZpKLlHkRnebVudy+JDdPdV2GMGWmBKIu7z?=
 =?us-ascii?Q?+unPUv/iO9avfinRezAOkpy72GaDu2zuDlt2zHeZoRd0EGPcxnbAfd5RMlgV?=
 =?us-ascii?Q?IPDO3BXpXScNtNaOZet5baPkvqGV9pXGQaV6vieZ6q4iQMW0Q5fzCbG3E0Al?=
 =?us-ascii?Q?y6xBxTLlYWcoMoImUC/uZ7HGMwsXutyW9LRUFf7z4rMbxdDhxhpkPJRoT4U7?=
 =?us-ascii?Q?6u/q8SMRriFFoXsNU5pWUWf61N723e+VjATtnyFoqIW3fC+KO+tHiqvBElpL?=
 =?us-ascii?Q?+7O9PEyUYrLeMA8a1cMTDmxbqW6mtpwFgekueqk4y1Jo9CvbzoSt6ZeUwC+V?=
 =?us-ascii?Q?9dfUngGVoVVf2icHQfkpmcKH8F6WrhIAH1F3Ge6K7l8NuRXRa48SM417qEbC?=
 =?us-ascii?Q?UArPVzdW0VKoIPQhlJO+NJs9LMqcVm4QxkqGaki6X/oTlC+0+rjIQ9dLSzIg?=
 =?us-ascii?Q?wkwmTKLsxETDya6jRnea3++HKiY2SGj6zakvYmEn5Rn3qC7UetvkvUetmCoL?=
 =?us-ascii?Q?GfaH4hWpp2kvdXpDvEYFwOpb29Kj8PyYGUXMDjaqn8rSxjSeYAnHaSnnfSNq?=
 =?us-ascii?Q?O3f1zMLbHY54sk62NS8wxYHv3IgKYQy/+dWerlBlL8NrlPUzxcgvskfxTxsy?=
 =?us-ascii?Q?ID13R7TywjCnG82Aj9Si5akDrYmYjthGooY/zHJeFckeaTSveAw63S0fL/r4?=
 =?us-ascii?Q?+6GqtsXi0YfvxNVfCsGRQgGXlwcz0jJ2hbSHKXQ7+xGN3GQkn3uefm/zIXXI?=
 =?us-ascii?Q?DbyiFWyqrlE3KSKdNQoeXTIT9vbkIQP38i7/Xk5QE04EoKexgvbXTNmoD7RI?=
 =?us-ascii?Q?gZsHbtGr8wflsj/31ifzxTseKaAOCvTw6Ke1ksTmRXyr2mvANE46XwquHucW?=
 =?us-ascii?Q?lL4IUKu4YIWpqCQnYREhexMwMDEhTooovLy4iiXJ0d7d5FFx59v0zu1dO7UV?=
 =?us-ascii?Q?D5pPrpZZ43/RSnDEQy9KxXk9VMw1x7lYS2ik21tXwNUk8OWpklHcTdUGD+ps?=
 =?us-ascii?Q?S/olFPkNPERMCrR8fEgI+44WLjJzkLl4Z0UsbDt7lB6q0Mj8BZX3HQseMA7G?=
 =?us-ascii?Q?AlCpMkjimNr+oe7yLckcSERvoe1XBLE=3D?=
X-Exchange-RoutingPolicyChecked:
	ZdIlJtU55kvm6nzad0XVMrTq+0oCAO3tD8hbbdhM91mhjKKf6ix4OqbmfBXnLq68sz2KAQsMCqC5tVjmFq/0BPdbQZWpBL0IaNZFXGoBQlNQpVFmJsRjQypS+3j9GRSIvTcxXxjQPwtgYQxfkILsMM0mGQ62Pb/vgt+yIxaBynoWt5sNyEhedlr8rdA1uZ8U27ZjeyMkvbqTO4VENlr3uBOr0rwnjCOqDUDWytmVjPP429VIqBEJgYZ+PwwA1WUFOAYQ3xOMFZxFslTdakdQQaGZuUSqHLswbX3vnKkss3pSac7V3Zv+tGP/MDvmhIesMHYO1H2tr8ag21bBCLTRWw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sVtyfCmJx+VOy1uSboFh6HQAAPI2Bt/RZE6r+kI++zFqZHJ8gmBhl0Ok415VLqEHrSvcGIYeVLt7+0wC5kzX4a/JKXbvCCgZu2LPXC1qLYeKp7x9PJvcCb1r7lkcs4qeidjn4TGh2ikBGab5/1GziyCGSb8PriuWWavY5/C6A0zE46R2QP0eFMDv/fdSj8udDKn6EeVS8xnNrKhPbBo7QCKDtfUPX41E2m2OS3kK/PhNuZma/GYXK6tg5G2obtOkehzvY3by9pZdSartBLLruujOW+HZgKRrg6OjyKwHzYurTT3+q9dFxOnY3d8xvCH5uFH4sWY4lziD8MSquxhDsfhPq0rcpXa3EN/Ctv9juD0vLp1kOtFXqpfmA0HGY1b9MQvs0qsblRPKR5oOKFxllDQWoL4cCyxHcVQMLrunExt2Q4hZs75mgzOGDc5pedF9qhaq2INs+lnRG8HbgQO/DArJWVMFdtENaMVqC0FPzNzLsLroTOjUAfu2+S8SCDQ+p+3YDpugImGCXBwP9PGdslSjVJcx0CPsPpjg9aoWggoJB4SfYAdguO27uCtNR8iQS5ZxnIf+JNJfWO210AoS/M0BPTwR9uh0h/QpvEum9Uw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65231fb1-f8eb-443b-b4af-08deebed5e31
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:05.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IY90MJD+rydmCMS9JTctVOb7AhHyESn/q84UvJe2xlIH23CM9M2DOYuIGwtxqcriWM40nRNvqhXyR6iCGhSLbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX1a3oIp/ORyYa
 ggvMLROc3TToMdCux8dAY+40gfLXm0YJ5l68N9MoCRnyIRtoyNoR08wA4CG7yregApN57zchqz+
 J5Gx6OedY6oFb3HpTvz+A1w1sdLR1A9mE1or89hy0oWJrlkeuCQ994fVjIvZ9A+NqXcIUkaLKcK
 lN3EB8aIdH/Ce7N8Wn3j9PxsY7cKfISNTbFDb9aj5Czzyz7Qh9J5OLaONxlgRn1OsMBIdLqDhp1
 GRLIMFgnTm8hAgqHkYqetoEiU/K8BPyRvyYeWmnaDi/r6ss4FL3xPOrfSHO/SMyo4huoBr7Y+Rq
 gF82WS7T+VUHEVZru3Vc9NzUZZdthSz39aBD6JEH/ygi0cK+KxXm3xDVhbx7vf3K6snyk3mBQMg
 iJCeZsBfsnfVY6ynr1/TXiTrx0nDPtA9JAY2EPEN8gSdbwmIHbNdKwpCEYJSRS7JDLeztwNIeXf
 rSTe6sCtS0CTF+XvjHw==
X-Proofpoint-GUID: qUBoniH2FdrNnXX7f1tvWvdwKl6N8_Y2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX8sgGf9ZAs/Il
 81eEcl9RJz5kB1TGnAt6bgarVmdooIqvkE+cvtjdDZyS5yKM9JFFPeHTyN6jOgsLdqLUEMq0ZAX
 Thx6y+xBhTBZbceMQZJCoezU6YQTged1IjTI8vkjE6B7F0lthhbo
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a676e7d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=JWw5DRbbQmmJTouRsXkA:9
X-Proofpoint-ORIG-GUID: qUBoniH2FdrNnXX7f1tvWvdwKl6N8_Y2

Add helpers for driver sysfs code for the following functionality:
- get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
- show device path per NUMA node
- "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
- device groups attribute array, similar to nvme_ns_attr_groups but not
  containing NVMe members.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  5 +++
 lib/multipath.c           | 94 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 66b6ad9c2219a..7a3708ff37254 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,6 +7,8 @@
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
+extern const struct attribute_group mpath_attr_group;
+extern const struct attribute_group *mpath_device_groups[];
 
 enum mpath_iopolicy_e {
 	MPATH_IOPOLICY_NUMA,
@@ -118,6 +120,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
 bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf);
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf);
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *buf);
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 			char *buf);
 ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
diff --git a/lib/multipath.c b/lib/multipath.c
index ede06e5e901c8..c78d46a446cf3 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -617,6 +617,100 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static bool multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return is_mpath_disk(disk);
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
+
+const struct attribute_group mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
+};
+EXPORT_SYMBOL_GPL(mpath_attr_group);
+
+const struct attribute_group *mpath_device_groups[] = {
+	&mpath_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(mpath_device_groups);
+
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+		mpath_iopolicy_names[READ_ONCE(*iopolicy)]);
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_show);
+
+static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
+		int new)
+{
+	int old = READ_ONCE(*iopolicy);
+
+	if (old == new)
+		return;
+
+	WRITE_ONCE(*iopolicy, new);
+
+	pr_info("iopolicy changed from %s to %s\n",
+		mpath_iopolicy_names[old],
+		mpath_iopolicy_names[new]);
+}
+
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *buf)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
+		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
+			mpath_iopolicy_update(iopolicy, i);
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_store);
+
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int node, srcu_idx;
+	nodemask_t numa_nodes;
+	struct mpath_device *current_mpath_dev;
+
+	if (mpath_read_iopolicy(mpath_head) != MPATH_IOPOLICY_NUMA)
+		return 0;
+
+	nodes_clear(numa_nodes);
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	for_each_node(node) {
+		current_mpath_dev =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+		if (current_mpath_dev == mpath_device)
+			node_set(node, numa_nodes);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&numa_nodes));
+}
+EXPORT_SYMBOL_GPL(mpath_numa_nodes_show);
+
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 					char *buf)
 {
-- 
2.43.7

