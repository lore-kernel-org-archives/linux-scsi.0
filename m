Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38333F99C2;
	Thu, 19 Mar 2026 20:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773953066; cv=fail; b=alzyqAN8qrLyBSI2CzURqfiRheiiUS1lP6C47gxWtW9ho/zUeOmq5kZK9xeFGRGkDzgXtNztL+gSo/I2Rf40wlXcGApoi5zDKkMySgJljcCyTzCwKBsCS3oFJg4vUBf3RexawjuMI7Z2GUSsLzcAIAUjsjQtfwm6+v74Tlt+k8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773953066; c=relaxed/simple;
	bh=UacjnLXBD4YggbohgikdC1mVh6cRQVLnsFxZKeXgVBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RXReUN9nGAq0dUYrSIjz3hkTHQivbSOmQN/IeDQPUxFpGBv60aXlKsZ3XIFMlZxejxPG135G7JGfKVxTwUrp9lPEY25yf/a8+Z+ql7rZHmXK/HW3UoeXdA3ICAQNe0eCoedkGN9q4gi0NPWL05AdzSCSXEQo048TxhG5tgVSASY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=kwZ7g1Yx; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="kwZ7g1Yx"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62J4u6242303745;
	Thu, 19 Mar 2026 13:43:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=mr30Fl9J21TR5WLlBT95cetN29/VA1yZm/yvaX1rHBE=; b=
	kwZ7g1YxXI+u04cDE+96ToTVT17paTQlFpqWXyiWyHW8S65V9Ycr9MT0Jifizkx6
	4FYojoFNzOPnT2oKzCDYE0TXc6W/u/elg9du6bCGN8H+D3ynCDV/jCGMoRTUhfqO
	7FnCYVB3IYi4SfcZop5YaitkjgVUK5K+fRYOJnPdEHYpJPkbdl2xDvP2KMlPlMhd
	e+iy1xOGL9g3Wjk+N1pWDVyDXVYqeuy+agRb83eTHwLVkooDGj6SsDFjyaXelW3i
	n1PERDY6aUvga4RBwLdu+H5Rk8GSHcHSqPlg/nZHKIi+8Ncr9yRttU14di5Y7Cch
	pkLWWDjS2LOQCaE5qSddzQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cw76dxuqt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Mar 2026 13:43:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=netJO4FowdJqROVLvdNnKElc8pNQKqGsLtuKwBHcB9ewjOA0PEaN4ilUSpfmZ/SRPaCGERmkh20h3mgjK4xnLZgU+0uJfB+mk+RF9H9V4/Iismw0kTaXTcp2G4225BKonqr3H9hZhKaaMS4p4KNw9wgxqOwj+id8MCmeJI1YtH79SKzkLYDabIGDiZ9vJlCMpW7LK42GdOqeyYjHGlqkynV7Y5eTrnrN3UwZQt9I0l4HryFSFoIfFF58fCIx7JYdqqI6kDRdoQYUidwMkV1H+boR/1xLdhT6tRqoH9ck5Eu0shCvQBOyT/P/6EiGRQ720H3SyiNcpeD8NWQKI4yNoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mr30Fl9J21TR5WLlBT95cetN29/VA1yZm/yvaX1rHBE=;
 b=h+XMf9u2H83BE261U5PWIb4bXcEQX7H5wS3mXgijTEMk1XLuFx/kyW3YVmkxAPvNDVzSmWZOOAuhLhMxEr1IBbAuY6aB+csPNmUZsAGkDESEfOhAi//ejapy4YnAPTpDRwbMc2jc7LQXHUuDLoQ1T2JX/DYM8b+si3x96F3z4pQIKIg8OynicAch3x16lxKQ9YQaUhGD4r7iZQwq7CyjdN12FljT4vO23jJJUb/ScqY3sqhBflEX+8Y06h4QpPCzN/iMKiLzC+/9ZRccd4/0h5u4UkYvgztxaAVFfvyMkjdKae3SordrBm7j/ATO9XwSOoPSVN7qZh5miuy2JXtI2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by MW4PR11MB5871.namprd11.prod.outlook.com (2603:10b6:303:188::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 20:43:47 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 20:43:47 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: dlemoal@kernel.org
Cc: James.Bottomley@HansenPartnership.com, ahuang12@lenovo.com,
        axboe@kernel.dk, hch@lst.de, ionut.nechita@windriver.com,
        ionut_n2001@yahoo.com, john.g.garry@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        m.szyprowski@samsung.com, martin.petersen@oracle.com,
        robin.murphy@arm.com, sunlightlinux@gmail.com
Subject: Re: [PATCH v4] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Thu, 19 Mar 2026 22:43:33 +0200
Message-ID: <20260319204333.17432-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6a78fcaa-7a3e-423f-b6f5-84cd66a3c88f@kernel.org>
References: <6a78fcaa-7a3e-423f-b6f5-84cd66a3c88f@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0105.eurprd04.prod.outlook.com
 (2603:10a6:803:64::40) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|MW4PR11MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: da7e56b7-cb51-410d-ae8d-08de85f837f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|52116014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0pjocZ3b0DdYo7T7Uo3YH/VHVNKy85WZnFEdhmghPBwYYlucb+MmqsNPoq9WM/t3jU3/b0AzMbgxmQdYjnx0Rt35KlEz01xOpSOsAOairT+n5+e9SoRUs+8mSpn3I0ylb+gyan7IXM1xnP0Ok8S4/BoTnAwB+cA2h7ETVs9sEPt2IpnGMqbGQa3Lt1/9j9Dx16NH/6FiOt3nE1P6633eNRuEJoXSfoUmV29/fmRB3AviaVOWEUgTTq7W9zldM5PlbJq9nv9KbbNEsdJcWZfrtmQzqkjVwvrSWBmzdRmlVCN7+qPhNlV3iG1dOYE7rqljJz1uKCOkVsQP+hjHFS9zJF0b58so62tFJ2ltNqw0GWKG6ahEL3dlXum0nhXqDdPvdnMfRF3bRbX6YYVZ2ztLThsHxvmI/BA43TFgFneslLOVd+GzzTFc0R86MhD+GZEWG8/BfTATWIPEETRA5ZhrFb/JUoJjZRqGtr7gwUJ03D2ykMyEWOXE0Dfv64ILc8I5qhU58OjIw2zMmteu68Q+xqhs8k5TXl9bmP/irIMIex8AOUFcPeWi5ZfsrKvcYkt9AsmNe+tq2xpV9v8V9EHTWJZbNi4C4kSIc0iBVChJURncuSzhs4zLPRTBsN/FoqDQu+E6ii8fi357J0GmaKl651soHOtubNMOLu0+j5ntG3LkmmRz0cJZddXY49zKsGLa7snZPVlsZ6vnvHg43qk5wJVUGIfOLn7DZLXDvpFpzfE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(52116014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2TsNEl2PNm9Sk4wabsNjV9OK8zty7s8XzuhYnnR9hs+qU6IIiHQEiAe3zWjn?=
 =?us-ascii?Q?a1xDCOUZdQMjhUj01Tg5hmRl8PgVakhnqZk9BPHPDNQvkZ2GYgG1FNmXuioA?=
 =?us-ascii?Q?7BFKn+Qwh+b3JOTlhxWrE96Nip+JEr65epNL98XybL3acLJCxGU7/OogJECs?=
 =?us-ascii?Q?ymwNSzsa4yhJ4js5EVef7nTuI/2o+7EcZN/HSdNnwBwt/p8lEY203MhOTM7K?=
 =?us-ascii?Q?fNHFD/zsv+B7O18fEUmZQ50gQILFm28yTJSwkJjUnJXaPczDBud6Vv3r9mjD?=
 =?us-ascii?Q?VCS2KIIKYher+oci80izsfxHHxDEnKFCJBLmB1QlU/w5ixnXpRrJNHiw6daj?=
 =?us-ascii?Q?WnctWKOEnt4ejl3U6Fun09l/LZVsXpUkc61uRJ8Q0L3eUvagjvWzJP4/vScK?=
 =?us-ascii?Q?M4lst8Y6N1R9X+v6a9LQ3kaNMcArBABDQfHyyjNuBRwMvx+HbINHAiYXKKzp?=
 =?us-ascii?Q?wnCfs7v5NxvC3/2ZawsdtE9/FyKMl9ngeBrB3im4OeO+EK0kV9UApGGojxCx?=
 =?us-ascii?Q?+qJyzhx0ZjjbpYK0IQGfnLVfUzLpdKZFqPIeW/1p1B0I+5i+BSRMZyXZnhMV?=
 =?us-ascii?Q?d+a0SyNgO7E7cBp29zshdktAIm+huOGMfknTkSEW3aNXT7LZXqgDuYW3sjF+?=
 =?us-ascii?Q?lPBGBtk6UGoZf9QBmJm9GJqd4bEJjGG9l41yuo/j1SnTb6sFSs6leFxFwytu?=
 =?us-ascii?Q?QdN4sWinG3TfIDq/XK6ogNSXMDoG1try1bIprxVc/ujTEh0QUi9i6BfUfyYm?=
 =?us-ascii?Q?FZ6J7tWq//r5He7xMTBNdgqkYGAnb/B8wxmu4GTtPzRJesQdARLtwMi9cUFI?=
 =?us-ascii?Q?BtBtPh+PKvitj0tk4gahmdKydcehRyt6B6/EX4bROcwQB4YInw8punuNORVt?=
 =?us-ascii?Q?zF3B0yl0bPZJWb9vBvUh9j2DZtAqQVOeEjCFk9x7OkW5f13GNBpFjtrU1gaL?=
 =?us-ascii?Q?5KRJ7WEcffaMkbzHPg+MEwBo3RsP51YIbCSIwFX0JzOPofKzyku860C9Yviz?=
 =?us-ascii?Q?A/bD7b0G+3xieAkc8KWXsoO5YoZMq+mSX1JRRRnuYMQSkDt3Le0VOGFb+TEg?=
 =?us-ascii?Q?xJU5fdG8+QucMJtnGHqJC/dyduRII7/YuJxIPpBNEbZONwrq/r73sJ+/7t29?=
 =?us-ascii?Q?9xNbHydbqHf6JtHESVWVP3hQ1arY3yFKW2P3Ui0G9Ts31cd0WokwivSrzJ8h?=
 =?us-ascii?Q?A9LtWAAMNnZ7hfdQfWC/S70HWkrI/3IMHBi7u9S/eRawU+ubQFRhSYltQQkA?=
 =?us-ascii?Q?fkMC25jZPomJUA1juvncsuEfLKT9Z+4oPKkxDUy/aJDgKlQS+sZEsK2bqE/G?=
 =?us-ascii?Q?p3+k2PcGM3um79fvULhgD6W8pfK4ddqulgK0dFITPfnVkkeHWFJR1kojxQrs?=
 =?us-ascii?Q?YCBDY4+pERJ1K6AGLOzdRV3yrkBKdkI9dCb/+/aNp1nW5P+QQgCdfbA6xOee?=
 =?us-ascii?Q?7sys7zHjkENCe4HLyHsnV2adwPqpHCrA3qsi/t6KNS7TrUqFjREf1U+N4eIV?=
 =?us-ascii?Q?MOLuj0oRxjHnxXKZ6pcrL8ib7m+Xy9Hx18M3eaJ/P8SW17fI2otkQ8+WGS/6?=
 =?us-ascii?Q?/xvYT6+pytYLlSC4xvscUtpMZyLBbsXKrl8pT7SUV2psVYxUGceZ+K+sgrsB?=
 =?us-ascii?Q?kw02goPhYp5oKvIOaocfJb7nF9IeEovYbq1BPgxmw1jsI65pvZGT6Wyni33o?=
 =?us-ascii?Q?NGQMSYFaZboaShrIKa0nZOqPVAfPVhJrXmrIOqH5xDP994gGf1DU82UjiIr+?=
 =?us-ascii?Q?Oc5PGlnCz+LPtroAVTy/GoIL3O8EqbwygMi7Awvl5jlAcx2qawdxQBQR4p7R?=
X-MS-Exchange-AntiSpam-MessageData-1: 5WSqhkc1p2YpsSsdIPJYuwjF9LRd9viSFsQ=
X-Exchange-RoutingPolicyChecked:
	SsoAmYz6vAFD1KeS+5agrmLvlJ/4CU3837TGbe+QL/yNL+7CYf9Xyub22ZwWdrAFMXekYGQBXCoXZAvANGLEHTg7yN+TYd+MYK39o1670fgbcfX8pM0nonwqHt9CH0BcOxrskwTUub+G9ZIdHjJ5/40wLCHxR2iJ+LyDLVhdAtpgRnelzvUeRPgnVh8prO7pQGuRdHrkEzZQ7oD3DaU6ooSKyU9OeTsGJELG9nLxK3wY4+7DI7Pkr5HJ0xA05WBTg84pLeJ/Wspk1Mr59rVH2othDIDLR+/CBvLG71o2GaAW3mSwSp86gYzaw6ilBYLTSSIJwnDdc99LiCxKexOajg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7e56b7-cb51-410d-ae8d-08de85f837f6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 20:43:47.3894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0c6/2J5JVr6CoHxX6+MFX3pvqRl9bzAJoDsuVbKyVJTgXMCiTbQBdPV2pNXf42cAsOg9gWLi982nwMM6vT9tjRNaHxE7WcCnUYbJ+XiIHw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5871
X-Authority-Analysis: v=2.4 cv=S9nUAYsP c=1 sm=1 tr=0 ts=69bc6006 cx=c_pps
 a=Y50mrEwtfcpO0Uk6WJhX1Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22 a=jY3BQ2UY-2ZJpQLl-tMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDE2NiBTYWx0ZWRfXzwZhRGBIF0Sx
 THLdthfmN9+nOLoEvHwxIs5TQVaPznZ9u2+in45q2XqHd+J2sxBeWCdyMXVNhoS/qjaaNEBRT3D
 67cOqpxojO/6SKIFemPBSGuJMNpX2IgVNxAaDdA49hOOmuPbDH4YyKtkg8hEdqxRgd4hNF2jVD+
 tiIFYeNEx4CdpC3ICRVyujcSzKphOPdNf5mg+paeyxjudBS7vrc1wk0uqcRiuhq6cxlCcsF+EdO
 9lq8ObPutrP0buz/MpRdimmF7oNNf8u8SB1SYao9TmOsNxluH5WLj3DEmA/KdTAsAFyvNO0LETm
 8X7bXQS1UML75YdbTBgfInLOvwXoMphwpisw8JzdToZOXuUqkxY6oGftqYcmOzJ6oJwWySd1UvE
 Kv2J8oTV6kHfOiIt77/PY+XnaKQXgIim95PwJrIy+iNv8zCevrmjxsbjNm3PbLjymgrEycU0f75
 XtYduW5AmOwV2Ei6QHQ==
X-Proofpoint-ORIG-GUID: P4cAfztOjr-5E8H_i2MwbYPsVCfaNlPq
X-Proofpoint-GUID: P4cAfztOjr-5E8H_i2MwbYPsVCfaNlPq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_03,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603190166

On Wed, 19 Mar 2026 11:07:00 +0000, Damien Le Moal wrote:
> Why return 0 ? This is a valid case, so this should get through the
> alignment below.

Hi Damien,

Thanks for the review.

The opt == max case is specifically the bug this patch fixes.

When the IOMMU is disabled or in passthrough mode and no DMA ops
provide an opt_mapping_size callback, dma_opt_mapping_size() falls
back to min(SIZE_MAX, dma_max_mapping_size()), which equals
dma_max_mapping_size().  So opt == max.

If we let that value through, rounddown_pow_of_two() produces a
huge power-of-two, and min_t() caps it at max_sectors (32767).
That gives opt_sectors = 32767, which is exactly the bogus value
that breaks mkfs.xfs:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2
  4095 % 2 != 0  ->  "SB stripe unit sanity check failed"

The key insight (from Robin Murphy's v1 review) is that when no
backend provides a real optimization constraint, the DMA core
returns the largest efficient size == the largest size.  That is
correct DMA semantics, but it means opt == max signals "no
preference", not "the optimal size happens to equal the maximum".

Returning 0 in that case means "no preference", which leaves
opt_sectors at 0 and lets the disk's own geometry (or lack
thereof) determine the I/O size.

Regarding the Cc list: noted, I will trim it for v5 if needed.

Thanks,
Ionut
