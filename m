Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492083B9DB2;
	Tue, 17 Mar 2026 12:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749257; cv=fail; b=fGY+XnRKlJYbTHT42bwZzjfvJG9IIYpVFnhHfl7wwh2/7kdikf08XBop/PrkzHxwmr3tDm4khVcYjzt41btR0BAoLctq8GxyWbvMS66M7KWBJSRz9Uu4NC3/IIoN/xcCjdbWKNyAfdOo9Vs6uZBv3n4b9S0YdxVkK6XE31zUdjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749257; c=relaxed/simple;
	bh=9HG27JKPWTY5FAXFohbe/MKweER0B97Dhj3KMbGgCO0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GP43SZsbSrIGvAQHoL1ro+ehJmWRWibQjzpMyeAiBdr0xixTR3dc4WTk7cKOmrYRvTGkgTSPgZoz2lSoRcS5/WJWhLV/3lIOAVcHIvtBXO8MfnHtGPM2GzHnWrGlEgcg0QVK9/vQlZ6JZ1/SENHU1OiqHuO56+tCxnITifMCgyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qtMfIIy2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c0TuJDyu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qtMfIIy2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c0TuJDyu"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GLUV1L104304;
	Tue, 17 Mar 2026 12:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=HWaXrRI2AFOAKSxy
	hs/YaHFWakmII+7hgPr6u87W5Ks=; b=qtMfIIy2tHTGi92NFo6ANeDJUygHd2e4
	ghJZvgfZK1CppG7TClGOyjR3nXK1FaLYf3JgMWAwaUCjlounGQeB/dBLx/l7RrPr
	Dl7aVg92V0YYfCNADV9+tFKP5bEK9ZcYn07lG+OkBIEDRCJhf8t0X4shuHu80zTi
	hNzYluiLBipFZ4kqoPCM3meuGyKzQE4rQ38niwETcPDkiXiHX8mLqjsDWZEFwbV/
	ErWj6MiVtf+4cidIcvOeiH8yv33OaqM8f8/afnsCx9TT4ukCRC47HJCETQHKZDwI
	6sqr3zkx2U6n9UtAInZ8lxq6qSzI3QpDhCfRWP9ipygxi0agTw7cmA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx8x41pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HC03kw003688;
	Tue, 17 Mar 2026 12:07:18 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011029.outbound.protection.outlook.com [40.107.208.29])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4a016f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pEM69bF1gWPXmNYcjgXK1BvUGDGt07ATByatcxusIkiZCXpAxXn0FU5pieAOYWrUrJ+zf1EK9UR1JltcvR50/HePStfp5Bs1783JtMLqiyY2zT3/TLYlCKQj2ghzdmwRD6UaMZqiqA+PlziVhNI0PrhvhP5d9fyiaURG/BMFfi+R/B7kvARBKltfNUkjVUu+A60JWGPWBczufbsU7ns+7be85tcMCpjc0/p4hOo3w6IdDcDCW+g9xDAoQ2yLI1QYgA1cemT+nGfsKusHm91An/2uERh2ISpbFlYh8CLfxPuv5AFbGweqvpkP2rcWgm/he147qFf8r6oG6A/ZdJbVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWaXrRI2AFOAKSxyhs/YaHFWakmII+7hgPr6u87W5Ks=;
 b=twBr0TWWS/3xkQrCfAwzPBmauLw/AQXB20cE0vkFqMfs+tbSy2zFQHDaafrO/6EpR/J/ZFlR2vKmHUfvmGBjSVeuNIpcqEKUIw2MKP5EFLcBW7/qmC5UY9zIKLuyzedF8eK8WSUaVNoBTFA2DLnfOkfCJSx1igUTo5E6YV6NDxQ2uXBXJTX4Jg6WmpL/wQ76cd+AA/lIunXdF0+JE2ulNOpc6YMGLHbceZBun46WANkpyM6IaaPT6FxhytBbw+r+hgNLcYwPCMWt3Sd3WsZrzRc3eQmi3InnECesnPn6lsxnqXzPbE8MstY7RgjNVwClib4bRGxZsMvXPPz2LPPo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWaXrRI2AFOAKSxyhs/YaHFWakmII+7hgPr6u87W5Ks=;
 b=c0TuJDyudA4Ds+f0LiP4dDfmoMBE9dG7lAVAVbWNIeteoIQao2bRlkTbr6r0pijccESFpv/TwHFIBg5cMxkoS+b+rIojdGpHdKEhgWAdFavkBRDTjqxIVvYpA1k3p7mDr978be56JhmsGwlGXKlrluFRf7+IJEPeIL4kANS6Y1w=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:15 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 00/13] scsi: Core ALUA driver
Date: Tue, 17 Mar 2026 12:06:50 +0000
Message-ID: <20260317120703.3702387-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:510:339::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 4473b9b8-3c89-4dda-72c6-08de841dba81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	XrkT2LauDoEtPyOhfMNAhqcIb7MVQqwLZGLrBKY5USnjkS4PBVn1YKyub2PPDnAmI0Jf1Outl+3Mij9CYt/RtVn3cpGaYvrcPUG06fWcL11GQBSRxQYuw7QLbV97g8/deB53VAZ00GDKHC7cs3AvAUTAcVBYP0U2PhLD4cFf2ME4JlgFptkWFxM8JhFX3UVbS6V/Wv3Wpifd8ppUXqkkknsFh9/zKabhxi+k37c/Lgetmy+IaiqjeEZ03lioVY9qy6S+cOYld6HtzeuOtmHgF4WNZHLhVYWDFlKuIQJ5V5SA2mHWd+qLsL0vwytpdPhMyF8B1+mj8Q9AVz2Kv+52cuDDBSYMkgQkq2XIxQ8+iOjxUZd4VLG7nJ0YCeL+ZeIBs7J0ryxtKdwASkFyiRgs2l3rqmV4WTGWKHzeWL/YDaoRhElKNHAHtnqKragPS7bjZRK5CoKpgFYZ8h5tv6j267DKG2WN7bjFL/RfIy2WyAqWLgakJY/LFTNHUss8ghsP9WDH+Oifr4HsqJjuGpeS6UlZF6cvsB49n4hrIaKNubg1VLH7k5lHHdSnDHJZE/3qj8VakvQV1+RUKiMoWdA1K9pOTfiFo6oS/zK1HC0ZbuUWGgW/gqX8SfS6dcPs0pf3C7TIw3soKbRsCA/Wp9P8cNoDor985dmufRpL5+KoT46QxgTCkzr9ce9A1Oun/FwXAXKeJ9MnwCCdra2d/pM5Pw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?frrONOpuur8xYkzYk/kmyeuawlxUCQMMrjGrrAm8xDOnAaVy7gGERCNOhiz3?=
 =?us-ascii?Q?AWK9AM924j0h9Pe699BWqZlg+J2Wgr+KisqQT7dpPHKIyOTBoBkK8ZY0S3oa?=
 =?us-ascii?Q?+6VHxfygVFdEwfbaaPnRoilt/CL1RrTyZDMTDNBM3kvxG2/2AuITreDNBHgt?=
 =?us-ascii?Q?sCxEz5tamhR1wajNghKFJfEPdnpA0PBLJ0J1cCl8rqI1pXi0pIypahdroY4Z?=
 =?us-ascii?Q?rErd3eFE8ugefiTKsRmAx3fVcW9UMLnLo3cZ7F9yQhD1A7ZTrIt1UfPOMCGS?=
 =?us-ascii?Q?q8xekUO16g7K/j8ySzforTNYbDNF7fHo3hNp7NJpiQK003w4AmO+9qtpjUrC?=
 =?us-ascii?Q?74lgIr88p5W11M9Yw8XuJ0lpvPPTjqwqn469kb64srcWqRt5RasY9U/bLqOE?=
 =?us-ascii?Q?su1D/+LKz/jyWpzuoR+DzPUJTbi9b6lMyCjL3wXyGwu2y/00GRMG6jNLhxyt?=
 =?us-ascii?Q?B8ABPB1hoij/8v/FU8U48i9AkmekbzQyIeAqCks66iEB490vVVtq4jgI36WC?=
 =?us-ascii?Q?qMlk1bjd4vTDdAuVTSDV+QCBRTh6AOXzRMRNxwJzYzDAukrUYlR0LcfZKJjR?=
 =?us-ascii?Q?vFylWWcWSU/DEZaHW4zrdLlNFTz7+qJDQfDaLy9juJN2b+rX+xejTl8Ug1LG?=
 =?us-ascii?Q?Ap5qkVT8PT3dkssLGvZahl1LaC2C8fnVES+Rut2Cm2eW15phpHoVnOIY4PUM?=
 =?us-ascii?Q?anEFQDWWQbvhJ+ON4usIvzELVFRBym2YS0iWL0z0emH+esqFsiSEqVi+6NCH?=
 =?us-ascii?Q?zcPeX+DRDHqN7CP+w5P+fX6yJwdwfs91QmJm27c8+Y1KvkwePG2I9zkPg1mj?=
 =?us-ascii?Q?H70aG+FFdzHluWKLFm4DW2B73f8VwGe2tlHmI2FjwBkUZyz0YHjU+ZZ0ZLGU?=
 =?us-ascii?Q?ibo/XKY7BKnwthGfp2+YKCXkdYF9PI12Y2/tLxQo3OgcvScunSEC+3SQ5i0n?=
 =?us-ascii?Q?ZZAO0XHCn8//unj4Z3cLO0nQszSOzZcaK9brhs06iErr2S1zpiFwlM17bcEr?=
 =?us-ascii?Q?qnTyH1luqk/qOGD05Fsz6wLGWDat3kQHz/0da1LmQbb2MgYubo+5Y7X6I4/g?=
 =?us-ascii?Q?Yl79SyQLlOhat3qkYB+znRcds4x9fMtchZ4JGZPYO/nue1f056ZKAuZyEjqJ?=
 =?us-ascii?Q?sKjvS+B+G9NWT7qcVPAJM4P/BRVZyFBNyPXI1B2QaEL3Dp4GADtf/cn3c64V?=
 =?us-ascii?Q?p3B+aozOhLZJCN5gjdMbRLNyjcwh925jTw1Zs7mpRczpOmVl+O7JqC65jk+O?=
 =?us-ascii?Q?59Nvwg+ZX0A1PKjhh58/tmXHVK4OIRZ1BtcNgco2zr9OHy3mUHnjXqf1weeM?=
 =?us-ascii?Q?PsiFsKLWFjju0KaIEaXo0Kv9Q2eHu8ZVnr3Shb/VahUCstJP7almsTXT1b1T?=
 =?us-ascii?Q?jBWREwcl/Canj+D6uoR6+EHx73BHbpJhv+qeftJnvKjTI+OT0e6q0iE2gWST?=
 =?us-ascii?Q?2voWgRBwoM3KZdNuKNwGz+B7uhEUkvX5UkJ0gm6Ft875J8P9mflH8EktHkn3?=
 =?us-ascii?Q?cnvLm0pw24sCpz+aYQdOxOADnzXMQtnpwRtLGMH+nDJmLPGFpdIKP4+WaKgL?=
 =?us-ascii?Q?ZTj0/w5cnNQ3I9wi18mC5B4JjHVAOkRg6GxpLrOI/LXGSHTzlUTNDjM0kvtq?=
 =?us-ascii?Q?rZxAcbMAxRccyUXLsCr+9HlUQq805OUiyMWQYxFIxg1moulpx9PZT7jlZW4r?=
 =?us-ascii?Q?K2/oY5LGQktmpsq08JTaUD5PV25cLHoepEyuG5Zr98tuEZiSskDieaXXA4aG?=
 =?us-ascii?Q?URUGpwRu2hLzzA4CxnXaht8qjHp4icM=3D?=
X-Exchange-RoutingPolicyChecked:
	LEVQMrMM5dlH7JFXneczqrgzSGu4QAWeFjv+8ozlNadhS+pOHNJXtPbqeAS0NSkcNjbhitvBt03Hv9F0ZE2BCfLljaezIpw16OTACbX8F5gGjHXDpKFaQPhBE+8gghnMJRZh7MOj9+YaduDKMZacbDUTTuJq8d0XzNAQY8iTW8zOPjj2R6HPbYORr6fy1tSK5pnUDc0MvP2aNmaQmJ7FN5XU53th6eF1JkV6+Y1AppUwXVBXAs/SW1rVCSC8oQBOe+BGC+kwPsRVEjKfOCCla7cqtHlTvB90nbIYE5o+JV9OD/c82BwkN9qPh76q28b0JsfytCPqwxvk5Rn3LefGJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JEA7NMKtYJYxmgZQH3HIURO1dsZrMhYCnTjW6L6rkV7EMx0qIunmJkwDMXfp2Ai7F6YMp+LUcCwtyq7iJRbiM1XjcAlhMneSaOQDaCh396aq7XhRrRWVJ7eeZz9OKYI9jbYYraUKHZ4Gu9tyFQMX0uaVhSQC0fmid8TzDbSENVsl992wf905Ukm5LU46g4zpiSiSPOz/M2fB3Vn4mpCTTyMl2Doxgm5Y/eZx3EPD9y/SItDomhllwtSBS4qY0jp+TSuwcjGg+IpB4O9MZHeL7bbsQlRcxqny2TW2olgfPcipCcUE05ACsU25tFMf32hLFgXDZQwIeI0WYcFu5idu3ESNll2g0FkoMU2DCtpjsZ9tgw3HRJK31xq/oUtQw8UKcNhRWDm/+4fAE/PA2P/5Wx34LD5ngwR75JVeJTOfTY5jJ22wt693cKoXT/ZwAodmjODpIIXLr+vMqR7lZROdn1CJWYdg1wE/fECPV1SrA9nR+62PESLbgDBQxPBmr6EsL+b2mUgh4ASLX6MJyRUwxGOWwqdwM4egwLvQXQkSFNRp3AzM/JAE1iwvHJ3anPxT3Mq/4ZGTww4LNLXkmTXbmqEU6SdFcMprebh4KD9XSHA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4473b9b8-3c89-4dda-72c6-08de841dba81
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:15.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mo7C4ckAIDG/v/tdNgCFNL06axo+i5DqZeDg5eKU2/d/cQOC0yLnQW3MeFZGeHcnm+xxBeSU+aznvGPVBViS4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=856
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170107
X-Proofpoint-GUID: sc3B_Cs1vqSzxIwcCB3nv0ZtaB7m6HPr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX8SmqvzsaSQnK
 eUYgsdmFexbPY4/ypo4M4hQOvpMGUW4V5ahaBHkiCMHkcG46EfxmwTYyUvTsub8qOUgDVrWxUfn
 fx3qM9ZFSiAnvNe0aTWMGh/5WRPN4LL7Fy9FzxQkivk+g6ZAzYNRXxwMcVlsqpw+dF+kZAmOliA
 aSDrznjOoHjnA5CrD29JyQ13g7F+/fBmuR4kic7oNXQ3TeHHYCuPydHiSIxH7K/2zh35WkJx9Oq
 MICLJ0L1UF57uboRHS7o2/433E4Pg1m1wQqzJoRahcJ/Jg4Co3p2Sq6G+G3DPIEOyF0SII/JE8V
 4yW4i1Cp7UEFfp7QcW9YfTy9bGVl2sO90+4oDmI+wTK7hGHF1gqgOVN+grxvX9dEIePBU7TdolB
 4w5XwD/lHChHj+5p+IvjIIvbhXV2khR0asNRN5YzRTliJ4JXwN6qpPyHcX/OQVo/49pMXDH7Tm/
 SSUZ9vOuGdiB1EZ4y3Q==
X-Authority-Analysis: v=2.4 cv=dJmrWeZb c=1 sm=1 tr=0 ts=69b943f6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=5xqtHL2x9lxvlwgU1NkA:9
X-Proofpoint-ORIG-GUID: sc3B_Cs1vqSzxIwcCB3nv0ZtaB7m6HPr

Following on the back of the ALUA support for native SCSI multipath
proposal at [0], this is an attempt to move to a SCSI core ALUA driver.

Essentially this series move the bulk of the ALUA handling from
scsi_dh_alua.c to a core driver. We still need to support ALUA for DH, so
the scsi_dh_alua.c is still responsible for driving ALUA support and the
SCSI core ALUA driver just provides a set of library functions for that.

The SCSI core ALUA driver also provides implicit ALUA support for no DH,
like when we would be native SCSI multipath.

This series is just really an RFC quality work and its purpose is
to decide on the direction of ALUA support for native SCSI multipath.

I think that this work is a real regression possibility for
dm-multipath, so we need to be careful.

[0] https://lore.kernel.org/linux-scsi/20260310114925.1222263-1-john.g.garry@oracle.com/T/#m9c054433076812dff464d0e3b50a00620cfe0af1

John Garry (13):
  scsi: scsi_dh_alua: Delete alua_port_group
  scsi: alua: Create a core ALUA driver
  scsi: alua: Add scsi_alua_rtpg()
  scsi: alua: Add scsi_alua_stpg()
  scsi: alua: Add scsi_alua_tur()
  scsi: alua: Add scsi_alua_rtpg_run()
  scsi: alua: Add scsi_alua_stpg_run()
  scsi: alua: Add scsi_alua_check_tpgs()
  scsi: alua: Add scsi_alua_handle_state_transition()
  scsi: alua: Add scsi_alua_prep_fn()
  scsi: alua: Add scsi_device_alua_implicit()
  scsi: scsi_dh_alua: Switch to use core support
  scsi: core: Add implicit ALUA support

 drivers/scsi/Kconfig                       |   10 +-
 drivers/scsi/Makefile                      |    1 +
 drivers/scsi/device_handler/Kconfig        |    1 +
 drivers/scsi/device_handler/scsi_dh_alua.c | 1003 ++------------------
 drivers/scsi/scsi.c                        |    7 +
 drivers/scsi/scsi_alua.c                   |  748 +++++++++++++++
 drivers/scsi/scsi_error.c                  |    7 +
 drivers/scsi/scsi_lib.c                    |    7 +
 drivers/scsi/scsi_scan.c                   |    6 +
 drivers/scsi/scsi_sysfs.c                  |    7 +-
 include/scsi/scsi_alua.h                   |  103 ++
 include/scsi/scsi_device.h                 |    1 +
 12 files changed, 977 insertions(+), 924 deletions(-)
 create mode 100644 drivers/scsi/scsi_alua.c
 create mode 100644 include/scsi/scsi_alua.h

-- 
2.43.5

