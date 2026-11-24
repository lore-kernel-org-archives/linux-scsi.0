Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.178.238
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795533307;
	b=wo3hptRfZDf/0h+3NFuJ56m8W4ujkkRlyVznET5/WhjyYrIz/aWBP64C6yXKDR3yoF1Z
	 50fHyharw+sAuCSZUT5JHN/xr6hnlhuPrv2OLxXJhxH93bh4p6VzPnJpqPBX6LI4jUDUR
	 F81eNR64uFFA/AlhGi+Em5ktjQ1TUSgbe6M8DTzYoE8yqMBIMPaDBpvcQ+n1kvN/uPmBh
	 VjnBnjXm9IL14r9+5yXjxHXBBSKPfI22rLIDUjHivvZRRKYDV8xNswiEe5aAaX3r1Jagy
	 9dcQ7+WcLzdG7ukDkzAwP/2M6fjbGeXPBAf+YxYchuyIAtGFjSKOV+uKgWZykLCC0aA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533307;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=0p+G6RN5/VvX23KcDoHw6Y/rTSXQjXk/B1JebhLccN8=;
	b=ZHqqhJhgXMgJkMU43aHeOjP+7tBXOetitbNtN61H8PCAfVnTe4wLcznAW3EyU58T+RBV
	 yATkrGolNt/nqQhK+cwp8dzaLVgHGjccnu+XwjrR2NseLuTY+0JGvRxH7Q1Z1bvJ4XzfX
	 m9vrbD9+B7++CQ4NaT7FCUYvix1/r/uodLEp5BelgD5eCnerIMfeLS9uMkJOu6Ngbugcl
	 FinwQWQKOB9dyOXwKaUC8PLpxPY5C5exITjHSS/ySL+/SkRbDy/dqh/oWgl22JMbhjxch
	 VSYQCiQzXSVJU7LmLBFO7PO/JCkf2w3GJlGqLSx9dcQsmt0p4uXU20ol5qkbU+NWggA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=windriver.com;
	spf=pass smtp.mailfrom=windriver.com;
	dkim=pass header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=PXEWLVS1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.178.238
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51E2606A32D;
	Tue, 24 Nov 2026 15:15:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A51E2606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=PXEWLVS1
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOEcvJ51477050;
	Tue, 24 Nov 2026 15:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=0p+G6RN5/VvX23KcDoHw6Y/rTSXQjXk/B1JebhLccN8=; b=
	PXEWLVS11lwPwopMjf6tSQDBBPQ9Y8mL9xk4u5UjuChXsm7Lsl9dOQ2SAbDAwKcT
	ctC5hDWINYj89G6O56bbiNxj5BUr8Nc42KXA1Ood3UEsj8PdQRSJXV4zOHIxVvF+
	ZRyHEB7VMTgpBiw4mBDkmhsS0gPiyHv8zE8eR7FJnV2+GAwdAApStPzMGemzjazM
	OaBOWYg95BZglr0AU9gcijkMDwCJylHUOGqtWz287Xye/hlIOzlOIwmzv7JhPRM4
	HH2i/qouXfm/B3fAHScybneu8ZzcClMO8g4+D/PSrUwOAYHrgwNAFy9oChb2Nd//
	GjECl0ZNK1pV+qH3X2h+og==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022143.outbound.protection.outlook.com [40.107.200.143])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4j517h9185-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 15:14:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ScK2KvCwtOSiW+m1U8xUq6fGMVzzJ+jSkd2IkoxYVdlQh8EB3h9C569c20ZpmDF+sSxNkh5Ix6QbpSWcqwIw7GuNKWc7jwKgvsN9Y0MBXcNUTn/6NFNEfLJKbzuaguVs/jDG2pLL+YQ+KpaXe+4dWYUXAVyFFAT0GuBq6fersGPKv3NSRE/2NBK4zV/eEfFoCL+dpV/0BtzdxaITtARmiYATVD7YW//iFihfo/zxd4Nbcn4xjxiNUwioqlwGTwyx702daMCQy9Mtsi2j5A9S1u3riNJFo4Jao09MhMuAeJaVXUC96T7T2Iul+9ZpsmqrtICJQLGLOuNaW6aFCbr+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0p+G6RN5/VvX23KcDoHw6Y/rTSXQjXk/B1JebhLccN8=;
 b=pOylCAaH+TCxa6rajlR7T3arwtKqfb8Yk0K9OR7NLKgXwK85t6PI+5k4w7eInhKb4tovCHTxLygZnMJuqI7BWRGhtByE1txGn1NzAJlcXmpbdJdIjhs2zgLIrFQjFCO1O9oM1hb0/Lq1n6GpHmlsxXkPJtw7dvtJVXn9XGYF+/cHYsT7kgVKwz4WHn18AlYmgFAtlcmN0yjNJB1gD/G9ndPlju9o409ZvtbIcW5P9KTamloq9fNFKj1mdA0wkwmapgsOwfT0C5wBh4o/AjKcw4CgoyJmOnTmrVfY5Tu0Qm4fyJ6IBPVT4xXGbg0cxeCskaKg3RKvds3T9CWWYZLzYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 15:14:43 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0639.010; Tue, 24 Nov 2026
 15:14:42 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ionut_n2001@yahoo.com, sunlightlinux@gmail.com,
        Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v2 2/2] scsi: megaraid_sas: don't use the fast path for system PDs without a device handle
Date: Tue, 24 Nov 2026 17:14:10 +0200
Message-ID: <20261124151410.43279-3-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261124151410.43279-1-ionut.nechita@windriver.com>
References: <20261124151410.43279-1-ionut.nechita@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VIVP296CA0113.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:358::6) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e3e75ca-ff46-443c-42ee-08df4a3daa61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|23010399003|7416014|366016|376014|1800799024|6133799003|22082099003|18002099003|3023799007|56012099006|11063799006|261026140227099003|261026121527099003|261028144727099003|261009223027099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|38350700014|10067099003;
X-Microsoft-Antispam-Message-Info:
	8qLv934ZE7o4Zq/zBIdnZMA267Sr8EBGB+JN2zRKYTlFptfQLvTXY8k2+XysYUZa6vjMs97Hhx8VJ+hpeF4zoDiTc5blcB5t6ytfEwyyv6Q0xPTrn6/bpUggf53VP5l0squE8qM1te7NHlbJsTpImZclELHmp6EjUsqhKayFdsJJRAPSwyVR+qklkH2Os6rB78Q/mx6S6mhOjv7kYIHEoQCCa/BiOKBGA6I/wb2amVhCPWuH9/NBGPA8ko1Uqu9E5G1OJMISSe/qURbkwJEpE4Jvmm5WG0k4CPoNbo7D1ECqQ3/yGd59yzUB4IKv+5V+A5UynTLbSoytFSrSjCO6RIvL606+JnQuOx2NaVKVmqGS8CnncTO98u+81iWQeW13R/+jg7q+1FFCEU0KWveunExKkitaqXnjlW9ns9ksyIgjpLjSwQk5D6b8qYrnsyUXtWpz1uqGKhk7Rewuz5y0n8uMXZQkiBase3/eybQ7ZdLKEk/ZdNIE7i4wINKqNao6Dn4VCsnRg0FEyqJ3M0e3IO5VivNNwwM4FY7mKzQbMSJDx9hMFiPb2HdrDyQ/FEvD/PDzKlgwSDeoxxIsf8p7gk7Ry5QxSxLBCPsAvaaZ94aba7nzSO4dfAjYvy2voybkxOyQg7ntxu71IyJUR+XO56GLvgvnlhVesK37t/+P/3k049GmQFctdnIsUvNp7LS7FTjeaJenywfYdT98rXoc05P0b8OKpjKt+HecWa1f82s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(23010399003)(7416014)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(261026140227099003)(261026121527099003)(261028144727099003)(261009223027099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(38350700014)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XxTZ1ZxYx7o7GFEfCQAhmvia0GXEBxBIzCBDuCPUNu6t9zpevFBX2WtICPgq?=
 =?us-ascii?Q?ZOdz8taqPI4GQVTPyQ6IaESSJs6q1zyl3pitplSs7uNBaun0FWtB3iLh/Soi?=
 =?us-ascii?Q?aW4AM5SYv5zshNOnqkpwt/bfdeLGQgsjU1gYVbZcB9FGfbsC5ln4u6x+JkhF?=
 =?us-ascii?Q?3hbsYQnvRXme9LOjPlq8yOCKGVnTlmVWKUlxB7ysCkDC5PxQVNWLvPo5V1hV?=
 =?us-ascii?Q?AtL9rUipGfcy2V8mQKSJUjoP1o8Xd3GUBrsnITGL+McsTju0n+iYcZqBCGPD?=
 =?us-ascii?Q?CDOcX1y5i+/+wk6FZfnqiJX9XfdO8YnhmJC0uSEn6lJhahzQfOVnNRRd1zdp?=
 =?us-ascii?Q?fcPiNsaCTHv159Y5YQSIFB/45FgxmLWFy9FH4X+ng6aFXMBcNVNM4cEWAd8j?=
 =?us-ascii?Q?SmvS1Cr6ozmrjUoSlXL7suKM0E4QMGTPQjCktXg6cztoKa9D9EPTRbIbfHEy?=
 =?us-ascii?Q?yZ65x/bIJWCfmcJw4bisCWUgF6SOFOOeODsCO92oSGXqJ84EI0bDJdOI4Wbo?=
 =?us-ascii?Q?FrzZhuwO0OQXTqDVPznnRMlNYlfaLgZS4zrJqdviyWr/D2cHRNGqpjMyQzqn?=
 =?us-ascii?Q?akFIMahVsf1/ZPZAKEyaGTpNDjZx3dX1kh9ryI37i/8GyLquc78FK3+c1heV?=
 =?us-ascii?Q?TCXuGQWBjJNZtr9EuFhY5V2TKCLqquprKBs3b1UHmUs63nzwdm/B/Ncfol1u?=
 =?us-ascii?Q?fauZ1zj/7AA+DjX/92WP5Ey+deXwl/QNnnP4qi5jgqp04V1Ja5wdsiNPz0f1?=
 =?us-ascii?Q?XtxgX6wA510xiz0ug5Uf48Ome4tugu0//qCOx1ncaO4+WyAVTbM8DeV8sY1d?=
 =?us-ascii?Q?6O0vt+93FntXwnTk7X9Hw5+QH3VbPOAE5yUq0cTy47LvKhTRy8SAP58TcylR?=
 =?us-ascii?Q?rKT2w5mkte22+cpql/9UewPnM4o2/fNZXRckaRfZ86iAE2J2mZA1e+1c+mHt?=
 =?us-ascii?Q?gxg9l2pXukI0s6738eAonaCNLXJm9xEseUqCV1uBovNXkm1rbPbEh+/GYJV7?=
 =?us-ascii?Q?MwvMM9Zpxeu7lpYw2p5xUlSAdv46NvjYCmdkx9bsklCgwnYDx/ELjiILYrtA?=
 =?us-ascii?Q?7b1MuACmltU3KNzjXtcAo1ost+t1VckylsTZK4KrIp/7Zm1hjG1tX30EjjTp?=
 =?us-ascii?Q?26xTMLsA48KURmnqpAG9vkpVAb8+3yL0lUvRWKTWiU8zJRq0cWQ5JfDjmqW3?=
 =?us-ascii?Q?mphNptRPOxMDGRm+sNYBKe2+TzMn6Ejf6XD/aJsEqD6YBc+7fAWP5DsjAmt+?=
 =?us-ascii?Q?0TJPmclkRYyRGA1RPYCn6cb4UYQuO3gk03lzXFw56c8xDUPhg/d+23gMfCO6?=
 =?us-ascii?Q?hJGUI1CHjdxvyMT5PwmKMh83uMGl8uyLHQ+hLU7TnQHzvHp2Fvm2cmYaj2/t?=
 =?us-ascii?Q?UI8NKsImL8R3VcQuQ6YpwBFrfvfIy9CPIpDXExuQwlHSMWCMyyf3NtHGfFjX?=
 =?us-ascii?Q?uuHtL+vzDJoxa8va1ZcWlQ19Gdy+YifOMpcn1lYZErd0LIe4/nxsSCFSt/Xe?=
 =?us-ascii?Q?AX+xwOT92j1zjCHwGcjGxrGOUGOFpnaR9hnYITwJTD38RAkxDNZ2ZI+n9bFd?=
 =?us-ascii?Q?KOfOlU5JwUgDuwJcmJQvOHrsKrns8p5ttQRbPbFcUchrOgFvI1Yvxx2+/bsD?=
 =?us-ascii?Q?6NzdnhTlHbuA6vkTOZZAvEyTedkucoto0XTqZj0GP3wIkZU4cIQRbOm8j3Ax?=
 =?us-ascii?Q?ZMRClQM7DXlLNgDioHVgcHqebvg7ezQINvqgGl5LvZcnNW/0ihWn8m45rWwC?=
 =?us-ascii?Q?CE+yjXxFYnNXpxH8Ut2rrrhYd8bEyLU=3D?=
X-Exchange-RoutingPolicyChecked:
	Z34TJ/Ab/9cY3WWBkflymlhuQRHOKCNM34GLi32eLew1MFvu/9d0GlYG2q6RZceEovas1hcG/WFvt5gT08Ns9OD+Ew0sIECzM2KNkTEhtkVqsaLR64RjH+dPyTKgssM3nUdmbE32bbULT+PfT0Iir+bz3j4hw5WuMwZtAOzqK9ILol0527W1BuKcyxOreWo9WFoTlX79eyJT9MBearLhNM6rMowhIv/XWLHeOg/8SYOd6AR4SRdRcRTabF1kpbdqBtiWK/KEpLD7oThym/WZSNPSgcMiaaB7P9uS5B8ij6PAGYlluzRilYgw9RZdt7WYmq1Hq1t+4964+3AZNSI9/Q==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3e75ca-ff46-443c-42ee-08df4a3daa61
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 15:14:42.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QmmeSXDdUAaCl99miVQXCGD2k4lXRv7elTZhg+Pox9Ie/EJjOYASN6ojkGpiiwu1w0jDjz1jZ1k/g0N82Ja7G5apZ+pOJFOjdIBDND7Se9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA1OSBTYWx0ZWRfX4fADS/CHnXuG
 UK06OCovzCCi0MBeGxHKtogS7yGYGOhSDZpFHXXVfskdu2a9d5tAN9Ymr20jllkG5WUhLsQc3GY
 IUHKwaNpCjTdTAXWHDxAGjhaQGjnzHscmnQOnXRivjP8IIESHIuz
X-Proofpoint-ORIG-GUID: 5SN_lGesjMQ12zPEEa1HxrQSDJDumhF4
X-Proofpoint-GUID: 5SN_lGesjMQ12zPEEa1HxrQSDJDumhF4
X-Authority-Analysis: v=2.4 cv=RutQvymK c=1 sm=1 tr=0 ts=6b05a9e4 cx=c_pps
 a=SFlR/MFxl0Ud3Fao2vm/6g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=28fGeO9oC0nIPtNL:21 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=AoMJvZtcn279lFdfBrIA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA1OSBTYWx0ZWRfX+AjsSlQ1mSz1
 TMDRqyALcC/2XsiBOSRMcIgsnNqx2BnNJwefPoYvX2+DYXMrcpElJNWvP4mGQ666MsD8XexQ4Uu
 8G1SaPaG6hLLFQlDDfVf2vFgWQJYVYzmW1NcOqNOS8FUerP/syoLf6WYgwE1wbCwblP/TRLesu4
 /Pxav75D2RhcSQpvALy5f0l/ZEBmLGvB3BGZ5zUWwclU+n8N6vicY/TsK4KegOwwRdyrw4Ehhn5
 7jZbRrqege85KcmuBIBwL7eo2Ml8C/uHeqK24GjCDjoBf2OewBFe55T33os02HKRXc1XbqKDXsc
 5PJq+lZNGNIW0qBjy//uV1J2Z6B+Nw8pfA8PwMgJCH4MZcHF1PwMRP8EHWvsYHExabf97IB8l4x
 990lzuahzhiRNPYyJ4j2MIQzofei1ISqnAHgYvMSzMHwRvRb7ZV09qcN673HOpesN+H/lX46OSZ
 YjuHLSc4S34xZD7K+7w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_03,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 clxscore=1011 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240059

From: Ionut Nechita <ionut.nechita@windriver.com>

megasas_build_syspd_fusion() always sends READ/WRITE commands to system
PDs (JBOD drives) down the fast path. The fast path needs a valid device
handle, which the driver takes from the JBOD sequence map or from the RAID
map. When neither is available it sets DevHandle to 0xFFFF and still uses
the fast path.

This happens whenever the controller supports the JBOD sequence map but
the driver does not use it, which is always the case with reset_devices
(kdump), since megasas_setup_jbod_map() disables the map there. The
firmware cannot route the I/O and fails every read with
MFI_STAT_SCSI_DONE_WITH_ERROR (0x2d) and no data. The controller
terminal log shows it explicitly:

  Out of range devHandle ffff from SMID 8
  MptHostProcessJbodIoErrors: ... devId d devH ffff INVALID - FAILING CDB 28 00 00 00 00 00 00 00 08 00
  FP Error lmid=20c smid=7 cdb0=28 status=2d devId=0 tgtId=10c devH=ffff

Non-READ/WRITE commands are unaffected because they already go down the
firmware path when secure JBOD is supported, so the drives are discovered
but cannot be read, and the kdump kernel cannot mount the dump target.

Seen on an Intel S2600WFQ with a MegaRAID SAS3508 (1000:0016, 8086:9461,
FW 5.020.00-0838) and two SATA SSDs in JBOD. Without reset_devices the
sequence map is used and the dump completes.

Use the firmware path whenever no valid device handle is available.

Fixes: 59db5a931bbe ("scsi: megaraid_sas: Handle sequence JBOD map failure at driver level")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2877b3829..15524d899 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3173,6 +3173,16 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 		}
 	}
 
+	/*
+	 * Without a valid device handle the fast path cannot address the
+	 * drive and the firmware fails the I/O with "devHandle out of
+	 * range". This happens when the JBOD sequence map is not in use
+	 * (e.g. it is disabled under reset_devices in a kdump kernel), so
+	 * send the I/O down the firmware path instead.
+	 */
+	if (io_request->DevHandle == cpu_to_le16(0xFFFF))
+		fp_possible = false;
+
 	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
 
 	megasas_get_msix_index(instance, scmd, cmd, 1);
-- 
2.55.0

