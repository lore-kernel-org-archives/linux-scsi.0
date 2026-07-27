Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751243AFD03;
	Mon, 27 Jul 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166307; cv=fail; b=F5WCHGl/xFzA5lBvdRk+7YXjjvK75cUndyBhrQ2cRNWEimmvsQZxnnL7eRZK5dw8XcS7ZRYz/KoAfYI7dCCIoLjePL2xTr32l+fmk0470mK16Ovso4xBloCxEcA8BwWc2LQN9A64yvpedrft5159+OS2i0U9fUdkPu51Xs6gi+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166307; c=relaxed/simple;
	bh=6HcZSeygH+QcLrgxWebvLZU5M7PahrKUF2xZth4ujdk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iJN707Xa0YMgUnOK+/wh9EkOt3TcxmcAQJ10we0BQFJV3tsVYvLdqGtrMnLKVFaY4SfU3XZap8V2M/5dXcyU7Tfq0oBZaWATIcOOOdnm4q/azHAZTMQgZrYGH1qVsgOmVl9CRN26GvOjQsBCStvOMz5xVp0GTOGQqGPzQaAC4fE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ksA6dHg6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JH/hhTcf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ksA6dHg6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JH/hhTcf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66REtYin2309076;
	Mon, 27 Jul 2026 15:31:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nYbnOX63FKDDAvW62hqjYf7TTMUKeQFKb6YdUVpUHHw=; b=
	ksA6dHg6tknn4XKtexLBoXvDbhvgJoibwshD2/08Im1fZFZrSrnQWq5mlhuUFbi6
	ewEedWJIAvBAIl3YAC08O5G0lsCgKAaJv0fY5SdLg2a3XWSdM1abRd/GWQPs5cQ6
	vNifhB5QbNTBDpov5LczfOA+Q2oR2qPDnx+OB+a9EM3Wa9YGHyF8CVGmIPeJ1T8S
	OvGO+PmU7ae443IT/R8zTOCPyMIvG8oVukv925OF4RhytXEhNAxb/w6LCEIy0Y+8
	y6xdTV3S5P0Et1E5VnSlsmWBI41QE8GohnB0l5h3JM3vFjF8ebBwRRejuI/d38hq
	L7vhTZ0WWvMXyxDobb+tEw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1da1t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:31:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFPZsW007236;
	Mon, 27 Jul 2026 15:31:44 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6njyc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:31:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nyQOdR8yrHruVZV8i1kwPjpFtUuvpMTE+KOGvdPs7Q7R5D9r020cQSAF10p0uSOrg5xVQtPNDCffNRb4LToiibIkhXs6M9+16QzZadSoflp/iohZ2PLYIJIVjeAssH7NUK4YNgud7+Qmj+J5+D6B+PUpBXQmqw+BZy32MIo5dGm9w7ApdbXgz7Ru4+nlvmQZpkLmQDCDkDL8qbp3AVqXVwum1Fa3vn8TPENZSddnynQcpBi43xavS9kQSZ7KJZ6bBpHSIGnuuuXsMCcYwPP3WxyfAAXpR01ryNeGH7IjNzRmRKez7sIR3z2yxcJtvd0Kf8mZ9Ccc343pizYYBe0HGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYbnOX63FKDDAvW62hqjYf7TTMUKeQFKb6YdUVpUHHw=;
 b=wSVWigakCyNDhdLIQiI2qMy2Kvm881myBv0ZWBD0LWOxG0dpZE/wzsq3FFKZ84COchHKXm+heXMsBuoxgXh09zjZSvSz2Mry7fcy2tY6JtjxaweCufDJ5Lyg/iDp0xHXwQt3KWo1yxrgXIGibPcJJwzVlstQ2+ox1VgfDZPKAi5ISacigIgwEax+NlRcAQIEGvLwovO/QHIdcKVsnJ8AwREsD0Bl9M+GWfK0UwSMu2jwOgEJ1ZROigdJa/+tG7AxBOTLolQ9iypqAnceogaWM2ia9NYyuOBOuNvqw9cz2v0Cao2VHTcQIiHPy5zE58R9eZSWcWnh5xBYU9wmXYPMIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYbnOX63FKDDAvW62hqjYf7TTMUKeQFKb6YdUVpUHHw=;
 b=JH/hhTcfEjRY0+KDdXe1/2cuea0fJo/WcLeLZ54kF4Y3JldZVvnSP3wwDV6LLPsvHONApB/Wn2e2LHcGWtRvp18lDWiD8pL4EfHd/zi3maK62BQcjGHnqC3IXkpOX+RrtiNbEwxn4nqQwkGWvfGFjwvHTNf+/YZneFBxqYoNrLo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA0PR10MB7370.namprd10.prod.outlook.com (2603:10b6:208:3dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:31:39 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:31:39 +0000
Message-ID: <55a71f96-722a-4b7a-b22f-2279fe1ac879@oracle.com>
Date: Mon, 27 Jul 2026 16:31:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/27] libmultipath: Add support for block device IOCTL
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-9-john.g.garry@oracle.com>
 <20260727150808.6E2F41F00A3E@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150808.6E2F41F00A3E@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA0PR10MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: db3e7a62-5f32-466c-4ab7-08deebf426f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|6133799003|4143699003|5023799004|56012099006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UfFH2etx62BZpLvk9eB12GaFQ6BrPOpSwaNWNBEi+UrBh2iJFiHaTARbqjEXZQe8lomedvB24AwmU8vsLZJMSY42Djy7SAYuEPT5j6jPBSrdfsl1cayujbfY1gbOROeKS5WBVv/wjmkv/c3UfrzYaXPEbc51h4ltBrvcWjkqO1i4sY/LZrJSF+jXCFJf4PF0s/p5/qwh5c1Sg11E9QcF6NhFn9tcpLJVeqwqQaWYjON+RbJa6okepLTUCVmBLm7z3CQ7B3lOSfpkCJTus5jP9qO47R8nJ9rv6LuaLppLObFAXkSDj1pzMMM6WY/pyShWTCNyh8avNn+in2WwuJte27jBV4Mzm6z4vXCcNCg6psdlJtBR3JOkwVvDSfpq1Fmoju3XChYNMP2bvLOOYn3uutg5CRqpuljOAlek/MsFTXb6rPjKGJ+Vh5cRMzy950XASAaP0dyosCqBRzhHgN2Pvl20Ie3IhSc5aJpHVMMOvxULu7XGRLeTFHd9hoqt92JYS6PldbqfPhPEEwcrnVeKzSyZMS/17ba/tihb27blKuqR0ZN9nXThypangidjF6QUl74hGjW6ygAq9evCOLfWfOcoLuQnIzzpu5VqOG8srAi1guDe4sQzedEqaksmvaHVDKlz7L0Zq7IfyhfwYg2aMaX6/TtEcY1su7250mm3j1s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(6133799003)(4143699003)(5023799004)(56012099006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFBJZG5Rc0lHcW9TSVowQU1Xa0ltUmhmdHFOSU1SWDFhRDRxNGlLamZZSzk1?=
 =?utf-8?B?Yi9jemQzOGdkTVArR09BT25iNGlwMkc2QnNyZW5mK0RGeFhTMHNkb3UvSWhk?=
 =?utf-8?B?bW9HRVZmUzQ0RzlnOVY1R2c0TVNvWUF5WkZwUUFhcFM3VFVzQmtNb3VYYVNa?=
 =?utf-8?B?WHE1SEVJZFdOTFRocXdCd2tTYTlZRm5UbmdEdzNtNFlHVllZRWVPMjFHRnVv?=
 =?utf-8?B?dnpjUnEwcTZYVFRYeTVJejhEdFcrOTVVUHdQN2wvQmlkeFNLOCtaRXg5QVVV?=
 =?utf-8?B?aFFVd2pFem81YnpyR2F0OWRQcVhuWEFZbzBXNU5OdkYvaGdFVWxubXYyWWwx?=
 =?utf-8?B?dlgvem5xOXdFcVpSQ3NWR0NWTXlocDBYcDhla3dHQjZnT2lBSWxyYUJCaElI?=
 =?utf-8?B?RGpMTnhyc0xGRjdTZGVEM2poeFVwQzRrRW5kNHhzcnlGQ0Z6OG1HQnVTQVpR?=
 =?utf-8?B?V2ZUaURzVGc0cmQ2SmduQ0FtN1BRUm01L2srSTZQeHFxc1FLOHdEOXlUME1y?=
 =?utf-8?B?UVZwVnI2RnQySmluOU9SWElsdmRJWXZJY0hJQnE3aEpmYnF0emFNblJwOWE3?=
 =?utf-8?B?ZDlMV3kwZ2ZhMSt2M29JVkF6WU16QTY5cXF0Z3ppQmJhcFQ5WHRFeGhBSHlk?=
 =?utf-8?B?T0F2U2ZaQXJqN1dMOTFIaHE2VjhFdXBlTi9wWXhLQzA3ek8vVE56UUM5UmFP?=
 =?utf-8?B?d3FocmpWdUVhR3lualVBdG5VczBUenhSQmRrbFlxU29mRW5VcVRxa2p2WjAr?=
 =?utf-8?B?YzlEQTgyZjB2cWhLU2k1TjRXdzM3azJYaldRMXBWZGxwZ3ZCbkhVRDlLSWQ4?=
 =?utf-8?B?bWFuMVlUSTBCTWxwdkc2ci8xOHhxbEkrMFVCZjFzQjZzRFhKaEx6dURWbW9z?=
 =?utf-8?B?bXh6U2tIalY5b1lCZjU1YzFtTlNTRVNGUHJOSHZ6d2piRXYvbEdjYklOT2Q4?=
 =?utf-8?B?YTNjWTBuWHMxVElxSVp0Zm9oYzlYYVN6aXpYa2RVRWp3TGZmNXp0OG1VeElK?=
 =?utf-8?B?MzFSeXZSNk92WXdGSVBqVm5ZM2NLcFMxY0NxQkQwV1h2aG1rbWhscXRoMUJw?=
 =?utf-8?B?MXNic1M4NW5YMmtzVnhDak5IMnRJMzFMQi9TMVppdURpZUhvT3EvT09QY3du?=
 =?utf-8?B?WVBkYjFNNi9ZTjlyKzNNYkY0czFUUVhmdzc0UVh1QkREL2pqT2d5K0s3Mkl0?=
 =?utf-8?B?TWJzS1dvNXdKdnNQclIwOFZmMDBDQVlVcjdjNkhpYTR6OEJUVjZUWnZwazU0?=
 =?utf-8?B?NGVjUFFxREExbloyRlZPcHBQRWtpb2ZtMzdGeS84SWRwS1N5WDgvOE9vY1pS?=
 =?utf-8?B?ZlRLeDlCVUtZVkpkZytEZUdkbmVQMUkxaFBueUl1dmpnd2xSWXJwZFg0cFl2?=
 =?utf-8?B?b3RFalk1Ym9JcUJtZUhsVnJ5anpPLzRhZVcrYjI5STk0ZkpLR0M5VCtWRE5i?=
 =?utf-8?B?VU9rTXhzbUZwaXEwakRObWRIdjliU3N1QmMrVG0zTWNhMjF3b2x3VC9Pbmpw?=
 =?utf-8?B?aTlqZEF0Tk5YelZLc3pOSW9VbTREVkFYNGsybjFTQ3BTNlpoUU9naUtiSHc5?=
 =?utf-8?B?S3pGb2IxVjZRY2xlWXRmV3VzdlBBRXpRandjTlVuSGxQMHN1QW9nSFpkSzJz?=
 =?utf-8?B?OFhuZi95L1hoVm1Rd3hEKytxSi9COEltdmdINWYraVRVem9xUEFyTkFLOEhp?=
 =?utf-8?B?QjBxQ0ZYWWFoM3VTSTFLYjZtV3JBVVgwV1RYQmUyaE5vSVJMTUxZWGxRRmRS?=
 =?utf-8?B?VVpCMjJjRWlocnZtUUcybk9ocjNYL1ZybnhTQkI2dHNhaXlqQ29rZDBVSUhp?=
 =?utf-8?B?VFNrenNmelBrVG85TkxPeXJKOWRhVi9Bcng5d3p5S0IrcTFwb3FRRDFUTHRr?=
 =?utf-8?B?RVNDV1NuaUhqTGxyU0pFbkhrdVZjUk9zQXhmK3k3aFBYNkhGdUQyOStRYWZM?=
 =?utf-8?B?ejFWTkFSRzZjZXlMaDBoOXM5b0ltS2R0TU9rOU44MXdxU0pzTWllSnpzR0VC?=
 =?utf-8?B?ZWk0Nmo2SEJtNGNLdFlCL1RHeGFpUnZ3Y1ZuNVVJRVI0UndJS2crUnJNMXll?=
 =?utf-8?B?SVRJc2lTT00wVk9PczQyZ2wxUEFBRzlxaUxWbGUyVmlZaU1BczdYeUpZQ3Q2?=
 =?utf-8?B?U2Zydzg2MGxzc1duamJGNDVobVVMbTN1VnhJd2hwR1ZJRHpVMUN2QTc5bUpK?=
 =?utf-8?B?UTJHMnFZZjlvOXBka0JSTXpPbnQ2dTRHcGtNbk5GTisrMWZubWxpRGxnb2hj?=
 =?utf-8?B?QVN1Q25BNHl6bG1OKzcydy9QN05FQmszZ01tQXlhdGVRRnYvRnJsRUhLSHNQ?=
 =?utf-8?B?ajMyczV5dUYxNjcrME96WXE5cktYOVFxSVphdldUYmlEODNJSi82RzlPUUxJ?=
 =?utf-8?Q?nUYjqKwotvW9AdEY=3D?=
X-Exchange-RoutingPolicyChecked:
	PsEOnrISyWjP/5SpBqn2H8uv4WZbA6MeDukP6mECGmmK/zCrP8oTPtf/KWpzXeRbPOCbhTgNMcH2aCLg2H4eH6awqQ00m9yieY5gC0yNAM43d909fQ50hI00u50IYBP7SMBGfB2+5wXXSMyi327Ki5I3T6KiatwpeR5zwAKh8VqaOUFUrsEv0drkcABB9/FZUpWoZ/VMPpmFNzP1hrjNYiIKpHYwH/aRmX8qTOh+yl2z8HErWr9Nq8q6STAYO1gOZvBHcs/lV3HxZrj3yA6wFH93ekTeQW4znoo9eHiX1HNNcabEYwI4KbSVAFnuUjd2gw3PHOrRqStPHNoNUEjEaQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MMbHRx2Z+qf+XicTV2uhARnViSz9Hy69CXVkFbewE/TVEyObwcv3fTFeb5sKdksVfrRkR7iyHH4A8TVmQw2ljAj7xPYzTkQ7m2LxdtFzrtscPAHaPLzwPwu7AMF6FGbwMOS481A5grbXmVH4JjZoA/AXwQopELoXXB4mH4Ix/DVy659Ob3hyNXjphLb4YoK0g4TiYDjO2JfXy1ZTXVgWbzp/4W999OnVkrEFsYxqzLm2bhFrJ4/RjaJAvndtB0z3o951roVm0bWcvPBL50zAgb68eWAdzFLWIEkhBGya8wlbhaqCkiCiuCqpsHgG3rzjqp//hMISvLL20jxzmMm9MsSednqmawFHLq92NyIhTBYT3isS0dVoQjWUE4u4dkZohatbgpU/LjTY0HcCDClpODS9A/poaFyrReZNNc4j6s0S/+jrjeyYUnGFw2t5XkTOwoTevZqDuSHl62+lB3Y3FTjASpwLXiubdspQNbj9NUnnB7bPBJ8c1CIPA986+XslkLrotcw+bGMxrbXKjjL0XqzMdJLTgfQbjmnbHUkvao+kI8GFMs5yalbXiwPZOaGcrRSeP9Ac4rvtyAkbEZsKSECHfo1EdqQxcX1QgqhEXZU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3e7a62-5f32-466c-4ab7-08deebf426f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:31:39.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKhMJcUc5LM2vJuF8/3vHSkCTdYY2sU8R2y91MJdA1kZuKWJsaRQ6Takma2sba4lNSs8A2aAmA6YfF4ntuR5Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270145
X-Proofpoint-GUID: Tsh8jsqQwbef2pmhs9-wEpGrHZKFq7ZF
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a6779e1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=qNEwBktK_V8bKlmVZ6MA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX93y3I3hqaKfd
 WfB/8LCJ+l0W5X9jvwL1imbCVqdSIRIGWlhfGMoTB6kZz8lBQiWkY89AKFDb49VylwUJ8Y48y9r
 ViyxrNSKpxf2H+GGGAvx5aPsvAYJzj8ujbxZVhyZyrTNcx7PWyGL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX55GY5sy8c/IW
 Kzq7x5JJiUEJ0+UNNdU+sRfy9nurEdgryazIw83KmgAlkVc//Z7Q1WUa4dmeIM5HfDF7tAISoId
 qd/eLpcB+059/hTwhPj+s8yaWCZ0+trBK5whFqA0nsLD4xm/h2txE7MU92Q4+5ZRkr8P53sEDYK
 vD9RyWfyc5oI37Tb4m+I04cby6j4SyccF2V/di/R24qtuZf2x8mR8S6iH7BEE4JA48SUKC77HXr
 z8GJFAtKDjshxetHmlaxJsagFkuQnr5QYWgW8NLXLKF69iUQ0wvDTS3HVjFIYDrCER8ynE3io3y
 H6xykqSYRLqLVsEyDmPVCcKXI/Lyctx9pLuPZqW0Oeh8eDmztkwjjP3kET/vN7yOnywYzqLXXfv
 0O6pZtIzYJZY6rnbVzvmpEP6bq5+yJeN+VYZP80fhpPtrzHsGluU6kNuYKt+G0vtekFu1SX2dgO
 hljAmcwoB+tOJlLXzPwTIKk2FH7iJHmBfgZDI7eg=
X-Proofpoint-ORIG-GUID: Tsh8jsqQwbef2pmhs9-wEpGrHZKFq7ZF

On 27/07/2026 16:08, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Holding the SRCU read lock across the underlying ioctl call causes an AB-BA deadlock if the ioctl triggers a synchronous path removal.
> - [High] Forwarding ioctls via part0 strips partition context, bypassing partition-specific capability checks in underlying drivers.
> - [Medium] Returning -EOPNOTSUPP instead of -ENOTTY for unimplemented underlying ioctls breaks userspace fallback mechanics.
> --
> 
> --- Patch [8]: [PATCH v5 08/27] libmultipath: Add support for block device IOCTL ---
> commit c97bc7070dfdd2d761dd1464c23d043908adfc68
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add support for block device IOCTL
>      
> Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
> handler calls into the mpath_device bdev fops handler. The .compat_ioctl
> handler is given the standard handler.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index c78d46a446cf3..af90cf38a79d6 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -454,11 +454,47 @@ static void mpath_bdev_release(struct gendisk *disk)
>>   	mpath_put_head(mpath_head);
>>   }
>>   
>> +static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
>> +		    unsigned int cmd, unsigned long arg)
>> +{
>> +	struct gendisk *disk = bdev->bd_disk;
>> +	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, err;
>> +
>> +	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
>> +		return -ENOIOCTLCMD;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +	mpath_device = mpath_find_path(mpath_head);
>> +	if (!mpath_device) {
>> +		err = -EWOULDBLOCK;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (!mpath_device->disk->fops->ioctl) {
>> +		err = -EOPNOTSUPP;
>> +		goto out_unlock;
>> +	}
> 
> [Severity: Medium]
> Should this return -ENOTTY instead?

will fix

> 
> Returning -EOPNOTSUPP for unimplemented ioctls in mpath_bdev_ioctl() can break
> userspace fallback mechanisms in tools like smartctl or nvme-cli that
> explicitly check for -ENOTTY to determine if an ioctl is supported on the
> block device.
> 
>> +
>> +	err = mpath_device->disk->fops->ioctl(
>> +			mpath_device->disk->part0, mode, cmd, arg);
> 
> [Severity: High]
> Does forwarding ioctls to part0 in mpath_bdev_ioctl() bypass
> partition-specific security checks?

I added that check above

> 
> If an ioctl is invoked on a multipath partition, passing
> mpath_device->disk->part0 strips the partition context. Underlying drivers
> like nvme rely on bdev_is_partition() to enforce stricter security on
> partitions (e.g. requiring CAP_SYS_ADMIN). Because part0 represents the whole
> disk, this could allow users with CAP_SYS_RAWIO to issue unrestricted
> passthrough commands.
> 
> [Severity: High]
> Could holding the srcu read lock during the underlying ioctl cause a deadlock?
> 
> In mpath_bdev_ioctl(), if the ioctl triggers a synchronous path removal
> (like an nvme namespace management command), the underlying driver might

we don't support NVMe yet

> attempt to remove the namespace. If mpath_delete_device() calls
> synchronize_srcu(&mpath_head->srcu) during removal, the removal thread will
> block waiting for the srcu read lock to be released, while the ioctl thread
> holds the lock and waits for the removal to complete.
> 
>> +out_unlock:
>> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	return err;
>> +}
> 

