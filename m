Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013002.outbound.protection.outlook.com [40.107.162.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490C471CF2;
	Thu, 27 Aug 2026 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841400; cv=fail; b=rGMooS1D2CJZAcPaEsYo8ml88YdpxwVkKh3SVF+RmdfQR1xfp6QP2uDVDBV1WptEg9B+WcfA/nMbB6NH7MpJWXSQt+fjEVPAl+6Bpv4ZfYEaeTrgo3gTEa2+aUECSWbBvCS25xQDZg7BIgiJZ+KYLY6ebJz8jRA6HZMu3pEfSxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841400; c=relaxed/simple;
	bh=PXcuZXfj0hnXT4Wl3RuDcQb5B047cEgEmZtL0ihiNL4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G6b/+3hI+UdpHuG/VuVzlPX9h1u7JUF9HABBTKdXu1GUCo/u5gHC1c6nehgZcRIUXmzvkZWMIYdJyIKbFsf/dBRZ0rYoVaov23bGXiu2fMmF6h6GKq6I4yGT1JUL2YfxcSUWAtf0Trxt2ohyOyDSAvIEExUyks+oNqHDo7vkdD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=hjajK5vX; arc=fail smtp.client-ip=40.107.162.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="hjajK5vX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLPfKCyBGmA+PSBLAPaIu0AZghPbdJwXaVjrsrKo5W2gVR2zo6QWPLRR0vH/CvwWEY56JntPrFH6aMyxsaWQ9H/MlASkFDBujFNNDG3nVYcaD38y1/KQmlU1SdeQGEsoI90MX013fC43CCbllol+bsaSO+xdVRbf7qYTMfy3Y4S5FNsgiXd23RzrlLg3heIvRDrGawxUQY319+s4U7DOh0NY42qQIQV3SNntTSZwyZRgqEnkZcinbKm5014/G8+PluJlqZcSfLYA15DfprH+0TEU+OQmiZjsQQsy2SQ0QkkJGEV0jVWR2SOB9oK/yqPF6B/PhLIulzB0tq1i/B4jDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkcLdZ04Ls6UFKCVVLFp4hZZe+m1YNt82TM1978eWlA=;
 b=Bgoe5QZKDhcvBRWfLG6aBfobbJSyQvFqUakQix0IZ+rJI3Q+9hcoR+VdvOYja8w8tjcY1cFAZDSwZPiNq7Ok9qjp5v/Jbq9huUim90wK09mivAzU8XEoPp7sDrODcuKl6Yr6+jgbjHFjQH1Z9eezQu32AeZEf2hL9r10j74REGEWP9nSmf8bxOYC43qw0Xi1AGTUKcHhvTdkJ/5mjXdp+Spa7TmOPBA80NjzeRDGa23b0oIb3rwN1To1mFA26MbvrF0O5z0zHiVRi17HvyNXDtHjuQqmaQ/ZK8huOKUl8fm3Zgk0UiM5dC3JDhgEvDvp+Q5IGSVcsSG4wOx7nCvCoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkcLdZ04Ls6UFKCVVLFp4hZZe+m1YNt82TM1978eWlA=;
 b=hjajK5vX0I3aZ/neFYV2UAO065inVS9NXI/PyK7CYke2aJ8XQ5HdGuTkV+Uzzgbryhqhm2HsBXsMFizhA7vDIO5jrD1/3thfA5L65LPLv+63RK3NZKB1wCvILaQf9gqEyZG9Rigmepkks1W4NZ837pVJWz2GpDXinCH9QZVUc3iFniYQN8MHe+91AucecNcf/jhM199k+0y08QVPElH/Vokj6+sHiMjMFcaaXqiEPpt9k/x5QdlE0ykhQ8ngQ0QIiayiiJZAyYZ4YOYhOZlUWZM8AeGSQKTPc/lHE9lF/WacxoPKTIOaKGwJT/PPMFyJj8ee9uagK5cvVtY0OndlzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PAXPR04MB9021.eurprd04.prod.outlook.com
 (2603:10a6:102:217::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 14:36:32 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 14:36:32 +0000
Message-ID: <ccacc3bc-7f81-4363-a273-a6076e468618@oss.nxp.com>
Date: Thu, 27 Aug 2026 17:36:27 +0300
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
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <ao75lU2zYDeOZi2f@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0019.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::7) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PAXPR04MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: b9528725-e939-4d7b-3237-08df0448966c
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|376014|7416014|366016|1800799024|10067099003|56012099006|11063799006|4143699003|6133799003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 alWxRxgayCy7E2qiQXXCBV8y5v044imEbhZeHzLnIgOl/q0MbUU/pjfAO5kWK6DHk5bNfrgASmBq+LpZ/vgNFaI+CT3y1RO2S96Sfl+xiCEPORv+NMOWbHygdvfzOw+zp+Jbis3BkrSNfG+8ry9jC4K48ZlhKy70/2DyjIznBxnK/nexV7vKezAS3PI258AhNg4rCJUho+A2oYrHwXJS5gmpsh3KjdKsP7s/WzXkwmdBKe49RUPOHok4wb/R4W0hPsI9HPWLEbODye06htufGwuKiWxvcjhS193uWeb5FTKPtbg9sYWfO1hOo1uC3GfwOzZMOXtb3FtSmCl57wFveKrySL/ccQ7MEVvu0hTRageH6qjaDgGjxSU+5P0rmKEUU83pcJPDGFw3zSLjxFwTeH+O92vI+rp4ne9+N61GrzsUthMUkGoTHF6Zvn1aMYk8D6lJz1vArSozYqHGUm7ZT1PfsiY53sibvBdtprQPkNw/ORAtNsT8rTi94g911MOd1HApRVUNE/NqTYecIgJQbOzO5ai6GfWVbqCF9pr1EAsvf213/fGDAOeNVUNWKxmknviQCRdtJbonJmJfidtbhaAKRpliJTlH4PpCfNBxdsvv7w38q2KzGQ/G3UBqTSED
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(7416014)(366016)(1800799024)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cS9UaU1Pc25TdThLU1FYcXVkcnY4OWpEdXNIMW9UR21POG9JUmhjMW80bjNq?=
 =?utf-8?B?ZW03YVRjV1BOSjg1OXlTbnVmMkdHaHZVY1Z3UFpZbXdTcENXTWJVbnlTWi9i?=
 =?utf-8?B?U2QyVHJhTVEwTHZzNXlpM0wrNno2RVRjSURRUUlrcHh2a28wKy91ZGJZa1hk?=
 =?utf-8?B?UGhHTXlYUm0vTkRyL0daRmp2cHBlWWtJTThLdEROdllJRlJuZktYYmF2TU85?=
 =?utf-8?B?dWJpNTkraUx6S0YwbjhSbHJPNkNVV0RONVJnMWpDNTgvOUJzRkQwR3ZWK21Q?=
 =?utf-8?B?elk4cVkxeFcwUndCR2M0WE5qWVhPNEZvNXhmL2RvZEpaaWZoeTBIZDFSOGVo?=
 =?utf-8?B?QkZhck1NdjlmWUp0YXJ1SHdHcWVoekhmM1BUOHBNWElRcmlQRDI2cHRURHBs?=
 =?utf-8?B?SHZCMGtWcmxwS2NJTWxNMFZROFlvcnVjbm9EbTNzOHJoYmNqZENadndDVVB1?=
 =?utf-8?B?MDZWK1pYeDkzMncvdjYyVTlYMTI1ekIxVk90dGZ4cXAzczJ6cnVUN0E1M3dG?=
 =?utf-8?B?amp2Y3N2WUxLQWhBZUVCWnhud2xGb25nS2JFVnJ5eXpKTm9NVW5qNDBaV2t2?=
 =?utf-8?B?SVpwck5RWWk0c1k0VEpXM3NnR2c4NCs4akE5ckkvOG11ZjdISnhNbmMwb1dy?=
 =?utf-8?B?TnFJMkVHeE9temErMENGdEJ1VVhuRXo4OUE3RDZ2MFZBc3Fqb2YrUFRiSFNs?=
 =?utf-8?B?aEN6eW12aWFSVitBUSt6d0NGc2F2UTNyNE9TT2d5cnozekg4Y2FDeDg3UStx?=
 =?utf-8?B?cDNiM1B5VXBLK2FLdWl0eWZYQm1XbmpOcEdRV2VwQjA2QWx3REhoNW5GN09j?=
 =?utf-8?B?U3Y2eHNKMXN6dGg4cXZxdlBSSVp4cmFpd205cmI1M1FCY0hwN2Ivcm94Vngw?=
 =?utf-8?B?RWVmKzg1N2NBbDFqd3BYZUt5V0ZoVmtCTVozNEt5bGhoekZTRkYrRGJDaHVi?=
 =?utf-8?B?bFcxelRUby9QeXEzSi9pU1hGQ2FZdWxWK2dhZGFnZHdYUkh1MXBZYlFFeDNF?=
 =?utf-8?B?TmF3enhteURuaDMwdUUrV1poTms5WHE0Vk0yNDc4Rm9XYTduVHV1ajFuN01h?=
 =?utf-8?B?c1FMMVFFbS9nWHJmZ0wxMjdMTHJKOEVxOHZSV3lpWnNOdDdicUV6Nlkydm14?=
 =?utf-8?B?L0RGYmErbzRtWVQ2RXd2R2FmaVptSWE1SHgzRW5UVlY3eGdBektnOTFSbW4y?=
 =?utf-8?B?ci92OG56NUoraklITnNiWko2c1FkaU5HNExqOHJYbk9ZYmF1UWFoaUlzY0ts?=
 =?utf-8?B?S3FUOFNxZ3ZTbmNpVXpJVlN3WDZjejIwejhuQllIbm5CRkZHT3RKV2pDai9l?=
 =?utf-8?B?RUdTL1I0eXN4Zk92akdEVy83LzgzWTJPWEM5c25kRU9TWGNiSzdCT0h0QzUx?=
 =?utf-8?B?MUs3VFcvL3U3dlJuenpDMW8rTjV0cGNGcFh5eHJWaldEYXVRMFRhRm0xNmRC?=
 =?utf-8?B?d2g5NmFRY1VXRzByK2kvekRqVHRzVDVjODlnRkkyWjBORkN4bzBMWkdEOVVF?=
 =?utf-8?B?YWpqZC94dms4K0dTcHN1RFJrNGdBd01HZFVnb2x4Q0F3MTJkdTFmWGt4ZktO?=
 =?utf-8?B?eDJBWDd0UjUrbU5QVGk3b3dpbVRQZ1ZVSFVJNG9qR3VXOUVTTTdOMVduR0hT?=
 =?utf-8?B?THR0UmhKM1dnTGlJamhoWlAzK3lwZTI0bFB1WGtHRStKZ2duK1c0eTEyaXA0?=
 =?utf-8?B?UEZkZU95UzdlMi9xRkVjNlJ0akxleUwwZWd3MFVEalhmVGlDWWNGTFpSbTk3?=
 =?utf-8?B?MnZpOGVpZ0NNcWxOWFRyT3MvWXVOOGp3MzE0cGlGQTNkR2VQc005Y09NZlE5?=
 =?utf-8?B?WUZJclpNUGNXU3hWVlhoMkJwZkJKNU4veFFnSlkxcDE0UFFaWlg4T3crNjVk?=
 =?utf-8?B?dXNZOWpzajlPS1VTVHVLc1pSVnIxTFhoWmhabWdlREdnZ2YxQTRRMWhMTHZU?=
 =?utf-8?B?ZkI3UDJQa1lCb2JQdVB5UDJRd2tBaHVIbFdRcWpKSDhxK1dBYWtmZE9PL1Ex?=
 =?utf-8?B?Sk9xc1F2TVpJU1dWRXl0ditJOFFpTDlxcll3M0RuU2NpNWhOREJzRkRpV2w5?=
 =?utf-8?B?S05IMEN3SXY3WlJFUDJWd1lKWmptcGd3V3h5VEFWNU9HTUNDR2xjQW9EN2hW?=
 =?utf-8?B?S2c4ckxKbTlUUEppbVA3bkxCWnZTc2NRVy9aM3lpOEtpOUxYMmR2dC9QaGNC?=
 =?utf-8?B?aGZwVFBERWh5UnQ4NlNuUGlhOXZhU0ViOHJ3eGNxbEp6dnhDSWdoUGpKY0Jw?=
 =?utf-8?B?QVhCYWpGSTVQR3drMUpHenFQaTRRY0J2eGpONEJPTzB6R0plY0dFRDkwRnRw?=
 =?utf-8?B?OXZtaDhqMFc0NE1IQ0R1bHlqZElpQnZLL09kK2VQK0JwUm0zNy94WjJhYjd2?=
 =?utf-8?Q?1iyDfEYszunzqios=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9528725-e939-4d7b-3237-08df0448966c
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 14:36:32.0154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cRykgN+ypEyska0L0G8Ab0KeCWd/TgpQ0vG/zpSsc45tE730+2UQK5sHYSQOyHcvJ68D04rFVidpkyl8tvpLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9021

On 8/26/2026 5:35 PM, Frank Li wrote:
> On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
>> [You don't often get email from larisa.grigore@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>
>> Document the device tree binding for the NXP S32N79 DWC-based UFS host
>> controller which is compliant with JESD-223D "Universal Flash Storage Host
>> Controller Interface" v3.0.
>>
>> The controller requires access to the SCM register block and the core
>> clock rate when M-PHY initialization is performed. Add the optional
>> nxp,mphy-boot-mode property to select the M-PHY firmware execution
>> environment.
>> Currently, the M-PHY firmware can only run from ROM. If the property is
>> omitted, M-PHY initialization is assumed to be handled externally.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   .../bindings/ufs/nxp,s32n7-ufshc.yaml         | 99 +++++++++++++++++++
>>   1 file changed, 99 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>> new file mode 100644
>> index 000000000000..d9d5669be313
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>> @@ -0,0 +1,99 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/ufs/nxp,s32n7-ufshc.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NXP S32N79 Universal Flash Storage (UFS) Controller
>> +
>> +maintainers:
>> +  - Larisa Grigore <larisa.grigore@oss.nxp.com>
>> +
>> +# Select only our matches, not all jedec,ufs
>> +select:
>> +  properties:
>> +    compatible:
>> +      contains:
>> +        const: nxp,s32n79-ufshc
>> +  required:
>> +    - compatible
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - const: nxp,s32n79-ufshc
>> +      - const: jedec,ufs-3.0
> 
> Any place actually use this fallback?

You're right Frank! I will switch to `jedec,ufs-2.0` in v2.

> 
>> +
>> +  reg:
>> +    minItems: 1
>> +    items:
>> +      - description: UFS Host Controller registers
>> +      - description: System Control Module registers
>> +
>> +  reg-names:
>> +    description: |
>> +      Names for the register regions. The first entry must be "ufshc".
>> +      The second entry "scm" is mandatory only when nxp,mphy-boot-mode
>> +      property is present.
> 
> you already us if - else branch to restrict this limition, needn't
> description here.

Thank you! Will drop reg-names description in v2.

>> +    minItems: 1
>> +    items:
>> +      - const: ufshc
>> +      - const: scm
>> +
>> +  clocks:
>> +    maxItems: 1
>> +    description: UFS core clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: core_clk
> 
> Needn't suffix _clk, just "core", generally needn't clock-names if only
> one clocks.

I will rename it to "core" in v2, if that works for you.

>> +
>> +  nxp,mphy-boot-mode:
>> +    description: |
>> +      MPHY initialization mode. Defines how the MPHY firmware should be
>> +      initialized and executed during UFS controller startup.
>> +      If this property is not specified, MPHY initialization will be skipped.
>> +    $ref: /schemas/types.yaml#/definitions/string
>> +    enum:
>> +      - rom
> 
> why not use standard "phy" property, if no "phy" means ROM init it.

First, apologies for not including enough background in the commit message.

On the S32N79, the M-PHY firmware can be brought up in one of three 
ways, selected through the SoC's SCM MPHY_RAM_CONFIG_STATUS register:

1. running MPHY from internal FW ROM,
2. running MPHY from a (modified) FW ROM copy in external SRAM, or
3. running MPHY from a FW image in external SRAM.

`nxp,mphy-boot-mode` was introduced to select which of these boot 
sequences the controller driver programs. Today only option 1, "rom", is 
implemented and validated, but the property was meant to leave room for 
the two SRAM-based modes.

Given this setup, what would you suggest as the appropriate DT 
representation? I would greatly appreciate any guidance you can provide.

> Frank
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +
>> +allOf:
>> +  - $ref: ufs-common.yaml
>> +  - if:
>> +      required:
>> +        - nxp,mphy-boot-mode
>> +    then:
>> +      properties:
>> +        reg:
>> +          minItems: 2
>> +        reg-names:
>> +          minItems: 2
>> +      required:
>> +        - reg-names
>> +        - clocks
>> +        - clock-names
>> +    else:
>> +      properties:
>> +        reg:
>> +          maxItems: 1
>> +        reg-names:
>> +          maxItems: 1
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    ufshc@4ac80000 {
>> +        compatible = "nxp,s32n79-ufshc", "jedec,ufs-3.0";
>> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
>> +        reg-names = "ufshc", "scm";
>> +        interrupt-parent = <&irqsteer_coss>;
>> +        interrupts = <211>;
>> +        clocks = <&sys_clk>;
>> +        clock-names = "core_clk";
>> +        nxp,mphy-boot-mode = "rom";
>> +    };
>> --
>> 2.43.0
>>
>>

