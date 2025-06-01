Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020120.outbound.protection.outlook.com [52.101.195.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45095227;
	Sun,  1 Jun 2025 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748742068; cv=fail; b=No0Kgu52aZnLejouulHu1ORh50qgovbS7XDW9kJ1BNaWxMXKdbCzEWOLn8GXvzn7ujLYrNU8orvW2I3moHBUIQR82YH77j6ZB7TUnmsjHVoINZBRcVARbLCI4BKJO2F1+wj6DWk2pGsSPelc+iNkuxplUbNQz+SU4ysgTgSsRP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748742068; c=relaxed/simple;
	bh=F4xCCxpDicx6qWXuT30G+VoY+no0+9psfNOazYpqhkc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GSc5tqo38kgZWP4sn7NnWnhmJV5eZ0lDa0vJYFrmbH/itcYORO1SUO9vI+FVOh3HfXwRPltXIkSEL9YrR8789mlKTdGu2OsJV9JjcDalAJgJfxfS9+K3UcfbHs4uURdrtY+ADNTs/Mal9pUEPlKohLtsRU6NUN9nkbQs21/NwX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTOMhPAgbzK8m7UyazFGfaqYIGTFaUoRB4K+FboNeP1tBIP/2GW14FlkszAlstgTJVZ5CupbuUYLhA1aybsvAKXasR8q0s62gHuspHC6l446B41Wt3bfEmacFwL11I56uGpAaHE++OUV6CWuklmJSPI8cGjNoIZVpYUtIklDMbOIxdHrp0CLjrQBB1m8Vl4VlWrbxB2xk0rDLvk9elo8f/Z8i6SsdjmJE9/WpubfIdHgYQ+h4JZs+gJtyySjIaYLOelDfngXEvBwEOENlR/FHNo4g5cq/J3mNLH7DyEZIrx/BKopxY5ahCCiXY9oUYDIN5HdP/eoe/LIQJzMtIOAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIpu+OUey+jTGs4+B/n1jvzKlZ8nLYOs/8w+zEu4S0I=;
 b=RBbfmAZBOd/MypPpTzvpyunhuFS/SrnSyyMcEo+T8DgZYxPg3ifbA5RxGLzRxiMnmFB8shWjHveEQH48do0XURY2y3FLm9pHeE8FBDFRinwXZP6lCXRIq7EIsYG6sb7bJbKCNkPtWaoBmPYrDS5zcwI8a7wYXe9ZqDZCNrWGqEulKnVtrMrUagp3G0LD9OIttn/h1Qn4ggXMX2D3dviIOxULeXYy2SpY2IDDaKM1GenU/coX9IZcmAbdNo06Hgc3IBc7KAcHr2tvHXV+ozfsqwkFuVNoyS7y4p+tbw1omZO9vk+rQ6wxruK/mXuU20CEa1SFmprb/p5YnWa8qUPUyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB5679.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:229::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.16; Sun, 1 Jun
 2025 01:41:02 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%4]) with mapi id 15.20.8813.016; Sun, 1 Jun 2025
 01:41:01 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	atomlin@atomlin.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/1] scsi: mpi3mr: Introduce smp_affinity_enable module parameter
Date: Sat, 31 May 2025 21:40:55 -0400
Message-ID: <20250601014056.128716-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.49.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN7PR06CA0044.namprd06.prod.outlook.com
 (2603:10b6:408:34::21) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: e26001e9-135e-4a0a-f1ad-08dda0ad5d54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DL1UziL1jTS631LSjgq0aKxlI1+HuL3OdcLjej2jWRgCBacpjkyyG1Wkk6kI?=
 =?us-ascii?Q?uACCZEkyl0DPuOFOkQHdKU3oDoHc5TwvTLo9TxyD7D39d38a7M+hMYn7YV9H?=
 =?us-ascii?Q?TbUHo4JoTax2Wpo6JHH3BhzVpAHfFOhEmG8d5hdg4V9CrOEdjto3sPDjlpnf?=
 =?us-ascii?Q?wTlHZJNrrY+VK6cgWsQwk4Zhhytig0oRSkkfWOzXnDGyy3HGJgG9IiFr+C1g?=
 =?us-ascii?Q?c4dxeo0f4CFV69apAuoqWnSQ5Lzw/Pie0DZNBYPEqCVXCPsQRwwL6EvUxi0D?=
 =?us-ascii?Q?i4dQujHe6BU8kORfoPdJybFr5a3RNmKuoyzKbkWtGGRm4eMQgPBs/u3ZiVoH?=
 =?us-ascii?Q?HrICzvK51vvbWbhspv3Hpi5L9/YZ+BKscrD+77w1DV8wPwLkI4vv62Xn4/xH?=
 =?us-ascii?Q?tBBmqoY8Y5FEbJV4RLJ8dyYJS4AZzSAAtAVZDE1bNRBXrgM/B0zYZ6HdMBSd?=
 =?us-ascii?Q?hKlAxulclp3SqnATxO66jxWO3+N6/o1AKabO0XEWjxQrqQjEFIvYxiNXzizs?=
 =?us-ascii?Q?UYBNgWrO69GjMMM9lSR7CsHtx/WZWhbaD/MXqxbY8/OZTY9xHss59cn5wIVw?=
 =?us-ascii?Q?2Y/NBi4xBgZ72ObLORD6fbe1wGytUPh238w/yzdEq8/NTIUW3WjuMacLbaDb?=
 =?us-ascii?Q?T+fJy+6WpYGXekIpB0xe32SMIlixGBCoUOYbO+bj16LKVBOvmZ/jOyXNnheJ?=
 =?us-ascii?Q?19Cv3RhL1OdpjwE5e9Ox5G3whHm+0GSIRAp8145hw7qa3YatUbMkc7LJr8xi?=
 =?us-ascii?Q?FbDKrSykWm6164zwXsjWiKyAau8yFi5ibTdzbxNuBDRO0eVHJL2ZxyYzI+/U?=
 =?us-ascii?Q?hCHfODA9uRREHxlDs7xfzY5O27B3sxZ/kiH62ku4sqBHyrSiVrIEquBSvcE0?=
 =?us-ascii?Q?JqrAStbG9mfhiZdreCRDNpW6ec7hLwtojwMfa33MDPIfm79OH+DUjo3GtEq4?=
 =?us-ascii?Q?L5pH2ffobfNCKIW1my92fd5tDSxdtCPouETkb+2RA/g1ByYMPDWyCmIwpBMv?=
 =?us-ascii?Q?PBCKXlQS0dSvoMD7qlKI5OqZuplt2ohVtPkINZGifJWjF4yGFknHsjdk80qg?=
 =?us-ascii?Q?QAKcMfKzXCIC6z2hAwnydOVgve8k+uMp9YXGWsDmOzzVpc/CZLb5M4fDmqk1?=
 =?us-ascii?Q?htX7PtQBPbidaFGTrO3YjO8ojZucWC/vpvvqr3M9gEI++pS4pbFGhIsvgc+z?=
 =?us-ascii?Q?lQSFX8618QDcQJt5dhatNRqYK3i2ejUU1BmZVNt2IEXLg6Fst1Ia4Zs+Jb4M?=
 =?us-ascii?Q?kYk7LdkqpB379b3CtH1OiwTu72nVkzI0qTtZDtiUdoUUMG6GdehLItam5Zah?=
 =?us-ascii?Q?pcf7f93HEx2F7SU5MX1Y3SPLb/IvCbTqb39DvPZHLn/lfO+HTn0fEB0UHLWN?=
 =?us-ascii?Q?MAjA5SxgXm5FrwEG4fGgjAPC8AedNecu6WwtuZ5RlioVJmrEKl4I4Pz7QRI7?=
 =?us-ascii?Q?R51nVAoqMRs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BtdTdf9cAXo2/gh+SsjDGflvtKNPlfhrPK2XupEkVaP9kG6ekXwI+VSzF2xR?=
 =?us-ascii?Q?wxezFcAFELQS9H89rjMDMOUSRHXTYXnVxGtRNSo33krPa0NM8ObWPhwE5t6z?=
 =?us-ascii?Q?ZsjoXjsqvrkrb1XmxkZWlMjtMzhl8u8u4jNLrSV/auUKEBzNnZ4oUITEnlX3?=
 =?us-ascii?Q?M6+hYnEBk/929BlmfHoX5XARgsK0le6Q1A8F1VlM5FGJWEANUA67NZMiCvs/?=
 =?us-ascii?Q?CX2QzXusMMtv0gwYp45JukDaGGCIr4H0W5V0bNS9U8RQO+VL7jWjeKGrCNWn?=
 =?us-ascii?Q?hU3XJsuGWBNg2nHJTtaGbfQhm5iXNninf4IJq8Cn8NElFW+32aOMeIR4EIBD?=
 =?us-ascii?Q?X/l1TfgDxjY62zYaXFRMlXzOolFJSRyNrLfZY8WHFFIvdyM5N9hHvJItxGRY?=
 =?us-ascii?Q?nhh/guFShB2LYMymjCeF+4UjvHPRXHA+EJ+Hpvhkv05PvqQ6ZgRDjXrCWThE?=
 =?us-ascii?Q?vKJ6ajzKoh2M2VJ0IdC+NXJjQt///fvl2bSeyYl7NhAFF80yhy2x2euTNcCb?=
 =?us-ascii?Q?WqkqyVeMer7UtGzYzXWK6EV5KTHd+9IZvJ+ZW7Cag66eq2aI/x9m8l4iZhVU?=
 =?us-ascii?Q?7Fc6/w7qj+pYR6lV0afwRQiep4UbJ57uC55vX1x6fAaQtdd0cnl4mxv+DD+H?=
 =?us-ascii?Q?ptWYdFAf30G0QlMacI/bIV2Baj1E12oo0NpNiHUHLsvy0D6d+0Ib/HiuKeR0?=
 =?us-ascii?Q?X054ZP01soRoirCkNwfeB342XGCCbFfARSshy4NvD90mnm1OYZV1FDFn7XFy?=
 =?us-ascii?Q?0HI2OX3Tl7CkrLL0PoC258vmi7zAaDmfIOkbrIxPAju8tOXAvQRi4szHrzjs?=
 =?us-ascii?Q?Z7ID1WAaa950MaspiTlLVGMOAy1ArgEl5P8htbwOcw4xbI4UBn9uYMa4DvNA?=
 =?us-ascii?Q?7ONDATOpcsjbGbqD7lUdAmzz/Lp0O0jeA3WDk4XTmXsxt+SMe5RVczJMo1kb?=
 =?us-ascii?Q?8rMLHykfVED9sg5q9ASyTsZXmIs7r6DhnRJow3orXCUv21SKPmGMVaO4sWd6?=
 =?us-ascii?Q?xfw+kai2KUeY2818fbv9Ps9oUM0HcLzIxRr2Py3593C1Oq3Y4lh6G3X6R/A3?=
 =?us-ascii?Q?q1S2npqjIIybp+O07lQSBQ/kR9G3Bz1tnBTJf9axM6choUk9UIaiEG8DkIC9?=
 =?us-ascii?Q?bVvlQbxVSRKul1RDeBk2iGM28ynDOB7v4VmN3/SiQjnI255M+ZVnecmopo1D?=
 =?us-ascii?Q?uZm1qqiWqFrxCTdtAFtwFdhm1mSlAAKY5aIEGS8WycCI3G9SjJR/UV8kbvWE?=
 =?us-ascii?Q?alAlpvh8qD9tHd+4qcNWHPV7ahBHbhFbW02BicXyrveHROOxg5W+mLyzr8ZN?=
 =?us-ascii?Q?lQcqd+ZQRLGii5DV3AREcCPFFdQlx3pelggMXRTXCZXlcut+VCE0SBbrsm42?=
 =?us-ascii?Q?Qf7iR9Ry+y8PMHVwmPAoGH4mRsEjYEjAkYC2E1cDgWHVt+Q5gvBmfa7G0rId?=
 =?us-ascii?Q?5a125Iik0wNy825aWrpHHKtkSG1VfB0vsRMmnppSPJjcOyD5+NB1bgfZzEUg?=
 =?us-ascii?Q?SMmOx9djGLzsuGYjiBaxO1W5diUBf/J7C9Qp2ofh/c7fwfCJKTZLjG9iP2hR?=
 =?us-ascii?Q?KzyLoFJGogTTswcMCAawMDGn5oCgXxYEJ4tk3vPU?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26001e9-135e-4a0a-f1ad-08dda0ad5d54
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2025 01:41:01.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iT0iHELtq80abZAeupRAsGYlvtbsd/2K8qT2Atit3dtCEpVBSNxYKT+MrOvjnuswvO5hjuLs7/n+t99KHoey1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB5679

I noticed that the Linux MegaRAID driver for SAS based RAID controllers has
the same aforementioned module parameter. Despite the potential performance
drawbacks, I suspect it would be useful with the Broadcom MPI3 Storage
Controller Driver too, to respect the default IRQ affinity.
Please let me know your thoughts.

Changes since v1 [1]
 - Addressed WARN_ON() in pci_alloc_irq_vectors_affinity()
   due to affd != NULL when smp_affinity_enable = 0
 - Avoid unnecessary complexity for a single queue

[1]: https://lore.kernel.org/lkml/20250428094141.1385188-2-atomlin@atomlin.com/

Aaron Tomlin (1):
  scsi: mpi3mr: Introduce smp_affinity_enable module parameter

 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 14 ++++++++++++--
 drivers/scsi/mpi3mr/mpi3mr_os.c | 14 +++++++++++---
 3 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.49.0

