Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794852748;
	b=aBykIjwRKw5+Kg/Z+YzPhcan0rFpPVpQNjCg/+qW5wpzf1qTdQqy0p9I7vDeAlUjozUE
	 CkhFGM+PpC1M53eDqp23eHDNi/zDMX0EFDeWYlT8y6qn85uT3BFE0jdMlqCfc8yW1eljj
	 NkjSbCXn9eUxUgZO5ZKJcbXCziQgjIdoWgoAYSSOnfWRX5Nf4L4Eo3Ey+4c2H6vnGg4/N
	 Fc81RqmRrMg5YXdO3M4KUA82dAVCkYNcmnpkHyXCwBkrF8sfH+tNBoTDtoVHGT+z354Q3
	 95L3GoCADPe7pPLSRLLBjSkLmoEJw+Xwi8862Fg7ZbX4olZcpZkoypXzJUCyR/qx7wQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852748;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info;
	bh=tZEMhVhvQVsBWL6mcpU8XuKPTHjgl3WsqlPzgbARyUc=;
	b=OZQrj2ZLOuao9S4IYlMeqTlr1NMGStgQlyYGJNuNkyn1Y1dOvpxJZk5WGHggJfpOx2cZ
	 rhjuHtY7YN73+FEVszBI5X2p8tACuYB+hIYzEiulxBG/+naSm6hhT2YWx761PveYQgmkJ
	 BZ0GMnBHVsB0SHRpAseJ3bafej4+/RFaHnDs7XBKi9POR8EqyvYA3VCsk6Q5nzxRLoI+d
	 rNcTJrYgxT5yOfNas5V84dqbs7SfLvt2S5ej0pKx08FLPiRf/cZrJIVSkXfAZxB1Qn12S
	 xT4uZZ3L4+d5fuH9huYYENG2bn6m7lW1MKaMW+uYGhtdAhvCEnTCDniUNBjDGAuDANg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=f6uivudx;
	dkim=fail reason="signature verification failed" header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=DITdZdBz;
	arc=fail smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC20D606A31C;
	Mon, 16 Nov 2026 18:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC20D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=f6uivudx;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=DITdZdBz
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGCB4Cd1468610;
	Mon, 16 Nov 2026 18:12:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tZEMhVhvQVsBWL6mcpU8XuKPTHjgl3WsqlPzgbARyUc=; b=
	f6uivudx0NKFet++CzN9yTtXM2kJEzhwHvmINfIjHZ1M3vIQxL1iXJX3xREUBdnu
	xklD07QmPlHT6XC/kB42pVEOTtSIQMC4ZpRf437n8rCcuIC/HXOtjZUdj/KyfxZb
	onFVOgGratG/XHGqnWM1TT9JAHP25M/oMuNS55+xPhIc2tY7j8QdGYE7WyGjlwAT
	bIsGLiqm/+Av9n68QNc/Pfr8KKUcmSno+nPimKyq0FBdk1fz0j5/i9ZwMMvynVmE
	qnJPKdUEBTkgmiugj+PMAlE01+z0AVc20lGiC4z0HsVpe7VM1bM+mOEMHYH4ypm1
	2qQfFqIbycQObxi8NB/0IQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hxe2e2m8f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 18:12:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGI73DL3747574;
	Mon, 16 Nov 2026 18:12:20 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013046.outbound.protection.outlook.com [40.93.196.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j066ahvm9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 16 Nov 2026 18:12:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2aAZNtjrDAeZqbWx2LsYEYIT9XOt3edu+kZHckHnKtxezazo2CTLSMtmbuq002qLm3/P3kBjAIa02CGjfC298Mx8lK2lCroCp6WB+VXWBkkzRu46HaooAj0ig8Mf51vBrb+FdMv2jEhpHvp60W3t/ErDgyxsJY/mZvlt2PstjmnHx0CSR5+lEAeLFUhKXBJoBWRNdb4Nsgs87FoeFhhWNxJzzQErgQHj+H1jW4qojRgSd5kWGOr5XkLJp+MyWdeU2mh2lyw9E3THWyN4riezscpaFuO1Ntdgwne+qGv7uDfmtmBmtTMegqZW8NJIv5ZWwSFUbg3dy5pR8rXyWu+xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mi8dQ99Q7hqhUYKuZavo1r36HjD0BNkbcGWGffH0MjA=;
 b=vm6Umeul0A3min2et8+/WdV4y64urs0JFS04IWLHoTsWvqrcih2/P6MYsfz/35vd2MseK5ISti1WpuX7qfUgZoYlaNkgxDWK/W4CUoS9rduum3AYY9ktNF1OwB4wTVPCqhEtbObOBznScdeojvKKwk2FEYRF1bGy6/wV/PSD9QpkYcefXRDMH3syunc8M3dR0fmaUpNXuWkNCxxaiDyJA6i6QAqm37bTKJ/lT8pvXaxSpvybqb+TftK0p8vFiytkM9myX7E/Ihm7Qv3EQODSC37MfWUe6UoXaP5lPjOoFrlGPMRW1JGDmf2b/R3J9e0DUWZQhLSR4YF6bMbzmPkeeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi8dQ99Q7hqhUYKuZavo1r36HjD0BNkbcGWGffH0MjA=;
 b=DITdZdBzB9BCrhzZ1GxnS4yHMyfDDVdqAvjeqQQXBIAElUmQi4rz5iQekR/H8FBwcxpezBtnukJdgYfRvXbgH82/6hQGDwMe9H42j6E3g/byNLU7iGSuixTO17eX6Ho7oATB9uJ1ta8jVQB/l+8d0/hUBwdqUIpujb59fSHRMgA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CY5PR10MB6069.namprd10.prod.outlook.com
 (2603:10b6:930:3b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:12:15 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::903b:7d56:3ec6:a45f]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::903b:7d56:3ec6:a45f%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:12:14 +0000
Message-ID: <4fc02402-4ab3-42d0-8dbf-d0a36a125e43@oracle.com>
Date: Mon, 16 Nov 2026 12:12:13 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: iscsi_tcp: Don't read sk_user_data from the recv
 work
To: Praneeth Balasubramanian <praneethb2002@gmail.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Praneeth Balasubramanian <praneeth@ucsb.edu>, stable@vger.kernel.org
References: <20261110222403.205332-1-praneeth@ucsb.edu>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20261110222403.205332-1-praneeth@ucsb.edu>
X-ClientProxiedBy: CH2PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:610:4e::26) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CY5PR10MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: 1926013a-6e41-48bc-b7f8-08df440d2445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|261009223027099003|18002099003|22082099003|4133799003|261026121527099003|261026140227099003|261021121427099003|261021135927099003|261021123027099003|261028144727099003|261102123227099003|261022105027099003|261022075727099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	MgQO5bLXQobZH03ZzhBBOF+kNbpTPVBDxyafhS7ierFu5SRfZMLvrI/p6TtIaWNankzDx2aq3wbidl6zw9N/odW+e+owMUTVxSbYzhOFoQZ57aQZejqZuqZJauWHqRzCBAyj76Uh2aUJGykT90gzKJe6O+Pyk+e0OLCUA1SKTwBHFGBwvxaCgcy25HmVOMNRCsC+sMwVvlnTYvHhK8o5kW3s+fH/slPd6BBW+TPxqbi/6BJxYzdoC3HSmkoNuGKwMqOWH5hlForCSRnFQZl/tIc16izcjs261aE2elB/2MZBPc6eG0ad3s0OgWoXW0MxUewgnjgY+85pvOkw09pFtjGPa6IY8zbP+afr5WcH33opLJCxPKQT9dt4JbJgeM/6N3aUs+FDOfvd8IXNL/qYbTXGUpHLvrYRxNExqGvqozKX5F/g0gjZCLtitv1JGLv2yyAYL+TbjqVuFPUN3AMC6M2fcPuTXALl8EyAtFT07HFTZpSw2ylLZ0R3LSuLcl+R9p/LJY/cSCnuWCU6XfCOAMKbFPp8n6t/77AMovE6WxxNEPXYxdagaFeZD7w6F3dcSh3zXB+FTxJQtKAPdwX1Hrk9/SdAXd2+5hGfosP+BvfMiX89oDwCeoSU39ENfIipckNWxeitfFrWKBpGLn6eQE3zR2xzeKJNQADTC4Wntm0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(261009223027099003)(18002099003)(22082099003)(4133799003)(261026121527099003)(261026140227099003)(261021121427099003)(261021135927099003)(261021123027099003)(261028144727099003)(261102123227099003)(261022105027099003)(261022075727099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2o1SzE2V0sxOUpCeFdCZXRFMGxtV0hsb2JFYzZZTHdrTDFBNmh5bllFTWdY?=
 =?utf-8?B?ZWdUYklXSENVNjlHeWwvSHJUQ1BqMGU2eGVheEhOM0NtOXBRd1BZaXhjUkZP?=
 =?utf-8?B?cVdVWXdUU0JxbDdZMWlzSlZ5RjlENUZnNzJlSDN6SWRKMldKU3VIcnhSMFYz?=
 =?utf-8?B?L3lKblRKUVBWMERQREtiam1vQVhWSFptR3FWclhUWHFTZ0JibzNIRmZpUnBK?=
 =?utf-8?B?ODluaCtjWWlvM0o3N2l0b1EvcTZnUHV1U0Y5ZEF3YVd4NkdzVDR3c3dFZ0hv?=
 =?utf-8?B?VXFuTjBxbEVZSVQ0V3MxaGVIaEt2T1BqQ2JWOXdVTWF2bnErSGxQbG1ZbFg5?=
 =?utf-8?B?bWdCQW15S1lYR2V1WXNIZDNDamRES2NMdC9pLzViN3VIU0dxOTRWRGx0VjFS?=
 =?utf-8?B?Zm9UV05DdDRORktyMk9KVGdZcCt2R1hDVklqZVB0Mi92bkRLeGhwU1cyTGhy?=
 =?utf-8?B?MFAyc3lqdWZHVUR3cGNzeWhoUCtyZUxDcHFwWGRwakw2MXNKUG9CUzFWNGk2?=
 =?utf-8?B?dVZiTzllVHJNNXVlbUFNMXorQStvWFJTL096aVk0SkFJcks2bW5GKy8yQm1l?=
 =?utf-8?B?ZTcwNUdnQlNOY1F4bDFOZ2lPNU1FZjdnVkgwZ1VTc2ExVkJlQk1uaTFEclRk?=
 =?utf-8?B?dlNaK2xRR3d3YnBLd3ZsUHF2bC9weVo5U21henFwNTY0SVJnZ25MUk9UbjBJ?=
 =?utf-8?B?cWxsOXFJRTlOV2ZubVA2VWw1eUVnMi85VGhyMnFCSzB5c0dPa3NYb1NTZGlL?=
 =?utf-8?B?eVNXSUFjL3FaZElQbWhIRmRBSUZNUjZkNDZ6cW15alNpaHpheEowcWNMLzkv?=
 =?utf-8?B?aGt6Mi9KU2FZMS9kOUh1a052ZEdvVFFuZU55VmgyR2VrYkRqYi9aS3FIam90?=
 =?utf-8?B?blpmZFZGV0JydEJzZHE4cHVuWjhvU3hPQ2xXd3EreHFOSXl5K1lCcWpPMWVo?=
 =?utf-8?B?ckF3eXAvRGRkdDJwU2NjQktoSGIzVWM4MGNWNEZXY1E4ZWg5b0F1OWJTbnpV?=
 =?utf-8?B?SWhwcWNBQ1BQckF2WjRpRnVQNVB3Q2R4UGRYekk4ekZEcEZkaFY2RmJnNDAv?=
 =?utf-8?B?eEFEQk9Ibk52TnAzeVpuQkhTSk9FOVdJd1NqeUtHUUFDTlYxUUlwOTRkK295?=
 =?utf-8?B?bEpmcXYvU1ptNDk0U1NIM0Zsb2tmU0VyVEF4MU9Ld0RKL0tOeHZEWUlaZk5L?=
 =?utf-8?B?WFB6dVBrRDFwZ0ZKUE1kejc4V2FXWERqWEpxMzc4L0pHZEtGVHI4NkZzTTNp?=
 =?utf-8?B?TUgrS0EreHZudW9QN0Y2SGdCUEhMUm1kTXhTd0pzZytKUXlSRVF2YlpKdmpM?=
 =?utf-8?B?NC9TNm54UkpJY3NOREdER0ovekhzZ0Z2NFFxa09aSWo1YVQyQWFiNEg2MGRX?=
 =?utf-8?B?TEJERFZoSkpGeHVLWTc3dHJZbTlMV01wdFJqMHcvU3JtZGZIUXk1aHVicjg0?=
 =?utf-8?B?VXNGL28rSTFtZ2doMWVva0U3dTZHeHlJcHQ3Y2g0L1RicHJYRFppYWIxak51?=
 =?utf-8?B?MDFlSFQ4YngxWVd6T01iVWpmUHgzY1ZMc2xSR21tOUdTV1lJRGZueXhnbUVu?=
 =?utf-8?B?UFFWQnBQZ3k1NTRDbU5LalZHb2lxbHd3NWdZaWNvdUljWWlQL0o3djBjV2pn?=
 =?utf-8?B?RXVFNDdObWpZaklPSHNCdmsrT3NERGdIS1FWOE8vbHAwTEowQUZ6Y1NIeFVX?=
 =?utf-8?B?ZWNaaFQ5MG5VNFJRdWZJMktBd0Y5QXBzcmNPTXlTU1dwYkJNU3BoKytqM3BJ?=
 =?utf-8?B?YUFrLzc0VDhlbVpkSC9oNGpGZHdLWExBOUxvcjhTRHlHbWlyZWw1QjI2ZkVv?=
 =?utf-8?B?UDlBSTVOR3FpZVFtSHl0QzJiOUk4T3o0eFFTeFdPVGFwUHhoZVM4cjFMMFJD?=
 =?utf-8?B?MFJjMFY4a1BVQThtYzlHV3VQL09ZMU0rVE9yeWtMZXVIaGw1SExBekM4YkJm?=
 =?utf-8?B?aDVuYXdTdEZrNDI0b09pcnZaK1VIbzc3UTJiMXI1V2I0eGZ2R2Y3NERuMk1v?=
 =?utf-8?B?V1k4ekl6UFpnb0JXMHR5UGwxamovdFUxZDJ3bE5MZ09hL1hlbHJIY2pRRi9S?=
 =?utf-8?B?SmNGNno2RnFSM0VUUVRxSlNWSisyQkNYVDc4c0l4MlU4dGZuV0d2SDRFdzgz?=
 =?utf-8?B?UmJ0MmQ3K2YxV1dBSVFmR082YnJleWZLMFhCalg3bUVQa1hkbytTNFh3dnJT?=
 =?utf-8?B?MkFqZzdQbk0wNmUwUXNiK3FETXJBbi9jck1hMGFUYmQvU2syMSswR2lZcm8w?=
 =?utf-8?B?M0hXUXVUWDBzV0xmRkxHdUFxRkVqUjJFd1FTUS9HdVFaUnhXdFNCcWxrM3c5?=
 =?utf-8?B?WGVDVEZ0cHY1ZG9aTzBWS1VIVUxmYnhHYkVYL2hxYm5hTlhBU3lraVQ3MDdJ?=
 =?utf-8?Q?4DaGfhv4MF7c2w9A=3D?=
X-Exchange-RoutingPolicyChecked:
	nFRrG3zBQmnWAVX4RiuWRYxZ9PGvxlN8yjWzI5h4dbIAZMhmicUCNTApQGhLcwQ6fhcclZhlf0v1H5R+97Gtoh6zQEQ/8qg1ffiIc015oE47XNYMCtbnej7ooV52O7YP0yPkab40dQxAzczTFqu4J76V7o328KPzzMU9wv+8MfJ3BV+9yzSzYizVaCCikya4HhV0v5lM7dOP0b5y7+ZBRusrcv35Xg3j+VXsDSuL2QVLG/luHQVxxzpiLQ364HdFQ/y695wyUvOeTGCOQgdwAcpaQyoaUqr/yt9Vhlu2mQ+SmRIxs79Ya/GvyLhFvqRrc5IjIUZZSFbnQ+NHfyqeyQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z2lQrbMj/PvzADNOijJgtq+67MKOxm2OcMW1A9c+fbbl9jCg6ESozAgmatmxejYQpZKIN6RKf9ao+bbMBf8/mrvUSiyfo20h1sWYoywCBkflNwm+ydD9VOWbFt2h6adbsp79ZTyTyWZ8LSGIULFDcAFScU6vWkqfQECAxlwO6oX7W9wFnwZn1OfB1UdxmLnV8HKUbYyyrJd4X4ZkhIYo95SDUDIDh/wlB73SatjaMiIfp/EOisWEjhpzkfSWxVUN/Y+6Io1+QPL2lgj3dUxRxo37T3rGoGjBNN8FMPOGrNjKWQrZMKR9yNgn+C1dVAE1Sj+8HveCa0JPJnrsRs/zuw7FFMeyqj3pfgZ0DpVMynb9Xmdaoj62Xq3NSilNtjc8UWwjY7A2dVletRg6c08UWTZH/is+USNkbRW04xQ8aF+YXERkO9B9fjGTkPWLgFdWRAM81sSqBE8ZPPJrWDgaD2YtjDSAYrIjvTt/g3/uZxkkx/zYO3fmhS6cRxcEq3fTBRrP+yLGGJJ7Fq5YHA2Roi2+e353tsNtj/lcEjdiuLG55vE/n7UU3/MlQqAAVl0MhCnLeDWJ/Z5aDG3oqY8BNvGWnfpTrdSscXQeP+JeJXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1926013a-6e41-48bc-b7f8-08df440d2445
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:12:14.6086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xjRvjqAC+mFEGxDAYMQy98/KYN7j6xkTMNLFUmj91/bQNfRZJyU6Sd0rjry68oBaDZV6yQ2QXvUOZeEPhElGued0WhiD2LkirXIS+tXXBhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6069
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160072
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA3MiBTYWx0ZWRfX8tnZeijiwAc7
 9qYC+k2cexVJIwXGkLZVuVUPQus/euC8W0So222f5Buon8z3/P07fJLoE+fBHHr1DwDQNg4/svc
 z/kzMVMNBkBBu1PtOiAVVbu/dWCh1YKdMoC3MZEUtCh+RssCNvOarErZVonM1j3M2l2J0YStUrY
 gY5NUywC9y1xqXKxICGWc+QC4tBdXpU0EfXx8faIu9LTlyvvzY0Jv7CE4DmNOy8pYkb6QDRM575
 Pd83MIuxnmKv7LhjtGETWolcOSVuervJPLHLs8804lvSErwscFKpcUkJYWzQnnP4oYwvnur/72q
 Sn0uAIi3DFREIjvmVcvjhdbEMNodeZxITvoHTC9VfoC0y3QvVDCNHRAhj+07osyjIRhaJl6/nDJ
 nFGeTjYAJykugVxgZAyUcDn6h8ucCOLpUWQm+eW2Os5DfBNVyQQRzFTCXQ98lUIshihvWhLLIa9
 9RyWTw/qJOnECJEPtLA==
X-Authority-Analysis: v=2.4 cv=BJ8mP1QG c=1 sm=1 tr=0 ts=6afb4784 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=RpNjiQI2AAAA:8
 a=VwQbUJbxAAAA:8 a=lctZ7TjYXs5uN09VQ8wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Of-s5w0cmkvkWoEZSXdiqefTtbSOWsoI
X-Proofpoint-ORIG-GUID: Of-s5w0cmkvkWoEZSXdiqefTtbSOWsoI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA3MiBTYWx0ZWRfX1uBYGPc4k3Uc
 /VrmfRa7lPQHrEnIXNHuimZRyR+O4N/WCXzVJpM2f9mQGfoNVJFfTKS3ynsRxRel5h+i7j6GuVH
 jaNso3vvOiRk78H8DkMI/hpH6Z2za7V2nrgZHsM2s7VO7ury9MjH

On 11/10/26 4:24 PM, Praneeth Balasubramanian wrote:
> With recv_from_iscsi_q=3D1, iscsi_sw_tcp_data_ready() queues conn->recvwo=
rk, and iscsi_sw_tcp_recv_data_work() runs the receive path under lock_sock=
() only. At the end of iscsi_sw_tcp_recv_data(), iscsi_sw_sk_state_check() =
reads the connection
>=20
>=20
> With recv_from_iscsi_q=3D1, iscsi_sw_tcp_data_ready() queues
> conn->recvwork, and iscsi_sw_tcp_recv_data_work() runs the receive path
> under lock_sock() only. At the end of iscsi_sw_tcp_recv_data(),
> iscsi_sw_sk_state_check() reads the connection from sk->sk_user_data.
> Its comment says it must be called with sk_callback_lock, which the work
> does not hold.
>=20
> On teardown, iscsi_sw_tcp_release_conn() first calls
> iscsi_sw_tcp_conn_restore_callbacks(), which sets sk->sk_user_data to
> NULL, and only then flushes recvwork in iscsi_suspend_rx(). If queued
> work runs in between and the socket is in TCP_CLOSE or TCP_CLOSE_WAIT,
> iscsi_sw_sk_state_check() dereferences NULL->session. With a delay
> added at the start of the work to widen this window, a target-side
> connection close gives:
>=20
>   Oops: general protection fault, probably for non-canonical address ...
>   KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>   Workqueue: iscsi_q_3 iscsi_sw_tcp_recv_data_work
>   RIP: 0010:iscsi_sw_tcp_recv_data+0x219/0x420
>=20
> Both callers already have the connection. iscsi_sw_tcp_recv_data() gets
> it as an argument, and iscsi_sw_tcp_state_change() reads it under
> sk_callback_lock. Pass it in instead of reading sk_user_data again. The
> connection stays valid until iscsi_suspend_rx() has flushed the work.
>=20
> The unlocked read was found with an LLM-based tool that checks callers
> against the locking rules stated in kernel comments.
>=20
> Fixes: f1d269765ee2 ("scsi: iscsi: Run recv path from workqueue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>
> ---
>=20
> Notes:
>     This was found by an LLM-based static analysis (GPT-5.6) that checks
>     kernel code against the rules stated in its comments, as part of rese=
arch
>     at UCSB SecLab. The patch and changelog were drafted with Claude Opus=
 5.5.
>     I reviewed the patch and take responsibility for it.
>    =20
>     recv_from_iscsi_q is off by default, and setting up the session needs
>     root on the initiator, so I am sending this as a regular fix rather t=
han
>     a security report.
>    =20
>     Testing: two QEMU VMs on next-20261023, an LIO target and an open-isc=
si
>     initiator booted with iscsi_tcp.recv_from_iscsi_q=3D1, using CHAP and
>     continuous reads. The initiator kernel had a 20 ms msleep() added at =
the
>     start of iscsi_sw_tcp_recv_data_work(). Closing the TCP connection fr=
om
>     the target side produced the oops above. I have only seen it with the
>     added delay.=20
>    =20
>     The patch applies to mainline 9ba46df34488 and to next-20261109.
>=20
>  drivers/scsi/iscsi_tcp.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9260b1c9b0e0..88b1f255ae9b 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -104,18 +104,20 @@ static int iscsi_sw_tcp_recv(read_descriptor_t *rd_=
desc, struct sk_buff *skb,
> =20
>  /**
>   * iscsi_sw_sk_state_check - check socket state
> + * @conn: iscsi connection the socket belongs to
>   * @sk: socket
>   *
>   * If the socket is in CLOSE or CLOSE_WAIT we should
>   * not close the connection if there is still some
>   * data pending.
>   *
> - * Must be called with sk_callback_lock.
> + * The caller passes @conn rather than having it read from
> + * sk->sk_user_data. The recv work runs without sk_callback_lock,
> + * and connection teardown may already have cleared sk_user_data.
>   */
> -static inline int iscsi_sw_sk_state_check(struct sock *sk)
> +static inline int iscsi_sw_sk_state_check(struct iscsi_conn *conn,
> +					  struct sock *sk)
>  {
> -	struct iscsi_conn *conn =3D sk->sk_user_data;
> -
>  	if ((sk->sk_state =3D=3D TCP_CLOSE_WAIT || sk->sk_state =3D=3D TCP_CLOS=
E) &&
>  	    (conn->session->state !=3D ISCSI_STATE_LOGGING_OUT) &&
>  	    !atomic_read(&sk->sk_rmem_alloc)) {
> @@ -148,7 +150,7 @@ static void iscsi_sw_tcp_recv_data(struct iscsi_conn =
*conn)
>  	 * unmap it now. */
>  	iscsi_tcp_segment_unmap(&tcp_conn->in.segment);
> =20
> -	iscsi_sw_sk_state_check(sk);
> +	iscsi_sw_sk_state_check(conn, sk);
>  }
> =20
>  static void iscsi_sw_tcp_recv_data_work(struct work_struct *work)
> @@ -202,7 +204,7 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
>  		return;
>  	}
> =20
> -	iscsi_sw_sk_state_check(sk);
> +	iscsi_sw_sk_state_check(conn, sk);

I think after we have done iscsi_sw_tcp_conn_restore_callbacks it's
a bug to be accessing sk_user_data from inside iscsi_tcp and expect
that it's non-NULL.

We don't want to allow that to happen so we should take the=20
sk_callback_lock when callling iscsi_sw_tcp_recv_data from
iscsi_sw_tcp_recv_data_work like is done from iscsi_sw_tcp_data_ready.
Or, call iscsi_suspend_rx before iscsi_sw_tcp_conn_restore_callbacks
and then add some code so after iscsi_suspend_rx has returned we
know that racing iscsi_conn_queue_recv calls are handled.




=20
