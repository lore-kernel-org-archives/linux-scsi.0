Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949D13F424;
	Mon,  8 Apr 2024 14:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712586755; cv=fail; b=ckCT4UwIOmcs+zhIiCJBTa3IZjxqRW8wAopeUVaOYW2Hdp5lm4KGTvgTxcwJqw1YCAcMgFEIXbJjsy2O19BqHPB7NLp3+lkas01HxhB9Wy+n14KK15FOePnsGFYgcGqDerm78RTLTJYxKsD9rKDcfP/J8ajsg3TV8nkoKVbB4O8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712586755; c=relaxed/simple;
	bh=eAPoXqAnDSJT67jfyWtJlKYDB+yXhLeGQ/zqTpwLfxo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UknTL/EAE9pPCb57Q1gxsljypaN0/HEk3BnMyQ/wpqOhQCLNs/G5kzeJDANz12gYytGLIoSruWDA67t+JhWu8wcr/BiXfcKFYPc1OGoDLZl0+K0K3t1PsA6VQZu8/Wq3CrpWLI/sHGcwLFaVhSwyelLmDM+27ipi5E0dTw66QNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lmLVmFK7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wXJJBntT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lmLVmFK7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wXJJBntT"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438ENwKv014629;
	Mon, 8 Apr 2024 14:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=KkwEeI8T0wqIzQEIqRSlnUDEOWjUPNeQ4Ca+5UYL92o=;
 b=lmLVmFK7Vi7+KikgaefwBuOZ3FZVrbthKI+5aX4sLnh1fISZk/dPxK90fcwk7an/KEu+
 v/sapL9FmNh3C44SOOFuGN+J0AijlmhZ2Oe2xKuaXMUHrS2kt2MOU24lELZHZm0PBgyd
 7ootDQmL7MXQLUmAZuG7NrvgilnWLVrU+0s+YCp/MdqY3ea08cLmUsARkcGC5kL0rncz
 zMaKHW6vy801QDrcUR9dhcvGi3k67zxJR0MYnRgFMnC/EQGbAYAxzBDFRJtbJLnPJrIj
 O41dC+nTpI+7O7SDgJwznmc0quUUXYyF5OqOgMWtXxU2GdWteTei+jK30XmSNKQZnz70 6A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtf2v93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 14:32:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438E0Vvu007843;
	Mon, 8 Apr 2024 14:32:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu5hktg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 14:32:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw9OaodrNGT0NeUKK0TgzR9bfNluuS6axjSXwplB+2rMR3ker/mLpiHDMiBmlkz0LDJfTCsl/6roXgbe9MgEHncybVoRaMj2p3fhEi3YRa+8emd9xHx0t13MEIKSqszgzoSBhvxN7pUTcw+nirFT4P/tuSZ+cF0/Rce9eaP6wCAmMI07OQf8jD1izvj+VvVeTjio0ryeC5LZNgUwN+R5oilmEeTCeX+1WtktFOlMjZWbYSMAiS2rMCHbPBiPptL1Z2jGJnfR09vXsSJNNdSVw+OFsexOd3WUBHpeQ+UgZ7i6ptbEMqv5eEEGhpVunnJ6BLtHR4f9+Q9c/eScRDH14A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkwEeI8T0wqIzQEIqRSlnUDEOWjUPNeQ4Ca+5UYL92o=;
 b=cqNA/En51iuwqPv7Qwqd9iCbMGBOMXyz6ZLP5VPU9EhX3D4HxwPGRW2cj1ymLMQaI4Jb7RuFPK2Xp6hX4AY9nqMk/2IYrDOw+221Y87+nLTNSYIxP3yYKU+M2PXudO7cKA1n1Yi4Zqu7VaMjtj+ljEZ2DNfns1sGS8vclD+baIWscV++lZcn+QrAQl22WkN0o8DiO0nEwuApameQJzcfEgaJrRM23dMSBl2kPCKCWj09PrY7slx4d3aFUMpTHCqlk8fbVytqgknagU6do62Z8V47IEbyV2hSnW5IRH4WiS+eb6lSay7JXx8RQobvRydymNqWhPqK3puLFpQHaB1Kcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkwEeI8T0wqIzQEIqRSlnUDEOWjUPNeQ4Ca+5UYL92o=;
 b=wXJJBntTrY9AVKy7BqO3WK3dmnq5QRhjaVCVSJkhtKzc5gy7HVWAyUOvJT+Vq5Riy60nTTyxM1qUKfL9tQyNvhr8IYDgFYjmD2xcny8z4Qd6uIncBJDJZbRdUkDpffxuQ3rcTywmFXgB+dGYvSkntWDJl1LL8Le1J/FCVvxkK7Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM3PR10MB7969.namprd10.prod.outlook.com (2603:10b6:0:45::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 8 Apr
 2024 14:32:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 14:32:15 +0000
To: John David Anglin <dave.anglin@bell.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Broken Domain Validation in 6.1.84+
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <450f1fa5-c564-46d6-8066-9becc5091d5a@bell.net> (John David
	Anglin's message of "Mon, 8 Apr 2024 10:17:50 -0400")
Organization: Oracle Corporation
Message-ID: <yq1le5oorjp.fsf@ca-mkp.ca.oracle.com>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
	<d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
	<db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
	<028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
	<cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
	<6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
	<03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
	<yq1wmp9pb0d.fsf@ca-mkp.ca.oracle.com>
	<d04f4358-6c27-46b6-be26-4d42eebc2acc@bell.net>
	<yq1r0fgotqd.fsf@ca-mkp.ca.oracle.com>
	<450f1fa5-c564-46d6-8066-9becc5091d5a@bell.net>
Date: Mon, 08 Apr 2024 10:32:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0028.namprd14.prod.outlook.com
 (2603:10b6:208:23e::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM3PR10MB7969:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	axyLmnrEm4+OELZmbx13jsfKUpn8JpGDFEQDAs3zwgW3PBdmJodid1ChtRV4wQx6oWG1Yo6Uvr51vrI1KmIrrWPWV8HXEGWXS35z4VGgahnci4dfoMQ5GgFr3nsV24z/5uTDTo6F5dSulMmOwKwxoh/MlLvXPN/ORwx2SiNBX+upTTQi+nfLVA7nYFDhxThq43TriHGV4RPsl4Bj+ysn3lBN8UJ7bEYgdh45BL+HhtkzBNEipcJlNzJc4MMrfjFreyaJZ39OXjP2o0xGQ9bZWpojmR9+TlrmYhmbOTmi82IYWHiasitD2sPXNzXlzrGAZax6GXoSEGIJ3fV5GPdx+QUtYblodQU8H1r8VAMi8bhDhfIwd9qFk6JO/67g0uTycftF2hmdfX2PjkS9S87BPApgKNv63OAWXhA5HuCbK7pC9M94ekFsueadBr4CWhWqKCiOpxtFhcCp3LJ3uu5GFmdoeOJ6jJ1YR3pmEhTW82Nb8wnk+9+5slwjTsDBJVVJJ1zzZeCHw8tABi6G0YxNqmiLw+b4DC96ZUOLdP6rU6IbVYLb7+qZhrULK9b4JAvVTAX8MdffQAj8B03vwjt1gJdxBL/GYwxAWee3ETsXVUE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?xtKZLLvKW2XFdm6Fbz9J1T2Ci3Q2+QWfr7j5UOmgZ5K7y3CAb2U/UCv1eyRh?=
 =?us-ascii?Q?c1j7UxQRBH7BJXKB/q79ZAv58Gi5EKVb+S3PPuKwylXvoDahKg+AtH0MJqAe?=
 =?us-ascii?Q?OoAawZ3/js/rpFJmQyesJZTnUyo0soPsPUWYTLlBYzPpqsMwWSs6tofAi/Gk?=
 =?us-ascii?Q?mqbGvrawK19o7gU95wr397WKxNuxOPqhTnutSE/lTMfnxKX99bzxCVNvubeC?=
 =?us-ascii?Q?rymqaEZ37Dp7q+bYLWN2S290v25F+y+p+vFdPagJLqyi3XGhz23twDdc1yRf?=
 =?us-ascii?Q?QYyJaWRVJr0KxH9bRrDm04nLF4lN5H8MuLUaQKFphXXD2CSXQNybJfPC/YTH?=
 =?us-ascii?Q?cCgKYoa6MDbyN1x1s9cH0FUcS8N0TXX5frjctZ76s9110s9v7sa1u5li+BA4?=
 =?us-ascii?Q?njxg9ekXxhu4Voa16kIreCRUvrvB+zcS1vTcvScM6L8tV30icoUFkEyR+wYx?=
 =?us-ascii?Q?2RYGsaHpX1UzAa1CeOQsFkF5cYe54EBE0kmCQ7V9BA6VaV54NTjwOtdi88T3?=
 =?us-ascii?Q?HMx+Q5fOsQ26jWWuKDDMnss4sBezesJar8neh+Hw8Rm4NLpDj6LfHReLrPvt?=
 =?us-ascii?Q?8QVFqd/dwWwHUylJ82C9PhNig7FGQr3cSFnAC3CrCScY0gkVMNjhsFV563he?=
 =?us-ascii?Q?8gW+Ldj7hO4wjQ488UTwodVP+Reeg0N7fmK99uerzF+Uw4bmdSlGagL7ZFeW?=
 =?us-ascii?Q?62R6ZbgoBmJ+bGeCzLIYgX8Y0AMCsoiMso+NSRsfCQRaM60EDhgc+uLgWf60?=
 =?us-ascii?Q?TvRF9TWbvSCwg8OohxUj8nTIMlWPUpZ5gvNqCsZ0PW/AkaGg4LKwyOysZaUu?=
 =?us-ascii?Q?ED+S3IBF96h0z2oHBSITJeExU5n4swT483Pqyetq94VW1qWDUM5mDMYnXfMZ?=
 =?us-ascii?Q?ZfhgBCydPqLAhbTcScF3VapOz4Z1g/OC3pQqjyjOvojqAFEXl52BzK4t5/ql?=
 =?us-ascii?Q?rSWQAZqHsUze2aAsE5HkR4kRpWtvzpUam9WWrFUUOJpVX1tD/ZU3A6WEqAGZ?=
 =?us-ascii?Q?bIjlItLH3Ie+os7iPbIEmsovJecyBK+T1WDmAPPp/mq2Z+Mtu+yrs58NYRwt?=
 =?us-ascii?Q?efDr1SRU8XXRP9jndgOFmOKZbQQ9A4FkBheLHOrLK27nmhrVce/aR9W0cKIJ?=
 =?us-ascii?Q?x2el4XjZ+jRsAyPjc4KGQuQSh2vHEtCGrBXloRDfdceOYl4o/uUpn7pIyw2r?=
 =?us-ascii?Q?2+ATH2WvPZMCYo5GTOR4VJmg0LXd9SlLqUV5DKjCqWBkSKa43aVa2oWgPSlw?=
 =?us-ascii?Q?E3Kj3HSonT8DBVhr9zW6+TNY/Goe/CLOck8Ugs34NrjrRKI+kIzGRxL91G7f?=
 =?us-ascii?Q?UtN2TnPMksF4oUH2j8oFYri09/SiRCQ99Y4qg/CQWZ5ICZGuD/TrSr/I24z1?=
 =?us-ascii?Q?I3pnuWvmYfNSRW8PQ3h87JxAmHX0/aGCQGdXlWYQQbPRoyVkGrI23d6M2Wxl?=
 =?us-ascii?Q?PDm0quweoxgNnVncDqIZtd+dq60kMFTyvl4uW0zHbuYaDwSRD2cGtS61mx5H?=
 =?us-ascii?Q?gs9NxNIwG5mxOLlXjr/kh0miVPpI/KZjpYvekHHCNlHM+broeEKdOKvGab23?=
 =?us-ascii?Q?5i9q2wZwTxmuXvRRh+oke0RC9FAXDTA/Pb5hHnTkwCuYhNLJu2wQxSnRCf4/?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UaIQAgzUwUrP6UoMIsGXDfcc5Woth1vsZ16NuKEL1BKk7wwR/OtZrW0EwshW+UhZaNhEiKAAMTQkUG5wV8E0h4u1o62cHG51dGhWLw0KXl0I5EaAgGjEeSDqUUXcN0n2PpZ1bJxuznKznYJ+kjgZD/kI9sEfdH69NmSwyMhvz+mP4DLI3SXvHZmkO2uk/wxDqx014gWESR/ytBucoZjIhkfXQAicnnm+dJezVZqZtnnSWYDtaL5jP1R/VpXmIsCQazzhV31Ef18Twu9b7Tx0cu3JvDGIydNSr1PFaa1Ij24ohkmvsSZnMNN4f8H1p2JM0/cxpP5FKCDBUYYJHt3dhvr24x5aaA056BukQRzbIJ1xUd95aaYxy1fVu1mLTj3LKVIqXT0dtJ03el9wU0F+1S/WWywZIOlVs7EVGS/GRUohziWG0iEkYPQjsd8mIlxfxtDIioMMG177Z1xd0wEe0tIbWiJNxL0Ra+YCnVoGR/ofglLd+2rE1bANiI3K8YV8MltjtldJar94M03BtYvOZaQ/pbCCEfEbFwntjhoxkc7aufmLUmYdCvSdFlrj9H+ISjQXjmK8HCUdZs07htGPOVtxn3+dKxOePIsq/wO7Nk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0606d8de-1171-4287-c283-08dc57d8af84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 14:32:14.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+6fzytntcWVjTzPdWvQf5Zd/1Th8gmSlseS+rFxNF4lPbBfE8F3R0ayV5cStKDzMOD+ADp5BSx46WZ2WWWEnxSTUDocdM9ABVYP6epV014=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_13,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=868 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080112
X-Proofpoint-GUID: fNcAbMvdj0vNkERNU-FLlTYe2QcQHErj
X-Proofpoint-ORIG-GUID: fNcAbMvdj0vNkERNU-FLlTYe2QcQHErj


> The patch I received by mail was in html format and wasn't installable
> by simply saving message. So, I used link in message.
>
> I see I can change view of mail to plain text. Maybe I can copy the
> plain text view to a patch file.

Peculiar. You can grab the raw mail from lore:

https://lore.kernel.org/linux-scsi/yq1wmp9pb0d.fsf@ca-mkp.ca.oracle.com/raw

-- 
Martin K. Petersen	Oracle Linux Engineering
