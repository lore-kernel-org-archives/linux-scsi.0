Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3E431D386;
	Wed, 10 Sep 2025 02:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757470649; cv=fail; b=iHlagWM4DQ9THttV+G6Uiyioyq2Tv/Kmlgmqsd2aMvyzTbPgz+snliKp+TDU9TAYgAJm0lOBb34wbt6i9jktESdXBe9QJs7XG/gfTjocvOEk/oTl7/HW89jNMayDESSS5AIYbr9GrYynjtYgWyFiUTET/v2/PIGg3EPhP+wDEdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757470649; c=relaxed/simple;
	bh=CR4DZ3ardLVWbPawC5tzmO0dVGPQdtRucgBzRWkLS0A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uULyYFGM0LpCWasljPcjlYzGHKW1YvGBFHa9sZg0zsMIrPgqFfyV1ROpgseK4xPfKyDLT0VxN/G73io4wgs84QgonWHQSkMrvzJVKeBQYbNAiVPPSPFEzA0A1SB/LMvTliQ/BwDz7PS0zdBJ86nUm/olPA13gSkzjFjtIaH6WmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=efpl3Tif; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IggjhSKv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="efpl3Tif";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IggjhSKv"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0dcE004358;
	Wed, 10 Sep 2025 02:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=f3wqjfe+Tgu18RllPC
	EJ7p0GT/K6dCr0y/8s4yo2mkA=; b=efpl3Tif0GOIrhQnbVIGWbSZ0p9lZucQ87
	tSZCrCk5BirdiX/pn4vymJSBdHwFX99shggKPMT/AANWCpRO/XcAb8sxWQDaSvv9
	4RmPCFss8Ag8tdqc2ihrLERdMj6+aucRPFFQc01+ir/5Cs3yJAVNp+z8yxrj4Wsy
	jimehaTEgGOcFkRzitJ3AlMHnPDeOo+RGm8AkfBXiy5wQ1df7Qod5tpJltKzmbe2
	ldYcwdGCJ0VQLBWS3SoiPW5GKLvsJD748mO9qs1pza4vsn4X7bRfNMn7ywyWY3oS
	PHinkKUHnrQ6U6+juexToS3lQiYtP8vgxngZUAo2SWr8xm+ZedmA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49229636vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:17:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A03X2A032858;
	Wed, 10 Sep 2025 02:17:25 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013023.outbound.protection.outlook.com [40.93.201.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbctp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:17:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MapbJJ51q41YyoeX+Ypg9G/p2Y5BbDOCc6+JH7cNhc58+7RUVCOZauKFfDD69kpDETUOe/0NEwaJFYsC9k26bpKn5ilCfhwq/lszbnb5Rr/WWIHr7Xz5n6zlGjp+O7epGgba+phrUd/YNNie03zdpumPuo4XPmaqYnc+rPQ/zAdOfr+COf2Glyk/CWFc1Mmq6w7RWeumelDeqGhYwBAVyp0rgRFmeSmJuM7htDDCqd3STwdm78EtKodQZ3TlVUEo2Ih8E83k16zqV11hGDt5wQjac/ai8AYVxoxjsv4GzjXsRiqJuj2I9Nv/a/UaDEj7GozY19rNaMM0rEWZ0Mg+hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3wqjfe+Tgu18RllPCEJ7p0GT/K6dCr0y/8s4yo2mkA=;
 b=E3vTU9YryuaHqcLhd3FfUIuHpL8MA46TDUEvncsWq8iHtrlA3oampxtLZ/qQcQIq+x+lQGxAtO3uVq5+0yCayP/ffBb9cmdv3oR0D7nAPbFXUH6qoq4vOBgDP9WlGyRHlcLwvY8Ih7F1LLHO7q2KNtXuhpjaYLXulmoUCUVvmEVn3eBt/JGbYnDMwmdLvQffAXQesVjfiRCuvrSjpnEcq76hbxS09M+U+OSafx4pS+fvrNQfDc1EAv8CHCU2YE5+k3328oEio+u65p8ZfdMzvQttTrv+dwkk1eB9K5WxdwsUWoD7Tsvy8Z+cgfQTo1SuAJUf6cvQZpAUY/BZTn/SZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3wqjfe+Tgu18RllPCEJ7p0GT/K6dCr0y/8s4yo2mkA=;
 b=IggjhSKvIGxQ58072AcGyArtC5GW6g9ryz6wOpPujl4ML548yNKmgLCXWFKGS8XzhRZWewWDbS1IvatyaeZUyPq+YozZP6pBo84wNNMGOk7TF9N/VCi6aRBOUNkDfglfgjcvpfy3VSwjR5ymec3tRsnwy7aKCV3025LJRS3fUH4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPFDB583D803.namprd10.prod.outlook.com (2603:10b6:f:fc00::d50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 02:17:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 02:17:22 +0000
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: lpfc: Use int type to store negative error codes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250904132351.483297-1-rongqianfeng@vivo.com> (Qianfeng Rong's
	message of "Thu, 4 Sep 2025 21:23:51 +0800")
Organization: Oracle Corporation
Message-ID: <yq1wm6759w9.fsf@ca-mkp.ca.oracle.com>
References: <20250904132351.483297-1-rongqianfeng@vivo.com>
Date: Tue, 09 Sep 2025 22:17:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0189.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPFDB583D803:EE_
X-MS-Office365-Filtering-Correlation-Id: 7af4844e-6244-4746-93c2-08ddf0102d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u9FzD4qzcSoVg7jGhY2JU1/zTF/fj6j7/WjddcDsS4L/BlTSyo/v8REsmCsQ?=
 =?us-ascii?Q?HSNWBXH0r8jVUqwqku7KNQoZpcDLCSgGg3gN7k9To/IRu7Hn3nXKsSlxJNTp?=
 =?us-ascii?Q?1VjVoF3iPWZziuJK6Ap9fuQe39LOMbLwKCxhWqDaTAfmufFAAeBdF02NZ7I6?=
 =?us-ascii?Q?xOm1mpORD4kRPjM176va/VFt3P+nJSZ6+EyNtAWh7OXkCdUlPztAoNLnA+Ad?=
 =?us-ascii?Q?kRhZpH0ud5MnW9iCrv1q451jKI/idnf34cZXUM5T4vCjl3QIUs0N2YcHl+Kv?=
 =?us-ascii?Q?UNQSaiTtjemb7z5+nHAdiNo3qKPN4cDj/2uDWRXinGYd0Ju6Xa/b3XUWryFn?=
 =?us-ascii?Q?ZFjMlR26q0PIaiM1yRWASZfWOx29dUywrasW/1fYWRvnADnBr3u4NMFrrYro?=
 =?us-ascii?Q?STe+MRI6DCxYqtb6hkcxhTYB8LViJzVZ4hDfD23JSehx3YHYZzP2JaUiceEr?=
 =?us-ascii?Q?nvxPbLNbuVnO91dzpyW5UMFhqv6di48HGwwyEPq3sS5ajjxQ3Y8iWIDOeKQk?=
 =?us-ascii?Q?Oz6lZBbMNw7gyzNDPL3dKO6i7C2KJG7xyb5+nMPf/W3axNMNUcB0KGoeDIXv?=
 =?us-ascii?Q?YvKgJMg/Ktqw9LPJap+NJqiWI7HXxeErNkfqKc01MSDbuYxL/qcUWUKaQzmz?=
 =?us-ascii?Q?dW/agaeCfz8WDSdpUciHxwX63ZvQxp1Q7mlPrErOGvY8OW0nFl/BcakAdU0V?=
 =?us-ascii?Q?dnyuHZ9p5/ND5j+4OGlKqTxiLOXWZgqAWdP+nrAcZsmcnZh6CUG5mWjbqGZG?=
 =?us-ascii?Q?mUkuaMxTwXX2o2zrfnnHxDc2iBm9ve+KafMY1bcbpWTCdQJlYAwNIFtkhkxY?=
 =?us-ascii?Q?S9CcCwIvlYES30ip3HarLpDfOKETd1vqpRfQASgLFZukjNAlzbWL23307JPa?=
 =?us-ascii?Q?z9q3t9SwxsDE5K8df3OgXFPkuGxOYKr7x3OfEU9U1o3AOat23F1yioUpLuTx?=
 =?us-ascii?Q?Ws0ED4HnQkp7q37aaw3w+srn/VXxng/1HGtwmkMCVi5F1wsHovu+sMQKrXQk?=
 =?us-ascii?Q?qGSGCLFUvKbGqaiPt8XwzNr1uy6j1rzE+qDL1Arf0z8wEY/QHl1xs5R49Z0S?=
 =?us-ascii?Q?7eR1/ygELlHTQxtvkdfIFxU04l6FIcnByE9a2H4Gjn88syrD2Z8FvjQQCIQn?=
 =?us-ascii?Q?UcIF8nE49v5tcB+Ybzo/7fNBbeQ2DeML8Z2Wjxk1wYUzDWYKf3Vh/6PqfxM3?=
 =?us-ascii?Q?XvKFhH4jAcwCPTHKW7NtP/KYXkTOCsPpyZAe9vOcrNYkrpM6wYwJqU9CZ6Cl?=
 =?us-ascii?Q?0YPK2lcNOjmaphloMi27sgMC8GS6LCnPUNkQRPhcHRHYg6GyUwLjkZlggbh3?=
 =?us-ascii?Q?C9NMmhcW6U3ee9nXu1shocSy3vMlbJvQfcY5HrxZeUoPj+3XAqk+BOPNVOg8?=
 =?us-ascii?Q?lpAGLwtjWY/btVASIw4yX6OOLXTF/tbyjd+wyRJ7AqH93Ig78b6aBtnjtO5x?=
 =?us-ascii?Q?sRlppeFQGpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yY1+6wBMytyintULgA1PJLAq5LbmOciWQet+6AxESNHgra/VVTmE3cvyShDM?=
 =?us-ascii?Q?dWGdvPkPeC7UqKfH2TtqRblEVr2xupwD8H6onJffMxydKeryr8kazos3/MmE?=
 =?us-ascii?Q?w19MSorXNMT3ZHsahuDHrZ3Qw6PA6ei/g1QkkouBh2wp0KzlpPkYR16SCGUj?=
 =?us-ascii?Q?DSCuo7krDwinwRvitcqm53cNN9UVxL1+re9sr36LZdgBORczvQ+PvFvYBuCd?=
 =?us-ascii?Q?hBwo16YwkUcJg0y5J7TUZNP74QgP+G1M3vwyKoUAahPZ90Bip6GUrXnmGUSa?=
 =?us-ascii?Q?c9FNjlYQykv7npf4TQ5T+bZYhxEPpcai3TN3cfdWxzwhIxp3CilPs1duWEIA?=
 =?us-ascii?Q?EWM9+/+eEgBsJ6wR08w+v0vf1Y2baDe7p5bxZMAJDMDnvruuxZZr3IbexRpi?=
 =?us-ascii?Q?pYvB5hBTtdZ6qtKxYnUpBLPKAFZzZkxzQvk4KROUR6fFxrFOXYwiETXSAl6F?=
 =?us-ascii?Q?9Jw/SgJteD/OmVON05oi7ijx68gzuofd1kKeYPXgZcaGUL2+nzpRIdmyn/q5?=
 =?us-ascii?Q?EVKCc6L0n1Nnf1xEAxzGOck8ObEZzTjp2BQurc9N2pTSnSqsiGC4zURFTQiu?=
 =?us-ascii?Q?13JlVXm/g72Sl3fIiHkqePwlvPkoZv9tut0qiGGbD4JDUCW/oG4VplpKFbp2?=
 =?us-ascii?Q?u63nDMIg8lEME+0fSLwnDZLpxP6v9sPlaBfEanyzK5lhz9pICwiSjfWH0DWF?=
 =?us-ascii?Q?UbkF+RRsBdIMqd6yKuN05HkiiwAb2h2lu9tkri1J2l9nWPgBzZiR1mbtF/is?=
 =?us-ascii?Q?3owzURuaPLTbIoIiVcHY9rDHe+dJyrNbb9ml06FhhR6CXCYDeQgkq1RP9t6D?=
 =?us-ascii?Q?GDIQttc+1oF359fQyHPX9XeFRSCEjzWq2HG2wss6fSIQXrqqRu5x+zazc/Os?=
 =?us-ascii?Q?TtL/nKTqrbJ4sqvZxH+++Cx5bLl0VRzaw4X7sRJMVNBS6ejnrP3Me9N/gpk3?=
 =?us-ascii?Q?l35mQu7ZyafVMRNO/Tde45PkJcSZrpBBEtbLxoZ56mHmwQkPayGulAynuvVv?=
 =?us-ascii?Q?QSeV4l7yYib7awsdVVIkYk57prhbK0x09ivfQJEvD5Qtax1nmeNPbRjEWZmo?=
 =?us-ascii?Q?GgWJ7Zpge25VOrBaT+kPs1lMOLyIDMkNE3r/OqSlItZ2hAiTd11OeCI/PwFi?=
 =?us-ascii?Q?oMCz79ySMayXf2xOO4+lh/4tu472eqli3h+iZ91UYJ2ru18ZdrmEQ/PhJjjF?=
 =?us-ascii?Q?K1ANh8BCn/0LpTkCqZcxk6CX1SUykvxKk+wNdGkBdKxlhSMB0X7Ww0WFtwOL?=
 =?us-ascii?Q?jBwghbNxmij56QuvXS+MpvEmU1kXKaznjL9Yygl00s3che7NlgQqKmABqMRR?=
 =?us-ascii?Q?YdmT33a1c24CLTcXnvnxIljmiU8rJ7zSzyBJuPI+NDvfzxq/8f6X/JspSxtL?=
 =?us-ascii?Q?aWM1PmlA+E8QYR1JdUcGqTWNeWbnTy7z0Q2LSZzaxfGFwzqmUyJhHyfjlCkO?=
 =?us-ascii?Q?XV2qgdBnBMori2RljzwN8L7GPudFLRa5jEjoCYK9nwovamEqAXF5SBWbj+SP?=
 =?us-ascii?Q?Pt898xb2ct93b3rp6DchnpoUQpx/xg0B4yX7IpAwQ8UYDRpAChIjpilx36qY?=
 =?us-ascii?Q?CeSljy5RL3u1U4CWIAkmS8+6Yjnl/X8UWNLboDJcnvm+38X2c/vLQk4EEPef?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VYVXHvVu3Ja0XEleJ8Iz83xVhggGUmPfcoVig7RegIxjozq3kRBHnntPszqWq+whmsOaqAZwAPYzJY/GJVtAPVdYh+B9qeFPzlYyNpBe7LoEsXJdW14SVIZ4G/YxZJ0oSPYVLN0roSjjNEjVLfTdwxQPe9i2I9ET55d0fwJhv1lgLBfGtWsjtqtgIVSavIPRdraWlrkdUdBleAfyIAKmKS/4axIzMp8jzNFHi0mGjANVtvwlV4zmwC79VU7Wgog4C0qkY7Wzprm5zDajYZFwcKCaTslfKa67EMqPJ+bws8v6fzi7sMhEWBmyfF4d4OfaBVMwxH37qfXH4o0/g4CyJkFIRt+j9jrnIkcHEEVOwxqcLCOZ0bRu/FINy1obQCoITNJriFgKAowuNtB7mJ6zNK29/Li9yAqqi8ZJiu0kosZTfWzYT4hjCg4krHIF3ipbGJumFhHw22JaKtiwVlv6GaAA05u4bJX8bMYsrycxWK2cVQVcWBhfr/DO/ChSkzvhR4O+Mz+q4rg7Ac1ereX/ctFuWcdYzz9XXyOPQ0Igjhn3wMXELw5EascpYVmO0ylw6KhK+XRC2LB0/56/5M5rCHJ1w+YNU/ekp7Ge2sGdwPQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af4844e-6244-4746-93c2-08ddf0102d2f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:17:22.5850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMwWrMWgrb8Sqm9iRfc5csxGwzm1d8VdwXxAdoC0big1Y44d9DQyhDdKzbbHYawg/0SzLdggFVrSPCnxB8hP23Cid2X3hH5OQq3fhR1FfAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFDB583D803
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=694 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100016
X-Proofpoint-GUID: 7g0dIccYeTXwE21zrPEEbLWishyqcSGD
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c0dfb6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfXwxR3QjNt9LE+
 uX655gpCDU4WZMM3YEKm9G+0iTReIuwinNI2j5cf0mKsTP/4Q2i4fj4tq7GJYAG1wYU1sQO7hxX
 +jPpYLYxE3maWAUGy9TGTvcnwwmHa7ZYqMEKX3VWY02TAjHlwGPrsLo/wxroru+rwfskvubMgEA
 XMI0FvaaGCwMRNRwHSNAqgu3pf4ZaHK1cq54BadFRRrk3MFX/rrJQSIbjgNPMv5sit27xme3pL1
 zf80H47IsQE32GuoDXFT+oCCnR61JrMt3SZ1xScL55aEPQtg7A+184WYSh9pnQW9UNk4KMsbCY3
 uaSG7GqAn3BldLuA1OjiOsa1iwRUKXdzdPflpZ4RAOe5NzV4cPXTk6ufi7tQuTmpckGG97CTV3B
 +32e60je
X-Proofpoint-ORIG-GUID: 7g0dIccYeTXwE21zrPEEbLWishyqcSGD


Qianfeng,

> Change the 'ret' variable in lpfc_sli4_issue_wqe() from uint32_t to
> int, as it needs to store either negative error codes or zero returned
> by lpfc_sli4_wq_put().

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
