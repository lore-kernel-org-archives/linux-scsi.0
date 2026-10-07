Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADF71397;
	Wed,  7 Oct 2026 00:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791331702; cv=fail; b=Nj7wIMsT409z68i5gzgR07ORZaa2FZ3ChMDaRK/RRx5n6ZUjZJR5sSjzrG4vsrqO4epFi+myELAVsu65x7T1qwjbnBHR/oplxpV+Ah3dGXHmNtHxDVRYPTbaaBezk1DD+fEX6jPjOIklLTiOv2uATZNowuXKXMGvolf2aLbg190=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791331702; c=relaxed/simple;
	bh=vKISN4FlhdphXPT4F7mJWTphcFFlrjW3W33eFVsTJDc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jnoVnr+qLZ21BuQs+kCZE1YJZaTZtFh3CP5HVSTZGazhYUHVBEYVIQm5b1ubD4Zobt1uw+aHlwH+gooMoAj9RXYrIkRDS4c3k/Yzf1xE92OofqkDpmQC+J9fKPk4ma3419rtI8pxmuXx++eVKSDnBb9qHIspPkXFwPBAYe9Lo1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WRFKDNJ6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EjJm5BNO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WRFKDNJ6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EjJm5BNO"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696Mo2wl1221157;
	Wed, 7 Oct 2026 00:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p1EObUxCrlLMiefGohPlncH717FkLAw1nofQka4hT3U=; b=
	WRFKDNJ6p/BZtfDpxEo7AiF1bSfMnXNo6Dls02IW4Um2dBfRIbEROWz1ORGpbhHM
	ojXLlUmSILjElaZOvEpn2hSQ1QpiLRMDH79RC+Bezc8mX1JUNe5wnAoJT4/WkYjT
	34/B7todd3pMBhT+PfUvQkWv6t19fxOUZYEhR2hus4t5H1O+Dbn64SwO6DbAOTeK
	VlERRf2dKrcpxCRCHqy6M8Xr57yRRgHeQiEI1mDzFPg+JmpqL29P0l9/3q+JR08P
	YMXZ5rLoguXFRUk3AfnMekBi3MLIOqTBoH9xKz1gOEdpy0gM4XsgdCwEQLQJD3NQ
	+G0Udl2Fkdv0BR0AAj9S9A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2sk7mr2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:08:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69706mtw019660;
	Wed, 7 Oct 2026 00:08:13 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d4w8ywf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:08:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LDNntmM6/4Qh1r5KmM7i54HsYMzyI+MgLjdrtIxsLtxH8LRtCs5WwEz15Ajw70iFWvecjax3I2HglPy2g0RrQEDoLKFeJnae9Y79EjWpWVQ0DiHnrNXyLOTWpTUOFNKZBJlfF1WS2T8eqcbadmGvHKHf1ZjLBTa0CyoCu74oPxsL6ThpQDThbE/j+zhLNsYy9w9+DwlJHh1zkTFky8z4y7MHK4+4bxSuAbZQMMX2rPSkjVyucQlE6viX8T+jS/sjy31x9MoMVPsjMgTCxwPS/+dDuhjLS6tRzGb8hQDoTMqUeKG9R/JLj/vhjLdzAf8+9Qw8IAgrHvC8+t9dVGYFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1EObUxCrlLMiefGohPlncH717FkLAw1nofQka4hT3U=;
 b=pO8L4QMduRl9s8PjOfYXb5fw+IA8PI0QKf+KV98TwJ6z0R0hkyxYauUYslGw2rbiwL5ZPTdkw/YDARoLthZ5iFZvGwJK5iH+pETghX6JFJjP2DB1M/+0PxZ6IFdVN8Jigt1NPIE91Tzsnczy9Qkm8j/bind7whoCPZwm0EG5sovFEAUMyoyJ5Hn/ez9K4WD0XMEDAqcDFcGd3PS4XlkIekmhmBkf2GDM+RU+GDtCKmpv2LiwmzL4+Di3LNHVEhZmvfE+Cxn40Bt/Sp7/Wxn0znBEjsE9Wki5f71WH5R7xYexZz0ygF+ks4TxMxc/QoCxu3bG98C9bArYU3mYxxWCIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1EObUxCrlLMiefGohPlncH717FkLAw1nofQka4hT3U=;
 b=EjJm5BNOyLwg6OJZJTOync4aZkHkfH4fhuSjK7xXBPpgWMOc+IDk6NqqQfFYnLhJbdx9wsf9JMeAS6jm5OoxraEXbh+BKSreOH7Asz0k+5CZ0VNGdNMoS77/46+PDdWJiFQkTOqR2sxsHSR4X3iXO1605Z6CejQ83PI1onPIz/E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by DM3PPFBD8703CAB.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 00:08:09 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:08:09 +0000
Message-ID: <5a4e8daf-d00c-47ff-8069-7bc57dd048a6@oracle.com>
Date: Tue, 6 Oct 2026 19:08:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libiscsi_tcp: check that a read got the data the
 target claimed
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, martin.petersen@oracle.com
Cc: cleech@redhat.com, lduncan@suse.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DSZP220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:5:281::17) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|DM3PPFBD8703CAB:EE_
X-MS-Office365-Filtering-Correlation-Id: d52defac-e9c2-461b-03a5-08df24071195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	NCI53J5y5lu1BbHSYYfQFDVl45YeWNDh7m7mw8L86lQpaqyNr8WYabqqkcwBfi26Qn9RmpnQmQB8EXNIfnupe10F4vbmtC+36QRNZLLiwl0VJdADWCuTeSG9JYZxpGgpidRz0gXhMYfkCtNmSjCuA28ym4YRfphLPGt9DwD02XjQ6/oi/3U1G9KruRipSM3OxJjtqPSAnikVvacITUnyy/fOkYg0zeE88/v6ySqEAwpLPN6957N36DCbsZTeUvYMLpHJEsf3ozRtZfEm7gvn3IvcUQrPOp5nU9VDyFMo+xPbLrVDZlgD3yRQXTCpT5FzhFDH6c5driTFTCjjPSpM2Ow67pugCdqlgkj7BL4zCb6NiFl1HPVc2HeyDBAhWTkH4ymf/0yfWT2j/6XzGgChMrCDcPwpPLYcqa3QMuENLZuJBeA22eTTif5rBeXB9tfU9f8NSJVm4j1z21AWiFK92kBGjPC52RHe6P/xIb5e5WRQZBDookhOzPpGmMx5kxX4mG3BWjDnEa9crif3nWOJ8YBg31Y3/1KB8xQYD4j9XHoL1Qbpjs3XJwDCEjHJqP3RuzJ62C+BTua6snOd4LlVEbLiab4xHI0LaJ1gLFECbocED0aE/TjN2BwfeVBe+kvV53fKP8w6AfJ14HGUgicVqyRMegmdM5fV7yXi/6Jj6hw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmo4OWlTMVU0Y0NmMWVUdmVJNUFXTWZPYUF4VkV2eStJM2NwU0J6SkE0RlRS?=
 =?utf-8?B?SVBGS3gzZHF0MXQvZjdhQXpGVWJpbnZQWDVDTUJFR3UyaEtZcGUyYzViYWxk?=
 =?utf-8?B?dGVnVk5HU3d4MFhCK25oNytRa2JHUVAvbzhBdExmc1NFZUpncWlxQWRPSkFz?=
 =?utf-8?B?em9Rc1RQUEZ3eURQeVVPZHRiMHk0b09uTVpLb1NNdGJQcWhsQTMxSk9vTktV?=
 =?utf-8?B?ZzRDWGZ3dUs5b0dOeGNiVGNobi9IMTJSOTFiUUVKcy9USUlENFpheTdRUnhJ?=
 =?utf-8?B?azcvdnJRQmVhbmxwUDBzQUlqanlzSXM0R1lIc2pQNmxWbjlVaWRJamV5aGll?=
 =?utf-8?B?OE5jSFAxU3h0dStzdDZrZ1FWSmZIdldRanltM2lXcm8zclVXWFRKd3dlV2t3?=
 =?utf-8?B?NGlQQzFNM1hjMkQvVHZaMlFabUljTVJaNFNqSzdmRXY0RVdES3dhL0RhUlJj?=
 =?utf-8?B?czk5cVpVTk5lOXJ3REJrVmltNUVGTkN6Y0FLdGlVYnZ0cHFML0NtU2JIalZ0?=
 =?utf-8?B?NlhLSERqcnhBUkFaWTVOOFFjeWI4UWY2ZkhycmFQMS82ZzNId1QrMVBlQlVU?=
 =?utf-8?B?dXp2T3J1dlZnRWNVYmZpSmdHaVcvMjE2cFFJUm1ick9RV1NCZTF3VlJjZ0Ru?=
 =?utf-8?B?MTRxeEUvTVBLckErOFk0b1o2TWFuaXRCei9jaXFCOWxVZzhWaTRDTFZGRDd0?=
 =?utf-8?B?UGRWOFRxVUcxM21tc0FBMlZoM1Q2L0FDZEYvSmJiNXVMdzhtdnZDUnZ4cFNC?=
 =?utf-8?B?VFNCUmdWL1pTdmYrUk1mN2RaRWZYZEl2NXhlempVVjVSR3p1NG5uVS9GMDdj?=
 =?utf-8?B?VzZMRytYNXM3b3lNRzc4WExIK05WMmlQaGFiQnpwT0dzZ1BaRTJUTW5UTE5o?=
 =?utf-8?B?OGJzMmlpeW50OCtYcU9QY2V3Vk00RUdxSU41RkY5MklHd1FQa2g4MjV1cWxC?=
 =?utf-8?B?MVhzZUgrM0paSGpGTkRuSVQrRTJlSWxSbngrYnk1RDRnYjhlWklDOFE1R1Nz?=
 =?utf-8?B?bmFXMExQWHRkcy91TEo1b2p2QVpxZ0RYRUp2NUh3MTU3Y3VsMEQwNUpGWGdq?=
 =?utf-8?B?ZDRtdUVZeGphZWZlQ0QzQnJBRnplWHB3aXlnOWhzUE93WTE1Y2VSSFVzQnRi?=
 =?utf-8?B?TFRZLy94WDFoL05GanEwSGpHSm1VUzJzOEJqMitDZXJlMzlnL3VOcFF2djVO?=
 =?utf-8?B?Vkw0L2tVaFJiR242YXB3SmpwS0RQcEpwZnBmODJhVlRJZWsrSGM0T1RjNC9r?=
 =?utf-8?B?bnQxNXVSSjZJNWhRcUNXM3cveEJ3ZXhtYk56RDl5S1dKUGdnRlJ1U3lzN2k2?=
 =?utf-8?B?NExlR1JWZXlRQ3ZIcVFNQnFxK1kzZ3pnRDBCMzAydzU2NW9vL0l1Yy9rVm55?=
 =?utf-8?B?M0RXVEN6QUtONW1lSW9QNDU2Z1c2NU0vWFNqcTR6U0RsbklwMHR2ZWw4N2l1?=
 =?utf-8?B?MmdYb3BjaEVkSHFuYWVIbk1RTEZFcmp2YzNsM2EreVEza2JLUHJid0ZIUUZU?=
 =?utf-8?B?ejNHQ2poZXVWRXMxRVpoa3VWRUZnMnRud0gxczdFYW8wOHg0elZRSjhpWDJt?=
 =?utf-8?B?YmREOFIvR2lkZncwcFV2cnlwWFBzbDJwbnNWNElmOXZwY1dpRFVvYnRWVzVB?=
 =?utf-8?B?QStjd09CZTYzK1ZmbnE1R1BHRW9ILzN0aUl0TkVtMDlnQzN4WXd5R1BOcW1R?=
 =?utf-8?B?QWEyTHRYOU5ubVNQWC9VamtVdXlIUHNyYVhQYjJ4Tkx2TUNkQmV2RUVWdXRT?=
 =?utf-8?B?QmE1VzRuVi91cURXVmEwUER5QnFkZHd5bXF5U2pYZzlndUFuWGhQbEYxNnVC?=
 =?utf-8?B?NU0wdHZWMUxCeGJjY1h5ZG0vN2hyR3FuZTdWYjZXOUNJZEIzT000ZzJBZ0c0?=
 =?utf-8?B?Smo4dDZLcUFSVEwxOWFFdWF6U1puQnhEU1k3VURnYzlyMUpLNVEyL1FjV0RN?=
 =?utf-8?B?THZBZjU2WkI2UjRuL1NpWDlPK0g0RTY1NENIVmM1MkZEK1BiNitDbldhZnVV?=
 =?utf-8?B?ZHZvMXF2Vm5lS3V5Z013eGRjM0J2cm8wRHJ1UG9rY3VHQjd1YTlkNWVwdzFS?=
 =?utf-8?B?aW1Lb25tbWJRTFBWOW9qSkZtNEdtZ29WYkttSjl5WEREWWcxSVVGZnYxNnpD?=
 =?utf-8?B?SVdndFZxV2Vrb1o2N3BacHV2cEFVazJ2ODhzZVpmbUl3aWIwT1JzN25YTnp4?=
 =?utf-8?B?YXRqUHRFZHZHZzdUZ1U1ektJQXFRck5yT1RlSTkvT2JGeHZQcEFTODZMaFBT?=
 =?utf-8?B?TVRYUHYvYTJLSzV5bUhjUGhBbmh6SmxNTlM2NytCamlOOXphSkVnNlpCS2pw?=
 =?utf-8?B?Rm5SSittcXJ5VWwzMWdicTB2NlJ6MkFsaURHYWhVT2YvanNGczNIbzRUcUs0?=
 =?utf-8?Q?HYvOD0bQWAeju+tw=3D?=
X-Exchange-RoutingPolicyChecked:
	tz3x6zAqkajVFvx1at7KvsusScV2JE28QjDrEWXmb0M4BNghN1QIwHl70C3Jy8iVCRjkQzvBLRr/Nz2/t1yK4BhiUAuxw9/KJ/XTIaQMrs5o5JowjUKDFewll2Qz3N/l8TvxFLAA5Vbd45lYREEsJ+tlj2S2UODjUPZPi5C8oMJsdSdXpmPh8vvI1ZYjpfeM+/ZtU9v8t0oRUjrYUKYasQRLTUJn9uO1RTdHwZcaX01+i22M0utGyRoMuVKEWpxCzFswX+Pl2HMOISCmug2NEeWD3Du4P/8pSZ1lGoAkotC21hqm0DtoPKSGv3AraObyngeB7rwwjwI9d20wrniJHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AnB7HJNrmqg98bA1SB9u5639pw6to1veXWI3faD0hM7Pvfa/bciT8CjtwhB4TIRg+Ng6FRynVsMkxe97zZQYKCUUSzUtVDAnLpSyFOFOWJaJxBzbG6XZ5gLEIeOZOIcfQpbGsEjBmPvNZeYi45BnbpVkTOz/nMvNMHht5peEsgfnbAWWCbgEDaGMRMC+MTSLLBaURhfJYi6KIRmXxApoI8nMhGy4ZZy4kMB/t7Hiqx10W/uicbcqKbDuQ9gs9LyGtDitp+EXL+mDvxk+HD7gxq4/AMVQLzMjjYnrwrIYJ/v/4V90alR3xh5A/1evn8//XNJSsI88iJQLmHmysBFGZmHwECztOn4Wcj6EYupXv/BaZ+ruYt2K4jTrFdjzwlmlwomz2zfdiDQtJhuwmoGHjEgJUNE43uD4u8+Sote5wfkkeDAOc7N4mqGHkLvjtxz1GI2E2KaxvguVKJsJfrlb4yR7a8CALBFkynr5g/A5NKq/BRQ1o9wqMZF6+q3nmGUpYrTOdn83K0aGG75VqPknHTCT6NJQMOPkc/KnZEDIZCoSDmtE6HJJqTagT3jgyaYsq4hA+cS0+gZx/BHaVoG41XyHsFRloDtZP+ibBNhLihw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52defac-e9c2-461b-03a5-08df24071195
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:08:09.0738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+WfQMzqZuYa119Gi7wbofJr0DPxTZaAobhAEQY6YxtrJqJFN4n/Pch4RxmE1neXHEFpCgUioYk8Tlyugn76qpolCRL5VgjYqLzTM4BLEFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFBD8703CAB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 mlxlogscore=923 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610070000
X-Authority-Analysis: v=2.4 cv=Cpsq4X4D c=1 sm=1 tr=0 ts=6ac58d6e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=ubcoK5Bgffa7cIzf:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22
 a=jLN0Y9YL_F5iLK54QOgA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-ORIG-GUID: zWy_Qz6WpQUmdaZQiJhC1uflv9QDf2gT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX5eyBWLWxK/Xd
 1aduP+OQuuEbr/0UpYYun492vP0UkwiK78CuCKw5Wvxsriop2r37sTykzpLUysxY7oBOeWw+hhC
 An8gy5xly3sD0r5NLm+YlwpmxGyyFOpl1L5mj/i9PX6yjREvFqQy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX6RCbnTALXr7u
 B8ziMiZfDPuMhTBSjF2idVOS7Z7ny9wJQ9BNDudySSjQezNx8EBjZYQE0LJtxeQvKHUOtRHLzK3
 nb/Ea3ZWOIjdG5xsrIPjYw23Xpq7DQLTf96kl8Tlg3xWA/Jx5fTynnhX7QoYd8O+6cn6rp2EVYM
 MpoSAbfRNx/d/1n/VjbhD+bEBcnebKi1h9+IdhyV2A48T+g1kYF9dlkp2XBPDi68ynuM1rPo1I+
 6U1UP4JZjp+w8MP3Qn5bC+3X6BVca3EpsrFpVkAaPFlsqJIQQxw1MTcDx+Thrgb20HYj8KGesK1
 oAbJtZuWPVVLO/BTwQhqW4kyCm5gpTOk83QpED1uJMN7ebP/tI/x/It8QEPyI1jVmzmw43vDy7c
 EKydB/QtNM/9IahfcYkxOxjJogRdiXpBhT1JYEIm8L8jrEfK1/BoJGy/evEfB5kKOr6Fq8y10uA
 E8jGzQ/oq2okaMZjpF+O3RpADcSfwOWCb+SZk8Pc=
X-Proofpoint-GUID: zWy_Qz6WpQUmdaZQiJhC1uflv9QDf2gT

On 8/14/26 7:14 AM, Yehyeong Lee wrote:
> @@ -752,13 +795,25 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
>  		spin_unlock(&conn->session->back_lock);
>  		break;
> -	case ISCSI_OP_SCSI_CMD_RSP:
> +	case ISCSI_OP_SCSI_CMD_RSP: {
> +		struct iscsi_scsi_rsp *rsp = (struct iscsi_scsi_rsp *)hdr;
> +
> +		spin_lock(&conn->session->back_lock);
> +		task = iscsi_itt_to_ctask(conn, hdr->itt);
> +		if (task)
> +			rc = iscsi_tcp_check_data_in(task, rsp->flags,
> +						     be32_to_cpu(rsp->residual_count));
> +		spin_unlock(&conn->session->back_lock);
> +		if (rc)
> +			break;
> +
>  		if (tcp_conn->in.datalen) {
>  			iscsi_tcp_data_recv_prep(tcp_conn);
>  			return 0;
>  		}

For the normal case we will grab and drop the lock multiple times.

Could you switch it around where we do:

spin_lock(&conn->session->back_lock);
task = iscsi_itt_to_ctask(conn, hdr->itt);
if (!task) {
	spin_unlock(&conn->session->back_lock);
	return ISCSI_ERR_BAD_ITT;
}

rc = iscsi_tcp_check_data_in(task, rsp->flags,
			     be32_to_cpu(rsp->residual_count));
if (rc) {
	spin_unlock(&conn->session->back_lock);
	return rc;
}

if (tcp_conn->in.datalen) {
	spin_unlock(&conn->session->back_lock);
	iscsi_tcp_data_recv_prep(tcp_conn);
	return 0;
}

rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
spin_unlock(&conn->session->back_lock);
break;

>  		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
>  		break;
> +	}
>  	case ISCSI_OP_R2T:
>  		if (ahslen) {
>  			rc = ISCSI_ERR_AHSLEN;
> @@ -998,6 +1053,7 @@ int iscsi_tcp_task_init(struct iscsi_task *task)
>  
>  	BUG_ON(kfifo_len(&tcp_task->r2tqueue));
>  	tcp_task->exp_datasn = 0;
> +	tcp_task->data_in_bytes = 0;
>  
>  	/* Prepare PDU, optionally w/ immediate data */
>  	ISCSI_DBG_TCP(conn, "task deq [itt 0x%x imm %d unsol %d]\n",
> diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
> index ef53d4bea28a0..b38be23b9e10b 100644
> --- a/include/scsi/libiscsi_tcp.h
> +++ b/include/scsi/libiscsi_tcp.h
> @@ -66,6 +66,7 @@ struct iscsi_tcp_conn {
>  
>  struct iscsi_tcp_task {
>  	uint32_t		exp_datasn;	/* expected target's R2TSN/DataSN */
> +	u32			data_in_bytes;	/* Data-In payload received */

I know we are supposed to use u32, but could you do uint32_t to match the
rest of the code. It just makes it easier to search/review when the code
uses the same style.


>  	int			data_offset;
>  	struct iscsi_r2t_info	*r2t;		/* in progress solict R2T */
>  	struct iscsi_pool	r2tpool;
> -- 
> 2.43.0
> 

