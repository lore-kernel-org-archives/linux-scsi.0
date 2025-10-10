Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F8C2F7454;
	Fri, 10 Oct 2025 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105741; cv=fail; b=MEpgD5vsUHy1OLA/izb0wuKzajqSdVB2yJaHa2Fp1WzKQP1xKK489I+lBz/nbRjhFgmL1cbQh7Ri63RWt03OvEgcumhYP8TiMtB05ecilPOU6FQfArL1hsXPqcMN8nNqbFe5P7Ic8yAHW2IhhgfA/o3saHiFPMSSGVY85jlIU6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105741; c=relaxed/simple;
	bh=9b+Ark5D44GpMbHohCHYfRc4ctR6l9R2t9Fjr5z1yvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=frgw6eC0bvMx6rkwx0hTaokDWXqjHbCa1aMg4uy0gWIXRvvy4xo/17Ri77jLNyYKVaV5VHcEhCSc7nRIFACay082ahmuN0J2NNe0ZoyjQV27N64ziVWi9+3SwzysCW+x24rt9A3S7+jOXqOpQLUrw5UDb02bPSQgQ1wkYegowPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fb5L8+hr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UoZ/frfi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fb5L8+hr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UoZ/frfi"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tVtC032558;
	Fri, 10 Oct 2025 14:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SY9Zl8G+mlg759c4/3hpMBD3tAj5/ygRizFMcakZ6fg=; b=
	fb5L8+hrVMIZodhtfsGdN5qkzGWOhB49iyNnUKYHtviSbUJ1/b8+01EoYzHT5GDm
	wzmvz8y4LfcUD5avxWq2k2zkYyExOmXFPHWpm/Yewn503AxmmqgN/fwMoSrQG1yA
	flUumrXyOSGCEczUn6kuBSGTtW5c1JwXa7ozpu8mmH+eSiHF+yWmbmzVI3/NO3rH
	+5N1/UIlfHwQvqLOHOW28jrcr4Qt42Llz6HiVxVV4gSqLeEmOW9sV6V3b0OtIrzk
	npEaRJPkVCOKJnqvubP6CDbRuHCasV8dK+iU+9sce3JxIzvqlo6bI2RNRQ1G8nXO
	4QsgQdatHFaOak/Xs4Y+Hg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv6d3t84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ACYDTt036971;
	Fri, 10 Oct 2025 14:15:36 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49nv659qpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EQamdwOVfzC6XSm9QwQyBBkrCfzbOm6b4fz4B4DmipI5oztMyOce7xNbW5KDbt/+MrAvy6USopbWhL3J1q6EyIPnLht0J0kKn6uI3YOUS2SQQnCQXYM/L40sFsPkoi+ADcGyubY0HdZMPx1hoPjcHwgKJc94rGGMCFOprN1F3neiSijbNhY2M+jXWoao6xw9GJen1Vy4/HbxCP15WqJPIjb3SZuSPl1kNUo9udNkY77VjPQYE6YGxoHRfFHgpcUv14A+wdk1O51pyWILILbOppggLc6/rT6cmHZ/XlyBSOd5Sl3UV0IOhetbZSqtY5ezCdyPUJLeAwFSYebgnBWGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SY9Zl8G+mlg759c4/3hpMBD3tAj5/ygRizFMcakZ6fg=;
 b=y7QQnxN0CTBfKZ9R4TImA+ICWzNa8U3Dp9DiL9Jq0wST9u9fBYsQ8wa8C69ywbpZa/Qo4/lPfV+Emg2jlHmofq7nF4yZm9mR6VRzJWFhadjoR6rsbktZi/5Dklmu+mTNTePWTIRBDSXd72+DOVyO0qCksOi6CNmkxve25H3P8Ac/9zKcEU6fsXwmXg3O7F+6KWOsuvcmstKdSq8oPIIKCCK6XIvwZv8hFArh73p/mqenLfi+jNR3AOar3A8XB145ihV2N8NQ6KiaG0XtACucwlI0QJhNyxhLzYJtUqAVKIsJ9eE4uz6YbmG6qnIZnUpFVVse34TnHVYggdraedLeuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SY9Zl8G+mlg759c4/3hpMBD3tAj5/ygRizFMcakZ6fg=;
 b=UoZ/frfi6ZV98dY0d932PgpTcx/eSq+HY5p2c7lqXXloV57EdzqUjr5nnUXGZgXAKBY9Y18QV6JP/35dahbG5iPxuBkiF23yTkKsxL0bphyI+oMhrACrOGJLI7dwExbaOTTfAeClcrX+n38Exdhb2UOtQkHHMljnp65otHsW5MQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:33 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 4/7] scsi: target: Add WRITE_ATOMIC_16 handler
Date: Fri, 10 Oct 2025 14:15:05 +0000
Message-ID: <20251010141508.3695908-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251010141508.3695908-1-john.g.garry@oracle.com>
References: <20251010141508.3695908-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:217::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e71524-27f9-4599-6b82-08de0807791a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4sRdEbDbMoul/jLawWr3sk+oV42iKSnn1bBpVMCMFwlwyL9kavCTB9aLgGoa?=
 =?us-ascii?Q?8g3qPn7ZxobO40E4ysWYq6bEpl72nHmMkdTpNHHKdFmOLdS2Lsh8UGs7a9AK?=
 =?us-ascii?Q?EX4VEqQbWODjxUzkYoaBNFtIkdjehg4Utz9E/Re/PXYfrYmZ6lPtNr9LVxNl?=
 =?us-ascii?Q?zUJZFpXy1J/+EZ2uHPdwmYfHYVSP1ZqNKgAdgkrm3zkXQvTrbuLFmpUlUG3N?=
 =?us-ascii?Q?nBcl9LAoRpL0XsEYgtfsJueSZfmzlWgK1kQI5nfFEne6pVwxDUUr0qwJ48+E?=
 =?us-ascii?Q?Geo4/dJPVh0153BfxXZaeFa+M3gbdpPhoyhhCLEwCwGcOlWBSPRH7LMr/klB?=
 =?us-ascii?Q?kKpTibK5lSR3QVNHP8U8Ej/fjOigqk0Z85OZOBj/ljHRVE/Jrlkqipul0zqd?=
 =?us-ascii?Q?QcnKMImCP43EmfBvElXT0+upr3aN/59BzqgpuWNjEIhUcdsxanc1Z/BuSIqJ?=
 =?us-ascii?Q?jOvbORlCJyq4DRNy5BBHXUNOt/HfDEb0flAn89jgySPwQcisYQ1EMPcnKKJG?=
 =?us-ascii?Q?2eThGXxPutXbZqYqAD2e9+oPWooYadidMa3+27tTvptkjAyysIEyky4Jv9JJ?=
 =?us-ascii?Q?SRi+9NI5qEOOx3agKO7PZxlqzb2hbSKT6gg2dK09J9epiv9X9zpBefnSp08V?=
 =?us-ascii?Q?M00mYdtwOmPNrjp1NEArk3sWYpFP5mYQcang4eWYzeHPFKmF42XO877mBvjw?=
 =?us-ascii?Q?nPD+14NlKv7OJ68lCS521hYfkP2vVRWUj3f/uCwv73faliLU3wan6egTltJv?=
 =?us-ascii?Q?xJQGOqJylUoL5HUdpvC4+kBtNchQzOKb2RSA3AW2dP+0s3V3lBmBFMS0onnX?=
 =?us-ascii?Q?XLxYu26WH9LkrvBDEkCw63ozDeHWn0Xi0XohCwhUCQtsMkpDL43gBhtueO+s?=
 =?us-ascii?Q?hCHgV/MAJ24pUJdYSBv+pIwwWg+umJzCs75yuJ6jWAg0OydCGRIWVUTHYMNz?=
 =?us-ascii?Q?aDcgR7O9nJ1xVZpgEZ3FQJ/qDk1kKQOyvCwLs2NhEKuM0K/Ol7e1bn23QZ0P?=
 =?us-ascii?Q?LZ7ECgZp6i5Th2sVSVX/xPWsV9vVhE+w4eL7qemYXgh0eqVDKrMemaQZiwed?=
 =?us-ascii?Q?TLJuq3CqX7fT3KerCcA9auV2EeFQMDMqTYc7daWVCwJBvQd4l2Kye8yaAwCt?=
 =?us-ascii?Q?SMwny6z/mSnHt6wo1tMDeav2bLs1MNUdwPR6jfo9GSrgx3oRa+Ax7XanaUeh?=
 =?us-ascii?Q?olp7+xztM0raB5MgXXjYj6pw/BodqOYkUyUo48wj622phWEHbGevQ11Xygf9?=
 =?us-ascii?Q?Ltx6w8/hTSqXUVM1b5KmSR6sEUdHu8iSkwjwtX6Yje/4+169XSSzveOgYMXO?=
 =?us-ascii?Q?fEzUwxyuibsvuMvVmloLBUqZTh5+1QSTtUutEAxxECwxlseLzdBA5097vwjV?=
 =?us-ascii?Q?X26O71wvo6p6JVjyPMnHtBBXDiEFozVu9c6Ca2kVe7qD6/gtnjLlBtesLat2?=
 =?us-ascii?Q?L9nvOlDDMVINzpXs6P7MmRERzYlt7Wp/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y/YarmHs4184UcwLZXkh8oeMtAIxY2GeaH/8Q5gtU+9o90g5oRyeTDp545Q7?=
 =?us-ascii?Q?0FQiE9ItWOHZNDM5LaDFy+R1Ytl2kdAQpmtYE74bBZVl5y/sBD7XO3tbuItO?=
 =?us-ascii?Q?4snTjzwMwZ5I2Rh7GkcHDq8kMs1hIFrFJFj4tf0Yw91lQ4E1ACPz4dSZRJFr?=
 =?us-ascii?Q?m6K+ssXkOZY+zSq7z4PG5irUjtiQs4FYC51popbThBEAx+UA+k7xMlV41KrJ?=
 =?us-ascii?Q?lFwUD8MDmw06kWq8NqTDuH8vYDTzTikg2rSrAdsShN4AXrYUWnwnoJFhnaQq?=
 =?us-ascii?Q?jm0GgVNQUUr52pt4kNbnExvFcd51WelmbrkoceQJ/i0PYbuqFL9vlxEQJuc5?=
 =?us-ascii?Q?o5trmgSXKz7sBCyDOUZa38lqmZ8GnL1SZf86YnwxsXOBi7KpRzPfj1sZ4K/N?=
 =?us-ascii?Q?M+zFxLBXYQnTUsyqFOLoc3r68Dp7Hg//aqfKftuYylgmMBN/fzaA1JQPldiE?=
 =?us-ascii?Q?6aoAoMAu+GBdnExi4CTsWxMdUjrIM4ycHvLjTxyoZX8MaGbVYdVW8MhxWMxZ?=
 =?us-ascii?Q?41ajnlgQi/xAnBfM6i4AnULbUEBj4M1/QxWNGbAerfVKPA3x2OFRuqJheRJs?=
 =?us-ascii?Q?5s045eFL0F83tixB1zeFX05irzXvTeKo83njIblQzi4bWDzSbV0UrMt4ttrp?=
 =?us-ascii?Q?6h3BP8+wsS6F+pfWmbAjf1a5Wc1+4Uxs5BMzWYfPulxTASxelq/kwn8bECAO?=
 =?us-ascii?Q?2CFAr/+7HHPV+iNrm+2WK4tmMAB/X3to+oeW1/jG2o+eqJwCSEhMB9P034G3?=
 =?us-ascii?Q?ggL+XCL9tmu5Alyqi5sF/xAZG+D1V/Dh4Y2eOrOUkmmlgKRjtO/M0rcNbBSH?=
 =?us-ascii?Q?f1o2qSpiliR+K+ID8YoH72L2r40Hz6KGJ8tryi8buDhFOQN5HSc73TguSo7e?=
 =?us-ascii?Q?DtGfRwy2tZ8hBA0d0ahaeZ/8FOF+NU+cOPElp11inciTU2TxG4XBFRKFPGne?=
 =?us-ascii?Q?8COEe0e2Mp8EE6B8wHErt0oE1pwGCBm9Mta7cZ/eG4CAVDAFxuuOotmYK3Hj?=
 =?us-ascii?Q?6lsPxK0d2lCVIwbEnKpZRqLPlHMTkMXfsSvrGQ3/Yv7crZrBLLAniYF59+4T?=
 =?us-ascii?Q?eEhAXzobmHkSTNdCOka5nL6BGzNSWPM2EfO6mF7Cs8MNOfOo23A9bq4Ir9Lr?=
 =?us-ascii?Q?+J6eEB4EMprWp9SIDMJ+gXzW0aACdF2VNgWQtkNgxY4apiTbfqSpLtICbNhi?=
 =?us-ascii?Q?Kx2DoWfh4Ignyv11z7OdxBponc4i3TWL1ofm7gVFp1lR+TLbfISXamzt3Rp3?=
 =?us-ascii?Q?M32SPMYo3nODA9apy8LJ6RlLxNhsBEoGCxcw2+8XyJLeR0WDOjzISPIEB5tY?=
 =?us-ascii?Q?GUgVDgoUXLuIJ6P93PBpADeckfoUzZcK2pXdmY0SRU02sJ/wH1Ti4KrEN35f?=
 =?us-ascii?Q?jNBkbQWfE+jrU7dKJh49Telms9wlN12MfZyX2PENFCNzz8nclpSnCWQoRkF8?=
 =?us-ascii?Q?+q5k5IcmOTVxymNWcmyjfajIRK3NfunrgnTwJIaQ4CQWK7LjBiYDNfg4gMCj?=
 =?us-ascii?Q?jn4Ao+mBEHTyApD2e2eDzGnPcMBaGRn5fgEy8LknK3HNToknNSqpQp5OJpfL?=
 =?us-ascii?Q?lKJWkF+0D6QeooOboefg33kxeprjLMrVpjgLKgdI7eK+4Y6jmKcy+nU5lFuu?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dur0xxLv/WKo9+RFnj0uDFrD0dM6XXZXsjJ252UH6ezKuvQOromxBT3kwwKGPHzfSjvEaxhEUHzEqcE2zc1wykHcJ6hjrFyO5bQaU5ZbBzXFeZ0DtVWoFAKcdmy8bNvDuNwZE6pbZ4SL2v6Y33QYNy6/Nh/Qtpzzu25Bb6u017adjTNRYqlAKyEO55XsgSAlgG86yRFgWX8qgnoaUDxKCrjd8iB81JINrgRjwRgXTyvJQC+cMXl+IUtbL7YcFPwklLE98mqjSzVx7/wg7a7zZ/7VNFBHkvDtucstkloju0TXnkDx4a0Xl31WjpfxfTsnkTIdZ21rREOvUHEZ7cPXewYz0BrRasod9gk4HFrEC92Xld6jVkbdoDKeFcjzSraFHt2pzjM3qNoy3CzugrJCLCcyIj+o5+2ltyvpDAhHc8VDpbDKhA+zGtUs2qxwaXonVwjbDCmRIVMA0F5/cnPH8JQOXyzZU6zsdghvLyh5eLSk6fR4qoXTrDZwfAoqcRgpPZPosCaB8i/rrZkebwcbhe3B4c0t8pDx9XUgDyhHr4r8vGtCa7K3uR/XRPjfn9soynopoUVo7ftFIztPtK7VMnivP36/fIvibAGlLfAMtLY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e71524-27f9-4599-6b82-08de0807791a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:33.2110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFzYDLFc4Lapg4nvOcpElgInu/Pb+qatkiGHsRoKE0lzP9MzHqsKs4spUvftfSQcIPEObnGAU5MHUFHz6dXmLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510100082
X-Proofpoint-ORIG-GUID: 7JJTZAjjHj_7EiwBWd4mN-dGr7A0DLfY
X-Authority-Analysis: v=2.4 cv=bK4b4f+Z c=1 sm=1 tr=0 ts=68e91508 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=bQE1qtad07Y6YyxsdVIA:9 cc=ntf
 awl=host:13624
X-Proofpoint-GUID: 7JJTZAjjHj_7EiwBWd4mN-dGr7A0DLfY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX+rr85fd7UwFH
 kOSmX4jcLKNprHn5pIKANRMfUyBYRcYWYH3/E7DtXdln/fh07nsM/dH/XAZg8BXFSgm6yyI3UaK
 pNvA6+gFjNOb6b4XrsJCynx7+NR0lMgojdzU5mK60Z5k//grGFzWPxd6k0mMavBKYjZ1cljdAYs
 lY0NWSO0zU3CPciJN/dY2/bfVPEplRvSZgcVv22Ljim5tys2UIW+O/tbo0urpYsoS89uWRxkSFK
 jzKJ3ldmDtrmTn8wmWYfll9blxYSp8qadvyUhgYecyLji6Iam7UbjjzBd9XliYT41k8nPmhvlYv
 N8O+Vz76UV0g63s0MbL+KRVW8Y2K50xxpnO1pEiUPg/VDgxw1dPCNSAstjoTqm5Xp/986vDDvEv
 mxuWVNDSIyppDOFgfZHb4+7b6J3DIOyqkJSLrFwg0YG9ziyEb6E=

From: Mike Christie <michael.christie@oracle.com>

This adds the core LIO code to process the WRITE_ATOMIC_16 command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: fix return code from sbc_check_atomic, reformat
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_sbc.c  | 49 +++++++++++++++++++++++++++++++
 include/target/target_core_base.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index fe8beb7dbab12..2878cbc3e79df 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -764,6 +764,47 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	return 0;
 }
 
+static sense_reason_t
+sbc_check_atomic(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
+{
+	struct se_dev_attrib *attrib = &dev->dev_attrib;
+	u16 boundary, transfer_len;
+	u64 lba;
+
+	lba = transport_lba_64(cdb);
+	boundary = get_unaligned_be16(&cdb[10]);
+	transfer_len = get_unaligned_be16(&cdb[12]);
+
+	if (!attrib->atomic_max_len)
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+
+	if (boundary) {
+		if (transfer_len > attrib->atomic_max_with_boundary)
+			return TCM_INVALID_CDB_FIELD;
+
+		if (boundary > attrib->atomic_max_boundary)
+			return TCM_INVALID_CDB_FIELD;
+	} else {
+		if (transfer_len > attrib->atomic_max_len)
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (attrib->atomic_granularity) {
+		if (transfer_len % attrib->atomic_granularity)
+			return TCM_INVALID_CDB_FIELD;
+
+		if (boundary && boundary % attrib->atomic_granularity)
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (dev->dev_attrib.atomic_alignment) {
+		if (lba % dev->dev_attrib.atomic_alignment)
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	return 0;
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 {
@@ -861,6 +902,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		break;
 	case WRITE_16:
 	case WRITE_VERIFY_16:
+	case WRITE_ATOMIC_16:
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 
@@ -872,6 +914,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			return ret;
 
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
+		if (cdb[0] == WRITE_ATOMIC_16) {
+			cmd->se_cmd_flags |= SCF_ATOMIC;
+
+			ret = sbc_check_atomic(dev, cmd, cdb);
+			if (ret)
+				return ret;
+		}
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case VARIABLE_LENGTH_CMD:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 70ece58d30780..56333b5726c8b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -158,6 +158,7 @@ enum se_cmd_flags_table {
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
 	SCF_TASK_ORDERED_SYNC			= (1 << 19),
+	SCF_ATOMIC				= (1 << 20),
 };
 
 /*
-- 
2.43.5

