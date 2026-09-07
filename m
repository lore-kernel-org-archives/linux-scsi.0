Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF704F30CB;
	Mon,  7 Sep 2026 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796661; cv=fail; b=VUdx2ry1s7/4+Yw/5ht/m8x4wdCdcsxxJmfLJ87MB8Ur/aC6u89Lw1kHrWYTTlUgNyJD1MQnPQ48uUp9Y427BmKFwJq4Dg81jxI8RXtuDKiemhSXqO/E1x/8DM98KDNAf8T+nL8AULub2lWMewfeV01BLxHFDXmZbdI4b9fxn+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796661; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sJ1KelJUMAswwLQ8sCdirrD2dcICR0jrZ6iesL+5ZhjGkF6KJE1Cnk8L3q3Z2MAPSQQlMVACor0k5pCLjVhz1hqjrVZtFTorS2STdwfsiQmF5PcRi0boxarJ/wTBefP5cxkdXJhKY6TR/NHpEI+NyJQScmAjhEaffMnYxVKS+/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XokhDhBY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=NdV1x8oQ; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XokhDhBY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NdV1x8oQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788796658; x=1820332658;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=XokhDhBY/dSGpxfYThEHqO8PaJ0oWFRB+X7+GKtgm0Y2ZpgeUxbQIRWO
   nEwmvhDf4CNo/wJVkp8Es4Zb/Jigun2agc77oXJilbW9fRLObpdEOJakM
   YthI8Gkk8/q/OQvuWGnjr8WkpMnSHR9bxkuuLCltMmfgyNsScPjZxZ8Nn
   nkRaSY74jlpeVJEXznScVcRlagwOVqNNzxE0triH+c8oPjpC/lYvYwbum
   th9orrPXmvPJwv1I/OO73ClTf0P/j/buBk+QEOloRiqogRoQt7Xw9x05m
   clDGl5NbvwFEKC0HMF1OQqbX4h7r4IY3jY+WnJiz8nktiiARwMHBmhT2+
   Q==;
X-CSE-ConnectionGUID: WwgSW/HCT7SP6TZiglyqiA==
X-CSE-MsgGUID: lQn3nHA3RwShS17uIeLUAg==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153549138"
Received: from mail-westusazon11012001.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.1])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:57:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GWqqDX52WFH61hOS79n+Y7UEg5xt9ZEbPidbTLzeLNqOgzKto+q2+cV6FW4G6x3+7DiX+gJm43pgpjkV1I21tdAC6101YaEmNd5JxvKazdtQOmvAG+gJ4aqLBdkR+4XtgRWAePGSenZAvAd0ZtBdR1JlylZH9GthC5mgM81By33BGO2b71CHSqyovOWsGebERaSptfTQk2RME8zrKDNsLJv8smmWgN99v+N2OL9C4paeiD4hqOEsX0p4hlfL6bX6sDQDKsC2z92kq5r2pFU3NCC84tgBZLuOa/zkXkIIWxvr2GFttXhKVt+6ILRVxb6dqbpTCI5SmQM14VP1xhLFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=tbx5nnnk5SLA0bbmw0n7jPREHnn11VxFPHcI02NAKUXssNKR+sXvoAXRS4LI5B1P2yZHCYa0T1gw3SzMmjYpYwBtFqs+RyWjn0eNb3UbmLsF2o6R7lbYb2HkS/kmmjzZIvAJdRkLPUeVcE0yDZdRe7NyUwp5h5OdhU/i4a5mO2YIqWzB0ox4PEKyyJPprVhEv5kNKXk/GU49kvRmPXC9ooCUOwMvAKcbkm8CaY1DFXWt0Sf+ZhMP5AfwuCRvn/9H1tJNcUAFgN9ZA4p4a2tL20y+JRflSPaKO5DSk2yutqwXDszszALDcGjINcB/LRUxTde/WhWUGHnmblRlCfQMnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=NdV1x8oQ8u6dTP//UEbH0i9224yF+sZHZaEzNXsYH8nyk77P45TRpePeDa9R4rakKcTG2iKJGDMY65ik6Jx8FHXcETiNamEQtZLwncHByWp3/wsnPiBWtk+U/pqueUY+VDCAIdJ45yhV7bUDh283b8erNkCiwlNpvfShcScSUfc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7470.namprd04.prod.outlook.com (2603:10b6:a03:2a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:57:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:57:36 +0000
Message-ID: <4b8e690e-04ac-47f4-a2ab-487b364a6c73@wdc.com>
Date: Mon, 7 Sep 2026 17:57:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 32/40] scsi: hpsa: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-33-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-33-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0384.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b252118-b761-4897-5313-08df0cf8bc2d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|19092799006|921020|10067099003|11063799006|4143699003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Epcv4MTXhw9Xyk31KykPVZb0c8sxjClGCu5zbmBy8pFZYYUtDGoS/sgNQgPUQX4arU9g/MVfzjz9H1SmnQt9fQHl29POA/WZ4iyrni5qODXoFiMFHIXIi8WkDGwBL6zP7PqZiPwEsDYt9O1LGOdYYMfE960CGfh01I5ANSUyIWf/1w46dgiFBTmZ0AW9lWvHJHXXBpd0UFDHBtXhmCjd8gDNN8e2hCZAZJRCGfpza/EJIv6J7IeWDOOXda430QbyfO2D491e9ycKEwYirSjkumaFdMB2FkleJv+Ly2mis8BsSupxnQQnJX0kCfQ6psu7VTiS6qnoxSd250SuovqFYf3ys5B9srCmKVX1QUL/dtd1q2n+Hk2q0Tr+o+9HgTWWXCZGoCP5P9PdpgvX5ZYQOXlhKsNvtrWcsrmyZm5oq+wdbrWgCLoGqqcfAJAx0wxZqAdXtpvNIRKiD2kuRLGSa87DkJhVO9SP+O8zthPbQXZe7XNMw2Aa1Jco40ykxyq+iGI4npYjXt9Kc3eP18AlJMI/03hxIid4goeOvs/ChYA1S3grn0927lbwAfYvbMaQp8FKmx+j5PB7qjoV4FwdY15T/9Vd69NaAOaI3gDN68sl9QsHkFYH6yCgJJqHGyLYEusstOZ8fT9YOv0zKMAT++6mMXAt0SjTfsos/OVXQI0o6PzZoOAEiAJe2BKzgaNY6l5zVbLKOXuKRbpB7XvfLw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(19092799006)(921020)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjlxTHNyNlhHcWFSQkdJZ213UFBieklKNWtTdVVtWS9ScUl4Nnd2NTNBbG5S?=
 =?utf-8?B?YUZwNnBsRmdPNGlOM1o5MHpTeFM4djhkSnRjdytCbGU0ZDdzbXhjbXJYTXZ0?=
 =?utf-8?B?bVVoblJ5MEIxajdaT2o5UTdtaXdpMUxJTWxJaXJMWm5nU3dNbitaWUpuelJZ?=
 =?utf-8?B?cWQyVDFLc3VKRFJuSVVZRVM4L2dpY0Q0ZDVmcVFYNmVoVXlGMnBmT3V5Mm5T?=
 =?utf-8?B?azVWZVdNdmRMVkxPUE9ubzhQYWpyK2JCMzEwcE5MR3VNSFJOd2R4ZXp0d3ZG?=
 =?utf-8?B?YVBSVGo1ekhOQlZqaTZrdzlaQXFMWTcwckRGWWVsdEVsU0dVd3c1bkFLdHB5?=
 =?utf-8?B?U2ZLMTVPR0QyYmJCUitqYlZNY0RIZnoxNHZtbnhGelBnSWNBWTZ2NnlLS1Y1?=
 =?utf-8?B?SVEzeTM5SnpVeWhnNmFnS3ZBQU1BUHN6WGFxUWt5RW1EcHpYMXBWblBSUXNT?=
 =?utf-8?B?THpPZzVCcDFWUGE4akxRQlFFakI4aEwyTVZrU3Q2VFdlRG9TQnVnSlRPQVJo?=
 =?utf-8?B?bk1WK0lPMXRFNzFjSkN1T1JQR1Y4WGtLaHd0OXFsdmVNUWg2TE9iT2hNNzBT?=
 =?utf-8?B?L09BY0FYa09ZMXdIb3krTHgrQmxGY3c0cWpKYTBQb1NScU1kZGdIM3E4b01y?=
 =?utf-8?B?UVIzMW8rNVlKZUxGaW9qRGZINE9GdHl0eXM4di9uY2JzMlJaSWhWYktYWUhZ?=
 =?utf-8?B?Mm5xdjFoUVpwYjVtRGRRTmNydnd0a1dJTW5iZURVOEFBb01kRG1BYVErTXlx?=
 =?utf-8?B?clpUSk0xQmEreEhJaGRXbUFDRlJ1TTZtVE0yM1JWLzFMRXp0dHBhRk5UcVJw?=
 =?utf-8?B?cUFZODFnTkxXeEpNT2VvRnZOVFA3cktlQlZQdWZBd3Rxa1ZwaEJ0MTR4bnFj?=
 =?utf-8?B?Z1RkQXhsNmhlVFVRRExUb0cxeFdUeEw1N0QwUyswY2o4Z3c5QVZPZmw4NWh5?=
 =?utf-8?B?ZHE3UzBZNkQzUEcyNy93UEtsOU5lZGlldnljd3lTMVRsNlRVdUdndkJYWjY2?=
 =?utf-8?B?VjdHN2xZTHhoNHcvNmZuTUFGNlBuYWpwY2JkRUMwR0EwVDM4UTdPU2IvTWdk?=
 =?utf-8?B?RGhtOXJVVUFranpPcDVlVEZIU3paWlpKd29wWUI4a1FJWWluQTNxZ1NEd1NG?=
 =?utf-8?B?bUQ5dHM5Uis2SkhLZnQranZFSm9KV1NHM00rT2l1QTBOTlhuYVBwVHdtekUr?=
 =?utf-8?B?a0FSS3QybWdDcEw4WXNDd2NIUkRPQ3IzMnRaZVY1Nk8xV0xaVHpqcy8vRVJH?=
 =?utf-8?B?Z0MrR2VmdXpsV3BDU1RvNkxBK3YyUU9WdStoWjZOTFE3TGYxbFR3UU0yTE9a?=
 =?utf-8?B?TUNpbzF2MXVhdTVGYjRRZFFneUhudEdKek5yWFBpWi90QjV0c1NLdkY0bzVL?=
 =?utf-8?B?Um9LYlFMM2tPMmJqdjJwRmxWZG1PeUlPUU5HSUkvdTE2Y0JNZURMbm5BQXR2?=
 =?utf-8?B?azRJNDJqUGxURE1ORzAwREZRcWljd05tUDJQYWdHVFdFMmlrMDRvY2I4QnFI?=
 =?utf-8?B?K0xxSE9LK1crS1Fyb2NzRytSaEh0ZDVaOCt3NE9QN1JVNXVReHhSTGdOSUhK?=
 =?utf-8?B?ZnVxcVZPTjU5by92aDdySzlIY2pGVFVwSDF0cG05NGV6NE1QZUdPcVh2dmhE?=
 =?utf-8?B?Yi9GU09BamEwYVlzRWMyamx5ZHVMR1lmaGpQVnRUWW1pTng5THk1Q0djV2JO?=
 =?utf-8?B?dm9XU3FsREhXc1dUUmRsdWRLWmJCelozUnFFRzlPS05sUmxTUFNiaTFvaU9C?=
 =?utf-8?B?NlowS3BwZHc2YkdvU3VzbWVQLzd4SDFacnNjM21pdEoxNnArSlRwYzhhZWc1?=
 =?utf-8?B?ZmQrMUtDcG1iOFRva25iRStYeVNMZS8rSG93V0IwWFZRZThIb3dnVUw5SG5H?=
 =?utf-8?B?dW1QeFg0MW5obWx4bUhlQjNIVkJNVVBIM0t0SjZwRVN1ZHhVVjRSMUpOTi8y?=
 =?utf-8?B?RHBaM0pqT3Q2djFOMFhBZU5FQkRodTlsd1Z2dHNoS1ZGTkdoTW82K3drbzRR?=
 =?utf-8?B?c0hRSC9tUzR0cEpJMGFsZGdlVXBsVkRWNlBxK21wbUJYckYzQ0lVU2RmR1Vs?=
 =?utf-8?B?ay8xclRWNmVYTXQyMDVJSGtlR3BtdThBRGlyT1ovUXlSUXN6aXFyT2RLZlk3?=
 =?utf-8?B?NjZOcjgzc3BHNXpHVHJ1d0xCZlV4cWtYNDB0WGN3SDVCdGhSbExDZmtwd29G?=
 =?utf-8?B?bFU0T3g3QXdzUW5PeTdpdWd0L0k0N09hcmZZRFZJUUpPTmovbkIxZjR1RFJw?=
 =?utf-8?B?LzcrZmFNYzdsK0g2YjZidFZzeTVBS25HTXZWRmhOaFpEclEyNTVLYXl6U0hu?=
 =?utf-8?B?MkFKY3JXdGpWV3VuQ01UTWZyZlhWL1pHNWtFZngwRS94ZWgvMWdkdTIyKzRs?=
 =?utf-8?Q?CN7H44KFandVM1TY=3D?=
X-Exchange-RoutingPolicyChecked:
	TYN3Xw6EE3sIa017Vy3CmdJZIRb1olebOhmAXNpWNEQJd4dQmvAI6NEhRSS23ZH9GMeLzOwarfAAFwpt2R/V9du7fqfjaKhyEbNEk/AnOoPilTqO4sq7XjSsZvioU7B45Y77GIXbQwa59qed0+EZZUnuhEaCGRjMeUALrZYfs0Gozhfa7maTIgKUk/pWkQy891SKjG/5j2DRL1VMV1+qHFadl5lmMNTzMSfg4YNSfjP+QDyWEeKxDvLEJMzrwZ9zskL2kmAhH0WCCFQ8gIECTL/93Ahkb7wVLWOsIu998N1fbt0nnZ7PvvjzxwfnO4AZAQMPg2ykloUlHg4UQpFtwA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kyPZpv71RmkbIw7+lEqGzBcIQFBkkmL6WYbQS4UugU43IQgi64/bVrT9O24Mh6y7R3EncQbyF9OuX+BPZLPk33IK2WlVtpuk/KJ2Hlt7qQKhnSf2YYAjNGh5kA3fIvvngr7H3ZRQPymidjufZsn+EQ4Mdz9odXRWmp8HMocoMw41aomjJkbPYauZ0PfwNqUiP3K/aW0jA4mSBD+zxIeeBwwbHiN681eTqT3PNPL+HUVCrBIAkrLSRQsEkyXdSpV/6j/DwSaQQx4J6mJmOdtr/ZrYJYECQdND/4UWzoqCSAfGy7isFs0pc8Eq2IpLRvgHrGsT6gecyBGwcLzna6MHfauaRLBqf+3jlPZ78u6R5I2Oh8fTFFZuyI3IYfEPfpjqjn4x49HSbDELQFOkCotL7FzXRyMvNc66751VXH7Nidx1HHPJF4AOjNRdVYuHKZdzveXku3Tac9fDuwqOWRasu6aRf0Aezhnbg2kK0jNBZVkKxCMRcw3xbC/ZVMIMrDksYoN5HJlUP9ayabY6VFHQ8n2jLqYkIpf/jiAeaZuO+WGxXRkVMIRCd1/Ql6ITzgqtF5FtARfuVPQ6Q5PxYqyUtkZYVKPxLiTZy6sLp5nToAnTN9zj+RAXGaORHOwV6JQN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b252118-b761-4897-5313-08df0cf8bc2d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:57:36.0424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybAicvdSXNLEAdSR65aE3rtTxJ80V94pHmlxPfGuvvEVwjjDssSEN8yV2HF5RTyw0U6ss1xM7A9ArkFqpupTYTLpTjWrBnv9tAtk9WhjKWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7470

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


