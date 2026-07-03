Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F393BE16A;
	Fri,  3 Jul 2026 10:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074670; cv=fail; b=bNChwtiedIwc656QxnnE4Hhxp8uzBwVnlmlaf9EYWuLjV90WWOQTs16yNtE+gXH1zjJM5PgpTEkRTANbcFjMnlkN2aP5w0xmp1FahCbqVL0nnUJKnaj0Rt7z1vYqN0c0HXl9VYJX3DsI8p9p1n5YNfQsdLXvT03nw6slmBLHdXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074670; c=relaxed/simple;
	bh=6iPjciV901FtnsyIc36eWsfGBDx/qXum071Wte+yNN0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=f5ZLEJsRVxajtou/OzvWKrNF/+KmmU5aoWGpQUGprgmnATJpLdb3YOHOyloREoZnrM1+7gBvC5QQY/6TWcimzEgLJ3Vkvl6wl7gQrAiki3L6tKX70UBAWQ6W782KpWW0mIKydbjCifcvvxl4gr0tCm8kPdlOI04lQwZKAwP+DUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KneBUK/H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n9ZNuNwn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KneBUK/H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n9ZNuNwn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfwu3088786;
	Fri, 3 Jul 2026 10:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=pr5721v2QR/qbTJa
	wpsKPXHu5ICu/aGDbFv0JLG0ncE=; b=KneBUK/Hx/NqsmbcPNCl2na9xOYJyYxQ
	n1vbGqHKC8/N57yNXrZi6lEBCdnFpBSCBqc9rjcTnQj2s/KkGVfy7utUzYycgVUN
	eDr/esuWu5rX3ujJQV0KacWKZr4poOWdyN7xx+etkUof4XjB9Yl7DWqYFO34tI/7
	kuDOUD7vkTznfAqPC1jZtbpLVBATywiTW4kFxGahOhgTaDBzUdVJNwlE44tddWHf
	K6gi8ggUpxFR92bQfPv1c/djvlGGXlWGEASQtxytxWOBzoUacedrU1zNautreHvT
	GVJeIFr/FNux/bWyQnhQWkiv6QJvwJ7XpcY7xnm3iKf/5MiPVPDh9g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p4af06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS74K033798;
	Fri, 3 Jul 2026 10:30:41 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012021.outbound.protection.outlook.com [40.93.195.21])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhyq9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwwI25pW7iWz7Z7gPgGflNJ3VcFvRF/ZIin2sv1/LoLYoBnQ3ds6BXtOhkF+omBTFlZ+hoGuf5t5E6BJ1orr+P1I5FW5bLTqd7KuaV2D+aNkq9/x4cSChOFfvZ1PVvNaqyKQskz9gM2tYfaZoGiLi2j0n5K/9B01Y8/XAdyHHtQgV2luvs5Xtb+QOpPiM5B5SHszW3gBoGS6GFyYnZ6DHhosQvunLeYrZ0JVHqJVcJlZbnan6mZg8/pNXXeLIHz6h2yvodM4CatV1ZmZL0ulhQPdxcjFz9723m4KKWy65eb4ZsYsafqCE7HfuoUyYe/IT+hqP2tgRDv2htG9Cevx8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pr5721v2QR/qbTJawpsKPXHu5ICu/aGDbFv0JLG0ncE=;
 b=KMgtDKSEj7CxA31V4GXwPOCzPkZDF9hNDm2f9fHCvOuILBsfE8eqNmRF2SL7HNTq1S4meWYexGA3YgjEpatr1f9YkAk4Q1Mm+QNenH093oNbSD7NEjsU+K+kR3jQN1IlxWwvIHeK+DdTfepFqH22Q7YGpOGFws7zOepLP2e8dRRw0ymfrFjydE7shJbPX43qYyrr6cEyeb08K3971TyLDDdGUNE/Xyi0mXav4UpvCd/ryMQdeMa23/DblCt6dlHW1k4FAAvqxIg/xAXpJR8P6mP6pWdoubhyGs6q75ae+9gECs9f7VMU6FCK0JzQenHO5FJgN9kopiB13fW2QSBreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pr5721v2QR/qbTJawpsKPXHu5ICu/aGDbFv0JLG0ncE=;
 b=n9ZNuNwnto+VdbiAUVet0WdLvGRmBiTQKRO+Q+oJdJb8KyNoOGc33Bzzb0jypUDchZv85bd/WGrPSLRjQKmZxfVbnu+VLfdKzbM5UUjb94itgB0xJaLfCIHV19x1HkPQ+Y54fMqXGMUDPbA2ui0tnUbYH825fruO3PEb63bmtUQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:36 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 00/13] libmultipath: a generic multipath lib for block drivers
Date: Fri,  3 Jul 2026 10:29:05 +0000
Message-ID: <20260703102918.3723667-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:510:5::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 220e7391-50c4-45fc-a5c8-08ded8ee1e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|6133799003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	kd9yU/9xNQO5gEUunseUSrZXmiQxAz+/aau846Oh57UJZV8TEr6p+K3y3dtnj2QKaSQP8lIJMkMPROxrOUw0ME+9sbhHIvar/fh0qW8OuerXBbQFhm00NSkHLGTea/QY70r8gLJqk9x1SWdloGEuJsgXHECR/NDdX7knpQahJFSi4+hhgM/3E49erRbGkxPsTMd74Y4Gx0aDDQCbR13EEW7BDnUt11gtntlfxjpv3FvYZcRQQ+1xpQuhjX7XhrPUWD4Vkm3z3WYd/hR8+sr8GpImBgc/2pVae3L3SpgJSOI2r+MspIwxdzSqztLPKAWS2Gv6J8jQ+WThhdghpduLBCBwUSCdLq87B7vxeF02mb0+vTdu1JyOw4e6dCnBss6yBqiwsKlUgKUIyLP8tVHd/jeiu9UtrhYuj2zwsq09u+b68XzDQWmxykccnET7rUigbck1AOSriO/mUyG0Tc1L5DI4qiWiMi2tu4WiWbNPgmij7ul6Rqel8IxWzRMPrEvhjT/ON/PYc9NBtIktQbAj1Q/H82RGn6K6YzajB64VKIeuZ+z9lkHl3O1LyehnjvfzrV/vblDGs/A+AnFyT2QE+AUx5O/XCOQMKWFp+B0lVlPBEFFbwl8e3xdaJy7zMziedr284umKRC8PRwWQmD7H5JtajmwkOhHVkZd47sJvX28=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(6133799003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ooAFWcPEv0CmIROUrxBhymHnzfJ72iwN3in2BATZtI0FAgk7fchQUOfTWdRM?=
 =?us-ascii?Q?7kyvZMOhI2ExpdQEnHOs9jYtu5AhhJcFOXX3xjdrNK2kzbaz5dsORnKjlhkH?=
 =?us-ascii?Q?u/yfYCq8BRrOppYztTjjjRsK8S6grGqTIBU4YaqEpqTHneqq0fcIPT4CiIYK?=
 =?us-ascii?Q?QiF8RoZkiFZOk8TRPRViZoDAxlqY499MtcZzR4DvIWHg0lHGpgBstNvbHLnz?=
 =?us-ascii?Q?SV6O+0BSuIbUiyVpVrYFlJzoxiuP6ZCSCdwyLsTOMhk6uVf0rgne2ou2zp5u?=
 =?us-ascii?Q?MW7WTfxpMKDNE61A+ENdRTR5V6XxCdPweXgVFBSb4kSsYLceBNv4nIokmSlz?=
 =?us-ascii?Q?rubMwPNIs8HscPrzfGt0pOgzfPJeRZEPPqKSAkCsuigIMMQLn0SOX1G7g31x?=
 =?us-ascii?Q?XPLFFEJPfe67LMv07mJ5cIYp659FUtLnQT/ZBx6k7GCXjt6J8no+vT3YSKHv?=
 =?us-ascii?Q?/QSutgQiuvJ1S7g4aKV34b5fKbvLh6SjxI4bXzsCSZn2JdvuLA56rMVR6qfm?=
 =?us-ascii?Q?rANStw4oNeRPKpFCl06GZngfx5f6CuCnCBZumuvFSoZ976MEc+Qjy0HVwpXL?=
 =?us-ascii?Q?GVXlwLc43tWD8jqdG9PUfhQOliNDPbDb/yvrWnlZdE1ujFxJUXbrXr8QDLzm?=
 =?us-ascii?Q?N+JlceDT5/3eRrAWxWjC4WS6RU/+Vo7BuTwL5nvG8lTqhNSltvGgV7HyQkCc?=
 =?us-ascii?Q?pxilZ0LqFC5G7KO/70TqRq8mXOfiZWlnmkM/112mVeNpsmiZkWYKf9D5i/im?=
 =?us-ascii?Q?A/jBQu+eWgUZfsayecR5baH2uNJ7eYl9eBV2Y+zCUmMiTep/AmQFKKr+hBjh?=
 =?us-ascii?Q?9N7A2JiKuKZVRJOM7ot5nd+KwFsBFDEzqaXDaKsybUvWC9uoQDarfjUj5YIs?=
 =?us-ascii?Q?PR1yf1z6ENCN1Gn7o3VphyPC3JrWfd6U4SczUJePkp/35HOzWdUbhP6z9s+M?=
 =?us-ascii?Q?hP7vFNKnM2oZYD4ro2v3wWhRjW907HeElVwi72c99h5BfptgM6afat3c2hPV?=
 =?us-ascii?Q?FP/fLjTYhEhsahCRDPEw8Sgdcazxm66EGkj4agDBEP5hrkYUsxq5e9IuXwYk?=
 =?us-ascii?Q?nbZRqEnYLmKlqJlcvJGDa6pNNjpe8voXvlI5ja7QpVkZKdpW3+gSfAb4gvpc?=
 =?us-ascii?Q?UtSmxCjI1vN/lc21+DvAn+bFChdU6+ym4eeAMo6DYQWBWUW+tzXP5CxRbWR7?=
 =?us-ascii?Q?vqkCNSmrzDN4+cZT5iMywVuCsC/xsu6eWgRVHdplvaVb9DuusbmDWRAICAN+?=
 =?us-ascii?Q?M/QqdRVqvJJAHXcAiY5H68bK8Ld9bwe8S5CoHtLZEz9421M0AHhWb0F1JBYO?=
 =?us-ascii?Q?7pmIzcMLW0+RwRo6211Qs1Q46vmRvyGmVp0xoNv+3HIDfZKcMrOUTO8sB7EP?=
 =?us-ascii?Q?fuv5PPa64d4grATDJk45ZlWS27SZoW9YMkGZZwqOssuYocjuiqw9VueJvUXD?=
 =?us-ascii?Q?jrDpjq1i8+msXUUlkw7s/ha8s0SblXRvcxIMWPc0WbNtcq1nZF/Wr1cBbraB?=
 =?us-ascii?Q?ALDOumInMD/9djQhLSKnO8WF+FrD2oaG31sHxDiVUwwAcI3BPdwNt6eDTLG+?=
 =?us-ascii?Q?7qizmwOcEkeargQYxVSvqgkImZBT0ms37wJc2nl5XCESVKCSqjTDVzJ3mQIe?=
 =?us-ascii?Q?bA6b75BF/039i8esFBLIknbRh/YAhuXYOGHU4njHHN3RD4X0Lx8hW/yZbaRl?=
 =?us-ascii?Q?n4K+OX0WVMqsUIteemF5mvoh6ErCRTKKDDCVcqyDjjU82OIvDre+m2nMUvSj?=
 =?us-ascii?Q?IFmu/q+10GNTeAEeDfQjfYVTheqN178=3D?=
X-Exchange-RoutingPolicyChecked:
	N4uEZ6fWjVAiokQ9iWqrWfj1d54KOpnTvZIr57tfQ8yAQYnB84uBT46RoUyJK1oFMfeneekkyj3T9La5iE7sNHFtGlaOHhE4mKB2pEScXXe8D6/8ANYkDvXnjBX3L2JkBGfXbblW3fOK5exT8LLFMYQ89kcUmvDprP9FRtH29FCSQoZ6MB9gAuZCDRkQc3fC5XzH3IFQDN/Che6qhqPyI5omIeaEz4I2poGKRItmQETOuMX6BZzpIuvGpnt3rdsOTvKyQ/zdvJEqqcD5VzPaijFmN8HhSO6/4F8En13tXfBjb8L4eqZyTQHG1vY5MgRk19gY8jOlk5OKI3X5MKj0fw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K+0qvCjTpyCTtxM9OiEhAhF/9lf6E3FG77FZWXsYz9mvh8y3VJW0AdK3ZIqR/ySLkuu2s4giwDPTmbTfdwJIfqKmfnuiLk/aVOeHOIbqEX3Oq3BWd32wHVo2CXR9FkZDPlLKlwjcetB1eE6S9tsWX0EM9VEf8XCMsB16IRomvCaVdpVMJrlDJuWLmGP+HTDDYsSrj8yhd8F+9ii1HDmGOKuPbOWgzgrQ1kT/mjrtNe2ExwkRsRnJ1+hdumjewqPsqiCnNb/lCPdq5rvz90B8qmxwWGGgvFURsZHqLtYG7kFo0XxHQT7u+A+9mr5GA6t5TfB7xsI0O7LU4VvL3yRP9USiPWhiT3WdCag9BOl/t7FKAk95qD3zXx8p93zwIoASKz7+rYNhPzEwmxq17zqEguH5PRh5BFjM6Z3Cc3mgBkAs/GDoZJUVcFWrBokJimoHTlh5nry6p0QtGKA8jAtdhDj7r1A4l65+hZ/pl9CyxLFHwe+lk0tUQkdiam6rRPabvfZyW3skn7q58b+2YZK7dYb7y2ZJEbT8VjwEyS9wc52SB7Ol8UHTJsqHPlUNWgqMpEQWIYIIWlADzvCzw6s9TxBHpnujKj2Ia8t3NySiRak=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 220e7391-50c4-45fc-a5c8-08ded8ee1e37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:35.7721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMdWV2Z1SHid9oDvbRT9JbxwPREkbQD8i/yHa+d4gEyd/8NuRmoFgRDNdznOP4K7E/WdtIb54MnSuEHbdbLK0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=916 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: eLljIDyc3-T0xSutAlgGdUO_Y9a00Ixu
X-Proofpoint-GUID: eLljIDyc3-T0xSutAlgGdUO_Y9a00Ixu
X-Authority-Analysis: v=2.4 cv=DK6/JSNb c=1 sm=1 tr=0 ts=6a478f52 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=NEAV23lmAAAA:8 a=mzwNoLC9IZnmwtnRvgQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMSBTYWx0ZWRfX2FZRXVrkNqNp
 +OYDH5eKqDE9JG4qtP8jzWswuRNzrRaMqqNxIVzbCsa6wKEpNckmXL5OmKmB6ep0gWtvBFXnlMY
 5pu01PbiiU1geeFfi2SZHoTynJ2d2ZauETnVMmHz4rsl4rhvNchgaC/qvupLAYFNL4rswlk1FUg
 8SUDi6Ro7pYPFNA1IxuxCjvSKGezjH8YIaO54rzup6bPKUqGHLqiGZjwr9xI6shZwl5mpGX6BF3
 PKdZ5pN46xVet/HN4n4qgxlcDj4HqXxAW3YdSix5IqnnpF10hmfPI+1fa4NMaJlXQesC9Xt7How
 uRxHU5K5EfHb/D4YcPrf6HwM11qyAs7Yj7MvEhAmcROWmrDlCeGUdiL9qHOUMRF0ynmRQBJt0Xt
 dW5hw2H2bBclweXPCxowkVEGVwjOz/kTXmprAgBEbIqzFONtqq8DWJWdbwKNsKmkuPM2LG4SxzN
 c3/3h6x33lGgD36rXrg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMSBTYWx0ZWRfX/AJ1qZauPY/w
 q1iXehQsHiS9cXzp15l3gTEO9cD6g1cglQZg30csUmrAmJlJG9LCVMpfc1dI94ky1EEaVTSpkl2
 SHttEi/QeE37ls65mBCBAIPHBK0gVbPNCrJ7Rn3F0jObsBD034s6

This series introduces libmultipath. It is essentially a refactoring of
NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head
These contain much of the multipath-specific functionality from
nvme_ns_head, including a pointer to the gendisk structure and
a path SRCU-based array.

- mpath_device
This is the per-path structure, and contains much the same
multipath-specific functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Since the NVMe driver has some code in the sysfs and ioctl handling
which iterate all multipath NSes, functions like mpath_call_for_device()
are added to do the same per-path iteration.

Full series also available at:
https://github.com/johnpgarry/linux/tree/scsi-multipath-v7.2-v3

Differences to v2:
- Make mpath_head embeddable in driver head structure (Sagi)
- remove get_nr_active and get_iopolicy driver callbacks
- rebase

Differences to v1:
- put current_path[] at end of struct mpath_head (Nilay)
- drop struct mpath_disk and keep nvme_remove_head() (Nilay)
- don't pass iopolicy from mpath_find_path() (Benjamin)
- change mpath_access_state names (Nilay)
- fix for setting mpath_device.nr_active and .numa_node (Nilay)
- fix uninit'ed pointers in __mpath_find_path() (Nilay)
- simplify mpath_head_template.available_path (Nilay, Benjamin)
- use DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE (Benjamin)
- check mpath_bdev_submit_bio() -> .clone_bio() for errors (Benjamin)
- drop struct mpath_pr_ops (Keith)
- drop mpath_head_template.bdev_ioctl
- drop mpath_head_template.get_unique_id
- drop mpath_head_template.report_zones
- drop mpath_head_template.get_access_state
- add mpath_head_template.ioctl_{begin, finish} and drop
mpath_head_read_unlock()
- add mpath_device.access_state
- add mpath_head_devices_empty()
- make mpath_delete_device() return a bool

John Garry (13):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add delayed removal support
  libmultipath: Add cdev support
  libmultipath: Add sysfs helpers
  libmultipath: Add PR support
  libmultipath: Add mpath_bdev_report_zones()
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()

 include/linux/multipath.h |  182 +++++
 lib/Kconfig               |    6 +
 lib/Makefile              |    2 +
 lib/multipath.c           | 1318 +++++++++++++++++++++++++++++++++++++
 4 files changed, 1508 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.7

