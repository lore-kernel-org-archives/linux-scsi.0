Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1132563CB;
	Mon,  8 Apr 2024 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712596809; cv=fail; b=ZJV3mmlholJ1KoMgKDEg1k6h3vgC4BiQnAogFv1OYnY+x5MQIzdwReilDnTVKlGWrFUUqu72DP+Ol+D5rRCXcdPmqKIFFfFzqQuF8Wg9IrfmAOcLACrBFEFurTWg0v9XNSbGQ+youproMThid+HW/bgKfLu/zSawCyrX9dtH5SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712596809; c=relaxed/simple;
	bh=sP9wBUk5SChK+AGXl5jhIQff25HYcSOEeF5Tn49KkpA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=t+EqydsVkO4G9p5O+0Yxx3uODUWRrAqFPFwluP3cSf2VNwymC8pGtL0tURybeTmnr1SZ0jTKmuXbYbOee5tJlG5IsT7yNGf8dKRLFUdlNe/cwVu9tpwNFQy+byp0sTtfncEcHnjnzbqDHWqho7zWeo9JEStfUZyebN3pfGtX8SY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ltEn/7Bm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0T08OcZk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ltEn/7Bm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0T08OcZk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438EPXIZ011855;
	Mon, 8 Apr 2024 17:19:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=zHMI+fiTERGWzwBVsh5CUdFmQnS3iHDEQKcRuqNkc1I=;
 b=ltEn/7BmfyXnEx89ng0/HmkamJH+QrX2MoBCZVZhWWmyLKtrkJLi9HhtALP2mf0Ty+zf
 Mz2aKeGsmlYJcMqATfxUiS9OBc0+RArR9pqs4ZwDqnukKfJ/vgNW4i5/daJ9n6MwryF6
 cSpM4ZP+lF6uQO3Rjs/lyxC11wvuuqme79pVvcfRPP3Udxomi5yXunWL+ptF+Nrp2jQe
 olc3CpUCBmfPi6ICBhKAIJFH/n5s6AN5sqmO2U0EdhUDezRlP40ep7ttSE+y0lbh2icv
 yyHEtB0UJElHfg9wB6eORTPJ8QLDDh2tYygWk5AEQ/Jk3XezMv/O0NtsHfUA0GR9bygR 5A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvb7er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 17:19:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438GwuKF010766;
	Mon, 8 Apr 2024 17:19:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu5sehp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 17:19:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAPWTqjiY08BaGwrE/Dfj+8+PEcpg0MB9rN1erizSYeEhozCDqbe6nOVna++A1yk0Hf5yxFnltG70u2O4QYEPeLS6m2Hpk8PwJAR3ROmzDNUqadF39p37UghUkuxRAzXVQO7LpjuvidZcdIsW1iT/kbptbzPk7M+F0jtpII6OSN0CwEYcaDM25caZZatJXK/oTdzAJThiRL8zl1Unr1/AsWn4h7J/riJTVyRKu3KGpaFMr7ODSeuY54rbJfvDMsiugjeU87AULuk8T91TiPufSnESiCf5MH2qt5X+jHXhmY7nuWYZ9+k9tcoX9pmIg7bdI+b4MT18V/HnAVif2tZrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHMI+fiTERGWzwBVsh5CUdFmQnS3iHDEQKcRuqNkc1I=;
 b=D31MCyYWwHoyoQ2JbLUf4YA48sjX3CxoS8sk8Y1I81WwVqdqZvjsDjt1i1BhnHi2uWWpLf/Kh+ROvpUh3bF0NPb+czRRKfhVxT2+mG9rH2KbH0yuX4rKmt0JHvC9tY/yx2qJltmpYNfhc5ZY0HniwhsX61BuiPP0mY9LagdPKeHZtjc9WskPuIxf5bMSjZ7ihacZ7Zy2nt6zS9xrMIB1xKTHA9Ni3iKVb982Sj/g2GstpDfnU828dALoyfJNSlAGrHphie6oMFC9W0OUAM3nsQQPaTZW8U8EaQlIOkyBjbSZmFEYTRPozAzOM0BMNhtdMp4FO+wHsE2BFrlQugpqPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHMI+fiTERGWzwBVsh5CUdFmQnS3iHDEQKcRuqNkc1I=;
 b=0T08OcZkY/hW8FyDo/DjWR3IkyUB9gyfEF3y4XTzsQk4xLC5+2JLnXTelfi8lfkdZ0FJfSeuUrtari03ARrN/405Q6Br+uqpMzZNTVxMS42xPGeKf2S++tHjcqx/q9u55IY5uQUvAOAzC/Fr4iFxvewlPNt+PrLz5QRZl2wOG8c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB6989.namprd10.prod.outlook.com (2603:10b6:a03:4cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 8 Apr
 2024 17:19:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 17:19:52 +0000
To: John David Anglin <dave.anglin@bell.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>,
        stable@vger.kernel.org
Subject: Re: Broken Domain Validation in 6.1.84+
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b3df77f6-2928-46cd-a7ee-f806d4c937d1@bell.net> (John David
	Anglin's message of "Mon, 8 Apr 2024 11:17:51 -0400")
Organization: Oracle Corporation
Message-ID: <yq1frvvpymp.fsf@ca-mkp.ca.oracle.com>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
	<d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
	<db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
	<028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
	<cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
	<6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
	<03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
	<yq1wmp9pb0d.fsf@ca-mkp.ca.oracle.com>
	<b3df77f6-2928-46cd-a7ee-f806d4c937d1@bell.net>
Date: Mon, 08 Apr 2024 13:19:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0082.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB6989:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jUdM1tfmENf5XF6ry0vCKs7Xs890ZwiTA8OjefG+7izO1OsZM1nlfnoyn9BcrSn1mcGuOg6smwmX+oHH1Ud8ic4S03IRXJ0rGhNOhB54mdphNaFaGh+6X+aIZ+03WoUmiBCsmfyXzOa6o4fTPnOCv/ho1zvL5PeS64GOxNVpmi1+WU6dBKKwcQkgSEl4Im0m6GQxlJhfHOLDNhedkMDTEY0sSQpvkjhJZ/UvM+VljxRHG+xACAnnEBxIzp7t42TC+QaWOSArdsdpIUD/8qNkRJqt8aP3R86I3SJCeV9F4/9iN44y9HVuPHGURdmyA9zeYqSA90gZYiFO5i91EXsdOl/B8oeitDpP1BIQmeenk8beaMb98LEvEs9aE+hTQxfZvr2v22rjOq0Gfg78i2Sfx/mv28jqU+w3Rpu8nsch0QS8/va+8yAz/FLeyNZE+A6zY+oE+oxnZIEIqMWG7kSkjAJlF3IF0JfIFpyMjg7DKm9wcCFu+70+nKj6z/V0v9PBYArtCZ2gYMeCxVJeLDNIqMRik0BsxNAaMEKFkyjJAORSrQKfpFfmIMQ7FqxdcAUXejpz3xgpVeIF/lhXRZGRzOfsK5nGDAMrP5gWZVLw3Nk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?GorKIM0vgACGr6QPLNuXDKUPGKyeYb1EuRBW2Arsky0R92CTELsTfMrZGJbL?=
 =?us-ascii?Q?xyosi7rEMtKH7dgNXi96wUf6jyrmsDmu2At5DywLVkVotUDcEk38FePdHT9x?=
 =?us-ascii?Q?11m8S8dblxFfSvrs+VGWqWYT+rqWkWhd0MlzhiOhVFPd8Dt3SZrs4hG5tjRh?=
 =?us-ascii?Q?LO0QGnsn1z9tRAOpqL7gghndiANe+bnRJtKJKJ7LGQNGfchSJ+EMraeXiAEu?=
 =?us-ascii?Q?QD2gCwq3CTCPDBn4Y2r+rykMFql6Oi0gcrR4j8cWPUJ5ghHDttqwWDCjxT4p?=
 =?us-ascii?Q?WFOXtq3unusvVjB5S3TPkIvHd7UvxXwhKrBOkww1lkT8gYYruSca0T0SDO5Q?=
 =?us-ascii?Q?82vOo9feFjPu6PPZrhu/k1L7tGECw8CYwl7r8sSRNsg0Kmlx1ySnHgWFNpiA?=
 =?us-ascii?Q?s5CANob2JPRMi4siruIPR1A5NNUxnftdlGy5G2HMiALTZQWBJxpq7RTeq5lm?=
 =?us-ascii?Q?FCj7j/KuriwSou9b1Nhy1tLgC1OZH1tyYRs/pT+KY2pQQUrTPVMjLaLct0fx?=
 =?us-ascii?Q?GhlrysLGX9Fn2aCNSiENqn4+npkIS7769phGrdeYNa5EDACaUryetbthDJA1?=
 =?us-ascii?Q?BfXqOMLGnAB3wE80sMH+BcZ7zIpPZOmIJuNsKt9qwF3TJbS/RWeuuQeJVOg0?=
 =?us-ascii?Q?3573sTEKMlMn2XC+sHsUDrAwAWdVDo/+OP9+JJGsu0CvbJHgib/tcsiiTYGI?=
 =?us-ascii?Q?KDMZxIXHjdi/4WzynLHSfrAE3xAt+BrzDl5bIfH2rdZ+CUZqc/1o0OntgCOE?=
 =?us-ascii?Q?1vHZ3TQujqu5BKYgYL8nuvH2cKnZbRJOb8o3kT4KM00oiFBVWIgpl6Z6vpGf?=
 =?us-ascii?Q?IVD6kOTiOarR8g7o2XrhRZoEDi/weyIYsfSdQdmECHvpbYkpB0Z4SITN8U1/?=
 =?us-ascii?Q?D9wxVjHdjZouZxSaNxBrcQfJ8/KiI/X3BOkRPw7WdCNrch9MNoGorKghX/Tz?=
 =?us-ascii?Q?29d22T5Qb5/eZJgGeZbFCWojnhuTdtdqbdBK9AnhStgAYt/EQtnSR+0ikg1i?=
 =?us-ascii?Q?TCjtvxF3JT+EOFEs0t9kVngTrMLku8tcVr9LMBb5hO7xxntEZXDWsrIr21Zj?=
 =?us-ascii?Q?UjeSkb1qJ1nkLXxvB6hFIPz331p7SvsY7yza93YT0LJUyNhkti8rOQq+bOl/?=
 =?us-ascii?Q?scv9RCUYd+whgd/WlOtiDqTmJM7w5D6nPAIl/+t39NxTpKiN3YCHAPC7OFU0?=
 =?us-ascii?Q?dReGQhH+q6TKRrmPt5VtY4MSZTzzyx/k94N+CG0G02ahB73j8/jqeI2D3pRl?=
 =?us-ascii?Q?8Gyh2wCbLKnMHK+bP9wJvf63XuV5aKAStKfa27SP9VPa+vTZLUx2liD7ZCaN?=
 =?us-ascii?Q?bzYMxNjtxTAp1iBm2mg6Kdfir1IIvQgYw2UGtFBTHRIkwp2stHBW7mbdz5zS?=
 =?us-ascii?Q?iindoVEJtE07AKSMfgyOlz0ZzCe1KrDf5KQbmzNToGkkrk1M2N7G9kbcw6/E?=
 =?us-ascii?Q?YOKWyRVdQQVajKnknHgNwhWxMfPLRJk9GIqNcd1ty2iopwydLxq+8ZsMom2y?=
 =?us-ascii?Q?STiKlztakZLl+GoDwJzr94iK09VayR4IRqkNve1pc+1LNvR9/s590nA2I0YN?=
 =?us-ascii?Q?JbzQh71h/PZnD2EORakm+EaMWyf+1japLzGLW5hR2xFZV3nRT+gyuDNoLgBZ?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FbsCxcT/3F4hf9Mwostu31PHa7RkYoLM1a63xUTVcf6au2Nq90fnF+uktNqVYfFi5W42QG3rvgx3JlVEZVqHITfMcp91YyqqmaUEYj8ID81uBZb0764dicuZCJ4y8gNgJHTesb9xL94BCcBDcRDqFdmH/Ygs/d2fdX4iIDibdvDzvBNhfZwjyllra2dyVif/GyeG59K/vpOmUkqMai7pZJcmJw8UiYvZT/TG20SKZCJUjSDO0xdftFriYzibJzSi3k+62gq3RxFxlnFgIvfR4sx71Q4xb4Na6AkRMzziAl/B/4x8vw3QVQUbjrp0sZAZxESQ53Fkl8iHs0PX0Nweg8Aa/D8ZbFRnhC+qWl6mrqO3SHXuqgSqMIA2IFzu14+v/jEKDuEp9e50j33TZKp/of3nsXfLJGW6+mly+YyGPpCzBLFXUNVoM47l0jR3VWJfrLKUJ/YmNzwRKY0JviZ6hEoyGeCipE+X0HzSdm/hqGXLccbmCYagp3CnV0E+ngsnF0uIjYV4qPU50gw4UNxVmuJhMgv5aLhdwkVVhki5gb0UWqaM0vaRwbYm/kXLccU/RSu6bqF+oulu3gb/NcGyMJia9Ymt5vm6YQ52kInQCrI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c11d96bf-a9dd-4762-02e1-08dc57f01a23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 17:19:52.3690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXXiDM3R+ZS++C+69gmtCGvAUX4A5FDWZkwyiULT1HpVKhmbouFFWQcWCZTLwquffUajRdsFCHPQVzl26HFI5jfN0JyvD7j/rvexb7iNAIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_15,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080134
X-Proofpoint-ORIG-GUID: jJW9QNKcd63n13MUjptevLLwZnB9HeEX
X-Proofpoint-GUID: jJW9QNKcd63n13MUjptevLLwZnB9HeEX


Dave,

>> Could you please try the patch below on top of v6.1.80?
> Works okay on top of v6.1.80:
>
> [   30.952668] scsi 6:0:0:0: Direct-Access     HP 73.4G ST373207LW       HPC1 PQ: 0 ANSI: 3
> [   31.072592] scsi target6:0:0: Beginning Domain Validation
> [   31.139334] scsi 6:0:0:0: Power-on or device reset occurred
> [   31.186227] scsi target6:0:0: Ending Domain Validation
> [   31.240482] scsi target6:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> [   31.462587] ata5: SATA link down (SStatus 0 SControl 0)
> [   31.618798] scsi 6:0:2:0: Direct-Access     HP 73.4G ST373207LW       HPC1 PQ: 0 ANSI: 3
> [   31.732588] scsi target6:0:2: Beginning Domain Validation
> [   31.799201] scsi 6:0:2:0: Power-on or device reset occurred
> [   31.846724] scsi target6:0:2: Ending Domain Validation
> [   31.900822] scsi target6:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)

Great, thanks for testing!

Greg, please revert the following commits from linux-6.1.y:

b73dd5f99972 ("scsi: sd: usb_storage: uas: Access media prior to querying device properties")
cf33e6ca12d8 ("scsi: core: Add struct for args to execution functions")

and include the patch below instead.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

From 87441914d491c01b73b949663c101056a9d9b8c7 Mon Sep 17 00:00:00 2001
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 13 Feb 2024 09:33:06 -0500
Subject: [PATCH] scsi: sd: usb_storage: uas: Access media prior to querying
 device properties

[ Upstream commit 321da3dc1f3c92a12e3c5da934090d2992a8814c ]

It has been observed that some USB/UAS devices return generic properties
hardcoded in firmware for mode pages for a period of time after a device
has been discovered. The reported properties are either garbage or they do
not accurately reflect the characteristics of the physical storage device
attached in the case of a bridge.

Prior to commit 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to
avoid calling revalidate twice") we would call revalidate several
times during device discovery. As a result, incorrect values would
eventually get replaced with ones accurately describing the attached
storage. When we did away with the redundant revalidate pass, several
cases were reported where devices reported nonsensical values or would
end up in write-protected state.

An initial attempt at addressing this issue involved introducing a
delayed second revalidate invocation. However, this approach still
left some devices reporting incorrect characteristics.

Tasos Sahanidis debugged the problem further and identified that
introducing a READ operation prior to MODE SENSE fixed the problem and that
it wasn't a timing issue. Issuing a READ appears to cause the devices to
update their state to reflect the actual properties of the storage
media. Device properties like vendor, model, and storage capacity appear to
be correctly reported from the get-go. It is unclear why these devices
defer populating the remaining characteristics.

Match the behavior of a well known commercial operating system and
trigger a READ operation prior to querying device characteristics to
force the device to populate the mode pages.

The additional READ is triggered by a flag set in the USB storage and
UAS drivers. We avoid issuing the READ for other transport classes
since some storage devices identify Linux through our particular
discovery command sequence.

Link: https://lore.kernel.org/r/20240213143306.2194237-1-martin.petersen@oracle.com
Fixes: 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to avoid calling revalidate twice")
Cc: stable@vger.kernel.org
Reported-by: Tasos Sahanidis <tasos@tasossah.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 31b5273f43a7..349b1455a2c6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3284,6 +3284,24 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 	return true;
 }
 
+static void sd_read_block_zero(struct scsi_disk *sdkp)
+{
+	unsigned int buf_len = sdkp->device->sector_size;
+	char *buffer, cmd[10] = { };
+
+	buffer = kmalloc(buf_len, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	cmd[0] = READ_10;
+	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+
+	scsi_execute_req(sdkp->device, cmd, DMA_FROM_DEVICE, buffer, buf_len,
+			 NULL, SD_TIMEOUT, sdkp->max_retries, NULL);
+	kfree(buffer);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3323,7 +3341,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
-
+		/*
+		 * Some USB/UAS devices return generic values for mode pages
+		 * until the media has been accessed. Trigger a READ operation
+		 * to force the device to populate mode pages.
+		 */
+		if (sdp->read_before_ms)
+			sd_read_block_zero(sdkp);
 		/*
 		 * set the default to rotational.  All non-rotational devices
 		 * support the block characteristics VPD page, which will
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index c54e9805da53..12cf9940e5b6 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -179,6 +179,13 @@ static int slave_configure(struct scsi_device *sdev)
 		 */
 		sdev->use_192_bytes_for_3f = 1;
 
+		/*
+		 * Some devices report generic values until the media has been
+		 * accessed. Force a READ(10) prior to querying device
+		 * characteristics.
+		 */
+		sdev->read_before_ms = 1;
+
 		/*
 		 * Some devices don't like MODE SENSE with page=0x3f,
 		 * which is the command used for checking if a device
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index de3836412bf3..ed22053b3252 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -878,6 +878,13 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
 		sdev->guess_capacity = 1;
 
+	/*
+	 * Some devices report generic values until the media has been
+	 * accessed. Force a READ(10) prior to querying device
+	 * characteristics.
+	 */
+	sdev->read_before_ms = 1;
+
 	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d2751ed536df..1504d3137cc6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -204,6 +204,7 @@ struct scsi_device {
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
+	unsigned read_before_ms:1;	/* perform a READ before MODE SENSE */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
