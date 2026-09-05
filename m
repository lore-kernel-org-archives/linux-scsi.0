Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E43D352010;
	Sat,  5 Sep 2026 06:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590830; cv=fail; b=NGn+tnDAvVqmLWQ6QaGuOHb6YWYFvTKzK9nu2VlPNz5pj4K+plBspB0ZDXd5GXAc7TZeuiELg1R5tZ1W+jGu3P/y9Yx9aXs5zGWFyXipXjxGuprSz6LVJVMJ61cvazraE+y4OjQwKHgv2zoK/deEkryJvXtRnRzcdLgEghFDSX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590830; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nTUwWbHb2iwZlEbpk9AI+bFrPG3U54j+E52J0baeMsowAqu/xUWjsyn1Mmm/6EuYVgMvdSQRXYCuhQm7nPqhTwnUe4A2bnK/32fuQAX9BSU41hpgGYVMxqM2ViSJWxgQ8s3h7de0o0tkojdhY330G3TktiWGxbGrTB+iXFZs06o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Gr4A9D3Q; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kPqgOZCQ; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gr4A9D3Q";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kPqgOZCQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788590828; x=1820126828;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=Gr4A9D3QyWTKYMqcX7UAqMrQemmWo4M9xKXTUcr6w625KX+7IoOI0S9E
   aWzcnrB/rq1fkhUjhyxu7K/mFacuDdff2ET3sKBeNAwn1APu9YW21jz5S
   xxM9k1Qa9JHxUeNzKIXESy93xitW/AALYSNBId8Zv+B9X5KnW/msUm8E5
   EJ5lh8VHxgCjFH8LouZWo/jQLmzIHq7OmLSJSGXRh9yeMnij+hAMfUAA5
   eeELU4iPDrY1dhiY1I5E098Cj9hOJjW+jE4nK6jKZXbeCXSkXXB0BxIHP
   H5tK4D8XPxHXazeai9uktwGK9cMlpOICTatQ+tv/070Z0lYkafg7foF6m
   g==;
X-CSE-ConnectionGUID: Bu1/ACJ+Tr2EOYD7NQ6Gaw==
X-CSE-MsgGUID: ESi+ZbbhQFuz/UKeztd+cg==
X-IronPort-AV: E=Sophos;i="6.25,263,1779120000"; 
   d="scan'208";a="154044601"
Received: from mail-westusazon11012052.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2026 14:47:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+8AQz7GXkOAVvy85FQyl7kIVu3fUe0eayrCHLDtTe/bC8Gpif2ItiusHc/IM8ysN8RdR7Fj3JsYe8SMGALHJfg/QyTOd3TXtj+QarN5l5FSMAM2XcdOCnBF09BNmHUoSZYbmM3msbgzqk/kRdFzdyfdJgO5fwIyeEe8t6HZv64eJYXAurQbQe2uXKpjtOQFKU2af9XQNCl6pvlSMQ81CiSJGmgd2jO9ox8eK743f7c1lCe+5Dp1qBumwd4JutKiz9or3AZ2QuDxhb/o5ptNaCgvuJmUtUMlIy0Mu5sH4JT46XDOq57x7K0aYLFtYGuCZrXbgcaHQL2jOSc2kf7j4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=f+h/37MBU5MV43y+0j2YvAFcpo6zdS49677ZHk9HaPtlROaPtNJCU9VBC1cTN1DXy2T8mpS0VGeFGoIJsosXpW7zOugvAWodWAIz1IhjtSBU57uPzIDLty40tUsvWQapxMR8rr/Tn7twescIW2D0voIL0trpgGCcjIFwJQF8HnBP5kINcAIhOlDiZaQ4cSavAFFq5S9kpPuoHsFTV5u2o3FiHq2quksEjZSTOGHalLc3OPCPNAq3fUZr+0+qAu7OdTqA2vrGRFNC7wI+tpVs3x3/s+sANgF7VvhhU2I2udXA8FxwgXUNH2MFU52b1dP8MZOCWGZVfpKhrcv5lwe64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=kPqgOZCQpLk1LDiQffZ8c1AUjkF9/03JhdrAurOsv3kuTd2sdTAgdDWjbHxmKEswNpooRZFHS5CvmSELKSVY2Unn/P0nVr0HoWHu38mhrkPRryeFILaLlTcvFDSJ693PPVX8Bz8Hdysk2tKSXj6gMzIChJNKvWW+HVvKtxVLw1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DSVPR04MB9964.namprd04.prod.outlook.com (2603:10b6:8:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Sat, 5 Sep 2026
 06:47:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 06:47:06 +0000
Date: Sat, 5 Sep 2026 08:47:00 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v4 13/40] scsi: device_handlers: hp_sw: use 16-bits
 defined sense codes
Message-ID: <apu6jen2YqCDKrjR@mayhem.fritz.box>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905032224.509860-14-dlemoal@kernel.org>
X-ClientProxiedBy: FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::23) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DSVPR04MB9964:EE_
X-MS-Office365-Filtering-Correlation-Id: 28418d61-e754-48b3-200e-08df0b198012
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|19092799006|1800799024|376014|7416014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qwQsT5iw/N+V65IzLLxWJIpNeG39CDLieH8fu4KBBZBBEFFKwqbHn0mleqNgtPzthv1dO1Y3LrIP1xgXe2SxEZhxKAnn+SmCJ0APpoCS1GnPvcYmp3ukxWFek31OmRyCTC8YSesEaYk4Eys1YFCYLCnT+ayId1YVkW0zepqfEyDfdKOGVhaGNXHmpTOq8Eu3Hp/R2PxWx2dzpe9Fa4ZJx1/Cqhls2qRJb/fXY2v3n3g5+aKbcctPmJX384qMTycM1YrdmbZRCebIfpg4asE4dzdww0RCSe1xC3o4Up19l1Wr1L7vkJV4ic6Z9SKwQWBgJ7YULHIEmw81T5YMj6vAU0q5WQj6cuBvrniZo2vZn0B8qFdzbfZPxI2Am9COYA7ouayRlb/WceucDp4Qmhf1gzPOlzHyzU/1VIdi4QjwJa4BRyPfABpUHFqp6S8rdvNPcZ/T5T63Tu4jgWowCZ4QgwJuO2RqlPNEml9AVWv48BdWVdzhshfS42tG3kM+Bhkl8Itpu1CQXipVV499b5xLtETMcuAfes7Gc4o1wxQRF+uSIbEA61zPJarPQRmrFS/g8EAZqaz1+fDD9LZEadQXmnhWtzViprKkH59gDmguMetZ8QjqbhZZBFlB3lm3Lc9BA0gktPqPWHLwIZh7g/V2e4Hae9tvI370NohmL/4xFcA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(19092799006)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vdt0/J/Bg4ngmfpl8FDiD2r623yvSw2BFotl3M8QyBL97pPZtSYRcUFIn2d4?=
 =?us-ascii?Q?nQyQOPa791oRVYf8y5N8RLGlvAdTcDmjmzQhUV71ZwEcUsIp5LWB/5LFQNh2?=
 =?us-ascii?Q?0c0OU73UMCiiXSn21vUDPH/7MWck4/wJWuj0tQFe35B1eN0LGrmPIJJvTWeA?=
 =?us-ascii?Q?UI2KxumClLjfPnXKs9kn4v5ssfRgWrxmtj32DyOgX7b8RsoB23a7fqdRj3bE?=
 =?us-ascii?Q?VS0kYYsRBXpowb0JR6fs7mDSYS4W6OeQkm0iF+btFyPFrsWqwvXpNdhsY/xx?=
 =?us-ascii?Q?MGjevp6J+tAp9P7L4MvYWv7MM5G0647IyADOvdb6NeV0QWLbYBCzD+LgM6eh?=
 =?us-ascii?Q?DmusI2LLgSiRxAA5ZK4noPMbqBvQOe8Kmq2vAf2u3aiQNkbffU2AOQfZVf8u?=
 =?us-ascii?Q?GOTpUP3RN4nnKR/CeyUqyZTqgQHK8lLdlCfkQK83Tsv/t7QHXt9FbWgpdFRB?=
 =?us-ascii?Q?to+6wbHEngHSnz2p8sBVA86OfNp4AFmrhy3riX7FPBCN/yTP0NyK79JtDA9a?=
 =?us-ascii?Q?inrMR0ctC3cmFDJZ3ugijVdQhvkBTmdbumcdgv5eErbLetyQ/Bl213nT81il?=
 =?us-ascii?Q?tyiZBPFaz8Z6T3uDKQ80pYfAQt0Xa2WiNuf0KM8qETshr9dfI4ZQEG9i3qtw?=
 =?us-ascii?Q?Aio9TLbskHvNbIepcdKb9KGRdEzttB9fR9+T8Y123FSQ9yFqS9W7JaAMip7H?=
 =?us-ascii?Q?HDnTBczRpoILdze496FFzQZR/TV1efA65+D5viqT1WBwntZyf+gJzmZsr8a7?=
 =?us-ascii?Q?Zr9WMzBGq+ux2FMBn2ZM1P2Lhy+8cFpNExw7FBzyfdN3JyRhnqqTaIsXxwmu?=
 =?us-ascii?Q?wW7biUw9wW1PNr82AQ+MSPVahNP5JKEyBpZbCcf9xCDDG+aomv40WmgQiBEC?=
 =?us-ascii?Q?G8a3R0pHFxvKFNWuUVjDypqGaWfY4xKqiqMdxfzrh7975molpF3OQyLIUQWx?=
 =?us-ascii?Q?Gz+a0p7JoZ8mcsg5odn5OCKepIkrpYsyoicHQ8AksHJ34yV3dZ7yu4MnC9MG?=
 =?us-ascii?Q?6IQEFJNqyNXgjwvCY3TmgcqS8bUAor3DsM/btTUZwc1YfMOaw26A85MxvQLH?=
 =?us-ascii?Q?s2jix+Ci6e+dnqj/jEfdkgJPHyFiXtmdR2lYMZ4m/LNPaE6h8yxxniFDyDyC?=
 =?us-ascii?Q?6nUVhUxqdi4n0cwPb+bHm35uhGz1XqJ20AL4cfx1TIXf6/U/ieDLDnFSU4TU?=
 =?us-ascii?Q?DQfDIMbK7SD+FMupTovAn/iVSfmeCtCmlXKl2fTi6W1x5ijP0xuxm/GfLz7M?=
 =?us-ascii?Q?zSxikeFpKRrz08yTJjO60USH27Uv1hk6rtd7JsEHVw5cK+VfaK/jhm06x9at?=
 =?us-ascii?Q?+OUlzStA8rTqm1nCYtZIe30pI7P/Hv6XDWxBkKI61pjuqcDLtBpMk2vB7yB4?=
 =?us-ascii?Q?wUyeSaTz7qu2w7Y4B0/MysLJYceD1B2WnVzAkm+fTIXrS4gE2jia8yYmKm0D?=
 =?us-ascii?Q?kkPP/bBjHGj5lMPtoiyVpBIZr7MREwSvDqRz+arsSShSTIi90DtAelo4Y9yQ?=
 =?us-ascii?Q?qRLuTnwqbmdx07mPgnDdO28TSAnHjWxkgw0DGUA8rWiGD/j9cn8wxq7oqkGn?=
 =?us-ascii?Q?2ywINyUJ48bg4cDvQmJx/G6GMIMLc5RNhJUk3eUiYEDN8hTMa3avr8zhEFLJ?=
 =?us-ascii?Q?dPFYqXO0F0b+KM6vHjvV8L7l7Hbi3bT4fqRJ/1UA7Vy3261Tw7PAbTKXKHQn?=
 =?us-ascii?Q?4imMoYntCi3fTkhpnhOG83Po4dZ0Tj2ZVKwD0u2SMqdt3A5xuGWOP3EEC9af?=
 =?us-ascii?Q?ww5IWlU1ppQiPuXou+TdyHSRuJeiUR6b0f9AZ9JETZM+wqAf2ggDIVnlCFXa?=
X-MS-Exchange-AntiSpam-MessageData-1: ex2erfebhatb7Q==
X-Exchange-RoutingPolicyChecked:
	q2TLH23QEb0+We3KrTpsePTOKZuHi+TxGMUVNjw2YshFcjUSysgd2VgEWVML7jF7z8yg5HBH8/0X0mAebBU1nm3vmghGozAF9nSDOXDdwt6rUlHJlMCKOq1examxAR5JDnyef1eOhXKSQoS845MHLH2BHossR7tTfbtpu1snvbZXHPCFwaA0YLQBQBVfKLnymnNFV8gzhc2DhBLkKAK0kEu81EuaODDhkuRqRvKxxRRAa3zBzbtvwbVRuf0kc7LDD9xtC5atGI/0R3mgPADg8MsRBdPofX+PlQEfnrbGXoSfFeISK9C25z8Q5TN4PiqRN+oQRs4C9iTXkg+wxCV85A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EwbaTUg7D/OZWJ++ZIIRXVLAgIt+M0GoRI6zj/si7WKNKZ0dhWKOXKpAevpzoT/J5ofVfvmF1707qCpsQa7rJsYDY/TQfMBQVBZJKA7hqT23AvcE/5KnRpS91CuC8aKl4Fs/t6lQKX8Cphsb8ilZ3WQngx+rltQt+ehYZq411TsEAjIIjmmrUGSTQGcgMjkEWOURcGakkppJH91f43qYV6Jphq5jfqN6AH+CKdzOu+9uA6DPCUDVbEq8GdmJijhanVi0vfkNF11Cq87iAS79gAtJezJIyhBPUZ4JzRHCxX77831RrV34pJ1JdrUlIk28+9Fn+TfWU5Hf/odCvY8xLg3y6uvWKx0A4k1CMFO2MAcEMZl6Bq6h+4YofVp0PhTkkTwEtwQvrtx32+JL3PWQaaTxF5HoIszga94PfE2iorqrJpyDLWeimnV+M8+ZWYNS/OhheyKxUcmDBY6OmQsDQNA/mxHFHXlRkIZJ0Q4SPf9fXdSD2x7JBFjRH6Nh6VlxXO4Ej4irJa94AC8hwiImBz8wmUu6Hs5Z88C+9MLOMvbr5q8WNXegylAcQ1pRMXI26Y8qqj1/0tT7kdt71WN5DYj0v7T0C2fLqzHkhe5dcJBXlNYi7Q9l+k8p53pb4txl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28418d61-e754-48b3-200e-08df0b198012
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 06:47:06.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SqXohSXaPO4nXJHj+pqv7Mo+WZMFrwzNM5zN12rNYZyBEbWT1j8M9td3MoichaKnr4kStTrtbh0TZ0y8qFjsWWgwt3AJtFtt2CtrtoybALE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB9964

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
