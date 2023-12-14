Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="leQR2TK/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Km8/+D8w"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90953B9
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:26:10 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0SRi0005048;
	Thu, 14 Dec 2023 04:25:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=vG9gTxAozw3GkBxiYUMoI9jerlM9RcP4NCMSO/WHTfY=;
 b=leQR2TK/MTk6T9zkCQLCXpkjeuR3Xz0TJcXlLkSEceGrQ84zlPCGzwFp9k80RD1qix//
 lUQLqExMCmVHZUa5dCoXjW+61rg+3JgjTbFpUIR/Vu+oE4ZFGSfYiN2GQIKC7b0ttqRJ
 FpUZkiqLrfVXf0pRnoWEMIsw8aH1BhlNcFv6d7JwqwIcIvcZt6LjmR7Zo9CDUag0/uQe
 CnWL5Xi31nnwl/NWqvnMF3sZNvgGnKpuQmHOqSeXjHC7Bg3K4rIWOn8WgmsiSIre9tzm
 WbuRH84KIVoJJq/24jza+K0aaRUOyErzjc/cMeI/MH1jZckzMSuoyTSD0en/PbfiiU6r Ng== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvg9d9x3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:25:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE46ZAa003177;
	Thu, 14 Dec 2023 04:25:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9dy3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:25:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoFOTrRnoE6HcsNnw+TvkY1Au8btFQEmPawKnrpO0N+EiugU0FwKtqon9IgkTZnAA3GWFlkS7OZy4Jx9J0buSir1OyRsoht/LPysiseLQggv7hVDWghE99TvLy/zdwqBfJdH/2OaT24artXiRfYb6Ann3yLVqYCQNPtwuU5rxYe8V4PSJzu40NCdwUgG5kt1VI2hfjXfU5du3ir9ublkAcME3KR2ZFCBsCAdT5SlpEZUkvK6R6sFAlwv8flRW2upYszMKGEzd9K0E0HoNJiPcvrZGJKQuKB+6YXkwWP6kR0hogYuqWm62WBM2ZSGcJXIqTYUHGbpwB6fFpAp+n/H7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vG9gTxAozw3GkBxiYUMoI9jerlM9RcP4NCMSO/WHTfY=;
 b=PdFazyO1GiCP8uTiQekmwJnl0Ui2d5v1/+VXgsGlnD3vwEP0qOpqOqWXpMJjE8wLP539J13CKDcWROMOcG61T1aq90Oz+OteFzDv4mCBQaXa/CK+LX6WJhMiFiC7aJXMUPbprO0V+9Kdx20wDJOk8upsoeSgSp37/MkOfRfnxNd37DeYqYVhAbkdbjc9EbcgcBhax8NUbdRpf1kS/dYDWOWbHbrMvxuG40gFm/WCltyEFMwoKACdHeVTX4q5pds55wtbZot+r2Ui3AnYw4XGKP6037Szeu8Ormsk4/iZHM+FyHTIeaUkZ31AYWdcDzx7SXvS/DPKgp7WhyULhHvgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG9gTxAozw3GkBxiYUMoI9jerlM9RcP4NCMSO/WHTfY=;
 b=Km8/+D8wM3YLdzGmjmNdTpWQCXC3f3PPs2xQbRnnqbeUmwhqjxGf8zEq+q2+0QOibbgac9zgpb3W3ImlbdAEa2yTyv6B2wrtXcEb2sL/q7mYUMtOs33JTDTSqq6aCh9K/DtbumFQYjR6MIuyDXsvVvi6a5BQLMmaPJPodjmJNqE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6711.namprd10.prod.outlook.com (2603:10b6:208:418::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 04:25:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 04:25:34 +0000
To: chenxiang <chenxiang66@hisilicon.com>
Cc: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <linuxarm@huawei.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [RESEND PATCH 0/5] scsi: hisi_sas: Minor fixes and cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7etfm19.fsf@ca-mkp.ca.oracle.com>
References: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
Date: Wed, 13 Dec 2023 23:25:32 -0500
In-Reply-To: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
	(chenxiang's message of "Thu, 14 Dec 2023 11:45:11 +0800")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:208:e8::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6711:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b59defe-a9c8-4220-cde5-08dbfc5cb6ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Cwqq9uiH3+IA94G+tRCdpZ8lpJSgsksfhSJSrOp3sV2/uqaBEXzwQn983Fa4Q0qftAbghm/ZRFzkmnW3LbwEQo35kpBtXzg1PFpm5ch9X9tD5Xcvw31SHeWFK/iPLurMYcKUd0jy+k2aqaaut9qR6LR9MyhuIpDO2SpA6l6MOLugtem4djfumYslnZZOjkrbd6mZcIpQJlmT4RaybPg4DVrfbRfQb1hPUmnaH10qldtc7tF2aJM8ml6htPXdqkn0Q5GkdZzuJNdnjpnZrJ+tUoQOMJP/aW5tIZQkTG3oiAzuTb6C+jJ+zVcYsypE0/8EBomvcVZ13iE2HFEcA5kVTu99R3JU88FqskKHFINrG6CaAxP4lLpxVRSLICZoT5g7Hd+WEdcLSaaa5JpKGdCrAKFAkXj84qShPcxoENGzeYQlCYfGuBypa3VP9WNvRfoO0/LJfUVSs224883AA6sziXlXPz+nNW/E46gS8+r0N8yUDpbOFX1uAy8Qv4OwZRaU4UdKKG+DI9uUBA7bIpzoxlgpbg5JYqbpZvHbwtjrulIYIr85xYyoFsLlZFcEGzc5
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(396003)(136003)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(26005)(6506007)(36916002)(6512007)(5660300002)(41300700001)(4326008)(2906002)(4744005)(478600001)(6486002)(8676002)(8936002)(66946007)(316002)(6916009)(54906003)(66476007)(66556008)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?yVZ/ISbnFbuRPMKCkrKp8saDIULwDZRjJrsN5BNtNx05P8IbAE1lBpjTjPa2?=
 =?us-ascii?Q?3e1NO7bsLpTuB1GHzdwtKkgeNvC3D/Y+VnzB/E8XkcdDs7hnryjWN1enF12I?=
 =?us-ascii?Q?8XH6hoZ10sOomJd8eFJS5ara1CmFj9V6C1A3p3MPUkZWe9dtEd3KUZ6BsFjo?=
 =?us-ascii?Q?Zo7beJl1Mx8CVG7i9SrSfRzre7fFRFdx0/thpj/RzB27kJKr/VOpKR9/2gB0?=
 =?us-ascii?Q?u0ljvgfVTb82fnVrTABKosFScXGpvUCc/L+XtgabttLk9KHhmUmgRDmVAAEv?=
 =?us-ascii?Q?23rtktA3jH2A+3Ozk89zAAtABqTee2NbTeeV7F76kCImG28/Evlsdiiq8GG/?=
 =?us-ascii?Q?Fo5e3SH79ZIRMZbsnAI0YaR1ikDm5Cy3nfQFeO9MQI0zC14qbTS3OXr6vbk4?=
 =?us-ascii?Q?TrRu7Z7cbca5CdlRVHMkYLvc5i35BkYB9GuSXGSpKnnuuyyFQC5NBta3afVp?=
 =?us-ascii?Q?t9KkA3FK2TnUfF7JxCclx5wnKOraGd4WFHomeLBgOhgy1OnmWzvDJcN0CUUV?=
 =?us-ascii?Q?7oFx9oZmSdTxTUCNEKsSmvbpn2+jAdOOC/gSGdmUNhij8ScXzPVczDxb7+6Q?=
 =?us-ascii?Q?oPzrwpAnVgyzq4qago6qDui71EZLcxBi+1H3aLWXN8/mYdW3zQBRt+1ax4AK?=
 =?us-ascii?Q?ntsF/bGiZspuVk2Rig5UqeUewANo6Ds7Xdiq3mUP+LKVVXDG+A2SAKePAI3y?=
 =?us-ascii?Q?6oxCItg9kV46FMrN0tsB5UpaBdzYc458vyCM2LC42nloRmyYV7+KkU7o4AmQ?=
 =?us-ascii?Q?9L0x+CzqEfo1g1nmE2SjlfESMm2Yu0ota3Q8jz9FXLhhZF/nQxNgi0yuhft/?=
 =?us-ascii?Q?xb3d/49+9vCpYa7SWwfU3ea0/+ul9JFaktBHXLifP/YqyjoH55PW43Yh4Bca?=
 =?us-ascii?Q?IWAJty5gYqWuy1UAYesR94osE8p6g8CIbSgGRHwsu0VnloMKlztQC5aZX+ps?=
 =?us-ascii?Q?bPOJ5afYA3UwCsMdWF43zWfLZ/QSHuMVrW5Mpr7wQd7UgwkywvDKo7rOVHfm?=
 =?us-ascii?Q?QyPZ5lusFYnUy0CHLn9JzveWFAACH+vhtD136RUxYoLd5I946hK+wsg1H4Dw?=
 =?us-ascii?Q?A9v2dSvE/ZSM/oLF035J0Pse77fzgUL/Uh3yMMb1VKebs7fspo3DvMYA2z3r?=
 =?us-ascii?Q?KcNGOUQWt+oOCPtd0sTKxW0yT2PQtuocZ5+OE5HDmYrSaJQJyEvruioSV9cJ?=
 =?us-ascii?Q?dWB9gmHeCcM7tfgQP3DMj58Yxm+XoSTTIxT+LCoeE0Q445xRnkGo3pkvp0T5?=
 =?us-ascii?Q?/skVVdLjlkqx9cmrn0CD19Nr2tFYJ8uR5TkukXoIZ+Grhy5O7DW+krO6IAl4?=
 =?us-ascii?Q?DeV3eKOMmYhMg3BwWG6T2cpS/+eku31SvvzzTx0iITuAd0UOtgLZXb++isVV?=
 =?us-ascii?Q?FKsy/0fldK85OGMnDXUJLkvrT6oLV8TKG7MghZnTYAusVLzDcHBwrowKq2tc?=
 =?us-ascii?Q?/V2fKQ3F1tHRBTUBp63nJpnozMUpiOJ/foyoKY63sRr8nxW066F5t9rtePLC?=
 =?us-ascii?Q?35bnwV5xgzyXkWqAhr0367H6QDajkIDWKmkk51ZbdKy81F/kANs6uh2Odgy0?=
 =?us-ascii?Q?DasEjQlaDkt+FuXfvYBOfeq1v0KwJlTgrNbR0GQwW1xlEcUlDyva+PN0FG8q?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HemOEVpNWA4YBnVK19A8LumyGOV65MZlk1gl4ejKLbBkRPFtyJSzO7S/yYjxmO7KV4k3OHrvbS210IB9XKfOtsxZQNYFhGhAs/gFcaA5G7exZPoxPEvWnnWjpgzkfx6fh5pwLUEuKBtA+Mq80lZjjIoDGwGZ4lXFvHOndggCHr7cp0rUdEt1/vVInHRi8/xF+ruIBCopT9KETl33OEKKON2DzqywMWAX236xPjtc+t0joZhXmXAGcqfcqr392lHigOrJO69SiX2T48owZ3hM24vqtiSksBvg488arfLhoYGTZlFcmqI0EiZYfM8FeBkeKt5iYrUiKeM/yc0iKmxl2L1Hc6lSTyqPthBQTcNZlA226mFuRecrWGNi4nrB9oRaUq9CrPy+M5bcxXEM+P/S2lOVDBT8nZuQsDx3y5NJKCMKluSgcda8KceQeBIOujCHNfWMZmFlYtStbcvUxUXYzXxco8EtOuRfTMU9eVG2Mx7OybhINHmeaa6EwWMkI4XJoUS7DyYrN3d09Ylp3IfI+VEb3TyBUSpGsQMS49jk3uF3ZMVfndfA+52ixrxNxKFVvIvaPcY18Gs/pCql+1RAxwjkMRxK1UuLS+mNK2G6jvM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b59defe-a9c8-4220-cde5-08dbfc5cb6ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 04:25:34.0616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egqxRkf16bf/rMZYncDcTDqhP/7onSY6lImWV5Udu4Kuzo6USfsqIclkRuc9RAiHqMH8CHP6na2RJCXenNUOcITNcKEkjPN8uBQR4wfyNmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-14_01,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=753 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312140023
X-Proofpoint-GUID: Zxmw9bLPgMZuoGae2CGTh3d6MJARBZT8
X-Proofpoint-ORIG-GUID: Zxmw9bLPgMZuoGae2CGTh3d6MJARBZT8


> This series contain some fixes and cleanups including:
> - Set .phy_attached before notifying phyup event HISI_PHYEE_PHY_UP_PM;
> - Use standard error code instead of hardcode;
> - Check before using pointer variable;
> - Rollback some operations if FLR failed;
> - Correct the number of global debugfs registers;

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
