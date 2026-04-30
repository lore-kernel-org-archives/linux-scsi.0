Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182BA472782;
	Thu, 30 Apr 2026 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566358; cv=fail; b=NxVV5SdOCXSsZq4fv0KmZ7eoQ5xPi7CHVxrpuX0+Ouym2oppREhq0Rrqyo79K2w2LaBtfUsRlNpj8TBj864oj7KycXOEqQH2x53rbF9sdumEdePKE0fz9V7Vi8xHKz3cL7n3H2hBT2jvBT+2wcZkyDKQpJOV+DrhQJuPiGNM0LM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566358; c=relaxed/simple;
	bh=6c2FlRGrynmn9Eh1HusbUVm29hx193lVxEBFGt2DZCY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eIeptmftFTsjpGWk+UnVM+vPRwW7NkKOeKsUVKZYEq5sXjJ96J62UPIyyQYE52zUIYGiPMG6ztkzjd2Rp/2802ifMU/yZIo8hXxFd6gPcqXEE7XthUMiT9qMQwl6HPT+TBylgXk8/yXnm+kFjhqBmXohdC25Z/8f4SiXFezRpUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NPOOIuuR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yl3v7Ka1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NPOOIuuR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yl3v7Ka1"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCfP4w3325596;
	Thu, 30 Apr 2026 16:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=84sk6x2erByMfwNSrd
	b+GHd/jvFlepENBS5cqqzY8bM=; b=NPOOIuuR+cOOhTaNrQscbP6gvk/LSv30BX
	OAGwLmHe9c7F877nTpZQw1dDryse0asQjQj4iaru4LazGXRePCx1rBqdetbiyU7V
	2BFfneiiAjDXKASLGBPt1Hw+5RtBCeSCukPifCWb+BlxvPq8LZg99B4L60NS5dWU
	1I5MGru55lLAMewRSSMMlw+cAfb0KKamDTZnAvygrg6AaZ2RAzNsWiVGHzl1qfdQ
	55MBRzJwkG4zcd4lWYruuJBDKTz61231qJxKTj7fJEaK0awYGg5jy/rkfJMBzmNN
	chQNjUwcxhvvNRhvRfr2clgcaVr/wovyjFyd9VbhSJtzJqmeXpcw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnenpyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:25:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UGGIdD021511;
	Thu, 30 Apr 2026 16:25:29 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010023.outbound.protection.outlook.com [52.101.46.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2g6cuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:25:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McYRYNboPmvLTlt3sd7LUE0IYIV3w2Q2UQbxvMdeORC9gqka1XFFeNN6coslOSSBU00XF9cNuo1gTaRJQ/bq5WEKFzCPFbaTYecUF56NBqDu7OBIka2GJVOME247cbZiFeYI2rHW//AgxotU2OSv6VCL3OLPJyhvcVtkMLsdiyzKaN0d3JQjCl5BZDQrhgqy/GLgl2E8qEhi6YKKUOQHokQa5OjZF53MYB650DEIvyTPTURzkDTlSP0w4vG99vpMwnbtDbfCfRixO+PFosF64E7g2FnINGe/i55qxGoNfzRKyN6Q5PmEHwUCZH8JOpFi6/9zcGLnbSQHl1o6zvJLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84sk6x2erByMfwNSrdb+GHd/jvFlepENBS5cqqzY8bM=;
 b=COAyXTEREbt3e119pco/wvoAhi+PH8S22oL5JW0sodFcwqCHCmdtwn4HoWAMKNlrwsRUlZcB/72VlkmW76cE+rGX2qCCvN7/xEGXziahq0VDfe4WcCRckQwvdpbMWyKPyGL4PTnc/970OVkIZcTRRBCyLg8IQ7p4JWPnje8pZccizaYWwWRFlfCR/uh+I50AvjdchZlvVFYpDVdsVUh4qgxbkozL2lZTkUSw9ouxD7QDjmJHYxQa66qJwmDIH6kDFoN/0R16xB4UHOT4cOeyEjpnslz8eg4oa8Dx6pu+lWqVIzU6i/2oe1Ecj26WK+NsrPzyaGJwllNT2INKLGWfhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84sk6x2erByMfwNSrdb+GHd/jvFlepENBS5cqqzY8bM=;
 b=yl3v7Ka1oojWnRtLLi30j5oZ7dhaunZgyEAZDRo9szHG/H/nOAPhgfRTaW4GtJ1IzodwtmBd+ybJ0oyg3tKnVYj1M1yloXdiWbZv0clnx792H++51sFur4ZNvQJQKnj3tChl2cB9bsdedyVx5Stqzu4rWBSIkgzVtolDLkjUBpU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB6399.namprd10.prod.outlook.com (2603:10b6:a03:44b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 16:25:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 16:25:24 +0000
To: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, davemarq@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King
 <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch
 <kmahlkuc@linux.ibm.com>
Subject: Re: [PATCH 0/5] ibmvfc: make ibmvfc support FPIN messages
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
	(Dave Marquardt via's message of "Wed, 08 Apr 2026 12:07:41 -0500")
Organization: Oracle Corporation
Message-ID: <yq1a4uke7rz.fsf@ca-mkp.ca.oracle.com>
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
Date: Thu, 30 Apr 2026 12:25:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0135.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB6399:EE_
X-MS-Office365-Filtering-Correlation-Id: a28da6ca-fdd8-4a8c-c150-08dea6d5152d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KGxRFkFAY2XZ3S4r2tq5qaWZP62VG0/rA9s5ZhmKQi6P7U+JoF6PKUMaq4f5+cXDU1NJyypCra00vcq5VyHurCok2UitCSREOrEyd8fGXwdQd994ERMBXKISI8XkXbZzSiXr02/78g8t6HwtP9swvnEaBUjNwnMYGCz69ktc0Z7mDXW93RTOrLWq958fum1cEWlQAdG+vjt4MfMV0yqxD6FVxZPE/Mu/p6ZX3bX9CBrXnuKd8UFEzy/unKPtMCMbQU9CKzTNxX8YI0VhXn76jFg9pRihFej2AUu3xDJysVaJhDToWedHGHzxgMq6Y0Omkt77MlfAaxdELn4qGqy65YoAhyX8zKaOJrbX11F38+8ybnneGbsvqtRoItkG176bdJsV6/EYioc1eFzbCVSm4ZSwtinlUBm/RD144/sDZ73Eo/2RXk6+Ph93lj6OSu0B0LAaUidH1GDUZ0UxjY1EOAo7maLhr2wWu/6t3jPxyuUeuLOqXJqa5Z5DVtuQQOalWv8YHoTTV+E3b1C1d/XDYxfWwcw4TUlPJcdk+zZ/QCi6cRrHP6VDGvJMQI5uwT0awiRQ2fxSadHX1zRvJRyWD6W48Bijnq5M3oTPyyDBSA6F1P+toM/fVvvA810Q7uv7aTykZ9CpUKtRqoNzrb6Iuqg8kOITaYdw6BS6OCTpnnHeg4494yFtVXY1cbzJ6UFp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B7oi35XVhxhmJ4IZj03iVSxMR4BHaM3UPC05PZaS69U1Qd8rPinUMKzZD+Ze?=
 =?us-ascii?Q?s1GdbkQNooxB6z8+XcWQxA/rJujldwytnxyGNnjDlGkttEm8EaajQiAVE/PB?=
 =?us-ascii?Q?30UR84WQE0GQ7ZqO1aKYEbqceO0WScto86393iWLQkEecqqWZnuldPBvpSZr?=
 =?us-ascii?Q?KJJ0LHBfKDD3MZ+jkHpPM/LcPN79I0b6Cd11dYlL088QMBT72mfg0tPF0gK0?=
 =?us-ascii?Q?QyUlRUawehT4LnY/cZnUB17Cl1i7yu1uknphZLdA4S+kjM/mmIAkxVPXrkyl?=
 =?us-ascii?Q?EHH5APRHqstvHu5lm9w3TcleMJws9Nwd9YGKtMfteDmuIUfqzQGZtJqVUJiB?=
 =?us-ascii?Q?hsKBIFHuJyF0DeXqu2GFUmxiqsWmCct98jGtht+BOK/U1wsyr/diHd1ApinP?=
 =?us-ascii?Q?vUSxi2wulO4gN1gIpAntQWeH+IgTORmwOhNYO/e09IbIZ215WpShazuro+9x?=
 =?us-ascii?Q?v7DlK24E8nNWAYiwV2Enk5Tb0EtC6quGOjqWtH9L6Oo0Ln8XtmGYZnmVZsFl?=
 =?us-ascii?Q?lN88rDF99oCyjEsVf1ua+as7DzS5YrrKnAJTCLOPoctIU80n710u0anOeVKw?=
 =?us-ascii?Q?7e+z/8dmGSybDAkVserHqNJRUN9tppygO9EHJHLkLhwIWUIZBW7iJrS/Yeay?=
 =?us-ascii?Q?x8cngWHKwXhrBQIy3epxwqBQJJbPmIsptEmXRT1sqZXSXTzq9uJ6uk7z+Kdy?=
 =?us-ascii?Q?YAuGo5yLKTBNgdcthgtq69Z1j3CGx2osJbIUa4E9fvclKewZ8pvnakQQDXM5?=
 =?us-ascii?Q?mPfXMHVpRZPCKDbPiukksDiKt0s4AfYaqjYITU2V7SKiCV5eZurzeVVhjQxy?=
 =?us-ascii?Q?yoGXDAPmV0JeMHPfL09cG8VxQNqvDX+/RQS65Gyf1qwiBRs1yB+anr4FIVE6?=
 =?us-ascii?Q?c6im0rlmb8qQBsB/DIhgihlRwkcwTRXeaZQtLxlCYSqIjTivRoWFol+SOIPn?=
 =?us-ascii?Q?qcjXvkpQb/uZzJ7M7SYuoQKvKMuRdhE3xQhQMIAIDodXk25Oum4uDRx9nIf+?=
 =?us-ascii?Q?+Hk/RJGmnsiTLs/uSD9sPnVfCDv/4Sps+94lApX/j14IZvVqkIrNRpIliEZl?=
 =?us-ascii?Q?/114bmpVa++ITCSA68rgc9eiKO4Yo+HwNvr9bUA2zPmF+eKw23bLP/OXvHXw?=
 =?us-ascii?Q?WD/JBMGT/TtQP4nI0ejGdxSWCRTjMcPSbDNOc0+5niaQRi2TqZz2EOjq7dNK?=
 =?us-ascii?Q?EPqeLjsoNPD+T2GSh69YBTBfn+EoS4n7jlu7ww74LDxxOItZtMA13ayor2sA?=
 =?us-ascii?Q?7DXVmgThA0TYqzN0FfsFXfx83Iai4SdxYbz80uTSlB2tgRrCvyvuKYiAtT48?=
 =?us-ascii?Q?E0FngUOW8rUgnq6x5QMZmcy1OLq9pjbjDc+RtJoPrTTqmvSc19XY2O/j36I9?=
 =?us-ascii?Q?WCz8aSgNPejThXFFI0MqNXt6vhCf4Lv9eqC9ZsUG4heUX7gIr+YjsQoGRKpU?=
 =?us-ascii?Q?Uqh2TsMilQBn52CEdjN8kKZmmZmJyQSlHvrhuX0vclshyLimZLQ/KcJP9VNu?=
 =?us-ascii?Q?TCcqbrM9090zVQJHpTW7XcMgt83yw9q7XRzmOrNTmgTbPINFkZ43RrYVWklI?=
 =?us-ascii?Q?sVhaHMkzflp4p99mor1O6/63RK0KMZITknzZ1STpvJUBKicDTNLz6OVZghGy?=
 =?us-ascii?Q?q0ewUk8TB0HSMYxDf8hFyDMkBtarXniqd0H5MCFQ81YfVWEugm4mEacqLM1h?=
 =?us-ascii?Q?1FLi7IgvqhyN6a5HjBEv/1jkvQa0QSA3eAUmFEUwPWuzLQnnYsRnI6I4I49/?=
 =?us-ascii?Q?vwk9i5SouSAh7arK++QRwOW6bBEDzgk=3D?=
X-Exchange-RoutingPolicyChecked:
	s2nU7WEh4vq060VIL4dCj8Sc7BY2RH1XrdjSvfgPhnHrraBIoCgZegswqMavW43uxCrm2OgDYQ88pRPN9w+Qmt4ZhgE51lLjK2gqoR+Benn39gJhO8LY0Yj4iLboreC/f8YW8rzoanrTaeSIDONU/LcF+HcxUA1LdA3gibMe5hN+HCTSElTBJmfSGbdlIeZf3VdRJ4R30dwK96fnMnqJqKn9T5IlpIJ1o+GhpcpddZXxz4OAwxa9Eg3PsD2McowgXBWs4HGa+TNKFM7HCWbijyU3XikwP5sPhaDNaFQ2PMcfbPaT2S5tQ62Xoqfhp3sHBaAVOnFKg6kYYR8u89Jz8g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n+OQcTm61q7/E/eWQTLw1ca33jKuGozEDhghiqq53iFDCyWkaHyIM2upySyrsLbTs4eDb4YEZGA4JHR8ImWVvtWmFMHc1UbgBlKkDUCaNdhwEp7Ecr0f+cFeRZ4SilbiUIcIpoySpkgKOVPrMSFKIbp6Y0YjF5iC6MphEXqsJ1Aogasc7wsDuZej4YmydNpaQqSdBs+UDVLiE/DWPndmXnRRcdQCWINW4WwnVSSRhYqkGfJFWxheq1uUop0G6HmUESmsXQV00+NQMdUn6+dYeBUL87AoO9aaRodobTvmO+P1PLsDBcUgHNGYLwaJiMNJOkX0b8sZML4jiZYmrZa4ZVUTq5rzbqEa76N1I0yh/3l6eWZ2TCWc2vR8DqjkW9ykl/q9JB3DOZS4IjML+ybSK0KkEXIWvyuZD7F0q0X4M4zoycNg2El2CTyKoFgmPTFMXVSEpNhxDHGbcpIGd/+T8fuZp2qIxZ+AkNd8dU9SYQCmM5A6cjU4AwYnhIcsB6BEyn6svGNA8nAlkfJZNTRRaUM/NEgC6s98rIm9quRMU/Wjj81JrhW8E27yj7yAF45rjJjcgcP1SiO80ti9DghYO/ZCwUzT4oQfM0edp3ISKR4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28da6ca-fdd8-4a8c-c150-08dea6d5152d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 16:25:24.8452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPdjmL6l39rtjcuBocX+Eg9gRdjDLU64+EgPPG7WgRXpOCLm59xWd5GSjQl2A1Nu4LqXfX0t+V9WSvo+7k1md2rf08UFK5cKAExob6b+hd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=896 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604300169
X-Proofpoint-GUID: NF3GJlG9oBijlac_KNm7DTYzNu-KxHrj
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f3827a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=c92rfblmAAAA:8 a=VnNF1IyMAAAA:8
 a=gPK9bUsYgEWbAV3L8bkA:9 a=VxAk22fqlfwA:10 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE2OSBTYWx0ZWRfXwHUyna5MMlKm
 PZwDRpXteoOAtYeRKBK1qzypyrrAzSUSX7euaODZc/ZNBzqiO7uwWo9CEgppCwErpnbaAycBbie
 ujpawcqshHE1vHHYz6Xk83PZtBYWGZkFsFrM/EOO7EkIJs44UPWJ5aoTuaHV4sudR0jW1LS3AIW
 qqwAqOqlXMYX0QVaFgKuCZmKYP23Irb4/tz6MznIExIYlOuWPiIVO6VUqCSYkOkLAuDBWuTqP/T
 Ws7iMrvdDlLyPb38v1xDxQSwTQqSvsqSrrBhfkW+GPZeShmh0mdgEwZ7be+nE0up7qkcToGEqi0
 e8rXazLX1TqHS6miSEMvxDAu/qUGJBaXKnBzKMwS5H/WW263bYLRPbPbe1X2nNYcQl7HZgebhRg
 CTG0Iw0SoufSsA5NDoH9vpVdd6QTFW0+FZWbzt/b1Yw3jokYX3+/fhocjgtab+8wCFPwBqyoZMB
 QLAi6QFfpCOehClU0+A==
X-Proofpoint-ORIG-GUID: NF3GJlG9oBijlac_KNm7DTYzNu-KxHrj


Dave,

> This patch series adds FPIN (fabric performance impact notification)
> support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
> in three flavors:

https://sashiko.dev/#/patchset/20260408-ibmvfc-fpin-support-v1-0-52b06c464e03%40linux.ibm.com

-- 
Martin K. Petersen
