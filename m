Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F054737;
	Thu, 28 Mar 2024 10:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711622997; cv=fail; b=Tj3rmQcjjqwBt2vkzyNBg8Jcu8CXFCDrjk77iAVd8m+vaASDcRQ6SBMaWVDoqfiV4SBtUShxndsjihABje5x/tid2QShp4PySv8va5AA0ZAhhnG1O/6rCbnEByGHiVHVG6pZ6AIJ7obkHaq9lvpi7OecNFClVrWyqZ9ImHrPf54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711622997; c=relaxed/simple;
	bh=K1+pa0NiXNZ+2tKXS0j4vKO396sYu27Df8Q5ilJpxGo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G07+FZDbv1A7ismFowO50bZKxpevp5DYZNqKRUJT9Zs4LOoCpiRpIPn+5IZE2GCD4PNdlpEOZ9pkmp2sOEJxaS2UlOsfF7qTJN/9QdKryuRZhRzO53eAe6nCyqMAja7pJfATJvFcfEWb5D97yxFZNBzube+pnEwltCY9fZ5tJHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VMb75prs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=guK0pFMl; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VMb75prs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="guK0pFMl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1711622996; x=1743158996;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=K1+pa0NiXNZ+2tKXS0j4vKO396sYu27Df8Q5ilJpxGo=;
  b=VMb75prs6/+qKsIWOwrGMrL0bqs46j16ZQLpJXMQGOCs13c3zBwfJb46
   ZGUjAnHxisvNGri8jJQ5qhHYgLau2n2gJRxKuFCcWQlAscm9MVgFKYd8D
   5Oq445BeTltGq2HWBOYsOSsKHIUw6STQ55lBIAGNsMypbRjcK7U5ii8I+
   wIqbeUtRUf1O+WUpdPkZUso47eBVMjc7AISMBoBMW1js/q3+sYnFk6u/1
   cDLN8pGQflptTZO9wjsar1LCw9DcjRnCbCfpFQWu2l5Di2zDwnKGBjBvj
   UkDgMQpy9/aD7nC/bJq9y9v6ZL3O3mkitirV0h2f3xAZqJfM1wQLa1DWm
   A==;
X-CSE-ConnectionGUID: zkcfab4uSfmRAlFKSKtD+Q==
X-CSE-MsgGUID: itVyNgTpSI+N3ysJQSbe2g==
X-IronPort-AV: E=Sophos;i="6.07,161,1708358400"; 
   d="scan'208";a="12529466"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2024 18:49:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFNV1cyJKmzyoX/0jF9pex3xWighlScn/idbWub0uNWUKpCIluqUn7+MKKpUZSMqLsoA2CvxczuzIk70WdR9Zh3OVM3iZ6mIGj9//bVwogKdwmpMFafL+GldZrmr/vCR4bEXGGBtPjNyfbtB9qkOYfEMy3bcMkG8Bs9PzQ76NRTQBjDc1E3iPvR7qx4fOC424A9FgIUZhgo8F1FD1IsbsO2h67RI5lKUMDUWizxlaBz9xN2o1+2RZgdK/w9Lz+sOuVTiFGc3qPIPm266CJXnttDQHQQm8qrSCETaGxk/vUccZUhfJsBaOg25Xnx7tO6u7mYfR4UrkQb8QLwrMlglLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1+pa0NiXNZ+2tKXS0j4vKO396sYu27Df8Q5ilJpxGo=;
 b=lnFZvKtqmfuILaMDX4LuEJi6Vwd5s8d70MzQb3AIXVKxzS9rFYIesVZmkrQKMHl/LJnHjNz0Azn7RmR3XTlLLUJjBktBci7aV6XDBXtv/o2AfFuxOJj4n8vy2gCQxtBlfxMU1343lwmGCVIuWs8guJnw+bcxM+BiZvLaZpLBOkyDLSw1CzHLJtC8lYkEnGAhM6SFOBYjHZbwdfBOx3U6r1c68xLAwRGvrniH1GzWDswwAQ3LnlnYFdEuczwXVk2ORsgfKG6z1ad+I58yPDfan7x4BEFQVzwjPOuU5zGD1JW2kld75MpXCVQ71bLww1ww0bGjexDCodu4bG+UlqRGgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1+pa0NiXNZ+2tKXS0j4vKO396sYu27Df8Q5ilJpxGo=;
 b=guK0pFMl49C+q0LFNfrJE2AWJq3u73G+aQ4keEXSnjDLT65vBP6wmokgu6RoJQ7nbQFdfKaxlgQDYKW7+tGVrNGYOOAvvjDsQ1rSKS186OFeq4SpyL2o4iiZn0pmxo3wcRwGeaXVN4IVD+MDjKUQcsuqhfRY3w0eK8TahDQnfdM=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6807.namprd04.prod.outlook.com (2603:10b6:610:a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 10:49:46 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::a814:67f1:24ab:508e]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::a814:67f1:24ab:508e%7]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 10:49:46 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 15/30] scsi: sd: Use the block layer zone append
 emulation
Thread-Topic: [PATCH v3 15/30] scsi: sd: Use the block layer zone append
 emulation
Thread-Index: AQHagKld2jDUZjEjbUOTHT1sWCBzqrFM+feA
Date: Thu, 28 Mar 2024 10:49:46 +0000
Message-ID: <cc6b06a0-9343-45c7-a1e5-031a03307108@wdc.com>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-16-dlemoal@kernel.org>
In-Reply-To: <20240328004409.594888-16-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6807:EE_
x-ms-office365-filtering-correlation-id: 7a8fb1b3-057a-4c26-4a60-08dc4f14c886
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 1k7tPO6GODmmNpuOsQUwCFdnLCyCRYuA7+mpYMnq5dxOS2tlfITk56vANDPAmMb82GygyAp16oKsbaYv7EGi7Fecd9wQZQbic6vB16ALZ4yF0tT92JIoQzDfCTUIt/c8DdzcIVmpEjvcImF6aX8LIT52QUw2seoLIyrHdKLmdtJc9RZ6Wpuu7EGseKF5f4S9Npe3dC5U1XUMZL1R2I93E1YylChfNdM+oAik1Trcpcn3KLk73aCHqfVQSc8BQdmymV3eIMpYJT6CbW2+zvbvWt6ibho7R3vSCDhvNplUBXDSj4hcoiTXqQOF6jWHGsTjX2d7Lohs9aJUmBGp0ltPi+r7RmJum3SR301d/9rkTFD9X2lq/qbCR1gUHqGNq+PnaA20lrmMDtT/dIhBuKFqgHsw11K3JB6W6158TDH2XdMEyK1AjD3TjOMKyzGudh+SMK2DRUhZo6ItTGG+Gmh6nHSIidqA0AYc3A7BFhSOk9nq3RMeS7D63hEvuhpKBaWzJ17cg9SGY6zMWqmiV8x8H8jiJBlCZLCIrLiCH/3SmJ9Ub2/BP57R0ZbRlWbrnGjaVmrS84K8jRm4RDaJNtAVPjxDqxD1B9KoxspOHI15QHy7v2FeG6byYfMqCGE4IJegx2AjViNfJzeS18iekJTDCtSH1of/gXW5PbcuZyUHASzhuNuTTh5VQbTuYi8YNKqTcNTUfxoB5OQHX3Wc3H84j01UppH0ycBQ9JlCcziKlBM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WU9MUWZlQXhCZTBCdEc1bGlZMlZqZTJ2ZHkvL3hoVDhBQzBnZHRMaDNCSkt1?=
 =?utf-8?B?bTZOOVovenBDZlhSZ1orT1BTbWtkbzltdS9vRytTak9COHRUdytaMzlwbGJU?=
 =?utf-8?B?ZldWYWZ4aTh4QkRVVHZZVnRzWEc5ZFNmWWFZamZESlVuVm5lL3ZiWTY4L1I5?=
 =?utf-8?B?MWszTXovM2tGaHltK2tQTWQ4L0JKUnJxVDRLRm9xMmFkem9zZnc2djhVS1BU?=
 =?utf-8?B?Q2VDRjM5ZlJDTm42clI5NURRcFRxRHZJSlRSeWVrTjQ5cllyd2JSdTJQVVpa?=
 =?utf-8?B?REpMWXcvc01DU3NCdkUrN3FYV2VuV2Vrc2hZRWp2UzdMYS9iZGVqVkw0R1dJ?=
 =?utf-8?B?d1V0bDlmV1U0U281UnNseDJ3My9KbTZMYjVvUndNSWZDWGVTMGh2YjhSZkFK?=
 =?utf-8?B?Q1g1dGZqN2pjY3M2RTQzZGR4VzB4cWFIWEJxRkcrZUJSa0o2ZlJ1R3IzNHhw?=
 =?utf-8?B?OElrSHNldGEzaGkzZWt6V3hTMDhOZzdFeGU0SmIzeEkwZHZXc2JEcy9raExK?=
 =?utf-8?B?c0d0QWRSVlJlUDIvdzFDZlN0NFpEVUF0czZWWkNqZjRrR3dxSTBvZ212UzMw?=
 =?utf-8?B?QTUvRXdPTFphVytpVnB2L0t0UC9ERk55bk83TTFtNGhyT0Y4b2F1RUZPQVJH?=
 =?utf-8?B?aDB5S3NsRk1uNWo2QytVTisydDc2c2hqdE1DN3BiR3BlbU5NVkVzSENheXZq?=
 =?utf-8?B?Vys5bHBlVFZ1UTFRT0Y0VU5Uemtva0xOc0tjMGY0ZUNXQ0JNbWhXckovRGpB?=
 =?utf-8?B?aytabStaajYzY2dYN2FhMmg1eVBiRTlyQjl5TGx3TkRQQ1VCa1VEWkpwS1RV?=
 =?utf-8?B?RDZDUDB6QzRrU1JaUzVLSDkyT0p0MFJWb0l1STFZSEZXUzIzT2dIN2xsVVJk?=
 =?utf-8?B?MEhpMnY2Y1dMQzgwOWVOZ1FPdEdsTlFlMGFsNGYwVmZwa3AxYS9uSVhYdk94?=
 =?utf-8?B?UCtiWTUxdFZxdy94cGVEZVRlWCswMFZuTGlUZS9KZmlPNWNpcVdBU21Wdnpz?=
 =?utf-8?B?cGJ1SE9KR1ZQMnBhSXI0T0VnMnhGdit2S0tOVzdHMDNrMCswK2FZSTBKUXdl?=
 =?utf-8?B?WHY4cHRxU1FMNEY2cm4zVGNCY3N4K285Tm5SUld2b3RPN0hHLzZ5dDdmR2JP?=
 =?utf-8?B?SEtqTFcwZmhRVVRxZjlvY2xmK2wxZTF0dk1kL3IrZ0NLQ3drWDZKcWJjV2ZR?=
 =?utf-8?B?cTNlU0VIdVlpTERDcUFtY3NpUHBZQ010TjBWV08vc3h3bEtkR1VwM212WFJl?=
 =?utf-8?B?Qnh3NzZXbEwxazJyd2pzcjFDQW42cVpyb25BT2ZFKy9TYXd4UXVlSEFCejBT?=
 =?utf-8?B?U2xjTHNPU2FkNSt5YXdZY3ZVUWtpRDlnak05eGllL2FSaGZZQVNUZWExb0Qz?=
 =?utf-8?B?c3FZYlFDSCtYSVVta3ZMdnM4a2o2QS82UlJ0OExLVmNQY0tFNlltL2p0aFJs?=
 =?utf-8?B?ZmFNVTg2eVFlUlJEOHpGQnpxQm9BY3pBbC91T1dLTXdDdWtYYVd0WWNSYy94?=
 =?utf-8?B?cUhDcGdHd2pEWGYwRDBneWxnSm93MWdGVm80ZXdXbUdlcVZYelJ1K1QxbHZX?=
 =?utf-8?B?QmticHBBME9SeVNnSnBaTkl0WTdYNlJna20vQ1dvek45VkZpTXdsRnFiZ05j?=
 =?utf-8?B?TlFtRnZVcDZWVm1yZ3BBVnA4OCtuK1VoRGdjRjlYK2lGdE1qRXZ5OXR2cGhs?=
 =?utf-8?B?b1Nscmt3OE5BQ0pSTjB4U1NkQ1RxMXdiYzY5bTVVMW5kMGVKbTZJTzRaNlBo?=
 =?utf-8?B?dGpoRHFMUjNHYnNyMGtrWXQ5bEo2anRPSzJPWUdRdk1FV0RvNlBiWUh3MTdV?=
 =?utf-8?B?SGZQQ2tNRFk4QlhuaS9DWUxLbmNRVVRITkNtbFZOeE9KbU5RRkJTbDZQRnE4?=
 =?utf-8?B?RXFXQ0w5V0pmVUhlR3NMY1EyVU55ZHNNNDJkU3VuRlMxN1dhYXBsUHVTWkJu?=
 =?utf-8?B?S1ZVeTFIenpEZ1RqemJBWW9ZeWRIWG9JWFcybGFDejBXN2dTdUIrc3JvL1Bu?=
 =?utf-8?B?Z01ubGtpeHVxbFRRMWM1ZFpWbzlDMDd0RCtMZ0JmWVhPU1NBTzhoUzljRmU2?=
 =?utf-8?B?dFFJWk1YNmc1VExFTm9GUzZzbVR3ZFFUc0gzRGFRRUpDSWFST3RHZjN4UlFC?=
 =?utf-8?B?SjBPWDhFM0dsdUpQQmlTc1hvM00zN0RxU1l3bEpOTU5ha1Q3V2JCa1lqcElQ?=
 =?utf-8?B?K3dkd0RURkh2ZmZ3RFU0QWpkbmkwdzBPYnBNR2hUaFl4WnhIQ05NenBKSW5m?=
 =?utf-8?B?WjFleitaMDc0MlV4NldQVUlYVnlBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09145227C2694A46BE7A82047D5B95E6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	70rZ0BT/a48S1aqcisIvvpe3Uk7QhnqGQhhog91k9iGKHIf2cr/2eLPJcuM/GaOPGIFPlTPSA5tiA0M7CMc4AvcEWsh7J2sRZXpD0OTkjX1kDbvoba7kNpWzWru7mXkq2VYMd8nL7fUuDLjWldmmaz/uQxaH2ip5VHJxCXeDYEpotPfmQ+lHSOjNr/0BEfHt98QpYRoKMBtWqodn0Dvtbvv3A6f6+l1tM1mschU9ilpVM1obAmV0lNUkpf2cu0F43iTXFDN29aWR6ohX3Ehfxy+YC2djF7KNbRpgU/exz6DDd28YmRFFwpr+STzvtjvGgsZiI5MVICIIgDOtPFkOhQWRq+6AVGIFA6LbEPYQouL4KBxm1O39CmlqNjxTdohcjSHbEPZzWpzBZ7vNdsoRssIkzV0CTozJifce+LoyksYz/AjNt6HzpHyamVPkzkUNjJKZGPDHLpN09l8bz5cH/YaqrJGiIAebL5VnWpQA/hL8AeaBYYPlAgvZbbfb7aM85bb4iRrE3IpOAuVRl8FVYGwlmljV0NquxPFCYT1/+DDXvo6J5ORWs8tcghFK8NxQCF+o3lEBDlX0kOfIIKXsmgU97Pn4TID6iTm6TOVn59QXNFdjiQImEosUIowWBPVZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8fb1b3-057a-4c26-4a60-08dc4f14c886
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 10:49:46.1633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rbaJ6H+NdF7ME99u4KIs2VZjXK7MbRqBEK9rnWWmWFwBNMz902+2CzlxgsNcZz14XZzmAYzf7rfkr6Ht2iYuuVQVfir6NTBi2WlDH+yeLyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6807

U28gbG9uZyBhbmQgdGhhbmtzIGZvciBhbGwgdGhlIGZpc2ggOyggOkQNCg0KUmV2aWV3ZWQtYnk6
IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQo=
