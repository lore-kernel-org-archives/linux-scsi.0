Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79B03D3CE6;
	Mon, 31 Aug 2026 09:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169035; cv=fail; b=R6Fa5ar7n3QKrYAk8oeZTvaM0JErYlXZJaTSeSpga6rJZMtlqIB8p6dHS1JzlMpiK5qMqeJkED79OK2loYQfOyDZETOQzpG24XEGm9S7pPhdlPhKBSIb7e+saxC/cNwnbZu04o/M3ScLToNSEXm9uuW0e2uxVjKef2ce7SReHdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169035; c=relaxed/simple;
	bh=RTnCekBR4Ua8faNS/i4FP/4FozljKGh0j2+X+uyTnCU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TyijeUAextCPVAdhdb7PG05FJZwB8DMI2Lp5gXSOL4th7p7SuLDw/Oimhk0AC8dZ1G5mxwOK5NppgaT/2FbHIqlRxgxR8Ds/wlmUOq6/jILAL3cHBAZ9E/egtXKVT1qiD043OODmG37sy1WnsLsVNi9aJTRk+2biuj7gG5JAiH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=My0d1o2w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pKRU576p; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="My0d1o2w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pKRU576p"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V21kTx341120;
	Mon, 31 Aug 2026 09:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=jZBVNHdpard1zUwS
	/QsoXfAEJ31U+QGj7z5Rfe0DFoo=; b=My0d1o2w3Pc188Vbb5HeT3RI+UO+xHht
	aqVgZCf4bC2NOqIVlr5XNlLDZ/y6ASCa6mDTMUUY+Xchjo46EUy1ZLYwalRNEGQ5
	tSCTuomFT1/ERDsnEPaOn2Smd+gRpMBWN08XbbX9dZwa19/LP7OU01BvKXuoCrPM
	ySQiV+CWxsIpWFee24EkpXNDdkabc++hhwgvmcufVYhm0cuL1uzRfggRuWGGqXyh
	U4LTuVOjbRBty0E+weL3pEqScV6zGvHwdhEl+K9FNYgONHB2AoD486Vqh4VNDQ49
	uz2GeCe89i3OZ5EQicp/tAmS7XOdb6BNsdxCQ1UXXR/tImBI9rpZaQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xt6p0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 09:36:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67V9ZXio030762;
	Mon, 31 Aug 2026 09:36:29 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvnwuk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 09:36:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCvxQ4ZOlBsePVe85iY3Un/3U4mfFUFj1DwwaykKGQC4brAdK7kE+Dp8ZdqkrBrhJz5c2yVdAjS85LhNb4gJueLC2b713Z4kBP1MAw20czhv3MKLQmc23SOdAjSCAto2LHzvZMVHLMPd+s2utYObhDANB4rvuKcuwDmZcKdHuFTx0ipP/E7ExnUdyCge5YupWzG0ISNcW7KmDlS4vsZDDLZF+/c2JuWf0A3Jusg07LXcEHvHnd2qDBOM1Im9WSUxas/QW99vYeTNS8h41K3NVuk2FXVbbeK5pPrslfODDpamTuwzzmB8TzZRUS3pMiISzrtQ11tnDGsBZrN2gAmFPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZBVNHdpard1zUwS/QsoXfAEJ31U+QGj7z5Rfe0DFoo=;
 b=lwJf2uHJo0CbXNsTmSRa9EKzRFZMTaRENLNkE7nUx5/Roq3xnnyTDxL4K7jmqfv1D2kOGBPTqWeR0/X0BDnGEDmZjbmRVk/13xZpkC0jzErQnLgOdeZzNcBB+TsM/DQysYMJGaGQxrK7H3Y0ac0MpfRCIqzZ2qcEYVmo2fuy7I5XONEDkF5nxZpck5nlTlXlx84pKfur71IP9AyfAP0L/AheYx/STeTCqjspMQNA2yLZaE/8+YgLIRSHfqTaPelw9TpmraYygjxzapGpwRFN+deOl2NNp6YEutee1orJuX8UfIWN9a5N+jdFclIoZQ1G5dmgztO8+XnGuWDBvIdEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZBVNHdpard1zUwS/QsoXfAEJ31U+QGj7z5Rfe0DFoo=;
 b=pKRU576pRLnjhilPgORUCvDkHu3zGa2DHXIlSD3ceuyQCsFsk9ubvYG/0hEJ9bWVHZSE394fi71oCBSGYb72Txb/4aKOZIdFP9ZIpdu6mewFTBakwe8j14euKxQKWMX0QCEYcmwyhzPfeoVHdtSlD5xZ4WYs8qusFW5XLI7qteA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN2PR10MB4157.namprd10.prod.outlook.com (2603:10b6:208:1dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 31 Aug
 2026 09:36:26 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Mon, 31 Aug 2026
 09:36:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: robin.murphy@arm.com, joro@8bytes.org, will@kernel.org, axboe@kernel.dk,
        hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        mkp@kernel.org, m.szyprowski@samsung.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
Subject: [PATCH] dma-mapping: rename dma_opt_mapping_size()
Date: Mon, 31 Aug 2026 09:36:20 +0000
Message-ID: <20260831093620.3481337-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:610:50::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN2PR10MB4157:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ce1e9cf-bc2e-4457-3ef5-08df0743541d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|7416014|6133799003|18002099003|56012099006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	fHk4pKRN3UwqtadqnbsH7H6YtR1EHyWGHnVXkg7a/AaIrqGeQurtyZxX7Dye+GzMwGl+hAxl3ctLlcU42yJtNZGoZLxCOEE+3M95EMasjDq5hdOeONkrtMMBcJZWjYD3BqWfKzseZZ57kzvjLI3w3M+mxc6/0nO79vqz6BdR7nRDwkcckGdjCj0w15NFfGUub8vQjzuMI6JuEZqtJQbKH79SFwXbKVRs+gFsvXT0zDMeoXTJl9hFm/qeGUvVgea+U997yix9Jq/hl3VWb0jpkXdczJAV06i3R1c41wJquNouHOPOQ+IH/bhIsLwRInTkHMZpGt80fq4qs1FbHxE/y/NnKwMgcpt5sLszD/RY4fWRn7ekgne9opxgr38ez3yZnGr77CTmTyckup/iuPUZKJqGOPTn6xEsFWOWxr5UXhWNs9mwt3fR99bazZJkQpPSDq7KSE/evLiYhStphRG7cCWtB5ixoXNYMmf+K1HfkzqgwQe2d6r+g78VqKAoV2DuHK5fKRPyf5ofg3zkoYRpTpMPQiBCRMiEHADf/HpHqIkigh3i5YJDBybEj8tOyv3wRX898R2rqJAX4pBWOM4jZ64mOV3A9cSGQEZaiNbickFy+kxQz4Fuvgfh234sxiu8W4fkw6MbmbbHtwt3Z8m4EY4OjCyxtevrQRC57tOy+XA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(7416014)(6133799003)(18002099003)(56012099006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/LqjsuGmQ79qWwK8V817EQSDq9gXJBR95lNtd9nA4qHOaLXbkHQY1GPWUrCd?=
 =?us-ascii?Q?JIckP6hiGyTAM1LVw/LUA7gHi/GXgBNoBJck7WEJIfHtT2YmBETuup4MviLv?=
 =?us-ascii?Q?UrAUIRuEPRSxKq5rnXtMTwQZBeX9+GFMQ81twthPjfsKajUzFApqJdAfUWn9?=
 =?us-ascii?Q?V701VtGIdN2zLGWspgCFYisf5YLnGsoFtrnxvzGhaMb7+XXnom3KWKGb8HTo?=
 =?us-ascii?Q?QaoQeFvEC6vIsrAzuo4gzfMFXauvYwKy9pz99cneVITc/5d+27nkppcjXbSj?=
 =?us-ascii?Q?VLw3GQ6S1wJXcz+bFYZ5iLYS3/sMGmu8vmymsNst2T5B8FzKPJwbl67WQaC6?=
 =?us-ascii?Q?fsHJHJ+DdUcSfVheqNT2nwsr5laACp+IUlpgCiidDYrmw+if+OaJybsSNJCr?=
 =?us-ascii?Q?YumASGWxcHHo+lvoFR3N388Xa76QN/BYXWeWIvaPGbgk9r8EdxvDmuQsuOKO?=
 =?us-ascii?Q?sHfM2jUudQ23NYUBzcb0no0unqlvZfVkU//pCM2PcXw8MptvKkZ0ZpdQANns?=
 =?us-ascii?Q?E+YWXTl8Dw88jz7DH9LPyk9jNc04FYca57snFBdL3M+hYfkO3VBesl2huzd3?=
 =?us-ascii?Q?nQnwsAV5J3gYuuEYCo6n3na33jO0sEKgn8yufZW3KBJUuwnzJIbw8Gr9vKmF?=
 =?us-ascii?Q?/jHyXrnxt1MrREEKlyIMbw1nZshuyEpa2NnW9ukk1y02ucO2p9zD9FDLeEfR?=
 =?us-ascii?Q?tMemOzw2PqcBsTRe0Ip2RDUh5RfHUQ+zlRVfuQQd1xhbS+NO0CoWxBRr1pwO?=
 =?us-ascii?Q?HQliNiWAx2ogdWS4DzSixA2r7kG8K8FcPxcqGyeXcJEvqo8EDJDJ2q/X0u25?=
 =?us-ascii?Q?t2YgfAAJAmy06ar61XgfAiS7+h5w5xm3mX+eqIyfKE1CA1Fz9xD6b+0tx8eG?=
 =?us-ascii?Q?CFsi6gHMumhA8aywgLZJa1lSgRM+z5bw/hgaeAC7FX3Q/kjc/YJJhbA7DEX6?=
 =?us-ascii?Q?K445VsxETHAoMMrcqvx2KwBZu03Uji9V/kLPyMe9sCoY3TcmmxuyJExC+8Sr?=
 =?us-ascii?Q?hGUc8zyiBtFPH0IB7R+TpLNmxF+LEommFxhe4h5wX59958Fc63XYTtEUSYiF?=
 =?us-ascii?Q?HbNTnX7qQEAxwVUcyrMKsQMPgO2d0RLjKdZF0SNqBiYg3klie1Nyps3Gc3IW?=
 =?us-ascii?Q?uvVxlFHySFRw1ra3IpAKiFHXaQl01lxZLCW10YADtXpHcoqDvIzVDhPj+7pL?=
 =?us-ascii?Q?gVBvkcB3Uzuu7VkPCL6pNdH7rVVL8KBFtD4Vpm3SbV+4jdgYh6rkS5ASrrTw?=
 =?us-ascii?Q?EeZZxDAQF+EKtCr0cmRMOY/+Hy+GQbIVsvCpm/YiKUx7vO2AduczCzY7hRiO?=
 =?us-ascii?Q?biSodbx/2bT9eob8PEsRgtFQIyM8x3FWqlocAaGM+nIIc8uKuZLKM/PWVAEh?=
 =?us-ascii?Q?jA395HNS1IrdaSdEjNXIzB7uH7lpKiW30r6tLW0AynGvxWojlYp5Fccp033h?=
 =?us-ascii?Q?D/n+YYo2JV21U0NUzQbWzk38hDB/co1akAxQ5gy1OjhNNzw6GyrGMqpGZgYG?=
 =?us-ascii?Q?2sNGEMBONygp2yG6mIBiUSmjb7jDxwa4RDjZIVZcz+cDm86F06Wl6bGtgd8M?=
 =?us-ascii?Q?yeZD//W0n3cQ14yaJu1djcQN6L9lm7YFGR+M8v6rZWlaxMKiPmD089QXKZH/?=
 =?us-ascii?Q?XoQFisKCWMdy5pCtlZDpnk8oUuyNTSmo7yDt27g2NGwUSuhSTF3ztRjOuyVY?=
 =?us-ascii?Q?ZUAo8PvIciPRA8DT/oTgFWpvtPXI2uAug6+HI96x1P9ZRWwHpQjEuMelvvQp?=
 =?us-ascii?Q?3B5VT+kd3w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	sJI/LTRxQ8Wsj0plE4HxqoNkkGduGVirPW+m54qI2/8VxmDd0UhhOOeb+q6LFknxFP1QxrxkIECUNGyo+zZTiqKVg+mXh+fBlj5XRsOdUi5Cr5FnKPXL8ljhGegjneohvcEFFurKm4+IEinzWOJ64dlYhrk5GB2icAzUGT5oRqvFODhCGNgS2rxy+5XqeZKh/zndGQHN3msv3grpn+Csp9qBkxb8tyWmis5POEhJ0Umd3KqResESJ1giwSohCIUH7D63C3iVUEpOvZhn7zF/X62QAJRG7oAU53nX+Ofmgquza+gDUEv0VkgzYAGbzUTpMTYM6U5wnxjPqIL303FbLw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0LiarFQ6x6bKmJAUCqRnTp1RQUYGFepxrTXnX+AbaPW1GMCYY3c44fYdz64e5NQMLV3xmB+h0IgyOMWIcuHSj6569Jga6Gi55SDTfQSeE7EMPAP2OxQ4sb5LrezxdYoeMJAU0icDG3WZgeYPK8GJrNOYHZ5UzWsNJrp88jTdQHQHorw+hw1TahrMSdS0bQhaKF1Sx2mC4vrrs7yUXEloS3hyAR4T5m0maupKccFQglUeY/fZzzRTXJQS7ThyuO/5enu8ZJLJ37OS3ZG+ogFafrNjQ/+ksIA70Q3csh+06I2C8N1w9wPA9npEwocgUCrAV4elMOkjI+x7kWB+peofcRGgNBHvjUQfCbY3gng3LVCDOJMaXW6QDSQiX/13FQ/8shA3Yk7z72CMLcmRE8GhE8m8FXxYQRTiHFieBCuioFwCiq+jwWFANkFHZ96sja3nA2iuh3oRyq2aGcpgOwPSMhw0rioX6FDbdxsjrEXpj2i2Ei7luEkNxPMmgFinnzfgvuohUdl41Xeg4ecNTknjvNR76YDtLkcsBMxDsTZg/QuXBGXp4A5QMkG+15tGqfxzpLKZiRugaBr8MnY/y/2NCg6Prz8hUrXLysbroK72WJw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce1e9cf-bc2e-4457-3ef5-08df0743541d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 09:36:26.6599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZrjai1S4mzk1m5VagTw0eSDZJFf8NeXKn9lEqGzC3pl8mTzXZ6Rs29bmlXGD4RK6+8PnmxKPqE1z1kZMmyxMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608310082
X-Proofpoint-ORIG-GUID: T-nH6IXxyaYLHlNJuKIHtoWzSAKtC0kB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA4MiBTYWx0ZWRfX7J6GfoUZx3Ga
 P+0dx37Bk0hHijGlRiDT+jqHE5uANhUDDPQZXkvcA7PiQ5x0vKjKdaRwQBAEmRhuICQ8RCKKXHc
 ZlRKHS6F/QYHe+S1VUjRPQvqpW8Qz+5wI+KZvCyOTTcdsV9meyooH3OjkVKD9hUPg3M+lMmYDIe
 AjgOfZd6Tr8vZFbT3jXhr49Utir1EdZBMislLtXlQfI+FCjAJDyP5ApCaNZMyAJftWHmGPBJL5e
 kTYIGlkrzeDNP6cGS6uhsfadLWsZJmaxjiubeJCKZI3VbmoZPu8zIfp9IGbpj92jzfazuUDpyzA
 THZAP+Q4u0Z1mygewGWbsjTU6dnCPwByQ4O5GtC4pI1xcttKgCvCQA8aVOdvHpDN0Y/t9MR6TNN
 Sv8iakUdLGR3/ZIeHyghEPIY2vtkSGa/ZIYQZNhO5llK6SKFMTlV52GaCx+v10NFDR+dhdnokQj
 eRDYTLbjvWjgfEhjN5gJHxrnjPN3jdr9BXjPpy6w=
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a954b1e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=qdfyvraTH508eo7UlpMA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: T-nH6IXxyaYLHlNJuKIHtoWzSAKtC0kB
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA4MiBTYWx0ZWRfX5HDn4+md7FmQ
 YPDwxRn1WS5v3B5Ewciwoviyz50Lq8mliAb58Da0bZvOeo82YAmsOJmXJelV+hs6VJk2PYOofZP
 GKYpm+UEBt7hD3WJN6Oa9OAV6ewjTQiz6Knke5/XY4Oul54mhs2/

From: John Garry <john.garry@linux.dev>

Function dma_opt_mapping_size() implies from its name that it returns a
target or sweet spot DMA mapping size. However, it is just an upper limit
optimal DMA mapping size. Above this size, DMA mapping performance may
significantly degrade.

Rename to dma_max_opt_mapping_size() to reflect the real behaviour. Also
rename the internal DMA mapping symbols to align with this.

The DMA API documentation already described this behaviour properly (so
there is nothing to update).

Signed-off-by: John Garry <john.garry@linux.dev>

diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
index ba23a472f7948..69d4ebe4f96db 100644
--- a/Documentation/core-api/dma-api.rst
+++ b/Documentation/core-api/dma-api.rst
@@ -154,7 +154,7 @@ others should not be larger than the returned value.
 ::
 
 	size_t
-	dma_opt_mapping_size(struct device *dev);
+	dma_max_opt_mapping_size(struct device *dev);
 
 Returns the maximum optimal size of a mapping for the device.
 
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 58c624513cd43..1b26c9ce4aabe 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1762,7 +1762,7 @@ unsigned long iommu_dma_get_merge_boundary(struct device *dev)
 	return (1UL << __ffs(domain->pgsize_bitmap)) - 1;
 }
 
-size_t iommu_dma_opt_mapping_size(void)
+size_t iommu_dma_max_opt_mapping_size(void)
 {
 	return iova_rcache_range();
 }
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index da93b505d2394..d87d268037d81 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3747,7 +3747,7 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 	 */
 	dev->ctrl.max_hw_sectors = min_t(u32,
 			NVME_MAX_BYTES >> SECTOR_SHIFT,
-			dma_opt_mapping_size(&pdev->dev) >> 9);
+			dma_max_opt_mapping_size(&pdev->dev) >> SECTOR_SHIFT);
 	dev->ctrl.max_segments = NVME_MAX_SEGS;
 	dev->ctrl.max_integrity_segments = 1;
 	return dev;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index d689b9ed08a6c..aaa47552a215c 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -223,8 +223,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 /*
  * Set shost->opt_sectors from the DMA optimal mapping size, but only
- * when dma_opt_mapping_size() is strictly less than dma_max_mapping_size(),
- * indicating a genuine optimization hint from an IOMMU or DMA backend.
+ * when dma_max_opt_mapping_size() is strictly less than
+ * dma_max_mapping_size(), indicating a genuine optimization hint.
  * When the two are equal (e.g. IOMMU disabled / passthrough), no real
  * hint exists, so leave opt_sectors at 0 to avoid bogus optimal_io_size
  * values that break filesystem geometry (e.g. mkfs.xfs stripe alignment).
@@ -232,16 +232,16 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
 {
 	struct device *dma_dev = shost->dma_dev;
-	size_t opt = dma_opt_mapping_size(dma_dev);
+	size_t max_opt = dma_max_opt_mapping_size(dma_dev);
 	size_t max = dma_max_mapping_size(dma_dev);
 	unsigned int opt_sectors;
 
-	/* opt >= max means no real hint was provided by the DMA layer */
-	if (opt >= max)
+	/* max_opt >= max means no real hint was provided by the DMA layer */
+	if (max_opt >= max)
 		return;
 
 	/* Clamp to max_sectors to avoid overflow in sector arithmetic */
-	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
+	opt_sectors = min_t(unsigned int, max_opt >> SECTOR_SHIFT,
 			    shost->max_sectors);
 
 	/* Guard against zero before rounddown_pow_of_two() */
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 8fae2b7deb20d..eee6de5188c76 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -60,7 +60,7 @@ struct dma_map_ops {
 	int (*dma_supported)(struct device *dev, u64 mask);
 	u64 (*get_required_mask)(struct device *dev);
 	size_t (*max_mapping_size)(struct device *dev);
-	size_t (*opt_mapping_size)(void);
+	size_t (*max_opt_mapping_size)(void);
 	unsigned long (*get_merge_boundary)(struct device *dev);
 };
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a3e880649fa41..efde0e5a58dc2 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -207,7 +207,7 @@ int dma_set_coherent_mask(struct device *dev, u64 mask);
 u64 dma_get_required_mask(struct device *dev);
 bool dma_addressing_limited(struct device *dev);
 size_t dma_max_mapping_size(struct device *dev);
-size_t dma_opt_mapping_size(struct device *dev);
+size_t dma_max_opt_mapping_size(struct device *dev);
 unsigned long dma_get_merge_boundary(struct device *dev);
 struct sg_table *dma_alloc_noncontiguous(struct device *dev, size_t size,
 		enum dma_data_direction dir, gfp_t gfp, unsigned long attrs);
@@ -326,7 +326,7 @@ static inline size_t dma_max_mapping_size(struct device *dev)
 {
 	return 0;
 }
-static inline size_t dma_opt_mapping_size(struct device *dev)
+static inline size_t dma_max_opt_mapping_size(struct device *dev)
 {
 	return 0;
 }
diff --git a/include/linux/iommu-dma.h b/include/linux/iommu-dma.h
index 060f6e23ab3c8..fae5d50e4f277 100644
--- a/include/linux/iommu-dma.h
+++ b/include/linux/iommu-dma.h
@@ -39,7 +39,7 @@ int iommu_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
 unsigned long iommu_dma_get_merge_boundary(struct device *dev);
-size_t iommu_dma_opt_mapping_size(void);
+size_t iommu_dma_max_opt_mapping_size(void);
 size_t iommu_dma_max_mapping_size(struct device *dev);
 void iommu_dma_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t handle, unsigned long attrs);
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index bf2651a70b7c2..82e701648d604 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -1012,19 +1012,19 @@ size_t dma_max_mapping_size(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dma_max_mapping_size);
 
-size_t dma_opt_mapping_size(struct device *dev)
+size_t dma_max_opt_mapping_size(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	size_t size = SIZE_MAX;
 
 	if (use_dma_iommu(dev))
-		size = iommu_dma_opt_mapping_size();
-	else if (ops && ops->opt_mapping_size)
-		size = ops->opt_mapping_size();
+		size = iommu_dma_max_opt_mapping_size();
+	else if (ops && ops->max_opt_mapping_size)
+		size = ops->max_opt_mapping_size();
 
 	return min(dma_max_mapping_size(dev), size);
 }
-EXPORT_SYMBOL_GPL(dma_opt_mapping_size);
+EXPORT_SYMBOL_GPL(dma_max_opt_mapping_size);
 
 unsigned long dma_get_merge_boundary(struct device *dev)
 {
-- 
2.43.7

