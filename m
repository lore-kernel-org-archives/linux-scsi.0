Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="m1ZZ1uz9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SrQoyHUa"
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4548E10F4;
	Fri,  1 Dec 2023 04:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1701435167; x=1732971167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Js0KFV3UKI97T0XaO5YnRpvRJDCqxmtCR3Owdrgfx2Y=;
  b=m1ZZ1uz9hW41XCVWOvbmAqZ5HuDO9TU5eekzgqdvWeJlY+id+2CpeFaQ
   pJM/rFMMTteAJz2CfARv2eb7XnU71PAJj0pfENXDIPSe8Iut24pRfXzrK
   nTNyPWhyRwm9tLJExRZZre1opgH6FFkHf2nbRm9Fz5HaLIaoTzOudFaXZ
   aj4QjUDbhsEIF0Vl1L2o7xQDrHWUdUycNEEm3lg5QU/K25cwemLrdi1Mm
   5MDUASz6urRR8X1YdZWo0oJRkDgNBrRUzFVAizzNZrWSFvg7lQZFAND76
   l9bPVu4ivSPGshVLJFZbaJ8pR7+NZ8cwMVVydSYvGsC9CM8kz1O/bV2ZS
   Q==;
X-CSE-ConnectionGUID: XzavS7iITo6fPxockaGJug==
X-CSE-MsgGUID: TJh3f/4pTaGnaDmxkCpujA==
X-IronPort-AV: E=Sophos;i="6.04,241,1695657600"; 
   d="scan'208";a="3762746"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2023 20:52:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfueiRXZVfNFjImJeq+aTKhv+K2gyAcM0rNr34MZ51xfPZDTzjMh261xUfc+ALH0jnRlIV2ZvTz2zjC/G0LktCSC5NlJTMOlXvKQx1p87ic9ZUYy7MAZB/yo7FcmcdHPp97e9rnhEyhlwivhe0vAcx/ZLR07mP37ALVCNvqQvMHqWPtybgTfWeGRxuGXcJlTD7jGCf5kJR9VKfmVPFX1+OI16CXGX4NiLkexLUUbyzvKvO3P7ZXWsHCzRMhZq5K71ZTCTAAEtcRhDnkS/tQ7p1eoLMsEiq1qHkpX1uC2ERCGw65/6fb38FGwwPU3hg8JnyHCWnEPGcqjZkEnWrPBRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Js0KFV3UKI97T0XaO5YnRpvRJDCqxmtCR3Owdrgfx2Y=;
 b=clWFCrDL3tTjLhWwb0yCjjD5IBD0crFET8Dv95OIZgcw6QKz9nXp3K8JG4KaeT3mKxJ4jqwYuzwRv8Frb7dumJeYmMSILph6eDs04WWvR1qb7qPH+dnNSeDHHFkUAj9RahNwjxErvtxqNAHwRqTx8NTTx9LkNSx0c9b7fNY8uyr8Gu+IS9+Z4sHggX/rulZj2pXn1U0h4X1HGBh7en8RwIK9Lvq8XiBl1gnd/gCg/on71cak8TLNuh6QV5FvyOHntDuOzBHkWluCni3Qtt6uGFgGnlGW88n30U4w2cHsvS3lSw4/nhx3Ljm0IFvYnJGARZX2Yvb/7JCdXy//FVepew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js0KFV3UKI97T0XaO5YnRpvRJDCqxmtCR3Owdrgfx2Y=;
 b=SrQoyHUanvxBGBeYkAPQieJvSJU/4Aqs/4wjmOFJxXX0jnjZioIfMEf4RiTiBhpIA2OWMhGb+RNvAEneC0JTsTZUWDoq4JsEs85wo1byoNOpA+yyJBXihl0QxG3Yall8u5i/der4MVVye5w42dn9aYuYBRwBBlDzRdIhRIWYFOA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6641.namprd04.prod.outlook.com (2603:10b6:a03:22b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 12:52:42 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ea3:9333:a633:c161]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ea3:9333:a633:c161%6]) with mapi id 15.20.7046.024; Fri, 1 Dec 2023
 12:52:42 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ming
 Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>, Damien Le Moal
	<damien.lemoal@opensource.wdc.com>, Yu Kuai <yukuai1@huaweicloud.com>, Ed
 Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Thread-Topic: [PATCH v6 1/4] block: Make fair tag sharing configurable
Thread-Index: AQHaI8PiMVKilih9yEiHNC40E6j3brCUYwKA
Date: Fri, 1 Dec 2023 12:52:42 +0000
Message-ID: <e728ac4b-bce4-4c2e-88bb-8874c73f0c8e@wdc.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
In-Reply-To: <20231130193139.880955-2-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6641:EE_
x-ms-office365-filtering-correlation-id: c09da225-645d-48af-59fd-08dbf26c682a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Fe19Io4gtA3xVSuNcb4DPLATtlXuybXF0ffnsrTrZ279Og6Ys9xedDTEKZVNnThqen+MTavOX20PJJ0+hsSOgZkOAb52z3zhVqB+H98uVoql251BmHrWKX3mCK3+3jqIfrzmHBBKPYChPM0hiQ1KDcB/zlXKmBxJpGWRsvoFTAgEIhL0ALf/rNvJN49fgl5lvISYPDsJLIG7Q0uwhK+Rtwvjw9LISFOAlUKvlnwZIWat4FgA/lF/zu4TBZ8vOHylMUfaJ4sdEgwwJ61rAR3/AILz8NxTk8u87C+gadpUWfuHO67gASZWdHZc3NGLzeQyKvvfAkn87tKSOasod+//2JWbW6pSEv2MQFGKVZi7ur2LWDGu2ElRatsY9bC+rviHxXRdpi2rK+MUz9/+cwJ/mqWaoWIrWX/dA3TTSalPq3dyliM5NbFDHc9qiej4SqkT71WRSjtDXzDDCYLjkiJmOgL76BVzSz02tVS6k0VYS51LSW4//FB2/KIJujueG41EnNONOILkQzLPUqTTKq0xshC0jT+CEAuyIC/rxtLNuNmSzXM7CrLhxAWPdYDO8aSAL3zZ6DBBvkyl6lZmAwpVEhDLU5DiYSislA2WHiNkhM5kdA5Kn7GgTAz7eHKE/IluUWXtoQbBwd+XsEcKcP/5xeKDhPqHPwWnhYTXj4wdR7MSdWzgwErBMEwOXxJNkpK0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(346002)(366004)(39860400002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(38100700002)(122000001)(82960400001)(38070700009)(86362001)(31696002)(36756003)(110136005)(76116006)(66946007)(91956017)(4326008)(8676002)(8936002)(54906003)(316002)(64756008)(66446008)(66556008)(66476007)(7416002)(5660300002)(2906002)(31686004)(6512007)(53546011)(2616005)(478600001)(6486002)(6506007)(26005)(71200400001)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dnNjblRpM3d4MkpNeWN6Zkx1T1IrUi9RcmxhRS90RUp6QUVCNlNGQXpXODdV?=
 =?utf-8?B?VzFwdGZ5Rkp1MjRuUHZHVnkwYjNlUmRKODZxckJxL2RVWTk1YnN1SHZ2R3NO?=
 =?utf-8?B?NmlPQ3RuUDMxYSt6RlYvV1pNRnhYaWV3YmNwVVIyUzJnNWFtRExWa29xS3VQ?=
 =?utf-8?B?dCtWSUdsNVMyTGwvRnM5VVVqUzJyU0ZBVmovaDdmY21CMklaRHZDQU1tbTJa?=
 =?utf-8?B?SnM4Mmk0UHBVeDBDUklIbHRoTUpZRmU1SGsrN0Qzd2JZU05LbVFFeXhjODQv?=
 =?utf-8?B?bGcweGo3V0hKbWtVMXZpdERpQk40ZUJUeWYzaFdreVFaM1IvUUlESzJYREJk?=
 =?utf-8?B?eGJYY0RrM3Q0cENQck8vSVZYaW0zYzdVY0h5VVlWY1J2SnRZSCtiU29ybUFs?=
 =?utf-8?B?Rlp1cHo2Z2hTUzRyNy9ZOU9udTZDTGlJM1hvQlNiT3h0L2N1b2plRlMyS2pj?=
 =?utf-8?B?dU5wQy9vSStkWXlhU2pYVnVGWDNMUk5IWkFkWTVMaDNoNGVxWi8zLzYrUGM5?=
 =?utf-8?B?OXRiWUdjRWZKYnV4YlVYOXhqaFB3ZUU5SW1GVGVJbGZhaThDQ1dMRjN4Y1c4?=
 =?utf-8?B?ZEx2TmVsajk3SW1XSngwYW5EbkdKL3FTT3NoM3VnS2lmME1DdERGcFQ3a3NY?=
 =?utf-8?B?YWprc29WV3dBRmRuaGk3L0tlbzNEd2tLaWhPYlhaTVp0Mm11YlI0SFE3WldT?=
 =?utf-8?B?dVZBRklNK29oRFF0eWZ6R2ZJSHRnTm9FQVplK3pTSlV1UUdFSndyZDhWZ1lo?=
 =?utf-8?B?RGFmV0NwUC94em91Sm9rUDRWZ2x3Rk9KOGxLbVVzb3MwZUx1WTVocWZZa3Vu?=
 =?utf-8?B?UjROYXErWTRhRzk2SVFUeEIrYk5UYldnaUZYOThuY2Z6eUM5elRrMDJTWU9Z?=
 =?utf-8?B?bkw2ZVB0aVY4ZTh6MStNbUdBZkdCTmJ0K2pESHo2ekh5ZG1OUTJjZkpJYnNX?=
 =?utf-8?B?TnVTSEc5K3loaU5PeDJkS2F6bURoejB0RngyYUtGYkNkanpxU2p1L25pWTAr?=
 =?utf-8?B?TmdodllLU0djZTJQWk1qNHR1eU5idXdDelF2dE9CQSsvMndZZGhHRXgzWHh2?=
 =?utf-8?B?dHY2c1JvRDJNZldVVTY2cTNqTlFtNEZLVTZtSjlQaVVJbmNseVFwc294NUdZ?=
 =?utf-8?B?UWdhSDNidmU3Nmt2aHd3ZUVkREJpZW8wL0RDc2NSTWxGUDR4eFZlS1hodDRi?=
 =?utf-8?B?N0lJd1MzOGhtbktYNWtCZ2JGWXU5NnJEQzJkck1wVW9GbWpadnV4S29QU3lk?=
 =?utf-8?B?YWlFZnRQdk03dlVScHlvVm1zOER5L0JiZWlmWWZkcm5DV3dQc2dKVnNJbUk4?=
 =?utf-8?B?ZENnT2RsTUZiQnZ2VEpuRjhkQ1FlT0RYNEwvK29FWHRHTDRZWHFyVE1CMWhZ?=
 =?utf-8?B?QVJnZk5oYTVjWHgyaEpZNmc1M3JPeVJ1K0hSLzhrV3ZVeExpUjcxUW5DZ0FE?=
 =?utf-8?B?VE1HMG5PblF5T2Q0aTlIRlBES2Y3c3RFV2ZOMWg2R085VDI0Ymc1TFQxMTBH?=
 =?utf-8?B?VUttUUh0MzlsZHNjblZvZjRacEpjNXZkbjRUUkN2c3g3T2puY2EvV096dWtw?=
 =?utf-8?B?aElzVWMxUTliTzd1MHVxbEJKM2dSUkJ0aFcrdTkwTDZVNlc1MnlFRzNaaTFm?=
 =?utf-8?B?Q1MrUFp5eCt0RWowL25pQkEvZFZwVHdaQVdmOFFwa3dkS211a3R5Vm9UK2Fo?=
 =?utf-8?B?OG9rWE1aRHhXTEZXc1BOVnFNVWRvRDd6YzNLdE40WjdmRjlUMzk2UzRvc1Bz?=
 =?utf-8?B?a3NiaUYrbGFPMXQ0N2owUFVubmg1UzhNWDVFWWk5MGRaU21HUHU2M3BmampG?=
 =?utf-8?B?NGRadTFlTEo4S08zdVlwOGpHTFRtQ2xpRXBEK0xQUjg0a1VyNU1Pa0xhUWQy?=
 =?utf-8?B?M1FlR0ExdjFoR0pVRzNNTVV0MlFNazB4OGV1djlvU1RVN09qMXhlK2kwbFNk?=
 =?utf-8?B?ZXk2VGlVMjFCYlA0QUtqeExqRGUxR1daUHlSYlVPU2xBU2FOWTRSV25nR2tY?=
 =?utf-8?B?SmN3cjRlS0tUTHNTZW5YNXdwb2tFcFVaclpnNTVsaU4rc2RrK1RxWUwwL2xS?=
 =?utf-8?B?R281ZVRFZzlQNERqNFB4QVVKRG1rQWFEMmlXZWVFUUJ0SFN1UjdsZUhTa2xQ?=
 =?utf-8?B?SUhwUkxCQjZrTkNOb3JoazJ3dW04YVh0ZmUvY0huMnN5SWQvMzhYd1JLSkNT?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5897F2748E287C49B72C49633B0FACD1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	=?utf-8?B?THByaFZJR1d1VDJMMlg0WXNmSVp2V0tRNklPWkhRRFRta05jaUdhdkRTYVlV?=
 =?utf-8?B?YTV1RytYTWVyNjM5U09PUURhOEM1OVhjcmw0MkNaSlNYUUhDQW1iZkE5TjZs?=
 =?utf-8?B?dG1qOVpYQ0xvRE91TitQWlhWVWJqUVdNMTRpUEF6UlNUdmxFYlFwazJ4dFp2?=
 =?utf-8?B?UEdwbWkxdnloMS96cDJraTExOC9hRUZpRkJlcjNCa1N2bVh2b0E2d0FsWkpL?=
 =?utf-8?B?QVoyOFpNRy9nVE9iOEhIN3J5Rlk1VmJsbEF1UG5IWVBWVExpTjEwcnNsWUMy?=
 =?utf-8?B?WTQxRVFXUGRrUEtBeUR1UjQ5ZTFYbHA5MGJ4Z3F4UDVsdGI1dUU3M1IvdlFX?=
 =?utf-8?B?NXppVFhUTlJFdWQ5N0F6MWZPVXdvaExBeDc0U2d2M1FGbHJTQ0dnNTdHVTZh?=
 =?utf-8?B?bXRLQlRLZzVtSXFoaWZjMFpGQjMya0M5Z0M4YmJsMTRiSkkxdFMxVGpYTC8x?=
 =?utf-8?B?V0V1cU1GTytMRGtzOHpWSUpjcEhnWXhRTkhBc1hVNndxdDZES2ZNY3JSV3hB?=
 =?utf-8?B?b1RxSlVzRXFMS2pZcnZYVWlNZmp1VWRrMzhpRW1BbnhhZnJkTnl2djJpMlZJ?=
 =?utf-8?B?MUNzRkp5VktxODA0bG5wM1RFdzltODRERGk4bUpsa2FCT0xzZ2laa2lDbDdB?=
 =?utf-8?B?WjdFMHIra2djalpoa29VSkdNNVJtQTlnam1MOGFWRWFTdnkwWjdCQnltSS9l?=
 =?utf-8?B?STU0cU9UTU1aSSsyalEzc2tZMTVTRUdZa3pERWtJUDhyOTlaMWxnTTRDQVVV?=
 =?utf-8?B?SjZzK0laN29oRFc2czdKK2hhVmVmcVlwUCtWL1luRVJUTTJoV1VrdEs1Q2lp?=
 =?utf-8?B?K0Z1L093NTRndHVSR2VucVpBWmNlcEcvY3lUSy9zWHpub3hBZ2JVVUNaM1da?=
 =?utf-8?B?NDZ6QitiTWhpaEkyNnZDdkFXU2RBN1V4c3hEbFlMNkdBOFVMcVdJZ0xXUWN5?=
 =?utf-8?B?RHdHc1NVVUUrbWZGeStJWTZMdHY5MktqNUE1YzlKY1luQlF5ZS9senpTVTQ0?=
 =?utf-8?B?THM0NEJTWHd0NjlpUXRwRzFoSnNybnhSQ1VXSk1Zek5uMXAxZUx6RjBrTUd2?=
 =?utf-8?B?cytkZUk0WlU1T0ZpY0JrM2ZzOGhlbzFzUnMra0YySHRNR2FiL2Uwak44NFMz?=
 =?utf-8?B?b0N6UzI1azRtV0syVnl1VkRmbjE4cUl5VWZXSGNZbEF6QWNTRFpuNmtVd3Fo?=
 =?utf-8?B?b05qR1VzazI0RFBkSHQ4T2w5RXVwbDdYQWFwWXdZQXVldE84c1huUEhyK0Yv?=
 =?utf-8?B?NFQ2UHZpeTVSbFRFYzZJQ1dYamNDRnhJczFIMG5ZOExtaFVYZ2s3MXNadFhR?=
 =?utf-8?B?MTJSUmxQK1pSS3hOVFFrQW1NSXBIVlhIem83U3I0NzFoRmFWSjhTazA3ZmpQ?=
 =?utf-8?B?S1R1YnpvanZIcGNoT0ZEenZaY1A2VENkbWE5Ym44WDNnTHpNVEM3bFloVTRq?=
 =?utf-8?B?N085c2xQRTU1UFc0TEtjMFcxa1lYbEFKeHdUdmdBPT0=?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09da225-645d-48af-59fd-08dbf26c682a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2023 12:52:42.0899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SA2jiKpwIcwuO3I8i8o/Q9j2X+wgWFo4BXPwPk4O2D6x+ArcrQzVupk5zVYRweQEZvC9+ae+e57TPyJNacComAc3XyqYlenQ20n6eupn0EU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6641

T24gMzAuMTEuMjMgMjA6MzEsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gK3ZvaWQgYmxrX21x
X3VwZGF0ZV9mYWlyX3NoYXJpbmcoc3RydWN0IGJsa19tcV90YWdfc2V0ICpzZXQsIGJvb2wgZW5h
YmxlKQ0KPiArew0KPiArCWNvbnN0IHVuc2lnbmVkIGludCBERlRTX0JJVCA9IGlsb2cyKEJMS19N
UV9GX0RJU0FCTEVfRkFJUl9UQUdfU0hBUklORyk7DQo+ICsJc3RydWN0IGJsa19tcV9od19jdHgg
KmhjdHg7DQo+ICsJc3RydWN0IHJlcXVlc3RfcXVldWUgKnE7DQo+ICsJdW5zaWduZWQgbG9uZyBp
Ow0KPiArDQo+ICsJLyoNCj4gKwkgKiBTZXJpYWxpemUgYWdhaW5zdCBibGtfbXFfdXBkYXRlX25y
X2h3X3F1ZXVlcygpIGFuZA0KPiArCSAqIGJsa19tcV9yZWFsbG9jX2h3X2N0eHMoKS4NCj4gKwkg
Ki8NCj4gKwltdXRleF9sb2NrKCZzZXQtPnRhZ19saXN0X2xvY2spOw0KPiArCWxpc3RfZm9yX2Vh
Y2hfZW50cnkocSwgJnNldC0+dGFnX2xpc3QsIHRhZ19zZXRfbGlzdCkNCj4gKwkJYmxrX21xX2Zy
ZWV6ZV9xdWV1ZShxKTsNCj4gKwlhc3NpZ25fYml0KERGVFNfQklULCAmc2V0LT5mbGFncywgIWVu
YWJsZSk7DQo+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeShxLCAmc2V0LT50YWdfbGlzdCwgdGFnX3Nl
dF9saXN0KQ0KPiArCQlxdWV1ZV9mb3JfZWFjaF9od19jdHgocSwgaGN0eCwgaSkNCj4gKwkJCWFz
c2lnbl9iaXQoREZUU19CSVQsICZoY3R4LT5mbGFncywgIWVuYWJsZSk7DQo+ICsJbGlzdF9mb3Jf
ZWFjaF9lbnRyeShxLCAmc2V0LT50YWdfbGlzdCwgdGFnX3NldF9saXN0KQ0KPiArCQlibGtfbXFf
dW5mcmVlemVfcXVldWUocSk7DQo+ICsJbXV0ZXhfdW5sb2NrKCZzZXQtPnRhZ19saXN0X2xvY2sp
Ow0KDQpIaSBCYXJ0LA0KDQpUaGUgYWJvdmUgY29kZSBhZGRzIGEgM3JkIHVzZXIgKGF0IGxlYXN0
KSBvZiB0aGUgZm9sbG93aW5nIHBhdHRlcm4gdG8gDQp0aGUga2VybmVsOg0KDQoJbGlzdF9mb3Jf
ZWFjaF9lbnRyeShxLCAmc2V0LT50YWdfbGlzdCwgdGFnX3NldF9saXN0KQ0KCQlibGtfbXFfZnJl
ZXplX3F1ZXVlKHEpOw0KDQoJLyogZG8gc3R1ZmYgKi8NCg0KCWxpc3RfZm9yX2VhY2hfZW50cnko
cSwgJnNldC0+dGFnX2xpc3QsIHRhZ19zZXRfbGlzdCkNCgkJYmxrX21xX3VuZnJlZXplX3F1ZXVl
KHEpOw0KDQpXb3VsZCBpdCBtYXliZSBiZSBiZW5lZmljaWFsIGlmIHdlJ2QgaW50cm9kdWNlIGZ1
bmN0aW9ucyBmb3IgdGhpcywgbGlrZToNCg0Kc3RhdGljIGlubGluZSB2b2lkIGJsa19tcV9mcmVl
emVfdGFnX3NldChzdHJ1Y3QgYmxrX21xX3RhZ19zZXQgKnNldCkNCnsNCglsb2NrZGVwX2Fzc2Vy
dF9oZWxkKCZzZXQtPnRhZ19saXN0X2xvY2spOw0KDQoJbGlzdF9mb3JfZWFjaF9lbnRyeShxLCAm
c2V0LT50YWdfbGlzdCwgdGFnX3NldF9saXN0KQ0KCQlibGtfbXFfZnJlZXplX3F1ZXVlKHEpOw0K
fQ0KDQpzdGF0aWMgaW5saW5lIHZvaWQgYmxrX21xX3VuZnJlZXplX3RhZ19zZXQoc3RydWN0IGJs
a19tcV90YWdfc2V0ICpzZXQpDQp7DQoJbG9ja2RlcF9hc3NlcnRfaGVsZCgmc2V0LT50YWdfbGlz
dF9sb2NrKTsNCg0KCWxpc3RfZm9yX2VhY2hfZW50cnkocSwgJnNldC0+dGFnX2xpc3QsIHRhZ19z
ZXRfbGlzdCkNCgkJYmxrX21xX3VuZnJlZXplX3F1ZXVlKHEpOw0KfQ0K
