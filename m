Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013003.outbound.protection.outlook.com [52.101.83.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDEE33260D;
	Fri, 28 Aug 2026 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909863; cv=fail; b=nmkkMGWo8P+kvrQAFrcv1pikh/wMTkN99W+HIAl4ynTCNow3ej0kEDzYCmjJnD2I28xdxYSlR41Toj0xl00h/foAGXwz3eTjewotkaxsPBHB3nsGWMAQogYMKRVMWFDzngBFJvoWDqK5nalTQ0G5/Xn/tgsI0FC888y49U53NP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909863; c=relaxed/simple;
	bh=W4Jc4h49qH/T6eL25mhuDql12gubDQPg0OjB3O0OHjA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UEbOgUMAQOuPkKHZFQfeBIxebUmYqCPup5xce5btrWJ1nSSQQ1dpFpm8tGAS8LMCjaLdF+VpFAljton2wUfJEIf5TJ/PnG1xywxoOH3hy+tlmfIgArcwwFAIsINuPuyLpwZvv8/K0+10drBwg0mo0L6lZURwNf8/0Xii6rneVNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=KgSYmJpl; arc=fail smtp.client-ip=52.101.83.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="KgSYmJpl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUJnNGrl1feeXZs7bIkSi6M9zLjJmHUgQDnYD6k/OOc3rE3oqar8l75CmJOhhioB/d7472BaYs6ksXu8Yn0yWgEwM4zJzuxya7/5g6wFSbm4LWi/a3ffELRHCSJDrOEO5sVqMkDFgUL+ygYO0xSimJzEckdrWgn75VC85X2Kuk+6cbHSio/3i7Ej/tbrwU6OJpleheIf1vz5ZcOri6W0Lv32TTL5hm12YUZEKD6kPKCVYz3u6GGDEaqbBFthEjKR0syImRSDMJUiMa/GSju/u2qpflifzJuhg5JiRzBzuzqwBE1S9DW6s/fBzsiqJBGm14ZgS4epP+qTvJEeQK/Gmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ua6znT7OmSltJfH9aeW4q5DuDKAMvEyEChB0EsuImQo=;
 b=uywhBrbqs2cyb9odzjHo21mzG24E2eewyR7tU5b1eEuL0x/YX6LDF3wd3cZbf2URCWvcdfDCmH8sqryIag72CwQeERYkz19h3MpAmw7SiJooGwZYpMQwqOP1raNIu8XKLRps9a5O2P6RNKqDw/t4rau9rluuscsbKIaW4uPRh+SliYU9I/ePz/g8q3FDMVtXCRkKZ6sMCWZHg5Sy+kAGq+MLdxxnxryC6d/z+rvNRC8rrfKEFr83B74tjh5mXEGvMzmcEpOvqNKbltQhnMDsbblJkEcqGBg4muEhM9nNmBfJPFdOLyn3mcqBr6hasLlAteMtgXAE1824gOY7Um3nVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ua6znT7OmSltJfH9aeW4q5DuDKAMvEyEChB0EsuImQo=;
 b=KgSYmJplGQgVwpPdg28FETBxkSiT8bJUGX/UuLFl2lV6ibjdD0U82bkEfFDoyGqgONlve1+/EDyAJN8VhsrKj95kiLrcBFfEV1c0FQ4MwdBqxS+udnDRJ7wFfJrFEwTqLs11XqQblhI53hcf8zNGce5oS7ARxQmoKtB2IrDCeDoEOTpmEP52sivZmk4h8I+5pPR4WvTGeoUBMUfR+voRc7w+ctuPHU2UXhNHVl5ad6ChBkfsQ2SuSWY0/AdowtKYKb9UtqKf5ZUBufBPvW5vD+qw9vESOCtCxPlq0gXKIlYwRJhfYRVv8DZbSxF6kaePqVrFiThDdD01A24QrmfjvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU4PR04MB12009.eurprd04.prod.outlook.com
 (2603:10a6:10:641::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 09:37:35 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 09:37:35 +0000
Message-ID: <aae98a14-ef53-4880-9c28-43ce56c01806@oss.nxp.com>
Date: Fri, 28 Aug 2026 12:37:30 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers
 into ufshcd-dwc
To: Bough Chen <haibo.chen@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
 aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
 <20260827104715.a4w7zdrjbp7wwtig@shlinux89>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260827104715.a4w7zdrjbp7wwtig@shlinux89>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0051.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::23) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU4PR04MB12009:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f7191f-10f5-4072-01c8-08df04e7fda8
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|1800799024|7416014|376014|10067099003|3023799007|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 PdgiEzcrdk5klwKsB6ZLCYiZXdjqEY5hiMKg7O8A8z/B442lt5EZX8+AEPs0mw+Hoy48YrIFdf6FL1dmL+z08CIhP3DtbpcpwXQtfvdx+d/JrPOrRBvXQYS1/ltyAQE6RFHotvjBgldn4j5l0n9c3JyVKQxOJaT0uY9vlA5W0FA0OBTEevufgNJ7VzE7eoGOm+8TVbVK1SRcGrsLxbfObsqX+sL8kuHePUwhOWEYTK3t03BTELc4K1CyUlqJu78X4ge+H1LAi3XRI1YdW/IBo2k5SFiLgvwajnBYbjeQz6U/dkdXBJKfCHhR59zhviwfhxcwHFC9sHUfWxtxf1KdFVxUZLEx+ON7wQImskIT7IK6ml3xYdh0vN+sUB5rj3WzqA0frXvWnzgaEKCup71pKKQOzSAtHgmEULuPLLu5SwSPuc7zx8sPlsn61GyxsONt4DsVeMSTFqrOH8b5NXFhUEVJBfva+Fp2d07AXS3RlrgL1ZLKTZ1DKyUZ5VItvzD8yPRLJ1hRod/1B162Y6jPyxF1GgniIXMwTU0sOo9s0HgDDVw+XH8++CAAtZ4rbwcW2j7VooIwXn6E3ie/dTiqCloiy1EdylM1j3LR00Gm8bEs/vJwoBJ6V2tnSH5Gu+YCyXgnWf6CX7P/8ZfkxHILt8cEt/UVh5mRzfnsazWHyJs=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(3023799007)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MUt5TEtTdEd2QVRVUlBxaUlpL0VOeGE4cW1ZclRrMVJyODI2QXRwKzNyUHlP?=
 =?utf-8?B?Y1hINFl2YVY4U1JrRTdZS2huL3Zxdk1NNWtCZHA1WkNDVGFsT1FKcHpKQlp4?=
 =?utf-8?B?V0YyNU1iaGFjQXNPVWExaVdUTjU5QjJYVTQrNWpLVHNRQmJWUUxZQURBR1FR?=
 =?utf-8?B?WTNXUzFrS1czSE9kb1c4U1N3ZmR1aWdkZkJreHl6M3Y4SjNveWlrZXRiMDcy?=
 =?utf-8?B?bEx3YldiNVhCOHdReXUzUFZOU1RMQ1hDWXJPZTNkdG1qeHBHTXM2emo5My9o?=
 =?utf-8?B?OUxNS1pSdzdQVHlqd3hiUy9rbkRER2VaWGdYUjg4aUx4WEVoaU9TNDlBb01S?=
 =?utf-8?B?cEh3SWI1RGxuRnppaDFYMXZ4VWNESktnTy9YdHRnSi9kckhTSzZZaVdzU0Zt?=
 =?utf-8?B?SmNIdlJvbzlDOHY0b002aHVGVVM3S05QRndZKzJlZVRKajdpbG52RWpnVlVI?=
 =?utf-8?B?akJvc25iR1kwNE51bXJ1VHBGVTloQ3U0VFNnVlhRdFA3RjFrVkZXT2Nvc1Y1?=
 =?utf-8?B?M0oxVjNET2lkTEZ6a0pmbjk0Q01VajNuWFZwOGFQb3JFbGNGQUFrcVJ4d2pF?=
 =?utf-8?B?QWRzb1VtU0xSRTFnRVJZek1BOThhYkRlNlNRRHBUbnRxTFdyMXc4QnQyaEFt?=
 =?utf-8?B?SmRRcUhQMmhHKzBGQmFkcnJzTG5DR3pHZy93bXVjU1pRSmVMNm9qejgrSVps?=
 =?utf-8?B?RVdTR1ZsWWhyWG5xbDByTnluQTZJNldyS3hIZEYrWE1YMG5rVVUzdEZUdWNS?=
 =?utf-8?B?eSs0UlRUc0V6Ti9VRjlZaGpQSTV1WXFoUE1FTHpMamxwb2p5dEhraEpjejFJ?=
 =?utf-8?B?ejRtcitsclVKNndIdkpRNEZQZ1NmU1hJT0ZIdXVtbkgrSEZpUnZEVlBTb2RX?=
 =?utf-8?B?a1pFbURMbi9QQjZKcDJ6c05keWxkMXVwR00zRzd1TE9uRjhVcWJKRVRZbVJ1?=
 =?utf-8?B?bkpKRHpWSVBvNzlpZ1YvTmw3MjhuNE9BQmV2c1JlZ3crNnU0akd3dnozeTJ1?=
 =?utf-8?B?aW5MdGR3WVlLYllqdUUwcHdrMGptSGtIUjZGZlJUL0pma2RJaHVqVHVFRml5?=
 =?utf-8?B?TlFTUWo1anROTVRSd1lETzRJQnQ0VnZMSjZWQTBBQUNDYnh6ZGgzSHdtUTRL?=
 =?utf-8?B?dmx1NHl2QXh2NW5YeWxWc2xSUEx6QU5zNUlTYTVya3VLVlppckVWMDJ3cFFG?=
 =?utf-8?B?Z2pZVWNQQk0waGxLSm9NbnIyY1RrTE9MZlVLY0J1VisxZVQzaUo2ekV4Vit5?=
 =?utf-8?B?a2VVcmFTMEZ0SDFkOGNpYnlReU5weEFlRktjMzVLK2NEemg5bGNzcG12VzBZ?=
 =?utf-8?B?dmFaNm1ORzdGQkVVNUpKRWRmQ1V5a2hrWWRvTTdPeWROemU3bDB0MWppcklC?=
 =?utf-8?B?Q0JzWEJPcnd4REptL2RLR3BSclVtZGpxT3BaMllZVTQvS0VCZXJjdWRIZCsw?=
 =?utf-8?B?ZFFXNFZCWkhUd1RFenhaSjE3VXFpVlFLQm5YdDhOTC8reWd4K1NqM25CdVpZ?=
 =?utf-8?B?UTNDNUFTNklaNER5WlovN3psNWViMXJMVjhOc1JnV1BTYTc5bC9jc3hPWWFr?=
 =?utf-8?B?eEhsclA2eU16VzJhenQ1eGZQdjM1eWxwMnlhMmt4Y2M2enJyQzFvQW1XenBi?=
 =?utf-8?B?NGZsK2RqL285dkZkcGViY0VRQ3Y2UTlsMiszOXlSc1F4MWN0eVFXQ1FNc3ZI?=
 =?utf-8?B?SWowdDNXTHVjZmd1OUxGYjdXRmNTR0dDNFo4VHpvQmdtb0wySFpSRUYrWmRG?=
 =?utf-8?B?UFQ2ckJXb3lkZjdTM2hSdlh5MVFYdG9UdHY2VWJhTHZrUEJIUWZuYm9VOU1V?=
 =?utf-8?B?TUxKR29wbWE0ckEvTzExWk9UamxMUXJmNks1VlpXZkNoejFGa0NEd0c1NUEz?=
 =?utf-8?B?UXVlbnVjeHlNZVd3dEl6Rk5rcDNwdWxHcmRySFFlUEs2ZEZEdkdDSktrRXVr?=
 =?utf-8?B?bVhaVGhvTlU4cEE3S3FZbjRKTENkTEJpNkVOMWhPMWtVbHJ5dkhFbEdXMVpz?=
 =?utf-8?B?OFdwNVBQUGZabkJsa3UyZnE3em0zb0Z4Sm1nWnhQM1RwUFBtMkdSMFlUM1M2?=
 =?utf-8?B?WWwyNzZrelZSK1NyaHczKzJRWHcveXRaUWNGQUx5amgyT04wOE91ck9UdEhT?=
 =?utf-8?B?WEFDbFJ6WVUwZlp6VU9kWmJKS3B6TXpVcGVsb3IrVFcrNll2UVlxUG8ycW0v?=
 =?utf-8?B?UWx0eGlPTk1DMGRjTndJNldJQVRqZTJNM1ppNEpGbDlOZ3B5c3BRZ2E1OUJF?=
 =?utf-8?B?bzhlWUJ5VFFTaEtITUVCdzdJMC9NKzhDT1FqWDNlc0V3aXpoTkdjcVhaQTJ5?=
 =?utf-8?B?OVFmTUJLY3A2Y0M5NHZPSmxHVFZCUTB3dGxXZzN5OVc0M0xyZlljRnozUHFo?=
 =?utf-8?Q?NiSJmZ0lH1UdhB2I=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f7191f-10f5-4072-01c8-08df04e7fda8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 09:37:35.2185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQUIGQ3uzX/DDeWzkpb3CL5K5E0dcdPjqNJiCou3GqvnJZALGWr8ClPIM81qsdCb8MKj8KfkeHde0IkVif/8xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB12009

On 8/27/2026 1:47 PM, Bough Chen wrote:
> On Wed, Aug 26, 2026 at 03:40:42PM +0200, Larisa Grigore wrote:
>> The AMD Versal Gen 2 UFS platform driver carries local helpers to access
>> M-PHY control registers through the UniPro CREG interface.
>>
>> Move these helpers into the common Synopsys DWC layer as
>> ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
>> duplication in DWC-based glue drivers and provides a single implementation
>> for future reuse.
>> Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
>> is no benefit in keeping them persistent.
>>
>> Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.
> 
> ufs-sprd.c also contain similar code, seems can also re-use this helper, but it
> do not include ufshcd-dwc.h, Unisoc(sprd) guys can do the further check.
> 
> Regards
> Haibo Chen

Thanks Haibo! Yes, I noticed ufs-sprd.c has similar code, but I didn't 
want to touch it since I have no Unisoc(sprd) hardware to test on and 
don't want to risk introducing a regression there.

Regards,
Larisa
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
>>   drivers/ufs/host/ufshcd-dwc.c      | 77 +++++++++++++++++++++++++++
>>   drivers/ufs/host/ufshcd-dwc.h      |  2 +
>>   3 files changed, 96 insertions(+), 68 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
>> index 0d4d5e98ad65..c7da95999c85 100644
>> --- a/drivers/ufs/host/ufs-amd-versal2.c
>> +++ b/drivers/ufs/host/ufs-amd-versal2.c
>> @@ -43,57 +43,6 @@ struct ufs_versal2_host {
>>   	u8 ctlecompval1;
>>   };
>>   
>> -static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
>> -{
>> -	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
>> -		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> -		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> -		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
>> -		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
>> -		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
>> -		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> -	};
>> -
>> -	phy_write_attrs[0].mib_val = (u8)addr;
>> -	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
>> -	phy_write_attrs[2].mib_val = (u8)val;
>> -	phy_write_attrs[3].mib_val = (u8)(val >> 8);
>> -
>> -	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
>> -}
>> -
>> -static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
>> -{
>> -	u32 mib_val;
>> -	int ret;
>> -	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
>> -		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> -		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> -		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
>> -		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> -	};
>> -
>> -	phy_read_attrs[0].mib_val = (u8)addr;
>> -	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
>> -
>> -	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
>> -	if (ret)
>> -		return ret;
>> -
>> -	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
>> -	if (ret)
>> -		return ret;
>> -
>> -	*val = mib_val;
>> -	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
>> -	if (ret)
>> -		return ret;
>> -
>> -	*val |= (mib_val << 8);
>> -
>> -	return 0;
>> -}
>> -
>>   static int ufs_versal2_enable_phy(struct ufs_hba *hba)
>>   {
>>   	u32 offset, reg;
>> @@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
>>   	u32 reg;
>>   
>>   	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
>> -	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
>> +	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
>>   	if (ret)
>>   		return ret;
>>   
>>   	reg |= MPHY_FAST_RX_AFE_CAL;
>> -	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
>> +	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
>>   	if (ret)
>>   		return ret;
>>   
>> -	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
>> +	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
>>   	if (ret)
>>   		return ret;
>>   
>>   	reg |= MPHY_FAST_RX_AFE_CAL;
>> -	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
>> +	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
>>   	if (ret)
>>   		return ret;
>>   
>>   	/* Program ATT and CTLE compensation values */
>>   	if (host->attcompval0) {
>> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
>> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
>>   		if (ret)
>>   			return ret;
>>   	}
>>   
>>   	if (host->attcompval1) {
>> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
>> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
>>   		if (ret)
>>   			return ret;
>>   	}
>>   
>>   	if (host->ctlecompval0) {
>> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
>> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
>>   		if (ret)
>>   			return ret;
>>   	}
>>   
>>   	if (host->ctlecompval1) {
>> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
>> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
>>   		if (ret)
>>   			return ret;
>>   	}
>>   
>> -	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
>> +	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
>>   	if (ret)
>>   		return ret;
>>   
>>   	reg |= MPHY_FW_CALIB_CFG_VAL;
>> -	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
>> +	ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
>>   	if (ret)
>>   		return ret;
>>   
>> -	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
>> +	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
>>   	if (ret)
>>   		return ret;
>>   
>>   	reg |= MPHY_FW_CALIB_CFG_VAL;
>> -	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
>> +	return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
>>   }
>>   
>>   static int ufs_versal2_phy_init(struct ufs_hba *hba)
>> @@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>>   
>>   	for (lane = 0; lane < activelanes; lane++) {
>>   		time_left = TIMEOUT_MICROSEC;
>> -		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>> +		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>>   		if (ret)
>>   			return ret;
>>   
>> @@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>>   		else
>>   			reg &= ~MPHY_RX_OVRD_VAL;
>>   
>> -		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>>   		if (ret)
>>   			return ret;
>>   
>>   		do {
>> -			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
>> +			ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
>>   			if (ret)
>>   				return ret;
>>   
>> @@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
>>   
>>   		/* Remove rx_req override */
>>   		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
>> -			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>> +			ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>>   			if (ret)
>>   				return ret;
>>   
>>   			reg &= ~MPHY_RX_OVRD_EN;
>> -			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>> +			ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>>   			if (ret)
>>   				return ret;
>>   		}
>> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
>> index 21b1cf912dcc..45920793d1a8 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.c
>> +++ b/drivers/ufs/host/ufshcd-dwc.c
>> @@ -141,6 +141,83 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
>>   }
>>   EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
>>   
>> +/**
>> + * ufshcd_dwc_phy_reg_write - Write a DWC M-PHY CREG register
>> + * @hba: private structure pointer
>> + * @addr: M-PHY CREG register address
>> + * @val: value to write
>> + *
>> + * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
>> + * UniPro indirect register access interface.
>> + *
>> + * Return: 0 on success, non-zero value on failure.
>> + */
>> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
>> +{
>> +	struct ufshcd_dme_attr_val phy_write_attrs[] = {
>> +		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> +		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> +		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
>> +		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
>> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
>> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> +	};
>> +
>> +	phy_write_attrs[0].mib_val = (u8)addr;
>> +	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
>> +	phy_write_attrs[2].mib_val = (u8)val;
>> +	phy_write_attrs[3].mib_val = (u8)(val >> 8);
>> +
>> +	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
>> +					ARRAY_SIZE(phy_write_attrs));
>> +}
>> +EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
>> +
>> +/**
>> + * ufshcd_dwc_phy_reg_read - Read a DWC M-PHY CREG register
>> + * @hba: private structure pointer
>> + * @addr: M-PHY CREG register address
>> + * @val: pointer where the read value is stored
>> + *
>> + * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
>> + * UniPro indirect register access interface.
>> + *
>> + * Return: 0 on success, non-zero value on failure.
>> + */
>> +int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
>> +{
>> +	struct ufshcd_dme_attr_val phy_read_attrs[] = {
>> +		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> +		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
>> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> +	};
>> +	u32 mib_val;
>> +	int ret;
>> +
>> +	phy_read_attrs[0].mib_val = (u8)addr;
>> +	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
>> +
>> +	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
>> +				       ARRAY_SIZE(phy_read_attrs));
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	*val = mib_val;
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	*val |= (mib_val << 8);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
>> +
>>   MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
>>   MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
>>   MODULE_LICENSE("Dual BSD/GPL");
>> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
>> index 0406f2bb576b..d8673cd54d4c 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.h
>> +++ b/drivers/ufs/host/ufshcd-dwc.h
>> @@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
>>   					enum ufs_notify_change_status status);
>>   int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
>>   				const struct ufshcd_dme_attr_val *v, int n);
>> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
>> +int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
>>   #endif /* End of Header */
>> -- 
>> 2.43.0
>>

