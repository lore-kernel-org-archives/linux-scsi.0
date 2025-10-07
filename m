Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E1B7464;
	Tue,  7 Oct 2025 02:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759804168; cv=fail; b=nO07qgW1g6TDzELFuXUE0HCzINGx6VmA8y108LXLzi5obzzViR7DM6R/oIr2VuC7j2Fe8dqsvR3dwfugOSmweKXdY4wWw9L4zbUHb0yTnZwy5YTmZfK5e+xFhSDOf91aUOPP/uclsEOOEy+ySDfqQEsLDNC++mXUFmezJDYY0Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759804168; c=relaxed/simple;
	bh=SOGq/epmf17xEVQdroRIY3fZiWuw1OS3aD130p+XyhM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BD5JYue7pWCKS6lKQAjeIrhwfhUkPs9YJQweTeJl/C6iJnRCA1A71pyLuda/9jpDjMvOj7Il2FeTiS5ZPeVQOVW3o4pgHcbPC1eBhh29+8fhYn14ip9n1NUQ+sQG0gmAXM6kW9M/LfKK49At79Ljr81ym+daDM03aTNUtnaGrls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i9TucKrI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jzcxIJAq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i9TucKrI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jzcxIJAq"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5971GjEo007584;
	Tue, 7 Oct 2025 02:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6dxo70AnqDMbPLIBME
	5HQLt+tbn4r0lbgUrVrmOmoWE=; b=i9TucKrI/HmOCHAFpsvaQLCb4/Fba8O09U
	oqtVKVeRHSv8YqueaVkL3SHXgGcHpjMgk5ncStMadAlc4nhTqjyGJha+Ec9QQ4MR
	B28UqnhvtvleJwk43nNp5D0DLbCwcCjmwKWpQtA16friPUdnlB1aAzpDukZ6f7jx
	F1FZyN4QMKXld0uvhqIy4DdeGpfsWnp6DaTCJdZKNKWN+nwf03bfDjC8LMxvfUPy
	czuZ3wm9aCsQ9H9id0J8fAK3/+GmX++wdGPEfGGkY4rNovO0GS69eUuvkhFevWat
	bSfVi1lgxQFCT4+OhrZ1pWiyqvUg94qyvK0xa/QE7e1xdJt6rqmQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mr9sg3mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:29:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5971RlVb040891;
	Tue, 7 Oct 2025 02:29:21 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17ua5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkOMrhLsC327Rz4NlyqxKUZtCciHqiVqh7diIht7ZrXJ9+0lePs/v6IPu8KZKlcPRqbemsGxCUZp8dJuQINGZ6hEDH4upCPMfl4G2Kwju3rmx0YZZhN56+qaQVojhDPyZ1jNVwFZWtS20mqYuWdrlUoguoySKxmk/eSHVUGrlLeEFZKPhFcCkvgSHkx2LrkHbPf/78HEuXGilfSwJyr4/uuPx8PYCCqJ4eDDQ4CdHDY8KPAdXnrXl2w0fhEJNEtn8FYRerZSaJkss1VTRBen5vV/51V9vjIfwphOFwHBTGyseAsbyoi9rZsq9EN17+gFTEAAxRULj3FiDbZtiigO7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dxo70AnqDMbPLIBME5HQLt+tbn4r0lbgUrVrmOmoWE=;
 b=sJPdK20j7H5U0ohzy5gqKs1zfSxNWooJ2AWzRY9bBwJIc98vzzQszR3Wv6D9x1uIKTFad+S+IjlgBMvIm8f97GV9wm0gyPhRekP4916q8U0nJx8gBj2iaso6juv3XPIOsjSg39IEO+ZZ4Nm4g62IoQwAZ5Oibvy7qKo4SbDcT1fviDALCEPgfvVZYMc+eUdYjqWhkfmNLgkd5Xlt0U7Y6u1UmOJV7CUpyKiKBlR47S/510Q7pVCWORWoBsi3T1mVUL1aXQVoHTypHvFKk7QsQLHADGhtcL4nnqVkr1y+3j6bLtuqg8CHoYzjllw2fLBmJdK6szHcik3jKq+qwrDuTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dxo70AnqDMbPLIBME5HQLt+tbn4r0lbgUrVrmOmoWE=;
 b=jzcxIJAqAPIiAifL74lQeS+jwldvL8y2tIsAOY7criQ5/09UkrvE276nT0ndEPGOHW0sHYj5jaJsJmJqPvGxHPEPtqBbsJYQtU97SP17UP7ClFkzEW53XjDTc/hxhS4IGkyqDEF10/wWUMa9wRuOIhpvfK7/Eu27EMD3b6jUEsU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6643.namprd10.prod.outlook.com (2603:10b6:806:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 02:29:10 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 02:29:09 +0000
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Robert Love <robert.w.love@intel.com>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: libfc: Prevent integer overflow in
 fc_fcp_recv_data()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aNvPMet7TPtM9CY1@stanley.mountain> (Dan Carpenter's message of
	"Tue, 30 Sep 2025 15:38:09 +0300")
Organization: Oracle Corporation
Message-ID: <yq1347vfnro.fsf@ca-mkp.ca.oracle.com>
References: <aNvPMet7TPtM9CY1@stanley.mountain>
Date: Mon, 06 Oct 2025 22:29:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6643:EE_
X-MS-Office365-Filtering-Correlation-Id: 01319e43-2373-4f24-c98d-08de05494be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VczJISoiV3NfSwKlRGrZDRzuXijH1f4cEdfN5qrJukaPf0Y8DQmlNC6xHcdf?=
 =?us-ascii?Q?p29RlyPeqgrFZjBN5/4LSJ7ydoE2OnSucCJpBTtf+CaxKfcf6+cD+iHsfgFG?=
 =?us-ascii?Q?36xEtU+crukfA/SBaauWDGr1c+pwzhO/+vwcJM05fQ+K2ZTNMeAjSocfb2Fb?=
 =?us-ascii?Q?5UBRVpQzeREhePkxyZzNxykuknI3HqI1TNI/ixkt+MCcZWVBcSvZELsulu3g?=
 =?us-ascii?Q?bxLyIuGTIdpOGj9uTKr8Gm+JSQqz30BnqR2vn/N4RKv/A0mJUZjxS3jZpnrD?=
 =?us-ascii?Q?5p+xYyWS2qjJoaPFR3M1CAPdrdjBBbFIISR1AxJ1fqGNApgWjaPA6/Q08J9D?=
 =?us-ascii?Q?t5xQilF1hAGQtOQXHrZz/xFLNR63gPHCC9sOCkdraImGb3gi5Z4SqTQ45wdP?=
 =?us-ascii?Q?ZziftzVe+47uHQv8esMsWWrO093XwoQxs5dMrD25MGYybDzCYANF2f64E1Cw?=
 =?us-ascii?Q?A2kOPYDW6txKlkR88Ci+NNrrYRTSN4zXP4/cHkAHKmo6m/Katq+VkSlnexBo?=
 =?us-ascii?Q?Z3NDY5Slz45rhKRrZQb1wMxqgl4ulhNtO7QRwPU4eJye9lMCum2brLVjF1UJ?=
 =?us-ascii?Q?8g2GBCDw5NUBWnqXE3jXENR/V93YtY7wml3iUo9ymhNLxMmIl+sZj4k+Auen?=
 =?us-ascii?Q?qSDgSwXfZMcd/jIJ3wE+5g7o/39x1SN3OK+SA2hR2rvEfyJ/mC/hF5aSPf4w?=
 =?us-ascii?Q?vndAcVZNf6Jz28blSQaEgS3UVM8AV52BB4tvcWl+E+ybKfFzRCZH5EHqPbWf?=
 =?us-ascii?Q?T9SpsuFoFfAXgl6RLpGp3599fSBrZHj06aKjNbH3dOW+3tLIFmzhc7WFi0oW?=
 =?us-ascii?Q?cxgAcdsjMRSXOsSwgWKSQAj1Xz5XwyysgsD+6IzSIKaOfC8Iv2MVSF+4Ht4H?=
 =?us-ascii?Q?y/7OEoACv7L4HQ7Js+k4s2sA/uIeRJpbPrHK9F8VtXpPgXmW45x4W4qWpFcp?=
 =?us-ascii?Q?52Q8CtNn1s+4c6Ddh5T2AjQtBDxgPxcGegT2VdYEUafXpy+DAfmRnVDjNXXo?=
 =?us-ascii?Q?rRxgbGgkNpAaVHq8C8LDK47J5Up1JokOvfVtMIH37t8Xc8Gej6CvlpWQM7Uy?=
 =?us-ascii?Q?rN663BF8+dAX2n8ATeuws8qsVNBHNHPn/q3I1AsNeM38gLE2Gh2CcovtrMSp?=
 =?us-ascii?Q?rSnzhU4EPNDqXN6CQFh02t7vXKv2tdMZjYhS3PN2J5mpKdZ2WTZsAcb512Dt?=
 =?us-ascii?Q?JG05bACpXmLD2YqBe3hXh2Cvf5QCrqw8VJS7uV5pvyf0joqm1+8SsymOEvq7?=
 =?us-ascii?Q?6yQcwx9BpmTCglXC+LHhR+Lt1NMlKu9tWBEMbQW2hxZ3kCVIC7ZhZ0iLWFIh?=
 =?us-ascii?Q?5mWZBu8uaxS2hcb2h7mpBgi3XvGVlda8WsYHs8T8n/NVxMBjAGeE1z64SG1y?=
 =?us-ascii?Q?IIM8BCmYepe70GJNz4rBCZgAAkU07KFBdqFsINPNtNArfljLRXM79Y+wY4Pj?=
 =?us-ascii?Q?bFwzPI79g6TASGigkIr0nu+MA1x6GECs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D7qvYb4YzdImLJ64f4SIrW5UxNDTpHoWslzq+0x2MKnaJFlY5QSQCt7HZOz9?=
 =?us-ascii?Q?UG+gFztrMvpW3nGcifrx2P9DtKeJQ9tMZXBo85XmP9+RvlIjRbBJsxeoYiSO?=
 =?us-ascii?Q?Xlcv9eoESYn2dNFDn+LSn5yZRTuCx8P8e0VzzRHdSZce+PXjosNzk6otoJ1H?=
 =?us-ascii?Q?K6J9o1+EcywAuEJQ2lgZG2Bc3wh2vXcCBrsQuh6qCTnpzk23dVvt4+Av0Wny?=
 =?us-ascii?Q?wjNWRC6OZfLOZI9N6HSZjJHPw+DilPyIXiIK6AOBj6Wsc/0uy5wK4HfgIFNd?=
 =?us-ascii?Q?rAP2OdjhpZQpVK3nOnVNcbUhLXfT3xwrbB9poxpg/sbiJ6dH0WEY5TaI9ajY?=
 =?us-ascii?Q?/8a/Z5oTJ21uCjFFYAUssbHwx7y/X5EjB8xXBlzzHF6qSE/2j+RQURnvDYp9?=
 =?us-ascii?Q?S/LUNfPsOiWiObLY7n2KxmbdB7Ewt10aNWk/y6k6rrvKOUe8TH/aDwxp9SJP?=
 =?us-ascii?Q?VQ9mmJzR6akwssQLESkJ5OnzfNo/Y21XClUWuvgD9enI/1gmmPXa69K0WSEB?=
 =?us-ascii?Q?ojOk+Xtsmxv5ia7n8Pmi89FXNOkKJ3Y4WoRECZK2zZQQv2stYLAcmYBkQ98+?=
 =?us-ascii?Q?Uv1PNQ4U+GyphpmuVtbKRzR91ey/NG2ulVQHHJTT7cwtG8sF7Mty9BTB7E24?=
 =?us-ascii?Q?pY28mnLLEpX3dT2cB5zQwrMoSKCh5/7s6i62+yIMGyPw5tPukU3r9qoS11ce?=
 =?us-ascii?Q?viPBsNl19lEOoOV/L2W8K0s9ndG/mRdzAWneLj4W2ZBTNbhlwndKy7M0iCjT?=
 =?us-ascii?Q?WraVz4yHSJt7zrEi3AXS38mdvNQoCInBo+kkeSR7tkYwK5wWQcGH5kKZu63K?=
 =?us-ascii?Q?CljNcmj7QTeY/6TtfO6fHFz9Qq/gaycWS5TouEoWFw4OnyfbeP99WlRs7AX1?=
 =?us-ascii?Q?ASJHhNUKCooVFAa/GyZmubQoG/X5HEOSH9IhR53PmtnqBPz8IuM4iJ9YVkL4?=
 =?us-ascii?Q?NyEQu/QHsDjmB8PLxrYfkQEgFSDGszeeJVokdLFhSgeNnpVfvsTs0WumbfNw?=
 =?us-ascii?Q?oMB7ZXyi8EYZPLIAq0X76hHYXOcjBEbgubHB9sEaVxKjZULcxo/LFMkR51BC?=
 =?us-ascii?Q?cDNT8JpvHEHmrOgVCq4jmr4uWOwD1tCd9IM/a98iuByh5ONT1rde5tM65DGw?=
 =?us-ascii?Q?wm30L7WizVeA0505Cb0rmJfriyZARu//eqP/QD+bh/0ue9HZnGTO9v1GfSf4?=
 =?us-ascii?Q?o7L63XETaOME7C2F02FwYIkhbIpGZlq9+wfUG2Wso1ci6XOshhokLz5XosEt?=
 =?us-ascii?Q?utmAKk5fpgfHv5kO22QA7XN0Y0P00vYnDVTffvonJ/cHSexPByQaniKTyE01?=
 =?us-ascii?Q?/8ukeRayJAdHbpv1LqXgGojUNSo33XbB5Qzg9JNU9hNxX34ZcTa7deLh0JvD?=
 =?us-ascii?Q?5Fc0dt0+YwmaU/ZzFBlFnIVvO8ZQ1pJEVpT+qXvyM5JGwqq352u+JGv5jMBk?=
 =?us-ascii?Q?f+sum23CLse7+LmPwvLZxyvyNi4z82GjKXBAaODXKRvtx0BLinNasAzUYkuC?=
 =?us-ascii?Q?r81LP7R/vYxIJurcA8I79bDXkADTYpWEUV5+p9NSGVkBydFATLf8fhvUizV2?=
 =?us-ascii?Q?v5DKybNU7rjVhK0+mNCY9NDCFwRuLgib8rn80N7/yceGC3GhMhKELPRI7MTW?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oGMpgvfX8Kgu0ebJnqfZmcPCZR6P60WkgNCVuQsiQ/oSts7sT+7WYd9J5fykDjEmxHOXUfot2rgHfa3u2CV7oljXRTJvq/mckPlpi9dBI9dLonPAb4N6QAKBCljCWM08GOU2w9bqIyDpP2shfR9hxEjgMsCjO8IfC5Y+vwL/cwWY1zWGp1UHCqipnnLjk/77393eo0BUwhdWUQUK9XAB/uhnzuSI+fsjpeWA8g3YBYUr5rSCUmjUz5v+egzCUrvYvnmHbGQcBtthjY76XN9TR1CRY1+rK7HAXTsEC29/3H11BBEvN3TqAFFOHoQY0PRa2BMo0l4feA2rbZ1C8BXESAmfURR14/NfwQaegmAI5V4lZMs23W09GFLURY39tVKamYxCRe1jid42dSKlp/PjhxMbg0ypv8iHwdfY+IHZHjwD4JwHpV0T8JgGztbAMkvwMVi84QS2ievZiH5m2GxdGzjdoNvUDxpA69YQXL4XBzr+nuMzruFaFpoz1G+gQ8PQ+kcEVglGGydrTiHfCNy9GI/liOq6MjTqauU8p3r8rXnFPKpD2pAebbYOjG7FVq1WF7D2mAhGI+YRz0EaPwimWEVvn2vb6gRN4GjgxMjOjqw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01319e43-2373-4f24-c98d-08de05494be7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 02:29:09.8469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EppZkik43GMbwbaTGP6fLEXFTilh4wA1m8fai9VaIo9ZK/3mJgBsNwcG8/izoOcIwmqe9dKv94OAvmb7U5/7U2/tNDciJCvqCrhHbT3+Ar0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=887 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510070019
X-Authority-Analysis: v=2.4 cv=PqKergM3 c=1 sm=1 tr=0 ts=68e47b02 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=zgiPjhLxNE0A:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: lJrRQGF0WfR15WSHpfmizoCwKQqHWEIe
X-Proofpoint-ORIG-GUID: lJrRQGF0WfR15WSHpfmizoCwKQqHWEIe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAwMiBTYWx0ZWRfX4tpBrACRKU4g
 o528Z1E4qQWVegEIcrSqGjCSMAZ79HsFNCU8JOZqOCzxuUd1vOI8q91HEJVda8MlBg57bA73Q7Q
 Elfp/dgkRLzF7FKf7fdJ2xZ4I3IFsbkr5g7A6W5tLl5RefqSfGJdV2RZYLHclLP1rFPeWO2iIki
 DTdb6xe3Z0IN3ZYuRh6RhpuyrYQAD7ibok9vMbDBapl+wZ81ABvg+JUg+0ZAzsty++3Nl2gHmPf
 TEL1FUPA33n26PzwYwAR5moQiMSlD7fCgILe1E1jHk2e/f+EprOE/o5wenIUUqHU1xezmfPpT1s
 vvE4KkFCgzUq9vNLUnZIs7ywnAyTGavjT0VbXDLXPM5Q63Zev3RGrmiYk6tTNztvIy03SEL6tmB
 EiSCz8vzaN4PPLflAQQlnGWUj6W09Q==


Dan,

> The "offset" comes from the skb->data that we received. Here the code
> is verifying that "offset + len" is within bounds however it does not
> take integer overflows into account. Use size_add() to be safe.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
