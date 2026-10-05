Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D4E47DD4B;
	Mon,  5 Oct 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791213963; cv=fail; b=HZDzvae02ouvwcXfYh8qKSnQI9otOHrZia/IYpW5qG9nOLVKQIuQQmCnlwDneGPeqL/4dbDldMmNi/SkKNR8e5QgqVt8Pm4NhW9roQ/zMfW0qXL6PWCTkw8WxaJn3XNAPBX8pQI7WXr03njUPY8TnU+HRzsN1lNgGfOrCZydsmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791213963; c=relaxed/simple;
	bh=nGKWTiQfZ/fz3cXEYZvWFy9hHY605r8D5NWuvN1EdaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eq2iUuHtD1jHlM6kt4sYEnIWZJg42WKuT9p4LkEFTYULYbTXyh7oT3odkpJ3mFG59KdBllQPOpfRLxiYtzMTzl9LSNCqy9ox2A0cKuYP4lLhoQJm56r1Mqyylh/bKH7INBriQd3oJLPGnI0Yu1s6/U7mVQez1lWYOu+UM6v+P0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Um6pyLI/; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Um6pyLI/"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EQYAi2484722;
	Mon, 5 Oct 2026 08:25:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=NhUk+nAK2i014vQnY2kYW08hVHzdGLJkWXpKhyMv8xU=; b=
	Um6pyLI/Wvy0WcIM61meqIZFdq3eGo2I9+GfBCoKXSOmtN5Ck0HrHNjrJ5mWMKCf
	WkPwzRw0rYHn9YgnpEo+OcgPUm3TY5gLlOWLcoVoFcTBFchr2HwXRVUdLNFA1n+a
	8kO4r+z7Pyyz8wBhpcj2wjXs0W05lZB0ahMOvVyma8lB5LaG8rAymtGnDVTmfVaq
	cDzyhXmGGnQ5R2I07w89CxIz2acnIU3zxBvt0V2Ji3DiU30Z9bC5e60pqYybB9l0
	/QpMBUT9PNAOT6gKIdBAZwM0xvx+2cMCdtZO00yGXw47nj5B6sPXI5MG6g8UU0Y0
	fYmjonyiNCdJYdUbRJriyQ==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022098.outbound.protection.outlook.com [40.107.209.98])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4h2w012cyn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 08:25:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKso8wyGkExW14NDBaWJX+PMOclsp3XFdIwQMi8qoMXL47BGiILgN6JgdgrbxDCELfzq4+LgoQR9/ZuoFqjOe909XFoDod0WpCO8mmlQ1qS0jmHDerI+dNAJef8yQHtOcia/XM2wyF47VeaRAkkKYgzraHqgdD+/YTSppSztL8OAo+CurAwsNmj6mqrV1u6i6cKH4MFPR9IKyXwjuSyzEPTp4LjJiiTVydQuS/EzYggNZcPufXy2L3A+9Ic69lv9/u01IFU+W5L0HmRczeilLDTnTkHgWZpf4PZL4SB0yS42XQT1OpkKOctUWLcZiCZwZvlXjOfd8UbuH0cviIAkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhUk+nAK2i014vQnY2kYW08hVHzdGLJkWXpKhyMv8xU=;
 b=AZU88fOPUQwQg4QYr1LhimY/9h9q7UxUynkKKA+whFwBrMHxiccq4h0tA/OOyL4PhKYlOBJ7O9bQ7BhdQziYzoBmdUeSSNUg2jpHMIrW2NNhqMrKLvzyMmHnGGMpVHMlQKaT+XVst5O5oeCxmCOV/0FoYhgtyBZAu9zN2ufuFIpF5Asc8V4bdNN3M3G2btkbxiSiQ17Oo+wIRAZXgcB97tfmQXPkdwmphIoT6Zla9DNURguWksQaKuVDObMXKSW+IDlwzq0hwV42x2IUlPNkdvGC+15q0ksSOUzURTPZbvx4zKInJUB24Zq2+X3MGifsVpa9ZghcqEhvH10T1PKi4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by PH3PPF10E309DEE.namprd11.prod.outlook.com (2603:10b6:518:1::d08) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 15:25:10 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 15:25:07 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: atomlin@atomlin.com
Cc: axboe@kernel.dk, bigeasy@linutronix.de, corbet@lwn.net,
        frederic@kernel.org, ionut.nechita@windriver.com,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        marco.crivellari@suse.com, mingo@redhat.com, mkp@kernel.org,
        neelx@suse.com, peterz@infradead.org, tglx@kernel.org,
        vincent.guittot@linaro.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Date: Mon,  5 Oct 2026 18:24:17 +0300
Message-ID: <20261005152449.468696-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ul7xqsblqnrzx67s7urmtc34qpemuf3jeduxmsuwxwlnky7eli@mzdpwwgug3hg>
References: <ul7xqsblqnrzx67s7urmtc34qpemuf3jeduxmsuwxwlnky7eli@mzdpwwgug3hg>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA3P292CA0005.ESPP292.PROD.OUTLOOK.COM
 (2603:10a6:250:2c::18) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|PH3PPF10E309DEE:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a7d6be1-ae79-45ae-e52e-08df22f4d67a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|52116014|18002099003|22082099003|38350700014|5023799004|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	PM9gkbw7ZE1jqQHlwLyBqazYwu1hYDzjtVjh2MsZDenBvJCD/VZx8+eCFLPGXR8RNrWLqwk7x8HJpGZTvVfzecgHO951Vzdo7iKick+j9zo14NliBgB8LPD88r/Vj5fLkDUawGSFAHm/g0cvcKm6qkXLCW/KmSxHukyurxbkTQTubdZkehHjudIF9TPtf++5iNfWHOWOmMLzUHXcmWV5g/c+Dhq4KVlVZ3f93N0/gle5j4uwbltd9oKjD/Q5T+dVJAKAbr5/D9lIc9J0xch36CEw7hH38UHt1/uRK/byt6wKH/QBq0oIFGDn/8leOd8YbpKh+n1DhfMv354GBcBzICrD5UI0P82dHhd31LHbl9Ti6Go7mm9iOiH+/sFsWSjThaSMfGd74HC5NytFP1nIPC/3ernJ4IDhxyyEX05voO33PFF5/OogDKhKN6jIkAlAb4DpwBU1SJslPGBpAWJ5eEcpiT70HyCvMEUofWBK0K8idx0urenMEaFFL3O0qIw5ecvYPhGr3dmvRFmPlgw267dVYYJnSqx4eb+eAiltRh2p+/GlxFOeCRB1OnfQFpbcEvGDSrKoY0LJIvXAwDAHMXe8xp6MZyQ/pb90OowxQXQ5Gh0a9A8yFVgxEwYTZojW95WUjjtT6/za5Y+0fKH/HwCL4egL3ii0+CWyf7qQ0C0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(52116014)(18002099003)(22082099003)(38350700014)(5023799004)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1sK48/0w+ZZejPrI0jd6gXi1HsD5zYEa+cHtY6yAORczFTYRGq/ExzSwLZ4P?=
 =?us-ascii?Q?l3JdzxlSh+JRO4kldl0CdlKVlJdd2S+mewrqw/8ytfznOljwkyVxIReo101D?=
 =?us-ascii?Q?/uYZ2TihQFM5ZEoh1uIuLAjsIFYl+DiEOVwY0ktzoq25RUSnVnHMPPSVzIAw?=
 =?us-ascii?Q?jyb2VbHfislyDKwA28q6dm3PESTwaDJQAuOJRICwlxxPTByQHuCYqKR6y6mY?=
 =?us-ascii?Q?aR/j0UPsINp8dSyGDOfm1gV519eUOJHOfCv70KPYTboJdxbcFc+NhcpYcIyk?=
 =?us-ascii?Q?cZCyItpDv/YqJAfd20kcZIAvWZtfjVO5pYfMQuvuDoaj/5pBA9RDPOSA2IPD?=
 =?us-ascii?Q?EsJkWudam3v6VjrPro6nOVgZFzC4jTjtczo6eSvemrXjy1aTV/QhcmX7lpCk?=
 =?us-ascii?Q?Ohv1iIVWdUmxC50r/oKXMVnTU+GR/qVwpAyNAw6VYXCpiIAyfm5WZgsxuG6L?=
 =?us-ascii?Q?97SqMKgC4nq4FxZ4dYsWwGPMbWbKC79sexlvPfgbN4lyTTGXf8b3ok3gAGW7?=
 =?us-ascii?Q?edaFF/hRS50aW1n+rSbXU/6gJsLB4ZieVB4z/kQt/aDSFxv9iMUF3F/dQfBI?=
 =?us-ascii?Q?xSazZ7UhXAOICgMIk0/wxDsvI8Vj3+QXH/6amhCiUADJQGCK/cEEMdSuI24z?=
 =?us-ascii?Q?XMN8+ZkwgShICPMjhO2JLiRwfbybAsR/QBXMLKZV6FyPEW0RWBw4OJBd87Ng?=
 =?us-ascii?Q?pr8qddEwozIcCW9RJfbtfZ6+4M8pKtNPaM2fm6IpDog/MolCN9frEf7bp6SL?=
 =?us-ascii?Q?vhTBT957IlLHLu0Hjyf3TbGyFgKju4hPXt0eqfiZyXnnQdemoN4oVPYLbxZR?=
 =?us-ascii?Q?LM0g06Lcvb0FKeXMGnji51ee9/UGZWaliJOyxF3Mzap5fVOEgN4afL+SlXMl?=
 =?us-ascii?Q?vGFqHqHBddRnnHkJHYFIz1RSXUrKQYVPZVzgACdm2jNMlr4cKwiEstBIiGyv?=
 =?us-ascii?Q?Y7246eINqvxojgHgqcgHxK+kfkffwPS4bgTXufHYSGusP7AsNGCQEVVBI11z?=
 =?us-ascii?Q?2KAsLMNdpOjos1QGowL4PE4hzgr6FcQMP3AQDJFPiI3cG/uXtLwtpZTkenkW?=
 =?us-ascii?Q?9+jg91GjwKbf75qq6x0rQwqQ0cAzSjyTx7yjPn/mkTARXIjURVloeT+xia2B?=
 =?us-ascii?Q?zmm/AR+OkfsiwyS3lquMgOFOcJ4BF4sdYe9OgN6t6K1fHfZB2zJpuWTg0GP8?=
 =?us-ascii?Q?M05oqbxggsgtpCCoIGSYVATIy7cvSOqWpZBkt8BUhfeg9o1FhDWX2kNI8O68?=
 =?us-ascii?Q?YWPJcFuufNKDxnsW3QfM2TYH54ZfPCRd8rZFQL65j3JSXMG9gcaRExG9r/t1?=
 =?us-ascii?Q?/18uamRpN1LtPfiLN9FlrsftGBLCN3yZyN7oxwgRiwXy/K0IteuC9sMCYd2Z?=
 =?us-ascii?Q?v+u2StzsuwhQjhWLPQCZGT9jsdPM7LQTZMgClf3ucmDGYksCTr6mXp1gcoCD?=
 =?us-ascii?Q?VfLNq0lHV5DOJ/eEy+W8E3Wb5Hr9AxYZspVEtgvlVUEiSjXlxr84GmMAug9f?=
 =?us-ascii?Q?D3p9zYxpJrno2WPfsYZvQM9QivJsHO5Ttxu2abXxUuLcZ7l7pM1o3kHGLTkE?=
 =?us-ascii?Q?nei04r+bmmtZSlz1U6d5Gacz1DgrX1pSNhnnRX0R0/Ont2RxbEO5rDLDvS7h?=
 =?us-ascii?Q?IfKUQtID2BZMv6Ydvu/BlcEU1fkzhKbNkAWZ2xjKOroQe15omFic3NtL5rKd?=
 =?us-ascii?Q?TIKQGxK31sb9GU6bT3Zcy27w22S6Wa5w9AESKBB+lSdi4hRnhQVgI/4iudgm?=
 =?us-ascii?Q?pa2Fc5eFdSJ5NysFctRAorjDg+iiIxE=3D?=
X-Exchange-RoutingPolicyChecked:
	sQ4BkO49BU0sU9CsoqEGQaxJIOa2ukGJ/4LnlsgFwHId+TmZwaunsMDSwkPBldBo4wR2w+CmwpasVaWnDDpvwTIlCOJasTMPzL04vdyKA+2h8RINl9YUCbul9vwU4EmY5VdFa9TZ/Zg89udHfVsPR4lvw+LfT1cq17ENVlsKD7iJLecIb1C9yZPW/TLa8JILupJ+x31a5RivwH+rKj24r7WamG4Pvn1LiTwR8ipCP3YmoBNRS8N1eQVqu+UyftCKYPmsoyY/QZGEDBQ5xWY3mU1A57OxvjgciSjcFTq9AoWA3mICQ5Jt/n10cGc26SfFe+NtwF85snJHXytcMdEQ0A==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7d6be1-ae79-45ae-e52e-08df22f4d67a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 15:25:07.8140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EwxhAE0SnqH667us+R1rLjFBQy32IS3lhT0GAE+UXoEXga78hiJWywdjHbQI7NZpepRIGnF5+5i9xy3FX5ob5aRSpDKun1UqLRadYOudbpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF10E309DEE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA2MCBTYWx0ZWRfX+cyZ1+FLTEP4
 X62SZju/TR1kImgRyH/CE6WFxozzSs7o1V2G3lJSYOfgA1rpDPW5F1o1n0N4yBa5AdVJ5MANIlD
 zdrQsw39EtkdRq/35nuzQ74aKJSrpCK11iz5kgqKU67T0heZoq5o
X-Authority-Analysis: v=2.4 cv=fKesTpae c=1 sm=1 tr=0 ts=6ac3c15b cx=c_pps
 a=eLOM5dFMzXA1JCJXN2lYUQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22 a=VD5r89Aj4ajw_bi-omYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA2MCBTYWx0ZWRfXwVIt8pBsyZ0m
 WM+m4dAlTmC5hiNSC0H60w7l7SN55CjSk9sTvL7sSY/Z5W91MyEjPCjxR6/0cE9W/ehjWPmYWGq
 +M12XJAnUe/6/ZG9v3GiuL8BLAeBIKf4UmgJzxUU1XoHWeqccEdxC+Ww9pVG6RGEu6Ma8P3dJCq
 cStD1hdKpDYlafhAhqTHId2nYWjka47bSvqadH6kXsEUeiJBIty4qpqQBNOYIZBOfPFOKEPkFcL
 POS6GUQR0k0JSxR7+Zgj7zmymUEMN6PpSVW6LLu3PmzHUVxMyy58Ddl+uhXdyEbyU2/9XPL38sT
 07pzqNSN7616nh0XNPkXCdCgNhPIe/eY3gRFPnA+eA4yRLiaV+5BH9CLB/rmlgzI3A9QNLCntUE
 cbZcA0Ys5IxPiqaVUsCfCjCkh8KSiGBbyGGThznrMPGrdEeJASyd1qX8sxJ+/7c//VEZP5QIKli
 gNLnZlvPZd+gW/O43jg==
X-Proofpoint-ORIG-GUID: wsCCEU4iM-sRvsDxhcBs-fmmfBVcD0au
X-Proofpoint-GUID: wsCCEU4iM-sRvsDxhcBs-fmmfBVcD0au
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050060


Hi Aaron,

An early heads-up while I continue testing v16, and a question. On a
small-housekeeping / large-isolated box I can drive the Kubernetes
control plane (etcd / kube-apiserver) into timeouts with heavy block I/O
from an isolated pod. I want to flag it now for context, but I have to
be upfront about the state of the evidence: so far I have only
reproduced it on *plain* isolcpus=managed_irq, i.e. WITHOUT your series.
I am reinstalling with managed_irq_strict to run the controlled A/B and
will follow up with that data. So this is not (yet) a claim about your
series -- it may well turn out to be a pre-existing shared-disk
contention issue in our config. I would value your read either way.

Platform
--------
  Kernel:   6.18.15-rt (PREEMPT_RT)
  CPU:      2x Intel Xeon Gold 6338N (Ice Lake-SP), 32C/64T each,
            128 CPUs total, 2 NUMA nodes
  Storage:  Dell PERC / Broadcom MegaRAID (megaraid_sas), MR(8192MB),
            fronting SATA SSDs (Samsung PM893, 6.0 Gb/s); ~0.5 GB/s per
            link, not NVMe-class. Capped to 16 MSI-X / 15 blk-mq queues
            via megaraid_sas.msix_vectors=16 for a legible repro.
  Layout:   etcd and the fio target share the SAME physical disk (sda):
            etcd on cgts-vg/etcd-lv and the pod's /tmp overlay on
            cgts-vg/kubelet-lv, both on sda4.
  cmdline (relevant bits, CURRENT boot = non-strict):
    nohz_full=2-3,6-57,60-61,66-67,70-121,124-125
    isolcpus=nohz,domain,managed_irq,2-3,6-57,60-61,66-67,70-121,124-125
    kthread_cpus=0-1,4-5,64-65,68-69
    irqaffinity=58-59,62-63,122-123,126-127

  => isolated = 112 CPUs; housekeeping = 16, of which 8 carry IRQs.

Workload
--------
A single fio pod pinned to one isolated CPU via a device-plugin
extended resource (isolcpus kubernetes label), libaio, iodepth=256,
numjobs=4, direct=1, OS storage sweep (rand/seq read, mixed rw).

What I observe (on plain managed_irq)
-------------------------------------
During the heavy-throughput / write profiles the control plane times
out hard. From etcd (host service, /var/log/daemon.log):

  apply request took too long   took:"13.08s" expected-duration:"100ms"
    ... error:"etcdserver: request timed out"
  timed out waiting for read index response ... timeout:"7s"
  Failed to check current member's leadership: context deadline exceeded

kube-apiserver (static pod log) in the same window:

  etcdserver: request timed out
  apiserver was unable to write a ... response: http: Handler timeout
  retrying of unary invoker failed ... context deadline exceeded

The failure is device-bound, not CPU-bound. mpstat over the 8 IRQ-HK
cores during the run shows 7 of 8 ~100% idle and exactly one core at
100% %iowait (not %sys/%soft) -- i.e. a single blk-mq queue draining to
the slow shared SATA SSD, with its submitter blocked, while the rest of
HK is idle. So this is not softirq/CPU saturation of the HK set; it is
I/O-level contention on the one disk etcd also uses.

Why I am mailing this thread specifically
-----------------------------------------
Your series changes which CPUs/queues serve isolated-core I/O, so it is
the natural place to ask the question even though my current data is on
plain managed_irq. My working hypothesis for the A/B is:

  - Without strict, isolated-pod I/O uses the local per-CPU queue and
    etcd uses its own; they hit the same SATA SSD but through different
    blk-mq queues.
  - With strict, all queues collapse onto the HK set, so isolated-pod
    bulk I/O and etcd's fsync/read-index may share the same queue(s)
    and head-of-line block each other, pushing the control plane over
    the edge at lower load.

That is a hypothesis, not a result. The A/B (same fio, same disk,
only the isolcpus flag changing) will tell us whether strict actually
makes it worse, leaves it unchanged, or is irrelevant.

Questions for you, independent of the A/B outcome
-------------------------------------------------
  1. Is there an assumed minimum housekeeping size relative to the
     aggregate block I/O of isolated pods? With 8 IRQ-HK vs 112
     isolated and a shared slow disk, the HK pool / its queues look
     easy to overwhelm.
  2. Have you considered an I/O-QoS angle (e.g. protecting
     control-plane I/O via blkio io.latency/io.weight, or a reserved
     housekeeping queue) so that confining isolated-pod I/O onto HK
     cannot starve co-located latency-critical services? Or do you
     consider that purely an operator/config concern?

I will reply to this thread with the strict-vs-non-strict A/B (etcd
apply-latency + mpstat + fio IOPS) once the reinstall is done, plus the
full fio sweep and irq-monitor captures. Happy to be told this is a
config problem on our side rather than anything to do with v16.

Thanks,
Ionut
