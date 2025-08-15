Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012047.outbound.protection.outlook.com [52.101.126.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8B7212571;
	Fri, 15 Aug 2025 12:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755260187; cv=fail; b=nCD0Jtlfg3rrAGhst2s4FrCHWww/f9nvkX1p6Y56IQjgfI4qpnCTCNgzpUXcj2sqU4ImtLEWoE2HaZemYsZiqN7SD2e7G1R6aE24b6IO58+Iep6Y2G7MJS4NXVdsNY4+3YsihR1GAyZ7Dcw8ZUKakwSRtHg2qjUiASSaCQkxKls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755260187; c=relaxed/simple;
	bh=stZk+tejguAj0xNIi2cv1NYnZlRYxSrhzWJUqYH8Ck4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=J6j+uIHXlxY+5HYoQz5xDuUxVbgUono1XENqUFzj/i8ry/3SLd99XX+wTrqnMFEQm9VTmqIH9peEA9QxvcJYV6g5TAuY6hVcQ4rQOa7xij/HKAYDE1rHNzQjxHk9MYILsDWsZ/d1/nLs6cLMGfGPpgYCsJRYO+69d0QF58w7u1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=WNsb9Cw8; arc=fail smtp.client-ip=52.101.126.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="WNsb9Cw8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I3d6hF/jk9BBXgWsWLSrYotp4La0GuTUPrvtoXlHDa3pywzubUMkde+r50aNclaqLHBxE4hOGKNOjthyzSxOqWxy9shIWETkDgEsYqMxx/+GureR3IIaIkXIl+Thts+ttd6xSxho2oid2FtoL31MMChdPGl5ABdH0pvG+z6lcCWl1Ofai1HnezqaH3bM/BmJwfzYu9T8q1M8F38WF72QEJpKoGjzqGlIZarBTLd6tKwg4qba1ngTETSYNPhwOteyzG9HNryVXsCjW53gfmX4ft4j+6smDEKu3dY4bMkXPdbk/5dTdSpMoDcapRX7lan4yHFFsb0An9j1fBNn0Tdjwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fYBY2mbuSnYQB07vYIOtIWrZXXCqOXefB0xccUTdqU4=;
 b=a63rkOLMf4JvufMoadu/f2OK+T214OdzxvZzZ1NP3jU8L7EYRhDuDMvtQqO9p1Y+kr6J1p/C3L5fmuH0P4A3HwJZVvESfK2r34xPTcI3fbJspxKtBo2YEFqlaQSQ50Bi4z1+XOr9B7OyfG2NVozMFGE/nOcfrqBiwfToRoA2pnQlC1CjwYsqvTwnwmQsNxPz0r8TyPJXduY7UYawFuCsegjrc9HIEdktJ83jA/J3Cx2snYl0jVf8fYTJn+cUZ4LItoPtmD7/fthgkcWIOJ9UAfNGktX27iHdSWMGavomVBcYCJ3ItV7+0BWSJlt5LnoaljY+EssH4VvKyrJGFWIQew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYBY2mbuSnYQB07vYIOtIWrZXXCqOXefB0xccUTdqU4=;
 b=WNsb9Cw80egoGmTgQXVCq8bgNcu6xboe4m5NCkJcxljRj9fAs5zYJ/g7Jm+n4r+rb/JqnmoZgAtQuMf7RLom44lUUG6i6RU6wfb3otU2au6K0CdBs5am3fMydVd7sfijMe9AtiOr9X14ND9WRHDdYJAQgmtylzkF/UY22K1mLy0vnlY6lPe3Y3zOqVfEBpRbriDSMqMIVz7RiQUg6ZIYCB3XKXL12D49SV+F8LiUd0Rwvmq92FNJK5/u9m2GDNgtXtf3+bj4efDjBN8czw13xVkTHYFMlg1aYAygy0olpjPQtakDtV+MXm9ls920ta9oMHiLaqKllIKbV6+NXeYxRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6896.apcprd06.prod.outlook.com (2603:1096:405:22::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Fri, 15 Aug 2025 12:16:22 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:16:22 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Don Brace <don.brace@microchip.com>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-scsi@vger.kernel.org (open list:BROCADE BFA FC SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list),
	storagedev@microchip.com (open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)),
	megaraidlinux.pdl@broadcom.com (open list:MEGARAID SCSI/SAS DRIVERS),
	mpi3mr-linuxdrv.pdl@broadcom.com (open list:BROADCOM MPI3 STORAGE CONTROLLER DRIVER)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 0/6] scsi: use min()/min_t()/max() to improve code
Date: Fri, 15 Aug 2025 20:16:02 +0800
Message-Id: <20250815121609.384914-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0196.jpnprd01.prod.outlook.com
 (2603:1096:404:29::16) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 71c0be2c-7b75-401e-7b4f-08dddbf58c13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|7416014|376014|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fL/vcPz8Vs+Hx9Uy5Nwy+Hy1lqasUWheP1pQRQL+BfEf4ab3i3GPazbu6oMU?=
 =?us-ascii?Q?hsR9+NmZ6j8xpOxkSeIb59kj5nt4q3rfcCi6diLO2jWzozSYz6KKjDnkrNdM?=
 =?us-ascii?Q?z+q9qQyIu1d8m15A8gLppzuXseIYsKYoSH+oNdLquJnGrFeiaUiylgGa3fUQ?=
 =?us-ascii?Q?ofZe1as6TkBIjkQWZRBzlPl/LVp8pzz3nGIY1bi8CcwHDLUw5kVENBf5Tuw0?=
 =?us-ascii?Q?DRzBfJXf41BHA6o8nd/m02Kr7/rlB57/q62oxb8DfzeAIu9Vp1RmECgEgLdM?=
 =?us-ascii?Q?S5+ddlfuikz1OI3hL4wXd8IT/b0deyqgTNKoNGWTSk8aObcu2KLqhg8zZCQz?=
 =?us-ascii?Q?pKGk34vJ9+Q9es4v5Y2OsxcHOZa0vCz3F1vWrmzAO4gOkGdGXAtMjN6GKgQ2?=
 =?us-ascii?Q?qQxYaFbSulwMxdIdbskPQVuf3uz+HkL+20FWRB/jXZ5+tR2ruzou5PhvMX4P?=
 =?us-ascii?Q?ZL7gTYRZk1F93pvLxvc/pkoKhnGvPJGEnFk+bYTX+7Gbuhh62aRL3HmkuRfO?=
 =?us-ascii?Q?WvC6n4+RXxhoqUScKu9SIsE7rG0e2Z8ZGmvHQD/+2QWCj5Vnx5B6rv4zN3ov?=
 =?us-ascii?Q?Hx3ByW8/XiFokdtkqB+HGrbo9qVezvpoB5gj/faJBTK9iTN56GeQFa/0Ag0p?=
 =?us-ascii?Q?GPhGihjuk+AIid3WdQi5GEoCvNJwb2QB07kxJpHWfJ4GSz6uWjvZPXNy2LJV?=
 =?us-ascii?Q?5jeyG8TV1GhW0NiRZ2VbrCRo7iifUHNQIAJj2qtBxDZ34RCNrjmxPR8ih+OG?=
 =?us-ascii?Q?sidmDdyZXItKN0DY+vnuz7K3CcaUOBGkd4OS03k45BGcQmfBMx/VragELWB4?=
 =?us-ascii?Q?hj9rBMnE+lPQkld5BIJndjiaFSgxKM03BFJ7j7TvDQcQKvzYp+D+vT7Jtzkg?=
 =?us-ascii?Q?AsRhylwuCS5RRUA2M5hNrx1PsvVlltrPTLSxKctcXc/wLODa8jtYVgDsGJkS?=
 =?us-ascii?Q?S6HlR6mt1SHhy2edFxcs18TXLO1hPlGEwLxN6L6Xu+toMesWVmi7IEI7u93/?=
 =?us-ascii?Q?nMMrBJpimE5P2lTMScrPKywvTGVLRh8/bSmDPEnmYAuHGp5MylfKrC7qc3qt?=
 =?us-ascii?Q?6f4lz0DSiFVXSccxa2w+ScsX7eeYwjhBRe11sYQjB8iOF2ktBFnCu72+ftW8?=
 =?us-ascii?Q?R54pxXWVEmT+u3kYFSSzg13UwOrDCzNKBJZ+Xo/rBB4QPBKfoq3hDp4OsIDz?=
 =?us-ascii?Q?gn2QkMt6qRic+33vZ7cLjZcKg/Fpz78oYkEz06wO4ReMa0YcE0tnnFRFClw7?=
 =?us-ascii?Q?V7qfs5TQA+Ck9j0NZtUsCFJ3WYc/nF8r2aFrl3vMU5OgB4aBT5BqkaZGmov/?=
 =?us-ascii?Q?NjXO93fVxC/fdGawaURIuYDj/a1yoDq4HBSlpJXoPSJLiCzTMkHPudRjiMtO?=
 =?us-ascii?Q?7vhvkyF+864Cbi23fdLd8QXsdls9AUNrLb5bKcOodZeUvnQY6w6WBUT1ruDH?=
 =?us-ascii?Q?M0Xa7s9DiryYqi+KDP5zMAbHs5nr6MbEAMP2NTaZ9mGR8uYeh+MmR7cJz/N4?=
 =?us-ascii?Q?fdJSDp4VUEuWJfI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(7416014)(376014)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GNnAyyx6q0G34U/CuTDblKFv11HjofrWPOM349Rxqsx2T/ummysZ8Pgto8gc?=
 =?us-ascii?Q?/QvEInXmSHBDg7ao0bopMH4rFCedIhjtJV0ZCTxjARszj+f5rQ91xH/guI9s?=
 =?us-ascii?Q?7fjqKzrwU8VOxCgr3Rc5t4sw3nms/S0SuQGNtBAEcU+Cm5XRMgbVMsB8vCNo?=
 =?us-ascii?Q?wS8paWah7p9kcVdoXE3euMyE7WktWEHu0uXOJFgV8zZWQir+PGzedVetN7zY?=
 =?us-ascii?Q?jij/esyJ7ARPKxeSblPzb60UMrUogheF2Aqdha9NyFzYMF7vMVzFGWe1fj1u?=
 =?us-ascii?Q?azYaF2sNmUqsSHCQCd/FfW1Tdpc8j1+DCMUVcnSG/x9ouJUl6hAcEvoTcUUv?=
 =?us-ascii?Q?xU9/iwXVCkOd/s6SxwfKjUBK/f9d9kQK1Rzk17KAflxcOIiZ1aPzdxg6Ta1u?=
 =?us-ascii?Q?SG6CXt9S1QQczPvIioGX+PzSONhsyOF2+iAsesPOGTnOVPKdjEbNyZXYTljW?=
 =?us-ascii?Q?fphPtAfpPBI8/9UlQ5mXcgYf3hVMGDNYJ2u704Gfhu+Rns441A2ydxFt6Cqr?=
 =?us-ascii?Q?Zn7mPskhtLdFgfWLRBrwDjwazKJNmOyo+0Ud2evbUzLdEoQDlKGvPsTGKQ7/?=
 =?us-ascii?Q?VdUfu4cYGOPPWEKEmkTe1Ry0H/3BaDdvorP+v6vmEtwBll4IOdJyVmdgtp7I?=
 =?us-ascii?Q?m2+JlzEyovcduDaWPE+ATimrfsVRwKtjIEuWgKgw00SvWaRB8xBC9GY6gD9X?=
 =?us-ascii?Q?XRzjKIKeBxr1xURLDONld9VdDY9ER9O4E0Eqt6TYH5h5L3jPXVD+j3Z0Nj/l?=
 =?us-ascii?Q?Nzx20g1NZUYGGJOy9IOkI/cbmcurel66ISy1/mVhc7VwPH9QQK+ZrfL9zX1O?=
 =?us-ascii?Q?BhCq9pGRSFuGhwgBegUuTbleiJ9NSoFZN+Cz1+iDVr+IhF4oCh5t7Uc2LYPW?=
 =?us-ascii?Q?JH7QBY4PeqRaQ7p7OJj2f0UrxZUUU5zBTPexUT2gW2tDxXGJi9uJLHlI6q3o?=
 =?us-ascii?Q?q7kpticwzZMEEpu/c0Kd5LCj7y6u3jUXT1hAS9PBsMF8gKPupr3/rgXYFiY4?=
 =?us-ascii?Q?GUF3WGtSoKGomWNlbvUZfPZknjkH0VrlHdUIrOqI7zYx78X3CgTzzQJq66SE?=
 =?us-ascii?Q?oBLFa3NKbfGTeW/q/ZxQuqOVnmidoKc6l5HSLcI6SbYWGQS9FkM0NelCIxj9?=
 =?us-ascii?Q?dG/ZfKDkzybz6QnQ6eReJDCQGrmrvAmIqWglr6RbMuT/0S8H5G+YO9s1hMLC?=
 =?us-ascii?Q?xCF3Rx6+2qA1Ux+z7IVs5d3xr4NMR4oPIq2dOQ+W2Eyy1X6CkptjGAT4Q3sM?=
 =?us-ascii?Q?jZfOsm+PBIm+ZgvTuI1kBYod1ESXjYVZxvpz64GtOZXmbBLnepj/6szOdPUB?=
 =?us-ascii?Q?Z+VWQwHa9t/4kHl7lod5ys+xCCaIbN8Z731o86aohfWo2NGWqVmKkrehzrd/?=
 =?us-ascii?Q?81hQPJDdohZJLbErnp8WOj+ZneZW9oAhAro94LW2md1QDu48PwYn1Z0XX9l9?=
 =?us-ascii?Q?89G9NFRwwVwtuefjJgMQulxnlywzONddzfzJCz75U6eAsioXS3Lo2pr16BoY?=
 =?us-ascii?Q?H0uXtdnl+pgoMSa+gcl8q5Rr0I4dbCQmfGTlweNWGMU/3QHObA9LqGwV+zW6?=
 =?us-ascii?Q?uZyX+TxseswhFNAEnYfyL8kNYsT7eo/XPDaUZUe+?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c0be2c-7b75-401e-7b4f-08dddbf58c13
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 12:16:22.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u30+v/rn/JP1oLcREInnD8/P4bPowgfCorNv2g5LktAf3lNqsosi90KYV8aZJicBbpUyqPTI+C0grFiGbn8Bcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6896

Use min()/min_t()/max() to reduce the code and improve readability.

No functional changes.

Qianfeng Rong (6):
  scsi: bfa: use min_t() to improve code
  scsi: hpsa: use min()/min_t() to improve code
  scsi: lpfc: use min() to improve code
  scsi: megaraid_sas: use max() to improve code
  scsi: mpi3mr: use min() to improve codee
  scsi: qla2xxx: use min() to improve code

 drivers/scsi/bfa/bfa_fcs_rport.c          |  8 +++-----
 drivers/scsi/bfa/bfa_svc.c                |  5 +----
 drivers/scsi/hpsa.c                       | 11 +++--------
 drivers/scsi/lpfc/lpfc_init.c             |  5 +----
 drivers/scsi/lpfc/lpfc_nvme.c             |  8 ++------
 drivers/scsi/megaraid/megaraid_sas_base.c |  5 +----
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  7 ++-----
 drivers/scsi/qla2xxx/qla_init.c           |  9 +++------
 8 files changed, 16 insertions(+), 42 deletions(-)

-- 
2.34.1

