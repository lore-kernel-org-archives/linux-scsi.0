Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E727F81724;
	Wed,  6 Aug 2025 01:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754445456; cv=fail; b=KnJ63nfEJBJt83ACLfF9LMDIlJ1ZGzOWAM8nVD69e/Sxp2UKC8t1Eie4ZPXhGB7SC4YbQbXm57M6dAn0qR9tFDeHereZJVXOQVGGv/wcPGnNAdV+/J1s52b10zqqV7zonOmj/coegwoBlVWWEepyzDOngHpjCLqXH4lh6Ib7I6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754445456; c=relaxed/simple;
	bh=8T9O9eWfqjGCdqX/DDvBi6YgkUAlcu2Lj5SQFKOkc9Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BOGZK2DabBaTS+2GUbT3k7754FwaaAjSbUa1mGDfSS0F/Fr4kWoEYamBSg4pBp1PCK6fZP4y+FJhriy/w9nV9XC/lgxcunAqMpMROzuBd01dq+NI66achQyLfh1blrqHAfKku3hwMVExgWOI99GEN58GGFMIHCOUv0pINSJBs2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jv1UfLcX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J90tIsH2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jv1UfLcX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J90tIsH2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761uINg028132;
	Wed, 6 Aug 2025 01:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MbTLizZJ5uUXr53Q09
	tJijYGGmShz9ZDH5opnxdXGa8=; b=Jv1UfLcXB4YLj+cxFednIldAafruYu/4SR
	NAq3P9oicTFq+Di+en+tyqD4F10G7EsegoE+5kJiRDyucznBPsBnzL+fJE/ODiYG
	dilSkVDLTnGhaVxu8tfFpF1JX5tCowLvXaOmKdKvDYGtMbKDmi0ZcwVphFLDIBZr
	PdZRXvIn5OkzS98m2L3ECuumUCBLQDcUVcYIR0IEH1wJM20SJi1CJ1QLalbutI0H
	Hp8Jhj+qyyA57xENoHoNngJdwC055dVPePmfsZC6QEpY5srSXSibBjsbBm49Gr3B
	g0Kr1qk7mbONznQEkjG//6gGKL/klr4MmZLzG1SspRP8scaPNqLg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg0kne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 01:57:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575NRCfs032053;
	Wed, 6 Aug 2025 01:57:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpw0va-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 01:57:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jrkxDXg1Rl0vGnGYBwsUgCsGWU2XZqoezIrPZyRR9HZMX0hJQ3nAjMQWhYHgD8drfeZKYorUjpgvEuKo9JeBTkhy1I6fPc6xYhqm82QqVbJBC2GcM3thWNw3gldNNCOcsdULWC8SN1hVFVtJ4SWTGuP2ex/SWVytagAVpOqdLSNy3A6ylA65EIDBjsvk3DKzc0m4DtMxBc7JeLGO5knhDMMzf1qOlkh9g80RG2hc6Y6Oalt4Sotm7t8LAThkwxAezQe9VoCk5/Sbs6hwJlkdVGRuhuV2cP1J588s/LahxJJgCdSf1c6FkCfBJ+Sfb1dl7dwrXTpgKHMJxMplsI1prQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbTLizZJ5uUXr53Q09tJijYGGmShz9ZDH5opnxdXGa8=;
 b=HQnDSayzQL418uzW8KyFHa/93RQcjSx/0yHMkwxDf7fy68i6YDFOz5Y2D6jJ4772xl4F0KQYIJ/iOXn7kJBQjLxLpXv/rpmbu75urADrymk8atHLcDwtblRMgpbR/MnCpd+lhesHfLKUrzM2qlBp7ORPIAiCcEdfknmH17l7+8KGP1GkhblVJBBv7rQuhNvQ6BrjvzPHAiWEDPfl9SHiId7HbGYnQ4WbzYYJ6gbOEsoYv2nKpOup+k95s4gVdHn6P7FfvX6huakfkRhOhGHlZUCeQBkY+H1yPYE4DPjpiljX2JRqndDmLCm8420Ky3+Zy3BCEdC4c/K+kzdTRRAmRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbTLizZJ5uUXr53Q09tJijYGGmShz9ZDH5opnxdXGa8=;
 b=J90tIsH2qTArQaaujV9UCntAtNV6CrfkBX7H2jfjdXy/+sct0DwzO6TlsUzukd5znMA+M+OgS9zN6VS27QFlmCIppuSy+LaE7L8Lk4JiN8oP23+ODmi4yNJCRMu3OrUeZRxl/tPR3nQaUxqXwZVRQjsx0LPbpkwoOBoIzkrshqA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7153.namprd10.prod.outlook.com (2603:10b6:8:eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 01:57:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 01:57:24 +0000
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: lpfc: Fix wrong function reference in a comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250731133311.52034cc4@endymion> (Jean Delvare's message of
	"Thu, 31 Jul 2025 13:33:11 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ldnxb4aq.fsf@ca-mkp.ca.oracle.com>
References: <20250731133311.52034cc4@endymion>
Date: Tue, 05 Aug 2025 21:57:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:510:323::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7153:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d4bc62-6d6d-4896-ebee-08ddd48c9655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yUxdDLQ+ABwzV1bIw61zGHCOAR/Bt2lFEGuNq4fEvomZyo/C2OHTdfv/r+91?=
 =?us-ascii?Q?9WWW4EoABFV1POV1VvA8lDSlFfDp+rgKIIL5RYk0mhGoNe5YxeYdikonnMRF?=
 =?us-ascii?Q?tr/dnRvq4BabaiT7WFbZ0zYP3vl1EiJeMJGe+S4+9CrdLHdU4PQv9FSXmSFo?=
 =?us-ascii?Q?GVEvVK3NHaLqYywA6xGLPylwfNSOnNQTqFtNfRuIAEKDR+0O7IPcQxK0nVY+?=
 =?us-ascii?Q?4AteV6ScAcINzB214fkZ3RTKVWBuzZKTkwbAm4UIi07FBaO3kRfQHKZtG9xO?=
 =?us-ascii?Q?qaM5NUtcMtcxuGd3oP9XnaCC9yMumfRjXVIt8IxjWQiBJNk1PxsfFOgcTTra?=
 =?us-ascii?Q?+nXC/VlSaVxgekk2iNHjQI3nnPyG+n6N0NoPERyEm6sdcPUi8ao0T6FqRNr+?=
 =?us-ascii?Q?l78MX2Jg+D7mFGTVfah400VihFWn9Fl8sZERuS/hBS+dKbr8bxNjbrHBXYFz?=
 =?us-ascii?Q?UpM2jXQTv1TTuelcrfZQ6nhQTwpYFQz94HbJeCYzdtL/jUg7c2mMLgbT2/n7?=
 =?us-ascii?Q?AOUaddjOQDL/a8x5d1uSkNU/yt0S70ILJBTDzVl8/g9eWZWy38d71RjPrmGV?=
 =?us-ascii?Q?RUtVNN/SlraIddZOY4m7yZf934F1vuHYU3cqAHCljHefAy7ormh9vjSskNG/?=
 =?us-ascii?Q?pX2sbZNUkWifOrmjLq3htBuoIlEwM2CphJJI/M1i3sLHrJvc9YWT44Lt/UE5?=
 =?us-ascii?Q?i8f5COoiun+4uNWwzSMGbYXW1Rhax0vNyjvHAH0VZymFDj3HTy6+TNWxVrbp?=
 =?us-ascii?Q?XO6dYqAxyFZa4t8b7yL+XUwvXWCQF2McnMEdG0T3VovbyTv8TElrr5aib4Gz?=
 =?us-ascii?Q?pBr6wTw9j3SgQGfa71Q9CxnHNSxC8Gxl6ZmYFtOOkYfZRfhD/cFDJ/s0Ypam?=
 =?us-ascii?Q?Kmph6dnVUmGiAvx70cE3ZRKd9F2RuZxAya1KMav3yWxbW2mVN55FrY+0wXXG?=
 =?us-ascii?Q?JiX40mQHy/y7bdQjTRmhhNivff4wFZV+rodPg573dXwv5Wg0xvKIm1NJpWQ8?=
 =?us-ascii?Q?JAYpyfKcNcbjoDyn9iNg7HS0C0iO2GdQi7LuOuJwClhJ4kzR8PwP6NbVn+cL?=
 =?us-ascii?Q?z7ntNiyo0nSJryFhvqrZZbI+B0eR1qS0Gs5cnU8hruhaZs7ao+eS58y0u/BH?=
 =?us-ascii?Q?4NEkGLVw82/ZB+SIG7YkK1coaQTHWaqANNRNlw8WuhWzbmDT+Mfnj6ONToy0?=
 =?us-ascii?Q?rDbYNztyw4t8fhRifu7P9u097NB+IH7AM5VBy5/Wtx/llkLXrD9CLz7WI8cn?=
 =?us-ascii?Q?qhNjnWmEnQQkbOeWMqPSU+GX5xgN4Mpir3p7/+5AMiAQBMX53fMkKFCvd6/k?=
 =?us-ascii?Q?1La40RHwWDADabJuZutGvE6OyQCXX6OZFe+K4DtdgWW/l6BYNBX4C53ldMOV?=
 =?us-ascii?Q?yTmT1fKHTtVYU4aXenGZB9I90xPRF5l3dU1dwVuQC2AHCJ531bkJer0w7ZPx?=
 =?us-ascii?Q?pGa+HQ8XiSA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ylcMXxETTwo7atJux2etnF0HByTlDpG4tJtmC17JNS3V5kLvRzN6yQPWd2Nn?=
 =?us-ascii?Q?DyCSfYlfyPi3lw+WhViLOcZPcsegm2zJJTmjEJCIRucYTe6MLC8gFMC2Uhq0?=
 =?us-ascii?Q?/MmWZa5ynknWqX7eCV21gJeTYcfpQ3cCaEAOR+gvjrfkVlu4WC6WRGNCf3BQ?=
 =?us-ascii?Q?Zdk1a3hUwdCVH/qKwMxkouCwbugpOkCUHearCtWsH/KWPNlwvG3iOZG/gMU9?=
 =?us-ascii?Q?Aa0bnzrWhkVO6c9zyzwP10naI+pIIGRpT3wBXhvqS07FrKF6SoDz/5kKDfKm?=
 =?us-ascii?Q?cHlHc+NT9PUgARzsLyw0DkMzm5Mlj4WoHKK3taHQESULrzUoWl0OQzGrtLTW?=
 =?us-ascii?Q?6b06HEE3TwZY/nBW6cWy/Xq3oIsGsHQTMhYkqCd9+6pxX1EuuoI2vrix67pA?=
 =?us-ascii?Q?+OSIH3kFGfN6bnpmKGEBWJOBaArS+pL/gYtOY8T6tj72eiy7yyFQtlVYHq5c?=
 =?us-ascii?Q?q1uYLXlUTW/rFx1NdDYtHCeOa+ClsVfffcL1sX/modoveYrTeb3dg8Fsq3J6?=
 =?us-ascii?Q?FFof/gRkTZlVvBTnPg7gHzauOwn7RR4ceVJEHp8btEx6XlL2o1qRi/+nRchf?=
 =?us-ascii?Q?Y5oKCH35e08IdykR0RFZ17G6cafi4qU8V+e13LYwcGx2ii7+UltdkPKJhU+O?=
 =?us-ascii?Q?RviTC0ITttUWFhTmVJtx3hhTOc7WQ/0hVwPmwYvSTkuhiKkm4IpJwg2rg1Da?=
 =?us-ascii?Q?TV2Ckfz7IO2mGMlJK7FIXtTHWt1kqAxDVymU0fyYSVX+nQDbVWq/uXJfcKN2?=
 =?us-ascii?Q?FHxZBYzYcLUYSE36pI88K5BdaiNS3uvnXltaRlCcwrHjYZRDrZumMQS7c8xp?=
 =?us-ascii?Q?CUgSjKkZS/la4jEkMvYBvL1ik2RnnN9CJpKstxPJ8wE2NFUcq12wjyoOUER8?=
 =?us-ascii?Q?PZhxPrL16rs0beBGISmrhUBIYItE3k8imbPjA7dqIQ+HS5izv9Vli+wunkul?=
 =?us-ascii?Q?mEfxx2bbOqZQRKhsfNBY9bQ/8ftvmjeQuSTff7ztF5LLHbt0tzs+6Lm9szj7?=
 =?us-ascii?Q?GM/vTE+Y955wPRGm9H7aGQk7Bv8C4yH4Nw/bos1i19hDu7sARfyBtT9o82WE?=
 =?us-ascii?Q?1d139gQSxJiFKpaZGpo0fYo2rYpqu1svrROUBLeis5+P07HnXTgxm2hqzBAP?=
 =?us-ascii?Q?YhzFE0u+cMqE89A7JuMt58wZcPTHcjpaEYbVW73AUfaPlWMPjriM1N2zDbXr?=
 =?us-ascii?Q?/H20iMQAgCiWRzRJUDjdsY7IzBPVxxM42yr82Pzm//YAIhJ5KfGxj0yMx+ZR?=
 =?us-ascii?Q?EDAXBvtxC/ACvTLfJo/k1MKWZ5rM3/vzAbZ8vPFFQNirwZbpi8omkKtsdoMz?=
 =?us-ascii?Q?DkMshng5VK9iW+qrY0S/u7iTPCvwP27t/kFA7vIpTjvWptv1R1Osg1YRqdUI?=
 =?us-ascii?Q?Wlpp+Ctnc6Kait8XV4lTPOHfgzelNnp+5BF0XvelON2J+TnH5ugs2OVhNJoW?=
 =?us-ascii?Q?VSHR12WlO3ipgKHRXfJYnLV8vjbbeVjKMLZlrb2K8GSTxH9bqm6lWuLzHZzt?=
 =?us-ascii?Q?LdKQitQS1bZqVtshIdzbIJesaZ7x1OScwTDrWiGiVo6KSGvmZ2RYQiq7azxM?=
 =?us-ascii?Q?Vhu520yjtyDC1Gsw6dfHihn/AfkU/CjQoN7z9tPIE3dVJJ/nMzdWPLOaUGug?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OSam8VIp73Jhoq4CR9djeNlV3H0ie7lahPv7oJGkkFN3h0WBe147j9IDEZYMNJr4MWqkJwVLC/o0jXzoDHlaNSbjt9k70KMJilBALLPDlERrVfgDwpskuKFClfzTZMeEmaXiYOL4Tdms6dRWOuULyXLeHhggKsvKRiIqIArmhOUGae4Uf1dNbngt2HW/2S00x462R1bSAmylKpTSWDu5cSfPmevPdCHRWsbfyx+5DK1RjyJzTjVTlrbZ+H1+T6x7Zu/Kfk3MuXv2wD+ZF5TYl7GBlPMOBc8H2moKcDKR4QJw6+KRuiodSdJEJ6PgcMrBXrmK05pFA2XZKXZqhBKHyMoGEis/L5eX6DniC4RBk4n4IUuHwoRTj2R7vuKGJncxJJVA4+QfeRzshvucDlLbHdoNn6WFkuTDhYz6ITSOSMm32gBQukuCsWML9BiCKSktLoOPwaOCBCY6kSI6JrxRyLjdIP3cCrCJ+zVbKp0lZuBcLaDoOYAcFvvDTVkIJtAOIFO27i09G0prgGFTJ8wul+bOrhv1E7UxCduTGtmpAOnr3cZK1EKhZIJDNSDPOcKb4S06wAF5jzSUAO5D1ODvw5LjqY6mGFUIcFHdILylF1Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d4bc62-6d6d-4896-ebee-08ddd48c9655
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 01:57:24.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p2RfS/7EWfjgWNnEHwzImJ4XgsOJ0B4NrMtmIUMeKovvWkTeCjlRi3zV9oUFHX7A8zgM3+uNo9PQhH2a9vuPC1ZjTN4Oa8duhJddjWUkrxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=570
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060011
X-Proofpoint-ORIG-GUID: Z2vHMqWEOceWKnMOZY9wVHe_NxzFUKpG
X-Proofpoint-GUID: Z2vHMqWEOceWKnMOZY9wVHe_NxzFUKpG
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=6892b688 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:13596
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxMiBTYWx0ZWRfX+DJd9hNFWu2I
 sw4HFeB5pEAiLQUbuMBe5A+JIwTEyWyQ7wMcGcKXG9DxAfayboOQMGbkbmTBo/Xi/Z6QQrOBY02
 MHQIlA20kvXWb12SjOZ8EJ5IpflfmMBuOT7qF6xCfWmyjrmbMDlWIKqoXx+qA5VsQ+SPEjPITWh
 GnTnR46j26pOjl7Lqe6OhqFO+2yvDLdeTmrSAEeEA0Jowb3X/R7imycl88ROVtrf95Sq/6zeADh
 +IWntofQkGSlilJjJtDcKJuzVFrdxmNxdF7E3PLOtqLzLniiJyL4Z1Ui0+saCIUlI8nuvbsV7B4
 znHS/Tru1L/ohHYTNaTepZU9pfyfOql4UV2N7oabBjRSByGM3LtMUAsVv6ZpU7C5QGNbQzBKLOt
 Jd1YR1X1qIqtGOB2fa/T/hBz1RPZPsGy0H1y276RdcE/2g7I9aBkN+D/V/wdxNvIiLuKy+Jx


Jean,

> Function scsi_host_remove doesn't exist, the actual function name is
> scsi_remove_host.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
