Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E844F484241;
	Mon,  7 Sep 2026 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794816; cv=fail; b=FTOzg4Olqz5jJX/H7Nls6GNd7ilrRIAyI6SB1MSreerw9XDic3wioKxuXlp6ekY/VuiMFV6dPe0EAum/HiZQXUS9xr3Yj/GQdKm1ZYMKbc7D0jMZ3XVZGl79hI9j73P6WgQ6QRlFowNmAJwRyX2DCxD2/oAwcrzKQCDqziG1meQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794816; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JTvL0VJlKC+yAJguRBPlKwGieTMZ97wcth06c3dAtEw04VAgqoQIwldMbZuYT7pnN8Hp5BT0C2Bto8qXDRyNHx+UqqensBZWJW9EUSaMyLnVAJREXvVy4uYH+axOpJ1dp1RukbSvO2TjSwzWbkN4RgnioVu23Y7E8ppi6eO+i8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gxnPWdtT; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cO1Xb+en; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gxnPWdtT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cO1Xb+en"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788794814; x=1820330814;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=gxnPWdtTCMEViSJ5tVbZIrTfImqKSjSlaM5iVkU2CyIaQODI4FLkgJtT
   Wu5IgJDP/J0b9/dJ17KSOpfq0CDhwLG72Ne3a5bLItOi093INb7QmmjtB
   JFNqQV9o1TbFCnQq4OA16vkMoWKvfGTc60Jrqi9KiH+OyU7b1VTim9GFf
   Th1ELJt8WRtib0ghuE6Y84dx/yHu7qaiOCyiLwyzcW5qvx/HZHBHx8jVp
   L0uz1RTmkSPPf50MZWZ6b4q++fXWy+wA6IUeDVzcjf2jWa4KHWjbyEzev
   dmZM+nOBiYpRgv+aErD3cK0XvRR/wBd1SHJmOdQrDeNo5NIwP4VZzg9tg
   Q==;
X-CSE-ConnectionGUID: rjYQc4wMRnSL9EEDw0Bm8A==
X-CSE-MsgGUID: 1FDhuI7aQoykpoeC9CZ/CA==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153548072"
Received: from mail-westcentralusazon11010013.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:26:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UEX14x3DdBKPs+IVpevD697LKSQYjaazYSEbAPcLrWkGa+Yp3b26eW708vQAdmO8rohSv/SXj/mAOgfOCInpmZ0uMhA/+vNnzvCdZYT8U8qeaD7mJ59CDSSaCkUEMtpM7O3ddc8DoLiuvGuacQVnNhNYRFwchxitebBghNiIVqma0iXZcyEV1rCV8y/x4GFyK1Os1JTKLM6WVLwJkK+JN7Phst8xzTcr5vgmBqXovpCRY4ep+GNLTBHYK53evgnfUVzunxlnQEVusni1bLsMVFg/BvNuKQzrr753Mg3uyxCiNnagwKXfEy2YiN1XOsOP7WD1FyfhVY96h4nnsE8X9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=GOIkad2wga1H6zmC1bpFJu+okn8v8b5IsI5t6F/V17OjB7GlXCsQuBbBWQ5CjQRHOXk0nuEfyo9dlIJyEifWnc9s8qMYQSJb8b2JJuunAnLHDB7bisJuv2epSQR4Iifw7cOd6MvyJdcQcCcolckhtAZ08xBrv0vtvwhZxVrIkFO/SQQGfDdnF6ZyNMkdvyDnihU74+FHM6fkCAvfmCoteRF5mYq/MxTnZXBHFJx8Ab8TONnl18sx1xdDOQ9kCHCMSOepsxLQbsvLFDKMy+r/5Q/pJBZelvsQ+wBIuyBNe5j/zNdIk4nvGylWRPXswWX6m21oNh+d75wdEKvScHP5eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=cO1Xb+enELCNp/jSTrT462HPT4uoBoOU7in4bQ8EnZMpMYUwG/JLImUZAF20BcSWDVvoZjACn0sU1x460YGLK812TkQC/zrHTDojm570A2NE0q8MloK0gdjwTLQFHrAn5dkPQz/zWgqEmxLuxK7tCbfQepJ+pNwaXxYxnMj9WIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB8960.namprd04.prod.outlook.com (2603:10b6:408:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:26:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:26:50 +0000
Message-ID: <3fd0c4e3-cbb0-4c22-b5e9-fc9eff0484be@wdc.com>
Date: Mon, 7 Sep 2026 17:26:45 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/40] scsi: stex: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-28-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 623cd174-835a-44dc-6f4a-08df0cf4706f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|19092799006|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	o3lYSDdyz+TYj50e6Ib5ZYfLk/Y7TPQ8/WVsCX3CQ+RJhfkQdrM43cknovg/MzpSCa1Vm2AwoVpA21h4J9AZSIVZ1kQ8tx29lMrLW50aB32WmJ7h/MNWA7hK0SeUTxQgQ82OW9B3qBVOvizT3Br9ExKprx1d6+AOAWmqYKSCW4nrd7A92wD9Om1zpULr8AaH5yPMiBFaqJqkFOdlRjIU4AsbozjJybQhGeUQ1EYJnfvx+B+Jea1V8TdGFlB9knnL+pTEGWSvIyArDMltwOVnIWHkl/tsRLfSZh4jtH86CIChWl6mMkEAYMtY0EHPlVjqm0qziNcFDJiD6nrWGBLfaXFwEX/dvUGcwQupIdU3gED2sUgpaTxHPoUFCdMkiAn1Ta4LpUQbVJe7dVKHF2K9E3AonN5ub/FViQ1zN0v3H0o+yh/xn+BfW2zatPyHRg7Bbgmm6V/s1I9xexJ/kw+docrrnV74xmyW6j5SzX6dFarxb7o6X5SLD+jLJAzzM+d82Q8oiLHH5lXsyuUOelI0Vn019brlLu1JykslApS5mP87UyD59JDtWwGpvYq0sw9ii4kRg+OXh1IKd6cXvrxxs1N3J8GgOPTf4vOsbhzulFqe/XwbcOHDD0hFofgufXKw+WHxvVuShSB8ieSxBtX/8JQjwlzXnHitmN7GqGxyY/MQAVhCzqVWwoisfaqO2FCoqNZF6vRf//fepLBGRpYm9g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(19092799006)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEJWNkZ3R0RGSFRVS0ZmV1hHcGZibUcxM3BtZ3hEMVgwa2xCMUNBWDh0aWZU?=
 =?utf-8?B?OXlxTi9wWGN6emhsZ3MydTZaWXJlS1p2ZStlVCtvMUIyOThQdDZXZUhVWUx5?=
 =?utf-8?B?QTB5QjhoQmtYdEs5Z0R1cUJIeE5CVVZkZENhRnV1Ui9BQmozeVlUWUJhSDBk?=
 =?utf-8?B?a3daNnQvUXBmcmx0M1JyclRGT21YNkkxSUsvNStkMWppcVg0SHNwaWxjTUFV?=
 =?utf-8?B?cFQxWEtXTzRheHJNMGdFTXNjcUFCY0Y1c1AvaHQxVzU4Q2g5bWlmcVNWL281?=
 =?utf-8?B?RHNjTUxpNWRVNzJPM1BGNFhVOHo0QXdJT2pQOGszU1RnNS9jS3pmR3Q4MHFS?=
 =?utf-8?B?ZDVlOFJMM1Baa2wyaW5WV1NSWVRMWldRcDR6MEREZnhXemc1bld3d3Yya2Qv?=
 =?utf-8?B?cUFKMUQ5TlpyVlVZRkxBSndjMm13OWdHZDhsZTg1Y2Z6TXVwTVdINGw1RDlQ?=
 =?utf-8?B?bXZPb2FHVjY3cko2NVdDbkNyWHpxQTlza3BKNUdibHQ2Vk5YWlF3TWc0bHRs?=
 =?utf-8?B?dkE2eUNFR0c5S2plUW5ZUW44VHpPaENsNzZVNmtOTnlOWS9YVERyOUw1MDgv?=
 =?utf-8?B?ejUxVk5LZjFrMUloSERpbEZnNFN0T1pGZFo0cnR3bTdhZ3BzZVFILzEvZTBM?=
 =?utf-8?B?SUxPY25JZUF5M3FOa004MzZ3WXA0V2IrbmRnSHpiMTFqL2VTVWMwcEQxaWZO?=
 =?utf-8?B?d3JZazQ3WDBPL2x2M1ZyYmFuYkZBMGxQQ3lWMDRkZUZLcXorU2h0NzJDK1Jr?=
 =?utf-8?B?d1IyajZhVitkYVdQTGN5dUhwL0E4SnUxZzE5VERVVmpSdTFvUHBxTkR3bHRk?=
 =?utf-8?B?KzF6enR2UkxEeUxNMVM0R3oxWS9XaXdOcGxydnhJeFRIWHZ2cXZqajl5eHBu?=
 =?utf-8?B?NjQvbFdYWEU0WEhVNlBreExxdTJ4WXhGSHBlUTJNclNCeHQrdTYxYkcwL1lB?=
 =?utf-8?B?cThDV1M3bjRiZFFKVFYvYytTa0dCQzV0Vy8vRko3TXl2cTY0R2dMWkU5V1NO?=
 =?utf-8?B?dUVYbE1TZlIwWlBuSXJzZ0xibkY4NGlDVFBWZTEwWmEyZ2Jwc0s3U0xUbEpi?=
 =?utf-8?B?TlpBeE5hYzRablZVZE1ZcEF2RnJVWlZKYTRMQ3BuWEh5cVNrczJybk5Md0lS?=
 =?utf-8?B?K3lsV0toK0NSaTI0T056eVViQ053ZGV5eFRwSUtwUzJyR09OdUl6SmI4Qlk2?=
 =?utf-8?B?QXc4VUthS0JxZ1hHQzQvOWFrVWg3anY2UUtwS0g0V1VYbyt2QnJkTk1mRVZt?=
 =?utf-8?B?THlGOWZwZHhGUVZDUVpXcjZCa2lYNmhNYnUycFBNZ083WG1aekRhT3NOOEJh?=
 =?utf-8?B?UzQ1RlJOaUJrVDBYMzJCMXVyTFlFTytGUzA4cTlmc0FRS3d0K09PcXNSNWRV?=
 =?utf-8?B?azhhWDZVaDV1UWxLZ2dIUWozZmxad3VVb0lnVFh4aDZ3ZnJtSFEvMitNN2hM?=
 =?utf-8?B?dUswSWlTTk55VWdDUHZUeG53ZHZVYXJCL3VWb2tOWTBoK0R3K1lacWpQOUFG?=
 =?utf-8?B?RWlXZlNPc3FpMUMvL2VKcG5keGJHUE5JK2ZzUFo5YWpDRXlWajhNOUlXSFB3?=
 =?utf-8?B?ZUYwWWtrYXVJOVdXRFRaYzdzMjFTL1diVXJMWTJ5YzBnNGFvL2pkbVZvSFkz?=
 =?utf-8?B?NHZ6UlhJWjNJcC9NdWJzbHRqRGNUZ1FqZnQ4THJnNmpwYytiMWNyMkorUVMv?=
 =?utf-8?B?R3ZvSGw4dnVBMVlJOVl0WHFGMTdYYWNBM2FqVnpQUjM0S05LUWt0bXAyWTd2?=
 =?utf-8?B?WFM3bTZ4cWdnaEF4cHM1R002K0tPTHB6aUF4VFREczk1eGorS3FmakErZGFX?=
 =?utf-8?B?SWpmdG1zZjFZS3pRVG9DU0x0L2xyYjdPVDN0ODF2SWFQUmE4OHN2c0VaM2Qv?=
 =?utf-8?B?Y3l2a2NWOUFhZUNHVEhLTnlDMmdVcVZOem1Rdkp1QW9nL3hoUzhmVzNkaHFw?=
 =?utf-8?B?bnhBblQ5VWFzSHgyZDNkWFdoRHFOSHJsaDJYZzhDeDk4R0ovWlhBUUk3VzF0?=
 =?utf-8?B?aEVsZlNYTGdOcHlGZm5POHRtWHdpQmlLRmlMVTBFaWllY2FpUEVNclJmSXRR?=
 =?utf-8?B?b1hvazU3RXNJRnBHMDdVM0F4SUZCZkpvb0hoVnJMKzY5czhBMkx4NTh4SjlB?=
 =?utf-8?B?a2laL0JwUGUxMmhwSnNZMDVJOFdIMjlCbi9MQTBWVUwvK2lHMEFpUHd4b2Uv?=
 =?utf-8?B?UWx0czBGc1lWSTEzVXBFcGVnZ3dHcXRCeHp2S0VzUHdTTS94VkJqaFFyc2NM?=
 =?utf-8?B?N0liQm9JU0lPdUowUEQvdUwzc0VKUVorc1NUNCtkN1U5a0o4bHR0TGlYc1FZ?=
 =?utf-8?B?RUhyWC9EZmNucnhrZXBxUUJnZmpPQlF1Zy9iWHdiYXo1STBHZGIvNTBiUXBu?=
 =?utf-8?Q?xdVA2VYBrCWw8iWY=3D?=
X-Exchange-RoutingPolicyChecked:
	QOIlv8r6jcM9uwaSbjtOiRIeH+4/LsyZQ/M6Kk9KJbL+bmR9iKntiZq2LSCq8HTNlEa7hAJUKzGjd6lnGxX7fuk3EuOFWXm8G9uh7FRYRRPBBBGbWJgvyCQPZ5lFZJU8/daT4oOn6EFF0oMu8JbgHtTj6jWZY5x1itYZmbKZGQGbsgVzyWEDhhSDsbqZSsm5ythHj0xb9XKfA69xpDzIYalFvcdARMymhXx127FpRv2C5EmGge7SsrcD/WSjRHF7Tem0C4qFeGH0D8rT4RfYwBQD+kY3hZcVmbM9DGcQun9QfhL6syT2y29hE1yMDXb76OlUowe/sNXvwY24G8n6tw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dOgs9mF+NHzqlJW+sh7Rhx5iXl4BGc5fdslSofQElTTZ3SEvQYKLyBdx9N+SoUG1SwuFCxPtHcxwZt946ENn2vdnkNgb3RZ0AkbsbqpixKZP2eT9l2zP0KLkPPsYzHYvOeJr1GjAlvgU5cvwBx/DTfqDlFIpL7zZ5+q217vMDIvKxs1yDKCtDjzJx4t28jMFa/B9X9/1Cw4rt3Vug5hne6E1pEaC3ifbf2xnCfTXxA2UQZvi/+BqKGMd8tAnpdsdO4px3DDElZcH26ShB53HoHLvCz6STJ0vgJ+78ujzrmKCW5fwUrHVlAaG4rEbErqCluaKRDnsmU0LL64m+9kdQZizhbRxjvRdK1gtErKlh21yFhlq3Id8aKrpQCkQ7Z3YLVtzrQg0mvTtRMKn3VWxPb0We6dd3IQwhX7UCmktnG1wz/fvTTN/AkiSgDxdeeBYu86x2OMCFrXXOqT3SdzUgB/f45iBRkW5J7G0iVQDnn0YIS3/hhAlMrpXau+ZB1lUI+cIW1WSLArpZeh/JvFONbdxWrwmiTTJLDnqs1ldVDge/Ck/NBdGj4YHRxOiB14nm9FlmEc7mTi7XWi6FaCr5dJgx7YyuzN5kDmZqWjdaYNqVOQ0R0A1z4s8UwsiuM+H
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623cd174-835a-44dc-6f4a-08df0cf4706f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:26:50.8369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rERUgjxNFrwsP1AQ4HuqI2h82/LDbQFxgDjToulQXmfQ688VVkHjpUjuJL4CIeZJuduGHFnDgYqaIWF8d5xMssdE33x+6Ui54EFxjpUXqzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8960

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


