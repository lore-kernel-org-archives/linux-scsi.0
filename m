Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3256280331;
	Wed, 29 Jul 2026 01:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785289825; cv=fail; b=kIQ1vDcWwyRCvBWNndARsSiICVesuOG+s6G8e1pWzMVeSW0mFfzpQzDivnt/WdypO8yeMNnzo55Mz2dvm9wTrwqZclWtOxlVAyH+5Z1xN5FRgqzmdv3bU5rHql8JP4rU26LFEkjwr+73hQIhi02R0MlLYuTZEYVZtUOb45TnJ4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785289825; c=relaxed/simple;
	bh=Yax13c9L4Ruz28ztVZ5rpDUnT1gejn4eCpnDMdiT0Rc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=run33NzCKxFqC7kSu1u7PLPRazDFniXtCA5JVjW/LQ9iQRvd2QHD4CBfmcxVf36zjptJ7flft54x7RFcd2CBLI2Wcl1FCGt4QGtvIlmWRZrL6aOZNdkN8ydPBXYXx8RxRY4VuG3PFJCmOURLeFwU+mMNB5Exs1OMplx7aQFEv00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=POUybz2A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FTWsaoky; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="POUybz2A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FTWsaoky"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItXsK1122251;
	Wed, 29 Jul 2026 01:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SnbdzA3pteO8VnRA7F
	+IwMJdcXOXowHA7LCSWzHQqds=; b=POUybz2Ap+5JHkoB+TFAvojXGGSoYJcuLT
	E5OH5LIXqmw+7Mmbd0MqgV1jQfNwwoOwdZElxORJLxJmnbck6L8i8s7S5EMlciCR
	MvQfxtD5H5eL4kUFWB5HSDLGmM6nWYqw+Qljz33/ZTcq7B2qOUpbJrlGLyxnHfu1
	T5EPtJniWJQYHk7sy46IkPQ/4RCNCmH+xjzD7Yv8+d8F/0iJYhOoLOmCHsqM+l5A
	KIJ36/wXeQDvzt00p32sLt8+dr3pi9nDHQZt/NEUbFMloBO0H582q76cW5OlAtDG
	fQlhSw3qG7PxjPNJzdH3ZqiRnoD4Jp8I2xFol/V7IbZnNFQxfxhw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xw670-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 01:50:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T1o6Br016398;
	Wed, 29 Jul 2026 01:50:12 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010011.outbound.protection.outlook.com [52.101.85.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8a0rxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 01:50:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TtupE3K9g958orY38A9f05nw3Z1eq9tAqoQDiR61ggErd3cSswMN4hwIhDdFJtue+k+EasZ8xJqgEYsR1VA8Pxpaf5I2M69cLj84LyktKtO9notD0bgJ3KgGvwyXWb75CtOwg/LhHHa6asCaRbKayZYOFNwsB8K8FGlOgD67Sp1Mw8jW2Vs3HlQEqsUY4HaI3BQF1+X1D29LZLetbvezIj4q+X0u/LuakWN0A1e4ENPCJSH9rCkWpeP+rpLl5OCLtljfcpFEvq4epPx1h/Jq2d52VdRX3/DrUpvLjokGBDAlVajg6MCRF16/m3SjuQHEIr3aP7H3a3cOtsYWBUfpUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnbdzA3pteO8VnRA7F+IwMJdcXOXowHA7LCSWzHQqds=;
 b=Wdv+DpmQWG9vmovN/CENtsFlQjcKHwOsKBZ+teQT5d+FEoyGaDXUTpW/ipUKnaCrhDM60WztH9NM7B1gJInJjldXdlVdlxK3MLjnAEUL4aRKrALPN7VYVWBPKX/oO6nqaWFKm4TxI54jDnFaPH8G9vi2hU+hhyyF6wWKhihd5X856Jrboi0w8hpHK4sS+qxu4TpeuwI+QtvU8HS440Qks75LG7lwgLJD6GCmQOuOlVL59OBezbR+VvwTk9TV78OrDQHwvo55BJoszt918zgfg9eahlzWS9+j0SYXGjUEPgDLt7iLRJqlZZssEBtOz/4Ox1XGtFbfmOryZzu3emNgSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnbdzA3pteO8VnRA7F+IwMJdcXOXowHA7LCSWzHQqds=;
 b=FTWsaokyjwJ0AOeyqLje9np6JOOTY8wmksNQPkSI7M0N24Y2uryMZxwj8A4p1q+GxYz1lAYSYHosA2MkYSi4Zfh/JvPg8PXYRKzslZo9PsNJQb4FNzkDsgqHj8HpXtH2+VF73gDQM3e0FBlLY/Cnsi052tOAP8vhU4cVu8ahLHQ=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 SA1PR10MB6517.namprd10.prod.outlook.com (2603:10b6:806:29c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Wed, 29 Jul
 2026 01:49:59 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%4]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 01:49:59 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        John
 Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on
 time out
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b5ca79f0-cf1d-4a44-98fb-cb470f01a102@kernel.org> (Damien Le
	Moal's message of "Tue, 28 Jul 2026 12:31:45 +0900")
Message-ID: <yq133x2y3ax.fsf@ca-mkp.ca.oracle.com>
References: <20260721064027.2081195-1-dlemoal@kernel.org>
	<20260721064027.2081195-2-dlemoal@kernel.org> <amfCVx43BCYFWFFY@ryzen>
	<b5ca79f0-cf1d-4a44-98fb-cb470f01a102@kernel.org>
Date: Tue, 28 Jul 2026 21:49:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0015.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::20) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|SA1PR10MB6517:EE_
X-MS-Office365-Filtering-Correlation-Id: f396f6b9-d67b-488e-849a-08deed13b28c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2Jac3efhGH321gL40PtzzjiHjW/ak9Qo5LHdOqxt3FeGr1Cd916C+dKO/CZOJVIrF2M8Rqi11fU/ceWVJRn343DSyRhctqrQo+g15TaCcS6BCCrfomWjboEVgxey68PemqlEPqXEyt+tWJMy3BkTpj0j0K+gHjAtdyVV0Q9f3jLMbmi9ZKfHWUoV8CN3s399hb95TbYaCbJweswKvw9xjJh607EP+LmcUFElR8AQj9J74aHJba7VNVTSYdXeh/2+JHPovTZ6kU5T9m/zjXYHjPO9QdsscNsK0+hA2KQ3/948p/B+LnG3nVP3W25N5zdfuaTUCzrXFoHyNarEWLE7dzVRLK7zpOdIPXcO1eH6zNyRx1MEvAHWLzdlkdCClryHKzvYFsjcx0TgR7lpW+bKEZYzqLN8Ks3k2F21++LCzdu0iOKZWqaIG2g+diOIvcfd7Saso3fqsaOfLlxGDO0S+vKs9G5UdTbGoi47iiW30WcN8d46kzTxfOTDqU6XTnLgjLApazvzeOd7V7PyKypfThJpEbBl5OZyRI53hWEDFtyJTjQwS+Hl2q4VgRD6SJylSkErevjr6mQ1e5rA2L4N/RFkx9E3t37BB4kA2miH5ZS0aNzhASuRbVGYCZ77Q7Dr55EaeTFHsS55K3gHpXxEp+gf3uOgdhGAmzEnB1yo1+4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yfqOTV0yaOVmmaxOvHKuEVspYCCoTBBmgD+O6Nmb2hU9e5uXWy/45cvwkpNA?=
 =?us-ascii?Q?FHqA6iNTRTTxbbatFM8oiSf1XPExurv71OFPKv2z3xvH/w4Oke8X8tsMojAu?=
 =?us-ascii?Q?5mTp8+XHJISF8SpyjVh2ktQp+rnER2fdObxTTd27ckC/PtCpPcct/po2HA2O?=
 =?us-ascii?Q?FbrtAUpZtOcta0hA0aK8K9Daj5mdCb7sen76pudt5EyVzAa8IVzMBrLnE05H?=
 =?us-ascii?Q?ov9gKVaGGo7k3fKt1p/c13snZifdeoZX0nMrijqkpJms3BuQUH9govZEzG2p?=
 =?us-ascii?Q?mzIx82yS+nCoXgd0Jnbfbk9sNShgGWLeF7McuUNYvlGISGnHrh3I8G4YS7lz?=
 =?us-ascii?Q?IvuE7D+ew728Z/jwa+Vel2aKglWPVScBqm7g3uiAlTKDRZ5KYCEangUSeP7f?=
 =?us-ascii?Q?UVMR4vXMDUN5Q/7LuZJaQappFi7jFNs8BX5cTp0FmIWfvZ07hW7K7L0GHho5?=
 =?us-ascii?Q?arewoQhPTul7KtUCwAkPWafJF6geK0zLUpiT4akDd3o/maaI6DVKLpFFqg0b?=
 =?us-ascii?Q?Oh5MNRkxmSBW6YsmV1dnmiH4JJ4U0FO252yVkPqVc/S5dlIOkLzesUYtFyb4?=
 =?us-ascii?Q?LnDMHo5RA9YdW/cke3Er0y2SMM6nScY9MUxLsTXrqh743dwZRpF8HD4j5gJM?=
 =?us-ascii?Q?cPqJ/vfOBhXR+pJFJy6H+GmzNrhLpZjKXcgQ6EBQ69TZraNU4LI/2ijmMJDW?=
 =?us-ascii?Q?o9/mY6O6dJpstM2DJ3qBO4NbnDpwg/9IwynP9tfw3MKoQW14BRb3m/nOznUn?=
 =?us-ascii?Q?h9uakpFog5FwgoGiCKUqzDXb8BJCmziz9o+WjrmT0lcAj/fOjIOeGMXa7kvN?=
 =?us-ascii?Q?ElE7FtIqt76Pa3kvRHqUrpeCcCSc+OwXHH5peCH9c0ywimBUJgbSrjzj9Hgm?=
 =?us-ascii?Q?QOmAVTpzlC9dkT2THYcK/pWZ5HLzMyCoHxdS95Euy7Nd2NZzcGXaGYZKoB0e?=
 =?us-ascii?Q?YkXZ7+wSK71meAUJ2xMDl72I/cdvEtarYqXyTgx8knz7cbfsWZlO2sL+01yk?=
 =?us-ascii?Q?28n8NLZGITpK18fwfK4Yb88buDh+bA96VHkNZ4QPVdseULwg7HDG9MSzq6Cg?=
 =?us-ascii?Q?Mxa5nu+S7OgAeO368XODoIWW28RFzdZME1Lkr79qM3Tvnxp97SVWQfyFR0Y5?=
 =?us-ascii?Q?GxfFx/uhfvYpqjE3bojn10LQYBD/9kNQ3267W9msRRissfy7vv0mxObqGtDV?=
 =?us-ascii?Q?5sts7fF8IUH/IO5DPyj3av2kca7Gzwkffeu3sd8aU982nQ6XZmLktAqrCfVy?=
 =?us-ascii?Q?bAr9cIkKNo4WXZur1cKRisgxL912Wxxr1Pkzg++XGI7ZjYmwIo0DVWK4ufcn?=
 =?us-ascii?Q?p/jeTiDV9DBQawkMS6SKUvA5OFkMFsZHWda/YxHbieJSWct49o7WpKJptfd4?=
 =?us-ascii?Q?39MAe5fTxKrSQfhWoB32iDKlNs9/OoXYLVwYEd15UH0VLCDFNinA960MowjG?=
 =?us-ascii?Q?Lb3K/hV4TmOtWXH1ySP+ctPypmXEBS9lA/6pNhL+pMUOS3bWjeGOe4Z3emwf?=
 =?us-ascii?Q?alrkI5hpuGVgf9n4Wvy5qnHElbpaknePsv4saZljzBEOiEup3/Z/uxjFs/bq?=
 =?us-ascii?Q?4q6clBY4EA6FSMmu+I5YlusWnAG4FkRHcht9xImAqzIJVg4yhtY1LfSmSXmg?=
 =?us-ascii?Q?V+2hVhERwAJuaVssfLKTZntkUs4K4/6QYALfjcx6eC3dDwLbskoz++LGe3vy?=
 =?us-ascii?Q?uLhzNn1ljmJHLVt2D/9/6ptX+t/P+Jyax/8RE1gbrzghFVamxGWDwnte+ebZ?=
 =?us-ascii?Q?wItVGlD/TGoKMEfCxJjkfNKuKG4uzOI=3D?=
X-Exchange-RoutingPolicyChecked:
	NJZyqn3hg2ZviRuYujo4SXcqRnJgmvyffFfCL2ISOD4WLeei742V/uimEWTk8R5sdEPYCfl3o7RIgkN1HKS+CG3+pON1EM53+wF2CYp9JB0gZI//Y0NuWhfsv8NwOpyS2kdox9hD11Ply3/5kplO1at3tUWhl0Bph4kLEAPVFegmxHgCvq+HK7PEVHhE6lehg+KhYSOb7H2nfJnAtdJswoRD5oaMCQyu4yGgohmdGpB80AeI5qZlN4tyit9DDnz+f2zl7j/8tHjbamjI58gLVG1OdYp8qOtFs+3n33yd7k4jSXnPF++KSN3KxjL7lsmoE1FQrM+aHWqqEGS3dCewmQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qo12okNee/gkO8PJJR8zQUVUnjDQyG7yVMaVWXKyjWguAUGMHWileU1yKFR06y09NFgizTx8F4UJ2KJIqR/1Yipm/f+RGQ8TwWA5M858qZFt+weMdc+q37CtOGPRiKIk/Eo+5Ow9HbhHQZ20gxGg+aMc6DyoB71+t6UsHKhGSHeO5WfPDXZ0MBq7SWrUjGpM6Pkw6HeJ95qy800RdbxF0vCsS603ry9Q9t6t1AF6Sn2nHGBNA0snfgd0y8Lx2qIutZrrirEb7u23yZRSjZZitxLhw9PmHzZ4qCjqE8TfS4qW9rr3EOwOLfsqEvELTWofftrt0paf2eLiKnqRCS0PEvziV9omUD1nrEJDLtAaVEjGEqgBFjUxjTDAKv5rwzVJFCu6A3tdRDFSKyjfx93o/oW1NIAVxrMLFz7SzIWAsaDtRQoaeWdNWfPBgbFCmalqkSilt+NjNsY5SJB8m/EVvlK4lsyp8cPAcVSkhNdwGb6IWT7F51uz5axOmwvYBvyPU13oXIZogx4STz/EUp34Wpj1W6PIwUQ1dqY5+/zzyRD1jcoJ0fwPIjUq0yY2MeZoCe7h9afg/7Io1s8NbcbCvpbKXxg+c6Ca5DLFis25M+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f396f6b9-d67b-488e-849a-08deed13b28c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 01:49:59.0019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1q8mGOieeMnl2lzd3DvKcSyOYsP/IpEyvQJnjLztgIykQrRlovmPSNYzQLuNKCqNHb5tNz83n0SBlRZFZr3z1SCM3hM5Eg29mbNvQUHG9lQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290012
X-Proofpoint-ORIG-GUID: Z0aR4c9mJC9xQTpbGjP7wDZ4bICKA57n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxMiBTYWx0ZWRfX9VuxkllCoSAh
 O/GAx8KVABOhdc4L2LLZhDnc4WUDthsL0G5mo6c/F5E5f53QCrqs5z7pl5szd4owaEoxy1veYr3
 1jVxb+jLGJkJkGtYgqO+DuZMovvEiDK4XZ84f4zsRycTr2hIdZrbkhtik20V41UzCV3Dy4MfGX8
 boVYE6GoDuBBUiRAXL3PUfZjfrAtQKVNj3DZ6FtjgUuOu+Bye7zNhy5puETTtLtbTh45WCRsUh4
 N/bEX9YLcx7wi09ju9YaZ6iGBxQFVSv6ovl+WCyj20++OstVVpmBGxX0Ubig2GC4Q3F2kJwCS9l
 Lq7wIagq0D+ru5ri0Dua1vvIcrK33iBgfenDo7lKnNjeYgmsYoA33LT8B1Jt3dKBoEDu5wBJqcz
 aaVL/rjosWCFpJgss88niRnGTtLJdpINZsmn1Jt4zkHRMNtcoMaoc5lb7UM44rMTWvMbc/Q9hqW
 F/uFSaOnsgYUm8kORvA==
X-Proofpoint-GUID: Z0aR4c9mJC9xQTpbGjP7wDZ4bICKA57n
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a695c55 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=UgzAd0zVo-rdZRpE6GAA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxMiBTYWx0ZWRfXxpULURaey63p
 1iacNitRQrZHFmPb0yFEm9O2d4pJVfWy1MaX3LjqRmyyRxvWpvRqVQDO9gk0inwINQFIlmPWln9
 /fL+y4QqtXbblbnEF4ib8CR5zbjRFxkyzxwG44iBoj2NW1V0grYS


Damien,

> I added all your suggested comments and code changes and added the
> patches to for-7.2-fixes.

OK, I had added them to scsi-fixes over the weekend but between travel
and a lab issue I was unable to push my tree. I'll just drop them again
before pushing.

In any case:

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks!

-- 
Martin K. Petersen
