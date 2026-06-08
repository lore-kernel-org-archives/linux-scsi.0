Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9817A3A0E85;
	Mon,  8 Jun 2026 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955121; cv=fail; b=sxxTR8d7ELMUloPswBd4hHl1FIa9V1MuJFp+MdOw659q7ryogB6ccwy8olomJGot+Y6wlPyFwmkQ4CMY1mALgkWHj74ZG+v51M9GSRMMwpQAfEN6JoEcaeD2x08tRcl1epPE39p/srJes1KMHAHY4zu+ueaw6KFBqSOsmpfNXCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955121; c=relaxed/simple;
	bh=jWpLgGdeaNfnZhPcTIjW+tjCfBVVV++nFqSIkaCE66s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OVoeknAS9fcMKXnDE+EUdFcBM9cQwIwzQid3J9WZO5AmrCCggQORuONVIfEt3v/inA0o4dkHmigvoZI+sfER4ZK837OjoFTEdmtraZeE56KdES/2pebydiS2M0dncgY9Z1auQTUGRGjR6DkB0XMZD6nXzgJAx0Nj2AxU2Gkllhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WKp6u4VI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ml2j2EWI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WKp6u4VI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ml2j2EWI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSYGN974768;
	Mon, 8 Jun 2026 21:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DF2A5eUX3HplbHZs1H
	P5aTj4q5yJLNkEGy1MTHRJxeU=; b=WKp6u4VIkaubwbFwzWZ4OJgkk2hwKTqG9L
	/nsczlScn0NY0sqyU5EN6+yq02dUE4KuscFTTb4krXPa21zWsI9RT2y/MrmV1P7G
	9xjsO9nwRmTLjjEtclqDHc5woX2t4Zd87MdEgu1W9tXS8tjhXjJSq1qeYXbK4BWM
	jepkMVEZtkqE29Q7XVEoUkWZvagZR+bPABuU5EENw0CvjVS/PtYZQCXd26zUhAh5
	9CNZsDTY7KN+6uthqbtM/zE3Mxd6Pi/y6uG/JbhVYeexhj0q0gUQzNY/B6n4j4CK
	zNVGMiXoEqu370Q2ioLMtpByKt3R0hc3VK8PRrH6iPn7KOZJtl5Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emaf9393s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:45:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658LbuHC013499;
	Mon, 8 Jun 2026 21:45:11 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0e2nj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:45:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkGdN3DVmW+ocnxdqH3glvN7kGWJOxthpmjp+OZfTA1i9croTFHppGuspO2rUEMf0lnAvx3CDHnZKHyHdM8hI9R/WBlgfS2TxWB/GM+fOl0goWRP9wkWfsw7xW2oDB1OpVuvwkaBQHXeEEk0zoI0bLbvhai/EeRODeKzCjQvAaYbE/4MoMAwllrTJsTjGi0jeIGkqxNpi45K+Eoi4fxZdFTxijGk1dv5gEzIDKWNTiKWFxQY0d5LdP3LSiZ9VwDWxhwmOUephkvp5O9l/06NvSRVaa6/mAr/Wm3imwvbu3nMy/2vwVyhNdkj8ILu6kTwlORUV2K8GEthKthfzD7hpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DF2A5eUX3HplbHZs1HP5aTj4q5yJLNkEGy1MTHRJxeU=;
 b=l8OvNPaipiWVOMDscgZoBzTLXRtFJUkLfAXchPQYcl1ezLESRIFUjLGbZDugmrpcwFCm6aBnFpBd8JaV9W/TKogPnCql3vaA9DEFKwtPRY92ZAzYMrIJoJmH8OtON90qo8IUHFdtC69uEbBWdxsEb+9fLdFExViRHpUEY0kkNoSId5niPQhN5OHQZ1K8uB5p7Gfn5CbXrpAO2Gc0wCab/PAlZY/4CMITLVcQ/5UFAWN1gJcEYfbSEAyGPD6aJGTqGwQycyUlYLGkZUNpQjF47BJqbyb5tIBLLGVgB7lNfPznIf6Xkfe2/fCfBmUr+NvCpPzM/PHyfH9PUlXF1aCQVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DF2A5eUX3HplbHZs1HP5aTj4q5yJLNkEGy1MTHRJxeU=;
 b=ml2j2EWIGl+q6A14bCxpgBecd6ZwQpewMW3TzAlDYJj2LOiGv0ricXM5eJu2K1abHccW2173yj4iA7rRNYyp1yj8uQyaE9NrRfaknSTJuJR2nj2xt5RNvThjTIwbYKc0yawekst2/iucB4B0p/GRLvXY/TqOeLnhu/WYIZPOMRA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPFEE36F3C1F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d56) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 21:45:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 21:45:05 +0000
To: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <bvanassche@acm.org>, <adrian.hunter@intel.com>,
        <archana.patni@intel.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: ufs-pci: Add AMD device ID support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260602095931.2869516-1-Rajeshkumar.Sambandham@amd.com>
	(Rajeshkumar Sambandham's message of "Tue, 2 Jun 2026 15:29:31 +0530")
Organization: Oracle
Message-ID: <yq17bo84sh0.fsf@ca-mkp.ca.oracle.com>
References: <20260602095931.2869516-1-Rajeshkumar.Sambandham@amd.com>
Date: Mon, 08 Jun 2026 17:45:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::40) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPFEE36F3C1F:EE_
X-MS-Office365-Filtering-Correlation-Id: 87468a8a-bbca-412b-8246-08dec5a733f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BWruQi4CXVmIlFPL9zR+Yn4giZOUQ8khefaJjwLX0U8hWV7+1Oace6R94JLS0tyjRhxLy5VxbvZGf3rsUOz4IVLLVT0E4Y+gPm0FMLgyXIEGHJyEyGkoEqvNltVDWR9BIsrU2kHjbOw5U/uwTWrpXNa0IhVJJ/yeiLvHMyDpuFml85YwhXoBgz/bmdS1Sc4/4WpZGwOZ2uJD3X0yg01ChF07BYzVNAZ11ROQZ8mQW9uQVUmlVGw/MK8wMozDWyzsQx35iFvFxF68NRDz/nrBSEpqg4QZ+TDk9MLq31aj7z3+ewGQAKUcko7kY+QYGvZr2TLsTQrE4z2TOJtWdzaszIP3DXOezE2LnKfmyoRm+x1ugkcGV+d1EBTfJdcsGQZfgVoGy9QWbiSb5eRN3iNKQ4g3qfg3aPPhZs7wJLhy9qqGrX+wE3TYLcnogXEQKOX3DOIwpGsE1zUfSbaDyg7QQBAyBYEVfkcJQqRl80kWAODuoBdvv5HG/TKM4xsI2vzmjMIO4EqNXadLPsc+05uKaZZdPj31dJetpQjtwYwa8V6xsEsbhfbDuUeGwrUoeIrBU2cqOJe+s+xeKRnWKiH4W1szzgNSwCslX78kUOBDfU9VHO9XJvW43WRLPzygzDMJ9eNHOrpaJH5SMUIuD1QhhAZplkxL5Ay6W+SKWRJxT0o0++3QnbEYsaHA3H6lfAdS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IRcgE0XQ4gYS4fJtSceX5SYe+FtwsL0JMAsKgDBJlrt6uvCxOhCMWpsbmTfX?=
 =?us-ascii?Q?7A1ZzJEvw1ti+pVksG8cJzpEuCPsi/wNTXlNU+9x0FHpP4vicWIIuhUSuDdk?=
 =?us-ascii?Q?OHTZniTySgihDQGSTNc/XcvRu8hHM8FL0BrM2ghvE29ue9Xrw3KdtZdhp1tD?=
 =?us-ascii?Q?4ZZKgfzmouRib6ghEjbGJ24Zxpj9qQ+N0mYB3IxBNByCSRfXwnKG8+DhpQBh?=
 =?us-ascii?Q?xHe/ab/Kt/VeEAOLP7CZX4dT++eKnFVENuCwm7zpAMBpzSJKfjv2cuYjrFKR?=
 =?us-ascii?Q?J/gvjdgyDzlXm8iWUsQHEkQT/OKYKHpYHqwDJog9elnrv2aAmQ/LRv1c4Vw/?=
 =?us-ascii?Q?RZdjEg7XD9fN0/Q9+eWYK9KCETRA6OBdKALXh+4h3Oa0lVfH/woHk/a4Vlxl?=
 =?us-ascii?Q?tqBsx3++fHfAiNKBhRtL811HI6MP94aDi+5my5qVgDxxVxl5rK+Ccnf+dA/1?=
 =?us-ascii?Q?bbggfBHZn2M3HElHVpmd+zEe2YlkROXhVjSTKuMfBJ8MFj2Tv8m8u9CJTIpr?=
 =?us-ascii?Q?LodL5odKRrIKTDiVHgHvkGNkbnnzWVTuCzXAYtpi/hjgIwa8lvJ/1RmImMOS?=
 =?us-ascii?Q?xPbO8ZIM3S9Av07uCfxrN2az24z2K/cujshnrRtL2bU4qJsHOQAMY7DaSD5p?=
 =?us-ascii?Q?VB+YtEEClSrHcqGGq8CFAGeR/7p7VcNuE6o7eCGeBxL8+NScFI3Ko5IM8nwh?=
 =?us-ascii?Q?30tCONIkpjnaDRg+I1UCmBdatkNjaGvIwyAVQGzJD9hdK/jIKYrq6OC5aYMG?=
 =?us-ascii?Q?OKOnGTdmucA2PxRlMyH3yhoEz5iXMd7uyt8j/X5zWpJNqMYpyz0wmChvuEcG?=
 =?us-ascii?Q?ISTF7Cfs3uGLh6ipWmQyL5QPq+AEhamgYrIeB+EHw6IZ5/r5RtXxN7UDqoqi?=
 =?us-ascii?Q?+Uchv/nkNI1wiCBSZplUKqHM1UJPil46wyoGm6klcZ1YQmwBATBE4jeyNU2O?=
 =?us-ascii?Q?o/DKVQK09R0nv3tfPgROldRv06v7XICjGJxx38TzsvfkdaOZKFCQuW6lRRgA?=
 =?us-ascii?Q?7k617P3AUdyBgk8V8H+K+eHpeO+6gtXbsAZiLcyGQnjd/yEI1F5bnD8e33gz?=
 =?us-ascii?Q?8sX518GcFoiOexjDHD/5z3D4TdqvT91+FfDZVNwgDO/dmJyw9OhUP5WYA9YB?=
 =?us-ascii?Q?4wGyUg/00nLtIm8OMnWse1nVUW6tf9cH42Z5h++lT+tgAi/Cn2cboOx/UkVN?=
 =?us-ascii?Q?cBOKWcEDwVDF6JIXc3dIWFopb7jVYTrOj9R/qIqc/0c8xvvmhselJ6d1Yjt2?=
 =?us-ascii?Q?E1zk7IUC4OiEuBWbK03AiecetiJLJVmOWnLZgxJrkrub82JVq5ef+KgpHlBe?=
 =?us-ascii?Q?SvKjyxRPyq/TJhHVdNr4YR4f+klDR0vONZaCOGmxb8Ez2o/46eaYKsC/W3IB?=
 =?us-ascii?Q?oTaVkv4dtiZZBu2FMrmTTGMb8N9/PoddT2JSoP55V3DgfNEontdx3iGDD6dp?=
 =?us-ascii?Q?rDz1XNV2u4oVjEVkX2QFaCpb1La3PxnJbe5h1iuMAtOGiEH9dZsfeZ+jbg0k?=
 =?us-ascii?Q?9BzG8bHmqWgwVioVrmaWY/Um5clQaVVrGc9MGXeRgR0hfe+J7QmgTcaYpl5/?=
 =?us-ascii?Q?LxsXSSGVXPs/eePTBHqqapyuOGO8Z2bdJDHZI/PcqrLxuHY34CTYAMMwvVxZ?=
 =?us-ascii?Q?NlekI4fD2jFlMr9NxzG60ENNYAo2L7ekNEG/3dtfnegFvFv8g6RsWSR1kxuB?=
 =?us-ascii?Q?dH0NxOmiZnioa/17K+bzZVJTMCAMmxW7Ma8ea/4y09Q9VFgsrhescec7+HBl?=
 =?us-ascii?Q?BAl9JZDhxLXj3l8JfXKtQ0DzpWWemLs=3D?=
X-Exchange-RoutingPolicyChecked:
	rIzKHBIwODxDNgtFRN7Qvw5jkNIpZdgbAIlqmsuuvBECkqniPRm5oPsD8q9MkuAsFTecy2caVFtCVeFmco3tyuwdgUgP0BaYbBpzzPXKm47fSu2IkJK3+1MCELzSRz4BQLaqpr2FYaCTGeBGwtfzRt7En7Qf14ciXOGqhXEbQg9OSDyya1sUlpNL3VKgs61HFu9jln7r9gyDOTJeQePGtk3tRePqT9x56EptvAe8NSbM0FF3uXTCefC+aV2vH1Svxr6WaYrcKCAG0dEEo1nbAXYMgEZFRAwOv7ykuP0rw3mEkQhsltqtipXzCZUF/a8SmmLVnmc+k75hEMWil/dG8Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EzgHGKasfQn8FImtnF3Vf2HAY5qqP4suYZ8T8WrXUAAz81JsGuIydAoJJV3XLzAil9hlNdgUKzXut7lJdTblSPoYWubnUXGFyMMDLg72M/QbHrHlHq/PRwUIOxbM+aZgw/pvsZjd+iLzccYfIHnKmNuJ+62LdgXzbP9O2mT1gFruOVxTWdYfieGXOS2z6EREMfOp7MblEcDUZjyjEzDZh4uytT07se5q9JLgn3n+i28vk9u9WQ3+HZGF4FIxK3w5GY2+6w5ixpPQIwFJh5RId5eouhyeggIP0QnQC9aUvl1DOlt7LNXeRtebpfZZBTtcWdHaAMTM83wWkmrlZOvN0XXxxCmUjIfUlU3N1lE9CXj4qt/EvN/OHfWt5Ss6Y6evi2M6dJ0k2qcuh3w+gfhMG8YVtJjMJOlcjqTf4lKE+bg7rYKeEQYflro5dD2uOzbOXTJaU/GbTjcjvQCurai2ZIofS24GOzFeGe90Fx653pm390TRBDyd+jc9HQlvwo9i2c/jBz6AsAW/loHv0dIM8/Bw/dQyaOA83MnFLenRI4F2Sw8qbebUp28NJos2CAoytsvLOjKDkTaTNK2vXsUAMidsh2ltLlQ8528LtcHXJ4Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87468a8a-bbca-412b-8246-08dec5a733f5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 21:45:05.6553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sns9QqYUlfU43mJd1UkynvGsbADWvdgcBAAEjcixBroyzMeR/xvDWjpPZlXKgbkxTFmf90LsI+fYb/p8DHL7uE4gq7+k4Dddn+aqrWEJ3wA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFEE36F3C1F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxlogscore=924 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606080197
X-Proofpoint-GUID: Z18J80lP9cCUEJIVHRchcKzvcyXoQGaB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE5OCBTYWx0ZWRfX7t1rR3Ka3PLH
 TnY5jserPRFOD30VsEqfe7rlzzQeNlMlzJrKB2B63u82aM6FZBGAurGv9Zwe7ur/+6qnEEcEOhP
 HJdreaQG+9GVQQy0j49MZUYY+hYcNzTaQOuUEOyF0BTMVB5Jmma7mDX95KbwkkG1E8yQeh478jR
 WbUAabGs4h/jQTiivGVpZlJZJDttbliqYvNeIi5hS+DGqC314H5KKvmuV4ZrV4M9NnOWdQvcSaA
 e1YaWK8AlMnEVpdzU9dhq0sT+FiQSdqO/z4Ce7Axx4IQkOKnDH7f2S/ditjt7tWLpQbnPFcS7zo
 YY9W7OIm1Y6s/FGzhho8x83kgsSyHiBqAuVxBIo1P13cNV2sciAwoIJxwKJYZwTnjPJydEd3cUX
 kqNx/NHEReWG2fq4AVGDtBFxUMBJCE4TfNFTedRjO6rSbYsD4E2BnVX/aDKrROsrpczJRSjuKVH
 pPAQ3RguDTO1tkzriRA==
X-Proofpoint-ORIG-GUID: Z18J80lP9cCUEJIVHRchcKzvcyXoQGaB
X-Authority-Analysis: v=2.4 cv=OYeoyBTY c=1 sm=1 tr=0 ts=6a2737e7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=cXXqVfydNUKYWxbBfhMA:9


Rajeshkumar,

> Add PCI device ID 0x1022:0x1B29 for AMD UFS controllers.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
