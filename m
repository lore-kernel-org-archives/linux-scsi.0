Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA9549C4C8;
	Thu,  3 Sep 2026 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438965; cv=fail; b=Jd/EZRM4YdWNt7VbtSfYTZh0/wpYZ7WbvM+3fdReLDz7i3Fua7YaflO6LMS+gHHQQs/Ldq7BMHEsDKywBghL9+Ll1roIRnjxz/uGn3/JFKFwWViOyYhFp7PAcj55/81bZ9b0lqrHBTsfnqaMEFyldeWTegzmSODjs+6QlmF6j3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438965; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Oub3AnZGKF8EI2iuEWorrjbJckPZ0XwAFZt0iC+V7WnPX5R+sWTjDPZNQvL8ykPMj158Lok70n0wUzV/MNCpuVJTFj+zgqlwUBeUFrdoaWun1CYG5ziw5mX6h5yx3ul0r97IFzmw8e6VJ1sBrWU3iJdGbf3FqJ2KW3QYECdl+Zs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GQ25DibP; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QgYqAVac; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GQ25DibP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QgYqAVac"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788438968; x=1819974968;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=GQ25DibPs7U7CbbVzFgHITbpzxU9mGoMtHudgHUuaF1zhE8PWBYuOn1+
   0qvIyYBJ60Qr+MN5MAY/W+sZv2UjU/3XJjvTz84+qzP67pCoOxbfcqsVN
   7cT/l6q4CmHN2pCfG/lMRt3oK+TVzpEYjkcHCp6Njm+NYai0/uwIX2YrY
   TWr+S44useEVZvFmpEW/I/aYeQVKMEaqM54bl1a2RS9AXhLLwPYjHZyFQ
   pvwnFxZhPMvqQd5MGr8xAt/TiQ8SM1jxDa7KuW62QTjMV/NMF9dnFKRbo
   ZvlsJ91F1zQPuHLiR3yYf8zxi/u5G1Cp7NnYsPy1BVZvSJyCipv9Exn1O
   g==;
X-CSE-ConnectionGUID: NuxEoElcTlueR7jH8xlaZw==
X-CSE-MsgGUID: +Q/U4e96REeK80upn1YlCg==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="155795274"
Received: from mail-westcentralusazon11010054.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Sep 2026 20:36:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sP5VuJiOFowATdvXznDIa4fr/7oJzxoCjstiqh03SveIrnfb7We2EAsxAOy7bQvqqXzEFOyyk2KgMfx4IZ3P9dzyvP8hgtS0kBuhSfSFQnKfOAKHTyGgHMeuNxXybvnMN3lap43+wcdAOLc7eyrIYwFpeMZOJLlMjMFiqNkeZvwbmh18Lg8ekDn1oG/ibRz1rEgQDx3xoINOG0zZ37M0REjYwkEKZ5cYnlyEk8xmAS3dVMHC1ZtmRoWX0eb8QMIADmT0hM7S90v32WsMQCEN6kUxiOG3q6Iw/618C2bIKwjq841EzBFco5kBZdLzg5DL8dJj1ZS+/i5ZPvuwAZG4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=JNMZxNA8i2T1Jj8i3oGSgUKC9g4tmsyGGrXyUCUPVnwqOyQJcguo0RmunS1w0w/pGP3ztyAM7lFbXkJPTmpHAJQtrYqM1h0PzZ5VPl758zoeF7u1G6lrIHhAnQIymVsadmsmVuipPexNRJlDY26A1K7Png9zjHGHctOmEuB0qqVpNCoIwaGqvRs/tuEZD34jRo00i/4Sg0rUuKw4+aFKyj35oUiE9pyqO9sl5yL+lrnKZ7cepQeq1l7Yln12pKpOowZmJRTIzC0xUtLXBjbF8EMAEGX/2Xt0f77PCFsdiX0zDha436C/K8p1qyIFN/GOjmriZ5iYH6CWVx21+NC9hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=QgYqAVacLEEz9eGoUTnS/DnVt6sImTxkwj9zACv8w3ewQueKkmsZxZwGl7AQw7v2F404ABA56un84o0dgZo/Y6qDUpXqoG2tFIPl75zhvMSMm/5hKsnqyYOR9Cij0bMtXnSuvJgLn3i0lZVa2eLx+MAPP8PFAVk2SLPZsg3G8gE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7656.namprd04.prod.outlook.com (2603:10b6:510:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 12:35:55 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 12:35:55 +0000
Message-ID: <047678f2-3d11-4d29-adbe-4eb251300488@wdc.com>
Date: Thu, 3 Sep 2026 14:35:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/40] scsi: constants: use defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-3-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260903034201.112211-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0238.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7656:EE_
X-MS-Office365-Filtering-Correlation-Id: fb19ed5b-699d-4a57-8150-08df09b7e5a8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|7416014|19092799006|23010399003|366016|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	/YogmlMcFN04pThqjeDUkiV/TQJv1kfUT6KIoo/BeD++sKj19QdbbqNoQs7Qmx6BTXpwD4exoWSpzKo6eFTNFGzJ7t+xruPpg8xR418HbdYgETLDMYsOCLsGR/zE5XjSoUWnVFL2sr1Vu00zrQ+dwqnNGRp3wJS0bJZXnydTlBM9lBJSHOhupxZEgIQrm1QF74/6UYbKmmBH5Lr6CN4G2QbOvysb8M2WtCCfffE2z8IgNiFp1DYBmvfPEi0iD5pf1lett7hrhomNt8gFAtwMI+5Z8Rw+IVBmaFBFTaDGpXj4i2l/snKbE1W7trDeCcXU6vT8skP13UYRyjSg5VHbRS0OFSUgiXGNe1FXTy8u4PfwqeERQtLqlODx7WmQQ9sloBxG52yk+wzEFjrYwzNsSgvq45QibHHVO47zq/chKm+HAm9DFc8epU6AIHOzDVQoiYLzSl2ooqWCijSQGD4Hyn8bgJWmkiPzEW4jz1WFClV0q6XBJRtKe0X2g0rPTFWWzqQ+A5a1XL8l+2yPMk9Tv6Z+nJYe4nnSjFzms6eHLahz8fkGvaKf+6Vfn/0g2XTUvx4DJPPeIwdfWjSxaM/HtGWC0TnQ7SPMpNo1M1R+qq0c6toy25uEfcaYve0RW/XDYpLg4Hmnq8CHkHgLK9mFAesje+XmLh3QH9uodcmFY2xC9Qf0jT2sP9mw1xd7otGDh8BGpeocXSSBL5bVkUDGBg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(7416014)(19092799006)(23010399003)(366016)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDdkMzA4VzAwL3NWSHprL2JKdVQ3ak8vUGRFa2U2NzN5Y2VLeWpvbkpUcEJa?=
 =?utf-8?B?M2dlUkVqZ29kdmFLV3h1RWRveGQyZ0JGL2grZE9JcTZPSGVyYzJRUG5SRFdH?=
 =?utf-8?B?cjR0RGxPTndVM1hPejFDc0ZwUmVBQXVaNzA5bnBnOGtlWEh2c1FRaWlYWGYx?=
 =?utf-8?B?S0VPZlg4NHFiUHdUcVFSQnprYmdXd2JuQVZFNXJVMWhJZFJqc2pBcUp2OVhp?=
 =?utf-8?B?UXNhU1QzSVBHK2NSNS9TUXFvOTFxUGtPQjdZTDdWT3FDTllFeHlpMHc0NytS?=
 =?utf-8?B?SityZXRMZGUwU2tLOTR4L3dVcEtiemtjcCtySEhwM1Uxb1UzWFU4bUptM2dR?=
 =?utf-8?B?aDNucVBzOGd1QTlzTVFUN2dIeUIzNExoVjRaTElYMkZQSlFqYnp5T3ZMNmdE?=
 =?utf-8?B?cURYcW81QmZyWVZaU2lQekl3M09LR05TaVNoYUlxUUtUWkZaczlTQ1NqV3Qy?=
 =?utf-8?B?UCtGbUEyL1N6Nktpd2src1ZBbFRLcy9ZTWd3amxEZGNYbWtFZUhnY2Y2SGJG?=
 =?utf-8?B?WVpIejl6WFZWbnM5TEFadHBybnhtanNZczNFZXNyYzJaTXFvTFUvTnR0SEZ6?=
 =?utf-8?B?VXl4YTdzaTRBb0o2U3dhR0E3L1hoZU5DRmtIL1hvd05FWm41UGxjL1NGdVhM?=
 =?utf-8?B?Sk1aRFh5RnhBZzRrcnNRMkpteTMxRVI1YjAwVTNRRlRubHdZS3drU25aaVBK?=
 =?utf-8?B?OGRlTXNFRlpteTlrbFdoY2w5SEtFbm5WcEJMdy9OZnNEdUJwdGlzTEtZdEp3?=
 =?utf-8?B?K3lLZTIrQ0Q2WWJmU2p4cFlxUCt6ZExrWHhQQStvb0hTdW5BS3pBazg5bFR0?=
 =?utf-8?B?RU5idVV2UUdqdUo1SjQyWWFnZ29WS0VmUndoTVFpK3hiTlJ5d0pGQVdLQXl3?=
 =?utf-8?B?VkJLblhlN1EyT1F0ZFFOalZvZVlNZjZ1K1VKQzRSQ3dXUmdJZEszTUM4cWZr?=
 =?utf-8?B?bFRmZnpsbGdiN1RrdVdIQzEyVW5QNlRZeFA4SUFiTlBCQm5PYlQ1cmVEMWUw?=
 =?utf-8?B?WWl3TDVBU244WmpaaXptYjFxVk9lVXd1SXBuYk5WdlRYSWRQdmZTN1RwbUlE?=
 =?utf-8?B?L1M0QlRZZFhJenVmbWM5S1BFQ3R6dXd3UTl6VE5INWMvSklSVWJRYjl4OWN0?=
 =?utf-8?B?TlFnaUVPM1RwQ29vMExrOWlGTEVLZTM3d01pUlNDMWtFNHZLVk5IVUgyMzBK?=
 =?utf-8?B?WGpMcUlSaVFyR2ZKS25zM25QMGRIbkNyZVFwZ0hxZjd6R1RrUVA2ZFg1K05q?=
 =?utf-8?B?a3Myd2Z0eExPZGZUcEZSMjdUZEtDZWl2WnlPSUNHZ3BGcTgvWTNhWHlRejFa?=
 =?utf-8?B?dS9JbzVzL3FmTnhyV214ZnFFZE1wb2g3N20yZWhBUUkyc0g3ejZZSFQrcXV3?=
 =?utf-8?B?TDU1aHNBSkRSRUx0NG1rdlIxeml0emswNVI3NHVjYlRwMHF5NU1ONWhPeHZp?=
 =?utf-8?B?WjBZT3c2Z28zNnE0aG4wTW9hczEwMjhrQWxlVFNTTXNtN0liRGUwU3lmT2s4?=
 =?utf-8?B?SE1BemExZVNmVUcxNUZtU1IwZS9PVXBCSDIxZkZaZzRlRm4xaVNPUkw1OEFa?=
 =?utf-8?B?aVg1RktLcTBURmxrQjJLUDI0SmVNa2RycHZXTUk1VmN1L3ZEK2VyVlRDck9G?=
 =?utf-8?B?ZlAyNitYZnl3VFptRTc2SEJDY2xrR1hFbWVoUE9qTGhndUlHOEwyMnM3Nk11?=
 =?utf-8?B?RFZlRjF4UmRsL3B2RndhZEFoVDR6YjN2UVJYWWFHNWpTSTVTUGJ5L3NDTEZy?=
 =?utf-8?B?RDdxa0VydGgxWnI1MFV3a2VqRHpianJpa09rSmxtZlVZZzdnMlY0d2U5NlpW?=
 =?utf-8?B?M09USG9YbEtDL2tWY2w2QnViaGpId3dHd0Z5TmV2RXJCeWdENE5FV2Y4b1l3?=
 =?utf-8?B?NU5iTGN0eVdVUE0zdlIxQThKTUlZR3d1MWtMc09pOEVNa1pVOWZTVm9EMHpa?=
 =?utf-8?B?NFlWaEFBVUxCY2d6ZUpKSC9xVW5xYXowN0c0YURxVVFPaElSR0gxQnRyZ1NM?=
 =?utf-8?B?VnFIREs2b29kRFBRUGVobU9QODk3M0drc2Q0bkVmOVEraHNLTEV1WGNtaTlR?=
 =?utf-8?B?OENpRjVkaWFqYWIxMzc0K1J1aDR1SjZNaGxCSDFITHpDZGxXOGYzZ2FnMXJ2?=
 =?utf-8?B?VEhiSDZqUnFBUmF2RWg3MTcvb0puM0ErNU9XS1IxbktNT0x0QndLQXo4N09Z?=
 =?utf-8?B?Z3lKSE1sZW1PdlFxbS9qcDhCL2pYMGlubXhrWWFxQjJwVFg3WVZJd2l2ZmdQ?=
 =?utf-8?B?ZWdxNFlHdnZNa3F1b1ozUFJrWTlXTjFXTy9UUDQ0dmEwR1YrMFBUc29lbXgv?=
 =?utf-8?B?M2JKWjNtWm5pWEl5c1JXZjZlcW8xWGtYUDZCeGtzL2IyZ0lHR2hwTjZHejNm?=
 =?utf-8?Q?G2LZqi3Lp9BNT10+QMj3/m3WEo+WUZaRJzgp5uqrnOq6a?=
X-MS-Exchange-AntiSpam-MessageData-1: 9xbADSFmR+iaICBCKfVQEfoRTT912LKlkvM=
X-Exchange-RoutingPolicyChecked:
	Wm5wu/ak4SqZ03rSYdblpfw05guqkMlwmLXr7sIa5mN4a14w14nA/5lmSwmoGjx6JQdWvadEjZqQ9h2T66wRTmai3Z9D7+6hxRgdePn0KpkvPI+JVzFgao7JLy13wU9LkmC8B7XYvBHr0EROUYdCwN72YCm0ty+Zal6RVPAPiX4VNZiocRTRgiQ4heK7iClEtNbaRylaenx77f7VvZBVvxdJ66sO5XBF5xcBUz9ONFhGnwciytzt/MguHXZBCOc5oZ+ue1Muq2frVMVYypVqgMjjCvAA7w0BdlIPBCvFuCtbKeRy/LIe0qjLu5/jPsIfn9FcGJO4y65u4RtEGuAE8w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eOvzOOCoYeVZJPAjet648sYaMDnqRuDHG3MYU92PCeGTBhVWEp1ojiE4tqsip5I9qfuKIsr8y34V6wHfyPWhyoIVmc5FKnavpfmJg74zO/d4s7JZOKoZlVer6YyFJ0U/mTprRYVGoud6O+kUgCL7bLw2bCVrpaEloqGnG/npqq68EHIj8daM87ZD1pjPdIm1W7cbmeTnOrYVlWtKRP64eeV299cjxzv7sxnJfAg0f8s0Fs9kQibpAbokED6aLIu7Y2KJmFP4G5fEP+D+IwL74/a/aJLFsVjeAsDa4QNWyMN5y2d18bc0EsDTugGPLa680LIdI/dmocWo7f0tplzocl5aUhoh1o3NFWddZqztedG1p9ARX/RaH5w4CvBFKB1FEe2MoYMhIeCS5gINIkyhVxctwahu6QgkIZPgpWpxWb5SbD9o1ppcW46NKrVUs19Sr2rR8KfsQsPe8UkCfNoG80qLve621B1VhmmTd/bgsPP6ZY0A72NuGBrsRqa0GDeBqbp8fqXFd9bFVdP9efHMNkyQqD1VToj+QDmCzuIhFB0cKkEil+gWP+TgdfyWwknLCMVDhABA8rU2QZgRgDAg3gqEo73VnPiSm1fDMX0hhrpn0d8ZRY2D73ooebq+AI0/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb19ed5b-699d-4a57-8150-08df09b7e5a8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 12:35:54.9197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZ6GNoidsSjqf07QOVjji8udOfg/s48pXRLv7vdsYbmJLQCcCcWtT4qdLaySTnIkCb6LliaV+KwzUrf0Cuz4IUNwrfzB4WOIKJ6GBinnY4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7656

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

