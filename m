Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61233537C7;
	Mon, 31 Aug 2026 07:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788160795; cv=fail; b=cc9Qk2IYoL5lTnZBrZqJn8Gznj7OFCPMmWcqG4oWvvYdWMxNOgpT1jGdE1EX2o4ooSLTJMXi3oSLAjYpP6tKC0X0c2mE8CR4WP73vFsRlCHVRPuszDVC+qtQvQuLZs2RSGFCXKr7ck4U8yB77xQXrLbV4Mxjm4SPnuLRehqjy4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788160795; c=relaxed/simple;
	bh=vxBSaemJTmFSsR1we5BqmSq9rQODSIoi8m/4vBTNtrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Aa/daeH472WgkdsCYeUKY0mdfOrHAtrr+Z+7VRhpOsfaUzrZEgVucCgG9H95mgfQjNvyVoSFi58IW0l9spyZ45WDJkT5pONv6nBhKcbGzLPqlnv33xfJR6zJAKsjV34zsHdriMCALZ+Al4oYA1plbYGBuvnvr9NH0Mw2fN352CI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bgeYHKze; arc=fail smtp.client-ip=52.101.62.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bgeYHKze"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GE/bGkMWorK83Owwi2ZM6cps4G4XuPKo0+AyvCdrH9eWRovHu+liNwoGAXVi2qREvjVTKssNCjE6iPG6yvMyeM8cetY6XX92jhFqHYCtZZhmbfQrKPmWzQbrAcGlvt4tX4zoOVIzF8i3cxb/vSSpLBns+pJzPt6JSMbgOf9tGiGRN5q/usahGMm+uGGdWbD60AFklc77hXAyv4aneYBn9XI6n7dADSc6d2ReoOmKQHnPbpfm/m/ap6TkwvV1oQ1UP70yTf4rk9JjgNUjUk0FpyksCXGZNG/kyc8yxfpToCC9rHGVKNjjan7DcdK/ZbgnSTc5s16WuFRAF0lEQFdJZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjTEUE551aR76aJw3Y6D8wYi4+EsIC3RJieqp8HZSOw=;
 b=QH9u5BU8hulgkaqcgoyarAkjtCiEcjykP8aggkRK5R3YQSMBCqnl7hIwzTv81hrGuet3ZHjbh/PsEiV0mbq5RGhfrcP5xKlVw/1TYnkMUB2lDOXaq/Yg0eEqWh3T9GXHp0xpgpDvb0lcATqLdtQUZ01VHYzHGMZX9frt79Xh6Aqhp1Ou21PFiEc6DZHMv+ppXt+KlZcG4a3qtM/YzsjVjWJ+0tN8v7Ku31lNDeR3wO3d2m2qgZxg6ZrRcWtaoztGMOlyluG1BwqjP09Rav+de11lv1TS23+/l29CinsOdS+sWeNbIKOAS3AxxbKvdDLPc97zepM9OjgenZk4wfUx9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjTEUE551aR76aJw3Y6D8wYi4+EsIC3RJieqp8HZSOw=;
 b=bgeYHKzexKFOaoMpQl2i0t4i5X2w9iMjtEloE6XJifcezgfPh/bU5TfoPWdQ98V38YsaIAYSXHCIFPjy653jgIvGR0hlg6L4pm8NcjiXsF9qTOoqLKOyZDR/fkTF5w5k6s6J7S21E53xGDMvJ8uEobBNnNaK+w2QEaL/6I10RFI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV5PR12MB9779.namprd12.prod.outlook.com (2603:10b6:408:301::14)
 by SJ5PPFD5E8DE351.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 07:19:49 +0000
Received: from LV5PR12MB9779.namprd12.prod.outlook.com
 ([fe80::8ac8:e862:8ae9:9287]) by LV5PR12MB9779.namprd12.prod.outlook.com
 ([fe80::8ac8:e862:8ae9:9287%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 07:19:49 +0000
Message-ID: <891250a6-ae3f-4abe-b58c-92c8b9cb35ee@amd.com>
Date: Mon, 31 Aug 2026 09:19:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] firmware: xilinx: ufs: move PHY/SRAM ready polling into
 the firmware backend
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, git@amd.com,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ajay Neeli <ajay.neeli@amd.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
X-ClientProxiedBy: BY3PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:217::33) To LV5PR12MB9779.namprd12.prod.outlook.com
 (2603:10b6:408:301::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV5PR12MB9779:EE_|SJ5PPFD5E8DE351:EE_
X-MS-Office365-Filtering-Correlation-Id: 0484da0b-b532-4d75-ac96-08df07303e1a
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|56012099006|10067099003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rEzXNPhixTYPOkiXB9u4/ora0cJy3SV9+D2Vc9IGY/Rtn1Jm7kMigoEHRijfs2R66HSqxqjCoSeHleatZV5Rguq0kenItB45GS59O2S84S0XSUkVYQDdKanyM99ZKtzJf40O2rnpgJNrMjXxby3YnwvkplktKE7+BiA1TldsnndckW5tyrCx2xVIl4fA0Ify6B//K/gGxBXSksKdL4WaQ69kDPleYbmI7WkWK08QTGfpEr0YpuxP1VU7uELWH6qiSwv0wRNlCM/Z4c/JFnjk+hJcdhmPa7o7VaU3lbJPJmlEYfR08pxbG7gKtC6fYOdBgvdTSVxT3Wl512YydgWTRMl9tTIooTqz23HDbTIWMKDorNaFl/b+vQ3txIclQtCWS+mFh5tG3/HdRO0RrVPmVNvE0TlkyVOFqDHMvnLwU8iiyUUi2iuG9coNHKsqXL7Gk8GwTz46lB2Tm2hqndAF3/qXe2U4aJO9QJtamIEQq0ME17gv0qq+l7yIX/n6/Kz7VU4+fIaW4JtOaojlkxbY85IHNQwqD8hm/3kRoLrHQUnNoblZGGSsnX6WoVFvKHjfe7B3OVadaFxP++D1GYUtTQIuLQxi6EuYc63e6xKdkDKQ9ZpG1Gq1NmVJhNlz7og2x040sQAzQpPr5ElkFsfG2g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR12MB9779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(56012099006)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THZrM2kzbFN6ZFdGMDRVaEZUT1FsVFVwbVVBRCtSaE55WWpQN1BwZjRDNXhQ?=
 =?utf-8?B?MXdRQXVGZXVCNWV0RWVFUWU2UmtzSFlQTHRXaXgxNnExYS9sdDczUzhqRDhx?=
 =?utf-8?B?YzdLNWV4SUpUTTFFMmROdmJTYTFJRmx3aHIvNkFpMW4veHExWVI1WUMxNS90?=
 =?utf-8?B?U3FMSjBFMVcwOHNza0trdllib25zUHZRU2lJVktGb2lnSHp0OHVqY0M2eHA5?=
 =?utf-8?B?R1FmWFFaVVlYNDd4Qlc5aFF6UDVUOGswVmRQbWZIVlZ1ZzdvZ3RZbHQrbHFL?=
 =?utf-8?B?ZE5vK0UvdVhUMU55Z0JWS253cW1QL0JzNzQ1YmdvczF1YzBNMXZsVjBaUjZv?=
 =?utf-8?B?eTA3UmMvemZuckFCTTh0MXNQL2VRSURlbGdQU3pZQUVYSVI4QzRub29hYWdp?=
 =?utf-8?B?MmdaNDZ1YlR1enhId0FPZEdQd0ZQbnplV2NJMHBBNDA1dkNHNzh2N1V1dzFr?=
 =?utf-8?B?OFZ0TkxIdWx5WTloelcwdjM2UFg4Q0RLZ2hxbHJPV3BUZVVvQnN3Y3Mwa3p6?=
 =?utf-8?B?SmV5M09rYTFicmJsckdJVURNQWVEejJLZUxLQm5yaEladWdQdW5ocWJwTi93?=
 =?utf-8?B?eTkybVN3dW5UNjJyTmpMN1QvK0tqcHBlbEc2d2lhOWlRbStrV2NtVDJCSVpj?=
 =?utf-8?B?cGZsSWI5MlBxZkp3anc2VzYraXkyVTFjTlZLclljZ2ZHek5sVURWcW1pVGtv?=
 =?utf-8?B?WHdyMG5kdk1ZS09KSnpHZDVKaS9yYkZBUEF1NWo0d3FIQm5MY2hub0JlRG9R?=
 =?utf-8?B?emJDcDByWWxTYTM1cUU0ZzRNMmxRZGttYlExNXFrU24yTFY5Y2xpRG5jQ3FJ?=
 =?utf-8?B?Zmk5bzBrRjJHcldML0tlaXZGa0RieGdpYWJQcFd6TGt5c2J3ZVFlVnU3TUcv?=
 =?utf-8?B?YTZzT0dWN1lMQ1IzcjRBUHQrVy9pNmhLUmFCMUtWZ0NUcitkc28rL2hGS01D?=
 =?utf-8?B?UzFUUEs2WHR6eFVjcjF3dGhXaE5XZVlsQXFUTEp1YkY1ZFByNHpwL3NEaHdY?=
 =?utf-8?B?SDN0clRYWHFLK29QQlRkckJxckhUa1NMV3JsM25vN1ZHSDZINzZEWTBlOTM4?=
 =?utf-8?B?bzlRQ042cXZvU1RXOHJCRFp4STlhZWlkVVcyc1ZVSVJQenBPeUdCWlVqUVZ6?=
 =?utf-8?B?QXdja1dRbHh0TlkyaDY4L1BrY2Y0YlhUWUZVUXpUc29tYVZaclhiL3VsdnRa?=
 =?utf-8?B?MW92L2IzMStTeW5lV29TVkVhaVBVbUlqeUNoUklWOEVEQmEweGJlVGVmODQ0?=
 =?utf-8?B?V0k1dU5MWDNXOTRjNEQ2aURiczdZNkY4d1RCNEg3OERRcmJJRXozZG96Qjla?=
 =?utf-8?B?OG9pYktQMVJWVjBYZ3FJQXpiUnduNjR1dUozbSswaHFrUkdrRzQwZkNpZW5D?=
 =?utf-8?B?TjBZSHVHeGowOTlpb1pBY2tNSTBsVE45RmpyNmJHbU4zanVjMHZsZ1RINTZu?=
 =?utf-8?B?Z3N4cHRodU5zc1RUUlorSXgyV0JkbHprbWs2bWsxbUgvcytFSnU5MitFSGFY?=
 =?utf-8?B?Nno4TENFN1MvZ3Z5M1hOR3NJNHFveG5lT3R6dG5MbmxKM2VqYlQ2Z2g1dlU0?=
 =?utf-8?B?V2xCcklnNEVzeUJFTUdKbzluUXRzK3E0S0hEdjQ4bFZNTmY5cEsxUnp1aU1J?=
 =?utf-8?B?bndaM3hPRktFTnNITEdQemY1N0EvNjFmN2xzTENHWkdkdDdSaU0yd1FKNnNE?=
 =?utf-8?B?eHBaWHFrUUtid0ZUdWY4UkZtREZUOHI2R0tGa0NJYUwzd1NvYmJGNnJUU3RW?=
 =?utf-8?B?a3U5S1lSempXUmp3Vm0zQ2d5aExnNmVPRzA4MGVMMytuNTl0cDVlNjdUVWx0?=
 =?utf-8?B?Z2RUdXVMVWpLSWVSdUdIRzVCQnJXekhMOUZ2a0RGaDRVTUw3VE16SFFKUGto?=
 =?utf-8?B?QlI1ckE0akNoRlhqYk5kL3ZtTEdjc3hxMklIeEZpeHBXbTcwMkJNcFNuM2Yr?=
 =?utf-8?B?enBNZ0tvR1FaRjlTKzQzWUlZZ2xXSmN0VWNQTEdlTG10eEdyN2ZVWkpORzd4?=
 =?utf-8?B?dG5kcWFsc05rRFIvNWNzRkU0MERtNHJrWlJVUjZUYVVNeElqS3lybGc3STkz?=
 =?utf-8?B?TzRRaEpGSmcrc2ZLVTBndlBqU1FLV2RSWGpFVHpteFVqaEtLL09SUE8xSmhY?=
 =?utf-8?B?aEZKWmRFQ0JjNHp4dk5yMEcvekZXdnZPai9teFYwZmVsa3V5L1RqRDZnemhY?=
 =?utf-8?B?KzhGblptQURrclQ0YnVlZlJaaHNLYlpaTXR1emY0dGVuS0xrcWg5V25aeENm?=
 =?utf-8?B?ajcxQ1ZHUlQxeDVlTmdINVp5QVhqcnEyQnZtc0NsTUJ0OEsraWtzalBDVzVi?=
 =?utf-8?B?U05YaTV6dzc1TVFuWGZJUnRXd2dBODZQUzZGR0hSSXF3MW9BeW1jUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0484da0b-b532-4d75-ac96-08df07303e1a
X-MS-Exchange-CrossTenant-AuthSource: LV5PR12MB9779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 07:19:49.2994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70n2kLYd3wkircTF8t4AiHMkB7SBULXGQ9WKBKFsoMtPkrXH3/Zah63peUtj9ve1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD5E8DE351

Hi Martin,

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

Do you have any issue with this patch? If not, I would take it via my soc tree.

Thanks,
Michal
