Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5A343E085;
	Tue, 18 Aug 2026 12:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787055094; cv=fail; b=Vdqicqh+xC/eTAN6977CaHgnSy3UKsH3epdjFoGsWu2kOl7Le2HVxhLHLPtD3w7o4EhD06D+UPZUzSm5ZePggVcmttf7eMKVwHJl8p7AOO/GHf/sHULOFf/Ms0TNiwsxDTzXKd9+j6JVVBVlOFzNH4jZhDSQhieiax9VhftS12Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787055094; c=relaxed/simple;
	bh=ZM4a1NRrx8cp+YG8ixYlxh1YkD/nUh7k7EQ5gpblINQ=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lHI0w59G5yGnKsdjdBZyperWsNvnt3SZQFGneW0+n0oOTSH65739+QgowZ4DrE0zeXuKF24KfDF04jCmIKpi6qczYuZFdWhK4c9c+7/2puZR1X6E7a8m+1FkKc8hC6PnSCIuWS39+Zs3+YSMAFuJEl/Fjd0mXAM7lPjqRvbzNKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LdoUH1+P; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LizbLGp+; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LdoUH1+P";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LizbLGp+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787055094; x=1818591094;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=ZM4a1NRrx8cp+YG8ixYlxh1YkD/nUh7k7EQ5gpblINQ=;
  b=LdoUH1+P5ASEWX6X7mYlaB5oNDZ2nduSE81ZaqTIsb3Rn72NaD+3Yeum
   MygNFgxLy9xBoEcH9y8/9erDysv+vc62IcKRrMmHrXDGtNVOJia9m+cQO
   ubXr6xIFP2wsotJ6nBZyrqWzhajYStpTCZCRi691yGbEyfIizLNSmmAyC
   XKts3dNa6MeBOrOXV3F4EkoPSs/+CnHgtgdG5PVI3MyY5KFVBuC1/TuRq
   G1L3h+CG4WL9uSlkHRi+Jp+FP60sTC+WsGYXz6sgQE3DHwX2Aa6Mzqzt+
   gwNL3vV1yliU478fNF2Na8oic103caackD2t6XyPH4/u60Xgx7OeybNoO
   w==;
X-CSE-ConnectionGUID: /TYQqBiPROiT17KnARqBXQ==
X-CSE-MsgGUID: Arawe5XBRx62ktOlybxR8g==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208";a="153543912"
Received: from mail-southcentralusazon11013061.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Aug 2026 20:11:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5kUDg7J7BQcHv6ReLnKrShn/vtjcGXEKSr+tzgwREndLmE9EMrZD9ZJQElr7NeurBgqS1PUuVKSqeoT6y3r+AdSv8E/C3Quo9Jweetg1JpRAy3s9cqNvCrlmOE076e6ZEN4XrvZjHdcfgdmuTouVswybYnzpUPRqG23gelBPWoQenBaPpDpeAoMlBkdiNusD7LVx634MJqDBTVXYYlbJsbMG95gT7ziF+HejdPBsHe2ZFio7ZiDlBoD9QqGU8rHTff2TnjWW8CrfcVcpO4W8a17mOrdbxzVF3pMl+rMY+NGIiXCrl5nrGk9PySFuBehGoocYqQD4STjVPlw13dIxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZtt7eWMnOVxwFtsCNb7LqJMqPu5YMlVSZ+OO5Vgaek=;
 b=IPOgMeX2ITj4Jd+C9F9Xfu9MkFgVbeOhSfJZvnnB9Ae3RxWMo3NKj8SE2mz2/Nc3P52i2Mc4DGOBYuT5FTU0+lctygiM/k4USUj36+CZK8jkCyik5PN0PGHpgNu0xNGt+srZc3Y31D8r4IXso0H25uo+HQeg1hD+zLY24uvqZ2olDJn8AFNvTKwc5FVBAOsS1kkvecJMx90OmgPc6vy90zYJWAiF0wMPnQ9dGCwadkN8997LNt7+41Ak1S/rz1k2uyGpjs9b4DbGShySXLSW7AM5BOHyrV5dnpsTvOUA1VJrzlCSklPU3iReHgc4IdmRWIaTFyDR1+08/gEU/2twHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZtt7eWMnOVxwFtsCNb7LqJMqPu5YMlVSZ+OO5Vgaek=;
 b=LizbLGp+ktVvNmoNrWaiWf0a3XI5/gV1945TBLg7RAjWKazsygrgiy0k3J2Uk1ci1iIaRZo8NMuoLiHsmrpFg9j7LvVY6sL9NZB9ARjox8jNa/RkOOQOAsLBkYytmjx6oeKhRxF6e+52A1tovHka/o5VPbY1G37QjEk8e10bBkg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by MN2PR04MB6749.namprd04.prod.outlook.com
 (2603:10b6:208:19e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 12:11:23 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 12:11:23 +0000
Date: Tue, 18 Aug 2026 21:11:17 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	nbd@other.debian.org, linux-rdma@vger.kernel.org
Subject: Re: blktests failures with v7.2 kernel
Message-ID: <aoRLc_etxQcbfd6f@shinhome>
References: <aoRGbVB70YCcxoxF@shinhome>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoRGbVB70YCcxoxF@shinhome>
X-ClientProxiedBy: TY6P286CA0027.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:3b9::10) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|MN2PR04MB6749:EE_
X-MS-Office365-Filtering-Correlation-Id: f51e0b7a-0586-44e6-4c89-08defd21d1fc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|19092799006|6133799003|3023799007|56012099006|10067099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	nmgwOuJ/rbkT1oEs5N6/+erAqOvzd9ODXohPc3RpTFCtmfQeIkHnFgXqTM4lGkMXVvl8wwS1PdXir1S0MWbQ83bSg35MfsiFrMnLH1B0U/U12L4lt43mHxhcDtXKJDM8xmHaqc4mjDSthZWNPiAWYu0EcY81bklPrQpXy6wBJXip7ZuKyzp6OFlLYw74RDxfP/k1VPUdhzhnTTswHLVkuiQvIjGz3PoN2Pnu9h4jKKJ7JG5ubKjFaUYFURLXdu/zkD+uIFauOg8CQSg/IEaqotvVSaDQ1215G7vw7RX4xg6fMHcUqB7fAVbjz3LYmGrKIbMYQ1soIaHPjWOFPyywGxPzBvSExH9as1dt6aZTlih5xKdB/sEhwW/Mq3wwUOzQtL8XF6mAWPrHrfUJSbwuwAAElppmRfE5INaC8IuMRAt5eI13p5mor9268g2OSnC2cjHiriYo9dRaPDywB9YLxmg3C6NOnsAv3rAXIwHEr+/6eKzLc3D1x1rbdB20m+nTRESjhhOMAc6Yvj3hs/Uhh+M/0EED2K4qDOnOvOgsGQlhqocDyQ1xYJP3QAI1ZwWmkosLarDtchvuByEyRzb6CCfcl/MNF7fK97Z1ktoi1RLSEBDIWi76jDY0SaHyudM/ot3Gt89rx5JBD0oSdlGheT3VFRptHa6J3FRnyZ5riLk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(19092799006)(6133799003)(3023799007)(56012099006)(10067099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zHf/eEz9iqYfPPCSBMoSIcx/gRrPKFCTxdHJzclMAym4jAoSSgCAHrKuwg6j?=
 =?us-ascii?Q?O/a8p7JY6Q3wtgM4WgMVJm75J7cHoWJABMrkJpLqbEk9Rh3FhjCEwyFm+vSJ?=
 =?us-ascii?Q?Ul7xpymSDveHc8f6MaLXm+r9NjJbdX6WSCE2OkZBRRz/pPOo6V9enKKQb+NZ?=
 =?us-ascii?Q?7JAo7PMLUVFQKXds2FRs5t1MKuBKCWervWLNDj0PotMIJ9uEWVGhuow8DIDn?=
 =?us-ascii?Q?Ef4LxCzOKlk924D8bNCXRa7KBwqRubxIi2Wf6EKsbHnP50gNx/cVOv5/J/1j?=
 =?us-ascii?Q?B9zsAhcAL1tm+q6b8TYB/bI/SAKZPjFx7EwwLtJYt0U5Y9prgCUB4UYZTGZo?=
 =?us-ascii?Q?LzQ5RNupcABuO3IK/gIgEEq79QwPhlhiyQfKUxh5M249QG00ARoMJUp9nekh?=
 =?us-ascii?Q?yX4BZQZOKonR8DyWhp1ORZ51HHnVXyK1dzRtwSZZNeNA2qvx7XWR3f87HgU7?=
 =?us-ascii?Q?LGVCzfHsv1rFyHCc9ZMOw28R0WEYEt1o7BYmIx1W0+EaMXxw9d/jtX0Shh64?=
 =?us-ascii?Q?+2A7LXQoEnuc4KuHEOjfh0TEBq8qu52d9WqLeF2qhENSmXDU4GQqp5tyMJ0o?=
 =?us-ascii?Q?FCG1MCMoyiDmuqJ/5OFRD+fyKWM0FpEVFgCapCHQYLSCMuBk7C068UCvVxuq?=
 =?us-ascii?Q?bd2kq+F/fsQqOuWCB/nWrnkNOpVz5uF2526xqgakcUzF8Q6L3mDzTGIi8JPZ?=
 =?us-ascii?Q?uUelFqvHIcWYJidWrUVcW1ZSxf9MoACqy39Cq574RThcPydjrY0N6eS/Ik+A?=
 =?us-ascii?Q?JdF0ojLxRMH3r45a6v8N2BF8PjOTwUkUmwCIQVM3IjZ5LVNfQno4nVElh75l?=
 =?us-ascii?Q?j7+2VRup7jAqgw5uB5Rq3v3CZ+0Vc5EAW0nvCwpUcps5wPPr7S93L38Owlzp?=
 =?us-ascii?Q?GJqFrKqzqwVbSFZT++wWTPwGmS7UbRQAIwnlqdXVDh35UTcEPOxNiQCVURil?=
 =?us-ascii?Q?4feEwf0VDo8E68hyVYTBZNcTk6AEp8bAUn4+Um4FHVQ3yxNd/Vg4ypsfv8Ws?=
 =?us-ascii?Q?8f7J+5rfDunVRDsJlbh/U5yCmhkGQI2B6HXwrhRdHsNOJFpeTTX9xApKzri6?=
 =?us-ascii?Q?74QbEblksJtD61tj9sOhAxQHd0fa4zdfdKSWmTX+TKls2OuzhOk1y+LvrSuO?=
 =?us-ascii?Q?y8gGJIZLDRG4GVhhkkL+sHetB77ZkWBu581mnaTZtbnvq5yjtxJ7FzIUhLta?=
 =?us-ascii?Q?nQIY8vwoPvab+AZbr8aoU6noPsOCFXC9zfYw1JNbcBJEKDMCTc26ctLju8yE?=
 =?us-ascii?Q?oKQwTH4un+JlwpTqLsLdLHiyblwIFbcQSPePubtusgCfdYJznt/K/G9d/V0L?=
 =?us-ascii?Q?z2VssjVDsYaXwNZzgwLlsJPfPMs9CnUDD2HppJcgWUBrSExK08eJ/PWAHvvv?=
 =?us-ascii?Q?W8PIEIGSMitT4oFG2/uHBe41rSBDQsL/E03rLx0VQ3wLO+Ww4Hjvq37CSuY6?=
 =?us-ascii?Q?5XIIKdYMbxq9dgZsMvooHaH5OowfD7gTrFBK1EIDCvhJMRQy4b+v6ZYOuvmV?=
 =?us-ascii?Q?5hdP+R2MbHJ4sAu6vBzewrnFQMkLJKxr8CGNheYT++nkEkwdfjR2kBCLFZpR?=
 =?us-ascii?Q?V2QMMyV7CwbVERMct8PdUNvICh24OLj4WIoEJc8z26KC3SDFZo4VJSu8h1y9?=
 =?us-ascii?Q?AhXjUUIUCuO2tyyNoeTQCnIEybHp8KKOVrK7ipU8ofQKB6jeTCJ7fUwAte3r?=
 =?us-ascii?Q?uqrJ7JMEc5C3uQoVGOf9mMbdhWr0tp1OzZRhqFOncCEy8TQ6x6i9LXNFvI7E?=
 =?us-ascii?Q?nxEzu7Vi+wsQiLJ8U8U5xsJtizv0OU4=3D?=
X-Exchange-RoutingPolicyChecked:
	fVdDc5EarSjbauUNnJoliOFgx9im5ST7f5xqB7Z5IIBGgNu7Y4aRoRz7+QKrGZXjONnA6NIR+q1VutKTRzOJ8OI8K3GPKSIpiaTkYJUpzZQNr1xj9Vkx/qQKV5lJV9YduG0VfMOtsE2EJeDmclO+3q87RHu7LcFNp4ns1M/+fAiHyRgTFocyKFGg6D+sRnFbC6GNIldFkl8KQXu2DQrI6V2+W3iAbEdwNiJAlSl3kh+Fv8CEOUo5kXLyTvvTzBtCqEy0s5KpXBg0g/DzheqQrbJwR3ZbvauBy/jz535PiPpiJCuO4eZXPRt8YLk9yw3BZUClKp6XG2ad3dXt4JeXsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ovGh+NVNq/OVLgA9wmQGPVpzDG6ZUEAnVN2kyrvi1PRB0J3R7lDhrhDe1koQm9DOEf26Dwb95JY5Tl5CfU/mjH2TOdDaD51cqyOQbZLp3jRV4QPNR+sotmeNtrDC+qWcm17Y07F3uY8NQ7DtLtVbO2idjKG0fcy8MVJqxHMCyEIw7H5mPomxg+nKVDN9hTVhAYrj0MPGlKxDsNzpJBRAfxwMzxfDyGkrUaTzw/pwFPF5IoH6fuir1npivkqLQHI7l8vOiobw2U49yWSlW5c2rkAx+RiI4YYNE2znJdtHg8+BTe0JljWqheAmFTZtljgPpxPozTfgXdg95gWlHaAKsHtyimd7XbtpAcFXB1K/uTBnJP3vZXnD/D1QS3vB1VcnS21clIkpB5Ag1Xg7ZPTAZmNTYWDSI74+UHoDguZ0V/4+X8nsVoQ0FvPMW18uRprUNAtiH2tDFw2mgO7cbcViIpTQcFMm8k641MU7pvxCmixTsuM+1Iv9DHEDFfk7rjhGVs+a39DXg7jXtIm6JKrDa8L+3VL8ILx2WOJl3pcsvPdomHvfmx0YIt/zk5Zg4Xuc7bmK5g28fWipyHpjyRSLPex9WCZ6b6iZgjxXN91rwqbGTf0C7fybAu0cPgxW7M50
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f51e0b7a-0586-44e6-4c89-08defd21d1fc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 12:11:23.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRFe5Ys7QYFSW/2kxP1NCtIxWd8umHftFHIMD0BeCO0E3iNHgfbTACQ8qp6SJ8UCmFpJagYS9IcEQpyAl6U0E6YQKlUMEoT8Q0uN0Y/ZioI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6749

On Aug 18, 2026 / 20:50, Shin'ichiro Kawasaki wrote:
[...]
> #3: nvme/068 (new)
> 
>     When it is repeated several times, the test case nvme/068 fails with the
>     message below:
> 
>     nvme/068 (tr=rdma) (NVMe multipath delayed removal test)     [failed]
>         runtime  10.979s  ...  10.975s
>         --- tests/nvme/068.out      2026-05-21 11:44:28.070959369 +0900
>         +++ /home/shin/Blktests/blktests/results/nodev_tr_rdma/nvme/068.out.bad     2026-08-18 17:51:30.262228567 +0900
>         @@ -1,3 +1,4 @@
>          Running nvme/068
>          pwrite: Input/output error
>         +module refcount not as original
>          Test complete
> 
>     The failure is spoladic. I'm not sure if recent kernel changes triggered
>     the failure or not.
> 
>     The failure looks dependent on test nodes. It was observed with loop
>     transport and rdma transport, but was not observed with tcp transport.
>     This needs further debug.

Let me amend this part. I totally forgot that I myself chased down this failure
and posted the fix patch for blktests [*]. No need to debug further.

[*] https://lore.kernel.org/linux-nvme/20260806033146.2067433-1-shinichiro.kawasaki@wdc.com/
