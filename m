Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D117DDA9;
	Fri, 25 Jul 2025 01:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753408422; cv=fail; b=Y37ni8FSbpzp5hDtG6VnrpkMZ6ta2FwKJ/xY9kqLA81WFRdr4s+paEQhw9ltp39jrn+mE6fH8cbgVc8GtOKutVe2z82nss65bOl9zp7SCF3kEuYjY2bn7/48/uVpELbOFe3OCLlzcA0gQos6Nuh/HKE/gPA8/Agxw/94+Lm10j8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753408422; c=relaxed/simple;
	bh=WyfesT5+pW8Et1WVqGa2bKnGCdoE0e4uFn2m898w55U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=akxrr9JH643XsShEiIZ1Hf3ARMf+98L4wneAydkqbvkNJvXjL9pFRioorhNlwExih7+055aea8W5YkMSXVjg6fZb0Y6Hq09dUhD9rCpRDwlqUOXUIRdetnwxjK3LeqMPOTDoXwH+yni7vmoivyMNmGbFHBkz9vZ41MOCbNbpROI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ICYZX+/F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SwVDwhpu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ICYZX+/F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SwVDwhpu"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLk3On004683;
	Fri, 25 Jul 2025 01:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pPElR4Bt+ddTQom4Ta
	Ns66dYswxxu72uLbuMYzZwmTA=; b=ICYZX+/Fpegmx6W9QewiEvlQXrl+ZOvag9
	l/nEu2CrfJonUmP8+ouHgMJXHW05tkx12jeODiQXFucovf6ricE+0tcq4IAyLzaJ
	M706MNV3GSnmvpivC198dpV1BIWepxHVrGqzE9cfMii46EcY4KOxTOk+6sxYDHjR
	T9XGufHvMy9l4WxuLX+hzM46YF7LShf0zvj4n8QJtQKNLAoA+uNCsRArUseh/aza
	y+90D6Iv+CCJ7lwYbilx4Xl4totsbzLqVqWIvn3200Bo/aQ1O10PoORrdJh6EZV9
	T/R2F5gyIRNCy0ZYrkFRAwpT7sB9YjW1jalQwJvVrdHAkhvvidIw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1h06cv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:53:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OMmdjg031510;
	Fri, 25 Jul 2025 01:53:22 GMT
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazon11011043.outbound.protection.outlook.com [40.93.199.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tjv78t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:53:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtKBHYPBLv24ScOeuLpgRwbuCwyhZ8b6DrkQxYgV4/XuPjGYD+V438WnceOpREKUfAYomiRqyBhzMcKJNHtslaOjqYmopbX3k9cek7vJCApFs2PCfo4B5MdCrVmoZq/5pyiNtP+Bqyc9uoR5D9VuJZL2cLrhXBy+pqglBs/p9LoZlbF45/eJn7Frr3fcRgoNKm3p0KCybuGVgi7p+m0ZT7mxzlrrbBvBHFHLL4Z0F1nasQ6LUNQPJ0IHDbd46+XCb3fJ6GnlrmjaUof5ZmCVFGzeUvwvhc0szzvtwkkuodlfgMSnAva124Xk1dPAGMfDz+B2yRbj4Sor8evNvCpHdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPElR4Bt+ddTQom4TaNs66dYswxxu72uLbuMYzZwmTA=;
 b=ZuMtvHcDBZpV2Ddr1kY/a4o9SOMBtF8JyihpPBdqklEn3SusbdnTNxiH8VTs+v+EvjrbgjzJvEpyTKzqTwvU/svE493dkmEAz1rA5adrCp9RHFIHDqy0Bz5yttx5kml1Rpg3a72U8IMTIs2H6ytgsLrZ2LMSoI10p/Z93nR/FzNvtd1UUnmD6yqSUt45P3FzSo74dWbdrvPl5caVUUgtBYT0KA68aEXtqprrJmC4o0v2Kel5Nk3onRWnNqy5LLQSj8bZYGrfQyIuPed70jDVZuE8bUrQ21IKZBOY47aRiJJVm8TrMLkGBmYdF399YMsMID4Lf0jIzGu0VxJ+V03weQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPElR4Bt+ddTQom4TaNs66dYswxxu72uLbuMYzZwmTA=;
 b=SwVDwhpuYkqtr8uWSccathd6tVTge+wLaRENg1M9UhFLXFzjdc51Nx9u3Sob0emm9Po6JEmJKFx67uSxnTusYBZ1kC3qjIFRuJoe/WB17fBDrnX1rlef9bH61pMXbbrqbxwzISHc1aBiVZ+TRzS0RaDyucXICgoH6YxgngjGtzY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7035.namprd10.prod.outlook.com (2603:10b6:510:275::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 01:53:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:53:19 +0000
To: Yihang Li <liyihang9@h-partners.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liuyonglong@huawei.com>
Subject: Re: [PATCH] scsi: MAINTAINERS: Update hisi_sas entry
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250702012423.1947238-1-liyihang9@h-partners.com> (Yihang Li's
	message of "Wed, 2 Jul 2025 09:24:23 +0800")
Organization: Oracle Corporation
Message-ID: <yq15xfhrq7w.fsf@ca-mkp.ca.oracle.com>
References: <20250702012423.1947238-1-liyihang9@h-partners.com>
Date: Thu, 24 Jul 2025 21:53:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0180.namprd03.prod.outlook.com
 (2603:10b6:a03:338::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b683da4-d7e6-46be-9737-08ddcb1e073a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KvkkAdV+xe/Op5IAnZWZwtEPnrlHZX4kY6Rp1EG4bnVZz0DrkMrfhAYmLdzy?=
 =?us-ascii?Q?8ZzItI740T4Ay1gy+Mk4jBFMRoLso2ksDf0REoJAYx3CJk4fsC+S+kzwuqNC?=
 =?us-ascii?Q?D6SWJXMsYYqYw4YuEQ5Dkk+YD15yCpErSDBhu7PwXbA7uqN6OYIzvuqoQjh5?=
 =?us-ascii?Q?iPbT/cmrKNrwq//isiEw3mQKapbBj5q2HUeMPBiTWplHLiQiPhYQWPCHMPE/?=
 =?us-ascii?Q?cWiXJn3W6lwwdPQ4OGkZF3pzpHLJPFEWSoUNskANR4kkpioNbzZif5b55Wzy?=
 =?us-ascii?Q?B3rjmeA2/6ITUDUVCU7fgJN67pjigOizfoiI4hPhxwGbzcHpH5uPSYaVMpcL?=
 =?us-ascii?Q?B1OhmzYB+IIv5ze9v3gVJuU/BzJVTo3YpE45ViFuX4W0hThaxBOJvrEpF124?=
 =?us-ascii?Q?CZdJutPIJ4wqENlFTIbuiKA3QGlzdyjVi0MgDRr4DyHsNIkptUMas3X5d6Vf?=
 =?us-ascii?Q?+9dareOMfe+c6BpOLCcgsxc3zOYIkHLfFkSx5RJr3hVK3gb4MgCGe92meVPA?=
 =?us-ascii?Q?sGFaSkiCnNAUBGXFn2bEBsHa35Mmh74pZkexQ4XZqVxuHwS+ibfsrsEhlCGr?=
 =?us-ascii?Q?qARHTzKVhfFDltv9vUd4qDMPgUYPk/LGnfDwbc64TE8DRmi81dDAGLNBqE4b?=
 =?us-ascii?Q?A48Nqe1grOPuYZCYZh5T5wdAMbaDC+2Zz+lTP1+2yGJ8CrXxcU45LcS2E5qn?=
 =?us-ascii?Q?VHFw+gHyDDk1WO/3B7w8XXTPjlkMP9euRsGsE20Vow/QqLSIdSIvi8sIyuq2?=
 =?us-ascii?Q?eNOgyJDJs7Sr23v/SlhmQvFSD9QY458CP+ghFDiwDpqZWxxRwfeqQoTybLFt?=
 =?us-ascii?Q?L7+P5yn/Bq37plpAlu8J3MIJBKW8HXnyYLwuMW/aTNNUhSiGuPINX5eKmVQC?=
 =?us-ascii?Q?WGihBr6xcEdy/ZpitYRJ9Dr0WxCv/QAoHR0jDGMU58JdHJjM5p8E0KJuAenc?=
 =?us-ascii?Q?fKwYZxU12sNRCJLPQyrqN55wpxHgsy0Y6ddLDjGv+zXmBoTzsVfX/RNkg/0P?=
 =?us-ascii?Q?6Z9axM7rbKbYjSCPgaHT3ngVHNhBfKxHabSpAEZ8KT0cLC0C5QKAT7GtgPvV?=
 =?us-ascii?Q?PWzaKSZ8KWoVI1GGwV0zW5paPuAGGzRzyMuRCMaNLujGMnXKBhatYfAQ3EWO?=
 =?us-ascii?Q?wNYjm4t7/MOXZg8HPGQkTCJznxFYkKa3t6qiyuTLacf8S8SFK375TrJQ5382?=
 =?us-ascii?Q?dW+aWMqHRpz2u0xU0nUaEZGKheMUscgtmkqiARtQlZM9r4AYy/hXIhEImtL+?=
 =?us-ascii?Q?fwm/Bo0buo27d+Jt7eHY62MlcnU1ONTPjImBuZDPpemI8miuMn2bofElt6KY?=
 =?us-ascii?Q?6bkmU4bXlEUJC/iL+u+w8eLKKmWhBRs9T1hD963zZpb+U8pZX5nnFOhXhHNK?=
 =?us-ascii?Q?MjE/+pbOi/RtKiQ/l8zyKqo1MSZkxDVEe23P94pz4dh4ssw16lrO55fMRkLJ?=
 =?us-ascii?Q?EAJfoc50Nsk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8z6XtrpO0K3X3XMq7n39RspZmSm3T5wBGdAz8xIzxV3Ye17eN2w8N7gQ065m?=
 =?us-ascii?Q?wvvU8WDyYtDnmYDbww32z1K4diLoHpIQNr+aOF6Yc9n2EK4X/f/LeT+WH9bR?=
 =?us-ascii?Q?tQZYNAp7wPJ6ouPBugQ7sGMLyYK/1QnXna8/bRB3flQSnqkCefftQuZYR469?=
 =?us-ascii?Q?Z6TPDAsGK45UPpynzaYMnQgGEIU/UzGgxfqMsrCShkRFuEwkLBF/khxZfJoa?=
 =?us-ascii?Q?GyJQ8E/yxbtdgNgpuvqyxmB5egB2yxwDlMnTUOlZvm32vy8f5rxum+dNHlsx?=
 =?us-ascii?Q?U5JbvSpaptlX5Nv8CpzNCy7nF3xia36bHoC2V/IWbpVHZ6MdIYG9YXdqJd28?=
 =?us-ascii?Q?o+Lr/OHOufBPFx7t3AB98tP9deY+WDkKoKXKEHyJlzwi1u+on1MHQNvl5Smv?=
 =?us-ascii?Q?eLXh4BQs54kX5E35thpIdhRQob4wYFrGKpmlqYMtrx1mnHLBhNU6LvJGczbz?=
 =?us-ascii?Q?oxvdL8eMQApW6JXP+PZdaLctbjGv7rBWsprAdwdd3sslQukvZlCCQcJc9XXQ?=
 =?us-ascii?Q?2IkUcRK8r19glcvkFtjt+HXUiVrK9pb9nRN82kJFR5KwK++7KOlbcz5I45nT?=
 =?us-ascii?Q?dTFgp67zK/YuLsNtLT6sB3jjz0kHlIBbR/iEZUJKxqMY9Yi1ff8xR9ZmHEqs?=
 =?us-ascii?Q?Ol2GoHwnVRfIzmO5E7y8kJHfIsnSSUwXOECoKRANRqCqeNrsGtQM9xGOwhAZ?=
 =?us-ascii?Q?k34Cz70nB0CjNHbfaELu6qHeACuDxSWT6UU8ytQ/Q63YW7zUaTmUt9tDf2ns?=
 =?us-ascii?Q?kfWJzRcKTSJOjXb61uT3joLanWZjiksZ773L8iKmTD9JJAdKpevL0F8X7Reg?=
 =?us-ascii?Q?a8viSdRvnoK8EngfEm7kBAhuTT660LcXQlwXZ54ffaoS82xcxMla3TMVitOM?=
 =?us-ascii?Q?rb7gH+dZ/CWZy/NZbpFJUGgV3emyHdz44CF+PE7XRMS7La4MWHisau58xhk0?=
 =?us-ascii?Q?d+491aBYh+k076stiy6Q8cI19RCIe8mzuR/lsDClqc1L+taSOxxspgMpgVBz?=
 =?us-ascii?Q?vlKtHv+hSh9mI9LplvqdkyMgpOeNK62FtdMj1LKWSvyr8tbDwhnW9nQM16ci?=
 =?us-ascii?Q?mwtqeb7fmf7U8r1O1QQjppYja69Z1tLTPPb09DpFo59R09Ydn6m0eLrsz1TY?=
 =?us-ascii?Q?A3hKGmqxPG/acU6xaPj/NMIyQ5glgbB4lfv5/umBou10RVp1xBXd3w3c3KNt?=
 =?us-ascii?Q?CD+dcBJhvtfGkYmeuuEAc2L52G+PNt3xhP4lRZAwd2SpGBK/ujHZRtWa333F?=
 =?us-ascii?Q?L4v3qCdhg6xc47UScSUAkK+8UdusrD20pO/4UnArncuF5qaBEMPkFR1BVUjm?=
 =?us-ascii?Q?uCNXKye18Q6tFafTY7f506QCxgOBna9O0UBQXy5krnQVozwZ3wsIMmnXBkkv?=
 =?us-ascii?Q?bxak8vU91izyAgZSNwvBcg728v9qWtIOFKalm/i7PySt9hoU739f2nSe5ogO?=
 =?us-ascii?Q?PYrKTJXBdcMf8f7Q3i3kn2kHppsTtcP5+rTNrHf5RtkcQ8Jk/bNjA2YO79Vl?=
 =?us-ascii?Q?i9ECtJdXKa5qEXXidFUrTaZ+v5i9Dsr3wP+iMhl9D/RyBxTMLkKkrwH79P2Q?=
 =?us-ascii?Q?IUH4fAIkM2GjN28o714QSWV9mdaDo/wXW45j20x/9DCPvhBpz84UtysSXi5L?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8wpQVuSV14KvR4gPb/nuLBXEDoteyZStptWk/PegWzZe2aYQTnpUJVxntqg36HaHy7bK31w/AbKz0wBCZCrRWINwcE78G2Nby03x26N0cXqZLHe77AjVirM/ydNy/6hGFbpzr39Tx/z44s8/LquriSpimxxjEHKT3zC9hDwP/8os91a7wmh0nw6L+A1/bZJiWJKcA/ui4Xh0J3WZlefRruAC89hQQrR+mrNDFODDQzQM1+Lyy5Rs81I+uSZcnYjF7w5XLr7n24qKSqTS0euK39z2OXu1Jqh4iTGNq/Wu1CKt7H48lwtGfeBM1FJQCDhpDvRp6uBBv8Xa64FuD8UxPZ/L0L4d/4glcmms388eFfhDHLI74XgiWKLMOfUE/lpLnS3OOtGNa1X4biCurHyUC7yYH9pkKgKW8qPmHFUwxrmQBEtCFjfl6lRrciELxCfMREIVUHizMTE6KL28t4GXPtLni4lkADL1ETYiQEkwFF8eC8eQP9mKky8lDswhA3iUC5TUMYWL3X6fyqRY0wK928AL6EVe3z42wqD4RINB3YhXH7UdvDPWC8ILZ10mJpeBnKnr0fq741sA5ySu64h7c2bF6DRTfg5XlPVbiT0KgLY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b683da4-d7e6-46be-9737-08ddcb1e073a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:53:19.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8tWlbG0GOsGCR6LSdT8vVWEb9OybEKzw1ehwkJ1EmI0TAqlFA6qexf2nWmDGPVpGXvNKizXo1XmBYrRNXtsrGeLUiyzISNmU6sMvCsMmerI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=901 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAxMyBTYWx0ZWRfX9sIU64uvTyFs
 G0FTWzYg8lbWCbLsBatpToIt27FJQamtvTNh5ePFBVqFk5k6iVngphZGFhJLA4WQRRtkUh+rzZU
 haNyMk5/j3/wEt8jdHkjZevuwn8npZrK5kITbRHNaze3GW9jA2N7n54U+93VX9G2LVM+3OSmhkd
 aowvd+eGIorrahSo3m4s3RpS0dXWltYAcHAs9iyYfDRWRKpmu8RWopdR4R59y8BbhIlaS0jRt9Z
 DqiURMfUAhEh4Ky4yZL2KfIxAYEmU9UnysUEb0NSEs4jgDrTVHsMJXgI0ec53QcXvxZrKGq79MI
 4xYO804xkbZSTDdFVZq7KX0wKhVaK2Ad9C9X8LAiRsXpErVo+m1yXORyAsysuZ5R8DxNsljGB++
 yDRMlzKO1hb3MGVGKMAEtQfP16Wnku0drXfJz6Hb08DIFLmrjl7ym+F2A/HK5RaRI9yXQGOJ
X-Proofpoint-GUID: ilAACnSIPV89L_JxefKXVkXZ4i11HyPa
X-Authority-Analysis: v=2.4 cv=RIGzH5i+ c=1 sm=1 tr=0 ts=6882e393 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8
 a=cewXuGIsSzsw8c2jRYwA:9 a=VncyM7JbuJcA:10 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: ilAACnSIPV89L_JxefKXVkXZ4i11HyPa


Yihang,

> liyihang9@huawei.com no longer works. So update information for
> hisi_sas.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
