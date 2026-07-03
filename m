Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532B13E715A;
	Fri,  3 Jul 2026 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074915; cv=fail; b=k63esUCnI8/yBhuZ7aGhohvp1fZmlMEArGkK1XpwI1wb3Gt45iqiBHOzcTm/qDJSSjoSUjXVKBy/1QcbrPUPOd0/tJVMg9bcpF0zg+adKDbyeZcmFw0NaAr31cYxwZa4pf0gOZwcsTUUJw9sTRdd2iaV+gIoLW7JAUd3OUfTzc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074915; c=relaxed/simple;
	bh=2vZK68QvvqykGw/BIpwrFWguubyoJmsIWw/F94OhTME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aa5i6CamwkpPCAJMFdwSr1dEJ8lP21HNW7TDJ45/ldqLJXW/2tnN7Oiy8zq+6f+ChEtXF3avR7pSSptIq9ZtD0/I4kPSOA9OvvJ7XsLngHH1EyDU1QJr7FRjYtst+3YWfadwP+zB/i/CABN9jy2lJ/6Xe6GlnaDt6ncTpnNd7lU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XE+wsyp3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CxwA/p+m; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XE+wsyp3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CxwA/p+m"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tdcK3088707;
	Fri, 3 Jul 2026 10:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6t3qFUp14jdveapk+tfw3Mm/uEBbaKlhQq1GwZtxfSY=; b=
	XE+wsyp3+2BE7436gGJ688Nhtb2TgFPELjb21RXk21OpYVxwZZstsiqlWxPgbQrI
	6nokgl//j7Pdb2kPtXetuyulzlSGSoZumEuMF6UbjLkg0tQeGJ+ziwGxW48NBpV/
	0GzVH942C1FOyuXOEru0QTHOLO9djrwqmjo6vNAGbQuYI5wcMRlPcy7nCBc7xpiv
	FV2S89cRm4dQwY3GWZZgRl7QveOVdMwfAE4d7Z5C0AC2SpBP89YcMnPC1usnoQWk
	jpJu1SMFH341eljhdmnBI6zGtUK1FGNmlnwfVVlOdSfleRq5a9deNmlDvOTmKDgt
	Elia9hxFL7I5cqX8Fcuutg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p4afht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663ASW7K035268;
	Fri, 3 Jul 2026 10:34:54 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010005.outbound.protection.outlook.com [52.101.61.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yugx8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZW6vTSmuee215KEhnbzDClTESdq5Yyl/GZnSgi9vy2ycdrl0QSg6fpEE4+ddd/aLozkpMPRpB2W+N8dA+0VCXA/S2VZyN+Y3ciJliKt4a9MGdnkfT2A27bgmspr9xzu/cFHnZhB/zrsQ0Rmps1Qt4FecgFVbWPrUkticELu/I0IUaxKmWDY7kXsB/VjlU4viDFxlP8VvhnKbxvo8zKH0POnhGqlR4sjJjB9nXSDTXo0BcwxTHHdTv3GQ4lrE0A6UlDaKD3XepAoiCxJDQb/g51xzhFVTLNbM8FDjOaR3mDmbrnZScq7caa/XLMO/7Qi9ZJqpq7T0OFA6RPpy+yaEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6t3qFUp14jdveapk+tfw3Mm/uEBbaKlhQq1GwZtxfSY=;
 b=jIJmwH1hKHPPq6iRybk6hJRf50TLlXQ575HMxGFOYoP/1X5AMrIORB1WlkHZYnW4qIBj2Sgb9Z4vHdaGEkDOfvusvmE8cWRbm8YdwOkgf5Nx5XLXPtNoQRuJrfSTF44vPKrqAguTq22rKRu8FQ8BakUnhBssDeWE5ELjNvF3Stceq013/assQAzFFMPTgebRNcryOSI2/xiRDrnfgbr/RvqEJ37/F80tMGSJuWodWI7hDVXZNncT/MneqDnM+3HezuFYm8C6xK0nLvQVKxgvpUsSchxBRQiDvtFvWQ81SWMIKDKLVHBsmIPoQQnzP3LnsAjrIrrzWdN7AqKlm7Kuxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6t3qFUp14jdveapk+tfw3Mm/uEBbaKlhQq1GwZtxfSY=;
 b=CxwA/p+m2+bTQYtgIxnUGomoTVpPyAWQ2UYzNQaVP0oETxTiFh2RHJFAP4EhJJeZheD6oLlZ5ZjATMd8kjQarbRbJH51KJTII0gQRt7AEZ9BG8xlzufZmcu7xYuIMUpk4lBg4XpVZjoVivVa4/9t6t23cmNOLjXDCLXDGky5yb4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:49 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 10/17] scsi-multipath: block PR commands
Date: Fri,  3 Jul 2026 10:33:55 +0000
Message-ID: <20260703103402.3725011-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:510:23d::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b89c32-5f71-4829-a2a1-08ded8eeb531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|3023799007|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	WQeKbdAMYjlHuQ7P+PfExFR/0+gEklzG5fyCx2jIFOVIKioxenoZkMMfYKy03qcDtY6sBAK5mD+jE4G1BFHtacpAuQGQbeCjRtNo3rnuUKH844LgQ6sGBppmZ0FwwZ5bBd3mIckaRfoYut5mEibGmY2rf5q9GgN5gosypcjj5olMoc3wDFV194GgkWNt4Je5oPAMIgERaadYuj61/WuqW/FoF4bTbBBdgfdFwI/UxDbbLhxIef7bo+mG01RHrOdj0MLE/oKBZ7ibavRp2SsauAUW9gKS/fecupzEAH8hRw6usrhDqbLKqMmcQiiKjeLm6MnMxrMtqvjvQveAEcEUag67w8sO79EYn086lSAJydPOl7s93tlnX3iho/Ii+tsO06J+JCbGwf02hFoyGn1hMnQjiLoEO3dHVt8FvY0lcvD5lgiHqBltD2pcVBiUIwXBrwEKIODzhVFw8D2GmMGR14+b6mr3HsSnDwVA8SE5tK/Mnix6nZON31o5NYmstkEwj2/zza1YEpomzKyGmgajKXk043Yf8dIN7ijzM1H5jKm9L3sRULlIbtXanr2QM04m09zsAUIFvCgIU+WHPOQO79YatkwnJ/CSOwAf1JKhAeq/Asr2J265URONQSL0r9T7vTwKlPiEylip6Poj3dkNxCsiZ4YxE3pJlzfS4HNYOsk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(3023799007)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D2jf/S0uan0YTU1KCIcuCoDeXEo6EU8+tjSYyF4XykEFKDCDz1YI3yW5yY9d?=
 =?us-ascii?Q?GqTZ5KuNdiAqyuVJKdj83/6SYlMLbM3s7YwFajLxMCPVMmVVyMc5CuyGHTVe?=
 =?us-ascii?Q?V+Rq19idOi+YuW8YxyWrddzaWo98EiRonPj4Siktfho//HwDACaho2Q7U21t?=
 =?us-ascii?Q?ZH8Xe3ByM1vJojDEBANS6Detk46cUX57qk7lFbevRvUztUGdd4U65RYhAIZL?=
 =?us-ascii?Q?qUGmEDSaU7VcOFIDBx+1hws6CZWZXBOL12W4NTUzD/9dOoqL/jEtK+tnIZSU?=
 =?us-ascii?Q?ggyBvKzY5S/Iq6IY2Z1G1h4aosUpAy7166D1xhqC8f3aFf0Ah2U1Z5agrSdf?=
 =?us-ascii?Q?4ehSRmRazKPrckkzn6CfA7p2SeNaHHxGK/P0TSN9Hs+7g0viIbRUGHZog/l9?=
 =?us-ascii?Q?APP30oI9giKT9OqZUfzude3iit5rgEw9juFZVrdxt+8pIX7T8EafQvdo9p5E?=
 =?us-ascii?Q?7iYocZWEn/Iu8moMWNeFtcgEP+R9+BLM3I/+ZgFr8NJ+Vtmixf5saeT4BK7L?=
 =?us-ascii?Q?m98z5l1mNmlDa/Ym3vQAtgG1rtUy5+1EjouJRWXKGHTvX9/pOLjUufOaYBhF?=
 =?us-ascii?Q?zCiFlXJ9MSSpa+HjUviqHSXLZc0eEerfYjk2mgyLdFhuZyS5pBGMHn+9JtYg?=
 =?us-ascii?Q?hDC0G9tHJENBHXpRaE4Fgf7c+8Ar/UqwnC7gtm+qlfCxSMW1Lm3OOag1ithn?=
 =?us-ascii?Q?g3aOs027podNgoxa8ChfjlOCj/LaT0r87ttam+Q4HhZyIbpJGwbqfAMRIH3e?=
 =?us-ascii?Q?LSmrD6cUZig2vFVoY8NO1jiLFhEtpyT+6I6uTfn37xDp0sRNvEVMSzsVH3Bv?=
 =?us-ascii?Q?ehjb655fDXZzQagD8/KcNMpqg5jbV3157GheP65cSD9UWQITJMI7/dkg0OAM?=
 =?us-ascii?Q?Z3+iXrEsgvSEnxcImAiREBgsG+4yk/c0rWwACK8dII1/QTW0lidLqklTUKcG?=
 =?us-ascii?Q?+uoDczS1dmrFzz+ZWWMS4Be7RYOx7taCdXKbXJqiUnY/gNJL7BPhq6uaV1+6?=
 =?us-ascii?Q?o7W5hRu1V921PZ7vA37HGA5BtN+yO22I5qsVOLuiI52AJINvapTPGztG9pKC?=
 =?us-ascii?Q?cxNJfsMhF9M1t15625SEyfZtYYc2AlKs1khohEMVLBMwQuk/DM0r250LmgQi?=
 =?us-ascii?Q?nQ8U0f4ge6jMn+Yb193B5tycrd3rjLnyNUBSdQCR75518qcOadk0jCdMxTYU?=
 =?us-ascii?Q?GVQO6w2AJ/rkNlRXiXtSS7YILXrzkQJt+z6wC8NNJ0N5/CYyx67MtF416bvS?=
 =?us-ascii?Q?7INI5MO5pVrN11hshyEmUdOd2LwBFPxv3IxZmNQaiOC/apY24YGnocAAyvl5?=
 =?us-ascii?Q?jTnR5/wenG2SFM8IlRMLiGa9I2TGG880lf8R1Yx9wXZbxCyJObRN/1WPZMAa?=
 =?us-ascii?Q?QLZEVksrJyKfmzVXEHD0E1RBwz7RuwQJuYFtCTZRefcsVohhaBCFO8m0R7R9?=
 =?us-ascii?Q?NLuIPMu7Bm1vo5Azno3Ldb1KXw2gSuetVeiCThhPOd8PeYEhCyLEXm9fOAs8?=
 =?us-ascii?Q?YyjxCaZKQtMU60AQiA3Yt44aEdwiFXX/9HjlolNelXlf97Dgkgrckts9MbjZ?=
 =?us-ascii?Q?Ns3oQOSmGLXdcR+OZmEP9K0PaTlLoLUY0N62ESmJ7Ay+ZwgRwxyOEEnnLBYb?=
 =?us-ascii?Q?pQl73QJCFkdwlMH3Y4BJDOU9F+l8VgXTfD9zBAy+w3fOtoxheQAkiDGzPFHk?=
 =?us-ascii?Q?yWm6bi0gKF8dKkw/9sRN7VqmBmVIm1pJcxSHm1qutgehQuFN7j3EdVPyrF4h?=
 =?us-ascii?Q?A3QIZ2BQ7BJW2zlSWwPqi1DAQnvQYEI=3D?=
X-Exchange-RoutingPolicyChecked:
	jla6vVnF9jzEFzV9HYCPo19BD5W7Ww5zM3fyfAn/GNO5IT+MuKJf82YlX+E3v+OR+rY2CJ+/YaOXGXjC5HKxk4j+Q4PtgHp31nqdQNOGfNK0Uo4yQMuzR47htk9uLPnRFU9VanW5n5hbbfX0AcstiC4W1FV4SvCnMOpImpXTbn+5Ex7mGhV+eLaFQPc0SHbyTMRKX90R5MqzFqMMV/ioIn/3ldaLXhOqlWHbYRGdZkOh6MOYKhGUdyTuPhymx4qMnK9PR4uVdGL8ud7n8ySy2650Zinl6uSJMnknzWuuKkFfOIyOFQ5qdvd2VvGndyiHh3k45GX413BqGCfvXrCF1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aExi/TqZGhtExsqOHSmK9sq7OWSQTmjWZWoWvxqscwDz4csolxo0EPO1fXeBpPTF6ixf9BUqYUllfiSEsR/NFtAlyFXz3Q9GvgmViGs3SH2KR+LN8bNO1/qD+V1u8JFJqvfh/IwiY/P/+PTFXuyMAYCehCfH3rg32P/QOtqhaJSnCW7E9JhLugGm4nCR/nbD55wQDSDvsmEGWY1EySFLEwI0USe0bYkkNkPyBekHZ8uyruUcE/UyAjIcl4UDwXIDoumKrXGiQShzLjl26Dha9ZpQSsdiWMQV8opTmbixfV170KQ0cHZQpnfFa6IolZXSGDa+eHTTH7Ms4CTUKg8umHmdkjQFkkz4KdJ+RLONAi213K4Gvv+IYV85xN7ZNtWHdSDtVi0bFO3mNR5GSaz5D+EK29qgAstsrk0lcEcTCvPdYuZbRpcWiK1mSNkvK+gWZT1Jv+qyOZbuVPoq2icR+aUI8T8H5JNaZL5kaML9KkWE3wPmYuvmdmVwKOOZj3PFENz5cZHxuvbk+NaU25zByGuQ2fBp8tiItL4VL24ejNoqrJndaR400aOMw/oNLggwzeCrM5vHnLFdB+N4Q6LYbovEvlnSE2JVWXGC7oraA6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b89c32-5f71-4829-a2a1-08ded8eeb531
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:49.0136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYYmfnpiC38q/ilz1Zz/v/fcN8DkyGAbPhDrb0q5zljZ0M2z0m3ipSuQd1mdg3ClfzmvARv9WB3h0V7B1P9mVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: MUnfeG174LRf5KaKhK8pWNUqd7Iuq3eZ
X-Proofpoint-GUID: MUnfeG174LRf5KaKhK8pWNUqd7Iuq3eZ
X-Authority-Analysis: v=2.4 cv=DK6/JSNb c=1 sm=1 tr=0 ts=6a47904f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=ly_y6h6M0B6UD37WiEMA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13723
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX5t0b8mgauprF
 j33WyI8iPOaebZlJw6fBOXKa50vVghfGHZ9502x5XSZG1Bp/gDtf6OPQ7CT0gzwG4MbXqY6Hm/R
 o8QBagrq03oIk045iAgR5T91O2PIgViu+VKS8OBHY5ScRWr4C38G+ObhMs7ioVSz7fUL4eGaGQK
 Afd2UJdlO18tePq31QzWypJaK7wtuiD9wcdhHLyf5eHQsW7YkqwNELB+sM7i7GK6aaJ/dcPLz1n
 J3AsIUN3QijW6nGqzj8qCBdC4VLKKOKHJgXoxtaco0dBXnpW+dcnbNqMyCfjnFaUQPU+1mgOc8Q
 3vUPjc/jL0rLcz0mjeMq/yGy5bAhKjqWCIlqIlN+O3jm4jZ33A0mhrSKNdKVBN9e6Yadmo2jiGh
 L+Y4VOvZNMewvgMsY3y8YhioaTdAilrTx/QcaTFcz3LLs9AsHRPQWIVwg+onrXWDRBaAZ6GreSt
 bDVdQjbFTWbDViuXi9J3qcXzljmEIdtXveR+o7dc=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX8mIv+y8brV6Y
 MwVrKFwgHL4e6/P6dk7fMiVdnZAGJRKYYzYpVNNCzsvwx2nirNAWD8bWGrIa51fbobY+ALFimVL
 3Be7lcnCZlW12gUBB9XRC/HhwzES7DauVqFrxNVR/5feBO6krCxt

As described by Benjamin in the following link, PR support for SCSI is
quite complicated:
https://lore.kernel.org/linux-scsi/aaHecneNg9Q8EtiS@redhat.com/

For initial scsi-multipath support, just don't support PRs. This means that
we need to intercept PR SCSI commands for passthrough and reject them.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  6 ++++++
 drivers/scsi/scsi_multipath.c | 11 +++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f8b389fda2537..42f6065c7d48b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1320,6 +1320,12 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 
+	if (sdev->scsi_mpath_dev) {
+		blk_status_t ret = scsi_mpath_setup_scsi_cmnd(cmd);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Passthrough requests may transfer data, in which case they must
 	 * a bio attached to them.  Or they might contain a SCSI command
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 61fa2e4cdfdab..b4d9d6518b4fe 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -242,6 +242,17 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+blk_status_t scsi_mpath_setup_scsi_cmnd(struct scsi_cmnd *scmd)
+{
+	switch (scmd->cmnd[0]) {
+	/* Special handling required which is not yet supported */
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+		return BLK_STS_NOTSUPP;
+	}
+	return BLK_STS_OK;
+}
+
 static inline void bio_list_add_clone(struct bio_list *bl,
 				struct bio *clone)
 {
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index ed5c77d568843..520e4761fa0f1 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -45,6 +45,7 @@ struct scsi_mpath_device {
 #define to_scsi_mpath_head(d) \
 	container_of(d, struct scsi_mpath_head, mpath_head)
 
+blk_status_t scsi_mpath_setup_scsi_cmnd(struct scsi_cmnd *scmd);
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
@@ -64,6 +65,10 @@ struct scsi_mpath_head {
 struct scsi_mpath_device {
 };
 
+static inline blk_status_t scsi_mpath_setup_scsi_cmnd(struct scsi_cmnd *scmd)
+{
+	return BLK_STS_OK;
+}
 static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.7

