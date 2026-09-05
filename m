Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC251DA60D;
	Sat,  5 Sep 2026 06:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590416; cv=fail; b=JptWfZTOqNefwvZj6S6Z9Y35E8qlJkiUJ04ZbAh/sty35jjcS8JsIC2exYNd9BiZXCUQ1AiaMV0FQ7vYMtmelAtw2m6oJkMfe9YkU3/zC7aV/XkRtcT+fGSaw5W3RJQI5RdTd8/D4Nzshw8BhkKEbCkDdNm5sWVwamUVu9l0Kds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590416; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m6zG/qnejyiRChhErlmy7Jk9GzzXoBEARbQ64dRKdhFoJBfNdg3H2RqNi7ajdFPrJUaGI3ZKi733rLpKP6oIYGXZ00z4caccSz8YzqrpkreXnDO4CZ4U8y7YXTdATwbCaY0hVIy2xIBo/3Jvjn8jhX0LolsTuF7DnXXbPVw0Ehw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oezekMLC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=hCCNblAN; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oezekMLC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hCCNblAN"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788590415; x=1820126415;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=oezekMLC49Bbj2V8yL4hn4AT4+/tIDUtBISrMNT32AYjdbcgBSwFsdi3
   fvRKvugTny+9kCIbKDLXgrXi3yOMba1VjmUV3Hf4y0W57tcK5Ltx2bQRv
   PK4gno/8huz6ltIGgpctYm1ip+jOym99KVwKuHcZiWcX9vf1dc5NrG3tn
   PoPGCtuMJTTePLvITvDaCMj0tD5XxSb+0bRN+xoBGS3NRf+jnIHENTQMU
   zJ/3uLST0b3Poh7lRfkGN3TrX7OVLDyUYXm3Y97MHGU35h6PC9cMCCiCh
   H9lbD7zoE4Q9YJzryzxK8hjjACtosrMepNHuEz/H/7jhj2I3NUa+ZMZI4
   A==;
X-CSE-ConnectionGUID: GE42WpjmQTGY24082jLV+A==
X-CSE-MsgGUID: ypmJukahTyiw1LSmmVryWw==
X-IronPort-AV: E=Sophos;i="6.25,263,1779120000"; 
   d="scan'208";a="155004942"
Received: from mail-southcentralusazon11013010.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2026 14:40:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJQEG07g3MYIg+xZXLEYFews8GSIWM8fKRlIXLnFQhiwDwTpJAytEKeTzb3UiPGJzD+PobRSKXxNpJiz1DmIHCD2pnuxobVjj5axns1FTsl0X1ALdUuJL3GK/NQfBGJdweoqh8uyi945iM6YweOgmcR+TCk2Dt35LKvj09Pk459HEhfgEVoIza3N5zGGAe6cBBUj1SutLfvlOLIw+8/HlykLIMoXpCEYoT9zCB+hniurZp4mZiywCb0rsIsoVw21nyQEBzT3q32C1f1qajSNaMmMxt6tlEkR/r6ma1OKBALgdT1oBwn8wZ18R/VmExvSX4D5ooaGAUIe0CBG+YQk6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=bVahZaBVopX8IXnPzwgevmCJpk71MgOvQJk43lMI42hK5e+VypBQN0dYx9ZXRinOj+Cw7hHNC/NaOZ5sMC1PT24Poa0NoWZTdWXngwNfQ9M7gLWuz/G+xWU/XxRU/7ezUsvkRF3QBUfFhOQsmV0C056VZvz77mqxFo6nXU27xq9ozeyfRLPzbfBXCTMzpQ/hGG0sHaalkxggHyhnoYG7666faecrdSqNutoD5IvnKt9MuPxBx7ACkWpDvGMUxD7TGj1UPYBej7nKRva9VMDS4bSLwV5jYd6jHzLuCVroCA5O+MnOTmGIPOn3dgHnX4/O5rjqbHaID4sRgLsyJr5znA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=hCCNblAN8myxH1JcNMTJq1fEYDJ68nnavE0RdWWXaALV5jYWaMfxJvyP5I50WJNZq2C0lyvrZpNJPcHUQFmewowD21f2ACQxGZdlKxwRKjH+Q4YRD+aDdfjQKVMjyocugnocPy2QsQq9HUCFFdZaz395wrJ7oaDVI5qr3FkyTrI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DSVPR04MB9964.namprd04.prod.outlook.com (2603:10b6:8:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Sat, 5 Sep 2026
 06:40:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 06:40:05 +0000
Date: Sat, 5 Sep 2026 08:40:00 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v4 09/40] scsi: sr: use 16-bits defined sense codes
Message-ID: <apu5GynrGBCdaBnA@mayhem.fritz.box>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905032224.509860-10-dlemoal@kernel.org>
X-ClientProxiedBy: FR4P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DSVPR04MB9964:EE_
X-MS-Office365-Filtering-Correlation-Id: 9477d990-5eb2-4cb4-55d5-08df0b188589
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|19092799006|1800799024|376014|7416014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	mV/nLXunQEwCIXAcHCGyZExNivfszF2ldSHPpVmJ16++ctTtE7ftODmR2gmQUSE1UF70r7JZKqtUM90Sw6XDt5M0kTi7FiB9z1bESyXTUTdOWTx+LYi/2aWqg1Lc2Bnc9hLRqA+VqIwek7JSv4RxWnyM5hpzNlnxQylNOqVZxgshZkOFH3FHAhL727jjjZ+xNdfgmm6GhESXQpRTf84wfatGO47BhgXh7eBNU44SlqbKiOAchzifj1xgKN9N1w3ZZa0Qno3uicMvQwJoqKmqfw4dNRldfM/9QUmxnTP2xPaJezdJw6atptTQwoi+eCghTGnWE+wjOTG2+yXTtHWP9xKYemEDAtqqHrznjNFnbxeC+hFfeQ3BeODUlzBPh6GZIVt6kjSqns3avmxGJov0AwH0fPBImdfNasqvH1XJJiuZ5qUoYHNLqq7r9yYzUOZwSuNSNJDNonj0aQFEOS2VPRe2fTG5aiJBChjv0qPHX/KL9I7yFoiqO5MsUcS04/skpEiUspEnyKujv79fOwMQ8DaUU1t42xPHxQtTmddIH+0z5v7RztzztpVShbMdDfwZbpo3ry5OAsXI0kBT1r8uspRU+7NCAZoklyxdlz70CTloWKYpnK16BWWXk7rLgyAN93Y7favQMgFJduAcqhs7nXFNgNsZzzbGlfbnlju5+C0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(19092799006)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4Kt35UOqXXEp1aW1TfuG51YzgCOgzpIuYIekZKwyKrd9S9DziOurhZi2LytZ?=
 =?us-ascii?Q?Wq8jgR/mrnxLO0lSur+uZo1muAmn/RVXtDH8RXNxXNNY9dmxro+aLO6CRD1n?=
 =?us-ascii?Q?DtmbejC0ozAD0Q03BqMRLkO7bkUiG1F/pbxRPQNdPKRKhIlwbuvb3Dg+YEBY?=
 =?us-ascii?Q?LnRD1Kyf5jNeOIPqgMepqsXppnGRx1X5I/QGPd2KNglnC/SN6PUGw8mamR0I?=
 =?us-ascii?Q?+oMx4grCPBd+AQmtO3sP3srRxwt+0qIFgd3ePs+mTYnHMqdrfnbeifONqr3u?=
 =?us-ascii?Q?zsM5k5kAms2z74TG4t+ACHPiKX1CJdb0uUyT0fsDmcz5XxIQ4eDa64X/6sIM?=
 =?us-ascii?Q?lAXBTF9QIvUTzQbu85AFNh2tXeOGmis+deFu8oQtkekDd7ad+5Go7DMm1Kpf?=
 =?us-ascii?Q?STkbqqhDKQFwiA/nAQRINZ1xEjzjpKjLsaiTDnYcYguAe4AZQWD1BM7Kn4ZW?=
 =?us-ascii?Q?9ZD5s6lzH+KSFSzu2zuCH71ZkctGB3S8mEf7u/il6BeoJLz/rPuoqhC5uyc9?=
 =?us-ascii?Q?eQeUl8ggX2l1KgQScfu1MeGv89UPzz+vlDQV74Y0XcY6++BgZ59EQahOvSRx?=
 =?us-ascii?Q?KstS+27IZ4LKCr9NF+LAu1YSqqrdSA9J22i78gfCoccnDTFjk5UrRZAE8gcT?=
 =?us-ascii?Q?cBuPPfZUi9BsKOXVXr/urSsYbRwKy5+MGarICkBv899hPpaokWWw7xFTQauM?=
 =?us-ascii?Q?icZZEH+n0glM45P12heTIxExXIwvnYY2Cc3Hqr4QQ6xzk+TPbrDnpTvglOPz?=
 =?us-ascii?Q?aRH+a3x2oUa+ebSCDMUKWG6TW+XtCrzab/aNk5AhQjL9HG6zd4Im42QCjcoR?=
 =?us-ascii?Q?ecqw5nI9K69gpGRz++24UKGPbP9oGu76K8aOZpI0bJEPIcyXJq0szUAn9f3W?=
 =?us-ascii?Q?YF+CZ4d/k9DPn0Ry4bHDBEWKdhtdD20L2nzCaberq5Umry+kRklyEhv5h/bp?=
 =?us-ascii?Q?xaj1om5jQ1HiS76vrY0XMrjCEWx+odmhJx6xx1PZ5qZqbp+xDCbuWujWdA/p?=
 =?us-ascii?Q?PN4ol5iF55S3Fk++hXYuX0eq73q66d3O9lpfiwNrSsxMleMGZafKM/4f1Xyp?=
 =?us-ascii?Q?u8fh83m4trnrkvZza/LFFP8K9SQvJWb9m/oXokdo1kxYyANCmtTqRHQi3FoM?=
 =?us-ascii?Q?7W8beuKIV3Yx3lB65LuydPi24ISW5RAPcbZcu/B+noVfRxUYoo8s6vWMs9XW?=
 =?us-ascii?Q?aXrfh1Zd6J4nC76UzlvaYhGjCibTO+qEuBb2xkz/0JKttQM8QZO9xgN5UoyB?=
 =?us-ascii?Q?ovTs3AYOiZdcrGc08N9KYKnFQyD2xM82mDafqxY6pehkgVniVJuMqzIqB/1X?=
 =?us-ascii?Q?pH7XCNXJRtpo8MrLuIRjuGqAq5wgcWVMnRqXTSTbEWKLCEZvMwC2N2a2IXFy?=
 =?us-ascii?Q?qVYfN0lEKVLk80HmTjkdonVpdqxmSbqiqXeXbdvINIDpKh38SAi9Dr9jeMcb?=
 =?us-ascii?Q?86S7BnmN4rxPK8ytvigyE7Jj0ZeQmMf6lXiGRnK+FkV1K0vJcvVK6r8eUCFo?=
 =?us-ascii?Q?2gIBOsrrh94uemOfAH6LgHfNasJpNj9AuwHPWQK2fxXn619PgplzZjjcbdF5?=
 =?us-ascii?Q?8j1fcCGEOIJvXH5YgYwIrs4tbIQRkZUlcTNh1HsjWnxZERZ4nGqP66pZl0bS?=
 =?us-ascii?Q?xHnbM+ZMsXMX8WF0MZ89Zq5cO1olYuuF4FZZRSzKY+YSdd4vyKc8dxl/tUPh?=
 =?us-ascii?Q?xWe75WrYjE2MN49n4j0ieVo3vr78kv8ibCjInX2sJg8pEm3MLhRtkxd2WeWZ?=
 =?us-ascii?Q?xdR050Nz8lFUklNJp/DEAuUUtD2X8STP5e3/SNBBkTFYwU0+hIKPX3Ql8jBV?=
X-MS-Exchange-AntiSpam-MessageData-1: eh/oYjo1ZetDQA==
X-Exchange-RoutingPolicyChecked:
	lOqZsyRcIDkhbV6Kt3129mshzdEWGUsIL3fLLrx7iSgM26dVpRlrJctWLSdTYTlF+lyMe/YuPRWzbVfw8YYMbiZksjDyA0e9E9zxD4Jvmd/LDkEF7AVGjJeO7mb5nkUxIJb5t6pMdo6x+XfcnXcPHR+0o5KhF/Ino/Fi1CREMcyb8lPtICgas5Di8VPGHVnpzF3OiwNSaryGgjFntM8e3uubjjr8IfMTIMvPr9T0oZ8lR9GLZmT3hP1gKa6IA8Jtv1bKjgGQj4BCoHsISlDVUterigD+yMlICX0/V78KQHw8C8FDKCw8Wm4eHJ4wE7qguxDKX8KAKueB8/imRobKXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xA3bgeBN/CASVNtFu05e35wNS3KjDO2Qr2q/EV+lWWObRY256WBurnzSvdZmHDhoW7WSY1u7ZuTdLsqNCoNFsQL9QuL5RENNHEpWu5cIODUzlUIHlmN+O8xLmAQ4id48rymvIFMOVacA5jM9ULhhScFilb7kbgnZhEA1eO7uYR2YWeRozlFkmM4c0tqyopLgIsheIHHTKMH4tZNRXua6cRm8sfNCAMJzDCrfz9TZKTbrq4UQ6V8rmytSSPTScijxOUKzdSy/As8UQL6CMs7tfiwAb0apeBElpXuTsr45Hh+4g1/O8uLdBCouisdgCtfPJCaI6rcBDf/w2TmNdojxofjk15eJWUdvN3neOoatvzPy7X3K9yMVEjShztESmwxbxJ9i2N7fOPpMVdGWnZjuacxiJlWzUlHL7j3hUa1OwAKB69dSB5+JVFsXEeyF0TtzbLkZWGXEVDfgRYQEGVm1diq3w2oOFNHne0DCnaIITPg0MaLCCic9jdUQlFSmVKQx3bfx+1ipnIfUOFvgKcn86MTxcy2RcYflrIyfGxhX65e/4v0pKIjPp2NKpjb3o+Iy62UL1n8QpRI8azVIT4jQPjNycuGu81/sMGFxwSYxlj/vsLbpFI757wb5QFNodZ3i
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9477d990-5eb2-4cb4-55d5-08df0b188589
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 06:40:05.8046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oiCiudGorWLUR/auLyI7u+CBzqDUj3xi7oTkhCHfwg8VcLkEY2PmYazH+MiNmDsp99/Cy1KhDeXEsrq8LREI1gqWuyU5X4XaNm8qcDCYBrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB9964

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
