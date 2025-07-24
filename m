Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC4BA48;
	Thu, 24 Jul 2025 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753317972; cv=fail; b=VJH5i9aogRM6KLGDb+NH0rcfu5a1C74hvzeRbTetxBkLGN1vRFKA5kpMpbjvNDzwTTBkSJTjQIVPSp48oEcvVqDUqIElbo0jRFjOoSGwdRxF5Y4C7YipT7Ifr7N0GX7U9bzR2Q/zZhdoAKT1oEGxQjNECSMilULS4WCrsQnobik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753317972; c=relaxed/simple;
	bh=xIiigj08t3oZyEnhxTPU1hfwz5jrFE2kcpXxZxb4GA4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rEk/Q972aozb9XOSQnjf2ptYqQzkblie/mq8rBeIDniIVRFGxUlyZqnawS7R+BQQOxxBp7cT1CGBjlHVXs1TTVRsGiXBLxmuKHWCl/TIJBVpsQooUZUr2RNqTikr5DBcJ0yI4YTj1wC0JhjwkLQQDAxE4f/vfOcZ2iiSqvCdmTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UOe3KAu4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pN9ZVHO8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UOe3KAu4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pN9ZVHO8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NLQqEZ022431;
	Thu, 24 Jul 2025 00:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=XzJnLoVpCdY95vl/
	QPMxVVF/OsoCu25x22iZicdBtHI=; b=UOe3KAu4tD16FPiCXy2P5i1no4FkK+hI
	w/0UtaLSNvSgzxOnfFheHR5uIziU4cnsUySwVr4S/L7geMVMajMeOiJMMnjaRDNg
	3paVStOjrU8a4vj+L2WI9lGoKVqidwAHhkFQTT+Ya5iN2rfoJpBX58lhswG7aIU5
	IfBp3aPwJnTwTEfpOfbjQe7CKugDal95fiJP1kBxNE167ZkyTpokt2R65ncrEvl2
	hKPYRMTewV54nIqj5VOsCPTPvMSrRTvpa21xodY1iEO6ABc+S9cSykrtfiB0LIIR
	9boCnUjcAcG5q1jfdVyKvulZB+UqWEFG9c4vsncO3IHIsDOrJ6tPcg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805gprq8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 00:46:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NM7RZK031476;
	Thu, 24 Jul 2025 00:46:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801thj9kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 00:46:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1euPPpRpf1gw4IpfqFhl5Wxf5nqKMEq4RyiC426uRzGgJuVGs5zcct/jODJK/0r91PGTRj44RK8HbN0jbrScBJaBGtmuN4WoLN7mBfFhYvqLJRr8CG0hH3TA/mrsnk5kbgOczU8Xs7OeIgil5HAtgspFFLxDdyyjHa39VgRXLDWoKXpib+ECduNd69luaBv4XuqPzCTxFuDAIULfTgMOLvrLRpnqZ/KEUt5EGIWBUrH9+u5Aw0+MPrCMTUun8G6v3qRIqWG05HuuUYYeHAbBMFqkmD7I4vCYajqg5wa167URmfHqmDd3W3J3o33ysDWwEZQ0dYbKK7+LFJfNIsR4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzJnLoVpCdY95vl/QPMxVVF/OsoCu25x22iZicdBtHI=;
 b=Ih04t1m6wV6RNH2RwEch41nTFvgjCIK7rfysbILHPPzKITf/LYFew0JtL9gc72G+HDuxnE7wawG6Se10KU5vlFs0weDU6VEB8qNwx+H0sPg+uF/0OWvWcjp5U+rs84C89zwe9VC/tn702b4qhR2M9EVyYctu8qQvCv0OFk1zFUY3nYtotsFRh9MqiCXUTgCLZssVjlMzsdZ1mIamM1d1/RDx36NS45Iwjzc1kym6xx6G4hBJxLhmOzdtLRyLg3TBwBluZTvUSVkinVCW8XBV35WE5Cw1covpKwHpE97WSE1Bw14paholhnnENSIKFu8B3IMlk2HB5kasL84jVSP+1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzJnLoVpCdY95vl/QPMxVVF/OsoCu25x22iZicdBtHI=;
 b=pN9ZVHO8Wn46hmSrt7s0UHWtF9QfSaabDr63I6fokAX8O2GTW7MssXtQfY5eguTaxJMEitful4gPfQ/Ijyr56nfTI72TZ3GnMOby24tfvh5zkAH/m1GsxM7nlNGf8qiCVGSyqX1KAtdac3dEnzjlt9U3PlciA9mHkO+5zBTkP7c=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA4PR10MB8375.namprd10.prod.outlook.com (2603:10b6:208:560::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 00:46:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 00:46:00 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: target: Move LUN stats to per CPU
Date: Wed, 23 Jul 2025 19:45:57 -0500
Message-ID: <20250724004558.40993-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:5:190::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA4PR10MB8375:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a27a80-a398-446b-a080-08ddca4b7558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SFdWxHSInZsDCHSiS3aYAF7UxrJZ/11QLJGguAxFdyj+AV3e8Wkm2OvAEs5a?=
 =?us-ascii?Q?8E4dNweWhRhZEsOFpqqPXCWSye626JFtwoMLIz0YVWUp8wFVFuc/FJLrR9Po?=
 =?us-ascii?Q?U1Xr8ZcxSYzQ4p70xTdJc2pqUcxtWVxWKKYZc8NBRsMMVH2Mw84UIzd2VczF?=
 =?us-ascii?Q?pRzS4IlW6Lx8ekr6Z9t/ZVgRYIOwUQDPIyUvyPvKUZqavJCSwFCZU7B5m6Qu?=
 =?us-ascii?Q?nviRP4T+3TYJKRdxJWlvTOtNOymqybe9fReTuLobF7hTYpfaDHwWczwU7oG5?=
 =?us-ascii?Q?wEgLYuclBUCUGNgSGzJP8cPioKBWD9YMn7aZrG863uFIux3p4MQyziQcRUuD?=
 =?us-ascii?Q?bjZeD9yfUuxUgiI3yqm0XiLPtN+Xc84G+jTRYMeAcErUteP/sL7TpL7NSPzZ?=
 =?us-ascii?Q?nu3dDSg40kMTXE4d4icuU0mN6RVoePSRRsPMn9JKNZQ8LOkemnGeb372iiZ1?=
 =?us-ascii?Q?YL8LbLQbW9tyLHkwvW+vm8eAGkMddaQYzLjZBi6dUBAWyQlMbOrNqASZl/rn?=
 =?us-ascii?Q?lyzK+eK5gFq5N4pnD+D7irfhrFJAGSqinjf2TeB0oS73YjYRU1jH++rGZc/W?=
 =?us-ascii?Q?xhPXZosBEjsGUHN1I2C4pFLUziWfvDHpNO9mmuIVdNBHixlHnidOb3ZbXIpC?=
 =?us-ascii?Q?RrcaM78jnq+dyVwiHsfiUIbb2u+CRxafcUa6TCoTmBtOVDkuOlP5325iL1fv?=
 =?us-ascii?Q?OlYsI5s9Anlx4npIv+hVV3uEBUaK/H5P9R1TNWtUMKgeQUaazWi+Rjuv2vPP?=
 =?us-ascii?Q?rcsDXa16MnDyOKuMsPoUVmDTuOZT5K74E/f4RLk19fUauGpqSbeVaL7ykggt?=
 =?us-ascii?Q?kxJ6/eJb0Q9bTBnGEIZroIIeUtxMaXLxHsmmhR1H4/6CwFmDjtPc4sSfCmAV?=
 =?us-ascii?Q?2ovm5t0WmKpK85gaGd/8/znDXcekqHv3YfAwZLDW7FVFao0QQZBt6TVa2b94?=
 =?us-ascii?Q?rPPwbc8PVJB06erPsHu3c+1b0XukO5p4kK6zUYgZiRM9g/hxR0mOd6qk5U8Y?=
 =?us-ascii?Q?lKRpqT+Jm2/dJKp+Cdrrqrmo6EbSWB6/eooImPzptG2wDYFcFM/l9kO7mkxu?=
 =?us-ascii?Q?oeO7vqQxoybcuzsqOAevMokpVud8O8zcd5VbqNkjiBpmWBcpxj/bvTYp45kj?=
 =?us-ascii?Q?+377rfc6cHr5kKI+snpRQwN8bzj2L9RDEa/6m/gZ7X/VatMh1rOS0XUhQNyo?=
 =?us-ascii?Q?vRWePcdq8Yw54O4ncb0z5/3z1SVp6AURDKCTK12xWoN/4EuCZ/CqpmXaFldf?=
 =?us-ascii?Q?Go+g5+csM8X09pW4CxjcxZUE7toYztyD+tf6BjOZUMMjYTMorAE28bAVsyIL?=
 =?us-ascii?Q?ViFPxH9NPnhtUaRv4y8cbcDXeulLfBRlHLMo+qqaMwVDiVEcmcHm6kI/RPKJ?=
 =?us-ascii?Q?7/aDOJdKeYNVvzqK/BCBhXZqL3W1zd2FtgpXxCZIIH0QgG9vvkcYxiENdpji?=
 =?us-ascii?Q?QRrFx3zPFoQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XoaMbJmuDTp2JZ23bCNEHUIq/lXH5PNll1Un6gJQKEMwsnCh83XbucZ/Vg20?=
 =?us-ascii?Q?x+KIXdiEfh6D1Npksuj+FWN6dTBnU3KjjmMoEQA+ADxGCoGqamQ3hYtDwnYO?=
 =?us-ascii?Q?dediITUR7SuWMY54valEsefGGZbra5AM23L4BFs/kC0uezpABsuGbX0D52SE?=
 =?us-ascii?Q?STusAll0wmiHN4RDf2IwocTvjmC75jNlo3vxUFsRdrjbyMAyKe1hWoRnLVq2?=
 =?us-ascii?Q?AFwr9F/OALF1LHiF97seYQqsb0fK6ybIYjnQIcOy0OVWF5e9JSeCbTMD4kPo?=
 =?us-ascii?Q?SLoogsE+8O5aXm903sLNcDkpu1F5crrl/ZMgDpUTXlBvtYSKuNUY5eA4GH8r?=
 =?us-ascii?Q?YPINciHRRvuOIt7yMPMHkkMdlP9huVNclESILiWt7cABSoPcUXJrK/7TLF2I?=
 =?us-ascii?Q?CS/YP4WEflBsr9CsMc6OjjoVGfNemScl8Rm9WOAFcjEnb585ZcHVgaNk7uwA?=
 =?us-ascii?Q?yGOPFA9HzQOJg1qV7aLOkfkmw4v2MlK3Gttrb1NT1PFp75Ia9UZV+WLUcKno?=
 =?us-ascii?Q?jkVPvIfJx0s2nMm/SlW9CJen/K2GGigxjQ9aiEw8PC/ZjTFk8VPzojumZVOo?=
 =?us-ascii?Q?g1Ad0XS/pAKqW1KsmzwSFwtEz4OsnamQzB7tpZi0qZXU7RJPnIr9mKhWAY3k?=
 =?us-ascii?Q?MB8j4kv033txa3+33ugfMozHStPTlhfei4xrmibdHnm9bKuGeO8ZMtz8cSEY?=
 =?us-ascii?Q?iAc6Pb1EC3r2hTVDEqMvI3V4ny63925r7ycNXRGUxDKYdQCJeikfD/u0wYse?=
 =?us-ascii?Q?5zwIeDWaNm+VCx1QQrfBMW8UDiP+XJe6EpU6fPEBJ3/Vu/1roaFh8zai0Abq?=
 =?us-ascii?Q?/2On59pKeTLPRlsVne7F6bL1UdW++uikNGQ71QhchfiLXWovK75aDNx8LpSy?=
 =?us-ascii?Q?UVd+XqXJYlZmnZD8BLhC5/X7f3DMBhLyUiNkfgmdoV5+H5ofzLuhuB1rChop?=
 =?us-ascii?Q?NxoqFbogIaerHZZX14P/8HPLl5DCj7JXqsLkzV4+rc3YTjymNqRCW1L+2jVQ?=
 =?us-ascii?Q?kFfHLTegMRECPNFb4hPjZ6r5YIg6rpSqu9Bw6dlvpQuH11SAkytjpLnXtNum?=
 =?us-ascii?Q?NcRz6hILQ8pLClQeyb5scjvK/lcdStdhAcHO/17jfzg8rcm3kZ/TkINRZhiN?=
 =?us-ascii?Q?0c0CydfB3q879BlNrWJHV0uAsyY5+RD5CwS5EMSYlkZj2D1oJHFCyzizZ3nJ?=
 =?us-ascii?Q?VaFHkSkf8VwzFar2GYCd8IxQmHeoyvm5aXly5TiIPZyFSEFFqTi9FtdKP269?=
 =?us-ascii?Q?G2wvk/Cs6GA9NmlC4gg+V+B4byVdUXkq4m3+jMQ8kYKYN3sIPhrZ5FVrYXNJ?=
 =?us-ascii?Q?bJTAvnvrqfOvDf4IEXAcytntZ9nBaQcy6jn5pcNN2olqdXDRkje0mLdD4w0h?=
 =?us-ascii?Q?V2u9IgD14bhDzLeGyYni12lEEacrBAyZenuqfB1PeGiu2BuOtT7ggfmdzMwb?=
 =?us-ascii?Q?jMHxwM2S4ddUPpGjo/GEwwfYY5NBaudTyJfvN7/wKZQCAY/ppszOsnZ9TtrF?=
 =?us-ascii?Q?FYUZWEY7LyUNJYpjDutJjRqgqOGpgoNqX5yublZtdm+f5fav2ObBUAgz+89a?=
 =?us-ascii?Q?K0JypXK7kEiBSLfzAHv2Md7DXCBH4rDYn7AymH1bvrZ4YcZ5hGk0NMZgl006?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jHtlsyBTW1FsTHa/IzqJT6H6UnFLglb47xD0QreEh+UU/rVeSpAPHZbuPnMitdULFHAh2zCpKh63f2qq8lV8KU58eBhPzQXoIZ/olP9A9/NZUi7iNgQmyMlp4mMzYC0sQcYaBCaFk5gvtd8/4ykMWRohiajlXBaBfjG4Y1r41PY/cOHmdrxLui9AjaIovDKFhCJh+2SYQEU5sx5nZv8NeJqevTT/A4ECOYsTLmhy3CWLzZ/GRpeZFQNtlp1mE5F4UaCa8ysAMlKZdcY8pdfdnlU9NoASKB4BWu/XSECCqc6UGNzjh6nAFZ2bC7VOSoCGEQN9wNORkyTQVkxs3peJMPRaq4gViLWWj3h4IDuSgWDML0snPmUfT/NBjAcyfKeOR/VWroXTiLmab672e3fwZZzJM0IGh6W91N5MK/DCtLaq/YuaTK5e1lD6VG+CY0D9zg6chPAQfPE8ByzrCW2QMIkAvvS6QRe2PyPBsYI4y9egdAurdI0b2TeCrrrpjGmbuc/F0F29qcY9cUcXK0oUTO7rCWaLRBgkUVzkQbdR2JyIoZS6ONcVU3itII7/6Os0gMitIS4OhdhoZwVwZF+FDnnsTJvceR2JsEzLGcS4nlo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a27a80-a398-446b-a080-08ddca4b7558
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 00:45:59.9854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cA9E0KR9Y8W1ZnjkpNeMUG84OzLLVaxza/pOAIclj+ep+uIpJDm86/BZFej5l/ApYug2cbTLu1KeIhU3tFz4Vnpu7omh+vgAFCkqmCRjhgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240003
X-Authority-Analysis: v=2.4 cv=TfGWtQQh c=1 sm=1 tr=0 ts=6881824c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=LzUW8NnXIMviKzXO3doA:9 cc=ntf awl=host:13600
X-Proofpoint-GUID: AQPIpyG6qkdMfNBEQKuNbe0zQFKa5BHN
X-Proofpoint-ORIG-GUID: AQPIpyG6qkdMfNBEQKuNbe0zQFKa5BHN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDAwMyBTYWx0ZWRfXyNL80IjISm89
 +12MKx851wLAgpz1YrkXXm+X0t/a29TLZMlcPFqzgn8oXiYf5fcwgVndii66QE8ddtEKlC8RrV8
 CZiv863q5ydFN/5YfbHiQRPxI72Je39XFuAeIESmDhW/N8OuMghXS2n9R96kqr1UQLzA+PNf/K/
 oCXOxb/6W2Pt6CPvCk7sVShN7obxK/8dhs4E1cYj14ToUt+AZXgR5XIW5fsi9lBgv/yTZL7MhOL
 YSK+VNrmIcvAsTe/8GM4OSLCm/rEX5hc/XnMFe3G5WeNqR2Cx6wFd70r8tHJnYo3Lh1e/NInq/4
 +3S3ONM2qt+CO8QOidCRWotcbVvxrtEkegf/Cr0+GCa1aut8xBkmPFF88us4RtyJ9Z+ZZiPHQa1
 kPuU7y+2IwiSZ2Gsn5JdDWRpcU/EfXWM3k59xml0EPubjm371qNx8WOx1H/pbWeGYDGA1269

The atomic use in the main I/O path is causing perf issues when using
higher performance backend devices and multiple queues. This moves the
LUN stats to per CPU.

I forgot to include this patch with the delayed/ordered per CPU
tracking and per device/device entry per CPU stats. With this patch
you get the full 33% improvements when using fast backends, multiple
queues and multiple IO submiters.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_configfs.c |  2 +-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_stat.c            | 48 ++++++++++++++++----
 drivers/target/target_core_tpg.c             | 21 +++++++++
 drivers/target/target_core_transport.c       | 14 +++---
 include/target/target_core_base.h            |  8 ++--
 6 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7156a4dc1ca7..13159928e365 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -697,7 +697,7 @@ static void target_fabric_port_release(struct config_item *item)
 	struct se_lun *lun = container_of(to_config_group(item),
 					  struct se_lun, lun_group);
 
-	kfree_rcu(lun, rcu_head);
+	call_rcu(&lun->rcu_head, target_tpg_free_lun);
 }
 
 static struct configfs_item_operations target_fabric_port_item_ops = {
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 408be26d2e9b..dfe529e59a29 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -125,6 +125,7 @@ void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *,
 				  struct se_lun *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u64);
+void	target_tpg_free_lun(struct rcu_head *head);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		bool, struct se_device *);
 void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 6bdf2d8bd694..88f8be197a68 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -627,14 +627,24 @@ static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *item,
 		char *page)
 {
 	struct se_lun *lun = to_stat_tgt_port(item);
+	struct scsi_port_stats *stats;
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
+	unsigned int cpu;
+	u32 pdus = 0;
 
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%lu\n",
-			       atomic_long_read(&lun->lun_stats.cmd_pdus));
+	if (!dev)
+		goto unlock;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(lun->lun_stats, cpu);
+		pdus += stats->cmd_pdus;
+	}
+
+	ret = snprintf(page, PAGE_SIZE, "%u\n", pdus);
+unlock:
 	rcu_read_unlock();
 	return ret;
 }
@@ -643,14 +653,24 @@ static ssize_t target_stat_tgt_port_write_mbytes_show(struct config_item *item,
 		char *page)
 {
 	struct se_lun *lun = to_stat_tgt_port(item);
+	struct scsi_port_stats *stats;
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
+	unsigned int cpu;
+	u32 octets = 0;
 
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(atomic_long_read(&lun->lun_stats.rx_data_octets) >> 20));
+	if (!dev)
+		goto unlock;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(lun->lun_stats, cpu);
+		octets += stats->rx_data_octets;
+	}
+
+	ret = snprintf(page, PAGE_SIZE, "%u\n", octets);
+unlock:
 	rcu_read_unlock();
 	return ret;
 }
@@ -659,14 +679,24 @@ static ssize_t target_stat_tgt_port_read_mbytes_show(struct config_item *item,
 		char *page)
 {
 	struct se_lun *lun = to_stat_tgt_port(item);
+	struct scsi_port_stats *stats;
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
+	unsigned int cpu;
+	u32 octets = 0;
 
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n",
-				(u32)(atomic_long_read(&lun->lun_stats.tx_data_octets) >> 20));
+	if (!dev)
+		goto unlock;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(lun->lun_stats, cpu);
+		octets += stats->tx_data_octets;
+	}
+
+	ret = snprintf(page, PAGE_SIZE, "%u\n", octets);
+unlock:
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c0e429e5ef31..caa95aa6f502 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -609,12 +609,21 @@ struct se_lun *core_tpg_alloc_lun(
 	u64 unpacked_lun)
 {
 	struct se_lun *lun;
+	int ret;
 
 	lun = kzalloc(sizeof(*lun), GFP_KERNEL);
 	if (!lun) {
 		pr_err("Unable to allocate se_lun memory\n");
 		return ERR_PTR(-ENOMEM);
 	}
+
+	lun->lun_stats = alloc_percpu(struct scsi_port_stats);
+	if (!lun->lun_stats) {
+		pr_err("Unable to allocate se_lun stats memory\n");
+		ret = -ENOMEM;
+		goto free_lun;
+	}
+
 	lun->unpacked_lun = unpacked_lun;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
@@ -628,6 +637,18 @@ struct se_lun *core_tpg_alloc_lun(
 	lun->lun_tpg = tpg;
 
 	return lun;
+
+free_lun:
+	kfree(lun);
+	return ERR_PTR(-ENOMEM);
+}
+
+void target_tpg_free_lun(struct rcu_head *head)
+{
+	struct se_lun *lun = container_of(head, struct se_lun, rcu_head);
+
+	free_percpu(lun->lun_stats);
+	kfree(lun);
 }
 
 int core_tpg_add_lun(
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0a76bdfe5528..4ec66ca6c0ca 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1571,7 +1571,7 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 		return ret;
 
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
+	this_cpu_inc(cmd->se_lun->lun_stats->cmd_pdus);
 	return 0;
 }
 EXPORT_SYMBOL(target_cmd_parse_cdb);
@@ -2597,8 +2597,8 @@ static void target_complete_ok_work(struct work_struct *work)
 		    !(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL))
 			goto queue_status;
 
-		atomic_long_add(cmd->data_length,
-				&cmd->se_lun->lun_stats.tx_data_octets);
+		this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
+			     cmd->data_length);
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
 		 * backend had PI enabled, if the transport will not be
@@ -2621,14 +2621,14 @@ static void target_complete_ok_work(struct work_struct *work)
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
-		atomic_long_add(cmd->data_length,
-				&cmd->se_lun->lun_stats.rx_data_octets);
+		this_cpu_add(cmd->se_lun->lun_stats->rx_data_octets,
+			     cmd->data_length);
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
 		if (cmd->se_cmd_flags & SCF_BIDI) {
-			atomic_long_add(cmd->data_length,
-					&cmd->se_lun->lun_stats.tx_data_octets);
+			this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
+				     cmd->data_length);
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret)
 				goto queue_full;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4d9116904aa..e73fb224625d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -744,9 +744,9 @@ struct se_port_stat_grps {
 };
 
 struct scsi_port_stats {
-	atomic_long_t	cmd_pdus;
-	atomic_long_t	tx_data_octets;
-	atomic_long_t	rx_data_octets;
+	u32			cmd_pdus;
+	u32			tx_data_octets;
+	u32			rx_data_octets;
 };
 
 struct se_lun {
@@ -773,7 +773,7 @@ struct se_lun {
 	spinlock_t		lun_tg_pt_gp_lock;
 
 	struct se_portal_group	*lun_tpg;
-	struct scsi_port_stats	lun_stats;
+	struct scsi_port_stats	__percpu *lun_stats;
 	struct config_group	lun_group;
 	struct se_port_stat_grps port_stat_grps;
 	struct completion	lun_shutdown_comp;
-- 
2.47.1

