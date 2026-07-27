Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183A034EF0D;
	Mon, 27 Jul 2026 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169995; cv=fail; b=NTixerko/SDR1idO5tRJRyHiqnxvYlKT0UiCXWl6sm7OJzY9Ye9jpC5RruqEl6IGovJwwEtJXR8th28WHZWJYwOfms4JJgoH/VtPp6FztW9f+rp3gITaQiuWssALCHwDyhBAhL/QtVVO0xY8il6rnUBy6ch8Qnp3Jessc/CalQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169995; c=relaxed/simple;
	bh=kT/Wk1MKbVXxM7MHdZaN4P4DQraFYNH7UKSJXwVFXr0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h12lqTxJMTLjScyz6sCiBHICV6YfHysJq+shGhICm+Loc+hBh9uaVev495R5I6rPwVp9DSjsCAkw1NRsIOXPaho4EHPuBD4L6ezYLb6AGQYkXTtoLTkt/+Ag3QkbGdmIaNJvMsii1cQ0qo1ptxUh2PgMieqhw305I9Nnas/Z53Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yc51QJ7f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ytu2Qqjp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yc51QJ7f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ytu2Qqjp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RGMmno3465558;
	Mon, 27 Jul 2026 16:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2PJHGYSkbNC3XTw52ZcDKUIdgB6Vu2HNF2fA5oO8cio=; b=
	Yc51QJ7f1eoF00c2QVbemw1Ix7ZXv7e9Adq0T44X8VdoQSPyDklH+x+yfrtiPfsB
	mQWpjWRZN//HDZtstJjBD488bJVfmvdbH0s1i54lNujoBcVYqMra89y3B/vbQx31
	jYnZ253/2/TXLU2T6bgSEp2Eybt7HPSE6x4S8fdRDJGQ8B3JTvkZB9bA5hAYyC7K
	21wc39hpoG7QaUPcmHaryzZMW7JYpCGFGYjbEqpdGdNrCc5klAc/2NkRDreZ+bdx
	Uxm1dwoP9ZZrVTkQa4f/aQhrzeqlNMs7NrMD8gBnnGSMforQuSYzoXx+m/5aB+rt
	APLypCYQTnbXAJhGO0cMqQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyya70d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:33:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RGTsQD016369;
	Mon, 27 Jul 2026 16:33:11 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh88bgfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:33:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hnYNmFLVyiKBjbWKwXZxNGumaDjD00dkY/fky4TE0rsL5iRjHo1yetyP+bpwkJaJO7qBqy7rbOjkVbGL0ZVhCJoQxisILOzWO+tJYrEcKPPUkCDm0qIpDOmzPNcfKatdUchH7XN8oBe6m5XSJB2dQha5CSn/fq6e8uY7fKkUWvjnfEM5UB+IPZGYUa2opzzmAakUelPTmTne/fCPJcRehKhsDSnqOFcGXdMoalUrUvCNv5sl5EAqZTv/O1pGz9gpxlmQaZA41IlmfHTLhllJHmZiMw0YbU6U+rGVyVFn0akSbz5UU0ckrNvDoGfxISKPwp70LnEb9sQezU3XMFv1WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PJHGYSkbNC3XTw52ZcDKUIdgB6Vu2HNF2fA5oO8cio=;
 b=QHmgE96byw/AC11Z1KGvS1cliewMO+5CixjMVAgkWxAc/tulQJ5bYxNDIacXafhQFs67stuRPcglOn4Zhu9z2NkUELzdYIrn9dIhtaxBXDTKKlwjXTmYI2CCyq81AsIhvn+i7MP6RhpK8SRCw82627PCqsHrt6Z5mTI1uEAQwSQxXZSwiNEXz9EKRKL2cwOlpAOWzivapxVOflVuyDT6Bql9K//Ccr0Qs78flJSd/9D7exmlDkoy78FN54Gg+6GALqkiIEvWZWaASmuKVBRLK1QOQZyDUCdKGx6xM5++8N/JOE0zfKoeplQhaZ3k/yFn4gL9LMoKqPc178+0IiDBDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PJHGYSkbNC3XTw52ZcDKUIdgB6Vu2HNF2fA5oO8cio=;
 b=ytu2QqjpiN+UKDrBaNrRFZE5hfZu+nD6YkzkxhTQOB+RSbUH1JzPsN5mPbsljXoHOzf3LfOQsC2FNDD4LZT45q8gKVyb1vxQau2kUh3jNs0hGFEd+3aXicqIHeIwbVcdyYtXxlmt4fOZq1HWJw5oAY7pfir0TcYVwLXUubGk2BU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW6PR10MB7589.namprd10.prod.outlook.com (2603:10b6:303:23b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 16:33:05 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:33:04 +0000
Message-ID: <e2d8748f-aad0-4f65-84eb-f4277f239cee@oracle.com>
Date: Mon, 27 Jul 2026 17:33:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/27] scsi: sd: support multipath disk
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-25-john.g.garry@oracle.com>
 <20260727152033.A7E5B1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727152033.A7E5B1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0342.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW6PR10MB7589:EE_
X-MS-Office365-Filtering-Correlation-Id: 910ba825-5668-4bed-b389-08deebfcbbbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10063799003|6133799003|4143699003|56012099006|5023799004|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	oOI5uTChzLqXm1hhgtN7cRuwKe92tr0Si4+PIN7p5oE+7GVf+5ZPraSWB0YA8/323ucdfLRA6ZZAQAL6kZEdrVCciSbWlZlM6vogZ4jawNhKmeN+ulIvlZzXb5ncWJ8sukheATabGBjagQ5h94/LGuakAxNmmhOHkNzAZgrdanYl99tYhozVacTKrNx8Wi9SFqhTxVcFqLQwKHn/OCk69NuVI2fd6fb9LYbt1/J4jrT5aOJ+GcLNohf5iKUDdsDS4YISC1/RQLHchiTXAY4/gAYCaAg2DEReWG0vLxeudev0iqvc/7cskTwMBuicdmH2Y0jNAlmGoWbS01CRGIr/mTTFNBokA+/d0wE2vMPhCwElOIIzjPudqugk+GjT3xL73Q4sBQ1XwFIq6HR2Gjck/ktu1W0NeOOE171FFojpJomcHeMyxbds2fkrRtJGKbW/j62l7QYI/Q/h7O3mOC2HtC4F/1myXCNJq8GBHvOlz1NxxbRwiy8OkidZPsgEC8D8b4Hs3aHcsKefpapNYRcUStbm0lkIZtLIoN6iAvcWY5apVwJeHE+1wd8O7+lIfxysWP6mJ6UQQVfSzAbWANbHA1Uvpe2CX9ay6Tk3cxMLupIH8E4OyUM7LC2fY5+cbdGXfxdicqwsBU/Sbq1qOSiCzTmK3gOpRSAp/qGqik7OVFw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10063799003)(6133799003)(4143699003)(56012099006)(5023799004)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eE1nR0ZjVlljMmI4NkhPS3VXNHAzNW1TdWliQ011Qm9BRGExL0JYb2VySmRo?=
 =?utf-8?B?Qkx1dlVsMmNhUm84cVdmcTh6cTdOMUg1bWpDNW1YZUd4NTdJRS9nbSs3Qk9y?=
 =?utf-8?B?TnVmMGlPZHNjS2NlMkE2eHh4WmgrZ3dhdGNhYUdiOXA2Y0c0THpqbjk2U21o?=
 =?utf-8?B?anVlWEVzUkVRN09RYmNXSmNydXJZQkVIVm9rVFhCaHF2R1ZXQmtsbS9pZXV5?=
 =?utf-8?B?TmpWaDZ0QnVjNkx5U2k3djNlSzhNMW9Xd3RlZW44MWdlZTEyNE9rT2FFbk15?=
 =?utf-8?B?Zisxbi9WT3B6eFU0MlM0eERWQkNyM2g2ZEROUW14RW5PU3NaT0N0d0JsUkcv?=
 =?utf-8?B?OThQNnUrbFdiaHJsSjNrbGU2U1lnYWxCcjhYZEY1eFYreXFXSmdvRTY0NldZ?=
 =?utf-8?B?Z1VqNVBrb3F4WStMUkNnT0xPaUNGWkFOTW94Tkc2MUZaZTNadGQ3ZjV0RnhC?=
 =?utf-8?B?dFZndlhaYTdUcUY4TE1JUFJyYXkwNFdWdzlXU21aa3h6eHIyUEFDdy9lRFl5?=
 =?utf-8?B?djJTSWlRaVZMNU0rY2s5Y3B1WFl6UmI2dDJVWW1YTmJkQjZtb0VrSTc0OUU2?=
 =?utf-8?B?M1hYei9iSkVJWEdaUzExVTlabEVYRXVVZzNjWG5hbEsxUkpBci95emhKT3dR?=
 =?utf-8?B?ZHBrR2dKOFRUVnhEQmlNMEh2YzdSclF1WFVyNmtZcWNkTHJnYjNOdWRWNWJS?=
 =?utf-8?B?Y3FUbVlFWUx3SnF5a1Y3M0cwUk1OTEFBMkdkQUhodmZORHUxTDgzRFkrOUNS?=
 =?utf-8?B?ZHdDcUx3Q1BQbnpUL3NEenFUc3FJSkVCMXJuZTVvOFl4d20vTlZYZXJKd280?=
 =?utf-8?B?Z1QzanBXRm1ReUhka1B0UFBCTFFKTGwwbU14MFNITFByVW85dDFNWWx0Q3lG?=
 =?utf-8?B?SXZVdlczUUpOSWsxdUhjSzhwa2NDREg1a3lmRlNLa0lTMlhnN1ZFWmlCdjJp?=
 =?utf-8?B?SWV5Z0FCSU9JZGlpbWFSQnI2MklSSGVoRWZoRW8rbFBueTZ6MnJHVnlyYUVr?=
 =?utf-8?B?MWphcWpyN21zdThCcE5MdDl5Z0RrOFQ3MUJUOVllUm8xSXQrT3VicGVHR3Fw?=
 =?utf-8?B?Ukl5ZDFXbTA2aThuN3VQS2ZUTUl6RmNOWnBxNFladXF3V0pBWEVHRmZMQkFq?=
 =?utf-8?B?YWI2TStsaTFzTEdhT09DcTZCRFdHUkJ4TVBCQmo0OC9IaTRUSmM2aTZBeW42?=
 =?utf-8?B?M3ZtMzlXb2gxRExtVnMxVE4xVG5rS3JkN0RyWUFRT0ZJSDBPc2RXNTY5V1R1?=
 =?utf-8?B?WXlQb1doZTNUbWl1UEFrSnR2N043cldNb2Z4RWxKc1l6UW5BTWVTOFZlR0lk?=
 =?utf-8?B?V3hvYUxxMkFBTVpCcU5qbXBXU2NYbXMySDR3NDUvbXpENlJlbXhOTE1jc2JT?=
 =?utf-8?B?UE5mRUxBQVVGb1ZWbGpieHZiTTQyemtRSWlPNG15Z1llQjNSeDVJc25ML3p6?=
 =?utf-8?B?ODdHcW5RaW85dnI1MXNldDVwa1V2WmJSa1NhYVVzQlhRdkFleEdaKy9TYm0y?=
 =?utf-8?B?ZHRtSzlnSXQ4K005OTFVdXpFK29IeDU5S2JHdUgra080MFZkNWQ4eVlKSWhk?=
 =?utf-8?B?N1lVeEZ6QXpDN0tTNy9hNmlrVnZwc2FTNHBZRmxvbmZRSWdoTjgwdjZJSmlq?=
 =?utf-8?B?MWtFcUJjdGMrN1ovbW9mZTlpbDlCUlgyc3k2VzQ4V2RhYVJnOFlXSVQzWmty?=
 =?utf-8?B?dm5NblIvbUtUK1NmUXRIclNMb1dZdCtzMUxDN3hQWWpuMVFXdjNNSDArR3pK?=
 =?utf-8?B?eGx1cFA5ZUVEemhRRW05dnNpRkF0d1N2dkk5UXBQRGRhK1hWdVMxQXpGaElK?=
 =?utf-8?B?NTk0TXUzbENrc3BIQXdWSGpZL0pIWjgwS29pR05wbWZ4bDI5WWNkbkRrMUNT?=
 =?utf-8?B?VGxKSVdiTEdOb0xUeHYzMlRZU29YWHZSSHNkakFXRWhaNCt1SlJicGVrNlZy?=
 =?utf-8?B?VGZ1T0ZUbVR3ODEwSmkwRWFzZHcvNURjQkMxRVl0YTRpRkNoN0dMSDRlcGF2?=
 =?utf-8?B?S0VBWnppQXFyZWJEWkVibGdlSTZacWxlTGFFaEpHamdVZ0Ywd2t1aUh6TXZ3?=
 =?utf-8?B?M3p5d1FPRzZTOU5WTFFENnUvdGZFUTlBTDM1RlJRQ1Rja25Qbi9oSkVDeXRq?=
 =?utf-8?B?dUpkWjhJc3BieHZRR25aTmwvUjBSYVJCa01wZ0NZbE4zZFUycmpxZkNkVGp4?=
 =?utf-8?B?VVpHVFczUDF2SG4wVGcvSnlFcFhXVGozQ0VHSmNaenNHNXdtOWRhQ0YwOGJy?=
 =?utf-8?B?a21nZXYydXJrV1dOdG5ZYk1kL3l6eFBTZ0NDRTJaRzE3eWVIMThvN1dnTkZr?=
 =?utf-8?B?MUcwdUIrNzNEVmRCamkwS1hacUZIYzNOdHk4RUhzZXRkOVlmdi9nbVp4UTlR?=
 =?utf-8?Q?KFIPbe2D/FQYcoFY=3D?=
X-Exchange-RoutingPolicyChecked:
	GQdPBRgjMm/WTxSAXs5TwSv6aZidTdSPyWElSKZQN73H/PDzVRvNgOxf9yIclUCyTnp0gYRDeEFqA7c3ptBU3uEjW3VL3NMxpkbg0BzCxkQa1ZYA9YgUSf4akNiY+zmvwhqbsd3Dd7Cpmx6O00anGKV8og9gAM7a438TN8RoIqfI/8DXQAYMiRfeydJ3k32lkNiyM5IlD61ae9J2nzBL8cgdM0wgNt3F9eRnNs0u1oE2V29ipSRWxDyIz9b/4kVncG3ic01sd4qAlLicYaj1HgnXxm6hUzO7iMS5xVRgXcYhJDJ/Zfm36msrfIEvynK026jr9DEg9BVBB1kNGdBDHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wUjTInZsncnyRid51K06K/wbZn0sfCEuVx6Qp20RcJUgbk8OuPQDi6dDEkh0fuJVuYD/hhinlfUWXiKmkCSLLOdqvBTxsLVRgFQB2kK4+egiu49xkqLM4DY9ck2D23vp86YN5gZDG1Wc1jJ7fNLPLsAvBVPnzIm+RQXZ3OR7Z9ZL6WZhqh2jHvWAQZO76gNM1cel27eu07IBP9VVIK61pk5kiSNeu9f+DgB5Dz30Ni7AipCaYPHPXh6CjNYoN8MNj9+XTeE8wrgE8fB4MgCZ/BTO7I84ovA2aM7CUVglVv16hXOSy7pTALeL1IO7s8TkfOHqb+kPpBFD9fJ/xfVTh6NBaSNcENuICvOeQU4uvtZ+RbnlAGzW6oZiwhwudOzPSmg8Bu4/z0szHTVocQXwGY8yN2Po8tlw8ThaKeg5zIRGZRnz/aaRXM6JXMoG1oiBA1Mc/ZkSHufi17ne8Z16AklZUktuB0SUqqxWGszcz+Tu+/xIoCkYfR21NmxgSO1hqMAyy8Qv3HjIF4wF6AM/4+uxeMPJ8sc+SEO3XhszBz+oJa7Ma81flNejsRV/18oZ1zIXmeEuRTKs0vK24QQhe2ArxR6rCAUN7WFdJwfbX5I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910ba825-5668-4bed-b389-08deebfcbbbb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:33:04.9261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkeWNYe9jdYYwGkcY3+EIGpSVD7aVH9PS+HFlf4rorO0aVAUc1q1NjdYYPANXSZS6OieKt2OA8u+APwhWNaibw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270153
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MyBTYWx0ZWRfX6tiqcKLB+bGc
 DcgLJsEeSCeJk1W9s5Lmqh+qH9XHQbV5x7c6VwCFzitO9HGI7eYd43BVE9h3G0ktTd14TaoJczx
 SqkA6tP01X4lkYzFB+yyVf9upe+6JS/R9b7LtiRA/868LSw1r1hb
X-Proofpoint-GUID: JZP1T6vwps2FPcKfi7cXqbgopVcCkqfc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MyBTYWx0ZWRfXzeHcweWWW4O7
 osb83R2HMhYYQzC5g+dPSV/APTHnJ0RGAF4FDLZDP/gL3NYE7nFWxM+NUsWF2gz+GZtwConhwi2
 s/k2Gx5BJ3EipKEYqm7WU8CxoFZ4EzRyoKXVKwMCdyXF0Cc+VOQH+3SO6bbnPO+tL4xAJCxgKug
 WzYFROLn0NkH6VDveO2J+x5SFRMyKWiwijktMk0inXHSyoseBdM+kvxftwfH/+qDXfslFkSxFNa
 fOge7/rf94/8zRyvUnV83mJxX/R/yZstni0+PiRagh406YuI1PkViJif3Xv41PnmiW0LkN9L9o/
 dl/oFW+U4LqFNq3R1a8FrqoMut2t0xmSZJ2d8/GJxmDRoOxjkeXjdozQ+b0fXjf378aDXkRLM6j
 IF+mxbMQ+X+wy6g7OgndpG3mrRVMA/xCSQ3GrgfF64vqLqe17kdcv4WV6NtSzATT8u3C4VK4eg/
 H7zLxsYKsWzYAMFT7Zw==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a678848 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=wW_1bIYVxPqxJ2TB9DoA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: JZP1T6vwps2FPcKfi7cXqbgopVcCkqfc

On 27/07/2026 16:20, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> 
> New issues:
> - [High] Concurrent path removal and addition causes a TOCTOU race that overwrites and frees the shared `mpath_head->disk`.
> - [High] Uncancelled `remove_work` triggers a Use-After-Free if a re-attached multipath disk fails probing.
> - [Medium] Missing `put_device()` on the `sd_mpath_add_disk()` error path permanently leaks `struct scsi_disk`.
> 
> Pre-existing issues:
> - [High] Direct `kfree(sdkp)` in the `sd_large_pool_create()` error path causes a use-after-free because the device is already registered in sysfs.
> --
> 
> --- Patch [24]: [PATCH v5 24/27] scsi: sd: support multipath disk ---
> commit 6b75fe218921318a27f170eca853c70058afe60d
> Author: John Garry <john.garry@linux.dev>
> Subject: scsi: sd: support multipath disk
> 
> Add support to attach a multipath disk.
> 
> We still allocate the gendisk per path, and this is required for the
> per-path submission. However, those gendisks are marked as hidden. Those
> disks are named sdX:Y, where X is the multipath disk index and Y is the
> per-path index.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 36c745cbb2619..f044b2dfaa9fd 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> 
> [ ... ]
> 
>> @@ -4035,13 +4138,259 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
>> +static int sd_mpath_probe(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	mpath_head->parent = &sd_mpath_disk->dev;
>> +	mpath_head->drv_module = THIS_MODULE;
>> +	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
>> +	error = mpath_alloc_head_disk(mpath_head, &lim,
>> +				dev_to_node(dma_dev));
>> +	if (error)
>> +		goto out_free_disk;
>> +	disk = mpath_head->disk;
> 
> [ ... ]
> 
>> +static void sd_mpath_remove(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk->disk_count--;
>> +	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
>> +		list_del_init(&sd_mpath_disk->entry);
>> +		remove = true;
>> +	}
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +	mpath_remove_sysfs_link(mpath_device);
>> +	mpath_device->disk = NULL;
>> +
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
> 
> [Severity: High]
> Does this create a TOCTOU race that overwrites and frees the shared
> mpath_head->disk?
> 
> If sd_mpath_remove() and sd_mpath_probe() run concurrently for the same
> scsi_mpath_head (e.g., during hotplug/hot-unplug events):

If sd_mpath_probe() finds mpath_head->mpath_disk is non-NULL in 
mpath_alloc_head_disk(), it will error. Only after 
sd_mpath_disk_release() -> mpath_put_disk() is mpath_head->disk set to NULL.

> 
> The removal path drops the sd_mpath_disks_lock before tearing down
> mpath_head->disk here. A concurrent probe can then allocate and assign a new
> disk to mpath_head->disk in sd_mpath_probe().
> 
> When the removal thread resumes, it deletes and frees the new disk while the
> probe thread proceeds to use it, causing a use-after-free.
> 
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
> 
> [ ... ]
> 
>> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk->disk_count--;
>> +	if (!sd_mpath_disk->disk_count) {
>> +		list_del_init(&sd_mpath_disk->entry);
>> +		remove = true;
>> +	}
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +	mpath_device->disk = NULL;
>> +
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
> 
> [Severity: High]
> Can an uncancelled remove_work trigger a use-after-free here if a re-attached
> multipath disk fails probing?
> 
> A delayed removal is scheduled when the last path is removed. A new path is
> then rapidly probed, incrementing the disk count, but fails midway through
> sd_probe().
> 
> This cleanup function decrements the count back to 0 and frees sd_mpath_disk
> and scsi_mpath_head, but it does NOT cancel the pending remove_work (which
> would normally be cancelled later in sd_mpath_add_disk()). The scheduled work
> will subsequently execute on freed memory.

I'll fix it

> 
>> +}
> 
> [ ... ]
> 
>> @@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
>>   	sd_revalidate_disk(gd);
>>   	if (sdp->sector_size > PAGE_SIZE) {
>>   		if (sd_large_pool_create()) {
>> +			sd_mpath_fail_probe(sdkp);
>>   			error = -ENOMEM;
>>   			goto out_free_index;
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but does the direct kfree(sdkp) in
> the sd_large_pool_create() error path cause a use-after-free because the
> device is already registered in sysfs?
> 
> After device_add(&sdkp->disk_dev) succeeds earlier in sd_probe(), the device
> is exposed to sysfs. If sd_large_pool_create() fails, the code branches to
> out_free_index which directly calls kfree(sdkp) without unregistering the
> sysfs device, leaving dangling pointers in the sysfs tree.
> 
>>   		}
>>   	}
> 
> [ ... ]
> 
>> @@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
>>   		goto out;
>>   	}
>>   
>> +	if (sdp->scsi_mpath_dev) {
>> +		error = sd_mpath_add_disk(sdkp);
>> +		if (error) {
>> +			sd_mpath_fail_probe(sdkp);
>> +			device_del(&sdkp->disk_dev);
>> +			del_gendisk(sdkp->disk);
>> +
>> +			put_disk(sdkp->disk);
>> +			if (sdp->sector_size > PAGE_SIZE)
>> +				sd_large_pool_destroy();
>> +			goto out;
> 
> [Severity: Medium]
> Will this error path leak the struct scsi_disk?
> 
> A failure in sd_mpath_add_disk() triggers the error handling path which calls
> device_del() but misses the corresponding put_device().
> 
> Because the kobject reference is never dropped, scsi_disk_release() is never
> invoked, permanently leaking the memory.

this all needs to be fixed in mkp- scsi treee

> 
>> +		}
>> +	}
> 

