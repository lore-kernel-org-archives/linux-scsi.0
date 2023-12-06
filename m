Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YGkDYl8E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lO1o4j7C"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E3181
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 18:48:41 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xEGJ029569;
	Wed, 6 Dec 2023 02:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=d048ZkByTjrzC7H9fXwh/ngzQQJJYBbdLKnmvJObQQY=;
 b=YGkDYl8EqHmXwfQGnh1mIWyZ4bfKX6WklekyUuujnWeLAGAjjOMJQuusdTi6j4n8WfAB
 k+iGO5tabrH5mKcKek4vEd4TlRqBBg+f5wUcel4h3NghW5DMXCrHwugngKttgCL+VVwv
 Gkl4KIChIFtvtPnbTsoN0bwNhi42F4yZrkv2Xwnxy2qvuE7ZxHwhtAwAzBBOMdUhp3/p
 ap8KMC3r1/cZFBvUbDucuiLcIV8oIM8m0F24R+OulNmwgP/L660lAy5nog++iSzePESy
 7bRzoPy5DY6cCHyMd/lJ/Jwcd9dqDzfgKwykZ8hzO2DntBm5cV42fex63NGQpdc3FFJv Hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdda06kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:48:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62Lki7039917;
	Wed, 6 Dec 2023 02:48:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3utan55hyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:48:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGVABhI0zikrSXxYCb8XkIOGj1+mVEADCVc2OFy05oRlykZ+9gFVhjmH3Ozg64gqAS+SM8v56NdtDE7ybcG2p5g3SuxTP1SMzZ5IOk/AVY4yx8FREI7ItvIvWrcHnjVJGbBhugMeHbYRPr2FC1sTg3WSfwhLOqcJnbsrf9HMClByRnZ4zJgBCwb9vnRohP3/ZbklXEat0C+LWXlJ6qHjMCQCbtRoglhFjtLFZwykWwFO1cElCRlAOLJUFZfWGvWlv4IP7M/C0nSdrYNAPH/T33RIo4pzPCCFP6KaARmm2EvC+RMQl0F1AuXP8V2hvLqZendcXXoEXdbxLmLZ1008QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d048ZkByTjrzC7H9fXwh/ngzQQJJYBbdLKnmvJObQQY=;
 b=OLi7fn7pYURceukTVi10x+ex/rpwrwaN3R8m1Q2XCbNtGJf9VYUEd43Qw8B3ECsHq/SN3PjZp4DMyTdYK/3MTE3tm+irZHnuea/eOoUHQPhazXoaz6arptpYf3OFVb1kLuneDICHLxJiqRSyLhN5GCQK2Qr88IVUEV5FPuiOcaISxVkk8LBB3M+QTscxv8Y77xRjE6SeOyGdnxlHQ178FfYBha9ee+gwGIjDVUJ1kWA1Iq5P5+LfwIf51NNdrh5pWQOh7P+2H0QziCNvJLJzCxRN4nbo2SAJuqstfiyp9ggyF47NLsRuVfo0vsYeRXz42T/j/kQNeo2c73ANsaabNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d048ZkByTjrzC7H9fXwh/ngzQQJJYBbdLKnmvJObQQY=;
 b=lO1o4j7C9QUGXuYJn4+srGeB0qslo8FLDYE6k7EV6t9uABcilb0oDQ+EDv3WlV/Cg57Kf9IySkLyeIhCS3sOE9vGlU2okmbAxNsMxNZi3i/T3gNmgCmsEVmcupIC2bvDW6rmtAbunm9veupfqR5+gdJBTjIIChv/8LIhpkLcQUc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5105.namprd10.prod.outlook.com (2603:10b6:208:325::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 02:48:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 02:48:33 +0000
To: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH 0/4] Support for preallocation of SGL BSG data buffers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fs0gm4g8.fsf@ca-mkp.ca.oracle.com>
References: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
Date: Tue, 05 Dec 2023 21:48:31 -0500
In-Reply-To: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
	(Chandrakanth patil's message of "Wed, 6 Dec 2023 00:46:26 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:208:32d::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 464f34c1-4f6c-46f8-9718-08dbf605d62d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uuFYywRNP4gPb29/FRNY82cpSiiog67o2cTZiVM8WLr4b8zaUW0tGNN3rDSIOmEfjw9CeDYboUPjktNP+rD05Yi8tpQxB7WXly5l++wZcCA4gO2UdxtBsI5pjvixfNnsVgsj4hpv684yD5RWLCvIByZko1yEm6YXmJHZmenemTvacS2KnquUytSeI0AvxkL5EHxwQjN+JtGFezPapIbZMW5/uM/dRwRB/QMV4DccHFw3/lEYfoIP41mJgulDaklP3tPbMeOS85KqwA/OiYRNCmBTPKAUyb6f59cGpfzkLGk+skZV43MPL5acuOUqZtH8puJu3PBgxv4gt4kDkNomy3SbTof/Ok2urQzMqakE4wz/pkoCIqih458eutEvmAY3vQ2caDLVDaj4ukpjnrXXTCUPmNYWPbspAcEsrSfnNYkvKU50q9I4oyTpmLuvO/P6+2C2fXYbn7ebM+7FlGIdR68L2CEis2SwAvGTKKajtBjUSLCgo4R09DW0B7Z7Yb9RKyM3JA1/ZDdf+44aAFrjObDl3syVoIlye/k4ZkVDy5JGNyGXBS9JC6eoamr44vmY
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(136003)(366004)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(6916009)(66476007)(66556008)(316002)(86362001)(8676002)(8936002)(4326008)(66946007)(6486002)(478600001)(41300700001)(2906002)(5660300002)(558084003)(38100700002)(6506007)(26005)(36916002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?n4UKO+q0k+rviz+fovQtqx6B5cYIYTEsxi2/5JR3hdg3ocJBXDnsTzC8zNOb?=
 =?us-ascii?Q?5ag6SkT5CgxGqtrbJC0FilGfl18bIyQohz1oYiwHOkb2f6y44e5Io+q2P9Ho?=
 =?us-ascii?Q?xpUIQHwjeGkavks2RDvHKcoxqs0EM1P7Jr6szrNrfTN5Je0ANOQxzO+O9UEa?=
 =?us-ascii?Q?Wm199rjYPibuX97VKIyXsOoxkhdwyngkzS3rCD34+kKvy4vKgTLshlMOrM6k?=
 =?us-ascii?Q?VeEcuGbo8nchINS60GeB28lJW+gvaPHxCOnqes/VTC4tFhIP3ly5LsdDOC5I?=
 =?us-ascii?Q?GT2gv66u6im1WijUSTQGwVNnHe9e4QjrTvf+hhyhEOik5MS2Kqzo6FkrwLV4?=
 =?us-ascii?Q?K+xPNLFXsV3lGFVe4EZAYrXDibvZDxNB0dNMtFgGQo6nnY++VoOMLrnQ3Dj9?=
 =?us-ascii?Q?04moVyg+ThW0EJgv9oSrUyBI4k5t7WzhIiMoVqc9Gx6RnGk6sQ7u0hk2vpck?=
 =?us-ascii?Q?Tqx+FGBLprIMKOTpqOOByoy1jMwtC2FPHBYYniWCFY62hfm+idVKQc+okvK9?=
 =?us-ascii?Q?xxigXuyQEa9FtRfDHyiDDj6YFqRq1lTe+nvOd0hp5d7FxPmwy9ojoCFskZMc?=
 =?us-ascii?Q?tPyPCedHrrbLB9qSem3XgUB5vtq+IJRF0RKbveFTzLD0hTGQg2bLGpvBKBKb?=
 =?us-ascii?Q?IE8hsTbyKoDAnOYQGQXBtMMBdl8qTvoTi/FckGeWMx+uWP/4kA6hHa46wVsL?=
 =?us-ascii?Q?xGnNrYGoo/g8+myWIW5f+r++XFI6duzi1ePKzY3CIJFw5j01OrSJKgDL0+Wx?=
 =?us-ascii?Q?5OdLgTln8+nvEdq3SJSz4U3LaECQfSdg/cpcUbY4eTp1sQMcXH5W9KQgVv8K?=
 =?us-ascii?Q?t70T3LxGERnmbncGiaxGdcNdkHRUxylfniuBFfdkRPHXYc6CFFt9DkiX2ahO?=
 =?us-ascii?Q?OgXaZd9nIQUg9SATqr7RMRhkdGlgDALshZsbvrDuv0rFuOjAavEhhcqfHrlw?=
 =?us-ascii?Q?e50iB5xproM6zjlus8KLeOZuA3ERCuTNu49GEzZYrIzqwmy1WoL3uDLsi31e?=
 =?us-ascii?Q?B77fBkahR1wAMSVaQIujTSjph+fM6ImGP2MOiBDW+4oMlAqZYtoLCerEZG8b?=
 =?us-ascii?Q?QTh9VGkIkYLcsba5xDUREkjLYYLVQmv/j+q3PuS8AA98rPfk6U/horCankN7?=
 =?us-ascii?Q?Y519EU+vwlh1V5pXMhNks2tCHV64Z662gJAne25+jb3JcagZV6+f16Y/SUAW?=
 =?us-ascii?Q?2ieZhRfbi3oQHZ2ZyNTi4cSPxgP+e4ZQi9PcqRfcyOw2SuzYfjK0oiUohso5?=
 =?us-ascii?Q?zQ9gwshl4VeQ5tkN2UI8hdijqHBk/ZdmKa9xLVu3euFHEYM9xDMvmzhrvAlx?=
 =?us-ascii?Q?xex1JUb+7cGGcvh+c4obpkN3aPNf5AqeVin9dHLADi5AUeVqdcjjmxAOuwLk?=
 =?us-ascii?Q?LOD/hUA1WqxBYPg0jQjDw/AzY5XfU/NpxPDdjV1iLlOQHviGZJg2PwqAnRqy?=
 =?us-ascii?Q?i0S8xJxarQnHuM+5VAbv5NL9VJvpng2gNo7qsML9aWC8hN3xqmp4Htzi67fN?=
 =?us-ascii?Q?9+tbHshu81xLX21g7/bd2DtjWn7XnkFAbzM3E7wSS37GmrTFWMfwSL0CKdxg?=
 =?us-ascii?Q?0FwB6vJWyjRlyuomU2gneTtREAnXpMqIXBqx0luIUsme1qhYvlB48ffHwDUm?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tFcnteTVTIv9SJg30PW4ikIPk+bqzcvDTZG7KuDBgHwpGgblrCj7J/bAfsyhjT2NUZmWdYZBGLXdBdffAdm87gX9hfbHol8uJaqBE2HKXPt94OGyz0ema0C/gcIIVMRAR6Fn+wwJXVOB7ziHX9q0YW7CmQ2aLrPHk0JcOq8gOIZNJ6R3zUYI5GZ7LwLSUhKt1BR2xlRgbIKpeMFU6Ap6EhtQmw3M5Oe/j82rmJ5wtVyIWTxKMhF6d6awOfZA8ssG6LkOa0GCwfIz4dLhBG9AaBtinKj0rQf6SA7uC/WT0fC7vHtdUyxa6n0OVx6aCcHC4ifB+e66JkafRTQW2uxYr+AhLRgeUY3ujEUhdABJ8p8QJjx2gn3kqYTFFF9T2yd8U1y/qw4OizfO1hzoqoB4Q1h8n5yzwI1OihGjlGH/tjI3oVL1qTL1u76D7ui++r2vQxX30NEdce/v6EgMyrWK/wSxXEjk9UNRnDhxeK30S4wZhZnwKW/c0Fo+PysnQu+dHE9T3aIJ68YE58BoZpV7JhEijlNjfkj+5IdUvW1nX38Xr6kHRIWZHTNPgUohCuV62j/HiPF2X+NhbdvNjnb0T5UnI1vZN/4wW1eWD8GOq28bQkLN5ifQrM9lzxcXaQKIAWE5tBwF1j1dsmrTkUCswT7z6Xhw/6I94bph3b3OA9TGwPjkorjHNV1iPENUII6QlYH+l4fEqgbg1BeSZwXYfedUAghc88miDExBx2cMp6DCAQO/lrttyd3tdu5f7AvkeJfXL7KzMmm8fJ5NUbzVLh+d35nz8ezzdsmTIYAprao=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 464f34c1-4f6c-46f8-9718-08dbf605d62d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 02:48:33.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aPBWLhjclivq2sRl0M6HnBL/mvUaO3CfSHiSvQm5HorEmwuKAliGufBEkn+LThI/0yrq8ijM3o9uoY7OHJE+8c3DkpT/EKmJUwevgOrxGzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=761
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312060022
X-Proofpoint-GUID: 6y3-iCZS7Ybs0nWhifm2ayHbyGE22Phg
X-Proofpoint-ORIG-GUID: 6y3-iCZS7Ybs0nWhifm2ayHbyGE22Phg


Chandrakanth,

> This set of patches includes a new feature and version update.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
