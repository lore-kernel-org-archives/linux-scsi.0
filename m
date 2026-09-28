Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020080.outbound.protection.outlook.com [52.101.196.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E6B4E9C0A;
	Mon, 28 Sep 2026 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610854; cv=fail; b=I/teMcI+gAOpMVxEPB1WW0Ug3rugP5qtaFsqriA5PK8Cfccax8gPLNMCIWPF6TBHBEJb8eJR/sobv1VHEaNHk05NQs6/IdntrZrLdZE/06D04BnZso6tpsLsBwdFKk03AQK3Xr/uC2/tLXRk7W+mgtAqQ3rmCjs0YnuSygYILBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610854; c=relaxed/simple;
	bh=c8C/OWuGIDcyeeKjdU7UlAW25ZyeMK93TF9A/brUVAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TUqeo12AY34hnTp0qM1yGbwLP1DsRMHd20xvUE/omqFh0wR/ygkekjWsCisZbCZJgQIH7CBMYzF4FcH4pjGD5ab+2UljSq8W8ZL/xh9MWSKpNvlMkVWLtnmMvzBJUwVCuIemOzODwpL1agDD5IYA/7Hqa4Z9dtD8PeNhB3eI2qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMlLIeyDnYUnCzCoEdOgIFhi0z2LdPCxBTSIMZgqZIilqF7vgeRwKT+JbXO5ikKxKG8/WsveJRisWtaLhvwOuKJgDcVT0yVXBmY07E6YaIdgZ+4TP2gcIWZvz7i4IDfd8sZ2kftdsZO3bt7qpue27U7L9K7Qx4zkmhj6B17VDx0CTwtMYU7Yr2MyMSlNFUwQSXeH3vc8TSx91tz48YPkApDHhKAt2PEAq6WmwTLq87TYd/v30hyJxSLip0ArATiciRFxaiIPIPid5kl4ZIHR9KlGDo75GHD6GEn2zKPPRnNg5rIg8yIOJD9RlAcijSrQpb7kkI2gs5bVLep1pNi8bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=dBWGcI3wM3CW7z/nk6hnn1XEFgtKCtSPQt64Ito0tKM=;
 b=GZPB+kbwTQZfJlPAXaurC4kYsjO4JyGdhwAXMB7uOIhI1nxZOtuwF+lLQ8hcSJ+BV9di5ojr40LTbtQm9T0ehy0AG6Swf9ePTRbLN/au3AP5EZoJK/20InrVtlG7XDaHxy7LLz6TYO+Q8bWbGpP6DtsOdanhM8APR4/39GypCcnwzLEl3n172IMRU8hAeOMh9WK0ukHJ1+Rlvrwa4sOuVq3DwjSkp9Z+wZGlsp37arxAWRhY3ursiesff60ugbC5Q6FPb8cS+IL5Fjg03Tu1ShrYKRayLSJuvVNFaQIZRYyyXnzpLDt7VO5TQ85uPxva4g7jTd4gf4q8iPvihG9LdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by LO2P123MB3664.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:12e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 15:54:00 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 15:53:59 +0000
Date: Mon, 28 Sep 2026 11:53:55 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Ionut Nechita <ionut.nechita@windriver.com>
Cc: axboe@kernel.dk, bigeasy@linutronix.de, corbet@lwn.net, 
	frederic@kernel.org, linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, marco.crivellari@suse.com, 
	mingo@redhat.com, mkp@kernel.org, neelx@suse.com, peterz@infradead.org, 
	tglx@kernel.org, vincent.guittot@linaro.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Message-ID: <ul7xqsblqnrzx67s7urmtc34qpemuf3jeduxmsuwxwlnky7eli@mzdpwwgug3hg>
References: <20260917154455.386769-1-ionut.nechita@windriver.com>
 <20260921135353.317688-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260921135353.317688-1-ionut.nechita@windriver.com>
X-ClientProxiedBy: BN9PR03CA0944.namprd03.prod.outlook.com
 (2603:10b6:408:108::19) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|LO2P123MB3664:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a9a1e0-4e6a-4dfe-d111-08df1d78b5d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|6133799003|22082099003|18002099003|3023799007|56012099006|5023799004|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	uR872L4mh7Ju4rMatP/C/fmdhjvAWZ7SGmjnOqxK+uOgzZkiKA2KIQAY2fwl5hSh5iP0F/oGwcutnvTajSc9C9I4Fr6AkhfEYkbV7+cnX7jTeG5fnu4RlgkiR8fFh0hrGeNKm/8ZRaBjPfrk06auMLEHRvQ1A2c2BZ9F24L7W8O5lWvXdSuN/J7KuAo8y1FQJgYTCWj8cbyUcBctB0pF/fS1vW9yUmPaA1m5seA/FFYFzLG+s/gAVcprZQptz9PavXyjLaQC9uTMBpT9mW3BcemXPAnePIYhFeXw0GzosYUrDgwBcVj04Idrg6F6UGISGa17u/ztgvzlnZlLq0D9L0w3kDDvPfFODDMnhhbkvlFKI0EZrga6J7HJBoR5GfYsrVHLzQrBCER5r6kErk9zLKFBDFkWKsGk8jUmrZxXDrVQY1X7afpJsTon6XjiKZQnG6xbNPAJdDf/6SfO6Yv6/UgOIMcHk3ksIlvYElGjs4pvl+5z0UWpjuyyNyOn0cpqDQc78G7Q8PfDZcSM2GxB1ZuxKBNm2pbH0cm8hnQ3YOHc9wtRtuBgfX58Lq/70T9Ilq8jTCjDEA6IpZ9X0DWF1PzZebJNw19AvjGft7ErVgBt0V4A+e/jxUzh0+QdVK8VNFstODTanpZhVOMjEE5WC70B5wNj1wonBAV17fwnBE8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(5023799004)(10067099003)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUhvSk5PenU2UHA3eEM0SHl5SWFyYU5mVFg1N1Bab2JZOU14MGJYam5pYlhN?=
 =?utf-8?B?UHM3NlpHOEdqeGpEZTV0RS80RVlob1lzZERlaERINGpqWkp3NGQ1L2RPUXBq?=
 =?utf-8?B?SS95OC9MSGk0bW9kZTJNSkVRQW81WnQ5aGZzVm9oeWZOM3BpZ3UyU1JtTUcz?=
 =?utf-8?B?TllRcmhzaVFZMGVXY2N5S01uQk42WU93UVhCdXZwa3FqVnphRmZqK2ovc0hG?=
 =?utf-8?B?VzlIR2ppcllSNm8rYWtEbGtiS2lpMXpGOUpXU2F2RlNvcXpBZHhzOWRac21U?=
 =?utf-8?B?Q09XTDRtNllJdW8za0FLYnJxU09iUTc5VjMzak43TjRvYW44SHRvQ0ZPajdh?=
 =?utf-8?B?RUdkeUY4ZHZCeGFwd0V1WmNtM045RzErTDR6YVd3VWFqUXRhSzZkV1dCc3hB?=
 =?utf-8?B?cUFVT3djeE1qNGYrQzdrb0pNOWg1TUJuMGtQU1lvYVByTWM4NGQ4NzdlRnBJ?=
 =?utf-8?B?WVNBS1VTd2thNjNBU2F1RzBWT0l2YTNKdFJQcHJyRUp2ejlFeHQ3OUhiZU44?=
 =?utf-8?B?eEs2RVRnSlFUYkpjQlh4RVhjZVBtQytJc2QyZFcwWnAyMVRuN3dXLzN3RGdH?=
 =?utf-8?B?SWRiVmVhQmtNUFZEZkc4NVVIbllPajhpbDhtOHIxSXhld3JoOHZIUGtia1hD?=
 =?utf-8?B?WkRVSXFieWg1UEtQZjdEcURESG1RTGpVMlFTOFFtWTUrbHN3OUM5UUppR3hu?=
 =?utf-8?B?QWVUZ1Y2OFFjcHkya3Q3aVFYZGNEdjl5Q1ZpRVIrZTdLamd3R1lPUkR1MWVr?=
 =?utf-8?B?bVAxNklSYmMwWkFUWGJqOHlhU2phUmkwRGtjNEpuSlVLTW40c3pQZUVoWUNh?=
 =?utf-8?B?REZMaFkyTkh2WFF2R2N3OTRGcTc4Vm82VTJIa0g1TDQxTGhYZE9iWmZlTzBl?=
 =?utf-8?B?Wk5tY2hiYk0yY3NkRXpoWDdiV2hYQzY3aTBmVUo5SFc0bW1MVUlLUDdWZkRH?=
 =?utf-8?B?a1dPekZFRWZpWmNCcEVBT1FFSnBFQWZLTTAvTzZqZjZ4WU1iZHdOMXJWZjBP?=
 =?utf-8?B?UWRieWpLNnpxaGdhaEdza2tlSTFQVGtvR2lLaUVtZlpFaUZSMTNycnZPR3gx?=
 =?utf-8?B?STVSS2dBZDA5ZXArNUpkWXJQQXV5ZGwzQ25uS1FZZHBvZVNpS1U1dmh1WnBC?=
 =?utf-8?B?SFpnek5tMzRPcG5rVEE0eENUUnJYOVhaUEFlVE1nMlJtU3RCRnYwYXZmS2RS?=
 =?utf-8?B?WmxGc1IrN25JdEVCOGdPalhYQWR6blJpalpHNGxUNktxOTdIRjlseis2VEVT?=
 =?utf-8?B?eElkVzlGbHZWSUJQOFltVzVFRWpKY0RRYWsyUlJ1eERhRDZicTg2N01tRGV4?=
 =?utf-8?B?WFNxZUtrUXBYUlg3N0ZtWStzekxXNzN1TjZNNGM0UlhJVEVjNWpUK2dUOHhr?=
 =?utf-8?B?eXpKRHFQeTZ0ZVFUWTd6WTZpanZoMjUvTzY5SS9IWWdNTkdNdEdEM24wL084?=
 =?utf-8?B?a1dwbW5Vb0o0SnZYRlNyVyt5czFrK1pkaGlZMkhuSWt4dzlhOC81V3Q1Qmp6?=
 =?utf-8?B?d0FyUy9hRlNra1VSaXVnOWdDTWtZS0RTN1UxZFpkeFhTZThlK3RwQzQ2OUI2?=
 =?utf-8?B?SDhuTWVzY0F2THV1OVozcHBWdHZJUmZseEZ0Vm11L3FqWW1zQlFpdGpLa2U5?=
 =?utf-8?B?bkRYbEhPdDlGWHhwS3o4d1MrQmYzZmhVc05VckxnOHNvM014dXMzNVJ4T3dv?=
 =?utf-8?B?SEZuU3FWMmxKak9PQ1JDdU00dnlOSWNCMTB4c3JheTRvODhONExxYlpEMFVZ?=
 =?utf-8?B?NFFzdjgvSEwzK0dvWWNwSGsraXZTajlnOGszb2FJTnYwSU15Ny9pOTEvY0FH?=
 =?utf-8?B?M1FvOWZab3ZtWFA5cGFnK2YwUjg0Mi9LNjM3TUVMbklQQmNtSTdBV3pmSWt3?=
 =?utf-8?B?dFFldUhhdnNuSjJFM3hCWkl3ejgwSTVWL0RzUkZleHZYS3J4cDc3Y2ZzL3ZQ?=
 =?utf-8?B?RzNNMndSZjdFN2ZwNU8xek9VOXlkWGIxbkJEV1BaVHovZW5NMTZ3NnFNbnhw?=
 =?utf-8?B?bTY1dzFhZmFoaVpKWm5iNDQ1THNRUVZ3SzdLK05pcXBvZlo1YXVuY01BWUxo?=
 =?utf-8?B?VEN3Ni9mMzltVk9iNXRRMWc1UzFxb2ZjRGZjaWFKVTdQTlo0bVBtcVRDeXZy?=
 =?utf-8?B?UG9jSC9UV0d4MEFKLzd3U1d0dmNIM1BqWGQ2cmRzSk5tWEM1UytCT1QzdGxL?=
 =?utf-8?B?OW93VkpsSzdIQ0hyOXhXbWNFLzA1WFQ1WVprKzZ0aytPMDluWXI0UzBSRUlE?=
 =?utf-8?B?TFRXcWZPWG1IU1o3ZWZ5eEMwSmcyS3UyeEl4L3Q0bkhPaFJPVUUvVTBNNkNz?=
 =?utf-8?B?QXlGUEF6Qys0ZHJnTHZzOVUvOUpEL1AwOEhoaHJoeHJxbHJUQzhndz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a9a1e0-4e6a-4dfe-d111-08df1d78b5d5
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 15:53:59.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szqaNIMFpWhvVzpjnjlBHaNM21Yt+HgUuw3GRFN5xDkJYu+EnhmTv8tEx+1mFLhVXZojF6ncpIMC3vi5cKQAEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P123MB3664

On Mon, Sep 21, 2026 at 04:53:38PM +0300, Ionut Nechita wrote:
> 
> Hi Aaron, Daniel,
> 
> As promised, here are the end-to-end results from exercising v16 on our
> 6.18 LTS PREEMPT_RT tree. Short version: managed_irq_strict behaves
> exactly as documented on multiqueue NVMe with a deliberately narrow
> housekeeping pool, including the nr_vectors >= nr_cpus case.
> 
> Series under test (as backported to 6.18 LTS)
> ---------------------------------------------
>   0001 scsi-aacraid: use block-layer helpers for queue count
>   0002 lib/group_cpus: remove dead SMP code
>   0003 lib/group_cpus: add group_mask_cpus_evenly()
>   0004 sched/isolation: prevent out-of-bounds read in isolcpus parsing
>   0005 isolation: introduce the managed_irq_strict isolcpus type
>   0006 blk-mq: use housekeeping CPUs only with isolcpus=managed_irq_strict
>   0007 blk-mq: prevent offlining housekeeping CPUs with online-associated
>        queues
>   0008 genirq/affinity: restrict managed IRQ affinity to housekeeping CPUs
>   0009 docs: document the managed_irq_strict isolcpus flag
>   0010 genirq/affinity: confine reserved pre/post vectors to housekeeping
>        CPUs

Hi Ionut,

First of all, please accept my apologies for the delay in getting back to you on this.

Thank you very much for this comprehensive and thorough test report.
A few comments inline below.


> Note: 0010 is a local follow-up (see section 3), not part of the
> upstream v16 series.
> 
> Test environment
> ----------------
>   Kernel:   6.18.15-rt and 6.18.52-rt (PREEMPT_RT), v16 backported
>             (6.18.52 is the current 6.18 LTS; behaviour is identical on
>             both, the data below is from 6.18.15)
>   CPU:      single-socket Intel Xeon (Granite Rapids), 40C/80T,
>             1 NUMA node (all 80 CPUs on node0)
>   Storage:  2x NVMe (SK hynix PE9010), b6:00.0 and b7:00.0
>   NICs:     8-port E830-CC + 4-port E825-C (managed IRQs)
>   MSI-X:    2235 vectors allocated system-wide
> 
>   cmdline (relevant bits):
>     nohz_full=2-38,42-78
>     isolcpus=nohz,domain,managed_irq_strict,2-38,42-78
>     rcu_nocbs=2-39,42-79 kthread_cpus=0-1,40-41 irqaffinity=39,79
> 
>   => isolated (isolcpus) = 2-38,42-78   (74 CPUs)
>      housekeeping (HK)   = 0,1,39,40,41,79   (6 CPUs)
> 
> Because HK is only 6 CPUs while the box carries 2235 vectors, this is
> squarely the "narrow housekeeping pool, nr_vectors >= nr_cpus" scenario.
> 
> 1) blk-mq queue allocation and mapping (patches 6, 7)
> -----------------------------------------------------
> Both NVMe devices allocate exactly 6 hardware queues, matching the HK
> weight. Each hctx is owned by exactly one HK CPU:
> 
>     nvme0n1 / nvme1n1:
>       hctx0: 0   hctx1: 1   hctx2: 39
>       hctx3: 40  hctx4: 41  hctx5: 79
> 
> No isolated CPU owns a queue. The sysfs cpu_list only shows the HK CPUs
> because blk_mq_map_swqueue() strips the isolated CPUs from hctx->cpumask
> (as intended). The full software-context routing from debugfs confirms
> the 74 isolated CPUs are still mapped onto these 6 HK queues rather than
> left unserved, evenly (~12-13 isolated CPUs per queue), so I/O submitted
> from an isolated core completes on a housekeeping CPU:
> 
>     hctx0 (owner 0):  0,2,8,14,20,26,32,38,47,53,59,65,71,77
>     hctx1 (owner 1):  1,3,9,15,21,27,33,42,48,54,60,66,72,78
>     hctx2 (owner 39): 4,10,16,22,28,34,39,43,49,55,61,67,73
>     hctx3 (owner 40): 5,11,17,23,29,35,40,44,50,56,62,68,74
>     hctx4 (owner 41): 6,12,18,24,30,36,41,45,51,57,63,69,75
>     hctx5 (owner 79): 7,13,19,25,31,37,46,52,58,64,70,76,79
> 
> All 80 CPUs are covered exactly once. This also lines up with the
> hotplug guard below: isolated CPU 3 is routed to hctx1 (owned by HK CPU
> 1), which is precisely why offlining CPU 1 is refused.

This is brilliant to see. It verifies that group_mask_cpus_evenly() and the
updated blk_mq_map_swqueue() logic distribute the isolated submission
contexts evenly across the housekeeping hardware contexts without leaving
any core unserved or over-subscribing a single queue.

> 
> 2) Managed IRQ affinity (patch 8)
> ---------------------------------
> Every NVMe completion-queue vector has its effective_affinity confined
> to the HK set:
> 
>     nvme0q1..q6 eff = 0, 1, 39, 40, 41, 79
>     nvme1q1..q6 eff = 0, 1, 39, 40, 41, 79
> 
> No managed interrupt targets an isolated CPU.

Excellent.

> 
> 3) Reserved pre/post vectors
> ----------------------------
> The NVMe admin (pre_vector) queues also stay off the isolated set:
> 
>     nvme0q0 eff = 79
>     nvme1q0 eff = 39
> 
> Note: in the stock series the reserved pre/post vectors still default to
> irq_default_affinity, which on this config spans the isolated CPUs, so a
> freshly probed admin queue can briefly land on an isolated core before
> any userspace re-steer. On PREEMPT_RT that stray wakeup is precisely
> what we are trying to avoid, so we carry a small follow-up that confines
> the affd->pre_vectors / post_vectors to the housekeeping mask when
> HK_TYPE_MANAGED_IRQ_STRICT is set. The affinities above are with that
> follow-up applied. Happy to post it separately if there is interest in
> closing that gap upstream.

Okay. In kernel/irq/affinity.c, irq_create_affinity_masks() copies
irq_default_affinity for the pre_vectors and post_vectors loops. When
isolcpus=managed_irq_strict is in effect, have you written something
similiar to the following:

--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -30,6 +30,7 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
     struct irq_affinity_desc *masks = NULL;
     const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT);
     bool hk_enabled = housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT);
+    const struct cpumask *def_mask;

     /*
      * Determine the number of vectors which need interrupt affinities
@@ -63,9 +64,14 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
     if (!masks)
         return NULL;

+    if (hk_enabled)
+        def_mask = hk_mask;
+    else
+        def_mask = irq_default_affinity;
+
     /* Fill out vectors at the beginning that don't need affinity */
     for (curvec = 0; curvec < affd->pre_vectors; curvec++)
-        cpumask_copy(&masks[curvec].mask, irq_default_affinity);
+        cpumask_copy(&masks[curvec].mask, def_mask);

     /*
      * Spread on present CPUs starting from affd->pre_vectors. If we
@@ -104,7 +110,7 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
     else
         curvec = affd->pre_vectors + usedvecs;
     for (; curvec < nvecs; curvec++)
-        cpumask_copy(&masks[curvec].mask, irq_default_affinity);
+        cpumask_copy(&masks[curvec].mask, def_mask);

     /* Mark the managed interrupts */
     for (i = affd->pre_vectors; i < nvecs - affd->post_vectors; i++)


The intention would be to fold the above into Patch 8 ("genirq/affinity:
Restrict managed IRQ affinity to housekeeping CPUs"). However, we would
welcome your patch. Please feel free to post your follow-up patch to the
list so we can review it, or alternatively, we will use the above (or
similiar), and fold it directly into the upcoming v17 revision.

> 
> 4) blk-mq hotplug guard (patch 7)
> ---------------------------------
> Offlining a housekeeping CPU that still serves an online isolated CPU is
> refused:
> 
>     # echo 0 > /sys/devices/system/cpu/cpu1/online
>     -> fails (-EINVAL)
>     blk-mq: cannot offline CPU 1: online isolated CPU 3 is still
>             mapped to hctx1
> 
> After offlining the dependent isolated CPUs first, offlining the HK CPU
> succeeds. suspend/hibernate (cpuhp_tasks_frozen) is correctly exempted.

Very glad to see the hotplug notifier path operating cleanly and rejecting
the teardown with informative diagnostic output.

> 
> 5) Vector count / probe robustness (patch 8)
> --------------------------------------------
> With 2235 vectors against 6 HK CPUs, no device aborted probe: no -ENOSPC
> and no nr_io_queues=0. The minimum-vector safety net in
> irq_calc_affinity_vectors() holds on this narrow-HK box.

This confirms that irq_calc_affinity_vectors() gracefully handles vector
exhaustion risks while maintaining minimum required driver vector bounds.

> 6) Runtime completion locality (PREEMPT_RT threaded IRQs)
> ---------------------------------------------------------
> fio randread 64k, 4 jobs, iodepth=64, 120s, pinned to a single isolated
> CPU via a device-plugin extended resource on Kubernetes.
> 
>   Results:
>     IOPS       : 56.9k
>     Bandwidth  : 3559 MiB/s (3732 MB/s), 417 GiB in 120s
>     clat       : avg 4489us, stdev 30.99us, p99 4555us
>     total IOs  : 6,833,178
> 
> While fio was submitting from that isolated CPU, every threaded NVMe
> IRQ handler on the host was scheduled on a housekeeping CPU
> (SCHED_FIFO, as expected on PREEMPT_RT). `ps -eLo psr,cls,comm |
> grep irq.*nvme` during the run:
> 
>    0 FF irq/195-nvme0q3   0 FF irq/196-nvme0q4   0 FF irq/198-nvme0q6
>    1 FF irq/187-nvme1q2   1 FF irq/188-nvme1q3   1 FF irq/194-nvme0q2
>   39 FF irq/185-nvme1q0
>   40 FF irq/186-nvme1q1  40 FF irq/189-nvme1q4  40 FF irq/193-nvme1q6
>   41 FF irq/191-nvme1q5  41 FF irq/192-nvme0q1  41 FF irq/197-nvme0q5
>   79 FF irq/190-nvme0q0
> 
> All 14 threaded handlers land on {0,1,39,40,41,79} = HK. Zero
> irq/*-nvme* threads scheduled on any of the 74 isolated CPUs.
> 
> The /proc/interrupts delta over the 120s run confirms it at the counter
> level. Every nvme* IRQ that fired incremented only on an HK CPU:
> 
>   irq 192 nvme0q1 CPU0 : +6,809,271   (fio's IOs, one HK owner)
>   irq 187 nvme1q2 CPU1 : +684
>   irq 186 nvme1q1 CPU0 : +598
>   irq 189 nvme1q4 CPU40: +568
>   irq 191 nvme1q5 CPU41: +512
>   irq 188 nvme1q3 CPU39: +304
>   irq 193 nvme1q6 CPU79: +271
>   irq 196 nvme0q4 CPU40: +4
>   irq 194 nvme0q2 CPU1 : +3
> 
> Every single delta is on {0,1,39,40,41,79}. Zero completions on any of
> the 74 isolated CPUs. I/O submitted by a task pinned to an isolated
> core completes entirely on housekeeping cores.

These figures provide definitive proof of completion locality. Over 6.8
million I/O completions and threaded interrupt wakeups without a single
stray interrupt or context switch landing on an isolated core is exactly
the guarantee managed_irq_strict aims to provide.

> 
> Still on my list: a negative-control boot with plain managed_irq to
> show the confinement disappears. I will follow up with that.
> 
> On option 1 vs option 2, my earlier preference stands: keep
> managed_irq_strict as an explicit opt-in and leave managed_irq
> semantics unchanged, to avoid a silent behavioural change for existing
> deployments.
> 
> Tested-by: Ionut Nechita <ionut.nechita@windriver.com>
> 
> Thanks,
> Ionut

Thank you again for your time and testing efforts. We will add your
Tested-by tag to the respective patches in v17.

Kind regards,
-- 
Aaron Tomlin
