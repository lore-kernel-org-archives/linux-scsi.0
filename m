Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DAC13959D;
	Sun, 22 Feb 2026 23:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771802999; cv=fail; b=lTGX2qNgIssbg9TM3LBkOma1OPITCtWSZP3YPLicZjl8PYNt16/fzjLLBpSA2jBhruB7dajHNKicDTeCk/W+tgAcC922vIXNBZHcdc7qSr88sRHKx5VPAk6f+Nx49twB/43CnQyA1jbbE9GyzUyQ5TyL37uRfpW/ZPtBjpKcfFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771802999; c=relaxed/simple;
	bh=WSSNSph7vRFb21Amm1JnT6wKr69Qsogj5KLjTTFbIIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QXb+Ntv1bFfMqoINJVc8UHxPRLubRcsM7pvEv8X2kli12gjwVoSAFXlMmOTa4cV/OlA35zoGkcXfoP271uQLYDPVJIV9Rsn0VKO6Wfteb+wtnGypGnysXSUTBdJ953J1iBtpXUtDeik0GPjqmxVwRzXDnNuF21tPLrPPnqYrAEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WxStdy9E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oetlAVSr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WxStdy9E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oetlAVSr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MNQwTm3892001;
	Sun, 22 Feb 2026 23:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=m8jMXGEOnmiVmFkmf//XlZ8hOthqTcphD7kRTzxdKAY=; b=
	WxStdy9EysoLK/XDy0Dcv3q/5h2I6ucgEWBopgim7l0CdY0Z5y+lOOinVoDVu3mk
	WnOZRlmOPXY8aQtlEtLUWETFbkMVcNyI1ktsZa/rSm2+NzHn8xKK1nqAj+fbOo9S
	HZB9doWZmybuKVVeyfSbxYrbeSbS9glohHElP3D9msz+0RkCh48ZsoxtDZHAe5Tf
	e5R5oL6o4avyFI+d5CZoObBtuQQrf4Hc0ggghHmDICL45Y/Ut1RPuQE+u9AqdEvB
	WoQtYeFE6ZPAL9ZIKiyQYlHln7ooRkas2WqEMRxRj6rJ4L7GA9I0D0Nu8luNOikQ
	oMV09qscwudU3jpHkUVGxg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a01afp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61MGTAIx015693;
	Sun, 22 Feb 2026 23:29:57 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010014.outbound.protection.outlook.com [40.93.198.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf357yft3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mq8x8yDZywq3jlc44bnE2MRgvzFk1vZ8tB4BzgnGH/CXLnrsXiBw9TOlR/aqg1jb9cZobBcyTCsNBVhYiHTCRPkDGL6U3Jde+e5ws7Dbjedg5HNGZFx5rcs4BoWm1qAPfiYsMl5EKk+9/pgeRzA3/rK+f8WDeO2JI03/dvci9IBDQ6i3oxFpfYNLMeTHkpiGD0bn4t9PISwLj/Gpan6rjynbnvxvbLYUXioyyYFjQFcf607z+nNlfvLlTpcH2+7eaMZYw3jCxOZQGIA+jxGeYFbnqBdEXE7AO4FeeGAWYxScuNyhH1uXTMCwGI90SauXk7EwsSegBD2P7vgqQZwopg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8jMXGEOnmiVmFkmf//XlZ8hOthqTcphD7kRTzxdKAY=;
 b=KwIPdIsuZKCnSr04xms3and8e3SSBiOo33VxykpjwNna70e3eDb3ScAyFkGzC+aw36KkdnXCoySKqAeRS86320Ij0vP4msi0UVxPdLWRYhSJwKPmhsbisOAk6XGtJlQ0r5Be8+bQo+396FAu6G9GgloNImSrznGh2O/Jh/BmYvjsr5SyxTM27nZX+tSFI27akq2ZtRjgRS4PdIRfYAd5H0f910g2iZSMZ7bvD9d8tZkdHHgict8ohM7wmkKwZwvuEd6YVn+iLfvFjmhyams1Ziquu86IDXNr3pm5v0rLvIUUuAwCw95LhBBHc6ofAZ1uteR9iRprjtMQTHudlpM3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8jMXGEOnmiVmFkmf//XlZ8hOthqTcphD7kRTzxdKAY=;
 b=oetlAVSrlIJpcy6HgsLohHfXKntPVE6S9qKEZmXhtAfPCIrRIbRRl0b2lJybxFXKbRr9P+pRcDxGzhheEEpLGtVmc3AN7Wn+w1OSt5xZvKfvCG1DyMSN8BF2HFP2mSsXLmm4mTQZ2j0LYNhhHpoV3OsQ/hUM4vdN/K0Dfxe6+RU=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CO6PR10MB5587.namprd10.prod.outlook.com
 (2603:10b6:303:146::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Sun, 22 Feb
 2026 23:29:54 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9632.015; Sun, 22 Feb 2026
 23:29:54 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/4] vhost-scsi: Report direction completion support
Date: Sun, 22 Feb 2026 17:27:04 -0600
Message-ID: <20260222232946.7637-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260222232946.7637-1-michael.christie@oracle.com>
References: <20260222232946.7637-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::13) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 99548dee-9a31-4fad-3e06-08de726a48b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Igzx9XjLeIjt98H+WjBdqnuFdEcQsVS8hztroqEHq26WGRq7P8pHCfAMm+Ou?=
 =?us-ascii?Q?VuKbOenKAemLx3g3IYqz7abSGkYdgxM68t4WQts8bouXZ1Pri2GT/C2hHZUr?=
 =?us-ascii?Q?HytBuZOnpwDLe8zrAfW+iCZgF6DkaNCWhhgnvhEUaHR/KDHYSX2IRtbSToAe?=
 =?us-ascii?Q?KTEUqQZLdW7UbforgR30JOZjBxVgJmkUsjSKrYXV55uog+fl1hMt1Zb4TLgJ?=
 =?us-ascii?Q?NJ/Sfi81eT/AR2fvV59FjMBc5EwXxnsyf33MTqmoQjdSvgGvrFhCMkmosljp?=
 =?us-ascii?Q?duwGP/5fsZvXkXTKFKYeSCPdDjPt4mgLdp6KRu9OtdLwuTqHW7ELrmpQMdUg?=
 =?us-ascii?Q?yMglM6+tNnlNrzU4dl7jirrVHZiDC1JV4HAgq2T93I4T1Yqbq0O0KoVP19zO?=
 =?us-ascii?Q?4p6ZAGWgZNXSBfAfit/lSjgRygBL0oeV/ulQmCvjprqWvV4xP9DGSRpy5ogQ?=
 =?us-ascii?Q?RIOIzXF6hUVlJI19yYPIrvwBJOnFgI3rboCFf0+6AOqsM8C+p4/4YYrjqG5Z?=
 =?us-ascii?Q?eZTi0QOZx7Ri0rDCf6rHG/dfri3SQrtwsCZ4cbU0Lz0EmrrL2zPkCgTTHje9?=
 =?us-ascii?Q?RWekWfK5LpGMZbNGDo6amqUSQeM3CsW0yZTbIM86V1IR9XYfCywuryhlX0Hz?=
 =?us-ascii?Q?LzmJazt10rG/3wZ+5ILbHNlqYbP1sXmzBd+44lpXPCMjhFAmhD4zJi+Av+yd?=
 =?us-ascii?Q?u5RGRfsvb7J0InzflyEkEDyaYeN2lXRU2ka1ZWNdfZ5FekhiDI4GUfqpo3RK?=
 =?us-ascii?Q?T2vIXdtsyPey3OhOrEM+TSZwupqLsR7u3LuGweJiz6NFXAzH8204GzWEAkX6?=
 =?us-ascii?Q?FfGgFYtbqQ9MwOEK68f8NQMRRJS5FnoMg9dIFIOr3rTy9qzDd1Y6dd69V4ga?=
 =?us-ascii?Q?f1i9HPE2VydcY96dFuvml6N5zMnzvx3aOLDNpX89EcZ2nMGvPPedx6Re9JET?=
 =?us-ascii?Q?WG9OtvJlaoc2kTNVouBspUurnNZLBToba6b9fTU0ZpLxk5WG6C1a2GIJLOeY?=
 =?us-ascii?Q?+t0M3mGYOlVTOhHqfKbmDW2H8ZKfE9wIZC6H5qRYcPxtxGsDiDyXgUdnDVVq?=
 =?us-ascii?Q?SvTxM7WuBB3S7geHgeZkY4p+rqKt0dIjQRKDXY2lRPTS7ntG9b5jM0LnUQX/?=
 =?us-ascii?Q?z+bE8mJ5t1bUh1XzlV9G/LUlxPXDSQ8PxvOGfE+8uggE1FfuDFKybwm0y68C?=
 =?us-ascii?Q?wZaIARVzbaRnnEMmMmh7VaUjDhmZoJgNZamwIzCbrIBP3mVrtVZJGYt5x5yg?=
 =?us-ascii?Q?QkvoRLJYsD+qmIyxyI/ao6szTHQ+IFsvgAfIf7/bPuFFrLTqvQ5PpYHRmF4h?=
 =?us-ascii?Q?LAWXkX8zA0RBQnCDqmuM8e9RJ1D24ddzrhIlROZsAWSV0eU8ZTIQc0K3ePRB?=
 =?us-ascii?Q?O6Pg59H4CB8Uii4bqsT8SeSX+bUDyayt/GdNmtUkjkDEEGSGzr116aKkRuuh?=
 =?us-ascii?Q?DTqMaKnAd/nPi8JTb2lHjwYOm1j/9kEX35UhvN+IPj1PlB1sAQc+/bEOX1uw?=
 =?us-ascii?Q?IQbwL6EgjPHkinI/4sqnbmmyKqe+P6QFOL+KfsMZ4jysX8xQd+1arI262IYd?=
 =?us-ascii?Q?PugFW09KSjo3w3foeUA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wItiz6MYZ5kXl5yFjLYQddDGWg4sBQ/mjGBeYIHouqqav8PaXouQvoxv5m/W?=
 =?us-ascii?Q?hdjRcyQwbxVsEIRbPdUBVpYGTXeRZsyv4EsqZEXwWyp3buN/+LyrQdVRnYDy?=
 =?us-ascii?Q?RE9mtVay34xufFagmRkBhn3h7wTb4Z9RJoo83P/lEA1+gv1FDuTrwn6bB0t9?=
 =?us-ascii?Q?11h73xPFbe4ZI9Af4FVM9UphYtu5FP5mxFfhAXsflMAe0jSd4DYQ2oAue2Nz?=
 =?us-ascii?Q?ZCrwjnowQEyNIoxZFLW9YC6BYtZon9+eOgrKCIvFjNUjKYsuAGfYnNnTj4DF?=
 =?us-ascii?Q?sWxAMi1TDQH9irS9stUn+y56oCYo0HJ4fThrlocWSfKi8Z7haEyZCiAvkU+k?=
 =?us-ascii?Q?iRMtqMrTPZNqCGZaTJw10l5Y89Oi6tumTIkQ+OPk4pnORXqsrPDBmOK+f8GM?=
 =?us-ascii?Q?aSMMjpp0f9eWULMjiBbo/Of7p0dSZmKk6kCMYI0LkRTP6kdoJW49q53/6agR?=
 =?us-ascii?Q?GfjSoOeQsKY/FMbLFxLna6fl4YT+aAS/QSZsAoYurDkN2msReOVg1+RyPTj2?=
 =?us-ascii?Q?VNSGBhZS2A4P6WGnURYhonM0DeuQcdKxi+HEH1rLCmrpVMgM4eYMIK1mMj2+?=
 =?us-ascii?Q?mpfOABzheS5SaPtNUqZUKSHfzTaNCJK78P+KTbupCjsNjkFtK0IstSUhqF8n?=
 =?us-ascii?Q?Seu17ww4560rpKt3Kdwm0suZswjASiIMv8fsLlCG6Wio6jwwNmyvwxf5eXy6?=
 =?us-ascii?Q?gbuXB+EpAf8Mx8gFGp+woF8EKDDbuCFr8lUqoOCnB7en8i94uiHFsZK+jPT2?=
 =?us-ascii?Q?Qu/tqIg7bv3DBCn46dfyoLraaETfHpM0hTrROq2IN+dgvUhEiexuxEt1iput?=
 =?us-ascii?Q?K8OnQLsrfggtrXalYpE7AiUEqMKmxZBe3KbUUfLFy0h6xQ0VXK8JD9eRz7Tj?=
 =?us-ascii?Q?K1p5HXi5l++lR5RFC6RHNpuk85SaGxo2h1YWSzdsBrVtay7HfkxR1D9bdlsb?=
 =?us-ascii?Q?ORtdyFk8RoLYV4NnvWAf7e6JDqhqmxkaL4yCr3dlMP7vBJbmnTMpNkXlANU5?=
 =?us-ascii?Q?+T7w93mdY2qvrkH8hUoq56FfBTdY0AbmyCZjnqf56jhEwrOcIPrpb0N144Av?=
 =?us-ascii?Q?226fsaK2btMgK6PhIB5vDyeQjtThc7KrOYFv2Ttd91zNev0bABiwHwQxNGlT?=
 =?us-ascii?Q?y6zu1ta/NOhEFlsH63ywQYspsJHqHyIFGggCAmdT4fav/NTflE/kd7/TaROQ?=
 =?us-ascii?Q?OVkRnrqqchpK3LVpnJilenXt7A1I0LJPWacMMa17irCFBvFIXWnBY5itDngL?=
 =?us-ascii?Q?xzEb57MbOxrx88pnAYvdKrc3g+CzH8WXbcsG8acP/ZhMYDmCA8cu8fNES0xK?=
 =?us-ascii?Q?xJoamLjbtpIDzgIcdudjrD/FRiDZy7XIeueFOEYsXVS/6Ix9sdNazUh1kmMr?=
 =?us-ascii?Q?uaUWpmUjEAf5fqnOyGqBW+2fBP0VhZo5L1YZ1VOYzKVmaYZyrmX79Z+i6euV?=
 =?us-ascii?Q?MS08FH0oA9yWwHLE52s0lPJXaY+Jxc897uhvZYHevDx534jWpAP0vRTMdxnm?=
 =?us-ascii?Q?YdJdOm/Bqx9on4YGs+moELTJ8esfo1vMPFqpc/ytiPBvD61BL8UZ2TZhYLvR?=
 =?us-ascii?Q?scTtHPiusdlKD6xa8g3FQry8p458jbBJEcPeJjU91UyjoTUgXJyqH11rvI2Q?=
 =?us-ascii?Q?c68/H1dOeFX8aYp/HNKnbNaxIU15naedYHd1wTPjfWBsJb8AR8xuEpmnq9W+?=
 =?us-ascii?Q?O6P006fgfMzVBTvysn7j6JTRLru8U1zYV0hNazYb+obyKyHwKoOxsk3zRPD8?=
 =?us-ascii?Q?xI+YTXhhezlLYSQhF0aGzscxOemLGoo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JrksqN7XfRCIsFeIpH717BlML7sMGkw6wB1h9cfkjBUAwer93wfb8wSZzJl8gyLd6KoUMbAih8Ej3fzvm8krBEDP9mEEFaeHtZ1+RnR0cfYup+WB0h0aAvaMtsd55uzQtLZnhLE6a2zGo8CWnfctDzMMfvCHKbmSfPK9705/YvCes/W/etQrdYqWshLDBvACdnIZ+HhrBqkj9UqFjdUzkUQqpwVu2R+zN9ZtYzaBZ1ui1+AKBjujR24S6E/wTLS0z8awz8UpiYSB99vBe3bzvPsbbAajDvrCV/H5vR86bldAJh7+qcGdVIN0NxvuEps1MRxPqPv1eKE7Yf/WxWR7osVaEsY46ZOAtpyLbwE3MjnNkqcFJUd9/MPe5Ne+zhDedZ5ssRx1fXsuZw+Zkmo+HIQX3HCuCnFNiS3Fxaov7SuUrBKc+eGE9uMtGYpD30cQjkUkOEA4FXD4qXXpMK/El+lR7R1iFl1smRAtWANGYyMFAkzOAmjXbp+lFgpwizFW+RXTc9ovxQWATdtfCsCtf6M99J21OC/McWyr7HHGPKJ/8O7MpVo+iMlviHH/7vZ0nrYdR5UN2ZLRigSLPAJ1XhA4PZSKiJxuJp7oiY5HgRk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99548dee-9a31-4fad-3e06-08de726a48b4
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2026 23:29:54.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdmm3g3wfwrJpwTzJC/HnbxXMEe9xTmkooKWwNzOMerNTH27OaljS0tfsAjSvaDhpFrcEUH9kGEYrx5mppASwkMr5H77/3waYEifBkcXSsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-22_05,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602220224
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699b9175 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=jXCLNjUwQNANgAvSNEIA:9
X-Proofpoint-ORIG-GUID: WEQJmrDkzFPLoH8G1kEBhx9bM297uGC6
X-Proofpoint-GUID: WEQJmrDkzFPLoH8G1kEBhx9bM297uGC6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIyMDIyNCBTYWx0ZWRfX8zuBkKjP94ZN
 0sXIxt2CyEaHihTr7Y46tgl5S4tvtrHroVq0jpqUblSXgBBy1ECjydaGzFtAWXJ472OE36x1AA9
 7oJhPBKZPOAGqJ+vjInm1g7DY5tyD6JD4+geDPc+73tUfCxKClY29ZSyTi/GRVsF+sCOgUZR8Sp
 tTmBg3SHixUQYNfJj8gIhQpFFPiU5qjpmS0XR0z9fVKxpSPDxgN1eSIkbmxe5LOqWyCnkGbva+F
 9A6w5TrFL0u0H66U8eantNy2peOBk0bxKh4p1RGlhoqpKl7EBPw7vsVHOrv3aPNdRjNpLjHN+Dg
 2qSduAhBSjtkLXh8W1ig5OdUsoj2UjEEpgbFCmnhDi6k67TkLqlexRWm34JhdSuresHB6AO7XC7
 P8abI3XXnuaMkQKjnI/BiCOsOyZWYZl2vJK07Fft7Kelp5yW34AB1cD7ZkKXRa5imrq2sSF5PmU
 8OgfE5rtmsy0Lcw/7qg==

This has vhost-scsi report that it supports direct completions.

When using a worker task per queue or group of queues with fast
backends then enabling direct completion and submissions increases
performance 20-30% with workloads like:

fio --filename=/dev/sdb  --direct=1 --rw=randrw --bs=8K \
    --ioengine=libaio --iodepth=128  --numjobs=$jobs

As jobs matches and passes the number of vCPUs in the VM then
the benefit increases.

However, when using a single worker then queueing completions
and submissions is best as the worker is busy handling mapping data
and setting/tearing down commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 1f00145116f4..653c08bb2520 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2959,6 +2959,7 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.tfc_tpg_attrib_attrs		= vhost_scsi_tpg_attrib_attrs,
 
 	.default_compl_type		= TARGET_QUEUE_COMPL,
+	.direct_compl_supp		= 1,
 	.default_submit_type		= TARGET_QUEUE_SUBMIT,
 	.direct_submit_supp		= 1,
 };
-- 
2.43.0

