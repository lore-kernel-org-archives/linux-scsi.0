Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="WPHIs6CB";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="csNMnhKY"
Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25B09C
	for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 18:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=362; q=dns/txt; s=iport;
  t=1700533446; x=1701743046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bk3Xt8DPCEkVHBL0L+JC+gubV0bUerYkUmI5Bg6vnxE=;
  b=WPHIs6CBOHBobPgAhiWMY5BrIVINzJNfML3NYOvP405DBL2lKhDQh3bT
   4X4mpBpGuwHRYqSq5wSMEaOoCk6Jl0yVtrF11DgFOuEhkmDPYfzgHKK8J
   ijXfIVZMhFvqn+lLjso18Z1EQDIINKrfMcmQoR9D1nbKsrZ5WvQDt2Z7F
   Y=;
X-CSE-ConnectionGUID: 1dkR6ex7Rc6Zd9zikRqoKA==
X-CSE-MsgGUID: kCxsabbIQ3OQgqyg4OE7Bg==
X-IPAS-Result: =?us-ascii?q?A0AbAAA4E1xlmJtdJa1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEWBwEBCwGBZlJ4WzxIhFKDTAOETl+GQYIlnX4UgREDVg8BAQENAQFEBAEBh?=
 =?us-ascii?q?QYCFocSAiY0CQ4BAgICAQEBAQMCAwEBAQEBAQECAQEFAQEBAgEHBBQBAQEBA?=
 =?us-ascii?q?QEBAR4ZBQ4QJ4VoDYZFAQEBAQMSEREMAQE3AQ8CAQgOCgICGQ0CAgIwFRACB?=
 =?us-ascii?q?AENDRqCXoJfAwGgbQGBQAKKKHqBMoEBggkBAQYEBbJuCYEaLgGIDAGBUIQJh?=
 =?us-ascii?q?DUnG4INgVeCaD6CYQKBRxuDWTmCL4klBzKCIoNSgRKNPwl2BENwGwMHA38PK?=
 =?us-ascii?q?wcELRsHBgkULSMGUQQoIQkTEj4EgV+BUQqBAj8PDhGCQCICBzY2GUiCWxUMN?=
 =?us-ascii?q?Ep2ECoEFBeBEQRqBRYTHjcREgUSDQMIdB0CESM8AwUDBDMKEg0LIQUUQgNCB?=
 =?us-ascii?q?kkLAwIaBQMDBIE2BQ0eAhAaBgwnAwMSTQIQFAM7AwMGAwsxAzBVRAxPA2sfN?=
 =?us-ascii?q?gk8DwwfAhseDSclAjJCAxEFEgIWAyQWBDYRCQsrAy8GOgITGQNEHUADC209N?=
 =?us-ascii?q?RQbBQQ7KVkFokKDPy5klUdJrjQKhA2hPxeDbgGmFodukFIgqAsCBAIEBQIOA?=
 =?us-ascii?q?QEGgWM6gVtwFYMiUhkPjiAZg1+PeXY7AgcLAQEDCYphAQE?=
IronPort-PHdr: A9a23:1Nv/XBzKtRcwlnTXCzMRngc9DxPP853uNQITr50/hK0LLuKo/o/pO
 wrU4vA+xFPKXICO8/tfkKKWqKHvX2Uc/IyM+G4Pap1CVhIJyI0WkgUsDdTDCBjTJ//xZCt8F
 8NHBxd+53/uCUFOA47lYkHK5Hi77DocABL6YAl8PPj0HofRp8+2zOu1vZbUZlYAiD+0e7gnN
 Byttk2RrpwPnIJ4I6Atyx3E6ndJYLFQwmVlZBqfyh39/cy3upVk9kxt
IronPort-Data: A9a23:18V/z6Ljoc8XuebzFE+R05UlxSXFcZb7ZxGr2PjKsXjdYENS3jJVy
 GROXm+DOqmDZWf8KI1/bIm1oUoDu5PVm9NiT1Md+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcYZsCCea/0/xWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVvR0
 T/Oi5eHYgT8gmQtajt8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKmWDNrfnL
 wpr5OjRElLxp3/BOPv8+lrIWhFirorpAOS7oiE+t55OLfR1jndaPq4TbJLwYKrM4tmDt4gZJ
 N5l7fRcReq1V0HBsLx1bvVWL81xFfRK+4WZLGjgi8fN/UGXYXrv+expL2hjaOX0+s4vaY1P3
 eYTJDZIZReZiqfqhrm6UeJrwM8kKaEHPqtG5Somlm6fXK1gGM2eK0nJzYcwMDMYhclUAffab
 skxYjt0ZxOGaBpKUrsSIMtix7/12CenIlW0rnqWjros6mLZ7TUq94HiKcvaJvunGu9ayxPwS
 mXupDmhXUpAa7Rz0wGt9nOqm/+KhijgWaoMG7CisP1nmluewioUEhJ+aLegieOyhkj7UNVFJ
 glIvCEvtqM1skesS7ERQiFUvlbdsh0mBddATNcxtjOBm7jV4DyAAUstG2sphMMdiOc6Qjkj1
 1msltzvBCByvLD9dZ573unNxd9VEXZNRVLudRM5oR05D84PSbzfYzrVRdplVaWylNCwRXf7w
 iuBq241gLB7YS83O0eTowyvb9GE/8ShousJCuP/BTLNAuRRONfNWmBQwQKHhcus1a7AJrV7g
 FAKmtKF8McFBoyXmSqGTY0lRe7xv6vdbWWD2wY/R/HNEghBHVb9J+i8BxkgfC9U3josIGeBj
 LL74FoOu8ELZBNGk4ctM9/vYyjV8UQQPY+4Dq+PNIUmjmlZfw6c9yYmfl+Lw23oiwAtl6p5U
 ap3gu7yZUv2/Z9PlWLsL89EiOdD7nlnmQv7G8uhpzz5iuX2WZJgYepfWLd4RrpnvPrsTcS82
 4s3CvZmPD0ECrShM3iKq9BLRb3IRFBiba3LRwVsXrfrCiJtGXoqDLnaxrZJRmCvt/49ejvgl
 p1lZnJl9Q==
IronPort-HdrOrdr: A9a23:bcZWHavx0CwqaPaNQuBHa8Ja7skCM4Aji2hC6mlwRA09TyXGrb
 HMoB1L73/JYWgqOU3IwerwSZVoIUmxyXZ0ibNhRItKLzOWyFdAS7sSo7cKogeQVBEWk9Qtt5
 uIHJIOdeEYYWIK6voSpTPIberIo+P3sZxA592us0uFJDsCA8oPnmIJbjpzUHcGOzWubqBJbK
 Z0k/A33QZIDk5nFfhTaEN1OdTrlpngrr6jSxgAABIs9QmJih2VyJOSKXKl9yZbeQlihZM5/0
 b4syGR3MieWveApSP05iv21dB7idHhwtxMCIinkc4OMAjhjQ6uecBIR6CClCpdmpDt1H8a1P
 335zswNcV67H3cOkuvpwH25gXm2DEyr1f/1F6jh2f5q8CRfkN5NyMBv/MdTvLq0TtmgDhO6t
 MM44tfjesPMfr0plW42zEPbWAzqqP7mwt4rQdZtQ0tbWJXUs4ikWVYxjIULH/FdxiKtbzO14
 JVfZvhzecTflWAY3/DuG5zhNSqQ3QoBx+DBlMPo8qPzlFt7TpEJmYjtYQid007hdkAYogB4/
 6BPrVjlblIQMNTZaVhBP0ZSc/yDmDWWxrDPG+bPFyiTcg8Sj7wgo+y5K9w6PCheZQOwpd3kJ
 PdUElAvWp3f071E8WB0JBC7xiISmSgWjbmzN1Y+vFCy/DBbauuNTfGREElksOmrflaCsrHW+
 yrMJYTGPPnJXuGI/cB4+Q/YeglFZAzarxjhj9gYSP6niviEPyfitDm
X-Talos-CUID: =?us-ascii?q?9a23=3AG4K/TmqSynpUb5bmOAe6QT3mUZkpcUeDwWePGUT?=
 =?us-ascii?q?mO2o4WryWc0aX24oxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AVAr2JA6ysx9iuxBm1q2pnQ7oxoxryLS1AUoHsKx?=
 =?us-ascii?q?dnPCLLD1/ZxCw0x64F9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-4.cisco.com ([173.37.93.155])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:24:04 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	by rcdn-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 3AL2O4Oa001276
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 02:24:04 GMT
X-CSE-ConnectionGUID: VCCpN2C1S7a9u7lcJxP/0A==
X-CSE-MsgGUID: vLNkClvXRQinRnCHXLxipg==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=quarantine dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.04,215,1695686400"; 
   d="scan'208";a="10447310"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:24:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0nOg0vqu4Tf7HAB+dSxLGA2vtmUhjlAWzYphR6Nu6+JmVcI69eyktv2TkGCYJkZLJ43g05YyUIiMXk1GVcwt4zL/at1Glrn3Ehm+IEVR0fkDo91dzxN6iXPjUkK6YPTQC8pLikfiJnyRwJ+OoxFdoRIphbytit3ZP4NpoJLg1/gMOEqMEmWXmEYMya0rfoScTAjWJix4vigVVkG4/0m/N8w3veGVSwKjWGzkFTfC7PSPPhLXN2dohNVns+pg/8KTFQpz2aFb+hE4x/f44mW1Pry6nVb61LiD7cWvd2/1ebb+XT8hMVEtYndfwZDkCE4ldM/N2s7K3cSigPJYL/xyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bk3Xt8DPCEkVHBL0L+JC+gubV0bUerYkUmI5Bg6vnxE=;
 b=aMn99nG+URvnfG3+FiSnOVpqUPsqHKJm22S2FPfsZ4e3ZgGHcxbpHna0zzybXI5+Z8+jW7jb67onGOtp2rV2YDq3yAKXVuRYznADVM7EHKjfLWCAX3uM6ZWr3i/Df4hmrngoYzeFnWmlbGA8lNHR/CJajMzM1i0DhgutwnLeFGVDryGrXtXQW7HQQwQS0lTiyISTeohcE4SvIKKkVMRqGpgYmvu0cmjvrJaCi/OH1L8f9we64WKty+dwxvw99dUWqGPkrWJ0QU6nqmyyQMjLOVPYeRZBkTOScswt/zeJs2IDB28b0uNaHN+EAEc3ltP6RCAPTH5fhFV2OtKMcC7/lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk3Xt8DPCEkVHBL0L+JC+gubV0bUerYkUmI5Bg6vnxE=;
 b=csNMnhKYgRrrpib/NdU/y9tuRcOnJAYTC2uL+RhEOy5QsyWYq+V/E5MEw+egeRKJZEWwewe4CTpwg3T/Lh8MvV64txIlH0e3IKNxDMYJAE6SL9Fl9uozc1sMhKDoCUp4tF+Uv9/WTqQXg96YGOoIQ5snEThqa+4v85F4peAUIaY=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CH0PR11MB5235.namprd11.prod.outlook.com (2603:10b6:610:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Tue, 21 Nov
 2023 02:24:03 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022%7]) with mapi id 15.20.7002.026; Tue, 21 Nov 2023
 02:24:03 +0000
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
 AQHaBkb42cCL+heyGUeyjm7ciZVVH7BtxXAwgAtnMMCAAGhugIACobVAgAMYeqCAA7CpAIAA89uwgABCuqA=
Date: Tue, 21 Nov 2023 02:24:03 +0000
Message-ID:
 <SJ0PR11MB5896D94B10745BFD3BB2BDFBC3BBA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20231023091507.120828-1-hare@suse.de>
 <20231023091507.120828-14-hare@suse.de> <20231024065427.GD9847@lst.de>
 <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58960463A1A9D634BE8D2A62C3B2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <a5df8cc9-34c4-4448-817f-0f61f4a493de@suse.de>
 <SJ0PR11MB5896E596C922936ABDDE0567C3B0A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58961DC466F1FC2DAD8825F6C3B7A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <2d5071d6-daab-4585-823f-5f2e9dde8f79@suse.de>
 <SJ0PR11MB5896DCA2219FD8C0047B5C13C3B4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To:
 <SJ0PR11MB5896DCA2219FD8C0047B5C13C3B4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CH0PR11MB5235:EE_
x-ms-office365-filtering-correlation-id: 5ba9cc66-e0c8-4d28-3514-08dbea38edc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 SJhCLD40jdmd1FqnzZDTwD3uN3IM8UWiq5XO0g3XkmYPcJRPu2n3mffRP+roUC9rHrEQdzymyLqrJI3g+4IgKQROGljfXtwa1joz3jcJTcI8tJWKV7ZP8LGPULXaYtyWFXn/pSx2JZS9GSVtabFlBVv1oEFqEJBHLbYGP+XW29dYstNTn0ga0cXBzXGiD4wsq9EgfzSOqdgTwAcpaDQiKEYPWXKJ17P6pn34m/O9jZPHkyjun7fcuXOFgQOFrWb2fSq28XrMn0gsY0i6U8T74MdpvJWa0Pf08ZV2magLzVV5IQRkCsRdC4cRXid2Ui1O7l+iN1IEs3EhqqnVETrvVz+czHwYtGZX3wtKwfjbrQ/l7YbEKcvHKnpguMxImx/6NzOOrQw19g+iYVFYh8cCEYiK9syS5WCtC7xkXM34fgrK2wwGOkJywiPFCFUUfknCOua7MdywVGJJ4b4wc603/Hb8g2kkq5X7pTmj7WTVLvB/pJCvzEePCPRXpF7ocAYAuo7nds8ilejrX+C3sg5sgVKFvrMtuMNbCZ2prvwQNVazXnAX4yJkFajXzenJiu+6BQKw56xtIrbRM2C7lvSPr6WtoBW9UCNkQ2p34t5MHhoTHfj7EHmHqru2j/suYiMkXN3IveIJDZpqoDixVX1I5/rlKO4Dp3hzyc2BNaACuDs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(396003)(39860400002)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(9686003)(53546011)(107886003)(38100700002)(4326008)(8676002)(52536014)(8936002)(41300700001)(2906002)(5660300002)(478600001)(6506007)(7696005)(71200400001)(110136005)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(54906003)(316002)(558084003)(33656002)(122000001)(86362001)(38070700009)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZzBodFlyODdrL1d0QnlsZkFtVE9abU5yNlA2WEd0Nk10Q3Q3ei8wZTZkNzhQ?=
 =?utf-8?B?ZWVsbjNVc2YvcENJN0tQSE51LzJjVEhkVWY2U25Vc2ZKS1ZqQTEyR294N2ky?=
 =?utf-8?B?K1FVVFFZb0ZpYXlFUTMvdm11NTB6NE5FMXRPQ0NwczZsZmYxTUlWc2tkK0ZU?=
 =?utf-8?B?QlV3Vkt0b2lHU0cycjZCRnlLWm52cERtVFZ6bVllaFd0RW95VW1YODFQTi9p?=
 =?utf-8?B?Y3M3cmRwa3lMUEpETWRJQnZCZnBnU1ZZa09QZlhkRmtkVzE3V1REUVV6eHE2?=
 =?utf-8?B?MnlnckphMWx2WVpTYmNZbjZscGhqWjBQa0tRY2hCNkdldE5IcTB3dzNGSkow?=
 =?utf-8?B?YTQrUkMzZjZ0NFpCRXZYVFhPOG55N2FiN0lTRktHcE5wZDcxVmluV3Jvbkpq?=
 =?utf-8?B?YTE0cVU0ekRyMFFQalVwNjM3b2lodU1yZ2MyQThnVmdqaG44R1crRFdIalRP?=
 =?utf-8?B?VmRjcnVQTkVwKzNlbE5sVTJncFc3UXZSeUwzcEVZdVJsTW4vaWdtOVcwamcr?=
 =?utf-8?B?UXNJa1A3Vjg1cStObnJMTzBkTGdFVEM5TVRwY2FrTndWY1dNZVpOQnZXMmxF?=
 =?utf-8?B?dmtYdFordUo4UmY1Rkp6OGJpSE0xM3MrWjFNL2ZJb3ArdWdTTzl4SGxHU3VW?=
 =?utf-8?B?ejNURGFUSU0vVVZaUyttVW9ubXM5dkYzUFp4b002eEFQRTYvYXBFOCtrbXZS?=
 =?utf-8?B?K1hkWHA5R3dDZUtPcng3SUw4NW8xbGlvOHkwTUY0ZHh0NWlrVUpqVFVVa05Q?=
 =?utf-8?B?RlNsOG9jS0w3WFEvblROTFNLTUpvOCtsS1JXVW1USy9DODhYYmpmNW9Yd1hW?=
 =?utf-8?B?K2lVOTFwNFVzRXRQNTFMWklsTDNtVXVkdWJIN1pEeU05QXV6ek13eUNzblFC?=
 =?utf-8?B?MTZCSGhUd2RCZkcxUWFHQ0hzKzlYRG5kNVB6M1lhQWNXaGJ4NXdESG5Cc053?=
 =?utf-8?B?R3ZxcEFCYStzOE5tNkNlMktnYStGdjZMVVA2Q2VTOUxOenpJTTJPck45bENo?=
 =?utf-8?B?ZG9qZmkrMVRXNDk4M1ZYYWFMbUNzTy9kc0pEUCs4cnZPOUpaT29FRGtqRGFG?=
 =?utf-8?B?eWZtaXdWaytWMVp0cGZiRGMvOVJyQXc5b2k4SEdWT1VUYTBKVGFrdlhVb2Nk?=
 =?utf-8?B?M2xGdjdnd2RISHppSmJHaWdpNTh2OFpqSEN1MmdPQVBSR1hqb1FoVzVSMXR1?=
 =?utf-8?B?Z1pYRlBrUURnQTRFRVRXSkgrVGxLK0g4N1BOR0J6YmdYMEcwMUF5WDIvSnYz?=
 =?utf-8?B?cjdHaWkwcld0TTNpcGZYTWJjMDBwbm1IcWgveWFEU2RWTDZVQm1iYit6U0Vx?=
 =?utf-8?B?MVUvZ3RMWmFleHNiY1h4SkpsdlFwVkJKMmZvZ0hBRnlOaHZvU2htdDhRZ0Ur?=
 =?utf-8?B?a21VaDNhSHhjNWh0Vm1zbDBHT0hLK001K2Y5SXRaOXN3VURCV052bVJMQ09r?=
 =?utf-8?B?anBWQThOVi9Td21WaUxOZ1p1dXhqVnhBRko5RU1obXUxSG8rc2d1MnZrZ0FB?=
 =?utf-8?B?djR4WTFGTzJQSC8xRkZXNS9McFVhcE0rZlZTTXN1SjNPZUZWTjRFcGZaSGdV?=
 =?utf-8?B?cCtqQm92eFp1NEhKOElQaWZXdzluaGIzTlp1UzlUSXptYmcyd3JhbG5XWUVp?=
 =?utf-8?B?RTdiRUpId1NBclVPZDNuOEdSNTVxYkQ0VDVmREh3WXJNRitNMDVaSUxGYUtB?=
 =?utf-8?B?L3diNWRGeHM1Vk9uMmVYaG84eSt4YVJoV3VxSFQvTVY2cHMwUWtWQm0xaVRY?=
 =?utf-8?B?MTBkTGQ5YStwa1JzZ1o3REJ1WlZ0U0p2Y3U5eFRBbEZHNmhDSnQ3MjlONGU4?=
 =?utf-8?B?aUhqMTIxejBXSnpPUlZSOVcwTUJmOGhMYUN1bEpRdERGZU5pdW54VlZveWRZ?=
 =?utf-8?B?SURhZ0MwcjFYbXpZdGFLc09GQWNaNDk4RDF4NWFOak8yc3JCZ0pJZytKYTQ1?=
 =?utf-8?B?S1NSRjJwZnk0Mmlub1RnbEJQMVRPWXp5aHFXaFQxNitUZkw0UVVQY0NVZnpK?=
 =?utf-8?B?ZUx2L0VqZVQzdXczd29BMC9yTklWNjN6bDdKQ0JlWjhVaWZES3RBWHJJMzU4?=
 =?utf-8?B?ZzhIbjByemlWQnY0ZWNadVovL1RXRHQ0L0ZjMFk5UnE3dnZzZEZpR3ZFWlpN?=
 =?utf-8?B?cWU1SUhXWlNBclJSaTVzam5DdGxJTEZyMTZlcFNtUVBtOXFUTnJrNEJPTnFQ?=
 =?utf-8?Q?Q2vYf5RUamVG+OYVK4aHlkjBHoBUZB94CN+qO2gFh44C?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba9cc66-e0c8-4d28-3514-08dbea38edc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2023 02:24:03.0659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SWlzI9TK8Ljs2wyDPgi1x5wlSih2zjHjVei0PvQaIMC+4TPsk8z1Dsqjo5jw8rpYVEa4kosDvMtLR0QkQ9N+LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5235
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-core-4.cisco.com

T24gTW9uZGF5LCBOb3ZlbWJlciAyMCwgMjAyMyAyOjI3IFBNLCBLYXJhbiBUaWxhayBLdW1hciAo
a2FydGlsYWspIHdyb3RlOg0KPiA+IE1heWJlIGZvbGQgaXQgaW4gd2l0aCB5b3VyIHBhdGNoc2V0
IChpZiBpdCdzIG5vdCBhbHJlYWR5IG1lcmdlZCkuDQoNClN1cmUgSGFubmVzLiBUaGUgcGF0Y2hz
ZXQgaXMgbm90IG1lcmdlZCB5ZXQuIA0KSSdsbCBtYWtlIHRoZSByZXF1aXJlZCBjaGFuZ2UgYW5k
IHNlbmQgb3V0IFY0Lg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
