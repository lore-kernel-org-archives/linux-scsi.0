Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7829194AD7;
	Thu, 27 Nov 2025 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764247648; cv=fail; b=B8aB0N+luvmULjulS+KM/SVwoJJOETEnjDeHb4Xgrx2ttasCihTcRSdOFsuvQgY3EVuw5A/F3STSes3sFOhunh4UEuYwG/VpqZ/MajweHc7T9LDR9KzNYA0tQ+7dTs0i9x2NiI9dhujjfA2MQSXf7EC1pFRkgBwHCOWrfEkeBGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764247648; c=relaxed/simple;
	bh=J2NfF1MWGUKJjh/kiElZhEcgZRkCj5ZIgqq8Je1qKq4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kxcZULaz4QzgPPJXxgCqBzKFxia7fd22CGCBkEhEfBNVgZwmbyfQ0oYzhR30TDOblFMt2WdA1mwCCIwP7qY1qdqGLnU0hjEZ7JhyzEp/rNv1TIEiszI1cwm0FeBCa9z/QH5kjOgsU14nGERpZVQo1rKfxnJzOu/IdsYkTr2ZgHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WPSOc/UQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rHllYMoK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WPSOc/UQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rHllYMoK"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR9fhYm356233;
	Thu, 27 Nov 2025 12:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+AMhea/Rj6McCFUUdylTFDSuYiz2+MVcCDei2kguVoo=; b=
	WPSOc/UQ0bmzlHAcZcrFg1oiWAFEqzhsqDxMEfjgd96qngJCMoPtVFYwXtLPixVM
	Dm/qNh4qxYMpP5NOIlkhutLehIDjgKC9qvo8YF5T70FHKBS+oTLlC+p5PYdsBhz9
	1CwnjW/gX8a8CLBkBx/+ZVFxuC3gvEhObjdnsEVWDJEQOma529MNMzKALVciEzfA
	sbywYJ9AB/G1DJ0R6PxmEBxaNdIXYYu7RopJowp/AO8AzMQe+k6QmZ5JYvUMLRVl
	BXnCLcfn8keidMy5PWcZ4V8p8EFR9K1rXPj70bLusPtxwuUw5PNBbd4a/U6+AoAn
	UvHspQpek6KYR2Hiar6umg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apm7ug8ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 12:47:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ARBcb4O029812;
	Thu, 27 Nov 2025 12:47:24 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mfsydj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 12:47:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wmcLQ7PnjLt4ljhtcFsKzoeIdjkpwT9+Nq7ShPz5fsyN7dhsn04PrWFw/SJajmTshZ6c915kmHkP4X2K21QKxPOQk7PQdYTXgPxmMaKy5MooqIv1wP3HwA4fL6tU4Q4TNNkshABZaYSrJcmV+qGNLq1nty0Nf/wQtEJPYeFjWLjbXri6TH+FtaDurehgqD0u3OP/WciamsBfIIMeuosiRxOV0Gh2Qmc/A1PBYo85B/Dkhp6WopRsQE+2muDcfSmp+cUKgj20zXVFuWQems1mNeyEafui+C1Z2fnlBHRNbB/6PbBk06diXppROvcc6cUkNG8BhSMvNJKXiz1ojK56AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+AMhea/Rj6McCFUUdylTFDSuYiz2+MVcCDei2kguVoo=;
 b=b4R4Qxby+fayIaTCi5f0A+JjVtpn33In+zXIkpNutUkyMQU9+UntRxO3WNrR1jZa6invwwcWJIMSYI4TqHs8vA+wVxPibIrD3NIMtoykLGH2FmFU6P7BIdLMzS+AOoTuAOomgqNC8HZ+L2KSYHgWkiftGAEVHE0DeSzr5PpkMOKYLu2e5sTFf8GniW1BydOkme+Pnmq+FEH72HM0wpl5HgHFa3ZW9IqyPVgJ4+47GDO1FVPkynIaB0X32dw/Hea5afkUg9edFkQ2uyPO8fwy2H9DOtv9aenhGzmC7DXyvjJ56DCU/ZtGBnrZ7LqX5+YmozTfXtThkhnuzgkTeaq/tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AMhea/Rj6McCFUUdylTFDSuYiz2+MVcCDei2kguVoo=;
 b=rHllYMoKuFd5Ww3aRybXK1uPj9yT8w/xcMP799Ov8UiZ4He0ge6Vm2szBi4DJ2sY9uwgTCdphhBkteg2oBVAMfBVfvhi9JCG0nLdsdCTjW1o5VRVzDL9PYdLtQ7nCStuSaeHfGIYLoFLKxlWmX1UKdLbuQqb+rcMquZoiOoMYp4=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by PH3PPF1D715CB68.namprd10.prod.outlook.com (2603:10b6:518:1::78d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Thu, 27 Nov
 2025 12:47:21 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%6]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 12:47:21 +0000
Message-ID: <e6d503fb-a99b-473a-b6fa-5ca3b02b9c86@oracle.com>
Date: Thu, 27 Nov 2025 12:47:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFYING_INFORMATION
To: Gulam Mohamed <gulam.mohamed@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20251127113448.17526-1-gulam.mohamed@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251127113448.17526-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0107.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|PH3PPF1D715CB68:EE_
X-MS-Office365-Filtering-Correlation-Id: ccfd78af-a16a-4831-0d79-08de2db31af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmhvMHdQS1VyMFFIMGRBS2cvMEJTQmJWWkh3R3Nsc3B3VjBvc3hTVWkxZE5B?=
 =?utf-8?B?ZW1OaEd0M0tuaFVWcEZpNUFDRzFkcGpCMlJibjZ5c0JYeHYxejB4aTMzT3Vy?=
 =?utf-8?B?L1FjN29ia3kyYjJZNVB4bStxcUFKOGJPZTh3MmltNTVqaFBKS0xhYlZ3dVhY?=
 =?utf-8?B?dlBSWUVrZHFxaFdxL2FPb2NtcXBOOHNwM1AyVnlLTk5DVzFzM0VFMGhOY214?=
 =?utf-8?B?dGk3Tld3OCtWSHdvZ2V6SGs4dDRFSitsT1FOY2MvcElNNVU4amo0VGRsc2V3?=
 =?utf-8?B?U01NNlFVbFBIWEYydStUUEp3aXZhUGVrOWdJTXBuZTdaMWtlcUVnWk4rVFBs?=
 =?utf-8?B?alhaYmFYaDFuYm5sSlA5SmYvY2NCaVdwcGVIWWVhZ1A1QmVtOXJwNkUwNkh3?=
 =?utf-8?B?TGc4a2xLNWxHTjJlQnZlNXZsR1E4VnBiTGxQTEx1WnpSOGMxYys1QUhjckNi?=
 =?utf-8?B?V2JIVzV6QXd0Q1AzL3RVdkkrbHJVM1pCLzE3UnRXTWpkdDgwZWNFL1NoQ3R1?=
 =?utf-8?B?c2ZxeE15ZGxQVDQ1QTdSanlrVVp5RmxIaTZXby81RkZyb3ZadS9aUm1oOUNq?=
 =?utf-8?B?a1pZSEludGFSb2Z2Tjg4OWFrVEV3YVdvVHdEYVEwQzl1dmEyUW9Ybm5VWHdz?=
 =?utf-8?B?Z0EyTGg0bDVDdE53dkJOdjFTQ2g4Vk5pOHpzZVd1eW80cXVaRXBESTRNcCt2?=
 =?utf-8?B?d0VXV3VFZW9YdkwwaWFpNjZ1TTlOMWtMaWp6UmRVN3FJSlpxUWZIdWM4NEg3?=
 =?utf-8?B?THY4WHR1Y0QvU2h1ZmExMEdqNWFaeVdUZ1dmZk9ndmZjMkhuRXFlbDhBSGhG?=
 =?utf-8?B?b2dMUXd3TnhNaXlWeWlzTTdHQTdCSXBzVFBWM2ZSeEdxZ0hXSS93NEhsbGM1?=
 =?utf-8?B?Zlh1aG1SUk1yUnl1MzVtaENVL1hwRk9mUXB0bmxLQTVtQUdoL29NV1VuQ1NS?=
 =?utf-8?B?RTVrOGFUQ3BvN0RFRndjbGFhaFNERGNsbWhpWVpYK0VrMC8vdk42cUt4Yzd0?=
 =?utf-8?B?eWh2RE1QMU9CSDBBcU1SRlZVc1pJdTRjVzVhT0VOQTRkc2s0ZGM5LzQvODdR?=
 =?utf-8?B?cFN0OG9uQUVNUHYrbFhuU0hxU2FmK2t4QlQ2a0ROUXA4WERxRThhLzdSMytF?=
 =?utf-8?B?UERYVmUwV1FSMU01L1EvS2xOMVZmVU04VHlQOGJvQlF3QkRYY2FNYWN0VDla?=
 =?utf-8?B?OXdZOVRab1BwaFRjd1FTT0tseUlGa0ZUejZlZFZ5L0pwZFpyRXI5VUVqTU9t?=
 =?utf-8?B?NVNrTWZOcTgwKzhOZVc4a292cTBBUmRkVm5rOGdLaklEbzgvcjJpZEorK0U2?=
 =?utf-8?B?S2MweVQrSytRTjI0c1RaSVJ5Z0xjQlZYcHQyTU03c2doWms0WjFXMFREWVRk?=
 =?utf-8?B?LzFkNUUzMUVXc2V0bEFTTW52Q2xnN2pBWmZ4Z085T3UrZVNmRkZ2dDBIb1Uy?=
 =?utf-8?B?ZnNDMzBiV1NIb2k0YnQrVkdta2hjdVhBMVdPWWlSUnhjZHZva3o0VDNRY0pL?=
 =?utf-8?B?TkZPTHkxVURFVU0zQU1ocmwrcG8yYUhNODNJZHArS2cwbnlSUyt3L0ZhdUVz?=
 =?utf-8?B?Ym0yejNBNGU0blFLUnZvTjhiWCtwZ2xmaWd1bTRJOU9uRy9wT3dMVW5OQU5p?=
 =?utf-8?B?bFZuWXJ2WE54cnRKb3I2dDV3Nm9XLy9SRDhqRHphVGhVR2pkYmloOElQbWlF?=
 =?utf-8?B?QW9XeHJ2dlU0SzZaNXBLUmVHa0JWc2pNWGsreHNPKzVubGl0T1I2c0tNZXBJ?=
 =?utf-8?B?QnltdkxKaFRBWG0yRnpIYUVpZ0tmMjkvUGdvUzBFMmx0aHQwR29oU3g2RjFp?=
 =?utf-8?B?MlZPMjhvZWdQVmdRZ1JjM2J3V2wvb0tSY2FBQkp1SVhsQW1ZZzdERHJ1MXY5?=
 =?utf-8?B?cVJCZUFrV1gvSGcxUENpRFQzWmxyczhCSXVKbDhTemdKeEdvbGFrQlE1aDZw?=
 =?utf-8?B?WDNkUERVR2hDTkZvVFBXYmdqUUtjVDJOYWRqcUhRQWJxZUkyQzgxWmlqTksw?=
 =?utf-8?B?Z0tsbUIrQ1pBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzhTZTd3NHg5SFhQTTNHZjFCTEEvU2V5SFR4bDdEc1plN1l4eHI0bG41TThu?=
 =?utf-8?B?ZDJqL1A5Sk05YzRYN2ZLUncvQjVLNkFUeHgreEFrSWRwTDUzR2l1ZW1XSC9v?=
 =?utf-8?B?cFFBK0ZpR3ZBSFNPVGZ5aE9FWWp6WitsdGVpSXdjMEQ2cmc1L0FLOGczYWdz?=
 =?utf-8?B?eEZoa29yY3BFTTBKUURaZkdBOWdlRkVwWkV5UU5rTEh0YjZLSWF4dnVEZnpR?=
 =?utf-8?B?QjFKYzdKTm5Hc1N4L1FpK3VBcC9jWW8vbFRLWjFUaVdmRjA2dC84QVlaZXBt?=
 =?utf-8?B?SlRRTzdVdU00aHQwR0ZueSthaHlMMjVZUEFuVWRHck1xRlBGZzVSeWVPemF3?=
 =?utf-8?B?NVpGRHo4NG5RNExBbkZhbTd0WS9vUmRUWlMyZjBMQUxRamlvZ0RXRXdwUFZz?=
 =?utf-8?B?OE5rMU1xOE5uTndQck5wenBmMTQzQzJ5cU9XdHhjcWlmNWNFOXh6bzIybkh6?=
 =?utf-8?B?VDh0bFBWK0RwS0VkYzd6b1hEMzFlcE8rR2IwZzdhVlhDK2Fwb0JpdURYVmhX?=
 =?utf-8?B?NjNwUU9SNTVYMjhmSS9kQmZPUklwTmpWQ3JEYnlXTDhOZFJLRzBKL3Zkb3U4?=
 =?utf-8?B?dXE2V0dNN3o2ZFRzdFRzRFVZdys1L0xESVZLNTREQTA5NVUwQloxaWMvMk1h?=
 =?utf-8?B?SStOOTB2WloyYTNnb09xa000S1hOQ2QyUEloWkZhTWhVVWQwV2VreHhHc2pU?=
 =?utf-8?B?UnVrSmlIaFJ6ZjFGMllERTF4TnlRVFZtcUw0a25rVUxvd1hwQU8zNysrNFlM?=
 =?utf-8?B?ZGo1ZEloZnhxaE5lODN6U0xWajQ2dTZ1T2pDT0N3LzVrZXR3WFFuZUFYbjdG?=
 =?utf-8?B?VEhUT1VRZ3ZUblo3OWRFNHNCUVFQNmxRdnNDQXZRRkFvVnhpNUU0VmQrQWxk?=
 =?utf-8?B?OWhJVEFnV1hCQ0p3MXN3UmpqMmM2NUZnM2h2aWwwMTJwSEEzZ1NyQXJOZ3Zo?=
 =?utf-8?B?R2g4amxtcFFXdjc4aENWWmEwSzhnZldDRTJGNHQrNEFGN0EvbEsxUmNuVEtE?=
 =?utf-8?B?WlV4TFI0SC9NZEV0aE15VWV0U01PTFlWc0VDSHRHVUlEaFV5dm1sV0x4ZTRO?=
 =?utf-8?B?M01OcytEeis5cnk3cXd0d2hkejdjVEJ0MGVNUVVYQXh4ZEw5TFliZU44ZHlH?=
 =?utf-8?B?M1NoblV5R1VxS0oxY1pYd1R4WU1Fc2FibDRwR0E0UTV3U3lRK0lwTFRxTGJa?=
 =?utf-8?B?K0VTdnlEaXBDMVZNVzRQZGY0WnN2TVBsMFJwbDQzSTM3b0dwSjBCQStDNkYv?=
 =?utf-8?B?WVZZcndsNHRJTnpXT2xuUGVvMW15N0g4K00xcGdrMTU5enpFbXVBQUQ0bFpU?=
 =?utf-8?B?TzJnSFR0a2VoVUpVTGl2L3VPYmhvM3pzdUNPMURiMS84SXFvaTQrcmhWd0RO?=
 =?utf-8?B?OTNKbmoza0xjOHcyTm5jdUY1U0dsS1Jmd2NjcENVMThrclY0MzhEbXFCeWVX?=
 =?utf-8?B?bkY0SDhxS2p4c0xRY1RQMC9LWXZhSkx6Z2dsM1VncStDL3Fmc3VweGJBWG0r?=
 =?utf-8?B?MnF4Z1g5Nks5SXJmZXpSaHhPa3BKZmtheENYQ1dmWHlDcVRTRGNlT3d5a1h0?=
 =?utf-8?B?R05DcnhkNHZIYmliNWtQcUVWa3d3dVhGMDQxT3ljN2lSVTdKaTRJZERDQjlL?=
 =?utf-8?B?TDRwaXlEekhEMXNuZm9sTzF4WEs1YmE3TzhNUXkxdThVL2IwU2pBeVdyL0Fi?=
 =?utf-8?B?Mm9EemdHdTNMZEJOYTRVUnBJM1hRS2h1emdSQW5VM29icUlzbk5BTEFldWhB?=
 =?utf-8?B?MDJESVVvckhjT3NyRWhaYWR2ME10cW9hekNkQWZOT20yTHRSdG5Zbjd4Q2VG?=
 =?utf-8?B?R0oyRVpFemhwNnBUZ1h1bkppdVdQb2ZmR2JjZk10SVkwTGRhejV5VloxOU5u?=
 =?utf-8?B?TzJJckdvMzQ1ZUYzVjZLOFBycGd3R1pWbE9wWE52emZOcytQU1JRMWZ0bW5X?=
 =?utf-8?B?TW0xTHE3eTBOMGpmUU9hc21kM1pIVFp5NnJYRm5yMm9uWHY5NVB1SXJiOUxX?=
 =?utf-8?B?WEJsRVhRTUxDYlNPc3ZTV053dUVOWThzMTBNbDg1Y3FyVk5ZcytLUnFEZCt0?=
 =?utf-8?B?ZXcrczBFS1dsblFSSlZsMjc2WFYwOHk4dnliT3V0VmFTYktqQ1k5SEpDMTV1?=
 =?utf-8?B?NmFuS1R6cHJUK1Ewa2FGZTg4VnkyaUcvNCtRNUZZRDM4NWEyR1FHSzI0VGQr?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bn5sT6CKVolWhVGt8si0dr2FgmBsVWFotxHCF0TusvMT53sgsvQ3P6H/LfzDRuHMWABqty3W2bMf3vqjtvYDwPoQh4ds1L6wf2WxLAg/tVv9w2/u8VxTSrP49qRYADyatnWu60NCF35d1pW/il8Fc4UWaZ/WRLGhKrM9CRSoCtqr6hiB+INxSycJYQs+wJYg0qD2K0VWEhI+JSzz+61+huTzgtdTwz3kRODsu41U3kbsZQOHiuVde2FJtGNjhAoV5wcazcnHN2uoBDCuGu1MzfchloALYBQ9CCfwz8NEe/GGhU3t83VXwza65HzvP/z0kGVvWb2xEULdWAv12qed6Npm0cXY0MYz+1O+VM2zQEoha4Y039Oa89fajRdomTo3aFU57PQ9heGDHfBxeQUMO5/ZoV80pjiPpGLYuEu2ePLtLEqSaUnjSqW18mgb/9IbEnt7K0AmGMPQTkPkCMiIdVmygHAPEhfSD1u9UxwnyBFo7ZBAd2znKbEsJTPSvC2o7Pc+n3XBHEzwXVZFeV4aCmyxPxU2Au1XjUQUSSnzUJKXJ5/PXTzJCzuky0sDVPwmGoNfUs5eVOnNFJxqe45jBy6GyH7FkO8TVM+oFuBuMi4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccfd78af-a16a-4831-0d79-08de2db31af7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 12:47:21.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FHR/z3THNaQZKKo9N/5C9w829O7i3ScxwSV4LZHnIt8FBPt3M8c1q7yQwibscj9F2wP0XnHuW+oR2YR5zdJoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF1D715CB68
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511270094
X-Authority-Analysis: v=2.4 cv=RuHI7SmK c=1 sm=1 tr=0 ts=6928485d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=KYzbY4hRItKLU3dc4FgA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: 7_cAmBDOJlhdlbWNwlHtMXP7mht2smis
X-Proofpoint-GUID: 7_cAmBDOJlhdlbWNwlHtMXP7mht2smis
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA5NCBTYWx0ZWRfXw598fTb5HO8y
 a+fM2JfSMOhyb8kc9DCJ9ME+qcxKzb0emM13mO9/T0+Yv+HtutA11dfkLMFlnD8ir0PM2eJjwyM
 ZbCOeETbT/o6Oks3L3MPZx8kPKKIaEqsRN9YCNVkh5yLIfxuwkxo0/oa3T4l6bNrkCr/voDv9qx
 lp54FMABZcdEm/W7U4F8n//hsfdJIWPrOWVxtBY93HJMz7SS3jz+FlK2l4nxwShWBvf9Kva/mA6
 6gcCNBQFBc/wICpYyl6DGwKz9MFelSiS0nAJ0xnifUtC+Yos7I36b6tWCabJvhtnju8kXlTjWWT
 ysONF52L6aI7j+xFi+bGzqkIDzCSJj9JSEt9I6b8AxZ1PNzyvtSr0NVUyuQmfyzckdT7Hv8gkyK
 mc6k71Fm9PsMofCrViLdSRq+Dr5TAQHWNXZ3mbZHFLfu3Y9oDIM=

On 27/11/2025 11:34, Gulam Mohamed wrote:
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

Apart from some nitpicking:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> Changes in V2:
> 	1. Corrected the command name to REPORT_IDENTIFYING_INFORMATION
> 	2. Included the spec reference to the command
> 	3. In function target_wwn_pd_text_id_info_store, return early if
> 	   the string is too short
> 	4. Check the export count before string correctness in
> 	   the function target_wwn_pd_text_id_info_store
> 	5. Fixed strings in single line for print statements
> 	6. In function spc_fill_pd_text_id_info, return error when
> 	   transport_kmap_data_sg fails to map the command data	
> Link to V1:
> https://lore.kernel.org/all/20251026191309.34968-1-gulam.mohamed@oracle.com/
> ---
>   drivers/target/target_core_configfs.c | 50 ++++++++++++++++
>   drivers/target/target_core_spc.c      | 86 +++++++++++++++++++++++++++
>   include/target/target_core_base.h     |  4 ++
>   3 files changed, 140 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 77da1fc82b8d..c2855f4048cc 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1741,6 +1741,54 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
>   	return len;
>   }
>   
> +static ssize_t target_wwn_pd_text_id_info_show(struct config_item *item,
> +		char *page)
> +{
> +	return sprintf(page, "%s\n", &to_t10_wwn(item)->pd_text_id_info[0]);

I think that we should use sysfs_emit() these days, no?

> +}
> +
> +static ssize_t target_wwn_pd_text_id_info_store(struct config_item *item,
> +		const char *page, size_t count)
> +{
> +	struct t10_wwn *t10_wwn = to_t10_wwn(item);
> +	struct se_device *dev = t10_wwn->t10_dev;
> +
> +	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
> +	unsigned char buf[PD_TEXT_ID_INFO_LEN + 2];
> +	char *stripped = NULL;

nit: this does not need to be initialized

> +
> +	/*
> +	 * Check to see if any active exports exist.  If they do exist, fail
> +	 * here as changing this information on the fly (underneath the
> +	 * initiator side OS dependent multipath code) could cause negative
> +	 * effects.
> +	 */
> +	if (dev->export_count) {
> +		pr_err("Unable to set the peripheral device text id info while active %d exports exist\n",
> +			dev->export_count);
> +		return -EINVAL;
> +	}
> +
> +	if (strscpy(buf, page, sizeof(buf)) < 0)
> +		return -EOVERFLOW;
> +
> +	/* Strip any newline added from userspace. */
> +	stripped = strstrip(buf);
> +	if (strlen(stripped) >= PD_TEXT_ID_INFO_LEN) {
> +		pr_err("Emulated peripheral device text id info exceeds PD_TEXT_ID_INFO_LEN: " __stringify(PD_TEXT_ID_INFO_LEN "\n"));
> +		return -EOVERFLOW;
> +	}
> +
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.pd_text_id_info) != PD_TEXT_ID_INFO_LEN);
> +	strscpy(dev->t10_wwn.pd_text_id_info, stripped,
> +	       sizeof(dev->t10_wwn.pd_text_id_info));
> +
> +	pr_debug("Target_Core_ConfigFS: Set emulated peripheral dev text id info:"
> +		  " %s\n", dev->t10_wwn.pd_text_id_info);
> +

...

>   
> +static struct target_opcode_descriptor tcm_opcode_report_identifying_information = {
> +	.support = SCSI_SUPPORT_FULL,
> +	.serv_action_valid = 1,
> +	.opcode = MAINTENANCE_IN,
> +	.service_action = MI_REPORT_IDENTIFYING_INFORMATION,
> +	.cdb_size = 12,
> +	.usage_bits = {MAINTENANCE_IN, MI_REPORT_IDENTIFYING_INFORMATION,
> +		       0x00, 0x00,
> +		       0x00, 0x00, 0xff, 0xff,
> +		       0xff, 0xff, 0xff, SCSI_CONTROL_MASK},
> +};
> +
>   static bool tcm_is_set_tpg_enabled(const struct target_opcode_descriptor *descr,
>   				   struct se_cmd *cmd)
>   {
> @@ -2086,6 +2098,7 @@ static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
>   	&tcm_opcode_report_target_pgs,
>   	&tcm_opcode_report_supp_opcodes,
>   	&tcm_opcode_set_tpg,
> +	&tcm_opcode_report_identifying_information,
>   };
>   
>   static int
> @@ -2303,6 +2316,74 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
>   	return ret;
>   }
>   
> +static sense_reason_t
> +spc_fill_pd_text_id_info(struct se_cmd *cmd, u8 *cdb)
> +{
> +	struct se_device *dev = cmd->se_dev;
> +	unsigned char *buf;
> +	unsigned char *rbuf;
> +	u32 header_len = 4;
> +	u32 actual_data_len;
> +	u32 buf_len;
> +	u16 id_len;

nit: Can some of these variables be reused? 3x or even 4x for holding 
lengths seems excessive


