Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29163FBEC3;
	Fri,  3 Jul 2026 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074931; cv=fail; b=iO4fu9wwLL2ZStZ7huTk2mOGprvhbjRi4Z9PVa2OyGOQnVBJfw0mA9TpI1TUGQrjPmPjF5tLGn/d2hegj8NFWH/FFSy9YTQBIetAmkqRuNrTeHWp1BViZeakwoFgVqAjuK6oVzSGht7vYhUUZvpnrL6hHWumE7201iMEf2jHBXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074931; c=relaxed/simple;
	bh=U3BWiE/C18A6ujhHXiG9gQZCyHfIb81qkCLeAImfgcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ro+aTu8Y9xQ6RPB7auvgb5zXUvdAjqGjByPnbplClyAGSXEs7pO6hahfvJxVXFIF9xsnN1oZHjgFViZ8FsPk/xi3Zbhgeowf84WbbZ0mSRHkGmcAYtsC/CZZ+UpAER5YQtYugtNCWKCldJJhqalT4JZSFraA43r3e/nT8jJWph4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G8y3bV5q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zbMvkzLI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G8y3bV5q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zbMvkzLI"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfKO3080649;
	Fri, 3 Jul 2026 10:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3vbSq8sgMKKyhHddG/0YpzaS34bsIekD6kKMk6XaeDk=; b=
	G8y3bV5qccTfwN5rGC1GT9vSNNvJYiVuOBKAj4A32DHvR5WndHdfBV+JhaeqQqQS
	AWlXFSj4vBliEZ5WP72Hcm6NzqrGvBblHUYS7Kv0ROymMwEu07rhcFCCoSJGmhS5
	HZmYYPzjEnWgtNpRWaMW4eRc1JqAXfXiAbr3CgzzPOVc6tkSbW65Qlf8I3VsbeRB
	geCvmJ/xnBmRph6//BGzrg8jyRouKrow3cbjdDlPtJQ6sDuHSzwwvV8eoO8CZCQH
	GpDmnQ/leaAsrVv92kIWqY3ZZwzGSTB20Lh61zrRWInbB776u5zghGEXMkVxQJIz
	vVooLM2g9ojG+0KDxsqang==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXBsJ022590;
	Fri, 3 Jul 2026 10:34:56 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yj622w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VvKKH4EgOiMY1D/Pf4KWs9FWWtRmzjE52omx4WALl6Gvv21UOHgnZC+qlwnXE0MJ7nvb1P3UUBIdTu0nnWU3WoTjRP/MrF/HYOgWfpJdPytoaF9HNL1xtG3A0IBu86lHTMsEBK/l///Jg/RDknIrYX1o9kIQkQbuAeumhlGOiDSW62jPCDYpV11524Ipxb1QXG5IZLgiKIeebyrD2eranO5YzE9MXXjys7CnScTExtIXT9coc1ThJb9Wxykl4Yo9nktHGq7bWQ+dl7rafuOPbLp7n9+2aBrsL2hrRxuTpyW+VHhwCxP59nnU57TGiCqhqHfcb/BOakvoxeFoiOVbBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vbSq8sgMKKyhHddG/0YpzaS34bsIekD6kKMk6XaeDk=;
 b=i9uxyCUGuQjn4usqCKBksCRisquLtqnlv2J0XSAO/N3hrPqDAgMiY739dCanh0UD5/VXgTDq06b5GRCVImBJJjbcO5tkaFIbf6uoRy0pS1Vh50sHxkRCUe88qtwFrbEukjOsK+cvXylkk4r2Upekc3/B7xaSQTHg6Yr9fHIlEa2ITg+XzN/gCKvuPlD3QV06lUf8JJqA7hQx0GMr19o0az8Tr72IjzPxUd0ICn4kvwn634kb/iYNd/oyi7yIlgGEqHOch/L8hZkzXzHownJPUWu7tkSytRPK1H1eSh6Mg7QDDrYSilKS3OinVEUR/gJZI2+iZzQDW9PD03w3m0kKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vbSq8sgMKKyhHddG/0YpzaS34bsIekD6kKMk6XaeDk=;
 b=zbMvkzLISdFmWWmHenDLLNfqW4RsWOslyzCDjUzEwdOYVGVWJ2yoMumWgjl4QBNrnu6x+lnBn5j8CqLNZ8ivOWs7wI6qH7Bwo1jKZ9T3w3ViJe6/14VZ//J+q4aZ4Y0nLVxbN+dwQ0ewlHsdeJGH4kM0evktA2DFy+haZ2zHoQk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Fri, 3 Jul 2026 10:34:52 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 11/17] scsi-multipath: add delayed disk removal support
Date: Fri,  3 Jul 2026 10:33:56 +0000
Message-ID: <20260703103402.3725011-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bbf9e60-7d4f-41d2-70cf-08ded8eeb6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tVW0u4pcc11xzh5FMCMiIg7LG+CfTdsjLRhdRjKRabmYChKIC1Hjc7fT4VLc0+YhXwZdQgrvzaZFEhiOF/aha2v6jpT7g+rQQXUy9aGwT2vEw6yrFY+tXVbKQ/5cZ/e93vQ0LJdQ0/QQGvTKtsZvb7M1ILlwABbEIwiQO2rghHt8n9+Ez4xXzQB7DFnsx+2ttggWFWpFP+WUsyEL617TL0NQYuFyfdGcGdME9z4BFKpqIdZsnvAUQN2kzQmUyETICIjwqeW7nmao9qBgsixMMZmLLMSUMqqn2IED9CWI5Pyr+j+YzSu3xhJvcY+myC5+C/F0PWZshnyAt6cXtL6V9spscyre6//T/PKb05mnrR6sBxFnPfjlDxnH5VrmDUrmuNqP6hLuJOInrQJv7oZIu9kfpCN9FEY9BJAJBel+oe7hIPxdljthTdAIy12+Jm+1lEzUpOBLwIc7a8zUCokGq0OqigeXTtsA8CLD+dzOelMsG6zEoOQUPn7LY2gyV3wNYaod6KmMHSR3XmMjm3Z5IaMG81IVtuk4jY/MKExICGAqj3y0g7hcd165Lv/w6PG3E+cvPMt7Q5fMrHV3llc2pbmaveMQS7fPpTIvHCK9siZUMiidrkNvtJaoV8z1k5y2avLATFVbSgLVId4LS9FBWlC6rQ+yQxyoXkj4S2MhFrY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ewK++DM4iIGESuaQYkH07WQtoPYKYDKyttrbo64QZHihgpX/TNm1DhJY2lvC?=
 =?us-ascii?Q?SV9w7XRKQ8Xmw3gOcXl32lt7x+hOa3/yEtCXFcYwJqUk38GdXaFdn8nfibKP?=
 =?us-ascii?Q?QqsSKWOYUEhBCfSD5tHmCteedkKPWCChZ34SU2lNwynMdvKFgVdWaHbBOvlP?=
 =?us-ascii?Q?u+wahmEfei4u4nKWayN59C61L0SqCStsHP3tYZJ3tR1e/AMG3WO+VpHJEyqj?=
 =?us-ascii?Q?5LTynC/D91pJk0/OIdX3IHY3Y016zaU1XoUqGvMfpCeDFSLYYiuEZJRiattJ?=
 =?us-ascii?Q?+zk5MlJj0dFfB33WotV+Xb4xUdZp8XDaT4J3D43vPk1VeFhJbtePq4IkM/xn?=
 =?us-ascii?Q?1qUfnAI6EtbJjIpN6QOBEfRBFDIVdrp6jTwftuqQ0xyGd4tCRQixVQDgXX9c?=
 =?us-ascii?Q?23UL3oMFZOKHo/lljnVEgEjxTCcxdY/n3vGtzTWY2QaICqG2JBzDW+Jm2Sx8?=
 =?us-ascii?Q?wGF+yKC5klQiGZu+H1zXkcWRF3ZY4lcwv1DdpnnT8yhZgEuZHSLrefF12D8O?=
 =?us-ascii?Q?rjYkrfhDchd0aR6MJ6nEKg7/lotJhjZJ/VViuuxA9evJ4+fZNFAtKLJCufCw?=
 =?us-ascii?Q?/6ETQrEPhDP9q8lsCYNN3QaaL0qyWY+lVAObeL94ngfwNXHR8gos0KzosfmH?=
 =?us-ascii?Q?pJ4EziPVR9FcSFijL8zCVP6vgTsxeSkFdgWe7Q1Z1XDiwiE5zSl0ZNB0P1iS?=
 =?us-ascii?Q?8GdxNHPvuvrjPgMyE9r3RIfsl2VQ9WRxF2O5YBy6KqQm1BWOJR6MBk/wAZPi?=
 =?us-ascii?Q?+2+c5ofNsKT+Zmr2CX1rIHQbeI7XAZoHz3yyK9ugNKdvtQF+EGEljk6U+lew?=
 =?us-ascii?Q?dQpehgQ6cI/FC/KYhBYUsAo7d5EWhYwlq0FP9zoJsW2bWe30iSNYwWC7Wc6F?=
 =?us-ascii?Q?LfYc7DalkhFJ8Zu5K9QUkaDJo690jwhXUarFOFzxcp+CHPkR0KcaQec0Ixy5?=
 =?us-ascii?Q?EmAXDvXt8OhXgMqFHnl4LgNG6itwvCmw2kFO+kZEcr3Pch08YYBzVYd/tqHz?=
 =?us-ascii?Q?LClJRh8aPm54T+08HuthZmIr/aOZvQcS/+ShtssJbPn5AkIG1wGYyH/qZSZP?=
 =?us-ascii?Q?F9LigxKJN8GYhnyvGAnNRT9kADBOync6otMU0YZgObvVtFXysZCVt120MUeL?=
 =?us-ascii?Q?9CGGqrjz06Jf2MGdjqlRydaKcyIZT9lZXp6752F3H4Oq5VFHTZGje957/ZF0?=
 =?us-ascii?Q?4ElNcTOV9bM5PT9SfKEp56AND9uupD+Ib2B71qWvAj04MaHcp7GWGoa+TUIR?=
 =?us-ascii?Q?xIQlhi1ZS4jAsYBA27RVRhWTZiwg2+wzTx4uB/Kzp8DBZxa0Elbg0Q5+qdzi?=
 =?us-ascii?Q?4QV+zDk/tlzm0yPlNv4oHD66HRJNPvpN82wKxtzaxvGG4McKFy9VNUCBLJFV?=
 =?us-ascii?Q?qHfYduzU1popjHt/b+ZAVLJKAAQd8A3E7oK+AajD8c+QOI67t3XdpGPjaRsA?=
 =?us-ascii?Q?kps68j2jDuv2cRQMOuszp/PHyLrU2B5ztKODwuv2S8MPG1zDVyJS49wpGnDL?=
 =?us-ascii?Q?GBgMJQaIpCDHmNLDqkiFJ0EXhFPacj4S368zpQk/C/EK3Nxm6XtpC+86lSwj?=
 =?us-ascii?Q?UyFuhO2dQxA/PbL/hP9zworUkRIqHrmOUSkRsx8A9ojz9KYoBlVpNYXPC3+H?=
 =?us-ascii?Q?oxU3rPB+YNyHa9F0Nn85KzGwKc67Gjw/CpOtrF4KLW6GaMI4/+rzSRzekwWk?=
 =?us-ascii?Q?22WfqD5slMXqv0nnvgLzYiGCdZLCVjqmzUwraKxF3TsQqhEbUzKtvtHXAjqY?=
 =?us-ascii?Q?EmLsSsJ45JxAuYQ/VjvZEjIgpi3eqaE=3D?=
X-Exchange-RoutingPolicyChecked:
	oWquy6XtYzIices/R7It4+Jetjwra46ii/Y+Eo1zmcclaVTJIqM41CXwMJABWBcZNSTNicoXz7N22wu5t5UhnRudnTt3bQfYdKSPQdwCePvK/zjdpDnwUaXIpUZUfVfbRk2Gr1g8KJzVazqyyREouPbqg/Dj4Z7pQPd0ZvCIrL7fdSIBPQwrITt9OiziNjExu9qeNzmz31wlhqyNjuZTlWEG/2qpB+vgjNxOxH3ep/hwa/qP4TNfbvqrm8VQpXXC7vRNX1p+XlHlgsWm7th/qw+Oqur0qhzqI32/9voSXMeIStn2MMtO8IRbEGdg2T+edu/kOaIbWPpcywWT91mPOA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QyR+6jtHJj5iX7Xqx69mtt2dpPCoMiwTCXJ70jMA9aZR1AcfnTjlP6nzZk19xGFeYKo2a3FYVGoE/qWWZ6VzYIcI0iYY/3+QMeZMcM4XMYB/Hv7zeWY42omdda44CwrHwAQzT9SyCedChQvfVa5y4H5ix+Jf9Q71/d6hMp5I+FlzzpLHPwpn31THvYXzl366fd3arix+j91EYRGddbfs8NJuxsfB2j9WxVOBEoTA9EDnm/w8DZupdPdWT6Eh78UovfzbkZT/byaJlLezvMvj7h3XpuGiXyZWEjq7fYGjsDCW5oAZuduBQWRyXPop4hEfVLpmYDxNY2fWvoCWVWt+OtG9+i6XrkE0mpHJSSHWSGv6lekvadNlXfv2LiVtPVRiJXxR2OiPiOk9eNx4RQRuFVZHiHw6UnLNvUgCfu1s+g+9pVCubH/b2tg99U2GRLBOUZc8//WIUAGFnOxxx12cyoRBqdcyOIL9Gyhdm3a93pSDvxnDJnWQypYmTnvJXI/JgD/mYbvVaU+C3wlf6JvHUFgepgY5CyNvHB1lLNou2wgZcrxXSjkY2+JMQweP18WfcWagsYSnzEj0c0zdYsYoeWCgTdYrn7xDW/VYv5DEbyw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bbf9e60-7d4f-41d2-70cf-08ded8eeb6d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:51.7837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5MIuMx1QMhF2J0JSZHTe515Q97gbGB2VkvbXIRTCTR9EGQ6HBokxMstOdQ0q6qtFvmvYDyzdhcGlIMxTVP6CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: VmHQSZw003_jSVy5VSFgU9cQvaLq79PU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX7rvARK31UQhz
 qcDLwCmCGgidJfySyvrefLfbmB5+UUiPd4JwbhzZOQmoD/1TLOXKnK6YRERHhcLk8h6ZBu7Qler
 UucccFyGOPWOvaBJ7RpsIGfSAdkjS8FBRKC0UAS1iSaBzrEpPAFK0erE7GYndEnlYLWKGJBH4yn
 Jmmv0aBvlzHkjMgp7tshbo7QJ5v872yjV9qxvKFMz0LtYXnG+pjJhD9m2XxPwECWrIE5c6d/zPX
 sZylUmqfDlMFiNZCr7jL/8IbF/7THAHyH2UeGoN+s9RS3K/PqSYOU0MSuo/fQK9M5Ksq1kMA4N/
 oW83tLu0DaVM10Jk2nPUoviKYnj6uZXfv9RDD0fqRAAFLmjrr6swajAYL1Kd5FmGJpmAO4cmr45
 oTXhUMcBU+ofIC47Hi8+Q8fW17iLoZvxcOIJKqGasP2oMm8p/pxSeceyR/HK1jrGu/yCRxvXgUv
 XERPrSh8I8spqPN1oiA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX5n8bBUfylTCO
 SISfdztKLOwqXkTZ+yLnDKQ6LKxKoGoZT7G+rSMVIPw4l7X0+yXnYWzEIW8hi6+NLoiQ6zQGOCr
 GKd0jORAX1mgJccYd0VDT2M9Ui7pS+jMEM4Diifjl8ehnWdSOBJy
X-Proofpoint-GUID: VmHQSZw003_jSVy5VSFgU9cQvaLq79PU
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a479051 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=S0-NFRiyq58gb8qD-mcA:9

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

The scsi_disk driver (sd) must ensure that the scsi_mpath_device does not
go away while the delayed removal work is active, i.e. it must keep a
reference.

No reference to the scsi_disk multipath structures are kept outside that
driver, so that driver needs to provide a scsi_driver.mpath_remove_head
callback to do the necessary work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 18 ++++++++++++++++++
 include/scsi/scsi_driver.h    |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index b4d9d6518b4fe..c947c71d15ef1 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -355,7 +355,25 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
+static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
+
+	if (scsi_driver->mpath_remove_head)
+		scsi_driver->mpath_remove_head(scsi_mpath_head);
+
+	return 0;
+}
+
+static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
+{
+	bus_for_each_drv(&scsi_bus_type, NULL, to_scsi_mpath_head(mpath_head),
+		scsi_mpath_remove_head_drv);
+}
+
 static struct mpath_head_template smpdt = {
+	.remove_head = scsi_mpath_remove_head_work,
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 249cea724abd1..d92b63d357f2a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -8,6 +8,7 @@
 
 struct module;
 struct request;
+struct scsi_mpath_head;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -22,6 +23,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_remove_head)(struct scsi_mpath_head *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
2.43.7

