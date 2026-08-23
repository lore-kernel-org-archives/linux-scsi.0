Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B8A32AADB;
	Sun, 23 Aug 2026 05:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787461422; cv=fail; b=mPjFCJf5Z7OKb2V50WBPZvzUfG9kk8AOwYT9voJ5k2wq6O8BoHZ2ghc9dRBYkQv249v4w0maGnjhQ8U8y6cMl6Au7EAdKuql1iVvzyYRtXKGLDI+GNqRmQxmd1zQdHBqHEUmxSlHVdjhXdajqc8Y6Q3gW5/CIqHBb6ja+hhOylo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787461422; c=relaxed/simple;
	bh=y3SgHUcrQucBbXmQU3IHQuKlE4n3e6J2sSU1fQUfn8A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gtjwlqw7wlmVHmb57Ia+n0k+X85/XI+lT8q/MgRHZbGGcrS0Q+IaHAt6aFjm5ZdN0VzgJ+rgxUAxA3NYhmdcfHl0jykwFj2SxDhYuJAwlQXHI+nyxrfJ7q1uH/FBt4b6TGwWQiyaNIszkKwgXJZyrdrhW49ZAPO+cLiyRqjN7us=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Pk77B6Ru; arc=fail smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Pk77B6Ru"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1614; q=dns/txt;
  s=iport01; t=1787461421; x=1788671021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bED4eo2Hwj+LxItiFfkE27JaUpl0oTygBIlvmrtGRS8=;
  b=Pk77B6RubmzajWywANYkh4mC4IoXDFvbcVDEIoPWZSoKP/VjjikJYOhb
   AD/hiuC5FsMXEx+vnn5QjK6oJZ0XOYV2vr9+CAwiTnqpQ/Pqe0qpgq3/O
   4+yqERloTu+ZaVZFMddhh/xNuCmP7Hj4T+nmI23MX7zgKa5/9pEeORHdz
   rB5JGq5YMHpfPS4hVT1vSwNI2LEf78NPMVqy8szvmX6A+bP/cv0vnwnpe
   elb+AZ1d5LQ2F/01ruX16Fc+pYgVChdiQ4pQco8LzbnwEvdkpL+Kjbbcy
   /GRlk1Hf2DxjheL4z7uFrbtzLDtSQKqgqeuwL92NFWVrvWZKguzL/+a3p
   Q==;
X-CSE-ConnectionGUID: EPGBs0JCQfm94t8cEwdaTw==
X-CSE-MsgGUID: 9nFj5q1qRuORFDNN2l0EYw==
X-IPAS-Result: =?us-ascii?q?A0BoAwBzfopq/4z/Ja1agS6BK4FuU4IrSYgjA4UriHkDn?=
 =?us-ascii?q?huBfg8BAQENAlEEAQGFBQKNbAImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFA?=
 =?us-ascii?q?QEBAgEHBYEOE4ZchloBAQEBAycTPxACAQgYHQEQMSUCBAENBQiFbwMBArQJA?=
 =?us-ascii?q?ooceIEBM4EB4DkVgTiIXgGFeBuEYScbgg2BV4JpPoQhAQEihBOCMASCIoEMh?=
 =?us-ascii?q?ESPE1J4HANZLAFVExcLBwWBI0MDKi8tFg0PEykFLR2BIxIPHRcXHlgbBgUSI?=
 =?us-ascii?q?CpBRCMDPoEZQQKBdT8jGTZ6gQlegSspYAECEBdGLhWCBwKCWoEnXgIBSUMOB?=
 =?us-ascii?q?0giC209NxQZAwSBNQWOVB+CTIEjOjZtCDURxx4KhB6iEheEBI0UhwOSUZgNe?=
 =?us-ascii?q?yOodQIEAgQFAhABAQaBaDyBWXAVgyJTGQ+OX89deT0BAQcCBw4DC4FokX4BA?=
 =?us-ascii?q?Q?=
IronPort-PHdr: A9a23:gOGeihWWtFxdKYMUxdiV8qsyKqXV8K3PAWYlg6HPw5pUeailupP6M
 1Oav7NmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QcPs=
IronPort-Data: A9a23:1wXqG6y6FhvUFcjjLvB6t+dcxyrEfRIJ4+MujC+fZmUNrF6WrkUHn
 GAZXW+EaauJNzGhfNt+O4XgpkpS7ZXUmIc2QABlpFhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 46aT/H3Ygf/hWYkaDlMsspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJGwOEqcDosRcOG9Lp
 KAEeDsgcRyKu/3jldpXSsE07igiBNPgMIVavjRryivUSK59B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cO3WjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCwaoOMIYTbHZo9ckCw9
 2To/TngWwggKful5xaj1Cio3sL+gnauMG4VPPjinhJwu3WXx2oOGFgVWEG9rP2RlEGzQZRcJ
 lYS9y5oqrI9nGSvT9/gT1ijq2WFlgATVsAWEOAg7gyJjK3O7G6k6nMsVDVNbpki8cQxXzFvj
 gTPlNLyDjspu7qQIZ6AyoqpQfqJEXF9BUcJZDQPSk0O5NyLnW35pkunogpLeEJtsuDIJA==
IronPort-HdrOrdr: A9a23:X1kGyKz/MDzaYx9hfxQgKrPxI+gkLtp133Aq2lEZdPULSL36qy
 n+ppQmPEHP6Qr5AEtQ5+xoWJPtfZvdnaQFh7X5To3SLTUO31HYY72KjLGSjwEIdBeOjNK1uZ
 0QF5SWTeeAcmSS7vyKrjVQcexQveVvmZrA7YyxvhUdKD2CKZsQkzuRYTzra3GeMTM2fqbRY6
 DsnvavyQDQHkg/X4CQPFVAde7FoNHAiZLhZjA7JzNP0mOzpALtwoTXVzyD0Dkjcx4n+9of2F
 mAvx3y562lvf3+8RnBym/V4a1Rndvq2vFDCMaPhsV9EESstu+vXutccozHmApwjPCk6V4snt
 WJiQwnJd5P53TYeXzwiQfx2iH7uQxeqEPK+Bu9uz/OsMb5TDU1B45qnoRCaCbU7EImoZVVzL
 9L5WSErJBaZCmw3hgVpuK4Ei2CpHDE5kbKotRjyUC3lrFuMYO5mLZvuH+91q1wRB4SprpXS9
 WGR/uslMq+OWnqHEwx+FMfgOCEbzAUAgqMRFQEt4i+1jhbm2088m4jrfZvxEvpMPkGOsV5Dy
 OuCNU0qJheCsARdq5zH+EHXI++DXHMWwvFNCaILU3gD7xvAQOHl3fb2sR92AiRQu1B8LIi3J
 DaFF9Iv287fEzjTcWIwZ1Q6xjIBGGwRy7kxM1S74Vw/uSUfsunDQSTDFQ118ewqfQWBcPWH/
 61JZJNGvfmaW/jA5xA0QHyU4RbbXMeTMoWsNAmXE/mmLOAFqT68ujANPrDLrvkFjgpHmv5H3
 sYRTD2YN5N60i6M0WI9iQ5m0mdDXAX0agAZJQypdJjurTlHrc8xzQotQ==
X-Talos-CUID: 9a23:LRrgiW4coRDLIXxqDdss2XY7MNt9UFbkwnKBf1PoAkt2RLSpVgrF
X-Talos-MUID: 9a23:wDFjUguhiCc4NgAeE82n1TdMNppxur2UFWc3v7kgnZOAbQFBJGLI
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-03.cisco.com ([173.37.255.140])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Aug 2026 05:02:31 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-03.cisco.com (Postfix) with ESMTPS id F2E0A180001D0;
	Sun, 23 Aug 2026 05:02:30 +0000 (GMT)
X-CSE-ConnectionGUID: QRwobj5DQf+8LNbBTwfYYg==
X-CSE-MsgGUID: KvcOOlQXRp6zpy6lzFR+hw==
Authentication-Results: rcdn-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,238,1779148800"; 
   d="scan'208";a="72223033"
Received: from mail-westus2azon11012016.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.16])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Aug 2026 05:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fvJ3H9dHfM82jlX7xP+xPSsOXlKvL+iDo04Th4gqJtW7eXpF9/j8kTYTLtBCAZWmsXFEoW8bY3ui1L8Q+X0vCtXrGI+r4G/Nh4c5IRgKLKKlpL0WGgt+XpxObYTRHCpTeWeTiKgXOqty/KfIroFV1AU4ZhjaDgw5O0OYqkAPv7IpCzQv35hkBbuytGB6aulMMagtypAFoU+KiawlFyV+RL0+s95aPixoxyFYslFmQX8EEmyTY1AICrXcKBnJIHuWvvgjaQtCYuAZW8pa4mdzseSXH+/9N7JBm0+RAJLQNGwO5tR84FR3zaNRweU79NFOPfLUsI3UNRHhJaHNbEVLiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bED4eo2Hwj+LxItiFfkE27JaUpl0oTygBIlvmrtGRS8=;
 b=qBhqIZOopAV6lz6AHaf3RopAUVSq85FzlAB6X2xzvnQ/8HMFvoAHYh/IHkplHfa418VYiPm3jhW/XUS/zMFbozPJ59Ge4viczFp4yu2bxJhva4pozas2cRkI/2JXxj9XJ3+C+jMfaoSpxUnmSMwpzHvySzbbZvImGP48ab2gicTpJlFH4MaSThDRWBiWbQ7/5CwILTFnV95Rp035VQNlQO52xB7F2E1tKIp+1D+Uc2hp8nIcN/Xd8wi92WpXfUshCE6KBQn1P5lxrgMj2jZCfSeX/U/xnXOS9XJtkFXqb+Wvsf5XWgfk2ZW+CJwp5Ptj4rVQbkQzXDHqU3qUbWYcRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DSVPR11MB9743.namprd11.prod.outlook.com (2603:10b6:8:34d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 05:02:27 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%6]) with mapi id 15.21.0339.010; Sun, 23 Aug 2026
 05:02:27 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Linmao Li <lilinmao@kylinos.cn>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: fnic: free the NVMe port template from the
 delete callback
Thread-Topic: [PATCH 2/2] scsi: fnic: free the NVMe port template from the
 delete callback
Thread-Index: AQHdL8/rYE8/YKPb8EimITGU4DriEbami8oAgASMszA=
Date: Sun, 23 Aug 2026 05:02:27 +0000
Message-ID:
 <SJ0PR11MB58965D752AF8F07FAF4AA364C3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260819114242.3598034-3-lilinmao@kylinos.cn>
 <20260820073000.3984849-1-lilinmao@kylinos.cn>
In-Reply-To: <20260820073000.3984849-1-lilinmao@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DSVPR11MB9743:EE_
x-ms-office365-filtering-correlation-id: f17b5aca-b8ca-4493-402d-08df00d3ba7a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|6133799003|22082099003|18002099003|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 hgHT6307i/1kDisPZVVbLy75lRpBdZfOcQdRIYppWz7hMFXTLu9N33+KxUL/oxIuDkTLG4vW68nxpcq8M6iGAK9hUgNrkbEiATIHIrxlQ1VGOvs0qI0zLuxSHfquGa82ELfM6PL6/hCps23WlZRNSZpcy44ve61ofMgGCWyilWGX+5g1PpCU7v/5r0nhdJN6tnCeHH4Bhb8ZrThQahQE3y/aJ0M1jWi0tKlLmeWT6dFgjTPrj8W6O65ASDnE2rJw2hcSDotenp8yCaqyDwJ4CBghMJjItRdJK3vMTUD6n5SJALKNDsZqXtKIzBUMJljUhtqjvN4cvlLL/dNzY0rEm8nXz5GoyZcRiCM3uJ4zekpV0C7zjoAp9jOWhTNidwL7P8d6VGbXSvcDzrsmr12RdIoLvP81bJvGoANefjKvdQ//Ypd14Ks72O5FI5k6Q7n3Beawyb25ZhLo0WyI8vz/N41QyQlPkBG0l/fLOylOQi65F8JEor3NeIpFkOk6Y6c+7VJkWZ70x2xybn4ROm8kq0e39+/A2Tk5VwANaDds1qloB+JfZiBZL8TOHwhVX+5OqmlOrCSvpw18uIpPPVkfQrbs0cBqefPH0N7Jc194uuVxRD068HukBOLwnvNv5cOb9IHy3g755cJmWPFggPI0t1Kqe8UFB9nATXjWOzNjSHLQ3QuXXpZZ8H/AKNZHsV/OcF5q+tBmMoSIwgTkg0KD4SceRVEaON2rqS89x3FmdtQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uGKjbtMPpMNBFNZq5oyiTsTqUOOcUQdyabO5BXdBjDGXAls0Cwqam1ODSAX+?=
 =?us-ascii?Q?iqrmicX/4ECE0qOe621HCk5y3MPjXESWzYGdz79ezmY2PaZmFxwL7qKRzEq0?=
 =?us-ascii?Q?YEh4/5kBbWtM2ZtzeoH3OH7UI+EdFmi2gksGDAepvdgle2FERVCQ0oD/2v73?=
 =?us-ascii?Q?G5R+F/oLCjd+9r9284jaivrN2uZEob6rxSZMieixqPSzWXRrWlBolT0NULSa?=
 =?us-ascii?Q?m/KC0q2BZ0kRi31GTksjzA3qMhY6xtAl5RtW3mHUhpT9oiv0RvpOg/0b1BfS?=
 =?us-ascii?Q?VesKQFM5Ii8KtScSUiYqcM+KPbFpwMf5jOpvp5X98Y831LMh1ZW6DHjw9mNU?=
 =?us-ascii?Q?QLPDOYcPfeUr/mGwQoNMveWvZyuBnrylj+r4vunHsXVlyQTS75YFsT3yjPrx?=
 =?us-ascii?Q?yPs7/EGWa8AK/ijQJ+/h72Qa2wVfi7gDyL+DnISh5ZGOirpN5ffOp5Mcq0Pp?=
 =?us-ascii?Q?LztacgoWmqumiI79mNCvi4aKBbirwZtTUeq0fHtrvtlS8zLMw/hJEvh+mp3h?=
 =?us-ascii?Q?htUEmIihvX9q1iREO17cl/nj9sHlvrj6mLtRdnuOmHEGK/dHagyqeNbuG8+r?=
 =?us-ascii?Q?saA+XwdCfe2i0cp6r7cR8BPrk9zlHHSdY9Tr6jRxql2rW7NtL3dgKJqtOVmq?=
 =?us-ascii?Q?C/mjPcKAPc/5KRsyRuyD9jZ2iOTIYfntKdqz/KeBfF71fqlwIR+BfU+i74Ha?=
 =?us-ascii?Q?9WUUHz5D7AtF/ylENtoNhbxIsEoOGI0c887ohnpxOPt76mIoHGUkJyeghAsq?=
 =?us-ascii?Q?UIHUWESeCkwMb+1B+3KIXxOZN6KEEAbBh0xRpRpG1rIHJJ+CkLv4w5Mkt8Y8?=
 =?us-ascii?Q?KlS5vU2VbL1hVsordWESx2UARgIU1SfXKIK58pA/7UwgrkkaMxBrUqEsDv9u?=
 =?us-ascii?Q?CKJq5ulyRuJFVe3XzDZNmNXU5lAUveIcXyPsLenaW2FNykAhUipMn9GOyecj?=
 =?us-ascii?Q?+p+77eWXQK60m2KcmTyPzMDBeh3iEOxRcqFqScE/GXgdQDxo9eiEGn5bcph9?=
 =?us-ascii?Q?CAoFW80CVB3PhbRgiuqM27Uw+SyeR8Qd5wlNE5ciPgHvW9KcyO2HAr6H9/6C?=
 =?us-ascii?Q?ftQs6ocrsNHn52GQm+o47m7bBB/u6oZMmNSAuwscsroXJBA5PCwZ9a4uRnqU?=
 =?us-ascii?Q?MDHq0cTPRH6IanS9800PTKevXvaEau5hjpOuH4nhqaJJwGlz9P+1fBMmdNN7?=
 =?us-ascii?Q?+VyDm3k9+wLC/QZM32PKfUKCR5b/BvJfvXDv0PLAoJ3IWswH9JieIgOTliGQ?=
 =?us-ascii?Q?eu8ulZ2Mwelqxe4u/rbZ1hOLo4bNol7fGp6oYY8RQYqJf+kxxSHerqAUbEuI?=
 =?us-ascii?Q?Xt8N7yd1FLgvMq4rO/XOBLoP5WsmcSkvFO4xHaHYsIlURc8VdZM4QmQm10kC?=
 =?us-ascii?Q?JNTsJ+iCc2IUqYbLoFJ4PDAHD4T2eZvGJ2RgotCG4Js6zAGIClvPMctFED2B?=
 =?us-ascii?Q?Y0W+tlqaXgQZ2yk2xbcQP4mDhMt4Frjevc6HETlFBoM3t2FoDz+QPoZZ+rsg?=
 =?us-ascii?Q?1b0qxL6OwRCDmiohXrMbHeVlBueotDD11M0itf7xXSXsvnfX6sC7Dy0oFe9B?=
 =?us-ascii?Q?QhAwzVU8fbp07CtRF+JS/Vp/dl/IhHQAqByE5IuZqnn+e8Akxzf0UTZveqB5?=
 =?us-ascii?Q?94vk1qrMPf4pwZ+pihCshAU47tVAV2rF8Ns6nfr0ceV9X0pWD9DPAXhg7GsD?=
 =?us-ascii?Q?cvI8D3gD1o3BEXm9bmuRWPNeDYTWzBi3Z5MTmzgbrHnQ6G92?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	rIT0lF2+pM/vmV4juFcdbavjQMYGUUPr0SHSKtuXkWmUIC7Z6qkj39jonrXoaLhUZrO2vRF4SLcWpDNq9tT/lCfNv2zTGGSHF5//5cR6Hn2LK691D9xoQjkYYj9WQzj1vKcAF7lMQymikBR1OJyJGhL3piXNlmsKc7rhMo9YBw6VoZBvY6cR0/7g5jA0Puq4/2gK0IfZT+Y5lIdQpCViwwxmThh0pAgV3JhssIqGlfVHm6h1m2TNlq6mxgq9onuH54GSzqLeUq6Hj8fH5R7x+Qq+7myM5chwQ10AFc5P4jOneg3wgX2n68VuYGT8DuX3P8+CXG7703UyZClU5YNbyQ==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17b5aca-b8ca-4493-402d-08df00d3ba7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2026 05:02:27.5970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CxlEgFM1nwnNyNDMjv9dsbSEvRMvLW48Bgc0FcoNCRRLMsrFSxL3lSZyjecdqqh6gjyiAAtRh2gBAS5rPwL7cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9743
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-2.cisco.com [72.163.7.163];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: rcdn-l-core-03.cisco.com

On Thursday, August 20, 2026 1:00 PM, Linmao Li <lilinmao@kylinos.cn> wrote=
:
>
> Resending: this reply went to the review thread and linux-scsi on Aug 19
> but not to any of you directly, so you may not have seen it.  Please drop
> 2/2.  The bot's two findings are quoted below; the rest of its mail is
> trimmed.
>
> On Wed, Aug 19, 2026 at 11:52 AM +0000, sashiko-bot@kernel.org wrote:
> > New issues:
> > - [Critical] Relocating `kfree(iport->nv_tmpl)` to the asynchronous
> > `nvfnic_local_port_delete()` callback introduces a severe arbitrary fre=
e
> > and memory corruption vulnerability if the unregister process times out=
.
> >
> > Pre-existing issues:
> > - [Critical] The driver's bounded timeout design for NVMe FC
> > unregistration leaves the `fnic` structure vulnerable to a Use-After-Fr=
ee
> > when deferred callbacks execute.
>
> The bot is right.  Please drop this patch; 1/2 is independent and still
> stands on its own.
>
> If the wait times out, fnic_remove() continues and eventually frees fnic,
> which also frees the embedded iport still referenced by lport->private.
> A later ->localport_delete() callback would therefore read nv_tmpl from
> freed memory before passing it to kfree().
>
> The underlying problem is that the bounded wait allows fnic to be freed
> while the NVMe/FC transport still holds pointers into it.  I will revisit
> that teardown separately.
>
> Sorry for the noise on 2/2.
>
>
> Thanks,
> Linmao
>

Thanks for the change, Linmao.

I will get back to you about this change after testing it internally.

Regards,
Karan
