Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA891CB9EC;
	Thu, 21 Nov 2024 21:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732225186; cv=fail; b=utveqWoKjR97vhJ239CayS/IBfccONPaQ8ZuewacocnE3DX9m3Y4aQNw7jvVfgnLFz5leNX/bPIR6WU7M2UxY1K6Q2jl2Wjv1j29+GHTDa+k5aNdmT8s5fZqTzOvhjk9jCVL7x/8hA7cqz9zturRSyi4JqtnAox6r52HX9AFQYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732225186; c=relaxed/simple;
	bh=Di60JHLzICmXYgMtUFQmnWnMGLnB8MNq9MmxbLM8BfM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t1pWcWfxHkRA42gZoXosQF9HU6VT3myPzpCStdhnm0c46C4FWDxImYy1Sjtt/wzXAhwbCofFTQtkn5kidrLRxOVgPcYXrreFnabfvduMIHahMdz8ItoDqw3FFiMp2I03jFwt87pMJdCYIKLI8BCj97ZMooEtGL8Jr5Tty8ZWacU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mesW2+qf; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=p1WkfEUg; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mesW2+qf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="p1WkfEUg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732225184; x=1763761184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Di60JHLzICmXYgMtUFQmnWnMGLnB8MNq9MmxbLM8BfM=;
  b=mesW2+qfa4Es6XFvF1GPdyAj658F+w/dQtxpKt3o5sb7B2hs7DecT5KX
   h3+f2V32jsh2gLezpNsf+lgB3ybfMydXb+9OHa2GL0mN5FBbi1p7P9RP8
   sqd5WbsSqmHmIK7Qdm+CUSy+woeERNvevLvUz2l/nF/JZr6iS2Hk76LjG
   zSYu7FDjcETHweM66VNRqs7dSUNmcbXg3ZgamWRoTJBO7wWWmRRvOuls8
   2Ih+MdgScjeBi7Llbbg93AtBn6UhWMuZbX744vFyk8iaryL58m0vKZnFg
   AifM3RyoL7lUCqOgAKK0VOW/zq7n9AdlLuSHzExbyaTmq+eSpMUnHqm2d
   g==;
X-CSE-ConnectionGUID: 1VK/Gv8mSDeWgBAXKmxqzQ==
X-CSE-MsgGUID: mM6QXs4LTjOOkUAwGEOQYg==
X-IronPort-AV: E=Sophos;i="6.12,173,1728921600"; 
   d="scan'208";a="33128975"
Received: from mail-northcentralusazlp17010006.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.6])
  by ob1.hgst.iphmx.com with ESMTP; 22 Nov 2024 05:39:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QY6fzmM8tE8odLkQd3lhBCPZy7nj9N7CbV60zZYQZy/W+//qRCcOq1/inEjsJpvL9v4Rh5DmAPvbdqKtTua8ed6LvYeVFVZ+CDKQ+YXNi3tFc1CeAGmJ//i1Zev/GnPUjxt4XWWNz/AQGCSr2Lrt2zmjQS93RKA7zO40KsZX1UyABftSHZaXtk2cTtGCBA0OschPtVPbtm8iSl+QvC6w0DNOjC4QbK/AyJH28TOgOhjb+bHF67H/tPOXoM3ZMMPrRtDd/c8EO8A0EZaOfKHUWm/IdZhhvRUfkBaeEum24E1IUO3xVBzp4M/tu22g3YHVYZ9P97cIICPKQcHjVIsUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Di60JHLzICmXYgMtUFQmnWnMGLnB8MNq9MmxbLM8BfM=;
 b=pUjQckMAvWKpo5V3mo1E64rElPXoMNRS0LiW+TU79CiBVJ5uSMN92hvJUgeognCAIqj9efx2GK2WNDpn0alcI07ulKJIrftv/wpXk2Xc6iBTkE/aA/ZYlOlHXIDRo99AmX4//zOpaeWV6rG3Hc42hKhutMDSpENM5InO+YZ4jM+UuE7rzw6lCXWX00Cc4NKcvJyJCwft9oBPOHVE2yfkBl1/g8MNyU86Ul6ape4cD1D75IDjzAkPt8cmX/PQOGsSyPVAmooc4OwJNH8mIoWeHLcPfWJhKXXw9y5IxuKUNiX5uCLHuWlcaSYggJYrgIKUh+heuwKgjDbrGCZafRMycA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di60JHLzICmXYgMtUFQmnWnMGLnB8MNq9MmxbLM8BfM=;
 b=p1WkfEUg83hhk7DSWfc9dB+VDai8f2yNkUuswdmBIFcHHZQo61lloU1dQHaiI+5Ae8E/g65UFrgpCitWdUs9k8vGF9pmCppMtVkRDIFEuhMiRpwU4WWuGz0OLNIwbOTOceXxLetdOG5gQVM6JLvT5IfskmC0YOsJ+Ox9re1kDyA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6779.namprd04.prod.outlook.com (2603:10b6:5:243::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.17; Thu, 21 Nov 2024 21:39:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8182.014; Thu, 21 Nov 2024
 21:39:40 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bean Huo
	<beanhuo@micron.com>
Subject: RE: [PATCH v4 2/3] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v4 2/3] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbOchMsHzJ8dy2eEyFfqftsiUG+rLCOLqAgAACVTCAAAX9AIAABvMA
Date: Thu, 21 Nov 2024 21:39:39 +0000
Message-ID:
 <DM6PR04MB6575245460C01A2A88701ECCFC222@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
 <20241118144117.88483-3-avri.altman@wdc.com>
 <2955aa00-824d-4803-96f6-35575ae9560e@acm.org>
 <DM6PR04MB65754AAF1FD62DC4ECF32A69FC222@DM6PR04MB6575.namprd04.prod.outlook.com>
 <55ab06af-ff92-4454-b9d2-d481d8e9db43@acm.org>
In-Reply-To: <55ab06af-ff92-4454-b9d2-d481d8e9db43@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6779:EE_
x-ms-office365-filtering-correlation-id: c475edf5-15d0-4b09-a4be-08dd0a7500f1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ekJkYnZyK1RTZFpvYkZnM2VxZk5VbUE5UGFCbGhnQU0yd0tEZTRETTQzN1o2?=
 =?utf-8?B?TWhrKy9BcHJCV0pMQWYwMXh0UjhRREdNSHVWWG9uMUlOam96Rm5NYS9YWFZR?=
 =?utf-8?B?dVd1R25OV24yMzFXbU9BYTNrYkVlRzZ1OUpDK2tBQ05PSUNTSmRnaDYvR3Zu?=
 =?utf-8?B?bTQ0bW1yRUtZTVBpSVlZU2xiczZyQ1YvdXFhc29teVRJVWN3UDdmcnVhSTVv?=
 =?utf-8?B?UjRsZ00wUmF1VkFXaHNZNkJkUlN1aDV2L2liRng1eTJrMXp5YmNwN2xPemZN?=
 =?utf-8?B?SzNPNElGV05WM1UzSCsvNGdoR0hoQUhWbUdNQ3cwQ0RnbXFMNlIwNjdhZHBH?=
 =?utf-8?B?N2I1OUU3NFVIMDhxckhVNlJQakZEd1JLVWZlL2gzejdhRHlSaTVaYnVzZTJP?=
 =?utf-8?B?RkZBbGRubmRGK3llTzlESGljUU1ZTkE5Z1BJcyt0eTFjbUNVSGNKTFBCajFE?=
 =?utf-8?B?MHBnaGlLSlNwV3UvNlpKdnAxN0w1TDI0b1RwOXdTYWowWVMvYk1wTjBXNGE4?=
 =?utf-8?B?ek1EOXEwMkRBWHNxZXJDQnNBRm95SG1aQmhmbmQrYzZhdzZlMXZEU1FoL1JU?=
 =?utf-8?B?UW1XL1IwVFVxRy9kMlJadW1rUE1hdUtvL2hWZk51eXZEeTZ4MW96Uk9ZeUgx?=
 =?utf-8?B?dHJmcC9LZzVhNjJjTnV2N0dPalRHUG5ac3JtTzBlUnlCY0lVMWtvU3BZVTlU?=
 =?utf-8?B?dkdacGZRNmVXREhOWHlBaWNISExMa2dlWWZjRHk4UllVNTdOc0ZHUGp5Rzdj?=
 =?utf-8?B?K05yWDhKY3FLaUJyb1dRcFh6S2ovb0NvYW00S0k0eXNYMVd4eVArZ1ZIQVYv?=
 =?utf-8?B?RERhc0xzd2ZpVWRmbVlJb0lRYkVmekNqU01EVGRHbXlWbENFQjdtZzNucXQ0?=
 =?utf-8?B?cXBndXVsc3FWbTVXYzNqUVNNbHY5c0VsbEgwZHZsWXNhMXo5d0V4ZmRMNFJB?=
 =?utf-8?B?YzVmdExFeWFtbmJBdGtQdW1oQUNYaTVjbG1CNUZuMW0vU0RuSGRORTh1UlV0?=
 =?utf-8?B?T3lOY01ES1d1OGZXcXovTno2U21ybnh1YURjbmlrQnhEaFh6Wmt1SVpHZE9x?=
 =?utf-8?B?UGN1UC9aNFNjT1ZkVTM5SU9KTVk4S2JMclg3R1NyLzdGZzJyVTQ5all5M1VS?=
 =?utf-8?B?SVhacEJFaGI3eXNuNjVTZTJzM2lYNG8vaENRS1NuYkJhbDhQVlZYalBhNGZv?=
 =?utf-8?B?SWdGR1k4QVFyL056Z3ZQUlg3RXVsUFNOTDlrVXdUVWNrYndpWXhhZDQ0bFVC?=
 =?utf-8?B?ZnNsVmZabVQ5VWwyWk41Q2tIa1E0MTl5UGMyZXpBK2FwSkNUYXR5elF5eUJj?=
 =?utf-8?B?RnFXcnFuOTkvdi8wWUlsNkE1djlneWxhTWh3TlNNTDdqYkE0TXlHcjcxYTNB?=
 =?utf-8?B?TVA0aE05NHdjRXJwOE1USENOdm9SSFdjZCtYSW9hM3ZLVUZrWC9aZmhpSEM1?=
 =?utf-8?B?aGYxcXV6Y3B6WUxscmJ3VmljK00vYUwzUWVjY0dQK3F0OWl4WkRibEdaamQ4?=
 =?utf-8?B?M0JMN2VLajRMenVuWGxuU3BHZ2ovOXZWUGlZaXdlR29QejBmOXpDblljZXd4?=
 =?utf-8?B?YWltNlJ5cWI5Z1U1SjhMLzN0anRUSDF1MkdGZ01WM3BVYXlyQWVJYnV2cG5U?=
 =?utf-8?B?ejVRc0tydXNmZndTejU4SHdLekRlV1pxcmxqcE9LeEQ3RDdxTHhUbFRLZ2hu?=
 =?utf-8?B?OWN4aVNYdVg2dkc5VHBHWUNldGdlanNTcUlYUmxXWnJFMys2ZjdQcVFCMThT?=
 =?utf-8?B?RUs0TG9GR0RhbEZwc2c1U1NrZW9OVmhETDF6TFVZdFV0ZkM4ME9wbXA4MUEx?=
 =?utf-8?Q?kJpJBTHpIjckCTTDNii1j25IlwzqaBMYottrI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cG5NemR1bUM2MzczcmhtVzlTcVE5dFpDNks3Sk9RQzBSeVg0NXp0Y3Y2NE0w?=
 =?utf-8?B?WmpITTdhQ0lScUNMVnVPaDdPbjZuMDhad0pRTVlLcWZGdE1FckhxQUErb1ZR?=
 =?utf-8?B?LzNNY3VwYUVvbWZNaVRKazVMdGoralVkR0pNemlkTStNMndMdUdXVXUyc3E4?=
 =?utf-8?B?WmdZRnpkZlc0bmowbGFsSnU3QXBCZVZpdFFMYmhyd2xLNUJpL0NXeW1Ebklz?=
 =?utf-8?B?T3dyWTk1dzZSbVgzUXJFeW5UOGJJWnY5N0FaR2ZpemRGM0xuQ3FkV3VFV01H?=
 =?utf-8?B?RFhkTzJnUVJ3OGhqRDFYVGVUUUFYRENkTGo3T2tubTBrYVZlNTdyaG80N2t5?=
 =?utf-8?B?cndJcmJrcm9CNFo5SXpOeWFIQmY0SHhTWDJiSE5sVkhweDdMTml5UHNIek1G?=
 =?utf-8?B?elpvUFd3Wmx0ektxNnRXU01DN1pQekJJV1J3WVpHSnB6S3pYTXlFL01FY0xq?=
 =?utf-8?B?YndpemRFdGZGNCt1NDFDdFVqMVpGTEhvL1NTT3JxZ1JsemJpeDRoVHBEZXFh?=
 =?utf-8?B?eWVBdmxyclJLS25vOE9lTk53dG50OWxqaWVIbDZkcnVudk9UZVNVTUtZQ2J0?=
 =?utf-8?B?emsxOHBpYlJQMG1tVlJKK2FGT2lzQ00yRG1hUTI0YW5pbE1XVkM3Qk1nSXBQ?=
 =?utf-8?B?dTZwV0w4dExJUjNJc2VKcDFWb2VrSklOOTd5NXM2c2tsQjR4QXM1U1RKS1Rq?=
 =?utf-8?B?ZDlyczRUazFVUlVoTVZ1Z25BY1RWekRVZXVxZnMrMVppeUdBVktWK053NG9i?=
 =?utf-8?B?bGFGc0xMSjJLN2ZpQndXN1VLRFVSMWtPemlsSlppNEU4TElpWjNFM3BVYkla?=
 =?utf-8?B?ZDI4ZzJvN2NuU3pNc3JSakJYUVlSSHVJR2cyc25za09mdklGMTBuRmoyeGhP?=
 =?utf-8?B?MTRTRUpVL3JtdGIwbzlpaHlNVWt5NDdQclJHTXByUjJQNHczR3FYZDhVSFNs?=
 =?utf-8?B?N21wZ1E5M1JlNzJmUENIdFJ4Ymhub0Nsa0R1QlA2YUhlSFppd2JiWXhORW13?=
 =?utf-8?B?RHh4eXFZanZRQ1llSkNCSHJZWjE3VWxsMFFmeHR0Y0tDZ0sweGlycXg4eUo3?=
 =?utf-8?B?Q1FISDljb3NnbW1FTVFQeDliaGZackRyeXZiVnkyY1kzWkgwSnZTd1hKY2ta?=
 =?utf-8?B?aFNjK0Q0TnhteHArZllBeEtFM3V2ajlTdjhDVGZMakNhQ003eTUwdXViSUV2?=
 =?utf-8?B?WjF5enNFclY4Q2prVDVSNDZPU0FjQkZMUWF4bU5RRmdNUVdoeDhTNURFZmZI?=
 =?utf-8?B?ZmJ0QW1nQ044b01EN1BBQTQ4NzlkcWVQRVpsY3h3M3ZsTHJVNHhIdzZBU1h5?=
 =?utf-8?B?RGp4SW9HNnI2c3k5aG1RRkY1T0IzVXIwK21jZ0tNbTR1VUNqcFppUlkzMUZp?=
 =?utf-8?B?ZmM1WGRPb1J3dDZGbDhvM0JTSCtsN1Y0L285cGxGL05Pbk8xeVFBRWpGVnlG?=
 =?utf-8?B?dE1SY2htNmJ3aFBiRGpxejJuUzBUNXYrZnFTRjE2L3FpbkdRdnRmeUp0cVlx?=
 =?utf-8?B?WjFpV0pMaFVoL2FjRFU2YVNjRFlralhlSDVwdTMyYnF6dU1sOS9WWlFSMklF?=
 =?utf-8?B?SGxzOVk3aGdBTzEvL096ZE92OFBaNUdNbFg0RThWNVNRU0ZQWjBVcDRwMVlC?=
 =?utf-8?B?MEVFT1dBOHJNb3Q0M05sVHNVNTl5SjlDK2dKbVVvanRLQjlEYUlFcE85R1g4?=
 =?utf-8?B?VUIvbm9PWU13VXg1WWc0enlDVHZWakdLVUM2M0FaODJjY3ZBdDljbHNvRWZS?=
 =?utf-8?B?UExpc2N3QjR1dDhLRkFBdlZXTW9MdXhoK3JzSHBGcGtkY2xpM0R5SDArbEJF?=
 =?utf-8?B?Vmd3UjVaOGNMbUVoOFhMOUQ2M1l6NnVtbXpvZTdUNlE0dnVoVzdSdzZLbnRz?=
 =?utf-8?B?NHZrZnVIeXlKeVdGOGJhYmFqcUJjVGt5a2lPNlhsWCtEaDRsR1RZQ1d6cWg5?=
 =?utf-8?B?cUV4TDhHcGRyUEkwdnkrbTgrNXpTU0sraEdldm5xbllGcHVEaTVUeThkS01F?=
 =?utf-8?B?N2VwNWplVmkwTHVXaGZzRmkvR09PbUs4cC8zM3hjR0NOMGpVNnhBUGdKUVk5?=
 =?utf-8?B?c1NKOUxEcTBJdmRJSzVwa0VqRmxIcTBTdUg0RThBNHRKbjRmNmlQeXkxRTNF?=
 =?utf-8?Q?O4gIsWJ465GL2Ay9PaYceRyGS?=
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
	ZJQ2RB8Y8jFoLtnEVtHXp6sgYuUFBOCCj05U03Q/zRsNKzBnYRJPcfZG/Zifcmi8cdWL4KKzj4qLqIPHErYtkTcJElWQc776a5u54djS189aI6NoX7beHwgd04TOg40ItGeG3H9qninbEoicBZZHXLXmRIAt9iWRP1NWDcp/NxUh81tipC91etWfPIboD3tThgYvdjnHGT34tEn+oXOO98iuy+a+OGHJucpWdUcKD89LrmgHERTafcC+VoYnsB67qv8V87mhJMS/PmhraY7gOsE0QP5NPiiIWqrsYemYqs7Q1O6X30i4lDT9QnqJq+aNEFg8ANM9EIKzFF2MMTALSvrtvqhoBX/ONJW+xnArpA1dCJvgq3D4sPKU0uymRp3yPanaMbUfMoALhXjjAnKmW+ydNS+HzOS8noO0PJcVgKK2PYC64t+sGqwPvhXRVEYj+p3q8OvBtObmGhc00e/spt3URI4YjZfEhKUOMaNw2179M8kdmkevss15O2MI0rF2ALCsPZ25FhxI+a2g9xGqRz8yCfV/KHLnq7K3f+GbihPo3mZcR3QPJhKW9sQeqtgSm/zAhLsXBEUU8oeiEfBK+193rU8EL1PJjWfGlnbRIWxRwi87bBJetf0OD9J3miLe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c475edf5-15d0-4b09-a4be-08dd0a7500f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 21:39:39.9140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cw6PNR1dpoPcFUs2aLf9HsK+cBMnN3osilcp8wix7B/WbXZyWVHgx7YfFyJNdl7xvMqD/Y97FAM0HezHMHQjYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6779

PiBPbiAxMS8yMS8yNCAxOjA2IFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gT24gMTEvMTgv
MjQgNjo0MSBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+PiArICAgICBzcGluX2xvY2tfaXJx
c2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+Pj4gKyAgICAgaWYgKHVmc2hj
ZF9oYXNfcGVuZGluZ190YXNrcyhoYmEpIHx8DQo+ID4+PiArICAgICAgICAgaGJhLT51ZnNoY2Rf
c3RhdGUgIT0gVUZTSENEX1NUQVRFX09QRVJBVElPTkFMKSB7DQo+ID4+PiArICAgICAgICAgICAg
IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4g
Pj4+ICsgICAgICAgICAgICAgcmV0dXJuOw0KPiA+Pj4gKyAgICAgfQ0KPiA+Pj4gKyAgICAgc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+Pg0K
PiA+PiBXaHkgZXhwbGljaXQgbG9jay91bmxvY2sgY2FsbHMgaW5zdGVhZCBvZiB1c2luZyBzY29w
ZWRfZ3VhcmQoKT8NCj4gPiBTaG91bGQgSSBhcHBseSB0aG9zZSB0byBob3N0X2xvY2sgYXMgd2Vs
bD8NCj4gDQo+IFllcywgcGxlYXNlIHVzZSBzY29wZWRfZ3VhcmQoKSBhbmQgZ3VhcmQoKSBpbiBu
ZXcgY29kZS4gSSBleHBlY3QgdGhhdCB1c2luZw0KPiBzY29wZWRfZ3VhcmQoKSBoZXJlIHdpbGwg
bGVhZCB0byBjb2RlIHRoYXQgaXMgZWFzaWVyIHRvIHJlYWQuDQpEb25lLg0KDQo+IA0KPiA+Pj4g
KyAqIEBjbGtfZ2F0aW5nX3dvcmtxOiB3b3JrcXVldWUgZm9yIGNsb2NrIGdhdGluZyB3b3JrLg0K
PiA+Pj4gKyAqIEBsb2NrOiBzZXJpYWxpemUgYWNjZXNzIHRvIHNvbWUgc3RydWN0IHVmc19jbGtf
Z2F0aW5nIG1lbWJlcnMNCj4gPj4NCj4gPj4gUGxlYXNlIGRvY3VtZW50IHRoYXQgQGxvY2sgaXMg
dGhlIG91dGVyIGxvY2sgcmVsYXRpdmUgdG8gdGhlIGhvc3QgbG9jay4NCj4gPiBOb3Qgc3VyZSB3
aGF0IHlvdSBtZWFuPw0KPiA+IGhvc3RfbG9jayBpcyBuZXN0ZWQgaW4gb25lIHBsYWNlIG9ubHks
IHNob3VsZCB0aGlzIGdvZXMgdG8gdGhlIEBsb2NrDQo+IGRvY3VtZW50YXRpb24/DQo+IA0KPiBX
aGVuZXZlciBsb2NrcyBhcmUgbmVzdGVkLCB0aGUgbmVzdGluZyBvcmRlciBtdXN0IGJlIGNvbnNp
c3RlbnQNCj4gZXZlcnl3aGVyZS4gT3RoZXJ3aXNlIHRoZXJlIGlzIGEgcmlzayBvZiB0cmlnZ2Vy
aW5nIGFuIEFCQkEgZGVhZGxvY2suDQo+IFNvIEkgdGhpbmsgaXQgaXMgYSBnb29kIHByYWN0aWNl
IHRvIGRvY3VtZW50IGluIHdoaWNoIG9yZGVyIGxvY2tzIHNob3VsZCBiZQ0KPiBuZXN0ZWQuDQpE
b25lLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
