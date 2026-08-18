Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5F33E123C;
	Tue, 18 Aug 2026 11:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787053839; cv=fail; b=HFT9rHeHr1PbL92xaYVlbm36GymvdpcQ61S8/wGRYFPerJT9mNIraGLngM4jDcm0PWYUMnVN4t7AWtqqd+RsyBPs4/zw0ilAW3xd21Sp5oSPxsGZ5uXF42pXagXp95/nI5vln1T6B2/v0QvjBG0Xob0OrbQb60gv6DATXZt17lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787053839; c=relaxed/simple;
	bh=beM3YvChpJR127E5gs8TQgg1AssCZ9fb8zqjcJ0pFaw=;
	h=Date:From:To:Subject:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=fPCwrdW3BlYZhmlMg3D86vPJQr3MOnt9ktzSAXhjidkO+LscZkw/jXIQCDU8jSnrszTq+adXxj7z+JsvGO/UShqi4yUvS9hzVqjRydlaHPTuM6fhDvdwAUFg437gf2S/Hppq7ShThLDhk9ebvH3uHAwbE20/5DHvaCDI0LwlBaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ec8xNWd1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=gNoi5UXw; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ec8xNWd1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gNoi5UXw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787053837; x=1818589837;
  h=date:from:to:subject:message-id:mime-version;
  bh=beM3YvChpJR127E5gs8TQgg1AssCZ9fb8zqjcJ0pFaw=;
  b=ec8xNWd1aJm4iOLwnXJg96cozHBJH9DseRPEYUeWr/Ap0umubKxH3YHR
   1+7NeL5tYYlcKovLIvZ1f9QT4ZlUH2UhRraRbcNfE68yZdoIq00PCEjSW
   NJta7amiCDyGgelWFoBaQFg3muiNUf/Asjk2D0qMbhztY5G6JCmFPy70H
   4zXwmLmQeasPwl9OIazDBwzNuLWExNuZIS7d3RWm5UhBVylVZOUUmrW3o
   lInLx6J4rGbXL4kUaretkc6FWpVscoocfe8H/8oU2ia3mXdhtTDTA6sON
   VjaQg4kYzZB/OR+BqaIhERMRWLtm4C5LvW1pLYPYlk1JHbDuxkV7Wgb/q
   A==;
X-CSE-ConnectionGUID: srxIxemvThyVVPAGs95nOQ==
X-CSE-MsgGUID: wZObdZbERZORdVLQLPRhbA==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208";a="153302062"
Received: from mail-northcentralusazon11013005.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.5])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Aug 2026 19:50:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gL3zZXLx9J6Gv0ntpgOcVgghsLiuP8IdJt4yr+FqnTg7LNXTFz8EBAkOt9qpBdFXbdDKIBe0nQiAIxcvkXwYJ8zawtg3QlIT+D1LHhRG5aubostG7L7q9VWv4cyl2KBUbxdnG/Zi44B/RJVq4qikPfauSAlchxqiKlAOKRUGpknLsRr5J3IsXjSAifer/qvxod2L5Ejg5+QvzDoNBkGuXoZxopPDmYfKJOjLOnyPy4K04jGOzLAJG5WZNyXJcdN9SDyCRznUmxV0ca4KzdWuTtUYcdh0NnkO0ouBcMirZ/WaOanm5dBLZ36bVqnAvGz2bVgFxxiVqMGixg9W7N1hxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KizE1bCne7yp/rt69UfQpZUXJdgSTz0n3V2Kqaj9adQ=;
 b=sTiHGSuH4rfbRMopE2VnD/BtTRdkNr8pIHrlWRXVPiG7sgiCl+yXE0t4UVDH3OlOMpUgdZVoObeI1G4lXjUw1q4/dmlZDdTqOX8loxR3vxAECVJJ5V0FEbnUjMqvFSGielq6+lhKqCplEML9mBhrfgFLVBTpQCu4L2T1g0tErdA1I27w08zUgPrDt3gjXKxmt/JdilYPZ0bWYkOR4Esvm2fvhR2Tyc4FkFWNU4ekgsRELEEFlXyNdcs8x/zBJ3xgnAy9Fv9p7pEUD6BRRbL879lvCsWVkTnC87vPzME6Am2oFzpWNdSpJzhxt9klqnsXWhk14V0PPrMs17ngpjwoEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KizE1bCne7yp/rt69UfQpZUXJdgSTz0n3V2Kqaj9adQ=;
 b=gNoi5UXwXo1A1zF+tGlXcLL7g/yMVMjHcRpOvOxxGJ+xxi1+swcoTnoAztogAD2wUAe0910uIFl4HCa5Hp8pfK4MIhVzmQr03R658YTqf8uDOnt1vNQ6XjmTnWcL61yzzAQNLXJtPXsRXRmYi5ndSPxzdGDt69aw32o3cMLvN9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by BY5PR04MB7042.namprd04.prod.outlook.com
 (2603:10b6:a03:22f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 11:50:19 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 11:50:19 +0000
Date: Tue, 18 Aug 2026 20:50:14 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	nbd@other.debian.org, linux-rdma@vger.kernel.org
Subject: blktests failures with v7.2 kernel
Message-ID: <aoRGbVB70YCcxoxF@shinhome>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: TY4P301CA0050.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:36b::9) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|BY5PR04MB7042:EE_
X-MS-Office365-Filtering-Correlation-Id: d2460821-a0ba-4d6b-14a4-08defd1ee082
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|376014|366016|23010399003|10067099003|56012099006|6133799003|3023799007|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	feC6SuUZUIuCaGC5jXGxVfArZ5x7pongxYWvpsRcuhN7IAzjU5hpneA/fmBSW1SH+LdjXbp0BA8S3nwic6g2Zh+cIJ4r7A0Hz/j5Sxw9SooBCTWjhTZqF8867F/Ot3N6Y5pONqiNKSwKPC2QhTA87dhoTJIC3JrKJKkCIW4FxKzjor62ZBDPEZ+Zk4pRRyxCCf0cZRcngYO8luIBf5MhpeUdWarfHhGXrfLWTBkUI7HA/OHDg+Cr0zi8CKgT4IM8gVjwBELuevNwDwKNQXosXVbwakjpgaYJBrEBOhQFYdk6uoe0wZ37Z+KC80PxZ1YAELFIITLYKCg+3yeMERbdxChluRiIR58sK8ngBEIQyV5GxRXB7vhsxykpv1PdaLxHpeL1MuFZG3ryoihdB6rgg7uhh9LUQJ6G9MoWj+fcZlf+6HcFuXGbbyHbXLizoL2tjk3bR842i1zEJBOOM9gHRvzsPwSs6pImjmX0v7yaV/jeRgIIdmy+1M1/5JGk/psRJhZslBpUMHq0I8fOl+wARRk2U/uu/UPMdOPmS51wWEpx4L1F0paI6gEJqXx0mzOSUJ2IQ4q7y36WZAEENllvNtMrAsW6XK0aLN/2oTyasT6hF4uLUMsRNcEMs0Y4zyTRrwuA968EbQmR7WT/Vn7yzAaknAUw+fHbnH7NKPSQzDk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(366016)(23010399003)(10067099003)(56012099006)(6133799003)(3023799007)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oJ/5SWLu2oGDGC53YEwER/m2N5qBz9JBvxQU0twXzXe23O3tpSbAxghRvdF/?=
 =?us-ascii?Q?2cRDxcucDozIE/aSqsArdkm9wuNZsaC01czmd6hGsjVcB7aMF2NVEzvQYpNG?=
 =?us-ascii?Q?KWU+dyiGJQRntIVxIf4QLkcbTU5VUiXQorGGrrYp7ec/70OruHtAiV+dH2r8?=
 =?us-ascii?Q?aLd5ovqz090lk9R6REr+V8SEdkhj1RqMZ7Xmc9qHQBVouxaPpaD3K2T+qJiy?=
 =?us-ascii?Q?Ubq3wpm3C5qtFXS8UQ1frx+2GtHeL8mKAtbcBdaTBGk19vspFdLbXEp7LNhn?=
 =?us-ascii?Q?Xt+hP5afDqPHB3sxgQk9RnNtm+syT00ylCl1npnl6S0hBGdHeH3lylRmijHx?=
 =?us-ascii?Q?DdaS+O3MqXdgbdXPU7rNDAXci/UqeYg/2ItYJOpp4Wl9JONOkb8PnVjtiewW?=
 =?us-ascii?Q?57c0qdRawbpkwj8HBsHfVWew88LLCEAVkAlSp2oWt6f3rY7ZgXhOI9rJqP2o?=
 =?us-ascii?Q?oofb3Falb8JC6TOCsOsuN36h8onbqo6HtJBjaAxNso3nZ8SBTqJfhzG8Jsuq?=
 =?us-ascii?Q?8Vd323WONf9pbN1D6t811KyhwuqW4zuExfc3dkhLXQlZqiRgKL9U/dApWCQP?=
 =?us-ascii?Q?fGm+lSgbysY0tceGflMda3OjGIyOSlUvypPRcq+uWw7hlfTWEYkb2stntslO?=
 =?us-ascii?Q?ifiwnp2HGRYR+RoBT8Bd/2Odcj+Ds5CUSB2GQamUIgupvxTdXfqsNlD+BfH8?=
 =?us-ascii?Q?m3DW95OW/6P/BZGzKhNh8XgAXE6Ltw55njH5dJOKAqSAJfH9vNbgbQOzLFGN?=
 =?us-ascii?Q?rjMZYzUDyu04XfJlZGFtMyHQGTQmZZiEWVuOFlO+OjpR6/k/i3pDqFhEH7sM?=
 =?us-ascii?Q?VCGdRvlwmP6SJiKewoqN41M5QjQM4i0z5x6/CqcPEfddGzV9Dtn+Csi7Xrya?=
 =?us-ascii?Q?A48sh5BPUOqhhYid61s6dDvtZ3GxqbnS3I3IedPkGKAzkzMOW7N95LnMvCKy?=
 =?us-ascii?Q?5QOGPQJUQPLpuIc51XwENxFCajIhXCESjed3MA6zbPhx1AoDPpN/WtAxmRs/?=
 =?us-ascii?Q?NRfjtRl+q1y/FZAvSzAMQXlvGISULCF3oLF7G06Hz7v9itlXuYb7vqoAPfzP?=
 =?us-ascii?Q?57yo6oizJou8+NHDjrhPZQr0BThEyYIq3tvlFfEiy6QhUZKK8vxVebx4agGS?=
 =?us-ascii?Q?yiKJfHMS1aeNwY7OAtEM7OH5eAhXNP2M4iSHtDUbYV7zW1lyWPOppitSxubC?=
 =?us-ascii?Q?PfiHCmaSEQxvMr5fDCvaSaVYU9xTPMfcR9M29l+ZmCp9za+IWSiWO/NICjSQ?=
 =?us-ascii?Q?PaxLoLT0RLUpjWbule7oBk014eddWmXRBHMtDsp7ncgLn2WihUheUt+li3yV?=
 =?us-ascii?Q?Sswo9cVCBB9UB/GggY+5tlNb/J0PnS3sTsPWVR4TBdK89cXvhjBR9tZnZNi8?=
 =?us-ascii?Q?VBjYHDazaHhFaZmjSz6pqqyTmxhn+5+It26Z1PArjxAl+gFXuuzfkMSMTh3Q?=
 =?us-ascii?Q?dT375NhL6H5tvXCuSVQZgHWLGrn/v33ELyyq+12H4J6RlksmdZvf/qTt8nMD?=
 =?us-ascii?Q?RZtnJlgBONbClnOHg//h/xS5PsFynYPCj/xAxZi65ZsroOis9PKL5GzzKMbo?=
 =?us-ascii?Q?GAIps85KZk15qImMGQCbJRb9WlGiHWOY3EvQ00wT7q+GP9VkQLNFfiH17mxW?=
 =?us-ascii?Q?1bnGGYFBt0fj9BRzGlWXMlGVTbqcW9Pw+Bsk5iNO+Cp4H2PasNf7GsN9Tz7M?=
 =?us-ascii?Q?ycpLmrFB/TBgab/6a6rKEK1ZRh81kIAzE1vPdd8Bw6Auw2AW3cujW9Lx5uVm?=
 =?us-ascii?Q?9jQBJukkkqFG8Gyy0s44+nanvdI2EHw=3D?=
X-Exchange-RoutingPolicyChecked:
	jF6SebQF0rEdlMCz3YMMUlJQDqRlGe5BPLzm0zmTiQSQ7Zih9/HPy/cY1DCxxQ+/16emKwZLuUsck9Bd6ufGwOKBlOK9M2xrkw3XnFFABUrlFlymymjVVh73HNivdjHysXcWwo3kX8w5aaVkcE4mqnaJ6OeZe8oMIer/vKcRT485yT3QgSQEqYUg/l8yD4th2UsBmT1u/nQ0rZ3q12hazJf5TjEaBH8HlnFrkeS59AY7jdecaPD6WZ4qRNoH259Wm4PybBgRI2QYaD4I61e7MHmKlDigSONvEw84bYCKKNM2YYYu8hS3qReZy/H3dq7k0cwEzQA1QUJqv8LbEhN5bA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZfWiFkmZwy9DQif0TDd2h00naeWlNabvFBhy4Yv6YgCISFoG9HBhpk4sQ/7KTNepmtCU6qdfxh7zqUxTU2vyYFTiWStZM+8RTC2gMi3jZQYC2p7NSkLomwQEhlCIoEM48q38uL0AQ/wBqcOdzJi7KOEOMDjwN/8Cx8Ba4h2rj4OuMmrT+ALAXRjOeEn28ClDuFf46uZ0RqrzmXB0t7a8+CgOe3hTLZg1ZfywdfVfRi9oJqAQPRAzCsnOmUtfn88wLyb7B3hgL3w3Un1O4q1qlG8P2/dSlx+ECS0T1kcBLpdvmXBPtb7yotEqgv9UzvBKr3FJEZKjlOy8+7zXhIhS9O4WzsL18/OiZ1phoY1N4bLcbLTodryS4QC/SD7Y8vZH+HChTkK/QLgIHhsQI5HpXOSC7bEA9ywrPb9pO+PdL4Cu0rBjtfiBoMoD372fqkFY1pYWNhsa4bIoYcVoil4XQQ1/M17wT2NGSMajOJyCReMZczrpiqhbiaILDkC43nGF+/J2Xim+t1lMxuQbfl3UG3mVtCWz8gwHoW9ONB/1Bk4V2230TB8xRXtW1JNtkemLSghl+EA2EAdaDH41LbOZp40CAaNwsrLVVugR30zmEtpn0ZK/Lky+NRdwmlz+PGS1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2460821-a0ba-4d6b-14a4-08defd1ee082
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 11:50:19.1665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dI+2lO92QsvRzbQ+lXYjKOVY8g6CR7igFjccF07gZZ2/60SIARubdNf5Mwk/8/7TTUw/EkG/HVVq79iZrZPLD/HTkB8bgPuwxqbqcIVscxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7042

Hi all,

I ran the latest blktests (git hash: ddc0babaccc4) with the v7.2 kernel. I
observed 4 failures listed below. Comparing with the previous report for the
v7.2-rc1 kernel [1], 4 failures are no longer observed (block/005,
nvme/033,036,037, nvme/058 fc transport and nvme/063 tcp transport), and 2
failures are new (nvme/068 and nvme/069).

[1] https://lore.kernel.org/linux-block/akryKgCjof_7d9na@shinmob/


List of failures
================
#1: nvme/061 (rdma transport, siw driver)(kmemleak)
#2: nvme/062 (tcp transport)
#3: nvme/068 (new)
#4: nvme/069 (new)


Failure description
===================

#1: nvme/061 (rdma transport, siw driver)(kmemleak)

    When the test case nvme/061 is repeated twice for the rdma transport and the
    siw driver on the kernel with CONFIG_DEBUG_KMEMLEAK enabled, it causes
    kmemleak that is detected at the beginning of the 2nd run. A fix patch is
    queued for v7.3-rc1 kernel [2].

    [2] https://lore.kernel.org/linux-nvme/20260629051529.810925-1-shinichiro.kawasaki@wdc.com/

#2: nvme/062 (tcp transport)

    The test case nvme/062 fails for tcp transport due to the lockdep WARN
    related to the three locks root->kernfs_rwsem, sparse_irq_lock and
    root->kernfs_supers_rwsem [1]. Fix discussion is ongoing [3] (Thank goes to
    Xixin Liu).

    [3] https://lore.kernel.org/linux-nvme/cover.1782436781.git.liuxixin@kylinos.cn/


#3: nvme/068 (new)

    When it is repeated several times, the test case nvme/068 fails with the
    message below:

    nvme/068 (tr=rdma) (NVMe multipath delayed removal test)     [failed]
        runtime  10.979s  ...  10.975s
        --- tests/nvme/068.out      2026-05-21 11:44:28.070959369 +0900
        +++ /home/shin/Blktests/blktests/results/nodev_tr_rdma/nvme/068.out.bad     2026-08-18 17:51:30.262228567 +0900
        @@ -1,3 +1,4 @@
         Running nvme/068
         pwrite: Input/output error
        +module refcount not as original
         Test complete

    The failure is spoladic. I'm not sure if recent kernel changes triggered
    the failure or not.

    The failure looks dependent on test nodes. It was observed with loop
    transport and rdma transport, but was not observed with tcp transport.
    This needs further debug.

#4: nvme/069 (new)

    The test case nvme/069 fails with the KASAN slab-use-after-free in
    cdev_put() regardless of transport types [4]. This failure is expected since
    the test case was added to confirm the kernel side fix [5] for the failure.
    The fix is queued for v7.3-rc1 kernel.

    [5] https://lore.kernel.org/linux-nvme/20260713104238.3034640-1-john.g.garry@oracle.com/


[4] dmesg during nvme/069

Aug 18 15:18:43 testnode2 unknown: run blktests nvme/069 at 2026-08-18 15:18:43
Aug 18 15:18:43 testnode2 kernel: loop0: detected capacity change from 0 to 2097152
Aug 18 15:18:43 testnode2 kernel: nvmet: adding nsid 1 to subsystem blktests-subsystem-1
Aug 18 15:18:43 testnode2 kernel: nvmet: Created nvm controller 1 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
Aug 18 15:18:43 testnode2 kernel: nvme nvme5: creating 4 I/O queues.
Aug 18 15:18:43 testnode2 kernel: nvme nvme5: new ctrl: "blktests-subsystem-1"
Aug 18 15:18:44 testnode2 kernel: nvme nvme5: Removing ctrl: NQN "blktests-subsystem-1"
Aug 18 15:18:45 testnode2 kernel: ==================================================================
Aug 18 15:18:45 testnode2 kernel: BUG: KASAN: slab-use-after-free in cdev_put+0x54/0x60
Aug 18 15:18:45 testnode2 kernel: Read of size 8 at addr ffff888128968170 by task nvme-delay-ioct/1178
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: CPU: 2 UID: 0 PID: 1178 Comm: nvme-delay-ioct Not tainted 7.2.0 #660 PREEMPT(full) 
Aug 18 15:18:45 testnode2 kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-10.fc44 06/10/2025
Aug 18 15:18:45 testnode2 kernel: Call Trace:
Aug 18 15:18:45 testnode2 kernel:  <TASK>
Aug 18 15:18:45 testnode2 kernel:  dump_stack_lvl+0x6a/0x90
Aug 18 15:18:45 testnode2 kernel:  print_report+0x14b/0x4b0
Aug 18 15:18:45 testnode2 kernel:  ? __virt_addr_valid+0x150/0x4d0
Aug 18 15:18:45 testnode2 kernel:  ? __virt_addr_valid+0x228/0x4d0
Aug 18 15:18:45 testnode2 kernel:  kasan_report+0xd5/0x100
Aug 18 15:18:45 testnode2 kernel:  ? cdev_put+0x54/0x60
Aug 18 15:18:45 testnode2 kernel:  ? cdev_put+0x54/0x60
Aug 18 15:18:45 testnode2 kernel:  cdev_put+0x54/0x60
Aug 18 15:18:45 testnode2 kernel:  __fput+0x749/0xae0
Aug 18 15:18:45 testnode2 kernel:  fput_close_sync+0xda/0x1b0
Aug 18 15:18:45 testnode2 kernel:  ? __pfx_fput_close_sync+0x10/0x10
Aug 18 15:18:45 testnode2 kernel:  ? do_raw_spin_unlock+0x55/0x230
Aug 18 15:18:45 testnode2 kernel:  __x64_sys_close+0x87/0xf0
Aug 18 15:18:45 testnode2 kernel:  do_syscall_64+0xdf/0x790
Aug 18 15:18:45 testnode2 kernel:  ? lock_acquire+0x199/0x320
Aug 18 15:18:45 testnode2 kernel:  ? lock_acquire+0x1a9/0x320
Aug 18 15:18:45 testnode2 kernel:  ? find_held_lock+0x2b/0x80
Aug 18 15:18:45 testnode2 kernel:  ? nvme_ns_head_chr_ioctl+0x142/0x2e0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  ? lock_release+0x1b5/0x340
Aug 18 15:18:45 testnode2 kernel:  ? nvme_numa_path+0xd5/0x190 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  ? nvme_ns_head_chr_ioctl+0x152/0x2e0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  ? rcu_is_watching+0x11/0xb0
Aug 18 15:18:45 testnode2 kernel:  ? do_syscall_64+0x1ec/0x790
Aug 18 15:18:45 testnode2 kernel:  ? trace_hardirqs_on_prepare+0x139/0x180
Aug 18 15:18:45 testnode2 kernel:  ? lockdep_hardirqs_on+0x8c/0x130
Aug 18 15:18:45 testnode2 kernel:  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
Aug 18 15:18:45 testnode2 kernel:  ? do_syscall_64+0x20a/0x790
Aug 18 15:18:45 testnode2 kernel:  ? rcu_read_unlock+0x17/0x60
Aug 18 15:18:45 testnode2 kernel:  ? lock_release+0x1b5/0x340
Aug 18 15:18:45 testnode2 kernel:  ? find_held_lock+0x2b/0x80
Aug 18 15:18:45 testnode2 kernel:  ? exc_page_fault+0x94/0x140
Aug 18 15:18:45 testnode2 kernel:  ? lock_release+0x1b5/0x340
Aug 18 15:18:45 testnode2 kernel:  ? rcu_is_watching+0x11/0xb0
Aug 18 15:18:45 testnode2 kernel:  ? trace_hardirqs_on+0x14/0x190
Aug 18 15:18:45 testnode2 kernel:  ? preempt_count_add+0x7f/0x190
Aug 18 15:18:45 testnode2 kernel:  ? do_syscall_64+0x5d/0x790
Aug 18 15:18:45 testnode2 kernel:  ? do_syscall_64+0x8d/0x790
Aug 18 15:18:45 testnode2 kernel:  ? irqentry_exit+0xfc/0x810
Aug 18 15:18:45 testnode2 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Aug 18 15:18:45 testnode2 kernel: RIP: 0033:0x7fa5379ab08e
Aug 18 15:18:45 testnode2 kernel: Code: 4d 89 d8 e8 94 bd 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 03 ff ff ff 0f 1f 00 f3 0f 1e fa
Aug 18 15:18:45 testnode2 kernel: RSP: 002b:00007fffd32959b0 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
Aug 18 15:18:45 testnode2 kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa5379ab08e
Aug 18 15:18:45 testnode2 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
Aug 18 15:18:45 testnode2 kernel: RBP: 00007fffd32959c0 R08: 0000000000000000 R09: 0000000000000000
Aug 18 15:18:45 testnode2 kernel: R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
Aug 18 15:18:45 testnode2 kernel: R13: 0000000000000002 R14: 00007fa537b87000 R15: 0000000000402e00
Aug 18 15:18:45 testnode2 kernel:  </TASK>
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: Allocated by task 88:
Aug 18 15:18:45 testnode2 kernel:  kasan_save_stack+0x2b/0x50
Aug 18 15:18:45 testnode2 kernel:  kasan_save_track+0x10/0x30
Aug 18 15:18:45 testnode2 kernel:  __kasan_kmalloc+0x96/0xb0
Aug 18 15:18:45 testnode2 kernel:  __kmalloc_noprof+0x2fa/0x870
Aug 18 15:18:45 testnode2 kernel:  nvme_alloc_ns+0x8af/0x2ce0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_scan_ns+0x647/0x7b0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  async_run_entry_fn+0x93/0x550
Aug 18 15:18:45 testnode2 kernel:  process_one_work+0x8b2/0x15e0
Aug 18 15:18:45 testnode2 kernel:  worker_thread+0x5fd/0xfe0
Aug 18 15:18:45 testnode2 kernel:  kthread+0x367/0x460
Aug 18 15:18:45 testnode2 kernel:  ret_from_fork+0x655/0x9d0
Aug 18 15:18:45 testnode2 kernel:  ret_from_fork_asm+0x1a/0x30
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: Freed by task 1178:
Aug 18 15:18:45 testnode2 kernel:  kasan_save_stack+0x2b/0x50
Aug 18 15:18:45 testnode2 kernel:  kasan_save_track+0x10/0x30
Aug 18 15:18:45 testnode2 kernel:  kasan_save_free_info+0x37/0x60
Aug 18 15:18:45 testnode2 kernel:  __kasan_slab_free+0x68/0x90
Aug 18 15:18:45 testnode2 kernel:  kfree+0x273/0x6e0
Aug 18 15:18:45 testnode2 kernel:  nvme_ns_head_chr_release+0x3d/0x60 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  __fput+0x36f/0xae0
Aug 18 15:18:45 testnode2 kernel:  fput_close_sync+0xda/0x1b0
Aug 18 15:18:45 testnode2 kernel:  __x64_sys_close+0x87/0xf0
Aug 18 15:18:45 testnode2 kernel:  do_syscall_64+0xdf/0x790
Aug 18 15:18:45 testnode2 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: Last potentially related work creation:
Aug 18 15:18:45 testnode2 kernel:  kasan_save_stack+0x2b/0x50
Aug 18 15:18:45 testnode2 kernel:  kasan_record_aux_stack+0xbb/0xf0
Aug 18 15:18:45 testnode2 kernel:  insert_work+0x3c/0x2f0
Aug 18 15:18:45 testnode2 kernel:  __queue_work+0x9e6/0xf50
Aug 18 15:18:45 testnode2 kernel:  queue_work_on+0xc8/0xd0
Aug 18 15:18:45 testnode2 kernel:  kblockd_schedule_work+0x19/0x30
Aug 18 15:18:45 testnode2 kernel:  nvme_mpath_put_disk+0x46/0xb0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_free_ns_head+0x22/0x170 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_ns_head_chr_release+0x3d/0x60 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  __fput+0x36f/0xae0
Aug 18 15:18:45 testnode2 kernel:  fput_close_sync+0xda/0x1b0
Aug 18 15:18:45 testnode2 kernel:  __x64_sys_close+0x87/0xf0
Aug 18 15:18:45 testnode2 kernel:  do_syscall_64+0xdf/0x790
Aug 18 15:18:45 testnode2 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: Second to last potentially related work creation:
Aug 18 15:18:45 testnode2 kernel:  kasan_save_stack+0x2b/0x50
Aug 18 15:18:45 testnode2 kernel:  kasan_record_aux_stack+0xbb/0xf0
Aug 18 15:18:45 testnode2 kernel:  insert_work+0x3c/0x2f0
Aug 18 15:18:45 testnode2 kernel:  __queue_work+0x9e6/0xf50
Aug 18 15:18:45 testnode2 kernel:  queue_work_on+0xc8/0xd0
Aug 18 15:18:45 testnode2 kernel:  kblockd_schedule_work+0x19/0x30
Aug 18 15:18:45 testnode2 kernel:  nvme_remove_head+0x40/0xc0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_ns_remove+0x50c/0x9e0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_remove_namespaces+0x289/0x3f0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_do_delete_ctrl+0xf6/0x160 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_delete_ctrl_sync.cold+0x8/0xd [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  nvme_sysfs_delete+0xb7/0xe0 [nvme_core]
Aug 18 15:18:45 testnode2 kernel:  kernfs_fop_write_iter+0x3d6/0x5e0
Aug 18 15:18:45 testnode2 kernel:  vfs_write+0x4b3/0xf40
Aug 18 15:18:45 testnode2 kernel:  ksys_write+0x112/0x250
Aug 18 15:18:45 testnode2 kernel:  do_syscall_64+0xdf/0x790
Aug 18 15:18:45 testnode2 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: The buggy address belongs to the object at ffff888128968000
                                   which belongs to the cache kmalloc-4k of size 4096
Aug 18 15:18:45 testnode2 kernel: The buggy address is located 368 bytes inside of
                                   freed 4096-byte region [ffff888128968000, ffff888128969000)
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: The buggy address belongs to the physical page:
Aug 18 15:18:45 testnode2 kernel: page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x128968
Aug 18 15:18:45 testnode2 kernel: head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
Aug 18 15:18:45 testnode2 kernel: flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
Aug 18 15:18:45 testnode2 kernel: page_type: f5(slab)
Aug 18 15:18:45 testnode2 kernel: raw: 0017ffffc0000040 ffff888100043040 dead000000000100 dead000000000122
Aug 18 15:18:45 testnode2 kernel: raw: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
Aug 18 15:18:45 testnode2 kernel: head: 0017ffffc0000040 ffff888100043040 dead000000000100 dead000000000122
Aug 18 15:18:45 testnode2 kernel: head: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
Aug 18 15:18:45 testnode2 kernel: head: 0017ffffc0000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
Aug 18 15:18:45 testnode2 kernel: head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
Aug 18 15:18:45 testnode2 kernel: page dumped because: kasan: bad access detected
Aug 18 15:18:45 testnode2 kernel: 
Aug 18 15:18:45 testnode2 kernel: Memory state around the buggy address:
Aug 18 15:18:45 testnode2 kernel:  ffff888128968000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 18 15:18:45 testnode2 kernel:  ffff888128968080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 18 15:18:45 testnode2 kernel: >ffff888128968100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 18 15:18:45 testnode2 kernel:                                                              ^
Aug 18 15:18:45 testnode2 kernel:  ffff888128968180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 18 15:18:45 testnode2 kernel:  ffff888128968200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 18 15:18:45 testnode2 kernel: ==================================================================
Aug 18 15:18:45 testnode2 kernel: Disabling lock debugging due to kernel taint
