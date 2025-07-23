Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B3F82C60;
	Wed, 23 Jul 2025 19:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753299509; cv=fail; b=h/1NOy2AjM8s0GgLwN9AMVAInJh9QlT+D9qYpo6ygwReazXfZ64qQ3RzzNMgtcj2GrqBEkypO0UCJt03Tg7Spxcs93sLmzmAjB95hRKV6R0cq4k6xhiITu6JU9qGdmBmldrsRDclpGHxp1ltg6xlf8FQx8kgE9kxh/dtshvGazc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753299509; c=relaxed/simple;
	bh=7L4ZtQPoDcQZIZrs2D/rOSCLl+HQEy+iK6yMypZpqVw=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ADfPPRr6GAekJd4eRU448SWBEy3c4X1qtwNAgXu6Ym5yihQZTgrAg6/X29T+OQ7BkTluzWJVyTlVVFMew1HBooaG6POyiDAGWIrLuzhR4ynSOQOFiw/Dc3qGHGgo/ZYEFT5NIaej9+9KAbXm2RJdALS89sKbWGwWGLhHuaGMHNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i0xBiTzm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zwgpej6o; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i0xBiTzm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zwgpej6o"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NHtvOJ013286;
	Wed, 23 Jul 2025 19:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0EUE6L/j/5v/BtzJKdn80K0jY4nn4QL+2VVHhv570dM=; b=
	i0xBiTzmyKhyHjOtUcaQiYGLpUwIRPlVTAOcDtROrlnt0oR/IO5R0+VP2O1bcCye
	TyuPlF5NMPCZnFW9eF5NY4dn+p2r1vNwRVmfba67LtjqgzEjgcFWQ9mKouY+CjoM
	NmYG17i88/qxNSRJd+YF442wr+K1QAR/VlZ5SZvzY/W5FuEs9tmmR6k24LHZWT1U
	daAjFzaECCpZiiH/nSrs9dfQNSuQ4c9LkpZ4z7nJCsMcalDNXtnYxysyEMsDKVUb
	6yw+qPOTWIHrXatBvg7D+WlaunwBty+CAP79PFEYVCJlsOG+93VZFb8hTV3VRLO5
	CpwmU+9gY44uuIHWDIEN3g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056eg84v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 19:38:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NI5hU0031544;
	Wed, 23 Jul 2025 19:38:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801thamds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 19:38:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJ9HHoq8s2kKkC/K+ULKETAYYIc7KbOt4eAfBrmCkBX4Z0QNXuwT0E4x330xvVFBff1jU0F59XaHaF630axbcR6btZNBsKbUsLS8whZNBMukQs4BEtNv9hUUBAef1ZSkhfTWx6zVzRhnzVNMAirJZAUlhsesxRZ3/bRcU/YU2dQAubnzPyn7em88mElKulLCYUxxbSr0vN0CEBMLa3eBYIgm3NN5Te4tFL8IwFDjaV6SptY3dvC9iDvhDJzZ6m+iruNwpq+VSiTEjlNhF7CE4Btiub69U9KUM0WZ7ny29e02N7GfTz7A1yfyPkOHkCL2IQxk+wT1VLbC4q7fU7okcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EUE6L/j/5v/BtzJKdn80K0jY4nn4QL+2VVHhv570dM=;
 b=CjMAGFXdpCOaKm5BJfD5v6SbCtjA4A3Mrp0woI4i0/jE91xrAmHMpYmVfdVbpR/vQnvr/JPwdbpmhYZdcXHtKVMqSR/GaIh6+gCELFiVclZRj/2yvtbUbE+/eZfuZeW1osY2njAF8y0Gs2ezj+Zw+M5c7652nGhfaCGsjALf5DVfQy1vsmcNf7zswnFPcUrFL2K7H2wTK7GHs5HRtRuOQAe3Psm0vUcsP6zNIFzfF5jp6uhq6+fBry6tUKyk38Yi+J7qSHZtjufrEy2SSzMyOzALQ1boGz0RN34CSehrQkh2eMoA8TeqNPovFgCJbbvN6fDMuGDxXruGKGPhTEfknQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EUE6L/j/5v/BtzJKdn80K0jY4nn4QL+2VVHhv570dM=;
 b=Zwgpej6oYC4tR7jlVb69mZruCVGNUH+UkgESjAG5zl1/5UUBZg//3mdweUJCK0hsV14CyVd0FsUuDSu9WlnQwanrQmqPE7LGKvSBy9V8FRvos1Iz2KYDnUri/gxMvqeGg8dEPzRHN6fsd7GISXF8xOmPu/N3i7ywbl2ubL9Sb4Q=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB6156.namprd10.prod.outlook.com (2603:10b6:510:1f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 19:38:22 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 19:38:22 +0000
Message-ID: <bcd7df02-df10-4dc4-a930-ba8c5bf0a02a@oracle.com>
Date: Wed, 23 Jul 2025 14:38:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: target: Add atomic se_device fields
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-3-michael.christie@oracle.com>
 <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
 <2eae4fbf-66ef-4602-91e0-d92838dcabe6@oracle.com>
 <951f5d23-19a8-4f6a-abcd-204aec160e74@oracle.com>
 <481bcab0-7bc0-40f1-9384-7d3c20ccc22c@oracle.com>
 <f6efa59c-680f-43a4-b477-0a3791f06f2e@oracle.com>
 <f78e4c94-ddc4-48dd-8d4b-182566e9234e@oracle.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <f78e4c94-ddc4-48dd-8d4b-182566e9234e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:8:57::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 12d86be2-a943-4b3e-e290-08ddca207c10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWI2RG5BdmZzank5U2RVUXBXd0hBVHdOamliWmJIQ0Jyb2xldkNkbnlkTlRK?=
 =?utf-8?B?aTU4a2kyY2JMSzVEODgyVERnakIyZHNwRkNSTkc3SCswNU1aQm1uc05yelY3?=
 =?utf-8?B?RFBMbnhxbWM3Q0xUQ1RyUnFNMjR6M1BYMzR6VVA4UC9lSGNHNnFrN1Y1Zzd3?=
 =?utf-8?B?VUEvdmNFd0NOd01KeVd0Y3V3dzRJQ2F1UHByN0pyYXhMeGlOZjA0eWY5L3pH?=
 =?utf-8?B?eWxiUGV4YmYwalZZVjZwNWtRU2RBU3B0VjlMbGJhV0swbForQXMwQUgvbi9k?=
 =?utf-8?B?R0FEOHhueUEyR0taWjQ3OThocUlHTnFqRVVUMlpPQ2hUa3UwZ2dya24ydGhZ?=
 =?utf-8?B?c2l5L0IyM0lXem54ZEVSWk1nWHd4SzF4MnpZRkxwb0l2RlFYeGlEK3FQaUhQ?=
 =?utf-8?B?THhmaEpyb2pvOHdJdHYrTE1uRjh3aHhydXBXU2pZM0JUN1VTTWk5OWlWUTE0?=
 =?utf-8?B?MU4yZFZZVG04ZUlwRlJUUGR2Q3FrQlNGU3RBYnFHVzZqelRPZUlvbjYxZ3hq?=
 =?utf-8?B?elBaNmgwMFpMdWx4MmFHRkE2UnJMbFgyVDFzZ2xmTzhOdW1vQk9BT3AweXE1?=
 =?utf-8?B?akdmSzIwU00zUTVHRVNNcndVRmxxcTJ0OXlFN1l0bGUxcHpzS1JjSVNRS0RV?=
 =?utf-8?B?dk1mL0pLNEVYcFNxUzNKRkRTYUdCM2Y2YVIvc0Ryd1NSN3RDdDZBTnlqWEFp?=
 =?utf-8?B?WllEY1lqdktYRlEzZ0lpS0Z4elpLOGIzQVE5Z2FRODZab3dkRHRzSTkvMjY2?=
 =?utf-8?B?RzhrbWpkN3pSRnpyTVVJdTQ0dHJOUUt2VTdmTmtQOTFSOGxUZGZWSktFR1Y4?=
 =?utf-8?B?ekY3VklOSyt4aStxRkpJL1I4KzFLVDJxL1ZqbEFPTFVKL2V4dkNGT09UWDBz?=
 =?utf-8?B?Y2toYXN2YXlRMWZWWGtxclZ2cVFmNmoxTU11OVVkSmRGWUlia3pjcUpnRjMz?=
 =?utf-8?B?ZHJ5S01iT1IybjFCTGl3TkdsbUhLbTB1S3RjVkREVG45a2JKK095MnorbTdE?=
 =?utf-8?B?bWxOVFBUSFMrYkIxK0hTdDVSNi9zNHFZYS8yQnhFaUdLWGR4WkJEYUp0WDhR?=
 =?utf-8?B?MEVkYTdab3RXaVd0Q2QweHI2c0ZVOG9RTFpzTlNXSFNHYjFEVFBWeXh4eTBS?=
 =?utf-8?B?QlNKR3BLTUl5Q3hoUEJmcGhaZWRiMjYxYkhZUWlSdUp2RnIvNDI1Y1UrNzFl?=
 =?utf-8?B?WVpib3RadXVWNGtIcjBubXo0eDFlb0UwamdJVUlpVFlsK1ZLQ0NwUitFa3la?=
 =?utf-8?B?YjB2ZzBLMTNNUzZwQWNqU2UyZllOT1dXU2Q1RTdMc1ovOE1vU2tOVzQyUVE3?=
 =?utf-8?B?Nlk2T0pSUWw2Uk0yL2g2VjVRdmxtQlB6Qkc2bVVZbGMrSWhpUHVreUtBRXZr?=
 =?utf-8?B?VWNyNXhTNHhFS0hHaGZKaThUbEFxdkQ2Mzd5RHdpRXFzUXRNVStMYjdIeXJD?=
 =?utf-8?B?Y2lVeHJKY3lpUXY1bE0yaTVVcVlOcVFyZnhJbEhSTndGeTNuOG0vVHB5ZHJR?=
 =?utf-8?B?MHhlZk1uTjZSMEg3b1Z4cFpPenNpTFU5MWcxb2pjZW15M0I1M2NzaCtlczdC?=
 =?utf-8?B?SEFSb1JPcE1uNlRBU3FodGVtYVVLemgya1hpRHVSRDlWaVJCUjFzdEhPc2tF?=
 =?utf-8?B?REpvQkhuQXo1OUlKN3JGTG54TnR6V0lzdC9OMHI2MmZueUVKT3NsNXBNN0RM?=
 =?utf-8?B?THN1eU93b2ZOYXpiYUlTdXFBZ3hmR05ZN0x5SjV0c0pOa1hXTWlMdzhvanB4?=
 =?utf-8?B?cDM3K1lvWlpnVkYxWkxuMFZuSFg1eVFoSE1LTWNONi9CM2lPcmZzajB1YjRp?=
 =?utf-8?B?alRWak0zYURKMS9OcWxnQVFGSm1CaklwdjVxazhwdWJxL3lLVGhSd2NiUWxM?=
 =?utf-8?B?M1V6M2oxdWVCV1RaV25YQTVhWEFzVGh2WXNSUlBiRUl2UUJjdzh6TXNJYTht?=
 =?utf-8?Q?LbpJTdH5sJw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlJMcTJOeDVUUW05UW84dVRCYTdqajVHbndHR0VFbFB6a25od0lSd0JObHVJ?=
 =?utf-8?B?WlF5aHFiZlpWWWxjNFJISWJSOFNOVDJEREpmb3crcVMya0loNG1XcE1jRUhV?=
 =?utf-8?B?SEY0SCt2T29Cd09CT1lJQnZhSWVJb1ZrTEpHVi9vbG9mdjduUERHSDhiekVn?=
 =?utf-8?B?Y3BCSzdhUlhaUi9zalVrOVZIeTZNcGN4RGhhT09QVWlzL3N1dzlUWHVqZlIy?=
 =?utf-8?B?UWYxUmNmNXM2RmlXK2xMemRlKy9QNm9vL05JNUNXSkQvdFR2L05aY05qdVJq?=
 =?utf-8?B?MGtCeldEbG1zV2szOHhrQ3pIUDdWT3h2a0RaV2x0Ukg1Z1NxVEZ5aWJFWnJU?=
 =?utf-8?B?ajBZQWEraDhlaHJFY3pTMnV1QmRoNmp5WUNxSEFnMlRXQjdocDlRblcxRk9X?=
 =?utf-8?B?UHRXUEFZWXM2ak5HZHdVWng4emRmVU80R24yL0dROWt5alYvZmQ0cm5zSitW?=
 =?utf-8?B?Y0plQXFTbnVtbGV4WCtVUkVHZUVuTEJiekt5eFhGc0Z2aDRpdnhuZlE0N2U3?=
 =?utf-8?B?V1Q2UVRaeXFkd3V5Q0VjanQyQnhFTnhwL0NONGYweCtyc0U1KytmN24wY1Vs?=
 =?utf-8?B?Y24vMEdVUEtSaGx0SW9GWW9CZ2swc0RxQ29yNjFwSmsrZ0I4MWhIa3dBQjFy?=
 =?utf-8?B?N0lXa2YzUitNOHJVWDdYTDQ4RVEvSzNwZS85TmNHNW9NOTFLTWJGL2Fkb2pz?=
 =?utf-8?B?ZWh2NHFqenJVOGwyYW51N3NRTVNhMGh5NmtKL2E3bnRoQXNYdldvZ3dmQWdI?=
 =?utf-8?B?MUxsOFRNMzg0YWpDRklCZTJRUmFSODl1K2RnY0dUZUxkT1dxN1ZndWRMT1lP?=
 =?utf-8?B?S25DUU1BNVVrbmRYZjhQdFAxb1c5eEtXUG1kblNxS2VsbDVuRlUrWjJMa0Vw?=
 =?utf-8?B?cnp5TDVkZENsbW8yeHZ2aEZKZ3NvcWtCSzNhNzV1K051QUdKZ0o1UHcybHhI?=
 =?utf-8?B?YzVNTUd2dlh1ZVhOVGxmV1RqNzBTUUtZL1o2bjYwSlVCUldZUzg0WW5Zb0ls?=
 =?utf-8?B?WjVHOGZxVFFpMUFibWk0Mm9xb2dDYklobHJadFBsb0ZuWGF1M1NtWWlqb2c5?=
 =?utf-8?B?cGxINnFiVStYMEg5Z3laUW9EenBjZDRjR01KQUw2cWtnYnpUUjhaOVMvWnFS?=
 =?utf-8?B?bUVRYjA3UjNXc05TNWxrWVNsWnlxTml5bnVVNWI5dEFybExiVmIwR3JjRnda?=
 =?utf-8?B?YnNpK0dhbGUyNlltTWdoRzk5S0hmUC80NWZCMzhwbjhnQzNiSG5uUkMvNW9O?=
 =?utf-8?B?T2pFVlFZdG81T3hvSDNLSUZpNWJxZFkreW04ajVEQ1VGNXdVb1lxRXZ0eVhh?=
 =?utf-8?B?Y3hCNlJIbU1HZ3dMZndYVTVOeitGYjBtTm9IZVAvYVF0WmJPTG9JNjIxSXJh?=
 =?utf-8?B?VEZYRXdSTUNWK2todm82aWQ1VjA2WGNOVEw1KyttZmFISkUzdUI3cnppRUhH?=
 =?utf-8?B?NWE1WE1iVnRtRkV1enpSWHM2SFNidjdMakdBbDA0OW5VaXRDTjBtVlB6TUhl?=
 =?utf-8?B?Y1Uzd3hUeEdtNWl6V2pHRzZqUG9SanV6WFJiMFlBZ2IySTMva3lLbk0vRDdE?=
 =?utf-8?B?M293Y0dXdExQSnBKWjlNRDJFeDZYYnU5WlA1TjFQcjFYMGcvbDhTWW0rMXRQ?=
 =?utf-8?B?YWZWbktZUW1QQ1NRMmlzNVMrUkFRbGlqdlhJblE1dG9XbExUb0tHUE1MVGxj?=
 =?utf-8?B?bUUxdkdSeFM0MEZmblVIdUcwMiswZ1dyU2Y1QVZVRWVRbGRueGg5RVBtMC9H?=
 =?utf-8?B?VWpsWVFiek5lV0tHY3R4NGUxSm0vdnJrTzZtUUhqNnJncmV5RzBMeTgwUFFx?=
 =?utf-8?B?V2ZVM0o4NDNvMm9lQXMwdFI1SnFMQmRrekQreGZzc2FvVkxUQm5ab1ZGRmhP?=
 =?utf-8?B?M3cwWW85TVNteDhoa2hncHJ2b1puSHhtc29iMWlIVVBCeTV6ZUhZekhGbXRy?=
 =?utf-8?B?ZkFzUzU5ekM4Smgza0swaU8zd3ZjS1liaUpicTJlbmdPK2RFMHIycGplMVlI?=
 =?utf-8?B?QXA1Q1gyK3BZVG5oOFE0Qi9LcjJQRDdJVC96VGRudzM0TVJGQzIyUUo2OU9p?=
 =?utf-8?B?SGdiZU9SaURRcmR2cUt0WCtXcXYxR2xPaTZiK2xRM0ZhendySWVjenZJQUc0?=
 =?utf-8?B?ajdySVdoUVNEazFHNVcrcVo3cjZMOFFjQzlaNm9KZGd6bjFJb001QWhGV3Vq?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b/L7amIbb1jQgYYKSr5q/+F+KMx0VTZPNvP54cPa2cdL5RAXQIQE0lfdgBvxDA8O8e5ID0F1ms9173UGD5l0iDFmaFu3iUxuSCf00UW78TtJkNitGoudWYqLZADyq+nrHAscbHic56MOIbc6cZMzDCLGUf3KibPGNvG/hCBdZNaoGa8C6Kjt2O71tmvHHtOoTtK7ejdAbox3xt4ZbmrJWIEeS1tHMZCOIHw1sQBvY97arqKfkq5NhNHLp8sHNuhsw23aCip1gTfZNiorIshkvb9Ok1vtVGlHtgQc0rZ5XYyHbWxAVapHZ5nY4qMv3ivB54x3l8LANMqyp5hoIm3ovKZ0+0Rl26kKJTz7+mDDYcHZvPAF4xe7SPTZpyq1KqZedSguuF9ANUbq6AUaW78N/k55+V9RScFeqqTcf0Dve42QHLysH7eIMhyh2fsdw+8xkkoYJiTMNrj1JCrxIXvkgIRlW9WL5CUwNPW3P5afw71hfqyCqz0oCuBVhekQVc2QtC2v36pagp6OZwyAwSL8hhYcHZGlNQXMRHCHNEixpLHn7XmietwMgtpHB2dbnj6MJBJpCCMnnsnUo3KNQ5uCx3M7IoFEXjhKLj0nHPhoVso=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d86be2-a943-4b3e-e290-08ddca207c10
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 19:38:22.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eGvPamqriB2Mvg4opVmdRhkh6hbNHdfqinm/ZxDfKZN9dyHCKdm7aHEEjUVxHR6a7DXJO1riiDNMDLZBnlzlrl33frYeKyzuxwm7EE4JXFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230166
X-Proofpoint-ORIG-GUID: UvPyX_lg1CrWW2mBzKl1-U8LNBMPxHbY
X-Proofpoint-GUID: UvPyX_lg1CrWW2mBzKl1-U8LNBMPxHbY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDE2NiBTYWx0ZWRfX+a3z3nvGvhzA
 SvXjFFX8ysft0ER7BfNryK8pkcT60IBGYhhbDhdNDQ41pII1GmKuEWpVyVE4BsmfolGTOuSk+I5
 G4urI4Ay+wuSHGiGIX0w60B3FqcZi0nuzPuxONutyRt4PaNJnnUyHhqIbtYomcI9xUPxDW8qzli
 sIKFXClVVohy9iW0FxZ4Ss0KRy5T0UVtbpdkybCaGquxWvgxLUxnp9EROttAUA97dknM40r62Q/
 /q+KOo2dCnUwySofYB2MfnVE7jxTHy1dDe7OQd8PV/mHAorEU2jKi/+zyzjzrzBRCJXYkKQoLMs
 TpbppI3jogcaa48TRBeLFN7NxNr6XePadTmjhThmyLcgImoqLHvpVc9YjYXbtKd3lhSX7M35H5/
 tEQdLr5XPMr4WbWsTaDpSs2LIosFlse1UhrU+qJOCf/Eto6kg0gu8AU+7d2ExL4Mh4tqYdH/
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=68813a32 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=er0FiDQWEHNxmozYDcoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13600

On 7/23/25 11:21 AM, John Garry wrote:
> On 23/07/2025 16:48, michael.christie@oracle.com wrote:
>>>>> What if you are not using a physical block device like using LIO's
>>>>> ramdisk mode
>>>>> to perform testing?
>>>> But would this non-physical device still need to support atomics? I
>>>> would assume so.
>>> It depends. For just a testing mode not necessarily. It can be relaxed
>>> so you can test different scenarios like you want to test when atomics
>>> are not supported correctly. For real support yes.
>>>
>>> But just to be clear for either case, there won't always be a
>>> request_queue/block_device. For example, rd and tcmu don't use
>>> target_configure_write_atomic_from_bdev, so the atomic values can be
>>> whatever they want to support.
> 
> If that is acceptable, then I am curious why only make alignment
> configurable (and not the other params)? From below, it seems that you
> have some special device to support.
> 

Oh I completely misunderstood you :) I see what you were asking. I think
it was just a mistake.

>> I think I misunderstood the last comment.
>>
>> I'm trying to make sure I can support a broken device for testing so I
>> tried to make as flexible as possible.
>>
>> With the code as is though I think your concern in the last comment is
>> that a user could set some valid settings, use rd/tcmu, and think they
>> were safe when they are not. If so, then I agree that can happen.
>>
>> Or are you saying even for broken device simulation that we will never
>> need to set values like alignment above?
> 
> I suppose that we can set alignment for broken devices, yes.
> 
> I'll make a couple of points about scsi alignment as it is a bit
> special. Firstly the alignment should be compatible with the atomic
> write unit min. atomic write unit min comes from the granularity/pbs. So
> the granularity/pbs needs to be compatible with alignment.
> 
> A further point is that if a partition is not aligned on the atomic
> write unit min boundary, then atomic writes are disabled for that bdev
> partition.

I didn't completely understand these 2 paragraphs. Are you saying you
want me to enforce this type of thing somewhere. How does the info above
come into play if we are testing against other OSs for example?
