Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C3A2CCB9;
	Mon,  7 Sep 2026 14:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792898; cv=fail; b=BGvXNO71uNgMCV2h/6j8LkYh+yh6F1b3/UZSUOG4BcK7ljClxVl78O+wbqvVzFg8sk/AQqKwKRzh78Zskfwy9OIaiHLCWDPjOxkkTj1trTilF418NdnOcfocABajfGS4d0+cV7ay3Zsfi9XjrmMLWX6XknTi1CMRSU7qXfZyfo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792898; c=relaxed/simple;
	bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EEmiaPsv7/4O5a9QqEXUhYvGw78CFHZfApsHcPRJh9u5YzSa1E7xrtTprlz1eR0XUJMkoKkrKw+H4WcrxSsM59P8+TYAi6Yh7TxfcotdwsaI14FaYEJbAnH57fesKo6dpcH/RjwxJEzmPA0IMxd7tHpKBoby9j7u7vFYox85wwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YdhaDcfb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pcsrWfMy; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YdhaDcfb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pcsrWfMy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788792896; x=1820328896;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
  b=YdhaDcfbungfJIQel+d+QRQadT4RVNuALf+DSGHRCXkoApgDifKSlbb1
   tD1Zqh3dc2sVPIc2HEry9GtOzJPCKc5tP+cQsymR0eDFs4g1wLNDuzRlx
   aAel2o6KMVkKt8z+R/2eiEAH/RBoyrjKdgMK44rVsw+4nOg5YZ8Tx7358
   XGKw2p+4V+idqFH4x6qkegLoU/Ayrf1GH6WkolvILqN27gfARqOxKyBSv
   d/SxfJSd9db4kdxWvvGFyTlqlFW9QaugZ+YPuTWyDhHvg09w//rz85ez2
   JmUurUrKXieAfLKLIITmu77pXVFErEqV0VDUZUOf8jZlsGcuEVUhvSWRs
   w==;
X-CSE-ConnectionGUID: YxbvL/SWSOSBiRBiPvKyww==
X-CSE-MsgGUID: u6GXGuZPRpWENyabgdWx5Q==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153546540"
Received: from mail-centralusazon11011059.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:54:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oy2SRVBvoQk6JFe1qTK82aFQuJXlcsg49B+fR81ayLNBcBWk5YHNwpa/VmPI0ZjAudzRf8n1kMFSOns5kNrbE9hWlki/bjz3EjdS/zPijEpbSqa4R9ClSX8P2L7RarPCiw+9JeDuW5rHJvciRmp+kDLclcVL2QgpsHR/aidpCgmIZsHHfYW55pB04FkSKnV41RvXD9Sk0QZr+jTE00338mOsHqaMC6KQsNsziez/YGsIbUMgOgu6caqkacKZ7E4ELPsUpJtoKlufkmATsDwBH72gB+DZu6Te0mZKq78SJNA5tDTdRfPKRUTrkoOdTK4hoBIf0mMJmmB3PqlOYrsvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
 b=yBcqIOuq2qZr1tCl8O/PtSqK1hHphNcMwAHRMj0mKvm5AOgq0O42PoYuBAT+zXDcl2wiE8rLLOLFcxk02qzLsXAiPM7Wqf0GaidVQUqfXjOP37XNe+Pvo6+Wa3+AdfE+Byi6NZlnjs0aq0HQPpQeUNHuh6txcScaoNX+Jm+DoQWQL/kPDUtogV3M6Bb4xJtHtrJfUffFEpai6ln+th2hihXXm3yz/K6oOUZdEK0DoYpch5+Ysm+U5cZfGVEwFhYzyloPgCvztokdZiYdwLVdY52OIckdRmURZVed0sbT3VE5PGz0+T6bhTwTNbD77GMVWhqkGoVqr4oDMUorZDfntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
 b=pcsrWfMy7MsCQITz6ARfEL2WJSdJNA2ocaMUejX+Jqk22hk4SqQYLg0BcDCLDzDJ64z+KIiW6NNHzSLlS8ncRJBRxaCC7kUAQio0I2BHbJSatFRG0gCZFRSvFlWoE/4Hl1m47CbIP+dhDXuM/yKI7l0yFWUVu/NEXApuHTGW75c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB7076.namprd04.prod.outlook.com (2603:10b6:a03:222::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:54:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:54:53 +0000
Message-ID: <91eb6ad3-f626-4e19-bdc7-5371bafeee2f@wdc.com>
Date: Mon, 7 Sep 2026 16:54:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/40] scsi: myrX: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-23-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: 379b3476-2900-4a1a-3d03-08df0ceff96e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|19092799006|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	994KrqeEzg2LW3cxPFtVWYfOuwhEX9wchJMGNXk/dlw5r5VkHcuUnsiQpmEVi+WWqYANDr7VBlN1zBwzWOCXi9sj+61XSNWhrrIEYxYjvMwqk+YIdK/6+kyhA5SH9VnTJ6LLBwEYnoDYkjfHdmZERkrfVGYRMgfIKNr23OChg+hp17VnXPtcJ2Nz52UvFnS1/KGI4ZBOZHur1Q8F/JFNYIJvmWzPAmXvzl9tvm3w8CYqF2/K/Fb39QtooPbjxUIkD4Ov7Npw+4QtGFeKkwLL3Diqnw3TvrjJU8pxRshuuoyTuJlOr1XRuSZMxzhAZ1IgHsQB7n/V3gD3wwwuMznMBZc5w+GIMMKFEfCdOlTRL9jzYwkQa1IJX+cRV3PJF4MXYyspHTZRj/tl99/K2hAEKO0V3fPRLOHClCSzffsB0FdNG8iH+5ou/RrC7O5v9+drwnXXfecZjlAO2SN8X5u6xj1VPG24nNChqjq5ZmoTRMKnD+9L+Luu7g9oe64/xcJ5q9BTqQBjz5c6FBzNAPr+2EPCS8Q0pKERpRTIv8pZisCC3DAZvhaJF6DV7XXGtxdEwr8pdieXr2Rx3KWFkz6QGl2Gvzc1KQpel86SVVKaVyILKT10mJ12q0GBHNU12uFx+FJrIw8fX7/lWzB+YdVRMXj89hOQ0SUcFaOrk6hi4+1Dx4LYxWGCzNDonfDQ5IwxqLD7rnh73BvmeDuEWkUsxQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(19092799006)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTBoaXhrdngzNzFjU09WbndkVEwxSzJIY2JHdzV2cDhBU3JrWE9EcElwUHQz?=
 =?utf-8?B?cGdPRkRaQXpzQ3FGSGE4UWxtNkNPU3FDamwwYTNOQ0pCbkZTOXFYWTJaMkJP?=
 =?utf-8?B?OCtuTS8rcmhYQnBmUldERnFES0lsUnA2QnJWVFdtVndMNDRmcnhsa3ZzaVAw?=
 =?utf-8?B?VkRXUk9DY094Q2UzSEJJclBqRTFDQlg2blg3a1kxNnRaS2g5WkUxQ2pDNE9j?=
 =?utf-8?B?M0JNN3hEb3hNYTVVVmVCNDBYUXh5aEhjeE8wTStGNXpsRjBzVTRCM1I0c29B?=
 =?utf-8?B?VmVoSXpjSGFoa2tFTkdPdC9RSWhCdk9ISjRHS05YNC9YdjlSK2V6d3VwNHk5?=
 =?utf-8?B?U2hSK085WnpxWG1mOWoyczRuaDUzdUdoZ0hQVFFMMFBEcm8waHQxWEd5cUVx?=
 =?utf-8?B?Umt6aG4ycEVXcC8zakpsRS9BSU5wMWxsa0VqTVN6ZVp1ZGpxNDE1ZDZtKzlO?=
 =?utf-8?B?alZuQTdJRVkvTWc3anlXeHR5SzRxa3RiMHFOU0p6Z09zT0g0VVdYelZZMVFY?=
 =?utf-8?B?K3Z1bjFVRWY4SDFlOGtWM1VVb2ZySm9EZDdneFFiNjFrdUkvYkx0aU96b2Ix?=
 =?utf-8?B?UVlaZ0hoejI0UmMxMlZvSGIyZUNCK2djOUwyRUx1aTNHSXI3T0J0enUxbkJX?=
 =?utf-8?B?YTBTSmltaWVOdllGN0Z4TkZ2REpENFJ3L2J4WklSazcwcmlBMEVsRG5EVVR4?=
 =?utf-8?B?aWV4LzNmSHNuM2lqYUFsSnV5a0k4dkxhclFUb3RhTVhwdWJpZDgyLzlINWQ2?=
 =?utf-8?B?SjZWb0tPSTVOUFRvTHdwSEdFWHVMUUtvNlRlc09xS0pGcTdvMUg2c2hkejlW?=
 =?utf-8?B?NjBHY0szbVgwRHhaaGtmSk9zUS9zcG9TWk8vMloveEM4T1ZHV1RxMVArL0hk?=
 =?utf-8?B?RUxtZzdHZzZuei81MkUrM3V6Qjh2L0NSL1RsZ05kVm1iWG95ZzFEdVEyNUdF?=
 =?utf-8?B?QWpqMmlpQ1paVFMvd3AzSngvV3VHeUV5NCtvcmZnMHhWN0ZQU1VMdS9scTdq?=
 =?utf-8?B?cWxxQWpET096Nk1xN3NDZDNmdUpCcEpmUXVhMGhBY1I2bjJ5a1I5dTlnZ25E?=
 =?utf-8?B?MDRjSFErZXIyOWxJNU9USlVrcWd6NFI4YW5JZHJiUzRFMmsxODIzVVREY2ZS?=
 =?utf-8?B?L2h5ZnZwdURkR3JNQk9lWld1dWs3Q3RPclBSL3JSK29jR1N6aytaVDNwcHdr?=
 =?utf-8?B?YU9SUHpiUjZkYk5ibmZWVXhKWXlZRmhWRWtFeVk4RnRDMDVWSHdJeTdBUWRm?=
 =?utf-8?B?NWV4bWc1TTgwclo0cDN1UFBKL0hRMDM1dHZHeEZQYVFwdXpSSzVIeFI0a2R6?=
 =?utf-8?B?YURTMGFFRlV2TWhDSXNockRGNElZcFZuM1FiZC9DZlNhUVUxSUI0aE1yS0Jw?=
 =?utf-8?B?NElSQWhPTURqbVZsRU1mcUtPN0tFNUh4VmlpVzg3ZnIvdWluaC81THprcnBn?=
 =?utf-8?B?eXRsZjRXRWVrTGYwOTg0Ly8xd2YvOGhKTEhKcXVVM3lPbWJWUEJrT1pWVWZa?=
 =?utf-8?B?ck0ydTArTWxuQk9tN3Q1emR3Z25tSlY0ZjV3a3J0MndIVWNKemJFb2k1YkNQ?=
 =?utf-8?B?cGhVQUcrbitCazJ4c0k1L1UyeGIwUm5sK0xlRHJLeStlOWlOSWdoTFF3ckxs?=
 =?utf-8?B?YlFFTVRBQWhhSktGaTFic3EvSVhoQnh4cVJIRlVEN25OQktQSW5XQ25qT2Zr?=
 =?utf-8?B?M0xQZmlxMFp3aHhTN1AzZXBEZ2s0a2RYdWsyaEw5Z3E0a0hYZlhyd1dEOExi?=
 =?utf-8?B?SWZJeG5oSE1QdkZ3LzduQ21zRXlWRkhnOWxNSWRuU0pSRVkyVlFZayttUGJm?=
 =?utf-8?B?OUI1MXFVUkRwaCtJM0FPK2pRZXcwUjVDUHJVRGdPTytERWM0REwzbE5tMG0v?=
 =?utf-8?B?SVBzajU0ZGtGcUh3c0xrZXdQTElnMUtYODJrdG90RmFLUGl2OFJlL1B6aVpD?=
 =?utf-8?B?bUdpb1A4SGdHckF0MU1NZ0ZWNGdoQTFubHhuSXlnTG4xNDMrWTQvZGxUbVVk?=
 =?utf-8?B?VHhOb3pSaDZRVy9XQ21CU0Zud21wYmo0YjRvZmo3d0NITE5QWHU1NnByMERi?=
 =?utf-8?B?MkxmWDN3OFNSRllqUW1nTEp6aWpaQkYxZHFkM0daU3grSStKY0hvYWtkdU9o?=
 =?utf-8?B?QXBtQndHdlFqUVg5V0ducmRTb3NpRms5U2tSNk1xMHZtN0pJLzBBM2tMZWpB?=
 =?utf-8?B?K0hBR3hOVThBcS9zSllpMis5OGU4S3dVVzFSUDcvVzNoNlRoT0ZVR3pKTS92?=
 =?utf-8?B?dVYvcFJrTjltWmNGMXNka0RmR3RvZW45a3p1ZEJmR3gvYi9xa2tNZGNkMHNh?=
 =?utf-8?B?VFRNNDVGaWJXMXZlZ0N4aEY0d1RvbkZ2VlFOVWhNOWR0Z3l1dFBHUlRVa2Jv?=
 =?utf-8?Q?gcuUg6xN+biYHvOk=3D?=
X-Exchange-RoutingPolicyChecked:
	jB0U1c/e3ANLyW0EWw2FVVr0gbRIbLgZ7iYCtIbwzzhswVj3gLTVg6w713ekgxCzvC3fuwW+p0Uvdbf+OYBpEJgpCNiIDkgqa+yZykYfjCcnxidPDkaGXJhDnKv0pIkgCZE3Rjvxz353WDd7v8Bipw5ptGoPcKx+b72sBPt0TmPh5Cor0kU+ZdgJOwrARb+yob3nvbhcPLidVVK8z7uSV8usv384zUwiiM7IB3HiolToApfgIiz05lxBWb4gPEhyItiZZQfqbV4l/O6OJmLfcwMf1mjMRoQQTlcjR1KevfQimXDipjbnTgYM1zeXwqh4/ZIdx1xvcA81UGK56E/l/g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4upANqFPlobgBmY/9BOdWBEPanHCYB9XonAD6EzRuo7UXkCZvo4LqZtX40aR6aFpRe/kR1QDjHL+MJ1F5PFSFRh/VcuZSe6EzfijOsbaqybV4tGWkjVR72/slkxIWsvZ+dmoG8ESno76iOjbTGyXD83ikcrUaANeQhuX5SVFGvXn/4Zy/m/CnXHgQiBzWMdXHu2S2iWArkkXejl6nu0lu+XbtehBAIRlCmXw0WnfEzAPHliwclwS8F+nPHecdh/MTCoiJCXin/3agngGAyKrwIbUsC7rcA1TEEntqksPIguFD9mvwAR8KZyq12zp93KY3Ixek5fk7h6mDpfxBJ4wfYXE98Ue/iXEc3O53WUNcjdJgN3E4p6aSEXS8TkOqsWKqbTXx7A1Wq+wjhGfY/MjQYSGuXOIZe+j3iAL3aTB01gwcSqWO9NPWOQAJhYiGk8lqffywXpN3cWSsAnCbWenCzR2qLAG8U/xTKl0dOvbHrekfSgU2hjkEohegjHnEIEjkLtWug1Hgh3vJWFPjCRT28dgnauWZRPx+wxoDsVXTzSK7vHN8KmkNfIafJkCKL3t+o6FttqBSqiFXKAjqAH3lGOU+AbKRZzkd/gBqAhqvxcbuKLM7lGe2yEdI2WaIqJE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379b3476-2900-4a1a-3d03-08df0ceff96e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:54:53.3534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mh0L4/AArMyCNILxwW5MadVJtoPuKVQwJ0n5TkzlAgQ2EnrGJgoc4l0RrBlnQxc/xU9QrWasrOFEMB/YmvyBdnmJC9HmWFy2q5NZ33/Ls7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7076

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
