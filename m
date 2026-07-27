Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF741D10E;
	Mon, 27 Jul 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163432; cv=fail; b=OUAvn4Z+RADadMsYOWvQFTVkDlbSddHULD4GQmway5OvB6Anu17Qj311YM+vxgewGpNn5oPQ4hbV3S8eSUCephyPpvYccmXbDUT8Yqm7r8YqjiLxC07ogs26RgT+haJHBE7lij1dRBDNUQggp33+sQPS3aRnx9cAPUq/CHFHpAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163432; c=relaxed/simple;
	bh=e+HGhtx6PTfXM92uGHIaXSvrU4GD5yZoG2wh/ROnh+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PoQv3u9pdY6HjJ1UTI6a4+TycZy2IbVq5wYqgRTdmJi5ALJZjDjoz9wOTCrETptkRq11bfhNWg6gAGhbM5msld1i4hV6FAjmxOOq9G6AWCQhdRPz6CRMyY7YSuxW4GOPBCLMizS4Kon37C4lKh9PZg+FDwqer4XVcf2/d7p+H1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tm6b747j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yqwZcucd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tm6b747j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yqwZcucd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUNRc2096592;
	Mon, 27 Jul 2026 14:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8A4mOTMHt9XUa9p/g6C6M5rytmm51eDYhfUSKMj4fd4=; b=
	Tm6b747jvfDQBmtT2HzGEXWzPWvjHL2v8kkGEomoAld4IwsfMXQw//LqagJPM8xl
	51vD+OyE5Ljx3CKY4aiSLQdSNIdabH9lRWgJvLu2hdcFIERx+2l4IXikuJRbMXh7
	/UprJ1RbWMv5FEta1yQxHhdBTQjb5exYAKG96c1eahEIVnj87yR9MYlwVzinCfOl
	/NhaLkj6PC5E3clIc3PvHofjboT9vSIBZAgwM24m2Svi/00sXw+4GvPmdRyj8INX
	2P+9K0cMHbIxlmohum0K75j8TgVY428QRnWFGlI/4htni5eicvTHv1EjS+VEjytP
	sOzi1m4NMvtv6iNVgzTuQg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xsxhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeGQj034755;
	Mon, 27 Jul 2026 14:43:14 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh85s1uf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCQYncmNn/W4TmIK5s1VaIeBryO2b3oM/Xi5xPLAXG5Ij6GuIxxNoqkSHLxoF6isXgszQ7g8px0XejTKBYDXqUyk3ECejqL99hRR0Ebmw0e6iPumKw1f0ITU95DQ5aKWMdWQjSCMnPi7Erc794HxZVl9Es7IJe+brKVE2LhvOrJrSY2niifrjeR+8cYrAOds4QV/rBetZ6cSBKOQCkVFxprfhYadEfS21iPlJ9cwxrknPNDLqjMAnTurr9nH6N2Uiw2Ci8qQhk34reoXdwZhhPNQ1YPYK1/Twyz+jNrjDHnEz8ouA/ixaHnXqqh6CyXN6RhIpFw2xawxG6e2A1Sq7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8A4mOTMHt9XUa9p/g6C6M5rytmm51eDYhfUSKMj4fd4=;
 b=Z4mYUmTdMSicpxjyjjcgdTbucnuln8ob+QLAoJk/APH15/LAZo2x+oVnfIH4YiWcSUgC/3o0xATf0hlc9eVLQ/IgVKiFRAd39Ktgk6IASZHX/zkyPSdg1IUxypxxr5bN3+JKwksgZtsrbkraqm+FK4TtBjCFDqCI1JJm7L8xSmWEGDqQigQ3VkvtRgXkD7guasgjnXeNoHOOTAezD0gfJhWYoSIqt6JUFEtBpu9oVHbYR8Te7Ve3ea+kbMMNVZ+pzW4XsmN5EmaQQ3gsg/z/m0oipGYFFpllvgvJmxiIO995kUcuWJA2w8sF/8L8yrSqQykALLy1Ke0J3PmevTcGKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8A4mOTMHt9XUa9p/g6C6M5rytmm51eDYhfUSKMj4fd4=;
 b=yqwZcucdNV+G8rkQ1OorG/QlrL/6pY6a964ATPgel/3vpI2t56GWjr1Go++COJ7znYMgPI202VhQNMboeaT0bIq9FTPrVnHCie4LzIwhvdxOGE0Mzrk0LjV2XrbKm5m6givau0JDjP7Mm9w924BWZJuE9xYHQc/Obr4ThIkq4bc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:08 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:08 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 09/27] libmultipath: Add mpath_bdev_getgeo()
Date: Mon, 27 Jul 2026 14:42:16 +0000
Message-ID: <20260727144234.3802948-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0024.namprd19.prod.outlook.com
 (2603:10b6:610:4d::34) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 375170a2-4d34-4d2d-37f8-08deebed6019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4y9ATYMQNUErilSVK8zl4v0ZwKlrt5UZLPShZfp/0KFtTiiEWNLT/K0kBKwhWs7ioXGmy0E8u3HCvcusBaGy1AHJCMgDo7Zg56XiUN1dUZj6B+SvZreiPAL3mm98XGfcAGMfxrGEAJ5aNpDnyPb/taT80vSqVFXl0obrIT7582TMptKBhmCCY7oHV9BuqKNmRENRl/6FLeae0mttdCI3XxYowMDq4jYh9xIdYv0Gtp1xBqgoXr7Iq2Ah2GkmP1mIrwuuGjeNt7PHABkbaJheHQwGnJ+tpng6lXck//9yu44EGJOjmTsjx2y2f8vT44BHEZMrnjtmakGk5bbbnLzZBt6AK6MX6kOULvoamypIPTDwCmRcXkpxOsa+0JQAuZfBq7oKGl1jpxzBVkLdJXYbLSV7VYbWCXiGOFBO37HLOjXBNw+H+U3OXLFaC7uB3JgB4IQ7u/Sm24httTaguNq4xJ1EvwZHuHBAvXeLWdesE5ARyAlOmkzjCkTWgn5CQ44jB2kIv0cU1zXc6QJV0ZUVOtbg7vVHTginT/z9Yuvy1t7niOmi0XEwbFeo9lJ0QYVMkWKF5XjfiUH+6YpsYu+r/b1GN3U2dO4pP7I1ll3LXvKpyZ2yP5A5JLgRB5ltpsT/3kuB2DmGXHPWQwJnOvFSxRIotig42ycTfCpU8aaemtY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RPfHUuRZ6lQuNdUuVnCARbgbWQdZKdVqgMoo6YSJktZmHqIXiZ+3uM9SHGbf?=
 =?us-ascii?Q?+ZmwtCOCcJrNKeJy08a2K6hSfSwIgkh77NGhmJkSBccKPV/P1sKeo4L3vjKR?=
 =?us-ascii?Q?97QCoS+BwgusHT+xM0jFyUjmXl4sEHeIalHcenPXbGSN5ZBOcJbfQUoagJI6?=
 =?us-ascii?Q?xcarp44SGbridQy79srRXGJlOpkjxb+gOm2mviU1C8XEHFcot/i035NeWDaw?=
 =?us-ascii?Q?BvQI62VRz5ZWYlwWfP4FyzVAtwrsQBQHaW00+l8MuzgtY5CrW+WbM3SfHZ5e?=
 =?us-ascii?Q?GKtgfiHhRWGaVUHw683Kq3vRrSY+xTJn/+Siz2jqY/V/WPcwdj4fDtK6nCGe?=
 =?us-ascii?Q?gjGuh1DefhERi+XCR+57tlcC2MSjD5SfsRjbAjT3O4JVqh1Sc0DCUSfgwMs3?=
 =?us-ascii?Q?TpICE+K6MDXmGPR1YGLXBb7qRwjbzxNMdv/KSiULaYURYxLYQZdMEngM9GdX?=
 =?us-ascii?Q?GtqzFXxxFFVA9Vnuk/2JU7vcTaXINTfev6XfkGJn7xDXG/IX/AQC73BGGfij?=
 =?us-ascii?Q?kbTMUkRf8WM/McNJM8kZr0a2yLGcupUXrU4yE0QJ8EqHNwRfIa4Bfx5HR9qa?=
 =?us-ascii?Q?NRH/euJORWCfu/LbZZKdS9lPWh7mku9EgqczW6Avc1BXWaZPom4CnB3093QA?=
 =?us-ascii?Q?ZKyfRILvsTjk1IAwfEKGr+89B8dmRjSLqFZFrauShw1YFAfpOg5RP+0sRVpJ?=
 =?us-ascii?Q?jSMBHnx71ZKwSBSjojdn3GgnMZCl/mWKZzsAI83juSbi3Kf7WrWr0Y/OTKKv?=
 =?us-ascii?Q?Fz2ZG36X94Pd7V4Lmwgg3etbhNJysuSz8M/K5C7xAZAZM84SjqCacffqxM4n?=
 =?us-ascii?Q?PgiSPJAOCbaORthDVfWRErwrG7yCjHlzKwve+9+I+CzHBhSp1e/bowEaNVjb?=
 =?us-ascii?Q?W+HVx6f9mAFi5SD0aJQZ2GRFNC/f0MT2Mp5vM16XHmcyDTQFdBbEU4ywzJF4?=
 =?us-ascii?Q?l9DEwIXDhUhvscd3ovvwaMWAveTECryCcs2CUX+rLTLD763B2Ucln43X5rLU?=
 =?us-ascii?Q?d5O80upfvBW32lw3ebnXqF5NGSmBGZ8SIxVRL0nnHwRzZCbJoG+VDqPaJhrC?=
 =?us-ascii?Q?EjLDfLi4ps9lj0VO4uBO0NG9IxZ4KEYIpk5s8oD6D3T1gG13H4t7bYj4Rgj2?=
 =?us-ascii?Q?l006NzDlk3KBO4G56FtNecmB624168mO3clBfxDhQbbSXNXODtxsh3utvWPt?=
 =?us-ascii?Q?8UcgK2hI/FYLqx1J4WEWmTfZ18CDL6WB2Nw10LqnDlgmqQt+0s/kcQIbhRgA?=
 =?us-ascii?Q?UuACKwTldaq1Rtorj8Ml4Rl0Y5n38gE/jckYy3AjaILSKgU+8nkkPWVKQPg7?=
 =?us-ascii?Q?ZtYsnpdSvBJ/WOJLDWYw3GUMEI6D9SEIMP95xrr/6b5axHxaV9JZt6JkvAAl?=
 =?us-ascii?Q?MNAaXvSGUVhP8AfMK/nfihJ7BgP0p3FfhORSmA4Ym93twdyqN4JaNSgeci0Y?=
 =?us-ascii?Q?wzg5KCNVPHA+jJexa9QWBkd3IKtbAgqbQPD8Peut5ui7DjQ3owOG+i3U9EWH?=
 =?us-ascii?Q?LG+T2nt1OVtthgU0WSYLddzVukvdqTVPNvVPhx6POVXfaQi4HQu/yjJZAL6j?=
 =?us-ascii?Q?kCxx6oSphX74RJHTtm4wpQHS+VLFdlC9xynwoZkivu7kKg3SvPGPYdClS3Ur?=
 =?us-ascii?Q?Ex+EKNxFqADLUs5hxuXfKxT4/LHhyxoYcoFuONXMxN91Id9TGgJSGGGVe8qV?=
 =?us-ascii?Q?Z3jx2YU0Uy+Vb6x+a3wbqndJjxVRZRe/pRUOpWADtIMhwCNvj2vnLzJNfuxf?=
 =?us-ascii?Q?RtlXXwr1BE9mCjcsTTi3rO/aDQP2308=3D?=
X-Exchange-RoutingPolicyChecked:
	Q4ElS8MKaB4xEVDgmgYuKugxq9TSpDpty9IurQ+gNyFm1YuRy7lYdV7RqIZm3cevXG/iUNj7Dw15AHG0Zun57s/TFsMkZsi1AScDnYsIiYfEAYSpsTYd9MkCkuUI/y8WnN24XnsX/Viv07Y7DtCUZI/PNNyMlon91kmzFFtmcTLxcRfJW0mc1BrWpMxN/mC09Wc9fgHRck0NdDusPvr0EaZ8X9kia43psUmOj07rA1WgtdBXFcLXqiGk/eoogaifMcVUWCXJWqRoePtjJYuWrx73TDPztLeU10FeY+NPvNUgGHB7WDY8tnHt5zllQfQEfL5Du/0C+ErgXUXlxx76Tw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G1J5rw7Ov6E7eQuCyqY+SFAJNwcswsSBHAIanEwJHX0IHWrseaKxJAnLhCf4PbONFRcubJCCAfElgaCiY04fhbZdSSQYAS2vGhVXeUyHjsc4QYADiU5VtxFiy8H5HE4vTFf0V4KISxITkMhfdZD7xLLHl5bTn17vjHk0QnVJM+lIQhxq7AxUxBVDECUQGJu+zYlRC9hSJay/6BD4esZTRz00jwN8gui4205D2Py/wQqwOX06PeZtEWl0FkQgXDOwlGpzDU6k9l1DGTNJKEa+vYoO/bLblVGwlmRKfWVdoMdH5NTG8B4qBSsu3WNlqvycBWT63RmlXVG4EnDwfXzITjU1ctCOcdoqbQZ0cU6Su30d5M3MibpxRX4kQfaIxBV6eBGMokQcjkCJMyEov+c7LL+nBuIB1Mg7rYHG+kWmg0JcD5BqiHG1xWQN740cNbXCJxUdyyyq346Zp8VXuQTfaLjvEcVD3L91QYaaG3mVMtL7FKjs7pVOZ+jXTeK3L0d0mg4uxKWHQOxBQN3qrJWeG/EFzW2StnawifWrgCR2GDRYB8CfbzYb+1Kc5AvsK/QruvydOrhTJMvsYn5+UxPO/XTZzeJcIQ5Hp22J2JFQQkc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375170a2-4d34-4d2d-37f8-08deebed6019
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:08.7883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSpRNFrl7I9gq1FlpnkK99eO5krUx/pi/Km8AdsjdHmekXas3kmkK5MuNrU1+y+2gP7xrD2G+cMEWS+qPunLwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-ORIG-GUID: Oe2LHhCat_93omYPICKeslvfIpAE-MYY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX2tVHymh18ykn
 jtPWqXvQ62BlIpahGsXWIhyoUYsICl+i0rXtS71Q+3nmhmfPSjmP59+A0b71tMvS5uaYxew0x6c
 QGSx7iHUUAjiDSYzXI0mcdNtaTh8PK1VaO8m9s3IUczDsajTV4mGUv57Y3gsa8oc6F2N3BTO5su
 D2ObSc7cPdLK/2RBPqJvXGpX8udyGB1w4ObgkZDLsw1XosxACqZSbx7SkeQu1K2I2Ajl1du3mSO
 jbD9PaNbF4KIWdIEpVBuaOyINH2LPo5n5T6WZBHAZrVPOO/Mj8apk8kRw0nw80+HW8MFs127RaJ
 TWZSwzEgyTYVXO3Ec9qTGRB+YuIufJmGevaTac7HEOnMm6kVXw5k+c4AhGo/dCjvcHGavN7YNW0
 VvsH71PStkwEcSt6XoFjUd+8sV82ng2o++Maw2cPI7poqPMm0iL+brG7xRJb5AHxk/X0TOk1D6g
 FMbLKCxWHlqsYpDCEAA==
X-Proofpoint-GUID: Oe2LHhCat_93omYPICKeslvfIpAE-MYY
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a676e83 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=5isd6qnPbDFeV7FJJ1sA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX5Yhh7KBis6ce
 RsuUQukTG9h+VS5Z31Pnw3IWLQQAJh/vq11cySQsWPVGBKRcaJWDGaH8bnzV0dtort6O4s6uVSN
 un0bB4Nr35+qzIvt88AV7KFW/e8GaGmqAabYCAX/xZqljpgaVXij

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>=
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index af90cf38a79d6..76b844d42813e 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -484,6 +484,26 @@ static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return err;
 }
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->getgeo)
+			ret = mpath_device->disk->fops->getgeo(
+					mpath_device->disk, geo);
+		else
+			ret = -ENOTTY; /* See blkdev_getgeo */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
@@ -495,6 +515,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

