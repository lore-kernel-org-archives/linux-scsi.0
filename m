Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B185433059;
	Tue, 15 Sep 2026 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789502875; cv=fail; b=gJ4EupGCF2PThf/JGyLlV+g/35fqWVMNsHEzW7Ws97kOQIstmfZP5/a+iNWYOCzHT0LzHgKVsYCVaV5CeluYeaa70hIW9TWOXVtydtEgZzVv4BiDasJ6oz+VwmbCgJXnvz8wugVbHScrS63Fj5oE59WhMynECOgbxh3GoJZdBm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789502875; c=relaxed/simple;
	bh=efk5SvEpczGo4cLsuFuvst0/d3JFxsCf4O/lbCvjv/U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HUCToL9C1HJNdm1iTNNupNWqlnVpD5dOyje0Sxsy6uX0vm0z9DR5J3yENsejhZNFtSJmJP9W43sww60x9rFwr8FHMuZNGTJpzW0YC7zvZ0ow/6lC3L30ZPDm8vRUx1gHqt1OKoM+662EvTlwrhxELfdCTTGhKK3lYjl4FcHXK6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UpWeJNuu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=he/nbAQ3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UpWeJNuu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="he/nbAQ3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FDN6DY3880031;
	Tue, 15 Sep 2026 20:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MrodkPF60Qnkb+tGD9Xu2EKd1K5/9Sb7Wcf+5DfB7d8=; b=
	UpWeJNuutbsb7w3LL19GPYxu/7cu+AM5bwVHj756GuOp+yEjY8ZveuMVwGjaKXOb
	nBPjlMPiOiioNRbbZKr6BW0aR1NFmlXvbcaK6RwDnCxkfA/X0RWNUPlUIy0R8rDq
	OEbBbZikPesH8ZRT2FPoGrgZaL/Hc0JcHFTUOJoNNu6ZmUFdhzA2oWM3+4LQ8+GQ
	zgGBuQBhUMh7tRrLvGw2y6MKAM/D644QpaTEdNkRPi4eXWykW/U1Hgt1aubfIhpr
	vMjrAOVFjl9BLbPtfNeG6aN/P6VKh4BMzfFJBFF5zTSOWBkmyXg1qJPNOAqObXf8
	rfbzzUS2POftUU3xMScwKQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmy9rvd4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Sep 2026 20:07:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68FK56Pn013544;
	Tue, 15 Sep 2026 20:07:48 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6ahw3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 20:07:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GTNZLyV+jm4ajjS92ZKPgQD0WzwdfgU3eQ/Dv78ljXnnJyGmsqeajJQXIL56sUtbYYQgQtvWqxBv+rKqbVzcj0ZRMabMzml9vUzzb9aNYDtu3Ubw5Q+cyZbs7hMzVYuXUwGvc20G2J/sTp4GX5JWkc1wKR/ehlSaY3PAxeV43U7rOFOLEUBixUMEhY/dGV9aRdv0651pOQUtErvHJqOjHFfQjp5Qd4pQ3b1+fZ8A8xkkcSosz5vu4tnxvhVhmsO2UxnrRdHBgZimZHyrhfYJAq7lFASqbqSDtcaq53035R3AvHFhXoYf2UPaz9iDeHlj72RcPg2RolwalBOZqYfFHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrodkPF60Qnkb+tGD9Xu2EKd1K5/9Sb7Wcf+5DfB7d8=;
 b=ECRVpGpJTDkPFXl3QtiJx7lRz1fPOJudr2M3rIPA35yZsbQJYTF5lZo+XoJHqVg1i+Kq+KecwrMOQfvELwCDAB+rEdY25yDLYMU80TXxbRNPYK9q5bKR7y967SQ8YhJKE/R24YFfym1HmiWpTRLKdV16F31k2p+C+1Y99/8gdH9NZEo3ZquhIdCxjzxydDcz1GAirwBVsA1ZIG53O27Z29kq4/tWJ7I02SfxCgdXv88t105pUagay+gFOUKSz8kE+mWcMqE7+kDE9DYILBWFJsM5kIl1mR/kG5yaljCiV0VcXPgggIP2NqelzDxXq80bNHNiq512Gc60lVDkVzfETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrodkPF60Qnkb+tGD9Xu2EKd1K5/9Sb7Wcf+5DfB7d8=;
 b=he/nbAQ3njmVVAQsHAdZRudZgD7r3LT5RHBguNupmgGQpAPCtZ7dFioYWHiHcu5z7DI//pRmAv8HMBTFVpJG43Mdva6yO4lJ7br49C9gchsF1pdxKeoTrXoPxjX/WHNs0LRAvRGw/HPIMBWq/EQwjG3mPTYoiyPwGyfrljZPjII=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CH3PR10MB7532.namprd10.prod.outlook.com
 (2603:10b6:610:156::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 20:07:39 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f%6]) with mapi id 15.21.0428.004; Tue, 15 Sep 2026
 20:07:39 +0000
Message-ID: <048a642d-eb74-47ed-b39b-1932568731d2@oracle.com>
Date: Tue, 15 Sep 2026 15:07:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 1/2] scsi: iscsi: fix NULL pointer dereference in
 iscsi_sw_tcp_release_conn()
To: sashiko-reviews@lists.linux.dev, Ye Bin <yebin@huaweicloud.com>
Cc: linux-scsi@vger.kernel.org
References: <20260821092435.1632931-1-yebin@huaweicloud.com>
 <20260821092435.1632931-2-yebin@huaweicloud.com>
 <20260821094757.45F171F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260821094757.45F171F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:8:2f::18) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CH3PR10MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: 25898fd8-824c-4d93-f6a3-08df1364fdf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|4143699003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RjL9ZnVb4W9O3RlUynwlmbrx43Q5ERP1oUdDZimVSRiVcflI15HhpdHGgwWlTIWytx3UCu9kEXAiup3S7eje1l377tgwfNa1PSK445pnEkMnzLbQcHwyBur10BXx12uVlYKdmYLTAlv3T399B+yAWt50rgCClOPdvtOgcZBfd4S5cfJlc/HCQH1+UKg70xfxUD4Ks2DeLHl5ocIUJxUmCDDSD2gyRg+7ibQlvcTbp2tzwSu/VN1e5pfdc7BWTNXQlmKH5Pb6rkA4/lnRyghr4w6a/AjTMBMm+V6w54JD2yysdvjzZOw3BjGyClRLtZssNpaxeqoJFw9ueLj4mJ7Mo9ug6NVci27rF2+14bDPRf7HvwUNsut5VpaKkVULaZ87YZfhbQK1FuTpgT1RIaynmW8euOBisrsLpCEmErM6y0XZAcK2vQjF/gd112NgolZYLbfb8j+bRzCQUuaXWxL3ZkVyfHd77+NpUYxMvNA3Iiv3+d63ELvSqcyjNp0oB/lAOjTWqARixzowA3nmQpoZzHY30euMhkPHrmAySXQ7W0ThS948yfpzhR+r56X0o/qaq4ES2EYj2jp0u7r2UNw2p7rPKE5emQVZgGARAeJ/nuWlUs7mbpccICtRxMOrGKgXsrU/09YBViTWe7YfeOCDd/0o8JFqh+8ch4yiHwdmKPw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clNPeXQvVUl3WUVFWGkvT2dGcUtucEVvNDFNR2RpdTNTVm1VMjNQaVdIaVlG?=
 =?utf-8?B?QmlaUlN4ajNTbFM2L3M4WXpjUHdrcm85cTAwcEVYbkl1N2p3UnRDTlZJYUwr?=
 =?utf-8?B?ZmdoRTQyWnZDaUthTWJERCtQc3YxQVN3YVdjcXVpMkJJVVNQNlJDVTFEWTR2?=
 =?utf-8?B?Z3JCc0JaLzRrS0ZNZ2ZFcWFRem9pZnNabkRvYXlVM3puMFRBS1BlKzRMZmx1?=
 =?utf-8?B?aWlBZE9JNHJJTnV6bnFtUlJ1QXRDUVRESnVzNC96MTAzZHBTTndFaS9qaHZP?=
 =?utf-8?B?Wi9lOW5SbnFJQWRXZ3Fqc0QxcE5MYXdqTWtDcjFOUDU0MG9FeldPdGx4UVc4?=
 =?utf-8?B?SzJFK2pjMkpsWm9yTjRPMkpWMlZFQnJGenpUdFhkRmw5TE9HMmtLL3FFQytB?=
 =?utf-8?B?ajhxa3hQUnducHRqcGM1bGlpY1ptQUNjMFpxY0VGOS9VNEZkN05oT2JNS1hD?=
 =?utf-8?B?T1ZsdkZtRlhzNUdhZ3U5RkRvVzMzMmNYclpMTEpncHk2Sjl6V2ttUFdZZ0Ro?=
 =?utf-8?B?YWlldFdtajhxSlpEcWU5YWtRTUZ6UGk1cE5OQzNPMTQ1cGdQWEZjQXZ1U1NU?=
 =?utf-8?B?eC83VDZnVHBXMklIRDc0U290T09ERk0xcHlOTnZhSEFvZlZWVTdqazRiWFBW?=
 =?utf-8?B?bnBublZGbUR3TFBFaGpNd3VLYXBveFpDbUJWRUxVK0FjSGR0Z2tpTW1YSFVr?=
 =?utf-8?B?NGlMODlKMkNUbk9YWDUrRVJrcVFJR01WUy9jdldKZlJoS2t1TlhLdktOSmJS?=
 =?utf-8?B?ZHladG8vTEFSL2JGM1dYTWlvQmJIdmNHNDRrMmc1citseE1rRkV3amI5cy9k?=
 =?utf-8?B?NzN3em16ak95L05yM3R0cDB0VTZINkVqYXFZbzNkRkxQcmZFajRNcTUxKzg0?=
 =?utf-8?B?VzhlM1Z5V2VJZk8rSmR5cTZqdStiVGlGWFJ3bkNRWjdYUGIvVU1wankzcnpk?=
 =?utf-8?B?SytVbHpjU0F5aTBpaVV5L2t0bTY2VHhaeUljcy9qRGJJRmlyVHZjYi9VVWwx?=
 =?utf-8?B?bFgzc09QTEZZd2hId21IUnZWTm1XdnNsQXhXSlZYbzVpSDliSzVVYWZsclRN?=
 =?utf-8?B?WXJtM1BXRTJ0NTViV050Wk5XOEowMDYyL2tEUWoyd0thTUpGWGVqemFMT1Bv?=
 =?utf-8?B?NGkyNUExczF1OUpuQ21XSWtwR2VUZVBtTTR4b0U3ZEVnLy9yMGd2QzNXQTB1?=
 =?utf-8?B?VlNpd3Zhdm1aUys0dlRpQ1ppMjI1TXo0cEhmVHBqQ3ZWYXpoRS8yNGppYTFK?=
 =?utf-8?B?d2FHcVBMbm1SM1FlN0hRK2J2ZjJvM3hLU1hBOCtJd2xFQVBVV1ZqUG9rMzMz?=
 =?utf-8?B?bElsSWVVSmdBSlZ0MlVQc2pPekFjU0I3dHlFSUJZdUFyODF3Yjd3OE5GYVdS?=
 =?utf-8?B?V1FpRkRrUGpjKzNkNDZoa05hU2pEQWxicTlubjVRVDNHZzdvUm5TQ0habWk5?=
 =?utf-8?B?OFJ0TmNMeHNmWWlZM2FrcjUybTBFZE9kSlZKS0NVdWVnRXdwMXNPcGlIMUl4?=
 =?utf-8?B?OUIvNXhBM3dJdW5kSy9ZVmcrcE54dmExWDlQa1FZRXVON2N0b0xZY3puUzVr?=
 =?utf-8?B?UmVEQnlqNzJVNUdodVg5TVRhU2pPOEx6MnhKRUp1MGkyLzZJdjhoV3VJa3pW?=
 =?utf-8?B?NDIwc2hMMFZNNUFRNEFDK3hnMk1sUHhYaDhBd25GVUtWaTh2d0MxeVRmbWtl?=
 =?utf-8?B?bWVDY2FISkV4bmFHR3dLd2NhZVhqT1RCaUpqbmJQVkdvQ1R0NGVNajgrNU9q?=
 =?utf-8?B?YjNlM1B3SkJlckRabXFoeXV5YUZPY2FDYlplTkNSREhhbEVKWEp0M1NuWkRD?=
 =?utf-8?B?bXJKR1B6VllzcW9DR21TTjNISUZNek4zNDFOMU14aXU5QTJaVVJQcTFTNm5S?=
 =?utf-8?B?U01WWUcvbTZGcnBTVkpLOHc1c1duL0xWa2l3MUxGSER1UWhQRThuZ1VVQVZQ?=
 =?utf-8?B?LzhpdjNQcWVRaXdtazJzMGMvU3VVWklHcTVrVGYyQ2pSV2NtTDh1Vy80dzVY?=
 =?utf-8?B?UERpT2l4ZDhGcHg1dC9QblFnREszOUQ2QWU3elhnYWlnWDdvbVNJcXZ6RHpr?=
 =?utf-8?B?K0F6bjVsWVJ3YVNLaUtmK3QyZHRhNXZNcFp4WGdrYU5rVWFnYUxhamptN2Q2?=
 =?utf-8?B?RUtySFl2M2J5aEkwbGxnZW1CUEEyVEV5KzBaQjJndDF0WENDYXhSMmJzV0pR?=
 =?utf-8?B?ZktNaGtlbTk2cnp0MEFNRUh0TVdvVzY4bUJnNU1YY0hXQUpOSTIybEpva3VF?=
 =?utf-8?B?bkw1N0ZxbE9HRW5xSDQyK2gyaE5ZUUJicGNjY2F2aGovdUxHS091QmQzajhC?=
 =?utf-8?B?dEtIYXFqcDdVa2ZhWHlib1FzQ21yMHlCVWFMSkhnS2hoQ3B3emY1YmltU0kr?=
 =?utf-8?Q?rQ9TOCi60dsVFXE4=3D?=
X-Exchange-RoutingPolicyChecked:
	pPMluMD+GIXsLJsWrYJHr1GaV+3z++5YazPAojVyj7HHoDW6Bwhc8gma09otNitT1R3yeiz3o6E2bW9BlpuImD1nOfAxarhGwPtAH9S0TiRVk1T8HZtBD2RfJp95B4nJ8+vsUnwVJ8Ov6U0y7mA9wY5dcyJ3VWznrOk97Iq8YDK+TmCtdZPSHKv1UWe6e7+2gyvRSzVSZYyv5Pwoxm+ChcerF5XaAuJssU1vK5Ch9JvgMlWwAJjBOgMy2k82BGthRY0urMcWZIXzxcguk+hhKRIq2Taay7B9T+t6wxBxhlWll5rS85LBRqZnrYh3ZiwEVh3fsnKJ8ukgmNnHmYJw6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/2+Ne73JL1kPhltilHk1lTTbVxGsHXA8BxJ4uirZyejki9/I5aGhdzo9zsNlgGhzIsVSB1rwm+nG5oVmzRXwkN2dZT70eti6xIb1KhEcShQ7Qk5iom/l89aThNCwnIc4FvwInjPv1pEju+AVsk6YLkpRTakCO6UgwXOd+RNb9nS1wj9XGH/TwHr7Y3SJoYfPJ1ej7JxIIUfZFjoK8qWK+6OOxfOeahAJ+Z2Sq1ToyyRlCqRRZMVmPWF4yqMlGu2x+o29rmrBNkNfZsJBb8A0cz+yMKDQILdUNZFLxZ9LaYXaI9JhkcLRczUnw5w5yrd0XCj+PHyiIuBuVY7paDED9Ymc2rYBSZaI+pUoyTRX/jGFBTjEt1TPlBHuPGYq5SCBkZTCbBhruEIPo4xBsux5/d4zyW4XSQ9FCebr3saPuv8Zy2X67mUcFKCOPTYlGm7nhU5t5Jxv+VjDRxM2a20ptTE4QTrfi7UmHwlxNSGo7iiGSG/lToFS16MY3YUBqV59ZIXFDp2s2Jp4lDcz/iuqbXCDJw3hAlrhEo5Q4gXxkZJI/isA7S/AcO8/WkvZ/xG56hALPGZ8u3vLotKp+Cb+PY1irXiEazBdPnZ1qhwgzHI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25898fd8-824c-4d93-f6a3-08df1364fdf3
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 20:07:39.0809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDFHDOicQ9c20RBBhpLa6ApvQbz/yTkdIgckUlq/NVHFB+h84pwcjBYUxxiaVBv+lpG8pik+AOIrmx3Oy2cqIwRqbzQFV5kXnhboRa20wWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609150293
X-Proofpoint-ORIG-GUID: 89kgcgePqvyBQA8HSCzqn7_-Ja97sN7g
X-Authority-Analysis: v=2.4 cv=MuvHeGae c=1 sm=1 tr=0 ts=6aa9a595 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=4NSHw27pDR18waeFCfMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDI5NCBTYWx0ZWRfX+9k9FGNXMtPF
 nsiVDEL4GXYScpnl1ULK4hSxwi+vqU0gh8BTy8VflpHmxeBov/XG+RMh7GqjuJeTrij6paZ+gHT
 cE53qZjnXYqZVsfBezOaduzV2x2DJn/OcU9ylTvoisCawYLX3MmT
X-Proofpoint-GUID: 89kgcgePqvyBQA8HSCzqn7_-Ja97sN7g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDI5NCBTYWx0ZWRfX5y2V5EQ6p0nX
 o3ZDoSNrLzfs4+y1b/2U4aLbhVKT3Xj33XsGVgYAow6fjzmjfCh6CHtdrhyoV+YJO4RoDSlY2Zb
 Mly8FKqm+zhlpQSp0KNVnKuGRC1Fphx78yRAKYryzDiDv8VWgtjexY6IavmgsvPS0hCkiJZKAGZ
 iv0GS2kxJWvFDTtTp5NCQKZpOlLgoxzeS2nFJhR5Bk5RBppXYYqw16Z0BN7o3WhFHkIL7UiP/gj
 LlhxVYBuLN+Iz8ZXvzLwBAF/PizHrjdusWpFdGSJ0A62OyeUvqQNCnqHS/9xg+nde5LWtoeBA1G
 kD8tazlN65nwvbenWC0lyupd2KSWz6N8bkgCX0+0T9phleh4ldjqf/D8HRx+iI510M2l2ZdwcVL
 Zg+7jLbwzfcZlrva7lTR/uVstE3CS+4hW9ZQusWYiBGYieABdmAtyyB3bH1ZdijHJ8zGRd3rfuD
 TomWdBjo1SD3eR7kfww==

On 8/21/26 4:47 AM, sashiko-bot@kernel.org wrote:
> 
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index 8aa76f813bcdb..aea319c1e72fe 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -2278,35 +2280,36 @@ static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
> 
> [ ... ]
> 
>> -		/*
>> -		 * Only clear for recovery to avoid extra cleanup runs during
>> -		 * termination.
>> -		 */
>> -		spin_lock_irq(&conn->lock);
>> -		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
>> -		spin_unlock_irq(&conn->lock);
>> -	}
>> +	} else {
>> +		iscsi_stop_conn(conn, flag);
>> +	}
>> +
>> +	spin_lock_irq(&conn->lock);
>> +	clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
>> +	spin_unlock_irq(&conn->lock);
> 
> [Severity: High]
> Does this unconditionally clear ISCSI_CLS_CONN_BIT_CLEANUP during
> STOP_CONN_TERM?
> 
> The original code avoided clearing this bit during termination, as the removed
> comment explicitly noted.
> 
> If a connection error queues iscsi_cleanup_conn_work_fn(), which unbinds the
> endpoint (setting conn->ep = NULL), and then userspace initiates termination
> via iscsi_if_stop_conn(conn, STOP_CONN_TERM), iscsi_if_disconnect_bound_ep()
> won't be called here because conn->ep is NULL.
> 
> When this bit is subsequently cleared unconditionally, and userspace later issues
> an event to disconnect the endpoint, will iscsi_if_disconnect_bound_ep() skip
> releasing the workqueue's reference?
Ye Bin, were you working on a update to this patchset? I don't think sashiko is
correct here.

Because ISCSI_CLS_CONN_BIT_CLEANUP is set we will not queue new cleanup work while
iscsi_if_stop_conn is running. Once that is done we clear the bit and if we
reconnec again the conn->state is BOUND/UP then we can set the bit again and queue
cleanup work.
