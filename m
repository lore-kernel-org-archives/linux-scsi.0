Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475662DCBF7;
	Wed, 17 Sep 2025 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758147242; cv=fail; b=qElgqeo5gOFtp1BPsD2O2gVipA16kK8xhOqMYvXsQbnQAy9BxIGfY03O5HFTpx0sNMYoUHnVU5b9iSEc2QHTZWsFnMbmCbJZPwZssMVqB8x9zAfzrWUwTB5Bk3I4xLpw/eccD+Z+sBv9rJh/G/VWUBVdyOjJfu/l88x2q7oWT44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758147242; c=relaxed/simple;
	bh=2twQx32FHxwhihWDpfoVg8mwox8MwVgH7lxy18cgtIw=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=u39J9xrC/PtT9esJkbGVJe7KlSL1/SR1oJHPxEcimDnFqrzJYB+21ymtmprNkPKNz6GwafXgpCGdO/e61S9pmAPYOfOAGrBT9X5Zti1gqt/R7D1WeqYxBcBwP6FMOxJQtrBtmuA0+Xjq7ZqdeuWk+FG+xlFaWJSUYrXnCrONWs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mm3rmxOf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D76gWOTM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mm3rmxOf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D76gWOTM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIVKq008351;
	Wed, 17 Sep 2025 22:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=2twQx32FHxwhihWD
	pfoVg8mwox8MwVgH7lxy18cgtIw=; b=Mm3rmxOfLHjpX3/uzg9mvURdgG1yDCgl
	MR1t7NuDlg/+qsWziH8D0XVSeV5djEqez7wk9KuYTBwlkaLE0+sLIO1QE922O5VZ
	AnoBR54g5xI7WVpzHMeYYiQTFfBUqiN6YW7rEYjAbaAs88soRtz4YhAmr/Nudi2Q
	vYergg9VU01vJXQ8aCW11VDh0dk/Rrz+jLImhtp9P0WH4k6k931+lq6iFbcLurla
	u6lqhH31WLQrtLcMNxR2z0FjnvgrjgUgVXiKvBPHgoEi27pjy+sV9xMgfqpAXwR5
	01jCrBzwpb/UrBLxtOvfq4RfszhLEzqaeOS3lNmK6D5ecaOdxXsX+Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx8j7fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HJocRY028809;
	Wed, 17 Sep 2025 22:13:45 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2eaq33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yze3/ybKme6KGCNFhOPIVpl3HJCnh92NrykNYHdS1SYNFcER4FyPL10l3x2w9JkZaZCtG6sQKqoTRlCdagVOth1wmUT/v1RVkA1DQ93HsQImSGiUZVvPFcHdS9OCcsAWs8KWjaG7QcvgBTF57If6Q5pSBdIZ7X095CJF9QPF7IirY/0xkpiJMSruCUyEkCdKhIf2VjKuXU7mQE8aPtq933Sjs8z0kJjndV4K9QnflBzjFzKY+7FQgoQzi2OhtznFUsLAyseaT7iSK05gQGCXcPDpedhko9wYqR3ZCXLItVpEknQc263rXfOMUW34k3PuWfpfF5EcmkRP84tH7MexhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2twQx32FHxwhihWDpfoVg8mwox8MwVgH7lxy18cgtIw=;
 b=dYHXXNB0hQvmzFVwco0mvkmmUc81Ckns8Nn9eccy61NgusZGwVOuAWmrPEOQrSevl5zkC+YPHtefOTFUZ2TSwa4oTaLeDcyJn3hF7zg/3L4PnuZH3wON2qTITa5pL0Qzjc6rkNStX71+mnJHteGTkbjia3x4RnfIP/v1575CUW/3ubgoT2A3aYdRYazW6RWnMOEMMlfw3V9wsSdD2Mwn+57mYpxI+ZRx8hpHwgXlvlb0XV5uCj3VZI3DL3b6vMMMgOiBLzxKVRG7Jw9WFRWiGChf75/sGTiJsCw2W9fNnOVjIuy0gDgxbx8H0a/foilxSg7RmUmCG53a+MetDeriJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2twQx32FHxwhihWDpfoVg8mwox8MwVgH7lxy18cgtIw=;
 b=D76gWOTMjNO42qztIKmfjSZuNw3esYioNhdsG6opWUUHfJHZS35pAsRJOiQR6qPzNBbm9fVGtC3bbTwYmuw+WJNHHsDI/BkF7caksbsGnInw+OfFO7LqdPoODVhFKZ9PTzjMPtayNNLTz72ls8uL+ddf9bsFbSPYcu5WA9O/+QU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7564.namprd10.prod.outlook.com (2603:10b6:610:17d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Wed, 17 Sep
 2025 22:13:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 22:13:40 +0000
From: Mike Christie <michael.christie@oracle.com>
To: mlombard@redhat.com, martin.petersen@oracle.com, d.bogdanov@yadro.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v3 0/3] target: RW/num_cmds stats improvements
Date: Wed, 17 Sep 2025 17:12:52 -0500
Message-ID: <20250917221338.14813-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR18CA0003.namprd18.prod.outlook.com
 (2603:10b6:5:15b::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: 034878d8-7a04-4fc2-7a90-08ddf6377523
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LrTdBDvaLvF2mWe/O5KZhP4u4RlbN1H0sCzv4f86CnVoOr/3hhpzN6s67Jji?=
 =?us-ascii?Q?iBqHAXqnA+HpX8pUz9BODCeBHL7N45N6sPkLfZdJHiswo4K0ksuhg1EAnx6W?=
 =?us-ascii?Q?1ngP4KH/iUMYn46Gb8oAXIHLpVBQdiX06xgdG9iD3tLtiwVfEttK0cvQM2t+?=
 =?us-ascii?Q?0RU2g9rDylTbohbirrgpKufREk8jiliUeNiNMSvhcpVUQN1aY1eghjA4T8c5?=
 =?us-ascii?Q?TGpjQWpNIE4ZV80/aaQcG1JXOqlJdKDttoq8jfKSzgKnbb11AIQITYEk/RIx?=
 =?us-ascii?Q?1o/bRS0ZNmPCbPwoOwPnWSy7hKdnqDVMWTIfm30xehwxKxHxwgPqFulUMrxb?=
 =?us-ascii?Q?mzTEr7dj5Lij1u0dUGsX5TOaZ1un9OSrMpwq/0k9ex0d05iv/xu/awl9SbGt?=
 =?us-ascii?Q?Y2ySFjhUFYsXxDZKF8V4/nAe0BLtj92SLiSYtvbrUU5FClrsJ94hdImQVwJ7?=
 =?us-ascii?Q?+ytfl6eY3DHwQZd2qviQ25hg2yE0QecP9krjOS9q6J64Mi7UuhHUPauawU6U?=
 =?us-ascii?Q?6kXwHJjyGWsXukFstSAt+6k1ObD9b0or+X/L0CsteWel909x/XI0Y17kGmwk?=
 =?us-ascii?Q?9unjx0NraR2er2Nk34+62RbNIFyh+y65I11zbuKSBbWwZoQmnWc0ZcXTi+TN?=
 =?us-ascii?Q?sJWb0i0EX6JRiJEP5wmZ8535MWV2E7Xhvw3Dca+sEbJgto17pKH79nGGh5tm?=
 =?us-ascii?Q?nEbYxqR/xFxx54IhKWi36C48GgKWp1N6rrNcnkREkii4xUVM5mQma5AgypEP?=
 =?us-ascii?Q?o3BWDLxgFs0p29kGbHcAh+3J5/HoENKf+IqwduPPr0tqwsn31EaCH/QWK4PE?=
 =?us-ascii?Q?WyzSRfWeqVXHkhiWahoInl49PJsgS81WZFzK1MUww4dh3UOkgskpFxkvU/sV?=
 =?us-ascii?Q?j1v1g3HbdD5spAr5I0ngFRBK/TwEP2rFnFjI2itQPG/TE3gOje5xOa3IqY+I?=
 =?us-ascii?Q?jt+O2j1tjTnjwDaELRGX9+P0bDE/FHe6JYdJDFSmolS32S2LpDHRk4f4YqkV?=
 =?us-ascii?Q?pzbM4D1+VoKs1F6wrB7cgHzDE9jqveIVMoCmtJTfNfXqnqmdQoKTqLhRW+yH?=
 =?us-ascii?Q?bfVX1L91JKbGlMKAcG5AlhPW7gYfTSMUaVkQGUQfve3ZO5DV6FvNzOyh7WxJ?=
 =?us-ascii?Q?aWvaBOFoHaBpO2JsOd/dKO63+PQOJV8TT1LvOLEoEwGZsd5+IWwmjs7dJPUG?=
 =?us-ascii?Q?AmJvwxUMiKgLBt0gvv4yBbFuGvRJQr6w5eu0axB+f3lbr4sBOdzrnbE8aeJd?=
 =?us-ascii?Q?fpQlK6yod1AsH4VzchQSwGUsEySpKrV/7FN2AK+Xj6wIefsyfijCxihPaT/5?=
 =?us-ascii?Q?bkHzayR6a4mAFEIn1nbKhd/3mtadUjlc+T3uCgLwfmbOy3nAcyVM3vIYzpon?=
 =?us-ascii?Q?tVZxD84Y+O+8RCOk4XHsWbMpT2ZSeh7U56Zc4cdVQ5wzwjNBLRKmhzp9qcdE?=
 =?us-ascii?Q?h/6IwP4Oazg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4cRH57jerzOdI31lHzcod7bPE8vU73RurkCpVp2BZlwVjhtxTchkT2JoUftY?=
 =?us-ascii?Q?kYwX1CGCArnx0kBmOu0vs+1+l3T72J/YtmaSEXlK1NpGPQ3m7sAKPig3eXl1?=
 =?us-ascii?Q?XN7nfakpIRNx0x/cj7GMdslPmN/vlHrdVSMiO8Xz3XwanY2mKebZq9KPvjB1?=
 =?us-ascii?Q?l8cGI8iSUzioYLzqS22syLPci5cIMjRcOkY3t3nrM18wqV0qZEZCqNO4hr+F?=
 =?us-ascii?Q?Hp2VXDGGrq3/ZdRGrXwERu6l9oywRiJf06jEFpJo9ljVJcQ59DJ5mJiVh4rC?=
 =?us-ascii?Q?BzkVk27sC3Pu8dq5MF8mfrOItIWkDPnb4mRzz2J2z0VLBMK9KuJQ39owcYWD?=
 =?us-ascii?Q?17+fODL/Or2ThtQIxo2oPPAM6dsurrG7b/0ILC5+fVf4bx1x4+seKLayvJub?=
 =?us-ascii?Q?nfyCRgId/eHHe26VIyVf/o9HpCDRbV5Kuo6fdCWqm+71dsl6kQTL5BiUUx41?=
 =?us-ascii?Q?GuvxQYkvXj6AI9/CE0gaxZp379aJtKNDYH9RfVkVt01f3sMRpPMPEsBPPJ3g?=
 =?us-ascii?Q?0dbWcT92FXKoE1E5Ls4GA8Qa0Uej5B/xCshPoyEjXjYeNuh8nnRFgkgJPGVe?=
 =?us-ascii?Q?5EjtG6aZ+MXWe/ofVa5EKN6TvDHtjjwoANdiG+u+1IwKEJW1jf8ASQFATKWH?=
 =?us-ascii?Q?E0H/eDe9ZyyyuF6ggwKfqIyHD7FjE1/qTIeKX/cDzeEkxtIgcnkYaLBtHZ86?=
 =?us-ascii?Q?g3G4NC+2Ku52Io+GCeWSVhQDZb04fKfI8pHGIaXEw3C0kKwLuUTIai40cxlF?=
 =?us-ascii?Q?Fc0u+N2pXjVD2gloKtMcpbgUezUagP/EpKD3VKodHhBpEageYmWdqpRW+Sq2?=
 =?us-ascii?Q?bClJsu2k10d8OCiEx513hice3U6EQJTVEsDV6wo5xqveENDziC20iYZ4sVL5?=
 =?us-ascii?Q?zfNZc5+8auSrC8O26CANYELmrNTiw7PKfXvd7eIAdfFzivZHgqh3FHru0xEN?=
 =?us-ascii?Q?9dHXzlSqhQY10D3ryZxPQEedagMRMlEqRD17b1K+Osg9qVipsa+TY83tEOwb?=
 =?us-ascii?Q?tj9EJm6SqxtxfCP3MJUlXX1ULQs/Q/TwjrMN6v7A+zzzVyO2iw9+g+n2wq48?=
 =?us-ascii?Q?V6dQWK9gYiBUrr5/zbrA9EZeDNl8Q1Db1Py6s9QBiwHvUraKY6zCpwzck1YW?=
 =?us-ascii?Q?IEsCDHS21zBSUH3sPr69Bheh4b2IVrUEbGBUwEsfuyoO87xsZM69N/Wd5wjn?=
 =?us-ascii?Q?SJMsWxhCjQg6RXPDgbozl2g1i47Bz4fS3jQGiPpVcRKRg/S6BZ1GhBoANv6H?=
 =?us-ascii?Q?+1MTiy8QqCYNizpueyzr/TvSGnl6ikFF7vN5oaEMhkw3AUHNNOtqg4Qq/JD3?=
 =?us-ascii?Q?JgfHKmxvOtpVqLqkgwVmsoEt98XjwVfB0XSCLmWsvNQnRRMnFcdrV4EF76Ly?=
 =?us-ascii?Q?7H86j03FjLL84LSrZ2CjS1IJ/7v3xwS5Y+D8DQGYLS78oPADSTVSqTX3KScP?=
 =?us-ascii?Q?fdSKfWzKZAx1t9rvs8UiOvdoTgfxdjArcezjTFb4krEfYfUuhwgl5xYGRo4I?=
 =?us-ascii?Q?NQOwJ3BuucQ85g35Yk65DxDp0s2JPhBOB9FDhEnbqaS9EenrGe9CuHQaVUoJ?=
 =?us-ascii?Q?xROqAJzJAIu6VvnTjDxv/6aFTjmlc5ckVKA3otB4AcGxqRe1BUTNpX/YRKdt?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3bq8bTwEdgJnYDcYlHh+QujW2XCxAVHGes+ndkG4oB28xXqxt6EPVJgmoBgsVbpF8WzefIILc1DaYEuFQ4PQizr3Rh6uIoWTpn07x/tC0kplYXroV4YvsYVobbaglSCyoD4gMzSCdJ/G7ojY01eOpZJNL+IBlxO/8wipTuIbrgMr6cYJNI1c4BFXTtO75Bwe8VQySf3nV6qWyWtzcRqyQYtvahWQ2AOz9qB0YwbjCGwltfKp1OpypUVXvLGlE0bvc5WjDyiH9UjsheIoSXCXcSCMSgx0XhqpHPooVcjTgOVs/Pmcnp6yi6HjqoZtkn0igXxNuj2DwMJT0w9c7weFQCWurDOXRYV5hafB08IoXhfM3+89XcznShsLRFCR8wqIRCmoyvYLS2yzT8mea/HeuCw82fGb5m3iVddVfVCXMz/I8CO9c+tYst3FBmL52u3sDLGoR7E1na7whXO+id4Ns795HCFNCDFB8O67DVezARg0SQejx3bO5NEEgXPHeQMffExIa8qGm4509GNGctujV8Sn9eQA9oonkhl06mXXuY3pyTm6pSNK66BFZseRdGZjpztLIoeJpHJDpfBKkLOq6cbLWD6Srxfg9c/WpMZGdSE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034878d8-7a04-4fc2-7a90-08ddf6377523
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 22:13:40.7036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rIA6EOSKhb2Ciigajyjn5mF1g+VNXKTuKcPS99GROhm7kEoTlwCsd5LThw5twgqlmpHF//zvlXgZKSFGT5CmUhni0dl8uibi9BStNpJGpBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170215
X-Authority-Analysis: v=2.4 cv=JNU7s9Kb c=1 sm=1 tr=0 ts=68cb329a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=Skh9uH65IMUAabULJg8A:9
X-Proofpoint-ORIG-GUID: Gwfnibc5IhtAQMws5TWpdk9rivo22A3k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX1RUeHtggdTKv
 9A50qOSZgd2+OssIRJNcV2vP1YB3TmAifam/eJmZdtHyiO50TjghgYXqrFgdKJR5esdT0pKUpxw
 N0HqNbvnuskU6JPNlpQqeJBcV3IvYgw2CTO9wFNWiaFEFiTdOdL0CpNp2PH+54GHjmJFvOOlLC+
 4pdIs4Uy3W5gWSW2L8UGeBZoxGTqblVqejGSOSOMJYyVJiNCzu0/RO2knFcr5/TchEwrhDoxxOy
 1jbBrx0hw9cMA1W5rWgkXPTolhRZFv5TVfgjm/Ua9ecoRobkDe127DSAQBRZuLbevZqff4NDPVY
 W4QYcApUh4F+cT8o5NLTWmIR/FwgfSHg0K4jVEQsapkYEYcIS6UKCg5cbt39YYE1zxXs8Bdirjx
 1u+b9d1i
X-Proofpoint-GUID: Gwfnibc5IhtAQMws5TWpdk9rivo22A3k

The following patches were made over Linus tree. They fix/improve the
stats used in the main IO path. The first patch fixes an issue where
I made some stats u32 when they should have stayed u64. The rest of
the patches improve the handling of RW/num_cmds stats to reduce code
duplication and improve performance.

V3:
- Fix ENOMEM/ret use.
V2:
- Research if percpu_counters would work.
- Add patch to fix u32 use.
- Fix several issues in last patch: do unsigned 64 bit counters, fix
remote xcopy handling, fix default lun0 error cleanup path, fix
byte to mbyte conversion.

