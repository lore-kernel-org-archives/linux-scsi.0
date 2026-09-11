Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A18D1E51E0;
	Fri, 11 Sep 2026 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138738; cv=fail; b=tJlxZRRhX/mVeYSG+hToKSUwBKwpenVkJZKg8SzmlrJRUbmc00qwfkt8OyOOagJLEZXlT+mOernEF31cnNWUsV1VKCYCZ4/OJYCdYAQ9wgx0C+V/RZIgA5NQmQKC8dNyOo+TpnDjLgSRCF7rPPHOcWdgW56Obm6iwoQ7XhNRnf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138738; c=relaxed/simple;
	bh=bbucAVbI/DmCzNML7Jh5+2fsBMcRMWVbCPoQAynzCMI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S49dOqDAXWbbUZVcg102pdooJUfTRFi/eyCsH5uMsEcdT5vbj6GjSpTHpH2wTLpWKGbrbdEhj6mnZyTwWBev1en0BFOM00fdc63XaaV6909gi5eZJuBSj6zKQkSsQqeTn2DIbzyc0fxo0Jem1wmcwZ4g62hWD2J0rs4KMl4p+mA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F9j+uyek; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=a9kHzXpg; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F9j+uyek";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="a9kHzXpg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789138735; x=1820674735;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bbucAVbI/DmCzNML7Jh5+2fsBMcRMWVbCPoQAynzCMI=;
  b=F9j+uyekPDoelVWBNNq3wtbsxS3igVz8c+R/57N2lRag8VnIbwDkskU9
   QMziuQpaU4hfgIOl0cLBzkJdtPsMq/LZu6IyNAgcX5Dqc6+S/s6k2oFkz
   3EGOFdrhA/EkqqDpWH1IKpDz1ZI/dhvNvPaDez13pWJgs/eaLj8tzrL9i
   cg0woIXxU1LLBAh9i2F0tmx+O5uuuLLE5Yl3xbJVgTkZg+Y/1DMgHo2EF
   mSAl9YfGW7rjTIzhtqS9zCl5LEtu03z/KPUL0pdM7REy7/6Wz8V840wFe
   HFg2Ha6vGO1KO5+lpDivpbYChFSoWwQLph5Uj+ICWZ8onUz/9Zaxezj3Q
   Q==;
X-CSE-ConnectionGUID: mRo1503MTNmi6PSAF//mAA==
X-CSE-MsgGUID: oMX7FxjhR+y0roA4XMNbjQ==
X-IronPort-AV: E=Sophos;i="6.27,97,1786982400"; 
   d="scan'208";a="156381440"
Received: from mail-southcentralusazon11011015.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Sep 2026 22:58:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCwxeGqAyTxhXpbUTt6uvO9XiHRid9mBY3EC4I3z8psSTMLtzk1zQV6f/zipB2xPGUAlj5uiktnwa89RlB4+86C3FBv67bmWidalmAQlcD0aeafGn/8+/b+aJQY6q088Y2LGnekVdJcqaWUqExZgwhlBdJj/zG+ooocOtV8rIJoa8PjPuhZ0UrZ6u2XrotuFZn0yUwHP/mhIrKkAhl9zACD6Hfi6ZeGLItsLKmRw5YUI/cNpiOkFVb6oj0PwU2ZxeU6ymaPAxjYgS0F3b/MHtOjhb0o3g471HeDBX3p3O5m4Cfo/3u+FwoAqWO8+fX968+C/Ltfpjr3KV8YmL50O9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbucAVbI/DmCzNML7Jh5+2fsBMcRMWVbCPoQAynzCMI=;
 b=ITAI8NmdXVVoD+48cq1/t2W21PvWhQbIl3To3vExIigCpXJqtW3k2kwNtWGuEhtTmWAe4xFtDWEw+cYJK8w5DBuuRqXW7BIZTjqucTLXz7t6glsz1FW95HPS/zswiJFTtSVGasbBhTEYVlWBOQvOpUs7pEB7yhs3Npjne3qJQQUzm16ysDCNHOoAqSf6kKa8KzSEcu2WPT+fHU4KvS2pkKA2hbtkYyE9owIiVuOpyEGz+L8AaIRih50SpHPvt5Mhmb/V3ivVL4xwbCu6U/2QJ4aWL8preiE+KzRW0g3EpKd++68gn6HzREKU+kF5OxbmyVeyibW8AKc1f5k+yPJSVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbucAVbI/DmCzNML7Jh5+2fsBMcRMWVbCPoQAynzCMI=;
 b=a9kHzXpg6FjWQ78Co/NJ6IRTcVaNgEqhGWELsAjcJTZBz7Bf7MCmaXRXtHfByAdlptbb5HcoXifOc2vzspeBIBOPfPP4Atp4qYzare5PhcWlvZQPVToLUUcrwJZIUO0A+6zLy4M1B/1y3nQ8YMyHZzDKIdJRezav/o1LJwCAksk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB994181.namprd04.prod.outlook.com (2603:10b6:408:41d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 14:58:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:58:44 +0000
Message-ID: <94c0f28b-ec9a-4c1e-a23f-af49eeb7fd0c@wdc.com>
Date: Fri, 11 Sep 2026 16:58:40 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] block/scsi: fix zones_cond out-of-bounds write on
 zone report
To: ZHOU Jiaxiang <26066541r@connect.polyu.hk>,
 Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
References: <20260911144614.39553-1-26066541r@connect.polyu.hk>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260911144614.39553-1-26066541r@connect.polyu.hk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0048.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::15) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB994181:EE_
X-MS-Office365-Filtering-Correlation-Id: 3928ceb3-0b82-4d35-13e8-08df10152cbc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|19092799006|1800799024|23010399003|366016|56012099006|10067099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	MDe6H6K4ofvFc2BmpVz0ZFP6xEgGQQLn5jgUsHBL3xqEeeYlFpEqoK39KXVvrPeIK2oGolRGyqXHcjRQvnXlUiiQyin+9Z86gDrqmscxAG0YCQta0tLDv06aflWzGFxQd0zQu6kw2fDSNfdiv8TVlr8i+cMf46WNP0weReAAFWdzRYTjBWe8Lf3ZX1I5Ty8t1rni9bjHFXkfc72HIXbnNbaZhZqigp1WJDIt4XmE+9BtNUlnDuH5dh4XGfjLNl7jlbxwYBjfj2sgiUiccjIVWHVrHtYZOE/HCs1RKbFuGUrUZiRLzE4/Dh41nnEDwAS7gN92Q06YSBZiYQgWhBkbqaH2mH6tYWABdf5Kr/bv3lTfv5cVxJjospxTo+XyAfYGj0mbTHDg6PMSL6GW6w6lC/4OKZH1k3q24i+vnEkpZfIU3K8BbCvpF+eDGApi6go1ZphWvY+3mtZ0rHbCx5CKeyFO3tqspoE4uWxNlevLkdMKLdigDPCDVrexuqft6VDiVOBAwAf+VbqscSIh9qNmrcC4uiBInxZpqJw4ko9fH5zjpa7rbVHoc4ecsYL/HR16N7VqmzZFycbYNRzbZomndpnoq52FrkihwR05tsBM5cR07u2IRt61f6w0A0IstwGML6EFW5rUwIihclxSvAZba6GGliMX4w4YFOKIQ/+vfoE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(19092799006)(1800799024)(23010399003)(366016)(56012099006)(10067099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzY2Z0w3OFJzRGptZ3FxamFmU3pDVGRUN2hKdVErSjVKYm9mbUVFQm1WZ1Qy?=
 =?utf-8?B?V1NOUHRzWlA1MUE1QkNlRmUzZ1J2MjdFcm9ybC9xZldTMnM5eFJWY1FOclQ3?=
 =?utf-8?B?Y0pGRFZ5Z0lWNzlPUnJtUldreHNHa3Y2VEc5c0NJSllRb0RlcHpGM0h0cStK?=
 =?utf-8?B?VTRmUFgvWTFTNGtMMjE0R211Tkl6eWlLVXhReVM3cnA1QkwyYitRRzZleVRi?=
 =?utf-8?B?M1E0M0VWVzZ2S05FTysraHRwaE5Kd3N2TzRRSFZudnk2TDdQclFSZGlCR21p?=
 =?utf-8?B?dm1HelpadDc3amNYUDBROTAwT0xWbTdNU1l1c05jRkhNQWw5eHZNdCtINlBN?=
 =?utf-8?B?ZDlhNXI2eVM5ZWUyNFV6QURwbzJudDVCK1JGMVNuWTVJZDhBOEpzL05qNWhT?=
 =?utf-8?B?bThqOHVOd3FING4vVXJWY0tGeGJQdlJKOUVHeituSnVhZ08vcnVyMEpmdC9Y?=
 =?utf-8?B?OW1MUStvZVowVmd1aWxYdjQ3NVZnTXhXQVZlZWRHSUtNYUZkcDROaDBNY2lm?=
 =?utf-8?B?czRXemkvSnA4bksxcW9ZMVRobXlaM0FIVzhHekNMaVk0cDBkMW00aEI1cis5?=
 =?utf-8?B?dTY5N3cxTVliSXJsTVp0bWNjb2NMd0M0UG00amdESVhENWRnWDBiOUQycEhY?=
 =?utf-8?B?U0ttQlZTb0k5K0hWVEhvTkxEYzkxdExmWVNnUkJoYXZkNE9xZ0tvQWRRY1BV?=
 =?utf-8?B?N1N4ZzBoT1JlRi93bzFKT2toMjVsWVczVjNCSm94QWdRTjdMNEtwbjdHU1NL?=
 =?utf-8?B?WFJKbGw3Y1VPTy9saDEwNVIyMWdmdUsvbnA5eVNEVHBNQUZzOHg0WTdrWERy?=
 =?utf-8?B?cUo2aUFFVCt6cUlPZXpna3RJVFNHRjA5OHRNVWpNNGxRdW82cTFUZGVJc09E?=
 =?utf-8?B?SlNMdmllUXYxVGszUkxrRVQrRHBROENtcmR2TWlPd2lpU3RiWHZpYmhhSlBn?=
 =?utf-8?B?NFJkWmNaV2F3NmlJeHlQaXdIK0dyMURiRjRLUkhwL2laRkpyUVdIeVFBMEQv?=
 =?utf-8?B?eU1KekJYRy9KRzZiL2NtSU1vMVIzOWlaMVRDVVpaQVdxeWU4dWQ2Wmp3Vmdv?=
 =?utf-8?B?WkNCbllqZVd2UXNXL1BtS1BXRGNmV3dqMVZXZ1Q5ZVhlNXJWclZlaVN6UFVY?=
 =?utf-8?B?eU1tejRPTXpmNUYyNXhpYW13QU5kR1UvZ3V5SXdVWFZ2OVpISW9Ka1FXOXB4?=
 =?utf-8?B?OFpCK29PZysrTTM1UFZVc2NnNGdyVkk4aEhpbCtJNUpFL2g2M3EwRUZNRzZR?=
 =?utf-8?B?U3pzTWdmSUgxUkhRNk1xNTZmd0RVNWNhMExldmtER25KMGlxaDlqVVVUS1Nz?=
 =?utf-8?B?aTRqWEhuWkQrVGFpTTJCWDFQRkRNVjM5cndPdkZ5eUpYU1Q2NVhBNWV1T3Fq?=
 =?utf-8?B?c25zUVozUm13VHNxYTFiaFF4RmR4SGdpOGJUQldJY1pqZ1V0MEJnQ2ZWbmtH?=
 =?utf-8?B?aDRnUTYvbkdtQUFMWEc1VXpUbHFWYmFSVHRpcFBSV2V4NEM4ZzMzYWVNZ2ZS?=
 =?utf-8?B?WmVXN3hCRlRTYXJjMzRQd1k3QjRnVlpyZk53OTlsQWJST1c5WUloV01WSWll?=
 =?utf-8?B?b0Npbjl4SVZySTkrOUx5d0s5VTBRV0t4TXlJODBWSWxiV3VteHI1Y0o1My9L?=
 =?utf-8?B?dTlNVkZ3aWRvZmxnSC9KZDVsdytQQU91MldEcDI1TWtnN1pyYXY4NU5IZDBk?=
 =?utf-8?B?RHBOMndIQW5vMU5Jcng5RXBlNFF0b2JwV1lTQko4RmIrNHJ6ZjZPb21vR1JS?=
 =?utf-8?B?MjRFTTFaYVdCZG44K0VNZC9YSnNxOVBxL1Rjb1J2QjNsM3JSdDlGejRqaTlV?=
 =?utf-8?B?VUNzVUIwSFJQQlFua1ZjNUtpbGJNUTd3UG9CZlhEbDlDdEtvS1h5VzBFU0dK?=
 =?utf-8?B?ZE1ONUdoUi9YR2I1ZjNubWJlSDBCeUw1V0pEcndlOW4wcFhlalYvMHRJN3NH?=
 =?utf-8?B?YXhSR0ZjTVc5WXFoNWtuWjZkSlB5MGthbVBZM2lHa0FLTlhKS0VkUHByNTk0?=
 =?utf-8?B?TEpIN29uVmxEaUxranJNT1FPdXVodHNiVjNMZ3BzRmVOcG1DRGNFcTBSYzVJ?=
 =?utf-8?B?SVZ2ODNMakJsR0xmN0hHaE1LR2FodzhSeFR2QmRvdTJGTTJERDJUSDFRdFJp?=
 =?utf-8?B?b2V3VVhSb092bjVYaGZHVktSbWpzNjA1S0UzVWQ1YUttOFFsc2hIMHlSREE4?=
 =?utf-8?B?TDdzRXpJRTJDMVlnV3ZVaVVwbk5KekxkanN6ZGY3SVB1cWpoVitGQlBHaFBu?=
 =?utf-8?B?WG9BME5laHVUaEZjMHVDdFBueU9kc0RFUWRBdnVVKzBPalVyRkdIOXBCSkR2?=
 =?utf-8?B?YWdXRC9lRGdNMExvMmE3NHpGTHNxQ0tCaEQ2NGEwRndHVGdGamRGY3NRa3Rz?=
 =?utf-8?Q?vX+Q9PY34sz3sTjsqqj7xFwoUMfJ76uMdb6KBAVBaMSVH?=
X-MS-Exchange-AntiSpam-MessageData-1: HF34Ge6aokOj4zALBTKpcDoO6p8fSQ0yMmM=
X-Exchange-RoutingPolicyChecked:
	BFUoOazrx4anROWv+9nSfTRxEbuHyCu0/j4MJgegFsV/0Xl2knl/eHW9n0qama7g78MR2Xyz7OK9c1vk1W/onsYmj6GPwSCBmyFvQwgKK+8+GmFf0sfBSf31jRtSsEiOlJSxZr/Fa57ytGwFTxhmaUzf8rYx4QvAgdHtu8XA/zETBzMaDIYjTvTvjVGiafPrFRqFrGdB8MCBhoVtDa1/vFTYI5McYlZJT7G8BqDEd/sGMm0Hf7mA5rg44FLX9a6ejEuuMlctFkCEcVlwKfmGzGURG1bApPi7PkG3oExWCrL3SzdzN2KodM0uFFmJWiqWXM/dd23WB1XSKXntPwYGgw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BRqrwWVIWTS/Y5PoEHwtCUmozPxIl274GF5F8mbKUBPAFNiWpEUpkAHg0f8jbmqlFmX2eo4eOneqFRhzCmM/IL+g1nTaFYeGHdF+sSOOA0o4sxOpw94SITYbHBtCAPhzKaPpx/BbBPx35hmLYNAH9LxLdQOkBly2XL61agTg5l+AZXScFi5HALh3GJYwrNADQmoEATRbQ2ydiymUco8zknO8VQbTP8k/C9nmw0OKcvSMYk0xqdB+g4PaoZxWLRcc7IUaAVEZ+moyJkeuOaVePNCtjAw1ti5hg5OYMVRIErKbNStOL9bwGHjZQXm9SjNpnR1avadIyLTZqTHDOTTjpdkWSL3NwSbq9sHP1j6gSFDUCeYpoDWtEVpWJHQRxSROHSDGxLV8kjLm+OxFnYUwL0L5f1Ff8JCTcz9watESQY9Fwd+2UU8ySw3gQW/gegAs+zwCNDrQFbLMtYMDaHWnQTKNvx/6RMBo0aVZFs8pZv19XSvBpXznfcnA80ddteT56l/+3V9l7pkVgAOhFU1gVwfN98hcVPoHfhWGrs+b5MK0Pf9QPcIvXldx9ywedKezNanLP9cZvHcdfmgbDIivTvJBThgTGyy68iGetkLyhRyMxyypGysZZWJx4ir3fgPk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3928ceb3-0b82-4d35-13e8-08df10152cbc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:58:44.1730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AjmT1HqMqsayWXuTtGio7yUnQ2eVXCxJyHumFiE3EhOB2EljHAMCjDbDyFCTp+sdh7KJghEIS12vin1V0n3hUzJ2ybLsAhbQOLtdUfTTb+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB994181

For the series,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
