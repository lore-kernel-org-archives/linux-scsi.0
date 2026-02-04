Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FD43EBF2C;
	Wed,  4 Feb 2026 03:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770175919; cv=fail; b=V3wVDSQTI9tOajBNfXldkr9LEhDMFmbOJ98eBr4LOxsBR+sG//TceevkBKDqTBdc6D04gD+fCWHw0SxE4Ot1IZvzXa2wjImENU3pbI8f3uhI/M5K4OK7J5e36Sz9F9u6SAR1RwGN6osBIIyKtPK8x4gNVahLX15nEC8tVpNlL5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770175919; c=relaxed/simple;
	bh=NbmNOHXOI1/FtqdiTgBZzS2n+IKh7RZh0bZq8MCyEGc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sJXJ8DtIe9oZ/648xc9HJKCyfTHVi86PuPbFE1F4LZ5LnMfgLuDsYcaPnu96CHUx0YuC+J2ppH1EKdRCSqvb6rfZ/778DQVYsn688GadWFqBsSd66NMGS4Nl+FKmWAo/2pl0V7kFuIit/5n8A6s4jrQ+7c5g7j0iI8rUvaFhL+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JyqTYMWC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TnXuB2a4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JyqTYMWC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TnXuB2a4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuOQh157453;
	Wed, 4 Feb 2026 03:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DTpY+wme8v5kfLUXLi
	iowHJTl85mpbjF7KeaKsRxN58=; b=JyqTYMWCGhmS+YytxxoFxkc0ON2fslL+HJ
	hSb57HYohxbJKnnkn+L5Sg34oHMXm7mH+ZMA16OzCq1XMkFPRE7LfOzZPNj+L3VI
	tw8UOQa1FuFbmZ9HuT4jRF7w12rxB6bwrqsMBlvIGgAZPuU5SLY2gBT5gXIui7f6
	n3CbgHvs0jKoahuvw42xnDclsUAunRexbGiyCQCKFSjatDhQGDPATMgA7AnbaujG
	Wi+2Ja7TXtsf/nQxiQEZq4/Z0lqflqT1DmfozF4w6CCBSUvDfcbW66Ud695a2f2m
	MbiMEXg9gPTIevR/63bpeZ9X260NByRXnq8vSNRWlljS4PQ5cqVQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1arkw8mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:31:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61433WFJ002141;
	Wed, 4 Feb 2026 03:31:46 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010020.outbound.protection.outlook.com [52.101.193.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186ncaff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:31:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deH3EuulXOQ95tsTNhpre3w32YfLXUb918DqdgrOjNYkqgIUObDOH9t/kvEAeH1L1+atUSUrmnylOyKOQJfFNjliq30DkeP6lPa3vqUuPDITkyga11PLyc1Jbsde6Ain4AoleOizftllyXzM5z+pSV6eB+x1KNfWzYDJ2xn+JeqZ5BCNLgcShCi9pIbU3bt662XYesVgOGKw0BAv+ZVaEv4OALxP01iJVstgFORKgZfsV2c2q2BqeWI+/NN9Dm7zYxpoMGpzhDL7e2DwzNqr/Dvww6LwHhCd+CCs0RCGBuNRK/DO/y+OBDBXCuewL6wPkoamBRr8/AU4BGi8G4NgDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTpY+wme8v5kfLUXLiiowHJTl85mpbjF7KeaKsRxN58=;
 b=rw4v1bO/zP7REhPunwH12QJR4HuiB6X+SGDcpwYuTcB7KB9aOPC178zrC6Lw/0Y7li41+qe2Xmy7kDXjvTE/Q8R4sBsOHJb/1SHy8pCTtCwhbrXDd+DST4cnOVguOQ8r3XdgBvQI174jj9/3bgGdJo2096vE4HLeAVPaiQA58kV5gbORLl87FdjTb39JAorm6KGPjCalZ2A1rL8hc0lE1LQzjL2+Kdzrbd0dFNF2r7ayfB0JaLK2toBVNaOt3KlKccwMlUgqQK9lDkrH0TT2uk9ya4pZbsvGa/+LQOJUH/rTx2nz5WPYdKoc7s/3a5Dh27kCa/18cBOhCxE+3BfC6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTpY+wme8v5kfLUXLiiowHJTl85mpbjF7KeaKsRxN58=;
 b=TnXuB2a4lNOfCpBzmLp0ob/z7GCabenAq9EFaloaavLPN0/Jztr2cdmJq4vDh5W9kLjqCtSu8vgYx0fvJQgFQl2kpF2zJcLlzO9bl4/p4SU1WK+C5ycMHRIMpNsDJvE2aQTI+w7d4YkxrPqZBHz8A+YyWwaSq3RKnvUgNSDwq8Y=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Wed, 4 Feb 2026 03:31:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:31:43 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Al Viro
 <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Bart Van Assche
 <bvanassche@acm.org>,
        Alexey Gladkov <legion@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCSI: buslogic: reduce stack usage
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260203163321.2598593-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Tue, 3 Feb 2026 17:33:15 +0100")
Organization: Oracle Corporation
Message-ID: <yq18qd9nq0c.fsf@ca-mkp.ca.oracle.com>
References: <20260203163321.2598593-1-arnd@kernel.org>
Date: Tue, 03 Feb 2026 22:31:41 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0033.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: d47ed824-b99f-41d1-ccfd-08de639dea7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ULcayxlM28IM3bWJvrtgiBk182/rGn2p/+hBEklxrgyxKeIAXsKvldCmqX3z?=
 =?us-ascii?Q?zPibwOspjyOTcNkmNl5HrLCpjQu52OUjX2wDUsDb6gcqzx4XadM/ydLrsGtn?=
 =?us-ascii?Q?YCTfPjG/3bisTfdqLnDcptVC5phCOG/wQ2tlMyjwr4Se+GVcRd5n9j9oM1nZ?=
 =?us-ascii?Q?sAdyeAdIiCiAMZhDOuLAsruifgPsiUcf7y+FaXnH0opgCm97Wrb1kwDVLZuO?=
 =?us-ascii?Q?XUGYtFg8A3xQ93wpKktJ92UKYU4+6rZjLta8D0U/PhaYdL0yzavlqviEWSd4?=
 =?us-ascii?Q?eBintSiSPZusFTA6uQ62rf3K1pAeBcXxjcrBAY5vb36sxaFi72g8dGYnfyHU?=
 =?us-ascii?Q?b3cqI5mRQuPS3TQMS0lm8hfVCxafhcEKhLULdZA4NsLqpjF7k+7E+MIqrR2W?=
 =?us-ascii?Q?YMFM/KstxWW1uWh+CXbjHb8VmQPFEuuKwjYK8suryXGyZPpnA49SG5U7ILty?=
 =?us-ascii?Q?Np62YC9ePPsvDIXhYq8/WLJSYXVGVdvdDc4EtKMF5ikZ0nJoV9BwM+3LtV8/?=
 =?us-ascii?Q?zGkgzE6Mdm/C0NZ2T3PfhLCrFsDu/+MWOM5RCj6t54zxWOnN00Ll8WjziuYG?=
 =?us-ascii?Q?CyZ91x+f1C64Ty0O8OCL6NMQCLRvHxDv/jUsANLbx47jDN9emZssu9X4X8M4?=
 =?us-ascii?Q?X04JPKS5+ZHXHOim6AJ4EoYO0qSix8jqJsoPWX9YQqu1xSjhbQouOcSWkOUW?=
 =?us-ascii?Q?fP0z7NDvj9Ygi2Jg6NUuV0TF9QZWulY36imSvX859PjCyCzFi48clDwRWuaY?=
 =?us-ascii?Q?I+fbndViM0Yib/+VXofMBs0lcs8JpIAWLhCBG9LoY8bM3iCkyg8tuaREO6Au?=
 =?us-ascii?Q?kB3iXwwdpTJ0Q7znI1U6zCNPZqScvHRaEbmvifZ/hYjxWQMyD0tvnZvJ0w+L?=
 =?us-ascii?Q?7LFtZAo/W27/P5hodrYUBc8CucVckkbxB22sh+XjevTOVVyi2q11qbvY3YNR?=
 =?us-ascii?Q?Ks14gns+r6sRZ+Y5tlzohjYnMm8NfUJS0Z+a0bnBFA3nPj3tHSer7Z79W2zx?=
 =?us-ascii?Q?2REkK3St3v/910N+F1klDMLdQXHkuKEzP2Zh4j5+vUyJKgzomKblJKMLCEvL?=
 =?us-ascii?Q?OrokxrfPCLv+CMF1ri0sI+UCGdLZZe6he2uoXpSoAEmMLSzPJ7c0yub2g3eR?=
 =?us-ascii?Q?QyYL6/xQi4VdJK17NixyX5o3dXq8z3xEjgmZUE5cLPnbsRjTkBalGcygR6ev?=
 =?us-ascii?Q?4Tnu3/P9Rc4Sm3ELliAnZXMuS4B5ARJ+qDJ+NzKVGYoU2s9kbxFVSrd6Fu4A?=
 =?us-ascii?Q?5Smq6n8Yafa0yOTcRm1YBXcLvvGRLMbsgZ4dt+qtgyhMtE44LJ9xYQAz3p5L?=
 =?us-ascii?Q?2j+ZSm6/TI79p40ti/DVk8C8nHXW0hHTEIiXk+TIbL1WKxPkoWQhFnUg0c45?=
 =?us-ascii?Q?zn8gKa0Q8DqpavxtTTr18BnvqlDuKRKvIsk2LLaknn6lRxGNvL+7NsoC+u/+?=
 =?us-ascii?Q?xmAlERcIlYdVTE3+3B521RYJJ3zb3tSyVmt6DCW55dSLWBcr+7AeHnHiMdT8?=
 =?us-ascii?Q?Mq22aQTBORUtvZkXoHkDydLjSwpF4LVyx027dQQ9NT8N3GbiHz2qK07QXKd/?=
 =?us-ascii?Q?BJKRsfT+cNDXOtmuc5g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CgGxurbL1MI/HPtJxVtopCDjNyAH8UYeCIqt8S/hYop/IULxhI7Jf2HkpLtG?=
 =?us-ascii?Q?hq4P9gidiNgYL2NtfXkBI6MBxW1+33SEQxjRTqn5s/GKYx9kFOzdZrKFr+ep?=
 =?us-ascii?Q?5pmKRuUSvZYSK5egKW7EyNJQVXmS86g91H+Q1U3CsH6fTkyea5Wwi/hWEUTT?=
 =?us-ascii?Q?6Vj7GjAdDWEOGf1i4YSlunkCmDDrUR7S3p5kjUgI15arOZnq+OcHbu5Iax7j?=
 =?us-ascii?Q?szujtiS2exgT+QYx6z9n1cXzIlWLmcnTPaxd1/JxH9zGqHMRxzR7MYwsCAI2?=
 =?us-ascii?Q?j+7Nb/137nldzVxOIRcSWlkVMjQyrMSY9JXJqma7r13MqaiBWxNdo4FGjM2d?=
 =?us-ascii?Q?wz/jVg5oeuqJiNW8nMq+yFA9h8MRMVnunwVWxNGVb3tsrbFC+DPpEhIVxQeR?=
 =?us-ascii?Q?7BOqQXD/giu+f1DEjI7AX+A7pYm6cOBaxmH0um1cvwY9QlOQPjIcTBlyCVx4?=
 =?us-ascii?Q?zvXPtCkXgL4SvwAAeYazGBFsfRPUAJLoP23HZKMTHMKLBKmZbhrPs0rXwqbC?=
 =?us-ascii?Q?IWJWtG/w8XXzauuhMenf03mjCzp3cxmncJC8CNzjohwZMhny4HHMinHL1sOe?=
 =?us-ascii?Q?FDY3VbNym7vShv38NFkz02z/vugX18reoMyy4PoblST1/sGgfiGCVPvU6IZz?=
 =?us-ascii?Q?8vEV0DUu2EdThHo1vY8D5XRMHq1HOhj+a6NPhxFseCAIP1tpQdrDi5SSzhV7?=
 =?us-ascii?Q?rrsJ1IQ1PeZCFQ59SEArVKn+bHGEb5mpkj+E5TMus151ubPO2N2KmdlVBnrt?=
 =?us-ascii?Q?kKfe55LsOKaDngkGyXtYOuJQ8pdkNc6U2vSKlxdiB1ukyF3Ad/jGBuq11aWS?=
 =?us-ascii?Q?1xV2utXkWA08k9sCRLqpktXH770tEWD5xYnbmaPNGofkVgNbYxZgKRmAKJ+A?=
 =?us-ascii?Q?3xQWF6rfgxmCpTpf17l8XKOM02m46mTbu8W8OTQnf2bQzk1NfmxtpTYD/+FB?=
 =?us-ascii?Q?pf6Zyz0m3LLY/AzGr3bc1kBcNg4eYlf8COv+N4NrHWeep+wzpj47VT81t1Er?=
 =?us-ascii?Q?54GIuheXjRSugjyTkQxMOfyOfehA4YtANWzngKPKectbZUvwUJ7V6btwr3Oh?=
 =?us-ascii?Q?c8AmD8vNYQxH3dFGRvPRmmw6YbThQyeblzniLrZO+im8ogS/gVycGLJZCH7j?=
 =?us-ascii?Q?zsNaIBwBJqysA1rtovkCXbSoUqpvLZ8qDfzfcvn4t0khMZGu39DJsKir9ykF?=
 =?us-ascii?Q?acaMga2sOe54bxyQ4RL0e31/jp2M+0vqteNx8GlnALfJmxHm2t620jM/1YYf?=
 =?us-ascii?Q?I1vHoCSlkepPEgGQVIR5CexHyLHwk9fEXi/D8EsEUNbNRWZ272Xgp8eB6l1/?=
 =?us-ascii?Q?gQXIEkkuLpb9TYjFBHOjTv3zKgx1lQvIv/+hro+Mi1IpjiCR30t56sZe8WjU?=
 =?us-ascii?Q?WhrWED65IfYK6z7xN+ZzFTpiq3ADK7Edb5uvTJ5u9KoOT2JFQu0OCcB+jZ1+?=
 =?us-ascii?Q?dhi+rqrjyqybqiXTt5MR1PNJXw+4yRJZyy3vjRi4fYbJy6nGWO9+pmN6dVb9?=
 =?us-ascii?Q?UFGkyoDc/YXm/P5KpvFriA1h0nfjwo4uRm4xyRInJhY4AgzInJFTz70QrkPp?=
 =?us-ascii?Q?RWRsW7J/vK0ivaKz2duQ6gg5mjlZK0ldJx5nJjwkBfeMcy9KGZ/9lXeLN6DD?=
 =?us-ascii?Q?LFFVY2e6Ot03q9w8dbI0zbSnOw1nD3xbrJl6vit9qDQ7Qoik9Gu/xGelx5Pi?=
 =?us-ascii?Q?nw0qx8Gxs36p45z+hRd2cRDt69i5w+UPTHXoZkL+AG0hVIaFYFCc/sUfYC/9?=
 =?us-ascii?Q?coYA9btYV6T67ujGBD++SMVZG56qtKw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ia4IK/Itz92ploBGF1WhWoOkyOgR6I/brqs3eq1+oAC2dSs4m3iBguy4zIo0ICxBdR6CLcanYDjX7XJLF1YTYvvxFNLIXs0ZvdYjYOAZafHb1UmvW9LsRObl9mvzy+t/3WdZSggdp5O0AJxBkb6Ujx/jq9aO/sM0HX/xh4686Yc9OMqqsDqrNARND/xZQNRXbTpHYzgR5tY3J1ZEBZ6CCm4Bd10y2dlTy0p8rtDA++apzoqNJ2o90V/caLVZDc7ZnIAKwzY+kOpETx+wi2T7hz5UkqvIeoFAkHXVAWI4ISvWUV4WGBZifQpRfB5cSAZnFmh/s0XMX/QlUW8940K6pMU9Xg6MtkfgKBKNlQDdTQ2+ZffI/M5wkLM58a053n8vudJNbUZK9iNvOWAFnxO4XRVq1Bc0K/fcdvsGyqDtvw6f7cYQZW5mOlogD3UOsdVbKi3d475M3RWef3SGTjkK+a5uwYoukQ39Skp6sKnYqQkiR2cjbzvcfV+340pQt7Nh+IDrO8ghFRtbwppblE/NqC9EQmHodwiIB04b/fl4deI9T8LvNWUJjTM43FLYde1JSy1cV/VSvL84hJiZDjIZPSx3Ry5gPRvZueX+S6M7Tp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47ed824-b99f-41d1-ccfd-08de639dea7e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:31:42.9326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhl619i/P/35qxbMYnPYUIKgjM1k0nEawt25UNr2+Yy4/HDuZuV0C658RuB5e7DCvcB+fSQP/tK4fBuf8QcAV4aFCAmHmqj8FW6PO45HVNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=901
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyMyBTYWx0ZWRfX3Z3oCINWidsu
 Jul2V34iso1syfYhzxKQhNn3knLbMgzaFruXBawvhjaHCeer2OOjw1YQYSRzzYPorCcYApii7PL
 YQ76Tf9t9dakvuAyJuGq0PtMRMfy2mt+gJl+ntvfha1Dtbvwf4O5ETa1AyTYOGFmlXaFSoC9A4l
 P54XuRf0zVixvJwuls5cl2zweGO+eov3w9TSBpU/8mkBTRxBsJfOcOqpeu2wd2LxBxfMhGEpG9H
 T7FQrMB0pgbZafZ2Cp2KZiUre46rJ3JePl58HBpx4WHImfwfELvgwtIy1BZHhUtVJBFU3uuIA3t
 XCcifr7A+PBUlriXGk1N8PxSVrttIjsNyjYhVlV5043mi+LJwgou+jb2QeEX0vj2raM//jsy4hy
 KURqphDcJ7jyEhFb1YsqesFZPAIti0j0oUKyj4ATsWmhqIWZivhIkXtfer1BXlc8owYgNUgwUm6
 6QTkHaOFyEotT5wrvK0p+lTSDGEEx00+ZXOhqQVY=
X-Proofpoint-ORIG-GUID: DHMFkSpOeRCEI--ftNjNdLCjWxLT9WN3
X-Proofpoint-GUID: DHMFkSpOeRCEI--ftNjNdLCjWxLT9WN3
X-Authority-Analysis: v=2.4 cv=VfL6/Vp9 c=1 sm=1 tr=0 ts=6982bda3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=mOkO6mnTCWDz6CupU0YA:9 cc=ntf
 awl=host:12104


Arnd,

> Some randconfig builds run into excessive stack usage with gcc-14 or
> higher, which use __attribute__((cold)) where earlier versions did not
> do that:

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
