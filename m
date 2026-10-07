Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0DA1397;
	Wed,  7 Oct 2026 00:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791332008; cv=fail; b=Ivr3NYfWkDfcmLnPP7jt21VGVUeOUzINCn1I2SDUu2uieFFZ22XvB3dQt3TakzAv0a8mbFOvdW7+/nO2ear/FqhYFiMPN6aGG4WrbzePcyjG1wC2Kyomg81cuvJFDlel+hG6rlyvrMim1/JLibL6Yv3oRDMXGYm8a8fwgr3aI2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791332008; c=relaxed/simple;
	bh=ZcX5epIX079PUDJpdBB/+Ez1lE9qN/e+yWNW/094eCU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iC2aDoEVwHNJVDVfMWmjfdlAaBB8p7W+DxDVCQQypKuO6x3FfVBhTJDYiErSjrk0aziNZuGfiSCatjzDIAuSZcKuf55ucFeh4hA0daBUhkug318jM8uZiAUpN2msCl6ujBYi14MGKsk5jNbqSAsLdfetFQp/qacYZuqoARPlek4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bbd/2g4F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HiqQNXlP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bbd/2g4F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HiqQNXlP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696Mo2wx1221157;
	Wed, 7 Oct 2026 00:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cNtgcoD5SentcRMYsbsaVWDCmkvAloxFBPTA58Vq+/I=; b=
	bbd/2g4FiaHV1Qme3KPzsz1fGOxnP9pKKbceTgetuOCIvLDac+p7rZ3mfkKPt/ug
	7MefxIUwzZYfHXqYjQp/XcFZxI91qz+QA6l3nrdpcjshrAjEvjUB8cUMW998kt1b
	gcToRGSFDV10Bsp8AQ+6Yx9DvuTbO0maHRuONAvAqzCba7abNgxORvhls3cxy2pS
	gFLv++BFQ3Qn82ENClf7RdcMFtaMdf3+oI43maXB7whWNiIKZjMr14QoCQgqa0Yo
	bU+bD+E+qTyxobbMsdJeENRMq6lEdKZmjQ0W/jIy3A2IfN+2LOxhmkMCRbMHrcEr
	BeNDhr3+9E3VOuXu9LuUUA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2sk7mr5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:13:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69706KkI039674;
	Wed, 7 Oct 2026 00:13:21 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d00a50m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:13:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9SZhHKwVslbJ+4APPUuK+JG6YHioVv8Vlgvkd1TFzk/rBR81PzPx7gCbDOkSSxhNkOKeBvJ/F62StT1vBkx7wMtFZuq5AuF3gU3CBl8k8UKu2E1h4vH0tJqy5lrlNTLWQXjf/fPRoDcRu2jIA5cpbNQuYCWlj/kkQ+E0ZpZvvIVJ0iyOzvGn3KJVJwCsWuCpTRrfeyfVQviFjis4rgorKMyCUqxLAQIqcPi2MiCn0bvYlC30RaeNu1b9mNfggvEHk/OPo+DVyMqRlphGndjylyjXyPki3VvAFAoE06J8Uy1P9e0HA+4SxT4sltsFBkCFwMNZZsHQtrBeSfDNkfj2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNtgcoD5SentcRMYsbsaVWDCmkvAloxFBPTA58Vq+/I=;
 b=rtFC7YHM00yhD4FqJklrBRkvNNbv94xTCJJSgUEOb/oFweE4cJ2vMLutfxMztpSVe9m+5dVbSY+XqB5reNOa8lbW0SGRQQm/uXgtAHzu3r9AF2nPinbhXx7dSmqyxfkZGmyI5wJWJnMPvaK3079IylvRLwJIyfNsH8M4POY+Bq0EB+Wf39E4g2Jhuic7pD+mBligC6WDmOy+BdlBriqSdj9MRA5IAial+grkIcxgPM03zYVrPd7SHfjQV4RUKBi4ihw0I01cnPvuV8UuWr7AWTUhTcU/c2RbLMtFof3o6ckFQra5mdJRqxXYuktZIx0zG9YnuYjUkOK9jTBG6+2RqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNtgcoD5SentcRMYsbsaVWDCmkvAloxFBPTA58Vq+/I=;
 b=HiqQNXlP867T9NVoMzbCiAqJ3AqVBB8u8tGGQ4/EKdWkI2oR55U5xfd4yG8qXbTRrdLVYzHyHtxo25zOGt195n84VBQ9BOBbm2+tp9CqmhBaEF11sBDwX7+fi8Yb72DinGBywXzL6GRB7Dw2eJBhvJT+IOEpV+/r8yFAKGJK/kg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by IA1PR10MB7537.namprd10.prod.outlook.com
 (2603:10b6:208:457::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.13; Wed, 7 Oct
 2026 00:13:17 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:13:15 +0000
Message-ID: <50f1b741-ca27-4597-baa3-e8eb57d9d44c@oracle.com>
Date: Tue, 6 Oct 2026 19:13:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libiscsi_tcp: check that a read got the data the
 target claimed
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, martin.petersen@oracle.com
Cc: cleech@redhat.com, lduncan@suse.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0097.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:25a::6)
 To DM3PPF905D77450.namprd10.prod.outlook.com (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|IA1PR10MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: aea536be-2611-45d8-2204-08df2407c858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9d9OyjBMzIIa/nc97+mzYmfjgAdT2FKxn10hUfw1m5qCdf6uW4eRVW7HQoquXqDU7NMnMSPrWY/2wY76ylZjcb8685lhEFVYZDMcuadjYgrtQUHyGb4LM7DPGLUMnoDtpsoqRaPA8UCxNT2D2q6nBjq4dZWe/jKv+pZMxR+8hQUoQyU+XB4+GqwwulGnZgkaa1ZEk09cg2LcWQifJUx/1NLsYNfS1XTb0YiYwccCyIMlI9PkyAfKl7ptYlSxFSIC9m1FAO/W1O6fdZwSGkOVDm88dK6iW5lxV646vHUXuSpdOAr+XwEZiMnqX3sVfSyW992ATiN8J+wTIaP2Pemng46BnvgzCE8KRkEG6BGYanjyeIlqPxxs4DUd+EyAvRUGN4puensamZShaqj4R2bDvmghxO5QehonrSgXhGv/McGkgKGnOgye8e93XHl8DYTd3+i+ZvSF/vNEzh92nesAIGOE44X7cKbGAuhufBMP8OTGU/XuUOIczGm+idI81Q9HfTOTT/HJk8Gei8Q3B/DnXKCIxKG2hbJNmTlK6ETV09HA4wjncrlHfqpGKu8h/AjUJdPMAX0tpfV32Kgy4Zsgx21JWBU5MZzn7dMXDLusGowGdJv63eyGVyDuYEdxcrfB2Ck04LdjrNWu1xqQQPOB6nzFOTTs9dEqbUw+NyDj3TI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWh3ampWS3ZlUHFtZWpqejhLK0o5ZWlQRk9XNzVpNGs0N1NubDJ4ZUF5UWJq?=
 =?utf-8?B?dEVvVUxFaVpPWmdYeG5mWW9idDJIejlYcUFQRCtFdWt5a1VXT1NuQUJjSDQv?=
 =?utf-8?B?djNlWVpSazgwZG1jOTFiTm9MQlBjZ2pLckdCUHhwekJyMDJwNFNTZXNlRG9G?=
 =?utf-8?B?cmU2VUkwK002T21tVHNIci9EWHRLQ1hxTU9JSmYrNDhUT2hld09XRlBIR0RW?=
 =?utf-8?B?SnRjRVZ2RWg1VXhkRmlLazNGcVo4eHU2WXZoM0pla2NmSXg0MW15YTNmWkY4?=
 =?utf-8?B?WmJEb09ZZ1lNNVBueVZCUW9rSDdFL0RsanhoNStsVDV5K0dVektKYW9kdHZh?=
 =?utf-8?B?WDExMVRkbVVkbmVmUHNPQjBTcjQ0MHl1VjRQbmRmVS9sYXBlSlhSYVRLY0N4?=
 =?utf-8?B?RGhEYWFJM1dKWkIwWDNGbVMzdlFtNTluM01ENjdpUWtrT01qM3I4TDl1TE9s?=
 =?utf-8?B?ZVlHMzdqWjhXNVU2YlczM0xwUjhLMHFWZDN4cERBNWJRK1I0a2VkY0N1NmVh?=
 =?utf-8?B?eU9QbkIzcmRPdkhTb3AzK0JKcXFMa1A1K3Y4eHFoVjhGNnJEUzAyZFk3eUVQ?=
 =?utf-8?B?SStNSldjVTBVMTVEOUtnVlVCdEZ4YUtNMTN2TWpVMytGL1hTR1ZQaUdYdkl6?=
 =?utf-8?B?aElidHFNSm43R0ZNeVdsbEhFUG5CZlBtVHg4WW5PeUlNbC9aQ3pzeDNrS3RS?=
 =?utf-8?B?SVQvZkJaNjZuZzN4L1RFVjZPOUtlYzJWaXVNb0ZCd0ZqWk5td3lwTENVR0pE?=
 =?utf-8?B?MFRuN2tsVGZQZ0xHeXZ4YlNjS2I1WVRCRkJrNTVEbXpHMDA4Mzd3Uk9oQzVk?=
 =?utf-8?B?V0hkRG8za2ttLzllNExyb1JrTWh2R29zengwOEZOTGhyWnVsdlFDcjV3SFZM?=
 =?utf-8?B?aVpOeFhjL2pteGpYMmVuVGxtQXMwZFEvOXAzR2dlRnFJMkE0Z3BJV0QrSEF6?=
 =?utf-8?B?UkNMdU5CaDdreFh0aStMVE1zMHE2MnBXOEFUTGo2TlYzUnNWRWJ2OFNFNXRx?=
 =?utf-8?B?V1ppbHV6S29wb1QwU2JFVy9tTDNXTVQ3RVNPS3FJUjlpZ2dSNHpFVHY2SFg4?=
 =?utf-8?B?Mkp0d2M4MkJObGxVWDN4aTJrVGZXbGJOUXRIYk5GY3pMWCtsTldtZ2tMeHVx?=
 =?utf-8?B?MndsTmczZkJvREQrRCtsNDRUcmV0dGkxa2JGZkJDclhpcE4rOFZoU2t5Ujla?=
 =?utf-8?B?eUdnSFRjSmEyZUgyRWI1YU51c2J6RHpmaEZiUHhsV1djSjJCS3ErTjF3L2Zl?=
 =?utf-8?B?c040RUhFRVorTWxCams2NWdpbnFTSnpjbC9BQitQQVZrSmZoM2NBblhXVkdR?=
 =?utf-8?B?ZmZhK2w4Ly9pYjJ1NmJkaFlOK1NvTWFJb3hsb2lzMXlqUUlPTkRmaFkyVm9a?=
 =?utf-8?B?MFEwbWVUNkthNkM2blJCR2pOTDZxaW5tWHJwdFFPbk16UTAzUlV2L1pwOWI4?=
 =?utf-8?B?Mk1EWlV5YlJ1RkVVdFYxZXdLUG9LbmlRTUtFUW51SktyZnRUWHJqMWFvT3FD?=
 =?utf-8?B?d1laVS81Nld0N3RodjAySFpEcXhRMUNyVDQ0Wm55ZFFQUlZEanV3SUpPTTR6?=
 =?utf-8?B?V0hBcFQ2OHVMNWxUVEFXMFNvVVVTaXFYTmNLb3I2ZU84K0V4R2FpOFJoMldy?=
 =?utf-8?B?cnBiWHJLT3FVclAzZTJ3aXE1L3NNK1Z1bFFVcUpwTEZIYWk0Rm8zemxDbStX?=
 =?utf-8?B?OVhRZzZQYWF2MUlUZlF6NlBwMUN6SWpRaU9Fb0pxYURJOXc1UldFbWtmWlpJ?=
 =?utf-8?B?TzgyU2x4aHhxMXhSQTBURGFEdjZiM2h4b1hRV1RRUVVjWjArVzh0R09JSU1O?=
 =?utf-8?B?R09XQ05tRkxFL0lOK1diMWZjWkFwZlllYjZOM1BkbGFkNHhwcGpGcWxwaTJk?=
 =?utf-8?B?YjZkbnFtNmRuZzV6L0p2ZlpMaEMwcGx0amkvVmRVbUhoUHdKUExCalBGTlZK?=
 =?utf-8?B?dGlHM2FYUG5sRkVmd3I1RTNOelZnOTY2Z3gyelMxQ1YySm1VWWNwcWQ3VU1l?=
 =?utf-8?B?bGJvQnk4TkJGU215NFcvUVJ5RHBSeXhwRWNIdkt1bGpRMUUrbll4VXgxZ3pl?=
 =?utf-8?B?Q2g0NlVkdDFLbXZ3VU5qODAzcy9rNEU1Z2dQMjFnaTFDSDNhVTJnVUl4Z280?=
 =?utf-8?B?YVN1bWFqcStETVFWZTRyS2tRVVdNSHB5UU9JdU53VVZGSDR3Qko4R3FYQUFB?=
 =?utf-8?B?MUQ2SlMyZXBHMU1teDRwQVV1RnJCK2FQSDZCRXBhQ21lQVoyT2lIOEJOZVdw?=
 =?utf-8?B?K0pURGN0K3ZEVkkxNHFmSmFpaEpXS09tYWxZcDBFZ1NPNlNLVTZ5MnAzQjE1?=
 =?utf-8?B?OHRHTW4zOWR3R2FBa2dTc3FvUGRTL24yNWlnUGtPV1ZXT1NvMkliOUNoeWJK?=
 =?utf-8?Q?cIBF53q3qomjlqrM=3D?=
X-Exchange-RoutingPolicyChecked:
	y/wIfJBvafWyvY9DklAYqSt9Tl5FEA5cZEFTwu52wSUzoqMbBDqbk6/7VpxVpKvpRukljpK8QCdhVGO+6y+ZJIjojb5qvzOzDsOh+HVyi+WzCvvrN5zo6A0UWMYgcclGm0WK+C7PxYpCl/TuzAIPgG2QykLRTd3YQ1DaT2IjIgMSRf4tGm94tFVk13qAM/aDRGly/kcJ/IHJiDOfm715O1n/u7QKBNfIFf296aBSqtinjZwWixmyyoM/UmdqXdgUzgr+6k59bi3jiRlyOGtpXx4yqglHioAmQFWTfltTB7laGjE0/Nh1XbAKBUbMIE6mrmsH6YM44luvXccz1b5YvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eC01VDiid8f60+JfEeIyP7JQE6x9zfe6YZxmw43SiY0nCsa/HG8dTzLNh8nXQisU5Ies07OBH1cncmgq1Gk9gaqtnw6aytTd6oINxrhewHPdpg/OjuZ78G5odQQR3hrU3jrQ7nv/rllI44IvekHaaPvJ1yjlaavRkS6AnQleYZ7ScGJodLjnH4v07+BDrGZQq/0vB8tjN1w3k0c99jKYykRILXVR3dT1RsfHexYCphl0dcmj6FyNsO8egAEHIE4OGsRTsHjeUguZJbkKT+vDnxSvbW+m1gmPh4bXZ8mFSiASpPAdtXychzkHCUc7bWzuXB+s50vQ8FQk1k18VBrpDIZqYuJm6+zTvPwKee+lxqWd+R9JIhPNh9FhnE2TloY6i9EHMeOa1EIu5sKU/Jc49u/aU4C1SkxzuAxFH7QOa36FVSoIGSxnxI/e2wpIUBBWHdXS1DzBU7i9gnhIVQTXTeNCzOvIyWeQfrIpm7s6zJrRrS6oe8tgR+AV3n1BsSyDhFTJteQSgzma5ELfyqkzQSfl3uv70W3vUgce4+uv7wvJJL7xOWjA+/yHxXHZPkq3X8Tap7kosGbPA8rw89eSra/vLCv+8XFQXTg/UT72t1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea536be-2611-45d8-2204-08df2407c858
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:13:15.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ns8Q8sBGdgJO99gX1LnmPiUG7DLbVUq3INzQ2RF9IYO7wHV8SKKv1cs8xjUrgtd/zts08zNLdMKcmz6ftwq9tNHut3WPtx2g6uU1UDLqf0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7537
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=576 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610070000
X-Authority-Analysis: v=2.4 cv=Cpsq4X4D c=1 sm=1 tr=0 ts=6ac58ea1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=ubcoK5Bgffa7cIzf:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22
 a=zhN1exfZd7CRR6uVNoUA:9 a=QEXdDO2ut3YA:10 a=w2-F-CrfloAA:10
X-Proofpoint-ORIG-GUID: pnm79D8xUMGvixzkNKXpKH1ZVCb88ZHy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX/n4easTo/u/n
 +OwuqDmnNFndacRqWPpAVBJ22JuepanbUWWBynou43XavyIVqqGCOc1mUdpQmZAy38MpmM2bVW7
 EmgBc/1an4tUbM7Vcw3OFJqbyzHsVKE443hX3CT04l8qjmS1B13L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX5YMmGed8AaVE
 XTwIElJ9ckx5jY4R7Sf+FYetlxtqb3cQWoCIrXrtuk7GZ0qlE+xo2qozb+JbHmvn0JvS/WNmt4R
 jood+QPRKR5XxY2hw/hHXvdXTbBrxhqGAJnO2jsT1T7esRqv0p5EP96SnyK9V3B8j/29h277RRo
 vjsbZgEPN6ed21z4OifgsP9RFlIkV5QX3nFjRCKjlaXbJO0PNwpHV7tHRIg1M0ftaHGQd8iY6IK
 wDS6Cm9SN4U+kbViLV5g5SxCIE36jP2RWfN6M593QKe2wimDxFEi/Gwug9LqP6nUXqvK2/qA3CK
 Fjeya7HXAATUMPhkBQXlbfqlFBmTdvg8KNLcNlgJoqgc12sGsSxAOykOe0wBVNQ2uvHu/WtunAZ
 hgQZvaZ2I4SAdDRGHuS1dOjJuEb62OPFjzz9mjS4PqIc0B6oEaBAxrDLMPQ/pMi3UieMl1mHmGO
 mEFkgv1bI0ZuKpZICRQ==
X-Proofpoint-GUID: pnm79D8xUMGvixzkNKXpKH1ZVCb88ZHy

On 8/14/26 7:14 AM, Yehyeong Lee wrote:
> @@ -752,13 +795,25 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
>  		spin_unlock(&conn->session->back_lock);
>  		break;
> -	case ISCSI_OP_SCSI_CMD_RSP:
> +	case ISCSI_OP_SCSI_CMD_RSP: {

One other thing for this patch. Was it built over
another patch? It didn't apply cleanly.
