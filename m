Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ABC221F0F;
	Mon, 24 Feb 2025 12:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399713; cv=fail; b=q+c8Dg7s81BF4exqMe0TCF0GJUADZni3clrF6kNy5rhO9UakwctUEdsoBDFWDawHIa6Lhts9L4tYYWSibOdHavwD+Q+aTnWXqMm7CIyrGxYkizCj+DZ3VqjgT+vMwxuSOh+7zEeQFUGZN+vSxKUN7JZK71CMNbY6wv61OlchA6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399713; c=relaxed/simple;
	bh=6tGYkxv6VxMMQqf1vEpISAkNB6g8gwcMNJde9eH07NI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SVNKo0lklsh4qySmRwdINEZ9bYM4eVzL41GlQOscZVGn03PnFdJCFD6b76tQFfj7b+nrHuKKh6f6TVf0/zi3wHlk1twyyfLGqL0MVAXqb6ADJMEPkgP0KiseLnPC0aFvIWMqQ9a5ScJ3YDZW0mVJLzMHwUbttc4vVLImEdeq6Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q7UvcBZW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CT410rQN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q7UvcBZW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CT410rQN"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OBMbeE019932;
	Mon, 24 Feb 2025 12:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PVpdoJi0YB4yGDAnLcfyj9QV+SS7UptL33xLd/wM/4Y=; b=
	Q7UvcBZWftDYWKLP3fuuYenpBaf206RZqYUmEbyx+pni2mxkEGeFoOnS2HZQSdDa
	bMdEKQHtZEHWXnE9M3NHol6+TK4gomI4WdyAlFmMp3pT46C2mLjSRbbWrhQduccH
	Sq8hS96NOAztCZT6KwuTdUcQ7imecRLCq57dh/sUhnPIxVr5kVo7PwDNW5ZOcSsy
	GuXs2BiB/ta8Q2TiqzAnMbE7yCKWnGMasef/3rOGy09nrg5lmLfU94RFX9lLjJoY
	rQvb+Q23sMc2mSxw5Mi4j70ToLlBuRTByVzFe1gl2m2qaHx8VSHjdhzvAm78iRHj
	NaVK2eC1otTzCO9Ln+Gh2A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5c2afms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 12:21:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OAvwca012629;
	Mon, 24 Feb 2025 12:21:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y518u5be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 12:21:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vp1hQgwJzirtQVHV7tUsLmMwRHs3VFzi2Uhepz68R2ZMHI9uyZDVxajV6fdK++iJ/6HLYHy3rQg1SWqq/d5giZOwp3A+44PMSOVs3Ie2vc8t+EQ3f82wR3f6faF0efwF5b0QYn0aWrjHXyBnrTZYyJcrF4kgvZuSa/4TrfqOCmg/U9tcSzWQh9EJNjzRDjkraLH+bAOMwlMnzSsAattYhZDIW5k0RfN/HQRagASWP20OHnagEkqK0i33EJNJXoNlwkt/z86fAQeYiXJoM5S2E8kxHwe9iKSVZXfBSefpGMa/6NX5FDe2+J5Z3eHypa0eqdaurrZjseE1UUytvRL1uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVpdoJi0YB4yGDAnLcfyj9QV+SS7UptL33xLd/wM/4Y=;
 b=EoHkTJiiQCPGV/rBlC5npAUgUogOQGcVFXWoT4aCP46S86Yqv1T6o8SkZxIr2+PaXkQ3XcltvuZBpJqjleC2W9vkKhcO54XmW0HKmFBujcin5Zudi3ffEgllrti4rKEFJnHKFqfGoz9H+gQzyW/Z4BXCKvNDtnhS1muz+zfpN6ZKB0duM1n6yRT5afISXdDETXWhtgHBo26YE1ITo9Cu9w1oBJ9F8PUQgxdjYSADXWbauOCgljJzMKAosUsZ9sgGWKPjR69z3GqUCmrf0B5TQr7fP5R+3NY4/HIYXjLb9PG4lVFRa2JOc58Emz1cepZJDwtw2Shd0PpKRdN2fCDukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVpdoJi0YB4yGDAnLcfyj9QV+SS7UptL33xLd/wM/4Y=;
 b=CT410rQNu/f8iktI6CLlKz17e7DxWOkuC9zekDd9SxaAQps5FZEVoq/vJqPFikzm5Jbo3JRMme7fVIxMkyP2TnwocDwvsKsppe2XiKePCQeBFu15BP99nZDloPUYC+UxAZ97lpLKw0fgsKQH7oqFeTcR9y5uYrqPVVAYusSifeA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7106.namprd10.prod.outlook.com (2603:10b6:510:268::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Mon, 24 Feb
 2025 12:21:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 12:21:13 +0000
Message-ID: <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
Date: Mon, 24 Feb 2025 12:21:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
To: yangxingui <yangxingui@huawei.com>, liyihang9@huawei.com,
        yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        liyangyang20@huawei.com, f.fangjian@huawei.com,
        xiabing14@h-partners.com
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:195::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7106:EE_
X-MS-Office365-Filtering-Correlation-Id: 03852b1e-0217-4c43-49be-08dd54cdba70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2VoY0M5U3IzaHVjQ3JvNFp6SGhpeUFvbTVveHNJYk45WitrS3lobGZwTGUv?=
 =?utf-8?B?ckJLVUpNSmZHSHVqaG43YWphUHFFOWwxaXA0U0ZOYS9XMEpXcmtKSkU4NjJu?=
 =?utf-8?B?OEtkWlhrbGtMUVUwVVhnbDZ4VXVSMHZnbG5yUkhXeFkzM21lY0l6dmZNSVpM?=
 =?utf-8?B?b2hsZU9HeFZCMFNrQ1MrU2hYeXZNYm9iT0pRQzZpdjEvSXp2ZTFhTnRIVFN0?=
 =?utf-8?B?akpJTXlyOVFFV2NWVHRmcm5sdEtvQ3FZYWx4Zko2dW1zd1Y0aVdrdDgwVHJr?=
 =?utf-8?B?by9wWlR5bU13dnJpUnZpRElreXdGNll1YW00NDJieURrTUQ5NlcvSHdGelRE?=
 =?utf-8?B?aGdhMTU1WGhqMno0SENPTWdPeGk4UW04M1pSM3A2TTdOUWNlYUhiT0hFbTBy?=
 =?utf-8?B?c2p0SHVaUEhiQy9XT2IrWVZUMG43ZU5nRWhGelBzdWVCc2dUUEVSVldBYTlp?=
 =?utf-8?B?NzJHejFHQXpLcjltNmxOZXgzc2JJZmp4REdmWGt3SHlOODRBRE5ML21SbUFk?=
 =?utf-8?B?QjJ0ZUlMTnRaNUNSVzJER2RaNjJ4WjFQbXZRTW9sYWZwQ010STQxdmw4amJ0?=
 =?utf-8?B?WTlHOFdSbWdQYTRJSDdBRi85aWVRNlNCcU9mM29ZSEtJSTU0amVwdnlib3ox?=
 =?utf-8?B?dEJScWhyNjdkeFRvQXdSZ2hsU3k0bE1HaWx1S3MzcDB4K0tLNzlLQm9ETnZF?=
 =?utf-8?B?NUZNeS9mdERQT0ZtY3dCbHkzR3ZQcHRFb1c2Vi9VTmJvYmNpRmRVS2xReGMw?=
 =?utf-8?B?ZDZWNWtWaEVDUDR3TTZlYlpwdWtmeHlKZi9Fd0lrV0VNdVg5MXRHTGFiZ1E1?=
 =?utf-8?B?M2tFSXZ4N0djSWF6amhhbnFieUZTWk9oemxQemNqYXd0ZXBoTVhnRi9ibWU4?=
 =?utf-8?B?bU1ZTExNMzFDM1lnb0NtMW5zQ1hUcm9CakJrZEVTOXRtWlU3aFU5WHdFNHpY?=
 =?utf-8?B?aFJGbUIvQ3FDM2ZSYzY4eVNDVmorbzc5c0pyQ1Jod3NBZ1lTZ1FiaVdIM0tY?=
 =?utf-8?B?NG8vTGxkMTVSdE93WU80M2pPUWtNNkd2WUN0QUNzV2pjbnJacGE0N3NDV1hh?=
 =?utf-8?B?aVJFdDY2WkhCbG1nK04yOHVBczlsalVkcjVMV2ZyZlIveUxIYWgzQjZuSktP?=
 =?utf-8?B?c2MvbHdQVkx5VjZ0d1VxMThyY0pyb2RMcGNBeE9WS0wyeUpKc2M2a2pNdWNU?=
 =?utf-8?B?V3ZkMUZvaFNicWRqMEE4N2ZYdWxhcU1Ja09oWUVhY2s1WG1nclVUNTNlR1da?=
 =?utf-8?B?bFYwZ1RpZ3pjUXoxeTVkb242ak9lRHVSdE52aGFWaWttc3dXL3dBdmRMZFo2?=
 =?utf-8?B?ajU4UkpoaVVNSGh6ajRqeHR4WE5qbENxaEZtaGo2cC9hVitUam1hUmVOL25i?=
 =?utf-8?B?cElacnBnUUpaZU15NkxyYnQrTHNZNEl0N0ZaTFViLzBVcVJOTHg1TllwWi9z?=
 =?utf-8?B?QlNDVUZyanBhbkhTdVVaRkxJT0NPeGhiTEt6dnNoclN6UmR2bGIzR2hCSTdR?=
 =?utf-8?B?TTV3WkRUQTJPMjlKM3ZiZGVSOVVSV3lPVi91c21qbkRLTHdQSllDTlVYNmFB?=
 =?utf-8?B?aFp5ZTZHWWJsQ2lLMGp2V3lvYVBkNmJoNHFHcnpLY2svbFBVYlFrOTJsRVR4?=
 =?utf-8?B?aWhCZ0F2MzA5YjJMeXRPbnlZdFI3QjZFc1VONHNiUWV3ck0vVktVdjY0Yjgv?=
 =?utf-8?B?cE5SWGt5K0haR0NaU1c0SGk5TUcvYVhzaTAwQ2R2NXpjT2JOdFZ5dzJXb09R?=
 =?utf-8?B?SVYzak10L2NsNFpmbjgrMkQ3WFkydnVvd2c5dzFTa0tRS0o1MGZtOGhOU1do?=
 =?utf-8?B?VGFlMjRsaDZuMG9Ua25RYmtXMGY2a2hTMksxVXdwa1YxOE90a1dHbFptTk5n?=
 =?utf-8?Q?jj/bDTHfE0/Q9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFlOc082cEhHdkFBYm9TeVc1dGF0Rm92cUpBQ3lFbHVwMkFnc3NTbTB3OENi?=
 =?utf-8?B?aXBuQjRaZzBUTlI3aEdXUVU1Zkppelhyc01aMkRpeVJmZXgreVJNZEFCQVZZ?=
 =?utf-8?B?OFVtVkIwcnBIYllZanFmR3k3RHlFcFVGbVNlUjdUTTZUOThXc0RTYVdXYlB1?=
 =?utf-8?B?YlVGeHlJY1pWZ0JydFpJU2FvaWlpOHRNb3NoY2dwZGdTUXIxY1dJZzk5emQ1?=
 =?utf-8?B?emRjMlIyd1AxdS92b0J2THEzdlNkWk5QaW5MbFQranp6eGhqN3N1TFU1Qk9W?=
 =?utf-8?B?YzdqL1pHWVBxQlJJdUtVZjZtd3ZhZVhnTGZYM0d6anAzZVZoNFZSYUZGdFUv?=
 =?utf-8?B?QTdKdGY4KzVGUFo2dksyOVBjR2xoZmR5M0RMaHpERDRUMHREMnlGM1R4d1Zy?=
 =?utf-8?B?cjJpbmloSDBRRW50dFZNMGRqalpKMWFpZkNRcnlGMmgwNXFjWW5GMkE3b1ZG?=
 =?utf-8?B?UFY4b3hDdW85RmhsRHVHTUtoazdVeC90eEN4YjNQRFdHVEFSMFJMYmxzT1NU?=
 =?utf-8?B?YnlNbnJYbFB4M1haM1dROTBtYWg5WTZEWmtLMUNteGR3ZUFxUFJwSjkrcXAv?=
 =?utf-8?B?MXVUZWJYcU1VZWhBeVFWalRWb1JOWVRPbFRVdG10aUNaRXpZRHA5TExKRzF1?=
 =?utf-8?B?bjY0R3RpMG81MGdMdXNZc3c3VHZ0eVJiVlRyN3ZaR1cwekhyUWZ2Z0VaMGF1?=
 =?utf-8?B?K1dNdTNZcGptRzRuMkZTdGIwSGN0bG5HWURKdmt6NUVrdjluWEUxU1VaUDZm?=
 =?utf-8?B?NkhZMmZvQlBVMWlvcWI3QmxNY1VxbjNzZmNTcllRbkxqSnFBUnpmWmVJRkRF?=
 =?utf-8?B?ZVFYS3hzWUdXUG5XeTZsZTJvZHJGd2IyeldqY2hVTGVBSkQwMm5iM0NZTFBp?=
 =?utf-8?B?dXlsSWlvWEJxeDdRUkRPL2hjQk81cUpLUHhDR2ErcnA5VlBLT1pkOXlBWm1T?=
 =?utf-8?B?OUhaWDNvNXFWQ2VuZ1N3RkUyZktCMjRublU3eG1KaGw5TkxpbWIxTlVDaEwv?=
 =?utf-8?B?TEZ0R2k5VXlUKzF3cEU5WUc3T0UrK0xFNGxLam90dHdHRGl5TVg3dDBQTmdp?=
 =?utf-8?B?RmZaalJWdStvVGNDWVo1SmU5anFsMVpuRWwrMm00am5lTVdtemxSWTdYaENB?=
 =?utf-8?B?UUFuMU1qMVZTT1RZMVN1a1J4K1hJTm9RbVlKS0lKWWVSMExQZ1FpVkRvQjZa?=
 =?utf-8?B?a25BYlRjVkc1cExHZkN2cUhqSEFmaitRWHp1UE1tV3VyWHFRSExSaWc5dlM2?=
 =?utf-8?B?VGs3eUZteUx2cFNmTGIxZjA4WkFkQWpBSVZUTmYrUFQ4bmE2cnZVbmI4Wk10?=
 =?utf-8?B?Q0RnWVNWbEFmWlpuSWoycXdKdlpvcHVTSzF5NlQ1MU5OUUl6dGJRQnZYcHV0?=
 =?utf-8?B?Z09wQy9DMGZkb1pOcmdkRlRES3FlOGxINW9PbDR5cUFySXpjN0svNEpBc2Nk?=
 =?utf-8?B?ME5pbnVzZ3g2ZW94ZnZlZ2RFNnExZGFyaGhxS0lMaGx2Q0tOMVF0cnlXencz?=
 =?utf-8?B?RDFBNXNJTXlqbDVnQ2JQR3dEeElaV3RDcnMrSjFOL0FZZmZtcWFhSnNXM2Y2?=
 =?utf-8?B?YlJTYjlvQS82M0RNUGtYNHU5Z3A5Ny9zdnJuZUx5V09FbTFGZmx3YUhiSlJC?=
 =?utf-8?B?d0FMY3RzYjBCN2hSSGxNc1dsSEpNRWNTbE1leGZ0VVVQS0Nxb2lUM3JObXlj?=
 =?utf-8?B?YlUvYWVUcjMwWUxmdm5xV2FxV3pQSTMzSmNxb0pFcVVRY3lYZWl3bHZYbFRs?=
 =?utf-8?B?eFZzL3grT0l0cUF2VlJ5eTdvYmhncFF2aDhTQjB1SWp5ODgwOVdmWVo2dm9K?=
 =?utf-8?B?YXU0Y08vempRL29WTGRmQWtGdGI4U1lhbWplVGcyVkFkakxRSHRHejlxS0k4?=
 =?utf-8?B?M3pGTlJ2N3RlTFpJRGdQd04xcTdNSkg5NHIwdXZML2RydkkyZGFhMWthdTMz?=
 =?utf-8?B?K0l6QkU5R3JZMlhLQnJ5WmJtRzE0cXRGeXFBRjVFQ3FTMElZZVZZOVdJdXNn?=
 =?utf-8?B?VExoV2JTU0lmU2VLQjUvWDJLTUdmVmkyWk9HMkl3V2FnbUdXWFdtL3Q5NWVS?=
 =?utf-8?B?RlpHREV1aEdVQkRZcGoxVkYzUU5nTDZsR0RZRGNMbjRQMmJJSnJzM1lqZjZ5?=
 =?utf-8?B?UDRxeDJpWnVKcjF5RkFlY3dGNzcrT2tUZy9wVldtcWZpbUNGQ29oWGdiR29Y?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DLEUE/e0vz0DP5hIA9t/MM55kihDPaOi0Iyuo29D2QjwTh3A5dHYpLnoPhEr4rhzkJbVvoiTAQc5gSy9FoAMcSHEC+dlMud6B1dzyIJGrD9aW3JvPAtaHdTbZskDcdWuHmZlXAJPDNChRgnfq1odA5uhaBjXC+A55J5BJqeF4YasMh1XO4pwGxBQ8GuqxnrQzdsJOEavXHPb8mYyyORuFkFf9PBWWuMNofribCQd8aTvEmhgeEmGXWwJU+t2nEP2QNLb04cm5k3BxefXpCiSjDXQqLbGpsrGey9Mu8Ph/3SqtW6ifvISfbxU+gAv3LdLJXWufnJad3MLVBwlJVvz58U/Jgd2WIsGa3e7plUf8eyUNFpeAsF51Cb9KcqinZ3LIXIUkdsGucsDGPUxbp1V5mpjtbSRxc5Pe4b/0fOtLhjXU8gzRUDyK0/qG+8k/g61tQOPJm06zUotS29m01p0X5q+UNQCPsiYBHLZQI8wo1k4+XxM90R+jlCD7MkAxd0LVagfYYxS7NewCpoxVofBInx1zCLAAak7ae1y7uhKWknGC/FVT4qDzL8oZp3AbN4rLDk8ROStiogW5eJFqeczIeNOjeVRktYQJ3jOUmvbxLc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03852b1e-0217-4c43-49be-08dd54cdba70
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 12:21:13.2337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lU9M3aILNyDv1i4bl2xqrvMulyddXaCz+hXpAz0DYG5dZcW3NWbPZVbQiaRU7EmubR3cAHKcOIjtfsMHF9Z73A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502240090
X-Proofpoint-ORIG-GUID: vH0MGqJbg194VzvumsXFNXCe3XElQ2QT
X-Proofpoint-GUID: vH0MGqJbg194VzvumsXFNXCe3XElQ2QT

On 24/02/2025 09:36, yangxingui wrote:
>>
>>
>> So do you mean that all IO to this disk will error? If yes, then this 
>> is good.
> Yes, IO error or IO result does not meet expectations. As shown in the 
> log below, due to an abnormal port ID, the SNs of the two disks read are 
> the same.

Do you mean that this is mainline kernel behaviour, below:

> 
> [448000.504979] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 link_rate=10(sata)
> [448000.505070] sas: phy-10:1 added to port-10:1, phy_mask:0x2 
> (5000000000000a01)
> [448000.505247] sas: DOING DISCOVERY on port 1, pid:2239187
> [448000.505255] hisi_sas_v3_hw 0000:d4:02.0: dev[2:5] found
> [448000.505274] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [448000.505295] sas: ata31: end_device-10:0: dev error handler
> [448000.505299] sas: ata32: end_device-10:1: dev error handler
> [448001.300517] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy1 phy_state=0x1 
>   // phy1's hw port id released
> [448001.300522] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy1 down
> [448001.436187] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 
> link_rate=10(sata) // phy2 occupies the hardware port ID of phy1
> [448001.608766] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 
> link_rate=10(sata) // phy1 was assigned a new hardware port ID
> [448001.775605] ata32.00: ATA-11: WUH721816ALE6L4, PCGAW660, max UDMA/133
> [448002.159364] sas: phy-10:2 added to port-10:2, phy_mask:0x4 
> (5000000000000a02)
> [448002.159575] sas: DOING DISCOVERY on port 2, pid:2239187
> [448002.159581] hisi_sas_v3_hw 0000:d4:02.0: dev[3:5] found
> [448002.159602] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [448002.159623] sas: ata31: end_device-10:0: dev error handler
> [448002.159633] sas: ata32: end_device-10:1: dev error handler
> [448002.159636] sas: ata33: end_device-10:2: dev error handler
> [448002.393349] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy2 phy_state=0x3
> [448002.393354] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy2 down
> [448002.684937] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 link_rate=10(sata)
> [448002.851639] ata33.00: ATA-11: WUH721816ALE6L4, PCGAW660, max UDMA/133
> [448002.851644] ata33.00: 31251759104 sectors, multi 0: LBA48 NCQ (depth 
> 32)
> 
>>
>> But I still don't like the handling in this patch. If we get a phy up, 
>> then the directly-attached disk ideally should be gone already, so 
>> should not have to do this handling.
> There is no problem when the disk is removed. The current problem is 
> that multiple phy up at the same time. When one of the phys up and 
> enters error handler to execute hardreset, the phy will down and then 
> up. other phy up will probably occupy the hw port id of the previous phy 
> which do hardreset in EH.

Could you do this work (itct update) in lldd_ata_check_ready CB?

