Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8768F1E376C;
	Fri, 13 Feb 2026 14:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770992363; cv=fail; b=uCGQMsqwJ3zUZSw7hnp5ooX0CzjrdvR3/siaA05gN4XnFs5Wnugs9sWIjPudlFXdKxir7oyoz7vqQUqTuDZY1wRFTvjdGApAKF4S8sZQhXS39M7fkt6+L+kBufadBXSJqe9CVf90Kx6HqblUnWz/OftpGxaCKNRe5x+bZxaIcH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770992363; c=relaxed/simple;
	bh=lQlEoc0gtpEc/nQVf78BbDIv3rjejz+EjMO4qGhKI9o=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=Sl2zF/reqWHtPrzWkeLLSvPZhpIpGgfS4EKMu296aUOsHHztXQKoHct8Xi1kDbKGb2OyzH/gCF3fO0VZmMOqZWrvcKInn/ZnmvmJ3UdwRoEh5kosnFugsIdg7GWSV9Hb0SijaYY1dPjy36K9+5zBaLgGTNrgzkNisuwISk8Ko3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ErqgWxdR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ncu0KTsi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ErqgWxdR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ncu0KTsi"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61DDbQrq3123490;
	Fri, 13 Feb 2026 14:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Xn8xzYIEjmX6lGZO
	KrF8wW6w6AUi4CRb/4d6Tzz3sHE=; b=ErqgWxdRlaDgjIH3d+hcZSqVaHkVp3v7
	A682JhVs/eL9IBqeXuyZm07l76EBfUoJXG2Em61CoYd0AymlBtYPqK2UTn7K7SOi
	SS8OGrMDBX/JlzA8amu95S/eIgwWaquwLi9qvtkwXy7pEl8+ddu7afYNH/HhoqeC
	8wnDVQUfOVJ9VKGHsZi2lrzhaUq8rPjUIFUDlUYcLhJ3I8V6ZttE4RdFy/IicJpQ
	F0N+4IHnJl2tr56UIhmfscoI2vbPNnEIH5GWK0efzA2QPUiGt759fRRoWtz5Rxo+
	AHSBdGt2YqcR4TNzGu7RleOKQFXBQ1ODzRXN+F+7H9kI9BoSYI8xmQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh91n4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 14:19:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61DD0obM013001;
	Fri, 13 Feb 2026 14:19:16 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012067.outbound.protection.outlook.com [40.107.200.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c8273d5gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 14:19:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gee7KO4KmhA47EB9sWurCjn2jSpP4JAXg+DMALMVfwBwUKFxaLd6crUyXzZj8M+eXM3jrfqnqC9GUnI5WNydwwOwYwxBGwXBCXMBF2Bb/1vfsAPRyM5n8jCeEiB2SyLxQbjS5SB2sAxePObmmXLSS3jFVZ14fSHnPycV1nqm4Q89/D8XDPV6FkFJ/aI5JkED35iSF7k77DjA1H7g/lNhzE0DjJETL0L/ZcWG5INmpr8ofCAaP1id5HDQ7n11+0hdHQglin8PEH0n1NWvqkB8p1bnNFIPcKNjp/9jEl8xL4jg9dlOsnrzlZOZYqBF4iyitaS/dvoD76bV1+A5n11lmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xn8xzYIEjmX6lGZOKrF8wW6w6AUi4CRb/4d6Tzz3sHE=;
 b=AuPKOyMXwX3BQ9wlZdWEe7DaWBjrVbRgPYXxSBDgJ+2kikp3v+9gGyLG1esnJLa+FFlJMsKXrVtBmsWPPyPAr5AX+ZuTirjHhqptzA/zTBEcUJ1avI8TvTf/ODM7wtxpXcM2ggamgsmUkZwP52JNw7LmVDn/9GERE/V5DVvbxyqtQMAi4aGOg1HU+T2wl2kwY1AKjhnoiGSLJeec7Q6elwWKEUPB/a7lI7JxJb/N6JKxr/mrJoBTTsOfnzq/yZt1trvDuY1y2cRQGHaaM9ei/R6vnAiPvMClX7zlmN/a6a2V947qs38wOSs2UU1IQbNCYO8ncA1z+65vFu8WbJT8ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xn8xzYIEjmX6lGZOKrF8wW6w6AUi4CRb/4d6Tzz3sHE=;
 b=Ncu0KTsixJIxWRFYj0flohLXDj0oqNPFHWnZHbvuAJx3q7vT8CHTXp3RWuUfV2kvqmsVjYSXIc62D3xbNXeL+0nJXFepCTkrjXM3DP6LgUwe30QMM3mV4jGdphb5JMFH02l10RJCcWMD5FDch4aVbB/BrCjcgHYi8blwJ3ekstU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB5818.namprd10.prod.outlook.com
 (2603:10b6:510:140::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.14; Fri, 13 Feb
 2026 14:19:13 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%5]) with mapi id 15.20.9611.012; Fri, 13 Feb 2026
 14:19:13 +0000
Message-ID: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
Date: Fri, 13 Feb 2026 14:19:11 +0000
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: [LSF/MM/BPF TOPIC] Native SCSI multipath support
Content-Language: en-US
Organization: Oracle Corporation
To: lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0352.eurprd04.prod.outlook.com
 (2603:10a6:10:2b4::23) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 708ccf35-c1f5-424a-39cf-08de6b0add11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHhEQ3F3OUJWbXYvNE81TUU3ZHJEUXk1bTAweFN1cStmL3p6cWRCTTMzLzNF?=
 =?utf-8?B?ZEhCN25IcHczRFZKdGxtLzkyTWQyWFJPMGNFeC9kZkNmVGVNdG80MTFpV1Vi?=
 =?utf-8?B?YTZlckU1cGw3QUppdDNUc1ZVNmlSRGc3Q0NCNXNRN0swbnhyK0IyWXErNmpG?=
 =?utf-8?B?TklxYzVlc28vUHRCRjN3QTNHbERWYmt3ZmNmRnpXUEIvSnlKdDdaTFZRZ3Z4?=
 =?utf-8?B?NDRueTZFV3k3aDhWNTdBd0NnTU9nSnNhUldNcm5wdkYwRm93TkxocUpiZitZ?=
 =?utf-8?B?TGtQSjh4MUJyZmNSODR4TXVwWWtHV0tKYXhRYTh5ODBNU2t6R01EbXNFWFZl?=
 =?utf-8?B?cTBRZzVxRWFZd0xtRHhMV3Q5ZXczZGs4bS9JSFhnZkt5MHI4TDZYRVhsQStv?=
 =?utf-8?B?bFd3blVMT2IwV2dhK0JXMjV4UmVBYThhMnN1bDNpek1QcGpnci9abjQ0azBs?=
 =?utf-8?B?Wm9NZWRXeTkyUHUxY1pBVUdNbFdtNnZaZVI0cTRIbXVkVHBWY0NUWGR6Zm9k?=
 =?utf-8?B?NWQ4a3Jldy9ycDBEM0VTL05IYzVUWTlFbkh3T05yYnIzLzR1WGdTY3NaSjB0?=
 =?utf-8?B?STh5eVIyMzZMdnh2bFNtajA4Tkw4U0pVN0NYQjRZdzBaRHhZbVpRb1ZzdWxP?=
 =?utf-8?B?TkhCYnpRcm4zVVQyZnpNR01KbXoyb0FOT1lxREI2WHFYNEo5aCtrRFhCakZE?=
 =?utf-8?B?RGc2SkYxMUtPZTJKK01DYlVHK0JEMHF4V3JoNXQzRHBGLzFGUlhORVpCUS9s?=
 =?utf-8?B?ZzBmRXdTOElDd3A2MkF0RXlOZUxZTEJ4Rm1FZUcwbVJzUjRUVVBCSHdpbnEy?=
 =?utf-8?B?cHJLK09QdUVNRUZlTWxvNEk1MUhhSUFEN3VIek1LZkZOc3lwRE1GUEdjcEgw?=
 =?utf-8?B?UDg2dlJiWEJXK0NLZGdoY3lTenJZMyt2amtpWitIWEJLSXlOZWhSQ0tERXRw?=
 =?utf-8?B?SXpUSklrcllFeWo5YmppYWJ2RU5ySmxzQkpRWG5LUFF4cFhHV3E1NllNcmhq?=
 =?utf-8?B?YWZTUVB1b2M3dUtjMm1xVGMzeXFpNXB4ZFUyUnd6MElzVFJxSDI4WkpxZTNn?=
 =?utf-8?B?blZOSG1FMnFCVHZtbjgzUzRCUDFOWkhtVlpmMGsrTW1Nd1dBYmhJdWRlZXo2?=
 =?utf-8?B?cVZ6UjQyaEF1V0lxRCtRUW9kaE1pbStFYUpOL055Z1NtWFF0WDV3a1VYK0JN?=
 =?utf-8?B?MlZNc1BoZzJIb2JUc2pSV1RFeTFuUERSb1JEL2QrTWxHeFZ0bDZEdWliYWYv?=
 =?utf-8?B?akpFclpybEhVNHVRMnBYMkJEWW9ZQnNJcEVPbVBJaW5XNU1tOVJUNlNpR1Vu?=
 =?utf-8?B?dzF2dXZNWU11SGVQRVJHZHhVM01XYzd5NGRyaHA4alBZN1BHTWhUTjNxV3RP?=
 =?utf-8?B?R2lKWEE1ZFRDZitsWXU3WW1zNStEUXR1OFNxUkhXZFIvLzc4bzZvNnBQdGUx?=
 =?utf-8?B?TENwN2t3dGJHN1RiS1h2VzdjTTJXZXhMRDlKclpITlFFMDlIMDZpL3phYlht?=
 =?utf-8?B?NHgwa0k4VWxmUys1YmFXZmd2SU01dTlDeWZab1p6eDRmamJhbFhQbFJpSTNk?=
 =?utf-8?B?ajNpMWxJd3hJbjlneVUrZW5PTkNFZVdUamw1eTFQcjZFK0JoSStCT1cralNq?=
 =?utf-8?B?K1c4bE9SZUtlS1VScWhuZElPbUJFUUk4UHpYbS9NNUtHS0liMWEvamkyNkJk?=
 =?utf-8?B?RjlPUHJIbWd2bG53dzJYeXZVcWtiZmFqMzRDalNRVnF0UHhCRzBMKzhObytN?=
 =?utf-8?B?aDQySUVvTEg0VUtaL0hxY3AyNXNWNzdtZXhrK01pMm9XTlpYUFhxdUR0U20x?=
 =?utf-8?B?YnY2dUlCS2hLcGYrMTV0aHZsMXE3YWQzeDBLL1BWcFpTVTVPcmtxdnp6bTV3?=
 =?utf-8?B?bjRpV1dhM1pveDJhSHhBL1NiTkc5NzY1Vy8reUVTdXUxYnlxK0VYQ05OL05z?=
 =?utf-8?B?RjFpcExjdUNwYnhrY1VId00xSkw5RVVzVEVjUTREQXh6QXkxQmQ5OGFxa242?=
 =?utf-8?B?MExSbDdmNCtOSTlIOXdqTytPbVpmL055cEg3S0s4QTRUblp1ZHVrMjQxOEUv?=
 =?utf-8?B?V3RtbVNBMkp5N0NtOHhWazY4SXhWalFDMmVXbWhiSTJBR2xDSDI0YWtKNm9V?=
 =?utf-8?Q?w8sU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STEyT2JXbzVDclIrZXFiejN6UmNMa2l1NGZLUUgrSDgzMHJMazBIT09vNUtK?=
 =?utf-8?B?ZTM1Ym5YTE5Db01DRExvMUZRUFJjWTFXNnZjOUYwczhocmZDYVdWL1dHMi9I?=
 =?utf-8?B?dmhWQ2NnR05HTW9KR1pBYVJvdU9nQ2RhR1d3a1JQb25MZWsvVFlKNWVoT25a?=
 =?utf-8?B?RmNmZmw5R2NpYWRuM2FtNjNGd1FSeEFla05zOUNaZ3QxcXVKQnJ5YzZYYmJr?=
 =?utf-8?B?UEQ3TVEyUVVwU3gxSmFSaUQreUpTRW1GTGFwT2VtUENBOGRUQjNxMWYwdlRh?=
 =?utf-8?B?b0YySHRtbEV4UUxVdStCeEZNNnVvM0FBTU9xcFNkZ1EwaTFNNS9iSFJLTmYv?=
 =?utf-8?B?WU8vbVV4MzMwT1lnSnN1RTVrYnBQRjF0MjNOZTI0RUpSM0lhaUdvOHZsa3kz?=
 =?utf-8?B?M3hXWjBleE9RQmtxb2dDZnRUMFRONmFHMTR6WWFVV0tXb0liVlRkQllwUWor?=
 =?utf-8?B?RHl6RUJDd29pOG5WOW1pbHFhTXpFcnN1MnVqMElpZFZ4Y092VU5jVFdBeHRX?=
 =?utf-8?B?U3B5dFF5R3prS2lSZlJRaGlET0JsMVEwbk5rbGV4dXg5bXBjRHhpTXlFZkN3?=
 =?utf-8?B?SjNpRk1KdXhCNkNkNUVtMnNXNHhDdHkxNDZ4NXF6SnVHMkhPZWkwWUNVNXZs?=
 =?utf-8?B?YzljcTV6WXQ4d2FYV0p1SFFuZzIzdFpDQ1FESnRlZkY5aVhpYUpoMnluUWdm?=
 =?utf-8?B?Ump0RzRobnZ0cndGZnNkNGt0ZFoyaiszdS9hOWxHWVFkbUs2enVVUDJNTlEy?=
 =?utf-8?B?L0ZZSXBWT3pFVS9MMjdGYnNLZnpOb2FkK0lMcS81RlRPTlFMSXp1WTVTVEla?=
 =?utf-8?B?dzBaaWh4M2VaZ0ljV1NaRWkxWWxzU1lIakF5RTV5VnNRQkxDTVd2K09teGV5?=
 =?utf-8?B?TisvdXlKdmlzRjRxV3Z6YTlIVHk0dUJOdGRWdGVKNUZQOXJ0cmkwdUFFTkZW?=
 =?utf-8?B?bEZMczBwcnArV2tnNEw1TnZ6SWE5eW15VmZkUFF6TEJoUDZURzdITFdiaTl6?=
 =?utf-8?B?bmxSOWdLdFpYWDNvTkJXSFlVcjhpYnRSM0pWTVhaU01NMXJWc25XdjFBZ0JH?=
 =?utf-8?B?WWRZRmx5MGZJSm9oUzlIdEY1eGQrS3pUWUNEUHQ0elZ6UzZBYkkvVEtSM2l1?=
 =?utf-8?B?czNrYlEyNjI4YWF6VnNSSm0vZTZFakVYNk8zTTNIZnpqaGNYd2NRanh5TEEw?=
 =?utf-8?B?OEpSNzFVTFYyN1hnbEVJMUp4dlZLTmkwSjRZSHRDRHZhelFyQmVibHhtcXhs?=
 =?utf-8?B?NkpjdGM1VUZrWWR1bVd0Wm1XdjBSOVdaR0xUZHRZcmJmTFpaODJNWnZkQzJi?=
 =?utf-8?B?YkZRdHBoTFloakxNcVNTTnQrVzNIYUFZcmpzZmozWVIxNjRoeUIveHdjYko1?=
 =?utf-8?B?OTBlTVZVSHZseUR5YmhTUUF3VGh6dy8xa3VYS290NnNVYUVGM2kzaHBvMzFa?=
 =?utf-8?B?UVdJMURZWWRaSG44bW1QNDliVk9QWjV5OHZQWE1uakNiVU5DS1NjNDc1SEJH?=
 =?utf-8?B?V1huUUs1RUJBZ3V4cDIvcVMxejJnUXNoR1l3VXlaSzJKODdrTmdxSGpuTFl4?=
 =?utf-8?B?dVUxM3VFTEIvTGZHRnZreDBoS2Erd3VhMUs0RHV3bmpzdXdlQlBoeDdoc1NK?=
 =?utf-8?B?alJxY1p6anAwbjYybmlYYUNkam9iTWFISTVxbHZEaE1QaERBU0kyU0gzeFpB?=
 =?utf-8?B?cVFidVc0NklhcFJxZ1ZsblZwZzF2SUxvTHhsQ2RGUmNTNzRMY204OU5pS2l1?=
 =?utf-8?B?OUZ4RlM5alMvL01zMHBqSHZqRzZRS2RXeXZtQmZLUzVCb3N3bTE4d0xwemtL?=
 =?utf-8?B?NmNmNlNvN1hpQ2FJMjg5K2JaUUxYOStPUDNncGdnS3pzV1Q5K0l3d2lzUzN1?=
 =?utf-8?B?RUNhYWxQOVBQWURWSWFtY3FKZFp6b1h4dWp0cmE1V0l0N0VJd2V6eFFienl0?=
 =?utf-8?B?aDEyYk1xVnpmNHlqcUh3eWh4S0RZeFk3d2xDOHBNZUpJanpXVm02STZCL09h?=
 =?utf-8?B?VEhialdFdmhwVXU5NFlmSm5jMVFyZ1I2SDhBMmZpUHgrZHdLSldBbG9GcWlD?=
 =?utf-8?B?UHFTOW5zNnlvYnZIWGdzVElSTnFvQWUxZGNtRUNGdldmNXBKR2pjaksvQUF4?=
 =?utf-8?B?YnI4UnZtbkFkZTZCYmJxYnZLemVJQm12VmdUQTRpa01Gc3Nrdm5mNC85YVBZ?=
 =?utf-8?B?NndTOFVJcjZsNjRydUdQeTg4bUxjMkdVVElOdlR4UlJTV0M4YWtnaldMMW5W?=
 =?utf-8?B?ZjNwRjF1clRielFiRzA1SWg4aktDWmp5b0FTdDFaajRyMC9wNldBSWJpeU9R?=
 =?utf-8?B?bXpHSlpPaXZUb2NYUUV1U0xzSVlGaHNEV1B1aGtCMXNTVG5KL2dtZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u1khv1kyC5dQrucc80+NmVvEB/yjvnTG93569s2JYlmYONL1VtkXRMVQEr8ZY75S81gKwOvppUviSh5R/4tCSe0bZFfHaSn4gU3mRUboO+sF4YgLPJOPGWOT+FreI/Vg01r2KS1BdZO/AY1tZDUUcWKMDfX4CxRgKBq0sIKRtBHXH9JRFQowf9YskRaf6FwS2IZYp+dg3q3jsj4c4kS5TQgtBrGwivgkkxoITFHaCYglfSZXrzPY8jEKavl9bUZkMc174wfwI75WC3R3zSZV9Qy94XFHNE7dYIgk1YlDa/9O5mVKHpwuWL8HWFCPdpLbUkxqBnzdF8h8Ppwka+tJwrAhfP2mBUwoQ9mIrRsEz90kxxIIy57o1Bo01D3WCnpRBBtCV2ueJXWkjLndNQkjdnnCdMP14KDDRC78+z8dzR47SdF6QNnBwa9x/BRCZyMzj6H++HaqrXiXaGf//56Ogkg8HWsC2kK98XFAbPxpZP9Gilwsj9weafRKMieq1oZVvGWa4dQW53FZt88gJ8JafDf35l+qsJOZVNyq3hxByBmeGhkgW28jakrvCvWMVFejSZe8cZe4p7Vtm56t6iiOqyYF+BIBMah6O0ap03UL9t4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 708ccf35-c1f5-424a-39cf-08de6b0add11
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 14:19:13.8794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUZQGXNPlOwm/bwzUhkv7QnoWDR7E1tPCuaYOsND2WW0VJGZuwVGQGIHOEqm3c7i8kFXGoUv4UPEbz+mgfd7wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_02,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=820 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602130111
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=698f32e6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=6WVHYR-coFSiix8MC9sA:9
 a=QEXdDO2ut3YA:10 a=0lgtpPvCYYIA:10 cc=ntf awl=host:13697
X-Proofpoint-ORIG-GUID: 05wihUMWmmcpZHj7i6N3akF4-BmlOEyS
X-Proofpoint-GUID: 05wihUMWmmcpZHj7i6N3akF4-BmlOEyS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDExMCBTYWx0ZWRfXxWdJfvlj0NSV
 493edHh2/Ahuo0RinEklS1no2TVcoKeniUcE6Z3N8/u/ZvDOjXIycR7nmPzLGegVvx63NwAI6B0
 ZcqavsYHbUYFXc8Ds2RqAs8iOJrj2VbwSQ+FUlRl0RkaUJcCIiM1xf4wNPywrPCPzmo3Rj6vv0W
 In5msuyjXbjngGBZJSY3fi/NHmimdk4HJuBFSYbmXvdjCY7x4XsyOMl8pA9yDmRCP6DYKMz/aPR
 ZMGVXYKIvyBjNowEH8wNjkDzEvmHebW6EDM/C7j+vpbInqp50i+QA4PUTgNNa1p7yxqakxakgT9
 4xl2i41I07vc86Ga+xPkvkGNtObVQq/pHJ4V0W9pcXZ1bY5NhCT1dWLqS6XDX9DYJx0CUTnAZ3F
 5c/2YAebcAd/2oItv2pe7+kDopgxMs4VQt/s6d0mxiMiDUXFm+rQpVk0uP3XI4gTTfeYAhimCYJ
 Qe1lkrgRrKEMXRZ8Q5D3WRFxAALH9aD7swNiIF1o=

At ALPSS 25 I presented a proposal for Native SCSI multipath support. 
Let's discuss this topic at LSFMM.

The idea for this is that SCSI could natively support multipath, like 
how NVMe host driver does today. It is intended as an alternative to 
dm-multipath support.

I have been working on the implementation and I plan to post patches in 
the next cycle. I am looking at a 3-stage approach:
a. create a driver-agnostic multipath library, very heavily based on 
NVMe host multipath support.
The library would support features such as path management, path 
selection/iopolicy, failover recovery, PR, delayed removal, gendisk 
management etc.
b. switch NVMe over to use this library
c. add native SCSI multipath support based on this common library

Thanks,
John


