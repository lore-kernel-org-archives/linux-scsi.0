Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC0D192B90;
	Wed, 10 Sep 2025 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757469874; cv=fail; b=h+EF97DuMxgfseOBcG9kFQScj69RQ5IFlmqyGKo0Y3tQCu0sIJPoJ+o3A0sq6efOXkdfBKr34CeOh/3aPSkTznQHFTvOInFnUsrnL6tIl+at7uvUoSvDWsHasMPb0k1pEWr3OPYSF2PnZmUOPsLu0vpNQcNXDV/O02z+jPo4YKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757469874; c=relaxed/simple;
	bh=lORCR7ePtcOGw6TICFcliZ0OxZncQhr72X9V+uGiADA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rb2fH64yOUlWiSmit/CBV03Zq4Ux9o19HA4vwu6rqHY170Jdm0REtuFxs+Y2V/W7yatBfGN+EGmdm4BjzDXnZvbQOZZNqpdl1aKqBy7ZNhh0W5/5cF0Bb2V8dHHdOJPbltlb6aj0ciMXvdmsBEMlz1Lecajd6gASmsvpISgQ/ZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jtFJOEEG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FLUDzgMw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jtFJOEEG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FLUDzgMw"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0Ymj004919;
	Wed, 10 Sep 2025 02:04:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Zs+WHuZ9PejgQznOCY
	9pnleWhFDvSiC19XE8wasktAg=; b=jtFJOEEGW97zcFugyuv1mO47lK3EQt3SkY
	a1AiGdFoOrCdtjDiNQ0IRKNEHwnEsf23o24UxCol9WULlLv77IWaJe3NVlbZfX0v
	wGVDm44stft/AP6wgWkLrKeerJdRh8EWKKBekXVgZ3RnGZJ0i8n7mJzVuA+EYzQ2
	paVyRAGtocQkObiM3npQ53XRAADt067S81nTjuIWeRBIkZquKCWoQpsQy+etCGDd
	bS8t7KMVFVcMulee67E1ThscqkqZJj946i6+9AXm9LctqpxFkjQXY7/n3C7CAjJz
	5fZiIKDxkn74qEY9TruieStsOGYttlVbAZMqYnRNQKhD0LmTXgMQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shu16n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:04:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A01YJt031517;
	Wed, 10 Sep 2025 02:04:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbcjy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:04:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMnJ/CEeu8B7xyzKCbfW3vzcJD7HkrbOXStLybuoJe+k8oKmeb27WnNEpsvCANBT8n4l4luGWnmVa+uoSH7p4C7PKyqEnnH11yCnh4We9Dk7lNDH4kxpLTNPagdUYCPf0vmHly8fLQlV7JsqLefOVrmE2E1nWQU2+YyCoDyYKY37X+UMR27YFoZ1XHlFXCnqxmI0ZuS/pbif3gtOC7NJ7al069+JgKEx0W0tTgaBMcTU/hAvyzPhL203T9sB6tj9ZjFNAOQClQXbgrAjLaROuyzaUK0+5maTUnn6lHaVfsz3i7w7DBV4i1P3bLgz4iTM18krNte+Tm+K1uwaqdHepw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zs+WHuZ9PejgQznOCY9pnleWhFDvSiC19XE8wasktAg=;
 b=M8Y7zRBnxfxUdyOlblnAK7VZoa7EecO0v+U//zboMn3kLLmcpodK1bHMhJZQWQ2fOyyiR0GN5GToZ/WNtEpDnuzb1FrscrWjqCg79oUTLiTjUTwF8zrrsW0dxCzpE8RkYzUu2EYFujaF9iXRR+9sE1+imYseV48zFmnRDlR4+RY5cO5ShH9LcmLQz2a+cF5ZtFnhC1ZdnwPCRMbiS2jIhgLLTSwbFYNPm4tQPzPUL5cBwZhZQonNSr5XGrd43uVnHQqAcY5SGlxyG2tj8KHxSkRltkuseJVIglmuCiWfrBPSkBUZcSXpMmFvfJ5YwFkMWCgdT35WHTz7XIAbNPzsug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs+WHuZ9PejgQznOCY9pnleWhFDvSiC19XE8wasktAg=;
 b=FLUDzgMwEbJs4oEK2zw2c0HEiBMioTgWbnTZLtQ9qSXbCs3ApM3x4PU9Jz444PWXbDBddlu4pI0WoCyLgl198DSW5N3j2/1PZCs+FNLoYWtdN0hhcxyzVzsoeunJ5XtArNHfTRXgSThCTqoqe8G6BIz9jSAu4cUPLk1Gp7CbaRw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 02:04:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 02:04:26 +0000
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Al Viro
 <viro@zeniv.linux.org.uk>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Use int type to store negative value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250902125017.41371-1-rongqianfeng@vivo.com> (Qianfeng Rong's
	message of "Tue, 2 Sep 2025 20:50:14 +0800")
Organization: Oracle Corporation
Message-ID: <yq1348v6p2a.fsf@ca-mkp.ca.oracle.com>
References: <20250902125017.41371-1-rongqianfeng@vivo.com>
Date: Tue, 09 Sep 2025 22:04:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQXPR0101CA0022.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7341:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd39cc4-d66d-43fd-e147-08ddf00e5e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8otFBafGtmYIsUDsDLHLLcQiqzzWDurTAKcV/T4suhVdLNyQ6giPTojdpekF?=
 =?us-ascii?Q?3+OtGBPAArafUX/qMakwxcwNN0FF9eqcYbq1L8QdecIGqjoDtlMHynJcwJ8N?=
 =?us-ascii?Q?MgZAsEuh6eWyFzRLOZ+X9SuBNjTveYoSH7MfKmIkBc+eYL0XZbL4sS5mB2kA?=
 =?us-ascii?Q?LD4fbKGfhDFYdxmyIYz2qaUA/+Xq2YOaKElQEDa0Da2ZRiAjGup7/UKspngk?=
 =?us-ascii?Q?OJD5EtQlvgrxs5NK46b03tfAWuUNCxqGA4n78oNSUO77UX1qFXuvKrvFlKlZ?=
 =?us-ascii?Q?B+9rn0T66ENOeIOvghu7SwQczKve+bo++rgiZdIAbYomtyTkPfiLN/PxKstq?=
 =?us-ascii?Q?4JEdsFXIPjJsxixELn97/nVAVVH9HhoQTelYw207mleOGowi8I47ojX9rQ/U?=
 =?us-ascii?Q?x8GzYD6WImArpUYPkdQi6igcx5PiJQYXziM+dAWwAJ0IalB9UEBdgVQSkmWd?=
 =?us-ascii?Q?3Ej18/y19uacAbzhLfUjcXY5EunhDj7AmYjuFN4LI7VQ7S7qFhT5R/3VWFXx?=
 =?us-ascii?Q?Zna4hpn+rLTuPp/knuTL3nFM5kPXQ6THepQe9p2aFZj+p2Up3wwNNQd2gpf1?=
 =?us-ascii?Q?NklCiy2b1X3jYC2QO9ANi7QULqptDMM3Z08zzD0EZi6YV/kDdenlEu19f4Gp?=
 =?us-ascii?Q?xhLqy5shbVFEKnf5+PL2q83ISl2kwmJi+DGDz3xQb2dfg7hDd4z5oSJRAm1y?=
 =?us-ascii?Q?t4e/yw9y2tcbBno7Loe9BGatMrRxTf+TG8reDKve60H7wqdojvVKRjTGr8Hd?=
 =?us-ascii?Q?mQUiki+yEyTbmy6BITTZS7lsyF/j/asabRYuU/KiOBNXm6cfXOw+Kb2KpUae?=
 =?us-ascii?Q?F4pkEuhOqfrGCqt75azDl418XFMgjdLwyO61KUyZJgHf9K1YAJPcFMnkGbMK?=
 =?us-ascii?Q?d2sqrPIrCY1lxqls93KRtoBLAGRiaNPugv2QpZ/VrzNyYF5iXDZfjPMHYwnT?=
 =?us-ascii?Q?IHY5H2wydIKrUsrrU49rtcoyK2EZPW+gF2UW13QvrgaqKyA/az86gfCUALom?=
 =?us-ascii?Q?GAP7rFppSB1t1xIGYoUd46X+KKYE6jE2HLi5W8288Av1Kxrth1731Ogo4AVB?=
 =?us-ascii?Q?mx6rM5ebt+YQBlev4BRcdYjIEECPoHxhPiO0PterZiGLCF13bi3Shb1dlb0G?=
 =?us-ascii?Q?PBaDB0ViUxz4IPazpnPmm1S24qnLj3a3lPcqmVJFUYy2CWfelTQJI7QrcPVM?=
 =?us-ascii?Q?Oz/IMQYc14LW9cBjrwHE7sjbazg/Gm+3nHoHcWNUDjCqbswGjk8ZR3PAvuI/?=
 =?us-ascii?Q?TocPrvzygJ28nj0KKCSBmYTB6ZCzmZInwWtFrt8HZ8QKhHHkm3+HaJE55w75?=
 =?us-ascii?Q?oaijbpLKaIMp0TEbUpizlZbey4CbT737R8jtPmUc4sG2OhgpB0DJhTluqbrX?=
 =?us-ascii?Q?PWjYy3sT+JV3l0VXcE+QUTCRBWFeMT0Vvywz+4yp91cxo2nEqYsKxfrD2KKa?=
 =?us-ascii?Q?gjsWQ+ZsKBc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wJUDg1PuTsxgdeQP6aKBgUYBI7Vjsoqza5Ohj2Ecjh334DQLIOSJ9xxM07jO?=
 =?us-ascii?Q?f7NB6rWgtOFsHtIQmYzSMlup7djJJqtKQPmF4q+uMnvpLpTzKWsgXNMpRm3p?=
 =?us-ascii?Q?fj0TQBPBkthKATOBwg/cZXXgaUe3bkFF/AfyJexTLvroCu63Bu9fJ0ACGYfk?=
 =?us-ascii?Q?RDgXE2PbHqcKTmhgSfEJUCshsGqBzyXjrhsQllZhLsoYshziE3kwXNgUDk2E?=
 =?us-ascii?Q?iY4IpclTbinigqqPxwxG60chEezmd36OwPMyw+chtBOjJnpP/IGby9Gcl0kv?=
 =?us-ascii?Q?h9fBTelMh1uFEbSpndorfMiKE51hKa+hmWzaveBUQPs5reHeh6tnO/vuvFWR?=
 =?us-ascii?Q?iLH2UkB/WiPxyGbSZpfh46DoJZBDgQ6XtczCcFm0BdalALvEvf33A3H5Ocl1?=
 =?us-ascii?Q?E56HaLOigo/RPgd9PkfO4a+R8UFS/PC1U3VXNT8iEyYI2TjKA9Kt+naVH31I?=
 =?us-ascii?Q?l1CDGr7178OTwcYRs5EqT+k2Np/4GFe3O7/51eDmtWo3RK7bbE1OdBpxU/SY?=
 =?us-ascii?Q?9XT2EEb4FCODpeV76iVTYw0tq8gZDFEUc3j1mflbbVaN4AMROX7mX3njvpTh?=
 =?us-ascii?Q?zb4L1bPLLSWn5ZeQpdOSnKOyGYDqUUtM9IUr9+oVHeoTmDBMyJff5fbq8Amq?=
 =?us-ascii?Q?3NpfMQVb5J07Iin1zJnaVVb5lK0E39ZePP33HUl1tO92viAG+e/ohrZqBLgF?=
 =?us-ascii?Q?VJGtlV75YG3xVQ0KPTKkNcSMOGyk4yKANa7FEH001NOBpTHqY1cyL/cJtxGt?=
 =?us-ascii?Q?A7BVKjuF7+X2AjQUR2sQ8tGrXH4vM/HJ6fev+UJhz3NvtPIATxpDvCZAQgPf?=
 =?us-ascii?Q?cajeXfxTPnWlZA8OaGksfmM+EN6wbum2LxIE306Hc7Ep8Ye9cgDrCRFXmYDx?=
 =?us-ascii?Q?vA8DkVOFY9GxJk+m+9tn1AvuscQU4YoKN23RhY9OY4XdoMVfqVqoQ2QdbJkj?=
 =?us-ascii?Q?Sxe9OImLOrb7P31S3ALv3f4Pg7DxwFO9cAoKatpNi0Af2H95o+d+fX0HpGfZ?=
 =?us-ascii?Q?JBVWeTmB/Yx5stkBrLZwPq0fyGAR5W2rbDlQRI4xCILZD8U9Qs6xIdg/0lGc?=
 =?us-ascii?Q?t3RshByJeZ9MBGt+6vuUUmyGFhDVfBFvMm15kZlV8dwiyN0d/t8SiESo13Eu?=
 =?us-ascii?Q?dLrvYgCQEXfOj7WGuv34rGTzvQiKXeVKGqlB9LcVUsbf/Vpmkj8DAnBm//Sg?=
 =?us-ascii?Q?RM+vlm5oOviKYbDtqSXta63CwJuM+RWdzF91KqI8bvf7e5rXBUTR8JueceP+?=
 =?us-ascii?Q?pGAlmtJRq6ArxBTwInNUIwC40m6WJx57sisjZMJVfGoKgZsKzdZKjGdK21Pm?=
 =?us-ascii?Q?yRLdunPFDMgF//ehiecXYSMRUKoyCOc0MKDPmj/twE+v/SA9fLDZke8yYJYb?=
 =?us-ascii?Q?bq2B+h65lyP9LGYcghNCaCARP2ITy+f6eWleOoKjW4FnweeBokDA/7J8ViOV?=
 =?us-ascii?Q?PM/NIOGXKMpbDtyGNL3VDGp3W/QwrYB69qX3M1bJQ8TAXmv4fOXZIUW0ZeOl?=
 =?us-ascii?Q?cFIODCKxfoDMl0oCjseJLhUG9kxOFY9g8Y0jGX0aO+URMA6mzDJ1YgX7DTi+?=
 =?us-ascii?Q?95Mecv4a0RgxiAAQ9ocsBXuZ6RBMRK5sXNATgkTYBBj6xOvmpjWaYUMrLPgw?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	afR5MT7V02eIH1C1+i5jf3hvBAo/99UpgDv1DF1wQKqY8taBXya22UnUnxu6fUf8HuT6D4ndEiJW7TjJDM/zzptRb4H4w39pXR1y46LfGiCiw3HyZNetplEBFXz+q6siqVgETGme+qCjQc8PAXm4m2bUreF4RyB8mMaJFi+eZEbwiT/bL7JaCht4oxQDXCD6SOHnOHvK8n6/U8cdD9oNRRy0+aKH0WFza6SR5wMAsWwRTwNpF1JCBRFWwBRulLRGF2yq3R9/cBSMwMG7wIgDB/NZ+SnM1B13Ic28hDorSAk+Z6Q+WtiZgz/foo8J9jHvhOIA8Kfr7FIRwI456WsIAIhvsmW35qGcgiKMzRVhT+YHGkgeJQitBWO6swpVMPvVcLktiXRN1SJMu0g5IA8ysnX8JZwtRBe70DgC3cCKRmNTtYb523f4gToZQIqsK8aCj+A8XFh9lSQYAqveeRBd/aKtqvl7VOzu/MpdY/nN9Oh2L/B+LRtzbW2dc8VP7pAsx9MnAs5T5npjoE2sky6a0rwS8XGkus+jM6UfJCdtCCDy/FHbFcipJ2bgArZmBXPoXrhaCHGmoI/d5297R5wz9UL1IKPKp8Cyn5c3NDoQaeY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd39cc4-d66d-43fd-e147-08ddf00e5e59
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:04:26.0840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aipzpmKMyFFvT1iJ8gkLrPBzqDrdt2nmetInJQsz6w+R+wsiZIWCIwuJBCpcx1QSbZ4LAWifJ/Mz0bwUjXuabGO4zME/vufcAMCiFgWlhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7341
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=687 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100014
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c0dcaf cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX7Ew3IZ02VCWf
 Vtll8oIo5roQh3oiWu4u3MGV0+ORIOAx1mGA68ZjxpNIi+MNK3TcHYu6mhdtn4ElDvBZs4rg1Xw
 hL9Ty+WT9cNsLm6Obdxd2CaTJKmdYwXyrVa5vt18k+fB86P/OZnJWA79U42ptW0dsBZyMB3HBlJ
 rUV5dM0PLmWHHTnttedJEgdXvkS/lJZu6uNm4waatS9cPSS8mXjcEdCxlifMSRibsCERenkw1fm
 KXCh1YMsjc3x/nLfTf/kNcNvprhJHVQKrEsKu6yjQvtZnwoSZfK1wua2Wf/VlN039JALx/7sY2d
 Km5GrdcADvQS3zolTFqHvzsU7IKhvO3x8etc9tu4FTSkjQu4iuoa6WMBrzB+xZLvpF98vQp8ELS
 crKUg8PN
X-Proofpoint-GUID: ngO09tffpjI4TTO9mngoshCiMuI5d6tH
X-Proofpoint-ORIG-GUID: ngO09tffpjI4TTO9mngoshCiMuI5d6tH


Qianfeng,

> Change the 'ret' variable in iscsit_tmr_task_reassign() from u64 to
> int, as it needs to store either negative value or zero returned by
> iscsit_find_cmd_for_recovery().

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
