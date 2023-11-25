Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EwXJJlBd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z2r1kv4H"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050E2172E
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 16:18:24 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AONs6lM015861;
	Sat, 25 Nov 2023 00:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=p0UDICRN129Q/JqWZWs0TsY/dAPUOVQg44g7PUE7QtA=;
 b=EwXJJlBd6oLRR+m10QW5qfAMCre5vTXHc3MIBP/M07i4S5ydzRZnZqlZadJyeyHcGnbN
 W0Qnp3VsFs8kBoBNc8UOzv8rf2o97JCrrwZ3E0zD768CFAnDvkK8LdpObODkAQUIoaHa
 PDIip1AQHx1d7J2EZuBFq7tUBaadZG0D4IPZ7rFtOiIvcTVG/xRCOK7t0J5TXVEQJ2U2
 VCPbUUNRqlKY5qL0sUG74C8oWTX4vr+1oCks0n9khWSZivK7kV16UtMI3+dVrSv0bvOI
 68rp4XvOCeME9SQhE+wLXlxeIKWbbsGHqUmd/dXrUXY7slmkeycF7bj2PL66WM7oZo5E Vg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uemvukxb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:18:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AONuPEQ007327;
	Sat, 25 Nov 2023 00:18:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekqc4yt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 00:18:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KA7u9KoWFX6dnFOvmbfW/7I+GsbXSfzuFf1e6wAf39/wRweRvqtchrAFf04E3R/p2WC25Rvkl1YUCPtw06e9BdhseDRAd7Vn8D96aGfZhPA+Z7pzsaD6qXoSuLG2SNf2SLUkgmZHhMzxrNdeJuFgPv0QtsCDYE3YOKaKdPQliPojrPLrjMGYN2d7qe03eHS89C+bdAJ5iLP/9piff/vigLw2AYQUQWL0QZcrA8TUmPv4tzQ0ffbj2AJGuLLtmLckf3545J6Bo7faXu/fzWSXT0J8hPhDvqNpzNopeQzGGjLFQPwHe//5xQh+C7ciECFTAGEsp7MJTKX4IeOB2JX+ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0UDICRN129Q/JqWZWs0TsY/dAPUOVQg44g7PUE7QtA=;
 b=mAJicZ86DhOLafTxIY6OKFZAT5iOEZRI/DNWyaCTyXQHxVbYpLmaDRdDxtYYwvHlBPNZhbTxyC00BUfDXERFho00KOvWU4S0J3w/K3hitKV5Yg5Lu6sm0qfOUVkntQGLWP9TAlJ+EoErl6ZWsJDPXspz7zhiHvzpDlz2pVE6YketrIHhhIDrBm2qiRXPoaEyKOihCTTVtbzKNgSvdLEMADd83WSckdZODfmx3NqXlH9b6bF4xax1naIzsGM6YLml+0OsQVzo3x0cl0t83UUTOl5DyTM3W55CUG7jOUjYnNc4tqZwFY9hPAha/pY/yMNkhpx33PmqE5JBauaNu0qgKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0UDICRN129Q/JqWZWs0TsY/dAPUOVQg44g7PUE7QtA=;
 b=Z2r1kv4HQ5bz81kAVCD+xGa5jb/83unbHi57NeXhSYbtXeg8prQZIEl0RYXLaZazjNMs0hnMiC6xNOy1stKOGFipEZFkZQ1FyypKkPlVL8qM4bixlyXVQMYaVrj0PQywBFlM7NX2JIiB9ltirKET1fOKvz6ZTsCCdGcP5oWyY2s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CYYPR10MB7676.namprd10.prod.outlook.com (2603:10b6:930:bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.21; Sat, 25 Nov
 2023 00:17:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.7025.021; Sat, 25 Nov 2023
 00:17:48 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le
 Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley"
 <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Add a precondition check in scsi_eh_scmd_add()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fs0uvg8m.fsf@ca-mkp.ca.oracle.com>
References: <20231115193343.2262013-1-bvanassche@acm.org>
Date: Fri, 24 Nov 2023 19:17:43 -0500
In-Reply-To: <20231115193343.2262013-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 15 Nov 2023 11:33:43 -0800")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0160.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CYYPR10MB7676:EE_
X-MS-Office365-Filtering-Correlation-Id: 669845f3-c938-410c-692e-08dbed4bf436
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	U4HquXkrAYNR1j3UsaQwtLx61J7UYlg/PvrDSzLJXTzdni0F5Wj54RzkP0FxfaBzMw1pMpPomfrMb7J/0WfuiuwNcxONahxfni0gKgLtBo8b7tD0vEsl4aZ8ks7EZXymPuab1oSV8cvco9hpdsb0lyh1RGA8M84MBNrcSUy4MstFO2FrejqA95EMKID4rb4aM3zHAp2HUKMkCnR7voJvTM9G/p+nppbIiR8mhC3samAdEqlmxzx8L24DHF0EyLF6j0tvj5g350R6oxjCbidzl3MV0Q5xfNPXyFcG1ymXTIqd8Bac4VjdlmqxIWbGypsZ5b6RpqLuHH2o3i1sF1se5jEREArYiNxQqp5wMTf/e8pJUoStScWPldihiQ1U942yusSl2EV2whRtQOvlUvv8J1l961CWg4ocaPLzVMVQ/KeZp8AM1JqJ48zIBy2cNjAi5d3O9/XlWl+VoGS+1eSMY7/ytinVD3rScTRu4bRMxM+be4wQw434IXmlIe9H9NM+/WfeNX0XXfHBo5uQapupNFIZBgjSOaRAiDKxlXzHyVr6jNWjrgZuu/Ls/OucEc9h
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(376002)(39860400002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(38100700002)(316002)(54906003)(6916009)(4326008)(66476007)(66556008)(66946007)(86362001)(5660300002)(6512007)(26005)(8676002)(2906002)(8936002)(4744005)(6666004)(6506007)(36916002)(41300700001)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?78yC1hGgaDSHrGAno1LAzWS8vAhB2oBOjFlRwi+lwbQsuTbQp+hcF1WvLmN1?=
 =?us-ascii?Q?4Oa7XdAtAUhy7Bd/ZWFGnpS7tkGbugKACXxWvjj4kLqGvyytI2tA3lMoTsNK?=
 =?us-ascii?Q?Kz9fDW/dbLxR7CpU5KMF1jbZQrNsG3WjYcHSLAQWeTBaLhH8IJfcRxg8Gf52?=
 =?us-ascii?Q?AxkqXmDokO37S2gxA28ZA9AbZFM+v4XtKQRxrsV2VHyfY59o6oadi9QV58Ks?=
 =?us-ascii?Q?AEsUn2zIY32VDUz4QCHv4k1o9AzVLhaPZG6bAqSUnP6UDBLRcPPmX8/UNFh0?=
 =?us-ascii?Q?sywY5QneqfEawEu8R+1IZppF6K5cJxbZM6j+GkNxAh8k7DnQFXQw6PtuM3uy?=
 =?us-ascii?Q?EKZ/fikJB5P+bMYVIR1qJ8HOxjU+M3M4EOY87L2HnZHUZKXlOEs5Lm2LDsTc?=
 =?us-ascii?Q?LMFAVs/MvoDsSaOBaE8er5APlyZPByIuDytpbJfqJ1inLzxKdd1+FBNB/oyn?=
 =?us-ascii?Q?b85Dw4s/w6O+Wwvgj2tc92aL4Q4VA7vfZLjmQPk1zGJC770uY53hInGzj4Fw?=
 =?us-ascii?Q?AbUsGP28p5gAIVP6sSgIM5RkjgoXnC1zrKoE/YEQPViPhg5sp5FaE61ovuUJ?=
 =?us-ascii?Q?st1GBRijmi+eJh2todK41Q/5LlGMOMW8c7IhgMPKVarp8nMtV1WQi3VvwcrI?=
 =?us-ascii?Q?8+T6CEj9BTWSBXop0uG3L+H4ePDEj5RMezdVBLCKPBpJDRkxJdJF3nYZ90T9?=
 =?us-ascii?Q?wjabKgikDaPuQ7bltQ3NI1SYQW5jXm+/AyOI0ZW49IYExWNlsjt8TbqmMmos?=
 =?us-ascii?Q?Txvie95rmkPzq6ECs4Kbf9CclTeIPjle6UFtNy/gVM9/xT6vnuBpkM8gMxcn?=
 =?us-ascii?Q?ZG63rzrdN8r6Avhbmaqu88yrbxMxwTGaeZ3M5TzsOt+I/lZ9EyBb9ix7ofQg?=
 =?us-ascii?Q?P8MU2qYI1ESHOAA1COuL/ntdVZYeF2RFsqz4GpwZG9PtjTiOLSE9rfOsDK5I?=
 =?us-ascii?Q?ZeRPIP5xEtUkn058o/rhvHoYC7JRfELFhf3SXLPMWLDeIdsvfcp0fFXqDfEF?=
 =?us-ascii?Q?ntS0XiQc0yp//7ZzSXpzSiSEb5XQWxWtc9dc2QOU8BYiuJLkoy7CEySpSqBk?=
 =?us-ascii?Q?1PuOvuTpb9MR5PmToQg8nVHjMJcf3mORPnVVuNFbpgcrRAvPFWPZkU9r3j1B?=
 =?us-ascii?Q?utHqKkC9sIQ5FgblcVdNhtzF7OC44LV9cdvYXVY/k42E0r8z6aSaIonT5J/6?=
 =?us-ascii?Q?//GjU8yB/7KSU/smdF9d8dq4LxuSR4cBt0XeDGEmoKBgVgJ7mb4hlwvpGCEf?=
 =?us-ascii?Q?EiCZFsp3kyGVcZx3mNIXnJqi1ZSgiQYUBn8MoCYNF4on8GiFVx5hveqoRCTc?=
 =?us-ascii?Q?Ukg/MVRUIoRFx6/60qBCWdGFMwqNeaE1uGRkWRbRXv+ES+NWVv83ssemOW5Q?=
 =?us-ascii?Q?ruD+a+C6S3iE1okoKWzfk1qZQncs5uR890klBiiVJUIBvQFzexBTmBq5BPQD?=
 =?us-ascii?Q?L9Xs9Gy++XH+Wcj7VyIVXIHkK9s817iH6Jfl3L02MG12TG95rC2kKVsYXct5?=
 =?us-ascii?Q?xks/X/BwZjeg21ywllvzIR2PY6Njwvrfd/8AUcztDQyxOuOkt1VNXuJznmpd?=
 =?us-ascii?Q?1Gh34ocj6mq37T762Hjp2/s3iCusO+3ztb/ZHsrwK/OF0BOJp9AhlAJREP2Q?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Tx5GXCeIDHZGU0sRj96+w6eo/+fkz3CF3EjOQYBzivf1EB6KzObbWOnpYk7TccoLoL+1/Mda7/CEZ5dfvnSqgxAGoB76WByqmZ5JB0NT7lBUH5rlnhpgfQFvmySwahoUN/90oH000GvYKdpjNx7v7D2Ndrs9ulcfiyqaILvTPRB3gJqeVxZiQl31nzrfTf+020qhgojNvtmBmOU3SqkS6ycFzSd85PF26qKaaTI/k4LkBvcvQUVefGbEyN5DUYKKxucGf7abp/pGBrryil5Hl3Shz6FU/IQ/9hM2P/lIPo1vgK3gvKndLd3fY9DKObA/53cBXA/JpdqePRAIfKP9aYpQXZH/n+7SmKlPgCaEwcH4t/qMmfGHEkz+jjFdyuabd2nYSpT6zc0/hRurOq0CK/s+jGK5TtPFe1no3kAnlEjBvSknlzidu3QXJ6rxvQE7THmkUlkUmlvlHSmbMZJzSwa/loGXdAQygJTyXBtgUlJTVaBLlsr4qkSkuDmd7CymCEP5BkYuZ1bEE89P5DWNzTIFZyvSwx7YxHYozrft3d2Y3xURhRB2AFlaRn/HPwJ/2ES9N5u94I7lIiMm/yI6/1pCxJb6EVByO7L8JT/Hfan5ZCniU9pJYVE5yVUmUG/JZgLjs5BppV0jSqeDsiaEGuqk/9GqjD9uXI5Yo590xL87nHWLp+aT2W4fqctWAumzRGmvKxOqcT2ARScD6QNYyRKtsm6Aj/x2c+s0P4jwAPB8hA0lAmzFTXqOvctH7L8EEHcwqThw4QdKxr8XSPXykre6u4fhPYq07szivihqsD6xywJUK+CbZCnak4ZCiOSOr/CIjK/8hYOp3838oRI/a/ot/vg78wpkErh906q1xQ0HZL3U0yprvek7E2lRiQAIZToy9mX01nBeTlG8H5wkukWu9o7zYBonlS0a/8PI2dM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669845f3-c938-410c-692e-08dbed4bf436
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2023 00:17:47.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sPK6AsGD4lvNBrEvRJf+4v5y37Lt4zeUWX5todM9vDqQXzdXcKJW2C+Vjqi0YtarYazdWnRU4ad6xxUU3M6yvPizBaP0Afn7OpqNHKO2l04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-24_10,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=960 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311250001
X-Proofpoint-GUID: kjXloZxbR9j-q8xvGssx8Uu0zQebpD0s
X-Proofpoint-ORIG-GUID: kjXloZxbR9j-q8xvGssx8Uu0zQebpD0s


Bart,

> Calling scsi_eh_scmd_add() may cause the error handler never to be
> woken up because this may result in shost->host_failed to become
> larger than scsi_host_busy(shost). Hence complain if
> scsi_eh_scmd_add() is called after SCMD_STATE_INFLIGHT has been
> cleared.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
