Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C5A1DB54C;
	Tue,  8 Jul 2025 01:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751937968; cv=fail; b=t73mI4zh6Rw2C/a6ZMpUzvK53xkAvv20SJUKWVpIpzUFGitmN9+qgdLAk7ra6lRs0+jzk4B26fPMlIlVVkKpwXtC4pGD8bzKBiVM/Uu23FAcRu3uOau8Uk04iKlnrY1S/Yi9QzAu6Bi+B/YfL3KzFk0HWo9kzrH+AQLydGGIxtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751937968; c=relaxed/simple;
	bh=VG+fNsX1lYXPvcba2j8c5bHFDWEKXq16dVy8f5qAG48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rLq/oucQEvKwOQGsobC/8w0rKVAA+QzA90gNMvo8TIkON3njrXW3Yqooy600+kAkpVfo7BuSPCjkfJ2YPnUnofglDX6BwI7d8RVVdbWReRcgctHEo23/KtsuYrVkS8YlVAHsDAaaXaRvG/d8WgI3iaR8tpbXC/8RdRTf49pXz0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ulbFArLzy7EoCfXKoaUuf96bGSyyeRSbHJFJ7zsr2fRsgMudV2d1dtILDWPC8oxwenBp6grYeUdafgFoR6mFgEBau0h2M9ID6UdI4GleJhYJLj6LBFdCxJqtgxsicdU5QoP99ZasX5pwJTKr4CY7qGgRddN4/OswpaUVLdWm2Uu0GY5A2vjgUzD9M/RTLnoFo9zCLhX/K03G76FEqXg9YbOiBFqZzM+sPESuDXmiOB0qmqe0EKYHuzlNH130hha1DDI9uAB/7UVhUccijjBgA4/VtKcWmQd97sCq9BkvT32X6Dl2FX8P0DGDMTp6oYe9X83qRg0xFTzjojRKz14rUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qE7QYDgx02tEuQ8jaUUZ82IE382xXI8qW3UutF7rJtQ=;
 b=jZia+yFtHZ/3WapVFsPTjxuV6OJecHEObv+PGzINSZyQz2z5jdw1NeIwenQBlr9hUvN5pwDZgqgn3OcGQCZy/oTtohzzWF0LIvh6U48eSMaQkvvnJ+0FKtCLdbVT0FN1v0+OYia06Mjij4yqSqQUXFYBd6W1BXTeFYQxopqna84V//ztnszjkNhXQqKi79gX3aPHQD9TlTfCI9HR13strVBrBnsr68NWzDnRJ2v9f3Pj1XFXIwL7q10SH5rZl1f+TJ5c7HfK7JQSMmmSpb2y/V2OiDFm8gTc56KUOIR7iBvQUrEZreRJ3/zadQRxAVMZAwF8EVoH63uIoF83HjbIBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB7362.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:220::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 8 Jul
 2025 01:26:04 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%4]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 01:26:04 +0000
Date: Mon, 7 Jul 2025 21:26:00 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin <costa.shul@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v7 07/10] isolation: Introduce io_queue isolcpus type
Message-ID: <riywz7hmdh3y6x22jlpspa65geuaz3uw6holcfvyoe2fvpusl5@n4t6gpig3j34>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-7-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250702-isolcpus-io-queues-v7-7-557aa7eacce4@kernel.org>
X-ClientProxiedBy: BN9PR03CA0286.namprd03.prod.outlook.com
 (2603:10b6:408:f5::21) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB7362:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf27524-10af-4d31-a64c-08ddbdbe680b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVViSEhGTHp4cWl5T3YzckhKUWlhV1JSMmNtMnNmSW5LM1cxL0RQN21WVEx3?=
 =?utf-8?B?SStTS3ZBSDVEY01MMm1wR0ZDZFZNeHhhd2Q4L1RXOTdzVlBPbWdSNW80ZE9P?=
 =?utf-8?B?V1VSdDg4SUR4LzE0aGVlT2V0aGY3OWw1STZSRXhwVDhWa3ZkbmZmU2hOZmNt?=
 =?utf-8?B?ZE9Tbm5UMFdvRlhBNGhHQ0ZPWno1YlFCdlZDV0FrVXcwYUNXeS9FR0dnclFQ?=
 =?utf-8?B?SzhiSjZjeDUxYkRYemsza1NvZGVHUkM3MGRUREpVeStGTVdrWWtrcW5RVEkv?=
 =?utf-8?B?V3ZDZ2V4MUlCbUhJZE9hYXp6UW5mdktnbHFpbzdjTEYySnZ3ekVlZUZFZVp0?=
 =?utf-8?B?bWpwejA1S2VvRGNMTjdWM2l5K3NSZ083WTR4NTgyL3VBYm5pSThTL1BEYU9Q?=
 =?utf-8?B?UFhreDhlNWwzay81eXBoZ1E5b09LclBlb001UUY1eHB0WmFFRkZFR0RuZDBJ?=
 =?utf-8?B?aFVGSVUxa3lqOVBHVGE3bVMvQXpZZ25SSFdPNFdROHJCTjBLWU5lWFF3T2dv?=
 =?utf-8?B?Z2MwdzZkVGRlWkxJTnM0ZTV4c0RnL29iclpHQnc0TS9uMkhvU09LYkpTMFVj?=
 =?utf-8?B?UWFrSjJBRmFUNDhubGdsWlJOSzR1cEdhOGhHWHA0ZHRVRWQ3THl3eWxkY3Jj?=
 =?utf-8?B?MnV6Um1zNHhYUlZ1eEl6amIxTXBKbXZscW5BZ25wSFc3TmZCWmU1elRaTlNy?=
 =?utf-8?B?Wmp6bGtMVVJCSHRpUjk0b05JMHprc1FFTWtYOTNHc2hEay9vM2pxMDNZNTVK?=
 =?utf-8?B?b2FBMWRxamo2WHRIS1JKcTlYU3JyclZiUXNoWDFtRWh5RzhFK1NRZCt6Q1pj?=
 =?utf-8?B?TThaZGxJcktNQkFKZEtyMTVQZlBCTlZxSE4vL0NpMThzdWRQaHoreFYvRkhZ?=
 =?utf-8?B?cE0vckJza0NmVHFJcVFoZVNCU09GUmlOQi9qOHRJYWpMeE92UWY0d1hLbFVS?=
 =?utf-8?B?Q2hMQWRBLzVGUEZuN1JZandXWUNYcjZ3c3R3WUFENkc1K0QxMW10K3lnc3M2?=
 =?utf-8?B?RmZvZFkrRTFrY3NrOWhOeGdVSWRHYmdYdjNWaWpnNWZDNnUyaTlxb2xsamlu?=
 =?utf-8?B?M1BZWi9saTZXMVczdldPQWhVNEJJWnp3aUFBYzcrM1ZRVGxUdUZpUFZGVVBZ?=
 =?utf-8?B?b1BWSjd1Tk5YM1k3WG5zaUdwN29HZmhFM0F3RGxjWmRKTW5hVW84cWcwY2V0?=
 =?utf-8?B?OUErQWtkSkVaN2drenlVbnMwVUFTa1J3aUFjVU1GT2pCcTgvbDBLWkcrU3JY?=
 =?utf-8?B?WERBcFQ3TytvR2NNQ1lqY1d5elArWThOVUx0Y3EyR0dvNDNEQVFTWnIxSHI1?=
 =?utf-8?B?WmF3UFF4b1V6bHZ5RFVTUGxINHJsRjltZEkvd3VkRUttVUtlN2NqdjlYTjR4?=
 =?utf-8?B?Z2ZEUWZzS3ZoOEtaQVE0czRVTXlDRnl2YWhnVi9XTEFVTi9lbzdaanZ3U1lI?=
 =?utf-8?B?TTA3Qk1ndUM5amwydSs2TE8ydlkyRnpsYjVvYmhkd0R0eGIyWSt6ZE5La2pz?=
 =?utf-8?B?M01weXY3QVd2cXdRNXd0bVFaZ2QrejBXcnozcXp5QXBQYklnNE1wbytjQThC?=
 =?utf-8?B?SUxRUTJ4ODl1WGUwQmZ3ckpxeVdrbnI3bGxWQ3BwMzhTZ21HdDN1ODVuVVI0?=
 =?utf-8?B?Qis5bUZKdjlUOERkWnhKWjZFWldUdTRQeFNOTURwMlZQWDh6U1JZQnBXdmNJ?=
 =?utf-8?B?ZmZVcWVSaTI2U0VaM3BGYVB1UDB3M0YvMXRYeDdtb2QzS0IwdjYwbXNBNElM?=
 =?utf-8?B?c3NmNFUwSGZEYlNTdmo5bTQzR1FjaDlvbCtaRzQwc2Z2cVdmbTZhNEtUclZY?=
 =?utf-8?B?K2RhRW5OdzhVbXIrTzlZUDE2Z3pIbXRRblhzRkhCdDE4clRjaDFic3Q2U05n?=
 =?utf-8?B?a0tnQlAxVkZBWHRSQU5QSnljSmM5UURDRFlsOVN4THpVdWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWF1Q05nZFR3SzNyczZ5MWd5aGNvanVNZU1SRFE5dGd4eUhyZGdyalV5YmFi?=
 =?utf-8?B?V2NsUXZUclpkOXF3QUxyQVdzZlpWR3pWTTE3YWUzUDk4dk1weUNyaXRXSnhz?=
 =?utf-8?B?Y1RrWU02Q2NoV3ZCUVFoVCtDVS8zSTJVYmN5SzZkRGtEVnErS3BnaXoyT3hV?=
 =?utf-8?B?VnpyZnZMN0lmVldmSVlMTVY1aVlGVDZpMFh2MVZ0YU9ka3ByU0cwTFdhR2cz?=
 =?utf-8?B?SmJMMVVLOVNmOXc3eDdUaWE0bGZhcE9DRlE4MExIUXQxbkp5RWhGSVRPZUYz?=
 =?utf-8?B?OFdFaDJ3cnlPTnRjQ1ltK0VmSDcrM25XalVuSVZ0OFVmZklMcERFbHNTeEln?=
 =?utf-8?B?NzV6emZxNS9FbCsyYW0yeFZUaWpwZTZlWXpZL1M0OGhXNWlBUExOa2tIcE9W?=
 =?utf-8?B?dDRUZnhlRSs1Y2UvbHQ1RWdwVjFPdTdINGdjVksyOUVLNVppUlZkdTI2OXJM?=
 =?utf-8?B?bHl5UmNhTzZsL25nTzY0NmU1bkQxcHVIVzVTQ2RXSWtZMXJOc2Z0SGtCOHpC?=
 =?utf-8?B?QzZOUlhRaXplYjFTWnRSejhjektaN2FPWDVtUDMzZ0hMN0k2eHM4NEhhczM0?=
 =?utf-8?B?VFU0MGlDWExCUU9hK2U2aGo4T09ET2RNRVpqaFQxKzBsRGo2RGlOSnR6UWRv?=
 =?utf-8?B?dy9DN1Uybm9BZGpzWXZIend0UkQrZDhMVDd3VGcvZm9XN1RiSU5MU1pUMkVh?=
 =?utf-8?B?RTg5WGtpc3JIeGI0Ykp0akpPRmc1VGNoRjBrMG8yWXRRODF5V3FkNjliYWZK?=
 =?utf-8?B?ZWQzd1h2cW80UGpLYkxKUDdaa2R2ZlpQUkRnTE9DMU14MjQyNXpHRThvSnpy?=
 =?utf-8?B?S0lmS2RFMFh0Q3MyYS9lZWxscWdVQ2tJNXZ0YXY1MGlwTTVyMXBGYmVHVzA1?=
 =?utf-8?B?cy9BeFIwWE9ZQnZ4aWpXSllxazFvc2w0ajhZRmNQZzFMd1U4ZE13c09IekhT?=
 =?utf-8?B?Yy9CUFJNZFB4TTExbFhzd2VxUWFnbkZBTzMySk1SS1RiNnR3cWhNYmtnVFdh?=
 =?utf-8?B?Vy8zclRsZmZnVnYrc09oWEtjczFXVUx1aHpYZGNmU2pIZ2hWU1RpWDJQOUMx?=
 =?utf-8?B?d1RLRGZMOStYTkpxV2JobHJLN2lBN2ZRTXZYMkZsbnVxZFJMWGFYUW11Vlpo?=
 =?utf-8?B?cTNOM1Q3bEk5TkJTSGN3K05oWElhV3htOFoyZ25kYkw4Z0dFRDBwL1ZSa3BI?=
 =?utf-8?B?RWsxanhxZ3RmaWZtVktPbjUwOU9zdXlVOEFXbWZBalNQcGp3bHB6dmdraUhT?=
 =?utf-8?B?NEFvdXo1ZFhPWDdkbnlITGdBOUcvMnV3Rnlic1VzZnJyV2JueGVXZnZaWDBm?=
 =?utf-8?B?MmZUaS91MkYwL25hMGsvNmFSY1F6bFd3aHBtMU9FT3hZYXI0Z2pmeUQyZU9T?=
 =?utf-8?B?NnBrZ1B1MXprUEk4bTJpNU1xNTBmT0dnbHBVNHlBemVrZ1JPdjN4b1B5anRO?=
 =?utf-8?B?TC95a01wYzU2dFBTQ3pVMEw1T0V0dDZYSnJGajZ4UEszaU5MVEErOXdDWXhn?=
 =?utf-8?B?MHdFRE5oeHg3SC9oTHFEd0hzeG0zc3QyN3c5MGVYSEQ4SzRxSTBBYjdXelRi?=
 =?utf-8?B?UFNZZUR6bjhybEpMOGZ4TDNwNW9sTmViUEVkWFc5aDVWV0c5RWx1elRja2NT?=
 =?utf-8?B?cHZxbmZ6eUgrY0FTQ25rcE9HT0o0aWFUZ0p0MHU0bCtHUzJRMHY5K0o4U3Nl?=
 =?utf-8?B?Q09BV1hydHhNU09LNXVrTmhvb3ViZldpK01VRTJ1V2ZneU9NbktjRkd5TTVv?=
 =?utf-8?B?SlY2MnVhMnk0dkRiTFdwK3JXT2lhZE44RDUzMEQrMVVXdjRTaHhzYzNYYTEw?=
 =?utf-8?B?TEtZVXNQWWtlMnp0YVhpaE8wNmlOK04vWURiYWtyRmFoQ3MxdzIrMkZnV3Nh?=
 =?utf-8?B?WllSSkt0VVA5V1VOUzFwT2dkUGxpYk1XQ1JZOUhFOU1iSUhuTWRSQk8zZ2Fy?=
 =?utf-8?B?WmpXM3owM1VwaUpzcm5xMDZsWVNHZGZ4RW13WVR5NS9sMHF2SVZhV0hDMnA3?=
 =?utf-8?B?c0lIYzM1T3R4ejlBdzVNVTBPK1FJYi9XMlVGQ0pZbmJIaFJiZ2NETWpka1Q4?=
 =?utf-8?B?T2luU3ZJRUpseW9RQlNCekdRZEpzMm1wMTF5L211OXRVTnluT01Pb0dWOEFn?=
 =?utf-8?Q?4S33UPGKoLhk0S9TjzuNmx45z?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf27524-10af-4d31-a64c-08ddbdbe680b
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 01:26:04.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zTYsknU2cNnm46DPUgpl02+qKOsyollaowAc+9kxdLi/Hi7D45+Ytmm/4nYHvnmHaIVbPFzXHQzeyDOBVYoRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB7362

On Wed, Jul 02, 2025 at 06:33:57PM +0200, Daniel Wagner wrote:
> Multiqueue drivers spread I/O queues across all CPUs for optimal
> performance. However, these drivers are not aware of CPU isolation
> requirements and will distribute queues without considering the isolcpus
> configuration.
> 
> Introduce a new isolcpus mask that allows users to define which CPUs
> should have I/O queues assigned. This is similar to managed_irq, but
> intended for drivers that do not use the managed IRQ infrastructure
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  include/linux/sched/isolation.h | 1 +
>  kernel/sched/isolation.c        | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index d8501f4709b583b8a1c91574446382f093bccdb1..6b6ae9c5b2f61a93c649a98ea27482b932627fca 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -9,6 +9,7 @@
>  enum hk_type {
>  	HK_TYPE_DOMAIN,
>  	HK_TYPE_MANAGED_IRQ,
> +	HK_TYPE_IO_QUEUE,
>  	HK_TYPE_KERNEL_NOISE,
>  	HK_TYPE_MAX,
>  
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 93b038d48900a304a29ecc0c8aa8b7d419ea1397..c8cb0cf2b15a11524be73826f38bb2a0709c449c 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -11,6 +11,7 @@
>  enum hk_flags {
>  	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
>  	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
> +	HK_FLAG_IO_QUEUE	= BIT(HK_TYPE_IO_QUEUE),
>  	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
>  };
>  
> @@ -224,6 +225,12 @@ static int __init housekeeping_isolcpus_setup(char *str)
>  			continue;
>  		}
>  
> +		if (!strncmp(str, "io_queue,", 9)) {
> +			str += 9;
> +			flags |= HK_FLAG_IO_QUEUE;
> +			continue;
> +		}
> +
>  		/*
>  		 * Skip unknown sub-parameter and validate that it is not
>  		 * containing an invalid character.
> 
> -- 
> 2.50.0
> 

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>

-- 
Aaron Tomlin
