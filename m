Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4AF45FFC3;
	Mon,  7 Sep 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788798134; cv=fail; b=eIzLOtiZu+z0s/2v5DUaO7SHal8oL3ziHDocbTRd8TRmYCvpbbwHN0+ztPcDf6Hdw9DyuldTsD6eEG8Y5/2C5EFV4k7O3JM3H9/CdkQLBjRbxbHMb1QyRLD9qdTkk2yIK3r9lDQ1zwjoF3nDfZwHM5mpoTCPQ4dPBJLnSwbF6HM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788798134; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h6qVXShv+opeFho6uJy8OdX0hu5IRLYC9CRVeW9Y4oxC/ox/KBaGmOrwW0INWmXJB4cu0+qYYyQ4gfHRqYNJBHZB+/oNVSSZpQAFVVGb1mgrUy27AmADwFh2cjQ3ZenlvwVZ13I6lXIbQq/9oMAuBGM3gs6DGMs+P5nl6QV0ZoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lO+pLRDc; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JgzaVZi1; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lO+pLRDc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JgzaVZi1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788798126; x=1820334126;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=lO+pLRDcPec+lzQSVFvDwv316AUBeJM6L17XJUmnUKekoenC8hmHBvBe
   +2vSGA/QBVdrCCHibtLmQrWXQ2ocmODuBlKc7mMa8a5dK6cG0SXovLqoE
   LNVYzsywnaZEHA/w6ORlaz6SdcXZ/tB3N3aH3a+MMLRUl5O0j4JkRFkDI
   cHvtVQAr3bG0B+92WaheXEQAB7RcUfwvmvgyZIYuszfs7bVhPLgI3fHad
   QjqYlT0budCMngQc/ssQF4DYADqhY9z8tpl67TVXkzPNurcquBKLlq8vI
   xjPVg2+bOn7wf5JoJs/WywmlYdzoaNGnsRIoK78qjFOvGelmzzV5cBe5l
   w==;
X-CSE-ConnectionGUID: krgrSIO5Rnys8DS+o4HvRA==
X-CSE-MsgGUID: tbz2OA2aQxGhHa4kIj/Kzg==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153550333"
Received: from mail-northcentralusazon11013004.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.4])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 00:22:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dmshpL1IP1kVP5CF7qRa5lvZfErG1jl9oGcRCqSBf8RSwW091RF7c398HaNYdRLx1AfHYhp0GHz02jEOY8GZODVz0oPjF4TZrdhGt/9d6XYPctWm6R6EpnTb+K8Py/EPotqMUN0h7WER0yGiPh8xiAuOIPA6cGlx1N3uAfY4LlrGwRGVA4xeepZlY4DgUhDDtatcZyDlfpbw5wAJs2TqLylpK+Zmf98ejEhJO3a/SPw+RmH1iFts0M6K9W9AjDuo9yt8i8pKFd5JAUnEz7hSGrdXozgruyOjRRGEzNBvygSRB3L4rTVFh9LREl6Bp0K/DBPGSiOfkEpTaW/BJCmi8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=ZI8IiXD0MrxmDJXPh8aucjr/BOfrv1q1GeUAWfN0UBzI8ZcMDHGyeKwmIsgJL6QzO64Fvs2oCxVaRh2+JRA3ns00bsWZkY5hWEVVesLw2Z3HFbo//pHRnNqAEj+zCNXoFvU36GP6PK6D/z7sNjygsIS/ZbPMNUcQDQ6fq0RI/QCX4IBCSXcGcL2sVWkMYMQgZ5Q2Wb3WCe3YEay1SOCNHMd9fVqGlRTPTvR8TomTq5xsqVztKIzAkfVRc0k2IKBsWmsfEKcWPnXV3uFYq0fk38hLfD4oAoD4wF3MnqPgFVKH0mFJCPamiCPJlKGi7VwjQlQtrEHYEDKULe43mr4CZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=JgzaVZi14mkmci4C804HFZ2skvXnyY61p9mIr58oR67EsnE2IYM+EY5Zmv4fp3uqolvJrVYXDf5oDLg3zOJn02VPra1xQWsWHh8+p6VO4InOtzDCueIMh9c78Z4ltNg2lrXfblTZrkGWbsDFvPPEfCt1/oFcuJtaffgr+tagZKs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8154.namprd04.prod.outlook.com (2603:10b6:208:349::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 16:21:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 16:21:58 +0000
Message-ID: <c2996c1a-2283-4d0b-9581-d5861f356789@wdc.com>
Date: Mon, 7 Sep 2026 18:21:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 37/40] ata: libata: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-38-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-38-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0435.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8154:EE_
X-MS-Office365-Filtering-Correlation-Id: 6304202e-db01-4a45-580a-08df0cfc23ef
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	p1Ywa7GIoH/BGRb+j7LzQ73K980er0JuMyrDWlG0HGzLmnMp47HLQfIpfv9p35e6OCEbW0TG+5tA25R+oFo7W6KkF7+A7atFzUi2piELNodw1pbLM70/B/KA+lWBa3AA+973w+8bENUCJ+Kaz7NJoA69pC4+lUc52KQb5LOMUDmH/cXPCcEWjhSl8WwpDmo1eoaiV9VJSag+MSA/FRMsHWPL693uFPMFzJdfnpPF5/owhG/4Kffp4qUgbF47A6SI3i7qimlAn64aMx31JlbMEBHPHDc4kbzJXiGZgE8xQJq5l2uSR95p91peo0jbr6y/szUdt4EmxdGshfegLtnO33BiHWSvQZMuL4ny8zBlOLO+q8E6/VkhdwLz1TbhfYoyBwWSol1wkv4eooxZZs0q1JyovNFh2/iTH+jE/JlozehQfavbqUyMkhCtAx8ZaWST97pt6sn9j7PWP3N/FGysdoCTBjmJsl+zidiHSZN/QgvQB8TacUI8GZnbFxWVPO5Te3Eu0Mgl6p53zl2kPdztkrnx6j11Fhk6Cequ9/DOyoyOHBSgxh8BCTXWWJX/35FUuXBHEif7M3doeH6kT7vC2/PrUskoZ/6Aal35v+WMM9ktDnvcwoRDLuSDEwr+KPb7eMbgPu02kEFQ7a5yAjTTwQLb78MZPQCkhO/EB589aoVo1CAdshp3EiaGKZGXlYN7NpZZqnfsfNM/gy8vj3LzyA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHl4elpBbE5lZVg2SmxkeTkzS0hIVmpSbjdYTTRNcFZ3ZzRPdEdIM3MzdXly?=
 =?utf-8?B?SmRaU2FzcGwwSE5rajhLSVY2aWZqQW5sazZiVUlmWkcrdURGVmxqcEh3UlJz?=
 =?utf-8?B?OTUvdko1NXlneUFBTWRVRURhRnVQbFRjOUtwNDJxdDc2MlFhRXpYMnRXWFgz?=
 =?utf-8?B?d0VmdlRNTEhOeGZva2VOOXhKRWJ2dEVmQy9DRnZBMTNGQVZMN0FJTTBuVE51?=
 =?utf-8?B?aWdYb1Z2VFpUMFFwSE9JMVo3V2xRcEQ3SXVDbE9WazRJQnhrL2NsTlowZzgr?=
 =?utf-8?B?ZkpKVWJybUhTNElmWXF3bWl1WnJEZkt2REZqMVhrU3A0ajJPYlIxUkdlSFlD?=
 =?utf-8?B?ZjZOUFlvWlJkc21iZFRUU1NSNzdTM29uRkNLVlgxMnNkZzVSWitiUFUrVnNw?=
 =?utf-8?B?Q24wVFpuNmkyQUxZSy9iZk5rWTdkUGxlMXVYeWluaFBQR1J0eDhiNGhiMWJL?=
 =?utf-8?B?bWVYTUhObXAvTE5tMkpESXNKNHdRV2lPRHVHNmd1WGhlL3VNbGRSTDd3MnZl?=
 =?utf-8?B?dHlFaHk3enV2RXlqaFhwcVNEcCtTeFMxRXZ5RXcrajkyZ2JXbFF2cWcwbE5y?=
 =?utf-8?B?ZGw5bGt2WE56THVCQ1phZ2N1TGk3czQzdFlyWmpMZ1Brdk1hN1RhZ0xRSmR0?=
 =?utf-8?B?N0YyQXhlVSt1bzVteFpxS01JeVZJYU5RVWx2ci9oNGdmdG1lTXNzT2dHUG1H?=
 =?utf-8?B?Q3FjYnhGU0FPTGxDKzdxVk1iYk01bGRVY2txM2NYbTJycDBWUjZWOTZ1ZjJO?=
 =?utf-8?B?U01Wa3BRVGlxM3A1eXZsd21zNGJMVUkxaVFxOW01L2laNlhHTnltRUVQMDNh?=
 =?utf-8?B?bXhYRzdKYjZTaWVGUFRWdExmZjk1Nmdmc2VUVEE4RE1oTWdudCtmQXdOc2hl?=
 =?utf-8?B?ckNKS3pVRnNwakQ4VnJXQjZIQll1QWxJNyt1UXVleVZybCtSYjBzcTRuV0Vk?=
 =?utf-8?B?QWlDTVVyUkNmdEJKS1NCcFBPMTRMOWZTQ2dTRE96WVlFRDQxcktuYWpXR1Va?=
 =?utf-8?B?RVY0ZUt3aUJVOHFMdXZOcEl1Z3gvTVlmSDMyZlk4SjBsMjVoVUJQREg5NWp6?=
 =?utf-8?B?VnN4VytNVWlQYzhJMTVtVXFIc1krc2QrUytPZk1GYXMyWmRta2JEVk1nREEv?=
 =?utf-8?B?SnlxNHhTTFNDSGpRa0dzemhPdHFuRHo2VHp0NUh2OTZPU012YnkzbWs5RlU2?=
 =?utf-8?B?YWdBZDMrRGxGMUJBMzNCZ25QNHRiREJNQzZuTjBXdFpDczhRNnhBU3Bpak1s?=
 =?utf-8?B?OVR3OU5hSS9lb1FCQnhOVTl2ZGVXSCtwUkE4SXFRUXlWQmszMDNmMHlWWHdI?=
 =?utf-8?B?NzlUMHhTOFJTdDVPdmM2RTh0clpZZDQ5LzZNYitvVmJSOUFiN3ZIOHQybEJo?=
 =?utf-8?B?dVVtRnhnNWw0TmZnaUhueXBzL29nZUQvTTVxRW5reVZaR2psQkZQMDNybWU1?=
 =?utf-8?B?VUtwcCtoWDdLNmpSVzNPMHNEaUY4Q3ZJeE9WTHpwd2ZWQS9sZ291Z0VleWJa?=
 =?utf-8?B?ajlMMTl0OGg5aFVIS1dQZStCVVczUE1wVThmUHp0WUlFS1gyd1RaK0lZOG1T?=
 =?utf-8?B?cGpka1g4dUFCRXRNMkNPOTBhQU1hMUVmWlIrL083TUR0eEdKd1VZTklSUlBR?=
 =?utf-8?B?WkF3NDN5OXpyNlNxNi9BUFlERXcxSzRXWE9IZ0lOMWRFdis1UnJNYVhPSFlv?=
 =?utf-8?B?OE04U3lkbVJacGZYeFJDbkdDMHg1NVRabHBaTFErOHlTQnFFall2TWxuQ0tm?=
 =?utf-8?B?WXM3Tzl0b0FWNVJmNEc2SFJOQUpTR2hVZVBVK0pyRVFrTFQ5Wk5wZjBMNXdq?=
 =?utf-8?B?UWVHeTExVnRnUUpaclY2SXp1ZmhXc3FmMXVQVEltT3E3bjk5SkJMUGE3THdw?=
 =?utf-8?B?SVNySS90cVQvVStrNWpCOWxQSUZlZDdXdURoWWIyaVI4WisyK05yREQzRzVq?=
 =?utf-8?B?RXdjVWRzQi9XVXFuYWNNRUloZGZIWUZGR3FQU2xEeityYkZMTURwOGdtRXkv?=
 =?utf-8?B?bDJIb0VJZ2EzeUgvYy9POVFPNFlqKzUzYTJaUWkzUDdUZ3VVNWJMSkRkSHEy?=
 =?utf-8?B?TDJ3SVdSd3hMZkZHMEkyR1dPSDNSNmV5bm9DQnNIT21CRmRZMG5VM0VaTWN4?=
 =?utf-8?B?ZkVoZEZIcGtVNm5sY290VVFMbUxLTy9pMlY3UmxZdzBKTUd4OVduem1wSEZR?=
 =?utf-8?B?eVo2bEVCMEkzdDczWm9RRWd2cmcrL2ZZZStHaFZIV0dKZDM3Q1FYdmtlaktX?=
 =?utf-8?B?a3pQNmVGWDNxZjUrakV4NW43aU4xK0gyRFk2Y053ZlFRdTYrU3VWUm4zRDMy?=
 =?utf-8?B?a0wwajVHNGFqRm5XYjRXdlhrSkJmckxQV3dYSWEzbm9OMW1aOHBWcUd2dkJy?=
 =?utf-8?Q?xJxamAirpAb8Akng=3D?=
X-Exchange-RoutingPolicyChecked:
	Viq45JMudzVpt0xFeyeuMh1tmkOj01Wj8J1yRt7FGiHhLkVQOiBLGHMcaqEID4Gj45bI31Lu76yHYUH7gdvUu2daD8OVeLrzFFaNtd2FuxiuzxSm/Hu5xj6f1vNCHgSMaelCj/jq/0F20+092hCuTzwRvZvq6uEgpb0tfeLEibZPcPNzcPI8DWnET2jkJ2IWkPTFnMce+5IRp4FGgfcRt21gvL8A9kbOeaVsZyF99BaPhXNAz0UTb9qNcFxoPhiYtGlQ0e0MiEfVT3OFKzyrbg5sfnqWOmfdpRtNOK3WHfINPTYxvo3ZsxR+6Q8gKPWy6GJWqIp6xTcTj+J3GTTcUA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QT97CzDvtD/ZyInyP/w5k2e8HMaL0lCEE3DYcz9LpYD14YUK70ouRBvAVdAnHsSG3PCDALHKztpU5rnBSUp3/ycOuLHkDaqDMrZnblDlBGisCypkf/ViR4fpCX+KoqdfceDVaymQcHZLPoswU9s4ajfkvIr8687NbITcidRvYuLsWOF8sd5Hm29lMcRo+AH73UDc2oGYD3d4rTvgaTeDR5ZElfWdiO0BB5Goirrth9XQW//+sGf/B5ZplXeToaw6baDekG9RMxEBBFUQNKbbG9qOMFNbGWpwAF0F6B7x/nG7biR0vvd/pFUYQ8ANIZmujJBJlIGplbALl79KZLxXrVJBvnXBIub+FZCpE2DZc7DihXTGvCB+1z1XzoKeQn+kPIJY0ZDQ/a4/bMcjeDWZMUpFARx7BVxi/SlH5CpDOnY4rqup8T66xqb8NrGg1fbRKnzAgYwwbI/4znvM/rc0KjQWvRfcOjEb3JLr5slHpZVhX0O5Bx52e4Lv+5ElB8MlnBs7hcLKVIheLhWmGnlkWXkHEc2XrYWE3cflgakS0R06VSLjzyWFMyOrgPj8t+LEuyTF3/CcpJH65AZHv5FTAhQeBH3zxVNa0PujPnTEnGCPgp9x4oIOagSq4E+sFkwN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6304202e-db01-4a45-580a-08df0cfc23ef
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 16:21:58.6289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDNSMZ1dEl64Ht2j0CANQlA1Y+5uyhm8Z4+HdgE7dZknCtrK9fQhEF45Xi8zL33rHdd/d07K9/ncbzXS6cSHZRNUSiDH3HxAIPKOiavieLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8154

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

