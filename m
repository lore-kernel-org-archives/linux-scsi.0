Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11E020125F;
	Thu, 19 Jun 2025 01:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750297454; cv=fail; b=iyvVMYiKBWYEKsIfUVOoXBHhrZkPTH58KG5aPs9FKRy5BC6V1JiXiONdGHPp5mpv0oa5N0TXz3i77u8VafKcMhkF/mucN7ZgKUouHBkz+K5fPvqWcEn7guxw0egVka+jfXOCwydX8ynbT1hj+do8Q5V4Vp52bbmg8E+yTA2otiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750297454; c=relaxed/simple;
	bh=KblgVs89XKOLP0uxIuRe8kz+LB1D5zkm6UtGrlK9D88=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F2KtL/Fs8OJhLs8RrEoDTM4tOsJT9OOAVvOhsZtWhSOH209OiaphvKQYEe+H+gloG5GCN8DPR47I2Y98a7QK6cRN17BeiznfmyINMRUsNA2PbroQcFDyb06SpBUukMtXmy9Do6tsIIbiM2UtTtUk+em236X/BsyfRpFnR31EhQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ezyOQ5iq; arc=fail smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ezyOQ5iq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=560; q=dns/txt;
  s=iport01; t=1750297452; x=1751507052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KblgVs89XKOLP0uxIuRe8kz+LB1D5zkm6UtGrlK9D88=;
  b=ezyOQ5iqxaCPhlxY92T3ZUmPLmWCLx4GFNFa3cW7nQyrRGDpFm2L18tG
   nUidEx9h2h+AQfuPbagLn1jZV2RwuTpK703jguCrzxAY393BASuD4uqj+
   IZisuP98j8JgLr62wkE9QlEp9IqG49IWgiIP9wc5CfRDr/RQg0saI4Rka
   TNPOQaD4WocKmajtT9TRKjxfj+RSvfHnq9xQ5gReBjM+AQFNUsgQBeIFH
   eAZ99ho13PtECf5FhQ5T8nNlWJnLzMqJyIJ5tWhBFZhivrsMEeMKSeIh3
   Y00C9GasgIj640Oq0Z7/A9T8yUI7+zicOzY/8tWbKuKHD25aaIEKugsEs
   Q==;
X-CSE-ConnectionGUID: W13aZLvjT1St9cVnDyBMbA==
X-CSE-MsgGUID: XedtAiQ3TZGO/7YlAlaUvg==
X-IPAS-Result: =?us-ascii?q?A0AEAAAOalNo/5H/Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVIHghVJhFSDTAOETV+GVYIkmDqFXIF/D?=
 =?us-ascii?q?wEBAQ0CUQQBAYUHAhaLUQImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGCIZaAQEBAQMSERFFEAIBCA4KAgImAgICLxUQAgQBDQUIG?=
 =?us-ascii?q?oVPAwGhcgGBQAKKK3qBMoEB4CWBGy4BiFABgW2Df4R3JxuCDYEVQoJoPoRFF?=
 =?us-ascii?q?YNEOoIvBIIkRFKFYZM2CUl4HANZLAFVExcLBwVeQhAzAyo0MSMPPAUtHXYMK?=
 =?us-ascii?q?hgOgjochD6ERStPgyKBAw8BbGVBg14SDAZwDwaBKkADC209NwYOGwUEOnsFk?=
 =?us-ascii?q?WyGdZZ5Sa9JCoQbogkXg3EBEo0NmVAuh2WQcSKobQIEAgQFAhABAQaBaDyBW?=
 =?us-ascii?q?XAVgyJSGQ+OX7sZeDwCBwsBAQMJkXMBAQ?=
IronPort-PHdr: A9a23:/y8v+BOUX4Rqn5AO2Qsl6nc2WUAX0o4cdiYc7p4hzrVWfbvmpdLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:TBqdmKj+Nq1CaLKCdRdWuzOSX161YxEKZh0ujC45NGQN5FlHY01je
 htvWG2PPP2KYzCkLtBxOY228E8PuJDRndFiT1ZrrCFnFS5jpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOKn9CAmvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSBULOZ82QsaD9MtfvT8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUno71+M0VQ9
 8BBEyxcZS6Fq/Oc5biSH7wEasQLdKEHPasFsX1miDWcBvE8TNWbE+PB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgp/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JoPbGZ0EwBfFz
 o7A11T0Dg0zNeXE9Qiq1TXzt+vmmSrGRo1HQdVU8dYv2jV/3Fc7DBwQSEv+ovSjjEO6c8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BpRUHWvJOHOAgrgKA0KzZ50CeHGdsZiVdYdYiuecoSjEwk
 FyEhdXkAXpoqrL9dJ6G3q2foTX3PW0eKnUPIHdUCwAE+NLk5oo0i3ojU+peLUJ8tfWscRnYy
 DGRpy94jLIW5fPnHY3ilbwbq1pAfqT0czM=
IronPort-HdrOrdr: A9a23:G7nqJKrLHqnhABbDFyhER88aV5tkLNV00zEX/kB9WHVpm5Oj5q
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
X-Talos-CUID: 9a23:tLhyHGGZrhRlltx/qmJYrRUdKOQ7cEGE92uBKHG+JXdDbbe8HAo=
X-Talos-MUID: =?us-ascii?q?9a23=3AB5dMPQ3BxT7jZOT2AdKiSKAmMzUj06miFGkMqM4?=
 =?us-ascii?q?6ieajcnNBPx6ZhQmpTdpy?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-08.cisco.com ([173.37.255.145])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 19 Jun 2025 01:44:04 +0000
Received: from alln-opgw-2.cisco.com (alln-opgw-2.cisco.com [173.37.147.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-08.cisco.com (Postfix) with ESMTPS id B0C891800044A;
	Thu, 19 Jun 2025 01:44:04 +0000 (GMT)
X-CSE-ConnectionGUID: 8apgxpN6Twe5t3sks4eW2Q==
X-CSE-MsgGUID: 6BYf8sd5SoK0trDyC+cj3A==
Authentication-Results: alln-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.16,247,1744070400"; 
   d="scan'208";a="24919215"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by alln-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 19 Jun 2025 01:44:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lXhyrlDPZhsA4c0+yf4OsioRcSenYVRAYVgEaMGnBIFiytqvTij0mmEdYyqB0eBN/G/r0HEMBZcbu+YrZ3PXJ9NrudsQi+YFuDQHtHPkktYgKVISwSmTi+eAy97T/iI2pbHs3rNZ852uLxX/nGwzaErVc7cPo9eSdW+hXdZr0iyMUIB4pwoxsTK/d6EUoVKuvGA3YSPFybM2oi1JXO8hNoZw9+QmSHFwq4ngojm0e16zTmThnkZtGh1S43aQryFC8ejaOSJhuEVTyiULHFZfNP/MBKnLCl9dbOOwvxTV4Q5l9CTAnVhIbDtExW9GvayQJfzaOdyxLUhGoa4fmnzOwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KblgVs89XKOLP0uxIuRe8kz+LB1D5zkm6UtGrlK9D88=;
 b=en94yRbvO/WXT7Gzp0ahRYK/dhulULatYKu6asGJRPCXwTyPWOdUNXulOHY+kz2ii4MrBdyEjCqDY6/oow6Vj282cRFTTkHIdcfoDXrL0UHGK55QBR3//9B2Zja7OjdJOvtBloDNcETmAQ06x+tly19ks5ZOFFnoUcnjTMktrE54RN8Ot6YN9AuS9BvaPyoiC/7PS7QyPMzWsEFb1h9KVYNBSKYbv6iIX/J2+xiS5X3J3jnnvINNtpjE4QkelIdRMgNkKaN82OJZ7O0YpOiQb3Dst+7whHEMGSm1mLIJlQTq9wTtJm0CWR1g+vdeonwThMXA1vtaFMsObG4n7aIwiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by IA0PR11MB7909.namprd11.prod.outlook.com (2603:10b6:208:407::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Thu, 19 Jun
 2025 01:44:01 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8857.019; Thu, 19 Jun 2025
 01:44:01 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: John Meneghini <jmeneghi@redhat.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "Masa Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "revers@redhat.com" <revers@redhat.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>
Subject: RE: [PATCH v6 1/4] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when
 FDMI times out
Thread-Topic: [PATCH v6 1/4] scsi: fnic: Fix crash in fnic_wq_cmpl_handler
 when FDMI times out
Thread-Index: AQHb3+jNXC+yODxQ/U6cEpDxFRKkNrQJKe2AgACNFYA=
Date: Thu, 19 Jun 2025 01:44:01 +0000
Message-ID:
 <SJ0PR11MB58966BD0A15339E284AC7B89C37DA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250618003431.6314-1-kartilak@cisco.com>
 <62bfa26a-822b-462d-ba8d-e0d85610e278@redhat.com>
In-Reply-To: <62bfa26a-822b-462d-ba8d-e0d85610e278@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|IA0PR11MB7909:EE_
x-ms-office365-filtering-correlation-id: 49bee5b0-0ebe-449c-87eb-08ddaed2c416
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?T3EzMkQvWngvUVhZc2VtL0I1YXFnQzhXZC9hZXordVpXcENJSkNVQnQ1MS9o?=
 =?utf-8?B?RHdXSVZ1Q3lETzNJRVJ2dUZ4U3hEbVJoa0oxZUVRUzI4QkFZWExpcGlBU1Ft?=
 =?utf-8?B?YW4vVW1FU0RqZDhtVGh3N21hUkpwbUhnYXNmOC9wTllJUTEvUTJrT1ZEY1Ju?=
 =?utf-8?B?QUlZSmRMbncyV0hETlMyamYrbzlZNXBteU9zaU1jTlFTb2pLZWR1U2tpTTBy?=
 =?utf-8?B?aFRpOHJoWStVVUFobUlFU21tL2pxMUUzc1NtYjFmeE5OMVowZE9rU0FCU1Bn?=
 =?utf-8?B?YVhIVDZqc1dvQkwxclZaZFc2S1JrMWlvNXI5bWVzcU1xN1ZEWlZpa2RaQ29q?=
 =?utf-8?B?ZytDR2lsYjk1d2lrWkdwWFNlTzRyVno0Sm4wMnhodDB6SFhMcDgvVUNnOUZt?=
 =?utf-8?B?U3ZaclhQRnNtWDNsYnh5VnBud1JtRkwyOGhvaEtIZEFtVlpiZXRLRjVmMlhw?=
 =?utf-8?B?M01oZkFYK0JGMjY5UFVzWnFJeXcxdW1OQzB0NVRjTHFPNXVRcHR2Uk1haEk1?=
 =?utf-8?B?ZUsrcGtPRVZXblJhZDFyZ1lZOUZaQmZXRGZOeldFekhISUE2ais4eHhQZkZm?=
 =?utf-8?B?T1JGUnVjdnFEYWRpdWZqUWdvRitiODEzT01LYWg1eG5yci9SQkp2UXV0UXdK?=
 =?utf-8?B?Y1NwcUJzTk9lZWY4bDM2UEs3RDFRd003ZzM0NlNmZStSeERPcDVkekM4NVFE?=
 =?utf-8?B?WXQ0d3RqNWZmdjdleVJ0MjN0c2FNVjhseXArdml1c1lYY1JCeXB4L2RmamdY?=
 =?utf-8?B?cW52dEFHOFJsUGxOTzFpbmJQcVhCMWJiSmZDQStWSWFrSm5teHdvajhpVzhE?=
 =?utf-8?B?KzVsc0RCQkZxbEJhTWg1dWFsNmhNQW9XcEZqRjYzaWRQU2l6aURVU21KSzAw?=
 =?utf-8?B?RkF4VzVMVmRiU3owdHpvZndMQUZYaHZ6VzFBN0pOc1VHcUV1cHpYNFBWMFJH?=
 =?utf-8?B?eUFxZWFNbGhScUs4N0NPMlFNN3E3dmtkdHdjYWE4eS8vMGM1VytDVzl4OWQz?=
 =?utf-8?B?ajEzYXpTeEpTMXBmd1Z1ZlE3ZGNuMzk5dkgrTFBseGdSai8xL2pabjhUc0VJ?=
 =?utf-8?B?aFliMGt4UDFuVEg1d1d1UDFIRlljM1dDeDdrZlB6NWpmb2VEdHZoMFE3bXdz?=
 =?utf-8?B?RytBS1Y4KzMydytUK2c2L3daVzVveTBLRitqNllYOGZVci9vY0xsTUhCam16?=
 =?utf-8?B?V3RKRjZZSlBJSXcybG5xTmVEV1NXWGMyWmJuaThBN1pDcXhQUzhUM0loVmdL?=
 =?utf-8?B?TzVSNndydHJKemxJSXlpa3UrUzFZRXpybCtiSklXSi9GazI4WHZyekVGNEpP?=
 =?utf-8?B?RFVoQ3hZSm1HTkFJZVdaeWRBUWxTZjNTcm54TWs5N0tTQ2RjNjJQV2phTDV3?=
 =?utf-8?B?aE9uMjBFYnFDZUpZSXArVThVc1prak81Nms1aXhPV3ltcFpMR0tZWWQ5SVFZ?=
 =?utf-8?B?Yk1aMllSZks2ZDF0c0R3RTBhVmJJMDNJR3hZRTVxWnA2NDZFdXNGaHYwSFJZ?=
 =?utf-8?B?ZTc2VjUxMUdUY24xNzBmL1p4TS9ES0hITmIwODJ4d2lFNmVuaU9icGJmNzNF?=
 =?utf-8?B?cW5BeGZNL2tGdnM1TUxRY1I1dmxxNjFVU1NScEl4a2ppSkZSUzkrbGJyNkJs?=
 =?utf-8?B?ekgxZTFNU1QwOTNLV0ZZL2kwMEhmd3VDMzgxaEw5ZjJXQ3hGbkdoMTczMHlt?=
 =?utf-8?B?bVRESEJIdHQwc1MzamM1SjhrdDNzTjdFZ3hlQzBZT1laaFhmNk9ac3RWaVVa?=
 =?utf-8?B?bTN2TDg0NnBtU1BVK05qbGlHNjM0KzZoS3pNYlFDWmNKNjIxcjM4Vkx5RVAv?=
 =?utf-8?B?UTZIdnZlejI2NkVCclErbk0zN1A5cnFhWWg0djlGZDRRRTB1VzQyRmU1S1Ey?=
 =?utf-8?B?VW1iR3VsK2F1a1VEeXpuaVJoM0pkaFJuUUd5Tmlqa2ExbmFZSnZkaWQxeWRQ?=
 =?utf-8?B?OU96Zlc0N1oxNTBwY0tHMUNCMnQxZFlyMHB6UkhvaW1XZHQrL2pzdlpjeUZn?=
 =?utf-8?Q?X1O4lBVZb4Km4BB4TL9TtqTuNGWxj0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dmtnaFkyRmhSN2MwblhiVXBVclRVZTlPdnB6NG1zanIvYm1XdU9BU1krMGZ2?=
 =?utf-8?B?NUtCMkpRZVVNK2NHRUxUR3RpK25jWGdLQWdFV0M2dkEyQ1Y3NVdWR2hmbytR?=
 =?utf-8?B?L24wUlpLTVV5VTRncUtGeHN1aGdkRnBRbTZLY0RqY2cvdy9CWkZPb1NoUlgx?=
 =?utf-8?B?QWtlQ282MEZPQ01pVWR1ZkdzZDRua1NZeDQ4c1lsemNndVRjam9ucWlDTlFS?=
 =?utf-8?B?aFB6Zk1wcU5iMVh3S250SjdncUtydjFSaHIzRGgwaHE0ZGt0clpsS2o4L0hy?=
 =?utf-8?B?SnlCNm1vMnNDaE5oTHhjTERjMEVuV0FmSUN5bGJsaDhrOFJuQkwxUVBHd0Uy?=
 =?utf-8?B?VU5XSzNuWlVWSjlTYVJGbkh0eXJoZ251Z2Y5aGsvQk5MYW5UNXhuY1pCUkxG?=
 =?utf-8?B?QVhiaThUTVBnM21Ia3ZQWGNqaW9xNndPWVk5TDRRcHZNRmRuZUhEZzNqdzcz?=
 =?utf-8?B?bjBaVkNNeDkzS1pzb2txY05WMk1UQXY1NmNEUG50QmdJVHlkUURDcitvbGRP?=
 =?utf-8?B?cGlzeEdQVko1YU5QWS9lUzQ2ODU5d1Vjc1lnbWFoWUZ3eURlSWJ0Qk5rdkph?=
 =?utf-8?B?QnRpMGw0RTJ1L0xJb1ZKcDljVUlIZy82NVd0ek5mbGEyNkltVEo0QUtBQlJp?=
 =?utf-8?B?SFNlUmlNNWJkQU4reWhUN3d6SUFndEhacCs1TkxxU0lEUmdSeElvWDFIdlZn?=
 =?utf-8?B?VG53R1lxUUZ1Y1llcHRmS0tub3ZUTGZZTnVXQy9NdzVVUzdETGtpZitQcHlU?=
 =?utf-8?B?MkFvbEtSd1IwWUpRRHVpL3h1WDkxMVZYaVU0SjhGOVByb0VHazNzcjVrUG1y?=
 =?utf-8?B?VE43bllUUUwvNmNmRUJES09udmI3TFhnNHFjb0hKNTRyYWRpZFVycnZnanJX?=
 =?utf-8?B?TWlWSFBwUEJVeW1MTmZXd3paN2w5aTlHTVEwSHl5dzR3bFYrMkZzRGpFNTVk?=
 =?utf-8?B?ZEJrNHNEVC9HZEp1d1BqNGJqa29yWXVJZ1BPZ21BVlZpZjFPVnNEMWY4TERs?=
 =?utf-8?B?RkhKeGdGZ1NBL3lkNUg0b0FaRDZROEpWVndpZUVCaDczWldQOFR0ejdsbTg4?=
 =?utf-8?B?Qm4yd3h4d25uWUtWOEE0eWZNSTRwMjF1VkFCdCtNWWFWb3Z3S1RKV3R1NG5V?=
 =?utf-8?B?QnZJRlJZZjRxakxXeGdKMk91TURkR1U3ZmVnQmU5R1FkZGhoMmg0QWRnZU5J?=
 =?utf-8?B?UGVXNnFieUwyMGowUXZ0aUE4MW9KcmpzYTc0MWRHMlowcnV1Z1YzR1lXOFhz?=
 =?utf-8?B?WXdVTTcxTG84OTR6eFg3ZEsyeHhhbjVodnFGVTBMK1JUcVlrRllPQU1aMkVV?=
 =?utf-8?B?QmFVL3VySWZaa2tseVNmV01vUm13QkVLQ0VQQitsZ2RIbDMwVjA1UTFyWEZV?=
 =?utf-8?B?Tzl4dWZFL0I1aDZmMUcyMzVqWEdocG40V2RQSkI3WTVRMERvNmFWdDYvYk43?=
 =?utf-8?B?ZUFuOXN4L0tqcDhYQnpkc0FhSjRlSVVmamJQQkY2ZVFQNnhWcjZSY0RVa0c0?=
 =?utf-8?B?NjViSGhHNzlSNGpabWkwbFY5RVQrRlE0MGQ3dzdQZWhETnVKNVFabGs5d1lP?=
 =?utf-8?B?ZzBiWWg4NVFaNWVBWGgyc2lidTI3aW9SV2JvczFsTnhJakdQKyt5eGdlVno3?=
 =?utf-8?B?ZUFkQng4Qk1qMjliWElJb05qanpFUVliNkI2TjJlM2hxV1Q3bGVYVTk5UlJP?=
 =?utf-8?B?YXJIcVJ0LytNZ1FiS1VsOGlxV0dlc3NJUVV6UTZOVjZqYXA3bmcwRUoyU2Yr?=
 =?utf-8?B?RkJPaHgxWVJPSlpYNEZOMk9tUWZpYW44eWZmeFJPVmwveGJ2U3d5cGJ3MEkw?=
 =?utf-8?B?ZmtBZFNGRFhJVCtjcHZONHo1elFaTGdmSytocHYwZ092NDMwY2VaNGlEYjRo?=
 =?utf-8?B?c0h4aHB6bzJ3UnlXTkY0dHZXaWNYN2Q5Vk80cjY2QUU1cjVCcVRYVEE1Y0ZY?=
 =?utf-8?B?bmtBcHBEcUpQZTBIVTVkRmRlMFlDZ3BwZDkyNEw4T3VHYU5uKzNOd1hxYnRJ?=
 =?utf-8?B?VFNCRXRFcytDWmpNN2JxUFVIMHBzbHF4cThZNDR1Q3R0R3oyUjU5c21tYmlB?=
 =?utf-8?B?WllVQlprUktrTFRlVjZ1aTE4cXpNbUpVL3NtUXkxTi9wWndOYnJCNzBBTllZ?=
 =?utf-8?Q?mb4+2pHpwyg18mSJeSoryUvpN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 49bee5b0-0ebe-449c-87eb-08ddaed2c416
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 01:44:01.2383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KTfxbMJkuyIuH2MFeRgW3giPKfORMJUEunY5SEjT4DjaqZOPclBFM/FmJxOPDQk7RIxo7uE+1K5IsnyS5GIKPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7909
X-Outbound-SMTP-Client: 173.37.147.250, alln-opgw-2.cisco.com
X-Outbound-Node: rcdn-l-core-08.cisco.com

T24gV2VkbmVzZGF5LCBKdW5lIDE4LCAyMDI1IDEwOjE4IEFNLCBKb2huIE1lbmVnaGluaSA8am1l
bmVnaGlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+DQo+IEdyZWF0IEpvYi4gIFRoYW5rcyBLYXJhbi4N
Cj4NCj4gUmV2aWV3ZWQtYnk6IEpvaG4gTWVuZWdoaW5pIDxqbWVuZWdoaUByZWRoYXQuY29tPg0K
Pg0KPiBNYXJ0aW4sIGlmIHBvc3NpYmxlLCBwbGVhc2UgaW5jbHVkZSB0aGVzZSBpbiA2LjE2L3Nj
c2ktZml4ZXMuICBUaGVzZSBhcmUgY3JpdGljYWwgYnVnIGZpeGVzIHdoaWNoIGFyZSBob2xkaW5n
IHVwIHRoZSByZWxlYXNlIG9mIFJIRUwtOS43Lg0KPg0KPiAvSm9obg0KDQpUaGFua3MgZm9yIHJl
dmlld2luZyBhbGwgdGhlIHBhdGNoZXMgaW4gdGhlIHNlcmllcywgSm9obi4NCg0KUmVnYXJkcywN
CkthcmFuDQo=
