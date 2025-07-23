Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B61E2E8E05;
	Wed, 23 Jul 2025 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753283433; cv=fail; b=mcP0N4OGjTC1f/SngIxri+pKwWALG2KQqbygZnM6t8fm6tmrt3PhcRWFRXOR3t7Lg1jAZyJLxCx59Wl3HI6u94hzrqELGLizHsCjN2Ee7wFjC3jZP6BRzaGfKwd+LLBW8Ddi13IhdKNhY2Y0UcOtBnZ4uaqq/9yhDzJr5/Xm/94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753283433; c=relaxed/simple;
	bh=hpy43AEZDJuNeWjdKWKeT2yw30yMvjocssQU1wxPBhU=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WRsxxvf8+265xnHOoV9nXCjKzwycPC7Ilc/CvRVuAobeJYxb0UFNMuu2e6G5sWqj7aBvY7yLaPNnChEzcFrl5LPOJex7iew07jHx5DJg+AdlZLBjAfPl+81S4b1382U7TwU000W5ytSvbbDXXpXomHsPPSyjSgU60FTtC/4oToI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D+3WM6AY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VC/oe1lZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D+3WM6AY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VC/oe1lZ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NR1u013934;
	Wed, 23 Jul 2025 15:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/YSOiE32dCX/ENGo5Rm63J2KvsFvM/s8cJxYY9+yw+U=; b=
	D+3WM6AYxa/zzZkAZOanWyl2+st5tI4sJS53+1Uo3Krxt7gLcCCW2UPQ39a+89gi
	MVnfoJIbl8LLlIAhCLfR4FbaRMvWqgL+XtQaA0lNax/AvgU/GqTn/WIULw5R74aX
	xY5Wq7eVMX4CmU3+U6WdaIxKh+7xyCyhidHz0GpOOYuxbN11alML8pZJxrLTgVgk
	kN+fhLll1k3cVPECvs21rCxBeOtLDoKsd04zvKAfxD4RNhMQTX+CEUccrSO/JoGq
	xtDagPtqjFrRZ1PZQQtD175Q0UjsIZL/kvnGwairXwjKoWUjPcmrAC1pHWQ+xknN
	RNqXGGAD6kB4x367F0gjrA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805gpquxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 15:10:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NEDom0011318;
	Wed, 23 Jul 2025 15:10:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801taps3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 15:10:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BgXz9pGmQxlvTdeEX8BCII19FwG1o/7rGmICJGrmhPQu9Oe0GI9ILxx6K0vQqUrt6bceCIGBXptAQRc1OisMmWXoBl1eWFWgnuUx144XM2lSMS6dqS3z5rgHl8KvYARFDT3BbeWQkI1vLTlCuCloFj3LB3VV4J9xw4ENCLxsvKSZnPfp1ep8tG5GoaweT0H/UkJEskjQbcegtr6ypNcOZcAfN5aMgM9cHiadZHTasTGO3A37brjHbH2cSTE6BMy8zXwin8YlpKaNB8m+Ep0xAtfxa9pqqpiJTFwWgOR6kYqiQ/2EwJoCsnKcX1sSEmoiSCsV6BAxZL96zK7iySTfzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YSOiE32dCX/ENGo5Rm63J2KvsFvM/s8cJxYY9+yw+U=;
 b=tLLdfa1ZjId2/S09RPavOswdrfvorGGeTlvqbzs8pjgeN5ikG1943CZ3fDouzIb2gCKyNMAd7oEQvqb/GtG0PEpDWwFiqxevVAz/m/Is3eXLiPcjR39tCL0O80rN56lN85cwTKz7zOnqnikiinH5LjVcPUF9RXV53anZsrcUJAzG9G4G2nSOi9HDgm27/TupZcr7MQ9ko53WItKSiGc4i6JwAjjCi+GkDr+Ebb5N0OCn98CklDyKao8N25PlQf9NhkvRCAOuq8MWgRd8mwkhyDEw0FaMswHDIL3EywKqkbvJFRVaYR973nG7L0tNzNz3193NyQFXvF1JTxyLfexmwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YSOiE32dCX/ENGo5Rm63J2KvsFvM/s8cJxYY9+yw+U=;
 b=VC/oe1lZFEdOk7K2WaA+en9BEEcNdHsh1Mis1o9pF48pbqU6dJv72/UwcHz16omMuYi6j6ki4bBxnSwxfmctqyut47YthGNGj8r2aWi6vRZl2AGi6kZTXAwfuEySFjV8blTH0gqZWLzHgFFv3Vn0QrxV0ITwLmMUExwdgD44uQg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB5673.namprd10.prod.outlook.com (2603:10b6:510:125::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.42; Wed, 23 Jul
 2025 15:10:26 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 15:10:26 +0000
Message-ID: <481bcab0-7bc0-40f1-9384-7d3c20ccc22c@oracle.com>
Date: Wed, 23 Jul 2025 10:10:22 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: target: Add atomic se_device fields
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-3-michael.christie@oracle.com>
 <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
 <2eae4fbf-66ef-4602-91e0-d92838dcabe6@oracle.com>
 <951f5d23-19a8-4f6a-abcd-204aec160e74@oracle.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <951f5d23-19a8-4f6a-abcd-204aec160e74@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:5:bc::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: db076d7a-5e6d-4c9f-0bbf-08ddc9fb0df2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVdqVXFtL3VreTNHWjM5NjUrdG9TR0VHZCs5OGpXWmViSEE5YnU3bWx6YTJh?=
 =?utf-8?B?ODcxV0h4ZXpvTmhKUWN5NFFNd1hlMG5IWVRXd1AvVXBOR3lIeVlPeTRIbkhU?=
 =?utf-8?B?dTZxSVI2d2lxaHRVSDZ6U0hUWUkzdnNTd01oaUtheEFHSmp0TEtrWDRQWndx?=
 =?utf-8?B?Wk5NTEI1alhRUWlHQnBOSzBCM0NJSjAzOTRCVlpnMzNSYTMwK2lXclRQY01u?=
 =?utf-8?B?V2hjQWcvU2k5RjN5azNrdDFFOVhsVVFKSHJTbjRubU5iZTNuYzhqdHdTT2Ex?=
 =?utf-8?B?U1F0T0hkbndGU0FHaU9WZGdaSGRVMUJjUlEvQnl1NWNPakU3NUUyelBtMzBX?=
 =?utf-8?B?ZktoR3NRMVlYQkxsMVg4bFFTTlBQeUdHRkk0UVNXbTZsblhxWkY2NCtzR1pz?=
 =?utf-8?B?WDQ0ZThCZzVHMTdLMmhYbldmbks4bzZXdkdKSjJ3ckFSZXRMeHppdDFLZXFS?=
 =?utf-8?B?Y0ZNaDNXWXhjOGQza2tYVm45VUhwTTN5eTRPbGsyUFp6Ym9WTmJ6S3Z6eDZl?=
 =?utf-8?B?K3E5alpnbE94VlhlZEpRbnhmKytuVVVaeFVXaGsxQUlkN0Rzd0luVXdzL2pT?=
 =?utf-8?B?RzVPS0h3MGFxYXlKNHdXS1FCUWcrRlowb1o4L0RVZC9DRGpKd1BuWUk4ZnA4?=
 =?utf-8?B?RW5RNDZTajFTVGdxNTljMjkrbnR1ajY4aTBXMHNIRW52am9nd0pOejZ5N25X?=
 =?utf-8?B?eEQzaGRvSWl5aVUxYmptL2ZpbEhMNmh4dDR3eU1LOXlmenVMbUZtRFdDcHQ0?=
 =?utf-8?B?TVN4MmUzYW5BRTd5YnNVM0RCMVRCajBQN0VHOXk0WC92eUpWVEVBc3hZTUZG?=
 =?utf-8?B?ekJmTWI2TG9JVVVTdjlXbDRtQ3BBbnNxOVR3ZlNwbmNjdm14bjNZejlmbzBG?=
 =?utf-8?B?L1pRK2VEampZSVVkU0J2cVBOOW02cDRmUWhSM2R4Z1IzVXRKODhiOHFxRmdU?=
 =?utf-8?B?WkQ0VXdvUmY4SXFMTS85d3JEVUowZkhmbUNkZlBlUE40U2ZZS05rRTdQQVV4?=
 =?utf-8?B?WnlhQmNEc2QxSm5KWkZiQ2kzN0RkVXhNeUY4a0Rva2dSWkc3QnNTaFJvaHc5?=
 =?utf-8?B?YjBMWFhlY1Fma0pIM0VxTjF1bDl0bUk0a2ZJV3IrdSsxa1J6WiszbzRzRGdy?=
 =?utf-8?B?VlZIRmViVDc4OW1qT2loY2FnanNyVk1CSDdTRUpqNythcUVwWmpzTGRoaWNL?=
 =?utf-8?B?SDFVNkwvcHkxY2xFczVKRGxDSU02WFNGSWdpVVgwSDMrb0oraHpUS0NPdjNx?=
 =?utf-8?B?am1OYWNGeE1mdUFGODhvQUtnbkRVTXlrMGNaOFdBVTlEWlQ4UDV0ZHh2VHdP?=
 =?utf-8?B?UFR0VVFaOHNwM25kcWFPVDRNd0RQOStlYmV4RlFrQ0I2MHNnMnM1cUh6MGRN?=
 =?utf-8?B?RHdJVVgzUThGeityZStXdVdrU1orQUdHTDM3SU8reEF4c3RqbHNyTHlEZDIx?=
 =?utf-8?B?TGZ2TFllWkN2UGhhN3F6QmdKdlpHNmtpYTNWWmxwUHpNTUlxV0pLaWNOM1Q3?=
 =?utf-8?B?YzRrY2h1K0haMEZ0SHR2cm9xV3NrQXhrRm5DVTNsTzV2czVQSURQd2tJZGFJ?=
 =?utf-8?B?L3dmSUw0Wk5VdnlRN0ZqNDRDaDQ1c1VPeVlRN0JVdy9nblVUczM2MUhIT1hk?=
 =?utf-8?B?SnNzeFkvQlpKU0hEY2VtTDBWYUxOQkNXWExuSnI2eUFRMjBWZ3hKbmRyYm81?=
 =?utf-8?B?bkJlWmZXM0RWRnBlUmxCSTRNMmt4Y3Ezb2dYcmlKczBQVFg5UXZsQjgxeW1O?=
 =?utf-8?B?MVFuOWxveTdnTjFlNnZqOXJHTjd2ZDl0cVd5aUw3Z0FoaVVieFF5N24rZEJB?=
 =?utf-8?B?eWtSdHpIVUpnS21LM2ZFb0JQTjg5ZDRRUkUxdjJOdVFac29nMTFkdHhNNGJv?=
 =?utf-8?B?bGxoeHNUOFBOVlBHMm5YRG9nbWpGRHFaNlVGeC92N0o2c1BnT2RoeW9XYksr?=
 =?utf-8?Q?4hLUrVok01s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3BJTFRoZ2FsSmwxSmFVQ3J0ckVKUlFWamIrc2JSYTlsbS91SFA1bndPNU8x?=
 =?utf-8?B?V2x2NC9KbndJbk85RlFJdk9Zb2VWR0ZsV2tRQUJsSUxBSWQxek8wVUl4dytv?=
 =?utf-8?B?QmxyYkNnZkVpeGJ3eUFzeHVUS2Q4MTdIZkZScVJLTFdYVlpqMXhkN1BjeHRB?=
 =?utf-8?B?Y1l5YUFGZ094K3J4cVpsK1FFaklLUXdLWHp3U1RUYmhleWlGWWdzeTN0akVP?=
 =?utf-8?B?Qy85L3M3YjM1QjdSb1owaDF2QlpJOHVmdXRta3BnRG5pU29pM1RGYkdVMis2?=
 =?utf-8?B?R1RrSGlYa1JrL295Uk5XSkt0cSs1amp4ZDZpdFY3VVhtYXZtMFc4Y29FVkpZ?=
 =?utf-8?B?bi85cmFNWWV3YW9ibTAyejZMY3hmdHpYRWNnMGZwMWJwZmpRR1c3bmszNXd0?=
 =?utf-8?B?aWRzdEIxYmVSSW9jelpuV3gvdDV6d1BlS0hjVm8xVWtTanJyRURpeEI0eFhP?=
 =?utf-8?B?dHhZRFRYRHpWbHordmwxNDNsMndlRW1SVGpKSlFCUDhvNnYvbTY5a2h1ano2?=
 =?utf-8?B?Y3FHQjBtbGZjOFVzdWpuRjFwRk55MW1PSkFVaGRyT2dCR1BGRmI2YldYeloy?=
 =?utf-8?B?a2hvMHJtLzM2TzNJVXBoZU1VUWh0RWF3OWVkZW11dytvM3VxVmVlTm5iK2c0?=
 =?utf-8?B?UnQyeTJ3VlhiaUVwOGdmRnM4SHYzeTZvcGF5OEUzQmFDU0FxQWMrQjJ6RDZp?=
 =?utf-8?B?T09vTE5HcE95YXIvYzBVSGRmaWc0NlNRLzhnblYxdnp4cXYrYWlTdVRIWjJn?=
 =?utf-8?B?TE1IRG5MY3Zod0k0V1pQTEpxRE1WUVdGVU5HYUdoN01vZ3hGWExvUFZyRjla?=
 =?utf-8?B?SjBCODRSZmVzNEZtVVdmbm5FbzdpUng3Nlc4RlhqSWc5dGxiaGlWZ2FRSkRq?=
 =?utf-8?B?KzVoa2wzWUZMY2pnTXZWWkwvNFFKY05GTVowaXBGbVN6bzlDQjlyTVJkT0Rl?=
 =?utf-8?B?VVVGRzBmKzFGZ2QwMm1PNGhGMFBYdFoyK2FrcjBZUS94a1Y3MFZTQXFRN0Zt?=
 =?utf-8?B?SVNLK3BqRm9VblFnZE5Rc3VpYmxIOHlwNW5jOU1lbmwra3d4RjhRWnNGTmIr?=
 =?utf-8?B?WG51K1NuZ2J3c2RSR1F2SzQza0wvUC9DT0ZSc1NoMjZqeEZoWVNaTDNyb0ts?=
 =?utf-8?B?ODJCUEJNeE4xUEV6dzZRRDJyUjI4WXViTEswOVdWR1NETGF5anFjOVJRNmND?=
 =?utf-8?B?alpxam1Yc3VaS2Q5YTV5TElEbmxUVlNFK3VVVXpweWk3WVJQR0NNZUszYU1w?=
 =?utf-8?B?OTczdFVOMEh1b1d1ZlRPa0Zjc200RXR3ZWNGaTBNVjJwVWR6dWllS2hLWDNj?=
 =?utf-8?B?ZTVqaVBxUTl1Z3ZsU3hNZVhqM3RCWVMvTmFsV21KaG9rNUxkSG9QMEpsVWZl?=
 =?utf-8?B?a01vdDlRcTA3SFE3UE9GS29PRE9YeFhHNHNXRWl0V1pFMGt5ZjhaM2NEWXRY?=
 =?utf-8?B?SzVzNHpQdDFrd1cvcDNWZVFwK2Q1WVBCUVdZSVAyRXpkSlVPY1gwWllmR2pl?=
 =?utf-8?B?NWc3RnNYTnJ0NlZWTXAvZkxBOXN5K1oxb1pLOGFPOHFkb1l2YlZsUlFpVTVT?=
 =?utf-8?B?OWJpQ3A0cVZkMDdxMFRWNFhuK1hJNlJTSFVvQWM0LzY4YkJOZ2Jad0RyMGVl?=
 =?utf-8?B?NUdVRkRnc0h5ZzE4MmpZeHJjTnBPNWdxN2FaR2dZUEMwUmlOcnhMcEt5aUpO?=
 =?utf-8?B?UEdBQmE5VnZYcDF5MGF2dFRTYmRmMjA1SlV0SU51UERDT3ZOZkxvY3FRd20w?=
 =?utf-8?B?RXN4VVNxVTR0YTNOQXlyaElFNUJpREVCY3BpMUN1THQwdTBPVCttN0tadVU3?=
 =?utf-8?B?NHRLOGxMQmhIcUlNSklSNXg5bmxpdSt4R2pBblMwSVFYR2hoaklmOUNZbmNo?=
 =?utf-8?B?ZEg2L3FHUmJJRVU1UXB0WlFHTW5CSzdCeW03LytkVzRrYllUQjN1WmNZRW8y?=
 =?utf-8?B?WXdQZ2RkbHdlbGY2VkdPSm52cmYxS2NrcDFITFhmY3Y1U0l2OVgwcnhqT29q?=
 =?utf-8?B?RUhsNU8xZEJYZ1lLd1NweHJaaEZldTVnV0NORksrSWdHN0dYYzYrUmVSRC83?=
 =?utf-8?B?djRTNVNaR1FTdEU1ZVh4Mm9JR21HVFVJSUVoQVNCSUh2WWxVSGRKWU8xQ3lx?=
 =?utf-8?B?TFZiOFRBdk84alBMWVdRUGlIQ1pRTDkzaXZ3N0dNamQyemdPelA3NUZSNDZS?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S0dkP9fMlGP+N8apqFwwIGvQJU6F7npG0vv6ILFjnT2XitpUCDJGfEHViu9ik5GrNhPr5mLVwFHNy++P4q6LV7i8n0TGKjh00G4ghbsJ7GizRSSf1TKB4kFtyHKf7ME/rOuJUYNrauZH0SEc6a/mMVDoLbT3i8Eg8vmAZqe5ZMh3QvLkyeMzBUWdE3l5LHip8Pb1u47zgJHvgRFUd2N3rraoS0294o2z3PsevCg0dRVGFKDGGGsNlKDQs+dZg87XklAUigHRHi7GevLdJJSK6nt48TasrplHvcJtAav0ZSWcJ8p5DsoD0CfsuS/VM/O0TfSb5KoYXAkqEsQjkfl8v18eYNCJ31CAgVG5JllHbn4kxjs4qpteP1wj/+aMoKrpwts17CY9r73ABMw/+yh79LSAXPfzaTiySBEhdq1UoPCydcQZwaRYoNp8j8DukDQJNu/WlwbIt0ki/SMa92IYgSelUcemL6T+bHPOD6hAets4A4lq6f4vATCR60YU+oxfBjodctFpCOSYcOnkG4yQmzQGQsUGbfi2OX5Pzz41HklF27QuEpzBIgWkaFwrq4zMjGh4pTCqUrLFlb9oBysxbx10X+4C8orGX8XrfgYyfyw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db076d7a-5e6d-4c9f-0bbf-08ddc9fb0df2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 15:10:26.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9GutDDGEzjWokcILwVrm6Bu+HOn2ad1WsIU3hkep7cV8p3eCPi33Quy4nHHJLx2zbbzk7N4Mkxg/8i5IrqoK9T758r1867IT8Xhblbisig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230130
X-Authority-Analysis: v=2.4 cv=TfGWtQQh c=1 sm=1 tr=0 ts=6880fb66 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=uuHRHqXctlGIAByXzFsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CrqSlxj_-ZRKyYLN7w-ExokuDJXM6oEU
X-Proofpoint-ORIG-GUID: CrqSlxj_-ZRKyYLN7w-ExokuDJXM6oEU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDEzMSBTYWx0ZWRfX9D1SibGU3cqU
 B7jztSD4Qil1HjQO1lAhwTwuEjxidFtXQix95SPSJRaO8KbhZCzDRas+R32KE3PByaRt1ierZJM
 HpMoD+oVrqTvOL6czK9XmoBWvoNbpknTBBTpcPk4Rsl1DMps1kwhsy5wjGQZIMJbrImYvUKWHRm
 UL5HR7YCImj3BS7ey0A7sUWoI1j0AnB5vVDgnjlVMhVnpDnRA5uRvf1zDZtwGI05XsHipzbjfY4
 cimAQAajiZSUDSPAUCRlHHljXCg1vutsQB1VsefhBJZIbZuhgbPybryEmjJHg7SpFSVZJm1h6v1
 k79fr5GTO1PNLPgAbPWkOsFT16oZRtolx/zTlf/N0McQ2AQbrFjzIAkFkNco8SPt7+q41QZLPVP
 c5csS9ITAnJ5Csei0visG4o7AB0ww8WUMxiqVe4US8SlbbJUOkaURCgLdalYB96K+PVVew8F

On 7/23/25 6:28 AM, John Garry wrote:
> On 20/07/2025 23:15, Mike Christie wrote:
>> On 5/14/25 5:26 AM, John Garry wrote:
>>> On 08/10/2024 03:03, Mike Christie wrote:
>>>> This adds atomic fields to the se_device and exports them in configfs.
>>>>
>>>> Initially only target_core_iblock will be supported and we will inherit
>>>> all the settings from the block layer except the alignment which
>>>> userspace
>>>> will set.
>>>>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> ---
>>>>    drivers/target/target_core_configfs.c | 42 ++++++++++++++++++++++
>>>> +++++
>>>>    include/target/target_core_base.h     |  6 ++++
>>>>    2 files changed, 48 insertions(+)
>>>>
>>>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/
>>>> target_core_configfs.c
>>>> index c40217f44b1b..f3c7da650f65 100644
>>>> --- a/drivers/target/target_core_configfs.c
>>>> +++ b/drivers/target/target_core_configfs.c
>>>> @@ -578,6 +578,12 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
>>>>    DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
>>>>    DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
>>>>    DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_supported);
>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
>>>>      #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)                \
>>>>    static ssize_t _name##_store(struct config_item *item, const char
>>>> *page,\
>>>> @@ -1266,6 +1272,30 @@ static ssize_t submit_type_store(struct
>>>> config_item *item, const char *page,
>>>>        return count;
>>>>    }
>>>>    +static ssize_t atomic_alignment_store(struct config_item *item,
>>>> +                      const char *page, size_t count)
>>>
>>> What is special about alignment that we need to be able to configure
>>> this?
>>>
>>> Won't that be derived from the block device queue_limits (like
>>> granularity)?
>>
>> What if you are not using a physical block device like using LIO's
>> ramdisk mode
>> to perform testing?
> 
> But would this non-physical device still need to support atomics? I
> would assume so.

It depends. For just a testing mode not necessarily. It can be relaxed
so you can test different scenarios like you want to test when atomics
are not supported correctly. For real support yes.

But just to be clear for either case, there won't always be a
request_queue/block_device. For example, rd and tcmu don't use
target_configure_write_atomic_from_bdev, so the atomic values can be
whatever they want to support.
