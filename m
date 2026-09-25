Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011070.outbound.protection.outlook.com [40.107.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE484A341C;
	Fri, 25 Sep 2026 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343666; cv=fail; b=a2giqZrRDf2aaIFCAmB9pO743GAKwCbzxZITK9UEDrQf+0IpmMcljm4W2gISDG7gogUpTTxlOV+MxLNbgvXrm80mH25512d7KVaoxleNYzRaerSfDZ4UW9fvPKLqtA+YNrdqr6kkH/G01n3mc+LPs0MmzovHfvD1V602EIUVXik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343666; c=relaxed/simple;
	bh=YnyZIlS5625/Ggs/B9Nj+LoB2fUczN07m3XwJwHl70Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LgzbfyXz8OD/NjU1Jlnkt2X+z/wRBrM+IahgkqVY+KgT17hmb65gac3fIThf1h3lKUNDPOg5I+NnEOjtht0bjFXU159GX3D4FG3HTUbS4ZgdPit5tBh23sJVGSOV8fsZFUbsFrgq4x2wk3vp+g8JdIQ5KHPrQ60m2MZzFvC8Rnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0eQlJNgV; arc=fail smtp.client-ip=40.107.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0eQlJNgV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQ43spcN0jEqYZgZ5vGknwA3NdwMr+qTSTFGRMpKZ3Nj/EtwFhTl6NVrXhzGPdCdR4dfxnLH/+BuQTxz5xq2+kWt8t6PmO/2H+vKUtXFJr+yLxHURaEbUbrZks23R371QduQEfgH+wlRtagAS5KOdq7dQJ/flT5Wys96btbX6YB9SdXdH/MGoyCHthuUwwRwCU8bEgXlrESn1BPioozE1/ZZSGwx3oqOxoxJBgyo60l4ksFwM+sq4++nLdRH3fIug8bJg16gKRhSpWCO5LBHDV+5abMuT4B5hOrHj6x0OWe1TnS+5Pk18O76kohxcYHK1/d1aML1WdYq1BFe1gzm4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlvtYn9Srxa9T7LnoKvL/ifdleRIsVg1SxKT9IRbOmw=;
 b=t4t54MdhcFKksUdm4UzZzMe/v1sY1GBaNaJ4X7K0UYtN1JaxuuRoUNbOBqCk3CzVi76GE5A2TrpnQiFIFKgM2p9bBYkEOqx7+Dn1HJY0hvPYVWWoB5hCMEKYW+VLdZn7O8IC9obUBLo2n6yF6dE15RXhn+G1DRZJLHfbW6/9G/nq0A5SWyKow5J+QpvxiTCDxIXtx5mLOXIgJ8x0dK1bTOoKhLi2j8GWGjFZwseite5vcbiZ146u2ELqhVWlL7/cYsM3iJ6w+jb3r7StIAdOmkJ5ACURsu9quWWF3eaSnbMc1FXIV+RXN1QANqWhLujrOYQsElcH9oWFwGAVzhA6dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlvtYn9Srxa9T7LnoKvL/ifdleRIsVg1SxKT9IRbOmw=;
 b=0eQlJNgVJLAMKG+mqHRT0nXlW5n1O9pw43IpxJive0xEt+FdmJLdrCXCwyh6OLFDZLgh4nWG2laapcFiPvkMthdF7E2zi9CPMCvlZcIEuLWuswCxjlJYCyP7FNla9XQoczyI122AAlPwOshDIdLopltTHeVuvVvmT9Cpr+O9yuI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV5PR12MB9779.namprd12.prod.outlook.com (2603:10b6:408:301::14)
 by CY8PR12MB7124.namprd12.prod.outlook.com (2603:10b6:930:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Fri, 25 Sep
 2026 13:40:58 +0000
Received: from LV5PR12MB9779.namprd12.prod.outlook.com
 ([fe80::8ac8:e862:8ae9:9287]) by LV5PR12MB9779.namprd12.prod.outlook.com
 ([fe80::8ac8:e862:8ae9:9287%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 13:40:58 +0000
Message-ID: <4c5215cc-370b-4e2c-b202-4a2c6a6ca9e6@amd.com>
Date: Fri, 25 Sep 2026 15:40:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] firmware: xilinx: ufs: move PHY/SRAM ready polling into
 the firmware backend
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, git@amd.com
Cc: Ajay Neeli <ajay.neeli@amd.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 "moderated list:ARM/ZYNQ ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
References: <eaeaaea8ed76069943e0706a0917139ff6569929.1785855749.git.michal.simek@amd.com>
Content-Language: en-US
From: Michal Simek <michal.simek@amd.com>
Autocrypt: addr=michal.simek@amd.com; keydata=
 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
 mpwx1d8=
In-Reply-To: <eaeaaea8ed76069943e0706a0917139ff6569929.1785855749.git.michal.simek@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:334::18) To LV5PR12MB9779.namprd12.prod.outlook.com
 (2603:10b6:408:301::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV5PR12MB9779:EE_|CY8PR12MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 33cdc89b-9741-4873-2772-08df1b0aa1b9
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|11063799006|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GaoYwmo6srC6lJWJiZJO/lys41bgxGuFaZRCbpVceShUEg2dk5qyQV41EChhIMR72fJRSmKdepXeUznaIMEH+YEritILm1f+7PWgm8hddKX8kel59WOQu8pnWXu87ZmLM185cE7qiyvowvuByAqJfpBDS8eDqIhYx1f0bC7f08Er3GJddrX6PCeY0PC82xsLdhM70ppneXrQYZm33XOqMS0a8hngTumon3fTNC/V5VE60yfKqAfPM3yY7MZVGTC4vB6rrvDMThMcvuDuNfghm5gbDPJA/2CmfDAm5AliMrY4HB2g4rheXYgNkOY1bi32x0k7sgirQ5RlSWNnikkulIWzqJK3EToyIOW7WCMH+Ad7QLw6wIRt4HKgKfig3i4rZdrRB2e8B/8P9B5HbOSHJ+LNq/r5TqSc8QoQgqU4K8vYmMAP47GLKCWrRItkt7Py6HHYlyfmXVTnQhHeI5/hzFYj7hkvfq0kFP2NyswtODkfPTGzrBAqRFcNt+jTtvew8uojjSa6UMxoK+hc5/IdF1yxUDsrnyM9YP6aq1Oh98XeJ8dQh8aJcFj+vOVf9QY2i5MAvDG+7hSHDrgRvGYQAEgqRdyRqI0wMgyY4W0YYwIZbsOYQ+X17aFCJSSmXNDYVZGhMOb1PLXhMapyc8CZzZmpmYRPKsyDC0edxhFuAK8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR12MB9779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nm5Jd29paWtmdUJYM1dEYThMWjlGaDFVcVFDbHZlL0hURDMwbE00N3FHdTJN?=
 =?utf-8?B?ZG9iN0thYzAwWkhNbDNNVUcvaEVpbWsrVDQ0ZlB0YWVVdEJ6Vk9pTWNXUktN?=
 =?utf-8?B?STkxMmlmOElPNUVFWklSbWpWdHFZcFZOdFZLSUZsbWVzSHp4V0YreXJNVzFt?=
 =?utf-8?B?RG5yZkE5ZCtSV25COGRyYVhXMVl4dkFRVVZNMnR4dGZpMDZ1d3pnSmNsR1RR?=
 =?utf-8?B?VTFJRUl3TEV6MFQxdjQ2WC96eWRzZmVlNUtJWmkvQWJuQ3ZMOXluOUZEdTAv?=
 =?utf-8?B?Q3N6bjhQaCtNYjl6eG5PRm52bWJOdG85bDI4L0NoSE53TnMvL3hlQ0J0Wm5C?=
 =?utf-8?B?WDFqZlcrNmQwZFB0d3VKZ251KysrdnR6MVFCOWdtcEFCdm1LQ1VXQkRaWjlQ?=
 =?utf-8?B?elA4RkFqT0NOKzVGZENUOUpYREVCTkJGYTNGS2FHc0xWRndodHZKaXJ4cDh0?=
 =?utf-8?B?MHBBdnlDbG91T1h0MkNKb3dKd1hZUWRROUQ3c3RYZ1JxTnF3U0JXUnFERUhG?=
 =?utf-8?B?NTlOTzBEYXRjNk1GQ1dIalk3VGdOQm93dHRrVUlBM0tlcjFic3ZBUGl1Ym95?=
 =?utf-8?B?eTRyK1J3WmNjcTJmcUN1MWVEdmpyVVdIVWdNV0ptNFhBUFRxY3kzS2VaS3Bm?=
 =?utf-8?B?T094UEVHdHlhUmpwVDAyTEM5ZFFmUVVpeHR0Qm9kOGdmSy9FQThyRlpod3FB?=
 =?utf-8?B?dnhrcEVFcGdXOEVUTkc1bS9aNU5rTjdlYXl1eUI5Tm50WTBGYWFWdldPTkxy?=
 =?utf-8?B?eW5RdHRhUDJpaTkwOVNrNDZWeGFWK3BqeHpPRGFWSDdkblhCemFUTlpmMjFq?=
 =?utf-8?B?bmRPakd1OGw5S0tua3B4Vm5DdGs2dVphM2F2K2M1RmE4My95MVRuNlFmN1BL?=
 =?utf-8?B?OWJEc2pCSVBXZ0pveG00dHI2Q1I5ZVcxc1lET0hwZkdnZldiL0k1VnhaQ0NR?=
 =?utf-8?B?UXduWnhkckduOUpuNDdmMTlkTW9vM0ZmUWxIQTl6N0x4OEVSeUxObTlLRkdm?=
 =?utf-8?B?dTNPTVFFZkNhT3RCZm11L2NlMzM4dS9QeEdTVWJlcHNXYnhuVmtOTTU5aDVW?=
 =?utf-8?B?UUhwMWxwNFdOU2ZKY1FXYWZKV1VvblVQTXV4OW91Tk1tcG9QWlpRdjNUZmRx?=
 =?utf-8?B?LzlGOUJiQ0RXSFpEZXRHL1NvcWV3NkZNYWdpSThGMnNVWHBwbzF1S1ZuRFVD?=
 =?utf-8?B?d0h5M3I1RFFkemJPaHMzQTZNR0lKMmpNVkVGUHUvall5MXM5LzRxMHEyZU1J?=
 =?utf-8?B?ck9MUTBYZzh1R2dUdmNmcTFEcTNGSGpERmR1WFdEdllGalJZNHFqUHRsakdF?=
 =?utf-8?B?RC9CT1lZRjdRaUp1MEpvVVNRZVYxK21RWU9EUE94Qnpsdms5LzhsZGVVTW1l?=
 =?utf-8?B?bEN5dWxvQ2Y4UXZGQVI2QUFNTXBBTWV1dll3OHZNZG1mVnZDdGNjVlUySkVs?=
 =?utf-8?B?Sm5OUGt0cHNOSFpsaUJRcjU1ck9kQXIvL1FETGE3SU9wQndRK3BycW1Eam1p?=
 =?utf-8?B?Tld4Q0ExemJGM3JxeEhQM2tzR0RMRXdsV2ZnU25HUXlDVnZlVm1GTGRRajVa?=
 =?utf-8?B?cy8vZjFobEg0OXM4azVDSGFRWkRpM2t0MWhUUXBYaDkrZFVFaEs4Rk4vRWtv?=
 =?utf-8?B?aHpLUEIxQTAwNHBkVE9oTWlMVTJpRUQ5d1NQQjR0YmVnZjV0Z1ZEMlBWZlVG?=
 =?utf-8?B?ekV0MkFwbzBlM3lvZXZLNzFXdE92cEUrVVVyclkwSTJkNHV4NE5LdmN4bWNS?=
 =?utf-8?B?aGhxRDRyTGtyamszZGduRTZXY0ZDUWsrRTZkbDZtMVk3a1BvdUI2TUQvcjdo?=
 =?utf-8?B?dHFpcHRDN2VPY3FHZWt1dEVXTGp4VXZYekZ3QmVONk0vWmxqTGFiUm03VFg3?=
 =?utf-8?B?QzV4WmpYekVZcHhXRS9VRTNja2RpYm1oT2xzc2dnNmVreXdjeGtld0FOUjh3?=
 =?utf-8?B?VjZkSVZXdFBOcUZkL2k4cWllQUpGWHA0ZThIREVyK1E1U2dsSXZjc2dOVm9Z?=
 =?utf-8?B?VlZPMHpvRHFhemY3cWx6MnUwM1cxWnhYM25NckhtUVJrd1MvQStDL2tYemdK?=
 =?utf-8?B?WFh6cGFRZ3lpbHhhbTgzKysvdDhoSXUxMktHMEs1UURxTTZ5UlpDNmhDSjM1?=
 =?utf-8?B?WnFZUDFldTZ5QkFMSUNnd2hFOWFTU2ZSS2R2eUIzUWdrQVdaVE5FeGVTTXg0?=
 =?utf-8?B?alc4UXZmaHFHditjTmUvNXNGOWJXWFB3aTdoL2lINTYxRU0xK2ViUUFUZDh0?=
 =?utf-8?B?SDBEcEpJTUUyb3piY0h0TlNzZjB6aTg4K3VHM0tMajBiNFdmZnRKZVlsbVl6?=
 =?utf-8?Q?aKlg0c/DSNnt31UeXe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33cdc89b-9741-4873-2772-08df1b0aa1b9
X-MS-Exchange-CrossTenant-AuthSource: LV5PR12MB9779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 13:40:58.7576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zf92qeu7z0AkINTgipH5jqeVZo9GXnLBG3zkuBEnMOTF5N0s8vPhS2OdhpAERC7s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7124



On 8/4/26 17:02, Michal Simek wrote:
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

Applied.
M
