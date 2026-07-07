Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EEA3546CB;
	Tue,  7 Jul 2026 09:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415946; cv=fail; b=aA9FR9lVbnvZOsY6F5r0Ro/AtyIgJ790Lsy5EDTMZbHAfLi10ze7WGTlyOFYJmkTkYNHjsRZ051LyCKlMLO92bgH4WioRiJfeGjZM0sfdUSsbEjko7JKyxWz4aP8ZRd84GquNJyAGP6k1BwIqYs4LSnq7t0sP1J21ab5D2t25D8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415946; c=relaxed/simple;
	bh=pC/IQkw62oRSiPV7z09Vaa1Vrhym4k81C+18nu6ia7A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HD0YOja5EoKIc/eSuuMNqR44P7G+4HqRp+IJvLXL+hQj5OZvOQTIXt8AGyc9jn1gurybsPs2H8callsNsRzodLWBGLye6zFEdjnynP5Cm1W57f7mX31GNfSHirQm0SMBK0aOModkkhBoLqaHHkGXLn+qv1tfdEPwOtlJ7a3fZfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IMZVQL2m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DvouEY5y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IMZVQL2m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DvouEY5y"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666Ncphf3452743;
	Tue, 7 Jul 2026 09:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Pr8XeAzoy6hoWRqU1Jqd3CiVKM7DUnJsVpliBg8WLrg=; b=
	IMZVQL2m14oMw/sxf7LM2JVV87h1a0U3IJR2jiL9rF7+lM56WHlHs9w1wVQ1Qg+X
	qDAb0fKNMyI2RspWxqEC7aiiKErkuVigwU7PJecT3Ptspm7nbpIijrVC/jBxYBDS
	eHCXDzZBiNFj56tUq103Pp0yhKZsyK3WVH0IT/IU3FIKMyfDsK71pn3X8s+7g8jV
	dhVu/3R8UArM79jeAnOM/bQFvZtpX/idfsYl4OqtVXaj98SyYb7jB7ulWCM6l9Pm
	Krm8P3r2ZTBK1dExLIZ42sNny7wy+tpQ2oTNmyGgbmbqAPBsNoNoYApSpLkHBYMy
	I9gk6y/JGVJIVcCpHPHEqQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6tqs55w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 09:19:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6679ICmf023732;
	Tue, 7 Jul 2026 09:19:02 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twhsct2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 09:19:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=efouoQG9fWHRxEtNil3Yg8I+VXXlILN4zdoHiYUHcWQGD5rUN3pfGR/TzdqdpDeX9y6GLhSD/vQZjKaXQL04MB1uBBObrd2bMtg3qxwtNrWUifDvDs8VKWmVxbeMLf+HXo38zK5SWNx9FZovsalG0AwZMQNUmECwGGvX0oeqXj2ahx6wl3ccfyV2AoTN/aldPUg9LMQTAaD57vJ7UswOGvaiMcu7W3SGwPJN/tEjNvrp4D0QWmbt26gMOkm0A8Of+WwSJlSKW7M9JHqNZnH2aCeOHXBFpd4OtHM/L0gidXeyk1t7z7yIiAzne3EWw9KT+QuOhNx9+d1Z9T8fKv83yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pr8XeAzoy6hoWRqU1Jqd3CiVKM7DUnJsVpliBg8WLrg=;
 b=JmN8tvf5YmlDFaa+alLed/aRlGuO+YmzwatVDYnxPnnSCoeTFbsB2zTTiO0bR2sJMrYjCqgB/cNiZkVCSwg4qfNlSqhzsI9ymVwTQO+hdlaBTOKpGAf/ijfbFBFEaK+qmB/M3BPQm3iXAMaeoVVEiSu+cOR8uugICgOznElZnE3s0LAvZiYxUoDbDm9YVDUZvP42sUxO3J6JRSA+JHvxkQSKuT6k5QCAK/7WmwOi4hLffiAloPeFf9Zh3YUYzGMdaN9iyqIBXIJfZnhjHkIJLWUK3Hv247Mh1ThUWhscZJD/8jO9zOCLyLRan3RmbR42xXSUnIuWarnJp5LIcLR1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pr8XeAzoy6hoWRqU1Jqd3CiVKM7DUnJsVpliBg8WLrg=;
 b=DvouEY5yHPPX1CpnY4yPdb8ElaxYwFaE6mhDUrcH5tsAzXEaqXUkRWFu9Ww5reD0a3robkwAJGD0+Ye/UB0f3x4w2Ox61EI3RnXMf16UT5atIYOvr7C2P5iiwQXFDm3wOk1K94RUpKcdD8IAQIGyM7fa0giky+c9OgZV9QIb+wY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH3PR10MB6858.namprd10.prod.outlook.com (2603:10b6:610:152::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 09:18:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 09:18:58 +0000
Message-ID: <c64a4c05-6f00-4249-9cf4-94a222429b0a@oracle.com>
Date: Tue, 7 Jul 2026 10:18:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/17] scsi: sd: support multipath disk
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-14-john.g.garry@oracle.com>
 <20260703122406.84E0E1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703122406.84E0E1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0541.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH3PR10MB6858:EE_
X-MS-Office365-Filtering-Correlation-Id: 95e3c902-2c83-4085-c3d4-08dedc08c697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|4143699003|56012099006|18002099003|22082099003|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info:
	hrpiFtq779D3Zd10wlt1aGIzBJHoGyNsiYq0Ce2fFUJe4h949VVQtylXmfBvJnN5X3x5XIwYdvC2MPDpyX8M9fglQqvaFDFq9hh8ybdO/TlBZ9oiPsh4KbyxJur9bdg5GWcfg1t8MOWCuO6SUH1NJU2xdlcmXTQuv7mp/IdKcW15W8SC+S1t3nUe66Pl3XtkEr+bw1H+4jnrC8gXPsVV9QcKZE4yrxnRvfW5fVmWBUEl4v0ttooMCc253vvLHWqD58B9mai4TRTST6s+CI6eqMX3ijmgRlomQnFKXCnWScC6rw+tVjguvZAly46Hrk40DeFXH2hkYzrsfuEe8r/0M6qtSLkoXobSI4Ze+wEXXIOgnIrFoPkvnGAu8Ee8khYsi9PnkgDvFkcLtE1SLrzCtyYF1oKi6JFIkJ972mVgQOpbun61nfB0+GEWVI/Q2EfAAQF4B6eBLKkW7zaSlykSlfuS87nbH8wcLfhjRn0VwSbbMFq5RiqQCMmF52lPF7/SfwvakIAKvZEK0hjK8rxWH/86I2MXX8X11zga65CidIWIjffZFhWTG/d99Lpb5xPRCqRzn82qnjgcnG+n2iFoGmRoMu3EpCFM+MPy1YjwmMp1XRPd4vu6fqqimJip3HNHDfeD709IvHXhGMYm3H2pjy8+02W4DknV2hoP44OkY6g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(4143699003)(56012099006)(18002099003)(22082099003)(5023799004)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWpQSWMyZytPbG9XSWQraktNUFFJalZ6Wm5Cd3Y4dlFycGtGY00rSXJYditV?=
 =?utf-8?B?VVBCWFlYQWY4Y01MT0NWNE1WVkZlTm1HbVNNa2pyVmNHVFA0c1hXVjF6bjFs?=
 =?utf-8?B?ZGlmMW5oMUFNU1d0SEZwSEd5bTZmNmIwRGFGSW1wUkl5clRJeEd4QU5VUUkx?=
 =?utf-8?B?QWNuazR3RDQxMUNWYXVVK1duWFZ3WjhvMWdOOUdLSlVhOGtpQTAwZVFURFov?=
 =?utf-8?B?UlNDelNySWx6c25KQlBQQmVBQTdWZ0ZSVWZJTUpFT0EwclZNeE03R1NlM0l3?=
 =?utf-8?B?cGtYQlNHNHd6TkNHZzNyR1lvMDZKWTlpWHFmRkhGNEhyUmlTM1hzUUVQQUZp?=
 =?utf-8?B?N1FTcys1RFRqcWRnM3VIOUNwd005a3RFY1RLOU9hSHpuWEVWUC9yQVFIQzB5?=
 =?utf-8?B?NWFzdDJuVm9iZDU1TTBKU3hqQmhCMTU5VnBUb0gxNmxORWNlRDZyN0t0d1pv?=
 =?utf-8?B?ZkFTd3JaK01NYVlLci82WFRFYlR0eStmeVJvQ2FjYlhFbWIxai9uaDh3eHJz?=
 =?utf-8?B?ZVhuam94VGxZR213dCtlL1FiclNIVmdKbUY2cVR2TVhZSUNwL0pOam8raHZ1?=
 =?utf-8?B?RldxWnRJSi8xdkFYMEJKd3VjNlBOZUNEQzA2S0U3c1hsdDRkdVloMEMrKzBR?=
 =?utf-8?B?a25LY3ZsWm5rMmNuNTJsQnFBNkVYWUZBVTExT2hZZVNiR2dWNGp3R0Iwa2tJ?=
 =?utf-8?B?dm00ci9lOHIrYzRYWFpWMnhOMmJqVWsyVXZQK2ZXbUZzMXkvRVJhQ0ZHN0dK?=
 =?utf-8?B?ZWdtTE9qMVZmOHVkdjJIUno4OURCeWtWOE5JVjVnZkRrS1U1a3VvLzhtSDVG?=
 =?utf-8?B?d1prT1B6QldyN1NMTWVEeGlxYjBqc3MxaGtaa01rZ3hWVTlIb3UwejloUGNN?=
 =?utf-8?B?UjNPc0ZFTEt0TGR2bmNRN0IyTWJ5RDdQc2FXWEVwb214YVk3MUQvaDQ0RXRi?=
 =?utf-8?B?UGZFM0J4QnRiL2FRbzdNcTBkR0gyeFFLUm5peGRMWi9BeUJPbUY5elYwNnVz?=
 =?utf-8?B?T0VmWERJU3ZsdDYxY0wrOUF6TmI1TnY0UVVmcGJud2Q5VTBnaGF6dWR6cExE?=
 =?utf-8?B?ZFRiQlZnT240ZWl2SXNsWUFKU2FjVHhaWHM5Yzh0QmE5SzBlbUIySnluTFRx?=
 =?utf-8?B?UWFtS3ZTSjZoSnhKa1psTmJhdSs3cW1HZFlWZzBFdUpGRjd3VzN6bDFLUmJQ?=
 =?utf-8?B?NGx1S1Q5N2JRVkRHOC80K1lvbUZTaXMySUpKOFh3emV0cnF1RjE3SnFVMHZ5?=
 =?utf-8?B?eFErcmhxbVp0L0hrdkx3a2c4aXZjanNyWUROOFlzVjVKY3dreE0yREorWWhJ?=
 =?utf-8?B?Z1k2N3dxM3daZDRIOTRyY0I4N2JBNDhld3NaQ3Iyclorby8zcDA3aDdseGNG?=
 =?utf-8?B?QW53NHpacVhBWG04YjRKUHJVVDI0bVhVQVNqcWVOcmdob0lkQTVjeVk0UjBG?=
 =?utf-8?B?Ly82eU91aXhJSDVoSFpQYkRsdVhRSGltblhSc0t0S3ZpOVBpenI2TnhsNFBi?=
 =?utf-8?B?NUdVTjdISVhRZ1lmTFQ3Sy9GNEkrc3V4MW0xR0ZFejZYQnNobXBlUWlsMVRw?=
 =?utf-8?B?N1FkdVRHbVZWdTJIdXdubi9GWktLdmFzblVPMXNGVDFRT0ZXZHd1MDBtT0JH?=
 =?utf-8?B?czhKdWkyNEMzK1MwSm9SQ0FkRk5GVk5Id2tWVFoveXlzZ3d6QnNLaGVCYWMz?=
 =?utf-8?B?ZUJYL0JFM3hCek1Ta0kvTlFyWS80TlkyTGc3NUwxdGpVSG1LaktkRjBUbGN3?=
 =?utf-8?B?bURSS2NoSzNrejhSUlRhZndLUTdWU0dyVVFQOGRrVmdCVzIzdjE0TjVqRnla?=
 =?utf-8?B?OUE1WklRbVgyc1RYdzJMSlRXTy94T1RtQUk4WG8vMkhpWERTM0JrR0dRN0ZF?=
 =?utf-8?B?Y0tXdE9qSUw5U2R0US9KekNDZ2RXZU9SaXpSaTJBVFkvQ3YzdXhtaUxiUUMr?=
 =?utf-8?B?bGljcERrK3VrbjBPZDl6TXNMbmNrM1VuTUJoaENHMGEyMTVJT094Qit2Qkpn?=
 =?utf-8?B?ODFGTGRVQUFsSk1uNi9jWEdEL1UwU2cxcmRrUlc2ZGkreCsrS2xjbWIyWXhZ?=
 =?utf-8?B?MGpKZWN2Sms4bUpWNmVZMUhNZFpLaGFyOVRxbVh0aHJrY01CcFVrMUdMcW1z?=
 =?utf-8?B?L1NHRjFtM0UybUE5WEtHTlE5NHhCeW9EN1JGYVJSdW1hUU1TY21uWjVtQXFo?=
 =?utf-8?B?SVhMUktpR25aSGdScnZYSGFSKzdmam9Bd2IxbzBXK2RrcE42YnR4VE5ROUhp?=
 =?utf-8?B?enpTWm1QZXhyY0Z3a2Juek1YVkU2N3BCTi8rRmUwK1psa0FJSnVIRHVxNktM?=
 =?utf-8?B?aENuK3FUQ04vTEl2RlFXUTFvZFkzMEphMnhsYXRGbithWGdsdzZIZz09?=
X-Exchange-RoutingPolicyChecked:
	C2bt5sBpgzaz1q4RU3s2k15Y4hwdxQ9CUHmnh0//FaoXoUEdfrcqnmUuQl4xSdvnTXI65RdYjK7j+O9Hi5qxrBKB3pnQWHZRsIZD9Jyu3uuHR6WSXC3pb4P2wA8NZirMu2x7jI+LzLi2YcDXRfldP/mDYCqXTJW8D5lwV9KRrSQToTDOqoezV4YIj+vwMwNCU7BN3GT1oHbnb6jxRNFhoPp7VUOjq0J7jvlylQBrw06jxCjydTh0pAAPwIZ6x9/VeX+ygOyBh8HUvuVphDg2gEsGsoh35fSwH/N/6pv6qEf6VOQeFy+xxZsJKcN70Icwn+jlL5vXuvmkM0eDDVVZBA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OyaHzdpG79OrI5fp6pQUDG1GxRasIyrtNGKCZZ+OzNpmUgLCx6hHPYeiaFI/X0yd7O0fNXDlPNasLfULfNvfTzKGFqpUWceXNj795OC++nAww6erObG5DndHgJweWPaU6Ke0trw9TTHRaMirxIHeG2bysWlXfNljTa/rXQwdGX2bcxO90WP9JbNqNvzj854PerGz/nAc5hViENnBfoU4JFw+yU8216v/PMpkJnbmo8CSu94UUo0xdp/tY5x3lt2CX6Pf0ktlC+86UOlrV14cn2uPAHokx9k5VcXtekVq2poyvEvb3viLK2uKqtfAw9KAxPOMXqp6NM7NvDm4QFGFC/3qCVFIDug8muvTPzYMe4nDQNsMjAKPU+mr9dgCZ3QMbTQI5dE4XbHma+syMCvrShZ3DZLC6eRJv3kH0f0E8fDJ+LVKgFHdANCLQuw4qP9LHb4mqco+FBUHte7+aJb08/fZ7tDs8rLNk1GZ+caSrr9Qef9i0pGx8KJwllH3JRNQFZwreYuMz2v/OlWMXph0MgOC4m3T7/iOVdQfeVBVs+RC5+ITojAvUovG0xRHzcSaGrZr3PHJcjkZG3/vbpmdc9+rX9mOaYq+yqPRUMNWvm8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e3c902-2c83-4085-c3d4-08dedc08c697
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 09:18:58.4358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiw4xNeW5dB1R7nj3+ua3QFF/aQxQ1p6tqMmhPZlZ/MdVipMLGtyrsobpismpDTJnBDm9izWaU4I1qItX3syuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607070090
X-Authority-Analysis: v=2.4 cv=BMaDalQG c=1 sm=1 tr=0 ts=6a4cc487 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=XZESHy3EaKDAReK9WK8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CnbuXSOAy-ENHBfXUmr2r8Z4D9AMHj2j
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA4OCBTYWx0ZWRfX25uk3OQZqLz0
 93fvJUPAZjqSwmQ698NISlIxbjNhOWfJwQ05Xs4aoF3DG07PTem/sFgmY6Rtvj53tDR53HNQh3m
 +DQKz79jlYGRYac+Ff40z1Y5kWsees1Vcm0mYdXchzSbafe/RROc
X-Proofpoint-ORIG-GUID: CnbuXSOAy-ENHBfXUmr2r8Z4D9AMHj2j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA4OCBTYWx0ZWRfX+pT4FWv5Eqdf
 bWnJQGDtB14zmVQ0K7l+M2WRUD+L4t1pblR1W/yOzW4wV+SNoRcc9jDWjYedAp8UcGQmcTtR+TZ
 bSwvuLHuIBYreUyGMb553Wo55JHpW23wyUp+mri/xTWpGnEG3SvLQ0SYuz/Cs0nZtP4C0CzETQ7
 1xTs0z5/DZPudnO2YQYxBV2EMKc5mukKW6Gexpff8ZimGz//XK7W2Z06BPmoAgqKDRP3RC4GmF3
 fXE/sExEBVls7iguyR7eykbb5D72QW+lMm1YeEW9qCjVux2AdneXdP+HlhI36HFWAAF4Zqej5Of
 BY2mxieG4w2ILLu3Gpj0uC6WZDmEIg6h5iDtVR1bbqnEwWUzunsOXNQNqzYckeiF88HZ+wykewu
 uA1o6XFIQsninM/kzOuJXe6gxPKYlP+WJhpFnqRmyIC19eaANN0fMEdC663ma/mIoIni8oazN0n
 JKQFdkxA9FUYPjt9i3Q==

On 03/07/2026 13:24, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> 
> New issues:
> - [High] The local variable `index` is left uninitialized when probing a multipath disk in `sd_probe()`, which can lead to IDA corruption if an error occurs.
> - [High] Error paths in `sd_mpath_probe()` call `kfree()` on a device object after `device_initialize()` has been called, leaking kobject resources and violating the driver core API.
> - [High] Concurrent execution of `sd_mpath_remove_head()` and path removal (`sd_mpath_remove()` or `sd_mpath_fail_probe()`) causes `device_del()` and `mpath_remove_disk()` to be called twice on the same device.
> - [High] A time-of-check to time-of-use (TOCTOU) race condition exists between `sd_probe()` and `sd_mpath_remove_head()`, leading to a Use-After-Free on the multipath gendisk.
> - [Medium] The `sd_mpath_disk` reference is permanently leaked when `sd_large_pool_create()` fails for a multipath disk.
> 
> Pre-existing issues:
> - [High] In `sd_probe()`, failing `sd_large_pool_create()` jumps to `out_free_index` which frees the `scsi_disk` object without unregistering its device from sysfs.
> --
> 
> commit 1b5b9df2120152290853f43f41a0b4fe936be00b
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: support multipath disk
> 
> Add support to attach a multipath disk. A global list of sd_mpath_disks
> is kept for matching scsi_device's, and gendisks are allocated per-path
> and marked as hidden.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4006,6 +4025,321 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
> 
> [ ... ]
> 
>> +static int sd_mpath_probe(struct scsi_disk *sdkp)
>> +{
> 
> [ ... ]
> 
>> +	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
>> +	device_initialize(&sd_mpath_disk->dev);
>> +	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
>> +
>> +	blk_set_stacking_limits(&lim);
>> +	lim.dma_alignment = 3;
>> +	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
>> +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
>> +
>> +	mpath_head->parent = &sd_mpath_disk->dev;
>> +	mpath_head->drv_module = THIS_MODULE;
>> +	error = mpath_alloc_head_disk(mpath_head, &lim,
>> +				dev_to_node(dma_dev));
>> +	if (error)
>> +		goto out_free_disk;
> 
> [ ... ]
> 
>> +out_free_disk:
>> +	kfree(sd_mpath_disk);
> 
> [Severity: High]
> Does this error path leak kobject resources?
> 
> Since device_initialize() has already been called on sd_mpath_disk->dev in
> sd_mpath_probe(), shouldn't we use put_device() here instead of directly
> calling kfree()?
> 
> It looks like sd_mpath_disk_release() currently assumes full initialization
> (like unconditionally freeing disk_index), so a simple swap to put_device()
> might also require updating the release function to handle partial
> initialization safely.
> 
>> +out_unlock:
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +	return error;
>> +}
>> +
>> +static void sd_mpath_remove(struct scsi_disk *sdkp)
>> +{
> 
> [ ... ]
> 
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk->disk_count--;
>> +	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
>> +		list_del_init(&sd_mpath_disk->entry);
>> +		remove = true;
>> +	}
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +	mpath_remove_sysfs_link(mpath_device);
>> +	mpath_device->disk = NULL;
>> +
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
>> +
>> +static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
>> +{
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +	struct sd_mpath_disk *sd_mpath_disk;
>> +	struct device *dev = &scsi_mpath_head->dev;
>> +
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
>> +	if (!sd_mpath_disk) {
>> +		dev_warn(dev, "could not find mpath disk\n");
>> +		mutex_unlock(&sd_mpath_disks_lock);
>> +		return;
>> +	}
>> +
>> +	list_del_init(&sd_mpath_disk->entry);
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +
>> +	device_del(&sd_mpath_disk->dev);
>> +	mpath_remove_disk(mpath_head);
> 
> [Severity: High]
> Can this lead to a double-free or sysfs splat if sd_mpath_remove() and
> sd_mpath_remove_head() run concurrently?
> 
> If disk_count drops to 0 inside sd_mpath_remove(), it sets remove = true,
> drops the lock, and unconditionally calls device_del() and
> mpath_remove_disk().
> 
> Concurrently, sd_mpath_remove_head() could acquire the lock, remove the entry,
> drop the lock, and also unconditionally call device_del() and
> mpath_remove_disk() on the same device without mutual exclusion.

I'll check this.

> 
> [ ... ]
> 
>> @@ -4058,22 +4392,33 @@ static int sd_probe(struct scsi_device *sdp)
>>   					 &sd_bio_compl_lkclass);
>>   	if (!gd)
>>   		goto out_free;
>> +	sdkp->disk = gd;
>> +	sdkp->device = sdp;
>>   
>> -	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
>> -	if (index < 0) {
>> -		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
>> -		goto out_put;
>> -	}
>> +	if (sdp->scsi_mpath_dev) {
>> +		error = sd_mpath_probe(sdkp);
>> +		if (error)
>> +			goto out_put;
>> +	} else {
>> +		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
> 
> [Severity: High]
> Does this leave the local variable index uninitialized when probing a
> multipath disk?
> 
> If sdp->scsi_mpath_dev is true, index is bypassed and not initialized. If a
> subsequent initialization step fails (like sd_large_pool_create()), the error
> path jumps to out_free_index:
> 
> out_free_index:
>      if (index >= 0)
>          ida_free(&sd_index_ida, index);
> 
> Could this evaluate uninitialized stack garbage and corrupt the global
> sd_index_ida allocator?

ok, I'll init to -1

> 
> [Severity: Medium]
> In this same scenario, if sd_large_pool_create() fails, we jump straight to
> out_free_index. Doesn't this skip calling sd_mpath_fail_probe(sdkp) to clean
> up the successfully allocated sd_mpath_disk?
> 
> This appears to permanently leak the sd_mpath_disk reference while freeing
> the underlying scsi_disk object.

I'll fix that

> 
> [Severity: High]
> This is a pre-existing issue, but if sd_large_pool_create() fails and jumps
> to out_free_index, wouldn't we free the scsi_disk (via out_free: kfree(sdkp))
> while its embedded disk_dev is still actively linked into sysfs?
> 
> Earlier in the function, device_add(&sdkp->disk_dev) successfully registers
> it, but this error path never calls device_del() or device_unregister(),
> which leaves dangling pointers in driver core lists.

I'll check this and fix separately


> 
> [ ... ]
> 
>> @@ -4127,6 +4469,12 @@ static int sd_probe(struct scsi_device *sdp)
>>   		}
>>   	}
>>   
>> +	if (sdp->scsi_mpath_dev) {
>> +		error = sd_mpath_revalidate_head(sdkp);
>> +		if (error)
>> +			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
>> +	}
>> +
> 
> [Severity: High]
> Is there a race condition between sd_probe() and a concurrent head removal?
> 
> Between the successful setup in sd_mpath_probe() and this call to
> sd_mpath_revalidate_head(), an external event could trigger
> sd_mpath_remove_head(). This would invoke mpath_remove_disk(mpath_head)
> to delete and free the multipath gendisk.

That cannot happen as we take a reference to scsi_mpath_head in 
sd_mpath_probe()

> 
> If sd_probe() continues without locks and calls sd_mpath_revalidate_head(),
> it dereferences mpath_head->disk and blindly calls
> blk_mq_freeze_queue(disk->queue) inside sd_mpath_revalidate_head(), which
> appears to be a use-after-free on the disk and its request queue.
> 

