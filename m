Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672F542BC4F;
	Thu, 23 Jul 2026 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799444; cv=fail; b=E6xl91F7ru45k+bvsm4vCtQURi4uKEwfMDc+RDfQsUyK8BqrzSlUV57r3ueX7Yh9ALWusBp4s7mg4pcuQ20oyY1Yig8foRNY7cnJea3FifiN035kSIr0ZzT33aj/1AGunPcpK9BftWTBDM2zrt9tvGnNiYEIs+1j8WVJoXojKbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799444; c=relaxed/simple;
	bh=JY9hNY3Yvoh2k6SiTbkTZmWu8/dwmL1QyhYZespDdKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TsNJMZghQkmzHc3t8rEmIFvEQ+sTtQft/yZwM9m2PQNjDCdzIHePgNhSpPCff1Z5hxsm7pgR4fwB5YZdLe7hgcPEU2jtNX8iordZiE+3okhk9srfeJdVJbVAkg0xXJIPG3pLuLhToS6k9sma/w7vcH4fZAWGpUfSBBsPKM4kIMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=drECQGNs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gI4x756l; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="drECQGNs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gI4x756l"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJthu03404240;
	Thu, 23 Jul 2026 09:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9eqajpk4+3ws8bxcDBFm5ZwUraG8nNOzrwN0wwelu5o=; b=
	drECQGNsBjRzlHu55E03gUHzRy8ii8KcsVzF0ifAe+V3Z0hKdEMfjEdz7txWh+re
	yBqI8UpZ6dvbv78HxDcJIK9pcfI6QLC8UhPccn/4YVLLr5VNizFX1FE9XBzAe8/p
	5nyzYn89aaqb6uWhdfcv8KahzCDk+cDO4vpl0zHEk+1Cwoq6Tz1M/VcvZM4jkODJ
	gzT58eI9MxBIGJaWcE/LefOOYOawKjOyDeJZnK9YxbPXfQxbo3WAm1c26qDKGJp+
	3XVXrGK4VfKqIPZ9hmPgr1LSTPH/GLn3/DF1jWPmOFRj6Fwf/fglVcF/piltk70w
	QIUClfsYfwz3MgUF74YUfw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3pmps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9SB021175;
	Thu, 23 Jul 2026 09:37:05 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y43e-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cfLDQLEQRgPyx6QTqteo9RcV60WGl2jxS7PrT+ZwsZUAGq6zBQAFoqYr5GB2/dCdPB8v9b0l3HB4QsmtjaWteGQZPfPOBln0i+yTA8ZhW3h0UDQTYEyuWdqPDNTQhahSvJf9Paur2W8j28dAToHNXn4pmgjxSxocFk7aLTC1NKuK9hjeD6/5xVUZpgeFrrCTZnAg+EirPxosJAYMRTRRCgKtNTj6wFKkRzNjydepdrdnhwSzRirVi4Pj2NmpeVAVhYWQ/ZCOPswlhS0FJ2Qa2F/LYLgNzakDOUVLa4XyGmKqHGUdXzl3XjW+0Oh/CajuFQZyvGXJOYCUuCjbfDiG5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eqajpk4+3ws8bxcDBFm5ZwUraG8nNOzrwN0wwelu5o=;
 b=QoOT6EXAyfedRUzPinnN2J0mxiY5aozBA3mCTcQ83vmUXDr68tcxnJvLTxQKVzy1g5ZK/T/+Wj0ALVKvPrr5k5+70w6xVU7J+hBZEhCztTZ0AYz8I4FHLqgLCi2lpUgM2Z3lH1cQKUo/GlHDPQV1KIcEaZBBIXL/ksGK8NXtMk8cZQH/FLUYLwsRsEqEoo9enmObGfXcXW3zuXceoKxg8Adz6j4qcc06EKSZXQ9Dmxw15c1mhPgfTbUiD74e9LUB3WRESuvvk7P0aMto3qCl5OTk2NmZ/lY3it+k60FRZxrsKw97n6r3KKYAdd62ozOgJb5jq1JbawEwwC2eBDMb5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eqajpk4+3ws8bxcDBFm5ZwUraG8nNOzrwN0wwelu5o=;
 b=gI4x756lm02+HcHGLXQR9PrJHqZGxzjdHDVA86KDpULKVuN0L2B38ztI2FVmfwvPmN4BtMX6ig21wtb3gtKJdcr3jkk+Hu6QMXXxJJFxlv+7ayK/eOvLmKMDVks0EC5atVXrHxj6kbaO3GdZNFrqhwC2U2OX4Nqrq37lMnPPXgE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:37:01 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 08/28] libmultipath: Add mpath_bdev_report_zones()
Date: Thu, 23 Jul 2026 09:36:06 +0000
Message-ID: <20260723093627.2327456-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:610:50::31) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: b3c4e19a-03ea-4207-5771-08dee89df25b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1BIiFxmrbD+W/wauKL8GaxXuxIuLzHSY4YVh4cK57ex7D/q0lPuHb98Q26hFw8J8aAEz0rasLBK2wn5CyGQR4x/fhFL1fjS8B7CdWX3f0gBMKtAx/Ju0zN/E+XDo88La7Lr8dUS/4gB3HMeaLj4V0m4vqC2y01gy/TYcrq/2Vei54SrEtL9mxa18IZ5dJYOCnt/1mtmeoltq/Rv8QHKny0ER9Lngm/i/w5wSIicyPxtPtzIk1fJyiz4BOFbDBavpbVjvxgJ8MRVuAIiHOGrcz2+27T9mmX+Soow7N9ULsJzokZBw1JrpTWSu0sCBKICNGRYbO+2NNMmox438ss1FpkbkFAdOchC71WW+mkGEDLALuuh8Gv7ROafgOSt92J5c2CMaESsmE6qw/7cCr/BObA8jcV7jyVaImkpSabZS7T5C6fBFCRhZYeLUEKQWzVYPUzJsVmZEWHN5+dnPN8hffH26JSLfX4uOuEGpRM4GKhGTASksC+RWkmeIu5O8q/f/7qRheWnzXuR+jbMQZKNAJwQ9cN/KmjIP5Q8QUx5ydvAZ69wrMzRMPG2HGIQPj/7+/raVN/BllMlgKZ2y5BE3WLxl2xrHrx/lwnx0ZcNaBNpRiwe7KIqwy3RNhXed0uTsJTpzyHKoSnfoN2C67LNkp7InEdgXiJjqdkpo3JHN9sY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MjDrE2FCl0id6YWzPwhrJFA0TtvuEO0pY4pGuisXQ2rhlYLEWnzeXx4gictr?=
 =?us-ascii?Q?gbXCAegOfGuxGZ2ORswW6zddhqgP5eAuBjcUi9XdCC8NdQgw1ZOgAojfKHiB?=
 =?us-ascii?Q?YRx5MLiCwSGth9fTj84gXkv+f3fnfLcQdI/5J5JT3aAlVmyRXaSlAV69K371?=
 =?us-ascii?Q?ZD2sBJc126DMyYBGAKtf9DA8pXYzzrZde4aEvpw469su4GeXfsDKdJydPO5e?=
 =?us-ascii?Q?Hug25vLPfiOyczcX9pARM0OD0WirnUZQCDvu/li57Mefek7cR6NCL5Bur1VR?=
 =?us-ascii?Q?0cPlXNZRiwZzPzZVj28s4+X2Jv2yYLbezqsRuT9SaA1dpp7drBqt0sLOaLQh?=
 =?us-ascii?Q?gCaBRdhjF/O6seGCcsxAjTV5K09OobOqTuWHWBZNmKYlUDVPJ4MnGNsr1Kni?=
 =?us-ascii?Q?p49CEFZpJVTURYVSzejIOePdizdxFxczP5npcfSJ/gGOLcG6XMSdVqxsVo3y?=
 =?us-ascii?Q?oR5N+8/wV9y5M3/CHCjAHcDKqawGKsEIS+p+Q2ww2T4rTQzU43wIGAfmg1AE?=
 =?us-ascii?Q?tGG16QE0muGicjaeal1H9UyJfuJZgXbFGWhfAoovu0g7ad4yrqBTRRcurvCS?=
 =?us-ascii?Q?pzm+uuCTcnyO3HNaBh1kY9zNik0mMhi0MflwFRH0uZMAOZVWawzayefKCnUJ?=
 =?us-ascii?Q?4yQFYIlu5Ev5BsIXmtYyoqsZQOfEjtLsNshrBvJ9i5duUMivgrZea4xThu/5?=
 =?us-ascii?Q?SBaNhbJ8vxvAawW3NzUDOnHNrGVH0Z4s1Vg12Qyzrm1OM48jwLUYo5hLZdQ2?=
 =?us-ascii?Q?iSenVNnj4jvT6dUwCtkJ1ebj915Z0QllLMyTB/vTDRj+wj0T2IeJatFk2opY?=
 =?us-ascii?Q?8v7Atss60+PxliHQ0T42l+89UcXECAsQa2zDrBkfT2h6hF+c0YtOKc6ae1br?=
 =?us-ascii?Q?ywhbdPCzM1XTWw0JSnfouel6ssU9iaCQfdgU6HIrwqnQJMvFSFJ0SSZ9o5uW?=
 =?us-ascii?Q?WUgGhhg6LO4aN7Z9ecRk4r6l+4Hwgt8oNW4luM1VVFYMoPoSpH5qzDDbOpBb?=
 =?us-ascii?Q?OLHc5zwE/xqpgGibS9ErGcSsac0BwE0FjgjOkBta5aQJo5Hrm3LzRLtifk+1?=
 =?us-ascii?Q?sVORX83PYF4AxhHmN4Iu1VrxZARq6Jgk/oUDr3W4C1+zvXxnypRL1LZprl9B?=
 =?us-ascii?Q?+9/AICOMKBKN2j6zyjW4HB8cvayyzXPcTf1enpfiBLyep+Sugw9k/vkEwoSy?=
 =?us-ascii?Q?KOSJ0O9oQNiip3KQxbwKOkomRNdsV7DA1UYeSXrJP9Zz1eWyrPShQx4z/7Rv?=
 =?us-ascii?Q?ydBYTc6Pje3YmNbuJSNKb4ovfxDgcikI8PD7cseyf7mtxSHqTLeRhN/SzzPq?=
 =?us-ascii?Q?/nGuP8Dk/bPoWqiSFc+/5AasZmWic9iEA98VnUgZqaQ2gKQXzl0veP2WgPMG?=
 =?us-ascii?Q?NxdErTDZG19Lz4nRpOQXQ47zmMb+JvqO0SO5PGuR5UlwWVCw0nH8EJR/Y2eY?=
 =?us-ascii?Q?k05xArbnuWdZdwwxPWmmz5g23z4uIzaS3PjZAbrKjUWb+qnqtgllHiZaTw/C?=
 =?us-ascii?Q?JhM6uEhq9/ERAHMI2VDEJMu9unBQNm9mlOGxeynrIpUtUX8JJXZJ8oZoCWj+?=
 =?us-ascii?Q?GOwjibsKVzNcwigtAUE3nRXibG3FC1ZBw+vdrd0TTIteKO0GdkVUlas5t/dQ?=
 =?us-ascii?Q?LU+/i08GJhOFQQbujC+3yL9kLTZHBNDep4Ew3p4CUYGeZvA3SqZZBY58Jr+r?=
 =?us-ascii?Q?K3TJgKaEsIdjqk44CHMFz8b4vyHzCLFOKttk247mZO0UCI33wiMju4FVggsr?=
 =?us-ascii?Q?IxmDNKC2xQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	rAJgzUgi+qp2183DHD9wiadRalTevucxYEh8l8+C+DQulz2hPMbzx1NaTg92RjNSSERrkrZh27X70ariJmLu4VUA0w2I/76WIfzPMmXocLFPyplTd2734jINV807KjCCpWYKIUmJydI27wtHHSM+psliDvODY9lYiu0RY/wcywnbmOwQl6+gZJ/VEeF5wEkRrC2vjaFdBYv1nlK8dKVXjZ16cyn6cmF+JzoW2/UDTGQQDIJN41dBwUK/TWCTv0/hku3tulRig8bp287zy+VELoA147AdvFliKDs3GlxJY+X+EP3qsUKmobRrQteqDGcR41N9a67CtdGHmq1L50rIMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D5RwVkumI+szki0PVYQz6gHiy6XZVmUeL3Cb2PwT5/eXRdrdyupPw6Za4n3rHfhxsIrV9pDKz0Ud8FoHq4bW82Qo0JETqsHlAQsPD7qPhbQaMHTtCLxL/gTe8pcPawq1T92PL/bpMwPEobKh0DoXUOqWoUsN4KURNowmX6kMMG68W5XjAixDpceXaqE8W5NfGGHprs5l2XVvroIIVuRz8I53G/OEbPo3C6/Wuj/yZIrbiv0MA0Wi3zHPIShraVYaBlUtVsZoNnfhWA5GcQIujcTprRh1b6nTMyoc89M5rxveXFZA+CF2vMHIAUvQahIcHUtinG7XLG5f3zqQ907WWkM014is6ui1EU+N7VGs9ERh9b20x2gvNKlf59kQLffu9hNQUh+GA8URWZ6UIZDogDDaBoIRMEDLvlJiQzIRNQnFsSB1QNXiLe+Y6pTUs0eAZ/5TPwDPZcFRugCdLgtIaRtTKAsE2nBx5IG5G7Q87It/sZ5q2qUtvIyKqiVA+IPamuHQTe5897VBSLC5sIVsgCmNV9k6QVpzBCTi7iH0Kh9q3m0ebSQ/cRWLNpKAXRCb13U+Cd2P+pPHmEqaLDXLc10FyRlyfQ4MIYuu/HwTNQY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c4e19a-03ea-4207-5771-08dee89df25b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:00.9070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYEtYDADiIOq6c4GqiePK9Mf+bNgk72Hu2cDgQzi1Sxe1TSJjtetysZk/zlbLpN30VcM7wUF6BoVp8KV7sEhsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-GUID: kl6xyYDi3rm_hlMjDMe0OoZeT9S09zgk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX6aHOpGdX3ZtT
 dWHW2ZsIXGnq0izP2WMH+LrgpTDr2+jmOzRfKKvfIaDzJoDAMOk/xJv5E9sqae3dxdBaZyunX86
 uJvzR82QXLZ1quvTZIW/vo9i82NGK+aJ97y/ZMI3nJtrck9RcN24
X-Proofpoint-ORIG-GUID: kl6xyYDi3rm_hlMjDMe0OoZeT9S09zgk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXzG6UOBGMhDoo
 wLMIO3UY68gGb2HSDUTAIkK0WthcBzE3HsnuLq5kQb4JctXhltpLwpEq6e67ZbJeIsDRrswsu1L
 NwmJMZjOcoNaoGsquioUeXCZ9zefyR0IezO7SxAMM7q83kqlTHm2Gy+eQ768vWv2FZKEAqMwSZl
 dznk+RSCcOpn0kw1++GFJaxvK3NE1J9tBQbAYgG7RujCec5Tko6sjf7hQB2ZXiUWl4eGq5hUSJF
 j0+qZTPod3+8nR23SQqe7WLZq0cTkV45vnDsYomaNOvVHiNdDwN7P4TUV1EljKerPfmrLMfA3tM
 KXkdhR12dLkzM1d27Y1ghoBGziiFIVOCpuCo4KG4vsIUIH3HTxgnxFE+5+Ub6kSn1XBa5V2wbYz
 c0xcm2/vIX4NMAqNlvX1nUDovPDiDty3LuZEpBbok0i6PGheJBDabYYu8LDWH+VNqjxdi0p2vIZ
 KKEttdZzgqE2iPm5dgg==
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a61e0c3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=hSvAkUGrqjTGy68UynwA:9

From: John Garry <john.garry@linux.dev>

Add a multipath handler for block_device_operations.report_zones

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 3ff4f42a096c2..0232f51f64742 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -44,6 +44,30 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static int mpath_bdev_report_zones(struct gendisk *disk, sector_t sector,
+		unsigned int nr_zones, struct blk_report_zones_args *args)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->report_zones)
+			ret = mpath_device->disk->fops->report_zones
+				(mpath_device->disk, sector, nr_zones, args);
+		else
+			ret = -EOPNOTSUPP;
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return ret;
+}
+#else
+#define mpath_bdev_report_zones	NULL
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -459,6 +483,7 @@ const struct block_device_operations mpath_ops = {
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.report_zones	= mpath_bdev_report_zones,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

