Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4352735CBA3;
	Sun, 22 Feb 2026 23:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771802998; cv=fail; b=gd5f/YwTdfvbsl118zlKuZDf/pT/BQ66HXssnjfFxpjmhpCpRmLNW6HXWxBRHKqXzY3ZykqCehzteARJ3d43HdAGP3MFPG3pHl6/1zUr36nFje2W2xz9K4ariQcJc/gdD6Q/IBBgw8R/arEEKR9l8AaNXUZ7xRRh3yfC/eFGSTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771802998; c=relaxed/simple;
	bh=hVW3xJKWaDXHe7OPUe7m8ZNOivX65QikNTuo13++ibc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GWn9Q6fL15akNjuAqIEU0AwxRcqJ/INbVhwEuMs6GoFslIjMAYdSS6JuXQ1wSdEFv0oCp/EZPE+sPi+H/xNS13gmLss6MIWVYZyewuxs1uVmRLP/g0n/S9cLTxh8G0v+1+tuD0xlIj/Jt2U1bBvxR9+mjCau0DvCUXDIOOut7SQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FnRW32RR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tB0Mv+R7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FnRW32RR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tB0Mv+R7"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MNF1Ho215991;
	Sun, 22 Feb 2026 23:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZOLoeQb5XhuZ1oHI9oCRfyxh6ef9Z8RYig53efVR904=; b=
	FnRW32RRzIW/NKZ9EW3wT35FRpzjzxdbu+Ecv7DxWCQ4KRg1RDotSgj+aI4M0cLV
	pmtP3pAqxidE0318C+Nteis95LT7HjSeo06w3rfcLh1U888SSco2mqawkKnePrqO
	At1QQRKmE/kpElyRELLJxJz5otEv+36TK/hXaPNZ/87Dipf4I9BrULaD/2U1P0Lk
	mDKSkHq4LNc0seNLPvwFDiAqz7iBoAo/vaSwZYVlo7IEgT5yuSMq0hpuO7ka4sm+
	GLbqgajNVZOHuH1lUo4kED7qenNA/k3mQODO+ePYcZA0rr/KLpJ1gtlBEK4BxqnD
	dK7zGUOKp4XCvYP26lHBFQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5s98p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61MNDIqZ028450;
	Sun, 22 Feb 2026 23:29:54 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf357pyvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vt0TVW8uFoNqjycJByAzft78n0fUYYItyQ/2VmCi1o5TCgB5qqfFHWIF0Mcsiu4i7QbQbZDtWTL3eLy9A3N+Egu8hU98mMd1axW5yxX6d8ZyJWx2JqEfNnnyPH/Oq7wQ7X/BhxKr2WYqkMnsSS1m9BhGS2bmKe8hzvfKd2t385mDpSdZZwwc/pxfJjXXybwiULJBz2uFC3ReQ2KAMExZ+Pb7qEaTcPOcMob85+D5H0jCWDRDizICtodl4QJF5wPtXd+UnTGZamz6ojSyCXoxTgTsnvu1WwEfQjOgfsesvbXg484/46HGmz6kkXYX2u7MiEG2iDQbN25GebKuwOT7Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOLoeQb5XhuZ1oHI9oCRfyxh6ef9Z8RYig53efVR904=;
 b=ftPM+pMwXXyIbXWeZIYpYkDzaMXYJmqj5FX02fAz54zuOR2bp9+i0N1ZDBNAodREUIlscUK/JZg5acV3ULlJtTYFihjYRybFahyfdbTNtULMN++hiLC5LLnwFwbBxamzhT/aBWbkSmwQid3Jioop3KHDWWvuN9zRxyaZ/TIdbkQ+646bDMJeA2cb099bQHJ08QP8IWH2A/wSi8UBsC6q/mwi+Mz1wpbtrNUP1vUTWmmiGNJer8iyJBP8G2gNm+7YsAP44m6oD8DO8oZCBYvlFRAwLlxfZb1s85Aj8fVG0lucXoNzIX51JwKqou5OUCD6JoohSORYc95E3FpvY09MUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOLoeQb5XhuZ1oHI9oCRfyxh6ef9Z8RYig53efVR904=;
 b=tB0Mv+R79NnIBcmuXFKB7LDDziWo7t9kWnGPPrEI6tNPq21EAJo84Qd9HHlg0VqPo5AMzfqO19w8XpAmMq+ViGtrVa0q81w50tRmuNeMSr2F25DJH2lPjERqgruNAN5VA0TKUomtPZEmF9oHe1QjfW9iegGbH+aTIamSla33cf0=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CO6PR10MB5587.namprd10.prod.outlook.com
 (2603:10b6:303:146::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Sun, 22 Feb
 2026 23:29:52 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9632.015; Sun, 22 Feb 2026
 23:29:51 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/4] scsi: target: Use driver completion preference by default
Date: Sun, 22 Feb 2026 17:27:02 -0600
Message-ID: <20260222232946.7637-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260222232946.7637-1-michael.christie@oracle.com>
References: <20260222232946.7637-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::28) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a19b89-cdfd-4a64-5df8-08de726a470b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JW2d6xvINvl6wKx5McINhE3xvG+kGVuEEqJyECegRNcOnZzDs8pdGnfxg3Zs?=
 =?us-ascii?Q?34kG6q/Tqf3jK9vlp3RPhi2BDn66U9Ka1yUGi+ovZPxGt4AfXtdubvlxPjPK?=
 =?us-ascii?Q?nh1K4REk3t52jN/YLiBJtx4LqVzzfuNVNLKcfQiKD3pDooldGc9YE+XqVjb+?=
 =?us-ascii?Q?zVvz/cGl6R/kmYk9Uj8oluyZo/nzIqBQH+yNZ4TlkCuGMj9+aD8o4aqDRILu?=
 =?us-ascii?Q?4CBGUO41DG5wnMmvqz1cRqT1BKXU5O0GHcXPFvtKt80UmuxQXs93xf0cI+Fj?=
 =?us-ascii?Q?D/27Il++BrwKLO++B3cqeTM3HpuPmTPI4M87kVM7i042V3TdczinlW2djtzV?=
 =?us-ascii?Q?h+ZDFBBJLkqIUjUTPSH7Ym4l6HOQD//hG+IocNPEm/SRjecN9KHlAD57Gb0+?=
 =?us-ascii?Q?RpTqKZsUXvirrippfwxnDGsVzxPubQ5Twuw2eeOmPEo9MZCK7OXuAonjYaFh?=
 =?us-ascii?Q?edOdGNjEWzf6WxLdlYizdtxHZWk6ydzOPMmsiamV+zDtPLhRY7LQSjzXF/a7?=
 =?us-ascii?Q?lJgp4YldTKyhijmVSDEOFnA2NBDwLTr9VUZlYs9F6t/Dml1EwmQ5CO3N4J/2?=
 =?us-ascii?Q?nntlvO/0jvO5WKjXBoDyo5Ett8t9wtUWntYVyeGiPHgPfPszuKRfCZCsE2Oq?=
 =?us-ascii?Q?tpt1KDOK3w2543Ja7mINF6yuAGkbjfc8axZS8Th8VzhwFE+cmMfNdQE+yrZq?=
 =?us-ascii?Q?td9p0NACm2So9sAPuyqJJjASPPeHQGQXYyhrvX17Bx+vpg1vD43uwID2n7Mq?=
 =?us-ascii?Q?0IKZtnbMh6FsOD7918kGlHchOtRY1bxil3XU5Ekf1TNinPF9nh3zoHDIXtmu?=
 =?us-ascii?Q?+kRjo7pnE3d8xaEfAaTEUj2b5cwNdyATF00HlsfAhKvwzbEviO5REfjjqrRf?=
 =?us-ascii?Q?pmxVuRburH2Pd/PMduULO8i+AHLp8mIAVYx+ZQoz3i9kZlir5ijiqUQdcvzD?=
 =?us-ascii?Q?9bXc6AF+E+STLFD9FGHUP1L6He10K8D3WzBhx1QzL9tLkdUZUs8rs7YQDeGA?=
 =?us-ascii?Q?J26EZq/AAxPz6QV2sISZIthZnT0XWSPSR1ZqdCjxDbZszpNUOdmHoKCAo965?=
 =?us-ascii?Q?7vtXIwHVNFMdSaEPq5X+R7Ov7D4jgiTh+nNIvL32om3IaAD1Xu9lAaxLTx0l?=
 =?us-ascii?Q?sNRpTSQuq2CEQ9U6/MaRqJsBpldgvn4O7+8aunJ6EMo9VOQprujN9c4NEJ8L?=
 =?us-ascii?Q?ahCLwfEpsIjCKy7IgCserEwtuoVAr487dGKsEZ99WlFEhwZmh3cXoLUggpx2?=
 =?us-ascii?Q?b4dmz8WWe275O/bXNu/djmDgEdo6GUzoCxvH7mG6VwNwzD8M+ZFBBV/HLK7p?=
 =?us-ascii?Q?gIPUwXDDRq7W1ot1Iny0Foln2dpWhYxouLN6D39jIweZAwy3ErOaGf8VpSAd?=
 =?us-ascii?Q?0NL65abys6JVhRvUqqU8MHvi945sXhrPJszJQDs1WVqhltWfH0cEAb4dBOSs?=
 =?us-ascii?Q?u+xQogXE5SblUtIYq2v2NVJl6HzfJrq4aKXJZ5duaoqKqp3HpISOhixMkjZn?=
 =?us-ascii?Q?NTfLizDxj3ETIh0L0iaNlBI0Q5hK1NLqagtlAMqnuoEYDnugdMaOTjg2xgJY?=
 =?us-ascii?Q?3qEem0prTb1l7J4WVzo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dgy8r6zL47Oe2vS3WvWWJu0Mm7F34jUkyenplqdJtLpSO+1ADkX1n1+GHXyt?=
 =?us-ascii?Q?z8BtEmhaqpkRlqXjlkfBY9A9iRF1SNNLm0QRGewouT8saUE9+a7cIOF+y+o1?=
 =?us-ascii?Q?e1vqesbw14CjeIYZdQL7vDiKE7AYtR6vc7h1XahMAGqDVBnEY4TCMxG4yR9l?=
 =?us-ascii?Q?xLmdMtMbz/r3GNxLWVzw7udO116u9GYUyohxbOVtE2CvTf2qeccUqMh27eoQ?=
 =?us-ascii?Q?BY0wOGkNbTGjsIwbMM3VuVHTvWLJ2zPtpuFcUNPq8tVpvVSogciRyro+L7xP?=
 =?us-ascii?Q?PSRZp6pfFlmYGrRKZC/lfNq58SHdbTtj2362YLUkTtW+MqwKBBx9M1GqAvx8?=
 =?us-ascii?Q?OIu6A+OoQuY//85lX9y8WTX1kmAhG2ANHW0QPYUiJY1ha4yxKfdabSB7HRxU?=
 =?us-ascii?Q?/tfqMTk6UlDfuhKIQRBNu+fBvBKt7gs/lBqvdskMNmZo/rKAxN9ecmstoRkd?=
 =?us-ascii?Q?bCVmv63HfDL7ZDRLKxs/jncOL5i9drkMkvN6f9UG72Mkzg7cTNJKLgMUKfvM?=
 =?us-ascii?Q?RZlfxnv2rfMTu9RrzUOIn/OKOUZXR3LZv2t4Ty0nWKNX3PndmZt6bI1yHfp+?=
 =?us-ascii?Q?tHJMNXohKJjgZ6salAsoQcUDFgf+K6jGthD1Q5a2FY5gZgYuNjEBOt6XSRd/?=
 =?us-ascii?Q?oATAyejNiIb0Es0UoBr2BpWP7Ag2sHPtS1sSNEqITtPjUUPKBljFVqsbkMEG?=
 =?us-ascii?Q?Vt0NcOQYHd94Ef2Vp18SH9e0TShKcKueReByc6/EQTAA2k3LH8Q6AVaozIkZ?=
 =?us-ascii?Q?wdwqe496tpoBi2mIKCxE4PdHNcflHSn1SD3N3QkQRbMsrhDCTrHHTyV+51VX?=
 =?us-ascii?Q?3NoJfB0qaLI6NyNC0gHwDTTgxZl0CRc1lku0nrfslKUZpDonXPWy60xbWHZl?=
 =?us-ascii?Q?o4LGUalJkC8HF/Sm8kXXMJtKRXCZkSiLrRib2zWM7M/51fFtTtxzVGkcO7QC?=
 =?us-ascii?Q?ax20fNWPeRW7ZpDui+1YKCDIG6ZkrHCyv6UVK8QSrCDUGWr5j35tzsFPHOEa?=
 =?us-ascii?Q?obaYr89nNVKc0Dq08zJJmND+Rw+0E3vKScL0eEk8mqBkJLlu8OhVE0YyFw4C?=
 =?us-ascii?Q?SVOoQWhx4nXNMwvJTlfOizHdclPnjTeOZ558RqNHMflzSVifsJIKGq9PcDj+?=
 =?us-ascii?Q?ElKZZPLAZX2xtF2DwNHUtg+GsTd1uUvJ/c87CQB7yYHfbRDjEKEymx6h5eEg?=
 =?us-ascii?Q?KQ7uEx3j7PpEqd85EC3GGWW2ec1aPTsaO/xK/0y4J+FCH6zFWuA0Lx864bUi?=
 =?us-ascii?Q?Rx1DoMhMc1M/3p25GyTEfkYvq2yc8RxDj+2N74yCx0QKEr6md1CpgKEYXUVw?=
 =?us-ascii?Q?vTwx69Wkob1W774tyec3AhuSEoloXolmR5aKQd5IBB389GqSMR2FFinSg2F3?=
 =?us-ascii?Q?87tI3s6j+b/W2rg06omPM1f/aHt3eF9JTJF6FvsVVqkBfoUUlEoXx230c2Uw?=
 =?us-ascii?Q?u9w53PZwiDTnEuMqAVyQUFBdiGcsie110MTtnisMMDHHDgJQeOsQUNt7AhpN?=
 =?us-ascii?Q?kRCsl8GZG7s6Dw3wYSOeeimEtPz/vxQZQ7yWjZBwPPZUKzV5tj+xajB/Ij8M?=
 =?us-ascii?Q?bZI2En4at0SVTCgKzOg3vXIukeTFZs0upbt1WSNOvycZzFIF8wIKZRtDchpK?=
 =?us-ascii?Q?GFCVsphiwe7uBvtAHrGZb2nyeAPeZX4BJO47Ygc4Z317kxyP+EY2TNQ9GbVP?=
 =?us-ascii?Q?Hw1pCa9tj42Ghvc9xGQuspryYYxTXcSYPYAdGzWqWzAEhyo3vTja69aXYpls?=
 =?us-ascii?Q?Ai1U++RscJWuvessXlqPsO98gYzBOZQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HOaTbGz0qkc4roPHiW/D1EyHwvRTezkrNw8POB4JwWHi6wmCpEcxQvUEFSX6OEtrmptWG78E3a+v+0Inm7l+3tjPQD3vTcLUfniRwpCw305WYgWYXr1eFhx5vLG0/TvTJQlGh2pRjdPJgYZjfcVd+Mh3EnpshC+3mve9TxPANq4fHyB4O4Vei2UVW//l7ILY3fhpzw/GnwGpOtAn6cC512VO963Y/lgtt5Lyiaek7wgWdXc9LFT5r8zsH/l/2JJ2dEMG89u3x7ZopOCrp4FMH6pt+da1TG3dgScUW6dg+gxSiegP7zcYKvEG9DquSr3VVauIN4Tie3Q3rvkj6r6d5B+pMYhQHLq5mqXRGOWpcbT/Fk6EGI3NJOcXSElciIVAIrPdrFUEhy9+YWyIb9rN7+aPPVRCAOQfTJb9pt7KS3X+xRA9IAu+D5NXur3L4li2HLqSbgysz9aYoQioLQrA3uMM+FRoBseBZAWRohuOSKc6NO9fQEwKCd8bUtGmSnk3D3dLI9emJbyfCVoehCiih7GNGMNT9AhyOPM6Q4kU4oklx3lLyq8Ykub9YU1TKlf6oT4YV6XUuxJM8+LUPJ69OdSNpnm7uuWG+8cGgGLSkqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a19b89-cdfd-4a64-5df8-08de726a470b
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2026 23:29:51.8836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqsueYsef1VfWzuT3woAZvxOgz3EkkVEpWKZf9TzfpGRUJemCcB+je7FdHfLmWXL/wM85rIGTQMmYStx+insDDVveQcbkoprtCnwPdIzi4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-22_05,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602220224
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIyMDIyNCBTYWx0ZWRfX/mfD45WvHtgP
 63POK8aT/wGBU7SAkfPU1RwTkOcaOnOC3ugMTIm+bFVDsZSSzgGBp41iP9BOOmutG7DNp5Beqi5
 OCsPuoVIP6YWbMeI9gKnOsD+QUtJX9fF2FuOYMD1pXBswhteITBYWE9eUdy7qfVu8s9lfyg49HG
 nhMb8qLtaBAZZJrjp+3Osmcodo3j3TO2HOZotAjKYK/YcgG3syTX0saVczkELjzcdaCUb2pZ7cq
 FqBSGUONF8SvHhwOX4W8BuanDXNnfKCELU2Yehv4s7LjYlxeft6qFSzWtRgwyiyFbOdmKPzggXJ
 BwgTjGzGM6fV3ITUb+imy+mNtXk6Xs4XDWe8KXnaHc0U8gkYMLjafDKf5EuOfN++OC/rvkfv2Ii
 wM1BMgCgqQyRVh4pn1rfdAzTx4BryHb2jZLxm6THwO0JI0OXxtLJWVpDLBMwFd7zhFnytZEMDXk
 AsJQTKkCsQFQsr57KoA==
X-Proofpoint-GUID: uDll94hjN9mbmpWW8AGLA9-1I1DyVn3F
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699b9173 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=MJFqtmiI8ZSq4AzAJL0A:9
X-Proofpoint-ORIG-GUID: uDll94hjN9mbmpWW8AGLA9-1I1DyVn3F

This has us use the driver's completion preference by default. There
is no behavior changes with this patch and we queue completion to
LIO's completion workqueue by default.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 1 +
 drivers/scsi/elx/efct/efct_lio.c             | 2 ++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     | 1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 2 ++
 drivers/target/iscsi/iscsi_target_configfs.c | 1 +
 drivers/target/loopback/tcm_loop.c           | 1 +
 drivers/target/sbp/sbp_target.c              | 1 +
 drivers/target/target_core_device.c          | 2 +-
 drivers/target/tcm_fc/tfc_conf.c             | 1 +
 drivers/usb/gadget/function/f_tcm.c          | 1 +
 drivers/vhost/scsi.c                         | 1 +
 drivers/xen/xen-scsiback.c                   | 1 +
 12 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 71269446353d..84b8ff5953a8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3926,6 +3926,7 @@ static const struct target_core_fabric_ops srpt_template = {
 	.tfc_wwn_attrs			= srpt_wwn_attrs,
 	.tfc_tpg_attrib_attrs		= srpt_tpg_attrib_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index bd3d489e56ae..9634178af680 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1612,6 +1612,7 @@ static const struct target_core_fabric_ops efct_lio_ops = {
 	.sess_get_initiator_sid		= NULL,
 	.tfc_tpg_base_attrs		= efct_lio_tpg_attrs,
 	.tfc_tpg_attrib_attrs           = efct_lio_tpg_attrib_attrs,
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
@@ -1650,6 +1651,7 @@ static const struct target_core_fabric_ops efct_lio_npiv_ops = {
 	.tfc_tpg_base_attrs		= efct_lio_npiv_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= efct_lio_npiv_tpg_attrib_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index f259746bc804..a093a4e5d8df 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3968,6 +3968,7 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 
 	.tfc_wwn_attrs			= ibmvscsis_wwn_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2fff68935338..3db9c52a9edc 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1840,6 +1840,7 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.tfc_tpg_base_attrs		= tcm_qla2xxx_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= tcm_qla2xxx_tpg_attrib_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
@@ -1880,6 +1881,7 @@ static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 
 	.tfc_wwn_attrs			= tcm_qla2xxx_wwn_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index efe8cdb20060..704ec94383c3 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1591,6 +1591,7 @@ const struct target_core_fabric_ops iscsi_ops = {
 
 	.write_pending_must_be_called	= 1,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 01a8e349dc4d..fd9beb1f5041 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1106,6 +1106,7 @@ static const struct target_core_fabric_ops loop_ops = {
 	.tfc_wwn_attrs			= tcm_loop_wwn_attrs,
 	.tfc_tpg_base_attrs		= tcm_loop_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= tcm_loop_tpg_attrib_attrs,
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_QUEUE_SUBMIT,
 	.direct_submit_supp		= 0,
 };
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 9f167ff8da7b..78cd242d7004 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2278,6 +2278,7 @@ static const struct target_core_fabric_ops sbp_ops = {
 	.tfc_tpg_base_attrs		= sbp_tpg_base_attrs,
 	.tfc_tpg_attrib_attrs		= sbp_tpg_attrib_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4e6736d469fd..619a82e78df6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -813,7 +813,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
-	dev->dev_attrib.submit_type = TARGET_QUEUE_COMPL;
+	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_COMPL;
 
 	/* Skip allocating lun_stats since we can't export them. */
 	xcopy_lun = &dev->xcopy_lun;
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index f686d95d3273..679fb5ec9a7a 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -433,6 +433,7 @@ static const struct target_core_fabric_ops ft_fabric_ops = {
 	.tfc_wwn_attrs			= ft_wwn_attrs,
 	.tfc_tpg_nacl_base_attrs	= ft_nacl_base_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 6e8804f04baa..64b569218ccb 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2015,6 +2015,7 @@ static const struct target_core_fabric_ops usbg_ops = {
 	.tfc_wwn_attrs			= usbg_wwn_attrs,
 	.tfc_tpg_base_attrs		= usbg_base_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f43c1fe9fad9..1f00145116f4 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2958,6 +2958,7 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.tfc_tpg_base_attrs		= vhost_scsi_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= vhost_scsi_tpg_attrib_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_QUEUE_SUBMIT,
 	.direct_submit_supp		= 1,
 };
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 0c51edfd13dc..8949da55f3c8 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1833,6 +1833,7 @@ static const struct target_core_fabric_ops scsiback_ops = {
 	.tfc_tpg_base_attrs		= scsiback_tpg_attrs,
 	.tfc_tpg_param_attrs		= scsiback_param_attrs,
 
+	.default_compl_type		= TARGET_QUEUE_COMPL,
 	.default_submit_type		= TARGET_DIRECT_SUBMIT,
 	.direct_submit_supp		= 1,
 };
-- 
2.43.0

