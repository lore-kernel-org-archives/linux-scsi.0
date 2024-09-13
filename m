Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C8210E3;
	Fri, 13 Sep 2024 00:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187316; cv=fail; b=f19Tvua23pv23E6X0e6tD0OGXdNmVeonJtxdoorbTv3d76OGNPegQwKWHzwmAQGSRM11SwLHkoWge1YPC0fKtH2tmb2gJuY/+vPH6Zt6EQQKSgwrAUicXUzxldHadPfcCLDzUjgdB2ePiV9HR6LfsIPzOPQ946nSgKWQ9asEoUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187316; c=relaxed/simple;
	bh=Uf3AJDGYuhJpKhaFeoAUgm34SoqBGRlajpL43Iig+nQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IMFZJc5IqCFslvM031b/ygeVkkdfMCHEbTIjtnAdyiNURF/6QPLfzHsJh8haZ4y64a1UmaV/B/wi/hcbHO3IiAkDHFYSrD172zw1tkBBy5SJiRODd96ybs3D+mfEdRF5je8+TH4dseinzmTdLFbNy4mvZJJCb/dWIXr1E3BX8mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZX8yxNmx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c7qfzS39; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZX8yxNmx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c7qfzS39"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYdY021198;
	Fri, 13 Sep 2024 00:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=32KmZadVi2C1pz
	rDJLtxCDNXoj92qByde6UwS6EDFoA=; b=ZX8yxNmx1bTSO6Qwj/ghoRRVnPbJcm
	bTbBAzej7AjKdbwOMDx/bmA7NAubysCs/S6TSX+0Xujh0FNW4Iwfp4pFpXEm1Btj
	g0y+yqLrENUOiH0Zq2M+VWl6pC2KVqtDsK0GzT0Ih7GqBnSqe2SJURWrXLhre6ZF
	qWOplkBiFVwoTpcc8x4YsgvcBpAE1x8wL88hdCCF8r1w2sogPQ00jMdLJPc7CZlx
	fY6uNLRQD+bHplTPuCtah0p3Rutx5FMXxPCYulH19QW7DJmefvMVAR1PsFwA0xOn
	dMFT+CR8cr8yOk6VeXWYNPYte0klPwgRwWGP6djWJHSN/x8hdGRHfchg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfctm7jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:28:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMFfbd034134;
	Fri, 13 Sep 2024 00:28:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9cfgfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:28:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QFFc2tKwkUNcRC4qX1OsiQ+vmC39am0Wt2GlvIP6eTQmvHD8hD/X8XaiJ/b76FHZ8pWcDXyZQ1vu+rXT/KoSyZLJ98s9Z3WW1RJvptNuysSjVjL4BHjfeVoCkwCVcMtQh6YUBRiaoB5Pi4wtk8/Nkc2gO+204csBJ4YyeipwL+Cuuh9oy0qlDYYDEfo2kGvv4VFV7jzrHrVYJJBfcIu5LhGJ2QWt9fXEQ9+fSn8vTjz01we9QfRkSQpTTJWLOMIPV9mt0a6FsEcnpMcVwimZBLwB52/x3dZqyxtvn54/awQor+oTIttoefoChZQ9smgTp0tmBMyJBhVuJeDbOM/lqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32KmZadVi2C1pzrDJLtxCDNXoj92qByde6UwS6EDFoA=;
 b=EtauCUb/byxtuV8aSn2A5qfJAFTioi5ileBWr6cQPQ8TW3HZMnvpvPd7M/9anSHiHF0vUVBULq+EKWyCVo5IPMWU1i13hZCAOLxHwGBSoNuo6rO7u5Za7ljVwmKUiQTxWVkL97dlDBpzyWCemQmVNHqzQCU/9w6TUeRtrHV7lfZ1K2DS2gAZ/Z5QoW4KWQA1nMyGBWf22vhCeypSZLKCemSaWNzYoV5kxTu5Ot+nDCT4/7MS4ySVeo0Qymfqg0y+y7Fq4+B37+GnAddrJf0P8YJrYS0ZkTqAG++B1iida4wN2EDxp/lQJL7aULV3+DG0seQZVqNxa5MLQ3ZwxtmsyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32KmZadVi2C1pzrDJLtxCDNXoj92qByde6UwS6EDFoA=;
 b=c7qfzS39//2zZFBbc6OM/1C4mM/8Bex838Y5V89AV9E5YGBV+dfLyHM8/AEV3kfiTcYE52+fC1IKdclm96GBBOYbamyFhgN+//ms0E5SlVmqvZ4N4sIrIswjFCgEJYKwwE0Mo2Ll80Ey7q2ftD10/nwx9R/iaUCtfOgNVel6UJQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:28:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:28:00 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Yihang Li <liyihang9@huawei.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: hisi_sas: Remove trailing space after \n
 newline
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902144153.309920-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Mon, 2 Sep 2024 15:41:53 +0100")
Organization: Oracle Corporation
Message-ID: <yq1wmjgxurb.fsf@ca-mkp.ca.oracle.com>
References: <20240902144153.309920-1-colin.i.king@gmail.com>
Date: Thu, 12 Sep 2024 20:27:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: df65f569-db21-4fe9-3cf9-08dcd38aebff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2rhIR88zEbvc9qL+s62qJdABqum9Pgt4+w1hyyNGhvmwQp5E1hftzoMuZfQi?=
 =?us-ascii?Q?16YcTRveydcmPnwFRO7jjJ271h/nmIxIlvslNvnsy83HyPjEsXy3DY39N/ls?=
 =?us-ascii?Q?uBYsNpCFi/E+/FFVWeaAFRWZ2pYN8C2+1+BATLV6BDoU9+gNJ2Mazcq/eDKB?=
 =?us-ascii?Q?LVsMUisVWMVIdfSgZqp7bUa7QV4pfmAoPAezIAuaHp+Yx7qV6E+3hizEzkDA?=
 =?us-ascii?Q?JMH08eIVaV1cz/nTIRevzI7bCV07ejkwPQJmAzI+RrHKQ4dcNqqxp0zh5eKZ?=
 =?us-ascii?Q?AeVuJGKt2mQ9ykGyJ3rZ9HQTtN8X4mJWXaGMWc2vvdgZ7fnRcXkH37pq5yju?=
 =?us-ascii?Q?UxQygCLWyw1RKZdfjeiyiD0vFdnQWTVpbhabhmBqrL+tSs9KCTHsFx2YZ26Z?=
 =?us-ascii?Q?UiIMVdOonYzyxBkKjSiyrfkt5lnIm3PN8nTdOcKxWm5j7+/awvk//AzCkLbu?=
 =?us-ascii?Q?Lo2v7cZ1xITFD8D9B1NPmV/5fVnV5c35zCfHqq41gOrdxwcZoHJ9RvYMpQHh?=
 =?us-ascii?Q?Cv4rxv9kOq7Y4EjccOU4ZJThpIa3wKajMohVKmm8mVy4R6EB35EJmjeQVVfL?=
 =?us-ascii?Q?oRf+heaQ7Gz2IRcZyEfi24pYyv72S1oB335qQ8P0juxthALyVFZ/oW8fB4d/?=
 =?us-ascii?Q?rtoZjo7HwWhdmmKHzf2aJpMpA/D38XHo1JsEGsra78UaEsMtQz3xKUb5fdGp?=
 =?us-ascii?Q?Qf32NPWBWwGtBO1afLpr3Cf86eJq/E8NY5AyBgDPB4CMORW6hDao7sMVBuNe?=
 =?us-ascii?Q?nB77/wZ7x2zlfZ/so8QSdhyARFq1r61quDbjHtFJwp/g50aR50GHphQWrhs1?=
 =?us-ascii?Q?Y1QnMwJZvu+RUAP0jqffWodZUmffeiLH70DF9FwftTkUMgSG0ZHRPt5BMJIq?=
 =?us-ascii?Q?phuIOVkWVuSj7LguKz2wE+tOvZaAcsJZ0SRU61wRGnMSos9S4WjgYOfAZqxz?=
 =?us-ascii?Q?wWXBSTcnqIS2vLMylkJ1mY8vZiNENtQZUKTzdNh9xBvEjgJ0Xmr1TIuKyxJ0?=
 =?us-ascii?Q?CcGzlvAzrpLCHMSBefSMq6jM4FcVnh9dV478xDKUjV3kTaDD5dw1ArT8VgbG?=
 =?us-ascii?Q?PQG7O6EuPI5K5tM4eZ/1xwwctUA3ohBnfuKcTJqYV6X+X5LO5oaABXNGG6WS?=
 =?us-ascii?Q?6mSZPzkIV/VvltGq/HDBadLrG9XJJ1ncAXn/CUdLSv/RIGns/TL/T/Iw8aFo?=
 =?us-ascii?Q?nK3dWhp8E3oXAFuW1S2Y7+X18gRRfW2beNosL9ODzrsdMSxxAoFZCEaKNWiu?=
 =?us-ascii?Q?9DhvfxbETbsOtkPEdCTpv5a3LNZee8e60VKS+Maq4OLAnGihmQ0RS4LwIUhJ?=
 =?us-ascii?Q?pVkZ7Fl3odQfPwRX09z91+8zCI0nimJmFZVAeHcK8DyCFQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?19LO/IG7B0Qq4DLqWYWFzipNUzCaZJsETP/H70RYPKObUbOAWBlph8In2bk9?=
 =?us-ascii?Q?pO/CkTJcVsdwHBC444n9esZhyPVjn+6y/bBo/aAJKwSwrJQCYjGc745766lX?=
 =?us-ascii?Q?TyW2DGmM1hkc3eYeafBq7HxrMi7aCovdA0N7hAsuDo53L+QkZjJ7/EmIHyuH?=
 =?us-ascii?Q?xF+F7BC7TqoSWuuQmKH79vEVijAsDMIFKU2aQK1wWT9xLTXrG1KTysC19HBM?=
 =?us-ascii?Q?cA6fFju2ixWFViPJvV1W0zYKedqXZYcc1HSVJjNrljmoI++zU4JTvB+s7GEb?=
 =?us-ascii?Q?1bntaFHEnZCbDUERXS2ja5+930VAbcDzvc5WOphaF74TKObEGbC0PL6y9YiG?=
 =?us-ascii?Q?TJphyUO9LnaEnKiesVAzw4FxsUAZboeyliBAwEOrka7m95KMqzn1Uu9psTl2?=
 =?us-ascii?Q?/2OmVX+raiZBzwuvNIxvpR2KVnXXn2MamGLFyVcaKPhXN9wu6D1jtMNG8QVh?=
 =?us-ascii?Q?dJsgFStHQqeJJZKukbq9DP9/s0/P2c5pQaaZAJqh0iJgFbx6d0SqmPhli5C/?=
 =?us-ascii?Q?+qyMqZyX6OehJNOzTQQS3A1h0ZNvExx4lRfax1WGu/yFRmZcBxLioUzvcBbI?=
 =?us-ascii?Q?9Keb69n2UAPf3IPTSlaXaiGH2jHmDz7BDmunYgqpNhEyweg2OaqWDAl9C5Ln?=
 =?us-ascii?Q?Y1Yz0wiNSLeV10JN/p9gK3hntIOYKAc4OirG+NEaooXfRkZiXVY6DsyjVkg6?=
 =?us-ascii?Q?+2DgcmkP6dB8NZOF0exDOd3HE1EZF+JwvTP8L3lJefrDEuePBQfxkFhSC+eu?=
 =?us-ascii?Q?xN1qjwWRncZ4Yfc/Yvy/VXquxY8K8gFKygT5m3DG1nFw4nhpgsztS/PK4azF?=
 =?us-ascii?Q?mUlcfHI8eRIUcViIxjbHRKTswGNwZ2yQ5bjBCrbT5LUQgxzZIH0SpaoIdOul?=
 =?us-ascii?Q?vlvleFCYYvV4r8xK+nP5Vip49dpn77iV9uBWJjZKOuT71z61V0gGGndVnSvr?=
 =?us-ascii?Q?TxGf2XGQ4a01nTKdRmCxrjb8jEy2VEm/cyIC1YIU+Gleqah3w59gku3BNYr1?=
 =?us-ascii?Q?nYV07ruEx2kSnNvNA6369E0ZOF+JlZD9yOWYl/g7EmIUM4InvJGMV7pEEHca?=
 =?us-ascii?Q?FhSkFqaMS0LRzrk1yk9AJIkDjSvXnwfy3BvPvqXe0bay7jHaEGx9n5YFl6Sw?=
 =?us-ascii?Q?xByEUvkbDS5Xj1KXOsSxO2pkjPgwUw4YfN7OYF8JACF5Wup9UGpWkzbNUh9K?=
 =?us-ascii?Q?8aU+04F5Azi+xNiR1t/YYWp3fdJabVM/b4u+pIBSAH0PsjcdHjlGkNBgwqCm?=
 =?us-ascii?Q?aTicVmU09se83ki/canSPzOesPORE4y7fpMXTuccLfL4kIfJDhYtVClBp0jF?=
 =?us-ascii?Q?TLLDtdsRhfK1wBM4Jjv8MbHqzJP1k1SykAKSHyI8mxzhffA1Y8WzrMmcMtLw?=
 =?us-ascii?Q?n3NCwMH2/JEA/U+XiIiTGQLvZWwoeudPXC3Z9BkSmBBITDjbFWOYpbq+cYip?=
 =?us-ascii?Q?Hf2M2xf/K/K8nHYYZSepGl5SEaNVuGsm4mkxadWlegzqnAEwZstlOJyFNn/n?=
 =?us-ascii?Q?MGD3knzHbBncTx1mu1rJrBxqUZFhTxzXVbJfq8KbMhheEw5hvOwdC5RXkTk7?=
 =?us-ascii?Q?0zlv/ZaS1GPeH2ONxKUp7T+PsH2Zvi0PTsXkLvwzjWz6DAorMEFfF0WawRE5?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IBgmxA5fhFxKnWi7khLouV79BqRndPuY+ZWh5TCDSMZIdWjeas3BGIP03wIl9eDeJHjKaT2G7pNg1GKSvkvEmI9L5ABdPzLxHMHN7a/QbapwBM6bvmbr/1seR30+BAfdg3h6DzcxVlcLnZcEBhanYOWshKdEsVyPjmDwS7RZi0/O6ABsVol0dPOq9pcf57s2ToFSj+tlgYLAcnUuaCB+AWX06AESMk1sDcHt62GaUdUk6UOdfZePrO9r0kEa20A69C9rl9LHTAl484HsX/ClwVBVAi69l/1+bv7r164TEHy58nCyQd6Anpd+UvW+L4/GrQEFxokdzOZxQzVARmj/QXoGuAjejKJBI97JGR3xMCmdmungkaGEolgTe2BNwEtBG8IHAkE+SxTNSjPBtUMWE3hZJntYLqlJe2qK4tt9yJfCbatErQe/BVfINUuS5XWa+iqeIUMC2UeFzgmuKdJXwNwUgLV/WTXJmK3aqH1takCsQFC43biQHj42l7hR/u0yFeEme12XDJmq8rGCMX+Jrr4R/nRPD9jwL2Rpnxq+yRf+n5o5dNVt2X90l0F/J8enfEEGysbmV2HMGfZfUrkbJGoTelIgeH3gsaCEZb1Grjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df65f569-db21-4fe9-3cf9-08dcd38aebff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:27:59.9522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdBh9wBXKpeq7t68OUMjkG2NDvLEcigYZCJyK0X5ZFRlw+QmoPJNCSU3aYWxXtEcJfeGh225NQ4fNxosmaz8J530gnQb3Bmmy20PLhiLxTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=891 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130002
X-Proofpoint-GUID: SouhZnVm5ym7GqjiAoxD7lZ_V53owIv8
X-Proofpoint-ORIG-GUID: SouhZnVm5ym7GqjiAoxD7lZ_V53owIv8


Colin,

> There is a extraneous space after a newline in a dev_info message.
> Remove it.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
