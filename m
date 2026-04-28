Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0649401487;
	Tue, 28 Apr 2026 11:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374934; cv=fail; b=iGoJZKOmL6IAEbcgG/geEPFSZeEPGkn1hqEhFvhZNTj7WpjE/908YpPMw9FfPZazZolQANuOXKBr9PiPm8bvmyY+h/rvBxIN94tls4BG/bSh6LvRwSyHU2Ie3mzfAb+tjVke2Rh+3UZ2sWOw92RFiJqNC4e/Cr7epQ6/xOfMyS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374934; c=relaxed/simple;
	bh=Xzh1P14DoBX5r8wihsaRuQn+zcIlLOkrF/eMiz6AP6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fb2LgAbGhbgmT8bxyUq+W6DASyJBnvIwRpmgFTH6EfCOGxLautAaVGSJQ2HM1SMrpXzbZZVsLk0EAbyo+ySdE9le69E6FJwWPJ4fsW0U79zFxRr1iSXAtmYiIYdhT8A2tXLFL2HaQM7TgafyV4P1DvWx3rAg40K9TVVTIJlMLmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y3BxUwB3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LbUvqYQy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y3BxUwB3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LbUvqYQy"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S8KHkn2722020;
	Tue, 28 Apr 2026 11:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uMUn6TlJiAypyVrB8tAaRf3SCfVxHCNGRDY47wSzQi4=; b=
	Y3BxUwB3TY6Hyt7gXd2Mdk5U1Uk/obiMMY6v6IkEmKVcmJ2eXv6h0M2imRxT1n2S
	buK3qiCFUACSVeKjGH8BKYoU8CU6M+Tk86Q0gzCVm/lVHt8baPJmhInDSl0DJMLK
	GP1eDOw9S8kOfUaEwoSf0v5tjjcPLGbrX3hPN0VgjfIFAuKmc53f7LSeGqE28SQQ
	oahaDJxIVRxHzn/8WcaSwsd8x2LLpUOxWeKe04jXeGSQtcdl3qtSFn/LdWisnW0G
	XDxLgScFfrHQy8zL+b1nPgUnVSoOYp7rA/2yfyPso+gcOgcjPKbuOP8b3HzMet0/
	E/ZI71p+hvf7veOAJy4E+Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drn7t78hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCSxK025967;
	Tue, 28 Apr 2026 11:15:17 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013005.outbound.protection.outlook.com [40.93.201.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ckm6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtpxGek54t2A6KmQSYQLV88JsGazWpzR75SHbeSfpXMI15b7vNIUfpr66KpAKqJeUapm7rq6e7JMef+bo7iKavtGQrrUKdmxcJswiDooDynynn5yj48GbUjKekK8JVosXWYg3BegSkdjQUGkyR/dUuJZG7tNZ2WXmMDJQQS62spHbFCVLjAsd6G/Qpia9BrslqYdJrklROfaVsdHlWUGrVFipKHVjvLCpYR6T/80P/qtf6WbtMcb5L5ABGyvChAlZHUzZ6haTuaTaNDgPH2ey6gSxw02cBq97vYGJagaKZ8W0dfYJF9jtdOu5OLBdn6la/lwyOZHEFET473k6wHL+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMUn6TlJiAypyVrB8tAaRf3SCfVxHCNGRDY47wSzQi4=;
 b=WpcmNjp6NPji+qJtVtjKRSsGXXpusjCEtkr3F0yQOjs1vg1TYkTf2QVa+Yl4VmcQyEUBnmB5C85yigqUfJoheOpv8sMzbc2v5NqDkJFqjrksRPPSChQMslTvoxXsZ/buXRjl9+XKh6Zqp0+VMM1Ql1ck4BSFJqsIiVEugusZahAZLxMjV2Ai6wC2O0IGRksbmbZxPHVH4UKQfGYA3R21PZ9sYFMTF/FY7rgLCLa9uErH4Js9jiFeMQFyR/ErO3FCFqvVZ3sPr1Lb+DFSxbWqCgy/XM46zu1lJgV11TMtQ6WI+rWj2Pr6ZMfzUO4WtWwFtVbZNOvaGaIvSuAYyIOcBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMUn6TlJiAypyVrB8tAaRf3SCfVxHCNGRDY47wSzQi4=;
 b=LbUvqYQygnwY+pJZO7Z0/R7X2ZQbqKBfh7tGxjfMBcjmXGVgkSSfWlwjvuB70CI+4DEWSIFKtEwOWcmDa96RY9bhjEklxp8/1CFigthL2D0INYi5Nuyr29hqVPNJU75pkHLIYhGUGCZdC2X+xjpLpoxf0Qd9ASsRf9c5s67zIsk=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:12 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 05/18] scsi-multipath: clone each bio
Date: Tue, 28 Apr 2026 11:14:34 +0000
Message-ID: <20260428111447.1779062-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:610:e5::6) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: b4841d24-3ce3-41e9-21ae-08dea5176a2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DR0QfAep62XVWR616cHu6Kip/pt4/N3tr1lZa1ey5H4M1vwcvO0DItioymygMcT7rsljLFHHVznfGi4dILWA7TtfnoWx6nreIDBgaODXZUsqqnuQxxoAWvKt/yd5oWkoqKlLUukMvWUi2edcxODnFa6bEM1sI11Q6p6gQfNFkzEsUg+c4H2i9S6CmWEdXd9LosfWAJiRtX3XTd+NII2GlMmU2wnjuhOyBXa8zPw2mS/sEk5p2dB+qAAxsZsYplCARRQfSra+Hxct7J3rFyx5uB9dd9PyuiRvZOnc4SsQda+c+Cl7BJw9YYHdML8xVVNLr0ipHC89lBedTM5nQ48woio6dYgK/I8zAbvYaRnkofIK9DAh9zIlAhfUFwIKz8FQeh4pTcoIh6epf0VE/Bz8uc+Dlp3j4tF4sk8yqaCGYTFwwX3aaPgQ2ioZ5K9N1SKPFrw/q1cL3xpSEvveHkq0qvwGK9GBK8kUjAzVTf+WkupRft0mTFTEkYgSnbcyMc3V1XfOSX3Eaj7EssCDWSZ6Pqmdu9G4SulagMH273TmD3RpBuA1gT2NK0EIWh/yC7BAu13L30jNhpJMAs1S2vhY8EPHrGnROOXOTI86QcpCnoT/wLVnbLGUiXNKlMJAmSbfsexZjjq/uoeiCbAMspIDdJPLF9D6bQ8hP2flaLPkwZHdr8fbpwkS5vcvUnnaZr0XCE1BmoZkhM/pBaW7wvSwDXTVu1rE6lMG9UgFb7iPEjQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HcdZbaSFu8P//M4IiHS3kTASmljiXqvGXbVs+FNtjW1YVnzt4X3Uu9P5/PN0?=
 =?us-ascii?Q?AXd7/GzdRHlrDRU83PgxRWMe9oL7Gtk+0Pdgw549sw5hhp3cG99zSE9jsGlt?=
 =?us-ascii?Q?GImcIkxj35nRDSSs14V21j5rb0uvvuw913ecmxFrzdVYEaXvN/BpM43lL6BA?=
 =?us-ascii?Q?kjys69S2wS8kKKHRqvw9FDAPjz2iyBJQ1c4wjrMLXqx0AaiAAtHbBRNjgUML?=
 =?us-ascii?Q?t9n59wNm0bTum11LiZW4ffNy3NQk2k+IF+2az+N2cuyN49EH3/S60NUdNTVj?=
 =?us-ascii?Q?feJcGwcUkGf6j4eeeHQfqYxSqH4Bj7rOEpDB6wsMvtMotUBQfKlSnoPFR50d?=
 =?us-ascii?Q?nEtQkqjE6MjL75SnjgkWoE2pOqWFO2gTBzutz/H45BiUqFrS8SLDe4Wbr2J6?=
 =?us-ascii?Q?4Uq7oHGXUhVMMPX750lX4jYYvMcqyJRIcx4aso1EQOL4Gl7msec+FFnQCVpT?=
 =?us-ascii?Q?26jXUlsfgrkG1U3UrzeKb5v51dbsq8plrwhA7uvawrK2hWMDgP9y4NPIZsqf?=
 =?us-ascii?Q?unCxEQyqBTcpshgNw4LNdmWITfjjzapRCxNz7tD2K/cXVUvCi0r5limKZyF+?=
 =?us-ascii?Q?brebQBAgAJSRJbH7cvol7vzxOFx1lGm1UFMZSHdnc4cOsZ212Ge3VZDMEwt+?=
 =?us-ascii?Q?MWu8WePi2B9216MfFvlZQLZ/DX7o7pg+Z7XZP3TX5/JwIUVnrneb0fy7PFEp?=
 =?us-ascii?Q?TSwhZPKioKdMiL3vHacnixsRFHc/uYadwyDDY+qE2gmUHkHew9hisA7gQJX9?=
 =?us-ascii?Q?/iuBR5AX0UB45hRhwEirBfT1MhEJw7TEHOv4vd2RTcxwV5OATFiSsZA62xG8?=
 =?us-ascii?Q?ScNmAZSTJPbaeQrHnbIrOCqCt9uSzBvsFMIyKn+4WFCjMflCM4fPRSKm00ri?=
 =?us-ascii?Q?O90t/kJGUeixrWJsyMH5oQ2J0QNC1IgUqO15OxKhhgT98uKjCQ6q2ubYv6v4?=
 =?us-ascii?Q?AHoz47aCUBVnALSRekoe7x5hs7ke5+L3rNkRwe5/dbEkHcH5jh7PSiqQILpy?=
 =?us-ascii?Q?ykVQL3TZXmbfayQ8iL2/YAlIY7/O+0pvUISLOOGd97NMnQMu38do9qL9o72m?=
 =?us-ascii?Q?ITYgab0w7sOTpOUifKT4fSrF+p5AQC1xze9XTy1JtzaUHnddEUJIPeEqwn4G?=
 =?us-ascii?Q?KpRjUpvgdvZp2B0US0EFCCIEFta/uk5JPibhSzwcOieRm7n+0VCB5GK0VTe7?=
 =?us-ascii?Q?PZczGJdNrCA7Bz7sgNtWGCpQ5mBQ8nhaMrRY/p362h2DAUHXCJi0X9PcpePi?=
 =?us-ascii?Q?l2ER7RCK/ypV4gaxIyi9TQLFp3nKjSerwUJsl0gKwYNBqztRHT7X8rhiEfWJ?=
 =?us-ascii?Q?uRPdbgYGvXBgjaqxij3FD78hKpLwaRHNyFv89VS88is9MoQ4rLrDXfxeqdpd?=
 =?us-ascii?Q?PUrYtJZYukc62OAfPUgXiMqxbbyptn9TDnjJXxq9FcriSRHgmD9tjQG0xMGh?=
 =?us-ascii?Q?TxldY9CdqM5pVlO/jsgouA8M971M6FP3mj+axnasUufmdAniDn8xuYH7Z0/U?=
 =?us-ascii?Q?z0ZpbANmkhMamsBXzF87f6+DpTRChxh52YuH5jh9gvvSm2an1TFSohOyUvur?=
 =?us-ascii?Q?WRDgH4gKqDzQATeul5Q3N7a97QrDCpJDH0clWSY8xnaBTx8rS+555yk/4rhJ?=
 =?us-ascii?Q?2qckkjvQH6HpRYQA3SsXvqEQ0mqgx3HtPmXGXw8OGR6Z8wayYxoBsdTo6Bbz?=
 =?us-ascii?Q?V5oxYEdaAldEByArqx+CmPzQP70/7wtgwm+jZJOD6nxl6vx8GKywj+RTGrYh?=
 =?us-ascii?Q?B2xSoJ2vx667ssdC0wCm6WcHTCACcHc=3D?=
X-Exchange-RoutingPolicyChecked:
	ByLE6HTxMaURkarinDlXAh3+kdI7QuQRrFLacX/TWZNRWh9GmAtv1yyFapIIFO5oMIEC21X+VfOmmdDHjstm6s2x/yLxQGnFc95jCpOeGcQA7SzUVsw14U26MdejrvH6U/a6JAc65RtSaZ8i2DWM970WwpP4UsBfVL4DfTK/yjTdiRR6i/YGsqJQWwW9+12D74kyLuufdnDXsVwVZa4VWbZPQED7Wq+N5WbP4AlPr/VqcCn4X9Ek8OOui60g8UPImy+zyRhcNEfAKh8OgjJ+v7/CflWQKn9ml1gQXBMSjQp5Nl2srN2d+O2QWT9azMVPuuUItgsNSO/6OrWWgH8+Tg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GJpQQE3Jz1/lM6fFSvpG+1YuSWq8+hEUq8M1ysDM4bESAinY2MJUT+p8krziNVsbzRC6xxwbRzkDuaxAQeq3XnPKSi/QUiWzJx+6znqQbbERezytyNaZaUjmRo7wNMoCbkdq6lkoIEt2W3K9WeEMR6ZwW94D+2tNk8WO+saqLDJJ1cwNXyKYKjndUQf1VtN5flV12wp3d3p9sc0NM7FlzoiXoiHZSCaftaJobIdE05qOQmJgPVcvtJtSKK/aUUlRs8Io5OxcJB9Rwj1HEAiArR0eA9FNZqWumDCYKAYthaNoCq81N/OqS7tncv0aj7HaL/VxGJVVsB0IEZBA1l/CUx+YmcPoFVyDbc4n53oEWpmBdSPJTEb1rLUosyWCkPgoNU5mWe0TUsEKQ35uGd/NgPfLfvLTCDXlBOScgoTksjLjcoozMPcBAnTVUOQUJnIt4gGZEuzmu56ZVH1VzRwQsWTjZKjKYMPUfjSIyiqJSCbWVCwzf3PBTS8dDLfxptEMCIqTCPSjlwSSgmKukictKbx3eqndcatKjEZGVu8VON73XE8SeIoG7VwVmo5jjtn2V7OUA0Z3wiwRc1tPyhNSaeFOhXGxOuTgFJy8XLuwGQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4841d24-3ce3-41e9-21ae-08dea5176a2a
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:11.9522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8SZ425REKQAZO0SO/tBoiCJRKsdrYZJDeFkVnXhqCM5Uj7deme9Ha6DPfeEtQkgMKnatA1QZY6YVUEEla/LOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX/ENaAW/yTEhs
 lX8WPFW1cigjysIu5W1hiAI5q0uVraY+79twUQpQm9w2lX6CdaED8HMa6Q2CNpcOfry28xlzPkz
 7GgpzgVGp4SvPadKusAgFTAoMrsZgqu0eOw0YfKaeLbc4vetCjfreyA1sscoNx9iQ9TqPo/T8yr
 XgJMDVQbt38vjh0UbBMV4DSm7vcAVdxoOAJbOugf+HJrqKJX8+f4VBQWsIpdmOxOOTJZOHyuDte
 kPBPNgw85t3Nxa74MULUET32OsEma1C5nBUabA3qwCRPwZJI55fIVXyggdIKG90Ur3dNjfXnxFU
 hUO6IxTw1kRIosh2UxtS/2MBY3iKB2c4Hjl4DCrwKNPZUA5+8cSrFtakiis8uOt1WXBp2EYLIOO
 TsBWwd44PyE94bbBFyeWVN/r8PfPoWuxMBQlMzlcOuM7QAfVpfgXba5Ls62sXXbUCIISgQ80Mcr
 noA/wq7fCadAqMHS4YQ==
X-Authority-Analysis: v=2.4 cv=QO5YgALL c=1 sm=1 tr=0 ts=69f096c6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=PbwEKb89bYuBhGpDIggA:9
X-Proofpoint-GUID: 1jzMLtGPipnZQ2rT71LIcVCBN3xQ-2Ad
X-Proofpoint-ORIG-GUID: 1jzMLtGPipnZQ2rT71LIcVCBN3xQ-2Ad

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 35 ++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index c6ae02644fdf4..068c5e93ade1e 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -96,6 +96,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	mpath_put_head(mpath_head);
 	kfree(scsi_mpath_head);
@@ -230,6 +231,32 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_head)
 {
 	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
@@ -239,6 +266,7 @@ static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_he
 
 struct mpath_head_template smpdt = {
 	.get_iopolicy = scsi_mpath_get_iopolicy,
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
@@ -252,9 +280,12 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 
 	ida_init(&scsi_mpath_head->ida);
 
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
+		goto out_free;
 	scsi_mpath_head->mpath_head = mpath_alloc_head();
 	if (IS_ERR(scsi_mpath_head->mpath_head))
-		goto out_free;
+		goto out_bioset_exit;
 	scsi_mpath_head->mpath_head->mpdt = &smpdt;
 	scsi_mpath_head->mpath_head->drvdata = scsi_mpath_head;
 	scsi_mpath_head->iopolicy.iopolicy = iopolicy;
@@ -279,6 +310,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_put_head:
 	mpath_put_head(scsi_mpath_head->mpath_head);
+out_bioset_exit:
+	bioset_exit(&scsi_mpath_head->bio_pool);
 out_free:
 	kfree(scsi_mpath_head);
 	return NULL;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index de6339989d2a2..c2eeccea52d3b 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	struct mpath_iopolicy	iopolicy;
+	struct bio_set		bio_pool;
 	struct mpath_head	*mpath_head;
 	struct device		dev;
 	int			index;
-- 
2.43.5

