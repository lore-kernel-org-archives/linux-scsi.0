Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D333B2FE4;
	Thu, 23 Jul 2026 10:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802533; cv=fail; b=l99KZlQz5JJGcuyQmalzLevduuXWI8ERDaa8uWmyHqY2i69VSbamcuUnBM3pj42pqkpxWaSxBqvG3GymvqWqKQXpqnGAq7aHvInvET3TY9R2nVwW+v1X17dG/PkKXdnFq8FdQYCyH9HVQySxXswDVwaopIwYTpd8RbldmV9opLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802533; c=relaxed/simple;
	bh=xPeJ4LFsxbtjioyu1h2dJNCSQAqaIOrSD2A9jrHVbOU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BfWh83MAdlaD3knfY4gmNbxsuVxm6rgBtj4O8MgpFdc6SeG6hJq1u8jklJVTGkl/IWCqPJDY/esW9cJS7jCsuHddTptATzAt4JHZ5xrjnpenk3Gf30nJ5rzYsnWmgNGEfjJ5VcxvE2wc1Npy2Ibf+6vWTcjIL1JiKHO+Qqo8fUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=liruv7gJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zxvKlDCm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="liruv7gJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zxvKlDCm"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtWKU071622;
	Thu, 23 Jul 2026 10:28:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=i/2W7mXSO4fdwQD3eYoeFY6+0EK5zQgJI8vbQ6Y+UZ0=; b=
	liruv7gJhdo7kzHkhWHJ0TL6uxg0x77X/LSwOdYBWQW83wftd3SStjvYwkcuicAo
	PqEwka5RfxcvhNKsVRnSuv30cLvujg5BZz6JkEPZeJx9qwwmyxG6w6SidSO0fSk8
	dsUrgztEjtjE1klMlR7hNK3uh8KlChOL2+Rpjq6eqnK81OmyzaaNuwiYD6ejE6Ji
	f1ZoYOvcKvXRhTGtcv43fB5SFTcuWS+kXA+wkQ/y/TI693bnYWDTVH6cOPrywue3
	suHRsXmTdjSkS1T76Lf/Sv0EWfyv8I2mublizy64p0WNk9gdttHe3QBYV99uqmYT
	1kMtbzSUgYhByjHRZAsojA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n36uca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:28:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NASYcx012343;
	Thu, 23 Jul 2026 10:28:50 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxrxwkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:28:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qy3QJBCOSSBAZNqQV7CTaYWgpgf2zrC/x74Y1u34m3yjAerKGL5Wy1DDru3GXXEPC6XirXfOD/gqm6JMLz7ocjGZo7XVRzwfIDP5ebE92KJO2Bgg4Pn+6yMyv8L6i4Q9wKpb1IwUicVlwM95ONrs+yRNZEqJIpkC/9mUBGPId/IUFnqq/vDlUOz7uOay5XpONsZ/TEGGpPju4WtTZUwRrG/VBFlLCk+qfALFIieQ7CWMa5vMoK5Pcm1Z3QNXSsILtm97AaWoJiUebv4QCLuYWk9dWt5RxOKWND56Cj4e/lnZzhDPHQWWprvVfemv+l55qmC6irTlp80XqQ5fwZ2LsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/2W7mXSO4fdwQD3eYoeFY6+0EK5zQgJI8vbQ6Y+UZ0=;
 b=GnUlg4SONTD4Rq6zLhoBcoBKTIZOZATOAF/uPbfRCyjWA8wuCe1vtFc6DsRFi4LRa3k4zqu/c1kox6pD6IfBE1+EpEIpYQb5GqcvmpyJtsDijUnbQiium5b7wkHWVTi/yD2uhs1qqk66wSFsvcrMzi4DK796IEBBdbw6bJw3ls6Wt5cI2Yr6iY7v0hEmbZoFycx8GeM44flxVjCeKIXZuvHSNryMW10+unsbsui4m04b++2CwuvMpRDGNXWaJCWs8l26wXA7p7jPOwuE99xNLq8+ZJmKXwdLvc/8KLJt76xkEezpM15bMm8FTkAdokoC73CHxWLSGpyx1uLOKjhtJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/2W7mXSO4fdwQD3eYoeFY6+0EK5zQgJI8vbQ6Y+UZ0=;
 b=zxvKlDCm4IQvX4rdYUGggpnBn84PucfqQ2CBLXRg2RBE577N1kMNDw2bSfGqGviON2Jj8iFtzT6xXVyOHKuBjQyg/l7MQMzKjudPBlp/6f5UqCV39S8VX2IhvL3a0WFCv/sBQOdACwbWmtDaGD/EFOEwTH83jCJnO3FXFmqTE9g=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 10:28:47 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:28:47 +0000
Message-ID: <dd7c4dfc-5f70-4f1c-bf14-736616265734@oracle.com>
Date: Thu, 23 Jul 2026 11:28:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/28] libmultipath: Add path selection support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-4-john.g.garry@oracle.com>
 <20260723095512.6CF7F1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723095512.6CF7F1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c2ade5c-8494-4268-8823-08dee8a52e15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|10067099003|4143699003|5023799004|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	L/A35C126ZxEOUGAG+Rrm8Uos04bWvmTAFFOYIvyeDm5tORy08sulC2cUcQgyF+PrxUFPfT+mo0lX4p+uvk+VJDTolKhqSJYwWjmgBc7lQtQi18axBACp3+reatV/ES5iwEXtLMs/5Yq102fGg8hMnI0n5ptseI8IUYp/4Lbp0SllTZz4KzM+2OByPD0TSX7JF81Eyjn/ihw5TefyQeb7je2tRYt6pr9P6xyarEwaggweHNX9Ebf8puLs49Yuxtivl6rC/THvWwYpwWR9/g4ByTzNxwIQqtSCU6hKxG59C+doSCi/i+MwaZQFhaKtsfuQfzhS5C3VMWP2wmCbu3ff6n7/rgOoDxiGICyaQPbawVPtpd+CKfuqdr/7f+Wo5zYuO24mJEbfP+uhPmHY+rVN9STli65BQKzZ9IPdi/B7wqKoZWLkENM5jHCh2LsFdwHso8Kf9MX+kLPcgK7m/T5hvZcD1gFs5iY5XqO+CVpArLADXh/jNRhJAAIRoaHhMbQV6EsZ9eItadpoQk0Xam/jpU6mOTfqyh3CmIEPkbSDZWDnurxKyC79MOkrRvarz2AGTbVMj0+SHeYJO1cWv7LvfZ6lDsFovIMi6q930YjIgBEMk1HJ/Igh8FkxIYGMtakO5MZkeownJwZgfxzN1Je6TOSUt6iUYDlnb4FbSEkZfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(10067099003)(4143699003)(5023799004)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGRadEpDNjh4QnVwWmk5UDRLWTNKVHgxeWFSMFo0SzhxaTRaTG8rVmg3WGJP?=
 =?utf-8?B?T3piMWZvWGFycmpWYjR5ZFc3UW14WkQxeXFINksxeE5URTJqYW95UmRrNjJj?=
 =?utf-8?B?UEJTV2ZYK0xMblJBamk5TkZNS29TSUlxSTFzWVFvTXd4WXFKcmVGbGFxa3Fr?=
 =?utf-8?B?N1NJbVdLRXIwVE1MT0F3b2Z5cm41MXNaRmJmVWlSRDlQUlluMFpocUprZFJZ?=
 =?utf-8?B?ZWJiRmVIQld4RHVuMkQ2eG5VVTFDYTlhS3k4Qk04RzBPWGxPNWEzb3hzcG50?=
 =?utf-8?B?YWpndU5CRVVhRHUxOW41Vi9LOFQ1QWE0MGN5aEllRlVUTHR0TC9pYkMxOWg4?=
 =?utf-8?B?Z0NiQm5wUEhvVS8yVXJVVUVoNDlHQ2NiUzRiVFRVUG1KN2xJdXN1TkpQeE1x?=
 =?utf-8?B?cWFSb2JuK1VwN055aXM3a0YrejVWS05RbDNOc3Y3aU1YdkREV1BQU1lhYlEz?=
 =?utf-8?B?UStEOGZ1ckgyZXFqQVNyVHhwZ1NpWUI5OTFQWGJiUGVHUUtaM1BLM1V5Z2Q3?=
 =?utf-8?B?SEd3MTdUUmlRTW1GTDJSM0JXVnVpZzMrdGtCTjNZVXlwcHNDdEdSRzFoRWZ6?=
 =?utf-8?B?Zk1TT2xmeEJ4cmIvdC8wMUtEK1l2WUxOdGZZWVBXUTVMM3hjYmtON2xWa2M4?=
 =?utf-8?B?MW92clRqM1FmQkhnaVM3UFRDL0VKSnBqVks1WWdFeFR2eWhMTDZ1ZUk4Nm9W?=
 =?utf-8?B?NjZ5NmNzK0NnWis0RUdzZmNnSFJ4cHlVdHUrV1FRSUEyMW0wREdtYndmdGJ5?=
 =?utf-8?B?MkxsSjR3a1pXZHhSY1A1SDhZeUppdUNwR0JkNmlicklDak5LQVZ3V2cwUEJK?=
 =?utf-8?B?MURzZHVscVF3VTVuOVAxZlRNMDk1aHphL3NaSWVra3hTb1MvcVljKzFRaEt1?=
 =?utf-8?B?dTlnVENhSy9QVHcwV1lOU2hoS3o4ZXJCaW53K2o5SGtydUM4dE5obS9vUS9h?=
 =?utf-8?B?VWZIZCsxb1A1NnNZVUxOM1p6eFRpUzJMSUd5WlNMZFFlRTBmdVRaYzdNMDZv?=
 =?utf-8?B?b0svanB0N1hVemgvblp3MThySi9vRGJQTUI1cmdydnVrV1cxUUI3b1pScDFC?=
 =?utf-8?B?RVQwakd0ZnRMS3VPZmZSYmlidDIwZWpXZFNsVzRjZ2FRdU53Y1VqdmVLdmRz?=
 =?utf-8?B?YzhHSWhtK1Zkb1h2MGdqNzZraGZyTXBwOVNTSkJEa1BWSDRZVU5pS3h1OFJv?=
 =?utf-8?B?bVpwZmJJRForeVIza0dKc0RUTnJZTXA2SGU4WHBZVzhTNTdQU0FnVU9Eb3JD?=
 =?utf-8?B?cWJOc0pyS1plbzdjRGVRV1NUL2U5ZVNaaVc2QVdMR3dweC9EWlVNMm1kSkZk?=
 =?utf-8?B?T2FkMFl5VTlUQzVxOWpQQWkrOXdlWGhETloyalZUMEc0UE9hSEMvdzhLcFc5?=
 =?utf-8?B?SllSVnhWRWQrR2lqZEVwZFJZWk5NVkRaQWNrNVZBZGNiWmF0QVN4VVJhWUNF?=
 =?utf-8?B?MlFSMFYya0RXVG5PVEhNalYyakI2eFNlV3Z4eHhxYitTTTh2M01IK1Z5VVBm?=
 =?utf-8?B?cWlPYUxQb3FGUm1yTUlzMG81cWZGSnNHb2JSb25IUjg4SE5EVWxUUzBqOTkw?=
 =?utf-8?B?aDRGR29DTk9VVTIvUnpsNElONUlWS1AzYnJxS2RBUkw4WTZwL1lHb1A3R2Rs?=
 =?utf-8?B?ZTJzZE10cGFDWlU2a0szQlN1cUpscis4N21WK2dIYXZxS3I3R21zVUtyNWZI?=
 =?utf-8?B?VFphTTdKdnZHUWFWbHE5bjNmUHZqLzRCOHQyRjVmSHk5SWF3d2FHenhvMEgx?=
 =?utf-8?B?Y1EvYUlSQm9nOEVJOWF5ZFdidFZ6b1Q4b0pHMjM2RE50YTc5bjlpOGxNWUk0?=
 =?utf-8?B?MXdmQTdYa0NtQk1wV0tHZGcxRitpSnZmUFZjSWhzdGE0NGZma29RWVIwRlhw?=
 =?utf-8?B?bmFFenpjT3Y3dE9RYzZzMG92b1MrTmo5SUdJd2lRTFJTRmt5UVUweHJYNHVk?=
 =?utf-8?B?QTQ3YWc5dUo3SmY5VlJ6aGx2Nm5oNHFnNjB1eHhFNVR0dlR5dXZ0dkR2cHBY?=
 =?utf-8?B?ZFM0ZWtoaEJSOVZKc0VvNHZ4aGZGd20vWmpQYmlCbWhpRlV3UFhDWW5idi8r?=
 =?utf-8?B?ZXZFWkFLWU9EYUd3cFdxMDNOT29pRTdCWUx0clRrU0NCaHpuZit1NmdpWjRp?=
 =?utf-8?B?OXVaRy9QeHZjYXBPZHFoNXEvcWpUVVF0YzlMQVZ5eHlIajFpMmc2ZUlNemtS?=
 =?utf-8?B?ekVEeEhLbnZCdUxkWllJbng0UGxwN1R0bCtyNi9ISzNxLzMrN3hMQW9MVnVJ?=
 =?utf-8?B?YTg3TFlFN2tpTW82cGlVR09LQzdRNWYxMnI0V2FCQllPbFRoNi81MWs3UTFy?=
 =?utf-8?B?dkFoSm1oNUZpcmEzTVJHYnNOZWJ4c1NOMnZxMGFWMStZRnNpQnQ0QUFOMlo2?=
 =?utf-8?Q?VEgzszDfIRK5M0d4=3D?=
X-Exchange-RoutingPolicyChecked:
	N54Za8KKAZLUomAx4rPbQlkFqcSzgyiLjV5K9J2F9fBZSMNZRyRgN9NKsqnEMoEhS9dNfpZUdrPyCCLoOrZDq7bnfE3ndOSWYJm8IsnEmth42WBeAFyprCitnSQDB5WhFu3VejJQlxAFxovZllObInJgduFYlF+Ev5X0opHwqwZPviI0kw6KZXs5BO8bAuMwjfq747NMazak9+PuYP18BAAX++1OJxW72P/zSmUEyd84qxWOdhVWfZ2Y6yP7hXrOWWUvTZpRo/AcZazINbGF7jyrPrAlrFOSBfCG7TyVIZ8t+sXDDQhWrhSodjD/wrbG1XdAZ0iwc2aOzsiy6uYMzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1l/luY5YqDhyifZMWIyiOfwS/BSWtf9YdYYMPwraUUxdrZyuGOxHVQ0H5tKh+U+oWZUH7hpzYBWtT6dG26qD+sqfUFbNK0xBkDkyIHFZ9s/kHflPgm3X41jAohCCcYeL3LTD4pN+k8IoOP8O71jFhCXCpFnKOk/f9yxSeWSdNM6C+7wrgrIqQyYquAtaJNh1ZfzmiNHg7+oT3/uMvVy4snwSOdDr6wSSqxombUmlaF/UrNcIQ2WgcMh13Iz2QFObSVTEaptl6iQU7kbea0pOXdZLo94r/faeLy5l1UtDQurjOYMtuLRiAkZWWilIyvXZ/8GpKZGSxs8raZMsokEc/0HYr8zsSY23TX28W0+yAHLhOY55RdzRRaXbTr8QS0UJEsphrhjEz/ma3v/iac/GQrKfuqr6Z4o7+GkqcRVvLA4Etp14l6tdI7d2jUvzRBE9vKSZkrtH73/ms63kgngw1I8PvkIM/zwdc8IZNizSQfganceeiuaAXKfGHxjPPChPAcyKIlL5O7qH9Sem093T50CiSedoGU9MImW0waRWjlmacNmcBd7asHY474VT5NCwkLoJNFyNaqA2xLX9CTf8nFqbeMvlrBlqXwzocR5KdlY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2ade5c-8494-4268-8823-08dee8a52e15
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:28:47.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Byppn83kEDm2nbQbUMm1QE67VwArx+BknZbiflFQbaO89nbXn8IOU7PjiwiXG9QwV7LHz3qSQwfkp2brgIu6ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwMyBTYWx0ZWRfX6vnhtdLmf+Rj
 59CJClYv0d+nryEdfrQ0oN1SsTA1itraBNBJnECkMWuFKOsFKK+X9b3B7uxvPEyLcE8ykPWUBQi
 3gMtIPlmAgt2BBTuzfZCCXx7Oyri02zd/sbdqtaag4Xo0octlEXJNLkJCvbAh1Z9XuoiWbuOWSW
 oq33FqlK49G9q3tqE0sNQmK/c/CPGhZxnkju2wDR7zPwkZbfeITyg/p30Hvey0UR15wgHN5AWGG
 BJyOOpJ0xFAU7ytDkXpMy9dnqXNGfC6Rcjl71MhfBYojEkPBm/WKiElgUaWuYGxhNcjSi4O/gpo
 YghqvDO8ny6hT0xwDzD6XhyGDnByFlRMkHQbUpaF23oKyIrDLaJWS70uQSiBPV2Npxd3GiSl4CH
 9EGTG/RSlKmAZTXfGjD4oG0R3HAXue9XjwEkKhkSrd/sdxs3ay2EjSOoR/loBCjA6XjwShJBlky
 JOG2w8cPBY9bPoWp3t7YhJ9UYTlJoPJvHcdE7uxQ=
X-Proofpoint-GUID: g1UOwDhLDk4JFgkcAa1JZZIWRCaKvUb8
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwMyBTYWx0ZWRfX6mWSHHqlH1T1
 CI+pqrlyculwIYZ0HZ9lZFzYF8DLSuPxx+2zdo1vG74LtkFxTgMcAdrFh/hWhoQKJ/l2jRcftO+
 xiBfepN1DYR22FR9KqGiPW44dkIUpqth4MX9yvDG8e6rqwpPjM0D
X-Authority-Analysis: v=2.4 cv=JrfBas4C c=1 sm=1 tr=0 ts=6a61ece3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ExWSKiLx27C7yUFix9kA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: g1UOwDhLDk4JFgkcAa1JZZIWRCaKvUb8

On 23/07/2026 10:55, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] The round-robin path selector can enter an infinite loop (SRCU lockup) if the currently selected path is removed concurrently.
> - [Medium] Calling `list_is_singular()` on an SRCU-protected list introduces data races and state inconsistencies.
> - [Low] Missing `WRITE_ONCE()` when updating `iopolicy` causes a data race with lockless readers.
> --
> 
> --- Patch [3]: [PATCH v4 03/28] libmultipath: Add path selection support ---
> commit 84fab111a99eb088e0b8abed39b8163220a9318d
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add path selection support
> 
> Add code for path selection. NVMe ANA is abstracted into enum
> mpath_access_state so that SCSI ALUA can be used. Path selection modes
> round-robin, NUMA, and queue-depth are added.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 916d01a285284..20bb8cb0ea956 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> +int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy)
>> +{
>> +	int policy;
>> +
>> +	if (!str)
>> +		return -EINVAL;
>> +	policy = mpath_iopolicy_parse(str);
>> +	if (policy < 0)
>> +		return policy;
>> +	*iopolicy = policy;
> 
> [Severity: Low]
> Does this code need a WRITE_ONCE() for the assignment?
> 
> mpath_read_iopolicy() safely accesses this locklessly via READ_ONCE(), but
> this plain store could cause a data race violating LKMM guidelines and
> triggering KCSAN warnings.

No, that would not be a problem since this is just at init time.

> 
>> +
>> +	return 0;
>> +}
> 
> [ ... ]
> 
>> +static struct mpath_device *mpath_round_robin_path(
>> +				struct mpath_head *mpath_head)
>> +{
>> +	struct mpath_device *mpath_device, *found = NULL;
>> +	int node = numa_node_id();
>> +	enum mpath_access_state access_state_old;
>> +	struct mpath_device *old =
>> +			srcu_dereference(mpath_head->current_path[node],
>> +				&mpath_head->srcu);
>> +
>> +	if (unlikely(!old))
>> +		return __mpath_find_path(mpath_head, node);
>> +
>> +	if (list_is_singular(&mpath_head->dev_list)) {
>> +		if (mpath_path_is_disabled(mpath_head, old))
>> +			return NULL;
>> +		return old;
>> +	}
> 
> [Severity: Medium]
> Is it safe to use list_is_singular() on an SRCU-protected list here?
> 
> list_is_singular() reads head->prev, which is a writer-only pointer in
> RCU-protected lists, introducing a data race.
> 
> Additionally, if old was just concurrently unlinked leaving exactly one other
> active device in the list, list_is_singular() evaluates to true. Could this
> cause the function to incorrectly return the unlinked device instead of the
> actual remaining device?

Yes, this function is protected

> 
>> +
>> +	for (mpath_device = mpath_next_dev(mpath_head, old);
>> +	    mpath_device && mpath_device != old;
>> +	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
> 
> [Severity: High]
> Can this loop become infinite if the currently selected path is removed
> concurrently?
> 
> If a concurrent thread unlinks old from the list, mpath_next_dev() will never
> reach mpath_device == old to break the loop. Since old is unlinked, traversal
> might wrap around the circular list infinitely, causing a hard lockup within
> the SRCU read-side critical section.
> 
> Unlike the NVMe equivalent nvme_round_robin_path(), which avoids this by
> breaking early if it cycles back to a fallback node, this patch omits that
> loop termination condition. If no other path is MPATH_STATE_OPTIMIZED, could
> this run forever?

This functionally is same as nvme_round_robin_path()

> 
>> +
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
> 

