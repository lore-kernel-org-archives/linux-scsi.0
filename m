Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="N+zIVGA7";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="iyVINRjq"
Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5BA19E
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 13:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=732; q=dns/txt; s=iport;
  t=1700600795; x=1701810395;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JZo4NXmSbfz0G5wNwmxK8/bZyGIqF+V7xg1dYdzJLPw=;
  b=N+zIVGA7VGJsQWAJp/GbYvYDXxA9iX3RKtnpdLSQ7WYIRQEf81PYvw//
   61vu/n4tKI8NYwoev9aEPxg+2VM6jg7HbWAPeHqqSyh7TgbW7xu5i5iPo
   i7NA6kX0LB3kwpPADAtvvduYuMI4xr2pTwzlhanWmq039I8TKjVvsqWCF
   8=;
X-CSE-ConnectionGUID: MQ/UyZLdS2eGdRc6+358Ug==
X-CSE-MsgGUID: Kexz4mAiRNKjW7cKsJej1w==
X-IPAS-Result: =?us-ascii?q?A0AZAACYG11lmJxdJa1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEWBwEBCwGBZlJ4WzxIhFKDTAOETl+GQYIlnX4UgREDVg8BAQENAQFEBAEBh?=
 =?us-ascii?q?QYCFocSAiY0CQ4BAgICAQEBAQMCAwEBAQEBAQECAQEFAQEBAgEHBBQBAQEBA?=
 =?us-ascii?q?QEBAR4ZBQ4QJ4VoDYZFAQEBAQMSEREMAQE3AQ8CAQgOCgICJgICAjAVEAIEA?=
 =?us-ascii?q?Q0NGoJegl8DAaFtAYFAAoooeoEygQGCCQEBBgQFsm4JgRouAYgMAYFQhAmEN?=
 =?us-ascii?q?Scbgg2BV4JoPoJhAoFHG4NZOYIviSQHMoIig1GBEo1WCXYEQ3AbAwcDfw8rB?=
 =?us-ascii?q?wQwGwcGCRQtIwZRBCghCRMSPgSBYIFRCoECPw8OEYI9IgIHNjYZSIJeFQw0S?=
 =?us-ascii?q?nYQKgQUF4ESBGoFFhIeNxESBRINAwh0HQIRIzwDBQMEMwoSDQshBRRCA0UGS?=
 =?us-ascii?q?QsDAhoFAwMEgTYFDR4CEBoGDCcDAxJNAhAUAzsDAwYDCzEDMFVEDFADbh82C?=
 =?us-ascii?q?TwPDB8CGx4NJyUCMkIDEQUSAhYDJBYENhEJCysDLwY4AhMVBgYJFgNEHUADC?=
 =?us-ascii?q?209NRQbBQQ7KVkFoliDAD8uZJVHSa40CoQNoUAXg26mF4dukFIgon+FDAIEA?=
 =?us-ascii?q?gQFAg4BAQaBYzqBW3AVgyJSGQ+OIBmDX495djsCBwsBAQMJimEBAQ?=
IronPort-PHdr: A9a23:OJcZzhIoc9sBeZOS2NmcuakyDhhOgF28FgcR7pxijKpBbeH/uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1o2t2qjPx1tEd3lL0bXvmX06DcTHhvlMg8gJe3vBo/Whsef3OGp8JqVaAJN13KxZLpoJ
 0CupB7K/okO1JJ/I7w4zAfIpHYAd+VNkGVvI1/S1xqp7car95kl+CNV088=
IronPort-Data: A9a23:0oPQKapCDrorFyVi9ubgnCt7USNeBmIaZRIvgKrLsJaIsI4StFCzt
 garIBnUa/uCZTekLY9yPoi+oEhTv5KBzYRkHFRlrCk8QitE9OPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7wdOCn9T8ljf3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYAPNNwJcaDpOsPva8ko35pwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86rIGaRpz6xE78FU7tJo56jGqE4aue60Tum1hK6b5Ofbi1q/UTe5EqU2M00Mi+7gx3R9zx4J
 U4kWZaYEW/FNYWU8AgRvoUx/yxWZcV7FLH7zXeXlPXU8lz0V3fXmfhBAHs9Y85Dp7ZKDjQbn
 RAYAGhlghGrnem6xvewTfNhw5llJ8jwN4RZsXZlpd3bJa95GtaYHOObvpkBgWlYasNmRZ4yY
 +IaYCBzbRDJYDVEO0wcD9Q1m+LAanzXKmED+AnK/vFvi4TV5C98wKqxNfPUQPqpR/oKlWWDh
 G/EpnusV3n2M/TElGLaqSjz7gPVpgv/WYQPBPij/eVrqEOcy3ZVCxAMU1a/5/6jhSaDt8l3M
 UcY/G8lqrI/sRHtRdjmVBr+q3mB1vIBZzZOO8gDrzyc+I7Y2FyUKWQ+RWACM4F2icBjEFTGy
 WS1t9/uADVutpicRnSc6qqYoFuO1c49czZqicgsE1Nt3jXznLzfmC4jWTqKLUJYpsf+FTe1y
 DeQoW1jwb4SlsUMka68+DgrYg5ARLCXF2bZBS2OAgpJCz+Vgqb5PeREDnCHtZ59wH6xFAXpg
 ZT9s5H2ABoyJZ+MjjeRZ+4GAauk4f2IWBWF3gY3Qsh4q2r9qib9FWy13N2YDBkzWirjUWGxC
 HI/RSsIvPe/wVPzNPAoPdrpYyjU5fKxTI2Nug/ogipmOcUpK1Tdo0mClGab3nvmlwA3gLojN
 JKAOceqBjByNEiU5GTeegvp6pdynnpW7TqKHfjTlk37uZLAPyT9YelebzOzghURsfnsTPP9q
 YgPbqNnCnx3DYXDX8Ug2ddKdghTdShiWMyeRg4+XrfrHzeK0VoJUpf56bggYIdi2a9Sk4/1E
 ruVASe0FHKXaaX7FDi3
IronPort-HdrOrdr: A9a23:8m/h26EfQCIs3s7epLqFrZLXdLJyesId70hD6qkvc203TiXIra
 CTdaogtCMc0AxhKU3I+ertBEGBKUmsjKKdkrNhTYtKOzOW9ldATbsSorcKpgeQeREWmdQtqJ
 uIH5IOb+EYSGIK8/oSgzPIUurIouP3jJxA7N22pxwCPGQaD52IrT0JdTpzeXcGPDWucKBJbq
 Z0kfA33AZIF05nCPiTNz0uZcSGjdvNk57tfB4BADAayCTmt1mVwY+/OSK1mjMFXR1y4ZpKyw
 X4egrCiZmLgrWe8FvxxmXT55NZlJ/K0d1YHvGBjcATN3HFlhuoTJ4JYczAgBkF5MWUrHo6mt
 jFpBkte+5p7WnKQ22zqRzxnyH9zTcV7WP4w1PwuwqgnSW5fkN+NyNyv/MfTvLr0TtngDi66t
 MT44utjesSMfoHplWk2zGHbWAwqqP+mwtQrQdatQ0sbWJZUs4QkWTal3klTavp20nBmdoaOf
 grA8fG6PlMd1SGK3jfo2l02dSpGm8+BxGcXyE5y4aoOhVt7ThEJnEjtYcit2ZF8Ih4R4hP5u
 zCPKgtnLZSTtUOZaY4AOsaW8O4BmHEXBqJaQupUBjaPbBCP2iIp4/84b0z6u3vcJsUzIEqkJ
 CEVF9Dr2Y9d0/nFMXL1pxW9RLGRnm7QF3Wu4xjzok8vqe5SKvgMCWFRlxrm8y8o+8HCsmeQP
 q3MII+OY6rEYIvI/c+4+TTYegkFZBFarxhhj8SYSP7nv72
X-Talos-CUID: 9a23:bx+AbmPZQN/Giu5DfRAgyV8mPsweKHDywE3bfQzjVDZUR+jA
X-Talos-MUID: 9a23:0OS20AV/6JF1/YHq/BzhlCM+Me5p2YKNCn9SmrYdmcSGbDMlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 21:06:13 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id 3ALL6CQ3027392
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 21:06:13 GMT
X-CSE-ConnectionGUID: d94BOOQARtmDCSScaHUx1Q==
X-CSE-MsgGUID: wP1sM+JlRZOqRsv5FfwqBQ==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=quarantine dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.04,216,1695686400"; 
   d="scan'208";a="9610912"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by alln-opgw-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 21:06:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYQW0tKhOlVWIEfkr4NEcASzoFVm+BYyUN2TmSsBLLM/V036vUY/+UktwzuvMhqKZZDC2eA56V9D3SU+o1BX84ZjSY7VGcd8qD7NoIIuHzogk/neDUVWxDTVaRVWEElM27+o2U9HJzqFtRVWhTFWidw0zKKtsLN2mlpCJbjMFfIogHiBd8TVZya1TF+8QDjy++tK1oJkxkEBLqt5wxD3nYbnYUeVXhnRx84OQKqwpSvSn7Fzgfqownf7z+9aSt+bwzVD/sJ8aTIrLRz/Qp42K3xOULxPxqM85MlguSVj7NXLkuuNwbJ4CxEa25SO4TeHI6erf6Z0fBW0HkcPfhcH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZo4NXmSbfz0G5wNwmxK8/bZyGIqF+V7xg1dYdzJLPw=;
 b=UTvZx+m1hv/KEHRgKArVgBHCUXswhk75YmoUCyv+NONMtKmns1Ci7kWgAEgaLEoFBg5GHtIJgIjdtiZKXKfqMjKtWy/2LyX93WZ143E+JDFhdT5AYYPWQtXRQKsZBOUu8kvpx7pPh0tL3RSMO3tVy9eMGI2NmKMEIzd804KPwG+VWMudS7vzJfAaahNy0MOrK3NTE2cOYr11vwTOCSQHsx79nAvhp2+1TMEIG0XcSUtqrF/Oy5N8X+nPOzJNTGLhjPV2y/OoY3hYqlB1jvYg/g4Z8dX9JW+Qjkc/2zT0D418LKF6qKg0HN97MSLR9pD3329WWb89kLhw/cHZAiGaPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZo4NXmSbfz0G5wNwmxK8/bZyGIqF+V7xg1dYdzJLPw=;
 b=iyVINRjqShXVw5Vwu+Uj3cjx3G+yhfBIReTSxvzYfDzdbht+UgJMROGxvueNsXy27aSHyqCmgiQ0gE/OjFKGqtgMroI/axWe4xw/FbEpiJsag82+ZyhrUfsMkTMR9m/NX5rc9aOet+q789wlmdkq5EHfS1Vx1pF0yKuC6cLJ1UQ=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH0PR11MB4821.namprd11.prod.outlook.com (2603:10b6:510:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Tue, 21 Nov
 2023 21:06:10 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022%7]) with mapi id 15.20.7025.017; Tue, 21 Nov 2023
 21:06:10 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley
	<james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
        "Masa Kai (mkai2)"
	<mkai2@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>
Subject: RE: [PATCH 13/16] fnic: allocate device reset command on the fly
Thread-Topic: [PATCH 13/16] fnic: allocate device reset command on the fly
Thread-Index:
 AQHaBkb42cCL+heyGUeyjm7ciZVVH7BtxXAwgAtnMMCAAGhugIACobVAgAMYeqCAA7CpAIAA89uwgABCuqCAATlnwA==
Date: Tue, 21 Nov 2023 21:06:10 +0000
Message-ID:
 <SJ0PR11MB5896AFB0C83B31D4BE4758A0C3BBA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20231023091507.120828-1-hare@suse.de>
 <20231023091507.120828-14-hare@suse.de> <20231024065427.GD9847@lst.de>
 <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58960463A1A9D634BE8D2A62C3B2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <a5df8cc9-34c4-4448-817f-0f61f4a493de@suse.de>
 <SJ0PR11MB5896E596C922936ABDDE0567C3B0A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58961DC466F1FC2DAD8825F6C3B7A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <2d5071d6-daab-4585-823f-5f2e9dde8f79@suse.de>
 <SJ0PR11MB5896DCA2219FD8C0047B5C13C3B4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB5896D94B10745BFD3BB2BDFBC3BBA@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To:
 <SJ0PR11MB5896D94B10745BFD3BB2BDFBC3BBA@SJ0PR11MB5896.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH0PR11MB4821:EE_
x-ms-office365-filtering-correlation-id: 302f96cb-6526-4ebe-218e-08dbead5b030
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 pyQo3UebKHmFga90EHou7TUcgOoiNMWyJ2btV+5VqQ0HO7OGLahfM80Kw20c6twLRf5txY3etO00CbjuzLI4lk31tECeifSd6sHobF2oozPPg0h5M0eclf/DBiRc2x92Eajs5LzwVDmH91NgYzAlUrFC3HwXYDjXLvQJHqp+QPjBMOSCDy5SNkVIKBbO/dggPCS7wMlCIhCJ4RfXqfoubavncNAhVT4sINgenQLx1S6DtQ97mmWldeolxlfVa3+FAEfVBCVXRubhX7iKNZ84qxnaEePmiKj1wjFv+0mJyOIBzaO2LXqlINR2BjlFx+vxqB+kakA3hy+gDU57lfWiis0Exy0wRSXaLhX565xKQ9fgSX1ZvpfzvZ5MbGLG1MXIepjeFqb2lw8D78twd33GDmSF31rtBOLZvtWo3ZR/yf2llVAromn1KUOS2vGTpmC/zbTk2NuLhXqEv7SZyNAuAnx8OaBTSvCqCK/R2WWnagOMFVJ1sto8q+GESsLKbp+odx2U0EhIeqxKUnjJ7h+AYK6kQK/sOA9Enj30ETmtrQrqRA9zhkx9BarXFCdne4WPPJ7+9Wt3gywOlxNnRCk68NX6rQEe8TYpu+wORZEMLLiUqOKyxvZkK5R3H8CT/krq
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(136003)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(55016003)(83380400001)(2940100002)(107886003)(71200400001)(6506007)(53546011)(7696005)(9686003)(478600001)(38100700002)(110136005)(66946007)(2906002)(8676002)(8936002)(4326008)(66556008)(66476007)(54906003)(316002)(64756008)(66446008)(5660300002)(86362001)(4744005)(33656002)(76116006)(38070700009)(122000001)(41300700001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S1VMWmpMRmtWZGZxdDI0N1R2SGh2VnQ1NXc5RUFPdndyZk9wc3ZDWU1DYytO?=
 =?utf-8?B?WE05NUtiYTVJOTBFd05IdWszY3FWYk95bGllV2VMUk1qTWRDQXBNaEJWbVV2?=
 =?utf-8?B?USswRk1ESjhFbnk1eUlIVG9sVUUzaWtoeHF6YWR3YnpGdXhSeEJvbzlkSTRx?=
 =?utf-8?B?alFrNHEwSEg5TFVZc0VGT0JxWFlIUVRycFQ2MWYrU2VlVXQvWkdxOG8zVFgv?=
 =?utf-8?B?OGZSRWNEUDFENDZmMGNqNFhDeTBnUmVQdmdUNXg4cVZ5RWpBKzN2bmEvRkRl?=
 =?utf-8?B?NkZ3aWtYbS83eVEyMEI2RHZOb3dNaWpZVHZEUkliZ3hGd29FYjZKZGxmWjlR?=
 =?utf-8?B?V1VWeWNWcFdXbVFVN3RyWVRlOGhKV3BCTW5iT2tmL0FVa291SjUxRWRNaDRm?=
 =?utf-8?B?Y2l5Nm9JVytqQXQ3L3lPVS8zSk1ZbmJvMWNiL1U2MG1JcGwxY3Rackd5SDIz?=
 =?utf-8?B?d25ldG1aMmY1TjVjMDliV2VFZG00K1VYUkhZR2thYVJSdFpTY3JuOVpaMXhk?=
 =?utf-8?B?SVIrT2pKbjg1cCtFL29aSjlCRzZ6ellPcmg2c1VvSy9lMDhyRmN2RytxaFJM?=
 =?utf-8?B?dDlCaVFqWnpIL2FwSFJ4SjVKRFBFbHRGbU5yTnJ2Wk9RM3loMkFDajIvYmpK?=
 =?utf-8?B?WCswcWJkci9GY1NOSVVTVzI4clhGM3NtMStVSFJGbVVSdE03MFpYcFBpVlZY?=
 =?utf-8?B?d3VpMmZjMnB5YWw1TDc5dkljdFpCMjVRNGJ5a2lvUGVPODExNE9jWlI2VGlR?=
 =?utf-8?B?KzFVUmpPMjFRTVB6dDJkL3R1MWMzZDYyZGx1MW1LT0k4OURJVUFBam1Dd0tt?=
 =?utf-8?B?MGVxdEJ6enhZaW1uOEp1VUN2bTFDa05xSnluQXp5NGRWaEoxcU8xZkQ1ZStH?=
 =?utf-8?B?TXBOdi9vQUdDR3kwRGYwcWt4cW91YUxBb1I5cUEreGgrSkcvUGJHTUEvaWVX?=
 =?utf-8?B?WjVGWkdISlZPYmRaL3Nsa2psbGs4TmsyNGpWcmsxemtHSTZBSHU0YjhwYmtX?=
 =?utf-8?B?THVRZk9Maytrbk9Jd0Nkc0xEblExV1Q4eTVjcmZDVnZSR0pDNzZGS25KQkpj?=
 =?utf-8?B?SzFNWEpIUno4aXR1QlFsa1pBdHRZZXVMbUYwN1IyWm5IRG1QMXhhaHZ5MEla?=
 =?utf-8?B?VjNlRks3NzY3b0t4TG9oWFc0OE1LQUJhSTh3bm1XZjZabjNPazJ0RWxWbFlo?=
 =?utf-8?B?dnRUaGx3K2lZWXZzR2d4WVc4cDl0aVZkUUxmaDhzUklDSzV6SjRqbTJEZjkw?=
 =?utf-8?B?dnJnWE9OV3YycjZpU3hORDBsamNaaUZxS0tCNWRqOForMmRPZU52MU9yb2VX?=
 =?utf-8?B?dzVXdUxyYmdyQXVJMGNwbVJQQUpRN3pRTFRNUlJ1MjNYcnNnUGtMVEVTaHND?=
 =?utf-8?B?SmZxK292TzA3aGx5WGJuMXByeWJ6S2xtRXFFRVhBUWRqOXFuVnVlS0U3VnFs?=
 =?utf-8?B?aGR6YXo5N0J0UmFEY1QrWTlXR01QbmZPbStGbWg4ak8zNEpUU29UZnpUb01v?=
 =?utf-8?B?TlJ2c3BxcVVSL1lHaGZ1N0N3R1VpU01CYVR1VWxBcTJFL09ObEZsSHFNSDhi?=
 =?utf-8?B?ZjBrSG82STUyMkJSUlg4dDk2OVBFVk1WdjVmajJnNDk4b2NjVXdkWTNXRTNp?=
 =?utf-8?B?YnhUMnlmbnRhZVpKU1pTbFNxeUhEYVRzQUtRbWdPVFB5TXd4VGV0NkRFSjV6?=
 =?utf-8?B?RldNQS91bzFmZmhweFpOT3poNUtnMHV2SVd6ZHNGNzlYNndyaUgwd3FVVjNP?=
 =?utf-8?B?eWhSSjB3ZzdtOGw1MkNSWFcySlk3cjRTMDZOTXRDdzBmQWJzOHprZmxMdWJv?=
 =?utf-8?B?ZDdmT1VYdElZYzkvRS9VTGN4SFRvb05iSlFGaG5YSDBwNm1TT3gvbUVpRWVN?=
 =?utf-8?B?aitNRnRydmFCa1pBeGMzdExFd3Z0ZnFMR3dOd0l6V2JDQWZ5c2dtVlNWVG9t?=
 =?utf-8?B?OVZMQWRzOWRCclBxTDFyMjhoOVZyZjByMmk4R3RtVkYxQ0hrM2FzRXJyVHVs?=
 =?utf-8?B?QVF6WG1sK0E3ZVkzTll6Q2hRY0U1dEhqOCtSays4dFN1TXZpUFJ3bnNXellq?=
 =?utf-8?B?Uy9aWm53c3IwUmpYVTFEay9zVXFZVTdjWFFBUkVGODVib0RZNXZjRlVhZnp5?=
 =?utf-8?B?VndXRUV1Q3REUHRnbGtFWXJPZjY4bnJUU3UrQlNMYjlsUEpSWXhNWm5yQzND?=
 =?utf-8?Q?m6wBbELMOG4cNGVgg/abQvMom9O99zXCo2h7WyDo8lWJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 302f96cb-6526-4ebe-218e-08dbead5b030
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2023 21:06:10.7438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v4qvEcxLaKo+100GR7eJDY0Kp8UfuIn4KiJkddmewcVxGu4r/ODM1jwGH8p0hBABbvqvq0nV+9h3Ek1XMUyp6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4821
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: rcdn-core-5.cisco.com

T24gTW9uZGF5LCBOb3ZlbWJlciAyMCwgMjAyMyA2OjI0IFBNLCBLYXJhbiBUaWxhayBLdW1hciAo
a2FydGlsYWspIHdyb3RlOg0KPg0KPiBPbiBNb25kYXksIE5vdmVtYmVyIDIwLCAyMDIzIDI6Mjcg
UE0sIEthcmFuIFRpbGFrIEt1bWFyIChrYXJ0aWxhaykgd3JvdGU6DQo+ID4gPiBNYXliZSBmb2xk
IGl0IGluIHdpdGggeW91ciBwYXRjaHNldCAoaWYgaXQncyBub3QgYWxyZWFkeSBtZXJnZWQpLg0K
Pg0KPiBTdXJlIEhhbm5lcy4gVGhlIHBhdGNoc2V0IGlzIG5vdCBtZXJnZWQgeWV0Lg0KPiBJJ2xs
IG1ha2UgdGhlIHJlcXVpcmVkIGNoYW5nZSBhbmQgc2VuZCBvdXQgVjQuDQo+DQo+IFJlZ2FyZHMs
DQo+IEthcmFuDQo+DQoNClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhpcyBvdXQsIEhhbm5lcy4NClRo
ZSBNUSBjb2RlIGhhcyBjb3JyZWN0ZWQgc29tZSBtaXNzaW5nIHVubG9ja3MuIFRoZXJlZm9yZSwg
dGhpcyBwcm9ibGVtIGRvZXMgbm90IGFwcGVhciB0byBiZSBpbiB0aGUgVjMgcGF0Y2ggc2V0Lg0K
DQpSZWdhcmRzLA0KS2FyYW4NCg==
