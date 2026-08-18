Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAA45C6E9;
	Tue, 18 Aug 2026 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787057183; cv=fail; b=QmKf1xnsvLUlxU4Z8JANYyc/xvQTPczjR3fuVTJgoieF2BwP9jIhaW/krMlZt8e5DzXA/x4n1vw0HD4Q+E8NmLPQJjE9nlfolWN0wSehyKrqTCFRXTiZ+lNbn8hIY7apyI4qG4EBI8TS/QzqlliNp1IcWaX5D+xJyMNKUklZ/x8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787057183; c=relaxed/simple;
	bh=PlNn6CiSh02R7bYvjuKd3HzS4akL+TiGEU5NLXPDyGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WO+p3cJvNoK0m5fJ+ySSLJTO/nIeQIzAYckQM3LSFaF8V5faE3miYTNT7EVD+B/Fxn2CTM9GRduTGgxVJB7sbyZ/3OAK5rlrZEEW9Bn2lXIxDrl8d6HgNmn3vsBNqjx5mOKi/W2ITIVfg2rzwNPpHK9mW+ASiYrTgMcuR4Kc47Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=g6cimooe; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BipNdufV; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g6cimooe";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BipNdufV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787057180; x=1818593180;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PlNn6CiSh02R7bYvjuKd3HzS4akL+TiGEU5NLXPDyGE=;
  b=g6cimooexXJ/jfrn8Y2rWGih0CC2Eez2uQ6lMo2iT0lJdOhBxQsN5bNn
   nOf/sF+2+kHuY2YhbFFWLL5PQWYXzBnNtTgOWVB0g0NySueIOmCyUtPho
   KPLG10js2a1AwxuW8erFiflUjT9NiaI64iEu+eOnMloyJ/0Bzgsn3QCBL
   pIITBw7ADE9QM5cdXT7TF1z/lvXPrqoPRlpkfu+ArpSOGEjC4/jUaMiiN
   DnZl88g+pKyfhJGproHu7eXDfOj855MBsAaWc/hv08GeTsZpSEqoiOuHg
   13F1nlpXNrWABoZYDC3Qx/Dcmglz91cG4CEYkTLxiRzWMvuuqCF63AklS
   w==;
X-CSE-ConnectionGUID: EogG5zbwSI6ANoWA0hFJcA==
X-CSE-MsgGUID: WxvIdN6QQE2wg/ukVCzlGg==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208";a="153550068"
Received: from mail-westus2azon11012011.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Aug 2026 20:46:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvW9v5pXXGDQjkz3Og9tXDRHeokgqn5XAltu0jLatSTSaTXgwJ/OIWvBrMpEISMs70qt0rszrKnUv2yd1kVs6wpc8QU97I1AHge2y4NGruRBPkaQ8NXkYwhKabwkYxO9V4JKhNtdu6w/K7Ow2OCQaltzzD3RbKi7Rf7olsNywWOvf+5+8+Fp5tnGkzTttdYgRwRTQIrUzlPmW0RmJzM+J1PpqrbHukN5Sci4Bu9IkyQ5u6QggJrq/qYCK0Cwo1a3rDmWpAMyE6HFtKRAYbZIhnsaN3+D4PDolwhzu+j0nMeGydCoK0OnOgMaNzFNBhlm3rcl1nu/4LTS1ooKqvfxyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXltH2rT1unsh0M7fIa7epcO9OkFPjRDvK3g4m3i1JU=;
 b=NJAtpyK6nj3UTCrJhDIaIsB6OdQ24MpKvLlxYRtMLtibYJK/WJUNzCFHqTAuKMqCLT7yn7t496CIqKO6C022+QrTA+veKryOzAbq63cqYa864oK+eGTBD5RqZFRLRiuhfj0NoARZr3+GHlqvQMD06sLYLW+nqOUWnFPEDf7/ve0dehbtX6hnwQpOQaOJbbSuV9onC8uOgawAXPNReBgdgmaIxBap469k8AewbqSdIl6ilaoSAVXKSNZQUvpq2/M8OJQ0HjsBIRwpAO8txOoXavKZoxjjeX3FFdG/kHm5twEYGmqfTcZr6T3p1W0lT8gKJcrxFjbTVC/f+8sld6iFRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXltH2rT1unsh0M7fIa7epcO9OkFPjRDvK3g4m3i1JU=;
 b=BipNdufVDH/WfOnk0YU2zP++YsxkKTJo/83REZvUI/dO+mSNSgdl90sla8b5CF+lVZx7Fnj4YyijUttEr2bRf3IyV7erkK3RfYBksFKuK9FfcGLZvXAD7zEb50Wgnv6R1CVXcAO9dwsF8PGtyAFkQH2GKBCLxMDJpaUAondp8ZQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB7021.namprd04.prod.outlook.com (2603:10b6:208:1e6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 12:46:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 12:46:15 +0000
Date: Tue, 18 Aug 2026 14:46:09 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Ivy Lopez <skunkolee@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Ranjan Kumar <ranjan.kumar@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node()
 call in _base_assign_reply_queues()
Message-ID: <aoRTzu2C54ksvO77@mayhem.fritz.box>
References: <20260817221300.43286-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817221300.43286-1-skunkolee@gmail.com>
X-ClientProxiedBy: FR3P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB7021:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c1cb84-4f84-4930-310f-08defd26b092
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|10070799003|19092799006|376014|7416014|56012099006|10067099003|6133799003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Kigz0np0R/P2Hozuz9Ak4Dab4X8qp8nFPNoDtL6NYpUeF+2JuJNo83YoTvL07CA4+MG9pE6wWJSdjaBPRXnyySYyLPgm2tPjxTlnSy/HklxkViO1PE4IwGmfaFW6bWLdmjSj5OlDt5htIYk7WYplRJTK0pvP0hyjfxHqsSIf/1aZN9UHBgQzchWOJJj0RESzqL4nYLAygK1F7O3CmOX1BvilzmMFGhWZO53RmcAY5zPNpszBBfzz2gzk2X+kWZKrcAjdL3moOewggsZDtWjEzSVXbpzZEi2JoCYeK4mKifXIm3ki3hE/cUHejTzd+K+6nH2mHmPg4cfDeRYjaW0SMeL11LS+vZs1N+xnLyYcHZwNafamJ1KrpT3mpjcf0k2l5wFEgmjnENWtcHtOZgSyY8QVTSe3s/1X3cZgoN2n3RpfylHw1OvEek0L+pV5Nry12O2aahoOc0rpPV1tS3RsuH1XbIHIXyOiXEysgIrSMjZKP74eBFUT8vmOGSjTpv/jldlS/Y/Q0mmC9oUz9LUMUBwKUT+iOiqHHW69TJO0oWehV00YuqKDRXVxCBB+qJsY3qb8MNiyJwWtzh4RrG4QZ4bNvMxGaV0s5d/ty+Gcw3sDXjZ812X4v5A2HwcLO3S+DLHt4Io59pq9raXMocuBjfZ+mhpSvg40EF0nk6XLEkw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(10070799003)(19092799006)(376014)(7416014)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rGEn3fjJuQdvPzCPdassgaFETKj4jdnVmgLOIetwfeoRxkfMQA0E2UjKWWcX?=
 =?us-ascii?Q?9hIrMTgFlqIu7SkLin3PLsPm1IS2KQAJTeB2LHCxPSOiRORBgTfKgW5IglON?=
 =?us-ascii?Q?BvOgkcHZ8RZsZzLCj+hgkD24oBgrHl6XMRkIF/sGQYNh0VI5ZQGY5KbuKVK9?=
 =?us-ascii?Q?4KPjwYecYm4AWnKC9uLxUWl9E37Gx5WCqsupVv7XPWbe+GxbhThT8pS0UfHD?=
 =?us-ascii?Q?XGF3VW8erxnpR4ytFjN64PsJm5W/U42EsIV6bRwm08+ai8rFIfs91LPIUZfi?=
 =?us-ascii?Q?js/2H3ZRuKPEFPsxplMppKazRFpC8SsPuUPdXXtaUCrTf4TY06HYmJZn0slo?=
 =?us-ascii?Q?/nC8USXliw15HWcFvs6yWS6yDTqpdv4pf7ocvjKa7WZNqDESxzUk/t+TfTqL?=
 =?us-ascii?Q?eUpVDyXrXs/RpiQsHAQl1GpH32PO1sP4o3OMtnQ/6jbUD9k1JGMQMv7anQ+m?=
 =?us-ascii?Q?aAldv4pykwciQDLV6u85ko0oW1bhh0pZZdsiLcECNartheaJ8M0php4taDyp?=
 =?us-ascii?Q?2SvrxWvzEUZHrAARlyO6eWPNr6ajKUXco2SGfq4BP1BOK55ZXs/6XI7cSl6C?=
 =?us-ascii?Q?WxMR/CqfkVSXekVvHByhV4Tkb3TNwXf5nJYCiEuqI03ieeipTsb/EzqoISbW?=
 =?us-ascii?Q?aAuwgCLjvNHkMJINAAgvSOIX8pKcnU0e8U+zrAxAs0vpE81Gh11G6ygXzRNX?=
 =?us-ascii?Q?vykxWI4fUrBrSWqpvTa6QkXaouW2EquM/jWQSh9QRZUv5p8RxHESL7BFF9y1?=
 =?us-ascii?Q?tvsDaeHBOpovfnzlVGWtKYPngOC0FR/8vycA1FdaNblZUsd0UoKRSS2Z9XAE?=
 =?us-ascii?Q?jy3S4xGKmf8GP4zBy3guXZiT/Mv12z1Rjv3ijZoIKFCw7zV0ttKCcxkaT6mQ?=
 =?us-ascii?Q?9D2uo7kJqmurOqU27NiNGCra5h8vbq/cKemBr8P8VyY+pxJpSONKghl9SlG0?=
 =?us-ascii?Q?0PYV/2ZDroCHMJE3qozM2xMjejeExf4ILVsG+7ulDepXHfMHokXRIDA72BRn?=
 =?us-ascii?Q?HRhmiRk/YlCvOpmbN6iV2uokquh8TKTPppz+x97lVwstB+OoJQrCGDXh+XTJ?=
 =?us-ascii?Q?mftfm1BSm1n8X2pAlZXoQF5n5HQvbDiL1L3ra+6gJtQ0go2v20W6x6XZswxz?=
 =?us-ascii?Q?J4MQ0cm5MQcW5v6vKAfKC7WiGgE6+tu1lnoh1S4EVjdbtMLLkilyFC4SL9K0?=
 =?us-ascii?Q?/TKN7Tm4shmTjW7lZFt+TPOYMtYEqhafmvfzvm/5uewR6+KkdrBs85TO2F5p?=
 =?us-ascii?Q?AQCbpg9SaGceXZ3UpHCAtvpGShKaOT9qowcJqiqKJWvIxykkAA5Ss1mV8FDx?=
 =?us-ascii?Q?FhnfeeOVYkb6nUjKHE4mzyJCTeFZBu5ziita8p8/iXzr52rb+Eey3E2gYthc?=
 =?us-ascii?Q?0pFt3DdHiXlUv8xAAj4bbIZ3R6MdjZPTV5qBYmaY/FrR7mwryaRBkC5og9b6?=
 =?us-ascii?Q?mPZqUTGY8zglHOwaeQlvYuyXTKUqeicE/3sRxKAidm2aQHhjUL1fTt+dzpOp?=
 =?us-ascii?Q?Y5M/TPxBTlpPI8lj51Dl5mLRudoSE5raSG8xJduHPFktIEC/+4jQAR49d/bi?=
 =?us-ascii?Q?rNt1ZvfqPHAo+FKqtX1vLKhfYgj4uIG51T1TfouS522iIfIw2MGkCyu4rPhb?=
 =?us-ascii?Q?ycSpGCUMU+VtvkarvEdXkZb6SEevFYo2aZHqNflZPRHG5B6SSzooR8jepExD?=
 =?us-ascii?Q?nFKy/L78LHqkmywBbzhF7fa5fyMY9E6NBu7PwHnW1adtGfs+ra79SyNPd7Jj?=
 =?us-ascii?Q?d/+4VAjblFagKnZ9jMJgHG8XStrsVjFL2VWQ4Izcm9DMBsmsmaQgFTTbpzG9?=
X-MS-Exchange-AntiSpam-MessageData-1: LigN9tyQzq5ch7Dv0g7pe/5rADKwg5V3uow=
X-Exchange-RoutingPolicyChecked:
	gjcIosxeyl4pnZYBNYTAhsquq7l6pphX+VewfgKFHyBeB+E+F927et+9/ZuTjZ46e/BzA11g+M5gj+0IYcUYjWvo6crdmjqN9dUzirBF5MQG6xGO43fa1xVUorgyRQ1XpA4F0M0fjSaeQq/GWjbDbq6x+jw7MiIrEzzgUXqZRwJIaslANOnYh440OPGX36Y1TOh9Cee0bMUXBxm+/9f6n/iiWLZEe01QKTUFnYTO/tXjfnYUjKL+F/5U6exyUDPSuh2zMiUM/EJBGThaiVEdbCVcQjce6S9Xj2RvEV8IMd75TWpCxh/50+LFTdt7BysQI4mnBAicH8dsJBcMGg2Eaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9tbqwjyUGZ6uT7ne0xheFPMc3rdLPcuCYRedi3Q72svZSvhKmt7/BfFZAt92Ct84QrhYgDgFtpGmDhfKPxaybwc7GGUu1x6kpxxaaZGzm3+Xa9p5qbN0ZWUCZcXUQLRKjn8RhUgaDBTXaVDoAjJSTaUYJs1d7WoumxZsE0ghkSSRTSiRVY/xnigm89oHVpTvUyaGKDfOtMjlwN59RUFoapibSbbdn2P0Xqy/ypteKTSI78aVVQBZp1Vh2zrH2masK7J9xSE6xKL8v+nJLQxi0YOUsSeONtUggMaOKTeVYCOXE8HKbBz+QRtqFVurwDQ7n1IHif9esJ2IzIomecSApE9QOanvE9L9e0G7eCglnzDR217ZDL2w517qPNcnULGXRKJehAMHWKGqr3Ikha58exC9iIcvIFF0igskvmfxS+qUDDHA4yZ+e8CdO9KZYuiASGWuAt5p72KXoFfDGZ8Iko+6qF+skoqBKzQSOGdQFAiLyuu37ZXDItDkIPr3fICNS9amQ/ViK0WCCjB/6sL2NhYHqX3fJhz2/rFzJq0wCsel/sfxgtqK6uYflJEQM1u5zChJb5zNUBZJ6qUUoxM06wUkctbg/Fd0WMtJB5zqibs4vHROQCnYQoDwPF7a46lw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c1cb84-4f84-4930-310f-08defd26b092
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 12:46:14.8791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9CRkHo0UCB0c22VjlUQzHDS5dUV+XlpRLcxojHIPir6T/sRd3yJd5UTsA3BBjR9mY4Z68CljgugZzfB6ydZVb3WwS3TCqZXGaMb9nebC5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7021

On Mon, Aug 17, 2026 at 04:13:00PM -0600, Ivy Lopez wrote:
> dev_to_node() can return NUMA_NO_NODE (-1) on systems without NUMA
> topology information for the PCI device, such as single-socket
> boards that don't expose device-to-node affinity. Passing -1
> directly into cpumask_of_node() indexes node_to_cpumask_map[-1],
> an out-of-bounds array read caught by UBSAN:
> 
>   UBSAN: array-index-out-of-bounds in arch/x86/include/asm/topology.h:72:28
>   index -1 is out of range for type 'cpumask *[1024]'
> 
> Fall back to cpu_online_mask when no NUMA node is available, rather
> than assuming dev_to_node() always returns a valid node index.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221294
> Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 79052f2accbd..eaad6fb7f3cf 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3238,7 +3238,9 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>  		 * corresponding to high iops queues.
>  		 */
>  		if (ioc->high_iops_queues) {
> -			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
> +			int node = (dev_to_node(&ioc->pdev->dev));

Why the superfluous parenthesis?

> +
> +			mask = (node == NUMA_NO_NODE) ? cpu_online_mask : cpumask_of_node(node);

Overly long line here.

>  			for (index = 0; index < ioc->high_iops_queues;
>  			    index++) {
>  				irq = pci_irq_vector(ioc->pdev, index);
> -- 
> 2.55.0
> 
> 
