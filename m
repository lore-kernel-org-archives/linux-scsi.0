Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168F1A23A4;
	Fri, 25 Jul 2025 01:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406536; cv=fail; b=McEd30+WrKUuo10vWERvP4gqZne1476xTTl+sBpvwHvjzFPlv6LGXzMHKULbMXwEPPLNNzPMZe8V+L/Xja25ZOgalhK0D2BWdk06UrkW1Z2dK272w23fC8J2/r2ieYK8ohNEOmInmcXqJZIAJpsFjWx71eX5dD6cePExossiGzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406536; c=relaxed/simple;
	bh=XyATyq9Cj7u+hnKYMyGZ1fLMKGw9XwJ8yCQ8KAz5LAc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RjFiPp6mm64WqHPsZBzNM0ndAUe1kKKBxmKz6JZ5U3DtglRVpB8fQR4CHdKudH6moDKRW7RcBqXj1krBUiL1ou7ymqDjAxFq9ccBRcMoQykk3yeJmhkMW0SUXCVkgLi5BSSI7flwq+j0DKLsdIUtTsyz49LYNy1aka8AHqo/ejc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CUTB/3gt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ERJKxD9w; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CUTB/3gt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ERJKxD9w"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLkFLm011975;
	Fri, 25 Jul 2025 01:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bqGhykcE+IIzfRQnVR
	d3urMUHQb0MTouLDQPQGG5nmk=; b=CUTB/3gt0uFqTnoi7deFtZGBtlkO3C8+ck
	sOlL6wIWcVz1sLGk2lI6SblR1djVz79Z3wY3+MT7RlH+9R00Jp1yfhT/Rg7ZuNrS
	IoalD2i9YU+qnWT2swPXfInYnEGeyaV7a7EAoAY7qApUeZG9yQQSLrp8h/A8S0++
	myyriJpbB2RVhzGkprta/u8n26ff+5Y6zoUX9x0fm6QXT+o2cg0abwDpRsRs03Lf
	QsMdIqQZ3ETXYCIIBCsGN+TTdzAyHk6YnkwoKZ+VQHHl2ujIZ+dtzYK03wgL885V
	v2KN4PuQnym/38SR4FIJdDLgXAr1oYNOKAK9MsHNpf2gZncWveIA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k8644-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:21:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56ON1JMY011306;
	Fri, 25 Jul 2025 01:21:48 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcfpyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:21:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QbnGWj3r/n42RhgoYphyuKz/Hi6oGouWYYwYpioFCT2qWdWntvV/E1uFksQZEF/2vxIUYXNrTHwzPFXJySiDAPXN5Iu7MaKbucwILrr64xT+tL+VSIYs7AKeUV7Ibd0klUU6kv3Fqu7jJMxugNDfLrBEBORsSFGEYNlx5RUUKbhJEyZgSBXvAt81X8tudElFbQNsjymWCRSeJV8f/YnosIO72ShRhbB5dA/QnRu7NR8v6+dbRPYEGeI98cACjM49fKI+BayIo8AZY7lwAfOIUibC2sl+hspKU1tkXamcKhn3KFzAj0GyysJib1g3ibFaRoSckIoXGX9SzR84exN6Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqGhykcE+IIzfRQnVRd3urMUHQb0MTouLDQPQGG5nmk=;
 b=XlXPXhtrrB8OvnYdYgqWDYL6uTQUyYY6hda6Q0UAV5xLOujkyMjxf6uHF5s32RHmyYkEQUEaEWBQZoQ/IRSJIEpVV3Kq+Npv7l61f8JF0sp/nNoBtwV9uh5BrbT7PS9u1vCOVa+lc4wNGeaFJvNIHt8dsVgZFPWmY2rNcVNyaenXORS0Bfph/6wg8PmfN6jSGG6wXW2Bba3SnWofOUGuyFqd+WJxqoHX2jyZgsyFDSjT+dHkAEIAeaUIKyfYt8VBTQWBFZEQkPQys0YsJMjxDudlwMR/cb+35LVCvGeO3gBzIRHVqIrel9t5qZv0LDb4EEvY354f8HHZcmAnqk+OOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqGhykcE+IIzfRQnVRd3urMUHQb0MTouLDQPQGG5nmk=;
 b=ERJKxD9wN/13yZY1CzLRXxql2X9CwtooUIvLbnjncoCnwSilGZwrXQJO4reDnnNQX8pWOA9mISLkKzgLMTMjULrvzkv4fd7MFjvb0+eVd0iprVpkhdwNcdbl4Ixot1rgC/UezceMLfYr+rcjdaN/RwHAVcci41HOXKe3abQpNLY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 01:21:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:21:44 +0000
To: Li Lingfeng <lilingfeng3@huawei.com>
Cc: <lduncan@suse.com>, <cleech@redhat.com>, <njavali@marvell.com>,
        <mrangankar@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <James.Bottomley@HansenPartnership.com>, <michael.christie@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yukuai1@huaweicloud.com>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
        <chengzhihao1@huawei.com>, <lilingfeng@huaweicloud.com>
Subject: Re: [PATCH] Revert "scsi: iscsi: Fix HW conn removal use after free"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250715073926.3529456-1-lilingfeng3@huawei.com> (Li Lingfeng's
	message of "Tue, 15 Jul 2025 15:39:26 +0800")
Organization: Oracle Corporation
Message-ID: <yq1seilrrp8.fsf@ca-mkp.ca.oracle.com>
References: <20250715073926.3529456-1-lilingfeng3@huawei.com>
Date: Thu, 24 Jul 2025 21:21:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: 59ac2af8-bf8e-4d09-5048-08ddcb199e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SlSkmdMBl7pXN5pS8lBE7qe9n9WtHTZjQc4HCPkky/Nl6KSuibi1RUixwLvH?=
 =?us-ascii?Q?J4OFPJWKT6cmoLwpWc1EC9lYb6HplulPHpg1cbHPb2dQeXOxalSp2GBPxAkW?=
 =?us-ascii?Q?y+Xag0qw5w+Sl6h5rfOprL02KmBPDSGrtSWlU2izCAlfx07WFsl4ifHZUqcQ?=
 =?us-ascii?Q?8h+E5DKpyICS6YKLI0c9SF0HsQ6+ULvTpoSbihi2EE5ln7kZQRCFVtlaOVcL?=
 =?us-ascii?Q?rcYqKPEHtotTMuolqgxb337w7XRzejvyI0LbeEniIhhpNxiMd0JTN2W5eVa1?=
 =?us-ascii?Q?Ix8EhfA3uTBcZ7o3p6mO82HotkJyWYKA/fC8Pt1BIgI1aqpazKcdoKXKlEj+?=
 =?us-ascii?Q?nZpl0989ClbsUgZs1BT5WJc30SgVmGbVpDPIffzJw38MBQ827DGjJSb9mcd2?=
 =?us-ascii?Q?mlJy8InpWcfusRY+OUplRLhaN9sjB4/HeXhPfU2ypRsDjlmt3hRxFKcVVvYm?=
 =?us-ascii?Q?moukt75R9PtmF98g7tn3HW74ekJ91MwNUM3fumYG/J4ZZtBBlEfZCX+p3jZL?=
 =?us-ascii?Q?tbZUTEmb4mHk/WZt0snhXKK4mQ6muxnKTj07uUZDlwAs68qyMLGHqUawrvrT?=
 =?us-ascii?Q?1Ioj5W7NYQH6/IldF7cVAKHcE24qaHEvaq3aRyPSFPk2bFkerWnm9aK2E36f?=
 =?us-ascii?Q?pFunUoJm81pxx8eWhk8TdiY888qHWsBQHxFy2Zm8VJH3IUVsrGEPBiH/HiRq?=
 =?us-ascii?Q?rxQ0pP6KD1zlADwLB6+4kdzmC9wWgkNeb7oJAJOo1/dGgJc8yaJruZQGCzs8?=
 =?us-ascii?Q?JqPU42WEPwIiqwRT6AZYuXVK/UMAR0pJP/bxcdWYngQ/FGFLUDqhUgtNhmpv?=
 =?us-ascii?Q?JmMrARbQDxbo/PdDfTTiptpykAHU7csDCHlO+KoL7pCeP5qc0whoH6utcKN9?=
 =?us-ascii?Q?Ujmbr6tnERyQVobwWuEjH5ELHZbHKdZ2D7kBtBqNoNg2sr3XXynOJsqw+R4k?=
 =?us-ascii?Q?neGNPb9fhBIj5ovHp2KT7bf2nsU4QnBRpZ1/RcXZfpYIfSD4motpQaJoJgar?=
 =?us-ascii?Q?b785cz4bgChVGuF1rfzTeAi3mN8ph8onz6Kj9aeoljc5GVDwg5wJGhbLUGCr?=
 =?us-ascii?Q?6zaVpuOCeevUsug00w1Z2JmdLoVW0X+aJBnkjo5jgw4zN8dtE4g9crg+OFPD?=
 =?us-ascii?Q?kldUx4yEnAxUsAx7RLKTjy66/vSs86hQbIt2P8wPVgksMzJb2fjpkqohBPDy?=
 =?us-ascii?Q?oGIUokS87juS+S9gBNcdyA5aQG4bESu3sEcIo3w+G0PodfpqS4ZNvHSECSvR?=
 =?us-ascii?Q?cHPdAzfGOVqLkyN6QAQntzJOd+tSiqI2Tx/qFq/Cjetu6w+BfOXeu2Gumbkd?=
 =?us-ascii?Q?xVvK+Xt3je6C9vPcjOYuf7JnBVYMLmvtSrasSLCYCEbDgwkUZKJSKcVJ692N?=
 =?us-ascii?Q?76afp+ApNfFeDSGhrGIMn3P/Pj9Tknfej4UWpEy4DM+9Pj+SaCr6Zh+MgQVt?=
 =?us-ascii?Q?lnARJ+zwWWI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3dK919fIMoDPpzfLtLoPX2ArJ8fRWLXNUn+urvjgwZGRZhQYalECSUg+HowD?=
 =?us-ascii?Q?hu4vMqd5irgQUvs2UK/6IMwGdaqlWayKJ34iHmIhPRcoYJmOsp2yszyjpGrs?=
 =?us-ascii?Q?ADHwWGlw/UJkeme/r3KUO0nFVGeD0pJcb1ViVrhb409EqRupeb9chKnVs+sO?=
 =?us-ascii?Q?ts+kpuVPeFEQKbEmn0xbZwMks/oT5rVA22bYqUIFzjWHGYzE3K4rfOliBwXl?=
 =?us-ascii?Q?t/wzsTzHYDxOE8c1ASYVJjKuLP+NlpzlIzqPh9ZpcXR8c4nSlgE6PB6Thl/K?=
 =?us-ascii?Q?gHMN8+ST5T7NHFrkmNZCBWwecm4gal8/6tXCHTaz63DM3wj//nX9b4WTr9eP?=
 =?us-ascii?Q?lFU6lYKnbDk1hKF2FMZkVa9vbQ6WNA33VSecv/ujWmkddfjCkTrRqcaapEk+?=
 =?us-ascii?Q?DEt3Ci0DaFSMV44YQ7B+LoH3aFg1obVByUrsgJiPZdVHfab5l/J3IUdF43PI?=
 =?us-ascii?Q?zHOs+f9c3KVE6bI3ucl2hcpqPUgJup79WXLomj6MQy19FiJrHcM9UfcZY1Lq?=
 =?us-ascii?Q?6lNL4e/YTSgNkqgL7MAayg/G93rXebd1Qkgk3sLLMgYXynPWqPxS760aGVzy?=
 =?us-ascii?Q?YwAyuxVrd+FKE9Xo/S9gGwHrJygWH+XuI/o6Z/jW4pvWd8koWGu0ZDyFfyyi?=
 =?us-ascii?Q?lzlbwSqwykP8+5Gyq/JHHLihQODXUY1XCngKfa1KSV+35v7bFxISU0Cw54Vn?=
 =?us-ascii?Q?vNZiDMzJDAsl3f9Fwd3oQIyECq0V1uiBbig94fHU6Q0MfUfkb2ulFSpdlxIn?=
 =?us-ascii?Q?rUIHVzOTsyJqZwUg7Q/INLZoJyvS4Mr3V4REjNC6OvcBQg+4HqNPfid8P6mi?=
 =?us-ascii?Q?jmYviLUSglZJg+/hpo5yXKU5tKi1XyPF/SJ/m5F1dRz6eRHKwwyWfs8Y0vnI?=
 =?us-ascii?Q?XQ9bYqZAlI902CdrQPZ89vLZem2zxWcK/8p9msR2pVjlSWibcfDAak5qq+bM?=
 =?us-ascii?Q?+zLZqLfTyK0sLhMh/1kZVD50Rpj59/0wwSEB9rX6azwzI2CBpQOsmGUIJQZZ?=
 =?us-ascii?Q?L9fJS6fA2FeN4pE+0m93jAfwVEUl5eQMI6nRJHlYIsGba06YuU0S1HwnOGOI?=
 =?us-ascii?Q?KmVhcvzLgrVV8Ot8JwH+afIk75EVa1soe6XfAuRzgFpTu2njrHzn+JbjgBbP?=
 =?us-ascii?Q?0Faq8XXWFVfDb9SY98YyZWFYg1Ug0JcFBLEpJwSE+ZImiPouSAILfReUDEd1?=
 =?us-ascii?Q?vAvmELx92a/Z4c6D555vEgU+btbSWRr8BYNm/dGsy6+9vRSN8/p/rMmh88x9?=
 =?us-ascii?Q?FGFKV2vLhKB0083MEnC63GojwyEKEWgDAMMihAZ2Xb2IppOVmb1xPhcuehzF?=
 =?us-ascii?Q?w/T3EYE5WHKKRzMeTWRRiaNYCCMZAbHAXPQfm+b7WOcdB59MOuFENSRrqIR9?=
 =?us-ascii?Q?V/0UKbDH19/SEfYSypIkYngfGkuno4Cc3wMspAlGg2FrQSLqLAOhfg0IehQI?=
 =?us-ascii?Q?cMbi/h02ySwpEECq/LhB92E0LTvm8O1G+rrRT+uVdAoz5QlWvDTVdEWOFaCX?=
 =?us-ascii?Q?Tu4LN9iBBxfVT84B1nfHSI9Tjw6vlmsWWHQ6wgFeK+7xuiK0qrzGQLg1AHhf?=
 =?us-ascii?Q?NgoNOL21Jf5d/cqjVvGS5q+s9J9mbrXWN6rH2hoXuckCUlwOBSfuu7vdj4eo?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wHPzPDbb7Yk9j6tubgrG6BPhEgkxBKfcLf5Y6rsM3SFObcGQ6ZSy1qIxjTxgsWgGsFDfshen14ZiSX0R+ciIKd9Fbdo0q2NJkjdMnyqIzojym2iizT3TriEbK/pi0YuqWMXXdiOsG/5ubwBrnuRVnRShbRqxMnNHBY96wbRZy6XSzsX3gkZgyULaVGVGfgffUohESw4jCBQPB+QyN5ZlQWAkgtRyXxlWN7XOyQnLymCU7bks0E/gl4PpXgTBvtd7pB/ds3jcgc0hLTpN4vy3fkfLgCeaLG/Q5HED0PZo2E8AY/0gXYLvRvCSlZ96WYxfXFHFl81fkd2JEIMXM4ixRKEiQjQuWxv/t9LKTBt7ZvOW6GHTup4CLr0V8PWXNfZZkQcjzBdSEPm8IJZbFopuDMnaQlZbJ4qM64a124PtzH8zBr8U0HLQMDYSgNgSJ22UIrLkGxsh6KB1XGFOiCnvhtADobGmxifbBDSSLY7b4HFUW0cqqrs17O/QF8cKIufAlaZ7zSHV5U05eVGB0lNnQvjruL+olF67aKEmHzBk+mOyrjabPW79t+LXOpwrr60q4rCOqcZGtZyJHO1TCuc4uzpX64IOc7NjX3FO6DTAU2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ac2af8-bf8e-4d09-5048-08ddcb199e46
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:21:44.7665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWAbpTxqbLcAYeontsL36eHldb7HGuxrqaeedn/5G4wB8ahgK+vr03kZwgdl6C4UNh/n07gOmv/fDny/jLjSwENsdcyLR/A6wIkLqIQ5C5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=824 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250009
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAwOSBTYWx0ZWRfX9FuwiNSePcCG
 BIkj+QhAf2eK/ImozNO4pRPge/ZBNb25naF7wM4+2f1qMiW1WgdZm4O2QVs0SSjCDoqSijHDG3X
 xLseRMcpZySYwio67okwHRZwDMhkaitxTxJIFURbROUfAUP97i7xkRFG2QR1Z59TorsDKlxgS3O
 +j/SmCD/7K3skLZAhyFJupyrGa6Zzku8TYWWb6DAtzVFjpWO4pJLYNo9cbEZG5zUsfCOQ18oZPV
 1WdfGVJfKwObmdOwn5uXi47YXqyKXMXR44IujT4fckZmcJGkrJHb3LN2tWSvO8BOE+rUNhvAaMY
 h5OL8I6Vd/RAlB6t+q8n60i2oKa1nibAvPXfum/vip6i2+EhicmlaD7ciOWvt5ujb56fAUP6gth
 s0Q3soNwys6DwKdSdp18M7eMN+TgrD5GR2m757/yyZLQXfmNMINGxCclSts83biWA/XcptbQ
X-Proofpoint-ORIG-GUID: j9WtdZYeAwpTGPh-QYYqkkhpnkv6pSVw
X-Proofpoint-GUID: j9WtdZYeAwpTGPh-QYYqkkhpnkv6pSVw
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=6882dc2d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9


Li,

> This reverts commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
