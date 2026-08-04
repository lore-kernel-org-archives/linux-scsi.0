Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33313C9EDD;
	Tue,  4 Aug 2026 07:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785828948; cv=fail; b=nwLiYdaPjpGWGPkzagLNeC4y4lsT0TBx2V4gBKWNZmb6TTgwwkiFOurg2GcGws+5f6Nm2vI/7JLHdM1vbMxcUVh56X3JDDPMlkdX9xV1+ND+NREiuuVEedbTD2pQ7+xhXzx4H10K/gBDruwq1KmW+crMY7g+ztNW9MXOVkzquJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785828948; c=relaxed/simple;
	bh=0r6XIbHt7nEx9doHqa4LhMK7E7OKxc+O4FS/k/J1X48=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UEn5nhAZocBQAaCM/1oZdmToJ5m/XaV15EHfrW4CD67kzrWd1fVrP6GZpYZw92r/6wnF4QlTd6TY2K0/iTbg6kJn/WWkkllxTigsEhqVllJ1UoaS2ckOTPcT6DWFWU4VDZGAhklQ38FKPrPfk+vt4ixe5Nhh4bB1nA7NXM6KpZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GZsd0pc5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WeGhubk7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GZsd0pc5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WeGhubk7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673KiIcW3789733;
	Tue, 4 Aug 2026 07:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LXektooThC2J9vZ7bSKEOvGrVUuzLg0ZJvVtCqXMuwY=; b=
	GZsd0pc5HKfjtmHsD8klVpH7SP102qBh7BOuveYr6wVprK3hkQAk4r5cB+rdohx9
	mi46QjFAuVjWBWGbSPzBhyJFQjGoqKVsGdkFXPXLCZ+H9K8aWSO86MWUiclSQC/U
	g1U+nMbEPwXOrSOpK0OFtZdUEjET4gWFyFrZnAc+FVODe+uClNsIBYmGHr9yRGuz
	+PdqaWTVmX2Pbp1aYxeGdgxtISjYepF7J/bGqEi9WeTQ9ylSF5qKJ3P9bcJabH4E
	BSCf55Yk8IIrljWrPZSrrMchkrjjdYCaIo9hFUYMJlJKNU9h6h/3mULE7MSsadtw
	5MUOU1wVEWroMYVcsCPbbQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8ugd2kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Aug 2026 07:35:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6747YvYn008019;
	Tue, 4 Aug 2026 07:35:27 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq4126tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 04 Aug 2026 07:35:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AG+qoZthW1zJn9SEH5Fmodp62/cDTTuNsnB4oDQgLRZ1+5s8BJCtpke48nqFZe3GQEF7ClReQY4Wq3qtzP70xpw4jIVA1aJP7bCILjrb84Ij1u+T4T1E8+QWrtoXG3tniJn1CsM9zWbAcf3Z79khdYwWHg8PhhETL+GFN08o7eYCLi8TSD2dDZCuG4K/jVID2pymfARs67kue7nO7qlqK3IaVhQ0lxvj6nt+Fsn5H1TP0kVddEDm2bDhuqsVJSccha88g4i8TZ10iRuymt8SA+5tzGj2AiGzBha3Co8jHs8OKuglUXHsKWTm3zLKj8EplmOOpVdkqw33loVL0DMLbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXektooThC2J9vZ7bSKEOvGrVUuzLg0ZJvVtCqXMuwY=;
 b=YDCLsBKykwlwFfU3IA3UuClsBgHXf7UaheXWkPO/BtRAtt3u15wOaYADPCvLDRntzVw899lzqP4xCl6uz2P8baXGU1hoC2GVTVRhNZt/XyuI8C6xeaAyUEensuJ2IB14dieJy1qiomiqkxwDehEMMiwTb9Hiw/6S/ehen2/ayyhIPlbzlpXAkAeZoCb8krOyEtObFhcISvGxvTYFRSBge5inFS4Btnm7OzSRL38hvgKtxHOCGoRebZSq2T5vIayP+wAmp06cNyGV7AEd9meOSeBbQRKBzWkByoTxQWMlxwwPeJcMpQeeK17kWHEcCKO80m7mIwnBqToZ8H/ZS3N5EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXektooThC2J9vZ7bSKEOvGrVUuzLg0ZJvVtCqXMuwY=;
 b=WeGhubk7fTuLNgcCrwotLntz/QlNLHinQTSyMFU73U1xkhuLEAO336TO/DEkU2VYoCQp5aW+767AG5jPOdTavlvlBwFK63R2T3pcv23i6EcnCH7NCbcQMarpqdkKnT8lj9hH/iYTR9jdYvXU/v87LfOh5Z91EXSziwSAVPnoCl4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CY8PR10MB6635.namprd10.prod.outlook.com (2603:10b6:930:55::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Tue, 4 Aug 2026 07:35:24 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Tue, 4 Aug 2026
 07:35:24 +0000
Message-ID: <e34a40de-474c-4a3c-8013-726d473bc79c@oracle.com>
Date: Tue, 4 Aug 2026 08:35:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] scsi: libsas: Support spinup notification for SAS
 devices
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260803020536.546544-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260803020536.546544-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0075.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CY8PR10MB6635:EE_
X-MS-Office365-Filtering-Correlation-Id: 2131001f-c244-4753-e998-08def1faf1fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	y04UTOb8Zck5Q5J+9x/gJ1Bvi/AM7tkbP7fVcrVthGcHVfF4ugPGWnZs+YvJiW+4tBHIH64jM1/3PP8EwRXWnAq1uSIBQRFBYjQpbrBc/L3TAPJqlNnabO1eC8WM81+l7yJpFtXpa0ZAM7REaMtgrJ5HmBu7Q+Gqlin4ekR+R/6U0/JTLPB4KBVWOAWBY9rDhCqgfKTOetjxmx3xa+kkH43aET97IX46xf/HaVarukXNO5in0uM1pSkgR6QY2TXCOXLOkCbnjAAYfkRjJkfN6PtrSyg6kbE+u1gTiz1tH+PbUtvrIhFNuPg5YuvK8YFjN8PdUGhD27yY6eix/Xy4L1iSoz5C0hNKY1UEHsdTm7c7x/8d3T2/FbPkDdX5VulGignCg+pawSvk737TIuRGCeAyCRMqxStRJbRdk8MaRhvutdNm59LFbU76dMFLaHJmRtKJnii1D2e3QYO8RdFb3iP4zrBsxWJlLRsKzY+I2YPVj8VdSYfddtTfjS74GE9sKo3tj+OLZoTA3JwuvTpOCtCgTobOtE2NCE0IECSIUm58agsARDA3pdEuJDoo322DKKf7r2NzK5mi4Uj8icK5SgPmr9oM4HEWxHfXt+08id+Trmrfhm5yN34QA36K4FqmTLWxNft0+iKfsI4icTrmWBYXqO7i66m6Fs9fYLtkl9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0JxSlprQVdqbTk5US9TWWtlY0Z5bm5FcmFNdVdpTWVxT2VJU2dlQ2JESUlo?=
 =?utf-8?B?OWNvMlZqMS9Tdm44SFR2c3A0cHRUTXFicGROdDRpd0c3WjlldlpwZlROa1ZV?=
 =?utf-8?B?VFBJVW1RQVFJeWxMajN1a0VpbzdtRk1FL2tOSEdCOW41UDFDYmRkZk9kUUFV?=
 =?utf-8?B?dFZ3MTNzRUpOc2k4QkNnK3V4bStrKzExS05HRTBFMktFY1RLangxd3VSalZ4?=
 =?utf-8?B?QmxIRjVpMkQ2Y01NbHdOd1RjZERoK0o4Wldna0VyQjVyMnkyeHJGYzU4SlMx?=
 =?utf-8?B?TEo4WFhJMGFwR04wbW9Kbyt1SStKcXJiTFcxTlQ0bXlpdTFkbUNpekNjSi9a?=
 =?utf-8?B?Tk1DN2tyRVNwbFBIYW15UE1nc2FSb0ZqMTliNnAySlB5dFR3Z0hZMW5qNERD?=
 =?utf-8?B?ZzhJM2xHOXI1TzYwMURaUXIzMmF5WFI1clo5STNPYjdKVnd3MHJSeE45VmJu?=
 =?utf-8?B?a1FUQTdSSVhQMVJaTG9XNmNjRnk0SU00ZWpJNG9rT1pJeFo1TEUrbGdYMXhU?=
 =?utf-8?B?SnJOaytuUXFScmxwZkNYZ0x4d0JuRmkrVjh1NjczY0k0NFF5Nmx2c0VIYTNq?=
 =?utf-8?B?MnJiMElnRmcrd2ZwTFNNdDVaWXVSeGMyaTUzKzJ6aG0rMFVGcDluN1BoRm1O?=
 =?utf-8?B?M016bVVRM1J2VUI0c2ZSU0xPRm11d2N0UjdLMFhQdVVYb2x1NUtFdlpITGtB?=
 =?utf-8?B?YURzVkJheVk2d0NpOWZZTkl3dk1ZR0YwMG5iSlgrR1ZydjZmQXVVWW5sTzR2?=
 =?utf-8?B?RnVoQnNMZ3BkR2ZTU2VBTDhDWHY0bklFRGRqNU5VT2IvMk9JbWx3TFF6RHFM?=
 =?utf-8?B?QjJuUFp5ZzI4QjVpcmVEQ1lRRVBZeU5NejhQOE53OWRseUM4R0lkN0NaQ3ZZ?=
 =?utf-8?B?WldpN3lueTU1N3U4MHlYWHdVSkhraGI5eGtQMzFKUVV1U2VBUGdTOVZiaVlI?=
 =?utf-8?B?S2tpZ3BLU1NidElmV0hnNDJwMk1UQ29BTmliVkU4TVBEc09HOW9hNW1abHVN?=
 =?utf-8?B?NktjVG5DcXpRSHpCTkxGYXNubG92ZXFBQWVIZVd2NmlWNStZYkkvSU1ERUF4?=
 =?utf-8?B?QTNYQ1FIRWVRK0pnZEZkS1ZmRUpKeVl3bjVNSDdsT080ajhxUEU0YjZ0Rmow?=
 =?utf-8?B?TWpESmlPcnA3N3hwTStpa1ZFWjlCWEFuL2VJeHhxcEhoTVN2a1F3UG5EcXJB?=
 =?utf-8?B?WTNxbWZ1eXRFNVFURDF0QnA4MlRNZFQ4ZE13cUJqaUMxc0tPd2N2THZwN2ZR?=
 =?utf-8?B?VWFxSFhjblFTYmpFaGFma1hBK3kwaFZWTTdUSWtZWGxuUXc1NEdYMG8xUmU3?=
 =?utf-8?B?TEU5YWhFRjljMkpzdjgybU9yTGtDYllRZGlKL1dPV2I0RDZHTkhxeGNVczhU?=
 =?utf-8?B?RmFxVlBpYkZoKy9ZMjFTYWFtRVVNbThZb1gvVjFkcmZQL3BxMXRvWmpUK3A3?=
 =?utf-8?B?MGxVNEtQdzhKM1J4V3VzUi9wSERBTXBlNStIQmdWYkZHRWlIdWpnRU8vUWlk?=
 =?utf-8?B?T002TmJwMklXd3RyVE8vdU9qVXZRVHdBZGJVYmxJdDNWaGIxWkgwZXYzSW9u?=
 =?utf-8?B?TUJVV1k3akxubjhIc1NWUHVUOGo1dXRYbzMvQUZVMU5MOU8yNjN1dTZyN0FM?=
 =?utf-8?B?TFZieHFhQ21EdWtURTQ0MHJyeGRPazNPSDlONVpzeDlhaVE1bmYwRDNlckVI?=
 =?utf-8?B?allJbTFXY3VSWCtQcktiVWg0dW1kaUt4V1BKWVNFY0xJNkpmODhvRzlGUVVF?=
 =?utf-8?B?RFZBL1FnQlBzRTNJTGNYM3FWU1R4VTRWcXdBTUtRQVhQZENWRnV5ZE1wTCtM?=
 =?utf-8?B?ZEJBQVpTT25tM1RkSEpTTk1abjcrRXd6dk5TdTRFc0NJNnpJSmR0QXdvZlFa?=
 =?utf-8?B?OGxiR3JNQXI4ZTgvaEFML0F0L1dmaVkvNDlQclNiZzlLZmxlZEtmL0dRd0tu?=
 =?utf-8?B?TGw3MDQ0R0h3UGNuSkdzNjZtaVVvRDE0REdLanFmK1AwSE40MkpaNkpiOVFl?=
 =?utf-8?B?VFJoK0JSY0daV21NazB0Q0QxWlZ0K3IyRW8vNllhQ1A1Q3RBUVdyZkRBeEl6?=
 =?utf-8?B?LzdtWktrcDU4aWwxVFlJQUZ1YnFOZnp6QXlOL3NvTzg5ZWVyTWxvMnEwTWlm?=
 =?utf-8?B?MVl5b1hNbHBZTGNEbE9EOFduWlNacGxBRDRvM0VGcUFDcG5SQTIrMHVQTElt?=
 =?utf-8?B?bnoyQ3NLUjFFQlp6bXNpdHlvNStUVTBQenNWVjhwaEpWYjdpQ0JFcnBMalBW?=
 =?utf-8?B?SXBoczhhM3F6MzBJc0dXcmNRaVNURndpYkJFZE5XZnZ1R1BobC9IeURWQjd4?=
 =?utf-8?B?NzJ4VE1BS2R2UTdZQ1Rlb1FtNFJadEd5Z2ZnMndEbzJoK3FkR0NyUT09?=
X-Exchange-RoutingPolicyChecked:
	l23ydCXisljMgCxruBZxkYcZicVtV8N6t5Haybmix1fZB6Tdud78BT2/tE3MxFbCFXRTd0EMVOrf3QgJcEIRvYgcvhoZ1DoxVlwfBkWlYSXz2AUaWzW45OX0S4dkmF+W8+980npD64Me2Wy/8BlCa+rQMKGI1qm3SDwrvsiSU7e9R5lOu2/uvsj88DDQ57yBRDmWr7PMUeGPqqb/N6HgypRhumnSCUuSxPzbbYYKOHxjF6n4Zd9J1b46siMAHg0WcDEJeDq2fKJYHJP+0XKxWRB7jKJykUCXXPykqWhuMxNCExDFNBvRxxWbLE1pscQY88Avlhpo/MWwlYKfykzWNw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2PDrSMwFUF/ULB2fY0IRzt1X8o+9BXGYOpAmYbodqQaOYDa1Rt9UsIleOm/JlaLa9YCGqD1l3HvpAvUuKKLXx4CAVeBRra+C5dPoZ4nB2zP9knWhdVAbQcZXxSF0L/9PAx1Gi4qWoryfHrXGPeDBwI9bybbVZ7WXWkY3ET2JloJXEtrbzryrl4GfLIdoqEiuA6WpsMkISmQ6pnVFTDDuC51dIX2K5AWNFcDJnmMY4L7u4VRmLNihWwuP/Jq/nGRO8EBycRKCI2DeSFJMXkuKgxzFKaTR8oER81WCe7XJ4gorBjZPn0caN8iFb0qcVica5U3seU+fWH5iBA4j4XD5F7edEm54lMbMx+OdZgJ68JKakPo4vGFYrWDNm6iMInA1jyvcQ9lV6JGZszKmzaHXT8skAg0BTr/b02hC+tRMXgSfmmT4zgjB7fv8XK7YZVeOHOOsjixIERYmlzfjK5k7zSHDLV9/ngXkJLavB8fEkE1WTS6UBDJE386lik/ewAGhfb5QgN9HhWRhym8bCSGXN/PKWlrARki24G5Y3sl8wjV7dqDImjTA3M+XaPDL7hRzeoPJtInHW1hYieOZOy17CQp7ihOAha1mbk+faTbeBbs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2131001f-c244-4753-e998-08def1faf1fb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 07:35:23.9975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDrp2DphE5I0qzCLRjxkkb+FOVsmAOVHlnXRR19wK3sd+V/Wvqaw/7UH9GKE5bx18uZlqvpafhyk+7aO571Jhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6635
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_01,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608040059
X-Proofpoint-ORIG-GUID: 7-D6zEWgxRYzTP_Wh7B0MR8IcEqdsDO2
X-Authority-Analysis: v=2.4 cv=XqnK/1F9 c=1 sm=1 tr=0 ts=6a719640 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22
 a=4k6lFwXBAMD3REdjcFAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA1OSBTYWx0ZWRfXzFK2RKrcki96
 wxP/VCFy58ewwEFX7t7JT02UbQQhq1dIxW/na5cH9M3YxWEQsCQdl0T4ACVnfEvc+/x7spxNb9/
 USQEOpONoonxzY13TJuil8QgPYk+YG5LemrYCw7+AL5jtfbUuiZW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA1OSBTYWx0ZWRfX0YxVPZ/sJfXm
 MOTgEbITu5bPVfGOBKEjtqoPs3aAN7Ga7yXKtCB94C2q1SlZl32JheXSjbn+QUR8o66FujaTKej
 7GVjbKBu75MdOcSTVBeiXppyfJEjwkWzjXs9s+uyvF9ZUWmTIqaJOOCRjsNFYHUVa6xBPrbAI0w
 ToRXY7f9DABZODHkJWmJK0lcPqLT+WpXhSmR+QwHBl7/bIDQZTUoU/gzW34QSmhuaNPMCW6/6os
 QWK1ghlPdnulcJUTqZPOlIEwZpnS/PLV5dsnK0gvw1zPFcC1GVoAHRy7dx6zuwAyxFjC1yeq1xf
 QcEs875L579VxWDyxFsU4TRladNrRT7pJ4/QV2ptM7f+puvPjIhoUJpYIX13Nveax07A+rqcaeS
 lJ/Zn8iapNmZPE6aJyV3ulKy0aXsv4Pee+WnbyDWeVM/Ey88BU0/KMlB960UmJDL4f+DtOC7/GH
 5OuEhhOVszHJLhEGO0g==
X-Proofpoint-GUID: 7-D6zEWgxRYzTP_Wh7B0MR8IcEqdsDO2

On 03/08/2026 03:05, Xingui Yang wrote:
> When a SAS device is in the Active_Wait or Idle_Wait power state, it
> returns NOT_READY with ASC/ASCQ = 0x04/0x11 (notify (enable spinup)
> required), indicating that a NOTIFY(ENABLE SPINUP) primitive is needed to
> trigger media spinup.
> 
> Without handling this condition, the SCSI mid-layer will indefinitely retry
> the command with ACTION_DELAYED_RETRY, resulting in the disk never spinning
> up and becoming unusable. A typical manifestation is:
> 
>    sd 4:0:9:0: [sde] Spinning up disk...
>    ...not responding...
>    sd 4:0:9:0: [sde] Sense Key : Not Ready
>    sd 4:0:9:0: [sde] Add. Sense: Logical unit not ready, notify (enable spinup) required
> 
> To resolve this, the SAS controller needs to send a NOTIFY(ENABLE SPINUP)
> primitive to the target phy, which transitions the device out of the
> waiting state and allows normal spinup to proceed.
> 

How would other SAS HBAs which use libsas handle this scenario? Since 
they have FW, would the FW automatically issue this NOTIFY(ENABLE SPINUP)?

I just wonder why hisi_sas seems to be only driver which would need this.

> This patch series addresses the issue entirely within the SAS transport
> layer (libsas), reusing the existing phy event framework, without modifying
> the generic SCSI mid-layer. This addresses the review feedback from
> John Garry on v2.
> 
> Changes in v3 (addressing John Garry's review on v2):
> - Move spinup notification from scsi_host_template to libsas. Reuse
>    the existing phy event framework: add PHYE_NOTIFY_ENABLE_SPINUP
>    and lldd_notify_enable_spinup callback.
> - Sense detection in sas_ssp_task_response() covers all SAS LLDDs.
> 
> Changes in v2 (addressing Sashiko AI review on v1):
> - Add softirq context documentation to spinup_notify in
>    scsi_host.h
> - Defer sl_notify_ssp() to ordered workqueue, fixing
>    msleep-in-atomic bug, preventing RMW races on SL_CONTROL, and
>    deduplicating concurrent callbacks via queue_work()
> 
> Xingui Yang (2):
>    scsi: libsas: Add PHYE_NOTIFY_ENABLE_SPINUP phy event for
>      ASC/ASCQ=0x04/0x11
>    scsi: hisi_sas: Add lldd_notify_enable_spinup callback for SAS devices
> 
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 11 +++++++
>   drivers/scsi/libsas/sas_internal.h    |  2 ++
>   drivers/scsi/libsas/sas_phy.c         | 12 +++++++
>   drivers/scsi/libsas/sas_scsi_host.c   | 45 +++++++++++++++++++++++++++
>   drivers/scsi/libsas/sas_task.c        |  2 ++
>   include/scsi/libsas.h                 |  9 ++++++
>   6 files changed, 81 insertions(+)
> 

