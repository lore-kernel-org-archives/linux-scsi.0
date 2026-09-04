Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264EE44E673;
	Fri,  4 Sep 2026 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516708; cv=fail; b=tIeYeW2ipI7GuRek220hGsS6I74JkpQ6kh1Tp7Em/fehwpZkru/SqvJ72dcS8S+6woNYrzs1huGsCRg43ZF8W2qE++x0//6FjXXKoOceej4z9FXatvro5CBzYGa1CyUNsx/2G4i5LQXRWrCSQ4QFqu3R0SNyQPA/1wi4nQtZhZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516708; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wd43EtDbuY+lOytFQFOUIxJjjK3iZ0CLRy04SYVPNpt1/JcidU08GKv0eDQ8GCRCEWlw4mgXBCELo1v1WE0KULL92bjtZ3Ao+6FyC/E0HuNDYI26NB5UVNPgudtngi/jgT5lPfcvBk3UcwDFHqVGTF8DvrC1I56McfHQOIoX+BU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bt+89BBE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jNxOL66y; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bt+89BBE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jNxOL66y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788516707; x=1820052707;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=bt+89BBEJz8oDa5xY4IX+LylnfcG8pHnzMSMVeNEpQBg9bUhW5t85/CR
   eOXGskw75eNZuolcwGKHJztneAH7q6RALxId8jCQ+z0hEkPVquti3ior/
   oCuVTUOrqHgSQvxc0O91p/muP2iDilETa1ej3mtKMnARH3641eL+bTroj
   CRoHPWTL+X34BXHMAuMpUNf46YBKKs9kD8YqcqZw9AGt/YtMulpTi7FkA
   6ooJIQYrU07ea66/pobY7uvY3CtG9ol/g3TCzaAFTHPhbLvmE9K2EZyPu
   c/ExjSUlKgXBG+dljf309SGg5ov93F57qtx69xGEC5kvuORO/BHA9KxI6
   w==;
X-CSE-ConnectionGUID: dCj5cxhhRRGBlM9eM1YEsA==
X-CSE-MsgGUID: ZTb5IZm7RhKxJXnIrUOdzA==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="153370241"
Received: from mail-westusazon11012039.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.39])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 18:11:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPbuDUaSa6hAHrAkeylbSSdatBgjkYluc53eurwmNwXkWScibGemlJ0WJLvTG01SxYqnPTiic5P3HAb0chvNpKqeGdvzktH+IDAeo2/gHIyPAOtzZlFmX/FDl6kRtXj/xTw8e6Q4RSncZUslkByMbS+AjOjNbAoTSwnzDdaiImYUb7zbq5yJkoRAR5YHj6VeAaMMITjXxbzu40elzJ1rJa7miqIPXyg/iZb8LptcU617uGxSVn3hjPAhiXvYzPIeoYc1tdRiCKpvzV1tOtBDQiYnCFjr6eZ69N6w8qT8Wx7MbPYG7r5KKcZpW4wm9Rfjo+d9fTrUSwf9I5u6vXOYDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=qiIeVjS6+vJv/YJemD2/avHBq8Uc/R1J5vqBsmtJ8LIQdY4XRQA63D+qfvF8UFApusiyuQ/mRp6sOo8cSi23BZ5mIFO0T+g2i9emtX4M7j+8DSC/EBrNw24n1+rQjxP3vkKCYKIWXAbfOhVsq+GOafkGcrPPTsmhbaNDT2uGij3amCJtkfqlVtw6Kr77IoqUzsiX8wbt+RKzo1Pm7hanhGvhPb1Yd8YOWELhdGlhQyLJH6kRrHhY4GpR+Qgz4O7Z8TgdQRbRYkFMyF2Kl3nkYJTGqHRYVGeyo/E1+2nZYHRaWBC0rDIRaEPhpmwehDEhgQ3z/iqKeQM7KAoT9SRYFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=jNxOL66yheo6NTiuaHU6c/7rkffZAYXUksh1RUTAaQZE6PKImQuuvS7MSmtglXbofOWnIGoeX3MPrmQAC1dyWnQSJQB4SrMfJDxnHDmwiC8o7TgvVEXJei6mNGNkILh02/w+RuZ0AvN+MA0tuaGs4P91j9YQC+dmtOav/pXBdYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9153.namprd04.prod.outlook.com (2603:10b6:610:229::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 10:11:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 10:11:44 +0000
Message-ID: <e6305243-7ce8-4998-a532-f0861d83ecc2@wdc.com>
Date: Fri, 4 Sep 2026 12:11:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-7-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260904002644.157668-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9153:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f00ff12-abc3-45fa-5de2-08df0a6cebe1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|1800799024|23010399003|7416014|376014|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	QFr26uN2Ir0vKvQFmmnxHR0+fHo5YpLZ0GEFxgiqBVXrEv9Pa3etY2sPcUQZEqj9aW32k3ZXnLusIdeqK+9+wA9o+mfg1w59st0tF1MTgTaSXRDW3qU8zl0+/GMXQUpeIcT1gtyvVsnLoKNewNO5OfWVs6TSmRpAyfBj1L920QQPtB8vZ6ZIQ6SUsfR3l/a/VnuXx84Ey6NLxr77q3UDLb9/tU+zOGZigdytP5benDrGIQ7JUCIk3WQaFs9B+I0LhpZsGB6q2fGLyzDDGqNj6QjYjqsrGqDlF3uwOW0c9ZVbVMDMM+0fhCPoSf/BbbFzBvWlewnc/rHhZPx4YpkDEgBkKVupTX4P6ng6NeIj90jr2QshnppUh5tc99UEVYOaojSb/kGKDel5OXpN8XHtPb5RQVkk2xqI7fnpJSb86b3LHA6VLlm5+TH4mkRnmsK54jR+P+fjewc2TYqcykvqiKBNw3vewvYT/UL/EYX5WODBu+ETYUWvUABzLMBBDxZvNvx0ifECpqAQKJH3OZjAl0VIowMqS7Ds7qwLg5BAb/3MP8DinYuonfaZHRzmDp3c18YUlf7fqFzMsLCEJW/+WcMQ2CBKFScOufX4pMFOEbPTB0pIqYgYAkyxi90o1XQApkqYdTnZsCp4LRyMLtLu8TRwDrNQReLy5BNFgz2iTJUmS5DEaVt7oHxjQdax4hp/ICfeik5oqYUjXHyaFE/Yxw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(23010399003)(7416014)(376014)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFU0S1FqZHR6SGlEWUtyTjNJUFVaWm9zM3pPRENTSDY0K2Iza2dqN0VDL1BP?=
 =?utf-8?B?TjdKRlJ4VW9VTXJhenBRNkdPWVBPdXllaG5Cak5FUlYwWngzbkpwcVlKcTFy?=
 =?utf-8?B?SXNtTVgycGJZN01NOGQ1UmxCVnZpRWdONnQwZXpLVGsyRTN4TXZLMVV0bHY2?=
 =?utf-8?B?U0gzbzhSaWk5aTNjT3FJdktKVkRFVU9uUDhSejloSFlUdFNQNkU1SExrUDho?=
 =?utf-8?B?WTUzb0F3WDI0bzhGMVArTEtyQkxmSWRWdlZLTW1STW1CQXNra2EybHd5TmJv?=
 =?utf-8?B?OXBQK0MrOTNOOG41ZWxReExOTy9ma2hQRldFd0w4aDExaXBxVVlCNmxvM0Jm?=
 =?utf-8?B?djFqWlJuUDN6WmlIOU1QZ2dwc0hYMjBOOUYxQWtoSDRSR05EQ3JNWEFiQzVa?=
 =?utf-8?B?cFgvQXM3RHZ5L21kaUdSS0R0NEpSTDBuQXErUlNXTFluZnZUODFTNFJjOWls?=
 =?utf-8?B?QUFxekRaOE1rYVV4T2FCeXQ1aVBXZUVFVGlZY3ZvTjRTekFGejlWK0UxNUZm?=
 =?utf-8?B?OHgzS1loTURkcmxHc3gxenMvaWtqT3RzN05wb3RvYllGbE9sb2hLR0QvalBr?=
 =?utf-8?B?UC9jQzVHZUhTcTRxbzIrNTcrYXp2b1hhb3Zwc3dDbmZMRE14Q2pHRGFOMVVV?=
 =?utf-8?B?eXZmNWNRRndkRVhJMnVxQU1QVytNOC9NTlhDTEx6Qkloa21jYUw2cWVlNzF5?=
 =?utf-8?B?aEpwUFdMRFhqSm43ZnJYMmloZ2JVTGZWZGRyREk0YlN3NGc2QmpVcUhIaDRa?=
 =?utf-8?B?R1dONEx5RkhqQmxOOE9BbGR6MnVXazAzNDY3RU4xeVcyMktFLzZTQ1duaFhT?=
 =?utf-8?B?OGQ2dmROaFJYVS9YbFNGS3dtSFp0eVMyZDZtUDYzRVJHbDVRSlMzeTYxYVhi?=
 =?utf-8?B?M01lWnNFNTVKOTNDRGUvSDRCUWg2UGlpMCtpUG5YSnZSb3ZTTmFrb2J3V1Vw?=
 =?utf-8?B?TmpMT1Uyb29WZW81VjJ6UFozR1lvd0YzLzhsdkVkc3JnZ0pMQmtEOVRRSmI5?=
 =?utf-8?B?N3NuanRaMjhJZEMweVZTeEJHVldTbHBwbVNPUmEraEtIZEVkUzg4eFNTYkcy?=
 =?utf-8?B?MFhtdk9iUjk2SVJobWc4S3NXTnpTQmhYV1FoNFZnSURHS1MvWE5ZL3RpOEtj?=
 =?utf-8?B?T3MwektpY3FRRkt4NW5DeWZPWWsvVDdXbXE3Kzk5M1oxQ0NjTlVkMWRoOUFQ?=
 =?utf-8?B?cWEzQVpqVnBTc2tNOThCVnNWbW81NUFNSFJqUENCVUlyR0k4Z25STFJqbU5L?=
 =?utf-8?B?SWU1M3FwcHF2eUlzMk1hRVpQSlRhVEQxZEhSUmhoSWVmZVpaeXpqTTZpZlox?=
 =?utf-8?B?dVhOMzdDMXUvSVVTY1VaeVRRckcrelhjSlJNeUtOK1k1cWlad2tqMXlMdUFz?=
 =?utf-8?B?RmVSb05ReDE3ZUkvSTJPa2IxSUE1eTY1UjQvenlvSExBSi9DcVREWC9JbXl1?=
 =?utf-8?B?bGdpcXFSZmw2K1BuZW5MY2M1enlkdUlyc1g0a2QvSjNOZHZyNnlGTkJDQ1ox?=
 =?utf-8?B?K3EzRVJpakZpNG5TUHBVM1ZhZ3B1cmlValJ5NjdFNUlOTVl3Z0xMMTM1YnlY?=
 =?utf-8?B?TWZWa3Mxa1BvWVVmMVRRUWM1ejRVdFVuZW1BenRxUklUdkxnQ0x6ektuVnVp?=
 =?utf-8?B?SjBHNXRrZVk0ZENlWDdKQUZWeWRMRXlTRTFIcnVTRFB4WlVXbyswWHFLUjBV?=
 =?utf-8?B?emJadTQ3dng5ZUZPaFgrazJrZmJub0tpRWZtSXgxcXdsR01QeFNFKzJNMk41?=
 =?utf-8?B?L0VqYUZXbHZ5bWJqY1lyamhEOUNZRmZjajlDU3BFNEptMzJjdG5HOEpITW1l?=
 =?utf-8?B?T1NhdmF0dGlBK1RhQ3R4cnhJSFJSTWF5VHhVSXl5VzJNTUtqZ2pNcnkwRXpP?=
 =?utf-8?B?WG5Yd0t6Wml1RTJPTHFLWHpQdkJzSXA1Y0VDT1pUQ2tFK1FZL1hJT0MrSGll?=
 =?utf-8?B?TVhBRFdGTzRmQjhmc1M1N0UzV0hYOWdXUkpMRDlUVzdUcGxYK1FCT3AveWNx?=
 =?utf-8?B?bW1JSGpkVmpPYmYvTUgweFVYVHNNN3FERmkvL3d1NGtlTVY3a24zOHNnSjJR?=
 =?utf-8?B?QVhWNlVVV24xY1V5SGFUR2hpUW1kMExwREYyMXllM0s2cXFVS3cxaUY2SEdr?=
 =?utf-8?B?SkVEdG1EN3c5MWtrOTVWZXkwa3R3eFRYSWRaZkFBOEVtWG50eXNTbnJaV0Vq?=
 =?utf-8?B?Y2t1OWZUZytub1FvcEd1YjR1dTZ6WVJ5b3FZTk0rS0hlclpVRnhtMTRTdXBo?=
 =?utf-8?B?enl5R3BoNHE0bVBiQmFnWTFBUWEvbzhaQVIyaEVnMUJTd0VZNVNVVlk1QnFv?=
 =?utf-8?B?QlVHZ2gyOGJEbjhXdHljVjRLMkJVNU9GNm52M2kyUnE5OGFDTytCenVUUmVS?=
 =?utf-8?Q?7bFI8kdHTDrmhn0k=3D?=
X-Exchange-RoutingPolicyChecked:
	jpAVxd2dHjpH1izCBJDvXwWnVYs/jWjRn47yDGFVol1fzxVfjw8jM3Czfj9Z6lzVUGv3CbvHavRZSW7MfDLGJP7Ze6mWAoAHiTQ+EzVdAPuGCWWwhFVSoZvGWP6Sa53kHB02ftkTvkORoi88KbQlXV+k9I40mtLfAPf2eUUmC0J/AyRKitwRDWKxl4QTI4FrV3+J+9DWviqhTiNazN1lgesyCntArWZAHX1yK+JU8Z3Z8WBRoC9OSvTHbAxK5uJIznJqcrYZxFo+m8hpMVMYo+PHsT/ZHCEYerMaWpJbCnO0wn5XhqM9xJqbEZf4HtWE3BdeZRoc3j8nCleHkjzg+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NZq8rXk2KeQvUlFzl6GplSZ34YF9hWA+hUJuXVmIYsl5w8KYs2FGjUa5jZpue8/SO2kj/5lyZHThRma1f9ADJdpqYpgZ2YifrUqJwjHrYbxrHulvN5HVVB9Yqyh6pnmHhMvEBK27APVsL9T22xlNNsaiJkM2blM3QPzCIw0+HsedKuDoi7Q/UdCW/Cp1rpGAblRT+RPMvGGEBjScgX0E7msfk16etY0QNuI047V0SpxYs3msXXCCV7IRd1OE/cXGkQSGZkeghnYLhXFHLQn3SoMKf5LT6Z9fU2/grtcXMyEBYrX/zbTk1PFfKgcuqUPuF259/mxWYcxdv8O014LSSoUFbKTr68ZIOlQSuh9IWs4ncHZOXyqBPNy06BGHJnrWNwUT1O38CJ559pVYjYos1964EjVF1QsNu+P4fuaNqe7WL+LNlETwuslfg/j6IhSE52CCl4CgmZk27a/9Vqld9f0uEhVWiprLERa3l8nDSa3RTDGp/PRS6EzzNKWEaaaiJem4RkqkwfTaJa7Kd7uVVrtlDZQGs/JzcR2WsMdwqgt5KFuZLP5RrPZyZjFJxXXatis5bXxMX0Cwyv3JDIYQLFaFdh2OZmMJ1aMa9k9fygTexu6ITwfYqjyG9lQ5Oij9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f00ff12-abc3-45fa-5de2-08df0a6cebe1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:11:44.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYr5SdNxKNazCNRPrg9XT5iUxDPl1zpyDyQVyccNxNjld0IwrDaf4oQLrg4H4C/uHpgpUJ+Xwv6muTQ/p6FDeIIw2ZJ54J3SnpuaMpCH6hI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9153

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

