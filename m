Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290741DA60D;
	Sat,  5 Sep 2026 06:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590498; cv=fail; b=eDRHsCblfOIxoHFoQuplMmlHsRmVvCy0yyKWA+PjyXhCDVWhu9U9WflXkmNtg2zj0rdfOjORlS8tWYjT/FbiUVW2tJbYhRPkSzN3mzBTj3WUHc9EHkz4+sgnQ4BDtltsApfKWgVcpiiB19l+0nBX4sk7CeirQkKnlVmp6kPHB3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590498; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RSEVrbUjvtHxYjWgNYTHVNl/REZzfmqjdcSrr2KkG9rxbqrNNeCmgo4NRh08qJnRby7ApE/7nJZ+aj29eOCr0FgwLMX79qVRNFXvoJy0Xhy+v7o92resuaZaIOkEjwFydXXprV2655+j3BfXdIJw9/O1xrxCllvrOwU2qGTFrOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=k7m9yiky; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UPkvZSLC; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k7m9yiky";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UPkvZSLC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788590497; x=1820126497;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=k7m9yikyBDEoqxnDJ8oqhMPN9FtaIplfVUqkSVGLFC2c3uN1Lvx+J9zQ
   zXZ2x5smyh1bs4Q09r0zal4o5M7N6xf35AhPdiRGsHLJgV5hm2YIbupUb
   8cToj0p5c7jYsd3Mc19NrCzyw3jZS48u9A/Jd1x/EjMCIiEeZXas9+hrz
   X8p5Uu9xqunkueGg9L6tH1ivhp+OYxZkn7D1FJKc1Wv0KnvdX2PqnyG2v
   X54GokLx92S+2inAdQmUgUVkV278p7fWmCTZQlqDbnhCq2O2OiCAcZ757
   vy30dBjLxdHb8b3znwfENAG8MoithG4dmaf+KpGn7uJiTGFfu/xFcROgb
   Q==;
X-CSE-ConnectionGUID: Hwp0UQmVSfOANOwBhQEiYA==
X-CSE-MsgGUID: Ar2gViT8TjqzwTs7s+DarQ==
X-IronPort-AV: E=Sophos;i="6.25,263,1779120000"; 
   d="scan'208";a="155004990"
Received: from mail-southcentralusazon11013058.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2026 14:41:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tVWQClJW2TI4PO/2EnFnKqOsvdDdHWxvFQXXic/0yN2GeRcinoIWEUGpbNyzfVwvL0u7597EIJEm936w28M8zryuFDPhCIqb+K6U4Zbb48frf5joFffKbwJ6YBl2YZ9Z65J/Q7u0QoU2TYhBcLfk48N89mobmQrIVwLes6SuEMRr2SXt2caiIybGSSkmqoAXYyqu4S355IQbqPA1mE1WEZNKf1MaM+XtNygtlApnoLSV4w7oqjWI0S5f4kTKHNkJMMPK5nmTx1QW/lly20aS7OMz7wzjoHqUZhIbwGBhNkuKJiHi9YucTdlDt4ia9VTtLj4YyAlks0zcxDpQRpocTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=YPtEqwFyzNMljfxdDkmkV8Uy+7BOUaDLBGhZJ1GJxs/ZZbxoLy+Y9rYFn54ymFU3109o85+Vb/ge8M4FlaJ+LGfrgN4cZkUO1aV2FAy1Kd8+Toml4olDC3JRO4g9VxmNV89Nf/ofWU2KVvwO4yEYaJe78QEV5Q7P4USkgYJthb3Qk+Rm3uDhwSNCUbnhrmzDUdHumJUL8l4G7kK578tb3NKT5+uV8gKPIfYl/RuDOu2CKuuKeePn+DiIk5egSkSw/orNVjEQQ1NngzAaEqQte6laEuAcOKncWPzhkZYtMXSsDBhPMv41upn0vZIvqV88c0jLSsSkGwkUjenUd98INw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=UPkvZSLCTfR90DvPYxuBKhEa1gsHyHA1CBZAcWSEBFRDD3CZNwaEk+RzDmnHRzbiyZ/kr52C2ef+OKvG6n/75Gj6zbav1Pb7Y/4F3W+C1aGLoyfQFWQ7TReB7tanR8uQD6Jxg++rajTMi7sdd/UPby7t8Ze1lSy6ZrZVdFX7Avo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DSVPR04MB9964.namprd04.prod.outlook.com (2603:10b6:8:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Sat, 5 Sep 2026
 06:41:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 06:41:34 +0000
Date: Sat, 5 Sep 2026 08:41:28 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v4 10/40] scsi: ses: use 16-bits defined sense codes
Message-ID: <apu5fZyMfWiuzlGc@mayhem.fritz.box>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905032224.509860-11-dlemoal@kernel.org>
X-ClientProxiedBy: FR3P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DSVPR04MB9964:EE_
X-MS-Office365-Filtering-Correlation-Id: 469be495-0d0a-468d-bc78-08df0b18ba2d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|19092799006|1800799024|376014|7416014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	lOSkPE2I+0t9+5jPorFahiQAIBg1YL6Qj/qmShdeJ05RMB9CpMa055MrtjsP+iNK2Xc3EymUgQETvIR4vykIjg+Tjv4wA0HiMCFoRnV/WJjiB5lLs8u2DzGZ3wlc0V6RnIUQkTPmz58wrJr1609+8aDxXVY5eZmVvQ4IU7JVcP7ztnzE9/KCsxT1DGvEYj4TGK6wDAVomDUpXFSc0yG3NP7/UF/viZQ4gbPcnjMwqUeCjp13isM48jzVarM45EcWWGhVkeSAPH849fC68G6o5+96oPlGiNia9pJZZeE1+KPK3RDj7mAa0HMimZEhvgU6eKWRUqzvfFYMwMt9gj+L/ns8yidv5CcaBmCItKZnTtTbqnpSO/wyQQOnEsF5txBmA2uTQXgJ/p1McWjSnfdJgWLO+wSTWMLIvYLnJqXFvyFWRQlmLCZjF2//lnIa9t+7mSR491XVMs1DsrB0feVGU9R8eJy7hE0+ocromoP5YbvdnroZ7PM7vKFzPvSoL2ECOTyIZ7/PqqudSXKqFb/ZMlCKqGJm+AG/Sp9m7ikPFIoMDH+kEqtWzq7vTKwClY8/7y0e4NfQq7Prf0OD65ITcDyBXax4OOhGaS9zegLpPLr3FigvuWdnqOwD5KjPckBmO4DwQYxY8o2WrsQJdWN3nTKy3wBpj1whiMQ09/RlB2E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(19092799006)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pDTTt+LN30/o0SWGq+M3lZte9sWZ5BpYidia9N7vlvvK+TQS+n5/Xf3/zFkm?=
 =?us-ascii?Q?YmhECjbPMosc1n44wv+wvbMWfmFJqLRaAoaODLghEYshUZDoklVV8rgWLo/O?=
 =?us-ascii?Q?vZxsXs8XJMI9Q0Oz+LIWwmdF3PAytN494E0esjpHiJgLSIURuDk0SKC/YDBy?=
 =?us-ascii?Q?+vV+I4bGYYpVSdZHRZ7fgsN8Iv3aBfDJ/R2yyJIFstr08+YpDpxzHIFWD2El?=
 =?us-ascii?Q?bFCN6slXRKgUhh34NyA1D0hEzEChz0fFMUjTKlonKCA/C7SnCa1hYLVC/nRD?=
 =?us-ascii?Q?zBoqiB767dFRfO7kb2fzG2OREoZy06xdlPwTDYYFzPEb3elVlbeTTP365UYb?=
 =?us-ascii?Q?vUveutl3Ey87GjJmLCPBR3gTxGVpR38LAypyjibInsCVeXIaPSkimbx5k14Q?=
 =?us-ascii?Q?VyLr4rLqB0Wb6Lr7GRODGQxu5gupEnioJRCFvky9dh4CW8AT1YzxrdtNeCcg?=
 =?us-ascii?Q?tXtjK/BUBXC97xxDcsD6vUsJGnkEnm62MLomkfID7azWJ4/xxtmsnGvePpHD?=
 =?us-ascii?Q?WDdDHpeDdSIs+/znlQwSMM5OXczjpcsuiIzKO0HUDWEUNG1gQ+K+vr5LRp8e?=
 =?us-ascii?Q?OS8YYgexxogghcN4tD/pANoHToXY6dEtJ4VJi3vUuiLKJdx0F4S/ufCZwQ32?=
 =?us-ascii?Q?VCH37YF5BI0ihsDVMZU6RjmVfUo2RadXQMoiDctWCE/uTnrpuQ1sc7k2HyMy?=
 =?us-ascii?Q?XzqQClDsXCQm7CJkkOACX0dFQX8jG3C0bhYDIhOJu2X+NrC0goUTaQa4jEox?=
 =?us-ascii?Q?YX5lcjpSu9NNVa/9BBABNS1DW58xvhh30rtRKTIAUok0OCCHBcdi620z7i4I?=
 =?us-ascii?Q?u4INIX4kYj3V0NNB59P3Yj+P13hbpI7jWJAkrnwcp7V/UdaaOMEwSct6eAi+?=
 =?us-ascii?Q?OvcIuwbjEevaFSWhODfBSyiPSDuF5YAhqQkcpNwrF/OV9Rr0FauLLt3E8EIA?=
 =?us-ascii?Q?bsAJSO/3VmQtJGlXqoDNOzh/qTppvPDzwyAwZQmnrovyw3bTcC7K57Aom1/4?=
 =?us-ascii?Q?VgKOwqn6v5732l167BgTj/HBBuAFmOn/3FGxDl3eH+F6CdKVcaImlRu/bLrV?=
 =?us-ascii?Q?ZEugtgg9i0O4XhQZaJuuXJ6RiTaONoo2gnbpOSJ6YE9vfCZQJaMb9ZmhF5ab?=
 =?us-ascii?Q?/C6kGFcYUYXGx6Oljyl5hSEgR0ylY4BXKiwSrYaAPMXXpTSL2aSpNSkrR1xd?=
 =?us-ascii?Q?RkJbsBQi64ym3mrRbq73gJjqC/gJ/NacZHLGQo5K5zN/AJYiX5bZjTvAf3VL?=
 =?us-ascii?Q?MXUtyVai29F1BjYhr5lzpMrvH5wuuQP85jbwfNvluXl0Ew1DCZgvzH082hSx?=
 =?us-ascii?Q?UIgVXwlx31wCSjAJi0eyVmiUgY53EIhxlcQR88wn5AbB4T9OSWJjHJZLxNH7?=
 =?us-ascii?Q?p991xvcAB6yhO76ZNvORBgV9EF6n00uU/nOeJcWeZ6dOfFVvmr5gHpTuBAtu?=
 =?us-ascii?Q?kkf4CGRbTqhSAOD7tWv55qlT/XuQt6WMDWeNIK96JZH8MePJbsgpY3hBjQvV?=
 =?us-ascii?Q?qnKJoZhGD37YkZyWOKGBHrlA16l07eO+Fu9ZStMpN2SlusMlb2NH8hGkIgpl?=
 =?us-ascii?Q?XBrSORwoXVsJnN7BCV0nBi0Dm99J617H+rkXiE1+wqL9KwZwgFd//+XYPFEp?=
 =?us-ascii?Q?1h7v7oPcDkaQMBCM7qe4dusUCc6KOfX7Fw7cLRK5QfsmVUkaAx5dZoiqYUOa?=
 =?us-ascii?Q?xF8plc6WkO5YIC6Ha9yGraOmUJq0xeNOqKTemgYtX60pbxAMtBltTgReMUEi?=
 =?us-ascii?Q?BH32HLkguO5QJodEZJdWHOGrgbuu8wN95+3MtPl/qURoIvwe0a1u7FFZnqra?=
X-MS-Exchange-AntiSpam-MessageData-1: 5U/gRcDf5AMpbIINC6HJOrxdamGsmOCuZAU=
X-Exchange-RoutingPolicyChecked:
	kCHK2SeTVQlQYCJcqmiV/7UGnp5uXiOoUnAmLhcVfLDM2nd2k0yrjhV+ZQFjq8T4RlX1kPqI7EzbjsjtxNx0wPeDE9nY3Se4yNct8UsFLh/ZQ2FLnQn7KmogDp8zboVZVv7YkSJJl/5zu5t6OhFo5C/dldjXv95L0fIBjGxeprkPr9vZ/nnqtHqZ1SqvZeKoHSTmYZTznbbbzvgEorlPPNr9xhSK4pRMVnIYzJy6Y6l8ptrXpTzZXOx50OtKP1XozGN1V0mgDeQCiZvZpF8mycGOPmxon2T9q46B6hjP13Mo/bbYeROpXkJtEQF+3vx6cHx59Um6MggVk6zUpZt6+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NvvGab6SeURRQqqVSJotXw5Z5dfWF8ycHYhJFJYQ27Qsd7UxhzzkNlI31gL5SJVjfk89huupUIiM2eul3beFS5N6sc9/tvIhl3eX7kykgyYbijj5sPK9VvGjG9H0NulHZMAg6gpWFhWwL1ft/JronB7tgeIS6rSdDeIWdFZVlfD+XOO+xL5XY5DZQUfK7+jtUX6UWO7FywlpLNVqVZE/mDiRmV8BTKa/+M1g3NB+Jty9S+ESiLahtKSez5U14Vsu6gWIcHSFw9nD/agCCLlrWzKjtGhIpJKfr8r+Gn42yzc/wgvcRdx88lR+LHgtCwTRm0R0HSs2mTNwDLTQsLnspICXaQis8o7CEuG7w6r/sGkGTJ26B3O3ueCrLJJEPy3R9dfP9mfXOOlMfaxLMYd5dqmULDd6hEz0JHfgLQRzVPb4MGLEv6BxD2Wmcely4SjGViUNxyouzFbKi+a0TyGTq5LSGVI0RmDcMs577+9HrnPjs02mGr/R77MlhqQhPi/bt3D/HYvN4caWz8/ZYvdUAAyLfBk83o0HhIbpk28QaqUblWFPFqJgnbQdxeZYzY/qGk4GalawTbnUVt/+Ye1rNcSALtbHY53mtxv5kO5TAoQRMgZh05F7KbQeiWmdl9yY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469be495-0d0a-468d-bc78-08df0b18ba2d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 06:41:34.1255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIiwMCmSdHaxerfmXxg+bVqFaChHwemqvB3XGUQ+fdPZRBzLCP8YemTEGjT8e6j+i+kUK8CdNb9raLiQ1wBw0VW06m7WoC6z6YWFWcAhLOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB9964

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
