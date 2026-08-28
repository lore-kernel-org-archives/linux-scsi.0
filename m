Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013009.outbound.protection.outlook.com [52.101.72.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2649D40F734;
	Fri, 28 Aug 2026 11:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787915625; cv=fail; b=i1nHPKYarKfMv+CNQDcSpsUrOmlTVPmiDsURNvi75RQSHyd9agSABpwuiQRIKDO/jDPZfJLDjem58e2dGMoNf1pxH0lT6bTo7nuD63wmka8NRlBwVmcNuHNlgoaPblOJjvoFIFbkXagxW3Vq2ZEtHCg5KnvFl2KXCBetzH19a3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787915625; c=relaxed/simple;
	bh=Zgr32HvkGIggK07k+O9UVJgq5KAOCmRpLD/WzOiOkPk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IqWiIb+LRCdwRxpfsbrrZ2jDK0wPNfRGAk00RiEpkuqEuePyb2lw/4BY/FpFM1Swj2GH4vedb0A1S3aQUyLsNRgtSFEwVl4E8VJ2NSc9pUTz6rE752e91B2jBa1LJ6pGFfw8xkc/njPk9PUV1q3pny52r8aVlxe4RoQ0yPWAXcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=DE950Wcn; arc=fail smtp.client-ip=52.101.72.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="DE950Wcn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udQPGPO3Ybz+9fnxplDi869womp1Z685mQFYOZIFoqeiyFwOG7bJJp0Dcy8++Dd5ML8JOLi88aLRWh3RRiMMcn7TR1WKV7WshXXOSBBQiHN3MwlmY5JZEYlyyR2eOebOqqLZvA8tmfWUfd8pfKLP671GKOaVvcvkDthS4EfW9gLaD1wJOrkLxapcLkpl8hehUSOK29TnrXQNkxO98m4TRGnDx8FAv58dGw9gUPP6gplaRJ3hgiaewLDu+rFUf83z56pWGycUI+/eZiXiWScWK+LNdJOjCrwf1txNeIdA1opRpq8weG7ZgcmejseDBZfMCWPoNJD5BFd/ab1VezgKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mkrQVSa2CCJCqim6X4u+PKD8j2FL5o3nzVzp7qa/kX4=;
 b=WJeeiwKDpTxMBJq7vBkXZm9p+/5ZERoc8sEc8fbwxJe6cOHqkxJcb9HPOKGt1qclmIqRMPCqB5Anri8tH3CL/gtSLOFd1FlO71saYe+t6Y6HVbTXSeO0x+UTT9rlGunzIZxDH6q2mAnZgGvMvSyxJDtu5sZlxmJ0sUN9VIgPvUJqa1MFcINTTkx0dBQA6mP1z0LbT8gVNGkyTjSv78dKgUOepWuqzUAxLIG34JRpaYmEk1Q4aGyToTnhHSF2nxe5c5DnSRxL9sgk+F8l3fzz4M3zzo/RGA21nKmh8NLUNUFsPisJcrJ46OMBh/CLCnnFXk88Qd1DvUrsutHpiu49iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkrQVSa2CCJCqim6X4u+PKD8j2FL5o3nzVzp7qa/kX4=;
 b=DE950WcneELPcL0hEfJ7fs7RsuMJh4aTAICaL8GVoXaDC4qLfkOVlR2/E2kqajgBdZegCV6DVxj49UUR/hvMwmghlhzAwwu89JJhzO0QdJZIoi8tuwOhNM95vlAAlCYIlSSHqIpZThSGRcNnnsm3/UUiWViXwUkYB1jnmJ5A7pHDEMlk7Xu3IdPIVHmBFleRQidud1PiTVVdWaqBPOarVeMT4YvG5Y0+AATL/rjFb6S0Hf/+uYel2e/C3lSHJYD7RizxWA9bb9r79VwSTc4QhSw2Fi/KbRBaYQgUmqirfRcyO/RFf6reNjLh2ZOasC1Z0rVCoFtySiTf/NstOn3nhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8422.eurprd04.prod.outlook.com
 (2603:10a6:20b:3ea::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Fri, 28 Aug
 2026 11:13:37 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 11:13:36 +0000
Message-ID: <d04076cb-da91-439d-8220-fe2e98e45fc9@oss.nxp.com>
Date: Fri, 28 Aug 2026 14:13:32 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
To: Stanley Jhu <stanleyjhu@google.com>, NXP S32 Linux Team <s32@nxp.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
 aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
 <CAE14pddHBP6HMihTePR+-Pqhu2DKjVgRA9++5Epod6TOCLagFw@mail.gmail.com>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <CAE14pddHBP6HMihTePR+-Pqhu2DKjVgRA9++5Epod6TOCLagFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0023.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::13) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d7e998-3936-479f-2775-08df04f567b7
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|23010399003|7416014|376014|366016|4143699003|921020|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 cRUwAgn7oiUWAiG9HPB0uDqIz3PIF57QEJYX2es3XUEhL2l4WYLldqb6hFzKjVCW65lhSv1e/77Q1BzXiSp2xCyEkHt2+Lb1m+n7lqqaGRoKPExRm2HndT2/+h9cVELUgbODQb1492iEykOdt6QXJv7L23jDm2mFsdZQyrQjiHHspAkwW9/lhkGTYjVCwQXCjYnqWydEPwt61lfX1d4QU0hr0tKaPqnsA5OVUyOvYE8rQ5MaUPOCH3Yv0JFO62k+hKpjYL4+tAt+KBHRKaliCE4JAGOX4rMRdnCiA9nZ0XEE6TELpFuZD+KyUcarFqelWWGskVik7wejLc5QvOasCWRfDRHOvTqEkxTm95w5U9NJnwu1RyIRy3xaFHdPczrMIF9jt1anKb88aevz3VYvehdbcvkpO+SoTrXM0su9qzSQBVfTx7cJvfoZGUB3DOCESquLluWKSCyglqU4xEgh6OGEV1vbAq+bz9yLwHeFDgEmRdhqrPI+POASext/rn/vT/0Er5BF40QBSk7lh5a1HIwsdP34qYeB6Y6tDsYVJpXbec3AIGz4+yu7UsQQTxjmFgvY9kBVDD4olYKs802GJyNCXWDlrikiYeA6nHy8NW8U9FWrSvri87MPXqJq0cmNAnE83ETSDX81EnNspoxAAqDawtBLusJPwJI3cWsiuXRSxQhCt/ocaW531ITeBxKbuTkPKXcbtgVES6FNaMAAbA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(23010399003)(7416014)(376014)(366016)(4143699003)(921020)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RUF2dVpuTE1vOTROVkF3b0kxNEE0Y1owODA0VmtpZGJuL1VvTmw4Z3UxaUc3?=
 =?utf-8?B?RUJ4VjViNEtVU0hOMGs3dlZRRkxjbjEyZWR3VEFJSG5WTTduS1lDWlZ6bEFE?=
 =?utf-8?B?VWQvbjBkVjVyYVVRTkpsQlg3M3daRXo1ekd4ditQckJwL05IeG1WWmR1UVE2?=
 =?utf-8?B?MEsxRDFwSm9oUWJvbkpjcjlrMDJmazJmRWJsdWFNMjhYRTc0NW9ZK2NHVHRI?=
 =?utf-8?B?NWNHOEVaOVBwMWJhOEhnaThWU0RwOHJ6S0ZvMFcxVHAvTXJxRmdSN2R0ZXFs?=
 =?utf-8?B?VGxUaFh2TzZXQ0IzaW4rZXJLM3FXTjRBcDJVcm50dCsvR1RlQ1BNeEpmcUps?=
 =?utf-8?B?MFNhNDFDbDFNdXJpTnphblJUdUh0MGhxVnk5MDlnVzV0WWlnaXVjRWwzU25M?=
 =?utf-8?B?MGpMM2Nsd0tURStHSjlWOGM5Y0EyVXRtSEpJV0FQU1FxZUJjTktWOEN3Umpy?=
 =?utf-8?B?aEV3ZHd5ZTNRZXNHRVMvVG9BNUVnWDdabXRvMm5Pa2liR2dHSVYxOTJCVEJZ?=
 =?utf-8?B?UVdsdEh3cGZpYWVpWHdSS2VhVHdrUWF4c1ZmSTFOaldQYXJIRGIreSs4disw?=
 =?utf-8?B?NEtqQlRDWHFPV2YybnNjellJL09vM2JKaXNya1FOc2pTMWUxcmpYeC9rQVBn?=
 =?utf-8?B?am50OUQwNWdONmFVTGxkaGNkOU9ROFBSdlM5MnRUYXA2akVoOURiMVVwSTcx?=
 =?utf-8?B?MmE2QU81Yk03bCtEM0dzRW1HMjhYUTNhaFZpY1NLczZrSHNlS1JRWHNaNHQ2?=
 =?utf-8?B?YnBYZXZBaFF0ODVzc3dVZmxSNnFDVkFyTmNUejBHTVF0SlFmcW56ZklVSW41?=
 =?utf-8?B?dWJSRkljdUNNZmxaVGxmODZGakwvNFFIM3FFZ3hscDVZajM3S3MvZFc0TWs5?=
 =?utf-8?B?TGE4b2Nhc003UjBXRFp4bGY1ZEcvbnNwSEVtVUltMUpvVGJOS1dvSnlROTRi?=
 =?utf-8?B?S2pVdG0yTjNDbW5lNzlyZTRqbDlCKzdYN2hBek8ySEE1NGd4dHg5VEE1eW1E?=
 =?utf-8?B?QWM0c3FMQ0g2VHhGSWtTS1hYNUhMR2xXOVdOZ3lNLzV6WVpsdGMvVy9zcUVJ?=
 =?utf-8?B?WDRMS01tZDVPcjNlK0FkaUhkblBEcHVsOUhyWGZVUVZPY2lGeFhrRkd2eEVF?=
 =?utf-8?B?VmR1NmI4eTZmZjc5QnFRSEFlY1Y3dW96MmZxa1JsZDZaOWhwTHFSQ2Zlb1U5?=
 =?utf-8?B?TTBOWmtYbXRodFMrZ1RGbUhPOEhQSEpOaEtxbHQ4cno4WVloa04yOGluNXor?=
 =?utf-8?B?UWRHaHNXN3h5VmliSTAvNWZkb0xUSHNzTWUwS014ekdITUplTlczRFB2NEwx?=
 =?utf-8?B?RHFjU29laTNQV01UZFc4Q1NjTE55TklMMnROV0FENmZzNW45R1kwUHowSUQx?=
 =?utf-8?B?T2h3QVdxVS8xNmJjbUt5RXd0a3laNUlkeHZrR2FsdURQWGY2WFB5eVNRazAz?=
 =?utf-8?B?NGdhWDcvVTNsUERmSU9mYUFmaUs2alh0aGdrdnRiN1VzQ3NqNVVKUmh3dEV6?=
 =?utf-8?B?eGtsbThtVzE4N0VGb3A3Vy9jVGJBOC8xdGNDRWRoMlVSNkdqM2VVSkluczI3?=
 =?utf-8?B?dFBxVzBlTjNyd3kvTEpETVdXMHlqb2dIK2tuWkUxSUFDeGJUSDUweWExU0E3?=
 =?utf-8?B?UTZ0alFFcldrN1d3UXpuVjlzVVo2VnAvMUMxYUhYTDlvV2ExbmFXQjNuNGoy?=
 =?utf-8?B?OUtNRTJiWnlleWYvU2Y1Ny9RNlp4Z3BDUG0ySS9ndzE2czhxcWl1TE9FTU4z?=
 =?utf-8?B?YktvazdMQjArTWtZTW1Bcm4yeVIwQXg3Vkc1cFdwb1RYaUEySzM1aUxVZWhn?=
 =?utf-8?B?NkJ1YjV4OW92V2VjNVZzQ2VIYzV4WGEwQkUvVmYzdGlOcjNkbFdTVjRGamFK?=
 =?utf-8?B?TEdFT3RpZ2lOZ2xkOVV1ZXp3WTRoZzZkTnVLSUxJRlFFM0wrRlBuRk1ESkhD?=
 =?utf-8?B?UUlKY1E4NWE4UUdoUVNQZ1V0OGJ6cnA1bTVHdEtmZU5ZWGtMVFoxY3dxeldn?=
 =?utf-8?B?SzU0V2pINEhHSVRkMHVFb2xXdXRZbGh6RkVBNE9kOVlTeVZtZ1V4NkpDeXNh?=
 =?utf-8?B?K252MnNFZitBbjRPOVpwVldnUyt2bmxwLzJ4b0J0bDBIRjArWUg4cFBBbGYr?=
 =?utf-8?B?VlJzelQ1VnhkSkR2SmFZVWhsRWp1c1pHcjBrUFhIdURVNlpROEpqQ0dMbkZF?=
 =?utf-8?B?MFRjeDVpdUEySkgrK3M4VVcrbTZhNEt4YUNtVHg1VXFnYWhCQ1NUWG45U2Mx?=
 =?utf-8?B?MktvMklOaXhQRTdVMkRiTkQ5V2Z6cTl6NHNxTis0RTBmdTBxVWcreGM0dXVC?=
 =?utf-8?B?T2ZjVEJRSUtZekR2V0kybE0vMm5uLzVFWTFFRXdiZEg1am1BWlBXakR5SWFK?=
 =?utf-8?Q?Qr2XZr5ypqtUq1IE=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d7e998-3936-479f-2775-08df04f567b7
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 11:13:36.5987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjcrjFIQ1cXjLDui778T2nijFvRotADGFYrttUTJ4UlLKz9+bcydziF3vb1NbjHQC5Qr8Kd30g1AdkfMjF+aVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8422

On 8/27/2026 6:00 PM, Stanley Jhu wrote:
> [You don't often get email from stanleyjhu@google.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Wed, Aug 26, 2026 at 03:40:41PM +0200, Larisa Grigore wrote:
>> [...]
>> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
>> index c2dafb583cf5..034ee988924a 100644
>> --- a/drivers/ufs/host/ufshcd-pltfrm.c
>> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
>> @@ -563,6 +564,84 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
>>
>> +/**
>> + * ufshcd_check_hibern8 - Check if all TX lanes entered Hibern8 state
>> + * @hba: host controller instance
>> + * @num_lanes: number of TX lanes to check
>> + * @timeout_ms: timeout in milliseconds for all lanes
>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
>> +                      unsigned int timeout_ms)
> 
> Hi Larisa,
> 
> Thanks for the great cleanup!
> 
> Would you consider moving this helper to drivers/ufs/core/ufshcd.c and
> renaming it to ufshcd_dme_check_tx_hibern8()?
> 
> Since ufshcd-pltfrm.c primarily handles platform device glue and DT parsing,
> polling M-PHY states via DME commands would fit more naturally in the UFS
> core. This also keeps layering clean and allows non-platform controllers to
> reuse it.
> 
> Additionally, the ufshcd_dme_ prefix would align nicely with existing DME
> conventions in ufshcd.c while avoiding potential confusion with
> ufshcd_is_link_hibern8().
> 
> Thank you,
> Stanley

Thank you for the suggestion, Stanley!

Sure, that makes sense. I'll move it to ufshcd.c and rename it to 
ufshcd_dme_check_tx_hibern8() in v2.

Regards,
Larisa
