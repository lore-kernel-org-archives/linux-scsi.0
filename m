Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6668F3ACA60;
	Mon,  6 Jul 2026 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783353427; cv=fail; b=nd5jKSCy+VcrKgWJQnws+6qPJnRXx7HvlWmDB1Kn924s3ujKTgLhBtItrmFNEP1lqCCnaUfrXLszvXr+H0rCp2C6dU2qECSD+Q8humVXlL1rO3yD/FDiWFwLlNSzNzaCiphGNf5FhqbGIrk0w/+kKsSAZkZPBmJ/TgkNm/4LZSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783353427; c=relaxed/simple;
	bh=QKbsF/qaMXhpiFjwoOJ3bE2TXLzt+Rtx0EQe4vsN4VI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R4/1+KZo4pxh47yVhhtAmuIhyGkD+uXSD6y3bVSO/ITG9rBzNuP4/9ii8ksR5qxXMx4+dWJhwtvYhQzk6PCpMcMCyttQ4nDQbiiXV7ZlWNc1+TQc4o8zR9aItBLLyNoid8NaKNSNeaaKs0mapjs/NccXQDA0ExAnewWTPIiOSsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kAcFh7Ca; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0N4qqpSR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kAcFh7Ca";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0N4qqpSR"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666EnG3n1226619;
	Mon, 6 Jul 2026 15:57:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J7AitoSPlOXM8VNLTL7wdqwr7Bc1SMT8yENtR8nZT9c=; b=
	kAcFh7Ca8XMV++fNbDX88fmG/QDqohMOSQC5re4hEVjYe0/Vq0EANzdKoFrjjgU/
	a9MK2NJGf08+PndtSAnwpq95n8eShKwAAN4ZKOPKcHqBK7nqP2Hi3I1526vwjy27
	3h+9e9kX4hizB/GiTkhwFproElnYSJo6Eaz/IaiI4mFPre9G+EcbEJEAwGu7Lspj
	Q9lmyN+I1tU4j88snjYq0x2YcNz4qWts+fgRUwO5KmZsp/5+G38LRHpt5UX7xH3B
	KCLekcLawE4DF4OzF7keQqUN7iuwWAFJL9xyWc3KfXnS76ZgePDgPeSLX0+eNlpZ
	SrlMtRH+3jpMJeWpsh35sg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rs1c0qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:57:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666Fm8oI018934;
	Mon, 6 Jul 2026 15:57:04 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012038.outbound.protection.outlook.com [40.107.200.38])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twgsv8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:57:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDYaUX6Rgz6R/CUE5vFiuvNbDdKawh539QxGAslKoGgyw5N89nvkcNd3+1fGnifz6N2QOMNsWF8xgzLAvKsLXu3d57h6Ek9vWPv5U/5J8BsxcdvSLq12s1AMtsjn6oLCGRFXZmAEqLcCJEXe42G3f2ybczBWBciJHqmLNoeunorj1YKnzNltpBa7Rj0S0GA/crXyc3+cjRkktTZbzh8X0h0HeAwfHQevt1gPdbR32Ht9a10MvoIhEo7/Hhd82gbHHuKPHNzmMIWrNdue3RCNn5LqjO4+QqxDs9iBAOZbEvDvs+5v14T7lJJIVCUFLBOBO3eT9bK0EDEUFwBODfltJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7AitoSPlOXM8VNLTL7wdqwr7Bc1SMT8yENtR8nZT9c=;
 b=nLVo+ecfLqvp4I+uavJKWooBpXuc8p9B4qeJirBU57JhgFQWPQBcnC9EccRPEgVJLMYsRewlnbB+lc+XLButxW2e5udvLlryrFlVJWm77QMIBwyW1RY4NohVV3dsSgBd3X3QI29w/hVdNcntTO6cKE6mFqp2MdT85xT3Z78Goor92MhOecWViP3hnfk8iMISfKsBAJ2jb58wc4sHsk4Dwgrx+FiXA7Ihbubo5wWWG/r8VT8Q+5VqKADdcB9ESUCIDihSv8pb6bvoZClnN1w6PLg3SLbyrAS2nlbKkFtXEFr39rGdk4YRJX7JbVrsRoMgEVunBUIpnOOCChZGZyv1xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7AitoSPlOXM8VNLTL7wdqwr7Bc1SMT8yENtR8nZT9c=;
 b=0N4qqpSRf4Qh9oGcGsJycdzr+gQ6DOHcCRmQs0pf+uZYyUM5IFnryWlncllEyobCoPx/RVrVng6qfkrEc5LDcrYg2b5dmVHbWfC+xV3QrSKuhLJxJN8l7AF/IUTRKl+ufsM0CkbfaRL7CBEt+jYGBwSLtWJfhdH8sNej1mSZ+0g=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS0PR10MB8077.namprd10.prod.outlook.com (2603:10b6:8:1f9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.9; Mon, 6 Jul 2026 15:56:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:56:56 +0000
Message-ID: <48cd54a2-0920-49b2-bcb4-508d1bb29062@oracle.com>
Date: Mon, 6 Jul 2026 16:56:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/17] scsi: sd: add mpath_dev file
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-16-john.g.garry@oracle.com>
 <20260703124330.6476A1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703124330.6476A1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS0PR10MB8077:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aa6e8bb-1088-4eae-2194-08dedb7734bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|22082099003|18002099003|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	0crYNONC2vuynH+6P6wXAI8RFAtcPdHxaXDqiS6FYdDM1bFt2W5+43JBt2VzVAgi8ckpbTQfbPWYtAbYqHbWc3LdHXg4wzuL7fG2r89GJJIhBai/u4Qdm+5JSYCTILEpXiip+Ht9UKNPKoOC/ZgApWe5yy8aseAkLTZUdMluhvJRkE6/nPMRplwTObN+Fbo2oidNA6kKLxqlnYRrX5GHhHrNn08KuMUtoFDSlHu8WNaVp48S20PzNq54cFHsNiiifGZ0fGsnFRJoiEH8AAGpDgDjVcuJvKLfxY6B9uvZrFCYJJ2VS/TRkXXOjPNEQw2UJd/hymo+wqVSd2RrU3xZUSyn1Mu0Td4WdHx5iNX9DcUK4pc9yFnhIrY0+qr9xWKJX+WO/jEtKWtB1juqnfs/rkeVlz0avUicdyDHDO2kGCxW/jSBImFuH3E614pXa+7pj0F1LXPWK+wXB/ckqV2N6aKPM6rvP5aGmd3fduOZVpfsaOBWixD3hDlf5zpJ6gwQVbIiAm54wELMGS7IEuiTW8QLSUviDfsYR4Z57gR1EwrDsF+bWJlSK6jYWgLo6OMdNkit5ftecMuaJnIHC3aqy/tc4fg55wXDJLJspJqcX6MQ+dXKpjVIJkzVse/OKifiZw/8K89tLv1bg0arGAmROmLZ6cD/2+VZavVzuN2wjek=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TU1WNFhYSWcrcTVrLzhaRG9BUVg1UEljckZCT1dUTlZuT0diS0xUVldLeU5M?=
 =?utf-8?B?OUpEQzd1SjJ3OGU4SjFpSTlyd2prY2dwY1hYWWJNYWZjcFdlRXBGUWZkc1hY?=
 =?utf-8?B?L1pwTE5OM2R3QnBsNXBPaGZOVXVKRjRvMWI0eXBPTmNycmJNdmdiaGhqeUwr?=
 =?utf-8?B?T0NWTjcvaFBHOC9XNG1LaUdyWHhkeGVvVEJsZkt6N1BhejdiNmlZczVWcDVy?=
 =?utf-8?B?eWVPbTFPakdmN2daWE5TdDdoUThxQWM5a1ZUNDdCRXdnY3hWMUZmdGF6L3hy?=
 =?utf-8?B?eU9YMXllRlM3VXI4REQ1OFpLVUdZTEE4aTBtWE9ueStWQ253elY1RytRL1pG?=
 =?utf-8?B?bzVvdDNONHViaW80SUdkZ1E0b2JOV2U3U3VVNTZvTmU3NkRPa2Z2U2hvZS85?=
 =?utf-8?B?OFVKRitLNnZSQmNYL3NPaHJadG9xYkFPa2VWcDhYNDdpRFlEWGhKQ3lrUzVu?=
 =?utf-8?B?WUNaS3VwLzF2MC81dmR3emMvcDFJYjZyTzlEZnA2Q1BoMXdPNG1yb0x6U1ZQ?=
 =?utf-8?B?Z0t0RE5ZL0VjaVdyR3k3d0kzZ1g2TTZIQnBGYWQwWlFMZitQakkrSGplVnJn?=
 =?utf-8?B?ZG5NUzZnU3IxNkFOZzBkdmlhVURFR1R6Ykt5U0Z2ZXVMak04YWxWc0MrRUpz?=
 =?utf-8?B?Ri9Kc2hPUVZseHQ2bk1HVzdzbXdoOCtXcnZYazc4OGlZTnFkYUdJRjBxU001?=
 =?utf-8?B?K1BmS0l4ZmpEc0RQL0hBRElTSnpYVnRLbjFFdy9aOUx1eUp1RkJIaEZGZ20z?=
 =?utf-8?B?dlVhdnpVUmF5SERMbnhkdW1rRjdpWWZzcUVqWUw0Zk9LKzdweUIyY3VuMHh3?=
 =?utf-8?B?SnI2dnp4WEpjWlBpRnpCdXE1bE5ZbUdnV1VSOXdhbTJ2MmtnVXNRK0NkMHVI?=
 =?utf-8?B?Y3ptUW5pWVd0Syt4WU1RYXJuWCt6dytoV3R4UzYxT043REMvajJNZStvYWMr?=
 =?utf-8?B?OUs1MjRuVmpuem1QR2NGS245d3FuWGNFZWVZUGlOenZtT2Q1cmQyenpGV3No?=
 =?utf-8?B?bFgxaGE2WjREQTJadFNQcmJMNzhnV2FnQ2lubk5SV21yVmV1alNGNE15b1NQ?=
 =?utf-8?B?ZWVNai9yT2o3cG85VjlId3IyRXdBOGdGWTJDQ1A1RDhCeWRwYTdQeHJQV0tB?=
 =?utf-8?B?MzRGMm5aUDNpQUpkeFhzcmZMQmZ0RUx6VWtNYWpiNmYydmNTd0s3RVQyZlQ2?=
 =?utf-8?B?QnVEaGY4dkFjS2VCU0VkbXkrbDF1Ykh3WXkvbE5HdXNSOE9oUjdJN3RXbEYz?=
 =?utf-8?B?SmVOcVJmSFdacXliN2ZVNVNpaHBMNXJ4TUV1QW5STWZHeVk4UGdOcVJ1MkE2?=
 =?utf-8?B?c0VKNWN0STUvOG5RYzdwNGFvbnlIUlFPTWNKWUN0a3V5bllqTzJaeW0zbzZG?=
 =?utf-8?B?Qnk2MVFXbWJvUlBnUzFZZ3VNd1JvMzVnT0JtWlFocXdLSzVmOXBWY0YvWFpI?=
 =?utf-8?B?bnRRUDBmU3BIaGNRU1hwU3BQME4zZjEvbTJxVGlLdWFZelNrYnNOaXZzV2NG?=
 =?utf-8?B?bXdSU2pXQUxDRTVvTFY4WDJ5cW9iUUk0RG5odFU0c0VUWjVUMkV1dkR6Ry9F?=
 =?utf-8?B?cEdBOXRQZWxzSXdaVkhJRUZoU1pGcytscFduV2twbllJQnI3dUdLU2U1dzVG?=
 =?utf-8?B?WS9DamIvY2loempOMmNhWlFBR3JYQVgrbDVjcncycVIxOENBcDgwWEE2eGNh?=
 =?utf-8?B?WXpObnUyWERqK2Y1NTZDd054ekxCYjI2eFMrQkZTNE56TkQ2aE5pWXVoeWJn?=
 =?utf-8?B?Tzl3VnBxWVB3YlV3NUhscy9ZME1kck1yTFVyV3c3V2lKVzFvQUhoR2I1YllK?=
 =?utf-8?B?NVROQTBVNjNic2hrdnR4RTZhSzE5YXlUYnFyV2tKclkyejlaYWVURXo0SzJj?=
 =?utf-8?B?YUFtczdpWVZhL2pVWDl0UjZYTFd0Y3JFK2tjZDZMYisxQm1UbFJOSHZaQ2kz?=
 =?utf-8?B?TzdOMVRZQW9nczdlTHovWUU2eHdZQXlyM3ZpQU9ER2tkazZmOHYwdFFJNHdx?=
 =?utf-8?B?U2Y3bGpFcnBDeVV0cWhjc1Q3cTczdlIzNTNTQnducnQvcHlURnc4UzVwY05L?=
 =?utf-8?B?UXpaL3EwQUFyak9Zb2tJWnUzZUFqY3Z3MjBwcVVPOWFEdWFkZHhnVzJNRHlI?=
 =?utf-8?B?TEdIL2lPVUs2QmpCVGRoYW0yVHhONVVVT2ZLZitjMHZBSjI4V1ViMXY3VkQy?=
 =?utf-8?B?b3RXcmtZcjg5UWY4WXUwRjB6WithZWw5dC9vM3dCZEdhT0laeXdES3ZVb0R2?=
 =?utf-8?B?WnNnUXNMUmFSK3QrZTFlbGY1Vjg3NGU4QUJwUkcrWDV5VENaSEtUMVYydHdz?=
 =?utf-8?B?ZjJJK1U4NjVmbkJUQUM4cFUvN1pUWFIwTHNzSEJCS250bVNZalFwdGdVVjJo?=
 =?utf-8?Q?vg44/IE4uakrFGAY=3D?=
X-Exchange-RoutingPolicyChecked:
	Lt5/Xprvh4ioT2I8pDQMVU43+Vi9J0Z5wZVdnQ/iPZ9fnOddgpK2zFY4qXyHNHeZf6tWpu2dz5lOce5UaizpBX5exNUVscTDe3ClkJXCFOdWQ2AucQAFQE//W5zrYCGwjGd1WqZdxt2kL9ulTTiYW3kWF9Upo6zj8MwacohN4pTlwYmrrncH61Aa5N+ol2CDOaG9groD/I7uU6wNi2Ci3FcFyXLzUt7UpPVbhWvXMRmL94KtJQvES9oJ7xAMHQp50Spwvz7447AXQSc8RcXrecfWfg2gJSMUokTKmNek3ctAc7U5lOhC+K5KtC1X8wT+YzqabAHN0xKEpQ0CZHWQNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DQgnXyIq2SLlgaeGxYxy2MOXNW1qKFxRSM5vljW9bhpLr5JzEL36ZLin2h5rpKjjimn9ruYRTRSwLCIrgE+5+ZSGBVAQQx2IryW1E8cnd4WZ3q1WpdMIawEqyLSEUg737mK7xNOE4xjZd4FEZqp9cyXkFTBfplOuzlGK5srdAboxZgxQs/a8ZTJVHUfYA1g6IytWj8JBcO8KsGyQaBpa6Vxm0LqShxXqe2mMPaHDU9LPnfWNxZzPzUQR9yXFXqJWmj3th4sPizlvhzHkORBxlt6QV1/EO2eH0N1XXfWFlNAQmYCuGvdpww/mRRADBlkirp7ioH9Ay7rqJQ+E17Z4nsFj3Z6luHXW13PACSP21kixMuIH1zbCPXVvpwKRD4zc9LgscnvsCZsvRtksm1VzlIWu3+Vbk61XR2U16Qu4UZqtBnV4GEQ7p8dtWp5wiMRmx89uKprwOig7OIkCQkUupL6/7sKysJ1YKvFGDjvCBUj+b+X5t1sjcvbxE6dPt/iHA6rWo/x/NmhRAkNKKOR6hvSh0Mt1O7TQCJVmCcFzl8BweMmELWEqgY/MglXiLic40tzqOqyX/9YNlY77zXN38wiiKmQ3qBH6DOQyejm79dY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa6e8bb-1088-4eae-2194-08dedb7734bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:56:56.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDMaoNEGOQFZ3YQxODUfMvwz1CZ8Bm6sTITwRr9jVV74WxAOXmFO12F9TbTtmWyl77GFxnJiEOb4k6jPM9SIPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060161
X-Proofpoint-ORIG-GUID: UZv7lNLh-GSeoATvVV5doZikpnl5U3CJ
X-Proofpoint-GUID: UZv7lNLh-GSeoATvVV5doZikpnl5U3CJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE2MiBTYWx0ZWRfX9yDz9b9X2SYj
 uJESj51BTMQZeVTFRqYqAuRqZkrHy4/x6L50UWCYMWLiKEP8VM5vFDXdSwm5ks1/jxZZTYcSwDe
 OGHHRiILnO6JnITvzMhBYneR4iwijgU5+CBMxi+1K8U7pk4rwywMturlo5UapyAdktFUeIYwLer
 gv+NuH9/5FHFkgsQuPsddvOI9o4Gsq1KkQK8VkJSHbEq8G2lAeUAudE2tezGEl9Rb/YW+R4AI9T
 ZKihur3b9WNrMnx4kTuPGFrk7U+fl5Kg6gcz2fLE9SH3re6uASIBnkEBnvwuhYFir0yCAxsWSH4
 fX2VqPyRa/mMPACgbuzi8UqdwU9qEPwVZc5N24/9ttCQJMS0DMDj1TRcDchE8yZHMthxRNvV/7C
 5viiRR3lQVuoX8YiYWf1CwWy4LajPetjg5ytrRSS9nBFdQUTncJOJnQxImMew7UZsq/kXVd4mtn
 Wj5oAHpRpMIbyQfKElQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE2MiBTYWx0ZWRfXwwd5uvkb5ceh
 QNe1DvT/Z8+PQX+Obi+JDewGqtgs9zNAJidP/OxpMcgEFPa1+b2H236ynFpS1VV3OcxokYBWzi+
 DcGFxycJ/WHchZqmpjD1QplzXsZUNYhJKjgk22MxXDQ73apyp3+H
X-Authority-Analysis: v=2.4 cv=Vu0Txe2n c=1 sm=1 tr=0 ts=6a4bd050 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=4qufsP5UtXi83W99g1gA:9 a=QEXdDO2ut3YA:10

On 03/07/2026 13:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Concurrent sysfs read of `mpath_dev` can trigger a Use-After-Free of `sd_mpath_disk` during device removal.
> --
> 
> commit 96501c42f9a149bd257256a80ef8d931781b2efe
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: add mpath_dev file
> 
> This commit adds a mpath_dev sysfs file to allow looking up the multipath
> disk from the per-path gendisk directory.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index a9a29e50f5eec..0c77466f8291a 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> [ ... ]
>> @@ -4059,6 +4059,52 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
>>   
>>   	return ret;
>>   }
>> +
>> +static ssize_t sd_mpath_dev_show(struct device *dev,
>> +			struct device_attribute *attr, char *page)
>> +{
>> +	struct gendisk *gd = dev_to_disk(dev);
>> +	struct scsi_disk *sdkp = gd->private_data;
>> +	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
>> +	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
> 
> [Severity: High]
> Can reading this sysfs attribute concurrently with device removal trigger a
> use-after-free of sdkp->sd_mpath_disk?

I think that we can avoid referencing sd_mpath_disk

> 
> During device teardown, sd_remove() calls sd_mpath_remove() before calling
> del_gendisk(). This frees the multipath structures, but the mpath_dev sysfs
> attribute (which is tied to the gendisk) remains active and accessible until
> del_gendisk() finally tears it down.
> 
> If a user continuously reads this attribute during hot-unplug or module
> removal, it appears we could blindly dereference the freed sd_mpath_disk
> pointer here.
> 
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +	struct gendisk *disk = mpath_head->disk;
>> +	struct device *disk_dev = disk_to_dev(disk);
>> +
>> +	return print_dev_t(page, disk_dev->devt);
>> +}
> 

