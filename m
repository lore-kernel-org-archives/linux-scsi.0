Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752913F6606;
	Thu,  3 Sep 2026 06:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418204; cv=fail; b=MRer3wtDplf+CdMFkwivD9bWGXneVSyzrx5c8rzI10rtNBzYL94A0S1nDK0KauN4xO7LZQ/9byDaBD4Ws3CptgSCyil7xdXeiL5v+xSsWGmLVJ7wHC74P78du5GWimYUJ8E7PIxAh2acdqlYmeO5yF7FHtJF6hnig3Fu8nCz+No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418204; c=relaxed/simple;
	bh=fyeoK5EHWRFFtKjIiTIWkMiO1hLIpHtqLydSG4IYgNk=;
	h=Date:From:To:Subject:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=eT0V5lq3wUOTasqB100H3u6o4mKT/zMziaqcYy1jgRtVKfmAKpL8NM75FfdO4Z+r7jqodZpVNfwlmvp+B5AP7RQzHeA9dDnbcYh/tVb/8IsjRXP6XxCLYzMIxSJcwnueYUVBRgot28+NTgf1/841NZQfxrrM+x+jD0o51OXc/Es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HGfVFHfe; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=aJf192SG; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HGfVFHfe";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aJf192SG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788418207; x=1819954207;
  h=date:from:to:subject:message-id:mime-version;
  bh=fyeoK5EHWRFFtKjIiTIWkMiO1hLIpHtqLydSG4IYgNk=;
  b=HGfVFHfehDaoVdwDWa+a3NRH+Pc4HZkjX5Lf4XNO71v6Q+0nZ8njOKuU
   vh3sR7x6bWxveo/5JgXylrGMFjXyzVcVhXZUGSJE6SIg0FjkIVWbqLn2L
   h0mrwLqnhGZdf2oI3xTRapqYOaME/s6LTQCSWKPPeOtRScVs7OWom36Cf
   PtAR1aa78ZxbT1MBCu5dha9ywWwXn+XOa+maO/re9nw2Hjvh8aW5qrVhe
   R8yfG1sHdI8fcm3T4vQ/CMOFWoNLHG1sZENBEbiRTIBPwsZzXYHjyyigQ
   n+p6Z0T04HILHoo0dzWCHbZ6pYdH1KfUrTVS1mX8u+KHIX13MNQtIjn8W
   A==;
X-CSE-ConnectionGUID: j5EEZjxYTdqKrWG9p1U1Qw==
X-CSE-MsgGUID: QcAVHwnrTaiD8cHDq2Qoew==
X-IronPort-AV: E=Sophos;i="6.25,258,1779120000"; 
   d="scan'208";a="153893382"
Received: from mail-southcentralusazon11011034.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Sep 2026 14:50:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UR8LRZZFWKR2yGe8i4ZNThtrie26Bs3yebg2YAH5KfqWW4uuAevfrVJ8Jf1IeS0u32SxQdauoWpSjtpa0xhzUCdXWt5mi8ToeQTv1OFdEvLQltAwf+g+F0eCysEAOEud/VLzlzMDvpso6iyRzDbD6pd4/WV+uSmfWqgFRgEGkoVmrL6RX3z8MQgdVz9pI5Hqj4+nmkOkm4iEJXbnnHfB/GUo2GppanObYd41iRCQbiR9QkgPtYAAd9x++UAtXHhehhQmwQ0J7J+qEOxYTY1z3nV+mlW/GSXM+wELlNnPcwsU67yUdkmUhBdqi3X3l66GXuUG4qGV1NCEnIanXiFsYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X52vrYfHStrpvMf5IQF6+ZBe2M7ZIq6qhT3Tx8qEzJE=;
 b=YtAIgloY9IlHqVvlD0gwiblt6WcKPKWh1EJGcSTHRcAMCY9eIhKFxx/Y4cDO7ZyuVE6vCEdGlXE3aGHRnd0OvMhI9tKj4OOS6qbUd++7/CxdFIyrJbESjQCBnVWG0fYSKJCP3y08cPbRel7WHE/FMm7rOiJiAdlKZ9aXzUAJAFatIuL2yaqcLNOKW/quAYHZ0mNIVvr+RVso0OTSDJLA2RLcuLmcmcL1+vdlNBecUQFutD1paWZFi3RyFpSaCi5O8p3FbThgE+theLrGhU3E/THFzzV4Vk4LhiFAcltA7dbFatefvssoc5PAE2CL5QbMNtbk0INQfNM758B5KpaoHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X52vrYfHStrpvMf5IQF6+ZBe2M7ZIq6qhT3Tx8qEzJE=;
 b=aJf192SG3tAhfjwI7a7M0PxpHLYuIxsjccdP+Wc0cuqjafIAFIh0A7dziF/XHJyGAgp1B0lL+2a4Cc8ddRNTP1xujj7WLqxI7rXraUT4+CjO3RqN/rB+6Jtc8SuutGpYwDz9z46OqgkV7E/g+HP5+ECaHjaFtRhIMSTO3rcA1kQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by DS2PR04MB993869.namprd04.prod.outlook.com
 (2603:10b6:8:336::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 06:49:53 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 06:49:53 +0000
Date: Thu, 3 Sep 2026 15:49:48 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	nbd@other.debian.org, linux-rdma@vger.kernel.org
Subject: blktests failures with v7.3-rc1 kernel
Message-ID: <apkYN8Os5A6VXqS6@shinhome>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: TY4PR01CA0018.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::7) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|DS2PR04MB993869:EE_
X-MS-Office365-Filtering-Correlation-Id: 0664bc71-7ea7-4fda-7756-08df09878f1f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|19092799006|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	uDeSai+8KBUBXUi9KgaUIknDaolzjmt/+lgnHLGCYp6hVb+Za2moPj6qLPYUyzpxUrl0UEpFkd5WIjzpkiXehO22mzU80ShG+TSbfh0wGQzY/LQfHcIVve/Wqjrcfwb/O2opQSjj2vI77pqdkjp9oe9k+8MajrsKOjQ9gaIzGEhiVULv2dUR568iB3K2SRz+PjWA/YQK64I3RSxv69xs/dWau2bYZp/iqHkBby7vwzv5ERLTTvRFDUoetTiLZjUECMmHNKBwK7+vZC9RpdBKrPfidzBuHt2g8nkj3aXgm5YzauYKFCK8ejyu7/tc1EkSKEkjpy1U1WyRskXl6V18ICFkSFn8k7tII1y5lwQth4TClTVQJXUrMGlYKhJqUnZAsyDDhISYsxkKTCwUXZnaJ7AyYAYX14W7CbCDqG6gONlpxS0hdbrBZsRdnwe3KWUgAZJSFywxf0p2GYw0WxG5wO2gfHB6VRpH0bQGwNd+o0JRJM6RyVlGHqJy2f6ZlIKQSP2WRQchBQcoiqPUXW09GRmhHDYJVrdV5aRqHz0oB2cZ4MScB+nwwIAIEyPyRF/G1EgL3XHBWsrzgORjMlHt38y9uhAVc+ve4p+RzvWm37aqsWXocMpLw/DG+fHOLnTOqnHNVbDCX/9tNSLW/SrYoJiXnAeGCZkefqDPK0aciow=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(19092799006)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v+ZkXlOMgMdimF49HCzSpJVx6sPDfezrsBpbS62KAENRL3icLoxvLxav+4VT?=
 =?us-ascii?Q?qaPN9YPvx/hT3AjMf/QJ0L1XhwX3F4eybU+ZEZbvPzmWap25CYXSmmBjZI4Q?=
 =?us-ascii?Q?EYRvsVCPt7uHy5Y1PCM2J9eOdLoIjgYpitFXUnLQv7Vi2+JBSubRHgiR4DJi?=
 =?us-ascii?Q?XeOOoE6MhIIx8wd5qT7g5trm84OyW3Lp6tUuuwFx7zWb3xICO7J3v00DAW+G?=
 =?us-ascii?Q?cYiuTVrJ+FBdJI2nN7f8daoP5vaQX1kfuXESwdp1iUyGsDKj5GGCqBb/JNsH?=
 =?us-ascii?Q?GpW/GuRh/THrgqIu/8DWRF9Azr2Do+7X1S7Kf3eHRGjm/TMCujMyR7tjCFdm?=
 =?us-ascii?Q?6BVfceQxUQtq7Y/vGaWRJ2rVr1882+iSzveUM3OxgmDGq7J0vylHrBvS439a?=
 =?us-ascii?Q?1fduIrnAZHdu7abLky+/YX0kLjNHKOC4d1G3ficngNfEnT+vgkpO+oDr6MtP?=
 =?us-ascii?Q?KMjtS6C5U9RSCLFY6bj3ALv6YI5KwDGs9XstuItxmEwuZX6/1ZEe2t+4oohx?=
 =?us-ascii?Q?x0EzY6c3tH2zKWHPUY+rDjR4Nn4+UvCliW8nJdZmfApsXdCBWk0tLaHPXxlG?=
 =?us-ascii?Q?y5JHsXe/vr+9bGYzEpy1Y4SWfmElIDX1+EokZxHb6wYIQ5GcXdaOjFulJRRZ?=
 =?us-ascii?Q?adPtPPyDH1cQMukrRVNtHGsrMjqIC5Ay5AJgBOkQSjsj8dNZaUUzdK2pI6sJ?=
 =?us-ascii?Q?lnP/yoFtiXJ4NXydmfgwHVrsDZItuuqvH6Q5qRwUctASNlwEQY1HwKnZRRJA?=
 =?us-ascii?Q?0V/u0F/kCCgqfVNF3tK6h97qgXGLgA6WHiflXD8lm+E5XipLf3dTmbo4HO9W?=
 =?us-ascii?Q?fnERMqyT1kf0MooBCgnqKp0QZ3a9MDTMDFZHR6EWNxZBffTIYi4xg9qd1KIV?=
 =?us-ascii?Q?2sx4ZFEsaLWBsFa0C43DAJq1aaTNxen0yCTchoXNSnW7e+xQPGZ2NI995Fqn?=
 =?us-ascii?Q?2L863lMyVlSNOyBr9rcKHEWXcE48EHtg2rN3xKkITD7aaE4Ij3nukiWgiXoU?=
 =?us-ascii?Q?66+yNj2auGWkL08xGhTbhhuHZzq6EleiL2YnTdTkLx6M+NGyTbYlmc0MQuxc?=
 =?us-ascii?Q?/2R0bNN9Go9abWZ+wBjewH2++UIHrlAeHhQQwdXO57WOQqcWgm1ykCGmjg4w?=
 =?us-ascii?Q?bJv+me7LwkXQfKePcH/fvcwJMGHTd1o0CNBwYaTuN96o11Et1pFfmZLZRshw?=
 =?us-ascii?Q?KWt3vzhmIScYzRvww3dTVwEO0u7rq/rIyiYE2dF/hCwzIa4c9a3dWucD0vRf?=
 =?us-ascii?Q?QTWM9K8TU0WxCXLfqTeltG2HiA/9hcurwn4w5/lU0T18EOT48j1fZSpRzcox?=
 =?us-ascii?Q?K1pnOCia3NjFYevYj1cCseoNnBZuXnUh3dIdPX4Q+SSMmm9l6f9WfOoiLoyZ?=
 =?us-ascii?Q?S++yhQqXx7GB5JNB3c7TIjcM81bYyt/RrI9EXdMS0iv+nIUlnOL9DulH6bCm?=
 =?us-ascii?Q?ugNiZFrge5iGVMKXvAJRUFY83btJRTcFEbHXV6ul/yH4R9w9aIyG/2cBYI1J?=
 =?us-ascii?Q?D2SRs922fNFfekuAwP+rbqr5Qmroay+wz0S/BVVrioN9wusVCUbZ3GE4S3rh?=
 =?us-ascii?Q?wENxXbUVqHA0B+LpsVAMdpdEPCLACjqxP4CVfuxcuNa9M9erL+vi5FAR5Ulg?=
 =?us-ascii?Q?yZOrsnWRmZ38jmpHyjbzsiMhD6nvT2b49fRJE23SOt9Ph9hmhz04kBp/KDBP?=
 =?us-ascii?Q?TzdPcoRuUeK5R3JJG/to+SGmforbBd9BA66KHn7lG9xW5mt+pPB2skuA9/CS?=
 =?us-ascii?Q?4dQmuUGNHzP7ILwLQiyXHuf4WWqf/RE=3D?=
X-Exchange-RoutingPolicyChecked:
	vzqs9raFqNzmR5+euqADp8AaFLYf6o3MWzQROfVfBcqebnOCknwDnEISyqbikLKzEDlIAq5mV4QQf/MmjCBIj6OH0KMcPRqjryGaOumPO/KTvOVHO7laEdiHlOY4UBa60BP4yABygLEdWIkudBclXD/lIReQvvXrFYb97jmJfy17AA5IyYZp29EeUz8iqxQEVJVaywPqQWcJsECicBKNXD5Cghs2S8o6hSwoDqQPB68Cui6sbcMwMo3uIP0SRjMuH+17V0r/u/rDlxnVZhWS5NAWfSz6Zdhv5C2ZEry3Agj8TYnSBlj+GU0uEur7f2N6MihhG2wd44W9bWYoHP4AaA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L41/DuYodj53jCDfIeN6wRbAVGZqkkuMjk46V8jhxBOZWE3YGOd8MIOhzeoSuqqgQdaP4cnT2V+TRWTP2DZPaVKzxQ2Ve+SwRQIFn4EUwed5bPx/pNvNvpsO3dMY2Fqb8379umZXDB8oIebQjnq8/3fydTwekTGztFVWDDeOpXNhOHa7rxEeSjyv25+Vswwr2pzw/r6BmOQn7goHE28DxWpd4lPsA1pXrLxN8EF0XeiL7MPWNxFG3E+qalTs7/Tmkc+RrtNI7/6fMf2iyVAvyvKCXn0ZYNRPFiyb5hBx7nZJg2dPjTHuRUGF7dWxR+s9br3DHrSaxifxpq0TrvKX/OCSgz91taV9Kr0fYI2XiVc//cgbh+JY9bd7eLSANa1Vauwi/ssWn8bcMWRWTsJk4RZsn74ZFmLCqQbPiOlknaAKuLbcg3Uwfq4g38cau2BvmIOwaLMy9CuNly7ZT9JQMQuyBCc1fLljeUTK1ocdNW+Ki6WqGtcuP1fEibIsLGLPF1jPiNEcQnzv8pJb+aq3bHtdsBRHP3lCLtIgEZGWLm0zZH+DO27pT0bXjkWvNM2eH2fH7J18CZCp7LBjKoEAJ7Kc2tU2Ty9mqJOrOhq6Aw1LKaWX3jKNGhdV6cuEHMCd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0664bc71-7ea7-4fda-7756-08df09878f1f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 06:49:53.7994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBJOu8zI8xyOS4lrrlBs8G5MD/j7Juwa1jGYm80/Grs2j34bJBUW02694Tn5MgWz6GCcLOJGxnfhJdZs+hTCC2XDUplCAcn+7uMSWpNKxVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB993869

Hi all,

I ran the latest blktests (git hash: ed675852b012) with the v7.3-rc1 kernel. I
observed 2 failure classes listed below. Compared with the previous report for
v7.2 kernel [1], 3 failures are no longer observed (nvme/061, nvme/068 and
nvme/069), while 1 new failure class was observed: Sporadic
cleanup_srcu_struct() WARNs.

[1] https://lore.kernel.org/linux-block/aoRGbVB70YCcxoxF@shinhome/


List of failures
================
#1: nvme/062 (tcp transport)
#2: Sporadic cleanup_srcu_struct() WARNs (rdma transport and siw driver)


Failure description
===================

#1: nvme/062 (tcp transport)

    The test case nvme/062 fails for tcp transport due to the lockdep WARN
    related to the three locks root->kernfs_rwsem, sparse_irq_lock and
    root->kernfs_supers_rwsem [2]. A fix patch from Liu Xixin is queued for
    v7.3-rcX kernel [3].

    [2] https://lore.kernel.org/linux-block/akryKgCjof_7d9na@shinmob/
    [3] https://lore.kernel.org/linux-nvme/c6e2a91f0b62.1787100300.git.liuxixin@kylinos.cn/

#2: Sporadic cleanup_srcu_struct() WARNs
    (observed with rdma transport and siw driver)

    Test cases in the nvme test group fail sporadically with the same WARN in
    cleanup_srcu_struct() [4]. I observed the WARN at nvme/025, nvme/031,
    nvme/043 and nvme/060. A fix patch for the WARN has been posted [5]. With
    this patch applied, I no longer observe the failure.

    [5] https://lore.kernel.org/lkml/20260830095605.3560267-1-shpark061104@gmail.com/


[4] example dmesg of the nvme test group failure with rdma transport

Sep 01 10:13:02 testnode2 unknown: run blktests nvme/025 at 2026-09-01 10:13:02
Sep 01 10:13:02 testnode2 kernel: loop0: detected capacity change from 0 to 2097152
Sep 01 10:13:02 testnode2 kernel: nvmet: adding nsid 1 to subsystem blktests-subsystem-1
Sep 01 10:13:02 testnode2 kernel: nvmet: Created nvm controller 1 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
Sep 01 10:13:02 testnode2 kernel: nvme nvme5: creating 4 I/O queues.
Sep 01 10:13:02 testnode2 kernel: nvme nvme5: new ctrl: "blktests-subsystem-1"
Sep 01 10:13:03 testnode2 kernel: nvme nvme5: Removing ctrl: NQN "blktests-subsystem-1"
Sep 01 10:13:10 testnode2 kernel: SoftiWARP attached
Sep 01 10:13:10 testnode2 unknown: run blktests nvme/025 at 2026-09-01 10:13:10
Sep 01 10:13:10 testnode2 kernel: loop0: detected capacity change from 0 to 2097152
Sep 01 10:13:10 testnode2 kernel: nvmet: adding nsid 1 to subsystem blktests-subsystem-1
Sep 01 10:13:10 testnode2 kernel: nvmet_rdma: enabling port 0 (10.0.2.15:4420)
Sep 01 10:13:10 testnode2 kernel: nvmet: Created nvm controller 1 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
Sep 01 10:13:10 testnode2 kernel: nvme nvme5: creating 4 I/O queues.
Sep 01 10:13:10 testnode2 kernel: nvme nvme5: mapped 4/0/0 default/read/poll queues.
Sep 01 10:13:10 testnode2 kernel: nvme nvme5: new ctrl: NQN "blktests-subsystem-1", addr 10.0.2.15:4420, hostnqn: nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349
Sep 01 10:13:11 testnode2 kernel: nvme nvme5: Removing ctrl: NQN "blktests-subsystem-1"
Sep 01 10:13:11 testnode2 kernel: ------------[ cut here ]------------
Sep 01 10:13:11 testnode2 kernel: WARNING: kernel/rcu/srcutree.c:706 at cleanup_srcu_struct+0x3e4/0xb00, CPU#1: nvme/55536
Sep 01 10:13:11 testnode2 kernel: Modules linked in: siw nvmet_rdma nvmet nvme_rdma nvme_fabrics rdma_cm loop iw_cm ib_cm ib_core nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables qrtr sunrpc 9pnet_virtio pcspkr 9pnet i2c_piix4 netfs i2c_smbus zram vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock bochs drm_client_lib drm_shmem_helper xfs drm_kms_helper nvme sym53c8xx nvme_core drm e1000 nvme_keyring scsi_transport_spi nvme_auth floppy serio_raw ata_generic pata_acpi dm_multipath i2c_dev qemu_fw_cfg virtiofs fuse virtio_console [last unloaded: nvmet]
Sep 01 10:13:11 testnode2 kernel: CPU: 1 UID: 0 PID: 55536 Comm: nvme Not tainted 7.3.0-rc1 #675 PREEMPT(full) 
Sep 01 10:13:11 testnode2 kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-10.fc44 06/10/2025
Sep 01 10:13:11 testnode2 kernel: RIP: 0010:cleanup_srcu_struct+0x3e4/0xb00
Sep 01 10:13:11 testnode2 kernel: Code: e8 31 d9 90 00 48 89 e8 48 8b 54 24 18 48 c1 e8 03 42 80 3c 20 00 0f 85 0e 06 00 00 49 83 be e8 00 00 00 00 0f 84 e6 fe ff ff <0f> 0b 49 8d 8e 00 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 cf
Sep 01 10:13:11 testnode2 kernel: RSP: 0018:ffff8881aca77a68 EFLAGS: 00010202
Sep 01 10:13:11 testnode2 kernel: RAX: 1ffffd1ffff89c3d RBX: 0000000000000000 RCX: 0000000000000001
Sep 01 10:13:11 testnode2 kernel: RDX: ffffe8ffffc4e280 RSI: 0000000000000008 RDI: ffffe8ffffc4e1e8
Sep 01 10:13:11 testnode2 kernel: RBP: ffffe8ffffc4e1e8 R08: ffffffffa078a1df R09: 1ffffd1ffff89c3d
Sep 01 10:13:11 testnode2 kernel: R10: fffff91ffff89c3e R11: fffff91ffff89c3e R12: dffffc0000000000
Sep 01 10:13:11 testnode2 kernel: R13: fffffbfff4a57cf7 R14: ffffe8ffffc4e100 R15: ffff88818c174118
Sep 01 10:13:11 testnode2 kernel: FS:  00007f5041375780(0000) GS:ffff8883ea987000(0000) knlGS:0000000000000000
Sep 01 10:13:11 testnode2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 01 10:13:11 testnode2 kernel: CR2: 0000558b7967fd5c CR3: 0000000127690000 CR4: 00000000000006f0
Sep 01 10:13:11 testnode2 kernel: Call Trace:
Sep 01 10:13:11 testnode2 kernel:  <TASK>
Sep 01 10:13:11 testnode2 kernel:  blk_mq_free_tag_set+0x2ec/0x4d0
Sep 01 10:13:11 testnode2 kernel:  nvme_rdma_shutdown_ctrl+0x169/0x1a0 [nvme_rdma]
Sep 01 10:13:11 testnode2 kernel:  nvme_do_delete_ctrl+0x14a/0x160 [nvme_core]
Sep 01 10:13:11 testnode2 kernel:  nvme_delete_ctrl_sync.cold+0x8/0xd [nvme_core]
Sep 01 10:13:11 testnode2 kernel:  nvme_sysfs_delete+0xb7/0xe0 [nvme_core]
Sep 01 10:13:11 testnode2 kernel:  ? __pfx_sysfs_kf_write+0x10/0x10
Sep 01 10:13:11 testnode2 kernel:  kernfs_fop_write_iter+0x3d6/0x5e0
Sep 01 10:13:11 testnode2 kernel:  ? __pfx_kernfs_fop_write_iter+0x10/0x10
Sep 01 10:13:11 testnode2 kernel:  vfs_write+0x4b3/0xf40
Sep 01 10:13:11 testnode2 kernel:  ? __pfx_vfs_write+0x10/0x10
Sep 01 10:13:11 testnode2 kernel:  ? trace_hardirqs_on+0x14/0x190
Sep 01 10:13:11 testnode2 kernel:  ? do_sys_openat2+0xff/0x170
Sep 01 10:13:11 testnode2 kernel:  ksys_write+0x112/0x250
Sep 01 10:13:11 testnode2 kernel:  ? __pfx_ksys_write+0x10/0x10
Sep 01 10:13:11 testnode2 kernel:  ? rcu_is_watching+0x12/0xb0
Sep 01 10:13:11 testnode2 kernel:  do_syscall_64+0xf2/0x690
Sep 01 10:13:11 testnode2 kernel:  ? __pfx___x64_sys_openat+0x10/0x10
Sep 01 10:13:11 testnode2 kernel:  ? rcu_is_watching+0x12/0xb0
Sep 01 10:13:11 testnode2 kernel:  ? do_syscall_64+0x1ff/0x690
Sep 01 10:13:11 testnode2 kernel:  ? trace_hardirqs_on_prepare+0x139/0x180
Sep 01 10:13:11 testnode2 kernel:  ? lockdep_hardirqs_on+0x91/0x140
Sep 01 10:13:11 testnode2 kernel:  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
Sep 01 10:13:11 testnode2 kernel:  ? do_syscall_64+0x21d/0x690
Sep 01 10:13:11 testnode2 kernel:  ? rcu_is_watching+0x12/0xb0
Sep 01 10:13:11 testnode2 kernel:  ? do_syscall_64+0x1ff/0x690
Sep 01 10:13:11 testnode2 kernel:  ? trace_hardirqs_on_prepare+0x139/0x180
Sep 01 10:13:11 testnode2 kernel:  ? lockdep_hardirqs_on+0x91/0x140
Sep 01 10:13:11 testnode2 kernel:  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
Sep 01 10:13:11 testnode2 kernel:  ? do_syscall_64+0x21d/0x690
Sep 01 10:13:11 testnode2 kernel:  ? do_syscall_64+0x1ff/0x690
Sep 01 10:13:11 testnode2 kernel:  ? rcu_is_watching+0x12/0xb0
Sep 01 10:13:11 testnode2 kernel:  ? do_syscall_64+0x2d/0x690
Sep 01 10:13:11 testnode2 kernel:  ? trace_hardirqs_off_finish+0x139/0x180
Sep 01 10:13:11 testnode2 kernel:  ? lockdep_hardirqs_off+0xaf/0xf0
Sep 01 10:13:11 testnode2 kernel:  ? do_syscall_64+0x60/0x690
Sep 01 10:13:11 testnode2 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Sep 01 10:13:11 testnode2 kernel: RIP: 0033:0x7f504141a08e
Sep 01 10:13:11 testnode2 kernel: Code: 4d 89 d8 e8 94 bd 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 03 ff ff ff 0f 1f 00 f3 0f 1e fa
Sep 01 10:13:11 testnode2 kernel: RSP: 002b:00007ffec0901290 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
Sep 01 10:13:11 testnode2 kernel: RAX: ffffffffffffffda RBX: 00007f50415ef006 RCX: 00007f504141a08e
Sep 01 10:13:11 testnode2 kernel: RDX: 0000000000000001 RSI: 00007f50415ef006 RDI: 0000000000000003
Sep 01 10:13:11 testnode2 kernel: RBP: 00007ffec09012a0 R08: 0000000000000000 R09: 0000000000000000
Sep 01 10:13:11 testnode2 kernel: R10: 0000000000000000 R11: 0000000000000202 R12: 0000000024b2a770
Sep 01 10:13:11 testnode2 kernel: R13: 0000000024b28590 R14: 0000000024b2a970 R15: 0000000024b28590
Sep 01 10:13:11 testnode2 kernel:  </TASK>
Sep 01 10:13:11 testnode2 kernel: irq event stamp: 67201
Sep 01 10:13:11 testnode2 kernel: hardirqs last  enabled at (67213): [<ffffffffa072b20e>] __up_console_sem+0x5e/0x70
Sep 01 10:13:11 testnode2 kernel: hardirqs last disabled at (67226): [<ffffffffa072b1f3>] __up_console_sem+0x43/0x70
Sep 01 10:13:11 testnode2 kernel: softirqs last  enabled at (66794): [<ffffffffa0545c4c>] __irq_exit_rcu+0x24c/0x300
Sep 01 10:13:11 testnode2 kernel: softirqs last disabled at (66789): [<ffffffffa0545c4c>] __irq_exit_rcu+0x24c/0x300
Sep 01 10:13:11 testnode2 kernel: ---[ end trace 0000000000000000 ]---
Sep 01 10:13:12 testnode2 kernel: SoftiWARP detached
