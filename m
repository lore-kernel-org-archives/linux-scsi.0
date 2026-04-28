Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9613FE65E;
	Tue, 28 Apr 2026 11:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374849; cv=fail; b=XdPnTiGVKRa35vVrgng7lf1b+YBsuvmyc4ErwVgEG91bA9oYv86ua3zF/UCdiCivdP8+Ru4lf+DCCc63mSdgkpAimWfF7vDC9UzKsk5tWXWdCezB2LoqJAY83+44oaSvKeVmLVz9S6OLe3FffZ48OTT/Ad3jgIipHb9rpdNp7q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374849; c=relaxed/simple;
	bh=sC+JfdBfwIoE0t2l5S1RDeLum4cgVCxA0VghaTPP03U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bgzvzRiuHHbNh46d8JtlWrdOBm6+Cux5UDvGoMVlPWxVWDpYL1pMzLE1apbm7ELadpNXKWKy56pR8VkLGDZHxcN3ekPvoX4k920r0t8lsSzUnulZjhkIVYuVifce6130ZZqy7EuPnpOd7dJM4++t2tcvz41wkCtlrcq7i5KHZvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bg3jGPTm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MwVhQQTw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bg3jGPTm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MwVhQQTw"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9csKF720964;
	Tue, 28 Apr 2026 11:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C1kj0ruPJUy2kWD+5a4aCka57kXGz5K11V79KMq/ztY=; b=
	bg3jGPTmbraXTav74hKIDu+3khM7cCAKgy17I8bKaqKWH//nOvGSwS8R9cYvNRu8
	Qu6y5FeNACvGKy/hNajkdQoRdYJwGcdnecmey6nUWs2GpAx1YQc5cM4x+GM119k1
	GDd2GoBvTTZ51+Q6OxibYItkICsCWhiTeM+9JX+eEnjsvtxnwYIOyY47bc7PT7S7
	aTpJ+H67i9FKMr5qqFTr7hC/edamadvjulbltB2akPBMTP6KhqWW2TYT58gjsyVb
	g7lMvns0QyTKe6+cf8HIzXLCAvQnm2+AFN7QNU2oEmlmdojAGezP8Wx7Sz46bIDT
	0kHKiPkesjGFAHCRLhoK4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drp5syf6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmIg038793;
	Tue, 28 Apr 2026 11:13:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010043.outbound.protection.outlook.com [52.101.46.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccjxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U69wbBXVm6VAFuSgizJYVDRlRLfkxgmcDHULTymJW62bAeDIa9gZcxqDEl3ZMDVOqLP9mOrd3jJI1v4cpFsOQWLZJQPbGGopBCa2nMkdddHvsnaamUaN32qoPOeZjPmnQgnJU8+BXE+KrN/dOjDThqC6n76erNjl2uAGAtBphRFsDnhQOXFq3KdBO8NA1v0cRRR5A1VtMcktuS6C9gsaaizZ+6sVz47HxJHAasUYdZM4xO+FSKsGY6zX97DhFGGeveeGS2YDl58O+nfo4uKX0kwfvS0/PNsL3Y5L62yUoayTrzOE6x/3SIKwwoRgvNrejtfh+F4YH5f7lg1R9fGSNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1kj0ruPJUy2kWD+5a4aCka57kXGz5K11V79KMq/ztY=;
 b=xlO5ahRIh7uoqY+1Bzaya/qrBCeOVexq1Fpe23RhL2bKsSQGR7v296xvJt2UJvzcYWUzzN1CDdNdbHUPGLwTGpOvk5g8SJ/kK4o27phYSsqY6/lla/XYDupiMNpTWSGlENlBViQ9uz/ssVqtpKqJrGS5pEy5QuDU39iVNHOyaOS+VMpvv8+E8hgc5vORGQMZnhBqVppV4p7xcb4OZdMdVLNk4K5rjDrQvNKBXIf52Ezv13hdpJ97yOzJ7NXYSoLex3sBH4yktacCxgfHpYRjGjna6YbtHduChw5pC1sc7/bUc38mHqADk0FtCrf1yfFubV6Yl9hfxO+MtKQV5DgTpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1kj0ruPJUy2kWD+5a4aCka57kXGz5K11V79KMq/ztY=;
 b=MwVhQQTwQkXJb57gL04H7kFrrobvzGwvWFF4+XOut20tFgp4jMdivHzWy1TzeLyGUFIdDRLxn+SgyI+N69naKTzWCuyjwVD5u4HXziVV/maIYXdsh7TeKY0ZcTINNGofIZbsYmxOf7CfIyLjQPtKGYNvdjhj5PsVY4EX7ShboLo=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:23 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:23 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 11/13] nvme-multipath: add nvme_mpath_head_queue_if_no_path()
Date: Tue, 28 Apr 2026 11:12:54 +0000
Message-ID: <20260428111256.1778475-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF000040A9.namprd05.prod.outlook.com
 (2603:10b6:518:1::4b) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 398741df-5f67-4570-3d49-08dea5172946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eCKStR91YhE84DlNIXAbllJ2bTQNUkxrZa3dd3dMCqdnc8EM2/26xmN4+H67GFfFWnqYn0eUyU6cF0Cl6/I7cxp8bM1OBy3SyWPcjKq2RYlbmCjzm9/en+oQ3+a/dKWByzkaV+92FFMecodRiyS8Eg0TrHBxs2To+Rv7g2v/qIgWDXSIPCR7h81C7He+XkjdzT/5k/dxB2MSWc/rJ6haVmugwIJ5Fh2iTYnN2G1vp5YcbpK27OSNX0DpG5dK646duMNUWsjBglhX5McBcIMULFZAW289AN+wGvsSauA0e2tB0OyjyzSP9NUYzG33UdMnRDL/8Rt2RiHylamotPftjduSBLzOZ/A+UvxxTP160d+5jKJL3btdqMo5p2978PSESajo5ORPDNmg42EL331fxjVXhpbpCbshpO0K1ltkAwzP/gRf6UIklIoVMftztxA01gB94Mkg6RVTLdy5+lYoI3F8lAW73gvVsyecA+ukvlSbeRLfEOjJCK4OCtpQCN/uMqtQzKPyGkO4tbRCgDXWtHyAXXBTKTId2ja00o441imA8vlnmpAcWbXEgctr0jo5SrS+ZHUkpQJzU3DR38y87Ar05RHhSSP03olw4xPwUPmIy66eyTaUBdyTY+fDUJNFntZrxUXZPOEJt3o+w6YqelzKF8B2evfUilKTUjRDt+3yjoY3nvd0sTgxNu8/kTTNZp139gbYAzRyUFYfsWTwafeTRNnyeIdMCUQPV8c2yvY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sYOTxjzge5P+1W9SE4fLYCtt/G4U5RKKBW6PKXCwYBj8h8xRvf+g+/OMvodj?=
 =?us-ascii?Q?rNhopLGpDuPrnnF3HGHcc5zzoGHc1jqVOCLjSqVUJXR2+z8UaC0msOfjtsdz?=
 =?us-ascii?Q?/u3t7S8ZuUYeVN4xpb8j1gRghIanrPlBG2KiTIUN3Rdnz8+hei6OqZo7GY0K?=
 =?us-ascii?Q?WFAC8nFEiXNsRjuu42b0xRatNVeJ/U3G1RXqSio3gTv08ZOQfR+KmNkTF2/I?=
 =?us-ascii?Q?O/N5x9JwreGsjA7WdJUJP8q93IYufQwL5RNMdWLF7KJMHTiki9gBFPtZjNkb?=
 =?us-ascii?Q?4Ufh2ZlY1Ck/xdyXXoxlXRiD95MOq8PJB9O9+XSpssw+bAlwO8u2Dwpnw+4u?=
 =?us-ascii?Q?Pl06m/mwYRJoFeT7x5B1b4uClCbkeXFODvbfXwNpK51Cgel8KPqriYwcgJwq?=
 =?us-ascii?Q?8KcQWN6uKDl5XrPltFjr/dFWyoI8xRLrQB6D7tDJbqpkfceVV1hs7B4FXnbw?=
 =?us-ascii?Q?MnnmQ2FnrniFeZDYY6UzQC7HGRkOvq/X8y5OpMLN+Aw8QOWLpmylul3NKIHj?=
 =?us-ascii?Q?V8A5MkA71Uggr2yzaT3A3ShJrQ6XPpJIL0jJb5QgJWu6FH0Xc4OKzx8tSEbk?=
 =?us-ascii?Q?G7/qgeUSSA0LOAORes1NBBqo/HTw34Do5WFBp43IB2br/uXYjIIroRZHMXtd?=
 =?us-ascii?Q?HqZY+nRE4DA91Qfa+iJlehTXhhMd2Q4kXDU8lcRiqD+VmxqDTw3mVDdqFCdq?=
 =?us-ascii?Q?euU5xztZhl5tJvMyYIEJhJsWDrFjjOzinqAFqy3YfIkEvew9qLQscoY5nsbZ?=
 =?us-ascii?Q?SdZalE+MXgsTcv0OR8d+kdySu6+v2tjfCub1hkM7JnIgqC+DZ/AfzupVFBUo?=
 =?us-ascii?Q?+qDXHIpSdxiCdM23l4WXVai2HbhMA4mwIVxRgPVErlyYtnC/WSFEqqijOyYs?=
 =?us-ascii?Q?yRzYRIdV4JDKeKaFFEd2e7mtkTVd/1ru2L+myvLhgK5js4r/ijOXiTwMUtBx?=
 =?us-ascii?Q?S3Pp2s454GyrAgJayaIaXmvwAZTsv6kmn9TcqvhVe/UcEkGINgmx29EYapG5?=
 =?us-ascii?Q?swyLOLIx9SyeYBhgn7cOqA/B12qTzJvl9/XORe2vRln6qzlNgy/T2BJ+bhPS?=
 =?us-ascii?Q?Bgt5/lAzFZfmFwP3F1LXxv2wNNvgfv/uFKskvNvEYjhhSBtL6M/7+JIocuQf?=
 =?us-ascii?Q?pR+32BTGFNuVfQxZ3z0XSsx6xYLHKzBz7Z5DywXm2x5r/yg69msj5dNnh0mC?=
 =?us-ascii?Q?M/CWjSuqG2QJlgu0aGOsD5j2jn1ovMCNCXlU7vKfg/1hwNINmjymHjkCJuW8?=
 =?us-ascii?Q?G51hN7D+i45xL5tLbv9KL6oyCoeXigqCrCbr8EnHeDgU6olnIWDhAQ3RprRA?=
 =?us-ascii?Q?yt46FenMU23hFFQ0Vd/o6iJluDFLacfNnAP0XIdUNag/0YSXZ0hGI5nsxeBM?=
 =?us-ascii?Q?f2JLziYsPfhoA/9ZQtImMnbjLfx6bDldDNysImsor1YF8IdmPBmZxv6drxTT?=
 =?us-ascii?Q?SGmjDFq02c3KhrUhfY0OEf9kAkqWTiBGufb3rA5vuzsMHq0yhFu5vKZcjc/y?=
 =?us-ascii?Q?Vkax+Y2jgZ/g6nq8SyPQ6kDtoopIUFUQzQF/8+h96D5/8QPyr8o3PTWWrzuK?=
 =?us-ascii?Q?o4XBzS6ZbHqdhbDAKeQtZcpyxPEs4R6O/zd18pnM5oYpDWhkunTM1KH4bXj4?=
 =?us-ascii?Q?zT78ovTepApnQvry5l4Wj5boxszQ+6RNk1/m63kzTtH+XY2IyeVfeysio6GF?=
 =?us-ascii?Q?G6HSJV67R5jP3YN1v1vKp1+xDxtknDVLfkgUyAp8rTc3j/mpO4FUET31skJh?=
 =?us-ascii?Q?nqLH2iI2YwWdvrVsshCAbcrzqJqPCV4=3D?=
X-Exchange-RoutingPolicyChecked:
	cLPUgbpJ65bdBFXzQlXkW6tGTOb0LrIASWd/UEOFWrt4kWJSJhmq2gqG+yUJYqemX3R1PQImegMUkGvYZsoeeW2Nc3HsCWI2Tz4IngC6V7Lujmf8N1bz7TLTSR1uLY3NjN+8bYGH9Fa3cLukvGQGLLX4ixiZHL5rpyniraNdEtXx0jV3FzWUkuHY7ZW9VaNFxicrI12+3tcCyjQAvYq4W+dZAGkkXY9fPs5o6tKwddAm6YWCavacCVabXnpkXzPEZQuX+8I3BDZ7qrO5PGc4D3X+kRHRVTVwmPbrrmY5PdAHnX0NQdkh0YzlBuW7tLtiszw5ae4h65yiJeU1DKfoRQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mb4CHZkARPWv91OpsZNXr2Nj5Z+5XmLP0biOBnGYG1/Z4CHMm+Gz0DMMiqaWQX0mYFhwO5BGDIc/Z1HTNrUWWpQEIaFPC4TQmyz7J1wozgZ2TlDev0cUkNs01hzRfAkFjzGFkUsTTdX40knNdRYGyU0i3uHZzogoKz26TYrOtTxeE9a3An+7DEovMmeWH9WboCBWL1mBAweJzxErHPstAqZd6mCuH92tE/pquXmOwCFs1iKjGBBvaBf806PPOrBYAjO6I1X8bQg/bA3jOyhWDCPz6Xa7d9iU21PIm8J133WhkvDOUr4ZG8y2xe/52l12swCjE8G1ttavTtyWiUXSQXMZ6h1uOxtDxsJdbO8UFHvBmMdqYARqoPsaHY7DRcWFAl0WiV5icRCSXnFJQ5p4EWeHMDOMRRZLna8PTyOMD0tbD+14nueFh8gwbbEOh39GD8rAw9nmmy8gI12Qmas4QEE0nmluYFGtW9eu5PHJ+LK47dPjHUn5IAb/sAneaMFS3xIY5AnyMoQ1MgS3wC79AD9CqfmMO/zSopMGXaY2j7iDq299TqUfhDGXbAc/BNLAnHvRtxAba6U56P1shd78bqV8xugmWXgg7xr6eRztP28=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398741df-5f67-4570-3d49-08dea5172946
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:23.0613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0gMp3KJ/F8yxg6CdcoYj16fBRmcAVVHzXso6Tbm56LyLKb1+s9NcuHdT5/rdaNwp8vwMBfxE2sXt9S21tG9zkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX0650tE0gTqoo
 aTxGH2rJJPFxWSndtgyq9Ao5O7AKLBM1h+lmM+DRepsULlsgpIT+Oc/d61Dd26HnlNU41B3ZZXF
 v1yfRvLPMafju0KAsjP/xYc6vu7NqCaoHo7ZXjPiTpPMST+5b1TBxQFfureVA57HNigh3uPxsB6
 FPhENDjXRjILT1Dw7P0Tf+bO2ZLgFOH4X4aINUwO+LcmAUoSqlWaEMxp8f+b8Ns4WjX/2X/Ikut
 fMMwBUI+Y2i5TRu7qYQCoEHNIUfd/dhRlGpgZPdvO+QsNJLHQJm2QiRtIjFfOJ3nfJRQEZn9I99
 85js/2QPwnRjNUXAJrQpOQ/uUQgh2Td14/9FeeEKPnqTEUOsN4YpKerlUrm/SXCJjE0nrnervnR
 iKaieWfXOmK4x9lIXSeojty+xzHCXZv1Q+NY4VzXMz90fcgsRoCI2D+WCV6frHpN05DJ8Z8tOzz
 q0h+WI9j5ylvRlfIzaNyJdq74Aw2mTD1MyoXp6lk=
X-Proofpoint-ORIG-GUID: V3kg9NuDkcCyBv7QODo_-6rt9vNIyDSU
X-Proofpoint-GUID: V3kg9NuDkcCyBv7QODo_-6rt9vNIyDSU
X-Authority-Analysis: v=2.4 cv=E7v9Y6dl c=1 sm=1 tr=0 ts=69f09658 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=Aed8ZSgTGLsvUS2N6I8A:9 cc=ntf
 awl=host:13844

Add a wrapper to call into mpath_head_queue_if_no_path().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/nvme.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index b4fe7a7dd7f73..f96ad4f890797 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1080,6 +1080,11 @@ static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
 	mpath_synchronize(head->mpath_head);
 }
 
+static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
+{
+	return mpath_head_queue_if_no_path(head->mpath_head);
+}
+
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
@@ -1200,6 +1205,10 @@ static inline bool nvme_mpath_queue_if_no_path(struct nvme_ns_head *head)
 {
 	return false;
 }
+static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
+{
+	return false;
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_ns_get_unique_id(struct nvme_ns *ns, u8 id[16],
-- 
2.43.5

