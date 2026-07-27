Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B524F40A94A;
	Mon, 27 Jul 2026 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163430; cv=fail; b=gveUbYfWGsuegTrE4hmg/+1ZOEk2KegaeNu9+XcRCyG2LY6ymp6LeZklsGSmR5kuP725lZT/OLea0cWISLZhBPW6wCoux10xTmNH94NSLMxoLIyKwWRpGkP3qdPyDyyQA9YTyGNJaFC63bfEvZcYBCnic6/dDs2ZTYIlRffIgXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163430; c=relaxed/simple;
	bh=hRocMvfiGfi3em+M6oEiP8l8HW+1VucVU0V9txY4W4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h9G+7vo3VwtbfCdJe8tmoBiXfWBtRk3xyj/mjN6WllqvLH/4gjjj6w2ARFMlqp8XJLmShfULmARzAAYCKF/MaWsPOQXrpnGuFROxs3EFth5mTMZ2IZeMX0n/0DuZxALIwZ9f2+sQk0UrQ+7G1nUrlw8BbvOziLl1jDpY4/Lo0qM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MDq/xDl0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ABuHW2nr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MDq/xDl0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ABuHW2nr"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTSlo2082575;
	Mon, 27 Jul 2026 14:43:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aRSNx4L+SNzxsih4HGXOPMsDoA8zzRGZAVhJnqM2lJA=; b=
	MDq/xDl0gjPQYvicTva+qfrCJ2OafqULHiVmeATtm0r9wvmRWXrT8J4gkh8CZXjy
	2gnhCQ64r+biWDUWQ6WxQIJlZ3kNpVDOiejkii1X0M7Wu1NBYbtv4l8UqXJBF80C
	mYgu3jhIkhYL778KGov0KYplY9g2dTRY9HRR3u7kvKDAqiZfZBaPxphg98N70Ems
	RglMgQIrjX9Ny44vKDqDZNaS0EQc5qa1crZnUzLgUSDUBsLTWz06S8apOY/CIQGN
	4VmURqnSwbOkf6OJQ/MQm61KbQ/8Gsv3RAjQClI/KoyIMUL8HNyC+N24MixUNhaJ
	iB8eSuKC2hHGp/eqMdcIOQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym1xkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeCJE006892;
	Mon, 27 Jul 2026 14:43:16 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehawnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yWSiALqJcBoURzqd3JbFqJ9Gc9hG5+weARDYs/iXu3xcL2kZ2VY9hCDJXEwJ68f3/hyL61bpyIfDCGwEyKFQLVKecMN01pkZe2MtMpHF2CJvyt0dJFZjZiIENoogXAODDqNYpywySBeOtLho8/zHK49vpbCnZNM4LvMnyfL/SQmnEX7xCZPpNihHDUdp/r58yjwYrSmASSV3Rwc3wgqYBlU5MIpeeIQrBMSmlqYmeuOCrkQhYk0qFHYLW0XQjZOFlDk3l+U50WGYstunIVBzXOD4py/tObj5LIjJB1epALsQQr3xiv3eZPIkuRJZDCbUeXtlHA8v8jZCo1sQsTlccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRSNx4L+SNzxsih4HGXOPMsDoA8zzRGZAVhJnqM2lJA=;
 b=bx8auBfOvIbVUrGuZBq4glG3ncsCH4m3VonII3BUATafbd35/rpMAlRqgeWBroFVzywwkhKoxDhPElql0jnOVEBRs/+wvO0WLbpHAP/1H4hULZrzBfgP3zqYOq8X6eu9v+QxzjP4lXimyZCISH3wrsv3WHMKhvCHR3bdgQ0QpaSAg5iUppHl0PHOKPDKHSDFztJ1p2mJJ0nlnUdv2sebO5tOrbhbywwtdeQ4ECfngG8F3f0tS2wGh0l9Awg14iodCvs5chmq7rZ9nveAI4WdLJTwKC9FWRO9Yn6h0l4fqgnAB7j857rCy0IVB6cZcCgZ0WoASNZmdx8Z/Q7gayaobA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRSNx4L+SNzxsih4HGXOPMsDoA8zzRGZAVhJnqM2lJA=;
 b=ABuHW2nrDBOHwq+MoQDtuhMLQ12UhumtKOrgDawRzU6seDnDjBBWT+zC7D8cg/3Cm+Ck44fp3ie5N4Atdx3m63Qm02B+fgDs9dYeumEI7v3Ph9WLAi9XM7lyRY3xM2qFlVCsoSskq6DfAEEZnNJYMLJaPSTxOIvpwptP1GpMmNs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:12 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:11 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 11/27] scsi-multipath: introduce basic SCSI device support
Date: Mon, 27 Jul 2026 14:42:18 +0000
Message-ID: <20260727144234.3802948-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0390.namprd03.prod.outlook.com
 (2603:10b6:610:119::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be38689-4604-4fae-abd0-08deebed61d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D74/uurinDzRFaIhOSMg2iafzLepENEPNP899VXExYvP9oTj1ytAEe1w9HaOpZlDz5JxTGSivn2woEmGBAjl96KefkYEu4j9XThx0oAWNUdlsBza3zA5FQPFHcTWbJuC9Ed+xocYCy1ULuq74S3T4zmhqORqhLd87EYof5WzM+h04x9ZAL4lu3Lx8lKA5xauSOl1blvVRP/N4YxYxFeEXavglqwuSGADd5Ih6EYnZbRMbfHgTGoIqeMr/V2KCxY7dyjIJiGBC5IhBENjDrFE4F+SsRclxfV10UGccap4lKtnrg7cEDyHlmu+aSmkRwPSexrc9UJNcOEDViuLOrVu5HVz37VHsdefaZ/f0uW9wKjgl97ZJK6G2MjwWJUUplevRtWQBY2kqTryF+D324g14WMWj/dn2idoCI/8TxOv4hATkm+OhSBbig6IgeHaabXHiAbIHpd7JW72Y6ZyESzsxEqqHo1aurKAMZmmLGuoRVxIzzY5ES6JlsczWPYDV398CI3PFWAsL3qO+mTnxKvSI7FFrnVcDbFAzn1rEFMf3Up+X2Fj19vRU3eZ3TQgIV16Cg1e2On+d5YKjWg0kqdYcyefQ/DZSLHoIVw8ycXrxMx3hpKfnq0vlVoLhjUVduv0/oRE/GC10QK5tyWmWfAHvzvkMTb0qscvpeHOjOuNdmM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KshmzozFeHjo+CalabVrNPDg4po7wJO9I0SviOrLjVNm7OXtaKcsW3j/PU7c?=
 =?us-ascii?Q?IQGXFf8Bt0SVHyJAcqnMtbtjpe15oTricOXdqbF3wi7wuUO535B8/MZ64kkj?=
 =?us-ascii?Q?8nYWw45BW8I4fHx39ZDeoDkOqAQqZ4q5duUcwKNntZfiHb61Qyy+gC8FZ5fq?=
 =?us-ascii?Q?jLwnGYnJ1e+FcYHyE6fLPbTfL0Z1xOMTWtECK4qASxanZyxxkvfg2O/dwfcJ?=
 =?us-ascii?Q?bI0uMre9GU2vsTiEMAaRJeKn8bLwyJtin0QYyZ545c5rj+8rDu3VQMo5vVW+?=
 =?us-ascii?Q?sN/0F6B4HQLNcNwP7Yi/npNNhZiCVG2LyseM+WX6c/Ri3XJqEQ9eHIfmTUuP?=
 =?us-ascii?Q?4mK/H7YMd6fL5uZtJyyGd5bo3nxXsr/pz91NpMRWK3VdTdEvd++iG515Pd8X?=
 =?us-ascii?Q?VXV49HggpPzTexF87vJXV8u3EIGCKTcL1ZQPuwlQVM5faGgiprVpxn1OAuRj?=
 =?us-ascii?Q?yitw3QqhcXc8YM+LOLV+UNNeRJ+M0pftqeyknMpOQtm2KmtIplbhagaOaTDf?=
 =?us-ascii?Q?NG5Uxx5rzf17qBfa8yyR1fszDEtNODsJULjEz+WJkIHe9ZUz8pjhNroiy7PZ?=
 =?us-ascii?Q?/W7RMz//VD/FU0ue+u8MfJ3i6FUJlT+TWBgkchWSbUpuTKte0kT4nkiuXZqZ?=
 =?us-ascii?Q?jYO+AMOwjknUgX/gdr3TmHgNkyePPoBiUxML2b6dFiP9z3m9X5lqtoQwyocl?=
 =?us-ascii?Q?7RXC2yAQx023LeneIGcdE8xdBpUWzEKY57EHm5Xj+HHfKTDt9I4EpMkSlntu?=
 =?us-ascii?Q?5SyupWrAtEXY2gqBkBbIWcKYlblRbxhpMU5+2NhGPT1gczeN4G0Mp+gooOrP?=
 =?us-ascii?Q?tTr1/4vbzXDKbhsRyXI6+a9BcSKPLmSdnOhFnD+2ViHimCSxlmo2Vq5k4xAA?=
 =?us-ascii?Q?/p+aH+EJLIMGPxlSijWdFchQeq3HR1qfjbszlgGodLSf+hKq0dkhOacesMCR?=
 =?us-ascii?Q?LgkFAXwz+otlP4AojDc8D7TgV+cB0fpKj9vVN7sagNDq7O2ocIF3rsRzV8Z2?=
 =?us-ascii?Q?Z0D7T+S3MmO3YTOkqBIPWalPVc0LdDbDUkP++E27VF6GHDv3eDFCmKuItsuz?=
 =?us-ascii?Q?cXM5jernAAO2x2/Tyg4yttm/E5zf20ceSdxzdYVlDC944Fl1kmPaLpX3pXEJ?=
 =?us-ascii?Q?GHUx1dRWoKZSvwEF4R8MPr4Oq+IXC9cqggSGLGrbHnufYYbdiJlS6nqE4Diz?=
 =?us-ascii?Q?4twmEvq6WodTfYjJCnB+/Tfj1GL1nIt8iNHVXWR+5chwrOO3hvgNfZZZnvRp?=
 =?us-ascii?Q?k9gU4+a+HDE2HEi1cplZlTITxNTn8SNFbxQjGTsNYMW7evgp28fOKNw/tlZw?=
 =?us-ascii?Q?nj+KH26SvFPo582Tm/ULv3bPV8fX0q9v3OAH6iGAYqYnMDb7BT+yu+h+tcjo?=
 =?us-ascii?Q?YR4hPwEmXiEJQTBd/hVIYnZR7Bu4Yv4MyRuXy+kErAw4xRCvqqho6M3QPnM+?=
 =?us-ascii?Q?G+e3+u/VggaOjqp7iK/NqmeVRUN2HkPNk77mMmPhbymlqtokpc7i2gJWW0Vi?=
 =?us-ascii?Q?st6OavKWXA9mj20CPErTTWSY3cnsMEMfSBOh4dN2Awc1juYyjW1W5/PHnFD6?=
 =?us-ascii?Q?FwVmNNRVI/dDleb/vAljJLLbDDQ6mw2HRq8rZT8Xielomz1zfAcNTpDDxiLQ?=
 =?us-ascii?Q?EHrM8N2qtItgGIrB9J6hjvV2+kZijtqQy+pLtUIijgGXqO2XoGJbUewSp6d0?=
 =?us-ascii?Q?LOOoELUZl15Ja/OL+zXF9wakyX8OEm+cNfXI2mrnpAoQRGfprfTy6u4H0HhM?=
 =?us-ascii?Q?1TpINk7oEIOx1bRb/k/0MG4siznjkOM=3D?=
X-Exchange-RoutingPolicyChecked:
	q5/avc+GPznjXB2fEcsHirtVthNETkcyFLSndCI4NclaaV8yVc/DAl7jkBpOF0TLqf5Qo00EmoUxXWzO1RkQXLcqaIaNCDwKe5VQkaODkcpJamlaVZFnbTd2R5HTO0sXwzLY28ylUtpROEh0IIyrbksCaY1gSPjOQMNfUAxpVM2zlyyj38yryFS9i3GcJoK7bC7VoLXJB9Qt2FtuNeNrx2AZolDEXxE6ZrkbdTb49G0z895/BjZ2I95EKSG0jymp/cpIBtx7cB8yxlXduVqx4gLHWmVeZuQFXsOTwAbpkgD14dflBZ1NqZ1iH22LkBkYrzvaS5qgkRABqXkXxdQbZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N13MHxmYw0P6t4/HNp8HF8SwPP70cd6ttsSlVZwwFQ5qmwyKITHFTM1tPI6hpg+mNMlYfyKfbQZsbmRpDvVDLrAa1evfSbkqgLDy0zI+MjojD9gfYWRTv7vQnuxucgOnD8m7N63MLmBwX/xGh1n+RTHL/2WuQld12UyOAkOsGE03g5k/NFvsz+ZX9/6UuK1rlL8q9RcJ8oLBGpo8rydK0R52r9J3DVwxZynWFNdilC59mQ0tVUmMRgN48m5ZkCPqP8gkpXm//CD/g8L2D1Cg9nyRkfgM+pICy1SUZGBo+X5bIa9b7m+UyZVcaP3cNGAOX8+m6GicFu+JzESafF/k+LiO7S7tKk5TErQ1Sc1I1GR34fNuOO9Re0y1E2PW3lQaOBE8qJu8VMnEiNm9uKnPGcMX3bKmB5EEmp6NdTdPetxUhyJpOqlwgHtGMqp7MDOrh/U+wrqKvkn/09ce+ggnIm1SaoEMTE+zDf+yzmrrOwtcLWnUWlP7nBV1RnqP7CoLHOWKdf+Rxh3xuc0cse5SzEyu7iWj1Ay/E3JhuCxIWhlbCoau3BdDmQloU/d3zqPnnLT8+c8F+Va7X0usuYcdwkASFug6G6tJWD2h1CgAVLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be38689-4604-4fae-abd0-08deebed61d6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:11.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy61EVbKflox4j06241katrh7QnNhcbUhd0B4iE9tqwMDCHYKbvMLq6O8ifSbpYOuY+VVCcgM29L8hzGkc0c+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX8/mv2WJXY/xn
 J4w/EQanpH9VJpHENn9UYdkUPmOwportswfkopoM4XZlSjXEjkMdH3d5illiqQAxmjTvnfviHuY
 DpD/ZGsmvd2PzCjOh4suTROoKStC4uHNKeEaK6zZbUTj8hI+mrBe
X-Proofpoint-ORIG-GUID: mBA3E5Vv_JJJM_fIfc_mP62lXr5Z9Z-g
X-Proofpoint-GUID: mBA3E5Vv_JJJM_fIfc_mP62lXr5Z9Z-g
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a676e85 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=pCOl5fTshOrEa-n2-VQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX41q1kK3lecab
 iADvvwfPdy5bWevK0fgRh5c874SmQzPhuXMnn/PcWz/8TCC0zKojp7zpxxYaYvZgmpXEzelO8Ma
 tW1NsnopCjcqwimT2c2QCQ9yJ0eAhhVawT+Amgu9NGH/5ilwlYbwPicf3bVpeIIKaYZiKKDZJPi
 zWzeGIQLJdRREiN5MUmxj0+ThYDFTGszQ7AfAsqOQBZXXPNq90JTMI1fbB0AcGi1i1gyMiF4RRW
 hXyST6GXw/DfN8ijQStFH0wzRSUPmqOgJUgb2Slj+3PmaJFRCQhKE6S3c4vWLRTGXcwywpD2sSI
 hN/wiEV3K3JaHH5hV7AOXXu4Ensre33PrwxJz/uYNlajj/cn7b2ZJ9yPtApX4nnP3a9ppV8UALB
 VO9t3g5i5Aj0qmUWKOUgwhXqm5+FAlPdcW5wkSIfd+xtelIk6bgBiPhEvwS1WdoDSFg5AVdc1/x
 QZSmxEDYwNtnS5+tyuA==

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and implicit ALUA supported and unique ID
  available in VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 146 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c3042393af234..d6c31df454825 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb2269..04f9c2e51fcbd 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..70aa1dbeacebf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..947f3e2103e6b
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+#define TPGS_MODE_IMPLICIT		0x1
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	int mode;
+
+	if (!val)
+		return -EINVAL;
+	mode = __sysfs_match_string(scsi_multipath_modes,
+		ARRAY_SIZE(scsi_multipath_modes), val);
+
+	if (mode < 0)
+		return mode;
+	scsi_multipath = mode;
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!(scsi_device_tpgs(sdev) & TPGS_MODE_IMPLICIT) &&
+	    (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0)
+		goto out_uninit;
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return 0;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e27da038603a2..3f1ac302719c2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1130,6 +1131,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04f..2f80d703ce640 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -455,6 +456,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 029f5115b2ea0..40a435e66b34e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -280,6 +280,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..d3d410dafd17a
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

