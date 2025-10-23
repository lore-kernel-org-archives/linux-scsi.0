Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ABC2C15A3;
	Thu, 23 Oct 2025 07:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761204692; cv=fail; b=DokMGV1LBCyNnp5J2Mc9RIQ56YYH0nKqDThflEGnShQJvwwKzph2VvDxd4/Ze1HcXkLhP5MeQLQ531igJUYLngE4HiZ4BgneoOqyokUg/tU+95rykoH6GOAYKL/830uqIFK2xjAJXB39l/9YW1XpN4hRciYD/jipGie+owPW3SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761204692; c=relaxed/simple;
	bh=98OrmZzbMV64U2BgIVslyYU9Dhf80VZF+hEbrTJBt+o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q54z5AhEwgRVLSwmQfkidOY3DO0mTddcuaOd+X+uqGT/m/UnqEq8S+8MmrDG36zs5XH2gTIO0qFMNRnUvp7GP+/Fk0DljB3wi3kZLiMHhw99plXcdwzLZi4GFwnthQmDKgc8AetcWcUyCnrLrK3+pZV7g1pPE6we2Br8haPkuyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SuDiIr7U; arc=fail smtp.client-ip=40.107.208.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SuDiIr7U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZjBuLzadIVi8iyCQjItloCMq3g435Nr/+rj7e2qQzqdZLUhcvh1GnfYJl4xUPCS8rUL321/8Vsf5xfb9E7xang/XwoOSMeg9PI5ANiVyRhAlAQwHhdmOt6nkkM1yFROM0F7R4SHrTp2PVcyGBQPD0UKBoJKuwDiWpT+C5Yf9QdX1QBcxF8IduNSFqeO3itmOoE6vVpwKdHHM++0ss2mljJZoSwITAe+GxcPUAx9QIuI0xwq1NSrx0mAwA0APW993RYhOjP0U0zWC0YGOQT+WWe7DfWrJikvmqQgLm55VkxwVYUdPysL1VKL7kR9BX0fwjHb0xNPs+PElY3z04V+ZFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JS0wN3fuP9NVil3WmjK0f6ZZzd778RhMsl9sGMOnTec=;
 b=RfMawsb0n/OTdgY5c0vVaXvM+5D/wtlf3FFxYI/YxUBoP2WoyAmbai+nbHXSUbp7l4QYxkskFCVIugQ1zXWiMHLkVvXdh5fsqTJc2kMSgsm+L+bxKhlKhZmnrGgxyZH8pvxDGsQLgxdfqlp7IFHpGE+aBi6Slg9BwCkMv7928Q/QY98BkRew3h9sAMmedCWh4gMs60nye+gm/atr1pZW0D34Rwww7jkEM0H76DaPOH15Fi/ViLwy/DJUiPg1m9X3ChNLV7NicwBBvTNlqYj10nUB3jVQbt/TPyY3T/plXDw8wHopvBg3guteowoNLJ0xIzGwAQHHVN0cQ5AGmGz4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JS0wN3fuP9NVil3WmjK0f6ZZzd778RhMsl9sGMOnTec=;
 b=SuDiIr7UMvXNjO4OnT4M3NxmX3i3j/2zRbmaAdxH+oVvKoQFFBEOTHTbfxBBjmI6vuG3bZus6twvzCpcAaieIlleQKGymkcXA8ODdTsxOwQbBvFV0gi8gJ+wSo+f8ZAR5MjBrxlDoEgbKdSpLhGyERpuRlT18bso9n2t3tpHqnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com (2603:10b6:a03:4f5::8)
 by LV8PR12MB9336.namprd12.prod.outlook.com (2603:10b6:408:208::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 07:31:26 +0000
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30]) by SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 07:31:25 +0000
Message-ID: <b6a9d2a0-00d3-4419-88ca-471efc7d0ff1@amd.com>
Date: Thu, 23 Oct 2025 09:31:18 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] firmware: xilinx: Add support for secure
 read/write ioctl interface
To: Ajay Neeli <ajay.neeli@amd.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, pedrom.sousa@synopsys.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, git@amd.com,
 srinivas.goud@amd.com, radhey.shyam.pandey@amd.com,
 Izhar Ameer Shaikh <izhar.ameer.shaikh@amd.com>
References: <20251021113003.13650-1-ajay.neeli@amd.com>
 <20251021113003.13650-3-ajay.neeli@amd.com>
Content-Language: en-US
From: Michal Simek <michal.simek@amd.com>
Autocrypt: addr=michal.simek@amd.com; keydata=
 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
 mpwx1d8=
In-Reply-To: <20251021113003.13650-3-ajay.neeli@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::8) To SJ2PR12MB8109.namprd12.prod.outlook.com
 (2603:10b6:a03:4f5::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8109:EE_|LV8PR12MB9336:EE_
X-MS-Office365-Filtering-Correlation-Id: 782d2148-8e50-4e19-789e-08de12062bf2
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2k1ZXJIQjVCckpPUFhtWGFGTGI0QXJ4SUU3UTh6WTRmS2s1ZUZtcjJTOHcz?=
 =?utf-8?B?SllJdTJ4WGJTV2dWS3lSai9mdllGM245d2Y4QzNXcWJvSEtNcVJhbU04MGps?=
 =?utf-8?B?QVVuYTRUUWdIajhreFJ1ODFCclI2dHFEZHVFb2hldk9LOGY0MG9YaVA0WVVz?=
 =?utf-8?B?UlRVWWR3ZzJieEI1YnZVL1hIWnZvSTNQMWN6SnV2WWlFdUNxN1J2WWdJcjlJ?=
 =?utf-8?B?ZGV6eVRGdGoyM0hKRktUTmMya0k1T1NURzRoMWFHOFdoNG4yZWdqY1RudlVi?=
 =?utf-8?B?N29FZ3hac1pScjlxZUp4VTBGZ05uVnIvRUl6cnpHZVg5WjVROTFNQ2NibGgw?=
 =?utf-8?B?c3pVUUNmeDhoR2xHa2ZQWW1UbVBFOFJWWDJndHU5YU51ZlpjTE1HZytWRTZy?=
 =?utf-8?B?NUJnVE9sVkNSeHVjcUFkempEV3krRUY2U0NKWXdYZWtnUTVQdGIyeVJFVkRH?=
 =?utf-8?B?eDBqWXlYS203YVgyQ3RISVZtVWwwWGRjZUJPRFpweitJUll4WU9NT3U0ME56?=
 =?utf-8?B?MHdHczR3MVZaeDBPMTZ2aTNMaGlzSVBqODF5MkxmTDJxTTRSaEZGYncva29v?=
 =?utf-8?B?d2xmRUhKdlFVVng5K0tCYWpRV0FRdjhGVnlMVHp0eDFRRUgzWko1RjI4SktV?=
 =?utf-8?B?bnZVbG8rS1lyalJ5SFZzYk1iUHFaUldrek5wc0phN2VJUW0yemI0WFcwSnkr?=
 =?utf-8?B?ZVY0aFdudWVpVGxta3Q3ZXJTaDFSRE1ybFlIUmFRb1VGOURMU2xkVE1ka0Vh?=
 =?utf-8?B?bkJhZXZ0Ti9vQmxETzdPdk9ZN2hzZlBNbm56Rnp3MEJxbmd1eVR5STFnSmRs?=
 =?utf-8?B?eDNHeUtFMFl6NlVyOG1BdGtpMWhsWFZYTkFScHRKd0NzYWNyR0ZVdk14cmV2?=
 =?utf-8?B?UVRUWG5scHNaVHhOQlFGMUhjU2w5V21mZms1WjdpUjBidW5sTy8rNEZSQVQ0?=
 =?utf-8?B?WTRyMnBMZThmZWlqb1hBempaMHl6MWRmV1FDUGJyWHhmUjZSbUhnUEtmc2hm?=
 =?utf-8?B?L3dsc09PN0NjdldYejJIMk11a0xsWTVHdDJHOSs4VzdTRHBUWnJEV1NEL0RX?=
 =?utf-8?B?WGV6NjE1dmRDNlhUSVB3dDdIaDMrK3d6TTMwV0ltNVAvc0N2MFFvYVlxaHRY?=
 =?utf-8?B?aGdxSkxndit2VE9rSC9NUEZvSmdma1hSWDBLNjRGdmdwdEM2VDJQY3J5ZWJU?=
 =?utf-8?B?Rm5aVG1qdFpyRDhtb3FxN3hHenc0RHZsYzRJeXBIWXVja3FSbDdhRXNOczRC?=
 =?utf-8?B?U3N2WTNONk9Udkp1Ym9uWGhzQit0WW1vRlU4QzIzYkZKWVNFSi80UXRpUi81?=
 =?utf-8?B?WExYUHVxUndrOGt2L015Q29Qdml3SDh0a3ZpN2Y3TTIyZHUzQTNla2dydU1z?=
 =?utf-8?B?WWdySlZvUmpFQ3I3aUphbFRHSGFaRXZXc29SZ2ZBMXNJWWpSZVVUakIrY3pN?=
 =?utf-8?B?VFQ1TTR2RXZYNWRwY1ptbUlpY05IMDdjWHpscHVuVXpuUzFBWFhQWmJEWnRZ?=
 =?utf-8?B?M21KOEhTNjlnMUFtMjU5YVZ2SmpIVmpRZGVmSGZGZzJFWE0xWFM1TUwrRlpI?=
 =?utf-8?B?YTdOZFIxNEt2RmpXaGo3NDcxQmdkWTJzdWV4WnNtNERBNTNIT3FhSjU2WnFU?=
 =?utf-8?B?YmNSd1Ryd2QrMFZKWjVnd2kxMUhPbGJEZ05ia2hIWDA4S0o4cjloZkI2RXhm?=
 =?utf-8?B?djJjUGVNeUlZR2trbXhQQVdFNmVYK0JJVHp1SWZHNlJBa2tKQTBFOWVyQTZB?=
 =?utf-8?B?eUNRWEtKVWNWNEg2TUVxNHlsVVl1dFNJbTY5NTVZRHVLbFFMdVg1SGpJckN0?=
 =?utf-8?B?dmVoMG02emV3Y3h5MVRVenJ5RWc5c2JCNjVSR0VrZVZzb3o1dW1OMXFNeDhp?=
 =?utf-8?B?MkZFNUF0QXE0TVZoNG9QYXoyKy9ZcTBhRVB5THpCdjdpUFRaQ1dBSGFTc1Ry?=
 =?utf-8?Q?4opuM5tk3NA77cFGMmQzh6mI75eCgM1e?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8109.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFhNSXRSRVE0NDV4K0ZpYTdSQWdxNEsyQzV4MS8rUlp4bWRCSjVJUFRzY1c0?=
 =?utf-8?B?OTgzYTBpcEN1Z0M0bHlNK2t3U01RRGZLcnRhMG1KOFZROHM1VnhpbUxwNUJz?=
 =?utf-8?B?VG1UYlQybnVWaGpNUC9uZnBPcmtTaWJjRnBiZ0hyMzdPelYwWVV2TmdjWGh2?=
 =?utf-8?B?U0c3a04wYkZCc0JoV0liWXpIVW5WdkQ1aXFBMmVTd0tYK1dvTWg3S09MeXNF?=
 =?utf-8?B?NGp0WHhVWjdremwxVWtVRDFld1ljeEs2aE16Z1hMdGhzYjd4TWhJU01TRFlt?=
 =?utf-8?B?MmJaQ1BtZ3BNSE5xbENuMjJ4Vkd0bVBGSUlJakxtd3hldDJNNGNDMHpBQzdU?=
 =?utf-8?B?RlFTdSt0eGkyd1ZHa1NLMGl4K01XUGIrdStBdFNldmlBNlJsd1JFTVAyVXFh?=
 =?utf-8?B?NFZVQ3RXQTFZWFVaUDZTWnZmSWc4bm9laVhtZzk5QkJtSUVBcGdrdTVjeXE0?=
 =?utf-8?B?WDhQUnVvdzZFZ3RYOHUvQnM2eThJVndtNEtRM05nNytLQ0ZJWklQS01XZi9t?=
 =?utf-8?B?UHdrUjlVNWFuNjQ1WTE3Z0lFTWZsK09YQmZ0WEVuTFZPK0dzS05ORm12bTdi?=
 =?utf-8?B?WkkvVm1hc1lVME1VdDJ4dUk0MlRsVnY4WWFCRkdZSW8vVW5KeEdERnR0VTli?=
 =?utf-8?B?SW1jQXRnemhDQ3hMVm56RTA3Q2ZrcGNGRlN2Z3kxdmJJOWk2L1o0aEtMS1l1?=
 =?utf-8?B?Z3hySUNBVEFXWW9PL0QvTzdJSGRhaVJNTXVQNmlQcVpnejU4T0ppczdjTzVj?=
 =?utf-8?B?ZVNZTTIzQ01sam14VWx0c3dERnhua0JXaGpPeWxlN1lyZTJpSHRjZzNkZ0Zu?=
 =?utf-8?B?bUxRZExUajF2TmtQY2tiaG15K0NtWG1CcVdydGRjS1ZCS3ZrSHFva0hGWlRh?=
 =?utf-8?B?K214VFRFOVJTa2oxY1lxcnZFTGtrSDNQbGJ4ZWs0cTdWUllRd3BXdVltdTF4?=
 =?utf-8?B?STRjUi9vMFZmVjRsNW5nd0FWMDB3ZVJnSU8veDNxWVJ6SHoweWJFWGF2WVIz?=
 =?utf-8?B?REF3QTVMSDA3UXJPNnFnY1ozQ0NnZUlDOTNWMjFid1NSd3RYRy95YUszdTBn?=
 =?utf-8?B?b0pTclhVOG9pSzRYblI3b2RxUXF2dDA1UUtjUHYrZUNqZklkMDIvYTJqL1Jo?=
 =?utf-8?B?K0JRQ0ZEOTB1QWJ5VkFETGoxbEswOE1NeEdWRG5GVHdUQ254NWsrTE9vMTA3?=
 =?utf-8?B?ZVRtR0U2ZDdMeFMrY3VnR08wYmpLRHVaOWZoMjZlaVRhV3RNR0lCK3NTWGFO?=
 =?utf-8?B?bVVOQWZGUHRrSGx3Ujl0a2ZnZmdRVEhNMCtTRGRNWHR2TkUrTWpQNEtPTzQw?=
 =?utf-8?B?SmtEY0VkS016by9mZW1JbmtPVnJIZk8xbG1Hb2lUT01oTW5FeklYNkw2ZHNw?=
 =?utf-8?B?ZldEUlpwcVRGcmNvQVFmTURMUDc4NHR5TXhKUjFURDFvdk41ME9ab1lOUE5O?=
 =?utf-8?B?L0M2NWFNQXR2ZnFCYmJhejNYMUtxY0ZEOURTVG5tMHdBenVWL3BXbWJ2eVJ5?=
 =?utf-8?B?eTIxRjBHWHU2b0NrWFM1UEd3dVlmZGlYU1dVY1B6bUs5TFdCQUZDSWluWDRU?=
 =?utf-8?B?cGQ2bGR2Z1VZeXVWQWlrMjlJY05hc1BiMXJwZmxGRnpFbFRVeWFoSWorZTJk?=
 =?utf-8?B?QnFpY3UydTVEKzVCdllhZEpyRmVZNUgxemFPd1h0TDVoNFBXRmJlOEYvZXEv?=
 =?utf-8?B?cFZoUWQ5R2p6cU92NnczclAvUTJUdVE0U3g1SWVpcGVCSzl2U2Fxb2FLdmVI?=
 =?utf-8?B?TEZ5dUF0Mlh4NUIvaUpTV2w5UWFtNFBTbHEvTVB6Tyt1QjVNdm5rZFF6TUpo?=
 =?utf-8?B?dStWWTVTOXlWU1pPa2NXWTFCbUh6RngwZFM2Y2w5V3dTbGp2dFBoQmxnZlNm?=
 =?utf-8?B?NEZyQ0RId2w4N3N3NEc3dGJ4SGY4akxPUDJxbktRbU8rQVFEcnpSaDF1akwz?=
 =?utf-8?B?RlM5MFFKUXlHcTZFVHl5bFY0YjE4eWdDSkxId00vdTNaNTI1TmxkVHBta25o?=
 =?utf-8?B?R0d5NWVpSmxvRk1ud0RSdWNBRjQrMlMrWFgxdTI4U2ZKYmJFQjhFRXE5STZl?=
 =?utf-8?B?OHN5eEdZcGo1TkxURkpINGpsaEEyaUU1Ty9WRlVZZXhhekZWcTJ0Zk1iUFB3?=
 =?utf-8?Q?WucamHaY+QEMUWH25RLNQ98/4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782d2148-8e50-4e19-789e-08de12062bf2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8109.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 07:31:25.1878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3PLJGhjrL+kpsnHgReMKQN0tot8BRAKaVm9C7EZkxVbEpRHZo96gI0RcYcDBWEe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9336



On 10/21/25 13:30, Ajay Neeli wrote:
> From: Izhar Ameer Shaikh <izhar.ameer.shaikh@amd.com>
> 
> Add support for a generic ioctl read/write interface using which users
> can request firmware to perform read/write operations on a protected and
> secure address space.
> 
> The functionality is introduced through the means of two new IOCTL IDs
> which extend the existing PM_IOCTL EEMI API:
>   - IOCTL_READ_REG
>   - IOCTL_MASK_WRITE_REG
> 
> The caller only passes the node id of the given device and an offset.
> The base address is not exposed to the caller and internally retrieved
> by the firmware. Firmware will enforce an access policy on the incoming
> read/write request.
> 
> Signed-off-by: Izhar Ameer Shaikh <izhar.ameer.shaikh@amd.com>
> Reviewed-by: Tanmay Shah <tanmay.shah@amd.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
> Acked-by: Senthil Nathan Thangaraj <senthilnathan.thangaraj@amd.com>
> ---
> Changes in v1->v2: None
> ---
>   drivers/firmware/xilinx/zynqmp.c     | 46 ++++++++++++++++++++++++++++++++++++
>   include/linux/firmware/xlnx-zynqmp.h | 15 ++++++++++++
>   2 files changed, 61 insertions(+)
> 
> diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
> index 7356e86..2422922 100644
> --- a/drivers/firmware/xilinx/zynqmp.c
> +++ b/drivers/firmware/xilinx/zynqmp.c
> @@ -1617,6 +1617,52 @@ int zynqmp_pm_get_feature_config(enum pm_feature_config_id id,
>   }
>   
>   /**
> + * zynqmp_pm_sec_read_reg - PM call to securely read from given offset
> + *		of the node
> + * @node_id:	Node Id of the device
> + * @offset:	Offset to be used (20-bit)
> + * @ret_value:	Output data read from the given offset after
> + *		firmware access policy is successfully enforced
> + *
> + * Return:	Returns 0 on success or error value on failure
> + */
> +int zynqmp_pm_sec_read_reg(u32 node_id, u32 offset, u32 *ret_value)
> +{
> +	u32 ret_payload[PAYLOAD_ARG_CNT];
> +	u32 count = 1;
> +	int ret;
> +
> +	if (!ret_value)
> +		return -EINVAL;
> +
> +	ret = zynqmp_pm_invoke_fn(PM_IOCTL, ret_payload, 4, node_id, IOCTL_READ_REG,
> +				  offset, count);
> +
> +	*ret_value = ret_payload[1];
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_sec_read_reg);
> +
> +/**
> + * zynqmp_pm_sec_mask_write_reg - PM call to securely write to given offset
> + *		of the node
> + * @node_id:	Node Id of the device
> + * @offset:	Offset to be used (20-bit)
> + * @mask:	Mask to be used
> + * @value:	Value to be written
> + *
> + * Return:	Returns 0 on success or error value on failure
> + */
> +int zynqmp_pm_sec_mask_write_reg(const u32 node_id, const u32 offset, u32 mask,
> +				 u32 value)
> +{
> +	return zynqmp_pm_invoke_fn(PM_IOCTL, NULL, 5, node_id, IOCTL_MASK_WRITE_REG,
> +				   offset, mask, value);
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_sec_mask_write_reg);
> +
> +/**
>    * zynqmp_pm_set_sd_config - PM call to set value of SD config registers
>    * @node:	SD node ID
>    * @config:	The config type of SD registers
> diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
> index 6d4dbc1..f441eea 100644
> --- a/include/linux/firmware/xlnx-zynqmp.h
> +++ b/include/linux/firmware/xlnx-zynqmp.h
> @@ -241,6 +241,7 @@ enum pm_ioctl_id {
>   	IOCTL_GET_FEATURE_CONFIG = 27,
>   	/* IOCTL for Secure Read/Write Interface */
>   	IOCTL_READ_REG = 28,
> +	IOCTL_MASK_WRITE_REG = 29,
>   	/* Dynamic SD/GEM configuration */
>   	IOCTL_SET_SD_CONFIG = 30,
>   	IOCTL_SET_GEM_CONFIG = 31,
> @@ -620,6 +621,9 @@ int zynqmp_pm_register_notifier(const u32 node, const u32 event,
>   int zynqmp_pm_is_function_supported(const u32 api_id, const u32 id);
>   int zynqmp_pm_set_feature_config(enum pm_feature_config_id id, u32 value);
>   int zynqmp_pm_get_feature_config(enum pm_feature_config_id id, u32 *payload);
> +int zynqmp_pm_sec_read_reg(u32 node_id, u32 offset, u32 *ret_value);
> +int zynqmp_pm_sec_mask_write_reg(const u32 node_id, const u32 offset,
> +				 u32 mask, u32 value);
>   int zynqmp_pm_register_sgi(u32 sgi_num, u32 reset);
>   int zynqmp_pm_force_pwrdwn(const u32 target,
>   			   const enum zynqmp_pm_request_ack ack);
> @@ -922,6 +926,17 @@ static inline int zynqmp_pm_request_wake(const u32 node,
>   	return -ENODEV;
>   }
>   
> +static inline int zynqmp_pm_sec_read_reg(u32 node_id, u32 offset, u32 *ret_value)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int zynqmp_pm_sec_mask_write_reg(const u32 node_id, const u32 offset,
> +					       u32 mask, u32 value)
> +{
> +	return -ENODEV;
> +}
> +
>   static inline int zynqmp_pm_get_rpu_mode(u32 node_id, enum rpu_oper_mode *rpu_mode)
>   {
>   	return -ENODEV;

Acked-by: Michal Simek <michal.simek@amd.com>

Feel free to take this via UFS tree.

Thanks,
Michal
