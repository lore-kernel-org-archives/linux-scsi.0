Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0134036AB4D;
	Fri, 15 May 2026 02:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778811151; cv=fail; b=HSb9pdlFj0XJxwsHVNL8Q5wG8xYvwprlgg3Y37mRja8HjjlPCek9qIbATGfHMFH77OsHeYPryIYCYoYh9pTxF2+9xabZHep6PNB74GxvPjRTNlL6DKaFOIAiPJmoaDKdlqHOmSC5+hvGym8x5WBYCv8iEdCT/HH2hhA7/EyU6eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778811151; c=relaxed/simple;
	bh=tk8ZGrGCXQ+bUQSWE3XG2/FxUVcSMFtbJtUHHKFRld0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lhgxVu7FcE3zcA49gpCtd/4yVHJzyGT8Ld14DXRyMYGMp8QQz+iDmwxFn3+BEr7QBVA3RDrBNhB1rZbarMJ9foS+/bYnRRNpNeyRXGd3Q9dwYmOE4qyAEBGBdIB5ZUy4e9/EZqkyL9cWmtPRazw/tUQaEWiZDhluFNX61YkTHUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W3aQ4+Hn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GJfJGgNF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W3aQ4+Hn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GJfJGgNF"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0TgYq1505112;
	Fri, 15 May 2026 02:12:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4eTnGx028XUsvcdFBx
	huJoxNB9CLItIJyJsDzPxjMT8=; b=W3aQ4+HnbbMZwZN5P4IVhj5w+ZTUbeVdQe
	RC/Yun7IjtvnJsH8Wu/Lp/NBr9iW99vf+tvwqfheUzfCRdlH5GTR7VlDQB07yUpW
	Y6Eohr813YIagO1x6xwz1GRuMfHrberzMNGCrJ5gEUo6qL81ogxCKuFDKM5UozKq
	eMZFr15pbH5p5TiAlpdYAAvGcxUUIUfWd5mZpJ+4/NoawKK+pfY4hh+qLy+DZRPD
	k2P4WZkYV8Ds4bXvrmxUj3Hu+GYyqfFs4LGhRPllTtg5f8fu2/STIax4CBHhxSN0
	DvfJo3MqMILWBSGtajPHV59cHuh95F0i9OgWkUhN+9a44ZSfzuNg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1rrdr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:12:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F29hJs026207;
	Fri, 15 May 2026 02:12:24 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kvx51fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:12:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qMDSezUeQhfTtSj/GSQRixceh8Kn210lp5hX5meqhbeEvAwxNgUIHRP+qFZ8gNE+GkOAgOhAjfzNtwYZ1Dr7H6fadgrYbbrc9waZVpin8SOhCTzOjjLNe6iFKJ09vR+BfpS7i3ibGX353crTPQXGJbHWuYnUvn6e27D0YXYpoO3N3eLGiWuoNxns5KDMUNa9M4+XcJsW59kV/TLEHOukHKRxo+MfJkPxi26P++mFZtj8clXQWKIfoAqnbBbLkfgPxEl9K4jJFbHZYFKORsjk7FCRVmV+5S7RIqqnk6MAQRZ7gj8NlS2uc7TcLfqo9qmKbKwAJ213RK9weuyxV60IVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eTnGx028XUsvcdFBxhuJoxNB9CLItIJyJsDzPxjMT8=;
 b=LEU9xsWh6lqyeiKiO18y66pmq1e1osegCWsqNy2CuqJ6bUdnYyBC+yjjLnsrVV3UnWdPt7ojhpHUOPhBMYTdf/T0hu6Xu73vmf5gwv3NOtYfLkDFfWn4W1Vu6MjL8S9JZM76LRGXBNmoSLL5DN6TPmuaUfEJcYr/txEP0TCtwHHCmKubcFGpyWY4vrWgRpeZLfkSwNc0Urih7RfFjsKuIPfQ0CA8OE93Ble45gW6h0/nN72/2iAgc0aKk8xC2bd9qSj7i5DkgDC8qb9hC+uRHYDcSq6nBoxO6dsOTKeZ8rtIfJsiQXAorVwQsRv/Epko5epH+wWauabT9ZJqHkbDoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eTnGx028XUsvcdFBxhuJoxNB9CLItIJyJsDzPxjMT8=;
 b=GJfJGgNFLw95ZBrk5XypD2AQNdt/YXEKIeUgpJ6QRfGaovhCA4GPA3TgH3exfGRGvSh67WOB4/w3KdS6F7y1tbAXWlMG/4xz/X0w5uE8Oa+j7yWFA7YL0olW4u+Fg/wDoQ46x44FLsNLsamG3VBQlgl29T9nVuPi8OQLDn3Tn0A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7763.namprd10.prod.outlook.com (2603:10b6:610:1bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 02:12:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:12:20 +0000
To: Sagar Biradar <sagar.biradar@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
        "Brian King" <brking@linux.vnet.ibm.com>,
        Don
 Brace <don.brace@microchip.com>,
        "Raja VS" <raja.vs@microchip.com>,
        Kumar Meiyappan <kumar.meiyappan@microchip.com>,
        Abhinav Kuchibhotla
 <abhinav.kuchibhotla@microchip.com>,
        Uday kumar Bagam
 <udaykumar.bagam@microchip.com>,
        Advait Churi
 <advait.churi@microchip.com>
Subject: Re: [PATCH] scsi: pm8001: do not wait for port reset timeout after
 link down
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260416155403.416374-1-sagar.biradar@microchip.com> (Sagar
	Biradar's message of "Thu, 16 Apr 2026 15:54:03 +0000")
Organization: Oracle Corporation
Message-ID: <yq1wlx54e1j.fsf@ca-mkp.ca.oracle.com>
References: <20260416155403.416374-1-sagar.biradar@microchip.com>
Date: Thu, 14 May 2026 22:12:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH2PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:610:53::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 88fd0a45-af1f-4037-291b-08deb2276557
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|3023799003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ouGulkQsS4DUv+ikCcdtNLYG6P0wt85leqq9sDfCqrZ0G7nAWAVyCAaudV+iifdYQCDFq5IQIZ7suXR0g6r6cdhAC/IoZG+IP9ctD9IG4s3v6kOo2jEF685XQSMy+fQzWA4q7HexWKxm209YvnBe0ZKVM6BV5sWdGxEAQFQiI/wGulqzHDLHp3mrCca1iSZuso6HuJiOTOcX/KPX6BVLNrLhWs42Qfdl2KFl0VX/JIhBqre2mXalseji/fe2cRmh+50RT/zZH4vZ/QpDeANcyvaLu+gDZL/8fIj7yFZaF7fwpUylDC8ZmTFdbNdrQzMLwf0zcAjL67nE6S3Rk/g+ik1T19hB2jaCij8OSrfRG7DdPmYNTBgufF7uoF7hvoZmIX6t1RIEO5s2TtPFJYvrDSeYxrAQ2d77LvQg/XCHY/TgE49HYC3m3OapesXdGkCxoSRtmPqZJNl9RmbsLdMt2vrbFmQjGwaMqNJKhlxw+gUGvUsZofDdqnnK3xV942gv5u+/6iLfsB6y1Wp4e3GCuc3Rfq7ZFTguIxTIJi8KUCTRIpQgViN3vA0V7a+8Td8Q0c2oVjPQJNK0Msd8sHJaZ5MmeX6kBW00xYc63pUT0DDJbEskL2SAVa/8C7GcfWvG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(3023799003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fHsexoXZkSdt/3evv44brcMjjqTCzfxBIR+uhqEZChOKnwqYHVjrDe3Kt+91?=
 =?us-ascii?Q?ukYmt+l/hdKJp3tpaRnVWIQcvB2RFVyv6iUTNer96g//M6VW23+1KznmwtCA?=
 =?us-ascii?Q?3mjIfeC5J9+BrEu1T0/DYuidosMayT5UVY5BTB2FY4QTyp3LA8A+JU/k235C?=
 =?us-ascii?Q?JHRUNO7h52xxZ3vDTqfqI85zqTOKuVMJPkXTJols5/QEJNQsWjqVCmO7xnpZ?=
 =?us-ascii?Q?Gs/YL3aEag8Pjv8RUyDeorL1sSOavATtBB+XyTa/ii6Ne/91RFbwRbxnZaAO?=
 =?us-ascii?Q?aLe//KCpzS7br5lXIzsNNRhV3Wn6KGtzd81bIyvTUYi9ancLbU5ASMuBpDpN?=
 =?us-ascii?Q?KbCtVyAc0CkayBdsb0eaQrWINsawHajQLv23rL66vqyg2mxSFCBDlUq2fOyq?=
 =?us-ascii?Q?2PTbsklikUg2t4BAajamY6F4w6O8Hve4/ub9i7wu1ZNTPUtY7TyckYHWP61T?=
 =?us-ascii?Q?yO5O8sAvmw1OCTj0apq+27u3s8cQkp69xXhzlZ/lxh3q7NQHmk3opJd7M8Bo?=
 =?us-ascii?Q?AG7fSBZkyYCwgwMT5l5yjjBLBiW7K7FrREhv5IbCSjSIlAxngvewGYAJlKV2?=
 =?us-ascii?Q?z9qUZfAi8Y9LI7rxCLAZVPXE8O9qgwGCFc1OOgq3gsBjdf/1j98G/EgVbzHu?=
 =?us-ascii?Q?EiP/MbERxlnZwPimRaRY9SFjQd+6TvgCssehxPIQthfqTtqqYdK3079ZDCTe?=
 =?us-ascii?Q?QIzFZG5FIoStJfgIilDzePSCFIdJV+3ty7ZmOaKjd1TRBPTjTZwCYGeokpSe?=
 =?us-ascii?Q?ODRIcUGMYbYeR0Ya4dHO8VrorPPG1XEWS7r7+Y5o5gw+P19FWaNcaMrA7kE8?=
 =?us-ascii?Q?U29JyRRQqSNlstmaG0RdLU6VZeWEe9QmvggrhiA9e6/BhTHuliSNXZ0vF98G?=
 =?us-ascii?Q?4dPQ1emTsNjvFcNds7U3oTIXTiD2J0ggbD6v2KJoDotWexD9khh8QCX+2pO8?=
 =?us-ascii?Q?hC7MrKSMGF3P7d86Rf12EVfdcjltJ0H9qNaTFHAwgR4fF4hKj7nH4TC39bvB?=
 =?us-ascii?Q?Gj4tt6i2e8fwdDmT9RKd4klX4UtLJy8fLZV+ZYrTVzPLtx2BdJUNqCxKT8yL?=
 =?us-ascii?Q?v54DHLgWSUcMHXTVhnjDMTQAKtYhsE1gUUZ7QVIg/YpoplGMjGHFHivByAp3?=
 =?us-ascii?Q?t/vy6lffAcEBsPbmt5jCHe2k0G5wJR472J2om/AN1/uBWz42P1Lgi7RZJV/Y?=
 =?us-ascii?Q?mTSJepy/bFmjjHLr75TqaiTrdX6fVFEDAmmr3XQDBzylkTErU9jkwlD/2yrK?=
 =?us-ascii?Q?R3o+cs0oP/AInb8ge2kW8/VrQ62mCp9ywht9vccCae28Jc+pMm+ou0dcAfQP?=
 =?us-ascii?Q?0nyVgqfvN4m+JqX+Fm6dWeNEvDh47IV9oDXJ1eNyvG0ZVZG9s9K/mqxPU5ay?=
 =?us-ascii?Q?5ePQVcUMevUD/RrW/3HNiUHuJMfJQoPt7/xzhubprmEgzsP9vzExByLc6B/W?=
 =?us-ascii?Q?FGVNwt9XdiDFXczYYDyHamA4DborVoVo4DmUWuMFiSB2VpNHt0N+A4moaJBp?=
 =?us-ascii?Q?9Or3LrHNIT27Atwyc5X2vzrmUsv/P2NnFcm72uCLFakKKZIMIZzpADMBmL2m?=
 =?us-ascii?Q?bBYs1ZwTdOCJaeY/khe34OOgp/L+k9ORAPnqYOqs6+iTFRTZkSy1jsNeYvD2?=
 =?us-ascii?Q?Kzx7HffK0cBx24Cv06ixMSqPyPS7OOtLIPNFgg76/ETKnXOHhWqWEvo25lKG?=
 =?us-ascii?Q?7Y835p6i5n7ZODOfMRnvNslDLCAexhl6m05Be0EI9Y6DbFlZYvalWMgDHjvQ?=
 =?us-ascii?Q?XZ/3Ty+ecceHya4dCJnTann8nNqGzso=3D?=
X-Exchange-RoutingPolicyChecked:
	QA5hGYLIkd36pYgqhv0mq2Ka6q3MXQ6s0EphY1ZRJW1sJ6Sm+tjdt+oydZJHmxcPFB5dq9xily+5pfV9xG2b3sbLnmKQ4Xv7ffKO+RB4wAEG2+HQS+dLuBKimwfBLUQ6JrRMDVmjFaZzmhASQSoc0H0uPOVafrJvMiNAm99e0CF62Ex+L66X+EA3husb6W/oiA862NbH+imThI5OvTht83Gbn+HFGQuE+Y59bofjGRpWWV54LXMr7odNkGYdrr0XNWEcSDM3q+KUHXMBVaYM1dCZv6r06a3PKG2gvZ3ywLiAG6fYem2I4y7DX2RwOENvOSYIrp87ofUdU1wY5/qBYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k5QtwJeV+EWiOui5Ynhz+X4dXbrWWfy/+LsONEwVAXqHJc+gHTs7wWlUMIayCYMJiL0sVajpLl202FgAqrJdQRUdaS9PGMseAzc0yxRtrrMj/jDCHcZ7r6WtAhjmoH7LE7MGW4U15qdZ7M1DKsZy2bEwZUJY6bbEJnr+fBXwIj9O7tXlglfNyfmQGdu35WYfqy2mBkJuidPy4D7msrXtsrUSFfw7NqINg91qalRabtMdYjn+LwbsDAFXOg8a4CBTqhvueXnY0TxxkyYigHgOE2ARQ4cHZs5IpfPUggDn2MDfaj1Zfof/bwb2oXZCEAqmqIXZS7abDjiWGvBNjGEX3TVfRJSBCQEdwDLc3U6fB+hht/GUOl3fiUJemAOIfZXyhP+44nGrNhExwafKgihC6eq1w+O5jVd0QDwwI3RkMAr7mhf1yrTGoBKqy6GI8aUHYPuitzi03lbGaYVxQzpKftJe9ABSjCLfjD9div4cmO4qNTA0AZjFsN7FKZ2o4scdTijC/caCcHm06mAD4iq6R9y5adHNCAnEZ72kI86iAsHZLlPNDfeQ2Hh9gJtMyVumG5JHXYbMo3PHIh4Vtr9VsQHP/hdfx2gbwMI9FCKphbM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fd0a45-af1f-4037-291b-08deb2276557
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:12:20.7921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R24VSvQAYYfRPYsuR0nsRIqDNcZ73DfDCMaEHhvwC3UJhfq/XhoyVLCAOrBfChzrf7d2xkmI+RFNwmkqfMJ77+iXmaDnCLUuKgZdSOGsF68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7763
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=861 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605150019
X-Proofpoint-ORIG-GUID: IUrUz4ViXpUB9CdNhB-uXX44csqMJaJa
X-Authority-Analysis: v=2.4 cv=OvJ/DS/t c=1 sm=1 tr=0 ts=6a068109 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=llt8_sfTqc3vngqy:21 a=xqWC_Br6kY4A:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=c92rfblmAAAA:8
 a=XYAwZIGsAAAA:8 a=CdxzaFImtShofPS-E74A:9 a=VxAk22fqlfwA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=E8ToXWR_bxluHZ7gmE-Z:22
X-Proofpoint-GUID: IUrUz4ViXpUB9CdNhB-uXX44csqMJaJa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxOSBTYWx0ZWRfXw1AGfsTMxvxf
 1dc3DkjnuKubZ4ybMKY6j42m8910PjWIOG9Qo4WN2TdrBg+QoOJrzrvADbhBHnGpK0zhSpRbsiY
 0Pw7+g9PXgl0JELAZIj47h/TTd5lEAfs/b0MU07rwRyh30ZfE7oX1kyOoO60D6PAwq6nQJdtu/w
 VUj/HBQIqwNMZFbdhGHoWS42/QhKpuxsGv+g2Irfk1M/nZmNAFv1dDouKKIGiNLXag3hrKeVG5U
 w+7uKSq+dukhPQaHHhJHxzBNIa29taLVgK7WbIHhWlmDxb9T/YjAs5S06r6+L6ocd3sU/54aSem
 kvKOT5KASSlrT1+yBhp6Df8FaNrZA9/eXq0rJvA4zsCgJliAzrTOeHHQOTgWY5UBgr5qfBtDgpM
 AZjHls8paglEVmfeQTqsZTZmiYRJg+4+QQxXjF9pxb8w0PnveH8LZbaiLmV44kkItpoBl3c1te/
 fF645lat6kTTNQzlwSQ==


Sagar,

> During SATA hot removal with I/O in flight, commands may time out and
> enter the abort path. As part of abort handling, the driver issues a
> local PHY reset and then waits for the PORT_RESET_TMO event from
> firmware.

https://sashiko.dev/#/patchset/20260416155403.416374-1-sagar.biradar%40microchip.com

-- 
Martin K. Petersen
