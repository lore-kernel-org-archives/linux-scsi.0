Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FzirmS9q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XvE0WbdT"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238151702
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 16:19:15 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AONtAhZ002612;
	Sat, 25 Nov 2023 00:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=oDiJNMhfMA0mB9qcfFkwdNBDijHKO/YXogeDI4flhjU=;
 b=FzirmS9qYML/E+VayR2B0LJg8JbWtVzEo+VqY6yGPaistxOv9koTDgdDsbzgzyeXc6Hz
 KF/cmx/4hNZD5pYQ9dGMh7CZgcacuUr2kW0PMrBN3VFojYqCTSbiczu/s2gEjJyHBGqG
 s19z+ztIktS8gHlj7a5XCjsDXeDFJI/jhdwAJHVI40HaDy5SVlYbY8wNyTxvufHIaRWa
 6fSAv4x3byBS5KLpalIdjULEmFbuBTRlB+idXh/M0BT/GbuIwNsM5U1ttIDkmgXDdk5n
 ZeHB5vIVPqkNXuXUXqV3ezBPLV9J0j8OnDrXrbu3zAYMFDET2AJb0AzPY880fe15SSlk cw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uem6cm01y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:18:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AONUF7R007366;
	Sat, 25 Nov 2023 00:18:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekqc50e8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:18:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCcuWvNRcx+qdhW6oBJNwFfWa/3SpyLy6EwMBb64faLXlVlpd64QHgQUYK4sEcRELV0vxZprdcGgFiwN6f/Cl9R0Jk35deQOLrOY5kk36ntlNN8CLDUPNPEDhy8d1yZ4dHryFND4jfNsw1j3sB/4tqZgSiJihNW/gHNo2ZuvjcPIWB48AodXQWcF/T5c+9ppPCLk5yG0yc0vhS97YStafUIG+c39qkjL8MrF7hnV0SE4/r2RFYyDWW2VoR3WmcXAKZvWaAtjeZi95TotZ5J0JN5x4UU3f8fBy903acQ1Zao3L/zq55LUjgkUBzyE6xE3NnDmow5TXGREcC4cg7nwdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDiJNMhfMA0mB9qcfFkwdNBDijHKO/YXogeDI4flhjU=;
 b=cKC/4tABHrfnTv/hI9iWPThN45yTBlTr5pcuzF5t8aQFr6hOtYEJ2PZeq/fDrhBI+UMUVYS1F3tupoIsPVUw4SwNJp4t+ZW3C631ldiCHWs3u8CqLelDjqgCttBPTnxu3A4yTzRIFx5z6eT1Yt0DYivmLyfRzPQpiAMWBJuCpMReYunjpEFR7bD+UUUhb65OMIhjFQ2BkC0K9xLsM8ti3QYUrhyawoxM0rEGiKennkmgQXF9RS20vWsI46ZOiQbVT+GSlhpWV3Az8pLxrKnmfX1ke7ZAbGzwIEcLsg9laDuwyqa3dHAxop15ZRv00b0aWBzIra9ZpApHPOgd/eaQbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDiJNMhfMA0mB9qcfFkwdNBDijHKO/YXogeDI4flhjU=;
 b=XvE0WbdTpwOKAHl4FrFP0qAg/yZPVkuRyCCBnPLkgQZAKBtDQknNHkjV/pqOlwo/ZWBHQhjKzYRD23RdA5v9T7z3EvcVVHGDUN1i2DBlztnwxpiM2rLLFYR+fWYR5LIrWHd4W2/tXQqU8MsnKARBz0Lms2e2QIBltKI74MLh5sc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CYYPR10MB7676.namprd10.prod.outlook.com (2603:10b6:930:bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.21; Sat, 25 Nov
 2023 00:18:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.7025.021; Sat, 25 Nov 2023
 00:18:53 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam
 <mani@kernel.org>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das
 <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: Re: [PATCH] scsi: ufs: core: Warn if the request tag is truncated
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5r2vg63.fsf@ca-mkp.ca.oracle.com>
References: <20231115193359.2262044-1-bvanassche@acm.org>
Date: Fri, 24 Nov 2023 19:18:51 -0500
In-Reply-To: <20231115193359.2262044-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 15 Nov 2023 11:33:47 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0068.namprd17.prod.outlook.com
 (2603:10b6:a03:167::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CYYPR10MB7676:EE_
X-MS-Office365-Filtering-Correlation-Id: db9a1fc3-dc3f-4de3-cbed-08dbed4c1b6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	cwVKR+W/hT6oKxJt4p3BVdBO6QF4kN+VB7oyDSsSXjSep9gbYCpYlymzbdklF50vGNlHSBWpgsnBfE2pImQn+9EZ47P8yNw4jHv4dGsV3N1sNtq4Z06kO5uHp9MFVjJn2cYTS/+xvrel/JOh/ByzmVM0fvdl3q82nangJ1az3JfggIG/TmFZEBd9HduMLkXmEi8yPsIung442tiycHBI/CKy67IASnGI2BXSdVivCWdYXFpnxxMxyyrZVrQH04SAb80H7SYqLrlnW0ZDxZjjm2uoHWE9OyqLpMMI2Oi1OHmjKapGBgUW5VTpR7cYti0k2pCxqojW6vR/s/NFp1QgZX9IOPc5C5ghC71L5pX61jNBn4VJUGKzi8dpEBG+U2FqPss6/VCN745o6zc/8qrbVedy9Hkuxll4pERd8QNBDusNAKHVYme1JATzrAwUU8DfhMpk9/oXYqGU7P32ND2h3CbxWVBamYFeKnKwvg1FXTDu8H+hPpD+EeRvso7aQaEVC4TDNRGxjD2FkAap4ereXP5pLbGuXNN8rAF989f4cWVWhm1/0gzY614rHyYi/h1QXDbObB7lQb2SzUfzBEPAXk+T6i4q6/scm7DMM2xdW4k4wyP684+Yx0L7oWbcu8bu
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(376002)(39860400002)(230922051799003)(230273577357003)(230173577357003)(1800799012)(64100799003)(186009)(451199024)(38100700002)(316002)(54906003)(6916009)(4326008)(66476007)(66556008)(66946007)(86362001)(5660300002)(7416002)(6512007)(26005)(8676002)(83380400001)(2906002)(8936002)(558084003)(6506007)(36916002)(41300700001)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?fIFtZJr88xf0Dlha404N2VBb+5v1ICsXblMDweCCvWcPNzL/PKQRNMpVgUGK?=
 =?us-ascii?Q?HTt6Of3tMCeVjC+KoIqMpdfX3+GNhdb89eWGTN55xx0cB9XBHgFvGcaMhnOT?=
 =?us-ascii?Q?sAmEdD4/cPsVesPIyAyJQmVs0I1+vX/6VXzJ2eJyfhhB4YzDptmBYsUt1aJb?=
 =?us-ascii?Q?O3uSSZkeFkzqKhlNCggun41fM7UaaM6wxe/DBeVIRwTBzHAVYfwGJ6xR43BZ?=
 =?us-ascii?Q?CqlEaahr4AXlOXhTPpdrJmF9z0Lj4mT/01P7LX8lvvVLZy7WUSLzFYKWsQTD?=
 =?us-ascii?Q?ZIluYxCbk9WyQlFm6FBFvGepM8Uam/0kuiGQS0Qs5xmnDYBM3AtSUh7saUJy?=
 =?us-ascii?Q?ZYKrDYK498qHu8pOwIaA8mQbbCYXoKdhjPWKcU03oqNoTMIH5y3sdKXfa0ll?=
 =?us-ascii?Q?BOYaK0AhXzEtmzfjC9DSWTLjAm79o45Tk4CHr5RY99LsfoZWED5xp+7vALhO?=
 =?us-ascii?Q?8WFvoU7kxEoPx3eYY0sIUMUb4OpAxPZSJ1jIJbKnwDeGroNKSyRH9XG6ifbv?=
 =?us-ascii?Q?BnVzd57N2remMbdEw2uHbCrJFxhDpb/QJXajj5zsn/XpdLIKZ0zDKJA89rRm?=
 =?us-ascii?Q?ngn0iwkWagvPjEnkFEAf5NpdgOc3piKafREU8U1G5A6NT+XGtj3BzgeQmied?=
 =?us-ascii?Q?ak9GIJ2/hsBHeBEgjzfHomuwhDWHbgdqFnBOuylwhmcaopUTEawPWKLSnZkh?=
 =?us-ascii?Q?wCm6qT2fkAi45C/a3vhT1YONLKvg1BZyaikX4ZLxcB4KclqYuyTtPCukG/pW?=
 =?us-ascii?Q?uPc5qZuLQWMqO8E99k3cZ85npZrh6IUc4fNZtTCYhC3usSsihbQgMfAML9dl?=
 =?us-ascii?Q?xR1kL6wzM3h1dVreIuIFaqdI9k6rFCJSAnZsthGp5Nwz3WDjwhB8vhaBl6qG?=
 =?us-ascii?Q?r2JlMarbWPaq4Wjud2a4tHaukmnUqHS60h8Vua48gYelGaBSqwTZELNJ35Sv?=
 =?us-ascii?Q?VflGZ7SNmK5rFfuh4B5ZEHQPJg7iScDEHUN2/MJEJ8ZumbbFWp4TSImHcG9F?=
 =?us-ascii?Q?WXZnlTKVq9kCM8/KhmJwiovpai/HBxjMZZhStOesyGClujoBwnIH4QvZOF8L?=
 =?us-ascii?Q?sO5ntj6CIyuQA5xqDRBZStEabPWaMNFcBcIZClkTiy7CBuxns2Xtw8hYiSl+?=
 =?us-ascii?Q?H+u5rSJrksgENhWO1pTFH+EyXnCUiqhT5WW/LXQGy5CNK7oTAbBSHgN1mz5i?=
 =?us-ascii?Q?UDQrJPo0zTlt5Rnkk3ybnz/ciUheGQfQjHSRox80b0syiFk5OHaT5DVXGPS+?=
 =?us-ascii?Q?Fa8Iap0Ke59WReiByFhGgcn6X9nYKKl31GQxcwnDcldqJ7zTaWxbMPV2aJ4M?=
 =?us-ascii?Q?dqJ9ZlDZPLjCRc1VIvUgHhBhQ6X0lwwCFqpNkqTds4sBKvy+1Jubmef8xpiU?=
 =?us-ascii?Q?PW5CeW701VbBu6/KAk1kRee1tC38jiN3TSQEjcdbXIAaBJYGna/sdMXRTHZZ?=
 =?us-ascii?Q?fIZtsKQOcygNiYBrbEKxWOKCQz9baW7BIq42zAh2zYK3JFYYsD5nBOe9YS/Y?=
 =?us-ascii?Q?n8WSYg0n+d39OI5oRWbt9k9gtqeMjhpCT/jmYa41nzmAFlygqsKV0Lx/Rmzq?=
 =?us-ascii?Q?A1aMmO3e20Fx9wtjiGoIsZW/XMuHo7Cn0w9zVM/jXmbrYOe9yyhbEDzl1bzZ?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?ov+Zb0rpZNZ4hP1+cMWgdLcZhWvcmXiUV+oih1Gk4KOeRepeBUVxBjzb+CM/?=
 =?us-ascii?Q?2ioF4qeKHAi8jTXtikh4pFO/bPx4HjmAFSbuMndBVjBMLk00tv/UZr67Zqah?=
 =?us-ascii?Q?9v2UZdvj+162rl/cqCKIrybThDrYLs08O3NOIot9CBBwv1p53N7pqP0uP6qY?=
 =?us-ascii?Q?GqWuWnBCfShieJL6MgqaVhamakH4on2vXuxPrQhDdrZ5ezifz1QV5cNvoZ6C?=
 =?us-ascii?Q?Ln/ko2RHxifLdmhNqZBvcsgDxPtwteTacHnyN6hCau8ItHlJJdKd4k6ynSft?=
 =?us-ascii?Q?naHRjpycSVTXNBx5Lq1h2Zx/6ocm/DCfamf8EGLVKt7ttMVAKnPE7XTYEVMo?=
 =?us-ascii?Q?gXHrN0HcMlPkAWYMEEetWwJlWtZZsRSZrk8k/WIuatAvCJzzBn7fdCKo5P7L?=
 =?us-ascii?Q?JhB1UGWIktLQjIXUET+npClIt2muP7psy/7XZSgXMapsCAv0GOOy02Sd/fu8?=
 =?us-ascii?Q?A+yaTI2TzQlZT61KR5gqYxI3qoUzL0j6kVCmdWULKcL7Zd8vihuyUvvip7zt?=
 =?us-ascii?Q?c7VhBqMrcs1mLkOZtNB0l5j8NWB5TWmHPwFebiBwrywJSTQhzEX8oGWQsCR/?=
 =?us-ascii?Q?h3Ma5UCcgzyh2DNXtMMcRGMAMdqUIj7riYeVynmPtjGRaP/k1d07ZmSDGkZj?=
 =?us-ascii?Q?ZJCTeDuhdsmGpFZd5g3rBj06DIuX0itep/u/fhyF2ZteOKfIg8b78J/XvQfV?=
 =?us-ascii?Q?1hbkAjg0sIwfTufzMvM2MG/9D0yUABNW+hPHrFfrNA3E+M1d82IfctEeSAGR?=
 =?us-ascii?Q?lpRGQY3q+fZCh4mO3kciLxB0vF3HYfku5Qsbzxik0UW7IBSHOn73mryzvby2?=
 =?us-ascii?Q?po8i/fjulJ2bxltULiH39fLcfK7T1+bt7Yr+g2o9kBXS/cT/Oba9Hq/RIgTe?=
 =?us-ascii?Q?G9gWORvDzEMV7I/BeX+aiCx7k52V5R0QpteKvIHo1SVkGMV9qcK9YIStkLhO?=
 =?us-ascii?Q?vORfuFqHpcTpIoV7x5YgTibGd989vUS5gWEVUHQtgps=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9a1fc3-dc3f-4de3-cbed-08dbed4c1b6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2023 00:18:53.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+yhYgZPu5F4WftOwmL2YxiPfAG4tN6KYEoob7APToU7JAyp39Gg0b9Mt9ypatz/vqlHDE5GgY9jRvDC78TXOkvDb+jT4M+8rGh+PgPBtdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-24_10,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=884 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311250001
X-Proofpoint-ORIG-GUID: EVjAwtSUQ61rOed8E3gOzaG2Ru3m-fgk
X-Proofpoint-GUID: EVjAwtSUQ61rOed8E3gOzaG2Ru3m-fgk


Bart,

> ufshcd_prepare_utp_scsi_cmd_upiu() only uses the lowest eight bits of
> lrbp->task_tag. Issue a runtime warning if this results in truncation.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
