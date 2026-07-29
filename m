Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3013547604F;
	Wed, 29 Jul 2026 11:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325326; cv=fail; b=iRqnP7LI02LF5wXmRwWtYMSs9zqwnwtO/2POmWA3VESvvC4K9TNUSPyKjw1+3AzrW5R5apPbjjHa8seWL2kxxYUMKGnUQYA64YrF67AznyUuDVqb4+WstyRPEBB9ZYfEuIm/LSOxvjUhrHNYIB2LwuAcEaoMU7vwTxtic7cgxB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325326; c=relaxed/simple;
	bh=ujUamT1tbgL+XR/6iUfJd1TMkVcvmr+y1nnVSjHy1U8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lQ/EetorNwy5E7kVLmiPK1fLVJJVfkM1RE2bmrmRxnfFR5VXbbfIqJDeXnuFooytFI0Nva1EMNv/QeIf09hn3Ulij5iKxn5LMwuS7Zy7mB50rno8EYD/WYWfNmN5CQ0fOAGgmo/qOqhZ8KtrJcFInBohGk+7/9DUR+D5bGl8MWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gCP311Z2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lIDQuR9W; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gCP311Z2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lIDQuR9W"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T1PTm21752509;
	Wed, 29 Jul 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=csR3V22KHfsJv1en0Rv+jEmFsAWS6x8bRdWFTqh063o=; b=
	gCP311Z286P28CojxTUKZBuBGkb7wZtXXCoY0sA1UDbu5vxWOqcZOI9D5ROCBbJD
	xVXmus/aT4L8JPHCkfxJ/QWl+oMGlh4HIh7vu7F8MebauDsfAdC8vPr+eahdOGsh
	KHZXOS5jsJ5wu045SUdF82U/b4W84KojlWPAZTZt0S/b1YsvQxv4aeEjacZE+vPW
	+5DdWP3mKcK3CZgumKPxK87gd/rDBKlo27ixsqj5CuCI0IF5jj7he2pBoulAKwVb
	5+EnpBUWd2eSuR/7vcsNcFyNU1/Pzje+UiaGoGyXeXhqPlaWVp5hiVbdCBuJeAEH
	d6b3OpF/Sfrlr6UI1keymw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1ddpmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 11:42:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TBZW15038857;
	Wed, 29 Jul 2026 11:42:02 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8jph75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 11:42:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vC2XxW8/1f06Dm+WJN1/UBs3omKYOUcvVUn4hDAv4Z+saGNfSe6sm3CCTd1GcI9IzmfR3nXiJuvQPJ7F148Pd/QBZUP1f/ON8Wgu1XT1QRZNAxTv6vJsyBGKDa6NBJagbP89XGkySUt0iBZoOC8HBcgFv6AzVdE+ud6C+F97rlglceB030lGfvCtT36V5a6ixjLNHlAVhqi4RGKAB6L5EdMaFIVZHZaZkUAVbmTUJyhLeozL4dZQtwxvYon7RAOuvhH207i904MTHmaBHKXFiTkDLhKnIjZL6bZ7vyiCm3MlahHwlYIcA6t/O2+e/u7Zb8FxhjT8iWWH7V3ijlUZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csR3V22KHfsJv1en0Rv+jEmFsAWS6x8bRdWFTqh063o=;
 b=xFzvbFV4YKIwgELa0fvIkPYzx27xXTpb8XFoF/+2u47+Ac1UdW9xvqWoGBTHzJQbiRE5XztPACISyFtYi9fv6ADol+FobLUOZi7LmJMkkwnFJFi71/8v5MHliqyM26tU4PPcfUBDI4VUtNJBHtdiwlBasndl60z8IDFyqCmyN9Na9LKnd1cyobsExckq260wRatlnBMnqDbt2BDW0bcLAFKeijkIlpgsi9W+MYLQBCfjU77nBiVH3hSp8qDpCi+LW4GS1gkmuC0R+XqiLAS1XHKdqcIhBwj1cSCURwetpAR8GlFLnWVeEKamevVr7sR0WlCPDXEoVEy9i75jy3Lsgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csR3V22KHfsJv1en0Rv+jEmFsAWS6x8bRdWFTqh063o=;
 b=lIDQuR9WllcoxJ7hsPwICZ1bP5K7TX0TBbqoAacgqgAaiRiqvGwchQ9bVma/cRXWAhb1I3rBP2uC8HMGtlf0nUWYlVYPoRvUVR98uXhQcg1MjHnjdQ6OhO0ey7dZU/cs+3e3hFh5WUPS7NQuWPIDITXLJ28Ro13UWmqvsdJ3soU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS7PR10MB5926.namprd10.prod.outlook.com (2603:10b6:8:86::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Wed, 29 Jul 2026 11:41:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 11:41:56 +0000
Message-ID: <cef06322-1b59-41b9-b60c-0bd23b9c4905@oracle.com>
Date: Wed, 29 Jul 2026 12:41:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/27] libmultipath: Add path selection support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-4-john.g.garry@oracle.com>
 <20260729113319.E1FBD1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729113319.E1FBD1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS7PR10MB5926:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bf4aef1-2214-4122-da20-08deed666443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|56012099006|4143699003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Typr6Wzd8lD6LECHGlQYTtuir90T5LC8GXEYIoqXo7uHKC0+HWC9OSDO2ZRH/xeluY3ENgKXhDlG+tHfGPAunGfKRB0hP68CbDXuVYdLNUXNCTK0tJWXIba+g4NYPq2HvYGyi9Sk9XOUx1TvH4dmWTjNof8UII4efLj2/ynha0D3kjteJyg6rKAE0QqahbsGrYnrss1Z0+TRDC5t9ijGI3O+zjBlkpK0C+E0pGzD83uUrr0ePloRLZodKhtA4x0P68T0h3ftyzCsoVAAZpVjxfQkSCMrKoHDVp6yNzuXv00CmdTT4C9Dj7vVTpqHNEn6FgDLZ+koyHnQIuHy2VzIV1lb/Jwmm2Z4KOliknBH8/B0aPodlHaL6V6pfWaGOG0QuAzViS0HfwtY4HL4JFbZAS242n8WkixONjEaBKaB4Hqu3qGzWDtWDRXVMUU22gSjHa1dKndr4pNiPHmWkUsnX03ag5nr9OmbszE2izerThRGsIYQI9/cBAheu/iBiw9hHXy5LbbzWa4MLb/iRQRYtsNtz79yDMTq2XpHhZuKXsnqiTvXFtBzpd+CHdE/Gj94ekCMY7wc1Nbr9xokFyLvpE5A3IYB7Y/FkwRd23wBWnLmH5uybGBs9rhxIMznoLH5iOdnR8zOovV1tYugPwvVH8uckV9kSuGsehqfCWLZ3mA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(56012099006)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3M0cFgreUczQ2ZjdGRXS2FFa0JoZzJCYWlEbEVHNE9DOVlRS1dXajhKUCtM?=
 =?utf-8?B?ZHR3R0V6bm5WTjJuaFJyZUlJK2JtaDlMZE1lcGsvL2xyNjUzdzdEaE1aL0ZE?=
 =?utf-8?B?dHNnVi9UWjhORC8wWXU4V0NlaU9hMTYrQXFDaFpDTG9xbnZNOCsyR3c3dmFN?=
 =?utf-8?B?Lzc5RFIyb1RLWCtkR1NqUksvTDJKbFJOOHoyeTc0eVFnd3krSGZqTEoyYS9M?=
 =?utf-8?B?MXhWTjVseE5GR0NtOFBLVmRFUkpEZzJubG9SYUxZYVZmUEcwQ2Uwb1lSSlk3?=
 =?utf-8?B?VFE5NXl1ek54NExnQmJUNXBRSDJtbVRhY3diaXF2OWEvV1hyMklGZzRvRVdV?=
 =?utf-8?B?eVkxYkxRa01Sb21iQXVpcUtUSXBYOXJnV1BvcHZtRzFZYmZFSCtSVXllc2xU?=
 =?utf-8?B?OFBWS0RMTE8wK3dzWlcyNm8zLzFxTUxaS09Md3NqbG1QZlpSc08yOUxNenhC?=
 =?utf-8?B?UFk4b0ZHa0dUZHJtZit3YWx6ZnZ6bm5PTCs4K3cwam85RXJzMHhaR2RsUUV1?=
 =?utf-8?B?SzMrUThwWFpFK3hpa3JKVytGcHM1eEppSUl1NlhhWEJPZ3ZEeVdrNjIrV3ND?=
 =?utf-8?B?YWpTUXFreTRDUUM3WXJyaUNUSkF3VXpDZHJWUFNJUlE4NjRyUDVJOGk0emRn?=
 =?utf-8?B?WlZlQm4zcFNpLytBUnRXeUZVNUxPSHRFUTdiQmJIcm9ya0p1V0Qvc2lLUUxr?=
 =?utf-8?B?MW9ESFhPWVV6cnJYT3ZCR0d1MVlmaGExMUs0cERmS2pndXNLbElzTjJoeVJl?=
 =?utf-8?B?ZGVxcTB2QmdoWjBFTXVaWVl2NldjcnVib2p3RnJaR2hwaWZwUisrTnVHYUF4?=
 =?utf-8?B?alZncEVmenZwZ1dZWElmR2VjSGF3MG8xc2RjWVliaXVRK1BXU01RdC9KdnF0?=
 =?utf-8?B?eTRDSlU1RVNGNUltR1Y1L041SUlFUi9TMCsxTU5KZDcxZmlXZmxJeGJtYnE0?=
 =?utf-8?B?WmxzcGdDMUlocThkUWZlZXVHVk5Oa0VWaVdBYlpBTUhPM2xXQlZNRCtMbXlp?=
 =?utf-8?B?Q1VFanBnTXBWQXF3V09aS0lIbHFTMkZucnlMY0R2ckhoMDI1UzdoempVVW1z?=
 =?utf-8?B?QVp5OWRFVGk3eGVpV1B3SEg1TzdLMWY4R3ExbHNyckg1NkV1aGUrWm5kdVJ1?=
 =?utf-8?B?QitJNEhwVmpSWFFXdzVoem1zVEp3V2NzdEY5emNSMTVVRWQzMCt2VDI2RzB2?=
 =?utf-8?B?QUpGc2hPYVcveklpUlNZbHRRSmQ3dFlZdTh6d1ZOdlR3TERTWWJNemdSaE0w?=
 =?utf-8?B?WGp0eHNJSnFrYm1EL05TYzFqNE5lcVNobXBRUDUxTEwwN2VTRTIxWGRaT05t?=
 =?utf-8?B?eHprZVVHYURsY0JTU1BEOVpIUWc5UjR1c1NFS0lZLzZGdGRnN3lUOGJKUnZx?=
 =?utf-8?B?Q2Rpa2VyNjBPa2pSTmFqL1gvQmJKSUVVVHlaTmxYNGR2VThneHZpcUE5Zy9t?=
 =?utf-8?B?U1Z5OHdUSzVxckswZHB3TmpyeHY1a3RWRFlMZTY0U01XM3p4WVNKcU1MbWF4?=
 =?utf-8?B?NXdqV1hxTkNiK0pIRzNOb2VSNGpHQVE4czYrR2haNzFXQ0JvOHZLTE9XU3o1?=
 =?utf-8?B?QU9DN1VnMHVQb2xwUTc4aFpnaElvN0dGYlR1WjhhNUdVbi9pSW9mS3JrSHZR?=
 =?utf-8?B?L29xR0RYVTdEQWIrVC9uOC9YNUFjcVFlZ1UyaW5iRUVWZmxxZCs4MHIyakhQ?=
 =?utf-8?B?eWFTZkdaWXY4L28yS0pYME9TWFp4UjFHYTE3bVFSeVU4SHlFaEVONlNOZFNy?=
 =?utf-8?B?TnFKOHZ0ME5Tdi8wbXNRbTY0UFJSVldPMFI1TmNiVk16MTNUVFJoZWNWQkhu?=
 =?utf-8?B?UDNOQUFTc0VGTXlRUG56U25xbXoycGZOcjNGc3FFcllHeVdUL2hUQ0JkcnU3?=
 =?utf-8?B?QVR6MHRmTmwzQVFUcHJUOFI3eU16cnd2ZzBqK0hsTGNzdElzVmg5cDBRSUpi?=
 =?utf-8?B?QzJOWjVyM0FoNUY4ZzRNVytWcnZ6Sjh3cmlhei9BRTI0T01yOTNqMmRHV1hT?=
 =?utf-8?B?NG0vOTBRRWcrdDIxWWtXQ0ViS3lTcWpXdmNHRjlEYzdxNis0OFRXUW5QZ2lB?=
 =?utf-8?B?WjI2dENKaXBnQ1IrYmlFSXJXK3FpNGtOTnl4M0t1bmsrSVR5a211Mmk0SGN1?=
 =?utf-8?B?QlZRTUtYZ0IrcHB1M3BrQ3lrYUdaemh6Si9TMXFUc0JuVmxndjAzQ0dZRmRQ?=
 =?utf-8?B?RldDbmE0NjlRZnI2NXBrcVlVU1dDUjdZOXFQNzNKak1wbzN3VXk3eUUra09W?=
 =?utf-8?B?cjRHcUpzNzNCMi9vWCtQTWowR1htYWZvZEpjdXdHV3NZaDJaK0VJTU50dnNI?=
 =?utf-8?B?anBkL3VJbmhFWUVSUG1xdDdqNit1YkYzVXF1anozemxwRGdaUVg5ejAzSjFm?=
 =?utf-8?Q?LHNNF6moBfwp7Ja4=3D?=
X-Exchange-RoutingPolicyChecked:
	I1rb5Jm6pGbhbpz5yggrOTe1H15wxThRl3GJFRCWifivfVIIpCGYEC4oBRxQD7HiRS9o7Rgjj8nsMJmzYSk3Fk0pdMFQxHVjP5IrNoib+EX7Q0aQaF3Ybu6+7ltEMBILJNyb/EgGG1cQ9h68zeIh4lXe0DWYWVSl6HgSctQLIWrNo61538iNKWmNU/IUW3B3VomBcisUwVnX+8AkNcWQyqERO0aDrgOlTArA1AuUxkeZKhYlwRLLzPM9SJSe59b9qNYRXQEDa0d8fSkHYNNpjKnhjtVsWYyU3sPjZdyNxXleK/hTUItKY10REh7WZvDxR2KK4QcjJVr0blIlp95ymw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w3KAmdV30aaMmmphmss5JGLgLHbh5N2GoY9ExgEqAlhOemdshuvYNcdC7fJzakjjUrI0/miSbE9L5zXWTTVwNxROXvLtIzOtsCjX+6GTUE9FuF8JdS43OQ2vey98YmXpIH0HdHe5dexjhWhxjCmLR2mJK+H5EeXConoHKdVrsf1FhUn6Y2LJzo1+TB7iAj0glAl8Mskb1SKAXaiSxnsTzVqIx2ypVoA8KOwPoj3goKBgCwqzaNfYQLJ98a3H6YyIBXMqFAp8yNI49S+Nf71xhm1THKwjcMLdu4VAZFKz73KosOG8E1bKTFeq2nDcbV4jx08C/d7Fg9uW+CewB2ngHua5LvflFAuJgQwZ32MrPlhTgvw2FNlFu9wmoFYVrxTLcLQRPnbxNNOlHjvTiVVsB1zyduSwetnhSjQO+abiTS9qVC2LfAxnRR7LTG3LlKJ5FXSEorOZqP+AL39ltYpFHRRtFFVPiWRjNmBF1trT9FUBJqDBuZxG012wPZv1mVSmSDql4ru8HKb6zGmvnhAKXgXEgRyZ52FwDqVETb+zw6Z03BPGbMHnfUAoue1gCmUSP8MxVcpJeShN0cdgSpuE03S2xXcqVxOSdIlYMAUphCI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf4aef1-2214-4122-da20-08deed666443
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 11:41:56.0628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHbiqh99NdYkzLG7gsCdN9FCSnixJ63fDViT2SR3SKF5zLsf/We168sdZW0tzSLFcncAayjSqj2gSqjc1Xz4+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5926
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=941 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290096
X-Proofpoint-GUID: qalTf5vVLLcj6T3g7AlQ2S0OyLc2pbkA
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a69e70b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=oB9fcY3t8x3pKbLyu8kA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA5NiBTYWx0ZWRfX3OGG/ME7JfCx
 7naarC6RQz1JXOPTL+qqNnkOwNebucIcTKQQO/gxXj6Xu0LNkC6FptAlC4Hbb/VG2dvj+TXjXkg
 29aeO0dxJRyLv+TXICIsa/+pm3lAfyMlHGVb4R18QtMY66CBNAxL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA5NiBTYWx0ZWRfX/aCosvE1mfV+
 f+LzQ0RtzlAz5vvs9MYuLb5zgU2oZmLuda3YR+P9OYat0A9pTr5EAR4YCt+LmiWOLKIcaVF+DDV
 t1UKWHLaAmvAlOGN+ZhQAH79Qt4vCs9fqTUKPf2ZnrIO8JX4vMvYFDwnFOrXKVc27MtJLxE87eu
 5aptGtYdxXvVfyABp7SkxqHWlJCyxAxhMsy6siuthaxgpFd1z0DE+J/EjnISedkeE5M12bpPkOO
 6YbHr5Ivf8DLo9WVKIj/YY1q/6QKDnm6qLNRFfB4JDdL22CaS+OVz4r2gP2qVnV5OULrOhyH32q
 m/H4HQmS5MooexysBgzZDkw79rmp1F5GSTZZVtBIl56w8UjluFu2sXdOcNzpb+ZN8unzd2QyyRo
 7s4qOVZ8/fI6mF8gOZ08mfgNgek/5+XVqRfPbmeNe3AvnAAgIOff9i6gnVaf4eubUr8/glfyNeo
 FwIVcYo3EOsW755SWsDoWxkfzQMr/vLM4eiE8yrw=
X-Proofpoint-ORIG-GUID: qalTf5vVLLcj6T3g7AlQ2S0OyLc2pbkA

On 29/07/2026 12:33, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> New issues:
> - [High] Round-robin path selection behaves as reverse round-robin for non-optimized paths due to a missing loop break.
> - [High] Unsafe and logically flawed use of `list_is_singular` on an RCU-protected list routes I/O to a removed device.
> 
> Pre-existing issues:
> - [High] mpath_head_uninit() blocks indefinitely waiting for user-space to close the block device.
> --
> 
> --- Patch [3]: [PATCH v6 03/27] libmultipath: Add path selection support ---
> commit 70a41be1b0a598af8cbd34732b889f79118d17ac
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add path selection support
> 
> This commit adds code for path selection support in libmultipath. It abstracts
> NVMe ANA into mpath_access_state to allow SCSI ALUA usage and adds round-robin,
> NUMA, and queue-depth selection modes. It also introduces functions to set and
> get the default I/O policy.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 1cf20b0f62d07..26714116023a3 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -7,8 +7,245 @@
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
> 
> [Severity: High]
> Does using list_is_singular() here on an SRCU-protected list introduce a data
> race on head->prev?

locking is added later

> 
> Additionally, if old is concurrently removed and exactly one other active
> device remains in the list, list_is_singular() evaluates to true. Will this
> cause the function to return the unlinked old path instead of the valid
> active path?

as above

> 
>> +		if (mpath_path_is_disabled(mpath_head, old))
>> +			return NULL;
>> +		return old;
>> +	}
>> +
>> +	for (mpath_device = mpath_next_dev(mpath_head, old);
>> +	    mpath_device && mpath_device != old;
>> +	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
>> +
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
>> +		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
>> +			found = mpath_device;
>> +			goto out;
>> +		}
>> +		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
>> +			found = mpath_device;
> 
> [Severity: High]
> For the MPATH_STATE_NONOPTIMIZED case, found is overwritten unconditionally.
> Because there is no loop break or check like if (!found), will this
> evaluate multiple non-optimized paths and incorrectly select the last
> available one rather than the next available one?

I think so, but no one cares about non-optimized. Again, this is same as 
NVMe code.

> 
>> +	}
> 
> [ ... ]
> 
> [Severity: High]
> This is a pre-existing issue, but I noticed a potential problem during
> teardown in mpath_head_uninit():
> 
> lib/multipath.c:mpath_head_uninit() {
>          ...
>          if (!refcount_dec_and_test(refcount))
>                  wait_var_event(refcount, !refcount_read(refcount));
> }
> 
> Since a reference is taken for every user-space open, can wait_var_event()
> block indefinitely if a user process holds the device open while the
> driver is unbound or the device is hot-unplugged?

yes, but that is just the way it is - userspace needs to drop the ref

> 

