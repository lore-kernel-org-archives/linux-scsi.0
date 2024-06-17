Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC131D952E;
	Mon, 17 Jun 2024 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718650606; cv=fail; b=qJCon4rsqFJz5tl/NWJ49y09nF8dZhzhXhLldWwZpp7/5oNVg4gfstu7aZDvYdiowjXuYwQCHkmOSclBQ0VoPJlBb/XpPAV8Ao23KknOvZ9wYL4agoc5/JfVsim0XzZUpDZfN9OwGM3r+wSpnrDkSvuiYtd6yV2tjuCbMSGLyyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718650606; c=relaxed/simple;
	bh=N23mA6q37XjVEulp/6lRuWKfHmiCpR/FXeyZjslNjts=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b7+Sb+lSD3ke6PIaymty4I7pyBFfZP7alHuHp7NELkirjzFiPpuT6o/acODJoIVscD1aElB6bjro7Ho2O/vAuBfrLed5al/+ATbqxqnER7QITymf6fjj83iZifPKzIDmnk8FlCB994q0UR3YKH+kxHt7gTheJpzPvh8NUabFsZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=d9VS36QI; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Aw42KTDt; arc=fail smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="d9VS36QI";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Aw42KTDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5544; q=dns/txt; s=iport;
  t=1718650604; x=1719860204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N23mA6q37XjVEulp/6lRuWKfHmiCpR/FXeyZjslNjts=;
  b=d9VS36QINBh1rmi1t2FYq6ajE3YxInVrOgDMYRqBFxYNSoP4qEFNqt5V
   I7UpE2ucBBVmYzICFqQxOi4QqxSN1gGKpmfLdpJvHOX0DqemXnjD0MtYU
   5Icfob21ptMVgiPkMLSiIyjDjGgD4lRZ+2x6TFWeqUavW6oNeMj6zSBXI
   Q=;
X-CSE-ConnectionGUID: c6Czinl+SGaXD8IC7uPL3g==
X-CSE-MsgGUID: Qus56jXLSQ6vIVu6HE0ASw==
X-IPAS-Result: =?us-ascii?q?A0AOAAC5hXBmmIUNJK1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEWBwEBCwGBcVJ6gR5IhFWDTAOETl+GTIIiA54MgSUDVg8BAQENAQFEBAEBh?=
 =?us-ascii?q?QYCFohfAiY0CQ4BAgICAQEBAQMCAwEBAQEBAQEBAQUBAQUBAQECAQcFFAEBA?=
 =?us-ascii?q?QEBAQEBHhkFDhAnhXQNhlkBAQEBAgESEREMAQE3AQQLAgEIDgoCAiYCAgIvF?=
 =?us-ascii?q?RACBAENBQgagl6CQiMDAaF3AYFAAoooeoEygQGCDAEBBgQF3XcJgRouAYgwA?=
 =?us-ascii?q?YFZiGMnG4INgRVCgWZRMT6CYQKBYhWDRDqCL4UJiTmDT4QiF4MSgiMCBhaBG?=
 =?us-ascii?q?YIWAXFYgm9qaRYkAgtBW4tKCUt9HANZIQIRAVUTFws+CRYCFgMbFAQwDwkLJ?=
 =?us-ascii?q?ioGOQISDAYGBlk0CQQjAwgEA0IDIHERAwQaBAsHd4FxgTQEE0YBDYEqiW8Mg?=
 =?us-ascii?q?QaCKSmBSyeBDIMOS2yEA4FrDGGIbIEQgT6BZgGDUE2EJx1AAwttPTUUGwUEO?=
 =?us-ascii?q?nsFrH4CPEwhCCgCOzsYLzQoAjqSMiRCAoJgSa1MgTMKhBOhZxeEBY0AmTSYZ?=
 =?us-ascii?q?SCjIIUgAgQCBAUCDwEBBoFlOoFbcBWDIlIZD44hGYNhxzl4OwIHCwEBAwmKa?=
 =?us-ascii?q?AEB?=
IronPort-PHdr: A9a23:a88oYxIBkfH3P2jJDdmcua0yDhhOgF28FhQe5pxijKpBbeH6uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1o2t2qjPx1tEd3lL0bXvmX06DcTHhvlMg8gJe3vBo/Whsef3OGp8JqVaAJN13KxZLpoJ
 0CupB7K/okO1JFvKKs61lPFo2AdfeNQyCIgKQeYng334YG7+5sLzg==
IronPort-Data: A9a23:vQHHNq7po29DnDrCjr/t5QxRtATHchMFZxGqfqrLsTDasY5as4F+v
 mMdWmrSOf+LNjf2L4tzYYji8xsGuseHy4RiHlNtqngyZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyKa+1H0dOC88BGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wq86UzBHf/g2QoajxNtPrdwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eNtMz6OdxBSJ12
 vUoBGAsRU+ev8btz+fuIgVsrpxLwMjDNYcbvDRryivUSK9/B5vCWK7No9Rf2V/chOgXQq2YP
 JRfMGEpNU+bC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OK8YIePIIfXHK25mG6hu
 3mboWbJJiojasK+9yfb0l/0r9TQyHaTtIU6T+DgqaUw3zV/3Fc7DBwQSEv+ovSjjEO6c8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BpRUHWvJOHOAgrgKA0KzZ50CeHGdsc9JaQNUisMlzTjsw2
 xrQxpXiBCdkt/ueTnf1GqqoQS2aMnY+P24EYWw/YgI1z4nCi94utjaUQYM2eEKqteHdFTb1y
 jGMiSExgbQPkMIGv5lXG3ia01pAQbCXF2YIChXrY46z0u9uiGeYi2GA4Fzf67NLK5yUCwDY+
 nMFgMOZqusJCPlhdRBhos1TTNlFBN7cbFUwZGKD+bF6rlxBHFb4I+htDMlWfhsBDyr9UWaBj
 LXvkQ1Q/oRPG3ChcLV6ZYm8Y+xzkvGwSIq/CKCOMIEXCnSUSONh1Hw3DaJ39z2y+HXAbYljU
 XtmWZ/1XCtCUfQPIMSeF7ZMuVPU+szO7TiOHc+glUvPPUu2b3+OQrBNK0qVcu089+uFpg6Tm
 +uzxOPUoyizpNbWO3GNmaZKdAhiBSFiWfje9ZcNHsbdeVUOJY3UI6KLqV/XU9Y7z/09eyah1
 izVZ3K0P3Km3CKfeVrbMioyAF4tNL4mxU8G0eUXFQ/A81AoYJ2k6+EUcJ5fQFXt3LYLISJcJ
 xXdR/i9Pw==
IronPort-HdrOrdr: A9a23:wT6R/axOGwDiNw61WJwpKrPxaegkLtp133Aq2lEZdPULSL36qy
 n+ppQmPEHP6Qr5AEtQ6OxoWJPtfZvdnaQFmLX5To3SLDUO31HYYr2KjLGSjAEIfheOlNK1up
 0QDpSWZOeAamSSyPyKnjVQcOxQgeVvkprY+ds2pk0FJWoFGsQQizuRSDzrbXGeLzM2fabRYa
 DsnPav0ADQAkj/AP7LYEUtbqzonfGOvpTgZhINGh4g7yezrR7A0tTHOind9C0zFxdUz5kf0U
 WtqWHED6OY3M2T+1v57Sv+/p5WkNzuxp9oH8qXkPUYLT3ql0KBeJlhc6fqhkF3nMifrHIR1P
 XcqRYpOMp+r1nLeHuunBfr0w78lB4z9n7Zz0OCi3eLm726eNt6MbsFuWtqSGqf16MShqA77E
 uN5RPBi3NjN2KFoM063amRa/glrDvunZNoq59hs5UWa/ptVFYWl/1ewKuQe61wQR4TL+scYb
 NTJdCZ6/BMfVyAaXfF+mFp3dy3R3w2WgyLW04Yp6WuonJrdV1CvgMlLfYk7zw93YN4T4MB6/
 XPM6xumr0LRsgKbbhlDONERcesEGTCTR/FLWrXeD3cZe06EmOIr4Sy7KQ+5emsdpBNxJwumI
 7ZWFcdsWIpYUrhBcCHwZUO+BHQR2e2Wyjr16hlltVEk6y5QKCuPTyISVgoncflq/IDAtfDU/
 L2I55SC++LFxqmJW+I5XyJZ3B/EwhobCROgKdPZ7unmLO+FrHX
X-Talos-CUID: =?us-ascii?q?9a23=3AgV9Jmmrjo6QLWyjNSu2lN5TmUct7WW/cynOTGGC?=
 =?us-ascii?q?xOUo5aZbKVGe0o6wxxg=3D=3D?=
X-Talos-MUID: 9a23:nHaUDgbuvn8L9uBTjiL32W9gBONT2vqwKX4Qz7Ur4+C/Knkl
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by alln-iport-8.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 18:56:37 +0000
Received: from rcdn-opgw-1.cisco.com (rcdn-opgw-1.cisco.com [72.163.7.162])
	by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id 45HIub6v010906
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 18:56:37 GMT
X-CSE-ConnectionGUID: /NXqXS1ZSeGLMK3IOOfJwg==
X-CSE-MsgGUID: tADo/0r2R0iFi4jqNWv+HQ==
Authentication-Results: rcdn-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,245,1712620800"; 
   d="scan'208";a="12388687"
Received: from mail-mw2nam10lp2049.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.49])
  by rcdn-opgw-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 18:56:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=la7qvFetxXHTU8INfjTXN+MXWiwPI/oDWfbzC6JYYvG6tmpRWE8bdPtB8Y0wJBIdQpGnWvDZuiEI75RBNTIsHrKNML6jR8M0J+PjEfitaP6kPYwXA2F064ZeinZRFsf37IMUByup46B0j1ZtFmHdKZiJyFDmNkP9ykgPeQMbkuGnukwPmQpbdNj6TIuLCUVoOcQP5wP133nMiiwj7NnTHDYPcKW9QRFCYJSdEjT12nNYzijS6vIpBVFxX0pgaiIM08/f+unm6fT6HJWVsHiaU3Rdrkt8BKjEQVKEYxjRN7fvFNiw9Zk/aRTw8eV4dHRyVt6xN0CYiqVMwohLd1MPMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N23mA6q37XjVEulp/6lRuWKfHmiCpR/FXeyZjslNjts=;
 b=juA4CdmTJPHI7D9SKDnOIYS8sajFzQRLc5mNhT4zKOSLnXoRa9tLKZ3tJx99o8OBeFG0itNKok9xOaCjMwxk09+kdEylEKQ0ICm+ieVdCHhEOYLvVgNEqy11G+J5RdTuEXIZn86C+RobOCmYlI0NTmpIW2UUPx4v8RtiKkIgAjaxhJorLGgF5+H5D4mpnDxe8XatO6rzzLP1oapYn8f/sE5M5U02NNluNztW4wjZYXqifxTw7VTiaOGN4EL5D/kCdLcKXwAeze5yeFGjpsPvRo38npNe4pyQQKm8BKF/plUeS5OGrTg+1NTEUJN28JAQBHOSgqn6bYeRCm1z6sdqmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N23mA6q37XjVEulp/6lRuWKfHmiCpR/FXeyZjslNjts=;
 b=Aw42KTDtB205QCG52dmnA//yRVzKUUy/6WkbRnxiSY6jEqrKmrCy35VO1aueW6d6gd/Ur/Is/nc7sstMc7G2T+v8jgf0OeEMpTRXlWd+mnTZ0MhXp/kUiYjXSl6xiuMa8q03cuKvTRhgMR1sYcU6iGZieKrA8Y+us/Jtr64RzaE=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SN7PR11MB7492.namprd11.prod.outlook.com (2603:10b6:806:347::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 18:56:34 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 18:56:34 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@suse.de>,
        "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>,
        "Masa Kai (mkai2)" <mkai2@cisco.com>,
        "Satish Kharat
 (satishkh)" <satishkh@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Thread-Topic: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Thread-Index: AQHau4DaQOSKJ2YKKUeWgcrHrkbAXbHDsecAgASDIGCAAFoqAIADxnDg
Date: Mon, 17 Jun 2024 18:56:34 +0000
Message-ID:
 <SJ0PR11MB58965477CD10B26A77F2E9FDC3CD2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-8-kartilak@cisco.com>
 <43b8bd73-efca-45b0-9526-3c19c8cb3713@suse.de>
 <SJ0PR11MB5896B7E6DCABDE98D4ADBFA1C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <4818863e-8ad2-4aa7-bed1-103d2801faa6@suse.de>
In-Reply-To: <4818863e-8ad2-4aa7-bed1-103d2801faa6@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SN7PR11MB7492:EE_
x-ms-office365-filtering-correlation-id: 77daa86c-a61b-402b-741c-08dc8eff3571
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?NENJaU14dFZscU1xc1RCM1lhdW1PZWEremcydmtCUFRWNDdqTE9jSlZlY2VL?=
 =?utf-8?B?VkdGK3NGR2dRUEl1Rmt3S2x1NmxzVGQvcGZCeG5HN3NHZUhyV1ZKcUd0M3Qr?=
 =?utf-8?B?RnpFeWU3NFg0OWV1UHcrcWxUOTZteVh3d2tsWE42a0xNK0ZlZVhpdE94VlNl?=
 =?utf-8?B?V2RUbmFyVVloMXJ0SXJkdEdKdzM0Nnh5WWFhcGRnUXd6Yy91SEw3TGFOUS9H?=
 =?utf-8?B?amZHeGtURENGeXdMWnRGMG1aV3dsaFpRUnhuMUxzcnhYZ2QyOGlsSFJ2cWth?=
 =?utf-8?B?WHlMNFFpZ1pZSFMxN2dFMnNieEVoWkJTQ2o3ZUs5TGswNk9PKzJUU0EyY1pZ?=
 =?utf-8?B?Q3Z3N3hvL21FQWZrYS9XUGtSVW02Vmp5RllHQ1hJTWNwRUFiNlR5UmlmaHZM?=
 =?utf-8?B?M3lIN3hZQU9DQTZDS1UxOEdvZXVmRWpLZkJjcUhyY05GeDhxQkp3blZHd0Nl?=
 =?utf-8?B?TDl3MEdhc0VlMElRMmdZMDlMenF6a1hqWTJnMU03dXNjZTM2cmlrS2lFVmln?=
 =?utf-8?B?b00vL2FTVFF6RUhkWERCRE1WUmFsL25zN3lxT09XUDNzY1RFTzdDNEJxMGJP?=
 =?utf-8?B?TGNZTzJjWEdYZExSd3QrODZyQmFJUTd4ODVBd2R4VlFvT082UnZ5Uy9jYVdM?=
 =?utf-8?B?TFhxUVFlczhJYTMvaTl4Mlo4V0ZuZXkyajRJSDhtWDJqMmltaWVGWm5EVGt4?=
 =?utf-8?B?SUVjdE9mV0NqbXV1bHdmZG1zTVA0QXV6WmtqS1lVZzNWN3NtU2VtK04ydGNo?=
 =?utf-8?B?bHNIbWUzY1Y3aHpObzRDbTVQNXhGVkhNZkVoQjRYZm03U3AyT2dsMVRaa0pu?=
 =?utf-8?B?SGkrTjY1d2cvNzUvVklrK2pMdDlYclBOa3Nycy9UaURxT0lyUk1vTkViTHV0?=
 =?utf-8?B?SHl5aVFLSlNLVUp6SG5wU2d1eVo4LzJpRWhuM2pmM212bnZFVlhCVmEwQ0xX?=
 =?utf-8?B?R3VjMkMzVmsvR1FJVmhpNVcxZ1ZVQ0VCVDMwQzRmRGtXS2VsZUtJSEhSRkoy?=
 =?utf-8?B?d1UvUElSM2ZHa3lGSlIwb3A0MDJGZ2MvZW8wdXRIVXhjTVNlZTZXeVpPdDVt?=
 =?utf-8?B?L3FzK2hnTmZVanl3bS9QSGEvbWpZc3FLYTJxRDdYSHBXdTdVamg3Y2FvVmlp?=
 =?utf-8?B?am9NaTYraTJPQVQ1aDZKZjl3UDg5NnFpc2lIQ1Nhbk5Na203NU9KNnJ4engx?=
 =?utf-8?B?cnFrcWNaN2kvM0ZKQUpuYXZwS1NnMnVoVEhIMVVTR0RCdmZMUnZTdlFsQ2xq?=
 =?utf-8?B?NndJQ1hMM1F4ZVpxYTRaNHlLa0prZ2R3QnhycGZockRjaGZ4NGk4NDNoVi9O?=
 =?utf-8?B?T2xCZWlpRmRIWmNXNG13dGdycWxVa1hKdVVkbjBTVlp4Mk52STVuWTBiNWRr?=
 =?utf-8?B?RWs1eUdDdm5DOFVRelJLWVNFRFYzK0FKZElxOTNGbnpBTi9iUVJZNExucDli?=
 =?utf-8?B?ZzEyU3RmYy9CcUNDWStoNFg4UzFDUkVKMWZrb0JpbWRYSFdqYmZsL0IwWDU1?=
 =?utf-8?B?Z3lLdHlKR2xZUmlzblJOSExSRmgrWXF2T2ZJcFViN0pIUHhuSzZWRTFoS3Y0?=
 =?utf-8?B?Q005amtodlFQTmxscFRzcEQ3bk8xbVJad1o3K3QrREFPQUlJRXB0TysrR0JT?=
 =?utf-8?B?Q3NhdzIrWEhPNjVsZEltL3lwWWdQVExuWlZXT1VCS1V0R1V4OWpEUUUyZkZX?=
 =?utf-8?B?eElGdVRFN2hXWDNCM3ExL2RBOUQ3b1FqcExCV1VCVTlzTzdiZmZYZ0lLaEhI?=
 =?utf-8?B?cGw0cXlKWHpGMVpBUHVZRkRKSTJGZEwrdVgzTzZqRk54NXhtU0E1aU4wbmhT?=
 =?utf-8?Q?apwehCa7XaBc7BKzRVakbmMZ2HvLpy8Rv6A1o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VWg3TitTTlpGdGxEd0VBTWVKU0xSenVkWml3azN6RkYrOENPckFLYWdPTEc5?=
 =?utf-8?B?T1B3aDJMWWhlRXN2RThBL2w1MTVDUHlFRU5oYk4rekZ4aHczWGN1WTl1RDM3?=
 =?utf-8?B?UkpGVnZHZ0tNSEl1OW11N2hwQVJSN2V2a3dXdStURm1NbUlQRXd2ZW8zQUVV?=
 =?utf-8?B?djNFaE05ckhkSHJSZWFtUnFLTlBTY09tcHVjOFFNUGdBTll0Vm5pclRoc2ov?=
 =?utf-8?B?czJ1YjJXZXhhQTJmZ205LzEzbTlza2pJN09CUHRkVnJUWGZKNEdkSUtUVDAv?=
 =?utf-8?B?NWxjeHR2NFAzWkNwUWJuY0VCT2ZrbzJOc0xwRTlXUytDdjRKaW9udWNnRzdZ?=
 =?utf-8?B?bitFbnJxT2RIZnpGUERQZ3ZURVBDZklOeFRMZmtKaXJQSnRPd0xFTE5mdGE4?=
 =?utf-8?B?R1QzaktGZXRQSVhnWlc0VklOejVPRHNYcFlUcTduZUR3T2NkemFqSjRIQWNT?=
 =?utf-8?B?SUZkUWt0b3d4RDNJSHphdUpMazZ4bW16ZmY5c0RsSmlYN0VpVFVpV3NzejFY?=
 =?utf-8?B?SzNweUNFQVZoM2taSzlnaHRNbGgyTXc1RzZWanJzVDI0VUc3NHNZdFhnU0xO?=
 =?utf-8?B?U2NmL0phaGgzU2R0cHoxWnc3RC9xaTg5NHBvSTd2NXJpdXRxZ1dMazgvalMx?=
 =?utf-8?B?WXRhSTI1bTB1dzBNaTZBOW5DWmdsb0NzTndPZHNkc1VRVkpzMGtiYXRtR2da?=
 =?utf-8?B?Y09zTXJmY1FlYjhrRGtadEVCZWErMk9mZ0FBZDVmTG5IRmxvdGsrc3FXRGVY?=
 =?utf-8?B?dXpNcTFyNG5NSzJ0WmdzcDlPazVxQ0s0ZDNqSjBLWlVNZ0RaNUYzNUV3bzlP?=
 =?utf-8?B?YjFjSEg2RDRCTzJVMXNJakIwOGFNRjF4U0JoeGVhY1Byc1B5b2RVWndhWW41?=
 =?utf-8?B?NEREdEl5anlLcUpEMnJUSFlsb2VBZkprMGZpb3ZteGx5WEkxbEMrWUFSQ09r?=
 =?utf-8?B?TTQvZytRU2RJNVNKU1BQUnhxbzNRL0ZlbnpSUTRNb20xY2FIMmx4K1duSmhx?=
 =?utf-8?B?OUZhbjg4L0o1YXlJTlY5SUIvTFBURlNjaU5DbndzcllHSDR6RUM1cWk5QlF5?=
 =?utf-8?B?NTNXRmx1Rjc5ZklZZzFXTGRSMG9iMjl4L0VtRXFrQnBwa01mNE0wNnpFVWZE?=
 =?utf-8?B?Y0pEczJDdG1TT3dvU0cyMDNaV2xyUi9UL3QvTGhYR2RTaTdhS3R3YW9xNVVv?=
 =?utf-8?B?YXMwNjhodUxKN1p0VjNTNFV5Tk9LNnZTcVJaLzNZak1uSVVPb2pVMEh2SDM5?=
 =?utf-8?B?S3dZS0hxT0NSSlNpTjA2d1lCSUFwakZtaVRwOEMyb21HUlYrakZQZ2xPQis0?=
 =?utf-8?B?WnJTK0VJelNFL2FDQmJ6bUZPSU9wMVg4QXRJbVlpaitVaWRXeDQxM2VIWjh1?=
 =?utf-8?B?WStSQVNxei9KNkdjS3A1VEcxbjRUMEY0OWNmU1l5eTFEMWdTS2hxVWV6Kzg1?=
 =?utf-8?B?blVLQ1dQSUtnU0g2M0hVdmFCNklIWmJUNXIvYjZxd2ZsaERQbTl1eTFBTXph?=
 =?utf-8?B?VzVZQnBaaFBoSTNiMVlKOFp0RGFpMnV0REJKRzA2cHV2QWU4bzAzcjhvMG8v?=
 =?utf-8?B?bG44L2U0UGZBYS9ZakkyMnd5V0xUZlRXa3UvdVlXUzFJUUtzKzNQK0lQL2ox?=
 =?utf-8?B?RjBCRjA4enExYUxYd1d1R0ppeE92SnUzVlQ2ZkQ0Y1dER010MTBmd3BsRkJO?=
 =?utf-8?B?NWM0ZTFZa0xEQ3d6TE1na3p4YmJFM0poaWJUWWlOL1hiSm1PZVBCSjg3MHov?=
 =?utf-8?B?MWlPWkF4d3hDWnA0ekIwKzMzYVFFOXhvcFhQQlRzUGQyazR4QmE0Q2tzM1Q2?=
 =?utf-8?B?QWliT0JzRjd0QUxwR1htSU9DUjNhclFOZGZlYTdQZ0xVRWVSWUFwL1hoMDB3?=
 =?utf-8?B?OFpwRU5KQjBIRGVVU2h1YlY0SC9kQ1BuOThUeW9kVDFyOEdTa3orRlJNbW5S?=
 =?utf-8?B?N0cyelovcTlJOFBzd3NyVDBvdll1Z2ZMN1diaEZjalo4L2RWNUxCRE5NeTQx?=
 =?utf-8?B?Q1U2cWZKeWlZTXFrYVp4bWZPNHcvYTlzMmZxTHZock42YXZpUng0VHhxRldQ?=
 =?utf-8?B?UHVWOG5FdktTZCtuTCtiNDB0TTBVS1lVdXI3TXpEa25VZjVZVmxiYVloWjFk?=
 =?utf-8?Q?vVaDdtLIVhEGJ3YOXfhGq9Pfc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77daa86c-a61b-402b-741c-08dc8eff3571
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 18:56:34.3492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uglksnSGNsH3Acpd7xL5Yi6udqlmeUfBkVFnKGcXRehhrfYRY+qSnWR+P4o+XfRPagoeKflVqcKpJ9LSwp4ang==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7492
X-Outbound-SMTP-Client: 72.163.7.162, rcdn-opgw-1.cisco.com
X-Outbound-Node: alln-core-11.cisco.com

T24gU2F0dXJkYXksIEp1bmUgMTUsIDIwMjQgMjowNSBBTSwgSGFubmVzIFJlaW5lY2tlIDxoYXJl
QHN1c2UuZGU+IHdyb3RlOg0KPg0KPiBPbiA2LzE1LzI0IDA1OjQ0LCBLYXJhbiBUaWxhayBLdW1h
ciAoa2FydGlsYWspIHdyb3RlOg0KPiA+IE9uIFR1ZXNkYXksIEp1bmUgMTEsIDIwMjQgMTE6NDgg
UE0sIEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPiB3cm90ZToNCj4gPj4NCj4gPj4gT24g
Ni8xMC8yNCAyMzo1MCwgS2FyYW4gVGlsYWsgS3VtYXIgd3JvdGU6DQo+ID4+PiBBZGQgYW5kIGlu
dGVncmF0ZSBzdXBwb3J0IGZvciBGQ29FIEluaXRpYWxpemF0aW9uDQo+ID4+PiAocHJvdG9jb2wp
IEZJUC4gVGhpcyBwcm90b2NvbCB3aWxsIGJlIGV4ZXJjaXNlZCBvbiBDaXNjbyBVQ1MgcmFjaw0K
PiA+Pj4gc2VydmVycy4NCj4gPj4+IEFkZCBzdXBwb3J0IHRvIHNwZWNpZmljYWxseSBwcmludCBG
SVAgcmVsYXRlZCBkZWJ1ZyBtZXNzYWdlcy4NCj4gPj4+IFJlcGxhY2UgZXhpc3RpbmcgZGVmaW5p
dGlvbnMgdG8gaGFuZGxlIG5ldyBkYXRhIHN0cnVjdHVyZXMuDQo+ID4+PiBDbGVhbiB1cCBvbGQg
YW5kIG9ic29sZXRlIGRlZmluaXRpb25zLg0KPiA+Pj4NCj4gPj4gQXJlbid0IHlvdSBnZXR0aW5n
IGEgYml0IG92ZXJib2FyZCBoZXJlPw0KPiA+Pg0KPiA+PiBJIGFtIF9wb3NpdGl2ZV8gdGhhdCB0
aGUgb3JpZ2luYWwgZm5pYyBkcml2ZXIgX2RpZF8gZG8gRklQLg0KPiA+PiBXaGF0IGhhcHBlbmVk
IHRvIHRoYXQ/DQo+ID4+IFdoeSBjYW4ndCB5b3UganVzdCB1c2UgdGhhdCBpbXBsZW1lbnRhdGlv
bj8NCj4gPj4NCj4gPj4gQW5kIGlmIHlvdSBjYW4ndCB1c2UgdGhhdCBpbXBsZW1lbnRhdGlvbiwg
c2hvdWxkbid0IHRoaXMgcmF0aGVyIGJlIGEgbmV3IGRyaXZlciBpbnN0ZWFkIG9mIHJlcGxhY2lu
Zw0KPiA+PiBtb3N0IGlmIG5vdCBhbGwgZnVuY3Rpb25hbGl0eSBvZiB0aGUgb3JpZ2luYWwgZm5p
YyBkcml2ZXI/DQo+ID4NCj4gPiBUaGFua3MgZm9yIHlvdXIgcmV2aWV3IGNvbW1lbnRzLCBIYW5u
ZXMuDQo+ID4gQXMgeW91IGNhbiBzZWUgZnJvbSB0aGlzIHBhdGNoLCBhbmQgc29tZSBvZiB0aGUg
bGF0ZXIgcGF0Y2hlcywgZm5pYyBkcml2ZXIgd291bGQgYmUgcmVsaWFudCBvbiBGRExTLg0KPiA+
IEZETFMgaGVscHMgc29sdmUgc29tZSBvZiB0aGUgaXNzdWVzIHRoYXQgd2UgaGF2ZSBzZWVuIGlu
IG91ciBoYXJkd2FyZSB3aGVyZToNCj4gPg0KPiA+IDEpIHRoZSBhZGFwdGVyIGhhbmdzIHN1Y2gg
dGhhdCBGQyBvZmZsb2FkIGlzIGltcGFjdGVkLA0KPiA+IDIpIHRoZSBmYWJyaWMgZ2V0cyBpbnRv
IGEgYmxhY2tob2xlIHNpdHVhdGlvbiwgd2hlcmUgbm90aGluZyBjb21lcyBvdXQgb2YgdGhlIGZh
YnJpYy4NCj4gPg0KPiA+IFRoZXNlIHNpdHVhdGlvbnMgZ2V0IGVhc2lseSBlc2NhbGF0ZWQgYW5k
IGFyZSBxdWl0ZSBoYXJkIHRvIGRpYWdub3NlLg0KPiA+IEZETFMgaGFzIGhlbHBlZCB1cyBpbiB0
aGVzZSBpbnN0YW5jZXMgdG8gY2hhcnQgYSB3YXkgZm9yd2FyZCwgYW5kIHRvIHNvbHZlIHRoZSBp
c3N1ZS4NCj4gPg0KPiA+IENpc2NvIGhhcyBiZWVuIHNoaXBwaW5nIGFzeW5jIGZuaWMgZHJpdmVy
IGJhc2VkIG9uIEZETFMgZm9yIHRoZSBwYXN0IHNpeCB5ZWFycy4NCj4gPiBDaXNjbyBvZmZpY2lh
bGx5IHN1cHBvcnRzIHRoZSBhc3luYyBkcml2ZXIuDQo+ID4gVGhlIGFzeW5jIGRyaXZlciBoYXMg
c3VwcG9ydCBmb3IgUEMtUlNDTiAoc2VlbiBpbiBhIGxhdGVyIHBhdGNoKSBhbmQgTlZNRSBpbml0
aWF0b3JzLg0KPiA+IFNpbmNlIHRoZSBhc3luYyBkcml2ZXIgaGFzIGJlZW4gaW4gdGhlIGZpZWxk
IGZvciBxdWl0ZSBhIHdoaWxlIG5vdywgaXQgaXMgYSB3ZWxsLXNlYXNvbmVkIGRyaXZlci4NCj4g
PiBJdCBoYXMgYWxzbyBnb25lIHRocm91Z2ggbG90cyBvZiBRQSBjeWNsZXMgdG8gcmVhY2ggYSBs
ZXZlbCBvZiBzdGFiaWxpdHkgdG9kYXkuDQo+ID4gVGhlcmVmb3JlLCB0aGUgQ2lzY28gdGVhbSBm
ZWVscyBjb21mb3J0YWJsZSBpbiB1cHN0cmVhbWluZyB0aGlzIGNoYW5nZS4NCj4gPg0KPiA+IEtl
ZXBpbmcgaW4gbGluZSB3aXRoIHRoZSB1cHN0cmVhbWluZyBiZXN0IHByYWN0aWNlcywgb3VyIHBy
ZWZlcnJlZCBsaW5lIG9mIGFwcHJvYWNoIGlzIHRvIG1vZGlmeQ0KPiA+IHRoZSBleGlzdGluZyBk
cml2ZXIgd2l0aCB0aGlzIGNoYW5nZS4NCj4gPiBJIGFzc3VtZSB0aGF0IHRoZXJlIHdpbGwgYmUg
Y2hhbGxlbmdlcyBpbiBtYWludGFpbmluZyB0d28gc2VwYXJhdGUgdXBzdHJlYW0gZHJpdmVycyBh
bmQgaGVuY2UgdGhlDQo+ID4gY3VycmVudCBhcHByb2FjaC4NCj4gPiBIb3dldmVyLCB3ZSB3YW50
IHRvIGJlIG1pbmRmdWwgb2YgeW91ciBjb21tZW50cy4NCj4gPiBJZiB5b3UgYmVsaWV2ZSB0aGF0
IGEgbmV3IGRyaXZlciBpcyB3YXJyYW50ZWQgYmFzZWQgb24gdGhlc2UgY2hhbmdlcywgdGhlIENp
c2NvIHRlYW0gY2FuIGV2YWx1YXRlDQo+ID4gdGhhdCBhcHByb2FjaC4NCj4gPiBQbGVhc2Ugc2hh
cmUgeW91ciB0aG91Z2h0cyB3aXRoIHVzLg0KPiA+DQo+IEluIGdlbmVyYWxseSwgYWRkaW5nIG5l
dyBmdW5jdGlvbmFsaXR5IHRvIGFuIGV4aXN0aW5nIGRyaXZlciBpcyB0aGUNCj4gY29ycmVjdCB3
YXkgdG8gZG8uIFdoYXQgSSBhbSB3b3JyeWluZyBhYm91dCBpcyB0aGF0IHdlIGF2b2lkIGNvZGUN
Cj4gZHVwbGljYXRpb24gKGhlbmNlIG15IGNvbW1lbnQgZm9yIEZJUCBoYW5kbGluZyksIGFuZCB0
aGF0IGV4aXN0aW5nDQo+IGZ1bmN0aW9uYWxpdHkgaXMgbm90IGltcGFjdGVkLg0KDQpUaGFua3Mg
Zm9yIHlvdXIgY29tbWVudHMsIEhhbm5lcy4gDQpJIHVuZGVyc3RhbmQgeW91ciBjb25jZXJuLiBJ
biB0aGlzIHBhdGNoLCBJJ3ZlIHJlcGxhY2VkIHNvbWUgb2YgdGhlIGV4aXN0aW5nIGNvZGUNCnRv
IHVzZSBGRExTIHRvIGF2b2lkIGNvZGUgZHVwbGljYXRpb24uIA0KDQpJJ3ZlIHRlc3RlZCB0aGUg
d2hvbGUgcGF0Y2ggc2VyaWVzIHdpdGggYWxsIHRoZSBGRExTIGNoYW5nZXMgb24gb3VyIGJsYWRl
IGFuZCANCnJhY2sgc2VydmVycyBmb3Igc2V2ZXJhbCB3ZWVrcyB0byBfbm90XyBpbXBhY3QgZnVu
Y3Rpb25hbGl0eS4gDQooUGxlYXNlIHJlZmVyIHRvIHRoZSBjb3ZlciBsZXR0ZXIgdG8gbm90ZSB0
aGUgc2V0IG9mIHRlc3RzIHBlcmZvcm1lZCB0byB0ZXN0IEZETFMpLg0KDQpUaGVyZWZvcmUsIGlm
IHRoZSBlbnRpcmUgcGF0Y2ggc2VyaWVzIHdlcmUgdG8gYmUgYXBwbGllZCwgYmFzZWQgb24gbXkg
dGVzdHMsIA0KZm5pYyBkcml2ZXIgYmFzZWQgb24gRkRMUyBzaG91bGQgd29yayBzZWFtbGVzc2x5
Lg0KUGxlYXNlIGxldCBtZSBrbm93IGlmIHlvdSBoYXZlIGFueSBxdWVzdGlvbnMgcmVnYXJkaW5n
IHRoaXMuDQoNCj4gQnV0IHdoZW4gYWRkaW5nIG5ldyBmdW5jdGlvbmFsaXR5IG9uZSBhbHdheXMg
aGFzIHRvIGNoZWNrIGhvdyBtdWNoDQo+IHNoYXJlZCBmdW5jdGlvbmFsaXR5IHRoZXJlIGlzOyBp
ZiB0aGVyZSBpcyB2ZXJ5IGxpdHRsZSBvdmVybGFwIGl0DQo+IHdvdWxkIG1ha2Ugc2Vuc2UgdG8g
c3BsaXQgdGhlIGRyaXZlciBpbiB0d28uDQo+IEhvd2V2ZXIsIHRoYXQgaXMgcGVyc29uYWwgcHJl
ZmVyZW5jZTsgaWYgeW91IHRoaW5rIHRoYXQgdGhlIGRyaXZlciBpcw0KPiBlYXNpZXIgdG8gbWFp
bnRhaW4gYXMgYSBzaW5nbGUgZHJpdmVyLCB0aGF0J3MgZmluZSwgdG9vLg0KPiBCdXQgeW91ciBl
ZmZvcnQgaW4gdXBzdHJlYW1pbmcgdGhlIGRyaXZlciBpcyB2ZXJ5IG11Y2ggYXBwcmVjaWF0ZWQu
DQo+IEtlZXAgdXAgdGhlIGdvb2Qgd29yay4NCj4NCg0KVGhhbmtzIGZvciB5b3VyIGVuY291cmFn
aW5nIHdvcmRzLCBIYW5uZXMuDQpCYXNlZCBvbiBteSBwcmV2aW91cyBjb21tZW50cywgd2UgKHRo
ZSBDaXNjbyB0ZWFtKSBmZWVsIGl0IGlzIGVhc2llciB0byANCm1haW50YWluIGEgc2luZ2xlIGRy
aXZlci4gV2Ugd2lsbCBiZSBtaW5kZnVsIG9mIHlvdXIgY29tbWVudHMgd2hpbGUNCm1ha2luZyBj
aGFuZ2VzIGZvciB0aGUgbmV4dCB2ZXJzaW9uIG9mIGNoYW5nZXMuDQoNClJlZ2FyZHMsDQpLYXJh
bg0K
