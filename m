Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020143.outbound.protection.outlook.com [52.101.195.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA23B30E82B;
	Thu, 19 Jun 2025 19:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.143
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750361727; cv=fail; b=vAekqKwTCM0fK1f+4XlttQqfRgutjYY13oqAn8tPLzO56Qs7UxfI1fppBnLsuuXmHX1hMWY5h5AUzJUweq1YPQuWoUt8A03/qaUFIpgigDvmoopSqhKJr1hYfplLzr9Jw4OZe66ejwXyO74yCxSamqd8vZHuDOvjW/Ui2Yx2Wjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750361727; c=relaxed/simple;
	bh=2m6ietf5f4oWqSn64lv0cGi+qUrVSWLeGM8FsWcbQBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o5pOMVwSjWPzy70HZzDEVHL94ALUzxVx0ZFY0yBN5mF622bjzIGZlfWT6uZMh/fN0tiLiZ6GtGBCnk6xyaC6FXRcR0lq48u2GRvKRGkwLzrX6MCVchUJuyQ0voqJ0mjO2Z/MIBa2MxdPyEtIa4bcmdpNuo3U7HjHvtRV3BhXC0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFeEsHIBydWnpK3xIfVw+KK3zqnin2JVkmEz1Y8iHs3124Ndm6P+sDFMxS/gyoy4M4pwDgokzAqrnsX269itecwUuJqb7O/kjgsHdABvnBvtZAXse0RuQ9p1P+HCoOJ8/XYJWXKePjMYgHiL3Bx+8XjXj+UzhvENRjpPTYGQKz23Ki1+prs2UyDaY2yTylILsQoZGVilMD853OLVSRQ6JWaNKBlvn5WGne1UPq0AOOeL8nhMPau/4EqmkGlWtDuwmJO60d4M2nJLSzvXKQTW1Q3upxApnIjOTw+pghn3r73EV31uXX230jYaaS00nt0MX9QHC1v5rV5WgOwYN57xnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPnX1dXv867Qr5QLLPxtwBptQl+HUPX+vcoCtiTsZy4=;
 b=G7c5CQbi77U0OKpMy5TbDJNQYxvJY3VpVR3w0vvsBpzzMPDX/sMAM4h2OPSaMpM583Fc+tTa8l7L2SnY5w739L+k69EagHv++isqIpKjuBZC5PRe4ZzgyDuInikgL4tLgYUsKL/N2DoJc5kxUPpJzbchInHzgRwNlrjrZ/iEXdI17RKBvsMhBYnFVKqoY7Bt9naGmTKtDzldVvIlBepX1Zm7pVJ/4NOfWHK21V7/oAqGlDhmmJhtU4Mnxvx+pjGDQAVHz2LqD0wVu0QSWHnW3qtTuTrNPp/quQQUG2wj5G1lX0m/oHpx7fXL5/meroA/mmJJrpn8Iwfktayje76atQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO9P123MB7732.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3e9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Thu, 19 Jun
 2025 19:35:22 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%6]) with mapi id 15.20.8857.022; Thu, 19 Jun 2025
 19:35:21 +0000
Date: Thu, 19 Jun 2025 15:35:14 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "Sean A." <sean@ashe.io>, 
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, 
	"sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
Message-ID: <ntxbqgnwvjdxggl5hno7eqae6ccpzwoyule3gwo4pnb53h4jiy@qfvkb3ocdeef>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
 <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
X-ClientProxiedBy: MN2PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:208:d4::32) To LO3P123MB3531.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:be::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO9P123MB7732:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c55a92-4336-4f5b-73d8-08ddaf686bec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUEvTzdvL0ZEL1N0cGJsQ3o2WnVJU2lxSkJzYi9hVzJKRFBjQzhsV0RhaGVm?=
 =?utf-8?B?NjI0SnJ3ZkJiL0Qxa3R1MHZPOW5rN1VTUlQ2VTNINzdVUEJVUWR3a0RVenht?=
 =?utf-8?B?Ykc3aTNvYnljVjRDbEFOZTVSZThiU3M1dWdsVlo2TzJ3TVNDNjJqWGZobVVE?=
 =?utf-8?B?Sk5NUlVGMWc1bTkwQkovcU8yd1Avcjc2cjNFeHpVb1dLb1hhb0JzUldHTW1q?=
 =?utf-8?B?U09RSmxQTm1ibTUxa01kK01qQk1sU0VUaytydUNaVHBJWVg4b3RkUDlJSmM2?=
 =?utf-8?B?THhYMnVpVFc1UldBQTBmVFEwYndjTi9HWmxGbkpNK3pNdlVPZnBhQ2V3LzlQ?=
 =?utf-8?B?ZUErREc3d2syQ0J6aEJZT0VUS1UxNkJGUDlJOXhhK1Y1V3FGR1hBb1FIbUxm?=
 =?utf-8?B?cjErREM3UnpxN3I3SFhWOU15TTR1eGcyaFZKMnhpcGlpUnZZakpZalpCU3Ra?=
 =?utf-8?B?T3ZxSE1PTmg1cVBEU3g2NW1QQ0k3Z2tVTVJOTFQyRWpzQThvSit5WU8reGZ2?=
 =?utf-8?B?S0N5ejhQWFVXVVZFVld3RmRONEdoMWpFSEJqcVVLUENOUVZaeUZ1NmxBeHF6?=
 =?utf-8?B?TWR2RU40WGJxMlc2YVU5NjZZMmE1T2pua2tlaWNzb2lRRm43eVZxRFdHbHNP?=
 =?utf-8?B?dW8xd2sxNGIxeCtlTTFBVU9zVDdkb280bW4zZis2UHRvU05jYlQ3WjRvNk5D?=
 =?utf-8?B?dWhnSWdzZU4zaEZ2ZHBiYklMZ3g5aGJwYkk2MG9IaXRFUlFaOWVZMWg4N2Va?=
 =?utf-8?B?cE9UbDhaUnd6SytSSW02Z1NhUk1UeEEvSEIrREdtK3Fkdm0zL0pVcHlnN2I3?=
 =?utf-8?B?NEhFbnZlbUlpU2tpTU9scWlqMk0rVXRxVEJ2c2JqanFnQ21SWFV3TTFGTWFj?=
 =?utf-8?B?REltcE9iNXlKbENOR29Fc204cGE1bW41U0ZiZmRrclFjenFvcm8vU2dieEdu?=
 =?utf-8?B?S2RjaklxQlZwUk56R3krZVdTSk5SNUdoZFY0cG9BMzYxNnI1RWc3d0F5WDU5?=
 =?utf-8?B?L1RHaUlUNlFJbEFZd2pMT0p0cWlqRVFlYktRMWR6eGsxcXF3Z3N3c2kvTlg4?=
 =?utf-8?B?VnVTOTdPeElJNEVGYWNBbVR6UVp3dXZHSUwzekVIYkhMZVg0N3NYRTFqb2Rn?=
 =?utf-8?B?Z1BCS0NRcGRwbjZMYkd4MWt4L0NNNVZ3V09pSDhvaWgyalRESk85aHFqOThS?=
 =?utf-8?B?MmJNRDBaeko2Q09oRG03UEw0VUJWSE55TlBIUUZ4YUNjYWdYKzdGemZia0xq?=
 =?utf-8?B?SDdEdnFXV1VQY2doRkNlM2F4M3Z6Vk40UitQQ2M4a3dTWGR2Tnltd2IrblhL?=
 =?utf-8?B?QUZ4bk9NN1NGUy9qVm0zcEoyMkhqeERueGhxS2tsT1cvYzZvOW5SV2tXdFhI?=
 =?utf-8?B?RlR5K2JxZVpmZzFJUDQ1ZCtZeWhKdzFQZ2E3QVNkdUwwMi9aT1NybFppSmNY?=
 =?utf-8?B?d2xkc2E3VUdoNno2L3E4RmljUXpEOFhENnJKcUpoWllMWXg3YmFZeldsb2tq?=
 =?utf-8?B?RWVLYXF0WXBHN3Jvc3owTUVobU9UampWUXBZaG9wQW9Zb1ZwaGRxYlBvc3FL?=
 =?utf-8?B?aUdoNHdobXh2SVc5RzB5UjFEWU1WdWx6WUZrKzJDaGY2SU5EZXFRWlZBZVht?=
 =?utf-8?B?aDAxWkdRVCt0Z0dNWk5oTnFSM3kzdEZpMWZObWxhYm1Wc0pGNzE3Um1VYTJN?=
 =?utf-8?B?eVJyZkpTa0hoaGN0WmFFTEp6WVNtN2pvbFlPd3djNW9SbEcveGE4OGR4TERI?=
 =?utf-8?B?UUVXZWNTeENhMkZlREtRTTl2OW5SQWxMb1R6a2ovcmF0U0lzZS9hd2ZFcVNS?=
 =?utf-8?B?UWplOTI5UmFlVCtwTHZSQUpjczc3VmpKbUlrMHZ1QmxUa0h5THlOVG9XMHBS?=
 =?utf-8?B?ZUI5QUFqZSt1QmYreGkzSnR6WWRYUmd3bFAzQ1RzUDQ4RW80UnFuTDE4OGRk?=
 =?utf-8?Q?uAt5zXo1QEI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFJqaGNRZGxTRDM1TytqTitpMUJnZ0ZZZVZWb0VZVVZWOWtCYkhjTkdld3gr?=
 =?utf-8?B?d3l4Z3Buc25NRHlTQjBsTXNjejVHTXFBalZQL0VlNDJGVkFWeVVWbEdteDBq?=
 =?utf-8?B?eVdLU1NEWGFhaTFydzBlN212Z2NVRkhCT0prSmZaOGFRc2I2SzRrWjViSFRU?=
 =?utf-8?B?VkkwL2puUjdHUnBxTnNSS1BSaFJzTnVxK0RQWU50Z2t3d1A3V3dCWUgwUkN4?=
 =?utf-8?B?UVo2WmNiVmpuUmozTk53dlBiNEZNM1BLTUxJUnhuU0FIQTRWVUFyVlBJcjlT?=
 =?utf-8?B?YkhnelF3U1VWcVFBV3hHQSt6blgzVGoyWjA1YUdMM0ZyaDJvNzZGQlFtQnRN?=
 =?utf-8?B?emdDNDdqb04xdDZtalFtakRxZkNlaXBOT3N0VVJBNzZuSHE1Nlh2R0ZSekYz?=
 =?utf-8?B?RmxCNldPZS95amlkRTNJWkNtY3FaejVUeExwNU5CZ1BueTR0ZUZFSGNBbEtB?=
 =?utf-8?B?ek5GSjZ2TGt4dTdKcjNOV3Z0bGhDV0pXc09NeXBPS2RMNllXZnpPOVVyKzcz?=
 =?utf-8?B?Y3poUnNJdWpUQy9oQXZ2WXVsbnJjUUxnand5WGVlUE01ZUJCM0gzWjJ2bGlO?=
 =?utf-8?B?SGR5VWVYb01UVWdXR1R6TXcrY0FEVm9aQ25PazI1b2RIT01PZCt0SVNZOXQ0?=
 =?utf-8?B?eGhNeUFzN0JZQXZTN2NscndjWUp5UjdNVVZ3eUxGSTBBY0w4Q1lucjlWZEtR?=
 =?utf-8?B?amxlRWZucjhuc1V2V3VvUHJuNG0vTEdvQnNGdW9UQW5VUDlTZmhhUENxaDY1?=
 =?utf-8?B?ZzBCM0hCRDE1S0kxRUxRdnBnWEowcmRLdmF5Mys0WkVtRFgrazZjTHQ1dFA0?=
 =?utf-8?B?Vkd1aVVRS2pwMEhUT0lpT3J5c2hDM1dXMGVHTmNzb1JjNzJYamhWTHpJU3R6?=
 =?utf-8?B?bXJYbXhzT25LSE9LOEdTTnhPeWd2WGFRdThhR2hEaWloamY5VC81cFB3NUJn?=
 =?utf-8?B?V1pSWCtJU1RLaWhCT2k0Y0hEME1tSVZnUnozeVhXN1RkOVZMWjRLcmdqb21y?=
 =?utf-8?B?ZzBLOGRzajlyaUczTG9JRlNZRmNBZ2ZnanBVWjJ5OEFXTFJWUVdRd29iY0NO?=
 =?utf-8?B?N2ZpMmNySXhQMlNsMDM3ZTBiRHJ5MTZtcjNjcjZ0aWFrTUgwdW45dDRZVitE?=
 =?utf-8?B?ekVaTUZIUy9VQlpsZXV5U0tQVUZDdWExR0R6dUxpbnJoN2k5WnFJeHlhQTU5?=
 =?utf-8?B?OUpKWWY2aVg1UnhFbmVYVDZKRGNnVkM4dkV5YkxUc3RvT3gweUYwYWxzV2h6?=
 =?utf-8?B?RkNrNHVpbm0va014T2ZVb2l0U2pyaHNCY00wSGIrejBvckovSFRCZmdTWFJY?=
 =?utf-8?B?UkJIRktGRkxxbXNMdnRFL2VLYVBPU1NPYWxkaTB5WTdJbXBvWEZ6ZGRHcFM4?=
 =?utf-8?B?RWVaVGxxU3JYaHJyM1VIU3pUTGhRdmQvU3l4T1FCVzg3bnF4bndzU0tDSzh2?=
 =?utf-8?B?UE5PbFFOdzNlV05LcjF0c1hsVnZTa3ZVZ1JSMlFnWXQ2Q09BZmYvS2FvRGNM?=
 =?utf-8?B?c3VPMFQwcnRVcjd0ZFNZenhBRDhNMWVta0d0NDNzdVlLSStTcE4vMEpVNnp5?=
 =?utf-8?B?eHNNUUFYa2tia1JHN3NySC9COUo5YTRmOWxyTGFFeU5Tbll4eklONktVLys3?=
 =?utf-8?B?UlluMzY1TS9tT0g3NzQwbWwraDMvMDg2SXcyMW9KbmlFVEdxdGJTTU50SUZT?=
 =?utf-8?B?OUIzSWRrK24wamR3QjA5OVhlTmt2WmQrWGJ0SEF4ai91ek44UUticUtYL1VM?=
 =?utf-8?B?TWtBbVE2V0ZFRjlqN0Q0YWo4REk2QUwxQWszMnQyV0plaUxNenVod21FMzZm?=
 =?utf-8?B?d3BWWjJPOW1nYkRXNDNyRzBMT0pZeUJhc0IvRzY2bWxWNW4rU3BRUUM3cDAr?=
 =?utf-8?B?L0V1OGFqcHYxUW9FaW5waTB5YVVnVVRVaFJEYnYwQ3p3N1V6MnF3d21abFFJ?=
 =?utf-8?B?ZSs2YXJQSTcvaFB5cDZ5L1NCNWdvbjdZeFNsc1JFcGppZVlWTThldFFkTXVS?=
 =?utf-8?B?elNjaHRZSEZmd28wdEdiZlRDb3R0UmFoZFpMU2dzeEYyTEVTQXNYRW96UXlD?=
 =?utf-8?B?TEJPTHFGUzIrTHIvQXZWVm5YQXJpaHp4Wk5wdms5L1ZBbzlBc2xNOTZJSUJS?=
 =?utf-8?Q?fc/iXEjdxIrIEkF4ZPoVPuhy1?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c55a92-4336-4f5b-73d8-08ddaf686bec
X-MS-Exchange-CrossTenant-AuthSource: LO3P123MB3531.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 19:35:21.7039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXknsP9ysJk3sA0BaT1bdyvuID+V2K35GGflFK9ktDe3O41RemlXQdI5BGPNZWhjS56lOA9Ct9x+CLzmJS6wFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO9P123MB7732

On Wed, Jun 18, 2025 at 07:49:16AM +0100, John Garry wrote:
> BTW, if you use taskset to set the affinity of a process and ensure that
> /sys/block/xxx/queue/rq_affinity is set so that we complete on same CPU as
> submitted, then I thought that this would ensure that interrupts are not
> bothering other CPUs.

Hi John,

I'm trying to understand this better. If I'm not mistaken, modifying
/sys/block/[device]/queue/rq_affinity impacts where requests are processed.
Could you clarify how this would prevent an IRQ from being delivered to an
isolated CPU?

-- 
Aaron Tomlin
