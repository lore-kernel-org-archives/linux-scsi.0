Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D23240EB9B;
	Tue, 11 Aug 2026 08:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786437038; cv=fail; b=uG8yHL9Ov6/noJMD/U1flbZaUPFJYvqn0mN/HsFpENI2qnprgHJTQXhrzwF0kDuKAH4XBSPWVmRPY3F0S5PDE2woT++aewOCrTNgnaevOs8vHmJxZTroV0OOaJyaFbFxzP5h7HdnXYECQT14Xkrp2BfCyUnqTi/AFQhODjUnAKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786437038; c=relaxed/simple;
	bh=z3JEjLmKeS9uywHwGJWPCKWLaPUdiiBGSCQalUYXx6U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gCUqNLHUNxbxYNfuTzd/DWqUMdheTwbqmBtKYyuJwheEMCw+ofl8/R/0oPhVDtaUxl6dl9+t3pSiJrNgpo2C+WpZ0+q8T3gLYaCYu+kOEs+tj+MRVYbZx6iLjIgyyTEWBvoMepQ1ugloiSny7wyYxMz24T4Kthl7uGYvhrMql2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MiX5xbqn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KbCWtFmd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MiX5xbqn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KbCWtFmd"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67B4aIfD559879;
	Tue, 11 Aug 2026 08:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0PzxIUF9y5P3HczYvk8zEDbZ2fel0/pSFn8ttA2VBVY=; b=
	MiX5xbqnU70nJFEMpPizIinco3EEg5TLR52hF3HW8acHSqhvf6FS7THnA8kirwQz
	Lx7uSOabAT8BAdvlDcr/DSK0t0hB6nXAtb7qDVVMJLoiAxGnNGOtMFgJa8OoPyjt
	cdSM/ARqGovpPmhQihTwFpOY+DBXU/RvgBenurcj7uaSJcwuYLNnWH5SR6zhi7HC
	AnFWP9mEir480MlHOchx5piCiy3s600o0xpfKblYwt+aXP5oh5wh27kKUkMvlUhL
	WVBub5LEzspIByqR4IogG5fFWVAWalFu3p8fZKHCPIE13eoO7f+AHaEZnKAopNsS
	B5bpwCLgEeZNxBhq40O9DA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvesvcd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 08:30:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67B8UDkL037683;
	Tue, 11 Aug 2026 08:30:23 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwdh3cp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 11 Aug 2026 08:30:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SUt+gFboaxeaGpK1BIHqpiTIJq78rQTBqtPnIpvabqDgRTAqDKUvi1VhzYPh15MKj1lyHLo4qCOyC06qNJnUx+Y+5RO1C+a2xwDOYdvDylNVW1T/gmmO8uevafh3CdOWvzXkrNhh1x+vTtcjXELDx7igLjojDODl+QSpr47QUlHOoW0A2H+NgkqUV9+b3MLZW0su/7xjPXTIHHCv6QSJkdLgc/e9Uf0M0Vec7RZzPSPibLvpJXR+HiZKVBslMWXM9USHS0MkWLI8ApM2joqw5zJGPP8RklHUZmDEKBCRQx9t/4Mw2GAeYqJ2Z8Kmt+HSwe87B5WuV1mCLwiKumcFVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PzxIUF9y5P3HczYvk8zEDbZ2fel0/pSFn8ttA2VBVY=;
 b=eV2jOzd2YRAaZsOFUuV/ILK0ZgbsS0wtom/dbLIPzSuEV89bGdBkQftdHB7646vTgf5vFX9IoXGR98aVywnSRxmi29VtRF/1OsVO3u1jwgeEDZuMW1YAcEqfqXrB/fbdLldlogo2h27JsJTUNmfWOFadtj+Mh60+1xb3W0nOPN7dop19XAiQdzfAmV76FLuOwDYQmC9tBMHCitR4rFEelkduVMbAwl7mGAODUfC6yciMp3ocXM0OHBAVWcy5r9qvNqE0Rbc2A9kX9tWLpV9BxX6RUaOrI/riXRduSdolmR9Nafl5erTDwtQ42xgESXhSln26nEea0DolJ/w15Zm14g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PzxIUF9y5P3HczYvk8zEDbZ2fel0/pSFn8ttA2VBVY=;
 b=KbCWtFmdmH315RJfFj+53Wn8lZ240oLVPMab+qgalQXLohRWSjkjWEzD25f+r9LQsPLidMFSWOq+bFZINsmHdqacfmT58Z4vLYaBc56FZ19A4vqTKkMfvEOBj2ZIwAYNoRWGLPlZrCJ0BBYgcOarswKEBeh+xBZsP9A1GU6MOfw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA4PR10MB8375.namprd10.prod.outlook.com (2603:10b6:208:560::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Tue, 11 Aug
 2026 08:29:42 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 08:29:42 +0000
Message-ID: <330119c8-14d2-4c80-8077-ec572b167c4a@oracle.com>
Date: Tue, 11 Aug 2026 09:29:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 1/2] scsi: libsas: Add sas_ex_phy_to_dev() helper
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260811040334.4184911-1-yangxingui@huawei.com>
 <20260811040334.4184911-2-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260811040334.4184911-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0305.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA4PR10MB8375:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b68175f-6e35-4034-a74c-08def782b0f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|22082099003|18002099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	OaTRxov9KVeQXnLc/4lMN+zx5VkAMpeCHgZhtEco2Ahbc27Nu4Ue1WpTl72xM/VCxXMLkAxvHhSxZ1cbHI4UWqNf+W2l7gRPNcob6EiEZg6uiNMYhSuJ/iNkhtd0kCqzz6z/sgLVIo6OhICS7ulf0kr0kymCvhhjCaxI1m3MT4yycxYsvXzGEjS4UiOkIkssDOBVegcOwATewp28yrMxr2lOjSs72xfymtpfBtfXBM3cE3EBZFokEhK2UKaAoSQDPnZ1VQr7mRCnk56yy0ouKIKthEKYWf3bd5RDdPanW2XzssntZIY7i47Wyy1twdtHuQUISiaPFMjnEB6KB+TK2UBS+ayF8pqvTeAWaqwXzHGL/xFIIPVvoQo+q3qvAdxIcy1fgO1Qn/petUm1KlYV5ovJ7LAiZy6+Y7iLoHwea+zt2zBojRUR7k6CZa9q89Uf6P2GTFoMbwXIgjWHLfVVU7HT1plLBkrSJ/XckVbBdiH+cOXZgqC+Hi+8RekNZ9XLs7U+fMi8KkwZBHTl9ZrjXcUN+xvZTemeqR8EDISB3gr91Uv5DiuvtsEqI4jgD1fgJeSbuugQGiZ1LHjh1QRGUeenrIjf9tKk6erRwA7WCnAItxfKxN5eduDkPOQchWH6xs5LaGspdgEprCn/SqB/kfr+cGjz0azHAu5WcFdSyfY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(22082099003)(18002099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0hXV0JJbCtGMTdyMVltWlVEM2RTMENyVnhLVStCUUNFSDdmVkJFbHgyMFg2?=
 =?utf-8?B?UWgxbnh4QzZ6bnBBQXdMQVBhNHlaYmdraEtWeHkxdlcwTWVmMWtrNk4rdVRS?=
 =?utf-8?B?WnZ2bkkwUjUxV3BwL29KVzJFRlQvbHd5bHpkSVNwVXdtbkZnaDE0ajFBMzdB?=
 =?utf-8?B?Q0R0RjFnRjdFc3hyTUhLbjlFNVN6K1ZwUnFlMlBqdjI0OHZLajdQYSt0c3B3?=
 =?utf-8?B?QlVrZDBFamZ3Uk5ocGNqL3UzL1g4aHQ4eG5xQWw2SUdlT3ZzSmtpaXFXa0I2?=
 =?utf-8?B?M2M2aGhGVmxMRUg0U3hLVllXRk9ObCs0V1hxd2kxaHpMQmVqR2ltR3ZOODNU?=
 =?utf-8?B?RGlyVU1iaGNaRlg4MFo3cllOSjlxb0g2YWJONFFKRHh0RSs3NnUyUExscHl0?=
 =?utf-8?B?WW1ESVBQc0VEQkdsUEhjNzNIZHBoWW40MUpoWmtqTWJjeGN6cHJsUm9pRyt4?=
 =?utf-8?B?Z3BBdjh1dFZ5ejhaZDYvdit1K29HbEVjTmU5OUhLdmFSNDdsVzVPMzNpZUVH?=
 =?utf-8?B?RGhWR3FJcWJsWVd4Z2ZjZmEzd051SVNBR2pmVWZmazR2TU9uV1V4Zk1lb2ZG?=
 =?utf-8?B?dVBXRm8xbmF4a3JueTl3VlhwQnNKZVF2dEVkTnhJVHUzeUFQNVN6d084dVha?=
 =?utf-8?B?Z0x1Q2lEMi9sZEU5QmhtdWZsQ3pLNG5keFdYaWFpTnBFY2Zjb0wwdVpjUHNN?=
 =?utf-8?B?Z2p3ak1CQmxnQk9ORTNTdjlFeUF3VTNSQmxEa2s0OU1hb2UrVHlRWWFheHFR?=
 =?utf-8?B?TDFhSGkxZlAweEl5MVFrWEhPMG1xTmNLak1IYy93Tk4xa25sMm5KWnhKUkx1?=
 =?utf-8?B?cXRDK1VOa0FWd0lER0FhdTdRb2RiVENTR2lvNVpvT3RLSjMrdHNHcktVbFJE?=
 =?utf-8?B?T1lRQWVyTVU2S0NhWkh5cnZlUnFSeGE1Qnc5U3BOY2Y1UUMzY1NBeWF5bXM3?=
 =?utf-8?B?b1U5eTkxUDF3dFpNdDhoZU81N0dxWGZKU1BKY3R1bGtMcEx2Qy82Q253Tyti?=
 =?utf-8?B?ZnVXTFYrWWZrOWlyaFNzaDh3YjZmWWJNc2h1MEpvSEFNSWxmdm5ObjNDSDhG?=
 =?utf-8?B?UVp2SGJ1V3M2alRWbDc0WG44V0JFRXlocllmeHRhOEIwYWdiVjZFTDdYMGgr?=
 =?utf-8?B?RGVQaS84UDdzTGc5bDJ1aldJcVRFamNMVml6dEZtczVMRUpTVjBvcm5kM1pC?=
 =?utf-8?B?TGt5cm1KRVZ2cngxaXBwS3RMNlZ5eGhhZTRoeFdCK2N3cS83cGp3NUtJZjNr?=
 =?utf-8?B?N1g3RHU5Y0ZSL2RjT09oZ1laSWE2VWtZUXFibWFJalczVVZiVGpHMWI0Sjdh?=
 =?utf-8?B?MWtGOHNnUkhtZ0Y5U2F0RTFVVlBjdUtyTHRvaEw0NW00OFBwYTFPeWFEb3gw?=
 =?utf-8?B?VUw5c1lQRnh1dXRVaUNFcDc1alNVOWZEY1VSQ3ZOaGtoOWFucU9EUkNKMkVt?=
 =?utf-8?B?L1FKMTVCZTNYa2Fha2E2VHIrU003bDBsOUFRL1dhSlR0WGdkTlJvK2I4YmEy?=
 =?utf-8?B?aXFMRXBtY1RGUjdacGZLNXJWT1F0MnlHcEVVL1N6WVdHUDM0MGZ4SmtRZWtW?=
 =?utf-8?B?SXQxQnhGT25mODM5QTArYXkrYmNWL2x5NHhUalREZUN0alJGWXE5NGdWMVV4?=
 =?utf-8?B?bzY1dkpPRGhqaU9Db1doOVVtWU9oRFlrMCtmbmk3SWg1L2I3NmVNM094RW16?=
 =?utf-8?B?MENVZlVVNllNTkVnTWJoNVp2TzZSZ3VyQjhad0hmR1RwT0t1VkdRS3kzS29U?=
 =?utf-8?B?a1R2Yml4RlFpaTUxSGpiakVjY3hOc2ZJRFdXbWhWdE14K2djWm1BSU1UZ3Yw?=
 =?utf-8?B?eGE2bE80SVRGSWNQa2R1c2xLMnFJMkZzVmcwc1pmdFpaSUFScFJUZi9wa2Rp?=
 =?utf-8?B?WEZXa1ZVMURRWkFGbU0rZnd3VGtaSWRTVTZsVkZoWlNqUit5Q05SZFlTZmhI?=
 =?utf-8?B?aHlnaWoydjdsckpJUFNjWmFNMXpwbGV1SFhuOUFoNFFXN2QwQk90dHAvM3Bl?=
 =?utf-8?B?RkFmUWxjNWs5aXFCWUxNVm5jdlcyWUR5Y09EUFVpYWpEenA3NG44U0Zra1Nu?=
 =?utf-8?B?Vm0yUmk2OWJrYTdXbjNEU1pScTlDV2FNVVYrRFJuT2lWUk8wd0lDUUNubmFp?=
 =?utf-8?B?Y3FwRGJrMTErYmdKSmxGVkI2Tkx0ZDNEUSs5RmpYRXVreGtaZ3FmY0NvZDFl?=
 =?utf-8?B?S2x5M1NSUDE4b3pBYjRNWkpvMGZsWHN0MW41cXVpdTc0N1FybDhVcW14M0ds?=
 =?utf-8?B?VTVxcWh2WEE1Vmd5ZXZyZ3AzVjRwM0YxeDZod1FzRWZEWjJRV29rdGEyYkxL?=
 =?utf-8?B?RGE2NmlvbXdkblJoQjNmWDN1cU44d0ZGclhoTktIaFJyU2xwVGhTZz09?=
X-Exchange-RoutingPolicyChecked:
	SqJAHWldn66TeZ+97rewTI0gtQedV+E3WB7YXhxRLiMQaTEuMKa6HbwB3cgJSxQkoaSuy3TvQDu7cdVD/jmwIYSWenS3yx7E5ofLu4WsMkRYKrNudSu1U2xpd9H+sQNxQPm3dQ8HOOa7B2ENWb7xAiz5HnegaesUBAqkb4OYejR22t4x55dzyv8FmtyreWV5rNB9tZCYwKyRaKeKSw8J3D1uiljPhOUXOxqnQRN4xkFBUae3jUJNEt0UkNlj6Kc9JkASp3mSl8trqr5jzKLFGQRsIkd3HMB65WpfNKlhIdoCuXBWWjiW+TKaArIr+G6vYQe6x0hyyLaqDRFSYihzQQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YUcdyV5bvdPffnG0FFsY4zs55TFMZSHvnqjEgDETYZCTiwvq2AM50JMShHfeUzhQNNwrzMvsWom8MHCLHglLQiec/pro2nXUMMkrUbgfyudNKAYGVq+y4lnKO3edQH9Xo2TPXxQ6afM9RjzdXCD9Pdqk+4NFZT7C5fTODB75yAyBSmTu6SquflyhzJyP5J3iT0GsGKrDoneSNS9hKZYCAyxhNVN1PnGeT9s2tE+nYohrr+UVkSKWlF1xltimlDmOdZxWHetqH6Cm1VgUouVCObWJVJO8mzFUFDUNShOckXbH+oqFRqOFSjPR7AeQPsICXY5/UcMZZx80o0btPt+BCGZHzyf4w4wdT8psR40kKFgjR4g/onL9ZAnP654eSdFAHc9XN3kkUMfd3kqLSQLcQM5nURZh4InfE7AH7v4ViW7SZwiAcbxTw/+nE8lyCG/DvmFssOlOYoKSv/PsyurqN9PWRpSjBeDGCxwu/qJ/PTVHJ0WUulJHyCcP3VdYnexoNwSr63s/ecduBA6ut/o/BPJkfrSHxbiBf7nHsGMl6OR6xZ/3kmphtCiNka+Qa1AhXK6lENdsdnCg3foxFTjVh5/21e2YaLK0cf3/Cfvk4xc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b68175f-6e35-4034-a74c-08def782b0f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 08:29:42.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWX9qjBFVkHoqq/2kz99DnNbiknEJA+MWqpR+mvTVIvHi3Fmhribk1SFN7iisC6uTmzkf3oJbvukdtHsGkGQqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608110070
X-Authority-Analysis: v=2.4 cv=R8wz39RX c=1 sm=1 tr=0 ts=6a7adda0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=1NybHGGomp_2RgtOGDcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: AiEcUZY0OGpFZam3M4XpSUZI9aQ6Q1sB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA2OSBTYWx0ZWRfX2AYMZSem7ic/
 +WoU4dMDs02cyPMJP2QTLGrALuW2RAP1WxfqAI0cqM2P6rjpFQB+2ykdJKJxpwUwsGf6a2Uzpoe
 EKiRCyZiIf2qUS0IrgG47Y63uKv3m/oJicbPiWZXe6IuCoGIZZ1DQ62Iwm8MerazXfVaNPPy9gJ
 FEG4u5IWhcDC9FeAF/dW8F+cqPZYw4bAFdWM/ITQVocKLCKaQoznrAI1ACUdQCWfMNu17P8AgmQ
 cDw4Mtitbu0pR1a/HXUll2L6OrmsxuzPpNytUSDT7vQFAPwx2JiGZP5EVzPTQ2xW5QKaNvWsbjO
 6TH0FRBqSPCsvhafsqA8kcYv0a1VaFA55+MxGBnXSvjtQ5rHxejtfbRP7aDhZ2uV9yOKwN1HAsw
 L423as7QdupzTwH1BB5Q5cPXJmn+YjUJejd+zyeuMQPHpiJfukIGDAqScDjTwNClzgLeeFnMhur
 bLLoaZFVGsI4pPcYJZw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA2OSBTYWx0ZWRfXxq0yGro//Peh
 wPoJ9HIe/+cdZZa2/y3KR6gRj8RjK4ryZ+rs1Lglx0WZwpqx8RCk3EjCKOroM4yC7v6ES+wBbeg
 A54nIVbrjPOEIEOZ5+rbynFKwPjCaJe/+xlibYQAiTmpJKsxWDLD
X-Proofpoint-ORIG-GUID: AiEcUZY0OGpFZam3M4XpSUZI9aQ6Q1sB

On 11/08/2026 05:03, Xingui Yang wrote:
> Add sas_ex_phy_to_dev() to return any device type attached to an
> expander phy, and refactor sas_ex_to_ata() to use it.
> 
> No functional changes intended.
> 
> Signed-off-by: Xingui Yang<yangxingui@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
