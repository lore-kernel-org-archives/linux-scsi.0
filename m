Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2640A287514;
	Fri, 11 Jul 2025 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752230732; cv=fail; b=s3GAsyUNSR+YwJVThje1GMqEfag2ZFXZOlyAZgDLAjzA6y64vhCv8RXLGky/+LMbMfheUJcSl5HnTbdBBLfunArmyV+/URZat5EQmoOyM4kOyfd2XCI4NHmfl14XVGpUgwtrAWUd6CplndsUAD3bf8C8RvKmaEG26ZwxaBnOyyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752230732; c=relaxed/simple;
	bh=+NbqkeBH2h0RA5aGRPKUbVXnarsq1MavxvJwyVnMXZQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kAwwj5Bv2tVf1cDIz/E25OsxJEn+FrdujnVL5xf/IZlp2WkRf4MkqBO7iKaoj47A/kQrPvOZsTd6xbFQ2dFo4HEFn0IVqEw2/36JfhChsboPyKHKTecHi+ryEKaselrku9RCXH2MmoQEt6lGaWte9dpKyPDngxBznD+oqLv1iu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SPM4NWi9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GQQMGbsu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SPM4NWi9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GQQMGbsu"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B9q3Xf003729;
	Fri, 11 Jul 2025 10:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+FcP5ydrf2xs3x3H6zKvBsKA3ROd3CjeyPcE9S2dzgk=; b=
	SPM4NWi9eUYIvfw0dA94PykIvtwYe2kVYIHpHlsFjlCLweXgJMVgys7ixzSz7Dl1
	Z+KmSbH+2AVXlkwQjZkjyatHdGZwjJLMpvUtyf99NiWvidBIxRgTmt+HsZrLWW8v
	NR0EkjSF1PxgyAc43VZGJHfEmrHN4rZLfTXFXsHkSK5xvRkWKPcR71cgz9NMjkXv
	Oov6bYtRX4cB1im3Pj0rp4ciHCf7HERq5b9jp9YQeoG84Uh6LuddFBLS2HtGT9WS
	bbcA7Vw0Iv45ObhPT1aa7VFxDmQ+e+TbURr6BUmGCakTGvxJQ+e+tBO9Nf2EoDpa
	+/XPMEOAo6jmSt4O32bzCw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47u0bqg2j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:45:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAPtuw040410;
	Fri, 11 Jul 2025 10:45:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdn781-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:45:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rziV6okIXt5ZySV7PCLRkNkXhWkvIlCQCaU1tETrjIfdgqO1JlYnQWsTl3Za7VdSd/x7PAT/sZfgirI/8iqyZWuNrGYqNdzV3kHGgj1AVqj7UHtKk2DUln4KslaiHK37eqwNgJdGhlVG1lR29AWSFRSh6au54UvPLFHpd3/NZ0P1fYz8AAPrqSw1qxiajnL8SYP3E0zRk3oqKGGwNjH00s9ePnJMjldD3UngYNOTOA88Y1obs44MRmnqSSJGGHS7odopAYgmfjjD/0eJBTPfdrZfU9nWdEYG2+9IVoDmjkCz8ivxqoiN5idCBZ4YMDE9WWJKV4suxiXeO4C6SAXc0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+FcP5ydrf2xs3x3H6zKvBsKA3ROd3CjeyPcE9S2dzgk=;
 b=fkET8Me9k0INElBthB2RT1YpXH2QXNjdGTFCszFwzDq39jSsViwhS25OGLcZsuPrXvhVrWX+B2f0OJt2UVZur7pEr8DH+wYL9vvQ8GQKj3+lfcm2n+Vyh8kbwbVYK0zYgspWz5X9dZqfffXtmGUY74po6b0o5BphB5RXWunhLvteEi6fGkLy34v60s1NwvuQQqep9oTD3er3sQNZcCEPEPtBLncWA+t3s/0UtCc/P4Wrn4GrvD4UbhcagShO3quxv9osOr4Iy6ORwrS7XUZR6+4oaNHEpMo6hcPRnbLru+qbH4MbNjaSseZP4WRD1Qk0linZh0oKKJ3kv1OxsgEKMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FcP5ydrf2xs3x3H6zKvBsKA3ROd3CjeyPcE9S2dzgk=;
 b=GQQMGbsuJ6oVnKilAD98H3j6nCdPeY6zVHVDnbBUq8j6TT+zCc9aQroxiyhyDw4vrNsjjmxLroA/lHtXpGs03M2MDSoXwfcaqPr+9v68cmZnpno5/yV1bIIC/YJFvcU8lrHzEu0mV8nybuwHzDbtIVL0P9/H/MWSRNQfKJWT9c4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ1PR10MB5956.namprd10.prod.outlook.com (2603:10b6:a03:489::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Fri, 11 Jul
 2025 10:45:08 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:45:08 +0000
Message-ID: <8068251f-3a38-4f7c-b58d-5d4ad974bdab@oracle.com>
Date: Fri, 11 Jul 2025 11:45:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] ata: libata-eh: Simplify reset operation
 management
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20250711083544.231706-1-dlemoal@kernel.org>
 <20250711083544.231706-3-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250711083544.231706-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0120.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ1PR10MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: 1150f79e-d3de-4702-3f95-08ddc06800ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sjc4NHYvNU1laXcwVXRYc0dDczRyQk4rczl4MnZoL01CNWpmWlR3WjZubDZO?=
 =?utf-8?B?bjE5aUI2a0JIWFA3cngzOWtxUzFua3p5Y1dyblRDczVBbTg0UmZMU1BHUnox?=
 =?utf-8?B?bTJRUmpTNlZpejZpcENaL2hWRzZ5OWtjMU1IcTR5WGtTVnkyNHdYdlRpODF4?=
 =?utf-8?B?L1NjR0daeXpMbEwzWFdHY29YS2Zua3ZPeVNGd0dkbFVpc0krR2N1cjJaM0sw?=
 =?utf-8?B?OXBiejRLNllhSW41NG5zQXlwNFNVUGdXczExUk02dVd2b0pKWm9iMWRPeWdu?=
 =?utf-8?B?by9FRHI4anMyRXZuY1ROdDVBSExpRXRPcDF1cUdlZmF4S3I1OGIxaTVBOVRM?=
 =?utf-8?B?blU1SXpMcXdDMnNhaTN1SWMyTmcxTlFraTRGcjVtZ3g3aXltbUpyeEY1RXBx?=
 =?utf-8?B?cC9hUkdkc1h6ajNOdmdEOENJTVpuaFdSaDA4ZWlWUFBQZTBzU201OUF6dE9H?=
 =?utf-8?B?bTZ5OGJKOUdOTDNlelBUU3BUVjZZVDl6SGsveGJCaGMwT0JRKzlZcHZxRGI3?=
 =?utf-8?B?MmJXYUh4SXZXbGkvdXN0M3g2QXd4MUpxWTRiMXo5clpXMVppR3JOT1ZDWEdO?=
 =?utf-8?B?M053WGVIcDUwdWJwOWJSZXEvNWdYZzUzc1VHbUNYL0dPVjltTG9nQUwxSTFF?=
 =?utf-8?B?WU8yVnJiSDdHUUw0TnBpY3JvNnVYVEQ1THZvNVk3R3BDci9OWVoxRkx1Wlgy?=
 =?utf-8?B?ZmI2dTd0Z1ZTR1g2ZSs5ckkvOHFrVUZna0d1SUhXenhqQTY5NzBMMzdoYUdM?=
 =?utf-8?B?aVZNZ0NlMzAwRFAwS09saHI3NlpCbzVLa3NWclB3QVN2THhGS2kxenRma3dE?=
 =?utf-8?B?aDhsWTRIQXR2SXJMUVVWNUJpN2FGeGUvTTZMOCt6R3doV0F5Qng0em9BeTlZ?=
 =?utf-8?B?SlpvVFRaSzh3aVZuVTc3ZlpWQzF4Ti94cnREbjIrQXFQaUlRdVZzMStDdTdK?=
 =?utf-8?B?ZHo1eG80ODNGUllkNW9yRkFaWkpPM0hQbWJCck9pZXJyRUlldjlEQnVZTFNC?=
 =?utf-8?B?VFVUT1VPTGlKcTV0UUNXbmltWVNUdFUrYXdKbnJCYU8xVzNrU2RZYVFZWkNM?=
 =?utf-8?B?TTk0enNiZHdvZHN0TFZNV01kMmhxWDhqUEdGMTR1dE5TWjVjbjE2MWlDb3pR?=
 =?utf-8?B?c1RYTnRteFp5cUlyT2xXVk50YWdwYjVJbld5aldUYXorOVJ3Q0dDeitxQld3?=
 =?utf-8?B?bUtMR0ZWbVAwNitWV1FNSktXZ3RLblFvVVlwT2ppaFJXaGhpbGJtUCtVdS9B?=
 =?utf-8?B?bHVqV08xYzFxWk9TdFhnRXlFNno0TWF3KzR0ZmRlenZHRFQxbFVpQUQwM2tL?=
 =?utf-8?B?UHdQSmhyZ0lhbE5uOEhTZmxER1JCZXJ0cGJUOXNic2c5RTlrY0R6eDFGbG9T?=
 =?utf-8?B?UUl4K0xJNUhQMElHcW1JcTlqMkE4a2ZuVHhGNFR5ZEVPb1hEQllSeWFQZ2lp?=
 =?utf-8?B?bWkzWTA3ZC9uWW1iN1pjc011bFVieDlrQWxjUWlaQzd5WFJFdXFZT3U2VzhQ?=
 =?utf-8?B?ZWRta1RYR3pKaGQ1RGgxVU1xQnV5TWVIeVhaRndCOXNOR1lrQjB0USsvQlg2?=
 =?utf-8?B?SzdKdUI1SVJNZnQ0alcxeTNhZUdSSDMxTWJ2YlR3NHVORHVVODVtUGpjVXps?=
 =?utf-8?B?NkJwNWIxRUFWU2krcC96UlJHQUVGdWZabXh3RlZ2NGsvaFNUa1Y0bFFRQXJK?=
 =?utf-8?B?M1lsK05JUGRjSnBNK2ViaFh4cERQbUN6OFZSMi8rbndGN2VhVG9yRUdHNFFU?=
 =?utf-8?B?QTZ5SGo5d3pxMVFVR0dsNUtGQ1dBdlkwYjVZTEZPa3BPamdkRUFrQXh1MDBZ?=
 =?utf-8?B?cUxFeERWLzYrMlMwVmxpc3hkaGpyTHNCaC9SR0F3VFBLY2lLK1o2WGNNTC9r?=
 =?utf-8?B?d0EwdVMyOXBobHpjNlVwRkRDMXVCNDgzN3NpZWlHdkVOeWZLUzhISjR5S1NK?=
 =?utf-8?Q?JkCxxpG832M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bCtGaGR3VEhBSFBIeHlKVitid2RMZUdXTDZYYXBKR0QrWjMwNndyMEc0TlBh?=
 =?utf-8?B?Y041ZHBXRWlhOWU5YWxYZzlQbm9ZZ1dxTFFHMG5nby9Wb0hFdkgzWStXNHNj?=
 =?utf-8?B?cjdOM3NiYVQwWWpUNURodkN1RXpZcE0vZW8vc0FFSDBQeGNxdmlLSmdrOE1v?=
 =?utf-8?B?RjBZZ0grSnFLc1VKcFJnTExONGpFcE5OaFlOSkxybVdxN3ZoZGNUdHpEUUFh?=
 =?utf-8?B?a2dHZ1QvTDQvTXpPYi9uYTRLNzNaU3diUWkxb29ML3owOXdhK2dLdm9zRGR0?=
 =?utf-8?B?QWRpVWlVcVRScHh4REN5MXVobGpjWXhaSGFVaU9zSVhCQ2lMZys1QjZuV2Zw?=
 =?utf-8?B?YXdTcFpJdkVVWTkxNm9VNDhmQ1BRNUlUSDVxRFIwT2xUV1oreGpxMTFLQ0FZ?=
 =?utf-8?B?OE40aDRKMzNUNWVOckh2eE0rdkMzclVUblNwWVdHd0tPY2pKRGpqb0tsNkpL?=
 =?utf-8?B?RE5YOEpkQU5XenRNeGNrZGVzZUhrSFJvek5zQnZLL0w0aDZUcElsN1pzRzNP?=
 =?utf-8?B?T2RpcGxaT2JKV05EVHpMZ0pBU2h1S1hyM1oxUDF3bkJnZThMaTJ0R2R4bm9G?=
 =?utf-8?B?RVpKUmhiSTVJM1FsWHpkM0UwUWRkSm4vZFVjb0JLVThPdmttUjl3QlBsNFdU?=
 =?utf-8?B?OThCb3FTQlFyTHNXYi9CamNNeXZBQ0gyNlZJVHVpd3ZRRkJ1ZlFuMFBxWjFh?=
 =?utf-8?B?TW51dnBFSFR3c3NyQkQ5MlJLVGhvYTFxaENsMkNwR0dqZHJHdElScFcxUlNS?=
 =?utf-8?B?ODloVjhTNnhmWXhkOFd3THdJU1M0QlcwWXkvVWNsL1BFMDZwRExjb1Vqcndt?=
 =?utf-8?B?cDRET0FiVkljV1l1QkxIWlJVVjM0eXFNSytTUmVkRjBRUi91SmlNM283UGls?=
 =?utf-8?B?V3Yzd2tVWlkvTmJBU1BtMzZpUTNqaWhmaTF3WUpxak5QUXd2WWo0cDdpR2Fh?=
 =?utf-8?B?M1pOOHhqYWdsbXhwTXJQS0VVcWFkbnRpMmJXREdXeGxndHArTW56eVN1a0kx?=
 =?utf-8?B?c2o1MkhLc3gwb1lGUHdqczAzVmp5eWQ1RVhSazhFYWRtNzFIck9kS3lNaWdJ?=
 =?utf-8?B?NURTTVhVVkVxYWlvcmwrSEY2QWxxeVRNa1F1WGpxN3NmMHQ0L285eHd1cll4?=
 =?utf-8?B?YjVZYmhGOGVmK0VtbHh0cTE1b3VJRloxWHpER1grd3dZWGd1UWc5em43M1Ux?=
 =?utf-8?B?a0FXSG90QVVyV1JNRVV3UDcvUitLYWUvbmxOWGpsSisrUmJhR3djVWVYOE4v?=
 =?utf-8?B?ZlkrTjdhb2txZjZQQjdIM0hNZ1FOM0JlaTRKaWlKTGNUTVdVRjl2UE9Tc0Rv?=
 =?utf-8?B?UUJTbm93aVZCRFBQTytUT2ozTlRYSEZXZUpwSEhvdW1IUWFNMFUvdnBHL2sy?=
 =?utf-8?B?cmRsVlNybkp2V3FISm9LRC9TMjBGQmh3cldURDNjVUUrcGhCWmp0Wjg3UjF5?=
 =?utf-8?B?VTRhYWdrN0hsUFM1WUdVc2hpL2p2Mk93dXJobFFPUWhpTWpuQlNaNVRvMEtw?=
 =?utf-8?B?K09MTENuR2VCTUMvbmxBUnU4S2N1VGdmblZTdmdRSktzeEZ6aXN2VmhjS0hr?=
 =?utf-8?B?OEx3aDBjOHB6cVlzdVR1bGJMME9PeTllNm51QVFSVnM5L2oybDg4aGlhWHl1?=
 =?utf-8?B?bHFTUDM1WFdMazFCR2R5VGRsZWVCdm1tZHJtd0xxTzlRVjkxNWVYZGJIRWlm?=
 =?utf-8?B?SFFXOVlIYlMzQ1ZXbWZ4R3BDMUYrTWF4SGd0V3QvR3FNNDlzd2lJUHRnUWI2?=
 =?utf-8?B?azhXdGN5TkhsQXBtUHdwV2M5d1pISzFHWHZYY0N2cUxtaW8zQVdRRFF0VHBW?=
 =?utf-8?B?VFVpMkNPbTNzNFkyOHlkL3REUGs1K0t2dTFpZXQ4L3Z2Tnh2KzdVN09Jdkg0?=
 =?utf-8?B?Z29UMXZxZ0FpZHNRdjFCTG9kbW5LdFdZYWFTWXFod3dST0xPOVU1aUlNNjJB?=
 =?utf-8?B?d1lzN2NsaE5tcEx6cDRmblJwbGpQVFc4QXNVa2lqRVFhZFJPQis4YktIMlVE?=
 =?utf-8?B?ODRiVE5IbzRJYk45NVcrVHQ2dVIzSW85RkUwcDNIUjF6N3llQmNRSlIyLzVX?=
 =?utf-8?B?aVVRMW1VdkNxZjd6L3NkQUtjdHNHSWphcW5MUEJpS3c0eEcxZXhEZUZCaWlS?=
 =?utf-8?B?blA4R1QwT2ZFYzQ2TFh4eEpKNlZHTlBjbW0wMEdJZUg0bzY4cmdOSW1KMFAw?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vlrm6p/x5/UVgR0BWjLDaaI28+L6iPNHPBnRylpJsAEHpZL8+GLfL4t+VoULYHupL5r9QkSLG+ALRtnlQliCrrPgG/+YM1IzOPoKJpyDgQryNPp3XNiWjYkWTG3Tl9g83DPz/qbMvHUWk0/fLzbQ6o76+R4fskH60ofXjWK97xLWxdgBZa6nl91WS4rxdB8VFwxUsZqF9cTZA139PNYqHTI7WfRWAAv6k2S/WpQFxEeIgQ9BPYRlnzcW1yLmZshIaB5LGNH2kjjNhZFPMItB58bgdXk7RdG4PsxauYz84v0G99LD1FGU+FIaXQQe437jVOQBYpmmV7qTusNUa+i3eoaYC31MWHmlgMOc8SbTYHSOAevE2/zFsGIX/LdXANQV3xjEn5p49d9BSQX45IKBFo88psW9q80RkWi3+qS3QZugXX3AnVhXK09UEopot1iTx6xZ6JWbKzRXtw5jSqNXi7FfVClUkEPjwo83iuwOc4HHvkbpinLSnsHZXlshSM/9HYWr75ngGuDl8OMZRMLxMgjdSFnjYIlpwE8rTalFlLt5TxK6EMhbcLznWFEntkb83R+v2XAPTc3jRYDM/iqlXVKf0wqdMCCsV5oYR3tm9d0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1150f79e-d3de-4702-3f95-08ddc06800ba
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:45:08.0559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTM4prSqKtrePbzeJT+mFLKNapABScINo90b1ca2yPusDKqDhoPZqOKi6sA8+EXFWyXedjh/XtIlGvF9dpGk3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110076
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NCBTYWx0ZWRfX6JFCduMt64yP XSibugmX/Jug13YWv+ssBPRMns+ALSOMKGlFy3AQLtBR/ld77d5yf93RrmDNt1Dj372MQuciYa7 orYZKjJaq/bXOPOPxnTy673UlXUWrw14e7N6tDQsU8qvScFgkj0Gu5JzBmpjSe5XO/FAldet48J
 mtq4+1B2b9ZJOtStX7AuXvDWUxudjvhWW6CAjF60de8d/uoe19camyG8n6L1AH9ntCBIWYUhKGr DA6jsAm2suWpHT//xn7VBiGVSnnMT6YMAdCslMLNjqTNcsyYlOPMBzr3RKUUjhoKlBFgpH6UlQA GCemUHK7MUUC6W6DH6nh3DLcKl2mTslFKaI835u7Cgzh2lV4l1UScpV+9op6kRlH4Q0AD8icn5X
 6cwHMpyoYTL34qboSc3fIfCkESlpp4iODsCMBXsPVTV8qiu+q5Q7ouvreie21OsbszJ/IY83
X-Authority-Analysis: v=2.4 cv=HPHDFptv c=1 sm=1 tr=0 ts=6870eb39 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=eXiWN3iUi8yj4UaYqFwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nQjylskwCnM6YFt_L5jOY-s938pcTnHk
X-Proofpoint-GUID: nQjylskwCnM6YFt_L5jOY-s938pcTnHk

On 11/07/2025 09:35, Damien Le Moal wrote:
> /sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 7b4e7a61965a..adb9e7a94785 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -559,8 +559,8 @@ static int sas_ata_prereset(struct ata_link *link, unsigned long deadline)
>   }
>   
>   static struct ata_port_operations sas_sata_ops = {
> -	.prereset		= sas_ata_prereset,
> -	.hardreset		= sas_ata_hard_reset,
> +	.reset.prereset		= sas_ata_prereset,
> +	.reset.hardreset	= sas_ata_hard_reset,

Personally I think that this is a nicer style:

static struct ata_port_operations sas_sata_ops = {
	.reset = {
		.prereset = sas_ata_prereset,
		.hardreset = sas_ata_hard_reset,
	},
	.error_handler = ata_std_error_handler,
	.post_internal_cmd = sas_ata_post_internal,


But it will bloat the code a bit (and elsewhere).

>   	.error_handler		= ata_std_error_handler,
>   	.post_internal_cmd	= sas_ata_post_internal,
>   	.qc_defer               = ata_std_qc_defer,
> diff --git a/include/linux/libata.h b/include/linux/libata.h

