Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100221C6B8;
	Fri, 11 Oct 2024 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728658147; cv=fail; b=FsGl77y/vItv47x/cEDrLqMPTL8iX8DDeyR/wY+nJ7j+TfksGxAw/I900gZR22gwoyzmyP3ULq5/0ZUEN/VbueB8SS24jj35de/M43JoSkmJlmko8mLBWgvX/JaWr2EfpqhCi2Mhu7dQI6rp5RTXA9WaI/y983XTJGT0WYlZTp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728658147; c=relaxed/simple;
	bh=x/Zv48denf7dEqsxsUA6Vd76S3rlnrDI4ueMwAD/5K0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tY7Zjor0BuwIASavmfeXBMEVk2TkmWNpFUzTjBaW+R+dmZdIaGAWfGzzofUsy7jQJ+MOx2huz7/p/agCUZM/Esj3cFqGHkF+ul2UsMMSyyDC0Q8Amh0MUzDBkTHrmvD8azHHazc5TVsDaIrWWn1u3TJR7ESJjUPtOdiHOdClsT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mr9M28Ln; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wNuzo9dZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mr9M28Ln";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wNuzo9dZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BCpWp3020226;
	Fri, 11 Oct 2024 14:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KzKhx4k+gncUVqciIZUrDoUn0fOhlqjxMf+77FvDmjs=; b=
	Mr9M28LnJxvOt2geNlfl4W7p/0oKC9RlKaVvMojFIXwQQSy+IcfQ4zNP0u8zGNHR
	OBAl/4trgPe1JGJpYmrQKP8Ac4AUftcZtebGMdkusdcTIvva8H9E7HgTB1SP43W6
	pzj7Mp9UGh1Q3zJqXTv0M/OMgs40v0SZhEDR2Krq0LiFmXgrTp90rmJzOxSxq+eT
	C9Du/HTyt1pDh82ZYfcuO6uVEX4Zx6H2NmboRHsZKDuw063MIAI2Mh8KZilNafdv
	SOUbwB9oHq7XTYVRopumXlTVF/neq+Ek8cWMUOVMPlR8NTl2UKn9tjZD8SsAp4SM
	DVozBIHnIqilTJtvbG7AZQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42306en1dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 14:48:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49BDxh6d033347;
	Fri, 11 Oct 2024 14:48:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422uwbcc86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 14:48:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFpJmyTIzeKuVB7HOkyYZZYg7JKCi9YSpY0MalsTjsidBNQN5yqS5jXgNdl9cR/q0Byvx8aU/ArjPRyMEhs/nKn+PBplW4A7JbJlS6klqAgIGVJ8oOyKqflFvVVnyiLDOLf0hkJSUIMqJqrUHOjZV+jD/vuvm8dF7V0LtKpH0W+5BIVwU3VV8KE79NzVeKzcZgPb35NbufC3h5K1DAcZRDhFQV8ARlKoD2PjJD8Npf3yHvBaxIQ/tz7zWijP756TKwm3YPtPvHVLXtnrMwmqhLNrkKi+GviSf3+w4ls9AMSRyeXUAIwwRlZVdUjCk/IzykApI/zhDBeuaQ5Wo6dRxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzKhx4k+gncUVqciIZUrDoUn0fOhlqjxMf+77FvDmjs=;
 b=UVm5bvivwfxlxXMP7Yvju+Df2ndwuHGEHYuMrM9YH4vU9SD26JQ8r82ScWBdcr7jICdVv4AUNn281Cp+cLvBhZypKuo3mh038fJxGIRmv5nZasLaF74hRT6updCAEN496i5X9CXvvPO00xbEd5zfl6hefPRa69WdTI4BLs4ccVSfzOZO5zlFnpZ6grIdCVUaz6Rn5WWqNGmHWZzOJPnN5PxkOK41Hctr1bB61Oh8PfpajWqg7zQggS2psGc9DOlYePAsm9FBirPhAOGtK+l6194b0S1jDCdEYfAOeM8CZTs2sTVpealOwSzGHdaaoU20+DLBDImWZlzNTMUVLNNbCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzKhx4k+gncUVqciIZUrDoUn0fOhlqjxMf+77FvDmjs=;
 b=wNuzo9dZNOv1gun6usd5Wt8VX7QfhGybQ63rQE7CbE3QOfAWc4HQcDFbCPl8Q1xHlPjsndG+YpzVPqdHjhbNkzfDBnC8/p4k3vC0AXK9OXwSEhF5rCydHnGPBnRpPGKmxyDyaaW2jIRAXG59LwnAbO6oQix1WeA8GfaMmIXLkts=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB7709.namprd10.prod.outlook.com (2603:10b6:806:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Fri, 11 Oct
 2024 14:48:52 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%6]) with mapi id 15.20.8048.018; Fri, 11 Oct 2024
 14:48:52 +0000
Message-ID: <ead203fc-abf5-49b1-b34c-64b97d3fecd6@oracle.com>
Date: Fri, 11 Oct 2024 09:48:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libiscsi: Set expecting_cc_ua flag when stop_conn
To: Xiang Zhang <hawkxiang.cpp@gmail.com>, lduncan@suse.com, cleech@redhat.com,
        ames.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        james.smart@broadcom.com, ram.vegesna@broadcom.com,
        njavali@marvell.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20241011081807.65027-1-hawkxiang.cpp@gmail.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20241011081807.65027-1-hawkxiang.cpp@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: 381741de-28ca-40fc-6ac0-08dcea03d29c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0VnN1JOOVJzNmpRV2xWTzRrZ0RubjNSa1pKQ2ZHTWFYZlRvUHdkMnFuQk5j?=
 =?utf-8?B?S1BLL0VlZFg0QTZuOUFBc2U2RVc3TXpaSjNyY3NvYVhKbW5RbndRcDNGWnNZ?=
 =?utf-8?B?dGJ5QTlHV3hmMGkydGNzMUVsNGw2QnR2M05wT2hFS21RVnV1bmhFSnRlanRH?=
 =?utf-8?B?V0RYOFpjdURweVV2VElpVGZBZmYrbm1oRHZzaUxjdlZ0aUdENE5DNThWdEho?=
 =?utf-8?B?cCtpZSthYWZSMjRmOFdQTlVUKy9QSjBZZGRjN2k3QXlvT2o0ZXJFT3J0dUQ3?=
 =?utf-8?B?SDRtNndYb1JwTmszZG5pb3FweisrMEFIdUp1bG5RNmRkbXF1Um5LK0RCVE9o?=
 =?utf-8?B?dGw5STg2VmY0QWlpRnZ2bHlpU0UxbzZSUTFEZ3NuN1RKSEdVZ1JpbnhzQlJ4?=
 =?utf-8?B?UHA1dmRjN0VPbVhDcDkwdFhxZk1IK05iRFkzL0xLMkhZZElndzdKZ0ZsOTBV?=
 =?utf-8?B?RCtaKzZVYzRDa1A1QnNkNjNIKzk2RHhOTC9oYWNLVWwwQnZmc1pRd3BubitB?=
 =?utf-8?B?bzJ0VTl5enFpMVlRZDBIQzZIUm5yaHlBY2tVRzhobjBXV3REckRQN1oxZDBY?=
 =?utf-8?B?OTZhUTg4VVUrTzFUMFk5Qk0zem5lYVdiVHRidm02NEhlQzl1dU5EWktQMW9u?=
 =?utf-8?B?cHdWZjQ3dFp0cmJzc2R0Y1lwdDUvMGkwcEN0eGVyZXYxRmdlVFlrcXp0bkRK?=
 =?utf-8?B?UDliS0NVcXp6Yk5TUU9OVGpodFdBUi90Y0VlVmRZT3d6M3JnR1AwYU5ERkdV?=
 =?utf-8?B?bExmbTJaUm9lQUo1RjVjaWI5a1hUZG1RSG8rRmtVYmpib2lpbW9DMUxNMEc2?=
 =?utf-8?B?b3RHcTNRZVFYV29nTGc2QWlLcW1oZWUrekUwcDErcDhQVGxOTU5Fc0lTTE5Y?=
 =?utf-8?B?Q2pOdlpaYjJubUZTSGs2SVNORUIza2FoNjhHRGpJOCsydlJXeTFnTm9adkdI?=
 =?utf-8?B?VXJBWjR4Y1NjcmM0UFJ5UnpNdGZHT2oraXRhQUc4RWRmTG5aV2s4T3A4bVJT?=
 =?utf-8?B?d3B6aisvbEIycVc2UEtSSk5pd3hwTGxaVmNCWXNsMjMzQjhYZEg1NnhYUS9X?=
 =?utf-8?B?a2pqS1g3cExLdS92UU5vMElFMWJrMWlpMkx4anVWeDhSVnFOOFJUbzIxRUxT?=
 =?utf-8?B?Y0VXVlJLQ2FyTDJjc0paVG93Z2Q3RjdMcDZaWmxJU2NwaFhSQjJjMkZVSUs3?=
 =?utf-8?B?ejJNZ3BQUjZJQUU5RU9LZ09STEExb0VBMytiVWFrd0VKTGZZTzU1Z3V1dkFM?=
 =?utf-8?B?eldsMGVHRmtpQ1FvczZHRDRqNWtYR0NnNTI2ckFwU1NERlRQbHk5NnNKKzM0?=
 =?utf-8?B?TGxCMlEwNlBMZTZab2hjZHE2aXd2dUtwcUkxdHl6aFpKanlGaGw1M3BxU0hr?=
 =?utf-8?B?cml6VjJhYlpORlNkM2kxeTl1MzRZbkJCUkRHcU42M09zTXJpVExXZ0VIWmpS?=
 =?utf-8?B?aFNrajBVNUZrdzB1QklDR0ZmZGt3M0MyNFRiME1rUnQ0aG9BK2ZNTXpWSjk3?=
 =?utf-8?B?STB6L09hamRDL1ByWitrUE96NXJ4em9ScFdhZGQ4UytHYkFaWlBNNmh3OE5n?=
 =?utf-8?B?V0wxa3pkUytlM3B6SG1YV3JsZ3VvVFVFdUNnYzdZUzkwQ3RmQmhBaS9yQU8v?=
 =?utf-8?B?Q0pFVU5mMDE3MngrUHdoVDBCT2xZZTRVZzlQWlVYZUd0bVhRNlkydkN4cE1V?=
 =?utf-8?B?UW4rZUNzOVNXakNHT1h0QmZaZTAxRG5KS3BWUG4yYlptNHV6dEVSamZ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVVscERISFVtbTJZYnViRVFMbXZNZ1hwMUlEdG5mOHV4cmt0TlRYL0FTOC83?=
 =?utf-8?B?bGw4bkpkWDdUYk5uV2FmdXJQR043eStCSWFsVWN0eTJhV3BsUW9hZmpRcXhr?=
 =?utf-8?B?Sjhxbmp5MWNGZzBLdUNiSm0vVENmVzg5R2Roenk1TWdjOW5TdXNBSUVEc1lF?=
 =?utf-8?B?L1ViR013d3YzSEJ5WDgvd0tVek1CL0V2ekpzZG1jcHZENEtkV015eEtqR28w?=
 =?utf-8?B?YXRZVXZGVmZQTFAxT1dZSjhTZmx3ZnNHWjZkSUpsanpVV3hNNnkxY1lwRUVj?=
 =?utf-8?B?YWZsY09TVWd4c3pDbmR0UVBGTURWSHJ6SFlZM1JPeHdQRHM0TU1Dd2NPbmxV?=
 =?utf-8?B?V044NlNXYmdFRitXanZrd2hvdmxML0E2eUxIY1NoeUVSdmhkZlpoMnZUZm15?=
 =?utf-8?B?MzdwVkR6d2VyNDdqbmIxSWlvLzdCR1NvMTlETC93aVhlOGNWMHNPWThiaFNR?=
 =?utf-8?B?YmVJNXc3UHpBMCsxWE5wQ0ptQjlOTmNoTCswWkNGZ0lCMFlTYTNGZEVwYnQz?=
 =?utf-8?B?U2NkVm5vLzVuOUJWdmd3VCtjVVhpMDByUXBOUkxVcVpDbDlpNGtSeDRLQStk?=
 =?utf-8?B?WGo0WUpIQ0lhWk84TVZYRzJreUZsUC8rTWZDRUZQK01MMWZPczc0RzlmTDNl?=
 =?utf-8?B?ZktNMUx1Q3dpUTJrRG1PQ1FnWmk4dVBuSERqb1JqT2dESy9tSnpzdmhvaXR4?=
 =?utf-8?B?M3hRNnRBS1AxZzdUOTZIOUYzdHRpdEtlUUR4UzhyRDJzdDZsUUxhZHJJek5u?=
 =?utf-8?B?OGFRUWxGcVp2QlUyU0cxT054Z1ZnNExQdHdrdVpWMS9MZUpjbnNjZUtESkgv?=
 =?utf-8?B?TTBMWWlXZk1MV25mTFdBTytXYkM3MC9vc2J1bWNkWllIY1l1dUU0NVJDNG4w?=
 =?utf-8?B?ZEdoR1lkUm1ZaFRraGVwVlZpTlpIYTFFUUpKZkE2ZEVRU3dNOC9zRk5GUlhn?=
 =?utf-8?B?VGFSMzVXdmJDUFlHQmdJN3cza2NTRjZyNTJ4MDQwZXV0R2VDOUU1ejVnV0J1?=
 =?utf-8?B?MlRDb2UzeGVlQ0ZBeFhmNHVKMHJPaEhCSlJwdkRLRVhzc1l5M1ZqMVkwcXli?=
 =?utf-8?B?M1JxOUI0dWZVcUREcEovdkk5VzdYNGl5QmY1VFpFRVROdmV0ZVRXVTJJUHBs?=
 =?utf-8?B?Qlk2RGFFTzJWYjVCVGluRnljTTBOaTAreVp0aFNJTkxLU05qd3dUaGxBQlYx?=
 =?utf-8?B?SGtIeUc3OWVsbmxaME9lNDNSYnR2a2RGM3RnWlAxMFIyeTFsbTNpdzd2VTJp?=
 =?utf-8?B?bTBMRWh6anpuek51S0FSVHZLTWtJRG05eTYyMkxCZU5EMEhtV3ZhWHcxOW8y?=
 =?utf-8?B?RnFKNFRLRDBBdktFMk9iRFpVdFhsbXJicFZjdEt1azkxY0NyakEydHc5cU93?=
 =?utf-8?B?S2owL0l0VlI1TTdubkNsdisvaTJTZ2U0M3BaTnV1ellCc0o0V0FzLzAvYmsz?=
 =?utf-8?B?MVhWMHlYbGlxV3hxeUtxdS9pTXZ5N3RMa1YvQ3RudlEwWWlVdS9ERTR0ZGFM?=
 =?utf-8?B?YS80bW0xZXhpQktTY1BvdjhEWWw0MENFYVZYa2FLMjdxUU9sSWlSYXZEcGdk?=
 =?utf-8?B?dFkyb2ZkelFxRmlOKzVwU0gwUTl3UDFVYWc2UDdqaHdJTHRlWU9PN3BxbzB5?=
 =?utf-8?B?NitQYmx4WVZKS2dUQnBVVGFObG1vL2ViNzZXWTgxUFo1YW5WanBrZ0h6by9r?=
 =?utf-8?B?aW1XT0Z4V2s0ZVg1QWdxT2EwSHdxWEIxTFVYZ0pobHY3VzBIWHBiSjYxdWp2?=
 =?utf-8?B?cVhkMVoxVE9MRmNwSk1FdkxZNlZJQVhEcG1kdnBHdVJXZVhHUWZrSkEzU1JN?=
 =?utf-8?B?elBKbjlvK2NQaFQyVERNTUw4bjhpeG9Ca0dONFhKbU1seTBWNFJwbzJMRzBZ?=
 =?utf-8?B?YU9yaGdTdmhKb2xWSmY5RVBxYjhCMGtkbzF6N3A0Yyt5QStmbDdUT2c0akFJ?=
 =?utf-8?B?cUwyc1ZCUkRpZWNTYTJrcWF2STUvU1lJbUptZFM1NkNsWDc5YnNWdlZqTnJR?=
 =?utf-8?B?MVpnWmxzM0RmUExSdTNnYU9wbFpvQVRvaXo3U1R6WGJzd0k3NGZmdWFXSmor?=
 =?utf-8?B?V2F4NlZoMEVYVVNlMEJzMVVXNWlZVXNCTTJCTU0xSVN6UTFLM0w2SEQ3aW9Q?=
 =?utf-8?B?aXVQTHJvdnMrWmdHZGxrT3FRUEhoc0NqcHpZQWt0akt4VHkrQnlMc1V5QkJS?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C0eumE9zfakBC129ScoW7YLwLjIcEKusDD5VvbQnndyC+3zmqnPO4H6aeUKyw3CcgA/cyMCjyDAQNHINqXdpQJltHyojwj/+vr9D1WtcntLEi7wsJH+j1jo8uaelXCtfn42yrh62TsEqRMP2ro1/DAQOK8HcfUYH9+69aTcLDjvQrDL/yboijzWTep8yIefPBslx98Jp9uB7bqzEkxTeUfyTndY5brTVyZ+Yl5ofEFhLvzXn266q9A8wZi+5LtVfhVlkEHRZnqvc07zNkrwstbd6rLDXgE2zdMVIEreg0HmwjZSoKRqiRb3cyWu6OWwoVNjIscgwAT5cOnexumoDezs5UAEhJb2YE6ZhkysmM/wz47Y3Ooe28duB+dD2LP5TpbUkjoxUk0OWFNjBAd7j40ujeQppypqPcH8g1DN5IKIRdjGB0oq1UKgJ5KkaeL208LZrfeBmEwJlIxW5gfktDmDsHr6b4a/n7EosmrJxWaf4T2xTbI0pLsQDUCIA0fzOYdaJMOPfjNuLOpyLsiNh4PFkR83QJZ7INLTlBeYTXVRvXIm58rJTR9/LjpV54qE07qi3i97yBk5pN+Ap2074d9oys2eSchBl6TUUDDIPRik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 381741de-28ca-40fc-6ac0-08dcea03d29c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 14:48:52.1350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hLmx31TYYnxSSKZ+UmxUUJ+LfgE4OKYVjnOzos4Lfl/F4RcuiJofNIwf4iPTCHfCqlehC9xbp2q7qqZpa9l06I2ioBTLAJ+uEdcyh1T2Sw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-11_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410110102
X-Proofpoint-GUID: 8qHbSomLArFSIZGAnvgZpsnnPNlTc6gc
X-Proofpoint-ORIG-GUID: 8qHbSomLArFSIZGAnvgZpsnnPNlTc6gc

CC'ing the fibre channel experts because they might have the same issue.

On 10/11/24 3:18 AM, Xiang Zhang wrote:
> Initiator need to recover session and reconnect to target, after calling stop_conn. And target will rebuild new session info, and mark ASC_POWERON_RESET ua sense for scsi devices belong to the target(device reset). After recovery, first scsi command(scmd) request to target will get ASC_POWERON_RESET(ua sense) + SAM_STAT_CHECK_CONDITION(status) in response.
> According to scsi code: "scsi_done --> scsi_complete --> scsi_decide_disposition --> scsi_check_sense", if expecting_cc_ua = 0, scmd response with ASC_POWERON_RESET(ua sense) will ignore "cmd->retries <= cmd->allowed", fail directly. It will cause SCSI return io_error to upper layer without retry.

Just want to make sure I understand the problem.

Does the failure only happen with tape or passthrough or if removable is
set?

For commands coming from sd, then scsi_io_completion will end up calling
scsi_io_completion_action and seeing the UNIT_ATTENTION and will retry.
I'm not saying we shouldn't do a fix like you did below. Just want to
make sure I understand the case you describe above.


> If we set expecting_cc_ua=1 in fail_scsi_tasks, SISC will retry the scmd which is response with ASC_POWERON_RESET. The scmd second request to target can successful, because target will clear ASC_POWERON_RESET in device pending ua_sense_list after first scmd request.


What does "SISC" stand for?

> 
> Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
> ---
>  drivers/scsi/libiscsi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0fda8905eabd..317e57be32b3 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -629,9 +629,10 @@ static void __fail_scsi_task(struct iscsi_task *task, int err)
>  		conn->session->queued_cmdsn--;
>  		/* it was never sent so just complete like normal */
>  		state = ISCSI_TASK_COMPLETED;
> -	} else if (err == DID_TRANSPORT_DISRUPTED)
> +	} else if (err == DID_TRANSPORT_DISRUPTED) {
>  		state = ISCSI_TASK_ABRT_SESS_RECOV;
> -	else
> +		sc->device->expecting_cc_ua = 1;


The failure case can happen with other transports like fibre channel
right? If it's common I think we want this in the core scsi code.

For iscsi, we want to set expecting_cc_ua whenever we call
scsi_block_targets() or whenever we return DID_TRANSPORT_DISRUPTED or
DID_TRANSPORT_FAILFAST.

FC developers, I'm not sure if that's the case for you. For example if
your driver called fc_remote_port_delete -> scsi_block_targets but then
the issue is resolved quickly, like for a quick cable pull, and you
called fc_remote_port_add, could there be cases where you did not get a
I_T Nexus loss/reset type of issue?

Or is it the case where anytime a fc driver calls fc_remote_port_delete
then you will expect a UA after calling fc_remote_port_add again?
