Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572833D60;
	Sat, 15 Jun 2024 03:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718423319; cv=fail; b=l4r87T+YtCTT4A9MeuwDsfdz9ViKpbn4VzPiF+P6Wp9kGkYAu9+owbUoBcT4aUpl2AYjRYJ7VMw+dFZYpbiIKRalUzj21oGePJ8Hb8wK61At2X5qCCawYnBTZyV2tASDgVARUHjC6IFGwZXttfRgpY+0BT8GfjE8kNScKsIHdZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718423319; c=relaxed/simple;
	bh=f/pdg1AUkO/I++tDcH7oulIcXocc3O3VIuctQouDDsc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LL7tmah/RI7hCkSm8ctM1xrWB7fkv9UmR7/2eSRLKrqZ9CFpqnLLyMT8Cmtwn7YmCe7ibppUxlMDsFOXLVF7V+WIJ7Cw/mEcYETQtEVHGkOddKaPNUHJ5TydUWyK3bJd76dOQbEArhNDHIMi5QFyMjU9BWPt9wswN45dxvr7M3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=a+cc8wPE; arc=fail smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="a+cc8wPE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2964; q=dns/txt; s=iport;
  t=1718423317; x=1719632917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f/pdg1AUkO/I++tDcH7oulIcXocc3O3VIuctQouDDsc=;
  b=a+cc8wPEkQn5IzXgQ1ONsJZBO1RYyQ7TT7Op9tkTbEpGaPHtTFAEDDrH
   HNvVHpfjHjEp35wGKK1mqWIiXPpGX3rvdUd29U1NCaFkPVddfZRupRg0r
   vMXFgXkvqTjI5ORaxWdcOIPN9sHaLw/yXhJhNMJr6BC1sHqZ4D6Q4HWLj
   k=;
X-CSE-ConnectionGUID: Wj98OjnsQ4Gml+jUZIBZaQ==
X-CSE-MsgGUID: jfEQukkTQCqkOgxwRraAFA==
X-IPAS-Result: =?us-ascii?q?A0APAACxDW1mmJBdJa1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEWBwEBCwGBcVJ6gR5IhFWDTAOETl+GTIIiA54MgSUDVg8BAQENAQFEBAEBh?=
 =?us-ascii?q?QYCFohdAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEGAQEFAQEBAgEHBRQBAQEBA?=
 =?us-ascii?q?QEBAR4ZBRAOJ4YBhlkBAQEBAxIREUUQAgEIDgoCAiYCAgIvFRACBAENBQgaQ?=
 =?us-ascii?q?4IbgmUDAaJaAYFAAoooeoEygQGCGAXeAIEaLgGIMAGBWYhjJxuCDYEVQoI3M?=
 =?us-ascii?q?T6ERRWDRDqCLwSGBYgCOIgEgxWCGguDToYjJgtDK4tmCUt9HANZIQIRAVUTF?=
 =?us-ascii?q?ws+CRYCFgMbFAQwDwkLJioGOQISDAYGBlk0CQQjAwgEA0IDIHERAwQaBAsHd?=
 =?us-ascii?q?4FxgTQEE0YBDYEqiW8Mgy8pgUkngQuDDktshASBawxhiG6BEIE+gWYBg1RMh?=
 =?us-ascii?q?BsdQAMLbT01FBsFBDp7BaxuAUBJBhMuCjCBQwEjBpMQCgqDEEmtTIEzCoQTo?=
 =?us-ascii?q?WcXhAWNAJNlhU+YZSCCNKYMAgQCBAUCDwEBBoFlOoFbcBWDIlIZD446zDl4O?=
 =?us-ascii?q?wIHCwEBAwmKaAEB?=
IronPort-PHdr: A9a23:wiLAIhMTCvsLIJKqGDsl6nfPWUAX0o4cdiYP4ZYhzrVWfbvmo9LpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgrDmgKUYAIM/lfBXJp2GqqzsbGxHxLw1wc+f8AJLTi820/+uz4JbUJQ5PgWn1bbZ7N
 h7jtQzKrYFWmd54J6Q8wQeBrnpTLuJRw24pbV7GlBfn7cD295lmmxk=
IronPort-Data: A9a23:yES/M6h2XZOJM1TVH8u1kjZFX1617xEKZh0ujC45NGQN5FlHY01je
 htvXWyFOf3YYWejet1xPI/g8EJQuZ7dzdBqT1FlpHhmEXtjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+1H1dOCn9CEgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZWPULOZ82QsaD5Mtfvf8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 woU5Ojklo9x105F5uKNyt4XQGVTKlLhFVTmZk5tZkSXqkMqShrefUoMHKF0hU9/011llj3qo
 TlHncTYpQwBZsUglAmBOvVVO3kWAEFIxFPICUe94Jy0zUvdSifDxvEtDnwEHKcq898iVAmi9
 dRAQNwMRgqIi+Tzy7WhR6w8wM8iN8LseogYvxmMzxmAUq1gGs+FEv6MvIMEtNszrpgm8fL2Z
 MMDdTtrZRfoaBxUMVBRA5U79AutriOmKW0B9wPI+sLb5UDRwiFIzbvuDOP+Y9+tStVKpFyRj
 0zvqjGR7hYycYX3JSC+2natgPLf2CD2QoQfEJWm+fNwxl6e3GoeDFsRT1TTif24jFOuHslUM
 E085CUjt+4x+VatQ927WAe3yENopTYGUNZWVuY98gzImuzf4h2SAS4PSTsphMEaWNEeej57h
 niLmcjQWRNqtP6XdEC83IWdlGbnUcQKFlMqaSgBRAoDxtDspoAvkx7CJupe/EOdlNb5H3T7x
 CqH6Xh4jLQIhslN3KK+lbwmv95OjsaUJuLQ2ukxdjn8hu+eTNX5D7GVBaHztJ6s1rqkoq26l
 CFcwaC2tblWZbnUzXzlaLtWRtmBua3aWAAwdHYyRfHNARz3pS76FW2RiRkjTHpU3jEsImKxM
 BCK4FMJvfe+/hKCNMdKXm54MOxzpYDIHtX+XfeSZd1LCqWdvifelM2yTSZ8B1zQrXU=
IronPort-HdrOrdr: A9a23:BwAa+KFOttJrfO5NpLqFp5LXdLJyesId70hD6qkvc203TiXIra
 CTdaogtCMc0AxhJk3I+ertBEGBKUmsk6KdkrNhTItKOzOW91dATbsSobcKrAeQYREWmtQtsZ
 uINpIOd+EYbmIKw/oSgjPIburIqePvmMvH9IWuqkuFDzsaF52IhD0JczpzZ3cGPzWucqBJbK
 Z0iPA3wAaISDA8VOj+LH8DWOTIut3Mk7zbQTNuPXQawTjLpwmFrJrhHTal/jp2aV5yKLEZnl
 Ttokjc3OGOovu7whjT2yv49JJNgubszdNFGYilltUVAi+EsHfpWK1RH5m5+BwlquCm71gn1P
 PWpQ07Ash143TNOkmovBrW3RX62jpG0Q6g9bbYuwqgnSXKfkN/NyNzv/MfTvIf0TtngDhI6t
 MP44tejesPMfqPplWk2zGCbWAbqqP9mwtQrQdUtQ0fbWPbA4Uh97D2OyhuYcw9NTO/54Y9HO
 Z0CsbAoP5QbFOBdnjc+nJi2dq2Qx0Ib1y7q2U5y4WoOgJt7ThE5lpdwNZakmYL9Zo7RZUB7+
 PYMr5wnLULSsMNd6pyCOoIXMPyUwX2MF/xGXPXJU6iGLAMOnrLpZKy6LIp5PuycJhNyJcpgp
 zOXF5RqGZ3cUPzDs+F2oFN73n2MS+AdCWoztsb64lyu7X6SrauOSqfSEo2m8/luPkbCt2zYY
 fEBHuXOY6VEYLDI/c84+SlYeghFZA3arxhhuoG
X-Talos-CUID: 9a23:zmX2lm1yg1UpW11BVYE2Z7xfJcJ0Ilrfymzpf2C9DSVrdY+0Y22ZwfYx
X-Talos-MUID: 9a23:RasL6gu75FqQNIFbes2nhj9PDdpr4JiXI1kOtpoWpPOePAVeEmLI
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2024 03:47:29 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 45F3lTfg019814
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 15 Jun 2024 03:47:29 GMT
X-CSE-ConnectionGUID: 7RBenhGTS8qY28KC29lhNA==
X-CSE-MsgGUID: zk/+pB/VTVGcOQ43cegjig==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,239,1712620800"; 
   d="scan'208";a="35895581"
Received: from mail-dm6nam04lp2041.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.41])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2024 03:47:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUCDLY1AAm01wW7w//efCtpanaiZlgZxO9J/dqnIO7Lz66fLwKUmKhSIKwKZjO7nFrct9C+iXUtZBZHHeBkZyN8+SoQsSt16OhA99cRW9VT17vhKpuMblHTxvuFI+DyOIQ4afEciYz7+kjC+GOmiZVb3Hq8ytQkRjPnR1M6Qs9wVUn5ecfKj2ikg07H+gzoe2JcBGclF3jTJ8l9pxuLa9a9NjiP0qbKTDRLcjRytO26mYz3v+hdgJ1AwyLalDVXvwlIvnma0Rfl4x3laItM/ikFDYAqOP6/cyVCJcZJsk/+Yrj4XVW06AK5XZ7MiO/lQ5UIVklCkrlh5uwlsL95ozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/pdg1AUkO/I++tDcH7oulIcXocc3O3VIuctQouDDsc=;
 b=iFmcp5JjvFHuJJUw90zawsNFMhqGAyIB/w0RaFq27Cg4SJb4v1wLl8KKiCbMZujPmYgMhUCC5fDuI11/XavPddpzRouRQBWThwbAaY8A1wFwQq/rSMFvEFb4YilWDSix1TpLPa7zikSkMmPK9k0OXEERLMIBZS2/30Jymm6J9L9mwYhEmstwcDcME8GVU2CXrBK+xLItnCI2TftRls9y7lm8+VHOWVamXO09N0Wl93RVuo0Jn5H/3NpSrLSV8nDTZsiUvR6i59vQX63Pf38hj5Sq3u58aTOHWsbHikzcKL/aKNz03pCoz4gQddWx1ewO658daPfUEVw/DnO8acrX1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH7PR11MB6770.namprd11.prod.outlook.com (2603:10b6:510:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Sat, 15 Jun
 2024 03:47:26 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7677.024; Sat, 15 Jun 2024
 03:47:26 +0000
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
Subject: RE: [PATCH 08/14] scsi: fnic: Add functionality in fnic to support
 FDLS
Thread-Topic: [PATCH 08/14] scsi: fnic: Add functionality in fnic to support
 FDLS
Thread-Index: AQHau4DvpVnghoIY5kqokjsHnUcQ/rHDtJEAgASBORA=
Date: Sat, 15 Jun 2024 03:47:26 +0000
Message-ID:
 <SJ0PR11MB58966D39EFAAD206CAE0A313C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-9-kartilak@cisco.com>
 <f992c0f2-8f70-4dc0-b679-e522e3fd6101@suse.de>
In-Reply-To: <f992c0f2-8f70-4dc0-b679-e522e3fd6101@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH7PR11MB6770:EE_
x-ms-office365-filtering-correlation-id: 65f4a992-ac08-4515-d2cf-08dc8ceddf6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?YndQR1B5V3R1SDB1K3QzZW8zZ3p1OUdQUFBiSm1KbFVzSUVkb3NZVkdwSE1m?=
 =?utf-8?B?WVh3ZGgvSVBmWTVRa2Z3S1pObm8za3lHRGgyZHQwc3NxYTB4elFoMEhQNmFs?=
 =?utf-8?B?MHhtcVprallOMHdIWTRUUnlKY1BPZXFoQWtJVUZQbFFOZWdLZGt6T2ZrbzNw?=
 =?utf-8?B?VDBMclVTZTh5WnN2MGFiaFFvR3hyejRPVmhqQnlpZXBxSi96dURCVUp4b3pS?=
 =?utf-8?B?VGg3eXNtZ3MwRFVGWTB4V0dhaVliYXF0cmxWK2dCUWQrMnRTNW9XOElIcml3?=
 =?utf-8?B?L1ExSHMrbFZyWEZBc2FWTlN6bDVtS25QRGFhcU94Y2JyYmt0dTdjZSs3dDg2?=
 =?utf-8?B?MEpJaEd4WUpjVVdiUGtkR0MvUnFaVmljSGo4UThKNVBWSDNnS0dLTEZFNkZz?=
 =?utf-8?B?KzZqTk83THFkdlJLYW9XU09vTGRmL0hoV1BGZHAvTlhnZjBHQUNpTmhmeU9R?=
 =?utf-8?B?QkxDT2E2RjA4ZldTMm16OVc5VHRDZHlaS2JIWFlkRFRmZW1UVWNMeFdpQzcr?=
 =?utf-8?B?Unk4Yld0Q2NhQVlPaWxOTzV3Ulp6RlErYnpYK25nWHJib2tVdnRDNU1BTk0z?=
 =?utf-8?B?SThnUTQ5YmdjMy9NL3RvdTM0dTlXL2tYdGUyWGlXUFFETVpzUjRySW44V2xo?=
 =?utf-8?B?Z0R1MldPaTN5NXk3b01hZ1kvNjdjcWxPeXJQZ3BaTjFpNkxpcFBaWERsQ3dx?=
 =?utf-8?B?SmwrOGIrWGFiME54anUxNXlBWlBINW5lYjRyVEFSOTdmOTl3NWpRTEZraDZR?=
 =?utf-8?B?aWk4MDdJMUNrZ3VnNGlHOE9PNjcvNmxRcStmb3FYNHFCazRVS0JCaDI1Z1pl?=
 =?utf-8?B?bk16TlNrS1RVZkU1dC9zaldhdFFsZlZiRzdINDVZbE5mVEdKdDM4ZWpzeFd3?=
 =?utf-8?B?R3N0NVBGZ3pQSnl3OTdEK1FqM0RRdXZWdCtlN2piQkFjYzhnalBhcHBDdVBo?=
 =?utf-8?B?RjFYS25ONzV2bEZuc3p5NmZNdlZFQ05ialRzQ0dwNTZqTjQrUzZjbGU2NGFS?=
 =?utf-8?B?MDRObEE2YTh3TExvNkxEb0t4c3FwU1BRcFVPUG5iOU9BeWRGTWtUazJIc2Vo?=
 =?utf-8?B?V3FMTVBvQUpSWVl2YytWaTRFcG1sZUxKUVQ1NFBzaGZ6S0FTNm5NQmM3eW5R?=
 =?utf-8?B?R3ZoOWpERmNkbFZWTk9UeXgreWNtSVJPRFZxNHhvQVBzTWM0NkVoc0ZsQTht?=
 =?utf-8?B?NXdwWHE1b3daU3Q3WkE3Y21RL1ZlOHhvV2l6b0wySWQ4VE5WaVZjekFLZXY3?=
 =?utf-8?B?UytxTXVZMUtRT29qMVBoTzlDaDVPWEU1UGc5UFVyeElQQ0JXQkRVZEdlT3py?=
 =?utf-8?B?ZFJ3bFZTemU4dkNmUUFNNkFwdk5iVmxBUkJCc05ja0l0ZDN6RmZqNmRreXBm?=
 =?utf-8?B?QW5RNVR6TEtiUnNDc2hvdGd3TjNleVM1Q3pFRnEyUEhNQlBISG1ReW44MzVH?=
 =?utf-8?B?OHhpL2FHM09VcGxXUTRxaDA3bFFnSk8xQ3ZnVjRod1RpdUFGN1F1aHBpcGZh?=
 =?utf-8?B?UUZhVnpncnVVTklJa1EvQVlJR2llVUpVVlRMak1hVkVmTElaMjJlNFdsYW90?=
 =?utf-8?B?MDFkNHhtZEV0TW45YkVYRkNHK1UrMzBQQktySFgzVVhFZDJVS2MrOHVzZGM2?=
 =?utf-8?B?Myt1RGR2OStOaWhIZDIxT2RWSXBkS2RZeUw2b1ZXUVJQVkdaN3M4MDZRNDBJ?=
 =?utf-8?B?Tkloam01Y0FBNVEvMWx2SUZUU0doT0xlRjF1UVRmcXJzd2NhSXZSd2tRMzI4?=
 =?utf-8?B?UXFRaUs2T1BrUzFsdllCNEJ1WkVnRFNyR1lleEM4MjZzTmVPL1NBZlNSZ3Nr?=
 =?utf-8?Q?KzGWDGudqHhosBQAa5P/KE88fpFqCx4JsZzVA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YkFzTGhUTWU3OWZiNjgxQ1dtWUZ2U3g0bk5Oc2sxaVNDcFR2TlVzRys5K2Jm?=
 =?utf-8?B?aHM1c0xPbUFYVkdVamdVOEVqZ1psYjhtcVY4MkRZYWhFTVZheDJYWkh3Vno0?=
 =?utf-8?B?K1ZsTzFZSlM2UWVqRXFlMjFSTmtRYlgwV3lLQ2JEMEZSRmY4T2JIWWZLZW94?=
 =?utf-8?B?b3lEUkVYSkNieWQ4bmNTUmZqaVJhVnp3QTVUY0hGaVhiTjBNOHFEeHYzQkVF?=
 =?utf-8?B?K2lhQ2N6cWg4WVJkK0xUUlhkWmhiU0F1UUxhaHVMelRONmhIMjQwbHdKajRa?=
 =?utf-8?B?b1ZZVU90RnNoV2JFeDVCbkYweVNGNGtnbVZha0I3dkhmM05nSmpTTzZQMUky?=
 =?utf-8?B?WDZXaFhYNVZVWUMrS3pPWEJtZzhlbGhNT1NQM0wrdXBJVm0yUnFiWDh4WFg0?=
 =?utf-8?B?eFpIZGdGSW54dWw5MDVUOFJDaFBsc3NjVFpkaDV0UVFyYmNwd3hqUk50V3VB?=
 =?utf-8?B?WFFUbWJubGdlVGNBeWdjS0I3ZFlCYjc2dUpxSGJ6VWlMRS9hdGRqdkM3ODQ2?=
 =?utf-8?B?UlV2VnB6VGhUeVY5MzdVdTBxaktVWXVTTTJnMTFHM3cvZGN5R29hNVA4a1BE?=
 =?utf-8?B?K1RLeUtpZlJvbmFMUXVUQU5SdklyMFJZd0RWYnNjVXpIWHkvcjNFUmFGQ0Fk?=
 =?utf-8?B?OVdGSmU2cUhpMzR6RXRmSHN1Y0tEcGxqbE16dDQzWWlrbkdGK0NqRUpiMm9w?=
 =?utf-8?B?Nm5ZZnhXR3lzZXQ0dUtCQmNlVzRvVzZrdmxIa1lzSzBLVDB5NlJZdFNJMHVP?=
 =?utf-8?B?SHBKNVN3Y1BHcWwwcVpPcVB5TDV0Wk90WVgzQlIyM0xNV1QxUHBHWVR6KzZY?=
 =?utf-8?B?T0dvSEpnNS9mNWVxK3p0TW5aV0laVThhR3IvcWdOWitJcWR5ZGRjZTRjRTNi?=
 =?utf-8?B?R0p3by9iR3dYN1Z3aUY2K2lCakFmNzRrblBTbDFySklJN1RYbjVVLzUwVzBl?=
 =?utf-8?B?M1dEeWNjaWRwcE5EcGN2cCtyQUwwbVQwR0lUaWJscUtVS0YwbUdtSzdFcktt?=
 =?utf-8?B?eDB3ZzBmM3UzVm9CMGZGSytya2ZOaklUS3lxb2lodnUzbkZxYThuVEF6Qlo4?=
 =?utf-8?B?ZWlrbEdDcmhFUGI3cXNLcTBKdEpkUHZ4VSsyd0JmSkxXbVlVVEw1TjlyRU9k?=
 =?utf-8?B?WVgwMHh1V3VWYS95ZkszV0ViSDlxVTBDdmp4V0lNVWZRUzc2eE1hM3NnNys0?=
 =?utf-8?B?M0dHbVExdWUvTGxvSFRJNGt3NlZTTVAzSnZPSFJicFBYMkcrOENBRjlkRmt1?=
 =?utf-8?B?SDdlYXh0dzBLZ2NMM1UvV1RiYnluVVM3bFIrblVjb21Kelc5VzNhd3NJUHo0?=
 =?utf-8?B?enFNbUE4NDhHaUlQazZjZEsrd2pZMUZ0Yk5SZHg0OHNQdTlDODV4N2oxS3Nl?=
 =?utf-8?B?ZkJHY05oN1FVZEE0R0pIQ3Ztd2ViQS9OZnZpWXgrUFM0Ty9FNDlTbFhIV0xE?=
 =?utf-8?B?dk5rdmlqeVEzYzU4N3VhcXdtMWFIbzk4T3VCSTFZNGV6WXg5bjh3blVRdnhs?=
 =?utf-8?B?STQxNzREUkxJSHkwejR6alZFRWIrTFB2dHIvTGltZ05saEI3NGVQNkdIREtO?=
 =?utf-8?B?amVrSDVXS0tXR1VBSU5iL2s0N2x6bTRjR091RE05eXM5OUhkTjl6K0J5TTFW?=
 =?utf-8?B?LzNrbGRJVXd6LytrMGYyTExqSzlWMm02VlhCelZQT0xzejJ1Z3cxaFIvS3Ru?=
 =?utf-8?B?QTJnTmhocEh5NHpBRTdoYXlDeTdudjYzcTFFeXp0NjljYzRkT1RvakVoSU56?=
 =?utf-8?B?aTRiTjNyVTMrb3hYMmJEVGZ1UWpYWVIvdVEwa2Y0azJ6MjlXM0FjcC83M2tQ?=
 =?utf-8?B?Uks4ak9QNmRkL0RYeDBIRWY5MmhPby9GWjRTNVE1OXpVUUkyR2ZDQTJrM3Jl?=
 =?utf-8?B?UnVyRER6cFlScENhY0l5aE8wSEhyYVhTUE1uT2NNcVZMUEk5bjNkQ2RNakRD?=
 =?utf-8?B?bGxCRVBtOGFEbzVvQXpiMysrRjViTnhTS2hNNlU0bFBVMk1BU1hvQ05YWkp5?=
 =?utf-8?B?RnJHeVFETWkrVWV4RFFheElkY0phZ3BGdVZ5bWhTSDlpbnV5cnZOenN0NFlq?=
 =?utf-8?B?ckVFSFNFTnhleDdWVzBCcm81TlE4bnBKRU1qSnY2bUNuOG1FeW40TE5FMytk?=
 =?utf-8?Q?yJDO1I1cYDsc2RuNwJxhkUwvm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f4a992-ac08-4515-d2cf-08dc8ceddf6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2024 03:47:26.2938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yqtcUYsSfT/MajiBrhWuV/Qv16cjSDUWo58NNUSJpQJXE5l6vp3aB6e5gcdgt/jgGKpfkv9oJnpVERuCczvQFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6770
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com

T24gVHVlc2RheSwgSnVuZSAxMSwgMjAyNCAxMTo1NyBQTSwgSGFubmVzIFJlaW5lY2tlIDxoYXJl
QHN1c2UuZGU+IHdyb3RlOg0KPg0KPiBPbiA2LzEwLzI0IDIzOjUwLCBLYXJhbiBUaWxhayBLdW1h
ciB3cm90ZToNCj4gPiBBZGQgaW50ZXJmYWNlcyBpbiBmbmljIHRvIHVzZSBGRExTIHNlcnZpY2Vz
Lg0KPiA+IE1vZGlmeSBsaW5rIHVwIGFuZCBsaW5rIGRvd24gZnVuY3Rpb25hbGl0eSB0byB1c2Ug
RkRMUy4NCj4gPiBSZXBsYWNlIGV4aXN0aW5nIGludGVyZmFjZXMgdG8gaGFuZGxlIG5ldyBmdW5j
dGlvbmFsaXR5IHByb3ZpZGVkIGJ5DQo+ID4gRkRMUy4NCj4gPiBNb2RpZnkgZGF0YSB0eXBlcyBv
ZiBzb21lIGRhdGEgbWVtYmVycyB0byBoYW5kbGUgbmV3IGZ1bmN0aW9uYWxpdHkuDQo+ID4gQWRk
IHByb2Nlc3Npbmcgb2YgdHBvcnRzIGFuZCBoYW5kbGluZyBvZiB0cG9ydHMuDQo+ID4NCj4gPiBS
ZXZpZXdlZC1ieTogU2VzaWRoYXIgQmFkZGVsYSA8c2ViYWRkZWxAY2lzY28uY29tPg0KPiA+IFJl
dmlld2VkLWJ5OiBBcnVscHJhYmh1IFBvbm51c2FteSA8YXJ1bHBvbm5AY2lzY28uY29tPg0KPiA+
IFJldmlld2VkLWJ5OiBHaWFuIENhcmxvIEJvZmZhIDxnY2JvZmZhQGNpc2NvLmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBLYXJhbiBUaWxhayBLdW1hciA8a2FydGlsYWtAY2lzY28uY29tPg0KPiA+
IC0tLQ0KPiA+ICAgZHJpdmVycy9zY3NpL2ZuaWMvZmRsc19kaXNjLmMgfCAgNzQgKysrKysNCj4g
PiAgIGRyaXZlcnMvc2NzaS9mbmljL2ZpcC5jICAgICAgIHwgIDI3ICstDQo+ID4gICBkcml2ZXJz
L3Njc2kvZm5pYy9mbmljLmggICAgICB8ICAyMCArLQ0KPiA+ICAgZHJpdmVycy9zY3NpL2ZuaWMv
Zm5pY19mY3MuYyAgfCA0OTggKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQ0KPiA+
ICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19tYWluLmMgfCAgMTAgKy0NCj4gPiAgIGRyaXZlcnMv
c2NzaS9mbmljL2ZuaWNfc2NzaS5jIHwgMTI3ICsrKysrKystLQ0KPiA+ICAgNiBmaWxlcyBjaGFu
Z2VkLCA1ODcgaW5zZXJ0aW9ucygrKSwgMTY5IGRlbGV0aW9ucygtKQ0KPiA+DQo+IFRoaXMgc2Vl
bXMgdG8gbm90IGp1c3QgX2FkZF8gdGhlIGZ1bmN0aW9uYWxpdHkgdG8gdXNlIEZETFMsIGJ1dCBy
YXRoZXIgX3JlcGxhY2VfIHRoZSBleGlzdGluZyBmdW5jdGlvbmFsaXR5IHdpdGggRkRMUy4NCj4g
SUUgaXQgc2VlbXMgdGhhdCBhZnRlciB0aGlzIGNoYW5nZSB0aGUgZHJpdmVyIHdpbGwgYWx3YXlz
IGRvIEZETFMsIGNhdXNpbmcgYSBwb3NzaWJsZSBzZXJ2aWNlIGludGVycnVwdGlvbiB3aXRoIGV4
aXN0aW5nIHNldHVwcy4NCj4gSG1tPw0KDQpUaGFua3MgZm9yIHlvdXIgcmV2aWV3IGNvbW1lbnRz
LCBIYW5uZXMuIA0KQXMgSSBtZW50aW9uZWQgaW4gdGhlIG90aGVyIHBhdGNoIGNvbW1lbnRzLCBD
aXNjbyBoYXMgYmVlbiBzaGlwcGluZyBhbiBhc3luYyBkcml2ZXIgYmFzZWQgb24gRkRMUyBmb3Ig
dGhlIHBhc3Qgc2l4IHllYXJzLg0KVGhlIGFzeW5jIGRyaXZlciBpcyBiYWNrd2FyZCBjb21wYXRp
YmxlIGFuZCBzdXBwb3J0cyBhbGwgdGhlIGFkYXB0ZXJzIHRoYXQgYXJlIHN1cHBvcnRlZCBieSB0
aGUgZXhpc3RpbmcgdXBzdHJlYW0gZHJpdmVyLCBhbmQgbW9yZS4NClRoZSBhc3luYyBkcml2ZXIg
aW4gZmFjdCBvdmVycmlkZXMgdGhlIHVwc3RyZWFtIGRyaXZlciBvbiBvdXIgaW5zdGFsbGF0aW9u
cy4NCg0KT24gQ2lzY28gaGFyZHdhcmUsIHRoZSBiZXN0IHByYWN0aWNlIG91dCBpbiB0aGUgZmll
bGQsIGlzIHRvIHVwZGF0ZSB0aGUgZHJpdmVyIHRvIHRoZSBhc3luYyBkcml2ZXIgZHVyaW5nIE9T
IGluc3RhbGxhdGlvbiBpdHNlbGYuDQpEdWUgdG8gdGhpcyBiZXN0IHByYWN0aWNlLCB3ZSBoYXZl
IF9ub3RfIHJlY2VpdmVkIGFueSBmZWVkYmFjayBmcm9tIGN1c3RvbWVycyBpbmRpY2F0aW5nIGFu
IGFibm9ybWFsIHNlcnZpY2UgaW50ZXJydXB0aW9uIHNwZWNpZmljYWxseSBkdWUgdG8gdGhlIGRy
aXZlciB1cGRhdGUuDQoNCkkgaG9wZSB0aGlzIGFkZHJlc3NlcyB5b3VyIGNvbmNlcm5zIGFib3V0
IHRoaXMgaXNzdWUuDQpQbGVhc2UgZmVlbCBmcmVlIHRvIHNoYXJlIHlvdXIgdGhvdWdodHMgb3Ig
YW55IG90aGVyIGluc2lnaHRzIHJlZ2FyZGluZyB0aGlzLg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
