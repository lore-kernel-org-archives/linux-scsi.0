Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C41A4B0C9E;
	Mon,  7 Sep 2026 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795729; cv=fail; b=KlUDJgC8nOWbQFXBZziU+YFE+a8eQUjKeosQgJWJza4ueHnHVNwP5oq8jBPPfMlsB1o6yJ2E2VmZS1H1x0jBsF+rtHaZrqVUp3M7A/mMngSTKEsQT2hBarbqAtWre/37S+wwDjKU13cqEcasrJNzmrqG1cHLTuPs2uiEsXTyi28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795729; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r3D6PkKzs5kxOqiIPI7RtfaU176UzzuwSIqW1gX6n5T0T1LpR80xC+bhYUEuZo3+MU+csrOZ3H1/GXTR1opQxhARvSw8G2P2dPhlVue6ZBXhJR0q1Ar7595tKoCHUZKiHdfePSY09k/cWBg/Z8S7qk60ndcz/lFsJjikoK2pdKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WoYNeYop; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=WBfvYyf7; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WoYNeYop";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WBfvYyf7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788795728; x=1820331728;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=WoYNeYopzUMZbaEFbiAKw32PTMnYn0aWrwHVpKDn5BnOUNTIZSsNV7TQ
   itMA54JO2MmQTXauIpUR+JD+G5bA8fnUsne4P9/tpkxdE59WU4va1FT2s
   +tXCBr2x+DSgJfoIH+eF23ZRlBtdaibEfmbiXoPzPDNegBfjFt6+fdx8v
   7r0mR61M/4/Ns8utNjoeP+V44SzG/EipHNwmIJPd2Ewn5oJJLylbF0U5+
   v1nPvnF5jo1uuPAHWR7EALvaFKxRweavmQd91lBlw+at733oEAMDlM/P1
   TXfAUkxhwznOiEFsBJLo6wrViolu9Dp84Igg7kbVPI92gmg1PG+gHvbDk
   Q==;
X-CSE-ConnectionGUID: vPuFGDVNTY2Le2a5SAhsFw==
X-CSE-MsgGUID: 0JRClzCDQ0WE2YscJ6YoRg==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="155130894"
Received: from mail-westusazon11010046.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:42:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mZvZUfl94hQ1o2VzJtvZX1Cg1GSrfkLMNSxxZvGWY/Ag0k/eJ1ixeeAwDGkUlwP3nUKXDqNxgN5t7pjOQCN65icT9e3sXcr+EXIIeSgrt4ZHgKblY5/KRDUnlCdoCqW4nUKjHq0pJfOtGtg49YnLdiU3Fcei40HRPyR0pmV2BJ9V4x84AQbTrZ49FTfCl1VZIiE8i/ed7Hj5RNcV07jQyY3bsbOK23d1eh7uEEtWsG13NlRZrJVv2uR+OhPlWPzFXa2HzG+1PjC9fX2JrrmW6Y7XYNkm8k3ZZPryIWnX/HxHBBt+7qGnZjcxPLTRjX9E/okmu6kTKpp4TtSm8u1PgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=R4zyxyEe2fk7Q428v3cfpPAU8V0DC1833I7SbDPji6zJz2l73tYNLaFnIUSleISLf1NZjEwAc9zB9foPAvg1FPexEj4rZkzcK8nozKR0RCwVjkN7MRsRPgqufwm3TFUDDIIdT2nOxmvh1+HuNPjjlTGUJ4G3EDTUx0s+n6yg3/i7xzW8AO30WXV+7a7nKlArhzXtddey6QVab0Y95i8DpphTV8li9Wbela73mCbkmUB0etom3rBgcIZMjZMqHJd++0eHWEeNiBmMboRlXfj8uB+BEfh0tWwj/PYYm74viYWxLiLehTvw3S9L20kBL43oBr9mL0mfBdGthtr5ajxukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=WBfvYyf7TZBIkcnsXPWxJlxxq2++xvl5gKIVuEeLeLHjmq3r0qYpN2P+HUqdfj54r6dItOvPzVLqu7PrMvQXc7pcgn0soHuf7UW/PAD2y4wiBqGpD6khgZv0nx2BPSWAjS3Xno4Js5hY6FCWB+KfJIIV0bg3H/84srFH7SJhA+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7873.namprd04.prod.outlook.com (2603:10b6:303:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:42:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:42:04 +0000
Message-ID: <661ea5d0-21ab-4453-9955-2b7e21cde8b8@wdc.com>
Date: Mon, 7 Sep 2026 17:41:51 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 31/40] scsi: scsi_debug: use 16-bits defined sense
 codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-32-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-32-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7873:EE_
X-MS-Office365-Filtering-Correlation-Id: 493a3124-71ed-40d3-a2eb-08df0cf690c1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FoHzQ6AkWKN6HfjYH9FAeHDTzXE1QWU3BCU3qdvAfaCaqjU8TCtY7WtZd4HX+wkINDwGrcoueT/ZsovfOvKgjVQPtx5TZgQZHntaa6svbLkdpVDi4J3e4gDzj01+fUB8FZnAhjYj0PQOHDAmGjx/mJdysD1tDsDzjdBNghvV0mGum5Ul1oq/I0a7gCtS4mPfPmtyWJJBGmwuOTh+nu2NmdIzcapLnfCXP+mpMDJXX+e6Jb6jNqq95Z1CHI/Fki1gPxAD0Cw+A9v3VZ8oDwBYKwhRpJ6sbZd9QkZBTV083CfyfNKjUOsjulSdXS1QF7nX8ApVzRhcrwGi+J+hD3OZR2q+0wQZS2BvtI7MSxUKm0aLxHgy+9v9BwjsEnj95lK7K+3w9aW0OQsrOxSygerzAEDZ5hTMwIguy2wVmRR/LkDGzX/I8cKsnkLS+AmjUXvV03T9g7Wz6Hw6Ne0/UdyuF8U/zNKd5Zsww335rj7bV0347jKPHuGBNteKLOm1fo7Asx7XqymUvUqnGgkXd5T0r7xBehzve6c6IW92l+pZy60qaXYGJ5ZtU2dEKFTjEpkED8KYZOEPuVDiXAPmpTZk7aGFJLs3IZ8M1gfBpUXuR3h23lsWqvndzcqEGpIt6K+UZl0pV2Nlhy3CzwM20gIp+b3BB9OaORPvo612Cb5esiJ7Ighj5a5UopB9QVJHfbbn3BjmEi0jUaRuJiC1OooVWw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ck1tR2JxeitSSzZ3a3c2b1RyRlZSOVhIMlphZWw4VjlLSnlGbUhray9LQnc0?=
 =?utf-8?B?a21xSHk5WlgwbEdaVEpNa2JWOWwzRzQwdEFFdWU0S1hGMWtIekpMamVQRVdV?=
 =?utf-8?B?YXcvM3cvNG5QdURhRXljSG5QOWsyT1FYUE01U1cxN0ZDZk1wL016ZFY3eGdG?=
 =?utf-8?B?SUtUUGJXeTlPSUxncUxsQTRoSmpMRmhtekk5eDAwUFRhRFNFTzAzWWlXMnVu?=
 =?utf-8?B?Vk1PVGFmQzVGa2g1QlMxTHZkNWFBY0JROW50UjJ2WTlKNVB6MzlrdUFhdkl4?=
 =?utf-8?B?S3JNa3kvUkpNd21pWjA1NHBKT0Q4ZFZlKzlZeGxNdXdJWXB1MmZqQ2ZTbDB5?=
 =?utf-8?B?QVUwdWRhUzhZTHFKcWpuSmhSbnJmVHZDaFUrcTNHQUQwRXU5b1FtRzZsVWtE?=
 =?utf-8?B?eHpPRkJxOGc3WjJkdWYwcHU2TkJDU0U3YTQxMGFSWDYrWFNHWkR3NTFKdnRQ?=
 =?utf-8?B?UjFuczJ6b01jQVJzeUV0dXM1ZXAzWUdPdWVDR1Y1KzdCVVQzTWk4QlJTQW1h?=
 =?utf-8?B?MGlhZE1obUw1czlnOS9xNVllVFUwaVRmZUVtM0xjNERPQmJ1V0s2cU5BR1cw?=
 =?utf-8?B?ekJXT3lRODVhSnhjT1dpR0twU2xTZ2RhSzBTZU1sMTh4emUwTkV6RUk4SzZI?=
 =?utf-8?B?c1grMU5jZDFHWmxIbGIwdHhldFlCc1J1R2llNTU3Z3VSQ1Y4Rlc5WFFSMitU?=
 =?utf-8?B?ZUladmNGVW5lN1NnbmNqK3dLTUtPbmxIZnRTb2pSZVBOZ3k1UUZIbXVUN2Nz?=
 =?utf-8?B?WUV2SW85VmVkb3NvS1B1UWJpNWhyTzFWMmdlN1QrZEM0UVpoYW8ydTZ1K0Uv?=
 =?utf-8?B?UCtjZkE5VDJ2M25VMEo1TnNSdTNVZlpOMUx6SEFBbDVNZ2lPaGVzOFhVQjRU?=
 =?utf-8?B?TU5GYVMxVXM1d2VublNCS1J6ekFiMTl6STBITkN2d0hEQkR5Y1lIQ1lqNlNU?=
 =?utf-8?B?MGZYekZ1WnBmY2x5ckd2ajZyVjZkc0d4alp0MEhHNml5cUFzMWgxZWMrVFVl?=
 =?utf-8?B?UUJxWEZaV0I0dWRMbzVYam1mZjRIRlNmekp0ampMa2VCeUhqUjd2YzVLRktT?=
 =?utf-8?B?Q3hTNTIyMkJnVHNEUlRLTk9ObW16Smk5cnBjcU5ETkZmRDNxWlREZ0lSYkJ0?=
 =?utf-8?B?Rm5mVmhZTnJWVE5iT3dJNGJjSXM3cG9CSGhrR3NsTkJYRjNUVm5UWVM3dDFR?=
 =?utf-8?B?bitPUlFzaFllNFEvcGdZdHQ0Sjl6M2Q0MHNsMFNnODU0UnVUbjNhUUN6cUJo?=
 =?utf-8?B?Z2UxeUJvR0N5RU9YMmhHRC9uaC9tMGhoNjdwZFVCK3kvOEphVXpKcG1LcHg5?=
 =?utf-8?B?ZnFKY0MwNWF3VWM5VVJMRTh3eUtGZ25PcnBVTUdyaEF5WkxCcGVaRGlaYnlO?=
 =?utf-8?B?T0xuOURLa2g1Nk81TExHVE53eG1OMUR4TWlpWEg4MUp0QUV3RjdlN21WbVJH?=
 =?utf-8?B?TlFla1N4WGFvTzAvSGs3N0NvaVZ5N0xjTHFRZ3hLSEN2VjU1Y28vbXk4TXgr?=
 =?utf-8?B?ZjRqc093K1M2b284b1cwcWtVbWVOVXJidFVkUUJPR0ZvSU1RaE13VHU5c2RQ?=
 =?utf-8?B?N21VSzUxYTF2TmpEY1NWd3ZSYlY5KzYxKzhZZlZpUnNaM3c1RldPNFJQdWdz?=
 =?utf-8?B?WWsxcjd0eW5KMXNKdCt0MzZFUHZUZ1VMRUwvTEtWajJtdHlDSlJLRGI5QmR6?=
 =?utf-8?B?ZGhRSDdNdzZwTVFrd2F6SHozQW9SZzdXdkkxZFFOamRwV2pRc0h2eHZnRTJn?=
 =?utf-8?B?RkhmQ21namNaL0dWRE5vdkZTV3ZaZHRZQkpzWnZnRmtzdjVWNndMOERpU0pL?=
 =?utf-8?B?MFZ2bkhTdVovL1JxUTVkaCtEa2h3VEgwZ2M3NVRKdzBjaEZHaTVzRVZnWmRM?=
 =?utf-8?B?UUVaRVZyVy8zZjJHTGZzVmVuRW5Zd01ZWkZ4TzhIeEFTWVVSRlZubCtjZTAx?=
 =?utf-8?B?UnFNVXArZnRqSGFhUVJMQ3hoQnhKejFBWDhBMXFOenZOQ3FsWmh1Q0NRemZ2?=
 =?utf-8?B?TGZIOCtwWVAzUVVwUFpOblIwRGY5aG5BUGExTmowSGdFOTAvbWh3eFdiRm9Q?=
 =?utf-8?B?SGVvdW1uVmVHQk5xYUpVZlhGOTlkTVB0WkdZMXpNeDlhRmJWRnJ4OHowYUhQ?=
 =?utf-8?B?WkdKbG91NWZEenNha0pGeWl6amNtVm5uaFUzTTl5Z2tmNjkwWHptVXJNV1lz?=
 =?utf-8?B?VDJCUDBlQ05DWmNIYWJXZk1VcUM2N2dyaWU4bVI2MjBNNTlDeGlPclFPMXdW?=
 =?utf-8?B?YWNiN0lvRUN3enRQSVdlRGZRMzZXMjRuUXRJQmhMZmlHZ0E5NTFXcEg1KzFt?=
 =?utf-8?B?NlI1NmRrUlNxcjVyR3VUaGRmcm4rVjc3M1JxcW1mMHgwK3FWUkV2VjdSbHF2?=
 =?utf-8?Q?szvWT53M+Stdh2xk=3D?=
X-Exchange-RoutingPolicyChecked:
	4Cd9qcBVwVHJZh4ZHim9hUnvIsd9Xf4TdjBgCqvdwbdkLtd7Jgj4Kk+k4YUwRPx2diutl4mXa52dL5nOsmXblUnlmLk9Ol+zhulkkqOYjxOylFPZW6B3g4wL75iDwFeeOA6XwvkZpyKzvWCSGXaONw0b0nkKllg5k5JhAOY1u/8mG4QupS9hJyuL1mW/mXYKDX2p8c3wHpg/gSDhge2tNlucuA2kLQ59t6l5tu9gE1RUI+luc0xBOno063pAGzvvqODmwuoaJao3Y4NOiqIg2PAe0MiGnEq1ya/BEbTduIFMcBvlASSqK+DrQPW3FDzBJxYO3MA5Q57ZcTfGXr27Qw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	he0kq8TF/XXweFX4l/os1eGapj5iYjMvJFvM3nkxv5b4AXewoZogPCLPdypwz8rnY8nOC0VHfR5FHxJx3+s45C0niBRkfp4Z69jru8vJIhrX85KOMljiHNwVOQB4OeLut3Rc46f0cqGDX+WSOfaIyp41+Cyuks1IoDh8sBNuQ5Pn6/of1vWbo/x1b18F1w4Gxca3G53B4G40hsKKDyRhzn0bkPaouU05057JBmMrr8HO3tK1ZZ9KfPNeEuoQziYhG5Gu7kraLxHjddbqpqtmBUCpiHJbYqfGSkCkhU9hH5NHbd4ZBNi5wjDLHYvmZNo22uFvKB/i8t4NRkTIwAywvlfywX6pZxvBH3jbog0Tp1JtXndFDhSpAdCxQCms8GOgkVIOStolhVqfXtU5JqXumWIAmLgRs85vQcZReTRZF5x/QxxZJIempoTIclaYsMGNaw2jeTGayM4DbLHz+CIuCNFXkE4sRrYw0vKyqWiA/ksRKCQcfhFII9v7mkymt50ehm9yH3ALMHUM9w7kLchnDKYhrIJB35Afc9bg2TtB3bhx8F3w/zfkK8wzzgVaJwWmvqe5oxmNQbuKpy+e/FtEKIh6smNwb3ErngK1EkD7zY0djd402DXP94OhmqL2ptuf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 493a3124-71ed-40d3-a2eb-08df0cf690c1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:42:04.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFjxlMW8g6UOvXyj4Vzti6NcNMtzBddO1ILl6yzSokEbH6bl3YJ/2USS9FRY7EbmcT9i8thvMG8UrhWjVUwtUbWiSK/gQFQSyAegSwAaxKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7873

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


