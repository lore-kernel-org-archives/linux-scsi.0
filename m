Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E0122CBC6;
	Wed,  4 Feb 2026 03:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770175820; cv=fail; b=T0hPKhrYeVzcfFMI+V7DbrbLmt89fNyIhqMXUsGDeMOIQQ979HCycXfxyfGWQcP10IROBMv758Zq6Bys9ZcqVmwXdoFJFC2dkfe0Y/sHTGekT7ijPZR0wNzWrl/EHiifxEYcO7+EuYRdVItI2K8PERjBcXW2f3dV+lNU7kBPKSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770175820; c=relaxed/simple;
	bh=LgEzcHDbygfcJ1Sp/fKoLl44NtH0j1FxLT9hPLtdUHY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=g9/OUsJqqoI8dTK+vw+OebNdxsL58nkyk6vYU60XhUAXKElWEI4g45sUAXQtLfX+CyV//VD1j3Bdztcg9V22YzbYsRAhZCpskmC53XLq7XxfEPoan8ovGDmbJEFMQBwYbZ+aIftDz9Ki/RYGW1cw0RrIQOHFqsZJfNqcXEbQxrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dPVG4O7s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Csnr2OLA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dPVG4O7s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Csnr2OLA"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuOe94088133;
	Wed, 4 Feb 2026 03:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vyhTwfGqgswH7NmXds
	J7tzPH/ES9dQDbsGYf0Q19BzM=; b=dPVG4O7snaLsRm5rgWr2RQV4vF0Nj/67DC
	68iaUpcv4SxJSOdcF9KcoovHVUshS6hkbWhdRb5xXc9kOnl9vUAnqB3YpsfRut7j
	PpYbnwpqeCSy3QwJ91ZGIiXn06RcmSkNuJ314yKFWsJY7jh4tqcKltwUCJC4UbRT
	lcboXOme8X6YKomww0LT9UWz/aiFVhQuYEH6xUWjJxiVnj+gF7tIcnIpU+M14PxP
	Y60qrnhoDHkNhJF0i/e5vI1UDzlr2QsMuvIbYWnZ6sy3HcLAYMjx+cGqvt1IBMFb
	dh/ZcljFnFA4PSweswYZzpLUIA03jUUKUUAHVGC8ptwPZs2eraPA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb14pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:29:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61422Tnu034769;
	Wed, 4 Feb 2026 03:29:59 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013013.outbound.protection.outlook.com [40.93.196.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186au2wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SGXu77kK79zTuizbHe/oQkS6IeWMGmyTa/k7NbBa/OdN3450owdGD/2sWHciNNnJfPEGeU3ogCuXiwCCZAXvIx0jzhV/Hlq5mfhSomQFknIqFSeEnaK3w/IHqy/KNWdh0wwbaR9L0ZLaWZxh1ZPl5tluZ6NMDpSPYtH2bO0EmxOgcHE80tBv+l4Ba3zOuJG9UXPBgtw0daYQIzrj2GfhGRkTTcCztkiEgvbstr7w8j6LvTYJRkeKd8a0ic20UDQN3y0pK95L9INq2Bs7Q3onk4bnHpboSv3e8EUU9xj8ULgjQ+lTTuOV842rwIbRHgmamTTTFkfbdZQwCAtSv0ot6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyhTwfGqgswH7NmXdsJ7tzPH/ES9dQDbsGYf0Q19BzM=;
 b=tIedHasXUb60qxLiq7/VMyBDV4AxJVnCj4EbyaxH6YGyYSoR+xJZ2rwseHEUhbu4cxiAkMGi7jeLmITgC7QUcJVoQeKlfeNz8MY0FcKWQzRkPA0FNryJF3vhher3IRty/tHiYdiIA9a35w3+7urbuG247anogloWKTGGDpenYFcP5mz6SS0KhQiIzeOPyfDwFMm209E+rnfLwILsvLiPs0AU5EmCKafgWzhxZgAZ1fEmdlFj/bGc5TLlFoIqP1+z+KJT/AsVViJOZQTWR3p4jwZ3K6dsy9SNG7X9NxHZDp6aOe4xBhq0y1ZLCq4353nSRJDZ63dRrzI1WwYH1bHq2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyhTwfGqgswH7NmXdsJ7tzPH/ES9dQDbsGYf0Q19BzM=;
 b=Csnr2OLATyyB8cn67djEnToVI7RYKPIW8wUsEKO7UpnFuRPluqN4RNcSQEeS+fNjSy7jkoMeUZG8G0l689tSkH+Ji4fpp3Cb+ik0WEpx9v/X8KMAUAj/c37MxikM4+4UjR6kLhpf7Xy45gPsLm5BXYO9q6wkO70PmYxv6in7uRw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF109C7C399.namprd10.prod.outlook.com (2603:10b6:f:fc00::d0a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 03:29:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:29:54 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>, Stanley Jhu <chu.stanley@gmail.com>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van
 Assche <bvanassche@acm.org>,
        Chun-Hung Wu <chun-hung.wu@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: host: mediatek: require CONFIG_PM
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260202095052.1232703-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Mon, 2 Feb 2026 10:50:18 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ecn1nq3d.fsf@ca-mkp.ca.oracle.com>
References: <20260202095052.1232703-1-arnd@kernel.org>
Date: Tue, 03 Feb 2026 22:29:53 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF109C7C399:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad729c3-d324-4c2e-00c6-08de639daa12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3f2aPUN3VlBmtudChbbUYxydYiDnr2jt4zkCDP2sUt2i/o+MWUbjZAn6Dbz0?=
 =?us-ascii?Q?OALvR3iPp84KZ3Zt1OCPDnquZrfWFmONIiwQIEDGbyHxK7MOy38pfw9KI+T6?=
 =?us-ascii?Q?hgB/qirQbEYj4WWKiFiRw5IZ2ARYIqEhnZauT63ygrX4haw4aLL18Y0KyeSr?=
 =?us-ascii?Q?GGkNxT0XqNZKfoxvAtnQsfvgwIS28cyMi/K29VD0jO8Kcf+nBkDwZDa8x4J6?=
 =?us-ascii?Q?w8xsagQCJcaxg41bjlBNGuCpDRNuBzwfMPJJxtoKhLazrNCpMwpa5XjXVa46?=
 =?us-ascii?Q?CBuxGF+r8qp6n+VlpRrXo/eoZxXs/fRPuJUt9iWRVMI8v3G8+KlAbc0nq707?=
 =?us-ascii?Q?JgkfW8WVvUcUe04VUMN587Ko1J70BD7YYSLtg0uk/e6hgo/ZUwS3JVLjvDsu?=
 =?us-ascii?Q?t+LWYQRKf5dsy47BgxZ0xWdIISSCuLMPD6UgeDHV40ZO1fYOZR7q5I9YsVWp?=
 =?us-ascii?Q?kqqj0dljr/n0QVJWQxBezbc+p0IhKAi65FYy8OBeTh0QrUQ8GVmrkFQ9LFVM?=
 =?us-ascii?Q?mHQgm33+/nDfsJyy6+x2rlSbpHqsB76C7oSTzuunSJInRyHYo4we4WHarZAG?=
 =?us-ascii?Q?1QAQGru363TlHSFJIwy5KY7gFaPvDVeM3O327PdQHzTZpI6LwaqxBgg6aMw1?=
 =?us-ascii?Q?80vtxE5PYzuJcprLOGR2yHIZEVUW9Z3QCEp0LmpdDF7R2jh2qiz0LW2DKKLU?=
 =?us-ascii?Q?qfvoxalexTkIFmu9q9p+VvaRs+qRWfA7N8YIiQAV/5rLVgvMBHc/UOq+070V?=
 =?us-ascii?Q?YRx58FsIs8+cqFnCLc0wDWfHpAmf+EIEj1yg6GfVCBbzXPXbb6FoRdFgIj32?=
 =?us-ascii?Q?u6oyohGDGaVNJiAJFnHnP2fN6ifYSTTvSgLjhrHvF0NlxKEzquSvpJv4pzLt?=
 =?us-ascii?Q?lcyynHAnjl/dqYjrNO/2UFovSc/Vs9lAMJ7gan5uWScN0Hh+gDAd11U6s5Bu?=
 =?us-ascii?Q?e+GXy407Keq8PSTrWemAFZxu+8i61oUP0gFM7H6RTcfEXNl6c4b2v6AdLXuf?=
 =?us-ascii?Q?MWPY6ksW8Rbsfys9fsv6nsTwEh7aztnP4VW6wPwJLNBjHzSaAe/u6KvbJwFg?=
 =?us-ascii?Q?ichPlb9D6Fph11SY3t6GgoC3ofKgzFlveUJOUyt0/Sksu0JAcJSjNgT9GvGo?=
 =?us-ascii?Q?uBS9rSAap8lNTJL2P9TKK/vCSNHVr+Q+eLyQtR+0MLtpPZ0IxFd6eAd70a47?=
 =?us-ascii?Q?ApJSuiuKE0EtwaCsFi1Jn258fWfmyXkW0jjhEeGjBFegJDmbaRVkD3FepEEZ?=
 =?us-ascii?Q?lqJvjZ8gR1P/1EoEytYoy18cEb6+8Ae9rgUw2tyF6YVE+T3goOVp9RlawkQy?=
 =?us-ascii?Q?eJa3UuqNtX/CDuZXNq+hFXYEbbn9DzNueSIx1z524RagqFsj8jfrMdknpzcv?=
 =?us-ascii?Q?FL9GZqUHcKm1G+E571rzARdP4cBYInFo+Z6ayUMWWKPRtzzuu0xfBh2R7ynY?=
 =?us-ascii?Q?NC9I7WbDfYOoivBVAwEfOHFINoscP5EiQkx08uimTPIuZ+AqxjDYqKqAK2nw?=
 =?us-ascii?Q?feM+2462glF6G+7sHskTjrpPOqvzADHM5FVjYcHhgWyC2fzeg+uUian2Fr50?=
 =?us-ascii?Q?twgwbBmKEXMJwzbzZSI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?28UbdRlQt9CA4fNYUBki+8M8Fb8LFK6DlxHT9k6K7GI+JU59uBdCAUYjAsXV?=
 =?us-ascii?Q?WURpshHCveTmo/YdgzzlgPxdzb135ayIGNkVXFBX1QFF1MbNziZYXDXlUVlM?=
 =?us-ascii?Q?wQuUn+kdZ5IyyBSW9NyFvjW2uJvyq1URN1d6KqCVOk6KANPK/dUELkfXAi56?=
 =?us-ascii?Q?AFdgVAYku++KPgvWARd4M1EGu4EunXbgFW0D+kPMm7sLJ1Hylkg2XsYPFfmY?=
 =?us-ascii?Q?6oG3Sv0rPowg1/reFrCAKCnz2g4qcwnSCGwhqY2ZzuN8IYN+nYPbQQ2pZxNe?=
 =?us-ascii?Q?81nfiCIWMe2tuBDxCmvwLdQA5BehBy+yZ/SGe3dMbgHHvQdsA4dRxOdjyQ4K?=
 =?us-ascii?Q?6+sm+ZCgxIDWTUiQwzT3QmeqZM707UDxZNyN6o4z4ZbxIbDqSiw+Z4HqeynG?=
 =?us-ascii?Q?+X62M9MNlZJULGWyJQEXQdB3RQj2M96alTW4gKtScQuO568od+XUZ1G/hsuA?=
 =?us-ascii?Q?Ec7JHSMAjU9ZVf2c3KAZzG0Tq0NxDQqDbuMrQ57np5W4Qk34X3WHu9unulUg?=
 =?us-ascii?Q?5t/0TcdJOAH2SzwtxKQwkTF85Xm3syIPGi0u5gjESWaeOxg4IL9qNa8R7WqQ?=
 =?us-ascii?Q?ArboL6D4pPyK/d4f58ZTwWLDv6IP5pfY7Nw3iCfwYv0QPPOfJ9ERdNOk4b+K?=
 =?us-ascii?Q?ciRGdHRr/Ob+znXHTlkH6JS34A/9VatsNHmlnw5eJHg4leaX/vfwnlXcEORv?=
 =?us-ascii?Q?XK7FR++Td4d88AkVIIVsOJMMcH/EhSMHtwuLj4U0C4XKXLd3J1h9wYq5sMCO?=
 =?us-ascii?Q?CYbwhXj5zsHB/U1pKeHhcnty4s5DS0Ty9QKMOWR1LK9Bk9Ji9aP2KgXT9Ugj?=
 =?us-ascii?Q?VjIqmo+QPjDxuHUJoJoypEDKdlZ61/D41QJPh7zcxwlMhG7vgaxVnb3iGP+g?=
 =?us-ascii?Q?mWrdE7LQaoOPeDyO1sTRkEhOGTFXPfjJCCPXIYHOGxKajLH2zS5Oeq9XpU4Q?=
 =?us-ascii?Q?3XullgjpB1eC5QFkTv8Lk4BBb6oNc6v2BzSuDgJgnZKHvjaq3NfxtmsMPsm0?=
 =?us-ascii?Q?k3Nxda2L2qNXX+774RZOM7PJ0UZX/ZpwpnJpxwNIbgpM4pXl9XgzKzzKrk0B?=
 =?us-ascii?Q?/k8G7vJ1qce5OG/5K8N/wE64NnVIfpc5I45+6cNWoC6TmXqk861lzNTo/6+o?=
 =?us-ascii?Q?Oh0sI5c0e0AlBqLUsGXhigHMI47Er2BzQoeQPqjz2BGLJEu/OT19eQRwesOi?=
 =?us-ascii?Q?7xq/sXtFQFnFucEiwRXdydMCn4ZoZfN0wYziwi9yVyzOWTZNSiliOI+khN1O?=
 =?us-ascii?Q?paF127Z7KirGa3fM7YoQAuwKDy24eHAYaPVOJe6jxYoK1r3knWwMp9hiIguZ?=
 =?us-ascii?Q?ta68fadlMTiY2Qu2jzVQ9bHRzeD3DV/F2P8IdreIxzak3WA9VyukQse+aqrI?=
 =?us-ascii?Q?7JWZhvCDSwIB11byNtIC7U8wu8IfycqhP10Nz40b5QD05mr5qo26/wW68CgB?=
 =?us-ascii?Q?NnGdOuCKJwxgZ851piRfo3d+p/FKkd3LqsFXE/RDU1r3G5SZVGUm3aycui6g?=
 =?us-ascii?Q?0th1NG/h6PmvvE5wLWP84F/+qt9N8snhTbm32czPLXPtpLf3VZ5SS8e5ZqWB?=
 =?us-ascii?Q?DinZHZAIdVNoW/h375LV/75f0lGycTan/Xn5IxZpb9rwedMYBiODr5JM6MF7?=
 =?us-ascii?Q?hOYQm5WJe5pP/syFuZlv/2Hdn5wcsETfFbdE9zK5RFV9znltaaTEYw0KsIhb?=
 =?us-ascii?Q?KunVgmGfAW2Z+4udl4TLaxpbTxmZAG+tMFI6QBzZEHqUwsFV1slaADooF5jK?=
 =?us-ascii?Q?vhRR6yP2iqFe5Y4QIbgwolqwo+9JBws=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HHS82Eb77H2mN+olERBqiAugo64Fe0PiUWIaZxO7+/zx12Orx8efcuIbm8uJSPEJCEpNHP19j2EKD31AUHbZB2w6U6umVuVq3QAKJMdioyd8lp5hCejpVYiU3GBYZEtKoTMBzGnPiSU/4zh+GCNXeTdVkkIDXOK8+sFXCc5rbs5KennKmsprUkobNG1xFqnTZ/yJo1rbcN0FLl6h2KVzwkTaY+ct3XnL5CjMyIYkqKlycSmaR0Q4JbySR90wSES0rUUVF0LWarfVJg5h3CPCSUqp4G/ygiifhp6JsvF0jng4eQpetdsGKkij/2IZxjzPmefz+bELwuw9Sg9l5RWEyWs2ecG6xVXNKxgQ8/Krrq1JRVfDHG4iXdTtCuFIcYUxSDUvJZxNa5AxPnm+g2Hv7mPj+0AS287KfThdZww3HjTADqDKx2gOabKfbR2QVkwkHd09kU/rnfSHAg5wrSQjqrDYDzRDI88gucgnyMSC3ZpfFAN+Foenm+1l0ZP8qSgSpGxlx+m4U93xjqVcjhINouZfa06Cj062+nn2UVcQjMWOFUpkZY973Jxyvn733UPnVAAZxs5z9PvNsE4+UVcrFmI7MAz5PL2B7LEO5UXTpZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad729c3-d324-4c2e-00c6-08de639daa12
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:29:54.8447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyyPwkSmmvWI6jiNR8rqHRVMESOFaJbTvgj1CbFItgmU7CU9T+ysPgivRazyWOx1R9crFO5HGT/kVhOMYOJtqNLGJeeYtx4L7nwSN2q+PIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF109C7C399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyMiBTYWx0ZWRfX4RSfhHc+S4NV
 Sdz6tbtLOiRYgj6Ma1mpHh6+WR9x43w3n+qKUeXeRLBYboJrAxsHcvzTvNvdZJ4W3aSE8a+5cxi
 zdXALG7gl1phdIG0eEmujK92aPpDmOqaVCLrFABdll/NuFAusn2yS55xpFG3pm8LKlr9R0bYu6p
 8xce6x57QF9u0FYhhPquOXyLyo1KM8ipvtZnYZ8Q5DvWvIVFNp6qGK2Bd736WYJyG7FXKB+NUgl
 J9pv0URlmBGAtY6j6Ri+a72Oax4F6Vlc84bwzB0lhYrUi3090dUWPLNqTG0glG8mGoGN30PDh4L
 H1YusJG5EvvdVCGHRkOiQvfXSuv8d9McaSz+OGB2QperP3YCypiwDN3nO9k8yd+yBX45lo4xVD8
 PnoNkzQj9n6nlIAoaT9yxamBV8qBdqcQu6AvT/umt1ND+6wVDTJASTS23ZcLV2shBBiUCPD7G2n
 GIeWjaeBmCfa2JC5xTA==
X-Proofpoint-ORIG-GUID: 6ql4vMxEATijLvCmUM4eeLSIyrNfBWvh
X-Proofpoint-GUID: 6ql4vMxEATijLvCmUM4eeLSIyrNfBWvh
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6982bd37 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=mOkO6mnTCWDz6CupU0YA:9


Arnd,

> The added print statement from a recent fix causes the driver to fail
> building when CONFIG_PM is disabled:

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
