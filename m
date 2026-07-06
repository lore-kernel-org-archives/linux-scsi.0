Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651D63054C7;
	Mon,  6 Jul 2026 13:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346260; cv=fail; b=IeBJYvGMPGGjPZ0ki9LFcdxR07fdK68MoPHpxaNaQtwiVuRHPPsVoBIEgSFlRYhmTZQT/dcGwEZxB9HLKyPNyR+AuC+oSWaDwLJspSGgyk0Iyaofpi9AlQt5LMIap0jM0PJdwkewziVidgn7Gs43LOIT+HjtAlZxJPPQmEZSkf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346260; c=relaxed/simple;
	bh=YgWT5SzaFCQ/HBWdkMqJO2DMTTV1Lf1Xb/UMasC/H7U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BX31+o9feYT+qRLApfRVGYZqSf/cIFxq7bjdkSJVwz5eDIGFlx2pRMSe+JHR0gJcnNR5bxcvjxgeY8wiaY69iykZLtCokV7Wg71EsF+pxJbPBVUlXpq3vA8utqaCKrZuNml+naqlsf/KE7VxVPHY9jG4HBP8o3C6ti2s94aJUW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sQa7szjf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tG3oBuzD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sQa7szjf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tG3oBuzD"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6662O12d1586180;
	Mon, 6 Jul 2026 13:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5JnQ8GzUIND7UJT1ihWXkaLDrdpvkkWF3FWkXvmNTMs=; b=
	sQa7szjfzq8xkS9h4bVWukCQtgURddxbWyRdmALPDVg6+oT/Jp6RGmDyuGvzOKZS
	b8yLe7YC5NTTMaES0dv3rUe6RVsQ9u5abqubP1EGveJXKRxmJEtH/OOTBNkyhDYb
	sS0ZbfrLvfRwhFDIq4RsH+g3z+DMKorSo8EaogpHhYuz5mGMQ+iDavK/hL/B9Kh8
	qTGPdTaDP2EjfSCmaDLsb8LBGmlZTRm1nCHZu8EEW750pFgq+5dKoCi5nqsLsSBQ
	NItEe2MsP7koTVgxk72Ak0x+FUNo3nn0eX/NIGcMoqaSY4WFiuExmmhDQ/nEKEGf
	V36EAtJqHvz9yrzSWL+8hA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6s393ny2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 13:57:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666Dm7hY021956;
	Mon, 6 Jul 2026 13:57:36 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmcd146-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 13:57:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GCxUXrazq2On8RA03+7HGdYXXKyr5JAXRCbf0TvC2gFu8IY5UvsUpA51qYYxrf8+mf2O3pO/ujULKcsdmAEmljRwxPpwL6aBE19nRMI9BwOcG5SeVP+V0mQVYeQ2YR2yHv5akWpDFn4dKsFGU9Dsl+VrdrXxIXjP5FvMOEPKEGKTOX881XjdZBlVH3IusrpjS24pyAhEsdXisEx8hoXUrPada3nkolKXdxzWMSIkzg9+R64eVQDVjwTr8eeg6eQyGEPQYOKgDQDrAj38mATCl4CtodAvb4tjGdCpjMuMWadgM6kGfgnI8azhgv6NvcQETmmjBFOmUEmWdOPEDpVfUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JnQ8GzUIND7UJT1ihWXkaLDrdpvkkWF3FWkXvmNTMs=;
 b=LRSUeHeKTOAuhyqEuKd4K6hzzxKrUeKX4HPbIbgmvxXb/6eNSpZfL7+Pi7vrHmwIFt/noFuq7rK5iiaL7RA6MxZatjTmTT/+ARch3ignSwd5k6m5QLlyjbX4kNfMdNjdecf8Rdubd+8U6Gjox/14OAcrpVU23BFtqSOjl8ohz9uP9vbniVr8HYcxIOEcSRQxOUbMh4jW4pqWPrjyiaVYMMP3l4AzRs+6OpjLz7/RASrkag5aM9wX8ORkLqjsVYd45VEPPnmJWacQrlKusZQI70Hju5+T+R0fdU/t4VSIaAN1G3e61A7w2BowGA4poZZHnSwm4ui9xzvZWz9txH0iVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JnQ8GzUIND7UJT1ihWXkaLDrdpvkkWF3FWkXvmNTMs=;
 b=tG3oBuzDw468vhnADtxmSkWjHf3atEeSMXPhaDFmZpcyVZvS2gR2vwXYoVyioXeeryIqc86+ikbxvCn0l7kds2F00PDmpmOIzZWSmF5fJ/ur3CQg/GWDQY45c+v+d2e4Ha3cjOCIfEMKOEhaLijkyWNPN7x3N8FgBLZ6SqldIb4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CY8PR10MB6706.namprd10.prod.outlook.com (2603:10b6:930:92::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Mon, 6 Jul 2026 13:57:34 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 13:57:34 +0000
Message-ID: <945fd621-73d1-430b-ab00-a922b9c082dc@oracle.com>
Date: Mon, 6 Jul 2026 14:57:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/13] libmultipath: Add sysfs helpers
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-9-john.g.garry@oracle.com>
 <20260703104450.DEAAF1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104450.DEAAF1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CY8PR10MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: c1cdb8d3-a8f7-43e3-d04a-08dedb668742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LbSNw3kSEkcJXuUDo9IvC41aEJWRE5fgoppXsAXTTOsemdNWcALq/nYeDuVGu/QU51/u4XPK4OMW/zrJqKbKsn3eBBVtMFIKpHfdVad3wLlNoYmjU03gI/nVcOsdNbPxf7ndAsLG4yA/zx2dtcG+R6NmxUiGk/WxsICz+/LGMgjzs7+erkc1vJU+oZby0t4ZLnr7rfAH7CyPuiHIq/xf2374M0DaKRyTb94Lq5bekZ0ozzpApHAVsInyWSMB0r+jB5JOy+2OWwPl2eIIaood2/2HAmCVcrXud3T8phNSvZj3doln88YUuDNfT96O4HbqcoQNtjihmDaeTmfdBSmSUhaw/bzUj2fmCKjaons0D0K5O2uyizf0S6Ch2K3pT+/OMo6Bb0S18w3VldESGERIJhPC2QTIJ7c7DHn8+ASGu+C7el4hRsiKq2SneL7aD8rwyC0g4p0QC7aRWzO5mOVBji2ju5Io/330qhZiepG7r5aDaYNtUFaTIlPxKV4wfGodWqLZIQD88xlLjj4y/LYA2PPom23a1hFzueECgqWc2LFsGTuWxsIRN0ncLrmhEhuQg3TXK5dH9yud1Ghp47bYEzPloVcp/Zmv6YtBx13EHM9DUfGjtbNFWLE5j8389siOV2rQYMDVSGvc1NWZLG0pu+KD2yfMJVW6S0wkuYjm1Z0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmExNjh3R2IvcTVFOWtQU2RQQ3VJYklja1JNN1pvanBjejVsUHFSVzRhK3RB?=
 =?utf-8?B?d3U2a29jQUh6UVVMS1Fyd2hIL3VuMVNqZ3FjSzdvTWkrOHRNUDJWanVwN045?=
 =?utf-8?B?YUlmRDU1ak5od2QyTmFFK2RoaWdBUDhWdlU4K0RjN1dvTzRmZkJ4dFNyK2hT?=
 =?utf-8?B?eXJ3YTBKNHl3bUh5cTdnQ2pPSXhCMWc1d1M5SXRPd0FzaHVQMnl5cm5PNG94?=
 =?utf-8?B?UHpaem1BMjBwaVZjdTd3bmU2aVBrNS84RGtXTkNTNlFLazdBblpLZ2dCaGsx?=
 =?utf-8?B?dktQeDJzbU1NWEFQNThLVGNJYWlEemtTcm4rMjhpb1dLRmljMmJ0UC9iWkRZ?=
 =?utf-8?B?eDF3TXIrT2x5TS9VbzBiUDFUeEV4dndVYnFCOEFJOElOS1NsT1JGRjNoUHhv?=
 =?utf-8?B?L0VDQWQ4WGRxS3ZCL09PT2JkcHNLNGE0aE5zSmJYOTZVRytvQ1dSUEdTbWhD?=
 =?utf-8?B?VWlWajAzMjJMbHNSM3poaFExSHhRQTYwcHNiK1dweHBXRC95YmVjd1dIdTRx?=
 =?utf-8?B?TkVjQmpDQkd1QWFILzBsRG1mSnB4b2NNRFZheElNWkF6bnBWWHJyTHU3ZFBp?=
 =?utf-8?B?N0xIZEpta2FQV1B4dTRTZ1JRRlNiS2JldVIvY05RcXNKTUYyQmJNb2pCb1R5?=
 =?utf-8?B?SG9KeklCeFR2SXp0bFB4SHZxdU80Y09kNmhaZHFJbXhlMG16MWpmRjdhZmZB?=
 =?utf-8?B?aWtPQXpSWlNhK2xyK1JVZGtOLyswaTQ0TTI5L3luaEFhRHp6MkwrTXhIRWhu?=
 =?utf-8?B?RmJMVHVjcnVPN0IwSDVQZk1mRE9BREdRL09XR0JIb05DU1dZbGlDZTl1Y1A0?=
 =?utf-8?B?eVkyNUlseC85WU1naVFmelMyaENWMHVrdDNtdy9oWUtFNVpLU05ma1VIQmtC?=
 =?utf-8?B?anNmUnZUOEJ4bncwWUNhcE1wbGtidUlaTEw2bmhRbXBTYWVwZGlSbk92d043?=
 =?utf-8?B?ZERrbVYwOEQwMjJVVVNIZWtYR2xteTVWNGhHNys0S2crV3RnbkNTdTFGREJn?=
 =?utf-8?B?clhCb2Nrald5eVdiUG45VTdJSXZqY1NUL0ZKM05UTnNrUHozaTlVM1lCY0Zw?=
 =?utf-8?B?TWNNNzBjWnN5OHQzRTJ2Yy9tcDlFTlpBRmRJaW8yMEJ4Y3I1SjZjL2FkdklH?=
 =?utf-8?B?MXIvMi8xS1lXSEVFVVVza3ZSUUpJS2lTR2VBZ2tuR28rQ0VSYy92cGpUWE45?=
 =?utf-8?B?aHFaRlFtY2FpNVQ1Nm1pdXlxUWsrdktmQzUvM1BobTZqR1ZTOEpjTU4rREU5?=
 =?utf-8?B?LzZUM0hOSENhZXphc3hvd2h3ejc4alZHTFF6Y3pJa3dJckJVV0dXd1ZvNkg2?=
 =?utf-8?B?ZVc0TTZWV0cvZkttMW9OanU3RThmcnNXRXY3SHZHTG1zaGV4RVFJY25kMUFt?=
 =?utf-8?B?eHM1YjBsUGFHOVc4M0M2eW5ITmJFaGg1OTAxREdNYytPRzFXRTR4VENoTDNm?=
 =?utf-8?B?ZzhpNHJ6YXlzT2tjSUdZT0pnRUYzVjBROTAxN0xDMFVkYmJhOWJBbEZ2R285?=
 =?utf-8?B?bW1UdVdOWUdiWGlMWXZyT2ZjZTdFeThqUktlRTM4UFBEdzBkSjlJaFVRdVFQ?=
 =?utf-8?B?dTBGQ1RrMGFhbERtT3h6K2VabkZDNHBpYXMzUkQyUVJINFM3MWNMc3Fsdmx4?=
 =?utf-8?B?c0IyUncyeDJHZXJMOTZLNUFGM3hPSWZMSUlMbU16RHZJRDkyN2Qrb2g2UDBH?=
 =?utf-8?B?K2xxazYrRG1MMm9DWlFDNlJlZ0V1cjZxZkVBVTdXczV4NURKUit2azVjcW9r?=
 =?utf-8?B?WFFHYzR5ZkVhalN6UDdQTEtNWThvb1MzTVU0YUdtWFcrM21hWWdBR0Q1WjBW?=
 =?utf-8?B?OTZjY1pVSllrblhNd090R3dVNWxzRk90cGViMlg2Znd3bzdsT0JqYWN5SU5n?=
 =?utf-8?B?S1dkK3B3WkdxSDZUeUNJL2l2MTRKT3pIc0MwK2swdkUxZWJtdisxZzBRQ1Nj?=
 =?utf-8?B?WnNZLzdLWUdzSFNYNVdhVzh0bXMxNDl5ZjByeUJmNHhWVG5GK2F0MCtKQkRl?=
 =?utf-8?B?NGtiM1pOMlhuZXZzU2htQlhtMXlHc0phMmxxQWxjYjBzTXcvdWJFb2JKZFB6?=
 =?utf-8?B?WS9CeUR3dm5QZEJDM25HZnE5dVIzM0xkbHdibDRUMVFwemp0aHVDWGtXbWhD?=
 =?utf-8?B?THpMdEZoNk4yZVk2L3BDY3JFN1I3UVhPSmxYREZFeGp5K3pHU3ZRQzhUZCts?=
 =?utf-8?B?L2Z1aHZabGp1NnFTek16SHBheWlUdnhWL1NURGw5Rzk3blp6UjlhcWxLUnZV?=
 =?utf-8?B?ZGd4bWtGZGhMd2ZBaHZ3NW5ETEgwdkNhT3FIYURXVGduQVljam5hbWFVek1O?=
 =?utf-8?B?MEhjQ3ZvUVdvQWtzQjV0aW82QmdPMnNScEFQcmhCVjg3QVZmQVdWd2dDWFdn?=
 =?utf-8?Q?3JJwdJF/iy8YxtrU=3D?=
X-Exchange-RoutingPolicyChecked:
	XFqEcNCjNj4QmYLG5SdYoLj0wDE7sYt4TbMVqUlxd7hdEj4qf/xKvOqIq4OQxPVjz53PxIFfPQJBBCmBgm1kWIjKgWI8ysLMZ4jEoqaRkv985mAz0fr/zNy/y0oyfBrfH3nWqCsNC2xlmTWJD1C0F0C7QSzJCtGhc2qyTEu3olWcXWs3CZCMOJOw3US6Ia/dZn3R4hIHggLdnpXTsdjTUMESetb4W09qIVAtdq0BF8Pq3LuftUxVKRjReJGiVc9oY8XSQWCZsBcWyhk2tmyt3BTbUjXTOz3iNjNH7R2Lzq6JgegHretRrhErUg723ubH+JVPd6CHZgMj9W4Z8zWZ+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4aPItUtEP0v6XsZkmwa6eYW1mT2DWzlEycpMJtAvxP7HCTymD5Thiw8CAW4TKSo0jsw3VIt6T6LCk3uYn/vRKDe4+mYuLOBFtKrcTrbzBikTweISvhXFlx01DasTG4RL/bhMdOHPaSEdk82sYTNvhj3/NK7eSLg11dJ50IL62VmLeoNXw77i/8aMbvr3RMV24I5GF28dRuRYSia7d6ahMsapxRGBfywMLFNbGzYkqZc/BOdOV2xd13MMfk/pbgcxkkBgCoHakZjl6OMJeh941+hL0SKHJ5N7Xy9hIyVYF+4gtqw1grlVcurgY2Qvb2czTX9dLR3yy5nmTc2NqQloTgj64JCZwDn/fYToDKZ6AAzT6UMnCTeqZIOOmuNATfU8svq2UGmqCxmL/W+XF5tgXDfqKiRn/Xm+DqP0y9K3lXiSCF09/HNHmAL2t33raxVgHHmi2r/4oP5EPfarrkz6oPjeeqW4MoOZlOwtu3OHvAyY8Gud6UPH1STqPgNCn6ajR4kIgRm9bhSxPhA7w0eCQH8zW6+kTMfW9P30y2yJk2Lo/Gt+d7NJ5n6rie9FXKD7RuMs9Hh0uZTRNBXYPNb72NTluAd++YIffxA2GWgySQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1cdb8d3-a8f7-43e3-d04a-08dedb668742
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 13:57:33.8805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTIl6UAhQxuNYDyhedD06FQ+kh+4aqfxef740xXDXvrd1GmBktnWyVAGFMF+OEj4Anz1GhVT061fW2VnjcUTcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6706
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060141
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0MiBTYWx0ZWRfX4Cr+lLy5gR2L
 DlJgoGuxuMVtGjAqh3alu4h1D8/J7yaQIWBmlZCpbXh2DsQ3u7+0NxOuV3L1QWZntIG1T1uVVFh
 r2DrQML+RtRcbib9nE9IIx/+y0Gw5aBCvftIcQ1IQPcrRG0ichAaNpLnDVciQZGcXZmfgBh0UTI
 efrOoZWe926jKkh3EgxjMRPZKGqktmJvr+/9GOVHzGqAd2FHtHXWXllNXQCRlb9RpaaB8sVjO0b
 OLBCQ7r9BBv+JHv6w8jBIzyE/MnnLx7DC6cbvVxeQX9MbTFpkb4KVHd4FE0nXFSedvy3RABoQdl
 Wjf1W+VbvDPZ4drbeS60PbdyOhuYMU6rwF6nZFdcBe3MEPB9lyh3DMmMqQJ9YMerOV+6MoiRHdD
 gW/QYl8tufd7lp7MwIziWGQgXQiUeC430mFb8X9EYjD+oSIZhhOH4jlr54rzcf5YBiFzUeuR0ht
 JTEkXJD5lzjxBaU8wpQ==
X-Proofpoint-ORIG-GUID: IxaddAIttSZrqh_DnKHjJWV2wQDppyqD
X-Proofpoint-GUID: IxaddAIttSZrqh_DnKHjJWV2wQDppyqD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0MiBTYWx0ZWRfX9VcqKwkZZfo1
 e3GlclZM8PEV5VQ5fw2JJcgJTubEIIi9TT+JbPQ5guSKPrXUaNcYND1mgt0V6VLwzjOILNxnHtR
 IQkfBJYTf9FTFCO0cgXtCIQGR61j87CJ7AKO7wSnjvEQ1nYQfUU3
X-Authority-Analysis: v=2.4 cv=RI2D2Yi+ c=1 sm=1 tr=0 ts=6a4bb451 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=5-EkaOFk5KEzbGM9VOAA:9 a=QEXdDO2ut3YA:10

On 03/07/2026 11:44, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] mpath_iopolicy_store() does not clear cached paths when the I/O policy changes, contradicting the commit message and leaving stale I/O routing state.
> - [Low] Unused 'count' parameter in mpath_iopolicy_store().
> --
> 
> commit e168713423f62d0ecfcf0e0b0c9ed72180e1f19b
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add sysfs helpers
> 
> This commit adds sysfs helpers for the libmultipath driver sysfs code. It
> includes helpers to get/set I/O policies, show device paths per NUMA node,
> and handle attribute groups.
> 
>>      Note that mpath_iopolicy_store() has a update callback to allow same
>>      functionality as nvme_subsys_iopolicy_update() be run for clearing paths.
> 
> [Severity: High]
> Does this description match the implementation? The code doesn't seem to provide
> the callback parameter mentioned here.

will fix

> 
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 6d2e1186a10f8..4945f2d847fbf 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> [ ... ]
>> +static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
>> +		int new)
>> +{
>> +	int old = READ_ONCE(*iopolicy);
>> +
>> +	if (old == new)
>> +		return;
>> +
>> +	WRITE_ONCE(*iopolicy, new);
>> +
>> +	pr_info("iopolicy changed from %s to %s\n",
>> +		mpath_iopolicy_names[old],
>> +		mpath_iopolicy_names[new]);
>> +}
>> +
>> +bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy,
>> +				const char *buf, size_t count)
>                                                   ^^^^^^^^^^^^
> 
> [Severity: Low]
> This isn't a bug, but is the count parameter needed here? It doesn't
> appear to be used in the function body since sysfs_streq() is used for the
> string comparison.

will fix

> 
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
>> +		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
>> +			mpath_iopolicy_update(iopolicy, i);
> 
> [Severity: High]
> Does changing the I/O policy via sysfs leave stale paths cached under the old
> policy rules?
> 
> Neither mpath_iopolicy_store() nor mpath_iopolicy_update() accept a callback
> function pointer, nor do they clear the paths themselves. As a result, drivers
> adopting this API have no mechanism to hook into the change to acquire
> subsystem locks or clear active paths.

drivers are responsible for clearing paths after calling this function

> 
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
> 

