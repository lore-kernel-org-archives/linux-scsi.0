Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096541B8D5;
	Mon, 27 Jul 2026 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163425; cv=fail; b=HzlFKXBn9wW3nlp7q0Y61gzbwmF4ovYg+LavLExm6DpKkL2S5li+h4GzmKwU096ZmscA9mnE0B/FtSdwwTankZMkNxMGH5K6caAL3tKpa6oD2P14hR2UL1VpwG21hgYxfo9Sw+XXGRURntvy79ewPkphEnuUesHsvS5b5lEwsWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163425; c=relaxed/simple;
	bh=C1CZ3n6q1UpzgG9GGu3PUJdkxvvNmz9NzlJdLBbf40o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XoKXfei/+DD9E74+CdibTSQ1mTtUdsdz5hcAk7q9mTm0xrqbwsfoMuIJuxZTeygVdwCCQxk5zVHysnOQEjUHsc9n+x3oNIv7PbzklD7fJSOjHhskn3/CrXe4uf0S3/B603E6hTEqzsEBvvbTcJX+0TM1/6dWxWGMV1YaT6Lcvfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fws4wJom; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YGEvIK4D; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fws4wJom";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YGEvIK4D"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCV2P92245164;
	Mon, 27 Jul 2026 14:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JV4Ke7SJuhsQLmuQ9ZMvasGHNvPs4H2hnNAreZ5dB7w=; b=
	Fws4wJoms0WTsRK+IBG5UenqukZRI69xipNpcnx1+l0JH/byqS4JvQzS5BlyVQtH
	DCsJaJzFqG2BJZE1yCS91eS0QU8aPNxTWXfceYARG+w0sox2q9j065uygiqsOocd
	0iT+6Or1sYwwQ+v9UOVsK0epHlEY85X7dmhAU3gPMgMwEQK2HczHEtzgbExPivdE
	kK+hLWLlqbn8Bf4WFbJk2fLQe8V1wI8mS7LZafmnBnxh5kFz9EUunz95v1uOBjH/
	s3n32X7uOQ587tqq1NNwCobpSqX+xMnHTQZh6xcAtc55DwRWEGCKrbxSF8vYckWY
	qU+nTtAZ1L1I1UqDA8gvmw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3phxcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeBOW006867;
	Mon, 27 Jul 2026 14:43:05 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehaw70-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvHQV7zn7PQvue7+5CkUgqpkmz4Cwkuze2zbYntsWuo4GcdJMrOb0jML5p9Y5pB+4rF4zW6ALkMCRQ0aNLDYN3vMNixqiuh81+u2ZGdaYDBp3bBONmQK6IMLec/02koqPfhhEU4x8Kt4o4NXMsYzLc/xQ4stpN2N8+zcSwstnyxJtBBKFY4NagfYduX2SSlq3NV+oluZGkL1SCGzapg1K4BlPUMdBSaCSzJQKd6LmitxUYIPHZ7SZA5DEPsM4rbDmk1EElnQfemK0OWrLl33cMXCRszjYfrBmdYYXY1MMDuZATsGu0dYG7wFXE0ez5Qr3fgooM/yItohCVQwJa/sbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JV4Ke7SJuhsQLmuQ9ZMvasGHNvPs4H2hnNAreZ5dB7w=;
 b=zWCD/wBb8KSwHfDEsWAOb0MqIBgHIq5+XtEEfTdJ4i+bcNDR0MIjzs4cr27/ZhyrZ95BY5eEhHlHyRGCdLmRNXu6ZOF/40nWRtB2B3omTDfhBBkiAgldkt/kfmerKCTlB68opE1DBFaHP4nraPYEOKLP71ykKptFp+MVb96fqGJAiaDmcx4jmNma1ewnChpEC8zxFhsYAOqLEXBtC8e3aGWb4MJPTwB1JC3WGjJkEXccvmvgmSqJO7nm3OcUJyAWPfATa3K3EPB+rp0HaTVuZyOOPLpyf822pltfkNhfeUNdcewgTjFyb8Eh7asS+d/QEKgMZTnmbpEzZ8FDhiu5iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JV4Ke7SJuhsQLmuQ9ZMvasGHNvPs4H2hnNAreZ5dB7w=;
 b=YGEvIK4DhHXAfTvgyQs/c1Fvwj9nBy5j7uiUZZMcaaUBP940Vp3UJnieMhXDYkrCcrSbI1OwpUL8zcaoqEp9vEp0YSutetM5sBLs9xrKpni5rJmEC34iJ5xWIVROWp/iQhcvLpZstcmdGfPdZ8eI+khrkOfTv1hQnrmNs1qjwN0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:00 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:00 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 03/27] libmultipath: Add path selection support
Date: Mon, 27 Jul 2026 14:42:10 +0000
Message-ID: <20260727144234.3802948-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:610:1f0::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f07e631-2406-4ac7-ff5b-08deebed5b1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RF9ZwXAd4xw7UK1/1AwOVSHIU0SzH8AhZ9TD7duygELSSdKwg4xcWFfxHx26x5PHcTN4QpOXYbPOO6W+GPE8CsnM/VkRXc+RCZ420AXVFKFky6ZKxLZt/aJTc+6VPoMFskYwdGXZuotNCILY/sdgoD+L4L84rOYoEVL6EsidIHmjCRESlvJrxyVDSL1MhbmnIBHH6/lIv9GiTx0mFlnVdFyizNqXiUJUBGUTaz+ZgYZyubfPmlIWwSIUD9TnNzJphWWY6055qp93ZGS3+ZtgdPqo0x05luWYJwCLfI7F6S8Wlof9YObq+FC0ScMa7o0QfIoZe/SeV7A5Alx6JOGQQJFlLE+H6kB1Gi+bBSfHYpYLKGHzTPWC+cUSnDpiUllh1K0qdYYBdHMSiXW9WVM6/u/Rv2OHbY82vt01glQQMKOqBeyLgOJ76yKbBiKt6OC6JUrjJ8k+dgVuhxSOmy9zCXmvQX9uATYRSGnK2Gmi8DvxTagq08i8l+hatV6+IE6EfN24tNXhC5rCM6ak6qicoh98AK4LZoj9CueALQnd9b5pKUT3ovuK1OW/O2cavoZ7+h8AAXG1Ia9ppRyKR+d9JFNPrKZWukY7g1GH2iivCbY1SOu02nU9SiiSV1Y9BLEkxkyfC4JiyHXOrg7xXu1csTAIlgXsC8mg3eTvxvkgU8k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4vT25g7BPEcOV5cNqP/L38ug59UC6R+fDcxkXNEun/VmpXNd7Cghi1kl8U/R?=
 =?us-ascii?Q?xQxvJ4lLaWug4oKqqyPPYjdVaSSOBoZnn9pFzOIQjtQcncy4CWCjqxwYncpb?=
 =?us-ascii?Q?o4Uv+2RyMZ1hTb0DiL6H2039oOO0FSsGuSUhEDVOKlMrzh1AD/bFIDEJkFMv?=
 =?us-ascii?Q?qJz9iaMipBMuTf2D2QhDUsKONjmkvBcg1F3+hqpLztHozy02cgVEuXag9vFJ?=
 =?us-ascii?Q?b6zp8tSFKJdheTaI2X5bqmdkPH+bIbCJW9qyaEsmCc+9s150K7RTcWGW5R0p?=
 =?us-ascii?Q?l4/XLVU51lkr5MIG1TLkqq1bpaZRVwraM/svW3hRblPbKb+jTm5AnMRBOwXh?=
 =?us-ascii?Q?UCQ518PcdfSVa6noL1e4BIQoMym5W/nh4T9h/Cf5DhTvdtKE5SwE5D1lnez/?=
 =?us-ascii?Q?OvX7YGbRX5aOrd9v39EUYG/JgHRyvtnbOXXvuExgfIfz+xHN6AXSD9XPPfEM?=
 =?us-ascii?Q?J/MD2gIsNRnNHEPJg0wl9y/I8d4NKeP0S2Ok4Ui16UrFiZForRhvaRFCQY+E?=
 =?us-ascii?Q?mJDoXzvL8akhtwb285iVBKNjxsyI3Z+LNV5VkfzD7lrxsBim9jTREzORTaiK?=
 =?us-ascii?Q?tqDicIAHaMgc0KR+w7F4/wSI8RlNY8ZUxeSDMukgnOywijxM7VW6jTBzidMy?=
 =?us-ascii?Q?pO8hEIDgT/dnS0I2xWnEmHV5RDsXtJMbrHuTIrrRxgDninHPw7w5WHxZzxyC?=
 =?us-ascii?Q?mSzXWuMu/RirCOqv8zqfvNbbVU2HvUlTZfHV2Rwe/302k8oMEXTf8twZrlaL?=
 =?us-ascii?Q?F+9yPCSuj1ozfgmRVjhMd2XyfLPyFJcivzcStawHNEStvKnRK1l/n75aGNNr?=
 =?us-ascii?Q?Dx1uoAjNlDrDegB+zRG+GsE53id/aT5SLpGrn9GOqEEXsZbu+whe4NJU4arI?=
 =?us-ascii?Q?LfipjAOqyAU0OMy2uvXIsoc5d7ERxbeujZkAHl1YIliPouc9RORID9f1rRQa?=
 =?us-ascii?Q?EiO3qc4skRdoO3IHo6KMoRYJHPSN4s4oqdZcMF9zYYoQ8aEYbDTLEmnEtl1W?=
 =?us-ascii?Q?f4ZDNJXF7RnXI2rukowrmXfkO0p8R1QTL9f0v9csK6Bd9q4Ubv85E96AR9YQ?=
 =?us-ascii?Q?P6REMoxyXaFYefLhhxEhjqBSfe/8YvR7erew/0T6NeKJEQoLuZVV70NhtJUu?=
 =?us-ascii?Q?A/H6werNsEPpt4GllRnFEiOQzmwmT62JsrNuZpt4h5Zf7gXNVRSot6Q8wwU4?=
 =?us-ascii?Q?Hw4FMn3BgkJgtt5fZTAUU4ynYMULMID5IHUQjiC0/yz8jCLOcq3SEbGMOzeW?=
 =?us-ascii?Q?lhPWcHnRVi59jBBScZKSuxrkEC9gPeEi+7zXnCv77f4MA/hqdai/DDvfrkGN?=
 =?us-ascii?Q?rYyRBNSNCfqGYX81WX/LTWJZzW6Xg1SLTnuOMd/210qA/QgE59VnEGt1jBvo?=
 =?us-ascii?Q?DhTQJOiVNY+lp8dONDcv9fugU9spPM8qgKpBE+L9GC19DTVLZx8DnvRqY27j?=
 =?us-ascii?Q?r4hVcwzwcYZS7bkSAkq+m+23QnI0f/2sW71qyiF3k1xY339wu9HExgXQfC9c?=
 =?us-ascii?Q?ZIHRwod4Kb8kSB9SDXFwLSvWLAmbV7t+Yj92eVJUIwp/+q7AIgooohb5n2Zt?=
 =?us-ascii?Q?G576E805HV1JL+U+xZP4Ef3ywmmsjT0/5waGsOGJ8pAnb16US3dWCKubdhkT?=
 =?us-ascii?Q?qggSKRP6o+ONZ/HTvvwevFruF14O86vQlWTkzMJ+oZsdyyajgI2ZJ2VbQzpj?=
 =?us-ascii?Q?p6lULotValNXXmsBVWktp428f7/H+UnR4y9pifEVndFxi0BRUOmcR44jGIxw?=
 =?us-ascii?Q?b4ti2MwagyOWEb2p5gS+hAEyRcUD6fw=3D?=
X-Exchange-RoutingPolicyChecked:
	O9PaaaCEo7nrJp9LNpydkqRfpxtjWk77O4ziQ1sNfiE+YFlUTzMD/r4e2ALu2CdETZush4KV6zZIQWkvqW5NoLQexgIPHv0/awnwAS4zlhoz4cT1/bA1IPtx9uLSqbifcSrEXyr7IDo8T+iAnMjTRoLMq/o+bzJok2P9H3VH+iC7GVR7XRef/WuPcpEylZdF8byKba3vWKpeHUfxwfm+1XlX6xiVRIG/tVZHlPAIKWP4Mk4fov2RcE1B2UtF0v6HO+CzTPzDKiDkhQK0zFSVCsTxOqvxCYjClwURf/ZkbGXRotCeY7wPJlKjonZy1HLiTDhF6PAoMDxBjSltm9OX5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aUHT7Aqinj7J3b8Oqox0RbbgYyadA0j2vTv+Fq7lus1NkxzIVQbw07CFYPcaoX0WTkzMZ4VWgjI0jYia2w+b8T9Y67VKh0sIeYWtKgTb16Letp7eoEdsJET++5JoE+sXLHb9vKjrvrgvoIOaUeZ0N2d3gO0vNtY0890q/u4C33QV8WOjQbI4xYQJaQ+b94tJiOOnr/Y7E0FetoLCze7x5qA096zTenFsd/g7416HSQq9nKNVOyi8y0nPT5Phip+pN/fMD5OFzWzGwhNO1Rx9rkk0uj62m7/umZzHwNc22/Uj/xo5EcmC8z3+z+XeniiVosgZeRS65eP8qAcouGbs4y0kKAEmYk6n8IDiJZZ05fsEajuaiDvjlzld68ji8kV3eudJruiamsTjJtC8H/tiT9XUXOjKDV+TpFacH7AFaCvUZ0L6v6PWjNsrgSSFXQUYE6oYp124WNSSzvOlEvSjK0pOZA6etmqgH7DukHxkdDMLcfF+C8BWV16PHlwh5eE6DNzpO5yXf3H/oxndtoHA/rr1bPb5CNDBdZqvjAu2JHSdj38+0beiFZvRwTC2dUwhRb/ocdwQ9nI2oDJhAxBIIKRwK4/Skg48HInD5asqsck=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f07e631-2406-4ac7-ff5b-08deebed5b1a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:00.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/ZuUbUxCtvkacrYvl8Oyy8ZYxUcXK6X4kk8ecdgBnUVDNNplg2ZHl+7k1G8Fw1d/O56KHSHSrMJ7A2e+fmT2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-GUID: 2O5JECml65jA7oEaeUMYhpQZ69nJMR1u
X-Proofpoint-ORIG-GUID: 2O5JECml65jA7oEaeUMYhpQZ69nJMR1u
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a676e7a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=Lb5UtHSxAhypNmDEWQsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX/5aE6DgsdNhg
 1I6TCy4X7b3Fxm8vWfDfqeu9XwA5ZEu7NirCUIp7YcqftwtQhwyOpzrzEPvlToFbL9FpU7+7GYg
 ockRR15S9MALscghKoc0FAAzPoERhdOMHxWnXFJdTCmf3H5B0RG+x49yk7KSK77Lfu1GOo/7u2B
 RhqXzyrZTPySTpBxLjVcpGv8ymqGs5qHLEa3Y5/lQBGXo6M2pETr3z9YOiPwbkadn+rNLKR72+g
 bTs+bOhLPYvaSAZlyTK9MUL3MlRJYGUCNff9Hhcfb5FLO4M+zmu02pzYva0r9qME/1D99dWvq7F
 JKdIpJdH1EF6s8r7cyWaf2Sk85p/Bmj6mdlECeCLP7V2DJKo8PSFwRCLnOXWNtzSKwWgEaiiHob
 6d2RNli8oa3pIOwfyD1FVap9Q5WspWHvvXOP6rOqMLblvhdV5HWOXw23hIZXlLU5U05eftVtpBc
 LAqdBBFVpvRHN3foJ3g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX/bgf60Wpwm+x
 DMCAN+MP4eIeCmG8ZzKwtHUet6AMegpCj8DL1uE+IWeNSw3sjXd0muZCwZI3NL+aftLe3mZLIy7
 +WtDQXKazC7jbJFc/cOtnV2zT1YkJwmx0kGeCAIy4qEzwFCnKMk3

From: John Garry <john.garry@linux.dev>

Add code for path selection.

NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
so that SCSI ALUA can be used. Callbacks .is_disabled and .is_optimized
are added to get the path access state.

Path selection modes round-robin, NUMA, and queue-depth are added, same
as NVMe supports.

NVMe has almost like-for-like equivalents here:
- __mpath_find_path() -> __nvme_find_path()
- mpath_find_path() -> nvme_find_path()

and similar for all introduced callee functions.

Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
setting default iopolicy.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  33 +++++
 lib/multipath.c           | 253 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 285 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index ca6e02505be43..9bbab0aa8961a 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,13 +7,31 @@
 
 extern const struct block_device_operations mpath_ops;
 
+enum mpath_iopolicy_e {
+	MPATH_IOPOLICY_NUMA,
+	MPATH_IOPOLICY_RR,
+	MPATH_IOPOLICY_QD,
+};
+
+enum mpath_access_state {
+	MPATH_STATE_OPTIMIZED,
+	MPATH_STATE_NONOPTIMIZED,
+	MPATH_STATE_OTHER
+};
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	int			numa_node;
+	atomic_t		*nr_active;
+	enum mpath_access_state access_state;
 };
 
 struct mpath_head_template {
+	bool (*is_disabled)(struct mpath_device *);
+	bool (*is_optimized)(struct mpath_device *);
+	const struct attribute_group **device_groups;
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
@@ -25,6 +43,7 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	enum mpath_iopolicy_e	*iopolicy;
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -44,6 +63,14 @@ static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
 	return mpath_bd_device_to_head(disk_to_dev(disk));
 }
 
+static inline enum mpath_iopolicy_e mpath_read_iopolicy(
+			struct mpath_head *mpath_head)
+{
+	return READ_ONCE(*mpath_head->iopolicy);
+}
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
+int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
@@ -63,4 +90,10 @@ static inline bool is_mpath_disk(struct gendisk *disk)
 	return false;
 	#endif
 }
+
+static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
+{
+	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index d2e334259f3c1..2b22c74760868 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,8 +6,245 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
+
 static struct workqueue_struct *mpath_wq;
 
+static const char * const mpath_iopolicy_names[] = {
+	[MPATH_IOPOLICY_NUMA]	= "numa",
+	[MPATH_IOPOLICY_RR]	= "round-robin",
+	[MPATH_IOPOLICY_QD]	= "queue-depth",
+};
+
+static int mpath_iopolicy_parse(const char *str)
+{
+	return __sysfs_match_string(mpath_iopolicy_names,
+		ARRAY_SIZE(mpath_iopolicy_names), str);
+}
+
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy)
+{
+	int policy;
+
+	if (!str)
+		return -EINVAL;
+	policy = mpath_iopolicy_parse(str);
+	if (policy < 0)
+		return policy;
+	WRITE_ONCE(*iopolicy, policy);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_set_iopolicy);
+
+int mpath_get_iopolicy(char *buf, int iopolicy)
+{
+	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
+}
+EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
+
+
+void mpath_synchronize(struct mpath_head *mpath_head)
+{
+	synchronize_srcu(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_synchronize);
+
+static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_disabled(mpath_device);
+}
+
+static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
+					int node)
+{
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct mpath_device *found = NULL, *fallback = NULL, *mpath_device;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+		srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		if (mpath_device->numa_node != NUMA_NO_NODE &&
+		    (mpath_read_iopolicy(mpath_head) ==
+			MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node,
+					mpath_device->numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    found = mpath_device;
+		    }
+		    break;
+		case MPATH_STATE_NONOPTIMIZED:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    fallback = mpath_device;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!found)
+		found = fallback;
+
+	if (found)
+		rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_dev)
+{
+	mpath_dev = list_next_or_null_rcu(&mpath_head->dev_list,
+			&mpath_dev->siblings, struct mpath_device,
+			siblings);
+
+	if (mpath_dev)
+		return mpath_dev;
+	return list_first_or_null_rcu(&mpath_head->dev_list,
+				struct mpath_device, siblings);
+}
+
+static struct mpath_device *mpath_round_robin_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device, *found = NULL;
+	int node = numa_node_id();
+	enum mpath_access_state access_state_old;
+	struct mpath_device *old =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+
+	if (unlikely(!old))
+		return __mpath_find_path(mpath_head, node);
+
+	if (list_is_singular(&mpath_head->dev_list)) {
+		if (mpath_path_is_disabled(mpath_head, old))
+			return NULL;
+		return old;
+	}
+
+	for (mpath_device = mpath_next_dev(mpath_head, old);
+	    mpath_device && mpath_device != old;
+	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
+			found = mpath_device;
+			goto out;
+		}
+		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
+			found = mpath_device;
+	}
+
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
+	access_state_old = old->access_state;
+	if (!mpath_path_is_disabled(mpath_head, old) &&
+	    (access_state_old == MPATH_STATE_OPTIMIZED ||
+	    (!found && access_state_old == MPATH_STATE_NONOPTIMIZED)))
+		return old;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_queue_depth_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *best_opt = NULL, *mpath_device;
+	struct mpath_device *best_nonopt = NULL;
+	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	unsigned int depth;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		depth = atomic_read(mpath_device->nr_active);
+
+		switch (mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+			if (depth < min_depth_opt) {
+				min_depth_opt = depth;
+				best_opt = mpath_device;
+			}
+			break;
+		case MPATH_STATE_NONOPTIMIZED:
+			if (depth < min_depth_nonopt) {
+				min_depth_nonopt = depth;
+				best_nonopt = mpath_device;
+			}
+			break;
+		default:
+			break;
+		}
+
+		if (min_depth_opt == 0)
+			return best_opt;
+	}
+
+	return best_opt ? best_opt : best_nonopt;
+}
+
+static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_optimized(mpath_device);
+}
+
+static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
+{
+	int node = numa_node_id();
+	struct mpath_device *mpath_device;
+
+	mpath_device = srcu_dereference(mpath_head->current_path[node],
+					&mpath_head->srcu);
+	if (unlikely(!mpath_device))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(mpath_path_is_disabled(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	return mpath_device;
+}
+
+__maybe_unused
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
+{
+	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
+
+	switch (iopolicy) {
+	case MPATH_IOPOLICY_QD:
+		return mpath_queue_depth_path(mpath_head);
+	case MPATH_IOPOLICY_RR:
+		return mpath_round_robin_path(mpath_head);
+	default:
+		return mpath_numa_path(mpath_head);
+	}
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -75,6 +312,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -96,7 +334,7 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node)
 {
 	if (!mpath_head->disk_groups || !mpath_head->parent ||
-	    mpath_head->disk)
+	     !mpath_head->iopolicy || mpath_head->disk)
 		return -EINVAL;
 
 	mpath_head->disk = blk_alloc_disk(lim, numa_node);
@@ -130,6 +368,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		}
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
+
+	mutex_lock(&mpath_head->lock);
+	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_head->srcu);
+		for_each_online_node(node)
+			__mpath_find_path(mpath_head, node);
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_head->lock);
+
+	mpath_synchronize(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
-- 
2.43.7

