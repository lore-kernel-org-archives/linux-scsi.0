Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79E83E9F9E;
	Wed, 25 Feb 2026 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034047; cv=fail; b=CecJcBshnfy+Sj+vySu9yRW7QwKxtRX2jgjT9f4hzIDotklPlR+tCn5nXlDRFXzgDSD9kFS7KtzQ8RLhSEazUEbu8eL1fQN28CJ2e29FHbI8OdhldhbMxchfkjC9wGaMDFBnREfhlasPLfWxFaGTAaz8YOqhpL5GVjJ8DsglEbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034047; c=relaxed/simple;
	bh=1TuSyjaYt8go4svX7PJ7YT6Cgb+iAsjqNvqojLUNCzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c6PdqSHNDy4IScOv9siDfqnqqISmiqo8gf3r+gjA8dpCX2zuRtSX0KXDHDWhwh3DEVkg2HfNODk5rTOa6FSo55Hd/PqZinaQZPafRPbzW+U5DB6cTL7NV6ipUYXPlR2iomYL8o8nS3ZJnodKoaLEcHCGzqPM9RxZOhyV6cy3fcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DoHMwwRh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sR8MR62H; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DoHMwwRh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sR8MR62H"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9mnO7553428;
	Wed, 25 Feb 2026 15:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nDD+SJdPeXSy8kBwX41p9UZwe5TP6F5b8bo8Fsa0BOA=; b=
	DoHMwwRhLafH6lg/1b3qsTZkfD4UZPyGhyQF3+gf14VNwbQlG5V72fSB+8AuICgK
	N1HpDRTthMP+bTUbNB2Kctn4LIl7zo3SOkiPxMEnFfK3HfoCxYIHhaqLd2PChwTy
	N+jBVGV9rF6+yzFNCLTVkpYPCevEb4q12FXZtdP0jFifeyOJ+pFSY8UfPbzCACGX
	iHvc3GXYK/m1YXuoTLVkNakSoyb7Gy5XYjMz6DYdghVSdHFQJCnDjwjj4lnI6pX0
	FPvbrASyrXjeNSyw4B9CpHoyood9b5g1MxQXSuWry2XQM/G8QJpykg2rWHZD/Z76
	ebZRKE8raZMUmaljOXQIlw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pgf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE699H027955;
	Wed, 25 Feb 2026 15:40:30 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35g8xgs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubaglernFDuZPGAk/dORoy3Ce8VDld3pfse6DGi8EM5N10ALkF0yUgM4HFMWxCCzg0f3ktdwkgwUMLSA/zoa2H30Jf5V6CgscbQYid9J89aUcChVGHLVDkqCsddfmhXyQpBXy1eHK3/na2KaOkDqiiPl98pKCAHv2VqjBZcmpupgvEpp6fJxlt3PfY0egluWJBd9veMoRjZGcDFHmwe8nxbnXoChzoqZiQdebLCbmbQtRAlYv0leJVXZJ86v5BCGPfk5zGw1aSCMLMzsbpwr14FTbjS91l2tnB1+NbgHmrRGO142B5DqMBaLRdv0e7JbVTTBWXeyuZTplJxJdtLPcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDD+SJdPeXSy8kBwX41p9UZwe5TP6F5b8bo8Fsa0BOA=;
 b=jw7AYH4W8klU5qTcUIm/r1r/phHxLxQEKuIQYI0UAEV6lVkhcp2/QRrOwMSAX2xtITLt6gNLmeZwmEyZEn6DpGTUAMbqXtfjLCkmnl6KJ7oGprzfHNHacVhM8Qakc7mDiXx6LH/RNa8ywBIjiUP/ilUPkXvekwvG3BpjcA9gjY3QxnhbZFTny0F0pBdubIm4nj3pHSK9VLFoYCXsgdRin3uVQF9rj/5tb59Areo5eewtLvFwd4aHPDOCWqqFEwQB7zwbJYUPWbt6zO/iHZLUqhnXMm1cVvryVocb50qyYqDs1WlUYlfVvhj/OIe1RK1LwPU1DhLMaCKK5k8aUicgEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDD+SJdPeXSy8kBwX41p9UZwe5TP6F5b8bo8Fsa0BOA=;
 b=sR8MR62HEvSS6WUKciOrWZxWR0Nv5ibBxeTPZC71Wc8Oqs5sUk3PsAWTN5mTtV6yrmfqKDqoGLr02I3NWuYVNC420WJ40yZg3Rnh4/qBHqGiyW6iGE+YnFpXqjBQZg6lj1cDRvN+QtpEM6WqBzfbiPvoBKESxDS/Pr4Swqx/ngo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB6319.namprd10.prod.outlook.com
 (2603:10b6:806:252::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:40:26 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 03/19] nvme-multipath: add nvme_is_mpath_request()
Date: Wed, 25 Feb 2026 15:39:51 +0000
Message-ID: <20260225154007.1033735-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cef83c0-50c2-4067-d30c-08de74843289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	pAJIEfS7Pm/Wl3GBakEoCZIIJk+CWEo4e1yTUqo8MHttskx2WPcdo3p+fbtbqMg9BLx3dD40Db0VxUk7IPka7XYNbJO9FzZzEIBtts08uJm/+GkQyI3YCmuz1yFQKYknDFcHO7E4bgXvL0O8wZkCcXJSvQOmw5DJmNHqWtG1qLwqCel5mnzVavoCHrThLzGBb/6MJ6MUQ/5jv3BODHfxvkQt7GBJ44UV+mAbj/EWHkKym5dr3/cjs9u3CwwQ58Hd+tSHo1vX4f1eCLewmH3ly08rrwlNB+MDRPFzKkrcJnfbgt+3hYk5JQ5at0EXQzI27piBmkyDs4H1KKuXQHJHi0XW+PRTcwtkKKIvvKN/PYXwKfXOngSlh1mq3jJcj7I7zMZWo3iBhx1KTuUZX7YyV8OzVoGrsVrSvL6/pJBK3PZW0k/rvcqLA2FgFPkg4Td2P3D8OwZTnlw45onrCqBj0lzdgcJcwtdvr3R5ivIzn1C2az3614IYQB3T9c+bGRfwcyvLGPUzTKcCKBOYhbEq/wPSztF642QHgyj4jms3JbSoXbwumXCqJ+HcQT09DgcOZ9st1PVhiNUg1MFZa7crthzQqrmgR8HZ5G235Sk1UhO92ucr4gokPlcvXrv58KzK77hjWzCFV83ccCoGyZlsb2xnA4e4iCfHxTuOYoEAjRVV5Yo+W0TCEq6DmyjVvku3AkVH7o7TFbkC+BsDBdidsjQNnq/vjYBhPTD7uRY0ymc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/Felf+VvNUZ5IuCEG4imZaEeUk4R+DkPZWpnyMvl9oXDkFaLV7DUPdh1WvOK?=
 =?us-ascii?Q?R5wcerc+dok7cLduQgpTPkYDc5JTEeyN22p/4vXgAGRzS2Q+oC/AUQlL0Ih4?=
 =?us-ascii?Q?/F4LmSDdKlVvUov46St28WcQ3gSKwUApF5Pa+LhNkwpSnfHIt5EfxSg+KXoB?=
 =?us-ascii?Q?iFff+7NammpdMgRIssoi0Vt3OJd2WDTfXwvlWI7BpZvB4gAkBCdXus0wgkIM?=
 =?us-ascii?Q?tI9LM1n+ZDWRoC0f4vvz/xWflNTL0Qrv1s2+XPAGySpfOTfSusEcdbX3TDKJ?=
 =?us-ascii?Q?bQZPIAJy7P3Mn1iXt+OLpc9U9wNh3F0omuNnNv2b/rWUv+d8q/tfta7SDoBl?=
 =?us-ascii?Q?+S5tfQjHFkG+WhC3jzOtfUb1sTUIpwVNMAJTXCXVNjEwWJvcazhRJNuHlIF0?=
 =?us-ascii?Q?7uTDrDSWQGKwnjvXTV1pGylv+I8pxu9xZHhspTectVRmWTmKcQhQB0PUdEbk?=
 =?us-ascii?Q?m32EYbDH87C+HXLPtGHUFK6EvT2ykZyk1RhbdMQd2HHYqsM9hwyz/gVnN5p3?=
 =?us-ascii?Q?Fm/CIvm+M7jXE1+cCq5RWxz3flbVe7xD7j3dqjuhegeCiOc3AogW6Qh/HOdB?=
 =?us-ascii?Q?WslTug258SYPFbvhGBsO2l6P0Ooos5N9z/hnJMx/QrQ9nWxtNQc6jWF6jIEN?=
 =?us-ascii?Q?dAEvSBqjRAU+xXmZCwHdXtDH0iS1E8F/pHK0mxSLirebok5oxu6OPitrEOKo?=
 =?us-ascii?Q?SzMHARbtiNR8LlvKYArrIJZU4gi59wjmtFUwhibM1522yHUCZhiiwnoFoSX9?=
 =?us-ascii?Q?yTDlyt/lUgm8Qgoq+kWCAQSxTAjQaJnGmIVBrH2tw2uX+Zp2u3stXkXz/cjm?=
 =?us-ascii?Q?J8a+WyetninRnGTsYAJGykUoB9oZl1kMMXg05rpBOBpcj5SN2cuo7KMLY98Y?=
 =?us-ascii?Q?JgfSXVhoxLqzPLChEVQytw5mn5NrUYdw4zbdcCjSwiY/pMMQ9ok70zEqlEKE?=
 =?us-ascii?Q?x3v9XG7ptZmFy+anPTMvxEHjyxVlDoTjZnl8vT4VnP7HqwUe+i8mF5qS6NkB?=
 =?us-ascii?Q?f6mkKm0bf+xfM8LUjXVQf5LrD6ZIqAtd8S7UjLm3JLhN6MUGg4TjV73fHr0R?=
 =?us-ascii?Q?lyOGs/IUw4pg/bbtUP8/MAAjpELg/Va/GERF/lNH7yIaDIUSmYGTAElWqs28?=
 =?us-ascii?Q?U1TmndwEjVc4VznntAJg2OzfAM4eKv/lF1NDiH8ry7RjNW82b+0cQyyEOhYb?=
 =?us-ascii?Q?NquCSkbc8vqjLBVeTPtTaodOydDadA+9+cAIjUIiljDShrFJevSp6351jGAM?=
 =?us-ascii?Q?UogsWobn9tRVQo66Z8Dny/Xg5BJqYVIUNSEMIKFVCxB9FTE8trjqFJGQ8QL9?=
 =?us-ascii?Q?CcYaluWLHc7mhhPv7gPdeTlAEAosbEGv16ctwd1CwTXrFN7dmFu5BFSDrb7S?=
 =?us-ascii?Q?HrkAmkD9kAup1gqQ+HiGgkrqhW0SZzM5R+gwegdiZ66feeUlvN5ao0A2pV5R?=
 =?us-ascii?Q?j42F+1kLnfl6PvwqDkviFxtynC1UJSGpY0nSsAAzYCbu9ctD39P4x7puXBQn?=
 =?us-ascii?Q?t1PuOGRwwurCajgGveN3Nj2ILy+23vXf5jyV7AbX9ye35R+O81/OpBLQUAWm?=
 =?us-ascii?Q?QdLgV3k2dsRpsoXBVIvdAsUmX6TR7JiQxgjOMQwk7nOZTrofxDsT696+RnY4?=
 =?us-ascii?Q?nQmPzETxmlFOUCl+MNgL0+QRDnyAQOsFkjvvTLPMkCYrv2iUxFe2hRgpWoqb?=
 =?us-ascii?Q?/HZLQoXipWb4WsQlsSc9/fGphzRUgI4LuH6S19LlYSuQZbhwhaUJ0zNSCse0?=
 =?us-ascii?Q?npscIBiSVhyujXYGs1IFgbB7uglMeN8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	73bH4UKx7lrpc1ztGTZvhq9OBtaURQcuMbEhO99QBJ+TuIAsocVo9mJnbcQ01eAUPyMQagZsWFkAfx/vCYC0FMTsugngG6U43hjEU86RWEgJtScTFFNtjrjk6yN/8Aosl3+jzrNFhlEy6fgYt63DkXWgRRE/vJIbJcJOu4bdzp91+0npy7MfzA1zIGLtF2clhgvd/Xc7n8WR6B+z1qdc8LPx9UhtEuZvZnUNiIK+6VuUvI85Mk562ecFWA6ZeY/WKqMS0nTEOh/vo2xV3506QGjeOKPdJF7qMql3MVtnLmbSaGBinYuMuAIYBTIXw5V2hKIASOUku/y/7iEXp5sCVqnUwN1mus6fZix8wlQzBohG5GcPaOCknznaBsOgizFzqn32tUaunnFVkJADPdTbN16dDb6t3fJZMMy6eDDBQ64LuD/pvwLAqmrLFImC8rqCG6QB/tgDBT9TFo6PhSbOssIDI5jy97QhZyeLk9uhoOJWi6l3tLlfr3kytpUIRORvNeb4uWvrS+eqx8V1OuLL5NkBcWINi3eRD3CPqRn7RYpYoQ0lrL+x4TsRg/hF1DdXrTVGhmydGhkNoDLnhYtYERI/4puNboSLXAYnoX6L8OY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cef83c0-50c2-4067-d30c-08de74843289
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:26.7640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKSZUal/eY8KT1hic1lHNKOo6FsMvSRC7NryizjihBoNvS2hHYZDweWXhLZZEqBRpZKHQY7ZZQ+SmMBcFV/yrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f17ef b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=k9v3cy8zUit5vjCvc-wA:9 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: MAp1_rlE5hZPkmR1ZBoass3TxSRMD0fK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX8WLRFuk+iKb3
 GCxqRtQkeOrtcRIALFi3LblOTi9ZHbJYtD4NL8ZtauSY99IIWbs44lb/Er/cyMV6zaSQGh2msl7
 ixDyL5ZZH7HvXDOC+gBNKLiOGBf4Z+POAjJNalL8lDMcWQpA1a3yf/JDj7ESkemuWuZKnLyPXMq
 Ql/s0gfNpHDoAow6rZlJafYmvbHnfKWROE//WvazXf1eolcaJTS0Idgha3TZk2fCWwwxskDTza7
 LhDYfre4QzqKwGOl7mmdWHcXeUaiziil7Q3jmcE0vFdh88OobxgSDw1pIXyKc8oFdKu9PCBYr/n
 QdOI1XxGtE+dZeZd7sxT8DESeYXhXAIOE7mt3GGi+4RHKw4Ag46lnFzxl1bAAPGSFXld3lEV7Da
 TbEBUjoMF/pqo6bUthT7agm1090R3eUyQBD/eREvlB7qkzyGk++ptvUqXxEVRZ4uSbXis+gW/7g
 veiNGFykHiyhuLKYlZvgf20keo8GjCJ7wZyxrL2U=
X-Proofpoint-GUID: MAp1_rlE5hZPkmR1ZBoass3TxSRMD0fK

Add a helper to find if a request has flag REQ_NVME_MPATH set.

An advantage of this is that for !CONFIG_NVME_MULTIPATH, the code is
compiled out, so we avoid the check.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c |  6 +++---
 drivers/nvme/host/nvme.h | 13 +++++++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 76249871dd7c2..2d0faec902eb2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -409,7 +409,7 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	if ((nvme_req(req)->status & NVME_SCT_SC_MASK) == NVME_SC_AUTH_REQUIRED)
 		return AUTHENTICATE;
 
-	if (req->cmd_flags & REQ_NVME_MPATH) {
+	if (nvme_is_mpath_request(req)) {
 		if (nvme_is_path_error(nvme_req(req)->status) ||
 		    blk_queue_dying(req->q))
 			return FAILOVER;
@@ -442,7 +442,7 @@ static inline void __nvme_end_req(struct request *req)
 	}
 	nvme_end_req_zoned(req);
 	nvme_trace_bio_complete(req);
-	if (req->cmd_flags & REQ_NVME_MPATH)
+	if (nvme_is_mpath_request(req))
 		nvme_mpath_end_request(req);
 }
 
@@ -762,7 +762,7 @@ blk_status_t nvme_fail_nonready_command(struct nvme_ctrl *ctrl,
 	    state != NVME_CTRL_DELETING &&
 	    state != NVME_CTRL_DEAD &&
 	    !test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags) &&
-	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH))
+	    !blk_noretry_request(rq) && !nvme_is_mpath_request(rq))
 		return BLK_STS_RESOURCE;
 
 	if (!(rq->rq_flags & RQF_DONTPREP))
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 397e8685f6c38..6b5977610d886 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1042,11 +1042,16 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
 
+static inline bool nvme_is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_NVME_MPATH;
+}
+
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 
-	if ((req->cmd_flags & REQ_NVME_MPATH) && req->bio)
+	if (nvme_is_mpath_request(req) && req->bio)
 		trace_block_bio_complete(ns->head->disk->queue, req->bio);
 }
 
@@ -1145,6 +1150,10 @@ static inline void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
 static inline void nvme_mpath_default_iopolicy(struct nvme_subsystem *subsys)
 {
 }
+static inline bool nvme_is_mpath_request(struct request *req)
+{
+	return false;
+}
 static inline void nvme_mpath_start_request(struct request *rq)
 {
 }
@@ -1213,7 +1222,7 @@ static inline void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
 
 static inline void nvme_start_request(struct request *rq)
 {
-	if (rq->cmd_flags & REQ_NVME_MPATH)
+	if (nvme_is_mpath_request(rq))
 		nvme_mpath_start_request(rq);
 	blk_mq_start_request(rq);
 }
-- 
2.43.5

