Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F6D46E01E;
	Mon,  7 Sep 2026 10:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778353; cv=fail; b=rWrpJDCPS27QBI7Ms5KQOvhME2B3txV7X0CPIsbR+/KvwxHXSvgeoW6YQKesUD/fv+kv7Zc1fTBC2zDncDL0HDWPirCLYaCCwFZCvepCDxuI9ZX6bZUMNx4px9tORvJmzSI+gqQAqz16+IvzvSrWoJjVE6ERBrM+zWGv9iWkjyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778353; c=relaxed/simple;
	bh=3kQ5wGmpiMXbmzYcyoLmkdWJAcvfxQA9+s3fFoZAYcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qZPoEn+FAYBBRPo3DC6Au/iJazwb44GxNyoX1AnCZJL5Tq0imR9Fnl59G6mjfV2gfLnfKireTT/D+Nsr6o3dCHRgsBPPRlhiZOA2sEvhZS4uoSreNlfF8A+by8xSprbQnLw4lzpQ9mr5W16XYq/EPMrofOIMhAf/3YnNv1Q5NEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c4T7tv0m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iytVOfK2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4T7tv0m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iytVOfK2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686NwXa5204422;
	Mon, 7 Sep 2026 10:52:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=q5+wnWtZksiLnCsRyuF46mtXFSwYP0zk9KyArtkM0dQ=; b=
	c4T7tv0mrZPxp53lv3Md6i4wrcfRjPGGFE/+fmmTCJhSJCrcGVkBZeLw7WbKb8SZ
	FEfPbL33EzT/UzMdWjp5FoFLrfkVc8vWD7mFHd2grbkTsTd6Qb3pj2rKwl2x7zIg
	hIi6fLgFFJm9/cIjVz8VE2BpxhKl55aBwpARMoKIK0iUblVydmvK0UR2uS2UAOkz
	nN3WqjhA+kx9YAVkR0WyFZItkAmdj7R7u0PxOgYnMBmB+8WKMVYU62fvn+sk86lS
	/1M3ekz3yt4/d+OnvQygPQLyZ8CxSNlB81o3QhWho2/3AvDrL0qEp3sSuGfpap6N
	8hUcRJFYLO8IBqFp8UP/3Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbhuht1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:52:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687ApfQi029304;
	Mon, 7 Sep 2026 10:52:03 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh7aw8bdt-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:52:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzovI0hnK2NiXIdBUGufnfmRgwxXY7BZ9R8RaFBODVjr1sZBxBfh1qXNIp3KlultBSVp2L4+B0YSa5nx/b3z2zV+jsl69iDmH4tKFW+u9t70S/jT/w+/trj83ihSP0EVK37At1Egli+wRJvQRNgDmTsu74mB/pQT+iJ8MkM2BBS1210YIR35XvSIRzBj/sz9v4k/e7GFHv1X7OVM2OpRaw2ph3yIR5vIHR514AiRzCHiCzDkjfypeMcCI4w9bNlwtVwa6AegQqoN0V8GO/u+ZFsoUwfxYuYcF7sp0p3IagvnRBny4BqeNQTo4gM3B09l4eCnC02qB/WaeoI+hrNw6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5+wnWtZksiLnCsRyuF46mtXFSwYP0zk9KyArtkM0dQ=;
 b=sYeAvbKdvwRuq0xLZZb7N66scFazbcz7V4R6nmhxkFXUb3aQqOn6ppWH5GsdD+I+pi7kI4ni5LCpQA5YkKiiu8Dfs6t63CUlQy4TYVIImOPeT+DD6J/B7cVgDHXUCttxieDRMUYFLjvDM0INACll/Zlo37d+QhBdXTxhbd0IQQj3nC5Q/l/jO9PHyg8fIXWRr4tGMnTYgou8tKFnOZB5vYlpVWZXuxK7ERVMvDS1wCgNgSGv0/nKAr1aZhG+9BKvVTafYVB2QdjQhhQvnXHDwrVbr2CjSeUrLVT3hh1LVDjwUALtjk7+vpvW2kDwthIIzK3Gr8WNxbhkSUR8NPfLaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5+wnWtZksiLnCsRyuF46mtXFSwYP0zk9KyArtkM0dQ=;
 b=iytVOfK2j4UNq/SFU8nEqtUe24iqeB7XqgFRIpcTa9dd7pzEykEvCV35tYwyOiiwEFXICzqDS+pF0wP2vvGr7j1zOnQY40u+RSJc5B3ne7SennmKooLWneWm9WBTwK8ig+E10AQL2PUUA0Bj3kE24ytAxUSf2Hy6GrtcjgSzOTA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6276.namprd10.prod.outlook.com (2603:10b6:510:210::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:27 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 26/27] scsi: sd: add mpath_numa_nodes dev attribute
Date: Mon,  7 Sep 2026 10:50:20 +0000
Message-ID: <20260907105021.1763236-27-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: 9509cf4e-b103-4c1f-23d2-08df0ccdf75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	rdwAU32vxIfdKPmJFeh0Z+1i5TaEu3YZkSHmaqLfHqg3roKqzt6/KlfuLpeXVGszJrO0HTRGuBKgYZNbruOLom99PxhoF8RjhgDIaumtmmh+6DcduBV9wMWBWHYq4r0NNnhrYBjZZmoofoP0jcx9CZhcdoRw2EFH419FugKL172WTcRs9akyqYZv9Ryb5Gwuu8ytUqgzQQbppv2MVXpc3aiw3INS2RhSKxZ6XtA1DkB1k6iAWrSjj3RMrKVvj9znoXORMFha7a5I2zwEZyVK09eGnViPhanWKwEPL/hT3qGUxaYytipM5qUrIRrFge5As21/dP+UsAu1E8of2xolcfSuPKJr/Zl6Gk6AAutcRXDVl8Pg8nF/0QBBIVMQXqmGXprZx+H8ZJVkT6WcAqcvSr4seuhfaJG6miML8dgaXt4crAFjNL8DWh2OpPcMKndqK5VshuNhBShZa3yFB/ufSZt82624buuXvHIj2Dt3+mrolY8eh7Pk7VHQxw521SNFX7iSasQKQp3OGfaU9hV0/b/Y2A1V/4zEWpciQtwr1a3SBoRQCPkBvPCJtnuZB7W6v9Vh5nQAWSr7mTbVvob6l6hXRovgYx1ayKG5DwY0ixFrvn3TQIMyX+qSyxuxiaOmh8+nnJqmdeGK8jPflDnaPcHZWacOIahppggtE/Dhe0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8F6lABEzcswLl4Xix6J0Z6ACx1L0p5B+V+WdNyzZ9ZEVdipYt5jxZ4wMNREb?=
 =?us-ascii?Q?h5BDQMinTxPu+oxPiD5x/mDijWdC0p1ifT3aSuJt4ShTXe6JPEURyu8gDDMT?=
 =?us-ascii?Q?7KALecJtbVoOZ+RCGoNODRfO1I9u3uPArQ3C0xHFzk+ifsYtvL6XVBM5zP5C?=
 =?us-ascii?Q?gNt7rvChlLNS+lh6y5n6oSgSEhuVGHcLoFZiS+0azOF3RGNDbMLpD6QKE7PU?=
 =?us-ascii?Q?Xu5uNLVCjf57Y3q/JShB9HyyzqKjGGATO14g5Rx7qhefKSJXBphZQ03As+vJ?=
 =?us-ascii?Q?PWb0ahmRU4EVMf1JFKe2zmyyEZhsWdMQqZZkyzF7tSTWHw1TsL5DRYyW1L9G?=
 =?us-ascii?Q?2cViFwaZOC/UytX0Eq9jy6M9q13C2nX8jLyt7TSXawqiEar9DuxQ2s4mmm10?=
 =?us-ascii?Q?O0UDfA/T+xqPxXcuA05xxHmIiDuNMj41C+j329H+2DEHeVItEz57sarc5MWk?=
 =?us-ascii?Q?JquyTBqonVr5oVUTk5zD5V6e6Ntyh7tBT39pBAaEG4DpYZl6Mrlq4wS4CsKt?=
 =?us-ascii?Q?fAS72joX70jFPTPGV6wczFRt7IS8KuSjiXDV0injWRAc45Ckb1A+UPf4xiWI?=
 =?us-ascii?Q?okN3AgsFK/ObZaqWJvu5KKlFPXg0nVLb+z1pv+9JmzSny4jnn1HEHSsD54BD?=
 =?us-ascii?Q?L2MFgetP0TslqbEQ4q/ipy0Cq+mzCkl9LkR+rC7Te2bJSfXPXDKPIjJc0N3b?=
 =?us-ascii?Q?Uj0B+faX9tm08/JpKLeuK4p2pdpSVxTrYtNz8OBxaEZsCC3fVJmqKxuJ0kFi?=
 =?us-ascii?Q?eL7jsgR/+ChPrfGOHG3nVluNefdbLeYpQKi6gj7E9woA4srvbX3vtwiUw4wY?=
 =?us-ascii?Q?o0CGDKg4pnnFuzrSFYdAfgsqVE/XQpMUXMONUctd+fBeROsCaYYs8u17WjPl?=
 =?us-ascii?Q?rHG9lgL4jp2SryFfS5U/Hiix3i8PdPWw6WaGYhoSKVI7QOMTCbbevcBcT0rI?=
 =?us-ascii?Q?/8FNg7kTUmXnmO23zlfEe88Am5BQBclt1Luph78HrBKiVm0QZ3Uf8f+fYKM4?=
 =?us-ascii?Q?ga/Us7N15ylBFHIl5HYMUJS8qbS0LH45i54TFySGAeNj6Qbw+UCgd2ypMq3A?=
 =?us-ascii?Q?1OhiAgzKuHh2YqiDeeWK2W/YgG68SHW4to9iQn62NnCt9lnEQ0pup0N+wONX?=
 =?us-ascii?Q?2rbovNqDL6zv70l7Wztlhp6DwwupFxqLn1cUa/zSyiNnqgBApVz3qNj8AMEi?=
 =?us-ascii?Q?6WT0hmG0aAx9nKgOF61IxiI1tTwDXBpd8o7dsqnHT6R4GRiXdZx3HrDe3jCo?=
 =?us-ascii?Q?p83MlzzDvqGSDhtyHcT8tQ0lMnOIHHgMc2HENgReOWpet2+blBStTD1WH3bD?=
 =?us-ascii?Q?iyE7L7gThyHoW29ZO1dLcWPbuedIuHNcKDs9TLKrPNEPCi9r9CzI+H0kZ0aD?=
 =?us-ascii?Q?lN3ibjhIPMGIGF0CNXDkTshxA2qQeCqYBRaycuWHzWUdShAHaRVhf/a2AUki?=
 =?us-ascii?Q?cjLuk9pV4+EvxRe4kBJC88MxCGyfemmduhAqad+cFrgcZO/3cqZtOpdN4QgR?=
 =?us-ascii?Q?KJIAlGnoCISWJgWmmf2+x02yVdRjL10R0T5/IwaxKV9ulDBcnWXBM/K0BsYK?=
 =?us-ascii?Q?bTDu/NDS54FD3nZgr68LyYXZPhU8u8nZyHYvPWUFP/5d8xWWyQ7sGH6XYOK+?=
 =?us-ascii?Q?XNSIZyR3/eVGkNwB5gjblU5VkkgOW3nebGvqHmn87qJHGFRXiAEkVkbqFlde?=
 =?us-ascii?Q?JsvMkw6hor3wfcmQUCcOYO8/pdkAIy6e8zsDDGgPFfxvtjvGXRzr1oM/2Tuo?=
 =?us-ascii?Q?Fe2KDiEYWQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	n3m79muPCwk4jALHgPrlyq0xuIkYBOs/KP/YDiZuqTG2SAOtin6mC1SSOS0YEnRbgZ1Z0Ru87A24sp0p1026UrGnyAPFoOUXs8jB5UngD2F4eoCIbmvP4Vzx79i3xuEurg20JrT5kAA0yakRamz712qDVOKVU1rzAqEEe25sslClCl/KQ2XyW67AtcGetDz8vBEF+QNSYpuhmnw2Zpn4XjGCBruA/1783puirMWbn8Qk+tPDrzbzA6aec7Fg+oOazJGOFxEC2672M4yF3OXaCG6hd2J+oP8QrHDxIhUanX72earvYHAQInNPzGFVb7ZZI4oUFYRJdM5+o5EAzMnBUw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5HxXX6ZhjpHeQElgZZuyca5aqb1OzZXVjq5rgM5pYF/C0wzUAAeZ4NcRYj3K+Vb2PpMmqQGaaLO7iwTOlcb8hkZbnH1E75T6Ca/spoFZ0uJb6hE+aqNDNWaNYhWbXWVX8ySIDSiIT6JVm51ADKUnQOkIM3ekQRe2g/s5Mxm7kvZA1zVMnHE3AOB4R5+mJmUjvRTTJXHq49AF5CawEblXBTIigfbvaoQGxoUwk2elocVjV8N1ZTDNM0Z6q/gEApNHMkOn3Fj6rncToM9ecHcdc25ntACtRN8QgoXflZRVFQ9g8dz6Cn9FDWJeni3HhgvOwcn+QX+OzIrWc/91zUwhl3zkBjkxNYQv/AWOjYZMeRM3PtZCgGPalMcEt9cqWHXbHnp3hXlwFID6atcwIjLStFsQI0VZUgtoVw/lDcASGa3w2KpEb7hfHCtj1kmbtlT7DDgmmePWEasWlmNsTCBkp4lf80I+p7lY8UB3iVB1J3HDhLv+L+U4n93PKMZd/y339ljDVaa3Nm4cEChJkezOu3UDnE/RWPDt+Zw3EqKU2IgIR/BAap66cPz1+zHcKgi7Gtuma4BW8lcltiN2wHbu/q0hnbkUj+Yz7jaIjwo8+E4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9509cf4e-b103-4c1f-23d2-08df0ccdf75f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:27.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Du5U9NyPqobvMRK4zGREvO7BXEtngajgU0nAQpaOaW9TUIPVWf9Ut0nbpmD3H9uEajtzka6Z/L3ot0uou/8bmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6276
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: _8ADFQZKzdhHfjGlPpuQiWxkMv3xUmdV
X-Proofpoint-ORIG-GUID: _8ADFQZKzdhHfjGlPpuQiWxkMv3xUmdV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX1omsdSqX22Lo
 /Xt3NCDUxsdlIZwq9NCE1B4ozxwKMW4TDvUdQp/K7E9j1jaA4s08QPXpPbBTKZEZ/C0ECiCjzr7
 p0MQihdy2CHQLEYPQ4es5QAOtxA5cMFIS1sHYgkt/Txo1ObH+yPY6i9g2sWCB0AeSn4sVGsJF5M
 j2VHPWIq8xMXdv2Rn1B+vMmcj0Hs+SCtkdxPcMkOwXiZgn0FZbf2U/rRpqC1/qjhDrKFQr6YhMN
 QpgwjrevvfNE+d6vVmjBdRBKVU5/+z5yxPO4Ru4YBy8MlM2aNFpM0/olHmHVTp0K2B03NJJV8rU
 9Z8nacet6lDuQfD98uKXV3HHAnG6N75xLoqrQt9EezDBdrrqwEWXZ8DMpILhn/+/DetJJSSAT93
 +KvYWS/5LMNXlVwmnjDJNbyja3oJYqOz+9xWsGQbrmucNdg96EimHtBRPtsIb3ZHe+iCIILLN2V
 syxnJRbFWeCVBKZIWt+XYG/4JzHmFZP2GtqPAsw8=
X-Authority-Analysis: v=2.4 cv=S4HpBosP c=1 sm=1 tr=0 ts=6a9e9755 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=P2_R26dytZ8aPJic-48A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX+tXWJ/4xyJvz
 oFCOUgAdbsFoCKFPtnSbqVEEzyPkiG0DRHXR/5hc+97x8UIz8EoPveSPJ+36qKO380OfJ57fVyp
 sMDFXnbPk6yAcI68Tt3Q8X9p7RlgBda7aJyEn0kagJMxll/qsnXr

From: John Garry <john.garry@linux.dev>

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f3062fecfcebe..bf02f14705518 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4163,8 +4163,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.7

