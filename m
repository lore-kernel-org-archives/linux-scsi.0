Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E081BF33;
	Tue, 30 Dec 2025 07:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767080749; cv=fail; b=uPuLIWLJX18Gu+/+jApuzf9dZQ3IDabbUsxEDaEpwEP/pYfeikZa9+NE/Grc/DJKt3m0HraDrmOK5/cP+AelRGR7SXm05SflOqcWaDtMnzcOHB6CAnneeQdUQH9Kkb0xZDYOSa9sNqZ5EUmn1ASN6Lc3hQNLcZsdc3cwbF9cytI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767080749; c=relaxed/simple;
	bh=IEy6zQjKZ/EkvrbST3YQEE0JvNz1EvDaK9zLvFfpBT8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L+cnB3BR4onKLnUVswnPBJz1VWp+ZwhX/J0/bPldjpwUajCq4UQiLQxLsIZiT3Z9vZuB/3qRSB9KxLV71tW7KY3Xlmcj+a1HJ7V7KlPPz2Ii2Kzf7Uo6SJFz1viCBSGUEmjeKf54/I48tqZNeaAT6IGfgMjwEjojl9+MCUtX+cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M6ISBtME; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TPzUtvCW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M6ISBtME";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TPzUtvCW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU4xZJD3399635;
	Tue, 30 Dec 2025 07:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4TINpCox2lWQdinR514VPwIfWPvy/2/dW6+eIy+1VxM=; b=
	M6ISBtMEYgZW3Gm8UnAUjYq1OMIZc4iNGOczdEh4qh6R8Ps/AYbiiTf7bnOpQsZf
	WXEGeQc81zLhO9ICqqbNefQcJ1299lE+145LoQY4vq4Vhry98T7MYvVSl8Uv2tCy
	8HoNrSLXelmpCLAbNyonelDZtPEuUxkjFKHukNVCpD5XIzmr6Io/i/zo0TyXREk8
	RcIg85RPl+VpAe4jJPF2X6RbLz8WWInTbdnwlAiF6+WSNKJY6qafd34jzrGqdmFF
	JqEoJrUxLSmiRiEJCGOdbu2OX9j1Nuk4a80EvCJcZX2pePTuYpikgO//ivNUucLe
	93Q981GvShLxGkWXStOGZw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba680jbjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:45:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BU35t7j003804;
	Tue, 30 Dec 2025 07:45:41 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010065.outbound.protection.outlook.com [52.101.85.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wbwxs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHS4lonR57vF1maPpfwIGLqaXLAxdm3TzQns9NbXU70frbsWYoFSj+oJf25hANuhVuU7kS2fbB6NlSugJOm0sUhCWbqg40wZpXDhJ9z1sJ/L8nc0VsxiIIlIY7Ex1jHDB/xym1U/cxZjBMazeKbW5mX1/EZ6Yq6elrxIb7KpsteM+C8Gz3SJ1FYpv89xTU6vOuNqc+sXnYfSa4fpdoo2k7dzuoTVJx+tROssfGo0fGtApdCHkRLl9rDfyD3mRvpt2H9xCIWo+EU8oW2/b8MxIoUTLXVNn3eNF4MGiwK8SLqBEtqdKfZmBIy/zeg0ig8y6bqIhqE065Oellxj2F31gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TINpCox2lWQdinR514VPwIfWPvy/2/dW6+eIy+1VxM=;
 b=NIf4A7YC9T48KRDjnSvGhIVvpCrcyBX7GTNXrKjr8NeYFZYUXXxTwmNFZlZROlX8HIHnkInWKMHlaqIuwogs42DKFapwK67EXUXhEqdNx8qyc8a25/k2cwMFHY0tJWx+2F2Ro+3SeMFfKK1t6xU+Yczo+eA10uB/80I3pnFk4j3er719AR7/RhZoTlbwACvOLcwkbKtEWocHYGoUeQcMek8iF2V/r/jraP5y2CLFJ7WU7XKEK971oX1hC+SoIUEUnXHRFNWn2p07GVi4mIQ4JgmnG4lqOwGxg7UkvTe+TqHBYUiVA+l4eign/+NhHtPFEh8pqULZhzuqJ7iJUljqvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TINpCox2lWQdinR514VPwIfWPvy/2/dW6+eIy+1VxM=;
 b=TPzUtvCWcDmyzXm2fh6SLnsdD1UOdJvwTLZ5IW/t+XYAUKHIBj8IcGZnsx4nUjXoKtfRXSdDnG3WXUTXH8frEndVawDj+KH82uysOnqQtKcvv0pJbkIXTeAxHWQ/0LNR2al40UOlJNfp99O4OsfyslhPtzhewm5SfdOMhstQoms=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4648.namprd10.prod.outlook.com
 (2603:10b6:510:30::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 30 Dec
 2025 07:45:37 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9478.004; Tue, 30 Dec 2025
 07:45:36 +0000
Message-ID: <cf0f9085-6c87-4dd5-9114-925723e68495@oracle.com>
Date: Tue, 30 Dec 2025 07:45:31 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpt3sas: Fix invalid NUMA node index
To: Haotian Zhang <vulab@iscas.ac.cn>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251230031416.55328-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251230031416.55328-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:10:553::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d3584e3-d98a-42ca-e6df-08de47776b24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXpKbFdCSHRoczhKQjAwczlhYmE5MHJIbjljVkdUYzUxeTRjOW04WDQyMmY1?=
 =?utf-8?B?UlNXRGpyZ25FL0RmNG9CTk9OcnpueE9JZDlXLzg0MDlNZDN1a29MdUFpbVdX?=
 =?utf-8?B?QjBHNXNOVC9yeFE0a3cxeGcvYnl4L2dBWEdPaTFRa015ZW9IaTk2QWlkTDcw?=
 =?utf-8?B?azM1SXZuNHViZDU1blNqeTVDYys5ck9LN3ZPekU1MGk0amNLeVZOTFYxbEI2?=
 =?utf-8?B?R0c0N0cxY1c0Q1hrQ2JvZ0EvekFYNmtzcWR4YWJGamZYY2VsMW4zTW9WQzBy?=
 =?utf-8?B?OWhrQmM4L1o0ekJlZVY0aTMzV0x2R0d6RnZGUEF0QUREMnBpUTVmYkVNekhv?=
 =?utf-8?B?Sjg0TWtHL1hua0ZXeWhPUHF1eUlzN0NmUnhiNlh0Mk4ybXo1VkV1QU84cSt4?=
 =?utf-8?B?MFpTbXFtckVPcU1Xc2lPVVppTEhmelM0bUFKTENLU2YwNWxOaEozWTlkS1BG?=
 =?utf-8?B?ZFhkNTc1emljOHhuMmtUOUU3d0RXelBoMnNUc0hCWGFQbTVUVU1rTWF5Vi9w?=
 =?utf-8?B?cGpPUGFlR3liT205ZEJSS2RPMVh3WG9sajg0UFhabXhVbHhZVWEyazRjekFK?=
 =?utf-8?B?VmMwdGkzS3YxdXcyN21OUXZDZXcyQkhseExlMDFVRHNsbFk5YzNGVm9tdWZ2?=
 =?utf-8?B?QVBFbmZxeE8va3hyRGFRR0E1TEtVUTVzZHVoekhNYTgvQWxXQXdNZjNPZlZK?=
 =?utf-8?B?WmlFeDExcFVDSkkyOUFKOTI0VnMzSFZ3ektqb2E0Q1FiRm9taHhqVW85Mnd1?=
 =?utf-8?B?SDVrN0tkWjBDU1FwTHBrcWtOV0FZTjFMeGNPQXVSTXhHdm5JOU1ZY3BUa2FD?=
 =?utf-8?B?WU9SZFdFREVPL0RKNGQ1NWEyM0dIQjJXZ1c1VTRmMEVVcDh2MS8zWFAweU4v?=
 =?utf-8?B?eFNZYUNEVDB2d0xkNm82TlNySGF6bGNZOTkzcUUvaCtzSG1aUmNLSFJQZjlM?=
 =?utf-8?B?a1JrdWdVU3BPUm5lSTBoTkRkZ21EK3EweVBjWjUxZ2NYSGMrelRwVUhZVGtN?=
 =?utf-8?B?VHpJUThpcDAzYlgwZnl0aHlLWlZwQjQ1WUtOYU84bFpPQkxjRmVySmd0TVQ1?=
 =?utf-8?B?OEhCZTRSbzNIMzNoZHIvdzdCY1NjRm4xRW5KVC9jMktEREp6Mk03dlp4VXli?=
 =?utf-8?B?NmN2ZWMzQ3IyUUg2VnY2VFVVMHRLUys4Y25zL0tJckNFVndQczU0K1FBREE3?=
 =?utf-8?B?SGhtVjhtRldvajVVaHVNZkY5T2VKTUdjY2xJNGM3RzFYWjNNWGNrNDBhQlRn?=
 =?utf-8?B?K0RTZzYyMXNsb1Q1K3gxZHpjcUNvdkR0cGxJdDhnNDNEOGtWaWYrdTJhY3Ez?=
 =?utf-8?B?TXFrVDdkaDNPSWI1cmo0ODZ1TzRpRHgwaUE1azArcUZKT003TnhWMU9scWNT?=
 =?utf-8?B?ZlVtZmQ3TTQvaGxMbTR2Z2VKSThOQnpyRFJsVVcyVjRkUmdsUENyZWJza0xW?=
 =?utf-8?B?aytQVjczQWJTcDg0WFZXdnMrVVliOEtEYlJ6eDl5SWt4MFc1eTRBVDZUTnVu?=
 =?utf-8?B?K3Fhbi9LYWhMcExRUERxaGo0UTNaQ3ZndGFKNDRhOVQvOTZuOHpma21LUzhF?=
 =?utf-8?B?MjNMYXdlMnQzcVQvMDJtNTQxcGVMbVlCTTRiNVE5cDBMRXMzNmZBRW0xaEVu?=
 =?utf-8?B?Y2M0QzhOSWVmMGt0SjZJNzlBaTlwcDBDTHY5b2E3OTRsTExJeU1LQ1N1MFRT?=
 =?utf-8?B?TXFnR3ZGWlFUTkZPMGRuMVl2SVYxTDNSUWJHOG9udEE2OG1hdGs3WjkyRkJh?=
 =?utf-8?B?OTVuTnkzc3ZkVTNPd0VKZVlkRG1EVFJ2Vm1yNXBiQVNVNENhUCtkRzNtODFC?=
 =?utf-8?B?M1dKbEVLYXRVaDhkT2NVMWJ2TzUyRWZZY1JHK2RLWkZ0TlZuOVdlNHJZOTZF?=
 =?utf-8?B?S2lpeHpWQWNjOE13UE9KMENZbnFIbmdLRmxwa21TQmdTZHRZaXlZdWdVRStX?=
 =?utf-8?Q?hqLTgQc1JdkbAcx49NGzuMA4SaPWUQVu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmJmZEhJTTFvMTI2SVc1WEN2UVhDMnpRemNOUzF2a0gxS284czFLa3lhTGVm?=
 =?utf-8?B?a0c1V3QvVEdDYm1LdXhDYVJTN2w4UUVtdEZpdmhhc3BIdlFqaEF1ZVZ1eWlR?=
 =?utf-8?B?bC80Q2Znc0hYbVV6b0ZVUVJVVFNhM1J6VnBrQ3dQNHltLzNSNzAxaTNzbVNN?=
 =?utf-8?B?NWU2c3lnYStVSkUwMDFZQWlKNS9BN3pHNGVoQStxMEJiZEx5d1IrMzhkZ2xB?=
 =?utf-8?B?cmxwanVSTEc2Y2ZwUitMa1lmOXNKUHJ4ejF0QW0ycXdYbWtGK1N6WDBDOWVB?=
 =?utf-8?B?M0M3OW1lYW9BVTByWlJqcHpFNkNvUWZ4b1lGSVZhdVVaZGZpblhucStERzNP?=
 =?utf-8?B?N3pRdWFaK29ZMmhneUJSK0RKL3VrZno1dlN6T1A5S1NNOW5ia0pGSWV3RHVM?=
 =?utf-8?B?Zi9LM2d4VFZsNFpiaTd2aDlhU3FyNkdCK2RLSXJuRWo1WS92QkxiV0hMTFNi?=
 =?utf-8?B?bHBabmg5eTNpRkhQWlFzWkZPOTMrbXU1K2wzR1Y0NFE3bFJNaWl4TGZHQnBV?=
 =?utf-8?B?K1dMZXBlVUR0UEx5M0xIRFdWL0F5ODlYQy80VFpRZXB3MC9TQlF0czRJNCtU?=
 =?utf-8?B?UG9GUFlXM1NiclgvZytDbFJNUFlaaXlBb1ZQd2hSY2ZKTTdxUlNGeTJOSkMx?=
 =?utf-8?B?aHpCeDJzb0p2YjlkZ2RWWkJySXVJaWhyVjlGSXJvNGYwUWtVYURHc3NySGpH?=
 =?utf-8?B?cElKN0xoekhLbHEwNmk5UDRPaEZJNEFBQlRIc29yS3hOYS9DOEc5L1lQcVRo?=
 =?utf-8?B?d3FVSmJtWGxCVUNBZ2xHQW5vQU9KTHhDMzdSR2RDaFhMYzVncy9zUGM3QXpn?=
 =?utf-8?B?WDl5YXg4TE0zRGtsRXRVQXdXRHpGenpyNnlGbFkyYnJzZUx6TWhEeHdicDhO?=
 =?utf-8?B?Ti9DcXlsbFRxL1NXcm1rQ0pER0JnT0s2RVhLNWYxUzI5d0JsWTliRiswbi9H?=
 =?utf-8?B?d0l6UHI3aUoySCtmK2hYcDE4bEZWVHRGbWZWZVIydEdpY2MwdFQyenhkbEZC?=
 =?utf-8?B?Mko5Nyt5N1FBaGJIWTA1L2cwZUFYY25YNjN4NVZuWGJSUkcxMG43VWErYzNY?=
 =?utf-8?B?MmRDWndaSTdYaGNsK0s4dHJCUFNCbWVYbFhyd3VBVXVZcURaVVAvbldEK0lS?=
 =?utf-8?B?SlFYTnZJUERLNVYraStlTmtmQ3FMcWE5eVJJcHZxbTEvcitrYThrYVowVHVY?=
 =?utf-8?B?L29qVXVtS1czVW9BZmpHbWhNaHFaU3loblFIRUxZVEJEYm5odTc0NGs3bmM3?=
 =?utf-8?B?UmlUamFTRkFwNDZjZDFvL0NzQUs3NEZmakh0WTN2L1B0alRpajBkbGVGNFlx?=
 =?utf-8?B?OHhyS0JkM0NHbDVyZlZjeHNaL3hSbHVhODRmQ2RoR1lEd3F1VmFSVVc5MS96?=
 =?utf-8?B?eXE4clpDSEJCa0pRQjZlOVlYL0tsZVBIblNnWTJ2STB3cEJhWSswWGlzaG1R?=
 =?utf-8?B?NVgrcC9RY2ZQM0JzczZ1TklvaWJXVDJkcVFLeHE2NEV0bTlUdWRRbHl6dmpC?=
 =?utf-8?B?WEx1QklCQVdldHA1cjRlREEzZUVxTWQva3pSbEpHZGYxYWgvZGtEQ0M1K2F2?=
 =?utf-8?B?cHNDR3M3NUhTd3owbkFWdklEMUoxNVdQbXJRVzZQZ2E0ZHNzM2YvaS9aVk9r?=
 =?utf-8?B?OEVqWno5M3RtaTh2ZlpSRE1NSGhxT3JIcmJZZXZNeFIyRUV4aGl0aWJUYkhX?=
 =?utf-8?B?aVlBV1RmV3B3UXhXWHl6NFhBa2ROamgwTDhRQVhQVzlJK1dtL2ZLeVpnbmtI?=
 =?utf-8?B?MUtIVnVRaWdHVndseUxYL0ZPR0pWQVhGQnBzOUhXMEpnZ0w5Wnlmdzd5bmlN?=
 =?utf-8?B?WGEyK1ZpdXhXU2dta1o5Tm5yMEI0UmUzNlhBVCtLN1ZpNEpEeStOZzRMK2Ey?=
 =?utf-8?B?bjdxY0xhUFlDbU5qZG56em5PbklIQkIxMWlTUjlMODhVQ0g5bC9vNjhzRTBw?=
 =?utf-8?B?cTNQalFyd0lMZG1pRFdlRFByNUhaMDVUTWgwRjNLaHpzL0xlYmR3OFA4QmVj?=
 =?utf-8?B?V2pmQjBONFZHd1JwcEliSm9wWUozcjQ3YW9xMXNBWTdXeTM5ZzdhazNic0xS?=
 =?utf-8?B?Mi9TN1YxeDBzNmhtU3NIa3VpbUozUDVSSW9MeDl6eW44d2RyTXBKUFBrblBm?=
 =?utf-8?B?Ni9LWnBhdWoyMFFPdS9rdmRYU2RCTEw2MnBIdE9yYWNrRFV1MGpDTStDV0gv?=
 =?utf-8?B?MUJrSVhWNzFwanJJWWEzZ2N5Z2s5cDVTUkIwY0QrbW1LRWxaRDdubVhwb0hW?=
 =?utf-8?B?dkJ5N0RRNklWUnFtQ3A5VUhVQU45Y0s2QXBISGxIZFVCRmlJcWQ5QnM3akpz?=
 =?utf-8?B?UmlpVWt5RDBLd1crdytRNkJKZjliVnJiOFJzREx5czA0MkRxaGs5QT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uzf3dwHUC7qj+cGlriLrt4ATSjRbBNlME1G00wHrIhSHLbi14cPwOCSnD8qpEVZ24k2hx1yJyKDiCZ0q6gBHoHhBlDxR5qwWWZcVumJPvmcuOHmhAyMSxGEFrUpKfhMhph1J3oGxPagP5H3WSJWxVVVxOi2IETRHrYGnR0kTk7rROHoGkJMc53j9ekiT14HGA+J/KLBxFjnvVmds6SrCq57PARRN4LgOwFMnY+rfozysxdJ71hMQeB+VEO+aVLF5q/8B53hv3oL+awm15Mt62w8MHC7H0HwbRbU/bZNf8H/iU9kSuDzAvW2Oxa+v1Mt1oBRqdQIqP189MkLcvIsmhqTkv1o0vlREOgj3v8Ax0WW2Io9Hik49ZV6MjAOqok1xGmQE0G8hiymoWJYVb8YRf2t8Rqf1T3aesmLBxTxpHEjp/M7ExEwoAC7mdkn0LsBhsvKGLt65N64plrF5TWfk2AVrcBQBOvt2ZoZtxlP5Nl233Ex/YZOwX35s8xJuVXcu/2U2Fo+c3xveBFtWCJoYxp24m187Gn74we2WiNdNaAuD+3gZGPROhnQ3NXOy4WQ0XUa59Bu3X9Nc/6P9aJbKq4EgcxjjmsaGqzXvfZmdVUs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3584e3-d98a-42ca-e6df-08de47776b24
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 07:45:36.6463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /WpGv9jfwd9mPoq9aBA9j/nBHuXGGmJhU7eTqL6xk+Pg1qUTi7KCNmpOumeQRZpCtA7b/zQOsr75BTX4Blz3Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512300069
X-Proofpoint-ORIG-GUID: 3h8ySiHJSA80iHuIY2Dob-q5n0aomm0_
X-Proofpoint-GUID: 3h8ySiHJSA80iHuIY2Dob-q5n0aomm0_
X-Authority-Analysis: v=2.4 cv=HPLO14tv c=1 sm=1 tr=0 ts=69538326 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uDPWArNiHQLi8KxoHC4A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA2OSBTYWx0ZWRfX2bBvaGsbQA1m
 PvL/0IVc0+D0jnlFBWVr54vZpYlc+KEtxnxm0f9/ORR30dBjJ+8gxXPxt00gjWDhEfHktNNrhBL
 dPVn3GENoveFBIMGVt0UAAlHEwyeELiSTD0JHONlSL1TCWpqnw245AecfoHim0wzlYzqM6KrgNf
 J8h9QCYx6gOWEu7xKiFuBnexkH/4yVJ2nlP+0rhsVpISR03RPrghHI4MrEQxlVUrUFPBq7WH6Ly
 UHGR7viUl4RWgyUF6mJwTjN0zl2Js7QPWNgZB5UFw00qY75oHmT9FNLrQLMmzBa7nQxarfwslv2
 HVTcnAEG8JBfGjnZfQRCkz6zrhv+s6hfWJJyXrJMLvYEMYnT+3KZ2I5YY/E2mSAbkpHZTA75/pg
 uquV9bQy6WBVRM2bf6bHQJR5aTQmsE09GOISCpMNbXC7jgQpzR9ydGBY/n0W4hL+DM+OYJoYSVY
 rDKO8n3hnAhAV3AQVQEvknpMMzqAir8dElne8gTs=

On 30/12/2025 03:14, Haotian Zhang wrote:
> When dev_to_node() returns NUMA_NO_NODE (-1), passing it directly to
> cpumask_of_node() causes an array index out-of-bounds access.
> 
> Check for NUMA_NO_NODE and fall back to node 0 if detected.
> 
> Fixes: fdb8ed13a772 ("scsi: mpt3sas: Use irq_set_affinity_and_hint()")
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_base.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 0d652db8fe24..3fe071e8490d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3238,7 +3238,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>   		 * corresponding to high iops queues.
>   		 */
>   		if (ioc->high_iops_queues) {
> -			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
> +			int nid = dev_to_node(&ioc->pdev->dev);
> +
> +			if (nid == NUMA_NO_NODE)
> +				nid = 0;
> +			mask = cpumask_of_node(nid);

Some versions of cpumask_of_node() handle NUMA_NO_NODE gracefully and 
some don't.

For the core drivers/base/arch_numa.c version, it returns cpu_all_mask 
(for NUMA_NO_NODE) - so your behaviour here is different.

Anyway, how about audit all versions of cpumask_of_node() to handle 
NUMA_NO_NODE gracefully?

>   			for (index = 0; index < ioc->high_iops_queues;
>   			    index++) {
>   				irq = pci_irq_vector(ioc->pdev, index);

