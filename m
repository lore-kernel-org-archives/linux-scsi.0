Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4181F754A;
	Thu, 20 Feb 2025 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060682; cv=fail; b=uQB3aVIwFfXh51uPt1usUZxh33y9UWCDRmCZn6O3DBDneg4YkLTjkLsjXodWS+/Ngq/sbjwO/v//scjPZekhDGaJTlcYVuZKXshH5cbqG2dAy3sFL/AkSx+g1zRZlttZ/LwfTVtayQEWN6xvPEZTL64UfVhLjGTZMZw+IQfd9go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060682; c=relaxed/simple;
	bh=MP2LPV+OR2SOhsEb2IOlA2QWh9i95qn7G2nxSgZrs5U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DEsBzUZ6vE8Hj7VmOjs1h3bvlVJnuGEpJGHZBaY7zg+uwUD92CljhDwlxxTt/q5DkIYqVPiGXRyWy58y42NYegESUeHA1/9RJZ3Dyc7XOwL3qpmYirtF85dZ8dJV2a5AI06dFjGfHpVvyp1xS/zSq3hFzLeDU/vogSDa/upNL+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=ZZ7lVrcQ; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="ZZ7lVrcQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1740060681; x=1771596681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MP2LPV+OR2SOhsEb2IOlA2QWh9i95qn7G2nxSgZrs5U=;
  b=ZZ7lVrcQ1CbWsiQ1VEfa8i51wFFlk9EFVCbsvIpAZzpDxcmNAARagumn
   mPYeLUtm2gNRJ55o+m5wr/n9NsudjoMO+OMdsWqmtEOAkJ13pfpZrqA3U
   7bT2FTJXYCsXFCLu7LRqBBNDFRPyqBgFafmDHbTCaS00Z7NpIb9Yif/HQ
   UgRzDEj6Gq0Z95/ollF/eJSNNhNNtznsfIpkNcg66l25hHcxct3Y8b9AS
   15ShGyVb6XmNEW7YK8o4D3ecSBSmQsefOQt16Yz6V7IoHuSQSkcWBeb05
   B8I2oyBJrTdVNDrgxmFh9k/oynU00s1siDTQAVDphlrAyMFr3aHEWkXFL
   A==;
X-CSE-ConnectionGUID: hQpunzKRRR6YeoS0XttI0Q==
X-CSE-MsgGUID: bCIddAZCQr6F7+mi/7aLJw==
X-IronPort-AV: E=Sophos;i="6.13,301,1732550400"; 
   d="scan'208";a="39658965"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2025 22:11:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLbDaKPPVJ4ciGCUssHy/jlLEvooFCAFECSlA1DSlYFL1G9I1IcCQ8QO3NAnLMW0qNUlra/rIavu2hsMcrednlH5qfNBYuIai4NVF9Y5oILCCE6VQ7jzHQnnzEMkDz+sOM25n62cykcHMtu1lFrMpl4kIgrk2T+ja4L6V3YWNICa/LsOYRJw5bZ7I0nBnkg6J4F7P0ckfrgcyc2HKVlTK7Lt2qmB/+TusXByGFZuA4MO1FImzGX+yGQyY+PeVcZGEvTm3HBEAyo6AXn5X5Sr6WvfK7fBlpnyj8H5YwBNG+/46GZGVGS/QRDl/HYvnD25fsnvPDqSb02rUb5edZMGiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MP2LPV+OR2SOhsEb2IOlA2QWh9i95qn7G2nxSgZrs5U=;
 b=kJRY24HoR0q/ghlMiFUOu+i84fF1b95nEOtlN8t7IAc9/yqdPAbJNvhOCshXvrWdO+8wV4wsoVbmtUtLwVnjTvtqJzS3AI7begv5noBcw6malUAa95XJwkMMsTMkfwHuysCqRomfrMtUWV8utNc2+KoJXMfSiGNWGHHcPkreQkMYhiXhK0OMawUxwcYydiFpxoGdsF5radfoe+1e3AunYUfmzncuFzDfo9hEjPnbA1F6jMwnP5JtaaE/STCLWtL+YpM2HmxOkGYRSFd8QDKgmDbbqsfdh9Zwgo2TTemUS/ZdZXHvybVPPY1I9DhK8Ian9tLuVhJ656Hg3Uh7oICRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH0PR16MB4245.namprd16.prod.outlook.com (2603:10b6:510:56::15)
 by PH0PR16MB5182.namprd16.prod.outlook.com (2603:10b6:510:29a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Thu, 20 Feb
 2025 14:11:17 +0000
Received: from PH0PR16MB4245.namprd16.prod.outlook.com
 ([fe80::a5b1:875b:ec99:3121]) by PH0PR16MB4245.namprd16.prod.outlook.com
 ([fe80::a5b1:875b:ec99:3121%4]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 14:11:17 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	<Avi.Shchislowski@sandisk.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb command
 failed
Thread-Topic: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb
 command failed
Thread-Index: AQHbgfZ14xMAE1nYNUajsliEsNBL9rNNojUAgAKcSjA=
Date: Thu, 20 Feb 2025 14:11:17 +0000
Message-ID:
 <PH0PR16MB424515C5D6B54520D786A84FF4C42@PH0PR16MB4245.namprd16.prod.outlook.com>
References: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
 <e4094087-f772-466f-b0a5-11528a798ff5@acm.org>
In-Reply-To: <e4094087-f772-466f-b0a5-11528a798ff5@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR16MB4245:EE_|PH0PR16MB5182:EE_
x-ms-office365-filtering-correlation-id: bff22dd7-43b6-4253-4364-08dd51b87153
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L0FqMDgzWjVwR050TTdvWm5jaVVPN3BkZU9CejRnODlJbDhqc2hkdzhBdHEx?=
 =?utf-8?B?b09ScGZyQmJ1aFhlK1Z6Mk1TLzI4RXBIV1NwMm5QaTErZmExdEh5R0g2UlU4?=
 =?utf-8?B?VzJKcU4zNWRkOFM4ZnF0SXhMSk5VZmRQeEhKcVZ0VUFxZXJ2dVBVMTJObll0?=
 =?utf-8?B?cTc5ZXprSXZuZ1hDYklxT1pXTW5lT3gvR0FaTjA5NjcyRkpsdlRuMFJpVHFO?=
 =?utf-8?B?eUE3WjFsQ1U3MS92WlUzb01LbXc0Ylk3QmR2YXZteHdkNi9zZjBsQ2xKUEdr?=
 =?utf-8?B?aDQwQnJ0Q3FubExSbzF6MVZaOGZyRnBDaWFiMGxjU3lvT251UEZxdko4S3dR?=
 =?utf-8?B?dkJtU0dKZFFjNXFuYVhoSjJFVEQydGkxMzg1R3N6cVJuRjR3eHBJTkRxWWN4?=
 =?utf-8?B?akE1SXQrQW9sK3BrczI5N2ppd05waitNa1NXdG1PZGJtcHhmVDhEa2FlQnpr?=
 =?utf-8?B?YjFzY3M0L2pReEl5UlJHcndPVzMwOVNTZjA1dm1EcmVpOUxIZG8vQjd6aWRm?=
 =?utf-8?B?MUxvc3ZodGU0MndHNmszTkErcmw4N0ZuS0dVaG9lNHBsLzhSeVk5NDJaL3or?=
 =?utf-8?B?Vm1XbTk5TG9LQnFWNmE1UVpDR2RaSXpkRW5xdkhhV2lJckpWV09kdVlpVUlT?=
 =?utf-8?B?WkVYV29Ga2lCUkNMNlcvWEpuY1hhVnRxbVhBOVR0MFFBMVdDNXpDSEZyU09F?=
 =?utf-8?B?cUlObm92OG1lUUEyZ3RMeUthZXpCK0Radk1TaktiT1lSOCthNmp0RlViV0xw?=
 =?utf-8?B?cGRYd2lNejhsRjUybHF5Vk43dm1rMGM0N3dOYUhDZ3NjSGFrTWdUc1dtR3lY?=
 =?utf-8?B?ZWJjdVdiMC9KVE9kcmlCejE3Vms3WWpOdHNyNjI4bFRSSXBnMmhkMFphZFJy?=
 =?utf-8?B?aFhBbkVhTDJmeTZZYkF0ZlhScy95M2lWRTQ4MzEwcGxpcEVtWW96WmFIRkJ0?=
 =?utf-8?B?TGdDUXhMNFJsNEZ4Yk5BUDBsVkV3UGFkQ3VHVXQ1dit2ZStrbC9DVVRDeXZx?=
 =?utf-8?B?anduZDEveHYwNEY1eTIwcmV1VnRlK0tMTmVFYkx1aVRlRXJGM3YxUjNoNC9T?=
 =?utf-8?B?SXFhRlhiVXhYOGtuUVpWL0VaSTlQV2dpeDJtYWpHUGNXaHQrbjhYYWhOK3p5?=
 =?utf-8?B?ZW12ZU9UdEVHRmtZb3hrQzBYU0szVXMyYXVjcFlGT0ZPSDYzSEl0ZWtZSzdU?=
 =?utf-8?B?c24yOVcwQ1hEekF0YmhDbmFnMml2Tkd6VjUvQ0Z6Vkxxb1JwSnRBMkN1TE5h?=
 =?utf-8?B?aGdGdWJTR0N1VnNSSEovZXo1V0dZTStqTEFydzJwTy9oNUNqamcvVEEwbkdM?=
 =?utf-8?B?RVAvQ3d4b0sxc1dEWDNtc0dtdnE2WFNueWFjSm16MUNRUW5mWElEY2kwSFU3?=
 =?utf-8?B?eHNuVVowdmV6RTYrc3FuYzl6NWd2T1VMdnNRTTNNLy91MzRxMnV5VGY3RGQ0?=
 =?utf-8?B?Skh3eTNkdTcwbFBZUlVlMGM0dWxRcUJ2ZXdnS2NpSHNCeWdlRE9ydGRjL0NV?=
 =?utf-8?B?cWVFTHNVamlUbFB2QUNVc0lJWjh0OFp1TUJZbUwyOEM4WHBWV0NWN3Avb3h6?=
 =?utf-8?B?Wmcxdm93amQrYWVLK1pwRi9lRFVjTjREZWR3OGl2cWJIMjNvV2ZVUkZyUE1Z?=
 =?utf-8?B?Ti9ieURkUk1XRWN4bW1DOXhvK21ZVmZ1dzlWQlgyZ1pKRmJJSjBrbldxUyt0?=
 =?utf-8?B?cm1DS1owYWxMTE5FUVAxY3I5MzQ0QXBLQ3hzRm92dlg1OWZDcmJwTWU3SzNr?=
 =?utf-8?B?YTU2c2F2MWtQZGNRWkEwY2Ryb25JczREUVYzSFNMTTlMMGM0R1JweVpZbUdP?=
 =?utf-8?B?aC9NRHlUckVjWjlUQklVMTVSaW0zczkveGRXNDcwZVdqTVVCQmNVSWRMaTBG?=
 =?utf-8?B?c0xvVXpJc0EwN2tWUDVtRVlRZzJ2b0hIanBnVDUvaHR4NlE1U1ZUNGZwekMz?=
 =?utf-8?Q?tDhHrzlaPlPQOMTAN0W8oyw8NvlDh9PJ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR16MB4245.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?alEreEM0alJmQktWelhNV0cyaXBvOXQvd3pxOEx1dW5FM3UxOCtkZXYxV1BF?=
 =?utf-8?B?NHFZUTAyd1Mxck5teGtjcUdGUTJFK0pyN0dnS0ZNOTNTZWI5UHdoaVdLTEw2?=
 =?utf-8?B?YnRNT0lnaVp5bzZwQTVwMHk3Sko2WHF2Z1lBL3JrVk9oWnlUQlRoYTh3bEpo?=
 =?utf-8?B?cm5ZOTMvdVJsMmZiQnlGY2libkNWeWFRK1NTQkU2ZzVwejVkTW5DUDlOdEs5?=
 =?utf-8?B?U1E5MklEdXN4MmVIMjlmSE1lODJ6elUybktTNHNjQU94cnZsbGhlQktkTG94?=
 =?utf-8?B?ZmZYTVhEUXBqa2IxalQvQXBXYXF0ZTVXK0dXUHhMWitndlFsMEJ3MlY5cGd0?=
 =?utf-8?B?eXpyclk0aFVsYjVWMjIvbVBNYlFBU1M5REp4MDhsVCt4NDk2VVhTbmVMRGg3?=
 =?utf-8?B?eGFHSzJJS3NUang0cnhEd2Z2WXNRNlhsRFUzQTBTMkpJTnF4ekhQaEo4bXNl?=
 =?utf-8?B?SmJ2a2RQUUhUNE9zQUZ2eG1TUmNidG1ZZVNGQjBEVlVIOE5aRHU2bksyclNw?=
 =?utf-8?B?b1Z5U04xOUlXbnJ5YkxldE5EUmtXMDNxSmxXWjNCN1pDZ0w1QlRFaktLSmU2?=
 =?utf-8?B?YzZ3OWVyWlFBc1pUWEw5QU9uUnQxUHAwSGtRNWptRmR5VVpreWVZa1BqTDVu?=
 =?utf-8?B?TW4xRDhBQjlYNUx0YTlNT2dtVnJtaDRVWDNRR25BNHFlYmVRKzhZajRSSk83?=
 =?utf-8?B?b2lrbXRKekpZUlUzelIvZlUxMFI0eTQ1RlVBQUFaeWVGQTdDM0ZwQ3dQdXRU?=
 =?utf-8?B?ZlY0ZWE5aFZETzJzMkZBQlIyNlk2Uy9ZNElvUDlvdUcrVndKVGltb1Rsek4r?=
 =?utf-8?B?dkpveVpVcEpnaUpwVnczbXdmd1VBSXVWQXRqU0gya3VIZzNqREhrd2NSME1X?=
 =?utf-8?B?aW8zYm0yUDlSbTN6amZ3OFMrc0hSSUxxenlpSXJVemhLT1VxQldBZGR0V1J4?=
 =?utf-8?B?enhXSDR1dC9ZQlE2MEdNQjhXKy8xbkZDU2w5OFozYjV5YlBBM2hKZXpiNXZP?=
 =?utf-8?B?U1lDNXBqRHpCckJpMTJ6bHBIV1BXZksvN050d1NxRmZmNjkrbm1Bclo1Ymh4?=
 =?utf-8?B?OUh3UndOMkJWNlRYb2tZRVdCZHU2WlN2eE1Cb1BFUEJST3RsWGU0REVuVTVz?=
 =?utf-8?B?UjJ6dFErcWRVVjQvbnJVUlByWUpKdzZ3N3hhMG5RVHN3VHFCdDg0K2JyZjhh?=
 =?utf-8?B?TS9lVE9qMHh1Mm1qcmFqUXgvK3hOUlFWQm5Sd2IrYnZaSG83SGFxZEFYR1du?=
 =?utf-8?B?M1duS1JsS0FDUUlidnFQNEYvSDY0aklValJZZzAzcDY1bkdWUWVWdFNZUkRQ?=
 =?utf-8?B?dHRiQ1dqV2RtbkFKQUJFVFJ4OHd2enVVaU1nKzh3cEt3QVRicFI4N1docEpw?=
 =?utf-8?B?Y1R6bW9WeERzZjIwbG1WTUsyb01GeWFMZ3JBenRmVmdoVkFNVnZZRUYyYVRR?=
 =?utf-8?B?bFZYZFcxYktmWURjaktkVWl0VVZEZk9MbTdmY0pqVS9oRzQva3UwKzkwNDJq?=
 =?utf-8?B?R3N0NTFkSG1icEJBSVJncThpQjRXeHVOWE1DSmVpb1NMcWhRNUs5em80aW1x?=
 =?utf-8?B?TTZWVGFtaVZSbGpCMDlBM05PbGwxNmdocS9lVzVFaFNaQ1FPRUg4V3VjbGIz?=
 =?utf-8?B?TWM3THU3aFB5cldYayt3RTJ4YlVwYmdCcGovZWhvaVM4NWJkSVMwUWJnS3dG?=
 =?utf-8?B?ZHdXSWFrV3NOWlMzTFBTN20wemE2aE1rTzF5K2pNcC9zRmcyU2FFeVlUTFB3?=
 =?utf-8?B?ZXQrNC9jdmxWWmlkMm1ZT0VrSjMxeXNFTzVKOXNLQ3RLdGI0OVJ2SUFhdzFD?=
 =?utf-8?B?QzNxOGRkSE8rMzhta2t3OFp6YXVtQzFUZ0ErelNzWVJ3d3M1bk5RMHk3ckk2?=
 =?utf-8?B?UFovcWFrNktLS2djK2xWVVFUOGRkNGhiZmRyNzcvSzl1ZjU1VEtZUkZNaUFm?=
 =?utf-8?B?ZDhlUVI4WEpTS01RN1RvQk9FSUt1dW5aWUZsbjBYMU93cnZTZ0ROcGU5VHVU?=
 =?utf-8?B?cjh4ekhURmJPSGZEY0V6TEtYK2tHMjJFNEhPdGdPWFdUSFdUaHl2MjZVUDVr?=
 =?utf-8?B?M0Y4bW9jK01qNWJZOVd6NVFwTHJ4aThnNTNJWFBxL3lnTkcwWUpQSmE4eHJq?=
 =?utf-8?B?Q0NJbTVqMkZJZkNCMk5JOUh6ZU8vY1RFOTl3MnJod2dNVFZzSWNEZks2V3hV?=
 =?utf-8?B?aUFhSndKaUxQSFpESE9Hc05lQWdjYWdWQW1EQ0M5dXU2MEIwVGdPMmxPYTkr?=
 =?utf-8?B?ejJ0eHBLT0svaXcyc3pGUVlmejNRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mnt7auUvFlTmHhCKg0ni5sqpSaRRrT12F6uLvEkWbE34+b3L+1gwFXxAPg7jvma/UBAHOArjjZMacC2Lv6Nl+sfZC55o4nzZMMDHLhQVziIp+9ORvIKahDSm3lwMT4ubTYRE7XR6El7679nkQqkSClWLBoMEgB4UBCIaubw9KgTjYHH08odxYpR5/gcx95qAG5c7YFkod9//wBOySgqkyditqIGeVYPaRk6iBPdrmS4UvywNz5L88O7/2Y4P2gQ3cYAXvuaN3Njl3+iO1EUUVk4W2FI14yyE5fm/KnRG6bf3O/MIuSEry3Hsmcl5q8Qe7dVTUOIrF3iLKJGk3S76HatPsrR6c+D63EYc2T6w7SjDjaqFekkHJQ589RSXivaATz0CzHeop6v15dtT6nbRLHwXl5cg9Vx9uUQ+2XAVY1H8MDlnXjKqzA7xC7PIMgmDEFzwlBWlY1efunnD4Mu4TwcjDHYim0rhTUocqbwB4MjOcQq5A2aHh9/71e/+cLlzlmy7v5Ty28Pk1aQMOQ/XIFNmuvze8rNKf7TM194s5D7Gyf3xfuOXKHBRULU4MdrwXUACW71CVxhHM+5kpW7Z7k7FyMpz3KdvU6phQ+bbNy0fNMfFQrc41hKHp6Ul+F5YT2aalyt/u/d3jRsbbMGocA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR16MB4245.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff22dd7-43b6-4253-4364-08dd51b87153
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 14:11:17.3254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ao3U72fYNdJgW7jFj7ZyOR1SCJBFGC6k6YEjOKkEeSNeZzwRWonixs1LS1FmAGzwYpqmD0gv3jW75chKOAFScwxecWwJmJRzxCisIpHO+Ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR16MB5182

PiANCj4gUGxlYXNlIG1ha2UgdGhpcyBjb2RlIGVhc2llciB0byByZWFkIGJ5IGNoYW5naW5nICFy
cG1iIGludG8gcnBtYiBhbmQgYnkNCj4gc3dhcHBpbmcgdGhlIHR3byBzaXplb2YoKSBleHByZXNz
aW9ucy4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkRvbmUNCg==
