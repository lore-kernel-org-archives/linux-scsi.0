Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C88536999F;
	Tue, 10 Mar 2026 11:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143466; cv=fail; b=FQDivv/GgksbSrstwLw36ZKovE055xEOnFvbIbwnkFagnxJbwNmEUzNUzQBDa/Y31gzLFhMqpYz9Sm7CsMLFv5CMi+F97GK8uK7s/a6dtrR3TlYr6OM+QXuEvxP0uC7IaRUp8Yojg9F4bygOVfF946wkJgQJdbRJRse4CmAOah0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143466; c=relaxed/simple;
	bh=5OhBhQOWOYNmW9V4ReemE8Gr+vBN376ZuK3d9eNQ1Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XCMnYN0dIxxZ+AORkNrTxZtGcVGhp8ptHcTYd6vRgxaXg9HGW4czSiO83fucKlY35HkAsmxCzO0ob3MOT03squLZuQ/pwNyG9V+Ij74GK72eGqlHuHkQ4+hzVLWorGqzXvn+34k5t0QzkVDI8WjL8yA69X4ulOzsN0H2+iIVZCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TvCTpSvZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tZGjSvB7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TvCTpSvZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tZGjSvB7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9UpR72581505;
	Tue, 10 Mar 2026 11:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=xbC978/rk9NjXFHJ
	MBYIOv4TDsY6xVWdWO6Tw4YcE6M=; b=TvCTpSvZ4J+Pl6CGpOXqACdfRYtVJMQu
	llZm8RPWBQSPAH6EI0/diqqdeceynbImuw9JkaG30/vuDEoAy2BOta4oy17y9ALg
	vjfxYvocVUdduiynvffgDPsIZdePM5HB0x1x1f6wV3fYdYX7msLIrRjO02aNil3g
	OPE5W5rW2EPVVm8j5oDRW8yNgL8z4t/oT/uqMj9mw6wHC8sYhATC0ZaDDBI7eQw8
	xSTC3wrflMqO8pRl3CSNVoEowyrQ+pi9EtlRZ5ZeuG23bF7A27+6Jt4I1/w4I3O9
	jNmyGG1/lVcxO3nBKhWlDyP7EKJC1F8hriPp9UEv4aYWrIl6qMpNRA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csm9ctpf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AAxAXv014780;
	Tue, 10 Mar 2026 11:49:43 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafe84yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wpw68K5PPqeRZMcBwILqsnoaOUiQTlwMUP9h+yJUgo1RmO1sVipYXzWM5nX+22Fp5kXQm5mpKGDyrcx16kQwb+cs8V/BypG3EmuJIkVXyTD798FMZjkxSSp/AnFUIcazEJmVq/VF1VE3+zjS0gAVuihd1xF3TLxGI25J8OpFM1rnb8G9dGEbMOw01Jvvz+qmuJ8oiYC9b8+JKVELF8iOvSJ0UTfbURHO2+hQbNzaunjFdAiRJUZ8o7veC0r4qHA2sIaMtUC7QhM2Bp3+61U8fGG4cRvXP1xBSRkO0zIH8vqnHTbihT2LB9LnU+3svMhU6RhszjPSVrDrqzIWEWPE8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbC978/rk9NjXFHJMBYIOv4TDsY6xVWdWO6Tw4YcE6M=;
 b=Nu+9jpOjEYaW8f/HZ4i49KJgnimZ38TaICZ96qXbeeNRWz3GfjcOd+ArZn1WDe3ad21I7a5raSTbEiUiSOBDM/vCfSwWFfC/EA+nPZGMqYank1xcoM7Q8CNaEbx5hYq7EHk3oYhUeNxd0suRev8caOleE4zBhQOdys7GvMI3rzFXfmVDxqlQwgGYkfDVZd30o+s2LGCMoxZM22Ace9+Or4HOm4oSXG7gqyYneEberzgoTgZCj6wowEEbPD5UVGwTFTm+7k1mahyM0oAmqL1NXY61X7d7iI45NHGDcEaNUQgJx7NZO7DWZQgVW9/qEjPvI8m1Gx38i5Mozt9orj2ulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbC978/rk9NjXFHJMBYIOv4TDsY6xVWdWO6Tw4YcE6M=;
 b=tZGjSvB7WzZ14+LRs5fvXwH4YC1stXExmVAIToGktImSUqYkhzfXC447TpBcXolnHjBwYLtfHRKXBxvRpbQA8th5Rs0R8oMxhzM0I2mQHHz71Vy83ijjFASH1hD/TsIqdBgEuQ04fFD7S8im0JpvG2CzOXl/CCu079XOrj1anHQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4519.namprd10.prod.outlook.com
 (2603:10b6:510:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:49:40 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/8] scsi-multipath: Basic ALUA support
Date: Tue, 10 Mar 2026 11:49:17 +0000
Message-ID: <20260310114925.1222263-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: 09a5c24f-bb86-40c7-da98-08de7e9b1cd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	4EmIaVWAtL4WQgDD1mOHNWKHR7YTvbtiIR2G1bB3W52NUzifr532XI8UYO1FMNXscK2RR1QIB+abu28XTPcN+UAWOurmk8MfMV+PeBeUWXFljz8Nj1iK1KfO/thjT/bdX1M6edB9E87L+iwkB7WFEywFff9G8wkjD30b9BeOWo9VDfzUkwhgbpCSkFkVSmnhYZt5vna9JSwFL1D7/DjCgX+pkX57Hkny1heKyfnJL7pgLdOwEAhzd15iErSDOHMMk5StCdN9igxAfWu+Yj4ibyQPxlMzWjms3L0qw7uEuhHmHu238g2yKwrKOfEhCx+w0mtIXE1wPbWvlvrOZi0yh2W80ATLEnkd16qyIFIg7vJHBmCF9s/iNWlTtnLsnug8db1PcNj96V8CgZtN0WAc7ABeQ4V3O0kEZGy7MybH8adBVwEdz7/Z2A079/c/7eLKqMwE5wKLA5ZPJlkmaSMEqKaj49pNnAfzO0VSh1cqPULpn7BhwHkVcptxPSgM1+NauSIHwY3LeFG3U0exlES6ivmwnOXtz+A47mNeIpU4Vip1Ob0Va4O14B8AKSd0aaKLmeeMTlNOcQyGALL4qDIuacMlA+wsusY50C9G7aScHo+hHbspN/V4fW4Vjl1bEQbAByMdH8wuClrUAnVS9eZc0eXVVK0TCauR35cvym3Kc2kvXOfArfQou4Fd9DPG7YNL59foKuFJRPy8ZsySPcBVnQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k+PoIX8csJGZ4nI1vC4h05QZBrIkgRhxePTmYxPraza2eW//OfZinKKFUqMs?=
 =?us-ascii?Q?qiwTGkGojWE/PONFbMTrq3eRQZ4UGAwj/tlkWnJ4ATEXStnujIW8Nmnx2Xc9?=
 =?us-ascii?Q?jfgWtdyan0rEcb5oh733NU1rl7gCIjZpGLB4iHr9CBzjxH0n49cJuDFgMrMC?=
 =?us-ascii?Q?6ajdoyI9Ncx6ZNJMSpWrp0goEY2MgC5VTiasGu1tdBZgGNDVLNpEhheogVww?=
 =?us-ascii?Q?Jm6po5DeSuMsHKeZPPDrj9+r1b86yRQfbXoTI6MlJibPPZJ42VWILSTyvJ/j?=
 =?us-ascii?Q?i9BVrxEueMspvuxZdFnyUVzGf54okheYRcGw66EH0PMui/2cZzIm6Nkailfs?=
 =?us-ascii?Q?rXF3vq74STVwoVOjW+MCMRD4Ittl4cSMeufG3KIOH8elxnYl0hrVrKmpjD7m?=
 =?us-ascii?Q?nvv2ZsfF/AjN/XeU6TOLCSxFGVBwTV0NEyOfuxMXr8hUNN98posR6rMBfoj5?=
 =?us-ascii?Q?l4dvE/dVHyQivRWvo11Uu0QWgKMtzVoY2cUCQBz5FbhzocfaIPt/3I3mx2Dw?=
 =?us-ascii?Q?F13AfPK08oowOpFPJ/zJI7k7DNyA2uSTgPwFMo51HWk4pG1mIHO85tJ3oAeC?=
 =?us-ascii?Q?3ttXMLNrAIBtMsymA8TxWTT/yvAWXmpjDjgkwoEQ7I/3nxaygSWF7sI2enl+?=
 =?us-ascii?Q?K7XjlFLyx7vnG6WpXtinNOyfCW2d9TQN5IGZQibAs2Lt+RngXWTREj/nlcES?=
 =?us-ascii?Q?ELEMljqJ6VQgiI/mrmPcsXHrJVWdkSAViSoYmpf2NkeYxFbLjQJ/pbeyR+M4?=
 =?us-ascii?Q?x0mdASnwQ+2nJOMwXmQVhAo5edUp4KonY9VKbykEBDKfkJkRzqB2GzNp8S/D?=
 =?us-ascii?Q?yaetnUUYdmDPsS41Y8/O6z2dm2M0L9OgRIfuFcOq3Q8FzzRH1T/YeGdIw4J9?=
 =?us-ascii?Q?QKOm4o/3kblWSNL+aWRCMph0clAv6cfeMPyKbliJ+5TWHVq2M6Dtduio3fIP?=
 =?us-ascii?Q?cHinmiN5X6UPJxZ3pmoXciQFRj2tFn4Q07WztwwXTgQydVf8NRcX3+/x/phT?=
 =?us-ascii?Q?HPx45Oq8zMtMRYSyMcfd5bONK7KDiK7mNi/QYyQH+BBJi5HdqM4osehQqUBJ?=
 =?us-ascii?Q?7L3KBniGtsOGN8Yd1/cuQeOaB4I5uj6xUnopKGYy4OsFRUZBJik4mg/v+Dqf?=
 =?us-ascii?Q?eXTbBikqrag1Mgh2yUZ3B5GDh0CfOn60h8nwq2UwsOFp3ks70f1CegoRiX3A?=
 =?us-ascii?Q?4M+F3q1vOPb1DkbM1kZ4clIXXiFu00GyHgmXtsyu5aSeyFzb7X5VvNqjcyDp?=
 =?us-ascii?Q?Zj6frW5b/evpTkurvu5ZU95UajLZizWSczrZ9fhx6CQQVRV+2Oo0l7plJkar?=
 =?us-ascii?Q?7UV61s4RbUxdvDtDZs28yHz701R6nlmZkovNnbtDzFdFL/W5DnGj4p+nCNQD?=
 =?us-ascii?Q?Q2AHW7kwZHROENowU7DmLIbJ5GOZH6mtFdPTGAlTx+nPufLF45iXptVbAJqU?=
 =?us-ascii?Q?WJNm+kK081FtvKXpJjCbuWuPSbYg/qiEYcy03sxSkDpBIaCM7Jp9jMqpwiFL?=
 =?us-ascii?Q?5eq21dsjpae9VLmI10WthnJvAzM4jpFY4ZPtcUfu1H5YnMlrMyl1QYF0HKpS?=
 =?us-ascii?Q?HiLPNBaTm16vtrXrgmPpE4PZElzWBC1vcWXF6Pefyif1AKgyySB8BHzlQyso?=
 =?us-ascii?Q?+C0eU/Kgnb7j00AD0KqiVB2V0ZPdc5kk/OOlReaAaM+dgUpiDW5nkKtH7/Gl?=
 =?us-ascii?Q?cUayz/K5yggeU14hpZbrZHG39i6O6qg0czTNZdLIYojSICfsih+OH/7mpe7L?=
 =?us-ascii?Q?RcX7kukuK7DWBtUv14Et8VmtX6vpcos=3D?=
X-Exchange-RoutingPolicyChecked:
	F9n21zqs9iuTqZ7BKs4Rk9LJQCkWRZWww9bXVvlzMXk4v5sMSDt/ANCOqmAAuReIUiV4rLf7Psd+CpXbvHwMrhv7FP+rudP/JsbTXBEDbt3v+eKQdRxrJEW/qVrHEnuMqrGuSeXcWY316/7yMiwOVCBbkSlhfoXJKbCiB5hzLmqJnQJLKxjcDB5M9copJI5M3TtZnUyLRboR0p4O3w7Ji92JjTFHLZ2ZvYNZxxwr2OQce4heMkAgb+ZIMcmAd3/Z9kJ1P0jWkBYbCPL1sME5n7ajbu4ArBvBOBSnkrA3rvI/1L+xAj37JedXz38eKeVH13x5ZP+qWhilyglPCAw2OA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FuTLHeCvM6u8z/KMTBXSGZ2zuSKr1VV6g+4x3pjpssiJLSs6W6z4oTDn3QkkYLi8jxN74bcMuOUY+rJEZ/dR9H/Uc8LmCBKKAl8e8bBiYQPU+8ChWvwrh4FQ/ZL8BZxpfDB7u/N7Yrasf5CS6UvW/FgAmCX7XuKa3l6QHvw9wTaIkaxLurjEn9kyBF0EvCBXhRcz1DoloetHAuH56gDpfp3Ez8OnILqfwRbf/09r6kivmHMIWucxkamphZP7choAvEMDjhl4kgYUBU5rkKlN6JvZk3Q2fOHWbmXph3DNkW5GuDzqJ1h5oNU7pTHQ8oY80m5Gl1EMKzjEae+rMBQ1kqtv9kxYO5uk12tvpCUfgZWlBcvf9SqXFtN3GJJrH5lf/5v6uB8l2RUMY3xwjBd+n1DB+x3BYgsPjd05wEMFU65k/r4BZeIOapU/GaLnLxQArp6TBwpOHGQ5SoP//q3mnIGoyJfAKUk3CR7ZBf8nfz4Yi+eGFHf7xdsWxUBgxKIwFQ+ajajbzYQqoT+U6Apbgf4sgUdluJMph1PHXd1+cbDiMATjbL7XdBVT4XTxIYNczamUoz5eo2+LZrvpKXk/zqPb5EBuh+xBvveYHjE0uT4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a5c24f-bb86-40c7-da98-08de7e9b1cd1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:40.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6SfQXy/tOPOid89W3ncX2nJZdDvgYYbq+NysTfo8Q9DmpDrPT4irRNtCqTZmetbPckSvHkW9lb+lqzT5+/Eocg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Proofpoint-ORIG-GUID: 27EBHVqemtOei4kogwGS7Lk3mDpCVoE_
X-Proofpoint-GUID: 27EBHVqemtOei4kogwGS7Lk3mDpCVoE_
X-Authority-Analysis: v=2.4 cv=LeYxKzfi c=1 sm=1 tr=0 ts=69b00558 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=6a5dLSlsXxERf5ysNLkA:9 cc=ntf awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfX+NKfqbviXcr0
 VYhKc/ux8GnS5wJXqqcDjd3uZeP6ZS3kwQu8TxrtgY4+j1TcyF8ji0+tJTsVI8NqgNBm3ZK4iQf
 csEOd18SZKlSVQ4oNc/sXX3H0eMZ/PdyIb6oqm25aMj4oRFlL1v0lgYF9SLMHL0y7iR4MlvgLGH
 KBS5PelGerjgG20PLlgpuWJn+urQHcHHpmPXN4vxCeobcOS6rZCct4jWggHfvEGdCr7pgEwlAez
 /xsbgx1S5sajkI+8aSTPv+I0aN1AIEgzvjFKCv9x8+XWqetJHEp3KlsZb2K++bl4IrxqtIxugWa
 vaM7xFgt6njNAFJuwNvx9CSB3onh50Zkgg+k5MBr/OhHYH0lnMq0Oedi4Jek3fRSEo7CRuAxa0U
 YOYNOywwLQiPO4iPG03gM9jgfdFg86WWnzsje3XI+U+S48PIhEqvNlgNHKJ7ldW84CLBbiOmQA6
 WorNuTbdz9QT4s8bfiKTpAGbzeJ8ovBsOK7GkyAc=

This series adds basic ALUA support for native SCSI multipath. Only
support to send a one-time RTPG is added to get per-path information.

I want to add more ALUA support, for things like ALUA configuration from
device rescan. The DH-based ALUA code already supports this. However
separating the DH ALUA port group management code from the rest of the
DH code is difficult, so I am looking for suggestions on this. There is
a consensus to not reuse the device handler code, but it is intertwined
with the ALUA driver code in scsi_dh_alua.c

An initial framework is also added to send a periodic TUR per path, to
keep path information up-to-date.

This series is based on https://lore.kernel.org/linux-scsi/20260225153627.1032500-1-john.g.garry@oracle.com/T/#m76b3a2756124e13b5564c434a38f9c51f64f0bbc
and may be found at https://github.com/johnpgarry/linux/tree/scsi-multipath-pre-7.0-upstream-alua

John Garry (8):
  libmultipath: add mpath_call_for_all_devices()
  scsi: scsi_dh_alua: Do not attach for SCSI native multipath
  scsi: scsi_dh_alua: Pass submit_rtpg() a bool for extended header
    support
  scsi: Create a core ALUA driver
  scsi: scsi-multipath: Add basic ALUA support
  scsi: scsi-multipath: Maintain sdev->access_state
  scsi: scsi-multipath: Issue a periodic TUR per path
  scsi: scsi-multipath: Add stubbed scsi_multipath_dev_rescan()

 drivers/scsi/Kconfig                       |   9 +
 drivers/scsi/Makefile                      |   1 +
 drivers/scsi/device_handler/Kconfig        |   1 +
 drivers/scsi/device_handler/scsi_dh_alua.c | 202 +-------------------
 drivers/scsi/scsi_alua.c                   | 204 ++++++++++++++++++++
 drivers/scsi/scsi_multipath.c              | 206 ++++++++++++++++++++-
 drivers/scsi/scsi_scan.c                   |   2 +
 drivers/scsi/scsi_sysfs.c                  |   2 +-
 include/linux/multipath.h                  |   2 +
 include/scsi/scsi_alua.h                   |  50 +++++
 include/scsi/scsi_multipath.h              |   8 +
 lib/multipath.c                            |  15 ++
 12 files changed, 501 insertions(+), 201 deletions(-)
 create mode 100644 drivers/scsi/scsi_alua.c
 create mode 100644 include/scsi/scsi_alua.h

-- 
2.43.5

