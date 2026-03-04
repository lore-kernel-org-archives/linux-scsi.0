Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AC639A05A;
	Wed,  4 Mar 2026 09:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772618138; cv=fail; b=saoBI9keizFQI9Rl1Qin8BWsIqEXmp/36gEc5BhS9y2ii1qExOUzKQsMGWF0IICXzD7DfzQ1N/sF3Y8QlJCKnGrlO3HJLv5RBMS9Jly5sIfItZLby7JV2HYr3kY+HxiQPAQ6gBW9is1jkSBHhVz2M9zzn8J3zi0BgG1mfHkkMoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772618138; c=relaxed/simple;
	bh=BQ6zzJ0rW3ggwyGFGJlItdBX2ywx6rXzH7kgyV6yjSo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S1Qv+QQB68OH25ne7LIYLt4CfFm/ar/LhCHHhWIw+ZCnYaNgc0ImGacw26QNo3+av3cH3VC9s9c3ySt4DaJmg0fUV+aZbp6nZf8J1wGwqer6CeRiG4zmLW5H7lhLJLcOMwjGKGCaHOCiDU0YDoOp+v93UEZVvW7OJz3KUtiadwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WGO50ClL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CE839NFc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WGO50ClL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CE839NFc"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6249lww52403263;
	Wed, 4 Mar 2026 09:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PY4perdu5uksSwAflPhTVIh48pcv9GljIAfvwK07Wgg=; b=
	WGO50ClL8+mcZ2BRqg0/f7Tw2U32PAP1diz0P+CpCOu80A523tKcJGmLDl9YZv0E
	DvRFwgLxET4S58JqlMddmc2D5XPeymTSInzy/aPxZ6RfdrK7xks23oI2i/Ejufte
	TM89Q+lMd+TjQ/Q4vweQtT0Pd0wDWJYd7utlsXoSd07qzp7QfZ5VdGrLW9neh4Y1
	jOObzpC3cJrr46aDCn/FnLMKDV+gXS0PpAH9auUJ8Cq3140ntWVj43XWtpYAaWpM
	NkTDg6K9L4SIYnF1FfrqgD1oZ1JwWeWcvT0SvM1i6OyL1JAFTzj0cPjeWu/9duBC
	nIDpgtjPbIgCczSUuQTgWg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpjdvg0g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 09:55:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6249VBOu030020;
	Wed, 4 Mar 2026 09:55:13 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbjr6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 09:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyH1u8tOSiSy7E7VmzYX2H9L76TdVVVlHvr66hjGNTMf0lrdb1w4GvHPhTUIp9xN/ql02+N529jDGL4XcUL31/V7LmJZ09w/0/fG9amoO2sK2KE6s58zbe5gGX5Nm97NzwC6MqkQmRA5/407O0ARRiEGBgG5Q9t23T3HEUlVSfVKU3eeTcI7Pfn4KqDejTaQl3FibOE2kaD+Leyzh7+tK5HbuKsYvIfnbA4Mm+74dLhAuGCd0WdnBXz/EdvvOrc9BaEwbkMN0GgYkdTFsL0r3xk0IpZBpWhO4iR7BqlzzEbeYpuZ3aVCtpOs0XPQ7hU6tJR9Tjz7dgVcOLMupavgRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PY4perdu5uksSwAflPhTVIh48pcv9GljIAfvwK07Wgg=;
 b=Vy6MAxPLHRlk6qIV49gRyt+dlpfJHnUlZKbs/EVZeOdke5yF5hhiLzRWW2U6Znpp+VOtoH8oALJK4Dm05vZ56aWKcIjpejIjrdd5T6h98RlwWtX9M0EoB0JTedrMe5FNDLYQ9AObFXndm1AUkg/9C7fQrWQxWGsAfvAmMDhEjIPQ9iw0JHfI7X2jqf2QiH77x85+lfG16eUIQ0mLwwTIR8UNcSearISxUDkX16l6yis2t9epHQlLdki7K+VYEFk6ftK7rvlguR5UJiJA0ta2gsABVdEj9wchINAXsvDC1WeSJYHOFcxhHut2v7cJUNqwT+Cfduler7zNGP/jgZc4DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY4perdu5uksSwAflPhTVIh48pcv9GljIAfvwK07Wgg=;
 b=CE839NFc2jAWYTimv6bYBKYZrYyvXCJAJS6TdJB5eE8zzMKBuoOYP56FDK6nUAi49iBjJXtTS0joAVzemwxz5/A6pcrWVEXI4GGjgtqC6vOt01zhiqYcpX2W7aSj9OA5m8zSsiQB1f6qjWBNiF7+SeEtNC0vGhJ6z/gnfIcg/W4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7125.namprd10.prod.outlook.com
 (2603:10b6:8:f0::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 09:55:10 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 4 Mar 2026
 09:55:10 +0000
Message-ID: <2c5c8eba-c4d2-46b6-bed4-3dabd8771069@oracle.com>
Date: Wed, 4 Mar 2026 09:55:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Fix async_scan race condition with
 READ_ONCE/WRITE_ONCE
To: Chaohai Chen <wdhh6@aliyun.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        dlemoal@kernel.org, bvanassche@acm.org, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260304075712.3039960-1-wdhh6@aliyun.com>
 <2885ac50-2326-4548-b92c-c5ae566a8013@oracle.com>
 <aaf+ucySU/sSN8WZ@VM-209-93-tencentos>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaf+ucySU/sSN8WZ@VM-209-93-tencentos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB9PR01CA0028.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::33) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7125:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b29fac4-affc-43d3-81db-08de79d41fc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	Viyrun6dS4403YwGXnJE/eTrPcFj/hNk2USNveLYE7xtl5HjvV6/bm0FDuOucoinOlBNlYO0wM+lo/MMuwVR4o5dtWcXyGMFyEJMmPOOrKU3Xw+8/s+g1iMMxtT4Qa1W/LBOkPAUX0vtR4mj/WlpESUyUjaa8Qtf4WKrUHBr+2GE43VSHl5hzGbMJhI0dgpCU4T+6/hxWg9fhY2NsJvpCGXxn2WvuIZK/JcuUPXzDXiWzKk+Hf02Cti5KPbZEWM4xHj/RiFG1yc6davPRx0EzlgzRhXF5Y0rbUpYUY9NqhF3nZ5Aj7h6lQWyRf6IFfEL7LH8MzkVHkje3fRUcQwk0Yl1wGjTBmsui8gOSa90abtA9xaK/mHk1/JeqW9oozU7OIFYmuCDLMBfCZh8sBhefr8WH/0U+yaq4PZt7FzWrr3HlxrKqfWik1QgGpxlD+ck9Xow3JQONADw+0klVtd0myXU3WqHHOnhO9yZ1Hsu5UAvL41ylGHKSmNhODGbEH4xXKQ2IDZPaHTiB4ypix1D0mzCYPSHFYcVhBPX5pOaUOXUlRXVOjKHciMXCtsYrwXG7MTtWtHHc1M0Y1Vvvp10tWQ9HIXEpA7h+Xi94ccrnnU3h4mcTfZEJgPACcETP1cZaqMXwbCEkxTujexO6qGylH96SU6XcBsH2xX1I8ZhgKDI9VBGMCmpDtglRJ48h3kxgmoWfxA3Sw3TwHlAAfFzgzA+ZXC49/0qgZuzbzdsL94=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWVub0Z3UjdzYm40eGxGaGJzcW1EbFR0Z2RzUUxEbjhDemtpbnNMeXczZk5J?=
 =?utf-8?B?emJHT3E3cWVkcHhZT2FvaUowSytaTHhNbFhHN012ZUdEckxWMHRBZm5GN3RL?=
 =?utf-8?B?RHJnUVM0K2JyMUw2T09UTWdxZW1ZUVdXYlpvZGxPWWYvM2lWczVjYUVnOVZK?=
 =?utf-8?B?VW0xYURFQ3F6c2hxMVFjTnRRL0Uxc0pnQUN4a1NsbElLbEZOREt1bTQ0SU9r?=
 =?utf-8?B?ZVgyYXEvcTRMdmtXb2wzclN2QW5ROWtLRi9HTVRETk1RNFJncE1DV21BQ2Mz?=
 =?utf-8?B?cWM4Uk9TOWgxL3R3bjlLbWNEV29LT3pHWjF3cmhwTFdRNVg1SWl5WlFVZS9i?=
 =?utf-8?B?LzNFcnROSHU1MDhYbGxWUDY4Mm5lWG8rM0tMaWhJVDh2czBXV3BCcnMxWmo4?=
 =?utf-8?B?aFdYSGx2TU9FNWk3c1JVcUlydFFleXdVUUtwTHV6WG93M1FJbXNqN09kL3NO?=
 =?utf-8?B?TjJEaGd6YUE4eEtUZkVtQkJLRjNmKzhrdk5OZHVidjQzaFBqN2oxdlNvdDVw?=
 =?utf-8?B?aUk0OGFYallhd1RRTGNpbEdwNE5TcUVLUXFmdWVLVlpJcUlZQWZJQ3FjV1Vj?=
 =?utf-8?B?TFM0WUdJV1lzRmJaKzFvTER1dC92dGZzMldwR1VjTkFBbTZkcUdyQWVHZlVn?=
 =?utf-8?B?KzJLV2YwQmhrL090ckgxQU8wd2lLNEJla2lGZU44NFVEZERmOCtvSFk0SHdM?=
 =?utf-8?B?ZWxrTDJDU1J3ZW9PL3NYN0VNUmtPM010d0paSjEyRExLcjRJakNuTFR4amFC?=
 =?utf-8?B?cFBycHFkdWx3bk0xVUl0aWNXaWtDd0xrWW5iT08yYUpHQ21uUmhoajVPaUFO?=
 =?utf-8?B?RVU2ZnZvODVXMUpESGM3QWlmVlJQVERvUFBJV0ozc29FR1c3UEw3VDA3TjR4?=
 =?utf-8?B?emd0Mk5MWGgxU3pSbVN2Rk93VDBWUUdrTUFmbzR2WGFrQWJUNVFZY2JQUEhR?=
 =?utf-8?B?WCt2T3djdVJIZkRuV1BVOVJwOGM1bnFkeG1FNmo2N3BSMEZFV3FXQmEyUTBh?=
 =?utf-8?B?YWJwekc0U3JvY1c4Nmk0ejQxMGZqb2tsWHMyRGdDS2QrMzRYVUEwTkJqTy9Q?=
 =?utf-8?B?S1Q2MHVCekRyTW9oTEN0QWhYNm5hMTFwT0pQb3kvNGlsWFFNemwvaGhRT0Uw?=
 =?utf-8?B?cFJITEdLZHAwKzJXb1ZDdmNrcVpsMXMrLzl1aXdQc01IZGZxNTYxeXBGOFc3?=
 =?utf-8?B?TFJFQWJGNFNaSXVzcDl4OEIyNXlnSnNiQVRaM2xmYWlwcC9ZcytlSEdJN0k0?=
 =?utf-8?B?eStBV1o1QjB4SWg2UkYxZTdXR21LZGw5L1BWOERMN0RkRGVuVStseDVsY3pB?=
 =?utf-8?B?ZjBZbWtkODNoVCt4b0tFa1pMUWVsdmQ2ajg0cjdqaVBTS3hIb2ZETmZKSjF3?=
 =?utf-8?B?NDBxMC9mdDROUm1NZFc3MmNCT3ZuR1hiNzNZTkdjNHZhZ1RrT1JITTJyZ2t4?=
 =?utf-8?B?Z1NYQ0NEMDNuWThpRmI0NEFndWswaUVkZmljUi9TSlZRejI4Um8yRmJmU2RR?=
 =?utf-8?B?cGI5b0FuZW8vQ1hkRSsxMzQrdWVveUdFVDkyZmRvUUVRRzR0T0J2alRLWloy?=
 =?utf-8?B?NUxPSm9OV2kyZmc3aTJrMzVrV2t4VWRRd1NSb3d6U0FKZmZXeXY1WFJZZ2U2?=
 =?utf-8?B?citvT3R6U1NxVFdycmRWaXFDZTB0Zm4zS0JKY1lUOTJhUzBROThkRWVTcUJ2?=
 =?utf-8?B?cWl3dmZNWTBWSGZIVCtpcTBnUDBVR3IxUFRTQnVRV2pUOGN0eUw2NWpCM2Zx?=
 =?utf-8?B?VnFyU2JrTmMzMWUrMXV2VjdTdUtiV0gzaHFYSjMxSEZENDdURHdzWnFyUDUz?=
 =?utf-8?B?dXB1VHQ4TzJpVkVnVzZQNHEwYzFKWHppb3RqZHVVWGs2M05oanZmRWM2RE9Z?=
 =?utf-8?B?NDZ3UE1xZXVkczFiVHh5Qm95NVpuWjQ2UDdjQ2o4QUxhOVFDVUVrYldlNVhp?=
 =?utf-8?B?Vjg1Y285bFM5Wk1jK1FmNktXdllYRXZRell1eExmQTZtMVgwN2NwUlJlRnVR?=
 =?utf-8?B?TndOaTAxRkN4YlI3eXJnVm8xdzRaUXppSFM4SVRzVDZZVVVmUjlNRDVrSUN1?=
 =?utf-8?B?OThLakJNQ2R3UDM4dWVKUlZoM2hoaCtmQnp4Z0hmeVhxanNrcmpzenp5NmFl?=
 =?utf-8?B?cnMrNlNPdUFOMnRDaWlveTFpcktFVGZEbnBsZmhrK05yYVRiMFFhSXVodlpP?=
 =?utf-8?B?dmNCalVHSzNLQ0I0ME1LQ2NFa1RydGRibVNJaVM5U2RJVTZWck15NGhHZHBi?=
 =?utf-8?B?MkRWbkxNcXRxSHMwSHNPZVlXL3pFT1pXaUh5K3IzM3FXektBNWNZdk13OEx0?=
 =?utf-8?B?MGViUzRpUlJRaWk4M1BDL2EwdXJ1Y3NnQkprTVZFRURZb0Zab285dz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	etqsF3mF6I8NnXKfpkTOTCHGDrhctPmgPlWbfybuMx9M3cBFa3yirLB8kOuhuG3FQae+2zja/PvRvADcX+mWemD78umsScdEddAPEhyGCj6nFDhnG+Hw1Z1PWyweHdtz/6z/LkA/5f4lTv6Ol1lxUvMlk6DUu5lYK4pGUXz3+xqW4itKonc9xNfrtZoGONjme82eeJpx7tdXIxh159A51rw8+AyJVP5rJeQ5jIIIcQnpTxd4P68JZClOWHp1sH6euu3qSOgDi/oZQsy7ls5vus2LEQJh+QLwyFTZGMk4K+Ifoc4SscMdd8IBJTTkZj5bX4rieTxZ9sYzIAG5l3ceA4zfgLd+8pNANE+OLBx1ObbFAbu4k9D+NBamSqujcpnN2TSra0V7B/nyErbtYVrq8oqQ/dN/l6m0mw4oCr5SWMXW98nNPIR8rokUbqA/55/Mrn0GDu3SVXPBdxbazjs+YRJlvcCDc83HC0kRLW307emEPW8TZ7tRwXt0+2bVP5lh+Z1EZfSC+LKyyMvytW3XYNYjW/ufhDCpgDCmANVUnybChk5R5ocGCLv+IO/tEbpf+PU7KHNzQsP0N9C7tPYAr6+YSgolm/8/5lp3HX8QAAk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b29fac4-affc-43d3-81db-08de79d41fc6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 09:55:10.7670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/syRaTdsKlxmSiAvy5ltDDHzosGzcYqNLAW29Rf+NqNpCjvtuZwuddjC3XtNNEoFub5NaQ5yUVzv9MqkorxWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7125
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603040075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA3NCBTYWx0ZWRfXzwfluTA2h3bd
 8lFIDtkk+YEE3e28MuDyWW6AnClbwnzQP10igAO4gLSAXko6SZIreB0awcF/1pF9bP6IHbFhS2T
 6y6yEDA+JrH+Ls+6Q3m6SiOWoThXojFvlVBB5djCj5emATSuSuFVMQX4k4hj8Ns6+gaKMPKqT3L
 NXf4MWM6PZ/W9GnkTNYYlY4mrvoiE+lgwlFSW0loIliEa/4tgymRpL6uoOl1Y21I1ufg3l+cilr
 RAC/gDWYX5Nbv1iX9OBi7EcOvdrRHyKJhX1kBBdq/A5e+P0UtFYj5hFq9xslp1U+yagNw4MaXX3
 7D2Iyxm9rnWdCDUtoTnsXaPgGQOBKhMRR9zmuPEqMjC74jnSZoW9vZlCOI5QpRaWYFkYPx0yPuv
 Eyzo9rZm3/NJczFaPVrqN62Ch0rNJx9RN3QFLScPzjTBDmT2o9adEYl6SF9JdMJKc/3OGKaFkvS
 lhvKVjhJVsCqbYySwhQ==
X-Proofpoint-GUID: BHvPfQi3cZGjqHMIqmxxQm-D8OBS1Ow5
X-Proofpoint-ORIG-GUID: BHvPfQi3cZGjqHMIqmxxQm-D8OBS1Ow5
X-Authority-Analysis: v=2.4 cv=C9/kCAP+ c=1 sm=1 tr=0 ts=69a80182 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=hf0mEoRwjFS_tdgVxocA:9 a=QEXdDO2ut3YA:10

On 04/03/2026 09:43, Chaohai Chen wrote:
> On Wed, Mar 04, 2026 at 09:20:25AM +0000, John Garry wrote:
>> On 04/03/2026 07:57, Chaohai Chen wrote:
>>> Previously, host_lock was used to prevent bit-set conflicts in async_scan,
>>> but this approach introduced naked reads in some code paths.
>>>
>>> Convert async_scan from a bitfield to a bool type to eliminate bit-level
>>> conflicts entirely. Use READ_ONCE() and WRITE_ONCE() to ensure proper
>>> memory ordering on Alpha and satisfy KCSAN requirements.
>>
>> Is the shost->scan_mutex always held when shost->async_scan is read/written?
>>
> Yes. In theory, there is no need for READ-ONCE/WRITE-ONCE.

Then I understand that in practice that there is no need (for 
READ/WRITE_ONCE), but having it will do no harm, as you mention below.

> Plus, this belongs
> to defensive programming. 

You could mention what this in the commit log.

> And it indicates that this is a shared variable,
> which means that this variable will be accessed by multiple threads and
> concurrency issues need to be handled carefully.

Reviewed-by: John Garry <john.g.garry@oracle.com>
