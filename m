Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012048.outbound.protection.outlook.com [40.107.209.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2894F1DF98F;
	Tue, 22 Sep 2026 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068949; cv=fail; b=O28OcffxRNzdOX2sqMK4mSb66xoS+/44L/mcZsro87V0rJLEYbMnH0gtkLl0pwSJz+7+adE3dEtcAJo3WGAHpcEqXRqz4flie9DRNvVOk2OOWb1ThFLwXzOkqWAzf1zSFLHhYPpt4aVEb2gd0EoPNNR4dd6GGR4+Ofmx+iaxr88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068949; c=relaxed/simple;
	bh=0sB15q5cLCuxp3QkiEVe2wAdSKboWXctkecEnXH6F2w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MFPoZXuJ/I4yULOo3K33/gUIvrzLBC5ZD6VJvmHKGc7qktmOBfeZELoyRAFS6bWwq2pB024QGsh+My/xoSZJYtwVM/lv2mXmlC8albupThoVmi3zaWhIfBCSWRDN85/AMdMbehIYu9e450yLBhdFFqrdT5wFqEBg9RU9UrWLDl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tC+ovV5j; arc=fail smtp.client-ip=40.107.209.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tC+ovV5j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyewkjZl6SXpfd69nAvFX9cgJwXEiBmwetN2MIClHu1Go6OVzt/yPS4e8pysBv/UbCHuMSjyq8FWdIbqTLwO4AoZhJV+k2xybdsfi7IfozOcvMYhZJyw5WwtCMt285Jb5VKnfSUdAicUYPiUhFcv4/PH6Z+7gFXa5HYSf1xFvZ34wV7N6jHzUn1npEqQl9ib30WMBixOPmPjOQeWb1XSob+VrdQHDa7SakW71cVTb1/8NK+4YZp6KrwH3qLcb9WpoPu3DY2yvrIxsdQVIJQlZXGE7lsEcGsAkQGV1+8eRVGMOrab4NcaJj7E3MKPI/adEQROrFXkvwdm1l3gt1SFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jedMmMbEMmPj2JEC7tbeXdHp/RvVsH35PBqpqv5pDFQ=;
 b=ZhHcaxkAkJ6d9dkIbhGLTNWIdf2ICuD8WcZIjpcg+ULVOhwbXNCgAf49SoCB94Dyb5mTTiwlCBQxRXsHUpuKn8zaVuDx1cItCi2nSfbXVmTrXbSg0fDm0ONHLJUblg8NOgEbbJxmQQI07g5xG6IYzfsrUqh/9oZgEPTCKzD0cwIrG6gNhZuEySlAiKWCOu0dbPvhqmpyr7qbiQ1IcsAjawTiGulgZNd7mBf4TBzh5SvpTD5gvGfJJ6F5qQBSEnzft3FS9jrUYbEIBZBCbi9/PBZSga2FMMAbqO7mDH3ZPKXY+5gQNrN+wNNvl3Dfviz2hVV2pd/8rlLC24SKC15kpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jedMmMbEMmPj2JEC7tbeXdHp/RvVsH35PBqpqv5pDFQ=;
 b=tC+ovV5jrf8hfmJw1hsSBoK1FoQeaRlctRJQEOWiUvHPg+G7+2mcJ5EWiZWCddvEOyy+HdeXTVP4JaUT0LRw/GW9USm1OPj9NxFq6SpuChQc/zdLWb9mBDKoLlN+33xOdcOEa0vauQ0viJ4/9YzCRVO64gikLiv0gz9u6US6kxRieR2BvGtgEpMG6Qms+s7f1dJ9aLvoeCPvWOVsTRaYk/lTHSnU/OiQcG+YcCSQExkewcQlPi36IDRLmZyW3t9LPrrbuGvGmB22ceF22+kHbhg/+U5Ekqfksax3zu78JFSu4/w4QFzFPi0uaONS8horIB6vUSJ2WVHuZQfXguz+yg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14)
 by CH1PR12MB9720.namprd12.prod.outlook.com (2603:10b6:610:2b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 09:22:21 +0000
Received: from MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76]) by MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 09:22:21 +0000
Message-ID: <86165a44-7d0a-4e6a-bc89-10bc83d69805@nvidia.com>
Date: Tue, 22 Sep 2026 14:52:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] dt-bindings: ufs: Add nvidia,tegra264-ufs
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Thierry Reding <thierry.reding@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel
 <p.zabel@pengutronix.de>, Thierry Reding <treding@nvidia.com>,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-1-e4a9831702a0@nvidia.com>
 <20260913-vivid-accurate-bee-4ccc5a@quoll>
Content-Language: en-US
From: Kartik Rajput <kkartik@nvidia.com>
In-Reply-To: <20260913-vivid-accurate-bee-4ccc5a@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26e::11) To MN0PR12MB5716.namprd12.prod.outlook.com
 (2603:10b6:208:373::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5716:EE_|CH1PR12MB9720:EE_
X-MS-Office365-Filtering-Correlation-Id: 792e64aa-9afd-4976-1fdb-08df188b0133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|4143699003|56012099006|11063799006|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	W1uxde/VtMpZ7Lkx7iWMatp2sryyxdvC4hyuNBsaRnnPtwkk+aB+bLmWc7+gxeTF2WMXxIZCFrjq6XDUxtYOALKJmjjuvhNiCVc82IlngsTeg7LObycirwMpSyd0lAN1UtpiDLAWLuX3UXptuCmwbXGnj4G9pDF2x8XvKg8Me1ozG10meH07WCfVcqBoWDIDIw0oe3zH7M1sPogWYjDVH06Ze8MFd4yAsTSCaOx3DiBroYxs5/p6zfayflsaRgYv3umoxZbMYql9ZNmVuid3og/WhD1Vt+s2J188CnKRXzu9EuZknJJF2SdwBeZ7/uF5ZZYpemaW63Ze9ymR1SvFwg+ovoSLNfAc9yV6L9z6MgjjTYyYJlQ2uu5E/Fs7OCFBI9/AbOEg3CD1r6Rcb5KwbncdakyneeSuDeNCZk11DPTtXLQ4M/TCYpe/mGzYJVMBn93WbceXXLCBZ6SLZCBbTT2+ZTk4DanjUgeY7Gvb2aJFVBbNLVXilNSTkG+UxZ0R/Ka40nSDuG2qvrSX9Opf364VH+5IasutiCD2bvmuyxsQ9gj5zt9odcQbX/qbqCcJYNsbg164GsjHnaI4JDESFvsxd8jmOI7T5ZFGh8hETtDb43zOk6oTC7boeS4R5n69FW6YEPyy3PmWXa0KlUvzKDfPbkRRcGWBt9OW4X2Gm2A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5716.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXRJaFNyenNZOXg0RWlQdS92dkllQURVc0lLb2g2NnhFVWxpbGkrbXl2b0tF?=
 =?utf-8?B?cWhVZ1NnMCtXTFVXWDdxTVFsN1F5TzAwUkg0OWlKTFdLaXJTYUh3UzlkNFgv?=
 =?utf-8?B?SlVMU0ltQ0MwRi9qMG5iM3YyNGlOS2JpVExMdGd6V1NTVXN4ajJQZkJFclQ3?=
 =?utf-8?B?QUFCNDEwbGF4N2loVGU0RUIwYkR0MEVGVzYrRWNia1VOTVZvRm1mbmpZWkE0?=
 =?utf-8?B?eDlSU3VYc3J6M3RoTTFGaThLU1h2c01xVVYzTXZGdGd2UDRJSHA0YkJISkRV?=
 =?utf-8?B?eTl3MmZMZmhRRTBETUN5OFJmQm9XZGZhQkJhK3JZSFpkWVpMM25zZzVkR2FE?=
 =?utf-8?B?TUI0TGxFcEd6UGRmS0ZDS0VKVTZReDZMTElMbUpuUWFLQ2NSUTBNaWd1SjU1?=
 =?utf-8?B?cE9LeElWcmJGSHdZeUpka2tUSFRmZWI1NS8yVGhyRjBwOE10NzZ0ek52eE5S?=
 =?utf-8?B?eHQ2aElyM21TdHdIZEEvUGlhazNka2NRTkl4SzRHWmZJVnVvVlVxSnRvcDl5?=
 =?utf-8?B?TElqWmlyV0F4UXZUZzh5enlwUnBoQTVtUXdQOHN6VldpNW5raG9YclJXdGRq?=
 =?utf-8?B?N2trRHcwWTZZemxNYnV4cVZJOElYdTlsemJLaWp4cUhDaWh4NTNYMUFqbzI3?=
 =?utf-8?B?OTQ1eXVPa3ZqckVjTE1lRnlYQUtIWlV1clI5MjQ3OFAwZWpsZUJKVUM2ejA2?=
 =?utf-8?B?NE1JUklLaUo2RytCQTFsUTJXcU9nMEVtZnIzSVVhQ2x1cVpzcjlTcTR3dWlI?=
 =?utf-8?B?L0JLN2NRV054STBvYlBoVUNhVmowdDJjMm90RWxmK243bDBEZi9tbHhhT3Qv?=
 =?utf-8?B?SzRYMzZBc2tydDFCcng2ZUtIbGJyOWtycmFnZ3pJYkRZbHpwbFdYS25nOGsy?=
 =?utf-8?B?TXZ3Zi9PdDBrdUpaTTZuWE9PTFo1alJDN1RlcEVDQWljQUozSkZmL2Z2S09N?=
 =?utf-8?B?bSt0aFQ5eE5URjk4Uy8vNkRockgxOFVyUHk2TFQ4RXdvOFVwa1lkQnNpdE1B?=
 =?utf-8?B?NHI4c240bFNwNWV0QjlzUUdlQ3dEVkNjOEtSaHErV0pGOE1yakFPZ3V4UTRs?=
 =?utf-8?B?cjBzak0rQVR4V2pHdHRsc3FET0I1S0YxbS9peHdDZTlKc3hQWldhbTR0R2FM?=
 =?utf-8?B?Y3UzWmVkeEd6eDNFMkk1OWFhbXFKOE9odzBFdUFLQ1g0c0tXTERSOURiRWxa?=
 =?utf-8?B?V2Q0VnJWK0F2VjlZT3MwRnNQQTRmZzFPREVTWlFZWWVyVkRqcGl5by9QaW0r?=
 =?utf-8?B?YmQ1VHBuUXJlVDE4RFErWmZCK2xsT2d1eW9sNmt6aWtiMkFxeDVNUzVScDRY?=
 =?utf-8?B?WjZZZUt3K1pqZUUwcUJqSUE3Ykl5bG9UYkVzMU0yVUc3NWZldlFac0NaS3M3?=
 =?utf-8?B?VEdBVzExVzZnN0Zna2grT2duZTJOZGlpWHlLa2hQOTBTVVdxcG4vYkJObXRW?=
 =?utf-8?B?YmdkSU9yNU1oT1pRVVNIRC8wNzl6UE52NDhLSm9SMDVFcUxoM2J1RGlaaDI0?=
 =?utf-8?B?WnU5ZkNSOWdLM21EZkJRMlhZV0RDRnhzcFQyL3hELy9xdURuclZaNUludEoz?=
 =?utf-8?B?Y3RrUWlad1l5QmU1Z3BTSUQ1RHYzTDJ1elk1N0lUQUVtc1BrUGVCMXpBaGQ2?=
 =?utf-8?B?b3VSM3pBVUV5RktFdzJaMmhRc0FtQ2xITVBhMVpmUkFJbUQrSFlhRGtwZEZT?=
 =?utf-8?B?Z2tXQ3RZb0g1UkVCNCsyQ2tFSjdsMDZoQ0NLQW05b0FRMzNON2tnR0dnQ2R5?=
 =?utf-8?B?b2hQdmVUcXh1QlBQc3FBOThBcGdxSkNQdmlSQzUxcFNCV3NoNVlXVzNkRHU0?=
 =?utf-8?B?eGp0Mk1Dd1BPYlVSMkhMdkV0eU9wNXE3WGlSbUVBWFFCNnp0Ukpld1hVbDJQ?=
 =?utf-8?B?YTd0V0JmUXBwTjkwaHJhTjNPN0lLNGMvRTB0QytMVWJmWUJNdlF3NkdkNFVP?=
 =?utf-8?B?cmxQdThXNnBObGpkVEkrUmpOUmZDQjJwQlNHUmsvN28zUnhnb1M2eGFwQWlY?=
 =?utf-8?B?dlo2RGkyUUVyRXZrZnUyenV3RWtiOExMUjZiUktrYlJ4OXdDQ2l2OTdFRjNS?=
 =?utf-8?B?NFgzd2NteHBVREdKeWthYTY0MEVIdkUwbFdTMGowNDE0V3JRN3JsN2c0REQv?=
 =?utf-8?B?TzBSalZaTDcyOFRGa0s4NnVhN3hTYlZDY2o1OWdPd1R6amE3TGVTaVUxN0pv?=
 =?utf-8?B?MjNaS2d4YWJJejBSUUtTZXppb0luN0kzVDZBdmRrMXJSMGgzVFRwdThZbkVU?=
 =?utf-8?B?ZTdMSjZIaGI5cU9ndW5hcVZZWEFLbGdlNm5vdXFKekxUMHRjNkd4NEVCNVU2?=
 =?utf-8?B?ditnR1lpeVdzYlNraDdjcmxHK0h5c3RPUGprSEdaK1Z6S01hclVZUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 792e64aa-9afd-4976-1fdb-08df188b0133
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5716.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:22:21.4758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOraB00PoY8khkkUccXdEfJwgWT68DAOfxPgArpXO+ZSLaLJNscXxt00xdeipj7lmdqKef053Cxmgv4WcIr25A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9720

Hi Krzysztof,

Thanks for reviewing the patch and apologies for the delayed response.

On 13/09/26 14:10, Krzysztof Kozlowski wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Wed, Sep 09, 2026 at 04:11:19PM +0530, Kartik Rajput wrote:
>> +  clocks:
>> +    items:
>> +      - description: UFS host controller functional clock
>> +      - description: UFS host controller divider clock
>> +      - description: UFS reference clock (PLLREFUFS output)
>> +      - description: UFS device-side reference clock
>> +      - description: M-PHY reference clock (UPHY0 PLL4 digital output)
>> +
>> +  clock-names:
>> +    items:
>> +      - const: ufs
> 
> core? Names equal to block name are not really useful
> 

ACK. Will rename it to "core".

>> +      - const: div
>> +      - const: ref
>> +      - const: ref-dev
>> +      - const: phy
> 
> Shouldn't the phy take its reference clock?
> 

The name is misleading and the description is wrong, I will fix both.

The M-PHY's own reference clock and PLL are already described in the
M-PHY node ("tx-ref" and "pll"), this is a different clock, UPHY0 PLL4's
digital output, consumed by the host controller.


>> +allOf:
>> +  - $ref: ufs-common.yaml
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/clock/nvidia,tegra264.h>
>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +    #include <dt-bindings/phy/nvidia,tegra264-mphy.h>
> 
> You need to decouple dependencies. Otherwise how is this supposed to be
> checked with tools? If applied, you just broke maintainer's tree.
> 
> 

ACK. I will drop the include and use raw cell values in the
example:

     phys = <&mphy 0>, <&mphy 1>, <&mphy 2>, <&mphy 3>;

Thanks,
Kartik
