Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87A2197543;
	Mon, 30 Sep 2024 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714617; cv=fail; b=BKii/wIHkMViNu1nQzFrz6qfLgSjWno7XLExfNLhXWaWrnwQPDemWXCKbi+F6kDUXK/hMcVUwOBk+HvxMj00Cq4Ur3ugX5WPmdDuAyRg/Es6rflCK0vNPDk2PI7MKe2q4ZMVJqhI9sE9Q6abv9hf93Ow7RX0BBaWSA3m8nCvx6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714617; c=relaxed/simple;
	bh=eU6MGjiXB/WXIVoERgJasW9Yj3vVyk2OxrD0pZRmYqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QAwi1lYyibMde6G+lefE7qq4Kzt+xZvKnKda/Sx+fwMoXPVza/P1ZmE/Ms+lPEIwOwWjMRF2no6QxBCkNyoqhvTo9oZDkaXS7MiydWXjbDeMb24ZZCL8fk++hH90pgYxuoNtozN7kVOYozvog5ZYHimsojO2Q77d8p1IcAoK6yI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=D78BxZej; arc=fail smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="D78BxZej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2727; q=dns/txt; s=iport;
  t=1727714616; x=1728924216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hisREiDnSg6b2Yjz/xNVzkC7WbRm20lSB0vNSN0JohE=;
  b=D78BxZejck3BWjCvyEYzbCT7rpIbBrNFkb6yAwKHONR6ViOyopwocA0t
   9deA1oiZ7LqCrhwFejqgicLpX6W+3k+2BBTqnGUY56ddgBY5NzO4ChPfM
   kN2/5JdeMxyFsNuZo7Nw6hreS1iMgjZkQGcNGINOdSeVsjEhx3ZSdL8ld
   8=;
X-CSE-ConnectionGUID: IIgpeuEESvmtKcZDEN0ydg==
X-CSE-MsgGUID: HH+1qTuGSRSGnAtdwDCIZw==
X-IPAS-Result: =?us-ascii?q?A0AWAAAx1PpmmI9dJa1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBKoFyUnuBDBJIiCEDhS2IcwOfOgNWDwEBAQ0BAUQEAQGFB?=
 =?us-ascii?q?wKKDwImOBMBAgQBAQEBAwIDAQEBAQEBAQEBBQEBBQEBAQIBBwUUAQEBAQEBA?=
 =?us-ascii?q?QE3BQ47hgKGWwEBAQEDEhUTNAsQAgEIGB4QMSUCBAENBQgagl+CZQMBo1EBg?=
 =?us-ascii?q?UACiil4gQEzgQHgHoFIAYhKAYpdJxuCDYFXgmg+hAo7hBOCLwSRew6Kcnwli?=
 =?us-ascii?q?FtwkQRSexwDWSECEQFVExcLCQWJOAqDHCmBRSaBCoMLgTOBG4JXgWcJYYdnY?=
 =?us-ascii?q?oENgT6BWQFGgnFKJAuCIX85gT4FOEmCUWtOOQINAjeCKIEOglmEdigTHUADC?=
 =?us-ascii?q?209NRQbBQSBNQWsQkeCKSCBBAocgVyBK5JfAYMmmlmVDgqEGKFyF6pFLphII?=
 =?us-ascii?q?qNghHECBAIEBQIPAQEGgX4jgVtwFTuCZ1IZD44tDQnALHg7AgcLAQEDCYtVL?=
 =?us-ascii?q?IFRAQE?=
IronPort-PHdr: A9a23:Cqoifx/oi4NgQv9uWBDoyV9kXcBvk6//MghQ7YIolPcSNK+i5J/le
 kfY4KYlgFzIWNDD4ulfw6rNsq/mUHAd+5vJrn0YcZJNWhNEwcUblgAtGoiEXGXwLeXhaGoxG
 8EqaQ==
IronPort-Data: A9a23:UJvT86Cr3qBwehVW/x/jw5YqxClBgxIJ4kV8jS/XYbTApDNzgWdRz
 WEZWWmPM66DY2b3LopzbI++/RhV6J+GxoI1OVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4SGcYZuCCeF9n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gWmthh
 fuo+5eDYA7+g2YoWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE4tRhFEwrEKAj5ONrImp82
 dE+cCEBYUXW7w626OrTpuhEnM8vKozgO5kS/y4mxjDCBvFgSpfGK0nIzYYHh3Fr2YYfRrCHO
 5FxhTlHNHwsZzVMM00LCZY3n8+jh2L0dHtTr1f9Sa8fuTaMk1UqiOm2WDbTUvyqBpxMolu3n
 Vj90GLQHh0FGPe++yXQpxpAgceUwHukA9hNfFGizdZxnFSZwmE7FhIbTx24rOO/h0r4XMhQQ
 2QQ+ywzve0p/1eqZsfyUgf+o3OeuBMYHd1KHIUHBBql0KHY5UOSAXIJC2EHY909v8hwTjsvv
 rOUoz/3LR1Ov6WYVF+wzamRsRC5CwQ4CzcTaSBRGGPp/OLfiI00ixvOSPNqH6i0ksD5FFnML
 9ai8nJWa1I705Jj6kmrwW0rlQ5AsXQgc+LYzh/cUmTg5QRjacv6IYep8lPcq/1HKe51r2VtX
 lBayqByD8hXUflhcRBhps1WRdlFAN7ebFXhbaZHRcVJythU0yfLkXpsyD9/Plx1Fc0PZCXkZ
 kTe0SsIu8UMYiD2MvYvPd7oYyjP8UQGPYm6PhwzRocfCqWdiCfdoEmCmGbJhTm0yxl2+U3BE
 czBIZ71ZZrlNUiX5GHrH7hGi+BDKtEWzmLITpez1AW8zbebfzaUT7xDWGZinchnhJ5oVD79q
 o4FX+PTkk03eLSnPkH/r9VJRXhUdidTOHwDg5ENHgJ1ClA4SDhJ5j646e5JRrGJaIwPyLiSr
 injCx4AoLc97FWeQTi3hrlYQOqHdb50rGkwOmonOlPA5pTpSdzHAHs3H3fvQYQayQ==
IronPort-HdrOrdr: A9a23:DtYbgq0ukPaeWA5FIQ0A4wqjBIMkLtp133Aq2lEZdPU1SKGlfq
 WV954mPHDP+VMssQ4b6LS90cq7LU80l6QFg7X5VI3KNDUOsVHYS71K54GK+V3d84uSzIBg/L
 xtaq1vTMD3ZGIK7vrS+hWyENor3bC8n5yAmOG29RZQcT0=
X-Talos-CUID: 9a23:H+eim2+LSzZx9Jm/Y5iVv281Fdgob1Dw92nVP2yzO0pEbuWERVDFrQ==
X-Talos-MUID: 9a23:c9g77Am1T5gjnpzeWJLmdnpCFIQx+pizJ3s3qroAktWIKgBbGgWC2WE=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 16:43:29 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 48UGhT3J009326
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Sep 2024 16:43:29 GMT
X-CSE-ConnectionGUID: IS0LPjYrRXq+CERzQSO7Nw==
X-CSE-MsgGUID: GLmX1K2IRPad1rFuT4V8rw==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.11,166,1725321600"; 
   d="scan'208";a="42692142"
Received: from mail-mw2nam04lp2172.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.172])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 16:43:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s5zX7CEZXX1TJD6HrHnwg5HYWRMKMOIiBObN3cYqo1AIkmoCxetcBoRby4lP73uYphaPxRLeEPNdpZwJe3KuuWiuRJARahxgLyUa3XUX0XHgDLkQjFx+1C67TbVurC81maM4aqBLeHX9Bah6TMvO3HCY5o/HySW4EWj0xhjco/HFmyrC0mqeEw34Pn0l/l5A/WFAUYxtXBZlQmhbmTc+a6x8dDCH3YPmqTfIIoAjsjFisftrw3a7JaIzgpjLQYpFXWGex1WsTsNqj+txBwdJgZw1KV4OtLt+kLlxkBpJIYWdxBKZ9gM1NBSL4QbriplXsokeqfRXHVQhR919Mv2lbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hisREiDnSg6b2Yjz/xNVzkC7WbRm20lSB0vNSN0JohE=;
 b=G058dcRcepStfC01Hgop/LaRt1fZnD9dz8bc3dgG/tzyx1KUgIOE0HNV/NAgxu0zE+wwMAy/YeAM6sqEnS1LS1USfLegnLJErmHf0kjk1b4AdpGZtgEvMfPussMNpHhm1Ro8qk7u4hbUndGpDEkiCyiIz9LXYC1uDDmw5JYyctvuW7iMWHV6EqyO2HWVCS2bmvvhIDP33ajiXwaC7SYOXam4PwNfuVKssBydyAhe6vRCK+nGPquyseOaX0+Jo+XkfT9hv+XYOESHEdSzea1p2AzTvwBAc817u5WLX+j48P9kVEa1vm4ei7JtHHH3W+pkb1HFkLNifHKgNDf9imHccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DS0PR11MB8162.namprd11.prod.outlook.com (2603:10b6:8:166::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 16:43:26 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%3]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 16:43:26 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Martin Wilck <martin.wilck@suse.com>,
        "Satish Kharat (satishkh)"
	<satishkh@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: James Bottomley <jejb@linux.vnet.ibm.com>, Lee Duncan <lduncan@suse.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Petr Mladek
	<pmladek@suse.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: move flush_work initialization out of if
 block
Thread-Topic: [PATCH] scsi: fnic: move flush_work initialization out of if
 block
Thread-Index: AQHbEzzt95Y4KZWamkicGqLIvWkuFLJwiMOw
Date: Mon, 30 Sep 2024 16:43:26 +0000
Message-ID:
 <SJ0PR11MB5896CAF450B6A1EA1DA6AAFDC3762@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240930133014.71615-1-mwilck@suse.com>
In-Reply-To: <20240930133014.71615-1-mwilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DS0PR11MB8162:EE_
x-ms-office365-filtering-correlation-id: 1405d2e4-5531-4d1f-d43a-08dce16f0168
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?EUj3Ue8BHiGCSTb9F7NNWMNDLSnksWuWcXTdn/P8+bPoEch3hYq8+MDq0vYX?=
 =?us-ascii?Q?/eGXmoPFXkf3VXS8Sv0gKS7A50/hWn2wwGGt2WlHBuvLhHvn2pEjg+Nif1C1?=
 =?us-ascii?Q?52f5q4iUxF589BDjRcPt1pOX7jidhNZoIxf+5qx4wRUHWc2jBBEphrOQ98+z?=
 =?us-ascii?Q?R9wVo4fctJ814C3uXvtyLVOU5gSqsAASIczRDafwziKF/E1ZcUaiV7wZWV2t?=
 =?us-ascii?Q?yUGIqdHpbF/L/9scaJnsTfu5efymYQ+44/r7l+ALod/plX4+/vAJC0OzToUp?=
 =?us-ascii?Q?fXzso1qfUZyXBhJuWzUWPj6tTt5In2N09hkoqo5k93X6LevDEuYBKhGepfGH?=
 =?us-ascii?Q?8RKHMVnaN+/ehHyEiJLKlAPY/7xT5uZ6fyS5889RdJukiL9p6TYCQ8tt9II5?=
 =?us-ascii?Q?20M/JHO0GcOL0UjqBQ/azfgh8AxBWT+vrlXmKuaHscXX9pUGzMWPYsGdQjRW?=
 =?us-ascii?Q?nFDKunNsMqXM+G6AcoEffz/d+L/gKkmQIiTcYDecPkd6SVibkWQiV0FxCAwA?=
 =?us-ascii?Q?DFb9iVollC9pJcapOh0eF+Nq1V7wRLX/fni/RNkxdYP6QM2SJoFmgdjZWu4r?=
 =?us-ascii?Q?gIMwgMw8vB3S6jtqt4QIsBa2Z5WlA/JzXGdQi/kRuOKZvhajl9IEdsOFKuon?=
 =?us-ascii?Q?/um1zjVCbsyzB3SZxxJcGiupdYBcwXTrpX0UCVsAKKeWJSCoJM7M1T7I/fuW?=
 =?us-ascii?Q?gEvAkM+/8pxxObp0OGsOfmTOVrttc0rS69nCFcRhKhDQGCiVqWWl95Gv6uQx?=
 =?us-ascii?Q?an6jd88xZMWM+R5nUf4muY1nkEF+gaXluqZmvV5xaA0+jdlzego4lW+eeLte?=
 =?us-ascii?Q?AOIjW0ZIUlKXB6u+T+hp7vwwoZVWB8oD7BDZnkDXhDuSJEgwG/qLluA0DU5Y?=
 =?us-ascii?Q?bDIm4emfSKS2J51LsaNHV8wcFeAJsRKws/qZWmWXxHJtXbiKTa5DU3MpvdDM?=
 =?us-ascii?Q?c8XdyZnslgMDw/yEn3PEkg264PaLJn1Onos26OmYp0d+p4bZ7U7ZqqssB8QS?=
 =?us-ascii?Q?nu0JMEdrmTKKXyoQy0xXHS3Tw+/wnus+A67U81KhE+GJHsJpo+uKhpbEQsfq?=
 =?us-ascii?Q?3JqCJiOrZ3OZ/hBuEsEz3m4xQun9nQxQV4l4yx1E1atrRhv2ssBBi+OOxanR?=
 =?us-ascii?Q?InxT1fsQ1LJpf2auuI0F6+UBHUez1Ammg/G534Il1Ko81F4cX7V0RvP2tMmk?=
 =?us-ascii?Q?+POxDTcdTae9HhNMd/yvATowJds0UrBhJGj2FfkurLwO3c5/aiyk9ee+lWy4?=
 =?us-ascii?Q?fRd//U2HKFdUkhxJ4GDX8KjQNcpiOz/tdVKLmcuy53oCUIrFct21VImh0JSV?=
 =?us-ascii?Q?iiBUB7gO2gMrWdqe+qlmSs0VBT3v9G1kuYdP0K+U5MDQ9g=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Y79tZrh5Ue5uKVlM9WX9lIOV6rUKhYXQB7XflbFyT26abwmsZJN3rbsd6jgy?=
 =?us-ascii?Q?7A532aZPKEIJ+lclaMpRuzuDmBE0aNxmusoi1mcgN93p560Xe4IUm3tqBzTK?=
 =?us-ascii?Q?CsBWQk1pYdhJXlyMGcptLkA/wMfnJWRq839i3VZhUvUT6BLz/symRveYF/7X?=
 =?us-ascii?Q?zLu+tGYBcmm7JP9m2x20isbjV1EnIZgG4F3+9VA5tY5hHwVCfI7BIhTUB46z?=
 =?us-ascii?Q?ZGLTHeQrz3R/7CtRQVMBblaL4BFsBaQEiFJKvnadQq4hDH/InblxVvIwrxxp?=
 =?us-ascii?Q?o4eaUV2kxeaM1b8W3BbIsXGtmZDq7z0u5FsPyfUEp2TUD7cu6NX+g6FGH8vR?=
 =?us-ascii?Q?NCC/Iz6dJb5DcY/+XKbCB/EDa3AFtsVOdXAl2n0n9XK/hkvSRl5x/8QRyra+?=
 =?us-ascii?Q?Es2fUi/gnhL/X52MJCqE+wWq8YH4BGWbC9xz3q4Un8Nd5nbTfn/hvyWeHuwa?=
 =?us-ascii?Q?jDBopOsx8lcUa8Xd+P0e7WNkxBc+c/kZhPWW7nXsHHwwMG4Aj16BPdA6v45J?=
 =?us-ascii?Q?lT0hInG2/h+RXuqlX9HD4Fo4bvnj+i27YqA+gaU6Y9WdEzbQSqDUakv/T3JK?=
 =?us-ascii?Q?L91QAg2gjECO4wSX5b6Z9FbqwW1XCMLmLSUCs46T59NhwUKlpmDYhwIACCU3?=
 =?us-ascii?Q?ZAg1y/112e7yhdm7kan1U9tMWftTAF4Jw7K+YLGSwxjirK4xyWY81UKlqptl?=
 =?us-ascii?Q?ONU/8p1IvTV3g+kKKxBj042DMWrOL4rQjHs9DK/AkGOgAm2XjzYP0/Y3cGlJ?=
 =?us-ascii?Q?jYLkLcAT48TYO5QsUqfKDokyQvCGf5HX4VquLpWA346kxaoNMznuRTl5f1b0?=
 =?us-ascii?Q?qoeppq8tINNd6RF7r4+zylJh4KbfmPmZvZK3zfuhtGGklmpOEaKIakYuACK3?=
 =?us-ascii?Q?73z1G3bWwydXlubT2JyPoCTJOj1ebrTM2heXjHffevBQgVd0hVOAOKQ+Qdgh?=
 =?us-ascii?Q?ludb8YnDie375O9V1kV5w6auq84g4B4uUIpMG4Y34jWX/IZ+K828OGXKCd2j?=
 =?us-ascii?Q?Pq/YXu6LTVwvZOLwBZOlmJesrohshXHN6EUZFyMzIXW0qBa1bowvjVv8ppQC?=
 =?us-ascii?Q?hdpapxtyokrCTiFIBRkIgALR2bDo2FhcL2/27Yh7UiNKYAtFlU3dA4Lbf1+Y?=
 =?us-ascii?Q?TaqavSoQ24x/vEfgSx08+uVEs1MJWOs4mcZcOtQiWYqQNaiJdvWr+0rc2mYs?=
 =?us-ascii?Q?+1K3gk2L0gPh8POqT+l+J8yC05HCvCV81FKtdOWnHnhDuIpRBpSuS8L/tabn?=
 =?us-ascii?Q?PSCMoJbxJy/TsHcarpAuoNZi9DRpApOWbdLmY1KdKmjixdguqtJYrxVdn05D?=
 =?us-ascii?Q?w+tHDCf43hG40dlOfcf3SLiTary3j2W12B+o+NA2FdoQYdmj1oVTMxq3dfDD?=
 =?us-ascii?Q?r9p8KqqdLAKo3Bs05EvQXD9YgypDPDMRjh+KdidiKYiqZqP/r6zwK9wCu8li?=
 =?us-ascii?Q?ySeNjfBYNMJ7xZFJtZD8sUJDdRPTxfSggTruxo0BXEfYc/Qz63PnbHdqEG3S?=
 =?us-ascii?Q?BiB5HK0G+bEGRW2qcCN5yTzoUey7MeEETdvvJUwazE+5NKdma3V4kWHnzDGu?=
 =?us-ascii?Q?bTpP3AO+DEjO46WzLxh8tXcaoDC4wjaEjpCD7Bsw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1405d2e4-5531-4d1f-d43a-08dce16f0168
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2024 16:43:26.0533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XgaOnsx1fJ96cwCejE26FRxjbez9Obl8g1oCd1uHkzI+Fo4txADfarN6eZ6NEyMSOWRUIlffxqQ4ELg6x7dXXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8162
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com

On Monday, September 30, 2024 6:30 AM, Martin Wilck <martin.wilck@suse.com>=
 wrote:
>
> (resending, sorry - I'd forgotten to add the mailing list)
>
> After commit 379a58caa199 ("scsi: fnic: Move fnic_fnic_flush_tx() to a wo=
rk
> queue"), it can happen that a work item is sent to an uninitialized work
> queue.  This may has the effect that the item being queued is never
> actually queued, and any further actions depending on it will not proceed=
.
>
> The following warning is observed while the fnic driver is loaded:
>
> kernel: WARNING: CPU: 11 PID: 0 at ../kernel/workqueue.c:1524 __queue_wor=
k+0x373/0x410
> kernel:  <IRQ>
> kernel:  queue_work_on+0x3a/0x50
> kernel:  fnic_wq_copy_cmpl_handler+0x54a/0x730 [fnic 62fbff0c42e7fb825c60=
a55cde2fb91facb2ed24]
> kernel:  fnic_isr_msix_wq_copy+0x2d/0x60 [fnic 62fbff0c42e7fb825c60a55cde=
2fb91facb2ed24]
> kernel:  __handle_irq_event_percpu+0x36/0x1a0
> kernel:  handle_irq_event_percpu+0x30/0x70
> kernel:  handle_irq_event+0x34/0x60
> kernel:  handle_edge_irq+0x7e/0x1a0
> kernel:  __common_interrupt+0x3b/0xb0
> kernel:  common_interrupt+0x58/0xa0
> kernel:  </IRQ>
>
> It has been observed that this may break the rediscovery of fibre channel
> devices after a temporary fabric failure.
>
> This patch fixes it by moving the work queue initialization out of
> an if block in fnic_probe().
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
>
> Fixes: 379a58caa199 ("scsi: fnic: Move fnic_fnic_flush_tx() to a work que=
ue")
> Cc: stable@vger.kernel.org
> ---
> drivers/scsi/fnic/fnic_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.=
c
> index 0044717d4486..adec0df24bc4 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -830,7 +830,6 @@ static int fnic_probe(struct pci_dev *pdev, const str=
uct pci_device_id *ent)
> spin_lock_init(&fnic->vlans_lock);
> INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
> INIT_WORK(&fnic->event_work, fnic_handle_event);
> -             INIT_WORK(&fnic->flush_work, fnic_flush_tx);
> skb_queue_head_init(&fnic->fip_frame_queue);
> INIT_LIST_HEAD(&fnic->evlist);
> INIT_LIST_HEAD(&fnic->vlans);
> @@ -948,6 +947,7 @@ static int fnic_probe(struct pci_dev *pdev, const str=
uct pci_device_id *ent)
>
> INIT_WORK(&fnic->link_work, fnic_handle_link);
> INIT_WORK(&fnic->frame_work, fnic_handle_frame);
> +     INIT_WORK(&fnic->flush_work, fnic_flush_tx);
> skb_queue_head_init(&fnic->frame_queue);
> skb_queue_head_init(&fnic->tx_queue);
>
> --
> 2.46.1
>
>

Looks good to me.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
