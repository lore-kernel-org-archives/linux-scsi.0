Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F8F41A8F;
	Sun, 23 Aug 2026 05:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787461517; cv=fail; b=AabFNx0iM/ZBnd1n/FqAZ/JtLC8KV3vkx77Wap7kJfSANfe21BEF7L0kUCqN91a9IPPil6cx4O+mBdxvuncW9ZY8mpgryFP4Y3piM7Oc43orEEQDG1GbBQp6KLoxqltBlAuFthYykDB+ZbVo4A11Mr/M0JY2CY18AwD9+3X7b78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787461517; c=relaxed/simple;
	bh=eeNv5QZuQ5fl6EhH7swBkgcNgrhv6JemO6NeSf7NOI8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tcawS5h9ChYDrsXPdKR/95y8tEqJMyBV5g5AS59XD+JFvzCeVJI2eXppsHbxgHRlhhSgzSPza9R8a8/2EiFEpSl9IdvQVyOjL/rWFFU5Kj0721McA3TR8Vh3qZJEFCBGnfcZUXCV4WPXrnK+XmcerokBiOx8GSHaGVLO8SOVeiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=R5uezt5G; arc=fail smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="R5uezt5G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1832; q=dns/txt;
  s=iport01; t=1787461515; x=1788671115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C17kN4Qgg5Fm4/HUFq/8NX+c2uB4rYyyCpJ7yPleGK8=;
  b=R5uezt5GEAWh+hAqD6rQejsqmbLdB9M7mJ9woZwugT3S43OnBKZbY0Dm
   oWaa5yawJLd4c6Rjmfudf9G+grw6oxdapr2epk/NzKeV+Vkc8c+hBZgJx
   nUrYB7HkJgJgnBUejpUuyRBj860QMys8gVgUean4tJrAXwRuDfhGq8Mbi
   sAOLEPGPHmXjNbk1wx1acpYeDl7FvDv4OtWPKpo/uWNE6uMrr41tcXXTT
   zm5whG1XBeYYrjz+HMWszKrYduHAMI9os3xWZvunvJcBHO5Q8O5gNJNiy
   XUiXdjyLgIDhZMlvv1vzB1DJ6OxUvCBJzk6b6a4//sLUg+BzBIPgB3Awr
   A==;
X-CSE-ConnectionGUID: DrKmBRVTSrKau3rPg1u/Gw==
X-CSE-MsgGUID: IYx/MdI+SQGezdoV6RlwmQ==
X-IPAS-Result: =?us-ascii?q?A0B2BABzfopq/5X/Ja1aHgEBCxIMZYEgC4FuU4IrSYgjA?=
 =?us-ascii?q?4UrhliCJJ4bgX4PAQEBDQJRBAEBhQUCjWwCJjYHDgECBAMCAwEBAQEBAQEBA?=
 =?us-ascii?q?QEBCwEBBQEBAQIBBwWBDhOGXIZaAQEBAQMnEz8QAgEIGB0BEDElAgQBDQUIh?=
 =?us-ascii?q?W8DAQK0CQKKHHiBATOBAeA5FAGBOIheAYV4hHwnG4INgVeCaT6ECjuEE4IwB?=
 =?us-ascii?q?IIigQyBfZFaUngcA1ksAVUTFwsHBYEjQwMqLy0WDQ8TKQUtHYEjEg8dFxceW?=
 =?us-ascii?q?BsGBRIgKkFEIwM+gRlBAoF1PyMZNnqBCV6BKylgAQIQF0YuFYIHAoJagSdeA?=
 =?us-ascii?q?gFJQw4HSCILbT03FBkDBIE1BY5UH4JMAWQqllGCaQGwIgqEHqISF4QElBeSU?=
 =?us-ascii?q?ZkII6h1AgQCBAUCEAEBBoFvCC2BWXAVgyJTGQ+OX89deT0CBwIHDgMLkWiBf?=
 =?us-ascii?q?gEB?=
IronPort-PHdr: A9a23:timrkhzR9fWVLT/XCzPsngc9DxPP853uNQITr50/hK0LL+Ko/o/pO
 wrU4vA+xFPKXICO8/tfkKKWqKHvX2Uc/IyM+G4Pap1CVhIJyI0WkgUsDdTDCBjTJ//xZCt8F
 8NHPGI=
IronPort-Data: A9a23:O8QsQqopeMYPt3kPc9mSVyc3duxeBmJzZBIvgKrLsJaIsI4StFCzt
 garIBnSbvaDY2OjL9gkYYjg/UsEscXdy9cwHAZv/382RikRoOPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgLNNwJcaDpOtfrT8kg35ZwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0sptImRkz
 8IkEyouZw3Yndq5ma/8ZfY506zPLOGzVG8ekmtrwTecCbMtRorOBvyQo9RZxzw3wMtJGJ4yZ
 eJANmEpN0uGOUASfA5LWfrSn8/w7pX7Wz5Rsk6UoaM0y2PS1wd2lrPqNbI5f/TXH50EwhnD9
 z2uE2LRIyAKc/mT6Hm+y12hlOPIo33BXJ0XLejtnhJtqBjJroAJMzUSVF2msby6h1S4VtZ3N
 UMZ4GwtoLI0+UjtScPyNzW8oXiZrlsHUMFRO/M15RvLyafO5QudQG8eQVZ8hMcOrsQ6Q3kuk
 1SOhd6sXGYpu7yOQnXb/bCRxd+vBRUowaY5TXZsZSMO4sLop8c4iRenczqpOPfdYgHdcd0o/
 w23kQ==
IronPort-HdrOrdr: A9a23:8OFAmqhBEAHeL+JnxsAlxoU0f3BQX9V23DAbv31ZSRFFG/FwyP
 re/8jzhCWVtN9OYhAdcIi7Sde9qBPnmaKc4eEqTNGftXrdyRqVxeZZnMTfKlzbamHDH4FmpN
 1dmsRFebnN5B1B/LnHCWqDYpgdKbu8gd2VbI7lph8HI3AJGsRdBkVCe3qm+yZNNXB77O8CZe
 GhD7181kKdkBosH6OGL0hAddLu4/fMk5XrawMHARkI1Cmi5AnD1JfKVzKj8lM7ST1g/ZcOmF
 KpryXJoomzufCyzRHRk1TU84lXn9XZzN5CDtyni8QeKDng4zzYJbiJXYfsgBkF5MWUrHo6mt
 jFpBkte+5p7WnKQ22zqRzxnyH9zTcH8RbZuBylqEqmhfa8aCMxCsJHi44cWADe8VAcsNZ117
 8O936FtqBQEQjLkE3Glpr1vlBR5w+JSEgZ4KkuZk9kIM0jgXhq3NUiFXZuYdM99eTBmdga+a
 dVfZrhDb1tACOnhjjizxpSKZqXLzQONybDZFQescqI1DUTtnV4w0wEgPE7pB47hcgAo10u3Z
 WZDkyu/4s+E/M+fOZzAvwMTtCwDXGISRXQMHiKKVCiD60fPWnRwqSHq4ndydvaMaDg9qFC0K
 jpQRddryo/akjuAcqB0NlC9Q3MWny0WXDoxttF75Z0t7XgTP6zWBfzBWwGgo+lubESE8fbU/
 G8NNZfBOLiN3LnHcJM0xflU5dfJHECWIkeu8o9WViJvsXXQ7ea/NDzYbLWPv7gADwkUmTwDj
 8KWyXyPtxJ6gSxVnrxkHHqKgXQk4zEjOVN+YThjpwuIdI2R/9xWyAu+CGE2v0=
X-Talos-CUID: 9a23:rzgqmWHf2DXCEM+NqmJL7m0RMPobTkbH737NeFWABj90D5KKHAo=
X-Talos-MUID: 9a23:2puuzQsqZhGjfC1rGM2npQByc+JkwueVMW8Ag5kBhZe+MTN1AmLI
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Aug 2026 05:05:08 +0000
Received: from rcdn-opgw-5.cisco.com (rcdn-opgw-5.cisco.com [72.163.7.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPS id DC3A6180001D1;
	Sun, 23 Aug 2026 05:05:07 +0000 (GMT)
X-CSE-ConnectionGUID: 9UuM32ACTPup1CjJZ6+IXQ==
X-CSE-MsgGUID: uc7dJ18fTO2paSZ1ltypiA==
Authentication-Results: rcdn-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,238,1779148800"; 
   d="scan'208";a="66884235"
Received: from mail-westusazon11010046.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.46])
  by rcdn-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Aug 2026 05:05:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sVTG1mXqmD3HIR2gdOs4vDn758LJe70HwJ9RfL5tlpOz8yl7ZfbxWu62SKAxe83IWNt5O3pDIdkmNmrLsxfHJxCLw/DK3xJCAf6EoL/WKluIgQLoI6DUnrZppASwgmUtUCREQ65wLnYQ9A0LH2VU4gMdq62GIGOgET4urH8l/kuJkFhZmoCmhDHmDdGflDFTSBzVN5794dAxOgSj423M/QC/XYlLds1TKppaDNshKyEZDPXiBT0MsE1TzkCB2Q7IpsMZ+e7GR2agQt5iReUEbfV0B5BGbyHcCSDnLcL43rNRoJZpyE7XwaOYdAM1cglSph2UeRs6V4vcPKNGjphkhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C17kN4Qgg5Fm4/HUFq/8NX+c2uB4rYyyCpJ7yPleGK8=;
 b=vDmXVqlNJarL4vYSKx8fIBUlAQzwktVHJrk9DQ7M/guXdotWdDY4WKASBZgIjAxDbbdmEhVX89VmvQMZOIM8a2SBYj35r5oCeQ3FJeUOWTfie1vWLTge/VdhddsIWfTFt+ygjlXb393hzaZ0ccbGPCfcPFM2KWGf6JCpbN3xJQsBNhGOpQZ5xZ4leTc4MdO772jJ9aofgc8rHkcKJecL48ruugZbBphdV2F048o+C0AxwGaC6CwvjxWxJaJ/nSla2fAtNwii/ANOxhf+Edj/D+0n0Y7RX9a/c5uBVcM4DMGxapQhByF4sxBMvZujhguNiGR4GG55M7gCJ6wzPAPPrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DSVPR11MB9743.namprd11.prod.outlook.com (2603:10b6:8:34d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 05:05:04 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%6]) with mapi id 15.21.0339.010; Sun, 23 Aug 2026
 05:05:04 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Linmao Li <lilinmao@kylinos.cn>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Hannes
 Reinecke <hare@kernel.org>, Justin Tee <justin.tee@broadcom.com>, Naresh
 Gottumukkala <nareshgottumukkala83@gmail.com>, Paul Ely
	<paul.ely@broadcom.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: fnic: initialize the NVMe local port info
 before registering
Thread-Topic: [PATCH 1/2] scsi: fnic: initialize the NVMe local port info
 before registering
Thread-Index: AQHdL8/tiO9knU7kREqpjtsF7UOa8LarGafg
Date: Sun, 23 Aug 2026 05:05:04 +0000
Message-ID:
 <SJ0PR11MB5896AC03937115745995EFDFC3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
 <20260819114242.3598034-2-lilinmao@kylinos.cn>
In-Reply-To: <20260819114242.3598034-2-lilinmao@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DSVPR11MB9743:EE_
x-ms-office365-filtering-correlation-id: 496afccd-2310-4a00-5b74-08df00d417c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10067099003|56012099006|22082099003|18002099003|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 /l3AhrE69/d/x2j5InP1t+Qc5YWA44Vny0/KDkvhirIva8Ueg2UIH+NwsdPtkuuyB5zzpqlcptGZ0zbbCBnpIXgw+YbUd8Bq2pGKC9fL0N3mB69R26ydgcdY84NLE693GP4el0gMw29wrmpoKeVhIUdCFxw/+I98dM0o/I3QjjnEcp8COy81YIkfntpQ/oBdzIsUbSrklxr6nqIeWY5PFdztTJwmPibx094Zw19Wopkz8y2z2FP4s+FcgMA6V9s3m/rbnEAMa7judmPe4Us/eBhANjsHKkEPFHdN9+ZEE7ezjeux6xzSN7HFkdm11yXQK1cgrReBPvi1GWDZTPNZlaoPxrwy+15FdYJoUo1DjX7pRSsqlZHywjHdqEmA2Y4RAs1okF5Qlk5KpL29Kh7SOvP1fvhdQUJDrE/An8TR2jL5GfoJ1oF9lBvnONI2O9jaxz181nhc7NVCff3VXUgNpY8kK8Lh9lmUkg/BwiXnqMNimNAvNO166M1xwnJ+pMHdriekiUEiu9Ce78+jvgCmdRk/sfmyHnQcF7+41FK+qbn92WCFhZMkBR12r/ihElyj/Y/10l5cb8o2eTTKEcK4A5EJx/aTnnMDHU7xrzqUe7DrEDcD7PEJHg+zlFaJ2Yoe1HiAP5+0kLqotTsvTzEThNNTxj9SWYGUZ2ADMlZ6kAqsz/uqZ4ZOvpDgP9tSQGCCRmRT5YoO0h8tPfDQF9jeTasLj/3Ng19FCiIIxURppz4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?69XyNFSCfnBrysDVVL0Wzp5xSgXZNXHAlJnwOh/WlqaWh76xVTu+t44vMrjY?=
 =?us-ascii?Q?g6cvEkew0SHIK103T4WK4n3e/rNcMmuBljCFEKpu4jgR1SbHLhGcwKzVjJKe?=
 =?us-ascii?Q?D2Nb2qr9IlvTAX9zDp0YhfaK5Vsj4FPhdfS6wh4R6hGqyhtjrAQ2hPoYlqOc?=
 =?us-ascii?Q?/HNIDxdbpR3BoQF8B10D1iSKQtlicb4N24fJr0eHXZQm6qUbp644Kwobk02E?=
 =?us-ascii?Q?Xr69JP6ioejTsQuD1hjPS/jCmRr/sMmjjt/160OtiVOwnbjZs3vhucI9Pfnv?=
 =?us-ascii?Q?HnOsZEOTm6+cQ98zuTSS0k+omONZ8fk0w00jxzP1sxj5V+bVEIJvCvsXTvpV?=
 =?us-ascii?Q?uYi9UJMINiP+WPyCyawRgLTKPDldQ3gjspGYpI774gWZzR3LyLMxJtcwaX3F?=
 =?us-ascii?Q?fGZ8cK/Q15FVSIVdOQHUpmdZhyz83ZljEkFN7bWR9Nse+Zw+3u8QSCl3C6Zr?=
 =?us-ascii?Q?UWRDMfSn40Wzfqp2Y3Z7KjMTUX2LOJYIWoOB1K3o7bJF7UtvZrqX3XkmYCGJ?=
 =?us-ascii?Q?YtAfJTdlj8D4LRHR8RVNKr01vtyW17Dl+nJghqU3R0Ibmo54h7cbyRG9Gyo5?=
 =?us-ascii?Q?RZSqfI6u2SLLGEqc6jMKX5W+naVyBOsnxntA5jRSDlMhI2MkjKOyUXXi7LsT?=
 =?us-ascii?Q?hUly4fYrXvP5rb/55+oEUHQtoU67UiCwBD/FRzfGcb0+weJKAi6S1ZscuMUN?=
 =?us-ascii?Q?RQ95+P73g0RIwisT+6mlCote5aIc5H4JfSy16qx/99k7rX83msF11c1khuQw?=
 =?us-ascii?Q?vxwuTgEKQkDjklMxKPDX+3c3RfWe6NZkVKcIS7VeCtDMbRFuLPo95oG19HKE?=
 =?us-ascii?Q?d22ExGGa6gNEYWczggQ76JZXsAcE4e6L82Ar6yaFWLli5wM+O6y+pgo9DLwB?=
 =?us-ascii?Q?Jw+TfMboUS35bVAmK1+ELmWpSor0jnACD4nGIHtxnw0hjrlZyu/+8ecJDNIU?=
 =?us-ascii?Q?MjPaZvgRc84BVhkGayZMY8rq+rYdCvafsA9I3+WxChwg6obIQZ6VNxpj7yNR?=
 =?us-ascii?Q?fEWvHdkuz6cTvvUUW1CD6mMHja0J/YXE1k4nOjBZ9oftwB736h3GdChaISxs?=
 =?us-ascii?Q?oR+MAls4Kh+Am6zhqTMheYqaotkMnkMsPSBKYDlBl6WjT9WOj7x5OkH/ICbt?=
 =?us-ascii?Q?4DJNlY9MW/S9T0UCvS808dpHxMPVBoUiXWzb5E6wofehNjuc39Ty07M9yYQ3?=
 =?us-ascii?Q?wM5XpkhmFZIr0HrVm3EDp3aO4CDe05MYaRVAnMILqYUwrVxYME9bEL94vXBJ?=
 =?us-ascii?Q?oHfHe/9pZr9EXfU6YQQ10fWAFJTi97YBxlPwDxjhJ3V4BirTxa1+Q0ZLABjv?=
 =?us-ascii?Q?MpU/vlthlBTtw3GQAPakpJLkFwjv35l/ImtCZJmRGIJ0ZVcn8Vh63d9r80Fo?=
 =?us-ascii?Q?e7uQg9CTGexn6BhCx9w5gM8nt27RTJXjWR94SPnOnGOh0y3LIYa3YvG/cul4?=
 =?us-ascii?Q?6ntXoVXrxgie+R+FG+208T39EJKEu/k833YQGSaMYflNZs7AUPreVReBDIZp?=
 =?us-ascii?Q?+3h8FGNyl0Zr3AEyKXj4EyIdQeQx5Iuxzq07Lex/BDjceHLpXvYUSEBHVt8V?=
 =?us-ascii?Q?y5KqXrqvxBU6FG5ImR1UW8Od6AsDoUXoTa438tfGehOFeg20vi++bIHijxA1?=
 =?us-ascii?Q?HViJEZx5918PpI3fuPxmHRM4p5w4idPAxN0DiyUvD6M8YHXPEurJ2enUSh0u?=
 =?us-ascii?Q?S7qEhfHiWWyOC1YSOd1OQalGUOk0yr/b7u2wbuWuQEAE9n+A?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	DHm4SCAdS4G6iy5qW+0OLT6WjU5+IKSqoZzXLVFEiuPVws2Ix6Ze6BfR9zrArcspgHJSg8t1gN89BM747vMWjli0rDqwr40AljwAjicHPHDzJq4kyFIAY8WyZiDOYX11lPbV0JyfUklKnAKJZ9Nh8qPE2WJqQKL1iVlP6xgYhN++kPs5wrGwkrTwex0H5Y/amLau2/jNz+w0yf6HilLIvXfhuNlsrkLTjB9E10zCPLrGiNm8797+FNbXzWr7kP1r9WE33xfC84SSLro/VcetEODKX6fK2fHPcntZgKNs3y+YTJjzHVYwPKQFA0Saoak3roiUzIQ9ZW1Z9lBST+Bhpw==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496afccd-2310-4a00-5b74-08df00d417c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2026 05:05:04.1569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TK5v77FSiVgb09L+1UZ1UXqJ0NvLxa63INvJy8ZBKp5ppnDVjhzcf6cRnRcUk5V3JBkzqKfI7D4GHeg15JXx7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9743
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-5.cisco.com [72.163.7.169];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.169, rcdn-opgw-5.cisco.com
X-Outbound-Node: rcdn-l-core-12.cisco.com

On Wednesday, August 19, 2026 5:13 PM, Linmao Li <lilinmao@kylinos.cn> wrot=
e:
>
> nvfnic_add_lport() declares struct nvme_fc_port_info on the stack and
> fills in four of its five members, leaving dev_loss_tmo holding whatever
> the stack happened to contain before the call.  The structure is then
> handed to nvme_fc_register_localport().
>
> nvfnic_add_tport(), which registers the remote port a few lines further
> down, memsets its own struct nvme_fc_port_info first, so only the local
> port path passes uninitialized data across the transport interface.
>
> The NVMe/FC transport documents dev_loss_tmo as "Used only on a
> remoteport" and does not read it in nvme_fc_register_localport(), so
> there is no behavioural change today.  Initialize the structure anyway:
> the driver must not depend on which members the transport happens to
> consume, and any member added to struct nvme_fc_port_info later would
> silently start out as stack garbage.
>
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---
> drivers/scsi/fnic/fnic_nvme.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.=
c
> index b237948dcafdc..00d9d5d439a38 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> @@ -2216,7 +2216,7 @@ int nvfnic_add_tport(struct fnic *fnic, struct fnic=
_tport_s *tport,
>
> int nvfnic_add_lport(struct fnic *fnic)
> {
> -     struct nvme_fc_port_info pinfo;
> +     struct nvme_fc_port_info pinfo =3D {};
> struct fnic_iport_s *iport =3D &fnic->iport;
> int ret =3D 0;
>
> --
> 2.25.1
>
>

Thanks for the change, Linmao.
It seems simple and straightforward.=20
I'll bundle it up with the other change in our internal testing and get bac=
k to you.

Regards,
Karan
