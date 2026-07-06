Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122F23F44F7;
	Mon,  6 Jul 2026 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783349401; cv=fail; b=brkwuwrC4nhFEapJxBfiWJ2NYPz2RRFmfsRyUGMiQ1iqUeZrWvBAPExh54Owoq0MHWlaoRCyLav4cIaetnXc3RJPmYzM6gh5Ch9VYbVEfRmQMft2KiOTGqxXWQpYnWYCBP1lP2DB7LRxM4NxfSQDix3QiG1N7h7S5qjpovwvyVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783349401; c=relaxed/simple;
	bh=8UeFVI/CiSZf1gNeQ/N6TQgWYCx7PsCr4aZNznJ5Pyo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XjReWmmPUtde+433Sbz66zPJkQMer5DS9NwoqyrrjLXwxOT6GgZg6ZkZ4wmg0aYOvDZ0b3nmt4azrIuELvpq3r6M4e6KWl7Oqc1lT9ChXVol8bSgJ2nws3yZz2FK74fNUK58aTp3mQNy/ooItWWjUXq1alJqhbSUJTBe4RCFzAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oleuDGlt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gi0epYdJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oleuDGlt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gi0epYdJ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666EcjVr1088739;
	Mon, 6 Jul 2026 14:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vFaIArClaO/kyDmdTUdPL3dr3ma1yjnVoKbe947kTQM=; b=
	oleuDGltV9Zlr3tHREV+zuCyquUDPEwT5rS+qY2nEx3ysMYGWgtAdnyxvjOZ3/wQ
	BUbWQRDltobPaCOywzBmej5OYjkq+onpKTfn0uA7ahhjSKB/rHJMagpkUI+iRjKI
	ZNWESNCXndUxlOQNB3Es7OFRRhew74Lb4tVLs8m7WTyxBs2NyQBjVg5R+FlRzznH
	Qwy0Fyf3sGIjr/3Ze6neJRSf02+XxTxIsamDA902nKixg7EIMdo3s/oKwnaIEfS1
	4omQOFB9FihVhLjp4DSJZ/ZEvRZcuMJRTvHL7hLulg24UDfRV9GXYqqKtNFk8jec
	esutOkIjYqpAG7bQPZtclw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6sssbsrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:49:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666EhV87024465;
	Mon, 6 Jul 2026 14:49:58 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012039.outbound.protection.outlook.com [40.107.200.39])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmp83u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:49:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BnBwvut37sklWXOLAogOzoTth57YO5/bUbMdlVkUW3hotqaTZj3rXF7rAmD2oOQE5OyqhuWzCbh8H3EDcrEMk37120oIFVSdHJ0FeVbMdw/ayEjybNDxWo/gMJjBIhL8WbZlK+heOByNGjwrk30JzRm0dBmkgracHySlGVvc7sifWDVEqH7p4E7Uc2kINsNI50ndup0qs5CgGTJDxUd6deWjLm0xzY9h7crKZX6SO2uCV5EGyFAghaKP2WU0xmEIXA8flenleWLVFgN0rhvVz+jVv2EafjCuLadT6gc29lWBTkmWChPFYbd0vq9emiOEKFpH8LzgO65/s9woCIDHfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFaIArClaO/kyDmdTUdPL3dr3ma1yjnVoKbe947kTQM=;
 b=tZfFxaq7zOvbm5gGb/XCU8Y011+g4h7o6TcVb7ml4YaI/q5P8xiuY+sI37Cb5tz/hver6HJ/7W1LElAStqBXN7p4YeiEKyjLfEeVqJdI6kFoKS1EC9w/CVFF6wcUsYiWc8XGbDA2bs9x+J281K6+Vp/BK6Gc3u/Qhzi45zdINaFSDAqTi64KiZTDOVNAuDnOiJ1F07Ra+rQyKPZnMj7hVtAl3jh3dpV2CZneA+rFP4ARC+sJv5JYVWtY/Att8v5CQeiL2cdlNgQePn4XSIIRVPVYjo48Jrv+MePasGKRobygFh/12WYL94uYNv12OrL8oP/2Wa0TcVEOsNcgkumZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFaIArClaO/kyDmdTUdPL3dr3ma1yjnVoKbe947kTQM=;
 b=gi0epYdJ3utCJy4jy0N8KUa5GSInrCN1lK5y8UuLCaawJZFSxyUCpAF7760IMFijU/Cf5mHfAdxg3kqW8vZ6OOsp4nXAjYmd3hUF1h8QYO2OAIAZweKHS4Fd5fxgm96UVeFzUQmaZ5oyWZji7ra6OACVkm8Trnm68wFZZbN+eeg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW4PR10MB6297.namprd10.prod.outlook.com (2603:10b6:303:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 14:49:53 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:49:51 +0000
Message-ID: <161884f4-fd1a-45ec-88bb-335d1001fa1b@oracle.com>
Date: Mon, 6 Jul 2026 15:49:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/17] scsi-multipath: support iopolicy
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-5-john.g.garry@oracle.com>
 <20260703111046.C57061F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703111046.C57061F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0293.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW4PR10MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: 14ba8540-d0c3-45c4-1770-08dedb6dd588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|56012099006|4143699003|5023799004|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5NG3tQGJThofBmW1H5aRLR5/6dsT0EMnPfrtgNoWvRhX4JbwVALt5BOkjjIPWUeB2inS9pNoFtqVy6vUjZ22F5d1WR1b/9QMKPS0Cxc2Xigr6E87NJrKduuiQMOHLdfQUxnpIus0XfyIR4WdOSKo1nJxymILq7GW7zTrGpLPcKIDOuubfzDxUEpMITnSJvMDWFa7FVpz7Ywzj/mwQXR9kOLbhtx/IrDzTTvRzCJRuiZKZAxMtVr+/wbNkZ1TWa5+S9QZnozc1c/MQ9QxzwU0Y3hhW2s0zzrt2D08yTx6ljFDcpOgWSMhOd0VEke7hp9LgyrbNQq1Gdy8wEDUgnK+zH7YentCRuQsnBZbFnlh5ESqvkJReBloFrQHr5lEdTmMVN0Gc8H4EklOJ/VWbRjHBU7miGOJh+0rroqWMeZfeqQfE/gAa+VkZg8C9EGn/e4FdwiN307EQGwMRvSPYCfe5PMxQVlYAYCKhSPrjOo6uIjAurcTwnOwxwNWhhPQlP3D9uIu1ox3vpxTUSqNNX/fRGBngg4hEQK87Gq3g5m9EYB24kjWwIrKSpuLepT4NUntYSzuS/YzrlDwD5wbvkm0kv+E4lHL782J1aAwaS3K7XXv339/CzLwd1rpsEze1STBJXFNJAR0cYs6w1v8N+x8SLL6dVzDQoH74IC9+vtyMwY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(56012099006)(4143699003)(5023799004)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVBSNUpBNlJva0pNM1RDS2Z2STFIUDY4aEc3WWV3Mkp3bG50YVkrcDkwWW9F?=
 =?utf-8?B?OEhGMGtWL3B4bGdxK1QwdVRKd0UwMnpudXI3aGhxRmlhWU0wTjVrWjFBSTln?=
 =?utf-8?B?aU1QeFFsZUp4anBjaGhrWG9LQ2tjcXA0MFg0WlFsTU42SmpRUEdKTjlibmlU?=
 =?utf-8?B?S0Q3ejFGUEZ3SEt4R25Nd2xBWDc5RldPdnZLYjNKZHdmWldQQnp6d1R0eWlE?=
 =?utf-8?B?MXpyVDNwMm1zeTZkejB3NGdkQWNnZ2JtTFdZVXRiT05kbE5yQU14WStaTGdu?=
 =?utf-8?B?d0JhRXVTczFwNmxYbVJaSjdsNGsxTUhKTDcxc2hNcWtqZDNCTTRLM3U1bjdh?=
 =?utf-8?B?a21PZDBQMDBZcExkanFmZU1KeDB2Nk8yZmdKRHpDZCtaQnFBMVJXai9WVG81?=
 =?utf-8?B?UlR5UFd2SkZlY05vaUJ4TXk5N3Q2OVUwN0Ywd2NOVEJqSm1WQ2J5L3g2YXU4?=
 =?utf-8?B?bjhER01YV2RTSFVpYmg3eC92eFRacWlvekFJU0JqUHRaS2VRNTNiT3BsVG1W?=
 =?utf-8?B?bUhYZ3hDdzEwTFFrTEY0TGlEQUQ4YjNDcUhYZEU5cmVZRXh2NDQ3TVhWVXpG?=
 =?utf-8?B?SC96NmZIcmVLUUpJM2RTTU1QdDB6cE9mYUlmakYza2NRa212d1kzbEJhRUl1?=
 =?utf-8?B?S04zNXAyWGhzR2k3YkgvNDExd3pQRnpYUjNoY1doZk9mQkZUNEI2b1FJa2pv?=
 =?utf-8?B?OXBVUEVqNVlQdHM3VTZ2ZFpXa29EY2lCbk10R0tkazN6MmRVNzc3M3IvVUpq?=
 =?utf-8?B?aytZNjFCZXdod3RwTW03cjFocStKblJ2ZnNXdlA0S0RlTFV0M3pZSzVQanF3?=
 =?utf-8?B?bm55R3I5aUFtYTJ3ellrQkNxTVA0Q0lDYkwya1NMWjAwdHA0OG80RFJZbCto?=
 =?utf-8?B?YVJxbVZzZzFXVlFCV1Z6ZFUxQlJyRFlkS2lQWUhaYU5GUHNRNVdCYnRMTzEx?=
 =?utf-8?B?Y3Q2OFpXaDRvYnRGZk1PZUVVcWpNU1c4RGJFNkxrTFFoNkRDR2drZFFhcXE5?=
 =?utf-8?B?OWhFWGFsZURDNVFibUk2TExHNWt0WGl4VDRFUnRnU0REQ0FUS3E2TzdVNEUv?=
 =?utf-8?B?NXFHUjE3M0EveHNUVTFOanFJV0RDWjJVWGZ1QWNYNC8rMlhhWXhaSk5XVS9z?=
 =?utf-8?B?a055WitUNlZidGR0NnRMZEZ6QlE5S1pHRWFmSkRoK3QzTmc2aXUrTlNXcGxa?=
 =?utf-8?B?QnlkbDBMZW8xSWNOOW1TZlJqMFJRM3l5UzJ2M3YxOUZaUjVzQWhKSlNNdGdJ?=
 =?utf-8?B?MWgrZWNsTXBqa1E4YnkyWGhkTzZkL29kSWxDeTFNM3Nac25PRmVrTFI5TFFY?=
 =?utf-8?B?S2JQQmY2NE9mblVCMDhTZUlVakFzNFo0REk4aEMwSnVWYlcwcUwvYzFNY1Zt?=
 =?utf-8?B?SkJQQkZEUTZ6dUxiTUwwcWlyZjZuM2VXYkdpcHpxWWFLcXIwR2pVbk9rVFNN?=
 =?utf-8?B?Z1VqTllDZDZ0OVZlWEYwSjZBTkZyVlZPZHM5emUxa01Od0kvUEpmUndIdU14?=
 =?utf-8?B?SUZyL3hjNGh6aG4yVGNNWWU1ZStHZ3o2blA0RWFuY0wxY0dVVkd3cUtNMk9y?=
 =?utf-8?B?eFZNTUxoeERWOFh6bk1vM3laaklFVkpzNzg5RnpDeStudVVvRW1mMzB1MDdF?=
 =?utf-8?B?eXE0eVA3YXdtZytrbTRYckpZZmFFb29nVVlxdGp2VUxaZEE3S2E0WDFnTDNJ?=
 =?utf-8?B?VUJoYVJIeDUwRjJwVjBFRVRTVTZKaG92Yzl4dXErSHRqaStXOXRtYml6SUJs?=
 =?utf-8?B?c0tsOWl5WUdVY2x4Wkw5R3BnWjAvTUIwS2lVNERicHdvdWduT3lsSmFMckpH?=
 =?utf-8?B?OW9la3JxYlFmMDVtdHdQaGZpWlhNdElmSzJBRGZlaXdHRkRrM045cEJnV2p2?=
 =?utf-8?B?S04vWnpUWFMzM3kzeTUyRmZhRWt0Q0FWWERTRm5iOERuZ29WRnZCYXRER203?=
 =?utf-8?B?WGs3ZkZSc3lad3ZBS0hlUjVXSXVMWjZpMXkvN0xxSmM1ZURQbklETjdWOEFk?=
 =?utf-8?B?cWdGZi9YV2lxeGtaL3NRQXFaRnJldm1tdnVXVzl3eVNia3REYllzQzU0UmZT?=
 =?utf-8?B?QlFRZEo4WDVHL3JBTG1JTFpleEZWOVo4T2pobDA2THVuYUJ0ZlhwT1NBZXhO?=
 =?utf-8?B?U2wyM1BpNkc2UERsUXY0N2lNSnZPMEpYN0xtMGk1dHF0ZUdqZTNpS3BZOFI1?=
 =?utf-8?B?REQ5dlcxR2t5K3hoOXUzejA0REpWSDBPbS85Y3BTQzR4ZENhK3drUk9hTW9j?=
 =?utf-8?B?TlRaSE1FTDVmNmhQZlllT25ZR2xOMGFmWFVZMDZlUXJPZXlMR0tDU1RQdUoz?=
 =?utf-8?B?SGR0NUgxbU5oUW9QME9CNGNxNGt3SW45Yzl2REY3aXRTVmRiT2NqSyt2cE5V?=
 =?utf-8?Q?L3ltB/S8+ZF02ICw=3D?=
X-Exchange-RoutingPolicyChecked:
	iE1gv1tBagK7MinVLW0j/huaYvL7kwhtZVlRhvF8jKI477uHfQWoUQ+DL7QZfjZ3gjrH+MGeMJ/XXyVRJXzi56iEeymkMYXw6Sg7/q4TvlQKcX+8je4gge8sfhovPe8jo/VsbK7pCAGWrEK0Y3CEiFd4qCNRTxYRS3ulbfAYyLJugh/TVGOHpb3UgxE6FtyCxym0/kPEEmB2IfSG6K7wSb8UoiM8D4fQHgLGxONGc7i1pu48AANzb+DS+FUsI2PvrCDT94Yx1LMVIzHb8qPyXNYoB1zEQgcP5IEUfQkNNj9v1HJVjREJF8DjsyIYmQeurxAGYQ3v1UTpq47scTtDQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dx2toTZ1XdjG8KzJhGCxEFCTnuZaPlHkvUZoH5KZ1H/BwA8SfKmCPvOfQ5DrDGEOR1gIcpthnRSlLIIuU3Wpzs+/miu//pOCJta7c28Z7ZmW6xJiRYbIvPWaxfVmIzObJzgUkOW4+wFZSJEm97BR0/8e56PFzfBwADXjGokacV4cdG/8/SZFDglPx84NnVu76Nnn8YNZbNOF49WJq2ToEmOvk/ZdXtusYLBXDJu03Tn0eEwB67aj5GeYMv8lrQ8xcSVzxvt58t/nd6HzVK+i3ftxz4Tbcge53LFoIgy0FO+n+lV/w+t2FyqE532VIuXMQ9AS9T2j5tYXmMO5ahoBkCQAjS98hCwrx/49unY9jsybno4bAzzPkn+aM7i5mNDNtSGMF3qDxHS2brRkM7xf7no7iyiGB5GtiqEN53JtmLf+xThEt0PsIhQVxmOj3swQgW3SCg73zw5dpQ2+x0eHQR1r91O9BAJPyhGlT2DPy/0zvi35823Kd2e7CRfYW2nmI1iOXKFAL9WYcyVYVANPcoJC4VnGqgL+ggY92FRgxUvEP8Dm6xat+NFw+DYlVkvQivVIwhxdaZImBkOsSeKaieR+SD5oxreR1bCNU4Fk9lk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ba8540-d0c3-45c4-1770-08dedb6dd588
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:49:51.7141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZ2cyU3R2IoGugBPjjErUBP90emd5DTdSQ6YHxAduaGlmc1MbcbjjQUoN8zD6XvWcz2B/Wh3kSl+mVQpdjExKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6297
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060150
X-Proofpoint-GUID: QA9RK5juuzQYsTGa6JzHtYXS3JBPQXSu
X-Proofpoint-ORIG-GUID: QA9RK5juuzQYsTGa6JzHtYXS3JBPQXSu
X-Authority-Analysis: v=2.4 cv=LpuiDHdc c=1 sm=1 tr=0 ts=6a4bc096 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=R6g8rOHrv9n-TBtzYVgA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE1MCBTYWx0ZWRfXzXVCCqog0iWJ
 gjJAgLdB8JweZ50NAYgzkbRtQrQpAjpSvFTRBh5p0l1cmavLVgig3ZGt/Xs9sKPtotqVXU9WFUd
 Z7QpehafuNCCa4xKRScTURt728lZbNBtjXFcxKzHO0heWBDUXWyW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE1MCBTYWx0ZWRfXwDAst+WJD2iM
 nS4i+O96Vk1Sn+eRVMsmqr1NkQS61BOKkin6iPWs7gRj5+eq7/64vBaKiIS7LyA74pQevVHnptU
 LbqxDjmKDaKB5/kOgNyYJ/f/vguDUVyaI9I0b83Ud0oVPBdLsB5OROH3ahYeksOsH4qJge6nZ35
 v2U4IKCiBrpM7XPqoUbFdBEQdyfj+HehNUyAJRyVkpS0EPzfjLwriihyGJ1RUcHeBDOTf0YYdWg
 BcSeqCi0IKyx48dsWZ6g6QlGDOu+Z/HaIuYWFWJTLccVAV72X5hQsk+BYlviMBJMl+GbQfXs9yy
 1Wn0rlQD5XkF/GJP36Zl99uuSm7Fr//9BmvlAB05aDgnkwR05fG0w35K9wG+R26tqDaWokVJ4f2
 0UqhLyKbGj8MrGK2cZXn/puit5j/25Un+CvjsOVjqlMWYDKaP3cMaQ2mFu3Ft1qYdtMG2k66zWt
 xWm2ukzfQTFrWpqXUmnwvHuxdjuDWK2XubGvdVkg=

On 03/07/2026 12:10, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> 
> New issues:
> - [Medium] Newly allocated multipath heads ignore the module parameter default for `multipath_iopolicy`.
> - [Medium] Lack of synchronization in `scsi_mpath_device_iopolicy_store()` allows concurrent writes to race and corrupt state.
> - [Low] The patch calls several undefined core `mpath_` functions and uses undefined types, causing build failures.
> 
> Pre-existing issues:
> - [Critical] The error path in `scsi_mpath_alloc_head()` performs manual cleanup after `put_device()`, leading to double-free bugs.
> - [High] If `device_add()` fails in `scsi_mpath_dev_alloc()`, the error cleanup path crashes due to uninitialized list management and invalid device unregistration.
> --
> 
> commit dcaa6fb2d7264e46f58295ab1af4b1021442b793
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: support iopolicy
> 
> Add support to set the multipath iopolicy. The iopolicy member is per
> scsi_mpath_head structure. A module param is added so that the default
> iopolicy may be set.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index cb433a028dbff..6159803d4cbb8 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -95,8 +112,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
>>   
>> +static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +		container_of(dev, struct scsi_mpath_head, dev);
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf, count))
>> +		return -EINVAL;
> 
> [Severity: Low]
> Are the functions mpath_iopolicy_store(), mpath_clear_paths(), and
> mpath_schedule_requeue_work() defined anywhere in the kernel tree?
> It looks like calling these will cause build failures.
> 
>> +
>> +	mpath_clear_paths(mpath_head);
>> +	mpath_schedule_requeue_work(mpath_head);
> 
> [Severity: Medium]
> Are these sequential operations safe from race conditions when called
> without holding any locks?
> 
> If multiple threads write to the sysfs attribute concurrently, could they
> race and potentially duplicate path clearing or corrupt the I/O policy
> state?
> 
>> +	return count;
>> +}
> [ ... ]
>> @@ -201,7 +246,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>>   
>>   	if (mpath_head_init(&scsi_mpath_head->mpath_head))
>>   		goto out_free;
>> +
>>   	scsi_mpath_head->mpath_head.mpdt = &smpdt;
>> +	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
> 
> [Severity: Medium]
> Will newly allocated multipath heads ignore the module parameter default
> for multipath_iopolicy?
> 
> Since scsi_mpath_head is kzalloc'd, iopolicy defaults to zero
> (MPATH_IOPOLICY_NUMA). This assignment hooks up the pointer but doesn't
> initialize it with the global iopolicy module parameter.

I need to check what is missing here, as this was working...

> 
> [Severity: Critical]
> This is a pre-existing issue, but does the error path in this function
> cause a double-free?
> 
> If dev_set_name() fails further down in scsi_mpath_alloc_head():
> 
> 	if (ret) {
> 		put_device(&scsi_mpath_head->dev);
> 		goto out_free_ida;
> 	}
> 
> The put_device() call drops the refcount to 0 and synchronously invokes
> scsi_mpath_head_release(), which frees the IDA slot, uninitializes the
> mpath head, and calls kfree(scsi_mpath_head).
> 
> The code then jumps to out_free_ida:
> 
> out_free_ida:
> 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
> out_put_head:
> 	mpath_put_head(&scsi_mpath_head->mpath_head);
> out_free:
> 	kfree(scsi_mpath_head);
> 
> This manually repeats all of these steps, leading to a double-free and
> use-after-free memory corruption.
> 
> [Severity: High]
> This is a pre-existing issue, but can the device addition error path lead
> to a NULL pointer dereference?

It would be nice to stop repeating review comments from earlier patches...

> 
> If device_add() fails in scsi_mpath_dev_alloc(), it jumps to out_put_head
> and calls scsi_mpath_put_head(), which invokes scsi_mpath_free_head():
> 
> static void scsi_mpath_free_head(struct kref *ref)
> {
> 	...
> 	mutex_lock(&scsi_mpath_heads_lock);
> 	list_del_init(&scsi_mpath_head->entry);
> 
> Because device_add() failed, the object was never added to the list via
> list_add_tail(). Since scsi_mpath_head was allocated with kzalloc(),
> entry.next and entry.prev are NULL, and list_del_init() will dereference
> these NULL pointers.
> 
> Additionally, device_unregister() is called on a device that failed
> device_add(), which violates driver core API expectations.
> 

