Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8574425DB0A;
	Tue, 20 May 2025 07:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747727161; cv=fail; b=kX3y8JlZ16oPir+RKYnWbyZCLb3GOat98+aYwMZzqxMm/DwOzb18SPWo3In+1vuVWWcQYmNV8KBZe3dGn1EdePVjUMOSlLMnd0JzclQSRzUu8JgmhnEG9X2hNA2/BjgjXvKo6Timntt8eyHMJa7tuKKCmN/014QhDCka/HLVoRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747727161; c=relaxed/simple;
	bh=eLWJqjMcU0Vjx8r9GL15YNdSOS23HeQfZyNLjKGv5+A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kCoFNMpv+iby7jffsC5dDmwtXB2ls33yodWBLuRUJMAYaUSwZmh3DLGxSVF7msDJKiMtfgsVxfI3P9GeuZh3mJ7DYX/Ee7K1T9UgplBM4ep+8T9xbkKrMo3mB57Hy25mH8wW3frqWGYun9pb9IrR1b6G29hb12zpR/+2OOzb0CU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eR3LS01X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hCyQX4JS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eR3LS01X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hCyQX4JS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K7Fnu9013446;
	Tue, 20 May 2025 07:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=miR5yuPCcThbb3nrFj9osBi7CQSW5rzYHgtjCp31Luc=; b=
	eR3LS01XdIOEQKi3gW4BCtOTpaswPkO6RP+fsDaGtkNV9vodCWGseuKTrPIh80an
	diaZSQBDBXQMWPTLhGEoloZCbECKAZGBSFKv2v3wdrp4MLNzh7W4saS8HrEiifeQ
	SgoBYptdovzwJ5GLn/KcoNQ6pOLExyAdQBswSmQ9RbZrNvbBVcUgB1q3pUSVvx09
	vtADA4KQJbBxwZeSXsa4KSIPGLOKHh66TB6CaLq7G9Si09xPLV+4UkavKUfZC4fH
	o9IcQzwOk3WYX/dHcxCUbeEtxtVOjSFji0qqfGhC7nHc4tMjtRlDccfB/i0YC49b
	mkhVp1OtthPn8qTS1wbHqw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rdew8nns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 07:45:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54K7iVrY015726;
	Tue, 20 May 2025 07:45:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw7e0ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 07:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M4FF8F5gTsg7E6K2tvogP+XS7wINqr5EZ432ong/hzB/+0nzTs7z/Zu1gPAZcVG6Kdnsj3IFOApuVPR5n9sEFbpNvLYzW7YghhNF2tqVN7xCoZmREpxJqCoI/2wmeZWpkLRh9BDgESG94WBNyVMyGq7eZBsC+pcJFQZYqfwjOKUGjVUdI3KGDHZ77SiNFfAd1lGDZHFYoblmWPfrnemBeiw0hM0TCI77/YW044wHAofhiD6kbGksv60WuDun3TMM2gRZzXIAOfwaMnjVOlcRwNVI3TXscnu9xCdChU/d5pmxB+Nqr5ntMlUnyGLHik4J1lqKN4vCIHSvb2lbpWFXzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miR5yuPCcThbb3nrFj9osBi7CQSW5rzYHgtjCp31Luc=;
 b=aypXbZ3HbfDK/mLMTH2w5ZKN1ffq4PLzBIhsu+oZQf+cXxB9jBVuMs55e4FWzIKJjVVa8oJFwI6x0oiI1+5QJB9/uNqkZBYbovnAbSZSnx+toyUtb7GOw2/JyPFlU3CL1g+efANI9nbeKtliuuCMHccHainFpzYonLTsF2VxjaPtFP+whbFldSbe+RnGspf6AtQMdXTRt1VgvR6v03Onvdxpp5uORR2tOroGcvo8yB5sxwVA8yo3gCzmO/zwSizL7nT0hjuPUm7XtyE8lsJmun4Z/Z1pOQhNd80PwNATF9PtCtHbOweAPyrNciMgbXWTBUwDIhmQjnPtFwGn2cE4ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miR5yuPCcThbb3nrFj9osBi7CQSW5rzYHgtjCp31Luc=;
 b=hCyQX4JSa0TerFXdFD+M/3Er6LhMRLFlBdxq4lUTBqt8IRhxjux7l9XDRN9GZnm3Fy1bMsHKR4bpZvcmyQ8o8garvj5B0ZyLLNDitQPoY9EgPC+z68PCANCswC6l5qtpbzjADhTVrpn5ot2xWEsrzf1/SzxHPsGlKGkeTjVOEUM=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SJ2PR10MB7858.namprd10.prod.outlook.com (2603:10b6:a03:578::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 07:45:29 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8699.022; Tue, 20 May 2025
 07:45:28 +0000
Message-ID: <8faf7a11-b312-4062-89a5-8aff192ee1da@oracle.com>
Date: Tue, 20 May 2025 13:15:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ufs: core: Add HID support
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
        quic_nguyenb@quicinc.com, luhongfei@vivo.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com, Wenxing Cheng <wenxing.cheng@vivo.com>
References: <20250520063512.213-1-tanghuan@vivo.com>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250520063512.213-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0215.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c5::6) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SJ2PR10MB7858:EE_
X-MS-Office365-Filtering-Correlation-Id: 594a7925-7e89-4267-4702-08dd97724a3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzNPaEdGczBQeE1rZlpPWGw5Zk5LM1BSdmE3enNGelhoZWZQWHNBTE1Xa1Jz?=
 =?utf-8?B?Z0VPaHJzYklMajZZcWw5Ukx6YUhjSUtxU1dYdHN2Y0NuSEdvMWlLdVp1b1BN?=
 =?utf-8?B?NmVmMGpCWUtRZHgxODk1eEFncVVxd2VCQ3VhUG9iUlBnNFFPYjk0SlVTRnZx?=
 =?utf-8?B?cDNTZHBJTmdpQnhwaDBMaVRhdVZmSHdYOWp3QjNDWTVpN1hNaFRXWTVvdUc1?=
 =?utf-8?B?dFlRaDdObWxlWUNYcm15czB4YWVXWnFraEtFdENJOHlxa2VNTXJFMklaTUVU?=
 =?utf-8?B?bzJ5ZCsvc2RlcGV1WE93RU0yN09JRlRkazVkYTFndmhGQ29CMjMya1pnNUNB?=
 =?utf-8?B?Y2pjS3lqbnJjL2dHeE0yWUpMU1lBZGhKRkJ5bnVQNWhHWFlLbWFtY3NnUU5D?=
 =?utf-8?B?dFg0bnBaSkptNENkTEp3aDl3TlNnRjlkZjhySjVIT3BRTG9aa29BQUYxbkln?=
 =?utf-8?B?TFVFQVdNOVlBZTdJZThUYjA0RFVQN1BER1V3b3dMQnhBOWdjUGswcTVkMFlp?=
 =?utf-8?B?aHNxRDZvVGtuMk1JcDFFRXB4cTdab0YzeERjV1kzTmVZZjdNVlhjM28vbHpW?=
 =?utf-8?B?dXhzcTJZWWp4TFNza1J0WWJVSnRieWMxNWUxQWp3dWloalBZQXRWUjdGalZa?=
 =?utf-8?B?VzZScXphRFFDMWdoNjNFTXdxUmZsK2FjSmFpN0FsMTlvcUxFSXFKdDJHcGxi?=
 =?utf-8?B?MTVwT1R1WGpvS2RWSkxJZ1g0U1lnZnFUaDhtaG9FYm9KOXlOWE14Vks5eWgw?=
 =?utf-8?B?eVVoeGlVU2ZVSE14WUFrWjhMVmlKZUt1a3c3dlFub0Z3NnVZV0EyeWZNaDNw?=
 =?utf-8?B?SVhCeEpYSVFDSFFmWmNBZ1NsQXFHU29ETG4zakQydkUxY2xnODRld005TUpo?=
 =?utf-8?B?K3JFM2NGV2VwTlExZTZzNllKRWZzdGJId0tGbUNJalhvekl4dEp4YjdibkVu?=
 =?utf-8?B?Uk1MaUN6aldqeXlWNjV5Q2wwUElVd1RuUjdGZGFWNmZlcFZkWTBqNFJxN01B?=
 =?utf-8?B?MlFUQk1RaGhTK1JyVkR1bHllRGNoREFmN3V0VytBWVFkenZOR2lodTZvclMy?=
 =?utf-8?B?REk1dzhRUVZCRVlsMHRXbDViK1pQdStqS1paaUFDUldXUnBWMnhYNjlPNFp0?=
 =?utf-8?B?TnBUWVBPODRCU1pKZmVJbXNNNTd6MXVWQkxUem5PcjhoRmdaU3hod2pGYkdu?=
 =?utf-8?B?a2YyRmd0ajlSeGwrOEhQM0NxYUwzSWc0cjBEeU1FNzhMV0t3dzJadnYyaWl3?=
 =?utf-8?B?Z0ZSMGJDa1B6dU94WERFTXFYTGU4VkNQSTNOK3dEVEJ4WjFCcGduVzdtQXNw?=
 =?utf-8?B?RmJyMXUxY0VkTDNuMjlxZWc2VEl1RW8vejlnQmx2bE83SWQwNnpnWnR0Mk1l?=
 =?utf-8?B?M3NHcG5uczYwT2QyQkp5bFFLU0VVU3dvUTZ0WUFQNCt4d1R2MXF2RHUvd1Nm?=
 =?utf-8?B?UUZxT0IvLzNsaWpJRVI0ZEt0YkRNM28zMDVWeEtsWW9ZSzFrK1dwdkFNT2RX?=
 =?utf-8?B?azJPbFpmcWh5b2srZjI1Sy9hbUUxSGhyRGJxZmZoNVRyYnQ3SE82U1RZSlRI?=
 =?utf-8?B?c3NPbjRRS29OeHROY2hDOTh2WGw4cFArTkJtZ2tFQnNYU3cveWlsU3lDcE5L?=
 =?utf-8?B?dVF4LzhCVGdWRGJrWWJwdDJTNFFMTS9JeUVsbzc5WVEwMVdKMzI4cmNma0pK?=
 =?utf-8?B?V2I1QkN3cWlrRWNodlhxMnExZGRzK3BlOXpVZzJlWldteTFLdFpLZEF6SWdZ?=
 =?utf-8?B?OGFRYU9DdkIzM2RXMWpnbVRBWXJoNE03VVpRamY1YVFVRWNUdm0xcE9HZzE3?=
 =?utf-8?B?U0dnN01oOG1NVS9oMXhoYTNyS3BPdU04ZU16WHJvSGlqZmxwUnN2TlhyS1Qr?=
 =?utf-8?B?M0pKU3MrVGdBUGh2WXJFeUFtMlBFRkxvNFVkaHpDSkYzbnlQaEZIQWNmRGt4?=
 =?utf-8?B?Y2JyK0MwTkxxUVo0WkNQV01uMXZSUFkyRzFEeFpqZlBkYkQ1Vk9DdnExZjJj?=
 =?utf-8?B?dUpDNjUvYW9nPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkZzOGVqZE82U25MUDRIblJINFpScjYzVzdSdDZRRW5QZnN3dGpzbkoycnUy?=
 =?utf-8?B?VTkvZWtXamdLa250a01qcEVibjQwOXQ0Vm1samdYbXBtaWNFQkxDUTFvQnNB?=
 =?utf-8?B?WjdZSG9MRmtrQTdnamV3ekFUR1FkTXBJaCtWQ3NWRzUyanBlc3VPY0paajVR?=
 =?utf-8?B?bTliWEdhR3JRa3dKWWhTcThXa2pzU2xyZVM1TGpUTTVUU3JhYkdMaWZCTWJC?=
 =?utf-8?B?OFRvRGs4cjNGamhQWDdCeUNRbGx2SkVJbDN4dnRWcVN3TnhGaHYzdkQ2WVRP?=
 =?utf-8?B?Zmg5KzZsOWtwTGlPaFVRZ244UGlUb1kwTllXWm1COWNIQTRISTZRRE9BZTg2?=
 =?utf-8?B?TVZrZHFOQ2NPV0R3Sk43TGxqeTJSV3ZLYXVSbi9JRXVLTVpqMGVkbnNzTzN0?=
 =?utf-8?B?cEF6MVhjUHRJYWdYVk5rOXUrSXV3ZStVTVJ1OFZMVncramRCSmFEcURMY3c1?=
 =?utf-8?B?eExReFFOa1ZZYmJJbFIzbHo0MkoyMFVFMkpobHcvY251dmRaUXQzeSs1S1BY?=
 =?utf-8?B?cklQV3VIbXBzeW9RTWtIRkRFOFZWU0VRV3g1QlpMWDRXM201dk4yNWV6RWtW?=
 =?utf-8?B?R2h0dGp6dEp6Vm5yVmp6enZZcmlSemJtMFhxUXQ0bjdYMkU1Rk9rQzluM2pl?=
 =?utf-8?B?QTBRZzVEUW9Ma05IWUc0OWFFRUZsMUZOYnBCRy8venlWUG9qaFVYWmJnek10?=
 =?utf-8?B?Nm9pOFlBUmZhK0Y1QTByd2o4TmRDNzJLdzYzUDRGeUk5bG50c0duK1MwTGJV?=
 =?utf-8?B?VlhWdTNaMC80NmV6ZnY3Yk5ha21SK1QyR1RlclIrN1F3cmpaNU9YcEVwQ05t?=
 =?utf-8?B?NjhBNUlhdnVjQzl2WlMxNlJ4aEZDSWtmR2tvZkVTbnNhQVpibDYySW1wWElu?=
 =?utf-8?B?V01TaXVUNUE1bmg4bHpqZW00d0FBQkd2bkZyTzNxNlcrZ3BJRGpubzI5T3Fv?=
 =?utf-8?B?MEpQOXdlWVR0OW4zZjExbXpkZUZsVmYzRkxHQXFlL2lxSFNoZ0NMa3lVcTVo?=
 =?utf-8?B?bkdPRlRBY0RQWXM3THp3NWZVWGc1bE5CbTM0SWJQdnVtV3BTSEdiOHdZcHVs?=
 =?utf-8?B?TkZreW9FM0FWdVVUMUN0cjgvR1BkMWhsMU1BZnloYUg2Z3E0VGxDWG5WaHNR?=
 =?utf-8?B?aEdlRTBoejRVRGEvMWZ2RXdDNUUzQ0ozT2JKcVd0LzVYclgxK2o1cG01eUVU?=
 =?utf-8?B?eUdmK3YvRms2ZmZLUXF3YTNEdXZ4dk9scHZWM21WYXIvU0Z4ei9IeEdKajhi?=
 =?utf-8?B?b3FwQkhEZSttSGdLSlpOWE5IRXNReXRUWWs4RmNkSmEwVGkra1JCazNxLzdr?=
 =?utf-8?B?L2sySncvM3FQMG5hSXdIMFJyWWFrUVVUT24vSHcwRkVuUVVoSXpSakNCcExm?=
 =?utf-8?B?dHJVUm9tYk9Ed2UvdHRBUVJQZnAybEl3WGdBMkhMNEJ0TEhXemxmUHp1MURN?=
 =?utf-8?B?bEpSQmZ6N1Fac3lkaHJEZGFjSVNSK3VBbURzQmxNbUwyV0pSMk1qSDNubUhQ?=
 =?utf-8?B?QVlGNnhFYmZhTEVDa3NKUEk5N0g4MEo0bW1jNWFkckE5YmhlR2VJYjd2dm0w?=
 =?utf-8?B?cFdoUEphUXRvdEl1c1VCTDQzUUVpWndmSlZxWGJvZ1M4MUNnVEoybkxFeWFq?=
 =?utf-8?B?clExYWJlNDRIY1ZReXRjVi9naG9wSWZSQ2JOd2NsY095N1lSbk9kTmg1ZUhL?=
 =?utf-8?B?eWl0b0JWT1R4NkJwS1dqOFlUdm9kQXN6VzgwWXQ1UVNpZ1lEelpqR1k4Z2Nx?=
 =?utf-8?B?a3dOdCs0NENtREEzMDdEem1kbTBWbDJSK2dHckFTcUFTRzl2amNsellsenBB?=
 =?utf-8?B?UnptQTYvdHZrYWtYc1ZwS2h1UStFQ1lGeWZSZUJTUkYvdCs5UDM3N1B0cW5j?=
 =?utf-8?B?dnE4K3kxQ0VpVjhWZzd1VjBUa2xUbFUyLzBpWVlxNnZEbmR1bHRva1JXNW42?=
 =?utf-8?B?WWtlQVF3WENZM1lSdWNRbVdqVFRPY204Wk5WbDR1eTJ1dDU0bStlTFR5cDBy?=
 =?utf-8?B?M2ozOHJnQ1dTUDlxT3ZSaGp2Y0JjTms2OGRvLzlBQml3YWx3eFN0T2g0T0pT?=
 =?utf-8?B?bitOWHl3dWtWYnZqMmJJMmdWTllpWWZmUTcray9pTkZzWThDcjl1eFgyakpy?=
 =?utf-8?B?ZTEyTlkrT2ZNSGdsSVZiZjFzNzBSeUVXZHUvU3ZvU0d5aHYrWDhVVXNmckQr?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9mcGQbV9qMiKiCBNHeoiE95WcDxN/n+JzUZm6ZtSSKObnU6vzdLi55Kvur6bnOJUjNeHv/vWPf0Az1Efp6Av+440S8CWKWoX+2PtCExGn+jJ1A+upCRZIvsBNYOF0AmD2vm58gV8hpNGyq5BghW6HBClNNR7FP/HJD4nV+bnypmi4cooF0CtB3jaTEktyVYfU0bf7kDVQLd0a+Bi8zPAjYo38DY8GkR+F4BRMNwnZfym/C9f3TDYTuELHaqmZm+jP4d0LPKwSZBtjU7XGIjM/9QgVJRinR2wFQxoep8n1K/SpMNXAYfO0pp5VOesLdDjOxkYvMAI9E7iqjLy752XbQa9O4YajPptSoNRC+oFgtNi6+emi/djKeimhNnP581fSoxTbnefwnfT0zXtLwC+hAxk7SBKth02DdQXuwKUTZYEQk8lVKP1uiTyatcBROJi6juHPuN8Z+Jbs6UR+BcmR+8yM0knZ13Pd4mGljbWX7cPnR8ewttxrhaojMh3wpXAb06/Ju6xuxQPig3l9wtMTFHtU9u+yT/3t0vqGZ7pnqSPDEfr/aaJf+N1whlq9BrWAGXhLdW6g21bY2341gKN4E1hLN2kDnMy5bYxps+mmTA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594a7925-7e89-4267-4702-08dd97724a3e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 07:45:28.6596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZLuXpoStQDUatWs/BzWVyUo+koPVWjENwn3XZ2VMdkm8N7V3InGOKFMhjZpP1xY2lSukd32MXaIOc+jazaLjWLuJmrC/z+2KWRxhZQWjV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_03,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505200062
X-Authority-Analysis: v=2.4 cv=Rb6QC0tv c=1 sm=1 tr=0 ts=682c331c cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=1WtWmnkvAAAA:8 a=mVlaUz4fsnOXs1YZuFkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: BYb2am_4AWxemlXBie6ngKyoQ7ANDDHv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDA2MiBTYWx0ZWRfXzxnPI+ibJFLz ohOuPNe/6/7jwujjoUQKonKR6ONzXOTYR9N4/XkRNQ5KzzBmQ4yAGAyk06u0XTTQZlbfIVtKOgj kiE7eNN6wpEqy3KQ3X/rFvkpTxrqzwXkterUUq7RKpL8q87R6i874Shogd7CU7YA6SEWH7JaxQD
 d+LYTN5Y7iGs+Usu/3wwxawbrqjSyDj2TVPpOymAzGS6grcWNP6uwsoPN2ckLwwvtmMW5h9YUMO dg9MK/JttLOyEpYru5B3xF8b6rufVa9Y3+vwMw32g10G52/OEOm2gfH6xKKMBb3y5smw3XWIa6q FEH30fxBP/D/IzcKiB6ymYhRDtrIyGBaTGLprXnGU61vr9BD8M6sq+pzWWba8ihg0GwxgYbm1e4
 cK3N8gDyHrNJHwqn1vcQ/NrSfqhEuEi4AmEE7bGOg3zZ8FMJULI4fEV5+cnHY42uQr3Ak5WD
X-Proofpoint-ORIG-GUID: BYb2am_4AWxemlXBie6ngKyoQ7ANDDHv



> +What:		/sys/bus/platform/drivers/ufshcd/*/hid/progress_ratio
> +What:		/sys/bus/platform/devices/*.ufs/hid/progress_ratio
> +Date:		May 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		Defragmentation progress is reported by this attribute,
> +		indicateds the ratio of the completed defragmentation size

typo indicateds -> indicates

> +		over the requested defragmentation size.
> +
> +		====  ============================================
> +		1     1%
> +		...
> +		100   100%
> +		====  ============================================
> +
> +		The attribute is read only.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/hid/state
> +What:		/sys/bus/platform/devices/*.ufs/hid/state
> +Date:		May 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The HID state is reported by this attribute.
> +
> +		====================   ===========================
> +		idle			Idle(analysis required)

Idle (analysis required)

> +		analysis_in_progress    Analysis in progress
> +		defrag_required      	Defrag required
> +		defrag_in_progress      Defrag in progress
> +		defrag_completed      	Defrag completed
> +		defrag_not_required     Defrag is not required
> +		====================   ===========================
> +
> +		The attribute is read only.
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index de8b6acd4058..f162eb36f46b 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -87,6 +87,26 @@ static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
>   	}
>   }
>   
> +static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
> +{
> +	switch (state) {
> +	case HID_IDLE:
> +		return "idle";
> +	case ANALYSIS_IN_PROGRESS:
> +		return "analysis_in_progress";
> +	case DEFRAG_REQUIRED:
> +		return "defrag_required";
> +	case DEFRAG_IN_PROGRESS:
> +		return "defrag_in_progress";
> +	case DEFRAG_COMPLETED:
> +		return "defrag_completed";
> +	case DEFRAG_IS_NOT_REQUIRED:
> +		return "defrag_not_required";
> +	default:
> +		return "unknown";
> +	}
> +}
> +
>   static const char *ufshcd_uic_link_state_to_string(
>   			enum uic_link_state state)
>   {
> @@ -1763,6 +1783,177 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
>   	.attrs = ufs_sysfs_attributes,
>   };
>   
> +static int hid_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
> +			enum attr_idn idn, u32 *attr_val)
> +{
> +	int ret;
> +
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +
> +	ufshcd_rpm_get_sync(hba);
> +	ret = ufshcd_query_attr(hba, opcode, idn, 0, 0, attr_val);
> +	ufshcd_rpm_put_sync(hba);
> +
> +	up(&hba->host_sem);
> +	return ret;
> +}
> +
> +static const char * const hid_trigger_mode[] = {"disable", "enable"};
> +
> +static ssize_t analysis_trigger_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	int mode;
> +	int ret;
> +
> +	mode = sysfs_match_string(hid_trigger_mode, buf);
> +	if (mode < 0)
> +		return -EINVAL;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
> +
> +	return ret < 0 ? ret : count;
> +}
> +
> +static DEVICE_ATTR_WO(analysis_trigger);
> +
> +static ssize_t defrag_trigger_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	int mode;
> +	int ret;
> +
> +	mode = sysfs_match_string(hid_trigger_mode, buf);
> +	if (mode < 0)
> +		return -EINVAL;
> +
> +	if (mode)
> +		mode = HID_ANALYSIS_AND_DEFRAG_ENABLE;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
> +
> +	return ret < 0 ? ret : count;
> +}
> +
> +static DEVICE_ATTR_WO(defrag_trigger);
> +
> +static ssize_t fragmented_size_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u32 value;
> +	int ret;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_HID_AVAILABLE_SIZE, &value);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "%u\n", value);
> +}
> +
> +static DEVICE_ATTR_RO(fragmented_size);
> +
> +static ssize_t defrag_size_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u32 value;
> +	int ret;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_HID_SIZE, &value);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "%u\n", value);
> +}
> +
> +static ssize_t defrag_size_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u32 value;
> +	int ret;
> +
> +	if (kstrtou32(buf, 0, &value))
> +		return -EINVAL;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +			QUERY_ATTR_IDN_HID_SIZE, &value);
> +
> +	return ret < 0 ? ret : count;
> +}
> +
> +static DEVICE_ATTR_RW(defrag_size);
> +
> +static ssize_t progress_ratio_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u32 value;
> +	int ret;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_HID_PROGRESS_RATIO, &value);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "%u\n", value);
> +}
> +
> +static DEVICE_ATTR_RO(progress_ratio);
> +
> +static ssize_t state_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u32 value;
> +	int ret;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_HID_STATE, &value);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "%s\n", ufs_hid_state_to_string(value));
> +}
> +
> +static DEVICE_ATTR_RO(state);
> +
> +static struct attribute *ufs_sysfs_hid[] = {
> +	&dev_attr_analysis_trigger.attr,
> +	&dev_attr_defrag_trigger.attr,
> +	&dev_attr_fragmented_size.attr,
> +	&dev_attr_defrag_size.attr,
> +	&dev_attr_progress_ratio.attr,
> +	&dev_attr_state.attr,
> +	NULL,
> +};
> +
> +static umode_t  ufs_sysfs_hid_is_visible(struct kobject *kobj,

remove extra ' ' after umode_t

> +		struct attribute *attr, int n)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return	hba->dev_info.hid_sup ? attr->mode : 0;
> +}
> +
> +static const struct attribute_group ufs_sysfs_hid_group = {
> +	.name = "hid",
> +	.attrs = ufs_sysfs_hid,
> +	.is_visible = ufs_sysfs_hid_is_visible,
> +};
> +
>   static const struct attribute_group *ufs_sysfs_groups[] = {
>   	&ufs_sysfs_default_group,
>   	&ufs_sysfs_capabilities_group,
> @@ -1777,6 +1968,7 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
>   	&ufs_sysfs_string_descriptors_group,
>   	&ufs_sysfs_flags_group,
>   	&ufs_sysfs_attributes_group,
> +	&ufs_sysfs_hid_group,
>   	NULL,
>   };
>   
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3e2097e65964..8ccd923a5761 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8390,6 +8390,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   
>   	dev_info->rtt_cap = desc_buf[DEVICE_DESC_PARAM_RTT_CAP];
>   
> +	dev_info->hid_sup = get_unaligned_be32(desc_buf +
> +				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
> +				UFS_DEV_HID_SUPPORT;
> +
>   	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>   
>   	err = ufshcd_read_string_desc(hba, model_index,
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
> index c0c59a8f7256..e61caa40f7cd 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -182,6 +182,11 @@ enum attr_idn {
>   	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
>   	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
>   	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     = 0x34,
> +	QUERY_ATTR_IDN_HID_DEFRAG_OPERATION	= 0x35,
> +	QUERY_ATTR_IDN_HID_AVAILABLE_SIZE	= 0x36,
> +	QUERY_ATTR_IDN_HID_SIZE			= 0x37,
> +	QUERY_ATTR_IDN_HID_PROGRESS_RATIO	= 0x38,
> +	QUERY_ATTR_IDN_HID_STATE		= 0x39,
>   	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
>   	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
>   	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
> @@ -401,6 +406,7 @@ enum {
>   	UFS_DEV_HPB_SUPPORT		= BIT(7),
>   	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
>   	UFS_DEV_LVL_EXCEPTION_SUP       = BIT(12),
> +	UFS_DEV_HID_SUPPORT		= BIT(13),
>   };
>   #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
>   
> @@ -466,6 +472,23 @@ enum ufs_ref_clk_freq {
>   	REF_CLK_FREQ_INVAL	= -1,
>   };
>   
> +/* bDefragOperation attribute values */
> +enum ufs_hid_defrag_operation {
> +	HID_ANALYSIS_AND_DEFRAG_DISABLE	= 0,
> +	HID_ANALYSIS_ENABLE		= 1,
> +	HID_ANALYSIS_AND_DEFRAG_ENABLE	= 2,
> +};
> +
> +/* bHIDState attribute values */
> +enum ufs_hid_state {
> +	HID_IDLE		= 0,
> +	ANALYSIS_IN_PROGRESS	= 1,
> +	DEFRAG_REQUIRED		= 2,
> +	DEFRAG_IN_PROGRESS	= 3,
> +	DEFRAG_COMPLETED	= 4,
> +	DEFRAG_IS_NOT_REQUIRED	= 5,

_IS_ is extra in an enum label, or sound redundant.
I think DEFRAG_NOT_REQUIRED sounds cleaner, especially since it's used 
with return "defrag_not_required".

> +};
> +
>   /* bWriteBoosterBufferResizeEn attribute */
>   enum wb_resize_en {
>   	WB_RESIZE_EN_IDLE	= 0,
> @@ -625,6 +648,8 @@ struct ufs_dev_info {
>   	u32 rtc_update_period;
>   
>   	u8 rtt_cap; /* bDeviceRTTCap */
> +
> +	bool hid_sup;
>   };
>   
>   /*


Thanks,
Alok
