Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B8213D293;
	Wed, 10 Apr 2024 08:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712736112; cv=fail; b=SRqk6UvBxw3PPUcCSsKpG5HTRXmPyx35q11/EiHN5ERTa7QUi/bw/nc6rfjDp6Yt78ZKh5urxnT8u2x35Vd9kV/wLTyjitMJBkAb4AcVGm1l1Ybus2WaHHK8ehQYg29V/Mle3/KxFFobTZ5bi6Fi96ZzJImFDdkiwRODm9Edoy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712736112; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WsqR0or36qjFhef/GeRbXTkSfVjEZhA6wYdLE+C+Kau8ptJYPOpP/EvxIk+aBr5n2SnivCngRGkPSjfKSm9vHx9D0r3mVTywRh2V8wgp5wltHQMg++oZEBBqbA2ZR+z/QO1KYOYcYEVC24U3037CTNK23Fbl1/sjL56oU3ZC0sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YwNypBY6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=P17hzgHt; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YwNypBY6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="P17hzgHt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712736110; x=1744272110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=YwNypBY6UsUYQMnosNyOzU9eXKvKimM7Ept+OJ0TYwuXLKd6tOvXlBLq
   d8zMr3o5xOSMfC9DRIQjH78La7jB2g8zchlAgoC5ZKTAavxo1a8/p00SF
   9tSpiwQa3LAR9btEVymr9MICc1p55SDcghzmRfUFT3FxD8BUOBUaEyF8v
   zfpLvIloe+aIkm52FeAtLau8o8Zt6cBvDNgTX5PMilAMtoQZ710akJO/Q
   5+Isqhb1DvjF7g+MEwiAKerKYJROjdK1AZ1LzeTOjhRzYrL4Qk//LS/K0
   CkfsrSDOLK6J0VNZVbvZdo0zFL2HAyyTTDscQxmtBeE/mRkYO1nf7olBi
   Q==;
X-CSE-ConnectionGUID: w93PextrQ56QJmpldyzZeg==
X-CSE-MsgGUID: bTdzJfaBSGiLsCqd58JrLA==
X-IronPort-AV: E=Sophos;i="6.07,190,1708358400"; 
   d="scan'208";a="13484864"
Received: from mail-bn8nam04lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hgst.iphmx.com with ESMTP; 10 Apr 2024 16:01:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REXK/S0+UeAZDh6MFHtzoj73HZmScKovpq2v0p+BS2HH6pI2CkYFPY4TdUWtLOPzFtein6Y6Mfl1xXBWH/urttSDOs8bGJ6dm+iBPTFPOFhQdK1fw4mJFoZD0SAtt/I8n8ajVDqHG/XQqsqgzZTdbCIarJAMvJStRLQ0Neb1jr4+NJAsONiA6HCGKhwQ3Ws6ObmFTFu9ZUT74EJpXA5dCvlz6IJIx+yJonhuwpnpSUArb7IZPEMe3JB269UQIaoKTnHhPq1eEbjqSIgdEb2UrP29qOd/7Y4RbabyzXXPjxwCcZe8KIjv4+0Czi9HQhWn/aV0dmB7eWV8gdWJ7mtzKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=nE2fmTv5SvmT7ZJBGKO4+VYzZnaR6ueltK6uBlDTAfjAaD+DiD9CDWGRhmspbaqJ/ljXxMdlvumW/OqtqzG8P/PsvtIrTlbXPbfOfXORhtnAT5+VP9s6RERdZeaTJNSRZ5eHGh3t1aS5RT4LaZaE+gIUDh8WrUh5b6PatXpI6pHrCpOAFjDg7Y1a9H6tMqSroe8sG9Toxb5i0O8mJcAOTe3tllFDvS+0IXpCaO8xXNXLFCAlgwkSx+XGdmrQjvYna3yiXT8C0HNrwCjY32ntstgWzn+19ZINp6twdRV7HAQ5bsFEEVek8CwfrPl8I2blN0NFdariNsQOkCtkLp0luQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=P17hzgHt0McNyw6YScQPHnS/viMfOTuxRy8omBVHbBpyy8/YF3rBwIWiMtuQoL19NrROuV2EGhaZzOeTbqobTLRK2FYEAjHWJGqiV6YV5wcSZKyNKMzhcFPkLrerLQjb55j+SxGNaDEeIhOzA0e6Wn8vAKAbWJdOx+IxuRMgxAc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Wed, 10 Apr
 2024 08:01:40 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::179b:320a:832a:fe82]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::179b:320a:832a:fe82%4]) with mapi id 15.20.7409.053; Wed, 10 Apr 2024
 08:01:40 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>, Sathya Prakash
	<sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, "Juergen E. Fischer"
	<fischer@norbit.de>, Xiang Chen <chenxiang66@hisilicon.com>, HighPoint Linux
 Team <linux@highpoint-tech.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, Brian
 King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>, Chris Leech
	<cleech@redhat.com>, Mike Christie <michael.christie@oracle.com>, John Garry
	<john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	<chandrakanth.patil@broadcom.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>, "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <Avri.Altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Krzysztof
 Kozlowski <krzysztof.kozlowski@linaro.org>, Alan Stern
	<stern@rowland.harvard.edu>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org"
	<linux-ide@vger.kernel.org>, "linux1394-devel@lists.sourceforge.net"
	<linux1394-devel@lists.sourceforge.net>, "MPT-FusionLinux.pdl@broadcom.com"
	<MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "mpi3mr-linuxdrv.pdl@broadcom.com"
	<mpi3mr-linuxdrv.pdl@broadcom.com>, "linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/23 v3.1] mpi3mr: switch to using ->device_configure
Thread-Topic: [PATCH 21/23 v3.1] mpi3mr: switch to using ->device_configure
Thread-Index: AQHaiv+KDFUHMRrhl0aoDuRvfXEedLFhJKKA
Date: Wed, 10 Apr 2024 08:01:40 +0000
Message-ID: <1701ade5-4f0f-46bd-aa3b-bf00d1fba046@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-22-hch@lst.de> <20240410042759.GA2637@lst.de>
In-Reply-To: <20240410042759.GA2637@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB8406:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 mlnjm+fnHKcNNfRQGzNDq6KLlRec4Be0T2fZgaaTSk/1aglvpJ7oN4COMkOkSYf5pJokelO7UfDhMsGRfoHOXDzJ33tpWrE1opHfsRjwI4/UCYKNZxnfH6Ypk6tkO10+VHsMZVBwvHbNKb3N02perOcXW0gLl6AYrZa3djfQjAGW0soRhm8c2PIkJ4PBYIjDxb6K4WJsq+CXhf3zn8/rywXa9UQxuDZnRzkUVj/WEElt7+UeimKUlex+PdMfc1vWIzU6xtoqq8foRe+uy3slYL9DQUqpgblWJGCb2yTiawAD0T0gVx4ICazL2BbgehXcOG7V+2mtVnsHlP+aOuHK5cxwf9bwiK0abaapZ/WlN7/b3u8/SIQUE8E0GGGaPYSYQq5wQNLlxVNsr0+iRhN26TpVZ2dHLUhc0I9XkFzxbxbtZBC6snc5OSmDQ2m/G4AtO8W/COCH332MuGI5Aj1ViIxUcDCiTPqnJu667qEfCqWcwB0nLjkN6m+oro8u+hmCOnE1e76Gw+34MCJvIPFlWbqlZrTgDTl5w34YW81rS2pVsZtlxEMIGFbpj2wo/u1a6pPvILH6yhnbhuNfpyZzgG6q6Gbx9EUhR0kQ69VjxFMFLgcFUA8vhy/dZmVK0uUyHRJuv3LwjaOrKTXFvbJWoz/vEV0Z/UItYRZtrBvCpDM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S2ZlZEdnOEdSVElSazlvSE5nMUxVSnNHbjhRZ0JTTDVNMjA2WklhUmNKWUJC?=
 =?utf-8?B?RHNjeGoxNi9BK2RUWmhjNHRQWXE0RmQwbG80aFVCcGtmY21rcVZQZGNleTN3?=
 =?utf-8?B?K1VoekhZZjZrQWk4Tm9HQVdZYnBsREFkTHlkMjdDZjlTbE41M2dhYi9nTUZT?=
 =?utf-8?B?ZzRPY05kUGFsSnhlR1lnVFFtYzg5K3AxNVJUeDhqWmVnaVd5T1pBUGVZQTdT?=
 =?utf-8?B?M0JtZW10am45c1k5VUNRL3BEMXJaM2xEZDJUQzhmamJVYk9VM1FWR2Jla05v?=
 =?utf-8?B?L1d4eGl3S0VwQ28yVUdzelRBR3Rad0I1VUZObUtVVTNHWmdFK1R0QkdPaDhT?=
 =?utf-8?B?RzVnRmptb1E3R2owbDZHYk9FWXlGSDJ0VncwbTQyMWMyelJxMnpoUERTYktL?=
 =?utf-8?B?SFYzREkwUnhVWWpQMlR1eGNXUGdJYkxpa05kLzBKSzZyUi85OGFIZStiSG8w?=
 =?utf-8?B?ZVBSTkxmRDBZMW5ncllQbm5ZK29xY1MwZzdYNzN1MHB3ZHJTSEordUR2dGZr?=
 =?utf-8?B?NjNSd3Y5VzI4MzFDOWJjUCtIQThIdDhhb1R2MUR6cUttaWxwZUhqdmRVN2Y1?=
 =?utf-8?B?WDUwb2c1c0tGRHB6a0lyQWZSRWpFM2hiSERzVlc4WXlZUW8yUmorTXI4a2xK?=
 =?utf-8?B?QnU3UHpHc0dwNzkxdHM3QXRBRjN4ZWxqdGhHWXNoWDdPY2h4RSs0MllISjhx?=
 =?utf-8?B?cllGeVNORVB2TTZFaTNVaWNTWHJ2NkE2bThuY0RYUVJCSEpmeGRDNWhNWkxS?=
 =?utf-8?B?c1JUbHdBV0laYjczVG5NVUxXclRjRjY0cWJwaUMwT2xuQ0RqU1MrYml4Q3hN?=
 =?utf-8?B?b2RNWCtUdG90MWExblNXRUhOTXZhV0FQZFU5d1haMDJaSVl5ekVpek56K01r?=
 =?utf-8?B?VmU3b3p5b21RZmFTTWFnLzhCcjJZdFhybFd4aFVRejFvZTRZM0UzSExtL2I4?=
 =?utf-8?B?THRuZ3V4aDJXcDdET3Y5RkFxYU1GK0NRcGdLUGUzSU9oN0E4L01UNjdvdU9a?=
 =?utf-8?B?WjdpL29DakNlVkhMZnE0UmlLT1BNM25NemsvRjM2Q2JibHc1eHdqVkV4T2la?=
 =?utf-8?B?ekN4Z0gwVDVwWkFFSjVnblJ1dm4zNHZaYzhCSjVDdmdwNU1Gck5wN29VdFZi?=
 =?utf-8?B?aHY4U0JuT1dRS3NhMnB5Z0IwcS9id1dheFdmZnRJZVIzN2tkVUlJMzFGSUha?=
 =?utf-8?B?QzZnd0FMclA0U1gvNm9UOTc3SHRlQUZDRUNOZFpKU1NFSHYrL1ZkeUdiS21S?=
 =?utf-8?B?MXFOUVR4dlNPdCt3Rnl5VWtUNXpGSTJmQzE0b3hVNWRBenFnNEZRU0oxY0Rn?=
 =?utf-8?B?M3RPM0pQamFGeis0WXhrNVk1Z1VmSTN3Wk9Zak84NUpSMS9oYlJVMlZISHNJ?=
 =?utf-8?B?ZzBaS0JxeFVsUzB4cEswZnh6N2toTWMzZG8rc1lZaEdXVEJLZ1QwVmxSSWRr?=
 =?utf-8?B?emxXTGNxcVZ6UzJ5b0VkYVBocTErbGoxY3F3WEs2UnBLRnh2dkN5ajFwUEN1?=
 =?utf-8?B?REE3d1gyeE9SSTNZSVdGYkFCRnRTVDVsMVdUWi9PZHhkbktvY1JoalE5bEts?=
 =?utf-8?B?MUU2L2VEOUs5T3NZbE8xRGFmYkRYb3krUUlHWkI0Znp1enc3a0ZETVZEQ25N?=
 =?utf-8?B?bzcxRjJaWDBnMERDc0JmNXBFcE9USVpYRlJXSjJ4YWIwSVozdERtTlhqYXJG?=
 =?utf-8?B?MnlHMkluUTZMRmJqVzBkSi9ISC84a1ZLNnJQNXRWcitBeGRoTE5DNStmZkhQ?=
 =?utf-8?B?eGhJbzZlK3NiQklHcjZXWExLQ3A4dXNSN09qQ003R0UrT1JteUZoRlN1bXdX?=
 =?utf-8?B?VUgzNjdxaFEwRkxkcWhka1FXOWo2Qi9GY2ppU0Yxck0rVVdNOWtyQ3hXT0x6?=
 =?utf-8?B?V29rd2paQ3Bqa3cvdHJ5TXIweXhueXloc0JSQ2dMVlJjM0p1TVBJVmpwOXZD?=
 =?utf-8?B?Q0puWHRMdUNyMGlobmNXa0FVb0Y2dkh0VlBrUytGUEtHUlZlNkxFbmJUQ2Q4?=
 =?utf-8?B?MGVVNzFjZlJ5aFJaOGxCd1hHZWdvMDdSdFliUlVZdlFhdU9BZEQrN1d5NTVr?=
 =?utf-8?B?WHh0bXVOSnNCc0p3cEJNOVpJM1luY1cxZSs5dCswK2drWVdWU2N1OTJmNi9n?=
 =?utf-8?B?VlZhWVZsT2hvOE93bUlYWUhyUFlPSDZxcTFNRVMxL3lUcUFFZGp5Q3hQeXh1?=
 =?utf-8?B?YU51TFlKL2twbW9rUmhvZ3hzakxmTlIwZUc0Z2xKS1BlKy9Rc0pSZ3YweWpE?=
 =?utf-8?B?QUE2bk5PQmlBZURVclpONzlEeGtBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E3ABC43A30BE44488ABAD001A209AFD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MXbRG3xqn04Sn2ZZR6nYrLFW5a7LWI7s7ynAFDv1PozX3liHQeynP90updN9TnNXNNyIdupdbUYM+veOmM76mgd3le/Q5G1U34W3j3m584j7yhNwtxOwgw4NNiV9ppbSLMVwFcCCz8HqeDjW3GR7We9gPC/1BFt1mpDy4V0pGpI1iER38l9JwGf5UFNiIhQ4JehDONybCxi16B41f8lqHKCEnr/E13GHGRIryNfLLQISHOx1AORF0BGJUeFVxA2Fi3dYex58AArWirrMGJOyDnuCoUhCD3vb5yKvRSltpaasmu+Tz2EZVOI8ikB4JZoCynb1QD2kH+TCXuxIpLMB+U62KCc3bueVaEr6N3AHiouYpS+Nv2CmT2c9KyxXmkQjtY1vig2q6IdmRVYn9O+maRpAcGQ8jVij5OJJDw6hHHik+aUiSwzv6APNAr28uCtf1acrlA5z+g0TJtIH7tKydlGtOM3lKfS58FPY99p+NCz9NFNV4l8sD9NVJ4gN0OO04zLB5To4keY/Et3Y5F0xPoXg311Q1nAMcJAPcqj3Li8PXZzBI78V4D8L3rFomcFe8TtwRhizOo5LxhfBFhCTjTRelRQ/g2eJhm9JOFXMXtdlIE2It6sK7LcxjiXRsXwZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a465aba-eb11-455b-4378-08dc5934743a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2024 08:01:40.2412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x/8AwpuoGr5xisQdjOqZtASZG+rcJftkmMaUayZe47+/0R88oa0AZYsoir3SXyM5MT0H3pnS9QbEfA7sly0q8LA5Lo1Oi4Qh2EdSauFK+YA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8406

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
