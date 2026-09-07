Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33CD4D8DBD;
	Mon,  7 Sep 2026 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791996; cv=fail; b=q5PuxkdASgNvg/d4LQIgtgmJpelEHtP1YtxIOT+qTNO8WIA035CLhZrxoPSctDspo3vgXwvIbsB4FAIFeTQ1de8CXjdxBjSg/WfEHuDQbcSxoS+5/xtXp5nTKtWdf8LWGiJIkj+zP2TE6WURa04/rmLnbZsTxBtu27CYgb9GiUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791996; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c7l5EI4DDOgvN3wFL/6v9okPhJANibf8TrICl3xrcTOenUlX6+p5iGbi4g0rQ+Ar61K31WWMOpmTbnHbTph/BNU+BroKYkWHkL9JFKloh3VQyhqfZYDR+0sD45JlpqznVcoVwG9I74pgCkzBozO449vGHjSPBki+wir3Wd36aXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fpYLwOOD; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uzchgJsV; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fpYLwOOD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uzchgJsV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788791991; x=1820327991;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=fpYLwOODkFqy5qquXIiLT2RLYs77hC/aPNyu5/ZtOJzZ+qaWAyxXYMr7
   fn1ItWS73dBmaYr+21qIt5vW4mCATlOxKICBXFR5ltMohFs4VmHF82Am2
   3FJ8aKMQhDodxqXspqDye/8DUAs4qSyTC9jED1Gu4ig/C2xsC5GMTC3V6
   doh3H0x1Ckwyb0UzzaL61iB4fPHQbZkx92CsVceSOCnJ8bmDbX0HFzzeu
   O3wGzODrfc6rs3VL+o0ahoICVbWab0iXyL+ZlqZfZNNJ5ewdi+RwWURd0
   C5a3/iXKkPIefEsw2+X6++O+4plyA23jxuAedORNu1q2PV6CXqnJwcxu9
   Q==;
X-CSE-ConnectionGUID: Wgxv84x8S6K+aTYcNzYGVw==
X-CSE-MsgGUID: XHbo/OIiSv+l+kEDUBIACw==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="154925343"
Received: from mail-northcentralusazon11010018.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:39:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zMUWoR6uYgGY7dOpU5YoDZ+U3GQUmCN6a0WPNYniFrfdUcQ1XWnhOC9reAkReCHIuEvNM3osegeuHAkS7buy1xgOMRepWAU45ZYVb/B7Tjs4LxOiHOrEQfwKmRRMKSv/AY+kNQbzZEMiAs5a6hPFFGDAgWBw5WYR0M6bkr+d5ObZZY3eutc3v7E3rPQ98sA7Hb5qI0NM1P9SNjDc0C82o6a8gW2VRh6lEdHYMOoUvXgtutzXAkJvWvXQeEiLO0GU0VNSYDzfAqAFGcYRaHgOWSCZ3nRHeEvPFQS/7AT/RXReDcs7kjBT3oBJpMmOUYnZ4KriHhWfI0NW4pqgx9Eujg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=B/EOxIpy8nj+N0JlabU6CNeFs8uGwQGeLF5uageNGtackx4eOWw+2NMDbjTEdKE8yacEzGQg1Eb64mUDq8KIIl5kP/s3FfiNJzp3QLoCHCpsO0R4GHaLMDg9T9Npru1Mry9z7iAJhi0il5OTukwvjOyMWTxkCIekvQBNrnR7VrPSN6FU/omOTgHhWxk8tHWjIDyOZM+Gch6kp736B8BQ8wlZTx7EzhgJ2RbhyMtXD/xVeisNVEzXSNuIMauthdJigzwqluoxCLV6vkjTGCbyYJoG/ot/aUp/iySvoMMnsUH4Z8PqeLq4CrvpWcyG5JH9IvLPl9Oyn5ONOcVLjY4stg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=uzchgJsV/XSYWBiyDt/m3WODZs2hmEZZoWFft2kE1NemNEDyEpW3gvZqpF/W8T7dp66+HMSv4YzJ3D9ew6CoVIct0jl7INfZTNFj9eFXJXF4DioWkty9a+uYWbyZiL46a/sAhvf7+WDlKrjR4w6whPgSmcP6rLD8biYojNMm/QI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by IA3PR04MB9329.namprd04.prod.outlook.com (2603:10b6:208:504::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:39:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:39:35 +0000
Message-ID: <2ff2cca7-1976-4483-a86a-68ace17376d9@wdc.com>
Date: Mon, 7 Sep 2026 16:39:23 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-20-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0162.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|IA3PR04MB9329:EE_
X-MS-Office365-Filtering-Correlation-Id: f70712a3-498e-42d3-ca56-08df0cedd609
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	deLNmsuXnOZhtinykvXl43JNAcHDreCNVfGfOtPw8bPjMWCsxfOtwTz8LioSubxm29EqXkgwfTg3pNinEkV6TadrA7ytuh1avI2XFfjLiLbKgFQ36v8Bp4aJS+z935N8Mgpv/UKYk/l64LTZPQ/g5C8lEyEdN9CofTBykRqsA//NVCwewHk3ePeoXjO7wugU9o0NoIBQxUcCE0Vw6fGE7b3D69APFICWKDrWuGpVrByPuCA5GPwrhKEg5FfPuodoryM3LHXWdya7klgeSBbxAsRokzUOv8uDi2vu2J967kATc0tLPh+Jcrpd4HgSksIaFr7ZiBYxrG/hFWx9AAabItMItyIv2fbAp4SXFcLW8yr197vCEzKctcz7rAu9I/hyH8pA1eVm2YjFzgGwq22086UmCYlNb3Gl0tYI0vnIdzEHqfj0HKceGvKLK4P3IRlEFuzrwJ9ol/5K7Na2ouFMs7/5v34i++5U+Ypn1cG7ROi0KnA6RShxoTE/qwmSDleMNz4GNBU3npfzHuiB/Wz8HCqJzu3cnoAXBasuTABIRpT6pni2/MuU5dR8DKgrHDIyuikkn+TLKGy1gPeJeNwsOHcXnFbSPgAXuXUPbjxZLkaFixkyNNfhVXHL7F0W9zwfXwqO4ouXOtAV/WD+1h1L9xRIvjsTCWVXlcTBvTRxdsLWQx2HobeyyjzHifgg76fwndqLQ6p5WOBTkLfADdoauw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm1oV1JxdXF0eVRZWmJLNjZWMXYzZ3pnbTZTRzN2SzVOWXhTS0RwYTU3bVM1?=
 =?utf-8?B?NlVabXJpRXpqTk5qUHcyQ25hbmRFME81Vk1YTE9jQWZ2T0ZCUE5xWnZRemJJ?=
 =?utf-8?B?c1RtYnZXdEdsNEwyWjNVRWIrajdMblVEY3FDWXY2am5OdnRWd29XR0ptNFlo?=
 =?utf-8?B?MGRiUklTWjZyRTFqKzJKdHNIMW1Bb2FpbFdvU3NsZGNGRWl1NkhDdlpkN0h3?=
 =?utf-8?B?MTYrMERGZXE2QzlsWmYwMmYzNFdqQWtBTlNWMVozbVo0a3JBbWZDaEt4QXlE?=
 =?utf-8?B?eGtLLzU0L2NhR1Q4Ym9CRkpORHZFa2kxT3FSbFpsYzIwMEwzM3Ric2ZZNVFW?=
 =?utf-8?B?VEtoOGdSUHhtellQbnh3cFhsWThqd2xRU3JrQU5oS3lURTNaMVBJTDZnc0gy?=
 =?utf-8?B?a2ExOFhGR2dlRHFUbGRwT1g0QXB2U0RNc2dzNktmVXNjK29xenE0SzNvNk1E?=
 =?utf-8?B?YXJxNm9QWmJaZlJTTzB2STlYanZFWnRzcHpVQ3k2TEYrbHV4SytTRlVrak80?=
 =?utf-8?B?N3ZUL05GKy80ZDBEZjhzaXRxb2pQS25hdW5sdEM2ZG1Meks2bCsvVHRwRzls?=
 =?utf-8?B?b3NnbDAxQlh4TE03NXVjMUtWTUZaRVBlOFpDTzRWMjZKN1JuaTlRK3UzU0ha?=
 =?utf-8?B?WjV1SGdRaHJVUnNuc05iOTBRZUtvamRtNkdBcUU4MFdtOVNnYkdKMEpxekl2?=
 =?utf-8?B?aGhSZVlDUjNQQUlJK0lsaDk0dGJlenNJTEZ0UnhpeWowM0ozY2FTUSthQWF6?=
 =?utf-8?B?Ni9KUUpNYlp6NGhiU05iSnUzWTNGV0V2eW93c1NOK2xOOU44S2RQMXhQUlBp?=
 =?utf-8?B?ME5HWHo0K09kZkhGQWJkYWs1Zlg2bTRSdDRoMENyZUROWHJ3K0J3UGZ4WkZx?=
 =?utf-8?B?U1l3V0VqK2ZpMnBkbUlzbXM0eldOWUZIcVpMVE1NT3RFNjNJc3VmUkY3K2k3?=
 =?utf-8?B?K1NWZWpiY0xqQXg0cmtjb0tnTy90aHRoQWN5WjFNQzU3cHVwK0NWTVR4a0pZ?=
 =?utf-8?B?Tk9DMVhRSU5iSHNkTEE3YllXUStOT2tNZEhFNUZpYVhnUVpRNnlmZnd0VXVu?=
 =?utf-8?B?NERvdEhxbVRyazRjWGcxUjdFcVZYQSt1cFR3aHhGOHN0ZkIxL2hObWI2Njlh?=
 =?utf-8?B?L00xZWxUdXljV1p2czhudlArSEs0dHMvdHQ3ZGRtZTA3RjFqdFhzeVdNRW4r?=
 =?utf-8?B?UmFpUlZhczE3dmxRN1U0eWVKT200aEFzRDFBVmZ3dStLaXg1RkRVQ25mcVNp?=
 =?utf-8?B?SUFqelYzZThpNFF4RnRjUERZVmYyUmppZ2kyWldOblFwZDkvOTJ6aXAwcHZn?=
 =?utf-8?B?cGJoa0g3SWZvWlFGL0ovRlNJZHhkcngrYlA3bmJqbXBPeU90Rkh0dmx3Nzlj?=
 =?utf-8?B?dExmNWNaTHJCK3QwQUVSeWRTNS9uSElOSUJEZGUya2lJZGhCUlp3MzNFNGRD?=
 =?utf-8?B?UWNBcHlYTzhMSFlXaUdqSDV6ZEFXc3RjQUpqUEgzM1B0NkFTY1Ntc1B0LzEv?=
 =?utf-8?B?d3BidVFPNWxOOFNsL2FCWjVXRTFjTDlMSlY0elpyLytNVklER0ZGK2l3ekps?=
 =?utf-8?B?VlVLOUhneS9USy9PUkMvUVFEVUErcDRXOTZQNGFqRXAxekhJRS85ZWs3VEVV?=
 =?utf-8?B?dGxpMHZxUDcvMjVXOGgybEZBQ3BjMDJRdmpGZGZQMFJFd3BpaFdJUEJyT29P?=
 =?utf-8?B?VG5tbktMMmJRYTJXNitMb3pBbms4S2d3Z0JiTmNXaGJsRUdHcnVGZFVPRkRN?=
 =?utf-8?B?MVg2dzBzZDRYYU1ia3lqUSswb3pmczRwTGQrVGpNMWNwdXFINCtyWnVBUkJB?=
 =?utf-8?B?WmdYb09uRUdscFJ2MTlZUzkrVzlyQ1B0R1d4M3JQeVB6YTJRYy9CVHJXcVN4?=
 =?utf-8?B?S1RqcDhENVBYTy8rUS9zV3ZLM29MT2FWT0JvTk0xNXRPWHo4eGpReWFvLzRz?=
 =?utf-8?B?c3lTbTNDQzZsWUx6U2xjUTFiUzFnZER4U2dKNHVqNjI0ZkphQS9TL21wZDlm?=
 =?utf-8?B?dkpYVHNWMzdJYTRyL1htaFJIWGx3dVZVQjduc0NiUkgyVWk5S3czUWVBS0p4?=
 =?utf-8?B?NkYra3AxSnRKYmcyMUpCbGNaNjM0cGhqdVhZdnNFYUFJbjd0TXdWRkhkUlQ3?=
 =?utf-8?B?aHd6ZFhSYkNCWnBXQVhGcFdYQmVtaUpVVkc1ZU1paFdxcTdEdy9abWFNN1gz?=
 =?utf-8?B?V0JVV3E1bThuM2ZsOVMzRFBTNkRPaEVUQlBTSDRaWUNxSkpObStNSnBPbEJa?=
 =?utf-8?B?YzAzNExaRjN2ODBiTGUrNDdrdElFWTEwWUlDVXZDd1dobHJ4NVFWYjY2aEZk?=
 =?utf-8?B?cHFWckhIOVNLYUMxNUpTM0FzSnM1QjF6VEFJTDBBS21jQXNQNGxlMmt6WmdD?=
 =?utf-8?Q?47gKxqptwHjDJPFw=3D?=
X-Exchange-RoutingPolicyChecked:
	c2VU5eEn1wpxr4j0bJeSiV6KTbpoQqrk6GHFhTacOfnOluia+gPbrKEbQkRU/H8hecuQTUuvdd2QrriFYKEzFdjK5oa3ZlvyJ2eXDs4K4WJklIxqemtVHLc8PH+kQoyiJpneVj9wuZGL4YFhkXymgCmreNfLkVhewMenV/GTvA08OFo20/IqPiRR88BFAaDmboZefFKPUf9zs0sxtN7Lc4Rykf7Kapa1jWG9N2POJWEnLtXsCLXFSGB2TpTSSeBTypgEBqwJGp+TgPVHjHAcBsxynam0S+5AgiuJsKAtEih2Sp4kj0WuZhPTAzApmm1F1BqyjFUYN3op9hpNWzRkPA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FTxqbEYwr4e/MWUQaJfTgzsLWgudleZO/U3yDAgad6u0fMnUsreqx3fxkp/GGrDL0VAgwZ1wjGiWWXZvKZlnwJcy9HnVcg7KMGbnpKgAGU10MQCJS5tTY1fn5LifkpufeYaF7QBRgYcSBYcszCzAqjcnG5UiKANRdTARnVj90xomDSgmeEMCwy1r9n/zy01ubatHPBFj8KyIpIHfJq6HYLowRJbXXM84rnctBQ8168hIfSwdO2R1FowYZZkUzAcgCrdLZzVh0CR18qcYcx38uzTpOo6WDi6fZwIR81Ov8vTrFW5jGy1Wgg5T/cDxjlMe9fy5e8tK7MG7OgIy87ghYKkVDY5qxcMBgbU129ji0RVMZ9YOKNsvt8oYHGs82Jv6xHIDgYWYRkTB1oLMM6XnF87zP4VbxZkggz8UcK/Vkv42MZrnoKmUP8hE/XzW4qj1qtpEO7X7GXQImPLlI3BGCaopK5CMoTrsorDq5EDFLqe8uhjQa7sm+mktLv5voLsnpKedDaWQesJN5j4mcNQuKmU6UTXR3NGks9E3oQfncOfJef1v5smqwOJFHGmtthLFyArmMIwbruY0bHQ/2dVPCwhsdBBxFQfvlrwTUbwyXMyBnEyw5Hjcb0+LIdi10jk5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f70712a3-498e-42d3-ca56-08df0cedd609
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:39:34.9860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Zk2iBkfty/pGoUiO5K4D4KcVz0K01zBhj+xTAasVrekYP+/Snj/9nlwbJLTUQb4lMWih8+OwIz3j48XD8yz11qR5xlhIvTQRiKzPLDDKew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9329

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

