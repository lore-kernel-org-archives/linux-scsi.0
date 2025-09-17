Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A92830E0C2;
	Wed, 17 Sep 2025 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758147241; cv=fail; b=Xt+lFZgU8kuyY8fyk46oC+vt1NgGWVklKRtxe4RzQPFelij2z1JLmpfDfVP+DJc8Lk7GMcC63oDDforxbknj9t4Ur1xAOCA4tYl8hoanTs327ChYjZABz0hl/isj0EVKspoCwiGhK4HLKZwvx0vQcSHH2eY19jZAknRB5/K6nDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758147241; c=relaxed/simple;
	bh=Ran45c7btJ4LrKrkLWH7661+NhkNwDK+CYvZ7sQSmsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XVtKZRbRPqzJsX2Ibs2+tyA+mePfI0kk6B9OUM3UjNaTFaPP60u8gV8odVL/7ccPNBpomYoZgsHlJBZG3+hD3QVU3B2QdrSoaLl8QQakk0v7wDbp976u7y/Ly3f7hO8fzVH/7vr6kNFeCilGKIMm5QooCFxvPCTptbICtMDsimk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GtIzpswM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vgQyLZot; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GtIzpswM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vgQyLZot"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIRs2001799;
	Wed, 17 Sep 2025 22:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MaQ//hIu3jw24uthCZJWiJCm7NAwgtpWe5BnfcJ9r3I=; b=
	GtIzpswMazctOXimj6IBueatbYE6Npl6uhZVQtiIbjHtYyuUh9QW2E2VkKQCUH4s
	9GQ+lZadrFnqiwWOav2XfKDBmxNW9NPA/P4b6R1Nf/wY4WxcfsX+03gnmN/gSnZB
	TQhz5NikLoMe75uG5XnuZyBK1iTMzWJYZbD3gh6PqXDcxxAe67yDUIU5Lldl1RQD
	70MMkQGv73vcYg5uTGR4s1YoC0bATEyAn+wLKfPy5rzJrLPxyVIC9pBc0IYdzMVn
	OaZI1iBYVtBsYBR7WktXCm1yybEMvpa04hm5lFVi/bAc7NYHNH+dSppZBnO0Nf+g
	yiGmY0XE+IEXBWAJSpkVZQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxd29fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HJocRZ028809;
	Wed, 17 Sep 2025 22:13:45 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2eaq33-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3k9iz8pp1vM6XIpRKZizwG2yvENVQaRmhshRL47eZ4nlNkXHbPzRDPR+ehMEpJv6NvWrvJHymBKgu3fpaqpFMZcuSbOkCpfVbcNhive9EdoqvrxR+YWijXUsC6UD4jIIJPuJUEgLeGg+65wQ1St0v+fG3HH4DRN70wVdU9bY7lDDF6AL4W9aGvucxIJjzFB0RgrzUQM501w7GEfkN67z+MRpwc8kzBBjRe7jgz5j/aIyJ1d+igudZFyRSE49Nxop65V6V+0Tzo7zRu9xDUlACVRUqbUGeGZZvbzw4QryWuxlT/JWRv/MPnvawXUSPdZ0OESJO0k4sRTV0qh7bHtfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MaQ//hIu3jw24uthCZJWiJCm7NAwgtpWe5BnfcJ9r3I=;
 b=QHJnery3D/iNbjk9mGqIGHqMmgXoiONDnHmlFFimqCcd/+OuzlumD1iT+IwHrhmJzIoQnPVrWyjDSfmwlF1VIekdQNljZ8D8bdtoe8FjuwWlF+YdLD8d4PeK4nSUflqJ1rn8qllcAujw5NVs998REggxEPOdkLvfVIVyT+0+i0zOAdB+rGYmZFxLX7gTKCSV8V6pmUvSEF3tmw71AYLP57L+6IxAa89/xPFtVJJ+Jr3Zwe+h3Cd4ULTO3mQfacgZa1TlDMJeavK0WIEh30Wb5cNaeEsiFmGdmbgfYDKztF2xGpWNarRsb5NR82sXrAEnIR1yw+BKhGno8P0x8I2CtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaQ//hIu3jw24uthCZJWiJCm7NAwgtpWe5BnfcJ9r3I=;
 b=vgQyLZotrsv4yHqYHF8XahiGkhySED9kulGSFcOaVMYeQPOupjnWGCMNn35GcQYbeNKzZ33m6cUt2jr75aqDWmz8sPqVZGaHKQCVhtzcFbRuHNnC/3h0mD3k0qcGo1WnudWTOYwWJEnEM5623VjtnGzH8jUSbbDD3bqblzvinYk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7564.namprd10.prod.outlook.com (2603:10b6:610:17d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Wed, 17 Sep
 2025 22:13:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 22:13:42 +0000
From: Mike Christie <michael.christie@oracle.com>
To: mlombard@redhat.com, martin.petersen@oracle.com, d.bogdanov@yadro.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 1/3] scsi: target: Fix lun/device R/W and total command stats
Date: Wed, 17 Sep 2025 17:12:53 -0500
Message-ID: <20250917221338.14813-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250917221338.14813-1-michael.christie@oracle.com>
References: <20250917221338.14813-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR18CA0018.namprd18.prod.outlook.com
 (2603:10b6:5:15b::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: a2cc35c5-1453-48c8-d900-08ddf6377627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K8IE83Hc47Lf703q/xpxHXju8GVmpbql+XpvOblvH4QIkX2sRcL6+JqGbtPx?=
 =?us-ascii?Q?houwLr9ZaPceJDYBisx1ta6qTcILsRM6a3GjXomMDtUdWhzyQTiqGXHWgR4u?=
 =?us-ascii?Q?dnK8P6a4KUOPJYOLtSDTGI8cgsqjQXilYbPIFnhISw8EOuy3H9RUWcWo61jS?=
 =?us-ascii?Q?ptoXKOI/ZVXGM+cqBmmFJ1pMMPhU0N1/oLI0jNPy2FIq6DhoYVRfhLhKdaHT?=
 =?us-ascii?Q?PYjjAdP0AL5IXZ0Z+wh201Vm2ak66iLL3bYr7RonWjJq4OF/KBG1J7seRqWX?=
 =?us-ascii?Q?1H+ql7eBluG/BMGueaqaC4KFDNtSJE7dvrqd5SmQYFOP7LoJmz8vorCdF1hH?=
 =?us-ascii?Q?22IRqpZwV5fskUaJBoGOepHsY4/VHcxk4RlKgnGkDsSvmN8L3577ErooeeNf?=
 =?us-ascii?Q?AW9egkv6ZNi9n1Ul6sTSzHzPfA9vBt7+r+VWqwazPar2VlVtXGLTaMqZyZSo?=
 =?us-ascii?Q?jtofhGSmVpdQcNIkkZUkbZmKxvxFVS+tHPCrzpOQWVKHxuBdQU/9WMsvCFrc?=
 =?us-ascii?Q?8cyx23KTyPlNur1s2XuCNGV/m217kuL3UHqRgObmcOENehc+CTchcd9psN/7?=
 =?us-ascii?Q?NicYvYbBxDQlz9zDRkPxvycCWWtHziq3SnMJnl/qcORmQL5AchWWE7ufwFqS?=
 =?us-ascii?Q?XP7qhYady8KtCKuYf4cWMmntFD4wpUFPnzHpGgTjQbkaxsXrvygHr8+Ehj/t?=
 =?us-ascii?Q?k6mSZxzUW1BhZkblNUxHPeGnA4BwxKCaj8Tg9/owQM5yqXaJm/23Gblo+PKm?=
 =?us-ascii?Q?mpdZ0CuJRXC++VoM3oPGb/Cws6Uq+FvSznIyPQuFugeBNAfVNjBjCOnaIXge?=
 =?us-ascii?Q?702hUbqCNPr6DAmQrEMD8Zwqafg2999ulHK8fWj9OCC1Xeq6/aMdr/XN9A0O?=
 =?us-ascii?Q?7v3dqiA2l9iOqj6RcxxcGhGzmcbD6r1+oymTMFahfTyQn8h3ibG+6whHLABI?=
 =?us-ascii?Q?3WEQ3TDtq70R2MDjKvN50HF7RcIyn65IXXebxDHqJC3yoZFLwGFZOp0BiRIh?=
 =?us-ascii?Q?k3aUr5qfR9n2OG4X4R9PXCQ3YEX0+nQBeEPbz964z5VjqaD3P3Zm15NZgrUv?=
 =?us-ascii?Q?PggoszvPDR1kdzibY6Mq/6cDOro6n0gE8YZ6322+NYj0S+Nf0KSYncDRqZsF?=
 =?us-ascii?Q?Wa9bcWkWxlcPDWhNq6MycE6YSdWt9vfgj8iovwVweeYuo6SkIVShflax0GDk?=
 =?us-ascii?Q?kN7K+jQv0Bd9qZiZ2SqA28C58ruFA8cbhJZY8eUzGUBBpiJ34r3MUjSTkEEr?=
 =?us-ascii?Q?BzaufzDSdj9/gwm1hzwKgOaLBoRXmbsr4fF5UFtiMZ2xpvkz1bMiYDRNOBpW?=
 =?us-ascii?Q?rXU0d+uB120IpJKwenXAkrTkMbDUNN/3yzK9RZZZ4LVtvwCh5oMYHA1a1aNP?=
 =?us-ascii?Q?s6NegHI5j2gCyWSnk389gHrhJQCMULc/I+xWoOlVlBbh6ZAb0VrYAHUx38os?=
 =?us-ascii?Q?rIvllcS5kr4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qkuoKNBdYU1Kb73mRL7XrLbG3pWf8dPsylz26Nu/jQYwD6vp+/k2M8TwVRlw?=
 =?us-ascii?Q?LJtWa2Pddko+KjF9jzkT3U8kMO45SEdllM4bGWEruYf5Xm1P8ZvFizMyGjg0?=
 =?us-ascii?Q?0QRuXthl6SL2f+kTRXBftmb6w8EcwUQZ0JO3Q1k61jzeyCXkZpea8iMgjkve?=
 =?us-ascii?Q?cIO1AZzYOUB7DgOtX2jG2evHtNp5srLs2tYQ2sXe5pseYID7X57D/VVbvqq/?=
 =?us-ascii?Q?BqGU36INhvQ2VuyX5y7Y3aToZR8TtM+9Hicva1X8v0P6+nOXoj2ZFR7qwN8J?=
 =?us-ascii?Q?y8+qn196F8vk1XTg1VO3SvfrDqhZ+ilcGW4XrmYv3LuE5ru9Ynaah3zqKcbL?=
 =?us-ascii?Q?KJtHE9dmBGprbGsziyNRCAn737FlBEbbdBkvoV8ohJCkAJBWcRXr7JDy71YF?=
 =?us-ascii?Q?i1pZ4qE5n7P+ktWaGd5APLOJDfQjBkF1k4Lqezv7P2tjwGDK66fx87DThcZR?=
 =?us-ascii?Q?RI5Gv+8s6UtvTxhMA479TGAhnzRZqi+iObzIGKlsNUQQkx4jr4ycsSZaEmUN?=
 =?us-ascii?Q?PMaLPYxa+T4ckFy24Adk9IOh1QHUv5YnFfTKsIia2FYLPWM+i0iyXuAGwo/9?=
 =?us-ascii?Q?iDhhRvzm0FBy4xP7GKHTcdtNJnPHks08LuxSDE77xdjTfLUL8tjvsKdyGVIx?=
 =?us-ascii?Q?OJ/6nhJHzTlrLmSEj4C92wAWpavhZPJe+yh/2e0fT8Y+kFScNQRlSkPKj8c2?=
 =?us-ascii?Q?C6+Dmd4wD0C6kaHaN8nX+GRMw+n56dHeJ6LURRes9IOcICCd60jz29XMzn1N?=
 =?us-ascii?Q?xXGO1agM4FN2/aXRoxIqan6H7tB1XL45uRYTl16SUV8j7REUHDrdehyzi7B6?=
 =?us-ascii?Q?FOuVpgfln7IIkQJSVxOG2lXMOlmH1IQOoxBMvpu0xTWrjbDYe48bScqsJ1n6?=
 =?us-ascii?Q?42MQ3GKNHxiGdPGLhnrozKBHOJMfOPuJZkdtHtF+TUX8EpCVDSvF7Ksg0a3S?=
 =?us-ascii?Q?+/0SZVVb4j4Bv+Mzsit0UVbWjzk3LKeq4ojKGJM71Qs5jeMkHNIs+qg92PKr?=
 =?us-ascii?Q?fHJProQ8DWgQyBjotgcHbMhh16XLhhn6mtfHHYmGH57SjOalMrt5uUvCshnL?=
 =?us-ascii?Q?GtW8VnXi0ngrUCWJgqf36X/GLOOmmalmCKAtOF/aqLz0EaVENe72UE1Bb8uQ?=
 =?us-ascii?Q?C8c6QoN7hT7ZQlddF3XmdmAJGI6SWan4mUf31gm4qVM+ddqFA+OQ/k6C26Bw?=
 =?us-ascii?Q?gfwXe6NEUM0H2ktrsuP4/q+ujHJlrupwP/F7RmbLJvW5mCbMHUq/3sgkBFWU?=
 =?us-ascii?Q?iQk6gtGNmBj8Lku3u+ByqnsFEbBITK9nlnO17ME7ZExOQhx+T28eXNnBMwnu?=
 =?us-ascii?Q?NZljbD7/+3fpt7SKvxOCxG0f8/s49dqo3CfZEyxcZ34/Zj6LQjbszQl4uH0H?=
 =?us-ascii?Q?kE5TT4NprTCZdEjq202ytKJ/Kmr5tE2Bsu04R5bZ0XWbZ1tAXGfGgC7gj1hE?=
 =?us-ascii?Q?19SriMtyxRFUqi9WbnvD30CHqFLroIxjiiGNd9vY7Xon9SHLLRO2nC2qabMS?=
 =?us-ascii?Q?R1kj1FAUlaaJHB1W08KWDNS1GkeyV5EVc6kOPKrJv8pQCCxj4vJHQQha1jJd?=
 =?us-ascii?Q?Pk7GgM3f0+jOq1n7Y3y7LS64UVn+ue8BZFXGZH/qPQC5Nyr0Ko2/xtfPFpxw?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EgwPyj05IyWpNTlQeoo2XFty1LM6Dr6B8d23H7BZnCRFiOmdtW2zJq2AQS8M2Kv47DMR2LBAP7ALhqAO+wzg9C+WnR096H8eZ2LH6mtvKqugue1FidctMpKWT7/+NePp3XKZcE2x77/D9jZovAJT4iDP8Fcg9fH++mCGFzKH1FECC4bbKatzg0PqRhr4SSCCilbpff8WL4rLXRXR/piX6Sutve07UdF9IkU6DhCFtTAx1mLczKSVuDrPg2LMmzqci1KOObgoJA7HtTAZ2zcDPordFZ89Vf4/cej1yWN/AIm7SUigiA7qf2om5dYfkjnaIlbbW7kiyHdUnZtkoIHCP7js0BczV2rPB1SskD7M/JxUqB+icqsNQOrd1pKFIYGcMHS0ZhY5HVCTYPAU54DpnNOV9aNKZ5XqO8sQn6hRYf52tuza+kaiurRI1hFd3WnalYhe8ZRu5obUMhWiOcBMUsleNjkHeEz76/Y1Zt3T6vQbaT9GJ8pamrseEIR58+ZnGwPF0Ya1KTgWB4CKflQ4u7HSKJsnFQRbpk9qfv7eLnZM6WIBVb7VyoL0U2RmhrTEGV4K+xO+beuqIsza6q69aYC3pFV3resHfPf2HC6wxQo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cc35c5-1453-48c8-d900-08ddf6377627
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 22:13:42.3979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcTzMtWIFXoikXw8QldywiVbSIU/P5ZzSq38CpAVf6XXMLLAYMS0PVhxrNA9A5qFvtfDlMqf3BvhMV1iPg5frLZZcwIwME2wNcRfCG2zElM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170215
X-Proofpoint-GUID: 3oYyhiTotH7DO_m-e4jxIl4WUGNAruFD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX8d/pP3aFavF4
 bCYoCwtt8XNo9Y3ac2u/hKZ95yPlJyAB798gnhWxNl0uRI0XJt1vJ/Ok/RNBi2q8sXLHBh+mZct
 JTh0n9gacpezjmhBJjidDNRMEa6L4FGGdllNZcYSiE1o1rXI2J8gkvAK4gKEYhHREfclC5sLWN5
 ApLShBj+29pNiXYZ7PzAru7BcGSmFW9fu8Du0U9V/oJypOuoRrbVNakUgmxX6BAqq47gpdrDQXR
 hzftfxupPa4fs8OkUJOBFsXPyo2Fxo0YdohUUAHj22p7codme1Qshdk1QtKDU7EtwENpBY7Lo/+
 rQDGIWWseZHFXQKv2sZxHwcIH/3Trpt1ze1lZm0s3iJ9iEDCRQ2QMNaoheJF6Lw7TNZ1aIWWQGW
 HVpfPk5o
X-Authority-Analysis: v=2.4 cv=cerSrmDM c=1 sm=1 tr=0 ts=68cb329b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=-c9VzbpeAAAA:8 a=3cnjVR_UEJ30e8tU16oA:9
 a=WAq88MDkwfy8HpmZFCM0:22
X-Proofpoint-ORIG-GUID: 3oYyhiTotH7DO_m-e4jxIl4WUGNAruFD

In

commit 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")

I saw we sometimes use %u and also misread the spec. As a result I
thought all the stats were supposed to be 32 bit only. However, for
the majority of cases we support currently, the spec specifies u64 bit
stats. This patch converts the stats changed in the commit above to
u64.

Fixes: 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_stat.c | 24 ++++++++++++------------
 include/target/target_core_base.h | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 6bdf2d8bd694..4fdc307ea38b 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -282,7 +282,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -290,7 +290,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	return snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 }
 
 static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
@@ -299,7 +299,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -307,7 +307,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
@@ -316,7 +316,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -324,7 +324,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
@@ -1044,7 +1044,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1059,7 +1059,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1073,7 +1073,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1088,7 +1088,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1102,7 +1102,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1117,7 +1117,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4d9116904aa..27e1f9d5f0c6 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -671,9 +671,9 @@ struct se_lun_acl {
 };
 
 struct se_dev_entry_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_dev_entry {
@@ -806,9 +806,9 @@ struct se_device_queue {
 };
 
 struct se_dev_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_device {
-- 
2.47.1

