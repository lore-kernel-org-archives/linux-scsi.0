Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB081D5AB3;
	Fri,  4 Oct 2024 01:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728005904; cv=fail; b=Vk3hFTlbg2kE+qca0D7yuiuqSzqASh++/YhsydeXihfHeJPZ8ap8tRr0A1KxuroLnEP72DZ/AaR6GDHIKGb/kBvlCO5cKvi7Cj2kaprPTBZDkh7TexhK1H9IyxVIoRly+2CsAMGZnKpRgoNvp8/OY6TAtxSARNz8mtYKFt7cFGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728005904; c=relaxed/simple;
	bh=+Tp0V7d3qNuLvzEhqYSY3rz+f//sPtuRv5KVzpcc5rs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rh+9JjDrx7lcYYR7yTrs0bbtsOXmD/oMYg1UOzOyD3pf8bbaWK1nIw4gV/yGqVcZWG9QnxgmmtalmJsmIIojrHRJsO9ZoU6BBMYqgYm16eNzUSBju8SRGBn9OMdIwcYQEeygs/dNOEKSj3fosQnm+ikzgiPutskRwbJ0r1t9ah0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VgreWRKX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mkg1dSTz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VgreWRKX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mkg1dSTz"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tfsP007664;
	Fri, 4 Oct 2024 01:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=yDFzU6VpjwQiqI
	VRuenrrqixiLPdMKjpeTjHYnjYmgw=; b=VgreWRKXUiM3E+pZ3RhpdT3geReVBB
	/AY15nV6uPmwNcwtkSL+M+m5fhkN7ScuPKIWJQ35kGS8Pi8+z1/fofoLW6YPtbwB
	91peh5Xr3hitp22XCOuSICrHj4u5VIfRoR29APTk6wrg+xM81utiRgmQOJ8cZnXj
	ZFUNdDVAayZ9pUxk9OiWqkzpmXJIel9/vlJE9vUX8S/YZJJ2FiVRWHSZU4CBLJJw
	8iN9GXWuK/ZaU5zzEQ82oym678IW12hDcJZqMkHmo7W0+dfnz37qzahOJP39amzA
	eA7OXWC9Kl7073h/6A2ZKjjHye7dEeOJzXhBfTJ0brCudmNkXclMdVxA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4220498nd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:38:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940MTUq013382;
	Fri, 4 Oct 2024 01:38:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422056wvmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:38:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCDYeEONOxFe1BCTsgB7d5bA1bsmQPE7Zi3zXoo5Xm32ZDFIcAroy7V2Fo/Z9DN9jGg7VxSB3elClClZfjcFT+lBXvx9yhHW6vwtzW3HfOHMMkbu4vG4vLqh4d3X5IOPEOjVJoD4qme0OvuGbHNYd6kLC2sb7I4sbGDF5dfKF1gGOW77eduyXgHciwpw+eRLFR2IhZ5i37uFJYEQpdvzRMH5Cu2icV0XyihHVbeGMs/IbMXMtW7NQvJSGkAIyRowS6DgRUY1cOEakfEQEhwMTrlkIdQiha+TOjFoyUwhEtkoM/cuA8NctjfOoZZ4e0rrt8dCdDDdgQIpxAhTm58ZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDFzU6VpjwQiqIVRuenrrqixiLPdMKjpeTjHYnjYmgw=;
 b=BNHQ6TSxAVnVmglwL7YGwwOfCXxrMMDQGEk0tgUXXBhkwzKZwR1i45sJfChTCiWuL9stWMutE3VJFd6Q0SCdtbR+hP/MEB+a1DRGOMpIq/sumzXsY842W0gfzTaTwHbXWwoGOi/mMZp4igFbIBXn1aiKCWfvGLlJf+OtmfNXbF1tNWl4OyKQaXvl1jrRof8JJTdbae94fEN6f9qA3s2rofrk/BoBKyD5IHBYnhR7IUiVe1MDoEMFHjFoUM9aJFnp9UhuZpzsbk03/fhwqKzDpR4zwjIkoTGwISBnJb0AJVBN02LH9BrLMR8A8UwwlCthvu8EHZdvK0+cGgaVziMkqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDFzU6VpjwQiqIVRuenrrqixiLPdMKjpeTjHYnjYmgw=;
 b=mkg1dSTz+67LTWnMpgHaK0Gx61DaQGhXURJByHS5m67fp3D1tHMM2ZPI4sybNk4ECY9IZwH7JF/SDGQeYtPaAxkjYYS+kLFXaMhw8ETzJ0J5h51fQj0dUaTDAzyS1JPhP/prz9ybrmiAqeY+t7gzDI1qQ5HBwhUhtQLw4uP80/Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4505.namprd10.prod.outlook.com (2603:10b6:806:112::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.18; Fri, 4 Oct
 2024 01:38:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.017; Fri, 4 Oct 2024
 01:38:10 +0000
To: Liao Chen <liaochen4@huawei.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <skashyap@marvell.com>,
        <jhasan@marvell.com>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <bvanassche@acm.org>
Subject: Re: [PATCH -next v2] scsi: qedf: Remove dead code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240921062956.2027563-1-liaochen4@huawei.com> (Liao Chen's
	message of "Sat, 21 Sep 2024 06:29:56 +0000")
Organization: Oracle Corporation
Message-ID: <yq1plog3axm.fsf@ca-mkp.ca.oracle.com>
References: <20240921062956.2027563-1-liaochen4@huawei.com>
Date: Thu, 03 Oct 2024 21:38:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0061.prod.exchangelabs.com (2603:10b6:a03:94::38)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4505:EE_
X-MS-Office365-Filtering-Correlation-Id: e3df7d33-d395-4322-4953-08dce4153476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0tmHbKQDfJBImDF0XVdz0x8SjOESCTKtNIBQZQk0HzeG5tazAKboijxEfFvG?=
 =?us-ascii?Q?n5+7Ml2tbbRMoigCG6Xt6heoonDpLyF2cwSXkJF+AYZnFqHywFt8yot6Kd/p?=
 =?us-ascii?Q?WaILnNG/9neNbJn3qbu5zYphVUXq4XS9JvYYt4822g/mD0CW/1JsKUz30UFO?=
 =?us-ascii?Q?V+XlH1ILWFU8Y7AaHt6/nCuIt2RAjYzbb9TruDeamKC8WB9HucO9lpkVAfUg?=
 =?us-ascii?Q?sVK5gE+vV6P17wwy6y+OVEmL5bwMexzc9IrStd/depRf7o4GXafmQBvM75oG?=
 =?us-ascii?Q?bHV7hVWvfS6z6uvs9VOre1FtfrjJ2MG21TdHVq9qnGgloRYp73NUlb2fbZr9?=
 =?us-ascii?Q?SPFcywxhcfpdGgmQSNwfAleRSeCuH9cVr7bhR3HipsZQ31MMhjziYypENSBm?=
 =?us-ascii?Q?NxDCQqiNyxGoOW0eB36xh1PiziupfwIykC3Z2E4ehHRWK08NDQJnHQ5tvSSQ?=
 =?us-ascii?Q?ZfQKQvhXJ0E8JiJT99rj01d7+moQlxQ6dwlwn7MfZBp+0llXyd2fVjPkOGdA?=
 =?us-ascii?Q?nk8s4jW5aZMhtN0AF0fbPvIlFBGQ8Ii9ROczkKftv32+YHzUtc9OBc5YRFIr?=
 =?us-ascii?Q?rd/P3/18/zF2KZS5SYYCjri+5IcRqMwfu3awAmZ46qmoCLJqDwCWi3bNRLS4?=
 =?us-ascii?Q?DcIFldm2/7WTWsndBVKtDC37R/+DEwIeO9gP6OmEXNCxToaldwasx6CHaJjy?=
 =?us-ascii?Q?2jDOjp/j/nEHHapGMlqaYSsDOrFnwVVs8iiRuYlRUpzKJ/B3qoxJZqrrPnHr?=
 =?us-ascii?Q?GD0ymCYHJ5LAVL9PXj8jxaancRc5BgMkjgExY4HYGEM45FYEXSyTZUYTtDA7?=
 =?us-ascii?Q?jg9rhNgN69ACVJSq+VGR+OgihaGEfT+pH+xL5N7cYCCJkL0doN1SXlfj/7uF?=
 =?us-ascii?Q?hKHcFcYIJaF+88RPNgA47Y8x4xx2+pmkyOAj8o854OGzKb4OZKXbb/js0UUG?=
 =?us-ascii?Q?r7Q/s5/Ntp/g1PidamFcUFfRdOSBi3Vdk704Ao9Hz29Kph8vgC2rHER6uOax?=
 =?us-ascii?Q?HfGkv3mgwwJhdF7RM2e7925cz4Op3bOI9NVkC+orq69kwX3438S9VTueVHA6?=
 =?us-ascii?Q?mlzFUaNjsele0rGr8UGJNv/kRSiAidiMCLwSQLhFwaV8w15n3j9ddqgIG/tM?=
 =?us-ascii?Q?R3Z2PxoYhahbKnBhA0dHgQCkcCXnG+RPf2G61dhIjIxgucao7CoAoY38IISN?=
 =?us-ascii?Q?UXrj36HfMZ2J174OH0Ps1W/Ea66ZuWn3cJLm94Luldj3VYUrAZeIwY41a9Iy?=
 =?us-ascii?Q?wTgO89z50OMMNBcJbOdJT05FowzyUEtmP8jKTW4KJQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tohbeXUI5pIo70M8coFP58hynAudKP/T0m8YJyQ33uLL1u1OpXOJ69B0njY1?=
 =?us-ascii?Q?7kpvMgYH1lG05b/sEoxFhWpD3l5Ir5eRpSd7Ra7gn5g7LfvrS+d5tSkcfXxq?=
 =?us-ascii?Q?gmz3Oc2QhwNbPMAHbTpfa0fDbXJwDEt/lhNFWGjQrXlCnbUZW5N9IYhzst2a?=
 =?us-ascii?Q?8++lRG1Y769wtCSQdRRqQPQjBawTPSq8jWkzJNL/T5N6sI5+9n1kkcRLk8gw?=
 =?us-ascii?Q?3Zv9ICEuJg3PpxXHssGScnpUPPgDkVmudui0WiQUa14KplfmB6I+DCQdFqHA?=
 =?us-ascii?Q?4A6XmQlWXM5xWqNKSsiCcX6DfKEelr1yeO6qGmX7x0irA27t9WcGcHF8FN8D?=
 =?us-ascii?Q?YmU081D358UyE+qighkMOs/IfGUuuF4VpSkenyJAjNk61N10Hu/ypYx6/F5J?=
 =?us-ascii?Q?JRnUsA9HXIFq9e8wMPDA4i8sPAMQ/9/cjdBNUgcdQrwfxDbj7LGyVHoe4jaH?=
 =?us-ascii?Q?K2f74jp34VR7OfLS2GzQIR239CzE5b4V9p2uxXwMwKGfkZltVSxnTnjh6+uv?=
 =?us-ascii?Q?RAoRxZlh9AeFcRkQG64qQdIRJsnCQpwvy8/8yKpL1TJC8cEoCJsT4PonS2at?=
 =?us-ascii?Q?PHvVClQc/cuTmtV+T1w2LzpjceNZBPCcZ2YVR/zma8pjFEH8CXrjbbZjM7af?=
 =?us-ascii?Q?8HAsJT+zPceeEF5NpPjnT7AfnbggjFmOxpL/1ZbPFWt9w6fd5ehOjnjYZR8J?=
 =?us-ascii?Q?GVTdBI93RSKF7e1SiYySAXD45NbNYajLIZGSRb06o+w28FgQ6guQDPnJnAqj?=
 =?us-ascii?Q?PW1x1EtNlf0sLURgK03bcephCxf1JCMshOxOdDdcMmpn0/OBTFDYeyG6yZic?=
 =?us-ascii?Q?eTEhPAGTINGgumg4T65fXIgMnqWD1ClQxzUH3iczfZSpsZeMYN2c0CvL1Vg2?=
 =?us-ascii?Q?aL4xerLr73fAwkOqQHTk5A/h0eOleK/3slO9SXeCmepgULu7u2+A7WEXtwHD?=
 =?us-ascii?Q?ayWLGkWblotYRCvQkoQxgPGLzmdIqH8FOoUagWOSyuVfZv5wWaI/N0PA85Tj?=
 =?us-ascii?Q?fB5gQ50uzrFLWW/b4WrJoUpnrBHNRXf6poI7LeJLNHM/0SeRRIO/1IFtQudO?=
 =?us-ascii?Q?U87DW8L51n9C96/wamB63N3XTZ+jkl0Hh5nlrIb1pnEw7JPaoehezfVdSQCW?=
 =?us-ascii?Q?QobmkIcMMBwbNELFT6/VzndjJxwXiaW1y009NQMwpaVw28tq/VWtH1SAMn/P?=
 =?us-ascii?Q?dQz5ykMIwgKO0uGJ/FooXtEKKOkIqFhyk77nlLNxwkv9NLa9xBOdRDBH5xrq?=
 =?us-ascii?Q?uvRjMxeXu/6YJnf9aDJOXc6slLwVm6wRz04nCJJysU4bhdod2CZjBbEWEdOI?=
 =?us-ascii?Q?m50AUHjzo8eAIDvGxRHGUT/1wx4IPPOWpJj7tcf2XpF+FM7OlVPTKre16R5n?=
 =?us-ascii?Q?d8HwfgMkEHZApuStOu2PEam7SXybv3YQLmz/d6HHcn3aDHWtFMoBMRag003r?=
 =?us-ascii?Q?FKEmv/5GpmaOJWL9NtEcqS3ByqGALpJCce+gB/m57vMSlc/pvLNdaemYYm6X?=
 =?us-ascii?Q?Z7b0SOglW1yZFepZpffWJzoezTcMhxbyOZXMLO9IAkA4ME5o9Mb28G8Z50E0?=
 =?us-ascii?Q?qTpY2p5Vgw3zxquzg7PK9uG++5Q0K1idk8rvrLy71fGH35L5tsrrLPnH1N1G?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3cVS+ZsrQz34UpSleh9br2BTNdRMRhmvwUDlpvdwSqwPR9SnIcKl6eZxhf34rhIgUIIkProTVl/BlJ3kTQ4yskuZBXmlT451hmO77pNeoTq74PfcRcXBMbLwMp0MqU12R4O39tbcwIiBefKZgGEmDLljC7wEPxyJjhI8RO3RXXRj+BX0o8r23V/rpXE1B836b5f8rUSUHDgoOQFcCfyQ+AMUbZDtk6Qj2nfAF/lNVYguCj+vTUSvQHU0rxRv8r9DmFQs28YebE+bMaJPDWNhu/vaXJ2f9xN+xTxsxhMahJivRIM+7xKsVRX43hyK8vzsvY2PDggDU60Qbx0Como6ZzPWUs9be5/JH9yPRipt7Os1pgEwvpBE78oS5BW2nE6fddnZmoWOeGMyYYgsjJDinwDG1GLCiiIItvQ1G5kPyq3mRRK/Y9mzu4P4cSryyaxUZdEhkRL4h0nWVcIopxMYDwl498wVxVSmBGGLQRWVdQTP53WJEptBpUryXuXpR+LKxZCKBWusrkaAYTZjqVc+0HD/Eiw/2cJ84xpPaow+Zk1hWEx/ePTWvpV7Uww938CsK0IKn8WxMVtYI5DJkA5igf5wI+S4PC8alsQYeWEo9MQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3df7d33-d395-4322-4953-08dce4153476
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2024 01:38:10.6930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ss4gmUZwWE/8NHGxvKJlhfbigQYV97ojjF6aHu28N7+uetsMEzHkuqwuMui0wHzDsWuSE6mI419pT566HXTKnq7MX7eDx6OS+nbYIQ0wP7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4505
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-03_21,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=643 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410040009
X-Proofpoint-ORIG-GUID: BpAC73cjFhNs0KzvWJArJ_R6MhQJWZYB
X-Proofpoint-GUID: BpAC73cjFhNs0KzvWJArJ_R6MhQJWZYB


Liao,

> If container_of() is used correctly, its result is never NULL. Remove
> the code that depends on container_of() returning a NULL pointer.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
