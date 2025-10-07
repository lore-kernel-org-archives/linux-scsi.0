Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B480F7464;
	Tue,  7 Oct 2025 02:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759804006; cv=fail; b=uVu5iodC/OaNifDcbvhIE32IXWmev7kxRboFN6G5lJZrmvo04YakgI+pcctNFgY4M6SDwpKwg6myMih/J23ISkRLrvP4Pts5MgYgFnrqrDqT5KPBlHClJznvMWij2ETV3LvAhBXh4RsCSNMXDI/nHvHVquspxP7KmN+rP80nNLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759804006; c=relaxed/simple;
	bh=MWhN/AznmZilmVnWrd1RB7hNusS2Z6hZVKcGEKC3azY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Q7ReZwR3wHrvLzY/9lxqJUK2OVeaQvblXQhyUTNx2qUKhv0fKggNqXRbxO9QPqWcsdmU3togsmnXgY9aISSURtV/CJ37OUWIzeypdjyACpOS1JeCZUr33uccmblTqtBmz9xkzPN5wvXZ0b1ddhueaesqjYNH6DnLVxLFzF+PRBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SuZ5WJca; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U3xc2VeF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SuZ5WJca";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U3xc2VeF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5972DAoP024738;
	Tue, 7 Oct 2025 02:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qcQ0rT8nAtWfNkQdiz
	smIZqw/41V0OnYg+UvLQDAaT8=; b=SuZ5WJcaP8vPYQKC9C/uDNxEvkya+Fito9
	+38lSw2M67sM1oIRNVqr+qXk2vyc6DXqvuNIwBpj0Z5gaOc0WTgi7IK2E3DXPuEk
	wMEG3/NX40xu8LBV3WZ43/aQVDtxqzkIR5Jmlcw0lj6wA7xrMGGHaMkDa/6OiKeg
	35noGgbVggoNAwvSC/JH/MvGhQ14GvgSo537S8gt10KUO4hq/4oNXRziBKT9sgDi
	rg0f2X4+EyWmFjO9qvk4LT46VNwXjvPjstpvIQp+doLOOSoOxr8PiCcwfvkKSazM
	USIPdys1Mod6MPOojamzf2P6zxcOX35xx3paZ25lCWqZtdzm/K+w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ms8a01ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:26:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596NZfmC040905;
	Tue, 7 Oct 2025 02:26:41 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17u8u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:26:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qn6cYhLHfioGyXcoD+N0pmlLYKSBNzS6zUH58h4CAszyQs0axD73lGr0SSdVgev8fl3tawphqSoWSDMqWOU83jdu6rzvuLep7dYuTGljeOUPH0jgTSYhm3xyVuScTpugl+faV0VqD/5XGAF+kJa3upApyiUOd2Y72fTgK9Sh73SzmvZMgY5Uiy0yTMxMXsgg1VifJ8xAFkUXnydvWpQWquVbPO/WCAcu7T3pQ9wq0kZ6DrA0of1GkXeZNNh22C2YUfzMrxvibB2b7uORKAF9S5uBezF9eUnefoyqJRcvHBdEjdJ+B1Hdb/FWX/Naiq0udNmwfWGUMI9rKx0vy+rYuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcQ0rT8nAtWfNkQdizsmIZqw/41V0OnYg+UvLQDAaT8=;
 b=KjCFdrjzX+3t1altbTljYLNtP7fzg16YyUoN77/P2/UJguBVYkbXguSHvlQGpYGxu42vZAnwBUKVRFuvc3eZ6aElmKKfssshGEIGSx4vYhSsETmwKbnogYswrNDHH0raQXvEdRr41aQ+dww4tFyPf2w4paRO4+Aszi/l6j5VT8rW/oWl6H7BsCwZwCGSU5ZIZq/VZQAdoTrGYc3KGSBcW4HJ0QrRqhHuRr10ZMIveoR9FSHt93ZtVckGBalOAvsju7uyg4s2kO27g9y8UH9u0OIf0lAdCL/BgP3Ttga3Qqu4d/HrzP3rq6fbLPKAfoss0eSTsm97uUFd5MDOgXsGaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcQ0rT8nAtWfNkQdizsmIZqw/41V0OnYg+UvLQDAaT8=;
 b=U3xc2VeF8HvKFbEVSx1ystJNTyeyIylIH/DC66Ul2bn8VhxKjVwz6EqLAwnDganPLQuZNwkIYHPg8Jng1sro6bGhMiKpG43wwjKnbsBAFRxqApUHwBUZVmJ4A8qn4nbtxS1aP2oRH7fj4OJbkJ5P5yrBmOgogL19rRSjTMsWeiY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6643.namprd10.prod.outlook.com (2603:10b6:806:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 02:26:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 02:26:34 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: <njavali@marvell.com>, <mrangankar@marvell.com>,
        <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] scsi: qla4xxx: fix typos in comments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250929092559.51137-1-alok.a.tiwari@oracle.com> (Alok Tiwari's
	message of "Mon, 29 Sep 2025 02:25:54 -0700")
Organization: Oracle Corporation
Message-ID: <yq18qhnfnw3.fsf@ca-mkp.ca.oracle.com>
References: <20250929092559.51137-1-alok.a.tiwari@oracle.com>
Date: Mon, 06 Oct 2025 22:26:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0226.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6643:EE_
X-MS-Office365-Filtering-Correlation-Id: 25002fc4-665f-407f-a67e-08de0548ef15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uJDj2dGWjIy6O77gBeqCo/oLW0TIuPbx5LP+aMNfqhgPq//+GjJShyupq96y?=
 =?us-ascii?Q?g0DJGagjizsY+vLja/i2Virx8ZKVQd9YbTYfbwQ+ZihEce2N6jFkWnQF+hjD?=
 =?us-ascii?Q?2OmxAyp4otXskI5nHScx8TMxhIr4KbOYnlif6grRiGkx6C/8hmuU0fktn4bI?=
 =?us-ascii?Q?T6Np2Jjvf/r9vTVyMGZCbWUiO3QqfhQwqSgp9HcA9bq8fXob9auCRqoEHZTJ?=
 =?us-ascii?Q?3KQaExtvIXt9RKZB3LW1xuenmZxBaqP+5oYyv1qvx6KO2yMqTJiIBtjmA894?=
 =?us-ascii?Q?0A1VmMnpi4/gA79NN7m+5qz8PHT/PLLJAH2gBYu2KTHlZalAaeXJs4ChxqkF?=
 =?us-ascii?Q?dQJOPLZX68hoBeVflMrV6XBHRu8rvoW4nERwaoRPz2A0xGpjaNw0sPt/h12r?=
 =?us-ascii?Q?wsupNipuELNXhWsWxk+y2ln4gaAlncYzw0RAzVFUxPUnUFR5a/DsOKxZqKGa?=
 =?us-ascii?Q?p9X9vGvD2by0zeoQ1OnVzHrPpkepZMuFhixb9ZorB+SxKcOPhsat18Pk+1IU?=
 =?us-ascii?Q?PzfAU8JM3MfUS+YTs44nzzbS1OEcYLAf5KYsqAh2WoneRu6WrxnynkGuTiLL?=
 =?us-ascii?Q?owCtYo7hi43GVf+v+PqFOjZ4Bt1Mx3/ERO6nJi5cYL/xBvA1oeOnhJW2JFpo?=
 =?us-ascii?Q?Nhmv5HBmfZFTQnh/uQqcg1l37l3gHS8UUGZ+A5x4HqKqHKjUgg67vDiYrKe6?=
 =?us-ascii?Q?2ouruR4pdCTG/APO8TzoMaYDAwClZAApVAT80l290W7+0SEi0WraPSChEGWp?=
 =?us-ascii?Q?Jll64GylzQR1jaFkGlmjfphIXaHYfMWUEDBThOMHx4Hgg2b1sFH4jYShFG4x?=
 =?us-ascii?Q?WC+gV353e4qLQentORv1HS/vTzmQuxsOTv6sSCBj2L3tOE++o8ArFzCbyZD8?=
 =?us-ascii?Q?12GohB09tX7U7U1WjlkmWdL1QHTEKql+obVPzaeo7cu/1HXKkrDrmTsJJApM?=
 =?us-ascii?Q?baay9tHvTtNDRN2dtRuTL2sagUntM5u2mWAszbeC/tOIM0ZpepccSaaNP2tI?=
 =?us-ascii?Q?cMIjbw3lsVZ5HwjUvEtixkaNsUjMV9pRxulRzIiRoVKw3u2fdnKagKbiZBnD?=
 =?us-ascii?Q?MN8x0z/KFPzuxYGgiQh85nXwLbKhyxIeUuGwi6gCRSgC1e3Go4qlzrMQleQc?=
 =?us-ascii?Q?L9zU7l84UnnxEI3FdUVlNRhqMJFqCSmjKnSbcLnIJC8IKqca+Vr9mjKjbIYg?=
 =?us-ascii?Q?XoCg7uCeIB2zrOWMY1dGpWRFH+a+xeIXUyJtbYCXfF9fCMyeobP4miiarK4n?=
 =?us-ascii?Q?75oCcr74V2sbRSMA5P4b3exZ3r5wtOYgh/5EKOQp63bcLjemaAbv8rHAOnOk?=
 =?us-ascii?Q?l0qaCxjynVn8vRMmpb4ggo5h/OJuC5A6cgFJlvElP9yTQmkAJ4kxD86260F2?=
 =?us-ascii?Q?wHzWJBtqvhBOUKSTPe3uH966V1SAPG2V7X8l8HBinkndS7Zn0QFkRkqdjd5y?=
 =?us-ascii?Q?zTusKyJAaG7Z8y1WHHN8qJRWEugfbr1S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jCYcg4d0OcKH8ZWhPNCj2jNuHlFybKLx3MN5ypU2Czppb+34hoJH9xqIb36K?=
 =?us-ascii?Q?vVD2jRgtReG8yZEu/TIIYCYAdn5T2V72Usmce9zAwbrD6Qju/HmTisSEx4ue?=
 =?us-ascii?Q?+l16QKlOiRtfXT4rt18nprfDHBKms8AFpzzXzFI4OFSBRF3FjlF3i/E+4wk6?=
 =?us-ascii?Q?ZxO/v6d/41FNmKRoznZYCkvhWPABN8oUrPERctRFOpzR+t8WwZwz8ni2hLkk?=
 =?us-ascii?Q?5xFVaPqJf198PjMoTXhV30ppKMcmKdc6OLURGl7KY4YL0Rt2Zz4e/MHeUPaW?=
 =?us-ascii?Q?LiNVGf9etcZgNJlLg8VrN/aN/lsUVbRmKByHYi5ojoPzl10uOPqz8UNU9aZF?=
 =?us-ascii?Q?ejMOdKNhALxXsXcigvhi7uB+AnwUPdnCTRFakM7Zp2f8jbIMOrXF8mY2cv4H?=
 =?us-ascii?Q?ZWsrviFPfrDg5UysHTYSSEXlgDvOf8Du8F14e2JgvvodvFUSWFBWSI+K3C+L?=
 =?us-ascii?Q?L67OqHp7L5RBpxtEpmu2EiNEKZBCa5jQDbdKHXpGoRYHhh7L2GEH7ycGJ0r0?=
 =?us-ascii?Q?4sAszlVBDb3D4gXCUWFLmPDEQRWCqoYNRxYaZt8BhEDG2+ZCDNKY/EZJNR9D?=
 =?us-ascii?Q?0G5ygN6hRt188cXifD7EmgYarPY1vziSPctW/AmPv44ZcRm9byTG6WqgkCV2?=
 =?us-ascii?Q?AiZ1QmMwMdHbwdJovTwFecZ1eW2ixgS6Vw/eQRGmbw6VALLIxS9WuLjMAlhO?=
 =?us-ascii?Q?iegF/zny+yYQTnUqqYHbpQrS53wWjFDyGs2GSrEyL+/KQfRV5A6oqLIGllPQ?=
 =?us-ascii?Q?NDndmjsce8QnmF04XEcYlGoZyFocsp2XzPCk4451czuBt89olpINy03nmbDE?=
 =?us-ascii?Q?kCpaMiA0fJuEXIE3vHmlwYn5aU8P//Dla9Vnax0tRPBkPZzsLsa/biK/raSA?=
 =?us-ascii?Q?eSjair/MTgZQcmNe2JohJyXdQNLLQJYXwd9CT0avyVQFYaM9RdYW9fsJ/YNe?=
 =?us-ascii?Q?kiQPjSTGhfGuwOxry423zg6h9zyXULc5/SOVYo9IrrMaPs53Am1FGGcRqA1s?=
 =?us-ascii?Q?ulnChgYgWOG5ytv/q3a2sSipMH9+mFwvxmF6VvbUR4nsW5391evxGDKXiH4I?=
 =?us-ascii?Q?gJxSIrkmNwpuxWcy+3hIbESMxvP5lw4f/mTou9bKc3xIxgfMB7VBJ7WCQ/gg?=
 =?us-ascii?Q?aGuUdIY0n+EMhc536gVQ3VKBKJA7IHyRseb7eaVxTIEuQmHp7cW2z6YBg41/?=
 =?us-ascii?Q?mDZ0nt1bZpoMu0rNsYvHT26aFBGnRKA6Lfz+5LupPaKQlG0YakPXK13mZXmq?=
 =?us-ascii?Q?VtArBV980nV5AW3qBXWtKLfB5uNXh8Oewf5e6TN7WQr0YFyrDAx3EJY6Du4e?=
 =?us-ascii?Q?qz7AS9fBScnXgyEz5pSJf3FpARyp8B+DtxDGh5G3Ddd0c4/HiS8OGAIwdwX7?=
 =?us-ascii?Q?fb+VYK9MtBSmP8gauSiMeRjFFL99Mb7UmR0lg75b9BobygHoz7GIlGmMB25C?=
 =?us-ascii?Q?stvJd5JSy5VssCPWkXvNjsvY17lmvdsHydHbz25UWQiOwwIa6SJ3c5ajT1qx?=
 =?us-ascii?Q?IYrPaKru6PB3B2wjOYyurp5m42l9JyY5xqZkNRmxNpc3BfVzj42AS/v2BMFV?=
 =?us-ascii?Q?UTlxSsWu47xzl5F5pPqfvDwfly0kQknZGOOVVRqqhp/QkPHFHsjPtZOCpBXw?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	INJFgKsPEctbxgSUWkIGDoqgQbexO+QaMCiyMBY33u8vizinJPf6TKayLLkF52wUcR3urzfwFpsiy3L6rkH5SgoKZojkJMxqaHe2Dk9CnuL9iSgqIf0aM9vyukn5auXjs2UT4y+/t66NMvcmaHCc8SSS5SbNOVY+l3UJpAfGDkCDRYbO9R9DJW2xkTrC8Co7D/GEmTywghjKPQeJ7vJ6zqWkZW9Cc/2WH36i80sEc63gnn2qh4dEW163yar6CY/TOLFcQvc7VrhqHu42oMnBtBvk9gHVu252P3TQa/r5QVlLG3+EnDNmyPVgBtzErIdR+9uU+lWNaEOjPaEkFkfnYt/o8sW/vE/bdTzE2Eo7yLV2QJSCqsTE66dS2MwR8z4WnL32ArM7Ht0VmXIE+jfJn35OKAVYwGrm1enZyAMzIFjj/X6bQAfCpCcLmmRiXJuEA6EuUHUrj8/n0pHYBPYMJDtNEU2y7uj63WW44+ZOoVzITgJvZ7sA8gB5Mc5OoTli24WJRftBaROU4DqRt7SZkeS7KZVKaXb4z0dRuxJaJFV57+Zbq7WFon9V/ogCEjzPzZDe64q0UMtgLbK1f3yVhgXttmsDSfoxJTxJJh7Owuo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25002fc4-665f-407f-a67e-08de0548ef15
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 02:26:34.1624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8arKXRK+24MlsSIqnU6a1WXVwkzhJLQa8Am4Fr/yR/ABCelGMfYi64DeRVhatbDXgheR/2VlBZE3+JjH8bz7eyMcPmPcI/l0ZMklj4bvyTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=856 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510070018
X-Authority-Analysis: v=2.4 cv=X9hf6WTe c=1 sm=1 tr=0 ts=68e47a61 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=MWGvnOQ7OP0oqa2xXHwA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: MfnK7IepZpukxM2Wq9JtT5xFgIQXQ26p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAxMCBTYWx0ZWRfXzCIIvazrxEmY
 Zsou5RBCys1DQm+AJ58kaEJRBffeEuBUFBT/vAuPQfexENe+zRgjBDnKMDN6YuoN6Ph4JvMLCrK
 Xo7fLvFXxbxMDVk+MM5WwxkqHLeyP9EIbJI/9csBGE02OqmUEacoIzdrjh+sPYLE0O0cuDGk64k
 42ttPkJqZCCHy8CpMcpj8Tmh66DSkbyh9+g7V3Y4ImbDdq0lWRGa0vJfF27K7MAV3VzCxPAZWs8
 pFsiWqH7xwMZX8cGdonQxUpkotIUxlQqZw7sx5SLOGTr6eCH4WWaxS5yRMKj3C7R63jvNd/b++x
 MCv7NTDHldlCxwwW1kWsDDPhHAUgvekCqrwFBO2tqpu75iHf9cZe49xVW2jk70a+xYv558J1ZTe
 gLBw1qY5pjMTeXzSeZFPzAIYf0iY6A==
X-Proofpoint-ORIG-GUID: MfnK7IepZpukxM2Wq9JtT5xFgIQXQ26p


Alok,

> Fix several spelling mistakes in qla4xxx driver comments:
>  "Unfortunely" -> "Unfortunately"
>  "becase" -> "because"
>  "funcions" -> "functions"
>  "targer_id" -> "target_id"

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
