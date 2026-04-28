Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F35C3F23B7;
	Tue, 28 Apr 2026 11:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374997; cv=fail; b=a3w4gNIHsQ4SiYij+WZ+uukLlWsq39dda4wzz/gg+zfCdphRDw8pTMaOScx/IRZeP85xXLi6OASaFJ6hwi9Ms0q5dEXvNpZHc8eSPzl2AywRnyxCCjlmpzhuqSWIZhZUQkZ5TBe9A7nfKcP2E75Ey6tu72PFz4LhKNg7O8vd3oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374997; c=relaxed/simple;
	bh=/kaLurNxG+K1casIoHWy9BsGR4AH1I7aDOXRTELoqLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aVcKhycWyvHKjFdeVRliaDDN2sGRJSfG/IGoFF2UAP/QISNqYGTGI3MFSy9GeuEhkvOMK+/aHM1eSrV1VvtGbaeTFUs0bVFHUecrdhzuALagm9I1wCar0A73DidCz9IfeNLgjL3Qgxoalbn8N7e1STq0v5BiucBnBmzqdfbLKZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Sv6PXaeN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uuYuc0+E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sv6PXaeN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uuYuc0+E"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAoDMd752791;
	Tue, 28 Apr 2026 11:15:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=74zizRt0sCl20vPZ1DMjEyHFAgONreOBlwQPBo/x3ks=; b=
	Sv6PXaeNyVrLTtvblkRW0kKU3dCjw0MS8PVeSJ7F5uFEJX94GaVYF62Porh40vNq
	CXf8FzrpQxEB9kF+mInXUqDUOaMRU8Har3XvX6sPDNzsdvOMycqi1l3rIcrMhMq2
	S7Tdt2D7Pv8zKhoDFGYrXhbs8nVPusO3ZA/d6AJP2jApAEUDz9uyHk7F+DQWQt4/
	zUgNLV85eU17LRQdIco3cv2zKXmqx//m0yd/ruNCt9hRFFmwgssoP+DL9dm/qTq/
	QqojVC41GGpRfpKJh7tP5VaH4pO5c/8EjZFh8D2k2xwpMfhsLRG464qwa3vT0EM9
	qKUEwj8XMuoqs/VEl6ew5A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnefexe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCSxM025967;
	Tue, 28 Apr 2026 11:15:18 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013005.outbound.protection.outlook.com [40.93.201.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ckm6p-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Op8vOVME6QofMq7guAYL4V43A9y7gy6BpCQYb9xwLft5Ak/J6LcA37LvLGfVyZYYoqu9F+i4envH6AeGNvUahqEk37M9VBtiQ8eBiODbbT50qkIAzXMsVUEFSp0YDcm5kw1/s1ZeI2nschdKLNB0S/AWEPbfEZIsgyrQQJO6Ehr2JwZN4uX0wa3oyv+Y86SJSkatR2Llrsqu6dnVcLl8TP6OrvORFQY5rXYNR6iShvoYxv1vLOTgBbW6ntKOryVT/k7aWkkZ8Hlw2EaRyrxf7Tc0KN66NBK1UNmXJgLT+nyz1WfqITyZRF7NXXFX3JOxe3FFJy+At82KlkLeIIvFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74zizRt0sCl20vPZ1DMjEyHFAgONreOBlwQPBo/x3ks=;
 b=cg8goxYBJe/qPTmMatqSpO1nrvYWkJlMsz4B51Do8On5uORWm/gjtTJjUD4WqBFarK82k7MkHoGARssADvwQJeEXqefJy97Q1NW81PicBFE9SpXzQMG1sjU4OuP3O5EzrR1c8JO7cV/cIp9Xz9y3tRC94L/jCnHSMsxBcpga9n7WMSxGzEiiJPZCRv6oJxJJkShrFWDssFmr2ggom4sx+MwjJ+GkXrAdPwJJgY8wF+5cWtwBwi0IEmE4KlZVsG/lrnFgs/8hQS1p1yWBsJ24pMEoAuKNrxkWV8dBn+u13yMwbpGgXYcQuBDHcDxRUPIzKjEIAwFTkM8QQwtvyeJU7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74zizRt0sCl20vPZ1DMjEyHFAgONreOBlwQPBo/x3ks=;
 b=uuYuc0+ERCHsOUcYpKjZaJ71DThMJSDwUgXBsXl5Sdr0fioMk5P+oBXU1kzGjm3UXlPMMgsC43Br/5gVhBoJAq+1X5+rrVrn2tq3l7i2oUif8d7I3bv6pLdmZjqJpnJ0LCqR4cGPq/CIVDOdyhNV5psomYkohX5J2ANDGS9UxCk=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:14 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 06/18] scsi-multipath: clear path when decide is blocked
Date: Tue, 28 Apr 2026 11:14:35 +0000
Message-ID: <20260428111447.1779062-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:610:33::16) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 77297012-3a76-4e9b-3a34-08dea5176b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hyd6QFAb3xSwB+Or6wg6Fc/caBjaqMHR7iSDMpDTIjwB1blUgdMXLJ71boQqGvbr3o4qcXkjSEbkWd+KTeJPyhdEuWJ28MbDkw6GEVXpuPgSroFYAU8IT+eh84xST3GrB8Zk1pHgISY8r8ugtxV+HTrcRZPHGdy3uVlSrz7oHcGPF+M0OjN51gC+k0pw9OBTFCTZ7eSi0GlXbSYcargGGFPVxILzmvKWWKLtIcJoNKlhDoPDaB2L5GSjl1yo/R61QbkTz8c5l8vSm/x08nP4JIr17FQoSVRnIyOmyMRkV2o8+HKhsiDsYS3q7oVDn8VM21qAxV0AoUA+tNJe0KzOIKgaSMXuiJvH0u5IrsKO1+3lsMt6i1s+WEewXZT0Fo/CgsWgeO9FLJ1isUusDDvkmvK/c4f+CjALD2zSwlXILQMoU/2/9XSphNB6N5oWQnFCq7hBHOBK7OfGIIfoCU3ZV0KxieuLejb7EG1FrWSS6i2KV8UhEar/1UvFMnHWxLgIwQ1dipg0AAOphIqeCzvqiy/lB7gCbcjoSAM29DwvHAqfC0StWtVj2IqLzLn+yJGywvZLJ/jDZYmYFvHwzJIVioIAB/BNmqfCOUaSefnw2AopRIjVCSRyaFFMNwcBQMSLi/VXED1mXkJ8y44WW6Tl6uCUiHDBxrmeCW+C7A/IPBnCYl+F3ddGJaHi65ZMwr2pUEVmvJu5HhznHOGUP4Yg/9yRuLouBHTt0zaiNbmynNU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JYyGrqGT3GdJCSQLsEYtyzwD93XX8lG86TgOIlpz5yPFyWKJPvmzObdYOl92?=
 =?us-ascii?Q?ABAWto/L9XHwHFoNi75IEy06/WPFg2a/YbN31hGfuwl520weGRWU6RJc2TEt?=
 =?us-ascii?Q?Yf/iuspJpz7pyt2+rpGQ7j2ELr//rzzYC28cXGJS2XNLz4vbvGYWuegka+Ia?=
 =?us-ascii?Q?imJ8V++X9rLiq4UKJNzYqTRpKvysTT2Hkz40WZ11Mix8bWAS9lw6kxhet43R?=
 =?us-ascii?Q?NEBJi+P6+3VRIZaXDy22DZlzIPv4/BEVXOMsVRvDheadQuAVw/jWRbhzDkbh?=
 =?us-ascii?Q?LCbZkjg+vsNNGrx5Ke2Xz7tgbGRIwXgg5MG2oi+RRRxuzHVq1JhcB5hsnssd?=
 =?us-ascii?Q?3xl0SiLhmLojFr14TQqyz/owGMfwm33hHIPShlibANnnhyirdYi0a1H67jfL?=
 =?us-ascii?Q?AebzAs6KGdoNa9vXf5WLX09kCkZkizggiuVtX4Hx1ILmyDBVLM0f8O4goRe/?=
 =?us-ascii?Q?yYtBbGNhY+EURd+HFLiR4iYFu3BoN5NO+EeEY7D5syzI31Vx+sJYW5iFIGj9?=
 =?us-ascii?Q?MW3z1TIYtE/3gdRkUc5UBEkf1AeUPRgfeNE4RYHY2Lq+z5yHVmyzkm629X2K?=
 =?us-ascii?Q?zzpDxjcJtzq7CIAD1xQAYESZd1LvlKkrv5p52rAEJCnpRx+dqUgcNh8WEgxI?=
 =?us-ascii?Q?9u/wz7XP54G6ql97zOk2m69MJ/jQwQIVofrO515lPd8qVdAaBJuUYIax73+I?=
 =?us-ascii?Q?DZzYzeonCM8jqmSFAA7AkR8VCEDLhnoSkjE+X/xVVlVtwEcBWRrLxO/vLOQy?=
 =?us-ascii?Q?lVLuQmuoNjiY1es0qWtwn/jvt01cIT4FdxAaHHn5NMXtbFwj8E7+QAXNKzi/?=
 =?us-ascii?Q?GlrXJBoKeRswMQfto6cFkCgn/mZVjcFlH0AiKtBqbLKhLizrZb8+SE2n+V9u?=
 =?us-ascii?Q?kGsQLUr3WzHHhJa2GLiEuvv/ReQbuR51A0JwfCs+buhEaUFrVjzUdYmwffsz?=
 =?us-ascii?Q?T09OOahpxJxZKg+QNpIhkVqtJvHXtT6HecgH2Zpgw4+jEPmOgxpLmNpsHP+B?=
 =?us-ascii?Q?eLrLy9bZWuspxDuo7kJvMghtL3TfLH/3D7eyjzL2P6FmGd3Sos3jHZkwZA0V?=
 =?us-ascii?Q?AG9MFV1/7IlIP8SFax8NDl7fCnEDIjGZW3xVOXNtaBOwABYW9Fp81cpurnEV?=
 =?us-ascii?Q?6Tux5G7SPkySlG4jYp/B33hVq9Y+fQFZCv+D1g9nl4on7RhQb2vC0kmHeDhR?=
 =?us-ascii?Q?n6SaQHUknHiE0AX4ZelLIQrjBg3fdlJXRynI0wmijeM0HcG8kUQjLcQfy+PH?=
 =?us-ascii?Q?vS3lKTvIr2aeVFJzVYYMiCHbxjc2kkFf5tup9zXtuVsOwOgOE2bLWEbE1Dm9?=
 =?us-ascii?Q?oeASAHkubKo30UMsCrrFxB2W1tLm2DGQVQ/2s8roGc9OJo8F9Xm8WJe9Ok74?=
 =?us-ascii?Q?CMwOQJ3ed6NKAguZ74VV/QTSLDxmzM1ttipp3cvvsklUxhL8cWsNETo46RXX?=
 =?us-ascii?Q?kiDzMJIOHkXnjrOiiOYvyBeNTu9n6CWTa6jHwytTGarVrfzmfc1QEa9ktKTd?=
 =?us-ascii?Q?YDamY3Ymajyh4q6G0FMYjz75+H540UPniRT1kDawxKTjQiSH1PHzZYtec5Vr?=
 =?us-ascii?Q?obaRv02CuYsF+wjdFgYT43mS4jHDav+uGnR2h8t92nm+BQxmlHHB3tuZTr6a?=
 =?us-ascii?Q?c4iFsBPvmju/bklJGOowwSh5nvILfX1sE3BKb6dRAtA0B/vsGKsYTTGs46vu?=
 =?us-ascii?Q?L+RISo9QyyETx7bNaT2HiR/EKK66hSqEACuiKQddmDtNzRUZl8No7QWM2BcB?=
 =?us-ascii?Q?S8A0IU8Kv0PTn+Vp7Jq3j7vVvRdJeXU=3D?=
X-Exchange-RoutingPolicyChecked:
	Y8ZiS6NzHfvdKuqWbfHog2PuXjYADl8GbPODFePyHYjqTz/rfUieZMk4N/XWWWo0VBSFMAAlpCjHKnUZjHSalI3xtQkmwDM+VWPjqlkBY1JfW3wRVNFRF66e3aiye3jol6/smUPcX+vFGGtOe84ehvvyPqF9jQW+etuKFg+ZBqzgX8uAcI0uBk37bl+I3lFBaRvnlhalGpnOvlD2Nm3RYzzle1HrliUiSfUmaoGqgfArpm0vXJ6gyTm2Hrf/UQVVlQNBxhYx8zurCS26+JaiUmB3oz/yhEB9xxOyyYBHV1MUPHJo1fuo0LCAIY0C965pt9exsE50PjUuPnkRhi5cGQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MySXVplz/MVl3/daKwgDDgUHKh3Y7FvVXIjwAihSE9BSR8jDsMxlamyKpEylG9z3MrAb2KTxJO3Rf6wuSQ9U8InLjQkABEC6NZvu1g9uXT12HV062xwNv3l0BO/h3Mxd00SGbr3bJfQ7tA+qmZDTYG4wR8UqYXMtcJ8gUetkMm2tYUFS/w3ms1XTXRwV33QWzaPEKxMs3dcq9D50URBcRzsOIMzHTXa8p0bSOiV1iIcqNQyuSIpaHzCzUOBcDvIhTcKXreMhWnrsRGuuEdr+xUs8LrrlDrE38VnkHl348jgG5KJX1kY7qaX6prT55s1n2xVAUELFm0p2o34z2lQXKIbe/k9VJjzWjzAaCPOyRt86XVNROirbFArpwz4KlvOVs2/XmZkyXaZn1YECWqgbOOgq6SPdRrIUKhBBkqNhGft8ce7ULdfYMDe7ryn3ycREQA5qw9XFYNLFNUyUUdNKIfjsrTCNMGJ64R9C2F7eN5bfE2TWP/SVlpwwR9t/e4X3XGrcNup6X5IK6aiDVl4v87TO8egl8mTT+4U0sNs0F/2NzEB7+8doCKmNShTb7xoLytinGS0OVEW0vzECWeHN0tNoNniOf6IMfPZ/ekhOtME=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77297012-3a76-4e9b-3a34-08dea5176b5c
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:13.9797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzsl4ZJ7fW7OM/F4R+K+Ey5YyraktgWk+M/KR9YgrQtUEOB1z2U0Nkz8E8lzqFh0tfmQXvywJ1WrnpnL6IaOvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: 39ULlSampWNYkVLNUl-6aBne3Ez1qr8_
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f096c7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=kQY_DWcjttSAKOrtr3gA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX2Kvh0L2/FWSc
 kP12kOzuh2IZI85fNxti4gWfZhPTfBeg9itvypDRE1H2cqTUcL/xhii4ASJUomV2BjcltqCQvsS
 fP+aaxyfEoBlLd6iNNZwp50D8mOZ6Hk3EGZrOw8gMScLWRGHIcUqzjOYyrVjx8cMUtKNZ6AO4bH
 BHBcZwOuwkwgOUAJN/v0ohRfpbIpur5rVWjsmUWw/nyqa+rO9q6gDSBH6CAdUaq2+kav9bJSxGC
 /SS2EfKVhbwN8vU4VyD/GvuSHewmQlS8pcvCf4k3BHWHaHp678ycAGTnZRyML4cBCdK3wuf7ntb
 ruNjCsELuTPXPvur6bFpCuOMqD8jBpP8TlENm2J9cNJmLX+lT/rnT5dX1KcjqZ/R04H2BBAWyPw
 ixSacAL1wDCtzve1B8eudyjHMS4KHhkfYNd+An+S8yd57VPWMmTroLBSywWnMUwOJz/ZM3OB3XQ
 /q2xryG/zKY5TYaTesA==
X-Proofpoint-ORIG-GUID: 39ULlSampWNYkVLNUl-6aBne3Ez1qr8_

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked, and call from __scsi_internal_device_block_nowait().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 11 +++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d3a8cd4166f92..43154f521198a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_dh.h>
 
 #include <trace/events/scsi.h>
@@ -2907,6 +2908,8 @@ EXPORT_SYMBOL(scsi_target_resume);
 
 static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
 {
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 	if (scsi_device_set_state(sdev, SDEV_BLOCK))
 		return scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
 
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 068c5e93ade1e..a4636a53ffbf4 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -113,6 +113,17 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_dev_clear_path);
+
 static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index c2eeccea52d3b..d0e1cda836865 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -47,6 +47,7 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
@@ -73,6 +74,10 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline void scsi_mpath_dev_clear_path(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 static inline void scsi_mpath_remove_device(struct scsi_mpath_device
 					*scsi_mpath_dev)
 {
-- 
2.43.5

