Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CB027FD4D;
	Tue, 20 May 2025 18:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747764822; cv=fail; b=fv2lKNqyf+u77oevS1XqmYFSJTiesR6sIPefx82VvqrgaCSuuJmPkuYZTWiCZ4J/OlMUMipL782jUKQ3z/qoIIhF+GXCtEBaY371lBQ2Z6Z8780BlKnxTPJYkAVMsiiQF7gducAXvwNr++LG5xD2tx2pCy5N0FKQevZJS1li8Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747764822; c=relaxed/simple;
	bh=bMmm/QIEJMRKNNmfktAVD97SS1XjfUldlc1DuqAqs/4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IZKs6Md05AScEmw+5TcfUpryW1xhZgBmxSJ4vP81JWVHmQohEek8JudN4rEnaE3z0Bx+wExVg80ixiBmk2zbrGr0Ann6FtlDz5vq+zsQ8XrkaTQ6xhbnCUYAdNp1QCKmsDV0jctUISQ4gx1r7eAjfq/RLm3dJVgaTLOxlGXzOJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=VVn4jDFR; arc=fail smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="VVn4jDFR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1619; q=dns/txt;
  s=iport01; t=1747764820; x=1748974420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ohVUegfFsa5i0O/Z4Zb6OuQWr0Axzvycri8xNMDr2BI=;
  b=VVn4jDFRS0TYWzKMVB0i/barfOOrK/fh9Kbem68771BpRCVwiCjq+eWl
   oui9x15b/3Pbun5J+pCoOJ1E2UgkrlyQb9u82+JX0/vQT35VJvMXxe6eC
   Kc7XGwSRRU/HGCynD7jgpzKFFel/FfyX4cXIYAIOGOdlSwxn+7BP6VF9T
   Fnt8SkLa3aPsf1bMX0ThqD63kCkhhte1t10iDsO3rDVNxo8R945AsZN1U
   raKujdjUIrjROhM8aNSVSCllEIz8dcrcYexzbuPZ5/o9nct3zVfdyAIKh
   UR3anTrY4ueTqKyZrLe8LwX9qVK9zW+bUVgGwZ1gHftXwcxovlvx0s5mG
   w==;
X-CSE-ConnectionGUID: dFHx69vTS7imDeDk7oWcWw==
X-CSE-MsgGUID: 9lq2XpB5QwO2DVU7ZtZjWg==
X-IPAS-Result: =?us-ascii?q?A0AGAADnxCxo/4//Ja1aDgwBAQEBAQEBAQEBAwEBAQESA?=
 =?us-ascii?q?QEBAQICAQEBAUAlgRoFAQEBAQsBgXFSBziBW0mIIAOETV+IeZ4WgSUDVg8BA?=
 =?us-ascii?q?QENAlEEAQGFBwKLTwImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBA?=
 =?us-ascii?q?QIBBwWBDhOGCIZaAQEBAQMSFRM/EAIBCBgeEDElAgQBDQUIGoUDAQEBAUYDA?=
 =?us-ascii?q?aR7AYFAAooreIEBM4EB4CSBSQGITwGKYycbgg2BV4JoPoRFhBOCLwSCK0RSj?=
 =?us-ascii?q?RiSHFJ7HANZLAFVExcLBwWBJhAzAyAKNDECFA0iDwQWBS0dgg2CLU+CHYIPc?=
 =?us-ascii?q?GwDAxYQgxNxHIRjhEorT4MkgQN7ZUGDHEADC209NwYOGwUEgTUFllOCe3KBD?=
 =?us-ascii?q?hyCJMcHCoQbogUXqmAuh2WQbiKoagIEAgQFAhABAQaBaDyBWXAVgyJSGQ+OL?=
 =?us-ascii?q?RaTEgkBuFN4PAIHCwEBAwmSJQEB?=
IronPort-PHdr: A9a23:RKi3HR/M7a9MZ/9uWBDoyV9kXcBvk6//MghQ7YIolPcUNK+i5J/le
 kfY4KYlgFzIWNDD4ulfw6rNsq/mUHAd+5vJrn0YcZJNWhNEwcUblgAtGoiEXGXwLeXhaGoxG
 8EqaQ==
IronPort-Data: A9a23:lX62JKiIoFbb54heRNiYglBgX161CxEKZh0ujC45NGQN5FlHY01je
 htvXjuPOa3eYmCnL4snYI+/8hwCv8SAn4cyHVRtrSwyFS1jpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOCn9SQkvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSCULOZ82QsaD9MtvvS8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUU1MZnXzBQy
 cdHKTUhYzyA2OWJy42kH7wEasQLdKEHPasFsX1miDWcBvE8TNWbHePB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgx/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9IYPTGZQNwB3Jz
 o7A1zX9G0sqLPbC8CWiqF6Su7D9gRH5Z41HQdVU8dYv2jV/3Fc7DBwQSEv+ovSjjEO6c8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BpRUHWvJOHOAgrgKA0KzZ50CeHGdsc9JaQMYtuMlzQXkh0
 UWE2ou3Qzduq7aSD3ma8994sA+PBMTcFkdbDQcsRgoe6N6lq4Y25i8jhP44eEJpprUZwQ3N/
 g0=
IronPort-HdrOrdr: A9a23:+5cSxapQykTbje2ZVEiR4ncaV5tkLNV00zEX/kB9WHVpm5Oj5q
 OTdaUgtSMc1gxxZJh5o6H/BEDhex/hHZ4c2/h2AV7QZniWhILOFvAs0WKC+UytJ8SQzJ8m6U
 4NSdkbNDS0NykEsS+Y2nj3Lz9D+qj7zEnAv463pBkdL3AOV0gj1XYENu/xKDwOeOAyP+tDKH
 Pq3Ls+m9PPQwVxUu2LQlM+c6zoodrNmJj6YRgAKSIGxWC15w+A2frRKTTd+g0RfQ9u7N4ZnF
 QtlTaX2oyT99WAjjPM3W7a6Jpb3PH7zMFYOcCKgs8Jbh3xlweBfu1aKv2/lQFwhNvqxEchkd
 HKrRtlFd908Wntcma8pgao8xX80Qwp92TpxTaj8DjeSI3CNXAH4vh69MZkmyjimg0dVRZHoe
 R2Nleixt9q5NX77X3ADpbzJklXfwGP0AofeKYo/g9iuM0lGf5sRUh1xjIOLH/GdxiKs7wPAa
 1gCtrR6+1Rdk7fZ3fFvnN3yNjpRXgrGAyaK3Jy8fB9/gIm1UyR9XFojPA3jzMF7tYwWpNE7+
 PLPuBhk6xPVNYfaeZ4CP0aScW6B2TRSVaUWVjibGjPBeUCITbAupT36LI66KWjf4EJ1oI7nN
 DEXElDvWA/dkryAYmF3YFN8BrKXGKhNA6dgP129tx8oPnxVbDrOSqMRBQnlNahuewWBonBV/
 O6KPttconexKvVaPF0NiHFKu1vwCMlIb8oU/4AKieznv4=
X-Talos-CUID: =?us-ascii?q?9a23=3Asml6PWmpxuqseRPQ5EtjRMt8BNLXOXHz7GeOclG?=
 =?us-ascii?q?EMjloTZGYZVzP/5xvrNU7zg=3D=3D?=
X-Talos-MUID: 9a23:v0Y5Lgr5nvPoVsNx/Lcez2BmLZ1Y+47zMV8qy7k4hpa2KR5yBDjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 20 May 2025 18:12:30 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPS id D14361800027F;
	Tue, 20 May 2025 18:12:30 +0000 (GMT)
X-CSE-ConnectionGUID: MbZxRK0nQzuNF34VnmMMtQ==
X-CSE-MsgGUID: 4gVHP+gpTFu63jHKHs1KBQ==
Authentication-Results: rcdn-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.15,302,1739836800"; 
   d="scan'208";a="32931912"
Received: from mail-dm6nam04lp2048.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.48])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 20 May 2025 18:12:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QP1ublR/rdmYXiJYpebtGdeTcncmEPwsC57X2cmgZjz8Rs4LlzaICBmyFK3snG8K5bhd8s+NiRmWBcuXpE5TFOpCoWELBGOfOrFYdKgxk3RWnNl+UwixkxoKcPm4DjQ0fx3BLwJxs/jdthvBByZqIai2WGYpqT7jGZwzlzeEiLJC6v8y9qIK4HZZzqBhcmmuzlFIAy6inxNhEpvKKRSvrSyRIj56y5bPR5k2axy/AViyzWNb+8dvPXrHs9z4h1RGpOGHtOtQYpd3U1le57L0tQA/uPecSNgoQrD239dKzvHzbhuxCqSDDn8prVgARV4bCrH++OLmRNSsdfyyJ6EJSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ohVUegfFsa5i0O/Z4Zb6OuQWr0Axzvycri8xNMDr2BI=;
 b=sve64IbjwhqaAvTXZisjumW+35lOhK2BpFhXO7ev1uhFP7k80cR1RrPCyUpiYv164OdHQfZ9ZKX/Ae5cKWtnvXG8dBMTnoGZt90Q9EruK1ciFKKLk0/b81w81KX0FC67IKUTrSMiRieOWXSWPfC/VzLMkVivFjAVW2vSLHvDObya9ifD0Zx4ZNlfIpH9KToWOTqy2NJRuZXDfwC5A9VkmTEX0VIkgnMxpeKSNgN3OG5WdOfxy/bTYS0y7N0Wh0X3v76UAN82TzScCOq4ldetsCDL4lfaFfyIkGrTuB4nrGljHFjRm0T0x110AOBLxdyaDbGLCsw4cOGWkz0F2QXG0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by IA1PR11MB6123.namprd11.prod.outlook.com (2603:10b6:208:3ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 18:12:28 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%3]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 18:12:27 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Chen Ni <nichen@iscas.ac.cn>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: Replace memset with eth_zero_addr
Thread-Topic: [PATCH] scsi: fnic: Replace memset with eth_zero_addr
Thread-Index: AQHbyJvnA2CmvWk+tUqkCRsrBdM/dLPb0XUQ
Date: Tue, 20 May 2025 18:12:27 +0000
Message-ID:
 <SJ0PR11MB5896F06178A5DEDFACE522E4C39FA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250519085457.918720-1-nichen@iscas.ac.cn>
In-Reply-To: <20250519085457.918720-1-nichen@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|IA1PR11MB6123:EE_
x-ms-office365-filtering-correlation-id: 563160b0-f101-4c0f-dd39-08dd97c9e11d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?IjjbDejwgOHCxEtyq0rjymDLUfJUqx0Dp6ydfzpkUau6KNjAoIQFKJ5dFOy3?=
 =?us-ascii?Q?lkpctYZyB74c1HhVSUJin/V8ekMb/myKZAkz7YAr30cMWxngGTNl7o4S39Nh?=
 =?us-ascii?Q?Pz8E0prANMfognIrTpNHKvC2vCDuZyuAL0iR7+VMxJqt9IvrwTTrGN8+8DqL?=
 =?us-ascii?Q?HZV4B6H+lLq6jAjSYYMW0fB2iB43TqFuVHDcbT+8cHkEB1AR7sDJkdC2WxRE?=
 =?us-ascii?Q?qDTfgtpYCdtynQYWV7Ff6usnb3R0xz7Xs3aqZNaGNSwKHYU0ytCacAEcmwMp?=
 =?us-ascii?Q?dbflEFPtoxVPWzX7Zum14U1ISv0kO4OnKhY05me77VU2bCAUy/eMV6ZKY3Ro?=
 =?us-ascii?Q?wze3mnD4HUJRwx1ZfX4qqgrXsNyrzZetcQ6Jchdw3pDQbcwLLPofKHRJbgLw?=
 =?us-ascii?Q?8wSWGkoy2NCqzSXYQus8Sf35xYSixIM0p9hmtLH6Nv/MevJIWWYjjCsuOL9q?=
 =?us-ascii?Q?wqXceB69EljQCw0RqsmN4bpKnnKJtkpglakhdKkiocrRWhoeWByBkDOt3X5N?=
 =?us-ascii?Q?kmv3SMk6W7SMETJUwompE8fow048qe3RTXNnUOewSBEHKO3BQPEB3vWURuLA?=
 =?us-ascii?Q?KuRi91GwihyMs1k48is/dVJNOcpp63RkdMvq82MTmOIFNnBnYJipkbIf9PVI?=
 =?us-ascii?Q?71xW8ckxHBVCAMIgsbYGaOLZzRbRtvHu7ynyHtLvch+fMe3NhoYtON1VA4Ao?=
 =?us-ascii?Q?G9q5uHfftfDhM8fVeDqI4v7KmLElynpn1wO/j0LSbJjSEvtGSXmmnkSOXMoX?=
 =?us-ascii?Q?Loq9KJ9V5I8BIKWaBgjxCTZEfdZyRjB2Ft9v9wL2kV4A7/TRwIpmDRgY5YSr?=
 =?us-ascii?Q?nEaW7f4fl/T2reGTFqCiFqIB0WNaDZIdQthkbjNLxKhcdPzW/z/Nbh+CGypm?=
 =?us-ascii?Q?pYhU7rM5KcSOaU5drMPD/wAr3KJK1Y6pgYD5yMu53BGG+IIK8sr10caUIrzK?=
 =?us-ascii?Q?XdpOzBcJsAylzEytv8vWyyHUSE4c77E0XoBpz55AJAyNJKFoOJxmX2YaGj3q?=
 =?us-ascii?Q?+ga4eGRI9GJWO0cU5eja+pgySeXEl8oule06jQCzGDyVmVG4LBSGGS8cxbOO?=
 =?us-ascii?Q?6xGVQaRNCtAbTK8kXLgOV193nGMugg/pDxAPqkAQ5GZG0PMxVJDvsBKSYfEU?=
 =?us-ascii?Q?7gx7cTpX9mxq0qCSHQFvsbcQDk9+tsDRcE8ZBTqGIfaYjvf49JJAw3eOpB/p?=
 =?us-ascii?Q?OOTcqgpS473/gBlUumr4FEfHAumU+yjALlrsLpQYCojpS1mDBkyxEUh4bYLD?=
 =?us-ascii?Q?MutDh+KsbG5wffvBt50B+6KoLvx8NuWB6RQvVg1JI/kXzlR17+AWLn/NThOO?=
 =?us-ascii?Q?agXxokHoVSBsXMO/6TKOpUIX33VPSrjPzQxTbcRXxEvLyuoLrUYGP0EJbMhL?=
 =?us-ascii?Q?WEGA+QWgZTfOjsh0CAJTu09nkBgKh/pVHnGcieEl36HaS9dQGvIL1yuEpDLw?=
 =?us-ascii?Q?7menLjneD51BF5DCQNYKF/ka4mvhKmVwQnYnMThdJ3fDrsTnWGazhd8uI1+W?=
 =?us-ascii?Q?JemMqZbJtrbpPwE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?QZJNDo34CZ5oorGyLacuNNnXXLyQHaxkitff9OOz9/eSDxz+UNnryAyi5KKr?=
 =?us-ascii?Q?xwJQkzyHG4xxCJOfp4CUQLg3Ns2gvAkPIF6DJSBldTaMrn2xiy0qj79qw/I1?=
 =?us-ascii?Q?u9R7MGnxANYyHBmmPfy0RIdvlKYOg53BILyM/S8AOcRc3uxKa8rNfhvEiBqN?=
 =?us-ascii?Q?ZZbhjqws9giZVzpeXp/a1t6CONj3s7g3oRTadr6X+oqEVYy26K2lYBpD3Qjf?=
 =?us-ascii?Q?s9UjI6t09/o3zICaGus7/XKIZQhE9fjqjqzz8pRSHRH1PKCepJ0hewtC5e6i?=
 =?us-ascii?Q?TZchdlgUg2GQI6qZDPONDm0Z8QPG6RUus3s0iv0lsC1zxh5si2ud/U/MTRff?=
 =?us-ascii?Q?+x7UmuUPBipWbtECIvIajhOJtbwJfRSl2z1rdWSBqkPlzYQduADEqIkhuNk8?=
 =?us-ascii?Q?HNvBA2dLzyKi8qxeaKMx2rffeRB7fk6cgZZ53SAJD4+n4FIyiK9/as4p5OSK?=
 =?us-ascii?Q?hr/SxxvFYRjL9kcPicFBN8fS3CP0upt2A0bguFMY1b6hAvIeQ5XEArwO7ER3?=
 =?us-ascii?Q?oerjGBtFHxn57+emq+gyVILKeLXe04EuNsrW8LwrPhD10k1/cD2Q08a51Xt/?=
 =?us-ascii?Q?pNCqMl0U5KHOVgnhbeUYmClnq+ZggScR8GFUSiU5OJhz0y9b2PktVBObM57B?=
 =?us-ascii?Q?xVOdIOv0HLGUVxfF3dXtNaUpeAPUi+JrjLHq4rP9ALxUw4UtLyKdAWdY1UZD?=
 =?us-ascii?Q?U0l2RzraRh++/9n/L+EUz3CL2aP3LsMu5ARSjsWmCbzIQmW1P72Qxob0YyEB?=
 =?us-ascii?Q?JnPD2ftc/D5U9nBN+EXiIwYmU39Lw5IsrEGUqRYeeYDKnbEEFNxtkT7EqAVA?=
 =?us-ascii?Q?B8Kj2IuOMwTfffiegw4oZoOSfTsbNfMZvKNPTZ+Bo2pqH0x7iISop05AdM1G?=
 =?us-ascii?Q?HRt5C0lREUMJNFVUa3qhBZozVYHnDG8hbZH/iIfCwwBvasvnqNs7q6mDznQ4?=
 =?us-ascii?Q?q+kEjproONUGtQbKeaZ540Sz8FtwY1g3RLN22dnM19DeuyZuMuL1cuvNmF/s?=
 =?us-ascii?Q?syFOir8q7GRRDDheZUVLycEzpHZt7joxRbNyXIRCKVpNTDV9QkzEYk66sqIa?=
 =?us-ascii?Q?ieGWeE9Ydr+9TJ67GMUCT9ohwJ9Au/o3MHZunW9uMuRrdGKsReXZo5NwkQ7x?=
 =?us-ascii?Q?w3ky7GOex6oZmFMlcb658u5uQo33ux6FFwniVgoCKrGRkqWvhnl994OOjbir?=
 =?us-ascii?Q?eiqtA20M/Yey9LYCRg0y6Dt3ycH603ltBxW/XW2+xrsOcmXNsvaib+XMi1SV?=
 =?us-ascii?Q?oi9i9T9eRPCQVGkky/UZ9Mo2nyqVMY626NvA0OOx23H56kucP9GOpmb6kq0B?=
 =?us-ascii?Q?q8ypHkFKPFBaPtKVHvedHje7qMY6bUTJNDX3Uy5tLRQsr34xFHpfF6B1zsyS?=
 =?us-ascii?Q?snYEmnOp1bpnyYNf8y8Fy3TeXtkZi9Ck6MLR2sMc3cRMVPzlLeKlqdgHlst9?=
 =?us-ascii?Q?c8bY+fSgVIYJ8AykXjwAjelFueEpawRnQ6kPp7cbQiYOcWipAlCCPFfC0zIP?=
 =?us-ascii?Q?5hxwTyTiX7hRJeQeBHhRwbfEK+2MEm523bHOisjs6124d67y3BVa17AbDnV6?=
 =?us-ascii?Q?8Ig4MljkqznOowXpPglkf5mQ6wqkPFav35FnWlcs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563160b0-f101-4c0f-dd39-08dd97c9e11d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 18:12:27.7429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyJFOaSnPDz7LwOvIa4YPHrzZrD/oVX6evKk8NgHD1Db9mvzHyu9MfFn8kg/Eo/qVdW3Z+nh4Rb63lBR6DpadA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6123
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: rcdn-l-core-06.cisco.com

On Monday, May 19, 2025 1:55 AM, Chen Ni <nichen@iscas.ac.cn> wrote:
>
> Use eth_zero_addr to assign the zero address to the given address
> array instead of memset when second argument is address of zero.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
> drivers/scsi/fnic/fip.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
> index 6e7c0b00eb41..19395e2aee44 100644
> --- a/drivers/scsi/fnic/fip.c
> +++ b/drivers/scsi/fnic/fip.c
> @@ -200,7 +200,7 @@ void fnic_fcoe_start_fcf_discovery(struct fnic *fnic)
> return;
> }
>
> -     memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
> +     eth_zero_addr(iport->selected_fcf.fcf_mac);
>
> pdisc_sol =3D (struct fip_discovery *) frame;
> *pdisc_sol =3D (struct fip_discovery) {
> @@ -588,12 +588,12 @@ void fnic_common_fip_cleanup(struct fnic *fnic)
> if (!is_zero_ether_addr(iport->fpma))
> vnic_dev_del_addr(fnic->vdev, iport->fpma);
>
> -     memset(iport->fpma, 0, ETH_ALEN);
> +     eth_zero_addr(iport->fpma);
> iport->fcid =3D 0;
> iport->r_a_tov =3D 0;
> iport->e_d_tov =3D 0;
> -     memset(fnic->iport.fcfmac, 0, ETH_ALEN);
> -     memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
> +     eth_zero_addr(fnic->iport.fcfmac);
> +     eth_zero_addr(iport->selected_fcf.fcf_mac);
> iport->selected_fcf.fcf_priority =3D 0;
> iport->selected_fcf.fka_adv_period =3D 0;
> iport->selected_fcf.ka_disabled =3D 0;
> --
> 2.25.1
>
>

Hi Chen,

Thanks for these changes.
They look good to me.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
