Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0844A3BB69D;
	Fri,  3 Jul 2026 10:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074679; cv=fail; b=eMRMejOmVj6lKCMlkLkIV7JmKtzn5qESUjgAyrdfqtzLhGQlzKMAs6cPooHqyPJOHY1qirzPy1PoJa1TNVgItMrhwhezSBwyqw+VGVXb0JJ7uk3t5KCIzFq/1KqBQGRMTiqfP3JR7/ytY6PvzmAnndZfXULufweicdMDtdDLRQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074679; c=relaxed/simple;
	bh=XxhHeqP3iZF7WSHV27fKzQUoLKLrldAcBQ8b47YU/uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fHIua0GqYvJs2cDjOiWyRCJKCtVxplBO2M+S0rbxpmVCQDEgiWDH6glIiqo4lFQGtAo15qMLvfDG/YAznwPwoCXUcqnjr7vtfc7wMKEcPQuBypqcXlwTRqaCzrq6vDzDVFj//A5ntZRtgc6CTZKL/6ulyXH90pVXpHTD6Z1tIcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cVexWVQP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SGN08Gwt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cVexWVQP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SGN08Gwt"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638uHD53340011;
	Fri, 3 Jul 2026 10:31:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qnecqqod5iuBsaFpmR3gyT/cdAyvMKtMEuScrPVmYHw=; b=
	cVexWVQPBK0Sf3TfIEJZIpXqgGzn9/qsUbNbcj01qMb81Q+LGUffDbTSIjPuAKLD
	KV47nhemqCR4v486TdI9Ee0YAtjvIjevFTR/AhuTRrKdrXaUtb5XUoLNMD7MTWp7
	vbYFDlWvBqYXlx/nv8kCqg593XR666Gkl8tZsGihkbvl45xnwIrd7c9VPzOIv7mQ
	nReEBstOxEzm1Tw811iql0CxpKsryGT6xpBbMFk9lV8tRMLDOEe9yFSIDaX3sMcM
	umCeNHlMsCsVm2paozxKubZ/FeSb3inwTWQHFLXMDH5MGaiAvvsg/uFmOXHrZZzL
	XRzxL5u8yyTm0KUC4Pjdyw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p8tk68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS8xd033859;
	Fri, 3 Jul 2026 10:31:01 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhyqqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fLlrQ5JIOEXgzVv/DUP0mJe7fOExKY8i1yiVfsi+0C+2OzVKGxNMgQ3qjRuwoeAVwQyXG3LK7xntWHWdwEQcF7vs+7fp0T2a6GNFqqUvtmQsUQeTpOqXnqhZP5MlHdT/s9HQqBr7U++5mWKqGAjgpsaFGI/Iid/FKNyZ8pXqq0d4iKQzNT+AktwenryOKc4IOQq6T4T+k8qvzZcggBddoCfzYaEHOzIhdTlFQbl34oqC8NfXpFxmCn+PXe+7ttQtK1pTFQSQesvvQcS4NRlTK+4VtHG081lzC+LB//ZCSAoS5xzKIO4OHyeAVPxCzGO3HFMIEhvSBG2eijkL9Ug3Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnecqqod5iuBsaFpmR3gyT/cdAyvMKtMEuScrPVmYHw=;
 b=E/51uR8VZ283KuF2aJ+tHbpLkA+Yvy75i+b0lTJE8WM9hZPOTgs+oCs7Oh3wgApZ9Ov6Pd31rFCuTKmyMT4ec/r/6LN7pOQN/wBnt9wifUj7UiW2t440l6giLkHw8/m4/pk5PIUYAB1NPwEIrCkQqKQwxekk1VWHHT9DHQEkLbYGptOEx/RxX6cyCJFPtR2hCPcghXvA8wFvLsFspQ5J3SjVta9POar5LFJsvVgHIKBMxPeKqrx7ycrCNHyr2RaQD28n3UKW4MLoXexgpqeUVBbf3hYVm/r5MaxJR+y2HCfav+BDMWTP4SOeWRwYsTW3tNsuyzlH/6PCjBbCbBCtIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnecqqod5iuBsaFpmR3gyT/cdAyvMKtMEuScrPVmYHw=;
 b=SGN08Gwtgs32fFbUUOBphI8O266sU4LoY3RIWbiagU5DPMNKeMsgw9ramsJn2TFqAn7zx+IuqMdvkV1j1L5jF8CS2Ng5pkNNMjXv7OtstBpkqdnkUNiGcDi5UXl5MjrwxLuXosTPS5qwqYY+zHDvxNnRweVbrCI4KLz9YAMLT0A=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:30:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 08/13] libmultipath: Add sysfs helpers
Date: Fri,  3 Jul 2026 10:29:13 +0000
Message-ID: <20260703102918.3723667-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:610:11a::24) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ba62712-c5ec-4d58-155f-08ded8ee2b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HNnUb3eWcG7x38vV92JD9mdlsgn3ITh2br9N6vhVrd5FmCRhJ08xi1PMOTTSG41T6qDb7mzdlb38JYvAAadXvzxlWeYPnv0WDDDVYimg6Hpdf5VsZbsqHSrtAwDjtt2qN/tYrM06GdgkMkvKPGuVCu2XIRd1puciNjvoSlsCTn8oCKmZs5wNiRUzg8zKG2/bqg1TbU8IP3vk5WAruMgqLdxvWOV35eDTBgAKQB1gXE+9CyxvdUkQePxzPOR1oIGiHtmuLwhXkG9iKo8111ZhEXAOnSUJ1V4UTfk9sQnQN36YtfBpoRsjJF/TLlyM0D44y/wcJcBoeGLpsPgnphUetSk6tNG+ZovYmmaLNGcb+wwkGgJicWWUgwI2eWCab1KzUDsrt4N2+ijKvI/A+y7UPbCW/AFqvwdBPAAlGzdJ2rlU8DySUo6+C3XalPqPcXJ04P97ks21DJUe6ZSl7wesKXz5VJomUgZVEJyxQv/I6h1xDLU0I2b9nZcgm1PKhSLLmHCb6oRR1GImZC8SHPxeZM06AHQ26hk6OvSJwwn9gb6fwgkxgefhAPzkY0kndqXy6hqPUqS6yaVPK3AdeHGZws/VulZLS3ZLqNGPQzU1unIc3M45ie2NBwMrjbIUwfgUog//e33rPBFZLd+38wynqBQR9F1Ych7lj4Uf4YwgQ8g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DSub5zepgP5Xr7u6fOWckpSbrUqqWzetHLOeoloJUEtUMVTMNVwdCTR9S72n?=
 =?us-ascii?Q?ursy+lDC8ppmzLaF5Wj62PLq2OJ86JwVj7YipGQor79yD0laqBZ9BcZYTzsf?=
 =?us-ascii?Q?yAdi4vULi4euBGX2LYuBU6k6kv3by7UzzgJhyiQDQKsIldWRFCahguHD/RvC?=
 =?us-ascii?Q?e1Z7Bx6lcYLnMpqMRy6cwsXpcbg4ImRLNccFIuuQdE+Gmokn+NVUgAH6wUOR?=
 =?us-ascii?Q?hY1NEPhAb0eDWFLproS/ZF+BEEy6+lSeaUlj75lJgdN8lqwEN10sw+F+bIjS?=
 =?us-ascii?Q?1SQabgDAl4hA0wdIf/j/IPxMlP3REiq4+AMvrynvlVlny68YDbyC3vYMrQyY?=
 =?us-ascii?Q?ZCqjkJDz3v7nG0mVlGFb/DK9d2LcahfwNQbr/1/AKSC1RP59w932iJ9gAgTB?=
 =?us-ascii?Q?4ssTVgfXvQiCoOb059pmFbvqKrTWZSjxSoztH0CjnXzVbwVuehpPgqAjkvSP?=
 =?us-ascii?Q?w7+9JDSe1ZZ4Q1catqf4uxxzDKxV4lN9zOm49aPh+k7hX/M6jMBGLCGi3fLA?=
 =?us-ascii?Q?cPTSM97DUmRHK9D1HCHF2HQ1wYVk8/Bdlh9lZ8qXa4+kVIOWMFbGmFueqvpS?=
 =?us-ascii?Q?pFfq73IB+RtfkT7MJbf05UMoNCpSO4g+it47jXQup7woEuoKxWiwi8Srk2PH?=
 =?us-ascii?Q?jxKgxDuffqWqnlG52wi/5HJbdxDaWnnteXVjogtsXf6g5KJdrApPOMlFPPtt?=
 =?us-ascii?Q?t+T/Nwvl3Ztkop6C96pkbTEVEB/VNmPyhd0DmxZfDcCBog+J2sgJfo0kgQe0?=
 =?us-ascii?Q?h5oG7EbQfEvkXTG4N2KGi9y3Ulbnq4loLes+F2jeG3ziPQVYAiFS88ViTjYb?=
 =?us-ascii?Q?SM2Z6gyrRy8n2VkWxoFbSbcx6jNWDZOkHI47NEScTn0/WpUCrtmBflr8L3hA?=
 =?us-ascii?Q?CUnfLrrggJs7CJXnmAHmez3mi8kz7HbmYpr8Vj04iVVSIPy/sQbAwhbPN3Cd?=
 =?us-ascii?Q?exsedQwzQGuUHPzgFrCTfcCJY/iAzzTvj2sPMNCUGj+Eo5ZocDzeR83HNnCL?=
 =?us-ascii?Q?efiF/MsbVNCr84mXcQR+LhlcSAJHCFqKPegXcpnHts14iLZMQC6nrMdUfdMB?=
 =?us-ascii?Q?HxQpjyEZOn7xiF6+1FJPyi82iT+WxYo1wDWdmEEwWdkCFQfddUPGMSGv5PO0?=
 =?us-ascii?Q?b22PK2PLg8jUtv319I3fac60kdvDuverbYy7cwFU8/Mf+MI1SibHpPxbmb0f?=
 =?us-ascii?Q?yJn6yQT6xSjE8B7jNspPCf1ZNmPZSKcWsffpJpQQWHc42PwniT7HULugxrKE?=
 =?us-ascii?Q?5qGp/Qqv/2oTr7wLKVjVHhcw2qnKfUYZ9qRlNtdTrCHeyuA+bW6uGVXHQGQU?=
 =?us-ascii?Q?bTfXhEMAas6ZLYY+/EtHGr4NatXpFQnPSwFsq9OStNQGkN1lH0lUC1jb88Ec?=
 =?us-ascii?Q?Mfdq463MrlWMUSmWfX8FjeUPpqKil896uwmHsZrW2z1XnJFrGSWpL2EzCRUq?=
 =?us-ascii?Q?+gNM6vU6K4LALHYfkAifYHsU/uiGcx8nZpgX9t35ns37Af/QCOISwHvgIoPJ?=
 =?us-ascii?Q?fHltiAnEcRTLru84WNUlRF/SNUOu8/5Kns5XMJI0XOScqm1ybgn3bN0ZV1ab?=
 =?us-ascii?Q?kRdiQUwi/CPMeg9DDlivuwIYYWwx8Zv7Kiy7E1jSMdZciujdIYaMKSpeAOwv?=
 =?us-ascii?Q?b/au7LqmD0Js1mVbzfHuqGQgvRv2PigzTF1wcVAAsdHT4iIyU+NnBqgq5urR?=
 =?us-ascii?Q?JdOp0VPoNTqIN0nOooLRwwqi+VF4XVuNlTe/ifH8dB54xaaDx0rBbhYYAUQa?=
 =?us-ascii?Q?eavYS94ZD39nOlRmHuxo3yU0MOV+UyY=3D?=
X-Exchange-RoutingPolicyChecked:
	cwLfuDF2HHM972A3YWKlNRnQ8hqLMHs+wwsi3nJabvXdJApJmZCuEaBjaduacfJC+IVAhzIoVS7YVWT0Rix4tngOA7AYtdH0yJ5inV4i64U996FvN6Ecf96TFO4fDAJjrD35ahCDaw6rataFewzvZst3VeVBk/5FyJWPzUh2qEs4FbpWYRxgJPwOqss05AHj4JBcfqxCfywV8P2nmchoKnrrio1Kg0UlVozvU55EA9dnUnMmjSCJwNXQcsLWVvJg4QSNuzR8nf8O60cFnD73mKi4DCotWNUFrAlOjYXG+Ob/4v8OqSuKFFdN44iwNvU0zOz6iPIeOWMs/YjfrHHaEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IXVNJ6OYXl7LcXLS9egxvhu8RGL87zAgfwPofXWQnZ+nhyys3DTShExUvYm4rzClbhnpssTcwqVPjR6FvtV2KOiHe5AwjQqpo/Ni8LZuzwLgMzy05DdzqL7VJ7Lmj3Z383ZP4dKDo8kyJj6TNIdN61NWNwFEyg6i8eXE5E9ZTNgex5FRlrrojPm1EkQEhqhPNMeKC7hrT6ajrqmHtoCNRvAt4AEMFG70pi4jxcIHm3uJUS1a1jQopqESSNbBta6CtZRQBS47pq20P6XauZKygJvdEtz0NXwIIkA3oXpetXoSo106g1J5T/b2urFfFlaeSumGlmSHY9/AptBbdbfFUOO0sNADIb5Sw4E42JLkx5cDFtoFgqOfaDCLY+P78fJ+dKQkU4XkyfcyEidMHoYGPBnguguP7K1ksGpr7g3KdnJSu3e6bKkeQSkNhrTobWhctnHQnAftTb+XKnKxN/cbu96xr2JaXzFSh5pGRnkXfHe/DjwEyX0wwIAQK+Uda2/bsgrryzrTKWO4nNacsQfmkj9l5HnBIbOZKEYSYD07WDTv9TlSoS9z4TMRE6GSvCtsVkgz5dJ0sehV2dpu0oQJjSc7d4YVQJHNe1/o6CZNc6k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba62712-c5ec-4d58-155f-08ded8ee2b86
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:58.0237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+kj9Arw06VVpFlN/bEzWbFg7PQpjuzTBeQFSTV2Ok6hGyeB/ifS8dLTfeGMYZ9qq4jkiUKGyY9PUaJgy68b/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX5kL6El8wt+zs
 R3CMFaSmMPRVMGCFVJ5K//OaN2zoqSfAEHOFlItvzA5h5fmZszAfl/P63kBeH6GTuvtsUFfXLAa
 Ov2kqE9LgcZqrbvtqZfqg7G8NkfVURgr6jKGay35kkfQX+k6kCfk
X-Proofpoint-GUID: CdJK-VlgfhGNRH1AolI8iQ-XGLdDo7BG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX0An3o3uJet34
 dFSjJLXmCDlV/YxIn8kwsxhGAJPFnLj/jlvyHYsu4mgiw6r6uo05BgdAauoHRfoUm4olMGa+JHl
 IN3lPf1dhsUB2qH9imIwINqJRzsNKO12dOqGHnnkEKUmqEg1Mc5lPbu7Q35zLlAEGpWCEjsUovs
 tP6pKB2uXdHm5kvkfuajqxgZPjhLX4FGXQucTBawqzQyOeaL8maEwjijlE9F+cZv7Ha9pWXBd6H
 QM0JYij1TkvSapdI7I5QjsWzCpfOr7MMPpxI6Niw/R1S0O5e/g4CDLNOT9qPCuFaIQdMLSDjuFS
 gF5Ll6wxDVd59exyA5UUBty9oZlA2m87owQAfz+dbt/SIjTq/Q1fmI5Eajz/sOLlAyjPfp3MnGR
 h5RzNImlsnC5Nld2Z0hbrx25i2uagMINBIptdwibIBZY9Z3petF4U6ftZIkwSN83EcRmg2e+dWX
 G63F0+UyBU4JKFzUtcQ==
X-Proofpoint-ORIG-GUID: CdJK-VlgfhGNRH1AolI8iQ-XGLdDo7BG
X-Authority-Analysis: v=2.4 cv=D5N37PRj c=1 sm=1 tr=0 ts=6a478f66 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=JWw5DRbbQmmJTouRsXkA:9

Add helpers for driver sysfs code for the following functionality:
- get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
- show device path per NUMA node
- "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
- device groups attribute array, similar to nvme_ns_attr_groups but not
  containing NVMe members.

Note that mpath_iopolicy_store() has a update callback to allow same
functionality as nvme_subsys_iopolicy_update() be run for clearing paths.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  6 +++
 lib/multipath.c           | 95 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 044061de3ecb9..a335ea9885110 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -10,6 +10,8 @@
 
 extern const struct file_operations mpath_chr_fops;
 extern const struct block_device_operations mpath_ops;
+extern const struct attribute_group mpath_attr_group;
+extern const struct attribute_group *mpath_device_groups[];
 
 enum mpath_iopolicy_e {
 	MPATH_IOPOLICY_NUMA,
@@ -142,6 +144,10 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
 bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf);
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf);
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy,
+			const char *buf, size_t count);
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 			char *buf);
 ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
diff --git a/lib/multipath.c b/lib/multipath.c
index 6d2e1186a10f8..4945f2d847fbf 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -791,6 +791,101 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static bool multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return is_mpath_disk(disk);
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
+
+const struct attribute_group mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
+};
+EXPORT_SYMBOL_GPL(mpath_attr_group);
+
+const struct attribute_group *mpath_device_groups[] = {
+	&mpath_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(mpath_device_groups);
+
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+		mpath_iopolicy_names[READ_ONCE(*iopolicy)]);
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_show);
+
+static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
+		int new)
+{
+	int old = READ_ONCE(*iopolicy);
+
+	if (old == new)
+		return;
+
+	WRITE_ONCE(*iopolicy, new);
+
+	pr_info("iopolicy changed from %s to %s\n",
+		mpath_iopolicy_names[old],
+		mpath_iopolicy_names[new]);
+}
+
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy,
+				const char *buf, size_t count)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
+		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
+			mpath_iopolicy_update(iopolicy, i);
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_store);
+
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int node, srcu_idx;
+	nodemask_t numa_nodes;
+	struct mpath_device *current_mpath_dev;
+
+	if (mpath_read_iopolicy(mpath_head) != MPATH_IOPOLICY_NUMA)
+		return 0;
+
+	nodes_clear(numa_nodes);
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	for_each_node(node) {
+		current_mpath_dev =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+		if (current_mpath_dev == mpath_device)
+			node_set(node, numa_nodes);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&numa_nodes));
+}
+EXPORT_SYMBOL_GPL(mpath_numa_nodes_show);
+
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 					char *buf)
 {
-- 
2.43.7

