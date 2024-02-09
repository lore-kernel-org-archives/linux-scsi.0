Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D24D1805F;
	Fri,  9 Feb 2024 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707515580; cv=fail; b=Yi7TlqFJ0/9SRi7dHjFihCwyj0IkmpCltv4aGfj43v7623/BiHeYI7SZZh/e/GK0iQOGy7dZUinFJMbbIBX/g3X1FwKiho0UPEvgbOjc3hCQqbc9ewsyjGsV1+SGAqlZqzxpo+QmD6pgTxsX9xRE+ilirsvugG4TzMy6rjseku4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707515580; c=relaxed/simple;
	bh=7t62R8fGhBvDPo+ngm6pQE99kyoSuSyw2PPwnt6EnPM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=SWCn4HD8Oj+ZzJPeZ1Wra6Z/F5Ix1Qilfm/6xdk6ryHqa3Hp+nlJI6qoMT0Wb20jrm/8lni4uaLsFbnb+X+2XAZG+vD2fbMe6myEchZqZLPRVnyF9wU+Z7gOPaK+3bLftbAIqn6wmboW+1L7WLg5LFtrtfIJJeXAPX6eEwnEl0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZD2raBkz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X3Ibj5/B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZD2raBkz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X3Ibj5/B"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 419L3XiU024293;
	Fri, 9 Feb 2024 21:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=vvbdvyECKIF2gjOmYsa7VPJOPOLZTvDiUawZ2BkQFSo=;
 b=ZD2raBkzJITAEsphi1h4eKj/saGjFmHEQzrSzN/+wK6NVOFxnKosw29JOdu7UIY+JFZQ
 RYUiRXDmQITIasEtTJfr65jfiuTnuhXvbAcXpbI9R96dELtzOP3whUJWARW3RAk+kYtz
 Xa4z+GpNsRwgByy51+xsnobl6087lJxeS1amLRksP07/TPQLlqne4l5Ag7GELoQX8lfs
 Y9Z9A2g7baHiB6afxCLRGxyjDPFUvqXgNHvSz/4igI2sQM84H2/SmYj12DM/CzGp+rMR
 0kwfZjFZwIo4BZUSdxjbtlr2APEQgXLOGhHgOQ7XB7vJlsh2K99KdALLJqAhv/9nwwAH yw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w5snr0d05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Feb 2024 21:52:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 419KUrIw036811;
	Fri, 9 Feb 2024 21:52:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxcrm9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Feb 2024 21:52:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6dqJzSppy0qbkD0xtrRDTmjHKH491JzH0G18IRJliyQOBfDzGVQPaD0ZuVfk6KpsZDyiaO8nGjyLwqMN4DQqBxkwPkGUp9fZf5ObqjMthc7yTEhU+LsI1Aaw+/roYmEabKt76H2oV/x7zSOAx4cRFZ4Wa8nIcSe8AzDJmtBbrcFXQABwH7fOpqNatFEB70vqN5LjbrruQJDtdN/ShGp6yYTjs0XkEpjpd1tVkdDhbmhVofVbzjUu48opY4BdtS29WBTNt2WK7OYOMhH2ZJvSYvffqr3EtVfVsWum3nyB0D1rFjCV38SssAU7921ANydy7NPNFhsc/wy5ORTZRWCmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvbdvyECKIF2gjOmYsa7VPJOPOLZTvDiUawZ2BkQFSo=;
 b=M2/i8vpNxMjzsTNk1Abh+1jAspjqxFnMo4FfV/Ir25hatlXzkwJH8q8foNj1+Pea5xnMnsaAJRC5h7LF3vXE/ZNvskd3VGIcbwRkXQiGOGmiHUjhYSDkFZJfsxIVdtiMlGjAfHNCjAUjjqpM1GL21AkskWFMdDhim+BTSD6vvpn+S+qj9GrfbnCwyaoRYDs51civLjqdm3VWiL+ZuAlkD26Cci38dLX7Mxx8xn/uwjfGS6qigeUqWzjfJWtrLgDMqYudpdh0AZQcXDnuCtnkuhLQkb1roAX/OrvNFBO99fUhVLOVESAA0DcBrrsU2QoM5GLCpJzHS2x9/YP3TwMTGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvbdvyECKIF2gjOmYsa7VPJOPOLZTvDiUawZ2BkQFSo=;
 b=X3Ibj5/BfvF6JABDzisIWe/vVEA6rzwvnVeJxVPqzmEytyDOkRGgS8Vo1sW7P3nBcgcK0LwkH3GcUK2ojGjx2juhWRC526jYDZhAKHoo38u51ZfNiGtBZ91cknNafvUH+QEZp46BWqIDsXxycApkclCnVwYX5h1LUYFpkr51DlY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.24; Fri, 9 Feb
 2024 21:52:49 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7249.038; Fri, 9 Feb 2024
 21:52:49 +0000
From: Mike Christie <michael.christie@oracle.com>
To: mlombard@redhat.com, d.bogdanov@yadro.com, me@xecycle.info,
        target-devel@vger.kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/1] scsi: target: Fix unmap setup during configuration
Date: Fri,  9 Feb 2024 15:52:47 -0600
Message-Id: <20240209215247.5213-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH0PR10MB4725:EE_
X-MS-Office365-Filtering-Correlation-Id: 412416bb-405c-4b61-279f-08dc29b97527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PjMjsDCJbbSA234CBYRxu5hcuyI8Jz+WjMdSjcdMJ668VYkuyfHO3OLdflJK/H0z8GTUsdU/+wrLrJOP+x3sYB9OPP7OaMIzuFZni6VSCXBS+lelBvXvxoVCJlw8iIgGYhY/A13l7gIGJsRcrKqTUTYf+MCVfsvHT5rL4+9UYi+J9WiWeMzNiTOhTEWe/zTRYDaIxfOqOX+VsNKv8VxpzCBvaRkutzCNfFVvr1CrPwaoLrjbJPNw115U+WYGjqjJ8ffipsDR9vqV0dnmyXVaa0SiIVUZy2lecUcEOlGiVNcn5zduFWbtDSedfG6e9jrSlaBCvYkhyahKXw8dHEnazwz/Jy/kT6N4j7uoCfQQtATWIIJVae6Zehgc7knSvOMPgz7LEvvcjjNKMlB0EgTytrMETPjZsgRK7NExrjjzo+ahMv5vfC1alwwAnnOED8gpSjLuLNQc8nKb+Eoo7JEHsrTKxxVNu5S6vK3eU5hIKv7323anZnsqUPXQ7AnoGBAsmaHsGIS5rlppMHAD2lmCsE79uBzGQwAHKGe/nHmsqYbPhtunoOIseF2fp7SS333e
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(396003)(376002)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(2906002)(5660300002)(6506007)(66946007)(6486002)(478600001)(86362001)(6512007)(2616005)(1076003)(107886003)(26005)(36756003)(41300700001)(38100700002)(8676002)(66476007)(83380400001)(4326008)(8936002)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?d3NZ3Itri78wDFWgJNhDDZ05fwmhkvQ7aUqYhrhNVV9hJGZHNVwXmZ1bCDMq?=
 =?us-ascii?Q?Cv5l9RhOTiVkodoM/O4WfqBPGlk6bmgrx5d1GNvWwzmIM7T+DtoiiENP3qu8?=
 =?us-ascii?Q?MpUn6KzYOwWkxtmfxBCemiggLOhQUVYDx7RsGF35Jd1ZrWCK9vVamvvmBS0c?=
 =?us-ascii?Q?GROvA+gQpr7R9gHKA4VRtOvjWJhvwERz0s7o+zEwPzQzjqsN6Xrl/4uJLSPE?=
 =?us-ascii?Q?7R5fW3C+SfeCWw9lmgBbVERIFGMIW8LDrnXkTMBQPy9rupxJTCSr7xLNRdJj?=
 =?us-ascii?Q?y6km8haE2RqFVl0sUbDiXHvloInzuKz09MVvQTFxLCGMH5VVe0hHkWTXLruj?=
 =?us-ascii?Q?ooXNoY4GYRvvfefYXusBIcL2B5NfHeCN0XnDPvVrir7All7QXcfmdOkvnzl5?=
 =?us-ascii?Q?vPRlZSmEr6LDryQApQJCpn+X6R6fkiy9slHr60Fxk1aZVTs9un3OW+UVPmSJ?=
 =?us-ascii?Q?wzgIn4nfvYXF3gYYp/h/+/w2xzpGv3GTHEQqBiXS0JnJxDdsIo8ckbyGxUqg?=
 =?us-ascii?Q?65nsgDXyIAXG8fkCtvGrmkrYyZU23f/QjZQQZE6OivDgbuiGkUq/0V3A3foL?=
 =?us-ascii?Q?BvESE89v1QF7xr/Z6EhT3+TFqYpvF4gNpbZHVaytqG83GHAopTBuurGfx1Mk?=
 =?us-ascii?Q?cZsOGt1TXFDOfuBmAIvS0vKeGmXP36VbHlNHR2fSoSZ+kChMRgwNFQzEvspV?=
 =?us-ascii?Q?toaLiuHMJ+OUVjBe50GAHl+DWRRL5yduoK+3yYi5Ffxk32cFQwgcxzki+J5/?=
 =?us-ascii?Q?RmalSYqzNyXmvEzRTvMtB9+7P7FcJUVtVBgGaATCqb0/DHZ8PgSQhO4d1v8W?=
 =?us-ascii?Q?C8awlrj42iWGg6UB2uAwUGu39TLqVK90PnEstOOrLmV5n2+DFV1QxBNvUkCu?=
 =?us-ascii?Q?GjPbE4uuRwjZCQp/Al433gTGryJtGr5u/YeAtbsr8+N7srmpKp5qfdH3iWpl?=
 =?us-ascii?Q?EbvGvygTkRuopiMEgVTS+KeJ03PcMvtuXAO3c1S1DpAFCw4/11Kp9RtU074j?=
 =?us-ascii?Q?ydGTA/6LglgxevReAyYNQmtUCcMfyeWr0auazgISSyAc2cp0JadTvxMY7Mrg?=
 =?us-ascii?Q?ezBQNuejnWCZQBKhrR5Zwt3xC9smVc7vNnpna95e0Fg0Svvm26vWol64VeXb?=
 =?us-ascii?Q?WTh/QKVUBuJtTjojjhckwXOTcUKBAnzCgNCfSU1OXcu7N78HvELR1IJXJD00?=
 =?us-ascii?Q?NSUptG9E4bECa8VvwYOgf9DWYOXUwlgruyOGXcCPGpuhDJ+1WZIw5WnfL56L?=
 =?us-ascii?Q?UxQd2WMOLnouq/yk9Jph1er4N4CL4szXm+rr9TuZjifzK7VEZoT6E9AQwh1r?=
 =?us-ascii?Q?Hfhccx3Vga/GVsbN98i9DBVSOG7YnRdzAx3156HZO5A6i6ug3Zt55CBJWj5F?=
 =?us-ascii?Q?sotlEQ16bjKAFqbSGudYzjzYmkkqC8FOA7FAsYIjMASc1kD5+8lx/PG6XnJi?=
 =?us-ascii?Q?/q3JM3w0V28Sf4SOuD34x/ZNeOgs7pst8JtQDKTFB40zyiOeTWmwPxoJ2fz4?=
 =?us-ascii?Q?8xH1KEJ24VoFVOiSM8r0FcdNo+MvZDA/VneD36nNeT7cBh8gOzomZzOffl7Z?=
 =?us-ascii?Q?UCr5lryx8g0Qh095MjNh6zARAD4LSmH+f5D7zmyT6Fjsf5xAu9PkwVsxAtdZ?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YUbKwdifyAtL9rCfn+q4yF2b+80VujLh73caqSCaljmC5ONncBNrJmXuoV5IKddzvAbpswNPmd6vJewCEhknd1kO94u7Fz+oOPKCjND7NAENqMXFZcuwvUqdaSvlzqzuRQQ9HO31LFMMUzkqC8UhfHfjbvYg40++B+wJuQkUKjPsknrj2nySncGqrpjFlbC96Kd3njG+aG/hYr7dUOUrUUQnxgm+ASzlu1W56IxNA/oOu34m+eGxXxXuEuJmMAQWRKtCqNFrut0LzESV+kQyc9UpIi8ztlveBS2EWiv/N5A7CByaFaT1YlrwhM1Mxda2VYD6zQMSzE6LMaHR4iUUhFU09pwn44NObMLgTlkp8vd2o5/0D7Av7hhde+bA9ixZVeGZf55+M4oUlMCLAuvDLjwOJe+R4GFxN9bJfAJNEFzPsCkiLnWcJDUtpNKjTN668hKTVdJyeR+5EetHhXyBtkwJpYOS717EvlSpW411GojFNTQUCKb2v+EcRdPskALmjiPid1em80zic0xNyUPl5bC/CRaI12243ihw2V0zDduxHE8VNElYeaF009QNkITovMKgUcQ3a//bE9FYIh5iP+x6JJCDN5jWhszRyEbJyEA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412416bb-405c-4b61-279f-08dc29b97527
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2024 21:52:49.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYfBRrGkXJpnb6LWAM6KxhvF16U99lq1t+RDpEcbcs2gxPC7SsTZX2ggs5GA/s1VOkhtT0OoEZNn+LiXnDNnr4B3sCaieC9K2zMVuFrXhjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-09_18,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402090160
X-Proofpoint-ORIG-GUID: nTRAXQwDL3Nzi6jmVadtSs4LpISL-Rf0
X-Proofpoint-GUID: nTRAXQwDL3Nzi6jmVadtSs4LpISL-Rf0

This issue was found and also debugged by Carl Lei <me@xecycle.info>.

If the device is not enabled, iblock/file will have not setup their
se_device to bdev/file mappings. If a user tries to config the unmap
settings at this time, we will then crash trying to access a NULL
pointer where the bdev/file should be.

This patch adds a check to make sure the device is configured before
we try to call the configure_unmap callout.

Fixes: 34bd1dcacf0d ("scsi: target: Detect UNMAP support post configuration")
Reported-by: Carl Lei <me@xecycle.info>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

v2: Fix missing configure_unmap handling so failure is returned.

 drivers/target/target_core_configfs.c | 48 ++++++++++++++++++---------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f58988130a..c1fbcdd16182 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -759,6 +759,29 @@ static ssize_t emulate_tas_store(struct config_item *item,
 	return count;
 }
 
+static int target_try_configure_unmap(struct se_device *dev,
+				      const char *config_opt)
+{
+	if (!dev->transport->configure_unmap) {
+		pr_err("Generic Block Discard not supported\n");
+		return -ENOSYS;
+	}
+
+	if (!target_dev_configured(dev)) {
+		pr_err("Generic Block Discard setup for %s requires device to be configured\n",
+		       config_opt);
+		return -ENODEV;
+	}
+
+	if (!dev->transport->configure_unmap(dev)) {
+		pr_err("Generic Block Discard setup for %s failed\n",
+		       config_opt);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 static ssize_t emulate_tpu_store(struct config_item *item,
 		const char *page, size_t count)
 {
@@ -776,11 +799,9 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		if (!dev->transport->configure_unmap ||
-		    !dev->transport->configure_unmap(dev)) {
-			pr_err("Generic Block Discard not supported\n");
-			return -ENOSYS;
-		}
+		ret = target_try_configure_unmap(dev, "emulate_tpu");
+		if (ret)
+			return ret;
 	}
 
 	da->emulate_tpu = flag;
@@ -806,11 +827,9 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		if (!dev->transport->configure_unmap ||
-		    !dev->transport->configure_unmap(dev)) {
-			pr_err("Generic Block Discard not supported\n");
-			return -ENOSYS;
-		}
+		ret = target_try_configure_unmap(dev, "emulate_tpws");
+		if (ret)
+			return ret;
 	}
 
 	da->emulate_tpws = flag;
@@ -1022,12 +1041,9 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 	 * Discard supported is detected iblock_configure_device().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		if (!dev->transport->configure_unmap ||
-		    !dev->transport->configure_unmap(dev)) {
-			pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set because max_unmap_block_desc_count is zero\n",
-			       da->da_dev);
-			return -ENOSYS;
-		}
+		ret = target_try_configure_unmap(dev, "unmap_zeroes_data");
+		if (ret)
+			return ret;
 	}
 	da->unmap_zeroes_data = flag;
 	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
-- 
2.34.1

