Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942EB26AF3;
	Wed, 29 May 2024 21:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717017350; cv=fail; b=EfiCpy7R4LsgFkmjnNVCMUmjLV07jcwDhakS+zJW37ZjsYZ23yDk5k7KzBEW5WCIIieu5c40ia0AIg8i2hCT5GWl5I0xXsq+zQqHicDk96b3UCufaklAXynwSDW/SrST4fySrETmhj+fUeLkToCmQvAsiv/v951j4uuAETz2WzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717017350; c=relaxed/simple;
	bh=TNb7fGWXERxWeFejxhsHaIyWUXvRV9i8cSo1xLGws9M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nYPBG8+QvoDTzomry8o3Z4CD3jcweZAhUK7NJx2d0NI+e2HBJw6E27vwxPyL0dVLZG/Mj1lcmNJD+EBnnDs4fslZiQQU2LfZGcpFDS27cehulVvhoekHTBx33ZcQtnZvWUK2g5bJtGxKTDD9jQJKw8Ya0TfPQW1ZOAYdGA9yCYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=o4IZQjao; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=CJ3p0DL0; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o4IZQjao";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CJ3p0DL0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717017348; x=1748553348;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TNb7fGWXERxWeFejxhsHaIyWUXvRV9i8cSo1xLGws9M=;
  b=o4IZQjaox3DyGxEDbwIy6LFO+yUqNSbCyo3W2w89bguwBlElAnZaiHkG
   JNJG4/Q0G5vVKYzUqL3MrCgZxnT7dDTlhwJkDui3Kfd33ob65aGnAukYf
   yqYhJAHlsGVTGZXekIL1PFWL5h2HEQm7hW/ef0RJ6JAjzr6/wVeRW7XlN
   4Sh3aE5v/lpe2EkSUUeL393fIUc5U1XT5rEbhJoNB6XStUUD9TZNq+Doe
   jWSh3h30hIXm675tmSt1arsYR7HbjxF3lGJiW4regHYHIa9dQmBR11bR9
   5nlm1ztGkXQbAkVEIsLbLZ3NqSluE3EBldcal4nWpBjeWDhI5zukaztJh
   A==;
X-CSE-ConnectionGUID: D28FVz88Ta6N+j0eY4skuA==
X-CSE-MsgGUID: gFsuuXBKQi+K1pm/ILrFWA==
X-IronPort-AV: E=Sophos;i="6.08,199,1712592000"; 
   d="scan'208";a="16923298"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2024 05:15:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECnBdBevLxjYryg1xr1ji0rk3gXG6RFVGTNVqp1a94UZmXbm6rpq6+rThEAFGPT9xGDyzUzhL1tTGLSPARuxn7my0VK2BvYwoM8cU78t89b5hs+I7sP5HZlfJrKsSKtJ9rcV4hALxwGKqlNCe+V8SGyqmczR7xoC3lVLYe6bmhUm1ymw5vAUhXDfF8bpeD6p7sjpLCktKmzXRsAIbxQQZDPdj+0/FK0djncO2m30PZncTY7gR7Mt++mQ+nmFCfcRz5bpf3YFCD9AOtUFJb8nY0F5YHMe77hMXe5mrSRqUPa/J2f+TiPatLucZey+S6sw2H2wwcDo7GUKIusIHXnb+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNb7fGWXERxWeFejxhsHaIyWUXvRV9i8cSo1xLGws9M=;
 b=aRDo/7j5pHZKHNBhGBMuVwC2vxOEAqazMDHLWst0ZXCutEAQEMrzprOF5AZci3lHtBCJdPMfr4fvYDYK9AS+ACERwnVZWV1hYlyu5j9ti6mXTG2nZ7gPabODMyz+q2I4N4pbWbBrcvCTD4SL8mbSSOtKiiXNxfCQbqG4KBRNNZCNN0nhExx/OQGhFjMnxJzj0+eMcR5eOu6nUWUj3z+kb7SssHdn/U7OZK2Pbrt+BT/ZLN6ekOPNaKTh3VLyTDzY9L012VPxE3nKva5KnmK3TbyBfrHsXZ6b3kmFjQLARekxMNWYLI0U6QSU5RTF/w3So9xeWmzZCflkn+HaptmpyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNb7fGWXERxWeFejxhsHaIyWUXvRV9i8cSo1xLGws9M=;
 b=CJ3p0DL00QTYcl9IzTmiBENHInKmq3fvCmhWTFEkVemRzsWPCka3n+VXPfQ6Uy76R+eifw26mB+EE4Js9k7CGE1IyrA2Cx1DHLWHB/baUdPjOvnVSeHdrICb0vhg85EoGefi+9zjXwen3EROayKIHdZ+pzanqOONgVxDcej7Vf4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN8PR04MB6417.namprd04.prod.outlook.com (2603:10b6:408:d9::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.17; Wed, 29 May 2024 21:15:45 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7633.018; Wed, 29 May 2024
 21:15:45 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 1/3] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v6 1/3] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHar0UYy1/vUEyaOESNvMrCYAcapbGup/4AgAATcKA=
Date: Wed, 29 May 2024 21:15:45 +0000
Message-ID:
 <DM6PR04MB65759C6532DC45C7F2ABE101FCF22@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240526081636.2064-1-avri.altman@wdc.com>
 <20240526081636.2064-2-avri.altman@wdc.com>
 <9c066dfb-b84b-49fc-94da-806b71e261d1@acm.org>
In-Reply-To: <9c066dfb-b84b-49fc-94da-806b71e261d1@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BN8PR04MB6417:EE_
x-ms-office365-filtering-correlation-id: 6b283a4b-6735-45e5-f082-08dc80248116
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?NVltTW5Wak1sRXVXbFhkTmU2R013RlVra0FSY0w5NlJPRkhDOGNTQ1JKQjQr?=
 =?utf-8?B?dTQvNmE4eUZ6em9vNysvczJZTllhS3dmeFcvUGJQNmpSTUhyamxjeHB0NmFj?=
 =?utf-8?B?STFuMWFXa0YwSFlwQ0tWNjdCdmVGa3lYL0lWa09Sd1NXd1E3LzJ1b1pQcXFv?=
 =?utf-8?B?aEVVVGZQeDhLamMzd0VrYjJqSHo0MzRpckUzWnI3bCsyUmYvaU9LNGRDNEVG?=
 =?utf-8?B?cWJZbzdmOXYzTDRoVXMwOHZaODNJdFQ0NFZydW4xSGMySHdTQVB3VUJhSHdH?=
 =?utf-8?B?S3BFT2U5UklQL1ZEa3RLbEplRzgrSXN6MWdzcDBMNWpGb2MxMkEwWmgyMytC?=
 =?utf-8?B?dWRPOGxJeVFYYzFlZ05hb2w1WkVLV2txSStYaXVwaFgvQU9PdmIzRmRHampZ?=
 =?utf-8?B?V3JZS2wxclJZSkdzTFFINjJ5UTM5TWRzS2U5NEhlYnBSaGNuZS9ZczcvY1R5?=
 =?utf-8?B?N3d0a2h3NGU0ZDh6bkNhVVB5cEZTeHFVZTJnR2ZpZWlUU2wrRjhEbWRaS0hs?=
 =?utf-8?B?eUs5RmNqL3gxcGlHbnZrSXJQbmxhbDBBaHpmaDhtUTNRdjNuMTJOZU5CRlA3?=
 =?utf-8?B?S0xVUXlTcTNoMEFCdHNZRitQalNLRXRidG5ZZGJ6TTI1cFNLVW82QWFiSFZa?=
 =?utf-8?B?ak02eE5oNm1qRVFaNDRvTDIrWnlLZDhHWHZoeDUyWnU4WnVPY0tiQ0lrWjVH?=
 =?utf-8?B?bXl3MG5STTh0OGc3aG1NdVNJeXFrYUxPNGdlS1JZYjRWSTQ4VTJidkowQmdR?=
 =?utf-8?B?QlNjVHVDaGtaYUQ0OTZZb21JcTRDSUhqZ0JmS2tORUlyWmlzUmgyVERhelhP?=
 =?utf-8?B?bE4xMU1XYXFQbnhvdmxBUlV4NXFhSVY0OG12ZHBiM1BvdUl2eU5ST2VoZm96?=
 =?utf-8?B?RGVzMTVGc0Rpd0dLSG0vWWtxc2FlRDgxTlU1WDd3QlJxUmtQYm1rMUR0UG44?=
 =?utf-8?B?RXR0RzdodEpqRWs0SE9PSjRLWEMvWjYxclArdWVwN0xyMmhPSDhENFhWeWM4?=
 =?utf-8?B?cHNPb01XMll5RXhXdmRPMHdpZXFObzUwN0VVV0RwQzFkWjZtLzN0VG4rVnNV?=
 =?utf-8?B?WEdzVzEwb1hCU1Y2REg3Wi85TXNkTnVHemdSUHk3OG52N3c0L3FYMjVrb1hu?=
 =?utf-8?B?R3BweTNWc0JFV28ybGdxUDB1OGdaNEdHcnYwOGNLaysvTXJNY1dlaWJpNGk1?=
 =?utf-8?B?dTFNcVJ6a044VVZMNStkMW1TTWNCZmFubmlxbWgvR0tvNEFOY0Q4OTlVSk56?=
 =?utf-8?B?SEphRHJrOEg0elBPYUpLa3pZYVhCbmhxZTVkVHU3ZFFZMEkvM2VBWG9EbTB1?=
 =?utf-8?B?Rk5pSEVDLzZSQ0U3YTJuWjBPSFk5UGhLeTBOUDVhWmxjblVUdTFJL1Z3eUJG?=
 =?utf-8?B?SHBjK2wvTE5JditlNFlRczl1UTFGTS94ZzBPcFpSaU05R1doN2I2eTBIZk5G?=
 =?utf-8?B?V3NramF6ejlzT2RsbnkrQjZHQVpPNUtqYW9BdDNYM1NiMGJDTW9reUNXSGp0?=
 =?utf-8?B?QlZrZ3ppbjhhTUZZbEl0Vy9LdzBiZG5ZWHRNZzl1dkNVVzFLd3RDWGR6TGNp?=
 =?utf-8?B?YVlCZ2dsOGhXdEROcS9QLzhUSWFsVlFiZnZLVklwZ1RnTWRDMU5tM3g2RTR5?=
 =?utf-8?B?cnI0Rlg1aDdqZ3ZuMEY0WlVvMHBldXYwVmtPdW5OemRpb0xDK2ZOSFJHZCt6?=
 =?utf-8?B?eFhDaGMzeEpRd3hCVnZmbnQrOU5nNXFKQnNIbldEMFhUZThURzJ5eUFoSExG?=
 =?utf-8?B?N0V2Y2c4eEtUYktnZGtzbWdFOEZYaDdxOEZST25lcDVLUG1USzdMbHNCMUEz?=
 =?utf-8?B?ZStDaWpnZS9XYXZiQysrUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aUFmNkVWTkhRMW1PZnRqSGJiNU9oRDZOTm9ENi8zZmhVblFuVVhEejZCRjdk?=
 =?utf-8?B?SzVtU0dlREZPaWNnd25xVmpvQlR5blM0UG9XcUJ1eFR0TTdYbHFBM20venBF?=
 =?utf-8?B?N2NGelNLTnd2d2dDWTdFZXQ2NmRzUjlQdmdNU2c0WS8vSzBXRytZYlVhVG00?=
 =?utf-8?B?cm16UTZiQkZsb1cwRWhxNXMrOWtPdU5iMFpodjQ1MWJCTGN6TE1VSENmYktX?=
 =?utf-8?B?RWY4VE5MbEx4UE0zOGo5R01ROUtPLzdxemRONDJRVElPVU5tOXlnU3Q4REdO?=
 =?utf-8?B?QlRQWEcxRzVmOTlRTDJlMnc4OXl2REtsdlpJTXVLMUo3S0pzT2lCS0pWdjZN?=
 =?utf-8?B?RERLSkxhUy9NNVNMUGphaEdNZWhLQWZTdWlDdThiOWZFemZzMng5VG1jWUQ5?=
 =?utf-8?B?VEt1eHF0K3VWT2QwajdyUDhSdm93ZXMyRm1PeXNzTTBsRzJYQ1pmZHl1eDRs?=
 =?utf-8?B?d0RhQXhCb0lpRE1JTWRYRDI1ZTJwMFFNT3ZyYmZVdEN4YXNETlNnSmdZSVRs?=
 =?utf-8?B?OU5iZld0NHljNXUxME9GOTZ5N1FzWVE4R0piUnRRenRSdmdXSmUwc0pmT0My?=
 =?utf-8?B?d2o4RW1HWXA2MVZOTHNtakIyaXpkL0hsdEUvTTdWaCtWY0lVZUtySldpaENB?=
 =?utf-8?B?cDE2UStYVm1PMy8zRUJ3ekowcHZxeE5EOVhpYXBhQkVheUw1bEpDeVFlQjh3?=
 =?utf-8?B?MmNsa0UrMDBTK3c3S0VLS052cTE1UURoNjZMY1VmVlo1b3hCcjE5RlYvR2tW?=
 =?utf-8?B?amFsd0tIUjM4WVVFQnMxR1RoeFdJUGlzRVpFaTNralZ5WjBGNWtFVXFKdjdz?=
 =?utf-8?B?eFBkWWZvOHlMMlZNOTZYVTR0cXRvSDlBc0NmY2NvMnNCUHNsdGwvR2ZzbEhP?=
 =?utf-8?B?WTFvaUhIR1EwTmpvNGwyeWtFSGlwbzdNWmVKOWh5YldRc202dmMrak8zWGQx?=
 =?utf-8?B?bnBhZVhNMmhGcER4L2RQc3lKcEZaQ1NnZlpNQnhGN3I5NHVyWG9VNjNxc2gy?=
 =?utf-8?B?a1k3QWtWV1RRQno4TitNeVptL3hWSmI0MTNTTFdrN0tQN0hZeG5aY1RpRXZT?=
 =?utf-8?B?T0ZFUWt2dlQ4Y3Jjb1liNzBNN2ZwWGJLVVBRbDlzREkySjBxc2VHWmNYd0pS?=
 =?utf-8?B?cVBWWHArbFQvVkF2VmE4ZnlSWXZZd2NJdUVPNjlabnduZWZpcmNRdjhEeTg4?=
 =?utf-8?B?d2gvSFdaOEIwem5EVG5ROTFwa2U3YVFyYWZFVFRXV0NNUFNJdHQrQ1k5KzhT?=
 =?utf-8?B?b3RQNnkrS0hpWUhCV1ljYmc1RDExelB0MTdyejlUMGgyd2dFcnF0MlU2azJt?=
 =?utf-8?B?RW9qbTcwejlhTUttRDgybG1LaC80d2tXQ1h1RGp6ZGtNeXdVcEF4UTNpRERD?=
 =?utf-8?B?MGUrNWFmNFRXWW5JRUk1cTVDOXFoMVM3RlpDRy9sRXdHRU1RR21Qb3NEUnJ4?=
 =?utf-8?B?TS85Zk82ZDl3eXliNCt4b0M3K25abmRSS1hyLzRiTW9SL3IrOGFmZWZoQnNx?=
 =?utf-8?B?aGFlVnQ0UE5HelZjTFM0NDM0VG1BNnRja0JqTEptbFZPWDFodWtON2MwcnE0?=
 =?utf-8?B?aTBOSllNTHoyclFQdHlXZlZKYjY5dnhWRm5JTHhDTDhFVW0vZzJBbnJxcFRR?=
 =?utf-8?B?TE4rQ282VFo0Ukl6YW0veWlPSURLaFUxSWIxOE44N25YMVdSZmwzUVNZVjhT?=
 =?utf-8?B?d2ZnRWNVNWF0S09waWY1aHlieXkxSkpPN0dwbGNORENqcENlNXFqVDFkN3l4?=
 =?utf-8?B?My9LRmdvT1RNMjVnMGMvR3k4aXJ4cFF4MW9QOHRhYU04MjFCU3plMkxYZW53?=
 =?utf-8?B?MGc3WFkxQk0yUzh6ZnhscGU3MXJvYUczalhMZU1HYlREVEtFT1M1UlNJc0FD?=
 =?utf-8?B?YXBMUmpuWHNxRnBYcmRwK0tBQVhvaXVza2FxdkR3Zmp3K2E2dm9pZ2djbVRF?=
 =?utf-8?B?cXFqU0tQZHREejZSY1FSdmk3Nm12eGVtTGN3eGMzdHc1Z0QrdUE0a2w3Q2Rx?=
 =?utf-8?B?QmY5eTZOTEo0bEIrTTdINU1acG8zQzNzZmx6S1JDelhSQmdUby9kMWJIeDJJ?=
 =?utf-8?B?dUxJeWpVbkxSV2NZVVo2TDVmTGN4VCtRekdmZFlnV0x2MGRmWlU5dEpMaGtv?=
 =?utf-8?B?VjBad3A0Qy84ZE5lVHRZUUpBMmFPbFBKQlZEMVp2elFNckNuQndSaXprdVVZ?=
 =?utf-8?Q?t6gHlSqjgO7+rcTKopX7zIVVzm1EoY0UTVve6GkVkEKb?=
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
	jh/lx3x7hqOZcFkQQBemFaAUiaSqddC3WoLyZ2D3lXQMNCrwdIhIzOuCPTJxQCmWqtc58SPvXM6qWGBEcbINqq9B9TvqR/fp9gzLJWvSJx4YbmksB6mJYgeWBWtM+qqHa7V1qL4fzFquDPBynj0UE2uTJTFrEx2rRQFZ+NkH1H3+WfHxgfapqRo78VeiK2Lh726rXCx/PnkxbiZWgmKtHkk4T6sXjhENLH45NZFMJymGCGwi4nc4vU9x0wzXATFlAifEOyW2YXB03+O0rQ5f+2mjKZsoHVe5a/sqzebMRLF2kbO4fXrNhE1wtU9SwaFz506J37GzcY6x/IO5T1CCBqZhNiO9JKfx56YetgoPdKrJCD00IS6QpDNFMHUB460m134Kjte0CSCPtSORCFWRhPQgoCZF38fe8VTV6RHxKaNKyasI9r5FSoHOUT7LOe3LICVVLRfvWWpjR2hRu6IEd9ft5puFRJ7tZlwsIj/fYzIA1t1oAEfKcTYQcHJiwHUM8tnMZpq3e+PMbrK+oq5+L5qWAZEVTxPUtuSndXplGxWuNe2ZHkZifkZkosmWmKkbUw/FIlXniSUsxCXueIPutvYf+WrksmP4cf8abqsl5fj2g+TkqE27p4hdOFjMma+x
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b283a4b-6735-45e5-f082-08dc80248116
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 21:15:45.2170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N7ugvJaMSQO4TMl+Gv4Cb0cKuYfnA0gMoFlmVz2TLCUOks2/ROpjTpj66x+SWCguZbi7LIplfcTkySTMOU+DNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6417

PiBPbiA1LzI2LzI0IDAxOjE2LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBUaGUgcnR0LXVwaXUg
cGFja2V0cyBwcmVjZWRlIGFueSBkYXRhLW91dCB1cGl1IHBhY2tldHMsIHRodXMNCj4gPiBzeW5j
aHJvbml6aW5nIHRoZSBkYXRhIGlucHV0IHRvIHRoZSBkZXZpY2U6IHRoaXMgbW9zdGx5IGFwcGxp
ZXMgdG8NCj4gPiB3cml0ZSBvcGVyYXRpb25zLCBidXQgdGhlcmUgYXJlIG90aGVyIG9wZXJhdGlv
bnMgdGhhdCByZXF1aXJlcyBydHQgYXMgd2VsbC4NCj4gPg0KPiA+IFRoZXJlIGFyZSBzZXZlcmFs
IHJ1bGVzIGJpbmRpbmcgdGhpcyBydHQgLSBkYXRhLW91dCBkaWFsb2csDQo+ID4gc3BlY2lmaWNh
bGx5IFRoZXJlIGNhbiBiZSBhdCBtb3N0IG91dHN0YW5kaW5nIGJNYXhOdW1PZlJUVCBzdWNoDQo+
ID4gcGFja2V0cy4gIFRoaXMgbWlnaHQgaGF2ZSBhbiBlZmZlY3Qgb24gd3JpdGUgcGVyZm9ybWFu
Y2UgKHNlcXVlbnRpYWwNCj4gPiB3cml0ZSBpbiBwYXJ0aWN1bGFyKSwgYXMgZWFjaCBkYXRhLW91
dCB1cGl1IG11c3Qgd2FpdCBmb3IgaXRzIHJ0dCBzaWJsaW5nLg0KPiA+DQo+ID4gVUZTSENJIGV4
cGVjdHMgYk1heE51bU9mUlRUIHRvIGJlIG1pbihiRGV2aWNlUlRUQ2FwLCBOT1JUVCkuDQo+IEhv
d2V2ZXIsDQo+ID4gYXMgb2YgdG9kYXksIHRoZXJlIGRvZXMgbm90IGFwcGVhcnMgdG8gYmUgbm8t
b25lIHdobyBzZXRzIGl0OiBub3QgdGhlDQo+ID4gaG9zdCBjb250cm9sbGVyIG5vciB0aGUgZHJp
dmVyLiAgSXQgd2Fzbid0IGFuIGlzc3VlIHVwIHRvIG5vdzoNCj4gPiBiTWF4TnVtT2ZSVFQgaXMg
c2V0IHRvIDIgYWZ0ZXIgbWFudWZhY3R1cmluZywgYW5kIHdhc24ndCBsaW1pdGluZyB0aGUNCj4g
PiB3cml0ZSBwZXJmb3JtYW5jZS4NCj4gPg0KPiA+IFVGUzQuMCwgYW5kIHNwZWNpZmljYWxseSBn
ZWFyIDUgY2hhbmdlcyB0aGlzLCBhbmQgcmVxdWlyZXMgdGhlIGRldmljZQ0KPiA+IHRvIGJlIG1v
cmUgYXR0ZW50aXZlLiAgVGhpcyBkb2Vzbid0IGNvbWUgZnJlZSAtIHRoZSBkZXZpY2UgaGFzIHRv
DQo+ID4gYWxsb2NhdGUgbW9yZSByZXNvdXJjZXMgdG8gdGhhdCBlbmQsIGJ1dCB0aGUgc2VxdWVu
dGlhbCB3cml0ZQ0KPiA+IHBlcmZvcm1hbmNlIGltcHJvdmVtZW50IGlzIHNpZ25pZmljYW50LiBF
YXJseSBtZWFzdXJlbWVudHMgc2hvd3MgMjUlDQo+ID4gZ2FpbiB3aGVuIG1vdmluZyBmcm9tIHJ0
dCAyIHRvIDkuIFRoZXJlZm9yZSwgc2V0IGJNYXhOdW1PZlJUVCB0byBiZQ0KPiA+IG1pbihiRGV2
aWNlUlRUQ2FwLCBOT1JUVCkgYXMgVUZTSENJIGV4cGVjdHMuDQo+IA0KPiBSZXZpZXdlZC1ieTog
QmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQoNCk1hcnRpbiwNCkFzIHRoZSBv
dGhlciAyIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMgcmVxdWlyZSBzb21lIG1vcmUgd29yaywgYW5k
IG91ciBjbGllbnRzIGRvIHdhaXQgZm9yIHRoaXMgY2hhbmdlLA0KV291bGQgeW91IGNvbnNpZGVy
IHBpY2tpbmcgdGhpcyBvbmUgZmlyc3QsIHdoaWxzdCBJJ20gZmluYWxpemluZyB0aGUgb3RoZXIg
dHdvPw0KDQpUaGFua3MsDQpBdnJpDQo=
