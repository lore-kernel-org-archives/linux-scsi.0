Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1623B33D6E1;
	Tue,  2 Jun 2026 02:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365759; cv=fail; b=OrWdYehMHiN4mYsUwLP9OuZrqakSfHVihVNIqECRE9+Nr2PNxQV5DTCGg/NRtp8xTm41FIoE9RrzMkBITbriIIHg29DJS1gnWYipwY+MYJIoPoCInPMLqyuiMsDXPGwTOHz4VB+Ki1g2OGF0jkLGCnEewC6/Ggp5apc+7ayPg/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365759; c=relaxed/simple;
	bh=sA1efsQckx/UcNR3DS72jZS5lymULJPMfteBdiC8644=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YTFbufq4s7ThTPecAvtEyUcfiRNwk4GLoLctBxZUVk2HM8OzNHcQsDcUh8l0owMrOOIoBCrc026d0Vc0dZAgqoUr4Mvb6ENxLqo5wjcYeidfSxMI+b8ae5NbRWePrU+/Py0E7GbVGcCuG2ZA7ZdRFRQQCU5lKmm3ei2WH73HIbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XkIIqt8s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PgocNeMr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XkIIqt8s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PgocNeMr"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gu4Ot3467384;
	Tue, 2 Jun 2026 02:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sdCdwmmveHX7qmFDee
	6syHMt4DWf1iY1JDmnRHmt4Kc=; b=XkIIqt8sSCsaBdpVGMfCmLaR1HcB4ow/qj
	e87Ja/aDXa/Rndi1W0EhaLM2vOPch18X3MLJZLZb+nEsJFOfZT8lDIkclfDyL/MO
	xS+WK+j4kTf2PwnYCM1o5aOn9xkqJlbmeu9vyitFQBbx5COtFB5WbMiEDEgxVZNA
	nH/+sMfK9FU0N5C89yrCQwGdK9wEetpRzs+pmLviD7lqO8jLJbUZ3AxZlnKD1O+b
	xeAgB2NZ5EUvlNhYXPx/xU6CNKpGhfPJceXeDMhiVRztvm6vnBUy39l2kp/WHuXU
	gPkNoPUW5m/p4mRIVSnfcgtl8sI5VI909qLk1iTvTxSc1I0zWJvQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxdb7ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:02:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521xs3H011750;
	Tue, 2 Jun 2026 02:02:21 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbcjfsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:02:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rtCOoQOsceHCKQdZAoAA/SSIVfeZwYR7xCf0CvLFjWrAsEhIdP6yOYBAeTMv87+FEoKCicRvC+lVgQhdWBc0KXCprYX8QhhkKyi3a2KBtRIx0/hP1ss8dtDCKl5ohrVZhjMgOK5tuJXmixV/HYDxRyMlps0ASBGUyt/cB6TW1YuJf0DsZebKDqlr2xHQqanONrfZe8AxN262tkIwGrxHP3dCRo6+p2c2y4O2G3FmWjQBh9wJsN3Tb5sf04qN29VJ5+QYP+j7JH9ffGpz3Euy2cJjO+7/KZVhd+yuinAjT/LrD32j5RWowsntSO7y/C/BvjaNDZ6kSWaIIxyNwhZyFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdCdwmmveHX7qmFDee6syHMt4DWf1iY1JDmnRHmt4Kc=;
 b=wgwnf1++QTglYgu+dMRROziMAYAHVp+eNkX1WWkMpvceUA+3U3YjIhdKpC5ZGdq/nVxZ6pXter7+wVXKA9DgXETB8Xz1oItd/nIW3lQSchhH+GrPNFIji+riss+T4e+280l72fPgpxxV/vrRbNy1WNvWu2G+RS6CxUQIL3MKchejA+CAxx/g7nylyapjKjmKz8uRa0P6+Ec96P6j7SGZrfwGMxZ5jYeULuX+S9dbdnuJdTkyIf95VLM39eLh31aIlLD6jVYcu9KfgmC27tH7UNNX1EW9mDzARIA3tY6s9rbZ8IvN0SjS0Am1y698Ba9vqVdYYn/7JEw5U5BTpYSprQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdCdwmmveHX7qmFDee6syHMt4DWf1iY1JDmnRHmt4Kc=;
 b=PgocNeMreCm2BdyKOz4/duXLT3HSlGF61O7qJs1oP7BedBUM/VsRcB73iDgsIzapKgShMTguX+8E7SYlAY1QQyuSBLxXLb+5DXYHLDgTKvgHMq3+eRp+8cfYz3L8zBE/Y2Pbu6NccXFe8Baytr27QvXTzZPOKTs37XadTBI96Is=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7576.namprd10.prod.outlook.com (2603:10b6:610:17d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 02:02:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 02:02:17 +0000
To: Chanwoo Lee <cw9316.lee@samsung.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean
 Huo <beanhuo@micron.com>,
        Can Guo <can.guo@oss.qualcomm.com>,
        Adrian
 Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org (open
 list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] scsi: ufs: Remove redundant vops NULL check and trivial
 wrapper
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260529061623.301291-1-cw9316.lee@samsung.com> (Chanwoo Lee's
	message of "Fri, 29 May 2026 15:16:19 +0900")
Organization: Oracle
Message-ID: <yq11pep8ztt.fsf@ca-mkp.ca.oracle.com>
References: <CGME20260529061727epcas1p495c499c91420790a225e66263f3fff52@epcas1p4.samsung.com>
	<20260529061623.301291-1-cw9316.lee@samsung.com>
Date: Mon, 01 Jun 2026 22:02:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::43) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: af67959c-ac6b-40da-05c8-08dec04af93b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	MIBNICeacUsNN0yxyPisTYEIwn7ALPWtb2wRnl65koQuWUsEJ24aAb9eanuOlI/QZ1EptmNRaJjURubMLpQFhxAnPq/nV6ysHgXRO84HGhKgvZv7RIoaa/W1OiPYG89xNtEQGfJOCASZ4asNo9aXZcx3laMLeMHmtQj8hK40MInotPTUe8Wbmf3nZDaZ7BMc3fbKhSANNV6CxtWZfrqyp/u8oGqp0GGTYk7oI7ZrR8EMA1PbTwWe1noLctAVJjmCPn+DcrhSNk9erxqZa3Kwu1NxlwZad5HMmRKCJI+bH62B5mvNTC77TxXf9EyOnlmmhQeK5eslLQvybAGrk5MZ/BkEDrJRrfI8ZutJcT9/KSGVKEQjXoFWzjlY/LgIPeU2ngMO9oV5J243yhWDF342zHoXE5ukTgT1fthcpT+IiUot0yVM1v1z5ggLyn9GLwOg0VY4eR1AfqhwPTPZ43jJcgqo/yZDOlHwRFyWspvu5L59mfPSL5lRnYMD8YVK0FQCLoLNA77KPU5NDHrFuTf3ZAp6OPh300TVbdPc1i2bIn6fMKaFtCcJfCalRHyHrqKHZE9QGusYymblS9gHDAWiofHAQrtQUb2721Bp9USSgpqcVixYZFJ5ljbjYaL1xlh5HhEVNfPfkRRfNoZicbUpiAU41gyTHlmzBRBMsY88XqLsQS/djmQQaSOvMKLZtIMf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YpgLIFDDT3FIE5BBdbhzJaPGjcSd3WmySDPwZD3hqygCJJdWu3ETIQb8ePER?=
 =?us-ascii?Q?2x/Jv4Pet2u4I/2mBpTV1seCrKmVptHrJDQlvpriJtZbU00F62GGwhTX6pFi?=
 =?us-ascii?Q?c5JCOg/UPB4JnQuVozlT7W9kBKmeiXcn3L+hrziXsb3podxQhHXfN36KuJcI?=
 =?us-ascii?Q?8dH7H1DVPrLQesGDcSDzqY8hN7o5aWdUM79m0kPJR8d+rYSUsPHx9oxcOsez?=
 =?us-ascii?Q?kwzgTavgyMw3hmgKFQCTbb+hKwr9k9Nl7dAsCAxBNIgl+rxbO+/fPJquu3xI?=
 =?us-ascii?Q?uj0VWQyirScDa1mWLC8tArJDm4sA9dvNpdBRTA09Us8Xp29BynYOY0WvG7YV?=
 =?us-ascii?Q?OaRHlU3FrvTYeH0TIGSxhgR6GpnEYZHyhypxqUHcj9kmIWeQvLbn4jdmK2ON?=
 =?us-ascii?Q?kAOrtPCzeTpKUToedCo/RhOvTsamPrASDCJfuB0sVnQp1QavTjA39PLBLFwR?=
 =?us-ascii?Q?0cC6hwJmSyo5cUn2QXc4aNwDMhGBVpjNF3oyX0JFZok7z56gMHpffIkZ2c0M?=
 =?us-ascii?Q?74DMLIu7CE+SKw4fytVQeRHNGcC6mW/qNEVjT4xTuZCdk2g4JjyWUheNMfeZ?=
 =?us-ascii?Q?Q8U39FQS2wjylHNJWBL/lNSykasN7eD9lc/X4wo/iVvI6fvQT02FGz8Oo0Y/?=
 =?us-ascii?Q?3gAjHJeX28ULLIIJG5tNM4Uw3A8kDJf3R5A8N1q5VeZDVO2uRdRC/092i3s4?=
 =?us-ascii?Q?UQISdIUWlHjwYvYDYY6w3AFR1usqcFSr+TgBg1+Sto2MqC3jwAoxeDFkBqY9?=
 =?us-ascii?Q?Z8GyMUff9iZaCZCnZvHU1d6lgKzlu5rkvYjZs++orvqp2gaKV+L3YvrJkWwF?=
 =?us-ascii?Q?xBHRqf7xrBEph563pZfG/HqKXVzPjaQGMrkG05p//LhPyChE4cT8U0VeY765?=
 =?us-ascii?Q?QXZBgvmis4V+Fq1UXdyNdInR5S6/Sq+qsBni3lrhVvXgh+7I9LRg0ICbJ1AI?=
 =?us-ascii?Q?RExGF+LxE9/IfeI3MY2k7wekbpQrOLyF3sV9x6AqyhyuPS7K1UVBb3jx9ZrP?=
 =?us-ascii?Q?jiChnvEuFzzGudAHWgMk3Pwy1IbxvUYxP402e2VsVkH/es+geTZaHuWj1jPU?=
 =?us-ascii?Q?v/WhhsnL/j//FhzY2fgzvDKgy1CM1czL8kTAWc6G5l0xh9dn/9XE3x31zqGB?=
 =?us-ascii?Q?RR8cCE5jP9PWHi9/lJCQNarNXCMaCBkMcNgzxo8JzIA5wce2TNccxie0/5pu?=
 =?us-ascii?Q?fUCON6oPkVHCMfQQGqp41jJhaTmN5Tz8KFqPPBXAJwwf+eunFDc4Ivvdc4tV?=
 =?us-ascii?Q?F20Bz6cbSMzsrxisN0211vz/TDSa65fYbjJRGsiu4HyoUPmNWaz/KIdYlmPD?=
 =?us-ascii?Q?yK7ABqoRQ+GM87xsYtr1VKbgJTKtTXLGoNArX45HUC0WKv0VGbbPO1kUKEP7?=
 =?us-ascii?Q?rc0UpGA0jMSH4fj2grXoqFrQcWf8hjM4fbe58PCHRFBrvBT2gZ8JczffYiQ6?=
 =?us-ascii?Q?aOJw1W5Z5zVeEGMHnIj9RtaM+z+9P12UzDr7ZQIJqC/f03/2/7rikLscC/nA?=
 =?us-ascii?Q?fsZJiFJjTgi9qsXBr/+lVaQBTSkfU+VjR9i72iPqnTdUhqHHuM2G4y9RGz9q?=
 =?us-ascii?Q?HOWZtZlXULANycpKBV0MwR8XrN8xllP1jP5RgBLu6gTbc9AZBTENWLMc88dr?=
 =?us-ascii?Q?r5s7mr6MfmonYxNmHNQcEubvVqDMQbKJHbc7U1AbDeAHPVWSoUO29TmBxZxc?=
 =?us-ascii?Q?ELerWNe/TSsbxCqGYHoZoVSnwRgw73wCqEOvO4wSc8418jjzglraxFlnqeoc?=
 =?us-ascii?Q?JEDsbg3qhdA//SkK1wFDWU/q5pBIQUI=3D?=
X-Exchange-RoutingPolicyChecked:
	Vn+Kpj5clHCngoJS1pZe/x+tdpvnFXRVjm8sn3yTi+kvccjAuh2RhVRxx9mEq/rKDIRxVyac5+uyZss9yAJUQQ6L+WhNXCpCUay72j0fV/grNv/F40LXff0PHiSJyT42ZywYcAaRYjYJCnfRwqEFcsdvORW4qpI6X0rVG1SYVWMrIfSQmFK+2+8Tm2s6mC0UstoEauXzse24A8Pzyo/SUxBOZOEij7hkZIXU4B9xpdi0J33z1hui9NHkCXpGaZ+MmJ/wQYgKSggGJs1jIGTlLldQZ4fzNBw4kWEqgD9yrrs0rQk4x4OU/UkF7OHXsJ104KSD4EFhlZZJgYgUVnKquw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fy0RqogfLdlJXPjIiWAMlFyz6yhcEhrBSvZdkFzaC5G3KdOC2A1+E47wGOKFAZQz4WfvGOtQ9I+tz0WL7SD05sbCQJDBGk0tLnBHYvodHiF0sgDQJbW69priVzuUB8MkVqeAp4EPKXYPD4Fp5PfXmaSTp65wsmr2uop2UBQZ7ANK94zXSpUYg7B2/f/9RPD9kUdl/Bkq7Oyo91NKbNB4gMyfjMcau2fnFKCGEni716f+YYtzNag/owy94LMp1QgM6D37ye4+ckeLNr9SiSjXcg8UoNe0dDNlHNOrwSKSho9tB5yrIwYedfTA9i2sA8Dc/zTBvkSTzPBEcJZ8Oa4FQiaxyADE5NX/PcgRIawIWUTvpqfzjGGk0t/MZ/3iOdcSpU3Z0cIcId2+e8ybwFlHKJkcJU1JLLYhIywriNm5JeOMquiLQBG8E6E8AqrV2I3O0LygjVKxullyjczKnlr6O1GPwvfIkGTPVZfn333f55d5Ky3gEILl7s86RALKpej4AxtgdspeDZDOylulNnffj9v2AJvijOUGJw9Xtsls45f436blG3UTpD8Ej9nsBCWdWlujAMXUr7wLSvRN6DZYb3bEWDkXpnTaqR5Rj8fgYuo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af67959c-ac6b-40da-05c8-08dec04af93b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 02:02:17.5858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AEVbA9/Ppy6ukXUvizcHNZ54DNlndQqGqABod596emZmf22CFnfq06SilX5sGGKvli12LjheUJzrdiI8f1DKYBV9fDiR+nkAgcoPumxHMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=953 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNiBTYWx0ZWRfX8vPrPW/vjl8b
 fnbyoQdBNc93aMMhOp0HW/7wjt6S92zC95IsVvGJRV6chI1Q01s0m5VHp+RmYoRno/xjG5AOmvb
 q6VLuZJ1f7sAhtf9bvmfBty7m8i3UeqYrh186wXWP2Ur/hThuT16iQ3yV905TKZPOtLPCbcN4hh
 ghBcqwC5tv6x3NTaMmBXeM0J6AE5a5k7OQehRWosrz2o3/oxtGayF10LacN48j3ho9bI7CCkMI2
 BjhRkmEANLZKnllLsFWCePU2E7ABiLY03rvr0Yyn0OdurDALJ5+/jm2TSh68xCoW9bbymYOW6nJ
 eSmxFqUB1LBe84XYi4JXKkEWOwdBHnJBsfulKzITCSrydrPjH9lp60TQaC8PEPmxKkMP1uRUYQH
 G4fkV1m8a3XvwnCNvnkvc7l1JDxOGufKFUB2evOdeKmPSspK8uEJzYfcsWTszgvK1i9C48AItbW
 HAL2xMM4jA2CrQ1ZwbQ==
X-Proofpoint-GUID: Jv6wqYnTYqg5F2hz4hgiXNbo23xW8EOn
X-Proofpoint-ORIG-GUID: Jv6wqYnTYqg5F2hz4hgiXNbo23xW8EOn
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1e39ae b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=Vlg14O8ljXDgrsEdhGsA:9


Chanwoo,

> ufshcd_variant_hba_init/exit() check 'if (!hba->vops)' before
> calling vops wrappers, but the wrappers already do NULL check
> internally. Remove the redundant checks. Also remove
> ufshcd_variant_hba_exit() entirely since it only wraps
> ufshcd_vops_exit() with no added value.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
