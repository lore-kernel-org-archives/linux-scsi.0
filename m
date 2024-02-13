Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B996A5FBA2;
	Tue, 13 Feb 2024 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707844204; cv=fail; b=POUPAckxhzD/klkQgVEoYeiTcQIgnf9CEvEH7AXkzoWiuR07WzG1gBP220AiVFqHjmAPMOwTyqMo89/YUdeE9Nz009xLvGHj4SpfgRCsaVLk97v6YIblVgWPhBVYtwGon0MzDoG7LaiM8QCpz+P/LyKBUoZQ2/s/sq78qhT6OBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707844204; c=relaxed/simple;
	bh=v8KqG+RAANVCzxRb0K66X4tdPlm1UbxDD9uye02rJk4=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=MI3QGy4BwlCVDq54wIIo3SQA/sPOaYuU3rZeViltCMKZbBzCpOK7pkoX8NC5pr8qJMyfa7QBE4513SyTRkRV1kLd/CkUKrz/sVl9vNmKoj7+fbfu6LtGOqST8HTLAJL+E9H+Y1aBou/CGE5FiuXsyHyKZ+0IEq9YZTaDRnax03Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QqRx57LV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EXh3nWTv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QqRx57LV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EXh3nWTv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41DH6vs8002508;
	Tue, 13 Feb 2024 17:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=E8U4FPYBpEnt3D6t1mwcD9Sn9C/hT0nGdgnL1WxOXw4=;
 b=QqRx57LVHS5qV38vFSMlSTOXBLNrpI/GaTIUxrLB4UC1OlxjpMUX6U8wCYmy1vsJUMB4
 uNBp/4wyRQU5I5uq5bu75g7uZmEzaDzTwRsAgTaKrXaWaL0k7bFJ3I4VlOOffEQgvO1B
 xVXQ8ofgbIBVDm0clGppEhB1Bzg/Dt0u6h6G4RaiK8Rsug4fBlg1FJfBMzqJVZoRxoJq
 s7/HGH4+/03GDpDOY2N8R/XzOWVEGSG4WKEEYvWinUd93ffItXfpdP+p8WDWZBCHz9EQ
 Ey/cx8hjQxZbDcScW72AKBYpbNjcj8xEoFm4nIYoWujtsOXvDMAUxbep6D46WIUe09Tm yA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w8chng09v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 17:09:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41DGBqBP024602;
	Tue, 13 Feb 2024 17:09:49 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykdx2p9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 17:09:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1OAeMEf7LX+HSbKs6nrZc545p5+JkyOOXNiVn049bDrsu9NisQcpU0YylQhiz2EleaBp9lPzubpPf71TQzrA+potVkEeP1+XVIgb55qkC4LIsLbxdddIg7aZVD0gqCoFiCp30c1h0qQC64mdvXk0b9fVyfNs4P9MqbUsr5ICzuU4NPLy9lbSEaDmFfPhLX/H2JGZ4SLU//nnov2aUZxHEaTFyuINgyh3e0Sb15hsKzZTMav6xJyErfcWEt4BKN4zTTEnDYqz540zldpUOiG9c6OxFSLMz/OwaQjU96f+h4M+GdsjVxIeCJzJXP2qwI11cSpsBffK06YGQPoFjaBoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8U4FPYBpEnt3D6t1mwcD9Sn9C/hT0nGdgnL1WxOXw4=;
 b=cbtBhXCGbfrC8lqC85nMl09mKbnWiYTfuu12oo/Vl/AEyj6yOqvE/DonhNAx7704lPc5wvD6w/2ZZvmo9roqfWlnEDrkWW/muNkBuIT/toLtDIqZVT55hMxIrfzAvPYeaoRJlQKWDRI7tJoMW14YV1qRqWP6aAt+brqJ5r2D4fX//A3KBE39+ys2+9nYkXVnvkt8EMhf2BRxKPEfac0s9wx8uXcEjT8CguQPF+l6iRQrZrmsCOWGW43ecuhYvYU5RDuBFldhxOKLY98X8WMnokD/ad5QncovNiVHZDTATqMiW2bkP2JzgsgyWOw46xZFb4YHMUFmaHprgzxJWe3xAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8U4FPYBpEnt3D6t1mwcD9Sn9C/hT0nGdgnL1WxOXw4=;
 b=EXh3nWTvAO0LPN1Bq2vF05/YZitWqZQXhysltn/axLlm9bGIf6eACqea5glKOm6aRY8HJ2TlLjaDZwdcERnXysIXo+gwWXfRILP9UONb33n3bku5PkBfc3i9ZidfQ7Fpq4/eMkFQx/rySSlupqQzIcUn/3ImFz2cEncmT90CHiA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39; Tue, 13 Feb
 2024 17:09:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79%4]) with mapi id 15.20.7270.036; Tue, 13 Feb 2024
 17:09:47 +0000
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        belegdol@gmail.com, stable@vger.kernel.org,
        Tasos Sahanidis
 <tasos@tasossah.com>
Subject: Re: [PATCH] scsi: sd: usb_storage: uas: Access media prior to
 querying device properties
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zfw4jof4.fsf@ca-mkp.ca.oracle.com>
References: <20240213143306.2194237-1-martin.petersen@oracle.com>
	<d8f04b97-f13b-4dbc-af18-2953eebfa4e8@rowland.harvard.edu>
Date: Tue, 13 Feb 2024 12:09:45 -0500
In-Reply-To: <d8f04b97-f13b-4dbc-af18-2953eebfa4e8@rowland.harvard.edu> (Alan
	Stern's message of "Tue, 13 Feb 2024 11:33:14 -0500")
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4694:EE_
X-MS-Office365-Filtering-Correlation-Id: a3c39128-a8c6-4ca4-61f2-08dc2cb694e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	HiQEWL2iil3l02HNfdxU1KwQZGCPRpuyjBYgT96a97Y0819XA0IfdrP5govqivxSoKPk7yhQSLHlB8FK69XMFK4d5tdSdWf9tn0dzfe9pMug25eR3BhqVvN+OUtra022cjv07ZiX6y8o9GGFiUtpfByUpyHm91udz96JAD3reZ359nEIMtiOhQTzh3hhqnG0aiIqiFfAdAlCWHTnpX0sS3X8W4pVcgz7A8Sg4SOr/eLeqvVa3drDCyEVUZh6AIYwyasWJdoSe0ux/swsmqRkLL9CcSBZlhzF3L8ikPviYD8Du14lSvFFDISrag4g8o5S3soioyJyUrkMJn+pgB5r7H/sejUUZVi1uzB9gIZ0QgfO3pWDhDDR99VRKdCZ8sccfMM+MR8eX7+wJDtrZNbFhYSz+0jiKLqOEGqIQgw9Cnonf+/WZvVRIuqEnZvqrz5dDOZxXcvWXuKtjo4OMrRgCM7vIjzWmAF/9LV01hJMrHQq7R9pu5gi4P7DqFjM2CGzjL01xEWnyXwyh15B3otq27yEZ8pGUyoPfZ0cwkhOpXv259gvxs7y/Ou95IXoZevW
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(39860400002)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(66556008)(66476007)(8936002)(8676002)(66946007)(5660300002)(4744005)(6916009)(4326008)(2906002)(86362001)(38100700002)(83380400001)(478600001)(54906003)(6512007)(36916002)(6506007)(316002)(6486002)(41300700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UWOYna6Vlwdf0/9+fiMV3RPlLZxNcWLDIOB0M3AzOMSCPb12PDgr11vSSDy7?=
 =?us-ascii?Q?TESo0p/ewBtTxGhM4hpSDm64cDIU/R0TGLPLNeJYVDCXgVma3qQzSSjIXSgX?=
 =?us-ascii?Q?rIitu2Py2w09rX9QTy1UzsUaQEIUhYKGxQk1RxFHl766ngwi31hx0fkH8dql?=
 =?us-ascii?Q?ckrdKbyefWlP937oE93sUrIKTZO8Pwq1N4XZbkuzb0vqZLpsD9GSjptRp8xS?=
 =?us-ascii?Q?ItAEumtIqKZOlVbCOS4DwaOFPG19/YP2I4/gO6LfcmH0ILNdFCztzQx/rDLn?=
 =?us-ascii?Q?laOBienUdlenzMtDFfWRzjiRe90xAcTz0x5Ts1tkzM2V6ypz1XECFrZqrZV9?=
 =?us-ascii?Q?DbeFa7lEPQnHk4NP6BqjOMAfSXDukjnHHIrMCg/uBgRgWyznkrRNFXPp8kGo?=
 =?us-ascii?Q?ZanDdiIrwaZHle7cIp0yeJ0n3qc937/I+w3fffayN6r39AP4UE5/fVa9aMWy?=
 =?us-ascii?Q?T+DBu9T1mci3bLCZtA05mjcl5fCFRqI+se0DKt2a6F5mKYXSh0F37pYcn4aQ?=
 =?us-ascii?Q?DeZmvs+/oHeC4MrEiTmpUUPvCGEbbuO47fvbRQdT3QRV+FAGTxiG06ldlM3w?=
 =?us-ascii?Q?kP38UjAp4DcZtG2W+FMkm66Tav29rpyzZrS0jdheBlhDCVzm68jy6ezMy2Lc?=
 =?us-ascii?Q?KbgrDtGqG3kvYlzbD1aG4BKIvqDI6Dq8VjvxwEqWtFFyxxO5G+g9tjMwFJpA?=
 =?us-ascii?Q?eQDA3tkJxFbT+GrLmxx3twCxAPGAc9PHgQdQo7sXsd+dpCjlDTUiAgqJcrxh?=
 =?us-ascii?Q?VqbXeN2JmL3MTuaf2QsKebJFcv1CUeUS8aRq3anWjyPorLdZ1mpr7zk1gx7W?=
 =?us-ascii?Q?FptlmDaiNJv9eUR3cFa8OTQDdiV3bek+aYcGBXiwEH/TaWGMvJiGK6qznvMR?=
 =?us-ascii?Q?WwNdBQsrYjIxIcsYT8frSxv8GVl9Jrc07FY1p4FMjxzbok46Nuo/s4MW038C?=
 =?us-ascii?Q?SMKHJ1dHsYgDolMGzIfRwy8P5QBy5sW8z+itSAnEymLbaa1pWYeyib8mof0t?=
 =?us-ascii?Q?VBU6C8sWJxXfH4S1r0zND5knHU/T34NEmfbZayneSsZxTpbduhjntylsRQlZ?=
 =?us-ascii?Q?wL1k8KlX1rsMubgRJ2pdch3fO6ZK7hjomUrKPwaxKc0FRItGRJc4r9sBBtjG?=
 =?us-ascii?Q?wCve4HMRCkzkiP80CTviVpChtWXhzEMMMqBS86wCyEYsz+aVVJ2LMFyg7I+G?=
 =?us-ascii?Q?Vmrhrx3puOb7Sp0vF9t/l7bPKIAQW30qZVZ+kJLufOeRn9tKh9YQzdWuFQ/C?=
 =?us-ascii?Q?fklfdmmfNrzMYamrDHi2rHnPnFN6FIGhJo/XhQV8DuIKvFT4Ter0r6kO5xXv?=
 =?us-ascii?Q?vycYmSVJLYYqeKMx1heFuGVYCR9ugC4KuAHCAn7aPvUCn8o7yU1/Nje2IBks?=
 =?us-ascii?Q?xLcdpB3Zcb+Ik8f6kiODwkEhWCUXjurjs+NsnttVIRDOud0uRTSLHRfkWsAH?=
 =?us-ascii?Q?UIVteZYZ0kAXlujcb9YZKgw401uW8GYllRRYazff7yVzTR7+8gq3FKHeKwyy?=
 =?us-ascii?Q?6CioU6M4CPTxC0ZDn1G88BpNxiVWmvzt19kWW2qFg0Zr2sRus4oSP/rJY9Kh?=
 =?us-ascii?Q?TY/1nBXlEiF9NccwWItsSXMG8/agciTCJMEE+6ZSWCervIMnjA/Hc3NZpsqe?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	O8PKoP7UBL9t6rG9GkAq5zMfJuXtQGZmYUxXQhjxEDafDOUaiUKumAm+3AOBBHDtC7QKjxA5+5F4+DLClr9E8/vb84unDV7CAaKdOaKICGOH20vSLJtfIKPlYPwFPmdm847rFnNGGQF/UEZGMEtkWDjSIl0W1ApGcsAa7Dle5uy0j5xKYwf1yWAuUoRqM+LJyDcWRD2gTPS71GWed/s/ZqJTGd3qM8op4OElS0bcWAlsUO+5QWV3XPXEy7Y+BdeYUL++UXgMSMuTuDE3DHd8VCs9TxGLpZsxu5zHYjDKK7UQ5Y7dSFkyQJEjbxbbXBx4rm2Uz5eJP6AyiyvAKEjeLYK3+mZtR7AYVioWmp5XXyl+JOYkY3xBO8MInPJdyM68G57ymc3JzIRgXnAbVAdR3uoYw4ZwxFtCPTDHByS4i4BR1iyShU+7PP8J3QD0t/688vwHAUu16P0POvFuHIz6FNqDJOsMIjJ4AedjolOB/goQdXuRsqRSUmtttT0mPV88Vhi8blN/40hkYuFj0vGNGtRqss716VPiWYXhBIelIjUHpSUFe947t3SJHQyo5jTPbAWLS7dX4aTYjxlD8r/vDsYUv246YnUHDsjYwa5Sn+I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c39128-a8c6-4ca4-61f2-08dc2cb694e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 17:09:47.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9iv0KXLVrbNLg1tz+uIykPEKQkc3dtOk0oTJYDbuULRklyW3bgN4Ci7R/fcoSU7xiAO4xSQ5H4Y3b6f7hYhfVA8odZDZDsaeLbB+cRLv5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-13_10,2024-02-12_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=723 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402130135
X-Proofpoint-ORIG-GUID: -IA8-Xn7fhrG4QyYPwW2P_Y77k-USSbH
X-Proofpoint-GUID: -IA8-Xn7fhrG4QyYPwW2P_Y77k-USSbH


Hi Alan!

> Do we still claim to support devices that implement only the 6-byte
> commands, not the 10-byte forms?  Or is that now a non-issue?

We have defaulted to 10-byte commands for a long time and the 6-byte
variants are no longer to be found in SCSI SBC-4 and SBC-5. In addition,
most devices now have capacities which exceed what 6-byte commands can
address.

I will not object to adding a fallback to a READ(6) if I receive a bug
report as a result of this change. But I prefer not to perpetuate the
6-byte command special-casing if we can avoid it. Especially if we know
that $OTHER_OS is issuing a READ(10) during discovery.

-- 
Martin K. Petersen	Oracle Linux Engineering
