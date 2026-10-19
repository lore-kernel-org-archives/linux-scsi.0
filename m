Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792438408;
	b=AoTgbuKdwqdfB3VsUg/KoGcq2a9+MYnUscb3GYujyRgIa8PCP6r5CC3Yn/zuSLOkwtw8
	 358hSrNldYmsUdAu0bymUM1et5t7pY+iwgoJ1P5LX9hFTIoVqDnhx5bs9x8SXK3J6V1qU
	 BdHe78oT74+2f5PpU56Sh/DGuh+QzSlqDalpR6Qv7mPkPtdVb26tD96taWYkFgtV5wrRW
	 1rIdneS2/UfTQJf7OKHetQZbX1+WTc1l3rW/rt4p+e/yVLsu9u9v57ymthB4FcPIJd8xz
	 rGU9qDDWPoYPaAf+xXoXMTSHtJ50EXA/tsuIhexL4ltpq5ruBLkXMGXi2mOkUV5F6kg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792438408;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID;
	bh=DKxWBeiyrgxzx4NtNF5ugrB8T3viO8amQvaX4ME0DKw=;
	b=yvdM8LD5ngINHTMFD3KquRlxd+ITzrYNANDM6NDm5BYBbgnre3Rf6k13CT1MzJAow0uy
	 OzvMcBjux3eim2zztfb565GEbD+MHKs4uvXvgjPekltLb62WwFsvpELxhS9E10qoITTg+
	 CF6whiZwae6jD+Og9XVYjWC4LGeeV6110drl4QnMkmwy2B9OpETY9PPibXUoMLXbA5bCF
	 9RP5w8lX/X6TzV8RGnzgq8CdXEx0jZrHjtWXBcTkOYjbqADMJrTIQI4ThT14+GEgVT4US
	 DeOwOCPVgORmS4gDGNjOrJaf+kHJi/MJ/J9SDgtH+6vLFcJ2gd9LHLEc5yom+qBVfFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=MWhBdcJ4;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=F5dkyUQD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160CD606A31B
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 19:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 160CD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=MWhBdcJ4;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=F5dkyUQD
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JEY8wW562449;
	Mon, 19 Oct 2026 19:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DKxWBeiyrgxzx4NtNF5ugrB8T3viO8amQvaX4ME0DKw=; b=
	MWhBdcJ4d0x2ztf4asulZv0jVH3WXi+Y3Yby+nsyKUVm1QwcK0ZyuSygr0UTEACO
	kXvyZ7mYZkDEe3/Le40Os8HcbEKj0AJXEJgXXMQgGcIO8J8Q93AOlvkODAM4all/
	ShbP0pIhZCiWEO/2ERvOssK9t6PUnt/7IDovDZ7sgg/VcGEuwP6LkYeGiT/Fe6Qo
	smjKfQgs9Xhaphd0VqVsYGFXbhLQt2Zl61alLTfs9xBoV4Qslv49S394IXeJXVl2
	39dm+8/243Nz5uu8UN3Xz2D1bT+sjbJVoNdTnHnRM36Fqw7dtOYhuLMZofoQAsLg
	HxVtCB6U1sonZZkIeGz+Jg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hbykxtk05-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Mon, 19 Oct 2026 19:33:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 69JJTEY9823959;
	Mon, 19 Oct 2026 19:33:23 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010055.outbound.protection.outlook.com [52.101.56.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4hdsdj86c0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 19:33:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hx2gLubHv7/61rsjesJQoW8+TbWTQrNXAIfPr+wxFX1sP5Jx1malNkitzH+cg2APyVDmxGeAZZ7gdb2tNtGNlQEAu2TeAmFugnW2K0XomgpIdMv7KFylYI5YthzK1l1za/+Kd8su+MADWZi0aE4tEBgwdN2Xeu1zAEsCl6y/pUaq1hh55UuCD5re/DZXQ4ps4AbOC5Lb3d9w+o7Y19uiKTigE5T9RSEyaXws0BeGr7cZYO0KmO/UbV1RrFwVCpCiHjs99iqqw6+TXaLqrlYvRc3JMcvQly4j36LezfTcE/ZZvQhsEotMVjJNyOjJ3q4q5JaB9kSDizCYQwKj+TgE2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKxWBeiyrgxzx4NtNF5ugrB8T3viO8amQvaX4ME0DKw=;
 b=UVHkSHZbCOfFar8ID729TOM9g0zAzEPWHcPoU1tlYSYv4G/X9Cjl8wdu7mdVYjVVfrpAAU8aRxMdrlT4tbJj2u4B07UYDGsvBikuR4y+oLAMqKDC4D7gNnBkMoBPCVQ+rTjqLZ19GXT6rOpiBscbIuhPvamJPGEHiuAl9G4Y5T4ffo8xHtBfVcbiM20eG2hm8A+x/q4pOEVbaMCVaZddKnqoR8fLFWQtXlIqKrtJaKniniWdaKDIfCJTXP7fhi3yVqfomcSoTw8nA8NrJjflkh9OFcpEcrDyzC9RsUw2cxAO230EFJC4cyVMt5rEz+xmOT8PpGFrm4e6wPFu3cY25g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKxWBeiyrgxzx4NtNF5ugrB8T3viO8amQvaX4ME0DKw=;
 b=F5dkyUQDLhwdK3laKD+mtDS1U8YElEtkkloXX4JYsJm9xdyChh1BDJhhxlINfToCGdrEmWDJ+8ugIGpyKuM1GcU0A9TJh6QM7DlRo3ETKyT+rDN5owX5QWuYPcYYMI89WreAAgq/1pB+AnN6kS3Eb3BObAoCdUUcI5i0pzAwbMc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from MW6PR10MB7639.namprd10.prod.outlook.com (2603:10b6:303:244::14)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Mon, 19 Oct
 2026 19:32:52 +0000
Received: from MW6PR10MB7639.namprd10.prod.outlook.com
 ([fe80::8386:1d11:46b2:b163]) by MW6PR10MB7639.namprd10.prod.outlook.com
 ([fe80::8386:1d11:46b2:b163%5]) with mapi id 15.21.0546.012; Mon, 19 Oct 2026
 19:32:52 +0000
Message-ID: <bc1bd391-3b9b-4f91-97f2-61b32e9afe0b@oracle.com>
Date: Mon, 19 Oct 2026 12:32:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: lpfc: fix node use-after-free in rport
 callbacks
To: Paul Ely <paul.ely@broadcom.com>
Cc: linux-scsi@vger.kernel.org, mkp@kernel.org,
        Nigel Kirkland <nigel.kirkland@broadcom.com>,
        Dai Ngo <dai.ngo@oracle.com>
References: <CAEQnVQnHxyMp3Acdu_LCQbL0esYZ3mfjM5kDwtYQdOK9Lk+x=Q@mail.gmail.com>
Content-Language: en-US
From: Dai Ngo <dai.ngo@oracle.com>
In-Reply-To: <CAEQnVQnHxyMp3Acdu_LCQbL0esYZ3mfjM5kDwtYQdOK9Lk+x=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::33) To MW6PR10MB7639.namprd10.prod.outlook.com
 (2603:10b6:303:244::14)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7639:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e094f8a-878d-4160-3e63-08df2e17c45d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	SAZCkvbYvr41wkEea2T/Ebvyg6SPPLgQU/cDDwHgMpB0f88zFwtQEnGLp0IXSffP7DeWc6QWZVW1NNCEwM6urggw0AXDoOeNxrjO91M+R6zhfb9KONKgp6+nThFECrHIaXP7GqroxoNmqpa1meZXVVak3MomSdeAEPQ3MzV21h9cDo3AMQJCuz3mgqSO2EkWBPX73vzr/tOjQ410FOZGe3OW4mbHoZeyb23a/Zkiz4YZUYqPxCRA24LgEEIikIy9h+LEXd0smyliwvKJ4R2XiyFXa+3rRwDzQCD44bGRmQhKyfNwKkt4ftlB1ua4mmLVEsVkf3KudQjFfXa8VmE6fj90XM/5BiwJMGGUnXuiAK0jnYRF46N2MQyR0+ma42piVKHsVMCXwDvgPSvmRcqrsor4sCHkh5kRzu4cfGonInOocKQB5aIIDnfnEM/MEurLetUATgKNKr314RbL4FKFLcQfSOFULtsJwn3kpKQ/lFtQvi2rVIFu0iR+sYW9NkTZ9IzASV4rD7+hRYnzmskyQ2RXT/RFC0A7t8cy3a6Rx11SDonWvBqIJcUZrbqwL0RK+X/7BLYjOvH/r8H5UtvkfDrrVQAuCq63Oy2VB958KWjHwnUMCRmLTpyNAalm0D0C7ih0zvcbwIAJ5cF/zycfXPVDYxbkbSsMVjmF+RsQtdQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7639.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0dXVHowZDExSEJrbzBISHNZK3pqTzk0OEczNFEvZUgvVkRub2dYTy9EUmJO?=
 =?utf-8?B?Wk5WeWV2NkhKOGtpZ280M2tXcEhvZDc2SkJkTkNocUZxdVhYNTdXV2QwYlVX?=
 =?utf-8?B?cFYwUGhGQ2I1Y2xLYXAyYi81TitoMHMzMUVXQUcwSjRlK2lXaTFRcEJYVVM0?=
 =?utf-8?B?aFQ0aXBTRnkvajJ2eXBZSVJlczlUVDRSUUZpSkNsYzc2VVY0VVBkNUFzU1Vx?=
 =?utf-8?B?T21vRDEyWnQxREtMNlhCQUovVjlSa2tBUlFCeTBQSUhZWFdLMFR6T3JhdW1D?=
 =?utf-8?B?QW5kZGJucmQ5alZJaDdpdHpnYjhIemhncmJMcjhXNWp3UmVSSXl2NFFIUWN1?=
 =?utf-8?B?S05zQ2FMVVdwbXpIbVZLZWZKQnF1OGZFc3N6Mm5VSS9tRVd3Vlh1USs1aVRM?=
 =?utf-8?B?YWtCU2c1em0vcnRXUEFzb0dCOU1uNTREdFhFZEhlWkU2THZWb0d1NWU1c1ZX?=
 =?utf-8?B?dEl1RjlCOFY4SnRIL29DeXhaaGRQK1l3SzFVNzg4YW1taG9XUmlTZkNXaWs1?=
 =?utf-8?B?RVZoWGJHQ0x6QTQ4M3c3Q3B6TnhjTGI1S3dZTVZsTTY3bjA0c3dPNFNGWGI4?=
 =?utf-8?B?TldXbSsrQlp1NDRSQnBQd1VKaXRwT08wOFh2YXM0cElHWjhTYUZrZTU0b2h4?=
 =?utf-8?B?eGkyb0xIelpzQ0QzUXJIbE1DYXJMenhQTUU5cUxiOG5PMEpIUzVtam16V3hw?=
 =?utf-8?B?Q3dvQjdUWVljbHdzZkJTdTBZSFM1OVBCVmdseFlpNTFmQ1ExS1BZQmhjcU82?=
 =?utf-8?B?aVg5ZDFPTkNRcUtvU1FuTDlJdjB1c2tVeU1tVDE0TUlYUXA4S1VOdTRZNXRL?=
 =?utf-8?B?L1ExSGlJT2dlVDRudmJpelRXUWpwZ3ovL3NybWZSSlErbWZPZWtGaUk3RXE1?=
 =?utf-8?B?WHp5Vmp1a005MkltMlNOWTZJWm1uWUxQMUtFYXNjL3hyNVQ0Z1ZMWHFYRkVt?=
 =?utf-8?B?NTVjNFJQOENta01yaXkrWThJZ0FsOE5tdXNnYVJZTHZMM1lJMmR0aUZtL3lt?=
 =?utf-8?B?RlBMK1BYU0xpdmpLYmlQVlk4ZXgxR1pmRHB6bnhScHgrMFVjOStxTnMyZkhN?=
 =?utf-8?B?cHp5Ump5VllhZC92eUZldDVZWXBoWWRyZHVBMW5uWEVrbWRKUjRLYXNaa3ls?=
 =?utf-8?B?eHcwYUdldnc4ZjBCTk1UcG1vLzc1V3N6aElOcVpOaWZMWkluU3NnV1p1YXJu?=
 =?utf-8?B?bzBDakRoektTQWVvY1FlVzdXYTBXU0p4Y1RTS0szSnJMaU50Q2xLVTBFRGNT?=
 =?utf-8?B?Slh0enNuZFBFMENKQUNpTTFYUWI5MTQwS1A2M0VpenlRTjd4RXBwRVcvbXlQ?=
 =?utf-8?B?L0RXcXpzcmtweHBwQWJiVGpwY2ZnZVRTa09SS3lPV1l2N0xTaFM3RnRZWWRK?=
 =?utf-8?B?QldLQllTR2R1VkdUNUFVT2V2TEpJNktWVkErY2YwQ0lGaGM0dWJGeDY5cVlL?=
 =?utf-8?B?M1RYcnF6VERxUlpkOWtEd1ZuRnpXV3hjTFlieEZnZm1VWWJ3c2ZhajZnUkgx?=
 =?utf-8?B?OHY3azllOU1pNnlOL0NPZlRIQkVLc2VNcVlVNWRJMXVnd29XbStZdzJLeUZw?=
 =?utf-8?B?cGZMa1JXd1o5Nng5aDZ5Rzg0Yk9BaHRFYTdHbEVBbHprYU8yVG9WdVBQNTJC?=
 =?utf-8?B?QnRMcHB4MEdoKzduZnNjNHhWeUJHZDZOOVd5eXd3aVZzNHFhWXA5cWl4aVhL?=
 =?utf-8?B?LzFqSmRKbjRtVFdubmdnY3d0Q0h5d2w4WVBEaWg1OWp0L05NNGhsVXVrMzh4?=
 =?utf-8?B?VklBZVpRWlhkYkZubEYvMGcydTdQMGJYZkFRZGxTL0NtWmVXbUEzdENPWTY1?=
 =?utf-8?B?bDViVXV6MGtiYUUvTks0aVhnWXpuck01clAwb2ZlK09ucVhZUmRZQyt1eFB4?=
 =?utf-8?B?OWFPWHo0QzBiWnNiUW1CSTg1QjJ2TjU5d2d5dy9BR1RrMUFHYTRqWm53QWpD?=
 =?utf-8?B?bXowaXpxckI5NzFWNkc3Wk5rSk1wbndXR0pwQ25udFZHZlVXNlBoSldEZ056?=
 =?utf-8?B?WVdpcHcvbGhheEhtTDZyZkE1RWEyMHhlTXcySnEveklZZkU4N0dHellhcXI2?=
 =?utf-8?B?ZGlacENrcWNJQ2tvY0d2RzFUdWtKK1pWV3hpRWhaUmZ6dDhmcGhLQ3gzbytt?=
 =?utf-8?B?RVVzUUJZdm5KZ2ZJeUdLWW56MGE1SXZ5REJjY0lyS3I1QkNxbTBqQmtQK2Jh?=
 =?utf-8?B?K3IyMzJaZUlDY3NxUE5NS29JNFhadExLbWlxUit6NUZCenl4Rm13Q0EzSzJ1?=
 =?utf-8?B?cHJrakZPMTFteWkxU1lLd1RRZjJ0NTJLNmpMMExTTXdRa1ZQQnJEbk9mZXdY?=
 =?utf-8?B?QmNtcEtLZGhPRVA5bm1hRlhlaVdDUklEQlArZE1qM0pybHpudy91dz09?=
X-Exchange-RoutingPolicyChecked:
	IUN6h2vYfGnFMeELpBLSpuefMW+9XHQyho4lS3trHciU7b2v78jPEM9mGAVqzRSCz6cvmWy9qJ5kXWCgVyidCfsWJwJNTednDYVoZdWV5MdyfqlLOD3fBCc0ns70AyhzfEhxf11hsXHlRzzEFm69HRR3K8BGq6WmDozkWkDCWqs9U2pRGqm+8h+YhzykND8iqdNXWDOzkz5j9+Kw6YaL8PX50QcRlqX8mbJWAZXcwMx8W+xvZtSjV25TtVc81krOPbY9b851gPCTmXHu37IadElMvVeRP41bkzXFeIWmE2KxQomPBmc9HHdvjfYVbpuvMbl+48sAfEGTr1T65k5cBg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NDGDDnPDXyw4qMlfBd2O0YpW2MXNWFvx677AMDrJWC7iD2urxtPfCUYAVR+aFT/cXNR9WKFip6MJI361VVr4zESjenGIW6/WOdDpmNzOHPQ3ErZod0a/ZYZgF3n9CNU9ZhljKkwVASSdHsVhVzXRJcrAYmryknGHlpfGPZAAWLf4ToraEjVqJbuiO6QKmZG/g4nbZ4OCPwUd6HaG6F/VRCeVD/PO+R4U9taKRTO41anKeaZwRSJ+TgkQP4lSkcw01tus29PZbRa7OeVA2aq9nDXlsf1spPDPuPRBAd12Ro4ACti8bsYed5PSTbddUXTE3yOlJoZUALITab1lWeDxi+BY2X+H4YVTv94Dv3SvvHYeU7L8oh0WLhpuAM+IRzOIBXDaqh3lq9EkEhhlTN4yB+/zzPNCzlzm3+omAtHYF+SEUwVKxVME/d020ofXsr0b5SGdCNZ4V9XF2IB4QjVsjB7CMYIoNDmRLAx/2P1W1hZuX2iVqA65y0khfOWucBSRiCL5FTPli5MwBso4pihB1nIaHhyzBW5/ZpGPH1sRYp6sa2/qtElec4mhos3M9ibsKUlcSePIVQhtlmCyOyFrllnEHTjC22ykg5MNTJ+inJQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e094f8a-878d-4160-3e63-08df2e17c45d
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7639.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 19:32:52.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIurG8Ss0PqWY1tT7M6r6MNGbJYfEfm2HzCbOnaOT9EW/QUoI/p7Apd843l6vlrIab+3CyyvYWCW2kfcHO26vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_05,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190077
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA3NyBTYWx0ZWRfXxRO4RZ4OMuAU
 0foSH22Wz1KG+9ghyv+w/h9qQ6AbMrMA/lNCeDjkP6jJitwX87CLUH3N5Mh4kBy7SfRw7P80uam
 PxUw3aiWZQZ1VANIRA0th7ZKfPDGakW/2f8y4eCyEPR7mjId9Mz+
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA3NyBTYWx0ZWRfX3hA7bzvGfpeW
 xcnYsTdS7kGk/qNNxvTQwQZXc47XrtaylxU1/758mKFtnQV+JVa80xW5joNLYAeFZNJSFc4wK1b
 HZT45NqKGAUx6FQV/LWBLtGmwGSt0xoaf70xCrz34O4nCAzgpiwIv7KZcZj3e6dxF1WjYEMV40G
 u8xgAAX7i+zBfDnCVIZekRgsg7w653hjMlnYLgLYvLfVBHTZa2fqAarueXnuguEHloxFSnVdJ43
 C2pA8ZQzYn9z9l3b3zCGeQ8UageGOd50KNh6Pv4S01zki3TCETuEvrziNBOgMhGbUAWB9mPXTL9
 JWn6ZE8akD8Do3zsaMiNhPnvKgV4YvJIStULn6a5+W4qbSF9DI+x40T8+CB0Tb/wEJkyaZyo2TJ
 jWLUaDEfxULz9VEyhnheAWcDOSRGzUnQQZM4jSWc58YWL56EQGjugmLQSo8rTqsDOMCpfoLuAOY
 Artdj4xEpTE7DMWLvKg==
X-Authority-Analysis: v=2.4 cv=BOYmP1QG c=1 sm=1 tr=0 ts=6ad67084 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=tbQrJMS_E1mRdqUcT30A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ojKiPzitLldcO7_IegD0sKxh0HtzT0o4
X-Proofpoint-GUID: ojKiPzitLldcO7_IegD0sKxh0HtzT0o4

Hi Paul,

Thank you for reviewing the patch and explaining your concerns. I 
appreciate the extensive testing Broadcom has already done, and I agree 
that preserving the existing design and minimizing regression risk are 
important.

The get_device()/put_device() calls were intended only to keep the saved 
rport alive while unregistration proceeds outside ndlp->lock, not to 
take over SCSI device management. However, I understand your concern and 
would prefer to avoid them if the binding and lifetime guarantees can be 
maintained with a simpler approach.

Your point about the initial node reference is helpful. I’ll revisit the 
original failure sequence against that intended lifetime, particularly 
around recovery and teardown.

Could you please share Broadcom’s patch when convenient? I’d be happy to 
compare the approaches and test it against our cable-pull reproducer.

Thanks again for your time and guidance.
-Dai

On 10/19/26 12:06 PM, Paul Ely wrote:
> Hello Dai,
> Broadcom has a competing patch for this, and I would like to compare 
> your approach to ours. Our patch has extensive test time against 
> multiple OS distros, platforms, targets, HBAs, and system test fault 
> suites.
> I don't agree with the get_device/put_device calls in lpfc. SCSI 
> device management is the responsibility of the scsi_transport_<fc, 
> sas,...>. And it should be OK for lpfc to grab a reference upon a 
> successful register and drop the reference after deregistration. The 
> lpfc_nlp_init reference holds the node in play until the 
> lpfc_work_list_done removes it.
> lpfc's concern is it's ndlp to rport binding only.
> This part of lpfc has extensive testing on and your patch extensively 
> alters its design. I'll need some time to ensure no test regressions.
> Thanks
> Paul
>
