Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983912F46;
	Tue,  4 Mar 2025 02:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053930; cv=fail; b=TAI/FpENLXhYQrmV+BOu4Mf+LTN3n4a99k2r3ULZezxT5I/SEf1YI0mvEu9T4HWBNAIKygJRo1/3YBhe1hyeQSb8Cvv3h9kF0MA/Q19PdrVUc3nW+qVEI9jmaYoeIcxGr0K4+h+3d/CDuYJ+/ZJyFed4bO/GCJijtDGHpYILTbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053930; c=relaxed/simple;
	bh=bfiLAehifsj2Epl4utpzi7pfW5VvJjUdjaZSTtEGEwo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OCJfTY2LksC/N3GDYieojvALmCAEX9sQbOnNvGRNU7/gcHFDuefOaE8F22WiWW3q+I28tKD50A+0RZtqjwqfqrBVdE1TS1t4FsM82rrB06cp8gbcO2/z5XM03wDRuVwxb8DJqw0VQJWd8fn9iPwbgIdTCsG4MbEjoiNO8528q4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eUCFtKH0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qWm8yNE1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eUCFtKH0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qWm8yNE1"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NIu8016988;
	Tue, 4 Mar 2025 02:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=kVSxCiZIVMiBuUT8IH
	Z7SLEQSqVCmyZrTWMCpyMicWA=; b=eUCFtKH0zfbC0jRY8ZAMqqOodYgOIQg8ff
	waxNmlpQuRWBYUdBioCxRPN1uBiIfScvGwgG/JPApcI2hq3UjI3V5iRuinUSKIXn
	p8MWa5JOODZKSjL9xdTP1yxQejeH3Q/TQ7IfSi2mUd1vqKOQGgKnRFxhOvm5/ezw
	Kw5gVTLJvYa6nxXbA62kZ7o1wdCH1I8McIfAZAWnE7bpUuNNFIuxmHvPui/47zTw
	snHlD5saDFz5lythYx5eiwebX45Ya5HpUi4XJhDGUpRN1U7tIUr7EbvdcZl5pHtL
	60NNqdzgUDBcAubbWzP8UbKCYxhvR5iAvy2GUx+DvqLzHQ+XD3QA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u9qc2ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:04:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523NDnkb015675;
	Tue, 4 Mar 2025 02:04:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9hmgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:04:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVRp3fQWSN9j76Dz5kbRecePfGzRmCIQGdDJ9H/p3d2BP2DeydARvv8cOLB8YBuzdFldRtOIJ6UTBsIw/AamcCtEq6qChrMYWd0fJXuviRbC6d2qYpPNaGrKyKMrVwEUEwTow3MwOyFpA3GQ7zb8m6oQ6ICRGIm+9Jg8G4u3RnhpB8eXE0coIsCm2PTPbWig0iuD0IXklL7ChzrmTf8EAsvyv7xqXXOXeekFj5obQUhBbZmUPvimLISCNDvFKkayc3GZNL8+VSA5GCtPMoVOYEpjA4MKg6nQ30Nd9n1Xz+7fcAe3HIuBVQ8ELoXNlHRk/WzPAzkbYrXL1LAM8zHxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVSxCiZIVMiBuUT8IHZ7SLEQSqVCmyZrTWMCpyMicWA=;
 b=F4PZWNJxwSJrXLPrnK88DY3sMuSylrTgMYpx3VOxMxVVC75V+GunBnQrzx6QSaiX10maIq+oZDGfko6ytbD7WisvXgahQMJoCTJznkvUnaSTPoDTnhalhMxqmMPLk6mDbW7UeRYvWfiAxDefBDp9ta53Vy8Nl0oSUSIU43ByHNjj9RQW6NAbeSGFNlhW5F8c/Rrq9PLFg8BDFv7Lr7ERsunj1Ij95WgHx4y7fmj7ojhsXQPXFk+1RZpZkQcGUDJ+eFe2kCC8E5jYEjfZ54tkU19SrtvvQZbp6e1Eo/cPUWNtl47h4ml4ETcMacOlp6eLu5I+D5CIWt2bxBqx7O/t1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVSxCiZIVMiBuUT8IHZ7SLEQSqVCmyZrTWMCpyMicWA=;
 b=qWm8yNE1WpPnpa2BbXa2Rl/+7FcdmsLbvPjpZKgDQGnVfV/hV09RKwitVDuT5FHwPvEIgE2Xm7YPh4GcQJHiOyE1kJTdEsoZnQUTYyg5FT0u85k7znwqwW/gsZbCMlZ3mWLsgzAn7c1t/GOutLDXHmNKqIH4HGmnMw6tvqHPXao=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4220.namprd10.prod.outlook.com (2603:10b6:5:221::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Tue, 4 Mar
 2025 02:04:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:04:49 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Yihang Li <liyihang9@huawei.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Damien Le
 Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Bart
 Van Assche <bvanassche@acm.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?=
 <u.kleine-koenig@baylibre.com>,
        Jason Yan <yanaijie@huawei.com>, Igor
 Pylypiv <ipylypiv@google.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250225163637.4169300-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Tue, 25 Feb 2025 17:36:27 +0100")
Organization: Oracle Corporation
Message-ID: <yq1v7spv9e1.fsf@ca-mkp.ca.oracle.com>
References: <20250225163637.4169300-1-arnd@kernel.org>
Date: Mon, 03 Mar 2025 21:04:47 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN6PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:405:75::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e0b70dd-4cf1-460b-5504-08dd5ac0f1cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yTxjVZFsez651P6OpX68FckQg+G/O04o9acDRQwGaYu6oPodE5ej4RIAiJFh?=
 =?us-ascii?Q?s4dEG/58wQ5W8qmE9fpLFshbLKO1czPBVprgXi2HNoUQgcqkyud/LmWG7H/8?=
 =?us-ascii?Q?L1jqkX5dAwI4EmYQ7NrEH2Tb1G9P/939n+3n6u4t1RrTaQfllptKyyFV5mUb?=
 =?us-ascii?Q?CuXdCOPtOw3S4iJPcqSL7qSEyy2EtE7pw9qLWlsoJF1PcmMTAUsPe2HcwVx7?=
 =?us-ascii?Q?h/Qu0s6wSQWsaideDJdNhgsWpFwHmqbjKAuPA2NWppelwm4bGgIa7LhFuxI+?=
 =?us-ascii?Q?4Ft+Iiai/OrAfkGbdRrrBlILDEezqufd4aS2a8YBeqbvXzKxrhGsaZNhDWoD?=
 =?us-ascii?Q?EGLSKfakISTuJ+vRG7SgXUzCFpJGqCVvVZJlUuEFEfTL4im/Jk7wxGVvyd5d?=
 =?us-ascii?Q?q4e34JWgAUvon7NTP4zNB0c8l3dsd9z3BFlqb+5TVBNUp1D0/fwHRWRNwnhJ?=
 =?us-ascii?Q?Q4BHD8AiBJuo0HXgY23Q11A/vafNHz80rNJQNa8Trnolz9rmTCmnTjCbCZLT?=
 =?us-ascii?Q?HknH+v5opHbHyPQ+AgNkAE1ch1wzz6TyRrkNGI3qRSy3gwop7WxkYX2nx1LQ?=
 =?us-ascii?Q?Eos5ZSmyFfYt6BMeEcFnPRVST7+Fv7JRt4qIxVkzFB2W7l/hayIJk7ogImKv?=
 =?us-ascii?Q?Ask+MrspmNx3zt2XFQI9ktw85gWoHV7z6uM9gTfgNI+1mpbVl0fD73Oip/cN?=
 =?us-ascii?Q?LD32yRIcT1mv04WkjuuXL2kdqGxa7gDdEp+VnPSi5NvYzxxx7yXfbteRdcfk?=
 =?us-ascii?Q?DiuJOJURF0nsT0y0BHvmoDA+c1cDqI9ov1xMm+HPfH9rgYJM6pf/opB5tKfK?=
 =?us-ascii?Q?pilLYPAx/FLeNQ1z2oEhHThNREt0NLkLPeWSAXjqlcOaEhC51Dl0kH5/d290?=
 =?us-ascii?Q?EZGojG18iJiM2xxhSA5SSAC61Z2t/tRibAF3GKd7C+ljPx5PaDL8YxUwL24J?=
 =?us-ascii?Q?fEt9BrpPPE+1avEHC8TGOYMCPdQk54WK1t+VqRr8nchm268WAlHLjL5qzyHi?=
 =?us-ascii?Q?4XgsuiIliwwbVbW9T++vPCcV2oXfTDFx1cpFgkE/aUo/sOv4rC0jz79h+WMZ?=
 =?us-ascii?Q?EIB41ilBb2LkYCR3BzGDpFIZ6crh2zKkrWy+WmfFC4hFZVSjbk38qo7aJOAB?=
 =?us-ascii?Q?anOKStmcmMkwKWigCDn1DjfK1sWoad7a5k9xPTj8R2eda/QP4eeC0KVJs+Hc?=
 =?us-ascii?Q?1noPF4eRqM3Gf3uLzlYmpf8jWn54+Rdw8BJiO3tSw2/WG1goYbWQEoL/tIWf?=
 =?us-ascii?Q?w5dQkGH0cXz6k8mPpGuSNzQTrRVvGY0KPRmietjFBHKkDI7JGEYuq69WkymG?=
 =?us-ascii?Q?vI3s5XcSs1+Sodoz/B6auItBLGCfrXNIkOdin5CHhvIaG4xslzQZX8rpt6tV?=
 =?us-ascii?Q?56RbAza721ouMg1gwYqnjYW/nzN7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IyrkT5SW0tsP6FRa3S+rRDisM1uiyrCuR5UvS/ZdqypDaSlwd+vyP67Mc9oh?=
 =?us-ascii?Q?f2UncGGBTwJyEmDMEojXBkJjbOGuZdoxdviu1Y45knqq+iAdNW68zk1JkPjr?=
 =?us-ascii?Q?g3xaG2uGVm6sLL3Mn/QFFznpMl+C4il8hoknnYw0WjMdhsV533+76MGFG62f?=
 =?us-ascii?Q?NWHTIvnhK+m7ETi9xXiHzRlNmoHcZRGsoLxxS/c97acHFJ9HDmBlW/KrBgLo?=
 =?us-ascii?Q?EBuZ75+EmVDeYGEs3ZjBGdvtnS9xiTbjr1akVkRtQNhw8Hrf4vli/l5gFtMe?=
 =?us-ascii?Q?WhRbOUYwL2U1cl8ATxnRkG5R8IneM95SdolapyxtQMYB6oCf0kT5P1oIzV6L?=
 =?us-ascii?Q?LUbLbNc+Ikh05fiuz/i5vl+sR4uUQnCQeivbwu4jngOOBx/iVQbkWtPhwBSZ?=
 =?us-ascii?Q?tZD2LpVXyV2GTpSjrEppwyeNAdhLSBqAfcIFzCwPnCwJeKhrHMZ2iuzu9opf?=
 =?us-ascii?Q?EGLG+HQB914VQZDkrHn/LKV9mVNdVHS66Dao8SHK6gH5my4Iz8UB26yvOrzg?=
 =?us-ascii?Q?RK2JkQYzLb8NI6K+Mtg9gVtGzwDkBNrml8Y7dwT39VQWyBmyvLcHpbTzUB+K?=
 =?us-ascii?Q?HwxchqyDySQ6MW2dcpSi0dNe/kusw39nIogHb1FCcEdWsoJ+Jr7RPqQsL+DG?=
 =?us-ascii?Q?DFuOkv4U4m689JG1nXsHHoRWK/AIZwBNFxwT84Z77PBfJ1bS60zHfyl/GbLa?=
 =?us-ascii?Q?++REUuoGoQAN+KfY66lcMHNTRP9IJ6pLGeSwAVBbdcNAGuWI4LVgQB/Zgv03?=
 =?us-ascii?Q?IjQTnDHWMU5SbaFT449R2np5iFDKnub6UbhgvrdsZFqRi6xsss4ljSUwsdtA?=
 =?us-ascii?Q?2OldDdRo5PuH2VlVz7BFgEj4AxLWodry42IMjSGO4JOeUv1Q/aK+ydwX5kxA?=
 =?us-ascii?Q?QvBzcx7BkbucKtdGsM1+mdC+O8TA2o41iJctCmrDghNvfMVLfDawnEzKgHO+?=
 =?us-ascii?Q?xa3rsRi8993SwLRxPgQYiK5FH0ryll7gl8U+VNqPzl9ees9nzeLYpp2CNstS?=
 =?us-ascii?Q?ZRtpIzQmqYSsi8UrH1WZu+WLVWW3/8uRBxmC4XouY0Lal+jnWgSKbIQB5Ju7?=
 =?us-ascii?Q?k34ndq7aRXReWBxln8aZxzbdt0H/17khlHG9FB23k0drqDNSpleYtj5tAg1Q?=
 =?us-ascii?Q?2Y+gN1vjBf/emfEnIw6G7jmwY9x2eDMvaGjktHDjhPZ+xm2RdyMejWG00408?=
 =?us-ascii?Q?Gaq4Kb+KwMbbwNtj9i7PXjZzLdghLPj0cVKVaiVYiBLDvWWVagO7oO/51BEy?=
 =?us-ascii?Q?Zly2vZFbRalcL9ctFO/63P9v3pnLq7oyATAF1xRW4gPUEUFY2o+JN3PHOIIu?=
 =?us-ascii?Q?gt5jMwWHblmZYyCnUSEbuu5mP1i7qMwprP9PfDJdOH4vdklpIP8/FGu0//gF?=
 =?us-ascii?Q?vBylhIUF5f+FvkT8imhy/3f3FvrJqrIJBtoNePMz2pEDjeO2YVYXjbj7k2h3?=
 =?us-ascii?Q?QBSyApP0c2rkVUndNk5tUiZBZaYzyTrOOPVETXgtbPPmqturfhTDJA7G9cgS?=
 =?us-ascii?Q?zzeER/Ce6CP80usYYAYfiCpgjXbFmDFW28EH0kkFwsH+coG57mpp7R5+fgwM?=
 =?us-ascii?Q?CdOpLYVSiw6+SQ3ef60HlhB+Gg3uFqeYyk7/EEkPvDV9WDNTKnM9ug4WrhoA?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bzV+FfMcNBg3uHRnnTBVJEj9BsenrfCtzuOI5FcUKfYW2oXbqExvJjo/zKk5OwKL7rn0KRrT1sIio0NU+12zfv+5BV3VzAVJGoWmQKmFg8celkDilGhhJqbxoG4EBi2K69/2n5AVuyrvI3xzX5Uos6fEr6xMOoZEmspo/ZRG5HwD81yqNQxmXdOzSZ2rRWlm1OHb9w1OZcYp0cr1rvf+wgHgN0vGCI+/UXr/UkhAVhbqPH1dbKDy15S/YpowCwQ18lULTThAXxDYItehjV2ZA0KtBEuxVaE4zXIr4a+qPxt8Da+QEfivi38a5/yHTpod/sMlSuMAhID9ULV8/sP8xAEE3rgEXeO01UWWUi52bnLHLxzouwxTdo5amlw1ysfJTlI7cRGKdql6vJfjtzfgc/6WaolKDAHsMhRe/qTEQS9lhYVRzWSkEWunsCNdFUWxfkywnpWg6umJlC6FFF2REUE+RkW3BEcCFbNiVAE1U9tNvHRNpUmbtCjN4PfhOcYp9rObSl/8uF89WhaxXFJHu+PP5JGQNWG4k162WfawIw9xENw999U14XeatGY1tEAvDY48HyJmKT7LcUBkwomXmHxaDM+2m+xmAPAM6uC02K4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0b70dd-4cf1-460b-5504-08dd5ac0f1cf
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:04:49.4885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNBWLTY2q9Co4YP3mwfbZMtfJx96U7hX2NN2uHEjKGKAW1DB2JPbZENf/Gnol8KoSkMGN20U8BTNTvkALkZXMQhsREtR/zEChwIWwloZdkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4220
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=848 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040016
X-Proofpoint-ORIG-GUID: 3Ru_vGcL86vYz5JE1Rc22PRy8B0DfZ4E
X-Proofpoint-GUID: 3Ru_vGcL86vYz5JE1Rc22PRy8B0DfZ4E


Arnd,

> Building with W=1 shows a warning about sas_v2_acpi_match being unused
> when CONFIG_OF is disabled:

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
