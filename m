Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEB23ECBD0;
	Wed, 25 Feb 2026 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033865; cv=fail; b=k4IgKr2Bm42sOWcq+OD0AdL1ARLhwT5Q692xLafRYrIp1n7CUH4rpSn7JEESZQKLOsgmvLM949v8JEjz7IfHaqViZe5L6ao5U0umCRVVmUSKxUeuc5Q9QSD7WfL4KL7EC7TZaJzJ/fR3PoZGYApdND4F4gCMHmjhpRiJFr78z7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033865; c=relaxed/simple;
	bh=PRr3PwGJ3y4Kqy1EQDD1M4hJnAGzNwoud3uZWJbvf+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ux2I5wRJbTekOD3TiAXCTCZ9jdacFPDRaxsgp+QLZO2GcN7AxUHDwyv4jNlwW8IifGM0eqgpTeku1LMJObUhpWo4yFngMueIUotjPcvXfsbnwAu81JCoHgafM+7LeKd951NhQl4M5PKuiBcmWJ3+0ifx6y/U5nfXo72k1B0EJno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qjn6WdrB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dngvp0UO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qjn6WdrB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dngvp0UO"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9a3Mn4019369;
	Wed, 25 Feb 2026 15:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XpVfQQUl6D4mJyAvFI2vmbDFYz12jAkliBajXlvRlng=; b=
	Qjn6WdrB8dC/rgtCtIN/AfM4XoLglg8HJFfjItxh/CHMXh1AGvqwRvALaP/Zh4ep
	Thp6Gb5+ItkOYD7FURvRq3kj966+6JduoZFUazbrdH16YUJOXPqjalVNi67nkn98
	YVv08NuMo+GW1Y/34CisGC/qimNiR7X4EYqYuPIBpoDyJ75hnNoOs0tuHcTu4+Gl
	dKUt+T/0W1m98UxpS+ViuOlcnfMaFlwK0kBkxDUhJOvnNvJvejb+1FkSL0ZGmi4M
	7jGEAsRTGwHhlNV3y5U71PVv7YSNb2m5D/7OoDC2MYm79u1jFGeg+NoOXR8DnSyl
	xKcBvbZdK+bi/PwzG+onaw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a06h95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PESt02028497;
	Wed, 25 Feb 2026 15:37:16 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7hfn-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NA8X3yt1Ty6Qa5TDfqf151Fw2JcYMiUf/BxVCJIbKGkAV0HeGUqyY3ksL42vFaMrom3tlPbPUf6WVJZro0DL5eVr/cREg1PArIAOhYQFB0trupqLzb7E5qukXc71+Hwvf8hqDEz+MhpjWaj1Ov4bLwU7vxvMJ67R1nKQ7KTRN8QnZm15V/x6ztMNymvTHitKE8O+2IVESQi4ZhBJVl2giYGaZIFp8genHR+D0WgyQdv5fW7Ky+D55vBAZhUNyHfKlXlCqdlncvRRZySxOzh6bVoy2r+NmyD9+NddqOkokQLQc8WufkXXhRCWl8RuF40s9fW1gWbaWHrbwEFRw9SwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpVfQQUl6D4mJyAvFI2vmbDFYz12jAkliBajXlvRlng=;
 b=vSsEFj0rbKRSTccmV9ytmttbnPDl9jwWjRE+9OJjAW9CmeJFc/dty1BjKld80IkncOZ/ZPC3Fh9r/8W7f+n2u6WiHv6r0lZq+/jTLSNv/3o6T17sLJ7PshPOIWdf9B/z9tDKU9QN3QIfm/J4UKQvwr21KGvi1F3CWtlj32OvAPla3Zt9iw3PmG4TW6PTbeZwtOTfSxkYLBX3TueFiA1triemtbVozIQyp0uCtpNXSlynWrWIs7BWh1ZeBr2j5sea/0jtN0t6VghBjpTcg9n1z7X7MFCe7B44hrgKlETJZa10B3SDE2GvlqYwGMtR1ZfeacRn8J4p2I5JPfxYpKimtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpVfQQUl6D4mJyAvFI2vmbDFYz12jAkliBajXlvRlng=;
 b=Dngvp0UOJu4H90MZ3Iav3VV77wFlvQM9p8YdLjZGpZx1FZTGws9orvWOXyDpCMJq1yypSaTdEgumsouTHIWaD8gYB3iGapsHvzPWM3Dn5RZj2RQl3S6Swa3KVR3zl8iBxiW185ooRsnCY/BwgbTLnTS2NGbj0GCA7BwSVYsBXfU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:37:07 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 12/24] scsi-multipath: provide callbacks for path state
Date: Wed, 25 Feb 2026 15:36:15 +0000
Message-ID: <20260225153627.1032500-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0076.namprd07.prod.outlook.com
 (2603:10b6:510:f::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: 60c3d579-b7c6-4ba4-dcd4-08de7483bbae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	0TzCigxWLlsovZ4LzhlK88mjRhJUvK0fAtWu4HCYL9FaLGVo2cNHd8TXqTIPorO/zg64ipFOWGTkeQTDsQZH2OytE+TrunpD3MMlDA9DF0wtb8uLWD0vHalO+VyAWLxEuuaTWSNJnF813HWFpRpwb9kp1jybsSu4nmi2o7452/vkZQYozGiDdQGH9Q9bBs+UKiZDrp2sAfrbFynXKpPagPIMYjljQxcx9t7x1W6i+2NvM4v4oPlpnPWV2S/uGe8kFhi7O4M8gZYVqkN1x/+r//aSErm6D2FcFYortBJ4MrQStKr9s3E3QgV1bb6Sh6cyDVW/zYXAuY20l9nWBQB3V4+SD1x7OOCqzOV6FqK5oKeNHjjGjvVSX+3efjmnvwaRHvaRc2xsm4zXei2V0CycStWv26KxhsGT+psfoMbph/pl+ja9CbxFNo3zsUj89F1Bi8foqnpvy3clQop64liNRnMU1SEkI+moBs5mVEhIKUC7Av7rqZRMB7gVs4ctdiSTzkzJFaRmifwg9OO7FLpTiJeFiDuifDmZJJPngxyxhkvPRY+ol2ienagP0D/Ckv34tdv+vfnIcDZMFijRykfSMzH9Yb1no3Fl3FvYwupQHqet5ceTphzXWfmTrZ7oPKYlYGFx/8nUYbShrv3e+XA9JyysEZZIjDde67Q7WqMOlIb2NcZRybLHLUKV30uHsQHr+ILfopTSY9cubRgrKgekkTzMgo2wtVmea1u5svOSU+Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QwH7FfHdJRFOQkg2tL78H9cCkAZyGohUwlBu2Llaxwj8kfcwisblihmc8CRI?=
 =?us-ascii?Q?eD+ynEms+BRhGw+jQb7Vc8ShvNASfP7BQGIIcuvkaR+NltlL6FSA3Hz/2tD2?=
 =?us-ascii?Q?VvL53YX0RsfJzhBOEYpM18I2ninyhZ/7qC6ExEsUPILPTLnc3aT+hQeQXiOq?=
 =?us-ascii?Q?rICRLMOBWzI+DpjMPjSb+nQzL0AKImmT7XcvH8kr84RncEJtevO19r2GAcgE?=
 =?us-ascii?Q?EiYw6pzNBNn1lAEDu7yv/GYw+DtQv2+OPcLbk0h6piYy+v52qi37t+QEWd1b?=
 =?us-ascii?Q?/T4SC0rovLdAgXdaLk7DvGRoTejgUWq7hTdyNH8SK2eIPUoo1zdCvAHqR4ZA?=
 =?us-ascii?Q?mHAJfTdip9D5BI92+sb9xIyY1Hn8iz0QdtB+PaAN6r4PWu8EFsVE0gzfirLM?=
 =?us-ascii?Q?piFH1rDHP+4e4SuJCDCHTIguuzOflpzfX4gMsEoWHGOBGU900gujIvqjvaU7?=
 =?us-ascii?Q?mKFfD7D59iz2rKB1x/dIil5g2F7Z+axYQblrM/BmwUFT8lw2CLzj8ujQzvcC?=
 =?us-ascii?Q?/mgVVk9HOkmY7eetB48FPXISzyOjibwPgP//hQNmVSzHZzr6DqSODdMhrdPU?=
 =?us-ascii?Q?Jw587hUn6A+Pvsqw7VbDcpQsg1O2HyTh5HRxULM7HwIcOt9HtCs70LdhE3t4?=
 =?us-ascii?Q?OIK74rGyaCU6J+8v3NSSo+/IRZ+fQa6XC7JfEyk6+JmkH8kYc5XFNo4FW9Bw?=
 =?us-ascii?Q?zhZ7h7nG0njfC7KvrPs2t7rWxJOlpXYPu1KIR8evg4NW4GqgkQDMqxbjMawu?=
 =?us-ascii?Q?qaG2ybwfXWkpnHgiZqTaYuS6l9rzQdM2zHP43rXEUfHu6lV2h4WrgUaEYWtB?=
 =?us-ascii?Q?25xXQhb1XWP82m7mN1e4hSI0ZOzLpFlTFbNwmSS40OBtDzIcspo1IqSds5Db?=
 =?us-ascii?Q?gOCmBxBptD9LDwtAsHpiuiCe7gypwf0+X4qn12IgLcGRF9ylzliO/lWcvJPG?=
 =?us-ascii?Q?33lek+ZsrPUsV/rE1s6KyFPP0NpuPawwS2TdHn2Gp3qstKz8MqnworDR9Iqc?=
 =?us-ascii?Q?W9MHZYOPeBgRB/g8pPUCE6i3g27Px0ikUC28jXM3WsB6MAM9nsSCvlg1Ozkh?=
 =?us-ascii?Q?khGlXEbl/IF3eEyeZaMyMJht5Iyv0zd/9834b9knDjRc+l1FAsaTRWeQBSF7?=
 =?us-ascii?Q?LTT8PGJ+F4x4KSmQYkcwdKJ9yozww9sieioLFDvGEPCF85Xg2Gep7H77bn4u?=
 =?us-ascii?Q?KKUI5e//rxCS/JUm2ah84QjVwCjwQcueTgJi0E817wMtuBlpuAX4om/syOx+?=
 =?us-ascii?Q?ThyecIguAbsPz4UnnPJnSdwNul7OQf4bRH6gO+apN0B1vhZVZC1r4HcOTUOy?=
 =?us-ascii?Q?FMMiEu11//8D8bF2vfvHbzfDIazkEwTBgt9UloQCg20dymUnoTjabLuAaM1g?=
 =?us-ascii?Q?WujC9bkd5+WhixDW5siz9lDmsBiIfrlA9xELqnweYdX89zsehJ1H75jATe3u?=
 =?us-ascii?Q?JQExyJU5Jt5jeJYWQb7axf2IexZUQ7oZk4Fp8TveNPUlvvWtB6vdMQIiLw4R?=
 =?us-ascii?Q?bXAP76bG7kAtbuXqSJqjWT0V5mJz3BELpxi35Ve3n9AU9IYCE8Y0iIOzqcor?=
 =?us-ascii?Q?6q/nhMZ5imXhbFzsfD/VY5bk3stwQZySUgzvqkLl5g+r6t7OkWSgha8jbeRV?=
 =?us-ascii?Q?10kQwuajBfU+xdueSYVvLBBBiyBRXRpqd+4be/+COZjHv4kVXnTOv7GXrUGs?=
 =?us-ascii?Q?34EsEkG9AxRE9JxZ1SAFh5gu/gEgpuV4hofe8J8rS1gc4U24mSM3DPG6DrcG?=
 =?us-ascii?Q?F3tbxIkrBwx/gfk7APf0wWM+BGn7nQ0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bPHknMdMQK4H2WkqAf8rkkUMf6+R/OSv0psZz9b5xhlEBGPwYNiMCpt4vXQHYIzWCRHaGxW7aDyUF5+bBbHDL4JsCVd1uvC5zV+qUGH6kQpYH1w8B9mGVS+Efx7SHg6om7vb7F1rdg+RP4wIl/7VWJ9nqPixn+yMMck0ZDHoCm+9mBD5a25VrTUF2cp6dxOVNMo+ZRkCUkPhKmFtnFI+dLb3iLUhdU2ux7D5FzM5KptDJDR9xheSjLKPFOEk3H5+ULULr/ifQkjfpQgwenJJJsD2sppBTzMjw+3+VLJ5C8XMwkeS0sHF8G/kTEfTk8PB28rt7wdwGfPguJ3Sk3807QJv1YQebpxjZx/O68MeZHlFUZwRV//R2CHcNELTFg8qjipa4ZTDoK1BEcgPAlTEIhq7NhhXLGDy/uA5BP/9bj7HGdTdKN+E6KkJLiRhjCaHWXxYFXfQsoh+eKdcsT9EUc9Qeh2IuK7LmjM9dVHioCK45UXTBUp7k1GE3IGIgJKJlK4xW35PJadCpYWb0qpKiJIVehcEsvAnH7R50bMw0YKz+w9pPLKQ4+fJl7FcHWhvPyk/xaZzKScTmPmVghZ8e/vFDKHAhurkau2bUbdZiJE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c3d579-b7c6-4ba4-dcd4-08de7483bbae
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:07.4845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/OXQVL8YT4/9HGDyY0iyqiDjnqETw33WfRpsbb22ET28vDhNIpm2FYCvj19s5ZLJQpvN5XDqlp1HzFuKYKMEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699f172d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=DHJJM_rHgSnfI6yttmIA:9
X-Proofpoint-ORIG-GUID: jUfynJcoch2LDQ6Tw8AISP6EoUywWLkK
X-Proofpoint-GUID: jUfynJcoch2LDQ6Tw8AISP6EoUywWLkK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX0+QP0RRTMLjA
 o+0FUMFek+ouwKjhrlL8wJJw9uTAm9Hmk+WZ1mG9a4osAgXjxIfvdMl4uaC+39fFIMJ/vWT54z9
 78Uq3aVaGP3kiIbHOIgxnoEgwBRFqpa165m6V0rWsq8S2bdIgI4xPwu/CuvQD7DxZF+urE8EkT2
 JTtYmnAewFoLkXjrhkAGIuoCNo1BE9pBfzT/pLcmBJuMnNP7V1HLUKkPsL3TdJA4NorNGYVaZwE
 mSLVst4vF6tqcMeR6m2bhpzP/fbQSHYJP8X8xY1EqEtNWOhdD8wbUKB9ryrTsdvQHGZG0eFHMnI
 3BDVuo7LWkd/yWpkGQ2iA98gTHV4QBqo7ixmhrmp74MHrWwZZqOmQtCfrO9L9QrTA6wXhfxzNkG
 tSk/1+4d40CNJ+XJ2GI2gpKI/x1pSvrVuLvxL7CHUcNYLp5Vu1qyCOoNhlk2OgO7CFs6WqZwzC+
 QK5GDHeU3QvQk/XWFAg==

Until ALUA is supported, just always say that the path is optimized. In
addition, just add basic scsi_device state tests for checking on path
state.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 36f13605b44e7..6aeac20a350ff 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -340,8 +340,53 @@ static int scsi_mpath_ioctl(struct block_device *bdev,
 	return err;
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = sdev->sdev_state;
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_CANCEL)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	if (scsi_mpath_is_disabled(mpath_device))
+		return false;
+	return true;
+}
+
+/* Until we have ALUA support, we're always optimised */
+static enum mpath_access_state scsi_mpath_get_access_state(
+				struct mpath_device *mpath_device)
+{
+	if (scsi_mpath_is_disabled(mpath_device))
+		return MPATH_STATE_INVALID;
+	return MPATH_STATE_OPTIMIZED;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device, bool *available)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+
+	if (scsi_device_blocked(sdev))
+		return false;
+
+	return scsi_device_online(sdev);
+}
+
 struct mpath_head_template smpdt_pr = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.get_access_state = scsi_mpath_get_access_state,
 	.bdev_ioctl = scsi_mpath_ioctl,
+	.available_path = scsi_mpath_available_path,
 	.get_iopolicy = scsi_mpath_get_iopolicy,
 	.clone_bio = scsi_mpath_clone_bio,
 };
-- 
2.43.5

