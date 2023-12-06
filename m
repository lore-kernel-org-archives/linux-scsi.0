Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VR5y1YgG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LhVwTTCl"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCD89A;
	Tue,  5 Dec 2023 17:52:25 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61ZVZq020630;
	Wed, 6 Dec 2023 01:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=laxFUI4d3QoZ8LHqrcaauOi9lF5k/8iauU7hsdRneCg=;
 b=VR5y1YgGWXUqc8RSsCYUbyLwq/J4Npbg8c9bTkPc/+5QPWZXs7ykv/RUt/WB0k1MqqnE
 LbEif06zQiHnN1fhtJYQcs3XGEA49p/be6RODjAYOPREtlbEGDc2ObwcbIqgng0FnkcY
 qTR7K3TSG0VX8J5PgS0NUfjwiPlt3/3I5ECKC5RpCBQRIrxRlGauAn4GnOy1dSbO4Aii
 PsjWKFm6BGWb8csuC4vHLWN96TGBjCNqB3XaMlZaSYogE3/tdnmGziPHyTVfnVZXqOrZ
 eXCo4f6+3iVs8fW253j+SgBzoMaGrrVAsjChDeVbXKADn6nWDbgVMXgYXjPVD/dCDoTI hA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdabr4xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 01:52:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B60BYfi037858;
	Wed, 6 Dec 2023 01:52:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utanb3syp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 01:52:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxC2CScsdg6P/nBOgXN7F6GYzmzXip5906lAi28O7xMoj8xGccJ3SU8dkHwgjMeUhXdlly03lf3+iXCMxnnHxf+QZVugHIerJLbCY5mu/ZeGKTDFB8YzbCAeBi9DOmwywRtrqspM9GSTCBezIJaABfzxXeavis/cdq0d1GY3gOElVI9tqALMTEbwvVRyD5jcsTobBMvDugsk6PQeQXDMrpbxYSxxnNCry41zNH2w31ziSXZHioTPqWlPT93J2DIZhD6ziSKM1AdDzvPrzenblrFdmlxM3tGWOAUgbvpP3fcJZJQFVuHI3ESypQIF3seKQnvRI31ChKzL68eRmDhVlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=laxFUI4d3QoZ8LHqrcaauOi9lF5k/8iauU7hsdRneCg=;
 b=DondXVb2ap0yOiTrlLIyyaXTpZkW2l1UKkaMH2NSPcpZ0H8ZuRkRxNZP1CmBxtLR/X6MRN5Zqdorr2CEDPfpwHUsYZB+gi4ZXYwGGADUdzkfEZNQUQCPh7HVBDGFCYqnBctk+7W0rx07Fp+Uc71pTXAHYZ177hd6FXglE4rZH4kYoaBr3PW0PPqfSndbNmqxKTaBhHOwOf7Ub8ZO8tBPQx9EdK05O8QbdaU5kEEeOafbrcNZk+w2YvQv8BPA3/o206WFJfK6AiZEtQRhUDQtfC4ZEWCpJfVHUOdQbH83P6fqaKkGKTQM0QjhT7G88Fy02d85x7TE5tS6opRD+H7RCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laxFUI4d3QoZ8LHqrcaauOi9lF5k/8iauU7hsdRneCg=;
 b=LhVwTTClW4ns7P3XWp2nSbHTkoaPAU6XrzPy7hF1t3LZgtKRWDcXsPakGo4x/GeoZoWktHs52z2teTK9fDDRnkeLWyvAFyH5T2l0nPfBIcAfce2HustG7z9sAtxJdELpH/96NBvo0lk9VE2gJSmvVeJ4JYJiOHInYlaplBNaNRI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5356.namprd10.prod.outlook.com (2603:10b6:610:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 01:52:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 01:52:21 +0000
To: Benjamin Coddington <bcodding@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: enable READ CAPACITY for PR EARO
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17clsp06q.fsf@ca-mkp.ca.oracle.com>
References: <ad095388dbc550c5b199a1dfa71bcbfc575a7abe.1701272679.git.bcodding@redhat.com>
Date: Tue, 05 Dec 2023 20:52:18 -0500
In-Reply-To: <ad095388dbc550c5b199a1dfa71bcbfc575a7abe.1701272679.git.bcodding@redhat.com>
	(Benjamin Coddington's message of "Wed, 29 Nov 2023 11:13:54 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5356:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e62d584-02c7-4cd5-ed3a-08dbf5fdfc21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Sers+Jr3dxbPyHMDgwQXp9JXaFe/YKKhaHvpETPefsCJGMcZm2AhDhl65kOxfi2lK1LbiTpbDBBln0ZqbszyogeF7CVqONPKU69J6+Ml5qcG4HQ4YWTuv0/HljKPjVF0yW/TDM9G7id7gEK8TuqlF5/AjmhwbonnW5tjO/msn2G1YXzKoMLJdSbwxFB9EM6Xzx9rXQGTKL2NBHfZZCeDp4+gSKGOGR2HGDWSvg3G3LxATCpdRqoTOVL+mRHgrBDuQVEkelOR3wnUllg8gCM+cHpOAcy5nXL8JP1GRFO4oNfIacy79v8ntwZuR4qe4587KtLEXg0bLw8q1tgcDHcGZV1SBw74IhcEbP4WkjQsmfwQ0I1Ot5XEknislGBPlj6WbbBhw0CkkHDkFLZDil3ZJutdk4bZ4R2z2VkR2FtMaj2WF5aCAu42duxHRISyAx2R650STxQIPMoNrhdntAVgdhEHdDfJ2gP/UVN6B96HK6adiqvt1IfgJHyFW45kxwwrDo2lbnZQtH7KrN9WPSGHp1UNqQz3t0XnrR6zNR/n5UA0mKZ8kIcFHMmKYQ9htUrl
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(39860400002)(346002)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(2906002)(5660300002)(558084003)(86362001)(41300700001)(36916002)(6506007)(478600001)(6666004)(6486002)(6512007)(38100700002)(26005)(8676002)(4326008)(8936002)(6916009)(66946007)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nXNw2SmdU4AGSvgFoaHVxT7dpTSd+vwXDiUoYmHQpXeCeKaGei7EMG41IPJg?=
 =?us-ascii?Q?jh3TumDfA7UrsMDWQEG4u7Q3CDG2nfzbnq+I7NhikvdJjKena6cE0GWrOhg/?=
 =?us-ascii?Q?DyGzL3e5znsI2AKR+yV1KTTvzdt2sGuqyQFTdl9h/P9XkRVl/NTWXgN020LJ?=
 =?us-ascii?Q?q0TxMelAnL81fScJ1L4R1OBFqjsZhIuST2fELvgWEhrokEUOs7u+maocwX+M?=
 =?us-ascii?Q?cRmiRAANOOUgP6PQ9l4vt/44aoVcJpZ6bf7P+ofNtEJMLuJccbGTUfDu0C53?=
 =?us-ascii?Q?17HPNcevs8K3A9v7hdIWK6s8Y0Qw+ZDuV2BjRb+kbk6b6iHmIM4hTIZljZMj?=
 =?us-ascii?Q?GNReSBlZvcqkhtxQV+UuFWbifoVF1VzqkTeMB5gXuDxsZrnehP+WbNuosfQC?=
 =?us-ascii?Q?Wm2GWoGjPCV/+IdLlbzYWlbA5Kg9PniYLuk2tbzgztoIgkcMYOCSxiXi38YP?=
 =?us-ascii?Q?obrXTlO4LXQ/+6IJTYw3nlHwDl+CbM5VBSamc7sneIerCyYnaadMLenbB3g0?=
 =?us-ascii?Q?1p7PiSnuOP8W+QpJXjYHP1deeL1tGJGK556jSEz5XlFEVbAQ4qnfNHwkkLVj?=
 =?us-ascii?Q?SoN106DZnVCkfcmFO1uPH51EHFiKSGm3U6qNDENHycCAXfQrZAMnCUvTUW5X?=
 =?us-ascii?Q?/bqEcCPaRwjRSiF4sNz4qA509ZPnNpFTIQ7ohFQzdv1Tyx1rK5PxYGvls0+t?=
 =?us-ascii?Q?X4SPh/Lp3BnoCwXTdSPetEPYpjJJ+8zz/ierklgWumEg16HbxOPfnE+Rv0VD?=
 =?us-ascii?Q?KCGBeIqnzPJqRH51Lr8Qy1yP59ScE4fjsgPMyRQj2FaT1PaUuqTZirmn9zmZ?=
 =?us-ascii?Q?qqU1TQoQHiZxX5aXLC5/PoCMwh71lz/WlEDzTUBembtm6u8Gy7u73h4aej9g?=
 =?us-ascii?Q?GAw1DwSni9HIeqtLOBmpPbT9kuBcbLTIODeLZ8EFExoh3/bifa4w+xi2/FBF?=
 =?us-ascii?Q?naTuy1k1eaEYvfOyWBcP4qY00uPuozkqtbjokYafjqF6VuzJtdQ50ny+FzBv?=
 =?us-ascii?Q?mw5sadOFb2vZj0kWXxmZj6k4fukQjNIpAyGgzqr4aRKfjoalTYD8RunNm73d?=
 =?us-ascii?Q?jTfG/bz67h2Oi7D2xG6mAwTvl65bxG68NGuOd+Ln3g3PCNHrAYxKgtmUzMtY?=
 =?us-ascii?Q?bMJMGBd+ZH7kLjQPju4YS2WcQIL0VV7mH3+lSJVqAVsRaUcTp28xDaw8yYO5?=
 =?us-ascii?Q?NNfdO+c96ZfalJ/TQILB6xVG8gkAnJag5ogubEuvUq6u/2+2WdW1K1i6koa5?=
 =?us-ascii?Q?jmBUk6Fnd2kh1dgbWp4ExqJ1295Fi4zvJ5ZehB86YcXhEI2MjVHOkDJHBtqL?=
 =?us-ascii?Q?pGGF7yX3i14HwgEv1wVv6DC/vTDvJaNf5EiRYRi88UOhQDv6VouTRn66+MQd?=
 =?us-ascii?Q?p4J1i1X8PYL+JQ1OSoRzUZkEPxfyQw6gIh8sP8xy+R/0LTbEldp6YZEi47Y1?=
 =?us-ascii?Q?rDdL3Ja7qE9eKs8CpAj1sNkz8HMqGJryufSgyS5c7HBwLfOKvpWNo8aMhVP1?=
 =?us-ascii?Q?nk6rnesc4/eaPRhagQTa0HBp0DqfHOx19t4L7I1bY+uflNb8XbG1SKGJKwQE?=
 =?us-ascii?Q?LIxInkKw7riIJ/UpfQVv+cQ3Ay2WW+J6SgBrPFajJVNrqwXeSyqSekDD/Rc6?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5cwbhNuw15leo82z6J0FnRRK5h32lqbcccceHliyiRVR63vHG9R8jJai+TD5YCkB/aN6HHzy6I22+RWkCnC/DAzyWUi5uOpnqccq48a5fz33kClIlVOnMgytc82STxvKE1nQ3igf/9m/xr4oJMCQEuR5KyvCVKb0hC9ThwLfJ6ZEVNl4rn5iEIyPu4F1juqX23iYzoi/yDYNqEqAFtnVaGwnJ+/qapDnom7Nq81gGBahzb8PfCXT7HLZvallkShc7rroW50+ocqCfHeKdWGOQ6TzNg6Sae3l1TZKd6o+NR10q+IOHL5IXD0JjOk4aT1EQyIVgi0+Lii2ddYHTApCV5C/x2Y3IDCwhdlczEtemSOeH/SFDhxuFLF3DDsbCVy6t+DNK2lQEqnsXk0m6ouVX0FoT+9YR9Zq8Qeq42eIVroUf/dP8SdrvqU7uraLS1Mro+jG0Ql4JgS93RuouBBq8fk6li+uz1/ZY7gtnp/w68p6TbBfxXaI7/0vrCovikTu+jZTqYrjcrzupz486RL8V2HZeF/aZTA0R1DM+d5t8Cke8owwV5h67GPtyZsxBDfGkAczALIFulJ7cWHpI2J2X2jh0qPZXtTt/+SLOhC5umuYBkxygBvUCUxdq0hJuO1VN34GSHIhjwTaGfkeMibfBSzGkEhKXFwnkjiJlB8/dlKEqJA4NGvOpJbFVAC0Z0pOKggWU7yLKNxGrUDMFb34ovYuc2GgdYbB/xhWWVqagitcuinl9Wy7m+sjP1/SmgsyUHeWlHTuBqL4vAen3LYujJGloayYouR1Z/bTQq6N1iQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e62d584-02c7-4cd5-ed3a-08dbf5fdfc21
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 01:52:20.9841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLQXLCPEbWsODDn7m57z2ThD8668lxS9xcQZqxXe9r7kSUaZGmiR4hItguZO2t8UInh7LXHj1qvzsv77bfKFFznFBxQyKPutvMYFBgr4pPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=737 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312060014
X-Proofpoint-ORIG-GUID: vESJ4M3uoEZkddowPT1ulNAoaSCTOyso
X-Proofpoint-GUID: vESJ4M3uoEZkddowPT1ulNAoaSCTOyso


Benjamin,

> SBC-4, Table 13 allows READ CAPACITY for all PR types.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
