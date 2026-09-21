Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012050.outbound.protection.outlook.com [52.101.66.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECDF36E46E;
	Mon, 21 Sep 2026 08:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978769; cv=fail; b=fbIFBUvmizkApFcma1n0aSyCr159nsVrroQTc4E7oek5LmFg0soaIseCQJxWz0XkYo2H9jk3uEQ7ICP6eL/4zEep+6wHtLhZQ2Lgy3hyu+3yvjaFGrrywCsziv3Hy8fa845dXD/KFC0suUSeJ8Ay+s27o6ee1Mxl2MF9v6uuuc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978769; c=relaxed/simple;
	bh=wkDeSrr8yLmRDDRNUPinF/cPLt1wsXPKSGnG7zoQ5M0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FPz8pnFlXpo15B/sn/Wz8yCLNyKkJ+9DSCBw+WZWG8qZQP0/67RCrNcpIK/gjUjqcjOtQsa67vwWYyXMw8QDdzsRA6+qYT98xHpFx4dLzR+jZQ7GgqP/N3TecouqXHZ3N3jeF4vitWkjU6O8b3LVm8iKdqhvmYOVkG0rJzinb1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=YVGHfmDz; arc=fail smtp.client-ip=52.101.66.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="YVGHfmDz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OWc21WW+RV6RALs7GzHecXa9sRXgo7zn17ty8Rzz2ISWP/ZBn+syRu4fVo0SExKenjbCAGyqE6hX3xbHRK7HWcv3VRa7Glj4fcjDQvTwZKT81FqRM9NTrKbXOO3SVEZNcomyKEFfbfnDp37nxKEKyciOD5Radrq2MmsVZ605C/A6JnBAKjTRDcZrBxBLBSZZK3HWuCV2dpnb0w2I9InVWIvDJ05CX3WcRjZhS/7K4TeswF0qdNwp45xxO1joyuiZwG3Qhl97okmBx8OQOo3n9VtDq0KTN1IS9h6k+hnnuXc3qej715FcAC/+aoHwsDEXwsWUZJSPmAM13X89R2BfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvnPw7uWEwwHNymLUK8VN2/FZ1/mTC9WJeRpheEEwS8=;
 b=BYpBCjCcjXLj2fZAt6u4UF9g0NsjMfS7rGYmduKrBs9LQ+7jJ03fwGrISid7/2YEVq1S4C1oTcWNsFQoYG8nMUHJ0XKJV8Trim3fYI0llurhXZDYtBZ0pd+3K+tWkqM6uuIfIaOS/BqYDw17tZi1m4zrusgXs8dcgR3GLWmNxddkWawR1bCVpwW/xzVIfHelJrlqkmCgecxFkqzV5v8kX8oUna+OY+ASqoiuvuamejLBdXoFOq3xCFexWTIEmmjgEDTfeztyZfZjvzf8uM0aqpRxDfkjRWWu4Ax4NBVusXWJrRaP1xcxvW6vLUNmH2vAdI6YNoNnC2HaCuD/7dvh4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvnPw7uWEwwHNymLUK8VN2/FZ1/mTC9WJeRpheEEwS8=;
 b=YVGHfmDz6nG80rplgK887u8180M8lrl3PHdlCg3PkIWT8SZsdvIAkB1+YH39nS0UoSqpxHVIrNRxL2Q5O/B9FGvYPCQ2N62KGRG4G99Re9svjzOv9j6PkiuG6RlXs4Nxrov+JyPp9WHAhrt8VwvUjX5uTaOa7OGTkhrzDi4NdRhKB+CmWpKwN4TXFYlQ1SbHeJ/kTpj7nMyyaCxPkKkSfcLlvj9FY6+CfJvSZwksFr7Ae+tQBJqLKiJWRfharWqKB9odIcWAQik5Ec0xmcvY0uUxSz1BMgHr1vuuyd20LAiccePymne+amrVdJ/jAqECRXlFldyPN2CRSzxJqO7p+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM0PR04MB038800.eurprd04.prod.outlook.com
 (2603:10a6:20b:801::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 08:19:24 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:19:24 +0000
Message-ID: <1d47addb-24b7-4891-bb19-b754cda22711@oss.nxp.com>
Date: Mon, 21 Sep 2026 11:19:20 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/11] ufs: host: Add common Hibern8 TX FSM polling
 helper
To: Frank Li <Frank.li@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
 <20260917091555.1443076-5-larisa.grigore@oss.nxp.com>
 <aqwPYEvGiamxNW3T@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <aqwPYEvGiamxNW3T@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM0PR04MB038800:EE_
X-MS-Office365-Filtering-Correlation-Id: de9c892a-873b-46bf-1390-08df17b90be0
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|19092799006|366016|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
 pf19Dribgf3YTtaJQ8Ct+qbY6iP0LzOlzJHLGDsqoqud8KXGxLzl+VbDeEwbI6pNpTSbnaGbiUZcu+BpzWwtkTPkknfV51LcCHnvcd3bn4nY8EpbyvBUvWiF5pFTnH5FhJzlNm1U2C0ZpPDsz0iK6hF3fWpXcGgkV72M3bmjF1x2DNZAbgRDRH7BBPgikAUPzNEnaDtEywdKr5RbrN/eWSu4k3AELjHsrzp8CYYWUgnH+mI6l9rMTPwwB7NABNJ75YXgGQirbQTNV/fKOJfF7OzKm17nQFcaW6sjQ7N3An68rMSvw+O9rzuX3x8oDXLoeH18bl5GEMIFWGqdfHilt9PEWX73I6W6nQjJSB5VtbaXjzgGDwl52cIRvmo2xMzFRQKaiwbo2ly+ecWx+8QDYEVgIUBERvKLjYm7ryivHbxpzm1eTeW74uYx+7tU2QfLl4MpGaiculimrEMKP30xrlPv21Q0MOu96ftAS6N2RonNuzJ3+igMAG6SN7kyaWMZA7kiKeFSjbgGeW468NYGrjsBIyiT/OtZg2WNFOgsnEHjB0QLUL2C7bx7kM99ALsKJ/LZQRrwyiWlaxKmURy1hJzZlqMemUmnne76WAPzu2zpKxMSiSXVvmleL97qlxWfjvOZeIuIbdotxaoG+/fwfqdeEIDtVza8sn9zxGLuQXc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(19092799006)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dW81K0RRRFVrbStSSkhhSnJWTmJDbDNFc1JoZG1WcWhrYnV2VlltNXdnTmtR?=
 =?utf-8?B?UURTYnBJaVdJdnBEY1lLaGQzUm52b2RENlFDWGJFOXpxdUI2aXF2bHAyZjM1?=
 =?utf-8?B?bGZEVlFzck50UmJJYmJSZHRaWjhJOEQrbjViRE93endzU1JaQTdQdVY2bi92?=
 =?utf-8?B?Mi9nVC9vTkFMZEJZYVFHS1VTczNQazNtL0hteXQvdGgvUlFiOTFPT1NDc21F?=
 =?utf-8?B?MU5hM2cxQnJLanF4MjlUSkFDaitNeDZYUFBUNE9ra1RhVHNkNWhxQzJwY21v?=
 =?utf-8?B?VHVhMklCbDNvb1dqMG9OMlRUcE12VW9MNnhSVitGRnc4VWRMVVduclEvTnlU?=
 =?utf-8?B?UFU0N3VHRUZmMjlDKy9JWUlvWGhyRVZOL2ZXeXZicGFhNHdsKzVOQzhpSWwv?=
 =?utf-8?B?NEN2a1lyUXJCTVVFdFNNZ1dLY013U2ZLUmhxRll5enF4SGtwRUZVZ2dFd29O?=
 =?utf-8?B?U21Tc2JpODA4RUlIakYzZDRtNVpzRWNyRmxvQWs0TnI4WXNkM1k0NGQxRTQw?=
 =?utf-8?B?TnZtS21IVnMzZURRRC9ock5mb0IwZEpvNHVVWmNibmpYS2F0WXM4VGEzc2o3?=
 =?utf-8?B?V1JBUU5RZFpRZXVBMW1McVdwVGNQaTViSkdwQnhyckRhdHhrYk1hRjdzVUYv?=
 =?utf-8?B?bE9wMTVQdjd4NWdpdUszUjlHYjZpQmgrbHRMK2JHNUt6emh2SEtpUktDK3po?=
 =?utf-8?B?ZzBNbytidFJpRzMvTHYxZE1nR3UwajdzQlhKdVh1bzVaaUZjQmkxT2N5QWNr?=
 =?utf-8?B?WUZPb29XcXFEMlJBQThHcjgzOW9LV3NRQ2hJMEFuSVhsZC8yR2t1Z0E2THVp?=
 =?utf-8?B?aE9scjRYOEF6UGx6UmhuSUpPM3F2b05YdzczeXlzM3hpZEprL0F0V2NjK1NR?=
 =?utf-8?B?SVVicldlVTY0QUlYZTJrbVcxd2ZSVlZsMG0wRmg3c3g0OFpTNXEwZjZIWlcz?=
 =?utf-8?B?Myt2OVhNdjY5cjI2aUMvZDZCVkYzT1MrNllOMnJacjRaTHdubzZvakE0VjRi?=
 =?utf-8?B?eHcweW1WUkhOQ2JxNE5YMWtQazBjbWpBampwS2VlY2hYeE9IaTFpdmNnb2hU?=
 =?utf-8?B?TmdrQUowVzNPN2ZHTDVBaWM0ZmlUcldCUXNEMWRoVEpNaG5WMHZzR1BaeVNL?=
 =?utf-8?B?NUN1SDZjWmtGVFVzeGNzbUVFd3JUZ25laDVKZDNYYVBsSmZHMithNTJYeGto?=
 =?utf-8?B?ejRMVWtZdFZlcEt3UnFUb0VMemMwWm9uaWszZUdHT0dxUFhmN0x4WjVUL3hR?=
 =?utf-8?B?M2VWaW1aaGQ0L2JJV2NydEo0RFIwOEV6dithNXdCM01wM2NFM2RkTm5IdFBB?=
 =?utf-8?B?Zk1EdU1oTjF5ajdyeUluZEp2alJVTEx1Y1YzOHRrNUFmalpwSzlyVXhNZDRw?=
 =?utf-8?B?aHBUUG81aFUwSjJCampJeExZWldIL0czM21iTDk1S1Nuc0lLQXphQzBmdUlO?=
 =?utf-8?B?TUc3aWQ2Tzl0OGRscm5zNHQ2V1E4YUxhaU8wRmIwQWtoWUtaejE5MUdWS0Ns?=
 =?utf-8?B?Z1lZRXMxSWNKTUhabWYrOHZKOWpWLzZ2ZWVYUWExSmNUSWxnTlRvVlEzSm0x?=
 =?utf-8?B?TE1TbllkTmRIaDExRkRFMUlNMmYrZnJFZCtXZEYxS2xmc2t2MFBnckxxVURw?=
 =?utf-8?B?eXdIb1NMbC9rTVo1Ty9XZXVaWmowcHlVZWo4MUgvWjJ5bTRCWGtqT0lyL0ZZ?=
 =?utf-8?B?Z0Y5RGQwQ3F0QTBTLzQ4MHN3emZ3WTJ6U3FpUHllZnRndHpVNXdqejEzWENK?=
 =?utf-8?B?NUNvSDVucVFmakFhSUQ3dlBmVjZ3KzdmV25KalBkRkhqY29hU1ZTUWNJaGh3?=
 =?utf-8?B?RGJzSFUrRFVqVmFzWXBmK3pDSE5GREZEQ0dHdzN2OVlPZWhYcHEyc0hUeDUr?=
 =?utf-8?B?SGxkWFhTK3pxS2s0TmJsaHFzWUtTQU92OGhOSWc3Rk9iNmpvWmpVRDFOUjcw?=
 =?utf-8?B?c2x6OW45T0FQUHBybm1rajE2VHdxUk9VSGVZUTNYUG10Y3lRdlJLQmRoVmZ4?=
 =?utf-8?B?Mk5Vem5zN1lLNFI4dmpheDdhVXBjN2lXQTRQNmdPYXFnWlNKS1dhVC9CZUtI?=
 =?utf-8?B?MWs3ZC9RdGdkZlVDSmxrUEFZVjVsTXk2Z3ZSazZvZ3VBMHo5clhZRms3NzN5?=
 =?utf-8?B?dTlRMWxDWklUWHZpZEFaekRTUDZuYlpwK3JoSkpEdTF4UGNJZEpKTThUNGcx?=
 =?utf-8?B?THF5UlB5ckNUY3E1eHlydityVG1EbDdOempCWm9Oa1N4czh5Zm1QQkRxRVdp?=
 =?utf-8?B?VFMxOHRNVk9MNjlud0kwbWJYZ2RJS2I5SGpzN1N3b0F5VXZod09GK1VmYmRC?=
 =?utf-8?B?VXo1Rlh2NlVBTkJUKzFlMzR2S2F5VjVPMlhNalE2ZGRkRW1sbk0xZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de9c892a-873b-46bf-1390-08df17b90be0
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:19:24.6482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohagEJxA6il2ZliajaXxcW3/VJyjSQl63RE//oTbiFH4oHr0YTRwSWn5FYegEnoBT5BfNomK5BPqYDhAe7T4ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB038800

On 9/17/2026 7:03 PM, Frank Li wrote:
> On Thu, Sep 17, 2026 at 11:15:48AM +0200, Larisa Grigore wrote:
>> Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
>> enter Hibern8 into ufshcd_check_hibern8().
>>
>> The HiSilicon and Qualcomm drivers currently implement similar checks
>> using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
>> this logic to a common helper in ufshcd so it can be shared across host
>> controller drivers.
>>
>> Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
>> their local implementations. While at it, normalize the "TX lane failed to
>> reach Hibern8" error path to return -ETIMEDOUT instead of the raw
>> TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
>> This is an intentional, harmless change of the returned error value; the
>> pass/fail behaviour at the call sites is unchanged.
>>
>> Unlike the initial implementation, the timeout error is now reported only
>> once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
>> per lane.
>>
>> This also prepares for reusing the same UniPro-specific Hibern8 check in
>> a subsequent commit.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
>>   drivers/ufs/host/ufs-qcom.c | 42 +--------------------
>>   include/ufs/ufshcd.h        |  3 ++
>>   4 files changed, 78 insertions(+), 88 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 2ba244cf40ac..c1c61377e28a 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -4448,6 +4448,79 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
>>
>> +/**
>> + * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
>> + * @hba: host controller instance
>> + * @num_lanes: number of TX lanes to check
>> + *
>> + * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
>> + *
>> + * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
>> + * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
>> + * timeout) if the attribute read fails.
>> + */
>> +static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
>> +					unsigned int num_lanes)
>> +{
>> +	u32 tx_fsm_val = 0;
>> +	unsigned int i;
>> +	int err;
>> +
>> +	for (i = 0; i < num_lanes; i++) {
>> +		err = ufshcd_dme_get(hba,
>> +				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
>> +				&tx_fsm_val);
>> +		if (err) {
>> +			dev_err(hba->dev,
>> +				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
>> +				__func__, i, err);
>> +			return err;
>> +		}
>> +
>> +		if (tx_fsm_val != TX_STATE_HIBERN8)
>> +			return -EAGAIN;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
>> + * @hba: host controller instance
>> + * @num_lanes: number of TX lanes to check
>> + * @timeout_ms: overall timeout in milliseconds shared by all lanes
>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
>> +				unsigned int timeout_ms)
>> +{
>> +	int err, ret;
>> +
>> +	if (!num_lanes)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Poll every lane until ufshcd_poll_tx_hibern8_lanes() stops returning
>> +	 * -EAGAIN, i.e. all lanes reached HIBERN8 (err == 0) or a real error
>> +	 * was hit.
>> +	 */
>> +	ret = read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err,
>> +				err != -EAGAIN, 200,
>> +				(u64)timeout_ms * USEC_PER_MSEC, false,
>> +				hba, num_lanes);
>> +	if (ret) {
>> +		dev_err(hba->dev,
>> +			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
>> +			__func__);
>> +		return -ETIMEDOUT;
> 
> nit: return ret;
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> 
Thank you!
>> +	}
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
>> +
>>   /**
>>    * ufshcd_dme_rmw - get modify set a DME attribute
>>    * @hba: per adapter instance
>> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
>> index bd223bda1ce2..b84075dfe00d 100644
>> --- a/drivers/ufs/host/ufs-hisi.c
>> +++ b/drivers/ufs/host/ufs-hisi.c
>> @@ -22,50 +22,6 @@
>>   #include <ufs/ufshci.h>
>>   #include <ufs/ufs_quirks.h>
>>
>> -static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>> -{
>> -	int err = 0;
>> -	u32 tx_fsm_val_0 = 0;
>> -	u32 tx_fsm_val_1 = 0;
>> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>> -
>> -	do {
>> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>> -				      &tx_fsm_val_0);
>> -		err |= ufshcd_dme_get(hba,
>> -		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>> -		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
>> -			tx_fsm_val_1 == TX_STATE_HIBERN8))
>> -			break;
>> -
>> -		/* sleep for max. 200us */
>> -		usleep_range(100, 200);
>> -	} while (time_before(jiffies, timeout));
>> -
>> -	/*
>> -	 * we might have scheduled out for long during polling so
>> -	 * check the state again.
>> -	 */
>> -	if (time_after(jiffies, timeout)) {
>> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>> -				     &tx_fsm_val_0);
>> -		err |= ufshcd_dme_get(hba,
>> -		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>> -	}
>> -
>> -	if (err) {
>> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>> -			__func__, err);
>> -	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
>> -			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
>> -		err = -1;
>> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
>> -			__func__, tx_fsm_val_0, tx_fsm_val_1);
>> -	}
>> -
>> -	return err;
>> -}
>> -
>>   static void ufs_hisi_clk_init(struct ufs_hba *hba)
>>   {
>>   	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
>> @@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
>>
>>   	/* Unipro VS_mphy_disable */
>>   	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
>> -	err = ufs_hisi_check_hibern8(hba);
>> -	if (err)
>> -		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
>> +	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
>>
>>   	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
>>   		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 1e492dac8d93..815ca82a0878 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>>   	return 0;
>>   }
>>
>> -static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>> -{
>> -	int err;
>> -	u32 tx_fsm_val;
>> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>> -
>> -	do {
>> -		err = ufshcd_dme_get(hba,
>> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>> -				&tx_fsm_val);
>> -		if (err || tx_fsm_val == TX_STATE_HIBERN8)
>> -			break;
>> -
>> -		/* sleep for max. 200us */
>> -		usleep_range(100, 200);
>> -	} while (time_before(jiffies, timeout));
>> -
>> -	/*
>> -	 * we might have scheduled out for long during polling so
>> -	 * check the state again.
>> -	 */
>> -	if (time_after(jiffies, timeout))
>> -		err = ufshcd_dme_get(hba,
>> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>> -				&tx_fsm_val);
>> -
>> -	if (err) {
>> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>> -				__func__, err);
>> -	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
>> -		err = tx_fsm_val;
>> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
>> -				__func__, err);
>> -	}
>> -
>> -	return err;
>> -}
>> -
>>   static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
>>   {
>>   	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
>> @@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>>   		break;
>>   	case POST_CHANGE:
>>   		/* check if UFS PHY moved from DISABLED to HIBERN8 */
>> -		err = ufs_qcom_check_hibern8(hba);
>> +		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
>>   		ufs_qcom_enable_hw_clk_gating(hba);
>>   		ufs_qcom_ice_enable(host);
>>   		ufs_qcom_config_ice_allocator(host);
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
>> index dfd302f2dc7c..0d9d0a26eb20 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
>>   			       u8 attr_set, u32 mib_val, u8 peer);
>>   extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>>   			       u32 *mib_val, u8 peer);
>> +extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
>> +				       unsigned int num_lanes,
>> +				       unsigned int timeout_ms);
>>   extern int ufshcd_change_power_mode(struct ufs_hba *hba,
>>   				    struct ufs_pa_layer_attr *pwr_mode,
>>   				    enum ufshcd_pmc_policy pmc_policy);
>> --
>> 2.43.0
>>
>>

