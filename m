Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851952F83B4;
	Fri, 10 Oct 2025 14:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105751; cv=fail; b=jJTh1SDGfSbtS+iDYqwTlJ5qn9ISzrutBjiujtvLBVF4uNmzF52xNluCP//NdydzrgGGNoe+pmJfWUpuaIvaZYLjb4lXLg118dZnplP3OK76tILQnO8G7DmNxRcA91p5wqHzTz29xA+8Qa47RsKEAjgF3h0JUcP5+X7WqUSOPLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105751; c=relaxed/simple;
	bh=O0umhKrH86sZpLuIjLhjHtxr2ZaMuL5FOgq9frGoicI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CIbt3tn68nuYnfNkIS2JDDGMkqk3+fhee2f5NR9krob9IU4w5ft8yIm0xcja8lc+KU1l7rH4U4kiPqK28nbBFHXpVeHn2UhnmIA9m/MnhqyAwrP0QCP3E4IggEcR9Xbc7e+At6o24CO0pOKdGZzj5SfBPRdC3pLlcp91Ddw0tBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vjd2YcZC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kDKiairZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vjd2YcZC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kDKiairZ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tbA9023311;
	Fri, 10 Oct 2025 14:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dIa3ePwvAWaY3kw92znXX5CRVzoShcUAAqWtvkIt9Xk=; b=
	Vjd2YcZC55AcTdsG+rJZGuMO5Ow0LfFfDTg4Z50ApQf5YOVKAy1fGpTlchhPX32y
	cuZahF0xFEGsIVR9CdKef7iG55Env5c/dOyBowOMJNHA8FL2jgmE8uvIJlywfEyr
	ce0stIfuNiglqBXqWFRFFekskyRB6Gle/th53Uz6iVaU5zZxoGCNNlidSGEX1Dxb
	Oc7Itp/A2kQl8spH1ZkxqA4AejcbvWbJaplN5lFDHxdtP/L88aPKRVFD2ZMoL3S5
	jC1+3PpE/8kzyuOjSg1ZYKc/nxVo3MTmnFIk7b6a7cgRF10i4HWjJiEDZ1BHc8fn
	pT0vFDMZlaak38KqFNmFqw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv6bbu3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ACnOwa036988;
	Fri, 10 Oct 2025 14:15:47 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012041.outbound.protection.outlook.com [40.107.200.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49nv659qx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Roh53UpKI13fLx1tk1zfFhL2ePuM7NfhoOeEAGcoEG6Wx4ZAsVxT7RajEmP8SBko69UcfCk1s5LntmMGMy5QLgAuocPjwP/ff8rdz/PHdF5DX1hrfdXqh9trIrnRFOPuohgO7OV0bB+uCAPSBhvD+O6qrUyEMWwYYCDgAg/ONw4f1IU86eFU8aqjRI0QJM1dWhMIdQYkUUcq4neDXpFmwXCdc9z8nsQyZUIluzK7cFpyMD+0IqbrmRXzksB7D31Pxap9Y9hqDwxPnzze+ktfz6nWI3yh/imWd2K3SPzTh5w5kCWvjf/KTsr8pxVgy7kr2fuyZ3w+MbJAnAZhPfn4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIa3ePwvAWaY3kw92znXX5CRVzoShcUAAqWtvkIt9Xk=;
 b=goPK05BQCd6dmvi9ACBloQJ3wg9AyUDcBMaW/TDEjw5Hy/Y49HcM5ihcyeQuunJ3kPLaQ5ErY/pI6ZPWGaIgmWJEfGF9+US2Vt7jt9R3um0hPDEJysc9w09T/XbWJfLbqxk5qfpksNGwJxiDl9bLh6OcKOrPkMtW/zaxOLV4VMWMJqt+I6wV266lcpNh3Fwtu9o5KSulROzGiM4kErSuRZeeYLrPGEmAjxKfh9leZ1Jr+PfJQGtX2ZoGKVjT8EZFl1fsQ6hD3p5F2rQEG8SmZp5AhMw6Bh0o2AUrGw/Dqn39chlFOMc/y8fjX/N98T4vp5arAagTIpopD89Gp7qHSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIa3ePwvAWaY3kw92znXX5CRVzoShcUAAqWtvkIt9Xk=;
 b=kDKiairZO8WnPZA30xTq5Dh6XoonJEhzwkz5WpkleEQikX56ClXvuFh3/ncjauDvT+9lKSQ979uOXOSQ0Myq7EdwAR4qO3N8kjWt0qY9cax6Gve/5ngDo00tTe7NKHVVdpfTgE1miIYVls1tv0p+68CTzdl5bD1Cv/rXlVJNQGU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:44 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 7/7] scsi: target: Add atomic support to target_core_iblock
Date: Fri, 10 Oct 2025 14:15:08 +0000
Message-ID: <20251010141508.3695908-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251010141508.3695908-1-john.g.garry@oracle.com>
References: <20251010141508.3695908-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: 996e47e5-5114-438f-e5f7-08de08078008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SHSXEYy4+cEHXoJX2yeGlFH9liLht2WnDcZxEjK7BvYIyp4JFaE+aFV1u29Q?=
 =?us-ascii?Q?q4sLiXdi5t152fNlBeG9Oh6tjo9AfduLp0BpvlEv/tOkwyHZmuLvG62qqRmP?=
 =?us-ascii?Q?8IKYAwWEkC8dd3Xf+bjKiHnD//SPhKyN2K6a0IslooNiA6CF5XsxLlf9S8Ql?=
 =?us-ascii?Q?xR9ukYVRjLxUE2jm5AhOJUNeyWPDM0mohQjam7955aM8d39jjZaD2ELZl2A0?=
 =?us-ascii?Q?DZ5k9+CZ+pkVTt9XX3/7WO9pcQ7VUUGUpDmFXdrzQ7zF9cfDr8s5gA+POc/y?=
 =?us-ascii?Q?Z2fonszC8bIvmP5DL38ZppY94/P8tcQoNPGGAyRc6EtkfWiZrOgoV51lHf+c?=
 =?us-ascii?Q?3DDoGMmHUdseiXGP3c4eS3JX8FWNuNJJf1Oi1hRRBF5peH8xVlu1/0CvTSxU?=
 =?us-ascii?Q?MGj42ZoGDzMRYV317rCidCASHzqGwIMmBKpWk38OBXag9QN/YjUhR0rjgtGg?=
 =?us-ascii?Q?uAJW2YKCjc2fRC/LPGk23mt0lUoGf1s9MM/KcbbDntB/r0/mCJX+v/ds6Ecr?=
 =?us-ascii?Q?5TJIxCYDHAoQcsBHe3GEeLF8XuR3pAlZi74oqkGXiKz+XGF4BabwgZVDRnDJ?=
 =?us-ascii?Q?MOp8Y7370hHlrs/E0ceTp59/soslotZyJTFUXfMqKqw4rw6d+osJau8eE0sz?=
 =?us-ascii?Q?6J+fermQv4+LsGCVnnJV+SIZkyGgFtRu/xuRonk+3C2i52GkIHTIuSW90EQa?=
 =?us-ascii?Q?20Y8ZHLHiiTQM5+SQKOzidRpUnWRx/WAFrCVj/oTD9ABHuG8txdlViEMOne9?=
 =?us-ascii?Q?aLniyhCN2sm+95MH3eGUmi8KkzM9WPAq3+AFX6Os7suX+y4ct+Yf0cz9nxTy?=
 =?us-ascii?Q?Moo/hO8i/eSK7YPq//uWEr1F8yOmVI6OTVSLBJWHS76+b30FxOeXGFotJjlf?=
 =?us-ascii?Q?KVEOshZoQh26PlXc7fyDKr3riHFmnx75qO7hy4Dyy/BglElMEfiPcjsMJ10J?=
 =?us-ascii?Q?ZAcFgzb0vHVHsEj7El4G62stSsiPaKIifWWNwLYKVQ1e66AOh+uaDZ9BCSgf?=
 =?us-ascii?Q?VC+hFIDihPoVWqG8m9m93JGGBn24NTyoyCm3v6M0cNbHdUXlugaXvMy8C7+E?=
 =?us-ascii?Q?u8aGkjPvN+I4c9Dk7I+9W3b3wKCkiPPVPbi8wRgoGxUOn8MwVs1zqXS6FUAf?=
 =?us-ascii?Q?fgftcIKkDFXnClRS6WX1I+IiuNdTWNsixr4KyMT7vD5zUEwQqnFh+/CNzzNw?=
 =?us-ascii?Q?7yb2+8o7oNZZir9RnpQyehR2dUTceBu6ih4GJEXnayr2mY4FGxIQHoycL2Lt?=
 =?us-ascii?Q?KWvKkVSRxq1thgIhL9XnDs7nrUUuWb2KBpow8/gqo6DEmlSqp4+C2KX4CRoZ?=
 =?us-ascii?Q?aQa02YoNIzsSdwTLs5zsP3z7VqcLeIo+X3DU07Gsz0sYIy2SR7N5SgWa/fJW?=
 =?us-ascii?Q?5q2p6yiJbHprmuRHa/N4PaxnJyzmz7CJRJNnRNyFfk8iy115RHugwWURb1eV?=
 =?us-ascii?Q?G38KUJ7WKGWkgMSetdR2KzDZX4hO0PWW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n1BOgsWFGIDZRfMuazN4NuRMGwOXboTmERK1Q2tedJcQnrDmUcb6DFT6RhFW?=
 =?us-ascii?Q?/uBEYBmMg9FeDFWUaMFEt5jms+huat0TGWepZaH6eZ6ci9TJ5tAIFsY1RrnM?=
 =?us-ascii?Q?aAOcQRbS57wbtD+sedxJFM/hK5uZN6mFOJyOTcrGyY9trkKkddYOpYEH91mi?=
 =?us-ascii?Q?LUMbNWqvkHJ2FDtAJEamyGGl4Wfh45vsdr3ye+Q+tKmgG4YMNdLGnTWcZHNc?=
 =?us-ascii?Q?PjJI7KSgFO1QVf0xFNJKgypVhmMd6YHudS718nyjULUP0SNI49QHWBSuVZIA?=
 =?us-ascii?Q?8feG8ziSYCE1+YSzsVh232Dz6lb5LyV4+Jo78gf4sqWYyocDHwDWHrXqMJxm?=
 =?us-ascii?Q?Jgux9Pt5lFewn824Xo6tKjeSQ2a1ws9id50taFAuw+yYrDviLsSE1d0OjsjL?=
 =?us-ascii?Q?mFeQYll/yJcW0T7tVgd0dIHzCfFzzj1zEif3zFSwGqgqVvU2iMQefuNGOHPJ?=
 =?us-ascii?Q?xTjRI4wUADbUys/5BJXZk9FqxfKEpV1abPgAqzKpvpMUnTpAe88k5VuYIQ95?=
 =?us-ascii?Q?s+WsAITINz69b71Ua1xGiq8jiUrSUSip/dKW3v4N04XLnkVi+ugeahOkgpuW?=
 =?us-ascii?Q?evqImLPctli+gnMg9KN72RyfrQkqxI/i4FO95PIEw9SQTXzAl1AeRq3FBgFu?=
 =?us-ascii?Q?OHGgj5cvPsJNLevPN/478r4flkSBfUKnTjQbsMWAXBSXKXYE1Q0uHpkcyrS2?=
 =?us-ascii?Q?yGh9kuGfs9JOnZkGc3XthUvX86L2WobhgjwWArrPWq3Bgd0qHs24pj5BGwwr?=
 =?us-ascii?Q?UI7F33fZNhfp6i79lRIdpk1DWk6MRQbwa8BftEQdEXw8cglmpmewl/U4uwg9?=
 =?us-ascii?Q?rDd9sXMNL3T8EWfKHVkZXah8eRv0e2m+VJpf7FLGdpT+2UIssUz1lT7e3p1Z?=
 =?us-ascii?Q?yzKZuH0tMXBw6puNRJv4+tu9TRS9/gAxwb/1SqQrE8BqGmxMHq7bzNiLFFwy?=
 =?us-ascii?Q?+4ZDNKRjbmKr4bC9OmqnUGFk5Q5dSvxzUsigmiXkVaFO1KypyAUjUA1I45xf?=
 =?us-ascii?Q?jcWVwIu7zU2H/COyBw36UtXdbdf7GJrIwNLJXdl/q40PHTR+jh4SJ/HKD0O/?=
 =?us-ascii?Q?+Xi9XCAO3LePT+FWzZskDKSnchDoLw5/nK/dS1J1LUJl6DRdNtI+39GwmeB2?=
 =?us-ascii?Q?LO3hVKYrF6C8K8MR6QwdcBapTr06F33RyA32iwXitAe6THS0NlQ8TuqPNPTx?=
 =?us-ascii?Q?HnVdTaTeX7rtlYlPFEnvvGVHkNyYxbmWbzmeHsxDgnxfAS6qgqYyJ7ryqUhE?=
 =?us-ascii?Q?Tvm8/sOSidwCK+GsNfpcQ33qaNVvfeqizzVG5/oozAEYIuECKKyd9VHfLcLz?=
 =?us-ascii?Q?sGo/SqplhXxYOSfxfCPpCNGc2HNVl+W6ekkYVayvP7lw8AwNDekIOvHBWglG?=
 =?us-ascii?Q?VKWz17fyFaKDAHyx5LkVQGr8Zlg83AKE9uvvf0bOFFH7dMsvvmZwLaSKpk13?=
 =?us-ascii?Q?yJVAF0dV1YYbGsIIQaAc82ybu6C4ns1E4KxmWiEIW9T0v8zKaA0ydSwwjR6v?=
 =?us-ascii?Q?vz9KsZLSu67ID3cByz2DaJQrsuIBCOQF39DJ/e9mJwBW93A4YWi+frajMF4q?=
 =?us-ascii?Q?qqG1isgKhD+Gx/yudDG4i0zzVYbJBQTioRlgbhAntDKscPKvnlnU5TukPgQ2?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cEgIuvulxygYNwoBYe0OXvP3kzWAHLDkGgpSfwx3ACz+cQcew/Sgwgk4PsEhSMHK8fP+8QFKnOV3+D3W8ArJ00EvvMIapgJBq8GFlLTcPRlIIFfQCtW21huO8Y9R5Zk4P5RES5W0uj4q+euvZO0jASNirekhzHH84LcF+GDeJENo4Dsir+8b7IEqYlYox38/hn5r23VFF6OXi3Wz8h799jOSByuIaBajuB6rNAok94PKzyOAIwvmcmlIdMPOPVDBQM6RWUh/iEuq29LER+WnYYZhc/LqM9OYVrmnabV5p1cmSaJ/war/inlw8kqnWJow7c9goE458F209PCgoaTYxCzgZF7LeHKDEogzPQiO21Eybklhi3JOA5v2Fl3qgrYggg0cr8cXL14+9N2lhhbYL+IVEj2d9GVboui893ot6UNHu+wc1dnj5SAEPOdXNqlH+72XJiTDuiswiwJOckgzsVGLL8kJxwfFURMyewt2+pqvD+tZAl4ZuRKUm5J3AkO+UtEaEjolxd8cVkaURgIH388tr8yELP/LS9g+ti80duOZ+QAaNYUays51OJajXmvGMQeBmkYlXZwmnx3ygxKTYp5nZxKl4XDWIngXcBThg04=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 996e47e5-5114-438f-e5f7-08de08078008
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:44.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytLNExyUZDF1yAeog5guairCd6d7cp7AXJkDpbR7yI+XNDvWwyJtYM6qy7xttp4/qj6+SBpRCpQ1OV4o6ZmEiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510100082
X-Proofpoint-GUID: iTfZDEpK96a25z_VjPK61zjVy_le_1X0
X-Authority-Analysis: v=2.4 cv=Nb7rFmD4 c=1 sm=1 tr=0 ts=68e91514 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=zDhUAMABgqaCYlsd0_oA:9 cc=ntf
 awl=host:13624
X-Proofpoint-ORIG-GUID: iTfZDEpK96a25z_VjPK61zjVy_le_1X0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX0VE7EMjUDjZt
 JyNAv+GSZHK4K62P0thvYKoQmsiOsektif3oCzVRRh7StdsFLGOs/aeDngtUeHT+BDQadrOXMrt
 A70Vj6liMd0Uj+HWz03lXY8m9VWuJDUyClkSJEtvWdFLqEp1kxRdygZC379Ok/XmBXI2JWzZ+bs
 5j2u8HmZCTAGhx8DsQn/qWKT7larelgvWJy9mN6oGPC3Ukmq1dXsHrd8/uVpg4qBkJrWVeD2I4e
 91buXwVVYUpHrqX5xTphXPvf20KPrqI3bja1cpeEQwy3ckABiTE3Hccke9yGIV1rAoTjQ9URKxZ
 h7iCKRIssXLPNd6OShrYYV7P3oJSLmIutb1Oop20xLgO1hncrmi9bW45UoTj5+xpMUViiCqguAm
 v86b7GskeD/6sL3eGjOxQC3ATjPVlnBica2UyJDvjlhKM5hvaKM=

From: Mike Christie <michael.christie@oracle.com>

This has target_core_iblock use the LIO helper function to translate its
block_device atomic settings to LIO settings. If we then get a write
that LIO has indicated is atomic via the SCF_ATOMIC flag, we use the
REQ_ATOMIC flag to tell the block layer to perform an atomic write.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_iblock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 281612b9830f8..8ec7b534ad760 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -152,6 +152,8 @@ static int iblock_configure_device(struct se_device *dev)
 	if (bdev_nonrot(bd))
 		dev->dev_attrib.is_nonrot = 1;
 
+	target_configure_write_atomic_from_bdev(&dev->dev_attrib, bd);
+
 	bi = bdev_get_integrity(bd);
 	if (!bi)
 		return 0;
@@ -773,6 +775,9 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			else if (!bdev_write_cache(ib_dev->ibd_bd))
 				opf |= REQ_FUA;
 		}
+
+		if (cmd->se_cmd_flags & SCF_ATOMIC)
+			opf |= REQ_ATOMIC;
 	} else {
 		opf = REQ_OP_READ;
 		miter_dir = SG_MITER_FROM_SG;
-- 
2.43.5

