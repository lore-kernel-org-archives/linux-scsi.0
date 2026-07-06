Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887D3434E31;
	Mon,  6 Jul 2026 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783348780; cv=fail; b=Zwa06wNcB2y4IADcVHC73zT1siVe0L6jBgMfYaRrtCQoW73k3z+ozpfOk+gz+94zA4bcXpUHgY0myOB/x4kCZnPZgSTRrejrdqPWW2qsD3Q7kurBic+zIeWCK22HP5OLww1nQ91GZNTU0iy9/XUzb9MYfusWd3ijAV8APjtajl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783348780; c=relaxed/simple;
	bh=k31fzYWXct0EEpEqJrN/QKVIFIi8G0N4KLDLMI4qL0k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qqPmIOY++tSparxY4d+TpmTiY3MSGYdO8xQQ3rJjneRUU8ckGhvejGtIM9bb5ZDyzqMS67iIqWNvanOVJZdkfnWiOvU5sBTFLAoOt9Pua90RdI/qGd38AREJnyGjDow5aVcASh63cKWNak3PCA0uv6MV8WAB4oJe1QXskGwJPIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xd4UFkmN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RltL2CNF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xd4UFkmN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RltL2CNF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66622LkL1569731;
	Mon, 6 Jul 2026 14:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Xlo+Zu/2gBUw1HeWXiyTom3o4wUwSq0ZKXXZRtpWxiE=; b=
	Xd4UFkmNCP8qlZhZc8VpmwOyuDqP5/BpjXICHIsD9MwTxu9RYwgTWffFzbA7yLD2
	IRaSF2SsQHV0utC54p43EFckRH8Jkkdv1A1KGpWA5FD73YrYS6vDcxNcrb6mu62e
	6sHS34s1j76rjMEp7Y9VAj9KJ/syV68I0ygPyRlyJ5KmpJiUsPzYuh38Jt2ksAvF
	FKfOdDQA4arJaPesHdzPml5X+yJN0aFoVopZTgzKFp2jur9hacvVXUienZuGHuTp
	tr+Qb0eS0dbzltwG8N175EYL0U+HGnSbhq9696LfchwOzT8H6zTnv4cEAe4kKRB8
	UHIkvcLX2dN+sU34MKcDdg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t7cktc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:39:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666EcZTO027466;
	Mon, 6 Jul 2026 14:39:36 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmp7kpn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:39:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x0llW0hwJsSqxjFV1hQfTGyd7bC32kUm00ZLu0lz6zK6QBCacwB6MF6S4iqCKLq55IFlb3DKxSDSyxHe3JrC3Ls/qajyMFV2oS0HfDkp5KlHao5C1ReatQ6XRMknpfi7L5LJPZT3o/XFRJ2LW6rvDdf65S7/OntZhTh8J/ZXa7Px5/GFmxhY59MJgt0BlPpHH1xV3EcIaZnMj3qoau3Y6TG6aQ99wEDhn36amcV+hNtgHGxRYdfT6QzXwTsGueODWAWLniHvFmyRCGfg6M4FSpBMgabQ8NV0auA0r9aA1Tcz+B/FLGLVuz6ymqF5XKGW1Zwtr0wQsLFrL1anpzC8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xlo+Zu/2gBUw1HeWXiyTom3o4wUwSq0ZKXXZRtpWxiE=;
 b=T/pH9DnHAsIJRLXEp4ZIxeqgZw52PKos5JJU0vUChdq39SdNQESzcvVax5pKzH+6QJWK2q0T9/QsY3SVmyn8o25PROpY0AyLzUgTSjAxQJkhqQiKxhwXnOgw9ei1Q0O+8ouc7J0VS1JV9P5VUW4SOZRaAHijHGhZiYQU4urWGTOvUw2Rz6tT0rjEdnWRD26BuHuEiImRWJJVE97Ej/oidnp7o14Utlp96C1hM1zaZrN8l63KsTRgLz6Cc6PV065lSgWMRo40HaEuDpDkeP0e3fl5fzxo/vRwuXFjDdPKhr1WqVsRq+AM9kUoJ/DYCaZSvByHdWSTceDkGEQx18j2bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlo+Zu/2gBUw1HeWXiyTom3o4wUwSq0ZKXXZRtpWxiE=;
 b=RltL2CNFrR8xsF23vlWoXpGq6p8DnwkPyPNBrHjSUPhethfodTQhyYqyhu8yg4wOdMPd2uVRnuL9MN+xT/3wD+H3izP7tO2aUbgXv5NwfmN4mx5pzyp2t0FlNOUZ8noLoWtVOPtrW7eYj8K/GvU1FP58c8U49X//g1j4625WURk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM6PR10MB4204.namprd10.prod.outlook.com (2603:10b6:5:221::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.13; Mon, 6 Jul 2026 14:39:34 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:39:33 +0000
Message-ID: <6d8f87e1-547f-464f-b9e7-e798a4c1c3b7@oracle.com>
Date: Mon, 6 Jul 2026 15:39:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/17] scsi-multipath: introduce basic SCSI device
 support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-2-john.g.garry@oracle.com>
 <20260703105326.0D9721F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703105326.0D9721F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0288.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM6PR10MB4204:EE_
X-MS-Office365-Filtering-Correlation-Id: b66b3292-ba44-4dd4-d092-08dedb6c64e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+IZoF3j7ODroeLVo11uiKCvfx+nXPxIl1+OwjoPd7Hzp373ExJzSJ++cccrlNGoZbchLR7X2SiGVoZgqU9u63GyTnN4KuwN52QXWInc7vB6W0cNZ955HdqR0JTpeIvW8Dtv7tx6IKsUFBnsBOwkybWN/jZAimzHclH0ENsL5ku0KuemuB/Ow2Gd5YNqF/90FkzKhpEwDnoiX8KPykZs2fX83p9y8wmZzDOkgUadr/NPxJMyWUT8dWIbtMw/veaZPL6MvaI3psZrOx4Icjjbs+nyJuJ74KCVs4mp2kfwWWkirELB5vhFqM1nWekwG4Qdod8kLgj6khdcZ7m3RKbfBI46pe6ChdIDW7AtyvZCkVsL8u1K935Q4EIYscATALYR5aXdxJ87vioILJNd+7IzjJlihkSjayIbSecS9w/Aj4vOP80nwGycCYU5NmII450cXyO2hx++FbwdKfAOUlTOyQqD0LudpTJHhUUq8hp+H9+WBHpNVoXiiuVShveBkhfPFgBe0Jj26NtYzf7R/eWSyYfwwASuRtMFZVzqXWlXXQE+20oZ3s2izXDUKCZBBaQDwgCUV9v9HjQt6ODqcZeOn4JvhgAr/CnUZ5ms77R/O7riRuW7Y3K5CfpCLBIJXbmiCTQdBiR1cb2jaEhzF9sRQr3CGdnj6/5zxqAq4WYVr76w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnVVRVlMcyt3NzkvbFB0aW9hSGo3VFMyd3E3L3F1em9Mc21FQzJucnhhSTRi?=
 =?utf-8?B?VFRQb3Y4UE45d2I5MlBKaVByWGttL0RyTG50L2YrUUtIdGdDUHZSV0lkL1da?=
 =?utf-8?B?NkZwNHE0bWQ2a2UyZTdNdVBZYnE5dmpSUk9ac1ovUWVlclc0MWRiUGUxeFV1?=
 =?utf-8?B?QTFFV1dML2x3L0ZheVhhaUVEWElFenFtVnZldFd1TTFNQnpwdWpqb2hPOUlp?=
 =?utf-8?B?WXRmR0dGUlFRVm90T2FqaXIxdm1seHpvSTl5VG5GWThrb1J2elpucXlvRWpG?=
 =?utf-8?B?RjNJdnRpK2pVYzBHcDMrdWFTdDA5OFJyZ3VJWSt6c1Q3TVUyWUJNV281TXFH?=
 =?utf-8?B?OWhxd3pxaCtOWklnUXljYk8zdEllWTFwUXZqUEhLZlhTbnNCOHBhTGpJY3FP?=
 =?utf-8?B?dVR3TWc4RnA1RTJyZHg0d1NCL3RmbjVySEdEL3grUGYwWXVjSHJxVmxnM1BX?=
 =?utf-8?B?dWlJZ0JrSHZwRlEwaEdoT1hoaFZEbEJZK2lUcVVnOG00TDV3b3JmRnc2UTVC?=
 =?utf-8?B?RmRSQi9WbVg2NW54VE5UbENCWndQdHBrbEt2RjVpUlEyVVk0TUM1dlc1TW5K?=
 =?utf-8?B?QW5nSFBLQ051eDV1ZWV0c3E2MVFndHRzTTRWemV2N3crcW1MS1YxV2dreFR0?=
 =?utf-8?B?WlpmQnJrb3E5am1ENWduNkEzWTZVMjdqRGlXQXlZSTNKQkhRdFlHMGZFVHFq?=
 =?utf-8?B?UkhGTVNjVHZZOWROY2FoeFlCbVJ2a3Zka3ppRE1CK2s4MjlVT0hrbUtXaUJG?=
 =?utf-8?B?WXQzME0xT0ZiQ2Rqam5GM0lDZVlZaGVYQ2NGb2o2SWFQY0taUXBVVnVXY3hF?=
 =?utf-8?B?bE9YOWk1TlBCVXp1MkZXbTZZTngxeDZPYnFaRzllVGdQY0p2TE9zcjh1Mm9K?=
 =?utf-8?B?M21BM1UyK3FINmF0NURLUzlLRDVNdmdyalJ4dzhEVFpSYXM5b2JwTktFL0hH?=
 =?utf-8?B?a285bkl3aHpzcU9ndkZhdEd3cjVBVFNwdEVmQ3FBeWNrUEJtYUxtOEZBQmVH?=
 =?utf-8?B?aldaa2xhSEVxVHhBZFlncE1tcUY2Nlc0dThmUXQweHhITHpaSE5idCtzK1V5?=
 =?utf-8?B?d2E1TTlJaGRaWVdOK1dSaTRtdW5jdTM3ZTBOd2lldTUydDE3aGwrcGlzS3pM?=
 =?utf-8?B?VXdLUjdoZ29Db3dQcjhyN2lyS3BzazVEaXNlSHdsekpjV2dOK0NGYldocTRB?=
 =?utf-8?B?T3M0UXZKdUlDOXBIR2ZjTk83aUJxVVdhc3lqemdtVGZDaU5oMC9BT3MvdXpx?=
 =?utf-8?B?SzJBbTJWSUZYVXRmbHdyWWFPZi83anBiVUtSN1Q3T0ZsZ1d4VGpkTnh1TXYx?=
 =?utf-8?B?NUdYV2VrTFU5WEFLTnFZSXdzMFJxNTFVVll6NGhiQjFueUxmaTFQdU5HV2Fu?=
 =?utf-8?B?MXIraEczUzZ6UlovSStLdzk0ZWxyNmJ6VWp5Y1VtU1gycjFrTE1jM1p2cThK?=
 =?utf-8?B?MHlXc3hJVlorMlUwcDR2QUtyQkZEdHM5MlRWVXc3bEVENUx4b05lUlRDdVZx?=
 =?utf-8?B?elZ5aTk2WDlkWkE4NytzRWhKd1k2TUNDK1NFbkFtOG5CU1dSaERTakpFbzRu?=
 =?utf-8?B?SlFXUmFDR3ZFSTErZTNIaFZ3cS9oOTVSQlllaFp2MGR6TXEvNzYvZHdsUzha?=
 =?utf-8?B?d25vSThJVVhFaEZSSnFZQ3htVSttSlFZZ3ZnRDVjdHlHYzd1YThqS0pSUlFV?=
 =?utf-8?B?VHZrelhDOVo0YlBOdUdGMzZGNXBiWDdtL01VWFI1TTVib1pwQllSYlA3b2hl?=
 =?utf-8?B?cG5EejZac3VXTDV1djJXUTYwUkhoK2lqdVZXT04rR2ZDaFlCNlVCeElPaFpp?=
 =?utf-8?B?ZXRhM3pTaHB3OGR0cTNZRDdYSWlPZkNpT2hjeWo3YUJaZ2dZSndlS0ZDb0dz?=
 =?utf-8?B?a1J2U2ZuM0F6M3MzZkcwRUpxeDg0bXFQUi9HemViVjhXZkJvQVVwczQ2MVM3?=
 =?utf-8?B?bitaeXpWanZEbFVtcGtLYjRHVFBrUVdmUi9UNkJBejV0RysxT0R0RXNraFd5?=
 =?utf-8?B?RFNSdFZ4ZWVxNFNoOXpkdU5JYjVuTUk0VFFrVW51TGhWR1FyWlpsc0NuK1VO?=
 =?utf-8?B?UzIyUk0zd2llTHpJQ0dUcGZXdzY0dmNQQzBMWG5PbmxZdnpHMytCQ1FkQlJT?=
 =?utf-8?B?eWxCdGVIeVc2U003TzRiOTlRYWIzdk9ST2dvYk8wZWR0MW12TFczRWhBd2Nn?=
 =?utf-8?B?NmJWVG5oSkRheldUd2tuOVl6QVhwdlZIWWcxeWcwSlRBYkg3SE9vUVJ1Sktu?=
 =?utf-8?B?dEYyNk9YZHoyQ2dTNnBVaVd0S2FCK3lIeitXeE9NMS9Bb0ljYXFTN0trbndZ?=
 =?utf-8?B?NmFDM1pEckxDcXNYTHNHSzFNS3FZdnFBbGJIa0pMOXVoVGxUMjBKMHA0TW0w?=
 =?utf-8?Q?vkMbQs8vLS6twGK4=3D?=
X-Exchange-RoutingPolicyChecked:
	s7X78cMb+hsYZ0yIXrfRIZj2f9Trocd9kp1VMpHwVknfJ/IQp5FaN6AsTdBwor1sHFt6+9vO0HLPHPyORuJBxPgymN+rV1Zz5TXYQDJLqxu5VF1DaP/oXz4KUlWMvO7IhVc+RaiYWr9VXJ20wbMGnU90NbXdKQ5hpb8NyZbY9xvNC8hPPoY4XE5n9sXfQ3/1pyk+sRG4HlzMwv+ocrMHT2wCE1mRj5N4DfFbfiTxZHU07VWR1x/iJipXhTBLBiF3neP4daBUpMwvVs4oE7j84pvQ/GLwT5bTDN4PS5JpCkTEh2IjZ4MgNQI/OjFJ4i3GFWPk561Namgm+UIG4B2oig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AUeV0WiivGLmbeFSQKYOLQ5sBpkQMbRQo7l+PvGUiQZ0oEubYuedyC3CT/iHHaKxs5S5IZnnqxzBd/zet6LxNoqROfY4233fN4PFUM9m3etnrh1AT0bSb0jJIt08M5gpUp7QJa/ppEfWhQ1jGZoXylE18xBiPfPxBCEr5vXhPenXy28SVSFBXwBstl+27pIZtLAmADRKMvMk9ZQzA9lxN1yNQmb39aIIeRtZ1+YWQyXHawv1/C0XtEwPeO5U9QBuBn7XIOqGD9rk3tsum6ceb9Ddox2zaTalcUvhxzZxeryUVV0aHD0ClSBRCjeex+YUHKy045yk355MFQWorgq/rNOl/6/Dqd6EegID1sN2SPVKAofyk029CG6PjeTJwhy/IVtnRBS4L5JpCbpnxuGmOGu/QPRD26wZDjeM2D5/5ohF1I9hOxsuvR5QVp9uy3gxWvDtwCKuAhsLUop1vsTuNtsWl90unkduVUb/0FZlTHHnA3f99ibrdv+VkqM5f2OD1jTWF6CPwkNzbvUWof0BQI5jftYAA+HCCEM2r1MC1bXGMyA680q+FengQmpjeQ7ykiKVGFN5iCanThQuejahWb2SLNjLp39bRXDszjSsVoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66b3292-ba44-4dd4-d092-08dedb6c64e6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:39:33.3137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNv6sEa8bvcgOmYP45gUPxxrTjgbjJX0+lDYnj7EYXOJR0/T2dkIQQ00hR/Gpoie5KYbF51PpMJXJ8uTsEjL5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0OSBTYWx0ZWRfX0GUEfKJpRmtL
 TRWxEgke2N4JCFu0xAG6LvrbluQ6VPYxBHM6UfbGCcFoo5mMJ5Xplho77dCrQThEztxSTPzHdCQ
 pZxYNqtygC3bXmC9uAoq0yrLaRQizppnibphvjS2YjHJ+4u6jJ3/ayNxerJzmux1xRZ9h6zLstQ
 CldlO6zfSEEvAjieVnuJ8UeLF30EczdSWkRkPikwS/AHr7RWb0IbBjEatpI1bvBctt0Btzv7rKh
 7zcLxVReiwe4lTEFVJ5kqov6/rCcauevKpsEbAna7fD8g/tJXbucYxUOBv0oYq1ltsrX1ax9AYR
 e5iCNToSh9SG1nAwNlnamLLcEV2RIAgIVZNPsPsGGTL3xGxUE/p+VezcnqzTUhXzR0/iUtTmZDW
 TG5NSuo6hNIRYi8CCJUYKJtkwjDZQniPq7aAJf0Tos/5JBShSvsB6pKetLUDXjnj0hu6Av5eTfq
 GbhR3Y0nWSbXBtpYxbsLR127uXUI3YAEV9b/1nCc=
X-Authority-Analysis: v=2.4 cv=P+QKQCAu c=1 sm=1 tr=0 ts=6a4bbe29 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=vaogVFyGufY-KdNt998A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222
X-Proofpoint-GUID: 8OVVdppZYMPKPmbyjy8RIYPc6fYg7wWB
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0OSBTYWx0ZWRfXy+BVnPM/RP0X
 knYZOq+McfkZ64e82SZByhJa6OW9Qk0rfDaXD48CdvX13JzqhzOwe+KSZnCLIM/zerkXKs8lWn6
 87QjfNNYEVdttFq/8JF9XdvGa1kVBK40Farkol72lO3JUhpVpSG2
X-Proofpoint-ORIG-GUID: 8OVVdppZYMPKPmbyjy8RIYPc6fYg7wWB

On 03/07/2026 11:53, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Medium] The module parameter parsing logic loosely matches string prefixes instead of exact values, mistakenly accepting unintended input.
> - [Low] The Kconfig symbol SCSI_MULTIPATH selects a non-existent symbol LIBMULTIPATH.
> - [Low] The patch includes a non-existent header <linux/multipath.h> and references undefined structures, unconditionally breaking the build.
> - [Low] The debug log message incorrectly states that 'IMPLICIT TPGS' is required, while the code accepts any ALUA TPGS support.
> --
> 

I will address all below.

> commit ad9f5e786299d2bbf9325dfe336051204d3f7369
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: introduce basic SCSI device support
>      
> For a scsi_device to support multipath, introduce structure
> scsi_mpath_device to hold multipath-specific details.
> 
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index c3042393af234..d6c31df454825 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
> [ ... ]
>> @@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
>>   
>>   	  If unsure say N.
>>   
>> +config SCSI_MULTIPATH
>> +	bool "SCSI multipath support (EXPERIMENTAL)"
>> +	depends on SCSI_MOD
>> +	select LIBMULTIPATH
> 
> [Severity: Low]
> Does the config symbol LIBMULTIPATH exist in the tree? Selecting a
> non-existent symbol causes unmet dependency warnings and breaks the
> dependency inheritance chain.
> 
>> +	help
>> +	  This option enables support for native SCSI multipath support for
>> +	  SCSI host.
>> +
>> +	  If unsure say N.
>> +
>>   comment "SCSI support type (disk, tape, CD-ROM)"
>>   	depends on SCSI
> 
> [ ... ]
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> new file mode 100644
>> index 0000000000000..ff37cfdf2f9d1
>> --- /dev/null
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -0,0 +1,146 @@
> [ ... ]
>> +static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
>> +{
>> +	if (!val)
>> +		return -EINVAL;
>> +	if (!strncmp(val, "on", 2))
>> +		scsi_multipath = SCSI_MULTIPATH_ON;
>> +	else if (!strncmp(val, "always", 6))
>> +		scsi_multipath = SCSI_MULTIPATH_ALWAYS;
>> +	else if (!strncmp(val, "off", 3))
>> +		scsi_multipath = SCSI_MULTIPATH_OFF;
> 
> [Severity: Medium]
> Since scsi_multipath_param_set() uses strncmp() with exact lengths, won't it
> silently accept strings like "once" or "office" instead of returning -EINVAL?
> Should this use sysfs_streq() or strcmp() to ensure exact matches?
> 
>> +	else
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
> 
> [ ... ]
> 
>> +int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>> +{
>> +	int ret;
>> +
>> +	if (scsi_multipath == SCSI_MULTIPATH_OFF)
>> +		return 0;
>> +
>> +	if (!scsi_device_tpgs(sdev) && (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
>> +		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
> 
> [Severity: Low]
> This isn't a bug, but the log message says IMPLICIT TPGS is required, while
> the check for scsi_device_tpgs(sdev) accepts any TPGS support (implicit,
> explicit, or both). Could the message be updated to match the check?
> 
>> +		return 0;
>> +	}
>> +
>> +	ret = scsi_multipath_sdev_init(sdev);
>> +	if (ret)
>> +		return ret;
> 
> [ ... ]
> 
>> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
>> new file mode 100644
>> index 0000000000000..d3d410dafd17a
>> --- /dev/null
>> +++ b/include/scsi/scsi_multipath.h
>> @@ -0,0 +1,55 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _SCSI_SCSI_MULTIPATH_H
>> +#define _SCSI_SCSI_MULTIPATH_H
>> +
>> +#include <linux/list.h>
>> +#include <linux/types.h>
>> +#include <linux/rcupdate.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/mutex.h>
>> +#include <linux/blk-mq.h>
>> +#include <linux/multipath.h>
> 
> [Severity: Low]
> Does linux/multipath.h exist in the tree? Including a non-existent header
> will unconditionally break the build for any file including this header.
> 
>> +#include <scsi/scsi.h>
>> +#include <scsi/scsi_cmnd.h>
>> +#include <scsi/scsi_dbg.h>
>> +#include <scsi/scsi_device.h>
>> +#include <scsi/scsi_devinfo.h>
>> +#include <scsi/scsi_driver.h>
>> +
>> +#ifdef CONFIG_SCSI_MULTIPATH
>> +#define SCSI_MPATH_DEVICE_ID_LEN 256
>> +
>> +struct scsi_mpath_device {
>> +	struct mpath_device	mpath_device;
> 
> [Severity: Low]
> Because linux/multipath.h is missing, struct mpath_device is undefined,
> which results in an incomplete type error when CONFIG_SCSI_MULTIPATH is
> enabled. Is there a missing patch series this depends on?
> 
>> +	struct scsi_device 	*sdev;
>> +
>> +	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
>> +};
> 

