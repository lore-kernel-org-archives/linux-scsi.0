Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D4318E357;
	Tue, 20 Aug 2024 06:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724135439; cv=fail; b=YhX4IuXPtn9f1FH5M9T5BNB4atxYy1Jta+5XyZXkes3EedRQ0LDnTbCcQ6mLxxfF/a5J+R1AuZL54I6k9yfzxc2Al2GDu2kM0wNLsFITYH1UV7C2nUus7Vt6SgR5OcUN7jdSfV4ekVP43GY1QbDrbX/68f5mV76Y5hqMIUcEbiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724135439; c=relaxed/simple;
	bh=kYQF/OoO9pCarUMaCfox+j8f3Raqy/vAmh2c42sJpH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rQ2Js5i2TXU2icbhZF2el3QROYg29eGuvVghq11djNVO0W4+ydl0UHAGYeL2emtb5yvoCYGeJUf4BNBfW+60j8TCqY/NL32xJ82+THHvqvsclcEsSbp4rebCyRbGRU+C+Q7/7apg9rhGQzWo/gfFPFKQ7PdExyJp4+CRP7lrOR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q0+7k4IE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tY4qcpXZ; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q0+7k4IE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tY4qcpXZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724135437; x=1755671437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kYQF/OoO9pCarUMaCfox+j8f3Raqy/vAmh2c42sJpH8=;
  b=q0+7k4IEriJSp8d72G53RDw7z2J1q5UayZX0rKSBiDmFwwhz4xE7wHVh
   CweBg7sTd5aXU/vUBujVgby+I6/IxFt/AqWZTNUS2PKWS5YkBvgI001Ib
   JTWI/ts5L2ZKU7kIykeJZSBxjS2WnD177flwJuXe2kFZI679uyPdCida4
   wbAGC6y5iXXLM6qcsZbSUb706LNXDExOadguvYtRosJ6nTxKfnTZOtpnB
   aA5yYZ13oJKKEyTkACWV6cKEMn4N4OmCyMrFiJ+ZDZw00Nm4xaJD9cEF9
   6NA5H7i1z76cFrBgEPhRIDebYrgW+APvkf1Y5Yd2RcgEVtVghKF7Dfova
   g==;
X-CSE-ConnectionGUID: JdDs2gbeQ9iDEKG12j1LYA==
X-CSE-MsgGUID: PqJLEXLASLqqXwLKcQ6X4w==
X-IronPort-AV: E=Sophos;i="6.10,161,1719849600"; 
   d="scan'208";a="24076846"
Received: from mail-westcentralusazlp17010007.outbound.protection.outlook.com (HELO CY4PR05CU001.outbound.protection.outlook.com) ([40.93.6.7])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2024 14:30:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hImazDyeFCg41NS2mshrwRMjBM6zIX/FnIA8w0lLpsWGuYNWd1pyStRyIeYErqtF0O0tAnD6lzrTOdSP7GTNME2yRPOzU22ljM2B9CV+KiHicSVsFSQ0iRFtD0/fVkyqefsU9iGy3Etrc7aJmam/fBZTAsYVRuSh+y28orCXD1AXDUZfvdkp4HX3mFfMdQTFfMVjbDRefOmHzk4h8lywaquxuNmNGWNa7r3GORmsK38Rap1llNpO65imE1smUd2fyuh/7TiR7Lo/pz8dP5nrLqbVGR7qXX5O1DkhaIoWg+3+o98O9gu7i+SxWnh3rLlSXQh8mFWcjUz/d0RDgxhJfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYQF/OoO9pCarUMaCfox+j8f3Raqy/vAmh2c42sJpH8=;
 b=pz8l2WxrtrdJaMZnOjRTAUMXW/TK4TCNBiLzbIQMJ3B4kzeNxPVHtgq1/MYzGtfNB+xig6USc9TwGoAcb9Ht0WARTFNLn+wybyuILQuplH0Fwm9C9Z3DDWPlEjwYQ6CbtSy/+/yXGNjQOnAtPpbww9SPiD6GC9KfZ9nVbVNV5FlBR+HH2Bcdqp1zCjvHIEgNjyJ5u8y8mfA0tlb3gXuIKDxwstcYj4bZLQSTVoi1V6yJtjyuqKRJ4faVydu6f0jozOjq+KU8t2oI7shy8YqltIorA/LAf3m3f8/vymK14GNCUSAPjkMHF+1e+DgkmXdUQLO2w3pbHFl2htor/qxiNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYQF/OoO9pCarUMaCfox+j8f3Raqy/vAmh2c42sJpH8=;
 b=tY4qcpXZ6KGxBu3m1AR7KGMTPi8/4BPH83fc686Ef8myteaZ5yaeAoWs0GC/ibe7wyvnhcvkp84MtZW1e2f5QS01LLV3kqgQ6YWLSgFk2ZAS2Eb/Dm2f3gH/zylrF7dzry1QiIYLJBELeATFQYSh7dV154DeRB7q2l7H1Vl/jn8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by IA3PR04MB9497.namprd04.prod.outlook.com (2603:10b6:208:505::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 06:30:33 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 06:30:33 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Avri Altman <Avri.Altman@wdc.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Move UFS trace events to private header
Thread-Topic: [PATCH] scsi: ufs: Move UFS trace events to private header
Thread-Index: AQHa8rWp4cQVaTCmiEe1prQJmfltZ7Ivr3+A
Date: Tue, 20 Aug 2024 06:30:33 +0000
Message-ID: <5f5d42a2-4c6f-4e8d-806b-c802c1881cde@wdc.com>
References: <20240820035826.3124001-1-avri.altman@wdc.com>
In-Reply-To: <20240820035826.3124001-1-avri.altman@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|IA3PR04MB9497:EE_
x-ms-office365-filtering-correlation-id: fbec8ea8-6811-4b18-9399-08dcc0e19871
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N1lBVEVkSUcyRGhGWEJJYkc3cERmVEFhMjBkZmZBOVZNWmw2OUxDTGU0QitD?=
 =?utf-8?B?NWs3Ym8wOFJlN0ZqRG4vS2JBNUs1YnRNK2RENm4xczlOWXhIQXlOWWdiYS9N?=
 =?utf-8?B?RnlXMUNOWWtrS0ZYazM4SzFOdEFXbmtvQ2J0M05YU1pMaEFtSzJrNE5seTNy?=
 =?utf-8?B?UUxIOG84NjM0WlJwVkJzTVhKQ1FxcEtTZ0VFaHpkYjRZZllJNnh0L01OMm9m?=
 =?utf-8?B?UFJIcnU3dUp6ZVgxUUhaTWJwYlBacVNPWTFaQ1pkNENTclUwRy91azlJYVYv?=
 =?utf-8?B?VjNYMjJieEZMdkxpNlJKV1RwUE1MSWc1Mis0Tk5WUldsOTh3S1UxZGZUbHha?=
 =?utf-8?B?RU9zL3gyWWJRd1pkSXFza0xqOHFNUjlBNDVqNWlzSlN4RmxxRmhlc3hhcFV2?=
 =?utf-8?B?dTNqeVlEMjVUUkFKSGpiUFZ4NHExQ2tlSVhIQXdXR3NReFdnRG1lWDZBVzQz?=
 =?utf-8?B?WStXN283WHh5eVFwWjZpa1ZsR2xCTVZxS2xScTZnamd3allkZmI3T2ZoSTV3?=
 =?utf-8?B?RUN5bnJSWHM1QzlmSlZFc2s3K29sOVc1Q2ZtNkVUWXgwU0dJTzJ2czlLYjBN?=
 =?utf-8?B?bWN6cHhuY0YrVGxhOFk0S2VOUFl6aXlNNVJ6eFBnOGRQVVVBa2xRR002VzNl?=
 =?utf-8?B?UTdVS3BvU1lveW5yMGVuOHJ6KytxUWpmNitoZTQxZGQwZUZ4ME5lRTRqUzZw?=
 =?utf-8?B?YitGaDkxcG0rTEZCdzk4bWwwVTgrUWtranBxNFEvU2p4cWZpcnk2aUtwWUpZ?=
 =?utf-8?B?eU9ORCtYcFM5V0h2TkhubUQ0S0kzdWU1NE5jUE85V1JsazdtVjlHNmtFajVw?=
 =?utf-8?B?bTdMMS9oSTdORk10TmNKZWdXTUcwWVFvaUc5ZWhOM2g0bG5PN2VDOFBjeHBi?=
 =?utf-8?B?aVEwcDZITmk4bDFzcTdqL05IZEJseEpKRk9PNFZqQk9SWTRnWHJjWXYyQWlp?=
 =?utf-8?B?ck56My9FbkhYUWRmeEYvQjU5RDZjMzYwUGo4MGtqMHhGVGoweGN4dHVpcEty?=
 =?utf-8?B?R2ZSTGhYaFhuNWtFS1FhUmhqNkFENnJLS3lSN2lDSUU0OVMxc3BUelJqS29r?=
 =?utf-8?B?NVlVQml5ZFFsK05YMGwxbnNaRHlHeE9tSWxTbWZWcVVrR2dwRUhXdnVKSWxB?=
 =?utf-8?B?dE1FcXhDbklOSE95T0hsa1ZxbnBOd096a0EweExQRWI2RTVFa3htSmIySWJ4?=
 =?utf-8?B?STNmMnpaVTAzQllwWmliQ05BVDl3bnE0aXZpVmk2dlpIL3dTRHo4L0N0ZUFU?=
 =?utf-8?B?UUpoWlZidXR1a2o4SWs0ZFFTK2ZGRllJaHE5bTBEK0k4aTc0aUhpaEc0clR3?=
 =?utf-8?B?N2tvbXh5ZUcwYVp4ZGFvSzFRVkNhaTJWMVJLdlVOeUptTXhIY2haSE05NGJ6?=
 =?utf-8?B?cXJpb0V4Tnl5VVBWOEgzd00vZ3FoMm5lUWxkQmI4d2pDeGtLam5ZT3FWZnBL?=
 =?utf-8?B?T2Y4cHVONWQ2SHBUbXlhbFBxZGNXT3RTS05odEE5Y1JOd01JazRCVnZDYWpL?=
 =?utf-8?B?dzlqN3lFTVJnQklpdWFZK1ZCMHQySDZOeFZxam5XY1hzWTJWcE0xODJRWnA2?=
 =?utf-8?B?YmFGOE82U0c3aHZmaXk2SHY1dTMwaGc2NjBqRnpKek1Bck5aRVZIeVp6ZU9K?=
 =?utf-8?B?cUhpb01LclR0NmlubkR0d3NSdUhyQlovNE4vSHZoZ3pDalhXNDlUWVJIWEVM?=
 =?utf-8?B?VnV0NXk1Z1gyb1RNY0JOWjRZL2NlZWZjaUV6Q3pjU3drZEEyZ3ZRb1N2ZkdN?=
 =?utf-8?B?dFlEejgzVmEwcnVhZnpMKzhsb1ErZGN1dzl4RUJKWWdnaUlvUDN2T2MwdUhO?=
 =?utf-8?B?TWZQY2xWNzJ3OGtDZ1AxWHRXOVpWU1E1R0luL3Byc1diMjcvVXMxeEtyTk5G?=
 =?utf-8?B?U2M0RTRmeDRPbStvZVRKRjVocmxkM3FydXc0bDFGclErSXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cUo2eitndjZUT3lSb3dRbHNIbG1WWEp6ZStkb2JvK2ZXZ1VGVHh0ZGkzcGpZ?=
 =?utf-8?B?ZHBmanFpV0tIcm5ZaisxQWhIVjdPdGJFdy9PdFNHME5CVjBKZmFKWmZYd0xX?=
 =?utf-8?B?aDZBeVRsLzViRlFUZTNMems4SGZKUUZ2UW5hTFRxQldRQXhuek5DU0J4Sy8v?=
 =?utf-8?B?Nm9MOXBQZmFLZ04yUzB4RXlBNGFITjBtM2luOU9NRFN4ek8vZEx3RnVEbFZj?=
 =?utf-8?B?Wmo3cUZ5eG9mTXd0MWlNNUdkV2t6N3BvblJkQlN1WTAwNHBrWnJ4Q29oRDVm?=
 =?utf-8?B?S0JFNTJHeXZNZWRCY0YrTnRORkJ1Q0pXVFdHTzROWjVZQklXVUl3Tjdnanlm?=
 =?utf-8?B?aEhieFY0cTRkNWdaU1VjY0NLYXlwUk13cy9CaU56ZXpmRXFrcThocEtWUlhT?=
 =?utf-8?B?a0xrYUpybnFQMG10SGJYWmxoSTJab3VRZHhCc2JJT1ZUYiswNXFOZ09XY2JD?=
 =?utf-8?B?VUcwQUd4RE9XL2NzTm9NRGl1ZU1QZEd2eVpMRUNMcm1vK0x6QU5EU0Q2YjND?=
 =?utf-8?B?YVZUMjVWMEplNUNqUFlSSFZyZ1BJS3IvZnJGdXFVUWx6S2MxT3dNbEJzeGh5?=
 =?utf-8?B?Rk1wdXJQSW80UEowbzlGeDNMRW4yeW9BOUNkQWNrYXVDSVBOWFo0M0xaNTF6?=
 =?utf-8?B?MUIrK21Ka2NickdJVWRaSDJiT2J3bXdoWHJkQkx0SS8wVmNXZytseXBwWHVD?=
 =?utf-8?B?djZXRTFML3JjSjJ2ZWRESVltMmdpV005bTk4WlhqeVNVY1hsK3JCbTVFWEZT?=
 =?utf-8?B?d0ErV1J2TE1oV1ZYaml6N1FtUENPN0d1VWt5S2pLMDNyV2ZHdUVxTzJHVHBI?=
 =?utf-8?B?Uk1lYllUY0xuZmtPRERicHpVMkljcEdXeGk2RWE1eTEreUtITHM5RUtLZ1gz?=
 =?utf-8?B?OWVndVp4emJUak15ZWZkRzdmRTA1eVlHcFpLa1ZOWVB4VTNoYXVYUXgwWUJ1?=
 =?utf-8?B?K0RkN0k3Z1hDcUlzcmFMbm5jOWUrQkJhMElyb0NKWEVvdThXWnByZlFhWFRK?=
 =?utf-8?B?aGQ2SFVDSStjMlpYbFdudjJyL2pkZ1B0R2hjNml5TjEvREhTNlJsN0dhSnJh?=
 =?utf-8?B?ZnJDWnI1U0dqTWVqR2kwZmtUZGc0RnFsVmI3MGswUmU2N0JuRUNuYU9yMnJS?=
 =?utf-8?B?aGtUUzlnUDdhUFVRT3hPa3dFd25HSVhnSlJadGw3L3UzNTN5dURnQVh4ZWJN?=
 =?utf-8?B?QWpzVEwwNklVN1RRTWVtVHdMSVU0WUxiaWN1TEoyNWlBcmdvSFFLQmtOOGF5?=
 =?utf-8?B?MFFHSXNuaE55K3piMjdZL0p4TmsrMERsTlp6QWovTG4wd3hkaVZIUkZQWko1?=
 =?utf-8?B?RU44QkhJVE94RTNtNTZMR1hxVnlsa3B3SklZS3ZhRGkrelEzc0RxNVY0b1Ix?=
 =?utf-8?B?dTVndmVhS3hRNkhIRlkvM3VnYXMwczBlL1B5VUVjdjN5SmlxT21mK2NNcktM?=
 =?utf-8?B?SFRsVWdhMUdJYXpEVVJ0aE0zeGRsMWxPTDk5RnVCM1B6R0hFbjJsZU9wZzZU?=
 =?utf-8?B?eXpVdGFJSnZ5WU1lMFR5QjB6ZGNLUnY0c0Zzc3ZqYzArVEYzcUY0NGREYnpH?=
 =?utf-8?B?ajlRVG90TXBWMjYrZ01Oc3NFVFgrZjYydXFoYTIwUDlseDYvMFM2Q0ZtRUE0?=
 =?utf-8?B?YXFaUkd4SXJZTlF3MlFYQU9qN0dzaGN1ZGRyZTFPWkdFWStjR2FDbkc4ZVpx?=
 =?utf-8?B?ZVZVRXkvb01JeVZKMERWWVhYRWhUdFhkR21PWXBEUXVHQ1ViVXRUeXhmOG1S?=
 =?utf-8?B?cE4wWG5pcFMzcFVIVUtaVXhuMndGMUJxMStKM2NPV1Rrb3RydEQ4VU02dEg0?=
 =?utf-8?B?NmpnVndrL1JwY251QlNabmdCcTlhc3ppNVBwWlRtVnVkdjVmYlFTbzRrbW9W?=
 =?utf-8?B?UzBUblE5R1paUWIwZ0pKTFlQTm9GOUluREpsY1c5L3BXTlpKNEhPa0NtNU02?=
 =?utf-8?B?ZTRqSGZnS0ZTVEtoMkFLZ3d4MkhiZnV6R1dLT3JXKy9ITjRwcWhBcGE3d3dW?=
 =?utf-8?B?WDFLNnRYZTlpSlRPTFhOdG9oMVArMnBBVlpRYm5ESVljTXprVkFhK3k1dWdz?=
 =?utf-8?B?ek14a0ZhdGlhc2NhbFJFSG8vZStybkVtcjFOOXo3TlVpdStVUnFxN1g4L05L?=
 =?utf-8?B?cHZDMmdRY1hMak1wNWdSUUVKZE40b0RuZzdMczJhUVpYNkgxdXRYYnZVYjcz?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AD97509F3E3E74AB96AAD24E339B8B4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TOc0WnEcKvgzM9fAmkjNQBcV8azBwLGMjnvkisyg8ozeLzM6XbHRBrHSCu7TxOVDrhxvRHw+DNpIrMfI8uj3wFvRl4k3q5nx6B3b+HI189nG009MLM0PP3buTl4LvV33kNUJgJnOpRZfb0iS1i5ukA9TnRdE2hf/zbR/pcDICu7hHyYOT1dlBsoivoCgs7muiAE2UqjJuU9iYZR7ZVAtE3tHrP/IGL0Zu3NKMG2nRxNoMNmZQlCcu4cZQMbesf1zkkKh05A54VZU/s5IbeEy0UOvozc4m6PxEv49St+Cn+raWKx87/J4KQ9oDZPoLiRS0J6iopNtF1LYLgy93u8xqBXePmHRDYKiwtzFTMEQfWuc2ZZPvlisHHbg7o4G05t3S/6R/ea39eO2YRbwvfNlaDzRmsW4lpGMBzJUnOhIrVwsUsJ8U8qxk08b0WNlvD5OkVq4QwT4KSEQfyzTix3rYey2+tM9+ziHlZgctxw+9R3PqFCqvhV8d+7dWHojIVk6RMZzMs5cqRM/pbSKByIQVbQgqo/ZaNVFgjmQECey2yfc5XpGErlg/HA0nA6uqDdHCLcRE4On1J82k36bgEKbfH2CfYT8FC21sx73Zftl46cWank6A0WRVdPMuKOsUrbR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbec8ea8-6811-4b18-9399-08dcc0e19871
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2024 06:30:33.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FrdhPXWixO2gxyUE77vU7FlQmX/n4R9VoMWmj8J7yA4J8WIF1g+97rh5f8hY6o5H9Z5jGBCAcWuG++rVTvcq8jBH1O7nO5ZZEE5p7tX+yZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9497

T24gMjAuMDguMjQgMDY6MDEsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiB1ZnMgdHJhY2UgZXZlbnRz
IGFyZSBjYWxsZWQgZXhjbHVzaXZlbHkgZnJvbSB0aGUgdWZzIGNvcmUgZHJpdmVycy4gIE1ha2UN
Cj4gdGhvc2UgZXZlbnRzIHByaXZldCB0byB0aGUgY29yZSBkcml2ZXIuDQpwcml2YXRlDQoNCg==
