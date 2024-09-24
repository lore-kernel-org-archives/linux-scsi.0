Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17449460;
	Tue, 24 Sep 2024 01:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727143177; cv=fail; b=RpHZpTmWx34+ITDsJfqq/o6DL5SpsB/04HYRoo9kfrA5VxEvTgOnkuHcagcrSbHFSkb19gE4vuGYkh2bTm0l4AYSIKbR/nVq327S4BFB40/S7VOUuEndUIvtBAwGhQ78GVO/v5Bq/eaFDWKqMw+mUQERGFMlgD+q8zQUUP0tiLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727143177; c=relaxed/simple;
	bh=qqWaUtuPot0S+8uJksQ/U0rF6D0Q6vr8CGgutumuOGo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qGsDTfdAr8TIyhNaU3gMEGVQD9LepKl7iDwY6AMkyt4JDIawAkhkue1WkbIphcUu/Wi7lgVgqytHAaI3dvjmG8Mig4PROo4VerNkAlDPr202RoMLj+OhBIDBTcqghk1FFUPWQRhsHAVuekCU74+DThQE0EgJLFW/jHa5C6qwVvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=emrXUlbU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X6ZoybTF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="emrXUlbU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X6ZoybTF"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48O1MWAI012616;
	Tue, 24 Sep 2024 01:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=IJIXPk0Umdo+oT
	IJnZjBrvNmke/Feg80wu6yBDi3fq4=; b=emrXUlbU5GEY8fo3IQFiAoGP6Nl7Vi
	OyFEJuuRx4YqzFiI4WnCtaWrhd9e3yaUp0PlRkgt0Ul0pVQBkI4X8MQ2atZEGoGh
	B9LhCZmlKbLH9Yo/BQScPbvmAjpgOt+lW2dZivdpZzt9C5Ll9Tm0DgGxWnyNV2+u
	0a36V3CzC2/VBXSVBHIE59QIdu4dkXYus6y90PZVFsvjkbZKeKmv5x4LvhG3X+tO
	ZKbFMdsT11uo+2leY1b7+93vEDUwocV/aCZVHpp4we+VUhg8ThUIsAk7HNV80tVO
	k2q+q7cJ4il73k2IK7RrbaTlARlW8RKsPAW5I/UtlUPpnBRiOE1qcgug==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smx33s1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Sep 2024 01:59:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48NNDEC1029755;
	Tue, 24 Sep 2024 01:59:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smk8jj23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Sep 2024 01:59:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfklCBZkJukuBZscaU1O8TufQ0oAWA8EFUtaUkSTgFc4UU32FsLpbruNccUj8mGjkg3+uUfpYKO4o2svYcFvFWAqzLqVMr8pwDgqpT60UtH1U0Ost7YRvkYfMPQwBjp2OnTHdfjPLTvqkHbfx4oMzSitTh8X8CXn9hca/vVfjbYL/9BpNNxMWTqq6xP1+TLforS49T8NbWFrzywZqpf53Osh0oLwYn1ApkfBq3SKFpWZThm/Oe7hatbbieCeyxa+EfcKXy7F15YuYxCnBGXD4maI+sZEIj7x5py4hhWoDRO7PzrGkSvUMGQfsK0WtbY7KAYTzts06o+IUun0dmR2RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJIXPk0Umdo+oTIJnZjBrvNmke/Feg80wu6yBDi3fq4=;
 b=GZB5i2C1k6Sl1y/Hbngbo8TyzaCkWiziWwaA4/KIb4t3M4oBKHr4oqRk1rYIaLuDMiaHRywLYQefx+ZMibPMYak6joLGHKHBEfB8PFMMT4MoD49ObfoJ9dEvLoyBuO+sdrdsRyTaCx3qMI8ygKSxj5S/h+o1emG0B8G1kQ+l9AZ0ZFk1xMfjGb1+L8Mj7NsE5lLLQbVfJeVY9alN7PvNONNJrDwNlelfoLGFWfsCzYdSvjZ6fatq51DeW/FuwYR9wQ1zL6k5w4I6wm/6hDOI4pDPIq5Ht3utSMYl/7HLQcb+XwCizkP8YFdAnmOjgvMcHbRm2ZktCrXHRZMHtZ2g/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJIXPk0Umdo+oTIJnZjBrvNmke/Feg80wu6yBDi3fq4=;
 b=X6ZoybTFmWku1EujZ30rATjVvbtmnL7fEOKwk2eZP3eiaT9HDHz3EmGRhgyYFMRxgUgpL5TDiDC0xoygAVw8VsE7hoYIaBfWP8PCthB9GuoRmL3mJZ4tpru2uaRGl0VyzT/lBslBA9yGi1IheChkEeb1WJ+3QksNvNXkW0Cl9cE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4799.namprd10.prod.outlook.com (2603:10b6:a03:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.14; Tue, 24 Sep
 2024 01:59:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8005.010; Tue, 24 Sep 2024
 01:59:12 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240918063910.hqntgm5jy2jisys2@green245> (Anuj Gupta's message
	of "Wed, 18 Sep 2024 12:09:10 +0530")
Organization: Oracle Corporation
Message-ID: <yq1bk0dhlko.fsf@ca-mkp.ca.oracle.com>
References: <20240705083205.2111277-1-hch@lst.de>
	<yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
	<CGME20240918064651epcas5p418d61389752da25e5fc50e6a50a111b8@epcas5p4.samsung.com>
	<20240918063910.hqntgm5jy2jisys2@green245>
Date: Mon, 23 Sep 2024 21:59:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0061.namprd20.prod.outlook.com
 (2603:10b6:208:235::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4799:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a94a4cd-3839-48ea-eb1a-08dcdc3c7c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z9tWTeEZczr12gJc9X0XBprODeS7ryVWPyt1Str6NYAm454K9oufNt97YfbG?=
 =?us-ascii?Q?NBzRdT12O9GT/k+DxoQAeZXYpFJp4XDQp6NVCPTsnOmPMv3iCpvFmwBPJyMq?=
 =?us-ascii?Q?kt3yp0KIYS3RQLxorXUiI3rrYJuO9MOSvuH3pReuT27OoCuuiXIkCqGyrrNN?=
 =?us-ascii?Q?GaPUuEBVTCJkmMzhPEWsQafjF1mlnZdx4G8OPnoMEfTeOljV6g0+PORLvJN5?=
 =?us-ascii?Q?4SLOjnx8L5Tow3JfYEyqw16DwkhAL2GFCwMe7RQqNCc7VriCqE6qeHFHffzW?=
 =?us-ascii?Q?t0vUfuITxhXlyqMXw7ixEgGc77SNVRBniFT71zuDtJ+vDzKGOJPIRB5ARg7U?=
 =?us-ascii?Q?aYmr/zRm+4UgACTzDlE9oA5Hy6xv7Dc7JU6Uh7TkJE7RsVUG1l+wXK4C7HgP?=
 =?us-ascii?Q?m2JcRuqPLY+T0OpcDDEUDliqy39AG3nhE4soenx3OuIWs0RMiy+YjttROaFA?=
 =?us-ascii?Q?ctIt75LANE+419JIlydr7cA2KHv8/oxGHAoyw66wtsnTxtVP3lCbsv1N5mEU?=
 =?us-ascii?Q?fFT076bpWYBGsMFrL6dh5ll+DCmYEr+ylvB9sK3SP8YPfYCwyCzrJJYffsjd?=
 =?us-ascii?Q?5qHABu9c1aFtql5k29RafTspLe/Rb2wryYFF2NopBSvU+Jpef2e+XOHRzrQB?=
 =?us-ascii?Q?gC4g+VY1wzf26rweqNv3EyA/pPann2m/PCKzCbkkz3FlGEJvWOLAkOAPREyO?=
 =?us-ascii?Q?E3ENAQkcgZc7hxfIllb4MsYmz4zhee1u2kG0YGitqdLX2NhlU5kR1JT/g3+2?=
 =?us-ascii?Q?ENFN+3gKpBb/0Tb4P4QNAANsOPv8C42RW42TqNpSb0vFy7BTaKMUQKiGOXIA?=
 =?us-ascii?Q?XNYZ8DHG+mmasrkA2FpUdPZCR2lPSxhoabatbLxyT1AFLOtCFi/0O/DBniEZ?=
 =?us-ascii?Q?0yLWajt0DJX2x+jSuYRjJVNPcTf1iXVr5cBsBhvAF0YqfurqjDqmcEpeWYXq?=
 =?us-ascii?Q?z/uImE7/FTkCoNiLppKc4pxyg8aR7TN5Vk+/yL4WI/87HYXAKScTHjS1ZlAc?=
 =?us-ascii?Q?xO3696RuRcsrCdXn2RShY3i0shUU3Kw49XGEdH3Dw5tXd30c7CR8bk/pJnii?=
 =?us-ascii?Q?L0K6EVHiFeZ1WqMgdSIkKrsDergaiAf+ji79hKnHs36vOz+ZhpS7mJJKOatS?=
 =?us-ascii?Q?IPxJaD1hCyfb069vVHEOUlXcC/cJ6AtXF1Mu/YDVcIFHV3M86O7xaR99fphd?=
 =?us-ascii?Q?S15UhIChDF/JMR9NXzuRgobbyh19RrNALUsaxYtD3VIwp9pnKsL8RP0zbm2B?=
 =?us-ascii?Q?Wnft1itl3KGWfDmqTNxfWxhED4AvrEszfaD/C+JCxBFj0EQC+6rtpuCjhSVL?=
 =?us-ascii?Q?eUhcUj3tcl9Wc5HHxCSeo49IN7TXACjHsUZeaufxsbOOZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oxUyp2/DPhi5cbzNBlRIEwNsPnQ2Iz1l5ZsVlzaXCgpuuaktll+JRT/yLRfD?=
 =?us-ascii?Q?v+dvtPsTE0aCikAE1zT8LH4rBMclpdZNUx2K5S8cy0JfYJzCFS8Hef3klT6l?=
 =?us-ascii?Q?LXZvXfbg86kVCo1+HMdQp8sgUIajOTJktqLKfOEEnzM140EM8jSk4qryv1bG?=
 =?us-ascii?Q?FQOnw5B4cwjI/NGwfPw/Zraf48zKt8rKlqqzqvHmsFAqDCvarFYz8MOXV/Va?=
 =?us-ascii?Q?Eu3Dl/CQSfwKbjdq6SCFridjvEo02Geu9Xs0BYLFhIN2W0upV42/sRJtWLUk?=
 =?us-ascii?Q?DhZ3KADs47W4Ch8UtjVl/IDgHbXDJIORV7Xvz6TdSdYdARwLd9HvGZKAnTbK?=
 =?us-ascii?Q?ppacKQcKcBgmqdhkKG1pNUmXCzlrZCmcl9xUCOb/cGCP8g12k8wEuLRRswnJ?=
 =?us-ascii?Q?hOgcI0l3zNVj51DFPRclAZrP47d9eYdJ/T5A2H3kUPXh2SudaLJm8kFn636C?=
 =?us-ascii?Q?pP/vU8HxMEHhBpCT5X2iaVwJaPITbU6W6NO3A0yvX4w2Z4PJqb2UKq40luGE?=
 =?us-ascii?Q?GuaSBiMIKkfxxUdQ8Bx7pP0vsXdjggwjAOIQrCwpCN8pMZ30INibOb+G2nCU?=
 =?us-ascii?Q?yxVmjLRm7Y1VsLzdI3ejVogbbCWlxp6FLNydxHKsXwH5QH4lKaGEhJwPhOUt?=
 =?us-ascii?Q?LZPjHIGygRavTfHHlfo92PuuhdIYDLOb+ny2D/zpzDjviht1blL20bus9zvO?=
 =?us-ascii?Q?FOmhfpG3ZXB1DpPQ9Mj+R/ty9QCad+YnOELQ6obNAeCeL7UwOZFmtjtl0aKz?=
 =?us-ascii?Q?e5XEDH6GxGHJqhbkhZx5UEVue9xae0boyLNrQr8vD5aO0G99SUu2mMACwWFo?=
 =?us-ascii?Q?WwQ4mhQh7dLvNJiIpWk74xkrxh9y+AUB1LSnoDcSPFOjTpTC13VMvBLRb1VI?=
 =?us-ascii?Q?oR2G4jUUVKGDV8V7WokQIxhzmO0TLag4lQWOOzT9qHTNm4G04IdvlXy23FX3?=
 =?us-ascii?Q?24Rj4VcRwl0K3eLfRv0CShWFKgE02Az6FBmcf2cmI2Jx5qnc7BHw68dTPTKP?=
 =?us-ascii?Q?FXa8SNKDTk7xsWg03TljxXRc3Qto93sSl1dk9eb2zDCWJogCeBNmvV9Y3HnP?=
 =?us-ascii?Q?D18xPyAj0xugHrfxvcleluoBHRMiOga/96ECf3DVO46LyVGoZRCGTbk2GT7g?=
 =?us-ascii?Q?6ni76RkulswUew3MEv5FMT2wOcrf4rWO1EiF7SuJnUPwVMOcsJGpQSOptpQX?=
 =?us-ascii?Q?hYw2u+Xe9Due/YD4VEDi/q0ETB7qYN1Ad+9QhP7Gbi4HUkzV9m+gytyGTG4M?=
 =?us-ascii?Q?x2V+MxTHJDZVpkaI+F/+pkKA1yeq55bissx7D4ZW0pXbZuk2Adz6CVWCIxgF?=
 =?us-ascii?Q?nQO3tDr9rdHs8mUJRUv9tCENce2vwaUNU81Em8YkPrqlykW+dRvIYNSNd3CZ?=
 =?us-ascii?Q?1DpPhHRJ6pPFE1/neCJIGZsKkhqr0xQ16suKYMPpumYgsfWuKTiH/NMORdhv?=
 =?us-ascii?Q?U/hAwEYQRjdQWfnNgsw1UPJtMYgmi2/rLrhXIBVQ/ICCrbdgn2k/JVeYV9I5?=
 =?us-ascii?Q?IHz06gxQYdSM+YKYkYZoUw0Z0T+nplUxwtwp79DxA6sMvvDzUN5/yqPliwbb?=
 =?us-ascii?Q?x+8ZlxqKTuUG/xSqoXHwZa9ToPFqiyoycs0zsR5fWMYZps/7tiRgo3N8w7fB?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V/ezirBnkL+3sM5BgyiUsk9e4YejRwQLocRX/N6sMDdIU69TNhrtyL9P4yONk4ZtTMgpGnt9aSEG2vzotZwjm5vJe5PmSHUOBlMulyoPpujiyzTrYnMFxcXqkZSFuwM8XZhUb5yHFdoI/kND+Ql9z6L0OiMWz6UGmdWt/bSnea+Qdha1opOV0dT5D3nelnjRx0X+e+xQ5KZmA0FmZ5H4YqY/eUPzdQ8yjOZATk1M4DJVc24t9N4T0+8JRsc1gyNU6wpOhv3Vf13zkKE0nPkFzl+xzqjvq7hQL/FmTslDbrE4pt8hc+pCQKY+pAg7L2U2KqCwTPOKb3qlw4gtN1RsXZ9Lxoa2CPOiPhIWBTctRmAVxEkTKbEZ1dDNwOOc8bBDvJjt8OYzS5jefQNJMQUFN9kkDkYLOw+8TQYHmWe17H8W9QRT0geRdqBwAoJ4jMDAY/4zsHAnsYKtLkSAqvMb/ohKwI+dmAhU1iBrao/g58HQPibjCLxBbc3xD+ZNSlQRJTurTexK4H3i+5tFIN1JkwluA8DRPr+iwRRRez3EovquyZkOi/hPoGZGJgJoYPURhjIXhTKV87I+1l894s6nuuZThKbo1PuHLqb/N1Nw5HQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a94a4cd-3839-48ea-eb1a-08dcdc3c7c84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 01:59:12.6456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4gWeppAHrBIbHIdV1RFJ5SRA1Zu4CB02eW57Zg0xN7+PE+88FnvEm1HnRwlWH8Eo2M1i/pDrt2dQ3+N9guhge3s62OeI7TBLa1Chy1BO4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4799
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_19,2024-09-23_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=889
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409240011
X-Proofpoint-ORIG-GUID: o1OUHJxX3StnwDAf1w61oTPAEkEBmw0B
X-Proofpoint-GUID: o1OUHJxX3StnwDAf1w61oTPAEkEBmw0B


Hi Anuj!

> When the drive is formatted with type1 integrity and dix is supported,
> the block layer would generate/verify the guard and reftag. For scsi,
> apptag would also need to be generated/verified as reftag-check can't
> be specified alone. But I am not not able to find (in SCSI code) where
> exactly: 1. this apptag is being generated
> 2. and getting added to the PI buffer and scsi command.

The block layer on its own doesn't have a way to fill out the app tag in
any meaningful way. But if the PI comes from userland, the application
can set the app tag to whatever it pleases.

Originally we had code in Linux allowing filesystems to attach
additional metadata to bios which would then be stored in the app tag
space. This was intended for backpointers but never really took off.
However, if we move the burden of PI generation to filesystems as
Christoph suggested, then we can revisit using the app tag space.

No matter what, though, for target we need to be able to store whichever
app tag the initiator sends.

-- 
Martin K. Petersen	Oracle Linux Engineering
