Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F414469844;
	Wed, 29 Jul 2026 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344107; cv=fail; b=j4x8M33Pq82QzQItu9ORD/4a9BtfyB/oe1OLIfnyI7ipBApGcUUYO2smMM4OrCPZr+RhLH+kKngfFnc8iH5qOKyy3ws/GThGG5cBnB+FLXcNmploqxkEOkekEcpA0ifKCkpaUKa5Pm1IGZkdLMFJmVESizv+AR1+fGKbx6QCRws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344107; c=relaxed/simple;
	bh=5RqcDPskClXbGYf8okyeDDR24b9HXsMZ+yvwVLau3Sk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bJYuj37uaFtTdIIJ7uEzD2qEeEUFPGacpggIp+uaqKT6sjasYGi7SaQSGmbPIL5CEqhuhaPoBELP3Ufqvw2QZQfcjO9C49YIXOGS2+BfxnZIFa2eobXFVUcfFqlXLst09Q3teAGsIV4BgcUeYmgtKRpMKKDehcMvYMH9gE131iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SS6HJjD4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oLTbi3GL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SS6HJjD4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oLTbi3GL"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTQZ93035526;
	Wed, 29 Jul 2026 16:55:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mN1NwrCWGB0on1qce2vctp0D8/XwdyWs/5ce9JKW81E=; b=
	SS6HJjD4wVOLTHw0BFCMi5lYjjxeVC6PMkiUvg6PKenWllWcuUcdwzx1l6QOp2CR
	rF8bwk2Gctq6pd7VniW1JJTq2fYIJH/pnPnL+NnevZ8uWZZSBRhe9u4/3XqfN7mC
	yP2Fl6r/FAQ9Mh8JFVYm1ecFIZPiKxFk2ExnNFLs92OZDXi1a+5FWTAGEvhnE/3j
	FFqA6Yw3YBffkdVVMrmAJzO52HGWZb5n2ID7BCmMnt3Ron0H8wMhANDbyxEbTnQV
	5qx7zxrpiWq2gBpkIuo6fh+f5ON1ReIpfplrcWUAKpxSo2tzNlQmob1CwuuH0Ri3
	a3uihFfh2gdKmZQ0cfA8Dw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5np9nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 16:55:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TGjcUn032595;
	Wed, 29 Jul 2026 16:55:03 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012057.outbound.protection.outlook.com [40.107.209.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6r6kd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 16:55:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l4U0Dy1RPrxn/n2/rA9prvD0PDIYvFRDi06McwEyVG6IrVX3DLXcOS70xMWV6J8Y3/VqDMroc3r2DiNUknGQKd9mzFC2IntiigdbYbjkV2VVyMF46WJlkot/LnoW3CH3sp9QMTdYpWBNMlF2pfmL/g547ayT+Xlt61mB8DWLHPcDEJcYlq3+U3CnRgMFDDOice2cJTOEVjm3Na3dzbFEndxL9mOYCgyBRChAa9E/pju2wZvwX6wuVA4Aa4vCS12iw8jYkWaMdcogdlmJRgQkFam584O6bvr97U0fDzplGRZ8/8EHEGUTufAuGyQXn/q8CpaJ3AP2gvWelHEp9tt6Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mN1NwrCWGB0on1qce2vctp0D8/XwdyWs/5ce9JKW81E=;
 b=aTWdFjL/CWJSdUXZT/cU4tCAwddVaE3+3cqxitXxlGYI3wxxJ5o+UzslXOrxm0KO3GkcNOlOX1w9LP99X2GjLvsgjApGYF1vUMUQOnhHHqyYn1rXmoLSFI0ZBl2/7J/IbNz8K8equ6EgEu2lj3LQYl3W+SCvaKBIWUGPFdqkhy3JPSLmAbDHo0m9mwqwn0Ft2rxgWJNj1/XSQ7LLNN/wqyKceGLMc27G/WWVQLxoYr7//FRXh/wMBLCkTa+N1v3r7jr9PdqcTssbtTToxfHMf+UO+Mpzeat8uUC/4Yyg4gZLEGSEYl8Od2t2IPLYrFGJuiRuZl7xHo1QqIAUq7O7qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mN1NwrCWGB0on1qce2vctp0D8/XwdyWs/5ce9JKW81E=;
 b=oLTbi3GLS5ykYksl3bZNrG0lhCFy+wA71XF0FhVP69BbmyjS8H8jck7paZGlp0Efm/sTdknBNzcRzLy1LdsIxIsjsWEg4uAkA5fmVlyt1tj63CadYODbNhd2rEqfStb/3SDTCtvrVAAAaDctJcV1UmOeSbSegaerbsPbNKbbi3M=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 16:54:45 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 16:54:45 +0000
Message-ID: <13fe2bdf-fdb2-433d-99aa-0d8dbabf97e2@oracle.com>
Date: Wed, 29 Jul 2026 17:54:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 19/27] scsi-multipath: provide callbacks for path state
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-20-john.g.garry@oracle.com>
 <20260729154331.6FA411F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729154331.6FA411F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0242.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: b19b3c85-257c-4b24-ddef-08deed9217b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|3023799007|56012099006|5023799004|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	pBddkfGPm4iO5gaJb5quzSOZ+ZI9hOIxau18/btD1Sw4EY10HPqnB9HbPmo6ZdDOu3jHXrEQCByMw95caJ+ckMyvgIKlCVy3YcnnEIsfXtze2GrouoLJ0hxZfKQc+gbRtpCARdDyQA/Po5TbUz30gDpnIgAYQ37XHqgYZTMe89Asie2+sanwLIqhWSUdar3hid8dJR+LudbCPKCEMyqsE/SLTmBLwq4gBObVEAzRvIsRG5MOmtj9vcmd3f3ha2Bq5GbupAyIJpUWtBq2RafMsqvZzobf7qgvlnQ78/2GKzNmhiVT15v3eFMyWmQmUozXDbK7iCXDkpoNhXmElqxEVnUTOSYlbFqeVAczp1qwghJCw4wuVWMM6gYNCAY4WeZC1T3IooY8kMtX/sYuSUsa+oyaSfxnaYepi07aTRBOy7MifDxSReyEz/fgjQkKrRjbBcsqKyMdRC1kDqJsvo6ReFX1+DNK37x7heLft01wMP/8TzgLuooTz8Mkh5fkxDwxWyM0pQTvhjXooh3FnoXPkmzUzqTdLm9Hw0149BB8v+wto2gY/8pdD7XkNc0ttZByB+Pcon3xdXm4RsSl+6uEK0LSTKFjWA9CoG52YEGz9XpVcmUEMkFPlKt1wtnK92fKno99baL9KpbgP5uvPScflhvD13x+ovz3wB6OVWRFWvo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(3023799007)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkN3dXRsU2xpTjh1THhOV09nTWZHdWdOWGFRREFucXBLU2JJTThKVG5yMisz?=
 =?utf-8?B?bDd5SGZKcWJoby9zMVBoeXhUZkVIN0d2NGVNUk1UbmxWaFJTd21mTS85c2pM?=
 =?utf-8?B?ZkxuZTEvalBpcDBITkhETmhwcTRpRFVOeDMvWUhxTm0zeWNublNwU0JkWlls?=
 =?utf-8?B?elNaVnBUZGJTY2ZzVmZqeWhibVRUaGhRRjFHbXpoQjdPZk1Hejg2WmVuKytn?=
 =?utf-8?B?MVV2b0NOaEJLYTZRS0xrR0loenNTZjloaEhFK2R0b1lGVzBaU25QM3ZWWXcz?=
 =?utf-8?B?ZjV0SkdiL1hwZkk5RFVvVVVEc09kK3lTSS9TNzQ0aVFScE1iMHFQZ3M5TnQx?=
 =?utf-8?B?SUVZMU5mWDNuSFdMTnlDM05mallOckJLVDZHWVl4bVVMS1cwL29wOW11TmFC?=
 =?utf-8?B?TjVCNCtxWUduWkpRbnIvVUUxU2twRFBrdVJKYVV4bXJUQVBrZE1WZTZlZ3NM?=
 =?utf-8?B?cHdwRlF0V1dlS1BEUnlzUDJsVVJlL2VnRjRaQnhRSnZRbnFvTTBsckpCV08w?=
 =?utf-8?B?VGQ2alVVdW9Ec0lmNG42dkVHNGlYZXl5d01PWmtWWUxrdzl3SWNWbUVPZ3lQ?=
 =?utf-8?B?aThaclNRcXRCOHlUSGdtUjlCcGdJK3YvQjVRbTh0N1pyK1p4a25pOHF3R2Mx?=
 =?utf-8?B?NGxBMlkxTlJUT3lnME9tNU5zZG1UdUVBOWgwZ1lMVTZ1T1pUM0J4WTBKZnRv?=
 =?utf-8?B?aTlrVmRETFZoWFRoT2pwZGxaUUUyOGdjWFVPbE1uNDY5WjhHaDdiQ0d1aWVN?=
 =?utf-8?B?WmlGVnJqM1E4K0hOT1M1Nmp6eDQva3ovcE1hYm4wMzQvL1FqR0lPVGdnRmlX?=
 =?utf-8?B?L1lOVldYbWV2MFJTb3Q4OVB4T1MvcHRHQWRablVzSFFyNlAwZW9DV1Evb0tW?=
 =?utf-8?B?M1BOeXZObVBEQisrb3NsRGdHM1lINlVGY2pGcFFkTFlLOWpTbkRkcmc1RWt5?=
 =?utf-8?B?ekwvMndYU2VqajJ6V0FwKzdmWHVsSkUyUjlZaGRRK2pOUUNsaUVMMk5Bd1Zi?=
 =?utf-8?B?YTJHRDVqb3RNNzNCOVdOR2RRWFQxeEJScmZac2h1N1FGcmNkQS9iTEx1VVFR?=
 =?utf-8?B?TnJpNVNIUzdycnNWeXc0aXlKQndCZWh4ZVcxYWRBS2R1N0pwSFJMR0t0bDVk?=
 =?utf-8?B?YmpDeGJtQXlzeHIwUTBZNlJtYjNPckR3bjBlRk9iaFBVNkF2aWdYL01sM09V?=
 =?utf-8?B?em1nTjNZZlcvbnFRdjBIVmY4Y2VUalVWYU53TXZ4NnMzbjM3NWhLT1lQdDB1?=
 =?utf-8?B?VmM1QWUyckMvOGluSzBnY1RPRnJRd0xTQVczR0RNd3hBNFBTdUpzQTJsZzVw?=
 =?utf-8?B?bXA0OHU2NHpvVHZLS0JkRHkzUmdValpNMkpuN2tPb25CUXdCVFUwL3VqRXVP?=
 =?utf-8?B?bzZkMlJjc1VsWTk2TDZDWURIdVJ3cCtmZi9JS1RhSUdETkduaGtNMi9FM21I?=
 =?utf-8?B?aU56ME4ySVY3cDQ2SGlqMEprS0ZwcXprM3hXRU5KanVMV2FHcGdYdkZrYm9x?=
 =?utf-8?B?YlRKSUpkcW9aTmVjYjA5OEdBRmpsakZ1ZnRVdHE2cUFkUUZ5YWZZWVp2WWda?=
 =?utf-8?B?dUpVKzAxRmRRR1RhZXpZVmdUaloxTWFHRTZINjM4dnNmODNJQ2diT1FMYytU?=
 =?utf-8?B?U29vZEdTeFI3aXBYNFpRYkE5YjFyeTVkU08xODhMV29adTVLZ2R3MkVJenVk?=
 =?utf-8?B?U3d1MGVZdzhlWnlOOEJyYU40dkhvUWswVmQwNTA4S0VGWkdUdWJFYlIrSk80?=
 =?utf-8?B?S21YZ0Y0Rm1WVEpFeUtLaXBaM2dMYWxkMDdWdlpoL2RRRlREdUpmendrUWtS?=
 =?utf-8?B?RnF6dENYZWEzVU8wTXhwMHc1K2tlNXZTUzkzWjZ2Skc0SGQyajdSanhPQndj?=
 =?utf-8?B?cjZqUUFaRW9sSVRDYWxuMHVSNXM3b2o5S0ticHo2cHVwSzF1NUJ2NFp6aDJu?=
 =?utf-8?B?blo0blFqMFZBZzlNWmVPWFhnbUtuWHJZK0I1RjFUb204SUN5SXNzZFJNRitr?=
 =?utf-8?B?MWZqdXNDcUN5eDRjTUxsWEc0QVZqSDFhQUhncUNmT3VmcnFzUWpCQ2NucFN4?=
 =?utf-8?B?ZzExUnhpM3hqbmtvMS94SmxhdjhhRGZJZ2VuUXBvNFlGL0ZsNWV5bEZsUnVN?=
 =?utf-8?B?ZHNaaTNvaE5OSGpjdk85aXk3NDJ6VkF5R2E1MFBSdzAzaFNncFdZSFg3cllX?=
 =?utf-8?B?S1lGWkEvOFlxRW5Kblg0MGRKVE9FbzNvSjVnMFEwZmd2bjdWOTY2NFZEa1Q3?=
 =?utf-8?B?TCtXa2ZrLzluS1ZHSmxSUVh5a1R4YTRLeEh3Mm02UHlRVEgwWWhmUW40TkU3?=
 =?utf-8?B?MnNmQk1PeUdQZXlhbnFuVVUwUGZMbUhldkxrK1FhRGJBZ2w5L2VHTEF3ZWtD?=
 =?utf-8?Q?tcz4Uc0cZLot3O/4=3D?=
X-Exchange-RoutingPolicyChecked:
	XA/WNCNWMPFW8Ihnnim6Q8BEYTGDauoMZElalxOM6SGPzJpA2IgELNrlo34l0IerM298gxOykcT5L6heiYSVHh+WC2gOHv4BH4F3fmj+IaErqbvvHJMcS/Bg8GLVJyafoWI2BRe84LoiHk0Bof2RM3wKrLwntJYIeVHJusD/oOI2e9ufOuIzycC2ykZ6/boJg9dkjeoSQRI0bgRinKpfBy16ZgMksS6HKw7LjNmiKWIK+j/3bNiPoUun9GAu2JGtFGQEZe2cOjWlk6Fvnpl6timThC8CqIUyh2UnjdyKl3ynCz+zgp8FbeLUqvrkqCH6z2OsJIO3KcoMoPr8iI3l8w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RcTcrFAO/BDNhYmQG+TnJ/3J9eCQTbMh2867bGgUyr6Mul8I7Ggj3rNwy3tFD2AWhGWRua1hjSWzLknljxDKabV80xoSZdKipeSsDMmaVApn+5yJTSlDkyeO7IQFPrOjaD24DVuK13wivR5h9J9FR2DZwWJwVTI4lTqSHhhh5QMSgOo/5bwxbCfJG5vi00D2Ly8dFB2pWGcyr5+Nz/mdPtm5AxkkDzPYHWwNreA6aSYqmPIUruFDSz/3cpW+/bzPWMs5XO44EnDFTMweIjqUhGWYjS3A9qTgEkGhidD1/kifE7d+cgIUsr175QEj/HOnQXJRCEjF1E9fOi3xiBPxVyUUUuHwXMfWYVd54zjQ2QybAEImE74n6cVNJUJWkJMznhIQRElIfWih9BSb2nERjghmL5JB+ZHzlGHvGr3SM7Tnia/dz2bfZoK9GBIfgrI0l47fgfdJXpT5B4gWc5G659oTomfhvqIJEVjyn4WyBiSDHYW/D/eQiblK+p9bYwmYIDv5Mc9xc9v1u2nI6fzC0i4GvlNfb1V3BK+yNxEMvWeRzSEEEbTJP5S/tBYdSiJ6ix1VYPaAJYydPy3MpMV7LJ/PwYXtK8vuA5798KqqBLQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19b3c85-257c-4b24-ddef-08deed9217b9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 16:54:45.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O145hd8JEF358bB4dTNag1pEFA4Tn8zavDq2r1AXYtTpQPYy5rpfBNpPNa85ML0siTKW4ST26McP9CABHZaI6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290132
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a6a3068 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=80OGY60jKB6pAUYAg0EA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-ORIG-GUID: OeHvvNQ5vCD_i8DVzsWuLs_KyMlOOiOp
X-Proofpoint-GUID: OeHvvNQ5vCD_i8DVzsWuLs_KyMlOOiOp
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfX7cMEPAfZr4Sj
 HzFlE674DlE3xsRLC7yPWDiu5xZwQeBQTzPBygTjbFhXli5M4WNZrKdAt3htHXAZXL/pERH6H+q
 1Mu4P+S6IOeyrRlP4HRztPNmRSfI1UKptxEwg0V4E1f2/nHe70gI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfXxzI8exDzjr5d
 BiC4Un1Xbm78SMgSzDVN0up+FGZRj8OiZs95IrPJyzbKztnIx7KTNVwwT3QBvVCY/o5aqz9eHxc
 mVJqUxGNdabJKVrL4lV586csBaLWm0ehErIazNA9fdIFdCFAaie8qPFJseAawMXhfE2LzO4kg2c
 4wvRaZuB2b7j/lihbkX8wuu5aDknmjgmWTgteLfGMXOhT0/WgMmpLp2a3I0qKzVcJWoN3FCj7VV
 xTief5H3eKuQKv83JGusXeBu5mxH5Ajc+VfZ70khudusTQcy9IyoSTMgGnZHnbusTPRuAwqS9ZB
 NEz4/xeteAahFZH/W/O6gqA726GL0dXwZuP4rfbzjr5qDcXKPLDzcvP10phhpYL1/vGxfPNnVZA
 5gEFUN8qjIx53QMAUjYDEHFGuhD2cldLdvM6m0oSzVzEoBmnFxmyMeRwMpWRSdWA5l4Vjxxj1F+
 fQorHu9Tp0Y6XthNskMl/PelqySd7SAZNy2TB+44=

On 29/07/2026 16:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 8 potential issue(s) to consider:
> 
> New issues:
> - [High] `scsi_mpath_is_disabled()` returns true for STANDBY paths, preventing I/O and deadlocking implicit ALUA failovers.
> - [High] Bios placed on the `requeue_list` during an ALUA state change are permanently stalled due to missing notification hooks.
> - [High] ALUA path prioritization is broken because routing policies check a static struct field instead of the new `.is_optimized` callback.
> - [High] `scsi_mpath_available_path` ignores ALUA offline state, causing indefinite I/O hangs instead of failing.
> - [High] LBA-dependent paths are incorrectly flagged as disabled, preventing I/O.
> - [High] SDEV_CREATED state is omitted from available paths, causing premature I/O failures.
> - [High] I/O submitted during device quiesce (e.g., system suspend) will hang indefinitely because the requeue list is never flushed upon resume.
> 
> Pre-existing issues:
> - [High] Missing cancellation of background `requeue_work` task before tearing down and freeing the `scsi_mpath_head` object.
> --
> 
> --- Patch [19]: [PATCH v6 19/27] scsi-multipath: provide callbacks for path state ---
> commit a79ca9463c83fa5a5480f800bdc6d5f3fef27829
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: provide callbacks for path state
> 
> This commit provides callbacks for .is_disabled, .is_optimized, and
> .available_path. These callbacks use the scsi_device's sdev_state
> and access_state, which will be driven by ALUA.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
>> +{
> 
> [ ... ]
> 
>> +	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
>> +	    access_state == SCSI_ACCESS_STATE_ACTIVE)
>> +		return false;
>> +
>> +	return true;
>> +}
> 
> [Severity: High]
> Will this return true for STANDBY paths?
> 
> If implicit ALUA relies on sending I/O to a STANDBY path to transition it
> to ACTIVE via a Unit Attention, marking it disabled might prevent the core
> from routing any I/O to it, potentially deadlocking the failover.

ALUA support to be improved

> 
> [Severity: High]
> Does this also need to allow SCSI_ACCESS_STATE_LBA?

As above

> 
> SPC-4 defines LBA-dependent states as active and capable of processing I/O
> commands. Should this state also be permitted here to avoid stalling I/O
> on storage arrays that rely on it?
> 
>> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
>> +{
> 
> [ ... ]
> 
>> +	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
>> +	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
>> +		return true;
>> +
>> +	return false;
>> +}
> 
> [Severity: High]
> Should SDEV_CREATED be included here?
> 
> During SCSI device probing, the device state is SDEV_CREATED and the core
> SCSI layer permits I/O operations like INQUIRY. If SDEV_CREATED is omitted
> here, could valid I/O be incorrectly failed as unavailable during device
> scanning?

Not relevant to multipath

> 
> [Severity: High]
> By allowing SDEV_QUIESCE here, bios will be placed on the requeue list.
> 
> When the device is later unquiesced during a system resume,
> scsi_device_resume() sets the state back to SDEV_RUNNING, but it does not
> seem to trigger scsi_mpath_revalidate_paths() or schedule requeue_work.

No bios should be queued when quiesed

> 
> Will bios queued during suspend remain stuck on the list indefinitely?
> 
> [Severity: High]
> This function only checks sdev_state.
> 
> If an ALUA path transitions to SCSI_ACCESS_STATE_OFFLINE, sdev_state remains
> SDEV_RUNNING, which causes this callback to return true.

ALUA support incomplete

> 
> Could this cause the block layer to endlessly requeue the I/O, believing
> the path is temporarily unavailable, rather than failing it immediately
> for being permanently offline?
> 
>>   static struct mpath_head_template smpdt = {
>> +	.is_disabled = scsi_mpath_is_disabled,
>> +	.is_optimized = scsi_mpath_is_optimized,
>> +	.available_path = scsi_mpath_available_path,
>>   	.clone_bio = scsi_mpath_clone_bio,
>>   };
> 
> [Severity: High]
> How does this integration handle ALUA state changes for requeued I/O?
> 
> When no active paths are found, bios are placed on the requeue list:
> 
> lib/multipath.c:mpath_bdev_submit_bio()
>      spin_lock_irq(&mpath_head->requeue_lock);
>      bio_list_add(&mpath_head->requeue_list, bio);
>      spin_unlock_irq(&mpath_head->requeue_lock);
> 
> When scsi_dh_alua.c handles an ALUA state change, does it notify
> scsi-multipath to schedule the requeue work? If not, could these bios
> remain permanently stalled?

ALUA support incomplete

> 
> [Severity: High]
> Are the routing algorithms in lib/multipath.c actually using this new
> .is_optimized callback?
> 
> lib/multipath.c:__mpath_find_path()
>      switch(mpath_device->access_state) {
>      case MPATH_STATE_OPTIMIZED:
> 
> It appears the path finder checks the statically initialized access_state
> field instead of invoking the new callback. Will this cause all active
> paths to be incorrectly treated as optimized, bypassing path prioritization?

used elsewhere


