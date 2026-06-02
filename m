Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E73F279DCA;
	Tue,  2 Jun 2026 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365524; cv=fail; b=vEQlVG2nHrF6iwAwrXRhq4JvVflR+Pj/HsYoGFGXWL4hbXOeVDjd5LPQ6fbJfRlgg75cG09A/NU0Fpu+PdZ7mW2mt4BMIXmbLFHFweSQZz89M2/ZPFW1METo4Er1vzFevMlCzFtZYU4P1JpZLQ0UnqLYGE4acc7u2RSg+f8cMA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365524; c=relaxed/simple;
	bh=ANCfuxowidGsZMZOegu7MuCzWDbrXpQAAjOtHR6Habc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FufpooDJffgT7gA1pxlF2gnNydEvjJzSs4oB2bm386xQmtcxf3XIbD4hLolSSPfHWldQrg4LsBkd3H/3zp9yepMCIkF0GeVmzmFbqfe3KIZgJ7ed4ginP8WyknWkLIUUJ6+Z4NUkaTsvcEI1ALzWCk11zhOFFJShEzkebUx2evw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=arjVzVB8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dGJTteNT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="arjVzVB8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dGJTteNT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gu2K0942211;
	Tue, 2 Jun 2026 01:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=s+V0e659NrKPGoXeQV
	AWSNwU7NmXCQmy8uqy+Nx1KXc=; b=arjVzVB8y3iD7qJUmHQdWHAuCrH3Fkxv9o
	6LICmkEdx9RxndZb7TOOqaCeVt5vnaAznAfA9BM7RDELZTBuXjMUK8wvaxxTqe+8
	BTjHgS0hLNWhvar1nLQJl+WJQw+N1vJT34x+JUfsL58fwbCneRsDVWXxvRZ6LCkM
	1M6G9VMI9626A2wxnoFjlerDdN8G8My4FKT59aV8i78i8y1cp8rwDgwyGFGusfUV
	V7nX/uN205wGcS7yrj5vZFnl7K/3BtuzsyUX9waOnCsfHxRvkkG+uO1bTHcrO0Z5
	Kuf4nLCjC8Zv1j/WVsPa563TV7861TuFkRDSsYTSz+/91WDFWU1A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqgru7e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:58:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521thMA021254;
	Tue, 2 Jun 2026 01:58:26 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbqk3xb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:58:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5qNTDj1slkDUUYulq0Uae1FKVvCZTRjAKKfN2RNPcpdQlepSw3RmpLsnmO12pQyTREt6ubiEkKzBPGMSER1c1jCTffTI+XpSunS0rtnoXGJEE/7lw0lwXtOyJm+waYqQ+6hgXu1DgKmkeuMUOXEbZsnso7GzwBXOcUNgcf9P3aTYvBEuetxjrVJdjdAwGgPXwUSG9VbCI3PXBYATbK6kFVefW0GfFij/JK8xSgDTnx/D7f5kjfciA16SSGLU46aTuWhnNNZ6kyRwEpvDI0/fg51EQMvTEWq2EezEZk8eUfzqBAn8KO8tZSQDLa4RslHq797eKJmnZIpKRWTVsw3vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+V0e659NrKPGoXeQVAWSNwU7NmXCQmy8uqy+Nx1KXc=;
 b=O/66QCi4IwSjdg7595eACtt3yvtPgI+kFxgawB/YJs52DjtkBZKDTrS6Nxa8PJx2seDsFcCJMiHRFUmNxqg8gtjpRG8G7YxRnPk5BUiv1UeYT5F0nZJ/hxKSua/xnnDgcfGlu8Ms8K8ZBbOTa+EAqx0HxbxnTHT3Ln9qYU4xMJw0Cdfso86M7xWPAMBIiXfkW2SRysk7/XwxnttkCLviGKOUInnL2DrVpxOBNZGg7VZ8SJZ6PhLhewC4pKnbn/mv6ymCA/sV9KDeXWzX1RhCynsy4ubNHo378cswtN1vYHa/+HklN/gvYtMXZzZ5e7kVyDxUbGeBb12lU+0CiyYwpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+V0e659NrKPGoXeQVAWSNwU7NmXCQmy8uqy+Nx1KXc=;
 b=dGJTteNTkp85WMN7V/sTUGtLnvL+zN//GpUKrzk66f3bY5yEqbx5EMwLBpRlk7btCcdJne7vNLkG8pZNSyof6p0Rv6+8TSONYXL9YHO8lebgmKiUgHG7PE7guJv+7aHEPzUWhMWhTFyynseG3aEGxwN/X+aH4njNKzLBeshWGak=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6729.namprd10.prod.outlook.com (2603:10b6:930:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:58:21 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:58:21 +0000
To: Chanwoo Lee <cw9316.lee@samsung.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        peter.wang@mediatek.com, vamshigajjela@google.com,
        alok.a.tiwari@oracle.com, beanhuo@micron.com, can.guo@oss.qualcomm.com,
        adrian.hunter@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: core: Fix NULL pointer dereference in
 scsi_cmd_priv() calls
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260529010739.295391-1-cw9316.lee@samsung.com> (Chanwoo Lee's
	message of "Fri, 29 May 2026 10:07:39 +0900")
Organization: Oracle
Message-ID: <yq1mrxd9006.fsf@ca-mkp.ca.oracle.com>
References: <CGME20260529010749epcas1p2bf38209e55149f0681550c220e541e92@epcas1p2.samsung.com>
	<20260529010739.295391-1-cw9316.lee@samsung.com>
Date: Mon, 01 Jun 2026 21:58:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0197.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb7853b-93ed-49ca-f092-08dec04a6c71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	XzLuRxB9lumTkH+oyd4YdVtsEYOr0I9WdGzucHoHMGy5LVJz2TfRZp9DQPOulqTmf7CnbTcPp9wvDzdC3BX9S9kq2RydjeuIcYruY0f0cvGB21LEWfA7NXeQ/dFnzcS2LbQanz8Y+pmT8kTmy/pQpzFQQCQIDOBIdyR2otAVQ3ftVY4MS76gLrReatR9+/F6Edwu648sghNlJBSllPiA3buCF0lmHQhKJCqb44X/sKZARru8HO87u0evIKRIuvZX0LnbH+DbS8aGLlCPE66zO8JaXDR4XHz/P1OGGDc7lP1hl14icc91YiGyeRWWLIE31179W7vw2HNhlLPZPpmloib8QXo/YKIJIpsfZl8eZh7d/cf/IpZh8uoq1BSr/ir9G5Xgbijidwdl2VSEhFyOHTPBxiDJH/thwR3yKwlu5S8cN7+AKQYeC+6Y+1E0GO3di0kaEeu3toRelpzk6KIjL2Eozd3FMShU/S4yGt/cKosEAA4Woc8dKaZk4Afy2RZQwT3LF6zQTn7lmcueXxBE8ePUhTlF7wB11vprET4ObskWw1NFZ8S5viZCLABIoaqlzZRFP2oMLwJQLVELCf5O08+qrRkt+TnqwL2m35FPRzNopJNVgTydDwqHnJksT4awp1E8oyEeiC9L9dnk1yb5Rrct5HDlXEKGi9QyD4gZ2PC1y4vEpuHMG2pDuwPxfhG4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hF95+i98+eq6HLMETjRYim+HDCKHXVvtYZn0+pQGrE6WUgYWGFApm+/S5Fsp?=
 =?us-ascii?Q?rjRAUAMVF1eb9Byit69iF871v7w3eehl9oJjirIx7VHZxtRXllmjzfT8CxXo?=
 =?us-ascii?Q?3ooM9XX/5gCeuIH3SYFoyc8FRWM78uQhPiO+5btA5cNWDAZXXAPAKOL4VFHa?=
 =?us-ascii?Q?PLesfoCZFD1nvirUrU/P3SRQWGKgc1ISTlckVX/DgXTpVTx0fKnG1CYyTI63?=
 =?us-ascii?Q?6aDpga6an8vG4mEztsk2DJle1F5JITjoEWadK0t4GOTzNfVD5y60bUZ/PXgQ?=
 =?us-ascii?Q?GMMbaC7XwcMhd+dclRwO2bkgk1Xaw6FCJollFuNLx2WLf2NFe0GKzHQNV6fA?=
 =?us-ascii?Q?xqsg9lGa9Np8bvRm1yCf0LygYPMNdWAyk5+mfgrLbHTYQ0/KeJI6E0XQb19s?=
 =?us-ascii?Q?Q9GGa1OpXNxOxQpssidlvjbyzX9Mxm5ac95WF9d6mCVLGRTVPv/sRolUYAEQ?=
 =?us-ascii?Q?/+Qp71JAsP0Lu0Ff2V8pJ+ut/4RtKqWdZF+XcC+LR53hA3HYt3UfbYTqU8zl?=
 =?us-ascii?Q?a7ovhHkBGGNkAuLWoBC52TJnIG9S51OMAWiAqev3VEgJtX0DNoYi9ckcq1ot?=
 =?us-ascii?Q?sjM7Pi2rKsreVeRl8k3VB+peXuSgOQLpZ/HtUBymfK3uR0PpNhip221UM3tA?=
 =?us-ascii?Q?uYL9QfxDi2twMfwFuiQhCvDUHJF2Qt2kkMFeXQKowLYjsULWe1Wml5x8Qo/X?=
 =?us-ascii?Q?xHWAuyQUYlfMpRXmbwsIvYo6k4+m50rRRir2S4YKYtb1sRGqJyWwdrLMn8zB?=
 =?us-ascii?Q?1ryYLPKDCP/2GBgY8nVhsW40lZvxNZSgby/1MFoQwbRBRZTWN6fFEybzh0bu?=
 =?us-ascii?Q?eo7kRW4DTR1MwpO9tItf8MvThJZeZ40C5iInmpWCRQP60dbNcS3iJKh6oqd4?=
 =?us-ascii?Q?EOzaSdHW5fQwSRWStFfr0S5MbediB6SGjFnXnJKPkZPIWp6yBZMIl0fu06bS?=
 =?us-ascii?Q?fEt86ErzBeUry4t6iTp0p8hDAkihKb3JjDCEqhZQjJigQ8pJX7XLONmv8VJl?=
 =?us-ascii?Q?cmRAlvhSvgEInRCi/HKBIttIKl+9eryFNQdEBBPP9uuwTP7y0dq6xzoU2Dut?=
 =?us-ascii?Q?zm6w2bovJbrVxFFm1nxLAhVBZ1naQ2WUGsrX80vZP5CZMsKXQ6OYiXntk94K?=
 =?us-ascii?Q?pnNdcbwlYze4/kbU9ovFcIVF84w7sSKZf6dLLB7KSRZniPlXsKzHLlKQLN9j?=
 =?us-ascii?Q?IuW6+yNKCGEzZ7GOgq5rTS55KR+muArepuTKxHEnr/0Q0zzQculrvY2mleq1?=
 =?us-ascii?Q?o3bc2l5E/Gq/76b0o9AptnCUz8WgkrAZQGYDUj+1AKOy2w6GGVYO7DqIn2ea?=
 =?us-ascii?Q?xhYlQXyClKQXlfBVexXmNhMLFrsSuoxHcG2rDdTbJrNudfX90gJPtEopQAYn?=
 =?us-ascii?Q?XHf2g6pWHUL966JGpfic6Zs9gxnMBuVZ/wrzprMILv1yLROrNxAAvy/z7m0I?=
 =?us-ascii?Q?qSKlFj8gtRnfmpoT5WQpgqRyf19Y/sE8ow1upCfxZJn5/aAhT1Jr2B110HY9?=
 =?us-ascii?Q?kCQKWvGhVlcTnwdHWY6U9x9FFFGGeaXd+2VtMKvnerEmNs/M00hH5VnnA5ej?=
 =?us-ascii?Q?lfpGz3M5WSMg1lwExKfcyNaaKNsXxP1dQww+8m16AUl0gh/sJb6Y4Gugks7Y?=
 =?us-ascii?Q?znB4CWZX5SfgjtBnRnQtj0N5lWtZruF9U5QCYUoh+Huo8CTpjD1jW5/LyThR?=
 =?us-ascii?Q?qJ2g7PD16NKdBNqQp+lnoV/zlPZxA2WxO2YB40PH6GEKo5CI3W5tme47Z+1z?=
 =?us-ascii?Q?b1DDvzL4Ym7c2j5U/o7782u8mD3Gc8Q=3D?=
X-Exchange-RoutingPolicyChecked:
	L5CZDybwPhOzBpRXMUQZC/Mo3pUrwIi1EwjpGeNX1AHvVcV+sH8wPx7SS0Xnby1qU2MmDUEMH1u2wV3GatPOgvDvcFpHrpzzhS3xh8CJjEo0FpcD355GS0wF+wpcZ/2MxCY2gD63oo6u9UQsYHAvDUwcPjBkhlNpN3Us5KAnSgB+a+e/YrCE1PwMhjlMV8CHdGaerfBq61jSYxFskVyL3K5xipTNjwhcCq2BYgG41WhSaoxVQ7V94qoQ1nNypKvM8W+pWz5h/qe/y0EFIrSY9FI2UvrLZkHUELz+bSx9aNM1mKyQ5I267tmiu66MVC9FEt4iYALbBl9ApdBvLDWVOg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LGkrbU67eCOzEKrPe6gBFd0rolOjvb6MTwzOiYNtnfO26y+5snYVPfQjOCFLJHZoTSst+1qH/QffBtMt6hJJUbCrkC74g2wwDK1XNraCs7FJ60LlmPKIIMD1LAKNy9oRlZZxCgqUigdOmVyQAOsJIOMjCYU9YD821Uez6A7A/4eWeiZ6TQiAVLdwVX866f7tT9lfj+qi0A/4WcOsaelBe2O/mygBi01roUUaBGjU/F8xWG832qpsoMqXjZLOmaogMlTknnr+kMxtm0ZDI8uM/1x1qhC+X5jfjwhLYkuMSaTXTo304+ry/Beh6Hmgijo6sum91TsoQ4jtbjzMqNu1xHt3iTiexj360FndAYlgp8pjQQTeC1+ZLfxdxTYfbTPMHsHQftdTo2N/v80ZdXS4vHdmhVTUo6LVwSwaEx7MJd7+gKJo8T/lGO2crncNLJyi2nsYPm5FQAm/tKrMXK3VBgOnbgxeGW0Jre68uxx6iCLmBkKGaYsc6gUhAqAPtgb+G2NAiYTKQOvB5ZXFlzRcuP1TwnQb7mNv7Ym/XROy+nRFtjPEvk3xkpNwtUzJ1DWauq6Ep9kXRbSIrxgoykGdJw9movfyWfOt4he1GkaAfQc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb7853b-93ed-49ca-f092-08dec04a6c71
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:58:21.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sNTojkqGGPPpBm2y7QXdynjIe4c0rrnpTLLuQHADMHz4RRjFmR4TOPsIfEXIiXhhpNUUf6ZEGDnJl4Y2q3njDtJZpNJUr3ptbxRo1Y4SKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=939 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020016
X-Authority-Analysis: v=2.4 cv=NLnlPU6g c=1 sm=1 tr=0 ts=6a1e38c2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=2xjKSZke_Td3YuyFDg4A:9 a=zgiPjhLxNE0A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13714
X-Proofpoint-GUID: BhmTRRUV2WiweKOCcT8uQRn7TZm1kupd
X-Proofpoint-ORIG-GUID: BhmTRRUV2WiweKOCcT8uQRn7TZm1kupd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNiBTYWx0ZWRfX2ShtH454Wpew
 xZL+xbAjWeD1sZEqO9gS2t4r7+/SX1D1FCHGymZKQeYcL5OZkyoeb9L6/gyPSluqmEKXz7Whjxh
 9J91ybAZXBh3L62wgmZUY+o53nxsTdzPbU1id/6RwZnrBRAdiENmDILgZRS/ZWA9GGCkNDt9Vg3
 s79eCr9pHnJtcfrErTFrCKWcbjRu9XGYniG+kdd92HlxszGle+fckNLWDF872FTDEAh2f7Ko4mM
 1XGvXs2RfoNavn/qntRJVkEzQ4hkunEN/kwa/HOFh5VvivxMyFJ+MQMT28eNkXaqpUzy6tdTQFt
 FLktDpxzQ6t+bp7euBBTJf++dv/5dlNn+pZQjLtvXEznkpiKhqtLQyZtdGUzv8+hWlkD12lVOGw
 kd0qS9K0ic6PWPU8RgaR3oM7sNghjHXlk6hbpI/uFHAo5/3tAiFKA6AsKW2cxbpLrbVN3d+a9Am
 XQ7aJYgf+ZPtOnendMxgy5fOIa0ffNrCHVG6QKI0=


Chanwoo,

> ufshcd_tag_to_cmd() may return NULL if no command is associated with
> the given tag. However, several callers dereference the returned cmd
> pointer via scsi_cmd_priv() without checking for NULL first, leading
> to a potential NULL pointer dereference.
>
> Fix this by adding NULL checks for cmd before calling scsi_cmd_priv()
> and moving the lrbp initialization after the NULL check.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
