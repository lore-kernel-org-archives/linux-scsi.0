Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89F12192F2;
	Wed, 17 Sep 2025 02:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758074997; cv=fail; b=q2+KfpahuMh+EO2jAv4tytJ0Vsg/7wkkLB454XVuJsFv7X3JUwtvrJ2whmUeS/pz+dOox13P0u713p05oj4oBZ8pu3/XwqKcwT9Vy/RhCIOsziDRMU4LTLYDN2xbBunSTUP0cT3XpvlWfpS5vR8NYw8g9IRxB5BOoAic0Of1Vws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758074997; c=relaxed/simple;
	bh=XhTRfwpw2zWAiMuQ1PO2q5seiOtE+ascParWLt9QSV4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hRvX8t9EFFImVX4iz1dJeSiLE/uE3qFO2iwDm/cFbcUlJvajnsNVANFxKovCWwgkjfwbNd7fuDVKbJGR84SNxL68VVcApFwyB7/pDD4W6BNTGfXsTCe8tZSDggPMwkMzMuHXK9qRLNEx3QS+JaD6fl3FmD248kXfnFGs8mX3D3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fM6hRwH+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PU1dIYSl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fM6hRwH+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PU1dIYSl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLYwBB032006;
	Wed, 17 Sep 2025 02:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yMyOQFsnz0gEPyfJNZ
	wQ1P2CCpmpoWSJ34Plu7a8HCM=; b=fM6hRwH++ROSktd5T4QWwj1UEhd+RPBMa0
	8gsdhiIZZD/Yw30L/23kwoYRD85zc+MKi5SKtuzt3GJNHBxCUDXX+yW3wnxrDBmF
	N0S96Ev4t4EoaHyyfPDTwFEi/Fq5PKMECMd+PHVKr0qx7dEZu7cQmr/KpSg6PVMC
	Bk2VtD5egud1F/N5tvedkS/otkToYcmOOiD23pCoHpRi5BLarsx4dmeIWmw+Gakq
	MIkKQdTL6arwWUheLJ+FhAzIUkzGUAUxtvAgu/cLVRdPSDjhuAW1JbQq0/UfFYc0
	wu4uNa2+JT1Ro2uHIOg4+H+Nh2S0kNQN/6fsp/eEcLjgQLEay0nQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxb08s5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:09:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H0Cdr3001483;
	Wed, 17 Sep 2025 02:09:52 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dcwhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:09:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bk/gZjPVpVb5Y8MUdh7G+eVX/ZGW+85L1Eih03VbahiT71NEyWZC4JAkmd6s5tGqW61OpGuX7kw2VQZ1PDuNed3DmStzjbP167iWUz3YQ+LJvWDo03iNfGio6GlM0Z/Tto+w43EBT8HT/Q7xFeSstJot+AcvF88GcmXrelvTTyEnhDlnKGrrT9Efdoug5CphrJCVJINRPlbryiVKcUAI/sUbwXvbc3hUVtKrrCz6ZMV4lTikQokMwQrIc54ln3UeWBGhAUGRNWnRQ8xIa/74FIxYYBUETs/LEvHCJ6NcCyubNqSLNEjcSUcSsAmcSqcZthGnhisvhyi+V2Ye1+vlIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMyOQFsnz0gEPyfJNZwQ1P2CCpmpoWSJ34Plu7a8HCM=;
 b=y7w1KGDQvMDVwsaB4tNZPtARL3b+N3i1wmuhCjzBI7hvYjNc8wXzPbrlYCg7tj5CMUpY3e38O35MyASBjO6cMAih0cggBo7p7pAXZ69SHffK0rcnVoYTqg4hwGjeFkrh/UIdgdyC190GXhJLXyO6r6v18n/ivVuCVb245c0ZZw06W603HwCPAmBKjW8VbNwpkv4LzmyaDT8IKMDtWAoRYCzJiCL9JuRPtlxWcAteNn0YFKL9sVovCbYP4oLf0HvfCPFTIlPgUMkqWG3HdkDIzgXEf8vSpY8JcPE3xManM8rG5na6DE+/ikYySMGev6NVfU9WsrY703MoNnlkrFnTlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMyOQFsnz0gEPyfJNZwQ1P2CCpmpoWSJ34Plu7a8HCM=;
 b=PU1dIYSlPnMgrQYvtWL56OS73xUyrc2TJyWb3i82zl8iBJHqgWRQhafjApCNgFvqmcanLMYs2OSLok5ZEm8boLISaOtSKmdsZG5CwHnE4KdWLOcqM5Yjk1MjuHKNTzxcIL3YJSTCJnRBjxoXtUrjLhQbYDDrqu7nMz9nhA1FCEI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7012.namprd10.prod.outlook.com (2603:10b6:510:272::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Wed, 17 Sep
 2025 02:06:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 02:06:43 +0000
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI
 DRIVER,blamed_fixes:1/1=100%),
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>, himanshu.madhani@oracle.com,
        Manish Rangankar <mrangankar@marvell.com>,
        linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 0/3] scsi: qla2xxx: Fix incorrect sign of error code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250905075446.381139-1-rongqianfeng@vivo.com> (Qianfeng Rong's
	message of "Fri, 5 Sep 2025 15:54:42 +0800")
Organization: Oracle Corporation
Message-ID: <yq1348lzvbp.fsf@ca-mkp.ca.oracle.com>
References: <20250905075446.381139-1-rongqianfeng@vivo.com>
Date: Tue, 16 Sep 2025 22:06:41 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0042.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7012:EE_
X-MS-Office365-Filtering-Correlation-Id: a236f59f-122d-44d1-6c45-08ddf58ed93e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8c9xPGSguSi1gHKVx6L+X8C6HOajHqFex99PUgLvkWYJ3FywlUtoieNFIaCB?=
 =?us-ascii?Q?reWv27i+Nyr52XxMfoa1t+wgcJSEYSNkUgz/2pGsi+iCIXcgTWMqT9J0EHaD?=
 =?us-ascii?Q?hASKScKTgQS/3w04w81cWT3rQaiQDppsOyMjqCOoVAse5x4hHj+AWIoTDLg0?=
 =?us-ascii?Q?21H/5DFjU5pIw5OryRYfr6dv5rS+3egPcDRSp5LluWrOeJMa4P7594feqB5a?=
 =?us-ascii?Q?tzlGSAeS8U8KNaoFfjFunGVrJyvTTNk+CzEFtiVwgJYhZHLp2SZCCuZXkQef?=
 =?us-ascii?Q?vgrPRw7rZa7mB18iX8VUf8/o7kPFVmnQqC/vTqaB3lOfG/q0mXAfYsJYpW1E?=
 =?us-ascii?Q?4JUcZJoxjvrn1FZ1UEwFH8K9JvJfG4ObrI80pRwHSC/N6XCVC9OMVepieJUW?=
 =?us-ascii?Q?72MmKZzP0tIm682sb03sBbFIzeO2byMlqTgb6MtyGyzIA0u2mzmU5t3/ra/3?=
 =?us-ascii?Q?utrOavLKkzWE6UyhUBpzzWgnwMXvS02RAXNsJAf/HOvt9nIlMyY0oG6GTOIS?=
 =?us-ascii?Q?05cqUWAqYyjRKFU2oqjj1qgi+3zYIZJh7srBDtiQrLjG+JEiu45S544pW2by?=
 =?us-ascii?Q?vym6uy5loDNJ5b2Q4NubwDh5gSKUm8HMCYfV/XrE8Fn+T6swwcGR5LZ1Vg+2?=
 =?us-ascii?Q?Ls/c7c3/of8CUPijqsHhcBlfnLMSvgLsoYOPiE0R7lDBagDVqbUGUSvYzPyD?=
 =?us-ascii?Q?E3Y5BbeArIhHBBAzNdQfC+yydcARc5UdAwbjp9J+GswqUs5xlkRK8GE043nA?=
 =?us-ascii?Q?D1oxZY9/kfTqSabAvgtFtZWXK+ZSDDRIsu+MLXHYS8Ac73RSzquRFZsfif2A?=
 =?us-ascii?Q?IynjRw0xrt8twYl7dEEmiO8reQgu3e7PSD31z4JKLDIoHMm17js6U/hM2B7r?=
 =?us-ascii?Q?p+V3A7PgZl4VcZoKccevoRv7YcWUa/vhh2lr9GdPZvz5Euat9uylpH+A9z4U?=
 =?us-ascii?Q?t/4TcNNRTuQQjjMK4ahj3/RUW9ajg09ZktAQ/4z5lmq9lqHjn6k7A7RxvzJa?=
 =?us-ascii?Q?bes6mvRuRVPhmNyCtedOx5u1c2+qZcumEtMO2/oMtAoQ+94coazwPihPA5PJ?=
 =?us-ascii?Q?TNHJQ70gKFLqHpQYD7Jy41Q23Mr/Q5pmnBmNIgZxyiLBB84J9GjVroh8OEut?=
 =?us-ascii?Q?AVism3KzTN4TEO6stIUGcWbKMkpOExZZw7ksGM6zbylc6mrz5p1gxniT9kmp?=
 =?us-ascii?Q?145DMZ6lzRqna/G/tQSKjtlsm3rbEuJIBRb9AT9l+CUjdQl6z7tcI3GmTdw+?=
 =?us-ascii?Q?cK626Rb2n+VrWHBuVj/D8e16RzTwJ41YbD61s164LKLBzybatt23ImVpYDbC?=
 =?us-ascii?Q?iBDYXiSc8AiRp9+kTJC0jJehybUK7+Zm73CnxyLxcZcHMGzpVEprkKN7gaWK?=
 =?us-ascii?Q?yylvWuIzhBPUyj6wC99R6yAWqz5BG6RtZoF65+pi4HNsgSHqSjOeGkef/35n?=
 =?us-ascii?Q?3V84hEcZu/8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aIEw+QJ70KD/p9B+44Fc03pw3BruOuhQHCvEHCjPN7ekvUBT2hRfN7VVqvUN?=
 =?us-ascii?Q?uPRv7e83TTBouP7lZMhrzm1dvz+fYHFOXjiRenEnqOF5siil9bBp3LmFZvmx?=
 =?us-ascii?Q?IgthNs4qjAtvGalVkvi561cDYUmiPvZD0YMpWbBD9V+08ZbxsJ+fFQcep9gJ?=
 =?us-ascii?Q?Iurasm+n8m8oXlKDKu8Ttyn8FgDoHbpxHkLUcJfXaWl/W5eYCUKnG5j3aOlv?=
 =?us-ascii?Q?svanfgmgu/X7G8V3Iop5Pm9vpA1tsZx0q0kOeTwgcLVpj9kr6NImfmmlwgi6?=
 =?us-ascii?Q?39grwBqx1S27033+SMk6zx2IwPXqRTD+wu4c2MVHwgb8+/HmsBovCoZyWvwx?=
 =?us-ascii?Q?/nI2EiWP4grLhe5i5gP8Gjvqht0G2TZbATMUcIiIvnWXZVy5euB7L8wFg1SP?=
 =?us-ascii?Q?80+M55MlSILeE0T//AnXxdo+UPNMSO8PDc5RavswxpbrarJ4F2y1T3dyeNCt?=
 =?us-ascii?Q?hJYfctNGVLJol6CIm1bdsUoNAgXWgV09rNdCyGGLA7I/lf5KbenHs2wH+IBw?=
 =?us-ascii?Q?pPECuD/0WRwSQnS8ZTzIwiWgWCipTyca1oDSLkLoaC2ruteXleoH7/itEMyo?=
 =?us-ascii?Q?T4r2Y4Icjc6tUVW8hdIKJ2BTo+Ju7QoV5eYY7hdmRzqiZRFZpcsgfgsYGAWM?=
 =?us-ascii?Q?tO3zpvn1U5G7TEmyLOEpcMxPRWB8fz1TdfQpmRmlFJA9MiNySk5HqkBmKMkS?=
 =?us-ascii?Q?NrrmIdX3oVB+9ALG7DAFYWKxx5Gsrxfj/GyVrOiOjrHpt9peCdYb0S30hmk8?=
 =?us-ascii?Q?rrjbRh/OsA54qXoQxqpnsZpMGA1yHFBnof++aho+tZf4/sWF20rmrOluO0VX?=
 =?us-ascii?Q?R/GJcHoRHNhMGpigVMMxH+INUO/7PYQohRe0xYJ/SjzJDhA+LSq/zh1irWDR?=
 =?us-ascii?Q?W/atWYMXlNeDZvmjziuaatO1423+H0mmMttab1Szmj1+iGuQrFQkaxAQ1FHp?=
 =?us-ascii?Q?56LSfjDdGcO+Dekq2B70nHBMQyjfpv+AeP6RYOk3UaQ1QaJwaPgvR2pV4UOr?=
 =?us-ascii?Q?9+CQuM4ynN0TsUKRb0ekvLEFYIZ79cfa7u2EHl1m8CyEjvo3HK20u+sDlIAD?=
 =?us-ascii?Q?J6M0K2TvpWdtfIVuWZwzRbsqFoHxjFvgYZbkEfVr1uVreHDbwdkT/BDeGRT3?=
 =?us-ascii?Q?pTpvM6eiKTahaDcTNbZGHCg1S+Tj27U1gvpkNXDkfpeLD0UHtBHCa9oa/sR6?=
 =?us-ascii?Q?kMQvO05RENdjar+aSqxsd3o56SgpX2zP5yTrJgyet55lT8d9vDa4EJN9kifp?=
 =?us-ascii?Q?2ps+afuIqmRqwg7RSuQy6LhEZCDSn3ty68EVctDKX89Nm5uc0oJmVoZ1xdY7?=
 =?us-ascii?Q?2tDJj8+4v5Rlg6JfYuFvPR6dMnNQFI8XxxUKyhbFpCf5cHdjdoaDMODEVk0D?=
 =?us-ascii?Q?bVGuxsjyT/3foeI/Xb+rmnUm1pXYpW9MQl8xVyNmbZX286dtA5id0qlTfXeD?=
 =?us-ascii?Q?GQx88yeQdMo0drhZCgLCf9HflmPLc9vtfiDMJ/i1l6MC1OAIPpbHttpxxaf3?=
 =?us-ascii?Q?do2PgG8qMX4Xe+8rcq2GAUVcANLkivqmZeRKc59bSh2TWq9FPW4Oz7PyoUOQ?=
 =?us-ascii?Q?6pzrEb+k9gCv4dNIFJXm8cQJ3Imh6T48zqrt6kyLDyLX/86oc932j9EnK+Md?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ut8+k0POr+PTUeMYejjfOa4MUocEMtZO//ylv7/Xe/T8h+w+cxBUuT9jjmccfeXLYCZvyTt8q8dQJ5zDd+ncpI3G+Dym6loBrPok9/p5wDc2iM/fw43+5AabM1wxf2Tw4nah2ey+SQAKziK9NeiCiWyLFe6sOogxQJnHprdSWUztdO74GsAJ2CA/JFywKV7PG0rTdh9DdPG4N+cTu/hz996vJuoCYcGnFCGhQPooQAJ2l1MLSk9Ijg/ZLFezNBrDWSQ1cRRcYQY2X4nO2DIKLnc2KUOxv6NO8ZR66lt7vo41vO52SQN+6V6P3a7k0g6VTDZHNGXbY8kV9G8FvxHQGh08pGAlpUCyu8Kn1Uxkw64LE8DAP74pWfvAuPuofx+iR+V3Q54glmL/0Am20Eu1gb8L31ocmDJBJQJakmegbKjmWBk3LKgym9aWNZ1aNbf1cZo10iCgmdEAr/FaYAWKhlFU5o8TEM2WPTota84tgycu5+RiP/H2IYsN+AWO4pKe6zdd4xZQWWhc5mfPAS5zbSTc5OT3bxDGkwvWYsKfKM12S0Y5ryI1VCnXaKNLpWIvE5AM4/AECC953XXFa8lYmwUuFdpmWiTdJpbjqgkAM1c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a236f59f-122d-44d1-6c45-08ddf58ed93e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 02:06:43.7442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OD5/C2uaBp1JwXvWl2uITWXethAIl4aTnO3Q6Qp09mpIyLyrLWL8RiM4Gy+lMYhWwGNzp2ojEtqbfIeSlE+fSzDYcD5NsWxMqC9b3QERzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=556 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509170019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXyRtwhn2Bhp+d
 pQXW1qMt5/zhuLuqx8/yDxvmEdwnqRpVsRvM9XKVwPEievC/O3ZzX0B3LWQyHR8bZB5rm6p4tLf
 ao6WcM8MGhad3eOShiwcAvfI8q1End1w939IemUrmW/jdbuCEUztmEenDgW6oymFw/+SyCqw7kf
 Vo6vptiAWICBrYPSwF7oQN5llJnI2ZtwRBXdHdzaLSoabKA6Fydwe5q6Ypcy/fITJENNrutg04a
 FQSDsyE2Jl47sK2g41MRQg2JGHBFkMJQ2XyWXYSdqLYwCirOZnb4rt6GbhNZsZ4wQ5e0q8d64C8
 RTD0BdHr0qEoL5lFd+s5i7ay1kp3+urdkacSyASgspY03isfRUoxaFvxhEOneO6kws6oibW9F9v
 V4G0+KtW
X-Authority-Analysis: v=2.4 cv=KOJaDEFo c=1 sm=1 tr=0 ts=68ca1871 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-GUID: TtgVdkm7o6VzCeRm2OnAxIewwAXLDvcT
X-Proofpoint-ORIG-GUID: TtgVdkm7o6VzCeRm2OnAxIewwAXLDvcT


Qianfeng,

> qla2x00_start_sp() returns only negative error codes or QLA_SUCCESS.
> Therefore, comparing its return value with positive error codes 
> (e.g., if (_rval == EAGAIN)) causes logical errors.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
