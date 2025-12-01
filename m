Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1385330E0D4;
	Mon,  1 Dec 2025 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764609951; cv=fail; b=UslcnOGlLkpYUjzYGPu7DikmlpfbgcPnk5ToZAGGYzo8Mkrbp513XJTwUgYmsp1QIRuVsy8qO0Qu5HH5y5J4zmVddW1+jreS8e+gBGwzwe2yMts3mT961qS6Lfg2o13xEqVwL4u3hZW4gFi6ScMqd72EcmOvXfkn0i1+lqSWMHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764609951; c=relaxed/simple;
	bh=Y38nzYS1bY6XupVNEwwUT/fT4yHnU1O9aYO8Fb0F0To=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=n/cw47Qd1u7nRmg7qpaTAon92TDJpQC17M6R97G+eVR7FnOM9Ot0VSVq/rbfM3Pt67zc5ayR0y2VW37N/qHImNu/sjJg+PEka0VYm/+0+uc+AS/SsSuANBcbvYyKgYTXsTujOgfQjwxRRFi6qAFPxWq2CuuegFBmA6XxK2z2Ob0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i6ilSV9N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A/05IEyW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i6ilSV9N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A/05IEyW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1FgOkF2315405;
	Mon, 1 Dec 2025 17:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ep8w0nFdDo8GLywk+T
	PsLZ61LUayB4UCqPG63DoaBeg=; b=i6ilSV9N+a0uaCwCF7H6YJi9ANsrmSz3DB
	uWZme0FTEB/69UYRI5Pg/gBqNJWs7RCCfFEpXGcZgePgk18UmlUfZrd5YEvf5isP
	uSUl2sztxljRkqSMyNIkWuob+FK9ajMrizlHvLiGuZyeNREmcuLWJb9KUicwPsgt
	HlF5eUx9UxMnnx5oOjynd5/z4xh0uW4P87nH1AdErY9RGm6fT7Xnp+JyPeaCWwaO
	fSl2oW75Ky7mzXQwM4isy2PMIBNcsoPyTwOsxvxSfL5C7i2PxsZmSlAdP11En6Js
	65/YsIgxL5wRyn3pMKsmsmSr/1GG53MysQgixOs9tFeNSENe0ghw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as845rxrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 17:25:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1GaEA8023383;
	Mon, 1 Dec 2025 17:25:31 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9bt3ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 17:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SuiVyDCgOLcBk6EeaWHu3y1j5XoDkVqdGkLL0JmOqmLhsZWt6hvZj6G7+iNojk+sx4cuuOHPOvo2uusHO8oNsnj6WZQcHwoj8IoW5vPjBMIrIOQLS6FMNdhGW0O2QAnepk7aqClWWMyVtdGNyuf4HINaVBey7JqZZ49cN/F/UB9+6zkeyK6vRCDdpHJoXMcZy7iMn592Yx7bZRbe6Dn0K82/BmcA6BDGq+tMjs8Q76Yx98tkQWbPDstIyLhczH7VATXKVIj3GfPq4J1X7l6Rye2+X+jeYH4pZXfEhWnoCJbBYbECu6C6qFiXdVMklSD7FL+VOn0+yoHptjMz8KmHXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ep8w0nFdDo8GLywk+TPsLZ61LUayB4UCqPG63DoaBeg=;
 b=gC7PQjEpFfie7fq96EFE4DS1KFmMQTy6Ey1VNPKQIOXfV4+DqSaQ1tubma/aUv6PHp9SKsgsgPWmC+uJe0g0RCuCCL3ZhunSiWwf2yi8mR5yMWmY7wHISjjB+2CqQRZ9BetF69svcTkmeGTRPJ/7vBfz5Yml1I4iSWy6kiHN6P9L5jjRduUdokNjH4+pZQb+0BnGhGwKmLGI4gvdUorDA2WNLx+oGJBqlqQKtGbFTyKuEqjAQ3l1uSOgG8FpFg7c6Ge3le6FZYSqcYlzhiV//gYdzKZS+/eYm20gGouTF70M5Y5GlhEhzMoKYw83TJUZiD58bfYl2J1jEwHpHuEDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ep8w0nFdDo8GLywk+TPsLZ61LUayB4UCqPG63DoaBeg=;
 b=A/05IEyWMpKlobqxKdKAJ74D4YRnperBGI9R7GHVfDyeRdfB9JNvE+Uuv6IGpxfay29d1PzbZ+kOdqmMqCe+91hsH2kROyGz+BXAyS3Q5iK2M+Gqgba7R+7VgL+SS4PbnEkQf7AU26pijq9+wJ7CJ4bkqgTZGlZVg+sKZiSmeWA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB7379.namprd10.prod.outlook.com (2603:10b6:930:96::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 17:25:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 17:25:28 +0000
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@sandisk.com, bvanassche@acm.org, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        can.guo@oss.qualcomm.com, beanhuo@micron.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test
 robot <lkp@intel.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251130151508.3076994-1-beanhuo@iokpp.de> (Bean Huo's message
	of "Sun, 30 Nov 2025 16:15:08 +0100")
Organization: Oracle Corporation
Message-ID: <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
Date: Mon, 01 Dec 2025 12:25:26 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::33)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: 08fc0a32-fced-4936-bf05-08de30fe9f06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O84UkwUEg0bj6obZ5VeOUucGztztipGNlRujyjj8uDiclqq1aKOh2QfblYrB?=
 =?us-ascii?Q?rhs5uTYP7IUyLNfwXVEC3KHR8uON3tz1vJUNkTadUQiYX4z0ArVPyU+PXeHP?=
 =?us-ascii?Q?hckO8UZpGhhSeKnBR+A0mz3Lh8VhsmSGCxNAoqWXH0WSBrB2nF28QdrBwDsw?=
 =?us-ascii?Q?eQNhAeKYZtPrWIzZSIMhytGmVIKz5SN3kavMvp/FMrcgTR7Xor/oe4LOzMh2?=
 =?us-ascii?Q?bB1pehGN8rsTYS838Wn7TmGrhYpGyb5gre2p1QdzKBUy/ndzDAb62LJ0rDep?=
 =?us-ascii?Q?ne68wKH6KztJS+dWkoZ8AIf84V1m+1ptFnswv5VINLcGPVQiZPoHewcnfR7h?=
 =?us-ascii?Q?G/YKgmipWz4GF9k/LdOcstRHbK1DMa/W7nN0DNVtEX5gBq9oR3tFzGaxwuhQ?=
 =?us-ascii?Q?MxJ/H37yMWe/ItMBNkKTbQo6NB3emKNhPXajp7VbFoKnizcJBor5Hp42y4Jf?=
 =?us-ascii?Q?TjFTEJPqgk+xeu1vnvU12t27ZSBJMqnICox/3hHNV2/uIoPU05mawrp2/qB4?=
 =?us-ascii?Q?Vf2Q1OtTK56NYpDev9y2GPYIuQKJqW1g3mZPLnPBc3d8rjpFi1kO7lFI1Fk9?=
 =?us-ascii?Q?8w121ipjf4UTuLnSJCPC0gv+WhAfwSfA8+WI0c3L2m2VmoMvisBKtxauqGkx?=
 =?us-ascii?Q?ZNcyXqf2XbMgxb/EWX8tbtFx5NmiI0v7olS69XsqGKJvPrWzDJvB52lp8dI4?=
 =?us-ascii?Q?+ZWjfaVsI12zeF07iXe39RnyA3MSHRKnFBe30g+rnTD3wQBHR8fupuhia3S3?=
 =?us-ascii?Q?ixuk2NCuUq92cKKk8eQfqu0Kp3d/LwaAvoLd4G225hW8mtjKjrrTGQCtgPDo?=
 =?us-ascii?Q?4JmhABeZeCuAeNV6g01u+8j6OElx+JU5ZpP0fP4Gi8fLjYZmx3KkmQ8880qb?=
 =?us-ascii?Q?MQ4hmGMr5PAKsSbVtDmewTwCy6WCQ4e/ucGzmVilasOeSKlhijaqseyZ2oLB?=
 =?us-ascii?Q?RX6gynQ7A5wRa+L35lqmmkc5zXbhUyhBJt/8TEyFcAYVvdd7jNH/tZikQJsP?=
 =?us-ascii?Q?M86MDaPlKhSUuo642Ov7F9hquucnFg+1lQt0JvgmGsj0hgf/HKlsgRMA2SsR?=
 =?us-ascii?Q?oMwnlK/eSl5+NCsl1rIwYmh3Rzj97etOrn4s1ktk5nXPu6FRDL/MvJN4JDXP?=
 =?us-ascii?Q?kXDz3qnt74t01UIUmfLIetUAkGxSJOABNAMDAe5pGRarzIEDv68rtWRFnR+E?=
 =?us-ascii?Q?zDXX5XrjGkAZAbqa0Vvg6A9R9WjoHFyNchZM9t92gkUJ/e2qf6ycGGndfw+e?=
 =?us-ascii?Q?8ZfjvhNjvC5i65l2py4ykEd0kMSswBv7Z4BRdbBqbGeirLLafaLZ//svjh+5?=
 =?us-ascii?Q?Hf4TTPfrBe9A27B12eQWqjtoICjUg03qh4/3vfgDScgaEGx3U17SpL658Sei?=
 =?us-ascii?Q?g7kmcZEIi+fBt54WqEk43TiMRh6EFx0wbhO/BxNOpvUQVVXm2ZKMO2oZcC/O?=
 =?us-ascii?Q?z4nYCAS1zOFmiPSfASWxJ8rnDmLxwwmj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?73d7dhNwGFZsvs/nXAeSrWQl1xS91L6IvyCHdzJXBsCEded7zB2Uftlon6Rw?=
 =?us-ascii?Q?KOmNjldIem+5R0BKJIjehdH0TWOT4IC584B7MD8qEvmoneo+oBJGRLlFd5cD?=
 =?us-ascii?Q?WAJsz8ViVkR2HiuL6/UpHG1VLnvz6GRTkjUKMzltx8pDnzTg9vyhn6tskNUz?=
 =?us-ascii?Q?F/1BEeSU8VfDos8dn7nrRnJOS+7t6aortMfskdOrYWoM5e4RQOHDT+qSKhtW?=
 =?us-ascii?Q?9pqzcND9UwYFVoG/cvvdRqPdEzcf604yZdhxCKax7Okpr2/GeWR/65zKDRrM?=
 =?us-ascii?Q?cLYj4bhFZhzqgHNKEArh9YvoIluR8LUpHH6fgdO1C3Y61+A/wsrbI2VFf/Aw?=
 =?us-ascii?Q?4EbruHFJkTlCWdh6taIrjhlf76NYavq8GXRaspQd56Y39NYZ2dJEF4vOUC3a?=
 =?us-ascii?Q?i2K805zsiLoHIf3zW0lrjPn/R003DqjuBDY7AKkjOY/bDqj/Y283oPAmiQ6Z?=
 =?us-ascii?Q?CDUzHzIMLDC4KTLWxAcES0lSocXj+DcGA4Netdn478eAdiFm0V+87veFX48U?=
 =?us-ascii?Q?wAV11egSeoapLWd83nAlJf0XRHkDBzjP2yCkmU1Q8VfQGa8oz360G21Z9xHJ?=
 =?us-ascii?Q?DD2UMRF9szSYFYiidqR5OEJOdYALHGA+yckMx+T+LV3iyXlaAJHNu9eedbj/?=
 =?us-ascii?Q?syNt4ne9GGtZ34K2TZetPUjwvvAYfNSEF0ssL8nt6dpXSZapok1sadJGEXSG?=
 =?us-ascii?Q?xUkG7IsEs0mZTgKdmdYOw8tnOVEA9uKliIaEBiaZF8O64wzSifKtSPR0tTSI?=
 =?us-ascii?Q?zirn6QDSoaPCEBfIh6ooMHu7PRuTHvXdGwGNYx2ltNqBud9yKFKomQ9qO3Iq?=
 =?us-ascii?Q?Uito2nFTnfdsM696der6Bwd+p8A2fVQ4x/oJQ4FcCfWAFBg1d4B9b0awhR40?=
 =?us-ascii?Q?WrV+TOaPqBCwfB3+vYmRFwpsZx2B5TcyWtGb4ZyqsX0t8/zNJrjncATNujdQ?=
 =?us-ascii?Q?LDGX8Hmisj/ZUA5yiMwzBvIwhIIgNcimZWv2Jn5UzMml2pkqmmQxgsIDCHuL?=
 =?us-ascii?Q?G58Yg4evm/U25hOjoD6VtGhOLm53ktzIyx4Z4yEocQluibzt65K6Aoi5+pcc?=
 =?us-ascii?Q?vaZLkQls2z7O1KGjbEij/JLoYSSYedK1IsOdngU4TiWGoTMGnsEPInZxrcWj?=
 =?us-ascii?Q?uWRhB6eStrTt0s2rmtL4cUDOMY7vf2xiS+0MNPtvr1wzmSUl/XVwu7pY3zDC?=
 =?us-ascii?Q?g+UcGhYlcv5ZhliNlZVC7HBurJMzCDQaWZAwdr8rtlP7MjBwUbJ9f0XvXc0B?=
 =?us-ascii?Q?lA6QBoG6IwOQMGiADi9EyoS6eA884E4yGOYiFid8C2eQqFE81cD0DhyLYtJ3?=
 =?us-ascii?Q?pC7rjORTSDRcCHUMIBh2UTZeLVHHY0EZIsaEjj9ppj2kaApHs+beVLLndEYB?=
 =?us-ascii?Q?I8S228wjoE5eZWnq/+L/55hhcaCj3pOGNhESAWBEpryiYkOGpCN4puQgZn+0?=
 =?us-ascii?Q?d8pZ183FgWqezNbHX54r7EraXhG+C/C+GrM+slpuSLyd4QKDCKq2rGszDAhf?=
 =?us-ascii?Q?psy6AWYafPjxRloKALBFA/6etIRyOadegsYUWxeLjuoN4TwKu8qjOogxr8gA?=
 =?us-ascii?Q?Dx8LkyGFIbIjf1xJbVS+ZpSeDw3ov4+uWfPQ8lVGimPRZ6wiI2gUNyQVInRX?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	omEA33wr56oQ0vZDG2trX4rAsUbJxpf+njy1vzetkVIBmbh0J2GJzuPlQWTx4EumKj4d5j+eug8Fk3ygPibDsYzPbkoxq/JcL+BgBavIWa/SdO6ij8eGhVpCDwt9txTN+riLaEsNdh0FQyQBg4B1bk7ssLDSxNx4ht/kgjcRgL/Fd38g6BbGngdphRGwd99m69pNNmuOEz33HVQ5BW2fDCj9fPeKv7S+i1A7ySZFfmxJGFP4eh34sTDT1ZckUPax285frxqKoj5iyKR5WhNk5VylZc92nBkkZMZNeA+iLvnjwV8bEHABSjEc3UaF9VsW/4f/KddCoD8C2wB6jAs9cOLKosk9UIplbaJ0hxmtZBpoWtpMczMkN4DlRPtXPHbQO9hXRWYt9RUtQp3I7sHDkJwFbEDvQ606WjN5ml36fr8PzWPP/Qexrrz64/wIlvjZ/bVAPshA+eEmwtUf7jPtxXo7zPt09bn0Qlr+/L+fEhW98VTc2STzjZWBNFPU8B/so2Ih3kqwKLm53Lg+917jXOsaWL/+anrMf/NFkTBuCMPfKLZXGRKktVk7DiyFLvZOAMeuhOhYlaJrVeT/z+x5Ndpqm3sfXeKNx1rqM9bw81w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08fc0a32-fced-4936-bf05-08de30fe9f06
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 17:25:28.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9lIImOtfDOkuuCcjqbkZv5PoNxKTa2wiTjl7pakgq0NfGmihyfCW8XyobzWOsv9qp4ti1R26y2Ncmau/HwTHFHgW9JcOkQp6X02nDWAmA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7379
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=876 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010142
X-Proofpoint-ORIG-GUID: 8Z8ohSDtP7OwIGwlrFL0-7Q0QW6rsz68
X-Proofpoint-GUID: 8Z8ohSDtP7OwIGwlrFL0-7Q0QW6rsz68
X-Authority-Analysis: v=2.4 cv=W8w1lBWk c=1 sm=1 tr=0 ts=692dcf8c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=-E1QZsLyYw6YF8VPcEcA:9 cc=ntf
 awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDE0MiBTYWx0ZWRfXwq1jXEix+Pqv
 rmmpZPyFCemONAnNehc6MDfR/9bv9SkEt101PFBmNTpHivVI81EB/wXUUCAMeKnL1uvf0SW0BMc
 rLscI7zvXzgcCDxl94G1QmVytTOIyhmcDGrLO1SXQuSlPlCIpOiGCqNqv2C9/ZsMOYiHLt4aK1Z
 e/H43uAjBAL7Sa9qlE4QKQ2dGMrmk6PGwgau+kc0nAzkh+t0pNSk+X9yzaVDogRQEKNzq0saW3c
 F8/KXt7HSte97UNOn5AGU1lj5RZQZttI8XOLL8+XWlpNbrfYRKWt/7YfGS3xMg3gkJPJNizifN0
 NXtiomCpEuXNdhsfYB4h0rw4g/lYitVRQFoHZ24HHeOSaAJzvV25SLzuGayJk9cXjpc19wnOR4B
 SIfsamwXTycPOhtAU6Vo2eeMgBJBKrZRu8hpx8TPBn8AfNQ51eM=


Hi Bean!

> When CONFIG_SCSI_UFSHCD=y and CONFIG_RPMB=m, the kernel fails to link
> with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():
>
>   ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to `ufs_rpmb_probe'
>   ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to `ufs_rpmb_remove'
>
> The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to true
> when CONFIG_RPMB=m, causing the header to declare the real function
> prototypes.

This now breaks the modular build for me.

-- 
Martin K. Petersen
