Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013019.outbound.protection.outlook.com [40.107.159.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683733EB108;
	Tue, 13 Oct 2026 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886763; cv=fail; b=uKvlJB1Gyn2GIpwJNhrevB4E4Nx/KZaw+KGfOUXMFaOJDrholWfHfAAyQ02t0j1g92bHtYELq3wfjOODgSyUiFQNkc2hf5kHxiiKtWDRKADF3Yktfif3SS3UtsCRq3O+W/cKc41yPpwYq1+YnXdCHm/+MJmPIXruYTMvF0B61N4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886763; c=relaxed/simple;
	bh=3O1g81HN1X2tvobqJeBM+IsKIdbSO/qeSNUigkTW588=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=szvbgNsgc4/cX44DxwdCTQ8Eq7Rn5SStBYX44kXZ0rHlPGYyqzkIECwZc35/ZjFstTJGl631gEf7qVcY8e/qCUg0OQ24OFFqfZQJvx/xafPS4p4zLWGUEXrkECUbcZG7Q6eKhD3C7p8koWKX1sNUq876DDEc5PMA8j4r29IX3GI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=YwsN9pIc; arc=fail smtp.client-ip=40.107.159.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="YwsN9pIc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Srtu/i2KMVIVb1JAsSIyCvIEMGlabxa4Ly+eUbeGF5/bz8lp243hEYvcmNxJaXOL4E7+r68kVDUe5e38A4fl5LDJBBLD8ILGI9EsOnIRAFQb+csmZDOIDfA1prgd6u5zDlusq3G387EHbVoi+JXvGfZUJh/jgTkMrJaqS+Gsv0p0f8QfYK2DA/Pb3zaiuWTXfWRcIyWIscJ0Rx3qjOKQ9aQUnF3B1pNVOmKeoaIljY+gHiG4xMMal32Vod47wjC+5D+waDS632tGPokdYTnNE960UK6hC7SphEXYLfr/97DlgUF/xGAjpIW/y1nek5MOcdVYIEN8YW8zaf45j+DXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lj6wyNb9UyuzaRcMjTIkR/mmS+z89kLpD6QcDiZRy98=;
 b=NNNNb55ljKBAZ7DSwHf+Q/TCPv9qZAGjcExT7KYUWdlAq0Kan87v3mqm1Conr1t84Ic+Bk1b55zHY1RB6wPLTfRBu/qyINsojFmUTBezwst9K6gBhXD13Y/LRwavcNvZCTRkHvkELws7RDNFwrlSEQh1U6PXNYzcg9++BlI4aTOmaxFCEHG7JBwjyDpwSj5DagckXHflolbGUhg0GSjgik12cLde6UvnqdpMmTxiOUH+subY6/KYVpbfS3BDA4tezlQd/uRjSnr3M/T7PgYKXb5+OgWn8Tf7RYiQQASmNuVE0Ma31u0EM3UiUw5pJ/nrd/mc62bDvmTM+TOexTRLUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lj6wyNb9UyuzaRcMjTIkR/mmS+z89kLpD6QcDiZRy98=;
 b=YwsN9pIcvVLf5AP28y+c/AWfqxu8y3ekwhudY4OsIy9+INhuZLPQEfTZuFCaH5vH6FGRnQYpov5tyEP+787EONnINE5UsWwN8voJofUznWPW8hODcdj2QAhts6NtAHbyrGP/MAISIxz7YFsZsluTx6lDcxv1/CjG/Sx9rL39SgB45u9AothrW7XAxuZVttPHenSKM0PlNWdZY4H2Vw8olmIgJKU+vqANDEZxf+GW+Na1w45xMj8Ec3k1Bj2jP436R1lLL97CuLHj8XYafgjneNBx79eogQpgIS0RzoOgITVa+SjO+zYgVzo2c0kVqf50LrOynaMZGsBF0Vc3gd6IhA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8438.eurprd04.prod.outlook.com
 (2603:10a6:20b:411::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:19:16 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:19:16 +0000
Message-ID: <9aa3d6f2-ee0a-4403-874e-8b47f4f8c425@oss.nxp.com>
Date: Tue, 13 Oct 2026 13:19:13 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/12] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
To: sashiko-reviews@lists.linux.dev
Cc: conor+dt@kernel.org, linux-scsi@vger.kernel.org, Frank.Li@kernel.org,
 robh@kernel.org, devicetree@vger.kernel.org, imx@lists.linux.dev
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
 <20260929100946.693962-10-larisa.grigore@oss.nxp.com>
 <20260929102142.A35F71F00893@smtp.kernel.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260929102142.A35F71F00893@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::9) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: 977f885b-b8fe-4fed-b048-08df29136f5f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|1800799024|376014|366016|6133799003|10067099003|22082099003|18002099003|260925021311599003|260925021911599003|260925022911599003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	KYitB6K1PzTKCG7mbjkdni+f1jD3QB1gvHTA8Kbi76nJWPek3V+F8m3/pzBFgURhY5qleBQO6hGTAR+dTsTwAO4sUMy10NcKIyqT3CzuJGufZSO/ceoU8sigVj261+EhfuKeFUtdy+vso/oCQ98SyhppHdjXzU8YQpL0UaNesGhYwVOd21eRROUTgfeeBvGq9xtT6ebn4MeLDS8U6srxLCh64lwf4F1GLByBRXx7Yb3FcxQK4iaJbFZS4MkmPdbpBScE1MsayiLsPzqZGTApiBIrnxydd7wfN7uVobgs4iJB5MY8odU0QBBoYjI81706jkLKI4P72odQSmaqAH14nYheJOwFVSOkf9mdWYt12xz703HMVUe1LdP/4KiT77E0oSf1DcRZcM7QbntXkNQ70yUe0OoQLsE8v5BAiTghqWKzczJLPG3/eJnEQy57YaDvKs+gsP/Ot3v0pkeKBXo7EoliiM2Icagkl1gILaUsjZRivmReRwvG0Ml2rb2kIAsE+v07xUBrN71Nu58A/RLO7wON8irdgVAA2Ru8SDDaEQvtUrCJ+gtarfs8yKkZdvDDyJc/McmGUw+aWE61RpsY9LWZ1+Xx32/KXzI70X3iBJP1xiSWvk6d4d1CiQFI+rK5VvK+w9kVg7Fh2lthXB7ssKn6nbkVyD5+gmQSN7NQYh0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(1800799024)(376014)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(260925021311599003)(260925021911599003)(260925022911599003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFlJaGM4TGxwcktqd2U5MUVIVkp6aGtRZzJiTExHTVVqc1Vob3VadHpyOG0x?=
 =?utf-8?B?T0lXVXFTUGZycWJYTEk4dHRkWCtmMG84UStucTRBRDJUcHBUUDE3OWRnbzQx?=
 =?utf-8?B?Q25hR28zWDJYei8rUDBzRm55cFlyZ3ZTUkZSTGFweWptZVJhRHA5UzQxWWZh?=
 =?utf-8?B?YWlHdVFWTG9rQ3V5Q3hSUmFZRldINERzSHR6OHBoYURWb29VdUxSQUI1ek5k?=
 =?utf-8?B?c3d0L3ZtdTNrZFVQeU96RUxGd2NZOEV5Nzg0ZDk3aHY5WEhXUXFGQ1FPOFUw?=
 =?utf-8?B?dEIxL2pBaFQxTGJCZ3VKRlFKUjEweEZ0WEV0NEx2K2tMWCs0QzJWVUtIZDVD?=
 =?utf-8?B?d1g3bTFJancyaE5yV2VObklpYlVPWWFSNUpmeWxzS2hBTkxHbWNsZkZkNDh1?=
 =?utf-8?B?TENpblVDYzg3LzRPcnBhWGt6QmpoVk5SQkFxTE16aU9xMEpadE51SERYYTU1?=
 =?utf-8?B?aDFLbGorK2ZiKytsbTN3QmVzRTBzaEtra2lvMHlUNWV4M2ZZY0NiRmNHSTJl?=
 =?utf-8?B?RExUYmJtbDVsdFZZZ0VuZEpudDV6cEJrS011RDdJNjBQTWd2QnVOSXN4bk9i?=
 =?utf-8?B?eTV5M1EzdUR4OFRFeHV2RmFnWGNFN1Nhc3N0c1YrVHNmY3lEWkl6LzNVeTcw?=
 =?utf-8?B?d0psMnp6TTVYNjhMYzI3cXYvV3Myay92NjJaWmRhOFFQLy9Oc0x2UTB2eE9p?=
 =?utf-8?B?aHpDKzN6dTBBdEs4NHdlMDZwREc1MHcySVlKaTJGQ0FyT3A2OTJkbVVaMDgr?=
 =?utf-8?B?eFphb3NOU1NPbTNRak5KeVc0bjdsZjlUV1dIL2tRbWZuWHNCSmtudEdXc3Bw?=
 =?utf-8?B?eFZCU2JpUFJPbldlcHZIWlB2bFpRSWh1UllaMlppTUZRZCtITStFeFNsakFi?=
 =?utf-8?B?azk0emFXejIvSG53bEdhdnRIT3oySEFKUzNLSU5SczdNL25ZT2xMb0o3L1I0?=
 =?utf-8?B?SlFXaEJQN0lrV09TWm9VOGJjekk0eXNZN1N0WVQwQklsclBtYk5rYUlndDJE?=
 =?utf-8?B?N2tCOWp5Ni8vcnRRYXVONDZ0bEpxRTFKZ0VjaSs3M2tyVG9La0M0U1Z4dGNW?=
 =?utf-8?B?eE0zd1R2WWlwQWlRNHl3TlAyMHk5UHFBY0JTTlZiUkR2U2RmZVAwaVgwbnBs?=
 =?utf-8?B?WnpncXl5YXQzd010OU50OUhnekgvUTQ3SDM5RXoxVlN0YVlLRjRDRkNtTGcw?=
 =?utf-8?B?Nk5Dc3NOcVFpUHRwbnFXTmxwMkpTTHdqdE5xTlE3dkZxOVhVY3Y2LzZ5cWdS?=
 =?utf-8?B?QWl5N1B3azRURmZLM0JmK1NlU0p3ZXVaYWdzREt0aDM2dXVpc0RUYldxazhV?=
 =?utf-8?B?dFZ6TVpSamVGZkdTUDRWZUlpNWhoc0FJTlFTbkVzTUJrWFFrS0dTVk1KdVFN?=
 =?utf-8?B?Qmd4UGVXK1FZUmxxSnREbjZoNEdnVm5tMUVqRjM4bnBSc29NeE1RSkhpRjZB?=
 =?utf-8?B?MlpSaXlMaDhLS3ZCUU5COWZiOU1ieExxRXdZeHRVUkhxeEJUS3pFMVN6S1pE?=
 =?utf-8?B?R203RytpK3lmWGJMSGRoTDkxVkovOWJwSTdHT1pLK0F3WTVqWEhLTU5nZll3?=
 =?utf-8?B?bk1GUE4wc0txUWw3WVFUQzVCdmdXTElQbHlNRXBmd2ZzYXVhcFprZ1pQQi9i?=
 =?utf-8?B?ZU1CQ21vekt4WHJFcTA2cy9RVGx0Y2J3SGI1cVRQaSs2ZExVSUlzaVJtbWJw?=
 =?utf-8?B?R0EwdXRFVWJwTW91a21xUTg5Y2xLeHFDckwrV2c5anVDM0tGTzBzZzFQNHpY?=
 =?utf-8?B?bThwUkUrRUNkVTNxekFuajNVZmNxWVR3ekxIVGt6dVgvOEUwczJFd2VvQ0lZ?=
 =?utf-8?B?QjBTa2VPV0lZS0Q3ZU9pbTZSSDVZL25ndHVESjFQVzJISDlVZXUwSURoSmFG?=
 =?utf-8?B?cGFBazB4TFVadk1aaUljdXZieGFxNjc4TGt2eDlZdWZHajF1SGh4TDd2WUVC?=
 =?utf-8?B?c0lHQXNtUkNVU295Z0pyOHhzQlRJMzQvVC9NLzVOWDFBdDdZUDhrWit6Wmpo?=
 =?utf-8?B?V01aejcyY2tSU3l3cnBybVh1dTBPV0JOZWdjYjFOZGJKQlJWRFdvTHRmVGdB?=
 =?utf-8?B?eStmMU1IVHNlK25ZbVVXZ2s5cTI5T25BcGlHMytnWWJiOWxDY2tpRXhUWkhy?=
 =?utf-8?B?UHNHNDFKeUd6Vko3VWRCcFdrL1JHK0wrMjR4M2I3bFd5WUVwZVQvazVFcGg4?=
 =?utf-8?B?V3dtMlk3Y3pqV0ttS2x6dlg4MnRmVm94a29ENE9JQzM4VjY0amptTzJsN3ZE?=
 =?utf-8?B?bFJTa2xlaWgxanE0YmxQZUwyVHZjajMxQTJMUisxWk1wOSt6cldXcENVcXJp?=
 =?utf-8?B?enpTMUJVNFV1b2p3RHZjeXpBMjgwZUVKcXp1dWlkS1d6TCtYM05ldz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977f885b-b8fe-4fed-b048-08df29136f5f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:19:16.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qs+Q1SCIp0dkdlLGoTKMK/WqJLi0ivB8IKqYrYDqXcRXe4ozwdwdGb1CabruxX+qpGPANCqNGW9v8Th9MqqITw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8438

On 9/29/2026 1:21 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] ufs: core_clk remains permanently enabled during PM suspend states
> --
> 
> commit aea859e7e22ef8d785ddf1572d56548e903ae544
> Author: Larisa Grigore <larisa.grigore@oss.nxp.com>
> scsi: ufs: Add NXP S32N79 UFS host controller driver
> 
> This commit adds support for the UFS host controller on the NXP S32N79 SoC,
> built on the Synopsys DesignWare architecture. It introduces platform glue
> and specific initialization routines for clock scaling, M-PHY calibration,
> and device hibernation transitions.
> 
>> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
>> new file mode 100644
>> index 0000000000000..5374662763b6e
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
> [ ... ]
>> +static int ufs_s32n7_init(struct ufs_hba *hba)
>> +{
> [ ... ]
>> +	/*
>> +	 * The core reference clock is not managed by the UFS core (the DT node
>> +	 * has no clock-names/freq-table-hz, so it is never added to
>> +	 * hba->clk_list_head).
>> +	 */
>> +	ufs->core_clk = devm_clk_get_enabled(dev, NULL);
>> +	if (IS_ERR(ufs->core_clk))
>> +		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
>> +				     "Failed to get and enable core clock.\n");
>> +
>> +	ufshcd_set_variant(hba, ufs);
>> +
>> +	return 0;
>> +}
> [ ... ]
>> +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
>> +	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
>> +	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
>> +	.prepare	= pm_sleep_ptr(ufshcd_suspend_prepare),
>> +	.complete	= pm_sleep_ptr(ufshcd_resume_complete),
>> +};
> 
> [Severity: Medium]
> Because the core clock is unconditionally enabled via devm_clk_get_enabled()
> in ufs_s32n7_init() and is explicitly excluded from the UFS core's PM logic,
> will this clock remain permanently enabled across all low-power states?
> 
> Since these power management ops map directly to the generic UFS core hooks
> and the UFS variant ops don't implement suspend or resume callbacks, there
> does not appear to be a mechanism to disable ufs->core_clk during system
> suspend or runtime idle. Could this lead to unnecessary power consumption?
> 
This is correct. I will add operating-points-v2 to address this issue.

Regards,
Larisa
