Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LuXkeG/z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NjOj1EDC"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551111A2
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 18:48:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xwLB019568;
	Wed, 6 Dec 2023 02:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=tSiMCfmy6JQOZVxDKIWl+oRnqZGMtHQ9pM2k43zf7OE=;
 b=LuXkeG/zxh6xgABrEDe5AfE/qGjsK2q1cd6DK9J7XA7cugVrKRsAoXWuIedJe/twTjrX
 xWif2ebkcnxZV2DnvMe94Lyyh1UcZ8/3T0oGdCOBrUus/c4H1UUp1r7wSthINjdmt+GF
 3JHb6Sq5EmfYnzZnuP/j3jV+UTAEBmJOIZIkEKsOz0HdZTw7wpkLhFbLyQ/f6OvsL6NH
 OOopy/HwwbQA5QRyxPw7tCpZdtpS/ETu1jGATPEe/+ZiZNCXpfZEehD1fYQXd6FKD2kf
 Ggw6QN1fepbnm3Xl7tWu6qLsv9UKKTSvRJ97rotLjN70iF5Zjle6VWiVjIYodotZ4kSB VQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdc186gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:48:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62AIcX037795;
	Wed, 6 Dec 2023 02:48:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utanb5dk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:48:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KElHDsXjHAK6oK4jjwA8ooy4QxzQchPEq+0W10rWM9kGXbHDHTVWvZWIXB0oYJw9gEjzK6B9D4CBkcKp97iftGOkLwl5uberGTahpRD3e5WyAcr/u80ixKRxi7pma5ofFLYv6Vc8B5q94m5qAKxKYH417s3W+4iAG+E94RGnEYch238NQoxEHp+c7u6HgmsLlP3YOXZ9Ke5kMrBac7Kq4XFiQ1UWKWaIFAKfKcEqNiA9XTQeqbtqtJ1AD3RyUIOf/iMVKpvNEnaARRTsCwNfo/oJokKq9vhQ9xh9dy5a8C55fjIxztnO6ToXLkfl/BG4qfWVjKnVq6wjhGsXl+k2Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSiMCfmy6JQOZVxDKIWl+oRnqZGMtHQ9pM2k43zf7OE=;
 b=NiycjvWJ2aiiVGBRT23jaPekxv7dMZUel7K3P4lXGcu9Dz4j3P329n5n/Kb9AAoYJSEsGegg0nv/dIwQADxN6fs8lY6EJ13HzMyExvxQTpcZGWmRZHAswJsUiBTUHe+wFYWBCCN6XO7REi1Ax9iu6K0/YgNEbeHHRhPnM1IxuIKHojHVEdmBSv3SxycqokvWGzXsp4LVXASy4EOKN0hcx41kcG2t98O0g84rv1r8qiVz5UGPj1GIQVniW/LHK+FBxe4q1OWYOHHu0pUkb/4LSxEpkXC7Z2KWBoR69rg0X0M1YvLi8SRfUoF7OJWv/EhJSJ86MUbuUzo5qE8vRm0H8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSiMCfmy6JQOZVxDKIWl+oRnqZGMtHQ9pM2k43zf7OE=;
 b=NjOj1EDC7Faz+Jrd0iRMFKVLhXU6o14Dqz2YmHmXi2BDJP5/kr2fzJDcrxDx/2/AlaZjp3AIOHWHnoqrx64tgjSzkwPMMBuERKYY0bHiZGduhdpoDPskkwNimL7pIHlbDBkGd0otOVXCSfxj2gza20TMqtwQRcq00wO0fEMgGVs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4639.namprd10.prod.outlook.com (2603:10b6:a03:2db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.32; Wed, 6 Dec
 2023 02:48:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 02:48:18 +0000
To: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH 0/4] mpi3mr: Bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lea8m4gl.fsf@ca-mkp.ca.oracle.com>
References: <20231126053134.10133-1-chandrakanth.patil@broadcom.com>
Date: Tue, 05 Dec 2023 21:48:16 -0500
In-Reply-To: <20231126053134.10133-1-chandrakanth.patil@broadcom.com>
	(Chandrakanth patil's message of "Sun, 26 Nov 2023 11:01:30 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0361.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4639:EE_
X-MS-Office365-Filtering-Correlation-Id: 17714b17-d6fd-4335-4ca5-08dbf605cd46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	U+cE4CkvSucXKsnVihanMXxC/6PbmY9p1J6TJiGshAoX87eIf48cvYHBTHUyq5kZRzdcFv5fx4myhm2wnhSvPC6ihgULUtes3cH2SiZLdXCYlDMWNdr9qbtPh3ynrW44MDGykBOHi1ZKBO6TEPubNVudMuqpT4tuOhutge6NRy+JtSMau+x7ZdVSv62kbsPrCmZsvS7sxXrVmosR8tt1D1lekFRnpsuNZpBz89dET+Nv/6Acrm+eI294ys2ee6xP7/vbPB+cZaVBcQgAnhragow67zoVeS/F+A76lrr07csxelmCeqoTRmNMZI+mCXOE11QPJap5Esi2tigZGiO9bXcQUCzEMqbH01swFXNoWEVmyjfGQ2XQDghGdLcMxLDyGqXGLZMR1vbLItLabEwjDclXHkBQ6x7fgNRMsQgs1WkgnOu0SXeFcutkf8xNqRbZE2RO6WDce+08YTfctaNtHFyc+pDrZpXua7wa90fYvLNBRdGbSxcU3/y+bXisxzzhYP6LQpJmuSvfXCMsrqGtDI0Whk6ZeWdpNAGvT8Uc7QLISI+DM8rTTznEbc/KbIWfzFatDM82ohBPcJYnHva2YqYQok2CYJVWB8yjXLD8FV0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39860400002)(136003)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(478600001)(26005)(6486002)(36916002)(6512007)(6506007)(316002)(66946007)(6916009)(66556008)(66476007)(41300700001)(2906002)(86362001)(558084003)(5660300002)(8676002)(38100700002)(4326008)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LX8TMF5+OCxcwJp0uZvwUCfBmCQMCzb+hl4FljwG1khiISIAuq8e/HSYcSVu?=
 =?us-ascii?Q?3/b+jm7Fkr8C6bW7aIfh3CQnNxvGuzvQ5HWjQ3Ki2FpS74Emu98gJpgGJc6R?=
 =?us-ascii?Q?8goCFPddkiYmmDDG0cu56RTZXcYBvjuzp/JBjQ6uLaZR7RxPStgfeOd3ai50?=
 =?us-ascii?Q?dIgMt9TS2nh0Z9qQF8JmHzNPgxOa6lnpYYWa6yjSTopJpOTLAdv5gYDbbdIY?=
 =?us-ascii?Q?sa/Hz/9/5kfF1rbx2V8gpT67Hqr/A3/tUD4UcOBj9igXm4w4Xqn7cNtfFiEe?=
 =?us-ascii?Q?zAiHEBHCnS1xMi9lywdksBeXf0fLlTTsCzkoCEb689gepH0QH6Rf8lg6RYFE?=
 =?us-ascii?Q?ZvrqEbfFsLemsiaDe8peLOEc2m97epLZRqWbpWg/f9PzL9xCU8W5pjgsx1fp?=
 =?us-ascii?Q?fVLmy9/kFyKGYlLVIutUlICZPrbHJBW8PAyz5fcY6oOpZaxsn3PbUxPxiVjW?=
 =?us-ascii?Q?D/6B2FjQFmU8S61Z9d1qdcbMXvCTNZ2dmCEa4wvyMPAXYOjX/fZ8xiOCjB8+?=
 =?us-ascii?Q?hlfimvkBju1fspSITDBZIma9KRu/DYUCrK1LhluWN8P9/NOdOKzwgKbYP5rB?=
 =?us-ascii?Q?05+6EYLvCGe1i1vEPxbnFRwZoP4q31YWvXaDzDYgIRtY9WZao20KHUIQBKYb?=
 =?us-ascii?Q?mo5WRTA+zi0B9XWhR/iYC+9Tw5YoB0sTIEY1uawkVWgLZWefhljHFkOSw/UM?=
 =?us-ascii?Q?sun81saq3KFR6i1wMUf/aaPpGOBEuG5sTs8SkeqATuiSL5TThqf2nW1TW8V3?=
 =?us-ascii?Q?/NtYqrL4VDjnOWADU6tovTFFryAACyg/sTsfBBxHvjhuIU3YpQ7GvD/jALL2?=
 =?us-ascii?Q?e9cFzlr/J+VATeuK/qKW3j1B+J+hAPkLcfgG5IonYHoSYDuy7fauSzfrXdwi?=
 =?us-ascii?Q?Q776cuhHeH40VHRximyyQ+xpjsbr3ac0DZjGepeMHA9ZO8E95LOqfTaheQOY?=
 =?us-ascii?Q?seOdymrqOTIGJMawS1JJ4GC7aznr9bBH4A7jtO7dJ9MBy41cRe4X0UdoW7ZN?=
 =?us-ascii?Q?tXEMvv195EzeFyv4K6N6fWto4bmsDNVYiCKoXTFWlhKhI/M8796Lq5oa+/zo?=
 =?us-ascii?Q?slfnbYFFsA/ZQG3ZxqFaiWp3LZesZOTDf+hFxlXRAEqXAXTKcaiC7F6j04Ch?=
 =?us-ascii?Q?9QNtXoCCqaWVmuE2B6vzsoVmyKEa2M8dD0WQwzZU+OnFTwlT4gF7BQreFTGy?=
 =?us-ascii?Q?Gj24N4eGUHMom+7tNhXPqV2XWZSTi32KWLtEBPvuR1Gn8SNZyTZZTwkl78fx?=
 =?us-ascii?Q?6s8jRwkJg14JmACzmQptXOE+1VqPTWMPENDDIV88a6SLIHE19Audmk3lmTCo?=
 =?us-ascii?Q?7ciJtL3cqySsjKhqsaQfYmOebJwXstr7Vy5amqRtVC9tlSRxgDK/09ODDVMx?=
 =?us-ascii?Q?h4iNjlFK+hLmYLHq4G4y38vkpS536Hlh4iefQLQ+TFNxewsmMVSUbbHYd0aE?=
 =?us-ascii?Q?JM61ZgR8q+aTUAlgR29oJDhiUo+2/bcFKko10B/2/dhgugY2eiwAlVRmR3+Q?=
 =?us-ascii?Q?KJCqXQ0k0Gf07sHTpUcJZXhKAmemSnJasQf/7OXAXC6zOB87dE8cV7C1Xz5o?=
 =?us-ascii?Q?poZRVvgnWGbnySl6BqO10aTsbwQHAalw+ECUaGLVivqPFy7sK1Lo+p2zM4GG?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iLSfedkgDI0ZTbHkoJsVvc3rL9/7+As5NAJZOF59YwN59iKNsssRp0lq5NaC2mxO8olNwV8MuOAuVRVzbPkec2HNVL2Vunbt0u6/pMMrehHfaLeiEUb5fiy2i3C7/Qt86BxrTHPfP1Xu4rq8UrXH9rJjd0rJwI0MEaPAXi6MZx0cn7ce36xRvCPQ6iEHuOC14ssG1CsMFep4J0POjh8x1kpSR5c9HNge/5JgANf8E4POVQTO74Ror9RINMHaXwojo4ZpYC/4jvKiJB2SGtU/KqkolJbinBypWL0vlOlyen3dC9E/3qLzj9/5w4kAXOAXE8o+qcaz+ZK5WICIoagTFQzHJhBaFEp1jreMvvkNY4GIm999aeMlJpLNC8KaMetZZYB/WXotoIkq/ge9YPB7DsoVLxwiJ/Da8QIOJxq9IFdpL6EVcNQQnIt2DFi0R64mJ6pGeZji/QKG31v6Oai3gp9jKqZ29kPTm3l8R+s5QJON/y6+pLmk/SRf41MRA6apAnLS5Pk/dzDOALsqtZkAiIca+KJFlZHqZol18KO5IEaNA673bUrq/Bfk1w+zPsorsMW3x/uDu9y+fa7Wq4qAvh/MMrc+m9cil/5yuDOQSBtZCpVTbKcfKgZMt/MHYBvw1nqJXMbsFV0RpWLIifOdsVLM/5AcT4YD2ANamhNCx6ANBZlnKyrMhqvaQRVaKV7gMgyaD7F3cPRXOoS2PqUi/QjSQ1TtEHP+jLzmG0n0hxctZWnRciCVGUq63wr/TobwmpimL//U9n8Gs+L2cgavtd+EPO2W0uiHPY6YtWJRWBU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17714b17-d6fd-4335-4ca5-08dbf605cd46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 02:48:18.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: at68ZvGwbA7+1NRxui4cFmhOBf5Gp8G75YFDCfZedN0+fFV4AQKH9jyeYnyCvbgO/1fU/xsUmYaw+SSlGkyWbKTvQCBBIaQIxl7xqzZMoS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=600 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312060022
X-Proofpoint-GUID: CHaPIvvpnPzGh5swWE12bZtDHhpPWIyo
X-Proofpoint-ORIG-GUID: CHaPIvvpnPzGh5swWE12bZtDHhpPWIyo


Chandrakanth,

> This patchset contains critical bug fixes

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
