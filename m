Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011066.outbound.protection.outlook.com [40.107.130.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8E4495ADD;
	Thu, 17 Sep 2026 09:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635714; cv=fail; b=tUN2Js6NOuEbTgCtly4P8ZsOL/GCnG1DayaDKiyr/AVxFirR8OS+gkoke0rGrRTrr5UwqL+rh4YjUzG8lXRiE1U05hCPHVeJOShGZ0Cn5xKzH4yjdxOS4VBK08GB9Lf2pTi6TYZ4EfBbBqBsDtEfz9w5ZnAU8C15Kf1Cr2yKk1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635714; c=relaxed/simple;
	bh=wwy2OCN7YWDazcq5WHtYMuD3TWfOqTg59IC/GnZgVvs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rouRqEkG0x+LIk69hcQE6/5/Vr1GnQmsZafKzlHY88yU01yAJCpvkL9DMtK1XyXsdJnWjiS2rbDQAFEYrWv7vMOESXeCMdjf8/Q5lHQeaYxOBLIeFeN6YPyhP1YVZ97bXDpE2vwx9Tp3Wmqssml2bkphuefrg+ijy8R9TIGquMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=pUrJm7vt; arc=fail smtp.client-ip=40.107.130.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="pUrJm7vt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+E96Av8QgsXRpCkeLGPV//k5jMuTV+e/OADE+7mxD2NmpE3m14ezMZB0oKq7fagwDkIBPgw0oveXnAgksR9hQjrY+xRweOBCa2ISYyWEyjvPGBp7YyOqIhA/0Sf8vTDTBksD5tge+3lYNjJVcEK+munQ552fpNyS4kZNTL3BJkOOVePSFSK7TsEAo5Em1trU9nX1p2HJaEDupkXd//kz50Lk+oyNA9Q2KTbbsB57QvoeIaOGVdHNE61UWUA7AegWxLuvVIjNVd8jR4oRoB9/XmpPn10rYmOdBmzpI6hH9EC3lSEdzSPmD/xNAqZh8Rpp+LE8ZlIgFqMVWE0G08uXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pl86Q7qob2YZ5ErX/IcW3i3qQSczAXkFlgiZv1kD11E=;
 b=osOj6WpFDNxENdN/RfayFsZmzCKLBrO+PKeUrtM6WnXTZJ9xSgw2+9gKp2hztEIaJQw6FpT08VjILTOlNqoDs+ZBQ/YFF/UbqCpkSH5d3vgvXbyzXroGbjqzq2QZXr7BTw8dPFFXWJL1wYlN6P+Up68Goro6O2I9wwwDcjrhWmUEW2xEAhZprQ/YkxWjto7qGuHOWRtT0uwvlLixY3vEWYLm2XupRtOtLuhY+H1AwvwzCijGCKckZUBiy47881KaZE3KhxuYDUGusp7lWdr2/j2HQTygJAGef9FZIyYdu2I7PuSSWimaU5wayKb5S0pbfc9dF/fu0Y8MgYmQ5uHiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl86Q7qob2YZ5ErX/IcW3i3qQSczAXkFlgiZv1kD11E=;
 b=pUrJm7vtkrKrzU2YH052GpeM0B/qYeHx14Gfvfbotc3/X3HyB49zkkzC/mU5yBanBiWQszNqoj0uBgOWzNGloLQnKB8DRniRCej/Imx2vRBfZJOACXTzdcdIV/hsIlyGIr3puqoAVRtbdU/+c+eoBury95JEVb0P+jilWXOGGqLDpudgTnxOuuSLbb+mikRsGWPL/uSGGZy94RccFIA6g90YQIWvS2gEoyfZAzqo1iWUvA5MSCt88FJclru1KmFzpH+LtWhRkRt3T1W8kqWKOKQKbYZwPlphPHn+A1+ULx0w2YXeEQarr11JUlmXJ6y2p9E1HwQ9/WvshzUAb+lcyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DB9PR04MB11628.eurprd04.prod.outlook.com
 (2603:10a6:10:608::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 09:01:49 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:01:49 +0000
Message-ID: <697d617b-0cc9-4457-8070-128cfa9cfb53@oss.nxp.com>
Date: Thu, 17 Sep 2026 12:01:44 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
To: Frank Li <Frank.li@oss.nxp.com>, sashiko-reviews@lists.linux.dev
Cc: conor+dt@kernel.org, robh@kernel.org, Frank.Li@kernel.org,
 imx@lists.linux.dev, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-8-larisa.grigore@oss.nxp.com>
 <20260916090010.6C7111F00899@smtp.kernel.org> <aqrFo6eFD7fGtrHe@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <aqrFo6eFD7fGtrHe@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0065.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ae12f45e-0606-4edf-3db0-08df149a4f42
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|5023799004|56012099006|4143699003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XZMxP3WxiqcKvuGcjUvbxtFTiwfgxw7mLAt98kkmBOejGyh10iENMFpS+/U493byA/QWIODB5qoD14gj9o1vVYmkOV3Xc2K35zaeIE+r/Scna0p5zC6+ZeN1ybWFU78BTyhzHE4mEV6wpEh8lMxFndWZz6RKq7g5n+sXcVkrQfzjgTNP5295orbIKsApL++GaNxDU/axpCBR2fALzf9WiKFB/Gz6+nZLYYYi+rnGoK7TZTl2/NLr9ulcnZx05+I8miiUurGzayo7nuEywhG/1FXbp4LYFQF1TkiqeAEf7IcSjbXF+jqVrKnWRsaVCj0buFkc0wzFkUwsP1GxTW92TBbojM4nfAiWChVCSJEQ5bB8CB8TS2Gp0U/z8b6sUxXSMMWrg1n8NCn/EOxBXcNguFDj4/bg1taJu7BVUlbk4soe+isQiFfiOzA7+5Qftt12sfyPEyn9lludor1iuXzrk46y5QCpLynpfAXQqm6fWL+xxva74EhzL3P1YLa8c0iV7oU8Y+uZreOAtZ0pofRCkX23CG6v2pyTaQPnTQ5POok0ynJVLBsTk7qdXrRmhWjbYrjYPxecs58vNNNQKFTnCIG37iQxrR6RkgAM2lS761U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(5023799004)(56012099006)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckxaVU91VFJaOENkNFQ1MEVpamt6QTN3QWducUNzL2hPMEdWb2g5QnZZOHR0?=
 =?utf-8?B?ZmY4VjVSWFBxM2dYQ0dSQzArYUltRXlVOEMrQ3RkU0wrOWkybjhLWG9iWVg1?=
 =?utf-8?B?N1BDK0ZKZFZjQXJaaE9SSmdTTEI5MEVnUHdIM3ltMDY0WHoyZHJCM1VHbTdv?=
 =?utf-8?B?Mzk4TDhsOVVJTk1Oc3VWYnQrSDdGRUxmY1lmYlplbVNpRjAvY0d5eGg3bmFN?=
 =?utf-8?B?ejAzZm9HRmNjMm15Y0F1OU12cmpnT3owdmJlcmRtNEk4dnphaFBMa3lVMTRX?=
 =?utf-8?B?dUxVQzFqVzcvRkgvU3J2UGFDa2YwcERhblhaQ21HeHJWbUxqem14eWwwZEdD?=
 =?utf-8?B?bzV2R2ZqbGZqRERWL0FkbmFyL2lnRlVRSm56b3p2QjhpUnlVK2pYbU1HSTJk?=
 =?utf-8?B?aFdIK1VUZXVYV09JTVAzeEtoV3BRNTVlZC9pd0htd1NCZHpIV0kyY2ptM0xB?=
 =?utf-8?B?VTQvSVNuSWJBa0VHVEpGQ3daUFlJWW9FZEsvbWFucUtnUGRFRHVEcG5wVjdr?=
 =?utf-8?B?Qm9LU3FmUi96a3RSUjB5UElYWGxRMEoyKzN2cDRhQ1Q0MFBQK251VFpTa1BP?=
 =?utf-8?B?bXV1a0kyaDluNGRObjJwSTdqNmVrQU5WcVNiWTZ5aUZXN3NDSGhUeXoyU3BT?=
 =?utf-8?B?WHQxN0FwOXlCNVJYaFF4MnNhVUc0VGxRWEtNZDZVdVRuay8vMFVCeEhqK0dN?=
 =?utf-8?B?Z0o4eWkveVh3WGJ1WTVObWhVS3I5ZGZVSkhkVFNKNnZiMVljNVFQMm9HSkh1?=
 =?utf-8?B?dk9uN1p3VlF5aHM2VG9RYml0N1RpQk9DcVpidFJzWFdRY1VTUmJiTmVabm9v?=
 =?utf-8?B?ZUtTQVpqRjIyaFFtaW9mTjliSCtUaHhmeTM4K1p4TDFEL3ltVnBJSDkvL2lj?=
 =?utf-8?B?bk9tS0txMGMwM3Z3aWVwS1F5bEVjR1VhRGpPeDBBM0tDc3JsOEJhcGk1TTVT?=
 =?utf-8?B?TG8vVXhoRWdMNkdHSlJIMUNrZG9qUlBGUFA5ZHZrR09xM2xZWjJidmk0ekh6?=
 =?utf-8?B?RHR2OFVVWVNYOTBpZDZXLzNUUnBZUityTGNFR1BZSjlJUFVyVnFiM04wYk9D?=
 =?utf-8?B?U0sxOTZvbzBNYU8zQVNLUEVtSmpUSGExUFQ4TDR2Q2IrNFhtWG5CNVBxVTlE?=
 =?utf-8?B?MzFNYmtZN05BYlUrR1ZRcjdjRHloQ3FJL1Zrb2QxU01YNFpJMWdBNjl4WnhZ?=
 =?utf-8?B?UFQwdXVyYnBJcnZMY2JOdkR4ZzZuMVlXL2hzS3R2Ui8ybnFaaUFqNG84bzJQ?=
 =?utf-8?B?S0tvTERuUVBicE9hUW1wbEpteWZMWUMzU21QT0tHUk4xSFh6S2tmelduVWlk?=
 =?utf-8?B?QlVEZ05rd3BVazlneUlpWm5DU1ljOXhHYmRiUzVCSjdXMjlMdmxNODU4SFAx?=
 =?utf-8?B?MVpNMXUxNTEyZ2JMcDh3VFJWQWN5T0dDRG56Z2xEdlBzWkZMYTRtUFlkM01E?=
 =?utf-8?B?aWVab2lrV2hCUnlwa0FmdTY2MUUxMWpvckhyZGpiZk5hRWE4MzMzRDdYZmJa?=
 =?utf-8?B?QU0vVEw2Y2tkS0ttbnpZdGZVcU5hUzh6dld6QlFGcGZ4aEI4RVFCNy9JelE0?=
 =?utf-8?B?QldSc01ocUY1MmpXdk52R3B5SnY0QWNhdGpHd3B2d2piNmJURy92S2VseGxj?=
 =?utf-8?B?M056ZU9UVUc3cFJ6aUZ1V0hhNHZzOG44bUhwQmEvZFNjK3EvQUd3d3ZBbEZS?=
 =?utf-8?B?V2h4WnQ3MjhaQUZjS1BVRXRkRjJJSlNPVWpncFFpMVhBcHNDQ1A0RkkzM0Np?=
 =?utf-8?B?RElCcWhLMDJHa3N3RzlMN3NZQW9iZGdUdjhXWHpOTTZKR2F6Vjl2TFkyWHlm?=
 =?utf-8?B?VHQySXZmT01wTE1Sc092S21KOXYycHNkVk13OHdtUDl0bHYwbFM0R1BidjZu?=
 =?utf-8?B?K3BlQ0dzbkUwZzd6RXdmNjR5d3RxWTMwcmZDd2ZRWkg4VTNPc1pMZ29pQXhC?=
 =?utf-8?B?R1hTTTY4VlNuVTluelY0NUhGdUZ2UjhRMklNeXEvdGdVajAzN0c5REgrZ3Zx?=
 =?utf-8?B?ZVJueFM1cjlkZzBRYWZZb0kveDJQZGVQYUtCNEJ6MWFub2VXeDhGNWlBaGt1?=
 =?utf-8?B?ZHQwcnlDT3NQTU5VOE53QTdXUzd6RHBYUllvMTNkSXVYVjB0bE9TUmZhU01r?=
 =?utf-8?B?Y3pyMmdJK0lBMFNlYXNuNjIvK2FheC94Q2J4ejZJTHRNVEhwYm5oVVlzdlRR?=
 =?utf-8?B?emxUNExHVWliaUdhRVpvZFZlTDVKNHNaZEJqaS9CNjhteDRJSFAzOWRncXdn?=
 =?utf-8?B?RGdtQUhaNHNIbWxSNXZTbzVPL3grbFRKdTdIUUVYNEhkWGpMTUJjMEtrcnRC?=
 =?utf-8?B?K2hTYXFaQUJLK1pxTHV4MDBUM21BTS9uMDBPUlA5Ky93dy9HaHJwZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae12f45e-0606-4edf-3db0-08df149a4f42
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:01:49.8114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: my/KMjw4OEjxOnAQAVrKcGmyIWbsr0MZ98wg5cD5bjEKqA7mtX1+7rZ2hclysDt9eoJxTkRQ4U8P2jOVC6tgAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB11628

On 9/16/2026 7:36 PM, Frank Li wrote:
> On Wed, Sep 16, 2026 at 09:00:09AM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>> - [High] pm: positive return in ufs_s32n7_link_startup_notify() causes unclocked access
>> - [Low] pm: missing pm_sleep_ptr() wrapper for .prepare and .complete callbacks
>> --
>>
>> commit 774c9ff68bb8216bae4f82205ba8ce70b0364e59
>> Author: Larisa Grigore <larisa.grigore@oss.nxp.com>
>>
>> scsi: ufs: Add NXP S32N79 UFS host controller driver
>>
>> This commit adds support for the UFS host controller on the NXP S32N79 SoC,
>> built on the Synopsys DesignWare (DWC) UFS architecture. It implements
>> S32N79-specific initialization sequences before link startup and applies
>> post-link calibration for HS operation.
>>
>>> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
>>> new file mode 100644
>>> index 0000000000000..4f9a001562024
>>> --- /dev/null
>>> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
>>
>> [ ... ]
>>
>>> +static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
>>> +			     enum ufs_notify_change_status status)
>>> +{
>>> +	int err;
>>> +
>>> +	if (status == PRE_CHANGE) {
>>> +		err = ufs_s32n7_link_startup_pre_change(hba);
>>> +		if (err) {
>>> +			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
>>> +			return err;
>>> +		}
>>> +		return 0;
>>> +	}
>>> +
>>> +	/* POST_CHANGE */
>>> +	err = ufshcd_dwc_link_is_up(hba);
>>> +	if (err) {
>>> +		dev_err(hba->dev, "Link is not up.\n");
>>> +		return err;
>>
>> [Severity: High]
>> Could this propagate a positive return value on failure?
>>
>> When ufshcd_dwc_link_is_up() fails, it returns 1. If this positive value is
>> returned here, it will propagate up through ufshcd_link_startup() and
>> ufshcd_resume() to ufshcd_runtime_resume().
>>
>> The PM core's rpm_resume() will treat the positive return value as a failure,
>> marking the device as RPM_SUSPENDED, but will propagate the positive 1
>> back to callers of pm_runtime_get_sync().
>>
>> Since callers typically check for failure using a ret < 0 condition, they
>> will assume the device successfully resumed and proceed to access unclocked
>> or powered-off hardware registers. This can cause a system crash or bus hang.
> 
> look likes make sense, please check.
> 
> Frank
> 

Yes, I will create a new commit to address this issue. Thanks!

Larisa
>>
>>> +	}
>>> +
>>> +	err = ufs_s32n7_link_startup_post_change(hba);
>>
>> [ ... ]
>>
>>> +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
>>> +	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
>>> +	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
>>> +	.prepare	= ufshcd_suspend_prepare,
>>> +	.complete	= ufshcd_resume_complete,
>>
>> [Severity: Low]
>> Should these sleep callbacks be wrapped with pm_sleep_ptr()?
>>
>> The power management subsystem guidelines require sleep callbacks like
>> .prepare and .complete to be wrapped in pm_sleep_ptr() to prevent them
>> from becoming dead code when CONFIG_PM_SLEEP is disabled.
>>
>> Assigning them unconditionally can cause minor memory bloat and potential
>> compiler warnings due to unused symbols being retained.
>>
>>> +};
>>> +
>>> +static struct platform_driver ufs_s32n7_driver = {
>>
>> [ ... ]
>>
>> --
>> Sashiko AI review · https://sashiko.dev/#/patchset/20260916084411.941297-1-larisa.grigore@oss.nxp.com?part=7

