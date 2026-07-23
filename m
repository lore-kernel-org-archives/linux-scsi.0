Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AD844AB6F;
	Thu, 23 Jul 2026 11:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806226; cv=fail; b=B2mm1t8DckiG+DWJc/+SLOQt5pa5KPQIBYGlrtDBllPE73W7Cm9SA6KfhRIckCPT/uZU1Ht8tI03x56rRWvJTHf5SQ+i/GubDaiq7AWERRmvi1mx9JnDyEQgvjWqqdMjXVXiiT7eZ/FrMlPE0A4vvNgF9tJ7QhrPYH6Em3RNyas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806226; c=relaxed/simple;
	bh=Ea3/3rsr8Nr1vblF5FBVhFxuD986Oo+ZUxt7xA8GUE8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HtslQIN/T3mKIGgG7bpkyBgUJ9TGouBAutvnS1tLRVnZtLak5rtE247/r2epC5YYuIcU7S5amH/2fyOVvwtKr8TvdK05nJERZQFunlS5jkToqY56fDI1H0WrgZaFkQp4wEtzsV3AQA9ojaPI+nhseH9S5nBVRDzGAnfXU2PSGPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J7y1oTCP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H9dfb85P; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J7y1oTCP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H9dfb85P"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtZuT3391774;
	Thu, 23 Jul 2026 11:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=khCFtEzF9Jp+sj2vBNsalOKlWtPy3zkpIK3o9pSco7g=; b=
	J7y1oTCP4MS++S9a/gFfElHIhiv0FFumxTXgguXqV366D+UQDIUoHwnLzotbH7bo
	7iAkgEcP2wFmypUo6/6AD/lJIGVajEnDzUmCxrezpCOcxTkpzSen3mALP3Uv82/t
	3IpqT/cXpRRSDzt9CFnRZXS7TG9WmyfyjgMZmnwuP6zG7snMQpS64oepqLwQh9G3
	7ZahFhvrBi1Q+RCcXEqxgI8qFz/N8+KuviPxN9SYKbaPLW6W38/pd+JKgAyiUTeT
	dT9/2sSjSX5G/36mKCz8zjDQwsui3TZzrOzuntlKvdwGiRBz1ho1TcvGa9GXzLn5
	5WseA3knOrCUOmEtbzHfrA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1tjxrmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:30:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NBSLis020173;
	Thu, 23 Jul 2026 11:30:23 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts11tgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:30:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TA8RInreQfGGQ2rTYEYU57lA9rG/Bkf6xtBJfSLhUE9vs5e1nN2DeJFHw/FxX3RmNhO+1AUT58m9Y7rnWVR/lIeKXedEwHgMrBUEuNlUADOYCgoPvcgfzTnrqxFUHgSX84qJHd8DQL3B0dYlCdqszYwBpsFUG29QxILBKydTe++H5WlvQvRFwW5lKsWke2wxuQP8ucnSSVS5iTzOlqfJc9Ay5+RoGo54sv3JfWcPBTYqKqpJvTFq26vW0ugYmxffJ1JiF1jpxoebOv7EVy54+K0z6g7j3X1sLD8blpyTo0GqHAct+LA8DMhe7XerQaDIlB1dI3YRzHT2hej5zM1N/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khCFtEzF9Jp+sj2vBNsalOKlWtPy3zkpIK3o9pSco7g=;
 b=b9LpLPf/Rs2y2KF6wRHCX/ZPv3wXrI8zLy5VIIwezn7yEdATJcLaQUTbxb8F7ECw0JfvM6/XZJocR71LqVzjbgeJLefOkrdEdRariAoUSzlf8JvICkTJZJk3RtBSIsCEL89soOD+ertG50PGvJbjZeSGOAJmgGbYslvHr5TS8ysUsxliaOrMwaQcxJ5yeybL0d37mY5JNlMIlzk3rMIDmng0YrAsgXpr6cOa4EH/MYi2O7ozODl3PYzBUrnrSXfPl+f2uZKmolT/plikqtWgmsZiQU8IKRF9uB/sQ02gC27cU2HhTDvTJ6wcgm7jBi+NjDWK1IfqBNkFZrxZehMf+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khCFtEzF9Jp+sj2vBNsalOKlWtPy3zkpIK3o9pSco7g=;
 b=H9dfb85PnrambyHUDt7YAbs6EUcRb1uGIvTLoSJwHY2H0eeXbFOo4lpRnHueTvzEyrjAq7wg2f13oLLRBp2ZY5rBjAxwvhZan5UjRuqwTbIIhxfrf33wROjHye+dxS8NnkqScyikmBj4cu+7n8IDnouWm3sD16ze3EIKe9FNvio=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH9PR10MB997856.namprd10.prod.outlook.com (2603:10b6:610:345::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:30:18 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:30:18 +0000
Message-ID: <1abe322f-4acd-44f2-bffa-d8bb4eaa8bb1@oracle.com>
Date: Thu, 23 Jul 2026 12:30:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 27/28] scsi: sd: add mpath_numa_nodes dev attribute
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-28-john.g.garry@oracle.com>
 <20260723105230.5040E1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723105230.5040E1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0104.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::19) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH9PR10MB997856:EE_
X-MS-Office365-Filtering-Correlation-Id: 4daf0942-f99d-426c-1035-08dee8adc5be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|6133799003|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lhl9Td0MuQSz/jag64eDlCvgdEzqNGXW2uoAWktNRq3Irgen5+b1kY7e25rzGTQlnnoGi9SH6caQI/8l/m0oEPOvAs2Me/og6TuJCIt/JiFLbDz3/FKvWNsXZbZxrlL87cbAeMwuYrDN501H/lMEcMO9OTt3rLVegJLGOqJktYu/rHsycYd1lIM+ScdflkvRy3H1ph3ZKcoiXyf2yzHtEL2qy13wtStTIvKxcX67kSHfm66L7u+ORP8CBlYk644UB9oy2gquLMZM4ITRDsi8cYf27FThP5PnsTlHz2MdmFwJv/i/wErQEOEl3X3zlXNTEwNqS8PI9zlzl3FPqrNvA9ML3Ir85X0/HR8y5j+CrlAJLE0XNc4FJAIDf0CAE+snDvvXBRFBlUC03D4KtJZ9gDDhF8HgX9OrHPsak8nn0KOMC8MYqYS8E7lFRzxkrpjrgJSpE3meP93LZni85G0fKMXKMzyGMfFmK25jcOLDGgkHdTQ3ZTQ91IwqOIpyJuc0b7D4iAwP6JeKr8r9IGlnLmHTWN0Jt7/DN0WqyDh42E2gHZ8hXMIBlLmqmM701UPTVYDUewRAXcYIEXHuJhzOEQd4HXiGdBHWfBH5osNl2VdDTPWgguWn2Ic65hDVC4xGtveI9OYGmmA+gf9T0fbbu+DyxQFbas5mDOYckwslOms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(6133799003)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3VEbWlSNzVXVithZHhvM0xkVXdLUXZIWXR5cjE3ZFpDUW0xTjVVTm5SOTBm?=
 =?utf-8?B?dHpjdittRHlXUEk2cHNJOGpTaS9NYy84L0xQTkpJTW9BSURWSkhzWjFYQ2pG?=
 =?utf-8?B?aWRPdkIxaFJUN21YbTRoRFRPQUhRZWlMclBLdlFHVmw4Um4zMlY2Z25GOFli?=
 =?utf-8?B?THlaVjU0UjZzd0hnbmZNR2RSNW05a2hneUc3b215QW9aYTkzOXc3bzBQYndD?=
 =?utf-8?B?Q0NWWWdYUFZXM3NrZGlqS1JrV1V3T1Jjb29iSmM5cHNudjViS29iaEdzeWJs?=
 =?utf-8?B?R3VQRzRnWmxVdFJ5UkhQbCtRSmFNYk1aWkJabHBGSXFSNU1BV1JQOUJMK1ZE?=
 =?utf-8?B?dXl6Sng5K1BXTlVZejc4NHlQUE1nR05XMlJRM1RlWTRSYUpTZnd1bVFxcEpL?=
 =?utf-8?B?blREVC8xY3UrZEJ2V3NVQXVPRkN6Q2RqamtmTTQ5cUJRRjB1d0xkbHd5cmVY?=
 =?utf-8?B?Vkt1dU1WSDJlaFhCajlFeGRqQVJKUjQ1M3pQdCtrdzJSWVlUYTBQVDZZZHVT?=
 =?utf-8?B?eDBDZkRmMWRiNUJyWmplN2ZMSmxOREdaYVFEQW1yYjcveFBQRVp0TnNyS2U0?=
 =?utf-8?B?VGF4ekNGYmZrYzYrdVhwZFBiNGgzN2NuVEE3UVpVV3VyVWFsQ0JjUUJ5RDBG?=
 =?utf-8?B?bHlkUTJTS1hkK0sxcUFwQmprUXF2MzBsM2ViTjhsaTExQ0JnT082bHV1NWNy?=
 =?utf-8?B?U2VlTFp1YjRQZmZLckdVQjBhOHRuamhJWWRYejNta3lqZ3pYVUpUMHlUMGMw?=
 =?utf-8?B?UEJSekxMdlB2bUVwWlN2QzRhV21sejhITndQY1N5d0FaZDA3NFR4cmN1cWxL?=
 =?utf-8?B?TXVrKzc4RWFnVEw2OUFlZFY0L2xsY3lqdGVrQmJIbThMS1I2S1JhNS95U3B5?=
 =?utf-8?B?TnBFblBadDRFNU1qTnVEMDd5MmY2VHFZY0IwY1ByeDAxQ2lHb3RTaFFMQ3kv?=
 =?utf-8?B?U2k2eWVNR2xTU2ZPalg5aGlDclRmcWxiZ01OVGtqQkR0SjF3bFZLcjByakNF?=
 =?utf-8?B?TXdjMmVoYmhlbVVzT3d5U2pNU1AvajRXeGZwWXhTYkgyWjBUTk9mM28vM0V0?=
 =?utf-8?B?bGVTQWhreTZOUkxOMzlHNWRSR2tTL2t2QUhQWExhZHkzS1c2U0kyVWs0OTVZ?=
 =?utf-8?B?ZnY3dkp5MVZqK2liVVhGSGxFUHladk9LYXNCVFZwTEFFTkwybXV2czJqUjUy?=
 =?utf-8?B?WUVJeFMwT2oxOVl0WDdPcUVub2ZjaGVUUlYzeXdGRCsxcVhsOCtSRi9hU1hE?=
 =?utf-8?B?emFzQjRvcFJSUTA0V2JDOUd1VkU3WXZVVjY3UzVIUWViZ0JQTlR3UXFhTFI1?=
 =?utf-8?B?OS84L0hmOVJsVWs3Ym13TC9XRzZwdTc3NitlRTJMNE5YSHVuNzhkdzNsY0o4?=
 =?utf-8?B?TkdJS0pQWUdQT3hJS0p6UklzMjAxZEFsd3pQdjY2Tkx4eU9GMEdKbk1PU1pm?=
 =?utf-8?B?YlAzS1R2dVY2cFkrZTFCYmtncThpVWdLZjdYeDdwZnZqcTk0VEU1azJNbkVz?=
 =?utf-8?B?Qmw1MGlDS05rdTlhRDFlM3NGdWhuVlMxUDhxL0hQRngwWlZYS3VlalB4d054?=
 =?utf-8?B?UmE4dVplRnZtNytLU1lUaTN4VUlDTGs2R0Z5enB1UE5ZVFV0bVNCb2ZlRXMy?=
 =?utf-8?B?ZFlmSXMwUWFlTkNDZ2lka2E3UzJHZ3pTMXB4R01vTDhES3ExUkZ2MVpBUGVG?=
 =?utf-8?B?dkpCay8yVmhCcElNd1lUczVlQmQ0a1E3Nkl0RDJUdUdqdW14bTB5dXBsMkdn?=
 =?utf-8?B?Y2JLZm1udTZ5Qy9mbXVKSnR3djc5aVhhQ0pVTlhVMVkxNDNOYmh4cmhwUWMr?=
 =?utf-8?B?SFpSekdpM3dKY284ZXlFMDk4QzlVMmJaRk5OV3pDMCtnVkF5QnBHZEtqQUV3?=
 =?utf-8?B?cmFmbW1PaENVODZYT2JkQTlLenAzd00xVEJIZmtRSHJCbEk0ZkhjUE1FSkJB?=
 =?utf-8?B?RTdNbjhmNkh3TkIxM2JvRUJEdllKZ2F2SUFQakx3U3JiTTVndGM1NitYWmU0?=
 =?utf-8?B?WVZlNEVVSWVBbk15WFV2MUhxRlQxQkdURmlmY1pWSmZ2Z205U3RIeUo1dmtC?=
 =?utf-8?B?Sk43d1RRaUlwRDNGUDByRTcwTngxMUd3SlUzazNBYU9BS0cvVGV4OTVETks1?=
 =?utf-8?B?TzBPbm1mTTBUYlhoZ1BYZEFpYjZDM2hEUEd4QzU5VGhRMVpnUGhSZDRyMS93?=
 =?utf-8?B?YTlPSTZFYlFIZ2M2WWo1azBnWVRtZTh0ZmhJVXlhWjNrMEFsK1NScGN5QWFx?=
 =?utf-8?B?d1BSbjJhVDVCT1BnY0NxTGRJUThLQkYxQnNCdGZ1SmF3MGlvVm1YYmRUMkhz?=
 =?utf-8?B?ZHJlaWdqaHVHVHNON0o2TnhNeVdIVmhzWnFHZ1RuQndwR3k5VXB3VTJJMVU4?=
 =?utf-8?Q?PKKi+fZBm6v59KdU=3D?=
X-Exchange-RoutingPolicyChecked:
	jq5FJZWhkSg4UZifiXL9JBlD67UqlGkbsdV7Bk/upWrOGNXWQ+Yf9acM32+9dBr+v8bAEHzDWtr5e6CQ0Ix/L0xdir51+HH7HHJMAqPoPtyf/kfrjvZMSlKecHArc5CLgEwj/67aJRg9NkxW7vE93RSNC98+N4LMxwhcB0RWAbelvDMId6u/83+odTpMI9VQWcoa/ukF+un2vZrB/fDjqDSME4HSpuj3tz3Fvs4uwXdor4+SMsu2Z8VAwPSXfiRHazGq0ciZ5kXskuZtBisWMV0Q9wSTEaYtQ1M7uVbbQOJgiuNjHDesIUa8uU0MkjSohx0Ui5Ct+5I49FPDNPKoOA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UGWNhZMXY6xePgBrzre1GP1z12GkEc6OTgPYe8+bJdt8BojkdwsvSa5e8MIJaewSvn9YmAetV68bsTw7ZNZQUk1jfSlm2P3IxYG4IQW1+tBhPiW97NQyH0DHavTwbC482FCKSmI+p2fdWIYPRk7S2jlpUAJcE+quztSRmvapQdkLMu1x/OEZ1nGBXTfmEvjeWkVOr7rOWAFNZjDDqOkz42idvbwiCPdFki0LskNJWoMmpovGs1fav4mOTeRx5jzXL5jxMLJhX2KVS9kZJLe16z1VrUt6LUEnJEdx0fp/eRkWBAwTy3e0VVAZfY3T1mcQSbq0x3OLMv9Qyh7wWCDwr2hFdU2+mRBd+K02ykzvphe5ihxXIUKotcvuYmrr0d+a0n++STJkUQqtuE2wi7hHNhL5HvUZc86WqvfwN+6ctHAcyCUuwbKJcxziOmRvhrCNAD/yVBqlUxkEtX1zN/CegVTWxSemVeZyWulSLuNHsZFFMJ94dJ49PxqFXjOGCQCMXvkKQTsLS9Ejvwk00nK4KDMmwsiwFH+VXJ1pUKCkR1Lb1kkLr5vCnauXuRC3CQhWXIgIFVmXtpZt+UzVDhm+uUmnOBuN/e6nubeqSgR9Z40=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4daf0942-f99d-426c-1035-08dee8adc5be
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:30:18.0409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnfG1uEjOeN4HPk71t+Zl2b8o7Jw2ZYdCEWvgvyvhKxPUfl9nkZz6xwtjLFOECxMx6X55d7ziwgW4CaV8KED2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230113
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=6a61fb4f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=k7hMHRduhtyvtRI4VcsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: gedkbjRfj6tR8HW9dqhsHmYXlFDPIDjB
X-Proofpoint-ORIG-GUID: gedkbjRfj6tR8HW9dqhsHmYXlFDPIDjB
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExMyBTYWx0ZWRfX0Bu2Mum5Zpck
 64W2UZm93HJUI2BJF0RXQPR3AURx9hYYtKDSOg/eMv0v2u4EgBsmOo2ewoJT6BViiYlsJX1bzLk
 uyCBq+hg3HJLoNyECcmzkpuYWUXrhYE3RYsa5v921B8qCaz1slHs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExMyBTYWx0ZWRfX/q6B/MFGEHG2
 FbI2B8bSdaCxUF+K0m0QIse0mJWE58RoflYaxHXXV/nreyb4CragJEqxPTAyixx8CLtQ0PJcHcg
 tHEjCZFeBLvmFKwws3B8aXvO5goYyBf5UCmBRoeYcIXSLR7qrfG/I7OC5p8vULImKbsZQFOXKLc
 YZWoZT+EPaxT918pebYoW9beb6QW2XJ5u5jWyhS+aF25c5Z9m4Ze++wOPvl8Lh2z+L4vdJKVrwA
 QZ2+7uvHPW0jhB5q0ekOEWDVZlDADGockkSZYHINzrCLGWY+SaGHe8mj3ZOSm0Fni9O80Hbdbjz
 89dxxgDDfhSfLvFkSzGC4GNUKYEpf79tLHHEQf/GtwTTy6Qc9GTg2Ql3cfpudhU1pbB9WV3IqRD
 vuhmQXg1A7bjQ+QEP3P9gmSoxy2rgaG4YXUWfNuB8jTmT0cJ9Le/Q7cRNaIEftwnEcFY6ZPdw53
 hsAfFExiCdbrPrrZZEQ==

On 23/07/2026 11:52, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Reading the `mpath_numa_nodes` sysfs attribute before the device is fully initialized causes a guaranteed NULL pointer dereference on `mpath_device->mpath_head`.
> --
> 
> --- Patch [27]: [PATCH v4 27/28] scsi: sd: add mpath_numa_nodes dev attribute ---
> commit cc5c94ceb8cbeeccd7a5678ef260c6bd21a0fd6b
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: add mpath_numa_nodes dev attribute
>      
> Add an attribute to show multipath NUMA node per-path (scsi_disk).
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index f8c9096e6c43c..7255df6e3e971 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4076,8 +4076,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
>>   
>> +static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct gendisk *gd = dev_to_disk(dev);
>> +	struct scsi_disk *sdkp = gd->private_data;
>> +	struct scsi_device *sdev = sdkp->device;
>> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +
>> +	return mpath_numa_nodes_show(mpath_device, buf);
> 
> [Severity: High]
> Does this code risk a NULL pointer dereference if the attribute is read early?
> 
> When sd_probe() calls device_add_disk(), it exposes the mpath_numa_nodes
> sysfs attribute to userspace and fires a uevent. If userspace (like udev)
> reads this file before sd_mpath_add_disk() runs, mpath_device->mpath_head
> will still be NULL.

will fix elsewhere

> 
> When mpath_numa_nodes_show() receives this mpath_device, it passes the NULL
> mpath_head to mpath_read_iopolicy(), which will dereference it:
> 
> lib/multipath.c:mpath_numa_nodes_show() {
> 	struct mpath_head *mpath_head = mpath_device->mpath_head;
> 	...
> 	if (mpath_read_iopolicy(mpath_head) != MPATH_IOPOLICY_NUMA)
> 		...
> }
> 
> include/linux/multipath.h:mpath_read_iopolicy() {
> 	return READ_ONCE(*mpath_head->iopolicy);
> }
> 
> Should we check if mpath_device->mpath_head is valid before attempting to
> dereference it?
> 
>> +}
>> +static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
>> +
>>   static struct attribute *sd_mpath_dev_attrs[] = {
>>   	&dev_attr_mpath_dev.attr,
>> +	&dev_attr_mpath_numa_nodes.attr,
>>   	NULL
>>   };
> 

