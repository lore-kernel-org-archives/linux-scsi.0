Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A8938F931;
	Wed, 25 Feb 2026 15:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034038; cv=fail; b=Z7KfY628HSGfroIavoMIKbhrqUjD87v46h14BkAO3+GvcJdxQ62oAdRBmGSSBP3RNuM32sT7CXKqZhKYjIsCFvb6Md0ywKsrJcJd2IAB0wn7l2jfn9jbQEfi87DjDEqjdXLqlXPoKDtlmFbCNnQXtQuu8Qd536AOn2UBABhyb1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034038; c=relaxed/simple;
	bh=h+mkHfMGALmGQoEGZUX4cLm4d4mgMQ1nE43cBxkr2cI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QsaI68Z6EC18XrhJM200eskFIIklEijgCSbYH4clKZQafpT/ICSd7mJ9uRkEFsXanxpdbaW4s0rBCp6LvKaCICPIp6CUi5G8M1YIzDejQu+5KNTEeD8yZkJQIPx0vjxNDq/QjCBKGoMRfHZ9T6RkFCgw0mDrK7hb6gN+TpTbzyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Flca0B54; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BCwrYvwZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Flca0B54";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BCwrYvwZ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P4BV6P1461731;
	Wed, 25 Feb 2026 15:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=EmnOg32mytH+zZco
	18C299ZWWTsYEVFcGuU5ClxHze4=; b=Flca0B54QVqnqEBjRJLM5nblvfIFQ8be
	Fe3G1fpChjYTv1XWVL5XTacBCwa1l18l+Ow43jeDDAzaSlajuC3Dg6xvCBMjarR6
	ckwHWBFPlDfNvRTkN/+u9SJvkHbaMLK7Xp6zxUw/lftOD5w/qeW3lXozCqLscBgr
	o6Z53N2apzZ/IUsctZgq4YfuO+3Uoq7lRQSt64SiCdIznz5xPQtbfKDob2Jms6TY
	gT4NFz3KXmRhfirlDEQLPHvOzu29RTzV80xXcPEjG3AikU4zRS1eDTzX5gHd2Jfu
	YvyduoFqQV4ytEyCdaBffCrpBD2J+pB6kF5lKxJQe6ZKM9u9SzOrtg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pgf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF0LR7012479;
	Wed, 25 Feb 2026 15:40:24 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012034.outbound.protection.outlook.com [40.107.200.34])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg4hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bXscWNDiZLqtYTqA6ckFrCDEuHBU8zfSGdR1CewaVaqZrRYDECEtaKrjfhV1DvlG2gMlMCL4eTqWrJoluF8LE8WMW5qGbg4Mq3OnIStWjIhwS6q+DtNWL+BIXjnwquQMeAXJNcvZ+Mb5TMzxznCtqsrlFa9oTDAhLkQXzXtPIiP/Beb3NLh+bFp8ezHJcm9ULrJgWIfaz8PSuvmoiVioHvFrgFExAFoLkC8PLaZo5/+GNJ7rvKmSzeEoHSymK0ynPgAlUxuZldAmzQYZISgWQJm4iNsXLzE5rgh1cbDu1LHA8pXLUJ52U7f7sQATBU1glxyT/PQm38GYrm9mbzom2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmnOg32mytH+zZco18C299ZWWTsYEVFcGuU5ClxHze4=;
 b=OTYBrNogd11gtmd9i/fHlUsoEo9FhQT6Gi+JfV9iBoePsNufZ0zY5U8FsLO9FdliYdelmmbWV0Eq86x8fWoYvvZ+AtkGsovNCwhXyVqkbtV+KC2lsDnnz32JC4dnZQlpRSvBf0BbFsQars0mIt1Tvem7uSCf8wmpkpaqoq38GVM1vOZ3eTVOAJy03EwD7WR+XhehxAmHAM2Gftc19M9swxQPgKCsQVNrO2OwGOz6cpnyKUTckQUSa8QwXAm3YOExYVtqdhMSm7A6S+9SUDpnNW74buAQpw6SCeMjPvhI9uqisGRo9NkzepJk4Dsb5JmBQeJHUXO8VDRPk68RhEoBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmnOg32mytH+zZco18C299ZWWTsYEVFcGuU5ClxHze4=;
 b=BCwrYvwZA7fyv7tWyhGOn1Y0bggCdS22+tor3qLasfMuL4KwUEBGvSPEp0jkBqV4DvME6SJS2NjNBRXLi2AOKBjmB1Vxs3dnzJGKeUEqpcJTs8wHQlnbdNtPwEhF+sibom63vIU40h9av0mcPi3qhuOnEhu52s0m2xMg9Wy/xn8=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:21 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:20 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 00/19] nvme: switch to libmultipath
Date: Wed, 25 Feb 2026 15:39:48 +0000
Message-ID: <20260225154007.1033735-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132F1.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ecc753d-9215-494d-5ef9-08de74842ef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	EgUTZtgpFZfsf/tE6gRQx6oJ+yFcdz4Y6Gfx87SXvekMqUdjGC9LDM0uHwf2JUEAG6zTcp8x2axeHttfe1BNii2faGLn7ny9cB5HlJQSDrgLl3K3lskZXrgkJe/V89LaWjybHNjzWDbE4M0eXheiNgf634KFdTbvYg8hRp7ZTFw5NCOcB0aaXpJ0WQlAYlMfMKoqKNKui7+He2H2Kx0txBxejD+lzd9Nft2ziC+XULxqiBenVzo5iE8R5H4Qa0077g53bujXDC3ix1ZDpHA6P3iUy1a9zC0vH5UdIJM0403phKf94U8J6HMgPjVItOcHH/Ue2oSS8OBVUn0DcmSEkU8N8Y2cgtmlH84btWjxM8KJjAC/8xK+KFp/8JmQjoDv5G/ZUKHJMr0Beu2pQWuc/qg2RYUy80kxV1ewwqXlRuxlSWF9ZB9c0upkyeKqCdWIbY3T8hxGsZTOp+rxq6R9eenbTHRpf4ab7//37XpY1MrQwoQh6TGsRwRoI0UI1wSezY2swTPJpNsUCSwIZXLrS5TNaM5nufcDMGQw8/KkdcLyk9MJVqSlWY+EFchhARWrRnM66Yt2P4XXysA3kyP8rYGsTlGdClUH5Gxp4E0OgEmyYAtZkMer3iNkYUwNA92u30dUGREnQ7m75NIocgIhNnXTvTW3Yqg7+px45Z5G5Wy54FakrIxUpIiywUXAj1dni+K7sebL6pMtd1KkQveP0wTz8aRURBW/rB1u+PY/oHbvE877e87i4r0iq+j+LLf1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xr7R7w1c2PPAiew7SbwZXSiK6uBBeRwZ/KuXGPZe5B+ih9fQsCtvPIvnap6c?=
 =?us-ascii?Q?375erjcgKOWqPkE9JRTS1Hu+Cy6+slN/EGAvPdAFutkiGTQq8tf/Y20gF+yM?=
 =?us-ascii?Q?7BgUvJk7pSadOcfcq2YAXKMYd7aLOS1CACjJ9w6zFubzlJDypOQw5McCaSIS?=
 =?us-ascii?Q?dpW7797STCvVogHAWXcSxsrHAVOc7nvqLGOBeCYbnXnistF0FOf1GN90cN4X?=
 =?us-ascii?Q?xrAMnE9v3wBXoUpIGEKDiDOTPUlf4vkn/ttilP0R72wDHUwqjGQH7upNPao0?=
 =?us-ascii?Q?lUlgozkPX3aaliNu6g9zJgPV1qU57FmJJYMD/t4l4ZwiuRYuWgBHO18CSs/D?=
 =?us-ascii?Q?CSx5aiDYcLDm4bCAGb5HTc4NQCwFTXYRRvEzzTXDeDwp8r1IQOF9vdjKASgq?=
 =?us-ascii?Q?RlGYo/vIbU80IiNF+P1kE4WH4L3luKhco4Kn/yDPXqiTl4GYO7KdVJ5TNgew?=
 =?us-ascii?Q?QpuHyfaicHzTVdPpm+5KNqbkpJnW7zVZgMPhY+LbZXWPWHIvtevQ9CkZhZFQ?=
 =?us-ascii?Q?OzmMpE/aYQC7gb3d93WUMhu1C2Awor2CXwpOuospHdFUjpoojgz8DnY9NXv8?=
 =?us-ascii?Q?iTO1PQsmdGaMxKaPUtP5KXQSDD6pTlS9/N1+VWIOaUixbnZoR3Kxw+hInNca?=
 =?us-ascii?Q?CX+Li8/hoSbpHarkyj7R/+xoRGp40YISnfspN6H8TOEbRZdPr9RYdXPvFghb?=
 =?us-ascii?Q?QPe+rgBN+XBNkYxxE0ZIOsjiaCgTBQdzsm8q5ZlrDCajfgGtyRhu0Cn1DfXd?=
 =?us-ascii?Q?LZfn57Wex7Y2lYC/ttBFcxKMqY+qMaf0Szaa84tt3C0nXUsCL1/YU/fr+j3y?=
 =?us-ascii?Q?/AonarkolyyGbG3Rz/PyHQ0EZt03IfyYf0iPIQMGK4cdzLAZWgeNQt4E91RL?=
 =?us-ascii?Q?1XmMPOZFI+QhYtwnN85amvg1HSGbKjh6SwvFrAZSpEriEHJvh8JMi6ekMyf0?=
 =?us-ascii?Q?2FIrfkDNRBXP8KTnpV9FzrF7+EWJ6L/RwzRZsU79DsrY4Nl/evoxC8/Rs2ry?=
 =?us-ascii?Q?eos8F5wIQlYUzIhBmQPRQTDGgVPaYqXi83o1si1YeeNnpqC3gJzXyxxSMP9s?=
 =?us-ascii?Q?gCOqHW7I5kn+yV9Uju9fOW7BB9yoKODJsqQkPRDvYYWSCmZr7LlSXYOb6sAT?=
 =?us-ascii?Q?3/XBZdm98+ElMNvCYGAVAjXIkMwJyXM8yRSHEH0PgLkyLz5eK0YG+c2r5XR7?=
 =?us-ascii?Q?aA4VTsDr8JB+yCOVn6Dl/pxxlc7XESayX3NrQDf1rMu8b3EySKx/o6tD/puj?=
 =?us-ascii?Q?Q2rezfW6l1B8E5fS6mz6wU09BAqsXPGzEPuZCd/snefcWrzOZdctFErNON/5?=
 =?us-ascii?Q?gwRuOWouI5odj62JPam15nR0Z5WNr2HkU7b2D0a98oE0see0py8lASU2MOUg?=
 =?us-ascii?Q?+ZLxDD/SNqjWZqeIsbSqMK+ID6fYa1wwTn0DZb8B35PxN6vOns5vIIGz0jvh?=
 =?us-ascii?Q?wNuS2oCjYz6foxOfADI632BDIq+UiKNF1ywV/l6i5TqhCad/HRSutviaTcvt?=
 =?us-ascii?Q?SktZNj3xN+fVs88a8oSJ3koju6+5O1Etupv5TTS9CGpYTf0nCAedq8FtKHOp?=
 =?us-ascii?Q?W3IQ1828LVl/wAStwTd49KFrDFS8FJ3YjuX/xq1tG+KbYyE4hOAW3wlfjV0k?=
 =?us-ascii?Q?1DyP9kx6JJcATW5bEZtEIXWthwLmzklOEAO8ESoRpKkHchBumG7iZuHFYZOx?=
 =?us-ascii?Q?fIj8q858ivr9ukmVNjpO6DbFGzseBKEnvTmRaRmDOanCfkO6muXobq7S42+E?=
 =?us-ascii?Q?sHc7sa0KPPbjjEv81sCAWQUaVkAmQ0w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rss1DIC+DmLgCwIGf12OPtwz87Me3vtTlorNT5+dJ2MAdfqueeadTpY3WO9iKjBw9+T5kRsf07wGi8solXijuPeBdJHERuC1WxObUf3GtcobJiGTmQyU7JxDtAPHWDhJWGnQwGWe6XX5PX0Hg5zk9UvWnHlzVRmDOYFi3HQoHu3eElRp18gEfCMq09LfCmSTjpEfvN2vlpyS3o7hEtV1FuF/SMhnjzutqJhXU9biUb2PyzVfxVXlJdpLJU/oAfxAyBK6yGyz+UmITxfb0DjpGXDpCBim+mQYyflpm5R/ByFYZp6Vd6W7Ee5bNLSvMfI3Rc0cIc7lmq+OWZUoc527Ou32rqgrzaxY+WeYPYRco0L7fnZknS1V+R2HIItwADFvK5h1DWe8PxGBubHPQpPf1MaYNvUsLozKdjYUklBztdhZ/Qc1nuRwbtTICfcbVE8PJoPJqt83Hm49kVIpIpKrMV0MZqkyadeF4EjpwcVjy6v3e76qYNvukWv2FfyDvF6cwoDu5qxTdv27dzcMPdwK37svlJmX0yyNMNHnxRouIfX/kwppLnNDLoj2wBDMi0eJzZSulNW8oPfXduWNttK7BS7473+fxddRW4Xt29NrqP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecc753d-9215-494d-5ef9-08de74842ef0
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:20.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdbE1Sw5UHzKe05RFieyxjXVJuuoHZ8wZey2xsqpfCL+ynjAGsh6c0vytHt2FltifB+SWQZ1esF39mmvkxrDvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f17e9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=z2atj4PpgoVyJXcdZjcA:9 cc=ntf awl=host:13810
X-Proofpoint-ORIG-GUID: zOpcjnTcTFKrdnDsYnnhey5sNZ_Nasae
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX6LVYAF/2n/IK
 O6gPFn7BmryUcg4QArQ7NWuZy95MeibT4uZN9sZo5Ft1WpGWmQnUROrKXtBqXkjVYsRtHJzV2Br
 fz57lkhWe8Pop6ssXv9jasdwi62xyPZiYmtFq6O7jH+3Aq9l0hC4gHsjWLYDva2MieSdbwvuq7V
 Aig5lF2qNIfJxQyKJHmVOGgBafEWelgFvdnghzT15cKoTZfFhTH3PSjnRwvpttKFroDunTR6YhT
 nXn6P7z+7gc6vk/xfHe2XFAWcJk6Q4bcm4uC+FFR4kGFBUB76Gkjw9k8reTnlM6nKQlnV5edP6E
 URtBuYAC9Y5HVgWBrmVFQSaQu1WmiJ+hnO35GHWHft4lPchrorETymEBUfC026sWl33kDsimN+A
 h2jvl2pqOdngEdqxPWv+2x+iu8TworTuvpfY4KNOAfeUfmRTBn5yxmL9t+SnX4IJz9M2daERyhz
 B9OIZr+THpDxRA79e+PD1xGOnRNF0JCZ7lx9AkqI=
X-Proofpoint-GUID: zOpcjnTcTFKrdnDsYnnhey5sNZ_Nasae

This switches the NVMe host driver to use libmultipath. That library
is very heavily based on the NVMe multipath code, so the change over
should hopefully be straightforward. There is often a direct replacement
for functions.

The multipath functionality in nvme_ns_head and nvme_ns structures are
replaced with the mpath_head, mpath_disk, and mpath_device structures.

In the driver we have places which test is the nvme_ns_head structure has
member nvme_ns' - for this the nvme_ns_head list was used. Since that
member will disappear, a count of nvme_ns' is added.

It's hard to switch to libmulipath in a step-by-step fashion without
breaking builds or functionality. To make the series reviewable, I took
the approach of adding libmultipath-based code, which would initially be
unused, and then finally making the full switch.

I think that more testing is required here and any help on that would be
appreciated.

The series is based on baa47c4f89eb (nvme/nvme-7.0) nvme-pci: do not
try to add queue maps at runtime and [0]

[0] https://lore.kernel.org/linux-block/20260225153225.1031169-1-john.g.garry@oracle.com/T/#m928333859c0320e57ece0dfcf4ecf58baae3220f

John Garry (19):
  nvme-multipath: pass NS head to nvme_mpath_revalidate_paths()
  nvme: introduce a namespace count in the ns head structure
  nvme-multipath: add nvme_is_mpath_request()
  nvme-multipath: add initial support for using libmultipath
  nvme-multipath: add nvme_mpath_available_path()
  nvme-multipath: add nvme_mpath_{add, remove}_cdev()
  nvme-multipath: add nvme_mpath_is_{disabled, optimised}
  nvme-multipath: add nvme_mpath_get_access_state()
  nvme-multipath: add nvme_mpath_{bdev, cdev}_ioctl()
  nvme-multipath: add uring_cmd support
  nvme-multipath: add nvme_mpath_get_iopolicy()
  nvme-multipath: add PR support for libmultipath
  nvme-multipath: add nvme_mpath_report_zones()
  nvme-multipath: add nvme_mpath_get_unique_id()
  nvme-multipath: add nvme_mpath_synchronize()
  nvme-multipath: add nvme_mpath_{add,delete}_ns()
  nvme-multipath: add nvme_mpath_head_queue_if_no_path()
  nvme-multipath: set mpath_head_template.device_groups
  nvme-multipath: switch to use libmultipath

 drivers/nvme/host/Kconfig     |   1 +
 drivers/nvme/host/core.c      |  81 ++-
 drivers/nvme/host/ioctl.c     |  96 ++--
 drivers/nvme/host/multipath.c | 962 +++++++++++-----------------------
 drivers/nvme/host/nvme.h      | 117 +++--
 drivers/nvme/host/pr.c        | 205 ++++++--
 drivers/nvme/host/sysfs.c     |  84 +--
 7 files changed, 632 insertions(+), 914 deletions(-)

-- 
2.43.5

