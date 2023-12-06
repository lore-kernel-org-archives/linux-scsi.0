Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VjT5/BLG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B33R6MPi"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C6D1A5
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 18:55:12 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xw81002492;
	Wed, 6 Dec 2023 02:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Mr0e71lxrboysaeXiebdWcrL9+MJjuAASCKB0qRMeYY=;
 b=VjT5/BLGM3sACY8+pGJVtuuAhmzdGDXxZnkHU/VKS5AGrxDTRdg+KGgNXG21tjpqJVVg
 w4nGel/H4PLTO08jbGZOXojXDLL4A83/yQHJsmDp4Pq0a11QOi3S1ZnOTPvaCPuzMz7F
 F6pgPpcItdnXWLTJbW/0+qHp2zswiSGlD7TO+4UlWua8QPuT6Oe3nIt4R4WebgqRXnN1
 UkoHqwSBNVJ/RDdTplbgBwbkjX2Vqckx8nV/G3nrPJdQWEqpSZL21b2mKrXzBs1FzSb4
 l5gtozA6K5uw9Np6jG5kpeIU/8oWZKDAlOegc6SyUvWzD0YU1kbPQkHWQ24RbcYUOo8k gA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdrvg5rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:55:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62BWx3035592;
	Wed, 6 Dec 2023 02:55:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utan95hb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkwEo0dSMyNZgQODAgNV6UmMpo3wrpLjMmtZp/tA3XhvMmafpU9TBHayT3f8hqODWzV3mNclTMwm/4cKZSy/uu3W9tDSrKFWpGod4oLUvDiuWiKppdLqoisoyc6pvpnQIxr07BNz5HhW/9qi2YC1kk0eM3D1kCbeNHVRt7EHrdBaLup3QDxFWBFeHV/dVwKMcFObLHBJRdim15Mm6+f5lQlHnk4YHZ8ZpOGOwxo5PhqZR0Gk9qvkCPy4wX0lLfwA3qloLtqQ/wfglbsswpnpdjLdqZhae024XbOeqMUDdXl4/tWZLqB8lf+PMMfiiJ/xsYujEdlAERJX6uFoO+CFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mr0e71lxrboysaeXiebdWcrL9+MJjuAASCKB0qRMeYY=;
 b=RamDmOVdb9xIu885ISqbY/Eiir8ByjEntiTabsbzanEOj4IIke5Lhu6oZD4dmL4RMBy6/VZRfRD4+8Jb68wWzWq4NhV3eJ3z+LAwkzWWHRm4GX55cjXrydrwXLuQX0Vw7oyOvNyhD9sBF7k6w15JcDzFKwgvl/J760zOdwmYcgDkWnJk2LEE/h0NlSnFrWq9aKF5/jZFXoiHFhTj7STkot4ZmDLdr1XD4yjR0HR9pz7lKmsLc/uIxeUpUMiCaQK5XkQ4dHJBPuEpdQ4XfEsX5fe4nmYQYjEUNaEk/Ai1j+/5G+AdwRh0BdnI+ivk3OHv7XSxS2IQiIlrW4AUNTwrwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr0e71lxrboysaeXiebdWcrL9+MJjuAASCKB0qRMeYY=;
 b=B33R6MPiL7ph2HELo5mwbIZiTTS+dNNS609RaKVcoOFPWyTRyp9HxB4GGVYEy5kn/WynpSWrq/ztES4mXLgCDTcOmmCxmsNiH2X4kXRTShPO0lrTz7A3G/KLTK4Tf9CqejEd4Ge3x4c1cYXBxdW9xiom1eezd2FQIrQTA2JxZbw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY5PR10MB6045.namprd10.prod.outlook.com (2603:10b6:930:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 02:54:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 02:54:59 +0000
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Finn Thain
 <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>, kernel@pengutronix.de
Subject: Re: [PATCH 00/14] scsci: Convert to platform remove callback
 returning void
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5qom45l.fsf@ca-mkp.ca.oracle.com>
References: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
Date: Tue, 05 Dec 2023 21:54:57 -0500
In-Reply-To: <cover.1701619134.git.u.kleine-koenig@pengutronix.de> ("Uwe
	=?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Sun, 3 Dec 2023 17:05:45
 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0071.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY5PR10MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: 056d135a-d8ac-48d5-914f-08dbf606bc53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	VRjrPuuVzL/yaJOzers22OGIt1P1hZbTI4iYlONc0lVoIutRNX42YQvFbXwSg+pKs9bvUF5LuBxFvMmzd0DI1SuvIMLRIUxLomIZE6fgrXP2OP/fbaTF2Wg40u70YM+XpKTKbSeUklbD35sCIhD35RIAAX1MsnZgUKiQAK48UF/RGbJcL+t4slgJdtU+VnRvzsPSK4FywzkUboAEZ4t3t1mNHzCCTtSk+TQM2a39yxCVypAEd8DcerMODp72N7HJzQxCVk6FAh19YsMkng6iNFwqpN8B5Z/JXjq91mCn4WvxuzTxSXdOHWRASWG32Xyvc8mCkBshcAxnE5T1RcqQCxT6ljsSgBiHfsZi8O5RZpJb0gvQJTqWOVTKyZDXOZC1yfkf1X1AV3dbE3qkkhkzrpa8AQAgP4CL3S5CtBHvNIkFtNV/dvOtujBczQZS4c5QnONhO16ywpRVsrgT7JiaydM3QF20BWPeQXZ3LFfV22WDvsVfIWlGmpa8bVzWwHqDdsS8oQQqdQ12SP6G7vvkWazcejS/5TDiTc02/1Yi3uo3ktP4KxknqhjhEMFozwFw
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(346002)(39860400002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(6486002)(478600001)(6512007)(36916002)(6506007)(26005)(316002)(66476007)(54906003)(6916009)(66556008)(86362001)(41300700001)(8936002)(66946007)(8676002)(4326008)(4744005)(2906002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ncgmSS8HDADkMfqXP+QiT7T2o09KSRBmPUGH8isF5N33+WswhTb1YhnWBBLO?=
 =?us-ascii?Q?DoVoyEfvIyDIKYLpsiDQO9unhkgQMmaweKZ/EFJSre5vBt5onxc6xaUOZCGq?=
 =?us-ascii?Q?XFEIePFhDrdQzt3nS+z4FkpoLpf+Eylk8CqYeSsI6eM4ypn6mlmSRSNI5lGV?=
 =?us-ascii?Q?suPtA+uYbzNdccoubt8Kas/ZwvHHWEn2hgKxKqGxes9Hn2e4wHauvyz+nOVz?=
 =?us-ascii?Q?Unsb/D5Myq/9FLr8wR+ahtVoWb0iS696y3ItGqK+mixNrYW8Ut+Fu+9vT2bt?=
 =?us-ascii?Q?CyM9eqeT0mqsWPIDhmkEFXTR2qXBuWNEqlDXJJMOtPyAMPr3kRToqKzrqw0R?=
 =?us-ascii?Q?msMUfC/J5DbYb/RK5zJFXuC7uHzTTzh6sukv+zQCGkNyEHYi6am9hZtMycDV?=
 =?us-ascii?Q?aSFfhWXwyTNw2phY+rkUvJvCqD1HozW+9Pb69oOuO6aQcyQ/L+RiPuwRiSwt?=
 =?us-ascii?Q?yjZJlMC9sfGhpBLN7eNyAsdY5SWXfp2vHUwa7bpHVPc9zRdIW4nxp8alVW81?=
 =?us-ascii?Q?4jNh34e9Dty8hh8QBZjD2Cb0t3XKjgwVmgHUMjoLTgxR48R/kBgNGsvJjct/?=
 =?us-ascii?Q?tykmT/bMy5hJ2QoapWLw4EaYu92yC9wUPQXX2lcFL+FByDfAutfk4yLktajW?=
 =?us-ascii?Q?aa9LNlwc/mMYTLSY2gYMye2HG6WoHdn4V51EgY+EyGflVkJ6WAxr12+SG+En?=
 =?us-ascii?Q?l73aECAXZE47fbIbPQ49h0DUw+zOWndsxGebEVWBNK9xxgsXlA35IxCEPt2S?=
 =?us-ascii?Q?S/xnYqRryvmknc1E0HlH5As+l37+88ZjHdfJ98rwJSt0WyoQq5fWXCNBR+gm?=
 =?us-ascii?Q?Q2t/TfpJeXzxjMN609hhR6XHtwlwiBjJBBJFi2QsJCNLmCyOPqFlTTlxdrOa?=
 =?us-ascii?Q?xTn8oCmSCNFp5AXr2xB9IsuAY8BTNsEGcwr6icFctCKKIdZX7+POZW4uo0nw?=
 =?us-ascii?Q?HzQrnn/WolAaS88prbE5EJ5jVHaTniolvjt5k8BCuqlqYgGpsjHohsbLcmiM?=
 =?us-ascii?Q?l6o3q05e8pCX1kLMmxel0M8uAlUn+NeqM4vwqQtgD7o5PmNuzj80VyTTnCtO?=
 =?us-ascii?Q?gB5BoKfQqSGT02olqeYuahlHXxPXMI/rn98rDos3yYVrHKNn6D2sHe9gtO1k?=
 =?us-ascii?Q?4OEhNA5EMUCvdtBv2GXIJqfteNiWOsG+5b6hXAqod+Ag/KprCWTFIVB9JVeh?=
 =?us-ascii?Q?G8N4RfptwCJgc1FFE5dZMxO+pqnVso756uj7JZzA37UVczqGmasjkkzvW5Ow?=
 =?us-ascii?Q?wjpnoCCr6dctqpmGZboeALxMFRlh6OIvcSoqpX5C+D+5BKGbMTK9va8+yROb?=
 =?us-ascii?Q?yXEUlKTFqiiRUJe7Qje7vXflWCIkn0QXFXALcprN7tD3MMzWb/fgtK3nQmZ2?=
 =?us-ascii?Q?p+s/hesNMs2jWx0BwxPssamajhKSyZh9ngjev8TCF4Z5y2rLmlF5nc/LuOmy?=
 =?us-ascii?Q?VItnGS5V10oq6ZniGeIsIeqhff50vSdlTzoKSfWigHC/HZ0LYE9xUXbe/P+k?=
 =?us-ascii?Q?+Vfm2TCqFc2zaUz4zRoBCanAgpzMpoEjbH/nu+X/J2jLHZJ+JE69bv/dLynM?=
 =?us-ascii?Q?Abmq62A7o9knY0nfZKTsIHxwCdoKpJ0aYFyw8COKKdSOS3a0yDPdHOx6E+UI?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6oTUMvdD3WL2LVREGq6mDOFhjcPdB74XePSmv6mNETu49z5zvsv2kheoDCjBJUt4S5Fzrz9VY2dlq+ZTmZVVpQzdUfuME3+6rjGJOCkdWUxRTIP9nCrUmeLJOIYPbF0n10xlAFe6NcJAHqMDGtsig2rlPd6CsjJbJcTtRpzpWhpq9UB+68WLEbCLIppZ9+COoF4D+HVuJNIZs8J1k9G7s9bSiHhwJTzywWi91Weoalt58lxnrSdzvePZSwzC+GyG5eLUBGwh3ebcvyYoNOXxC7rK/S9AOiKJAbqHK0Igog95Gd6QiKBqOHDXKnRgJX1e2Fdis3zQWQix88DQkzREdA8PUQQVUcBX9ec3Rpxd7DRcCl7ozuqw973LoggR2r+5J1t9ZDqhDYYXZa3f0PwNhtjpV7dWqdEDpwd+jYQxEdqHME2NrVka3z6q7rJ5k26EZiCw5NnOEb21DjyBiR/n4/GPTikGrACD7AQ1fL5LXIQIIP5PrIAonI5Rlzfp3+taucazDHz0EDi7+lr6k8ysLgjVdiyEYoxqRHiwFerf6ZkFh1WyXC+sl7sh9UVdfL0dRiEe2Be8GGFoE4m4O/aZmjDkPYKBBreLc7aMXhzBQi+d8xR8Wti+msPC18kU0cTxT+qEmvxvulei7ZquIyJOOd3l3VqdExJjuGfw76zzAHS71ORxbRW7GfvMDzIGuWR34EITGPPOsLldmqZK0BApoa/2hBvqpHWPYv13zie8lPV6tZ93Esds9aFe16wsgFcxRQX44G5iNYoba4LbghWLBMos9QUq5gJIZVUCmgTWzubHOdhho33Dt39jzapHpxVuD1fXwRUblC/zvq3NbCFCKN5oF0cA81slOXwH4AglvyCZhNMvsxfrZzdAdYvU1y/YJtTGc4eWS3jFxOn0Ui4F9Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 056d135a-d8ac-48d5-914f-08dbf606bc53
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 02:54:59.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMsmj8jByWNP7s8Mw91Li+MKlxCh6TKt0yYVFtJ+wYOzAJ89AUc2EQEq9D9HiR8dYbSi+mZ900vvtfNYUNjm4q/WN8O8I4DiPnxF4AvC6ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6045
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=890 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312060023
X-Proofpoint-GUID: AdsSB7tjVHafE1zvYvlyica_3DHkb77a
X-Proofpoint-ORIG-GUID: AdsSB7tjVHafE1zvYvlyica_3DHkb77a


Uwe,

> this series converts all drivers below drivers/scsi to struct
> platform_driver::remove_new(). See commit 5c5a7680e67b ("platform:
> Provide a remove callback that returns no value") for an extended
> explanation and the eventual goal.
>
> All conversations are trivial, because all .remove() callbacks returned
> zero unconditionally.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
