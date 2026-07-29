Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4069547D478;
	Wed, 29 Jul 2026 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327317; cv=fail; b=ERstOtOyiglDSliKU7aAd6cL5iK2xh+QPJ4pMCh8ilrzsSnbYGOSBItrjinVO6+MZNlw6yAO8+H6s8n3EhxXbcrd+oKXX2xI6Rhzu4YA8cRX9J5gtEWQTF8Z+TuCYrNEE8H2u1WAEL/4hJID1JfX3a+5AMeyMP5XyRKgGmv9CKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327317; c=relaxed/simple;
	bh=laaFVNlZMA2JQ/qkEV9CeH7oP/qOOcDvFr0YIMjNUCs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FuojWoH+xfw9W8GejFVaXA0HuYRiOWcj5wQ8jNd/aGkb+JiMwnZzaEOY/BGRtU8hAplOLWnd4VUP/oocVgT5Dj21Duesdx7NEPPgH9r2F74PIxRVBpegzsNcexcndRfTe29Xj1DtZaMZ+pNZw2CdPa4S30GlVQD7H9p8xOI4LyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dz9BVN5x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pv2zCuSh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dz9BVN5x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pv2zCuSh"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9GtEX1094297;
	Wed, 29 Jul 2026 12:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ehbZYUgkvc40jyqFWnPxqkTadO8lf4zcVhj0ZjaGgBg=; b=
	dz9BVN5xsTR+gMXdaYeCX10S1JY1QylLts1qVTZ1Q8U9OIVv6Zn9OxkkDPHBzmSd
	jw1SjfIr5Ld/U3h2TOinRVq3lvAju95s06pIHMqniMpBufHaneshCCUQZ0sokvHm
	GQS5Zu7q2fAL3RmxySAiGHtC5sKj7JK2/WLYDZV2DN5sKZ95i84r+4izsit3ddlq
	Fh8kXDPQiEFGH5nlPuVBnA/y5JrjEtu2VWha5s1Rmh8lHFAy3dOyw1D9PwEvaX0Q
	wlVX0As57CgH53eL5k6B8DZEqhUu4ZeD/fb9oioPsxj/R12of4RIlLDMUhBgqXPo
	ZZ13HG0H5G5uWeOQ3w45fg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5pc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 12:15:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TC5b5J014701;
	Wed, 29 Jul 2026 12:15:13 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8jqmfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 12:15:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PNJ81QWZ0gL8sf+MIKatXGIMT1GQtg1jc1P2GiU872zJuKQKx3b0mryIkuh7CUEfa4Fju3I2ebEOlqlVlbJuk5w3NMTamUChdkaoaUOBACRGWFgeg9p00ghZvM5iVVHdSLAr6OtZKfs7ZzzGmbn9p5qVxnvNl+4zL+3d4NGZuquTLsfpE/qtxvxJdD8dODAYW4i+BVt9pjSuzDxWEDKtbT5vUhKulSRlJGDxgm3VzxSFMWakiRfQVrsXcDigec5uJYzBKeF7+EYEdekKZS4mR+jDLmVqD/k0FH9JUabEkn/hkGsvl3FdxvmL98qagxNwe9cw0A2AN/6/CD8Wrb9xAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehbZYUgkvc40jyqFWnPxqkTadO8lf4zcVhj0ZjaGgBg=;
 b=qlMSHmZMcXGJ3MuWAk2fVNpQRgH46uU7djekbZ1dVb8huP3nu392pBXdLJaR0HVYWbpPXLrFHlVI7jg6BlzlSfHgsQ7V1dPOB+r9mTg7AbHVbUEJ9amPRhrLgpwyFaycPbuH3fy55nesRDYl1YuwFc92D5A6vfKaH8uWr32yMA23Un+OM1XwHMU5EE/KHjx7ttfCcSmVsmxIisU6sfWNoHdNvNLGFbI+y1fIdUmKXfH7ZQ2oVGwalXGTJ90Y0Y9pu2y5gdbBNVQNh/RZk+vgYeAa7G2hhrhA9DdMa9GOgakNxlDacqiZB9bibGKxlu9yeh97Qfpqn5jGZByXdf02GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehbZYUgkvc40jyqFWnPxqkTadO8lf4zcVhj0ZjaGgBg=;
 b=pv2zCuSh9TEbpaKc1PWuzTXoFZBxvTH4B8O+z8wR+o+WrHtqzF8qDHh6p0AmUzovR8J3FiZODiWhfdOcGkxSkJ/O0b/KPe6xXFilM6rqjfztARcMTupPQcnLZ/j6H+gfv3h4au+g2SHIZTjAoONpBeOLmdreSAD+Ex2/nLFR7KY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA0PR10MB7160.namprd10.prod.outlook.com (2603:10b6:208:409::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 12:15:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 12:15:06 +0000
Message-ID: <b9e1fe6b-3d89-4e4c-99d2-bfda982243f3@oracle.com>
Date: Wed, 29 Jul 2026 13:15:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/27] libmultipath: Add delayed removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-7-john.g.garry@oracle.com>
 <20260729120812.555561F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729120812.555561F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0061.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA0PR10MB7160:EE_
X-MS-Office365-Filtering-Correlation-Id: d107899c-df40-4175-2bbd-08deed6b0672
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10063799003|10067099003|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5LGO5zXeDd+NzWpO7Xa5PMdFY8UCzPqDZ5kbS9c4lA8cOhl1iQhIDKepgVCPlMoQ6kH5dDRxKzvJwbU1s1Hsb22jduwZdyqMwFyDchuMy3DGSTG1NDZEkHVfA6hUxIThi007Bq54UR94XQndSujSBNtg2/xW7qmQr0gt8cdPHuKg2PR9j6pC8ISebzJFZqES6XojrwprzrwnqmYQfU/r96eYiR+djL3MsTndjyEfjaIddu4QlQkh6WviJlCWEyjyOFOgL9aaiM59IlvgyoOyq/B/fQ229CW5Y3tqiQWE37RFlMSfY/eFPysxuhL3IPdlQ1eoWCy9KFp0347I6usm3ED3c6w7zazexf4RFlkjEdFOWwakq9noATPbeME+Cu/Yjn22me49cBnKGUnhvWs4d/yTPAaJ3Be0Q10NSzuuL7Q9MrqYu78v7HobBN0g3f332G4WvACW9P+KQrZqetTMnawjLbI3iauyBycVgL9ST3KZxsBEYVRsnOEisJ81xyyWTQd3RLyN4hgm9gh77A0qdU1upuxTtWNOjZnnOkGy8PL4PNPSGr8KoUElVgdCg0dWPEFvARcT5wRj7GlbriGScHxF4J0VIAFR3KArwvoA8BFTKP9VsdtmaFgIthU8+aAlxW1hSdGf8zTqk5MrUJYrM95L+z6kCkTYirpz0oaQTzo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10063799003)(10067099003)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T05kQU9yOEFRUmxYbEdZMFY2YkUrN2pzWHBXVC9keitqNEc3MVFTQWdyQWpS?=
 =?utf-8?B?bjVNQm11cDV2TElMbW1XRG4xdENqTzBFdGk5SFZqaWRHZlNtWWNQWWc3b21N?=
 =?utf-8?B?SDAvV2VlV3h0WVRlRWVXZktwSm44aFJ6b2I5bXhEV3k5VmE4RlZXWFdSaWZF?=
 =?utf-8?B?NmxpUitGZEticWVHRUhCRVRZZ3VUZWVYS3BiMVhsZmVhU2xWNUZHVjhkaTZn?=
 =?utf-8?B?YmRTT2UremwzK09JcHNNMllma20wTlUrclhZSmxwTHBRVlNVallJdW43NXVj?=
 =?utf-8?B?S3pOOFp0M2gzRVpWUEhyMGlHZVFmaWQ4S0p3TXBwMW5WaUlJNTR2TExCRy9B?=
 =?utf-8?B?UnlXanpxQmhRRG1hQi8ycmVaWlFtWnk4dmpuSWpxT3hWbDg1OGQrMzVqRnlE?=
 =?utf-8?B?dHpsMVFTVkhBd3krZ3BrdzFYZzdzT09ENXhrblE0UEdycFBRTFRnRkJHZTIw?=
 =?utf-8?B?dEd3ODJWTkx1MmIzdGZhbWpKbjNjcUg1a0laTTl3em9rTi8reFRFelZBVzdn?=
 =?utf-8?B?YzJNYVRreDYwWmZTLzhpdCtlQ3BFcGRWQUFHNDFDZXlBcjBOS0Y2VmhhRUdU?=
 =?utf-8?B?VHlEZXVkKzlVQVVGckxYbDhpc0h6Z2NUMU9RN24yYjZ4a21HQjI0VXp3ZGJ3?=
 =?utf-8?B?Mzdtd3h0WXFZblU0b3pMaWVrRXJPL0dSYjJTWHlXZWR4aEd5dFRnMXRQbFFU?=
 =?utf-8?B?dnAyMVNuem9HZDdTWWEyTjRmVjc1OVJITXJpYmJRd1BkbUVPTWpDdnQ3b2Rw?=
 =?utf-8?B?MUd5YXU3aWpKZDRIZWdSSE8zb3NGSkF1cE1iQXhBK2ZpSmRHaThNaytOUHg0?=
 =?utf-8?B?RXBzZmw5d25QcCtLVHV2RHdDU25kbUZPV1EvdlB2d2Y1YmYxMGpFNkRjM2dD?=
 =?utf-8?B?U0hsWlBmS3RWOS9aY3NOdWJzbEVOTzlpNmxxOGJGRnB6YU1lSXFjeU1DWjZp?=
 =?utf-8?B?aXM5TmlpMUJMZFNsQ3dkTDVTajJVMnhwSlVWa2szaURmbUptS0NaZnJxZ2Jv?=
 =?utf-8?B?VkZUdDdxeE5iQ2tuby9TcE5FcjNMNXRVZ09JVmpwQnNTdHNZUVpqcTMxbGFG?=
 =?utf-8?B?Uk81QmRKekcramlQaTRzUEFCbGFodUZmb2pvVEtVeTZSNFBYY1kyRVVBandy?=
 =?utf-8?B?WTBha0xwcFg1bEw2QnNQaUIvQ2dMT1BBTWt4anZJM09xNlFORFpoQllHNE5Y?=
 =?utf-8?B?SHZCSlIySHF5SS9OTlVFeVBWMThtUVJHMjZSb0lldUlZUGtnamlSUms0Rnh5?=
 =?utf-8?B?MmYyQTdydEZQaUdkQ0xEM2hXT2ZDeitRVkw1UEx0UllMNkxhSyt2Z2FSRXc0?=
 =?utf-8?B?ZSt3bFh4N3hySms0TEZUb0F2SHRWa3B2ZUdIWjF4T3FuVTV3T0RvbjVxWGtj?=
 =?utf-8?B?Q1RZSkE1MWtaTDE1Mi9SbVZXYmFaTVZ1OW9hV0x6aUR1emNSRVpwQmVjR0FU?=
 =?utf-8?B?U25ZQlg2MW12eU5qYWFCaU9YNTk3dDVTME9oaWFDYTE2LzRGUUEyRFFQM1RG?=
 =?utf-8?B?ZWVZa0FTWXRobUM2dWFqc3NPckwvTkpCelYxUGRpVGhrODdWQ3lxSUIvWElq?=
 =?utf-8?B?ZjFLdVVyU3lQT2Q4K1JTRXlLeHNCZFQrR0k1UzBxcUswMmNvV2o4eXdrWC85?=
 =?utf-8?B?bjdrdFJsTloxN2tQRzh6K3dKMmlrOVo3d1U3dC9FMEhGcklkR2MxY2pxT3N4?=
 =?utf-8?B?YU1IVVJkZ2FmTXp2YnNOelQ3aDZpN0xJUGpia1lFbHRVemhIY3U1V1lvODhZ?=
 =?utf-8?B?WituYkczYkEzaEVWOFdNMHNJM1RzakdNUTRlbjh3Qnd3czB4c2VITk00TU5L?=
 =?utf-8?B?dm5sOUhEV2xiaTM5MmZmekdWc2JXNDJoZXduakdrM0QrcC94b01MS1RuT0ZW?=
 =?utf-8?B?azFxdFlFanZ2YnpjZ0NIdHpMZVRjdjBwZHZyZHRRNnVQUkplM2VFOXgwMW1r?=
 =?utf-8?B?Mml3VStmamFnSzhLcEtOa1lCRXFmeDFVOUNqVGdmeVpmcitISDIwQnQ2YTVQ?=
 =?utf-8?B?L21EMlEvekxPUWJOQ1pzVFRnTkg4dmUrSnVOTmNEWVovV3k3RlJQd0txczJ2?=
 =?utf-8?B?OE93SzVLSi8vaFRSRzgxejdpY2czZVlEWm1VODJGZjJlTndhR1kwR2dzdG9K?=
 =?utf-8?B?S1VHaGdiL0lIN2theTh1WHpyY01OMTU5bktYQWowTXl3ZG5SMkx1T3UwZnlQ?=
 =?utf-8?B?SUZJd3czanoxcE1YMHV5N0lFL24vUllFblAyOUdaUlhQQUxxZzFxQnJBR2tw?=
 =?utf-8?B?VDNtNEdxb2xwbG53R1JlOGYvL3VsYmozeDRILzhQdXZQTWtvQXRaUVlUTlM2?=
 =?utf-8?B?Z0gxcnNKK0YvK0ltVmUvZnozN0MwSERxOHNnN0FQL0ZpcmhscEdqbWhxa3Bh?=
 =?utf-8?Q?IbnBhQJAVfAxTckk=3D?=
X-Exchange-RoutingPolicyChecked:
	P3VDSyYIQcl7+egBYCAhwnPSMfTM+94nFh91sub3Jg+rlBrteYOsK3hpi8H+8xHpEkqT8I8+qcIXyemhp9mCkx9VgySXAq5Ke2GB1QaWRyvSp34C40J5cf+rClJfb8D0PB7mrh7YjSj/a37RVwR8gTdgKY5t0m0F3X7009PHBRTqWvYcIuNfjTgj/NBEf7koN/N6DCm6wwAhkj9oaHHVeSsBa67WASA46SBbRjE/8qbohsOjcMwvrNFdQ3YgAd24KCmqP9bYlke3/8uawMXAoUnhHpxHiIcj+IYlOE7E3h+SHwAie/2dycdD9s1cR9p/BNLYCLpnbJu0fYtDZnQZzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vbLdKLmOp0P93h/+h8HdLLLhsgU2O2HTtsUr+8qzObS+TpwCR91hQcGxUAzycFEzUNCreaN01OTk/5vY7dw+42GbdFKNPV2wrOj+5aeP7KZmt24a6QVoKMsfk67TKNcBnv9pH+mc5l0UDjqamUyr20SL30+Ggh+pecIzjGcpw+GNZdvaB1tss8f+kdieYPQenl193SZkL9AHxcJxkCsm1WjLJqp7NnptgqluQsyNkG687Oljf/WCgRHP9tTgUk3qYEd4lcSUixMwtwhTC2+1iTy9HXba+GuFxNQg4VLZdlV4W5tvkTF05RdTKEBBnn+Lx3/9Buo/zZCRSRhJgwRlpdXXHviONp+JrR+96Qvi6PFnOay3kl9jMJ+r0gyd2agEISpUz1gG3lznZR8dgckCtWmjxvqntpuzZ5SEIBIwXRZNVC5fqi7DWxonbFhWeuxQwxmmyut+KZOIwntYp5dD6kY6tQcS6gwAXASfAy7NQjamLkyLrvpnzlqTyprZUgnGIAYPuvN8W+rcHmHZfoMKxrPcaldu0JeTs6JSQry6YgpqKoQhs/Oimq5Nac0AvE5T7nZP2h/E58FEsv3ruyQhsE7o2xmkBEKRB2mFg8xKS1E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d107899c-df40-4175-2bbd-08deed6b0672
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 12:15:06.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUojOJXQbzOJonVvptZhtpDWj1qkVO3r4UCe6qhVsimV8OE9thesiAH/nhLLAI/wIAMfxj3RjgkBTprMEXn25A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7160
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290100
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEwMSBTYWx0ZWRfXyfaJzdrxD4LP
 QyuqKDNGmjkZl3UeKeFW/Lyz8R732ycO+1PHRIvWXshVtcUclkxis/Xi7zdNHGPLvmzeoxp780Q
 HwE9+roZ93w6Ry4r4KsA6sBnN5FXXGj0QbzHwRCG865r6Xyv543e
X-Proofpoint-ORIG-GUID: bm6v4pU6Oq8zCLRg3cblHyrWrdr49Sgk
X-Proofpoint-GUID: bm6v4pU6Oq8zCLRg3cblHyrWrdr49Sgk
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69eed1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=09DICs3yVDFeWIhthtIA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEwMSBTYWx0ZWRfX0Spqv/SRktmr
 v0ty611YP4P2CbpefObKnZnTufCUgQZooL+tAVtsj/OHotUEJW0F56oZSbQFGGVwygadtkAwMKx
 JzvcHgMdCcNPYkbUWsa9cABK+Z28dpJyTNzizzNZt2roaaGBDwD9Tx8wCu1DSbmKpuNL8fxj7+R
 4Byrxp89rLN8uO25dDd9IjWy0yjkw0chVkPlHbkDzH+lFIyRPTuo+8fatL/HelORfn1ClXMFDaT
 P1y4AlDS1VCpSNG/y6/WMf9B4ZgfMFAJoBrzbn4sUb+iQWcRazUN5k+Kbyt8yTzkcn2Ou217gin
 J8VP231FvnDLKghljZriuZUN7pb1CGu2js3DGJuth9zRAR58oH/p4SMvXx/wa0s37vTc5py2I76
 uCEJ+I0XE9BfFu0zXTPzLZ4IJutRlnP9W+/DtseTyiXyJxE1AGwEbB2G8LpsxEvVNGSsTmSsRGK
 oFTPJTVXeHNxaTjf57AGl7w9bZIWvyXEW8oLhoYw=

On 29/07/2026 13:08, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] mpath_remove_head_work() unconditionally removes the multipath head without verifying if paths have been concurrently added, leading to destruction of an active device.
> - [High] Missing cancellation of remove_work during multipath head teardown leads to a use-after-free when the delayed work expires.
> - [High] mpath_head->drv_module is never initialized, leading to silent failures or crashes on module unload.
> - [High] Disabling delayed removal via sysfs leaves queued I/Os stuck indefinitely.
> - [Medium] Module reference count leak when mpath_can_remove_head() is called multiple times.
> - [Medium] Large delayed removal values cause immediate removal instead of a long delay.
> --
> 
> --- Patch [6]: [PATCH v6 06/27] libmultipath: Add delayed removal support ---
> commit 87d6b13fc148098f06b11013c5f12523eb0d477f
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add delayed removal support
> 
> Add support for delayed removal, same as exists for NVMe, to keep the
> multipath disk and cdev present for intermittent periods of no available
> path.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 6b8f6e846987a..fada92bf9754c 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -66,6 +66,9 @@ int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
>>   	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>>   	mutex_unlock(&mpath_head->lock);
>>   
>> +	if (cancel_delayed_work(&mpath_head->remove_work))
>> +		module_put(mpath_head->drv_module);
>> +
>>   	return 0;
>>   }
> 
> [Severity: High]
> Can this race with the removal work?
> 
> If the delayed work is already executing, cancel_delayed_work() returns
> false, but mpath_add_device() still returns success. Meanwhile, could
> mpath_remove_head_work() execute without taking mpath_head->lock or
> verifying if the device list is empty, unintentionally destroying the
> multipath head while the driver believes a new path was successfully
> added?
> 

the removal callback should take care of this


> [ ... ]
> 
>> @@ -481,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
>>   	}
>>   }
>>   
>> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
>> +{
>> +	unsigned long delay;
>> +	bool remove = false;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	/*
>> +	 * Ensure that no one could remove this module while the head
>> +	 * remove work is pending.
>> +	 */
>> +	if (mpath_head_queue_if_no_path(mpath_head) &&
>> +	    !check_mul_overflow(mpath_head->delayed_removal_secs, HZ, &delay) &&
> 
> [Severity: Medium]
> What happens if a user configures a very large delayed removal value?
> 
> If check_mul_overflow() detects an overflow (e.g., on 32-bit systems where
> a large sysfs input overflows unsigned long), it fails the condition and
> falls through to the else block, setting remove = true. Does this cause an
> immediate teardown instead of clamping the delay to a maximum value?

yes, so don't use a silly big value

> 
>> +	    try_module_get(mpath_head->drv_module)) {
>> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
> 
> [Severity: Medium]
> Could this lead to a module reference leak?
> 
> If mod_delayed_work() returns true (meaning the work was already pending
> and its timer was just modified), it doesn't queue a new work item.
> Since try_module_get() was called unconditionally beforehand, and the
> work callback only drops one module reference, do subsequent calls to
> mpath_can_remove_head() leak a module reference permanently?

it should not happen - that is the job of the caller to ensure

> 
>> +	} else {
>> +		remove = true;
>> +	}
>> +
>> +	mutex_unlock(&mpath_head->lock);
>> +	return remove;
>> +}
> 
> [ ... ]
> 
>> @@ -529,6 +574,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>>   	mpath_head->disk->private_data = mpath_head;
>>   	mpath_head->disk->fops = &mpath_ops;
>>   
>> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
>> +	mpath_head->delayed_removal_secs = 0;
>> +
> 
> [Severity: High]
> Is drv_module properly initialized anywhere?

yes

> 
> It seems drv_module is added to struct mpath_head but never assigned in
> mpath_alloc_head_disk() or elsewhere in this patch. If it defaults to
> NULL, try_module_get(NULL) succeeds but pins no module. Could this allow
> the driver to unload while the delayed work is still pending, leading to
> a kernel panic when the timer fires?
> 
> [Severity: High]
> Is the remove_work guaranteed to be cancelled during object teardown?

it must be assigned

> 
> The standard teardown sequence calls mpath_put_disk() and
> mpath_head_uninit(). If cancel_delayed_work_sync(&mpath_head->remove_work)
> is omitted during teardown, could the timer remain active on the
> workqueue and execute on the freed mpath_head structure later?
> 
>>   	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
>>   
>>   	return 0;
> 
> [ ... ]
> 
>> @@ -572,6 +620,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_device_set_live);
>>   
>> +ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
>> +					char *buf)
>> +{
>> +	int ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
>> +	mutex_unlock(&mpath_head->lock);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
>> +
>> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
>> +			const char *buf, size_t count)
>> +{
>> +	unsigned int sec;
>> +	ssize_t ret;
>> +
>> +	ret = kstrtouint(buf, 0, &sec);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	mpath_head->delayed_removal_secs = sec;
>> +	if (sec)
>> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	else
>> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	mutex_unlock(&mpath_head->lock);
>> +
>> +	/*
>> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
>> +	 * by its reader.
>> +	 */
>> +	mpath_synchronize(mpath_head);
>> +
>> +	return count;
>> +}
> 
> [Severity: High]
> If a user disables delayed removal by setting delayed_removal_secs to 0 via
> sysfs while paths are missing, how do pending I/Os get handled?
> 
> We clear the flag and call mpath_synchronize(), but shouldn't we also
> call mpath_schedule_requeue_work() here to flush and fail the I/Os that
> are already parked in mpath_head->requeue_list?

I don't see how this is related to requeue work

> 

