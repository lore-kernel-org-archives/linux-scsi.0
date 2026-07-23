Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F18439F9F;
	Thu, 23 Jul 2026 09:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799514; cv=fail; b=c3Oa5392BfKsqTUTxZqUpQenQcyL3h0DmQboQBf3n2MDg+JXifPzujdTc3dBTREW0aIi0m4yLJbsrCVedSjh9JMpxcpD9nm0NNV4LOAoASSS0W5ZgDXWTysKt/roqPN/FqJylFlMKCsw0WpfMkII67V+Lm+6npFzqQvYedEWWxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799514; c=relaxed/simple;
	bh=pKmLfBGjiCMoYAz87+yhMiIdx4eBraDihe/ABGgHEwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fsa1V//Jv++aAAnz0tlMsX8xvOCzLGFMvUOdlyJk00gnL+tEMAMCtBzCKOUVApW6K4WPG+wACMgiuyRoJwtGBjyfNDkWpHg9c40bKwFepqKZVJRep2LTEXVAhG/rLPsePb+6Cf/AHHUA5699Ni6OK1R3oqIJca/jGBnW9fp3EhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V8xAncYJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yUDCneqQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V8xAncYJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yUDCneqQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJti0Q3573969;
	Thu, 23 Jul 2026 09:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=K6r8D5Vd/iPH9Klu9jEIAaOBPPjMdBy9AyLVyegbo0U=; b=
	V8xAncYJqdZMN0DYweL4Q+wTe3hRJt4lGXI2twgQG6Ng6K1KlwuuOb2ejOLxlQu+
	ZC9Ne6Ov2W8zb0Et5veYON9WvrVJlBB5+/Iyi03biGGZ2xvzNSn2uafp6VSjSXyK
	IlvCzGlP26dinKfR26bTCfBKHYqCUMOEJaXWVNb4H3ro0tGR3UHZp2zwDDndBqnC
	MgAcqbxho0bIj0cX2uVLIj4kzbLYw6nAxex7i8tjk8FK5gO1xSyAYAyjpXFJffYT
	1mmp9pw0/Jztf/kwLA45j7v+PK4Q5+fxP+EspIg7ARDl3SYOo8hun17Gbtqh4fky
	KU8A04Deedcvfv+bFbujBw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqpqd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XVCH010595;
	Thu, 23 Jul 2026 09:37:30 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxsdeua-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y6sgQODjFiQp2dF7XAwRyd6JYTDad0tnuSfNLeMoBn6dLEgoL0B8chthUqkqsij5UF7FQf0UiqWJJ4T5/DsRTxR7UCctCWz62TRyp+G5Idz9nbKR9Z5k57vQE6WoXNQdkJyhqE17m7qRdIfOMPJB2C3dmW4BmmHCuyvT1I63I+qYmVfXvbVH+I3a0qAT044C8ZeClXpqZeh4M9Q8DrvL0X6BvMz3LiUIG8mt6NICVzgDal7Ry/hwdzQTnvohMd5q53W9AgFxOGPEhY3ZFGXUxuzMHvEdo3F6jUCR6o1CwXAElbWblCzMGkS9jRzXYI9N0fT8rnOv2Jye+dvRkhHp3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6r8D5Vd/iPH9Klu9jEIAaOBPPjMdBy9AyLVyegbo0U=;
 b=xEJlFViT4M6HOysjhCWbJ4EUbhlpKmdo7Iuf3rER+KyZFniKxAGHDkqzIziNuQ0vxr/JpftKx9DJoKZ/q3wnJuOjNeOkDK42kBlQeINoT0YZ17tdMpOfIaDWunWUFYNrpzIh+Jz5uqwp9kOzUh2ZkTJ6DR6xNHz8ajtqGWrIr5FYVCS6wbChzhygwrOD27snhSXYk9Hd8XiOhrBwZQn1yVY/CBRWm14daIOwZ67R0AeGDk+CEqfQfwqEXrjSlGWMNxU53NiUia5cU7wZGVnxIiMHw+DZ6ARlUZUAYN/khaNgG6DlFlaY2aFeYplfXWvHQN1CO91VmCz+gJijvHouSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6r8D5Vd/iPH9Klu9jEIAaOBPPjMdBy9AyLVyegbo0U=;
 b=yUDCneqQejOU+MDMkM8epHznkxuq2Owls2o11gjHrKUmDlS3LE+alxUwXwvYcCwci1sGEkvE2FZAAr2yOw3S8ptcf3DejtpWsPEynYgoxFZhM73xP3BCr2YMSxeFgDJERP9MGE0CPtYuOcuF3Bmw48/oYLsZxupvK4DHikDME5E=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5672.namprd10.prod.outlook.com (2603:10b6:a03:3ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:37:27 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 26/28] scsi: sd: add mpath_dev file
Date: Thu, 23 Jul 2026 09:36:24 +0000
Message-ID: <20260723093627.2327456-27-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: 05ffee78-e741-4f55-9683-08dee89e025d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|5023799004|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ZjDwu9ECiAIMOKAh8KS3M9XsgLppG6MWWBVB6vCIDS7TYVjGSU/WSXEvYclfe4xp9qYNHnzjGMptiaZrr5X4hZvUmM8MgA7kjPfu/P/+VND/ZDCoBOsLCwnKc65fhjgEnlFbGgJqy1A1kavlUSRfm7o/qVhvg4/CzURrEiDcQVcy09Ya8FsFJnw7UMxhWp1yB5OPFa4PPNG2F0PlUgjyfVjiHHV1a0yVRl5o3jt+deCcNcWMgpI9u9c8Y/ZCLVScvdNzVKOgBMj/LWMGrsA/kEeaEPnI+vjr6Fv0/9klObs5MfeNy+zQESnwAzXcGb304Q+soeUDzTOFYXkcNTi0JX72QCOVyiF4EoIUq3pErBdfY+APRgE9z53MFKvtzTL6miq/MO5Eevxk20zWorFyUso+CtAr9cses7Gkfo2whGIovXhFsFbYf4XEy4eq8MYgsuvj9SqQOrMVCrUt564ANpeJOXubtU0VpvYVPm6lDAdAs1b6K5P/NBeP+qOF3dlZHGhedH2D4kuVI1PsAD9R5PJuWptDoZAS73XNir7blsrEoJ1dlCiecn74UqQH8H4jlkcxvIJRcIgNdLyoql7RJjCSuEeW9Doy3WAkm8jbcZUacTq7gDFerSO7gtVDFPIC0L/Qfjd7EJq9hhLBp/EepeMDFx+lOO4KECXPoRg3NPA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(5023799004)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?om997ooJlx+6vXiLnhK+jzp06gmLOt1ar7YlcKpQYoo4TYP99gSf9bRUMVXJ?=
 =?us-ascii?Q?3ml9r4s1D/PfI0Ko5mHGrTjMVE2acI2SUS49ZzAPuIkrqu0nvU/AkJ3YVqAG?=
 =?us-ascii?Q?e7nmY3VQ5eRgLGYuxYTZtrSvaUQLk7HZ6axGaU/t2p90m9/eqccvtzlydmsc?=
 =?us-ascii?Q?HKxRO/8yewxzYM6d12bxKCYx7GE8P4T5d0iM6yzlH+8Z8fVAcoqqrZhCSiRv?=
 =?us-ascii?Q?0MxWeeKjLZoRO5s6BKttLAEfiHCciIgi1mwRde5y2WSEVdXc/dC8wUxS5aVj?=
 =?us-ascii?Q?5BS8SsXk1nyy/u3N3q7nxtWne9sO08WAnyLAOAeVWpI8b36bn9uGqCLFGVEe?=
 =?us-ascii?Q?xVeFur7eTCarnq6OSA91CENqHTT44y6GMBRtxh49zLnykXSZjX85LRGqrlVJ?=
 =?us-ascii?Q?dl/Ru7WJk4EAHjsxoNXoMPTL8an9M5TE6po6+ahOcfcwuwSmb0Nff6VPAjSs?=
 =?us-ascii?Q?vHjltHlnsnsIaNfqPGo90kZpLvIXC9WbyvJ0NM46BsdsUnJf6qxKMTE4tlml?=
 =?us-ascii?Q?UShwTcnIi4dva1Vviw312zgLyajd64rKtPnrwFRmAyjFPkNzZyVL2RpUz3Oo?=
 =?us-ascii?Q?0mo2TIWPOdpFLOHVHhU8Ac/k0ahCjGwnbAWt78wDWxDQIYXUTNS5UG03S7Up?=
 =?us-ascii?Q?quAjiBoWYPA4EGnl+X7kgWucSucQ6lvH9Zcvkvg4jzssmfs204TanNQVA6Vi?=
 =?us-ascii?Q?XF0Ulgzm7ZsTirg2oFHefn2a4JVA2SGJV9NHjQRhxKxZgiSIkxwxODwHTQ0W?=
 =?us-ascii?Q?gRekYDllcvm6ZyhgfbQsRX39bDXtEtPK5/YldpEf0wVIPlx45EMSNcDg/bP5?=
 =?us-ascii?Q?i00zz2baxdnna8CqzTQbESRddssdn0C0MQYwkDbZxQYx+lH/PL5YOxBif7o1?=
 =?us-ascii?Q?nRXJq2b9Ubm/pZxFLrYB/Ou4VaxG2Ib1w3X/9rq7s5IeF7JzgBkPbCQIJdfh?=
 =?us-ascii?Q?MAUkgj8qvba7i/8J09ll8+5HZ8EVNaHJLIzGZEUx7E3C+LQAE1oNKDFUcHdd?=
 =?us-ascii?Q?pnH4/Dr20XJL/ICagHS2WCdR+U6vleRvZBfyTv33Cd5Jpzf32F48rF2iefsi?=
 =?us-ascii?Q?gnEtaPqdZtuVLxxMkZ2eBCPbwbtt5CbW+fLRgXKEeWg4JmWE+NxJ1ljJsMX1?=
 =?us-ascii?Q?m68ZA/9b9dKP60U4P450oEm7Xmfzel1XAH7lKzzQ3QZYfL0q/OAUelFTjr14?=
 =?us-ascii?Q?5BcxnsiUzKuK4shX9Bp5g7iJwZ11yhBKR/ixJcGziD/ZkeV0pDcZ6ksZ3hfs?=
 =?us-ascii?Q?PnXc78Zy4nfxhZVYYzVUcKIO6NrYGro4Crou4Ur6pkt1MCWB7+2WUICCJOtl?=
 =?us-ascii?Q?N6x2fYxVrlhGY5s9zfA0PuoP7BnbF59a+KJTnd50U5UXKXXoo/S2bOWMInKk?=
 =?us-ascii?Q?cFk/4u7ExksdwRrmKRSR/Osr7YQUAW12rYWayITHsyTIGDmT+4izpSpewbfo?=
 =?us-ascii?Q?YK18MWGDHSgiRZhz0sS+u6hIRMkxXSb7t7bFSe5slIFa47He6BntKxUdsEss?=
 =?us-ascii?Q?zdFiNF7R6xN0txtx2WXVmCjuefb+p3FHYaDmAHq4AFcvCpEqk+FcloQK2YT0?=
 =?us-ascii?Q?rj8kwEyTqX+1FDmmegWHerPoUlhnzP4dbtGMRbCk8lmLu0Syqtz+VzhazwB+?=
 =?us-ascii?Q?vEmDvfeowri6n0UtU1wF0EsE85z2/J/S6YfSExgeU+VGgdx+5LFQTu5uthD3?=
 =?us-ascii?Q?ZJX2CdipOZVFgLBDk2qCPKAWRi8lU8HvLpwGnEVbUL0sMK75F3wBJnEqaUlV?=
 =?us-ascii?Q?iY4qAVzuTNIs3ElUfsxINa6NAKnUAtI=3D?=
X-Exchange-RoutingPolicyChecked:
	WLvTw9MIcMWOglV2dVlME7TS9g48jQjXM2LxFaK8XckRkbin59QPZ4953m3WbGI1QpM68NHZrb2/4CHXHChG0yHW6bgHaT+/5m0qKHhmxwVVQ7gmoqNYlwpiuAoG6NVQpZZmC7adVKZb0kmltmiCmUb7V+7OmdGhvttwTp1H7YnDDysm/Lvp7AZ5R48czsAhAoNe9pPBJQsOKWItI5bM+g0HxzEIRHpEHgJhiCt9FzNRs2Po50kEjR/ro7Ua8YFrlDyf8oAK1kJVFJIIil3kj/jlNsUrBIrQ35+2idZ6VDz+8nPLQfqfJXZ6v3CXEI4/qbb/SH/b/5gE0dsRPcheMQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hAy7uOzZngDssQsSr8jx3B2U4zVFy5ZNr8AiFWdcqsSHno/5qtarDQWGJUkPvbyCwj5rmH1ZJRKorOgtS6PXoIFdRiO8MKej6hliHykY5M+XxjcfVItvQJ2jGnNFkdq6jdPVOtAkPt9/PkD6MDqF9OaS2d4tMzu7/kOl56bumaHA/n9CaVSaXUdwd+rYgqAYjfvwjTriHOGWi4UZxH/u9L0wvDtCyNBo0aximsmEz28A62WR25zG8ZJqHwRajX32iQxTUs3gCF1mjoRsOXQIaGmgyOhs+BHobr0umMU3syvthU9En3RWWO5zuRPmsRCKn8V6QHYkqHZ4+qGtXhYRQjNDBObNrr525k9Ki478bQcqYZ5kEyoVhIcyJDQVUbCrszk1ue0HWd980yY6OGCG9JcI4oZxhaheNLs+gcGQRg5zMkt2afPeCgs3HEC27Gr65krnWQ4LGu4b451qtTd94YkfyaMARfJ1C2WHLD657wG5cSBj8xQHsPqLEKAT3EyBwwDrrXNWz5rfMPvMSOdATKc8OpSYLCJzuWRJX/7fTqwxPXwqggOGQmfCJLMsVJa8xOjEa0H+lacOxKr/YARmUdBhEZJ+YKL3bsPA6ZVzS7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ffee78-e741-4f55-9683-08dee89e025d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:27.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRNz8YgvCCVhe7cmJgMrdGE7rFgkn8jmXdUqUZmyFj3e5j2UCg59oydGUrVAlrd0SmdV941SKG/Kfk0BlW9+1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-ORIG-GUID: SCOrUFtoavCMz7cNtbPfI1RGo3zHUTXi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX+vIV2IvF3RuB
 p53e1FdcRUpvT9pLKR7QooR4s7pgx84rnFsiQbdyq7j8QiFkHzhbSAzDg07L9jqvulBrvJuXa9d
 SSQqLqmXdMseNCbuTN62rHIF5S9VpQ0BEmgvXG6d47JgUqpXaYuvcwhwPk2c0i3KoCsuLDjeEzm
 XelLnEvQkxXiRsdoNkl0MLi6BPORnuWK8wTcFQCZwox1g1MYvSkbodA/2k7F7SHht70ANqaIwjd
 j8XbxfGrRhk4yvtceUdTNymeMChGcdk3pxy+fsNZNyUw+kTvCpRudg9Roki74ypx2MzQRVlGaeX
 pmGvTOeK73Ya3h4UYDsocwgVqgdEb2lLtgNzl32CMzi5H3apBrnUiOvhKGUGWoUVN4rMghYAVQF
 mbhKJC7SHA5c9lLolCXDs55jwchgCKHDmU+1xgEKy8zEKBOXYOfIxWfxYwrsXNxRvPME4zFFK63
 iL6HX7z+2c6PYEfk3SLq0DMHjlcsDM6dOAab5thw=
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61e0dd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=A6hY3BpGxKl4tX3xGd0A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-GUID: SCOrUFtoavCMz7cNtbPfI1RGo3zHUTXi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX/wHanCCRqhH2
 IsVclS1TcLpFtLiCKz6nyaVbEXKX4igrit0OmeoHztvsNXQTss2QQ4jbv9/VuXRU6qpTVc/Ixz5
 c/mSSIDLyoPqFfbnFsFj9eXAKoeLpUrRdBrSVIgZUuJa1fo0XGdU

Since per-path gendisk is hidden, we have no

Add a mpath_dev file so that the multipath disk can be looked up from
per-path gendisk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_device is missing.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d5a37b1b312c3..f8c9096e6c43c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4059,6 +4059,53 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
 
 	return ret;
 }
+
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct device *disk_dev = disk_to_dev(disk);
+
+	return print_dev_t(page, disk_dev->devt);
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
 {
 	if (!get_device(&sd_mpath_disk->dev))
@@ -4389,6 +4436,8 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 	return 0;
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 
 /**
@@ -4539,7 +4588,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.7

