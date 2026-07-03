Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80203BE16A;
	Fri,  3 Jul 2026 10:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074824; cv=fail; b=a4KWJ7e4GxANuOVuB3EU1Q3Uxi14OvbvM6IHS17/EF0I94rUUDE0RgjZi9YJkJ4EYpYLaLlTGu67vCgrxbDA6Dep4V9ZrjnsiEac0rv9JQzKRN+sfhySXR+qzej81LiSajhINH9EhtysBO1VFeGTRtuIb5MPER6hugQMAQV6FIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074824; c=relaxed/simple;
	bh=DIn7JDh1CSdcDbc4kA8nn8ny3tJxdwAG0GZ3I2xgVko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VuQEGPbLA2FrBn1Jqud40ewAqMk2XIBVG7XbHbZrKmXzhdzs/Cz5Cysd6Rkw5oZNnrQL2jQ4gel6fw8vU2nGRQj8V+CGFaeqvdv533XUE4ZQIxHdK3Rwg9Mx/O4wH34GiABEpeW3LHBmWs5IwQT6xTXkeRv+xx1ZLjncT9zVXT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bHpm+HnV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j7AQKOit; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bHpm+HnV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j7AQKOit"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tf223016255;
	Fri, 3 Jul 2026 10:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4WTG4Ht0g0D3byMSVkZZcqUcCZcO6kpYk5wTgUs/+tI=; b=
	bHpm+HnVdu88v2LpmsnMGhgNL+OVvNDn8P7LuNmdbJ1qJvXtot4EXUqbmXyZhnOd
	4vIMuPLuDebXWUWsXvysrthT6vnIZQzgn8h92tXHDLSrdCs+Hk7Loe/EuA/rI9dp
	h8+quFE+ttgB4ZySpuZY0PxsA3GMD7eXyOx9xbrmnixzkUAWxkN0ESEMpfZ81qSG
	unyCnfeFlCIKtFJU7+oeeHled/bSKUiKLfuSxlJbH5+ki2nkoRk8QjLiODYhAyUN
	9Y4jdJ7jTcbxpUNcO+NACphg4OWVUkCBAfU4BR5W+XKojXNjHDHQuZ6+riYbm7Bv
	19u4pp0hRb/N1LHhc6PKsg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qtde6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7gA013121;
	Fri, 3 Jul 2026 10:32:21 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvrrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hh4wC4ne/kASR5yh15LiMbIUHVzHp4NzeV10/ZwI9cRlxLJ/zcluw8H1p79g9kgLiGAAS7C88+jMLSly5L2gBLUU8NU9f4Cx+Ozv6xg6jSQQ8JHfnrwOhnKdE542a+9h/3RJ3Yjd6Fm8F+n7Mu3QMJuOWkJBm4Y3TBumz3E4vPZvXYKLGfHcG3N0E95jvvG75mlhKCF+rCv4oLlvPOTGjSqaMShhga97swPzIDt7JgS53oqNOompDTDJO957akdMsnZ38dMmwUOEkmaUrUscGjKnf738d/kIuJayvfxr7ONsgRbwGnwFfOBCPhpuzL5tj1oGdYwUx5mrqED8h+5+lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WTG4Ht0g0D3byMSVkZZcqUcCZcO6kpYk5wTgUs/+tI=;
 b=DCKznwcRKBK3TxibeYqks9FpB37Il8eme/NMKhmzBOPMJCnXVEINTpl/0mTV+e778CJgTmix6KORx18YhKlJOUNT9jQgQ3tCoolalZ1vvXuWRZJgzhy3x4yMvO0uvLt+/eD+wUs2WOLuR28D5lUt7wzCNNNTW5L9YMfPABjQB5pkUPJLnxKqyxR0kZtx2d6pirXeG/ZuCYrIWqSO/p3DoW+akKJZ+KJ9gfyJpkBJSzjWloH2DKUpBLOFbZ/xi+iT3emWwqBkk8UzpOkDQIZMvdxI9PPLgJ2w17vs9pXe67LEYuO9xb6x3ZB550wBQXLF7CI5UBpfwVAwv3ZDem3ujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WTG4Ht0g0D3byMSVkZZcqUcCZcO6kpYk5wTgUs/+tI=;
 b=j7AQKOithiVKeNq0UaHXdnBEpUH0MhnmvAu9Kp0s0d17jkmhd+VKYYnArS/xnxKxJSL9QJj3G5sftNGfq/7JZgdD9BKSTiS1JX1pQ5DrlGkwxxM3dIMhEvsIAAja8bdFo+xhpj67S4KSvGfRWpZBv5z0tfaQdKMnml29C7iEuyw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:15 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 01/10] nvme-multipath: add initial support for using libmultipath
Date: Fri,  3 Jul 2026 10:31:55 +0000
Message-ID: <20260703103204.3724406-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:5:174::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a19265c-eb2c-4826-6767-08ded8ee5957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	fWFevuH27589z9Ou+TX1Ygmsj/iP4+y218d2KArDpJLbsjKyw5sFKQtztENecpLUUshvG/L/605KLszg/lBsBbfuCW6sHyZ4DxPdA9gjnZFXvmg3xYd04yrEkq0MIcVZytGhc/5SkdaCLrcLo7yXqkyz169hQoaUzSLPhMKPK0mGbexKtOTxmp7XJex10CTF2Qjz3UUzGMi/lMlSxiDd7kx/KfnYNGhyTFFSp0m9C8ut+/NAwM1HelHVn3uC+JdEkWmuw8du/keWW8r+MuIspV3HaYeGRpaEFRyETN6zf+IgewqQD85UnDZlY5eoxyaLY36Se+3NMUlFCM/0ZG4Ps1Bfe9zYCvg2Yt7u3Mmkib5m4IeFsA2zbII++Rwy6lB9CBAPJYksUwc0Gy5mO65NnVfL/vqejFgAdS307Qj5ZWKQCNShMuTqL/nNrGyRlHyjzzi9awG1KR/YqyGbcQasXyIJqSoCVw4svGpozc/QDKAPcQ2QWBY4Q40xEZwHLzIpkDBnZ4UngpwaO2UTUaLugqv2ssTyxPLCwEGDKBM1e2/y8IcYfD8FFhYodt9CCOg2jx74ow4dBmjGWpt/D8DRNhBeT0oMrfHEYlIT5PTdoXxM6kWLoZdhxpYIOlnSB+SNbF641oSb7NVtwKm5fpAeTXZ4pSRQA6G7AO7NpI7XBwA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zC7F+IIYmo8X6nuCu7YYi0jlQxONE3hl/pH5y17GrP+JrxY9pgEywKejyscR?=
 =?us-ascii?Q?SwIw5xI6gWjoGEYya5p73wg3nQ1ecDaFzhmQMO1F12sn5fPrCfAU+pjKi1vq?=
 =?us-ascii?Q?1k8Qynd0v+A5gtd7m21s5dkXXwm/pakY+qasprHE7CL7S/C+EIVcfE5xRSMG?=
 =?us-ascii?Q?BSJ1dA2gWMP7MkPKhJR2hmlqScT7f6ZX2+zopN5ZG4BGOqsBITHlGzPVjYIX?=
 =?us-ascii?Q?d+S7YvtTuRnoVLn5ehwTRDBPSW1bT6xtlplydwYUR2k0ejH/gxn6T1ITw4mn?=
 =?us-ascii?Q?qrzZBQFflgdi1PkIvrjDUiqXOWfB0NbxdHWrRncO6+QqqXUVAS2EYzQIF0Ui?=
 =?us-ascii?Q?nGUuYe1mWLaN8mE/u46BTZr6+eYh4yE7KhWD1O8fsWlTux8NknYs1tX+LaD2?=
 =?us-ascii?Q?Ff2esJe7stSu0vmy8TkaHQ1uUoAPvol9WG5qUXmJLq6HlYiyEJS0Sh0auNYi?=
 =?us-ascii?Q?jQg9NojA0wbB1cAforNa4Rv94I+tvrZX5PTnErMrSlExHSE626iXcEp+QdES?=
 =?us-ascii?Q?yupuwjyAZI4SrHww0QZyDIHeTD25MqlWi8tYks7q+vsMpviIZ6IkfVJNtx22?=
 =?us-ascii?Q?cYhiir5fOSMuGcyp7n7M6XoAvuS3AIghVj97MGOc5QeH9CZuYIBx2N8VhMyc?=
 =?us-ascii?Q?dje83jUUe73gubmk1mpYRihHaCxkZimx1/JisNdKsuGj8LsYiJt7qFVppJYO?=
 =?us-ascii?Q?OUunFvG07JI6tJG/VrMx1LzKUofU3YBz9TBRman1Wo2K5M8Mtx+sWTOiEorX?=
 =?us-ascii?Q?XvzXy0u3pzllNmyulQjyGxdz0IX92MXLEsnNreNiau5cvssHEC0YrsbFrfJO?=
 =?us-ascii?Q?JQ6hZfSlNRj1KIcYLyycrQp7XdAEImd/D0cFlW4O/WtstyT/tVytgOrCBktB?=
 =?us-ascii?Q?Idww/qcnu2ur2xXj4b/0ZWYR6OaHCOwje3QCy2CCvOKZAarMSOUeOsq0yADe?=
 =?us-ascii?Q?Ooh2CyhYoz4boeRA+6Oi2Hd99mwLPKxBJdXl5ZUEuSEZLFMyUuDPz+9iYldv?=
 =?us-ascii?Q?4Dot+B8Hei4OlpWtTIwMBgbNWec7onktFwG3Yc7t9euEdmeRk02POjnQOKfk?=
 =?us-ascii?Q?ypJQ4+vu0Ca+DO7942JxgCmtco6hg2vWSfutwAe46cKR17QarLwL64QT4IjN?=
 =?us-ascii?Q?D7/pt0WqtEa/RZycsHgB94ydeq78kCaLQwZggA03znXX1KP9abKVHehCkpXm?=
 =?us-ascii?Q?tJGm8q7u794h33Czc7VhNsOgUSNPrq8humRGA9CjPFYh0MBIi8u8OVLiT/TT?=
 =?us-ascii?Q?glshju8ozj2xCCS+eajqsFPgPHPhyCyn2w25C28ghLUVZIaN1KwBWx0rONdd?=
 =?us-ascii?Q?y2xbnRX6rEzX+0eIMyDgSAMlgIqy5bS6644nErQ5aCMrUiED7KC++XtZ4HKa?=
 =?us-ascii?Q?D0wiEKekaDY0TPAGhXYmtlcEYW+7a/r9k9cK67bEiGaMyenMiULkGeOCtKxw?=
 =?us-ascii?Q?UnvjXvVjkYwCgeXI4MrYNAcmuqb/ugZnmiA0A25VkBBuamU6SSesVamU4wl+?=
 =?us-ascii?Q?wKBUNa0lvXOiiM8MfGI1VULxvGnbtBgQghh4s16q6KfDrApunm8nZnHHULAI?=
 =?us-ascii?Q?UHDnLT8IFtczL5ZNCTyUbCl/UPghzAxEJ9fnWo86Is5E8QxsTVO6Te1p6gHi?=
 =?us-ascii?Q?IuC2/ukWTTHMrgXQZ2xjojNpdSl3aOA4n23d2PHFWK2jSgLcdRv+BaFCnDHu?=
 =?us-ascii?Q?WUV974HuhsyNgR/tTNCr2s3C7OR5FkU8ICzhr95VpJOJuJgFxdAzqmPFXPhP?=
 =?us-ascii?Q?h0YZu4cskruQop/Kg8Y6y5k6l2ovTKk=3D?=
X-Exchange-RoutingPolicyChecked:
	q1+L6hQI62J57AlsMeJ1qZCPjg3QC48ScG7al0JGVMwHKRlXLZ/gVyY27FD21QPeGceePowXzuQv0lJ6veXms2KI4UTPkxouoPIKCHKPNakIHvxZLdz/a71HSJ5uI5BIcuuz5LlsBkVAx04DnKGZtVUz6KssmphvPACX7AfDA2xU0fknmGPayEE2cZNL4PhSMGfz4k/YdvWkO7jY3UTl+MuSvPVoWOzQXn+lcwMgWPQzUKiJQ/MfsFENj0ireqrIgZ4QJUhCBLuf0AHmoMh7E2MdGZiKLmZxyVgfBw5uv1uK8WuJKtp9FMqp/Rol/U4r9cyzo5S3jzSAw6KdWcxumw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2aAz5gkKxXyItFMErstZu7mMYDfNQadwMmXp6NMxK2fhlczdeklMgQixmVz5oMvqbouTPfRHU9b87prO8mgxDQR6kN+9nZ6EthOAkPgoV0kat0spwLyAiiMUjBZSv1AJSJ7NmdzGr4UZKyUhrApSEQUIrYPN0deMdwW1szfY1VZphmDZs2E+U+6uPEML5fr4TDJNFoPKfwY9Xgtb20Amx4zad2Hgu38ga4apaLp4/g/xRH9EBQkCqHRJ1tYalZwkb8Ic+bTawREDI9w+JmCBugZzIx/e1/ojanPPhkhd0ywpVFRTG1wJvwfoCRMJGFXMian99Wrq1wbCVE+4iDvzJtYKanSqDcjlwlnwXYNoLW1gP+HClybcp5umNZI86Zt3e+33/xVc7ht9zr6pzcb6VACx+zSpA79vszLh2P2HYmKELCCDAClXbBYJRTJ8K2J/pTm5FP2ctjJ+k+Mcd0OafStxC+P59Ge57fEidIp9XBBkmm9jYlY4DAEpDYStpecpv8XnL0ckrTKchCvLeqx3a+lhyqWVGHqxEB5W73GTjFAQ4Xs6WyIR2P0IK59TiDpeB/0lmibPRrK8C0lucl0pStnvpT69ISsljtIwnh6L4QQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a19265c-eb2c-4826-6767-08ded8ee5957
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:14.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gFtObZFJDdVqv9MgF0e1NX8YVS0q7qZwKB8MxdWJ8TtvHLqWCQ06YURm+16xCdcMAjBCPGY7vSEKS4tTndOtog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: hd3azS6h5E1joeo3WHe5FnSYVBos7QBI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX3YLoaOCUlqyv
 0hpsL1/K3epAlnN1+wCUGlwfwBEHLIPEG1+ePNe/mjWmumtR3jg93NuZLClzZzrzuuLd2991JG9
 s97DPKraa2C7Q93/3FfSQeaisoKgqaSFRjUeqzBlEJk/qZGkFsGdtPC+cZFYq3+tcCnGn6l8Yho
 jNtcvd5WAsikC6Vrum9q1X6JgpfWs7MC0aIyNT5g1UpkmbU+kk5nb+Jc8r9AC7DfiYNaaq8qCv2
 nKmOQkDHUtjG0tC2wnn9WET5l1l2BAkAfompg89x0u1GTMDdXfBogBzXM9VM8LFMS9W+DIwTLVV
 h4rd2goRgnLxHJZVc8l4tDkXlhNVbC3nQQKwLS788YULspU57BHwEN9EvFPHvciM6bbEopE8XGV
 lArIMbYzzorLy1DsvioX3LLys3oKLNFFe65RnrCXQHg6WjC4dRKN5D+Uiw/mPNh8nUuotZ3gEHN
 GNWk+M6lnNa2x+JSYbg==
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a478fb5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=iqRKemep2BTn628LUkAA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: hd3azS6h5E1joeo3WHe5FnSYVBos7QBI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX+dyHLhWWmbQw
 mYtLFpFKDtJqXErFBoNtAFfnCpQXiDswfqAtQhHCjGRfV3AEmIu4tmvZu3dt5XwRw8q3sfMaGJw
 fw9V0vXR4CUsYlkp2LSdxFhCVjXLQyRbDz0N1JWho27TB28boen8

Add initial support, as follows:
- Add mpath_head_template
- Add mpath_device in nvme_ns
- Add mpath_disk pointer to head structure

Initially all the functionality which mpath_head_template points to will be
unused, until the driver fully switches to libmultipath. Otherwise it's
hard to do so in a step-wise fashion without breaking functionality.

Many of the libmultipath-based function added will reference the
ns mpath_device, so add that now. Also add the NS head disk pointer for the
same reason.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/Kconfig     | 1 +
 drivers/nvme/host/multipath.c | 4 ++++
 drivers/nvme/host/nvme.h      | 8 ++++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 31974c7dd20c9..1b3f76e781bad 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NVME_CORE
 	tristate
+	select LIBMULTIPATH
 
 config BLK_DEV_NVME
 	tristate "NVM Express block device"
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 9b9a657fa330f..14947736744a5 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1496,3 +1496,7 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 	ctrl->ana_log_buf = NULL;
 	ctrl->ana_log_size = 0;
 }
+
+__maybe_unused
+static const struct mpath_head_template mpdt = {
+};
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 824651cc898db..3e023948015ac 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -13,6 +13,7 @@
 #include <linux/blk-mq.h>
 #include <linux/sed-opal.h>
 #include <linux/fault-inject.h>
+#include <linux/multipath.h>
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
@@ -560,6 +561,8 @@ struct nvme_ns_head {
 
 	u16			nr_plids;
 	u16			*plids;
+
+	struct mpath_head	mpath_head;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
@@ -590,6 +593,7 @@ enum nvme_ns_features {
 };
 
 struct nvme_ns {
+	struct mpath_device mpath_device;
 	struct list_head list;
 
 	struct nvme_ctrl *ctrl;
@@ -620,6 +624,10 @@ struct nvme_ns {
 	struct nvme_fault_inject fault_inject;
 };
 
+#define nvme_mpath_to_ns(d) container_of(d, struct nvme_ns, mpath_device)
+#define nvme_mpath_to_ns_head(h) \
+		container_of(h, struct nvme_ns_head, mpath_head)
+
 /* NVMe ns supports metadata actions by the controller (generate/strip) */
 static inline bool nvme_ns_has_pi(struct nvme_ns_head *head)
 {
-- 
2.43.7

