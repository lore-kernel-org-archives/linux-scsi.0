Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7D93ED5DC;
	Fri, 22 May 2026 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779451216; cv=fail; b=FFuB7bOsbkkJYtNaOIFHNovTu8ikDz8J7AIfXvO0BGuB3UKn6lNEh3K4nH9Gr019PlJm0TJo7V20/6dqdQ4/9FTvN+enPLZJEThA6k6XHq7AmcmWuYyZqbs4ceDGbBGb4oI+WiGiolrTNpylbuIIwKC5raBp/PSNrNf32i34um0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779451216; c=relaxed/simple;
	bh=qVGxoTahdlG5XdsykVDShd6z8JXMRztZkogxxfQC/BE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qcCa/bU0ldlNFICQZibCMiOlVG0IY0swYnWz4tBYDzTgtZlM/kf1Co8ttJW1qT8mvsEjP8QQVAhjr/VCfCfyoJew6YAuOB4PFh1FpOr8oVxbbKlacjCEDFC69asQLv3rN4yQbhFWYy1yIMVS4UvpI/MNebwpjnl6jSzsZsMr7oY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gpehkV2k; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ApFwjjqA; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gpehkV2k";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ApFwjjqA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779451214; x=1810987214;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qVGxoTahdlG5XdsykVDShd6z8JXMRztZkogxxfQC/BE=;
  b=gpehkV2kZstQ3vdT54+u8eDCW4dlv8LBwVoZtVT41EwZy75Lely1RpqJ
   6/au20mJXWGJyzVCoFZ9jWWgmo01M85xSkA3GgX0wfzYWmukur+jOQbQ/
   rK1PlbmwB8ZP6SOyznzKUK1r0wwB5yBlEgMY7otkS8bGMl5ROdGJuPXgK
   rwGaqz0c3xzx6bo3iFisHVgN/pbBXhOTlH6ealFskDShiNZck4JbJrDqk
   3bCBxdUjwiAqEhVK0xX7B3i8/EsQOWLQ4gYVokOjivS5366f2snqBeonB
   GewPBtX5NCIluQ/mY/xWLbQAcKJHS1foFnEMJmEsWY6mE4nfT3u7VW+N4
   g==;
X-CSE-ConnectionGUID: kx0kKwwmSAWirM7VA1ZaiQ==
X-CSE-MsgGUID: gKvXf7SNSCqzukvIqdET9w==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="scan'208";a="148311278"
Received: from mail-westcentralusazon11010044.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 20:00:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEq5PJkLZW1V2wbM6l18b4BprzhUDeNpSLOfnNoxMAyEU9lvKG9poJLLeVg3Vrn1tj6K6468RxOsfksBrNboxy3z/9dIvo45w66Y8Wo8Ct9yFr2Pz9sHHEfv14HUGvEsr5/QAKbw7w2VkYhGmEyh4KIK4iO8pl2k1RVqbeE8uANt0b6o2xkgfoTpOF1g5Xt6YK/675Rl+GwaJhXf1SHxC+4rkwnpOZ0kM5nfdueZJRBtj2angrKp6AYWRTcG/Ci19ARFJUPMLdsVMzOmhptcWHSHHAh+bjOgviD4N3rWmI5VPU18/AUvj7HJSztRiCfN7lszRPdYMueHVLTOBYIALg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YftXsSouA3Eud3B2D760OjsxLkS38Ra5BFXQa36zDI0=;
 b=KE835eAGwOlANyFfpjYogeeZzscEtPN1tWBInCu8WcXeUWyKa7vKDwsZzrXFN7mKHD95WtRTGMf1I/99yqjSKEmxMcyqk6Nbv/lGTrF+giH3t65hW3chAtsoIBBZFxcSD9cwTCRTR3yeVcYWQ2hiBWBElEOVvmy+/W73z4yki1OYtpejpTLIPtrZFrzMAM+GhrcP4R1j8NGphJ13JHbeNclEm3hkM9uP91pWRC6X9iNatHr0nKJLDe7PdOZdVQCxUJhV7fAMUg/51ZZCLDgo52KjvowE642su5VpnLGoYBM5S0bzNY/fAMn5A61X6EG7hQf+jq3Y08eMNq5LDj+kTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YftXsSouA3Eud3B2D760OjsxLkS38Ra5BFXQa36zDI0=;
 b=ApFwjjqAqkmyVOreDC3HAWMf2UWLv1WVUkgP7xg6958Y3dHQLn0m63oHEhcMqAPXDn8L5pBWIltkZa/k3oNynMZrn9RIUCL98ScjBNIuVpTjHRoiI0miSgGZY1KJwLCBKKBTkCarZZgh4kIV0Y1k3TB4AyCPtxaevMYAB4XDCJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by DM6PR04MB6573.namprd04.prod.outlook.com
 (2603:10b6:5:209::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 12:00:10 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 12:00:10 +0000
Date: Fri, 22 May 2026 21:00:04 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, 
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH 00/12] Block storage copy offloading
Message-ID: <ahBD9fRrPDuoB2cj@shinmob>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
X-ClientProxiedBy: TYCP301CA0020.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:381::13) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|DM6PR04MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e03097c-40a7-4224-d0c6-08deb7f9aca7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|11063799006|18002099003|22082099003|3023799007|6133799003|56012099003;
X-Microsoft-Antispam-Message-Info:
	yWgIPUoHP2aHC747fTyLzruThgfgp9Nw4EgIKLdKS5FolTlsvFCFIxmxAaPVcHGKhRr7X7Utpg7f8TAYRMRYiuYeT+aDyWRk4jg9uoIpdvK+DGk2S7rp/0PF1yiN/FJslUNtidGJMAt61Qw+HK8h8IrDW2Y0A4L3wTqkT3+jpv0ImGqUxEsqOAT8FehTjAUE8CIlJNbgE/gqFnPeqxe978MdlHOV8WPewAZfhIF2M1HLuzZFBOBd980plsOpRsNryAILVNB9+UaLla/OEH460D9QpT6wevFXSPzrUr+GvPrkcsCmZZAKCCeRHJ9foSYH2rGQsLRcpwLuW4z6DR1dayRBwoNmUtKHO4oG6KVhsy/NDC9dW5/6sU0c126Qw7wQi4iIAoGNXJ7NaYqlC7solxTot7ua1VSppFtCCeNcNwOGuQR3VhfwBsfqe2tHwkd0NnKahfCGmO1ErbQBH8mZBvqFDdXCJ0YswnyeWPWB89LmDWbXaOVVTL7vrT67FQT+YeY0CANywgpCIK4t3MyZIQXJj9AJDIHVAls3VpfAdGlY7bEj6sPdp231VoJUN242tk0DF4KfoeAt8uG2C+Dxql3XHThY4cGnWGqQwc3RawARcd8BtQvE9NmUlHfClLx9fgElHuQnffvADPyQn+JFvEwqXdlaka2XWWfMmFf65i0MaRUOk2EmOCdK4pgXTGEgPBnaa5qsWR8QXUSaR32ekg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(11063799006)(18002099003)(22082099003)(3023799007)(6133799003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gsaiEOIrvf4q6Zg431DWQxYELRBbhfZ/0+9QU/pd64sDOLRfYL+8Khalt90M?=
 =?us-ascii?Q?KwgtZMjDgkspid4ID7qdOUx/rcq9aOMUSSWC9KLzUIysnBf7klP8F/DZm2Uu?=
 =?us-ascii?Q?FA7EsCMSFHZVBSVbozLQ4UFCWUR4uujoFCcenRXSwlEzeI0lhApm6M5M2Ye1?=
 =?us-ascii?Q?a/I40o0lEVGZFcTORB+sAVewoWPVtsWrPyX46VkDgoEhvUW+obdAYB8bQS+f?=
 =?us-ascii?Q?3uavp692T0DIUq4fv4PxTFiwyDGHry/nt8R0SK9d3DG44NbPMb6+Qm81m+Pe?=
 =?us-ascii?Q?qMCfmsdOwidlBxqi0Lr1X5D5uDA7lCqviad/Xw/t0rNW59pDDqsw3Zzm4q0O?=
 =?us-ascii?Q?uSSMY5clDVQJgybl9wYQrn0l1RPJbSiobA4IfMkV50/nxYR/WH+xYCYjGeci?=
 =?us-ascii?Q?oggIFWXYB8OUHkBxum0IG5qv0mfJBUsFaHlUM9fLTMnz4szDDv66EgFN6I1z?=
 =?us-ascii?Q?CuNP6//O6oKY/pbReoKxjORXZ1/ll/EgCicZlLYxaMIYja51HLkHShfhL/xY?=
 =?us-ascii?Q?f6JeaqMtZUbdFD+/FpjvK9bMvCTczoq77tHq5yErk52j38dyNipqT28rpPlg?=
 =?us-ascii?Q?KvywgDQAe7oBmrG+Llc9BIA45CqkXvEpm0Bu0oP8JRg8oFOGhOUYygQYfwKE?=
 =?us-ascii?Q?/hfEdRGBeYmKaUs8vGU3p9d/Lqy3v7TCJn+NWX54CRn9lPjX5pbfSM4Actl9?=
 =?us-ascii?Q?6eIpxYmoCbqer3/lO6no06aXBGRX3L3jmc/s1gGW18gTh4L+g7CjOJt2RYSy?=
 =?us-ascii?Q?bfut+nRtxRLgokOt5jNXR1pKb7nSAE297/Ume7JShCYqEI+8bmnJjRriFK3W?=
 =?us-ascii?Q?4upIHcdVRQ1aJAMQv6mpErrVF68MGd5XjdkgtCLeWntCEQ0sfswaN5D/886+?=
 =?us-ascii?Q?QjtU8VZ6+wxlu0jqjoL3P5rq/VBf72mL+FBg6XAjzPlkR5/lGkELkgRaHOnL?=
 =?us-ascii?Q?39PHT3mFPL/7etzNL53/aDkFJMVdonf41PGug5DHsoQH5cXYjr7Stf+4nPTD?=
 =?us-ascii?Q?vRz7XRMXsjYMR/PaPELcG+wBWfKoaEkqFGPkBqSM3eFaAHdRa98QJtvjYu55?=
 =?us-ascii?Q?fr6l5cH3E1U5YJESCgQ3YMwXgE+zJa6vHyC10c/YftfefVO4fjn2TojacBnP?=
 =?us-ascii?Q?WSFJWeVygxhnQLLv/J3B0OPn8680EZ0iVQ/tbvMB1LyYb5uzaZpuiKajE7V9?=
 =?us-ascii?Q?8ZdIsm2jBe5H2I8InyuvQD9tPhpBwp30CBkCztj/z0LhCEtyi2xxRfu7HDhZ?=
 =?us-ascii?Q?TSaO4cx3sfapU0QLxEZHwQDuahHPr/ulJCS4hsJ0BvVvWMVtVSi973l79rQb?=
 =?us-ascii?Q?bhpO30IaYgqSeLFpVyqGh9fm9U9ba9g552/isrhPKpHPSTKCSw3FYa1+bY+8?=
 =?us-ascii?Q?pFbJiyvN7bYOWHBwvNCvzTOLmhi5jLuXXYN9+7vRjJtoCpRHIuIKE0vqW0+Q?=
 =?us-ascii?Q?cxeTVXH8ssVJzR5Ku5zGGerRzeBftVuFTyNkn6o8TTtrh4+cDcl7uJPj3QW+?=
 =?us-ascii?Q?ZT4+DM2I7O84m2ODyLygjjJbUd7tcawPij12RW6/7rUA4Wy2JUMLCIjFTBz4?=
 =?us-ascii?Q?wZh/mLPBpwY4mZz2jnN388g3LR547MMUoQMZeRdw31T26kjvVYN0M4ew1tQI?=
 =?us-ascii?Q?WVmkhKCizmVBw56BJzvvVLU8s9qcCjxhvxvqtpPqIgAFRUUkNwWk6/NJwcT0?=
 =?us-ascii?Q?QlVtNl+zh8zAXDooQHLyiwj8PW0MHM8KRZaW62FMkDIRwUl6wqnw/95Vk951?=
 =?us-ascii?Q?4GwUXo/iknrdebZzbYy3IsLD/LthNLc=3D?=
X-Exchange-RoutingPolicyChecked:
	oWY/z+tk6BBFfS9OdWtzT9OowISxEha+gAbJctHWW8XXlxy0mftsTtoz/Dj7TRm5zQL611i2eruLX14vM5LqjKRRR0YF7znlF7QR816q0IVFJvI7aMn1SeR9gOqCIHnviRX70KIM6clEElyGf/t+HQa6W+LG6/4knauFZzepRVMJJwVBlXv+6MwDVRVCfE21WRttng/jDBohCDYPjPca66zF5L9WE/ItgVdNjJc/fd+Llvk6fwnEhK/iRuynCFwNxKLXKnumojBdjDomWoJK6wvHOtstkdMCiqSZy15hyUebmxtYaqXN0Wdjb3h83XY+FJzrZxWMxbVeKLvXzo9/tg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/AmI4tcOm1GvLNGeJtk1iTagTa4H5q+y/GlXf9VnqzvBtVwjZ68yvXvmzyBxg+WXfPYMw0Gc71ukZ4jkLyXk7hugJb7B6yY2GgIOt1g8VxRoQg9D4mGrljH1nEu/Bu4Es4o80C7f0cSCATIPmOUrs5SU6vbjsmWciJLU8qpxJEw+Z8YJs+AFg/eol8WaJUInwlN8iyDqdP8CeX5MyOPEnnxRcfkePyunqHvON7jZZsZKQMDOqDrS9Vf+KJC2etQKsRmpbAwTdtJ199gNCPhp8FhauFZZCYuUgts1HRF1BHN3THHQ/tUF/LWFOptQUaFUD2/d/XzshPV4OzHYcIH+/9TBX+eDa8ruVEa/DTCF1yFuA+oBcNO4OKqmJZAMONi7tqRsvev+Q7Dsaj7RIXK2eocOJTqNiGhh1R1UrSfnqba2QqJe7ihIIVIE2OjDwrDE/LKFYX/eL0gkIgJBAnGKZUFOsLYDHtFmvFOJWIc8XZ5DPnDVf73BFuPBswVlCrVCoVH5hTrC8WYYn/KARzSMaSWWu2lHJFgvLSaGKnZC40j5AYTOVSTiQ7RJHYyzXwTrA37msdGdl4MA7lnO3WSvfl1tZpB84uHbNCpfWNmhCGndiyhzEHHqIaXb9xTbknmk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e03097c-40a7-4224-d0c6-08deb7f9aca7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 12:00:10.5322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UXK+n6z9/9Ww6TNLvRRBxtOJpLmBc8IzgSVMSOOvrVpOLZsV3JXhGhDT9AuEUevUOmqDvZ2Zdglf+dVUJ47nCkyZQFdpvv+OAkQhNLDZbXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6573

On Apr 24, 2026 / 15:41, Bart Van Assche wrote:
> Hi Jens,
> 
> This patch series implements a new approach for copy offloading. Compared to
> Nitesh' approach, the differences are as follows:
>  - Two new limits have been introduced representing the maximum number of source
>    and destination ranges. Support for multiple source ranges for the NVMe Copy
>    command has been added.
>  - The blkdev_copy_offload() function can now submit multiple copy offload
>    commands instead of only one.
>  - The implementation no longer depends on block layer plugging.
> 
> This patch series includes copy offloading support for the Linux kernel block
> layer core, the device mapper core, the null_blk and the NVMe and nvmet drivers.
> Support for the scsi_debug and SCSI core will follow later.
> 
> Test scripts are available here:
> https://github.com/bvanassche/blktests/tree/copy-offloading
> 
> See also Bart Van Assche, [LSF/MM/BPF TOPIC] Block storage copy offloading,
> January 2026
> (https://lore.kernel.org/all/0cfe6fe2-3865-4dc2-92a7-74b1240f7b63@acm.org/).
> 
> See also Nitesh Shetty, Implement copy offload support, May 2024
> (https://lore.kernel.org/linux-block/20240520102033.9361-1-nj.shetty@samsung.com/).

FYI, blktests CI trial run detected that this patch series triggers nvme/018
failure. I manually applied this series on top of the v7.1-rc4 kernel and
observed the failure is recreated in stable manner.

nvme/018 (tr=loop) (unit test NVMe-oF out of range access on a file backend) [failed]
    runtime  1.208s  ...  1.189s
    --- tests/nvme/018.out      2025-04-22 13:13:27.738873155 +0900
    +++ /home/shin/Blktests/blktests/results/nodev_tr_loop/nvme/018.out.bad     2026-05-22 20:57:31.060000000 +0900
    @@ -1,3 +1,4 @@
     Running nvme/018
    +ERROR: nvme read for out of range LBA was not rejected
     disconnected 1 controller(s)
     Test complete
