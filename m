Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794143291;
	b=Z4Szxc8LuLZMP22FfUD7jf9GqYwLp1+dvp5lGjR98Am0Oc5uIS3hgyg6x+pQ6WSoncRp
	 28qRVFwOciaUaRUAc2KwgvdTPZ41vEXjnW3tY+RuCcaLktt2WJV2mAFfvLVMR/+DIdR38
	 Ljb1jAqry6PnvU9glx4XVMkCKP2yTZo/M1HXcN0mni9WbI/IT1kw/UeYH5aoOnUczN/lJ
	 sjv0bWjOuvScxiu21VULI9OEXw81ie3uMZOJ8+IujpUS9/U77zrpKoNrho4MM9nhi0bbS
	 AiX/p+R/JjOCKtcjwQ2E9djNQtvXuEw+HWhFl1kH1/CbwOu/RUxJm7jQAEIVD8AzhEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794143291;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Subject:Message-ID:Content-Type:Content-Disposition:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=XuOpCGStdqP6saibhZVYx9/3/yVAFhW23UR2yrzxiNs=;
	b=wX8ZibdJX39k6ChaNf+yxIrmt5nJuZg0Gva+84Uu0CCsjhSOGUZXSn4A5I0GWWtfLRQo
	 69EjrSyd26QNGAMSGyTV14Gx7BZENm7Qc5xL+FXLlFaMVBjpjApCIR481WyObBIkngY+l
	 1beH9pIDKYVBqgr1kPTPVO5jtgV6QkrjndLSNBw1ASE98CNIPlbzEmtPU80Lev+t5KeNx
	 VALktWW7+18M7SCmlWO/XTDBqrNgJBTKZoTS0D15Lr/avO8Bmz0yIaFxU+HOJAlCDfrCy
	 XB0g/btZap955S99qv5bt+FdTqbzoI2xRRkmq7LVlvUH2kDD4s/udUfouzkPLXBK86Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="jd69/sGs";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=B6B8wRCC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC789606A31C;
	Sun,  8 Nov 2026 13:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC789606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jd69/sGs;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=B6B8wRCC
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794143290; x=1825679290;
  h=date:from:to:subject:message-id:mime-version;
  bh=33hZiLVGSk4X9IrkhrEMHPj+c/qTu/ht9FLxTKGIWSs=;
  b=jd69/sGslPlFBJf9j5PB2jDNNBga4xGaXpOFakJw1hR0boVu2MBMQWag
   syFGPmzaizWMdtovCoMPOl+yCy5prubbfY0abLyEB9qhPBjZLnua2mhBG
   4lVGweeK617kgComEekaUlbSczjc6Wg5J8CCtQucXz+9O7Bb1S6e53PkE
   CyxLgNWJnfqkDdSOR0Dcc//VfG1yyOR/w9XWigHbPew9hR5z0FNg2CG55
   X94Rds/+1Bo866acIzfiqC5eLGNo8IScBGwW311ccJXzgkYheP1AbIcas
   LWjLuzyCTuJ5hLv5cRj55ZHrxSpslH63qLAn706dJNbD67BUxcdShh+xK
   w==;
X-CSE-ConnectionGUID: eHxu+nhgQK+1I/xWQhPFCg==
X-CSE-MsgGUID: jW9voZmnQwu8Mtl7Gk0BmA==
X-IronPort-AV: E=Sophos;i="6.27,202,1786982400"; 
   d="scan'208";a="158627367"
Received: from mail-westus3azon11011009.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2026 21:08:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kp64+L90GN1i+UngZmb7/raQNqbGCuSG6sKJzSxRwYNHcllhhUR4KCzl/yLHCi2tJzPaOMnuNZxPtLPdZGxhzGgZth7QwFbLdm6Hv42yz72jtCxPgOSxy3RcMq/8ujP2c+vtfPG14McfUmzVQRGcIhqAuZ1O62mD4U9Py5D8EGSqX1j8SS5AnwjX2VIBLVPcPetdrlyLnZ7n+znOiPn2g74cMo9bKOv5DucQGD+D1kEJtv9/kB3H/WvUAPanm8KtlECxwX7Zrtgyi5QUkYfYUYQzZw2AJyXTalm0IuM+zaDCUn8lh/Tc7lTb84dp4oRxxeG78pGNb1VbFCQbC6TXxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuOpCGStdqP6saibhZVYx9/3/yVAFhW23UR2yrzxiNs=;
 b=hfqz8FTad79gN+Kcp8yqAhe4B+53fSysK8BZMAPr9+Pwi+jMUzQtFMfiZGKyzStUGjykJBZKeGjyeRWSYas9r0PLA38qSt2KdgsyH5Lnec6MJyZcMLxyLMZtYselzKKDpwl7bmxC2FLgFly1iX2S2Gtr0rnPTNeZR7WtMKIBsPiwEQO3aFYsi7kSqYFdNxXW40T5lUMxJEMCgIMZtHDGKPPhor4+aUzz2zkhrgQJ/ZhI5TCUzzbFxR5vNxnbtVCWhSnsqLUPb0WqfcC26YWSkfDqP+6mDhJkny4UGu7L0H4MBkJ/TJ0hXdgfkZOWZlKiKNNfxbJGYG9IGfPTafIe5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuOpCGStdqP6saibhZVYx9/3/yVAFhW23UR2yrzxiNs=;
 b=B6B8wRCCLeDcJ3pYoWAytowC4MORtl7SVP8cMbmNwhDeoqP0GHtLu3LvenyZAnF9cW/HhVohoVyy+7z+TX+DoD6pFSdxJ0fq/bfU+7qfZJUoJz6sW1c470DV3CpR/NSBmFtYYVZ44VitRPD1iQpJzy6XyCYFX4/jd2oIN9F9B28=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by PH0PR04MB7525.namprd04.prod.outlook.com
 (2603:10b6:510:5f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 13:08:08 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0592.010; Sun, 8 Nov 2026
 13:08:08 +0000
Date: Sun, 8 Nov 2026 22:08:03 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	nbd@other.debian.org, linux-rdma@vger.kernel.org
Subject: blktests failures with v7.4-rc1 kernel
Message-ID: <avBz7uOGYo2y426_@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: TYWPR01CA0016.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::21) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|PH0PR04MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d10faec-c4cf-4381-f8ed-08df3d99558d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|19092799006|23010399003|376014|18002099003|6133799003|10067099003|11063799006|261028144727099003|261102123227099003|261022105027099003|261022075727099003|56012099006|261021135927099003|261021121427099003|261026140227099003|261009223027099003|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	ZdWbAXH5/s8IPLtx9HvywsjDXpW+IOKCGtygN+xoQu+98Jm0YsVdBETo4MB2b0ka71r2OTJcrSBzCf6QHlSE8gB3vQ4s7knztZG/1bMXMOEEJCWkRj+0PC/eFHA86MRaPuQWjp/HkiNRGaNw+j4Y8aGBja2SxKM9KAKllkATKaTYg/irn6/sV474i4NNS+JJMPRBcuGF2xNJqevA6gOOCMfNur5hxm21vD7JnBrlMoUA0X/NTnSjvfrRM2lmNUgh2SuAmkwpe7mc9wicrY/Br/w6bZrp97fQJnw8aSiSXsE6+BN9ZAnRjjzEbVzm1ym3keZy4O5TnMCfMLjWkUrrkyWVr8c/7viECvJ3JP8Lk6WHs/M+O21pGkqRvM2yj3Ax7uvg4AYgYYABznXCeop30SyFusmRTn9eRt7lWVuF+8wpbsnjkTKlKeJf6cRUK+HiI5A09xbwHAHN/JsNS2JpVtzLu+F0m5YAyxqDUtVZ8g6rpD9OmyaEAnPEsfswoLnHgSpuFODbxRv01bF2Mi/ex8+oTTa8rV7rzotEj+osFCj6YaVEviuaUNnJ8JhdkUkmxkHs+jhocoEQzz3MdITrgNFmyfGBUFJtOupmpDqoHKuLhpwK4z/NJyQcKcR/cX1T
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(23010399003)(376014)(18002099003)(6133799003)(10067099003)(11063799006)(261028144727099003)(261102123227099003)(261022105027099003)(261022075727099003)(56012099006)(261021135927099003)(261021121427099003)(261026140227099003)(261009223027099003)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OIBiJEQUZc0xfKA2MvyFJBjlzAJWuDJrr3Tp767MJVcpWL23+nJTTfK5WnKm?=
 =?us-ascii?Q?CFlsea/I5inJ2tyW64AcqrJruA9/ibLplKNrBUEt7ViKjF9EOs+Y/tbnU7aV?=
 =?us-ascii?Q?7uaA9PpqFx3ZEs87vhjwkaBMs+mHG7k2fwxkKDwy+STZ/Gr8sSGyZlQNWuER?=
 =?us-ascii?Q?HXtxm3xlJZjmTX6HNz4mWRSWfnyd7iGrCLJ5728KZ4WfW5huhyzr4UWb7+fu?=
 =?us-ascii?Q?sMqq/pcSQcMs7alpjfcob7fukHatorOGjCK2R4s7GS9HwoG5u9o3jctud/od?=
 =?us-ascii?Q?v3v2gQU3YNqUFgkPlQ3ixz4gXq7TfWTIV2cVdg9DQ0IplR5O/e1iblOlytaN?=
 =?us-ascii?Q?WbcMZIsV3LYBR6aj+VqrqqOuIc0OBYrCKVfu8xJenURu8abHOMg3bpVq1eFO?=
 =?us-ascii?Q?hz2+/UerKAA85YDlkuxeQtLFGzYeI0l7XN4QZ/ITpJFOtcyvmu8X3fUJxrVO?=
 =?us-ascii?Q?MnXHit8SrmWU8jpaKnuNJ3GI4LgSMIlHUjJGxzGy26f6mQwvudRDSCyWmwnJ?=
 =?us-ascii?Q?08Z/PZP8K3mGxA0PQaY83WFLUFGi+PXMuGY07VvRiNiJD62zYQRgWEwwxCto?=
 =?us-ascii?Q?O/WHZCVR6AdQ4Gx5S7MsbRXVQJpAIDi8lUOlFKDd/55rdfWJPWuBdvLAXL1J?=
 =?us-ascii?Q?GJGEv34Q0ozb4G2Tav9Tt52K/jC1VHRLzWK8QWDTqbQMg4k6Kb+VBVeVs46i?=
 =?us-ascii?Q?pt9pZnIBfNZ39f2nk3jySogKycWDI1H/fCfRf+Mas24FNylWAZkxLfOIpQZu?=
 =?us-ascii?Q?bFWRmFj6POI1HxDHt+UUmfQaN1QEcXmcPamek4tob1nMy2EXLKru+HgWGyO3?=
 =?us-ascii?Q?GUfc6pOXSS5UnWTv3sxExaIx7CooJ+qWTNWtlku6ugk94Kw/NhhAhFhOhHy5?=
 =?us-ascii?Q?Ea7quRIXCTME2M1mie4pWja6QTvn2GdF7D8hy+RpxmgG2ei1nCNmmfRkJUNM?=
 =?us-ascii?Q?BmcUTM6C7xLB9oA+Mzr4h2UzxyBh3xX6K3FxdIMYykLuewawZPfNxz/EwX1l?=
 =?us-ascii?Q?/N9ECsHKNRJd9Gr73oDP5Vcdru0oB4vMzBIbPlalL3hBkxFvbljxcYtwwxP2?=
 =?us-ascii?Q?qRE6aUFFOciuC79Pcdk1ucmWLCz5S9zzVMXAB2lv7990aMNAaCHYXSH8PsOJ?=
 =?us-ascii?Q?ORRoEw8mF+kPhFHDfvs/44cYInrNsgKE6AeN0N0dJbj/A4xoMa0S/di8emU2?=
 =?us-ascii?Q?JBEzFpFxhIfjreLEcpMOCOA6BT2wOhS7vDS9xEGlaQoyAkttLeIXzYw2znKT?=
 =?us-ascii?Q?7BEx11RDaOEEJSGFnf60D2LZvZHYX1djGniu7GB51idHtVRr/riidIQjrJev?=
 =?us-ascii?Q?gqMLVWtHnDGyJInHhokKdYbi1/P13zg3v/ajD+r995BEs74LB3MF4d59pc1V?=
 =?us-ascii?Q?sialMRnX4cyuuacmsT+UwPhTW5Y4//0Z3kCKRHpN21+r8yJML9pcV1ojZHy5?=
 =?us-ascii?Q?Wr1lSwS4VhBqzWpYH9M7FFLT6yCRE2Ikb3Q0/JXBmPFao+Xzu2YUYXUwkJVp?=
 =?us-ascii?Q?pp82ZogWTDkYVHamDIupeP+h8bdjIn+0QtOi106d8dceoIIWDEDnH9G09dhO?=
 =?us-ascii?Q?6JnTxvrJdV4OZYgj3xqOZHuz/bemjB2RaJeeKNuLsPi4lD5ByZFOfHMdXXzX?=
 =?us-ascii?Q?zZgwWz5BO+zA+xbj8E0D8lfhnuI62ijOp4NfpX3hZJZ0ryT27JKQVDNZCSwx?=
 =?us-ascii?Q?u3PVOH79ohuSTAC+uLhRcGF9YmpTkBC+DbdWNiERhBMDoOxQtj+YHNs2Zx18?=
 =?us-ascii?Q?h+0iTHGqX1mUpu/SiWvPk9oM1jEIwyQ=3D?=
X-Exchange-RoutingPolicyChecked:
	VWzcxdJG2emPZPtKmNXXEeub9wlfOYjG+B/J3EznzZUf0j98mdh2ClHeibTw504h715QUR+xEUIO2QyRdAAjadn9aAIgpdGpac9WTOrR2EMa2pb+7W8DWzN5yoNDmu/esj4Ila0SaS/jlVHx4Nnx3lGn/89PV8BEw7CRWG5SUDa56o6Bjh8nvhsPtWKCvjRhfgVNw/EtL2633qmhF6S6EtzyIC/FdWMuMya4+bu7HyTwHlEkiywHhTAtFfjdF6tyXsm65NclC3LQzgrxPPjjoDaqxDlhMncP1YZx8hKJFAqhAo1HOMUpInddd4cOIqveU23NDcNdPMe4fHns++j0OA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+EHkki3BNDtmXDMCQ6Vnyuj54htqNS9mn5yDCnnKjSuch6fuzAnFkNU2+dqx+Joh4No/+z8RNKgffyfVB5+Zf0NzS3Ri84b0p6RYrsyJ8gxPQTYHpTioFJ/jY4X9yNSLIsIpM0W/2jBxLE2aLQ8C6McTnp0aDOUvw6k984mB89t7TeugePMtTiZ+I9ovzi4FNiqT4I+7LCubkERduA4GggMdX6FS0mQP9OpKeTEh1rqqrCI8X3OhhLE+4cPAkZjIXLFzyGffijGwL1SF5WGssKsmmkHjUndLkmIlEEkzS5NLyz1CpVMzYZdBJDKz4LZgxcqAzRfU/SZ8Vlyf4ke/K0lqn8dIWvmdc8YDHmBBqb8UjFvlMLf7j78MA6tFuG45EU7b4LWO9/qIfS1mK5d07RbyZ59jAG44fqe58+1rLqA1eqcOynHPoJVyQHEidEr28JcHjyakqIGBhC+ixzyUi0bCrpBFxJi6iT4Dgt1tZjRS1aZcrrTjYUHRZEjL24+/xrsnFvHjNVRsuqMO+zMCa5/xMpGj+0UTccAEhCXP29Dic0/utBGqdLC6juM62/wD0TF2Wn1pBwysmDzgOmYe7jk125J6Ql3vYruYefqfoEZrhVrpT+axVvzo5f72x0/P
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d10faec-c4cf-4381-f8ed-08df3d99558d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 13:08:08.5565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyZx8szrURZY9F0k0zAC66bPRTXU+rNPg47w9Ywz2k9o6bNixHfAbjyleVkSsmSAoXFv/lNX0/NlLur8eFRmmAVuPLpogU0Bgdv+ronezWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7525

Hi all,

I ran the latest blktests (git hash: a65cf6bdca19) with the v7.4-rc1 kernel. I
observed 4 failures listed below. Compared with the previous report for v7.3
kernel [1], 2 new failure was observed. The failure #4 nvme/059 needs further
work. Help for it will be appreciated.


[1] https://lore.kernel.org/linux-block/atgwg4i6C1zGi1HU@shinmob/


List of failures
================
#1: nvme/004,031  (rdma transport)
#2: nvme/037 hang  (new)(rdma transport)
#3: nvme/052
#4: nvme/059  (new)(fc transport)(kmemleak)


Failure description
===================

#1: nvme/004,031 (rdma transport)

    The test cases nvme/004 and nvme/031 fail occasionally for rdma transport
    due to the lockdep WARN related to the two locks nvmet_config_sem and
    &id_priv->handler_mutex. It is easier to recreate with rxe driver. It is
    rather rare, but the failure is observed with siw driver also.

    The trigger commit was

     2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation and startup")

    in v7.3-rc1. I posted fix patch candidate [2].

    [2] https://lore.kernel.org/linux-nvme/20261108120154.148824-1-shinichiro.kawasaki@wdc.com/

#2: nvme/037 hang  (rdma transport)

    When the test case nvme/037 is repeated several times for rdma transport,
    it hangs [3]. Nilay provided a fix patch, which was already applied for
    v7.4-rcX [4].

    [3] https://lore.kernel.org/linux-nvme/auhpmq499RVE9YpC@shinmob/
    [4] https://lore.kernel.org/linux-nvme/20261105123642.2120548-2-nilay@linux.ibm.com/

#3: nvme/052

    When it is repeated several times, the test case nvme/052 fails [5]. Nilay
    provided a fix patch [6].

    [5] https://lore.kernel.org/all/ar30Q5H1fuyFtDwM@shinmob/
    [6] https://lore.kernel.org/linux-nvme/20261002070249.338225-1-nilay@linux.ibm.com/

#4: nvme/059  (fc transport)(kmemleak)

    When the test cases nvme/057, 058 and 059 are repeated several times for
    fc transport, a kmemleak was reported at the test case nvme/059:

    unreferenced object 0xffff88812a768000 (size 512):
      comm "kworker/1:3H", pid 92985, jiffies 4301970763
      hex dump (first 32 bytes):
        40 cd f8 4b 81 88 ff ff 00 00 00 00 00 00 00 00  @..K............
        00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
      backtrace (crc 3cd92a37):
        __kmalloc_cache_noprof+0x4c1/0x6d0
        fcloop_fcp_req+0xc4/0x650 [nvme_fcloop]
        nvme_fc_start_fcp_op.part.0+0x642/0x17a0 [nvme_fc]
        nvme_fc_queue_rq+0x392/0x6e0 [nvme_fc]
        blk_mq_dispatch_rq_list+0x3e0/0x2400
        __blk_mq_sched_dispatch_requests+0x20a/0x15d0
        blk_mq_sched_dispatch_requests+0xab/0x150
        blk_mq_run_work_fn+0x1dc/0x2e0
        process_one_work+0x944/0x1760
        worker_thread+0x5fd/0xfe0
        kthread+0x36d/0x470
        ret_from_fork+0x653/0x9d0
        ret_from_fork_asm+0x1a/0x30
