Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YBPq3Eu0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ikGjeDrr"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2680E1702
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 16:15:46 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AONtYXn002777;
	Sat, 25 Nov 2023 00:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=xm/qNE3tctXHPpg/RWBsgDBffeZoSNEVv3r0POSet9s=;
 b=YBPq3Eu0AseUyQsgiC7SbzoyV+V9zB7eHIpWD3Av5VwGebqcJIjYvedUfDuFKFukcraQ
 vwkPH3IvEMXQkH3sYzXcyNVq4nZIpkOsN9yolh4BC9Kdd9KSBYdD+xaucP7/iCNa/gmo
 pnJHubQDcvrYMjrNvfGINWv2uuwG6D/8xVMtmViwQJONmHqAMnWK0yR4tHZ+DMFEkyPk
 sG+Vk2NIvBmvXNs3dRXJx4boObmYwf7C/ATO98pou+I2+SiXoqNeehnXbmnthHfK2k9c
 YnS3YdsEmfKjkvG3TtBUwSHtHrbdKt6euxMdiJH4X4VuhZzTW6M8eVcm9pnQSD4iSwJM Gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uem6ckyy9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:12:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AONHX61011054;
	Sat, 25 Nov 2023 00:12:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uekqc4pf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlU3PkC8jnry1jVq0lsg2utT8vpE8rBNW/FaBOdef19V57E/SDzLQ5kDCm6MEC1l0Q4L1/9m1r9OGfkGdmhkNu3KZLoVHS6gF9+okCOTC5fu82DD6R5uN+QUIJuwJLf7nZWJhONvvRTEhSzXfuiuAXU5im5HU2o4nMAikODjxA3kvctcigpXySXbRNFt5srx8QtRwQMasflZc0dHn06y1e9w64r2NNzFu+7R1F4AMar4tEFBJo0+eTCsmO4gyvwcrsH61DFcsa+X8/kywMOTQbKPL/DI21vkhU2HoYLaLEE15Gn/CotYa+Oan4ImJtzjFe56J8L1M9gTnCYgtvkcag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xm/qNE3tctXHPpg/RWBsgDBffeZoSNEVv3r0POSet9s=;
 b=keS5yrGFtIEVEVeCgPrMYT6psUOmAr3ZaI3Eu7Bld/kl14tImvzkKqie/k/hUflTEJXekScsjPJSwcppeFf/pULZzaeWhsvXwVfrZ65R4otI7YRNuWIHFScW12TZkNMHFsngAIK2527TKxbYX9PK3KGNaO6scCbJZLIRJLvk6CKm/KbmGNSY8AonreGViMmTt0sE1nV2h8bOWuw6DCCEcZjWOKqfENWQLrTCcma44cw7S58cLyHG3mHwybvGXUBK+4kSCK9mw4eEaMgxQT999RpgCtg5etFRtBzsMZn6GibGY1YSgBk3AGkZ/XGlY2+ILnw5x/FtbPev9MuseiNtOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xm/qNE3tctXHPpg/RWBsgDBffeZoSNEVv3r0POSet9s=;
 b=ikGjeDrrAi//k9KQRpKVXQtWPjlE4Hc7MHDg2sDqbcJ84ngHBADewtdC3tjalBXYJXcDeqHL0ptvvspLveFzTjMtKPzGk/QbH6AvUUZ7iSuo08RsRQQegoTh0gT4i1wt7yBS1olckUYXr2b7Df6nCIuUCHCLnkIRam2w4xRqbSc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6854.namprd10.prod.outlook.com (2603:10b6:208:425::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Sat, 25 Nov
 2023 00:12:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.7025.021; Sat, 25 Nov 2023
 00:12:25 +0000
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: ufs: core: make fault-injection dynamically
 configurable per HBA
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0kevggx.fsf@ca-mkp.ca.oracle.com>
References: <20231118124443.1007116-1-akinobu.mita@gmail.com>
Date: Fri, 24 Nov 2023 19:12:23 -0500
In-Reply-To: <20231118124443.1007116-1-akinobu.mita@gmail.com> (Akinobu Mita's
	message of "Sat, 18 Nov 2023 21:44:43 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0216.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: 04741782-d960-446d-a5e4-08dbed4b33eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CsDHy4Rj3jHSk7Dtub/CoqRet5VMyVw1/7I7/0EOIjbpN3fE7eBRie4Pgg8Q1y7wF7gPQOsUDwDb0VCI5Wk3oBCaJT2xF6HA/rlZuoXkfVdcPzKph31lp9o+v3eC9jCsqHiHMH/GhigUurAPubzxAxCh5cJFCK0b/oVFG5bJO7PfLgT9FCmGsU6g65TJtniindBzQodfCZFpGU3haX2WL4D6aIywEfad2gof0RNBNaOGRY1OeQ2eza8+bYlCTaD8/D4+nOu9mjSK4LztaLY9AEUWiQFNzVK5Euq0yotF69dyfKtNh8mlnGzyZP8437605xT7tdh0ZkfuknAK/6P/nHZ0jpudNA8/yF6NgBLr5kaI5tGyrb05WCBhztM6wNCvm9/NQSzLEp5Z4GLrwKDHNByxfpY1nAhzg6ZCU8kLydHgR6WoIxTp36CMWbkhnmCObji+i3sn/SryWViLXaVtEuuwEim5uObm+7wKyfWOOLto1LQDXlDDqUmoK0O6fpQTCNeaPTfzCiKbYvs242oG/+FHQH94wb63lS84Xlii5QSHUTgGHvEteM49OuVg8emy
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(39860400002)(366004)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(5660300002)(4744005)(2906002)(41300700001)(8936002)(8676002)(4326008)(66556008)(316002)(6916009)(86362001)(66476007)(26005)(6486002)(6512007)(66946007)(478600001)(36916002)(38100700002)(6506007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?toRV1cmmmvWsMEyr4xlthKotxbN12CHvkx0kuoLXTy9vcHU4VTRic5dXc3EP?=
 =?us-ascii?Q?AEaiBlOn18dS2vEo8RIkSSB2vgxzPVORVyS74UI7WNPQ1FA4BJiLVSutnQUw?=
 =?us-ascii?Q?u5el6ENt4Uw5NmBGwGNlxFV23v2tZLDisb+v30329sLXG07IhQauamvF5V1v?=
 =?us-ascii?Q?wVbyJmEXIU7X+H2iIvTN42/nWVW8+F5FTcbqepEc0JsEYMtNNJjterRHeSh/?=
 =?us-ascii?Q?Rzds/o4N/xS6eeAa97FlMfo3/byMI5sUOTxRab9x1wY9XDkJg/qEd1seRDXk?=
 =?us-ascii?Q?pnR30HWi88Yj2JkM6b/e2UnoaFZZuwvR6IfUXI/iElOMwDVGdKMLS7IswABW?=
 =?us-ascii?Q?znu1HSj6DoCpDrHcDfMDjhlRvcZIsKDRjLlpO7rQtuumPbeQ1JmIsx0iHfH4?=
 =?us-ascii?Q?mPtT3wMR0ZrNIKOJ69XMmJcvxfabvicn+jXxMX1MLAKlITZkv4LyjAxy7Niz?=
 =?us-ascii?Q?M8A7c69MGG5RQc5b9o4ss205yWcdiuaKgy1h6EemyesrrdJKzsNoj8w7GkgG?=
 =?us-ascii?Q?6goio5ShVYmUsJFWOexbvhBzSqqaqOU0Wstcisdk+MMErxC2vis5WIUNJsox?=
 =?us-ascii?Q?RNzhqCByVjXtFXanSIMacrW7kWLbIe3OGfMRu8yHVkuTxXpcol4HeNHUEYT3?=
 =?us-ascii?Q?Gb8RhLjTwkrEHKpqiIBzwRT17HjcHYWUhe2XD/+w66m1WJMfit/xtIQfsOWo?=
 =?us-ascii?Q?3GO8rELsTu8tGhovF9yDceAFBn0dl6C94B/2E+ta9pKWaZZgWjLZvz9UjvfM?=
 =?us-ascii?Q?E0Bujz4/3QC9J9cX4u3dUW7IkQ/Ebl57RIH7n7e/FWs06peeKuht7ds1f8wW?=
 =?us-ascii?Q?hEE21+ezrHw7FgWTO4loGVV9kxFndS09lJ0Ej0JsjSkuNkAk3uBZCBLqcs4z?=
 =?us-ascii?Q?15cbaSQ6pS5cxAz6zYaesIXs52De7dZdYNwZqNVD/pXlnqntcXzPASGMcWla?=
 =?us-ascii?Q?maM9a+MOVWveySjNeyx0lLVDtFFaLq9vRx8jJYqcM+BFR9yA7cF9SK8mEuh+?=
 =?us-ascii?Q?R/PCsWQpvdglSuiJbQgB7dDOl9zlhfVhekZMrQz04+atNE8knZoqQNndTtEu?=
 =?us-ascii?Q?JMUZdw6Ak8KyGdGXSd6xXmxpBow8JrxT4aWcUptS8yGjlIDDGylGbg6aCJQ9?=
 =?us-ascii?Q?ft8ODjOFaD4KntoL2LWQkL2+EwaRq71BRTcOODH60g2dQZAOV8XUlIGpojWi?=
 =?us-ascii?Q?cQqF8YcrnfhaCb/zGxWZ0B+cUSkKWNsDq4jgb7RZwAyLCX1wdlEAH+TCgy+B?=
 =?us-ascii?Q?3GmFH5CsurnrUL+mbtD17Ze2o6dxNf/wA09zJTMxAZ2Sgu2UkJxRdRUBEJmg?=
 =?us-ascii?Q?jilhuh1NxSrTHcLnZKJK1RUXEW3hvZboFZfHAgokN8ja55lIdf4Cux5pIyjN?=
 =?us-ascii?Q?c2wgnUanA3LrMTSwh088euGfF4cQ8B48+5d3/+VVtuGlhSO7RRzd7WJeOikk?=
 =?us-ascii?Q?afuk/QJQMCO8uQATuHlrb2IOptHxDLAzc95KmoQEvrwIktgN6MKsMWEdLnmC?=
 =?us-ascii?Q?9F6UFzcO6gjqJ8uRwUnBl5BB1yGDaoCFT9cHIB3TgZgNbysClJs+GeDW6+aT?=
 =?us-ascii?Q?84WHLaXjOldZZG70cSz3Tg4u1GEqS+GtBef5jVpNXXNykpQmbdk2cWZrVxCg?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GOcT9B3TFA1yZ4ASZym6bh9cQ1S4dlEbuBKdcR+amvpC+uiXvCu0p/nXdxr5v4bCun4aryCNQWHwSBLOo1K6ieuvvtlXYiL3G+cd8HRxLAowVke5dlHAUR6Tpkqbpe+EYK8tE4eRqEikmfOA9HznjAsFNkDM3yOTE3C5rS/N6crW+5oFb5UB0R/mL/kmgBs3iyHQQb8k/Nx3oiyJM20qIeMFubAbmXReRVjr2F8LoKf+PsyxLEQYzvXsd7ATI3cQebbVEhPQImQsOSc5KwddrBPB9MF0cS5e5lMQMxZVH359Ftjlyi56plTyr2HU1iQeEDJP7zym+j7y7wAEkFWkynKA3tCSjF7dfq07TgU8dZicciUzFmsKK8zm08wiJWLPZfREQheD76mkEH0mQDIi4RPT5d9cL6qCDt9V5h55/hB/ZW3h6+SOG87KdmQSyr9MfN8QISi+r5sgwABAn8o4D7gnGlh9BJmOeCzNVEK4aRFLYLbY0cJ0CLcP0NPIzBN6HmbppHpJV657MlGo8dwlY1sL8icpd1N8FZwqNWgiaaFSyQCjm9Qt0arSl/Jy05Q65TBvMKcLLFPoSDh9RKUPBD5BoAcT73PkSeTyvgB3ZkumQZQd0DYUvPomKhefSG7i3gju9UmV5Nj5b8q1C6xJxTQ3wxCkvv+3xer0KAoDL2jBIyXgp9gYq3jSH4mT6YnQX9XNvfeJxNUbZ8gXLGapmv0rjVgdLk0hNaC9L9VYob/52XgrVGH2Rp0EnXEMCjMVum4Gh/0AZtPJBhPrfSJi2Gnx8eWoa3WOr53+ynt9qZkDpnPXorvBDunvF6D5lmSJy4Lo6O6eEeNtEDl7oOUGmHX3/30U69QDMcWPmc+JAOQ4MuNk8leS17ZRTK6LaFEmJnoQXvv6gWRQ0zaiJIazKA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04741782-d960-446d-a5e4-08dbed4b33eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2023 00:12:25.3982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CSFrOIfbpmQKQuMuiwAAgoryfK3OaUmAinvMXQGOrstBAs70exTrXhTRVe+cDeZRl9e6U86SWwXaeetttILxlu9naOwjWisE3JThY8Bubqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6854
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-24_10,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311240188
X-Proofpoint-ORIG-GUID: dOATv8fJsUORkdUFomODkgrNUY9UjZ4Q
X-Proofpoint-GUID: dOATv8fJsUORkdUFomODkgrNUY9UjZ4Q


Akinobu,

> The UFS driver has two driver-specific fault injection mechanisms.
> (trigger_eh and timeout) Each fault injection configuration can only
> be specified by a module parameter and cannot be reconfigured without
> reloading the driver. Also, each configuration is common to all HBAs.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
