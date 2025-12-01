Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B39247280;
	Mon,  1 Dec 2025 11:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764587891; cv=fail; b=doQucKkZS901L1qtORyFz+TxRunwJ/f0piuj773C669A48y5awMHAZSvsoMMZ7NgWCn+r/o2IeZymSEhHXmV1Q2mYBgYTPI3yHzEKK9ddxcZkhcOw8ebxg2m4x9IVf3FfN6SiBchPtx98h2vZdqeHH1G3yNdVp6p0ZYXSSJX7BM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764587891; c=relaxed/simple;
	bh=DGAUuPErJB4TsuApkQoLYco1V7IQgnEqrHHBYXjI3qM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uFbQMgOBjIYC5Eisk4DyxhybiNzDIbF2gG77/54dtGsj6D2RhRTa3//eOvbcvEuRaeE6zPnqTbhY57bUUqYvTvOnWe/NXL2Xou2f+4RunuJtbodtuSpD7kzgzS6/qsrbLynFpzLlCvRmYCz/ewDKMgPRdSJSmU8uoS/8TklX6is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kkgbIJSM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mtGtT1+c; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kkgbIJSM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mtGtT1+c"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B16NN0r1473754;
	Mon, 1 Dec 2025 11:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Lpm4pR7Y5hdlkf0V7lPD8pSXvRXZpHbRq78dcLHbh4I=; b=
	kkgbIJSMG5RAjetm07IaG1lqtIlSQV4hR0JRdRG/kUn1J5uaCWKDua7SAOnlSo+X
	mNisfoKKj2V4b+dNbEEqPOK7aiFr8W6oXc3dBMj9zB7PHanjt+8rkmY//f9Y+Oz7
	cX8RWgZLXzFP0IqU43maCfUphVhKoUV6antbUe8J922mOjpE4jV3NkjyzOrguwpM
	sXg0l5ny5TjCmjXprg3Y/hKa4pwJeW4QMIET5ZdBULXJE2G80JSNQ0RUMtlDuqtt
	6EgDkn9jjmnRbP7Dh+2XgZHkv94thGiyZO/2Ac3gA3VBYH98qrWXLDplDZOYLh+h
	B8lzA9d07ZbfuYS7LIpqtg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqrvc2b3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 11:18:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B19RECu017569;
	Mon, 1 Dec 2025 11:18:07 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9hvws5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 11:18:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMlulisv/JULkPKg1xSL7nVjHyjZHfuVEwPxPzG4TmCyaOOI/iMKP4/QoA6JcQeRlLkuX2uVryfg6LN+qGjuxc3OJ77LjuNYB2rnaOAgZjWvtOvmeXpCPvKd2HHjNcYf5JpmDO7fK4TNGT6fvQ2JrebG4SptCgHtaeLbOtmCHfanqBmIdkqAcY5/Woz91rNmB0R76ACyMRf2cgxQ53m+isZiJKMrSDHZ3VS1r0aHSZohgCe+dTjGURJ/4eYFskOuZ/F0roh7kHNaJeU4fnL3/nhtbeCwVoB4zUVrdgl7/6tFs5IkM5TOZRTFbiNlogckZ/apiRxYHy0BtDCiBwpiMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lpm4pR7Y5hdlkf0V7lPD8pSXvRXZpHbRq78dcLHbh4I=;
 b=MzpdphQfUjht4o+KCDbvP47BKw/6R5qpZ2fdmrd8stBmOiBC7CNBK3+whNi/ZwpxXUPE/q7v6VM28npUDiRSB2OXoula5qwuDM2+hGUSsQelDWrvAmNbaQsBXfhFrnaeb0U3C/dI81+92TI5GvAdwQ/xbNlnzRqez513a5WbLILKkFo1JkNHU9VD8EhK7WjTCoYbQGF7QK56yTUsJe91mWdtATnNPIewPe1Ct9PKWDstS6RsfHFKvS4B6349c1U6XBBkllo9uynRoaE5KuPQExu+PGGEAXt3AoIW6r5qgbWfox1QaLpG4pJLVSghD6iuDtkL9x8yK/V16NnkNN90kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpm4pR7Y5hdlkf0V7lPD8pSXvRXZpHbRq78dcLHbh4I=;
 b=mtGtT1+cAThidWhmpjC6PU1adk4E3ZiQGyKrZpuQpQDCU4lHZRuUHo3V+sKRgAWb2//xzJabtPys1dootnBqTaLD3oV22lSkBpL7yDXfnlCE7c5qa79xic18OynB77UDQq4Nlaf0zYZrd+VDeuax+zIxeg5L5kjxQsSQkeMpN0Y=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MW4PR10MB6533.namprd10.prod.outlook.com
 (2603:10b6:303:21b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.10; Mon, 1 Dec
 2025 11:18:05 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088%8]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 11:18:05 +0000
Message-ID: <5f51e632-494a-4ed7-b352-644552224b90@oracle.com>
Date: Mon, 1 Dec 2025 11:18:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFYING_INFORMATION
To: Gulam Mohamed <gulam.mohamed@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20251201110716.227588-1-gulam.mohamed@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251201110716.227588-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0152.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::13) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MW4PR10MB6533:EE_
X-MS-Office365-Filtering-Correlation-Id: 0683f348-c521-46a6-0cfc-08de30cb4c54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MldRTkR0SGd5QkNkUjJ6TDNIcWNKMURUcmJzNkthZnBXUjJQTHdpcXgzampx?=
 =?utf-8?B?alZweUtUL05wSmM2ZTJKR3l2djRwem56ZytZY0JIbm9IVFQ2Rmw0TmdQTlgx?=
 =?utf-8?B?UnhVeUcxbUVzdXlZKzFLZnk2b1ZUa1NXSXlLUzVZWWo1UnZPQVRLZG9PcHlr?=
 =?utf-8?B?ZEFQcnhTTk94S0FHVllPYk1vRVRrLzJ6SC9qQk01MXgyTkh1OGVIVWlyU04v?=
 =?utf-8?B?aUhHU1BIaUloWnhCd1VqamZGeFRLOXNlSlNuQVo3YjljQjJjSFNDdEZZR3hS?=
 =?utf-8?B?THNNSUVYeHlaNmRRYWcvRUJpK2FhcDFhL0VERDZtYjJUUHF1aTJLMmNDdDZ1?=
 =?utf-8?B?bGZXam5IM0NnNzZ0TnVJWG9CbVY5MkpVZTFHYSt3cjZvbVVZZE04U0ZlWFdC?=
 =?utf-8?B?TkFRQUt3RDBEdG9QdU5XNmU2a2U4WDNuYU95STB6aGhqYkEyYkh5aU5jY2gy?=
 =?utf-8?B?emhUM0FEVGJCZUpYQ0NmM005Tk5lWFVLYVZtYUZ4eW1vV3pITWtkRTBnN0JI?=
 =?utf-8?B?ZkFYYWVxR3kxK25RUWRFL2hoSXBocDJXZlVQSmFHUXJ2U1pCbFZVelYwTVNF?=
 =?utf-8?B?cDVaYlY3YlJacEdWeUI2dTNsL0tXckJuNDRxMjVBNTdLRGJGYVBUL2tibmEw?=
 =?utf-8?B?SXN5blVFcUs3UVNzK0FYaUpmNFFQY21JbXhlYWhnczJUODVvZDNiM0hvV0d4?=
 =?utf-8?B?aEV6aHJvYXZKMTJ4VmpxZVoyb3lOWUhsTHNacis3WjV5cEljL0tDRE00TU03?=
 =?utf-8?B?eUtiNm1qMzUxOVZTbzdGWFZNQ2FzaDVLZzZySktNQ2FBRFhleEVGQVpzTE83?=
 =?utf-8?B?VWtUZmczTTI1TnJrTE5peW1pYkxRSzExZkZ1QVZzRlpTalMvYXVNMGJ3UnlE?=
 =?utf-8?B?aEp6Yk9ObHZ0Q2pPNHNHT0gzZ0J6OWY0a0NRY3BYQ0k4dGszdlZLZWNUeDRt?=
 =?utf-8?B?dGlsTkJpbGRRaGxrc1U0bmpuNmZoUEFuTTIvYUsrUzM4bkVnT2hoQ1N6M0ZK?=
 =?utf-8?B?V2RuakZIMTlkcUZLeGVaekdsNGpmdCsrYnNUbjZ5azVHNVBqUXMrWjV4UGZJ?=
 =?utf-8?B?N2FHNlREV2twelFieW5yQk1nWHR6TTJNcTRJdm1JK2NUYnovMDA2M1FxbVlW?=
 =?utf-8?B?VHNucWdseUNEclBaN1RkM05TRVFpU3BOY3JtSndmT01SR0RUb1lPME00aldx?=
 =?utf-8?B?cWhuNmNjb1RqQVA4SnAyTXZmcmdPMHR5WS9hd0czZkNUTEZKTFV3VC9FK2lN?=
 =?utf-8?B?QlErYVhFenhkakdKWCtOeE1Yd29OM3FubzlNeHpaSXJBYVRtVy9Ucnkxenhl?=
 =?utf-8?B?dS9ydGJpeVV2ZnVwaHZwYU5ScnFJWDVmajVFOFVqM25XZ1JCUWd1dVlqMjF1?=
 =?utf-8?B?WEIwdWlhYm9JVVljMXcxalgweG9LZ0srY2wzSWRWWjlIajZVWDZ3ZUJhU0dX?=
 =?utf-8?B?OXNxakYybkZNNU9pQk9kbE5QazdoODRmamp0YUY4Nm5LNkp0d1hnMEhjckZY?=
 =?utf-8?B?YjZJUTg3eTg0RFZVR2lTRi81SEEyOW9vb250anRvZ3RUd2pMeGZJUEsvUkhk?=
 =?utf-8?B?UDVhYjlUcnJGWG8rc0EvSU85aUsvNC9ZZEtWemllcDVMeGtYMzNvZGRGbkk4?=
 =?utf-8?B?a2ozaktxUE1XajdiUUMzNzBOWHN3alhkemIzbnR5WDNVZFA0MHVTaVJ3NUlr?=
 =?utf-8?B?eEo4SDY0UlYyLzFQYmcyRlRUMFYzd21XMVZkeEREMitrLzY1QlFRb3FkMGkx?=
 =?utf-8?B?eHBlV29Vdms5MVdUK0NVNy91amo3YlZzdms1M3g3dlZFSHFnL3k5TTBKRzll?=
 =?utf-8?B?MmlaNVp4Qk43c2lvcGJFSGdsYXFaSkhHVHJ2U2FqdXhsUmNXbCs1a3VMUFlD?=
 =?utf-8?B?VGFCbzYyQXB4UXk3NWQrRTJnNnliYWhSeS9uRy92ZFl6MzJjUnpXV084dnF4?=
 =?utf-8?Q?lzfbU6IwFEpaIaKJx3I+Y7cuPXnZcIpu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVkzazFtemVnZlU4V3hjYXJoeUVRc1JRY0tTYjV0akdDTDdIOE9UQmxMVkZR?=
 =?utf-8?B?SmcvVCs1aDhFQTBROFZuR0U1RURGd1NKL1lDSUI2a3dZeHlJczdNOHhxOUxm?=
 =?utf-8?B?Mk9UQ0pCaUx5aDRMaGNncEJoK3dXa1hWTUVvZXh4MURHK3lGb3l4Q3EybDFn?=
 =?utf-8?B?bGlUd21wMVV0U3RBc0x2cHJ2MjBweVExOXlJa29oNW5qa3g1NEMwQWFJWkhN?=
 =?utf-8?B?MEZiRm5qdWRqZE9qS2ttWFUzYmM5UWwvRjFBMnhlUzZXeUdYTEE4YnVNdWtY?=
 =?utf-8?B?RFRGaDJTdnl0RDNPc3o4UGhmMnNqa3c3WW9WeHhyc3VBSGJHTGx1Q3lhWDF3?=
 =?utf-8?B?am5wVmllWTNlRnJUeTgwQzZwMFIwWC9NMXhESXN0aWVoRjVyNjlXWjRwMytq?=
 =?utf-8?B?Vk9DZllrRUpFMDdGQ3JiSWFqcG1HVW15aHdUR2lRbTRaVTdKY3JZN3VXRnIv?=
 =?utf-8?B?Y3pnY1hzVklvcFhLY2s1ZHRyeGZTRzdtLyt4aDVhcnpQSDlFQTc5RVg4WW1s?=
 =?utf-8?B?TmNMV3ZhclZheFYwU0QwWWgrNUE0czlQa0hkNEpHSWpOM1dSZGRXUHBPdEhn?=
 =?utf-8?B?ajQzdTArRVYxUU85SFBMVzhPMHFpbFhEUk03MXo2enNBOGdMQ256NW91TG1l?=
 =?utf-8?B?R2hPWjhGeENpWjdvUUhCb0ZJSGFmY2RRUThuVkxiYTY4Q1RyWjV4dnJ3WlBT?=
 =?utf-8?B?eWNLTDlrSENKdXRGVmt4SlNrYU9WeWphL1l5VGtDbzZPZkFreUdPNWZMNktR?=
 =?utf-8?B?MWQ1UmV4VTZiTEpML095bFFhZXBOZDVvc01zUVNQRDZ1TFJ4YUs4Q0RyYjJW?=
 =?utf-8?B?alpmS285OW9naVJMQ08yUk9oMlZIVXlrV2h6T1JtVDBnYzdvTzVuOVdkY2M2?=
 =?utf-8?B?RmNOU250djJhQnNnQUJjeVpJcUNITU9qZUN5c0NJaEordFFNYld4TnMzYVY3?=
 =?utf-8?B?SE9pQmVZVEtDMnRzS1JYdm5iWDZSMzZmaFVnVTB2YVl2Z0sxOEQ2SkVqZHNX?=
 =?utf-8?B?czlGYkdpQno2MkdVV1NlcWZyUjE2S0N0MzA0bkVkUm5QVngyUlZMNVhueUg0?=
 =?utf-8?B?RTgxbHJpRWYzcUNRVlg1YkRSOW82RUdhZlZrUUNsYmx4NW1ObDIxYk02c3dH?=
 =?utf-8?B?OEt0OVJQdzQ0UE5oQ1RHNWlJTVBJcjNkOFI5TkVFVi95dTA0T0piOTQya0or?=
 =?utf-8?B?R3N4blJRaEZOaVlHUGZSQjFVd09Mem9yQkVKRVFkL2lCYVEyMUVCL25yN3Uy?=
 =?utf-8?B?bjlWQkJ2T2dlTm9LblVHK3BKYldxUjZvWm1wb01iZ2JFM005dkdtWXhUUEtv?=
 =?utf-8?B?TVlaZnNmVEh4eHQ4UU93UFVGMUZ5d28vK0dZc043Q2hnU0psU2xZZ0U0QXNB?=
 =?utf-8?B?TmhPcEhJdXo4YUhJcWY1S2RYQTE3b0liREJ4OUxXa1kvTHRDK1cwOWw2THVw?=
 =?utf-8?B?UEFaYnZVa0ZDUW1xMnlmYVZmcFRaUXlnclMwUTR1Zi9DcEw4NlpqSE83Zldm?=
 =?utf-8?B?YkhyN3pkbmFJMEhjaFlSLzhDZVcvV0h2K0ExYXI0d1QzbHYxL2d2NzhULzZi?=
 =?utf-8?B?UjM5aUVYSjFnUmxsZ3BjeDZNdHhrYkdJdC9WSWNESlY1ekpEM3lRSER4cmlr?=
 =?utf-8?B?WVpNb2syaENUc1pZREVDOUk2Zy80Sk1hOEVrREdvekJYK0dITXh4emVJdkZJ?=
 =?utf-8?B?STZic1JMcnZCSUhmRzZ6UW5FVlIrb0grWWdScTdWVXFPM1RsQXhBVWh2Q0Fm?=
 =?utf-8?B?RVV3OUM2anJTaC8yOElkamRKUkRBU2hYZi9xS3QwMjN4cDlRTk1QWFp3WVJK?=
 =?utf-8?B?ckluZ0ZoM1JLZTh6dHJrV09GSWdMMXZsYXA2aHlaaVhtN0drdC9WOUdpRXFo?=
 =?utf-8?B?YmQxNWEvL3p0TzFxMm9hUzVNd0UxcVIzZHY0S05CTTBJK2duTXZLYy9pc0Ez?=
 =?utf-8?B?Tm9Dc0p0QThmL0lIRlJVNW0wMGNzVDk4QUorbnVUTk91eFh0dDIxdnJWZUlr?=
 =?utf-8?B?ZnFtb2p5UXdTNUxPajFDQTMwRStYTHU1bHpXQVNKRFYreXA0Q1phdnN6dEtz?=
 =?utf-8?B?UWx3WnJTaHM4UXJ1dlRwZUxEZ2xJN3FjeHN2TGxPQ290WlhaRU5lNXpRdUZn?=
 =?utf-8?Q?w7Pe4Pj2WnADxaZcjzGp3vlr/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	46GQPv8FIoB4CjeRDNavOU15aalp4zfhow/083/jzRC7nDg3VgWW44vI+XLD/YgwosvhXZfvghATE9u7yKfCSluQlv8Tv+QN5Dq760V7T4mEin3UGbh+rVRZf05FjQ4Oa8HqFTNoOgySD8i0A3dOX+6TEF+tnTbIvl1Dbk6+EW3FjJijmw3nbzPS8Bs9ifL58WWzM8ZH1r3KcpfIY9/mzKWPDrVWTJsLnXa8jrYyor4VIX7X1SWkWKKmydP/MRjXW3ZMHZa9BoS8mly2qNa6M4lldeUl79kBKuwZktEG7/BSu/IaptZn+q1/lBQjUdg0jrBTOafc6VwHMc2wkbiR3lva3cuLe/uxVfqT4AsfwLufXr4GpHglde7k0eSk75zGREjMVynZstJpMhlaZA7DNBW37vVqmaMiSmMwuKluCLDD+dTsKpQVWN8LUDVQNQnEPxPNmK3qStb3WATw6CxjRzO7hoq3EfSeHov9kW34dWk/PaJK5+hkC0HJDWg7UYhbwmtOwIpY3IVaW3caIkspoTMF6x4UmcVsFHgqpbSH4YnJR2XRusqrLmm5a9vk/dcETE2W+kuKZmWXH/c/plfst0aapQMaPTwrOayjSpJ+N80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0683f348-c521-46a6-0cfc-08de30cb4c54
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 11:18:05.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkCg7Rj2SmpGSGcMPVJ8V7FaZ7PYGFBQHCbreNh28BhOqUJfdNggG7tsKqQaZV+mLYv7FGMf60IPGpnpMqABCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010091
X-Authority-Analysis: v=2.4 cv=ZeYQ98VA c=1 sm=1 tr=0 ts=692d7970 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=w2h7RB53Uq-13jtNowoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDA5MSBTYWx0ZWRfX4Tadl7ANpTHu
 RjgbK6BVeU4KcQeuMSm2YhiuCuI6wjEoMT7gPeiV4Pk5+FFZ6fXgXLlKYwDlD1ug/h4Mj3t4d/R
 EKqg5HGVeukMBre/gYMzYjFBcGmc0UhQvqW+mf4OcOccIGCHV0LbNGOOkPDr40UhXOutW7uirXX
 N4fsUGaO1pvHwp86ZgMuGc4IoPJbI3oDxBBfIbtbtBabEwsPazm5q5e1KIku6TkLfCKd0Uz3L9p
 nyKirc03iW9BNCau39DOdt7P1qOR09Mwe4FzNE0Kb4NECi9gy3QQx/HtOP2wujYML1zVKaAGowu
 i60KqFV3GyuURa0ScqjrJ/29kCdRUzp4Ym4K/Hlnus2B6x4tDrUwX917A8ZdOym5n8NR28N81d5
 fJ9IPxlgnlyawXcUXABIoTjCiSsLyWONepcomeiCJigupylOvZs=
X-Proofpoint-ORIG-GUID: UH9K_CApezjXCFGt-7Sw9H7cFfXwVR8B
X-Proofpoint-GUID: UH9K_CApezjXCFGt-7Sw9H7cFfXwVR8B

On 01/12/2025 11:07, Gulam Mohamed wrote:
> Add the emulation for REPORT_IDENTIFYING_INFORMATION command using the
> configfs file pd_text_id_info in target core module. The configfs file is
> created in /sys/kernel/config/target/core/<backend type>/
> <backing_store_name>/wwn/. The user can set the peripheral device text
> identification string to the file pd_text_id_info. An emulation function
> "spc_emulate_report_id_info()" is defined in target_core_spc.c which
> returns the device text id whenever the user requests the same.
> 
> The details of the REPORT_IDENTIFYING_INFORMATION command is mentioned
> in the section 6.32 of spc4r37 specification document of SCSI Primary
> Commands.
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>

thanks for doing an update

Reviewed-by: John Garry <john.g.garry@oracle.com>

BTW, if you do the changes according to the recommendation and those 
changes are straightforward, then you should add the RB tag granted.


