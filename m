Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F07C36F915;
	Sat,  5 Sep 2026 06:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590615; cv=fail; b=qBWd3UHDehbjXH3QGrVBULYLlIv9yGnYYfkN/LDUdLWpHJIUM4Imj0tSWn0ArBXzvMbLadrBdshwyu2nP2ywLSD+v2A8kvjShDTv3SoCfJATVbnmu0Lpszk/M/0UjrMwlsHHyTONJgcb6T7NAuqKFHW98RGRwRWao+DzUKizAe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590615; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ldU2Yey77a+DsXNVG+Sv0bFKFYeMXuDL62JnBLN+ja7lIFxdAfUxr2w1Ijav7A5mzX/I4AmOAPuijIq7GAP+EQcYS490m1JiavrWVWAXZGQFd7MIUj9zJz6vNfy2M9OuRSvsagpAikngbreiOb630gSiPYEFyQ4fdBVxm9LF9OE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GKNNTede; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yvddCZDi; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GKNNTede";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yvddCZDi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788590614; x=1820126614;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=GKNNTedewOBJOi35T+PgZ3DxOKvbdsygLBzKLgE8ivZ0xqYx/qsEsgt4
   J9pZxUuOb7sXNb9xBnj6gQjvO6QqBMQDCTZCEhaQhJMYKWKr1+zxqIXsX
   tUkVJN4vdPI/jo4cjIaf3y0SAOyiY1jslTT8FPrVrZA17K7EZmO6vXb7D
   JVaY064KIHQEm58JKzsvV14Nultkpl5PYzEvS60wfAEA40/7sMq2/1CrC
   15sFfoQoTMCt5tGSBggTPUCL60Ghk5sUhid+mtuUnu/tp3THvZSjNslXE
   aRrQHe8mTRImCdArZnElftyr7kc/HO+0Rd+ahTtCTxayB3v6Aeku3fQtX
   A==;
X-CSE-ConnectionGUID: Y5sGhuRFRtaJ4V31nf/BUA==
X-CSE-MsgGUID: rNUFwKocR2uWMHvwcXEe6Q==
X-IronPort-AV: E=Sophos;i="6.25,263,1779120000"; 
   d="scan'208";a="155927608"
Received: from mail-centralusazon11011031.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2026 14:43:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QqjwP60DXsMYSDmodB15b0bEoziE4qVTJ2Nh1NIK+Ph+cDGdrcEvHg1zeQd1kuiNFip62Q5KCOtzXoO/6HfzmJKsmb+JLaAkGWhBBHwh3nieCm/GwwbqUHfs+xVjnvEOaY1maP/AEWtlViswyfbAKPYvca4QbjfqzA5NlPqIYUvLZzPXKtXLlxl1KexY8Ejd6D5YRDHr+jQpmWiXH2WXwTY62gioTHqgGZNHP54QsAlUPHzxGseYiucTciyfHbub+SXoQuN6Q8ZA+JJUDnNZds3C2ArsPDEXG91O3wZF9R4RIwZ0poJgcKfQo9jLTR3yhOoq0cQ+wSfecARFrLkGCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=aL3Jk96YleKZ9/5NDCecnyXGjvC6TtNMGSVdgJHteu9Ihsc9vH5x6XuzRM+yQAaAW+us+iB/62hPunb0JbpykQYmuUAcoZcd89SXlqZujhsDtsv8D6Z4k17aNtvyHvPx4NcaVKtlwWmwC8I0WeHFg+qQ4On8Hno0/WzLXUcx7+U4mSKU0T2zfEV5ge2774lL7tuzc+vKv+3Vynukur0pL5zmg3DHWSFKBVGLqDewy5KI8NIpo0PyKiPm2YABoZqeoiZwCGa1yxInzwm9K/1YVAdaD32iDLvCY6SElgW7hR+ATDNAasLod29LJKcEgfGonr8YChkpGGDPnHZOUdFfNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=yvddCZDiHLGjCx3359ucufvBFfP44MopeE0vBWWKSJk0kpsZ4L+GrtMz0blgMD0Jxq431KgpgTGn8qaCcjUFa8ZZ/09W0nbGNjsGaiFvTsQfRzHfys5U+e9/XrxFA5jIPVQwMErlma7UdptJ7Y6no4ghaWY+iVw5y/0B5Yhv6NE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DSVPR04MB9964.namprd04.prod.outlook.com (2603:10b6:8:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Sat, 5 Sep 2026
 06:43:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 06:43:26 +0000
Date: Sat, 5 Sep 2026 08:43:20 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v4 11/40] scsi: ch: use 16-bits defined sense codes
Message-ID: <apu56OT2MYIRKq3b@mayhem.fritz.box>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905032224.509860-12-dlemoal@kernel.org>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DSVPR04MB9964:EE_
X-MS-Office365-Filtering-Correlation-Id: df844a5d-798f-4908-8acc-08df0b18fd0d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|19092799006|1800799024|376014|7416014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	G3ORik/l03MDJGfyrUzZ/ugwU5hiHaisB2QbolZ3hHuUxi4d55XEaJvVCyIllT3W8F2ACpaL495UZm6J6l81qpj5a1nAw4OnmLTuvTn308aznzOGtoQSqPlaSBj+Hc0w4kkNo2JvItUPmXpIdEZns88UQAC8sfy16iHE7tyi7Gc34mgE0DIdS7D+sF4zGYt90pqSjp4NciQE3zBIX8uVQJ0Us4uXvL2YkZ/aPVxrVqhJTHFZEPEundN7by7DcWuhsyiYk6qfM2Q5C3XlbFlbG46k+H+tvIUSTRtjwuDCpykIgPaliAD46LOWFXK7N7luXaj5AyKDjYldq3PK1sh4lmevcEUnNd50qwIJZaieAzSFLARmdXYbnPIfgBnVAM/9dIyiZrnTdTTTun8qeqGZmAd7HFs1mO4GkuPkgN/YHpaul88es9fJ/6N44ODWPvFAeOlwMyonvAxZjSp77GnzFF3JAVh16tPB1XYHoIl1y8kyW509/Ih3UuEYZRjjXYDbeVFta4LSvw+DbngLui7BQ3IrAiRFVJw2QP/6cYAFsfYU7F7wpqmPu8EyjXAOBDlEMPv/vB7TQE+BNWtz/jIkNqIeQVCOB7gwaQWsDC9vTfCPeLKllWmDEJ8XP9jD4tdLDxvNV8BQR9Qxi83lLWo1TOgPeTYzkkKEh7+3ItLdA1w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(19092799006)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mkX9QpbDxE/1Ygh3JLqL35zH2Vz7wiTlgAWqgqLbsLfIU9QdoRYucPvT1tbF?=
 =?us-ascii?Q?1seb7ObP0We+CBTpTHWVZfs+Xz3AVhefQBRmB3YJStc4o847KSErTgC+dgSZ?=
 =?us-ascii?Q?G+FX2o1op8EGAQ+F1A0n2YBq9m6UlMiD5/dbzKOmOhQtr1VqV8avqp9woPQd?=
 =?us-ascii?Q?G8AeHftBuLlb5MnvzTdutG/McgsxlhcDHlRwBEU4B5g+mH6EKlTDfFUGFE1s?=
 =?us-ascii?Q?YSzKA97ZMArfoKw37Vtw+nKOiKobgvIMjpv1fa7UrtkFroqrEWooe6VPxXGI?=
 =?us-ascii?Q?njQi9eQqTssbLlFsaKu2Ep2MbzysngFJ/zVXCegedSggtACAFukICD7tJm3U?=
 =?us-ascii?Q?kRWgAwLYhcDrnDM2ewHIKfgRPINWmvhbo1QtyoLyMhTAtjiF8+G6/oq0eRZk?=
 =?us-ascii?Q?D1gaqiWff+3i+Cwefl5F7CwpckH2PDb8JmGBtTrLMwbi3XSlpqeajgMkSYlj?=
 =?us-ascii?Q?tajApOhyKx3B9M/089b2qCKZSuTmz7Csk9n7JfkJXt8irYs8D3V3Ehkq3Om/?=
 =?us-ascii?Q?HKpcNsPw2dF2naZCWkCZeXmqw0GD1o6MLUANzPSggCwRqLxwWcVptxihUJa2?=
 =?us-ascii?Q?LZIg8dngYDryoF5Oim6+dg9cjZx1fAkl2tg5EVJZW5mUK5sR+/L/pWKeJh1X?=
 =?us-ascii?Q?cNmiSwUHqVM/xjb2eJEKIAN1ArhkOH+RgSLBq+WvOuay1Zan2az6t4VkxWOJ?=
 =?us-ascii?Q?+a/K42Gi1/4/N+pfQu5tkhyZ/7C9nSUUeSgx0hyvMt6ulEGP5NXBkkOaL4YM?=
 =?us-ascii?Q?8twrceI+HNM3QVxnUqIhwCusOk3Cfz2TjrbCWHluUR09EpcWCViSlzCiy2MR?=
 =?us-ascii?Q?vNGKcmh7wgJVEWjH2+nCyh6PLIWXfIEUw3cyzs2LzxsWuz7sRKk/n1d6rDWA?=
 =?us-ascii?Q?YIJZ/zBWxbaMsb9wemDVs/bF9W2mQvY0NxuHTV+55IlYQPEaxHAJVOwppRHH?=
 =?us-ascii?Q?8GTuvJ+FDNeCRthiRntgF8s7Sq1BR6bnz9KjnMyV9W4+cAHB6P3nfE0qH9Ml?=
 =?us-ascii?Q?6wChg3ECnGSrz6xA3BvTv15O3zZuXx9GoNFC5vwJ/dk7LMP27pdIhrf4z3IK?=
 =?us-ascii?Q?Di8Dqb0SxkpH4fx5RsQjJkzjtcJK7DOWEjYhpzJsOM/qrc/UldfYrqfFBI1o?=
 =?us-ascii?Q?aWlEx5OCaRuDp2lFrEKrdkRNxhtWBSOL43Iq6OxpsxISODLgKcoG8za40E4d?=
 =?us-ascii?Q?bYCLOrtWRW+zcjYK0EBSfZ5IQIZ0cGQCcRdZNtcsJw9QfLh8Xo50VizCTbCL?=
 =?us-ascii?Q?SQx5rUOOlPmz7IBVwJak5SByaHLZDoBJ3WJ7j9sGUBkIY1LZbmf1PheNIA2+?=
 =?us-ascii?Q?TLeThJWijx8qFv1Hj6MXr/U2zWOQAAPvOODtD5ip9kvS7Xu6Da2rqa/apq9S?=
 =?us-ascii?Q?qWY6YevSzIKDgJS+4DSBcPHDl8OVj+NGQmzEXlW6m9jRMwlzFuXt+ltcYGMx?=
 =?us-ascii?Q?Fd5MS+T05SKTZxDVzdV2Cj7mVhi2Wrd4tQOmpmNjTMMXDLn7zYFJGCvjaRs7?=
 =?us-ascii?Q?FMFh2TooouCEpcO9qyAvy7hAR7yT58P2PS1XAbpNZKMPE39V5Xa/6gyKPEfq?=
 =?us-ascii?Q?svgK82CWyhkg7UVaqBwUTnHfA9KcFwK68zNLbsH2m4sHahXCJP+op3XUnVXB?=
 =?us-ascii?Q?OAKw/UMiI60RoLP3XHkrQSTM8FNEwcD76omn9+AzwaiYL0SDxxojIKpSSC8o?=
 =?us-ascii?Q?OGcsfRf71qzFNp9Dx/44b+ursSk3PocA3YrLVpwlQS9550lz63zWXV6VOvBN?=
 =?us-ascii?Q?10c7cKNptpBz0ESFUBMX+MPEOWA9b0flVxxg9Hc4NbXajqpr5+utCM6XtqQK?=
X-MS-Exchange-AntiSpam-MessageData-1: GBXo92QhSw6LbCQH2nBWmy98ZPfO9dG9gfE=
X-Exchange-RoutingPolicyChecked:
	xVdGsy3VPmMCeysRvw+K8mjG7uIgOSy94u//cqLQ2hyCsJlkHt7bcDehBcRUyULUDdDlU+yU/F8Je75v5np2gx8GXopWHEFuC+f8/a1PoulOegHrvx1PzU2itHJhCFoslaaN9O+lRcvtoey+CPv15sn+Wor4QOMop9xZQLCvedqCpkuo0U52Y188TCIVkkA6x9Ii7eo8JKpHs5babQlwdXCVNwAyWWbeUbs8+wOK9Hr6v0TO9OFSOmPPyV5NBs8pj4z0m+I4CrAJR5fmoZRDDDgWowmjqIaDij3PyHKjrg3m27y56GreNkH1zfdBzB26hn/aFAG43DPXxbAXBan3FQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pv/GWPES67xnjvLhd0GpIYJH8ahQVMdKBw3sxrxSZDFj4ISjJQoEWb0+ofWO7U/Iuzc/JNAhjjeTLMffXgUExwQ6JslYWC3M6emtVzHJ0ztRiTy7uG2a0Oh2lyj0DMScpQtu+QUfDZQO98iH4PDdOF5Jd8gMs684GP4AtarEqaHipcn1QOxwBDikFiVA9SQYkVrYsfW6+i6iU2SYA9yDFOcYVihvjZpx7vkUC0OWgYdp6HtKukGlG+dfzhUpiTLt5iEvul8KFkbUiNVXTRJSqN2yl4O8Nz3QwI0S8beDFNXOcqfq8cZc6zMd4ql80tjO+R5wbGcx9EkOrvjMh+iBLIa+AQ5FprN1t3+6JJrokTXpcrkK5xMrcAnmkNpTdzwbDrgbHpiQgPFuVvjcBf1qRzJJ+fkh77eCY/BUW2nxT4H9rZA0Lmbbm67DO34Ck5BT357dXO37JsaOIdHRPVEaM35Pyh2GaTnjgde2VqIuecA7Vnb/eVat0fGX99Kt+A4m4tozTZorJL4FIPguum/YKPDzzTpU3CCACqzGqkRrI/cIJKhiwUMjqQ1HOLZ2/mNXJERqCeCrRIYCuPKrUCLXHaJlGE1h2TDzNpK4o5jr9OyIGKMp2bn3Zvdn+N8JDBBV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df844a5d-798f-4908-8acc-08df0b18fd0d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 06:43:26.3142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgzvYj86AuMLiWTYN740nhPdyrPWqBlpoyH89M1i63ciP0+VpkUqv+KqCFAeGJ6CQ7um1Eq5ryvYvs1wqYpzNgsnPuvZRTWOvD/W9du9hEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB9964

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
