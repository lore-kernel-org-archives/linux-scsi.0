Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7998024B26;
	Tue, 18 Jun 2024 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718732178; cv=fail; b=nS3NQiEUcGU37T69LlG/6s1vd4kUmi+z4+k+RDxNKK+jrb1cN3um0Uo+4LU2XUm2eswaSV3YBvWzgF5jM6BMnOWmgDm1YR5K6q+v1C2JsDulXMSpkse7R5uJnuzgcVK+3Bx4yt1uidNU+MZ7TVg8x0MS1yAknOZ6qedLXJKi7Go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718732178; c=relaxed/simple;
	bh=/Vo1Jxgpx0FT4FrMNbu6lLw9KVxIVEVFXYzq3M60JoY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=daylWuo+dRbJUUXJ2c21OzTGzUgmN9py5WOw0isXZZ07Kf3J11zJGnSnvin7HxOSsU0JN4VdoAh1wwLanITnWlaRXgznJJYmWOd4ThydzIJoxt/kAObsdQT1oqXX6Az3Z/W6UwRcaKDcqkJx4NrP7g490s9iCryTEsBRlj5vVEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=a21MqF0p; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=XauCs5LV; arc=fail smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="a21MqF0p";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="XauCs5LV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2024; q=dns/txt; s=iport;
  t=1718732176; x=1719941776;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/Vo1Jxgpx0FT4FrMNbu6lLw9KVxIVEVFXYzq3M60JoY=;
  b=a21MqF0p+JDbjfQZOg9eEXkNAcfPaBKNIAN8E5SRK5wWzCrqWxw+xtKW
   IT/r09BioFqlYE7Zcl8B/kfriS6agZLLQvL+34cIwnegQVGT2O+FqRGyL
   PoA68BCsa0qlC4W0Sa/jA6jv7BBJLmIPywhpCGel26QkXkmG70z8ZBnKN
   M=;
X-CSE-ConnectionGUID: 9fmDV5MATLSN1mWcrxq3Pg==
X-CSE-MsgGUID: LX94A8RITt6DjNsR2QRdCg==
X-IPAS-Result: =?us-ascii?q?A0APAAAixXFmmIsNJK1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEWBwEBCwGBcVJ6gR5IhFWDTAOETl+GTIIlngyBJQNWDwEBAQ0BAUQEAQGCE?=
 =?us-ascii?q?oJ0AhaIYwImNAkOAQICAgEBAQEDAgMBAQEBAQEBAQEFAQEFAQEBAgEHBRQBA?=
 =?us-ascii?q?QEBAQEBAR4ZBQ4QJ4V0DYZZAQEBAQMSEREMAQE3AQ8CAQgOCgICJgICAi8VE?=
 =?us-ascii?q?AIEAQ0FCBMHgl6CZQMBolEBgUACiih6gTKBAYIMAQEGBAXddwmBGi4BiDABg?=
 =?us-ascii?q?VmIYycbgg2BFUKCNzE+gmECgUoYFYNEOoIvhgmBS5IIjBImC0GMYwlLfRwDW?=
 =?us-ascii?q?SECEQFVExcLPgkWAhYDGxQEMA8JCyYqBjkCEgwGBgZZNAkEIwMIBANCAyBxE?=
 =?us-ascii?q?QMEGgQLB3eBcYE0BBNGAQ2BKolvDIMvKYFLJ4EMgw5LbIQDgWsMYYhsgRCBP?=
 =?us-ascii?q?oFmAYNQTYRDIB1AAwttPTUUGwUEOnsFrSCBD4F4MAcQkzwHgxpJrn8KhBOhZ?=
 =?us-ascii?q?xeEBY0AmTSYZSCCNKYMAgQCBAUCDwEBBoFlOoFbcBWDIlIZD44hDA0Jg1jLc?=
 =?us-ascii?q?Xg7AgcBCgEBAwmIb4F5AQE?=
IronPort-PHdr: A9a23:1kaktBDQu6Ol7Zx6/5EYUyQVpBdPi9zP1kY98JErjfdJaqu8usmkN
 03E7vIrh1jMDs3X6PNB3vLfqLuoGXcB7pCIrG0YfdRSWgUEh8Qbk01oAMOMBUDhav+/Ryc7B
 89FElRi+iLzKlBbTf73fEaauXiu9XgXExT7OxByI7H2E5TOjsC+1Mi5+obYZENDgz/uKb93J
 Q+9+B3YrdJewZM3MKszxxDV6ndJYLFQwmVlZBqfyh39/cy3upVk9kxt
IronPort-Data: A9a23:kd+G2qnTyZf9qZdY6ZyYS8fo5gyyJkRdPkR7XQ2eYbSJt1+Wr1Gzt
 xJMWTvTOazfMDH1fNsnbI208E0A7JTSy4IxTVQ4/nw3EltH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaB4Erra/658CQUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+5231GONgWYubjpKsvLb83uDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FdwW/8pJXERny
 dgjDmkIURuZl/vt+L3uH4GAhux7RCXqFIobvnclxjbDALN4B5vCWK7No9Rf2V/chOgXQq2YP
 JRfMGEpNU+RC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OK8YIaNJY3VHa25mG68l
 jOa1jTDIy0GavCd7yG/qEuWisTAyHaTtIU6T+DgqaUw3zV/3Fc7DBwQSEv+ovSjjEO6c8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BpRUHWvJOHOAgrgKA0KzZ50CeHGdsc9JaQNUisMlzTjsw2
 xrX2djoHjdo9raSTBpx64t4sxvjNy05EzInTBMgdi1c5uboupEq1SrAG4ML/LGOsvX5HjT5w
 javpSc4hqkOgcNj60ld1Q6f695LjsaQJjPZ9jnqsnSZAhSVjbNJiqSh7VzdqP1HNovcEB+Kv
 WMPnI6V6+Vm4XCxeM6lHrtl8FKBvqrt3NjgbbhHRMJJG9OFoCPLQGyoyGsiTHqFy+5dEdMTX
 GfduBlK+LhYN2awYKl8buqZUptznfa8RIy1D6uFNbKih6SdkifaokmCgmbNgAjQfLQEzMnTx
 L/CK5/1VidAYUiZ5GrmHY/xLoPHNghlmDuMHsqkp/hW+bGff3WSAawUK0eDa/tx7aWP5m3oH
 yV3aaO3J+FkeLSmOEH/qNdLRXhTdCRTLc6t8aR/KLXcSjeK7Ul8UZc9N5t7Jdw890mU/8+Vl
 kyAtrhwkgOv2SGZeFvTMxiOqtrHBP5CkJ7yBgR1VX6A0Hk4aoHp56AaH6bbt5F+nAC/5ZaYl
 8U4Rvg=
IronPort-HdrOrdr: A9a23:iim/oqCjE7S8YIflHejpsseALOsnbusQ8zAXPh9KOH9om52j9/
 xGws576fatskdhZJhBo7y90KnpewKkyXcH2/hgAV7EZniphILIFvAs0WKG+UyDJ8SQzJ8h6U
 4NSdkYNDS0NykFsS+Y2nj4Lz9D+qj6zEnAv463pBkdKHAPV0gj1XYHNu/xKDwPeOAyP+tCKH
 Pq3Ls9m9PPQwVwUu2LQlM+c6zoodrNmJj6YRgAKSIGxWC15w+A2frRKTTd+g0RfQ9u7N4ZnF
 QtlTaX2oyT99WAjjPM3W7a6Jpb3PH7zMFYOcCKgs8Jbh3xlweBfu1aKv6/lQFwhNvqxEchkd
 HKrRtlFd908Wntcma8pgao8xX80Qwp92TpxTaj8DneSI3CNXcH4vh69MVkmyjimgwdVRZHof
 t2Nleixt5q5NX77XzADpbzJkpXfwGP0AkfeKYo/g5iuM0lGf9sRUh1xjIJLH/GdxiKsrwPAa
 1gCtrR6+1Rdk7fZ3fFvnN3yNjpRXgrGAyaK3Jy8PB9/gIm1EyR9XFoj/A3jzMF7tYwWpNE7+
 PLPuBhk6xPVNYfaeZ4CP0aScW6B2TRSVaUWVjibWjPBeUCITbAupT36LI66KWjf4EJ1oI7nN
 DEXElDvWA/dkryAYmF3YFN8BrKXGKhNA6dh/129tx8oPnxVbDrOSqMRBQnlNahuewWBonBV/
 O6KPttcrbexKvVaPB0NiHFKu5vwCMlIbgoU/4AKiaznv4=
X-Talos-CUID: 9a23:fGuzx25zYR0XGiYKBNsspUARNv54V1Th6Ez2ekqHAnx5UeatRgrF
X-Talos-MUID: =?us-ascii?q?9a23=3AGz9x+gy5p8T7TsLCwGrcbsI9GoGaqICeWRwkwa8?=
 =?us-ascii?q?nh9XaGS5WIA3HtQ67aYByfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by alln-iport-6.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 17:36:15 +0000
Received: from rcdn-opgw-5.cisco.com (rcdn-opgw-5.cisco.com [72.163.7.169])
	by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 45IHaEuC021759
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 17:36:15 GMT
X-CSE-ConnectionGUID: Jdv5qztRQx+3drxVDefBeg==
X-CSE-MsgGUID: IFNKUt3bQXuKOYzq8fYgiA==
Authentication-Results: rcdn-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,247,1712620800"; 
   d="scan'208";a="11196135"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by rcdn-opgw-5.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 17:36:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOygAyOPm1fXo2VSobj9tXbbLrRykaFpgh/s76Qvvsp+BsNqLHJNnC8ii8pNR7L4R1y5pNAjqFqTK+xZMVfN2KfpK6vYVB/7r5yYFTGDpaEqYqoNwgfA3wD2Jl0Lcyi5mTxTh3HXh7z6Qiy0di9ywwPTD5TbqydI8Ku6hkPP33AEZ4e7Y1LKl3x0J4r6zFlXDaQFa85BqqfBTZR4AYw5kkOnOvQ2Hme9Aa5ovz76FPOjD/HUoowuB2G2MZ/UmpRe57rayzOJZpKJQDuUbkzP0P6SQMXdL9DbMxzHjdqNaBQgchoLOVxLYFeQsx6hhu5XQTNZhfNZdoMJRy/mIrw7lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Vo1Jxgpx0FT4FrMNbu6lLw9KVxIVEVFXYzq3M60JoY=;
 b=DDxIEU00cSWhjlT2ngoecmAmAJ4irHzdzaBCPTANesXdvTPEqTFMJYBmzB3GZ4VLmNe0yZcZBPVlfIIMME7l4HEusQy+qK4cl5vKc5+7rbHKGS5sD/4f4LV6pGJJ0INLja6iEmMGhz7G+Yz4W3DWzq7LwVT1vZ5YA4+hRxgptZSL9Wph8sezI/8sbvG/IWo++F4cD7fKjAsbshdjYLy/zlofd3MnseN1rBKixZyKnA5bRMI/hgnQVtnG+TwHu0sTRngoSjHYvHU3gCc2xybNAjrGrTKZph7sM1MgvyLb6oHDMQVi35+Q03QAckKugHCPFbIdRiaB4ms7xAuVhQsCgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Vo1Jxgpx0FT4FrMNbu6lLw9KVxIVEVFXYzq3M60JoY=;
 b=XauCs5LVfEdj1tpzix2/uT2iK16EAOqyMkOw2Gl1MANsjjfBsTy/XJh1sVz88C+wxTb9H3XD4kTH8NtAjZcE9Co2fiKMS8EB78Ynusl4atE+bJHHsmCQew408abg+8hM4RjEaZju91CyJ3rlnL5ZPkEiMzyXWvVZfbLrFC2U4dQ=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CO1PR11MB5075.namprd11.prod.outlook.com (2603:10b6:303:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Tue, 18 Jun
 2024 17:36:11 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 17:36:11 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@suse.de>,
        "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>,
        "Masa Kai (mkai2)" <mkai2@cisco.com>,
        "Satish Kharat
 (satishkh)" <satishkh@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 09/14] scsi: fnic: Modify IO path to use FDLS
Thread-Topic: [PATCH 09/14] scsi: fnic: Modify IO path to use FDLS
Thread-Index: AQHau4EKE6NOUxljUk2VOW48qUwIurHDuosAgAoaJqA=
Date: Tue, 18 Jun 2024 17:36:11 +0000
Message-ID:
 <SJ0PR11MB589634E8E1C924A8EFCE7145C3CE2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-10-kartilak@cisco.com>
 <b1ab1878-cdf3-4f8c-8268-bc6b5f6b905e@suse.de>
In-Reply-To: <b1ab1878-cdf3-4f8c-8268-bc6b5f6b905e@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CO1PR11MB5075:EE_
x-ms-office365-filtering-correlation-id: 15e858db-3f2e-4969-2558-08dc8fbd2563
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|1800799021|376011|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?bW9QaytsNm5Uc3Q1UTJnMmlQazlpMnA3UUc4UVhSNWtlTUFqUWsrVkNGYjNv?=
 =?utf-8?B?cng4ZHNVa3FySDBtOEFpVFRqamt4UGpmbm5vamZsVm94RU1kNmxoN25jc3d5?=
 =?utf-8?B?c0VTK2ViWEtSejROS2czK2JOMTdSTUVNMWFKcDRpOG0zajNIZE9MRkdWUjFt?=
 =?utf-8?B?ZUZYZ3hieXgzTzF4L1hBRDI2Nnh2WUhZZmMwc0hTeTRFTk9kRWNsb3NXbXhD?=
 =?utf-8?B?U0NhY3RwdU1udmx4VmQ3Z0JacWFMaTA2WnNBSjFNUFdMZG93WnZqR0xYNkpm?=
 =?utf-8?B?M21oRytNckdaaFdMOWdGV3pSUzhuRmxSRkptUUNWSms2cXlDLzNPMnNRVGp4?=
 =?utf-8?B?OE9UR1FaU0FWYitZOGtOZTgwSDFyWHA4TjNnK2RyL0lXdTdSSVBGMTV2ekRW?=
 =?utf-8?B?ZERCYzVkcDdKUUtVK3hCMEYxM05uM3N6aUdwWUYreVh0MU1zenBvN0NmcmVF?=
 =?utf-8?B?a1A1Y2VqTEM4S01iVjlja2M1eHhjeTg3U0poRDZ0ZC9CdWdza3AydkpsVHZ4?=
 =?utf-8?B?Vnh4TWZmK3ZYRGNlQWdIS0RmN1FxdVFXVEp1T3FYazNrK1dkN2tIcHlVRnpN?=
 =?utf-8?B?dVc3ZndUcDRmN3YvZWlxTGQrWS9GcGdyc0drVFV4b20vWUFrWjczTEo2QmUv?=
 =?utf-8?B?Q05kZHhycUZpbitHQXFXOUc0aVFiR1BiZzEzNEZqaDJaY2ZtK1Z6d2k4SWlM?=
 =?utf-8?B?NlNtUFdlYkd6SFYyZUdXc21UL3ArMmdDWmdtUEpwWmhiMnlXSzdnOCt1Nkl0?=
 =?utf-8?B?a0xsKzd1L0hVNm5oVEpPeVJxa21EYTNxV0I0NFN3V20yRU9ZQzdUUThocWg3?=
 =?utf-8?B?KzIwYjZUUXFMUmY5T2l1ZktEN2JqRjNEV2FCYzRYTlIrempKWDF5SzFpSEY4?=
 =?utf-8?B?dXNKRnJiVkgxVno1TGVVOWRLVFNOYVFEV2lEbTdsRFdPU3loVzQvNnNTSm5P?=
 =?utf-8?B?ekZLYWJ0VTR6TDVZQlF1VFlMOGVmRy9rRW1xNytJRmkxTHlVcGRTM3NlbHIx?=
 =?utf-8?B?ZEU0V21zV1ZFVjdiV3hJTHB6Z3BiUXVwbjFWRmN3OVRRVjJoOGk3YTRoN0Z2?=
 =?utf-8?B?NlFaUy9CNGZvQXhuODNNRDJHc1NVOHN0eHVQeGlzUm90R01SeWNRb3JubG5C?=
 =?utf-8?B?eDhyOXRHTGhvMVZlbFZaR0pzbEpIdVJ5U1lTOVpsVld3TXduUjNOei9DSGVF?=
 =?utf-8?B?TzEvNHkyRjd6d3h2aFZ1RG9CZVVPTEdCMStobS9zSlF0MldST3hVMk12Njg1?=
 =?utf-8?B?ZGxBbGJZT3ZTbGQzai9hUEZRZlVNTmN4Qmw4T29pV0xsbG1rWXRKZmg3dFU2?=
 =?utf-8?B?MWF5N0k3MXhMbUZZLzFyeXU1OFhnaXBEeGdmN3M5OHV3UGdwdEwzS2FqVmgv?=
 =?utf-8?B?V2dyRmVuQ1lkU1drbDVDYVFFRE9WaksxNTJmT0xEbkl4eDZGOG5GaTV6VlpL?=
 =?utf-8?B?cVNacUsyOW5HS3lUMHV4YU1TOTZOV1JSc215MFlSemh5RjZKS0ZyL21rUTcv?=
 =?utf-8?B?U2xiYThUWjRVd1JwdUZZbE45UnpFZ0lidWVxcktOMHZmeEM5N3RtbXU4d2JO?=
 =?utf-8?B?ejFFd0tGOGlTR0VhcXhTTmdibjJQTXl1ZXJPeDc4MmlpREdoMkF3bk9rb25h?=
 =?utf-8?B?cDVtSWIvN0s1K0xKb0plQnBwclZmY0MxT0t3cHhGcTNEUUovQXZxUy9WMzFM?=
 =?utf-8?B?ZWd5TjFPNHNaa1VWMU9MejkralU0TTRCZjM1ZzhjMm8rQm9Jdm9HTU4rTUVP?=
 =?utf-8?B?M3NKTitaVVAzYnM5bllrQlV5dFNqbzM0S0YvZTY4aDFDQVB3TzdwTnlnSlc2?=
 =?utf-8?Q?Ap1Pdhx6Xyep/LyyKKBMUw2JXdhadm1+d97ys=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?djR0dmRkajRWRUxJN1RUb3JmMDFnenYxWUJZK3BETVVLZHI4b004OW9yamYz?=
 =?utf-8?B?VEN2VXc1Lys1WHlNaHN3T3J3NVdYQVl3clFDaWxHYnlJRTQ2c2JROStCSTAy?=
 =?utf-8?B?OXkySm9BeUx3RE5vLzYzTTNhSk1aMGRSZ1Z4MW5ETGVhUGxXc1dPa3JQbExO?=
 =?utf-8?B?MUtDSXpKRzczNzY0WWZtVUxTei85bTJvT2ZOTVk2ckZsY1NLczdhWGJucGRi?=
 =?utf-8?B?R29qT0JIT3l6MTh0Q3FBUnhhZ3kvSkJDU2s3OU50SGc2clY3S2NaaWZMYUg1?=
 =?utf-8?B?blE1SjNRQitIeGp3L0pHMzNmTG0rcHcxY1dVVVI0alF2Mm1lUnFzcHpHdU5u?=
 =?utf-8?B?M0RGd0lzY3BPUHAwUzczWEdoRDEyaDZsOFVTRWcxRW5jMnNyQ3JIVndHc05v?=
 =?utf-8?B?Y2RrUnA1cW50SEY2WlpnUGZjc1dYMGEvWTQrUExvelBNRFpveENkYm1KSWFt?=
 =?utf-8?B?cm1qUUE5TXNnM2RRSnJXbi9FZ1luc1JHTEVnSEc1cC9Dbm5NaXIyZHFGMlho?=
 =?utf-8?B?RmJsbEhKb3E4OGZtOTEyamszTVZ0bU5lcnBUcEFtRy9tTHNiT3UrbXdPdXFz?=
 =?utf-8?B?WnJxRkI1OHAxcHUyRDdlZlJ5MDFhWjBzS0lKOWVSKy9rU2l3ci9qWk5lKy9R?=
 =?utf-8?B?Ni9VYVlEY1k3aUdWRithZ1cyTmxGMEwxZTFIN1Z1cDhqNWJMbzFmRWcwd0ZS?=
 =?utf-8?B?MDJMcmVabnUyQktHRFZGYmQ1K3p5VXdNeXMwUFdHNXVOVUppTlFuSjh1VUFw?=
 =?utf-8?B?KzZDbERRMVZWSExuKzUvNVMwQmFJNi9aNG5jTGM4VE5FdWhhZFBSbWNSQ1B6?=
 =?utf-8?B?b0tGZmlla0Z1KzgzYUE2bWlQMVZKemdxYkF3ZkZYN3dzWlhoVW9Uem9XY24z?=
 =?utf-8?B?ZmFrM21BQkY4RG1IdmQxc2xmK0NTQzZ3dExUSE1GVW8zMVBHVjB4V0JIczVQ?=
 =?utf-8?B?SFdYdkJKV05ZYzNkRFQ1anRtbkRtbFJoc3JJUmp2d3Y0YnhQa3dmZC9qYU9a?=
 =?utf-8?B?d1VJT0toaGNHNmV3ODRET1h4SEEyeUtCelBVc2JxMkI3YnJwbmx5Snc2MVVo?=
 =?utf-8?B?RVpTSFhQR2ozWjVqYjlQeG1FR0IxNEFYQ1RaV1I0akljUEdxVFh4SjV5VC9K?=
 =?utf-8?B?ZE5IQnVGbEJKNEF3YUpjeVJtQ0VGZko0cEE3NEFyYUdySVBISnB3Y2VHeStn?=
 =?utf-8?B?Tmt1TG5qZG9nZEFtbXRkM2pzZ0xXYnRzalVoMEFNMWVtU0c2Smc5blJtK1o5?=
 =?utf-8?B?ZUZCbXhsQmh4bUc0Q2hmc3Nxam54Z1RsNi9tZXpBOXFid1kvSWpSTHhQeUdv?=
 =?utf-8?B?c1FxOCsxMlpUVW41eld6NE04SVRhOHpSWGk3US9jUklVSHRqSzJhWVkzbmJK?=
 =?utf-8?B?R0NFT0xwUmVNdURhdFM3b1RoNDJSY0VWTFhHbitRWlUxMWFhajhuMWw0ZVBQ?=
 =?utf-8?B?VE1WQTlRZTZKK3JBL0MrdmtjWVVGZm02WkZ2cldiaXFIdUtUSllDcFBWQkxR?=
 =?utf-8?B?QytsKzFPRkQyNmRzbjNrbm1FclJpRWl4OE9YckZLMzdmNGFqYTdXdDRDTDhE?=
 =?utf-8?B?WmdvaU9sSHdmTDEzc3NEUW1HUnZFNGZYbEw5OFZYeDczTXNXTXB6SXhxZHJu?=
 =?utf-8?B?bjVmK1N5OTBta2gvanloWHc0UGFsVDZ0aGF4UHFJQXdudWc1OWZqenZxM3BJ?=
 =?utf-8?B?UytabnBVa2FNTGFpKzIxQ0xJNVJ6cTRFYUp1THpORzNEQ2drMHV0SVh0MytD?=
 =?utf-8?B?MnRnL21RM1IvMnhQT0hEV253cDBFVndjNTl4ZmNPOTVhdjVKM21SOUY0MldY?=
 =?utf-8?B?OU5uWVRmVG1EWHpZNEM3Uk9LN1VxdlhWOCs5K1pXSCs1Q2RLVXpDSkpqMjJy?=
 =?utf-8?B?Vk1BclEwQXVXTGI5blUxZm8wVzR5OFp6eU1DMmJIaUZZR3JHWElva0NmbGZ0?=
 =?utf-8?B?VnNCdGQ3NFRsZStCYy9WcENvOTUrQUNOSXhUa044cFdoYks1djUzaTBEQis0?=
 =?utf-8?B?eHNJc0g4VVRJMWRhMUp1L1FsT28zYm9nSmNHQS9ZdS9HcE1OZkdjdVhOZUdS?=
 =?utf-8?B?TmhNL2VJV1FYVXRDWEpvM01mRWNFL0NhSmtWUW9XdFUxdE5tck9kQ01yWnJT?=
 =?utf-8?Q?Cc50c3U7/QMwQzSzaW5l6+H6s?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e858db-3f2e-4969-2558-08dc8fbd2563
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 17:36:11.8118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 79Av/FISHxjc2NeG1RU8Czs+LMC6xU9JT5GxJwERn8B/h6omj4/sq1B+ep2RCk5f2O/c3ooCaS6JQR1o9cwN5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5075
X-Outbound-SMTP-Client: 72.163.7.169, rcdn-opgw-5.cisco.com
X-Outbound-Node: alln-core-6.cisco.com

T24gV2VkbmVzZGF5LCBKdW5lIDEyLCAyMDI0IDEyOjE5IEFNLCBIYW5uZXMgUmVpbmVja2UgPGhh
cmVAc3VzZS5kZT4gd3JvdGU6DQo+DQo+IE9uIDYvMTAvMjQgMjM6NTAsIEthcmFuIFRpbGFrIEt1
bWFyIHdyb3RlOg0KPiA+IE1vZGlmeSBJTyBwYXRoIHRvIHVzZSBGRExTLg0KPiA+IEFkZCBoZWxw
ZXIgZnVuY3Rpb25zIHRvIHByb2Nlc3MgSU9zLg0KPiA+IFJlbW92ZSB1bnVzZWQgdGVtcGxhdGUg
ZnVuY3Rpb25zLg0KPiA+IENsZWFudXAgb2Jzb2xldGUgY29kZS4NCj4gPiBSZWZhY3RvciBvbGQg
ZnVuY3Rpb24gZGVmaW5pdGlvbnMuDQo+ID4NCj4gPiBSZXZpZXdlZC1ieTogU2VzaWRoYXIgQmFk
ZGVsYSA8c2ViYWRkZWxAY2lzY28uY29tPg0KPiA+IFJldmlld2VkLWJ5OiBBcnVscHJhYmh1IFBv
bm51c2FteSA8YXJ1bHBvbm5AY2lzY28uY29tPg0KPiA+IFJldmlld2VkLWJ5OiBHaWFuIENhcmxv
IEJvZmZhIDxnY2JvZmZhQGNpc2NvLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYXJhbiBUaWxh
ayBLdW1hciA8a2FydGlsYWtAY2lzY28uY29tPg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9zY3Np
L2ZuaWMvZm5pYy5oICAgICAgIHwgICAyMCArLQ0KPiA+ICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5p
Y19pby5oICAgIHwgICAgMyArDQo+ID4gICBkcml2ZXJzL3Njc2kvZm5pYy9mbmljX21haW4uYyAg
fCAgICA1ICstDQo+ID4gICBkcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYyAgfCAxMTA3ICsr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tDQo+ID4gICBkcml2ZXJzL3Njc2kvZm5pYy9m
bmljX3N0YXRzLmggfCAgICAyIC0NCj4gPiAgIDUgZmlsZXMgY2hhbmdlZCwgNjgwIGluc2VydGlv
bnMoKyksIDQ1NyBkZWxldGlvbnMoLSkNCj4gPg0KPg0KPiBXZWxsLiBUaGlzIHBhdGNoIHJldmVy
dHMgYmFzY2lhbGx5IGFsbCBjaGFuZ2VzIEkgZGlkIHRvIHRoZSBmbmljIGRyaXZlciBpbiBjb252
ZXJ0aW5nIGl0IHRvIHVzZSB0YWdzZXQgaXRlcmF0b3JzLg0KPg0KPiBQbGVhc2UgdXBkYXRlIGl0
IHRvIHN0YXkgd2l0aCB0YWdzZXQgaXRlcmF0b3JzLg0KPg0KPiBDaGVlcnMsDQo+DQo+IEhhbm5l
cw0KPiAtLQ0KPiBEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgICAgS2VybmVsIFN0
b3JhZ2UgQXJjaGl0ZWN0DQo+IGhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgNCj4gU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwg
RnJhbmtlbnN0ci4gMTQ2LCA5MDQ2MSBOw7xybmJlcmcgSFJCIDM2ODA5IChBRyBOw7xybmJlcmcp
LCBHRjogSS4gVG90ZXYsIEEuIE1jRG9uYWxkLCBXLiBLbm9ibGljaA0KPg0KPg0KDQpUaGFua3Mg
Zm9yIHBvaW50aW5nIHRoaXMgb3V0LCBIYW5uZXMuDQpTdXJlLCBJJ2xsIG1ha2UgdGhlIHJlcXVp
cmVkIGNoYW5nZXMgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KUmVnYXJkcywNCkthcmFuDQo=
