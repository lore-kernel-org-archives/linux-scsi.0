Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B3F429CD5;
	Thu, 23 Jul 2026 09:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799443; cv=fail; b=V487P6SQd1JmunM0bhg5bnd1rCZlYm2fIvMqc9z5Xcv/jRRRTlGNaXFov4Zk6Y5ckX6NnaDV7l4rBg7GTfA1IV6gqMPQyAmdiO4Sw+QPjmnXEU8N4Rbif/4AuDhi42KeIAQdntekTJap9I4CNjnqaJxuB1Tnv2S9y+snFyr+p6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799443; c=relaxed/simple;
	bh=YUKyICC1sHX5maFRnxZDzwyMFnZ0soZxI0ynjNWsvlY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SVRnYvh8i3ahw0fjRcfz1+XiaREwVMxVCVmDecBQvjLy+NrUUgvOcTuZ1AgMuRskNj3kJKvCX97P0MksGENGQgeBJMir4mB93PZHb7TBaFhhpC/tEA1ttllEqJyTD+TJKG+fFL1jyZNv3wWucMRm0u1DEIZK49tu7Rlqpjr/HA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SLLCd5YN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n5+0sjOb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SLLCd5YN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n5+0sjOb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtcT03353523;
	Thu, 23 Jul 2026 09:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=sl9AXHp+RntrYc2Y
	ibe6jGvnVi1dTeRkBNi36Mbqw/o=; b=SLLCd5YNI/aVvWtctMsFDONkYiPPz8Wo
	vwl8jF3dja8RpppCppgzcDvyjE0OCOfW1ImD5bRIR7852GMUWgflCGyrtuo1CAy6
	KBojbKHIiNja09AcPcFZiXFQ952RLxtcy/CqEaDsHetpDxL6i5ixS8lhFRm24/HG
	xcJAssql78qZV7r7/x5rZMqlCH5yPwYg55M6vuau62RZTeWS2+62LfT23lTwaHYz
	pwpKtwDGvhcjNtQsJXecSfO+5Zx8BIc2Uq0vGPIQe5hG+RWfnAUzetNG2vfvmIW6
	CIorY7zqhIbpCQfW0Znw1VYNy/rM2nfcpGuOhKl/Z8qL1K+jKBqPKA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6kn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:36:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XA6O021265;
	Thu, 23 Jul 2026 09:36:53 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y3vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:36:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A/fTDJm92e5z4wQal4rXO4INbMNk9npcMTyd6t602BJLZ7q5djZlQFsaggymoswZ5VmrA4ZzGQITl7JHEPxQJ6QrrobjPXo6kEOcE/vi3ieccKb/YLkX4ZsrDC3++a8vNy4zpPDOHTSo7gC5vo1dhC8rAL3j/gMjC9BUs88qhSrVqPQY4oTIq+6VRtDzFIC7IGmNaS9RgTdxO49xZv5ti2ETWqIx8Lc3++LkTdqtFMq0si+i5iDGhLklS8BJVg9jbLAAoBJMVhJUCBtJLRq7Z2/4ylMNiUJJ9TxXKvZcff8vaJgQ6V5GdoE0sFVR2S8JlN8u+SBsl+42e3zxZf/H1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sl9AXHp+RntrYc2Yibe6jGvnVi1dTeRkBNi36Mbqw/o=;
 b=lkZYoQzwTdZ8PsTQsZsp+Z5fQxORpR8NtFmgA2AnzCqinGIxU1peSnuGtS4tUqZPVeE4eOE7Go6MXEZnwAvk72ZFZkGRSzhDt7SMhXKGVZldvww7nmnnxm111rjZcNiwpLDiOZEDeprTdkBaS4MdmSS3mKtZ1LrX27VTcPY1OyhtmNYZnkOzyUpiZq1ang2TB9oyREZsg2dvCMgzl7ML8vgdbiKVxUARL42i1YA4r1JiOWRLhWyfakTyocg0zttzql0tVQ4wxAm2L9v6NgxTu8et0fNEdooPEsP59GSxHu4M9YvJ8e3O8oYCXI/+Jc4HOSp5fyqDHWdIhJjVpugKcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl9AXHp+RntrYc2Yibe6jGvnVi1dTeRkBNi36Mbqw/o=;
 b=n5+0sjObNl0ymg4Mc61JfBQ4rW3pINcqXIQFmJ74T0e9qRpmDm8KjR9cNPsppPB+Mn6ot8DNul1pNOcdFas2tvLuHLFIKoyV3/6mMsGijxmz/rbylHQNCyt4FhuNRGnW7c/ob3FgDmIs5DihbjhA/GwgjjDV30EwF+hP75HAzvU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:47 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:47 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 00/28] Native SCSI Multipath support
Date: Thu, 23 Jul 2026 09:35:58 +0000
Message-ID: <20260723093627.2327456-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: ae9cce7c-2d7d-46ee-2683-08dee89dea23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|18002099003|10067099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	/GCrtbqI9yFA1EzFR92Cy0V8rn27kSghnMbaxriLgBjg/1Lu+6kbI4Fk2SYtX6RAXpt+FpnMaa8Ai8pCphIry7e8WYZSF6o6onUH3v8kZ0GM1EPZ7T7hWJtXRlgShNGWoamhslLVD6uORdF3MvlGzIk7vBkgR/LdZFl29R1gfk6VWBpoUDhnzqHKVc1JXZiSb2m/YbSjcQg7OtaD+96wBgnErSJLtTfpUN62uEqFO06zRZ9NN9NrYHfG1idxauP4VNPNTjSx9gmFut02Imu9ukNfjLeTm+yStn9j+5yC4aFilpcTuN45/B4RXANqxJUFVBRBR2yrFF3lHJ1SQ+WY+T8y39yCCaIab/4k95FHzVNN7WW4DA294WF+K+V1hEhjwL4E7Z+Vp4YC29ymJRBGErQiPiFq0McRb2dzpAfNkKM5aln41GwnZHWjRQrrOCmTvW6NTih1f6quU9AisKShxuitp7PY6cEzFjVHh48hj7HCZlLZGy+dqCV0bR8oGPqwR7uJHoOzSIKiofafbqni7x11IsY691QuJxU1pY9in0Pp8MMOcnwo+dhT/zTC1rjr2+I7TzH39oybH8C5abKZk5naSfH3zpfmOe77DjbQ2zGrP8C254/kFaSlhVdhu6cnrR4MxpXTJs0LrKD8YyrJi0mHCQrAd3AR4aO4Bf0zY7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(18002099003)(10067099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1wUum7+BE/hOtxiQJG5mngMSW1Kb0Y8wSZCDnl6gFjaq+Ah0sn39cx5MHAcK?=
 =?us-ascii?Q?thgw6Q9doVZYdtaNyGDy+vYqPArq2kutWvE9keUgvKPPdUYT3ktMD1D6yAbr?=
 =?us-ascii?Q?oY0C7p+99EET5HiWd1If/h/i6IIB+xAkKonA3p6JT4enGpMcPJur8pA1V6VX?=
 =?us-ascii?Q?EiO2wM/YfIIDzClpcLM0Qtc6NDEJ/IV9TzH/4gMjNQe2aBBW4G7HdPNnyXEf?=
 =?us-ascii?Q?mr7kpsO00jy8Ku33Pv0Zgbdv0EkDpdTSWhovauI9HMCtslReLokLx1kzht0E?=
 =?us-ascii?Q?3v8h5QvlbClzy7eaFSJSp9vFAGiYX9TTVXYVu9amO7dk99T3GdUWczN+cono?=
 =?us-ascii?Q?iTlR+eIqxlwYSjg5pmt1PEpMtLIcfWooQQda4y5MvGmNkylb9KJFDDgKwc4X?=
 =?us-ascii?Q?gC13CIsFGGC2VOVSShOchXzLBDejW+bt+5TfcCn3qKY2P/imx8RlT+CFy19Z?=
 =?us-ascii?Q?j3tNWH4RgUl8oB+u1mSk02n+yl6fsHB6cSE4IIt+wYXi6kUz9VcCgHPd8cjl?=
 =?us-ascii?Q?zUl3C09sHBHAEcOCyMe8cNJJw/yFPkjvb9nC/SbNR4y30VP3B/uOHpHoEact?=
 =?us-ascii?Q?uAVK/LlIWmbab9fgetq9XLdLQGtESX3YENeTrIuwa6Nd1RNKy+bWmT3TYSr2?=
 =?us-ascii?Q?d1A8h1mK+J6qlFOmQm2m5GiLVxSBzhJQJqUx5sX0p6XzZwP5d3Mwr6PRvJUc?=
 =?us-ascii?Q?YYkmqggVVfqWECKJyl0nVbzv21eVGo39TV32G1brbD0E8JB+EyGECRurMsKQ?=
 =?us-ascii?Q?lE6mNreiP7sCA6KmMQb4WD/NIBw09uHxzUbiJi3sXrkpjIQJXuJ5kWmA9l5j?=
 =?us-ascii?Q?LFBgjQ1Xl0VKFFNpOhVfptY4T30Q7nYN8UKLQ8CS1xvvrUflJ/vEv76ayRxo?=
 =?us-ascii?Q?i0Z345WAqixnjxR1gFxFiAKwX79Q27+fcPwY4rtflwKbiuGHsJ2e5idd6PcM?=
 =?us-ascii?Q?yqH+jwoj64BuHKVcc1JdPNg1ZFyweqmOwe+dZZkyaUlWj719BHMI6pbU2dlT?=
 =?us-ascii?Q?MCUANQXJ5wgYzOa+zEBljaOrlolxWEGtsHyZ49Inj6gx2Krtw/pQqGB9g/Gy?=
 =?us-ascii?Q?k1dBJ9uh1Oo+xxiDbWstsuGjPOEhCJ6hPqRPCapKYd/cucWAlaepNxNK6PsL?=
 =?us-ascii?Q?1OBKx/QtFm5Gd18Su8KXrmT8fuZBKTzQcX1cOegjLWuvJbZRPtEXWaSrG+IY?=
 =?us-ascii?Q?dFGKrFOQt2DWTzBoU1ieTI+LFMZOfyLfzJj2BGPQTY06z2r+rYnWlP/Ef8a4?=
 =?us-ascii?Q?hfPrBZiT5Z3lSgLTXPmmvyTK/2VmWepQyOG0MgXULZq9GVqcIKz/F6PC+g16?=
 =?us-ascii?Q?JBT8hicRul3A98SFIsCkUJtF/mIWlY1dKQZEIsFcqhVJjRAv/lf8NzUklZrC?=
 =?us-ascii?Q?qNpQcAg/eFg3qrWiwRPcMpI9JdGiDLCHSfCQC5/k/tQOK35y/3iGsk+VH7ux?=
 =?us-ascii?Q?wizpIggM/j7m1bYIvfNwlA/0io+kq3/il7T5UeYCgbfYGD9qbs7hJT7NDyhM?=
 =?us-ascii?Q?sAscpDcqjXCFgTuqLKdSgWMkjnMolIMS+l6VZGF2G0HmO/owaB7M/TQYoiFU?=
 =?us-ascii?Q?g+pJD7O9qpGiNTYgYU1IpkiKoCE0L95M8sMYDgMCl91B1dBPzYqLrIbDMmiY?=
 =?us-ascii?Q?tFE8ltYnbb0506mqEqpTKdRlmTRT+LGZkjebzWePxqPOMTKVudutIAP5Toa9?=
 =?us-ascii?Q?vlGWTDR0uTakysQDu47f6ATg5EQ05WIA1RkXagh/d/fKCYjn2et67dpNQwSb?=
 =?us-ascii?Q?N2ZO64vWVw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	BMkR72okvh96sqC5fMDeihRwKbArkuBS26X5aQfK8PqbuU3xLxP5fRfzYd2VdKXy6nwxSx6Y/z98PTTQvlJmyW52SHiQhh1zWbVahGDJW0C4ogNmGWPfOJR9trvp+yRPDwjnnVlLIOuiHkG9detijiSVu4jB2utoMk8Hygw0dAVh0mHJ8DIWBg7fuchPgxJqf+WvyH48qinLCSKPWSGFurO6Xymnf0kLZiMy2kWewnePzzlpAWgz1e6Wzs7FmPfBMomUkUvA2iJDWl2i4pQ0Bj5Gxnul3/zE08XA5a7wlEKvvxhB6+O+prLKoO9qqetajtBqCQXbpu9aTLO/WkE0sw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x0plAqZtDRa7CJJcPkaBI8KvbMJyYUMb4s8ZSJ3trvUf9J5wzHAjn4PkKW/FkbC/fa3rx7UiB6eO2tcoqOFbEeJ3Jb5fifsPpS/S/PLmFu69yci+omVT7PKtIl4sAPPpdNGecYvUTuYNhtkbBL5vBVBYzAFRN6vw1FzhnztcBBJV+P3oY8nimG5auLc20zlyJpQoHPvYFrnveGT451x2a4wWJ5sVLAxV2h1s/2s6p3Ulc+1n29amda3m9RSPo2sS25gpgd27956W9X3UazbQ1+/kSvRrcv6Rb7Vq7Nk46GR8LINTk9XrdwfypWWQ7rMrgk1ERuYYwYfFtr3jCgrz8FzmR1v1EnnVdTLBCL/CenYsc1OfBs3o02Q1Wcv9/aee3urDa+lfppwpvHGCIGt7uo/yT4Bi/01x+ytOX+9ZEQdfXv28URAmx/P85ynvWh7NpwyJjgWxNDJIOii3a+qnV20uFXygXdVIxgVMfcAANG5DrCrajl+9M7fuWhlr5v2zTgrs6z27+eAb5fK9ZZFUlVJqF4ktdHcihu/eMGIUbvCoLgmaQ6t5t6awQysJ3IhypObOIfgGz8w1bw9HYf4IfgeRV16VHzPiNlFUkEqhi8o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9cce7c-2d7d-46ee-2683-08dee89dea23
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:47.0718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aemu6BROgttTtu1/snfMUgXOlsatdXb6rgxNBZqRhCN0EYknSbqbqFzzIumI7EAJIZsQEkQjEpdgDhK3J+4zmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-GUID: xhJgTDeUurrUGkokbzFRZQUAX3O2O9hV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NCBTYWx0ZWRfX9clGgwKT8xJZ
 q1BEZD0Ao8IxSYRQLfWoPUDjfZIOphUYwXHcLtvAd9dMdGG28ckZIgw8Nj72O0NdaDhUFkXPyQg
 ky66KrQhO1mMlb65S0SJWrWz/68s0EDWMRRX4Vu6PcgpPAbUBTff
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NCBTYWx0ZWRfX+x6Bzy+OQJAV
 FABfeFG68IS93rFN5685j5nUIfgU1C3bl7M3xpy1tylB24XnTacXigFfv0mqyiXKUYL/gnE2OvH
 +MnvK80BAQv/8Hx57ayUiYM363y+APwaQSXm+fwZ14ICXkvgiC5eacGo614qpfGP3e1+rUsCpLb
 AFIXvfqcUU53rf7D1qd008uoPV9iuD+lABDB+gKfQXYrTRuXGq4/icV1vTlSqz3+TC0uiNqfNk5
 Doi4aLqDNeqv7kxhW5eDzrbM32Fy4ghUa7QwMpWLmFtP3x9FN6zcuoVxjHShJayal0rOMTO+Fct
 KRDjeE7eQIh4sOc9BqAz11pvLhUf0B16czBMfbgEoBwsUL2K9f/mpWlTh47YyCJpg4f0tDtlOnv
 RSXQQm860b7xRYy0XR43z+4Qg5hjyDqIwrwnCharwgt+FTxJ+UrcwnqPXruJotCky15wD9WaXuC
 Bv394tHhZk17ISEcQ0w==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61e0b6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=CyDbF8ZqInVbw6yNZtMA:9
X-Proofpoint-ORIG-GUID: xhJgTDeUurrUGkokbzFRZQUAX3O2O9hV

NATIVE SCSI MULTIPATH:

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

LIBMULTIPATH:

This series introduces also libmultipath. It is essentially a refactoring
of NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
-may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head
These contain much of the multipath-specific functionality from
nvme_ns_head, including a pointer to the gendisk structure and
a path SRCU-based array.

- mpath_device
This is the per-path structure, and contains much the same
multipath-specific functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.2-v4/

Differences to v3:
- drop for now any libmultipath specific NVMe support, like cdev and PR
  support
- deal with issues sashiko/codex found in libmultipath:
  - add checks in mpath_add_device() for setting pointers
  - add mpath_delete_device() -> mpath_synchronize() call
  - add numa iopolicy check for disabled path
  - fix trace in mpath_bdev_submit_bio()
  - fix race in mpath_head_uninit() / mpath_put_head()
  - add ioctl check in mpath_bdev_ioctl()
  - fix sync ordering in mpath_remove_disk()
  - drop unused arg in mpath_iopolicy_store()
  - fix mpath_delayed_removal_secs_show() print format
  - memset mpath_head in mpath_head_init()
- deal with issues sashiko/codex found in scsi-multipath support:
  - change TPG check in scsi_mpath_dev_alloc()
  - use scsi_multipath_param_set() -> __sysfs_match_string()
  - add scsi_mpath_revalidate_paths()
  - add sdev check in scsi_mpath_clone_end_io()
  - fix sdev->access_state masking in scsi_mpath_is_disabled() and
    scsi_mpath_is_optimized()
  - properly set default iopolicy in scsi_mpath_alloc_head()
  - fix error path in scsi_mpath_alloc_head()
  - fix possible race in scsi_mpath_find_head()
  - fix scsi_mpath_{start, end}_request() for partitions
  - fix scsi_end_request() -> scsi_mpath_end_request() order to deal with
    partial completions
  - don't call __scsi_internal_device_block_nowait() ->
    scsi_mpath_dev_clear_path()
  - call scsi_internal_device_unblock() -> scsi_mpath_revalidate_paths()
  - fix sd.c sys attr references to sd_mpath_disk
  - handle delayed removal race in sd_mpath_remove_head()
  - default index = -1 in sd_probe()

John Garry (28):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add mpath_bdev_report_zones()
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when device is blocked
  scsi-multipath: revalidate paths upon device unblock
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: add multipath disk attr groups
  scsi: sd: support multipath disk
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  16 +-
 drivers/scsi/scsi_multipath.c | 640 +++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 585 ++++++++++++++++++++-
 drivers/scsi/sd.h             |   3 +
 include/linux/multipath.h     | 158 ++++++
 include/scsi/scsi_cmnd.h      |   6 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 119 +++++
 lib/Kconfig                   |   6 +
 lib/Makefile                  |   2 +
 lib/multipath.c               | 960 ++++++++++++++++++++++++++++++++++
 18 files changed, 2514 insertions(+), 24 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/linux/multipath.h
 create mode 100644 include/scsi/scsi_multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.7

