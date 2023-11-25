Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TbI4o29P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GSAjS3h9"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB1810CB
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 17:56:01 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1bxUS003655;
	Sat, 25 Nov 2023 01:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=LOq0m/KjIPM/1Fds2QjLfpEXAK/icEaylKLw4VM8f2w=;
 b=TbI4o29POHv/HuHarP2OYmYLWDugLdjh/E4s6TVLXLWQ4EFioMEh/mpyRh+jj72ENhHw
 IE3JByzveXXF/hci1X8dNIUB4X2ivxc84Lvw/vYxoN0AFqqeeDt98jMV+2TLOpPkMhd9
 XvcEQrs6mEOZuK08fQwN23i7w/RBKzvcVdQUd4Et3/74rEhsJ/afC6jkBXmxXBP0jzTZ
 QRsrAKccqdQ6eu4Rab1y55dE1r7kmTo3U6+ae4eH7VqGDS+76P5KvlFAZNeNJ7vwzXYB
 6zcO/en7SadjS6qnfPbWtp8kIgPURh4twhchL9ISf3LDOKCg7ekmQvpG3+9Yk7CSrMed QA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk7ber0ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 01:55:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1XuDD012742;
	Sat, 25 Nov 2023 01:55:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c8rcm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 01:55:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elnE3RDHFvai2L/mncRijy71I6rEut6kX2kev7DRzy5mpIUpYSJHHw0kSoKuNlpbGmXMI8MSMgHxOGSvaeLQ31pmKSlXLOBlWl6L3yilnXFMMNO0/SXBK0TAqUJUpckuNtzRV62ly8lb2drihNy6tENuksJvYIUVCax8PdGViBYYmgpk5fb9nKlVjru1EOh6h0ZPZoGZupGeNRw44JFrHJYuqQWAqNx7ukh7OYMB40xlU4FwL15DkARX84I9fVDwlyYkNtAuyLpKmEvz0w1JRNs87gc7zvvTKqFztK9mwzzTAHoNPkuV5MYR/9R+oeXWK9IGI1BDK5+CYBhThjglSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOq0m/KjIPM/1Fds2QjLfpEXAK/icEaylKLw4VM8f2w=;
 b=LDG7F2jGJ20XQ8sxSuRLgOIpuAeNqd9NDB0a+zjzpyMJcILjbHzmSjKCa1qHBnUM3bIx3RAnC+HV55Qh47CkbeLmxm+dZl6brFKeewGa3hCyaRzmQnhIlo0ilINlozSk/stgItZ+Ryaa4rsjOeb4DD64W7Ke/F/36PgccXpbK4dUNXT5PFfn+AP5Krk/siaGmFo09peCz04WnhGVtN4XdOiJaENh0nOQu9Wj5zilsQar4MmvbFZQxrG+KhIwZDeWGp3r7L1Y8eY+qrP077Qm+z94Kchl7rv9pev0La+03mRXmoRCXaNGvwLw4rlbsyc043xICqGROuluiuhmHnkpcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOq0m/KjIPM/1Fds2QjLfpEXAK/icEaylKLw4VM8f2w=;
 b=GSAjS3h9FyTPj9lCH7Vpo+SpCPbRmpRdXtRj5TPc3Y/pPRwEPemIVrhQlkSQ08cYSrnNOmYaLu/Vpabcyc3SryORseVTspN+rZ65ZdmiCojYIdLtKEQU7vYHyX3J1JFC4zWYboynickrE9SNItP2KqgEdb9YI43KYnwwuVKmxG4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7395.namprd10.prod.outlook.com (2603:10b6:610:147::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.21; Sat, 25 Nov
 2023 01:55:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.7025.021; Sat, 25 Nov 2023
 01:55:56 +0000
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: Re: [PATCH 0/5] mpi3mr: Add support for Broadcom SAS5116 IO/RAID
 controllers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sf4utx3w.fsf@ca-mkp.ca.oracle.com>
References: <20231123160132.4155-1-sumit.saxena@broadcom.com>
Date: Fri, 24 Nov 2023 20:55:53 -0500
In-Reply-To: <20231123160132.4155-1-sumit.saxena@broadcom.com> (Sumit Saxena's
	message of "Thu, 23 Nov 2023 21:31:27 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0198.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7395:EE_
X-MS-Office365-Filtering-Correlation-Id: e18b6501-9ee3-47b2-1db7-08dbed59a9ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	1Q2qVzF31LD6vVa/bbZo4jmYKnrrUHL6R7AQTxT7XTANsdcHNT/YTHX4o51VwvLA7zqhlg1r7SKcVoUT/sQww3PAyNAmis/O3nqWXADHT2JwY2ZKPuV5I+cnsqtJqgEs9lRNfmA9IMxomplQxBmjY/Uh2zM2KnWeDfUUQ7A7OCm6hri9AR40cnw7+9wb0EkGAIASrrITrT26LriSp0OqD3rPiH4ykNuZzSPTg88ygi+rEBbvyVCT5LQP7lnjVDAqjuPKj81yq1pSoLwcfqW3xbiXT24iSNp3iE0edAvD9dRFFTY+HjW3yhha+nDHDpRNHYSoOAtwHCEj/84lL+FCdKR2AmGg5WZQ78eo3ffjRkZndFbjtoHb/yzbzTAfg1KAQb0Iu3lNH/jxzKLUErYKHcpoKxUKVI902wY58I3qh6fgZtsfF3zU6r4+3TUxuvsH7+tBJGM7fsgTS8N5XniR8o+U1JG2m8+ZQquwvwtvbRBf2o92rbvn2igTVj4GxqWONzvvjwhfkkz4WWHdJggjTP8IlHuQ+zz8nzL4I+A+630Ob4cfq0ec9EbkOAnmGUjy8djUH9joJM5pmHga8oPhcqx0kKZ1bupH3ni4Yx4OoLc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(376002)(39860400002)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(2906002)(5660300002)(6666004)(6512007)(558084003)(478600001)(86362001)(41300700001)(8936002)(4326008)(8676002)(6486002)(38100700002)(36916002)(66476007)(6506007)(6916009)(316002)(66556008)(66946007)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6YVJBzuEAuFkIwfwiHIxuG7uq8UX3+/2yey8EVsWbhVDITK61wxCFl55+Saj?=
 =?us-ascii?Q?H6aiEgtNhbf42wVVZPVEgVTVG9QX9dRWDLHLZI2Vn3h+dGO5dog9SevStNL9?=
 =?us-ascii?Q?OxMakA2ow1midMWOoHo1bwBgdszhqkZd5Ibf5bxu72doIsA1nnP8MDhtkQ6d?=
 =?us-ascii?Q?166dP4FGMN773hC2AQJwDpfdZZbYZW1t9ZOZAARd8o7Zbn4HzCJHSwvYEkta?=
 =?us-ascii?Q?CbdJjrgJGtwlMPPgPKKR6PHtJKBON+lR/2MftLEAlbEJU0D0TxuzN+7+Eq/B?=
 =?us-ascii?Q?tf4MngRcuYTARI2UYWvL4jTK8UCYpcUA9fT+01pHYteBGJOLdTFwvtOdX0zO?=
 =?us-ascii?Q?n8vf14Fd2N1phZnjwEUAfCp8+rlD2PBElvwhoXqUlPY9VAlDo5IHRsLKO9Q8?=
 =?us-ascii?Q?UyR3Q13tt5VqJO14B4wr2YSQrTooSrOBCkOE1eTTA3nol+D9yuVVA2cIM1Ki?=
 =?us-ascii?Q?0+MGVe+7lA65tj3vWrKnZ3rh/TjYTvgjh89TOCJJbj53Zw+PRhFhAoywiBpk?=
 =?us-ascii?Q?ocPkO2iVXaZh7stfoJYh2HUwgYtHyrM3u7TyZ1mrAt4omCz7gFb64jPXW3vS?=
 =?us-ascii?Q?OjgfAKuWSX5Zenxt15p+kyEPT67iM+Nr4Hln8huC0pV3tCpg134bEz/8fzSJ?=
 =?us-ascii?Q?NxxNtGuwUfWdXdUGicnVHLyoowU3OPBT8aGl4C4BEkvjW3h9DLGbUxTEZ/Qe?=
 =?us-ascii?Q?wNmepL1J8g0XamfomWmRznXuf8WIKHuBAAj9iIG8WBDmXsfJbJLhs4meCSTh?=
 =?us-ascii?Q?IqWgkgIu0oivr+1cCBjIhH0+TVvYJpl/1cT4PEJD58o6wqvHiYMG12NOs4lO?=
 =?us-ascii?Q?7XpxX1lDYf31nIT46V9zZA2MVlxIZKCwR7d6wbZFbQqrUsV2fDUwvr9CyUuR?=
 =?us-ascii?Q?6LNepSXpA0uMiEiFcF3sW268qZDJu3w86gFql80KkXF2Hc9vFX7ZeXO5nHRU?=
 =?us-ascii?Q?jrNwWiFLd01LPqQjqfb/s1njO7xERCIjG4Wi8KsqJvijE3M4Jk8XKnRW2xk0?=
 =?us-ascii?Q?hujQ3eNvPjooiwet5FYzfXStPpWf8OOZo570s8/W+UKqQ3FAP3DLrkDwaUQu?=
 =?us-ascii?Q?8sVNPhHhxZM8wnx0VYK9IkZbzzjzrhb8+KQg3ARxqoB80ZKLKpIaRxyScDsX?=
 =?us-ascii?Q?6ucHsw28l2wXguKRbWQnpudV9YEEUrMcKChbZn729mk0BEOEDLF+/iX5kRwH?=
 =?us-ascii?Q?rH4Rw6g25tu35aYn19srmlRdEl3PjsqAibn7UP+uRoP39VZ3v1knsfrCylcj?=
 =?us-ascii?Q?h+J05eRQy8ctxrFxhBjSLKmdSKKpAr4ADFZnbQ6rFB4BwgoO8JTbWW2k+kec?=
 =?us-ascii?Q?yYrhpvRjfFjovTT6rleXOaa3HeVo9cp+VkAgyvfjjCS2KF5+M5qIknNfdlDX?=
 =?us-ascii?Q?5ghciklicXh2N1UVLukG4FstPabqcIKEAx6ha9AzM0X6/CzI+vjY/hX4qZdU?=
 =?us-ascii?Q?Ci+FuIgnsoQbIDBcbXuDLh44yI1DvhOBQQt/TWWbWJzCoWi9Udc3ZnSbCSvm?=
 =?us-ascii?Q?C52v52Gyq7rxFFazn6l2Wi1hjKEwLV7S8EOjBde0EWKi7gNYsYfzPIsH5IVm?=
 =?us-ascii?Q?0R89sSj7cnKxfeaPlSXO9q+LK7b1KPjic0KtbzaZNRU0KMJt3DG39sanx2yn?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	laeZ6yPUUQTvUGWrZw/SuECE9iiaVCZymnjacuVNtWclNpkSt+ukK0WSANECGdMc9Ro/Q1h4wS2PvUfA/62Z1fm/DD8Qfx+tCQV+5F4pnAdooWDStI/SUc48IlBBIZI5vBJiPU/jqp27x3kw+l3nGZ6XoWlWY9Xnt/MmDihgIJjl9izaGF4WioDIY0BpDg2O3O/R5CtNuE3CWR207TCO5eKJMLFQinHkd5Y794HGE2PZBIdbkn4c/S7em04Kz+SwDv6IPlxLgF7VQFFE1RhXYj15QdUx6TrYVAmFe1sFD8rIBnN9Uc9iXRZ2UmodHrFtz2PikaDkbpuGyxcb6ol9JdB1giu92m9XAtd0LmfzjY0+finQnUUcklAXoPbv9A0lvHqElZrKCMalgPx3Bifo07zc5pvVWBbhgMxcjaNrOfNylVQmsw+Fj4T90T5jkIqqEyrYZp+nZCV/M1PpdOzY2SGIepUDvfJpjVwicC3LPn0jNeHdXECUfsG+xsiAQggkra+RdXetJTqxm1by498XP+U8EcIPK52hGJhgxzy8SetNNREWdj3p+nOsUxLBkidNhycR/EjIOTkURb3csZ17WZXOwLJLm3sENCgAj0wAheJj7ae+6dSRFh+T9gqBzy0ysbC1Ysjfrwed6VWPkm8sZ+eS2IKtFKXXqGuJq/YsD5irbkiINQptjsWK7QYeZhnxJ3X2WlIFNhvBgnhNkPocYu2eGJM2OytepPUIDLKXgF/EZfeeagBwkUoUVqvo2WQ2x0ggJHUx43AQ5OM+0A8sl+gU5YvQzTaS/AkR4EIHmrU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e18b6501-9ee3-47b2-1db7-08dbed59a9ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2023 01:55:55.8656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aySdoXN6hqVf+tcCgUbscCRRz824PXbQK90SWW5lLC6tNHmyHyNHKITRw2aNM9woTBWTIHQ5TmKRo1j9o8hDtR6mxdeJaigmu2gSpn9ehSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7395
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-25_01,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=860
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311250013
X-Proofpoint-ORIG-GUID: gR5AV5IyegQyTVzZTOTERXQY67-bni5X
X-Proofpoint-GUID: gR5AV5IyegQyTVzZTOTERXQY67-bni5X


Sumit,

> These patches add support for Broadcom's SAS5116 IO/RAID controllers
> in mpi3mr driver. 

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
