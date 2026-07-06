Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF97627CCF0;
	Mon,  6 Jul 2026 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783352333; cv=fail; b=ZneTGkkNSmmdJxJ2NfxkA+PfQW4syucCEct+rWmzRf2RUGa9HSSbivIWiv5BMIieFgBHjyyaVTgwC5toMgqR7STOnCRqFeiVjcIY+J0inIQJb+XZ4VkDqugX5JFvSGNWr6N244ZE1etAujyFY8I+KUpwRvPsT/4cVLzKz09fw0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783352333; c=relaxed/simple;
	bh=sZ4Fbnr79IHscjSBXoVHaInR3Sqqo7L0NpOj/bzYYZ0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EnDOHKWeK2eXePspM67nwdSWqa663XakqpqRqviX8OxNjo+a6dKsi++8WAt8u1fX7jwm9+5yj6ZyxLvTABGpDWSkqaNPISyVQXlvyDDkRVzGaJE/hDyh6/iTL/Xok7RjDz6+MH7eBbyySMTv7Dkgrqn7GH9Tt5yosyGTOwc9VDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H/tyw83K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OVoNE0X6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H/tyw83K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OVoNE0X6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666Ee2mj1150580;
	Mon, 6 Jul 2026 15:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Fsbj1m+n7wrnJorqBZSOd+8+BNo7RZGuQr0dxa6LtyE=; b=
	H/tyw83KPzvbeG4JZ3PiUIM+IcORTqSAFX9bv+f4Ga2T+Z59tXKWgZeRpwW2vp23
	No0EyxgYFWVcFkkOKqN3SovFgQ6EshJgP+Y5jSuJK/Lj53aFmn7K4GDFL1ZvmGmV
	ro5aDBu8r63H1rwi+toaMQ6xSBH7xiNWJd+qCIDlEYTYNw3VsJE4g6dWto4oMtdB
	Yh/nKNmnbUu7zRGQEGIu9hmXworgbF8FYufqNWJMl7HOBWreSfH+BWyoqELRbNMj
	BdTju7+nLfGmCF4uL29iUBYYyaLpvMKGqcUww+WY4U/UBtI/rRqPLg69uh1FZ7AQ
	ZissoYwrOTt3rkLhQAVz8g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6sssbx92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:38:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666FcWDO029449;
	Mon, 6 Jul 2026 15:38:50 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012032.outbound.protection.outlook.com [40.107.200.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f84vx3qsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:38:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dF/S8CEweleqRHCheEKyTqqPFdCCpdVdRgR3bgy42s4F0kmIFBavSaOPNo0KR4Szx76zIQcHINFMZDoDEbnxm7ipxgDvJTdZhkMiJz3VaeQhtlyVcOEDkyT2TY5FXPZg8H8sQc4ZU+5MyBq2WQCxchsAzCnkPO/qqeIkKsuJi3EkK/WCJpqv6ZOjcAO9EOUQQD9Gj98Mgh6gPxZwAeV+tFhS6fgoWm0j2eMgLYQ5thB7ov4XKRreqkQlEzrFN9M6KGf4lEutuBjkw+fnIfNJ+ouhYvLN6he/cq7GULA3w1TVTNysIdDeA0+uf84/41FZg7Ivhqo3v/y9aINpznFxjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fsbj1m+n7wrnJorqBZSOd+8+BNo7RZGuQr0dxa6LtyE=;
 b=g8P5g0tBvl1COPT+vBTGyfHJ3GzaM/Ls6AxDK8CZPCFFgEK9lM4Tepep6dClkmbpL8exacnll/gx0JnIT423xi2BlJI7ztsLSrbq6T0uI9Oy8uo/lT3rpgsVDz8l4C10j8Xl4QmA8FXLVr0ZkoEiFa7uOznVTGt02ZA1tWAxukhjtHaJSspluYEl8mvAduOV+LdJWPKx6kcpis+5o7mHiOSZ22HHl8WAZkvwIJpvUxb67iFnmZmqtOHbh+BXYQI98O0pd7c8U/a50beZxX/TuCOyuYnj5Wh4aYrm6VQ81DAoZ/HUiZ3IN8hhd6ht231hjmSlEI/IP8bDjoEcNnaUAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fsbj1m+n7wrnJorqBZSOd+8+BNo7RZGuQr0dxa6LtyE=;
 b=OVoNE0X6x6jcBY0vKsMgLIzNq/66/w/xuZjj8dG3IvL9qmCOGlARU5HzuLsyxVRwLWfETcU5zpE7lRAIA+OIn/XZtBoDjDLDty6VgRWMFiY48V7o2N5eDIMV0eZp7wwj0WB7pNsQW1YWyIusN0kUixl6OitnrWh6yxoskI1krcY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4390.namprd10.prod.outlook.com (2603:10b6:610:af::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.13; Mon, 6 Jul 2026 15:38:43 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:38:43 +0000
Message-ID: <6a760386-9e13-4331-bfe8-d30e356cbab3@oracle.com>
Date: Mon, 6 Jul 2026 16:38:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/17] scsi-multipath: provide callbacks for path state
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-9-john.g.garry@oracle.com>
 <20260703114918.1CC661F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703114918.1CC661F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0269.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4390:EE_
X-MS-Office365-Filtering-Correlation-Id: 54279573-c36f-49d9-05f0-08dedb74a8e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|3023799007|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	GkNyhQTEb0ZYHZlj2p1k7nwp0FyotsqiRRfFXQYDKrI/Iwqx0lrnesPy+p4rMBQ+RX/hJWmch/hm5e0Qz0bLD4hKiABqe+7llihkydPir3qB5Zhdpy7VdHOw59BhbU/wP+OYUTJNiMFUMbSyTNRwYpESNiXeVaeb4p/xSHzzGovs/49hIeNuNtyOlwpC7WVEwfkvDgusOK45zIXlNkc8lF/ddaR8eV3FMsiL/Tu+t+ldLhLcB7GhJIhyIs7sV1IdYyRswixmXuS5WkxK0qTjcGvUbFxOepSo+l15fbiwTgzNgSbSWTroNzlbZcfI6k1BRub/EJknTS/T3NDlnk9IYUQYbDDhCn/lHOBZwVy10aLv6VIKInnm0YGuESc02uXEeSwQEy2mzieeujnErkO1IQDXE7ThvxSEQq+K8J+hdnspELQ0KAiVHVF0fFk27WxYqtUZVjqdg/YDM7TVnEVN368jpxmLapqSaDzo8KjVz3SAoXiMhzyWm9RcsX7Atl+fG+S/SfDRqUboVwDk0qg43XQvuV/s5JflqyXAFz3cf4G588Uts5SaEdCyEjkDzGm+I5mG7aWIO0LNVvWKod1zul/0/jhGPIXCuZazaxxiyNc7zFZFCEqYQm+0BYvwtX0btTspRzbgfznLbUb5EMaJY4MxMiGTmcT/rTvese99Ets=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(3023799007)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmx6WWtmMk1UU1ExSXhMRXhXMldoVXZFWmEwbTYzUjlTeTV2bkxqVGhWb01D?=
 =?utf-8?B?cWNxWnQ1QWU1bi95c0I2bDhIWXZIVlhLVnhqRU9UYnFJcEh2WUFBNlh3anhN?=
 =?utf-8?B?U3M4OHZhTFFtQXdQV0JBc3BLQUNRYldQaFVHK2pMNFg3YTUzcTA2RmF6V1BM?=
 =?utf-8?B?NzhSSXBSZUdCb2o5cHBIY3NZR3N2ZXlNNTdFakRYeHliczdLaks3eHZoeE16?=
 =?utf-8?B?OXRMdUthcTM1dy9hOEF6UEozUytlVFZmZ1I1VmlJMnB6aDRFVmRLYk0xZTY3?=
 =?utf-8?B?am5OelZYUW1sS0lRU2lpS3dIbmpyQjNaZFo5dDN2T0MzWjVEU1B1cSthUmlv?=
 =?utf-8?B?cTJualo2YVc4Y05BbVJlSTVjdUdZcXJZemZZZXJqVjltU2dzNEFvNzRFbzBP?=
 =?utf-8?B?M2w3TWpNM2RHMUxLRjlFQUE2UmV1eVNweU9FeDBReklxSllNUkRXbTRUQUhL?=
 =?utf-8?B?Zk1kN3h5Q08vaDNWaUxDeit4L3FMWjdiM0F2elpDdmFKeHVmUWtDUTFHc3Bx?=
 =?utf-8?B?OVhYZnNoeXdHcXN1N2hESmZ4VjRxWVlGWDRmeFc3Tnp4SEdWUXlKc3prTG40?=
 =?utf-8?B?aVZ0WGVtYW5xWFFsRnVobGQ2ekpoWjVnVGVtVURZN01lNGpjU3VMNkV1dW1H?=
 =?utf-8?B?Z3k3WEhkZk0vLzZYM0RkU0xFa2E4MW5UQUYxMlJBQlpoZ1c2Rkx5TXNFNmZv?=
 =?utf-8?B?SHluVkEvZGFxUHkrNzUwSHp2UE8yT0MvWmZhU3F5cEZpRW40ZFhhTDhzRHBE?=
 =?utf-8?B?K3lnT0RWTjk5dVhKcGpGbjZ4ZFNKMDNxRXZKbDQvZ2ovOUwxQXd4M0dsMVpv?=
 =?utf-8?B?L1A5MmlJUGhDWHowSzRxQTRqVTc4UXlweXFzZ3luNUhEVzhUUmxSRXhqQjdL?=
 =?utf-8?B?bEI5SXpOTmtwWWp0bzh6UWlIZlVpV3VJQlNWa204SThsMzZYTTVORS8xeEVq?=
 =?utf-8?B?UlRHREVFeUxSL0ZxemdjUG1GbTNpWVZwNmMyeVdiNU1zc3Q2Rk56Z3Rpcm1R?=
 =?utf-8?B?QzlLL2VUQ2pNT2VabUlMTTBod2t4NllNSDQ2MmlRYVdMVWRxcVhDVTJrNlY4?=
 =?utf-8?B?WWVTOVFlZ3BmTkp6c2hLTkFwVTFJRFJuQkFTNE9md29jbG13VDY3bUhuYlYv?=
 =?utf-8?B?MGd1TmNkMnJid3NXc2g0STYwcXdiRHZJVmhEUE5xMHFiRGRjT2VWZW8wcGhy?=
 =?utf-8?B?aUR1QWJaS082SnVYU2trNHNsa2F1YVEvWno1RXFNdWt1K3Jjb3dqdEY4RWlk?=
 =?utf-8?B?Wjl2SzVWbDR0dXRXRG5wMlM0Q1JYeU9kMlJkVHYxcUQ2U3RiK2dWZkdNTTZy?=
 =?utf-8?B?YUFoeXZJQTl0YUdwNW9ZRkRaZktZOEpkUTQ5ekk0VVVOMTBiTUdkT1lucDZL?=
 =?utf-8?B?cmlxVkt1anZZVDRMN040aVFDbVhjRkhZbEpaZ1BhSnlnSHM1S0ZKYjVsdmF1?=
 =?utf-8?B?YkhybjFkMjU2a0pJNjAwZ0hibHM3MDNRWjdwOXZkNHZIRjE2alQxSUZjNkI2?=
 =?utf-8?B?Vk1CUWUyT0pxYnljcXRPTW81azFGaVlKN2cvTGY4VkFVUHF4ekVLQnI3UW10?=
 =?utf-8?B?UEJZTU95VUtNdlkwaXl3UjlOQjd6MFJpM0RDSWdYdVJRQU94QmJBV29ncjFs?=
 =?utf-8?B?NTNVanBjT2R2SVl5QmRkTzJqNzk0V3BtU3dMNlFBc1Noc0VneG5tMlh1bCtJ?=
 =?utf-8?B?eVVheTZZTFVONVMwT0tHUm5TQnpjUnVwZ3k1YW90MVhoUTEraHJlRFZwaXdz?=
 =?utf-8?B?NUtWSDRBeWNqQ2k5RWtRK0NrRFFlbDY4dDAxL2JCeHY0ZWdKaDh3SkJUWFBr?=
 =?utf-8?B?OG16Njh5bC9QWDd4R1RPR0VNc2RlaENTbElFTFFwM3M1ZkhHVVJ5ejVYQnVn?=
 =?utf-8?B?Mk01NTRUMWUyYnRyV1BkUDdYTHMrbWFBbFNPdllGQUo3bVk0a01OMmlJMXZH?=
 =?utf-8?B?bnFHUUFwWUFRWGFqc2VPNEJSamhCYW9DRFdKMTJ3bkd6b28wSzBlaUJGQUo3?=
 =?utf-8?B?aFViOVRreHByQzZNQnZnWXVLWUpLZ3MyRUdWU2Q5Z0RDdU9hYmRpR0dpTDJY?=
 =?utf-8?B?YUVsdWNvbFRWcTRYejlkTTB6NHUzUkY0cHo5Z0RXelJUL1B6d2hQZGlERytE?=
 =?utf-8?B?eDZHYmZXN3F2VDJKaThpaXRVTGE0Nk55SkpicWV5dmJxZUN4ZGFnM3Q2VjRW?=
 =?utf-8?B?cmxJNzZUb2V4UWdzZjR2NVpLVGJUT256azNLNzhCem1sMjhJZUtUZ3NWR1d1?=
 =?utf-8?B?R3ZsQUdXVlZmSDd3V2FYQXcvTHJLR2JUNVp0TmUxQ09IOExKL1VKc2I1dXIr?=
 =?utf-8?B?U2IxYWtrb3VWZ3ZkSVI4bkFkc25wLzV4Njh2R2xuMFNkZE9yVTJERm9YYXZq?=
 =?utf-8?Q?YOEE9vT0tOX6FOIA=3D?=
X-Exchange-RoutingPolicyChecked:
	laKcEVldcBsqoQeaxdGvqeHboqpBjxtEyCJt4c3Fvbl9VNVB53wlnTxqWyA3M0sWvH8gN4KxfvBm8NbSz6qfL/uI1HNqNnNs+MHiv5IQG99GWZWa3PHFXlf2KnCtfPRlu4ROGP6br+EKPQPrH3qGeSrZVtQO7fAqXRVzLbtbEj/vPuK8Sfe6A4cY06FRO36hfL0BdBa4QkIWfRFVapAq2vLUpGX5ZWIdnDA0txqeZRwnP1oxrtxXMfhdBhXnK0cUAvQLNbVXLqRNqdP2dDD/j8I4IG9usFrIetuAe57I7SeEPNK8unQbqtzvLFqlcUWEZPe9zIeCyYGWELwFp+tgYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jwssY6u8RmktJgVAq10nXdTiEIHvDwIgjbJk+GuRprofUvMaxQeg0E5uiXWx0PzknR2Lz57jgtdYoBifpOhbgHdawqMgw8xdWQvm64G8bG0bDNv6lYQkZ6tK6ba/c0XxEtrhaPaeoc9NjLA8iUzjY8GF6xN3L/cEyKXKDe/xKhar8yEwR5uKujbXQnbKHNTVDc0fuIlXUT4JqSG89snDFQamKAQBpMIa96WUD/6N8Yk9bNdguqso39ZUhz8hDfda4pQYxJn1UL6bKhdAccixDGpabTFRsL4Ff53KFaMfsUUQngKD0CVL1klVeBUzEFyhoL9/tzS7URflP8QUcQSxtVSCp08CanW8jHeo57060ozDG7fl0bKnFYJvr1TxKqaMpKUy/wjdfOWtZ5bkF2hiXGVlFd+7GR6YpH/t94HoN/hcUi+ISCz2rHILE2qZSglM+Y2bNaXVw/8pB2IXj7MCKF5GPw2SRnNJSi10W4O4/J/qAspkdVCX/pbbKZw+d2Zh5eJBaOu/To+xAzV/tylKpCwn5NDHLYn8sK/nTB5a1P6X2mjrUrB7rh2vkFQlW+hqFeoNIaaGamVPjmEgnet52iozxnM2+qrsWzeibxj217M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54279573-c36f-49d9-05f0-08dedb74a8e6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:38:43.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbhS/DVC8TDm0wg283ttLVYdZGOk8D2eTfHZNgjaytwmHQfFrxv9kD+V19xf+C6rtNXot7/YmgZ1xXxzSDdR3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4390
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060159
X-Proofpoint-GUID: gdlbp53vuP7TztSscNrStgVW-l3stnvQ
X-Proofpoint-ORIG-GUID: gdlbp53vuP7TztSscNrStgVW-l3stnvQ
X-Authority-Analysis: v=2.4 cv=LpuiDHdc c=1 sm=1 tr=0 ts=6a4bcc0a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=r5FJxjr1P8WpHFkrf1AA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13633
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE1OSBTYWx0ZWRfX/nRB/6M0QH2+
 n5EbYCt4WHS98K1g3ERaJnPanyewCkKIG0VReYVoJbh+pUq6Mv74IE4fRV9Fhne4XxyiK3pKYAp
 PaRh/8Shk20z16AoAmR675pNb2FB46aJD3YeOSZpKC5xSWIVcIFw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE1OSBTYWx0ZWRfX2CXWXM0F0Vd/
 90jPzczD9JEhgrCB9rEXF+JMNMeowu1dIso104Mqvu9QHwNUMiUNflbHhBMPe9uTEm7nG1tsb1f
 2zTKCNGOvZ5+H+Wf9mgabUVkgt97hpp6I6SXSt6XWx8+Odr42u+OCAeYiytNb9YsRwgN6ho/fxt
 yW+DsdN7YcV10XXc5SNZGUZrfQltY3uPVqcw6XsKKJS++TyqppxaQFMuAVwPDeegb/1Vb0gnHFF
 U6pLDs1Baa2HVpyOVLkQJtmifLJ7qBGnDXFmbMkXU6ydVrxxktslx5mo2WVQH8rOP4/Sf4aKMN0
 bqPO6RQWI4KD7m+ePqzuRy6fqCw1hVfJrhbo1TrfcMuImdw++2pfPZAw2p1Py0fhMFAGODpt7kX
 Ebl5FIEhSO631OC8ZU0oMqUrjf2o81ozT4ZhbPUBKoqJk/SaWFY/FJkA+CtKADwipcLm5CekoLe
 sk/ULgn9xgGmcMDS6/4/k7sMk0OYhpvKR38uiszo=

On 03/07/2026 12:49, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] `scsi_mpath_is_disabled` and `scsi_mpath_is_optimized` fail to mask out the `SCSI_ACCESS_STATE_PREFERRED` flag from `sdev->access_state`.
> - [High] `scsi_mpath_available_path()` incorrectly treats `SDEV_CREATED_BLOCK` as an available path.
> --
> 
> commit 71967b8cc1b7e6dc50c814782c317913564b9ee9
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: provide callbacks for path state
> 
> This patch provides callbacks for path states in SCSI multipath, including
> scsi_mpath_is_disabled, scsi_mpath_is_optimized, and
> scsi_mpath_available_path. These rely on the SCSI device's sdev_state and
> access_state to determine path availability.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index f22e3677cf2ad..d8ea9ffe8942c 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -301,7 +301,53 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
> 
> [ ... ]
> 
>> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	unsigned char access_state = READ_ONCE(sdev->access_state);
>> +
>> +	if (sdev->sdev_state != SDEV_RUNNING)
>> +		return true;
>> +
>> +	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
>> +	    access_state == SCSI_ACCESS_STATE_ACTIVE)
> 
> [Severity: High]
> Does this comparison correctly handle ALUA preferred paths?
> 
> If a device handler sets sdev->access_state to include the preferred bit
> (SCSI_ACCESS_STATE_OPTIMAL | SCSI_ACCESS_STATE_PREFERRED), this raw byte
> comparison will fail. This would cause the multipath layer to incorrectly
> classify valid, optimal preferred paths as disabled, potentially discarding
> them from I/O consideration.
> 
> Should this mask the access_state with SCSI_ACCESS_STATE_MASK before
> comparing?

will fix

> 
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +
>> +	if (sdev->sdev_state != SDEV_RUNNING)
>> +		return false;
>> +
>> +	return READ_ONCE(sdev->access_state) == SCSI_ACCESS_STATE_OPTIMAL;
> 
> [Severity: High]
> Similar to the check in scsi_mpath_is_disabled(), will this strict equality
> check misclassify optimal paths that also have the
> SCSI_ACCESS_STATE_PREFERRED flag set?

will fix

> 
>> +}
>> +
>> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	enum scsi_device_state sdev_state = sdev->sdev_state;
>> +
>> +	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
>> +	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
> 
> [Severity: High]
> Is it intended to route user I/O to a device in the SDEV_CREATED_BLOCK state?
> 
> Devices in SDEV_CREATED and SDEV_CREATED_BLOCK are newly created, not fully
> initialized, and generally only accept internal commands. If a newly created
> device is temporarily blocked, this function returns true and routes user I/O
> to it, which could lead to I/O rejection or indefinite blocking.

It does not specifically route IO to it, but allows IO to be requeued 
for the head to be issued later

> 
> Furthermore, when the device unblocks and returns to SDEV_CREATED, this
> function would suddenly return false. Should SDEV_CREATED_BLOCK be excluded
> from the available paths list?

probably

> 
>> +		return true;
>> +
>> +	return false;
>> +}
> 

