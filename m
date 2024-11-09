Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D8515D1;
	Sat,  9 Nov 2024 06:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731132356; cv=fail; b=Am2ANQZdYNp1961KSN0okGvPu9i05Gcm8eqTt3lseROB0HaCbGBH8h7hG2ecy0jWNS/Yx8VTDrqf1Hg22w2WY5tZB9dU7gOLMdpoWOEqZU8XVoG8kB5gEN54Xt3vGWtzDkZJMPaFxAUONGg8ZODfMMVyCMP8M8PFKo9S8ofJsfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731132356; c=relaxed/simple;
	bh=NhyQqsiR9nFKLXVE7vow+AZHy77x9x8tuTqAkkDEHU8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZD5LlhXSGEvOaJuek4gXDGqbaXOJj3/l0eQ79vsAw/s5C67zC9ssSKCHiC0Rdcbq5e/KEyun9qrEg9kNqHh/xpE2DUKFmnuE7OhP3Ay+FZQ49TXcoPdLifNtZGOj+MZZDt78HrVKjKXD4MlCROV8ULa1tTDStdTl4Gxaljog/GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ipcM95us; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wBIqFuMg; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ipcM95us";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wBIqFuMg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731132354; x=1762668354;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NhyQqsiR9nFKLXVE7vow+AZHy77x9x8tuTqAkkDEHU8=;
  b=ipcM95us8FXfWg5iqbPWB/uCj5Y1XjoOhYVpDToyQoHMp4K/q+JixZi9
   SPQvYTNrfVtpX/L1J3e/awEoJYVgD3KjVpzAP0NzZotja6Y/9ZqqKAjGM
   GqwuLLk21mJIkiin/tSefHy11FXZPoRYxRzRhvP44Y/7Z4LsJ6MX7bjQG
   Rd4YAderWqNR3HSeJymg5YxWd1/hrDEJWYhvWV8tZ2IKL51956avq8pf9
   liyyU7Y3uAoNl0L3KKAFzHhCU7XJVeSGbJuW1rDd4xAS+w8yI48LBQj/3
   45RhSNPazhH8lk0qiuwXVYskDKxmEimwe2cvPxgs2xzRpDq4TKijE1jpM
   A==;
X-CSE-ConnectionGUID: f6SBIIGmSCe4YbOJ5N1KZQ==
X-CSE-MsgGUID: OgvuyI+2RAGmUzhZCecT3A==
X-IronPort-AV: E=Sophos;i="6.12,140,1728921600"; 
   d="scan'208";a="32047742"
Received: from mail-eastusazlp17010004.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.4])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2024 14:05:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQCxnZC3qIvq+POZOAKKMzZlqrTAUlw0WW9zRw1e7wCNZw1W4bJcP3I9ejZglvqkHPtuebk/HZtndKGDypVx9d3EUYYmSEwDhb0usZ2hcObGJ81fcazxAlkkSBzbNYqYl521BFb5VDMqibzYEW4+1MwLxXNq9kFV/CxX9piZbgG5JOxncAC7yoX3SqVIfbUAW7va7m7S5dWVqOIdsIgPkdSEKKQxNoZTlSFUpcoYy85+1jZcsnFrA3q5lvUc3OkFqXMSrlz5ZtU40ehB8ENeXY5m+k9vHyBwjB7Xpuvfa3jHuHNXGUx+ZGZ9JWOVycD9RejvDFE+FZQmfgE0hT98TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdBQhIv69I5AR6mgQiilaLCXpZ7TUc93goeWbS3FPqQ=;
 b=fKp7MnSK9zvQ7BrJ3QcYfhPehaTLdzHT5u5lFNW/D7v3OrWLYsl1QcNz3ULpnC4aj4yJQLBk4VLnRyYKVTNrMSNnvFNs0GSwD+ODBKEcaDaUe/X4jzyFn6fRQJQhyjxt9OW/2qOkMyAPeWyH7JpIwjqAUqIjRQZ9mFqlGI134jN5Avuy8/VRnmXQRBBtqa9PvP8INnTUNxWnw9Fv6xRt3l1vBwH5JVNVmV1UVavj8FyhTZuCKgMMKzm1adFeEyJghrB7+OmG+Zx/f+o+Vt4uhPZOO7/lRlvNc7xjqI1u9pMgYAGUM13qhoD6fmLKDt1gbzOiInA9GOe9YtZArHgZHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdBQhIv69I5AR6mgQiilaLCXpZ7TUc93goeWbS3FPqQ=;
 b=wBIqFuMgS5oCFDDSfL/XCM+raU8a2jpVZAuqv6oTxJpOy64Jakx08nL3JyoRrY5B+ciymKIGuTBZwcuDGIyjOuK3NYUXCI93iOMScw9Hutw1sa20N3a/7zAU0h6o9CV1r6hwbBC+q1mGk9RTpLzygFG1T+rmSvNDNatvY0aX7Q4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7523.namprd04.prod.outlook.com (2603:10b6:303:a8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.22; Sat, 9 Nov 2024 06:05:44 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8137.021; Sat, 9 Nov 2024
 06:05:44 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>
Subject: RE: [PATCH v3 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v3 1/2] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbL3WvpQA/mYZcmUibUopLvxMna7Kue5EQ
Date: Sat, 9 Nov 2024 06:05:44 +0000
Message-ID:
 <DM6PR04MB6575F8FA15D71505DFE39FFDFC5E2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241105112502.710427-1-avri.altman@wdc.com>
 <20241105112502.710427-2-avri.altman@wdc.com>
In-Reply-To: <20241105112502.710427-2-avri.altman@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB7523:EE_
x-ms-office365-filtering-correlation-id: edff3f0e-f099-47e2-3f56-08dd00848c17
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?6KLbTAQgxRLCJgWoVYtUkOq7QcFIPzr6JjUOZt2dIXTtoNrNoTU5/03HXCV1?=
 =?us-ascii?Q?Yj4dayN3HlA+PzSujX1mYD8dBpu5gmj3qqIYU9bAjs8WdbGmPXErqMP7ci6z?=
 =?us-ascii?Q?E4lBDhz8W52sFNLaVq5LwUXjeDjsaes3IbJGtCHAYqBdQJkQ5/OkrRqvpXDE?=
 =?us-ascii?Q?zytx+yGs4zLAuu1hgt+UhNQn9k/Y/x1iZ59/X2Gtj8yCkcUw4sqDzUdjFKco?=
 =?us-ascii?Q?tRSBn2jQOXzDp6yahsvj1/gkVPzwPoKD37uAs9C9J/7YN9fuOKQCwZq1ONvD?=
 =?us-ascii?Q?U6MD8Vo8CkCG8a9e4X60nONWtZBTniBWMwm54FEo80d/jjeNNvLCnpZ3yO0z?=
 =?us-ascii?Q?Wz4Xpkj+kyAHBTxNwiql/ATdtHPDj8xwxI61P6pswmkOWrCv9C0S0LpCutDT?=
 =?us-ascii?Q?y7rZMr29QP7CScuT2uCmwhVbstDLTrbbdKjLQ0T3s9ynvixcQG5Am6ocaMSp?=
 =?us-ascii?Q?JXRvCvuMHoQK1RRmyXJRZB+TPDpOo4HWk7OuyNAPzWDAH+Z35kZlGwaQhsgR?=
 =?us-ascii?Q?O06WF96xk4Ccg09usMWtJZgHU5uwr4vbbLJMwpf1By2gItrocvTw4GplHGPP?=
 =?us-ascii?Q?zHwFXEDLzBxxpy0of+xIQRIbpmyUGbrSZizlYBtOfbPPQuQHMtYyQQGvluYP?=
 =?us-ascii?Q?MU25P76v+EgLX+0h551dX8+43eVVWGN4vSc/bNhhEO7KyPywDd/pKOOi8S47?=
 =?us-ascii?Q?ml9n4G6bv2qX2OL0GSTa7RZ6CtTTNptQSbSl9/xHZriqLvkCiZSGeUAfG+WE?=
 =?us-ascii?Q?QSO7MpPyQyw8Ghwm1/z8Q0qGAg5xfYmka1kAJNlNlXdS2pgjDuZY1dvXYVk1?=
 =?us-ascii?Q?sdxqBvs5dite+6QamehFhfsw+UJpmnS6XqvEZnhcQv6plq3JSDuGrSL9RnvK?=
 =?us-ascii?Q?n6Go9+12/K6cbhV+/eh76Zh8T9DJYvEaJQ8lsrcnX+xCIMyBKhY8nrUVqXQr?=
 =?us-ascii?Q?jkLVHkc8y/r/2tdW4wC5Rbr3jx7E0vbCHBW5x8ZQJornH/IhrfFpWoCecU4K?=
 =?us-ascii?Q?g+UQIunDIVyJcwJlrFS+6VAM9jvmmo5tOfKcRG+t7xSJb70vHE3UbaDmZOp0?=
 =?us-ascii?Q?WHtwGKNNA4C+hbD23Lf/Fu8hb6LqXdMwdhbBcJzHMn3xW+rKhh8rsnVldYwe?=
 =?us-ascii?Q?qsAnI5gFYTjtn6ZbWNMVaiXltPyV/mBjSKNhzMzco74DZZSjOMv1OdB321E+?=
 =?us-ascii?Q?eu6bHhrF9mUGaZ8a1FF8ZXQSxk3HpDO5XXnc5PT7J7IEyPiUAz3DItRDoF9U?=
 =?us-ascii?Q?GMJerLB5pSiEHtp8St9Bne841KDjo+PhYcwVdjW51JVdbxJfFotjw5c0XGk2?=
 =?us-ascii?Q?GPa8aqGk8ccIrkUmJEr7tP1HdDwQoQOEjbrigNx4wJxe+FkSlapOWW2bbhQI?=
 =?us-ascii?Q?jb4nHX0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KmNpD8yVXHRKTGxhn09ILllBhWS3HJUEOZ1RbTjUsHtugaiYEYk1ZA1MYsNN?=
 =?us-ascii?Q?1IGgMc43pCRq/Dvsdh/TiR2GbnygKIQ5iLoCDOtxW/4Qvvjdad061U1XNulx?=
 =?us-ascii?Q?Dqlj2FMbDUTsUAFjossZ+v//ErbW8RoNGyT8NyGeweLO6VGYAxKbEx6Tq9QK?=
 =?us-ascii?Q?UuaZtgRUF+bIUvKA07ZdD3wvDeDfHfQcSi2k+Yix1J9YrJO+mg6sp2NvjAPu?=
 =?us-ascii?Q?VN4TkpfVJK8Uw+NWuqLfvrdJzwt1SttlDHKPyQt4Wp+/UXLBNS0BOOxJEP5V?=
 =?us-ascii?Q?aVSFA67P+sscaX1a6I8d2HyLClpGw0A56maH9BpRr7z8XBZn8FRSW0wEUFTY?=
 =?us-ascii?Q?sbG8hzMDLXaY9Q59auENc4/xIkUUGBvCURJf3d8gSI0khpIZ4GsNJLFyvkZb?=
 =?us-ascii?Q?gRjXpUiv+c85zAQSYsknqgHs5Fy+S8rwf3rcZFYnL/NmFDgippV+yDXHZd7b?=
 =?us-ascii?Q?vLRPVNDjHSMjjQNq2ap1gSPOaJu2IvgD7uqx0NpjOwaJAngg2fHk5yjMJqmI?=
 =?us-ascii?Q?mkSKN2GrRjikG+CeB/rXhuqBH7bqI8zu4NfSnmu4y9LbRyCQ8OEVhH4tAaz3?=
 =?us-ascii?Q?mczy0NI6v4oqBaaUBpeBOWJNZJk/f8s79wDuFwsrm+G8YZvbGkyYyzmf/3IW?=
 =?us-ascii?Q?Xm6H3M2OBaWoBV0EwWM7NXHiP6yXKrGRf9shMnE3QXDyVFsnwuNmW9bpRPZE?=
 =?us-ascii?Q?wbNSbfD4U3rIENRKoKRy2chXJEa2JAVc7gwXsfKsksqrKTKGUvll8vFPyLbY?=
 =?us-ascii?Q?jlD5eqQ4g2YDs+1bLWQZU2+a5IVF+YXNXZzH3DRxg31AQHS9ZfrIz42FVD1B?=
 =?us-ascii?Q?tCeSk4FAeyiD1Jx58gxmbs6f86F0S/10FVDpCOXEs4lRMx0TGjyoeuQQQodf?=
 =?us-ascii?Q?AlIaoDJQQi9D5RRd8IEckce5EHjX8ShCAV4mTPzQcZol8TNTX/nZjohTBtul?=
 =?us-ascii?Q?03PZpF7MDT3t7YcKPAyVbrDPCKpG1EbtplPV7gYcMO7dImETJvw5qoFOf4oK?=
 =?us-ascii?Q?CneYHR0i8veRHRZ7B19XJH+w5pBc4kRcFWc6Z+EYJQo5CcWKne9nDY9cuFB0?=
 =?us-ascii?Q?PPsz9GbWCN5ixsiK0Y7+EyoA3byd0/9XmMOp7ieg2LVxhIenahXUAR1TBZkg?=
 =?us-ascii?Q?DDNq0JVm/z06IR7H/B/px4VxnSASSMxAMioLBqeQtGKGWbzSMhmd9/bdv/37?=
 =?us-ascii?Q?lawe1dmBT302+8le+Mj+ESyMh6cn2IRKGNsvhGwmehDCIZqkBnNQaTbrPaVh?=
 =?us-ascii?Q?w4ZlqMy/+2cCpq214qrTnQ31qGoGYX0S3T4U5qg2ZTVTSqCo1kDHpAimZBJs?=
 =?us-ascii?Q?IG8g1qo6FGH0lp1xYzGEh+iuAuyV8LQLMqW1HiAN5kA+53RClvuKwF3STUt+?=
 =?us-ascii?Q?BQXWHUnXXHZyT1viTOHs+ZvG2ATkWvFsW5+P3qzzWjdk0gCp3ukJ+kBZxA3t?=
 =?us-ascii?Q?8dKgD4/VNvaSAHi1sKRCTp0p8xTtOELEsTwRlt41icre+7PtXIYHVTOpwC+G?=
 =?us-ascii?Q?8gEdLjHTjpALQ+WqlRS1dHzdPUK/3M3uiyB2UmvGuHPUrarSRuU2Rg/uQwiw?=
 =?us-ascii?Q?+m2/Em1wh8H2C/SgknlHBIKOOkAtYZPtBj3NLLaFLpZFmBtniD6xbvqAuGi4?=
 =?us-ascii?Q?j/EUOTaIHJckumZTRN1NxYZh4aEv7hVriwSY88osaO5V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0LjLhPACixPv6geUI0cAz+iM6JEqJz4h+zI/M2UKfKES9Fywx3HSxF7Ff6/3qO6wGaeUe9vqd6EO+n2xnMCZIA4A6rnZKBWSOFctQLUnmJE9PqK6QToHn5rGXUaKE0rcgHQ4+suzq2onMEPks9Z6bYr/zpa99MsxrNTzQSydHw1fzECKpQ1oZSudeCm3yjq3hg1Oe8ScirEWJXskTpAzdp9Ff5N+tCaDtyHwSC+k2YyVMEfWXh03v6Y9v+hSiqQmExiB6J1lDazT3L9pYcjRfLJpivpx2kjvVLj6McFB+ZWghHbXQ1uwTlqquoRgFeVebunLBFpeOqbH+3H3BHcscIHcQ/13Ub67Z0Y0TOqH9V/Oukzu0TwK/W6rLz1X6GrlQwYhZo0TCCsdygFIUV8EUr07u/cnYe9812FlfIA3Up17jYtAMf7npKidhr8oeiqJwRYJeEv9px0VeFITrcdNB+7VBBHVgb6wJhD2m2huHzFIQES6HUwI63j3OaLPKMB8mnHaSg1u46ZlKx4+4MnwBaeeUzjKvzrsRYcxBib/jBO6gAMlHrNEur9nRIb7bxBMTo3DXKC8/orN/nbhTHnJFLwoU/X7TlqH/ztqSDn4+VjgvivHNZl5LPOCw+wbclND
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edff3f0e-f099-47e2-3f56-08dd00848c17
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2024 06:05:44.2209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1UqLR1jSbFA1iHHibn7idLVGfhlBjqoLqfgQ9YSHKGeqZh4dsYy60S1XOV7ruF3WKQJGsz7JqKPg5jYqYbjC2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7523

A gentle ping.

Thanks,
Avri

> -----Original Message-----
> From: Avri Altman <avri.altman@wdc.com>
> Sent: Tuesday, November 5, 2024 1:25 PM
> To: Martin K . Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Bart Van As=
sche
> <bvanassche@acm.org>; Avri Altman <Avri.Altman@wdc.com>
> Subject: [PATCH v3 1/2] scsi: ufs: core: Introduce a new clock_gating loc=
k
>=20
> Introduce a new clock gating lock to serialize access to some of the cloc=
k gating
> members instead of the host_lock.
>=20
> While at it, simplify the code with the guard() macro and co for automati=
c
> cleanup of the new lock. There are some explicit
> spin_lock_irqsave/spin_unlock_irqrestore snaking instances I left behind
> because I couldn't make heads or tails of it.
>=20
> Additionally, move the trace_ufshcd_clk_gating() call from inside the reg=
ion
> protected by the lock as it doesn't needs protection.
>=20
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/ufs/core/ufshcd.c | 93 +++++++++++++++++----------------------
>  include/ufs/ufshcd.h      |  8 +++-
>  2 files changed, 46 insertions(+), 55 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> e338867bc96c..62c0e2323f50 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1811,19 +1811,17 @@ static void ufshcd_exit_clk_scaling(struct ufs_hb=
a
> *hba)  static void ufshcd_ungate_work(struct work_struct *work)  {
>  	int ret;
> -	unsigned long flags;
>  	struct ufs_hba *hba =3D container_of(work, struct ufs_hba,
>  			clk_gating.ungate_work);
>=20
>  	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
>=20
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	if (hba->clk_gating.state =3D=3D CLKS_ON) {
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> -		return;
> +	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
> +	{
> +		if (hba->clk_gating.state =3D=3D CLKS_ON)
> +			return;
>  	}
>=20
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	ufshcd_hba_vreg_set_hpm(hba);
>  	ufshcd_setup_clocks(hba, true);
>=20
> @@ -1858,7 +1856,7 @@ void ufshcd_hold(struct ufs_hba *hba)
>  	if (!ufshcd_is_clkgating_allowed(hba) ||
>  	    !hba->clk_gating.is_initialized)
>  		return;
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->clk_gating.lock, flags);
>  	hba->clk_gating.active_reqs++;
>=20
>  start:
> @@ -1874,11 +1872,11 @@ void ufshcd_hold(struct ufs_hba *hba)
>  		 */
>  		if (ufshcd_can_hibern8_during_gating(hba) &&
>  		    ufshcd_is_link_hibern8(hba)) {
> -			spin_unlock_irqrestore(hba->host->host_lock, flags);
> +			spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
>  			flush_result =3D flush_work(&hba-
> >clk_gating.ungate_work);
>  			if (hba->clk_gating.is_suspended && !flush_result)
>  				return;
> -			spin_lock_irqsave(hba->host->host_lock, flags);
> +			spin_lock_irqsave(&hba->clk_gating.lock, flags);
>  			goto start;
>  		}
>  		break;
> @@ -1907,17 +1905,17 @@ void ufshcd_hold(struct ufs_hba *hba)
>  		 */
>  		fallthrough;
>  	case REQ_CLKS_ON:
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
>  		flush_work(&hba->clk_gating.ungate_work);
>  		/* Make sure state is CLKS_ON before returning */
> -		spin_lock_irqsave(hba->host->host_lock, flags);
> +		spin_lock_irqsave(&hba->clk_gating.lock, flags);
>  		goto start;
>  	default:
>  		dev_err(hba->dev, "%s: clk gating is in invalid state %d\n",
>  				__func__, hba->clk_gating.state);
>  		break;
>  	}
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_hold);
>=20
> @@ -1925,29 +1923,28 @@ static void ufshcd_gate_work(struct work_struct
> *work)  {
>  	struct ufs_hba *hba =3D container_of(work, struct ufs_hba,
>  			clk_gating.gate_work.work);
> -	unsigned long flags;
>  	int ret;
>=20
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	/*
> -	 * In case you are here to cancel this work the gating state
> -	 * would be marked as REQ_CLKS_ON. In this case save time by
> -	 * skipping the gating work and exit after changing the clock
> -	 * state to CLKS_ON.
> -	 */
> -	if (hba->clk_gating.is_suspended ||
> -		(hba->clk_gating.state !=3D REQ_CLKS_OFF)) {
> -		hba->clk_gating.state =3D CLKS_ON;
> -		trace_ufshcd_clk_gating(dev_name(hba->dev),
> -					hba->clk_gating.state);
> -		goto rel_lock;
> +	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
> +	{
> +		/*
> +		 * In case you are here to cancel this work the gating state
> +		 * would be marked as REQ_CLKS_ON. In this case save time by
> +		 * skipping the gating work and exit after changing the clock
> +		 * state to CLKS_ON.
> +		 */
> +		if (hba->clk_gating.is_suspended ||
> +		    hba->clk_gating.state !=3D REQ_CLKS_OFF) {
> +			hba->clk_gating.state =3D CLKS_ON;
> +			trace_ufshcd_clk_gating(dev_name(hba->dev),
> +						hba->clk_gating.state);
> +			return;
> +		}
> +		if (ufshcd_is_ufs_dev_busy(hba) ||
> +		    hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL)
> +			return;
>  	}
>=20
> -	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state !=3D
> UFSHCD_STATE_OPERATIONAL)
> -		goto rel_lock;
> -
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
>  	/* put the link into hibern8 mode before turning off clocks */
>  	if (ufshcd_can_hibern8_during_gating(hba)) {
>  		ret =3D ufshcd_uic_hibern8_enter(hba);
> @@ -1957,7 +1954,7 @@ static void ufshcd_gate_work(struct work_struct
> *work)
>  					__func__, ret);
>  			trace_ufshcd_clk_gating(dev_name(hba->dev),
>  						hba->clk_gating.state);
> -			goto out;
> +			return;
>  		}
>  		ufshcd_set_link_hibern8(hba);
>  	}
> @@ -1977,16 +1974,12 @@ static void ufshcd_gate_work(struct work_struct
> *work)
>  	 * prevent from doing cancel work multiple times when there are
>  	 * new requests arriving before the current cancel work is done.
>  	 */
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	guard(spinlock_irqsave)(&hba->clk_gating.lock);
>  	if (hba->clk_gating.state =3D=3D REQ_CLKS_OFF) {
>  		hba->clk_gating.state =3D CLKS_OFF;
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>  					hba->clk_gating.state);
>  	}
> -rel_lock:
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -out:
> -	return;
>  }
>=20
>  /* host lock must be held before calling this variant */ @@ -2013,11 +20=
06,8
> @@ static void __ufshcd_release(struct ufs_hba *hba)
>=20
>  void ufshcd_release(struct ufs_hba *hba)  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	guard(spinlock_irqsave)(&hba->clk_gating.lock);
>  	__ufshcd_release(hba);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_release);
>=20
> @@ -2032,11 +2022,9 @@ static ssize_t ufshcd_clkgate_delay_show(struct
> device *dev,  void ufshcd_clkgate_delay_set(struct device *dev, unsigned =
long
> value)  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	unsigned long flags;
>=20
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	guard(spinlock_irqsave)(&hba->clk_gating.lock);
>  	hba->clk_gating.delay_ms =3D value;
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
>=20
> @@ -2064,7 +2052,6 @@ static ssize_t ufshcd_clkgate_enable_store(struct
> device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	unsigned long flags;
>  	u32 value;
>=20
>  	if (kstrtou32(buf, 0, &value))
> @@ -2072,9 +2059,10 @@ static ssize_t ufshcd_clkgate_enable_store(struct
> device *dev,
>=20
>  	value =3D !!value;
>=20
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	guard(spinlock_irqsave)(&hba->clk_gating.lock);
> +
>  	if (value =3D=3D hba->clk_gating.is_enabled)
> -		goto out;
> +		return count;
>=20
>  	if (value)
>  		__ufshcd_release(hba);
> @@ -2082,8 +2070,7 @@ static ssize_t ufshcd_clkgate_enable_store(struct
> device *dev,
>  		hba->clk_gating.active_reqs++;
>=20
>  	hba->clk_gating.is_enabled =3D value;
> -out:
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
>  	return count;
>  }
>=20
> @@ -2125,6 +2112,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba
> *hba)
>  	INIT_DELAYED_WORK(&hba->clk_gating.gate_work,
> ufshcd_gate_work);
>  	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
>=20
> +	spin_lock_init(&hba->clk_gating.lock);
> +
>  	hba->clk_gating.clk_gating_workq =3D alloc_ordered_workqueue(
>  		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
>  		hba->host->host_no);
> @@ -9112,7 +9101,6 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba,
> bool on)
>  	int ret =3D 0;
>  	struct ufs_clk_info *clki;
>  	struct list_head *head =3D &hba->clk_list_head;
> -	unsigned long flags;
>  	ktime_t start =3D ktime_get();
>  	bool clk_state_changed =3D false;
>=20
> @@ -9163,11 +9151,10 @@ static int ufshcd_setup_clocks(struct ufs_hba *hb=
a,
> bool on)
>  				clk_disable_unprepare(clki->clk);
>  		}
>  	} else if (!ret && on) {
> -		spin_lock_irqsave(hba->host->host_lock, flags);
> -		hba->clk_gating.state =3D CLKS_ON;
> +		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
> +			hba->clk_gating.state =3D CLKS_ON;
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>  					hba->clk_gating.state);
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	}
>=20
>  	if (clk_state_changed)
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> d7aca9e61684..8f9997b0dbf9 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -403,6 +403,8 @@ enum clk_gating_state {
>   * delay_ms
>   * @ungate_work: worker to turn on clocks that will be used in case of
>   * interrupt context
> + * @clk_gating_workq: workqueue for clock gating work.
> + * @lock: serialize access to some struct ufs_clk_gating members
>   * @state: the current clocks state
>   * @delay_ms: gating delay in ms
>   * @is_suspended: clk gating is suspended when set to 1 which can be use=
d
> @@ -413,11 +415,14 @@ enum clk_gating_state {
>   * @is_initialized: Indicates whether clock gating is initialized or not
>   * @active_reqs: number of requests that are pending and should be waite=
d for
>   * completion before gating clocks.
> - * @clk_gating_workq: workqueue for clock gating work.
>   */
>  struct ufs_clk_gating {
>  	struct delayed_work gate_work;
>  	struct work_struct ungate_work;
> +	struct workqueue_struct *clk_gating_workq;
> +
> +	spinlock_t lock;
> +
>  	enum clk_gating_state state;
>  	unsigned long delay_ms;
>  	bool is_suspended;
> @@ -426,7 +431,6 @@ struct ufs_clk_gating {
>  	bool is_enabled;
>  	bool is_initialized;
>  	int active_reqs;
> -	struct workqueue_struct *clk_gating_workq;
>  };
>=20
>  /**
> --
> 2.25.1

