Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011069.outbound.protection.outlook.com [52.101.65.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6C143E06B;
	Thu, 27 Aug 2026 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787843408; cv=fail; b=ohTRaFoa488nGeKMkO6dQ5KFdb82wJjh+Qvu1Go7gQCqkj6hNPnyleytWmC9KrtoaksqVuS1gWDvMYsBIiokOkx4Ym6PXC97q1n7TKfvJlQ+dxTkvFiQ/5XZcSx66mHwKLPfjwoGW461OilrIk70zh5sJDQcqI+wmZISfaAH8QQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787843408; c=relaxed/simple;
	bh=wWThSO/3kM2N45smuIxxGskoUveEJspqkwPm6l254bA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MlI3C/PpHjvbfsaFOjWEKyRufz5IY4ovsSgtdXR7TrSh5dvrlY6gwZelbJ1hLg3emb73gVKtwp43Hwn4jjpJ4jbuY06xsvECv1VSYggt51PPN8IS6VVDP2HETWSkmiJS8vMx/XAwGw0iaLnL89csK3r3jCWulLBHyvPo/4fFi/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=e58XIF/w; arc=fail smtp.client-ip=52.101.65.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="e58XIF/w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UBn9+526enf8wJK7nGllJy5BP2tLx7x85gG7jMjsT98HNUQntGNg6QfSHmqySiCB/RTuirAv9noFBMUROvZwTPYCdFxUJQAgpTcvKZ1X09CHVYtWyyE7BZ+eSY7sftrhAuBu9mwJmFTa7th685nV8JPNXeL44K02BWzIAfaBBbiw3YKOaD6G+B+SiFbpzQgYStF5a/JoKTwJ5orelYdnTZWGdEphfDjr5ImjZ+qfeO0dTFnP88s4OQqwciJWxdYXKnq21Us1WfEeKqq4ptF0otk68n6wwOK4KA+Utce70JxNQr9dunYgUI50pmCi4S1KCBz9R1zEWwbdCUK0eZ1lXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFdPvxnRmAwYFo1B09vLSab5VMyGXcoaJrL/erpB4n8=;
 b=momT8tLorT3Tk17jg6J6wfik/vhXiH0jFdDGO3XQRdnFiwGgBnkVX967Yez+Vw27T32zYp0wsdXQK06R2tEJ57bC9JyunNEgGwN5I4g5YDjTjZ95OBl6TQ7QSJE+xuSWA9LJg/dY4YCrdUUvtaQxbdQUf19xncPGFDXYdVkW42+nRng85A8O0YJN7F6cNw6F+AXW5zCGxkTmrQ+ZeavsGAi24fyw5kbDtMC7ryXiHSSenLunO0MdT59iQoMFbD0oY46bNSzHLs9W5WDgnehDmv3qjTmWNW/RrKST3zbswxx4jxZvv2ST4AP0m4RGy/YQfzcjAMFSMMHTGth3FNxOcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFdPvxnRmAwYFo1B09vLSab5VMyGXcoaJrL/erpB4n8=;
 b=e58XIF/w/iAWtuE6jScLNb/Caj619v73cMazboE4o2LX8ukb3SyDpaEYmtsP1BeQMtLOjMzRPTzQufv+zAP0A3+4aZ0jNOtyrz25W+lu8P0N/+bAswrEYjSBwm5uscKjgthvJcZfr6hZeezlGjBMHfvK5lXaN9KfTu/KEvc5v+NrHiQfZHjOfO3KpNfb7LkrQbpiCP1Cjln8M7A2AocJ1fE2c9/NyLLVgAEQ7d0AhzB7+jaB+E85hTsgStJVTBMfNKQDHPanwsVXVyjigpl64l55plwcdDVIdIo9JGliCaWGrli8IRr0e76NRSW2XFch4OU3kcD9SRKOewnuxinpcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by FRWPR04MB11175.eurprd04.prod.outlook.com
 (2603:10a6:d10:171::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 15:09:56 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 15:09:55 +0000
Message-ID: <af07f0eb-535f-413c-9542-ec031110254d@oss.nxp.com>
Date: Thu, 27 Aug 2026 18:09:51 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] dt-bindings: ufs: Add compatibles for S32N79 Host
 Controller platform driver
To: Frank Li <Frank.li@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
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
 aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-7-larisa.grigore@oss.nxp.com>
 <ao75lU2zYDeOZi2f@SMW015318>
 <ccacc3bc-7f81-4363-a273-a6076e468618@oss.nxp.com>
 <apBNp1ybnHsNrHSL@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <apBNp1ybnHsNrHSL@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0014.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|FRWPR04MB11175:EE_
X-MS-Office365-Filtering-Correlation-Id: a62dc306-094a-453d-7691-08df044d4096
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|19092799006|6133799003|10067099003|11063799006|5023799004|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 Gm7aeq9N2tVNZ4Rea/v+tcBONN/0j7sY66XhGraTeebE1dTy9Ej51lcYnQVeUwdIWkl1WTJT1hU3/0ZFDuqffSMf3Cx22ahLXQ3W3/Qv67e1w8AfcEWy8nIvFDhm8vumWDDng7PAOtU1kw01OeWev2u8+kDoyLlHKj3sz6jcaP3q943Tq7jwh9MjkOwveXxQoztbsC6z4XAw5KUYbnf7kFl22uhUdwnYazT4Y0omPfLvoHsRuG1wMrwp8vwPX9S6PsP/amFKnfzfx9V6CoZkkC+o6sMjXp/MaHYC7iy7g2ef+vnYHCz9SY01sRTmSqXLaHO4/51vPnq0hyfn3nkF2EVn9spHThTncaCKw3+JtZh4F53Cc7wDQutZaNFQ9MhlJ4gDDb4gMbd49AkncfbZUYtgydPgGY4hxUn9IcZI+usutl82lS24tryAqBlbGNqLGOluqHElwwegSPQ7UrpGXZ00IuJq64j+Zb1f1mu4mm4Jl9XNb+g+d08KAxehb/wUscnrFl+zRc9dq6OFYrtDMgKReLixu3fdGQcgpMXGQXVXcDEZstKxvLNN3frWcgw3Mi3YN5DTObYgfMAf7QpYltmDJ85hda3iDRfGl4KsPLxoUsV2s814WUoCs4s+P/tI
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(19092799006)(6133799003)(10067099003)(11063799006)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?d3cvTlZOK0daQUJjR0ZZcDQwVDhONHBleFJyTVRHZlp0UnZlK3FaaEtuRzI0?=
 =?utf-8?B?TVdUcWRNeGQrcVl4QlBrNy9rQ2h0ZW83dDhUbFhVZkM3YjJNZDBuSkNvZDFJ?=
 =?utf-8?B?bkhtZ1JtUU5LYlBWbE1SSm5rS1ZPT3ZyS2t5NXhkbHBnUENNRE1YYjduQWFu?=
 =?utf-8?B?YkZSb1o2c3Y0Z2ZyZEhhekcyakZNUFhjbW5KUzlYYXlEVWtPQTZnU2NwOWhD?=
 =?utf-8?B?TFM0MVZtQVlycmc5NTVUTE1ZM2EwSEY2TXZ6KzJGVTJ4dGliS21XazhJaFpQ?=
 =?utf-8?B?TTNjemV4N2ZLMmd1eEI3ckVLMmR5bG85a1kySVFXMHdlbzZ0MGFKVzZOOHgv?=
 =?utf-8?B?NGVvVTFNdkN0TWtINnVGdFFSUFp1Q3JEUXc1Q3lSOWZNalpTMitYc3VFZnFH?=
 =?utf-8?B?K29KNEo3RnZWanJTcEhPU3ZKNkZnTHUzMjc5OW5md1FlelFHYVYwVnJOSWxH?=
 =?utf-8?B?MkxuYlBhczE5cDVNeUNab0dsbHNCTXVTSnVFaWsyMkhHaW91VE84NHR3bm1M?=
 =?utf-8?B?VlJleXRPQWhURWtDdnhGbjYzTVd3Yjl1TEJQbmhhYWFLSkxhZVZBbWJnQmRr?=
 =?utf-8?B?UUk4akFCbjAyRmZBR1dad1NhcVZoUlRidWVFNFBMaGtrOFQzM3NhNHZOenYr?=
 =?utf-8?B?VmFOai93TXJKL1kxRzFPcU1xaWttMVBDRm8wWmhtZ01YVFJWSjlPL05KcU1B?=
 =?utf-8?B?NXZFUWZYNUoweEpLTHBsNGVnM3VjTjkrcDByRVluRkxnbHBZVUVmdnFWQ2V2?=
 =?utf-8?B?SE9RTVUwbTFDc3prVjVZZzk5blJVUzRnYm5YQjNFTzNoSHBHMk1mSHJOS3lx?=
 =?utf-8?B?L0tZNWYyN2FGYVlVSkpJeWhuVlpkK2YxNE5lN05mbjRoaTZjOTc0QnZQcDFS?=
 =?utf-8?B?UXZNeVJTbGhRU1NKRGVQTUllS0RMRUVRTEFLZFpqdEFnQVNQaW1xRmdJckRV?=
 =?utf-8?B?THBLT09nVXhzVCtSbkI1TEpyOFJPTWN1cEVaaU51Mlc0K0JiVTFmYTFiSUVt?=
 =?utf-8?B?U1NZaFNyYXlOK3NsNnhjZ1RkcG5ieThXTjFwN0lLVHZMQkRQWWZvUnpkZ055?=
 =?utf-8?B?c0kxNC9OUnU1S2hoMWFjS3B1V0M1eFFkLyswODJjdE81SFVDN3VjMzVpeWRl?=
 =?utf-8?B?bzV5RDNPM3QxVTVKT2V5WWI1NTVqbVV6S0trUFRHTi9ER3dXMmVXTWVQWjQw?=
 =?utf-8?B?cmg5Ky95N0ZGdHVCOFRvU2dnRDJLWjV2S3Jvb3NyQmZMclJFUnZNSWJDS3BP?=
 =?utf-8?B?Z3lrQlpTN1F5Uy9ITWQvQnZtUHNZdnJPQW1FT1dvbkVBTkdjM242OGx4UXVH?=
 =?utf-8?B?V1V6bG1FRmoxejMvby9nVmRqNmhvOXBRTjJ1N1d4dFRGNDFtNjV6a0poVzJu?=
 =?utf-8?B?Q0kyVnBkU3Y4R2ZZM1FZTnFBWlZsQk51cGxZWjBYd1lndG9VRGZadHRaaCtj?=
 =?utf-8?B?VTcxL0NwajhzVzZMb293Um9Wc3BRNWFvNkFiNTNleFJ6bkxzQ1Y0S2prMVR4?=
 =?utf-8?B?Z0J5ODZmTXRYSGN0cXpoYlZ4VGUzVUZTYnVaejBYNXVRaEd0TE9VVG16dkxu?=
 =?utf-8?B?YnRYeHNIdkI5MWhDVE51clNzZUtkWTc0MEpuVHVrd042bFB2ZFBmckk4NGs1?=
 =?utf-8?B?VjBsZ0JyQzgzc1JNNTI1VG1GMjdielN3QzZRc0pydnBiRi9NOGlYZUlYTUQ5?=
 =?utf-8?B?KzkvaFBtS285ckZ5eC9QMDFzVlNLanhHYlRyMUxLcGEvTU9DcE9jZTM4L2w5?=
 =?utf-8?B?SEJmM1Z0LzJXQlZidDB4MURLTzIyaERDamR2dVZCdTZuUVZDbUpnZVBWQ3BT?=
 =?utf-8?B?MXpQQWMzTjE2Um9sZnNCSDQwS0pqRnpYcUI1bjdkbG1NQ0NERDV3YzMxWWQy?=
 =?utf-8?B?aUs5ckZtZDgybWJ3SElIM09hazNXdzlpYUhsQ1ZqMkVmOStlQ2hMcWRRaWxa?=
 =?utf-8?B?SDVVd1B6SGRYczBWMTFOSkFqdW9XMTdiS3J1TS83Y3NMTFlGN1NyVzhxSlhW?=
 =?utf-8?B?NHZwOXRTRzBxQWdqVGczWGtKYm1PVWpmU2FMMERPRjhvdGhoL1BZZUh0SnpU?=
 =?utf-8?B?OUJtK1h6cWVGYW94WUxxelhhS3ZYZFdVMEIxaUpRa0ltT2wrSC84TVpySkdh?=
 =?utf-8?B?T3grV3d4ZW0xSHVDSkJsYVlsejBPSjV1bDZtR3JSdzJGQmpmeEdMS0kzb0pC?=
 =?utf-8?B?Y0VmTDY3T0x4SEVPR3QwQ3VOdDZHUkgxWUthbVdFME9Wc2d1emNmS3F4N1RD?=
 =?utf-8?B?UWlhMFFsYUNqak9neFViOXBISFMwWU1pMlZZa09TU2NVN1dCalBRMVd4dW1s?=
 =?utf-8?B?MGxhMDhXbXZXaGtvZjBMTDJlTTJoVDRBVDdUbE51TFUzVWhXWnNoUmJ3Z0Zq?=
 =?utf-8?Q?YfO7x6GtOLfqB2jU=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62dc306-094a-453d-7691-08df044d4096
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 15:09:55.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F52C75ix1pGzZNi4iwdJp0wiGIjjqwf3KCPXJuQE8cbfepqV/2rGbuwCs4eOEaD8Bze0WvXRmqSsBtFacGcGrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRWPR04MB11175

On 8/27/2026 5:45 PM, Frank Li wrote:
> On Thu, Aug 27, 2026 at 05:36:27PM +0300, Larisa Ileana Grigore wrote:
>> On 8/26/2026 5:35 PM, Frank Li wrote:
>>> On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
>>>> [You don't often get email from larisa.grigore@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>>>
>>>> Document the device tree binding for the NXP S32N79 DWC-based UFS host
>>>> controller which is compliant with JESD-223D "Universal Flash Storage Host
>>>> Controller Interface" v3.0.
>>>>
>>>> The controller requires access to the SCM register block and the core
>>>> clock rate when M-PHY initialization is performed. Add the optional
>>>> nxp,mphy-boot-mode property to select the M-PHY firmware execution
>>>> environment.
>>>> Currently, the M-PHY firmware can only run from ROM. If the property is
>>>> omitted, M-PHY initialization is assumed to be handled externally.
>>>>
>>>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>>>> ---
>>>>    .../bindings/ufs/nxp,s32n7-ufshc.yaml         | 99 +++++++++++++++++++
>>>>    1 file changed, 99 insertions(+)
>>>>    create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>>>> new file mode 100644
>>>> index 000000000000..d9d5669be313
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>>>> @@ -0,0 +1,99 @@
>>>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>>> +%YAML 1.2
>>>> +---
>>>> +$id: http://devicetree.org/schemas/ufs/nxp,s32n7-ufshc.yaml#
>>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>>> +
>>>> +title: NXP S32N79 Universal Flash Storage (UFS) Controller
>>>> +
>>>> +maintainers:
>>>> +  - Larisa Grigore <larisa.grigore@oss.nxp.com>
>>>> +
>>>> +# Select only our matches, not all jedec,ufs
>>>> +select:
>>>> +  properties:
>>>> +    compatible:
>>>> +      contains:
>>>> +        const: nxp,s32n79-ufshc
>>>> +  required:
>>>> +    - compatible
>>>> +
>>>> +properties:
>>>> +  compatible:
>>>> +    items:
>>>> +      - const: nxp,s32n79-ufshc
>>>> +      - const: jedec,ufs-3.0
>>>
>>> Any place actually use this fallback?
>>
>> You're right Frank! I will switch to `jedec,ufs-2.0` in v2.
>>
>>>
>>>> +
>>>> +  reg:
>>>> +    minItems: 1
>>>> +    items:
>>>> +      - description: UFS Host Controller registers
>>>> +      - description: System Control Module registers
>>>> +
>>>> +  reg-names:
>>>> +    description: |
>>>> +      Names for the register regions. The first entry must be "ufshc".
>>>> +      The second entry "scm" is mandatory only when nxp,mphy-boot-mode
>>>> +      property is present.
>>>
>>> you already us if - else branch to restrict this limition, needn't
>>> description here.
>>
>> Thank you! Will drop reg-names description in v2.
>>
>>>> +    minItems: 1
>>>> +    items:
>>>> +      - const: ufshc
>>>> +      - const: scm
>>>> +
>>>> +  clocks:
>>>> +    maxItems: 1
>>>> +    description: UFS core clock
>>>> +
>>>> +  clock-names:
>>>> +    items:
>>>> +      - const: core_clk
>>>
>>> Needn't suffix _clk, just "core", generally needn't clock-names if only
>>> one clocks.
>>
>> I will rename it to "core" in v2, if that works for you.
>>
>>>> +
>>>> +  nxp,mphy-boot-mode:
>>>> +    description: |
>>>> +      MPHY initialization mode. Defines how the MPHY firmware should be
>>>> +      initialized and executed during UFS controller startup.
>>>> +      If this property is not specified, MPHY initialization will be skipped.
>>>> +    $ref: /schemas/types.yaml#/definitions/string
>>>> +    enum:
>>>> +      - rom
>>>
>>> why not use standard "phy" property, if no "phy" means ROM init it.
>>
>> First, apologies for not including enough background in the commit message.
>>
>> On the S32N79, the M-PHY firmware can be brought up in one of three ways,
>> selected through the SoC's SCM MPHY_RAM_CONFIG_STATUS register:
>>
>> 1. running MPHY from internal FW ROM,
>> 2. running MPHY from a (modified) FW ROM copy in external SRAM, or
>> 3. running MPHY from a FW image in external SRAM.
>>
>> `nxp,mphy-boot-mode` was introduced to select which of these boot sequences
>> the controller driver programs. Today only option 1, "rom", is implemented
>> and validated, but the property was meant to leave room for the two
>> SRAM-based modes.
> 
> 
> You need define all options in binding.  who load FW?
> 
> Frank
> 

No external firmware loader is needed for the first mode. In the second 
mode, the initial ROM-to-SRAM copy is performed by the M-PHY internal 
bootloader, while system software may update the SRAM contents 
afterwards. In the third mode, system software must provide and write 
the complete firmware image into SRAM before starting it.

The current Linux implementation only supports and validates the first 
mode. The SRAM-based flows, including the Linux-side firmware loading 
mechanism, are not implemented by this series.

I agree that defining only "rom" is incomplete if nxp,mphy-boot-mode is 
retained. I will reconsider the binding for v2, either by describing all 
three modes together with their firmware-loading requirements, or by 
dropping the property until the SRAM-based flows are implemented.

Best regards,
Larisa

>>
>> Given this setup, what would you suggest as the appropriate DT
>> representation? I would greatly appreciate any guidance you can provide.
>>
>>> Frank
>>>> +
>>>> +required:
>>>> +  - compatible
>>>> +  - reg
>>>> +
>>>> +allOf:
>>>> +  - $ref: ufs-common.yaml
>>>> +  - if:
>>>> +      required:
>>>> +        - nxp,mphy-boot-mode
>>>> +    then:
>>>> +      properties:
>>>> +        reg:
>>>> +          minItems: 2
>>>> +        reg-names:
>>>> +          minItems: 2
>>>> +      required:
>>>> +        - reg-names
>>>> +        - clocks
>>>> +        - clock-names
>>>> +    else:
>>>> +      properties:
>>>> +        reg:
>>>> +          maxItems: 1
>>>> +        reg-names:
>>>> +          maxItems: 1
>>>> +
>>>> +unevaluatedProperties: false
>>>> +
>>>> +examples:
>>>> +  - |
>>>> +    ufshc@4ac80000 {
>>>> +        compatible = "nxp,s32n79-ufshc", "jedec,ufs-3.0";
>>>> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
>>>> +        reg-names = "ufshc", "scm";
>>>> +        interrupt-parent = <&irqsteer_coss>;
>>>> +        interrupts = <211>;
>>>> +        clocks = <&sys_clk>;
>>>> +        clock-names = "core_clk";
>>>> +        nxp,mphy-boot-mode = "rom";
>>>> +    };
>>>> --
>>>> 2.43.0
>>>>
>>>>
>>

