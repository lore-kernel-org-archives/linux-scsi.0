Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3813412B94;
	Wed, 11 Mar 2026 01:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773192845; cv=fail; b=Q0Q1fZG3wrPk1CTqiMd77tTcB3fYtUTuyejZJPkto5LmVWJOvUNwdzg4UiRFt5Fn90mFTxwPbHFgf9q2+wZQHU2O1vVkFK7IduepdauNOCKd3zcjOLAdTbRXKvRGPEWHPtRoWn6V5qw8rU09G2cynVfmRJ9IafBvidpf2b8kyr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773192845; c=relaxed/simple;
	bh=gzH1MSzZDv8x1C0BrWErIdWsVABiDoyEegbvgGLD0gI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=V8NBV35K9T/j6l/OK63YrrOqokh69iKxFGmbhEXsM+yrKFW+xy3Vm+a6OdNSPgOcNkloHeE8CRWfAiD+xjENeZFfdBY1krJgb52rxgO7IRqITqTBlJ4A779sLJclilGPhapKXC3dfK1HMGIyyAo08PhIpiM5mpzdbtvhqM+LBKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N9GtLQP3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AA2clIQJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N9GtLQP3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AA2clIQJ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B0BbPj3216075;
	Wed, 11 Mar 2026 01:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yXZImIz7dQBik+Teuz
	uajz8UH7VZLKEk9i8TLV2q5YU=; b=N9GtLQP38AvxJ9AtCHwt27eofQHQs/uQ+/
	HaofNBnXcfnHFe34vgzG3y8hkm1n+8EVg1lcE9ZLPNO3Kg7vAKQw0o9hxmxpnUU1
	OG9KCO2UEkYESLUqMLkNGLMx/zrTvk5sdPrDmyYVPjAEAGnT+KBL1RJh4U5VoIdR
	IZLg2DfHbj2NskfMS847NqD9R7yFbvnClSopGIlFiK2JYxwesOFVlnGMeEWXlm2q
	IvWIt6KXCskDsffmjxH/+GBk4Tq1NAXrMT0FoFVoPDeJRg1TZfOCde5Twf4UvByO
	nvdeTuYPsHAKWqIrN/gVB1Ux6ZCGKz7JXUF+thQvhZwZuIkSNVmg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csm9cv300-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 01:33:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AN1jR4020420;
	Wed, 11 Mar 2026 01:33:55 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafew9p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 01:33:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMLWB62y03WKpeNJu03LfUn11PaRjA/sNjMGPM8ZrP1S0l16pKc8zu2cXA2jlv+lP+mxm1kzGEVbIBUqhtFBCEilUWF+gXUzH6esY/VVSWyo1sZ1UN0ZrS39Dzj5eBRqZAZ62wq/3019aR8k/oedVf75j/qa6dPYgfdPpbkilnIMFX2laxcD5WhRnYa/LY9+PToPkVcSLyQ19UXFMwWDBc+ZXKe0veHWxuknkJ9HPMmWRisPR8GW+r+aRpzIV2XuFzRUXIzxOzpm5PIXDS2TjV0nRd8BWvCBhyuPsm7L6yvL8yJH2YGI+Q7u4xJQPFj4pCyFbrzqc4H2Xr0dOBLppA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXZImIz7dQBik+Teuzuajz8UH7VZLKEk9i8TLV2q5YU=;
 b=BK0Wf02scxuL8tF8bRr3nMpmIvTquKkmF9KT2FIbZBm1/xyBM2ImjbIcoYn5gWDut+cFgYwiHbN+xazPh6AeUumwaYQlfx35E0IaNzBRLTUi3ZqMyq/TVsHiC40pMNW4vcwIVOknVx7rfiI9LJHbNuafKftg74FR2+v05fML6Bz8Qn6h36ovTZh60tN2iXkQShGm/VA1ZEtb5hXRxT5AkPku2Ei1RRoKksRNXbiD7nZCyb8oWJ+TfTcN8vGvxhjCN5T1wOAEWUcOUsXhdhoLSlouBOzRZu9PYfFddavYyIah/AQuHgB6NeFeT1biEhK20cx+qaTjspNX7ULTrZvzoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXZImIz7dQBik+Teuzuajz8UH7VZLKEk9i8TLV2q5YU=;
 b=AA2clIQJul3ixLhjcmqPc1JbU3QvLrUqoOhQXp5e0n6z0kKj7mt0UzPUd9ot9W4loltLJM9Wj8S8EBrdWeTY+yfLym6j8NYq9b5HIPpkzfHvDQlnZrjUCHxLv5ZJtwbUU0YMd3hQ3jzteKKQ5JzrjLN05uiKwLNkGzLtbZx54nQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6040.namprd10.prod.outlook.com (2603:10b6:8:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Wed, 11 Mar
 2026 01:33:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 01:33:51 +0000
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Martin K Petersen <martin.petersen@oracle.com>,
        James EJ Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Nova Lake
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260309085815.55216-1-adrian.hunter@intel.com> (Adrian Hunter's
	message of "Mon, 9 Mar 2026 10:58:15 +0200")
Organization: Oracle Corporation
Message-ID: <yq1pl5btaix.fsf@ca-mkp.ca.oracle.com>
References: <20260309085815.55216-1-adrian.hunter@intel.com>
Date: Tue, 10 Mar 2026 21:33:49 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0021.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 01292f14-b1df-4d08-0232-08de7f0e4033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/pIMvBCEYcDzn7jKcDIb+x42ZTI4snIktBtSJEui99T/YG9uCkOcS/ilMnCJs6ltd5+9atxBkLJTocfQXivyUPRDJToB97/WSko02r1wNIdWHC2gbda3e6dCRaifYSLzwcgHpGrxHTbNebvFhoc08Dv5xtzNIGgRIcZ6+eGjgvJxBzWJolZO81xS55j0NRdm8bdJHoquQOpAnNpcSXTrRwHTIneNp3XMpAyyj6BNbAzYXBKDfkVKXiBEBiS0qSBYCcCYSBp8Evz4ZstpmsnAUlh8r41esYBEMhi1PlqSAgKuYBJLgRKJvgvtu8WnUN331w50oT54J7WWfXnq0i8fxLJ/OzPuLd9qP3qVpwLxEAucnaRPt7MWgAjD0pK8Mb9kTx/5F1vC1dLfspK7g+shkh3NlNIHq9sgjWhZ+oCMoKHfpkBGjogvEvF5dqrXFQbjyWnbdYU+NKU+J+8w3QhPI1j7leB9oMM1XNStEPrfbB21WFWdrQgHORzzXsk3An5B7KwI7eHX83NspNL2pg2W+HIJX9HUEIJSaV7GfTjs371gZ1d9tAt/Hb4nMm4UBkysGAvcWF2qbuD+KXXpVor0od2REt+oRk2tVY/q2lBQao/63cs0/QzXRegbQS6XP5CzrFLLjssxsIgcyWc1lfPOhvDUJP5QKesavTWYbveQRU1iLsr8zAEtiEyBap3weX3ejvlr2yA1ty/HC1b/4REuS4Zqr6jXUyNNbqR2nQ1uSKI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+0tXVWjZzMLjAOH08fD/mKGPaskorxRymX5TlsG22MrQGjJA6OLoQB9CY81w?=
 =?us-ascii?Q?A5uB4Ft/0ZPJuKAeOaAmCNAPS5H6/v1ajnkuFOySF3PvBNjWGiLKomeQc0nQ?=
 =?us-ascii?Q?H/4lBcEUKwGWILQxmdTBFABKTGCrWi2qD0GFrdh3P0i8UuwmzWEJrn6ZfBhU?=
 =?us-ascii?Q?IF7qEY39q8IEmk9QuKydetgXdwiNXMZ7OoeNv4eBhNuqCk3nOqq60eDliQzO?=
 =?us-ascii?Q?4ujFr+4DazpeGrqD+3oMhGRQUy582eRHLTLL/XmeB6uz8W+eyEkbemYab9jU?=
 =?us-ascii?Q?wwEG5HiPYWWXu/KNHv77Z1HqvsGeYlolqrd8g9a5/E3kf4/Xy2WHtR41wcC3?=
 =?us-ascii?Q?X6og3Q6bnJbjOadXmxPMqTYePEMnmIRXbcejowNZ1POBQvJX0eQVW4toMvGc?=
 =?us-ascii?Q?jVQhhvX0whDuHqJIZwHK0DMusEQ/UuRx2jjxDLXAnSogCT6+PPsOxVu0RPzK?=
 =?us-ascii?Q?DYMKdvWACaRh8o/Jg6JGZObYzLkgJ7fCBMxovV4o9aqO1zE8xerHdnR3AGFG?=
 =?us-ascii?Q?KLyu7PceyTpGqLYHXrKQplN/3LwCnncn8ZiERjaEpD81eevVOkKpn05cVitY?=
 =?us-ascii?Q?fndffY+FlZ27yAcwbKXrXrRpAuqhZNGi8RScxhp0hFBu71lNyfbnSPSruVZ3?=
 =?us-ascii?Q?xdIUeWdY4mFdPrRMD76DfNqKiyS4dEdzSk15bRAZAMNmC+qlgClQSCqi8WPI?=
 =?us-ascii?Q?tpCvRoJdGxRZlpdsv1+PjRDKHQL2s35Q4vlQuIYbaANBl9sjF1zGyxUbf0Zx?=
 =?us-ascii?Q?9SzSAjNSXrMu6yjLHqOjA+Eu2QE9MlMfX1ltN241zjDIwK33zut6y8Q+arzp?=
 =?us-ascii?Q?8/YpCk/z7/+ZMiaR7XwnbdcQa0lIST6TLRm78bomxxcJMxRP5ZGFWj5WHXOy?=
 =?us-ascii?Q?G/+1byf2CyeRWOQPIaAT6hOatFr67ttmo0wNwcR0jJb8MAjwYkM7zqH5onty?=
 =?us-ascii?Q?VSrB85jwYjQdYcyP9wsAt7wWXIJVL0oheoWl7AeAaBA8zpY6Z0cLB0xR4TvD?=
 =?us-ascii?Q?Q06Bz2B1bCSX98D5gQcPNQahQE3ea7qdS5wrZONvL35mnoLplI9AHEcFY6Go?=
 =?us-ascii?Q?HN4UNclbBmhGyCAb16yBMiX9z0YwetM72oFq6+iW0gXf5IVFbENQs+roosKz?=
 =?us-ascii?Q?qD6v6W5uOxUYIIzn39tJgi3SZNfcf2j8d0u18qtXVjF5Gh0CpD2qKpTRfQxu?=
 =?us-ascii?Q?kRgFp2XxsuhGJmTN8dDR2jW54+N+awtA+up2z5MZ0yu+HKByAR5pRs6F7hsq?=
 =?us-ascii?Q?Jl8RNOP69Mb0Q+uJzHpqcnC+RUz2Mq+HJlXMjwfz5up7CvCnL8ZgzBQIJKSJ?=
 =?us-ascii?Q?72r2yoyK4hx4EPGfQq4JrScsEWbFPPm34dpCZb2vjTX7LNpGQa3euNKK/4vh?=
 =?us-ascii?Q?oQeG1guW6+FzlJOe4w25wEvhL5dPveC9t14xIoD1ee1NgoMw2vz4ai6sDQ/Y?=
 =?us-ascii?Q?DxMtxOe63O2+najq52tR9n5rbsedEyiJp2d3Mpy4fXNacBkruhWd9Us8VoLT?=
 =?us-ascii?Q?IUZAQqFyZJ2fpn3oFUc/OLCKYyndP93hctqJ+asa2rF9eVq9+Aa2JPc2PSaE?=
 =?us-ascii?Q?A4TxNfsn+kTJNVV6N5+lCRE/SH4eT4BZomFSeE0sShESa1LHwBet2c7Y12DY?=
 =?us-ascii?Q?8+sUGbvRzpazKhCZqUNS3F5m5Qg0vyjFs8ytafFVVp8tTbVlAwk+Mr4Zvf5s?=
 =?us-ascii?Q?tTb4s199TD7n6K+k56jdc/5QUvt9G0DMDqUQShhlkrkDC0qec6XbGL1bV6pq?=
 =?us-ascii?Q?pVRhhYWnJlJh7s4tkSFwjipRgZX4K+4=3D?=
X-Exchange-RoutingPolicyChecked:
	JRsxZtgZ+XCr+VJDvylDx/8z86Y6/bblysWkz7xV7Mal8+YYaqakKZ1qZSJfYS6uVXwyH0nc3TgWNCGNSmQQ7jmEohcf/8b8WjZj++iccve03FtoPMyyAqlhjOsy/sBQpMKv5PHN7WWduM7hZu7tBqoKWzzhp+ZMRG04zMzqCpdY+CZE528EcsouRJYq2OJU4xs8u9Lbw1Vky+nxOcZ5dUrjCOWCzdrUoNNm+ZjYoEkg8ZwWrAf1MWa5lW5+HyCDJtNM2ejY50hKluynjlxckXq/zKjlwNIK/honZkS2FWW74jmECmDhxOLuxCl9JZKC3WB9wznwvw/6+cTWYrUoYw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nqT7PQ+pviBuaj27iZKG2Bm8XSNW8i1OKaSPFgVxj1czHk+sXiVJIohCiWxHY+m1Wp1vFhuNZYXSVUoFi7vrYVrIVVOx9r35QpUNtmWObBMwOuDxNGsn55qMFIDLJa98ADPr1AvVzGeRXit3sabbo43u+G/9T/WWmYFgeMb5N221thISBcgb9WousYyaL0s/SWsYpRWVA+KW3RJFzabD3GXpMwAwB4+DV/Gg3RcXGwAwzWrv1q5kkwodMptM8Rasd96OXNy9LfiH95yOUaAXZ1oBV7OINn0l49dEKGgidEUNGQmnlB7JMxYqk5dMZAw2HiMAxtOqaDTjPACUvBrUpDg3sJyhENc3+LervbkVuXWaC/8do4+JhtsnIlQ8dG04zoy5s6O7xv7Wr3jwBD4Lf7b3be3WXAy4EkA9v8jy6vvO7Hdd6q6wDGqH/JvtLtp6cvfJCPIScinMQ5JkPK4MukE3Rwp4cbyNx2zyv9jFJ1diX0++SE1ye/xKZvy/3DimYX8LglSD5kI6xWKleUKuBDvDYb0PF6u67O8bMaJwjtxKu/oXSPj+6UhstpDf5u9tVtQOBFn6DSf+Zs4Tu8tdmNV3ZE/8gal0MFDriKbkmBQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01292f14-b1df-4d08-0232-08de7f0e4033
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 01:33:51.7842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dT/oMf/M+OacZHOJxls/rw2wUe7Awx+Rw3aLNVbzS2FaVYfZDqesMJ7Feua/He9zqQ6FPMwhkJxbeURVQqGaCxjVysF3MLqpMCBJnv9RkOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110011
X-Proofpoint-ORIG-GUID: _lsWiOoNLM6CsjS2sQ6QD4dwDIzjNvqd
X-Proofpoint-GUID: _lsWiOoNLM6CsjS2sQ6QD4dwDIzjNvqd
X-Authority-Analysis: v=2.4 cv=LeYxKzfi c=1 sm=1 tr=0 ts=69b0c683 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=0lH1nP1UEO0-QL0kn-MA:9 cc=ntf awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxMSBTYWx0ZWRfX/pbUJAJNzYes
 E4ifzCL/5E0aafqx8HdkQHIQw80IyUSNX10C7cunD8UcA6vYSehdUJTx9S1SWkyd/ISSFETHTa+
 juMCv+S60GOjEkXFCRPj/h0A1EeYrX6iwssBFhYi5HT7uYwx6ZwWlD7r1sPOZ9YZ66wEm4Rj1RB
 RXGBT2hS4A6rIz5rpShix+NceYbEoceludhVtFtX8M9zjy+1tbej5oCk6yvJKL5Crg5Qgr09+C3
 SnVc5QsRZBuXhr5eqPAw2d/C3Da0OSNSP/WG+zKuKY2Yo6iRnkmk+hPCb6/GXdJ2n6+ayrp/JiC
 iR4HzWhK0Rge5MTEkHlG+NSvETz5KCJBSURtSONgEV5ebpBIA5yYRF38LIxZVV8P7ueTgkT6igs
 NGsN94836aduO35kLtf3nz8WaTlwrU2MjBXpJ4awW0IE3wYMBe+WOzkHSXu6gCNmGpiODP1YlfO
 DAyhCs6whcsDlE9nyDLYsbV9NBjcuEv8Y4dscF1Q=


Adrian,

> Add PCI ID to support Intel Nova Lake, same as Intel Meteor Lake (MTL).

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
