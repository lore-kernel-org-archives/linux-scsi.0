Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494713EDAA3;
	Wed, 25 Feb 2026 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033869; cv=fail; b=iIhg+RjlCLAqXO3UjfNLJOD2xL0ov8sQ8BTdccx4EfGblCsghS8CidAstHqAXhiMG3xIAYKTRz+nycdb6vKXMW9tHwUL262CQ7iXcr/kf6ujWLn39GwpMDQ1P+YDA8p5jDufUD1qpEedo4U7yoKbyJLsnQkIjBol0hqJAznM0x0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033869; c=relaxed/simple;
	bh=++6VZF7tGKSd22v6GkMvdDs33NvsfnfUu7qyRzojanA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jjp4IKP0APLtte+Ud7TVIQxHH7H/WDJKkUq+fQGXhiTkvZ8WScaDTzhZU0r5U1l2o6X4FM6LHCF7BUMCob8uw28R1wVQQeW2QTnVFo0ouwTpcoeHPg/fB3/BmNFyJ2svhSr3UaEMcvNbESpm7jiC3ngvB/bT4bE9Kzj0s/s+Kko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E/p5fjRc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BHGERDov; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E/p5fjRc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BHGERDov"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PETBIn2703463;
	Wed, 25 Feb 2026 15:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0ioWiD4Nr1bVF+cjfq7WzOnc8SFoWIxw4wR1krCiYqk=; b=
	E/p5fjRcPMQbQ5KPhMc1KeRpQYqdAJb7PUNYHdGLaAzIaDidEcuhkaY14VRHBL9x
	HJCW6N09NDYJiyGemwnjvaeqg+C+5ZWrvUUFyS/W3KKNmqlIk3MVqzj9HvZUcTbG
	qZDF2uhfO3ERAnq4zGO7pivF6jFyDvoUrbl1kW8PYpAgankLQriTQNy7jzyI4qal
	cCoo3ELUYooAnBYwFSp0KehB9a5P1DhMS/eZe/1kwJ3dgKpvfHmlD3vlHsVwW9lO
	xZh9ZRcFnRk/4oLEWz7t9vw+nYP0NI6X0ppShWZ9vYM3vCn81QPKSAo3javfPSgA
	p/DAUzO5UKrF7QUJSbcLkg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbeghr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF5ciM015907;
	Wed, 25 Feb 2026 15:37:20 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bfm0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9DeMpy4yQ6NiIZ0HLyrxSpJHa6wVj9U/Sd6a6RekFbeSyW6z2faxInWNJjm/7WHJKpNIpRKOLgtgeS+1dbHVBTNSr3Ye127JXIX4QQeVdhy/A1KvVQhbFiRvWcypxfpbu5kH1KkwBOHaV5rOrGG/mrdBEz1ZT9daJ9+r2xCSt7xU8ZYYjDx4Ql80xEvSIMc8yxPeKQaj/rIEU5z7/Tj+hfWITHfz9cGWNvG0n2tz8MBzLxAdWLxXbJlt8YzJ7rnNwQygxVsTVEFX3Tc166nrbALzOrID2ueXW1HTelrOdar2oSROzyDlIgSLSGEvwZGhqaZ8x3VfmT7FzceKuiDQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ioWiD4Nr1bVF+cjfq7WzOnc8SFoWIxw4wR1krCiYqk=;
 b=L3Gp0TuePVhndAWLKsZF9eKPkemPGaGhsDSy6TK7pBZWEplQZ61jd6NUluIS+ExYWBs+Vl3ZHfQ62NxEgjp9IP4Kf7Ir5LS+XSxYBRuy92BXQR9OrkVXV6IRSEII0jp1OAisPmwJi42cWyvwwQC6O96k5UvN51ZTfygE9qNB15nHo7EOA3Q8CErriilI/4ieZISlWkfxSl/3gJGf9OSwyZXvTQar/PyiXBjwnBBqaAhatMJkIP4diNYuam/otBvskM9PJ5OYa/UFEE7XkidC/2dNlV5nFicaaKrFZAGy60P+0qyVYtWt8cayj5w4ji6TzFB+1TjDVeb1p3BtGVn1yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ioWiD4Nr1bVF+cjfq7WzOnc8SFoWIxw4wR1krCiYqk=;
 b=BHGERDovQaS/sZ8pppCDIbZq2mBv6v14liYmA2cPIfvXhn9oQ8eo0fjlP0UqiOh3eOJnqAHGa/6MKqvwLA2MXqBcFZqYEcPOA7EQWJlO0TB7DUFwvrnmKLCOSClX43ci7LjYnjbZcW5X7xE3UFmnhAqXQgmu950E93Th+Hqc0jU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4285.namprd10.prod.outlook.com
 (2603:10b6:208:198::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:16 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 16/24] scsi: sd: add multipath disk class
Date: Wed, 25 Feb 2026 15:36:19 +0000
Message-ID: <20260225153627.1032500-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 2226697f-05cc-4cd0-3435-08de7483c109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	H9Opij4ONmF/h+RLppuq7FBGvHV+rJq/KXcdUO36BkkxYiqOT23J3hcYG2s1i3w1QujA9KdBdbtbQs9tuNRjv3lPj5p/KhtykersNBn0blnU8hufhfcMaXYLGw8mdyRcwgHMUeH2zoHc++NxrWRC0JhgxbgYYwvM7WzU2K36LNRzC7tM0JMn8vhTcqgbY+AoYiitJ9y+CeM9FDR/p593L4ZUd0mMpjXEuCqTPR+9MlFMoHDsWw4NQJxrB+CON/JWJwugjv3bFdasJuiDP+W4/yn9peJ1Ns8F25XT2tUd/8nyvkUsmAVlzn4LWEbqWQ8yBb8cvuKCiYG+W/V0tujxK3VN4kggB9rhYA8ShyFv5veCnPskykVU6sQ11BFIAYuNX69252D+NRtqXRR8rkWerslvnWmOcqWdGH5VgmG/Q6UwIETbd0EQWBhyXPGh3hlB19tW2mdY4otR2l+edd+YfSIpsNd7Adoq8LlC52KpzQ1y+jZhdxsciHG8Z//vaGzXsiXe6475nTUvnefZXCLlGe+MZ/yJTXLADw+XhFQGx0bZ2W5Ae3bfbftTvLxuFCPEp336+7RXwWypIlaS9bsZaFqNontlsLPegrK/XrHRYJWW6i4Jmy71UXaGvWnGFtm+jCr3m1LzrCGy4IQ1+7yVHDBzCVzEzYljFmVarXiJBBy/MyU7HhXWgTCBnxt1m+9WQOLdCFPTG8YAuWz69OuxdtCZEQqMykQ29xZHARpbQZI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gUtuJxVElx4IePrQFYGk1m4X2ARmxg1GteEKvb0ZAJR+7iRJUR1TNC6WebkR?=
 =?us-ascii?Q?rWIp+lmzc3yHsWa2aMNFGM+aA28Xt6qu8GnZ54vVlk61zN4i07NKHdoq5w2O?=
 =?us-ascii?Q?ufWvcVZzcg0GZduq5UyGBokSt0f5fhVwCvxXbHS6PCQqxds1KFTEe6KPFwgd?=
 =?us-ascii?Q?+XJn9S9UwZ8fKb0BiwW21S9eJWbhOQAdZoBck9pulNIO8Yob6yP8Qh54OTHV?=
 =?us-ascii?Q?4VfOctIGQWCo3YIvELkuN6Gk/jqvQ3sPXrBPK+xleDDZWGbNxFYRfmn+hYZD?=
 =?us-ascii?Q?+6wG6+RONS7Z7l4vH9FBILSCe53MPBFEFZuFm6FK0jGW1kvgCBRzaB+qHxO+?=
 =?us-ascii?Q?gz7LXW91yQdTrP0rBR6zywwXNRwMIvc7Uk5vpO9wgivdNLlxRx/yKvHW3Oit?=
 =?us-ascii?Q?DceGBQB3kuC1LX0CyiIW2b5tMN3GrEQ8FC4fueKyEa+2nnOvtyHsVYutH5h5?=
 =?us-ascii?Q?xVsxwjBFZEBjSqHqODLs8Iu7R6TpK7F9o5t6wnB52z1lDcO8FZXqmpWPpAK5?=
 =?us-ascii?Q?VMuQUIj40sR8l2DLPk1b5jjHz7tcFnsDNJxZtZZakNpztb+3ULlWe7LtVHj2?=
 =?us-ascii?Q?z2jtVaTxNL0mlfFQJ2utClZa+CqITyufxzICXt/Z3MEcnNPIsVeIWl+bAo7I?=
 =?us-ascii?Q?prJs1Tq3/z72hTW1QlnWB/Pi8Z7FvIk//KvpmSaNe8YjUf/Gnh+svcq4V14V?=
 =?us-ascii?Q?Mb5nUIy2NyL+nKFHfrBv4HFXIJSBYMw/JJ+Af6Cx15p7BP4/W9RCvz6z5BUM?=
 =?us-ascii?Q?hh3RexkhdGJheZZvLikESZ5ZphBm4FU0pDXtzzuKnNwdWzEhHeo17i/jrUoB?=
 =?us-ascii?Q?T1JMbCHXqhKnyVWC9ZMSl/IZ6PUhD4KV7r7s+gcmiQsFLZxqL/yrY6kYerKB?=
 =?us-ascii?Q?fT/KkdCYzAyMg8YMyaRXuAkqf7z//eFKbpUsyIQCVW0GWEJ+xp293MvEwITt?=
 =?us-ascii?Q?t3ubhRaSqR7DZykgwFoOjfgAxjkHBLNFirfYOeNq7D4sP0TB/7rgeJ9qOvi7?=
 =?us-ascii?Q?ep8uf2byOrbLYSv3d394dKCZxJr//uF+x8HYBZnFd1U97+wuidTee7qwptSu?=
 =?us-ascii?Q?3x+KttG7s4BNcMcEovqhplKdd2gQbs2TiJF/ibbrWOTi4y4w+itSY31CL09N?=
 =?us-ascii?Q?d9JRR1i0ogxQO6VR1+G0v89KD5WLBcqEUQK0l0KW0EbKfLVjvff/wfhiIpj8?=
 =?us-ascii?Q?FD16LbacCzauLc30JfwTGufUjM2VyxDeOEwhsLAc2XzfwUwbYTDqglqpBkp1?=
 =?us-ascii?Q?LcgGDZUO2UZ4jnf/y8GGaC2LKLFFY1hQiUb6aGwmRKCXzTWj66xLyb96ku2P?=
 =?us-ascii?Q?+mAdPA4P5GrrMt17rcR6V/54wOgbplRaGD8ep3YE7Y0J5Z8pjcjFTdfnxkHO?=
 =?us-ascii?Q?fAIAZHqN8/hl5MkBcxn8M9gS/oL2yM/ZW/etGSxi66V3eSClVoAZewSfTUwG?=
 =?us-ascii?Q?oJy0B+nuAoyG2dgFwEH+Py3KQVUIxJw2ZqdP+AtH9f/cwyQuhudYdZfT0o44?=
 =?us-ascii?Q?MgSSgvSeNSpIesvLhwzsl0E585sbE4sjhn6BVg2oClngDFEAS2giF+ljG1SW?=
 =?us-ascii?Q?vBE9NkhmGQO/J36MhBnj4gSM+Gs7hwasbQ8sL6OItlO8hxznTfs5JCaBEAoX?=
 =?us-ascii?Q?Wmz5h9CnBqi+5hWYecEBdTrLi3q/Hg5HHFwbsQA3Rb8hxR5PaJGxdZiBh4aG?=
 =?us-ascii?Q?Sl6+XddscizFGX21+3jpTSXOS0Z3fpRY6x/mDr39RKVSK7/mtKdH5MYEsyQs?=
 =?us-ascii?Q?m5miVmOz0yLF21m4Z768A3txhhBgZlk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	voohCBAxXlpM8clxYsRd1trWsk/wSOpQ9Vm08FhfHgYtxe5uVzfM0iTimmjEVy7E3O5Fe6i9FWjlm//g21jLJGzKpG3SL0/CJyEB6VgOgomEIhBX4dSyF5joEokG52pjorFQDjxwsVbjBJ1GAnw/678IGocqVI9H8DyUECPLNmttDDZrlPd2fHPvUNpGz+Kig4YGsy8tWxc+5n//BjL87yxGXtTXudWokUtaYxYlAF9MwrfMAgS9UlWvP/8VzMTUTveq2HTURW7yLENqXA2qV4Yn6t5OCl/95xWNApYzYQvuR9/Qa4kqYhcVhuQk36jrB108tlwhv0Rl4byfgnJ6HgyZg6rmJgCu6Yt3EqcADPxlR2FSRzQXpMKJFOftKKPlIy65z8QZyiiIHTfcnme7+/kDgV7JOwpGwmwPfb1n8CURfSa686N9Mzr+Ie3nLXtckkYBXlo4Qx0XV59Lkh4qhx7bpwDLaXOjiRZ8+aV3RqJmM+n7w1yoP4NggvpjVfRFEydrlADWSvm9MFqWaQL/9nO07E3us8VdV49JoLGlJ3KuYPLa59RxGNsotjm3UrWU/XjcAf+zaK4hLxPW2N4+I7m3nJy8lRTPivtlRNMImKg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2226697f-05cc-4cd0-3435-08de7483c109
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:16.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUgxlWZ5zQjL4gwVLR6+/wb7KMc4ZY6qshTm1/gLwA+Vm2Cmyrit1VFVa4AEDviF2jjqbRPI4vNYVM6IDVS0wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX0+ucS8bD9fef
 vQTZJtOLRkxzq17WrJlh151fFXz8efD9wjB0r0FwAVCN4wjr1pBQUeI6jofP/7U0yAgF/UlfEix
 iw5NV48PHF2asyVfcSMYKgq2sTguVzZ+BfZWLCICaPF9FYTsfrpuZgGzBb4tBYk/GMh8V8JbAfG
 qt1f4C4KEhp5Mx4nf6i2Z3j4uo2V+ssU8MA5hRbtreb/so36c6p+xbRP3ZwLNj91Oowd0I+X5vG
 F43gN3ksHx5+FYaWaxNqHJ6KpJF4/Ui+PRfQVHBmRCHJgF625ajG/X1z/wMqb+ODNONb4tZ+QGd
 IzgYGrZaQeg2xDAtNOvexxW8BHxK+cCq36r6HGvYl8yEyqJUemuf5L3efsNLbgR4SXrnAbGUVeS
 zq45FPk6KgEGN3O34p51lH/eTs4ms/GzfGcBG/r6e1Iv8rpvkfM67s4hgSuZwGCZrMNJkSyrCgy
 Vyzns3+QDqgave2rQgQ==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f1731 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=ecQ7zCoEdOpy3JLqRw8A:9
X-Proofpoint-ORIG-GUID: aExVfJ4pBLfE5xWB61n6xid7iV9lQDa-
X-Proofpoint-GUID: aExVfJ4pBLfE5xWB61n6xid7iV9lQDa-

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the mpath_disk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cea3ab54c4417..222e28ed44e9b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -115,6 +116,39 @@ static DEFINE_IDA(sd_index_ida);
 
 static mempool_t *sd_page_pool;
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct mpath_disk		*mpath_disk;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4464,11 +4498,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template.gendrv);
@@ -4479,6 +4517,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4502,6 +4542,7 @@ static void __exit exit_sd(void)
 	mempool_destroy(sd_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af82430169..304b24644d942 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+	#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+	#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.5

