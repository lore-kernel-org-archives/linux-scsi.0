Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8314429839;
	Thu, 30 Apr 2026 15:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777563829; cv=fail; b=G9tQsfQaqyoBnRXeG4W2tKQZTa4u6Guuhdq4oR5Zfz8suQCgX3gUyLbOXyhJexEjh5MCAZP7Zi/43gD/hOKqVrVM2PZr6+klLlGJSIRbHK3nmywwsf59KCX6XFos4rtuPR/cb8luNrzoN8iocGVdLKq/uHueo1y43aO0MN9YLGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777563829; c=relaxed/simple;
	bh=UlIMRX7YQb0qHUSAJO+6YmBMpOJ6SMFUxUFFBtx1h/U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bBg/cwz+sUgIFhmKVkLw6PvOsmj+XcP0fQQcxfQ45u9YyTXKVjxDY5WJzc1nAQtHAbXVdQ022hvP19jCxNy2T7MsCJzK3U831tIZkYJbuMLkq11eSTct24L7ebUzuJG+LatxqF2t7W79CUd2C+dOcIZjWCZf7AXnmWNZsIW6wMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JZQ3L1v4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kit7KPEx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JZQ3L1v4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kit7KPEx"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCfU8l939510;
	Thu, 30 Apr 2026 15:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PFjHGCqo1wuFxEtUHn
	2Dsb8yuHiZvA5UizBFnDvzHZs=; b=JZQ3L1v4t2kJIfMZugq3mVGY0RdV4kYq7M
	6J76sC1DnYn+C9O/NFNKXpmqGX0i7l24etHvqHruPAohHsES/fCB2zwaeDruOHKZ
	96zmLgsaw1u8kdHtR7bkQ6tX8sDG8++NIDxZJCCk/lipEzscYaes9dgU8FbW+LKP
	oaEyQFheyTIyTI/UAk94Qw6c+z4VuwwiQ8mf0yQrHR5RhMnmvj9VuUlSPI4DryVr
	7gMJoUrDrnSunZmNpIdejfGFgC5YZko+LxUtIb1zAgnI0TQ+LXiCOF9SoUQGvLgF
	pNntsVFizeU7jlfQoylA3dVNfknhVnibykKqs7u0MFwMB34p07dQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm1d57mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 15:43:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UFfICA012611;
	Thu, 30 Apr 2026 15:43:43 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4du8xa80pb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 15:43:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQYOQjxCaUK8UiIt4wXrk7OWxrJ60DPkVnCUUV5Q2UuVLNhF8vvCisuPbgqoboOkhwtbl9wwT9cpjH5Qs+X6kFv1eQVlkAtCPi/w76u3l+WyAHivoW8MWaN88uVaSHqAjLrmaeEIh3/3+i1l1hKla3Qwos1HSHFBbATmjvLz0UJFcvqUfdtpCfDX6Qa81GtzHWD0bBUnYSb3smQXK2H9WuO0sxqLyDFSZUyC+/l6cHokgphmTnQqR9UBRHQQicfapv8gUvvrZaVYiEBG8GRX9rJEr+5DKgHjXb9iEeRF9hPY033OMB2gFAW3Sfq5AWV1t+SUJkYqljyPQtDaIMEqSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFjHGCqo1wuFxEtUHn2Dsb8yuHiZvA5UizBFnDvzHZs=;
 b=N6r9tG8iqDhbECZkphx9jApweFhsNTqM2OkW82bfZ+8UKeX5yxZGlEUDazFCMvHqYt+X8LGekzpXh9nlxywMBuBEXq5cLetQYgo3RfJHECp0l79trvFLPQO2x9xCLSVR5oZfGzpY33WMPuYAIg04Ejl3UOfmODRZQWmm2tq3LzR6XbIfjUa99EOq4/LSGOKPjm5K7lbqm1DLCVE5X+q1wpA1HMGONBNjEWMTIRDHZeJwpAoMwndKnVbpcJ1JW7oumtln4vw96mLo/uIpvesgqGZXsOIdKKnlGu/TVyA6PpbS8SYajbsYJz06HrAoZYl7w6Fx9c/y2TCPr6gVqvdxbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFjHGCqo1wuFxEtUHn2Dsb8yuHiZvA5UizBFnDvzHZs=;
 b=kit7KPExLcCvBO1CZrFU/QYbDN9udqbJWd9j7cx/oVGZMkS+h4VPfc8xiRhDl4PYTwq44E9U74WtnHp4s4SpTwfDVY9ZXbIGwd7eeOzYbNZoNXJvaWWV/bgb2TgQ7VjsjxbHaWeGVEQx7Aw8LtIrl65Zx+nFFXiCUaPSa50d9Ck=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CYXPR10MB7975.namprd10.prod.outlook.com (2603:10b6:930:d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 15:43:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 15:43:40 +0000
To: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: Allow FUA if no write cache enabled
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260428203938.9738-1-stuart.w.hayes@gmail.com> (Stuart Hayes's
	message of "Tue, 28 Apr 2026 15:39:38 -0500")
Organization: Oracle Corporation
Message-ID: <yq1340cfogx.fsf@ca-mkp.ca.oracle.com>
References: <20260428203938.9738-1-stuart.w.hayes@gmail.com>
Date: Thu, 30 Apr 2026 11:43:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0046.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CYXPR10MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: a8bdb838-2432-4b35-e225-08dea6cf4036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6mb8bn4rG27n+u+Ae1JHM309rb/wE4jW8MDNxN/5Tb3o+pNWv9kGCsPCIhFpNv9eft1ynGRcWS9cnkItZrpMMLb3DQYOx73HnQS9jqsp/PczURpc/R+0y4dN9W5n7Y1f6XzY3MQgqRl0WvEHo3s70OmGhlhXujEmdg78PSbzdsrzSzWPOaZ9YkeVzb6JY8e3aGwhTw9RnzG9TlnTnT+E4oUikDDnuwpZJgLB5vOOird6hK1V+zej/PH9/CJfrX5JJXUwCwUbmEBVo5yq3/iynbS6MGW9hUGYbzPn46qjjbaYx8XgyTlc0ObYaEvR/LUDbGZl/rNFzdFjgfQ+Nqjb3kvLhhp36zng6pSCTpRN47RZKRZhvuoFgLeZPAd+xU9qNKRlnKvx0bCEh4MCxlgbeJngUG1MhAztVLZdn59jdnKSwVoqrupY5YnpO7LLIQvYRUJrN02BtQYMfhyO00m2l4cG2fT+5QXKpmbKHhis3YqeiGRtd+Wbpm/WishleX7N2/HAro6Ett1oLoHo5OOv2hQALEuFobcGX9l4WMPoKBpqBQg3pZttU5I411NF5jVeq3QrKmEZse9Xe+kqNebgHh+O0l5FTVgpcWIP47kQmtGK7wVn7HDbyAOZna3WzpX9yo+Ywvy9/RH8FANqGg8mrq+VRBRO2pYPYglullYCjnE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eP9/QdSpKArLB70CkAW+0g7AonLFHUFJnUDhlSvkK2ufTiTWNF8bCLwO1jSP?=
 =?us-ascii?Q?YRz9gfCpsDUR6rFKwHSY9HVW8gc6qL0Fnyv2NtfoI4WuFl4sKnBvv8QgBxH6?=
 =?us-ascii?Q?O2VhVbw/KoPi0Jz5rEcmFOc/iblXL8ZbAOgjZraIkgpPKcNbExFKkEKqUPcR?=
 =?us-ascii?Q?WkCKKvYXatAWSusWGsF2RJLeW7P62AoY35zao20B3qNjyrc6nKyG6vnUQlJR?=
 =?us-ascii?Q?E/qGOnM1QzzAp2soMGZBanHgwqocaZhsNmD6vK8X90P2ERkzc0Bg3vYrvKfj?=
 =?us-ascii?Q?GTcnngG+ar1n2xYxXSSVNrm/z95yFg+gCgdX19vSaj4x2GxYcntUUACgMD0B?=
 =?us-ascii?Q?7eAskrgUI0oYSbipkBOWM7O9aagVdO5Dpt890xSKaNYdWIe6r0RJ1IOkWmQh?=
 =?us-ascii?Q?K1qeyfDX6lfBMsTOFl4luq35a1HUfbL4RVN9/N1Ct5S7lRxtySk7qZ1X0+T+?=
 =?us-ascii?Q?b+Y7kkeAAt1d+fy2AZRrNasuKSfYRlMKi+xq8Y0wfk3w2l1iJDwB2lpI/TtW?=
 =?us-ascii?Q?kOxsqpIO4KZ4545xXeSJNT8KSstJyS30nEZk6x7857au39UGnixb5RuNpfo2?=
 =?us-ascii?Q?Vb1Fvtha0etzFV6bxyyypdWgnaHseCa+hcJYBKIwPb6jcBmMaK4AKVM9UKFo?=
 =?us-ascii?Q?2Q4Ksv3r20CN1dcpmZN16qyoH7uwu6V1TjtfQAFeqtCPf29A+owfGVHZ7kpN?=
 =?us-ascii?Q?wxDIMDXAdzsbisCtrsw8pTffc6RIzA1Buive8uAI8wre9ZYfqCEMpepJpmxu?=
 =?us-ascii?Q?87GhVL1IkIJOpZ7Hz4hL9Hhnz/aegTZYqg6LmWBXTK8Wchpglfs8djLtT/6a?=
 =?us-ascii?Q?I4RtxAwH2/bvzAWWfY9EenqwEiTEvRDqSFJ0AbcZYz2VZHdj2iu2mzYrZDVh?=
 =?us-ascii?Q?FIj2auHjxiMA+OUyIJH/2+DoFZbdVi8aF9iKiUkUEae584QOpQTk7Jr9Vfpf?=
 =?us-ascii?Q?elrpTn9dPZDPfu+wqL8ttx9sgMg2NlUoq+OO294iYKggQNsQkV4CsD+MpOqM?=
 =?us-ascii?Q?A5MSNe8+x0MoMk1WW/QzeOer+S5iLgLzhlGfHxikq+gsKhP7Q26N8GJTJtzW?=
 =?us-ascii?Q?cCtPc9BAJsHyiecA9x+JNiqiYqNssexftRIDd6Eil5iW+lcaDfZ/JPsmtQhT?=
 =?us-ascii?Q?ySfGep9g5DyKfEixdL9pq/Lqo4Fvd73qdRhjiMazq3/rng+hoOnJfvW1Ygbx?=
 =?us-ascii?Q?dWrXGhsZPaq/NVNSIRkEmpauw2UI8mjM78hHs/Visj5fw5KQULvCRKp2GVBu?=
 =?us-ascii?Q?q3VKXegGlsnhuMxusGucy1Cp2VqqdNi92ygmSDzPTrAJwgodWCk9TvNLX3um?=
 =?us-ascii?Q?vQI+hPqBaoQS1fggtBWbkJS3R3EzFLMYcgiQB4TxFSISWrSrl63EIB2pPOou?=
 =?us-ascii?Q?JAVJrQhD7P5f5gWzCQxUqPNKQiz8rnVziaYjioUkmbmmGQz8/EbjHgrWniCj?=
 =?us-ascii?Q?K9oC+9cRzdHlImOqQJL7aZIta6mE0KpHFvc0V/Ma05q7yLNfI6LacpPEVMGF?=
 =?us-ascii?Q?xmA10LhKbIZ6uXFmYbGxanoyuV7fFBxjc3w++HvIGNsay+A/W3DmRpFUYUBN?=
 =?us-ascii?Q?xI+mttWlQAMxSu1cePObTzqquaJIBKg9YE6R4o3VqKXnIPjzrDBux8NStFMM?=
 =?us-ascii?Q?qKlNtsZ4Zm6eAGcdYLLhek5IHmUbQ6SxuJux95DZuWJeD8+us/mzyQnt/JOz?=
 =?us-ascii?Q?cNlj24BBm7lYDvvdJ7o3mfrafEtjur8NbAo3gB8Qiz9SOfX4uTx5yUa64tHo?=
 =?us-ascii?Q?ozBn7OGuX/6jrybJ6//a7TXRK1MS/NU=3D?=
X-Exchange-RoutingPolicyChecked:
	ULlufgVEhyIGNVVShJNAT8AUxW6vSlQ7+UjKIio4+lHHfJ/1Z8hFeiPYpPg9rQC84pdUwyj6kA1WSo5PY+Irl5uzyVa+yw60GV9dGVkrZ3mL2PDjLLjBn1tdwKCHke4f2noVsPDI+Jsl9ydbQqBrSJSefuiRFMv2Q5AcG+IcIkBkj+CQjzUKTfWwrwyNmx+kDistEGBsjFc1SOAQgKiED6Te/eSxmZZJFeQzYWIVg6ZuHANjD3t3/CeKWFoihc5B4n8a2Ij4VeygZbyUdMHXipC9dOJUeVUrkRUEUrgp8jipJR4y+kH9Kt1GRlCAWVTmMsWmnr99mXv37zUUaxvPdg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XzGCn7byUWaMNPFFmXBCvZizgUtspkRAL0Lrj/8FP0R8p158UYOLTAcX9SR/uNcR9dke9KccMWPJueeaoBqViCs4apHGpSpWI7lN3LCVWi+XOOUZmtS88IAcvJ7RgKqv7j+aSCKkPXzDeOscvw057oU8cbJpFfFxTScUR9sOjYO9l23OOZVjrVKzhiFGVeYGUlKz+B/aMZbbdhcuIj1dUd7Cu6IqCreje3pA7Xucqq6EDmJ9ib7pB1zB5hn7YTR3+Fnfr5k3WZGLXfNOITkmSebTSL7Qj1F0bIrEBWXyAvS1qHjBFfriC+T46stBpdHrGbCFiXYypQ9zwcmw08EDtThBJESiy8QLyr9As3xB0JL7+m5UAKHFvFtGbdzONAJHn3Q4Ic4hzIpJYPhaI++7eI+W33O6ImQAMKs7mEwnyTcV7Kldup8iKvaE2XNwRz7raPdKm05hvdKNmH3GNS20cKZQsBlhyf0ly7xiMhkwZ1iaaKcW4iYfM+BqWrdFJNZbiiskHTNSXRxNdxcFsub4N65KQsGCi4YXA4elJ8njzeiNPAOHxAKNc0uJyngRq6lJwTDYN1JpRlwmw9p6YdT4SPgSAK53Urg7OPTlEkiqZmk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8bdb838-2432-4b35-e225-08dea6cf4036
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:43:40.0365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ku8utKILTxCn8eLtEFLP0lwq/P+RXDdQh7HK0P5rTRxLC3hgjFNPQ2z/9Pr2i23ordr6lZ8jkFYIcW3xMm0n6YtOQrS9ucUPzKmyftpoLYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7975
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=818
 lowpriorityscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604300162
X-Proofpoint-GUID: z1rVNpfPi0aUmcXAuNe-gEaNR9Qs9ISV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE2MiBTYWx0ZWRfX2gn5mtrMBJdQ
 AAbm86o8eo9ipcz22Hbrm3OoP1JYJn4my45PXk7G9oNxkqj1M+JUwgJsY+LqdGCfNFII1nKfS+N
 AiDHobf4AUOClPD09TopMm7qqjkBpr/lABronfurpM9OZdGBY4097rjTD2SFly95Wa/uW0rGlWv
 jOsOgplD+aiPp42Z8gqzn+lWhO/nJVZFDr84vAZRTnJ5mkywA35Dm6YfQO4zfUzxgen0p/G8RTE
 EP9gH28+QOxUK+K/OV7ecEFZlWwsKWUrHa/35Kn43ENc+Ij02aXaEgNoh9t0DfaHEGO2073WAqH
 XhUYGTeEhg95GGLzV9Q8XKFCGX2Obg5gbCCGM4gdhj9KUouurygR44DYOZ8r0UIws3wjkpL1PqZ
 eZoqctjZENfFqTBVRvc0PKL91C/LmvVfob9BnEW8+ne1ZaU8xz2Chq7J2X3kNfNubh7S1OOhp+U
 TdqncVtKtq+BIzppqG59xvPx5WR9P1TKw5fnYRxI=
X-Authority-Analysis: v=2.4 cv=I89Vgtgg c=1 sm=1 tr=0 ts=69f378af b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=c92rfblmAAAA:8 a=pGLkceISAAAA:8
 a=rcTnnAsZqUb4u5i8dY8A:9 a=GvGzcOZaWPEFPQC_NcjD:22 cc=ntf awl=host:12310
X-Proofpoint-ORIG-GUID: z1rVNpfPi0aUmcXAuNe-gEaNR9Qs9ISV


Stuart,

> Without this patch, accesses with FUA set will be rejected, even
> though they always go directly to the media when there's no write
> cache.

The spec allows this. However, ...

> This is needed because EDK2 FAT filesystem code sets the FUA bit when
> writing, regardless of whether the device advertises support of
> DPOFUA.

^^^ that is clearly a spec violation. What is being done to address this
issue?

Also, wrt. the patch itself, please see:

https://sashiko.dev/#/patchset/20260428203938.9738-1-stuart.w.hayes%40gmail.com

-- 
Martin K. Petersen
