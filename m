Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0886A4779A5;
	Wed, 29 Jul 2026 10:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322418; cv=fail; b=egEf2NWbAlxyyLUaqMb7p8kNA3z4w/Vhi1YQqWgqVUmkJ8cFYIeyCUEf6c0vKBhYbiJN2R1P+YeF54KnnOgW2cm4j/dS/y/VnhowMoSlzc7FHtOip62HVUMFHa98uvHHVmg0ep8Ra6XJXkkOb46SJpxddzaqtWyEFKAqOmsmdfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322418; c=relaxed/simple;
	bh=uola6VH3//ASpENVPI7xfkES8CyxP/As6n3iHr8nuvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tYZ8DqkTlVjuvmlkKV1uTI9Mc9yZJxsoNFItD4ors4HwkZJ+GQUOVGjr7kdIdIUQ8vmbrh1uk8DQwKiW2oZhoyCZgo4h1Gpne6e30QfHpkhVTWptBpUwOMYrmFvQps7JzvtkwnfoxizycvqYPrhnmzTQuEAGED5oQWMcIX511BY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NGRZqDtJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eBhSSuGs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NGRZqDtJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eBhSSuGs"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9V2et2091525;
	Wed, 29 Jul 2026 10:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gBj3QgBQSBfZsv/upBKvQw1d2sAyjf8/JwM+WxheL5E=; b=
	NGRZqDtJeF6oBeE+R8jADsfeRsIBZQghZg87oQkyX8aWQYOvlOt3twkZ0KyS47iN
	1CcNz1m1w4mvAq5I0+wSfsrkywOsAS0HJguiLNkV5KuWbuS5E+ScsLZdFqYdFxZr
	dk2Qk7oFoKENd0k8PKgzyGG/RvSboPoGagNQCgXaBdgM6vWVz2Pd7du/JiW+fXJw
	tgtZtV9SUh9put+0L0vbdvhkgN8Et1+RrPURQ/lskcxgRO2G5Ub+HwmHyj2FDqgT
	DBEbKAJ5ggO1RXXorFgLN5YCIb3r/TBxv4ovd3vAjfx+WMPrcDVHXve+zhT8UoEV
	QCc788tyr/bENMFs37rCOw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyydqg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5t7039998;
	Wed, 29 Jul 2026 10:51:50 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010048.outbound.protection.outlook.com [52.101.85.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk3k-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ipJ9pDRM1TIwaiRUzjw1j9gvavuzWEPqbmj642TLT5kMGBapPW83QYwpzW5ecelyOpNP5X6yg/V57YHulJ/B56qsqNTgMJGlnhyz2s309QqqXvuhHkhQuY2t1aN8JE8JTMx19M8ntVDFVqknGZg15BfvMoEHnpXf8hklRQkm8sbo7mOED9WbrvVX7XPo52EtXtsHi6ojm+lp2O+LIH30MnqRxDPQq51+w+/Ucf+/jLththWlI6tt9ZWdsX7YqGA+R+2URIPHmHGEbAty/7mJ2Jg69NDEU074NFU699C5F9EZIlP7kWL842Isj5XrIfom7Xrexaw6HxGvq8TtUqY4aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBj3QgBQSBfZsv/upBKvQw1d2sAyjf8/JwM+WxheL5E=;
 b=WFozOF/+gtVtFmx9QJc2dJTztgR4sbS1fuq91YOmjGsHB1DuAaYIsRnbpR5K3h+R96anY3T60BKPja54yiwxDfzeUtHUS+d6aODTK7nJjYuy69cqUOhdP9XXD/N8aJETiHGuvWqLPGUFXcpg6kJnmqYS+UzbhbNIirhtB/rV680+FtqGNTLOuQTYsONE7sZSMHF3Kk02nf3MjcWeBeDNwXVN9xilqcQkur8CDOxCdWqnGpPspxauuSKiHvv28VaUm0zpvELAQXRl7vlh5MDUWaKljdY+F/NAI1w3Afb+jOT/Gab62fiAA6UzCWgSPE677mHakg1BObanJ4cu3F80xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBj3QgBQSBfZsv/upBKvQw1d2sAyjf8/JwM+WxheL5E=;
 b=eBhSSuGsVnbG1AGNSxwH3qfPfWgW3eUg0/4Ed6mzxb/KJCojpkecAHo5JE1lKyJW7j1j21QY1Aj0H4VrNizCVLWzzAw0cbXasAJ8w2JomuA5W+w4OIhAlTm/VkIEMC3VCA15ZXYhm40Wjst5ZhlTHFXIZOcgHSPXVEtgjHpO0bY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 07/27] libmultipath: Add sysfs helpers
Date: Wed, 29 Jul 2026 10:50:47 +0000
Message-ID: <20260729105107.255712-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P221CA0028.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25c::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a0bb544-7a0e-4802-607e-08deed5f6242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DJvhCEec6+daH2E28WSK0g39mKdNyc8VvK0pnBnmO8kguNyfqIUHmOJFawyCmjWXFYfQnSSDF1JA2+JOKLyX/gx6djOWnGpsj+2MyOk1J7MG5cxd4J5TYFrzWkUx4EMZ41rFpVXxIjiTbMRCk+MpmCnuBmX0Vznr6PZtdpsKskeRL8VkTwbWSc0Z05rTY7UHSUDf1IMPer6sgUsPyFu7FDaTnypDhwKLo98lOmyFJMKHkkDrKh3I/L6FkezKbuADgrohfcrEvSSJ67XSlWWO9MvH+AToFZbCnKb9swX3czqBrf83cY1uD2gazDzYfVFrRaI560CSNF4YCVVL5n3NvwUZ4gpliJoHCgwtKkweaXMsksk6siC3RrCh1h3eH/ocaseqZmYjYTPp8GtJ5g/dtYBkt6zU+4r/1/tXs2ULJ110bbZOUBBnyunQOanSf5KR2yU1LKHkKQm1FNBTDt0THZhI6xFhCQxzumvZSYf4HuvFpUPIqmV1xVILSeOtueM2tDQ93tssa7kAeOnypuAVNUEo3YCX8lziRN605Jp0ycM/jR/Qy1xIFyS/o1FRTPqhdqiBSANC9D1IKcnd910Njk0DnnYs7YXMeWBjDrChaq20IGpIHE/Xo6IeDC+GoquDn0GHwEtCDY0BJ5TYq2ZzWDLozchLBCRvI5S2pfUZMr8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HPZWJWzwRNlOk9KVSft9Bicw4JnM8RW5rsJsWDoB9kRsMcikmMKmDNPlRukP?=
 =?us-ascii?Q?n2J75BxAHba60wgJNtcUBMlCC40S9pUC2jh73rpqCpNgluq8Y1oaQQnOs57M?=
 =?us-ascii?Q?/dd8vPclQ9qR11Vt4I01v6pzJfQc8RBk37Pb3dphVAIv+qe9J3mVL+UKqfbT?=
 =?us-ascii?Q?RX21Z+tzujYoqOTPMRhL4sZwyg7lOg/ucLTRaJo2iTO+WzNCsAfqlP3BtFdm?=
 =?us-ascii?Q?oBJaeb/MX0SfKOBYb1tv+8qpD4+O6CwK03hIMrYvXyd0PJei7I+i5QOnS/Ro?=
 =?us-ascii?Q?Z3H5Y82zNDXFv7/DQNwu9tgh8jAXtoIEYgg9EFIva97isWpBxyjPVeafv9ML?=
 =?us-ascii?Q?4/tBOurUdnhRfquHExxOY8XFh+Dy/Hso/2uoUlFXW75VM0Cgq5X2p/I41ghn?=
 =?us-ascii?Q?1tB+NVeAlaO4CzDh82lkdao/8n1secUIkzLblIWCIy2b/oxL32cS2mKw/HFP?=
 =?us-ascii?Q?dacwpdrtmHCAkhYnlpax/7uMDiiuJ2GiAcYQc+L+2qBBLmQ3syeJKhh70PHe?=
 =?us-ascii?Q?w9lVIpLXJA5i1a+TAa0OvUtEYIuM13bUjHDkw6Hq/NcX35FDCSM/z9zNcdEF?=
 =?us-ascii?Q?C8ruYlW5nsChDhBUEO7ahGE7mknxw3SrG7wcew+3qVEKK7OW74OW5CmVfiFq?=
 =?us-ascii?Q?slVWmA872LwkBRjqnSWgTLLaz7Jcc/wsO+Gk7pAjt0EsPX3jU1eJyCJSRAOs?=
 =?us-ascii?Q?DmdsbIjaLzZiNrTclmYq6yWIKcft71IyuYnjpvSToYIRP0DsQXIOkbbt5zQV?=
 =?us-ascii?Q?HHp61dPF4rLWnU7e+k4q/VTYPHb6zm8QC44x6G3Tvp5FkfST4EI+F4J1Qko+?=
 =?us-ascii?Q?nHQgRv3MBmb37S2rxOYPA9kF7Wv1to7Pz5h+G1ITMO++sO7azR2WdIiDeo+m?=
 =?us-ascii?Q?+nWlfFb028ZMQ43lKGeYcAdtHJOybmf03aYImGBV2/W3jaMpRbPBv44OdEPA?=
 =?us-ascii?Q?JWFHpW01TtwO6qQxPz+bskm00FQ2VIcyMT5ALkmmiSAAjB1q2gESsLe7cvyh?=
 =?us-ascii?Q?Jk8kK2oo/GTH9N9yjUELhnB2ATmhbA4P3lfSZbH2dGW0htig/IzOYSMSrZmF?=
 =?us-ascii?Q?NM9kKC12/T7inpCirIvDWPUMhxNleteo98E7lY5dyJnjuasyrdKor5wlPBcV?=
 =?us-ascii?Q?NyAvGJvmLOifiblIdpISQ4+00pXNm4whUtI933kzQit/uVDCwD79WtOnBL7S?=
 =?us-ascii?Q?mg1mhpCG/TvgjQc+7tbcxlbPf5y/7QOmlb+qAT8YZcn/ul+AteVLUQgmDYfs?=
 =?us-ascii?Q?u8UEw7ef8nM+aF/z6HnRrW60RORKBqJvNCicrzLbBAHYLNnvm3ZZ+AavoJIi?=
 =?us-ascii?Q?LOwYw4n4YeJlcp9Pyud7+rz+WJn1Aw2fSPL1OwHiqsWKU4RxzMGqAVhTz6qm?=
 =?us-ascii?Q?flyVjh0Ri3OfLd0tvDlkpix0glttqxIKcGVXA5cXQ8m9HUiND5zjCLx8CA/T?=
 =?us-ascii?Q?B3RvpIG29SohiLFtQS3c28Be1digqFgYKC/+sN+r5a7J8gmDK1f+nOrAAC0D?=
 =?us-ascii?Q?arIk2Uh5gk2Av6lwStNJjE4Oq2v72d+yj6UXjIxh2J/sLpjrkVQ6+aLvV1S0?=
 =?us-ascii?Q?dpqij7Bh0lspBFBGCRA9618fSLvB3Z/L4F2Orcb/wM5gPsP5Wt7PuHV/G/X4?=
 =?us-ascii?Q?Sy2x3NKZZ9yMD0oSl23vM/lbtrTJb0lXF35GfvZpyL9YlTWsNmbL272DoX+w?=
 =?us-ascii?Q?uJ3JJQGdy96s70jIeUwwiiHPyHH8f9Esq8rg07WLrRZJD3tB6W/35ZR1gbsY?=
 =?us-ascii?Q?5CbHMDVvXQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	MtUVoJdsS9120LMJ0NKcN9O7tdXlafuCdzQc9jve5yB9M9oIZtFrwIwtk842yz21rm0jnFCRrj+XZL3xSjnWkBEnXLeQxftpW8nZ42WzhePgE6DC4qGFSHJ83LtcufB2oG/3PpezpJrQtGV3lUZXmgahgKd1ZGFeZRss0gftrIrJUwsh/fMR+TL0jff0+0WZfZE9ikgoJfFWKrbVM2pNfPPf0KtpjW38QHvG4RVOYpapnQIjdHAcV5B9JAihWnah+rU1YYVOa2TFR4l7lQlHU2UXmoQUg0/XH4xPxzRjvRoZ+CtYtX4S0jXctHnHnMyUax2y5zQW4XRamq+9qZXpdA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7/5a+HP+QjA6BxAr3bYwfHAW51tEDwEeVQIz46V2mmgD9n6QvKEzGZ7wvlJFudkBaEsu1+wbSsvPSSfD2MgbuIC+P0xKHdWD+P8MHeaaL0KmPbNynG2HcOsk9ifaXoAOpB/AjyzGeMYqXI3yGnqdJcW834vteRNtaz+SzD4OYJjeiVOqW0gfSMLRYYO6cSofTJ4NOUBBaz/aoE5PtUhvs5QqvSFjCOcJ8X7vAWvhU+5mRMKQAGamGPF+qKK9wZpdfAhF1s9De1JUu5X29dHrmTzk5ezegaGC/9KhACukMp91/aZuQX96YNYiY2HXWEFQpw4izIacQu0WebHwRcz5SJv2wJw83qIPVW+HP2WjQNgh4awnuS/mYxpV51xRFgQF1gA7PQE0ZGMdGyv+IW8z70hJ8WqKwXt426ErZzxMOdFW97o3NC+yi+ugeMS2TNZwxNA0qCQFS+URRIfRbvzFt17FSzt8QC0JSaUYrlqeTqtzCTCpJ2qKB+ufCMLXIkhfTT8iab3BkaJeaajIixmMQ/B3ejerSjBKIruunvSYetfp5YT0vUZZb4Q5hHXoGWU8ErC0abPUMQBKYuD9jS8oFWPND28kSg5KvwZOgZiDakk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0bb544-7a0e-4802-607e-08deed5f6242
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:46.3400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ECPJldjsYxQF0hfxRDTQaV5Z5uaF8DWmyNw2xOlyIyR4KMgn057cAhSX3twyozxhlebP4utK2pZEBVo5Ory6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfXwsm894kFaJfN
 4RvroLpTvSA4xJRdEmLgWudfV6mdRkoXXRft3Av1ug93knuNT5OfQ5Pp9FxyfdOYbOZf4iRgosS
 G7lmUBXiWnqAdr/Hw68DFoe11R0ZqJR3JKki/DyBZUPj1nCtxRM7
X-Proofpoint-GUID: jVaG5ZIw6831Geln96J3nKzsT2lQ6LTR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX4fOvXLwa3IO8
 qtDxswS2fmb0lwipha4FQromAx+DunolB/HhVzXbhUB+f9Smca6Fafk8lGIX7DLc4mmRtua9qfm
 TaaPwGVuvE5nVMZy7cVnLnmHG3AHa6z07t4ZfxqqKWIZvIzNKKTnC5aiSHeBsO/sEkYfiaCsbNh
 BbBD6Mwygdfsab2xFX702NNmVDkUGVkqCoY7W37o+EgXbvyN8hSKcm4plz6aJ2sjqBfecd5+mbe
 JJCzgmTkFNjYIpQeeLavoiHv1yyzi5v+B2VZvviS22RNwyCm+4nSlDnQftHhoQsdt9bX/6+4WEm
 uGda2vYt3pjarmpExjAEshz/W0ylLxjn57wyQjMBeLsiyUWcPicYRHwPZXm3md2yuRxOtF+1dkK
 lqUB2yEwmVksYp122kimC6hyvb7S5HlP0VZBz/C21jjOQEI0CMHA/sjVmVgF2o1ZtWCBppmq+W2
 nOMP/5iGhNspNXRukjA==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69db47 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=JWw5DRbbQmmJTouRsXkA:9
X-Proofpoint-ORIG-GUID: jVaG5ZIw6831Geln96J3nKzsT2lQ6LTR

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
index fada92bf9754c..58eb9be5bebbe 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -620,6 +620,100 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
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

