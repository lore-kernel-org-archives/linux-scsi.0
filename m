Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE5F1A01DE;
	Thu,  4 Jul 2024 07:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076714; cv=fail; b=cDopwYVMzl7HkizVuDQ4B/O2C1LqJQu6GnTNUqrByZ8DnYMEAciTFEtbPq/7x+ko6Nbk2HJU/HVwdn8rWgbM42hEvilysyVk3uxCkWaj+fPQXT62lue668lRyZauM7I+DtqYKZ0ivjNdtihJvb5sIVEnA08UDIVDmjD6VrlSuQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076714; c=relaxed/simple;
	bh=WsCAeFPQupnEKGzbzx9ryN8xUnB3uW7wm96vTz1Fmuk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BG1Ce8M+ppD8XzInrjYG8pqu0VP71VROhJXDbtJcBnL6pEjuEqdxHzSpjVgeqxaX1+0ZLUDQpG42HPGnSyCtCRYGnvGW7MlUEdX/zOmgCGG1RyiS+Vc63ZaCrDApoFtJ9lJXGMAbDFOektH1koRa+ZZKmSOXWclyGgDA9gu5Dn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EXJZa/rL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w8U5oTc6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EXJZa/rL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w8U5oTc6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4642MVwC013133;
	Thu, 4 Jul 2024 07:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Q7UyQarXQskrABIWuMJAa+ykExjMCj4cqDGzANPizQU=; b=
	EXJZa/rLeCRvt4gcEGzQjhajf8ptcdWw0IHRfGpvvdtofuq4z2ADDUD5p94dNEfP
	JaHDCpFDzZbJAxP0M2ATGNvSAQs4wvtOk+aS07G80qzhfO30FVY6EkCziHaVSN4I
	RoLdmciH5NpbvQFeKG4pMcQZTzxNQfShS7opoMPJhkGNe/FWEVWpQ5xzlx4oRUl5
	iuLF322uS0mx7yZCpWtE9s78YE1tz6jrTI17+8XOm5bm+vQe57bL6lx6vt4o/78T
	5TQYQJ3KdX3JmzTi8XvrF64rnu204gbQgIDgy/NUWJPNBxoRVelxy/Jlkhc0Ri60
	DR1ysU1ywDON5A4lG5B79A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 404nxgk85y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jul 2024 07:04:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4645i7eq010299;
	Thu, 4 Jul 2024 07:04:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qgf94c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jul 2024 07:04:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgOzPf/mNwlKjygUrxRTCySipHsEnAY/HBOKlSgdZHgYIBdOb63Nb2ikpkftZ36iCPePPxXOslIBdGtFsj5LTDcBOlJIgA+2YozKw0vr2xmFyf5XeMMO57Mv29lG/r7SGUtCZrz+tbJiV11Egkcxf2TWhG9dc/YIIqM5um7Gdvw45cLhdZBFrBRHg7bWdiHGhCF9gjx72wInTI1EmStgNb7JTzNBMmQ+i+DA1tQ4ql6aQmz6nTYpI5Af0lj4fJkNH4Lrl67RnHCulxE9JRnGKX9zNdxVz6Wn3q1qBxr44xhWztHnga2DuQouWdl9/zQX82BALo03Jew3pGavEILzUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7UyQarXQskrABIWuMJAa+ykExjMCj4cqDGzANPizQU=;
 b=C2H65sYDtK70LzjBlHVGJpIcp91ndgpco7WwH9EVjBrwb1+YNTp4a9MXuSnVPFuTZ3NQ3wwg40dTUyb9+sl6YyyxKuf4nKO91l6J75CjoL/X/4/kJjA1zi1ouMXDY6pefjRoWn9Z+Ljd/uavvpJT15o6312jBQgN93frPPa5ZEVk3/VBUnByXn+s030xSfX5VUJWFnpBG1GiQM+qplE0Ut8TX/1KZ9FHub/HZzoZO+txKdGzv7XiECdNl4Z4TlRtu/hEMVTCgLSYy1iIN6hqRMWgc1XJlTpdPvvyzsgVSjgwLbMUeKslgigOziOS0IJJ7fSkkop6aa1KseKAXnEtOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7UyQarXQskrABIWuMJAa+ykExjMCj4cqDGzANPizQU=;
 b=w8U5oTc6POthDedCXKZQ2ubOMHRfHOtAFXVyFQ0P9uw6jknCIm8cM57rxTmBidfw3+3D6i7PdeZh56VEg/eWOmuVAhjXS4mw0YZAElfTIC75oFdNoPY0x/NoCEskkFKZndIz53kO150RpdjWC8wRVzuhn8I5iWXfHLAlzj4XCvI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6031.namprd10.prod.outlook.com (2603:10b6:8:cd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Thu, 4 Jul
 2024 07:04:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7741.025; Thu, 4 Jul 2024
 07:04:38 +0000
Message-ID: <3b22bcaf-064e-48a3-b81f-209d1d8ea518@oracle.com>
Date: Thu, 4 Jul 2024 08:04:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] ata,scsi: Remove wrapper ata_sas_port_alloc()
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        linux-ide@vger.kernel.org
References: <20240703184418.723066-11-cassel@kernel.org>
 <20240703184418.723066-19-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240703184418.723066-19-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0071.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e5dd782-c924-496c-216a-08dc9bf7918f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?MnhoMTg4a0RCb1Y0WnNuR003WFFlSUk5NXA0T0plbDdoOWNHcENmbk82aStN?=
 =?utf-8?B?QVRORlF2MS9XRC9Fcmk1RElGb2hUeVJod21uVlpEZ0crWWxPV3J4eXE2R2xu?=
 =?utf-8?B?MDFNOTdDT1JkTENTanRyTHV2UDNRbDNUdFB6TWxBc0ZZaHdpMlVob3NsRGRQ?=
 =?utf-8?B?Q0lzdERlbWpFQWNYSjBiSXJUKzJ2WFE5b3VibXY3RHBJWUNZSHVkanZNR041?=
 =?utf-8?B?T1NhUkNLTHNvdmYwbEs5QzRWUHZETDZPQXFLaG9HNUN2TmlEbi9XcmVzZWJG?=
 =?utf-8?B?L0Eya2RORnJsc3RqK2NuSmFHdUR0Mk54elVkREh2M0pyYkpCcS96cDc0TVJ4?=
 =?utf-8?B?bVppbVdDRHlncUNiRjZwUTkxaG4raExMblRKRmxoU2h1RTk1WXVIRXFnTXRt?=
 =?utf-8?B?bHZtTEsxTDEwRzgwck1YUHBLZVNhN1d4dC8yWUVEVW81L2dDZ3hGbVFpMVNQ?=
 =?utf-8?B?VlZIR2NQaFJOMzdQUXFJRzBES3IvT083ZUttcUE1Qm5ESlQ5K1Rka0tRajhQ?=
 =?utf-8?B?aWhzNnN6MDBqWFhXcUVWUklCbkVLTlV2Rk1pSE9sTDRMRC80d3JzMytNYmh0?=
 =?utf-8?B?dmFyVGR4Q1JGdUphbGM1VlpTTTNNWWk3bE5rdkZFYzE1UncvcS9TNW41Mm43?=
 =?utf-8?B?MzluUU1yL0tmWmFBZm5XS09vM242M0dNaGlMZlFiVm4vZkROb0MzL0dVejZV?=
 =?utf-8?B?NHlPQ3hzcWkyV0ZFSFJPUWhHNDVzY3cxT0NTQlhGa0Y4Q25PRVVGTHpWU28x?=
 =?utf-8?B?YnVFcW9KUy9GSDVDejNJZWhvcFB3UDNud1BnaGhpRVdLSXJiNmdnekdaSWhE?=
 =?utf-8?B?aVEvOXUvTmtxU2hjSUhURTFvRk9UWHA2Vk0rQmdiU1pGazNqVmFGU0ljTkt5?=
 =?utf-8?B?Z1NQSEtad2tPY0luVnhOSmNManVWWUVjVnA0a0ZZYmhCMGhiTlh4Q1hWN3M2?=
 =?utf-8?B?OUZSNVI3ZG50YXFoa1ltZUJDdEhiRUkxK1RpY0lJdWZ6SzUvS1lNQUNRSjRw?=
 =?utf-8?B?WXBLSkV1aXNqOHRDL3lialFhTllmZzhLS1VMdno4WlBZczhVTEFLdDYxM3FB?=
 =?utf-8?B?WlIzeTYzT3NubXVEWitndkVFdEdCcWxNK0J1WWwyZDZtRm8zUk8wOXJsMHhM?=
 =?utf-8?B?ZldycnFseHQ5WEQyUjZ3bk03YTZYNWpuZThEKzNFVXFsZjZxeXliR25yMzNF?=
 =?utf-8?B?dzhXcTdmU1VNZlFFRUN4TlpzSFJJMUNwbSs5b2MwdGl0OEJUVmdROFRyclNM?=
 =?utf-8?B?cFZUeERVRTE4TDN0UVdRT3BnUzh4Ulc2UVM4enkyQkxCL3J2TllhdGRNS0Y1?=
 =?utf-8?B?SFhOQThMV0g3cU1TbTNScStaZHlQSU1HaUxTOUZ5YkVsRFRQZE1rRzE1OUw4?=
 =?utf-8?B?K3Z5MDNpb0pnSFdZVXNFc0FMaEJmcmRXUVFPUUZKTUFuR0tqTy9BRkN2cVpu?=
 =?utf-8?B?SjliTmFzTUE5eWxPM3JYWU1NQWppR2dNTWJ4UldTVVhReWttYUxmZHk3VjVZ?=
 =?utf-8?B?RmdEeWgvM1dWSVB0UEVNNEJiMzFTdTEyKyt4ODFDMzFiUjlhd1FRY05VcTBH?=
 =?utf-8?B?SnZ0cGJqVGxVRWIrV3BCcldMU2NZeG9KNmhLNWQydjdLdjNEcEpJb0JRditO?=
 =?utf-8?B?WHduU2dYNkpaQzF2MHRQdFgyRUZaQ0dkK0VaRkM5VHF6RWdGRjg2VnlkYTFm?=
 =?utf-8?B?NWQ0Z0p5N21rL0RtaXpxQlBQM2RBSDZleGhwRVRtQy9VTnFMa0dCUXBjMm93?=
 =?utf-8?B?ME9DYlo3NDNDemdHSkNxSnIrL0JTUDlFeDFvQkJpaXFKV2tuaFQvTWhuK3k0?=
 =?utf-8?B?ZlhOZUNJc0VoK09nWmdadz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eHkxZ21xQWlsQ2hHT1hZU1ZvcjBRR1R3U0lQMVhqNUlhajVhSGV0MVdMUzJw?=
 =?utf-8?B?ZlJQOHJ6SFVmQWM3V0pwSHV4UTB0WHMrdU1SakxUQzlFMzY2dktVZ2lKZDhP?=
 =?utf-8?B?ZE1ZNTg5czhuY0FvcE1qK3pUZlpCTWRnU3l2dFhHVUY5T1JSQ0c4WUY1Skxq?=
 =?utf-8?B?TDFJREdCVU9RRHp5aVp3cEdVSGxsNlhTZjBtM1R6bUkyZStGY0diL2VBRVJN?=
 =?utf-8?B?cmdNTExoTlRYeFFTaUxHenVMbGppUEdsUktkeUMxMGhkS2ZGS0xiYXhCeVA0?=
 =?utf-8?B?Y3pFQldLUnJ6aW5iejVBSm8yMFdyeEIxWjRqS29iNVlEZWwzYzRjVGhZWjRz?=
 =?utf-8?B?MHFaWDkvcktHcWNzaXZ2Q21Ob0tnVU1LeFdJYW9RQWo1WXgxYWF0QXM4MFE1?=
 =?utf-8?B?ZWtoQmFMcVRlR2pIdDErcmF1T3orVWtlNWtsQjg2SHA4S29ybmFadldFcXV0?=
 =?utf-8?B?VVIxTGR2WmZ2aGNhM3EvUi9reG12cjFidVdIQW1GSWw1WGpkc2dqWm1xdkZx?=
 =?utf-8?B?ZlovdG44ZVJUNEtseStQc24wd1UzK2VGSEM3b2tqajVuNmVZRkxaTS9qdDJY?=
 =?utf-8?B?RmtrRVMxWTNWdElacmlvVUlqalpYUjJpZWFTMnU1YTlSSEd5NW5TVFpWL04w?=
 =?utf-8?B?eE5KaDRhUll2L2dITmRLQUdjK0hMQktsVC9LSjdYZDk2R1I2cGZGTld4dHlS?=
 =?utf-8?B?YUhpckZTSjRBc0lxd20vdTFPSlhySTNFYVZHNGROdjc4TjFmbjRDQWZEU1U2?=
 =?utf-8?B?WllRNmZCN3ZCZTQ5aTJ4K0NHT3NjSGJaSm5ydElWK3dnTm00VWp4MGJibHMv?=
 =?utf-8?B?N1FjWll0UlRodFp0dm12WFAvK0FtWWtZRDRtRUROTmVselplbDd4MG5WaDhn?=
 =?utf-8?B?V0JaVWVBb1J6dHBvZDlYdk9xbzlEOTdoMmd3aklrUXhiVHpQaG5FSmRvWVp1?=
 =?utf-8?B?RWNOcjdYTVVEdGxLUmc4Lzc3NHlpdnR3dS9vZFVpK05OQXR3c0grL0lUWkhj?=
 =?utf-8?B?SmVUMktDdVBNN3VTS3R3Z0wwcDFobi9iUzFqTHo2SnJEREcxWUdFRzJaRks2?=
 =?utf-8?B?aHJVaDBaTjlQakJINjA3UExsR29aVWU5Y2g2ZjZ1WkMrcS9aSU9lNThwUCtP?=
 =?utf-8?B?NGNWd01USUpGL2Z1dk04SlhWaUNWRDk2ekV6VUgyQWI0aG9hcHprRmdNY2oy?=
 =?utf-8?B?Qmxib1YxUDFoTE5ZRzFWTHdpbUdPVWJrZmp5SHNheUU4TlhTOHVEYUtmVEpE?=
 =?utf-8?B?eFp0azN3RWl5Qnd0S1VSRU1IakJKZGxrUGJhcjJUV3N6bnpBZ0RkQUF2Q3Ar?=
 =?utf-8?B?UDIvekw1UkxTZHZQdEZZaDhSM3BUeVUvSTFqUG9yckNRclBrNTBqemRBKzFU?=
 =?utf-8?B?WE9qZzk3Mmt3TUkvMXFmWk9iMTUxTVB3T0dVN0JUS2JYSWNGUTd5SWZSMGZE?=
 =?utf-8?B?R2RJMFNPV2UwUmRtT2NFQXQ3UG9YbmlraE9QNlViRU1OQjliYlVDWTB1SERu?=
 =?utf-8?B?a0NqT09LTURmWFd3MlV6dndEQk5hVkhpU2RpZkt4a1B3K0c1ZkkzRmZRN2NR?=
 =?utf-8?B?WHZNcy9mUnpQYUNGR29TSW51M0xBRFlHeVpTSGtxa1ZQUTRSbmhBcmd6b0Zy?=
 =?utf-8?B?RTc1akREY01GVFBsUVVVQ3pWNFFhdlFad05jWDEvbWNlME1WYTJRN0J5SmpF?=
 =?utf-8?B?Ukx5TThEcytnaUhkUWx3Tk0zTGw5bkRTMVd1eXNRTWtPUEVSVlRUdmt1NHhl?=
 =?utf-8?B?bjc5OE4vbFlhWjlrZlMwK2x1bjBzLzE2RVRzRkhwcmNDUS8wanBpb0pxNVhh?=
 =?utf-8?B?N0w1Y2tYU3djVFY0MW9OcHF1MXpYbG4zY1RvQnBRUlpYQ0JBQ3F1dE15WkZk?=
 =?utf-8?B?TnNuVzh1Vk9UUFVlV1drT2xUbkFOK3ZZaklxTzZUSHlSSS9FSkpWZitvbEdx?=
 =?utf-8?B?MlVjNUtlRjFvNmxxcVBuaFZpWklFaWJEc01zTzdPMkJaRk1QSzNtYVFrTEtt?=
 =?utf-8?B?ZDVQSnVXOUN5dEVlT3VXeGdKTHlGOTVNb0VZb2NaSHg5NVhBbUdCenpsVTg3?=
 =?utf-8?B?eXVVV3ZZMjRhQ3N4ZnBwYXBaaG8wRXZjWnRHZ0NQYXV0amtnaUlobTdqOXRI?=
 =?utf-8?Q?MELknkCKqgzNt4FyAVuPCHvHI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zVvcVMLsK5qnx+a76kd/gxOvZhOzndCS1U6GSsMwDS/2zJJZZzpNYe2UOdAA3oC5K+Ce6wxb8qKV59JTni4gB/UclHIOwPlcYZTr3JJPhUNE5EIBOib67X5/qqBGCR8+yT2IowhoTbAz2gAniFeQzXR4CHvqiyxczVOx32sviZJDpdHLjsxtWbmOy7xD6+jyYZT4MAAWH9Fab+Sc+A1aMhxTE1uQ8sRKd4reGBOEtIA2TWiVMZFbqD5OMam/XggTYLlDKVKBtOAO/3q2ttnBm6VjM7MJbFO2uyROSSaJk0eChDwENP6BsiWAa+KU+vO566O3A77Y6OZEB8yulLEW+mykmSNYjO6v1uL8/MsrNBJRG9lTZzoo11DgHrO39AvsBO5F6vmBfRjibKQdCwj8VV7co4Zbehw9ad3fJem3eJQwxl3WVeMDJak5wFAiLmA4LykZTL5H168ZyMfWqFTXeaCSvT9VYnS2UvoWySQ4cu7edwOAoBzhGQ6hFM0vuTYY31LM89Fq+nRk38u0JMt0Zj80hmYcutbwc99Vfz9O4HDeLXcKYA3jFA4XD064zmV9V4jq3Uui49UOObCYbK+lHccqeXKenCrvTZrCZZYsAz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5dd782-c924-496c-216a-08dc9bf7918f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 07:04:38.3303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lt1kBB8DPqaWV9NJHiIEPsNXkua2LBtfLvoTdmN87UYNqvJDf5Lald7y2h1+CH/g/mtPMpm+kC0NGD1ekbh5AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_18,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407040049
X-Proofpoint-GUID: 5ZvCGYffoQI-u7rYp7y-jBGBlbv-GVAO
X-Proofpoint-ORIG-GUID: 5ZvCGYffoQI-u7rYp7y-jBGBlbv-GVAO

On 03/07/2024 19:44, Niklas Cassel wrote:
> The ata_sas_port_alloc() wrapper mainly exists in order to export the
> internal libata function which it wraps. The secondary reason is that
> it initializes some ata_port struct members.
> 
> However, ata_sas_port_alloc() is only used in a single location,
> sas_ata_init(), which already performs some ata_port struct member
> initialization, so it does not make sense to spread this initialization
> out over two separate locations.
> 
> Thus, remove the wrapper and instead export the libata function directly,
> and move the libsas specific ata_port initialization to sas_ata_init(),
> which already does some ata_port initialization.
> 
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<cassel@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
