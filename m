Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285E83E3175;
	Fri,  3 Jul 2026 10:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074911; cv=fail; b=rHBWL/N8xGb6ElZUNvoV6FfwQPUjt55ZBW38vTNTj5egSGv/Aw0S0s7dOOVItEsiWn6IVrQiB/PqiD4Adm+3lgsr9Qo13Rt2glIeGcdrG8TViLtIwCImFAZ6HYSyxRWtIvLLUZVhRQV7p4f0lgeaGf8MjiMpe4fTcLP/ISDwPEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074911; c=relaxed/simple;
	bh=XcuJ2QzCEs3n2XXwplYfHXFMpk9eMteYy/u2Nd4EQIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dkvuZFVOuRdXjcxFMUHpKkPE6Qgj6isAcs17qgeLtQCNlG7fJKEmG7I8aHR2xHRntYC90CHtSSk9noLjPUxwMZPY9xFmWEVbYFqSdejaiEC5JYZfXnO/mSEjJd7M1Y6FKCty2aj2+sQk616m0kH5NETn7Zca07k1G2kX7pzWYXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EV9kTtjj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U6wmfEZe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EV9kTtjj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U6wmfEZe"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638uY4N3340542;
	Fri, 3 Jul 2026 10:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1Xa3+3scPPbt7SU5n8R8wHPWGoJ3qxb8qQNsm7MIdKo=; b=
	EV9kTtjjtKwtCtSYObvrMn67GMSHlRDJm8n0R+eq6xxgLNUyfE6VW5kzZnTdHA/y
	slH6hWeDigt5lXqZFKU3hCoMW6r3IYWnLfNhye/9i0PwX3kxa4fIRDLlDq5KOTT4
	jSEQi8y1I0hFSQX+/9qv6BOKghO9aGkSJxtDYTVmihx0sr9Rr087B4oCBYNGzNrQ
	lxnG/8dx40K70eUAgkTrH9V/jQEg/9Nfi0h5WBqD6GvqMpAwozkMXymrd9gBRrmP
	l/+f6SxidR9SRubbgVnGfWBD0J562ldVtEkny96N3/Y/U6QEwU/dWtSjlJxvxqxj
	OJvGEpDiBcpRFlXBaGQO3A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p8tkpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AX9Hq009769;
	Fri, 3 Jul 2026 10:34:47 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhytvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EzXQ+ymQK0Jkim06m76ilDarHMfotPqaJ7d6WfUUze32hysxS+SoXJwhpaCGUrZ4A0jmoo/KSCDtgT/AyShGhLac0qmMIQtgJ7OO1yPcVPdaeFya4vn3YwYPJQuivKugDLtQN1Ncdaz9mdoZaujD02goWOeYgyQhMWFg2tmMifauVVoQNpGYxbSZEyMKPeb+T2gwGJ/u2r4tY+k2pdlserFqMybNrCzUZlc8P2A5hSNxLbIasTT6eWQvmPkqSr83kbBUrG56qzQrjLv/3UNUelWkMLzgl0b/2H7rFq5UDY1JgngEItspTji2VnyvJgpuaBzTSWTClmpKll2smvwQYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Xa3+3scPPbt7SU5n8R8wHPWGoJ3qxb8qQNsm7MIdKo=;
 b=OLHzUe6js5Md8tSWQomhyUlzd5P+/zfOzi63lgNWyFmkQjBYw7zuKUoVa9lVVaKOgNKrmBFqzRpCjY30kIErVawMYXpll7AB24dzlQ04zgZnlRzzRoxVU9NZ7NWrnstcmmX6NFx/JNqvkqPEsZGlJSBoh4V2EDLjUgVo/n3Qn/xohH8WgivVUvZv6n8DGr/ddnH6exk53zyXi7hEWfJ+XxQx59wzVE3hPb3nf/R4ZbYd1cgL828V5KGmY66EikEW0U1ABeiT7v969d7wFhpvbJjm6HMn9D1KMNj6YUYbCdU2kFj25OaIJzV4cUepKfESeatJR9LVxRljkNwjwh6fKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Xa3+3scPPbt7SU5n8R8wHPWGoJ3qxb8qQNsm7MIdKo=;
 b=U6wmfEZeApHgZ6DGrlSJ8FeIUXfU+e2flv+djS3v+VCJXPULvlJ1caXylD8Xu+TxN/6OdsEdZXrT7nsSgAhI9NTq05EgZmBd37QyDM9kLutJOXG0G8VeHMT+E6L9xL/Hsraai+EQZhtIS3RT5Tq/Nxm6NPg5q5o+AtZYbKe5IKY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:41 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 07/17] scsi-multipath: failover handling
Date: Fri,  3 Jul 2026 10:33:52 +0000
Message-ID: <20260703103402.3725011-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: d6339067-af53-4109-776a-08ded8eeb086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	jSqk3O5d1e0anealXM9RJEP6r89M096yUY194OMpRU3Z76zPeuuLkUFCM5a9ea5Y18VZFQGcHvs6v3E3kjC3Qf6FYDU/3YzKNzBWESXlIcxiF2fKlTZOF9V0Bft3CxSG2g+T0aRmHMElKlfXVqTXz1+nboUaU0CEIyx3keVATaHcHauLTRW6+2b+nS5Js0lWic0taq+6XUHTzm7ANrBU4m/5hdQTal63AyVb1lJ0MRIcznks0f49eL/ZA+srzZ4l3gwtwGL886GXuW3Pe7KEAdx/HSbZbV3JrGz0+Jac4Z0yOwvDOF26arr39HABmB7VI86ZQ21ud6TbX8d23kOZVmfsZBRnm6X+dlT6L3bSNFU1R5mbsPaqR2Ba23nklSBhvWLIU0Aw3Zw9KFpidP7GwpREgYPghQ8Won2Kk5mzfmOFdjErFj/HDuvSTsa1U4DXFu+xCRgIV3iHy6brDHcXVTbKoTxR7yvfT74FeD7Vte91bh6Nk0Dv/OP5gkqXWfIdzi8oRr213C2154rSJbduETbvFluSp4UpuCkAQPmsN0dcUzSv7wv5hHji4b76+bb8LGp49Lol2zGy3hyE98oWmDCM7+O5la2YexMd0z9XmI7/HBJVxdKshph/SUT44OOuviq8QPy/K8lEYks3T9a15AhhsxgcGVThTzuZjA/plU8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?feeKJTDwbmJ/tGtm+lRgF88A3MA7V3cAYs4xX+HNxwE54c35v8AZDMl74ng8?=
 =?us-ascii?Q?II27njs2P3PE7Mf2HTF62jCcYWzCwGhTsCfwCQcQihrNL7JwFYXzUfBDm1bD?=
 =?us-ascii?Q?NQaDRV/iCoSIJGQr4fDnfgBXqZ2zqfu8As/przAIx9fe0S4QVtxCc58qyjq5?=
 =?us-ascii?Q?2AfbCF1eGMPLLV39ZvxDW+CDo69+I7Naly75ShMPEEamqPEQzkyJAwaM0shD?=
 =?us-ascii?Q?JIU3qDuxK2PEUSeWouDuNFqgEEublneEOimotS0NLyOEJmyWja7fVUJusQoB?=
 =?us-ascii?Q?ieYfRnLRu/01mTf6MI/NqB37eO2SmiUwGi8J7U4mjQpzCxbCJZSbeQc4HET0?=
 =?us-ascii?Q?xTZUXzrBcaxrRj29NEIWfldQl9NyC/kbfinnEGZuuel2DliC+Hv0PwYQ5h2+?=
 =?us-ascii?Q?0oYa/KP6IzO14BHfkzpmePjO4RQcizyRdc0rNze2lOjNXoFX7SBpDlfZqMeS?=
 =?us-ascii?Q?GhBOVGazDM9NbK7RmCvtgxRR47Zhn/jZSnLUKUmtAl+/ygvTWsM+vEZeX1dH?=
 =?us-ascii?Q?sjjduvaDKjsEsyMN+vI1njMg/3Mi4f/qHAcMXWfMyFhtTSTPwGyak01C4Z0o?=
 =?us-ascii?Q?91nPTHwbeD9o2rgoPWiZmPXSiDXkR8LCRLa5K1WaQcCDIb8Ky2ok51mTpF9j?=
 =?us-ascii?Q?ip8nV/18OJLLxzGIDXSmzJMtyTRrg3qPgnQ15vfykZCANfnvDCLEczEE93q+?=
 =?us-ascii?Q?geiRgdmna6bCfCkM6nLXefsdOEtllDWZva0FLWdubOSpAQBb8Rw5kxUgUOY/?=
 =?us-ascii?Q?M4k+DU7k1I2WS38FaRN1EVpLaek7L7Hdc6TFyqh83fWOrcazYkfETjzFRwSW?=
 =?us-ascii?Q?u8RSNDETBYeSpAOtP2IJtrzmQY+K4ptUqRSc0qWMTtmaVWczhw3j9LZ0wDFg?=
 =?us-ascii?Q?/1j/9Q58GwisfLGzIQ4i55+Osv5WiV7i2YYuK8pbc+5S5n8DF4a1pHVp+yeC?=
 =?us-ascii?Q?d/hV4R+G4gixeI311/ZpIvorShG4jXOj9WX0beYgroR2n+uIdR7yPL1xTmgQ?=
 =?us-ascii?Q?evlCrzP6EtOL6vycZUS0ziEfPZSLRQT2fydaqizkdxfB8KR4Oc6ANPb5ISz1?=
 =?us-ascii?Q?3xjA8RxjpkvBzCC1IIT/O9JL7l3PuefRLmH0hBHVCcEMZzGt6QqQ6wJs4zrI?=
 =?us-ascii?Q?zjrnnpOyukWm1Oa9zGzxiN6T2zJCosrQ+CRrQJUBQvHFsSu5onToanvm3glM?=
 =?us-ascii?Q?zDuliSe1vnlvXq6LaDjQxGR9LZD57FsfLp9GO09Cp1nRXvaxVuRegsYDT2G9?=
 =?us-ascii?Q?crGTxP+UW65V8X0h/58AZZ8c7aoPdtxHR5aIf9Z2LVCXSvW/PP94jDGObDsj?=
 =?us-ascii?Q?cx10/TPEaq/4pr8JPHufa7AAV0ifD7Zsl0AFEf58VXIy1/ddZg9p0hPhvshD?=
 =?us-ascii?Q?6ju4J9yeI0Zh8+fZ/8Kk7FYPFtfWuKipSKUX+RmJBCkDR+vLTqPC6hb/BTBB?=
 =?us-ascii?Q?39KJXG4AKjEcu/67hq8U/dOSQVnOiSaBKY4CL0eKPfQHAR3/XZsJxW4VcBVy?=
 =?us-ascii?Q?5J/Ki7hIp0aG6Nia6vNyNeYiisQb0DTGIb7gURuPjEVXPZi5wDMscSdTezwX?=
 =?us-ascii?Q?QwgB4oFm/jWd9YdT4HZwZYfx56oEeSfLbXEQH6p70FLAOsPr6vOVV0F3ymoM?=
 =?us-ascii?Q?sNpU9xl9rS1UAUHE/0RPWRXXA9uBTmLTRoXXRVq0yrNI83v1BrwaXHSGPtxv?=
 =?us-ascii?Q?ba4laXxGUo63Phuf0tYsxalt3R7hfGgiT5J7nGd90dAo6RMme5nDrB/E1DPj?=
 =?us-ascii?Q?m6gVbDqy7INREV3Ui6Vk1CHZ7tPjtl4=3D?=
X-Exchange-RoutingPolicyChecked:
	B8SEoDiBMp3U/YSD4zFcA38WbP37CW6Jq1m4eAhZ3xLi1XnZkOVwDTGKWrLPH/t0mekDymK5tzC07mbeY8Md2R8lyzM3FZAUz/B+GXcwdzqZnIoS8AJXsyNpYbSTLUWBJfrSwyXGajRyqOFiVX6UHEm+6io4vKE0QZRo64tIwVfGK2Vmb0Im7i68wYB20ScXxvtQLVosXdz24dVd7yXZFwhBVO7KWcrevPRxHFUcAQkumjtuTwhsywHgtlKOAgl5G126biNAPcBylvXl+qY2kC0zYrwJttzOJ+bIW7MHoOB0TAP9ci87s2vLESo+1Xty4EcmaNI/6Z5M/IH44fwu6A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sNXi9CSFbFNpyaJ/vWpCL4i41bjkW2MyU8KM9+sY1QOp8RlGYard9v6CzHbbtxSh6BGfhtpPyZaAcvmySHRrDh+JsRiOKExZREICKyMqa1JuUhMmjP8FteWhJjLThsTwwgNebmaS8XnURjQPVkb5zxc5DlYB8pUsjbiCJyn8DixmXjWK3MekobqYyYFblP3XH1kE1Bc7R0YdKB+q4dRufH61p6GpiELDbH1FUJugfCrItspTq564bTj2VMVBPSqGoBtw8iHOn7KWm6orHKYE1IJTTlXl8cIlBptrU/bxYOYfTUAsxbWGw6hF9DgY4Ltt0ftVyIxjX3cpidSIOFMO1bjdJc+DbvIaTUB0rfDuCxM94VB4HR9ZNsi4O2v782lMTyHCroGLOEuL1uY/Py5zUjRu667xH3J+/5Kxb4IGlmSVn9Zivmd4T36kLdAZi83wzTf0xI57aKnYhZv1v7qw3ddk/6WF57IHGpl/J8cA0GDkhdbgBwLRYjkAfXrqZMqXEQ8BO0WwQ0/l9hlH3Va4NRnHBjSRpRAMq6DFPEYOYmyX9QvFvOaHJQOQvkmAYwi4Ap/Vh0Yux1yQ6ysKySVags+kJMram8+LRwAgh4ZBBw8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6339067-af53-4109-776a-08ded8eeb086
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:41.2400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cb2OWmwW1CkZZV+PvxZG1ukL3DURFbYFvvxo6ckj1Ayk+zhAMmGYMddehkVo/vzbtpIpQYK7TzU/Az3rsoogRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXwF8mxSf2jVEG
 LjPkB/f5tzkl6FhaG+mvJHgYkzgDY6943C5CInM8IM7xcXARo50PdbdbDc/Bb2RMSBYj3PsxFhc
 Lq7rdyrC0kBqh6CJZqzQqn5Yi18FfnQ8fLDOiY/UpH+tPZKJUsig
X-Proofpoint-GUID: _LdYvIGqShOVGb7bInSErHQEvPTztHeb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX2GUfLj+C3WGb
 /Izw2qdmOEOIja0HngLVT+gdsoAchmb3cOt92x9EluIJVrf6NX7fi2ItxV8q6f+wcR9Ay1gP3Dc
 +dVJp9HWFQSuhD1N91sB3YAK02YnpSbSVWe6AgCjD/IKGkJus2+RzONv6f9a+5DiKybZWIam4mH
 0254lsS8aAPOuT/R+efhC6ZXR3Avl2hq8bxLNU0zamgyk22YLzPflEAuNEwKgUBH3uBO+9XXA1H
 FhPAYset/Od42EX0Coz6O09ahlZgoFPsSsdGXfI3XRxAh28d4995fDIll540ONDtMxzIDcem5aA
 20/dJ8ZtBSBHuz7u7vqoqtY5K1RtBO71z1HEn9hX2YzDJEs4sd8MTqOyGU9FWzWHKcselC/NmM8
 7L4Kh8Ex3ngmP3c26IkoRO2Jeb6PIgzYlCMHF99BMx9xySXA+/KFF55UBTO0nOotiAK2BZjwlR1
 EzFI2HoH3Ds+ozHsaqA==
X-Proofpoint-ORIG-GUID: _LdYvIGqShOVGb7bInSErHQEvPTztHeb
X-Authority-Analysis: v=2.4 cv=D5N37PRj c=1 sm=1 tr=0 ts=6a479048 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=KFrTxiSEMK9J-XJLMaMA:9

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occuring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0f3f3f9fa5fae..f22e3677cf2ad 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -242,11 +242,44 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static inline void bio_list_add_clone(struct bio_list *bl,
+				struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+	bl->tail = master_bio;
+	bio_put(clone);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
 	master_bio->bi_status = clone->bi_status;
+
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct block_device *bi_bdev = clone->bi_bdev;
+		struct request_queue *q = bi_bdev->bd_queue;
+		struct scsi_device *sdev = scsi_device_from_queue(q);
+		struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+		struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+		struct mpath_head *mpath_head = mpath_device->mpath_head;
+		unsigned long flags;
+
+		scsi_mpath_dev_clear_path(scsi_mpath_dev);
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add_clone(&mpath_head->requeue_list, clone);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+
+		mpath_schedule_requeue_work(mpath_head);
+		return;
+	}
+
 	bio_put(clone);
 	bio_endio(master_bio);
 }
-- 
2.43.7

