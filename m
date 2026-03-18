Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F3E36C0A1;
	Wed, 18 Mar 2026 07:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773819899; cv=fail; b=C+ToPrDF21dgl4jGJ6yhGCMi+icj7O/N9ddHUvHf/c+fG3NpPyb/+15H1PG3k8YGE/qJuT678ObDarYekBO1+ywBhOj7bfqj7hIp5IBas+cP8pnSFmWWRi2pvxHgqMz0kEQ/RftppyzndVd89VtUvou5Om1sWbUA1iwUbpXTsIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773819899; c=relaxed/simple;
	bh=7uSWhh0vEr8Cto/E7jACc5o+MN4ZDMBF7bA4DzczVyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LdkkBBJq3g7eVDU8THQphNkiz4kgAjS+A2BCachpTY8KGBkoHCdADD9SsSJ6rBqrFDDqwsD0n5AM4Itg0pxJsH0+bcfKBPiVzGmZxvBrm0O/RjHa92DJ7R1Tv97bHp8KYvIfid4IConE7Z+l4KgBUSbFZq5SsMNUGZR/2CfCXvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=pDs19uX8; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="pDs19uX8"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I4AVWD1191847;
	Wed, 18 Mar 2026 07:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=/lOs9WcHmuTQgw94rCTBWjV9Ww/iR8wd+jVESQyZQ7E=; b=
	pDs19uX8Xs07X+lDzJIC4osRQLImIB89eEfu8d2Xu6PzG/1VBx3Qh18+LxzgJ/jT
	QBofNGi9c66166A1kYkSoFuUbkKjfHlpQLyWuZCMAPta0/Uj2R4bfwVSGdHmN3ur
	po6R5PwMT8p22sWjYvDOw1soWv1HHcdGmH2/A1TA1cqPyucu1PZnNJ61WwhZCaVu
	sSoB4/QsRWqhMCAGn1sqXx5jj0ZYbTnVU4WO1krxdl9nvL9pbeV6c7FzWDlJ/0Ul
	x88gcA5Udlbiq1EN3LlRGYAc5dVPdmxe/67TgW+I09T+DjHe4+Exd7ExG1VLFmwb
	Of/pVZl4J+KWG1u6FafiZg==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011020.outbound.protection.outlook.com [52.101.62.20])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cxm66acvw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 07:43:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJZTeTc7WEy5oGBEeStX+R5t3m53zOArd7BYJjbEvwADIMqxekzfzyYb5DzkU1LhNu9uCdVDo5/x5jmAJPakbhKX4O3CCuIKys/wT5cUYau29O9PoKYBzdJFirsKj7NNspNf1+EIkRy1Z5A7pQ9ojfyHFK157hpdsIdfG+lGAacygQ+CzvsHPRBKtSkSoamRN+mq8hxs8d6vXJaju1jpCyDZzixEc29ubf3dlLjtmq2aIBSNEfTvmC4gqVAJ1zJCFKyRi/618nl0//DMpLJnq+5VhaFp/mbu4GG0/ujRSgAKcFuaKdIi2TB3wLYtpvK1neijqrnavX2K2DjIp4856Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lOs9WcHmuTQgw94rCTBWjV9Ww/iR8wd+jVESQyZQ7E=;
 b=kfa1Kmz9bKJmExp5kM25mjwpVaxaJ+gKpHblUmFUslh7W37r7icl3nBavvLOe9v3gmt02SqiOU2Hx0H2EWKDm+d8YbjRztdBgDxVZoiTaSzG4X8eaMGmg4PT84HRjRpR2ecf8dhQl5z+sq/PyWsnkkBaMWwUYFlxYEOHilBlXZHrNSoH8zF9ExeJMsgyGfc1K7TLGOduzNZ/+2hYAnonfHWxVqi5q8Ur/NZoQoPdh7TYkaCF24nnK6dyse1Cj3PqGr/XnQbMpdCVXNgwMh4NsV/o6XpskMQghqXhNhl29U8kY4SyyKMJiYX/SPU1Ws3QZo7p2UHWWpuuomYGrBlg8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by IA4PR11MB9177.namprd11.prod.outlook.com (2603:10b6:208:569::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 07:43:38 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 07:43:38 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, kbusch@kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, sagi@grimberg.me, stable@vger.kernel.org,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH 1/1] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Wed, 18 Mar 2026 09:43:14 +0200
Message-ID: <20260318074314.17372-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318074314.17372-1-ionut.nechita@windriver.com>
References: <20260318074314.17372-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0034.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::21) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|IA4PR11MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ed8a8ae-3ee9-4a2a-e77f-08de84c21126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|10070799003|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	n5v7v4zLruf2iDAPXEiyeZKbCeQQINYJLMEhC0BUvxyKY3MzPRFtvmPD+IwEGHHOPHQVNE/IZTre82fS8gS/xvC4y+oSTcqi7Ettf+RfGygwpqnFNrkbj3HB3Txqf3tsskmAzMRTqLZUqARdXXb07qqSJH4HgLp8qkGQLvX2N3k6PTbqciKF/b639UKNZdnLHtjgZ2QoeVbx9YHwlx+SYrsMR2dr5YV0u8ilzxFaTGRCEgUgutOXnprPVDHTHCTakrCYYQgA/9+nEMAYvmKsB/gm+7B8rXSbd+HtnTh+xxReOEuTBLsTNAuQGvGKXUdWgdvmeqGi1OgenZI8N84QYriLP4EKlsgaRTbWXfrOOW3QB0J63dpXezcc9QSQrRBFfLZj2WU7rQxSWOVJmPOmQ84unZuuw03BCVU7ljyVtBDnzhI2s61Mp2bBN9k17lptLB35DVJMqUncYflka3LJdCQfBmsnMV+xRoSCNKLmMXNd9r9868kamowN+tL18eVOxQ3dICxmYOVcZJSXLS9r0i5NqWhrNeZgAvdWcrF1T0rzDwWdPsX2/Xp5+p7UqfGe9svGAN+o5boFEt6DsxbNUgpMTYc5jfM1F40ROThduBQw+v8+qLXVciHUB12z4nU4Sr0CczS53A/V9VeAg5N8Orh+gAn6k598RXggJlWIlGUpAx7XeVfyBc8Mki4dQuCrVraImVObGza/ceGE92YWbkaSOsXOVCfDW16mbgx5lHE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(10070799003)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2hEdE5IS3lyckg2dCs5OGQxd1RSWktZa2E3cHJxTmJzS2NsOTVuWlhZNWZR?=
 =?utf-8?B?UGVNamhUZUZiVFh0dU9sYU9vY0hJM0hDVnN5Z1pNN0d5VDdTeHFqMTBXb3Qz?=
 =?utf-8?B?RzlMVU82T2diNFRyNDVMK2FYL0RWYkFRYUxxU050VXB0Z29XL1o2UVNrZHM2?=
 =?utf-8?B?Y0ZjTUZMNjF0eFBIczlRNXQ5c2swSE5qNHlOTWh1Q3B1K2hRTk8zS3N5U2JB?=
 =?utf-8?B?M1lxTG94M2Vyb3lmTHFXR3J6UDJiWFVlTzlaRHFkN3BrSktCTzl6RUdxMmd6?=
 =?utf-8?B?cnhnM1grTjVmZ0pkQk9USmo3RitGYzhsZEkrZlF0YnBjam9Od1BkK1cvNEZS?=
 =?utf-8?B?cnVjbmVtU2huVFQ5blJUUkwwM1hZSStOa2NUMFFyb3V0WEQ4dDZtRkt1Smx2?=
 =?utf-8?B?QW1TZnNuY3dJbTQ5R2lUYjRVUmhxQVE5V21VSFl1VDViS3E2VWdnQ1dhRHZD?=
 =?utf-8?B?NFZ1ZjlJS05PMlVnODkxVDJXOEs2TGwyVnUwNGZjYlFtWER4ZjFYWTVDRmhN?=
 =?utf-8?B?NXFEa2k1WndCamw4MFA5bTlKeFhoR3lycUNGeXIyd0NTM2JvUTNLdzN6TGls?=
 =?utf-8?B?VGJxRDhBYWZxd0Z3SmQxTzdCc0JEMXlxMWN3amRHUGRCYitQU1NHNnR6Qm8w?=
 =?utf-8?B?Rmg1bHF6bVZZUUxIR1Z5TytNS2NkRnZKZmFzL050cSswVUNwY1BxOFFaek9i?=
 =?utf-8?B?eXlwWnRFYkVlaUhGWTlaZXk2bDVIcE0vbE5HdDJZazVkNjdveHNPS2c3WDVD?=
 =?utf-8?B?VHpZcm1zTVZLaytCV2o2WTZVWC93VnVId2xGRU5POUJwZDcremM0UThkOWo0?=
 =?utf-8?B?WEt6SFNRQ1pvamtCSzlwZlMvc2hwRVVqd05CaDdkaFB5QlpiTDRLYUJacWVl?=
 =?utf-8?B?R2pEdmF4RkVIdnhVQ0FmZDk2dUVuRGVrZW5rWjQxMGVOT3ZKR2xMa1lKZEhR?=
 =?utf-8?B?N2FITEZwcUxEQzh0Rk5hVWhhcEl6aGQxVlo4Q0prekZqRUhLQVJLS0RWOVJM?=
 =?utf-8?B?WE9EM2dGQ2JoeHdlOFJ5aWFpVzB5OEdXLzlMTHFpUWU1K0NGWnkxcmdIYTJI?=
 =?utf-8?B?aFgvc1p3a1B0NG5ta2NrQU80N3BjKzd4czM5ckh5UnVhUlp1QU95dXltRkVa?=
 =?utf-8?B?MWtKVjNhUWdDMlhSU2t4QlAyLzY4UHBuejA0K2dFVXR4T1IxMG5sRnRRRDFt?=
 =?utf-8?B?TzlOVWM4dHNDV0RUNkxDNTJ5UDlqeWtxRmpaMjRMRDBndzR0dmtIaEFBSjVU?=
 =?utf-8?B?ZnlDTis2cFZmR0NUVjc0ODFDVnU0dzRKNStjdk1KN2JldTRRSHVXaDRuUGh6?=
 =?utf-8?B?a01pZkdZT3dFYnIwTEcvYTNFMWFKcGF1ZFB3U0lGOUVUNGVnQ2NvbWJPbjNp?=
 =?utf-8?B?M3RQLzc4dlA3SExxS3U3dTJ0ZXo5Yk5ENklMN2p1d1ZJQS9pN0NLUzF2TDhO?=
 =?utf-8?B?UTJlbXIxNjdjWVpOQm5wMm93amtnMlo1NVliZGpqL043eFdjOUZpcDMzVVdE?=
 =?utf-8?B?S1RScjZOVHFGYStaaWJjRDBuWVdyL2FhWnQ4dzhvV0JMK0dhYVN2c2E5LzJt?=
 =?utf-8?B?RlkzRUQzM0RMMmlnTjc5L3NQcHRJbWV4Rkp6dkpVUm9pMTJrcDlpS0pOc1Z1?=
 =?utf-8?B?dmJ0SytjMDV2bWR2VUMvMjY1ZUpBVEpvamV4SjBaWURkSHFFS2RDbWRiQ2FQ?=
 =?utf-8?B?T2xmRk5nMlRFTGptT2wyTEx6dDluWnoyTy9xNHhQbTFZQWJ0SkNzOEdPakJr?=
 =?utf-8?B?bExYWHhvaHdoVXRrcG1xWnNURE42d2tXOGYvVkRrYndJaGIxemxIcnZrUWgv?=
 =?utf-8?B?bWJQMmVsbWVhUDUzK1ptUklNeG5JMUJ6YnhaM0VxQ0QwOHNYU2l3WHZQTXFR?=
 =?utf-8?B?U0p3bzlyMmxya2kzdjB2VzFUNUprdHZvSWk0OTJoU0Z2OUtvdGJiYmVYbFQ0?=
 =?utf-8?B?L0xIQmR1cHpoM3RKeXkyN2tDdWswRVNjTk9LRGFNMXUxaHp3eTdxUmtFQ29X?=
 =?utf-8?B?OEY2T1VmZytGalNCbklJOE4yZFI3TE90WXFvL2xoYktEaHRCUkVTdFl2Uzdj?=
 =?utf-8?B?dGp4enduQmgwQ0JLV0RxMGVBYmdZTDNsOE55WFN4MlBJelFSU01ieWNDamh1?=
 =?utf-8?B?S0tZREVDRVE1QWJmUE1DQ0NzNVhHSW90WDZkVVdqOXBvU0RvTmg0RGxSR2Zl?=
 =?utf-8?B?VE1oY2NsU2YvTzZrUHppL3RuVmlLc3J0cXlIRHVwSUxQY2lYY1RTSGIxd25D?=
 =?utf-8?B?eWh5ckdwWXgwTDZBbW0wKzQ3TzU5TDNXTnJSa1hockViNEFOV3o4NFFJMWZB?=
 =?utf-8?B?by8xY3RNQzVpREFRTDZEeFRYcjlQL1B3SU9SM1lxSk94bkZhS3JYU3dqL3Nr?=
 =?utf-8?Q?w72y/FpJDiU43DJOQMCx3qhaXF/Kh38kS6me3OO9UQdfu?=
X-MS-Exchange-AntiSpam-MessageData-1: UvQRGXPYiihgur/1Ui84cRzlQMoSrbNnOMY=
X-Exchange-RoutingPolicyChecked:
	Uuz1IaqDmGh8Kf5Flxq+DkSr1v2xnOKVtxB6miCWpTYOxUaA0ugcGRIWH8Fo9Uqr/SM/pDvh5s3pBdFF1RpSCNShGrq2YQQi8ahQ/JDPB3OgFWjN217aWgD2a7WjDMJQuHavoV469kBXFhsj3oFxMOR+Ol63rlnsvGoFxPbHbSy5YscBroFkQoh9SL8fFzychQyJ+/nZT3p/p5Ww8qBT3Xg72a3fEFhXxcO9KcPpOwgPZQCli4KefcxIr7O+B+qt5w1H4t15p3M/FwKd+3Tq4xIwVNLXLPfNupRxEIQwKVzCR9TOzhKOdx6QK8Nsa8a0cCYXuc7uOnb5+DSuiALUdg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed8a8ae-3ee9-4a2a-e77f-08de84c21126
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 07:43:38.1068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvwGXbP5tssWhSp7PmNQ2mb0riwbv/SYhiKeCiIVxvhSpiKBvkva4Tah2LaVUceSQaCtgF7hrMqzG1vadnFSEoArX1Bb1jRHyCghFpN0v1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9177
X-Proofpoint-ORIG-GUID: wbGDK33nar7njh-GzpW2-ntg07lv6N0H
X-Proofpoint-GUID: wbGDK33nar7njh-GzpW2-ntg07lv6N0H
X-Authority-Analysis: v=2.4 cv=fLk0HJae c=1 sm=1 tr=0 ts=69ba57ab cx=c_pps
 a=wCl41NmqrnDcz9wBTMCcbg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=-DCVhyIXrxZYsbhsFEUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA2MyBTYWx0ZWRfX8N8MgHGGz3Gy
 XEoHFb/mPEhAIbSNJ6F7o5j0z7173facwTzJTDRpbRkyUmmETyPym3Bd5SBud8+tga/l8581dQu
 pEjhSUHLhFdlXRkUjd1tbzHhmJw+1V5krGp/6s1FdqQiadpT04QX5fhy3ZjPUJFUvqMp5ghfjG2
 N6fwG0UUH4Egus1LmqTYAkircgL8tZnp4D34C6Acka2jkOBoUkpAo8tF9xGg0iZfAxqvMKyih7Z
 iHeUgWtfbUC0kYK5aBIYrER7SjPF9yf7mUbg9ZNZNAOiKfIXIpHHifXU7mZNrNozFDsVhpUCZJq
 VyU9QlmmODGH1vNyNGk8jdvoln1IseALNQBDysV1sptTLfdnwIq+M3OnmIKtgidHuROvNnlgdJV
 YHF13v+vBY879ma12UUKSw19bO5MlGwjkhLcB0L3jEBbLcnt+IWc4QkrAKIkU34h+oKLdmvW/AI
 kar88KE6CBsNg/w33EQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180063

From: Ionut Nechita <ionut.nechita@windriver.com>

sas_host_setup() unconditionally sets shost->opt_sectors from
dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
mode and no DMA ops provide an opt_mapping_size callback,
dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
which equals dma_max_mapping_size() — a hard upper bound, not an
optimization hint.

On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
and intel_iommu=off the following values are observed:

  dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
  shost->max_sectors      = 32767
  opt_sectors             = min(32767, huge >> 9) = 32767
  optimal_io_size         = 32767 << 9 = 16776704
                          → round_down(16776704, 4096) = 16773120

The SAS disk (SAMSUNG MZILT800HBHQ0D3) do not report an
Optimal Transfer Length in VPD page B0,so sdkp->opt_xfer_blocks remains 0.
sd_revalidate_disk() then uses min_not_zero(0, opt_sectors) = opt_sectors,
propagating the bogus value into the block device's optimal_io_size
(visible as OPT-IO = 16773120 in lsblk --topology).

mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2

Since 4095 % 2 != 0, XFS rejects the geometry:

  SB stripe unit sanity check failed

This makes it impossible to create XFS filesystems (e.g. for
/var/lib/docker) during system bootstrap.

Fix this by only setting opt_sectors when dma_opt_mapping_size() returns
a value strictly less than dma_max_mapping_size(), which indicates a
genuine DMA optimization constraint from an IOMMU or DMA ops backend.
When they are equal, no backend provided a real hint, so leave
opt_sectors at its default of 0 ("no preference").

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
 drivers/scsi/scsi_transport_sas.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 12124f9d5ccd..6b4de5116feb 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -240,8 +240,20 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			   shost->host_no);
 
 	if (dma_dev->dma_mask) {
-		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
+		size_t opt = dma_opt_mapping_size(dma_dev);
+
+		/*
+		 * Only set opt_sectors when the DMA layer reports a
+		 * genuine optimization constraint.  When opt equals
+		 * dma_max_mapping_size() no backend provided a real
+		 * hint — the value is just the DMA maximum, which is
+		 * not useful as an optimal I/O size and can cause
+		 * mkfs.xfs to compute invalid stripe geometry.
+		 */
+		if (opt < dma_max_mapping_size(dma_dev))
+			shost->opt_sectors = min_t(unsigned int,
+					shost->max_sectors,
+					opt >> SECTOR_SHIFT);
 	}
 
 	return 0;
-- 
2.53.0

