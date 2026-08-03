Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA01835C183;
	Mon,  3 Aug 2026 12:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785761654; cv=fail; b=NDpCLZaa9T8YHcZCk3Ygz7TlyKVR5JdbJvP6PT3QT5alOPani3oo9HzTDz569ja2hXe4sE6bxyWKBAuSywxBJmI6WepGf4hB87G0+PavmlDMgcxC1oMjEOzp3LfJtpqmtj7ZK2wMvkCUufMJZEy7lUBg7LKqcVvmY3hg0nMPG7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785761654; c=relaxed/simple;
	bh=uXxCbE5iylUrKa5bwnjmZli3vr5HXyNYFv8xO0OhMuA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dUX5obBJp/uv+s9umzY6fvwjjSZKq3dotJzbA7kd4UVy6TsZ16IYpc3BboqqZk54ehYSGjoaGtvA//hAb2wu8pjt0q27R4+dJ5xapt/F0eEPYTrDjQEqFH+a1zkBRqwGXgLcOeSMKHKvjREUxqQkdXFSkouW4vKuGHbjAICEcqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jS/7yNOr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hOd2CRbZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jS/7yNOr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hOd2CRbZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673CC8XZ2754123;
	Mon, 3 Aug 2026 12:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t9/76ymHMv2dQKjk/BbIweC0BB8FmibJ+TXpmIjjC0c=; b=
	jS/7yNOrm/bP935nLNi+V8HZAQZJhow6g67NWDsbqXaPcNIJ8CmtgUxJPrlLKBwn
	hnA/20bYNatFKbzYqOnXovPLrt4nkVBnj2Q5EEyy1aZ67I9lh4aAs33V2erHWcMB
	0KAiw1h7xl8G85g4ggLdV5wWsYaFj1qxGlVPhE6UnMoI8U0r/xPZKSvjvnWXYn3j
	tcAzpzS5jedCnac7qRReDdRYDOk37EqgGUa5x/XXocC7gTZTOVxN8AsLG6ehAl3f
	i8hVZFERL1kmCsv2JaMfXuaRuV35cbbge4sr98xR8/pgBUIfXLHJLH+Ew/zU5xli
	Iqxno0fc4KAXgRZT6gw52Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cy42jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Aug 2026 12:54:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 673CoUEC013749;
	Mon, 3 Aug 2026 12:54:06 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78rqqvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 03 Aug 2026 12:54:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMOK96zx5XFD+KPgDoOd1vWqysI/dIqNo5BR3ulFBOoyHJyiXbVL6REQQ6KnU0/Yqp/Ca/+x9B7Xcy7sYA8LgNB2tdUbDpXR1GFwJTEVfQvJmlt768kIkiNN1lpVfoqADRCCDh3akLdrdTcVnBteYoDMQpWLrlk4ag1z5yoounQzfxfI+CQ8krxbyczb5SwI3i/nEwqFu1PMAd4e+DMjgZP8g/jvYX1Q6AwPfR8NZ6HFXel2jegkBM76V+m5dMbnvtjHmG8UzX42HY44q3196slpO4RcT6Y1znW8zpp9D4Xy8zI/tZAbfALTBji4VijFSEjS2EAvp5hdKBvvNU9LNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9/76ymHMv2dQKjk/BbIweC0BB8FmibJ+TXpmIjjC0c=;
 b=s+89LBEjVQ9lAwvSxvYoRAEPBpMzJclzV3nA3GESyG+rmBtGewtFK9dFMWSTqD1wHGdV0bRZp3YnbaJmk6RnkFEzrG2hoBDx6f+ukdpkbtdF6wVUN8zcL0aQx3IYrCHq8Oyy8lqKshrw4YN0cIVG/H2uQ9ANV3NL0Rjr+sSosm00cJfwBiI0dE5gwI94TbfhZQyTYf6hGwwSc+a1wJ0dxU9cNE4uReMpK+0jLyK0Zg2RSh30/kA2wW1iQia77NQIf0h2qZCa4B2Mfo0EyTYP1nuxvROFpJrXl27XpftEHHaj/+JbDOltQ6nWPRvF7L2oBfhm8OVTLTe8DZ8k7adcFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9/76ymHMv2dQKjk/BbIweC0BB8FmibJ+TXpmIjjC0c=;
 b=hOd2CRbZgLyG/GLaUZHNDr5wSj6ttDmnnVrpCb9aTuTLQMmY5/IbPOgtm+V8SpINfx+RkcTfi1jIKI7cX9KardWxx8PS+QucEakxVpfbBTbXzNu+nSFi+I0/34KPJ6xQkzJxSxB1jhP6XO79DnrUtTZvTqpvWEyeI6tCnwg4O1w=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 12:54:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 12:54:03 +0000
Message-ID: <70563a46-220f-47bf-b3de-26e8e37eb0bd@oracle.com>
Date: Mon, 3 Aug 2026 13:54:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: negate wrapped memcmp() result
To: raoxu <raoxu@uniontech.com>, James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <E5AD42E9C0E18633+20260803095328.3445311-1-raoxu@uniontech.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <E5AD42E9C0E18633+20260803095328.3445311-1-raoxu@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BN0PR10MB4821:EE_
X-MS-Office365-Filtering-Correlation-Id: d0486df7-94fb-438a-e999-08def15e4b53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	DHA3nc6VVLEnZDA6WZFfBk0ytvwvMOSW9Hri61aT175ZHO0GUOxfXHhuQ8awLsWTX86HWVA6suPZpvvY+TF18qlUUsX7WsQk4IMqQF6xbFh4VD6P9mC5xPV0cpKvRtUKQtsyQK3paA0jEt/Lo7mdooqM6yqf2Os4dodhy6zk+oypREHB1zfOGnedMOW0I/UEiWLDoL2NXxAHjYL+UkGUMiGgHm34I6wT4kP07nHgYegboAoT9MBWJgnCI/oI09vfGblwmRY7V7vR8KfiO2Kf6LQlTqPIH1VqIti2RJ7EbS0OMRvQ3l7sObV6z4OBaMO8uHjuxxtLdmM1EdoRcxgOYrF6tcHyfEuVN7aJy1GuOkm0jmAuN/E5QixB1LnvlRh56Y1FlyFJ/FUjzTiVyS73ljZU3US2GhKBaPqs4T9LRGArosqAnP1GcTr/2vLWC8bqGFNEHppCy+rlkha7ROEKTL4356TgVz2mIyjiGxUkT5PxvNuYKcZKrII7jY7rED3f9KmfxOMlZtm92MtqeZFBadInpDRvrgk4jF+pF6LEe3eUVoGa2XEz0XOERUOIuz7nkur0z9cLC/a396mLkO0xVRaPAoxGBsbPJB/X4XFzkU9Zo7+QFIrvWtvKWnGPbW5Fra5ET+sKFBjKXlryk79jGadsoj9lNIFFBG93AT86A1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVhjR0l0RVVpSEIyOENYdG1YcUd3bndiTU9CYmhYVGJzd1BUOEM0ZDRSYnZU?=
 =?utf-8?B?UmhVRWt3ZFkrYnFPYy9xMnh6ZG10RTNvT3R3VWx2eGp3YWtvNWdxNkdheHMz?=
 =?utf-8?B?cWo5RnpFYnlnUjlRRWpMaHJIK2lteG02MFJtRy8zZEF1YXNLKy9rLzJTaHlh?=
 =?utf-8?B?b2dVODFyekZNTWl5ZVBmbDZ1ZVIycjE4Vms1eHh3NlY3Qnc1VmhrNW5zL1V3?=
 =?utf-8?B?cWYxZnlLOWMrdmtuYlZ5VFg1aFk5allPT01JWUx5SzlETnRER0U5d3V3cmRK?=
 =?utf-8?B?ajgzT3pISVlSa0dlZWJlcTlJeWtzNjcydVRsUEVGZEtpd3pCNmRYbnZUa3Qz?=
 =?utf-8?B?REpweVVvZGR1WFVxLyt0NUNhS0lvUG1qNlBEU0tPYVRSWkR4YlJ4WnlsTm94?=
 =?utf-8?B?Tk52dDI3VU9CeldwY0dveEVGZlUyRjJoZy9NbW5SVW9KdWJCUmlPUUVrTW1R?=
 =?utf-8?B?MFBPb2lGSVp3Wk9EaFRZa1QxRFBxbVE1NEJpWWtrcnFLUHRMZXFpVjRrdFhO?=
 =?utf-8?B?aHpUTXJVM0ZLNzBIMU1QT2RCUzVpYWVMOXRGbUlZU1dmaTQyNnVkMGFxMDJq?=
 =?utf-8?B?Tkkyek10MFp2OGxXMWxRd2VRZzExWEQ0ZHNOK3RLZktlaGszSW1KU3dORDVy?=
 =?utf-8?B?MUliOHZaMTJmVGtwdWVONVhvTDBFR01tY1MzN1lvT1BjaHBUUEhrc2t1SUNG?=
 =?utf-8?B?RkNxUkxmUExybVFjQVJZS3dLRHJUbTFBZ1lpcDdja3Z0Q2d0eUdmcFpKdElx?=
 =?utf-8?B?UFFsL09ob1BENW5lUHI0WEhwRmVGMzBTQjZCNEFWWDRoOWErMFp1VHhIY05E?=
 =?utf-8?B?ekpBa3N2Q1BmN20wNkdkbVBTb2xCZ21wRFRPMHBFR0E1Q083eE5QOXpQODFM?=
 =?utf-8?B?Y1BicDFDLzZ0ZHZybXNlOExOOVJqSnJxc3ZuTGsraGg3Q0toTnRPME85bXZD?=
 =?utf-8?B?ZEVzSk1STXYyQS9lRXhQS3F4MkhrR2VRQU1jcWxUdjVjbFkvZENuaDhuWG5R?=
 =?utf-8?B?bjUzOVNqUXkwTEdUSU9DWGd6NkR0NCtEdms3UCtYc0g1NkovSzRaL2d4ZE04?=
 =?utf-8?B?NEozUFNMZWR1amROeDYveUVCZ29ONzZKalFPem1Va1JiM1ZmNDlzRGVjZnRO?=
 =?utf-8?B?YjI2WG9mejVsQmR5ZlpidzVydUJUbUJhYnRSMG0rRFJsWjBsQmM3VFZsSi9M?=
 =?utf-8?B?V1k2WlRLNlJVQ24xN3dtWXRWYWJOTDByN3liclI3ZUtrU1J2WFdZdmJ2Z3B0?=
 =?utf-8?B?ZzZ1V1FjRWEwVUVseVRHYW9hbThhVWFpanBSNUpMTlNiWUF6cGJCOGdDcnhD?=
 =?utf-8?B?eXpHait0ODBseTkrMDFyYUdZbmh1QUVxTlZNd0F3WU1xM3VLcklTOHNQNUI3?=
 =?utf-8?B?bEVzNUFIWDBRZXFRTXRZU1pRcStSdTBXdUdZdTlSUEFabWk0NHhmdDZjT0pQ?=
 =?utf-8?B?bEZqSFhrbUlOK2hTYjgzWGR5aUxjSGszTjBQRXBBS1NIRlRVVWF2SzUzZ2ZZ?=
 =?utf-8?B?a29CRmRKeWVqWWNOamRZV3o3TkovbGNXaHhWWU5SblJ4V2FVTjJEdnh5Q3JC?=
 =?utf-8?B?K1dzMVVZZ1dBNDIwVUJYc0NPV1Y1bmFVT0FuR2ZjV0ovWnRhMnhZUVQ0c1Rs?=
 =?utf-8?B?VWNlVDY5OGFlOGpBSW10T1o4anpKRzFGUFltV0ZiVWZkTFFIalZuVE1OcWxn?=
 =?utf-8?B?aXAvRCtYYzF1SmJEdzMyeGY4THg1bGdVRmM5elJ5KzJmS2gyTHRrWVdGUGc0?=
 =?utf-8?B?REJVWGNlRGFkL2ZBY0pBdTBpQVN0NDBJcGdwaExDSjAyQjJVUk94WFU0SDQv?=
 =?utf-8?B?cGwvSTNDY3hZTHY1bXJESU00SkFERVZnZE9xQTA1NG1pUVRkNEtXNkNDM1dn?=
 =?utf-8?B?VFdZTHdsWVJQYVFwMnp0U0EwS1FyQ3dPeDlQZHBXU3ZReVpiNk4zdGNJc3A2?=
 =?utf-8?B?R0kzSzlROGJXeHpUelFFczhlSnc1ZGlRNEVVeHMyZjdlUHRWTFRzSWZtcmFn?=
 =?utf-8?B?NTduaTM4cGJFUkVob0ZCayttSk1vTjRqUHFpUlFQbURSL1JVNWIwakc4U3JH?=
 =?utf-8?B?dDFmYnlxd2NROUZtQzI3K0hRYzlWSGZDZWtrYU83QmFxZW50OWtEUEVlcHRT?=
 =?utf-8?B?WFp6R0NicjBhZ0V0Zm4zTit5RDR5Sk50ckRQMVZTQVJ5eTdob2dkS3dJdVpV?=
 =?utf-8?B?cGpLcW5PalBxYm9Tc0ZIMmFSRFJ1Uzh5WHI0c2l2bFJhUFNKTlliaUc2NlAx?=
 =?utf-8?B?dHVUckVRdVNYanZiazlTVmt4bm1GZU9NbjBybTF6SGdQWjFaMGliQmp1M0VX?=
 =?utf-8?B?LzhaL2ZBSDBjb2EwbVhsRmUycUVGaDh4WG5NSkdWbEVLeDlQTjNmQT09?=
X-Exchange-RoutingPolicyChecked:
	Ewofdx6tLOSF8huBBlJ88oEB3IN0ava9aFPMCiJe05fNj+HrQsWlIySB3ruL0oDrvwUTKAA55WV9ejUZClB/+vhyLEgkMILASXj+VYQHjotF8uXm+8aD2frZLL7kwc07cRF0EFQVnswyKgrbD+KAqbxkB8TV0skaBDCuee1iuuPDvUSk1/n71BPoxTwCX7lsqKC/gfBcucybT9/PrvJBsumfWKavt61Rnqq881fODzWylUzoXZao/L5QnbgBoPJSXEUPJ0gJc8MmRnwz6n7IQWekG89YHXoxsiZ4ZPk9jbDUiar9aWKRY1xIEAhBtocnUNruJU1YyurjzMopSwVHew==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UXD1Jes/zoILOKOxpryVRsVP0mN28/gDy331oZEQxUqPewM16P7OMt3eB5EVfU6NiuIpC++4rikk/8OSJOSbgqKSUy75c72CveKmjrlOBMTxUuV2qlOz7ODUMbunmxbBvdHRwoXTci4WrOaaGROZOFCqXkmDXLyRFEVueRUKFeV/Uu8e+gD33OQ63pJEz/1GuZ29EhqLJrGiQPDnUE5UFUBGFd7+p7mFkKE/zuG8pN8aaosuIXQUnM9iDtJu0yLdc6UO1s8SmQkfJexOiJKzXrxQfLuJS9u+pEnOTxDHDBwsAI/0v1BjArfGq36QnqZzytWSrGLTooXq1Zt3fEC6jewCyQaoWJCSMdcU6oEEQ6aAL3ugeXLQDX06plJ5Ng3vEs8/xsp7MJBp5fRQ1ueXVBSKSo++/bteYeUwsKSefGfGAJHb2VmyMQEorO+jgjfZ+NTVuhadzDZzIjy6TI3eXVFaai9eYiQMdPCJk/unKAueM8VJ85Eu9veAXg9aM/s6Wm+cRZUovGlI3j0l/9rk5SZoNROUu1hlOkHhQnungvoG+bgMYHXdIdzV9yzdfN4KgV++5f4CRykWn8snxAJTfY1RJGfcMLQkKoA/vKzMHIo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0486df7-94fb-438a-e999-08def15e4b53
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 12:54:03.2245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6926R/3rhyv7NbC18RgSGkPr2NLnP4JX+HdVP89fpB8fD50K+3Ffhu8lIK8KKPHi1xoKhCvsv7EnisehFRKjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608030115
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDExNiBTYWx0ZWRfXxdotvmwn+EF5
 bQTZwmJ605AyobT1MicS4BAdL6WBA1EKLtCj1Qp5Z39LsHvabfNXjAhHkRILyae7hkhufqNwTi7
 jUpd7XettAKl6oJW3llRShYCJW84Yjc9ZTRdQDzyr4FzRQVdS6up
X-Proofpoint-ORIG-GUID: lz5GOANHinQbp4FDuMn1pf3zUQJUV4rr
X-Proofpoint-GUID: lz5GOANHinQbp4FDuMn1pf3zUQJUV4rr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDExNiBTYWx0ZWRfX45rXvDaaU3/h
 T+UVkiKLE7Oi4nKBpEspiRao59nf36SIP/Mnmw69sUt3l5pp6dlmxwDN3bccIK/fn0GDsPEquH/
 x+9HrOzJVdqiVH0sVFd+YnqJRTsBoiOCWRUpFbfS8nXc7xK4fdDhQ0kHDSrRtbm9QxsBvgSNl9s
 EIEZJ4DLB5u3PQZCcZIzFPe6F6Rt9fHKUWOeTi0lVnWYEQPrCd7sm7DEKZg+9P1j2sByZoO+NXa
 5VDspBUHU15V77mjpJzg4hezGpizH7KXUHITtH4xtJmWASGjqms3N42yZ3GBkfQxyNhrRXnGkhF
 kPJu6Oamt3f6VIBaaMcrpA4OtNIAA0PzJAG2lC8L94R7dHM6DaX8LBJqUq55vqKOiCKT+NV+FUs
 f460vsOpkITHk4mlq2v+4ysd9Nv48c/Nlr177WRZs4IuDIklVJlhCwZ3+vip4NTsKSc2uwoLGPC
 hW5xoqMagSm3y9JHdr7CVrABJkhn2KZF6xPYBRqs=
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a708f6f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=iHwBjlyiAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Tc4j8a6dAIIitNfB5KUA:9 a=QEXdDO2ut3YA:10
 a=uNSKXYNwxGiU6LD0JREI:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13517

On 03/08/2026 10:53, raoxu wrote:
> From: Xu Rao <raoxu@uniontech.com>
> 
> comp_write_worker() returns true when the compared data matches.
> memcmp() returns zero for equal data and non-zero for different data, so
> its result must be negated before it is stored in a bool.
> 
> The first segment already uses !memcmp(), but the wrapped segment uses
> memcmp() directly, reversing the match result. Use !memcmp() there as
> well.
> 
> Fixes: 38d5c8336e60 ("scsi_debug: add Report supported opcodes+tmfs; Compare and write")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xu Rao <raoxu@uniontech.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_debug.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9d1c9c41d0f9..a5911482fc44 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4310,8 +4310,8 @@ static bool comp_write_worker(struct sdeb_store_info *sip, u64 lba, u32 num,
>   	if (!res)
>   		return res;
>   	if (rest)
> -		res = memcmp(fsp, arr + ((num - rest) * lb_size),
> -			     rest * lb_size);
> +		res = !memcmp(fsp, arr + ((num - rest) * lb_size),
> +			      rest * lb_size);
>   	if (!res)
>   		return res;
>   	if (compare_only)
> --
> 2.50.1
> 
> 

