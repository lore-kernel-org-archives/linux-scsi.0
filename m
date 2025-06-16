Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C151DE2BF;
	Mon, 16 Jun 2025 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750091513; cv=fail; b=VdR1hRGJh5owHAtt/JLt0q6sAB89EIFY4gcUM1eLdiiacgHet2meKp0xwCHRjiT9bCK/K93hSmWu5BQbvGZqLwQ3EHtwajadBj2BFwY2cDlQjbUH+Rr7aK0rnGyfnxNEktkDPL/vhARcFyx8wfPcsDgODGOge7NC0wy/akHvS2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750091513; c=relaxed/simple;
	bh=+SBEt2SDluDrbC01AXqt9ZuITJuMQQQJS5gfHWiD9W0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CYzifPQS4qaIcx6vKLfTfpv4JLbLezjjTRMRj7c/qtVUeOY6ilVru5kjqcgEhjUWNEAvxi1oeJXG4KKMhpqesInvI7nBwxpHSqD1DLSNSiygHonaesJECAO3GC7b3M9jWa2331OFywBW6Dfz6gS1baJYA3dkFScKe9Yl3P576Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=GcxbiFyU; arc=fail smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="GcxbiFyU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=404; q=dns/txt;
  s=iport01; t=1750091512; x=1751301112;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+SBEt2SDluDrbC01AXqt9ZuITJuMQQQJS5gfHWiD9W0=;
  b=GcxbiFyUH7kQwmwelkPukTL5F4BiJH0jAqvXwTjalN2vWEGAz3kTB43P
   ZSsjo25nAcIt99F6hfaOhFqR6WrBEzSEy4ZTx+7QkCUsmDI0seulDzNKx
   7jt98JY7Vz4fF+yl7mIUVI3zDeDK/nw7sSNo7PI4uVDokP7pYsntHHnTy
   j2jUvdBjvjtuI6W3lwezxhlPByBh9J1iY5ezmHqOzj5tDHanLpjP7GOJs
   8xeIMqkvASWExPm6aQEoVjxPLHgyew3WCuQWbDddO9GkCJ9aJf/hvi+JT
   FJBptzwlgvn+yzHq6CjLxtAZ1lDjQjOBYIinTu3LhWMv6AoslGG/6WrSy
   g==;
X-CSE-ConnectionGUID: TH+cEHWOTkmW0Mg/hu6HPQ==
X-CSE-MsgGUID: 2SbXRVrmSnq+l+uPOBztcw==
X-IPAS-Result: =?us-ascii?q?A0AoAAAXRlBo/5L/Ja1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEaBwEBCwGBcVIHghVJhFSDTAOETV+GVYIknhaBfw8BAQENAlEEAQGFBwIWi?=
 =?us-ascii?q?1ACJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGW?=
 =?us-ascii?q?gEBAQEDEhERRRACAQgOCgICJgICAi8VEAIEAQ0FCBqFTwMBpAABgUACiit6g?=
 =?us-ascii?q?TKBAeAkgRsuAYhQAYFtg3+Edycbgg2BV4I3MT6ERYNZOoIvBIIkRFKNFpQPC?=
 =?us-ascii?q?Ul4HANZLAFVExcLBwVeQkMDgQ8jSwUtHYINhRkfgXOBWQMDFhCEAhyEZYRJK?=
 =?us-ascii?q?0+DIoESAWxlQYNfEgwGcQ8GUEADC209NxQbBQQ6ewWYAoUcYJg9Sa9JCoQbo?=
 =?us-ascii?q?gkXg3EBEo0NmVCZBCKoawIEAgQFAhABAQaBaDyBWXAVgyJSGQ/JeHg8AgcLA?=
 =?us-ascii?q?QEDCZF8AQE?=
IronPort-PHdr: A9a23:35fSHBFUkSR7y87McLNAMZ1GfhMY04WdBeZdwpMjj7QLdbys4NG7e
 kfe/v5qylTOWNaT5/FFjr/Ourv7ESwb4JmHuWwfapEESRIfiMsXkgBhSM6IAEH2NrjrOgQxH
 d9JUxlu+HTTDA==
IronPort-Data: A9a23:1FQc7q4NBpGxdbtjC6ncYgxRtDvGchMFZxGqfqrLsTDasY5as4F+v
 mAZXWCBP/iPazbyLYt0Odyy9klVusPWzNVhGgY9rS4yZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH3dOG49xGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr/aUzBHf/g2QpajxNtfrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eAa1b8ctXPkZy9
 vkncBUCKRCe2cKO+efuIgVsrpxLwMjDJogTvDRkiDreF/tjGcGFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkERUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIGEIYLbFJQFwC50o
 EqcxG7JOC8AMeeZ0HmBsW+UocXdgSjkDdd6+LqQs6QCbEeo7mgSDgAGEFi2u/+0jmagVN9Fb
 U8Z4Cwjqe417kPDZt38WQCo5WWPpR80RdVdCas55RuLx66S5ByWbkAfUjdLbNEOqsA7X3op2
 0WPktevAiZg2IB5UlqH/buS6Df3Mi8PICpaNGkPTBAO5J/op4RbYg/zc+uP2ZWd17XdMTrx2
 DuN6iM5gt0uYQQjjs1XIXivb+qQm6X0
IronPort-HdrOrdr: A9a23:faMoI6m1As8qOlwSkgFm2kO3Pj7pDfNjiWdD5ihNYBxZY6Wkfp
 +V7ZcmPE7P6Ar5BktApTnZAtj/fZq9z/JICYl4B8bFYOCUghrYEGgE1/qs/9SAIVyzygcz79
 YbT0ETMqyVMbE+t7eE3ODaKadv/DDkytHUuQ629R4EJm8aCdAE0+46MHfmLqQcfng+OXNNLu
 vm2iMxnUvZRZ14VLXdOlA1G8L4i5ngkpXgbRQaBxghxjWvoFqTgoLSIlyz5DtbdylA74sD3A
 H+/jAR4J/Nj9iLjjvnk0PD5ZVfn9XsjvFZAtaXt8QTIjLwzi61eYVIQdS5zXAIidDqzGxvvM
 jHoh8mMcg2wWjWZHuJrRzk3BSl+Coy6kXl1USTjRLY0I/ErXMBeoh8bLBiA1/kAnkbzZZBOW
 VwriSkXq9sfFb9deLGloH1vl9R5xKJSDEZ4J4uZjRkIPgjgflq3M0iFIc/KuZbIMo8g7pXS9
 VGHYXS4u1bfkidaG2ctm5zwMa0VnB2BRueRFMe0/blmAS+sUoJhnfw/vZv1kso5dY4Ud1J9u
 7EOqNnmPVHSdIXd7t0AKMETdGsAmLATBrQOCbKSG6XWZ0vKjbIsdr68b817OaldNgBy4Yzgo
 3IVBdduXQpc0zjBMWS1NlA8wzLQm+6QTPxo/suraRRq/n5Xv7mICeDQFchn4+ppOgeGNTSX7
 KpNJdfE5bYXB3T8EZyrnrDsrVpWA0juZcuy6QGsnq107f2FrE=
X-Talos-CUID: 9a23:vvIXA2HNkBQ/o3ccqmJb1A0fN+AaVUHeyUiIBkD/CXs3aIWsHAo=
X-Talos-MUID: 9a23:fcCP2QkC6Lxzbusz/crZdno4D81Y2Zq0DXsLiNYC+NS8EgZiJzyC2WE=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2025 16:31:44 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPS id C399118000492;
	Mon, 16 Jun 2025 16:31:44 +0000 (GMT)
X-CSE-ConnectionGUID: NMC+84k4Q5+ULOJEwZOcfA==
X-CSE-MsgGUID: idvyngYETxueGx9ae1vckg==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.16,241,1744070400"; 
   d="scan'208";a="49800537"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by alln-opgw-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2025 16:31:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7bAUTNl0r8k6CAisrZsMz9DSdNImPKnRXhnshUizVls0oETCb3JgI+8/dhrv/eXDwsNcNFF1DjUdgMslVZZ6Uz6ZMW758wBmi1DePe7ZHeMv6QVvgyFGutVqSkjciXIFGwSrUXsAHc5Z+WBX5eq0cjYWabnhF0uLJVu+gb6MNbTr7tk2TF/LwmBlTgenWvfNEbLqqPbBQUgmSnS1/g5td1eK3aBdS0okY6M4PGtfUerYyU1nWG79kw99puus2XrCZjvLVS+62naBztGTwwQumt7Pg03LVz9/VRfiYoHsvM9/OeHKXFt3sWprKZheLpOQTU5kCfz3ARhwTO5b0g8jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SBEt2SDluDrbC01AXqt9ZuITJuMQQQJS5gfHWiD9W0=;
 b=LQhoaVq4myhrl2TbTmnlEEfBjF+MofN+xtE4RfqnOLiqJO67IsmMAhLnP6rPVnf6wXCey+HXiM6LjeFfwSqi47/w0ZI8zcQgyJAYsxBBsgc+5A5AGTDOBM6YM15S0a6/iLYZQDhj5uqGbVo037AqK8udV0uJ1UO80drI1O1hrQjaPlAPn4MZ7HOc8FKuYz7U0NLmBj7lRJDczxJhv9QOr2B188EJrFKtSDdRbu36/yFlFnVNDFzJRL/A+caXYGaKtOYw2V43DJ21QCm26an2t6gnbPIh58qEQ1qPuqsk8J+C6NTa/9BaT3XaI6Po0bmGsOVZ/W8alrEYy5fr1UsxBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SN7PR11MB6560.namprd11.prod.outlook.com (2603:10b6:806:26c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 16 Jun
 2025 16:31:42 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8835.026; Mon, 16 Jun 2025
 16:31:42 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: John Meneghini <jmeneghi@redhat.com>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "Masa Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "revers@redhat.com" <revers@redhat.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
Thread-Topic: [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
Thread-Index: AQHb2+gh2qiqCptSFk+Aa/HWmBvPLLQBi7YAgAAV2cCABD58gIAAH78Q
Date: Mon, 16 Jun 2025 16:31:41 +0000
Message-ID:
 <SJ0PR11MB5896EEB17909C18AE35C29C5C370A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250612221805.4066-1-kartilak@cisco.com>
 <20250612221805.4066-4-kartilak@cisco.com>
 <7a33bd90-7f1b-49ad-b24c-1808073f7f5e@redhat.com>
 <SJ0PR11MB589646EBDF785F570E35E774C377A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <6cf23067-de70-45b9-ad83-90e96c5ea189@redhat.com>
In-Reply-To: <6cf23067-de70-45b9-ad83-90e96c5ea189@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SN7PR11MB6560:EE_
x-ms-office365-filtering-correlation-id: 1fd48ed2-42c6-46a0-366e-08ddacf346ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?LzRMb3J4U2ZyaEtic0dqUThGaUZkQVpkQUZyV2Z5eEh4U3J0Z0hnYllCcDlM?=
 =?utf-8?B?MHFIeExtTkt1WTg2UThPRE94ZDBpenAxOVdhZytMR3ZrdGtUVXJKRW1PL1dY?=
 =?utf-8?B?NDF0Vk84SVljQUErbjF3SUZCbTJKM3J0TEtKVHhaNGhTTHJRQWlkN2NVdzNa?=
 =?utf-8?B?a2hrb2FjQkF5NVZFZzNrd1lrS1ZCbHRINEgwb0dpaHUweXVEZVd1aHZtK0RV?=
 =?utf-8?B?Lyt0bE5kWUdvMGp5NHZWMVJxc1NYMEpIUThlbkd5VnBzVUJmamd0SkIyMnZG?=
 =?utf-8?B?WEY0TUJ3Y3ZEZjhnUDZxaXdLZTl0aHhKUzFyekh0UFBzMEdTYzhTQkUrcTBI?=
 =?utf-8?B?bEVoRVphdmcxMW15UFU3RTVndUF4MUtaVW9nZ3FvcUREYmRjNUhnTFl6dHJv?=
 =?utf-8?B?cEF3NW9DY3ZNQWs0d2o2T1FmYTFPdHVpUjd4ODVzNDZseTlzY0NhUEZ4TVJa?=
 =?utf-8?B?Qi92L0RUUGZveWE0WTdCcVh0alNuem5yVy9mZGprYXE2OTlEZGpWdlVUNG5R?=
 =?utf-8?B?eS83WmVmdzFUTThPOVI4WWY2UmtaZk1FU3IzNzFHWkhHZmo4NUcyRmxCcmVE?=
 =?utf-8?B?czEram5wSGFrQVRrcHdHTy85WHFoZ0dFamtzcWx2TG5JQytFTE1YOGwrT3BM?=
 =?utf-8?B?MVc3U3BpM0ozTXJJRFF0VE1WK2ZWYXp3dlFRL2ZqdFc5b1ptcFBPVk90OXVi?=
 =?utf-8?B?SHFoTHJWY0dQQjkrRUlFMC9KOFU4Q1B5VEcxNWtVME95enFyVFhONGU3enJX?=
 =?utf-8?B?TlprQVpoYllFM0tzaWlpa3orMXQ4Mm1JUnl3c3JSRGRaZ3VBTUpaQ0czcmgy?=
 =?utf-8?B?OElWaW1CdStEUEQ0SHByb1dScDZmbjRNcEh4LzJENTE4UjNVM0YyUnl2L2s5?=
 =?utf-8?B?cE9RaWNzdDR2MktQcVhMMm1HeXlJdVlYR2x0eW1WcDRkLytpM2tNRDZOa2Mv?=
 =?utf-8?B?eWRndzdkdGZydXJ4TUhYTHNvL1JtbWd4aGxyMks5Q3grOSt3Mi9xM2FBTUpv?=
 =?utf-8?B?eXdxbFI4dmplT3FKTWtKRGZFa0ZqbEp4SFBaRkZ1eVQ2WThXREJhWE56OFVj?=
 =?utf-8?B?dElLUjhKMjN6V3Fzalp4Q0QzUWI3S1B6YjJEclZYUEE0RzlhcHM4L05OTXVY?=
 =?utf-8?B?Y1ZVRVl3YjFOZjNjZkxEcnBITzB4T0ozc0ZJUUErOE4vMy8xNWtRTnpDVGNF?=
 =?utf-8?B?VWZRQ0FwcXQrdVVWU3ZoUzYyVzZZTHNodFJIcXl4TlZldVVsQzVVNy9zNTdV?=
 =?utf-8?B?d2EvSFJpQUFrRFNSNmdtUExPY3ZPT3RFUU5PbklUQlQvMVB1M29paXlHcGlp?=
 =?utf-8?B?RDR3eGwyV1Bpd1hXUTF3MjVWT1ZYWGRDWUR5NWkweWdmeU4yMGRucWo0OHU3?=
 =?utf-8?B?dDBGSW43SUdNbFZNUllFaVUweFhsbnNOUUFXdVNJT3pSa3lOUWxHZjRKWCtL?=
 =?utf-8?B?TFVTbkJYSERMNzRLQnliODJRQ1gxdFU1akFoWDZhbHp4Z25vTjhsWXZCUEdv?=
 =?utf-8?B?QkpQOXVoU2grUUE0aHZCOTJMVStQQmZjUHV4d0lyN3JwbXFJWlN6Q0hHVVFu?=
 =?utf-8?B?c3cxc2hLVVZkSHBwNDg5M0YwSWZYbktlb09UMTRiSW9QckpwN3k3Nzd2bVlW?=
 =?utf-8?B?b3BKbG94cTAyTjkraXJ2WmhlM1VpYVJ2VGJLT3E4OEw4T1M5eTk3Mi9jS0ZW?=
 =?utf-8?B?Q2hvS2QxR2tmMUZIa1N5RnZwdVNVMURJeFMvNy9IdG9MNm12b3ZsY1I0YVZM?=
 =?utf-8?B?R29mY2FTbmJoN3ZVQm93ZHJjaTRlK0J2V2ZxR2NqRG9XWHhDSkNOWTRlVkpj?=
 =?utf-8?B?eW13emlDaGxDQXVURGNCeDlYUkY1T3hKTzZ6bGxIOXJTekx3amlhMExPczNV?=
 =?utf-8?B?TEpZSW5NREVVTnEwaGVVcWZxOXNnV1RBcWpGOGlrSnJOOGd6RnlleTJtQmpS?=
 =?utf-8?B?S1gxdkFWaGIybGxVUFVsMGJxcitZOGJ1YzVxVFdoYU4zUUd1SzROUnZDS2JT?=
 =?utf-8?B?Mlo1Ym1ibU1RPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ejRoQzVST2V4dWp6dFE2QlpyNFhFY09hOEpOYUt3c0ZScXIzUXMzUmg3VzhS?=
 =?utf-8?B?Z0U5dmlGeXFSay9EYktJek4xSE9qeFA5TmlPTWlnSkF0ZG9ZbUtrK2YvVnF4?=
 =?utf-8?B?d2JNbGlIbWhhalNBOThnaTZVaE5na01YbTA0elVsVHhDWThGN2dRS0F2a1h3?=
 =?utf-8?B?TDhQSStIRFViRWNwalFKNWtXVUJVbVVaNW82OU05eFdQOGkvdFFwdmk3b3Z6?=
 =?utf-8?B?OFNJLy9BQnR0aGx3TGt2cjJTRnRxSlpKbEJTdnpTQzF6a2xNVEcweXFFMzhz?=
 =?utf-8?B?NFlra3o2bXpSWUI3cDY4d2t1N0xkcWZDcERqTE13VHZzdktFdFFXUlhxMXpO?=
 =?utf-8?B?SE91QnRFcnU5clY5NUIyZnNINkRpVkJQU2wvS2FNcmpBTEQxVmdHN1MyWXBY?=
 =?utf-8?B?SVhqYUhLYVFvSWo1L2haZFVWUXJuRGk3WG1HV2V6U01vZCtMNTVSWmxkd1B4?=
 =?utf-8?B?U1VaZjRvU0NnVVJ1THZuM0RQTWduYW8yWjR3a2pMbnY0bS9uWWg0VFI4K0tQ?=
 =?utf-8?B?emNJak53L2hjOGFwd3hDSWY1Y1JUUm9CUVJCYjNSbkYwdFpDdytnUml4N3U2?=
 =?utf-8?B?L2FMQUFubVZOcnFwakovL0tPTUlkalBrM0llQlVXYUVNTGRvendRU1FJVEdO?=
 =?utf-8?B?TFV6Nm0rZGNlSFVuTGVDdmlhak96WU0wRmxiTDV3SS9RRjVGcjI5TTFSVnRB?=
 =?utf-8?B?dU5Zdmt0bDI2aWdSVjZQVk5KZHBiVHg1eVlZQ3cweGQzc0pkK1pZQ21mcDFq?=
 =?utf-8?B?UER1QUdVbE9EVUFXQkZBZDdyNkVBZkU5Q2NsaUxrS0FDRTZmSTlyWlhpaWVB?=
 =?utf-8?B?eHFkeTNVRkNmSHJ5a0Jpa1BZeDNwZXliRG1VcmdLWVV4Y0RYMmlPcEFoUEZD?=
 =?utf-8?B?UkkyNFFLTDlWcTVNbnhMMmpMRVhrQ1hMeEk2SCtXckxONHVVMFJiZ21la3dY?=
 =?utf-8?B?TU0vMnVrVVQ4L2xsaWRpZU95ZjU4TjVVaHkzeitkYUtsZDBrZE5DMTd6bEtm?=
 =?utf-8?B?TUxJMnFScXZpT3ltUzQxKytuazBJRWw0NlgzaXcwQ1psYUJNNHArdW1ybFl1?=
 =?utf-8?B?amhkWnZCV2RwMmViVDJxVElkalNsRWZYQnRsZDgwT0xCU2xKbHUra2N0cnVI?=
 =?utf-8?B?UXg3WXptWjVvMlZESzVjK1VpWmFPOFBXVWpyd211MXF4d0tMZUhBd0M2cXRo?=
 =?utf-8?B?T1RaWnlrcmNmbnRrYWx3TVBUOFNpZ09meVJMcFhLa2x3N0drcEhHd0h3RHYw?=
 =?utf-8?B?QXdHVkNzc0s2Vm05dUhQREhOYzdCdXZ6VWJJZzBZMm5CYkJ1UkhqNStudjMv?=
 =?utf-8?B?WGdOMllYZUlCTk9nWEhETS8xNkVtWWY0b21VeGQxRWZ0c3VNR1RnUVcvN0VV?=
 =?utf-8?B?b29oQVBrNTdhK1UzQ2EvOGF2SFI1OEtodU5WZEdDV0pqWCs3NXJ6RzdNbEM0?=
 =?utf-8?B?dTVGc0puUno1L09BZSttZ1VwVGJpR2tzcHFHL0puVEJTU3FYUGZEQTQ1OUxC?=
 =?utf-8?B?cDRJeWtSZCtwNkFkRUhlZWQrQldLWVNZdEh0eVdFRVdCc2I1bUFVUDNCTW1u?=
 =?utf-8?B?NmpXdmt1RkROWDgyOEVuL3VmMUtyQ2c0dHJTZnloU0Q5QXZDZnNRaE1rNVBO?=
 =?utf-8?B?Y25BdjJrSFRiZGF2N1lxTW9WVzUyWVoxWWwvNEtCSFE3R09QRGNTVFJIU1pl?=
 =?utf-8?B?RW9OYXlaWFNDVjJ5YTB1SmVyamJadmtHUU9HM1ZmUkVlNXJ5SHRzR0pBL29N?=
 =?utf-8?B?c3FQMS9xeE5TOWd5UWJVSm1IREhLVGY4NFByR3RSendsNVg1WElYNXNNQWl6?=
 =?utf-8?B?T1NvaWZhY0J0WUl6WURPRlBIRzREQk1ycXpPZG1zQ3k0R281dkREaFNWYnVq?=
 =?utf-8?B?MmFDcE9XUjFzMWpxS1ZkMTlSdlNMNkpMeVRvbzIxU2xFbU9zV3pCZVMwVzUr?=
 =?utf-8?B?bXgxZGYrZnZPYUVSWS9iOVpkQ2RhbW5xRVZVNjhXN3oyRG4vcEhFc0Z1NHhh?=
 =?utf-8?B?bzJTTDh2WkxjMVhUV2sxYm1POEdybWRvOUxSeXcyNW0xUW5pemp0RGtkKzNT?=
 =?utf-8?B?ZTM1MmRHK1F0NTFEU3dBQ2dnRXZkWDl6alhzUXpwZUdRelZ5aCt0Y1gybnZn?=
 =?utf-8?Q?aNQ676xJ1HWWag9i15I4MuKDT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd48ed2-42c6-46a0-366e-08ddacf346ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2025 16:31:41.9554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vcmOldlwzXIPgOCA7d54CbVfYQljJytwPQ5uG9emr76ky3Ucn5jeBcnOloYEk3fQT48eY9quiUtpCDanURIxqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6560
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: rcdn-l-core-09.cisco.com

T24gTW9uZGF5LCBKdW5lIDE2LCAyMDI1IDc6MzYgQU0sIEpvaG4gTWVuZWdoaW5pIDxqbWVuZWdo
aUByZWRoYXQuY29tPiB3cm90ZToNCj4NCj4gU291bmRzIGdvb2QgdG8gbWUuIFBsZWFzZSBtYWtl
IHRoZXNlIGNoYW5nZXMgaW4geW91ciB2NSBwYXRjaCBzZXJpZXMgYW5kIEknbGwgYXBwcm92ZS4N
Cj4NCj4gL0pvaG4NCj4NCg0KVGhhbmtzIEpvaG4uDQpJJ3ZlIHJlZmFjdG9yZWQgdGhlIHBhdGNo
ZXMgYmFzZWQgb24gdGhlIG91dGxpbmVkIHBsYW4gYW5kIHBvc3RlZCBWNS4NCg0KUmVnYXJkcywN
CkthcmFuDQo=
