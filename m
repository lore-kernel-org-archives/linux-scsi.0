Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013063.outbound.protection.outlook.com [52.101.72.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA7E35B63C;
	Mon, 21 Sep 2026 08:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978744; cv=fail; b=MJk/QhbdLENOVdOhgMhd1R7L8iFe/R6mNVol2Npue47ge6hVkj549YKNp1xlrnX2l4nKnunlxy3bDwgU+p4Hk13IbX4+6ZXbQTiLwq5yu8QBAjoHgu1YcJlbdWBeYq7m2XrmnYEutXoPi9OPvHF1R75/kg7xvoXGYko29pM8xks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978744; c=relaxed/simple;
	bh=USRDzuzI8Z4HxjJy1F9R4BFYc+fNvQpoPzmzwj6M2KA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ft9VL7p+9KxiVVtrQA0iapdNYZUPMBLXWWcVVxROt5NRh8jwpRYpaEXdxfLB/HpaylwDdf3I/dARjIO3Uy0fe1CwqDQWqKYzmOzurVJ/RxMz8R7IwFxOvrbnldHfxLLRYXdIGFwKslTsWslSC40EYXSEiKgTx7nMsnyQtP6alcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=pqBwFkJ0; arc=fail smtp.client-ip=52.101.72.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="pqBwFkJ0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsclQiocVOX0S3P7rGn/M8f9ePwI4nRXV4kSa58AKaWEAPPJ6kIKj7q9HX6Wu97ZQFI8TqbuzJLIxH0/pux05jDB21cKE+mqnanP72ZBfczQhxOy2s/a7FEKIDqiq2jXhg2k/grV6x8RJe12m0NxwiNncYFlUc13bgqbAYw5nlPTrA86hcMKJZdRP7jNt3baAgDvsTtNv18Eraz5jkRIaUng0iXu4ChqVc+1i2+pOjEK/qARtcdWxBBGsmzuEXTM2rhAdZK/hcuBI0CA6ayW8syUke46+nX9AUpioNRD6/XgVAOfaRA/3Lenq03IU+a/wqVMBS0S/+HFWC9+G4A+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lw4fsaGK6Q1c7CILx6ZigaqtEIulw2aEvy3Q2xsDzYw=;
 b=gQKNzdAlBnR2I+FDDvgkRVXhiPA4qWUgR6IOBC08RxY7BOypZp+Al8ka5RCyuK/4z8QctnOGjZQRtigJcU666dnV4Ib1v3VUcMX/QgMdLhsFka+WnD5LwJ9qc6NFEbwfUFU1wIGg7fXrTBcCQybHdQZI1DnnglLuvH/bB4w+IoIMcQE2T9swJyYAFNOAtnWVXnxPXrd1dO4bT1yC6KbxTbnKxZ/aZTQo/DoW3Qj2rno1fslepvZlQlay9ph2q0HUr/km7KCYePeFpTBwbN9WOB1YRcJ1eSSvw9rgOq8AutYITd/jlpjlV7RGcCTlVfIg3XWtStqlfq42ZJWBlgcw0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lw4fsaGK6Q1c7CILx6ZigaqtEIulw2aEvy3Q2xsDzYw=;
 b=pqBwFkJ03JgFdleOJvumGp04kIxWrPKZaS30VzCMug/n4XDaycUh7KKf29OQLh2W/CkAQVbnTluh1TzDshU7N4ZdGGhdOSUjifTlhPKJrbBWjNcR4MbqRw41//1Z2UTJvRvz0SQelr958RideWRSLKSouI5zGhPdva6gDdRupuHHpRcWtfgOd2I5YRuZiGg77CLfKxE4Dfi+K0mZNc22wGBfv5TVYSX8Weux3e9L4NjKsbOPWLwxgCFhclXJMvEoAM+q6zqKGZzvPnY55ZlJ1TSbHmzdvW2oL0hOmddYYv8+cEj4rzAcuZQFIY7uGzSPK8RQT2k/Vh0KDKckDHck8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM0PR04MB038800.eurprd04.prod.outlook.com
 (2603:10a6:20b:801::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 08:18:59 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:18:59 +0000
Message-ID: <18b4d45d-10b5-4f25-9553-f3c27216db42@oss.nxp.com>
Date: Mon, 21 Sep 2026 11:18:54 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] scsi: ufs: dwc: Return a negative error if the
 link is down
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
 <20260917091555.1443076-2-larisa.grigore@oss.nxp.com>
 <aqwOMoHrxaWXoQUX@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <aqwOMoHrxaWXoQUX@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0027.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::32) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6a3e4656-05fc-4434-a86b-08df17b8fc6b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|19092799006|366016|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
 w6VlIqI7ZHJ1VB+yDlTP/ZzRJkL+eZQjoGSVbiE94yDyl8fETBqhXnSPLHvsju8OmxFOk0uKgFrku8D0pFJkR9LgsBmWYThWgg886RimL/sPxDHegVKiFGdYLP/22SKvZ90utX/A2hnmwOObTb6BPVyyFOB31+1Wfs9dbvZaIojxbxAWLoH2grrbjmD3nSWBRby2zSYX86rLP5kwIYvbUUa/j63KMT86OGpKXGBRDPfMb6kdfAuTkPIMSmUz5ijJTOmdYyFCxN7wMStFp6xZqxIrslajqef4NC9BLKD9PjGlPwNjoiGJSVT0ALExyXgQ/dlpNM7nHXs5C+gG5eWPvR84wtDkFcJgm9j4NRa2VpJS8v4aAuZtTckz5TOjmNqYQBYE8uB11YccgC07MP0cgrRvJI/gq3l6Ero69NcVxiks40GEFMS4L4IMTRbS07xAKjEB6FDv5CxIMDpo0ZZTqo0uAAtN5dLv4YoY3WlP6CmdE02knROKBbTXflJL5O00oD3GhVxGpKROa2wM2e9iOexgHsZo59S/UYTd6IBFEPFpIN6+Na81jqiiCMQgCITAp1YmY3XykvrJilBcoO9zztm4QQoHtGVGaG8YqXt/KTsMa6geyt4kh2peLkziqDdS+X84u1Z8pRWs0zq+HcsEOsObvwy2z8bLZ+54tOlG3mU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(19092799006)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UldLeVBzZmg4bVNYYmJxR1RsYVVKV0k1L0gyWkRaL081elgwZ0hsbFJ4RExJ?=
 =?utf-8?B?OFBwUW9pN0c0Ymx1NndWSE5pK1lrbVFXVUk0cGVhOVNCbVNYUmF6eEpKd2Ex?=
 =?utf-8?B?MGhDejBYWjJGS2lRcXpFQjNaNVFZL25sRm8vTC9LMzY0TmlQcC9jNTJlTzBt?=
 =?utf-8?B?ajQrMWVQMVh2elh5bWdoeWQ4K0JIbWticTZYRm5hN09HR1VxbzRaQ1VlemxD?=
 =?utf-8?B?MkJTbWI0TDZwWW4reGVwZkVkSjVxMGxxeGhldWpHZUs3czB4U1B0djVBdVc0?=
 =?utf-8?B?MVphUC8vdjd4VEVockJhV0kvN0Y4ZWtDUDVIVDlXaDlxS2J4UFVlVWk1OWsy?=
 =?utf-8?B?WXpUQVVveVAzclFuYjFxMlhSd0tIWkM2aVliYXg0K0RxV09YMW5ybkVLSEl1?=
 =?utf-8?B?K0xCOUo3OGtSQkxpS1FGUkFLb1ZPb3ZzSXN6bU5MbFFCNzFUSW8rdEtuRm5M?=
 =?utf-8?B?dmREWkdDK1owbjJOK05ocThtaFFMUTJLdldPL2xsUU1lbENEeDd3dTZKVjBK?=
 =?utf-8?B?azZnazkyZmV3djEvUC9GNXZRRUtKalhWcUhKbUYvV2dvcHNWRWdOR2lHL2pu?=
 =?utf-8?B?ZFNpZ1ZvZjJjandyc3NkcnZZZCtBVzk1c1hlekYwZTd1K3o0SkFjVk00TGU2?=
 =?utf-8?B?OFRTR0lqZkMwcWlaQ0NkZ2EvZUFRT29wbmFTMnJVb0orbFpJdXdOd1EyaUxj?=
 =?utf-8?B?bEpoY2NJQVJGVzM1Y3k5TEJ6dXhmVy90V1dicVhXUElPUEpBdmVld2dwaXhL?=
 =?utf-8?B?NU55VHR4TE5yK2h2UlVIVjMvcDFiNmxCQk5PNDJVbmdIV2VWejJXLzdZc3hP?=
 =?utf-8?B?dGxXRUJRSlFaOFZ6R0pwVnRPelBYZmpyUk5ScFA5WGJjd2IzbW8vb3dKNEw5?=
 =?utf-8?B?YXR0ZnpzRmExMGQxSUVsdHhqdGtFN2ZETVpwR3NtREtrOGJBcDJZeGZhMVUx?=
 =?utf-8?B?dkcyY3dpZzdDRVVhQ1p0aC8vWk83d2ltZ3pGLzc2MmF2UmMrbERGdlVMUFRu?=
 =?utf-8?B?bWxKOGdpSE4rKy9rSExycXVPSFlwamNld1ptY1lvMURYMWlNVnRuQ2tEakpJ?=
 =?utf-8?B?WDUvOGRmRWttU24veGMycER2VTNlem12cjJxTlRsRU5ESnZwVnE0alZRalln?=
 =?utf-8?B?T2hQVDViS3BlaE5MNWNweDd3ZWxsb0hGYXNtUTczb2hOSnFjZFcyWGNsMDIy?=
 =?utf-8?B?bFlMdW91ZnRJUVRsb21IMXErYUFEaDZ2NExNM3hxcEJKTnFNWEw4UEd0TUdX?=
 =?utf-8?B?Tkl5c1ZnY0UvUVVybE82MDdjRVdzRkxOUDk1emJkc1ZkbUlsUXFqeUU4YWJk?=
 =?utf-8?B?bjZNYXE2QWRKaFVrSnZNdHpNelF6ckNyWE5NQjJWK0lmOGhST0ZtT0dkMGpQ?=
 =?utf-8?B?Rmc4YVBlTG8zNFJETSsvcllhQlZWL1YweHNwVS8zUGJlSUxIMFhrTVpCdENN?=
 =?utf-8?B?V0NXdVBhOUR1bVgxUEppV2g1ZmhFSUJEdndaUytTdDJ0NUIxdHBiOS9Mbnhm?=
 =?utf-8?B?ZVNKR3ZWd2lBTUROZWxndU5rR2ZPQmQ4dkZ1QnpHeHU5M2dKaGVmdTc1bzZS?=
 =?utf-8?B?c0o5aXJwTmlTR2lmTGlWK2JuSHdqQm9sb29zRUFJMmo2bkpQcVlDZHVUMStR?=
 =?utf-8?B?VUJ6ckVTVkFxbHF0R1JwcnV6U3VWWm5Kc21oN1ZOcG0zc0tFNzh0eTEyOE9X?=
 =?utf-8?B?YmtVVGZuU3Zrcy9FUzdDd2tIeXRkdDNoNTE0bWtCU09PbFFRLzF6d0J4Z2M2?=
 =?utf-8?B?aStxTnI1dzVJZ1hnanh0V05pclRxV3Z4eVFtU3hpZE1ON0pBWmpPeU5GdVV3?=
 =?utf-8?B?S0p1dzd0SmRHNnYzQ09qazJibmRtOCt1MHZPSjh2Z0Jmdk96cHllZ1hFS0o5?=
 =?utf-8?B?SHVIMTJFNGNSdXN1cUFmK0N4WlpUcVg5VjAza25nbzJLcVp0RE95ZzY5QU5r?=
 =?utf-8?B?MWFpMW5IN0ZhazZIbmowY3o0b241R2ZHQ29QNldNd1VmVy9veXMyb3RuMXdj?=
 =?utf-8?B?aUE5WmJuUVYwcHcwWDdiakdncS8xZHFab0tHWm1YeGpJakMrZGdNMWpvWEZJ?=
 =?utf-8?B?THh3RnpkUTdjTmhOSnllVkxqRTYyQWR4a09OK1h0STR2N1NxMGk4NGRwSVdP?=
 =?utf-8?B?RFFUODFvNVZOajdwcEZ6bXJJUFh6b2tpWVNpQWt6OGh2emFmTzU5b3BVNXkx?=
 =?utf-8?B?M2d3WkRYUkNFWERFelBVcU5RdjdoV0hnVTFtUDR5L2dWeGE5VTBqcjY1STZU?=
 =?utf-8?B?ZFNLaWVHSWtDd2swTXFuN0cwNVpZcE1yaUhLbDlmWXlVQ00zYjhsSjJtSWdH?=
 =?utf-8?B?UnFJRXlYM2pTZ2txVEFSMHZsK3U2Y01sbVRaUFMzMVJZemh6STNEZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a3e4656-05fc-4434-a86b-08df17b8fc6b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:18:58.9028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wj26fbWjpjdEcK4e5Yb9zurrVdA+Oz7mLQcHdTgQMIO+x491uyeSFIKrqbMisOktrU/K28q/U8wwRIRoN5wJWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB038800

On 9/17/2026 6:58 PM, Frank Li wrote:
> On Thu, Sep 17, 2026 at 11:15:45AM +0200, Larisa Grigore wrote:
>> ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up. The
>> value may propagate through callers that expect failures to be reported as
>> negative errno values.
>>
>> Return -ENOLINK when the link is down and propagate errors returned by
>> ufshcd_dme_get().
>>
>> Fixes: 4b9ffb5a353b ("ufs: add support for DesignWare Controller")
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>

Thank you!

>>   drivers/ufs/host/ufshcd-dwc.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
>> index 21b1cf912dcc..ccf785fce6cc 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.c
>> +++ b/drivers/ufs/host/ufshcd-dwc.c
>> @@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
>>    * ufshcd_dwc_link_is_up() - check if link is up.
>>    * @hba: private structure pointer
>>    *
>> - * Return: 0 on success, non-zero value on failure.
>> + * Return: 0 on success, a negative errno value on failure.
>>    */
>>   static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
>>   {
>>   	int dme_result = 0;
>> +	int ret;
>>
>> -	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
>> +	if (ret)
>> +		return ret;
>>
>>   	if (dme_result == UFSHCD_LINK_IS_UP) {
>>   		ufshcd_set_link_active(hba);
>>   		return 0;
>>   	}
>>
>> -	return 1;
>> +	return -ENOLINK;
>>   }
>>
>>   /**
>> --
>> 2.43.0
>>
>>

