Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAA538B7CD;
	Sun,  4 Oct 2026 08:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791102185; cv=fail; b=U21Ou9zoaNaUwD2ZrVr8PbDbfaOZaRpGHaceeQ3rHUIy5BLE32OtBRFXnrsFj207EATu3v65NP5EdVgaEWVG+8qxgZzrucLDXaW6Htd8hSrCety1Oy20TgU4N357NO06JrwzqcuBwBe6UMY83IA3Y1CSborDQh+eVrh2KBQpB/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791102185; c=relaxed/simple;
	bh=ItmcC6Ay9ndYNeQJJtp6Wmrdd+wvLcaSkvCeRVEPqXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bkzrtEhu+D3zfOEtss1lUUgEQ5MyehploQZg67Jf6+ivkQ90UJc6d5aDRgVSZVInY7ZTD/HT2T/eqhRYqQu0Kpe4DtFAXnwU+3YZDf5kqfM/ldTl04hjbKHIZbV9ZxitwXnJBmBZS8UNZvINXQyR1tZtr8LqBnVO8zZwqtmZ2wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=AwbA3zRp; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="AwbA3zRp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1791102184; x=1822638184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ItmcC6Ay9ndYNeQJJtp6Wmrdd+wvLcaSkvCeRVEPqXU=;
  b=AwbA3zRprsmvxtXMm9JZA89SFgkvEV8ebCRMhEr0w+XmGe5R+PDCYt4t
   HJJ0eydgeFZA4a2I+Jz2rVnK0eFvxC8AEAJT9vM/+zwtvc4OtSMrk7MyY
   XmcH8x3R/L6mFiPc8QRb/k4bST80OBq5Ed0El6WzODpIU2woYptQX/AnO
   2lW+J70DGFVCc0cdNZqS7MMU9GTQdTYgb5HpHpQXMGJtMKHwdlTZAxUJB
   gfykEsrakYiBAk3IMqa4fX+DGrNDBZsYf+0QeWA7OfrxdJqd6sqvWgF+j
   A8aM+f8aIg9ZqFEjIDB3ES4yCuBxD7tpU35lmai4ErPivJDOEgGA4oTQg
   g==;
X-CSE-ConnectionGUID: FancgUarQraI85MPf2QbNw==
X-CSE-MsgGUID: 0W+VbwJTTQ+DXoCdNe3ijg==
X-IronPort-RemoteIP: 52.101.52.99
X-IronPort-MID: 31481075
X-IronPort-Reputation: None
X-IronPort-Listener: OutgoingMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
Received: from mail-eastusazon11021099.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.99])
  by ob1.hc6817-7.iphmx.com with ESMTP; 04 Oct 2026 01:21:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9A9ec0tAEy8pbbPLr690KVUt9UFwx7iWoSE7x04PARfwRs9WW6BJd6THdNzOrsw67KCZvTIrQMPkHm0aeFNtTuGeEaS194VCPKdIFy/pa/lWYPCZPaw7KPGDejtueVoVzXY+ijZdgHUTDTI7Hoo66p9pCbsmWnucONnxMJCR7/U7qlskMewY4KOYJEeh4dDR99Nb20DN/Mk8p8DL/PGut+QGGQ8z/f74oJ2le8Ihu/uadoqupn/GsL7k05/dQXd/TnQWHaay5iykH9b0aT1qfM/m9PJ8CMT35bMiWt6KcfE391txMH8dxlZzwJV2Gca95tdLnBFfmwH+Wyx791xVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItmcC6Ay9ndYNeQJJtp6Wmrdd+wvLcaSkvCeRVEPqXU=;
 b=l57Ck0DMeXfunKbGQGFHpRuao2agn/p1W655aBchipv0FjHBVJJICy3FY8PgU5r4dDp3Xh06EJaKqVgIxTwQzLFnphdWQ1ToOpNMAl9wESeeaG5oRFpaameaqLrrj71r2x9bsWCvWIsepU/VbPEwORfDKRwSFcX91d8GKn4r9bLGdLFi8Zf0e/YThC8uvpGv2A5bQNexa0l3DwEgBQ9jTTm6ElmwjztNDcZTh2mRZ9pch+1BODg40Mj2ZKlmVSae7BM31fgSvdWVdjDsaYmmMOO0KVkXenS0Tt4GaN6rrswHsXopyEwyh7VMGzDkB6SQiYOy7s1mDATz1VyaCLw2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from BL3PR16MB4473.namprd16.prod.outlook.com (2603:10b6:208:344::6)
 by LV8PR16MB6400.namprd16.prod.outlook.com (2603:10b6:408:22c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 08:21:54 +0000
Received: from BL3PR16MB4473.namprd16.prod.outlook.com
 ([fe80::f768:136d:184a:ebb6]) by BL3PR16MB4473.namprd16.prod.outlook.com
 ([fe80::f768:136d:184a:ebb6%6]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 08:21:54 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Stanley Jhu <stanleyjhu@google.com>, Bart Van Assche <bvanassche@acm.org>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E . J . Bottomley"
	<James.Bottomley@hansenpartnership.com>, Bean Huo <beanhuo@iokpp.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
Thread-Topic: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
Thread-Index: AQHdUOP5btbY7IsP8kidmN0lGPhABLbqQwMAgAACzACAAsrBIA==
Date: Sun, 4 Oct 2026 08:21:54 +0000
Message-ID:
 <BL3PR16MB4473EF5053283779F18B4161E5972@BL3PR16MB4473.namprd16.prod.outlook.com>
References: <20260930135947.2339918-1-stanleyjhu@google.com>
 <2fbff86c-f276-4e46-b7d3-549461706d37@acm.org>
 <20261002134158.2844652-1-stanleyjhu@google.com>
In-Reply-To: <20261002134158.2844652-1-stanleyjhu@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL3PR16MB4473:EE_|LV8PR16MB6400:EE_
x-ms-office365-filtering-correlation-id: 427383f8-f418-451d-e60d-08df21f08c8a
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|23010399003|38070700021|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003|55112099003;
x-microsoft-antispam-message-info:
 SRrDyC9YBIBMYcWwcpllA6XbMMnpg5L2nkZbo+kcRZV196ZJPXbVQIIpWAwgfBaLCWjTw+DWKYgGHws6ciKYwnRH37UriBXFXW3i6X442G8Pkpk0URsoyvxE8Efz5OZb3u/ot5CMyC4xfj6I+zHIh7S94suTAqqQuouhcnZ/qn1VckWeJdXbsNGH5DUyzV8cKxVe3esE6AtCIUeberfh/BzcDVon/oBQ1SyPfW3AKJ3fjL4IIIYvOtQyew69hmkoVa0nYmazVpf6zloDhD/dtP87EjtunPS6XYYriRto42y+ve76IInRPnUJoekwLHVD5x/ULq+tjLNBLNcC1yfTJJfWwUzEFwMEcICQGnZ54ZV6ITgiGblFv6OZarDVuw2zYwLBK33gFBkN5j/zUcaARfGkVk9F05HdruqEEZX+DJ98ZGkqwYDWKgOfG7kSDFNEF2khTRAhtmFXUkRm1oKBTc21BgdtzDQjG7NP//iPD2t4fNfPngn5Jqi8jjJ7bahIkzgXPaVgWlAHgYtPMdSFXsHTlz+DrUGoWJ45cnApqNWaI93BjMtGQRc02ZAj2KIxEv3n2xcKDpULNZqadjGmGRiyd4F+K1l0O2nd2eyyuFzqDV1UOncVqzOkVhFartQARM+r/DQD725b6wH+LyqxleXlU1wHwDSNHrXJniEvozjajZSqoZ/7u534zHXS5Pms3lWTVYlwawlWwwnEs8NHQ8pgkBsQ5BpjBTzRgg6dwXQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR16MB4473.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(23010399003)(38070700021)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(55112099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dlY1ZnAzbjZEOU9mVWhQZzNOeHhvU1ZSUFc4enZ6aVpnSkVQRzhDY0ErSTdO?=
 =?utf-8?B?SkovT2EvOTZoQW1KMmN3VlFNTmcwZEphTEFhbnh3VTdMcWRRNjBnQ0tKVy9r?=
 =?utf-8?B?anJZTVFhd050Nlo2OHBXbytFTVpUMDE0aTR2alhGWlRkZWRJYytseXI4RjBi?=
 =?utf-8?B?aGszYU9aOWpRaFd5TjdQeWp1TWNjMjBPU0lMZnRBcy9mTUpNbGFySldWQStw?=
 =?utf-8?B?aFBTTnpkMkx0b0lSelZuUmNxb3ZXb1g0Tms4dnpzVkovTXZoMWNxaXhiYWZt?=
 =?utf-8?B?RVg4V1RZZldLWERHVEVLU1IyUzlKMjdmZk9yZllXdWgxeC9YMW5MV25vLzlH?=
 =?utf-8?B?em5xekNQZitzYVdqaEV2TzMwZm01LzJWYURKZVU0RUd6UnZFUHd0RmJNbkFH?=
 =?utf-8?B?Q3hWQ2FuVjdkNTJhZ1ZqUlZPSW1mVy8xQS9yektBYlVXY1FOM2RpUmUvRThF?=
 =?utf-8?B?enJJdmprdGE0NWp1REZLQmRFdEtnQ29UaVo4OEpFNmN6RkI2S3Y1UXdyQm55?=
 =?utf-8?B?WW9LcE5LS25DL1EzempFV1V5RFdUMGJEZkxFSjBLWDdETGlKY1phWmhRaThX?=
 =?utf-8?B?S244Y0F5eGN4UGpxbE9lRGVkL0xiUEhQK3BpUlJ5Sm5zQmNyU2tVQlZMeTFO?=
 =?utf-8?B?WUFia0xvUENuOWh2VVRKYnpBTWhMOW1iM1pNUmRDbHQvOWNYWXpRUjNIZ1h3?=
 =?utf-8?B?RTU0d2Vpa05yM3VTc0pKZ1V2VzF4WURlVUVkVk4vWEF6VW9CS1VLdjg0amtu?=
 =?utf-8?B?SzQySXUzbXMvSDM3bEJrUkZQZ1QwcGVWU01nUDQ2NnBzVlRTUkhyYnBsQ3hY?=
 =?utf-8?B?ZzNnL1pYSU5uNlBGdjJFaHFBbml6N1NEbEVmb0NqNHZWK0hzcnBjbFhUK1Za?=
 =?utf-8?B?Zk8rUlV0WUVMcFc3SUs2ZGI2R1FOemY3T1BSdzJNKzRJMHN4cGFPWVo0UFZH?=
 =?utf-8?B?bE83WFFhZDdGK1FNc2poVzNqL0g1NTlybTlUMFpPZ2Q2VFlGODA5K3FpOEly?=
 =?utf-8?B?M2xaQnQ4NlVrQ21iaExaQzRlRzJxdXA1T0RDK1I0UG9wMW43MkIyTDYrWmhw?=
 =?utf-8?B?TkJ5ZDJTUGRnMWNQVGNyZmJlb3JNMVdWVi9IajQ0U1c4NHJhdVBaNTVhSzFk?=
 =?utf-8?B?MHRXTVJIR2Vkd1M5QnpMZHhpK1pnb1puR0dHNWlUUmxZdXRZOHRnRjAwa291?=
 =?utf-8?B?SmpTa09vdHhtSVhYVEs0L2JYcGYwbllrMEVXWUJCSDQrSnVhVjVUR2ZsR2lI?=
 =?utf-8?B?ZDluRlRiSHliSjcwa0llSENZcnhBRjI0cm1LODU3N1VJbXJMM2FaQ1NRdGZw?=
 =?utf-8?B?WFpxRlRzZFJhK2JhbGphZXErVjg2d1Jra3pTVno0MU1QVFVyejM1MnNhbkNs?=
 =?utf-8?B?Z2M4bGI0NTdVNzNIU2Z1U2FGRkNMNWxYdFFwYXZHVnRQN0kxaWltZjAvai94?=
 =?utf-8?B?WGdmQ2RIN1BXakxrUHdyUFBzdTRyYWpaK2FCeUFFMTdzK2IrTmJDSS9WZE5w?=
 =?utf-8?B?VGViSjVYWE1ibFNDUjU0empGWnFLQ1lVZVhNMm54UHNFeVZyK0hWNzNzYStm?=
 =?utf-8?B?QWpEanRJbjYrWDBjdTRYNDNMcDBhNHBvL3l1Tkgxd2VKMjZvSkRjaUtYelFz?=
 =?utf-8?B?VlIwaVcwckpURHd5L3pWbUUrVk9jWWFIUWI0dzdZVE5ldXdBbGlzam5sLzlS?=
 =?utf-8?B?WGtRd0NBeTZVOURwVjhtbFk2TEhpZUY3R1R2WExYNGdmSi9jRTRkS25pTHc5?=
 =?utf-8?B?RXlqZkdlQlF5ZHl1VnptRUkyWVhsamVuZ2V5RG1uM3dobmhPUE9lc0JUL2w0?=
 =?utf-8?B?aE1WOElkOThRa0tzUTVxZzd3bDZSeEE1REYrTEQrc2tLSVE0Vy9qK3hveWZQ?=
 =?utf-8?B?YmY1enVQem5SekNSU2dtNDh0THJnU0lDRW85Z2lOblZKV2RKNVhLRmJWSVF1?=
 =?utf-8?B?d3B1VDkvZ0NpdmZpVGVyajhsVXFTUm5PQXA0aGJadndXTldNVXZvM0F0czBz?=
 =?utf-8?B?YUhTc2tvK1RqUkhJaUNvUmNhdEJWWWdMVjUzMHF3NE1KMnRUL2ZWNndhRmxH?=
 =?utf-8?B?Wm5FaGwraHQ4clIwU0p5M1hQRU1nMTY5R3BpK1l3c2MrK0UyMHlXbGxhdEha?=
 =?utf-8?B?YW45L1oyT0l4c1FXWTJBWTdoTGovSmRMclcvZTBVRWswUG42M3ZTY2RjTDds?=
 =?utf-8?B?TzltVjhoRFVVM2x2ZFdrY1MvcjVSVUw2d1VGZmJWeHJNaDNZUytORHZHdmhh?=
 =?utf-8?B?TGFSa1ZIRTN4Uy9sQmNnSXF3dFN3UHZCSHZRdS9aUVVoS3RGN1hXbE9aUVJ6?=
 =?utf-8?B?OE84Zk51bnJUWWJYU2FjSE1ORStuMnJhbEhTUGYvMU05bjcyVVBvcFo0R0ox?=
 =?utf-8?Q?dvLGOYHw5JsbxR7yjuIzgQ8eGC8e+J4ef9jcK28gHjACY?=
x-ms-exchange-antispam-messagedata-1: lxlS6JSG9CBA6g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Gaj8dv6uI0TjwiTFSatJkH1S5HkyEQFstagMbgMsrms0PSvepfSvXW/0sq7490A5qDseYY6geKbRH3Gfh9J08kMaEja5+tNdfV0VlBZD32LNsq0NcgYf4+EGx6ui8yzSm0KHQTQNGL6BFK1StA3HBujJFWeEXm/l9SFyqD0QF0xaEy0qNIf6MA7+noqlFKTiD3yJfyWrrvNg7tZa6NC/BvYkTW1csLwr/SMwMLpDOJgwpiEfta6ZSd3Vd5Y9HXvqcA1DqFcPI5mwb3o6uj67vo47eTLzDfu93L7owq4TseIrdTKVmhPJIbThVwgnj+6s8OKKDjgBNa4qOnCuh+n5IQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eQyWMTh6eK0iVwNzt+b6Hcm9pRN/uVOK9mZ+vjeTqapS7Wdqo0RXaoUhDszwh7YVDjiJdvA5cf6OwFF0jSznjYQAAjTH5hZ9xSvsPwFDscEutRAv7Bkgq0PLVsRFjJz9XTu1omJoGP0L+2Pi6fpYiRFWvSMFB1XHQdRLNJrfgkWxYhnYCaTaVpFn83v8wIiiQm9maVlPWRPCMhPVJTU3t2hvBRdF45G5qqGJKl2fB7o4GmAbYb3tNyCgO1LR7wAA4DAdQsWuLbwTbiU+yQyxnIptp4o/sIn+MSUvJTpxWRK0j6KYRD2uZNbghcLY8HJUNNjUBGp54VYJUEIfnqjSnTI5E4ElbHCPbk6SEl7TBlqOWvOj3fn/fwSt+LUKaF1bnuzUgcYfn+B/0UvM/UDQ1aOaFXg1e6AM/EfArJI3GSRvUFd1jUq2nBAYfFsyRDbHTuCgR1aDFwKzaRfr2946b5MriYjAh3gYP1JOzlgypzewSl7VdFAwEo/fzHxt2+tZpeUSk/EYcYdT1gtjAE6vUTWu8RZdg4C5WBVkVmBGfhcecR0/cJMPYG9YI8GjP0J0XC0cd6Sv9epClrna/tM2LVdp4fQvSMUbc59jkn8NMDCd2zNToaKEdmIWj92ipx6oYDyFHR6czIaQ87e9EuHS/g==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR16MB4473.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427383f8-f418-451d-e60d-08df21f08c8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2026 08:21:54.3052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTue1o9JpBBGfxCQvTodaH7K7m6KNcsDYKRS4tcJUxFD+VC9Ej997lrA6WpkO14QtxuhLZyfoocTPU/pK6KwHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR16MB6400

PiBPbiAxMC8yLzI2IDY6MzEgQU0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBPbiA5LzMw
LzI2IDY6NTkgQU0sIFN0YW5sZXkgSmh1IHdyb3RlOg0KPiA+PiBBdCBBdnJpJ3MgcmVxdWVzdCwg
cmVtb3ZlIGhpbSBhcyBhIHJldmlld2VyIG9mIHRoZSBVRlMgaG9zdA0KPiA+PiBjb250cm9sbGVy
IGRyaXZlci4gVGhlIGxpc3RlZCB3ZGMuY29tIGFkZHJlc3MgYWxzbyBib3VuY2VzLg0KPiA+IERp
ZCBBdnJpIHJlcXVlc3QgdGhpcz8gSSBoYXZlbid0IHNlZW4gaGlzIHJlcXVlc3QuIERpZCBJIHBl
cmhhcHMgbWlzcw0KPiA+IHNvbWV0aGluZz8NCj4gDQo+IEl0IHdhcyBvZmYtbGlzdC4gSSBhc2tl
ZCBBdnJpIG9uIFNlcCAyOSBhYm91dCB1cGRhdGluZyB0aGUgYm91bmNpbmcgd2RjLmNvbQ0KPiBh
ZGRyZXNzLCBhbmQgaGUgYXNrZWQgdG8gYmUgcmVtb3ZlZCBhcyBhIHJldmlld2VyIGluc3RlYWQu
DQo+IA0KPiBBdnJpLCBjb3VsZCB5b3UgcmVwbHkgd2l0aCB5b3VyIEFja2VkLWJ5Pw0KQWNrZWQt
Ynk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkBzYW5kaXNrLmNvbT4NCg0KU3RhbmxleSB0aGFu
a3MgLSBzb3JyeSBmb3IgbXkgbGF0ZSByZXNwb25zZS4NCkkgZG8gZmVlbCB0aGF0IHRoZSByZXZp
ZXdlciByb2xlIGlzIG5vIGxvbmdlciBuZWVkZWQgZm9yIHRoZSB1ZnMgZHJpdmVyLg0KDQpUaGFu
a3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gU3RhbmxleQ0K
