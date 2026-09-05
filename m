Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD48E222597;
	Sat,  5 Sep 2026 06:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590146; cv=fail; b=pCUZkN+6PO3aiJXKxOj+rsqtGq0+DddUsrGSqlKwxzJwF+/AETMnpLJ++x4SLNfnWZnHYxEhMfb1trj0CKZlrLaVLilifeU8ZxEp1MaCtz5rjwJkLIqH5rqSxGNdkp1nX3otHPFkhWb1JXxL6TAnvmpGL3bFi+v/NlBS/1izZmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590146; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jLJJa4/T42IhUUy0g4Gu7tqiNXGVeSO7gKhyheivvUwQUb0dTnUQ9ZidfXB12B635CySvHh1mgwosS2p/ECkfU43Pyc5aye6Km7WuHtvZm6g8JfEJ+9kF20DxfANbv1dbP7oK6WThpfdNSUavLCIrbxlrp32EWewHa9lSCT/aPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kbFi6Wdu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GMSRsgD6; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kbFi6Wdu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GMSRsgD6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788590144; x=1820126144;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=kbFi6Wdu0u0V7Lx5SsLpf5biTBMVuvCayDP6ggMdjEMJUidKjVqUD9Wp
   ln4MFAeReBGMZc9OjO0cg5MtmnrX5FoAArJZu7+XAKSZqIv/XOyFKwBoc
   NXTKQLqcLvycJnDPRhZM6ouEdCopWnXKzKSmwEEZSPy3XlmLnuWF5ONOw
   0ADMvJjmT5LvAu/W3pHWe1/oy8l+T4mnfUNNPTss4q+9lbpruW/jbmXpb
   ZgqPDXh1/u2oWj1yZLrm5equS2jrvWBlmD1YLPS14NHfCEfekkpI6fqxd
   mZX9UlAU5tpenpaXlZSmK3ln2UeI7W4mdSnljzwPhzVxTFPV39T13ARrT
   A==;
X-CSE-ConnectionGUID: le6LaXMZToOcsS45puOw+Q==
X-CSE-MsgGUID: 1GjmcFpUQ2S7j5RJS8Yevw==
X-IronPort-AV: E=Sophos;i="6.25,263,1779120000"; 
   d="scan'208";a="154799133"
Received: from mail-westcentralusazon11013024.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2026 14:35:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YkomX5eZuytqqE7xFwA1EBmUnMKQtR7q3RVXPWNSP5ZgpPYdEenq+Lh6TeNfJAfcB6ROLnRohyxYlo8HJFDjr/PpCP8sl6u9nLxQyByfposcOJ0dITg+a28/+25uR2MDD+3l7ga/OVjh/aFu4VoC27SPdPy+XgDOi8CM8F+osdrspQeMCtL9Xt8ELz9n80xfxXXERYqzSKGi1IOlYHsYsLuqirnYjsPBaDQNNNGEDwwbM5PnkDczu8fd5Dyg5gLWVe5OuwGd0xKAwQb0ZKu+wIOZh1BpNJJDBptTWa982O7IKDYfrQEB8W2/NMAWabvt64LXAlUvTFNn9DsnYFxruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=cCLOOMy9kXRjX734KdJplbT+BfRXDXIukhf7cX4mGbW4hya9/fx1XsgPQOo+g0h0l2m4J/GBeD5hBiewndSQcS8S3FubLPTq1vJBRkIJfkxwoU/NMqZ4Tq9+4f3DfZhjzgWicnSVmfPTPSF1YY6dU3BhZM7HQehLW+CxBCDVv6c8oEb90J7nrgxgI0+UNqjCSFcBz1osixDeZXDYNZB+ZxFZ5leH3/OanmXFUw6/LUV7f+dStdvjnP96zPefNuorLEdu2S075oRCS6h30YL5R/kdJyKeOyv7aIOZIP5LO5FA1tI7WenvOI0Ez+TkoIgTezCk/JZlRhbWWD8aJ5Qy1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=GMSRsgD65JF1V7K0jZw71plxgnLhC5r0eUJrf46gAaJpVnaR4XRQMfgRQ7mpc8tG6f82XDIwOgLU35OAEorQcrKtx5zaT2qxp39jYRUCPgwwlkmiFmf3gprnqKZ8CUi8hyFw9vWe2qhaLESe993RO7EwOYpOOSc0TZVf29AJga8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7562.namprd04.prod.outlook.com (2603:10b6:806:140::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Sat, 5 Sep
 2026 06:35:33 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 06:35:33 +0000
Date: Sat, 5 Sep 2026 08:34:29 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v4 07/40] scsi: core: use 16-bits defined sense codes
Message-ID: <apu3uTxqqwu3XyDm@mayhem.fritz.box>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905032224.509860-8-dlemoal@kernel.org>
X-ClientProxiedBy: FR4P281CA0307.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: 1962b79c-6133-4a72-c996-08df0b17e360
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|19092799006|376014|7416014|1800799024|18002099003|4143699003|56012099006|10067099003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	BjPLg5vMjrEs8KIf0tgEfcQa95+NXUbtOzlvVPZsTFIhsr8n/LkQK16gLRM8w7mB/EddMWBEl1F9lshCzTs61EJmS8Cx8GNFFu9t+jjrbt49Aq+ey5+MchsWqtv7qHE69AVe4Sph5sG3DpT3NocVE1UMmeJOfGsLgKZoqH/k8BzTf19tFL1mCew8T7yBCosGzG4YH9sJYwU+wnnjh6LKo3G81xtUI5xxjogqukzPPiN1qNzavO63583YJMqF1eRYKKOZrJCpnNrbnmgUTRu9qKMOXXOOgsPzQww5Zws+0gY2g9tK51Y8FMKeHPdP3ZvtZXQISipT3iHkFpJuLv8F3j9ouOSk6IwMSRAKrxlvk5lZlnVLoX9BTKylVdHu2jzp7X5d/epN0LvEHcWk0ygfujIh/YjMbI4B8jwW+pNDwL7RioLg2BSqCT7tSonbmTv2OsRW0uwfji3dHNkmLT4H+eGjHP4B21DZcXWx8hy+CoQ5uqSL8INpgRyzeOCWD54UFIfUfG86nPEbct78gZ6Fy+H5luCfhjKRgAPLpQC1pFbmkXAVUuyWZUQ2b5U0EzCV4viiHAe2ytRuU5l1zf3IbEuXyDpl5ZUubhXCk6pZIzWkd2ciYEyokRvKreYMqQEEuk95QAyIWNVxbIdwQGi2FhWDk3YpZC+Nro4cBelaaVc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(19092799006)(376014)(7416014)(1800799024)(18002099003)(4143699003)(56012099006)(10067099003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0NjHG/SDC/YMcTxuR8Jivo5zTV5Und01gy/laeHsi9qnPWCE66vUoN48LzyI?=
 =?us-ascii?Q?HmBClklPtHDuQCpEPkwdVKs1iWvyNKnNmwlX7beohWPXqxKdOY2JUhoGuCCy?=
 =?us-ascii?Q?6VV8a3vi9Tmu0eDbAK56YAwGxz90y8aFz26CXyT6bJlTPMRaKnQZPXhHCFwE?=
 =?us-ascii?Q?GoAxYsMVItIRVhp16kBzg/uoqunY7Ys64Be5jWtxGmbssRDHUYeM11Kul3YP?=
 =?us-ascii?Q?JUD78v/ZguhZv9EhhJ9VH1JSjnxdk9iwb1CSd8L/JXShjDpvU9Tu78b0dCCi?=
 =?us-ascii?Q?63Lcr/g9jL+Fulh3tHCx5NJ/5Oh4g+9KGo1cqj2RBXRdnqnDEJHPkRDq2HPv?=
 =?us-ascii?Q?MkAj7gD7GVvZRUvxwOfpMdTbFHsCzKIQYHWaIrIVzix7/8ikHQl8Mqg847Xg?=
 =?us-ascii?Q?51pQLuyutU0FWoGKUox3u3R8iFvgALqkSoPNnV1oewBFSTEHh88xWIArZmZo?=
 =?us-ascii?Q?0j/yFwQ9A5+JxOY+NDcJN3Q8bYE3hS4wyBAatglIVgV6NjvoSqa5EtgHbmO5?=
 =?us-ascii?Q?NWCNgMN8HnJJDpoODjJxkNY9u1fMGUO408gGT1gcE+FFcngD6RM9tn4qmuzG?=
 =?us-ascii?Q?11PgSysCvoK3x24YxBq6i7rytznQ+gjsoaNlZu5T0/y128k7q2kW3VR6mYSq?=
 =?us-ascii?Q?cWAn0oMWLICrDSKCkKoXVQDzkBAWJYwl87EWJAxFlpXAESJaCiXiyO7puHV6?=
 =?us-ascii?Q?siPycaZwMwK+HKFnmtWBKhaeQgGcLUxvJub2Llqd6xFH9yl1H5CKXGMQsYdH?=
 =?us-ascii?Q?JkFl4k2e11nW9NjLjhKf5+GKixvA05g9yD0GCS+FtOb0qITtOF+7FnRRKM3s?=
 =?us-ascii?Q?4R5gtsBU4rK4EfltUwvuizXKCZWfDqSJIDZWqGF9khc3jnrm5s6YvIKqlisH?=
 =?us-ascii?Q?76LBtep8FY91Zk9dhwI7x2mfcqudaoXRI4BLQ0GGO0DRNBHZkcR2bHUMiGHS?=
 =?us-ascii?Q?/rEBXpZ/2+oqlTCzqyjGpjZnBcbQkK4qkDyFKjbBv8wumhFf31jt0vwUbeFo?=
 =?us-ascii?Q?298dKLdmwFAv7taWVRSxwmaLQ3uNARKCODKcbJ6MAPX8q+HWjhMUPyp4ByeX?=
 =?us-ascii?Q?cMeHtiTzoE01hIY0qg2K2Sqd947zAiazXd3HJsSfBdq6NSTDgH5ei1y6kWUd?=
 =?us-ascii?Q?PSoJUuuIDWmdoeI3CLgFQK/zvgM9CBhfdlJj5l+bIHyMyq/Ny5byirz8Bysj?=
 =?us-ascii?Q?4MrcQK9jdRKc2m4uM4DQw8S+52rCx7Da1q+qgqnNFf+B15f22RgilZMqSsTV?=
 =?us-ascii?Q?jjSr+Daboo47E4oh0Og2zmKtAt37081kuBzMgCF8aN1LynFUfjQKgKWnWjgw?=
 =?us-ascii?Q?EMcpMkZ30hKQGPv3EHA7LIlO2WG3vTZDpHD0MA/BXLZHuAb5RHm3H3skj63B?=
 =?us-ascii?Q?4yl51o2DkPo0SwBtvzpXyVvlhMqu9tbOQN9cMmLNNLhdoTgZ8UEz1h92dSla?=
 =?us-ascii?Q?D35OYJrfyNKjG4yFydc2KniOcuQR5jVMhCDatJAoYvdMFt8nnwH9Rpt2G5gN?=
 =?us-ascii?Q?DMp6cmC8qbvRT6KGPN694MIy3gsPkWkKZgx+c8pnL4H2wM1eywI3Zf0FF4F2?=
 =?us-ascii?Q?1Db/HMxVId5Ef3xE4aHW0BBwL+KZxGSIZyjPVX8Ez6T+g4TU5ISLRuZUrPyf?=
 =?us-ascii?Q?BWLRgyexXPQjkFaM5Ahb1AE1pKpBCmtmGyK80TUrDMe8ahdCyTwvC2jQS7co?=
 =?us-ascii?Q?GS6uzFDXLrwLavvyCItsqJcoi2XwyS12OqGO0iYLbXCm0DiJGMYQy4BgeTyi?=
 =?us-ascii?Q?yE9nK9K1QPP+D8WyKBl1QqbIoVUIMluANN+eNVHBco0k8NOVQiFwfY0/YwSt?=
X-MS-Exchange-AntiSpam-MessageData-1: ZoDEv9z5nZp44A==
X-Exchange-RoutingPolicyChecked:
	o64ihNk+f5c/xxXp78PyEzbYyibVArJpA/bNK/1b+aE5KqpIguHWCQWYTUAGIl38sLYj51GmMCGpO0ag1ygIN+bMPmHHNlh6X9DoW5WoH4AoVdlzdy8vwCZVxgDQXYHPN5zcHAjPgOWfAkmN3RYizPuyukjFu3y+DgKxm5DTnVdL8+TH4wEaY8+i5uT2/F6Yt0t4Shv4vhF8hp7OUFT1ucw15fOsVDzph2ZoyaNdUqjQTY/mFaBsk6wUZFHUJxrXk02OzkbGOlxKt2WRbug3Y6hExrO1JbuDAqAP1871IZ+YjzGYlzSJ0oEdzpFFxJsig0LUxaR9v/ntAxxXwCHlzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z/iS9xQMLxRmekxOXeFmmzP/1XxSqG6NWooIN2+9+ssaSTBiC8u4IzoLuUAtgh89R4OrdGOF1E59Bb6tSOYQRTngNyuvBIFPbp8fNfguwkySKFlCTVeHbCV3zWPcdOLaHYr5UrGQnBNYRmalEgPgpg8dIAmAVhcmHhsjfPtuWZforPHCTWpoACuC+F7JcdCDKES4Olx5dxeeW9OkafsPeueEwFQV5NvugfmrlhLqidSDWJ6FgVj9wWb52/B8/lzzPVLdXExf1brdbrz8TERcPoJGUaFycKwMTPck9PGNPgDQVq56VAsPZ/6h4ERQXvuOkb+4XDGfEEIEnAxB8wSEr/Tzl6rWyngWuDAf014CI5/o+PBY0y3GpXRQRaUvBbhivMP2m0BoSX00zxdoMDgJxQTwY1q1aILG6Rok2LapstScRKVFNfclaKRjG5NyXrIAoLrLLwRbdDkHXp2ZGCJyBXt8C/FhmBTWC8fya8mIwR2AxGzqotDRPj9LFsmpsJX5fuoOoCMQVcZuXJR8x/yeYYU3ww0qo7I3qTWuYueGjO8wXYuNHa+ha4AjveYH5UkDXWyg+xbxWIf/3Mol6x5oiK4jTCD79kEcnuvHI+j5uP4yEsldL8ohtv8lbGEyMo4j
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1962b79c-6133-4a72-c996-08df0b17e360
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 06:35:33.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkDMK3SgJkw5y9R6KMyg4ldwWyGgDjR+g56K0uHESBCDNQ/cZp/zU5RRWnT01J8Lt9BYVCNduIC4iqOn6Q2Ii02avOovHKPVI6OrbketLcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7562

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
