Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FB64207A;
	Mon,  6 Jan 2025 21:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736197476; cv=fail; b=B+afoWWXmqvud9RWzMA7kwkasrl+cK0SrSmkTAa7MNJ3tSDNuRzx630Dt3FzLqj+8rwqJJ/tv+ekAEN7wg1IYlwQQLMqyMRiUaKRqYfplbwT0elnjm9s8IRJnYX7TM3SdCqs4IpctJ0k1ydwgXli5PtWVhfo4u77IqX6vXGp8oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736197476; c=relaxed/simple;
	bh=Ln7GHifGoHfUGVMyfQjNanFPWG80sxMVPJSX3LV5XiQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NsfLE5E7KFzcN5dNF8XIpMge6vGpRObhRuzKWjGAvySU7mR8YvCk+c5Jg4yLVPho2SRTCOhNLNHs+tU7BHzSpu6PAaGPLE+yGUtZBllc2QPsQEGNUEnEL2gVclbrJN2vLNQyPJOVHY6/g2vJto4+rX33DGPRQKA/LWJwiH9nUWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i/FLwvQE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dN5SqCt5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i/FLwvQE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dN5SqCt5"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 506Hth4x025614;
	Mon, 6 Jan 2025 21:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AsBsYrkbfK5tJSAI2eIf1SeubrvH2/abZyAPcoSLl54=; b=
	i/FLwvQEYMY0v9J8d9gSEHlCBgWrGUiTyJ0//8Y6wx6a45PFlMYloY0fYG/E8Zls
	BAPPgKpMQVzJ7w1iRNxRZjheJjF+/yKtK2UlPpyY2ZA4m+6KYw7ubppwBnzEO8cw
	Xvkm00iG12wtvWolOdmXXItRIGlvK3Y1FzAbcortLFW1WNdJlW+e7dqhPFtMzh+f
	zMvQBgmbxwInfKfdxdQ2lfHNeDjs8rNWrBEyKB2mC1DeNHseIbAhL8DdtpuTA8hP
	FE/PzUpOw+lTlPQXKwCVCNQOJOKXwgS8bbn/kOthKDz6vJF6/Hw2dZ6NHs8E1xdI
	f3pyuP8yZ8+eCAm6N2YOnw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xus2bett-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 21:03:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506Ki9M6010741;
	Mon, 6 Jan 2025 21:03:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue7h0x8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 21:03:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uly8sF4gHC0Dq6AUiMG4ga8V+fixCzS9aiaiOJYCHcRR2kGczpLDnIFB1vZYJ66J8rzk/LBX9CDJ9yJTLyXpKrOPKt8fCexlHYbngFW5YOpWSZIQSaLt12MO8WBbxrlBIpQP4dcWmscazOmvtLnbjKDlhwPL+eavV+IlqvhngOFeuxcM4PwXZxbfm2futjQmcf1piS5JxB1LKAJRq76oNe/LmCEeAIWQqzyd0S5tLq6atHZplmD+5seZRKDrNGjeaxmdO+o9Ory1f0m7Pt4KDEY5ecul5GjfWlbKZ/6KNrtG5eZ9o6rqTP2HbwmdVwkB9SiSkAWMTQh+NIRbWw3EWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsBsYrkbfK5tJSAI2eIf1SeubrvH2/abZyAPcoSLl54=;
 b=RRzmhHjNKRCLZeotSm+y8a6qN39bXnHDIJ1KJAWtOZ0vhUAWcu5e940Jt4HrYchXZkoTpmq2gosAqa5gKX+jRYaOoFMD51chPJw7s6Dq12W0sNwuyRHKLZFjSIKbEnYEFJxyaFBZ6Myv+MTLSgtKEHyVLaw4LfKneLWE/4rKLBLMaazrVbTMTNFlpBycfKPxtSjZ3w2c9G5ojh2PhFXntTDqeA1HLn7t/s/Pzs6408NU3V58YExgIoCnLwqmPzS23PY8yJB5HQrqMSHVD0INIdFxUsaRjChjYZpW8DCdeUPbsnw0B5clwLtYXTmSxp2jwFq9SbvX0Qy2bEodanyLFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsBsYrkbfK5tJSAI2eIf1SeubrvH2/abZyAPcoSLl54=;
 b=dN5SqCt55YpMxkP/w0a2qMd7wnNz8p4Y2CzW2SnFgm4A9cD9cRSqfBYvNKW3vTjVFNTzyLkUL9ULEawjAPGXEOBp6dLT3LgvTAahqtc0n/TAHb3EUqHlc88+ZAeNmFn9lYnHOYLAyR7ouceANzTIMNyk4vMJovMt5hWD6KTxW8Y=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB7791.namprd10.prod.outlook.com (2603:10b6:806:3a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 21:03:23 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 21:03:23 +0000
Message-ID: <d9be3663-f6f2-4a1c-bd88-2a3978f92bb1@oracle.com>
Date: Mon, 6 Jan 2025 15:03:21 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: iscsi: Fix redundant response for
 ISCSI_UEVENT_GET_HOST_STATS request
To: Xiang Zhang <hawkxiang.cpp@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com
References: <2caf466e-322b-46c8-9028-8bfd8347792a@oracle.com>
 <20250106041607.71102-1-hawkxiang.cpp@gmail.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250106041607.71102-1-hawkxiang.cpp@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:1ca::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: 91442925-93f6-4696-01bc-08dd2e958e72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0gvaXJseVRxc213YlhlaDk3WFE5VDRSZ3duWTJjd1VmUllSNlJ0SmdlNGhn?=
 =?utf-8?B?a2FocSswNHlvdkFvc2NDeVkxR1p3NjlEZnZtR2xodTJDTE1tdTFOb1pYYXBz?=
 =?utf-8?B?UGRmMkI2UkpobEVRMStvZDAyUVcraDZGcGZFRHJPQURvTUo3b1pIbDBtUmxu?=
 =?utf-8?B?VUF3WGcwMnN2LzRYQVF5YmJTNERSNkJVNVFhMG5PMy9TSTdDS0RYNEVBeG9I?=
 =?utf-8?B?WmorRXo3Mkd2Vnpna2lzeW9KN0JoVE55dWovdzJrREx6YU14dWxtSGg2UVVm?=
 =?utf-8?B?eU1XMENSait0MFVuaEhVVEFobzhPaDhYQ01MQ3grSmxMS1gxTkFuS01OeUJa?=
 =?utf-8?B?aGN6dCswYXg2YmtMTW52cmVMY2hscjNkUUVKcGtWWXltQWprZkE4KzdCWEpY?=
 =?utf-8?B?UmNrVmllalVVN1ZJVithM0xKei9nNWNwY1NQNG9IR25ydDlFVHZtYktrRGxa?=
 =?utf-8?B?d252MkhPV1MrMkg2NnJpcU9OWlRxdXcydThlZWxGRy9ka2ZVWDE4QlI2VXNv?=
 =?utf-8?B?RFltL2laNW1TUnpuaS8waXFYc0NyWkNicDA4bDhsd0JHZURsbmh2QXhzak56?=
 =?utf-8?B?T2lieWNhS3Y3TEIzL0xhOWh3VW1xdFNVTThYZGY4a0J5RlB0VUZEY3NrOWZ0?=
 =?utf-8?B?U1lWL1Z4ckJIOU9WbGh0QTlUVVJnemxJeHo1ckgrelVxSzlpc092TE5nWUtq?=
 =?utf-8?B?SVNuY2FFNHlrZzlZVEpaVVl1dHdGRUZ0TWtONjNEVDB6dkNUSWtvb1hNK0dH?=
 =?utf-8?B?KzkvVU4rS1RLS3pQTkpPYlVyWkkzWndueEdtQ3JPNEx2SURWdWRKMFBPUGNE?=
 =?utf-8?B?R2FSSTI3ZWdyTzBySHlRWXdZM3pCYi9FZHBsYkVFY2VUaGNVR01FQ09vazMz?=
 =?utf-8?B?MURJMy9iUE9rM1BrMVp0ZjAyOVYrSlpDZCs5WkpmZExlaTRBdlovWVcvWjdq?=
 =?utf-8?B?MDlOMVRqTTRUUE5reHJMZHIzY0hEcitjYk1qSzY1UWd4bGQ2TTBnQzdQd1U0?=
 =?utf-8?B?SkM5VTFsK20weVdZM2lqbGNON0RhemdhTFhvN0t3QU5yVHdmTG1aT1UrOEZY?=
 =?utf-8?B?R0o4R1NTY1gzOEZpcitITzd6MHRHUzZsZXVhQnRtY040WlZCNkhpMlA0NlpI?=
 =?utf-8?B?MVNFcytsUTMwNmo2QUx2ZEk3VGF2SVlEcDhZYXE4aUEydDQxWUFpUGJvUDNE?=
 =?utf-8?B?MkF3UWpZUWlrazhWRkpFalRnemI2Y2tiRlJVeXpmWjhPb1JnZEhqWmNET2Rt?=
 =?utf-8?B?MXpxRzR6TXdzZTlqOGdiZTh1THhJWThJelVDQjgrQmNyQXdIeXg3K3FMVm9D?=
 =?utf-8?B?aE1aUUQ5ME9jN2lqWlhXZFRoZVRvTTl6OTdZYy9vT3Q5dGRSZkI2cUk1ZmZ3?=
 =?utf-8?B?clVhTUNSd0FsMmQvZ1UyNjhFWkY1eDZvb1VWUTAzZ2s3b2p1YzBFeVJURTZU?=
 =?utf-8?B?dzl0TS80a2N0N1RIeEhjTHhRdjdNN0pNVnN1VU9yOVA1R0hBb2d4N081WVNH?=
 =?utf-8?B?cVBKOW5QS2hUalcvdnlYT2xKdlI4SDBwUlZqaUs2OUhiV20wVTRhNVFKNHAy?=
 =?utf-8?B?ZFdPZkJYWXc2VnQ0SG5DVlZKTFVUdlJBK0hZL3puNG04THRVV29nSHhIeFIx?=
 =?utf-8?B?MnN6YlJmbWxScE5MVXJqbVhCTVhtdGQvTm1Kc1FrTkw2czljeXVyV0dEbzZC?=
 =?utf-8?B?UG4zVElzN21qYnA4MDhzVWlhZnE5ZS9HQkVicjFTa1pIQmN5bW5WZk5LM0Rx?=
 =?utf-8?B?S3FoWmlZR04wNEU3UUJTai9GUUFQbFlaYmJyMlAyRU00OTBLOUh1b01qNFEv?=
 =?utf-8?B?TTdueElZUWMxMUhRa1pnZHRQMDM0MVF1cU1BZFhwR0hRS3JKd1FmZDM0Mm1u?=
 =?utf-8?Q?/18jorJ2P3xQC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yzk4N1U2TnRzNE95eFVBTnc5K0dPc21BTUlzczBUd0RlTy9ZaXVzS3lXNVNz?=
 =?utf-8?B?Y3A4eUQ5ZVB5OGhrcDZZNS9KVEpDZGM0T2pjckdHTGtoZ1dIQUY5UzNOWDlN?=
 =?utf-8?B?NDkxLyt1NHluV081ZDVGTUZNUE9tWlpRMlg0QUttRHZ6QU1LTTVMZ2JXUlpL?=
 =?utf-8?B?OFk0M2JrdnUwTG83YnFpZGdXQ1dyQzJ4WHhPOHg2WDI4ZFliay9NTW53QWU4?=
 =?utf-8?B?S1pTZjJ3dTdxaG1RK0ROcjhld2FTY0hOUTFOMTA0cUtqV0JLZ2hUM1g0RFNq?=
 =?utf-8?B?T1UvU3RiZy9rdjFsc2lRdXVya2JjblVNSGx6VmlBNElrRDVTYU83R0ZjcVlw?=
 =?utf-8?B?L1BjR3pIdXI5THJDZ0MxV2J2SUQzUDFEcEpmendYMnBnSDlOK1NjejJ6UE9w?=
 =?utf-8?B?RjFUZFdLQllpOHFNSGNQbVpQQ1FpRWZTbHhiWEZKdnNNTUJ1YzJTMlRJeHVv?=
 =?utf-8?B?MjcyK2p2Y0FjNHBYVXZtZWJSS0pPQWE5RGI1UWVZdndqWHJ6cnpnRFloMDBI?=
 =?utf-8?B?RitONmsyekJnUTM5bHVZNXFxVmhtUm4waFBYSkNreGVDcWNVTzBGUDRSdzVO?=
 =?utf-8?B?V05VWStNSjJLYjlEMmJJbktWaC9CMUpOU3dEZDJxQ21SSzdYSXRpNVNGbFdZ?=
 =?utf-8?B?cXRDc1l0L2UxQzVWWlNveE5GM1ZyMXVaK1VUTFhNKzZ5a1lQa05CNEFtYytN?=
 =?utf-8?B?bllFSlZUS05nSWlNWldwTkxIYjZxNzVZUHBab3hTaGkzeFBpMTAwWFNPWG5L?=
 =?utf-8?B?MWUzNEQ4MCtYLzVUbW1IenowOVhUd0RhckJrTTFaaFhwbDh5UVNiamRkOTJQ?=
 =?utf-8?B?bzc5dUgydldwT3FETGhBZHMxR1JUNHZGWXNMTjd1WTJWTFZEL3dmZlNwZ1ps?=
 =?utf-8?B?Z0JZdTNEMTFaVnpPUEJLSXVVVVkvUElpRG1TSmdFaTFzZHo5Qko0YnBYbTBk?=
 =?utf-8?B?eGVWSFNucUsrTEZPUVp3cFNSREtCK2xydDhIbTBVSlQzVktJb2RZME5Qb1o0?=
 =?utf-8?B?UVVKcnJqRHVkKzR6Ti9INzFsMDF3QWVBVFhMMlU2UTMydCtHVnQvR3FjS2xI?=
 =?utf-8?B?bWNyV3pFSWJWNG5KdzdncE9DZ09qRmtiaWVpRm9BSXJldEQyNHZWRkFTVUxE?=
 =?utf-8?B?cUxZVldMa1EvaDk2aGhubXpIVHN3YzlTQTB2QTlYTWNCaVJVUHd5TGtQNVI2?=
 =?utf-8?B?OTlCTzloM2VCajJlaDgzOTVIbWFsdFVJZ3k4Qmo3Q0FGYnMxamR4MGlsWERy?=
 =?utf-8?B?ZFVMdGRLTThaRTBZbXFuM2FNSENhNjI2NjJ6dlVDaWxQQkEwMERacVdHbCtC?=
 =?utf-8?B?R1RxMVdiRjd6RlFTMzZEVWd5NDlyNi9IdGttamR4L2VvbFpxalNSUDE4aVJu?=
 =?utf-8?B?QUZ2TzB5UjlZY1JrWS9ldm5iMTlGS3p5bEZBMXpBbENKTUlQeGcvTUNYOFNt?=
 =?utf-8?B?Z3l0UytQOEllTWZNSTdCd1lJaXBLWUpUdXRkTzNtSWFDU2pQak5CYWliWk5V?=
 =?utf-8?B?YUZvSHVsc1k1SkFRSXRMTUllQXFSM2IwalFxZjJXdHQ3TE5ScFplN2RnVEdh?=
 =?utf-8?B?UW1nMUJYZFdyekdTNXlQTXJPeFJvVWVpUS9EUE1yckpVUGdBNUxsYUVsVG5K?=
 =?utf-8?B?TDlaSGNoWjNaWkxYVWFSaDFnVVlDVUdDVU1lYTJ4d1pMY2dxM2laT0M0MThN?=
 =?utf-8?B?WVlOSXVzLzY2Skp3b3hhQ3dGeURPc3ppU3ZUdjJvQnpReEN2S212ZWVhUDRC?=
 =?utf-8?B?NmsxeDVvMFhMUW5hanVxODVnQ2xDbTh2bitMaUQ3WjIxaE12cmROZjRvOUVC?=
 =?utf-8?B?ZHkzYWNubGwwTEVXTm9xUG54RGVRYzRuNjI1Sk1oQm5CZjJrb21lT2VXZzdv?=
 =?utf-8?B?TnZzS3UyZ1VUM0tmSE4xZzNyZmh0N3l5OUFLV2ZHd0l3MzRNNjh4d09uek0r?=
 =?utf-8?B?SDh6KzVXdEV4N0pOVzRPQThoV2FGZVY0Q3hVUXF3RWM3YkNlTm9HdXRMMDVr?=
 =?utf-8?B?RG1PNEVQOVEwSFVWVFZZTzY1QXFMZ1pkSVZTRklIUHRaVERFaVE2WVIzMEl5?=
 =?utf-8?B?ZGVYQ2NpMFZsQ2Z0SWF4M01lMzhBNHFmRWJha2ljWmZJRHlaL3dlUmJLSENL?=
 =?utf-8?B?VUxsWDg0RDhoTC90TzFUUEhuR1BjbXp2OVl3cUpnZCtlb1pHM2Qxa05tRG5l?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QQa9ZgG/bXdGkR8+oTaIB/2fik46DCTbhzLeHmp+HBANt5dIuzyT4AXZ4tXMAsPBMQn8AfAoKalUCeoXXFqqzwyH7M9DKN6WIQPiv2mvu6i/E/IaP/K2WKV2bshPIx3h++JxJArbZl+6M5oodelKwNL19lI2yGa9Q2EcySQvXEvltRtus+m7FmneEqxrobRZjhOnnu8moSwMXNxTV12oRLU+LwyPt8vM74JxhyrPzR1eQJ+5sraBLgnYTcwOoDOvxPgVSmqWDL26yZXQHBfiF5nrqznBcW1fu+9TeYhMILhMv1Hbgbm/SnaVitFfXEdN0PzpP7nEqcg3CaSDXsId5Ak5+e/cHFYv42MSxsm+htvxDaK71KLFyDhUFoJAQ9+ipjBM2uxq7LVkV/ovNltKj3vfUei91Kc/AMFG0XZMN7k0lrRf7SkeFD/CJixoecVB+6RF26XWxy7Lye5N48tWaO6otKA9modgI1DC0q6OeY1ALVBO7mHRBjhMJMmUaTR8DmyDZYg2ngnkYu5r0OZrWSTpEz+rnt+g8yx+5Yz8QwQpvefSeYViSbbFQl/Vuexoh0tHNinpvrUD4QldtJkb6m6vmOOxXRF0eekQYmATXIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91442925-93f6-4696-01bc-08dd2e958e72
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 21:03:23.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtmoHyOkGUKi2jbRqHgLwKNx7bIdwyKZ0WWCSr7HqyNyI8XWBTbrN4T9CR39ntSyvY/3xyKCWaKoGQy0AlRHLoBSdteLNKRmWd/CY3Tgya0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501060183
X-Proofpoint-ORIG-GUID: DEJQqDYj3xCsGXIt8EZl_xTngkbqQCZF
X-Proofpoint-GUID: DEJQqDYj3xCsGXIt8EZl_xTngkbqQCZF

On 1/5/25 10:16 PM, Xiang Zhang wrote:
> The ISCSI_UEVENT_GET_HOST_STATS request is already replied to iscsid in iscsi_get_host_stats,

The lines are too long. You need to keep them shorter than 75 columns
in the commit message.

You can quickly check your patch by running:

src/linux$ scripts/checkpatch.pl your-patch.patch

Also don't forget the code comment below.

> @@ -4113,6 +4113,8 @@ iscsi_if_rx(struct sk_buff *skb)
>  				break;

Thanks for the update, but I think you missed the previous email:


Patch looks correct, but could you update the code comment right above
this line so it mentions ISCSI_UEVENT_GET_STATS and
ISCSI_UEVENT_GET_HOST_STATS.


>  			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
>  				break;
> +			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
> +				break;
>  			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
>  						  ev, sizeof(*ev));
>  			if (err == -EAGAIN && --retries < 0) {

