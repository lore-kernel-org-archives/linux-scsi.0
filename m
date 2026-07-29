Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF46A47255D;
	Wed, 29 Jul 2026 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322370; cv=fail; b=tSSUxV6QADYZ6Lb6JTMVdVUvp9K4Pu1wndnfPGPv3ZUZcg1W1B2jiHkcmCwSggYusjhHqncj9YAFoeyrFXbzC7byL+JkNlSDAzV9jJb/jopBYhTsO8msxwO+gB9m45SjJ/ZHLeZFn2toViMWsavXtNNtAgBGyOzjQH/XKiQzpsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322370; c=relaxed/simple;
	bh=cDSe8au8xmW6FrUzAl6EfKeO4WDmfFpFAh+VefTS7no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Koeq1mXMINznhTt894ugmzPWp4wFl69+hXEm/hJo3ZUzk1E1txr12s51+/qXzSotnCT9chPtc9/bMbEv3l3jfBeQwRvcpDSBDXsEZhGMMgyhpUrgHPbb5rAuszGE/shVCoiHno3/z/HME0lrr1h6NAzdB0o/Mt3vSsmT6xCpldQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GSjI2ZL6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cdDRu6iM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GSjI2ZL6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cdDRu6iM"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T8ookB1120918;
	Wed, 29 Jul 2026 10:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hSpwXwtr/lGFW4pkszPmaAOSExeapRbATzNkBo0BioI=; b=
	GSjI2ZL6LVMg9r896mMRdDK8e6FxFD+oiEVRoj0Xe0Nd6gZv8GrWcM2XPcs1JIxX
	yGc3mtEhYPluBgzr3goLWkpa2eUAOq80a0A/TpTaS8zhCd9xj/gVT6xfzyZfK5Au
	hFLV+7lLXSlcHQGsDPeW2w0WW790dTd5klaWmpLdpSgB/QAJhPh4/jIA9/RE8mDH
	u/FO2e9fSXpdfhxZl98FG1K/S76NDOEXcvMx5EmRexJT78AkejT4I6xp8u5WozVi
	kHpcK2Xo+Rz1jY8zD5XbO/AFJEwOzPKRXHq40jHLs2ynVl8rU1ByIXz/fVVnxJn1
	RwMb1HiF2b3HzG1H/nFcrw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nnmg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo6JR040182;
	Wed, 29 Jul 2026 10:52:01 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013014.outbound.protection.outlook.com [40.93.201.14])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrkab-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmYn4XgjQHI8GPpMCY025Ygwux6hBaME1xVyehsKIrgEF5Jd3v0rKrial0doi1ZyVhmw42luKm3LzGZGxA0JJ8NEvfBEdl0XV2whYl+fG805ygvr2W+/vsrxIJ6G9DXS8oXzZzTYEu5lAYu72wzPB4UhTtC9Vmw+Sh29PqNPWSKtNGksGsukFCuWSB8cNppQqgRlr2SSB9JJnhBL1R+JkGK6C3fcCze0n0vLQNWPiGts9h4oKsUlSCwTK36bdUSGHXy9CYdLHpJbprZxJ0ik5oh0jmkdsRBHjMdtQexdYqvl2vyDc4S82uaVsixJKNBBtPq/ASa7OFjlrzBCtFcrjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSpwXwtr/lGFW4pkszPmaAOSExeapRbATzNkBo0BioI=;
 b=KMWUn3JEJkFaGOEmtDi3oOSG4vCDB3KilUToVJGRdySa3zaPGd+iZB28M52IFeY5vga+qsjt8uz0fbvc8NxKL2Hl/BX42VZ55pAkza4cj+2mhPoDRzC+qRQMS+3UbuCoxSBGdN34oRClQTuXHu8/1MHA3weXfwoSB/Y6la1YutdRj57ex9j9erxn9m4OeLy0SQcqVCd2SllRQU/nCPwVL13whdoouaNa/BscoSsBZtl8wmr6tcvX10JLbw8Uc07wsy5uQxcvESoU0sLJmHN6mSsD1UsBbSB5nCiFtfFi3swXnFsJxnlTFfoyvsy2xyfEBqX4FFE7jKh6GfvlwRO/LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSpwXwtr/lGFW4pkszPmaAOSExeapRbATzNkBo0BioI=;
 b=cdDRu6iMO+nFCdZy+E9Ju8vYmWfcquvf2QbW6T1hHEU85iit+WzXNhy1/7JTCLYudWAHcuucd2UMz357TL6uf0SZFb9BnkJJw5zUBShpUJMia36NcWCXA1S8YM0M8WK2daJkmFg4eUsROvIViX/DFlNKQgPVardrJOKu0+XyQlo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:51:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:56 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 12/27] scsi-multipath: introduce scsi_device head structure
Date: Wed, 29 Jul 2026 10:50:52 +0000
Message-ID: <20260729105107.255712-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0064.namprd17.prod.outlook.com
 (2603:10b6:510:325::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: e33ba404-c0dd-4545-5096-08deed5f6858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	G3jhak9QCFjIHRXLOGo/zRWWoxpWk8Ykm1zvdC9q5WvqZzpFMlkjPJqfxugj+2wpOIrG4lsEgHaUFVGBSQOlmtHPg6MMAwWrH7vyRY7q9K7ZVby9j6alhzBnPbGjQoYd8t4kcYsPp6Y67I5q1dnw0BLnUG+q31Q4Bw75gn1OyGVkCjFvAqZ5sZoUFTbOqH+DceJ4jVC9wbynDMgf7zwjGqYrTx9Mx4qS1oyoA8Vz49e/XglMJkLp+TPDkuOfqHvxh4ZniMtvyCD49LWMDFg+oOB2VWosUEl3IGqFVFJvK8cPUcojLuMUFcGVpVjLvnjhG2H1sscistjdBTvrvdxPR6cJ5IlLbBOwPP9vWaXEWnuufqoay2l96nmYlSldiZedx7GCdtBOzFaKOc7UU6EGq7sSHp8lKgcWiHp3LWu1SaE42zdA8Vwg/VzrtwhisrpAXhhS+/s/FZgyvEmyJZfxqZVEdMNfbSpvWJWdg5t/fdiguIEvf1SxKJojpHjXjCkNSL6QAty5aTn8QaRYtSPDmU/qqmpx5zdbferZ+Jb1VpT5IVas6Cji+0x69w6ASzxIatO2O9oEXd9SrRtAOY6tn4DdcTO0qsrQmI0bnAFyzNsQ2NrW4jyfFk7pRfA24dyrX6wEk/NkVef/CaayqHYIvTimX+15zVBtwLol8J4UmDA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E0maJRfznPzgYxGIjHhcU+aNttdIOgrEMCx+1eU5jQh2f31pmZxgQUAvxWm+?=
 =?us-ascii?Q?tLhHKbK94gO+fbCPo2zqL1wgVExP4khdMNrXduZ/9XNm991wdoja/2XNaKHp?=
 =?us-ascii?Q?5qce3b9RsNGa+Ja7r4VPa2G7YdGTpba9IJkDsFn8boYrnnzeSxnzZLCNjkwK?=
 =?us-ascii?Q?tUnvWKoBFUUtyJVpPkFaybGUEZT43Nc73kaCN5Nqk4UOaq/0xMd25KO9JEnp?=
 =?us-ascii?Q?T7eOfGwrSGcxdK33A6HPqZic+DVtDpz6Dko0kcv4mgAAhaqW8KseOJ0f9qlj?=
 =?us-ascii?Q?Yt6i/abQRA7l6ZqCMSqya6eev0mBUW+H+iwp634qOJRX/jEM9owqRboNlxTz?=
 =?us-ascii?Q?eRe47tfrFhs+oOZec4Avf2TRe/A3+Xz8r/Payo9rnANtxwWJhL0DhHDlKLwg?=
 =?us-ascii?Q?C+UKo9sGPNS8XhiZT+iVIjVuk3mzF8Tgjqsf42nG/ykaZM8W3llB6HJUCxQQ?=
 =?us-ascii?Q?BsICATfqF0CgdxAM258Hsc7A1boQmbGvLB1PTId0p7n/cyM3lRhIc2clgxuu?=
 =?us-ascii?Q?qc4DbLBnCmmBEEKhrsNcpb6rrDIkCq8QII2oCEzO3zNYRjTmeR8TQd/yyi9G?=
 =?us-ascii?Q?9fNhvwGquA7fHKe1crY16rUDkSTsa37s+EY1RhUkk8QwXX3oCFnLKSZgtyxc?=
 =?us-ascii?Q?QtFHL5vrQKVvyGBoNiFxwEeKjAtgKcWfioTR2/LXxmLw130N9/PjOjRpaoek?=
 =?us-ascii?Q?0fa4LaNxirOf4XWBBrIq7kMZIyrksmFm+S8d/frKoVbL3zeaB5UtMj3+Ijzo?=
 =?us-ascii?Q?fY3HkW4uRgnaXbEZNbHECWt4PUTel9VlpeUX//Ao7BNcCV4AioN9G6xg3tUc?=
 =?us-ascii?Q?q7Ch9XewojtLRLz5a+WsaqpVypEEI1ooJgvD3aqVlffJBCh3SjXIkT1Qs6PH?=
 =?us-ascii?Q?NvMbF0h+rHPhsJ1agCuArXTaoSfZt/vEMg1mICuwOGXKM2TK/SbppKS4QEbI?=
 =?us-ascii?Q?pXQFP+f2uCB9GuniMhO3ZLuRTHuNWkcJJgbMcqwbOTgky1jjjeyapyQz70T3?=
 =?us-ascii?Q?TPg+bPACbmlGQpgMRnmPGAJ7oBsuG74ZnygReMzW/QbN6AuVsrxqmAvdejcS?=
 =?us-ascii?Q?BzPe3h8OGFt0UfmgxtgliM0Kdiiizv3U727qBp1g7poFu/utlLl8dQIlFmRD?=
 =?us-ascii?Q?eaFuSjPJEKzybrKgPDHmrpPMct44dV7hixMt/6chRn/MPTiBPu9LWXLP9+da?=
 =?us-ascii?Q?lQoYnwZl3xJZI8Tlig0AEPjhf15R1FJ78nMUWczadDeB6gs3/2pWB60iY1k2?=
 =?us-ascii?Q?58BR1X0GQWen+sTkSIfqB1tAZ+B+b7OuT77OFp7jTn2vgIL9ujUKq4gszB7/?=
 =?us-ascii?Q?zW+VLms+Lny0DGrUTPBKaXV15XjV8MUSx8H+DRQqgd0kBN2bDm/f5WeL6UCW?=
 =?us-ascii?Q?2QUO8WCrrw/e9Cw0gWJxHJKbeAl7RHS6+wIn898IMWdA6ZPeg0JLzKWy6kci?=
 =?us-ascii?Q?mPDGaDOdgnfgGuWgmI/NpQUOu3iyIWh4O9C/0U0uEEw4jV01b/HI4/GJ5U1A?=
 =?us-ascii?Q?wnD5IYhbnCjpAXIq7jlYmQB4uc/DfOB9L1bFVF+ielvZnQagWMc0d58pnQn+?=
 =?us-ascii?Q?O7kkOvlZprB65AvocuOWnGTybdChS76ml+nX+jp6viMOSYUIMXDsoKtww3yq?=
 =?us-ascii?Q?+5xEJqIAKyjV2HDiXaKBaVqNi0PrMF4Osv4NMUtUrsqkKggdFKT2U6Tc4hJd?=
 =?us-ascii?Q?a82u4MRsRGpGCSVcxGcaLAGlWXQyuf3Sjb9nANi9UL8zBRJ9lURDUarzXUfY?=
 =?us-ascii?Q?HuVbcxWwVw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	EO3mwXLAsR2W/JQheGvuzBt9HgN2oYepNvhq2FkPy/jTjTCxH8i76k8LOgiLEBzvhrfiZbCGffMeZpvAqQfxHNK5ZdcG+rTc+QJ2Ml45hAhgbulwDL1hndk/5Ml569YcP6M/T6Atf/e1KIhSeYdGwgv3xgBrgy63GzXoyhWiGtThLogFaVYPQvykYHhR2oqVOsO3gHLQxYcAFvefl88ZhG6qevoPvj4I2tDLQJ80WNOZ3hfF8UJv7czRiFrXjfOaiTt0I3Lpb4rfjZs7t1KCThBdx9Lj1OCWnIZGyCO05uyc+VTXfvogpSyQziH3MYHjh+QJ8MWX6m+w0ILo9I2xwg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SH3B06IwK0h2gTzQ9TrlIPaDNvSelCiUTLQ5jfbVe0xMt3xt5zPr5aNLJ5aLar4VYBi1FAH/k1d34fcsLbZXKlHXTDNFZzgSwr12HgMI7pf5DOCZeTrq4IODylkilnxkWYSdx+5eUIM0rs30ufshfdlPyuIm2LwfA/NCVrHYRzW+o4uHnE7JJZ+hSsWt5LJxeFPlI2x0LK1RB//Q6lYLa3bZoM29cFArHMX+xnJSxLwB+L+9p5tubYQZVzmHSZPyiNUHKpECDmstRS4FwAjxfoIL7cZhMZ+KzMPmhZ1Sb9j/6edNbSkfY09VkRbA2Ltt87M2qcd0VKD+vB206kAIHFTHQmFSbwL03ms6nMM2ho9AayndIDBaygkZnStsVzoApW+AV7mgidllhMgCNS8A5+kSBkT03ziaJFkwMClDc0LgxNOcY+EAMT8bP0qGixQ1OEvl0glNELH4BswQpXEjwYAtlWCw1CqreBTqHotd76zywewRPNufnRcf2BtzR38b4Iy8LEorp4oV3RKsSsg60DYE0ZTPOLPUsXQTdj75qpcatuuWHlGD19rhbMZEuTdngaLCqWQxobqiVI2dteZ+a1dqNXWlnz5xtxqV7Yw4Mfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33ba404-c0dd-4545-5096-08deed5f6858
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:56.5736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RR97zG308r3rYJvURlG88BXw+uG/riRSXg6iZ/3ZQQiFOZuvQV9N7jn4A0mAxErocbtbJtrp1lc5AASbk6R0MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a69db52 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=rslDvqJ3sq2LG7fXSO4A:9
X-Proofpoint-ORIG-GUID: tCYxRjEIsrWGWc0m7uLTO0rQJtBeMU4y
X-Proofpoint-GUID: tCYxRjEIsrWGWc0m7uLTO0rQJtBeMU4y
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX0QE0zLRgQvoS
 b1qZjgiikf5GQuVV0Nj4dF+TGcy1yNCcUc3T62AQ4oF6N3GfXUpanlU6YuVrYTF+C/1RNWfjHOO
 18dv0J+3z0/xHgisovJMTffaKjqRb7TPd8A3xUa5A1bSFOhWbNCf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfXxroQDBpzIMEp
 Gi1iaWRW/uyg1+uAq5W+3IblTa/mTPGKlAzWOUrhdDe6755jaurBN069jNXBbitxEsW9B/BnGYA
 LQCnFMBANqF/Bqgqxc/jq1JyfppUBkX3G63o2p1JTqU3QEwxqOlxdmbz4uCL1n1kbbbyAd925Lg
 HjgzSGrWgwc3khmXkKeWPsUafvWPWw2x+TH97SlvMF6Movq/XNJCaKhbSq0CxBDjc/4f+Dfp+5A
 fObBheTZTyLyA62ekpTWX8CVrymAGGUKbfXMAitTOaQ3LpwQp24SOfAVy0Y8d+vW3YOElo5Y7dt
 45Mq7Eya45FZatNm+VGDRgIvvqDMQbDkYbxGEx4xT+WN/fB1LIZ649tlvzsvOca1gGHsl9mE7B/
 4PDDINS0Y8rU9GOwxLhl3YCMDmNP9+rozOoPbIVTPAreAz8r9yMq2JoLrsijNhF/9s+Dqks/zoB
 9+Q2D8/Bn75/Dez8alw==

From: John Garry <john.garry@linux.dev>

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
managed by the scsi_disk driver.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

A new class for multipathed devices is added, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
drwxr-xr-x    2 root     root             0 Apr 13 15:48 power
lrwxrwxrwx    1 root     root             0 Apr 13 15:48 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Apr 13 15:48 uevent
-r--r--r--    1 root     root          4096 Apr 13 15:48 vpd_id

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 199 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  31 ++++++
 3 files changed, 231 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 5559e2e8d64a8..30a2d01be8aaf 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -29,6 +29,10 @@ static const char *scsi_multipath_modes[] = {
 
 static int scsi_multipath = SCSI_MULTIPATH_OFF;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	int mode;
@@ -72,6 +76,55 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	ida_destroy(&scsi_mpath_head->ida);
+	mpath_head_uninit(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->vpd_id);
+}
+static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_vpd_id.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+static const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -91,6 +144,74 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+
+	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+
+	strscpy(scsi_mpath_head->vpd_id, vpd_id,
+		SCSI_MPATH_DEVICE_ID_LEN);
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_uninit_head;
+	kref_init(&scsi_mpath_head->ref);
+
+	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
+	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
+				scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	return scsi_mpath_head;
+
+out_uninit_head:
+	mpath_head_uninit(&scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		if (strncmp(scsi_mpath_head->vpd_id,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+			if (scsi_mpath_get_head(scsi_mpath_head))
+				continue;
+			return scsi_mpath_head;
+		}
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -99,6 +220,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -118,13 +240,51 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	if (ret < 0)
 		goto out_uninit;
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head =
+		scsi_mpath_alloc_head(sdev->scsi_mpath_dev->device_id_str);
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
 
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+	sdev->scsi_mpath_dev->mpath_device.mpath_head =
+				&scsi_mpath_head->mpath_head;
+	return 0;
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
 	scsi_multipath_sdev_uninit(sdev);
 	return 0;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	scsi_mpath_put_head(scsi_mpath_dev->scsi_mpath_head);
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -135,13 +295,48 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
+
+static void scsi_mpath_free_head(struct kref *ref)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(ref, struct scsi_mpath_head, ref);
+
+	/*
+	 * If we race with scsi_mpath_find_head(), then that function may
+	 * find this scsi_mpath_head in the heads list; however we would fail
+	 * to take a reference to this scsi_mpath_head and continue the search.
+	 * As such, it is safe to call device_unregister (and free
+	 * scsi_mpath_head) after we delete this head from the list.
+	 */
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+
+	device_unregister(&scsi_mpath_head->dev);
+}
+
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	kref_put(&scsi_mpath_head->ref, scsi_mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
+
+int __init scsi_multipath_init(void)
+{
+	return class_register(&scsi_mpath_device_class);
+}
 
 void __exit scsi_multipath_exit(void)
 {
+	ida_destroy(&scsi_multipath_dev_ida);
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2f80d703ce640..799569b74b535 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1525,6 +1525,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 */
 	scsi_target_reap(scsi_target(sdev));
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	put_device(dev);
 }
 
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17a..50298056181f9 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,12 +19,25 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 256
 
+struct scsi_mpath_head {
+	struct mpath_head	mpath_head;
+	char			vpd_id[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	struct ida		ida;
+	struct kref		ref;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
@@ -32,8 +45,13 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +69,18 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	return 0;
+}
+static inline
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

