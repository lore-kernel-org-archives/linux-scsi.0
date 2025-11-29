Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B16921FF55;
	Sat, 29 Nov 2025 21:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764451539; cv=fail; b=MUFKrrv3GdQg3024Ca7pejc8muEtp5uHEuFUSEBM9XG/73IEUaUG3sl5mGLpKklzxeGOcfzLn+gqdsgwXQwzaUXfLC7BQD2hHMwg9Ag1KNseekDD+pUwXYVmR8nll2NojE24Ovqm3lHB8Hvqsw6uOLUM8mxYSjQoy2LTxZ17EKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764451539; c=relaxed/simple;
	bh=PL6uZQbyqV84XksFX3uhT7vtqwLBsHqnDVSq7ZOdOTw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gyfc8kxmkkcWYeJZlqo0hGavYEJFUVFBMv03tw6Mgaio2c25DhCH01I9synvoPUPDPuhdxab7LDpbr3vmQSi+CvpTH49YmgL0NfXwYeqlSpMEqm1JoYHwg4kqR5z4AloIpLFE4KThyYNYgvGbpYeUrlIH4826wbtEIyCXiiYVzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WSwDUSRc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mcTHbpuS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WSwDUSRc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mcTHbpuS"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATKA7sr2236280;
	Sat, 29 Nov 2025 20:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u8gswDBNENae3VK5sC
	DdcBS+d+2iNv07jIZlkZnr7u8=; b=WSwDUSRcYA3Hjp/6U2BeMO4Aya/1LZd7HC
	KGTzu+ENnN9iszP5HAKfLXaNmODM6fCF7U1TdmURahMIjhmVaIzi3xUtGVqgKIdf
	mzgvkHzX2JprrEFaTEm9OE28APulio1XB2UxoUY9NlL7XYB9WTndARE08MI8niv7
	8vvANLfMz/Ryg7a2eeCg2rDQ1iMikyA9hFZYeSnFKNjSMcsruRxIWfpD5GozxV8J
	FGbn6G1H27v41LQwfIGfn+iR1HPlIR7eyDgi1RrYVx6BpEwBToNPpTP3grS5UASA
	Jeka3JxpsZfY2U+8GVgb79vDu9dcVOzYvKyu3UlCiUfGnPAiVrnQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqq8c0ktg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:26:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATES59t029707;
	Sat, 29 Nov 2025 20:26:10 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012016.outbound.protection.outlook.com [40.107.209.16])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq96qk4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:26:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JraP82XBwahrCghAYrvnO5BBUgBzX6Xnt4lzj6RbE/+7TE8et5XChzZ6n9Qsb54sZ09otvMPTiIrIq12c9LO28LIMYR3QSFhQt9ls3sCmhuOquxBCmr6IVSvejqDt2SfrR7WS4CLfc4Klr38hoM5uCdrSwDg0xiBdEsNrHi1aNW08h1kZvE35GagQY7Ej0t64NNegQLjbNDrAwBYvdlBNeyC1il81T9RLCDlAcoAcstnu6vtK14sIqRQTUCxK6r/9bE8C0ess61bbcQ44fwpIcuU8H32iuXyVZ9qtUXfpp1C7M2zmkBN/cOqc0vAjZukj86K9JRVC3JRgzgul7OMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8gswDBNENae3VK5sCDdcBS+d+2iNv07jIZlkZnr7u8=;
 b=FXG1XK53eDDC7hVWfN6iTggTgLkSjUYIEO00VGFN41tsh29LfybbKvoCGWLkAmo9n9Jzkx0YE+00f/cv1G7MDruktXSm1GxhzcxQpaLz9lA2n4TRR19XX3YHsqsi+5sELYkbVvs/LD+inWx34WG+vqqQlrr/OGaG9KiMiiskKZW1/UYlBqMWr0KO/N5N5Qge0y5E5VW3UYLdxn+u2tWp4mgVRSZQ1C+jgU3EPmW1U42GKhpdDRiY14SnnbT9H4HhXif/tLfTrP2KUSBqsQaie3hQVr5B6osPGtpwi2y2guyP3omcycqoz6PkK3I3IwGPc19kOk2jHlxCv7G62unB6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8gswDBNENae3VK5sCDdcBS+d+2iNv07jIZlkZnr7u8=;
 b=mcTHbpuSeNdlCveVr/w3Xe/uwjMj084ectI2oZgMQSnqRbFz2I6VJOYAKo9uHgL8XYSwk4AIzEQ+XqM3gUT9HoJvw54mJ4TDfv28czb2y2JLMBHzmpwWvvod2ItD5eCSz5r8U5PA5G7oJMNz91eJS/j3MZqj9Nde9O/wf4GxX7Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7323.namprd10.prod.outlook.com (2603:10b6:8:ec::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Sat, 29 Nov 2025 20:26:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 20:26:08 +0000
To: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
Cc: Don Brace <don.brace@microchip.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, khalid@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
        cassel@kernel.org
Subject: Re: [PATCH v2] scsi: Prefer kmalloc_array over kmalloc involving
 dynamic size calculations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <2e697dfc-2575-469c-9ba2-4470db34b5d1@gmail.com> (Bhanu Seshu
	Kumar Valluri's message of "Mon, 24 Nov 2025 22:27:01 +0530")
Organization: Oracle Corporation
Message-ID: <yq1qztgy4aj.fsf@ca-mkp.ca.oracle.com>
References: <20251007065345.8853-1-bhanuseshukumar@gmail.com>
	<2e697dfc-2575-469c-9ba2-4470db34b5d1@gmail.com>
Date: Sat, 29 Nov 2025 15:26:06 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0117.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b3af5db-b389-4de0-86ed-08de2f85879d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UorEe1c2ycHxEEXanMWDDOnqvttSK/zS+abnpqwno0cGQgEBSi8SDtBF4s6u?=
 =?us-ascii?Q?kaENAb+cEOGhmoS7HY6xVfwM8jHMwpPb7eqnBcLVPM1YXkaP/ctfXOgjXiS/?=
 =?us-ascii?Q?8J30SyXEgEdCpcY+e4ifRQrvoX1dCMpxHFrc2M3X9+oB8c4pZEe8MBxqDcv6?=
 =?us-ascii?Q?nTLRxN0juAatmhVxCTTcPXUisdbrL1jrgQXT1niJJ03A6dr8s6JCfKI1cYxV?=
 =?us-ascii?Q?7iWWYrphNsRW0e2Ykl5S4+jg4f1gQl7FLMOBGoDIQBKeZueSPkulD0QuYd/5?=
 =?us-ascii?Q?w3eo3zYXCQy6YBeJtDbXhjtSPox2kwTQtHzL5pXnjR4L68rPtZRbofrG0ojw?=
 =?us-ascii?Q?+f0waiG/GjvhIQvggfqAi2gkvjXWqhBKFsgLA/H17YO36qyijZPa+Fo6GILQ?=
 =?us-ascii?Q?5b1o82TbDUmDujXDe2NdlJPTLybUorAuXE1a0+qqlmHFK006WnjN7w7KX1b6?=
 =?us-ascii?Q?f1BbEgGjGXHkI1WN9Vxu6fby0K8DVkoZUogE/MNXeeFSYn0AKODx5snJbzwD?=
 =?us-ascii?Q?P/FD/yApMZF+caUbPSoE8ZzcN7oPa9ivAMLtZNzxCmpG25qwv2zdeGWhjCvv?=
 =?us-ascii?Q?9K9g7IA4I27xcbW23cMylVpC4JP13w7DclcsBA9ekxTwAn8BRTXWVsoMVbQh?=
 =?us-ascii?Q?6XvtZaT3jBbw5gKT9GwkTDULQELXECk+Zi1wiBtM2NSI6OIN99UM9W/6i48A?=
 =?us-ascii?Q?NLz/iCKukYWdj+YVRLuntdRDBy10EcfOUcdehr8yDQnFHb/sVoB2sU3v5EM0?=
 =?us-ascii?Q?WTdrRRaGhNe/WnBGHCXXoVel/HHQC3VPZ9zllOW2EjndV+GIUtlnDUjQ7xVA?=
 =?us-ascii?Q?Ub2HNwat2WVPAYYsVsUero+2wR37cp66uzKMdHYkE95FWfTsOE/HZzmvkdHM?=
 =?us-ascii?Q?De0LgAs1U4QGTNdp91Yjq8Cp+FHs6S/tmUcTXnkeVPFskJgqTZ185JFNt8sk?=
 =?us-ascii?Q?d+r1dH5G3LoeW22h6XwHDm8Wir//5TwofTlpi8r5Ymo+g3Wfe8i0yan37sn8?=
 =?us-ascii?Q?i3exDjhdGlm0iZ5QMCbEe2fGoYFqrZ3slQ+ZyYzMoH1FBYSyBdQBYn1Z0xn1?=
 =?us-ascii?Q?XAxy/NlBO+mvLnlsW0jultPfxB+uBicRWOxHjPK47rukTqCY1hUrc4ERhSt3?=
 =?us-ascii?Q?V4jz2AwxbDq+iiCR0OT1MNqVpfIyMzSad1pwqgX35SSbH3D9KFMrnr3OLd64?=
 =?us-ascii?Q?iOjZddTTjJFxhLfMZHBGDi7MRrgzCYqwNcJECf3j6k3haGVcVncHtwruRETF?=
 =?us-ascii?Q?HVJA3rJSNbLMzizi71y7iJ3myGpyyTrNBT2UDmvsa27jjKHJKukMNkHcG6FE?=
 =?us-ascii?Q?T9uY56AMBEKOUjKk0kz/LBsq2uB6VvIYlLbf94ipIPO3HfNbb4V3ocY0Dav6?=
 =?us-ascii?Q?aF9SH3fVwDoTip65Sm/S+leavWvk7Vl6voRQf2FOlXdB5OpR/Pzb+3Il0m9m?=
 =?us-ascii?Q?JH6S9+gqLghAHcV+/8Ka1R4vYoEgxNwM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZL8+vNncttFVQ09ODNPcdVR5SbdDSnx2HM5JThYWERVzsy8M1i1Ot84aom6y?=
 =?us-ascii?Q?xiZtR3tkfXbmSSlBpc5RH6jraVt/upU3zSi3du94i5icTKhBDvD18r7AWV+6?=
 =?us-ascii?Q?8QGTmufnZJJiNDcYr/R05HBdK5mKVcrzHlcC3F/G0Qt79S67tM/y5z1/0i9v?=
 =?us-ascii?Q?zW3k0EjEcE4rOfkonD3TLrMcxzUHN5n0zK6MBGHXbMr7EjoLNKfqXjX4oXTE?=
 =?us-ascii?Q?1XnGq/KtTBTYzUnsglp5958YMOUEQSgckT9LWUl4R0JJF40QjSITmlj9GjNO?=
 =?us-ascii?Q?vP4V4l85TV8T/nBxEegDj2TTHHfUCMhya4OssMGojZCcD72CrMh47F+8PIBp?=
 =?us-ascii?Q?fLn3Gimj2Q/vCt03uaVi69OdAqVJG7T3Dnr8g+hKT8iyb/g+tzkuaQBizu+/?=
 =?us-ascii?Q?DVvifvQRI/BSO0AgUlyNRiCN6IG7tRh5gMo3ZeCMUsT8m4/MNoeNdf1pnoQo?=
 =?us-ascii?Q?P6BqJLjlL1KFh6eaBJcviFUX03JBdFARl8NOFAQRpUUkjfXH2431Q2lhFU5g?=
 =?us-ascii?Q?TizpQc4CmtfTnC9vB69DDKNhzudrs7oTpmkpc7e/jYs37aH07mcCaopNNLsw?=
 =?us-ascii?Q?lVkNFSqN1+a2WKJBFByvgGd1MbrMftcP7RIQpErYMiHOKQp/w0SN9N4SCJKf?=
 =?us-ascii?Q?I7efaXGtJ8s5svfVRWIl8H7nrGOZ2LGt9gDf+goOR+JSf9YU7Bu74uG/IyXj?=
 =?us-ascii?Q?dw+lIBaCoucz/eeb2M35maJH56V0uuohS4XjpbIkeNyTzjQFMKSOr/ohDv/m?=
 =?us-ascii?Q?JTmYE6M6JBejvYGqfelVGXDLoFkrg0/EnZwDPnGxBsy+Dr0jUoWoQh6P/Jpb?=
 =?us-ascii?Q?6edq5pqY7SO218PRCxZUVOqQ+YQOL+OuTWWI2VzGTkVRhs0yo5mAlvD6HK95?=
 =?us-ascii?Q?OFwy7HsTA7l5R2VLh1KHlIwzEY26Q2g6fsg8GVemPuhOQEKCMiH4sHO70Z/S?=
 =?us-ascii?Q?/jJbJiKVyFy/Uk61SU/W9ipfoXA+BOGm8p7hzQ2iMBgNjggHSmSkTZrX0nKV?=
 =?us-ascii?Q?JYsQtiK0Hh1ECmkk2CPiBIFiDf7Et0FArHY4eQdcjdAR7Xf1ESQmAYAScOQ+?=
 =?us-ascii?Q?QylGYtHexcTyDZ9cFnDAZCw3tZHhS46+vQvd68xc9K11/3Mh8KBgCSNnu0Wa?=
 =?us-ascii?Q?Ko/j/+CGxDkc1GJUS2rzyTd7ne7a+g+fI84mKOgJ2kcs4N9JMFDGNDTS0mSs?=
 =?us-ascii?Q?bgwJSCvuqGTB/fSsvL/Ock7ob6hN4PwH8/u58OlgubBOytf0nXPc4LOUuUF7?=
 =?us-ascii?Q?vg4eLnAA4IQoG8NY4xrBFBhVTmW5za29rlSdC4l9F7W0mKXcgsOtWByvug8R?=
 =?us-ascii?Q?tZWUw/4gcNXyNRw5ejlpXJs8c2ONRgOsJENkAs49tUsiDwNs8H1n4xqcUl8+?=
 =?us-ascii?Q?N2Rbs81Nnm483Q967o/QqMoloh1J9hoyl3HT+DyBEU1UshtXqdMKMr0k2MHz?=
 =?us-ascii?Q?DfzZx1wZpNMMmTKMNpdmPblJjLEBYN/143LuP0TEaqUfll30S5qERM8gXodC?=
 =?us-ascii?Q?bCIBvdrD1QG56Y2h3FnzhVciUZ5aeAm+NKnvMQkxW6JjajeWSJaEnmMiGUcM?=
 =?us-ascii?Q?Xmvtx4ypSfxluXrputDwC/jw/+cnn6eB+/s2HGMxSzsKBImUW3bOTwY8OU0M?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B+6BG11obzWp+g/FOj1POwUREAjTmjbdyGTxoQXqTkNkamKpwtPqIquiqseHhBnwgYfGu7B4umq1cm7IxWUU9WlUKiQBh8op086jWQdX5iT1jJsIGDLvzVpL+5eE1RcFcyHTSXoQ7pE4rbsSTk5xvLiS7sm1hAHOwljyOakcg5biTpxSRXrG1aodWl+yeLu4Vv88bytA5L6AOIwho4Y9EV2KZKoY9+u8SAQFWMDT5+ErWJACQlgiW/dRZ3gPZJ+v7HfWSDrNrDD3cQiK/o3fmWTifUZj2YTVicCvuO0+SXpvvx60Et6LBQlM3qY4KMcOnIaBKmeNpyQxx6ikTpAfXEoha2UsYumbOJEu8R6e98MEEC2DSrSHwc1mcdBfyrnCpiYttfrcUVyfkTLZmimMAvt5MnQOI53vVu+ZIRW7EGlXeFMA4Kngazj6qPCgYv7ePWA4DhU2QS6TG10ZjXK+bDyJ0tEIlOHSqxbbbBiQqXzokEIbHuLt3KsCs5DJRf5QLXfPUpSRLHnDTJ2yZVYn4BXVWcw19hVswAtYP6PNCcppr3Yc9ArkDYBMeY1rQ8Apbz0oiRpH3ADfk77ptwHoagR/8i2BVFyefJkFocDteko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3af5db-b389-4de0-86ed-08de2f85879d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 20:26:08.7147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3y82SghToPFScNwEe04rg/IT4jM4PJ9s87RdIP87G4XIMl8A1hsqPoHolIGvVnxmjyE6hipgmiGHgBQrwchWjy4LA55+dm63oWdmhflbA8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=638 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290168
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE2OCBTYWx0ZWRfX4lWrje/OqWdh
 59GdqECEqmQBCTRLF9J/FWl79ko8NSAyi3vJ0l2OgKdocvRVJMrLtM2wBXfURWQCRPO64/TDaPj
 ds+qI3MsnWzzg8rsAz5uNEiXPAjydFvV/af9JLSYjgnCzDj6FKs9JDH8xggG4jjQMFQTnNpVj8z
 baygiYv8KSzoSM4vsroMrPl6HXz5+6JWZ1gEAvwHN6tY0sQHwKVVyjBhticPBLNH1IppTlFJQLm
 lOMmm7+MhpqiXxYcp459ioLA2JGEw0Xq2t0ajDwOD2+6Mrj+Wb1pzW63BcKNceY1YEzh8ODoleT
 4/hngMa4wWwJDWtVXNGI/MCmqSD2gC8UFtsAkT8TtnRGFa96CGLMQfrFgJqFm3mithUpxaLIkTA
 p69vgamtTjTA7PrM0S2a86I2aF7SOw==
X-Proofpoint-GUID: IhcW55cTFyC76EHjc03aWvXM4w2ACuCy
X-Proofpoint-ORIG-GUID: IhcW55cTFyC76EHjc03aWvXM4w2ACuCy
X-Authority-Analysis: v=2.4 cv=EpHfbCcA c=1 sm=1 tr=0 ts=692b56e3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=nqnvlkbHQM-B-cy_cYgA:9


Bhanu,

> I just wanted to check if you had a chance to review it or if any
> changes are needed from my side.

This patch was merged last month.

-- 
Martin K. Petersen
