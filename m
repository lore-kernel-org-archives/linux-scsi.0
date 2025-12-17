Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2308925A322;
	Wed, 17 Dec 2025 02:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765939870; cv=fail; b=EerMVaNQ4bIdWWbwFB74Cu3rv573IFaMkCiKTjp0OTBSyP7pZdykjsuWm2gJUOfIwWaKCkmNnPCOlQe7/3qnKhJ81jax+TBZ07Dx8IxHJHNyi6YcwzpV0iQimTmNqrXqq40fV+hsj1sLLKCqgcSGBa6FFY+ggHpO/PNSRzFe8Pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765939870; c=relaxed/simple;
	bh=5/sMr9NzY28GHGAlnEbzyGAqxti8/wlZ6v6N3mN/ZEo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=saPp6CEqG2p9P3jN25Yv8ee7fwv5i8+vl/WjnWqe3OdtmUPJ+KntrfjqJPzbiy94M7Y6H5jzolc9T7t137wo239CfeIEnsEfokW+FXWuuPnwnpLBLyFnhlcXqOYqEit3NCg4IyhpjAMEg+nY5Z/hLCXBbxfEp1RBOcTJuC1i8oE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bc96Jq9B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vskS/pTP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bc96Jq9B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vskS/pTP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uJYw1588720;
	Wed, 17 Dec 2025 02:51:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nTaOYs8xHiJqRX08Yl
	fj0MRw6D5Hj54rkXvi/I7Bkb4=; b=bc96Jq9BXsIHz3cx/dU6GtiBUy2AgXZ+fn
	92EIz26U6vldAj6EAGNrTv1fTmODCV38ieyDKGRCQgtrcvUVoXdNcZEn8A0WE0+D
	+U/OI0RuTQJBBvK2T2REBvdFPYQjsGkJhy+/fiVvoDa/t7M7PP7gSkJXMQ+nQbbe
	FhkOTt1rUoGUFkBdDtRCfhE/uoOnsJAMhEDYl0Cyj7fX7l3vkmhRTz4uo2u3qHTg
	LjKhRlJ8lwjqLniQN+QrofG1i4lmwpuok2aosPYzVHFyghg3UB8R82bqZBDXSHp/
	p2f8sdBpgQxn8pe971d4CvCSU4SoGCUPBd92epAVw5NI46/UZYzg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2d3ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:51:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH07con005877;
	Wed, 17 Dec 2025 02:51:06 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xke0x9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMIqylYyt7G9sHKwN62U0P+RjViHByXtHB3BtBiycxJrrZ6RWrFxoMJtQdM8fWkyR26K3KZBdA2/OFcO8Cr0UyVn1I4zQdACv6fwPpeNkCodBP9WmY03wZCAhcj/cGzEvK0ySTcLM11suFFsn0Qfc5UzxfzQM/ZUkAVf/JI1sDAblQzDTpbq4v645iXEu+/F4fgeQFyeynupfEAaa8myULJvGVBfhk2toKzeJXFqb2CkKBu9g8GeH7qfSbN7x9153wU9z/w2NHnhJlAm/SSWvzqzyTXNyQox17PlW1GmPMqq9dk1wIaCWpJQBfkta0jNe1I0vwqZ9W4bBm/weFZ6Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTaOYs8xHiJqRX08Ylfj0MRw6D5Hj54rkXvi/I7Bkb4=;
 b=Lu9D+bjR0lgRSBxntWcrLbn0zwYZUNTghJvoyOX0ou+2W+zeq+wNa265XUmBvV3NnOsBG25YkaK1lt6bDFBPfp4XEHhkAeEohUM3jGJ5KPb1WqVr02GloVUygqR8vWNGzRt5DELUPBX1+X3de1GPIEuqRB5IDQBfHHALtDpH8Vf43ydj7UqtsDIupSl4kCC6kbNHz/CLmUAqkAvhUV4n6YR9pVOGqa8yiLXkp1DnBC7SY8fgu6lA7UD4UA1s4jMdz5KfSiQrrR54XkKy1cAgnacfoz717WutTKn8JeIMujigkHynlOiaEj6K16/3FSrD0sk2aopucn7KiPQMdG1RlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTaOYs8xHiJqRX08Ylfj0MRw6D5Hj54rkXvi/I7Bkb4=;
 b=vskS/pTPGcJT0Q2JwTbR/laP45jGgL0vZS/iP8RLR+lrtKhM0dfyMMooPg3M6p4FvSWFHHLtvTQDYIHf8OMZLqPOhr2dGwmTVC4ONTWXFMe8bkBtPhs7BrnJSEUxUI8l4Dh46jdrisstDy6IGjj2IhvOx/L3NjeGcaogY3faw30=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 02:51:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 02:51:02 +0000
To: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: lpfc: rework lpfc_sli4_fcf_rr_next_index_get()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251205235808.358258-1-yury.norov@gmail.com> (Yury Norov's
	message of "Fri, 5 Dec 2025 18:58:08 -0500")
Organization: Oracle Corporation
Message-ID: <yq1bjjx6ctt.fsf@ca-mkp.ca.oracle.com>
References: <20251205235808.358258-1-yury.norov@gmail.com>
Date: Tue, 16 Dec 2025 21:51:00 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0163.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf0b515-0fa7-4457-9cc2-08de3d171d68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KoXlkTDfBQR1LLDA5O2lxsadierd6Zs/57p3t2aps17kXt6Wu9oU385U5e5/?=
 =?us-ascii?Q?KwkqBt6er2Kzj8Kstw9evmuEyAVe1SJQgTOHnlCG4CvrbhoOECgO/0PKmmrW?=
 =?us-ascii?Q?qUmRLU+bRPLE/dA2QuMR+srDo29/sfmGdbd5J7lAhu8gz3K6yiSHWd5nNN76?=
 =?us-ascii?Q?BC9sllOw8bJ1dMLXf0lMsARS13JnZgfzEbbO4rxQOi7NpcVQRxIOTZTT4Mlr?=
 =?us-ascii?Q?Gj5O7CEEG1SshjUWktWi1i9EvHf78Hj7jArKI9MZ6HtNj3dIFLKJmJIYMxua?=
 =?us-ascii?Q?oABOFC9EFROUz78EXeHgVCOUVmpgRt0nq97i94cSqhn+LFaHBV88LEF7q82h?=
 =?us-ascii?Q?Oqoo6jQcxJQKTpSa8Zy7/BFTkJmHNg7HezX6/MszIAn2Ja8IE5JqtHLYeJ+s?=
 =?us-ascii?Q?0FVoLh1E0G3i0n6tDu/oCe8VJ5XaiuGdZYP3jgrB7ZPJyuOv92nFPynTyiQK?=
 =?us-ascii?Q?sa8YJ9f3bX/Jt+brhgVv1CNyxejGrGitv+1teEI6nIXk12DFtJfa5tNMV0cZ?=
 =?us-ascii?Q?decaNTAnukK65TprJwIgka1C2aFJLhyd5yeo+7n3UekfmCLHqwtvIkoC207A?=
 =?us-ascii?Q?/vnXcX1VfIwzGI9x1T0U/OuQ1jKzTPt+T7X9U6/JvIJHdtO+ZhiTbiqDTRfF?=
 =?us-ascii?Q?jPsrS6WP+WsAaSeFnKCwvSJ3ZXg/uskQvawqXHcw83qGLIyH34mSfUpGs1JB?=
 =?us-ascii?Q?y7MUf1NX0G1VHr2cHL5d8kf1FaX3MS7jnHDfr7LS8gZHf4ai0OQh7CR9zduZ?=
 =?us-ascii?Q?lPRFgarH5a65GhqJyWaq6qKZojfaSngmEbss/vbk+DrxjqyeSbeSXaZ8rB8o?=
 =?us-ascii?Q?anapGAYp44L+bwuj3Iy8iAIZdXpUMhwQwfirIe61/dwA/kn6Nsr/qpQpuOdE?=
 =?us-ascii?Q?/njzaf0Z3sNTM84ugP8zVCIGZMDQPl4hyAl19wpBI+uU/u8aA8xdSpOi3Qnu?=
 =?us-ascii?Q?eRg8podORYhIfKK67FZDRgx64Nfs37a0BKAxhjEZDJWydFxgL9L/RH3y9Z29?=
 =?us-ascii?Q?j8n+AXGzqatzY5+rI14qbnqPcnTAn/D7kv31Pt35vIIkxCqrlbn+Bj3BrSsJ?=
 =?us-ascii?Q?tVGSpiY1gjdMaw5tEjVu3qreINbbm6e0AppFvadVd0PxmCnnLLriS/RwxG7i?=
 =?us-ascii?Q?CxdMj2XnHBgySbXEmwnwolYbJPtHoLej1wEtsbXuSckTFzCvFUnYdI2o1P9H?=
 =?us-ascii?Q?JmSDbMk0RWJswy5n585ggo7/ZAJkczgDnWgkxuLhSTjurX77n5cLn3+zSIaa?=
 =?us-ascii?Q?hhdYRbHai/fIYb4oug1adJOqVPP/OLgnj1WaS/SUJH4qrGg9JrZ4nwfnNAfH?=
 =?us-ascii?Q?MNeRTRyfzj7k2CrZndo8/MQiEU9d7kNxMaZIb3Ih+R3kzkYumjxwihG/Jk7g?=
 =?us-ascii?Q?gqDYThFHFJMDgfpXo6ZNg0BLsZcnw8qct+diQpFc3nhCLXjJypecJvDs71kR?=
 =?us-ascii?Q?Vh4pXk3Tr0GLbGfWmMAEFrz489Z762LV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?02WNzSeVIvOyOGrqtepQ9ffo39lWsJApfduiEat3oYQMCG3uHIxq5jS/DqJC?=
 =?us-ascii?Q?kaeSBZoo5emw8wlse8aQi1Kp8k+Ynfh3/SIzyvZflMDlyCClLZ1oCX+xzU/d?=
 =?us-ascii?Q?9/unnWOXzl3nyEk9eSgzpMjy7NfyunVHaJ+b/clROQxBI71wzmTeNz67U5bC?=
 =?us-ascii?Q?BQcWAiWuFtH+IJKO20suyOd0g7xrFTmCwtqniQ9ix3W2muWH1hvzISaBnFou?=
 =?us-ascii?Q?fLp7FCKONFtAuHUfuQ7N4j+urbc/ILXjHd+dVPkdgqvcKBq/Ugms37BRprSe?=
 =?us-ascii?Q?YbIq+2u/ttUB6o3e766w2U7dp3P8DgyIAHrmQqroT3mgRIHRnKF1k/plfbvE?=
 =?us-ascii?Q?7gDEGzNqRqzgB/+vJRk8PSH+PW8jLkdfW7mSMtcgZMqro9I/R+xpCXFyZHDQ?=
 =?us-ascii?Q?xSKcKKcHrMtVJse7QLGTAI2uNTZvc4tf+l37z3Vwe8924iC9MegiT7N+TB5y?=
 =?us-ascii?Q?l1nZ0NFULFjlz/TrFK8KPOiBGHUMKWSeDC3V46QKQMglwT66HcewoSXgmfbX?=
 =?us-ascii?Q?C3kgwdTDDCUt8IwAqe/q0zMIdi9YomNhB3UP2BuIn+y3CBf4yhJRQnyy5HLL?=
 =?us-ascii?Q?mP2Dqvw3JQvHMq3Sv7lMzwfP0pBj0+wV4ecf+Z3RZ1bny7K647m9/Uct3JKQ?=
 =?us-ascii?Q?WxhY8FdKlnhwBUp7RW7rDyM7g1IjPuc0PYXxlrPv/lUJZ7EQuSvCuhndBmTL?=
 =?us-ascii?Q?ZuqrBF4V0zZz+zSq2qZPfIds2/BHDgJ7k3PaZweSqW3sIBTYPlcj2r681/UU?=
 =?us-ascii?Q?/gmynXOcAN3E3cGwdGKdHrC7GHba/4FDdQTXqg1gzJ/a/cbTPXGsLMrx8cY7?=
 =?us-ascii?Q?cVS3igVOsrQ36e46JpoSmXoFfuxKzPWQAbi7nPpVNX6hO3fBYI7+4R2DmmxK?=
 =?us-ascii?Q?z6d3pIGEDu57S7BAWUgbV9o4JssDVJYSrxr1LuanT9eedtAEd+irkOOLsLnm?=
 =?us-ascii?Q?NjsaFDfwFDU3HYy3YAhBQQOiU1aIuxejUqUSOZY8s1nHAqHiKUJl6loech0t?=
 =?us-ascii?Q?zwSfiQOeBe6Jm13Ko6aDl0GqbB2LfMpR1lDu/cUNKMW30lw9NoMDZa6Be3P3?=
 =?us-ascii?Q?1sg9AWd3eqkJ4LUdyJE9H9HT+NIOrPGq37n4vCYN4zz/jil7VsYZR3tsA0W9?=
 =?us-ascii?Q?LVq50s0bOW4LS4QANn8+NoSy7BA1V/1TPK6267MswvHLI0j+yI3JDPpEMXmC?=
 =?us-ascii?Q?QaPdwNqnVH1qCbGE7FdkXAPHZSKzWVoa1f0ysPZboONHKFtWYTrDy6ScWvG/?=
 =?us-ascii?Q?TcoPFTBRtkVOxxuk0/UZFANOTNQpvu1yF30/3wavH9FhvUCbJ6vd4o5maU1R?=
 =?us-ascii?Q?U6XN1DnKj+fKJglOsktKLNiw8PSxjkmLukmNW/rTbWtibhJsWTgevE/OsQ7B?=
 =?us-ascii?Q?zjW+PRrLhy59VzjJXl7Nz1yVIorIC93G0GA6eHewdD2H4aMhLqsxpJ/V0D9T?=
 =?us-ascii?Q?1g87ceGQjpXMlKG2mlSusnaeeWVcrNd0j1Hid8z0kthJieenz3ul+1+2KbOw?=
 =?us-ascii?Q?AeI9w5sPnGZLzkR4q2DFQ4DfLJ9OUWxsK0Aj7jfDlIAN1Xj/0/Mnm1PxLL/J?=
 =?us-ascii?Q?+ssF/541RTkU6Pla0u6f/C6hZGovDMVXKy67kcAmDKnCWKHx73xpP/AGN9xt?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W51Yv8uiQrGvL83yZFzyJN6Hu8bLvwq5szY7/TI+ml9V8rfDgP7OauWM7c+bklpNDrvYn3zZllzEgUhY3IAZO774Bdv4akaQygXvb5qntyQS6qUPEhsMqlnsMjH5XotQ+QwKdyiSDEgnHhqfbPMnlOG2/Wsr0uehqVMr8op/mQaPl67p8J+E7I12W1elknuvw+7BMS7dhTqxQzRBpQ3W1TZRfRJ5zwA2qiy9yhgyilUGzoUuk1GB/fQ2Il8pPu0V1hTsLjvNMarXg47U92IzCp5d0AOqHCN0F6wwL77f392gQUmmIIoLYTN3OsV+xuZ9LMNrfz4dU5ve6I8r/cZBSGWH8gR0PQ76zdISHgPB9BH1TW1Tbl/krlwh0Be5BO/pvAf0E2UOWdAfl1MxBnXyw2XT+oScP8VwZFzCHlFceQBULGu7lDk7/FqxaiHttd3qC3GvhwzMDj9dyA7wpc58SdPjUn/Ngh1sfujm7gtM3hxXnRJj/5GwhZlTBocCrGnvm1PoKt/yJBXrG+rogAue0ypmpUblc7WNw3uXpHlhkvDM2Y9mdZo0CDiq9WE9pyc/bhtvk/F34kXBEs0gviKrvvmuGphzri+zqSEa+LKkv4E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf0b515-0fa7-4457-9cc2-08de3d171d68
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 02:51:02.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w54Uhj4nPrH3vJouguJlwZHPKLNN6mAHj8RNhUA04ARdDEgLqy5dhD43x1TBl0OkUq+9RlP/51s6f207fn8TyMhKpS0q0scNZE/FzMfLt8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=857 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170021
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=69421a9a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9 cc=ntf
 awl=host:12109
X-Proofpoint-ORIG-GUID: 0a8-EFAxz4ZoiUm4LDdc54vSLBifmLy2
X-Proofpoint-GUID: 0a8-EFAxz4ZoiUm4LDdc54vSLBifmLy2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyMSBTYWx0ZWRfX0SrzNOUhIs1U
 DaU1DfawFOBm94ViNwaTHDjz7+UXU21Es5uWHWRnxhsD16Ym/VPm2qC+0QxfHirfedYl0NuEMt2
 rcTIqCw0VnQdeI1fI9eDbm4UYOvUOQ7b/75ucgC2kyxO/EYVkEdWhCeHcLDs3dcXFPCeMEUzsJ6
 3JbQE6Yg+fFjoE6pGWK5BBaOMm5EtCCdaY3BC21eiTCVz/sxDulXrWX9g/6SoZrMs53/+YmNicG
 Tlv88wkx/4U19LKBtA0g8EpgOpKRK5WdQgjB78V8Lm6VUMPn9FI7utlpbvIiVZFOTS2aD5LQs+9
 uRCPGfxEEhk7rsXlAV4qwL9n1YAR9rezjEJv2SxH1woUnhlWv7D3eXTaI5/Ofj3O05GNYpj2JcI
 9zCHBzdOiEgdY0WxR91ZjWI9BjcdbqomRZYtp8/Fb/OLsWaXm5g=


Yury,

> The function opencodes for_each_set_bit_wrap(). Use it, and while there
> switch from goto-driven codeflow to more high-level constructions.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
