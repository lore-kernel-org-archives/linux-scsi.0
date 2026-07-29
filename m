Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5004582F2;
	Wed, 29 Jul 2026 10:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322469; cv=fail; b=Iy9UmH+2Ew+Da6WnDisOJbTwlU3S1EzmtLKhYQUhRBcg3Kuli+UHSjSgjAcF72a0+KaEcAnkK77mvBnNoAzuCAc+4fMT6u4OMzGrZf3xNre7AN7Lh9DdO7d+5rcEPuBHJeY4Cp7rpaleiH6lOdL+cW6qtTduMVXQqT/dF3SJSlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322469; c=relaxed/simple;
	bh=kAzge0PmEGdoepXsp871IGHhCKq60fLaBTC54/kCYig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mE6FAXC04DKhBtq9OBaYm5ObDUbER9MXb9xEGe5wdycgwi5/cddk6UsuH3O4YFDN+i3qG+vsrHVBrCl6r2dXwCZ0Wno8WjXGNftGHMBKWOAfgR+FfsT2enagNFtc5314OlDgg4bTKq/rPZ0FNtwhdVxMNS8srzjIUTF+afKdyJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RjjsxRKN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D0LC5iBx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RjjsxRKN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D0LC5iBx"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T90fh71074548;
	Wed, 29 Jul 2026 10:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2eUPMxgRgwP9hl2rwtR8XMTfyEeuFINElH0C97Wta4U=; b=
	RjjsxRKNydMEcyovfcTbOjTYGOxeFs3emZALLhWcJI77OeQNJhRUC2wVG/3nWxjz
	pg0hB85lQn1ZaAoq7JuAFAvF91nvdiG+tgxcYCKjaL+FomtA62IUlNuzuxLnH25X
	H4dExpE80sQGsojabMP5FlNO1RyQi12Y0SegAk2QD83RAVuhmk1jgQIHqtQP6+ko
	GN3+fUhTIy7qoHh5juruerhi7ZffM31IrasXpGKkETjg5Rd0hSAgnafjxsFTf1Bg
	lJ2F9EZ+bCnZVtCdoubplfFrGJCmgUUqvLaJUhiSaQxKgtzetfld5A8Bx+CSbsR/
	GSaSsJ9efvzP5ffcsbr9tg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq5kds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo6S9029959;
	Wed, 29 Jul 2026 10:52:16 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh882kkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCjCkheYnKALsGmqYNfUZANdoFQpttfXWxoXfVn8McbAWatwHKJzxj00lGoTDf1z50B40NCHm8MUBJTEKdUZKKdQbKXSrL+djCCUAm5To915gmRWRQ7p8SMTHVRpKtT+7eLkBp5Uf+GkeaRXEtyd23gXNFAy3XkXTFYPvkl0OVLmfjRajipE+rZ6FKHS0n9WHutNw8yttRr2wm+tYwisyrIvebgpekp/KmCaR5OC/uDPTtfZX8TKAPRhvwRguyZSJDn1a9fxjUmkl/v8INFjCCubYi0VW4UVu3k0o1JdZC4dRL25udL6dU6GssSpk4YwDK6MuLMSD17Oe62NtqdcKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eUPMxgRgwP9hl2rwtR8XMTfyEeuFINElH0C97Wta4U=;
 b=G3Nla8cXMQK7FSVEq4nx3C7SYqv0M5ch2Ytww8i2s8uXCs82JVMMdyL2DBJGiw3bdwKfpv5zu0km+jxb9U6qwslRtkKxkXRmfTRYZBcuRJtJBgH8RaF9/ldDmtVQ1qs3g//KPCGwux7z9PpMB8eRckhV+zPD4GcFHxyBKzCol0AeZWvMz+Fgj6gSRzJl9gZcea1gzQu8oNlvA/KvjHS2GtgkOddUHA6O6H+MlfZz7LMzY35ZYGeryYKYDLPG5mTOPkI04b8CeHbU/kwFq5k+4SPsKpwxKhwieLzZ5NfV23CFLH4HO/m8dRogR1Dj2CdoiPpEk6Tzn/l+XODLrUHGBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eUPMxgRgwP9hl2rwtR8XMTfyEeuFINElH0C97Wta4U=;
 b=D0LC5iBxQ/jEhbgMduLXUDo40+CSCliZefdK/Gr3jrj/MSY+rlM9tVwGYqXXdWEj0jqh2vZ8eRz2pCcYeDPoCH2QGx8PLOabDKiM5gpQUX/BZiFs6iG17Gav574XtkhJROilB2i87AgEoqnYNLyHn/WTrJXf/vJpamc87sXzrgs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 17/27] scsi-multipath: revalidate paths upon device unblock
Date: Wed, 29 Jul 2026 10:50:57 +0000
Message-ID: <20260729105107.255712-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:345::27) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 54b55851-e1cd-4e0c-28d3-08deed5f6f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UJNd2+w1ymcjvEjY/P5cbvAsFj3ZO7czo66QdzdBRf6djAszz021//QyGzpevbNw5aA9bUZyKcsHidf4UEg5OIYvXEum74SeJo5HxEYyJkWl1k0TjDh7X7ZL6zRkfezV/w5KEgNVa77kJ3XUH8pIqyu0hsg45z5PmqC+JTdYs7fEX/q4LKXEitsKPPNDKFdH54NUetx7bsZKoStJn3QrqAiMiOdAJVXjn8+OLxXtYIYtoi0qMPz5woQeAxdpk5TQge4ku1hw7cRqqA7+kX0NaUxMvIe+PV50WeJKVEMKDPuLpt7qMPryIhcGPlMXRaT8Kg3hypgN0oHdscXSq2G5wY65QUh1deuXsUycL+pE8/7JUMdjW6UpC6HUcpis4FasxIHa5hiKQkv5awT9Q6l9uOJLcrc1+5l6+YL8+qQqFDHJ1MY+Eo3yGyyQehJxGhaR5g5Tg4MAMhpDvgm1ZSuGnfxO9YlqscXI/f0no6rOgT7C0+csgOjDdwGXw3ybVvdGNEduCMsuOPdmL6jTDYqoWjuYnCP0zDEcEOieuodtY86sWnN1lwtqIhHPlSWNHEKdxW2EiUmxjjI5wgGtkrXFnqsYc/YFJZHZi5HwUJYPome3I8dnt5CD+H+InWHkon3IVBV5QdNSLa08UMuemX18L2yAAzsxzdPQTf7omPO4wXk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4E2tNYOBjeemL/zEWBE94JyMgAnioEBLpIYMI3JmLXdhiq/ju3KHDWIjrahG?=
 =?us-ascii?Q?AlMiJ2ieyEs5qAOSncezB2zDCdaSdq0mZq5tPlGBcLNw5gNETP/0B6uFR9Wc?=
 =?us-ascii?Q?aTi8Kr1atgWWkbWMB2cg+jo1Ea0zSiNrUY/vF1RdT+6IIvIzSfxRmd9fPZQ2?=
 =?us-ascii?Q?JfHa9pdr4ABTKnventIcvHekXMUIL8PQKDbsaFuJtcKVKH5BiAH3sJaSk1xG?=
 =?us-ascii?Q?fBAYO9IpVHBjsJLhkeeSSajmvbOH+xbtDuZWRB4duKLYm1YhGTo8+YX9O63F?=
 =?us-ascii?Q?iJZ2fKCOtxujz6zFgEJqXiQWiCTiWlzIDWagTdCwq+Qr3G9IiwC0KbCyvkq6?=
 =?us-ascii?Q?JiAy3c0hFNCbivMQ5gBqsu17uSEcJczb1+EtvLUIXHGSpnuKfUjvWpuIDfxl?=
 =?us-ascii?Q?l5940GIufnSDgLUPi4UJL9FcTPIzhmDlSDaQ82SoV7IXLsinp83b87mFUZ7u?=
 =?us-ascii?Q?Mho5ikKfHDyoLeooZrl8gYpfJCywgiLC2xelJQgzUB6fY72tPwPhvuC/eLLB?=
 =?us-ascii?Q?60depc1E3PeQyo2QHcqF5C1Z+XavNqn2Eb5J6NTo2j1ABgLBwgLOh0bvkGv/?=
 =?us-ascii?Q?463RbPDyuK4uAklf7BcEfyQpdwaikC4SLfGkLUwGp4nCPIh4xk7zAWCVlptf?=
 =?us-ascii?Q?zMWyVOP1gFRnfTTlQW0pS/WzuVBqNFZiHdeADA+M48kgOtdAUFLZB4+jbbJS?=
 =?us-ascii?Q?ETExgueklOcWhoc+tHrZw43s0cS4l+sOAECAeOD9EJF/YCSCoarECDlHnQ6P?=
 =?us-ascii?Q?uSXlEZGgvWuroDeT6uxQqffjkCAqYCQwfnF03964uC90xdLyR4Cey2Oi5+yP?=
 =?us-ascii?Q?xnBGq37k5+wWkRBzy3c/+D7/FhMramIgoB68UEuP+MhOrlLhYArrnuSSqnaJ?=
 =?us-ascii?Q?z22BSA0lG2OsfHtycLqBFHRdMcKcvRzjWrCeKszlubkRwirt10VJ4aYwqs7G?=
 =?us-ascii?Q?ql5G1JM98BiqbOZkJ/bhiuT0jVpKW1iW3xw4vWtb2I8VdesJG0m148slgmdu?=
 =?us-ascii?Q?Ltzbj0ehuFOQ/bIhPkUvQT9I2Xe0rP+cEtPo2IX+ZZqCP0AkYKPXaa2F5lsp?=
 =?us-ascii?Q?Qs2up5t/Jo62I0VMAa5uCsTrCXXQ3aOjc9HTq+ga+T891yPB10fEOAu6V8+E?=
 =?us-ascii?Q?mEIMEA7bseIjtl3inoijqj2YenkHeHodOVkZUsocAkYUSZDzoWsJiVK/On+y?=
 =?us-ascii?Q?gvgcqX4CMdnNlyQWwQiDzSFQwKlzW+eg1r3JVnRKNDC0tKJejweECvi4xLd2?=
 =?us-ascii?Q?inYzO71gYCpcuC3gb9BLpDP52ZE9RuLB58BUJpk9dPRFc27lxHoXa1TYvvMp?=
 =?us-ascii?Q?fcOFfaBFIIm0I3vYQ91MHTUIFmaCujyx4jGDVjbiZd6sypWoFL+3LySjGDSH?=
 =?us-ascii?Q?VyTRKc/EIA27eGMczAKEt45wQSQVJn1ktdLzFM1U59RUPAOPMOx8OnsvNKWy?=
 =?us-ascii?Q?qhD58PguIW3+e3SSaPdX14Da0hZQJbDdi+gozGeT2RrzEODgTHl4AmopSmEl?=
 =?us-ascii?Q?GBbaVWPCzZ9urp7kiPoXzqP7tcDPdeHpNithJjQK7GQK2X76UOfdMmTBSPfO?=
 =?us-ascii?Q?Tph9ed4uHN2P+H/xd7XKrSmk6Fya2v491DdndkLPfMf6DtT88E2PhPPkEsbS?=
 =?us-ascii?Q?E3oNusvNV5NcT7xxyKWm1mdJcYf1aZn09vhVHvoAN7Bi3Oh5OJ/o5onyCNWA?=
 =?us-ascii?Q?8l/7Fbz9UbYQw3e1xpXxdHsTIkfUt0bvyWHHFVHRb4RZbbBQ15Dz0GDo9Lp1?=
 =?us-ascii?Q?/HdqabKy9g=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	pUg3JXA35LlM9cJsMkAEjtPVMgOD52fqnzB+P72R4fUXIVDPKgS6JhiV3w/ZwXt8qHgJ3RU4mkdwH+BDHwQX2+amHx7kXBEWzmC+v73V7llTqqF85rxlO4R9PqR0uX6J3ePLMcA0UrFaTbdsiEdq36/gNj7iiim7IDl3c0HEcC/lXQ7LNPnLaQIJZeFxUV6CVWkpbFNLbJzWsPEdHw2yaFrAY6vYg75iNpXbJNhC7HPH5GoNOtD6iP7C4t+52IeAJEwvx9jJvGzTLJH+ubzwPp5f9JJAU+xH7EMW77xeGJjLWfiDzauL/HmyOEcrz1xrXgA2te9YVQqxOeiIuvob0w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WKu7yQgfQNFU/INaFixS+sUr8Q06JOnbYm9bfvRUTOdsgc0EwB7AvHbf9Onr5HZ+0uxvBTQqmV9Hx1VMNUI4T7zjTR95F1Qx7Du+b9d8AGk1DxYL2mrxyf/zCyJAK/L/o2SsEtEg+GxWF7w1111d/Y2mFELrvL36Eun+Y5G9GN1wxkrSayyVjtUOvb0k+hdJ09ZNg1gaayOdEdLBrn9PsHPrzyodzkTx0FJixRF/MPZUKyBtZ0KUkWMig75aooWSWB9wVKM9suTiJEJQFJnJCW9T7slCNWH0GZvKAgoz1X3h4wY90QDcmB1JKB9RzOXbOuZT457PUtrVIGlzJijmS9bAo14mo86BnM+6HJjlCXuatp5U/bOQjkVen28Oq6kGBN1xc9SuEoyo+D+n3CphSR9IBAszjRY3NrGkSIZcsZR9WHmbNzyZQp3LShLiUg4yMWQ+ViBLEHPQQDaylu3CMR6O1wFruaIZQoFdFBzwXk+U+jhHbatvbhs24jOzLBtangFPiVPcLQUmxIeqVFH6G0wosjmrKNKnXB38UMXBxRA+1sqpo5Mw4aDE8/lNNSCKFb5Hq3v5XVMvgld0SIp0tJoIJA284HS6+mV7NYroByA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b55851-e1cd-4e0c-28d3-08deed5f6f37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:07.7828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfC8TG7tXo6fuU74q8sDphNZ69/DneG3rEnu/ihNvdzZQtEHFqPjh8fDXD7AEsZJ6Lzi29ZGca8ly/erf2M5fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX3sKg1UZhIORL
 QDPX38vOPdiS4SCohHhBuqGhoaIdhCZVSonFXRw9aPWh+8rbEOJKpHIJJCHTD2WEmazb8QJW9Lh
 LcPVRKwUa7ueFOCepGSBTATvfMD12r2WYZ/8DQTon/HDzS/i6SOrbj5C3S9bdiqhonudV2k2YFe
 FyHQ2sozYK2Mn580ngvWuPxN3Wd565C3d+ZxQDZBmCbdEqwNuw1q/fINI+d3moBR+5l9vUfw0FG
 7RaMus5yWdNGZqRqlXIfrsp2LCy9IdXWeLbjSb3nI6cIoxtSH8dHhZsEzcXN1DNxM47Vt96JNwI
 2nH7VlyJ8ghqcmCd9qBGe4zypPRauoBuqJ08xlirlOr9tvXkyzEhJqa2xu7ISaTV2TEEl+i1RNo
 NP09mgKPR+DGPLH7pTDA9U7B/jmmzPo2ps8M9L7CombahrJBG5dAD6Y60jDQ6tPWYQUjkG4pr4D
 21exM3/gDEeBv/Y9Esg==
X-Proofpoint-GUID: uqkZq4UTOG5391R0SPr7V_xNokvOvd8u
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX+akbbhdDFHbK
 OCP0jpX46RsquzTh9Tf1JPDfgaA7F2E8AcU0IJFAVJ7JV5qo78jgtgSOL3Sylh+XM1uI+DcG1m+
 E21IKKV6pBezudiNOFRcNEs+tO8Fi2aErk7zTm1QoZmkOOsInRO4
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a69db61 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=W7bJnpMICk0HBaUQiUgA:9
X-Proofpoint-ORIG-GUID: uqkZq4UTOG5391R0SPr7V_xNokvOvd8u

From: John Garry <john.garry@linux.dev>

When a scsi_device is unblocked, we need revalidate paths which means that
we clear paths and requeue any queued bios.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       | 2 ++
 drivers/scsi/scsi_multipath.c | 8 ++++++++
 include/scsi/scsi_multipath.h | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e2452392671f5..41d201b7e7def 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3100,6 +3100,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
 	mutex_unlock(&sdev->state_mutex);
+	if ((ret == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
 
 	return ret;
 }
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index b23cd6f12c602..12750621a7fc0 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -238,6 +238,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       mpath_revalidate_paths(mpath_head);
+}
+
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
        struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 8f58c44d96a77..cc77e63c43da3 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -55,6 +55,7 @@ void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -93,6 +94,10 @@ static inline
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

