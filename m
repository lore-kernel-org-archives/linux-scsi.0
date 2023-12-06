Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ntlRajUh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o2iDdhvX"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892EE18D
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 18:34:06 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xvG9020114;
	Wed, 6 Dec 2023 02:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Fri06YE+4FG5AWKvZwKX1pa47IrpphFH14ffN/mbRO4=;
 b=ntlRajUhkAklVNco+U41BqpdAwrKnIuffcC5wXRjdbEVrBGI3mtSYdONJrtEXUrfTT3p
 SOZB7mVvtK2t6NfLfoHHFfZed+NLvf8myMJbYZFM5pb8KyufJsuCugbiOH9mfkbis4W8
 fuIRqfhyswFaTTBcz09VjeWVHMET2NkyFPKshwJaOcNRaLWGw8hfrmAXwtSqhMp/P5ka
 szpWqf0/CMd6tckVE1GmDlXfm7OvqTa4NIF36B9a1o3Nu6dglAEtzzr8c5ZUf0uLIg4p
 AGubr8YQpUFSSlgZdeLlzGSLTLB/dtKvKOvjcoEbaYVgxaHoJESN/cGny2UkQeWOX/Jm tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utd1g871g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:33:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62SQMr032374;
	Wed, 6 Dec 2023 02:33:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utan8d3ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 02:33:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LU8cQO7fVHn2zsCFlpEQkJYjr1SnTJEc6D9P3YfeizPqF7FTlJx8SgQOdFvBj4bE2L7On2C9O8rE6JNgHHewTzRVHxVQChyqR7yANwFyAF+V766XLnPwNDD4pWvA9AnbHiaOBoTfi4c5a4HFPqwtTJwgijj7xYzNHZ6CYhhXqZck0kFv0tJc4FY/h5WFmmF40DtjggGniZE/23cp3ZjU5/eQ2N9QEsy7w4XMj82JbZNS9mDHPQMhIrAqrVKNV3IcrpZDiMycTuVve45JBjGhiSt8no5zj6KBZogDAPDHuMj0z4rLQ/kGoz1seTIo7qyc/FxqTVRJqzP5qU+5l0I3/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fri06YE+4FG5AWKvZwKX1pa47IrpphFH14ffN/mbRO4=;
 b=huoLqhEh4aMJHDLrBdvPUO/+/TfUiRfMQCKXL34j1u2QLLfe5JJvALr8i0qFgtBqXUR3DoQQ9NZxg3/BRC7Wu4Y+EJz8R0hpO2iUSNUKFaw7mxmUsWDTRqYqGMiBES1CsmsdfOy+yeT/zU/Z01zm65CfLlq+f25ytd8+5p+7c6ySAH6l+J2JzV3DOI8++Iza8sKMT6DFbAAFJhR4KZUv3UTpbB5Le1qN1BcTQ+YoLE28EfkQmaRRnHw+SpUUD5Ux0GEij7vAdGjxTp6SSPSSfj52TtX9Q20msbvfiiA6hC2gO3Cm6fe6XMTI3brIrgo1BBlfZnB6TvJpAU2Ik6BbrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fri06YE+4FG5AWKvZwKX1pa47IrpphFH14ffN/mbRO4=;
 b=o2iDdhvXq3VyfOEpfOBmYwSQYIwKBzgxjeC6lfp/0BLQSoOxxhFyYCs6+SoJJkiQjVIAVhFeODMyaqISsN1zHSShmSEUCgPLRahWjTZ/tGredFt6fLAOkMcfE7xRIgZKraf78XWE6UDnOxwQ4x8GaYB//g5rbFzrsJw9SbtplUw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6361.namprd10.prod.outlook.com (2603:10b6:806:26f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.26; Wed, 6 Dec
 2023 02:33:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 02:33:48 +0000
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] libfc: fixup command abort handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0k0m54v.fsf@ca-mkp.ca.oracle.com>
References: <20231129151408.119844-1-hare@suse.de>
Date: Tue, 05 Dec 2023 21:33:44 -0500
In-Reply-To: <20231129151408.119844-1-hare@suse.de> (Hannes Reinecke's message
	of "Wed, 29 Nov 2023 16:14:05 +0100")
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0056.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6361:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6d926a-cc64-48a0-cf60-08dbf603c68f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	WXTZ+bFITR9kCbcEq2DluyfzOPLwc/eyemW8s540WeQ2CnBAhm8ghgH8x3n6tWpX0qRW9qHrZ8lMNKee5wi4TLCCR5IxjBUD1LO/jd3BRxn94q1rf3mwZAGUOVqNRXtSwrBdGh4txG8hTnId/V4zWN6qA0vQdGRwYJCVXc1rSR6ncibgfsq1p34Q+DqwPrcveVlHjEoYrzybQ1cR6blODePyijmJ9FO+f+6zQ0jBHAc72IBiiceU6YDQjDwj8RQ9mUzp1khDbPBcSHjPIRuGcTPHX3h7pkzZAnoFwJ5DugyGIDv1MQSYuRLNV4VvgvW6/miPIPAHRg57h2gufAwJlopKkU3OyhuMwHh3/0M6uOap9gs0gQdz8Nds0qkZDV5qmPV7IV7JptVFJ9KcXLhb7SPY9ptzzFoP36KGbEE2TZN6CCQq1Ct14u/BdBfXGvNp+N+EAfo+n6NynUEVNX6u6vbwJS1mrhLafYfMDeAwpXE1XmOtvJDSrDrxSa2BpiFQRvTWHdk+Zdr+iShTR8uHqw5Sjh/vookFpEmG8fr81S2TvyO1PjwTEj/AaM2Mx0Oz0U/O8B08QU86Usjs6+NCJQwED35qqVAHb0uI6yTL2ww=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(366004)(396003)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(66476007)(41300700001)(86362001)(316002)(4744005)(6666004)(5660300002)(2906002)(66946007)(6512007)(6916009)(26005)(6506007)(478600001)(4326008)(66556008)(8936002)(6486002)(38100700002)(54906003)(8676002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?X5zygWCZ7UBztWz3UkhFUkmMg0GVz5KbcbJrf+vFCerSpldp0AYnwQgkA5VB?=
 =?us-ascii?Q?K1sLZD+Z8q60LQVu0U9s5QtWbdheemUC59MCKmov0KtwJ+3s6JYCEypvZ+rr?=
 =?us-ascii?Q?Xs2GaOghydM36syoAig9ciUo/qjq/3dtucxxzUiltPp/QVL7DzZ2o5VLCCmY?=
 =?us-ascii?Q?0hK0DfMSCYrG8dYdbhXqqLVh+gv/kCWFr6BxAG8pILnhB+jyadZLtssMRpAb?=
 =?us-ascii?Q?yaZGtacykPvJ5KDf7EX4qV/me3sSErpJBAw27RosevhV76ykDOu85u6CpmW5?=
 =?us-ascii?Q?wey0VTkNg+OYhHfSx+yPcheiI/c6rVqigkKnLcMS9xOJXwNA98kC9gspMMyh?=
 =?us-ascii?Q?QR7f7qkzd4dFeQVkGZ2iEcx2GpfOd0/0gN+6nQYT1nK5+SmLwj1T1HjFNzl2?=
 =?us-ascii?Q?rzU6t3qd2Soh2QPFhVSmPt3/5PVjn8R4E9JsJWiJcoJr515NuLaAt+OHhJuq?=
 =?us-ascii?Q?DCZG3nIL8U2XpSXc73bDegHeZ1/9w8U/GVBbmA0jbo8HTabbBAykKcTDISzt?=
 =?us-ascii?Q?7tiE6F5nia7hwixsKeW122/pHi2BcMfk4LFKCmkG/opcAJAHH7exgVciAJRw?=
 =?us-ascii?Q?V0CgNsIjziQCyYlNUpVsiOlE5rAnrI6ww16k4cEPF9rbUTWH6LSqU+8UPK0c?=
 =?us-ascii?Q?qQ1mmM6GaknIxx8lDI1j8QcWahul85AZW3KmZ8SJmTkMEBoKPHdlhZVqPs0p?=
 =?us-ascii?Q?0CcJFXRDsxOkiTAIvHAh4RMbUAdOhXNn5YoUyJkkKLBNW6d6XPh2k4+CeCR5?=
 =?us-ascii?Q?JaP5LfzI26QmTo/EQsAOXa5On9k1KfNIuPb63+y6PfllYOO24POXSVR2FMBW?=
 =?us-ascii?Q?V0DuCahJdwUXZH5cWQ6YznX3D1aM4fZ4LeML2szPuMbLz54LWxc80fm0EFbp?=
 =?us-ascii?Q?CvZKubBaSspQucDDM2HMR7xCVnBAhXAj3nqB6QOY7KsWA7r7WYaISacRzljk?=
 =?us-ascii?Q?kM/OoF5rnmv3ym3OL6Nt+40jdNl6n66dqozPus4N4PzxW1cLRqv+RCy4bMS5?=
 =?us-ascii?Q?YWiBKrn4ZMGLgB6fW2/j233O9kD+QnpWjYxRcHzWNhkagVu4+trrvZ9nwndB?=
 =?us-ascii?Q?/GPTCet4eR27DlrzMIuYzyUo6k8YNvFn8OtpwIWJHbjEerg12W65fBaQuxHM?=
 =?us-ascii?Q?clm4MqrWnegHbXrhlFqUAcL0ACSXAQv9pYEU4qtDU6EbfZg84IV8m8ZXfGzl?=
 =?us-ascii?Q?V485cMWMPwx4KTnPjYv4ldocnFXXRlgkdTIX+4CTc78poXkZ7a9OuQexsk6I?=
 =?us-ascii?Q?GT9zGNYbmzP6+qpC5g8/+iqmvP8uj3C7Z/d2rD6Tu1DqJfCksYPHTcRw2wO5?=
 =?us-ascii?Q?gRdcMH8Xuuv9LB3vLolOJOFeqyfrlfwpMfVSaSfw1Tbibig8Dum07NJL9xAo?=
 =?us-ascii?Q?lvdXxC6UXebA2/R8hIileAt/evtHOr8VCaQofh7HDQDnQKCH57S3CnpA/Fz1?=
 =?us-ascii?Q?I3f0kVr8S+3YnGVY9lrc8ecerDTySK7nnI6sgc3JevO0CmoF3+/r57GmbXpq?=
 =?us-ascii?Q?oEe/Bk5ygngH1z/zwPVlmXsqrgwRj2I5Zdn6b4Kx0MXJmvRXLdVDHm6BNxVU?=
 =?us-ascii?Q?Cox9eHO0KGne0QeAlOHAAORrNbDmkPUOI+Q20gmNOtLdcd2uKC9QeAsYpBLc?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Tn5LymKZYy8S8TBDxP05gov3TrRsyRrhjOK05W7bRgyg1pkYx9RAoWxJKaC/6kUDxE0umMNMhjYkFgLvaDkQ+slrsA2ykW9znm3KhAlQzZghhTRqwEwQQKKhI/AlpBv2XxsPNp0R6Rc24QkrRI+/LRyWKDgDImdKdLlgmHm2qig4Y0o591HLIhYUanPdTsCllFuUn/9xixDq4vdUROdu/Xruz8xWohzbmvqoetlUS0Pb7cNbh1mZj2QHJoUlVMcezLg1TrBoYfwxzmttUAgPHVujpVNBtMAiuCUrcXKO+D4PdRzY0UUkdRsxpXP7H/xw/YfaT63FMgYoJa7gSIUwoswKBUbIwSxHfZ086sG9KhSBLERl12ncfP/EfKXdwK2Ef4jUNUNFXgciBHuLOBuZyGF8sRkao9uQihQ4MCUyKhURYaoF54xoWgp5UBy1mCOll8GqnDkoTkUJ6MbRVfdbzrxEGBxGp5zkGPc+aErYj+nOMwEzaJjW2ssULeP7tuRfLAfMO3LdmfuuohdRats1hn3YhtohwfU5T5Sgz2ot1/D16VA/GNJYEVR4rqGA1UhkceuX/lyTAnQnD0+6S0u8tLdcJ0FP96LuuEguKRVngZ7WttwepeKGShiP1lnVoDVme3EtQJ/q2EbKIXbfNxbZmgXgtP8poTjJp0R1+FasNniiY195wYjKPCjNry+HkEZPuRPEYyZtdXA9c6ze/xAanYh5fsfzDSNkGPbvk+poLg8VE6sadDaX1WJGOVvyz00IJgi1zEQntXH43wEwwyzrADGjsElLLZ3psxMEgrlwz541tTDpFzYypNpJ1cWb6RWcmzZsCd32V8Mnvi3UYv1gm9YPq/UgA+w5iuWtZD0v8Dk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6d926a-cc64-48a0-cf60-08dbf603c68f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 02:33:48.0915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUr5KGrMsdfwbgOwgCOWwj+XxCJivbw4qKk104ugyQTKwwwl1futsu6h9wchKaSJ3o+rmAuG9L06htrXmjgDAOFoh2qBnU5QvMnfeH2fmGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312060020
X-Proofpoint-ORIG-GUID: Tk7T8loqk9-h-NB50K9BmrwMDl_RgY0m
X-Proofpoint-GUID: Tk7T8loqk9-h-NB50K9BmrwMDl_RgY0m


Hannes,

> when testing command timeout with the help of XDP I found that
> scsi_try_to_abort_cmd() would always return 'SUCCESS' for FCoE, even
> if no commands could be sent over the wire. Which is not only
> surprising, but also can lead to data corruption as commands were
> never aborted. Root cause was that aborts had been sent twice, once
> from FC error recovery and once from SCSI EH, with the former inducing
> the latter to assume that the command was already aborted.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
