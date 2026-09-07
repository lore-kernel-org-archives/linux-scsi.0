Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E9538A72B;
	Mon,  7 Sep 2026 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794955; cv=fail; b=rS+cP1vcA+0hDNjk3xgQKp3kvBjDguXT6+Y9J8cxDe55RxzqNwz9sa7B/7TTvP6MBxjKhMCdTfzClC3FrGEzMlv0O1AyYDnCrxJRjATRR1YD9JgQFHzIX6hN4+AE+8RG/BEPwdapNSd3DfAnq6aOQqLlpXLM/HMWp7Rnptm1XRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794955; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ep9vv+nyugTXDNRDOokIqyc+Duq4Vn/DrplOgts7rUDOLegk6IRGbQ8+QvAjR0jYLHm0L1JKQhDJuFRYN1DOcDoHh8IocOMBkiNcOK44LMW2dmjEM0tUHBZl8bmonu3aiZDPRJ/JOKSG8rKgjnxF9VuVMsG1Oq9AykIwJswbxzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gEih5P/m; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dmPYmdG4; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gEih5P/m";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dmPYmdG4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788794954; x=1820330954;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=gEih5P/mCm4XT65TUgOhkYMZDgkalUskBb+wnMGkRqkCq7JwPlkEDi5e
   IOUyMPctnOrNE+PrS97Oq7UR7jvsEjiOd5tn9nL1/WN1Dr2ES/xSOEbYm
   QI3Mn0LBtIDIAjZ0XtXqYd+y9H3GGtsAp7XcuSoc743Fzs67pd2XD/R1r
   7uhVyiliH2IhqB7fWDCaVUI87l7lu3Tv8LzAdugrGL2mKX9KT8ypoFpha
   nIXCxOje2PqzWCr7gLdcM/6D/WZErOxTeXAw6JcOA1lbPL2ryMmpljCSC
   otK0pa8mDxKjqZ0EYC/S/V5KstYxDjwmrdXMsF12tYpSZD9qsz/DvAV0B
   Q==;
X-CSE-ConnectionGUID: NpE5f55RSKOcnfkwy/VI0Q==
X-CSE-MsgGUID: zWkdw7pXRhyZ513BGSYz8Q==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="150923137"
Received: from mail-westus3azon11011047.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:29:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=at6nmrgtF11dfa90cPWeGGJSP3FVArPkARSKjO2mKLOBVHG41oK3HKtdWwxlaEaLz6zU6h1J5pcknnvMDYJqucfmpDzzvKfKfG4dsnDrq8MBvowOiY7P7Ycl9vPTuNN4oQzUxVgHbhDUdn9XJd7VKz7d4/RPTXw8WwLU3NG7ebKqDIONy146DZm2B8/Ql3svSOOXJstpbuWc0pfjkjYUF415BQ6V85WNFLmRZkuHF2kdtgjDiSee/8jMjTXDjcMOx76K4naciLjfzUGKSpBKWoeDqhZiAVH+QHKEgj8E6qgvrGy2GmPve3AALi8/cJuBdRdm6YSY6Jr2rI1war0XTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=C6YmgL7RJTf1dezHEA+W0cndInCv3qxqh9BH/llRiw3A8MCw9KFmRf0gu4j5gbHkWbK6FkFMAPmQZfmnw9VKBTDq7fTBTiW86RIk4+JVH1uSw5NVx4XVHex+QNmbDCQvPa8HsBqjNs7G2jD5fXtEgR+Ma20Kk4Yp2SnnfBb+zuhuBH/EIoE5WnNfS+bKNd9dw/mpn5gfPvG1CUGuhd9FogfVbJDxI+CWuMCiuJu7FE3SoNGMULolR+HE/lJ8PZ4uttok8SDAsL1Y3rKSKaqe/z7kE/GHCLEdhY2c5RxcZl10BlO2YrbpDv5C/WLSgxrZLVcYZ7I573bMJ2QBWmVY+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=dmPYmdG4aEI77hEJmFLqXK/Oeqz3rMa8YAMoixHYOctYx2sWzEnpXOMNnBLNzLxLWTz0HpWNF807wph2Z9memptg0cflSsww3WDLySu4xfLJnKpXSQ+KBpleN4xAzYO2f+aGxWq4doTzZ+KaWQ1yzy3w3QgFkSK+EKP0bEaFaek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB8960.namprd04.prod.outlook.com (2603:10b6:408:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:29:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:29:05 +0000
Message-ID: <1e6e6769-9cb1-467c-bdc7-1b47e8fa6eff@wdc.com>
Date: Mon, 7 Sep 2026 17:29:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/40] scsi: mvumi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-29-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0177.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b75c2b-916c-45bc-8abf-08df0cf4c087
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|19092799006|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	3t9UuRfxoJDn/VdgBI1wJj+ambGsv+8TTyUkhtauDPJNePLI219h2YspOmO4DnrRzAg+12uFMBllIVA+jXPTMsWmvqrR8rBRWOQZk9AThS9J8c0v9d7O0D8mttXPjqwtEootFOXGiruTFxLkol1KAaQl/WkjifZMjgqK6glSe4w4pxVfV878UyRH1rQmrog1J65UL3Plzm5g0Jw4Su/4nFLJNoauUn1TtF/naV5K45iXZ+msKCJz/5fGjHWWthOIFqSwTOrmJFQ1rFpA6fAzf5P++7MRuhKtkV376uFUyYvlzUv0vpJroDXT175uu0Ni5O5DF8ZMED2m8PiZBxHQOaR4ov24pYxq6mWeVTjbW2LUKcH3faA271yqg5opavAT1WtZHFJIvnPoZKbK8tjceNZ5SoBqUBZXZwwwmbEvpbDQ0aj7xy8UiuIgwI9Cg4m+diciG2xAZGZz0bkPcLN1eMincUkeHu2tmgj9rQq2H1tOvQHAdGzaf+3Qw5BdqUbTinmHbKwVkukte1MMqd1C/moG2GxrV+ZImimeZai4GG1BMtLuH0hoQhwedsotcq/55VmgoERKJWmwUniGDRsYbaiPQ7dzrekpUEnTYUON7PSsfrQeJjheVoZ4xUBhjLziAp+KiuwOq3qrbA2jRO7lntPsfGRB680MXglNg3y4DGujvyzpk+q/tGEyJTnNR2YAF9XKkqsKk/Z3EV0MZIStoQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(19092799006)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWdpS3pUQXd5WlhoK1NyOUR2Q0RmSzNWM3hwbDRrRDFxN2V5ZWY0UjRwTzVR?=
 =?utf-8?B?eHRjbERtOEVYQVdTZys2ODFwVWVjTmIyV3dRK1IwU3k4ZDhFQVVlYXhCSVN0?=
 =?utf-8?B?VFYzNmJTaDV5UEhDbzJvUnI0SWNsRHNnbzlOSzNIc3JnY1h3SjdIMWVzTnZU?=
 =?utf-8?B?RytTbW5xaXU4S0RGSW1tSE1xM0crMWs4VFFoQmJHbGh2SE9EM1dKZXRodG5k?=
 =?utf-8?B?QzhQcmk0eFl3ek5OSFo2cGliUlFUTUFaWmUrWDJmY2M3dDlIRytqemRod1Z0?=
 =?utf-8?B?MFNwcXpyaSt2UXhReXJDUWlHU1JnemllNEVyTWZWa3hMTzNLWXlzUXB2YkRn?=
 =?utf-8?B?ZFZxN0RBN1BJVUVYbzYrcUhxUnpNcWxNeGFqZDA0clg2a1BPbFB4R2hTWHAv?=
 =?utf-8?B?dXpuZzRVMVh3KzVuRmp3UGN6dEJsemtCTDVKZjR1aTVweC9iSXRkcko2NmpF?=
 =?utf-8?B?bDcwci8rVmVMNEk5bnEyTGlqYURtUTZPS2R3cmxydDF0TmkvY3JFNHd6OG1p?=
 =?utf-8?B?UThLMWNWSUhiZFZjYXdwOUJZd21za1Z3MkVSU2RUZFcrWkgxN2FxcEdHMFJh?=
 =?utf-8?B?L3JJRjI0dmxkTmJqcTZLK2J1bHk5ZXNoQi92cUVzcTZEb0QxTlc2KzZEZzRC?=
 =?utf-8?B?UGVGT1owdENLaEgvRFZUSWJKWGtEbFRKNGMxWkJrYjlUOXJkU2tnVWpYK2VN?=
 =?utf-8?B?VnRwZlhXeXV3ekwvYS9nSzFOK25uYlpaeE5KYWVoam40bzl2QkJYZDBlcC9y?=
 =?utf-8?B?MjlCVmE3aUNNSkk3eGNEc3pOWHNJT1R3QVZCeVNTY01vdkQwNDFjY2NISUg2?=
 =?utf-8?B?dXNQUjFEemJ6cXFhRm9Qc3lsMzNMRDNYdnh3bnB4RjRYMVpqQXZtTTJka3Br?=
 =?utf-8?B?anhGV0d2cVJFVEwvTmNpcWlHckhxOXdKQ3BOTnVobXZrcmlXeURxdE1aQ09y?=
 =?utf-8?B?UmxCM21KdCtaMlhCUmZqVGwxalpSaHFZVHZjZVQ1MzVwREdhbCs4VnR6QUNZ?=
 =?utf-8?B?MTBoa2o5Lys3TnluYjJhNHA3djFEK2FXSWRJQnUrbytjU0pWVDBYUU1aZnc2?=
 =?utf-8?B?eEN4SVhiMjYrdmJDMjBJS0NtRmdNMll3Q29kTEVWMlg1RWxnZlZQK2J0TWNV?=
 =?utf-8?B?U0hGSlZNWFkyRVZ2OW5OYmlVb2VwWm9SclMwLy9yN1ZOUHNrMzJBZ3gvL0tk?=
 =?utf-8?B?TmtRbDc3MURMRFlrTmUxU3VncjJ6VUZqbzU0SFRUN2pQZ2plRmhSeDRHeVd4?=
 =?utf-8?B?d2h1Vnd2QjQxaWVvdkMxWStXZEFSVTBLSEl0QkRJZVNPZWhzclBJdzhvY2FJ?=
 =?utf-8?B?Z3BYVTk2citqYkFxV1BQYk1oYXd0dGhzYnlGOVhJRVkvazllKzJSY1l4MnYr?=
 =?utf-8?B?T3dBSXdFUU5IWFNRRzFmZGNzazZpWERIVlRTdTRMSVU5WWlua1VmR1BRekhF?=
 =?utf-8?B?aEJ0UForTHB0WjhscUo3QkwzdHNYVG5ISlpwamdWMmthYkZ5eU8wSWs3bTU1?=
 =?utf-8?B?R0dad1A3d1pNNzVtSmVSeW1TTUN3YXl6OEo2aGpocmEyRkN1Y2EyZHh1aGtk?=
 =?utf-8?B?RFpUREtRa3pENkNzRUxQODRuVnNIYTB0N0VMZW5Db3JZbDU0YzRQWVNlek9P?=
 =?utf-8?B?cXhGZFNBYXNpWG5LR0tVRW52bEpIZlRnTVZSQWRKYThHOTBhM0l3bTFsQTY3?=
 =?utf-8?B?V3N1Y3NwRHdjbWtvTVd1Z0NEbE8ySlAvU0JJMVYxY0tuM1dUV2FUWEZoWnR3?=
 =?utf-8?B?b2NDU3VKM0xVWkg3ZVJMTzRVZ3ZNMnl4NkVZb2p0aVM0S2M4SUlKSUcvYzhD?=
 =?utf-8?B?bU5NZFJ5dUt6SE9EV2paRHZiZTB2UnAzclMwQmxoSWZSaWtrMk5wUmNJU1Br?=
 =?utf-8?B?S0RFUVZWemFsWm45eHFvMU56KzRUUXFpZFg4NEdyZ2ovcnIxSmFJUUtSSk5l?=
 =?utf-8?B?L0plL1dOekg5QUhGNjd6UkR6OTBKWkVoaUxPbXV0WlpLYWVCWWROaEVTT1Q0?=
 =?utf-8?B?SHN6Qml2TTJoY05nU21UZ2JLOVVwNy9HTzJsd04xamFpWVBkZ2xjc0xSd2M2?=
 =?utf-8?B?UmUreXNxc09hS1Q4V0ZiNVYweTk3Y2s2SzUyTlBpK1YrcEQ1enpidjk2S29j?=
 =?utf-8?B?WmNjR0lITEJsSzNvQ2I2MTM5aTdORmtJTWNpQ3EzcEhsL3EyT2pnM05jdHRV?=
 =?utf-8?B?Wld1RDVtZVNWZG9EektmUWdMaFovaG5Nenk5dzkrUjhjcGpCTTBSd0YrSys3?=
 =?utf-8?B?SGx5V1dSQ2V4SitHYnFCTGxlUzhXa0FSSFVwUXpQZEpHczhHV1pQTWJqSVdq?=
 =?utf-8?B?QTErcHMyK3dNbTJSSHFHUmNOT0FJWkpDMWNOeTBzZ1hWcVBPUXFCQXEzQkZB?=
 =?utf-8?Q?dN9xSaIOJ5vW7Qe0=3D?=
X-Exchange-RoutingPolicyChecked:
	dYgc3nRFA3dfgt15ug3kN13xnKkoNz0pPLtZ8lRSSHn+clKynM3dXZmR53NXvX7Mepp3ukbmFm907w4iFTjoiFlsLdZ7FP4GpBB3ZbmoclC4dz1fbflJv609ZwX3EUsY/5Nek1q5EwDVXgiJ1iMLRl1phKNmLvwJ5FLVYucGXSK3N0GnbdN7GUAxAUCNUwN3Y3B4YB0HOhlwLCSnI/fpjnpz453Clmp2HkM0eWIteflOe3/l60AWjutJYMKNIpvDD9GODyuvfhnFNaLOVTaYw9lzpfm3tMyYn54V9sgVKHwDaAmIT1G8d6a3oYBHkVMlLHhdlnqVM/lNLFe1DzeQeQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dOl9MDCkP90IExwLXlN2IiQ0yeuvRT5TWiL/+cVMEhYUL0+1BNY6J+MUu+N3d4F//TKXl69+5fQaSPEBBJqPk2x11+ojaNXKxNxJuO+/KE6eT8GCchlNaeW5i9U4n/uSuaz5u2G8s0gY/S04mGhMZzEfETjKKnZQMXMYqvQZYqcSrIgaGXutbIrqyePI2apev+GYBq62Iw7aDJiTLZwuwxsEU4NkAt5YTHcXc9WeeKuf/2RvXLCPw808ELaWMmqjzJ/4uyPVLd8a4uBndfj5s52DW5E3GpZz3o4I/jiJGwGwMEFB/EvpJacFht4xa/SxeeAuor/kE8au3lBrfX2r+PliykfWz/yl8TFoNi9LNjFbmsjLTqhAUtWqZK3sarZ8R8mmCdrWEQcIat352hdTHWg+qMTzEDtBgDae2I50WaQuGJTnux7l441+DoYtBXuGHrKb4s4HTHGQSync1+tDi89UCZraCoAMns+UQNWy3vHNzVoSdW4S21H/B77g6lzmI74OCQn6iASTjvZs30B+CTXs1IzayxCQVLl8EAx2v99xp4NyURIZXV6/W5zSDPOakYGulQ6ecw/spmgPQngYbYd/34GG7GFuz3Sorpw8FYqCQj99dzddcb/dE9v1C5wq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b75c2b-916c-45bc-8abf-08df0cf4c087
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:29:05.3694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rij2KM2eWsZxFmuejaqXfwgnQojQGf6Qminez+z6+VIxwLg8u5ND1o2BEZ2v2OkTBATHwxQizziIXpK9y4PjypN5wCuZBVPzhT24I5tH0m4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8960

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


