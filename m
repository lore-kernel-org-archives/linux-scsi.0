Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C8D38E8DD;
	Fri,  4 Sep 2026 05:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499604; cv=fail; b=tjf1SAvYbO0OE/OA53cav8KlOfIlm5Ob77GGbN/SldbLESe3H5DVxCgvxxMY4HgZS2bd3xN96tLSOmJdutuoCxeBpemIB97tf0zELovBX32ISZjPit6DSHMyiiLX8mm+GPeOmwByXuEfxFmDkKKy0l7IUfYV/FgU6FotY6ZvexE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499604; c=relaxed/simple;
	bh=sLJFDaEFMTzrxuDbStX8SnnN4NZSZ9ijM3QV9ABLr1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G10Tr6EFqpY23yENLQdFeSQaAD5gBX/eu6yTSvDxaH2gAPj8x+a+tMNe2usXpFfgJyd1N/idQKDGWztVthF0xjBghvQW1t/G+qCh/+9zj0OMaWq+Am4JJQ0PPiaGhwZOGk+v7gaMOnCDo1b07gqc3/Cug40Vf8RMyKzkYgChvs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BVEGr4sN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XyOox8Wk; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BVEGr4sN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XyOox8Wk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788499602; x=1820035602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sLJFDaEFMTzrxuDbStX8SnnN4NZSZ9ijM3QV9ABLr1k=;
  b=BVEGr4sNTHsq81sWFD61+tWTxqay1i2gs2endrKqcL0ocXbvIWWzypY+
   NCv3Ncklf0YxNmAV2KeTguvHwADxd2qkPnPwxZDKYBGsVonHYtNm+wjmd
   d+AbAkvKqzD0yJjWNYclai7VXfT+gkidK2pQKLzUENO9fhDhsttfvh7K6
   gxNBIwYP10q3BvbRvBF3oRialOrBt3WGd9A0WcmM79oPEG8hJLAq7Lc94
   lSD9iQ7SETLqDPfuYtrlszzHyD173LQGhZdz0wyE5Ki7on3QVCGGomTCV
   7frfcfGOdLRqUscyhUEG0XUXXpcGQws2Dcqpnne5UYZt67wp3DdOdiE1s
   A==;
X-CSE-ConnectionGUID: KJl+W6eRSVeQs7HjNir0YQ==
X-CSE-MsgGUID: vQW1cW44TzCtUdGdVHIdRw==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="155858120"
Received: from mail-centralusazon11010058.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 13:26:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NMzdYp1JtJLv0f7vuY2sCwEzJBGSz7JsvO76F4VEW4rSGKqD2gqr1OEdIIK0YClNB7RqJvepbxQYmC4Bg2Y3E0fiCv0MbxoFv+objrUT10o0aQ4KW9jaR2X6W9IWQiA5J7TIsALIdse6wU51S8+qlOwsp0qu7y4lLbu3OIa5qq71pAaqo/9J1cMlwykhD7UqkEGBVmSYZuUQn2lu7+vbhSIM8TpQcPwJS5iXeDSpehQ800iXCzVS+R2jPCBQwt3BM+2vkkcpr2IIPd5SNR0ESFivHg4/s5o7m4Hx4AVBdOqr6pTyXYN+OdkNgT2kmClm6tCEIYhVIl/Zb8YQ1VR13w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLJFDaEFMTzrxuDbStX8SnnN4NZSZ9ijM3QV9ABLr1k=;
 b=rjrRhMJEy5fiFp8ZxrlX9auF84hPi9wpcfYm3epgoY4sMiuApeDesVVYju9rT+ka5mrRVBbmt24QZ0V0YDvVUF7OIUulgRLmUyXs2Dt6xkvJ+onQD/S45+LdoW8xv/DSMlIT6ygDhoSrr+IkuIHNYjCz94HOrEaCys/BkrjVo0Fq0xu4aL7ijfxmxmCXhND+sGhdSQRPcEFUY9C3Ytbc6vycsmqa4TSLAm+jkLgTuxBmJvsfERZy2MA6b1a2RJXdfNpbSJ7LrBfq6xmZKUOY/jP5MFgoNxRMvyWlTrNfjXLqDwt8Yi85uTYzhEQaM4gWpETKhhayCG8vV9s0pFsb9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLJFDaEFMTzrxuDbStX8SnnN4NZSZ9ijM3QV9ABLr1k=;
 b=XyOox8WkDulghukNsXjHBvsKb/XCpcPqPMolPIvx18O5uaCjru3Sr/ST0a53o3KkpoqgITlmeCLa7qQM/EaXKfv/YAElLPw4zpW3zqig/yPOUzZ/hNsF0EXa0y0hWDqMW/G25cuXn2DTwYThAkRAwrP+w20Ws8Fvp19msCmy0a8=
Received: from BY1PR04MB9561.namprd04.prod.outlook.com (2603:10b6:a03:5b6::11)
 by CH2PR04MB6839.namprd04.prod.outlook.com (2603:10b6:610:91::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 05:26:37 +0000
Received: from BY1PR04MB9561.namprd04.prod.outlook.com
 ([fe80::3869:e494:2fa8:9888]) by BY1PR04MB9561.namprd04.prod.outlook.com
 ([fe80::3869:e494:2fa8:9888%5]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 05:26:37 +0000
From: Alistair Francis <Alistair.Francis@wdc.com>
To: "mani@kernel.org" <mani@kernel.org>, "cassel@kernel.org"
	<cassel@kernel.org>, "dlemoal@kernel.org" <dlemoal@kernel.org>
CC: "alistair23@gmail.com" <alistair23@gmail.com>, "jasowangio@gmail.com"
	<jasowangio@gmail.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "xuanzhuo@linux.alibaba.com"
	<xuanzhuo@linux.alibaba.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "eperezma@redhat.com" <eperezma@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kishon@kernel.org" <kishon@kernel.org>, "Frank.Li@kernel.org"
	<Frank.Li@kernel.org>, "den@valinux.co.jp" <den@valinux.co.jp>,
	"mkp@kernel.org" <mkp@kernel.org>, "mie@igel.co.jp" <mie@igel.co.jp>,
	"mst@redhat.com" <mst@redhat.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Thread-Topic: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Thread-Index:
 AQHdObPJz5OVFDRvSEWKpAWXM9IaQ7a5ZmCAgANbVYCAAM7zgIAANFKAgAAW4QCAAAylAA==
Date: Fri, 4 Sep 2026 05:26:37 +0000
Message-ID: <214bbcd5d29760543edb47d8136cc40fa7d7b6cc.camel@wdc.com>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
	 <apaOZeeDBIRlpB7b@ryzen>
	 <akvzpivrbg3b3jra6ibga6j637pwqkwnnzs6q2ymcn5ixrdym6@wniqpspkcknt>
	 <795ac93a-9377-4503-9dc4-58f21c815f71@kernel.org>
	 <2daeb43d582f0d960370fcd415c3b5bd3d94c67c.camel@wdc.com>
	 <d4bd2363-48d4-4fe9-838d-7ef4a0f4e0e0@kernel.org>
In-Reply-To: <d4bd2363-48d4-4fe9-838d-7ef4a0f4e0e0@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.60.2 (by Flathub.org) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB9561:EE_|CH2PR04MB6839:EE_
x-ms-office365-filtering-correlation-id: 5dd21a82-b520-4afa-a2e6-08df0a451795
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|19092799006|23010399003|1800799024|7416014|376014|56012099006|5023799004|4143699003|10067099003|11063799006|3023799007|22082099003|18002099003|38070700021|6133799003;
x-microsoft-antispam-message-info:
 pLd0IeQnTSJggB9ZEK19be865/c06yICQO5AgFONV6+l8U3Qtw8obeKaHPKhozfOmbHAC610H5lebgXI7GqSd1MaC9sfcTz84V52IOnpAkVw4aBgKmdGiOiTvq//5ApMUTe6rXP8FHJI6ts98ru3MCqhLqDhEhbhDN5yW2J2sbBOF/yFJ9wRcmxVTFLnyc9lsdkFcAYId5g7ZMvNB8aO+pgggg98mxrAcxuOw+85+DsxNRF73Yz8mEega70QJx4yA9DZylR8AQo90nPyCK2L19kujWocLblkPXt3LSm0DbQgZ2SWjrfOtiknOnIJUXe7jwQJPntLw8a32uVWkBA4S2cttsKY/UJNf4eDMXry1COhyx0FEH9a8vFI8JClJCN4NZkeLanrmxhMP9sbF9ZKHQeCd+GpU1NFUPONJ4rNPqCVMKrbq0CwhU+D4Ly8GCf5dZDelEpUb6s2N/Ef8I4XVew+JXwxKMs4cpwv+nhXundRSpQoyxDMlW8YygVMeSqaT4zDKWJ00xDTcuzO20waqXemEqH1JtUdwZ5BdjdkK9HzGuOZne06LkRttV3hka9yibF6BgzVaA+WJUdXIiHP7LEC+q64fg4cQo4CkeJdIyGdD874zd2DHmdhmgdCdXjcMyDpHCb/xKvh/S9p+iqiwzZZglJkcbJxnxXk/zODt/VFO8agDyo9xzSGRY27wk3/KJR425+7+/YeYU6qJJEktrwTTTMA5EjNJ04tSNgJL1c=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB9561.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(19092799006)(23010399003)(1800799024)(7416014)(376014)(56012099006)(5023799004)(4143699003)(10067099003)(11063799006)(3023799007)(22082099003)(18002099003)(38070700021)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QUxtdDExWms3eFk1ZDFKdkM3UjRnQlZCQ2dRWkM4UG5SL2hWUXNScis5MS9o?=
 =?utf-8?B?YnliRlNxVkh1aDR0a2dnNDhoRms2MEdrcGs1OWdiVUg4aTFIVXV5SEwxaGlX?=
 =?utf-8?B?bHR3bXErQjV2eW9mSjd2TUowb1QwVmNIK3pyWmNuNFFGTlZCL2ltQWRrNjVX?=
 =?utf-8?B?ZkVWck9lQ2dJNE5RSHNjbW01TEFIdnpMTWVDcHBoTXZzQU9OS0RHU0NEbURs?=
 =?utf-8?B?S1lpeUZyOFFYMUc0NVlyMjR4aytLWGtSOEpoZlZBYmRIa3JlMUNMMUFlZVFs?=
 =?utf-8?B?R2g2Vm5qZDNUWEFEeGU4YzV0d1EwdWxFbWcyaVdiSVZSUkpYYzBXRGVBa0FD?=
 =?utf-8?B?cnJ5NTh2YTl1YWR2WTA1WGlqVXNjTVFLR0VuZ2JKSEROVlNWeHNkdGlpWGc3?=
 =?utf-8?B?VGtRY0tmUUk2Rm1jOW4vV09ydFlOWWZFNmpJWllLTU8yU1BxRmd1TkFGdE9L?=
 =?utf-8?B?NGxUMTlaOGNvVjR2bDg5N2I1R2JpMFFOaGt3U3p4WjdNcmZOeWk4citpYk5E?=
 =?utf-8?B?MkVHL21saDJNREZPeTRWRkZaSCtHYW52VHRBK0tIUVpOTHZoVnA1OWRuTmJq?=
 =?utf-8?B?TmUwTGFBbU1najlKZjFFN1E1S3JBM0w5ZDhqWkxKVkd6VXJwdWlJcEk4dzJj?=
 =?utf-8?B?SklkZkxWRXhSSnR3VzhkTnJMSENVdHQ0WjJ2ejM3QnFHajYrN3owWFlKM29a?=
 =?utf-8?B?SmE2NW1ZVjVTVyticE1OTDNNMTN0cEkza0RFcWlZZjlVU0QwWmVwM0Y4NC9s?=
 =?utf-8?B?ZEM1QlJKTFozTzdaa2tsNlJoZHU1ZzlVSDNJYk5iRWtpSW4xbm1wVXBlNUp3?=
 =?utf-8?B?VnlJTzlHeDQ5anFVdHZVb1BhZnNMZElpMzZHUWR6MHlhb2RSZUFRakRBM1l3?=
 =?utf-8?B?MHVqNVJiampqZ1AwMDdMSFhUdzlSaTRnWWFjSnp2OCticmZsb1A1Y3ZCNnZR?=
 =?utf-8?B?a2tzcnJadXRRc0dQSXQ0QUI1U0xxdDgrZXJ0SUdqTm5aaUQ5cFFJR1A2aFMv?=
 =?utf-8?B?K3cwRmZSMmcxNDRGbGUxMVJ1UFJ2MlNmTU5XOXRzdlhZVG9lU0lHdEFXYTUx?=
 =?utf-8?B?Z2N3V0ZFQ0NxMmZoaW1mQXJRcmtTcVB1T3A4Z2x5eDdUUThFclh0Wml6VmM2?=
 =?utf-8?B?TGJmT3liWGVHUWFrTUNGTUJydllMaWFVRy9wZHpuM3NYV1Z6SWtIcUpPdk9Y?=
 =?utf-8?B?c0doUCt6L1pINm80YUdQb09RblhVRE1QdFJJeWZqR1p6Njh4Qnk5NmZ2Nlhi?=
 =?utf-8?B?MGUwdFNOc3VGM3lveGx3eFVvWmNGMGg2SnVnQVpUMmRUd1N5N29xTHhmQWx5?=
 =?utf-8?B?dzhoaE82dHpsWnVSSzMySXE0VXdWaTBiaWNZWXRmcVA1YUZ2TGNLZUsrR1JJ?=
 =?utf-8?B?K2ZGMkZjcTk0NUVCM0xFMmNmakRGUGxWVEtIcWw4VmhURlQ5cU1WY3krelA2?=
 =?utf-8?B?OHFXRTBsMGdEeWtlUUY4UWJBQmZESmRPSlNpL3VGb3JLaDdGdmVmaHR4Q1g3?=
 =?utf-8?B?SXVlaHN0akphbStBZFVHdmNCOTRSbWJOTkN0T2xOV05xc1MyZnJNM1Q0eDBV?=
 =?utf-8?B?cmswdmlXQlNLdjR3Q3UxWFp6enpnUzhXQWxUNmJTYTUxOHhESzQxblFTOEdW?=
 =?utf-8?B?NUl4ODhuK01sMGRYWVZ0K0xLWVROS05BTE8zOGpLUVU2SzMwTE5JODlOMndM?=
 =?utf-8?B?Q2NGbjlValhZUlBtVWRiWlYrdjEwOEFNR2pxcVhmV3FxdzExUlZBaFovU09t?=
 =?utf-8?B?ZzdEaWRoUVVDWVF2MVZsVUJ6MkMxSTl5eXU3NXVZay9GcktsRStpUGxuMG11?=
 =?utf-8?B?dWlpbHgxS1FyakhwaTI1K1hiRElrdlBpWmFqcDlTS3o1Y1RYb2RZRlpNYU1V?=
 =?utf-8?B?bWpvM2RqQmkrU1dETDJqSk1uU0FKZG9pMUhXMFc0eFZLWkxZc2VNdWxyN3R3?=
 =?utf-8?B?SDEzdjAwQ3U0Y29XS2FFNXdtVE9rTnYzekRqUW51SzY5VEV4ZVJjK3A2TEJv?=
 =?utf-8?B?NFM2TUpCeTR4R1VIRXM3dmZnTFY5YXBreE9aQUdobFNCVUpOUlZVLzZOdmR1?=
 =?utf-8?B?dUh4K3hBdisyWWoybG45cWdkUVZQYnJvcmx3RTRWWUgybEcyL2tMVkFYdmhH?=
 =?utf-8?B?VEdaZTV1OFJJM1BWNEErdHBPaDFIQm15RmJkcnVZcmlqdXBqV0FBNndyb1ZW?=
 =?utf-8?B?dUxQRG45YUtwV3FtWkIvL2U5ek5HS1phQklhdWRZWXhrUDJHV09HVmRyNUdX?=
 =?utf-8?B?NTkvUFhNRUw3NTV0emdEWUNjTDhwQXB2Wk9sZ3Y2WFM3RUdkTkZ6UEttTTht?=
 =?utf-8?B?NXZMK3c0R1dnN1p5YXhMalJaMGpTaUhlT2Z3OHNjUFRiRk56Y1Z6cGh5OGdo?=
 =?utf-8?Q?GrGCLOX37HNTY1hzWwxHKU4+ZKsysf8KQfrE+jN106vgQ?=
x-ms-exchange-antispam-messagedata-1: CbcrpORFbFXvGOpDSqxobqpJ4IyhDCUnHlU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C8337C6F32D0E478F2E52AECF928BDE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	xkznbl71Nr9S3UeZhgnwRnW2Ks9jOE2QxecYqsg/58bR0SgLkLR30nUTb3Lzl7cG7VG1HW22yP8pUSmmpiB/952d5UuH6mbyidYjMngPWhOseJzT9iFZ483VGFzojMhS7HtAEkxrQAp3SMk9yiTi5vqBWQ1o3c9lfF8MJIwUufq4g30dCxSXFCHtlj6PALY5PFHkTDS9Sqr7uhG0O0RFeFLPoxQocPyeDtQbdoDXWMLwkh/VqDsXRTuO8o7ap8cxWwIFgH28KwIxtCgWNF5Z0V10ofhOeVALjjyKklu1rXFEzgA7qQ5id93TH35LCYo8AwynpR0nCJtSK0kAHzwGFA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6e7gSVHFNMK0txU6Gf1xEq8sdDvFpGwk3BzGa2HH8zGzmy9WxsoqICP5fQmp8WCPN7C/TcNiyLR+mHPLq5U2bzQH0UNBvwiDW5dSr0r/9gUskixExIntrG/Nf471gdePxBpCb1oV6UW9BCjOFRUaPK+LLuGorhX7OC+jnNNjMmuJWeB/PRDc8Gy0wlw4ilqVHEwrreSAS8clQkYR2DSQQun9k1/b4uWVabMkK1HD6JGCczlAwTX62RPlri6slikvVLPcxcg4XlxQwZrVfjKWXpGOu0vOCgz+M29MTmB0ernw2N51kmaNMwIR4YegT1xnashXqdWTzZzh+65P7MHDK56bIvTZuaTj1UYZgUjlB69F9UH8fDNMupVTMKA8zqLB/2tHo5lcANtFABy5h9YvmQWsPpExFcD+MZNPIo5T+JsAE4kRmWkR/1K5lOUmlkqAHW4k3hAgWzg7dnyw+7E2CCJ52nk9pjiWxHHVGE69rFMk4WPQzFH0catPiVfRU+eNNSumuxgvMt7A4CMQJps16KxIQ6YlZMlLqjT7pkGH66GHBAbnSPzu8eGmr3noaS+k+2cPzWwGrLn1Z/MHkrvHDFJJTpklwQxor0pVTTue94kZsCqMqoa82IAGu/B+t06W
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB9561.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd21a82-b520-4afa-a2e6-08df0a451795
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 05:26:37.4504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QRjwLqjYrT6R0GDQ1iPnsNRc+Cer/ngozB/BUiW4JuBHAJ0sTPhDrx+/uB6IRPLndAAXA5h1KQTHTaYq2I02lP7fI1Nt3b8uTzGjtnRPEJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6839

T24gRnJpLCAyMDI2LTA5LTA0IGF0IDEzOjQxICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gT24gOS80LzI2IDEyOjE5LCBBbGlzdGFpciBGcmFuY2lzIHdyb3RlOg0KPiA+ID4gPiBNb3N0
IG9mIHRoZXNlIHBhaW4gcG9pbnRzIHdpbGwgZ28gYXdheSBpZiB5b3UgdXNlIHZpcnRpby1tc2cN
Cj4gPiA+ID4gWzFdDQo+ID4gPiA+IHRyYW5zcG9ydA0KPiA+ID4gPiBpbnN0ZWFkIG9mIHRoZSB2
aXJ0aW8tcGNpIHRyYW5zcG9ydC4gVXNpbmcgdGhlIHZpcnRpby1wY2kNCj4gPiA+ID4gdHJhbnNw
b3J0DQo+ID4gPiA+IG9uIGEgcmVhbA0KPiA+ID4gPiBQQ0llIGRldmljZSB3aXRob3V0IGEgd2F5
IHRvIHRyYXAgYW5kIGVtdWxhdGUgdGhlIGNvbmZpZyBzcGFjZQ0KPiA+ID4gPiByZXF1ZXN0cyB3
aWxsDQo+ID4gPiA+IGFsd2F5cyBiZSByYWN5Lg0KPiA+ID4gDQo+ID4gPiBUaGVyZSBpcyBub3Ro
aW5nIGluaGVyZW50bHkgcmFjeSBhYm91dCB0aGUgY29uZmlnIHNwYWNlLiBJdCBpcw0KPiA+ID4g
YWJvdXQNCj4gPiA+IHRoZSBmYWN0DQo+ID4gPiB0aGF0IG1vc3QgUENJIGVuZHBvaW50IGNvbnRy
b2xsZXJzOg0KPiA+ID4gMSkgRG8gbm90IHJhaXNlIGFuIGludGVycnVwdCB3aGVuIFBDSSBCQVJz
IG9yIGNvbmZpZyBzcGFjZSBpcw0KPiA+ID4gd3JpdHRlbg0KPiA+ID4gYnkgdGhlDQo+ID4gPiBo
b3N0IFJDLCBhbmQNCj4gPiA+IDIpIEFsbCBQQ0kgZW5kcG9pbnQgY29udHJvbGxlcnMgdGhhdCBM
aW51eCBzdXBwb3J0cyBkbyBub3QgYWxsb3cNCj4gPiA+IGRyaXZlcnMgdG8NCj4gPiA+IGNyZWF0
ZSBleHRlbmRlZCBjYXBhYmlsaXRpZXMgaW4gdGhlIGNvbmZpZyBzcGFjZSB0aGF0IGNhbiB0aGVu
IGJlDQo+ID4gPiBlbXVsYXRlZCBpbg0KPiA+ID4gdGhlIGVuZHBvaW50IGRyaXZlciAoZW5hYmxp
bmcgdGhhdCB3b3VsZCByZXF1aXJlIDEgdG8gYmUNCj4gPiA+IHN1cHBvcnRlZCwNCj4gPiA+IG9i
dmlvdXNseSkuDQo+ID4gPiANCj4gPiA+ICgyKSBjYW4gYmUgZGVsdCB3aXRoIHF1aXJrcy4gTm90
IGdyZWF0LCBidXQgc2ltcGxlIGVub3VnaC4gQW5kIGluDQo+ID4gPiB0aGlzIGNhc2UsIHdlDQo+
ID4gPiBuZWVkIGl0IG1vcmUgYmVjYXVzZSBvZiB0aGUgdmlydGlvLXBjaSBzcGVjcywgd2hpY2gg
YXJlIG5vdCBncmVhdA0KPiA+ID4gdG8NCj4gPiA+IHN0YXJ0IHdpdGguDQo+ID4gPiANCj4gPiA+
IEFuZCBmb3IgKDEpLCB0aGUgb25seSByZWFsIHByb2JsZW0gdGhhdCBjYXVzZXMgaXMgdGhhdCBh
bg0KPiA+ID4gZW5kcG9pbnQNCj4gPiA+IGRyaXZlciBuZWVkcw0KPiA+ID4gdG8gcG9sbCBQQ0kg
QkFScy9zdWJtaXNzaW9uIHF1ZXVlcyB0byBzZWUgaWYgdGhlIGhvc3QgaXNzdWVkDQo+ID4gPiBj
b21tYW5kcy4gQWdhaW4gbm90DQo+ID4gPiBncmVhdCwgYnV0IHRoYXQgd29ya3MganVzdCBmaW5l
LiBBbGlzdGFpcidzIHBvaW50IGFib3V0IGJ1cm5pbmcgYQ0KPiA+ID4gQ1BVDQo+ID4gPiBkb2lu
ZyB0aGF0DQo+ID4gPiBpcyBzaW1wbHkgc28gdGhhdCB3ZSBjYW4gcmVkdWNlIGNvbW1hbmQgbGF0
ZW5jeSBhbmQgZ2V0IGdvb2QNCj4gPiA+IGVub3VnaA0KPiA+ID4gcGVyZm9ybWFuY2UuDQo+ID4g
DQo+ID4gSXQgaXMgYWN0dWFsbHkgcmFjeS4gSWYgd2UgZG9uJ3QgYnVybiBhIENQVSB0byBjaGVj
ayB3ZSBlbmQgdXANCj4gPiByYWNpbmcsDQo+ID4gd2l0aCB0aGUgaG9zdCBhcyB3ZSBhcmUgdG9v
IHNsb3cgdG8gdXBkYXRlIHRoZSBjb25maWcgc3BhY2UuDQo+IA0KPiBIb3cgY29tZSA/IEF0IGxl
YXN0IGZvciBudm1lLCBpdCBkb2VzIG5vdCBtYXR0ZXIgaG93IHNsb3cgdGhlDQo+IGVuZHBvaW50
IGlzIHRvDQo+IHB1bGwgY29tbWFuZHMgZnJvbSB0aGUgU1E6IGlmIHRoZSBTUSBiZWNvbWVzIGZ1
bGwsIHRoZSBob3N0IGp1c3QNCj4gc3RvcHMNCj4gc3VibWl0dGluZy4gVGhlcmUgaXMgbm8gcmFj
ZS4gSSB3b3VsZCBleHBlY3QgdmlydGlvLXBjaS9zY3NpIHRvIGhhdmUNCj4gYSBzaW1pbGFyDQo+
IHJhY2Utc2FmZSBwcm90b2NvbCBtZWNoYW5pc20uIElmIHRoZXJlIGlzIGluZGVlZCBhIHJhY2Us
IHRoZW4gd2UgYXJlDQo+IHRhbGtpbmcNCj4gYWJvdXQgYSBkZWZpY2llbmN5IG9mIHRoZSBwcm90
b2NvbHMgcmF0aGVyIHRoYW4gdGhlIHRyYW5zcG9ydC4NCg0KVGhlIGlzc3VlIGlzIGluIHRoZSBj
b25maWcgc3BhY2UsIHNldHRpbmcgdXAgVmlydElPLVBDSS4gRnJvbSBtZW1vcnkNCnRoZSBRdWV1
ZVBGTiAod2hpY2ggaW5kaWNhdGVzIHRoZSBjdXJyZW50bHkgdXNlZCBwYWdlIG51bWJlciBvZiB0
aGUNCnF1ZXVlKSBjYXVzZXMgYWxsIHNvcnRzIG9mIGlzc3VlcyBpZiB5b3UgZG9uJ3QgemVybyBp
dCBmYXN0IGVub3VnaC4NCg0KQWxpc3RhaXINCg0K
