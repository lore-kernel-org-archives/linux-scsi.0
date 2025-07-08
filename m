Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021124.outbound.protection.outlook.com [52.101.95.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9812343BE;
	Tue,  8 Jul 2025 01:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751937845; cv=fail; b=Ly6hpW6YDpMWmnyVUuW58m8ZQ+N7ofdJA6kdg27tQbrsmZzxzw4guFeELuALzE63R5S1M7vyFkqP2OOl540zERilf/huWrJQv8fiqwEjlmQm/dROb7JfDS2R3ck/XcK3UC8sQtXUqIrOjXEOe8jk6s5STyAXvK3UEmc6wzuRpIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751937845; c=relaxed/simple;
	bh=LWDo1raANaMe6yPYflzvczlfWyBzwU4+9y1CgLWFlag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Oo0syHKEniT9CdBR8+HhHMIsmn1W3EAEnqNxbIaVWDUTTvQgDSdIkQrIqmwt1pa39kmLU+F/PhFuxDgLIKONtAPAELcA+02KJwA1PvlFnkw+DUDRf8y85+85zh9NZ4b95nsibtIgLrFk9CsE0ag+yr8QuB4KPyHymVDjT21UTsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m34a5UQuuq8/CX9j6SAB1BqIvEnAhDNjtZ36nCcDUwQNzQRNI4FNPCeZnNccAXTIyyvK8Whb2gzZmQnBrUQaqHJ2jA0mmXokxnlHxBo8uykp/Gv6xjxQTFNyEyZ4fsV5sVuT2CW2ZvAthvcYQ+/sd7uNrZpWVcLKKg4w0tId0EtrGk5XRXH4GAMgVlLgx0JzQ79KHuh4J9IBYOZW4jQKWY8qIQjxfJp6/85ROk2XOs3I46jnbifpMJxr4BM2OZ0n8CHzjHfkv8eN7WfKByA7mOrmBOSI2HBNnQkGn1i9buqtpuEmX9UeFeYitYwcZZGdqJu2UCG/AU9tO3m111d3zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fK06QT3/71+huZtWa4pdok4J0tPA51ZRNueSqncawjU=;
 b=h5YZlB6fLtyzjyNBqUn8NqIK0ilGE0ufhyfx5Sz0tddXicvvcSM842piqdt6AAseZBo2Dhbnf839HSXstb0iq4UAQ1lM9jdOzTRBVAKkyXDgqgGfYADggx7A5Y45nbTm2gs6q8ijlDKtvoLzuoJAeqrfXmVgaYkvxUROMhqKURqyFuzkCCTKnDkfOmf+n5mrlTEQik83C28SF416TlwddoQzNqUT1Ls9RnJivqzbXC1Tfg0BEzx5ZO5XDtne6GELC0I25GbGiipe0XQvu9MUqx50AIDf6CRtx0tHLFhKJKQlRZMjmxe97syAvi/7ZXuEcLsF6PpN7fCy2dggBW4+FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB7362.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:220::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 8 Jul
 2025 01:23:59 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%4]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 01:23:58 +0000
Date: Mon, 7 Jul 2025 21:23:54 -0400
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
Subject: Re: [PATCH v7 09/10] blk-mq: prevent offlining hk CPUs with
 associated online isolated CPUs
Message-ID: <kddv45bntdt2rwrkcoocimtzqf2h2ndhz3nxl7q5ngycfwiqyo@dppoo3b7p5js>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-9-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250702-isolcpus-io-queues-v7-9-557aa7eacce4@kernel.org>
X-ClientProxiedBy: BN9PR03CA0771.namprd03.prod.outlook.com
 (2603:10b6:408:13a::26) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB7362:EE_
X-MS-Office365-Filtering-Correlation-Id: 19d382c5-1d14-466c-cc14-08ddbdbe1c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emt1ejJma1M5SGFMU3FxYzFQckNjcnAzcDZ6YmplN09McWJyc2h5aERaN0Jl?=
 =?utf-8?B?cUE1UU1jdnl4OS9aN0Z4eDRNTE4vbkcyM0UrMjFZQndzL2xwWFJucm5YRVhC?=
 =?utf-8?B?d0xOcW83RG1NVksvN3FPQndrL29CTWVoNGRoaEtYVGN0MzQ1NVo0NHZVUTQ0?=
 =?utf-8?B?RE9vTXd2VEZsdkluWHVoVitoaDBvUlhNeDhhWXJnVW94QWJTSU9pM1NVVDBz?=
 =?utf-8?B?dXJtNkFGQzFXNXpSRytxYTdqQTZSR3FRUVY4NnNudHVvRThCbmlBL2NIWW1a?=
 =?utf-8?B?Q2Ewa0pvMjB0WHpqTDdBRzBNK1BpcDRQL2YyT3FmaXozdGs0WU16WVF1dkdl?=
 =?utf-8?B?Q1RjWm1uT2EvVXg1NGdudDJmZkp6S1JIMHZQY25DTXRFSXo0S09ESUpBREhm?=
 =?utf-8?B?SnEydlVtZ1c2eTMzVWZBeERucjNDNW5GRkxrWmNiM1FvdC9lbU5zTzBhRU4x?=
 =?utf-8?B?R2hKT09hU0prTStKM2NLM3BDTnRjWjVmN3pSTy9hYnNGSWFaWUR2cXV6THBO?=
 =?utf-8?B?cXRGeGVrWGhIMURXRkdZbXZVZFJ2MW9DMmpOaTU5bmRiYklnMXJoVVIyUlI2?=
 =?utf-8?B?aVR1bWE2WUh2Z1dXb2FrNzFFUEx0S0lTSXF3UHhRMnhtRVFMWGhSNHREUDZk?=
 =?utf-8?B?TWNXcnR0MUJkSGFxblRZZnE3UlAzQk5RenpKWUtnWXUzN3pYeFlJWHdJRldN?=
 =?utf-8?B?ODQwclp4Y2hEOWZzRng2Y0ZISDZoUnlmNmFGZWg3Zko5K3J4ZGJ5SitQend0?=
 =?utf-8?B?Ukp3NDZ4NlZaMStpNG9COWh1UTFUSnd4Mm5tblh1L2VKWlBMa01KSVhSN2Jn?=
 =?utf-8?B?dC91WkE5RFRSYzg1V0hXekU2Z1NLSm9SbnZkVE9Memt6UEYvaVF3N2VTNWdr?=
 =?utf-8?B?aVJKSFdzV0xwQkM0dUxhY2JuOHZ4SWVVckcxV1ZhUHpLTWJCZlVyZksvNjVz?=
 =?utf-8?B?VmloTlIyL3o2NW9IUk0waTMvVmk5S283cnBwZlR2TkNDMnNmbTlFVi9jTHow?=
 =?utf-8?B?MlZLRVVCV1Bqakw3bnBNSFJJOTNmLzV1VmdBbHFtb3RESWJJL2hCQkhkYVBm?=
 =?utf-8?B?U1VVa2N6RUQrWDRuUnZRcHBUZHNUQWhQRzh3S2tFQ2hGNVVINDNUc2krem40?=
 =?utf-8?B?YzM4OWtqTFVoa013MlByYnVzbm5kOG9kdFhSWldUdUZmQ0ZhU2tnQ2EzYnV2?=
 =?utf-8?B?ZmFIYnFHNjJvZndoWEp6S0RxNFRaOUtSS0dtYzFRWUw4T0VsaW95TEJlS1Rl?=
 =?utf-8?B?RkZvcHhVOHcyMWNnU1JkcVlwcnpEdlRLQUliamJBUmNkb2FkOFo4Z0VWa0pQ?=
 =?utf-8?B?c1FBQWZrMkM0MjNNRXp0Wk1Jd01TYlBWK1BEWGpVNGhJRDhOdXN1QTNFTEJh?=
 =?utf-8?B?bmxxRVhBenRUbUFoaWdpcVBTWkgycFU5Y05rQ3Y2QWhGa2hUbThyVzhZR2M3?=
 =?utf-8?B?c1dGcFJTd01wNTNTdmNoTEZGcXptM1BFT04ySWZvWDRMY2wwVHJtSjN1LzBk?=
 =?utf-8?B?RjdMeDllSGhJM0lDYmZUTG9NTWtKM3Rzc2gxa0NKVG1scUM4RkQrMk1hM3ZU?=
 =?utf-8?B?elROdzBld0MxZ1hMcmhHMk5EclNScUlYL2I2eGR6ZDBpOFZsdG0wcklkajA4?=
 =?utf-8?B?SWJ4bFZ1UGZxZmFpR3ZFLythWlJPN0ZpSDB5OU40bXZDYVkraSt5OXJEV2hM?=
 =?utf-8?B?MWk1ZEJLeHNNVHQ3MWxEVlppeEJsczJzZGJHcmprczIvcFpzV28xbS9tQ2RW?=
 =?utf-8?B?b1EyeUh4MlEvUngvZTFnQXpOVDJ6QUVtZUl2RnFqZmsvSkwzUHRTOEozL0hk?=
 =?utf-8?B?U0N2Tm91Z1VSaTZLK011MmloSmhXb3Q1OHR1Nnp4YkV2cW9kRXhVK2xOb0tW?=
 =?utf-8?B?djhEM0d4eWtGYzJYTkdCOTJHeWdrWUZxeE02UjBNMExObDJQOS9FcHBTa3NT?=
 =?utf-8?Q?y9uFQ7blSPc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0h1VWVqUExjUS9POXdvOFJHL2RENllXR3Y5OUxwWTgrZm1JN1JlbFFuSmxo?=
 =?utf-8?B?d0xiL3g4SXRRMGZ3Z0VtV21ycHRYSkpObmhrSXBaWDZrWlJGTGlOWjcwTjhu?=
 =?utf-8?B?VnBzZXlYUlZiQ0pJNjFDYTV5RkdXM0pXR0tyQ3FpdXlEQWN2WC9mY21kRlRp?=
 =?utf-8?B?bnBGZU1CcHhJMWRoSEJBMUJQbVV3enZWVnZKcnY2ZzdwU1VkNmJpR1hXQVFO?=
 =?utf-8?B?MGJGQk5rUlhWQUZGSkRZWERkRUJCNUJUMmhrckNMeG1Ib3VISkh5UXhGQVA0?=
 =?utf-8?B?L1drSmZLWWg5RmFua2FTMllSYXZsVEM5QktCcmtLWDlFakJ6Y1Baamd6bjJj?=
 =?utf-8?B?eGJDNkwweC9aa1Zsa3ZqZmZlbHVrcnVYOWZOMUhrY2NjYm80czQzeFNLQUsw?=
 =?utf-8?B?QlJZN21XOEdBRlRxSGpjWFBWbkdxb0VRSTFrbTlFbmZSU2I3RHBqRTBwd0l6?=
 =?utf-8?B?azNmajRiTVRYUEpKdTI3bWU5WmxMOWNGZ3BmY1MveHd1SWx0cEFaQUpwRGs5?=
 =?utf-8?B?TGszektRNitkU2dneFhLSklEWGdKb3gyUjZEcktwdWE2ZE9RQ1VDSlE3Z1dt?=
 =?utf-8?B?a2VIOGIvMld5ZDBPZXp6N1lHWHZOeUliM1BnemtjaDhodG0yakVQazV2cFdx?=
 =?utf-8?B?YThhWDVrU1BlMWpvTEZWd1Nkdk0wZXlZTU9XR1BZcm5EU3liMHR6T2pYVVFE?=
 =?utf-8?B?bnFuWG9vT04wQ0xXYWJrRDVFWVBHTHFtajZPREw3M1Zid3JMdE9DTVVDd0VX?=
 =?utf-8?B?YURWM2JNTVB4ekx0ZTF6cDM0dmVWNDhIZU1tN3NEUUM1TEZVRFBSM3BBTEtH?=
 =?utf-8?B?Wmt0TnRiZHh1OTQrZWFpS1N3d3pmVWJCT3NobU9DSEhOVGJlWHNrNldDMU1J?=
 =?utf-8?B?MVEwdDJhSmRrY3VNTkdRcW03ekV2cnNsejl1REpLSFBXSTdLdzlHRXZQMTZW?=
 =?utf-8?B?cjdKcC9yRG80WDhLWk41MjU5YTVsb1RQOFIvMkNyTkFNdE5CdlNHQkRMN3pu?=
 =?utf-8?B?WWxGbDd1NUxQUUlLV2g5TWNsK09DN1BFQUpsS0dvWkxRWnFiUzliSVFwTkkv?=
 =?utf-8?B?bDVyanYvL09hSk9nN3RrTFdKZ1ZzekcwL2NPbW9adElLNGdpaU9kM254ZGtp?=
 =?utf-8?B?UDhvRVJyOHpEVGFxQVhIM3ZnNm5kS0xIU0R4VlpLdUF4Mm5uQ0IwS0RvRlRT?=
 =?utf-8?B?NnBEdG5sTFhJY2VLNXJFVkNYdG1UNTZ4eTNZVnNvU05BRDhlbnNmeENhc3JU?=
 =?utf-8?B?RmRsVGd3NnprK2VYeEFZUWpzMndtTHh4ZlorUlEzdWlvamFBa2VNb0NkZ2tG?=
 =?utf-8?B?ZkpSbXdBRnF0Q2hEdnA2K0p6WXh0ajJNd1R0RTEvSXFoZkVVVkZjSkhxOWdy?=
 =?utf-8?B?dTJrNXlqVGNlZ1pYdFZCRWI0SmJnamlWaHIwWEVURURvd3R6OTFzMVpEbndt?=
 =?utf-8?B?VGY2OGJNN1orK3pGZjQ0b0NEaGJVYlc3QjJkR0ZzV2xlT0xJNTJOd1NkQlp4?=
 =?utf-8?B?QlBPaDh5blRxcWRXL3krdDlSQTVqSW00b1Q1Uk9yZ1ovK1JDOUV0dWVTL1Iw?=
 =?utf-8?B?SVoxNEdBR1RTMS9Xc3Jvb3p1blZjTzBrclRNcVpJekxHekZEbEJWaEd4ZmIv?=
 =?utf-8?B?dVg0NU1acGR3aitYVVBOM21aSzBSSzZxRG1uQnVCTUVpNWFyazlsZHFUSDRw?=
 =?utf-8?B?ZDNSUEVQTE44TEU0WHNqZWdtdGkwSlU5Y3hvZUlwNmgzZXEvam9UNFF0cVhX?=
 =?utf-8?B?OTNIY3lnRzdxb3dCTnI4bHNFdFhydGtWZ2pjdVdXQnFYS3NpSmZuTVNvcDdG?=
 =?utf-8?B?cGNWMmNJK0U1KzRVQnYrd3huZmp6NTRaNDhGdTZSWjEyd1k5OTVEUVdqZU43?=
 =?utf-8?B?cmVyQzNaZkxTSlhMVlFKN01ORFZ0STlIMFlwbVV3MEppUjNVRXk1bTJvN05T?=
 =?utf-8?B?ZUptZW5LMGlzSXhrUkxOMC91ajVzQllJRWR5UWVUWW5Tdk12eXRnaHl5SjB6?=
 =?utf-8?B?VU1HcUtweEFDaEQxVnVSeitLSkJHeUZFL3ZGdVQ0OUNNdzVlVzU5ZlVmaHFy?=
 =?utf-8?B?RHRrS2hjakx4SXl5MzhCWTRFb2htd2o2Zm1aeWhGNTcyejR1YXBLdnVvd0Na?=
 =?utf-8?Q?FoAB0GXtYRNPhjAiKFwBZ4BXR?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d382c5-1d14-466c-cc14-08ddbdbe1c7b
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 01:23:58.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxawCXnghOmjVQaF6FLSU1MD4vBJ6a3V937P3+dlmfRfflUqlsbCKi0zRfBSuTZWNLXGgleWHBc9D/O8MMJYSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB7362

On Wed, Jul 02, 2025 at 06:33:59PM +0200, Daniel Wagner wrote:
> When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
> given hctx goes offline, there would be no CPU left to handle I/O. To
> prevent I/O stalls, prevent offlining housekeeping CPUs that are still
> serving isolated CPUs.
> 
> When isolcpus=io_queue is enabled and the last housekeeping CPU
> for a given hctx goes offline, no CPU would be left to handle I/O.
> To prevent I/O stalls, disallow offlining housekeeping CPUs that are
> still serving isolated CPUs.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  block/blk-mq.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0c61492724d228736f975f1d8f195515603801b6..87240644f73ed0490a5459e042c68e0e168f727d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3681,6 +3681,43 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
>  	return data.has_rq;
>  }
>  
> +static bool blk_mq_hctx_can_offline_hk_cpu(struct blk_mq_hw_ctx *hctx,
> +					   unsigned int this_cpu)
> +{
> +	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
> +
> +	for (int i = 0; i < hctx->nr_ctx; i++) {
> +		struct blk_mq_ctx *ctx = hctx->ctxs[i];
> +
> +		if (ctx->cpu == this_cpu)
> +			continue;
> +
> +		/*
> +		 * Check if this context has at least one online
> +		 * housekeeping CPU; in this case the hardware context is
> +		 * usable.
> +		 */
> +		if (cpumask_test_cpu(ctx->cpu, hk_mask) &&
> +		    cpu_online(ctx->cpu))
> +			break;
> +
> +		/*
> +		 * The context doesn't have any online housekeeping CPUs,
> +		 * but there might be an online isolated CPU mapped to
> +		 * it.
> +		 */
> +		if (cpu_is_offline(ctx->cpu))
> +			continue;
> +
> +		pr_warn("%s: trying to offline hctx%d but there is still an online isolcpu CPU %d mapped to it\n",
> +			hctx->queue->disk->disk_name,
> +			hctx->queue_num, ctx->cpu);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
>  		unsigned int this_cpu)
>  {
> @@ -3712,6 +3749,11 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
>  	struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
>  			struct blk_mq_hw_ctx, cpuhp_online);
>  
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> +		if (!blk_mq_hctx_can_offline_hk_cpu(hctx, cpu))
> +			return -EINVAL;
> +	}
> +
>  	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
>  		return 0;
>  
> 
> -- 
> 2.50.0
> 

Thanks Daniel and great work!

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>

-- 
Aaron Tomlin
