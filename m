Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DQsfOHhL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IsQPnhlQ"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F61723
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 16:14:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AONsY8N032168;
	Sat, 25 Nov 2023 00:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=ryK+IsoKh0ehEvy3/7Qw2HNP5/3s4Vdnt/5bnc6IdVU=;
 b=DQsfOHhLYlFxgGdvI1f0MZwFlwLZgByBC7X8EcWxkju24zfLfp30zUlBsSfEPuiIi6Lp
 DlECnfbGs0NfG28QMe+EtIBzw2/f7fuC/m2AxIbhAvZy2nAHJU613akxS2QsZ+GbntRW
 mfnUYJx9h/8WDuioEYWYgUwm0maL3iOpJxwHLedTOGaZHqyLgRWGe3OGx+kf5HRC+5wJ
 iubjuqf8N18tUskop1b5y1+pCN0oSoX7evH6LyplHDwyXV98BjY2gXkfdgpqjs/ETsuD
 JRIDFNDQqmNZPRNALhnx0b+qbmOTcu97IBdrnU+yo+A8cDgdON71p8mZhh1bI+xjibz/ hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uen5bkuj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:14:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AON12xd036082;
	Sat, 25 Nov 2023 00:14:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekqc6nv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:14:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5Mj5faeQk4Nx0tiaZCfi01zHhkgBe3QmfdKGrrxkJfXKoF3wEU6Wzn4xKhy/JPDxtZq8Z0R9ax6IHcglf8DEi/gfD2q8VeG3yT8FhJ3CedOF1w5ETOW82EKVpGZBEdXwgb0iApu/ItlMHMT7dOzTXN7xWKKnhB8vlDj2MyKSdPJC4tjsmXH2x2Vw7DH2Zi048L4vzzTRxZbaMWd4OX7aRj8L+QXWMmgFHCxZ5v4e+8GF6GdduO7RCAkZHT1o8MmRju2G6Rq34aOgdrv1wn0eCd/T608r40GUP3a9mw/OzqSS4ApZ+9HBRhLHzOyPGUvAL67E+C448zaXTuAlbSUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryK+IsoKh0ehEvy3/7Qw2HNP5/3s4Vdnt/5bnc6IdVU=;
 b=Xtb1jQtz0dGYR+IP9nPh8ukLut7c6MRlb/MeSwPImk8Uq9pm74gSrph9KWJcwwrih2JPhoNZ3HHXnsJHaTs1BTF62Tunqnf0IIAHOyF/kTNJ8umCRHIN0Oi4N8A+WFIVsMAhZM1L3Lxo0lu9xZ2K/3RrQV68+n8vzlPoIvWHbSoiCC5rDXY4tulsa59/AXWYry7f5dhFyh3XxUSIrcib4/mypvsnUxgVKcUhqGZQcBxRCCD9yPZFrRU48doWvSAv+uW8uGkyU2/HjKQw5MJLN9xarRe3y+wDF/tDWg0sIbgk5EAnwhOOki1GNG81IxeqlUeRIFT6RjpYVNT8NVwF+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryK+IsoKh0ehEvy3/7Qw2HNP5/3s4Vdnt/5bnc6IdVU=;
 b=IsQPnhlQkt6hAyAAhLl6FD9c08AyQfijiD+7X7OIF1XqdE/t4y3W4GzGUlmdSDte8L0xnC6wbSfLBiPrSJJ/JpT9y+nVvHNAgKNwYAzMCXB+oZOFAKbrgSL99JV0I1Vl/+JLXFfb4CjsBK4ZOmcAxi64jqgO+yw7lpsaFFLzlCM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6854.namprd10.prod.outlook.com (2603:10b6:208:425::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Sat, 25 Nov
 2023 00:14:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.7025.021; Sat, 25 Nov 2023
 00:14:29 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Anil
 Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru
 <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley"
 <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: bfa: Use the proper data type for BLIST flags
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1leamvgdl.fsf@ca-mkp.ca.oracle.com>
References: <20231115193338.2261972-1-bvanassche@acm.org>
Date: Fri, 24 Nov 2023 19:14:27 -0500
In-Reply-To: <20231115193338.2261972-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 15 Nov 2023 11:33:38 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ae21650-91ca-4db6-7f05-08dbed4b7ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GvQm47b8F6dL5K8hc9O15M9uq0QD+OYy4r/amKiYwBo1ZEKyNfHLsol+9NMpGoY4HtEbv/A3IGTiM6Z3Vl8JerCXFVT6KgKIIEr/EZyl2vk/6u23lloEJcRzx9C0hmJ70WQooAmlDh8X0SMzHvN18b5r52oubsgi1jRvsPDXvUCr4NVW2iaFCnRxBSYyEKnk5YzKV3ERlGzkm4/crhn24okzq/51RAbmeZov5CEtDB4gN/akNS0sPiPEEekKwektVBI18XttnqJRg7nv68YSc1b/XkMMFibuXQOUWZRiPqTV09WQL76x7NzqYEJITwGqqW86leQILas9Sc1T/NbLF58kBrpvSWkyeVsEufIrWW0JxW5Sf33Zh9yCbHuLlPQPUnsZ6ii3/VAcrA9Zkquhd2SVKubs5O3tesRL9NadhGnsZHGrVx7lQpMc5Fs0DUDLdgOjkuoc77Prfg0cmsxV4bgQu56lqEdS9JjQHINEYt5v0Z1ke4oqzCdoZxDndO7j54M8NYJISeYziOjG94f770sB7RbRl0+ZhlKmLfQyj85lGkVYt6IxjUFy5UH1bhbvMwAiPPfw82Y+5nKuGZ4KT7V0I2rv/srt2ACCS2+Ym127CwyKWZF1PbjH5v5uZGXB
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(39860400002)(366004)(346002)(230273577357003)(230173577357003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(5660300002)(2906002)(41300700001)(8936002)(8676002)(4326008)(66556008)(316002)(6916009)(54906003)(86362001)(66476007)(26005)(6486002)(6512007)(66946007)(478600001)(36916002)(38100700002)(6506007)(83380400001)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YLRhO63pdAol/i9IJGDwEIxM4WSNnRmj1xxBh8KBTJwf5yUwVsieNI7jELpn?=
 =?us-ascii?Q?4wdd4UPJT2ZkZCzK5LLDDSbOjHGmgKYcARDpSWql5J5rnMabq9tKEDJ1ZhjN?=
 =?us-ascii?Q?DW/SLpWJ7IcGh/Wltftw/NPYAPvG0j12nBouv93GgNuENfoDWjlUpb1mElhG?=
 =?us-ascii?Q?RNSKy3G5JhPl3HIO2CpRfh5l92yuxvevsEXrSX6T61wPNVWzUExs/aG7dsyQ?=
 =?us-ascii?Q?ra4sJN0omu1bxr6AIcT8yFoYOg8IPk3MztmQdV6lQTkfKdO0bObvG2DJ7wQU?=
 =?us-ascii?Q?dASlXBH+ynSwQTbwmCvW7+0fpfaB6hQku/U9qirsAi9WYj7K72d7dYISBh50?=
 =?us-ascii?Q?FvUUJWeMb7AisXmnCGt/iasXFmirar7KHKPhgrLQvXWWIqOvepqp4KLy9J82?=
 =?us-ascii?Q?m4npT3TnKWo0dQ0c60SX50e+cTlP/yprzTij2AfgR78IB+pY5NBGynmrDORj?=
 =?us-ascii?Q?3gZhwD4Yq6y/8bgCDB4b1TdzOd/PMuFuC3juVB5BcDgQMIGHP4l2i7d6mb2x?=
 =?us-ascii?Q?Hy5nWQeeIcZYmp1XCtpswln7X9XBpOuQOh9MVXGOzocsGBo+CnHLGUwoJsEh?=
 =?us-ascii?Q?TKmtAKTKsFLjJInxsYJ2IL02sQAvtA2z3VNNEgsWyGQcLDPFQYMz1SSHVE90?=
 =?us-ascii?Q?KAn52jvOmyQu9Wa3N5E9ON9133lrbKWqU7DfGWhIufKuwYu9oBykIp35QruF?=
 =?us-ascii?Q?8jfHxFVM0+FY+CDd1X+wgQvMNtFvNESTZmjSDhcK7u57eNuMw5njxtfwev4S?=
 =?us-ascii?Q?KO20tLSMDbvvEJ99Z9R6Z6+degDOo8KxrDMR3METKJB9XuE6c0soZsCFMhNS?=
 =?us-ascii?Q?qvONMb2azlKnXtSbhpRNw7zL1tFUO3pse3al4x0EflEzKtecdvf2vn92inzs?=
 =?us-ascii?Q?9PFBznITgfj/53GySCkM2rQYy4FGbv73s9pgVYzI6VcSzIlL+9TU/M2xIg7E?=
 =?us-ascii?Q?wEJDPXlrBUD5Ig119u63arx+U6KRZxvUPKuHckgVPf+aOhRR28ARHA+R17LT?=
 =?us-ascii?Q?1rZZEuG7Y7V7KfMiAmDmP10KSn5y7Pan7dFTHOLYC6+4NB3X/K8nUjNHzui4?=
 =?us-ascii?Q?/13iF2WFzB6xy8925vFj6xvupJP+CVH1SNmtvbsa28JWMm91Nuh9opVheDQT?=
 =?us-ascii?Q?ZUj8dP2IUJahhtCiPxUrmk9wuXto3PSF2IiZuLRYVm0fG+TECQOzt82Nx78X?=
 =?us-ascii?Q?IpZH80b4kIyAqonh5D/1xvAuMBoXzBMA+BYswu5OsYabcxbXIZvjym1fahHY?=
 =?us-ascii?Q?ehICzBb1hQjf/sV+D5ul3ASkjImq5h+B0WOf3rk5hZHAuSdVU5LB+TTgEqYO?=
 =?us-ascii?Q?3RgRNbXn6qWZaSMbdmMLLC0hyJfWY0GpUcy96S7v8Pj9OLY4q/GE1Wc5UOzK?=
 =?us-ascii?Q?VldiwI/uPwY9+OCBDs+LRVq3wifRWODo/S8hWpkH2eT3pBpfZDEbKldvDx3n?=
 =?us-ascii?Q?uto1SJkfpF00AyU+sh37/pgRDgeB5n2VnNpV06boNJ4KRh/EUv9nNx1n2aTC?=
 =?us-ascii?Q?T8lzMclYu0rJpN4Vv9/JrWH8TKdD680U1q1ElwoGbITQjnXZexwoTMqtkPUB?=
 =?us-ascii?Q?/ZUsas1c+oMfWZK4wnb0LVEKTyH1o+vseVL0SLRPJxBYAiaPV1PDq8NFOcsB?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UyO6Ztpezo4E2j7ATuMXZDJhZxKQ/WISTz57TPjGVkGvSJrlizS/8C8pIYj3VYbaraTB+M8gjFA/fet66zolJKT9xkQW7uhp0ltCB8RW/8+1yOd2nIOMs8yC8HgnjGE+VX0THdR6Mk2BFNudiUJiNownBOIY/gw8uE7S6CkD39Z9xX6Gr/AGK+we3rKMwMNxkXDv/avA862LoPDpUy8DAM/m/bDgX52ScnTHzN/lEHXp62PNPvTATwSo1qYPNZ4PojdPxsMaelNXrDNHyVfG5HpWnv54kHBX+TPkcoPdB+re4fnjXf6Jh1FA8vxySjp1ylGTgwVLhnlC3ok9dWFW+b5BI34aur1VTimCzQ6sACI5+u84xs4CniVNA+PW5/rh3lYqd3mqku5j5//a+SVCPMN1p1D0MLi4fbZjP+9bWJ/1BKiPp9NAnco2w2dG2m9p4HqQUXC5uwozPbDmxhWU+qF3W4LJPoSh+j1gf3IWJvNuTp1+0cR4rftosheWH98JoZJeBTmk0wH/CCjZIZjYRdORbFNvxhB7Qb0s2YYp02+D8U38WaYBTEvlSuWQXOWfWkfPqQKwkxCc8kjmdihckWIsQbivveJHgrNdZ6i8S26RPAC1ey/CMvQUzHqN64AtJdJjlIG3f8Kv7HYnDU4dB6x47rYcdk2MCXAu2ZzWz98TlpmuNyLO/IYZq/d5itM/EvBzxQey3eJvwKXdAeESK4Fbv6Pi96V1WVDQOjl3omjSEA3aoWEXBc0337hIdZSEaDej9iXMoskwTi61yUuhdiSWJGlq6sc6e/60VmyyawRGBNp7hqpT7RIoloer3nn4NyQi5rVrXcClD0Tb9TFmOZ9SNnRd0V4hXpUZciQlVhxx7K0NvDPXWNXLR7IgUNNx
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae21650-91ca-4db6-7f05-08dbed4b7ded
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2023 00:14:29.5669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HFGu7m9eG3E5QStg88v4ntXdKPJnFqVMvA3xODm/NOi5YdfYHBo7g72lx+U+BsggpyoWF0AET4pkgTtZNI5GDBixhOixI7tXW/RRc9hWp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6854
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-24_10,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=728 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311250000
X-Proofpoint-GUID: lXLobK6nmm7-kXF6Lujc8qtGhsnTSpxx
X-Proofpoint-ORIG-GUID: lXLobK6nmm7-kXF6Lujc8qtGhsnTSpxx


Bart,

> Fix the following sparse warning:
>
> drivers/scsi/bfa/bfad_bsg.c:2553:50: sparse: sparse: incorrect type in initializer (different base types)

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
