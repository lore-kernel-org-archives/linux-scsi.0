Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013050.outbound.protection.outlook.com [40.107.162.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093324A4848;
	Thu, 17 Sep 2026 09:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636016; cv=fail; b=S66CMcF5Yi4sz0n5vhwPP1IFfO0MxJbVkpKRFvrtO1U63gAIoFhgWWuKIdAposU/47tI5JUExbGJ3eihioOqMFGq0pu9FMGG8PuRpviuOOkmE3/NS6JrSbS7MfFMytnQ2psMAS+hXTGT4ZbxwlROPb8aSSc3/dfWBohHw3W+8ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636016; c=relaxed/simple;
	bh=GiR9S9ip9uvsrT9O/aFFMtmYZ06vySjM/GnoPwCGB9k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gurM2gCeuLonvWWd1kV6HWM07OLlJ5/DpQQfeydk+jpa5QiIbhbs5Z9VQWLSoa9/u/8oNdnr/zjYrUfWJYZ8Dn4QXMVt3blfFCtNnLlYos6J8SwuxoMMt0M226ZY20iG/XVWNZYez2gDNDfplIX8E2XJEG5d2wB0NFfSbcFg3MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=CaWfUtnw; arc=fail smtp.client-ip=40.107.162.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="CaWfUtnw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mgww5GKCxNNplpJqA0sHK3c3eJQ4QxrAM2qXs0HMgPHu7NmHLlo/ZYz/i375I3J3wFXWyD91yi/CTaYbSAZRifUIcL0QKoVNwTO+jOZ9NkNXNjdITDnJD/U6eGfMrPgy5u1QvNIoANGSxHH35q2mgxSGuN/L6soIv5zy+veJ+pDI5G46MOWyAKytvM2LQN+4uMeUm2mhgM1+i235KMT02yR3b3aA8he3xmAl3GYMIa0+Fsrt9q84Ud7rrBpAahv+kTrFugg0+99OQ6xMdRWK+0cNVeuz6aTsHO1Gw3fdL8JE6rGLtS24myb1b5CGxNCvE1tz0tZ9/MiKlrlNhugTtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6vOyAnTn8H0j0Ifv82EYPWH4yN2qc1ycqc49+RVtLI=;
 b=mMJCds6z4tdOoKln0Lg92tPQQzP0Q0aK5QaTh8m1HhplZqhb1f3XEbf/LfxMonEWNHFu5ymyfI1uUPuxwL+8bFJRB/u5NuEUhIthI4HQKgSK5furSkZbniROI2aeNGrkP/xpc9+as7d8xaZubA24IOrsvKxdf7dubYg+fibTulfbmFE9t6L6qeMtc8SyKd5x14G5ruOtYIVYpQg/Np3j58hZ0nqq5ACL8e8siJAusXFyAWcKMYbGX1urj1+4v776cePaN7daD4CWNK6W3tXXF0w0YvegjysH4DRT3gCRD6r6q5FFEGVtSxLW0IO1TOk1YJ82Z5DSv7gjRX2BaCQUrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6vOyAnTn8H0j0Ifv82EYPWH4yN2qc1ycqc49+RVtLI=;
 b=CaWfUtnwGYr/zPU/92XntuyaWL9uttyHbMb8ePCvsRQJVMcHOMl/mDjDnhr1NowcMiX0uBC6aVFmfGF1QeFpoXbzchh/DPG5Ny6TmrLyjD4abzbB1aqnc9i2uTRHxILvjeWlUQIjjkPUuzw62kAt0oghHjFl1vnQcoyOeLuBNMW5gaICi+cX5t0CkOvx+654z8TgTfw9RsJ47uVpZXvnQIMIVt44A1WmHiUvX7/S7m4oMn+LQJY7/4Aar9MZbCYLPRp63A48FILKNRVe7uQ9hvcbXD+0/QXfnLT7WfBoKR0lXkHPCp1iW/SYmRYA/pRn94SyBto8GJt6HwEyaVYCgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DB9PR04MB11628.eurprd04.prod.outlook.com
 (2603:10a6:10:608::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 09:06:51 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:06:51 +0000
Message-ID: <289dd7ff-023e-4220-b573-cf411f0faeda@oss.nxp.com>
Date: Thu, 17 Sep 2026 12:06:48 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
To: sashiko-reviews@lists.linux.dev
Cc: conor+dt@kernel.org, robh@kernel.org, Frank.Li@kernel.org,
 imx@lists.linux.dev, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-8-larisa.grigore@oss.nxp.com>
 <20260916090010.6C7111F00899@smtp.kernel.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260916090010.6C7111F00899@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P191CA0022.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::27) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DB9PR04MB11628:EE_
X-MS-Office365-Filtering-Correlation-Id: 92359d5c-dec7-430c-469a-08df149b02bf
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|5023799004|56012099006|4143699003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yTy2jMf5WjG3V+R+6eTWNu71KoysBy6pfpL8D2ukY7+AOLVP1npQTgX56omikRY5P7aepGrhXmVVYXFgVt4J6jnL77MQxP5ElHdGFDDS+FpIAuB5HTKhm9D1V5gQfEmWv045IcqDo0seK7YT+8871MfTWpoSoPaYNIsRNuU2Vm8ae+BWxds3pkE8iXu71jNimb7+aCuWBHchVF1xGcojLRZg7D6V+Owt32zNHS02hPGpB7L0bBL01K2VQF5MkrsdAGEK28ugOEmDZkrIi+fIrAwIXSOpZRk4ySRe0xQ8YP/glaR//Sa6rio190xDS6AcDbbX+Lk11da0ZjAbPxQujC6rknMpa8F0TNawaoTMTldZXTAD8gfcYvK9uKE3kYIv5lUY4GzHU4d9bRgb8A6huGZp1MAwlLTJtiVYqL/bSOsw5Bi2xQKrnrAKHSBKbvbcGibE2i7qXfiemRsoAgYtOr/U52YNcQ3zj6sP8ADYGig3iAb0CS0UZ0eKGQBCGZi88kFdmYZRN+TUGIMfDwDQFX85to24GwCKRjIcWhhGRxsZsbxkwzoW4UjJ33+h8MjgXoHxQAtCQ04hXy2GvBP3LuDbRmyWK6GpQUTGtmpTzPQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(5023799004)(56012099006)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHVOR2xXbDNabnpTSmZ3dUFKUzEzQzNqZFhCN1VseklEbFlVR25Vd01EMWhN?=
 =?utf-8?B?NlRvcHZZUU9sY3I0WGg2Tm1aM2RwL2N3cFYrck1uTHNleFRPdzVQRUxTUHh4?=
 =?utf-8?B?T1doeFJ5V3o2eEo3R0M3bkFyM2FYMnVLQXAvd3A0T2xjSEVPVXpUa3lFTWZ5?=
 =?utf-8?B?THhYMTBLdWlCYUkrbVdxVmlTSjg0emZidWhvTDVsQThnY1M5U2wxdy9YVnJM?=
 =?utf-8?B?bGl0MzFtdnpBek1RRWhvTGUxcmxDM1o2S3lBanNnYzU0dnAwYWUrTkdyc0w5?=
 =?utf-8?B?c3ZFQ1k3ZnRxOFVQSEswYnBxTHJnVm5FLzlqL1o5Mm54YnBkYTkzc290T2Fw?=
 =?utf-8?B?N0E3aE1Kenk1TnVLZk1GQWhmdWp0Z2IvWGRIcitMcnpjRVh1M05wcTg2b1pT?=
 =?utf-8?B?VFNnQk5RSFNpRWduTUVpNXNSUHh5cVlPdC9oaCtIWC9PTlZsVEJua3NieGxW?=
 =?utf-8?B?U0lBclRPY2ZIa1pBcm1HR2JZNXdSU25qampDdUFRUlBVY3Mxa1dyQWJIdGZZ?=
 =?utf-8?B?b0VqVmxYcVlBYWJhQkFjaW5CN3hQNW9wZ0thWmdOREFueEtjUFUzSFliWmtY?=
 =?utf-8?B?YmpHQXY5N2JxRXFubnFvY2c0VXZDcytLRjVqV0M2WE14Z0U2TUxPYXd1cEN6?=
 =?utf-8?B?VlRka1FqeUZZNWoxMjhUUkpPajUrYVMwTW8xQU4vU0pmbE5VbVpEUHEwdTli?=
 =?utf-8?B?MmNwK1pweXRJRnFrM1o4SllBRzRhelZPemtuNWdrK1RCTi9DRTl0VUNQMCsy?=
 =?utf-8?B?dmNmdVozMURYczVPY1hTU2cwVS82a3VUYmd3emhTb3htMWpCUVlqczIvWmta?=
 =?utf-8?B?NGhmdzFLRkI4eElubEVDRUp0TXIyRWpQdzJKUG9nc1VkOGY5aU9aWFlCdVRD?=
 =?utf-8?B?dm5HWEVPOUd2VElNVkM0V0dVTzlIdmRHczA2WG4zY05mSUNwY3NHb3RwcVBu?=
 =?utf-8?B?c2IxNHpRcG5BMmF0b3JKOW4xbDAzTnRwTDVXbGZNOXo4S1RONzI1UTFGNlk5?=
 =?utf-8?B?ZkVyTXBzWTdUbXU0STFjNnhyb0V0TEZQMWN1SVYrUXF1S2RRbGx2NWZzOGhn?=
 =?utf-8?B?OHlKYXVlanpQRzB3MWVuamhKM0NxZ2tpUTEvV1VwUVd2UitMa2drckhFdG8z?=
 =?utf-8?B?MHM2KzljK3E1bThzaFBONWZRWkFjMEd3MllKa2FFb2N3K0MyNzRCUllGNjly?=
 =?utf-8?B?bFFqM05tVGVqamNZYm9HbG53ZHpvR0FXdHVzYXFOQldCMDJrTml1Tk54SEk5?=
 =?utf-8?B?a3VmdFA0SEd1Zm1FbWJjU1JCYzVrSDdhUm51QWVBbFcwRGY0UEFsdC9Od1Z2?=
 =?utf-8?B?T1I5SWRseTIvNm5pL2dES1RKdDhLY21Gczd2RUFKZnY5U1B4cU81eWpxZVgw?=
 =?utf-8?B?RVgzY1VHeXVUOGlvZDF0Yzc0NWZjT2s0TW41Rkl1ekRSMlBNVU16cUFndGti?=
 =?utf-8?B?TVQreG5qWTdQblUwUjlxWnhya1JmUllQMU1kUFRMM2pZRTRwdkFOR3BBUnZL?=
 =?utf-8?B?TE1TdFdQSW55dlBZM1lIcEsxaFFvQ21SdFh5dXpBaWs1QUZEU0trL1BTeVNm?=
 =?utf-8?B?c1ZaM29ObTgyVUdxd1Y4OEFnRnRidkJIWkpISWRZZEt3ZlB0S2taODdUTm9D?=
 =?utf-8?B?SUpDOGQxSnRaTEFvT2ttSWFyU1NMcEhGY3JSM000T2VVWUJGaXBTU2wxU1FV?=
 =?utf-8?B?Vjk3MUczYnNKTFF0Zkd5Sk8zK3c4Y1R6T1dUMWM3YnZHQzY3aVZ6SnBGeEsx?=
 =?utf-8?B?NWxCS2ZyMDRtcXcvcGM1a2J0bFF1NzFkaU1ONHpQS3ZvRlhOZE9STFNmMGxC?=
 =?utf-8?B?VlhPb3h6Ymk2VEhRYnlhWFNKSXpoUXBHYTRiNDUyNlZvWDBDVFFwdlRHRnFJ?=
 =?utf-8?B?ZkQ4d2oyRldteGIxS25ML1ZnMFpCYWhNKzFuMzVtL3laWU9DVldudzQ4Sy81?=
 =?utf-8?B?emdzS29Bb0gxOHlqMGVNNmx3Z20vaWNvQzVWR1A3YTNnU3ZKT2NVUEI3eEJx?=
 =?utf-8?B?cVB0bTRwNE42dXZvOGRjTmxxOFZXT1BUWmZkV0Z5RkQ1aTcyQ3dpOXFiTmxn?=
 =?utf-8?B?L2l6OGs5YkJkai8ydzJUa3REN0J1djJuRnptVUhBdittT3REcGd2a21uMnRO?=
 =?utf-8?B?UTcyUjFmMWNvaU5pK3NiMGpaMThDWHovL1ViRi82clZlWFU4UCsvdm1MUFBU?=
 =?utf-8?B?eUtTT1A2eFhBSW1aMDVLSzJvMnljRnFKd3drT3k1Q29pZGZicElmamF6Rmg2?=
 =?utf-8?B?c0xWYUxGZlF6MU9iQTMzQWl1Q01GWmJBaEZSYTNiN29ISWRmUGJqelBrNktJ?=
 =?utf-8?B?T0FaNSs5R2x4Q20yZ0JuaDVDc2MrS2prM3NMak9TS3p2VnRkM2pFZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92359d5c-dec7-430c-469a-08df149b02bf
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:06:50.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNoUuEw3lrZft6vlGI18TiEhskrXWM7TuXVSQu9h0i0kW2tCiyA4C1be6l5s8w0qGN/4mcrZrt0uNlycBGEEfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB11628

On 9/16/2026 12:00 PM, sashiko-bot@kernel.org wrote:
> [You don't often get email from sashiko-bot@kernel.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] pm: positive return in ufs_s32n7_link_startup_notify() causes unclocked access
> - [Low] pm: missing pm_sleep_ptr() wrapper for .prepare and .complete callbacks
> --
> 
> commit 774c9ff68bb8216bae4f82205ba8ce70b0364e59
> Author: Larisa Grigore <larisa.grigore@oss.nxp.com>
> 
> scsi: ufs: Add NXP S32N79 UFS host controller driver
> 
> This commit adds support for the UFS host controller on the NXP S32N79 SoC,
> built on the Synopsys DesignWare (DWC) UFS architecture. It implements
> S32N79-specific initialization sequences before link startup and applies
> post-link calibration for HS operation.
> 
>> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
>> new file mode 100644
>> index 0000000000000..4f9a001562024
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
> 
> [ ... ]
> 
>> +static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
>> +                          enum ufs_notify_change_status status)
>> +{
>> +     int err;
>> +
>> +     if (status == PRE_CHANGE) {
>> +             err = ufs_s32n7_link_startup_pre_change(hba);
>> +             if (err) {
>> +                     dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
>> +                     return err;
>> +             }
>> +             return 0;
>> +     }
>> +
>> +     /* POST_CHANGE */
>> +     err = ufshcd_dwc_link_is_up(hba);
>> +     if (err) {
>> +             dev_err(hba->dev, "Link is not up.\n");
>> +             return err;
> 
> [Severity: High]
> Could this propagate a positive return value on failure?
> 
> When ufshcd_dwc_link_is_up() fails, it returns 1. If this positive value is
> returned here, it will propagate up through ufshcd_link_startup() and
> ufshcd_resume() to ufshcd_runtime_resume().
> 
> The PM core's rpm_resume() will treat the positive return value as a failure,
> marking the device as RPM_SUSPENDED, but will propagate the positive 1
> back to callers of pm_runtime_get_sync().
> 
> Since callers typically check for failure using a ret < 0 condition, they
> will assume the device successfully resumed and proceed to access unclocked
> or powered-off hardware registers. This can cause a system crash or bus hang.
> 

Will address it in V4.

>> +     }
>> +
>> +     err = ufs_s32n7_link_startup_post_change(hba);
> 
> [ ... ]
> 
>> +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
>> +     SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
>> +     RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
>> +     .prepare        = ufshcd_suspend_prepare,
>> +     .complete       = ufshcd_resume_complete,
> 
> [Severity: Low]
> Should these sleep callbacks be wrapped with pm_sleep_ptr()?
> 
> The power management subsystem guidelines require sleep callbacks like
> .prepare and .complete to be wrapped in pm_sleep_ptr() to prevent them
> from becoming dead code when CONFIG_PM_SLEEP is disabled.
> 
> Assigning them unconditionally can cause minor memory bloat and potential
> compiler warnings due to unused symbols being retained.
> 
ufshcd_suspend_prepare and ufshcd_resume_prepare are not guarded by 
CONFIG_PM_SLEEP so this is a false positive.

>> +};
>> +
>> +static struct platform_driver ufs_s32n7_driver = {
> 
> [ ... ]
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20260916084411.941297-1-larisa.grigore@oss.nxp.com?part=7

