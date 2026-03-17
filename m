Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68993BD629;
	Tue, 17 Mar 2026 12:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749269; cv=fail; b=KvdGtijDpm76vXdaqs0CAs/AkMFsVS2/5HN/lKNz9MQfxQIe4o2a+Cyf79dSyNNFBGN/N3lrrk+C0V3yK7X6wMyDsGO08UDdGXh1ge1uxhy5jsWFMPqkncMuYiT88hjuzNSLCNTxoSQWoB1aykX5nf7byX0e8p7oy8Whp864xpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749269; c=relaxed/simple;
	bh=VgYtamapMJvR5ZAvY1aaZgm/bI69lcn3ociUeVMyWdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=izrFirbI5KhFPvAkwVWukb7/u+cNzSnxDSqUy4jLyb0IuhwcShv6VZ1KmLUG+t8vEgXnk9Ix/TeB0zujuRXxwLJWkUOQMRvVYykygmAL9Crzvy9323VvrqjMc6oAVm7K15b++0ayV4Gr4/RHhDCCKUqArMUx9LOFMAzyaqcpFD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=noiJaBWO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oaRaeCCN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="noiJaBWO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oaRaeCCN"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GN4uts1347797;
	Tue, 17 Mar 2026 12:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qs6brQKG93X0dnUWjK52b2sQ9FPr98n8xPjH8rza7As=; b=
	noiJaBWO0hPq+bSQIYTaOJrh+352l6ry+bvj5gmHbn+UtcoPonL+mhPj5HqHOAEc
	nrRDDkamth4ec1KFluR9lgWw55+n0GdEkIVsvu9w1j4wlJaQKn4ltU4imLaFDN8+
	NSEzUdW4sTsn+cNdVWM4Ir/uU6Wk6TYNoxkt1aCpruOTK/y2X4Yn6h8JkaXXqPmk
	kyLHuwnpS7ylhPMbeb1zmeYGY4Ot8La5K+UEXWDtb89v5eN3HwRDL0lmERTP9RNj
	WZQlMofDrQo8gDNO7+IvMSF15ZQMTci2m0jXlcozyUoorVt4JQzC71xNBCkaWxU/
	CStAin9o4qi9scGQO7HHyg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx3b3xhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HA6t0L003526;
	Tue, 17 Mar 2026 12:07:39 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4a01gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQPEjWVF+btnZzd/hkalykTCH9V05QtnBCGG0/Ak3rkwPMWTUqnUZqH5MXqHkEOxj6b96zwrNBttpa5OcC2MnRR4w/4T/MNOUYepRqlbqrkzTeBlSkKI9FFaU+9k2llrnq1J/cTsuKAB5/zFVZRGFyisWgiEb7R+B8jHJo/OUAPDmcLAzYp6T4aZn6SVeZuk4ln4xEc/yXzkQ56xMfmC29woJjBjtDLnmdKdMlqtcygas74ahEb5/7JmBB+oykUeQn2hgov5d0hzPwiGDwiA5wOw98p1MtmajRWXHMj/CnmDvnTGk/YJZ+xyyaz+uAWJPnRtkIIsIHb8f+KTC7rCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qs6brQKG93X0dnUWjK52b2sQ9FPr98n8xPjH8rza7As=;
 b=SXt3+n1heCF/IzLizo0UxWN/UR+c25iWb61Ex6czpF75VbNvKi59y4OauSVYcV/YakzV4XK1nYbHB8Qd0hX2OxFeyJra38kmiyjuBu/r8u96mZyQYUWG/1INRvGEW7ZL9SwW1ofLZilXgSs/+txljUoSK0zJ5RpDXdBZEn/FhWp9pZCAHIqK43URHQjXMlOa6jMJG1C3bGHpyzqMM2VXGKMLQ5tOtUU2V1Oq+mg05zT9ReyIQwcCDI+b/IN2lqVEY4hDIL4FkjYSs78h7bVNmxRP+SCa0VCVT2qDlZE82CwNW7BfNS0IOtEg8NxrMrRtHRKcdZJByLi9ESpgj9SRXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qs6brQKG93X0dnUWjK52b2sQ9FPr98n8xPjH8rza7As=;
 b=oaRaeCCNZdObE+/CLA45azfiPz0mc2mP4U2ysZGWCGnNlubh5+0ZIH3MkBd9PFh/raPvEQmqdRxGYV5UDjoKfdjitfXHcnYJk68pwW6qXunUkWc1HnbADgBOw3qRmkTRaaZY4LQOSgZRikTL+dcXCRborsDcpZWIi61P40PzkIk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB5976.namprd10.prod.outlook.com
 (2603:10b6:8:9c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 12:07:36 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 10/13] scsi: alua: Add scsi_alua_prep_fn()
Date: Tue, 17 Mar 2026 12:07:00 +0000
Message-ID: <20260317120703.3702387-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: b8f3d35a-197d-4d9c-7886-08de841dc719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	dV4buX8r+FK9g/qETxq6BgWeINcJuI2pnHiKrmA5099Ihgdm3U21pSEd6cRgTc3AGFd5zkN+7L4A9xZBbNq4cBdYQnPhDtZp1kjEJTTwHlpBOifLAH7xeDTaMkMMGy61lHz0toMbfqbwMe8LmVT3DSogdAgJjpiJVRkxNTXZVL90Wt6zv7WF/EJ1HTLybqnPxb93x7OXImf8jR7np9Z2ktwFLbgZyJER2UIOUcRuDiS3aITRuUuzeiIKtANUXNqZmB/9wEB2Bvcjs+9yv47WTKamfSL/JXD/0qbghLw1jUyCXzd/JWfy6/oJE+DaoFSIWQKzzqGNL4K5CotA5aDcfrHxf06FBxQ8rxFR9WU5CqeS4CPwf8q7aGRLE35vzSXKiFBPkipvH2YTS5N2DwxfDxskvOHTQXyeK6mKD/cO7HW0T7u2G2yo6jVFZIUqQ/lo8nBoggvWKLXuYsoX9C9qwhA+B/Ceem1x3nv0fk15fky+Ld0In3v3nqYTj4sYQe5qpNfJpcenJsD4+ghKCw79Ti6Nod5BSjGv3RDsv3n05upRuGIiBv8rhZkP2sbP5axVvGab1nBhs9HVFMTF5IKgZN9oxHnZUOZOyx6dmGwpAhOaGvvTgnkEvhoeDVICka5W1Ns0UtGuGbwqHoyZ+3K666Mh5ffiAU5nwQ2iG/POIaeY2EPdkI/Z8RJBNrc9blzZ+pC9hqS/kmFROk/AK/4xQli+u6y2bOXl1luZQlWDsag=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UE7UppDwOTgQKlNeBeeA5654P2Vle0cVXotwiaWdeATcKNyKMAC1aXjuk8D/?=
 =?us-ascii?Q?mo3/Yd/c9O1wu8oDNBh6qrUYkeKaxq+U9caOhcZdwrf316mTDuXLKBvDWZ/Q?=
 =?us-ascii?Q?NyKkLLrLbo2xx8Z5BABd8ALAnfyF/ro5ufqofB+1d4gOu7XzHjDg2JGEY6c1?=
 =?us-ascii?Q?FZ7rgHY6N+xzbCeeB0lMlUFflavxxgcvxoQ2F+Q7SnTkT7PnnVVIN2szxPbm?=
 =?us-ascii?Q?pX8zFHBsf7xFMLHtwzo665gpBHg1e7JHxB/Td7joWYPNQB0GAjneau3ke9yB?=
 =?us-ascii?Q?XYr2vtSMvCXYmDTFleHa5QJCozfyVAiAU76mve1SMtGUhJdQfpdFC4zUE30o?=
 =?us-ascii?Q?QzHesEcKBKTZJ2GN/ff9mBsU2cHuI0W3/JJRmTZxkSCnetjNRXOERp6WzNSO?=
 =?us-ascii?Q?5V+woU7flJp8HNYKPM+gLrQ/sJZ9xdm5vVEn7aHg9ZBDnjgBlHIHOmXEsfUB?=
 =?us-ascii?Q?qWHIebKBHSdTheN5WOkuwqVeMbsQD4YF+Rsnz6qRptUUKvL1+BjFk9++NmHt?=
 =?us-ascii?Q?2gLgrmeDwxyZZdL3F6LgdRErNTLjQI8ltpw1MOQ79xwA4rYmeLviMA/IuuYq?=
 =?us-ascii?Q?/Sut6sgeFG+2mXt/2s0LLJSFUpAWtnOO7ZKYHAew01L/hJBTv3DDQLsoP7vW?=
 =?us-ascii?Q?hDmHwe+ny3SwOxMDJS6VrSX1NEJLub3Eah42jdJhZbiCpz1DDP3FYS6mOm/F?=
 =?us-ascii?Q?AIDTXx26ktKZBWv+hxTDjeF8f3uZYhOm7C3LPH0IZ/kLssH4TOjTCnwZiWD6?=
 =?us-ascii?Q?2GyWLashC3SrrNrVMgU9XTTowD5iQm+hr/hwd37YMPm/u5GKNLomDlTan1Hj?=
 =?us-ascii?Q?uN6u/csfGRgcel9KJFeeCP1Sg3HrxwqNBJ4Nienh4CcNTPSpWTNd8jPS/yuX?=
 =?us-ascii?Q?B+ajI1wkAbD2nJYYxFzwqOV9V+IsBLrMdys+mQaBbOkqzJ/n7cJsR9xEpLMy?=
 =?us-ascii?Q?4rbVDEV2+e3wKw3+S9yrjqArD77O1+cv1rBusITDD9GzPqomMM4VZ/OKW4Ig?=
 =?us-ascii?Q?MLUO+V0A6PD7xgNEOzW9sladFzmx6EYez1SrClHCxUWR4uiPEhfDNLF/UhYN?=
 =?us-ascii?Q?Ox+LQvyJuJXH4atrNDx76WcwQwq7lIp6FDCQtUdNZXTce+Pz2qoPv6kkqRoJ?=
 =?us-ascii?Q?Jp9X2coyZeN05F/TD4hYjc5WVvMQJ30v51FHEMYOzszBn9i4CRNogkPX6AD6?=
 =?us-ascii?Q?sM8wQ5lrwmhUUJULDRfGFyagfAQUtQN6J8qLHsaW3gF/BtYuL5Gp2NnnCh2l?=
 =?us-ascii?Q?AsthNr0brea5AmK1/U0FxBbe3JGd4Mo/KrFZL0P10Z3MaAxqh/Sd41QCmSjo?=
 =?us-ascii?Q?IJrMC6uK1H18sKd8KQlLz3SR44TrCwEB9ZEUqJwRM+85B46arKmfU0iFxItM?=
 =?us-ascii?Q?BFFeUbTNH+BWeegrTK37UM3yzYMNuGR2nGQ0bpEVWctR1Ui76vHoUfnuxIbG?=
 =?us-ascii?Q?VfUt5MPd1pKbtZebkxlycTXBS0vy+aJCAZkzIhrmksPS5SbvdQR85n5ITSRZ?=
 =?us-ascii?Q?9zbLfl3z0GR7JfYHOfO2GRJv1r+MaTrXm1rsPxiDRHlgahkTjAAtU1QZByBQ?=
 =?us-ascii?Q?PkvyUJFDRcTlmwQ/fsr/mrE1aE9Zlnn8hHPBxTW872tvL+qww5KicbHjpD5p?=
 =?us-ascii?Q?QOo5IIJn1qGTVAJ+rMsZvZVP7T5uf7CDd6Mlxxz0LG1rLjcc+HJEc6TO2+Hm?=
 =?us-ascii?Q?mb+/Wfjenl2RMB8J4P/hq3l/IPZdk6qbUIvy0DenR9Fvui/Hr2RckFum3nCM?=
 =?us-ascii?Q?+0t5RJLC4U7SgBXav4tNz6Ib3w097/s=3D?=
X-Exchange-RoutingPolicyChecked:
	Ftfkv5BcT6cg4aZIUATqCzOnNV2pyTN2RiKp3LdTwe0kDqCIPhJhXxEBtbBOimQoG+HcXzhXgCdi0dxoX/6VrcyqKlPJ+zI4nMO4Nqi8Xi5e2JZqM8IaF3mmZ7c7UB14W2kilElZbe+qAYWdI7NFac9lnzdjaS9pASb/IrK5hxFlEsVL4xgpunjRRXPMciOySgYwZLAz9uduOAHyZM5H7WIU2MOf1KVCB+ls9laZni1ljO0K2gJfWVjifv1ERfjj/TaTeHQJgePraCNDhnmxVXmxtOkaZ4gfTDAjcFdOgQocG+QGQZiEzSkJiQBZcsJlMODshfJdd6pjg8bf06Y2Ig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xnT+ScXqReKQAXztVz31U9LSFAUwKzYqLQ3oPH3cERxcA7Ew/26LB8fGfxTUy5gYvDpsK0mACYXwh8LZA5vWpdNjt9rgVDRghR55h1UYko0ETKA2HfPmqa/xH++Qt24kKuc4ucKJDuSwNUC+31HOPkRMa7B5W0oKocFhUv0pnPa4D50NyV6c+C/SueQghfjKoiJWWKMzgMYXjSnrMxrMi2nTYsUKbpfIZ4UOP8HV8z9vxCFLN7bm7zP6nQCEkj4zENy/UxLmKkvAFDnFxdaIDBJmn5QOdU7L4D1GBbepGw6qUUYwpbv7YymXmCST2WJN/SsCzgk99KfDeWa4mAcX44wgSEanbdtThInh+wAr1394VN06Lg7LxX90Qrhl2HffY17/zdskRQ+vvE9ex71tRd/9l07Tdf8gQ2gztj4924tNabPGe7umFrf5M9eZI95rUx3xSPrBLFaJjqu/pmqHVziOvdc+0/ZKnYj2Y6o1PBDgXVnBEqOPhlLg0cT6bmNC+3Pc53E8G3dujv6ZH3GL5uoeYSV45MO6Eoh2HjRJCgk6BZfCEwFTQjO9g5+Ql8Nb33tlkLfuI4tGgTp+UoPX9c7JMfiGVi2Pgl+WfQs0oEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f3d35a-197d-4d9c-7886-08de841dc719
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:36.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcICIw6gL3+Ru3xULZ1XX9PLyX40nD1wyp4hhTyxclCl62rvZyzWFniOnl8025oy1WTCJ8nELb8fMk7CnivfnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170107
X-Proofpoint-GUID: LMltvQx-3nBOcjMSELj8sTeCBWlTW-2j
X-Proofpoint-ORIG-GUID: LMltvQx-3nBOcjMSELj8sTeCBWlTW-2j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX7Gg6Hegg2COO
 Xq2CDdXDe+44soqd9zfPILjtlhhq2d//AaO3F/n4ge6+Tu1Ri97yRvRygK2FsxVZo5+BQlocGo8
 QZoj+/H38RRu/ab0ci5gfEICND+y+IwmvDMMURsLRbNTEX2nZPm/NsYoRZjSG1QPliIkSRqePUB
 7zTqmev6rgaUeJvqNNgiM+nzCoMd4FAbI0ayKMkgOeDykgsN/b8zkLh1nimxA/jToASJ/qrD09o
 gXO3tgKUoyZNIAvih+ea67hsz3p9CQ+XlI3rmb9RTgUv1kSC+U8RswT2uBncNvp8aqZPhOJYubt
 2pg7g7xJqwaDCyfnzTx3gvhECGKLu9OkR/wj8F2PEXJqj5eajoiJ9Q+UeXVnMgrJCtWE6bt1Dj4
 J5PKpJbOw/0XTLJkdP9d1nxuxNuD3Q6kA2BYyx2TibfMQ5jw1CphlcQtmZLZ3Is2kkIgCm7u48U
 libw83Bg4E2LsDVbYBg==
X-Authority-Analysis: v=2.4 cv=IN4PywvG c=1 sm=1 tr=0 ts=69b9440c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=w2j-RYuHlRZ48gblGfEA:9

Add a core version of alua_prep_fn() from scsi_dh_alua.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 23 +++++++++++++++++++++++
 include/scsi/scsi_alua.h |  8 ++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index d19d1845bc324..c269105dbae4a 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -608,6 +608,29 @@ void scsi_alua_sdev_exit(struct scsi_device *sdev)
 	sdev->alua = NULL;
 }
 
+blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
+{
+	struct alua_data *alua = sdev->alua;
+	unsigned long flags;
+	unsigned char state;
+
+	spin_lock_irqsave(&alua->lock, flags);
+	state = alua->state;
+	spin_unlock_irqrestore(&alua->lock, flags);
+
+	switch (state) {
+	case SCSI_ACCESS_STATE_OPTIMAL:
+	case SCSI_ACCESS_STATE_ACTIVE:
+	case SCSI_ACCESS_STATE_LBA:
+	case SCSI_ACCESS_STATE_TRANSITIONING:
+		return BLK_STS_OK;
+	default:
+		req->rq_flags |= RQF_QUIET;
+		return BLK_STS_IOERR;
+	}
+}
+EXPORT_SYMBOL_GPL(scsi_alua_prep_fn);
+
 int scsi_alua_init(void)
 {
 	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index 5b3a12861658f..c16d4adc915ec 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -8,6 +8,7 @@
 #ifndef _SCSI_ALUA_H
 #define _SCSI_ALUA_H
 
+#include <linux/blk-mq.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 
@@ -37,6 +38,8 @@ int scsi_alua_check_tpgs(struct scsi_device *sdev);
 int scsi_alua_rtpg_run(struct scsi_device *sdev);
 int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
 
+blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req);
+
 int scsi_alua_init(void);
 void scsi_exit_alua(void);
 #else //CONFIG_SCSI_ALUA
@@ -56,6 +59,11 @@ static inline int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
 {
 	return 0;
 }
+static inline
+blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
+{
+	return BLK_STS_OK;
+}
 static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

