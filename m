Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013003.outbound.protection.outlook.com [40.107.159.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73F33F88B9;
	Thu, 27 Aug 2026 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839412; cv=fail; b=tdWby1tDqfP20duqFu60lOgjwvMWwX3yYVRVzmhjtC8WJmOT28cV//WFv5/rWlyhip7A8FbBy5NrpN/CHCl16KiyiW31EZS/BIqddYxxvT/X19qexpzms2/9nO/X3BLYTXBT1L1ICJpz7eW5oNOsF2pUrcZw7NpmfQkbf0HK3Ko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839412; c=relaxed/simple;
	bh=2cnb1i0Gcy74N/QniXJLFJTPmGuAW4hXxtF6lNPOgg4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t7t3mPiKg4dJ8z/QSad75u0fV7rOoY4cWizaBcm49z1cXSyKZWfCzFwc1QFZYKPyVVW0ZY9qMtXuIFnDi1+GGNLvZUsu/JbbXzRj8mZDl23kSoBLpX1nT7UhWWMEFGkNTXkHviug6Nx+JZwRfnhFzriBv9+/dcq+lCIsDFS5Vgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=WzjWCyvK; arc=fail smtp.client-ip=40.107.159.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="WzjWCyvK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQ069oyXQ8Wbq6WXCRt8Q08C6zF4KYf9chRYXREvkUm/cmSu0LTgFQZNMf+xJNs9ePrcesq3FKFy0WUGePGFTbW/6NQvsGvWJn2m4Jyu+r84cL4+vWlscG1/mR7a8zQV+3trDg+xQAWFCLqI7seNuLikWDyHHFDIrtsTVw0pyT/9FHRpQbh+eU1vmPi0aoFjJvEiYeMIvp7EoXeYN8DA6MoEsAq+J2bMYGTQLVddCc7/XI0Di39dTc1Uqya8jFn0ibkaGAZU2I+CE5dYZSICpjZXPxkPaIJn980KrJvaOZUmR9S7b/hAOrknQ3WuEfsjSaxlx8G5WPu6oOI33ojygA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Nr8gp+oUiFJnWtHWjWlIOZhgEaC2m9Wp7Aet4tZvjc=;
 b=X8LFcJpH8GmTMoFv2R8S7yScDO0Writ+AGssyGAdfqVO606rbgtePsXx34nmFaO517ygUPwtU2eQC9WenoP8MqTjC85ks5VHmTvhQdpzGKfsoDpBmZ4eL61z/5cK233frAnb+0uvYmx9zVbZpNINIwiP/IrCDABAPKp+bDe/97RrdldtFnH+gnsCceXqQ8DXRItVtCGnhXtTo26AOUxGQyYP5a+lSjW4PseHWtMG/2MygagIVHbWACld7WYrussaCCvXH6dvNYzMBaeqSBqyvRBP2nyOhzyP8T+pd+NqzjGlRYa7e2yIJDxIwpR8K21LX+tcBX31/IHs7mdfN/v0gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Nr8gp+oUiFJnWtHWjWlIOZhgEaC2m9Wp7Aet4tZvjc=;
 b=WzjWCyvKXeXVBJB9bgQ6Ip5HycB581hLOhEYrwTax99qPyQV5mPWOj07DkaobHAI52w4+crfs7Hii6ygfE6DKJ5MDpQY9v168C11PnnHhmEDzx1nTUQcuSVFr7zZ5Bh1P9kDsYnCqdqIe45wcae4jVTi9q1gSpNHNil8ug+1IDycafkqrnaIeTkCDyVJ29/yEwczhFnzoOwB6I1A4bAX28nHcoYNvOtEtafp3GTGm3jEiabCug15+vpoAWJ1dybDHAViFJPeaeENao9Qxv/WzS3ID0D9GXPJou6yFmVxSG6vxCnVbkeDAiyWHaX7hgcCJJdkyrMxx4ATotvVt1xG/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU4PR04MB10361.eurprd04.prod.outlook.com
 (2603:10a6:10:55d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 14:03:02 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 14:03:02 +0000
Message-ID: <5e0022f1-e4f5-4313-8292-95e98ae7ced3@oss.nxp.com>
Date: Thu, 27 Aug 2026 17:03:00 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
To: Bart Van Assche <bvanassche@acm.org>, NXP S32 Linux Team <s32@nxp.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
 <4af1df20-f6e4-4559-9cc0-e4db05597090@acm.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <4af1df20-f6e4-4559-9cc0-e4db05597090@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::15) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU4PR04MB10361:EE_
X-MS-Office365-Filtering-Correlation-Id: 2303ddd6-b8a3-4bfc-e048-08df0443e883
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|19092799006|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	dnPKPbhvZSDndOHXQdtkioEt+BMDrMDfrPe3ooyY5EVuuvJAAI2fcf93YgVkZYux5J6y5D5mL33+InG587epDZQK0ZtX4nhZJFj8uHhocwQ3WkFd/aRUI1MtxhR8+JxO8/F7HTxBsJIL+XM7vZ/09DQg9v+ggJ+BISG0usvVlSZUdFIs7PwS4FMIxNPsj+DoF90bk3xhlqIhwDo34SuHom0J9qBoDH0Xqg4VlTOrh5T9pDwcrTSfJMqVTkihHG3Ua18WgsWKy7QxMfHQzYWMK+eQuuX0p6L8cB5XO0L0cxWdXqrprkzj0ThkJkZzeTxYRiR5NvF7hmXMYw/l3OIxIaTZKJiYRmKjYAc1uETCPswBSvvTARyCCEmuoeO0rdGKbnVw/BMErsNXheuZ6A6YyrpAKGwtg0PZdoc7zYVm4lJe9Ht705GnUVHvxxfaRscAAVEnGOnU+xODcW+HFiwUXXUbzp+jbPDOqpKsOqJvhteFXMvMMFdN4kovK1QaGJRlDkLX81gSwXj40VluVY/RviWOexKVpEVOyfvuO5zWPQO1CKyqCH9/iWgKvIs9FTRfibjDACy+I9/KAWrJMCGOFxgX26jWauN63kEcfJFoLjYyEpgBgr1lBY47yoSWhQ+9T/EuzVhPvhwclxPGk3n1x5HN+ExC7O0gUXNmygKXbRI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(19092799006)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDdKNVE4ZWtKSDBjcFJtVFpjekVFZ3BIMTVPeGJlTjhUNHZCL3A2cVJreFlM?=
 =?utf-8?B?bHlkRTZoM2puajlkUUZuVDIyNW5xVU5zeHhaNjk5Z2tVMXNjck1GcnN3QjVX?=
 =?utf-8?B?SFEyUHU4NUkvTi9Yblg5Ykthd1FEdXFIZlFiWkVwWldsWEJ5TW01M20zdFQ3?=
 =?utf-8?B?Wmx2OW0rMFpNR1FPeHZRYlRFQTU3aU9yUWZicFhaeUFnU2RaZHZSMEJLU0FQ?=
 =?utf-8?B?OWdlQ0RuOUJHQTRmT3NYTXBDZkxhbit1emJOazgzUDNwRGZqN0xvMXBZZDdS?=
 =?utf-8?B?bkkyNkpPNkRYcUJ4WXhPN1l4TXg1UU4yak1GU2E5eitWNUF5V0Vld3FRRWdl?=
 =?utf-8?B?N1Q0Z3ZFenpWc0E2K1MvMTJna1BqbkpTZVRzcjNnRkZCTlJ5NEZpSDBYakRK?=
 =?utf-8?B?RXIyQWx4NWdoTnhFRXh4UXU0aE82MU9uVVZOeUZFWjVkK0dpQm9SQ2RNTmNz?=
 =?utf-8?B?LzdObzZ1Q0o0VXF1Vno1U0hXRGhMOTZOUW9GaGVzMzJUQ2NnejN0RVdDK2VW?=
 =?utf-8?B?dFE2T0RSOVlDdWduTXN5SEM0ejZkbHlCSnRkb20rY2NkUmVWbHNPMjB0QnRh?=
 =?utf-8?B?YTBEREdkUVRTWkFvcVh2eWNONStpZmh0SUNqZ3BNQ0Jmbk52cSttTzN4UzU0?=
 =?utf-8?B?NzFPRktTQjdJMGFFc3hCWURRbjFnbDc0NG9ud05jVzZtSmk3YS9vU0JPeEdM?=
 =?utf-8?B?RnNSVVBEUXAxODZidTJ1TEptdkUweEJvOG80MTIwc0ZkVlNocUgxd3duTkdp?=
 =?utf-8?B?dExhcndqaGdoOEhqVncrY0lqS0dSZmJOWFdGSlZEWVQyakF6aXZwUzVNbTFT?=
 =?utf-8?B?ck9FL20ySElpVUdubnhoNmtZcEJWMGZRaUgrenJ0cit5bW50S0lHU0F1NjNi?=
 =?utf-8?B?YWlUbWhSOFdWUGswU1cxSmFFMUlvYVY1WCtmdXZMdkZ5WDExcFE3RCtKMllx?=
 =?utf-8?B?VjI5MnNCMGJnNVlhOGhaWC9TVWk4dDUwL1EyNEZzTU1NQTFoayt3bUoyWDVr?=
 =?utf-8?B?M3FrSHlWRnZGRGV1YVBielZDdTkvRWJqVmRISUpMZUpGUC8xQTdPdW9nSzNa?=
 =?utf-8?B?RVlxSjRoQWR1MStBUEI1VCtiQ3BRTTNheXRGT3lEUXRLQ1hPK2ZaRlp4R3Nk?=
 =?utf-8?B?YzRwVlo4bFZKbHh5MDduRnd2TnhVS092dGVZRnE4NHlrN1I4cTNQMHEyaFRt?=
 =?utf-8?B?Q1R0eEZOWUVqZ2pZODgvTHZUenBZcjA3VTB0UklhVVBnRisycFhkT3dXVVJT?=
 =?utf-8?B?aEt5bkE1anpLMGg2SU82VEc2Z3R3TStYc0RsMXdLSVJITWZwVEVFemo5R1hY?=
 =?utf-8?B?RVBqamVZMHpYMHNCbXZwa3VHNzNZNGhwaTlMZ2c3Rnd3UEF6ZEtWRGxVTXFL?=
 =?utf-8?B?WmtuRlFjRHhERFpoTkloYno5Q3BCT1hFMXI1SU94RGhwcjJOdVRHY0QxMHpR?=
 =?utf-8?B?WlZEaERsUk12d2xnSzFkVFc0Ny9nR0FVb3ZaalV4SHJFSEFxK2tQeUVoQUpN?=
 =?utf-8?B?OFp4RlNGUGpaUkhwRk9jd2FOMHF3ZUtNRFJmT01FblpQSXdpVk9kalFQL0x2?=
 =?utf-8?B?TVVQM3JKRzc1aHNGMFhWQUMwRGtacmVRRi95T1dtQkxyQTZaTHZOOXBodURW?=
 =?utf-8?B?V3k0V0FyeEI0MFJJNGd5WVdnR1FCc2l4U2JGSE9NYkdoM0dLb3ArQ2pXM0hX?=
 =?utf-8?B?R3JpZkxzVElzRTY4ZkFVc1NpTnRmSWxmSWRzNW5ZandGaDhGalR0dGFadkx4?=
 =?utf-8?B?VXp4V041ZFMvN05HVVMrMkpZUXA2STZJbDVZVTY1K3M1eUxGc1JVT1h5d0xL?=
 =?utf-8?B?S3RwM1dLeCtQNUNkbWFxMHJSdHFpNEFpYktPNTdUSFNuRGNRN1pyaG9jVjE3?=
 =?utf-8?B?bWdybEc3OG9TdWtHK29sZTVTeERVQ01wclludkFLeWNQUk1sMDB6U3hob3NH?=
 =?utf-8?B?enpEdGFpOXBhRGJieVljM1NSYlNUTkRkaC90aWdFelNSOXhoVkdycTBvMnhL?=
 =?utf-8?B?YmNBVHVoblgyZE92c3FNNmFaN00zanVYN2pPVUJkKzhiaDVtdVhoNXlsUXNp?=
 =?utf-8?B?WE5PWUNEWEgreTZHYmROelZJRTVJRGhEQ2JGREZQeFlNN0R5UFBkTnZ3QUo2?=
 =?utf-8?B?bVlUSGY2eFUvSzl6VEp4REgyZUYvS1crREJZZDBUYjFTUTJud2NPSTBtSmpR?=
 =?utf-8?B?YlZUb0ZxdWZMVlVlVlBuMU9PS0Nsem9ZRXhzTng1QjQ0NlNWN3hOYitYRWx5?=
 =?utf-8?B?V1oxcHRHQ3hldGNPTFEvaDBuczNhMHhkYWhPZmdicTFySlJ2SnBhWHlPVWdp?=
 =?utf-8?B?S09pemoyK0NVeUlCcERLVklHbURhVTJPaTFydTI4YnVCUkhpdEVSWG9paG9Z?=
 =?utf-8?Q?wc/fGtq2QB+hGctQ=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2303ddd6-b8a3-4bfc-e048-08df0443e883
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 14:03:02.0987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5krTx6Qd1eV3+5bDgbVjwGWrf2rozGUcbWGvfAWo15+R6mNiqidDWKEucRXUUc44jqHc68FrLtTYfnzzvXdMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10361

On 8/26/2026 6:33 PM, Bart Van Assche wrote:
> On 8/26/26 6:40 AM, Larisa Grigore wrote:
>> +    for (i = 0; i < num_lanes; i++) {
>> +        err = ufshcd_dme_get(hba,
>> +                UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> +                    UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
>> +                &tx_fsm_val);
>> +        if (err) {
>> +            dev_err(hba->dev,
>> +                    "%s: unable to get TX_FSM_STATE for lane %u, err 
>> %d\n",
>> +                    __func__, i, err);
>> +            return err;
>> +        }
>> +
>> +        if (tx_fsm_val != TX_STATE_HIBERN8) {
>> +            dev_err(hba->dev,
>> +                    "%s: timeout waiting for lane %u to enter 
>> HIBERN8, TX_FSM_STATE=%u\n",
>> +                    __func__, i, tx_fsm_val);
>> +            return -ETIMEDOUT;
>> +        }
>> +    }
> Instead of duplicating this code block, please move it into a new
> function.
> 
> Thanks,
> 
> Bart.

Thanks for taking the time to review this patch series! Will do it.
