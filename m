Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9A6219A8E;
	Thu, 23 Oct 2025 07:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761204731; cv=fail; b=YLz816agz903f5vpHwFYzbJ2Zx68Wi61ujSUSk3OOlmFx7B2gScEg6jnwUXsMoPdlPoPUOECgMUCDUR8zrwRN7g/euKLok6m1Z2zHIRtRV0PfoNrdvSLiO3B+gDj4X7MA46PRR7K43GlCwXRkqbOaoYJIjbg4aBdD7VhQ5JcDWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761204731; c=relaxed/simple;
	bh=1WSW6cUV4zbSSMM9gGHWcfRuDUN49aQyru7YQU/mI48=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oD75TCWcUVQ/d3c+KBSB4TjEt99aL77gjgWIkYM9XI74KdqBUYRnqy+cVBiOMwu2jNJZnolBrKutau6g7CxVvwJGQ4czkmy4edUYj6wuIRfB+LCsYE78fCJ8FO7ZUwsOQQQhDH4NdMp2X0/H1IqujjIGQSQvwe3a1Ex3OsjZv2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NRQhGI7A; arc=fail smtp.client-ip=40.107.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NRQhGI7A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LyqoQNUoQkKQqIe3yEf2tjPFD/1UQ/y0IQUd0oaFggL6bajjmdwsgVhB5TlBn5IfiMYj0Ic8kw+1ShZ+4Ll+6mOMLKggYb8bniXJU2DCZbFW1URNrOC7m/26+4JnldWMloT8Zeowla0LYiddqLcYJGwT2kxzqflemxO3C4XMSqHV1VAPcUpIN5qv0xmMGSkUSPhh2Aa/nATDSVyO0lflro5bzi9WyqqDLSOmC2iF43BdRN8zdNZSOwJkurf941xxRiolaje++hhPknGFBW1qnjlz2Kw/9l9ZabO5fz9L+BNIOYssGALmQ8zFlbcAP7WhuCzqIgcCVrtNflBSOCQlWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fmxj4PQRobuBdngIKVqDKQ7LjVbdQsTh24ZJ7HsKAfE=;
 b=RI+E6DguvnpO6SQRRVzyWOaFfUKO5PtBQLQNhaM3elQYoUJ+hsmwiX2JA54m+w7PrzwfeCWpjm1iHVT7pMEjOhHw3RgTGr4SUTYCU6xUgpM6BV7lL6uRcqkndKIRtTBnLouVwowManBHb2omElsOlQcGzXgexs4D0QeDp+cFJyvkShrXqWaSaPe329DDSmsFfvPRN+RYNoPZeetGoy2lG1hMq6FDq16LMF6HTW59u35n9aJc7Xqe4mvnlk9qIh1akVkvdclj4CCBbRHtaEGcaZBDHAm17StM+GPRA1LtDNuUytZ8gnh/zRZ+ijpyaxi/IXaLVHJs+MxzWDPypZwjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fmxj4PQRobuBdngIKVqDKQ7LjVbdQsTh24ZJ7HsKAfE=;
 b=NRQhGI7A7TnBLZ9SJPQzvK2A+q4ZY/mGABlaWA2TCqibmaWGbQpn9IomPqHKKWPcGaXrZk7/BsGGxxUMwLxvcaKBFhXTwpTmy5lAAwKTqOZmQKCYOqsT0N5MuQ0zhud0ZKsEAGzMECLpzWTaTYoS5bYsuEmm+idFrlbyXV5kSVk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com (2603:10b6:a03:4f5::8)
 by LV8PR12MB9336.namprd12.prod.outlook.com (2603:10b6:408:208::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 07:32:01 +0000
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30]) by SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 07:32:01 +0000
Message-ID: <bdb1f667-8a93-45ca-aaf2-535c914b283f@amd.com>
Date: Thu, 23 Oct 2025 09:31:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] firmware: xilinx: Add APIs for UFS PHY
 initialization
To: Ajay Neeli <ajay.neeli@amd.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, pedrom.sousa@synopsys.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, git@amd.com,
 srinivas.goud@amd.com, radhey.shyam.pandey@amd.com
References: <20251021113003.13650-1-ajay.neeli@amd.com>
 <20251021113003.13650-4-ajay.neeli@amd.com>
Content-Language: en-US
From: Michal Simek <michal.simek@amd.com>
Autocrypt: addr=michal.simek@amd.com; keydata=
 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
 mpwx1d8=
In-Reply-To: <20251021113003.13650-4-ajay.neeli@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::17) To SJ2PR12MB8109.namprd12.prod.outlook.com
 (2603:10b6:a03:4f5::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8109:EE_|LV8PR12MB9336:EE_
X-MS-Office365-Filtering-Correlation-Id: 4113311c-a699-4f4f-1361-08de120641a6
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3ZncmE3ZVNCMlg4cUw0KzlzOE5XZkpLYkx0QzgvaHZnQ3R0Z2VrMG9wdzVn?=
 =?utf-8?B?UWdNMHh3ZG5pVUowZFhWUGlSdFRVM0x5b0YzdW1uTFU0TlU1Tk41SzEyc1R6?=
 =?utf-8?B?eFMzSys1OTZoaC90akRpWkdndVE0RGtleGVqQ3JPNWNSYm9tV3hpcnpKcVR2?=
 =?utf-8?B?Zm96blZuQ3cxejNjSzJLSGg0L2Z0K1JKN3ZHTVhTaDc3TitYbnJTSWswc3RW?=
 =?utf-8?B?UTVvOVlBa0hVOU5TSFE1WHhCWTZEcStOVzVsaXJDNm8zZDJDcEs5K2o3L0I2?=
 =?utf-8?B?TjlSeEtkelZUaGdMbmlaYndtWUk3MFVyMGZ0c2ErZXhxUGQ2SzhNRks5dXBu?=
 =?utf-8?B?THhSa21oQjNmU2s1ZUdnZkVvY3BZY081T3JuYzRWYXpCYm5zYk5vYStBb0tT?=
 =?utf-8?B?dEpySUhOOHZyUkJZNUs4R0JmMVF5WFB4QnNMVWUvbkdVY2tjSkJ0Y0ZhQ29D?=
 =?utf-8?B?dUdldUJXVkJ0WTZ3TkJ1Qy9BT0lJbjdpeGlrZHVOY3FGcEg3QU9FTGJwR0Vw?=
 =?utf-8?B?c2gwMVRzais3TGhPS0ppOVVES0c4Vkk2ODBSWW5uUHhFZmVheTZNVnIrc0pI?=
 =?utf-8?B?KzNJL0hKOU95UGNoWC9CR0FweHVJNFZwaDlIa0VWV0tKRlhjYUZqak5oZkdD?=
 =?utf-8?B?aTVtWmpCLzVwL2tjdU5PZFg0RGd4SmVpd1ZMeXFVY05CMGRBUGIrRkdMdjVJ?=
 =?utf-8?B?dlA4ZXVJSGtnZElPTFlHUzVxSGJKYVBQVEtFU3E2T3o5Zk5UWVNDQXZlMjI3?=
 =?utf-8?B?UlhGcXRMd0xSdDh6OFFaMzZXSzhVRHVJL05IaldTcmZSSStyWk9qVzM2ZVJt?=
 =?utf-8?B?NjBLOUZBNlQ0VHdLQ2NmUXJiNWF1Wm9OMy9UWDZvaC83MGNZWXFDSVdCRHdD?=
 =?utf-8?B?US9zdHZzRDJnMEM2SzdvY2VRY3hwNTZIYTRvc09FNG1sQmNaTStBV3JWOFdO?=
 =?utf-8?B?d0hlWk1YUU5kejcrYnNuSVNGUzl0M0xLMk1JdFlMeStNWU1HOEdvL0hCVGZN?=
 =?utf-8?B?dkFTTVliUmlKcURtU1A1TWxVNG44S1gzQ2lnMndld1hTREtkMC9NL2hmTVBB?=
 =?utf-8?B?ajRHSktNN0o1b0dDU3JpZGxJT2szeERMQ01nUXRaWUFINEMyWkRQZWFDcFh4?=
 =?utf-8?B?UGpjeXNrcmNzbnMvRjlReVBKbGFtSFBJQWllK1UzYVJ3Y29kZW9GT2x5dk00?=
 =?utf-8?B?R2xWell5Kzk4VXlXOHgyRkRZb0RzMWw4MDhqVDlVWUNqTURrdFhTYldYY1pI?=
 =?utf-8?B?VmR2UmVWdTJleFZIQnIySkRXbkg1YWlqaHF2UmozUU1yTmR6WHJEdkEzNzdN?=
 =?utf-8?B?dXlwNmQ3Rjl3Z05HZ3RPNVNjaHlVMW1WTEJUTHlkZjlVK0JidUdURlV4ZmZY?=
 =?utf-8?B?ZnJHUE43NDQzNk9jeGtuMlMvb2RuUmV2aWpEdjRxUWZvc1hnbU5QQlIwREpY?=
 =?utf-8?B?UkdMeVBlY0gxVTUzcUlwVlJWNExlNkpsd3RwSlZSL25KWWFIZVZYZ3lXSWdi?=
 =?utf-8?B?KzZXdFUrbExleStBUWJtMENIYW5iR0lxWnRYMWVKN0NWem1oSFVJaklXTExX?=
 =?utf-8?B?REVubzR2NkZsaHhrVkZUREdCNXUyQzNPZVpLdnE5U0NlTEJuUXFEeTZNVjZS?=
 =?utf-8?B?MzNwdFAvUVF2YU4wcFZOaGlsNXd1eUFVWDRvcWZvZi9nTlRyRTZQSnExazVa?=
 =?utf-8?B?akYvSmhhMHFKTWwwUHh6VFF6Qy93WHlwS2hJa3VMc0JvK2poTGwya2RCTm5W?=
 =?utf-8?B?NE5Id2RsUUtINnpWUVJqZVM2RzYrQWdvaXI1L1crSTI5UmxhaDlMTzdHdkJ6?=
 =?utf-8?B?dVU4NVZXcjRteW5IdzdXK044QWNYSUFPWis1dExOM0FMNFA5Q0xqWFJPb3A3?=
 =?utf-8?B?WGNLeDZKVHVoNW5RSW5VK0EwVDEwc3hyTVBlVUpkL2RTTU5wQzNyRUE2NXMz?=
 =?utf-8?Q?L1KJDa28+SjF+ErXl2GHKvI8gGbln2xT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8109.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VE5vczlWcUlhL0tBQStzcEhWRHk0emdlallYYzdYOWZSay9FRzUzYWRXT2M0?=
 =?utf-8?B?UXhUWHFJSGhuTHkrYjU0clczZVBEc2hnWEFaS2Q4d0VrUkJuLzNGM3NwZmdz?=
 =?utf-8?B?bUdvMkYxcEZqOWxqVFhWS2RFWG1TS1pKeERWY1EzbnBpd3hTSDVJTkZ5R0dI?=
 =?utf-8?B?TVB1NlhPeUlVSjNFSkhXTXd4M2J4d2gyeStnTXB4dEZLUzJoeVBreERVdGc1?=
 =?utf-8?B?QUtoaHVGQWZPbDJmenRFYkZuVjdvU21iS0NBUmY4OEx6aTVSUE1PajFrMXda?=
 =?utf-8?B?cXlnd3JkQ3d6UG5VN3FJNHNlVzVmS2cybFRtZ1VBODRZUE4xUFdTQWVhS1ZO?=
 =?utf-8?B?MDhiMXZhOTJWU29QYjVYQkNqbGNMMzZHR1Y5WEFoL1hhUG5zdXJxNzQxOUZU?=
 =?utf-8?B?UDNtR3lZTThtR3dlT2RXdDkxTEFSbVBvU1FYbWorSFVKNVBlM0NBdWRYaW9r?=
 =?utf-8?B?alhNVjRGbERiV01JQTBUM3A5U0VYMzdzSDlIZ2x5TUpUMC92Zys0cHJSQWND?=
 =?utf-8?B?clNDYmlFT1Z1RS8yZVdNdDhxZGQzZmh0ZGhmOEU0ZXIzUnZVYzdvK0p1bmxs?=
 =?utf-8?B?c0NtMU5FNGI1TGZXRC9VeVhpb1lwSlZpa2VrcGhTdFZCYWhVc2U5WWJEOGxV?=
 =?utf-8?B?YTFNME5Jc2txdjNiZ0l5am1TcWNLbk1ueTV6RjEzdWxWcm1xWFc0ZS93T3FZ?=
 =?utf-8?B?UlhhdkVEbElaQW0rbFVMcEFuaTZvWTZ3NDZBek9pM2t1NzdNYWhlZmVGYllu?=
 =?utf-8?B?bWhNU2FQbW9sRHg4MXp2NFZ4d1lwaDExdkErekorN202SmVwWWNMZXJOaXBW?=
 =?utf-8?B?bnRYR2xOaHRHRUpIdjMzdFhuMzk0SmppbStJNTNqRDVPQkFrNnVtOTJhTlpo?=
 =?utf-8?B?N1RiaDhxeU8wc3ViTlovV3NZN2dsNVA4K3NUSG8wd3l1QTVnZ2xvOUhSUDhh?=
 =?utf-8?B?MUw5WjRZZVIzL0hyRDRkaFl1bnZQOWZENDhNR3NXMzVVY0cxdTFnS3BwMkdi?=
 =?utf-8?B?QXpTcXpIZjI5Q2F0RDNJbHVkaXNIcnRKSUlHSUp1eXZEa2Vnak10Qmc1bFBW?=
 =?utf-8?B?SzdEZnE2NmNtdU5FUUZyRFhRYTVWbzFwdjByVXFGZ2U2bUF1aXJ2Um9xZGNj?=
 =?utf-8?B?YThFY3Y0ZXo5Yll6b1gzWGROcUVCRVJhQ0JHK3p1d0xSMkhqU3crMnZRT2Rw?=
 =?utf-8?B?MXdiV1NkQmlOSzNsa0F0NGNwcmZmMktKSDVjaHJQaHNyU0hrOFFuSXBWbVB6?=
 =?utf-8?B?UjdtdDNjUkxtWG5YUjRkZWIwQkxpMEZIN1k0MDhvNWxxZjVlSHFINjZKd08w?=
 =?utf-8?B?b0l3NlZGeThpOHdVWjFtVDRhWFU5d2xZRVdBdzRHdi9VT1g0VVBqOEJzK25o?=
 =?utf-8?B?MWdiQkxmdXNZNDB3RXJkOVlISzlRRDFtU3dBYVlHMU8vMDdLbHFEUy9MU29Z?=
 =?utf-8?B?L3JWemlHejNOZzNPcTF0aDBHVWV4MjZwTVZGQjFWbXFuVThQYVhvUWJZWU1a?=
 =?utf-8?B?NXB3bCtSWkEyazJKWWxNbEZsb1dYd05PbC95YmlsNkFTM2hDUDdVbjNLV2Nx?=
 =?utf-8?B?RmhlUG9jTGNIWW52d3dYTjN4R0ZpNGlrVVVGUmJPMDgxOEc3OExPL2o0OEor?=
 =?utf-8?B?MUlTREpJN09lYWF3R29YY01FN2lYK2tzMW8xM0dhcExOUU5STFowWjlEbm5H?=
 =?utf-8?B?TDRXNG4zQ1dUbCtvNWY1cHR6ak1ZU2d6UFQybjhUd3RrQ3crWjk3a05RdDRG?=
 =?utf-8?B?SnlxVG1XWm1SUVpFc2UwTFFKN3NpaDFjTURzYkVXR082K1JuUHlsSU52cXlL?=
 =?utf-8?B?a2R0eGZCbU9oOXQrSEpaeGV4bExSMmNCSCtySHRMS0VMWTFXSDdQYi9UU1Ja?=
 =?utf-8?B?RmNRdTdDQVhnOW5EU09LTUZqTE5yU0w0VndjL01PbTJLazJ1OU9VTmhCVXVs?=
 =?utf-8?B?QURSMGx5dG1zOEpHWkRXa0wrT2x1LzEwQnh5ZGphWTRyK3VZQUE2bC8yamdo?=
 =?utf-8?B?clo5UWduZzNNVkY5OXpyRGVGUXF1alFNbDkrVnBHclZ6L2dvOStHYlVPV3dt?=
 =?utf-8?B?WUFpTkU4L0xGbldVZldIdzJtS2w5aXBHWk93VDNUQkV2R083NFRGbk1DR0tG?=
 =?utf-8?Q?BaeRCTiX1BV6u7CWok/ZqF++1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4113311c-a699-4f4f-1361-08de120641a6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8109.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 07:32:01.7325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwH3qxxrPRcbwL6thYYT59/HFYabYRx6EPSS31FH6aJUkhYwgSXRkmJgDDI1LjKg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9336



On 10/21/25 13:30, Ajay Neeli wrote:
> - Add APIs for UFS PHY initialization.
> - Verify M-PHY TX-RX configuration readiness.
> - Confirm SRAM initialization and Set SRAM bypass.
> - Retrieve UFS calibration values.
> 
> Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
> Acked-by: Senthil Nathan Thangaraj <senthilnathan.thangaraj@amd.com>
> ---
> Changes in v1->v2: None
> ---
>   drivers/firmware/xilinx/Makefile         |   2 +-
>   drivers/firmware/xilinx/zynqmp-ufs.c     | 118 +++++++++++++++++++++++++++++++
>   include/linux/firmware/xlnx-zynqmp-ufs.h |  38 ++++++++++
>   include/linux/firmware/xlnx-zynqmp.h     |   1 +
>   4 files changed, 158 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/firmware/xilinx/zynqmp-ufs.c
>   create mode 100644 include/linux/firmware/xlnx-zynqmp-ufs.h
> 
> diff --git a/drivers/firmware/xilinx/Makefile b/drivers/firmware/xilinx/Makefile
> index 875a537..70f8f02 100644
> --- a/drivers/firmware/xilinx/Makefile
> +++ b/drivers/firmware/xilinx/Makefile
> @@ -1,5 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0
>   # Makefile for Xilinx firmwares
>   
> -obj-$(CONFIG_ZYNQMP_FIRMWARE) += zynqmp.o
> +obj-$(CONFIG_ZYNQMP_FIRMWARE) += zynqmp.o zynqmp-ufs.o
>   obj-$(CONFIG_ZYNQMP_FIRMWARE_DEBUG) += zynqmp-debug.o
> diff --git a/drivers/firmware/xilinx/zynqmp-ufs.c b/drivers/firmware/xilinx/zynqmp-ufs.c
> new file mode 100644
> index 0000000..85da8a8
> --- /dev/null
> +++ b/drivers/firmware/xilinx/zynqmp-ufs.c
> @@ -0,0 +1,118 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Firmware Layer for UFS APIs
> + *
> + * Copyright (C) 2025 Advanced Micro Devices, Inc.
> + */
> +
> +#include <linux/firmware/xlnx-zynqmp.h>
> +#include <linux/module.h>
> +
> +/* Register Node IDs */
> +#define PM_REGNODE_PMC_IOU_SLCR		0x30000002 /* PMC IOU SLCR */
> +#define PM_REGNODE_EFUSE_CACHE		0x30000003 /* EFUSE Cache */
> +
> +/* Register Offsets for PMC IOU SLCR */
> +#define SRAM_CSR_OFFSET			0x104C /* SRAM Control and Status */
> +#define TXRX_CFGRDY_OFFSET		0x1054 /* M-PHY TX-RX Config ready */
> +
> +/* Masks for SRAM Control and Status Register */
> +#define SRAM_CSR_INIT_DONE_MASK		BIT(0) /* SRAM initialization done */
> +#define SRAM_CSR_EXT_LD_DONE_MASK	BIT(1) /* SRAM External load done */
> +#define SRAM_CSR_BYPASS_MASK		BIT(2) /* Bypass SRAM interface */
> +
> +/* Mask to check M-PHY TX-RX configuration readiness */
> +#define TX_RX_CFG_RDY_MASK		GENMASK(3, 0)
> +
> +/* Register Offsets for EFUSE Cache */
> +#define UFS_CAL_1_OFFSET		0xBE8 /* UFS Calibration Value */
> +
> +/**
> + * zynqmp_pm_is_mphy_tx_rx_config_ready - check M-PHY TX-RX config readiness
> + * @is_ready:	Store output status (true/false)
> + *
> + * Return:	Returns 0 on success or error value on failure.
> + */
> +int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
> +{
> +	u32 regval;
> +	int ret;
> +
> +	if (!is_ready)
> +		return -EINVAL;
> +
> +	ret = zynqmp_pm_sec_read_reg(PM_REGNODE_PMC_IOU_SLCR, TXRX_CFGRDY_OFFSET, &regval);
> +	if (ret)
> +		return ret;
> +
> +	regval &= TX_RX_CFG_RDY_MASK;
> +	if (regval)
> +		*is_ready = true;
> +	else
> +		*is_ready = false;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);
> +
> +/**
> + * zynqmp_pm_is_sram_init_done - check SRAM initialization
> + * @is_done:	Store output status (true/false)
> + *
> + * Return:	Returns 0 on success or error value on failure.
> + */
> +int zynqmp_pm_is_sram_init_done(bool *is_done)
> +{
> +	u32 regval;
> +	int ret;
> +
> +	if (!is_done)
> +		return -EINVAL;
> +
> +	ret = zynqmp_pm_sec_read_reg(PM_REGNODE_PMC_IOU_SLCR, SRAM_CSR_OFFSET, &regval);
> +	if (ret)
> +		return ret;
> +
> +	regval &= SRAM_CSR_INIT_DONE_MASK;
> +	if (regval)
> +		*is_done = true;
> +	else
> +		*is_done = false;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_is_sram_init_done);
> +
> +/**
> + * zynqmp_pm_set_sram_bypass - Set SRAM bypass Control
> + *
> + * Return:	Returns 0 on success or error value on failure.
> + */
> +int zynqmp_pm_set_sram_bypass(void)
> +{
> +	u32 sram_csr;
> +	int ret;
> +
> +	ret = zynqmp_pm_sec_read_reg(PM_REGNODE_PMC_IOU_SLCR, SRAM_CSR_OFFSET, &sram_csr);
> +	if (ret)
> +		return ret;
> +
> +	sram_csr &= ~SRAM_CSR_EXT_LD_DONE_MASK;
> +	sram_csr |= SRAM_CSR_BYPASS_MASK;
> +
> +	return zynqmp_pm_sec_mask_write_reg(PM_REGNODE_PMC_IOU_SLCR, SRAM_CSR_OFFSET,
> +					    GENMASK(2, 1), sram_csr);
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_set_sram_bypass);
> +
> +/**
> + * zynqmp_pm_get_ufs_calibration_values - Read UFS calibration values
> + * @val:	Store the calibration value
> + *
> + * Return:	Returns 0 on success or error value on failure.
> + */
> +int zynqmp_pm_get_ufs_calibration_values(u32 *val)
> +{
> +	return zynqmp_pm_sec_read_reg(PM_REGNODE_EFUSE_CACHE, UFS_CAL_1_OFFSET, val);
> +}
> +EXPORT_SYMBOL_GPL(zynqmp_pm_get_ufs_calibration_values);
> diff --git a/include/linux/firmware/xlnx-zynqmp-ufs.h b/include/linux/firmware/xlnx-zynqmp-ufs.h
> new file mode 100644
> index 0000000..d3538dd
> --- /dev/null
> +++ b/include/linux/firmware/xlnx-zynqmp-ufs.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Firmware layer for UFS APIs.
> + *
> + * Copyright (c) 2025 Advanced Micro Devices, Inc.
> + */
> +
> +#ifndef __FIRMWARE_XLNX_ZYNQMP_UFS_H__
> +#define __FIRMWARE_XLNX_ZYNQMP_UFS_H__
> +
> +#if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
> +int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready);
> +int zynqmp_pm_is_sram_init_done(bool *is_done);
> +int zynqmp_pm_set_sram_bypass(void);
> +int zynqmp_pm_get_ufs_calibration_values(u32 *val);
> +#else
> +static inline int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int zynqmp_pm_is_sram_init_done(bool *is_done)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int zynqmp_pm_set_sram_bypass(void)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int zynqmp_pm_get_ufs_calibration_values(u32 *val)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
> +#endif /* __FIRMWARE_XLNX_ZYNQMP_UFS_H__ */
> diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
> index f441eea..604a03f 100644
> --- a/include/linux/firmware/xlnx-zynqmp.h
> +++ b/include/linux/firmware/xlnx-zynqmp.h
> @@ -16,6 +16,7 @@
>   #include <linux/types.h>
>   
>   #include <linux/err.h>
> +#include <linux/firmware/xlnx-zynqmp-ufs.h>
>   
>   #define ZYNQMP_PM_VERSION_MAJOR	1
>   #define ZYNQMP_PM_VERSION_MINOR	0

Acked-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal
