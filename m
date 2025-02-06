Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258A1194A6B;
	Thu,  6 Feb 2025 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738866322; cv=fail; b=fPtUtn22iyQRUIUO5EqbOdKRW1oih1jY+4aAkvuqcggYw8Q1CNd31ULYbilgFTIM5oPnKUrGZb5WM99ONzZKTHCW40SH2DefX4P3E8wnDtrTxWiphyosRYU7/0ydp3gyc2uYiXn1m7Xj2BS0VJaVkI4pvvRmyX1M5E6EO0OvUxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738866322; c=relaxed/simple;
	bh=knfPpitAgcQw1wSUjm46ZEUfZD9B8p3RlvYcwxNED10=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cDBdDViCNqspgCo1XBba34/qboaBzbj+vRUzcHEpgtUCCL4HzTtsl8prewgdMT590VX9Fl0ssJRzivsI7oiUiPAWk3GNQMLXVUHXgS8eWxdoMK6w5DNDeN12Y+vTmlUiWLOvybTZT5NFOV0yfgjXNl7s9cM913wKBvJIG2kKD0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DI3cqEcS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qEUC0nH8; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DI3cqEcS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qEUC0nH8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738866320; x=1770402320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=knfPpitAgcQw1wSUjm46ZEUfZD9B8p3RlvYcwxNED10=;
  b=DI3cqEcSceOyqiostbpKinfaZcsBsOV4xVZXrXwQ1YNKE5fcuxTKMCoW
   4gUlahltz1YkvqUaUYRbLxOoFi7CFvOsKTQD8r3EI4gR2RX0fJeE2j5Ym
   bZtII7zkqOBnA+TqFLpFqKIxz5wgVjgVqYsr0vr52sT7DUNNCf0cTe+wp
   wwoK3J5MB/4VROKhFjG9UXc8caG9wK2Vv9ObttnlFFJHCqbNMFup+RgnX
   p+5tuuFNhIDvreCACKy7mrpjEX9lD8ONQYN0mNLT+iECHV5Zt9tOZnZ7d
   Trv70FPVHMWkaWeqXvYFArjjhqcXzeUT0R+9BmgMwx4eXaGCRA6PFYVXh
   A==;
X-CSE-ConnectionGUID: /J+msBFhSaeh6RTLrJDhAw==
X-CSE-MsgGUID: n7Ks6cr0S+KZsCnmMyv0gA==
X-IronPort-AV: E=Sophos;i="6.13,264,1732550400"; 
   d="scan'208";a="37200556"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2025 02:25:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kaSLZ1NeqZ5YZLbF0KPs1ETSesk2lzoi+8H/MG66XMWU/qfCde2w1X6+2HE6YOPsudVkGe+sjdfnm3TjR020xnTBN6U/QSwrJ3Wrth3uX3Ry05fPTYZi0LEOeeQ7A/vglZAfs+RSkVqlKR1an3puUSn7UFN0U0nyo8tAUVkXelIcIgINjAQpS7S53mv+FP5csIsF+jTsspXfEoI58gahbglhLbtQHHtLTcfCDnuYA3WbJn7ZuptF+KY/NQOYocwz450QCe8GrmBcBZMyehTN6sFQPO2hHx3BUv+zQ4hkCfKM7A2eshdY5U3qgKpZllmjlJ1BImdOlMTw1W4GieRsbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knfPpitAgcQw1wSUjm46ZEUfZD9B8p3RlvYcwxNED10=;
 b=V1Ol7iiVIjUN9Ti4zhYbKk7S6HUUpYchcMkf64YPT4A7rQ7+uMiUkLPF3MFAgcw5ijaTGckQ7lOok2ZfBfhb5JXhBsLaZQ1I8EuKqJ1opYC1AnYZ72zlTbyd3Q20VSffgo5Jw5uTvHwxYOWK5WXiteh7DJIaTKADmXEL4ER7g8efHJtpez90gwGafuGUJ/6VcUc3pniMN2H3EWJ5FkVLLDHkVfB0NCOM1zs2pc84bOz2p4gvuVYJrd38vAJbCLR6J2DCZkSwJ8K+qHZohwsGHdJP30Kj19vGBlN9GMlfR2hPPDBvlhCNBJtJhJoyykfrJSnKWmjwA8yLHwFI0AWqgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knfPpitAgcQw1wSUjm46ZEUfZD9B8p3RlvYcwxNED10=;
 b=qEUC0nH84xyIciWSgjdnK+H1T1jwHjibkDXmnPe79GE2CFenRpvauxHsgIXHUI7vX1OSw0H+dMyyXh4PWOUn4UWNikNz4eo25Kpul5gXsNb9AWTMwh4PRrLh0QKEuHluiOtBabsIRLesTwS4d01MexBaae0vkDukFbwKn8v+r1Q=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA6PR04MB9240.namprd04.prod.outlook.com (2603:10b6:806:41b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Thu, 6 Feb
 2025 18:25:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.8422.011; Thu, 6 Feb 2025
 18:25:10 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: critical health condition
Thread-Topic: [PATCH v2] scsi: ufs: critical health condition
Thread-Index:
 AQHbdxHmvf69B4w9AEaXxutfZEUuCLM5AagAgAASWaCAAORSAIAAeE6AgAAcwwCAAAjGgIAABF9w
Date: Thu, 6 Feb 2025 18:25:10 +0000
Message-ID:
 <DM6PR04MB6575471948A3F86CA56DF31BFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250204143124.1252912-1-avri.altman@wdc.com>
 <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
 <DM6PR04MB6575FACB152A64BDA4B4F5E8FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB65757320A1761FE473BFC5CCFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b962df63-42c4-4bc9-9815-9871be1ce2d5@acm.org>
 <DM6PR04MB657573C4DE11B13E58B1B5ADFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b3f8a233-7172-41d8-a39b-49e6014a2aff@acm.org>
In-Reply-To: <b3f8a233-7172-41d8-a39b-49e6014a2aff@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA6PR04MB9240:EE_
x-ms-office365-filtering-correlation-id: 83661c21-facf-4573-0e92-08dd46db9758
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YlZERUh3T1BvY1dUazF5MytFR081TTlrQTlTY29Ma0FrbW9LRmluK09Gb1Y3?=
 =?utf-8?B?di9NUHNIZEhOaitDVlliMWZCVkNldUs5TXhYQjh3UTFpOWRMU3duZ0JvMGRa?=
 =?utf-8?B?aUZoVGd1cWd5K200b3ZPTUpvZVEvZG5ydXhidW84czdTc1o1WDhZTDZVRTcw?=
 =?utf-8?B?S1dNYVp2M0V0R2ltaEpoNUZWTjA2NUwzQVd5QUZkSW14a2pLQ013cGtJQUdM?=
 =?utf-8?B?UnlZdTJJeS92MXdiYWsvc1NxWTVQU3FKQzNjRzVoMjhLNVcxRkpGekp0UzE5?=
 =?utf-8?B?bjJUTHFiMjhlNnlzNkV4c1JIUlZucDhuaEdNcnBCNmloODBPQkg3MnhWMWow?=
 =?utf-8?B?WHVHYTFnWmtwMkd1WnBHZDE4S2N1V1crNGNTUFh3ejlmcTZoSjBCdHlNc0ds?=
 =?utf-8?B?eVB5dnBmdkpVc2Z5YnpoajVVeDZqQUhNbzNwRVhuUjZ5VVdVSzBidUl6eVpn?=
 =?utf-8?B?c0tXMGJTcDJMZ3hPdWNGQm5Ec0t5anlyYmIyUlFFdHMrNWVrMmtibDdUZmxH?=
 =?utf-8?B?VnBxNHlVSlBKaVgyQ1ZkY0hBMTJsVjFKbi9ZMVdNU2JsdFJvY3lpaU9ScXAz?=
 =?utf-8?B?RTJiUVVNSk9iY3Q4aDFmWFVwdlVsSkkzNGV1RTdJaUtQK3lGTDFkaW04R04y?=
 =?utf-8?B?N1d4LzAxSmI3YjVBRVlrMUZKZkdnVjc1ZlJ1US9HajI3Q2tJUW1Qc2JsVjNL?=
 =?utf-8?B?UTJObDRiMWYyMzE5ekc4ZU8zN3hzZVpSd0lrSUUyN2FMcE1pSlE2SUlEL0RM?=
 =?utf-8?B?TEtCWVU1M1AzSERVM01FT25Sc0pEcnVoemdaeFpNOEZ1ODQ3YjlHU0IzQTlz?=
 =?utf-8?B?M3Y1UDBGM1J5VTZCaVFBOFpYZnIxRkhVRXArREJTVEQzSnBMMlA2bjFwVHdi?=
 =?utf-8?B?T3dhQWp2UTJnaGk4eVMxY20xUVJrL0J0ZVU1ajl5Zk9tVEw0L29sOHA4RzlC?=
 =?utf-8?B?RmZFeitXcElMQ0FSbDQ3UVArYXVZaDJLSGw4bXZlNFQ5SnE5WDdvamFEMkU2?=
 =?utf-8?B?VHR1SkJyV2NkSDE0cXlHZVlPalFyZlhoUlh4NkdmT2lhWjVjL1hHUTFrL3pR?=
 =?utf-8?B?ZkxWV3pJak5ranBHaExZdUVjRW1JY0kxazhva005YmtFcC9hNEhTL1BlRDl2?=
 =?utf-8?B?RW9kY0hveEJzNHh4a1Y1eVR6aitmZnBaY1JkMnVrWldVZi96cHFvRXZLeFJi?=
 =?utf-8?B?TmlSc0Y0VmR3cm9NVFJtbWpsRzJaRHlxMWc0UWRtcHh3ZysyWFB5ZWoydzFX?=
 =?utf-8?B?S3VLY0h0SlRvc2hhZ3B3Ym9NWXhrNnlRRndwci9JUmxqMFRxaGJnK1RXNUM5?=
 =?utf-8?B?VjVJSGF2QTFmdTNiSmUyYmJFTlpTSmRXMFZySVZWNWo1UHhQemVCL1lXdk5Y?=
 =?utf-8?B?djA4VTl4RkN5ZmZiN2hIc2NwcDYwblBZMFpDL1RJRkZyNjN3ZE5nS3hlQ3RI?=
 =?utf-8?B?anRIWlh1RnR4RGRrNGF3SFE5VnNXejA1YWQ1aXBWY09NREJyTkFiSlFBcXZx?=
 =?utf-8?B?Qkk1OEVrWlhCU0o0WGpYQmIwclJEZXVzK3lHS3ZzQ3doR0M4cGsvZjV1VDcr?=
 =?utf-8?B?Q28xY1ZIMkIyaHc0VWFJVmZWb0huU3h5MmI5ZWFBc0tFWVBkbTY3dGRQS0cr?=
 =?utf-8?B?QlpvN0lVdndpTmE4a05hYjBuTU1GWi8rVi9Jb0kzZ1VsajVybEZYdUdzeEJv?=
 =?utf-8?B?SFZvTG1nR0NTaVYvYlFScmtsRmdaekgwcGlnOUtDT3JiemxkS1cyeW1qdGpZ?=
 =?utf-8?B?OEFqREgvUHFtTEw2bUk2aVFXUlZYa0NrZkE2K0lheXNTTzRlS05VcXA4SmU2?=
 =?utf-8?B?OUsrcldTeUIwMlJWS05acGtpRXZJMm00aDdsUlJVWlNSZlNac3FkVE1TbXFl?=
 =?utf-8?B?dWlrWjRaY2JoYlFraUU1bEd3VHpqN0grZTN6MG9PZHRuS2REb1UzNloySUdv?=
 =?utf-8?Q?7uy5G1rnM1fl4G2SVuYHFAs0sx/ggd11?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZG5veHZaQUhiRlJNdnBnZlRxMmI3Q1VTMVdJd0tybG5ORkFkcS95Q3pBSG9z?=
 =?utf-8?B?YUQyeVF1QzZ0ZENGM2ZFa2NUQmNsMTRvY0NPR2hiZkxiY25iaXRTemhLbmJz?=
 =?utf-8?B?N1VSYzFSS3BQQWxOSG5ia2JabThwNCtaa3piazR2aU1KcnVDQXlwdmYxV2Q5?=
 =?utf-8?B?MmZ4L2hLTU9TS25RR2pwYXZmdnZPZHZIZ2QraTBjZitxOWJWeHBoMWRRUk5o?=
 =?utf-8?B?c1hTVDNMdmNoWTd1ZWxPVGNPVEJXdkJkUjNVN3VOV2dxaWZuMllUaDNmS25z?=
 =?utf-8?B?RkY5eVViRm9YeEs1T21hU2hLaU1tSVp6djlpNFNkRUE4Vk84anFvTk5OOGc1?=
 =?utf-8?B?UitTMHhvemNQQWd4eWxhVHF0ajUvWlBYcm9XV0ozcklLcnFCWnRjTjdlNWts?=
 =?utf-8?B?V3U0Y3I2MkZ4RnNZYXBXOGFCeGZwaXBCdDA0Tm5Uc3ZWU3A0Tnk4akxYVmdV?=
 =?utf-8?B?WTl6eHhmY0R4SVV0R3BnOUVFdi8zR1hHc08xM2pHNDNsYUd3NUVMNTZaR0dm?=
 =?utf-8?B?VlA5Ulk0dTNxVlJzN2dlQmJSZVpKZ1B4Y2Jrc0Vqdlg2dzYyM0huQUhWWTdr?=
 =?utf-8?B?bkNjSUFZRWpWWWZYRTZoaU0yQUNTNllrU3pjUlNtTFlvL3BSejBMNVNRdkE1?=
 =?utf-8?B?ajJVM09uemo3cjlrQUplUXpDd21ENGFDNTFldEJ4OVpuQnFjbWhidlJBN1ov?=
 =?utf-8?B?MlZKZGJxcHJlQWdtRU9KanRwSnNLdWUxa2tLOEozMDNhQnNEOU9FMFhKUEZs?=
 =?utf-8?B?U1FuSWxWNUcvR3FZZUxPVVJkYTV2UStwQ2xnL3ZNVzVqKzZYZEVycXdua09W?=
 =?utf-8?B?L1VqVmdtYmRTY0VZNG5mcVJlTVppNk9uRlBaR0g3SFdHcWh1cFJaV25sWVpM?=
 =?utf-8?B?ZkxnallnT09Gc3FONGhxQ0Y2Q0NHRytnSnFSSlV2MlZKbWVTWXBPbjJRV0ZN?=
 =?utf-8?B?dkxFQm5ISkxsT2xVaUQzUFJHT1ZDZlhCQTBZdDhRV084bkhERG1INGFjNHAr?=
 =?utf-8?B?dWtvdDVGZmJIZ0FuTzBkYmNybkRwaDExeWxPUHFwbm80YXJRakZCb2M4NnFJ?=
 =?utf-8?B?WGhBMEx1SmFjVElMdWlCK083Qi84VjR3cU9jZXlnQmZtbGliK21abm1lcUlZ?=
 =?utf-8?B?aWpWYmhiSGNnS1RrNzNLbjhNbWJ5dkJkWTBic2gyWnN5QU45SnczNDB6UmJI?=
 =?utf-8?B?N0cyNXkzQmZ4RTN4VjNYaTlRVFFGaFRGOGNoV0VyUzYyZTJEZFpaVFVTam42?=
 =?utf-8?B?aHk3dVFoZkwvL1RzWkdGdFA2bDl1aFBtZ05yQ2Vzd1YwUkd3cnZJRzNuWnhF?=
 =?utf-8?B?a0lESzMrM0hFRHhxRy9OcGpVeWNQNndzeERBZ2prWVpFLzBuM1cvL0NSTzU4?=
 =?utf-8?B?RWpvT2pNWUp2MW8zeDl6SzFFNFVpRlhIRExVNStNbE1URFFMaTV3SW1iR2Ns?=
 =?utf-8?B?Y1VNa1FzckZxNG9aeVhiaGRDRzRwcW9lQVJZZWdTQno4bEpGM1pqanl1UElQ?=
 =?utf-8?B?N2NwYkFzUDhEcWFZZkI2M3VoOE1lSnZMQVVBa1V6Z0s1MVFEVVNjWllRQi9j?=
 =?utf-8?B?SGlFTnZQaHNwc0ZqWmFJeTMrNHFqN2w1bVBEazZhMFRiZUNFY25HZGN3Wmx3?=
 =?utf-8?B?WHNYaXlRRXZVOFUvMEVNR3NIOHF3Y2dPZDhHZVNEV0FRRmRQTEI4Q3hQQ3pD?=
 =?utf-8?B?L0grMFVCeTF0bUZUS01rL0k5S3pWdnozbHRHN0IwOFlVZ1RUV2VPbWFXL3FF?=
 =?utf-8?B?YTZjbVk4R01BSmJha1o4S1MxWVRYdkk2U05qcGVuMVFVZzZ2MGE4WGFVS1NL?=
 =?utf-8?B?QlRiK2hsbVJmcERZUEhha0RZV1ZIVTVNQzRtRlRJa3NKNUFVWWVUZHRUN1ow?=
 =?utf-8?B?RzBJRytnMUJmSjkrdVhtUFAvMlFwbno0ZlJNSTZVSW5hNUtlb2hyZ3lWODFW?=
 =?utf-8?B?eUlETTFxRFdVNTdTdkFqK0FaQUZIc29TVjdpaWxGdnVXTGhPekc2ZFlhTmdD?=
 =?utf-8?B?QmFSbjJJckN3dU1wNzk3cUNPOWwvQ3JlZ3Q3MjE3ZDB4ZE5FZk44R1oxOUR6?=
 =?utf-8?B?K1IyVy9SaFZsOWYzSWtQWEFKQnphN2VhckxCR3Y1Wis2aXdXYnJYQWxLa2hk?=
 =?utf-8?B?NXFndmhlaVNNRWFJWFpkQXBUSkFISFAwdndJc3hkbkNoQ2pyK1VLakZiVjRs?=
 =?utf-8?Q?aCtDxVnbzma8APlBj5Fs0AYuGyh9l3dpZQ+/DSL5SSzV?=
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
	+9rEv0Czp7dOzFnOJw7Uz4VCM/i/p4Adwvte0LsEM7EtaMI0n0rrhD+zq1rVgQjgYyLlF3dle/Bu9ZQF/ndKE1k4wqryqVsg06WwBtOKhCIedtRzU5syxnSVzALGhw3FJDWulbLAqUww9Du/46feRNMnluSe0Dj64W8tcIFnSXuMriMOGOTcr+JIUmfSEKBMCTmXYjzseMiGnDH1u1OTbJhnVskFBBYbifRrw+hfdHiNhxw7W1WEVxF2ULvTY0VUVsBmdcM168bhDbE6aTsxW02h0oYzM9E1eGChfnXCQ+6du2oUaUPg7bbIO08a4LK8HSyjjGlzgeYZXQbZWDeMgO6cij0CGxOHCqFk3JL8GgXiepibz9XoigOVyfp+lDdhR7DunMlvWDRkVrtvZbYfwPgIH1vBZfi05DboQNVbIlpGqHD5XVo/hc8yaby0a6yC+yVHDV+n+LtKMW9z1u2ju2vaA+KnpiE3AAoqFCopQlMuurp+hQUnElkZ/wofS8/xUSWVOvS6YJGt9NBM2giUWbOblTltV3Q28kJDT6OSRXmowFWvdLOuSBMZL+mvYCkMqUy7OpPwFdaTwvMDrP/mj1qGW+jI3Lb3U6a0lw8gifvlI7OSmEGXzkMyObFiNo0e
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83661c21-facf-4573-0e92-08dd46db9758
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2025 18:25:10.7086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: biTmWC8yUsxxK+Onu7B9KjFWp70NwqMJrFydgwDurfovs9DJ9nZG4ZSeaDj/ynMU0cqG+gHqhpknbpuK13qXDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9240

PiBPbiAyLzYvMjUgOTo0NyBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+IE9uIDIvNi8yNSAx
Mjo1NCBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+PiBBZnRlciBzb21lIGZ1cnRoZXIgaW50
ZXJuYWwgZGlzY3Vzc2lvbnM6IFRoZSBzZXQgY29uZGl0aW9ucyBhcmUNCj4gPj4+IHZlbmRvciBz
cGVjaWZpYzsgVGhlIGRldmljZSBtYXkgc2V0IGl0IGFzIG1hbnkgdGltZXMgaXQgd2FudHMNCj4g
Pj4+IGRlcGVuZGluZyBvbiBpdHMgY3JpdGljYWxpdHkuIFRoZSBzcGVjIGRvZXMgbm90IGRlZmlu
ZSB0aGF0IG5vciB3aGF0DQo+ID4+PiB0aGUgaG9zdCBzaG91bGQgZG8uIFNvIHRoZXJlIGlzIHRo
aXMgY29uY2VybiB0aGF0IHNvbWUgdmVuZG9ycyB3aWxsDQo+ID4+PiByZXBvcnQgbXVsdGlwbGUg
dGltZXMsIHdoaWxlIG90aGVyIHdvbnQuIEhlbmNlLCByZWFkaW5nDQo+ID4+PiBjcml0aWNhbF9o
ZWFsdGggPSAxIG1pZ2h0IGJlIG1pc2xlYWRpbmcuIFdoYXQgZG8geW91IHRoaW5rPw0KPiAgPg0K
PiA+IFN0aWxsIG5vdCBzdXJlIGlmIHlvdSB3YW50IHRoaXMgdG8gYmUgYSBjb3VudGVyPw0KPiAN
Cj4gU2luY2UgdGhlIGV2ZW50IGNhbiBiZSByZXBvcnRlZCBtdWx0aXBsZSB0aW1lcywgYSBjb3Vu
dGVyIHNvdW5kcyBiZXR0ZXIgdG8gbWUNCj4gdGhhbiBhIGJvb2xlYW4uDQpEb25lLg0KDQo+ID4+
IEhvdyBhYm91dCBlbWl0dGluZyBhIHVldmVudCBpZiBhIGNyaXRpY2FsIGhlYWx0aCBjb25kaXRp
b24gaGFzIGJlZW4NCj4gPj4gcmVwb3J0ZWQgYnkgYSBVRlMgZGV2aWNlPyBTZWUgYWxzbyBzZGV2
X2V2dF9zZW5kKCkuDQo+ID4gVGhhbmtzIGZvciBwb2ludGluZyB0aGlzIG91dC4NCj4gPiBBIHVm
cyBldmVudCBpbiBlbnVtIHNjc2lfZGV2aWNlX2V2ZW50IHNlZW1zIG1pc3BsYWNlZCAtIGxvb2tz
IGxpa2UgaXQgd2FzDQo+IGludmVudGVkIGZvciB1bml0IGF0dGVudGlvbiBjb2Rlcy4NCj4gPiBI
b3cgYWJvdXQgY2FsbGluZyBrb2JqZWN0X3VldmVudCgpIG9yICBrb2JqZWN0X3VldmVudF9lbnYo
KSBkaXJlY3RseSBmcm9tIHRoZQ0KPiBkcml2ZXI/DQo+IA0KPiBQbGVhc2Ugbm90ZSB0aGF0IGVt
aXR0aW5nIGEgdWV2ZW50IGlzIG5vdCB0aGUgb25seSBwb3NzaWJsZSBhcHByb2FjaCBmb3IgaW5m
b3JtaW5nDQo+IHVzZXIgc3BhY2UgY29kZS4gRW1pdHRpbmcgYSB1ZXZlbnQgaXMgcmVjb21tZW5k
ZWQgaWYgdGhlIGNvZGUgdGhhdCBwcm9jZXNzZXMgYW4NCj4gZXZlbnQgY2FuIGJlIGltcGxlbWVu
dGVkIGFzIGEgc2hlbGwgc2NyaXB0LiBDb3VsZCBpdCBiZSBtb3JlIGxpa2VseSB0aGF0IGNyaXRp
Y2FsDQo+IGhlYWx0aCBldmVudHMgd2lsbCBiZSBwcm9jZXNzZWQgYnkgQyBvciBDKysgY29kZSBy
YXRoZXIgdGhhbiBhIHNoZWxsIHNjcmlwdD8gSWYgc28sDQo+IGhvdyBhYm91dCBtYWtpbmcgdGhl
IHN5c2ZzIGF0dHJpYnV0ZSB0aGF0IHJlcG9ydHMgdGhlIG51bWJlciBvZiBjcml0aWNhbCBoZWFs
dGgNCj4gZXZlbnRzIHBvbGxhYmxlPyBJbiBDIGFuZCBDKysgY29kZSwgcG9sbGluZyBhIHN5c2Zz
IGF0dHJpYnV0ZSByZXF1aXJlcyBsZXNzIGNvZGUNCj4gdGhhbiBsaXN0ZW5pbmcgZm9yIHVldmVu
dHMuDQpEb25lLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQu
DQoNCg==
