Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB6A13C9D9;
	Tue, 10 Sep 2024 04:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725941082; cv=fail; b=fqqEMiq16ecBV8S/QJ0KDhVlVGHRFLy3e3p7xrYoihS5THYVJfgui1l4z39gadzT2EEPF8VjjRNu7DROCBQu5r8jTs3em0iegYpeTEpBL1qPQOZKmsE4s+mAEKFZ8jfo7Nunu7sXgiQf3Cb7INW+HzLHw08POJGomavKTPP1xM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725941082; c=relaxed/simple;
	bh=W5qG4vS1Gq+VCYG8bN2OESohTbp5r9wLirbbL3JY7eg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jn/1u3cNZCl9Oz2VszAcX8MCtn/mLdO6ro+a9QPvdvY7G0SQN7Jgq3dRc3hQDmTXXVd3MdmnWynVeb5H6Ecmz2bAxHqeIg2I4G/8GT8bsKvE4+fXSQ8HJL3CZZyYlRqIKGqUo2Kma4RbMycVznMRKDmv8jAxSjeDnZ+ZnAyQi1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eNxkneJO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fjC0NTkh; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eNxkneJO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fjC0NTkh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1725941080; x=1757477080;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W5qG4vS1Gq+VCYG8bN2OESohTbp5r9wLirbbL3JY7eg=;
  b=eNxkneJOqyjlY9VbPUfCYZ9eYT3ZTi3eShEd1WvbjYLwLY86RYAoxecW
   11OcYzEkx8ImynZWNq7RUT8LVfQclPpqSah+9Qx/qEwkrA8UpzZMgVSCh
   Z73Yh4gofszo4sAXq0vQX2VzCrov5vcWv6XG+Y692pt+2ZOsRsXgjeHwk
   +buOb8VLEJrHAp1/3Uhyh3WEZPLWMz2wRKib3is9xk9CKJ0gUcre2JgBu
   gtVub+FnhlD/p/PO9X3TbUaMZjnfXwQCE1+alQXsKeMgeiwj9v6+G5upa
   riptzk2uala63lEP9pSiKKg0lni3mUSLoaf8mXU67BxeJLASvVRpZM9Ba
   w==;
X-CSE-ConnectionGUID: RODyCOaFSx2iFcOCCQggDw==
X-CSE-MsgGUID: 1kHbpTCLQWG0gGoNoUF2nA==
X-IronPort-AV: E=Sophos;i="6.10,216,1719849600"; 
   d="scan'208";a="26318614"
Received: from mail-northcentralusazlp17010000.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.0])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2024 12:04:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8Bs9NYQ+66gV6L7EsDmTQU2CxSTFg7mkyPOid0uUtvvke1DHNql1lftfQTy32UvoT55eRZDDF4UiBD9JnbA8p7GDDBusIsSavyO2lKTTmyAwAMEYWD+iU9t9S+9p4hMa/gkOoZSLaqlIW0nPK9GAXonaN6cRDs/M7nXWEd1sU/EFKf64i5eQKz4GJUCJJurQ+qReCTnG9OSM7NYP2GwF1FeRx36PQEwFPpmfI7i7dygTZX3Oi96sG72py5X4VnFzixxHVpd3BzY7V91VkRwPbAa7xuCQzb0FFQ7ag6Ow8/DTIoAbaSig2aKsroWzXVWEBWbnPMeV6NeRp4lRZeBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5qG4vS1Gq+VCYG8bN2OESohTbp5r9wLirbbL3JY7eg=;
 b=qESmD1ha5rmabigaRqIVCLMH/QtoBmA2FSIJAVedxk86xPo7seGqiUvhA/8JUpTwncybwrYDKiI4pfAKnKfytZNxWp2k7ZISD3Agm8IVMjOuLjJTGQAxNVucAMdgEGJdZ1J5tgKNnyfgJa0jfP0fRpmJspKqQG6KkpM2IcyDmZGoInzG4cSPtDmfoz/CI/ZSpupPTam4ekgGbsvjE13wwnhAYCaoOBy2zrx9Cn4YbP9Su42DTAfnPOvWMGPSu1ciisLDcNQpn8zRBHdyGpLzGVDoGnJ8wKvWfXj+nsLyJ/poLe2ybg/LBZT0wBcj/r9W6bWt2vCSQujVaN6nZE+xPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5qG4vS1Gq+VCYG8bN2OESohTbp5r9wLirbbL3JY7eg=;
 b=fjC0NTkh1wqi9UAnCfr1p8GqSabh4kKhIX1nrpbRkuregzHWfu2SzPHLcLiArHDAQHrmMou86W1GOabtMbE1TPj2oKD1Ww7Ng3NBruKvTvTPbwdsKWZ1fh9LgkQPDS91VIKRGFr3FfCr5iw9P0LYPxx/dNG1Z7Qoz0l9j6pjsGA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB8347.namprd04.prod.outlook.com (2603:10b6:303:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Tue, 10 Sep
 2024 04:04:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 04:04:32 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
Thread-Topic: [PATCH] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
Thread-Index: AQHbAp7ZgRCTR8PKKUuUU0N0OoiZW7JPq/YAgAC7y8A=
Date: Tue, 10 Sep 2024 04:04:32 +0000
Message-ID:
 <DM6PR04MB6575D2D3010999D2A33EDDC9FC9A2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240909095646.3756308-1-avri.altman@wdc.com>
 <de761b4d-bf11-48a4-be2b-6312d5f383c6@acm.org>
In-Reply-To: <de761b4d-bf11-48a4-be2b-6312d5f383c6@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB8347:EE_
x-ms-office365-filtering-correlation-id: 87615cec-ec3e-4cd1-fee7-08dcd14dacd6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OWJBbER3TTZWVWhzekZLMy9nSVNGOEs3N2pxU0xaakZvb1IxdU1ScXoyQTdi?=
 =?utf-8?B?UzFqMElXVFVzTVgzbzM3ZEJCVHhDUzF3NkJVQXloZlE5QTFndmJubDVWTUhk?=
 =?utf-8?B?NEdnYXVJY2draDIwWk15N2NrSU5JTklrRkJUTkRnLy8xZ2ZKbDU1SnpsMGtt?=
 =?utf-8?B?d0NLTy9iajZwVWxZQklBYTZFRnZNNzYyWXIwZ1JyWUJnQWMvUzhzbTFlU0p6?=
 =?utf-8?B?UmJ0QUM2MlBuK1E0cjhNUCtUWkxSa211K0NwbE9CZ0JOZDdjd3R2d2Y3RE5z?=
 =?utf-8?B?OC96VTBwKzVwR2NMQmlnRGkwdW1VOGErWmp0K2RyVTJwMUFWeHVvdElOUHkx?=
 =?utf-8?B?eGZQUC9mRnpPenhKOXphT0c0OEdCZmR1UkhQeVpOOXBjK0Iyb2NRVFllb1V0?=
 =?utf-8?B?a3hXOGFoWCs1SkV1WlJKdktnS0FqYSsyQ0VreHhqU2hUL2grcjdHdzhGWVZl?=
 =?utf-8?B?SER3Z1phNXA4UCtwTTBlTGhMbm4xZzdDVzdsZ0h1VHdUVWFTVXVhdHdORWpU?=
 =?utf-8?B?eHVudVNXL094Z2VqZjJtQ2pZRkFZQkZDdjQ3ZXpYWVBsZ205MG5IUCtVL2RK?=
 =?utf-8?B?M0JnUUFPbU9QdGZDUmtLcURHcXYxVFNRMUVKOXVzMEhKMm5TUk1iWk9oRzZG?=
 =?utf-8?B?WFJnaUlaY2FLamRyWUJYeGl3SDdGcDF4WUtEWDBpak4zUVdseElDRk5jMisz?=
 =?utf-8?B?Q1BTTTRVNlBtV0lvVEhiRjEyN1B0eVkrb1NOTnFQSG40L1k2YVlSaXhFUzZ4?=
 =?utf-8?B?V3paZk9BZzdac21EbEZrZHBva2dzWjBiUENuRlJaRE1jc0pqMEpUYS9FdVpC?=
 =?utf-8?B?NnJ5RjhGaFNIOEJXMnBMcklINFkyUFJoUnRJRFpkNU5HVWxlQURoTkp5ZzRr?=
 =?utf-8?B?cCthMkIycktVbnhTWEZKZ3NCVGNtTHRuSFpmODBoTWo3enhvVkp4ekdyd2tU?=
 =?utf-8?B?bTJuckdhRW9CZlhYZ1A5Z2JXaDdxcTJFUGNaUkJBTHRPM0xXSkY1TGorWjB3?=
 =?utf-8?B?aGZSUTd1ZUZxaWtVZUhZVExKa1A3U3I3d3BqTnh2RUFSVFdpY2JqbFdnVGl5?=
 =?utf-8?B?UlZ1UUR4RVRjbVRONHdTWlBhT0crUjgvem1jeVVFU0xDWlowSzZQZzEvYVFt?=
 =?utf-8?B?eFhVa2h1a2FrQWcraCtRZTBxNThTdTZWdXdDSFc1dStPK1JHU0pJcnNtR0xF?=
 =?utf-8?B?TS9HUXZqWjdNREI1NmdPeDZ2WTlSakpITnFxK01RSGIzSlR3SnduM1lmS21r?=
 =?utf-8?B?ZFpLT2wzWGJkWDdIOURIYktpT2hDbUw3Z2hnZjdqcGNDZUc4SFNPWHdKTWYv?=
 =?utf-8?B?R0x4SDVTYjRjeHR6SUFkQXdtdVpsTzdpa2xMem9OMndsM3dheGFhblpYU0hx?=
 =?utf-8?B?TnpqcGZCQnRkTzdOUExXOFVSSkQ0N1ZEbXMrOGJTOW5POSt1VEJiWkZ0U1RN?=
 =?utf-8?B?bWpQaWV0eXpBYURLaW10K3J1VzVhdmpDdDUxSTFpWXZmVmcwbDI2RktpZ3ZE?=
 =?utf-8?B?MDhHazdVTzhBY21uZkhoOE5kUzBvSVFuVk9PTjIrcDJPUlk0VmJCbG4yMzZR?=
 =?utf-8?B?M2lZQ0VFdEZpaUdya1l1L0hLbTRGT0NxQ3pnSkNVRHhBNmF0WlMvZUtwRHZx?=
 =?utf-8?B?WEdkRWtTNjRFUytBbWM5a2E2UlpEVkc2bGlSeitncmRqRll3MmZYM3BIUlg2?=
 =?utf-8?B?VlljcldJVVBtQ3FrZy9vUkhpREtzd2hYMjNOVDB0Qk5pWWxOaXlkTjJBaGF5?=
 =?utf-8?B?M3VBUHJsQXN0cndkeEE5NlNVOTNIMU53UFRZQWFPR3J6c2RVZ1p0VFVRZGh3?=
 =?utf-8?B?b1BCWEtGM3NTVitGQkhxWDM5cytVWVZ6WmdjdE9oOVh1N2dHS2NBVXk4MDVm?=
 =?utf-8?B?c1BjRTJpdU95ZElDYWQ3Y2U3aVRUK1RHQTJHYjBXa05NcFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a1V5RVVTRXExN0V1VVlkRXZXbzMyNjd2SUZrdTVoc3V2N3F5QzQ3QlRUTWhP?=
 =?utf-8?B?MVFWYnNDaVpHdE5nOEZXVWhEczVoOE9WTklJKzZ2dnJOSHd5R1o5R25lNi9Z?=
 =?utf-8?B?OU9kY25Td3ZiL3BwYjZiTFBkaURhdWpzSHh4TkdYK0QvTkJLNGZISXVidVR5?=
 =?utf-8?B?ZmNkZXBMR0xXZlg0emtTNS9tbnV2bUJvZzBBODI2SkVWOXFRZjU4QWFiT0sy?=
 =?utf-8?B?SllPVG5laDcrT0w1dXo3TzFWWW9uWm5RZUxta0RpUGZ6Z044dXVSclBKMDIw?=
 =?utf-8?B?T1NDT3YzdUtBTDd4ZEZHY1JZSHpRUUI1YmRBVlpzVFlwOHl6d0w5VVR5empB?=
 =?utf-8?B?QlhmNXhvVDdWd2JQTy9PMEU0QytKUHV4bUE5ZmF5bkhFQ01abUlaUWRjdjBy?=
 =?utf-8?B?eklhRlBkOHlBSjBvMDFlR1gvMUtHNllBUmRVdGE0U1FSOHU2d3JGay9wbUxa?=
 =?utf-8?B?MU9RNmZJWit5ajhlY2JwSVI1QXc1VlcxOTJ5QWJicW5rRW95NE9iTGlCUFRm?=
 =?utf-8?B?cUZWSWpzTUgyVU4yTlZpbVgrUVBoQ3lTRldjWm5sb2tPY1gwbHl4UXFXb3hs?=
 =?utf-8?B?UUplem4vcGF5b1VTaDJFV3YyWitoeC9MT1ZBOFpCT1RYbmNWRml1c3djZXpl?=
 =?utf-8?B?dS93Q3c4eEg3dWwvNWlDYmJ2MzhPeHBjZnQ5bExmS0xUMWtXMXhhN0RrZ3Jy?=
 =?utf-8?B?azBaSmNWTE5KeTJxbTlTOG9HMmZSRXdManowUTZiaVFqdjNIKzR5QSs3eDV6?=
 =?utf-8?B?YjZmTm1iNCtsUFBjWk1nV3hadi9qamRtelBid3FKZ1NQd2xXaHFCTS9BcW1V?=
 =?utf-8?B?TlBCdTdSZllHVGRNVVp5ZU8ycEJvOFN0OFZibS9QUTMvNWZWb1VtM2x1WmNw?=
 =?utf-8?B?MHRXV0k2cjRrSktJZ1Z6OUxVdkRqQW5xaTczUlBaUnRzeERWb0laOVRRWUZB?=
 =?utf-8?B?Z21sUWZYeHd2QUFIU0tqcG1Gd3M3ME5LMytad081T1NCZGptNFRzYXlGNWF1?=
 =?utf-8?B?QUMyeERRUFpNSjg1Z1hPTU1oeithM0p2U1lNTVQydXRYb1FXaGoxV3pHZnpt?=
 =?utf-8?B?KzQ4WEtuN0MxalpIbkJXMUFPeDNPbDBXNlZaSTZ1VW9kNUQvdjBuMTkxaVFH?=
 =?utf-8?B?ZnN3QnVJcTZXTC9yVUZ2bmtyVk54Y2FSVE1CMjJhZkhFbnd0TU1IQndjS25T?=
 =?utf-8?B?UkZzTzJCY2IxNHcwOVhZV3ZiWDFVWVhHbWVYV1pHc1RRTVFya3pWbzMrZS9u?=
 =?utf-8?B?ZXhJejFRQis5Vmp2bmh4RVUyb0xsMDhSM29rNkVjZDVWVmJhcTdzSFR3L0hl?=
 =?utf-8?B?M3NGTUQ0QlNRdjRhS29Halp6ZjJ6L25LWXM4N2U5NVVpNUROcFRQSHYweE95?=
 =?utf-8?B?Z3dqYWtJbGhYMzdYUzdzaXA1QzZoWHVJTmlndFc4SytWRVBSblExeUNvbHd4?=
 =?utf-8?B?ZG5GcTNuejVPVUFIMUJHM1pGamJZUnpNYVhjRVZSMTFOa1B2WTNrTkFmRGtx?=
 =?utf-8?B?WnB4RzhtUkI5c1VyQlFxZlBoMHBUaEpVMkJsOUFTUXpPaGF1amVjQ3VXbGk4?=
 =?utf-8?B?VjVmT2J5d3FKZThFUGc1Uy9CNFBjTWc0bzN2QTFpUzlaRGJSN3pyMW1VdFBK?=
 =?utf-8?B?bjI4V3hicEhGQi9hdlIzUFA1TGdBZW5BSGhXbndrOWdsRXc2TExwRUpUNnBE?=
 =?utf-8?B?ZGg3WFRIRndiMjJkRTQvMTBwSVJQKzJBSmwzaTYvR25pM2wvRlN4UnVqbEVY?=
 =?utf-8?B?V3djTWY1M1ZDNHhpdFJ3eVRUQjBhQkNTZGFPSy9OVjEvSjdUSVlrOGswOHM2?=
 =?utf-8?B?dDBaMGVqM3hTZDFTSXZIMUt1MWlZWHVhT2RpaE5pdUZMbHVlOWJ5SnVLalBp?=
 =?utf-8?B?YW5NZitHTjBLU3dlbVg0RFBzNUNTeGNrQ3FXaFRJaEZobzhKNnJYd3REOWhu?=
 =?utf-8?B?REtIMGk3bU9FQ0QzVkxJT3A3QXhJM3Vja1UyYWx5bm90SXludWtUY2dlUHM0?=
 =?utf-8?B?M3lGRkZnZ3NWSE53blNYQXREa2lEM21Zc1g5TjNad3dxWHFMYWdTMDVpbCsv?=
 =?utf-8?B?OXJ4NUNxb2kwZk5McUg1WnBuK05ydU5paUVQajdUcVRNZjJPUjRlb1gyRVhL?=
 =?utf-8?Q?8zwlv3jXiLCpqUlbur895rQyA?=
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
	07hUaeh2AJGSOt0vVGZQ7B/jmqOoyVHwC0vFyUef9ufta2dMAD+XEXrIOzFxi50oGHZ4fd2DO1K5RpFfSEztlLJDO5IgWoxaBoQZ8CKIrKBYIHqFNqE6SRUuHCpDmGZ08uEe5AiA8ipGCdwU+VTwypf+cGYRHnF30qW/MLUwDRHCVGN3KRtIVO9TnmJpbo6GgMce80BnwYxPidW3uIoqkV6WJJBXL8kMu8P3xwUOOLNHU0Y0wNFkQXEJGNboslQ8PWXMjxvEqm6IQff76dpm5h/B+LxdAJwysTaBN3SZkflKxoAes2EM+9SD+MpUyKMn4CvW/PNqsT4sx5tqnkWh8YDfuoydJRFjztMONp0TT9O1z2ooHSmkVSevOGpPM6erov8oh4LaUQec42yMjjkDCAU/gyg3qOoFZqo3RJjexlw4JmNOjDoW2qzyq33sAAMVYe8Ab/3rwG2OnTI7ub5nDS7q8i8mDEakhV6/exocyxibnHJ8SPZ/24J6tumLxDRneXvsWhg5C+LU7z8qtArOKYJsGMBO3HzHQtSpZi/56vZE2nmO/lNhUQm2IE0ukt95kaRfwoZUlb/XLQLzt1f3ptpLGhXyuR6DA0uICpkfcP3lXJVIAh8Fbs+aYbLYC0gu
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87615cec-ec3e-4cd1-fee7-08dcd14dacd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 04:04:32.1986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qes2x0UKQvkHGqeNWmoEsd+MzLP8wZTqQ8GVM6AbtpSRM0Ed4oWNQBMEYCI4eDGOV/l7ODfUhobF+U38++Mzag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8347

PiBPbiA5LzkvMjQgMjo1NiBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gUmVwbGFjZSBtYW51
YWwgb2Zmc2V0IGNhbGN1bGF0aW9ucyBmb3IgcmVzcG9uc2VfdXBpdSBhbmQgcHJkX3RhYmxlIGlu
DQo+ID4gdWZzaGNkX2luaXRfbHJiKCkgd2l0aCBwcmUtY2FsY3VsYXRlZCBvZmZzZXRzIGFscmVh
ZHkgc3RvcmVkIGluIHRoZQ0KPiA+IHV0cF90cmFuc2Zlcl9yZXFfZGVzYyBzdHJ1Y3R1cmUuIFRo
ZSBwcmUtY2FsY3VsYXRlZCBvZmZzZXRzIGFyZSBzZXQNCj4gPiBkaWZmZXJlbnRseSBpbiB1ZnNo
Y2RfaG9zdF9tZW1vcnlfY29uZmlndXJlKCkgYmFzZWQgb24gdGhlDQo+ID4gVUZTSENEX1FVSVJL
X1BSRFRfQllURV9HUkFOIHF1aXJrLCBlbnN1cmluZyBjb3JyZWN0IGFsaWdubWVudCBhbmQNCj4g
PiBhY2Nlc3MuDQo+IA0KPiBQbGVhc2UgYWRkIEZpeGVzOiBhbmQgQ2M6IHN0YWJsZSB0YWdzLg0K
RG9uZS4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQo=
