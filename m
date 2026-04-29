Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D09377EDB;
	Wed, 29 Apr 2026 21:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777496511; cv=fail; b=NOQepLhrMm2wm5DY7ZXJEQnE8uCqALLurLsgu60xO8VEsqRe9OfsbZ7B7tAxLHAZtyZMohmwtzGLHroIvkMREj7OvcL0EEPoOCcYpYw7NgYcpsyDUnaUkpFsngDiqwWZwQJqv8VPspfp+VIPo1lPSNSUyuzU6Vb3k2GVZnKsxwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777496511; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bMWVedRLlUdvjHvz8OLyclDsT/4yVhLZ+ffRYinHVOKzES++9SsQ7EtANhJNk5J1H9eI8QgihQ7Soc45JozoQtfblOepaSXLvIngfBXNaCoVfdGa/Li3UWsbsCsFZrFZ2g3+iQMIMBMkm79RwhbcoqQSwjwRApAuewD2wdojmzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EysSQttJ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Cr1qjzhR; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EysSQttJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Cr1qjzhR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777496510; x=1809032510;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=EysSQttJh1fT8ketD4wdStFugfn35ryMbObZtUbExEaFq3bJjg/H5cOa
   3x6UJcC34CAZSoDKySmrHvhsVH4UN96AqLmsyjs4XUErk23EGEHIn7E8y
   Q9PMPdBAg0AcUzQGIoUlj2yu+dAzjorCd7Bz+oU31WUJWEZF0Olh31PJH
   /1QuN6kQgj2zcDr63IZA837izhk0lLVO+hypvlPxMYvGgZjgm0HPKrbLa
   +vRhOxyXiBPcfSKcClKL31XVoyz/EjM0EcHv610RSAHUEIqcZtrPJwD1F
   3gA+X9rvnJ3tlAoDhud2O8ktimpWS0HHU5Y+lFdL1jdH0oEXKyG1zKg2w
   Q==;
X-CSE-ConnectionGUID: vfRHCZr/TVC1ohXCR6W7yA==
X-CSE-MsgGUID: pySwMh91StC3ImlXeD5jzA==
X-IronPort-AV: E=Sophos;i="6.23,206,1770566400"; 
   d="scan'208";a="146700655"
Received: from mail-eastusazon11012051.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Apr 2026 05:01:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mx6vRmj6XgMxoyublvQsdAqKl3Br7MKWcjEc7fSveVELZOBNmPzgxp68QVs3fdRsjC9XGa9C0PRH7b0dqciwxJf8eATgIQccpvmSoPJFOpern0SUvgXzA245MaEP67mbpq6qau+bWDAN8NMvw6ugjvD7vnaojn0JjhZ+gTdSdDMq6Fyc217TTj2mnv8PeEzJiHHjci9+Ht053BmuvpvLGZ7314I0Bi5O00tFgTgci2LMCPnXZgLJkgOTY1oZDnZstAapd4Mgo/hy/2yEV+2Ip5Y89gGAs66xlF5zMkgnzWUWSQMenwVW3pB133W4P4l16Kj2cioYBWSfZqJPCIOfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=qAWYI79gMJxTvYExSVtK0F2ZR5YIV4/mPrhu6KGNu9pKyRl5tAgucYDcF9PcuNnhf+52pgI+lMyyi8H8xNAGbaMdmEetoC60rDi6LwpXoUOTVRutKtU7jEYyt9xCqmyZjJlfy8HuR5j/yVeA59H2MZTKuaXd+DrGAwceNbt7Ga/iDtYdeAtYdtI114/4+4nhJ22YwgtcdcqS5XcxvkPIh+k6AQnB6ZTnY0RvnsuMG5BnIvBHXUrMMDldiGo9fV7UAJpbr9yZgK5z+0Y7dcLhsSW2FshzEz+3VCyxNZwluk7V58tZcw+FGggQtajZaTOyZLwXUcDoHlpzcuQdhApLwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Cr1qjzhRYrmQ1wzhJ0E4jV8YBHG6YqOcyEe7DRJaXJX3CfCKA3EK/I5DXKj/8sbSH6SKFeJXW7tJUfBOxEcJY4D2gKoPXNTGpxCDuSL1/4O9feuR5+XadOLvLpc1zD8OfHKn8ZxIIeBLIx632ct68CYfIM/Mvr9I+z112CKE/BE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA6PR04MB9446.namprd04.prod.outlook.com (2603:10b6:806:447::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Wed, 29 Apr
 2026 21:01:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.20.9846.025; Wed, 29 Apr 2026
 21:01:40 +0000
Message-ID: <1abb005f-198d-4f9c-aa57-fe8fbe1c2afc@wdc.com>
Date: Wed, 29 Apr 2026 23:01:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: advansys: drop ISA_DMA_API remnants
To: Arnd Bergmann <arnd@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: Arnd Bergmann <arnd@arndb.de>, John Garry <john.g.garry@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260429151623.3899875-1-arnd@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260429151623.3899875-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0224.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA6PR04MB9446:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bdd4ce2-dba4-47a3-e4b0-08dea632827c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lrdHN82amsw9XkAf+D/B7s0i7Vz6wTNJid+clfgzjmMU/9mn1MAm8K9Iqsa1SWDEw3FJkqXJiUjPK1L/eKquJ9CovER+gx+Ru57H4XCbJYCwvHgO9LPBHTp7FVKk7ftpVmDqc11eNg1aD8vtfkOr8Rt5RlPa5hJtCScyapKmB2h6uZOQpKgYGF/zOBVZUL50GACCvjEbeYjKTDiRBrGZPPXtQjnfbHLLIJPTEQmdatoiZhoTWNJ5KWYI9y83ZO6P6KBuMR2j/JiUBxbltwGfRfnCuN/tjp8500DHYQZSst48wk3Nb50w+v+qIV32cbys7HWNLf0OmQyIYKn1SUaOhTtdP+rK8HbCohOb1DliOsqZmes0M8l5UhOTNd0gENFIbqP/w1WMC8zFvH3MkMdNzPPXHvLUD33vHgf94+binS2gaIkmZH0qqCb3Ad9pL6ou+tH39pvkx2R+mvb7bHaZYTUkuDPjJhDMKuMz+SYn49x5WE8jLuhSaYrtlkTpJkdOoYRU+vLcnlPJov/ofjLVlMdPIVs6B18ibdVlG4uOVzXcABWKTlQu5yuLds8dwWbUhtN96j6GyIb24ZTjFw5e+3yUu+xRr85YGvkgxEC8TBFvlSjH02f/PzE51RB/ES4lcY4C4CgyxNFK+nn54h8+4vS96YtRiaI6MRWuO0QdodJzV1/2Fqo0J3hh7TYS8GVnTgz1dF+PxZYqICsb0+LSvst0II71M9l8WYny8zzCRNI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDJTb2tJb1EvU2NLUy9jUEFOYmtRRGdrQXhvb29ZQ0hZbDJaMys3cnhrZFNW?=
 =?utf-8?B?UEt3STNKWnNBTTVkTUcyTXI0RmxCRXorWldsbGFJeXBITTNJR2tiRnVRZFBJ?=
 =?utf-8?B?U3pKT3NDVVNWM0lpaHNHbnViYkpaa2ZHR0ZmU0J4cjlPV3pDWWJzMHpmV25j?=
 =?utf-8?B?QUZka09vSCsyUElXZjdqZzFWVFNub1JrbU1lUXNwWTlxSUQzRjhrRzlUcUw5?=
 =?utf-8?B?RkRZU2F5dmJ0WURFcFdpbHd4b1pWakFZS05nb0UyMHVkM054WjVHNlQ1RldS?=
 =?utf-8?B?ZEdsU091NU5mUUF2ay95QXA2RVNDNkdZNUJqOG4xL2o5ZkkybitBRGJIWnZO?=
 =?utf-8?B?b3pTdE1paDZaekN4L3FPWXNyNmcva1RCL1hFanJnYXB2RGlCRjdiUjlqNGRX?=
 =?utf-8?B?Rk1Eam9TN0JxRVhPWS9ybVh0SHRVR0I4RDVhUFRaZTRFMy8wOWNLOW9Lak54?=
 =?utf-8?B?MFcyNlByTng1K014YjhOa3JiOGI4WjlNZ3pIZFB5TjZoMlFzRFlnOFRTeHdl?=
 =?utf-8?B?MGxDYlV2VGtKSlBPN2RlbUtIVS9YVjV5dnRwS2hTdDRVN0ZYODhJSUptZEx2?=
 =?utf-8?B?SE1kS0lsWUdORjArY2JDbGVrOUxjd0FKUC85NVdkZWtWVlJieHdUUmxxRGJH?=
 =?utf-8?B?RXNOWlY0c1FXdUdnUnZCVUM5MlF3WWRMR0F3RHEvMUVyV3g1c1VSVzI3Mmtk?=
 =?utf-8?B?dUJ2eHdsL0ZJWjdtL2NuTjFMWEJTcEtjY1BxZ0RRZitKU3VRZitHQTJORk5R?=
 =?utf-8?B?anV4cTc3TkpGdW5IeVZuOTdTWHhCdU1zZ0NRMkthVWs2KzJEaXJiRkRLemVj?=
 =?utf-8?B?L21WZzJSWStoMU96SWwxTjEvc0pkdjJ4UzkxNkV4NGRlSzdYbU9QNWRzb3Vl?=
 =?utf-8?B?MFB0WTRTR1NaMy9PNWwyWDlaWm9hV25Gc1NnbVZzUnFjeXVuNHVBNTEyc1BM?=
 =?utf-8?B?QVRJaFNXRnBXY01VUW9nRVV4UGllaGUyRmpYYWo3REMrZHc0QXBWV1dadFZt?=
 =?utf-8?B?Ri9ZWDZiNERzNytMV3E2Ty9haXd0QzArU1hBM2prTWcvcWhVbUtUNzZGZjNF?=
 =?utf-8?B?cWlWQ2Z4ajNDTUx6MWU4YzVGQUxaMmVESEphYjFDUUxQb0RENHE2MVRTYWpU?=
 =?utf-8?B?aDY4STdsVWpkbVJ1U29IdTRmNEhWUzZLRGlKcERBeHR2VGYyRVltMVIyUzFX?=
 =?utf-8?B?SGJvdlJXN1V2WHBTN202cVNpWUt3YkR6K21mVWtjd251cE9GaExYTE9YQmE2?=
 =?utf-8?B?WEVuZ2xFZHRZSzI5ZFdhNkFLa0kxc01NNHNoTnhhWHNpQmNZT0lvK2NqbmFq?=
 =?utf-8?B?U1hHc3N2TWxGUktTWklsVWhjaEdpczNMa2ZKNjdGQlM5Q21yREIyamkzRENK?=
 =?utf-8?B?SWxkNC9vc1RkaHF6a1AvZWNORHlQeXlLbFpGekRlTUs1SHVhQ0NybEdkZ01a?=
 =?utf-8?B?MnNJZkdiZTdGS0wwdUVpZW9Tb3JXMWg3dnJvSThNMVpxS0ROQkRySldsdDBO?=
 =?utf-8?B?WE4ycXREWTRRMjV5N3JzeDI1aElWa0pjZmlsaGZESHZMQ1NkR1dMeVFWbEE5?=
 =?utf-8?B?MGV4Y2ZucGVsSmJla3hvZ29iUEwzcWVMRWJuUXppelNYTnRBaUJxWUlRTFJ5?=
 =?utf-8?B?OG1lY1RWd0d5N1UrbDF2VkxLMERWY3czbm54Z2VsQ29LZklUNDZ3SXFVNG5y?=
 =?utf-8?B?M0xYekVIR0NrUGQ4VnI3azlXZjlSV0w3M1UrTnVaaElXanFvS3dvUnRHTXQy?=
 =?utf-8?B?Vlpjb1FTYzhvR3g0VlNhOFAxOVJ5RDBVeE5YYnBkSWpmeDFtTXMzMHhaN1Rv?=
 =?utf-8?B?c2piVmkwRHEwMFZEZkhDcjRJRDB3OG9KNVlXYjZXMGNCdGJkOEJ2dGY0bC9C?=
 =?utf-8?B?V0swc2F4bk5aMnNmSmNjVzJLd01zSVQxTlRjam9aMExBS3NwNUJjUlg4VGlU?=
 =?utf-8?B?L3NqN0pXUmlZK3FGaFBYMDdWTWt3TTRxR09iNytrdWhsdHEvc3Y4bHA4Vktt?=
 =?utf-8?B?WE9PTmQ3ZnF4c2x6LzR6TE1HbXRMbUNXQ25XdlJUSlF4cnlzeU5OdUVKVllp?=
 =?utf-8?B?MFVoYjhnamRpVitoaDcxbVQ3LzNGMnM0Snp1MlVYTWpTNklmVWhid3FBYUZJ?=
 =?utf-8?B?M3JUa0VGQmNwMUNDV1Z0VmFFY1lmMWVHcS9OYTh1WlNPdnVmcFZkZ1p6bW5s?=
 =?utf-8?B?N3Jmc2NnUUM0S0p0cGFwbE1rd05iUEF1ZVVkM2g2dVBSUGlrSmVZU1hNN3NM?=
 =?utf-8?B?MDlNclI3YjQ3M1c3NGdqMWdDMFRXSlFlUE9NL1Y5MnBWZXA4WVc0clR1S2N1?=
 =?utf-8?B?eXd4NGhXNksvSmpzTUpSd0lHODBlcjVCMWoxSE1PS0xIS1loaXhqWUxKY0hY?=
 =?utf-8?Q?SpCjT2QE3si3zwpg=3D?=
X-Exchange-RoutingPolicyChecked:
	FD9vFjxnX/c5+iYYKYpIZpYagSdZ/QKuNhRdGdorS+AxsbFdSbfZco6CtWN+ChLOr8pUDmQ5evzxwqH7/fuu0UTe2Z4nkYXNH5hJkrIL+/jeYEWJEQy+Jr4Secisjtxvg1poguhL3FDbyn5IzCuP2V9hF4OgT5YJl1xXT8iWUR0f7m9aiVO7bYfTS27G/v33wIEf6d77FybB3imS0ks2toUqIVtgbFG/Cjr1nb1cvVV6YHpl2JAVQQn7NVXW25HVg84ZGu8Kcg9XvORC/zEUZDDADKbMgPE5QGY8vOOO/DUKEwsaJKi3RPW1g55qgp04FmJfSLwhb/n60fVcHhSQWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pymgCvaIWnWJ4D5w+QsyAf71lSuibwzD2VReAbuchOPKftWMAEpZhpttHD5giaz0jOiRkJ7zfwe2Y+Hza6WWetOUDorDRdfhH+eoKioqqvAhGy7uxJCAfBm0pyW2Qq2lwZXGMJLwsuiacwGSA+3IR6w1pksreuBVv5oWJZxBURgPFwlFmkBQKDGe+rc+CiHmAhWuNHRMadU7ONtTaVasj6SUNnu6sBYTzPtmQhL78naG0AKoDngHYhkR3vgA6UoYqxHY6RMSvVsLBNhvnL6yZQBYNWP8RhtZ1B3yX6dRkMHnBLJHF/4AlgYdHW3m5gt+X9DMnPrM2dK9rlre6w/kHeDl8cw1s/2bLhjsv66hAau5MllXlqs2MKO28BXIp5dMnl3oJQFUorlNkUawcwRlJeCNbys3jtuB1e73XRiXgKE2pmZv0L6uX7BUR6dF6JO21CzDk/dYTOcpETP4rSz1v8FiIZEPIOGLj7X0Fowis317E7AowbMctrhJxNwIR1+PnHByqariqqSPMBnxePicllXzXCIfivrViTtjbtJ65TWqNIQcklrmJjliAdQAkN2byNIqsbL/Ii1OJDTPhRjp8Qu2vJrHh07NbWGb/KC8EuseoV94wLzCx+1gMTFAa+NV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bdd4ce2-dba4-47a3-e4b0-08dea632827c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 21:01:40.3647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VupIh1Otg6ShXFC5CrGcq5s2/rGPR9IgLYEm2fL4pl5x/XjPL26H/ua0piB2Lng7eXTePrYCome0d3ry38FuCYkVpQxDabBExqt/w6QzuKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9446

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

