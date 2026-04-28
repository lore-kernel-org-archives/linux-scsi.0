Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00CF3F7887;
	Tue, 28 Apr 2026 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374709; cv=fail; b=uAvcZP//Zvt1y35BNrjhMbX0snRJW9WJePHd6BFkQNtQ/FIXolvIwQ1ykS2SjppQQ8ENYG2FK8yw4Vm8af4VxrDWWBgsj5G1a6LXYCo1hi9orGvEmMkMvyEhsIO4ZYGarSWhbjsW6mFszevihixkT32+VhBmfEUZQcYPVfQ3LdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374709; c=relaxed/simple;
	bh=1cys07I2/6NullQ6wHxHdsCNPFQ+6pPsYM9i+K0Mi8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iEpRRbQgbio6ibaOSQOF7W0B/pqlUBWyZxsOF4snVdNZsm5ubpCtCl9Pb4f1sZsfJrxJD2xqvgSh72OlJ8NLOMTmn0/1Yca2KbOW7PKotYqgDCFvoVwzhmgrRXuLcn9F/kPEt3P/66XhVYuTwgbMv9o6RTDvymjUN60hE8oECYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RF0YuTMO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=coMTA0Gg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RF0YuTMO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="coMTA0Gg"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SB29ZL1015471;
	Tue, 28 Apr 2026 11:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wIMtkbHfRZV/it66bMUBJ0JKrm3aVBeQwUSNX6Z2Ga8=; b=
	RF0YuTMOMjeQ/LQgsMALKdbVjDm1J0kmTW4YMh2YrPBqAE0Ty2reW11cCwH5qVJ9
	11GKAJJYRPD5Nv2J4JY3Nxm8F9qo6f1f4X2ukGr9ZRTon3OWdDa11rbV1YRO6lJ5
	UiZl35TTzWtHs8eebf4M7PWM9zP1iT3sVVBizj5yKN5azYb4+n0ncj7wd02xhha1
	1UfarJL5CY554gQKlLHdgEg5uOnwXIoP75YnpAXe4mfs3nfDeZzFfUYvDsw4kZ7k
	oBJL8Yl4N5wdmqY5T/ETQR8EyAR7KG/7+Xn/PsY9rVMeecOVVYXhUcdfa5R/hWK7
	XW1m1s7ixpvT0O8cv5y9ZQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yyju7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2kNj040801;
	Tue, 28 Apr 2026 11:11:29 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cudth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jwVCY2FWgokZd4EBdbWUeGJH8z2u7iwkqYgtJYWfnSbBpCSl8w4R/lAk6+8uV0uD8asfHRx2RSS5KWxY3T/ixVbkwmf7/0euwv3BTpj0X5yZMcDzIbj1xVvzcST33IAtGK9uGjYwU2w+bX5DtxgdTZBCiBDwk0IASoZsfxnoHZuN/tU7IyVhPJB15StUyzVszZdKF3qSs/4OzF5ckA9ueZr3pQyvy+L+Rti4qW8DjsX5Zt0QwwSd2bRvQGStdttVQaKHF/haR7UQS144zAYA5AZEh9fCrYBEmxZFMd1R7qV6/d1yxAz1w4QLyhyGQOhTMu46lPGa8i4UUwOIj7CM2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIMtkbHfRZV/it66bMUBJ0JKrm3aVBeQwUSNX6Z2Ga8=;
 b=ocXZVo0AdxwgjTz04ITlMq0OagHBD2Ga7FwyRrYpZoDszFPUm8aAl/u89Bs2faWUTwgxq9CacOwnmmV8IRhzshRfFcsoKpRbNzl5MaBLLUZLJVZKFKquh2Ml5UnExzcmWZzqJ62SOwHg5o43UwyYXsbtp3LVjxC4uj1tPoGOdyclsjs+9MdnRltpfi3ZJpbwFBY3DvBmiiOn2eu/5vtfofhKMC1Unu0m/iLE6ZOO3qA9ePj2dWlG1lXi1RgLaNiyDVKtQmWyoNlLQzWekFw48JFoURQGK8Fcq/bUE2q5Vl4DBA0mDF5nm735MhjtAFUS2Df+5Nyfzal4GDasnZRI7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIMtkbHfRZV/it66bMUBJ0JKrm3aVBeQwUSNX6Z2Ga8=;
 b=coMTA0GgAoejFWRDCaLRmbfeKnLwAPwBjapzfADVx4ptGGpWjt+ZE82zpHdcaBjzimuG+d4zw2npINxj7/wMGahNS6xgdxBLUFDpJNTJ4k2N8TseuRWkukLPyabc6szMWQtNlgiI2i4ExrBjsP3t+Ae6z6zd4rbSg/yHUOxpuA4=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:22 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 03/13] libmultipath: Add path selection support
Date: Tue, 28 Apr 2026 11:10:55 +0000
Message-ID: <20260428111105.1778008-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::8) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 814ea7ce-04e8-4301-6aee-08dea516e13b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZCigyNxwbKG5ztV4auo+hI36fAHakI5lSDtpDJvDt1FpDCbVOE1EzNUH9Se+k5iJYBk7BF3fiOQCbn1v2LuNY9+WsveYf5DeCm6qg7vS3NpB9gxJMEEDR7XTrJh7Qbqd1EAxyjGu9xaXdWB92H5p/s0MKFbbfSKE/wekZE8w3v0JAjf+qlksMPN1ajLBFMa5YIzFCR6P3F/K7ih+p/llnaktDNKMgECg2wYfHz9XN2cnpy/anMsMHV+YfSpzt3W1to3CrtZjFO4vm9KTS37yLDWzICTaYrkr5HcqbK0UyJfgS/jKX08iPG6euiOJj90CsqUPVsq3hrqttWDR6v2m7wxPE4hNmU4yas287EcrYSiUA4HOXmv7JMh78L7Uw0AWrMYzmadSOk3FFoJfn5TeUCl6fEyDYwLEgXpogOx9LqBPWFqlw9UupNt5wgt5QtjUXBFngAoRNeDDQPQiGtzgfACUSLQNCDt6GVh9P87CJYjl/H9kE5GFiO88Tr/JIdG0Rlb8ymOkxT7e1S0hqcb1Z5obJ2E29alkOPKspsTw228EqLgEZB9pzOiiHZ/POXdRH6/rlBvDzTQGvWnH0xC96tm32q2VSQeeQy+mSdVoc4O49RQdS72u6kcCQ7f4lyfxnXtIcxSU9McX3IERlWI83qrS5YH2KcwAipLVnmsQtEFPUxWCExyGo/KZglEqavQHA0/KDWpnooRnX6rGpPrkvedT1/OP/06XuIAmnTcShu4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fkNF0xa2Ghhz0oqRMVAiSAtSIAT0hync/tDl1QAEHVti9FMvAb0OfQrmSgVR?=
 =?us-ascii?Q?4US+Chhdco8VYCoa788kFhPXii2v0IugDk+X8sHuGwsUwomdOAO/6QlgpTNm?=
 =?us-ascii?Q?llXeHAc7Br5ajLqh1/uFYRMLKWv5niHe243/91O3DzQTXn2icPkuiDh5+XIw?=
 =?us-ascii?Q?1zBBhZV6DxrtuB/2Gefn+EHaJ8e5nOvtcrx4CH6kdLtVp/WaD13P8NIDeLVS?=
 =?us-ascii?Q?j8KFKUkn1mbyPRh92146rb4u4zfis/ohvPuQPm5f9vP+R9jWnsHS63r+M4RT?=
 =?us-ascii?Q?VgQxQTa1sww9Cl1qokVlaTuyjaBF2Umilnwri6WuSGfmvCzjxJHhUmDxFXFE?=
 =?us-ascii?Q?ysdPk6X/jc+9APJGRf+9kXxZiL3K735V5RzDeX1gui3SFabYy5zsQhpmf/Ab?=
 =?us-ascii?Q?VXSNPN+uzS1jCuH+qS0eoe+Sol4DuN+aCc48NmN497/u90N0mFDwEg7UFgZ/?=
 =?us-ascii?Q?9zCTjOiE7frzHkT8VXww25rx2KgahuYzNDxRBqJ18ClTfymHX27n+Hnqgpn/?=
 =?us-ascii?Q?1pZ7vH5OaSVmY9Lid3oObneUgAOV5TVnfSKLSZs5/vVAyLUSempX6mPaVm74?=
 =?us-ascii?Q?VU+mEkVRMenUBpoRaI/NOGTSKVzzLAqVsc9fo9Gzf0lsQJDLOKOiYqpIlO5W?=
 =?us-ascii?Q?Yvnzca3YYooE732OgzQ1Pr1NGjobA6VZRG29339nUb/CDsuNSUvBdmhvBVZ4?=
 =?us-ascii?Q?PVfTxDOZWDLfFze3agz5fgt+T2kIAjG0eWfa1prJAJLqNd9CbQYJ22Z9kr3m?=
 =?us-ascii?Q?FPLHfuSsoDsTDAxcGDnNmpic5APWqzsgtZ1thu80JAUabRdH1oPSIHdMYpJ/?=
 =?us-ascii?Q?pprgo/h1D53YsbYc+GsMxPsB6S0v3u4448vZRu1/rGGnLIIVflAc90bXeX3z?=
 =?us-ascii?Q?drz8OBTPXz67Cic1/u8Dt9IOSpGwKUg8H4I+eCv3BqbqyRjgdW3bjW5T8AEO?=
 =?us-ascii?Q?V4dGZ6nW+R2JZXNUL2y3+LoKyo+tQsIjN8QaH7npz1k5XK+M7Rk6HC3K9+SY?=
 =?us-ascii?Q?JTN+xV6T6eSuufNTDNylTc1p9k3fM0fFOZhLoX7y7RRObrphLXVSWUocWe+q?=
 =?us-ascii?Q?ENyCaJYkOkWrPexhGXJJZF/ytGrXDYqEd38s661otpLbug72poG0o2qoM8uh?=
 =?us-ascii?Q?Faw3oG5HbEIh56xbrDsjd9b8NbdVbUKAaXEvP9Sqgyoc6NGEO2J8FjmZC8Fb?=
 =?us-ascii?Q?QawVDx/NUMz5IJKEjyJ/ySnP1piPDdeCmzjckrMhZpc3ctACKTsYGE4lyeg6?=
 =?us-ascii?Q?hMwtyswNVFLXkz2vz0Bq8PGrczoGbYC4lxcSLdRsjP4DeBuDSsYJfmwk/VtK?=
 =?us-ascii?Q?/XfsxjXSqerpvna14Fh32YWwPT+OvNX2wCfYEBshJu/C0V+mRuR70BL7eS3s?=
 =?us-ascii?Q?pafeeIt52Dq3h2/BJ6F5BPHZRnXjpWNX52QyaX2nN7U7dawtOX/3U56fJ3e+?=
 =?us-ascii?Q?jRFzLjnGqKkYFEPJDfpuU3VlBBALSoG7k+Mvl8WtgRTd65qzuVZXjahJisQa?=
 =?us-ascii?Q?Te/jTSHkrfYkRMU/6dlADy3VvgwS2mFU9oQEKqiedtbFn3YWJ9JmNwVSmivp?=
 =?us-ascii?Q?BEJ6YgopA4wZpp6ZtPk/SaNfVmPgjizvRKU/d1RcJYueT5N2cKKIe+ZQ2AMo?=
 =?us-ascii?Q?QtArgjYe1U7LRmuLIRdhDfCJYieG3cL0IDF9ELJZ/b3dwJS/Y5IWezGou96k?=
 =?us-ascii?Q?xHLrnjqtjCn9+k9XzUIlifRX35Ki+GB2siV8MO5W6UgE9g7j1GVnrT7xtwLp?=
 =?us-ascii?Q?M6hSJQQlwprrs0JdFmCZCKjLD6sgCMc=3D?=
X-Exchange-RoutingPolicyChecked:
	GN9LYPHPKngbef904GoyPyMyK0b/OhjGptGGirIzFTeYiFTM0qulFpYN09DTc5/SpYEioCj826UwwJs7w9kkb2DO+/2lyQKqXWkGHXb1X3I9UuIAr7BpRkxI3m0+rJn/4/U5D4Tfn4NEg38FDP15v++oLiPOyL+xB52gzFcavzEH+eD+j9A+RC9+Zq3p91yP/K+c3umQW3Xa0K55RGOcRcVENPMJN/koXsIIqxFkhvS8zqrmzWOIfi1X/VysbtSUzAfzhV5bbc77/7J3BVz3wSTGGUFWi5/FF8g6ahpmK3v8NxejI1L33puMuCSoMs4i2rQdlHgj0MVHxL3T8chrLQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3HtztqhPoQuvEKpg3OO9YS/O0+Z7zJIPpHAPVjCMSm/PNDS/3cO6L2nbgyT51mAl5WjCgQSF2cvrfc+8EJ+xAJZdaookt5qQFNNkrb2Qdy4pEh0DkSLLHsKxpJnHt5GBaMe1qiBTdOK5d4cilXTLDr36L4EdOiZZPf973/+L3MDE1RJ48cuYgyA1QSDj3Os4l59yMFVSyaIwG9x36+65g5tFrxYarIzRDecF+H2jxqtDvErti9M4QntNe2pnLcVn6I5A7xArGW2rPl929sHbvUAusisdxya25UIrjShEHLBRXCYxa4oj7lyAZPfadVf9gALUKgcER6nvsIHTPNt9tDgqe42kUYq/0fdnZa/E95VZfWJQ1KDQhL5IO5XJILLS86oT77MbL++0Vb799YwmQe3oOJbUnC1NTspgG3Qi50ZK7W9mms6C2DDMcOXWK2MA/0FE598yJzv/U5/sfUQyd0AdGD/VjFoy8YanycAGgEIBgMmGDwzEXUKcuYtOsYTvSJBUTbqIqa0aL3MSjEEW6RhyE6JVZgUj6jb174mDtg45uO9pYVXDaePreXGF+cHBy50sRu7kA8b93xtw2lCQq1zPOEs/fRVw6uZIC14tcVo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814ea7ce-04e8-4301-6aee-08dea516e13b
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:22.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lNw8y7LsHnl/5cOjcRFwfMXskK/hxvxcizxar1kmt3TxDNRazi/y09eZLQ02l2O/vMlGhNvuoRMSEaI30O+sUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-GUID: w3sE378bvH3s9z5TXt9SqFenzt1ATNN_
X-Proofpoint-ORIG-GUID: w3sE378bvH3s9z5TXt9SqFenzt1ATNN_
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f095e2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=Lb5UtHSxAhypNmDEWQsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX9+Zd34jmFCjb
 BP1c5GldCkG9UxILvAPYdHVcPvP7FzqGK6zTQOUQX6oY0UOpGk3mI+/Y2fLGJ7GxVszjHnCEvlh
 lErJ/kEOXhntNjVwnt/iDlfy8PQuPiaGr1/1S59vlvSNfRqNlNqLlN0UajfDE/IEIQd1KVnF/Ik
 JCV/VmvGOYqCnfpILmkDTGik1lZ0NNz4iFKmWXpaC6wWCs4VyVH4BGT5pZdav/ZX15ptUlpu13H
 7ztMpUyo7JnunCluhlAVfmIU5KqSYZuszAyLgY3eGwwC+ZrdNmmtcXuSSW//Q+FVD+lVI+519hv
 OXzSp4ZU0EYJMgRgb7Y2d0Dh1IyR2nZrQDdPDS9wav+llAo5lQjXYN+VNUfaIC1C6WDK1BHociE
 oZjbWp2D5ZFWYt7jbOIZOl/B/+wSTha8UP52SOaznEBSlAqAVY5fOLVLHcfK7GiGNXgvW7ludZG
 zMRCPti+AGv48UV30Fg==

Add code for path selection.

NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
so that SCSI ALUA can be used. Callbacks .is_disabled, .is_optimized,
.get_access_state are added to get the path access state.

Path selection modes round-robin, NUMA, and queue-depth are added, same
as NVMe supports.

NVMe has almost like-for-like equivalents here:
- __mpath_find_path() -> __nvme_find_path()
- mpath_find_path() -> nvme_find_path()

and similar for all introduced callee functions.

Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
setting default iopolicy.

A separate mpath_iopolicy structure is introduced. There is no iopolicy
member included in the mpath_head structure as it may not suit NVMe, where
iopolicy is per-subsystem and not per namespace.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  37 ++++++
 lib/multipath.c           | 248 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 3e2a513059cde..13d810148a96a 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,13 +7,36 @@
 
 extern const struct block_device_operations mpath_ops;
 
+enum mpath_iopolicy_e {
+	MPATH_IOPOLICY_NUMA,
+	MPATH_IOPOLICY_RR,
+	MPATH_IOPOLICY_QD,
+};
+
+struct mpath_iopolicy {
+	enum mpath_iopolicy_e	iopolicy;
+};
+
+enum mpath_access_state {
+	MPATH_STATE_OPTIMIZED,
+	MPATH_STATE_NONOPTIMIZED,
+	MPATH_STATE_OTHER
+};
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	int			numa_node;
+	enum mpath_access_state access_state;
 };
 
 struct mpath_head_template {
+	bool (*is_disabled)(struct mpath_device *);
+	bool (*is_optimized)(struct mpath_device *);
+	int (*get_nr_active)(struct mpath_device *);
+	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
+	const struct attribute_group **device_groups;
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
@@ -45,6 +68,14 @@ static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
 	return mpath_bd_device_to_head(disk_to_dev(disk));
 }
 
+static inline enum mpath_iopolicy_e mpath_read_iopolicy(
+			struct mpath_iopolicy *mpath_iopolicy)
+{
+	return READ_ONCE(mpath_iopolicy->iopolicy);
+}
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_set_iopolicy(const char *val, int *iopolicy);
+int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 struct mpath_head *mpath_alloc_head(void);
@@ -63,4 +94,10 @@ static inline bool is_mpath_disk(struct gendisk *disk)
 	return false;
 	#endif
 }
+
+static inline bool mpath_qd_iopolicy(struct mpath_iopolicy *mpath_iopolicy)
+{
+	return mpath_read_iopolicy(mpath_iopolicy) == MPATH_IOPOLICY_QD;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 726d9bec13553..fa211420b72c3 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,8 +6,242 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
+
 static struct workqueue_struct *mpath_wq;
 
+static const char *mpath_iopolicy_names[] = {
+	[MPATH_IOPOLICY_NUMA]	= "numa",
+	[MPATH_IOPOLICY_RR]	= "round-robin",
+	[MPATH_IOPOLICY_QD]	= "queue-depth",
+};
+
+int mpath_set_iopolicy(const char *val, int *iopolicy)
+{
+	if (!val)
+		return -EINVAL;
+	if (!strncmp(val, "numa", 4))
+		*iopolicy = MPATH_IOPOLICY_NUMA;
+	else if (!strncmp(val, "round-robin", 11))
+		*iopolicy = MPATH_IOPOLICY_RR;
+	else if (!strncmp(val, "queue-depth", 11))
+		*iopolicy = MPATH_IOPOLICY_QD;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_set_iopolicy);
+
+int mpath_get_iopolicy(char *buf, int iopolicy)
+{
+	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
+}
+EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
+
+
+void mpath_synchronize(struct mpath_head *mpath_head)
+{
+	synchronize_srcu(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_synchronize);
+
+static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_disabled(mpath_device);
+}
+
+static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
+					int node)
+{
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct mpath_device *found = NULL, *fallback = NULL, *mpath_device;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+		srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		if (mpath_device->numa_node != NUMA_NO_NODE &&
+		    (mpath_head->mpdt->get_iopolicy(mpath_head) ==
+			MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node,
+					mpath_device->numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    found = mpath_device;
+		    }
+		    break;
+		case MPATH_STATE_NONOPTIMIZED:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    fallback = mpath_device;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!found)
+		found = fallback;
+
+	if (found)
+		rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_dev)
+{
+	mpath_dev = list_next_or_null_rcu(&mpath_head->dev_list,
+			&mpath_dev->siblings, struct mpath_device,
+			siblings);
+
+	if (mpath_dev)
+		return mpath_dev;
+	return list_first_or_null_rcu(&mpath_head->dev_list,
+				struct mpath_device, siblings);
+}
+
+static struct mpath_device *mpath_round_robin_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device, *found = NULL;
+	int node = numa_node_id();
+	enum mpath_access_state access_state_old;
+	struct mpath_device *old =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+
+	if (unlikely(!old))
+		return __mpath_find_path(mpath_head, node);
+
+	if (list_is_singular(&mpath_head->dev_list)) {
+		if (mpath_path_is_disabled(mpath_head, old))
+			return NULL;
+		return old;
+	}
+
+	for (mpath_device = mpath_next_dev(mpath_head, old);
+	    mpath_device && mpath_device != old;
+	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
+			found = mpath_device;
+			goto out;
+		}
+		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
+			found = mpath_device;
+	}
+
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
+	access_state_old = old->access_state;
+	if (!mpath_path_is_disabled(mpath_head, old) &&
+	    (access_state_old == MPATH_STATE_OPTIMIZED ||
+	    (!found && access_state_old == MPATH_STATE_NONOPTIMIZED)))
+		return old;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_queue_depth_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *best_opt = NULL, *mpath_device;
+	struct mpath_device *best_nonopt = NULL;
+	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	unsigned int depth;
+	int (*get_nr_active)(struct mpath_device *) =
+				mpath_head->mpdt->get_nr_active;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		depth = get_nr_active(mpath_device);
+
+		switch (mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+			if (depth < min_depth_opt) {
+				min_depth_opt = depth;
+				best_opt = mpath_device;
+			}
+			break;
+		case MPATH_STATE_NONOPTIMIZED:
+			if (depth < min_depth_nonopt) {
+				min_depth_nonopt = depth;
+				best_nonopt = mpath_device;
+			}
+			break;
+		default:
+			break;
+		}
+
+		if (min_depth_opt == 0)
+			return best_opt;
+	}
+
+	return best_opt ? best_opt : best_nonopt;
+}
+
+static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_optimized(mpath_device);
+}
+
+static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
+{
+	int node = numa_node_id();
+	struct mpath_device *mpath_device;
+
+	mpath_device = srcu_dereference(mpath_head->current_path[node],
+					&mpath_head->srcu);
+	if (unlikely(!mpath_device))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	return mpath_device;
+}
+
+__maybe_unused
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
+{
+	enum mpath_iopolicy_e iopolicy =
+			mpath_head->mpdt->get_iopolicy(mpath_head);
+
+	switch (iopolicy) {
+	case MPATH_IOPOLICY_QD:
+		return mpath_queue_depth_path(mpath_head);
+	case MPATH_IOPOLICY_RR:
+		return mpath_round_robin_path(mpath_head);
+	default:
+		return mpath_numa_path(mpath_head);
+	}
+}
+
 static void mpath_free_head(struct kref *ref)
 {
 	struct mpath_head *mpath_head =
@@ -71,6 +305,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -121,6 +356,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		}
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
+
+	mutex_lock(&mpath_head->lock);
+	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_head->srcu);
+		for_each_online_node(node)
+			__mpath_find_path(mpath_head, node);
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_head->lock);
+
+	mpath_synchronize(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
-- 
2.43.5

