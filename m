Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020102.outbound.protection.outlook.com [52.101.195.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9479D388E4D;
	Thu, 10 Sep 2026 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789064794; cv=fail; b=d2zQHFXpSyohgDY0Nkyq42VPIZKdI9dxj9ybBLS2J/3clPsWhyNferIuAurquZ9W62pXDG7dInE+K2HCa9hfPCF78VNU7mTTjSm8Osg74pfovy4IK/oGAOoR88s1qMF3DKrtXXGzIMDCCkH+CHdtzZ6w28FlwtL/0xeMNGryfG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789064794; c=relaxed/simple;
	bh=hmIPjVsHHOMIWkP0kiYwXtezW2Klb7DOsnrsXWbhg4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hAaQ5fGCsQPvDFhs+1as0NHNuBoAPaf/LIF4NCFMS8V7cG9E3H3cREzQmzoUmThFq/XZtEyIUXlX1AXns/YOJasVhaGkt8WB+fU8DE1uw8pZbTfgDPY0xrEHj4gqNPimo3zg/ICbxkN0N5CTc7xk3wvWGi5w6WkneEqVQViR75s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VT9L9U1OS17rpVC0WSvsAZltW7vRgXdNcWEpz/kpb38hjmovg1lesmwcmXDI9sTGwug5YQq513I0dRkPUVqs5lyCggr5dI2weJqQWJ5EJ70rDX6xaZzvti6a5YVxKGp/aPfdTH41zrH7egpNlz7ryoaAvuHBLbPCTMCtH6o2BR/ZtD3W5DWSPERc4kSkYloBHB4YGSNT+UURAuGAETDCM5I9NvcTFcugDQToyuG9vhHEZ4s38KgHRxHi/igLsumtFNSviqgxHkQJr3BUO7GicUdwKXYolnELyAdEIa2bd6MaTWygQN+tkmUdd8MMhHqhTNPr7e9BQ7wv3FJHPJRhXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=F/MKQoVQcWbrHDvv0trCuPq3AI9Ft5LHt2ZvkFxuRVI=;
 b=OhPo68u5XdIkgnFFSak15Je4/98PDM2WoECRi1jgFpJUo7QypQ/VFFOr+xEDKJGcSb95wDo1ASzmIh43v8WvHinOrZqhbukfRaTQfZ8L+KHyM4HLZBuKlEF6dvSXsMgohXLxBPS/ug1WNkvLBrcHX6hUW26AXHclPg9rklmmGZzQ2FPmcMVPUGMZJmx4rq0e4Gn1xEq66cXb4kjoKvc/yyfEGSy/BmQY4HhUQwL10PhSuci4kX++vCAbmFQr2ApD3K7faGlSLF5imL6+EskzCwz6zGjD3+luUaRbIqpXiqNcObokTn3fm2axOzz5G6c5BPPLVjZzjdOVCVpJD0ANaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by LO3P123MB2859.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:b1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Thu, 10 Sep
 2026 18:26:28 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 18:26:27 +0000
Date: Thu, 10 Sep 2026 14:26:23 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk, tglx@kernel.org, aacraid@microsemi.com, 
	James.Bottomley@hansenpartnership.com, mkp@kernel.org, frederic@kernel.org, bigeasy@linutronix.de
Cc: wagi@kernel.org, martin.petersen@oracle.com, hare@suse.de, 
	ionut.nechita@windriver.com, corbet@lwn.net, vincent.guittot@linaro.org, mingo@redhat.com, 
	peterz@infradead.org, radu@rendec.net, akpm@linux-foundation.org, steve@abita.co, 
	sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, 
	nick.lange@gmail.com, marco.crivellari@suse.com, rishil1999@outlook.com, 
	linux-doc@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Message-ID: <nfqo4niblcea7d7nwjew3kfb6nzazkv76opngoa3icntpy7smq@rxqdmidxfxem>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
X-ClientProxiedBy: BLAP220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::33) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|LO3P123MB2859:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c65417f-331d-4126-ae40-08df0f690707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|10067099003|6133799003|3023799007|56012099006|22082099003|18002099003|5023799004|27256017;
X-Microsoft-Antispam-Message-Info:
	xHcpLpsTWLTuzZEzMIKnudDPlON/C1meK0cEhxwkUHJQtnM/kIKJFd9O3JraUhUHDS9lByNcHoEOQiK1quO1DNam7ARUDNLH24h6VevbMwABtOo3EwLEu9nTndDc71EfEQVQiONLlINEWVKMlbTalR9LYyQ3SQkFyWw7gZpo6cmTGyYIqv7Se41sEjXBCBIvqSsNGrj5x01xPIaR/C4Bo0h4IcmR2qmR+dWyptXbIwmVW/N88icM9PI/No6O3awOq8M9DGzkrAA0t3j19R6/Xh2E5V5O0SMv8q38qVJLzGboSvbopp5wUOYxbUX69OrABIwzPpe3iEyDR2mbZI7PCUWxJMqIdnY5hHO86DXmYpWTzflrShxfqaMVE6sSqvF31n/Y6V7ohUKhoqMxWSorvmxNmZ5gXMAko7kIA91BjynXKTmc/pcYqQMOex5xqjKB5e2vFaWuMyAfs2xjWuibn0rN4LM2qzkPWaAP7mDgScb2ghXiv2H/G6hRlFvTLaBkeNs9MaxdbA+Rh4p46+UibFJuyejRT0zZhrQi8VSEau9UeVUGY1U90+E8yobU51Mwexiehdd3psbXkIjquTb90UfFl+WMC0vDs3CcZYqFp47DlWfLClXaHJNtWYKl20itSyaJRk1C0cymU6JxU21SR2RYjuBanTKpa7FyqJI5voE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(10067099003)(6133799003)(3023799007)(56012099006)(22082099003)(18002099003)(5023799004)(27256017);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dDcvVEhxRktQVEJHSFVId2VtK2dJcHY2dDBnWUt6RW1QcThpcWs1OUFiRUN3?=
 =?utf-8?B?dUYwZDB4S25BL1pGaUdyMHdCcEtxV1pBUElybElJb3hDaGd4RkVDNzI3S1py?=
 =?utf-8?B?RGhMVXhZeDhlWEFWamNYakNHVVZDbEVDcFVqbUNGTFQrREtMUTZlNFNYVTVL?=
 =?utf-8?B?OTZyaTVQUXcrTFZjSStPcmN0SFRnYTRhTTYrdUN1em5wWTdBWngrbUNiQ2JE?=
 =?utf-8?B?WnlFR0wxOGdCeHFCU3piMkxXUDdKMCsrL1ZTZU0wRWZ3Mk0ybHQ0WWpMTHdT?=
 =?utf-8?B?cmYxZTdzd2JJdGlxaWI5dXVwL3VpQVdvaEVsb01ZVkVpOUExeTExSHp5QVYv?=
 =?utf-8?B?bVlzZmp1QU9pbkN1QlloMFExNzR3dHFPcFhEZ3FqKzVXY2ozck9zSU00cDBx?=
 =?utf-8?B?UXVQWUtxOWxzV0hrb1AxUjhNYko4RXJNVGJrOWxXZXVWdUFSVW12TlcxaVJq?=
 =?utf-8?B?dTltWUswZ1BnK01uOGh3SDNTbHE0MG1zTFRGV3BLbzFMQnF2cmNibWZscU0r?=
 =?utf-8?B?ZW94Mm5SNXhnSXJXYkdaSEhWeFFKTVdhUC91VWxVdSttMXM2NEIwUHkwQlVV?=
 =?utf-8?B?Vm5NOWdxQzlza2dRSzdSMkl4MVErcUJZN28wRGtrby9SVWlkdFdIbGpFYTd4?=
 =?utf-8?B?Yk5iQWZUWWord2t6eC9BQzVvVTdWLzgybm83N3lCbHRqelpNWVpJbi9qUzF3?=
 =?utf-8?B?NThQYXV1Y0Z1OVp4SEU1MTl4VFg0RXMrMmJiZmtBWEJ2bkdKUWdaNGlsQWtu?=
 =?utf-8?B?RVFWbitHSGZGOXJDbXpmaFI2akJFZDJ2TEI3M3BTemZUZ0lTdzlFcWtRMUMv?=
 =?utf-8?B?WmoyOUYrV0FzUXdDUG5hZkdBclhHTzdxRkpiQUpDMHh0bzgvRlA0UjFtSCtv?=
 =?utf-8?B?dnc0L3NpQlpVL3pWcy8xYUQ1ekZZbzdTMTlrcmVOcEN3TXcrNmhuUVphcXNY?=
 =?utf-8?B?eFpjQTVveFRWc1M4OXpsV1Q3WFJTc3dMTzZnakM4SFlidHBQSjVpckN4K2tX?=
 =?utf-8?B?UG1SOWRrakl0ZXo4SXNmTmlHZ1ZYTmpYN0JqWStPS3h3b1hCeDlaVFRPM1Ix?=
 =?utf-8?B?cW1hUGE5bnJDYzZRamdBOXBEWkFTdk94ZlpkWDhSN2F1QWc1bEhaUytuUkR3?=
 =?utf-8?B?RGUxbkN4NzZGTURkTFdZNW4wTUJkZ0lHNXZEd003TFdpWXFGNDc4MkhjeElp?=
 =?utf-8?B?TEtKa3BEYmpYMkt0ZEtnWnRBY2FGek5qVmN0MUZJNnFoOVNLL1N2RU12ZWk5?=
 =?utf-8?B?ZWpVM2h0aWpBQVlTYW5XSElqWWd2QTducytob1Y3NFh3UTJwZjNKL0pzRkky?=
 =?utf-8?B?WXZTNllTaTMyMXFDU1ZoMkNZb2NDT2ExakdkNU1SYVVRdFZVd3NJOVc4b045?=
 =?utf-8?B?bTdKODJocmdQd2MxZFJRUFBOSDZaVzVRMytCMksyYllVME9lcjdWTGcyd1pm?=
 =?utf-8?B?N3NoOXpvSFB2ZW1GNFI5SGcvTzJsRXM0aEdzdEFsSjg5YVdjVjIydk5xajVi?=
 =?utf-8?B?dnFCUExsV3BpMU02TFhPbGo3dTQxRXF5eTdFYU5pTENRNWIwKzRzZEYvZTlO?=
 =?utf-8?B?TzF6ZzQ3bjZ3b1ptdFR3NkN6ZXF1OVpZcFZEcmQ5Rkk0RjJ4SjMvOFF1MGVx?=
 =?utf-8?B?UnI0ajJEc2hQd0g0ajgwY3FSL3ZvRHVUamh5RzZIY3JQRkpERG15KzkrWGZM?=
 =?utf-8?B?QTBvOHNicU14ZEZnMnFHUVl1OVBKbWNyMU5hUHdQanBsRm1NTzNzZDNyMFBS?=
 =?utf-8?B?RzFGbjJ6UGx0REtLTzN0WnR3amo1M3dMOWtEZEtacDVHRUtocXlXajNtSUMw?=
 =?utf-8?B?c3hzYXJUYUtBTDlVc2Y5RzB2RTJuZExNYVJUa1BsZ0d1UFNlcUpPTklyVU9V?=
 =?utf-8?B?dlN6ZEFPZTVJa1NQL1UyZWlsbDBaZTRvZ2VIaUNhOFhOajlBVWZyb1UyYWFr?=
 =?utf-8?B?OE5wb0ZzTG9UbHJEbFgxaVlXOWdDbUdCeTJDYW52ZFBYN2xyb1FsMGN2TGU5?=
 =?utf-8?B?eEtubmxOZE5YSDFEcndTaTF5TmsvMlV4OGRJRTNEL3dvWjl4dFpZSGwwbW9r?=
 =?utf-8?B?SllFV3B6TU1QQ1JNQUkzL2d6TVRaT3Npb1dGZ0x5dTNJODBPcC9yZWY1bzlV?=
 =?utf-8?B?TjhnYzVaYVRzWEtkK0oxQTVHdDZGQWQ4TEZSMjlkYm8xa042VVEramQ2QU1y?=
 =?utf-8?B?emNTWFpNWGphZ04wYmZIM2M5WXcxdGN0OEJIWlJzbjRiQ2gvR0lNOVU4d2dS?=
 =?utf-8?B?UU84aUFlMlZxTnAwc2grV2ZwTjcycUJHeVgrcHVhbmp4Rlg5TXlXc0x6dngv?=
 =?utf-8?B?WGNqMzVlMVNlS0xZZkpEMEVTaHlHRXpZT2gzV2JBRGgwRi95SnZFdz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c65417f-331d-4126-ae40-08df0f690707
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 18:26:27.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqzoGaZlfPefNX43fGYD0kpyI7CEiutmMtW8YXLc5jmzBqHncWAY+xBgHh5Hu/8yTfQLWDBZAfd/I0kZWkqK/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P123MB2859

On Thu, Sep 10, 2026 at 12:42:28PM -0400, Aaron Tomlin wrote:
> Hi Thomas, Jens, Sebastian, Frederic,

Adding Daniel, Martin, and Hannes on Cc.

> This is version 16 of the series enabling multiqueue devices and managed
> interrupts to adhere to CPU isolation constraints. The series has been
> rebased on v7.3-rc1-708-g893e11787f78.
> 
> Background and Problem
> ======================
> 
> Modern multiqueue storage controllers (e.g. NVMe devices) typically
> allocate as many hardware queues and interrupt vectors as there are CPUs in
> the system. When CPU isolation is requested via isolcpus, the kernel's
> current mechanism "isolcpus=managed_irq" relies on post-allocation affinity
> steering inside kernel/irq/manage.c. However, because drivers allocate
> queues and vectors before affinity steering takes place, the number of
> vectors frequently matches or exceeds the total CPU count. In such
> scenarios, the post-allocation steering logic cannot avoid assigning
> managed interrupts to isolated CPUs, effectively defeating CPU isolation
> for real-time and latency-critical workloads.
> 
> Proposed solution and architecture
> ==================================
> 
> This series introduces a new CPU isolation feature,
> "isolcpus=managed_irq_strict", designed to protect isolated cores from the
> disruptive hardware interrupts generated by high-performance multiqueue
> devices.
> 
> To prevent I/O stalls, the block layer is additionally hardened to reject
> hotplug requests that attempt to offline a housekeeping CPU if it is the
> last remaining CPU actively serving an online isolated core.
> 
> The complex "top-down" mask plumbing introduced in earlier revisions
> (version 12), which modified struct irq_affinity and expanded block layer
> APIs, has been abandoned. It is replaced by a centralised approach: direct
> isolation querying via housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT)
> within the genirq/affinity subsystem. This architectural simplification
> successfully decouples core changes from driver-specific implementations.
> 
> 
> In version 15, this was addressed under the previously named
> "isolcpus=io_queue". During subsequent review, Sebastian Andrzej Siewior
> pointed out that the existing "isolcpus=managed_irq" implementation is
> fundamentally broken on modern multiqueue hardware, and raised the question
> of whether we should introduce another flag at all, or instead fix
> "managed_irq" directly in place. As Sebastian observed, if
> backward-compatibility concerns prevent modifying the legacy behaviour, a
> "managed_irq_strict" designation represents the logical counterpart.
> 
> To make progress while keeping backwards compatibility completely safe,
> this iteration adopts option 2: we drop the "io_queue" naming in favour of
> "isolcpus=managed_irq_strict". It acts as the strict, pre-allocation
> counterpart to "managed_irq", constraining both block layer queue mappings
> and generic interrupt affinity masks exclusively to housekeeping CPUs.
> Furthermore, if both options are supplied, "managed_irq_strict" takes
> precedence.
> 
> Maintainer guidance requested
> =============================
> 
> We would appreciate guidance from Frederic Weisbecker regarding preference
> on this front:
>         1.  Do you prefer keeping "managed_irq_strict" as an explicit
>             opt-in (as implemented in this series) to preserve historical
>             behaviour for existing users of "managed_irq"?
> 
>         2.  Or would you prefer upgrading the semantics of "managed_irq"
>             directly in place without introducing a new parameter, on the
>             grounds that the legacy post-allocation behaviour is already
>             broken for modern multiqueue hardware?
> 
> 
> Please let me know your thoughts.
> 
> Changes since v15:
> 
>  - Migrated feature naming from "isolcpus=io_queue" (HK_TYPE_IO_QUEUE) to
>    "isolcpus=managed_irq_strict" (HK_TYPE_MANAGED_IRQ_STRICT), establishing
>    it as the strict, pre-allocation counterpart to "managed_irq"
> 
>  - Specifying "managed_irq_strict" automatically enables
>    HK_FLAG_MANAGED_IRQ so that dependent subsystems continue to function
> 
>  - Cleaned up commit bodies across the series, stripping informal
>    scratchpads and adding Co-developed-by attribution where appropriate
> 
>  - Added new patch 4/9 ("sched/isolation: Prevent out-of-bounds read in
>    isolcpus= boot parameter parser"). Incorporated prerequisite bugfix
>    resolving an out-of-bounds read in housekeeping_isolcpus_setup() when
>    sub-parameters lack trailing commas
> 
>  - Defined HK_TYPE_MANAGED_IRQ_STRICT and HK_FLAG_MANAGED_IRQ_STRICT.
>    Ensured HK_FLAG_MANAGED_IRQ is set when managed_irq_strict is enabled
> 
>  - Decoupled queue mapping from dynamic cpu_online_mask; eliminated the
>    blk_mq_validate() check and online cpumask snapshotting to avoid TOCTOU
>    races during concurrent CPU hotplug events
> 
>  - Added cpuhp_tasks_frozen check to ensure suspend, hibernation, and
>    resume transitions are not aborted
> 
>  - Added blk_mq_map_queue_type() check so CPU offline validation only
>    evaluates hardware contexts actively mapped to the CPU being offlined
> 
>  - Enhanced warning message to report the offending CPU ID and queue
>    number
> 
>  - Prioritised affd->calc_sets in irq_calc_affinity_vectors() so multi-set
>    drivers scale vector allocations with requested set sizes to prevent
>    cross-queue contention, while vector spreading remains strictly
>    constrained to housekeeping cores
> 
>  - Documented "managed_irq_strict" in kernel-parameters.txt, detailing its
>    role in blk-mq queue distribution and genirq affinity masking, as well
>    as its superset relationship with legacy "managed_irq"
> 
>  - Link to v15: https://lore.kernel.org/lkml/20260521232956.553287-1-atomlin@atomlin.com/
> 
> Changes since v14:
> 
>  - Fixed a division-by-zero by ensuring group_mask_cpus_evenly() safely
>    frees its allocations and returns NULL instead of an empty array if the
>    provided mask yields zero groups.
> 
>  - Fixed a device probe -ENOSPC regression in blk_mq_num_queues(). If the
>    housekeeping mask intersection evaluated to 0 (e.g., against a localised
>    NUMA node), min_not_zero() would erroneously return the absolute maximum
>    hardware queues. The result is now safely clamped to a minimum of 1.
> 
>  - Added a mapping verification check to prevent unrelated housekeeping
>    CPUs from aborting the global hotplug offline sequence.
> 
>  - Aligned the pr_warn format specifier with the unsigned int declaration
>    of hctx->queue_num in blk_mq_hctx_can_offline_hk_cpu().
> 
>  - Link to v14: https://lore.kernel.org/lkml/20260520215030.496803-1-atomlin@atomlin.com/
> 
> Changes since v13:
> 
>  - Removed ineffective data_race() annotations around mask and
>    cpu_present_mask pointers. Wrapping the pointers failed to suppress
>    KCSAN warnings for the underlying inline bitmap memory accesses.
> 
>  - Fixed a silent validation bypass in blk_mq_map_hw_queues() caused by
>    overlapping IRQ affinity masks by removing the short-circuiting
>    optimisation and evaluating the active_hctx bitmap in a secondary pass.
> 
>  - Restored topology-aware multi-queue fallback by correctly routing
>    missing IRQ affinity masks to the map_software path instead of the naive
>    map-all fallback.
> 
>  - Dropped hctx->queue->disk->disk_name from warning to avoid a UAF.
> 
>  - Fixed an isolation leak where excess allocated hardware queues were
>    improperly padded with irq_default_affinity. Because these queues are
>    marked as managed, they bypassed user-space IRQ balancing; they are now
>    safely padded with the housekeeping mask.
> 
>  - Enforced the housekeeping vector cap prior to evaluating driver-provided
>    calc_sets() callbacks, preventing modern multi-queue drivers from
>    bypassing the cap and wasting memory on dead queues.
> 
>  - Introduced a safety net to the vector calculation to prevent fatal
>    -ENOSPC device probe aborts on heavily isolated systems where the
>    housekeeping CPU count is lower than the device's structural minimum.
> 
>  - Removed an inaccurate claim stating that the io_queue isolation flag
>    takes precedence over managed_irq. Both flags are parsed, evaluated, and
>    enforced entirely independently by their respective subsystems.
> 
>  - Link to v13: https://lore.kernel.org/lkml/20260513005509.135966-1-atomlin@atomlin.com/
> 
> Changes since v12:
> 
>  - Resolved TOCTOU race conditions against CPU hotplug events in
>    blk_mq_map_queues() and group_mask_cpus_evenly() by taking lockless
>    snapshots of the online CPU mask prior to algorithmic evaluation.
> 
>  - Migrated the active_hctx tracking to a dynamically sized bitmap
>    (bitmap_zalloc), resolving a critical out-of-bounds memory write that
>    occurred when hardware queues exceeded the system CPU count.
> 
>  - Wrapped the disk pointer fetch in blk_mq_hctx_can_offline_hk_cpu() with
>    READ_ONCE() to prevent a TOCTOU NULL pointer dereference against
>    concurrent device teardowns.
> 
>  - Introduced bitmap_empty() checks to prevent the mapping logic from
>    routing unassigned CPUs into unallocated memory when all mapped CPUs are
>    offline, safely forcing a fallback mapping instead.
> 
>  - Implemented a native two-stage distribution logic in
>    group_mask_cpus_evenly() that first prioritises physically present CPUs
>    to prevent I/O starvation before distributing remaining vectors to
>    non-present CPUs for hotplug safety.
> 
>  - Restricted the maximum number of allocated vectors in
>    irq_calc_affinity_vectors() to the weight of the housekeeping mask,
>    preventing drivers from wasting memory on dead hardware queues that
>    physically cannot be routed.
> 
>  - Added padding logic using irq_default_affinity for sets where isolation
>    constraints yield fewer masks than requested vectors, preserving the 1:1
>    hardware queue mapping sequence for subsequent sets.
> 
>  - Fixed a logic flaw that prematurely rejected valid offline requests by
>    manually iterating over cpu_online_mask and reverse-mapping to
>    accurately detect isolated CPUs, properly permitting the offlining of
>    non-housekeeping CPUs.
> 
>  - Corrected an absolute versus relative queue index calculation bug in
>    blk_mq_map_queues() that was overwriting loop iterations, by iterating
>    directly over the generated masks.
> 
>  - Replaced scoped __free cleanups with traditional goto unwinding in the
>    block layer to align with subsystem styling guidelines.
> 
>  - Refined the io_queue kernel command-line parameter documentation for
>    better clarity and precision.
> 
>  - Link to v12: https://lore.kernel.org/lkml/20260422185215.100929-1-atomlin@atomlin.com/
> 
> Changes since v11:
> 
>  - Removed duplicate paragraph from the commit message in patch 11
>    (Marco Crivellari)
> 
>  - Ensure ZERO_SIZE_PTR is not returned by group_mask_cpus_evenly()
>    (Marco Crivellari)
> 
>  - Link to v11: https://lore.kernel.org/lkml/20260416192942.1243421-1-atomlin@atomlin.com/
> 
> Changes since v10:
> 
>  - Completely rewrote the isolcpus=io_queue documentation in
>    Documentation/admin-guide/kernel-parameters.txt to clarify its exclusive
>    application to managed IRQs, queue allocation limits, vector exhaustion
>    prevention, and hardware interrupt routing (Ming Lei)
> 
>  - Fixed a stack frame bloat issue by avoiding the on-stack declaration of
>    struct cpumask (Waiman Long)
> 
>  - Link to v10: https://lore.kernel.org/linux-nvme/20260401222312.772334-1-atomlin@atomlin.com/
> 
> Changes since v9:
> 
>  - Fixed a page fault regression encountered when initialising secondary
>    queue maps (e.g. NVMe poll queues). Restored the qmap->queue_offset to
>    the mq_map assignment to ensure CPUs are strictly mapped to absolute
>    hardware indices (Keith Busch)
> 
>  - Corrected the active_hctx tracker to utilise relative queue indices,
>    preventing out-of-bounds mask assignments
> 
>  - Fixed the blk_mq_validate() sanity check to properly evaluate absolute
>    queue indices against the offset-adjusted loop index
> 
>  - Corrected typographical errors within block/blk-mq-cpumap.c
>    (Keith Busch)
> 
>  - Clarified the commit message regarding the removal of the !SMP fallback
>    code, explicitly noting that the core scheduler now mandates SMP
>    unconditionally (Sebastian Andrzej Siewior)
> 
>  - Added missing "Signed-off-by:" tags to properly record the patch series
>    chain of custody
> 
>  - Link to v9: https://lore.kernel.org/lkml/20260330221047.630206-1-atomlin@atomlin.com/
> 
> Changes since v8:
> 
>  - Added "Reviewed-by:" tags
> 
>  - Introduced irq_spread_hk_filter() to safely restrict managed IRQ
>    affinity to housekeeping CPUs (Thomas Gleixner)
> 
>  - Removed the unsafe global static variable blk_hk_online_mask from
>    blk-mq-cpumap.c and blk-mq.c. blk_mq_online_queue_affinity() now returns
>    a stable pointer, delegating safe intersection to the callers to prevent
>    concurrent modification races (Thomas Gleixner, Hannes Reinecke)
> 
>  - Resolved BUG: kernel NULL pointer dereference in __blk_mq_all_tag_iter
>    reported by the kernel test robot during cpuhotplug rcutorture stress
>    testing
> 
>  - Link to v8: https://lore.kernel.org/lkml/20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org/
> 
> Changes since v7:
> 
>  - Added commit 524f5eea4bbe ("lib/group_cpus: remove !SMP code")
> 
>  - Merged the new mapping logic directly into the existing function to
>    avoid special casing
> 
>  - Refined the group_mask_cpus_evenly() implementation with the following
>    updates:
> 
>    - Corrected the function name typo (changed group_masks_cpus_evenly to
>      group_mask_cpus_evenly)
> 
>    - Updated the documentation comment to accurately reflect the function's
>      behavior
> 
>    - Renamed the cpu_mask argument to mask for consistency
> 
>  - Added a new patch for aacraid to include the missing number of queues
>    calculation
> 
>  - Restricted updates to only affect SCSI drivers that support
>    PCI_IRQ_AFFINITY and do not utilise nvme-fabrics
> 
>  - Removed the __free cleanup attribute usage for cpumask_var_t allocations
>    due to compatibility issues
> 
>  - Updated the documentation to explicitly highlight the limitations
>    surrounding CPU offlining
> 
>  - Collected accumulated Reviewed-by and Acked-by tags
> 
>  - Link to v7: https://patch.msgid.link/20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org
> 
> Changes since v6:
> 
>  - Sent out the first part of the series independently:
>    https://lore.kernel.org/all/20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org/
> 
>  - Added comprehensive kernel command-line documentation
> 
>  - Added validation logic to ensure the resulting CPU-to-queue mapping is
>    fully operational
> 
>  - Rewrote the isolcpus mapping code to properly account for active
>    hardware contexts (hctx)
> 
>  - Introduced blk_mq_map_hk_irq_queues, which utilizes the mask retrieved
>    from irq_get_affinity()
> 
>  - Refactored blk_mq_map_hk_queues to require the caller to explicitly test
>    for HK_TYPE_MANAGED_IRQ
> 
>  - Link to v6: https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org
> 
> Changes since v5:
> 
>  - Reintroduced the io_queue type for the isolcpus kernel parameter
> 
>  - Prevented the offlining of a housekeeping CPU if an isolated CPU is
>    still present, upgrading this behavior from a simple warning to a hard
>    restriction
> 
>  - Link to v5: https://lore.kernel.org/r/20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org
> 
> Changes since v4:
> 
>  - Rebased the series onto the latest for-6.14/block branch.
> 
>  - Updated the documentation regarding the managed_irq parameters
> 
>  - Reworded the commit message for "blk-mq: issue warning when offlining
>    hctx with online isolcpus" for better clarity
> 
>  - Split the input and output parameters in the patch "lib/group_cpus: let
>    group_cpu_evenly return number of groups"
> 
>  - Dropped the patch "sched/isolation: document HK_TYPE housekeeping
>    option"
> 
>  - Link to v4: https://lore.kernel.org/r/20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org
> 
> Changes since v3:
> 
>  - Added the patch "blk-mq: issue warning when offlining hctx with online
>    isolcpus"
> 
>  - Fixed the check in group_cpus_evenly(); the condition now properly uses
>    housekeeping_enabled() instead of cpumask_weight(), as the latter always
>    returns a valid mask
> 
>  - Dropped the Fixes: tag from "lib/group_cpus.c: honor housekeeping config
>    when grouping CPUs"
> 
>  - Fixed an overlong line warning in the patch "scsi: use block layer
>    helpers to calculate num of queues"
> 
>  - Dropped the patch "sched/isolation: Add io_queue housekeeping option" in
>    favor of simply documenting the housekeeping hk_type enum
> 
>  - Added the patch "lib/group_cpus: let group_cpu_evenly return number of
>    groups"
> 
>  - Collected accumulated Reviewed-by and Acked-by tags
> 
>  - Split the patchset by moving foundational changes into a separate
>    preparation series:
>    https://lore.kernel.org/linux-nvme/20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org/
> 
>  - Link to v3: https://lore.kernel.org/r/20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de
> 
> Changes since v2:
> 
>  - Integrated patches from Ming Lei
>    (https://lore.kernel.org/all/20210709081005.421340-1-ming.lei@redhat.com/):
>    "virtio: add APIs for retrieving vq affinity" and "blk-mq: introduce
>    blk_mq_dev_map_queues"
> 
>  - Replaced all instances of blk_mq_pci_map_queues and
>    blk_mq_virtio_map_queues with the new unified blk_mq_dev_map_queues
> 
>  - Updated and expanded the helper functions used for calculating the
>    number of queues
> 
>  - Added the CPU-to-hctx mapping function specifically to support the
>    isolcpus=io_queue parameter
> 
>  - Documented the hk_type enum and the newly introduced isolcpus=io_queue
>    parameter
> 
>  - Added the patch "scsi: pm8001: do not overwrite PCI queue mapping"
> 
>  - Link to v2: https://lore.kernel.org/r/20240627-isolcpus-io-queues-v2-0-26a32e3c4f75@suse.de
> 
> Changes since v1:
> 
>  - Updated the feature documentation for clarity and completeness
> 
>  - Split the blk/nvme-pci patch into smaller, logical commits
> 
>  - Dropped the HK_TYPE_IO_QUEUE macro in favor of reusing
>    HK_TYPE_MANAGED_IRQ
> 
>  - Link to v1: https://lore.kernel.org/r/20240621-isolcpus-io-queues-v1-0-8b169bf41083@suse.de
> 
> Aaron Tomlin (2):
>   sched/isolation: Prevent out-of-bounds read in isolcpus= boot
>     parameter parser
>   genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs
> 
> Daniel Wagner (7):
>   scsi: aacraid: use block layer helpers to calculate num of queues
>   lib/group_cpus: remove dead !SMP code
>   lib/group_cpus: Add group_mask_cpus_evenly()
>   isolation: Introduce managed_irq_strict isolcpus type
>   blk-mq: use hk cpus only when isolcpus=managed_irq_strict is enabled
>   blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
>   docs: add managed_irq_strict flag to isolcpus
> 
>  .../admin-guide/kernel-parameters.txt         |  37 +++-
>  Documentation/core-api/housekeeping.rst       |   6 +-
>  block/blk-mq-cpumap.c                         | 163 ++++++++++++++++--
>  block/blk-mq.c                                |  63 +++++++
>  drivers/scsi/aacraid/comminit.c               |   3 +-
>  include/linux/group_cpus.h                    |   3 +
>  include/linux/sched/isolation.h               |   1 +
>  kernel/irq/affinity.c                         |  29 +++-
>  kernel/sched/isolation.c                      |  18 ++
>  lib/group_cpus.c                              | 112 ++++++++++--
>  10 files changed, 395 insertions(+), 40 deletions(-)
> 
> -- 
> 2.55.0
> 

-- 
Aaron Tomlin
