Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13014368961;
	Tue,  3 Mar 2026 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772542815; cv=fail; b=EG6KmreEgo7rgJL/GitfJAUw2i8a605jznXplEDPmYO1tvrz18bnWkNUT+Z5OPd9Hd82m4SkNJ5Mw5qyvvJECI5nGIOgJ8gL6xHyVHs48rlbtReCBYwpBDl+Av59T5xj0Y8qAGrNyu9grJDKmfpRSjSPXCVm27VvluZ1Ewr4ebc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772542815; c=relaxed/simple;
	bh=xkt+fmrW/X/iFexTRYX5yCnOVGDDJ4tz3WxhbeSpS6Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uW/udaRVgGoBFlq3I8n6nROgNEq4v3S/5RmYH7n+WMshVT4KlJY7VTpqg52YlJgvRChkW7qY3PCdq5PiWQL7brO7gGq+pHwTUi9LIb5ypl7issVYZ9iHctdPJZx19RAHnEkHgsd34jpVOT0F4inhcNkAYosiS3WbKZfWBXK+jJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ImnfwRpQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yCH80wZz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ImnfwRpQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yCH80wZz"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623CZXC6290476;
	Tue, 3 Mar 2026 12:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PA2gDisFVLZFb3VlM4uzNPkZzfzbUIKalbs6CljGmts=; b=
	ImnfwRpQqgSFQWeAa4mNyxVAv+0ihhoLP/lXt7nuWjKlItsiagXcn0JXimPK06Nc
	TzV84BxMKZBGBIiiDLaK+nbwxwd+cdQAZHKdwnjT/1g05cgBPdbCTy4XisLPxCnN
	x3oksByQ0Ta6acW6Tuhuvmz/gR1hEg01qgLHoUk/5M6ID46E4X3Nx0kaUxAZj3TO
	IUpUnq8WUUAB5ExAWKXUdt8VGbye1Lzk2ud3AdN/7XM4M/82n2v9RxEMc/GqoX2f
	8NooViwm+y1Tzt2DXYLkmNDlK3KJnKYL2jPaqfHUwu6lmdNP4acoH1DmbtnmusFy
	6ZHyib7sF3vqoLxkNEeSWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnysjg173-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 12:59:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623BjkYT037193;
	Tue, 3 Mar 2026 12:59:46 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012013.outbound.protection.outlook.com [52.101.48.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpta159n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 12:59:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFK+2gEaibtrUCYU0XwLnbxS4Wi5wK86Hp2zLNIHKN4mWfEzAF7Q38EXH2BRY7yF9eXQb48MJNBGYt7cVUE3/jsPc6a37QmtcErrpzPSK+ukWwBYT4KYUeXqoU+ra+BKlbKy2emsBi+KDF2AxHPXXmkSJ9u5XDy/yFKoBWClRuRJ28HCxmEQl4nWTog66zN9uIs43g4pUdOxxI0eRhDYFGWGhC1obSeqf8bDxsRkRfjwGdFAWlqYy/mZcI2xjxR4nFlkk/1v1147MOKvowkTcdhYvFHf7fQLDEaHSKxayCOo0INC+pFp8a+rqWB9zqhhs8hbLnxKJgyHEbd957JbeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PA2gDisFVLZFb3VlM4uzNPkZzfzbUIKalbs6CljGmts=;
 b=bAkYjOU7FXEmBGiK2OXoscoqKlC3rDE3BR7wVHT4jDlNThVx+jvbVCRXIakAWwjn2sruYLB4Fl84Ypu6uUv7SxB3xDNBSlORs7lir1dMvU7bpC9xH9ctwIimfIl2qI8PrPHobOkZ/DRutTdZsDl8Y/xpmtfTJd3VnHGwejygx6ybhgiMdxG7S40+3EQzjIxJm/qlF50Nxrq3gZddnbq5rMFAWMrtAKBeWrB/2ky/3+dI642F76xVReSwusjzzBOB2IQoKzYW6P7aUqzPUfWuK8LQCwDm8p3C8MLxv2OK47NpuyIS/GXUnWmM3GzzT29VDgdMFH0+FYoqTlkrPfdgiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA2gDisFVLZFb3VlM4uzNPkZzfzbUIKalbs6CljGmts=;
 b=yCH80wZz6qV4CZvj4H1hqIvKkkRja9UuEgNxWL/FIoIorDh1tOfe1ATdFya2NDGGyYRaq7CTQsgtqjRy+2CpqQUJPrRfoT2U6U8K13FPW06fchC9C6tNfRYg+K2pMVKbhNjHgM33eYAgax24qY2NCQrGVcccwU9CIdRKeb7RV4s=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH4PR10MB8028.namprd10.prod.outlook.com
 (2603:10b6:610:23d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 12:59:33 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 12:59:33 +0000
Message-ID: <811e7fd2-799c-4e93-b0b0-222b131d918c@oracle.com>
Date: Tue, 3 Mar 2026 12:59:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] libmultipath: Add basic gendisk support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-3-john.g.garry@oracle.com>
 <98aa0bac-bf62-4e7e-b7c6-d2547ab34ef7@linux.ibm.com>
 <50b1e223-9c4d-4db9-990d-089540215953@oracle.com>
 <09240997-29a9-4463-9b6c-3e3ff30c8756@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <09240997-29a9-4463-9b6c-3e3ff30c8756@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU2PR04CA0239.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH4PR10MB8028:EE_
X-MS-Office365-Filtering-Correlation-Id: d01e2859-02e7-477a-51fd-08de7924b708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	kzu1LlsDca6yabcIVLvfIqFg/wIC/VnY3SvcRQYeahtlbxfnYlpEHlGjmNV2PZFwKA/ivBHXfhzsN3fA/ycfB99tGT5TFjGVR9Z4AYuvge24iYD0mD8Y9l1BsTiM3aWjQdKXgtyvUipXS0CQGbR3lT6MbDgIXlWJhzj2TsVA8vLcZIzC9fsNSMDL4/WkvWF0PfZOltNP+VnBR2JPCVIsyvp8QWPi/jS/Z3shWb22YChDDH2Zq+FxiNEzWpgcnog5w9BFukfiJO0Xhdh9wuSdq2A4i0gslpRlLyBfGX0v4HGXCFnpNsnOWro/0G3iTmE51ijR5mdmdsNORwrW1iwtfZaA8WcuezqPm/IxZGEd3ejiep9yP5tmxqj792BvuQnebHdoaYlG2as/hBCU6FkbSkxk1AiDfl2E2+Mk5SsAXQyRdYI8csce63ozaZUUbDR2ZyL2skxodOfsZxrsGNMxX76Uz42lhE+ysj2Iner/ar8fIUChIWkxAsq6fxersT2U+Ks8gjEtQDs579eYLmH8H+zwlgL7CcZczuiTGUGERG6MH6sh7rtg0s+yk3gfqP2w5nwBEbeD/dbbsJIiGXA2jb+6HLMogiACJ5UnM4UwX6SN/4oGiDqh1ER0q/QaksozPo+1m2nbT929Zr7vYBZbnHAh0QiN6vXDLn2GSTyBqSn3NhktTu1fz1ei/fg3xEWDndFI20jfdCE7T3Upep0/t5BisBHGVUseTNOIDcZ3sLY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEFHcEZMMXlQZzRFYWl6ZitvMjRHdEtYcHoxdSs0UzNVNVVzQUpvbW5OOUxv?=
 =?utf-8?B?eUVWS0dTZFVBZWNvRElBYzgxeWpLVHgyTysxQVp3R1NkVXFQM2VZWEoyWGlx?=
 =?utf-8?B?WHIxQTR2K3V3ZENJcFpHRWRncVhsemIvU0ZXUGROM0M4ZU96anJ0Ri9vZ3lP?=
 =?utf-8?B?NG45ZU9BWll4S1E5SHU4MVdmdUg1ZFptMWdvQWtoNkpEeCtLN3AvMTZ6USt2?=
 =?utf-8?B?RkpHU3VwZ2VpbUIrTlo3VzZrRGtpdnIxM3hSWVJPcWFRaTRzZjhYeXBtYkRI?=
 =?utf-8?B?WHByK2pnNFM1bkdYVC9WcXUxWUJHS2I1eU1QZEhabHFycFJvaGpRQW9reE9Y?=
 =?utf-8?B?SFNuMTBEZEVxQTVzQS9ndW9aSGhza1FoVVkvQng2SDVNSVB2cmlnRG9DUzVW?=
 =?utf-8?B?ZVBORGtEZDVobU0yOUY2VXJBVGN3bWFoMi8vNk4vNG5VRTBkZGI4NkQxOTl3?=
 =?utf-8?B?RWlpb2hhU2FPZ1VBVHZNSW01Unc5OU5MdEt5QldTeUpoellyeE9VNnpNUUl4?=
 =?utf-8?B?SG54R1J4eitpa2hubHZYTE4wMHlodkZHZ0w1cENSMms5UXJiN1EwTS9weXpY?=
 =?utf-8?B?S0JJc2NtYmNPTDFPVzdkYVJpMkRSM1pJNWpqQzZFV21IK3d1SkIzSWtsR3FG?=
 =?utf-8?B?anpyNGJSVWhjYmFwajRZaTZZcktMOXpyWkRwRHBXdXVxaW1kSWVoRjQ5eGQy?=
 =?utf-8?B?OG13Z1kyTWthbSttTVk3SHNMTTBoTWZ5V2hvVU9vZUJhM3hBUGJjVDlVUDl6?=
 =?utf-8?B?WStnNUZtSG56eGw4VllndTBMTHFoNHhLNXhJVW5MdGY2OEtuWnFDM1hxaFVS?=
 =?utf-8?B?MUE4Q1BIRkh1UURtKy82eGpjd0VIN1JYaGtZTzI5ZlBQMTMvNDAvWDlZbjlx?=
 =?utf-8?B?bkRldFg3Rm9yL2tCcG83OU1sL0Q4ZzU0dzFVM0VzdlN1VGVIa2NCRkt5UFRk?=
 =?utf-8?B?V1UzWnh0cUhSMWxHbmxiL0NiWm5kZS9QQ0p3TU4vcEJ4ZzBxYkVsbFQ4bEI0?=
 =?utf-8?B?VGRMa3BINGthNVMxTTRrZXR1a3YxZkZxdTRjYitlRkR3MTlXd2FteWtZTHNt?=
 =?utf-8?B?dWlHSjZMcURyVUZtcUFob1JPb0ZwQU1wS1BKWEhiNE94UnB3MjBsQUpubEtJ?=
 =?utf-8?B?aTZSbEkrVW43SWFhUmN0TUZESWh1bDY0WWhBdGp4S3JLOThrVVpITzhjSU0y?=
 =?utf-8?B?cjlkZXN0VnQ5eUlwdVRvbkhjampzR044Z2VrZzR0YU9FeFYrT0x6d3R4OTRl?=
 =?utf-8?B?ZVJNN0EvNU56UmRyeUJKTG9LVlZTR1RyaTh1QWpuaER6cHN1Nk1VTTdKMFQx?=
 =?utf-8?B?bjFkV3BLZzd3T1dSbGI3Zld6N2pqa1pBcEsrQjd0N05LUE9ZQUsrbHVmRzJ3?=
 =?utf-8?B?RjIrVVUvSUpMOHhkU1dDbE5EcUJXcFkzL2srSjZ1U241RTFCUUdxY1EzWEU3?=
 =?utf-8?B?QTZ0YmJjejB5RmRjTEl2WEdxeVNDbWxWbHh6YmdjM016MEZuWm1OWDZrdW45?=
 =?utf-8?B?REdtRkYxTUpCclpWS2lLK28reUZQK1VVSmxiTWp0Vzd3bnhVYm00cE9haGJx?=
 =?utf-8?B?elJ6clc4cTF2K2ErVnQzaDJMTTY4S2I3d1pBaXdQazlzN2dQYThLMnB0NU5V?=
 =?utf-8?B?elBySDhHazQ5NHN0ZTYxQ0xPdkZRaTF5QzNscitXbnZoSVllRCtCRFd4V285?=
 =?utf-8?B?TnBSelQ0L2lQZjRPTys2S1oyRDA1TlFudDhNVFUxUWJjeDIzSGEyaFkxR05n?=
 =?utf-8?B?QmFkTWErNi9YTUd2aGUzd3V0ZzZjMmRmcEJEanNlZkhkQnUyZVJzZCtuaVl4?=
 =?utf-8?B?UmU3NXE2bHNiR3hjaTdlemJMT2IyTVhBR3BacVl5Y0hCVFY2c3k3Ly82Qm92?=
 =?utf-8?B?THFwMnRkZk1QbHh4cFFSN2x1YWozT0F5SktmRW5CV3lTSG5GUStwLytWc25x?=
 =?utf-8?B?eEF3WWhQV090a2NhY2cwTW5oWmdwNWdZbk9pSlIyMWcwQXZ4bWRnRzFrWW1z?=
 =?utf-8?B?aG4xcGREaTFGdUVCdDR5aDZXd1AwRWRMZ3JMcCsrWjdvR0pzamNMY0lTSVM5?=
 =?utf-8?B?TjRtYVQ5dEZOTHlLVWNwR3VkQUc0QVR5VG9Ma1dUSXpkOG9oYm8rQU0zejJz?=
 =?utf-8?B?dWdEU3pGM0s1YWdUUDl5UEJpbytuenFIVklDeUl2VGRvRTY3QlFZL1g2YTF3?=
 =?utf-8?B?bDB6MjVqL251Z21ETVJUMGhiU2I5enRBcThDUEpGWnBROS9TczFyY3JjcTR0?=
 =?utf-8?B?S29OZEFrWXUxczlrMW5lUzlIeFI2cFpRQTJJMXV0TisvRDFPMzBsTGNpbGhq?=
 =?utf-8?B?Q1I0YjNGTXMwMkNqNHlwYU9yMnptZkxOc3BRVU4rdTQ4cnBmUWRUNlBxUlZ6?=
 =?utf-8?Q?0Qe+ocwf5cUDzp0U=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mzR+YAzVJLkFWMaJLDEQ12k8u9wreDxDjPox2b6aUmO5DLusyxle8mMdYuk1kABRipvnuRMU0OxNPMQYf6vR6/swDVgcSczLz3mx2lA2Ex6tf4mcUsZsZ8hI0s4B7F7dnjU3nB9GdXBW91TRhF9dOAZfkXu9IZGHGI7O7tXYbylzyfJ9393V2XLmxPa+rjzoZFgFW/zoxi7iGL0x8GOuXH/FyOSJVGovirPMAr2N5cSLSuD0T/A2erryYTNs2OEOqnll1RuHrTlU5yNzZmYEx8vibpl8y8fKiPYkMJScCIFVqvXg/9pyQK8iidxCtEfqkoafzls0kMHEa0DVOYJxSjVNsjgEuqIXwiMCo+KQPccrTa51pPUA3XuRwtqPuM+9zQzTefesm+AE20JfPwR41Ab18oZNothrEU/gZgm1kPCVPqlnvMIdTfRrSgYP2ZXZ6SfsVf3tli16gBa6O8YSJ30pQKXWC1Zlk68l5yzazs+SBW4tWVox5bUyXFjpOmSjcfZaBZuLAsj+lu2ujwKdrorZJ4G4PTiu1t+WkdwQAWuXb7kulrYNt6cM87oXTj+2ymiZNCxWAMHT3TG0G4xPYxxenDmMEGCvxBu42E3+0Ow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01e2859-02e7-477a-51fd-08de7924b708
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 12:59:33.2193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdFV7eNAhAmYoP0Stgj3MCpOJqjgDOlJvsZP9rG8w3dURbXaXimDw6O98uOG1T8LzQggw+D3Wen6wQhcuaIEhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8028
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEwMSBTYWx0ZWRfX24A21idstz6E
 jYUfTl0Ui9LPVHn9lKFIbvX4EhVUG/nu8X4TIQLQTfoIbay8fIBn6Ac6lWINb2gdZK2HgjmRZcs
 P+z7sQYFkGcE8ZT87yhIWiSgkchp6nXrc/wV5Rh55tiHGEfpyt9NGrB3YnSVPNZEDPeSuWQlZQg
 Zb7X3NWEEGhcvpt1GxYroKvrcVq7WbyqRSe0VlVmVhmGPEheYKYmk9v2ZmVTBS9ZBW9TBbGsmZV
 3j6enfJt+MCR/F703Jln9l7VIxj2uDOox9SU+jIjzVfPrQD04MZKgonyjO/HNRFDMjs2E7NqEr4
 EeSD0pmbwAfjHiC2/CH/sq/2R1Gi2sRqO1OxjDahpHo5RvpgePjbniP6HSfxi5Itm0J1DkYUYvW
 0UZ8N+SQTnXtci7S6eDJKCSYVKhsE9acwFgKMd/y4sXO1uAiN0d2DZO+CaljzIx+a2+9hU85iBZ
 /6aUBSvyv0TCHfp8w2Q==
X-Proofpoint-GUID: lp2TYE6BmUVcZLquhxUyU1wR8h0vhlgB
X-Proofpoint-ORIG-GUID: lp2TYE6BmUVcZLquhxUyU1wR8h0vhlgB
X-Authority-Analysis: v=2.4 cv=EqnfbCcA c=1 sm=1 tr=0 ts=69a6db43 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=OmqFwUqCg2sYYxTjeRQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 03/03/2026 12:39, Nilay Shroff wrote:
>>
>>> Yes we got a reference to mpath_head while
>>> allocating it but then these are two (alloc mpath_disk and
>>> alloc mpath_head) disjoint operations. In that case, can't
>>> we have both mpath_disk and mpath_head allocated under one
>>> libmultipath API?
>>
>> I would like to have something simpler (like mainline NVMe code), but 
>> I have it this way because of SCSI, as above.
>>
> I understand the intended lifetime model due to SCSI, but the current 
> flow is somewhat confusing.
> 
> In nvme_mpath_alloc_disk(), mpath_disk and mpath_head are allocated
> separately. However, during teardown, both objects are ultimately
> released through mpath_free_disk(), which drops the reference to
> mpath_head via mpath_put_head().
> 
> Since the allocation of mpath_disk and mpath_head happens independently,
> it is not immediately obvious why their lifetime is tied together and
> why they are not freed independently when the NVMe head node is removed.
> This coupling makes the ownership and reference flow harder to reason
> about.

Yes, and also having 2x separate structures bloats the code, as we are 
continuously looking up one from another and so on. Only having a 
mpath_head for a nvme_ns_head would be nice - I'll look at this approach 
(again).

> 
> Additionally, I noticed that nvme_remove_head() has been removed in the
> NVMe code that integrates with libmultipath. IMO, It might be clearer to
> retain this function and make the teardown sequence explicit (after
> removing mpath_put_head() from mpath_free_disk()).
> For example:
> 
> nvme_remove_head():
>      mpath_unregister_disk();  /* removes mpath_disk and drops its ref */
>      mpath_put_head();         /* drops mpath_head reference */
>      nvme_put_ns_head();       /* drops NVMe namespace head reference */
> 
> Does the above example makes sense?

Yeah, something like that would be simpler. I just need to make it work 
for scsi :)

My current implementation has it that the scsi_device manages the 
mpath_head and the scsi_disk manages the mpath_disk.

Supporting a single structure for scsi is more complicated, as the 
lifetime of the scsi_disk is not tied to that of the scsi_device, i.e. 
we can do something like this:

echo "8:0:0:0" > /sys/bus/scsi/drivers/sd/unbind

Which removes the scsi_disk, but the scsi_device remains. So, for 
multipath support, doing this would mean the that mpath_disk would be 
removed (if the last path), but not the mpath_head.

Furthermore, the scsi_disk info is private to sd.c, so this would mean 
that the mpath_disk could/should also be private. My point is that scsi 
makes things more complicated.

Thanks for checking!
