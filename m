Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7128427FB18;
	Mon,  7 Sep 2026 14:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791450; cv=fail; b=mKECH7oCjwNMzRiEK9f1buKcyDepO4+8gtnhzxdYQ7liMzxQupSKf7l/Q6zVIgzCtuJVy6ykCHpRQjPFT8pZcYNaIKZrZ2vy+7gy+7T0LeF4ycXXK8ygQyxTnftrs0BehyZLuLwZky2d4KjsJbzuW+VlJcTHCQVIKcLj+1NGjbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791450; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JlkJo1mLj146rCymWFw5MTs613ZVI7EMvojAq7pSdbCdp9PG7P1NSNo4thVVQStaFyFVgz9OU1qj5OhKee33FkwincNb+BK6xiSmC2dQqesniskL0ve1JAJHFatWI9jZc2qPfwWaZbffgl6OsT/M+6qQhc1X+qv+AUSo/MJvHvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HB71dTpE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jrpXzd1t; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HB71dTpE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jrpXzd1t"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788791447; x=1820327447;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=HB71dTpESfDcn/iNXVL7lLlXYJeEja7Y/lQCpammvO0wUsmPJ4ZuurOK
   IHh8aFy59MuQH5sYh/WpBpjhiZMB4Rw7z8iFY40yMohGJzYTqSxHZacvJ
   KdwWpttYYlZ22UPJUku9zjeZV038O7UfGBPlN3I86+il1z42HLXp1VLzW
   l+mNbnT5x/R2E8OR1T4t2NMfys3YYu/hAA56dm+bpp+jA3vBBAzkaQ4sZ
   GoWqBhNS0e9SbqO5lwrYp7Jt0ENSuJ/mgy9neSPc0zF65WFufTR8Txclq
   WKZt5UlB+PAwxPYE86VTvXkqeQylOjEx1SsE+HGsdufnO6TIHoJussfsa
   Q==;
X-CSE-ConnectionGUID: GLWcnrAySzeex88mRLtNmQ==
X-CSE-MsgGUID: IEpWQAS8RqWf8w5cWabalA==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153545715"
Received: from mail-westus3azon11010029.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:30:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n24zOjXS+dJyGKLLB1UQMEBD17O+UQW2NlZkZ2qTfc8M0d+unq4H8qDxg+P5UpI1XDI9ImTkQ9v7Jt14jmH9CZbpyW8JbVngr5fqIwBezGJA3dqV0kDz85hWJ6xMQraKMf2PQPG50nlokS/QHNEu/ajNWi+yrviq6U08mrrNUTYcEs7dAwj7dTsloJiesopy87D1TztQN7g4dv8Y+EIw9e6E7oKmGOTRjeWxT35TS7LcmDAZZnyo+aJRLBD16aYbhyzFqhCWrerLt610ybLx56mLzkVEbqFH0MtpybXY3CHpScl2oG/ka+ZrZc9bQZEYtyr7xoV0bpUY1Il2KPPC2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=KDcicjNrAYFaITXlLZm9YZh9f7Xh+F9vVv+fZcd9nn96CxRe+4oCxZ2SZkANhXAlnG1tm3HeonU19KUDCnsV0bIVSX8EavnvBqqFLk9Vq/5g5FwMf+x2AFuk6G0ObgBIXW8KmFzsh5ph5JWaiGuzZ1av9tXmJu3O6DUEfcNPOI3FKGtsD4ntG8ATR6XsWh3gcMmsOV2qGLv/PqePHtuYP3pgSaaOVCaCHYQ+dpsfQAzratXlOzg1oLmS4MO31zOGGMLu2gRggftT3SwCeAvdg15u7BC4aiYTUKSkixNPIj4OcqinaunNKAY2bODnWsVIuVCsMVeem5aCCG9AY1F74w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=jrpXzd1tLBEkb8l0/OR2xpUKPSej0dt+IVTeVgY8hSZchDR+EcqhoyurVLxQCGHBayU/mrVh4mhwOdws7AXnp5Q27IZFb14jVDTLH+4qDndvEtINRv/sEuzj/WpiZxzDtC2HH9nJsgcIr9WM+6XcRB0anOzsJX22R9fkBvpzGuo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7555.namprd04.prod.outlook.com (2603:10b6:303:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:30:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:30:38 +0000
Message-ID: <5e0e7aae-6b04-43ac-8494-6b670612aca0@wdc.com>
Date: Mon, 7 Sep 2026 16:30:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/40] scsi: mpi3mr: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-19-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::16) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: 944a6173-a4c5-4b7b-2ed1-08df0cec9678
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	hdByDRSPtVpRUgVCEqo7X1UAjawxOmgJXqvlxHhhCXi83YLyMGcLoYcIMml9Uc2rdNdbyYCPzDayEQR4ZihwNjNkUzT5K4sDN3BOKEYBMEv96nfvIgNwLOQEWWy8mSMm5HLb8fkPm0h12IHtyl4AxDrmK/nKJu/ZfD4y4ADEg36hZG4Dwr1T/VmxgosDAi3BUo5gdH998mg24cXjPLil2GLlGIjlKbJZLD+ijwMylhSC9Uk82HNLLgW5DgaiohPzXieZ+mLJxVACnfZE9AMaZyfFSTzHtO7boQctEDgVTz/YTGQjZnuAQmKR3HmNp4Bit+tbvHaLuYO5iboNuwU1JqgNueAa0vvoDH3c3e4t6lAc7LSBXiI2Pwh9fZvLJl4oxXvy9WKIpzlW6PQj8+wkxaLgCLwLlML1q2uLXSdT2AP/sdnd761AKZCG0GfM/aWhYLkPuZWb9+HG9EqXfonaJ7HJ/SI4TKpkWbi5tani+XVBIm2uVWDml20TtLHiSdgnh6Xgd/2MTcz+9v0GYECESMbw8PjDvzxNHXsOEGTzSuMDoqs8bysSiqCdfOUSHcbe0faSXZi84Dll84/kUslpZ1lwe9QQ5O38csHJmPieNMAoR8h8QuCKYTBf7ZnK/oBxFMR520Jntn55h297YzU423pPgSEPwsy7gfc16wqPGX57y0J0OxT58jgocrabHZOPEbdCkK9J2eZboKVWG+eiog==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nmd6UndoWTMxYzBvMEY1U1Z1MzREd0VsdGVjRXdaRzd3cjROOW9PUXY3UW03?=
 =?utf-8?B?Y2xQeWF6aU03bmYySDd5cW1qOVBBMEh2dDlGVmtCNTYrc2M5anBDeHlacWxm?=
 =?utf-8?B?em9SVmZNSHp6V1YxWnBML0tqMWtzZXJUSWViTC9kTnVUS0FxZmh5S1VXMEtX?=
 =?utf-8?B?aTRPMEd5UGRJT05ZNXRkbEpDLzRaSjZvazU2N2JIL2hpcUV2NUNEV2xHdjYv?=
 =?utf-8?B?RFhrTnp1Q2FhRHpUYXdMbjdmWkVuRzRuaHJ0NXVQQlRhdnNkM0VpbXdjaDV3?=
 =?utf-8?B?a2pia0NITkJldXZOUk9qUlUvUVptL3QwcHE0YnJqeklnblUvb1Z0dVNoUU9t?=
 =?utf-8?B?QWtHeE1mVVJZNnJLTDF1d1BXdGQ2R0I5dGYxRk1jMXNORk1OZHl0OUU4THJP?=
 =?utf-8?B?eUZmTFh2VmhQTmY5bTRWa0dsREZwRm9tbkFjK1liS3FtSnNQZzI3N3JrUXdk?=
 =?utf-8?B?bDZueUV3M0kvK25zRU1YWm5ueHMzVDFkd1VTV3hDUlZ1MVF0YmZPdTNjcVor?=
 =?utf-8?B?OVlSVUJFckl6NFJEVmFZVDV6aTVoME82c1JsZWh0QjZhUEhrY2g4ZW45S0tO?=
 =?utf-8?B?Sk1veGw5Tk5Wc1JDakJyWXFIdjRvcFBzdGt6ekZ2dVJDRG0vL2pPWVZWM0pn?=
 =?utf-8?B?R2dlQTVYMzF6ek16S1IvbmZrQ3pjNy90V2Y2UkpwVzhvRi96VHIvUG9OZWN0?=
 =?utf-8?B?NzNsRkY1Nzdub0VGTysxckVMem9PeEhYQjJsNGVHVDQ2eXVLTmZ2SmN1OHkv?=
 =?utf-8?B?SThNN1pwbktxOU4wcWw0ZTVIVFpzNTdnR2pDUzhpQytCVE1Ya0t0YjcrVklO?=
 =?utf-8?B?dW5YVWxCUGZtZUNXSW1sMjUxNWZXb0lDei9Pek4xaXNOMnVpS2treHZvVVA4?=
 =?utf-8?B?UWs4ZFo0ZG9wczFhNkZVSEVEOCtJL2lCdURESXQ2eFpTL01xRkdyZ2RwYXk0?=
 =?utf-8?B?QTFzOHA5Z1pSV09KQVFkVjhLYmdlTW81ekEzNC9yY0c2b1ZUelVhbGJzb0w0?=
 =?utf-8?B?WENpeURkNHFkQWdnbW0raEx5YmF0U2VCY0lZd1A3OG1JRXJXUEQ2RUJsZFoy?=
 =?utf-8?B?Y0JrVXNjbTZpVy9GbVU2eFh6TnJCZ25xT3I1dEVWdlJwNm1UWGl5cDllWFl4?=
 =?utf-8?B?dFMzTlV3RkQ5NXZGc0Voa1hySHJibmlPdEoxUzRKRUZCTUh0dGIrYzYzVkln?=
 =?utf-8?B?d0w4Q1c5M01iTVpXWUU5VWZ3Q25mUFJPMnpIWUorclZkN0QzWFQ1ZjBIMWZn?=
 =?utf-8?B?SlhBeDBjV3VHU1VQK2lBRFJFWmprTU1XelloODJ4NzVLSHVTMU9nMG9SbGxL?=
 =?utf-8?B?OUh2cENua1E4T3ZndDJEVlk3YzRYbW4wNE1LQk9pQjBNVUdvOXJZUW81NDFk?=
 =?utf-8?B?cStpMHJyRDBZSFRGay92QmtTa1RERU14NjhnZFk2UlVKcnowWWYwV1VRUTJD?=
 =?utf-8?B?UHBkZUlYZmJOV2tGN3FLMVlIOXVyRk04b2QwbjdadHdaaGhOT0xtRUROSjdq?=
 =?utf-8?B?SytHOEVBS1laMkRhVm8wdWN6ZEk5UjhQQ2RidThOSXRWNEdvd2p4NDlIYzE2?=
 =?utf-8?B?ckxWMkFUYkMvRW5ubTR6amxKY2xRVjIwaE9YV0o5ektNeFhYSlNTay9MYlox?=
 =?utf-8?B?L0JWMXd2OGNBanptYmNCS0pQUnFsRjNOcWFYMlU5R1BWMVY3b1hkbElSbEFU?=
 =?utf-8?B?cTk1TEJoL0R3UlNZeXNYYkZMY0kzajV6Szg5TjBCdFJKWDlYUG5MdjA0T08x?=
 =?utf-8?B?Mi82VEhRM1VKMFpEUlNIZk1mK1JEekd0eFp2M3pGV29WZHlTZUNsQ0xWTTFh?=
 =?utf-8?B?elk4SWJpQ01nMlNHM1JyUDFTUG5ZVE5URVByQWRvREsvY0Z1dlNsS2xYM3Ur?=
 =?utf-8?B?cWlsOEFRME5JL29JbVVvaE5HaU5yRWJWMVFWVys1UHVHaFF2aFVmVmwyK09M?=
 =?utf-8?B?eXFPTjZuV1RBcjBsK08zbGFFWGdZVVRxOVhxRWZYd1pLbXJjaU5vWWlyazAz?=
 =?utf-8?B?TFVTQTZFWU41czg1OGJrem91MC9XV05tOUVkcHM3YmRETWVwNjZ2SldPeTVT?=
 =?utf-8?B?RXoyNk1JOVlXbVNORHhsUTdtTGRianI2VVRCM0djWS8wU09CZjhZYnk2WWt1?=
 =?utf-8?B?MXkyVGRDQktaSlFyZXprczIydzh6bG1SRFFaV1FUTGFRVSsxM1VHVFRRZkNl?=
 =?utf-8?B?MEtIZWZSVkNYbUg0Qk4rYmNtRnpIby9NTDFLRlVRN3FpVVF6dCsvTjZYdWFy?=
 =?utf-8?B?bThWWng5ZG9VUjJ0SFVFOTdtOUNJVFRCZnk3RUVGL0hJSG9SRmxUQy9pTldW?=
 =?utf-8?B?TkZpSVUwZDZ5aHYyVFU0ZXJtUXJIMFZ5L1U1ZVZSd2JSUFoyZzBTWmxOZkR0?=
 =?utf-8?Q?u9DyyOi4EYH7Rx/M=3D?=
X-Exchange-RoutingPolicyChecked:
	Mej09MyO1QjZd2AhXOvomz5Pzz9zLhExVf6vgnda3WjjTBydPgsnFq/OF0QWG5Y6rwWUKdFk9Kz+VhIMzDFbeMsrgMtv/dWkbaSE+cYDtHY1BMmIY9Z9fTnCkKWdXlRxHIhQ2hs9+m5drXDdpsKKIPQ0YH+6EBa8Lx14ZYImNbteaZ+LBWoVNrPBoMV6vyY58i6L6C3vo0r1mDdX+lybl9pn8ly8Tgvb2J4qfnU9AgClIUvjSCC0grYBk7b4qdSUyAjukO15+M23DWXXdtXdW8HgN3TU+lvO2IOEhsnB37tgRNoUlATU5rWUEBN8wK2RiI8vYfSwN6XpuNM0XDyepg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DuOlig1iS19x3wuTETZfwh8tKle7w9y4/7f7xz300HcpkxBSHar2Ttek/u6fUTF7g2V4/b+7TAmWPoMl7nCz9m3Wqru2I8LbxCx/xYSvamR311RTkNUiw+GwWAsAya1EG0uZTaPCbo+U0ZCioNsYMjEf9ZT2dVRFbRPcOiA0JzMHFM4w5y/NMaV2o7aGnbuuQfHRXVYQe1jGuXlVZTXoZZboz/Rvz+z1lk5/CTuGpjfGWi4vsDnW3tshbVXj4DVLn2g5XQB2as4zcCkRCK58UVesbKyHFALxwB9vo0R/wTLwDpHEAwo7OQLezrXhYNWydDygS45Apedq/hJT3qMLVXCIlcDzJNSNAzYJ0eoQAzR1byxMwy617f4quIMDn3gCe1u1Um5GB8oOLAhRpUKUjdJGwl8Ypdq1wiollmxZ9vKUC8b2K7+j2t1QmXnibqcqeUDTAtEk2TEtJU+cJBWlquZaolyJ1OK1fDn+M5wwc3na3EGO05gLg1sogIGgMQls75mf3/vXUn+L2AjYiqQx5oI9SEr7Ecwl4I94H2tJCKoEBSd9C0PyFORQTVmGzM+NMtO2yPp44zeM6I9WrdsT+kOUxVGb+L4ZFozkiidhelglXhiP0tFIOJlYPnX8ZU01
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944a6173-a4c5-4b7b-2ed1-08df0cec9678
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:30:38.8253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcpBdIL3u4Wg+8VIhirbXsJEGjI/VTxd2EKAH2oeQVI+eC5JYy67J2MYdUR7k26j2I8A0QzGorJFVK0fP0HegCUaZyEnGKBtcowUJ1iJ280=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7555

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

