Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276FA1350D2;
	Tue,  9 Apr 2024 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675569; cv=fail; b=opJMk8LcYhvbrxqp9Fv0dWuxSe3aL/8Iud4SY7Nm34Ge/0arc1TZ8rCNOjYmfI908v/EupKkDIdxzJkfAdZKZIqDlxd+Y2Klwew0jtguqwuM2c9R82BBFnp/8mQa8kim675tbNJN5/r4URvWtD/otyjwOA2okY0zLlJLyZruLOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675569; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ouf58uy3gaghS0K6bzbVOHigdt+gQn/0QEop9NOa9Yx8/whdHfXvHexV1M0D0IHivTl5icl5ZFSzuzhqbFwZ0wjKTwa3V4mRnXvWm2Pw3/sbo/spWXah4YEG8hsELp3VEX6Pn9a5GcvsfDBl+boWX74QThfdzugM8Db9DWDue6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qNhY1PYI; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=gXgHYCje; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qNhY1PYI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gXgHYCje"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675567; x=1744211567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=qNhY1PYInzqe+ThjS8h+JpbOPX47NhQKOsfJmtu+yKFZ4RmwnXj9fDXX
   k+Uw0yhObALZB7HlqA4nXqketKEpMFA3DFYUFraI3KKbuOmoOu18GZ/vf
   hvszcfUMOYF/TNBdKSKQRvc8N1qAKvjqDB8D688R3L/AUTVpHGVJp0H7A
   Hx5DKH1ny7NrZKv4m0cv1VXiHF9mOrcm6jA5MRFoIwcJIx+ddiaXqxgMz
   qEmRiNzME5uGap2DuwVrgKqHaIn0UjGJnCyV9oKbKGocFhNCiNiYfRgax
   5N8FWU2JzB/Ix34BFaC79DvmI4u9+3rPphDIhKbMblQB+OhjyL8P3/dBj
   A==;
X-CSE-ConnectionGUID: C/9OEyIPTgijb1h7dCYiNw==
X-CSE-MsgGUID: oSQlKJxQS8uh9perdTkLUg==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13077115"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:12:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ocoe4dyjtExz8ZMhgVKhP8A4iiJ7Ro/6HffYWlHa4OAaRNAvr/o/Ui5WQKI3g7Cm2KTa/TBYoPYTHBOPfwMLLYBbBKOLzTGuouPWXh8b6WfFyXUox5Sc/x12E+xGCeYOyzwW3BQtNHds4L2WElpjRDM/y9XyHjWCSru04OiJRD72gNMLImbPtJFuQIbhh4k1Krt9m6nW+BcN2RDLvlCSyaWEHqnBx3Fi/qcmes8NuGt3TBDrfrL8as4k5f47eU+CHy2Y5H4BQHZIrMejw3/0H0N6ELwgvxQOpz15SVJbL5oDlnWkx379hEs77GNpCZv+PKwtgCsSh/RUR3Un8I1jPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=OkxsiZApkrqiQQVC/V8H/ZOM6WV0xxd+/HnaH9kZbC+s0msf9T0gFLCc90R01YsGOb4nInABHBTZ9VQ9OCNJ9jZfdvRKD2mNn/jbtSy0Xj/GMv9G+u19kFK+S/qY+Cwjm32VlIG3QDLtFVWUNA13zVHMNpURQ+ZZPDN6vc6vJ3lXRZYpSx4Pzbf70MtNFzpGoaWUqN/OlHrCCFu3VkzlhhzqjaXOOYd7h1/THK7dkNul8niTiaKhNjD4+CKNtwzX4sMBV8W4+GDzHMEz1EiyDLg6J2kXh+baBNHaLE6DmS4cQzFqZAPICClpN0atym6C18qwuJjKUwPbeaCxfR7PfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=gXgHYCjeMKs9TZeZBhrMQyTS1oPNe0asl6UceygSspvDFNdt5diXDsHMj6L6n+jVJ83fftW/XX7pGxHO12wlZpIu+IWzHpEJKUmdEErk0y0DSHwPj4YfyZNE7C81IY23FUsRDUo8nBGfz0hnjYvI4jEY1DcNyhKT4HZPmKkkF0Y=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6375.namprd04.prod.outlook.com (2603:10b6:a03:1e6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 15:12:35 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:12:35 +0000
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
Subject: Re: [PATCH 09/23] scsi: use the atomic queue limits API in
 scsi_add_lun
Thread-Topic: [PATCH 09/23] scsi: use the atomic queue limits API in
 scsi_add_lun
Thread-Index: AQHaiovKXFrNho+t8UGbggU6LD+uP7FgC5mA
Date: Tue, 9 Apr 2024 15:12:34 +0000
Message-ID: <8af92ce4-4ecf-499a-a1ee-126c0b463392@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-10-hch@lst.de>
In-Reply-To: <20240409143748.980206-10-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6375:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 UtALpQEcWrfwFy7uSRZpRQVoAAt9pVtzehBAutM+sGZPFnwoFAqrf+NLVIUTnn6RDCAYQTX32KAAsRMbIfrrqsrg3m5uPnG8klK4ybmbvnBrnet8nXVt2MKYxdMCqaMokC04ncx08cJxyNtvGQAp26IYcN3d7VuicB1h9IvjaG4HoveQeKMjQ+2SxE6dJnqpjjoGu2BrU4NB3iwRaE7ppb2ftNUedFo94ceWYhJhQ8FCm4LGx6I6wwoa0g01/xApeEEYHIZF4NYfigcj1X2udybgJ/huLlZNKiLSZLepZ9OvBT8khtO6QABf01P/5FiFNZm5cjej87TVSDuairPlbAtwSKGFhBas1qbN4OnD/cbTcBdKrBIswqd2Jin8151bSTSnZuNA4d6O72iZxfPXQPfiCPK5BPBcog4kBN5u/86NTbzTUzDBTDgGEGK4w3o1PdMxW3JCDrkIW24nFbpV2BofCgTl3jM1+f9EL77t64hj3tI+dCLUERkoMq6/cLkedC2jcIvVKoIoOgMfEr4Bcz3THg14OTeWHjCiW3kt6BMB7zAxXoy3Y7Igmt8pJHyN1C/X7vAud72xBSQbAJiUyzvhbRBHXvFuKneT5TKJFgJpf4f9BVbnZV4BnK8EEznHSPy+fHdFSmFIbjxsGwHY/w3TCw9eTFvs8Eq59aL+pqw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?akV2ODFYTGhSTk03anlkWkdtUnlTdHV1bGNTNXZDekhTSnVIT2lXak1OcE5S?=
 =?utf-8?B?ME9FQW9XY21KVkc2TGg5aTc4YWQrLzE4U3JPeDNUbmpTaW9NRTJoeFYzMkZP?=
 =?utf-8?B?b05aRUcwMDRaK09CV0Q0Ym83dmJzT3Z3SW5JUFZ3aE80MWhLdW9oTk9XK3h6?=
 =?utf-8?B?dWdSZVF1eFc5MDVhYUZELzJNMzF6NmFyVUp3dmE4c20xb2pqaEZUZXZEWElE?=
 =?utf-8?B?MytSb3EwVS8zRHNiWUtBbzByUVJTcDF4c3BIZmkzZnN5aGVmT3VaTHBKL2di?=
 =?utf-8?B?NVdnSlFuS0tUc0VOeDR0U0Q3RlZIV2REZ25EQTk4K09XWUY3STNBUEl6WGFh?=
 =?utf-8?B?LzB6NlVPOVJoT3pER0dkbHluNWFsVFJJNTY4WnlyVWQ5ZE14QWdSS0RUbWk5?=
 =?utf-8?B?VmhER0NhZ2xTU1F6blVFSFRpeUtuTUZ3Qjh0MnJIYTlVZ25XeU0ycjY3RlVl?=
 =?utf-8?B?ZW9KMFI4NzU1a3Q1a2FpbTVUMnc4ZFJVUitBUWt5OXF0enRXOVdUNDhwcWdO?=
 =?utf-8?B?aEphVFNKTWozSVJIVFFqK3JqbXkvaDRlMmlpQkRDQ3F2a2Y3NzVpbG1VaHJ2?=
 =?utf-8?B?Q2xacWp1WTA5Rll6WlQveHo5WEtNMzJyTUQwK2dWYjllVlhKTVdMQndyTXhl?=
 =?utf-8?B?d3ljZ2RLdW5WTkdxNFQvZVAzTW94OElPSnl3MFU0VWhXeWlZbTVONmljSmFK?=
 =?utf-8?B?dXZZVzhyL3NKSkFST2ZYSjhJTlN5OUtobGtidFFMbkFoSHdqWC9LZFFSK0dI?=
 =?utf-8?B?SkNrS3ZYRlNkQWdEQ1BJakFuTWF1NHZsOW9SRHRMTWtwdEhXdE5rY0x5RFIx?=
 =?utf-8?B?L3lNdm9NR2VMTlh3UU5pZmNFNzV4ZDMzV3JUUzdiV3BWREJWZnUrK1dUbXVs?=
 =?utf-8?B?WHZxK1hCLzFQVE1qMHd1T05EV1dsemNwK29VVGpWYzhENVZJUXFuRTZnUjRy?=
 =?utf-8?B?SkRJbG1obXZJbFB1M2F4Y3k4T0lFSjArcW1zamhPdldrVVhteTg5azJkTisz?=
 =?utf-8?B?UXVacVdkYWt3T3NlTFJJUWdSdjROYTQ4OWZiek0vTVorTEUzSjYvRWdwRm1P?=
 =?utf-8?B?dHFZYjYyWFNJVXR0cDhHYWVCWTlmRjRRL2Zma1VlU0d2cEZCRHVoVEptanh6?=
 =?utf-8?B?WmZyVjFOaUhLR2FqMXZvbXMxK1hwSmttK2tvMDVpa3VtVGIzMURSN2ZVenFS?=
 =?utf-8?B?YXc4di9Wb29ua05Sc0JrVW84ZTlKOVhWbVpaWm00Nms1ZGNLaGduUlJxRWgv?=
 =?utf-8?B?NGE0RS9CRW5LWG83clRPZEFIUStxUG9OWUMvLzJ3QlpGN2NvWDJadnBJdW14?=
 =?utf-8?B?VnlKdVo2Y3VIaFY1eEU3R09OSXk3RWNsd1Y3QnBSbTRJclZ2bW1zK3AxU0FP?=
 =?utf-8?B?UlJoSkROa21zZUNEUVAwSVBJNmpjR0VKWk5DOUowUlk0WlBTdVdadThDVUZN?=
 =?utf-8?B?U1M2SFZjMXZhRWlBOWZxZTdRcGU1RU0wK2dQQjM2MUNiTTRWaUdnaE9VNTJI?=
 =?utf-8?B?TndDZHlVVWw4eE8xMkpQTU9JZFJzbTA4NS9oNzQvd0J1bzRmejBkVVBqS0tH?=
 =?utf-8?B?MzRUZ1FzVm1iVzhXSUM3bUtVdVRuUGRDTFpEckdTRlByekRuYWxMUVJJSTZG?=
 =?utf-8?B?bktyWXJXaGZ3WHFWVyt2L21DZmVZRXI0SXRUOGhjRVoraHlTdW42UlNwNWdy?=
 =?utf-8?B?SWpudEVRdEQwd1pLTERqVXJkcjBaSW4zcWdTM1JKdm5mSFRTVkcrK1hyWVRK?=
 =?utf-8?B?dWVZNTE2ZlhyZVpXMkE2UUJoUTF0SWJ3eUY3SlluT0NreFlxTUNYNFpONkJt?=
 =?utf-8?B?am0vSE9PNWhGQi84dXM2M09iK2FiQkQ0eGNudG1TVmpyejJoVFdvZXRxSHhn?=
 =?utf-8?B?QUJ5d0M0MG5ERkFtQTlwaG9QM21Ma25XSmFkcEpqY1lsWkRDY3pmRWtOZVM5?=
 =?utf-8?B?UlUvcElHNzFjamdHakVvMUY5Qy85VmNSRCtoL3hQQlJ5eEFjaDBUa3RPUVdj?=
 =?utf-8?B?QnE5NWlaSllYRzRDVkgxeXBtSUozWkVUMGt3RzFadGsyT0loSDFOS0RrVXdl?=
 =?utf-8?B?UWFYRVBIM0d2QSsxZ3RWWDQvWjVsTkw1SkJ0QUFLMTN0MjlDcVdHLzB3eUgv?=
 =?utf-8?B?dHdaRmJvMi9DaHNzVzZXOHBuOXlFU0VqWEE0ajMvZlRKeHo3cy9TaTV1Qmt6?=
 =?utf-8?B?NXlaUllsa201dDlGckxEWmJMYStPR05HZDVQWThXVE5zR3BLTjdYM3o4MXk2?=
 =?utf-8?B?dnhSZXJyWUJBUENrSjNrVjZ4UzRRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E3DE83A40317449968B9BE536DA6079@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P0yyB+0pUayJRuP5eNL1u02By34jkJujpZt6t1DrNGA9DCgdQR6IVd6gpxlaPLZh9y/1j7BATwjqZfbOGda+ZGHPD65w0sJYIQ9SLb2sVT98pzKaRMTVoVy5IGmWLCTMNhj63iDIKmr+YTLuAUIvjUGLmWh90HA0f/kwhd09vPOh8bXqcZY2spNtR7eiIxIdRkZv8JyV46hBqqHZTlfRl/9+vmPbttQoCVNrtx7rn7VNoicqm2x+p0ajIURqwe9Yt5aPAkfuf/GMvnn6gr9t4Kh2OWDmlSI6XGxnlYMjfoIQ4zl6BFI39jdBMW9Hzd+lo6/tote2T4zrWVBFAYNtkSp/qtnPbT6zMz8ZGMUb8HVwii0bl4c/gYViP8BxXTK+3FWv+1dF3C0VCA3YIkQ/Xn0yZh/gUKo9thlyFJ+mKGyiSbtZ/kcBtJFaPEj5TS2BkGN+3wNIf/KvkgwFmy7OYyW/yz+gcLs8rc1qI2bnG+OF9Ksvg5D2UNX11hOpRXTEaNAb8tcouUTqpOtLEgfuRtx7hTFDk2cBmD/zEBrkt3/EO6a9/cJSr166aq4J+7GBgEQwYb391wkcX+jdtE+AlsW9HtpeNdYsT7EF8rafWYGyxLMerZxP8yniR8ho8BZh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1f855a-f83f-4c03-0cd6-08dc58a77c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:12:34.9936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUPu3G7SvDdhixKGD6SnUZ0ZeKuTXmX5PLt7teKjNH27lM8pcfc0bNjJNfHGqVcF2UxtyARu/LEeXw+qbzC3vSm45r0p83X6u6Ugi+RxfBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6375

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
