Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B03939C9;
	Wed, 18 Mar 2026 08:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773824069; cv=fail; b=CWT6HZBfzyKXSlqqIu4ev7QWKWtBFEKB50dllpmUGnpC854oGX9/P57J68yzOIlQDKAUobjX45vJvxyc5uijvRS5q+6QwwsMtMdE5tVSK1k20jGnMnwJdptdxZzJWW1ra4QrTZcFq/6Vb/O1fyVu3krDO4dmXUmM+eKCgQR+bYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773824069; c=relaxed/simple;
	bh=MtgfzEYpoq97hWySX1l/2zNTYFSs0MFfeENN/r7stJk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E1enfctcj7xkaT8I9zYzxdt7L3Sydpr1LyorAt+5On8pHLj/iaNPgHBBK9DhcoE5rlUmacIP9Cvgpz0GLmnSzHAp0BS48Un3muLcav/Rp9yDdDQAQhLxroDlO5AbKuAqx1Rdp4p7rbGLMFrKAs4Re7hBWwcsyfuYTvOgNeEBh/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pSLDfGqS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H+AVVAza; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pSLDfGqS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H+AVVAza"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I2NKIr1711359;
	Wed, 18 Mar 2026 08:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MKZdLURbHWwgliJyE2+/gCvYoI05XrxWzpJ2xKZcMFk=; b=
	pSLDfGqSVWX1LOBVh4M370MRv4GihdjXgUig5Z2hFVLHU1XxNDvRSUcxiHDH6hVN
	qOh+1XOKbjPoYoD860mBpIRR/skzrM4eiDmaxM7HZovTM+L0+YbjZQeZM2wjQDWR
	G81olmdy44LgW5kHUPGqoaPvq5jQBEc5Pu1ZdC04OyfQPiOATcAc/odM7e6OVzyC
	jj7kot49LYupbYahtOrwn0Bd5YPGG5xQyA155llfLTdg3eHoezkzjL9zE5X9ts5N
	Fno3bZ1pt13EQYCbSecuZHxY3qsSnAS4h17lq3vo+lzWYyR2AClzQerkuewqUW6G
	/pXs3elRLv8qCl4ykVleWg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj65nce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 08:54:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62I6jOsh017759;
	Wed, 18 Mar 2026 08:54:12 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011003.outbound.protection.outlook.com [52.101.62.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4nwej7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 08:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E4svDZ9TI8vF7mB0ZjNGrzP/AK/tRrNEIaUwZOiYBgrFGmavMD8CXFcTLRnvXivppv596dpnvMRF1k6SRlagPor8jsLCICk7adxczsdORVVKuvoo1MFl4nWNSDkcEmsJVwfAbt514pvk+GYRlk53fag1oBSWKpzi4crdN9eHJhV1kcYaDZsHx6LzUIqj0tVdx1E1QxtmW6TcdbY35MyVcS+ajmPRc2+5EzzGyxf3TF90FVhUgVsF1UhPzNyWLshRr69wvgNr0YzVMZdgmceOBAX2ipNvIw3cz4CyYVPEinsymj5l5LZoWG+jBhC4qCFDQgIGplwFbzgVL1pJCM8Ndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKZdLURbHWwgliJyE2+/gCvYoI05XrxWzpJ2xKZcMFk=;
 b=MRo+cX8PyLKUeUErj1s2rDFjZKWbxdIVxWTiodMUERPfucOPpcNPq/hpnOKR419Pr9KFIGF8nzBSyzu/Bjt9ijcnRAB0t4dO+hJdsmkoDznkCS1k2VzyMo2qgj5+IPHvReMd2o+mkUbZprvGoYMCwuJiB/3iAqBLUgm+A/6AzCPLhs2uHt2U3ZvU2YxH9YlGlc3NxX8liAe6Kb34tuE7j6OI5IrqLDegjQj2B1PfdX8qdTveQLoKSMv0FlyUN3D75da7EEUslTmMhWy4wlWTIf1jM3X8A8vH5PjI69fCYstVAWHD1Q8s0Cym4ap84swIz30i4JGpi2PHVD4VXxotxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKZdLURbHWwgliJyE2+/gCvYoI05XrxWzpJ2xKZcMFk=;
 b=H+AVVAzaFLVQEskZjhpQfgSKAWCJ2s/1f+C0lKBQiaOnKh4eXEGbZXISmNJdvfCF6P7ycHYhOiJwz26aKTdlpi49MsRtZDlg3JzanZljGuV7uIaCuO26G8YUTLkbpazYWAIABz/DoV23fJqc+bVl05oXjglPksc1L5cBrzhFhnk=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by PH0PR10MB5642.namprd10.prod.outlook.com
 (2603:10b6:510:f9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 08:54:07 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f%7]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 08:54:07 +0000
Message-ID: <6a452848-2590-4ef6-bea0-43a9a4765e23@oracle.com>
Date: Wed, 18 Mar 2026 08:53:57 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] scsi: scsi_dh_alua: Delete alua_port_group
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-2-john.g.garry@oracle.com>
 <ad49619a-6773-42ce-9658-6e96bede2bfd@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ad49619a-6773-42ce-9658-6e96bede2bfd@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0086.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::11) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|PH0PR10MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: cb0d78b3-70df-47de-b0dd-08de84cbea22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	65HVxVDq0J02y6WYCpxO5waYo3OWSZ3sYTNkBb/03LdN6qF+goJ6iAxijQGvF34jUlvGb5NXMnBVRkvkVjJMloACX010zoXrzH/eUalAkloWPytBCsu/nncFVYgauCdj78TI5PkSiQFFWyLA0P43UHA5PseEEI9SIBIogi+LuuScZUKErA1n7t6EjJYApA9TcMGc90Ug+PKd56fxnkGY5PieVvbebZLXabFSouCpm4/SHvPLDkQTO+tvr6s22u6QXwZUKaLN8G/WZ9I4MrBuWHgjNqSwMLhATpq4rog95w5OUdMxUwDrPPXJBxgiOkkPbeBmHv2R+Ue8iTBwYlrHVZ0HogImrBesl/wUSEj45sdfNTcTii4BjrnPhxo5FLKDa7AVRfpMtUeVRHbFoy+2qjV5RwDCQfUjQOgeOX/fDw/ywu8SKnf7ZUur9xkgpHCnO+NryC8/fhXsVEqumR0L5aJc6TwGIW1wmsyF/RzvsKy5dHzUHihNSGOUHToLehbaVB0j2QQ+AjTYfhKlZekMvzJs0lFuMO1hmsuqT+GEMj+i2n1gQvFT/Ht5D/UfqSHGHOSdV9ai2ddD7uWbhjsZ+0NPXuqF22xwtt2O3NYhbVGaMR7EEQx9q9RlQVqPBGw+dLylAvJuzxXMXQ3M/YqGdN6wMO0i7VoF3jDeWgSbfqb89hocx0aRgJv3ykkSkGBJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2RSR0k3NEZYMUJxZW4yNXd0OVNodUp2S0Jza2dyVndRTnpvMmxCQUh4eGo2?=
 =?utf-8?B?YmZqQy9mODJvTWlaSGVLLzd0YllCdklqSStsc0trVitpeXRJaUxJVnpoeWNN?=
 =?utf-8?B?bjRQQ29XU0ZsY2RtTEpzWXdDb2Y0NkdiZXVRUkl3UVRlQjQ5T1daRzdDZk9Z?=
 =?utf-8?B?WDIwbXY3YjdMSGJTNXI0UlU0YzdaVU90Umg0REY3bEVJK3l1a1o5ZnhlUVJn?=
 =?utf-8?B?VnBrNTNZbU8zNWdFMjRZc2srTEg5ZEhwMUNZWERUWjVZMEFHeUV5Y3NkcWVD?=
 =?utf-8?B?amRHYmNuMnBpOGpBdFpkZzBnN1h4MlJURXlTMzRRWWdhdjM5VFFMYzBrQWNy?=
 =?utf-8?B?VXAxTEcvVVk2dTkrVUJsemtwTjNnTEEzMW1KclZkYklBS0VyYVF1K1VkZUN1?=
 =?utf-8?B?bXprMWdUYjhuR1BHZUs0bEROc3RoalkxWXBMVjJ0S1RKUENqWEwrZ25HQ1NQ?=
 =?utf-8?B?cmM1Lyt4S1FKRzZLaDJYanVRekY5RURnRHlxWDQzYWc1cDVFWHpXd0gyQ2Fm?=
 =?utf-8?B?eU5MLzNvUGtzMjAxWFk2TFVBSGVncnk1Z2NkQlRwWGJhRnJXNHF5eFMrMnp6?=
 =?utf-8?B?bktxcmsvQXQwMUtIZjE1QVhaekVCcEZYUU9HeElpdWtic1dlc0MwL3ZMamJ1?=
 =?utf-8?B?VE1pWE10ZHk3a2prNGJtek0zV25ZMmJENlVIN3pKY3I0Ui9WaFhFSHlMdzc0?=
 =?utf-8?B?K0phYkJzYzBZK3l0Mm5TSVJJdTM4WTd1WFRVaFhmeVhEUkxZYXhGc0krMVdH?=
 =?utf-8?B?U1dYWmljRGhhMmRSelF2MHN1TGhoOFc3ck41Qm9sQXJ6Yzd3Y2oxRzNZY3l5?=
 =?utf-8?B?ZUMwc25aaG1YRTBLZVdPMkxiYzJEaFpldjV0VDBzZDhoa0dHS2U5eERrYjJr?=
 =?utf-8?B?NDhiU0Q0ZHEvRGFkcUY3bExnRk9oeVlvMXRXQU4vRzNOWGhrdDlwSnRTZXVY?=
 =?utf-8?B?RSs0UlZCQ29BYXhRSkh6OURPVldFajhma0dBVC9EaTdhcGphQlFSTjF5VGwy?=
 =?utf-8?B?S1ZObjVGbnFxM0tzR3ZjY2RUS3c0MWhpQ0V0RFN6cWFTNUhFS2M2R2ZLTTlH?=
 =?utf-8?B?ZlA0d3g5bnhUNVZPYi8wMFBhbmhwdUsxdVFnSktFcUJrckYwQ0xqYmhsekw2?=
 =?utf-8?B?RXJoME9IbjBvM2NuSWwzZCsxc2NXQ21UODRzSVpZNFRCM283aDJUNnRlWDdm?=
 =?utf-8?B?dE55TGM4dTU1TEgyOWdrZUJBV0dXRTF1cHRUUjVvc0J5RXZROWk4ZHdENzBa?=
 =?utf-8?B?YVFBK3puNFF1ZWxFUnNObWdBSGNwY0N5eTVNdGhJVExvbnV4bldSS3liT1U3?=
 =?utf-8?B?UnZYNFRSQmd2U01QVjhPQTgvdXpMUmM2Z2FRbzBabjQ2blRaNHVpVVBLZDdM?=
 =?utf-8?B?bzFTTm9oVXk1b0xGa21iZHpvaXdldm9tTGlHdHB6ZHU3YmdkMDNjS2NiRjY5?=
 =?utf-8?B?cTVqNjkwSGlpYnlVZWpMU3JUTjJETk44M0Q5R281MGpvcURvcSt6VlYvelVi?=
 =?utf-8?B?RlZCZkhwU2cxWFd0NElCOG9UYkdXcmFOUklra09Ba3R1TWU5OUtSUUM5YjhH?=
 =?utf-8?B?dFdzOUM5bHkwUDV6aDZub09nZHpMQkpSQ0M2a2lyUklzOXltckZNdCtSQ2hn?=
 =?utf-8?B?SWtJblRCMWpKY0w5RkpqYTlTTS9BNHhlL09NMEUxSlNaQitKS09Rdmc0MFZH?=
 =?utf-8?B?VzRDU2VTSlc0WUQ1MzVaaWtQdVgwM0RQZGdZamx1amlqWGUvQ3JBRHBBVUNl?=
 =?utf-8?B?SWpaWjIvV0VJeUIxOFRqS011Q1RyeURyMFV1SXg0WDZyMG0xMU9qNERERzZD?=
 =?utf-8?B?RFE3SVVXL2RjSTY4NUVBNEMvZGV0ZGo1b24ycVFRcVdnNVhKWWNOWTVaQVl0?=
 =?utf-8?B?MDhRbStuZE1QNmozMUQ0WjRkOXlHaElXbEJWN3dkVnRQMS9BU3hWZU1KT0hL?=
 =?utf-8?B?YTNtbEJ2Q0RSaXZob0xyVmU3dkpWUGZFTGYzMGhZSTdHZjBITk5FcHhwd2py?=
 =?utf-8?B?MnB0QjlzRU82cG95S01yV0dLRnB4N1pXQTdUQTlvRnZWbmw1QU1hMVZnYjB6?=
 =?utf-8?B?RGtMTmtCTjUybHR4SmROK1NlUmdUVVVZV1FtaHlLYklxVmt6clhBSzFQWmpH?=
 =?utf-8?B?RzN2YjdXOXBzTGNwbXZCajRjUFYwOVdWZTVRMzQxQi9sWUJnQTBTYk94WjRj?=
 =?utf-8?B?RUJDOU9DalM1QTc3cnRZRmlORUZzeTZLc1hqVFczYkpGb3JXYkRiZVBBNEZ6?=
 =?utf-8?B?Wlc5aXEwUFJ1RmE3UmZrbjVZK0JtNXQ2cmtZdUtYaVJ4MnVSQ2Jvcmk2VTNM?=
 =?utf-8?B?NmxWYUdIL3NPSSt4aWEzTWhNRU5tbjJWS01YNXBNSElXbkdYTnpPNEF0ZmRU?=
 =?utf-8?Q?zTVbDaKLwhP7dGB8=3D?=
X-Exchange-RoutingPolicyChecked:
	vVePTIlzmuKHQHqRp7v2O3enW62NaXiEceyE6EMV01zU35kWD+tS/8nKDc/gE2qpQdMwTQgHs13dOp6wWtfVYdNoPKcBSTihPcMGj/w/C4ZXCNETppKC9sqQ2ftV2Cu4wBPTPqoqF7XENm3OxtE4vgDzTtACvQGyN/tFpk9uPrrA1l2P/GIXzLmB4c6C58BdQ+UajMfDsrK8hdze7kOvH9Z3GM1luACO6Qu9pUegLkaaPOmeYQrpAgNCwwyNCXLM4NbxSTrHzdIxXiIPJHQ8Od6GfvbpTI7ZhyV1/K/OLEspa/o+/CtyJO4oWWjWPFE1N6feWR7npoKJj2Ei78T3Ww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d6f7hPEl7ZNSmIRNOV9hVYLrpcs8ahgh2zd0b8kws/5TNUJbZckawRfA0WHORWXFHLlbQZN5QFdqHbF8fkFddrmkIiGSKOBx7V0Gs1l10sjhhMyU2g7wBKU4DW+SNZYT53APOx9zmnpsWQoFPgWXxfaHgu5h/fXfqsqQZ2ULDmS3FXaE3hhtP/wbjFa1qREZXURhwKauAnG6QQhIG33zuIvH2KDT7yKQanCvYYBHYTkVmfVHZc78LfF1xzDotd14EtsLNt9r/9LnoyeecMX9Te3MBzZxXLKzivpZHa1fVxOYtuFEScq1oXfFaXve4jYlw45ww27fVHn9dGfJ4q1MXApk9R8aNCFUoDqePE9i06h7zmDvXXI/0SwGxZqfKgLJiuC/A6LpVGeBfH47rLuywTqm2UF+KslIAhSjsC3Wtd8mXjMnyCFY8xtEarfyLeeCVKAPw1qNaCD6Hedtf3ObD5E6XbCnr1Vo4PxoZj6rtH6n0Jn2YMVlcT8Tw0BMvoTwTdWnRaAzxyTj1uWzPLeWpghDXJovNa1ryoaxIqGUtSEbsFEU+ZbDc8PfyZBAZZfZNvVGW4cjJyNuGlmeoBQdXLXuFN3bzEuRDIFrPyyaFTc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0d78b3-70df-47de-b0dd-08de84cbea22
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 08:54:07.8044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvfXdezXvK80g1Y02V46iU+QxgED9FtDgL/SSgFVSL3VTghujDQqckPbFrD7zVvfAPHBXQOimToLT82Xnc36Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603180075
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69ba6835 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=uherdBYGAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=RjMfpA9a2slMFQn8NvQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA3NCBTYWx0ZWRfX7oEbvSqLwOuF
 LoBnSHHfMvIozxFKawlVIs4LhEb3mS9n+G4qJVkn3cdTWX+9IH+rlgRooRWQdVVfR315Q/VrHhh
 lgnTd4RH7WXji9Uu+aO07C1Fks9dTgyc53tClszdWW8UlYf+SHipnCO8hoeO2f2nB6Tj3/tbZc+
 6lbnxJwB7J5p/6dMI93cG2yDX8IT1UUpvRA/n8bPd6eA+9x6AqyYqh1A1wxquyD5p69HLyCd5sY
 JQeX8GYUdZEGev5/RcYaiSTIUJOcM85z61DH1qoSGBK8/WPjx9lrr0UmdiJxD14xqE6W7Hl4+Qf
 /6mFj8RT3grhlyyG8Qj56p/0Z3cPqa07AL3ff6k6CeXFNlpnBdIUA4lFQsDnfdqh77xRDQITYx8
 rOXK8STcgKCTVmlG6m3ozYsCtxuQYxLw9YyV9IxiQ10YQT+jl8gq6TFmvuVvuyythvMjeqUIEVC
 hBMxW07+UD+VqUfPHHOAG1SRntQNYuQQfe0+EcKg=
X-Proofpoint-GUID: Ja-vlDQXtjCBbMHX_XfMqw8BJTpI4dOC
X-Proofpoint-ORIG-GUID: Ja-vlDQXtjCBbMHX_XfMqw8BJTpI4dOC

On 18/03/2026 07:44, Hannes Reinecke wrote:
> On 3/17/26 13:06, John Garry wrote:
>> Delete the alua_port_group usage, as it is more accurate to manage the
>> port group info per-scsi device - see [0]
>>
>> [0] https://urldefense.com/v3/__https://lore.kernel.org/linux- 
>> scsi/20260310114925.1222263-1-john.g.garry@oracle.com/T/ 
>> *m4ffc0d07f169b70b8fd2407bae9632aa0f8c1f9a__;Iw!!ACWV5N9M2RV99hQ! 
>> L3ooFRT-lbVw- 
>> vEOYnh_4z9auyqWLGG4U8lhysEdtpLWZCp5ReAn77SF2Tnr4nxHbv7zdsG9q6NxhWw$
>> For now, the handler data will be used to hold the ALUA-related info.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_alua.c | 663 ++++++---------------
>>   1 file changed, 180 insertions(+), 483 deletions(-)
>>
> In principle, yes, but I would put this at the end after the patches to
> move the alua functionality to the scsi core.

The alua_port_group functionality is intertwined with all the ALUA 
handling, so it is hard to start to separate out (from scsi_dh_alua.c) 
and then remove it. Furthermore, it would just be duplicating what we 
have in sdev->alua structure.
