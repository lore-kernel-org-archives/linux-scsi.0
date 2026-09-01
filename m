Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8047DD4D;
	Tue,  1 Sep 2026 10:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259681; cv=fail; b=rhfJpYW6VlzPLJ5ReATkkds6sSwKg9vwXrmiNqRJxa1HulgzEb92tR2NDx4tJDVFePzeZbApi5L5QqNmpyTtBDa1IHev1xpuMxswrR6+0Cf4MLvGWH6e2KEgAq0EHH1ivxlHXpzPFCKk0k1oznxH17aGcfzrKTqw9zciRDDMcAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259681; c=relaxed/simple;
	bh=gUrOjFsKFkI2SPTusxKnE3ROxsQithPeHw4+As057OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m1ln58vxY+bnIoFmm3aVmxsH/6I7mHrXUe7mD0YTagg5X08r0wjmFgcZ8uEyxLm1L/Prx8oAI3ftU7pslWbzvfzuBBwXMk/ccrXvLX+phMxS+nXascVcPgh87AL2spu+xAqVwahE1ihNGzQtLx2AgvQvJDImbyAJkdVwvZLyj8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sD9ZbNdj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=okxgApRD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sD9ZbNdj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="okxgApRD"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLC5l92287504;
	Tue, 1 Sep 2026 10:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8glij3Cpn0zvkEWA4DEIOYeLFq+5TNW/SwTuER/RLi4=; b=
	sD9ZbNdjh3HyCrX1g49ov+vZyOQT4zEFiwrz6U17UlPQ4Rndgr0SFmTTEkS+Pq+w
	jmdAjr5uRhJfMCW5QSzdvDm+SOF2vl1dJUvOSOfpVcqXd62Ed9FNGDiyc6SeNWj9
	IOUjUwuk3xrao5ru+JUXfu6n+IPizFmDkecrM+IQMwIkTjqQqwwe57eRMbIQrdAN
	bAWSiLkqb16XypgKSBBhaKXwyVNF/1RnEOObqG5ReX8rjfe+Yp57hl0a0pqIvTLf
	V5ymQu3u1S1yu4M/DGkqcv6Ro9TWI9V83vonw+k0/Q8ig+95nNJyclEtipIFXj5T
	0Yy2LWlxLCyRpTlIDc0+/Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp72cc8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681Aja7j001164;
	Tue, 1 Sep 2026 10:46:31 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqac89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gdzQUJLo0QuYJvfJoUpR7zLLAcV1MjlOoSWx04Vh9hOHWIzDj61oyr5oktKNgkOsD0cZoro5LIwsf+kmbKfTjAIvrsRNtw5f7nHe5mtq7maKr2RRtIVmAROzuPIjhvaaoXAX8yY0tdIThXK9wJGJQQAixHTwA8wAO3gzUD88+yf3kqI9AQCsh+urWPVKye/t27tarX16cFHqF/+8+tO7hRx5d7macezz8yMbM2CoC/eJO4osqom70ae1oVrdRbfMe/6rjHEHvXp7ayi9YhfdRvV6VKrbcgYw+9tmPkKvKGQfYYMlDFiYJcQ0NbCujcItFAaVudm7kl4US5DkWRYtKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8glij3Cpn0zvkEWA4DEIOYeLFq+5TNW/SwTuER/RLi4=;
 b=Xj0mL3rpFbBS/TQSOHVnm7b3Zz3grpE0JYT9dKKg2E97rPJO1roKwBPCbeXYO2siHd5X1eemGKYZ93S/GiXMJAQLxKdN6J7Kli4xjvTpO49ntazbcjPnRW1Azy/RLcTM3mMiQJSlQlNPhQ/oGNfNktPvUDyWh8xsDnDRfJsa6cfdK/MX7pemocJLx72gHwVFZgUonwQKW4+n+XpKUCUusqWgyUomGu45d+x3mmXrsy0xxL055kFIN0lT8vG+4EXIHZiQuuO/3MW3Ec8dgpedfPocaUXKFarfeTSTZ+oqOIGKBABQ0FA1g237uTE/mZw9AOYnczuQexcj/WGaOZGVEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8glij3Cpn0zvkEWA4DEIOYeLFq+5TNW/SwTuER/RLi4=;
 b=okxgApRDopNvkrfC/3NP2GSFPxErDXTNUwxUT1pyJkLfEt5q7t/K2UtfaCFl13IvdLp7uQm6JHFtByFaL1s/7GIUS/7MauKdpyIEWqB00jcDUTeLqWvcnjX/scYsS3Ky1qgU8uBKGskVBhtAL1akHavs3/ICbQiQpRUrajBtbs4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:27 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 24/27] scsi: sd: support multipath disk
Date: Tue,  1 Sep 2026 10:45:23 +0000
Message-ID: <20260901104526.3850621-25-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:510:339::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: c1895385-c177-4717-0f3f-08df081645dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10063799003|6133799003|20046099003|18002099003|22082099003|56012099006|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	NEKSUA+/YX8c1/eLGSP3lfSue+QzVzBFAgw5ukK58vatwFZ+gegybo5FZQYr0emN83MStFIsN+SG1PZ0AYBIkGnzzfneHPEJAheUwQrL++wsMQOMNjiRvCkQSafcL39I9CM2sC7b0p7zaP6oOEkMoshguZZXfLu8ffnj6UqUD4PTV8oJO7F8dPeZiiZ9b31D8b6PRWQGxNi/8AAh2jdpHJSuQcrsa+WROS/IG9nKV5Lfusy+ux7wPcnIZPxLSzA7GtnXpNXDLcW333V11j5qW0z+6CA+uR9GG7MurqwSYBBRy/6iYm+CNaRzgzahdbr9/KMkFcVei5OaCkhl12fWXqdLfBN00F9Td16wKZDeqo+FDjnAuiQbx28oKRnMsFQGVOfrwbRO4HfAwQloLogFWJIDCxUjUylLAQJZamQDBK8OCsYMqG5ceyU7Q6TNdYYVdeWTkndiDotg2o79batHCAZwWS7mgD/P1tSUELm3EWrb5soyL7361E8Y5+RCb2xJHGUnJYoKiQX/hfpuJ2nf/wGBPVeFs9Pevr8Gv55mxJcoakY9pvA7DKQrjrjenIvFmPhh7NK4UxkK7kxnV41GCGn08i8oexfXnFavBNcw6eJhHBgXWHgg3+ySe+Jz+d6qLbjMXoWeCNO4UUo8tuw4ZUz3a+ZSuMfXmSwM418Yn68=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10063799003)(6133799003)(20046099003)(18002099003)(22082099003)(56012099006)(10067099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MsXre1N13VRxalWgrudTEtKK6RjGLxJ28YyN7C2m0ZxIDAvfZCy8SC3YKlWu?=
 =?us-ascii?Q?yS5mwUvYgA3ppeZSxUYs27Er2O0fTwHcCo4XEMlv3HeA2DH0kOFXoNv157iY?=
 =?us-ascii?Q?PVLHrPImFIQgVTUol13R+9KgS/vwryPWCxlEITmQcqkvKGmwiw4gKZ4XZMiy?=
 =?us-ascii?Q?3tT2OuB9wij8ji9wsSGJVmjSd8H+E44T+9XKhhJRzbmG1QXKcSOjHIj/xjPv?=
 =?us-ascii?Q?eh/eR/+6FU05+rPF35ZsHBS52V1iqUSXX9fN/IagN+gUJhht6N5LIvgHW0FZ?=
 =?us-ascii?Q?R/PJhB/B8XbslK6zF9V4sp1rLHZUSbJTDliPqFrd/a3xmT98QTam1Y83oPRG?=
 =?us-ascii?Q?ut9+CfnThBb4lG5YHWbvwdE9xuFJCI8NWNSlBDn1yJm5x61JGvpEE6BWVhDN?=
 =?us-ascii?Q?THwCf3y6OzpwuFwnV+ZBkfbUL8k77JNX8frCTRUIDxpctZe/15MMJDIrFYm8?=
 =?us-ascii?Q?IUNOCLSgfGVpwhzopuO7zpTxSkKQ1VtTnNmeVP8WQUA8465UaA7j/Vsniox9?=
 =?us-ascii?Q?EALLS76Vl58Adl91WFzVsrCkv8gL3oPdTrOnE5LHdn67EOAgcZ0jX+o91+DD?=
 =?us-ascii?Q?ZdjbjYu30Qqnav3Q2yKIx0WNAkpMELccf7l4LxUytuh6nQHgDX82h86uNr/A?=
 =?us-ascii?Q?lIKvEWyapLK3eVK+KNl89toeAouoVgXlx6B1R0YJ4yNwXDcE6foKOr7luSey?=
 =?us-ascii?Q?ghwkI459+659LiGOpL5uctOM1GTuNIROUp5XgU35uC0vCIGraCpX1EpegNZq?=
 =?us-ascii?Q?73m05kzAdRiGStTSciPUfvnNkkjD/G4f1rYWbbD0A31p1aHVQkHHuUx3eZ/8?=
 =?us-ascii?Q?ru17dDE/OHdkbRS6Hym0P7cWR1ODuGo7IEHvg4LyAJiT4FJfVnvoiLcRtIgK?=
 =?us-ascii?Q?5xZkVU97OLlCRCMQD8cwYd/IPRCcMhtwJfNPVRMtbJ6zjuzYnPxx/1z6NsDf?=
 =?us-ascii?Q?NEP3hhK+dGVRkIz4N9Fav+9NpxvqUf6GEZj3CRMKffeUlhJs9SPqTHuYC5IV?=
 =?us-ascii?Q?xOHlKVOYxeu+LsZlS8eHdYLWS6wQONFjC6vDQUqELpK2zDJKxiF5yiCLAVeA?=
 =?us-ascii?Q?hkyjHnZIH6FkL2ky7lwMyLzD33VYmjpmxcoeNTDyCOmnDeGAOS8jYXKIBqb7?=
 =?us-ascii?Q?6TVkHDcFgYdRkEyK0kRe/Ihd1e6ehHo6AxmMT/TB6CfG+G/qaamHyPtxVFJ8?=
 =?us-ascii?Q?A24Dt8R1dd5Ut/blID+/nujUC+Gk/xJuoy3X8pIH+THin+KVW6UeIryIK7cc?=
 =?us-ascii?Q?gn98cVk5lgSaaWSxYtHnlblLfnE49au/al1/B8U+ucf9qyFVjuFjgKVQCyna?=
 =?us-ascii?Q?xotyy2DpYadxHEvKKMzsGbGwBFmZ0tmVyxJNzt2bSlqDJU/9sGxeCeb8eqee?=
 =?us-ascii?Q?PFgdfHcHmZEtKO0Fn9RYVZp6wVgm+aSvKWgjyqnKfoF4bwH3bvbdzwgYkFOE?=
 =?us-ascii?Q?j0tNj3FJJqPG/YG+IBpXz4AWT89qkEuLRn18Y73MY4xuypqp0y7dziYyatQp?=
 =?us-ascii?Q?dmQncvw/7/11M/T7A8CwP1W1LUl7Tno4DrbEqLv3yD860vh8iQtuA851kfN8?=
 =?us-ascii?Q?DpIVzc2d81jRLrS02OsaS9ztw3Cs7XyFahX3MDN2ANfJEoNgo3db5sWv/m5O?=
 =?us-ascii?Q?XHvI3eM99GFgbyz1TVfWO/2ju90kqiXde7Omk/62B/xeP0+UyZwrEXqfrw+T?=
 =?us-ascii?Q?oVO8ahWrFtaLOyccQ9GfigcHzPSA+zfN3+0duI+BVSREmyST8Cee5QOUufwy?=
 =?us-ascii?Q?kMH8FN8ECniqOTD6A14eQXlbpVM836s=3D?=
X-Exchange-RoutingPolicyChecked:
	tvU00Wd49NmCEI1AOq0qTfiCbgtmxWCj9HAXvPWPqo5mwxsLmMf9rmXG1+ZB8xgiQ5VDF4faF2YWxo/bUs9A9E+MXe5o3vxZMpDfbN4jEhGAW+Uo1tEQf5vFf+lCiLl/p8ZJxf6E8XFp5UYRR8n+kzYrYS83TGkGANeaEj+ndM4fq7F4RbioLL7rDuL80quMyeA7m+LSiiAur7p9ag7fcagAANZSdWcAEZh4yoZ4/YxIpal2ECQkuEZ1PL1IvFKVeKlE4Lc6DH8W/GruOea9QXI2Hn60B2kBkygFJ2ug4Kk46Cg6rEna5dY+JCUawUGGjf7Ih1MyOe4VZ4pNaqXFVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UZ0QescsxmKvt0kSeoQOTJ65xtAn91xF/1HHDHQFc5rawrp8imgOCIOQrZtEMsdoWa+esJyHBWqGnjhaow3mvZEqV52gfIlwJUsFAMOho6ZK2FANgZ1REU9C/gWTe0sPJ9HCBfm5g97a5p3hAzUXqOBYRu4nx/gg7rnArTsGhjNeuAhKnxpnkys8D4YTUiErPHY2BOvFLajQg0OtWg9K3XNY56mGrZ8Bri5nl6/UJMYlO9jCUsbB4JmRpjHfydipJNgmDyH2mXSv11KmcqVlNzEdVHuSNjt92chUaWiGh7Luqx537LoCuXUtc90EpxQCopH62Y0Qs4zCI4m4gFtsGAzpZ/NZIdWkRwbMNgcGQzaJ8xYddeAM9A2GTDdaEEvCPRcI3LoyMcEhzRhvJYa3oFSY323dRSJywxOq0WLCymy26OEj2VBFbS+Zytvo5Q+rPslrJiZ1MOdG3L5dxlB5OyQ6IhlAvnllywAOkwCAzcskDAVUvS7S18MChr9hzo7mnAOG9K14jYnDFtaoEMnC0ZWaPJRmsNxjNWQMGXTF/nNcdBN57t252/SchqXQi+L0SMzpK/q5rWsh3yxqd5IByBdTiog0KO93WBEaCrPJ+jY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1895385-c177-4717-0f3f-08df081645dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:26.6495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ko6SOnnsSyXyWVqpk5qGB7cN+6gQq5vN0DAPp5U5IwDzSFrYgXHxUF+kgp6UxJAiAAy+qc48nCxqa3LqK8w+QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX3IYclr5nBzz1
 EyslfYTlO1gR2AGv1EtpFS/AT6vOu506CoTDoyENNuWUU/3l2pvFM/86topedB1oG5d3aHDUGg7
 VJY4n1g5PVi4ePqz3Y5w1vWTvZCb0vJh+peVktzl3a3rHJkrkLAF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX6q+CiDogAoVB
 oWYkFD1+A1BIZlYj5lB6VXx5B9OG6HMuORwH522N/CwwoXSK7x2Z2oobx+jrqaHN29bttoJMrZs
 1RIMt+9/hhFkDLWz0LUxXeYO/1PLSoL3TPrd91bdFZq8KuSETas79HTB+DNrkVr0tsFAnNR+tsx
 tRy5OJQwViWHJreT7+hyAUfmAmObSbmX41Llwzp4zZRQ2vYLzvpj/EwBe9zsKqPo4JFh+JbdS7S
 LEzSpRJTXr8TshJ57Z0imuGet4tj4wmWX1iR0aP0Lfb+eafvqcuDiBHtW5tIawZ/rbHoqUA0xQH
 7zrpSrmmlW4zfpxa0mu0XiL8GNZeXkUVzWo1XhTZfujTpjQkDO7J9R0Uwvan1HfMw/nxWkAc8Jh
 wDFl4Z/SzEJBwZvSzjhGhtFmBzaI0EfeMmcYX2Vkx6chGGTQWBThwkeuujSSs5ZrP+R3sL9IWyo
 HkjCMCUfMpR+RnScVSU7sh6LElfFn2xPcXd8AQ3U=
X-Authority-Analysis: v=2.4 cv=G7os1dk5 c=1 sm=1 tr=0 ts=6a96ad08 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=UnEsLBAWqG5TZJypXWwA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: I_8JK_Ajw-ZaADKIkNahBKhfRF_KHvwl
X-Proofpoint-ORIG-GUID: I_8JK_Ajw-ZaADKIkNahBKhfRF_KHvwl

From: John Garry <john.garry@linux.dev>

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2

$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 425 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 405 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 60e071d23ddd0..28304a497d8c6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
 	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	mpath_put_disk(mpath_head);
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -817,7 +835,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
@@ -4019,6 +4038,90 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity and zoned limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	mpath_revalidate_paths(mpath_head);
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(
+			struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+
+		if (sd_mpath_disk->scsi_mpath_head == scsi_mpath_head)
+			return sd_mpath_disk;
+
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	int ret;
+
+	ret = mpath_add_device(mpath_device, sdkp->disk,
+		dev_to_node(sdp->host->dma_dev), &sdp->host->mpath_nr_active);
+	if (ret)
+		return ret;
+	mpath_device_set_live(mpath_device);
+	return 0;
+}
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4048,13 +4151,259 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
 	.attrs		= sd_mpath_disk_attrs,
 };
 
-__maybe_unused
 static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
 	&sd_mpath_disk_attr_group,
 	&mpath_attr_group,
 	NULL
 };
 
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	char disk_name[DISK_NAME_LEN - 2];
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (sd_mpath_disk) {
+		error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+		if (error < 0) {
+			/*
+			 * Should not happen as would fail for the same when
+			 * allocating the sd_mpath_disk
+			 */
+			sd_mpath_put_disk(sd_mpath_disk);
+			mutex_unlock(&sd_mpath_disks_lock);
+			return error;
+		}
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	mpath_head->parent = &sd_mpath_disk->dev;
+	mpath_head->drv_module = THIS_MODULE;
+	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
+	error = mpath_alloc_head_disk(mpath_head, &lim,
+				dev_to_node(dma_dev));
+	if (error)
+		goto out_free_disk;
+	disk = mpath_head->disk;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_mpath_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+	if (error < 0)
+		goto out_free_index;
+
+	device_initialize(&sd_mpath_disk->dev);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+
+	error = dev_set_name(&sd_mpath_disk->dev, "scsi_mpath_disk%d",
+				scsi_mpath_head->index);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		disk_name, scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(mpath_head);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_device);
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_remove_sysfs_link(mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *dev = &scsi_mpath_head->dev;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk) {
+		dev_warn(dev, "could not find mpath disk\n");
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	if (sd_mpath_disk->disk_count) {
+		dev_dbg(dev, "non-zero multipath disk count in removal\n");
+		sd_mpath_put_disk(sd_mpath_disk);
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	list_del_init(&sd_mpath_disk->entry);
+	mutex_unlock(&sd_mpath_disks_lock);
+
+	device_del(&sd_mpath_disk->dev);
+	mpath_remove_disk(mpath_head);
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_head *scsi_mpath_head;
+	struct mpath_head *mpath_head;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	mpath_head = &scsi_mpath_head->mpath_head;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+#endif
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4078,7 +4427,7 @@ static int sd_probe(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	int index;
+	int index = -1;
 	int error;
 
 	scsi_autopm_get_device(sdp);
@@ -4107,22 +4456,33 @@ static int sd_probe(struct scsi_device *sdp)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4142,6 +4502,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
@@ -4149,10 +4510,6 @@ static int sd_probe(struct scsi_device *sdp)
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4171,6 +4528,7 @@ static int sd_probe(struct scsi_device *sdp)
 	sd_revalidate_disk(gd);
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
+			sd_mpath_fail_probe(sdkp);
 			error = -ENOMEM;
 			device_unregister(&sdkp->disk_dev);
 			put_disk(gd);
@@ -4178,6 +4536,12 @@ static int sd_probe(struct scsi_device *sdp)
 		}
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4192,6 +4556,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		if (sdp->sector_size > PAGE_SIZE)
@@ -4199,6 +4564,19 @@ static int sd_probe(struct scsi_device *sdp)
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_add_disk(sdkp);
+		if (error) {
+			sd_mpath_fail_probe(sdkp);
+			device_del(&sdkp->disk_dev);
+			del_gendisk(sdkp->disk);
+
+			put_disk(sdkp->disk);
+			if (sdp->sector_size > PAGE_SIZE)
+				sd_large_pool_destroy();
+			goto out;
+		}
+	}
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4212,7 +4590,8 @@ static int sd_probe(struct scsi_device *sdp)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4340,6 +4719,9 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
+
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->disk_dev);
@@ -4508,6 +4890,9 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_remove_head	= sd_mpath_remove_head,
+#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
-- 
2.43.7

