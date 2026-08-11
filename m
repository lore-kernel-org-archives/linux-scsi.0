Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ED72AD00;
	Tue, 11 Aug 2026 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786458365; cv=fail; b=B2V28jSoA60QfoaUIWwhFrKSrillUZvfuxmeGsKimfrSovXiH9XaNpB1j6FKV8PbyZsR9t7fkjv1/iEGq7qEjMjUq/gNVR+ejFl9oDnUfbApBIPA6ct0UQDsE7da44sy5yZPPvZ/2F+GUrudmpEvatBSnCGnF1+4BsjUkVsKBrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786458365; c=relaxed/simple;
	bh=5P66ELHW+kuTtD+yiYVtJOwgt407FsTkr28BS6/EYSE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fzW0QujtFmKnvU9/bqzSLeTUqkcMGExvicnQU9dGvJjRHmB59pPQ90z708bXTLXvG6sdclKM6XTEdEFgcPLqsYQJQ5/eNo7p0DHdpQWzVhlZgEKkHCJGGgtd4zKRS1cI2UKJ4MK6FwHykzOlUL4D0QVDMDMp/lMp5kqKOUurqUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WBpzkKm2; arc=fail smtp.client-ip=52.101.57.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WBpzkKm2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQ+O0raNhMJvxMXvTNfdQrHHX1/EZGJyOsuvYoZSDfi436iQRoZCifRpSNN7ENtLhp+pFfddaQOaBNG5gAQDsYzE7ZvWIMtp9BMAvxGLNpky+sEPDvQqnS+bOZB7FTCuPv2+AiqxCzj2Cy2FYvnyl8Dekf9yUqgCW2kbT8nhK/bWRFB4vjKai+GMFF/DHoal2rUtzvBsvS7bNpj9xObaSLi3ScbWfePUpB9vvnHYVe55NV0N5jw6iT/DynfiqcMgDqYkMZ2oGaFK3kQjR7A9MIHvea/5WBg9VAJpsNAeC9cqIPX6KGPK8JaZ1ks0h5ddWqDtSIFiBbhcceUIBbf4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lIe5PD7kYFCQLG2Th1SAANT3Q3n6dwSXPufWFRYVC4=;
 b=Mt5sASykltXMgu58ltznvFG8okNgYiDli6HSks//fZy6fH86+4cl30rF/N8DI5NJHZz0BwN2qT59fTEa38yRK/DB45VAV5zz2cQvN8jlmI/59fi5JEJ1BwIZ39fuwvHsF9X0mOD0ld+AOHsGDi+ozbcM2FK38s0A7i43US0U3y015S24wHnr/hb3ZM2cBCOro7bYgOqn1YOvbOHha0hZJ6+PrUYRcGHmvO/od5d8y28ZNqn28Yc8+dFrMR2mBLaVbEgJOaPPULDRmcVl3oy3Nn5ThLvNyjDkptKAukfuwrvalUGIGp2Kr7JIR8cFXAd4N8tJGWO0qDNt+x/HJeh7/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lIe5PD7kYFCQLG2Th1SAANT3Q3n6dwSXPufWFRYVC4=;
 b=WBpzkKm2BWGiz74rRlo/0Iv6wIhUlMXovYlxXfll/eRwNkTk+3uWNyUYzaHi/kM9cIF0rC1moE++IivkofTCDMY8drtJN1knFrqNgdx+qVyhsD9p5lpkVC5+45BGUR5wI6T25irIGDYKWejYG/8axtSsniiY2iibn/SaF9g1T20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB9060.namprd12.prod.outlook.com (2603:10b6:8:c4::12) by
 DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.11; Tue, 11 Aug 2026 14:25:55 +0000
Received: from DS0PR12MB9060.namprd12.prod.outlook.com
 ([fe80::e096:864d:d60a:c83f]) by DS0PR12MB9060.namprd12.prod.outlook.com
 ([fe80::e096:864d:d60a:c83f%4]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 14:25:55 +0000
Message-ID: <6cf0791d-902d-4a89-bb57-d4c607991579@amd.com>
Date: Tue, 11 Aug 2026 19:55:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] firmware: xilinx: ufs: move PHY/SRAM ready polling into
 the firmware backend
To: Michal Simek <michal.simek@amd.com>, linux-kernel@vger.kernel.org,
 monstr@monstr.eu, git@amd.com
Cc: Ajay Neeli <ajay.neeli@amd.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "moderated list:ARM/ZYNQ ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
References: <eaeaaea8ed76069943e0706a0917139ff6569929.1785855749.git.michal.simek@amd.com>
Content-Language: en-US
From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
In-Reply-To: <eaeaaea8ed76069943e0706a0917139ff6569929.1785855749.git.michal.simek@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0160.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ba::8) To DS0PR12MB9060.namprd12.prod.outlook.com
 (2603:10b6:8:c4::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB9060:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ccd2670-ceac-4f16-d510-08def7b47450
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JXLHuav/43fhrEfpvX5I7reqmJkn8knognbxR7rSBeZbraq57ipMoYvX+Wmms3DZztxE7G1uAYRtXNae5MWMI81MbGJNrjvdKZ2GLg1SpBt34ZqvnBciDkcR8DE6RhGsLEdjpr67m0+IUDCMg8dOSVTfw9vlsMyrx8FFc+qicSBvKqkhJH8zzwzcDY8/XpbJA0I04Hw1w5l5RO7NdYc6BUyc1lm9i0t15OgffuZBnJX6Cs8UeQRdkKLouLDcxl8/LXv1UvKeGqXYCH7PUzzZl+Mo4D/odsDnrKfhYy9M8C+pmtrQ8FBtP50VO+rRTCCQ5l/YcbnMMii3Ss/DD6qxMy5s9tlxGmdtgv12S6peaImF+UJDROnd1AQL4at+1M/pvQqayECoAlfKq9KEFaVTFEfBDVgdVCEyp8Qyew+PmWA9uqb50aSlRTZE5LUCYztNhGNXJkXlU+sm1TqpvhVcLMpc/9KJegh/7YUT+7zkEbwiKtvzzOwaiyAduvl7hX72D1D7qNomYrDhzGzQO9gad4uUZlzLy4svGz34O8uusznzkIn2loPx0K9O2USYU7+u2aTxdG9rJBsjym8ZBBm/b4uRQGxkr0w8tmmLMVTHqu3Rn0nMjIyro/eTFpPl7EtiXJIcvAmoZ4L1XJQGqfEloxyXn6u3+9D63ESUKAr2rxI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9060.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVZOa0tweTJMcWsrc1VjY2M1MVVydStEQzA5a0VENkw4ZzZFMkFMQkIxU0NS?=
 =?utf-8?B?cHE3MmRnNW9YbldrdERzYi9UeFNrTUF5dHdwWS9FNDk3NEJrbEJHdkplYVBT?=
 =?utf-8?B?OFpXZDNnbnhnUjhtYzIxZEVJc3AyREN4YVEwMFZtMVRPdGQ2SXdUeFlFUjhW?=
 =?utf-8?B?cWhML0N0OFdQODhOVDdqNTcxWUljZnZpckhMaENvKzBrYkJuMDFBRnNhQWN4?=
 =?utf-8?B?ZCtFd24wWE1STTdVL0tOQXgyVjg4clFBZG5hQitYdnhodUdwMkVLZ0pqbk82?=
 =?utf-8?B?L2lVdFNCUWFkZnVUS3d6N2pzMHVQMDI0bitBV01GS2NsMDNKRzM3dEZKdU8r?=
 =?utf-8?B?bHo1Mml6RnJTeHNRL3YxaW9IVUs4RFh3ZmoxYVRkdzJaQjNaQUpXaUg1ZjNC?=
 =?utf-8?B?RHdwaEUwcU5qd0loRk5HaXRXekRFVTZJOWxtOXV1TmdxM01pYUlPc1FwTWJ3?=
 =?utf-8?B?QXZwMEpMbEhTcHRwUVdSdGJKVGxjR1FTQ0lJV3I0Y0xlSUtSLzE3RTdadXh0?=
 =?utf-8?B?cHJZemxDWEd2Z0FSTlM0S2IrQVZtU2pyVW14YUdHS1Rxbm9GcUczQk9qdUJn?=
 =?utf-8?B?ZjdVMUFidlFuT1l4Z1dFbWFxZGFzTFVnRE9lM0xwd2hDOWpYSWZjS3ZZdUIz?=
 =?utf-8?B?Z0dmTFI1S080WUIyRlJpeWYrUFA3SHFDSkhEQXJLQnZicTd0a3RjU21wY29m?=
 =?utf-8?B?TnRNMXY1UkZOV05udVk3bFgvdVozOWtwUlJhSXJteHZ5azI0QnJBWGY5RmFP?=
 =?utf-8?B?QVRhOU1udzZpaGFOME5vQWNYWjNsK1JpaWtOWnVOSGRuZGVwR1RpUGU5K2gr?=
 =?utf-8?B?MTU3SW0vNUx5TDlWVCt0VDVvYVoxOHFrcEpBdzNTSndLN3gwNHdvMUpaaUhq?=
 =?utf-8?B?cTJONVpDOVYySm9iM2Z6OGJDcHRjYmRLRWtJeXo0MjVKa0Q1STFISTRVR1Ny?=
 =?utf-8?B?SlVTUG9qdlRBUnJVZkhhTlk0TXFlZjFwY0NjV3FxQm5nWG5BN05XemRxRWNC?=
 =?utf-8?B?T3N3d3hCSjRaZWxTU2RVWnk0dUpYUjNKa1d5U3BobU9VNElyVVBhaWs5NWtu?=
 =?utf-8?B?RnVaKytUT0tNWWVYdnRBVENrUU83MXNueGpuZUpuMGV6VjFBblUrOWtMQ0VH?=
 =?utf-8?B?a01UVHdPMHpkYWVNTnB4UGJ3UlB5Z3d5MlhYZlZBZFlYVTJ0Mzh3aUdydmhN?=
 =?utf-8?B?dXQrSVgrZUNndXJQS3ZnVE9xME84RlBSbDZYSWFHVTQ1cFcwM2Z1MTJQb1Z1?=
 =?utf-8?B?cFhWUzlPZ0c1d1hpTTNDc2VKY2xoVXFXTFRVZ3pxd1crTHUxeUlPTHJMN2hF?=
 =?utf-8?B?ME5oa280YjN6VE9UWjFabW5TbzR4WDBOZ2dYanhSQlYrUlFWc0p4TzgwY3dC?=
 =?utf-8?B?YUdQekJFbWd5cHpQM1R2dkcxWHZmVWR6NlZLb2ZHSWNPdGgyeGVTWDRGRDU4?=
 =?utf-8?B?TTBPbkFvM1c0NXVBOUtPQWlmTGQzYWV4QnV1elJRZSt3T3NyaWRobjFtWkFk?=
 =?utf-8?B?TGZqWjFiRU4reEcwTEJmOGxyNW9YMUszN1B3UTJsME5TN0xoOFYxaE1Ebm5Y?=
 =?utf-8?B?UW5zM2k3U0ZZSG5WRjErOFVwdWl4Y1dKcXhCRFQvb3NGMG9EK3pTTE9taGdN?=
 =?utf-8?B?aDVHZFpCcW5HZVF6R1ZrWVQzdE1iS0VhZkVQWWFnSExpVm9OOGN4MDFMUVpX?=
 =?utf-8?B?S0QrZU1JN2crdXkyMmJTMnlzQXFqNEJhTERackhOTkdzSVRFMEpFK25iNFY1?=
 =?utf-8?B?N0plL1ZielhjVkdWbXdxNzVGWHpQRVhMMGdxZjVZWkFNUGdsUVFkMFJ2M3VG?=
 =?utf-8?B?YU96bUZLZnZja0orTHhoRlBNRTZaUW1HQ2FUT080Q0x1bHc4alEyQW01SDNO?=
 =?utf-8?B?MU8weUpFSnQxSk5tVDNzVVc4VlcwNnpMc3poZWJ5S1B2OXliUVZlQ2h4dGdK?=
 =?utf-8?B?dlRLWmgyMFV0RmdyM3dXN25hbjdWQ2o0enlhUlNxSkhiQVVFWktmc3YzVnlR?=
 =?utf-8?B?MnhTbWg5T2FucVRFcXM2SWV2RDF5MC9JbFFhVmIzckNIdm5pQXBpZVIxMWoy?=
 =?utf-8?B?SnMvbmVIRXhKbGp2MnBqWHdsbWN0bjcyalBzdGRLNi82eXhrbFRHbjByNU96?=
 =?utf-8?B?Mll0aW9qM1A2R0N3ZnFpQVBHQ09hSUpLVlVRT3FRZFpYK3JRVWc4c21ydllq?=
 =?utf-8?B?QTRRTTdEMDNyVmFiNDluQWVpWG5yV1pTWEkrS1JES09hMHAyb2dKM3ZaOGdI?=
 =?utf-8?B?YmZLWWw0Nm9oTzQ4aGJSeUtGdGhkcVNMdHQ1L1Y5WldSR3dyWnc0RFhtN2hP?=
 =?utf-8?B?eGF4WndWYzdsM3VHRHRaOEN2T1M0L2VuMUd4S3pzWjZFcytHRHdQQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccd2670-ceac-4f16-d510-08def7b47450
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9060.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 14:25:55.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xK6l9I/nqRv4rZCQqPyuDCCzJDBCQmGfhWbCzd7+qh22cz3sJ+MLEyvZgwGGtcc1ODTetKt1sgOwnk9CbkPy2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851



On 8/4/2026 8:32 PM, Michal Simek wrote:
> The Versal Gen 2 UFS driver polls the firmware for M-PHY TX/RX
> configuration readiness and SRAM initialisation completion with two
> open-coded do/while loops. Each iteration is a full firmware round-trip
> (PM_IOCTL/IOCTL_READ_REG of a protected PMC_IOU_SLCR register), so the
> loop can issue up to a million EEMI calls, and it hard-codes the wait
> policy inside the controller driver.
> 
> Introduce coarse blocking helpers, zynqmp_pm_wait_mphy_tx_rx_config_ready()
> and zynqmp_pm_wait_sram_init_done(), that take a caller-supplied timeout
> budget and contain the poll loop. The loop is EEMI-specific (legacy
> firmware only exposes the per-read status primitive) so it lives in the
> firmware driver, keeping the UFS driver backend-agnostic: a future
> backend can offload the wait to the platform in a single call without
> touching the controller driver again. The existing per-read primitives stay
> exported, so the current EEMI interface is unchanged.
> 
> The timeout budget remains owned by the UFS driver (the consumer that
> knows the hardware) and is passed down, so EEMI and any future backend
> stay consistent.
> 
> Signed-off-by: Michal Simek <michal.simek@amd.com>

Reviewed-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

Regards
Sai Krishna

> ---
> 
>   drivers/firmware/xilinx/zynqmp-ufs.c     | 70 ++++++++++++++++++++++--
>   drivers/ufs/host/ufs-amd-versal2.c       | 46 ++++------------
>   include/linux/firmware/xlnx-zynqmp-ufs.h |  8 +--
>   3 files changed, 82 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/firmware/xilinx/zynqmp-ufs.c b/drivers/firmware/xilinx/zynqmp-ufs.c
> index 85da8a822f3a..81ccf61a037c 100644
> --- a/drivers/firmware/xilinx/zynqmp-ufs.c
> +++ b/drivers/firmware/xilinx/zynqmp-ufs.c
> @@ -5,6 +5,7 @@
>    * Copyright (C) 2025 Advanced Micro Devices, Inc.
>    */
>   
> +#include <linux/delay.h>
>   #include <linux/firmware/xlnx-zynqmp.h>
>   #include <linux/module.h>
>   
> @@ -33,7 +34,7 @@
>    *
>    * Return:	Returns 0 on success or error value on failure.
>    */
> -int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
> +static int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
>   {
>   	u32 regval;
>   	int ret;
> @@ -53,7 +54,6 @@ int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
>   
>   	return ret;
>   }
> -EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);
>   
>   /**
>    * zynqmp_pm_is_sram_init_done - check SRAM initialization
> @@ -61,7 +61,7 @@ EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);
>    *
>    * Return:	Returns 0 on success or error value on failure.
>    */
> -int zynqmp_pm_is_sram_init_done(bool *is_done)
> +static int zynqmp_pm_is_sram_init_done(bool *is_done)
>   {
>   	u32 regval;
>   	int ret;
> @@ -81,7 +81,69 @@ int zynqmp_pm_is_sram_init_done(bool *is_done)
>   
>   	return ret;
>   }
> -EXPORT_SYMBOL_GPL(zynqmp_pm_is_sram_init_done);
> +
> +/**
> + * zynqmp_pm_wait_mphy_tx_rx_config_ready - wait for M-PHY TX-RX config ready
> + * @timeout_us:	Caller-supplied timeout budget in microseconds
> + *
> + * Poll the M-PHY TX-RX configuration-ready status until it settles or the
> + * timeout elapses. The poll loop is EEMI-specific (legacy firmware only offers
> + * the per-read status primitive), so it lives here in the firmware driver
> + * rather than in the UFS controller driver; an SCMI-based backend can instead
> + * offload the wait to the platform in a single call. The timeout budget is
> + * owned by the caller (UFS driver), keeping the policy with the consumer.
> + *
> + * Return:	Returns 0 once ready, -ETIMEDOUT on timeout, or error value.
> + */
> +int zynqmp_pm_wait_mphy_tx_rx_config_ready(u32 timeout_us)
> +{
> +	bool is_ready;
> +	int ret;
> +
> +	while (timeout_us--) {
> +		ret = zynqmp_pm_is_mphy_tx_rx_config_ready(&is_ready);
> +		if (ret)
> +			return ret;
> +
> +		if (!is_ready)
> +			return 0;
> +
> +		usleep_range(1, 5);
> +	}
> +
> +	return -ETIMEDOUT;
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_wait_mphy_tx_rx_config_ready);
> +
> +/**
> + * zynqmp_pm_wait_sram_init_done - wait for SRAM initialization to complete
> + * @timeout_us:	Caller-supplied timeout budget in microseconds
> + *
> + * Poll the SRAM initialization-done status until it is set or the timeout
> + * elapses. As with the M-PHY wait, the poll loop is EEMI-specific and kept in
> + * the firmware driver so the UFS controller driver stays backend-agnostic.
> + *
> + * Return:	Returns 0 once done, -ETIMEDOUT on timeout, or error value.
> + */
> +int zynqmp_pm_wait_sram_init_done(u32 timeout_us)
> +{
> +	bool is_done;
> +	int ret;
> +
> +	while (timeout_us--) {
> +		ret = zynqmp_pm_is_sram_init_done(&is_done);
> +		if (ret)
> +			return ret;
> +
> +		if (is_done)
> +			return 0;
> +
> +		usleep_range(1, 5);
> +	}
> +
> +	return -ETIMEDOUT;
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_wait_sram_init_done);
>   
>   /**
>    * zynqmp_pm_set_sram_bypass - Set SRAM bypass Control
> diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
> index 2154d6286817..dff0c2c95486 100644
> --- a/drivers/ufs/host/ufs-amd-versal2.c
> +++ b/drivers/ufs/host/ufs-amd-versal2.c
> @@ -225,8 +225,6 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
>   static int ufs_versal2_phy_init(struct ufs_hba *hba)
>   {
>   	struct ufs_versal2_host *host = ufshcd_get_variant(hba);
> -	u32 time_left;
> -	bool is_ready;
>   	int ret;
>   	static const struct ufshcd_dme_attr_val rmmi_attrs[] = {
>   		{ UIC_ARG_MIB(CBREFCLKCTRL2), CBREFREFCLK_GATE_OVR_EN, DME_LOCAL },
> @@ -235,23 +233,15 @@ static int ufs_versal2_phy_init(struct ufs_hba *hba)
>   		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>   	};
>   
> -	/* Wait for Tx/Rx config_rdy */
> -	time_left = TIMEOUT_MICROSEC;
> -	do {
> -		time_left--;
> -		ret = zynqmp_pm_is_mphy_tx_rx_config_ready(&is_ready);
> -		if (ret)
> -			return ret;
> -
> -		if (!is_ready)
> -			break;
> -
> -		usleep_range(1, 5);
> -	} while (time_left);
> -
> -	if (!time_left) {
> +	/*
> +	 * Wait for Tx/Rx config_rdy. The poll loop lives in the firmware
> +	 * backend (EEMI today, SCMI in future) so this driver stays
> +	 * backend-agnostic; the timeout budget stays here with the consumer.
> +	 */
> +	ret = zynqmp_pm_wait_mphy_tx_rx_config_ready(TIMEOUT_MICROSEC);
> +	if (ret) {
>   		dev_err(hba->dev, "Tx/Rx configuration signal busy.\n");
> -		return -ETIMEDOUT;
> +		return ret;
>   	}
>   
>   	ret = ufshcd_dwc_dme_set_attrs(hba, rmmi_attrs, ARRAY_SIZE(rmmi_attrs));
> @@ -264,23 +254,11 @@ static int ufs_versal2_phy_init(struct ufs_hba *hba)
>   		return ret;
>   	}
>   
> -	/* Wait for SRAM init done */
> -	time_left = TIMEOUT_MICROSEC;
> -	do {
> -		time_left--;
> -		ret = zynqmp_pm_is_sram_init_done(&is_ready);
> -		if (ret)
> -			return ret;
> -
> -		if (is_ready)
> -			break;
> -
> -		usleep_range(1, 5);
> -	} while (time_left);
> -
> -	if (!time_left) {
> +	/* Wait for SRAM init done (poll handled by the firmware backend). */
> +	ret = zynqmp_pm_wait_sram_init_done(TIMEOUT_MICROSEC);
> +	if (ret) {
>   		dev_err(hba->dev, "SRAM initialization failed.\n");
> -		return -ETIMEDOUT;
> +		return ret;
>   	}
>   
>   	ret = ufs_versal2_setup_phy(hba);
> diff --git a/include/linux/firmware/xlnx-zynqmp-ufs.h b/include/linux/firmware/xlnx-zynqmp-ufs.h
> index d3538dd5822a..00383dd835f2 100644
> --- a/include/linux/firmware/xlnx-zynqmp-ufs.h
> +++ b/include/linux/firmware/xlnx-zynqmp-ufs.h
> @@ -9,17 +9,17 @@
>   #define __FIRMWARE_XLNX_ZYNQMP_UFS_H__
>   
>   #if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
> -int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready);
> -int zynqmp_pm_is_sram_init_done(bool *is_done);
> +int zynqmp_pm_wait_mphy_tx_rx_config_ready(u32 timeout_us);
> +int zynqmp_pm_wait_sram_init_done(u32 timeout_us);
>   int zynqmp_pm_set_sram_bypass(void);
>   int zynqmp_pm_get_ufs_calibration_values(u32 *val);
>   #else
> -static inline int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
> +static inline int zynqmp_pm_wait_mphy_tx_rx_config_ready(u32 timeout_us)
>   {
>   	return -ENODEV;
>   }
>   
> -static inline int zynqmp_pm_is_sram_init_done(bool *is_done)
> +static inline int zynqmp_pm_wait_sram_init_done(u32 timeout_us)
>   {
>   	return -ENODEV;
>   }
> ---
> base-commit: 848acc8ffe1b7cd5f1bf427b93069becfebc2c9d
> branch: xnext/ufs
> 

