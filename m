Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A57446EF6B;
	Mon,  7 Sep 2026 10:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778319; cv=fail; b=JsNC1OqWlpna1k4vr/aob3arHHa0cM9kLS8uppWZ+/yS9NYzF+aQBzhdO0NASJx0ldRgAuSCzWHoTpQayYoRLMnpCyL/AigCT7ItpHhB8KAaOVBysRYz4JTEGXRlu6286mE05RBT+lisgMq/v2KOchfAAeQj9YkJASIwlu/zwHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778319; c=relaxed/simple;
	bh=twGP650+YHsC+Dcih/43ibN0FPFGglKDDGTJ1GNhIKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fZF+vOgKTukBbhtuMmg+cWqEHjx7Wi1MelK/E+mzyzD80Qy/b3OEJUXBibDptJhBXgv+lIIUG4wr1PhGlJretmEKYsc9UK3NRYb+pOBLV04U7BmPhQ0o1VNosTHvhir9/jJIQ7qJX/TGB46fe+daLskls/JoX52LJC0DSnfn4Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YRXKl/nY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C6XinO1V; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YRXKl/nY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C6XinO1V"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870l44i227842;
	Mon, 7 Sep 2026 10:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mwvaCKUdLCs8zXtLJUiB9uuEy9GPlbWo/GdGpb4ehRg=; b=
	YRXKl/nYKgqqQyDp1qqByp+OPe0W2hvvEN6HLlGnu0YaqORYiwpVEt4V+wdG2aOj
	IxjT95ddt7etQ1szmUhIZvqax25N/k4oDRcTiCRGgEWkjcdrTC7Alq58f9iR258R
	HAXHswdRTFtnJjijydUUP74mWYKUb3agR/L/UUXViAqf8Kuh6XdR1bvH6niiMabD
	4PzidLN7/AGO6KyALTS3SSqbWvZYar9HPO+Dq6BIlqQyhqGEwN6572g+j2vHSsZn
	tDh4MHUeGVfCXNp8IzTShUMCMO+jufuWBg9vczEvjszRQGE4TILl1fOm1AzCvNRB
	mHBlPJWgY9Sc77EqS9FglQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdessgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfE019106;
	Mon, 7 Sep 2026 10:51:17 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9q269SizMq8nOBkFVFrU8ZJFkPzdfsU6aYH1sYTGKOZ2fmO24/jtpS/OwWXjBh2WRwpmD3AmnIPssBOdsTw/Znjw0qie+tZnTo2+LZgB+OI+DbifQI+ipVxPtj7aJQbiunx5Imf6opFdJcOyLJI28vFRFwEFmmTdCCa0zPx4otzbJpBGvjNc4C0AAdvbpfsxnXDU+q8MFILaozWWeJjJQ2Zc6ftcEYKezUJzrL6XiQbuD8lR8I2ZSJNr82cA5iZRewWagZttGMGgs+uvqkNpx5PfIUyXr5MmzqYWS1yDxxtNYZWZ6u1p+x3+7u4LINN+VSldUjKsHUk2AbimU1VNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwvaCKUdLCs8zXtLJUiB9uuEy9GPlbWo/GdGpb4ehRg=;
 b=VOcA21CUQxEL8e6VIezyI1iFTQL/tiFch4cZSKG2fmnLO7xfHKszHsLUWHM6XxCW5bomzSbsW7R312dPJ+rqY6KPCORzNa3sNC264FTK9hcJk1d1UtW3VL7QkTaJ5Z8Rjp4DtcwkGIS4u6e3kwEUJh/jD7Ep83PAsYQmY8ssfs6oncX5NWL9qUc8m7fm3xQ82iIwa5UcGh5yPPO+RuY+1R2KglfR6Mf8t7bSWGHKhJ+UW/Q025VS5fTH2CbA/fDGEo/NcbFIhvZZ/jKctRS6pvYmadNSwoTwsTHmnKAWoVKwOYmuAl7oKO268G6Fz3nZIqGY2TZMMOMsR9cigF5KXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwvaCKUdLCs8zXtLJUiB9uuEy9GPlbWo/GdGpb4ehRg=;
 b=C6XinO1VM+3eQcL3jO2nJhQc10NoERwJ1SQtECEu6KgkNX6BDQdfzttr0WslX/NxXU6+kP245sVaBLwldh8g7W+olDxVODf38SzI4vAqHglMCctQSwSL/T5/CxpLmGz1HEvtZysCoJR7ZEbNMMw2SdhaLwKJgVocTgDzNP+p+Gw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:59 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 12/27] scsi-multipath: introduce scsi_device head structure
Date: Mon,  7 Sep 2026 10:50:06 +0000
Message-ID: <20260907105021.1763236-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:510:339::27) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c778bbb-e9af-46ed-b40b-08df0ccde6ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oKRtrO2w5GfLzwzn6tpyHOxKrJ9nstc7Ub+xVZBnpTaRH/sQCcaaoxo71LY9pEaTbBl8Vx8/aza7NpsAYa1/xn+HcG0fVHg741uQ1cyZtTVKByUccOCkXF4xJAxklnjgzOt8y1ydDuz/L5o8uN1pCnj1/Wui1pA2TkghZFy9LWwNT0tOnh33ebLJIEZfAdWLtk1/I59tOxTr7RI8Uf6pZIogJkbg6B4sqiIfEnTa+Y3G31LD52QUpDYLKDvMYBkTKEVk7bmwL5z3T4AS4mJAq2BdHoO87roXIxaPd3MIjdnej+3dsKSe0EiPzsDvNZFOn1dFrHY4l87dCB1NTPk5SlL3iUs3lMQCj/Vsi3aUwg9ytgW1qcE2CWxBKqerkvvphss9HEtz0igBOHbtT+I8HmyyDJx766+QBDzgq7ymiPwKBygy4Rhhr0LihBjOtnnjCXFzKRfAdZyU8dBh25XUtDSi6Bkle0AD5OjSHQa65D2jZqL5nY83LdWxM5Z97Q/6QIBcTosX9+pPolzueI893Wn1RQfi6rT7rcYokV/L1BZrtnVtvY7B1kTkniQ8ue73OA7BC+KehPp2qOY+8wZaA4De1GMJl2HAFgxhuoOuy/uF5rkf+os1xJSlqWVz0lJWzCUlFzENFjqMf6EE+VzawIpyqo0b1IMSO33xI+M1FHQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KTafTxxpm+huUiAf8X8/AO7mZ0YPuRDwF8rJgSMGFe6ic8icmKjEI2IW0z/l?=
 =?us-ascii?Q?XgoQXbH0m57wfZgia9qwyPPmOJX+GKtJ6+1XovtIwqMhvK7xO1qZSLZ4cnJG?=
 =?us-ascii?Q?jJqQmED52fGE645+d+dO0hSD7NqcEcv67DJ4WxLv/cjUIoA28buuLU6lEhdK?=
 =?us-ascii?Q?ciPcP6sZ68ZOVeIZ8eDVqxTyh+jIGqab2fhNCjWfJ+mtYf53Qx9v3nVABXga?=
 =?us-ascii?Q?Dic/6AmNcIgAhH/EjNqoca6B8PnwoH0chj/IiqDxCUyUUJiEyFZEBWsN8pJw?=
 =?us-ascii?Q?b0bpQb8HGSspHaQqR2LatN0gl6XpSJTSQppwlwap2tGv4H3C0Jqo4JdRHzMC?=
 =?us-ascii?Q?p10AuQ+nnZu82Vv5C4Q7C3tgQZJFUHqqiOf6MQPoRz5OCr1sf/ooGGb/RHPQ?=
 =?us-ascii?Q?jHZNdgKJh2avqz4Nj7tINxvdOKOc8d5V289Q6wJ8noMALSrdntRjY7Ocuw7j?=
 =?us-ascii?Q?Tje+oB+zWGmaEgukXVC5Dcx8Gibq5eNXo4Fg2jtlXRzKNBQvZNinvJI/hTF/?=
 =?us-ascii?Q?MAoPRH/sXnHLLjbtHpePNEWG/si+Iv1srWagQAfb8MQ032sAZZHd5FaTV/fH?=
 =?us-ascii?Q?a5RaHR1NfE+3q/PuPf+v57aAE77RF5FPHuyUyFG7FjkJkwej9FaC+j1LLNBT?=
 =?us-ascii?Q?m/vU5M2hQ3uw80pYp3jO2KmfyXSc/LjnSuKXnrhiFA8jla88q6ZzWUSOREYE?=
 =?us-ascii?Q?Xci/FPUxZAYCZcDysDbGgJbzIiwrUvRER0NTNyHcQu+l8wno7vTkbyLEAvhc?=
 =?us-ascii?Q?6oQVeVD1pY1kNJXOr+qDHOB41p/09nb6nSF1aP+xZwAPYry4yBT49LyoJZ5y?=
 =?us-ascii?Q?HSXU9qtbxFA5jbU1oPu50PESJ1VMSBQ16TFffQkfuRCmerNoodAYQV+K+3Ef?=
 =?us-ascii?Q?KQbyMpPBgZ2C9wbunrVi0fHHORw0LMgSVn1Ukn5AfXBytoLT411Vuo+wHw/e?=
 =?us-ascii?Q?VytKQNyHErMq/TsUxbQf551eyv1U27rzCRuwLcQWMXBT02+KqoYJ53eFnk3w?=
 =?us-ascii?Q?BoWY2QTcmjswY8a/kG5ZBk7itI3NQkR1fUNdRGMOiM+jdSn7nwABexmskShX?=
 =?us-ascii?Q?20eOw4k+uI8zUZJLsoqNwlSZehv5ISOVW/l9rP0vNqj7p8YUYvfUruGWJbAA?=
 =?us-ascii?Q?pSLLdqkMxR/BSSsxsyryRkWf/Rsew+irlbrZxTirbZrdKZWChRenRg0SY1Ok?=
 =?us-ascii?Q?/UkGTvo4QsnKeibMFVmMTBbtzJstJ/Y2ye6zkT2laUOT366gBeg1utnlEi+b?=
 =?us-ascii?Q?pBfFwk46HYmIsz3jiAGkmZTqKz7pdl0/6vm8NC+tBtORpLswvSdz42sPfyWI?=
 =?us-ascii?Q?gtlN3HosoVffuxN5BVgmJ3lpr3YOEpMtFFHlu22yGINel8yPZUDu8RKXv6OG?=
 =?us-ascii?Q?js/kcT8r2F/+AFCsafWODruUHeesz5yC6A4golOSvnIVRu3UjIY6jmaF0j3f?=
 =?us-ascii?Q?uC4g8Vj3sW9Nltj7W8SfxKTnaZbbmUnUfS5bEcgZfEwJcVn6WyT6ykLuQhTi?=
 =?us-ascii?Q?oLgkbBCvbYIO1vyY8XbIv0kBd93Qt/q/NM66l/pY5w1cMySk5FYVksfYRo1E?=
 =?us-ascii?Q?Fa3A998YrF2ymaW5HqjsUK+l6QsDRB3dUgTIsUSVoRhSA22r76kUzebZmrLy?=
 =?us-ascii?Q?nDVnW9OUkzAf7tfXHd7VOUwhXJis76Ika6ghUBegalQvjt6VN5neGuQ6BJ5V?=
 =?us-ascii?Q?abuTtKsBy+RNt/8PsaW5kie85wdiH1u0VxD1fxCJbikpZ2ULWJz+Hgoi051q?=
 =?us-ascii?Q?8Ms3TyFl4Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	AOfDt5giauunXJvRiWwf4MPHy/a+hqDrYio/RehP6LFiiCXGva5GdGiGOm6PK5q8fOys3sZpdCNT+WYs+C72R6W9bFw9fsn0uYb4DHnhV2HgCfFBMm06aAxBqfPr9lEiDZM2Emeu8qbQHjQT996EkLaQmE4wjIzutKCbDDZO3v16cBbAgVt2Zs1dCxm7rgVGn1CO0fm7ZT3e1wwuq865yn4vbYT9rBXPjygZsB2cbIxi1RGSaokv0WFCXJ1uQ+BlMwSOwMrAqv1sWhuuY/AXVR59ZvsybWUhBmd1aCS2z3MUaSd8m6/BIXwjTFOzArmKlH0rNt95LZScpk0SVvKwAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OMJtjLBVLaSMxZfQDIN71Bsf6Oz2kfZpXzaeQxrCaKJknF7/gATSqCtaNXRvztFB5cJnQwwxe2+qNuJqKaaFAr++HGK2it1Ad5KDDGBeYg2Gc6ANnhYBXdDhmxptllLcuwbz+EGlk7xCAuuVkVWVMFFuBx1zMjGI9iiQ0mT+LEGf/vcB6SVA8/9X7jq7Gnyxf6yAvGdgouzJ2LUeX95lmHRQbR9jl/HcKcWhG7GL+18rljHj4vdAVSORp12khKQ2NI88WEjq/q9oLatVp0OGV4A73X6nzJIzul6dCJZs/1s5wsRoPfWexB6nK+GioUHuBz/NR6RAEuggP7e40QkYohEmuSluK+fcMiNqd8v70xxF3H/tZL+aMJe5n8ff/ttHY3uSBZgsJ6WtyhejTyYDgoQMKNhfjV9qoqYVvJZ4gjEN4SEQk5lkfW82csHYLSHbvajHSqHaeNEWrsfjHSHcQ3t2YiILcjW68B296THEnIzktxEupeeT4tTxR0Ym3wvaDUwWuTyL/OyryzcBTzqzg6FiFADBL6VkXJarFnCU/5UbKfEk9x9qKU/+qep8mxWQU5rHAi28RxUUMo019Rl/kms17sQIc2xfW25FZ6/0Ptk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c778bbb-e9af-46ed-b40b-08df0ccde6ea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:59.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIIPnM2WrX710Imi4L7vavc+z2zastrkQcaJo6AsR+TKgDifW3ImHPUy/WF40wjAleJPrk3mpUM8kF05NTpcKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: _XH9MUjoYbEBmMMldxBS2p2Q6OWvNLsI
X-Proofpoint-ORIG-GUID: _XH9MUjoYbEBmMMldxBS2p2Q6OWvNLsI
X-Authority-Analysis: v=2.4 cv=R94z39RX c=1 sm=1 tr=0 ts=6a9e9726 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=rslDvqJ3sq2LG7fXSO4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX3nlqI8uLZePC
 zivwB5xsOSbiNWgIrOW7451QRupDKo/KLT+oIB6Jy3r4pRfHx+Hhbxxf+l5ofg/mG5xfWR307a3
 qcdU+HmuuyXc61Od5UyMTN5NWWaSfokzXUY5MUMNNrKxdQZSr6z0SHu3lmn9d5xGDAs2QXsiF6J
 XEPSoXK1pkL5pDL/e+Cj+7AdeYa7WL6H6WBe5ZHg/l5gqhilCl1u7pvQzOu2CQfOKJs/XzmmBOz
 DWDk6yCR+ZgBxzvjz1lSAUcq/C82ITOmDIS0E1iOLS+1NkRcCCqtOU/gCEdve9ptOPmNJjCwibI
 8Cx5GTbknET2s4l5t8CxnWmtOVPgv+Lqo2IE6xzCXXbcB8sVL11WVbjDID4stX+s5VdA43LwKCA
 67nIzAInADrP/q7nDQmmCjuJWvuurO+tcYRkKh1QjYelTgAvHrqMGsdwVBlJu8eoKUo8EnfEGNN
 DVNZLvp8h2vNDqUEhbA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfXw5MVlhWhuRkF
 7IvnHBw7ThZJvqAHxJBypjVZwBlHGxIRq6CjsGIVhWV62ApnDgrRInujh0sYXrC+i4OM9ulg78s
 RjE6C9rgDN0g8FqleG8/nLXDXdwV0nkIkWuCBxXTQCRxRs5OiT1I

From: John Garry <john.garry@linux.dev>

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
managed by the scsi_disk driver.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

A new class for multipathed devices is added, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
drwxr-xr-x    2 root     root             0 Apr 13 15:48 power
lrwxrwxrwx    1 root     root             0 Apr 13 15:48 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Apr 13 15:48 uevent
-r--r--r--    1 root     root          4096 Apr 13 15:48 vpd_id

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 205 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  36 ++++++
 3 files changed, 242 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 5559e2e8d64a8..0fd4347725134 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -29,6 +29,10 @@ static const char *scsi_multipath_modes[] = {
 
 static int scsi_multipath = SCSI_MULTIPATH_OFF;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	int mode;
@@ -72,6 +76,55 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	ida_destroy(&scsi_mpath_head->ida);
+	mpath_head_uninit(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->vpd_id);
+}
+static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_vpd_id.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+static const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -91,6 +144,74 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+
+	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+
+	strscpy(scsi_mpath_head->vpd_id, vpd_id,
+		SCSI_MPATH_DEVICE_ID_LEN);
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_uninit_head;
+	kref_init(&scsi_mpath_head->ref);
+
+	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
+	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
+				scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	return scsi_mpath_head;
+
+out_uninit_head:
+	mpath_head_uninit(&scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		if (strncmp(scsi_mpath_head->vpd_id,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+			if (scsi_mpath_try_get_head(scsi_mpath_head))
+				continue;
+			return scsi_mpath_head;
+		}
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -99,6 +220,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -118,13 +240,51 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	if (ret < 0)
 		goto out_uninit;
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head =
+		scsi_mpath_alloc_head(sdev->scsi_mpath_dev->device_id_str);
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
 
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+	sdev->scsi_mpath_dev->mpath_device.mpath_head =
+				&scsi_mpath_head->mpath_head;
+	return 0;
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
 	scsi_multipath_sdev_uninit(sdev);
 	return 0;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	scsi_mpath_put_head(scsi_mpath_dev->scsi_mpath_head);
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -135,13 +295,54 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	kref_get(&scsi_mpath_head->ref);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
+
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_try_get_head);
+
+static void scsi_mpath_free_head(struct kref *ref)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(ref, struct scsi_mpath_head, ref);
+
+	/*
+	 * If we race with scsi_mpath_find_head(), then that function may
+	 * find this scsi_mpath_head in the heads list; however we would fail
+	 * to take a reference to this scsi_mpath_head and continue the search.
+	 * As such, it is safe to call device_unregister (and free
+	 * scsi_mpath_head) after we delete this head from the list.
+	 */
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+
+	device_unregister(&scsi_mpath_head->dev);
+}
+
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	kref_put(&scsi_mpath_head->ref, scsi_mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
+
+int __init scsi_multipath_init(void)
+{
+	return class_register(&scsi_mpath_device_class);
+}
 
 void __exit scsi_multipath_exit(void)
 {
+	ida_destroy(&scsi_multipath_dev_ida);
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6a68da42df913..5b5de58063857 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1526,6 +1526,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 */
 	scsi_target_reap(scsi_target(sdev));
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	put_device(dev);
 }
 
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17a..50d422798d835 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,12 +19,25 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 256
 
+struct scsi_mpath_head {
+	struct mpath_head	mpath_head;
+	char			vpd_id[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	struct ida		ida;
+	struct kref		ref;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
@@ -32,8 +45,14 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +70,22 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
+static inline
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	return 0;
+}
+static inline
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

