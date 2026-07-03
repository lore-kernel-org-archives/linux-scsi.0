Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626D3BBFBF;
	Fri,  3 Jul 2026 10:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074680; cv=fail; b=P1MzcZUMr5mBT2w7ZvJzIHwnp+0F+VDD23gIKWL1DHNfsHGEAzn/ZF2GmaTODKZIYR/e/07d89POWy5Fhc5+FYZl/trxxfKlvkVf8epCCVO2iH9gFEimsXD3T1dwX2uqOMjXJu1DZm3X2+8lRxsi1e2wtDILbUNjuyyNg6QmZrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074680; c=relaxed/simple;
	bh=GLGsPIWindziOMkpeosfaT9+NTWlNxY4pL9xbGcltoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DpBqNkqgIpBDX0cmMDlnQzx3nVVwVVwck9iHlkhf4nwYV/Udp+q1eB/eG0pdlxGYQ1Gfcv+hJhSE+m5FfRQ+nitdUFjCtKM8xtyQU/fVRYvTIuv4yv95BM9Qh+Z4rQ7b2zlgftrOIqXoycd49X6GjeoYqe2j5Jswd3ThW2XYnHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iWJLSxl5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d40cnWqa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iWJLSxl5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d40cnWqa"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638ttQc3080961;
	Fri, 3 Jul 2026 10:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JTKGaZTHdkZ+5sr6j2R7mQdfxmK4Yvu7acTpFtfs7FM=; b=
	iWJLSxl5zxe8KYfZ4gcfGny5QsBsz8gicg3xd2zcl0Cn2xmnDwZ7w9Wg7fQ7KBUx
	p9TwWfKv5cZ0M8r1qFlmqTeu2t3eyureFWRWcPvNvHxdzMMG1WECjspsdum3zIyz
	uTWuS28IgMYPssORqc34FzfQ6XjQzCWTr9dT6vBebMCHel93twyLKIIUWHYdV0SV
	olj3mddARSXMpwS+MMEvrmUobRYEL2fw+GpJYubzuN/PE6Nbee0/8rDZstbG8avy
	pUWKJ7Y1QyZ+fORaDtoaJ3XHG0FyOWSwA5SnIrzSDKWYOKtJj+vED1qGAx77Kv9e
	+fddEXUZjs1vmckIGl6/0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS8mi013395;
	Fri, 3 Jul 2026 10:30:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvqe1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qMi+7nzrhxRGuMZN6DxWw5urLmLefbws+idrsnivn34ng8W3EL4bTIafljBMJGQ/em7+GlJxy71WnoZ1ki1Pv8hCY93KNA/SHKFVB9QpyO11dgehEOUUhj6pCD8sbipqxXewXQhFS5xDj2TgfJMdZ6czuHgxI/zosglTr5aQEg1Fakqy5ZxJzBAAddn9eHlk2kwcOXr5bw58ej2LrGMU1Scj74twT6tKlI3X1ZJvG0Bf6OLJrjqHjVRaxl3VklrQdgtVxVz40/VALK9W+QBGuUPaAVpcGsMpU4bLYU3r3UkbU9i7LjLtbLczRiP7g/eQoJXBHKa8XgRgJfzmOJfTBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTKGaZTHdkZ+5sr6j2R7mQdfxmK4Yvu7acTpFtfs7FM=;
 b=XeAT8Ies2OHi3ayZY7XwLo7q7mkx8EsUXb8hsVONqiCaIF1b2ug6Onw/aPybT9I4KfQeiyARjrzRNLwtOY1Wc6FtsOgkHHdy/oTXJVeSZQ2Mkx9+9iZKgICzkdu3Q9oLsKhb+yGygXp6kFgaVkAqFrPwFwSs9FX5W+QcLC6IuB6Jmmcy6DLy5+Bc5hShiSWg6KPNROYekNVVZaOuM+ukWEA4Yh0Nh69KPpYz3Dr7GWCnZTW4whN0iosP+5WHewMmyueWamWPUAg649zAnc1qPjwHMWoWCC1O/BeFeQ5x5XbkUcCM7jl6ivJfLdY1XdmnEuroGYtGst8qO5bI0C2kdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTKGaZTHdkZ+5sr6j2R7mQdfxmK4Yvu7acTpFtfs7FM=;
 b=d40cnWqaaa6Ij3ujUHTLlzh+ZrM92/DIqJ53f6Eol45CEAMECgq43n4JOqRqQlF5vStJCm/fOMQcuXgsF8ofdOe90bvYTml7w83SHWsbE47wn5HZ6BjQPWqwXzZPAfK3Nxno6w0kPMiQLcEwOdxMfFdq5KH6siDS4o9Jnnc+gIw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:53 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 05/13] libmultipath: Add support for mpath_device management
Date: Fri,  3 Jul 2026 10:29:10 +0000
Message-ID: <20260703102918.3723667-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0423.namprd03.prod.outlook.com
 (2603:10b6:610:10e::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 571b5e08-4799-435d-6748-08ded8ee282c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	XAyumTU7LGMtUcS4A3T0yf8TouIu8UL+I2YS+DjhTokTUzRihzOssFJy64gG1JqvZbN943Jm2U1vZUmx67MddMPCnnSiXZ3qN1YD4GTPe+yWpAG/xvrIyIA8WMmNxcNRjGQRAcYwWbjdlZE17WK82aMXJLAoEdS8umYjkvotFof8TGevrjPcq426329nKRarrUvkqBcrKCdqJG9XHphAfW2f1lu3C5uSNwomxkmBe3H8qayO/XyVlQEuBD4JzVw0chj2/UKkkN8GIjAemGIkB0sQCIJ5juZlfwh34pWUDKmtPVULHDIifPCFL5edP/dUxM5dncxyDzAdG+FDAH5dOpPWdL+UedkfXGK2htrDdcMzws2+KjXC+ySTuqay4WUoaY7hKnGlSBh0Z234i+WeRfjKDym6e5QT0TXGuqahlSbwr2JxNvMFrKs5Hjf8rbY3RPL+lGsUJLe2w71XPiI2z80/jX4jjR/hv0r9f+8AmwW7ss9S5RSQEHxa2TzO9EkLVqKz9cTRkO0jSa5em20KoVVErpTn8QaADGLSx2UL/CpEjwZe5F0yQlKlbxRzgrgdEWHcw+SI/J61bJkRHZbj2COSeG3dclEG4kGY1i7OtstNEBzC6EAiFtCTY8Eqyaba9pBrP0bJpFKbuqeYBf7MyXKgHMKxcqtz+QjR0ah9gHc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tM1A1X/Yd7QPkk4ou30jYsY1V5ClhErbNUf+WpbyWqim9SM03jckLu1LBu4X?=
 =?us-ascii?Q?oF8D6rgiwE+D+kt6fWQjg0EaACXwGIs9CMv8HvDqeFRWzy9FVvyBDVyfs28+?=
 =?us-ascii?Q?wR7fM2D+J2+XF9Ki5KBxZN3N0dkBnUozhjw6xHwHCqO2JXd3TeyZA29VcoCc?=
 =?us-ascii?Q?vsRfTcoxUhxzoUgnU2mcp+b5QXaFB5HbYpC06RO8DEJhiq+yj3GgHSw4NyCU?=
 =?us-ascii?Q?sHOv5CXlR+fPbLtCOMHQhRd+YfVZeyjhWSzfXvMsmCvvPDviBZoRuGfy+G3r?=
 =?us-ascii?Q?x4yyop2qsZVZ9YhH7bdwagseQLszK4hZyyOaVwVz7t0j8gO9OWac+ftBkIKP?=
 =?us-ascii?Q?YMEybg7dPvaHrUdDU6+SUS6x6JwodvG03+M8WaNx6yuCIvVwRJF0Yt1+ji+5?=
 =?us-ascii?Q?zaefnXqInyRH54UBPAV0m/YCtnOgq7IA4LKZMyX61YQkh0HyN6EQtEu9xER9?=
 =?us-ascii?Q?kVDrxDuB0QkdWVJsSXEv0vMe/ejcWsCxdHRYqj9ng1+ZYO5o+zOkMBbDxnm+?=
 =?us-ascii?Q?9bLiCJgNn2VivhSZTYOOfvgIFN1eet64Z7TG2KeBxNiNkWP5vYlm/eZkYW6N?=
 =?us-ascii?Q?2fbaiQeCKrSrY1LObYVSi8JbT/iHUjQEY9MhTLFyThaw6y/Wgjo9Bd9kB+Yq?=
 =?us-ascii?Q?VwHU3IMKMczA6xEr3ErRpEY6/XgW4mcejQhaAIK4FSnYMxSAA9Qct0YIi9Si?=
 =?us-ascii?Q?kK+pBH67UrWbT5O4lwo6cM6LChi4DjIK42h/OCx35zqlHx3w52euIyhnEuxA?=
 =?us-ascii?Q?QTEzVa8yc9PdO1sJNdsDQPAtBkUQPaMEygrB6I3TC+mChPuFrMusEK2Qt0PJ?=
 =?us-ascii?Q?BtqTidxSpDea7XxvUBnWbBpIiyAFcjKSo76AcjPBwb7za/rEKvPdfYvTzg6Y?=
 =?us-ascii?Q?NkG6+fqCK/7enF6ddR6UXmV8SpME31QArZ55QbbE5AOY1bbD0AzTv/XMIYgb?=
 =?us-ascii?Q?9Tma6ZCRzWKh6tKQNsA10/X14WhmNhZUSs/GCz6y5aROXWNTLe7iikClvZZw?=
 =?us-ascii?Q?d2wwybq9U9BfraochAGn4+H4nShYGe5Po7VJrsdgNDglRBvH18bdAgU48kSn?=
 =?us-ascii?Q?KKTFkJWNArjcCkNLLWFhed5xOIZUzUE35HmlqfOvcYVm7coat6W/dV7ed14X?=
 =?us-ascii?Q?jEulma3rQcmnXG/ZAcciJBD/BQqr8q5G2nJS+UNhIQF63BIvxgfymOlR7Nrd?=
 =?us-ascii?Q?3jXnWw1oA+bvve2EDeSxHRBVbzFBnhFySSxBpH2wf+CHkTWQ8BrY6hE/MN36?=
 =?us-ascii?Q?9XsKchvt94NiV+8U+L3zDB9dx8w+rTXsqthEt23trTHRWGvmQbGfXfCqrvDc?=
 =?us-ascii?Q?jEXsIr6dZKtlCedCNPStBpycPWvOdoYDGRB14Gx8uwoPu2ECB8rXjRmKmekp?=
 =?us-ascii?Q?+kFYJTbKru9rjFOS6MYtAdA+BY5PqWBoQVkhZSWhTqRiGrbTgSAuBrVxmnOa?=
 =?us-ascii?Q?wsnsSGsDdlhzeyRLo6rcURG6KYnWt+YlOUpcsTiryqc/wcdHs+Kbpzu7V6nK?=
 =?us-ascii?Q?HngDuSL2Zdf3C/ZxsVuXjKPNuuVkC4OH6fWtiRzb+BV20nGJO9+rUWgKsWK/?=
 =?us-ascii?Q?XsvQQxpbUsQnifdd6qwMUeap+hsEtHBvlRGKHFg4SGbBhC4zRx6SDPLK1Tyt?=
 =?us-ascii?Q?+ZrxesDscD4Qzm2pzFztc35ybPn06sy6S9eIAEwEx2lUVDW8HQpITX71aq4c?=
 =?us-ascii?Q?6sm1UcwM/9j0CFKTTA8V+fl7bMECgL8BsRRK6MlSpemPLiDma63SV1iw4Me4?=
 =?us-ascii?Q?xBpFlbPrRQJg9GNdArAFGjNb3AzC6J0=3D?=
X-Exchange-RoutingPolicyChecked:
	jjn2a4qlUT3O+JuYQynsWf+lIvELtGdMJN7ddCtyKgkOFwgjg8tNYfS7t9A+AqYaEJtwvPrJrNwiN8PWN2tAABrFp+nrNp8aTRPxMUZpd9ppp33QHBarnng2XayXnO1Kn60Om3Zcr8X/QU6gosFADhPykB4VeRE3Oxu2TQV0NIVqgcsjcgEzwS7HOQp0hrMI+iI4mBqm4pDWrzGwj80ZSbTqBrXGpZ0QcBd+Q4QaypjqXiCJ3ScJoSkTcRRP10WPjYWqQqBpauRk2JcbpoZz/3kzo+Ilm/MhnC0HBjuOhVATvlnXEBv//BfyKyQLn049chuaz/MKHliYhBiX8iE48w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	geophj4sQTyILcN0oOcxQoGfeqxN5hXKuTl8HznFhJn/QbUhmWgdy5EKNUoiOi4DXRZnYa8W9Z1t3vZyx2NqjmQkm3SGZjbEJq0sHx057nNrA9x6j9XnKyo+zsiE3Z4v6/P/jm0NjUIydkpdTrI3uaSNe3k9FqV0zn3s2d6EHJXOF0JDkPHHB+M3PWMPh2J0wMXOXnYOzkRPX5kM5g7mnM54xg9hx+tg4NMgix5AJOcVliKHbqKjDCAYZsINwy9yBrEgyFkYHZ+qd+gMr+iIV9YepFyfPMujT4Sdwz8yHeP55DchIvP4tNAY2cZ91UjNd2NhWaF/vnAb98NDyUfhsozOJYK+BiLCgrEmG1XjCVTEYKw4VSTsagZ+mZ2U/SSV0NMILNt0O1zvHf5JgBKqvW1E0V3KE7QQFAJ3UPGo80lfECRNN8rj7C+gEF3JMj6uXMEFr4mflc/rNWJ7hrnoSeZVMq/r47kt3em+sslnNEBpvKIuQo2QvIS3GFJztGcXV4cTbGMnflgYZ1uhUGVQCCzFgnhFVvSIMr1Y7epXiDlL1sA6lvxariztwXKv4Ur5ghVUobTMwQZSqGPuHl4UoPz0eF4QH+s1/P+q+n6tTQs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571b5e08-4799-435d-6748-08ded8ee282c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:52.5895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7wS2XDL9xq6vZoES7K/E4ghvICqrjK3OYlmCtHkXpftuZBRxDUfXtIvp+oxk9bEmHNwJz5xgo2BhsEHR3TvNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: ISc_JsT3jmzI_47hcsS1oVzAV3sFAkWo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX5hyV6+YjkEzO
 bTTdngnwlMV4kKI+fAo6PSL5OSZgKkLEjI/2L4ng/yd7GJY6Vt5LDk1EK5KfNJEk7uSI25mK9MF
 RqAwtJ1q6jGx2WQ+GNSotLY+aOEbW+SFi2ZwSsPEpG3EOtL+VrcJMCk4zHXG/Gq2wNDYLDibRmF
 8GT03MJ7u2VZl23Qa/hVYQnuiaNg/k7mN5vibmdhfYl3Oq2nK5Cn8triRI/SsLRs0AbRDpbbmXJ
 R7dobHlUhKKsGsog/MXpyRVjM2uKyc6pWFd6KuRtoZD9Al87OHPU3JcFUhA0JTNP+NwqdFiNU3V
 wrfcbeH1tLlKI9eUPpkAloH2tJQiSibZSUN4OnxEMkEJ7dxgT0TPyGNkcajVtZTsX6a6PHMyim8
 TleXfQFz55BbyofWiiuuOMfxezJaHx9W2/6klKmnwJUbNt0t8/oZSUV+vr6ib/18ipFpqDYCJw/
 Ne1n9p9RRYyC/32L1Iw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX2gjVq1T+S0p0
 R7BV4oJRyDgyo9CmJF3fxdj/iZ8pvt8HGnzb/3zfEv+/Lh7uQ0JBITcQlWDx8fgVWFh/5PuK8Uw
 2a4i2qsjLrpYdXcsQNZVPcaaASh9k95DH6QTj2lyQqN/bsOvJf/T
X-Proofpoint-GUID: ISc_JsT3jmzI_47hcsS1oVzAV3sFAkWo
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a478f62 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=ldRTlTcT5PaS6-tWTisA:9
 a=WmVTiCyuxqgg3mnwYu6p:22

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

mpath_revalidate_paths() has a CB arg for NVMe specific handling.

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Helper mpath_call_for_device() is added to allow a driver run a callback
on any path available. It is intended to be used for occasions when the
NVMe drivers accesses the list of paths outside its multipath code, like
NVMe sysfs.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  17 ++++
 lib/multipath.c           | 185 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 202 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 57d13eb1450cd..ec4325b77cf8c 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -20,10 +20,13 @@ enum mpath_access_state {
 	MPATH_STATE_OTHER
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 	atomic_t		*nr_active;
 	enum mpath_access_state access_state;
@@ -89,6 +92,20 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_device *mpath_device);
+void mpath_synchronize(struct mpath_head *mpath_head);
+void mpath_add_device(struct mpath_device *mpath_device,
+		struct mpath_head *mpath_head, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active);
+bool mpath_delete_device(struct mpath_device *mpath_device);
+bool mpath_head_devices_empty(struct mpath_head *mpath_head);
+int mpath_call_for_device(struct mpath_head *mpath_head,
+			int (*cb)(struct mpath_device *mpath_device));
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_head *mpath_head,
+	void (*not_ready_cb)(struct mpath_device *mpath_device));
+void mpath_add_sysfs_link(struct mpath_head *mpath_head);
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
diff --git a/lib/multipath.c b/lib/multipath.c
index 81e737c1ce469..007aa34796569 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -50,6 +50,118 @@ void mpath_synchronize(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+void mpath_add_device(struct mpath_device *mpath_device,
+		struct mpath_head *mpath_head, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active)
+{
+	mpath_device->mpath_head = mpath_head;
+	mpath_device->disk = disk;
+	mpath_device->numa_node = numa_node;
+	mpath_device->nr_active = nr_active;
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+bool mpath_delete_device(struct mpath_device *mpath_device)
+{
+	bool empty;
+
+	mutex_lock(&mpath_device->mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	empty = list_empty(&mpath_device->mpath_head->dev_list);
+	mutex_unlock(&mpath_device->mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+bool mpath_head_devices_empty(struct mpath_head *mpath_head)
+{
+	bool empty;
+
+	mutex_lock(&mpath_head->lock);
+	empty = list_empty(&mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_head_devices_empty);
+
+int mpath_call_for_device(struct mpath_head *mpath_head,
+			int (*cb)(struct mpath_device *mpath_device))
+{
+	struct mpath_device *mpath_device;
+	int ret = -EWOULDBLOCK, srcu_idx;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device)
+		ret = cb(mpath_device);
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_call_for_device);
+
+bool mpath_clear_current_path(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	bool changed = false;
+	int node;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+static void mpath_revalidate_paths_iter(struct mpath_head *mpath_head,
+	void (*not_ready_cb)(struct mpath_device *mpath_device))
+{
+	sector_t capacity = get_capacity(mpath_head->disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	if (!not_ready_cb)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (capacity != get_capacity(mpath_device->disk))
+			not_ready_cb(mpath_device);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_head *mpath_head,
+	void (*not_ready_cb)(struct mpath_device *mpath_device))
+{
+	mpath_revalidate_paths_iter(mpath_head, not_ready_cb);
+	mpath_clear_paths(mpath_head);
+
+	mpath_schedule_requeue_work(mpath_head);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -475,6 +587,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_head);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -491,6 +605,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_head *mpath_head)
+{
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_head->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_head->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	INIT_LIST_HEAD(&mpath_head->dev_list);
-- 
2.43.7

