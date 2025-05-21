Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33E928682;
	Wed, 21 May 2025 01:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747791061; cv=fail; b=GxX2wAjaWRrCu2PUqyUtwUhNMcP5TaBuCJetq4vhFk011yHpMUe2AxHTckZiwJFRTbs5nzpr0TQN9zHlr2bmEmML01FZm2rlGjIvD8RGYhfgmwFheRzcRfpU+794eBk3QzDTDu5Xh9TqIGvd2GT8itRvQTkdzkUY3X9rGRIUNqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747791061; c=relaxed/simple;
	bh=OGwMZSA80QSMsziOheio+Bt2pz0ITq4AKyh/VQ4ssgo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VI5DjEMaio01Z3i3VVwf+6IobDgJA2SWaQkxieSCZ82qpazZD5B1HN7hKcLrcZ6AkuVoBQOlFqlQLLflz8fT004PzyaKMLVht4XsCmyoxnemQbb8gTb4nYL45wf0cYo8iz8jiKMc30OZrpMn+JaWWyobexwhGqbzlpGfFZdVUtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ROE5Cy9p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ERtq9Lfd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ROE5Cy9p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ERtq9Lfd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1NZmw026312;
	Wed, 21 May 2025 01:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j1fcha9dZDeD2EJseS
	7dvsxnqO4W6/UrRaytcjtkiH0=; b=ROE5Cy9puA/GerTOvJegjTtZgPsBmqAluF
	FMQojTLLYCp70CAqvsn4sVcqwnV3dVMyB/4EXX4Rxibil0Usy6x4pWwLPiBL06JB
	odeB6puDJcYwDmA3gvw+qO+vmTRbUDnfpReqNOf/Qa/Ukc6dMIyunPmlbI2kGVO9
	5tPWqRvkz2Fkz+iw3nftFTrYLfMe+fOlxoSot9c9RabojgIXK1n03xRgUudCSUXS
	07BiymlaKwyNr6fdh0lv/ZTB+ltanpBLQuXK9zsWJhPmHSu22lYw0jyxg7A/BIpo
	eM92U0hKtJpcJi/AeeBA8zek0FtXhUO33XAI1W3lPyWwB7/pLxpA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s53vg0cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:30:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L0lIZ2023954;
	Wed, 21 May 2025 01:30:57 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46rwekrb9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:30:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zTh595YWmfxEoNcyR+C8yeiMsc6Eb5DD1/5GBN9zWePkT7I+NnGJTnmM/qNZaNrzziVGviJLluIywBc46cpPqJBq9BTidnkPryTHyA7FGe0ldU8oQLpqr7DZ6IS/xMp6A+VgGsi5ADB7zVQP2oZF7oDOvOInP0l5URH+iPelAK6dSCPcFmv4FujnRS52luCbcvbZCevxGrsyySj4l+tjsusOKvbmL0J0zmhMYDG8aSefjUji0eEF+JbmjlC/ssVcB+IZ65vNP0RvqdOADvBOKKsfgUsw4vvCa4XRV9/Mq8xe6hOvSMFSCi7Pb7Ajows1PRzsAvjak25xoiOegQy9hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1fcha9dZDeD2EJseS7dvsxnqO4W6/UrRaytcjtkiH0=;
 b=PgOEmAWtIZbQOThxS2G/M1HF8EhUHJ+0Ccqi3LtiJQlQQ5sw5kSDzuqbbXIKoLT7CXRcBEA3EkjmfyHZiKRryD/DtdUCpbQjfBKJmbNZiKXwAzUbkBLwn1+ZMxoQs7vj5NJT3iXzCzUp6KuCOaU6lQb65TGWlEf6ewuKFUNaBjApNjy0xYgUOXkrcVex3G555Nw6t3Tt3IIOz/bmv95f4Wp+WuMVeHLB6DoZcKKWUdy/hC6kuQnnElFpQhls8jUYN8cKbd4DteQTwbt5W/C3pq8MG83z+8v3WR//GDRbY6uo47iucr/RCMO6pb6UnXCB3RCYDYN8hhiYYyhjLR0D/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1fcha9dZDeD2EJseS7dvsxnqO4W6/UrRaytcjtkiH0=;
 b=ERtq9LfdL/A6o4cuBSEW2s4ODjqlK+D+owFV4+/TikbA0hJkryFdRvkxs6p1MIRXCUAohRVSHjChu4PB2SuTvAc78Z93Uac6j5KY9dxZGD7p2wwDsNCEnNEHJLM7FkguRwkfq9MVCu/bjHBoURHVNFPrfG/UBCBHy2UlgOVrJE4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PR10MB7945.namprd10.prod.outlook.com (2603:10b6:0:47::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 01:30:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 01:30:54 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        darren.kenny@oracle.com
Subject: Re: [PATCH] scsi: mvsas: fix typos in SAS/SATA VSP register comments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250517192422.310489-1-alok.a.tiwari@oracle.com> (Alok Tiwari's
	message of "Sat, 17 May 2025 12:24:10 -0700")
Organization: Oracle Corporation
Message-ID: <yq14ixen41p.fsf@ca-mkp.ca.oracle.com>
References: <20250517192422.310489-1-alok.a.tiwari@oracle.com>
Date: Tue, 20 May 2025 21:30:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0086.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PR10MB7945:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cc37d8f-0ce7-462a-fa28-08dd980720f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?no9HOziKEQu6WR1lE9TS51IURDhhVYASFe3OrrwxQNsG7gWv/HLzJQT2SKgX?=
 =?us-ascii?Q?qMqqnkWwLgflSXLHLGaFVfQ90kpC7fGWnmfSjwa74vedB8te7kkuDsNm/sNe?=
 =?us-ascii?Q?N9HsTydrDqHQFAAZMQG/3sdBkHnvAuP647X+nHQm0ONKS4/M+OO/Qpv5fynK?=
 =?us-ascii?Q?66hFUQjUt2LBNNMvG20UeJ5LO2XTU/htJ1Dae6bOdx/rjOl4hzfrkc83vDmv?=
 =?us-ascii?Q?V+mO6lVr3Tu38k7JMh/utmqATaG1V1eTK9rpSFpc1O/rLKd7kR6RKlYjJSPB?=
 =?us-ascii?Q?HNdgBXP4aGNqXdPfV8EoOmBc6Jsgl+aTGQxFk5LGC1gWs0/6dvic/ISxoYIO?=
 =?us-ascii?Q?QU0HUwoy7CnmUn2BqaxKJtWwaMndlZR6xGsZdOPuB8WvL0mYVMztKM3/0aP7?=
 =?us-ascii?Q?4aZhy8P31AweT26kEDr6NNa/Ufg/PCDL96k6CTWti4crsaGf9+goUg6QSgr4?=
 =?us-ascii?Q?MyqVG5g4XbTqFC+CVg9Xylmh69A2vWHdclW6Y53lzgrEr+Zxj6INvaLeG9IE?=
 =?us-ascii?Q?SQtMmpN05P6kASRG8fhEwyvh0Fv3bRcTN8rI/Q9+Rp3opdvW/NlpqCSAa9qc?=
 =?us-ascii?Q?sEyUsWrHUmJ4KRk5Ie/MsWO/esj5Qg99Wl8xd2t3nzpPcPzfYn7jR1mlem2S?=
 =?us-ascii?Q?v31Ai4cESiqq7E5ZNRBESXqsWakXciyy3m2ySVpucepKl1tDCBN4sjf3lABA?=
 =?us-ascii?Q?c8px+JtnYGr5sqjCX98w0kFYKCjkDFAvk1fypRncQ2nM1YQyxZDZf/ykzDoB?=
 =?us-ascii?Q?iHmoDicR3fybiR8/We9cZeNt7m71ZvMYrwuy3WDBya4j3slbd3yyEnOq6bVI?=
 =?us-ascii?Q?xBAdp1iiBcd3LVwpB8y8OP20x/fts1E1951PPoeNp3JLxLA5/8Fkwbttr/Ss?=
 =?us-ascii?Q?OZ8/Pw1S86qg4VB4x7znsL6lDvG3Hc3a9DDaFZauKgIU5Mrn8KQRXhQ8TjKq?=
 =?us-ascii?Q?zXZNOXPmgU8IMXffRmD79p3ig4UgOxPl6BjVb22doqT+ljoNWa8nqJK4LY2V?=
 =?us-ascii?Q?KBWCKrbFJ34QUO4+XLr1ayGyZ104PGBAm8IZe/dEWBn+Ir7AHeDZrTUHcSGi?=
 =?us-ascii?Q?/SC85gGRP2242UqYkg8pbUnvozHtdvKN9FlGwZHVCQ4eaWmMFVMUMNlnHjHM?=
 =?us-ascii?Q?rMJJ0irdISqNVWAG2hfVuIVWO7cRTpnn1qkrJsqUZYQWs3xiE5b6T/t4v08h?=
 =?us-ascii?Q?OZpZtQqMjTtUwpl51+E5Cmjsi0JPzbbxVYu3MGKsecjb3BlwD4uUVEMOJY6O?=
 =?us-ascii?Q?6UbD/53kOkXt0J5txlp0XEW5i85flMrPp8kIgpyR1+EhDptliP3JZYL/lypJ?=
 =?us-ascii?Q?tUBe5t5oorhzz0lNQmdPNUvf7j3yiONgjOiggIX+1KFNYyeHRLyJ6QwFFPRE?=
 =?us-ascii?Q?NY1Bw40H+E47sGLhn5Qap4RuEk5adEGSnaNsYe5AIXMcWmKH8pHONl7T/a0o?=
 =?us-ascii?Q?J3P9z5v2mM4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hHHZfr1cbkard3A394sOGPPRvCn46qVyQcdpE11FG+ncAVVNpOakA5c6f7c9?=
 =?us-ascii?Q?2Dz0AMGA+JpBJLU0IaQAswGYSGryhvYl9JmNAA/N2ApQP72qyhXXH0/eG9ZT?=
 =?us-ascii?Q?rNc+XtsaPUmWMMm0uMrSPVoJvOyfn4kEo1RLQ3S/cIEvHCNu+TzssipT9NcM?=
 =?us-ascii?Q?joqfWeleb29+vHlQP2ASHUW0ELG1Rhk6i6rMyziLlSZCVyA7U0QryCu76M7p?=
 =?us-ascii?Q?fsluq9C/LG/+cPrgxhUxeCwnwjoZFmXhiMvo/bhLfutPnguvyH5rd9FdTr5m?=
 =?us-ascii?Q?VlGtAuA3qff91wGpg3r/O87q0q3kFp3iQ9GOOF4Wz3fzt6GDoQ14CH+itob7?=
 =?us-ascii?Q?ilraDd0FvkgUur102iBrJjUWeAFIy65PERPEZKtHRVPd0V1TUs1ZjvgysnfJ?=
 =?us-ascii?Q?YfV5g1Z+EIoelesmWq8WAaPDJrvFIHCEd/GSezb2Zu5PzNWrO3jfJ6R44kBU?=
 =?us-ascii?Q?iIVxaAscV0BZcU7ysh4nCmlCQE61s8tbUPrTfgBKFgXcqyK7YLMpapprp+0R?=
 =?us-ascii?Q?MCojtiGkldVnCsykJ5H/LbQh9hQ3J8U+XwaZVxk0ClRxQVYgHd/SlDQAU71F?=
 =?us-ascii?Q?E2O0R1renW99zntmeJh1PMNtKgz5Zr71x7MCmvZ+WVKZ2QzAWdWlFnKFNYdK?=
 =?us-ascii?Q?F6/Wjg3XgrQM+IGRNEqpUNXjDNrO8h+GcIalPps4L4ti8TftuDHSUYD5F5yH?=
 =?us-ascii?Q?DABaeB4J3V0bXAR4/HWVZVC19pQnAIZofKu9T1jDnLiElAtSrAHVNPa332D+?=
 =?us-ascii?Q?yRYrTwW1y3p4NAYdhbmFZaihAHhyfReBM9Yn8MXTBFqWzkHnN5E11lNsfH2v?=
 =?us-ascii?Q?cP0kg+wHe9S2+bBFW+C0ulhmzgXMrLTDXqaUWpHNr1k9Cl4qBoOWwSrR5DWQ?=
 =?us-ascii?Q?4tqYayp/ywu2uf8eOnqaLVeov+tupcn5x7VbLyruXKwnn0pz9FpsartcK7mY?=
 =?us-ascii?Q?r/4p2GeJmuySxuTFZHDUj4wZZ1m2PwAMjbySFq3hnRpeTU7iGvCjplnAeYs4?=
 =?us-ascii?Q?9YW1xzFwP+fpicVB7SO0iHuY9nHE83zz4Adxx9RjwYt4EhgMzGZGx5I5vbB+?=
 =?us-ascii?Q?UHhas+11oaXHbtS0snjUlbQNc4JPQEEvVSA821sWn3crE/RfSQ11LVQTvS/D?=
 =?us-ascii?Q?HkRJbu+dcz+V6ABVECq8HePjehFrYtnYZeKhAS6aIbwe1RhyyUMdlojyBcPS?=
 =?us-ascii?Q?WTn4bRzOBgEwkRefl7TGZREJkiAprtthfKdyYGgH7yz1MZqZ+gcB9yaWct95?=
 =?us-ascii?Q?fa0yM0+qgrpsxam7sY82dZJEwtYilS9VnsEyxUajvrqDpy9HcJRBJgOifF+7?=
 =?us-ascii?Q?99WaXFBBb/CVXgYI0GfceE6Jb3MJDHtBZwjZltRLvMi/xiD/6wRiGJ8g1zIK?=
 =?us-ascii?Q?s5z/Cw/y7jRU7a5xkgmx4RUQ2wbXUDeP9lj6Oj0Q9RxDF2kbcME+ECXCr5dU?=
 =?us-ascii?Q?sQ0XVlLZux1XIVx4fC3EhE7SdpMNEBaolp9QBCL9bBZqMD1CEeZIB9FT9abT?=
 =?us-ascii?Q?NKX7walU0BLRAKk+IhsVa2jRU83Ebqjkq3ZKOgs5D6Go/ZFtTzCNyNEUbwzd?=
 =?us-ascii?Q?99FIboB5tgL4mJpkwv8qyONd+u8gbK0MI5Z0ebSuVArsZQlguBoo1YW0ckbY?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WyM5BcewdgxRUD6uMtxZsYIxpzazj44R4YwNi3SZUMSPKCNqPvcNBi20B5IhtF2z057NOwP4gZTJSosF/Zomxi2b/MPJKXonCIjqqb5exnRIusVWIP10/mdgeOoCSXfFEyZ1tk1AXG2A0N/8AUlEI3kkhIjXYthcfc/y6kN0OUcOWvAUiwhBhj2yf08ENxLMkDW8bJOYHScswo+UQIyJNSYgftEUtg39GhtTyMwZbH6SZk3j9YrNrjrJyw1afmoBkio5xn+Vb9hvsemY2DPikvFkI3dVYzh9mvPZjJrtfpLtt70SbVBYchOp75UfPI7PYUbd2nydkqvB81mhmpy/NvXjK9MfpQJb8CeSZOWFj/dSNo9i8plXZYUby20wggok2q44o4mjMthHKormx70/vdbVxcN4mawXsMklEL0eeZdHe2h4s9yls4F4ny7jhnUMCDk2X11+VVCPKvzHiko/yNkScuvrz7Fd5Kv/wsxfw61DbMxkmdSkkVEmebTHED1EarnE8E9IbXYcbHih+WeD17mf9O/ZIE9Ce8rpGyRyTbms3OWWAH8DExYNgyHxi3LVDQnIaXwoRDfLI2QaJyufoBLYdbqLUf1rY1BLJ1LSzTI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc37d8f-0ce7-462a-fa28-08dd980720f0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 01:30:54.3648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKExSBCvYuIXh2jTaxaPkycjvZozGmBeUGQYiyli36sAQk9kovVU8YWUhrw18J4ClyL2DbEi7PhJxGpXz1eILZi2TRWRrtp3qlUQzuiNsAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=861
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210013
X-Authority-Analysis: v=2.4 cv=cKrgskeN c=1 sm=1 tr=0 ts=682d2cd2 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-GUID: gfrYh3367RpWB8Icfbmc55IO6zbG0yIC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxMyBTYWx0ZWRfXxz5meCrfOoSG Jg1CmxPkqoJPgV56HIAaBv6BoMlyHPrvD+p1jwfOlw/a1twtYbDWgJBFz3rTQNIunVFz/e3RvuM xdwgHoXtpz5Eyq1gJTtSWoHK/YtMML11DqSU7c+E/DtTe1P1NC849tpUH88YSqPuSkWO71juTkQ
 e+RTUBZbDfbRwus1TBoKvhCgsDrZ2Qwmf7Eu05gXrrGB2Hmgw6Ohz3ofFor3JzoOcmjAst4F4aL Ka2qVcF46iTo39eOKBGOwwNd83gmKMpv8iTqeIb2zXyCxNLcnukChe5mmF97+AKUzLhUQTHHnC6 jRoacgOGZrZFsn7uoxTf2B3BnRiQqmWClJvPmuYoa+ElSkOk6nBf/qnK9fJVPrxfdJm6j240b9H
 ITsN/oVHx3THfZ0OYLd6GUmxhkMfLOj2x6ziUmZsDWZqHm5x2D0pFCLaelMXiI3K4A48LQn8
X-Proofpoint-ORIG-GUID: gfrYh3367RpWB8Icfbmc55IO6zbG0yIC


Alok,

> Correct spelling mistakes of the SAS/SATA Vendor Specific Port
> Registers. Fixed "Vednor" to "Vendor" in VSR_PHY_VS0 and VSR_PHY_VS1
> comments. This is a non-functional change aimed at improving code
> clarity.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
