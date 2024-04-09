Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B32B136E05;
	Tue,  9 Apr 2024 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675182; cv=fail; b=rAFL6lgCij+5MMMd7uMTUqxvgxOlW/twxdmFQU/Y+q1hK7AgoAqaEj9s4hXlY73wRik3NmQqPA0ncPPBUssh+JgKV3ivTL/Xa2YAwFagoLlUMwUw5I1u55HzLxY2kLqnjqE0xbySbGtBrtMdumWVPFp3qdNGf6p9uzPo7Y3mgE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675182; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lJP10dGXcWlr0W0vD6VRGm9V0fKqpPw/1LdvwqwClzkCcahEysR5jsHGtGcswaystYhDBKQkDeD2JfujEGKetOi/tYn+voksMG7t6HXdUIrXOlNz8iQIbwRZuiFjU2I0Xi1CuPOe2D11YYixkw+kvDgSM1Vu4jgKwI8njQ0215k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=khF0H2sY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yiV9/d8j; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="khF0H2sY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yiV9/d8j"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675180; x=1744211180;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=khF0H2sYLe2ag3ngqNIsmQagNeYu376wpwILymtTSaWb5mz0CgyiAW31
   7zCYq+O2FL+BanDbotKKG1OUvFIfIiY4o3jGOmp+nVmGo3pnrnVmMbLzO
   zwMh1KaM8Vjh+4qKtUm/FbGoxccJ/XjJy3Cu77EIVhrixxEsjFdC6+iwk
   K+kaH6J7i5vXAZZwj1vD6+ga3H2bpyUI5OZwgT6GKWEUv0rY10zjjE/gO
   53xtnjK0RHNxifJEViJh4Uvc+3v9woFNfHeBa/QlS5r0ERWp0ivlAbdGj
   vB70Xgwd3iQA2zIFgGtDJ4O+BOg0Jn8VaI2oRt93WqNv62uWyKWqejOr7
   Q==;
X-CSE-ConnectionGUID: TqMKuWl3ThG62cYPwji63Q==
X-CSE-MsgGUID: Am0Q+FpjQCCzXQQKVG7Spg==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13601227"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:06:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afVGE3p7b9pYiPhXubJxtMnTKwXoLdUYhhqoKUQpjjIAHyK8POXoc4bP0RAJJEM616oj/FmZcpf2NogUPrYmjhpL9QrnMNO4UC0JceOKOGzLTp7nmQ458Ir18K/0tIlK0f2FaqpHVgqS4ZCwc75+WyQaPs60CN6xtcj38hNU+iNuenCBmd8I92O3+sYM0paqxZ4Sox2tSIpkW7T2HRCHvCX+jylH5dQLAcxBqlhXMWVUaYioJHYsPd0EWc10bf9OJfk7BGbFsA45EER8xVurC8IzBDuJkPtWchFU8W7U1npCP14iCAUkSDz3Y1p7dg8nbnwVPjk0iOQHlxSvC0nuNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=d35/5EmeZ8M2YHfAzntoGgnAEqSd4bhnydsQO1lppOdF+Qa6MqbULazfzisEpKZGQq+8RWIXPupZa0IdaVqem39X5U76nys92JEAPave7kflLkKPAWbpvjl0/maUsZ9PdJ0TJ/AYUBvny9CrVsnXJr6BkrnoqOM6xntZEKe1VoiMfQbzi9eugA2vpb/ruhgpxsm4jtQaCOv0j/iTS8wjxxlSykn8pVG0KmWOul2cZSb3Z2UEVV1K8gR3WjXOK6k6Q7kkd/utibkO41ZunVHh3tjat+6n8N7LcJClqaN7dZA/gc4cciNgC5FbelAg/HHXZc7z7XWndvjsgsXoOudSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=yiV9/d8j91Y2O9GAG9Q1d1IB5/kRBle6TzXZLMaOp5p8Cld/3W/ZGIARF1o8ucMBwrm4If0KQxLMRRIR0xfQdNG1M7LEONonkMeGXlDbXOaK7eM94HnxUk5y3mxsPKngf1CZvCu54kJsPFZyK1Nw0/5cGheC9jIJRuSrWk472HU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6760.namprd04.prod.outlook.com (2603:10b6:610:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Tue, 9 Apr
 2024 15:06:08 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:06:08 +0000
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
	<usb-storage@lists.one-eyed-alien.net>, Kanchan Joshi <joshi.k@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
Thread-Topic: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
Thread-Index: AQHaiouc6oymJ0ZL402bahR3WO6rDbFgCcwA
Date: Tue, 9 Apr 2024 15:06:08 +0000
Message-ID: <1145fb5e-4b15-4cc1-9266-1734c8a6b5aa@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-2-hch@lst.de>
In-Reply-To: <20240409143748.980206-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6760:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 T2tA4gvIvhQ46N+4BpKzoMR7Xen+Gt814KOtzXmpmkrKrDXfjYuih/QUrONhvR4ZqglNElGtuEyfe1Y8jAgeZQ8mLJpeeJnNmAIXLuT8b6hrI6OvAtuGdDlTfsep2fSzs03A0TcXsX+XxqgWneTN0vGB2tmNGuRvbkCASfSldpBFD9XtayAxLKlkLWUmc6PlgJj1g2vN6Wucb6Smgy++vMPxFNsv5tdsnlyYjt/JXGBjnTcMcNlwEl4bebBHpKMKfW6wnB7s4Z0JZw2bxmPt1gcRAB0cuItpkfMwznH6VU9x6G8OeGUAn1/Jo8/bJ6xHusJuR+VQ6nCC45Ue1/kTvHOtgdgQpxUoklk5yLwr2Cz4StdkArDpLvJUGVfujBKqPOEPMlk3kKfr7nh5QuedOvvZmCc7dJ/UuiLyLP1FQMmqN0i5UX/vyD9J/WZd+xg3p1pjK15e/KdSGK0sOyk9i3mBDMYbDpaintL+eWPmHXTzZpHfeolwwzlWKDHTu/AuhkE4WvvgZyOZPhLptHhmF4+/PGAZ1MIzRckiljjKyI8ToolgOX/TOqyt5A1HxwzLzHZ7ybNSAX6QYasNZTSRlRa/bYZZaeDtQ5cQ/eL/KvCPxYScUaOaqpSFpC3Jpo6gv/ufidcxzPtLAGiBMb+sKiPPlHx2R10ophS3iAPjNak=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZTk5a3BUelhsMDNjazB5R3RGY1FCaysxeERoTGNTZW1PcTh5aVQ5L3pVeEFk?=
 =?utf-8?B?L0Rmd2V6VVREcGtlYUhjT0dSMzNvYTg5MVFsaytoTFdaU2gvQzRYR0YzT2tl?=
 =?utf-8?B?WEphRHVFWDFWbHpKYkFZY1RJNzdISFY0YWFRNEY4U2Uzc2xpUkhNYktLVnV0?=
 =?utf-8?B?VS9oOFgyeEFxUEsvNTBpbkZ2VmxJMTdFNi9rbFJMRVUyd2ZtR1FXN3A0UC9s?=
 =?utf-8?B?WGRlSXVZaldwTk9ucEkwcm02cjNoWTM3M0FFRm5IVVZFRGFEYlc0RGNrUTVi?=
 =?utf-8?B?ZjRtQ3pKbFhSNlRhRjkveEFESzhmUnkvSUE0TWxWM1RUdGlmN1lPZExJSUtI?=
 =?utf-8?B?Tk1OVU1JWVg1UzB4MlZSYXRnU2FmYzdmUEY5RjFIayttd09YNUNtT3ZkY0RN?=
 =?utf-8?B?VVNadjJ5RGFGNkhVNGpRakZHQlJ2dkdKV3FMZWtCT2hyb2hCUmtBenRwT3F4?=
 =?utf-8?B?Nm9MeEM1UG0vUmhkWFp2V2MxWUUzeWFaRjRhbTJOeU9IOEtVSFczVlJ3b0Zz?=
 =?utf-8?B?Z25oWGdZU0haSk1RelAzUElRVEcwNzUwNmhZT0JGZm9HZUgxYVRoTEhMVGg0?=
 =?utf-8?B?N3F2ZEtETFpsemo5L2JQTXNjYUZiMW42VitBUm9qZ3VnRTBvSWhWVG5UUW15?=
 =?utf-8?B?cDZvOCtiaGwrc3RYbVdIR2pnajZxazE3ZkRYbUdxL054aUducldaWTE2aldP?=
 =?utf-8?B?MlVJMWdkb2tkekh1RHhBUmpQRWtYdmMxbnMwVDY4SEZIQ3kvRGJXRVFaemRL?=
 =?utf-8?B?VnpLSGUzV3k1U09ENXRKaGxmTXIwZGllQmRCQytXMWRuTFBtQ3Q0Y24xa3p4?=
 =?utf-8?B?aUhOdWxUZmNmTzZGTFE5dTNPSnV0UUlWY0JPZFM1V0tUdlRXMGpqR2RlYVZ1?=
 =?utf-8?B?ZkNPNlNINnpVcW4wWDRtV1RMbTFuUnBNWGJJaTk4UjNqazE5WVp0eVFvRU1G?=
 =?utf-8?B?SnFvL0dxc3RFQWVKN29IWFIzUkc0bHVUVEtyUm91VlVRK2lyU3lzSWxWMzR5?=
 =?utf-8?B?V0c4Y1NzU0pXY2JLbUY0TnpTSUxlRGI5enEyQjV0bDlZSUY1UkpRTTZ1ZU1I?=
 =?utf-8?B?cXZDU1NVZWVOd3FXaHIyTnlscHhNOUxSb2VUYVNYeVBjb3gzbkpaQXAzMmFQ?=
 =?utf-8?B?YkdGRE5aMWNuM0NmZzFvNzBLbFloZkpQYllTazJ2L0tOSmo4MWhXYm5abTlE?=
 =?utf-8?B?YndSTkV4WGkzWWpLRDI4V3NhVEpycGkybFlmdEJJaFlDOEpMNENTZy9PVDd2?=
 =?utf-8?B?TExhU3g3M1FDdFJpcW9TMWpWSFo0Wk03WUZlYVUxY0dEUXpybUtCbjRlWGxF?=
 =?utf-8?B?bWFCRDc1UWlNY0dEUTJaU1oyUmxJcmxzZHlJMGJvdEtFMGpielVMVmFxSjZ6?=
 =?utf-8?B?TlA2bnIrMURUSDRBZ3gvVWNwdHR2RGltVUxLNTczaWJMbFV1V1FFZDFzVHdS?=
 =?utf-8?B?NkhweG0vbzY0RnloZmxnbG1qQ1VGQ0ZmWmo5ZkhPUTcwbW4vb3hTdXlJb3lW?=
 =?utf-8?B?R0FMblVlWW96M1VnVDNldzhUWUExOGRmUDJpcDV2RVpORDc2am9UUEcvdHdp?=
 =?utf-8?B?eXR3ZVZ4Qng4bCtOUjdnR3VyVERWRW1SYklQVE8rUkVZdlhEMllzS04yRWxC?=
 =?utf-8?B?N0ZBVnViV2YvbEEramdqSjVTeVdkbkpjQXNpYzNVNnJjZTNqcElRMUhkdUJY?=
 =?utf-8?B?OFlNMmxzRXhTVDdQbzJnc2MxSjRuWGw5RUhWVXRhaE5Fc1VQWW9aQnB5Tjdh?=
 =?utf-8?B?Z3hXZ0Erd2lrRDVVOUt1alZmLzkreWJOSkpLQXRTOFQreWlzMDJzZnVzMEpz?=
 =?utf-8?B?Zk5OTk0zYzBlaEI2S1VtM1k0bHZGdkMyQnlMUDhNUE95NG5NUlpTMFRyK0x0?=
 =?utf-8?B?eVM2WGZ4ZlpYZjBoNW5YSGM2K0hvbDV0WjZjL2xocGp5WXl0anBMZEEvN2xO?=
 =?utf-8?B?OFY3b0ltT2J4aTJYczJXK2k2c0FJbURJeTlZT1VhckFCblNrS2tOMVJncXpB?=
 =?utf-8?B?bVVLY2FwaUU4aWViRmkwVEtCZDEvckM2M3VTQzhQVlIydmpoL1RQTGM5T2Ex?=
 =?utf-8?B?SEExdStIUGlmL0xDQklST1kyVWV4NCt0emYvVG9JTnNiMVRjS0VqckhING1U?=
 =?utf-8?B?T2IwWHlGK0pHNksxVm1SbG5WcmNiby9VQ0xHR0lBSW1LUlpRcTFlTFhVTlJk?=
 =?utf-8?B?NURyQmVxTFNVcFFGTHZWaHRJSmtVTk1pQlJJcFp0YzhUZG9IOEliR1dFRklt?=
 =?utf-8?B?bmJTVFlQSFpPOWcwdVkvNXJxOFJRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9FCFCB06023954B95CBC2C583FCA1DA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D27d4Etd+Tsz+8tQxYKQw9LGwwNDMrW35AJvHn2Lf5ArcSgatTrvxueQq7ex9LIlhH1PuNK4obG2K7sxsAkGe8hpvqUDzf2hJQWoXPOCDqaoQxbXbVwEnuqzRgU+kE5tkmyOP0tXiI3vUhmM9WBoCFm3n3DGhh67WqaE32sCJ5cXbic+gFD6k6dOe4UK7JvzcbyqEl6zCUL4Lb76c7nGcAfPeMv2vKM38QEduW6MgFdaDCyLR8aKRWETreTlQ02tjNnSNPOg+agcVnhXlYthmhBwKTPBfQFfFoSibqfygUhNWnyEhnrhT4p6cgZtkW+okZYLUOmb9TL2wSorKoiUdtaYVlWe5+TCRPiPWX7NTIowvLJraCsNBPiL5c04QkjgQp3sfk//T3E9M2BEkjHepToWjZboC4kMvbIqkBq4jD2JP7Vx+J2RR6XgxP/6caqycRbOvop+cvnwKoXtC3Ar6+jYCexryens3E8GmCp9nLzipJ587Sm6pHaArBFCWB2jICPafuyBTuftKxMYXC4gC7jUtN95zJafD4eASm38yoExSZRcZ+V/+r4JglBpE5F9LtaVPCyMHos3zlULriXFSFmlUwmoOadUSPCx7b4leb+aTR7HiuZznH23Df/q5jEE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad345a1-a323-4f37-8a19-08dc58a695cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:06:08.0258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzcivJv3SAIK0afUuWTlXJ0yFoAxglUzZAncghFKF0S8sq7bvO19qjysSQaO+wSw+iRohpKckaR5TNt3m8OieD586OhExBfrAWjo/6woxg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6760

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
