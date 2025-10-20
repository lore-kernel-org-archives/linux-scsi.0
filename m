Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EFF2FB097;
	Mon, 20 Oct 2025 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956720; cv=fail; b=HCN+Ho7YJTcjsUkx16EblsRL3NDQsnhZffxMFx9mapBydiEvgApGXWxl0170pnDiK9fz1V2J6Ini9NJwftUop7B8uJLycscyJZtympaEf+mlv6cj5JiPVCBRj78rpTQkJrgw7jgWNAspI34XnSYTC5n4SSqCwKgg3OpuLmcyjho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956720; c=relaxed/simple;
	bh=gu2w4VpLK2Htn70NrEJCJRGihUTSbzV+36j1i/k6mZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X9LKAyyPwu2DOzpXq+SMWLy7p3EMXUacBUsNayCmI/yUZT1DHGLx+HGmT3TsULSetyZ32UfuaMFeoKRX7DWwWnhxGmlECfyra4UlSLNx/2iEp0i50NKMMzBbysgFFgoEgom+6hCPMgiHL9/Irgu4QWxPOcDrSNba8x92JwCJTzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F4SSSc9Z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JTtwaBSO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F4SSSc9Z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JTtwaBSO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SATA028240;
	Mon, 20 Oct 2025 10:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kAqJyXMD7gD6bDWstv8uGANy1dMalPHHMVPD1uMlzUs=; b=
	F4SSSc9ZFdfKYzSgwNh/gzktrXUMb1EEGbSFN9ie+1fiXktE41ba+nK0VY7jhgCF
	TSxxdh9lhgdDm8VY9KHxiI5IlO10qX6UD+sooLc3hOY3tfX1se5gbFCCYEoVF6eL
	TFe3xOwfWFs7+6ybjDAkJCHxGfF+zRV6xTyOhbQAMIorpH17nC5uzdJBwyi/AWe8
	AAJqsuFFQZxOdhxmS5awHSwQ+eAXVe67N4DtZc2wG/F/XlAz6mpOql4OpBOSuQp1
	+O34TRwyhmH17y5ztnXwSHPWm3uqkNYa+Ex5HgNT1U6pRvPHiK9wVI+Ropvdf7Ex
	TwlPNFcnC4lGPzZywpSIQA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypt0k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59K9xoAJ032238;
	Mon, 20 Oct 2025 10:38:36 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011024.outbound.protection.outlook.com [40.93.194.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbj7ke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Av1GSFc4Pwxfkfv8LGPK9U323VPFYwfjBXGYM5o8vH+eXEztsPSO1GuN3D3u0bAxx4Nlpp7EXrDNE0j8rWee6QyOTzx887XNJ3/3APMO2NQksozEvWv7YybHkprso4cSjq3LkT7cgPWUOTX631s1qarYLuHwkwZzB+XYmJQifHQVal7/L/dCzwlOJAiO/HHYMiMXZBcPXmSS2GhB5zjQg+Q2UKdWXb/oWMEmEW2GfAfPHZjOD/0X1hI9LpVcbFJVlCpejRkGPSWS/AGQB6KEP0/gU2s4PsWte89vkAzzo92iCsfyG+wB+k2KideogLkC97nSySopQ5dHyUtfqU8t3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAqJyXMD7gD6bDWstv8uGANy1dMalPHHMVPD1uMlzUs=;
 b=Mx6F45p5MhQfUMHJ9Xqe052PCDGfGfNcVyHAJBzQyj8btdje4gu1OLE4i01e9XY1tvQyA9OaTMOktgHGPI7ZJGqgadXykSFtatqRgeqiYf+n5D4lJx4RKhb/FjzIFhs1MiLBHHd1D0y5SPTl8ShLTptNKepJLMLfhgdFz9mD2C23eMeQGKskDrCy5cDff4nng4OPXjqKUcX0inUlSIbphkuInnQUcTrnlmacVQqM1BTPFAwmAzCfWOEJ2HAgxCm1tVHWFAAk39iMx96dkD99V+5jh7dXjEdwid/pGUNExltt4PVqSiPzmQi8D6djnbV/VvQb4TekapfpoxQpc3Xpxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAqJyXMD7gD6bDWstv8uGANy1dMalPHHMVPD1uMlzUs=;
 b=JTtwaBSOK0ZipFeYZMC/9uLL3mfXVTSbPYPIJPxNvf6ptnOuMwP+B7MGcE3++a15//WE1GPWpJTPeI2/XtsY4EUsRGVbErsfqnY+MceTy8wEO20Tzr2JcP+AXPFDP1mkgBQxAmfoI+nsoqPENMWenZQtV4zVohjM8ZuZEqVZyRU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:33 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 4/7] scsi: target: Add WRITE_ATOMIC_16 handler
Date: Mon, 20 Oct 2025 10:38:17 +0000
Message-ID: <20251020103820.2917593-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013310.namprd07.prod.outlook.com
 (2603:10b6:518:1::b) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 9530f256-1fd7-4105-e872-08de0fc4d156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Di034toKmd1nHFk5yJTuqzp1B1XRIZ87qOer6TK9W75ebXdeqxZewytzTnc3?=
 =?us-ascii?Q?SNeFWGVAcUldP2Qrf5P3qjK339fdmLBPBeHThWz6mW/inByV2aPAD/QQs3nu?=
 =?us-ascii?Q?JyMVnu2PaNvSh5/O82XGPJHnGhd+0Tvw9ZrwavjAA5E8ZbDlAU4pqn4S8uu6?=
 =?us-ascii?Q?DcATzecG6FJLcPddE3DJUsLp9W1xG3iAw985vGiuWWyK8+uiRI7UOXo10gdG?=
 =?us-ascii?Q?x1igeCmdYwyvHxBpClGJs5X8hywyLzMHTEBEy31wCf+A+UAk+8BLNcfZvn6A?=
 =?us-ascii?Q?UsyFHcxCNPvZZ9D7/Rk3At37iR5y+L+mbbMfdwQCv5hMCUS+768hikkXfNQX?=
 =?us-ascii?Q?BQHVYhZzd92r0ln6MZgJkKhkUTntrpOgzpo0JOpH5iRjbaViza6eMII2r2yU?=
 =?us-ascii?Q?k+nCBEVAJ6OSdbXE7/m4Tcc4PMwT72QH7Nzvs8+tHNZkucjzPC064B3+WAAB?=
 =?us-ascii?Q?OFMM6vQRM8Yy1Oz0yiRBcGobGyRh6j7AmlMGC0TGjt7MlK/YHNwXoiMYCjS7?=
 =?us-ascii?Q?30Kjyw9AbrooSSCkxBDWW3/nwGkeDVr7FGuvdGDsi8a0W2Ts18Q+kuLnZ10T?=
 =?us-ascii?Q?uVRuoMOOpNlL3rU07lDQqzosOCLYx2L/FDIZB+t7U6lrESmJXiUswA4lKTau?=
 =?us-ascii?Q?+L2WnUE85ycY2QUxrM3Au2MNpepC2V3KxHOpDwtdc9p+GO64eBYwKgNttBjL?=
 =?us-ascii?Q?/CQhNRr9LFf/AszKv10o5HADsq5XqkauJUT0jiBp5C30bnugX5CnIRIXpGRv?=
 =?us-ascii?Q?0GiS44gKCTSYNeujToVmHqymYToKyUTmPSUHnrjPTfKzeyyrVOaqM717EgKR?=
 =?us-ascii?Q?Po2nnBGRdA1mTx74UZzrKDeKZW2ez6FzKVEZar138JQJaeU44rX13fYJXmvu?=
 =?us-ascii?Q?AoQ5+DHi2h/wpYeCZBo8o9DwQkYzRrM935Z9PXjOhW2oRg4tp8iH93RMcK4O?=
 =?us-ascii?Q?duWhDsuFQcNa8a8fEIEmUglx7yRb9D8wvs/TWTnJAWYRis8EEihKmqp40FJh?=
 =?us-ascii?Q?hOAOujQy6ekjS6SUFb/WIuo94JsybfDFCs9iuKs1CWKstWcTyMUOtuWOpPcV?=
 =?us-ascii?Q?ntbLoMvKtopho+hM7pB7z+vwVRaENDVQf+21XKdA63CSSzpTkcSoCliujeTv?=
 =?us-ascii?Q?6IoEmbFMC75PPy2GALq0I6GNsX8zN8uSIycijyh3ijEoJC2HcgPcuqqCO98U?=
 =?us-ascii?Q?I4fOFP9FZnu3OBiA/QtSlnVzsKXB5INbWpv1/mJVBGW6rB/BRdColz/0zx3Q?=
 =?us-ascii?Q?4TzG1MOps40LSxbYv9sJQ6eium+AQNVYdMis+lA5We3BeAOH0SoFKGOZh+Dm?=
 =?us-ascii?Q?h1Z7i9ctECb0Wn+620IraL+NN5UG5BBmEd41GQF0Cnamtqt+nDqEx2Bizctp?=
 =?us-ascii?Q?CNclIqF+y3pvJiG+VvCx2qam53G/6mcAnW3wTsO5MPZC65ZRWAp9q+nmxauI?=
 =?us-ascii?Q?B2X2RiLAWVwckBune7NiL2M3EzgEYWUS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HLSgAJXxvS+YOLYcC7ECi9frH3D/t1awIP0S5YZJmIIemDD/JGuV/UiGcn+T?=
 =?us-ascii?Q?x4kcsx8DtdtJ/aNvkeSxg12vYx3YURH6IwGLkGiM67KqWiEnUvwoiAJHuNcc?=
 =?us-ascii?Q?TAm/i/70GqLMKN62LUYNfrZRFghI7uU2FYrtrZ5+gtxqeG3gKsiZjbxYS3l4?=
 =?us-ascii?Q?lkSahdy1wkPrbwbfTv1oE507LLjyZEY8ogHOMnS4MJhxsX8jYInQxpsO7IBt?=
 =?us-ascii?Q?TH1BWoZMLN3qGnrekLsZC3q23zYmMi2lowMLxPUfnKzLpN/7iATQCXleikdh?=
 =?us-ascii?Q?01XI0+v7GnjLoWi/nNBwDGxlQVCBGOOct9y38tlSeWKQ2EDxCE4PEIdlKLKo?=
 =?us-ascii?Q?7nF4kPJ0+6qBFq6+qkOfSKoldRQXQuEoIi4Wgyz7JQZ30QtYlJmeiISp6Y/3?=
 =?us-ascii?Q?npCTTOwAuvFE+VyM1MP552RK7/dfg6ZKwNiugbm4v5MnTe9rMc+Lp+Y4ZwNr?=
 =?us-ascii?Q?BaXy1m8FoLQWXxNbbpkdGOxy7xztjv0kY32fupDQUcSYdjPQClaFcfgekxXj?=
 =?us-ascii?Q?amSoeMNTpIcbYPjqC89zYI8SzM3RJsM3WKzMkiUlB3jWOAwR54xQicowM6nT?=
 =?us-ascii?Q?MsrPh1AzeKzdPsAboLFztfEHUIZnfxeAqvMfo6HGnLNsqR774Nfjik9t9OxU?=
 =?us-ascii?Q?pvXULh37V2Qm47qIzxEpcGWC/oiWgR/JZuemBruskBq8zhVOg3gH6ruBNLML?=
 =?us-ascii?Q?EMealjrCF4e1SyGh8aNB0m6BZSS5MHjq5asNJONL+PGXAjXIBr0JHl7BTByB?=
 =?us-ascii?Q?T/NaAg19jqcR+DzZ3FGdpfSWur16uJcQkvIFKWRmQEnQcQ4DLkDp7ffKe97g?=
 =?us-ascii?Q?0Ct+GWBCoehw3r93aCHKMSITUEjbLFhFEBGvwXo713rQk0eb5P7ji2mY7kHu?=
 =?us-ascii?Q?MUTjy/7E4ZZZTfRMxOjv7xwGhx7yYHy0k08TNHZ3Ramf9cK84ohfMCQeBbE3?=
 =?us-ascii?Q?lyoNN6t0ayghieLIazqqAwTgnM42UjHGDDjog6HcajWcStm062199faVK6Zy?=
 =?us-ascii?Q?rY1ZqhilJro+UymizPKuJYKy8+SVKfTswGYMsLhyF5pdiGXX1AI7yuR593Qc?=
 =?us-ascii?Q?VnQjVaHwXcxlqwI34MiBS4vjpZaBJPmFdkhcG9oIDwYGLzAUqFyi8TNcTF4/?=
 =?us-ascii?Q?GujFAJJCFVCGxP3XETLk3+Lsu3mLCUgayO2bde9ncFbB4DDaMiP+PnIuhK5h?=
 =?us-ascii?Q?dHZFyau3fXLRYa50n9QTa5X3wE7FJkvUh8k+RP8as1lJLkCl4ZPthK+uroSt?=
 =?us-ascii?Q?AW/IEXxqAi98UeiL7AD8sfgWR6db1d7EeqvAIhfwr6kbD1L5aoRWa8c0mm3/?=
 =?us-ascii?Q?NlYoUSFrVbZl9IWOWdkYxO4YiIvBddvkTqTI+asRlmMOglxjJ9VkiaVPWOTE?=
 =?us-ascii?Q?nslMTHrv0wEqp9ByWXiP+FnGuEhzCtsF+Y7TYgVM7fk/Bd7PPb23IMnnXgEr?=
 =?us-ascii?Q?wpBe7rFyIofSyufpJSk/6pzsRNRI0XmPQg53sKUMA9iwFgs37OPVYEQ/t+hX?=
 =?us-ascii?Q?gPEt+iNga/0OsFzOIdy3JRZXRE60XehAXvQIrW8DAWwB5pJ3YI7kNSxq9bpS?=
 =?us-ascii?Q?m43gmk0E1awZQ937q0ZYzbUIjfrqpriNrx+nkKK/RD/YcPWCMREl0Z7KgNXR?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QS1zoGlWMNQvr0yQQMJxFyhEAtNZPNGHv/+2AVr60sicQTVak4t0DDTD9NDwdcqeBjpV/eYKLg2brc91hjbELUXvQejlnAXZGmfYji06SxJuYc7sYh2FU25UCmBOaPR4OQpW81Zuhjc34cgmnNSohMGXBfm80ymfmwb9zZR7l2M/I6Dv3gxcXp9+4eZIF/Os4PQ6uU9xCxlV/9RpjhmGE2kyd/CMWJ6z5kX2QyoSXj7Nv8rAi/+Zkeb9xy3IlyggTpc1ouM7B4StR54IVqbG5u0050IgAbAGTZXbUJ312cQPHK4LLWBY0j1cD6DIGpCnAebj90Z1ekhLjbJzNzWUERr7QyTOzs6lF9yhA08tFbpUYcB/Sz+Sn+6yxDTQscuGoImwlCKmN9L9pBFQlbf8W6jn9q9OGpzkWCnzD5/GiUgbxlmwBEgzIEUeTcK0Gn9d2yd1pDNJwzVu5ynOOnSnhAPWxjqrnweHDM90Z9HM+CV5NvQnd39xOfGXO1TbjmK1KfUQjW+q7hRQa2G/tnDC8BFUCS3QN9EH4ioflEot4dGQsvrEjHfXoOebq6K8PMDGG8vTh//IaIVSo1BMrCqigDmHsaHvIIitIg64ZNXcbiA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9530f256-1fd7-4105-e872-08de0fc4d156
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:33.5209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/vpyvHp/pECa4Y7Nw1yK+H2Cu4Q4zQP5MAQupcaBkokbWgbTs04qvhTV9kFUifqbN+G5kV0JLssFZ6loe96kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX0/ki4GZCs2rw
 EPt8VZjnC+D4eiYl/QgAg95+LI8y5E3VFN59E31z2ybODK+1Pi/NYnRoWMSt4VEu08vGPAinCqx
 1X/pcP0Pjz2yMF6e7H4SkD7nzH6pb3AMcbOnrPL28WrDQtANaknvetb1hrFuAw6G+1teIIZWhDH
 WuUh/tTFDxEFtUcei7LRWCizK47ZjhGc7bbWHWWJ9cxG3U5WYfVN2YYhFQQK5PauPLGe6L41Cu+
 j667hYNQtEU73Pki/l9LCoSvcGBUjhvM8MA0edXFA1h54BjdXc92f726uagFREoUmHku3CzNCLp
 1LsUU91ccA8UIAc1wFlXAozynVW4TSAl9EiL6xZdKRt8y3GW/9kCOLtJ/+CmiXiKZkNNELHsduH
 ebAHqvrV0RhtvvA21nqUa+/hbf7aL+MwrjzKFtWJ94rw58dC4Lg=
X-Proofpoint-GUID: rthaquFJg8QNyHwg3_jUs7Ldzi9sTjRc
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f6112d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=tdePMMsOE-AiMe2hm44A:9 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: rthaquFJg8QNyHwg3_jUs7Ldzi9sTjRc

From: Mike Christie <michael.christie@oracle.com>

This adds the core LIO code to process the WRITE_ATOMIC_16 command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: fix return code from sbc_check_atomic, reformat
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_sbc.c  | 51 +++++++++++++++++++++++++++++++
 include/target/target_core_base.h |  1 +
 2 files changed, 52 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index fe8beb7dbab12..abe91dc8722e4 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -764,6 +764,49 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	return 0;
 }
 
+static sense_reason_t
+sbc_check_atomic(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
+{
+	struct se_dev_attrib *attrib = &dev->dev_attrib;
+	u16 boundary, transfer_len;
+	u64 lba;
+
+	lba = transport_lba_64(cdb);
+	boundary = get_unaligned_be16(&cdb[10]);
+	transfer_len = get_unaligned_be16(&cdb[12]);
+
+	if (!attrib->atomic_max_len)
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+
+	if (boundary) {
+		if (transfer_len > attrib->atomic_max_with_boundary)
+			return TCM_INVALID_CDB_FIELD;
+
+		if (boundary > attrib->atomic_max_boundary)
+			return TCM_INVALID_CDB_FIELD;
+	} else {
+		if (transfer_len > attrib->atomic_max_len)
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (attrib->atomic_granularity) {
+		if (transfer_len % attrib->atomic_granularity)
+			return TCM_INVALID_CDB_FIELD;
+
+		if (boundary && boundary % attrib->atomic_granularity)
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (dev->dev_attrib.atomic_alignment) {
+		u64 _lba = lba;
+
+		if (do_div(_lba, dev->dev_attrib.atomic_alignment))
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	return 0;
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 {
@@ -861,6 +904,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		break;
 	case WRITE_16:
 	case WRITE_VERIFY_16:
+	case WRITE_ATOMIC_16:
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 
@@ -872,6 +916,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			return ret;
 
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
+		if (cdb[0] == WRITE_ATOMIC_16) {
+			cmd->se_cmd_flags |= SCF_ATOMIC;
+
+			ret = sbc_check_atomic(dev, cmd, cdb);
+			if (ret)
+				return ret;
+		}
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case VARIABLE_LENGTH_CMD:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 70ece58d30780..56333b5726c8b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -158,6 +158,7 @@ enum se_cmd_flags_table {
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
 	SCF_TASK_ORDERED_SYNC			= (1 << 19),
+	SCF_ATOMIC				= (1 << 20),
 };
 
 /*
-- 
2.43.5

