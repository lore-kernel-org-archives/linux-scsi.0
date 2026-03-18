Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E94139184D;
	Wed, 18 Mar 2026 08:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773823946; cv=fail; b=GvKrvdI0y5ojcW/OtyHCU3QBIXdCjAtIJNuVUrvqhF16QhhpZAmHmIZTECKP5sf7jkrMa687yelYeF45U/0QJmDvCyhFK2lDfqfU/RXl4FvILKmaZdTaI28s2gVJa1i+kl+YVqPQVg2JI+MpD3KYlHk9d5n3jMUAPu5FtbOLYPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773823946; c=relaxed/simple;
	bh=K6WsNm9v7V1bQC/10EasV7ft4I+3YRtoz9KQKwX2YiM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tM7x4OPTYoqdJDtEKgyMQfT4qLBg15NxluHa5z/hYo0D+Z1SpBaTD704ouILgNyGHQwGVeRlFxlO7EdPsHVRJWhVSZk7Bo4P6xF8wnh4rGShkJggS26xBKlwF1pmE5ZzlVSSFbef1v+esA+giNXwC5uojCkK6/l40iJj1MsIStE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f/0LbWcq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m2d1Cxiu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f/0LbWcq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m2d1Cxiu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I2NALl1711154;
	Wed, 18 Mar 2026 08:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/5TXdfG2stBItccVOdDcppgADy9e/bXGZEFrXp1CO+g=; b=
	f/0LbWcqAHpMdqQfbv1u13e2aVTtMCTHkItRQ61YfQEtV4eaLPHvDv3fZMsJwSAY
	ZJJ96g8xAl+Y5jnEoS+nVn8BlpEFOUWuoQytcaRWvuKBigQj0la6jFDzdTOl7X06
	WZnV+isPhVqhY/x9Hx30tj3BZ/AZcRm1zIFkFIBcwqedmg6EHCTpI959cegceOEF
	CCht/nLsNHtGKHvshECT+eOlH1Hz4EuaUY+XX1ALodZxF2u5hFO0b3IGLBoQgw1I
	53CaCpmWeHgRmqN8KAfMngAKVdrg2alQfMbe91A/iAS3JjnzO/fonF866K0QIA0P
	AHRp++f2MLAIVVcL3dNO2Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj65na3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 08:51:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62I6ldUL003688;
	Wed, 18 Mar 2026 08:51:47 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010065.outbound.protection.outlook.com [52.101.46.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4bb0kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 08:51:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=krMhb2l/3HoeNnSw8HfljaFOo49K5tTcPNehvgMwlgYcgZCSnMHqZ18YhuZCxn/1rzkDHL9U+U2eY8juMOJWuTQStz5PIRRbzzXtaGPlmHor56pRl4WpSV3Qydj2iZdVpn8B0nf+Q+VrLXIAN5n4foBaKK3ylfD/iORL5ZIGf0yQcwaDZr3MfH8Sf+tgYUL4MC3k+VKt9MfJjkVENF4bUdkB1p5qibYsj/HuPz+NczuwGtbqL2lQPPV1s97tUelyhoqUkf2JaMRKzgq9G1g5HyiRDx9W8h+LEk5xkBIKgo+cnY/i6eUBFwN6A4FHw0fmBppwzebSfnqsgaWCCrg1jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5TXdfG2stBItccVOdDcppgADy9e/bXGZEFrXp1CO+g=;
 b=PlV0SAoM6wXJ6nHnpUm3YvCogyz4YZiTXoYigbEH8dCjGa4qh7bhhCy4ffLVWWy+Mh47ViTRgurMdA6AzQ0yOsChRN5ashhRfrCgk95lhR/zaX6cE3S4ejz5FwuI2vIbjLrZcLd32FGh8lfheWbez1JsLiVp/IzXc7xp4Nt7HfyrbLyfSG9zt7Z7QLt4SpfTsetMkbifev6ABwqQMkqafnzK2lt8+1k+hOyqqh+RWilxG1M3ixkJ/tKD6J+Ha1y22qHNmCUABbo2Fmhd7RPLhxblh5/8OY/V1EtUpDT2QfUVBvPNIt3Q6iLslnaNFtwMB9qx615ZafReoZZmwQ1IKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5TXdfG2stBItccVOdDcppgADy9e/bXGZEFrXp1CO+g=;
 b=m2d1CxiufuoBgyRXsy0fZv1ka+X85JHbjAC3Dteu5NZhNodEuDGQX583WMvYXsGvmhugMtSweietYKN4nptrgJg7pBGdh3HKNYhoxY4SVxyDibWtvDeVG5wQFoARTC6zZ+OAskBBNDnYN6zkxZZwLGQfZVeYiWPDi4RpoXJActQ=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by PH0PR10MB5642.namprd10.prod.outlook.com
 (2603:10b6:510:f9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 08:51:43 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f%7]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 08:51:43 +0000
Message-ID: <60c133d2-e9f1-4b5f-b3c4-4c37dd62dbb7@oracle.com>
Date: Wed, 18 Mar 2026 08:51:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] scsi: sas: fix mkfs.xfs failure due to bogus
 optimal_io_size
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
        kbusch@kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com, sagi@grimberg.me,
        stable@vger.kernel.org, sunlightlinux@gmail.com
References: <20260318074314.17372-1-ionut.nechita@windriver.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260318074314.17372-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0278.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::19) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|PH0PR10MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c3058a-8501-4fc0-cc72-08de84cb9458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OhEL5unOxizJFHExSWuqMwQcHGgMCFMQOp3ydRGfLKkkWrVtjfcc4yJE2g3SFgDTbvEkCrY5CH9QIB3kQlGXLDJkhG+vnXhRHUGqy++XhPIR7DRb44SL5HuQmu1IJgmbdHxWzOAFpYlt//GI3fNGRglgfSlTj6vN5VmSUGl+XUW5jnGHKKQXeT5Rv+kkyglzPwLZ0jzzZJzsB0w7Dy5qeOFpkswfyI4z0HUJRJBQ5lF6zvrKhZ8OLCfpNdRrtWjVJLppsabY+IzXIeml23GGXwnE6pKksiqRU0Ud/7z4bH4ca98lOx4xXl30D7kCei9kyBP08f7iKQ50l8K2DTg8uuxgwh6tDMClYF6CLPo5PSpE/iWLu1ReZy++FVh7XmwBshLZ5OI0g2IadtxVDbnuFJ/Jl/4BPIwXkxZYZFqU85CIN4vNpfcuMK3UmliddJKjRD7ltDD25NEJmoro0CTN/7DhNvRntQckdcbwR9/njJHCmfAJThEAGcUPrHqjMQLnCp98dGochZsWGcGEWVM9iqRgnLKbJNfdPqWKxyGz4mHOvW4wAJC9d402R18iPgySagL4DhEujE9ETZLM4LXprmKXSvQPkfW87tkBqopgamK8As3fIah4KsX/rzGA8nhAAB6WT2i0WGZIBY5V3AIgBBJWYX7/k4GqOy9urFsD+jJu73wxfNTM/YsnUp1Aarp1YtDaBopLEaIOBay1AimQuqGErNa9qkxXzHPmhqrZXyg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2Nyc1hmQ2Riem1lbHJTeCtOQko0OFNVMUZWaW0vekRURXlsb0NVTkVVZjY5?=
 =?utf-8?B?SDN3U0kvQ2JneEQvWmhuc3Y3blJyYXhBbXI1YkwwVENndDkwVjFnVXlnckhF?=
 =?utf-8?B?MDZnOGNBRlA4NFB2QWs1SnI1TnZKb2ZRRlN3YU5Xa2JWc2FpcE9MeGNuUkNP?=
 =?utf-8?B?eW1hUVRIbFppaDlIRzhHN0Zid1V0Tk1WRy9zbzBWTE9NemZ5aG1CeTgzb0dB?=
 =?utf-8?B?TGFmTG1vcU9mM25GZFo2Q3d6ck9ZcmhkK0dqTytYM1VzMDJ4ekNNOHRNaDBW?=
 =?utf-8?B?WlFFMXpUVEpVclkrMlBYWHFvNXpLNjdkaGd3WDc4L1h3bkJzYU5kQlRRdm4y?=
 =?utf-8?B?NWliZ1hUL2hWTjVKY1Z6Q3lMY29CVHR5Zm8xdXB0RFgxOU0yK0RXVDhIazdm?=
 =?utf-8?B?QU5HMGdoWERMakUxRVo1YjVtdWJwNlZPYUtldHhndmNqSmVrbUdobUVTR3Ex?=
 =?utf-8?B?OFVQb2lMWHlMTlIxSXNIUTA1Ujl3M0t2Ty81TU4xQXhiRitQQmVPRklEaXhC?=
 =?utf-8?B?YnBEOUV0WklEdnpQMGM0SlFQTU8yTFE5ODFDN3BPN29vc05UR0NJb0J4WWYx?=
 =?utf-8?B?b3NyNDJOaThGQ1pUQmQ1RnJvVkErN2k0VE9tM29tQmlDR1YrOXhMQXNqRnEx?=
 =?utf-8?B?WW5STnlTRlB3d3l2cGpaZ0RRUnRpVFd3WXBDMy9CeVBGeXVxNUNMYktNMGZo?=
 =?utf-8?B?NVFraVZEUy81NkF5M3U5b20wM1pNRkFqNEMrQTMycktyV2JNSU83YUtPanV0?=
 =?utf-8?B?bmg5dm1UUkdvYlVycldZdzVka2Q0aDJPRHFIUU53ajEwN0I5SjBXd0p1RUo3?=
 =?utf-8?B?NXVnOFNlSzcrSW5wNS84Rmwva3pwK0VpQTQ1bVRPYlFuMEw5R1VBUDNHMnFX?=
 =?utf-8?B?MG93dWpkSW9tYVpWeHJaQVg0UHVhWkhSdGdtRHFJR0dyUHJhN2dnMEJQSitZ?=
 =?utf-8?B?bDlMaHkzQkhqcm1YSXV0ZUIwdEZlTEIvNzFVbFpZKzk5Rmh1Zmx4M2JIaHJv?=
 =?utf-8?B?SWdNYk8yY1gycW51ZllDZDdnaEdDNy8yKzNxN0tFdUJQZm15K25BWXdiWXJn?=
 =?utf-8?B?NVQrMGxiQ0JmeW5WaEVuekRHNG44M016b3B2ekdDV1djWkFkQ1M0MFdoRGdV?=
 =?utf-8?B?UmY1T1Q2U0svOWtseWlsNHFadXBHa3oyNjNRQkdYSHNjZHJLNTlvUGV2YnMw?=
 =?utf-8?B?TmtsUzdvcnE1elpnNWlhR09zUzRCMTZCQ0xXUlBleTNKZE0yWllQcEwxOUkv?=
 =?utf-8?B?U1dEWEZJT3lybW9NYXA2MlVPU043cXFOZzJ2ZExXb2llMjlyU1RjWnRJUm03?=
 =?utf-8?B?TDVia1dsUmJLamtLamxMbG9CaHAwcjNjUUFiNXg4WFJ0ajk3aTI5NjV1UG1P?=
 =?utf-8?B?OVhtSTQxbDdxd3lHdWgxaDNJOFdEZ1hjaTFTNlg0ZWR4VlJGQjFwU0s3RlpY?=
 =?utf-8?B?Zjlqb1JpRSsza05QNUVkY25nOHNwREZYeXY4d1B4TjhGR2pzUU5DSW14eGRS?=
 =?utf-8?B?RzhCTm9uZ01BL0ptNlVoU3dUZWtTd1ZDSkVuTjBwN0FlTm1mdXVlNGlUcll2?=
 =?utf-8?B?am1SN1BMRWRHWTRQaUJuU1lYcEU3OEFMN2JrNSsvOEltT0F2MEJlRDZvYnE1?=
 =?utf-8?B?Q0M4ZUdSR0gvQWZWU3MxU2ZsSDVpMWhZOUl3RXZ1NmFadVZXK1YrUlZmd0My?=
 =?utf-8?B?ZTV4VVorTFdVSTFzZnhJNllzbTdXVjJWUmRxcDdXUStRbGFMaTFIOWw5WENW?=
 =?utf-8?B?ZGg0MUppdFJTQytYUUFSVnFTSzdoVUZmdDhJMjZaUjNQSXdnKzIxV3ZVZ1BS?=
 =?utf-8?B?aXluUGxlN2gxb215WDcyL0R2NGcwdWh2ejJLMEIzM2gydXc5ZHlTWVljRXgz?=
 =?utf-8?B?MUhFV0NWK0VUTVNjOTVmYS9WaEF2VkRXME5lYUJ2QUY4S1NTQjBuK05HRkhZ?=
 =?utf-8?B?b3VxVTFnV3I0bWRtN3U0K1V5dTI3c04xRm9Zd3hJUXc1NDhqeFVJL2NEV0xy?=
 =?utf-8?B?UW95d0srZ0diWjV3OUg0OVREa0VlK3dEaG5sbTB0eTBBbWlqVlpXM0ErcVNu?=
 =?utf-8?B?Tlp2TlVYekpSeEgrcU5tSk1ZQk1XV1FsbmorV2ZKRzNnMlE0UFdZNjdPM1or?=
 =?utf-8?B?a3dQYXZVc0ZWVUFOWGZiNGVZaXRpcC9WK2VyRXNWRVN1dUxkWjREcHVPd0ZU?=
 =?utf-8?B?cmh5VG52UlVIdVJ4YVR6WWg5ejNsUmdQMlB3ZldSa2NDcUVpZURMam5Qdmkr?=
 =?utf-8?B?ellFbjRuRW00TUxVYTlLb2ZZdis4L3RrY3VYZC9EWFpQK2NTa21pcUJyZXlY?=
 =?utf-8?B?aDF0UVo3bDNhaFNxRmdLM3hzZ3loYUEwakFCcmxSclBkSWtLVC9Dcm56WlFU?=
 =?utf-8?Q?xcALuuKytY8qg2NI=3D?=
X-Exchange-RoutingPolicyChecked:
	DsomD0kEAGDuznkvoLLVXqa11CBmQFsjYzukTxGxs1lcCg4wKJEDydlDngychrERhOn53HmnqTbt+Chj3L6XYkF8O9ONrHj4J0FM7NJUZZFCYbjoPZHGyWEy7RAQhz+IicyVfb7RezYkAl4F+WGgrELXKHNlYetf1B8h/cTYUyXpxiUyW8wYQxU7pDIYtLYCJ8LKsYXbiyV8ze5O88YH4Skq0au9kW8tlArAUlXaZ9/IaCc0Ujd7p7mRCLvKICfpcHXMB4Bhcd9SBEZk8xNPA0tUywlM0qL0A/qopkNAfmWvwrZPKIFVQwOGOcpV8sYLZHyxPDposyOao5BcgZgZqw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JZXvWgoSlw0l0rpQVZs/ytrTkNOO4UXNPBRFf/zJNggML+mPaonLYuG3m5dFSvmy6uUm0Qqa1MAojGPMIeshhKddEUmtMtejd3cL/9tDIMXUbeDhubYAt6EsRY3x60s/jZ0h5e9X3pjWCHv67mVobfgxFqYSSfl4R3SdxsTLKoDh+g363gnyVdIjUUsgm7ZBq+M5dAAy3Cgux/wfhL7jPKazPSnU0oCPfq0IDR+hPJdu88shlItFIoPS+QPHTyz7BSya4hRPdQxCPhu77SzvHUHLRc2hDks78E7EenAls4Gt7NRCpkLJoNQGh8hfsHDBQ2S6GtnySTM8mZ9DWJtz/TRVtFeO/q90Xk7qzJzQlQ32Dn6z/4Su/9zN2lULW2uC2pAjDvfEQcDMcQzLLkFuN96Hg+3lPUJcBFJqCCXTPCUWP4Z4FP8fg0QWYItpNjP0fFg6A+TLH8wojQbLQP/sBu/s3QA51d+g94TiPi3D0D8c6XIF4x8UiKPoWMx2FuOyeofUA4LgPI/BbQzxTfh2Xbt0jfQDG0/FIZetnSjf0Nt0CMXpGSZrGsJLRqOgTUq/IlihRvt1rudfI9MoaxbnVagotqJ5kWSwH9AV8Qxl1r0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c3058a-8501-4fc0-cc72-08de84cb9458
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 08:51:43.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAkBbWGzfRyRb+LxwzLSpGe0CcKxBe4WKbRLfU90K0LF0aXX0p81dT2HZeONGaJbfGx8lBCPyUfH/Hf5AZWWuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603180074
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69ba67a3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=RzqYyRu2LyB9E_pxa0QA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA3NCBTYWx0ZWRfXy/k5jd3Tdkn6
 U8tkxj67dILWePJNas4lRV4pWtHgm7BJHVY9oXXk8A45Y2OlL/eNe2YVhGaDjvq4ZOSPxn7d7fV
 b/YIl55P5lrSzlCvY5rWkOoCHXHUPcb2LlKxrP/4eLar11tHepbv4KNNK1cpjny1vDvH3R1N6Vp
 umHa0y3Ccxqt/KJkMEVILKGPqAlPRtQ5cEYO/+Y9k6AGcqiYfRK8aHtnZZnqVDL6IZJDB9huwj9
 wpPTipb5ahHkZKsi2DbCr42motMj+MqpQlzVwNnYx/q0xGjxKYwuB1A+HC8ItZVlp0ApDdgMI+k
 Pd8ulk0qhUyXAagIjhOBEiqkVyVvP4Z2Gy0M59SMqffK6fG/wcN/dgOhzXI+C4uh+pUHLG/KWiJ
 Sjiyf7vTi0BGAYm43r3IY2XPMpJh/2YrVA1GgXHhVJi7rcqFQsL+57Tyf7xlZCgHlvG3G+2vldW
 T/sZZnCZc9Ak31aPN2A==
X-Proofpoint-GUID: VVXSMGdynY-GxFcFyyzHDfnY39fNFHoI
X-Proofpoint-ORIG-GUID: VVXSMGdynY-GxFcFyyzHDfnY39fNFHoI

On 18/03/2026 07:43, Ionut Nechita (Wind River) wrote:
> Answer to John's question about blk_validate_limits() rounding:
>    blk_validate_limits() rounds optimal_io_size down to physical_block_size
>    (4096), but does NOT enforce that optimal_io_size is a multiple of
>    minimum_io_size (8192).  So optimal_io_size=16773120 survives validation
>    unchanged — it is already a multiple of 4096.  The mismatch only shows
>    up when mkfs.xfs divides optimal_io_size by minimum_io_size and expects
>    an integer result: 16773120 / 8192 = 2047.5, giving swidth=4095 and
>    sunit=2, with 4095 % 2 != 0.

thanks for the info. I feel that that io_opt should be a multiple of the 
io_min and we should enforce it in blk queue limits validation, but that 
can mask problems like you have seen.
