Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DDB3B6C1A;
	Tue, 17 Mar 2026 12:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749260; cv=fail; b=GPOGgCmqVeuc65X9c8tKm7900ma9dJN4eBONxzbkEKTjLm4z9J4HuSS2DdYY+QxzK1NjTOWPumJ3Y1NKguArz98lepFWjhr5ROFhtx8NJQdJziHIjUzCxtX0Dzs+4RXN1xQR0/296VqzMvQZoEKyLaNtO1/5gr2xXcpdPYJkIGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749260; c=relaxed/simple;
	bh=hJxvjNZOwNPeuSjIvugy9S0FS8AjZmoIAU6ZgIzmFrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z63uHslbLVqTYEiUfuC6P0IAPnWSgTeJtfELOJPlkIMkZjjK3UAnlcJB9TZ7pZ50AcxhYFCBicYTpT3D/r2ADpb4cpwcSPer1qD9M6zXRoYKw//171YVTOvTXS8WNQH5UE2Y1ZytNZHfdTQKSix/dFz68EtS5OMP6HwhJIMHDnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TT9DzR/z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bncvzzyy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TT9DzR/z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bncvzzyy"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GLEe0T1337612;
	Tue, 17 Mar 2026 12:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=e3ilrWJzrcEND/6/dwlT+5vQxFP8FGfVeJfHq4Kbk7w=; b=
	TT9DzR/z9ocQpSOvUW0LMSZ+bywcnOa7KLdaOHYF/5OeXChLedD5FqeDVbgogkid
	SMR+q/GdyTN76Or3M2kA3eLXZiJcxvIfb+3vLiCTwEdDXDYEkiNb833udAehCu3r
	QSeNbjFYjjh56Ns8PBsXPsLT9DfDancLGYiWhTwQUK9/zBBqROW5kAVvFILEHmRf
	n7c1CY84nEbwoTWTgG3mzUF8CzoLpUeAtq9+pA1Cf2dVWiw9mKCmDJBZrKBvHxQo
	joDgr1AMxlA7Uaei8kTQJgOSv6b3lmswXEWL7iG/U2V9DGkiiAx3NBbT08d8lHeA
	1Y6ET6hNl/PyTIWwUpjpDw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvy9ruwyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HBaXS7003335;
	Tue, 17 Mar 2026 12:07:24 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011066.outbound.protection.outlook.com [52.101.57.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4a0198-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x6jYrThWkOlLGqVAaPpWmNC6UAusU2adRhbDj4Ld5uxCxsfoSvJ440AAh5cYVahLUvg7h71v7S64l6NJeIWhrRx8qK4XQV3BKkSwHiypreIsUnLvXZ4oNMLGainyHrorp3Hj/FKu+vLbxm3r4n+w8nW7PhjNXzq4aN1HDfL4/YXL3LX5AbVJS6fiDdkGsPXUewCbHbcfLM49wBLk7l/lidBGh04y3s/GDec5StPj8o+X7lVkKs/XSd5QS14Y/x4EyAQskWPaKFBtoenT0kXvEA7s691DMAx/JnUyvtzi0KpnuoDVNXU3ydMp34QnNgOfXg4JeiydN4uIXhQbGCYzRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3ilrWJzrcEND/6/dwlT+5vQxFP8FGfVeJfHq4Kbk7w=;
 b=RwzjM7XEVS6Di/fMEbeMKj6wA5QTLdljbh0QFoqPPHLAnKcvBr7d8qWINLdHny3GyiyWspfqV3D15C9znzRDVVd+Q8K93DtDKu48m3miQDsswct+ChUWNnk0GqcPbFVfQgGhCGzmCc+DO54O1AMEH3mrRuXVW/ng9lKuZuZj0OZovLAKliZpvS8eEX0Nn+dOo4QXoh/L10uR2sJni//oKCXkRJZIU+KiEZcw5Wj2kF29EY/CrK6KvG0n7MXsUbDI6DRrjms1ceR6Rne/x7QBXnfRyeEaW1zZMABpbUxnqA385SxkqrAkl9TqSD0+U5cPSfTkhLmxJqljwCQ60Jplsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3ilrWJzrcEND/6/dwlT+5vQxFP8FGfVeJfHq4Kbk7w=;
 b=bncvzzyyVG4F8q+GDH7SmgcXZ7T43BDE8aoCvKP13SCyfri9yx0CV8rfqi0eP7egXdgFoFHBwXhOqm8IhERwJl98RLRYuUQ7DzO1oHts97R2oq10tf3PEBJcY8Y40R4fShLf7cL+5MENEanP50Z+1clnjLL6elP65W00XTidbdM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 02/13] scsi: alua: Create a core ALUA driver
Date: Tue, 17 Mar 2026 12:06:52 +0000
Message-ID: <20260317120703.3702387-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0009.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 502983ce-2478-4873-b9ce-08de841dbd1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hFiAckAPO2emL9fQUnXi88oOMCfqNCJd5huwzsKnCA9WMO526FN7o7e3K2jDbFwkBw9W/EyBcunC6xYP60+nkDYD8TOvg7MTlY8bLJj1uMQfTEaDB4i1uojJ6AEWFqFxUSDxGvkacHwWqSeWiSwAdAczyZ7U4Oq4/HAkH2ILHcOhgINRQYjnsPPlEDQdtzyKXNAhT2Dkv6OGvzpyhs/akjBS7gq9CJXy/Xy6yYdjlP1NuPjAs2tJzGsbzYhqtjwt8pEavaedefCB1ShtpD8+S2gxh/1dT6SvVCYIYh0B4ZYjNca9irtzbQW/RxtVaxepT7PBAMOOKvYQXGGMH7XIqAtoUtdHtt6XfuUJZu5QVILLc/tIwkBXUIyFSe//Rj19HzKoWBOo6pY6YIgnSO7ZQ2thVCszfzjdMTQaq1VakFXoz/OJS45fo8vMlVuLU22s7t/lMTlJxTxM00htW+6gjZ17+qPyHQ49EUxe99ar3a8iOHqLnonOY8htRgJ+pvuD/CFPDvuMVt2aHDgcpuPQSnFdFP83XB3H/L8zb/RzqTxtO61loA4xKdKXmiHlcObOybdBQqXraCY2kgoykYCXbnEpGlvKctjLGD+Jc1LXNLP9qKQRjjdTIYcSvH+dDwLSEH+6MhSLj93vfvQ5G81EsSxlx+lz6ZPZqyGTqC1cU9CxO6mf0mMO9CRKPkPJNRuZWEGUk3OzCE5ZW950bcgv6ed1A84iX0kvG6gn+/mLj0g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SkhKGPYX003emg/yAT9qFEphiSqalcDULeCYLFJuj4ZByYbeXUGC2ktlm1Tv?=
 =?us-ascii?Q?gvGHh13K+hR4ZxnY4HLcFEdjSUFMvU95fvmh46inLvk8KITcqkbmFF/8v1/X?=
 =?us-ascii?Q?NgEpAty7SxG/9ga8GsPkMyHccNS2tlAiUUtH1/pVC2KSXgQaeSLUM7+hA1n1?=
 =?us-ascii?Q?VSAw+2UW6oQfHt5Ojo+MMprVo7ZcesN9A0Pds0lgo4v79nu0HKOktYOWkwdK?=
 =?us-ascii?Q?t+GqWtyn0/VY+ohYKMl5tguYg3//nib4YZk2XS5SbUxirtQdNf1Uw8HLrpDd?=
 =?us-ascii?Q?lxRwGVZ+ZrYLtYFxSV6HX6yxhlhGKhWHKb2ySOHB8BdctuHyRCUABf2tR2DB?=
 =?us-ascii?Q?JOHgUrlGAMz9miRHTUOLixxKZyxgPjVRQH9op37cS7mtTikbmB7syo8PcpiU?=
 =?us-ascii?Q?kXWVs3M7PEnnqFM+SIBkaJVKqft29Bx2lZVnn4HiNaodqKd150fFQuYzhiJZ?=
 =?us-ascii?Q?wbTr6TzIZMX2DjaqMsDkgDXN/+Qg6ZDIfTjZYNGerYJU49BB1inVL6RO7Arw?=
 =?us-ascii?Q?cj3gyRJUMD8w2vAGRsiGHUwQ1o+fL1qE9FM0XnuUChqdVgNNbnhDpdwfMWgJ?=
 =?us-ascii?Q?dIk/Ar/gzJgQ50cd/bCTHJeBdeQFWABSChvlY+7gNRRxx+tgwztUTaAs6FFL?=
 =?us-ascii?Q?axtFgAX4upuRonnF9xNBr3z+HQbUYLhg4zCwVps4bUcjlqGXmm63AvW6o+74?=
 =?us-ascii?Q?W8GeP5oAd7+G76iA4qKzymBmg4rN4brADJtb+oejwus/vYKXK+k5zIKoEfhf?=
 =?us-ascii?Q?XVc96JlOSqAxjAB2FrTKyetmAjhr24gODKnpIT9dLqrPpoylyxvbr16GwYFJ?=
 =?us-ascii?Q?Qu/rBgPvTPMZVktiahTBNaHTTCj0cLIbOvQw2AZdtftnrJwBRAAhN7jWjkfT?=
 =?us-ascii?Q?b3ElBi+RSKRRn6Hwp5vcrG4gxl9C4kmWrMjCNc5Xd74jWKpqg7W+HiwwZWR+?=
 =?us-ascii?Q?ixgUadG+uXawc2+yaRZ6Z8kjGvbZA6EXOXBBrz7LXaHjeb1rcFai3oR7Hhku?=
 =?us-ascii?Q?DSW+vCIrjS9ONCIvpSgVT8zyz88ATE5Ekc81Sp+rpIC+NUs+iaQlZVQngekv?=
 =?us-ascii?Q?fWWnmcB05V7VHRdELRTSHiiuyCxkzdye/3J4fXq7Rpf20Koun/WpJi8/Oas8?=
 =?us-ascii?Q?7ccXFbSp6nVaDX24bbjgshUHa3KUFpkuroKOwpT5qha/Md9huitQHgAftbvQ?=
 =?us-ascii?Q?oChL4r35gOcLY+BFqcxli/9mo+/XJTVOUx7PG2xheBNZZDj6w/9B3UwKJ7UQ?=
 =?us-ascii?Q?2Y165Ada9KRC2J/Z4Z1jxpBe8gb1031O2Qya8xHtHNahAkoM2Juh1tamgWOr?=
 =?us-ascii?Q?m0GzVLBahJLdXK5D4tdUGSLW57NT8fnMq5GdAetYJQddfw5TgUuOA1eJQ3ZX?=
 =?us-ascii?Q?JhltRIi70+PVJFeSoiuNakQhDkCom2lRRa5pFyn/KJqjyTap8TSSIM/dMVFK?=
 =?us-ascii?Q?I1nP9lQjf/DW4L2tT3Npo9NknNtTg41AtOy5yONgdP/3BCeX5coLcBcqPXJa?=
 =?us-ascii?Q?ZPSoaeSxvVeaUuFfjLWNBELSQ1fycsWsPtNNIFuZw7gBeSSC4Ti5nBv0QpeW?=
 =?us-ascii?Q?4esAqTGApJv2I4ct+pI66tducqJvXTGlXsnjKHaXMfFlW0JtMW7Kqw1cPvgR?=
 =?us-ascii?Q?TJmIij/IRRfvZ6XQ1yx+1JIsi0a/ukdrX/upog57FCEIjbF4CKBWvFvONNRr?=
 =?us-ascii?Q?V4Opi9tV3g+vC4HkkBUwRhLhOL9whV4HDkSKFekHHTENaPuggmSgPDbZ0djA?=
 =?us-ascii?Q?9mB+dbqch9AGfFyp4yFzcxT54x44jPA=3D?=
X-Exchange-RoutingPolicyChecked:
	KW4bZa/yGl1igfuziRppRitguFgCvzyhyeGgmaKtjfgtZi0Zp1Fw5KPGHhotTcqPJMLrPkZv4kz8FDv9gvCY5Ku3KnweIX3d3bih9+0u6mF9j19RKl7m4wQIL5hIAHdibvXojRmD127QR/POYX2NakdsFHhmrm24ymAM6Pf5q5X5I6DsxV73b4gLjIwOAd+8z6tD4ZD8t95ReHP1ttjkMdVdFaHaWQTevwslxoMqmqSAIqbwA1w7p1dt3Kb2H2ALku/CxicePY6X040B9HWQDhGFa1Z0QvSLToHxnOhBryizh7DX3TKkArCQsfY5NMLj7GS5mzETsTXm+sRB0s3pvw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T9FwYgOmvpyr+YS31StgnOkH1qKkx/+eLoCpEX8wrxZcxZfgorZg1zph1WDu/54ay7THQE+D5mU9ockuceqgcdXd9CS+t3fsWtYLvxqgcIwJ2hJAmgLFnPiI4jFnNup3her+U1HTG+RevVoGMLFKpAgsPflVBtiJXCx6GPRXLeUaY95/o4fPUA1KLm4VslOsRZqV7uLWZHSwK+OmfzXd8RF5am4q+3NHufE3BHePcaCh13k+rQ4dXWBhLDoI/4l1U0OPuntKVrt5usoYRPOIj7XGP6oqkIM86HZzbi+6PB51QRU+OrzCzIC7AWSHq0d5CjltliP/NauClzUppACSWX8hOPMfdF/YNC05fDlYJNgsXsn7+KLDKsPLFH8catEhpLuLoIWsJLB7mrTep3HubaWT4kyZi4qXFPue9MyBvoUaKHm+MJlpd4FG95Wsvo9x/5XxhygJQvVHaGil3y0vbQaInLrXWiMKveKTHhnVQQA1es9/mg8FKZDTDyh11nPoHsfGf5Xczs9R0M0tc5IdXuOMAfh1kIqBCPMGxwmcVTetgz51bUC9U1TDOVsEcp6E+2aKTCxGFp+i9n8NWeSrZ766xY+sxBtg+jJEvYLSu+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502983ce-2478-4873-b9ce-08de841dbd1a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:19.7373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwjpr3OGMGs1XHpI/1YNZ0arPRQwYO+Jm7mNT6qrdLaXnN/xk2HTgJUCj79BN0SdViVBzYee63/EYsl9ujLhKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170107
X-Authority-Analysis: v=2.4 cv=X5Vf6WTe c=1 sm=1 tr=0 ts=69b943fd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=kTpkkXqb0D4BMuDiu54A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX+1FkyyFXs8Hf
 9+uCKjmUjkrWvtKlqL4Hctc4hSWYLOyE8126yhgB+gNDMQvpv6D4RODLW16w8kYVJcQifM9FV0n
 rlrADqGPw8/XMbh7yiGoMRzj01tSD5tE8B/W/0HpRSVlKO1ZCa6+ekfoxD4a9w3cK5U/XgqcHmI
 3NDfNGrgfWkWqSfZXg6FTO6F+cvdZzKUDK4W1fyPoU3NAhdhPMlABsLa8QC12+KZhNgcRc6Iiwl
 26lkNCVcOnJzPut9WdAEPCh2898frMhzzZoSp1lFm5kDLA21mbIp+f+wAudiDPvaVsrFa3hLpLo
 hjXA54VjfOxZn6G6OkC96KyF6QqFOBZUD65o+RBpA6wK9RvHl1FaVXMKWTuGQYF7Rq8mFJwQ8qz
 z0GiIMQLmY1+6NI2smqBRq7A/3JVzBJzm5Z9yZPKewSCJoJfUTJWuBGCqesJBdKaqmn83sU+w2s
 THWmboQ/RpCMlFBdcfg==
X-Proofpoint-GUID: lPGdBTugAML-Imnox4tMghNCCH2bzcyH
X-Proofpoint-ORIG-GUID: lPGdBTugAML-Imnox4tMghNCCH2bzcyH

Add a dedicated ALUA driver which can be used for native SCSI multipath
and also DH-based ALUA support.

The core driver will provide ALUA support for when a scsi_device does not
have a DH attachment.

The core driver will provide functionality to handle RTPG and STPG, but
the scsi DH ALUA driver will be responsible for driving these when DH
attached.

New structure alua_data holds all ALUA-related scsi_device info.

Hannes Reinecke originally authored the kernel ALUA code.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig                | 10 +++-
 drivers/scsi/Makefile               |  1 +
 drivers/scsi/device_handler/Kconfig |  1 +
 drivers/scsi/scsi.c                 |  7 +++
 drivers/scsi/scsi_alua.c            | 78 +++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c            |  4 ++
 drivers/scsi/scsi_sysfs.c           |  3 ++
 include/scsi/scsi_alua.h            | 45 +++++++++++++++++
 include/scsi/scsi_device.h          |  1 +
 9 files changed, 149 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_alua.c
 create mode 100644 include/scsi/scsi_alua.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 19d0884479a24..396cc0fda9fcc 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,8 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
-comment "SCSI support type (disk, tape, CD-ROM)"
+config SCSI_ALUA
+	tristate "SPC-3 ALUA support"
 	depends on SCSI
+	help
+	  SCSI support for generic SPC-3 Asymmetric Logical Unit
+	  Access (ALUA).
+
+	  If unsure, say Y.
+
+comment "SCSI support type (disk, tape, CD-ROM)"
 
 config BLK_DEV_SD
 	tristate "SCSI disk support"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 16de3e41f94c4..90c25f36ea3a8 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -153,6 +153,7 @@ obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
 obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
 
+obj-$(CONFIG_SCSI_ALUA) += scsi_alua.o
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
index 368eb94c24562..ff06aea8c272c 100644
--- a/drivers/scsi/device_handler/Kconfig
+++ b/drivers/scsi/device_handler/Kconfig
@@ -35,6 +35,7 @@ config SCSI_DH_EMC
 config SCSI_DH_ALUA
 	tristate "SPC-3 ALUA Device Handler"
 	depends on SCSI_DH && SCSI
+	select SCSI_ALUA
 	help
 	  SCSI Device handler for generic SPC-3 Asymmetric Logical Unit
 	  Access (ALUA).
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..fc90ee19bb962 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -58,6 +58,7 @@
 #include <linux/unaligned.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_alua.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
@@ -1042,12 +1043,17 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error = scsi_alua_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1072,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_exit_alua();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
new file mode 100644
index 0000000000000..a5a67c6deff17
--- /dev/null
+++ b/drivers/scsi/scsi_alua.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Generic SCSI-3 ALUA SCSI driver
+ *
+ * Copyright (C) 2007-2010 Hannes Reinecke, SUSE Linux Products GmbH.
+ * All rights reserved.
+ */
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_alua.h>
+
+#define DRV_NAME "alua"
+
+static struct workqueue_struct *kalua_wq;
+
+int scsi_alua_sdev_init(struct scsi_device *sdev)
+{
+	int rel_port, ret, tpgs;
+
+	tpgs = scsi_device_tpgs(sdev);
+	if (!tpgs)
+		return 0;
+
+	sdev->alua = kzalloc(sizeof(*sdev->alua), GFP_KERNEL);
+	if (!sdev->alua)
+		return -ENOMEM;
+
+	sdev->alua->group_id = scsi_vpd_tpg_id(sdev, &rel_port);
+	sdev_printk(KERN_INFO, sdev,
+			    "%s: group_id=%d\n",
+			    DRV_NAME, sdev->alua->group_id);
+	if (sdev->alua->group_id < 0) {
+		/*
+		 * Internal error; TPGS supported but required
+		 * VPD identification descriptors not present.
+		 * Disable ALUA support.
+		 */
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No target port descriptors found\n",
+			    __func__);
+		ret = -EIO;
+		goto out_free_data;
+	}
+
+	sdev->alua->sdev = sdev;
+	sdev->alua->tpgs = tpgs;
+
+	return 0;
+out_free_data:
+	kfree(sdev->alua);
+	sdev->alua = NULL;
+	return ret;
+}
+
+void scsi_alua_sdev_exit(struct scsi_device *sdev)
+{
+	kfree(sdev->alua);
+	sdev->alua = NULL;
+}
+
+int scsi_alua_init(void)
+{
+	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
+	if (!kalua_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+void scsi_exit_alua(void)
+{
+	destroy_workqueue(kalua_wq);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_alua");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2cfcf1f5d6a46..3af64d1231445 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -38,6 +38,7 @@
 #include <linux/unaligned.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_alua.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
@@ -1123,6 +1124,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_device_tpgs(sdev))
+		scsi_alua_sdev_init(sdev);
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6b8c5c05f2944..6c4c3c22f6acf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -16,6 +16,7 @@
 #include <linux/bsg.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_alua.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
@@ -480,6 +481,8 @@ static void scsi_device_dev_release(struct device *dev)
 
 	sbitmap_free(&sdev->budget_map);
 
+	scsi_alua_sdev_exit(sdev);
+
 	mutex_lock(&sdev->inquiry_mutex);
 	vpd_pg0 = rcu_replace_pointer(sdev->vpd_pg0, vpd_pg0,
 				       lockdep_is_held(&sdev->inquiry_mutex));
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
new file mode 100644
index 0000000000000..07cdcb4f5b518
--- /dev/null
+++ b/include/scsi/scsi_alua.h
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Generic SCSI-3 ALUA SCSI Device Handler
+ *
+ * Copyright (C) 2007-2010 Hannes Reinecke, SUSE Linux Products GmbH.
+ * All rights reserved.
+ */
+#ifndef _SCSI_ALUA_H
+#define _SCSI_ALUA_H
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+
+#if IS_ENABLED(CONFIG_SCSI_ALUA)
+
+struct alua_data {
+	int			group_id;
+	int			tpgs;
+	struct scsi_device	*sdev;
+};
+
+int scsi_alua_sdev_init(struct scsi_device *sdev);
+void scsi_alua_sdev_exit(struct scsi_device *sdev);
+
+int scsi_alua_init(void);
+void scsi_exit_alua(void);
+#else //CONFIG_SCSI_ALUA
+
+static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_alua_sdev_exit(struct scsi_device *sdev)
+{
+
+}
+static inline int scsi_alua_init(void)
+{
+	return 0;
+}
+static inline void scsi_exit_alua(void)
+{
+}
+#endif // CONFIG_SCSI_ALUA
+#endif // _SCSI_ALUA_H
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d32f5841f4f85..c439e837dcaa6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -295,6 +295,7 @@ struct scsi_device {
 	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
+	struct alua_data	*alua;
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
-- 
2.43.5

