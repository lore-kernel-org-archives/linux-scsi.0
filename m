Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4230B13B293;
	Tue,  9 Apr 2024 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676864; cv=fail; b=hqyVsvnMXdtGUa+IZ4yYWEHmBRRtaWpcDD4vpSHdzdXKqaNlptC7acCs7hYpyFqqvIVyO18tF5HpviZRonIc1PD9nrGSiPHkPndgpK3k+laTaJhAI4Vf4o1DjmGUhV6ALJXyHXZH9YK03Ben5j/G+TAfVrc2hcsgKsFh5ULIWTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676864; c=relaxed/simple;
	bh=5PrsjNOkWCAA7lY8QhuHsQKhAWALeR9iAjCMAPLzSeQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l2a0/4Ew3KHdRCGs2TCaW0bVEWb5eURo7C5tiXAY2+NmSyi5Pa1pWa7XTB2qx4RXTLMzqyLpiNIsa9FOK+1Z6nZ8vPukZ+oSqOGG7fDt6J61FaTAhUlrhD9K6D8AN3lWfCA5dS7H15n1JolVYtxhIrEmEeTitSTH/rKZQioxfaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rogaxAyU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZB2PUudT; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rogaxAyU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZB2PUudT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712676862; x=1744212862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5PrsjNOkWCAA7lY8QhuHsQKhAWALeR9iAjCMAPLzSeQ=;
  b=rogaxAyUA/mhStz1imKhBWeGTMkn9XmXnG4KNQCAVxIoo2S3lBahp55n
   WnFAkUWNhQbG6tbeqi5BR2IssR1uLIgtEcHKwHQkGX5eLdFp7QVbCrryG
   71mon1Z+5YylV0cc3CjD3t0ibXd8lupkmwPwZEJ1Xw9N8qVL2vwk2NLrQ
   69tKSf7uSPX6NY8GfDPvAnZeT0+lSKpSxO+i2t1AoSHDArEwP5e2QLc6n
   c4LFFLCunjvA4TkWf8FCFnjMWCm9HQ+8K++eNUIG7sC9Y1tZm5q7nUYTF
   6S9LUGEmAAMKG5+AQ2ZqGHw7lk9eovqP8loihcVRJNOO7OtLKYA3sZ/Ky
   Q==;
X-CSE-ConnectionGUID: WLXNzbsuTv2zgFGY9mLtPA==
X-CSE-MsgGUID: nIhsGmVcT4OCms5JGsauGw==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13079431"
Received: from mail-bn8nam04lp2040.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.40])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:34:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nE9sIR+GTueVCTBhpylaaC6t6wb8uPt/wRArsDcDJnrRfhTI6f8TCXYFV4ZNE8W+Ngpclqt1GlViDt4D2bI9ulEG8PlVc5OkNmShxmgdFDL6SWdnwnOdfz82Gk/sggBzGfi/1g/x472o32Eckd+JjQGRI0zPLXTibI8P3MQQgmzP2YntMXEwmfdcjIhVWDijbatL7EJ58j4XmiiethU/pSr+YmgD6+aLhLMN+0fl8cYKerOIG58irqIvichkdUP4Rj9CgkX0j/xDlOaSMlI7ItUWKLJUugAZdNJdXfndClLmAeBvBtxITyB87QtICKNKm/lbZtQ1TVbC6MWMs2sRGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PrsjNOkWCAA7lY8QhuHsQKhAWALeR9iAjCMAPLzSeQ=;
 b=D3mqt0ra3wsyioln5Rq98t9QIl4xUwF6I64mqI1vAVb7NPnYetctvEjEiDDZ0B/ht2Q1ZU269EIsgpv4jh+qwOtQKmRRHVgIMv0NhtDeFvETfZKx/1SV6J7dfaWqa57Ae8sd3KEDbcG9d0KsUhuGNxqY0+bU6F7ncVFN+MQvIj2lVD5pqpVAk/xqH2EKKP8XamTXanj+QZluGz5iZr8mTCz5MC44EF2bTNLv/1inH08CsZcT/ygm4OxWXYWA6aCCsRPp1KpVjkXAM50SbFLYP6scAg0VfJjYv3Zl/eiDqtwUxsOVLt2j4JZE1rtSzwiO+JV+xzlE54fCiDMfshOkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PrsjNOkWCAA7lY8QhuHsQKhAWALeR9iAjCMAPLzSeQ=;
 b=ZB2PUudTQ8zwD5cniYkrBNK7SFJN96kk3twWpDCDlD3JbW6C8BbVaDzxDtz5yXWBpihz/X9IXcMopHj01HiYOzki8B5gTAl1+kkz/c5e63Fs5JHRTRB4qbYTF+0zPDkiQw3pvOOHMPlDjUIntS08BLXxy44l2Ygn3ssIds8ll/4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SA0PR04MB7417.namprd04.prod.outlook.com (2603:10b6:806:ee::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Tue, 9 Apr
 2024 15:34:14 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:34:13 +0000
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
Subject: Re: [PATCH 21/23] mpi3mr: switch to using ->device_configure
Thread-Topic: [PATCH 21/23] mpi3mr: switch to using ->device_configure
Thread-Index: AQHaiowbkQDc0j/+qUSj1t4oMOP0UrFgEaeA
Date: Tue, 9 Apr 2024 15:34:13 +0000
Message-ID: <1e41a8df-2046-45cf-8ab7-caa5839d1718@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-22-hch@lst.de>
In-Reply-To: <20240409143748.980206-22-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SA0PR04MB7417:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 uuDs1e3W+WanIx9flAYB6LidTFpnKzKyzAhjgSu8eSS1OW/HvuoIq9plbCGgepOzmv6qp2sUatTSRCRDgD+lbiul+T7zOjkeEXCaDRl8RlpdVbJbuXpcmD35EQr94RjWasAcRs3i7jlm7Rno0tOG3NLPdnutgwjqVhEZTDY3HC6Hi7FcFRRcxycSCR3Ae4sDmrvZaUcW3XDz/S5lUw7pGmMXQmaywud/hETlsLg4jHVT7ttwd4p1ZWluj5xy7gV1xNP6xD/sH9FgPLvYVZeiX+3OTLmGmGmjtv6DH3Up8w+bebdAnc9oMlZY6HgCRVh2Ekk2Df/1uPb/xNe5E8TtFTFsxtjK+z4LnpJYUkzKFDKFDmORzqSPEsqfC69jhbhG6gc7bbnKLre9TFGtPOt/jXCLufaUAbzLsvjQv5iNe9zwXjo6kVY1EyCWmJMdJp2WhpbDESf1Xy1Oli4Nj6Sgi4GslcTbvPqF/YK8L54uF6fr4MGSa+2ovbc513+P7yGrKNq/o9RIu2Higz8zHkNlJbxHkmg16x2jJevtI0KExTHgjql9MD17/Ws402/nDD/tUBSiH9j0zw2bLj/u4v4WVnu5KnYIE8gcO1lF6fDr1XKzUAH0+sXWCw7iUMh4Yqr9crbpv+FTemuj8/v/d6rLwYA8nZkEubYXmT2BTysQRIA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Um9SWVZnVGhSaTBHUzVlbjJXcjlxd3c2OWR4Q1d5NHBRZzVZRGhQeVhBNDJT?=
 =?utf-8?B?eStZS0JHbzN0S2RMajJ2dS9Ea1NDeEc5WFlVSStSNGpJS1UrKzB6OUZHZ3Zp?=
 =?utf-8?B?LzI2aWg0aXhHbG84RWxIV1grRU9LSGpSOVN5ZTYvUElGN0dUOWZCVWEyWXZL?=
 =?utf-8?B?U0pqMW5yVjZDL1RKRGVMOElwUWlJT0F6QTIvSGUxR2ozdWZ5L2tFcHZGd1Nk?=
 =?utf-8?B?N1dBdlh5L2RrMDZicFBpdVhvczV5Vldxbm1PMTlYby9WVTdvWU5tbmJ6ZnpC?=
 =?utf-8?B?WE9Nd3ZTcnNmcU5iSVppbEZsdkxEZ1dsSmpJU0g2K20ycjFEMTJpdzUxVmg2?=
 =?utf-8?B?UFFoTFFIUWFyOWJuWHI4dmRWZi9YaWNBYVZCYldQSS9TN0lBc0pXMGl1eGRB?=
 =?utf-8?B?dW1OMU5YRTUveFhrMEQxUHVJTWpMV293Y0lsWXQyUk0vcVhDbU5mWVdpc1RE?=
 =?utf-8?B?RGs2a3NaVWZVcmtCbHFhRzFKYlFOK0M2MVNFd3hQRi9CQTZTVTFNTjJWbWV5?=
 =?utf-8?B?SDJLM0xkVlVDRWwveDNvOXF6ZDFWVkZtVjBOcUpsdGVtSkZKcWc0enJUb0VF?=
 =?utf-8?B?cXR5NG53aVBsWnR0dHlnWGRUcG5vMkJ0UHRhTHNTSkx1OW1IZ0lJS2g0Mnkv?=
 =?utf-8?B?YmlJM3RvT2crUmY4WmJHV1dPK25kYktxN3NVVXgwdnBXaWdLekFuR254Zk4x?=
 =?utf-8?B?cGdyaHJxRTFMRWwwS2VyMnNaWnNVbXFDNGo1RDJmcHdFcXorQXgwNm9KbE8x?=
 =?utf-8?B?T1Y0ci9IQ0czbDJNUWpjbU16Z20wQ0o3bTA4VmxmVElhbjh0YStHUjBBN1Zs?=
 =?utf-8?B?U21jSzh2L2hJRFpVekVSejRNazBIRGluVjRkMnY5SGpWVHV3ZE1zM1VnTldG?=
 =?utf-8?B?UFl3Y0pDWXRTRXh4K1E5MnU0MmRFM3R1V203LzEzNEQvSG5sSFl0TmtBWjR1?=
 =?utf-8?B?QWwyTFk1aTlwaFlpaFo2T0ZHK2dsQ2RyS2YrVUdqdW52OU9jcGlwbmJuWkk1?=
 =?utf-8?B?dStwZ1JDckpXQnRKYW9MQWxRaVh2ZGZTS0ptV0xJcnE0RDJOTkl1WDZSR1Yv?=
 =?utf-8?B?VktrQk8vWko5WXF2QWpKOW1SQVN3bUtNclBSVktaNWh0WGFrVjFIQSt2Ukhn?=
 =?utf-8?B?VnVVQm5WNmdwNEZBUTd4YWFNVWF4Q1BNRjNIK3VjekRnSkh5WGdrQm5QMGJt?=
 =?utf-8?B?bCtWQUZQaTd3eEIrTS9ZK2lPdnJiNXMrZ1RiaWFtNmJ4TnhnL3I5VDJCd3gx?=
 =?utf-8?B?K0FOZmViakYxNng4RmdPOHpxdW0vWUxQeTR0aE1DVFZvTE01YitNVFBjNmtl?=
 =?utf-8?B?OUZITGQrdkdDWURMUWNpWlJSUVYyVkZ1ZnlMY1NUWm9MTytORVJuU1JUWDJ5?=
 =?utf-8?B?ZFZ4bnhQMzYzdTdsKzc3K1pwSFo3WHZ5UTJWVXlaOGUvam44SUJoWXU4aXZr?=
 =?utf-8?B?V0ZaWDhqbXdlOXBGeFJHb0hNNWlQZDlMM3NqWXAxUDFVby9SMkM2VlZISWNJ?=
 =?utf-8?B?N3pZRHJXcTd4NUdQdUpLMmRVZVVqd1pMeng2cFhGblRsYmM1LzNRRm1Jc01V?=
 =?utf-8?B?V0x6YTZ0U1QvZmtuT2QyVWRFRzlxZXNvYUtGZWNFQ2R4ZFFtZzkzMEdCTXgz?=
 =?utf-8?B?MTdRY3oydGlQQjI3RGdFRDRlTTJ2R0ZXSk9UbXdrYlFGbTJSTHA1ZmRxcVBF?=
 =?utf-8?B?eG9OQ2pPWGpVa3lleGNUWEhhVThYUEZJWk5ZRG1LdmNHUEYvYkw2OXdVOHVn?=
 =?utf-8?B?K0l2K3NVZVFYaCsrQzYzd0tSNGlWT1JvTkRtdCtjNDBDWmp4K2NpUkswdXIz?=
 =?utf-8?B?NDc0b25VcDBTWk5hNUtzUzYwR204YTFvZjZXZmRITVQyNm40ZUp4S3loNWJv?=
 =?utf-8?B?U2J2OWowd2dGckJLaWNVWDJibEFVdjlqNkhxci9wK1JvaTNoUmt6bytZQk1m?=
 =?utf-8?B?Y2JqQUl4RFpWcERJUDZlUnNLcHk4YjB0NnE2V2kzVmVrYlp5eDZ2eFlwMTZ6?=
 =?utf-8?B?TVRBYzJVQ2U5WGtOZHRrRG9pU0FvUDFjUDM1SVlzNDZkUFM3aTBOamdDaXcv?=
 =?utf-8?B?SHFZVE9HdXp4NWJZNnJyR0V2VFAxOXZ4ZDQ5QjFkWW5Iazh0RVAxRkZpNWNM?=
 =?utf-8?B?MVZ4SlhwS29hajBKMGNyUWk0STdEYW9EK2ZEZWJHUFk4aVpCK2R1Wjlqa2hB?=
 =?utf-8?B?R2lOVzlONkdPQnVXMmp6bkpiUXV0YlpEWjRYL1NoQVZiL2xtWGZoWGI1bkVu?=
 =?utf-8?B?YlMxUWF6OFFXR21KTDVwUWZHMm9RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8550081561FA844E9C5CA8ACCC3F1C26@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+AIJ5J1HLrGkz5C8T5ui3ODkVmLRmEVLmW6PgblEQ7m8ckdNU2a+Hmh7upE8FnSoEoNgYtnA7isBfLmtvUa/uvUT1DIw8gxfgRo20g613qN9tByNRo9e39v+gqv37vlyVzE75tvADppILfSWiaFT679rBZslKRyD+1XlA8S0xl60hSzfugTPkD/fWMZetzxBCY7z8mnNdlnbPVbLk5M/6zM5JKhCXv5XC+SUPXwCcYnQbsZBfXQmmGj3orSCWtkLQS0X9rZRFVwFSbVtkGvQWJfu4lONNfDhFyWOh9p8JB5fAE54afGq5IwZxfciWh3y8arNlqwV7dc1dJmtjeCPfWqYhe/7gP9p6j5agB8xqC679EkJ5nnxbwN7ljU3QlSGndSgAHtTWSM+kvtN2POU1X53PuzXqYXrWZeEeyaO7vGR1c8jSHfjr5JzcQ5RzPwP+cgpX//7fHQWxNxxDHfx+R+8VW/CKTrt8TrOSTJGBH62k+yTYs7Lwfvy0QauRJ3U2s6sWQX2edHr4FXZtWedqk30c3BetP9ly4wS5QzvnQWsjHvktU0HqC0bvLFMJ82y5esHbjzt7ELfx8UmxVzmNS+SSWrB09On6Nqycn4sLKISkHqdnulw8KuDrxtMwc/p
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974ee461-51e4-48ef-028b-08dc58aa82a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:34:13.9128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWJY6TL62+HNwCI28/Lp1hjsgV6sswx850NVkK9zgm70E+A1l5dNyIvYEBZhMTiMf5+yc1w7kzTplecAmW+wIv5Luw3fbUqco20Q4czned0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7417

T24gMDkuMDQuMjQgMTY6NDIsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiArc3RhdGljIHZv
aWQgbXBpM21yX2NvbmZpZ3VyZV9udm1lX2RldihzdHJ1Y3QgbXBpM21yX3RndF9kZXYgKnRndF9k
ZXYsDQo+ICsJCXN0cnVjdCBxdWV1ZV9saW1pdHMgKmxpbSkNCj4gK3sNCj4gKwl1OCBwZ3N6ID0g
dGd0X2Rldi0+ZGV2X3NwZWMucGNpZV9pbmYucGdzeiA/IDogTVBJM01SX0RFRkFVTFRfUEdTWkVY
UDsNCj4gKw0KPiArCWxpbS0+bWF4X2h3X3NlY3RvcnMgPSB0Z3RfZGV2LT5kZXZfc3BlYy5wY2ll
X2luZi5tZHRzIC8gNTEyOw0KPiArCWxpbS0+dmlydF9ib3VuZGFyeV9tYXNrID0gKDEgPDwgcGdz
eikgLSAxOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBtcGkzbXJfY29uZmlndXJlX3RndF9k
ZXYoc3RydWN0IG1waTNtcl90Z3RfZGV2ICp0Z3RfZGV2LA0KPiArCQlzdHJ1Y3QgcXVldWVfbGlt
aXRzICpsaW0pDQo+ICt7DQo+ICsJaWYgKHRndF9kZXYtPmRldl90eXBlID09IE1QSTNfREVWSUNF
X0RFVkZPUk1fUENJRSAmJg0KPiArCSAgICAodGd0X2Rldi0+ZGV2X3NwZWMucGNpZV9pbmYuZGV2
X2luZm8gJg0KPiArCSAgICAgTVBJM19ERVZJQ0UwX1BDSUVfREVWSUNFX0lORk9fVFlQRV9NQVNL
KSA9PQ0KPiArCQkJTVBJM19ERVZJQ0UwX1BDSUVfREVWSUNFX0lORk9fVFlQRV9OVk1FX0RFVklD
RSkNCj4gKwkJbXBpM21yX2NvbmZpZ3VyZV9udm1lX2Rldih0Z3RfZGV2LCBsaW0pOw0KPiArfQ0K
PiArDQoNClsuLi5dDQoNCj4gLQlzd2l0Y2ggKHRndF9kZXYtPmRldl90eXBlKSB7DQo+IC0JY2Fz
ZSBNUEkzX0RFVklDRV9ERVZGT1JNX1BDSUU6DQo+IC0JCS8qVGhlIGJsb2NrIGxheWVyIGh3IHNl
Y3RvciBzaXplID0gNTEyKi8NCj4gLQkJaWYgKCh0Z3RfZGV2LT5kZXZfc3BlYy5wY2llX2luZi5k
ZXZfaW5mbyAmDQo+IC0JCSAgICBNUEkzX0RFVklDRTBfUENJRV9ERVZJQ0VfSU5GT19UWVBFX01B
U0spID09DQo+IC0JCSAgICBNUEkzX0RFVklDRTBfUENJRV9ERVZJQ0VfSU5GT19UWVBFX05WTUVf
REVWSUNFKSB7DQo+IC0JCQlibGtfcXVldWVfbWF4X2h3X3NlY3RvcnMoc2Rldi0+cmVxdWVzdF9x
dWV1ZSwNCj4gLQkJCSAgICB0Z3RfZGV2LT5kZXZfc3BlYy5wY2llX2luZi5tZHRzIC8gNTEyKTsN
Cj4gLQkJCWlmICh0Z3RfZGV2LT5kZXZfc3BlYy5wY2llX2luZi5wZ3N6ID09IDApDQo+IC0JCQkJ
YmxrX3F1ZXVlX3ZpcnRfYm91bmRhcnkoc2Rldi0+cmVxdWVzdF9xdWV1ZSwNCj4gLQkJCQkgICAg
KCgxIDw8IE1QSTNNUl9ERUZBVUxUX1BHU1pFWFApIC0gMSkpOw0KPiAtCQkJZWxzZQ0KPiAtCQkJ
CWJsa19xdWV1ZV92aXJ0X2JvdW5kYXJ5KHNkZXYtPnJlcXVlc3RfcXVldWUsDQo+IC0JCQkJICAg
ICgoMSA8PCB0Z3RfZGV2LT5kZXZfc3BlYy5wY2llX2luZi5wZ3N6KSAtIDEpKTsNCj4gLQkJfQ0K
PiAtCQlicmVhazsNCj4gLQlkZWZhdWx0Og0KPiAtCQlicmVhazsNCj4gLQl9DQo+IC0NCj4gKwlt
cGkzbXJfY29uZmlndXJlX3RndF9kZXYodGd0X2RldiwgbGltKTsNCg0KV2h5IGRpZCB5b3Ugc3Bs
aXQgdGhpcyBpbnRvIHR3byBmdW5jdGlvbnMsIHdpdGggdGhlIGlubmVybW9zdCBmdW5jdGlvbiAN
CmJlaW5nIG9ubHkgY2FsbGVkIG9uY2U/DQoNCldoaWxlIGl0J3Mgc2xpZ2h0bHkgbGVzcyBvZiBh
IG1lc3MgdG8gcmVhZCB0aGlzIHdvdWxkIGJlIGZ1bGx5IA0Kc3VmZmljaWVudCBhbmQgSU1ITyBt
b3JlIHJlYWRhYmxlIChwbGVhc2UgZXhjdXNlIHRoZSB3aGl0ZXNwYWNlIGRhbWFnZSk6DQoNCnN0
YXRpYyB2b2lkIG1waTNtcl9jb25maWd1cmVfdGd0X2RldihzdHJ1Y3QgbXBpM21yX3RndF9kZXYg
KnRndF9kZXYsDQoJCXN0cnVjdCBxdWV1ZV9saW1pdHMgKmxpbSkNCnsNCgl1OCBwZ3N6Ow0KDQoJ
aWYgKHRndF9kZXYtPmRldl90eXBlICE9IE1QSTNfREVWSUNFX0RFVkZPUk1fUENJRSkNCgkJcmV0
dXJuOw0KCWlmICh0Z3RfZGV2LT5kZXZfc3BlYy5wY2llX2luZi5kZXZfaW5mbyAmDQoJICAgICBN
UEkzX0RFVklDRTBfUENJRV9ERVZJQ0VfSU5GT19UWVBFX01BU0spICE9DQoJCQlNUEkzX0RFVklD
RTBfUENJRV9ERVZJQ0VfSU5GT19UWVBFX05WTUVfREVWSUNFKQ0KCQlyZXR1cm47DQoNCglpZiAo
dGd0X2Rldi0+ZGV2X3NwZWMucGNpZV9pbmYucGdzeikNCgkJcGdzeiA9IHRndF9kZXYtPmRldl9z
cGVjLnBjaWVfaW5mLnBnc3o7DQoJZWxzZQ0KCQlwZ3N6ID0gTVBJM01SX0RFRkFVTFRfUEdTWkVY
UDsNCg0KCWxpbS0+bWF4X2h3X3NlY3RvcnMgPSB0Z3RfZGV2LT5kZXZfc3BlYy5wY2llX2luZi5t
ZHRzIC8gNTEyOw0KCWxpbS0+dmlydF9ib3VuZGFyeV9tYXNrID0gKDEgPDwgcGdzeikgLSAxOw0K
fQ0K
