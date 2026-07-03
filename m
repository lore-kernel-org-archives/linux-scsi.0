Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610953D9DD4;
	Fri,  3 Jul 2026 10:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074918; cv=fail; b=nc966PECaYXKYZpeihMdLGLIzCPpIr++RIFPPzLZgJfc9DzXgq9EXaWQ4aXn02hfg09Qu0hvW1ttIqwpBwXzxIN6sJ4inZDAEeB4qjeY4YzbDZY7h4/mlIf7AXWXlbK7s5+vwnUKrapGRZ7ZK9LKRfLbUIhqElnsM0wYRDMeUIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074918; c=relaxed/simple;
	bh=B7uybhuLpJFdwKIepB+LKAlROI5qX+PXFGyDAcOE2NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cdf/ju5Njjs18SNOBs59NcTXArL0/azNOz2SgIpSekAI0MORBOV1LSznfQ2IWj7P4kSDZichaqgFI9h5YzzYbu/r0VlSujaMGyMndv20IBU/Hb1DzEFq1OHwByGS6cxF65tYHX7IY4GIgenWSajUHcgtQRGA/azKONguQh9wLbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iR1+23Qn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hrr9U43p; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iR1+23Qn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hrr9U43p"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfqf3016260;
	Fri, 3 Jul 2026 10:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BeUahfKhGOubWtdQS+zR4egxROWfVnwBqyz/P6GoeMs=; b=
	iR1+23Qnb+3veSzWIE0ZgxohosMWwQDBI1o5p03zCgEya+72YlC2i053kgVnKKQr
	n6ZUTpJXfNdr7/jXzN22U7f/LLDM+3wLNihSG1x2RUXVkfdb3UpJYtTouTUJiR64
	As2ovU9K67UMLdayXDIZNJxDxq2pPNDNYi7zHqQKXogfbPW/WVsXvAax01wR1t/3
	nh0V7KEEdKriCSm5i9fn6FYKvPyWfHxeP3fjBSmiHW7AXbst0v3I2NhQ3RVYlWa0
	r1nbJ9czVVCZSQb1FL7Pmk3qXShS7IB4znh49v4R7+qZjT89kEJ9sd01DMABVvj2
	wDoKigycoDFLs/63Oz0JAw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qtdqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXTcq019323;
	Fri, 3 Jul 2026 10:34:39 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yu87h6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7oiG0pxCApoizkexX+bdlZr5gnO047n66GWiwPxNRRW/vQCXjlPz+M3ttZ2OYIeEysUHD5YQNryATnDJHBYh7e8lqeQhQJ+uykeKHBcC2PLAkt0LgJ8UfzkCzsw0EUWwOYm45t105dYyQKsecQLT16dycKvNgb7PdAMVu4pen61QupMnanA7ZDPeZiSrhb99O5ASSJTiCbvdy3SF3ppDhK8NNuM+INkpV/0ua9WAID8eK31f9o9ha7ucQVkt9y5ZQ02DHKUdDeSX+PN/1cuO/4R27ZYgkYXO0nJP0JVKkfaMT5Ki1CgBoEO4jienkKAag+Be+CrT2Y+i0VAZDnumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeUahfKhGOubWtdQS+zR4egxROWfVnwBqyz/P6GoeMs=;
 b=yZbvk+/4g43NKr3vc7yg5KEUr9psa3WMqOrHg4sLh9td7osSMpTyOdJGQsxy/3EoY5K2b+kIGMxePjhuGIHKcqz6nLV3xQVdQeiEMsrllRR8YJgIy26MGz5vOQB2Aon8xi4XSBwMTw25CEpz1EgpvrNqQ9oq/bWzYWG0bWH7VG4BtBfzKywIU6yIlDwSBPDbKwmOD9iMdY1ERPU+IQB3uwh69Ekbm8R8MpKD49ZyWSFUydpP/63tqPStZVzJU0HGvPKx6oTWms3Iqatge8slBmCymPyqvlI1T5Votw5noQUa4/iEpUc5Rzyl2d4L0AcrWhlPPpaoKYqXtwsTFxkDTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeUahfKhGOubWtdQS+zR4egxROWfVnwBqyz/P6GoeMs=;
 b=hrr9U43p6kgCo7vw3BACz4LigRMTHLhPfl+lSR/M0L9vo13gmftbdAPXYLylHJwqe+CdnfG6wWm5ExUctbDbSDt5YR76wbzCmylgRXS/1pOGEH31xkK47hTcWof75IKSFl7PoKR64v2AYCHAYMzgB+L95PvIoawHnNJGaekxLv4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:29 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 02/17] scsi-multipath: introduce scsi_device head structure
Date: Fri,  3 Jul 2026 10:33:47 +0000
Message-ID: <20260703103402.3725011-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0165.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: b821bed9-a9cc-4316-2287-08ded8eea9d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	hWlxPukWz8LvpJGqJ1uDOkP4vbfxUAjnAgwUpNKbXHU7hcLBg/iqrMkqORmUkTM+xAHANt+1AafJ3aOXO0JQ0VoftgPSW5J1g9saE8A9k16moh6TIcRSTrQmX0VPebiVsMiHwZHSqmlm7eog1u2azUKCLkzPfdjFeNElVgebFtvccxzQ9U2jLo21UoqZBL1r5YSki5PocIpHvnza8u6kbFIQl8zk//iio9JkKTl14G69tDnbCWCNj64PdACu/2SYkwI7eHGaub8IuXB8eki0O5ulMfKaYa79nU1hN9jqp3LZo1r9TB5IEjGtKqXmnAGVn9dKDNdp0cPjVmV1MuQCRZRhhK3EgQEcG9kfZX5efuT/lyLU88d30I3W84WZW2/9lOOfcos7JsaKn5Uph5NWwhkPqQHxpZH63kzgSVwFHJ+Cfj221QZgL7WvQuiVQjYO8PV+yBobrdHGB3SaX7PImd8kxOtCGCZpkzWItSqNKLiP0S8xKMmTDKLl7b683+DS4c1ym/54uyg60iq2cge2iGC8jLET0EHP+6kxaH250rgbT+/u1gjPr5fnWz/whloPwWh5cqL4iVP8hFqBol1ZeehEt8ilHYk61CZ0OlUr7IpTlimS4+slFEPFwVBYrLyjHMLlcsl6XRiUQLqY8xW3ADYxYtW7K+wP5Pu+KyURdXI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TDzz2EfCy7qzuIfwRB4DQ+saYWLicdZcdophUBmVHXi2h1Y/wm/VT1JNidtq?=
 =?us-ascii?Q?UPSQtvsqlTsQPQCyMqV+69lZ0v1dhxZIi0+6/Qn6UHrmKC7Xhp0gk9gDk+JP?=
 =?us-ascii?Q?JFZdgzR2DLKVRfRmjVBuUPcQoC7ssF0Mv8WEDeqQ1CZktQx4JH8AzUX5U0iu?=
 =?us-ascii?Q?0CJ8SiWWjToxTirG1sH8TuE7S5yB2tlKHOV8e3YA45aFHttP8DN90U5nQkBD?=
 =?us-ascii?Q?YF022joHp5dnvKTQsvJSBumGSZgWcpcGNyFvdkjlRs0P8LTzxGGcRUvuc82z?=
 =?us-ascii?Q?nu14BpKvnQB5TopFVtT1s/4L9Iaxi+XEf3DvTHHKIyKM480Zizm2x3YuSD/s?=
 =?us-ascii?Q?8nI/0coMMsCLKyZpQUDlvS+nd5toLQQmWToRQ+p8S/IAFiRrX5Bx52VGVvZq?=
 =?us-ascii?Q?a9ExMe6OXUJ9tXJMfPYVLs/jqIrPS9Cfl2AUAQd7UBSf+C461a7JAlz+MC6R?=
 =?us-ascii?Q?+H6ueB9yMCmbcTHmY+YrNDPFxfIk6aiVsxAPFpD0A82KwAKWA23GWQMlCGf4?=
 =?us-ascii?Q?6QxuS/AjfQZdwrBVCoDo933I57saNB866iSKwN5MNRA7IuKNCvqNunmKqxAI?=
 =?us-ascii?Q?3EQAAtxKeuX39HeqKj6dHxPV9+y1pSVGC60FfyLy/FuWu5tTHjZbfaO2ONC1?=
 =?us-ascii?Q?tvsoHb+6MA0ze20+MCvZY66K+xFvlNPd1Vzjf3Mpar7rFxyH1L/3VzvzTAA2?=
 =?us-ascii?Q?bGEXT14/UydYpUyLLk5fOZeHC2He9iVBkwXMh/0vAglCWrC5YfS7DDS1Ecqj?=
 =?us-ascii?Q?hkLSQcLGmRqDgbZXSUpI6hDlVeCVra8/XS/FczTjX7uqAs6JjJPcqR2ZOOvR?=
 =?us-ascii?Q?fK5ZlA1V3PzjyfSIGKGboz7X3GPRiZuScCU/bqDeUbYj4/2+Mo3Xn9RiZ7pi?=
 =?us-ascii?Q?32/lAVoaUlPu/SP6TQfqMDrhvP5n6iV5ULW8kQCerbt8usexw6ILyse/NKGA?=
 =?us-ascii?Q?p4YlDDA1xQJBfadY9UsYGayABqlwzj9CLdrVPtyWCG6YI97OI3V/3ixK8Ubu?=
 =?us-ascii?Q?xnh9TUZonHKPATkvp6ZnOqdtTQI9gYUuDzEISMmIjmKPrbBVcLAIFYxeU5Jm?=
 =?us-ascii?Q?9nZvxebHTmo4GUuBZpt/G1SQJegO/ZO7AfrSJ8/imSR4iaJpcdvAOOwvL3IH?=
 =?us-ascii?Q?7D9ub0Z21b8XwxtRSvaLo0/ABiJxG2lbnKPC8XLOpKflKFiZvNN27OHb4Qej?=
 =?us-ascii?Q?x4tHzZ19vPrPNdeWT898pqE17n9A07VtJ5RE40uVEyFxJCMSg/VfiZhTZNZE?=
 =?us-ascii?Q?2bfWBqIItoer5Ad61g3XUqwSIOP68MpfiKygGrpRiJbw1F6HCBNg9zLp0Rwl?=
 =?us-ascii?Q?G9vMlLPZFe/xKMh+EmjfRYl2Pml96djHkSzf47DNA4VUJGReYA8zbij2gX1A?=
 =?us-ascii?Q?3PzhxSu6hvzrBqadJGnI+fnoCNNSDVMdv4ALuy1CGiTQA8LHxUsXwo28xqPj?=
 =?us-ascii?Q?FwNlU6+zXB37A+2k0AJZQUXyQgs37ayA6jvats4Ef2XpomdHQHqqvMdEDtyC?=
 =?us-ascii?Q?Uj58V+fn7Y3zwE42VswTKvOULWYYP5r9QsEQv84nF5oIB4XzHkQpxbLdCmVW?=
 =?us-ascii?Q?sEf4kkl0+FdbpwDOyk9VdCpzZbOWVkW2qaLUkRAZpGI2OEC5LgB4sdPC30ui?=
 =?us-ascii?Q?nz4mQ4AdLGhkLson8oS/hA/SBkDXQQ6VTAPJfIRRnNyFARBlMzu4Vlf3PzoM?=
 =?us-ascii?Q?63y2xgHbiPWSkpa3kRQoWjMg6wqATxqINhMSBFmmlFuz9i4JeaKBS6lObes3?=
 =?us-ascii?Q?NZM6dr+ocdGRTeFj6wlqTb1oaAoVs6Y=3D?=
X-Exchange-RoutingPolicyChecked:
	VljUmfwtZHmaKGrv6TktnKrucpfxLecvPp6PkNrOitiNE3MdMmfo8OLYabAG+pzf7nZX+y32Fy2sWYZ0RZGXLjgb0mJksiTMOkYjvzm0QJGkd+2aFFXA91s6mP+a8jTBdbkUoJ45qIGe/WIxxKRLgkZeEFDgCviSWBlzhWUV9J2O84zoFYV1q9BsFbleoS5Vy1QEfGSuy/iLJ5qrnF+eD8gMqnx9Cp1swVEBeFYPb0e2eCWZ5kHDGp2iBW/W6sj1nQ3lzfaNDRXPVWY4RqEyzDtj1s2k6zUIJu6JHyI3PsNK391bJ/7TvmFYv41mbXYH/BL8Tx6Bhu03qpxWP8BisA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	01jjHO10V5qiKR2kyVpv4hHP+lxi9VcLxuFKtFx4KdxonIWDXYYvPtSVgjLwDYbVVYecz1Ld7DAoi7uz10OfJX0w8FP+/7kyoy5JXaqkVLjAv+aRbOVhGvmJWmxOuMT1TiwKjZUyESTuAL93wqANlBFKnpmsg5NZsqDF36XFI0x1uZOJyph+biZgcbosgtX3ulUW5HGeXxSOCPrLWF/I6NLauEKyhyQHN7EGYW8A/ETFxj2F04xdj+uOUG4UrZX1djjLwd63zaVBZvoFIhqX/wfzO0kRcGAdANw8QKvkNBvKbcf2YzADNySHQ3QNTJpYJAXzF7r1ieLqY3LIwTCJ2YInH6mfiGymhrFiLLDkTI48Iwqp84GJqVXkMOXIPNjyuOnO4SORsi0AMkwMPIfQeFabToEPBO6ldBwusfIZOqk+SM/TVVFFbeOOS/qATp6M7fIZUgt8lIn3HAJcd6NsfbvLSHVYQVw5BPZoTd8rUPafVBTvxOp9yTkgb/b5p4weJtAjvN3QzKPjPgtNf7nImVyix9HbLMjucTd8u4gEdx1/iNXtE1XAR+cyanebLYu3dx3a4tfPJqrrXhRqeganLbCaTqCCGT2hQk1TuedRTGM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b821bed9-a9cc-4316-2287-08ded8eea9d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:29.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHUOZVsVsTqzSarI/H2B3yCPJRaIYwWCZ6ByWPIMdWSWY/FMz4jEiRI3XHkvRDY4dIawnJylDYkL00v97HGOQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: eGvEtTrqzNozq14LufDB_oswAXDxRuEy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX6dqfyYI05h/R
 yHabsBh22BuGvSvJuGaU39qxssXT2A9kkmUGRjJ7MqsgAxiIyA+LN7tBtPbrD5MVHdemUwCrMDg
 greZI5jrayw/x0Xkid3k5iBjEdAI+7K9yDTOsMb0XUcwSf6VPVpn0oQVEn0M4I1YKmkOi1AfyYk
 KBZs2WousMhiUd3MOns8kh+MRj4m/+J8ctOpUWVvHNDzjRRgAlUkc+PxP79lMgTZvkQD5JpQWdR
 gz4Vx1XSuL7IyfhNhm+Z6mQWx1194J4vvsFOUAV+C7eBHNWL04JuJzgS4KNuivIbc85t/w71ZOh
 xOVLSy67olJcbuHEDnyCd+mAm/4uL9yhPwrhFrgwj29qFIBKJc1cJAaECq9rt3ubzw19zxIk/tW
 utg4IKlnYcW4iAXEoHeGJjfWn1hnpcSxyDAD+d49foLfdIsT+oDxvwt1pCGuvSL92wQkbCu19f/
 eC9J4XGuVILTNq6MVQMCrn7xmSRT3w1wqg7khjHg=
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a479040 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=rslDvqJ3sq2LG7fXSO4A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: eGvEtTrqzNozq14LufDB_oswAXDxRuEy
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX9TexaLc4uVFg
 X9jrA1lPcacApJEiS74hIxUn1iWgF3SqJV26ukJu31O6J4t/WDiWN/tbYvH9T1pETE7FgmJeIPS
 kie3mBgOeZZRZbtQ0VIG9NEag/c0f7TSD7aqbbYgY9wETn9UhM2e

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
mananged by the scsi_disk driver.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

A new class for multipathed devices is added, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
drwxr-xr-x    2 root     root             0 Apr 13 15:48 power
lrwxrwxrwx    1 root     root             0 Apr 13 15:48 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Apr 13 15:48 uevent
-r--r--r--    1 root     root          4096 Apr 13 15:48 vpd_id

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 207 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  31 +++++
 3 files changed, 239 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index ff37cfdf2f9d1..65ee3da5cc7fc 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -27,6 +27,10 @@ static const char *scsi_multipath_modes[] = {
 
 static int scsi_multipath = SCSI_MULTIPATH_OFF;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	if (!val)
@@ -69,6 +73,60 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	mpath_head_uninit(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->vpd_id);
+}
+static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_vpd_id.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+
+static bool scsi_multipath_sysfs_attr_visible(struct kobject *kobj,
+		struct attribute *attr, int n)
+{
+	return false;
+}
+DEFINE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+static const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -88,6 +146,71 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+
+	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_put_head;
+	kref_init(&scsi_mpath_head->ref);
+
+	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
+	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
+				scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		goto out_free_ida;
+	}
+
+	return scsi_mpath_head;
+
+out_free_ida:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+out_put_head:
+	mpath_put_head(&scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		ret = scsi_mpath_get_head(scsi_mpath_head);
+		if (ret)
+			continue;
+		if (strncmp(scsi_mpath_head->vpd_id,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+
+			return scsi_mpath_head;
+		}
+		scsi_mpath_put_head(scsi_mpath_head);
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -96,6 +219,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -116,13 +240,58 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 		goto out_uninit;
 	}
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head = scsi_mpath_alloc_head();
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
 
+	strscpy(scsi_mpath_head->vpd_id, sdev->scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN);
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret) {
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_put_head;
+	}
+
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
+
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+	return 0;
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
 	scsi_multipath_sdev_uninit(sdev);
 	return ret;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	scsi_mpath_put_head(scsi_mpath_dev->scsi_mpath_head);
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -133,13 +302,47 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
+
+static void scsi_mpath_free_head(struct kref *ref)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(ref, struct scsi_mpath_head, ref);
+
+	/*
+	 * If we race with scsi_mpath_find_head(), then that function may
+	 * find this scsi_mpath_head in the heads list; however we would fail
+	 * to take a reference to this scsi_mpath_head and continue the search.
+	 * As such, it is safe to call device_unregister (and free
+	 * scsi_mpath_head) after we delete this head from the list.
+	 */
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+
+	device_unregister(&scsi_mpath_head->dev);
+}
+
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	kref_put(&scsi_mpath_head->ref, scsi_mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
+
+int __init scsi_multipath_init(void)
+{
+	return class_register(&scsi_mpath_device_class);
+}
 
 void __exit scsi_multipath_exit(void)
 {
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2f80d703ce640..d6bbaf424bd4a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1501,6 +1501,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	} else
 		put_device(&sdev->sdev_dev);
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
 	 * scsi_run_queue() invocations have finished before tearing down the
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17a..50298056181f9 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,12 +19,25 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 256
 
+struct scsi_mpath_head {
+	struct mpath_head	mpath_head;
+	char			vpd_id[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	struct ida		ida;
+	struct kref		ref;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
@@ -32,8 +45,13 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +69,18 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	return 0;
+}
+static inline
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

