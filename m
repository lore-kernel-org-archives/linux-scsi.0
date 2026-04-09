Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82440271A71;
	Thu,  9 Apr 2026 02:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775700715; cv=fail; b=D9EQjO4T+7bsVlKzSpZ17yZdO/AxpVspk64PsJOJGgUW9yR3Vc+TemMI25KIU8prSAvtmrVsvrgH4/R2DHlNMY6eYumQxRxk5roVC16Ma460fxUHlGb8W0aqQQAc3Uta+K5ut6jRPK4rgI/nV4GWQ24cm4uIwn1/Le3o/9PYmT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775700715; c=relaxed/simple;
	bh=CY/Wq8B1JwCzQVfz+zxaVfTGXXKwQUD8dijJ5fqq1Mc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RGNmyxjvfqTgt9oZUssSJb2CBM0mdvbqfi95QebPVmULiZVivhG18dV6qu1WttjH645ZkaPaxUlY6si6mv9XwVmkafCUsVaEryuLIo6RDuTlRDPT0PEiAv3BE1sKCyC5DcferCpbgv/xXSsRd/9ZCjoNj7Jf35+N3d6p/d4/onk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HBwDXgV2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qicb1JIw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HBwDXgV2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qicb1JIw"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NvLWJ1496126;
	Thu, 9 Apr 2026 02:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Hry94ak/TqLl8Facqv
	0BbVb9XTtfeICyjvgwR6wp7/k=; b=HBwDXgV25ReSoLPrQvPCQnUURwCejOZy5F
	Fz2Xx+B870KP/HxYlLSQ/lzHdTR53rpRSPBP5OLCn+A+/hgtTdTq6JdGstViNID6
	MsHlPywAj8sxye+DwAPjXr83DQ/ndg5SQILPrvTExcNbYkP379EtKJM6Ha/HnYK6
	7tvjN4Xe4920Icc4ABi+iE1bUtwy8pDYQ/w+zfGcl11RJf/H3RXobgo+JAridJrM
	FWGVekzW4c3EsJ6/1Pjf4o2lX7C8c3Q20q3VmcoVfqRhbzRlo5rUDDdo0P69zTCv
	svV3Falz6OLQvKH6UFZ616Etu+dkcmyk6zOs9NsZ5A9QjE74dDUQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb4typ-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:11:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6390f4EM005269;
	Thu, 9 Apr 2026 02:11:42 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxr86gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:11:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jfD2dPdRwpl1TF4PUEA+Mp+LEFtnIPUOI9EQvJQ8q3U7fI9JpF2RVndNZVes6ppGsaYMSPKs1sJuqNEfd15pciEhgCJiOZmF9iTdJUlxOGHJ5WoSDGNtpzDIbyynp7g4Sqr0TXAy6+BvXJ+QgsuDfc5q+AShDVOSa4HwUek/HRnWuD5GGQcPM4RTNlRwCr4KSnq76NWLxfTMDxXnNScTEJNKShFZiDj08kEWR8IF7qbWcCcYvJ04Zddv9QInXiB7ZwbL9M36PVtXJ+EGufbbcBm53GNfpZuaCD9uMMUzxwe/YGmsCYkzFrr0hC1l59eqi7H8cDQ4osAcwIllZJdvmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hry94ak/TqLl8Facqv0BbVb9XTtfeICyjvgwR6wp7/k=;
 b=LVwD3ciQfSTbPM0MkueDdnmeL3oOqp7SKvo7mrmiGg1Kya1d1C7iP0ijrTt6eTYD7TvaNPZ2IqbtKuXPFABmqVZYmwDqn2hrPMD0joRZXzghwtqa39BcZyXZcX/9QmrRFCYWvJPMdYgqmPYd7W1680tp/Z7qX/kRWvhFigAC/VkxKUsprSOFh7K5mqWMZuVjqBeBBMrEn1GwP4kR87ZGZh9w+frv9Cv3UnFFaOqO5CXrYB+KDMULhiq+yJTH0xJdQUKuBmtWVFTfamtRKM+jhisrz4dyPQipEM6I4+/m6F4Zl9EyXzk01gPVXhD6VIY6kEiakLjum+4x69dMrEAOVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hry94ak/TqLl8Facqv0BbVb9XTtfeICyjvgwR6wp7/k=;
 b=qicb1JIw+PWaU5nnC1Oz14yeTGnENLfyZ4XJWxJtLH+TZH9wlTty1Sbvf5p4ZKL10fs+IDQatDyqzNZhmuPnvCTt/IdmlqXlzd5jebiBXWR46rM4t8RdWM27pBZZP9G+wifr2G5Lz0WcOAxUde+jXG2dycn8FgHIBJQI/kch5ts=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 9 Apr
 2026 02:11:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 02:11:36 +0000
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K .
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming
 Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John
 Garry <john.g.garry@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: sd: fix missing put_disk() when
 device_add(&disk_dev) fails
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260330014952.152776-1-yangxiuwei@kylinos.cn> (Yang Xiuwei's
	message of "Mon, 30 Mar 2026 09:49:52 +0800")
Organization: Oracle Corporation
Message-ID: <yq1mrzcyjap.fsf@ca-mkp.ca.oracle.com>
References: <20260330014952.152776-1-yangxiuwei@kylinos.cn>
Date: Wed, 08 Apr 2026 22:11:35 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH5P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5539:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e479d0b-dc3b-45a3-5bcc-08de95dd5403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Z2IvazbKDjSRxeGc1quwJ/sJEvV7H57fEdNXBvnAeexxoBHigOtCEMEzU9q2jJQnDCwJBFQi/ofhTUojYo3X/xQCPJhMQLabJIdnkEpCAtwXzEMDdH1/5nwQ6SLBBrZ1445Wprh9dPTxdAuih5kQ8HOHebz/7DWBOn5XRShWBFChCcU5Fo+g8VXGIflfaUsJI5mGB6cu0LSrBR5QjxWYI4eRyZ22bWQ6bM2Hfg5AZx84Mbx6E7n16WtQK8J7CEcSH9iP7sWC+3ePuWRs8uMW8bmSWTyV+9IYHljtRX/DAQ+uC9s8PfWTRZdvrZAY3AmQFJXVXk0AQQnyA/ob2oVw/CCH4DQjgQ4oQUQryNcyc9tSS9fyTb55hRl10q/SDPMYBeaZcmmEn7nOGnMfY45jVDXTQ31Hs3kPPAaTjD5mGXtiHosIsOwjPqzlK5uNMDhgTVdUvWLnElG7tMMs9KJWgiRdsCsx3SD1zqnHF6+/7hy5w53VQDxdFM/90/Hfp5h9ibKytn8XAXQlPIOTGar2hrBUxW7u14oitdBW4k+1buXCrhmPwWum9xquVVwpIR+SCMaecbDp3fLK42JHIxuuHY6DVjuLwbtSxUkKMsslWxC5uWqXLC/+SLtnnOIf/rRRY29JHgVf5D/czG83J4k1JOa7XQeRnfgx55wcD6PjR1LJagPKDZLpFw1ECuetppC7Unv8zrJOyvxwnDW9Ggc9jJJxPkPf/k4HRT9damt5Ans=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2LxoYNAz+vmyvhndDr4naxFpmxhjucBvEUvxsx7r+qPQUXjrCahge3WbFNGM?=
 =?us-ascii?Q?1cSkpgLIeMNK9y8vfXpNb75IgPbZlEDUFKO/nrrfuRaLD3qUviaQMMHwqZXP?=
 =?us-ascii?Q?PTopKY5Gd/L72316FlCF9CfaWD+PB0GrN7lZlSgTa279bNET1mfwG9H3nX3t?=
 =?us-ascii?Q?a7Yyp/4LpbXapzGT4eXPhNQZU0tOuBzAOiRXLvL5TgVQLkrBFgRzkTnn127Y?=
 =?us-ascii?Q?Ss3vzKGOZSHOJYfAIm1vctNAfe/5DziFONQVqe0AclLkY86PpX9lPlnKwCqx?=
 =?us-ascii?Q?Ptdp2fsAbppt3Hrvn7rKa+Bz9NXnQD+X0jAP1rPSpZWm7p6ucOdB+GA/R08d?=
 =?us-ascii?Q?sw4rzqhDBkzvrd+mEJMtLpTb57pJkFCilfSI7dR8E/kK0lkbkqhFeUm0kxzh?=
 =?us-ascii?Q?b+Ki77jZF57T4lTVzlERps9kRGeV5lufGPHrRy1soWfMMVn4V20sOmz2G5j8?=
 =?us-ascii?Q?x/8LvQqRx3ltMYTlize23abtvxT09OGJ6VDzC53seqgWxh1TalqOZZD6Grkn?=
 =?us-ascii?Q?PaPlh+okhXOXb5xIh9vEXqBqsYkMEMHntzlAmWU2IXEYujwbykmMN+uaAnK/?=
 =?us-ascii?Q?gavqYBRNTYMaNvIZNez0GNY4qSY8WlbTQC05TT/xWJWorcQguMnAtxq+vza+?=
 =?us-ascii?Q?lqOuNfqEeuHO6im8D6m3vOT4W5AxLsRfQ9RIISsK6t48ccsb7ZtcP0Vns4lk?=
 =?us-ascii?Q?QGoW9Q7Kmx8f6/8JaB0LXMTI0qgbfUC8mKqH4+EaQw3rN4CGZ2/77Gyazd7o?=
 =?us-ascii?Q?nGI5CnakQ4UpI9Nfa7fADzKU0Q8iRDMXiANJEOcAynh7pqUoNxISA7dUKNv9?=
 =?us-ascii?Q?PK7Cw5KzUIKLbD5k7VIydOfXtu2Yo8nQRCiOe1odNxrcs+4MfQPLgumn4mAp?=
 =?us-ascii?Q?FuvT8V2Fe0Jt7+BWKwa42g53hz4oapRfIakWV+12/+PMRI7mkWh7kXGtdHRl?=
 =?us-ascii?Q?r+I1C1vLRHPZUCZKXY+lBoVJ/NXVFjNc6CJaNQEs/OAvvQmo+zYzCpe9gxyn?=
 =?us-ascii?Q?tn4lpReobySQPT3ycA4/6JC1fEpY6UwWk69HTMcFO6EFtYPM53MfCfNd0+4X?=
 =?us-ascii?Q?nyry9HVwtZtishVow+NqaBOjek4yYI9MZVJP/xBbK4YiRKFekqXDHy95q3j1?=
 =?us-ascii?Q?77VNqEXbvN6LDNt/rQWyYZxIjzIR70TF8W1saoFrgM/YQAiII5mo6WR/s79J?=
 =?us-ascii?Q?/bhizjcUee0KCj4jMaovGaikCFLYr5YaF7FSPLCwekipyLFl9xcT8vZCe9SZ?=
 =?us-ascii?Q?yWi3VLdCnx9zNRkuua0LxH6Jzyuwmrtb6d341fPc5NnMm6rchBYCLnfQtSxB?=
 =?us-ascii?Q?WMD2JBxlSwoJPNkrcNsOmcvjB9bRKb5y1/znLVN2fC6DP8k9hh6ImOP0+XQ1?=
 =?us-ascii?Q?8FZPj8sfvqhJBsIxm6s3ddk44ZJoUxYvsMbyTSedlQ93kGPo/Q5E3SV41zOQ?=
 =?us-ascii?Q?UTIBQopWbXimzt/ct0jqp3oH01vK75RkmPJ2AGmNd/io+mWTmk4r725yolAQ?=
 =?us-ascii?Q?an1cj49tTHI6Xx28cHpOlHgdRAVyT4VNd0+fLVqe8YzZkmQZDp3j824iFUX/?=
 =?us-ascii?Q?s01JNw1Qi6R/mRZdcPBsAKOprl8bjqjs4D71y2i0Tj6c/fUODzfS6dtTkXuC?=
 =?us-ascii?Q?zgEQS7COz/BYH7+3gO0WaqDCum6/uLD9kXn0hoGHqg86Ul2g8BG33dtpp4AI?=
 =?us-ascii?Q?lhgenWe9W971j5R5NWVQxJiV0N8G89ABY3z2OPyi8h+5I5a7Vmw6eSTRpKqg?=
 =?us-ascii?Q?6y8ycX44a/NHiGDlr6AjFRnerjv5ECQ=3D?=
X-Exchange-RoutingPolicyChecked:
	Pjt1/WXnldSykOXNZl6wAaMAw+lYUXW+FEsWmU6HLIM/2NYkFPZ0aP4dfhZhiRjXiG0rdkjesJkJblxVpFjsa6uPbMv/E3MXkt16JqowKOOnuJd5ltQvEGB57JZDEPveGUYt/JUZEmfSkDELbVAL5iFaNYHuOOdPDIRWezzz277TYn3/jnNjTnUQgqWRAzHvGtaI/hrVoB3r4kGVuvhsFhB9FOblPJ7k8pcL0d4K1rMXQpzPiwbkt9wmvusQhPW68l74lMIjTV70sQYLYhi0WU/1oEEKPb4mH50RK24gpaueR7qxnRgpxvTAIbGmtmPvc1Wt1fGP5AQFs9+MsTlW7w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eZMuo9h6YI8LbZj/aTwsN2dDfdG0FgMVrayvsLDGfYMmDR4UYCE35BzahsV3kSu8+lfn3Tg0QVc5s3WWRGwjIqcr9sAxj/u3xtIWhNTviR7wJ5/CR7Xi/W45tspo3qFraTfgp0Mb21jtA8iIpWdK6VdknAOP/ueq3pAXdVkuHnj9TMSJqsZO/flyZAZ3yax/FNqR0esjdvAJDsQUVvpLb+p+8KD1cKkYADqeZOS9V+zgAmimW9WAq856sEsufG8z3WGa7L6iFdt7Syst+wZeSTp0U5TQO0IXu1VsnaoSBLqyd+2r+2+hMFwGphAn5hkqXm0svndxYgrePBanqL5Om+cRl8h/n7DKYXJnNz3rZ5BKf0adCMlERo26tm1fdKNM9SXTRqgXL64JZe/P9iWp4f46Qqpubz2RJ8jRlfVDbkU0IG/pN9zZFMS0yiUqcKaBPIUSb2byZSWEPPTv5vbnMrO8m7NV3SA+rw1UmWf2ZdHX++6ZRqRDqhfgDEIFlsPh29kwGfnEqf7QZFhoeEj2DuTMdMoGO1X+nHZyo4d7PaobSjichRLVZfLxKBV4UojGxsP86MGf+fyaajB2weCN08nErapXMvab0G7+WO9R0rk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e479d0b-dc3b-45a3-5bcc-08de95dd5403
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 02:11:36.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhhQai42BPpcbsOY1KUypEglfHhm4tg4qIdS0u7etlsUwd9YcKbRGQcSGtcqaD/yWp4eTRwD34Bseugu82p5yO5xStkpuIBKngzDTdSygvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=960 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604090018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAxOCBTYWx0ZWRfX8CMajbhAwJyl
 aNm7AhuXIqZegi/ppmbPyhsb4LuTxVeOWt6oScQTfSErIQ8Uih9kzhLP9UTNDMWfVOWtLK6UI6a
 sFoafG9nsYVgzkFFDdlGEspCgsO++QUHt+4zom7k65nY7v83ipeNBs5QFjwJ+YuFpJ8HFMmFDLG
 HwEB3J1eJktnY4rVQBUJJZj3eQGpV9BsPd6TgkL0XzNSUUfeL5dqfBHz8AHIV389k3bu6++uMER
 8dG7e3jmpnaW4Gil5/LRS3vyHsw78fSXmfept8iqAEdcp43XK8aAzIoZY9Tir9WvFSusHrsqJQd
 reJ7uochhrR6Mhm+Z+XkzGK5VRUEvD1kyf8B06dChAd6ZCUd0Ik2Tyr/pDxOClqzZMn54dQlX/z
 hA9lJBE3SKLKPZH/VXyxtQcdU5Y+gbxcW8SsQoRg1kp3g9UDyunNYTx8qTS0l7u6NYdWcycrtn+
 Mgx5XreNwDj2XFw/VMQ==
X-Proofpoint-ORIG-GUID: lMvIJZPuJ2It3141oTseGp9zWDHKUG4o
X-Proofpoint-GUID: lMvIJZPuJ2It3141oTseGp9zWDHKUG4o
X-Authority-Analysis: v=2.4 cv=cK7QdFeN c=1 sm=1 tr=0 ts=69d70adf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=U6JzTy5AYZHMq5zM_AcA:9


Yang,

> If device_add(&sdkp->disk_dev) fails, put_device() runs
> scsi_disk_release(), which frees the scsi_disk but leaves the gendisk
> referenced. The device_add_disk() error path in sd_probe() calls
> put_disk(gd); call put_disk(gd) here to mirror that cleanup.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
