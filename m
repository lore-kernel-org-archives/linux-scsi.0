Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF7D48489A;
	Thu, 17 Sep 2026 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660034; cv=fail; b=Bvm8ZSAeiBMunD1KGaa0Vf8F9w9y9bpu4UnpZsbSgI/Ytg4XrTS/jusNo6IE1EEZPfEsohGk8rdAOh/f+l6e/D/aFoPGAvYPKm/TOfeOeeESIyl1KuoykSq8kTe9idNpcrswx0TaLUX9J/akG2+Vprc9GSKs10YWzYWsBkvVcro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660034; c=relaxed/simple;
	bh=AuAKqdtCtlceDbVGlieWOyIur4CzN9vLo590H1c8w3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WkG+pFWevbVW6OXRfiXpzbghkXQQdO7VXwUtczwfgZZWQLuqVliYKfyOjQmtKtmnnf7TaCL6zGbtw3IS+eTGEmhvfjnTKhsXH1lOMwj1zOMC3Z7ZxgyC1hBR9HX2gD46pL9g+N0jSfMN6bS2PQYAdjEQ4p9FafIpsv03kzWcXC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=fttoSdk6; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="fttoSdk6"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68HDe2YH3744487;
	Thu, 17 Sep 2026 15:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=HRZLsg5K3Lo1PKM0f+T8R7JvXdOZr93lSJ8tW5SDpdc=; b=
	fttoSdk6Yd7819QGRV11SpjM4BsvZvj6WLwI9rshOiMHjN2wl0osEJdzHcSDhjgD
	va72YaSmZFPvaGWX9ok7faemWdlFDbcsU8ird0NQZmn3q+wWMJ5T4optIjKuIvAy
	dfXM6xCUZzFD4WjOItfyQi6yQ0h5pyYhil3/RC6PJyCKAksTTU8B0PqaIYI5lm0U
	PkV0A7upIxMlDuV5bMN1EMlPVjlIXncpLgTCQPdh6KGoL8rCMTrcxmxULFPSvGJu
	EkQdzwa+PmI1O/zRpgeBJgTZeElZdbQFBXsYPGuTwbjEqVVU7Sza+e3RvurYgeBo
	FhFyUadh4sNiRw6uUnRoBg==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020111.outbound.protection.outlook.com [52.101.61.111])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4gqvxdtnmf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 15:46:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yW+PM7OiH+ICEjnomBBy2RPq6qU+LYJNR/IMyDCHq5msYc0Pr8bIfIJi60hUlKvx6cE8M4nRQ6nRD0o6XWuevuNRtQuzCYBvDRnavJrs+RbhsmHvf6V/Oq+a7xHJezZDomfADUQeFf6vmYXQdhNKrH09jQlqS7FWtGsqsLlII5bSeuVaFHGao3F/mR/GmU0LbjsvUeb77XdABeaBqZEMDk8j/kbQ/Bvmgrs46EmPy1ovtv+3LgSzUyOB5Cv+h+ZJfIaYAEUvoDNQJ2oimZKCRGEAO6IvoSXDjB2qsYmQS2VcbH0Td8MeU1vcSQSOQJdr298wdWD8GSb6U7INYmww9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRZLsg5K3Lo1PKM0f+T8R7JvXdOZr93lSJ8tW5SDpdc=;
 b=gX7s00gSMvdWtVufaM2M240EU91lpwS1ZJcxmrhBIJ684Ib6gt1xn5dJxs7n8Ykhiz5FsGijl9INGPMzQMHzUQ0B2qamgNQsJZ0b7kpqkmGOirXGuxJiFN/rw9JdniXyAJ3R+n4WOyr0MtW+C82VxFTrmWLNwL86xr+OuPEMkmQiNn5K64d9PvmPy8rq+fYeh3uQrrOCKgol9l1dWIGuj6P8gShrVj2cXh+ouSNnRiLYazbxVbdnGWfUqf+PZLcIpEbXYAETBZVtS2x4F4+z9UmPvpEMShnK0o18BDI+DWL8TTQw7nZPHvRUQcI7WSkVWfOjgGJARbRJzJCxGFulfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by DM3PPF777B3455C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f2f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 15:45:28 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%3]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 15:45:27 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: atomlin@atomlin.com
Cc: axboe@kernel.dk, tglx@kernel.org, mkp@kernel.org, frederic@kernel.org,
        bigeasy@linutronix.de, corbet@lwn.net, vincent.guittot@linaro.org,
        mingo@redhat.com, peterz@infradead.org, marco.crivellari@suse.com,
        neelx@suse.com, linux-doc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Date: Thu, 17 Sep 2026 18:44:51 +0300
Message-ID: <20260917154455.386769-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0052.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::15)
 To SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|DM3PPF777B3455C:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c28a848-6757-45e1-703e-08df14d2b211
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|52116014|1800799024|7416014|10067099003|6133799003|11063799006|22082099003|18002099003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	u+LPZk5fHf6Z/vwcAv9aRT1sTRARNQ8xCw4hIv79Y4taLtxeHOZ95rZ7Y8TSbRlcmj8gIAZcQEvoHW7RhqBdJ9w61mq1W4rzkJWRIgefCFmLL/ddFylcDh2WKiR72AQpQDuuasLc7R/B/l7Keztywye+Pih9V9YIejaIKI9t36LVm9oQE4D2A5vJhusPC2hN1zFdAgTQrTqoyX5f44m7ihdwwIpTto67vCA4aqBiCq0IcXZB0SncuJ5HaUm45WVFVBSeolvbAbWMI2brb1zoqH0tTgtvE1RQpHYGupmJvt2E+1pZm/Eh55sr4h2EeJgjrsk7rDo04rc0H2AYwRloe9EsERCJUco+9bl6U8qR0srlcu/LvCGA7rGHvnQtLWLIa8ev0/zwm09RyV4Y7RFLBmUo+wpxkWEjCyWyyCZQS8a+B5nRP7MGCu6scEXANy/Dv2fJF1khzwlkj6h8kgRXDUGF9oMnz/iqkVj95rT+NCQ3F0mJ5kbJrdCkkZjw3CUlZSgmj3vVPI8AuCJEqZeeiMLdevgvpacHvzLCr4t6O87wEITh3vnjTfiSNpGYijdWPhQCTnlvZ8qmt0GhT1Vy4p3KA5p4mVnmdgfK2xYf3VLyRI7fvEMktplNtKUzKi1IULTTxXHXhz1vMikTqMDy8+nP8mWWu7sST2hlMFDemxY0f1spg4Thj7ZDRG/P0CpGezhkKnfbavJhOC7qV7U2XO7vcrIVJuYd1h53cBE6/YM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(52116014)(1800799024)(7416014)(10067099003)(6133799003)(11063799006)(22082099003)(18002099003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cWgflZZxotQACx8Jploq4ZCMEUil60fadIWbLdsGRNjOAcvL+gNYcg/Gwx7U?=
 =?us-ascii?Q?Ej6DC7K95m4VEAuXyaaO/0YsJmmvloj2QQAGDHTIy11g9WNcICuz8tNS088r?=
 =?us-ascii?Q?vEe7BJpPwuFGD07LUjB4JKpz4/PY9nsCfAED17x/burcbc6UJqhISqMwxK7b?=
 =?us-ascii?Q?Mj1uBqS6a4z7s/y9RXAtktgdaocD7cLnSJ27MJ588O7l/Jsl83+BX4/EUwlc?=
 =?us-ascii?Q?NoB/Q88mQqvPuqo1mei8n6QNYYU+lbDMpLarK9mp7RHH0LRbhz4DJL/BIT58?=
 =?us-ascii?Q?w592rI3Wik8ZlX6JZEbXonDi4lHOiWrnt3dqS3RU6On95wLuIOK/9IVtUAmz?=
 =?us-ascii?Q?f9JNQGWXPoSsK4YjeKKtxUda9xAJgl/sFu3PdKJw+d+jc8UiJ8hdH1p/JCYA?=
 =?us-ascii?Q?6MWzc9yjgZZbNJg3dPJZpt/I6J6TJoAtXvjJyyptU/CABtITVErXvPYCitmG?=
 =?us-ascii?Q?+wOxGiB9VwT2urNzHbtqrx7x7OG4s9qHk6gFCpHPsCoRpTuAODixCzVWtcCF?=
 =?us-ascii?Q?Gurt+gcrE1CKDHTGmcrAP1ZUU3G0c+2H6oi1EhAO1tGafWZYOR5o8z6OpqoI?=
 =?us-ascii?Q?d0MXAR6fLToF53zEIBAqrvgXMDWg8gAyI2ASpIvhHvJiU9ecCtRAEbHq6f7W?=
 =?us-ascii?Q?ZFltwo3S62G4xIusjUWTUoumZc59gQGm9csNq8LOzbQ8OhVczCivrm+pRmkz?=
 =?us-ascii?Q?kF9ckXTTEfyy6QCAcAvPV5aS0LotCOEFZrKrhe3tVG6Dd4CM6LHfgbwXPCsF?=
 =?us-ascii?Q?MxpIhgrfvBhfLPbORk8wwA6qJzS39XZ2YnqimLBtjd2CjN0kd0SGoXhuYdcZ?=
 =?us-ascii?Q?3cYxUcERz14De0zJd8XTEscxVW7IKMYNHvuAeKkNEQu2fRRd4HmJKXDywxl3?=
 =?us-ascii?Q?ZPkX680Gc4CSFUDFugBC1w5cQ3g6HSYooGmNTt2UatffHI8oN2Mc50/2dppU?=
 =?us-ascii?Q?y6Y2+qV1Ruh3znhv2AIVzsldP7gBTxFFNPK62lytl0Qf3kG2hhNvAg4jVtZ/?=
 =?us-ascii?Q?qerxGfg0xgzPVWksNzlsBruoygbAeqo7HrhCK1bg9v7RXVhXlZMfUYT9bHuX?=
 =?us-ascii?Q?hV8Ty1l4W4QqBZpIJ3N6a0QNN1DImO5+QskWKRjkeIar1RhUgF5YsPiWx3m/?=
 =?us-ascii?Q?0ap0u6pzt+IA6TqDPBAvi5wFP1kbtE2TPmvP9tHT2xhiMpDlcekDKC8Rcdvb?=
 =?us-ascii?Q?IUQ+Q5ZqHbvY+X9eYM3YOxrJB2g+Tt6xSTop4y8k5yqg2lmg+vdc0H5z7j69?=
 =?us-ascii?Q?mrqxOUrUdickoK3sO4YzG8n1RZLCj82DunEDbOZQeiBJRJChFhgvkKe0zAq+?=
 =?us-ascii?Q?nIxbfMcMS/g8yWCe138Tj//HlkG42kfhQLaF+NbEmb0+Qsf4iTdjNt/iHuko?=
 =?us-ascii?Q?RB8wjVe+HM5mJC/SEvoyroXlvx40NP2NJh5GIE/GpH4S457gE0kx2T/YMstb?=
 =?us-ascii?Q?Rs9ejACKx5fRwaC+qabVxDFohiVlST00V6za6Q9NWs0HsNpbxnP2nDVO5LhX?=
 =?us-ascii?Q?wu6pZOWMI1rrJCeyRlB/M9jFfZ9wZHzqUhlJCr2k+mmQmrevpFUY/IfQ1Yr2?=
 =?us-ascii?Q?zyC7L9cxqBEPgm1d0zj5VFC3sEPByuO7TluSErGwZokoNN3kA3DDwh4T+4Yx?=
 =?us-ascii?Q?REy4/c3bbhYZuK9rEt3vLHjLivD1N3dSC64pBRO9Qk1YLbWnVZVMMaLt6i0V?=
 =?us-ascii?Q?bbOt3dX4SkRG+WjT+wwAa8hwpvj4rs5uEg2a5DyGUZsoDWjkFnBZmlV+J31J?=
 =?us-ascii?Q?iJtLX94ghxusZihbmofmCkbHsmR6L9U=3D?=
X-Exchange-RoutingPolicyChecked:
	Ig1j7rnuEaroKJFAXHQ3r503vFaeVJwtKyN2xkB3NQGiN+x9Lbslo7NZ6YmlHI3DWPmsNCWc1xciVZ07A3qOno/2R+0hCrQYH44RBTHoUAb1KxBuKhDv+toXWiUFO/pU3v+hM4U47U7bQUBorPWFuTbMx62kphT5nKzVkA+B2D3qPtCqR8QKmOZ4GR3bzTAgvkQzJKTlHj40sDqvYjaHna/5ggfXyGvwnxrD8wS2gl2DQDFVzyEiw1ZZnM06+edllqeyZkea9s2KBH5ylSXqWGt2wG/XJVcbPCAXNI/RJnXsklD4MRkt1Ki0XMMdWxUpPNF5/ylULN2XbHmp6Nco6g==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c28a848-6757-45e1-703e-08df14d2b211
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 15:45:27.7997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWaiMH2FI6JZ8XMgaOqMUzcoKRcXG3fgLqJswB5ukY6XQ+XB7pzobsxykgidZco6Fe1rA/0os1ZcRSwXGpxQ6nj47CVgf2+o01Stf0WOajw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF777B3455C
X-Authority-Analysis: v=2.4 cv=OPayTiaB c=1 sm=1 tr=0 ts=6aac0b42 cx=c_pps
 a=GSDfjOocp3kRe1wCCJtFmg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22 a=OvQFxdf2BpoGyvGMKAIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDIyMyBTYWx0ZWRfXxWzmT1ZrmjjP
 a52AP9OtMyepv2cAs4DhYZTjNYCHZtkgkPELY8tQyeHKv+0u7vgkP/4Hdx4AKjvucU6KgRfxNDV
 ElF0NQsPmwIaDGpFC254FK0RywOBfvLgGRTvle7I8PzcJnbRHbDR
X-Proofpoint-ORIG-GUID: nNHsks0iwFSUZkpf3rZsrPEXb27wmHkk
X-Proofpoint-GUID: nNHsks0iwFSUZkpf3rZsrPEXb27wmHkk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDIyMyBTYWx0ZWRfX+nQIQgK/HuxU
 Dc3U+vIfq3l1IUFooIzsDakcaFAAQW5noywDroSfSn2qx9bV29Fn/H18PqL8AknrsusYQgWHuvs
 0Xhk/IZ1WEdWDS5vgD+9r3iQlc4z3uHNdvoX7nTtQ4cs+rTZnyUjlpM+7QFdwhZv8EZPShWRkta
 dFp/HfvNc7AA9NKdfu+pKv6xAAmqikHPPJfjg/c1s3QAjaR0m/HCsWDdXfrAaVT0mDBk+Js71tZ
 IFqCm0bpg04wqiFF4a1qDOL7RoRa85T55Dayzp0ZUzj7TRHuSfm0LMRokdCRwK7wR0Z+T+TjpD8
 dQIPamBPzdR0MOjHxLLdB1Cis+V91LMG+EY5DJPDshA9uB884j0miXSUN3ZXqENc+hWqZN3R0Ce
 ELYf3qcdT1l51+tQBGLHe8Jw0GS/7ELWZvVb7YCTng04ILFgJioGV60qe/UGNzGc/IE98Nx681y
 uRnSFKc9hq/agkhD8+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170223

Hi Aaron, Daniel,

Thanks for respinning this and for the move to
"isolcpus=managed_irq_strict".

Just a heads-up that I have picked up v16 and am backporting it to the
6.18 LTS tree so I can exercise the new parameter on our PREEMPT_RT
configuration. The goal is to validate the end-to-end behaviour of
managed_irq_strict on multiqueue hardware (NVMe and SCSI) with isolated
cores, in particular:

  - managed IRQ affinity and the reserved pre/post vectors staying off
    the isolated set and confined to housekeeping CPUs;
  - the blk-mq hotplug guard that refuses to offline the last
    housekeeping CPU still serving an online isolated core;
  - queue/vector counts on systems where nr_vectors >= nr_cpus
    (narrow housekeeping pools, many PFs + NVMe).

I will follow up on this thread with results (effective_affinity and
blk-mq queue mapping data, plus any backport-specific findings) once
testing on 6.18 LTS is complete.

On the maintainer question (option 1 vs option 2): from a
downstream/product standpoint I favour option 1, keeping
"managed_irq_strict" as an explicit opt-in. Leaving the legacy
"managed_irq" semantics unchanged avoids a silent behavioural change
for existing deployments, while the strict variant gives new users a
clear, predictable knob.

Thanks for driving this forward.

Ionut
