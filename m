Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FA938A725;
	Tue, 10 Mar 2026 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143411; cv=fail; b=U5lpvHZbZB6dyIeNAevORqOqRZ0POLM5fl/bMIHz2Arx4My3fxsAxmpParSoDvxgZNpY7a3On2zGw36Uu55BQLGHoN4BuTejlj+edfZp4LKk3OEFIMuq3ci45c71zgazE3tSJZG5QhEK5YTTgLQ5a5IB9WnJH9dc5pVqNsn4xKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143411; c=relaxed/simple;
	bh=sPjRpDYqwjwpemHUoo2OXIbcVuQu9lajdGqCHxdrUrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eS1eC5sVoVT95QUoy2ShUbSH8Zx+ACjkBXWv1qhBqnPm7tznYc+iyZMXwI/wAYc+eN/8SOeGROtcUcl5/vWwTP1EaXtXA5wQB5pG1YNVOYwPr+Nwvhj5Dep42vEYsJxJlirgCEPzkPEeqqA91mD5m2SFG8sOXjXn6BP5CFrYPI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SO5jTP2t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x7aoJtf2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SO5jTP2t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x7aoJtf2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AADYPV2346954;
	Tue, 10 Mar 2026 11:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8n9Unpn0RFiP0EZbsLgPY55R6k52/EtX0jHRIFNIQKc=; b=
	SO5jTP2tULcBeThyoAheB2OUrOTM8T/ctSzJpTsDJsMvnMyWVJWpnmESP0vK8B1C
	51B5AF7xA3CvuzZSptwAQmzGObLLTslxkX2g1ahcElUpbVsk3KQ6yM11naOzw2Gc
	YhnDFz+8Y5uyqljzuqSBVX1jUyMfDnltA/ePXNl9393vc5sNbhVk2Cqr/8WTPUAO
	EBR1gLKRjUj7IWAkCDv6EZOMK+7flf26cgQ9ONU4MHKQP6mua1knwjQIzxMZHKa8
	L3V8cQ7fOxN9HrdB/Y+h1wMSWPFk8oL2VKWP/N0hSCP0kql4MhL+AXpmsKPpUJ79
	mNjEKJiCsIq0Vj4jDf2J6w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmmaanb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AA07Fp039595;
	Tue, 10 Mar 2026 11:49:48 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafa18g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9p5sYEThsTBPyPBXCV+fsQWx+9G58Fx2bdXH0AnnmgAy1OCwPiSeapcE9Ivp/PV1nT1rD2sTALzr12LRUK9cNOIy5hlA089GlENRDEoudd+EW/RpqX8riG7HhmkEvBq/TFPlG0fG4uv4Pwq5NqTDnCs9H+3Jr54fN94rilVWB0qqX4OyA8klSHrz3gORdWEUwbjrV5xpHorEoCYlosdPiHxbU4qaKYsUTDXlzEiInQ791Fj2xxR/6L0YhyDTkqqcriqkIA0/ZRqVo609psoPc4d53aEKDXPM5gMAd0qCJ4xZnVkSwUWtNtQmIXpapkjiitJSqm7QCQaEldPwCLlig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8n9Unpn0RFiP0EZbsLgPY55R6k52/EtX0jHRIFNIQKc=;
 b=WvgmVdNhl2c7INOsKFkUZtk8S0on09Bye5CRwJd6NmjY42uZpUKphene9EgP/V3KPjMU6EldYW/MyGM6eIov9CrxsfjBUPjVUJ9y4DQ+58ALluoKddn4Tfc5LYE4zTaGH3nfRS3PsazjdITILft79YYlC/sjp/2NasQdfg6MO+8zrz4G6yjdw/XnysCoBNWr16uuYtefkPu3bb7OhE3y+RggM/ExgyUwAYxE6sTRVB1bHrhp3v1RkDr2d8wtN2eYREcvUtmw8LWI1zQmmgwkBhizeYWNYEYtanOKW4kXgxXiizJwMNr4fuYQDtYGDy2iHcZjOsnG6B7hVABKZWRXpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8n9Unpn0RFiP0EZbsLgPY55R6k52/EtX0jHRIFNIQKc=;
 b=x7aoJtf2mY/nfpm8YWDUXG1Q1vfbzkX2G70fVNlMtC9e895sLbbQosMxRCgHo57PjQLWNSJr39tdhwXLYfw4CoQkMaq0oo5x66NAA2rHBMQrmcTuwBHzPsNEsabV+y2b4PRObjpXCdKSMNZU6s9o01oDHbUUsHA0bQLcjra65jo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4519.namprd10.prod.outlook.com
 (2603:10b6:510:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:49:45 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:45 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 4/8] scsi: Create a core ALUA driver
Date: Tue, 10 Mar 2026 11:49:21 +0000
Message-ID: <20260310114925.1222263-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::30) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a81f20f-28ec-4639-e48c-08de7e9b2005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	tbiFnXFeKpjFyaHoO9Z7qkNx2Rd62m4Y4uybeWwH7tcaANl4GUgUKx712i0BVr++7LBIEgTmy7sM4mjpgoDuhPJy7xhqFaF9+Iae6VdgNQvC4sszGliLbBUdArsK7GlUjvtrlc9YJ9tC891LkgzpgZ/JbEH9u0KJqOrIeFzdbRBpTXZjgfWBIf/jN/ddu0HRIEjwV8cifwLngn3KW2pq+JIZHtMZPLIIXZLaRr6vfR/E1ezQi+Zqbj4bfg6hyEhPsLfj2zZLxM3gWl9UeHfWvIQtSf0bCgJouLwUjYHJ5GvPeuy2X7yamRyxuhk732nzGoT33FugIbQdz+wszQZ2i6o2xZ4XUaNPwfbwshUoJvWGwpiCRJL+V6BKxEcgvBGL2GTqv9TEXLQClyzFgjIzgRaUXi67xeAy6zS8nG4IOguNkT6not7hvtlwUSs7SuGgHjvT2d5vPOvrAVpZAjO6IX23tJa0m6gonczOlAeVHOOaP2wyYI9Ou+G6Q8R9YjQcWNYXY7ZScoanCeBKOuP8M1kX+e7P39y9VPWm8kIjR0wUJQIIr4rPLT+2M1Cx3oOu8UKolDeUG5EGsx2xQL/810bmkll97aXe/fSPo2fzS7xfyynVdX3nPDgSwZmmiHQVJQZwQJy/oAhDCxfApdFNbTwKXiRmwtYtkSQjcoN3dioN+OlrVEMjROPM+DhYCaNsJMHMbM9oxfQ/WBVNttpBtt/GDxgXP1cyyIoQ3ZJZ8UM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?irRTKCdmBh1Xufhe/43OctqC16Kw3M7HkWX5KuzPM3/G1Xi0L7h9AOAp+YnQ?=
 =?us-ascii?Q?2roFyZ84nlOjaAlDyLDPr06ggb3K/qXAw+BiMu1jDq2B1LgO+O4Ie3AxyBi8?=
 =?us-ascii?Q?Ku9QckfiNkpvKBRMgMtqcqFbIZqSgw8NHn6kpO3WhlfJKRS6ssl7nBxc95As?=
 =?us-ascii?Q?seyXjfST7qmuNdsHdn29ALYa1ynygq8gteuPg0N1IzLRoNx1GcVS9Mdtsau+?=
 =?us-ascii?Q?R2DopLC8CFCwHqfc+Dout1Za7GFXD3sYiirukcc6anMeM0n+GT6Ci1hau70c?=
 =?us-ascii?Q?K7tdsUmAof3LrO7HJ+4Wz2DEtDb7RJWttTxfKMSb75YHcRo7cbS153un9YNC?=
 =?us-ascii?Q?IdJxZ5bP7ezJdtUcI63sAJ4s7UDH22gm8uh08rabev69FN1N2AMcIt7yCJtY?=
 =?us-ascii?Q?1AvXnvkhNhPU6maEihSozd3eOpD7Gyy8gXkIftpAfO53sPicLpM4oLYh6sQN?=
 =?us-ascii?Q?pzMrhPO4cgOyYlWpH4bmfpo68xpnfzsGGp6SgXJAlEz/NKrEEAKpdTQdSrGy?=
 =?us-ascii?Q?9WVua1+DHAKU6HC+u2GgVMx26iXflpgujqOXKbmVeQhbPIY8iwo2dMoG+cPm?=
 =?us-ascii?Q?9+L3ugNkQCcdhggD3hR5CyWU/DNj4YwCLT7LSUTZ7S0BOvYU8WQC8FJyv9WD?=
 =?us-ascii?Q?J2U0ZcNCrNAo9IAZv48qtSup6eO4iXrXW88o1T/ZPPPTAL5s6qKbxKtj45P3?=
 =?us-ascii?Q?DswdPLWpBWRVjTMUsthg+3yO7Ut29FoHczs5Qo+tjgzR1ySgTaf0VF4QZSic?=
 =?us-ascii?Q?5k9WT+pFCqSfsDpkWHJ/JGOMX6WSbNkVdY0a4l0o/PbgYTYr4E/r8o9VT3Er?=
 =?us-ascii?Q?o6Nng8rGmSTVBqggPfVy6C+oAojKRyotOx/3STSQbBRrWAJ5AKrSaKxzGWPX?=
 =?us-ascii?Q?ifFZWli5chydyEk+0KT1XcS5nXDGMkBuNu685zmDmR3DvB9zNhzD8wZnWVQ5?=
 =?us-ascii?Q?UGyrbqQOK2e/LCH+eZB+WiXxLMAQHzjU2bXJANbQwHrkrzqiDyEoxN3EwoKl?=
 =?us-ascii?Q?tl8/4S/oOlSZqxaQ/DgqpzhgiFttKpE+/4om+hsMYwKOd565oeW2ybzvlpd8?=
 =?us-ascii?Q?jgSuCANJUAhoCk4gP3Wk/W6lQacGNlrB0+lqoP6CfLEEenwBDY0gcDUj+mVp?=
 =?us-ascii?Q?zpBhCWmuZXlSzI15oIJml2blDn8ddv0FV2ZDoAJik45WH51TBr+k8j7wLiW5?=
 =?us-ascii?Q?unQm+5MODqtZnDnBlPErALussNozo9msShUhd5Gh0ExrEY5zz0Ieaew67Gzz?=
 =?us-ascii?Q?/xb0RLtE+nQvXyVh6nArzd5U44RPCbUZEdrZ5VuQcjWl94UcsGYytgwoMciP?=
 =?us-ascii?Q?ycyhBg1C9ELhlBM1akcxZgnw6LeRFiAIH0Sf0wG0plyYUNQrFMOSmtLKnPlM?=
 =?us-ascii?Q?+I733OdgMDv1RJRGh6U6cyvad2GD2g11wIUurl1pc9FAWy7Fs1sQN/lN/hT5?=
 =?us-ascii?Q?hm83dPYHitCBPHI2cPmlp57MfbQeE+I/wFU/r/yn+uVGjpWsAfAzbxPMF6Im?=
 =?us-ascii?Q?JGPDFeVEBzEoRPL8EbonaD7oLkK7tF1cdScgVp4LSRfgB9TStr0Ekzc7CN5k?=
 =?us-ascii?Q?tD9fdHYwlCRhiWzLB3G+nomhWayyIsbBsN1BKeMKPFe6QMC0eUvq8ORYEI0p?=
 =?us-ascii?Q?FWCfLQsOSbZ9EhLnLE7tTQL8mncSlzVQdlh79NSVvQOfXXXWTDHB2DpoEHlt?=
 =?us-ascii?Q?VUgi2Tn27sssD8vNkCkJLxU2XZiFpAgdgrHqrTlN9JwI0kY2xNt6xXv20oBH?=
 =?us-ascii?Q?fgHcjakrnQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	OPSnN2AdvbbOVbcuH4wICYO7iajKsu9T5HDjqolJPK1tGXISCXeibKlOGPZriI+cXW1SylVy0+Uo9c3jx5+q2+DEiuzB5NsTNDyuVQNINW3LU0y1LYdEsdvNN3VHxze+d5FwcUNaNO1vbteoIK0upgOO8yXD+qjB4PweLcToO4iCwc9lke0A52bw0ITtNmY8SIzBrdNEvt0ePfDPw7L9nG0pSH7/QlnynHOvKGKT4MddWC/Puo5Mnph08ipCex3EFQ5fe3YcQBwsW0LX1Uakl8QcvuTLz6fhEowhbhxgAupdQLUCYRhr3G0Gkj6eERJ5iFECRpVNiWMDhMpsyUBJWw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eNm6PJN7dIvu7hCRSj/IOiwxAhme+hfOLvTzOaSNu+2JRIrV63VsiAv5KgeanLl9IPiR/5Jk2ma1rOWM3XNi9mPvF0MslSBzAmqc9nvsP9OS9+xthdLFjmsHH98RFaG2vd5URlMSKwUzPXJCCl1QP4j9zZw4GLr7FsA+kUrVTEGg8BTVIsSV8RpYofjX7VzbJhh10pHE6gzvLoYOxOiUxaTcrdyuDl+B/nZx7rapXQGO8qj1rHbeC/3eoJcSKP0ySELpNRgUE6LTcy0iJ8SZflVZRIcFN2SF7s29QwRntyTxHnNtOhOrqEjm0KyeMDvGwcvohYEVIZgEh++W526EviR+q7wST48+e1xYNjeNqIlUAG3J1fvhgg0nhmqGWXXtTjQaFEGTY61vXSK8Pv4VJZQTfUPbPXPr5UtjAR3GyDXwQvrdlOHSPFxvvxllNgyqDpAc+akX3Fkhh9BlRfQtbYBuEIOIYAOFsGM+7ChtVMrReLwvV+UjjKj+jkpYUljP8QeTBR67M2nZnmZfWiPUSwzFuDtcNK2il7mjnOAZ9kdYN8uG3EGUo18pEPmJ1VKMhwjUMSfTMZIE9PzQLotz7JgpdI9KvB8FNZMIJPVj4yg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a81f20f-28ec-4639-e48c-08de7e9b2005
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:45.6852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UELDF+2V6MoW+33IZH2cAPD8gJo/rgE6w78yjGT4m38lM7340Gr4UMipm+ITLzVL7D2f20XP1T+yHBsIH6wyfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Proofpoint-GUID: 2IGW4-oU6cXv4jqDiqWSNiYokvKOGJVR
X-Proofpoint-ORIG-GUID: 2IGW4-oU6cXv4jqDiqWSNiYokvKOGJVR
X-Authority-Analysis: v=2.4 cv=U5efzOru c=1 sm=1 tr=0 ts=69b0055d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=XL_M-tDpjql-NjFPQvkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfX1l5Gxb0sutl0
 FtcXcl3KAWhCy2fKWDRKcY3IHy3LpmALR1pT/gFeE/lx1DFBshd8wTBqZXVq8dZvcHD1ZW1uYue
 oKWAwCMwPTgn9YjziE837hcqHcmjl+6nJWwEiCOcKm2Szq94W/SF9Of96Te7ydnqed9Q0qcNGmL
 rBadp7jcw+ii6GdNvV8BinTgbnbqVYPE0VyPyMjRaB19dnUmRaE8x1zDiNNgPHAAvXLP4bCRbVE
 QsRGNupa+li6C2D4XmbQQvG0HmJqOh+GPjHMraatKxdtvsckTmgkVvY8ssg4Y2iSQUI6cMPOUdP
 ODXNo/c6BQO3EzMnk4+z7eb3ifJn+jN5+K7ZI8UB+XpLL1Vdbv39dRm2xGuE3yWi8Z72Tp8/w1F
 JjI88B6t/pe/ik1IY6PHaiXF4rPnD6Zu9kLDBWSqvJpNUALlK2qqsfKiXgGrYJ5sxQVKJVIIxvg
 wRNvJW9884kJBaP/1VQ==

Add a dedicated ALUA driver which can be used for native SCSI multipath
and also DH-based ALUA support.

Only core functions to submit a RTPG, STPG, tur, and also helper functions
are added.

The code from scsi_dh_alua.c to maintain the port groups is not added,
because it is quite intertwined with the DH code. However the port group
management code would be quite useful.

Hannes Reinecke originally authored this code.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig                       |   9 +
 drivers/scsi/Makefile                      |   1 +
 drivers/scsi/device_handler/Kconfig        |   1 +
 drivers/scsi/device_handler/scsi_dh_alua.c | 198 +-------------------
 drivers/scsi/scsi_alua.c                   | 204 +++++++++++++++++++++
 include/scsi/scsi_alua.h                   |  50 +++++
 6 files changed, 269 insertions(+), 194 deletions(-)
 create mode 100644 drivers/scsi/scsi_alua.c
 create mode 100644 include/scsi/scsi_alua.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index cfab7ad1e3c2c..1a538c84ddf0a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -86,6 +86,15 @@ config SCSI_MULTIPATH
 
 	  If unsure say N.
 
+config SCSI_ALUA
+	tristate "SPC-3 ALUA support"
+	depends on SCSI
+	help
+	  SCSI support for generic SPC-3 Asymmetric Logical Unit
+	  Access (ALUA).
+
+	  If unsure, say Y.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 64b7a82828b81..053fb51d98092 100644
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
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e9edd45ae28a3..42fa6bf8bb480 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -14,31 +14,11 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_alua.h>
 
 #define ALUA_DH_NAME "alua"
 #define ALUA_DH_VER "2.0"
 
-#define TPGS_SUPPORT_NONE		0x00
-#define TPGS_SUPPORT_OPTIMIZED		0x01
-#define TPGS_SUPPORT_NONOPTIMIZED	0x02
-#define TPGS_SUPPORT_STANDBY		0x04
-#define TPGS_SUPPORT_UNAVAILABLE	0x08
-#define TPGS_SUPPORT_LBA_DEPENDENT	0x10
-#define TPGS_SUPPORT_OFFLINE		0x40
-#define TPGS_SUPPORT_TRANSITION		0x80
-#define TPGS_SUPPORT_ALL		0xdf
-
-#define RTPG_FMT_MASK			0x70
-#define RTPG_FMT_EXT_HDR		0x10
-
-#define TPGS_MODE_UNINITIALIZED		 -1
-#define TPGS_MODE_NONE			0x0
-#define TPGS_MODE_IMPLICIT		0x1
-#define TPGS_MODE_EXPLICIT		0x2
-
-#define ALUA_RTPG_SIZE			128
-#define ALUA_FAILOVER_TIMEOUT		60
-#define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
 #define ALUA_RTPG_RETRY_DELAY		2
 
@@ -119,70 +99,6 @@ static void release_port_group(struct kref *kref)
 	kfree_rcu(pg, rcu);
 }
 
-/*
- * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
- * @sdev: sdev the command should be sent to
- */
-static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
-		       int bufflen, struct scsi_sense_hdr *sshdr,
-		       bool ext_hdr_unsupp)
-{
-	u8 cdb[MAX_COMMAND_SIZE];
-	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
-				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = sshdr,
-	};
-
-	/* Prepare the command. */
-	memset(cdb, 0x0, MAX_COMMAND_SIZE);
-	cdb[0] = MAINTENANCE_IN;
-	if (ext_hdr_unsupp)
-		cdb[1] = MI_REPORT_TARGET_PGS;
-	else
-		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
-	put_unaligned_be32(bufflen, &cdb[6]);
-
-	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
-				ALUA_FAILOVER_TIMEOUT * HZ,
-				ALUA_FAILOVER_RETRIES, &exec_args);
-}
-
-/*
- * submit_stpg - Issue a SET TARGET PORT GROUP command
- *
- * Currently we're only setting the current target port group state
- * to 'active/optimized' and let the array firmware figure out
- * the states of the remaining groups.
- */
-static int submit_stpg(struct scsi_device *sdev, int group_id,
-		       struct scsi_sense_hdr *sshdr)
-{
-	u8 cdb[MAX_COMMAND_SIZE];
-	unsigned char stpg_data[8];
-	int stpg_len = 8;
-	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
-				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = sshdr,
-	};
-
-	/* Prepare the data buffer */
-	memset(stpg_data, 0, stpg_len);
-	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL;
-	put_unaligned_be16(group_id, &stpg_data[6]);
-
-	/* Prepare the command. */
-	memset(cdb, 0x0, MAX_COMMAND_SIZE);
-	cdb[0] = MAINTENANCE_OUT;
-	cdb[1] = MO_SET_TARGET_PGS;
-	put_unaligned_be32(stpg_len, &cdb[6]);
-
-	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
-				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
-				ALUA_FAILOVER_RETRIES, &exec_args);
-}
-
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
 						int group_id)
 {
@@ -265,58 +181,6 @@ static struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 	return pg;
 }
 
-/*
- * alua_check_tpgs - Evaluate TPGS setting
- * @sdev: device to be checked
- *
- * Examine the TPGS setting of the sdev to find out if ALUA
- * is supported.
- */
-static int alua_check_tpgs(struct scsi_device *sdev)
-{
-	int tpgs = TPGS_MODE_NONE;
-
-	/*
-	 * ALUA support for non-disk devices is fraught with
-	 * difficulties, so disable it for now.
-	 */
-	if (sdev->type != TYPE_DISK) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: disable for non-disk devices\n",
-			    ALUA_DH_NAME);
-		return tpgs;
-	}
-
-	tpgs = scsi_device_tpgs(sdev);
-	switch (tpgs) {
-	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: supports implicit and explicit TPGS\n",
-			    ALUA_DH_NAME);
-		break;
-	case TPGS_MODE_EXPLICIT:
-		sdev_printk(KERN_INFO, sdev, "%s: supports explicit TPGS\n",
-			    ALUA_DH_NAME);
-		break;
-	case TPGS_MODE_IMPLICIT:
-		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
-			    ALUA_DH_NAME);
-		break;
-	case TPGS_MODE_NONE:
-		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
-			    ALUA_DH_NAME);
-		break;
-	default:
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: unsupported TPGS setting %d\n",
-			    ALUA_DH_NAME, tpgs);
-		tpgs = TPGS_MODE_NONE;
-		break;
-	}
-
-	return tpgs;
-}
-
 /*
  * alua_check_vpd - Evaluate INQUIRY vpd page 0x83
  * @sdev: device to be checked
@@ -393,27 +257,6 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	return SCSI_DH_OK;
 }
 
-static char print_alua_state(unsigned char state)
-{
-	switch (state) {
-	case SCSI_ACCESS_STATE_OPTIMAL:
-		return 'A';
-	case SCSI_ACCESS_STATE_ACTIVE:
-		return 'N';
-	case SCSI_ACCESS_STATE_STANDBY:
-		return 'S';
-	case SCSI_ACCESS_STATE_UNAVAILABLE:
-		return 'U';
-	case SCSI_ACCESS_STATE_LBA:
-		return 'L';
-	case SCSI_ACCESS_STATE_OFFLINE:
-		return 'O';
-	case SCSI_ACCESS_STATE_TRANSITIONING:
-		return 'T';
-	default:
-		return 'X';
-	}
-}
 
 static void alua_handle_state_transition(struct scsi_device *sdev)
 {
@@ -500,30 +343,6 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-/*
- * alua_tur - Send a TEST UNIT READY
- * @sdev: device to which the TEST UNIT READY command should be send
- *
- * Send a TEST UNIT READY to @sdev to figure out the device state
- * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
- * SCSI_DH_OK if no error occurred, and SCSI_DH_IO otherwise.
- */
-static int alua_tur(struct scsi_device *sdev)
-{
-	struct scsi_sense_hdr sense_hdr;
-	int retval;
-
-	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
-				      ALUA_FAILOVER_RETRIES, &sense_hdr);
-	if ((sense_hdr.sense_key == NOT_READY ||
-	     sense_hdr.sense_key == UNIT_ATTENTION) &&
-	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
-		return SCSI_DH_RETRY;
-	else if (retval)
-		return SCSI_DH_IO;
-	else
-		return SCSI_DH_OK;
-}
 
 /*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
@@ -722,17 +541,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
 	if (group_id_old != pg->group_id || state_old != pg->state ||
 		pref_old != pg->pref || valid_states_old != pg->valid_states)
-		sdev_printk(KERN_INFO, sdev,
-			"%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-			ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
-			pg->pref ? "preferred" : "non-preferred",
-			pg->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
-			pg->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
-			pg->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
-			pg->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
-			pg->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
-			pg->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
-			pg->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+		alua_print_info(sdev, pg->group_id, pg->state, pg->pref,
+						pg->valid_states);
 
 	switch (pg->state) {
 	case SCSI_ACCESS_STATE_TRANSITIONING:
@@ -911,7 +721,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		pg->flags &= ~ALUA_PG_RUN_RTPG;
 		spin_unlock_irqrestore(&pg->lock, flags);
 		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
-			if (alua_tur(sdev) == SCSI_DH_RETRY) {
+			if (alua_tur(sdev) == -EAGAIN) {
 				spin_lock_irqsave(&pg->lock, flags);
 				pg->flags &= ~ALUA_PG_RUNNING;
 				pg->flags |= ALUA_PG_RUN_RTPG;
diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
new file mode 100644
index 0000000000000..2e4102192dcb9
--- /dev/null
+++ b/drivers/scsi/scsi_alua.c
@@ -0,0 +1,204 @@
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
+#define ALUA_FAILOVER_RETRIES		5
+
+/*
+ * alua_check_tpgs - Evaluate TPGS setting
+ * @sdev: device to be checked
+ *
+ * Examine the TPGS setting of the sdev to find out if ALUA
+ * is supported.
+ */
+int alua_check_tpgs(struct scsi_device *sdev)
+{
+	int tpgs = TPGS_MODE_NONE;
+
+	/*
+	 * ALUA support for non-disk devices is fraught with
+	 * difficulties, so disable it for now.
+	 */
+	if (sdev->type != TYPE_DISK) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: disable for non-disk devices\n",
+			    DRV_NAME);
+		return tpgs;
+	}
+
+	tpgs = scsi_device_tpgs(sdev);
+	switch (tpgs) {
+	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: supports implicit and explicit TPGS\n",
+			    DRV_NAME);
+		break;
+	case TPGS_MODE_EXPLICIT:
+		sdev_printk(KERN_INFO, sdev, "%s: supports explicit TPGS\n",
+			    DRV_NAME);
+		break;
+	case TPGS_MODE_IMPLICIT:
+		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
+			    DRV_NAME);
+		break;
+	case TPGS_MODE_NONE:
+		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
+			    DRV_NAME);
+		break;
+	default:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: unsupported TPGS setting %d\n",
+			    DRV_NAME, tpgs);
+		tpgs = TPGS_MODE_NONE;
+		break;
+	}
+
+	return tpgs;
+}
+EXPORT_SYMBOL_GPL(alua_check_tpgs);
+
+/*
+ * alua_tur - Send a TEST UNIT READY
+ * @sdev: device to which the TEST UNIT READY command should be send
+ *
+ * Send a TEST UNIT READY to @sdev to figure out the device state
+ * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
+ * 0 if no error occurred, and SCSI_DH_IO otherwise.
+ */
+int alua_tur(struct scsi_device *sdev)
+{
+	struct scsi_sense_hdr sense_hdr;
+	int retval;
+
+	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
+				      ALUA_FAILOVER_RETRIES, &sense_hdr);
+	if ((sense_hdr.sense_key == NOT_READY ||
+	     sense_hdr.sense_key == UNIT_ATTENTION) &&
+	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
+		return -EAGAIN;
+	else if (retval)
+		return -EIO;
+	else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(alua_tur);
+
+/*
+ * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
+ * @sdev: sdev the command should be sent to
+ */
+int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
+		       int bufflen, struct scsi_sense_hdr *sshdr,
+		       bool alua_rtpg_ext_hdr_unsupp)
+{
+	u8 cdb[MAX_COMMAND_SIZE];
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
+
+	/* Prepare the command. */
+	memset(cdb, 0x0, MAX_COMMAND_SIZE);
+	cdb[0] = MAINTENANCE_IN;
+	if (alua_rtpg_ext_hdr_unsupp)
+		cdb[1] = MI_REPORT_TARGET_PGS;
+	else
+		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
+	put_unaligned_be32(bufflen, &cdb[6]);
+
+	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
+				ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES, &exec_args);
+}
+EXPORT_SYMBOL_GPL(submit_rtpg);
+
+static char print_alua_state(unsigned char state)
+{
+	switch (state) {
+	case SCSI_ACCESS_STATE_OPTIMAL:
+		return 'A';
+	case SCSI_ACCESS_STATE_ACTIVE:
+		return 'N';
+	case SCSI_ACCESS_STATE_STANDBY:
+		return 'S';
+	case SCSI_ACCESS_STATE_UNAVAILABLE:
+		return 'U';
+	case SCSI_ACCESS_STATE_LBA:
+		return 'L';
+	case SCSI_ACCESS_STATE_OFFLINE:
+		return 'O';
+	case SCSI_ACCESS_STATE_TRANSITIONING:
+		return 'T';
+	default:
+		return 'X';
+	}
+}
+
+void alua_print_info(struct scsi_device *sdev, int group_id, int state,
+		int pref, int valid_states)
+{
+	sdev_printk(KERN_INFO, sdev,
+		"alua: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
+		group_id, print_alua_state(state),
+		pref ? "preferred" : "non-preferred",
+		valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
+		valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+		valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
+		valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
+		valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
+		valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
+		valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+}
+EXPORT_SYMBOL_GPL(alua_print_info);
+
+/*
+ * submit_stpg - Issue a SET TARGET PORT GROUP command
+ *
+ * Currently we're only setting the current target port group state
+ * to 'active/optimized' and let the array firmware figure out
+ * the states of the remaining groups.
+ */
+int submit_stpg(struct scsi_device *sdev, int group_id,
+		       struct scsi_sense_hdr *sshdr)
+{
+	u8 cdb[MAX_COMMAND_SIZE];
+	unsigned char stpg_data[8];
+	int stpg_len = 8;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
+
+	/* Prepare the data buffer */
+	memset(stpg_data, 0, stpg_len);
+	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL;
+	put_unaligned_be16(group_id, &stpg_data[6]);
+
+	/* Prepare the command. */
+	memset(cdb, 0x0, MAX_COMMAND_SIZE);
+	cdb[0] = MAINTENANCE_OUT;
+	cdb[1] = MO_SET_TARGET_PGS;
+	put_unaligned_be32(stpg_len, &cdb[6]);
+
+	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
+				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES, &exec_args);
+}
+EXPORT_SYMBOL_GPL(submit_stpg);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_alua");
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
new file mode 100644
index 0000000000000..51b5ed1836c99
--- /dev/null
+++ b/include/scsi/scsi_alua.h
@@ -0,0 +1,50 @@
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
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/unaligned.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
+
+#define TPGS_SUPPORT_NONE		0x00
+#define TPGS_SUPPORT_OPTIMIZED		0x01
+#define TPGS_SUPPORT_NONOPTIMIZED	0x02
+#define TPGS_SUPPORT_STANDBY		0x04
+#define TPGS_SUPPORT_UNAVAILABLE	0x08
+#define TPGS_SUPPORT_LBA_DEPENDENT	0x10
+#define TPGS_SUPPORT_OFFLINE		0x40
+#define TPGS_SUPPORT_TRANSITION		0x80
+#define TPGS_SUPPORT_ALL		0xdf
+
+#define RTPG_FMT_MASK			0x70
+#define RTPG_FMT_EXT_HDR		0x10
+
+#define TPGS_MODE_UNINITIALIZED		 -1
+#define TPGS_MODE_NONE			0x0
+#define TPGS_MODE_IMPLICIT		0x1
+#define TPGS_MODE_EXPLICIT		0x2
+
+#define ALUA_RTPG_SIZE			128
+#define ALUA_FAILOVER_TIMEOUT		60
+
+int alua_check_tpgs(struct scsi_device *sdev);
+int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
+		       int bufflen, struct scsi_sense_hdr *sshdr,
+		       bool alua_rtpg_ext_hdr_unsupp);
+int alua_tur(struct scsi_device *sdev);
+void alua_print_info(struct scsi_device *sdev, int group_id, int state,
+		int pref, int valid_states);
+int submit_stpg(struct scsi_device *sdev, int group_id,
+		       struct scsi_sense_hdr *sshdr);
+#endif // _SCSI_ALUA_H
-- 
2.43.5

