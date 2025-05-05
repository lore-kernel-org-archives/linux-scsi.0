Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A611F17E473;
	Mon,  5 May 2025 10:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746440238; cv=fail; b=Ypc7jU5DDHCqxIAaXjIMiQ28nac1g2a1hBrGMep18qskp5JdI+uIYsSpVhUGAxWYuIfiY4/I62H/bOvCKQDiZz8VV0L4mntAzMj4fvwVLIuJBv4nQc0FgB2c17MMdK+5EpRmmeD64R+Y4qL4Ejn4f9SMEGuvjdOtDVMKdCC5Ygw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746440238; c=relaxed/simple;
	bh=xoKFlIU/ApGnmtkw35REJfHd3dn0HWWxwUiPMCnfv6Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PFZtGAIYNNl37TLuSSXCf1m2kNgf9rWbWaxKBz0Vu2PdfeWh8ZD97deN6IqrkhC+3UNkUSASlUAg/TaiMvxkVIYiiQskN04UXeA3/YcXs749xJNLHNOEJW1D9Crdd7H7w5aVmzt1jWCy5i9L+e9yJ2/Ic72dsq/B3Cjnx5+ylRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JiczQqyt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Au8UTuMy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JiczQqyt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Au8UTuMy"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5459la9j007434;
	Mon, 5 May 2025 10:17:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HI9BRUiq9Sy1HfC4WfZOkGEHoXQZKomerwtf3Hagy8k=; b=
	JiczQqytXIrlaKhWlBcKe7+ETyolEea7MLJpO3vOJXH628/KEAB8q457FrSk0g3k
	VZKyzR+V+TyQwtCliRuAr1QjW5G0AyE0Zu4f2lKTY6X4UHATaIZ0wRJInIDQP9Sv
	0tSzZpeh1Xo6MwQsczMvP7OuDVLwZMhoGV001u2qPY4L2m2o63BLe3ycouSXo8OO
	vv0OfQ5pNYuMSpsrW4Gkq5MpyDgAng/22NXRU/g12Ccpw6HyivLFvGsT9cAU8pMC
	vhLAQsM0yUc+JmDz/DjvcUik8TiXrAXTfgTh8yLv54nXbtVqpU2iC9m5xy7oTejM
	tz4Xc2aPxYpIpIyffpP7YA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46eu0gr1gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:17:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5459NMl2037684;
	Mon, 5 May 2025 10:17:01 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010007.outbound.protection.outlook.com [40.93.11.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k78px0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:17:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BUJhNgRZFyyXi0ZRIdAW1n2lgPzYKo0gWNYZmN8T/2huvefIx3Zix7JPmUx0Se36mPVSYgR23K9hcboG4UJDXi5zcjOSQfSLFSzjRhhC5o+3vl8Q/gPRHQGH09KtE8EWT3LPaLPDXvSyTupjl7xYK3ved8RFfqntnawtgElHopI98bXhlm+YgRwk5HS+h4UOPLM5PpK4M4ZQw+AiA3ARRqC9gxOGo7Z9D66sAD3/yvSJJQcDPKMQSsGu7UwHNiJecX4CMGsuBSY7M+U1z61MJbkQKbG0ED/BllS9rNwomoMFniAv2+fNxGFmoTUbxpQ5JmUuhIAJFp7/flgdZdT1nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HI9BRUiq9Sy1HfC4WfZOkGEHoXQZKomerwtf3Hagy8k=;
 b=ot4PpcT0SgrUpIpiqMYCAPtdOCE5AHOGC83EuioJJAGQF4j0e9+85PW7cfok4c4V8jYIaBaYBfkGur/KyBE5clgKZNGdzdtiIw/v0fpG8MYt0topYXNUiZOiyI3eDZIvF4iHr0n1P4mu74uaPxRfO1SSl+pL+GKfm0QcAI2JP9kn1lkODv/LgNW934+GWZNVuBeIKhnp9Uf+1c7yxb1IPV5jjz5dtqOc2Rn43HtZgALEWmi1g+JCAx9YCmCfcO/mlJBzZ5PR24jVil3fGGhGTcZPeaMyF0z25JDdclCsp1SRKNF3zoQ1a1X8X0/VrxIM7E7/dyqYuiv4HtWNsencvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI9BRUiq9Sy1HfC4WfZOkGEHoXQZKomerwtf3Hagy8k=;
 b=Au8UTuMyfpk1Nk2W5n8s2hl8CJDJ5SwhMfNszcn2Nl1ozUIzROsW867pzbrOE8pf7pwe8w8aKIDWOM+f/ist/BMDz8mU9R7UWPSwpjxgNOG9iz7HpeWSVnlAaBIBvWQvMFby1Vu8C7l2lvgjX1Oul3zCGBQtf1S/kcAVgDnkuyU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Mon, 5 May
 2025 10:16:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 10:16:58 +0000
Message-ID: <dabdc0b7-879b-433b-a5f3-005fb58421a1@oracle.com>
Date: Mon, 5 May 2025 11:16:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] scsi: make ppa depend on !HIGHMEM
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org,
        Hannes Reinecke <hare@suse.de>
References: <20250505081138.3435992-1-hch@lst.de>
 <20250505081138.3435992-4-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250505081138.3435992-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0167.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: 47b616cf-cc33-4bb5-2d9f-08dd8bbdf7c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXZadS9PTEZPRk1mdk1GaDNzY3JtdnFySHRFcDMyK3J5TUdwRUx1emw2N2k1?=
 =?utf-8?B?SmJOSFpWSlJtT0xKV0RBWWdoaXZ1RUF1RmlEcWhvVlFPa09zWHZyWFdQQzZT?=
 =?utf-8?B?TCtIK2RwOWxhWkpuLzhLcitHZ3NVN0J1Y3hUTTVIVkxieUVGREsyT0g5TGds?=
 =?utf-8?B?a3psdEY0T1JNUXNSR2d2bWNlaUlHUGVVamdqZ3J5bDdqcEl1cEFDWHlLUjBm?=
 =?utf-8?B?MjNXZGJ0MEoyUTE2QUc2NkZTUTN2Q21SU2QxVGFWZTVrSjRuekpOaHBqdGhv?=
 =?utf-8?B?SkZ5elMxWWFJZ2ViS3duRGpRWUNETS9FOXh1QlZpYzBBN3d2SkgvSjdFQmtF?=
 =?utf-8?B?bVdLMDhGaWN3ekMrbitGQzRMWW1VNXVJcFFUVlJ5TTkwYWpxbjg4UkNhK3FD?=
 =?utf-8?B?VE1uZ0RJdU9vdXgzWS9VaHNxK2gzSEpnWEpQWTdQcjlLYVhjS01FaGtJWG9D?=
 =?utf-8?B?WjZKTEMvYzdDTXZxamo4K0Q1akFITG5ncnFic2Q3YStDWVBaMkorSndtSDZt?=
 =?utf-8?B?RU5VTHdZL1RKakpZakJVMFVEZFZlMjAyd1gwSE1wZnZ6aExUYXhFZHUwQ1B3?=
 =?utf-8?B?TE1jNW1UWDZsMk9rU3dKdlpXaGRCTk01cmpTUXhwNno1ano5SlMrMzBDcW5U?=
 =?utf-8?B?bTBHU1NXU2FwOXNGaW5hSDhJQUVvREZ3aGI2SHJhOFVJWGh5bWZOdExhdisy?=
 =?utf-8?B?V0lBbHpPekhiUzluUThUYVl6MmtUTkpFVlpzcm1wS3Nya3htM2t6L1dNeEtn?=
 =?utf-8?B?SlkxM0diOE5sRmNPc0xYYkpjRHVkbFV4SWZ0RWZ0bWFSMlpwUEx3N2lpV05G?=
 =?utf-8?B?VFc4amYvOGlrTmRzSkdzaEo4TEZ2UGlOczA5N1BGRzdSREtTa0gvNkovRUVk?=
 =?utf-8?B?UUtZWVNhRllwNlExVDg0anhuSnFGMjdJYW55MVhjK3ZQUVlxQThQc0cxUUhU?=
 =?utf-8?B?QW9ROG1TVjQrcDY3UjdKNkwzVGlZb2NKS1BEbHVySHM0d1BaQklzcDRzUFlo?=
 =?utf-8?B?Qk10RHQrQWxYdDROOVA4eU5Wd0VCMWx4ZjhnWnorakhUVHZJUFBqQ3A1WUNj?=
 =?utf-8?B?YXpIWXhrSW1sZkxDNjhuWUJiNzVnemRIM3ZjL09TMWxmRzFVckQvMmwvNnZ0?=
 =?utf-8?B?aG4vNC9jb0cwUUNuUVRaeHJKN3N5WlArUTFJaGRPbW5iVFdjcytyQVNFOVhU?=
 =?utf-8?B?UE9zWUlxSTZnTTZld3NKRzZhRU9TU24xY2g3SWwydm5ZTXZ5dTFJTURyMEVV?=
 =?utf-8?B?U0dhREsySUhmTng2ZkZZdU1OYWF3dS9pQi9Ea3R0ODMwYkhaTXg4T1hKQS81?=
 =?utf-8?B?eUdpekpWQUt5WEEwcWtOdGFneFJ0czE4ZHM5KzZrZ080NFlXWVgvaHNzcTFK?=
 =?utf-8?B?Ymw1U0xySlhQUnJXMG1KV0hNOVUreW5UY2N0eUoxWUNLdU5yU0ZlRm05ck1K?=
 =?utf-8?B?RGxjWEV1OHNocEMrbmFxaG5pZm5Ndno5TWt1SmUycjUvU3ZOelJzQU5SMXVD?=
 =?utf-8?B?OHRuYVM4ZkJ5Q0FGYTlZWjBxeDdUc1RPQWZBYUtmWWYwUjZDNkgxQjhzbjFV?=
 =?utf-8?B?L1R4dHVSU2JtTWFiZlJzY3cyMm13QktIWitSVENCdTNJNUtlZUx3K2Rtd3ky?=
 =?utf-8?B?OUEydWJtRERWKzBOV1lESDlteWp1Z3RMWFRwakVFT2VNQVgyUXh2WkR0Smd0?=
 =?utf-8?B?Sy9VcEVjSnkrbDVYMHpSYktMOGFiVVZlTVhMYzMxeWZEdmJVY0dBS1RnMStz?=
 =?utf-8?B?QzVnUlBLRkEwcXNId3FRU0NXaStUNGplQjBGbHRqSU1ZQnovcWJiSU1EYkJY?=
 =?utf-8?B?eFhERGpkOHN6aURpMmMrY2lXcVdLSnRHN2dzbW1aTk9qZXU5QzdlOUluWU9G?=
 =?utf-8?B?eVVFWjdQdWxDS0lVV3F0bGV4N3NHa3E3K1lnSnlFblpzblJDQ3JPdkgvaVlX?=
 =?utf-8?Q?NXlhE15/ol8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3pNZW40TktUTG5nSi9PTEN2b1c4VUZPaXc4MHVUVzBLeWtubDEyRE5ycUFF?=
 =?utf-8?B?K0RNTkpJem9wZk9vQThneCtPOWNTaW9rZzV5MUZBVllac080WWQzb1MrMWt0?=
 =?utf-8?B?OVRreDNvam5pZHdhUkt3aEpZLzN6SGZzdjZwRk1zaTl6ZUJydWhuQU1rVUZ2?=
 =?utf-8?B?NjVJbS83NkNMMlpNcTBHNS9CSjdBa0JkM1p5S1NmcDN1OXZ0a3FOMEZMOGJs?=
 =?utf-8?B?aE9vS0RQc29oSkpoVTFma0RoNjlBQ25kTm5aWXQ3ZDJkZWY1Y216Z2drSWhH?=
 =?utf-8?B?V2c3NDFzaVJ6OXZvRmxTOUhYblphMDlpdkRUUFJ4RWM4NDNXdnZXTTJ5NnNE?=
 =?utf-8?B?VFhXVUJINVZGWDBLUmRrNzlhOTd5VTNLNXlLemxBZnU1VGx5dmpwU1lTbUhO?=
 =?utf-8?B?THZmNk5mdmxsdGcvWmhNTEp4NTVQVVBkWG12SG5rYWx6VUlCMXFPOUJLRS84?=
 =?utf-8?B?OG5zMy9uQlNqUHFjRWhFOFNYLzl0azBoVUFXaEZwNngrWTZ4dkpGR2tVcXRT?=
 =?utf-8?B?VjI4bFp2dW9ZOUZKKzIvNTMxT21seDMxakFCU2dZTHcxelEvUGp0OW9hbjl3?=
 =?utf-8?B?Q3hTcGtXcDk5NnVUUXk0NVo3VGRLOHppQWJ6V0dkNm9jdm5FSmFiMDFHSEhh?=
 =?utf-8?B?M3FYMUtFQ2ZoTzVpK2hzODJKbEVlMXloYWM2R3F5cWRRUW1oMC9SYUZMd29H?=
 =?utf-8?B?S0I5V25KZFpVZlpRN1lCNTI2ZXFqMFQ2c1A4SHl3UktIZ055dFBVYkw4cE1D?=
 =?utf-8?B?RHhCMTlmdTA4M1U5MXZSdTFqVzNyVmhoRm9jdnRveGt1V2RueEw3cy9vcnM4?=
 =?utf-8?B?czB6TmUrQitGcUxZRjhqQkFydUo3em9YZnA2dWYvM3dSS3dvcTFJNFJiNkdD?=
 =?utf-8?B?K0VldmRXemNQMGd5RXMxNm9FcGU1TVk3SldqUFUydURPRUtqSWppQjFFWXNC?=
 =?utf-8?B?ODRCVmxHdXlxVTRmNkt4a0ZCOFFxRVdNcU9rWFVYN21TWVp2aEp5Rnp6LzhJ?=
 =?utf-8?B?bGYrQWRSbmxnRHkzSW1NSmFFZDlEb1psc0JKZWV2VFVubE9qMnJZaWovNzRK?=
 =?utf-8?B?MHQweDE1d0NJTnJxQ1p1TVUwU2J3ZE9PYVlPNjRKa1ZnR0FqZ2tGTDZ3bUM0?=
 =?utf-8?B?bnBRK0t0Skd5RnBDVEhFRmlKY1hGUDZUTWpmT1I5UkdwVXRKaGZJS2dSYWp4?=
 =?utf-8?B?RWtYZm5DY3kxUlIwL1lHejlmYWdFRUJmbWwyUy83UFhGVHV6b0t5Wm5HemJ1?=
 =?utf-8?B?aUgvWmsxNFNvTjlSSUdNVjJUQURmYXVuYVk5TVRBWkZCK3V3VmtTc05PaWZr?=
 =?utf-8?B?aVNYenBzanBLb1c2VE1TZlRQSEJ3eHdIdkRrN1d3elBjMVh1ZWtBdHdhQ3FT?=
 =?utf-8?B?cFpMSU9kNU00L1BrSDVNVCs2Z21GOHRrKzJhR25MT2hIUWZmQ2J6Nm80bk9C?=
 =?utf-8?B?SkVOWmdnSnI5U2tIUHVqKzNrRE90MTc3bHhZVkxqaUdRMW1Oc1MrTXEvQmJl?=
 =?utf-8?B?UzQzVlBqRVBZcXVkNzhWdkJuNFJWS1cxWXpsV0tCMXJRSXVtcUd6Nzd3NE9O?=
 =?utf-8?B?MUMzMXlJR0wvOVdxcFFnTXVJd0ZhVk9GSHV2RGZzNnFBN1huZ09ac0dyUG1I?=
 =?utf-8?B?TDFQbGQzYjVoTE45V0hDS3NLUThyamxHWCtPTjRhUjlhZDBidTd3UTBFZkpK?=
 =?utf-8?B?aWNDaHZRRGJ0WGs1cTBHL0FzVzdUeHZqL1REMjZrNUVXMkZKTUZrdThlY0Ur?=
 =?utf-8?B?Rlgzc0cwY2x0T2NUb3RLK2c3cXpUR2VkMHNuTXlONnhEYnVVTW9xWGVjbHoz?=
 =?utf-8?B?dVY0Y0NNdEt3aDVtU0Q3RlkvR25yTU5IdWozWFJ1UkVZdU4xQWhyTDF1aVJa?=
 =?utf-8?B?TDN0S3YyU2h0ZkorM00zUFFNUjhFeEMzZUpZTTE2aTJwbGpDOWk2a2dLTlBF?=
 =?utf-8?B?alliYy9QekV0Tk9qbVQ4bXBLMzFTTldGdWkxMDlpTDZ5SUZGdi9iaWtyMUJO?=
 =?utf-8?B?N1FJOWdTYmxKZ25qUmpxV3JsTk5YbGkvd1MvclMwNmdkM3hPUVpGaXAxSFh3?=
 =?utf-8?B?QUN2Wmp4RnNUWVVMV1dSazlleW5EcFo1OUwzcHBXV1JRd3U4eGk0eVBaLzJH?=
 =?utf-8?Q?ICHxxi4iVbIxijOn5evUh6c23?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nGOZ6WFYK9iL2cr+Z9znmkXEfURRxDoy7LxJgnJnoYI1iivakLR0/WZczlHxGT8vg8tCZ6c0L7zsJ7SYU35IGMvWJqa7ihI7GfhYJmOlmTOykd0lgw81TF6faTEFp3N8PoXEHBX22AS70CXcVN3PBJCAhiZBJKel3x0CxvWLkaarTnYBnXr/HngjEP2R5QkYXMrL5HiEg9MBSHEgyAo/3WVJq+bo/yzXjYX+a5jr7s4213lLI2LU5aTuJR4KrQsz7HQ154l/XE0+Z4L2XMAVBmoLmYEr5mn0brerJ7aIrFwZq6k2DNoVD/9IZPrdQvkePbcGH/eGJu1Pra5tJ1sZIm93hH4JBB+4mlS+ivcIRb+bf/P1e3MtqMUgGWsKRcRbb89MBdJWLTkPKe3TBh37aM2z5S1zL3zcA+jLwfGgf92VfYdGY3Fo6p6jnUvZHxXRSDh7poY43E7hWZf1Ro2/o7n98paSYE0B/8RvkyQus1RZQcULEW3f7TgxPSBFCzfILrey/8Z0TILwMpDg+LR0QVuZVAhLSecNWyyszEvxJqirQdQoWA01nUi2L3w7xcTpwl4+x0LQg0KkbL4zJgRD63a1uv/+1x20EeSlA2LfCC8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b616cf-cc33-4bb5-2d9f-08dd8bbdf7c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 10:16:58.0931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35aQ6FfkUhBhx9ckIm+i4O/79yN6T18asGEwxR2ZarQiNOQmQQcQHba9PDiE6UeuOIkcyG8l+vy+fw1pBWYeNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_04,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505050097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDA5NyBTYWx0ZWRfX3Si0TMc+BhD/ rH2TXMT/cplHdoAJDP+pty6LlDuYEW8+ZvS+Nh3wRJR89bDklTl4u5DN/SfGCdnknNrE5MCUd4z uC8Mw126tCWuwn9c+eCbembAdgzCP0SP5IMTgAFa4CgIeiHgrFnHJTanvtBo94760UNfWF9ggf5
 RdlT9DDtNRAIwXMyYlbM99EwXiwqBQTKX7KJko4gIjrDMkWp2/DDohv7shVCS8PzgVIOO6Q15Rg dmZoR0SNfG2aXoBCZPHQ2fz29BKx8Zr5uYuaT4zuv7Xusffm3jYBXCQg0S09RuGXMSjO1Yp5BHQ lQ/+oQvJE/GXA+X/7nhowzTEC6dzuidFZ3eRcozXMcSP3Yayqwl9H3MS0m7z2/FhkRX+9w8BvrL
 mOGvDJ3KtcfweP6UoQNLHnLwwWL3izUtVNfMODlNn47p24QhPsXr8lF1TKFsUUT4ddez60CS
X-Proofpoint-GUID: WxkpaUG5Z8kGf9CrkUK36DvWwk7y_CZx
X-Proofpoint-ORIG-GUID: WxkpaUG5Z8kGf9CrkUK36DvWwk7y_CZx
X-Authority-Analysis: v=2.4 cv=M7RNKzws c=1 sm=1 tr=0 ts=6818901e cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=_MckG_xjt8bSkswAZlMA:9 a=QEXdDO2ut3YA:10

On 05/05/2025 09:11, Christoph Hellwig wrote:
> This is one of the last drivers depending on the block layer bounce
> buffering code.  Restrict it to run on non-highmem configs so that the
> bounce buffering code can be removed.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
