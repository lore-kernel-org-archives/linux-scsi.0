Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013009.outbound.protection.outlook.com [52.101.127.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CAE264A9D;
	Mon, 21 Apr 2025 13:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745243905; cv=fail; b=eIT/7XkLparvbKIaQURHDFkApbi+nbzoXmaz61dL60/y/DOY4Ehgh4q1tWFNm+P8TEKyjWYZhMRG+wdj20/2uJHniKmRt6CBmCzyS75YMgfj4NhaOnsVclSGLF3hboiBniBEUpRXyobQIBOtUN5UDIE6K/PU4tA3/CBCI+Rqudg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745243905; c=relaxed/simple;
	bh=ZYX4C0byyp4wX0RCOEYe6NOKJe3xMTYMKrygOGvRw0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BwgGbokoDrxS1jgksnDKPImLkG9o6MDd/y2uUavaTXCLeeWhAhffy2yYq3hxuBjt600VQsSHgs9WsH1y71V/J9N4oM7FVrNharfu4Dm9zjDgSgIDfajZwF7uqsBWxdupDAkvQr1cfmJvXZCQJF/wwrscsDBZo6Oht5VNfEF/TkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jiCMY7co; arc=fail smtp.client-ip=52.101.127.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="jiCMY7co"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oXFcmugm/W1q2bWwzaukiDu4zJSHugb1i+VKABu5ecLcRWeDCex+j2dwklo5azUeUulhcuNoxZ8p6Wtg9hXVh9+nn0a5iMNhuKr7vB7mBcX6rtDJqIKBpUndgKMjNRFmRDpfQoMwoiAQIvF9x1uXc4TV64u9UHnIwORTCASetlpbTf8jcmMYVtShKCu8jLPhNiK/ELi5Ro3qkifGBjBKAreTbzryQB/xEqDaJbrxbIrAnB9nBmRQeotyNavn6xg5MBlTZnLfd3IQ1iMrBE076DZKXpKF1XzidGXPKdWlSQbbFjmibIUgVgAj5NwLZrV0EDO4s5BFrs9Cqd0xTI0MLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYX4C0byyp4wX0RCOEYe6NOKJe3xMTYMKrygOGvRw0Q=;
 b=RCU01CKZCq2e+4/9XWIrIuQ7lmEexLtLxApyG69B8wXKYiNja1GfP4v+PdA1TyQZ7Ryo6CI2i0iuVHqpYdTVlGqPQ5Nmd5CQpRod/ogar63SJDBETbLv84cGH+8R8knrpNK9xEmsp6H+aomFBlh0M4MJNuN4vwr9qobIruapbpaox1b0caeiO5gIeu7DYX99zJjrU5EvQQPLpc412tnMzRxCC+4yymksG6LvBKZfFWtRScrwWkep5IZ6toBvH3FU3HXWq3UGPb5MbzWNp1Glp39cjXZ21yMGKsKyjtrzlbj0XpWNTl1cjS2dh/9nn6TzAwt2byjAnJu8DdjjNYH2Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYX4C0byyp4wX0RCOEYe6NOKJe3xMTYMKrygOGvRw0Q=;
 b=jiCMY7co7oJPLej8IPCNmjqmiX5GIFi2Qnq34mCpY+uxhmtE1vJmvAGvmvUEgyAmkWwHXjNI1c6xGspP61BviRzsBUFR5NuyXne5G77BhdmVQ7zjnnYahVwt1LZ/PYo3t6LCd+hzp07iidzU/7iQ2pDXJwvV/flJSK1Uk1rPuXDsHmjVeJpxWhL/U7Pv/v6EKMvFuafV9kC6cASjqYmBBjOyibX6MuI0Sfx2u4LoZEBBGRtQP7tp5rv70hLsEvQfsYCbQXTiPDbMOpLpFIDMlLwOCPFqPRmmwOZNRXgBS7oq/puR1bKOrTwWbbskVteFunNaBYqjh3zQaPaJ8s4H3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEYPR06MB5349.apcprd06.prod.outlook.com (2603:1096:101:6b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Mon, 21 Apr
 2025 13:58:20 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Mon, 21 Apr 2025
 13:58:19 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@vivo.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	ebiggers@google.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_nguyenb@quicinc.com
Subject: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Date: Mon, 21 Apr 2025 21:58:12 +0800
Message-Id: <20250421135812.644-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250421135123.594-1-tanghuan@vivo.com>
References: <20250421135123.594-1-tanghuan@vivo.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0238.apcprd06.prod.outlook.com
 (2603:1096:4:ac::22) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEYPR06MB5349:EE_
X-MS-Office365-Filtering-Correlation-Id: 512efcdb-cf89-47f5-0a0c-08dd80dc9294
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+TTKhvPVnuAcXhoEs7F5tcUgL7rdjY7QoHbbT7/jZesKmG+EyYq95DvNSVuY?=
 =?us-ascii?Q?9i/nFBPUMChKN1dJH5fF6twH2g+jgxKSz7snA7N+owoJztTWIfbvj78EyZpz?=
 =?us-ascii?Q?WuZLCCWVm3laYFNH2fgMwF2puX31OWnzEjiHVawmswcwocOssix7bRR1yI5K?=
 =?us-ascii?Q?X0dT5E54E2gPfgIDyIfR5WXtzVaxn6fjdQOBhtPEM6yNQWi4CHeEf0Y7LzTn?=
 =?us-ascii?Q?rejH7wTC/Kah6uwqaBqph1oQtJjxGly1E3jZ8pddsJBgl1m5FEauIFEuwhHD?=
 =?us-ascii?Q?CjGGsvS6BJ94x5OPqHRb2d0EEv5tM+IqDpk4TrbAOdy6WjK/e4iVldYHduWj?=
 =?us-ascii?Q?K7kFvYsAFHPrSTiInCNKyzYQAj61YTQP3Vbz4vpHJj9MyElJh1CYkoJGuVv+?=
 =?us-ascii?Q?I64xgDIP4VJHwqz/CVLKMmB0wPs5DAqvnzGzoGjOa28cVFGHMpo5XVVizza+?=
 =?us-ascii?Q?/dQRLUadPh9G1Nrre8MXGBvBED7Oe834n1+phsoYmZX/ondGqyJmx9Yi4Tt9?=
 =?us-ascii?Q?lUSLnAZFft7ATZLNUt6K4wPCgAoSA0MGKQMSRpx4x+TQqrjaEpfLStXOXqGR?=
 =?us-ascii?Q?PujW0g9b4cGGKtuXqIjBTM7J1MABEwe50wF2IjxMBHsciLC9opF7rdOXpjhv?=
 =?us-ascii?Q?UtlT0nAty8/Rp0ImhLR3hQhfhfSpQN1m+j2jDoxjougphG9vf8qHovWMZegQ?=
 =?us-ascii?Q?4/2yfvlfbuaD4P7JMJgbzIeWiJYOTB9f68aBb9Q7Owj5tJGFbeEipskzeIYq?=
 =?us-ascii?Q?saj1kVhOhHtYWtmFkEUPAt/zPS+s5eyc2jXdjeZQBHBllYZjUyaXFS6EHKJG?=
 =?us-ascii?Q?DFIVTvVa/FR7PmpKOs10h/Y5ehV7mnG5LzWqvQL4Lz3vnkgQ7nvC8GBeimRX?=
 =?us-ascii?Q?G1C9Y/Fq6aISGtOgmAoQ/teBdlCbNycgjqwtvhFrGuum5Jc9U5TwJhYLfIR1?=
 =?us-ascii?Q?zjdHxqWDIp/xl1kC1FUeBirWG0GnLMJyHa0gBvCppivRY2IHUWaE1o9sLJGQ?=
 =?us-ascii?Q?6AFHL/w4onw2ZxmqrhPDmMP3r8eGgQaGATqxyALtaCEx98ZLRz/r3aHVET6n?=
 =?us-ascii?Q?Msf15iZVwwLL8QcKi3a0d9cbpEUkNIBCkxJDyeNz8MFeUgCTGSPW6n/PdiaB?=
 =?us-ascii?Q?T/tEq0gHYTc/MHgrSr0YSPwPWxdpJXi/Mql1jYCP+EyDYCatBI0Wsvbc0iOY?=
 =?us-ascii?Q?jTFsE8skuyiwtOuuZOM9rQy4FZ+t0WHyhiRW/A0TC5Venv5KYwKio3eH+ioV?=
 =?us-ascii?Q?4y3cloBr+iwbyRNiTJG0zTTdUChih1bq3J2C08ud5queoOFZgNA8iqsYiOWJ?=
 =?us-ascii?Q?PY5+dlgTrmWR8Mk9aPIBruai0Fp6MbzDFIBfPMusbov3IpEz3smfbubSOZcz?=
 =?us-ascii?Q?K/a0j/AZ49jQAS+uuT/AbkEBFM+CdNwrADvBcZTuccSsiXQ/GMiELo4IOsgU?=
 =?us-ascii?Q?FrNiH/6TSPSeQE6agXYric/HoK8YDkhj6ljyIdGH8EY5o9V8x5iDqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zdsrBPmEibRZe4UNYPCVXYvFtjWQU9OwSO/Plu7aAOgr7hQYhQpQmsj74Hqp?=
 =?us-ascii?Q?CirkeXNyXdQF3uDKyEt64KYWcJWQGZ4WgpPtkWrUglDQsfdEhnPDlr+WcAwp?=
 =?us-ascii?Q?BaNbOWWYfk9M4inP6y5K5vM33d9f/5We9k/kS72Sf+AH58/oqecvxICekRBX?=
 =?us-ascii?Q?n6cKmTIJhdbaKj/kcFS6NwyzIWkOQsB6Mbw8Ckwk3RWpZp/wrbwxi39CqTl+?=
 =?us-ascii?Q?pj96Ek2VaLNG7aeqBCAnQz8oYNLCeQTGuMC9axsW1BRiYSflQvOCt+uq0VGB?=
 =?us-ascii?Q?/ApyjMmonhAPvLskNckIsawoYTD4ROv44tTUBDVu+LiMzZnT35TKM4iX1C8i?=
 =?us-ascii?Q?UpH2zHlzba9NPmGgpdpEtTNNJa4ppETI45n8ueo4tNY2b7YIL4IBzL/RSfkL?=
 =?us-ascii?Q?9TaoO0qwYeY3Ajl9w8fSyznNlzOyspl8EbgsKQ7nXC7Lz7jHHPVxkVRxEHpZ?=
 =?us-ascii?Q?vDme5JBTan0F/EEe+gBGJZO8S6oKIeW99pw5PwAD2SCxgw1z8r6Yjf6XUM26?=
 =?us-ascii?Q?stKcypMhh3H8yDOVuxCvXKxMLu9jbFYx6iQyr2GXyJZ8D5ROUY39SYKHMiqM?=
 =?us-ascii?Q?vppmsZCjAfUg4tst2psTa/+gDHvruXUcbDMGIDhUjsqEGOs89bThcxxiL1pE?=
 =?us-ascii?Q?oU9oGUM0jiYsQ/jhgiEGn66LeDfuar0G9SunTRZyfl5RcSiwpxIbrzWyf9f7?=
 =?us-ascii?Q?4qgBoIV7efFOOBmy1Z+0KtdB7av2MHNobLAEVOJDnhEACJQhcGHy1McOPjN/?=
 =?us-ascii?Q?2ZMnpLUOe5XzGs0odA9cU4qyampEpRixQqbrbzqozwFID4QVkpBop93K1+9d?=
 =?us-ascii?Q?3ChZNvVIxjWWmiYsMgToYTCOwEG+5qYeEqhLZw8pE/hh5j7pP6x8I6hqxvXi?=
 =?us-ascii?Q?za8MwFWkU68m4NgqhKmX4V/YaMc3sae2kDDbG1ln95mf/4s3t8GmZ8+tXniM?=
 =?us-ascii?Q?eSKUf4KYA3K5f0Ej8yfFRccu6vz8o+OaK5DZpUHcSshTGhjUYVOpKyRCkijV?=
 =?us-ascii?Q?U0YvOaYyj9u54qQKcoaBoKNFpR+jJhPpsL2XdLRopcOTfCXOZm3dijcRSzaQ?=
 =?us-ascii?Q?vpY2LrCyAgbq+ryZn07Jzsp7niR8OwnLRqTB7zJJsL/5+iPAH+fur3yraLp4?=
 =?us-ascii?Q?k4snLspVSfpTSTomwnv5gn1X0NIAWZkvlY6o8ANCMiVm60IOVONq+TEYv3tk?=
 =?us-ascii?Q?IdaAu2YFSmdO1V1odV5AayPQJ9ufXWGIRsdXG8QYv8oxvQvzjAKkp00O7ata?=
 =?us-ascii?Q?hiYGjUXXRlwYgmC1T7tZ4l4hrGGWSeqgO9s8FAbF2IdypBPntK1JdIUbnwrX?=
 =?us-ascii?Q?ia4Mv/vTEeXMgP7paE664vro0lq7ORfaXPvoDS76WcSZ8b2VyogTdCJxIGan?=
 =?us-ascii?Q?ZWNlSG4YyoOmruxcOeMh33NWMQCuOBVzWqcErqBMftUvxYXfRrnvpkvpGkna?=
 =?us-ascii?Q?skSHt/3KPWLsBm4WKAglG5Bqbx4GXMn1X3vX6mWcvDDZtglRPOG5K/5jxZnj?=
 =?us-ascii?Q?YlI5wb8zfBxSE945v/3Yhb+lKXliDy/UP7FslOjmkVN0577sMOjxleNoZnq7?=
 =?us-ascii?Q?XX9ZKMJamJWIbMZW8/lLMTw+6BeAslbKy2vxVQ7t?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 512efcdb-cf89-47f5-0a0c-08dd80dc9294
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 13:58:19.9072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfAxLiVMc3/yQUhvWLteW6QlovwEfNWyFi4faVInulOpJWgtjHekZSpyanBPvkeQpw8pfoKAFLSYS45zN2LBhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5349

> Add caps UFSHCD_CAP_MCQ_EN(default enable), then host driver to=0D
> control the on/off of MCQ; Sometimes, we don't want to enable=0D
> MCQ and want to disable it through the host driver, for example,=0D
> ufs-qcom.c .=0D
=0D
Hi Bart sir,=0D
=0D
Sorry to disturb you!=0D
Some phones use the qcom SM7750 platform, but I don't want to use MCQ; curr=
ently, to turn it off, I have to break GKI, so I want to add a way to contr=
ol MCQ on/off, so that I can turn it off in ufs-qcom.c=0D
=0D
Thanks=0D
Huan=
