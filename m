Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DE215E8B;
	Wed,  8 Jan 2025 21:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372531; cv=fail; b=BPbFUPngx/OJTBMrOhloxMmS8chi4uVdNMXS6C84uZo0iUABHvTbBYvgXaxREAx18cPn/6i/pGe1000q8Szd+lAT2UUjLIfvpHmQPUZFG2UCFzrw9XflttjXiK+ATVlwbXyBWA/z35qT+y5nacXnbAfxQ3Xc7/mJVkrOJNRG+QI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372531; c=relaxed/simple;
	bh=umMrPgih55aTrDvmFoYpV96fvaBWZyoe/+GYvDqgAeE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=efjmTGccDlB8emIeD6xSLI+2I5RTAUVo8zeWgJ6R9jNPAjyhdfXiRLPOCaPc/03fW9pLU4V9qIMAYiZJUQWkrEjguAgsCKyWOJzHxYhLea2kUhdfe8BhkdQDh3RcapTQToc/+vhAof6scC6aKS41wh3Uhh8qXQOD0QCzIEiu40E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Pq43rOqi; arc=fail smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Pq43rOqi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=55804; q=dns/txt;
  s=iport; t=1736372527; x=1737582127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i8TCuCfJJFMwS7hUpqjly5QhMZ060ktcz+7cOa2gMns=;
  b=Pq43rOqiswOd5h/PxS4/oSNlMAO4baS1uaHpAhNRLzvqRr2owy22iYNW
   WqhO3h4WNz6/rhVyw/LzyZPkx1NvgKi3gYmlPQIMKdnDrXOtJX2C+BilK
   cRbUVx8qVvta9ThVO+YFiJp0HgQ9LKJYKM25brijRaOrLEsDWxqkrwQ/q
   U=;
X-CSE-ConnectionGUID: PNsXVkHST+SxP/WaYvGAyg==
X-CSE-MsgGUID: 9KIx59PrTkeQD6Hr8A1oug==
X-IPAS-Result: =?us-ascii?q?A0AJAADa735n/4//Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcSooB3aBHEiIIQOETl+GUYIhA4ETnQWBJ?=
 =?us-ascii?q?QNWDwEBAQ0CMRMEAQGFBwKKdAImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBC?=
 =?us-ascii?q?wEBBQEBAQIBBwWBDhOFew2GWgEBAQECARIIAQwTPwULAgEIGBYBBxAxJQIED?=
 =?us-ascii?q?gUIGoIHWYJBIwMBpwMBgUACiit4gQEzgQHgIIFIAYhNAYVrhHcnG4INgRVCe?=
 =?us-ascii?q?W1KBzE+hEVGAoNLgi8EgjNLgSuBVl4lZ4FsiAmBIIFBHR0vgi6BL4FcgxKIG?=
 =?us-ascii?q?VJ7HANZLAFVExcLBwWBKR8rA4EUJoEqBTUKNzqCDGlJNwINAjWCHnyCK4Ihg?=
 =?us-ascii?q?j2ER2EvAwMDA4M8hWeCF4FmAwMWE4MXHUADC209NxQbBQSBNQWaeAE8gn4IN?=
 =?us-ascii?q?i0GATEpIQkKAQUOECgCJAoGLQIMBysKER8HDwEeAQQGOpJUCQgBAQcKgxiMX?=
 =?us-ascii?q?YNUij6VEQqEG4wYjgeHXReEBIFXiy+ZSZh8o18YGYEhg1ICBAIEBQIPAQEGg?=
 =?us-ascii?q?Wc8gVlwFTuCZwlJGQ+OLRaJGrEgeDwCBwsBAQMJhkuIXYEbYAEB?=
IronPort-PHdr: A9a23:Vg+m6xRrj6gJiP41AkBTf24HI9pso47LVj580XJvo7tKdqLm+IztI
 wmCo/5sl1TOG47c7qEMh+nXtvX4UHcbqdaasX8EeYBRTRJNl8gMngIhDcLEQU32JfLndWo7S
 exJVURu+DewNk09JQ==
IronPort-Data: A9a23:UsLb666tB8ExtCxgU8j00gxRtFPGchMFZxGqfqrLsTDasY5as4F+v
 mZOCDvXb/aMNDT0KN0kPN++pBkAuMCHnd82G1Q4/iBjZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH1dOC89RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr+aUzBHf/g2QpajtMu/rYwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eBasDyth0IVpyt
 scIEHcyZyGdqMunz+fuIgVsrpxLwMjDJogTvDRkiDreF/tjGc6FSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkEUUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIGNIY3TFJwLwy50o
 EqX3EXpX0AiLuCcxAOprFK21saWmj70Ddd6+LqQs6QCbEeo7mgSDgAGEFi2u/+0jmagVN9Fb
 U8Z4Cwjqe417kPDZt38WQCo5WWPpR80RdVdCas55RuLx66S5ByWblXoVRZbY9Ag8ctzTjsw2
 xrRwZXiBCdkt/ueTnf1GqqokA5e8BM9dAcqTSQFVgACpdLkpekOYtjnFb6PzIbdYgXJJAzN
IronPort-HdrOrdr: A9a23:YGZFda6Leb01dQP8RwPXwYeCI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQ8dcLC7VJVpQRvnhPhICPoqTMaftW7dySSVxeBZnMffKlLbalfDH4JmpM
 Ndmu1FeaLN5DtB/IjHCWuDYqsdKbC8mcjC65a9vhJQpENRGt1dBmxCe3+m+zhNNXJ77O0CZe
 KhD6R81l2dUEVSRP6WQlMCWO/OrcDKkpXJXT4qbiRM1CC+yRmTxPrfCRa34jcyOgkj/V4lyw
 f4uj28wp/mn+Cwyxfa2WOWxY9RgsHdxtxKA9HJotQJKx334zzYJLhJavmnhnQYseuv4FElnJ
 3nuBE7Jfl+7HvXYyWcvQbt4Q/9yzwjgkWSimNwwEGT4/ARdghKT/aptrgpNScxLHBQ+u2U5Z
 g7ml5xcaAnVC8o0h6Nv+QgHCsa5nZc6UBS4tL7yUYvELf3rNRq3NYiFIQ/KuZaIAvqrI8gC+
 VgF8fa+bJfdk6bdWnQui11zMWrRWlbJGbMfqEugL3d79FtpgEw82IIgMgE2nsQ/pM0TJdJo+
 zCL6RzjblLCssbd7h0CusNSda+TjWle2OADEuCZVD8UK0XMXPErJD6pL0z+eGxYZQNiJ8/go
 7IXl9UvXM7P0juFcqN1ptW9Q2lehT2YR39jsVFo5RpsLz1Q7TmdSWFVVA1isOl5+4SB8XKMs
 zDTq6+w8WTWlcGNbw5qzEWAaMiW0X2ePdlz+oGZw==
X-Talos-CUID: 9a23:zKNoeG9UGosGdneYDa+Vv3YyAfAbcV3m8DTrM3f/Nm9YVpK8WFDFrQ==
X-Talos-MUID: =?us-ascii?q?9a23=3AD4uAeQ3CaxPjGWJ+dSG2qCt9kzUjsoePGB1cqY8?=
 =?us-ascii?q?6uMS9GXJQIWe01TOqTdpy?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 21:40:57 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPS id 0085818000264;
	Wed,  8 Jan 2025 21:40:56 +0000 (GMT)
X-CSE-ConnectionGUID: dXKUPyzPQ9a0cJnYSy/c5w==
X-CSE-MsgGUID: ggWy1rBcS4mAf3jLiiu4Dg==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,299,1728950400"; 
   d="scan'208";a="21434164"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 21:40:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSN3gyVi2qLOkhykOSryCQaBfANNVfmKD0UG9HiECF97iA4mw4R/R0Jv/vY1L0t/zTy1QBHVo6LvDWt1sXKpN8m3GjIpyjiTyn64gTdXys63Jp//Md6V5J0nCTVEM2hwz8N5HKfM+IfGPq6E2sdu9CqjJtundaUeceWu0h8105AUs+Ed3dCBB614OkZB19opa+uBIDZy1GWC2lkalzucKAa82M8Qgetw6py/pfq3sacLelAyskm61gvkiBjMpfJ3ovJjQQqtz8SYys8Ml6DsUXSWFDd3wVMhIRgWgYuebZTVmcarw2pdfo3rLKOHQZvgwgjV1KVdPR/F4BTvtwEO6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8TCuCfJJFMwS7hUpqjly5QhMZ060ktcz+7cOa2gMns=;
 b=jXqKvWRqAljDz5NxwfNHKX0/Jm++ZZ1E2EvSNbEtLdnButmekbfrYWBSQ77nCYyZbZ7CCAGhSvc7/CrcczbswPTKEYBGILa3CbOC+Ur6VP7WG8dnflnmab+uf1cpQgMowRS/z74pMmbKpv0hF/bOwuIMR48WCMKRB62hoBRWw0YTzj5FOjehQduOu/p1XjcTQWkpl9Z9nky1yQqbL6zn0R1kEI7PPlXqrBiZr0OiFOdy9i71kJzCXhDsRILbpzNJC8hzQF5wXgtCq4Uerh7Qv8dah6lcpcbHDSEfFjEpKPOQexbibhzoIKanlM8KXU3IMjnthBpL8ulZqqwiEeWggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA1PR11MB8838.namprd11.prod.outlook.com (2603:10b6:806:46b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Wed, 8 Jan
 2025 21:40:48 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 21:40:48 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 11/15] scsi: fnic: Modify fnic interfaces to use FDLS
Thread-Topic: [PATCH v7 11/15] scsi: fnic: Modify fnic interfaces to use FDLS
Thread-Index: AQHbTDsxPk6F5B20lkuO2Uul0xmNtLMLdLsAgAIQJlA=
Date: Wed, 8 Jan 2025 21:40:48 +0000
Message-ID:
 <SJ0PR11MB5896C6D97A0A738C7B67EAC9C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-12-kartilak@cisco.com>
 <9d458a93-c2bf-4414-b050-98631fcdb1a3@stanley.mountain>
In-Reply-To: <9d458a93-c2bf-4414-b050-98631fcdb1a3@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA1PR11MB8838:EE_
x-ms-office365-filtering-correlation-id: b42412a3-dcde-4692-c9ea-08dd302d1dce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?q2pY2O81AkQHQtvsKj7B9TArXOzIq7joEQOiWW0tG6y9uvkkhcmmyT4U3uIr?=
 =?us-ascii?Q?uypLANJ3tG3dEsYeVQO6h4wznQgt2ZqFZZU3GlUA2MWNxGGxMfmCSxPjcqeG?=
 =?us-ascii?Q?vr7hhGHjger0kAiPh7wxxtcMGrcaIcDIGfPaEsI94RNc6D3Q4orMmufmVX8v?=
 =?us-ascii?Q?ChaOkb1XOoWiAMYHUhUcpAwZA7pr3BaN8E0uV51MKOn4JsBokNpRLU+F93Kf?=
 =?us-ascii?Q?+jVv6cYrFkni4Yp+RoS2abXRWr/uk2Qc5cO+derKeNogzkHE9F0qd1F8ko/u?=
 =?us-ascii?Q?ubo1j8Bq2NTs8G+KtxCX4GYq3xBSQF1LzxQ2hze8T//Cm1ibWnlShF56UR4g?=
 =?us-ascii?Q?dqhKy3470YHvNlLQqAa8bSDorxFSGXfNeB4mMd1tn1dRrb3r5qy0ebR4ME7s?=
 =?us-ascii?Q?IBKxannKus9eZnSES/RZ+4rj4dntXv1EPi+asYSbi/8adu6FYCeh1hp+g6Rl?=
 =?us-ascii?Q?R3KPrq55anSQkfnrFK+7C5qEgZbkJDlFicqOTwrX3FjsGgicoIjiLeNg2Mlj?=
 =?us-ascii?Q?uocl5kvvJnyTfN+J/T9k2jKDqB88D+gLiXztl/jxrXmrReWy5kV+7C8dCZic?=
 =?us-ascii?Q?j0vvLShVUi6/Ts+akI977/TFbrdLJvv2Dj42SCNv9rHK9JTTjTCloDV29ESx?=
 =?us-ascii?Q?CinqPApmyTkQZnLJwzJDLJTIXIKNDnYWr85IAqK+8SSx3qr/M5npXw5tzOCr?=
 =?us-ascii?Q?QDikHPUxmzllvKYIQfJmqX2kd0ZfdiWrNC8ArbvstEwuL3JQB+Qe37xC/5fh?=
 =?us-ascii?Q?vJMOiOkJa5kXh+/UbxXAUPMSOzm7Ma0gIRZ5oXuX+qR6PknCbIii3/vSFca+?=
 =?us-ascii?Q?jDSULUb0fnHXW+qgELKDEcnYF4JxEra1e6PYXRK0ZeCqLJX/vLwXRxssMl2Z?=
 =?us-ascii?Q?p+yNCof3O+mzrT5yJBJKUZHaJx9Egkktciip8RD394Q4sSVUX0ybqjb4a8+m?=
 =?us-ascii?Q?hoo0C3JfgR7WIfayeLtxXQab+cmAqJ4Lj9EhcQ5y+6iwv4Scz8xWSSxPozzf?=
 =?us-ascii?Q?lsqbmdL3w/RE9eJgTYCNAQK/7YSJYQqmGT6oB16Mv2wSZp7b45Jpigp9TLfo?=
 =?us-ascii?Q?tXnMkJb6iP/J6OnS5rMOpMRtYPzGiOwqQ8hEiNNAp4VBL98FhkPEsIv+x3Yk?=
 =?us-ascii?Q?KTPeFL0IcmzliHXzsj4RfWUliSkj8aDzQS2uSu4EorATE0mbNx0xZOtTg6CD?=
 =?us-ascii?Q?lqmN/cHrIr0z2eqjTOS2KFNdGXBCjMXSeHd5rmOsvEOk1RzXyaGZ88grooy2?=
 =?us-ascii?Q?Jo7s9FYl03eXfZ3k/y9fyiEuLlJf/CDnm0UBm/NzUfrRpWywjKc4rVYTOAtC?=
 =?us-ascii?Q?FNvcbiuY76gGOAd2XgATaUTNezo/fcnVkeqNKZlRU/r7+7PDrYWkCCFkRDd5?=
 =?us-ascii?Q?Q81hzwLbWc5eva7HlP4oywj1qNZd/yX4jqHnoDESddfnxL/0dOoaJa3Hh9vM?=
 =?us-ascii?Q?HvZZfHIdjpPcPS62j6ESue+r0ICnUE1J?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GEoA7Z5OaMDo/buLZ5BI30EyxzMBlXajOfF71TDd/0AD3qYwvpa++C1U8MAG?=
 =?us-ascii?Q?F0ipInAoyofFcNXuiGqpWDIVTRheg8KJJviX7O9plSSw3hvBFZoeoCFYR5YZ?=
 =?us-ascii?Q?wrWEGOQIF2deTZ+Tnzep8eV8Db6bZh/1rr+EuFL/X474ccyT6Gff7htGpTgd?=
 =?us-ascii?Q?1mPvMrwuu0SRO2bBWI9JxCeDtjV+dKLox5juO224grn71RnGklCzKYj6EI9d?=
 =?us-ascii?Q?Q+bL8GF27M1PnwkyxglXpI6RqLHgfMJ/3c30sS5LZ3eJ8JguYEsecWYVyd0M?=
 =?us-ascii?Q?sUh2LuVI78R7lZs46j0Yw5LalWeDlq/6LR0pVp7YBcJQNPHUfz5a71k/B1wF?=
 =?us-ascii?Q?LrGYx4KVaYVG26rUMYdKKCI4SWoGDwcPUP0BSCtywjd//xLp6ZQNdaf3sjXB?=
 =?us-ascii?Q?tkrNOtGWlnUnZ5LX0oWC0REogLAdmVrgp03/RIhePRB/5u4CfglbfxnMNQSz?=
 =?us-ascii?Q?lVX2eAExWAcLT98AC26x/m3QcmoYgo4ASve0lMDQ+D2OrRsGjIQG8eUj2PEg?=
 =?us-ascii?Q?34y4+hTtscQSAt4lTtgZd2Vn4NQMrxQxsyV0Arp3/O+qkycvnU8H0odYQZZ7?=
 =?us-ascii?Q?xgY0+eU2Ze0UI47KUdYCNgd5Qwxb+xpykUSPKdNx60KjSnesU6sSKNeG/Nfv?=
 =?us-ascii?Q?7Z391vrylAi1LbCYJ/18E1MIUBIuAbql10vZ+c4cr269OTCcEBq8hHRTYJVO?=
 =?us-ascii?Q?KAX0HDVyLfr/3efZmdAvgQaltuRSe3Buq2bqtool/Twq9ze0xjAAt4MnOBIN?=
 =?us-ascii?Q?D/ZKCPN/HtXysmd3dKfxqYBxwNQnFUNwps+Ch/4nOcEQgdHY+BJpE77BbZn3?=
 =?us-ascii?Q?dpyl395xS+/hvtC8gWIxrCgf9aP+c3/bfxhy19WkARj1uRk0Jbjv+Y/8aHXt?=
 =?us-ascii?Q?x7YKR1XvgjSfAzjWS0td8RVDFmoTwPHfYYfaePznXxHDAw7fMBIvDWtwqWA3?=
 =?us-ascii?Q?LAgOhno6JPJjDfXIfYtijaDjBCN/JrB4utiX1gwmI6f1SGBIIesLt84pFYgJ?=
 =?us-ascii?Q?go7aafuFKWCLvTpBYnS6Km0diutqeEnmUyMJ+/Kvye4P/U2U86eifkt6cdiT?=
 =?us-ascii?Q?39bufbVVKTJuOWWMI/79/zieRnBOMhuTdWe3Z3Lu//C5J6DCHzc+kLihB+FY?=
 =?us-ascii?Q?tabPRcqbWYdkM6xllmZL3b1XZ6mfcHZtWO56hInFLWoLr2WUCFxo/eNs5hkW?=
 =?us-ascii?Q?L0KNQ0cznmX7LyiTo4fvm+cB42Txn3ErZ+cA70vwBjDFkl4Sp3uI+mGPqryl?=
 =?us-ascii?Q?7rvxmWENNKtN3q36Fm6Z/G8O3muZ0HTidYNPdkIe7zRqBGPetYrdtf0rvUO4?=
 =?us-ascii?Q?Go/3DzSjnQTrgLe+7wIGn8ukxNYVcsYr37bzd/jIhrtsqCMFtYwH7jTu9qBu?=
 =?us-ascii?Q?MWV5BtaF5TUDO0F6AGFJagLaEDNJpAM3x3KGYJ9wE9z1OKtFkZKJwAiES/t+?=
 =?us-ascii?Q?IKL2qKN+y0AYe8hWKJAepSg41UKZW5WF8D25CHGHJkCYw60BD9i55inHLtnY?=
 =?us-ascii?Q?PEbyHyEg32HVyC32LN3NvjUtsRyhBWW2XqNhBXNI+C3FTVqtEbGlhZSZU5vV?=
 =?us-ascii?Q?lbDAhbRDq/77rGIGk2G+tBUNkTKCkcq55hxF3uGuW51zx0PnCVLgKDkJCwJH?=
 =?us-ascii?Q?u3rlaywQPR9XKYWFnNHdVbQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b42412a3-dcde-4692-c9ea-08dd302d1dce
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 21:40:48.7989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fGLmw/1f9O3DSBynpRx+w7MNPOaEyvqZA+wR2Y2w/OmGSFAVibnUnJ3FMs356qDCZXLSbvyRf66YGnaVGIToEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8838
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: rcdn-l-core-06.cisco.com

On Tuesday, January 7, 2025 5:18 AM, Dan Carpenter <dan.carpenter@linaro.or=
g> wrote:
>
> On Wed, Dec 11, 2024 at 06:03:08PM -0800, Karan Tilak Kumar wrote:
> > Modify fnic driver interfaces to use FDLS and
> > supporting functions.
>
> What does FDLS mean?

FDLS stands for Fabric Discovery and Login Services.
Please refer to the cover letter that has more details
regarding this new feature.

> > Refactor code in fnic_probe and fnic_remove.
> > Get fnic from shost_priv.
> > Add error handling in stats processing functions.
> > Modify some print statements.
> > Add support to do module unload cleanup.
> > Use placeholder functions/modify function declarations
> > to not break compilation.
> >
>
> Patches should do one thing at a time.  There shouldn't be any
> unrelated refactorings to complicate the review process.
>
> Honestly, this patch is process failure.  :(  It looks like only Martin
> and Hannes are reviewing this stuff.
>
> Ideally Martin and Hannes would be focused on the more technical issues
> instead of basic things like "One thing per Patch" that someone at Cisco
> could have handled.  There are also many style issues that you will find
> if you run checkpatch.pl --strict on this patch.  I started to point out
> the style issues in my review but I deleted those comments.  Just use
> --strict and you will see it.
>
> We are forcing Martin to be the bad guy.  It's super discouraging to have
> to NAK a v7 patch.  This is what leads to maintainer burnout.
>
> > Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> > Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> > Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> > Co-developed-by: Arun Easi <aeasi@cisco.com>
> > Signed-off-by: Arun Easi <aeasi@cisco.com>
> > Co-developed-by: Karan Tilak Kumar <kartilak@cisco.com>
> > Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> > ---
> > Changes between v5 and v6:
> >     Rebase to 6.14/scsi-queue.
> >     Incorporate review comments from Martin:
> >     Fix GCC 13.3 warnings.
> >
> > Changes between v4 and v5:
> >     Incorporate review comments from Martin:
> >         Modify fnic_get_stats to suppress compiler warning.
> >         Modify attribution appropriately.
> >
> > Changes between v2 and v3:
> >     Modify scsi_unload to fix null pointer exception during fnic_remove=
.
> >     Replace fnic->host with fnic->lport->host to prevent compilation
> >     errors.
> >
> > Changes between v1 and v2:
> >     Incorporate review comments from Hannes from other patches:
> >         Replace pr_info with dev_info.
> >         Replace pr_err with dev_err.
> > ---
> >  drivers/scsi/fnic/fnic.h         |  14 +-
> >  drivers/scsi/fnic/fnic_attrs.c   |  12 +-
> >  drivers/scsi/fnic/fnic_debugfs.c |  28 +-
> >  drivers/scsi/fnic/fnic_fcs.c     |  16 +
> >  drivers/scsi/fnic/fnic_main.c    | 498 +++++++++++++++++--------------
> >  drivers/scsi/fnic/fnic_res.c     |  30 +-
> >  drivers/scsi/fnic/fnic_scsi.c    |  39 +++
> >  drivers/scsi/fnic/fnic_stats.h   |   2 +
> >  drivers/scsi/fnic/fnic_trace.c   |   6 +
> >  9 files changed, 398 insertions(+), 247 deletions(-)
> >
> > diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> > index 1cfd9dcb5444..19e8775f1bfc 100644
> > --- a/drivers/scsi/fnic/fnic.h
> > +++ b/drivers/scsi/fnic/fnic.h
> > @@ -85,6 +85,7 @@
> >  #define IS_FNIC_FCP_INITIATOR(fnic) (fnic->role =3D=3D FNIC_ROLE_FCP_I=
NITIATOR)
> >
> >  #define FNIC_FW_RESET_TIMEOUT        60000 /* mSec   */
> > +#define FNIC_FCOE_MAX_CMD_LEN        16
>
> Unrelated.  Also why?  The original define made more sense.

Thanks for your comment Dan.
I'm unclear as to the original define. Please clarify.

> >  /* Retry supported by rport (returned by PRLI service parameters) */
> >  #define FNIC_FC_RP_FLAGS_RETRY            0x1
> >
> > @@ -344,6 +345,7 @@ struct fnic {
> >     int fnic_num;
> >     enum fnic_role_e role;
> >     struct fnic_iport_s iport;
> > +   struct Scsi_Host *host;
> >     struct fc_lport *lport;
> >     struct fcoe_ctlr ctlr;          /* FIP FCoE controller structure */
> >     struct vnic_dev_bar bar0;
> > @@ -464,11 +466,6 @@ struct fnic {
> >     ____cacheline_aligned struct vnic_intr intr[FNIC_MSIX_INTR_MAX];
> >  };
> >
> > -static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
> > -{
> > -   return container_of(fip, struct fnic, ctlr);
> > -}
> > -
>
> Unrelated.
>

Thanks for your comment Dan.
Since this patch is a part of a patch series, I tried to make sure
that each patch compiles independently without any compilation errors or wa=
rnings.
Based on some other reviewers' comments elsewhere, if functions are not bei=
ng referenced,
those functions are deleted right away.=20

> >  extern struct workqueue_struct *fnic_event_queue;
> >  extern struct workqueue_struct *fnic_fip_queue;
> >  extern const struct attribute_group *fnic_host_groups[];
> > @@ -500,6 +497,7 @@ int fnic_eh_host_reset_handler(struct scsi_cmnd *sc=
);
> >  int fnic_host_reset(struct Scsi_Host *shost);
> >  void fnic_reset(struct Scsi_Host *shost);
> >  int fnic_issue_fc_host_lip(struct Scsi_Host *shost);
> > +void fnic_get_host_port_state(struct Scsi_Host *shost);
> >  void fnic_scsi_fcpio_reset(struct fnic *fnic);
> >  int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do, =
unsigned int cq_index);
> >  int fnic_wq_cmpl_handler(struct fnic *fnic, int);
> > @@ -512,7 +510,7 @@ const char *fnic_state_to_str(unsigned int state);
> >  void fnic_mq_map_queues_cpus(struct Scsi_Host *host);
> >  void fnic_log_q_error(struct fnic *fnic);
> >  void fnic_handle_link_event(struct fnic *fnic);
> > -void fnic_stats_debugfs_init(struct fnic *fnic);
> > +int fnic_stats_debugfs_init(struct fnic *fnic);
> >  void fnic_stats_debugfs_remove(struct fnic *fnic);
> >  int fnic_is_abts_pending(struct fnic *, struct scsi_cmnd *);
> >
> > @@ -541,6 +539,10 @@ unsigned int fnic_count_lun_ioreqs_wq(struct fnic =
*fnic, u32 hwq,
> >                                               struct scsi_device *devic=
e);
> >  unsigned int fnic_count_lun_ioreqs(struct fnic *fnic,
> >                                        struct scsi_device *device);
> > +void fnic_scsi_unload(struct fnic *fnic);
> > +void fnic_scsi_unload_cleanup(struct fnic *fnic);
> > +int fnic_get_debug_info(struct stats_debug_info *info,
> > +                   struct fnic *fnic);
> >
> >  struct fnic_scsi_iter_data {
> >     struct fnic *fnic;
> > diff --git a/drivers/scsi/fnic/fnic_attrs.c b/drivers/scsi/fnic/fnic_at=
trs.c
> > index 0c5e57c7e322..705718f0809b 100644
> > --- a/drivers/scsi/fnic/fnic_attrs.c
> > +++ b/drivers/scsi/fnic/fnic_attrs.c
> > @@ -11,8 +11,8 @@
> >  static ssize_t fnic_show_state(struct device *dev,
> >                            struct device_attribute *attr, char *buf)
> >  {
> > -   struct fc_lport *lp =3D shost_priv(class_to_shost(dev));
> > -   struct fnic *fnic =3D lport_priv(lp);
> > +   struct fnic *fnic =3D
> > +           *((struct fnic **) shost_priv(class_to_shost(dev)));
>
> No space after a cast.  This is because casting is a high precedence
> operation.  The newline is unnecessary.
>
> struct fnic *fnic =3D *((struct fnic **)shost_priv(class_to_shost(dev)));
>
> Put this stuff in a function so we don't have to open code this
> everywhere.
>
> struct fnic *shost_fnic(struct Scsi_Host *shost)
> {
> return *((struct fnic **)shost_priv(shost);
> }

Thanks for your comment Dan. This is being referenced in only two places.
I don't believe a function is necessary here.

As to the whitespaces, thanks for pointing out the --strict option.
So far, I was resolving checkpatch.pl warnings and errors.
I was not aware of the --strict option.

All the indentation errors and warnings that have been fixed starting from =
v1,
were fixed using "indent -linux".
Is there a flag or any alternative to fix whitespaces and alignment issues?
Please advise.

I can fix the whitespace issues in a future patch.

> >
> >     return sysfs_emit(buf, "%s\n", fnic_state_str[fnic->state]);
> >  }
> > @@ -26,9 +26,13 @@ static ssize_t fnic_show_drv_version(struct device *=
dev,
> >  static ssize_t fnic_show_link_state(struct device *dev,
> >                                 struct device_attribute *attr, char *bu=
f)
> >  {
> > -   struct fc_lport *lp =3D shost_priv(class_to_shost(dev));
> > +   struct fnic *fnic =3D
> > +           *((struct fnic **) shost_priv(class_to_shost(dev)));
> >
> > -   return sysfs_emit(buf, "%s\n", (lp->link_up) ? "Link Up" : "Link Do=
wn");
> > +   return sysfs_emit(buf, "%s\n",
> > +                                     ((fnic->iport.state !=3D FNIC_IPO=
RT_STATE_INIT) &&
> > +                                      (fnic->iport.state !=3D FNIC_IPO=
RT_STATE_LINK_WAIT)) ?
> > +                                     "Link Up" : "Link Down");
>
> The white space is weird.
>
> >  }

Addressed above.

> >  static DEVICE_ATTR(fnic_state, S_IRUGO, fnic_show_state, NULL);
> > diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_=
debugfs.c
> > index 2619a2d4f5f1..3748bbe190f7 100644
> > --- a/drivers/scsi/fnic/fnic_debugfs.c
> > +++ b/drivers/scsi/fnic/fnic_debugfs.c
> > @@ -7,6 +7,9 @@
> >  #include <linux/vmalloc.h>
> >  #include "fnic.h"
> >
> > +extern int fnic_get_debug_info(struct stats_debug_info *debug_buffer,
> > +                                                      struct fnic *fni=
c);
>
> Hopefully checkpatch will catch things like this.

Addressed above.

> > +
> >  static struct dentry *fnic_trace_debugfs_root;
> >  static struct dentry *fnic_trace_debugfs_file;
> >  static struct dentry *fnic_trace_enable;
> > @@ -593,6 +596,7 @@ static int fnic_stats_debugfs_open(struct inode *in=
ode,
> >     debug->buf_size =3D buf_size;
> >     memset((void *)debug->debug_buffer, 0, buf_size);
> >     debug->buffer_len =3D fnic_get_stats_data(debug, fnic_stats);
> > +   debug->buffer_len +=3D fnic_get_debug_info(debug, fnic);
> >
> >     file->private_data =3D debug;
> >
> > @@ -673,26 +677,48 @@ static const struct file_operations fnic_reset_de=
bugfs_fops =3D {
> >   * It will create file stats and reset_stats under statistics/host# di=
rectory
> >   * to log per fnic stats.
> >   */
> > -void fnic_stats_debugfs_init(struct fnic *fnic)
> > +int fnic_stats_debugfs_init(struct fnic *fnic)
> >  {
> > +   int rc =3D -1;
> >     char name[16];
> >
> >     snprintf(name, sizeof(name), "host%d", fnic->lport->host->host_no);
> >
> > +   if (!fnic_stats_debugfs_root) {
> > +           pr_debug("fnic_stats root doesn't exist\n");
> > +           return rc;
> > +   }
> > +
> >     fnic->fnic_stats_debugfs_host =3D debugfs_create_dir(name,
> >                                             fnic_stats_debugfs_root);
> >
> > +   if (!fnic->fnic_stats_debugfs_host) {
> > +           pr_debug("Cannot create host directory\n");
> > +           return rc;
> > +   }
> > +
> >     fnic->fnic_stats_debugfs_file =3D debugfs_create_file("stats",
> >                                             S_IFREG|S_IRUGO|S_IWUSR,
> >                                             fnic->fnic_stats_debugfs_ho=
st,
> >                                             fnic,
> >                                             &fnic_stats_debugfs_fops);
> >
> > +   if (!fnic->fnic_stats_debugfs_file) {
> > +           pr_debug("Cannot create host stats file\n");
> > +           return rc;
> > +   }
> > +
> >     fnic->fnic_reset_debugfs_file =3D debugfs_create_file("reset_stats"=
,
> >                                             S_IFREG|S_IRUGO|S_IWUSR,
> >                                             fnic->fnic_stats_debugfs_ho=
st,
> >                                             fnic,
> >                                             &fnic_reset_debugfs_fops);
> > +   if (!fnic->fnic_reset_debugfs_file) {
> > +           pr_debug("Cannot create host stats file\n");
> > +           return rc;
> > +   }
> > +   rc =3D 0;
> > +   return rc;
>
> Ugh.  Don't do "rc =3D 0; return rc;".  But mostly all the changes to
> fnic_stats_debugfs_init() are just wrong.  It means that the driver
> cannot load if CONFIG_DEBUGFS is disabled.  The original code was
> correct.  Debugfs is weird like that.  I will send a patch to revert this=
.
>
> >  }

Thanks for your comment Dan.=20
I've added my reviewed-by to the patch that you sent out.
Thanks for your change.

> >  /*
> > diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.=
c
> > index b2669f2ddb53..8dba1168b652 100644
> > --- a/drivers/scsi/fnic/fnic_fcs.c
> > +++ b/drivers/scsi/fnic/fnic_fcs.c
> > @@ -63,6 +63,22 @@ static inline  void fnic_fdls_set_fcoe_dstmac(struct=
 fnic *fnic,
> >     memcpy(fnic->iport.fcfmac, dst_mac, 6);
> >  }
> >
> > +void fnic_get_host_port_state(struct Scsi_Host *shost)
> > +{
> > +   struct fnic *fnic =3D *((struct fnic **) shost_priv(shost));
> > +   struct fnic_iport_s *iport =3D &fnic->iport;
> > +   unsigned long flags;
> > +
> > +   spin_lock_irqsave(&fnic->fnic_lock, flags);
> > +   if (!fnic->link_status)
> > +           fc_host_port_state(shost) =3D FC_PORTSTATE_LINKDOWN;
> > +   else if (iport->state =3D=3D FNIC_IPORT_STATE_READY)
> > +           fc_host_port_state(shost) =3D FC_PORTSTATE_ONLINE;
> > +   else
> > +           fc_host_port_state(shost) =3D FC_PORTSTATE_OFFLINE;
> > +   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> > +}
> > +
> >  void fnic_fdls_link_status_change(struct fnic *fnic, int linkup)
> >  {
> >     struct fnic_iport_s *iport =3D &fnic->iport;
> > diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_mai=
n.c
> > index a6c2cb49465b..44cbb04b2421 100644
> > --- a/drivers/scsi/fnic/fnic_main.c
> > +++ b/drivers/scsi/fnic/fnic_main.c
> > @@ -67,6 +67,11 @@ unsigned int fnic_fdmi_support =3D 1;
> >  module_param(fnic_fdmi_support, int, 0644);
> >  MODULE_PARM_DESC(fnic_fdmi_support, "FDMI support");
> >
> > +static unsigned int fnic_tgt_id_binding =3D 1;
> > +module_param(fnic_tgt_id_binding, uint, 0644);
> > +MODULE_PARM_DESC(fnic_tgt_id_binding,
> > +            "Target ID binding (0 for none. 1 for binding by WWPN (def=
ault))");
> > +
> >  unsigned int io_completions =3D FNIC_DFLT_IO_COMPLETIONS;
> >  module_param(io_completions, int, S_IRUGO|S_IWUSR);
> >  MODULE_PARM_DESC(io_completions, "Max CQ entries to process at a time"=
);
> > @@ -146,7 +151,7 @@ static struct fc_function_template fnic_fc_function=
s =3D {
> >     .get_host_speed =3D fnic_get_host_speed,
> >     .show_host_speed =3D 1,
> >     .show_host_port_type =3D 1,
> > -   .get_host_port_state =3D fc_get_host_port_state,
> > +   .get_host_port_state =3D fnic_get_host_port_state,
> >     .show_host_port_state =3D 1,
> >     .show_host_symbolic_name =3D 1,
> >     .show_rport_maxframe_size =3D 1,
> > @@ -158,79 +163,79 @@ static struct fc_function_template fnic_fc_functi=
ons =3D {
> >     .show_rport_dev_loss_tmo =3D 1,
> >     .set_rport_dev_loss_tmo =3D fnic_set_rport_dev_loss_tmo,
> >     .issue_fc_host_lip =3D fnic_issue_fc_host_lip,
> > -   .get_fc_host_stats =3D fnic_get_stats,
> > +   .get_fc_host_stats =3D NULL,
>
> This line should have been deleted.  It will be initialized to zero
> automatically.

Thanks Dan. fnic_get_stats gets added in a subsequent patch in the series.
I get your point though.

> >     .reset_fc_host_stats =3D fnic_reset_host_stats,
> > -   .dd_fcrport_size =3D sizeof(struct fc_rport_libfc_priv),
> > +   .dd_fcrport_size =3D sizeof(struct rport_dd_data_s),
> >     .terminate_rport_io =3D fnic_terminate_rport_io,
> > -   .bsg_request =3D fc_lport_bsg_request,
> > +   .bsg_request =3D NULL,
>
> Same.  Just delete the line.

Thanks Dan.
This will be addressed in a future patch.

> >  };
> >
> >  static void fnic_get_host_speed(struct Scsi_Host *shost)
> >  {
> > -   struct fc_lport *lp =3D shost_priv(shost);
> > -   struct fnic *fnic =3D lport_priv(lp);
> > +   struct fnic *fnic =3D *((struct fnic **) shost_priv(shost));
> >     u32 port_speed =3D vnic_dev_port_speed(fnic->vdev);
> >
> > +   FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> > +                             "port_speed: %d Mbps", port_speed);
> > +
> >     /* Add in other values as they get defined in fw */
> >     switch (port_speed) {
> > +   case DCEM_PORTSPEED_1G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_1GBIT;
> > +           break;
> > +   case DCEM_PORTSPEED_2G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_2GBIT;
> > +           break;
> > +   case DCEM_PORTSPEED_4G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_4GBIT;
> > +           break;
> > +   case DCEM_PORTSPEED_8G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_8GBIT;
> > +           break;
> >     case DCEM_PORTSPEED_10G:
> >             fc_host_speed(shost) =3D FC_PORTSPEED_10GBIT;
> >             break;
> > +   case DCEM_PORTSPEED_16G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_16GBIT;
> > +           break;
> >     case DCEM_PORTSPEED_20G:
> >             fc_host_speed(shost) =3D FC_PORTSPEED_20GBIT;
> >             break;
> >     case DCEM_PORTSPEED_25G:
> >             fc_host_speed(shost) =3D FC_PORTSPEED_25GBIT;
> >             break;
> > +   case DCEM_PORTSPEED_32G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_32GBIT;
> > +           break;
> >     case DCEM_PORTSPEED_40G:
> >     case DCEM_PORTSPEED_4x10G:
> >             fc_host_speed(shost) =3D FC_PORTSPEED_40GBIT;
> >             break;
> > +   case DCEM_PORTSPEED_50G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_50GBIT;
> > +           break;
> > +   case DCEM_PORTSPEED_64G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_64GBIT;
> > +           break;
> >     case DCEM_PORTSPEED_100G:
> >             fc_host_speed(shost) =3D FC_PORTSPEED_100GBIT;
> >             break;
> > +   case DCEM_PORTSPEED_128G:
> > +           fc_host_speed(shost) =3D FC_PORTSPEED_128GBIT;
> > +           break;
>
> This change could have been done in its own patch.

Thanks for your comment Dan. I understand.

> >     default:
> > +           FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> > +                                     "Unknown FC speed: %d Mbps", port=
_speed);
> >             fc_host_speed(shost) =3D FC_PORTSPEED_UNKNOWN;
> >             break;
> >     }
> >  }
> >
> > +/* Placeholder function */
>
> What does this comment mean?  What is it a placeholder for?

Thanks Dan. As mentioned in the cover letter, a few functions
were placed as placeholders to prevent compilation errors and warnings.
I would see warnings like: Function defined but not used, or,
there would be a loader error mentioning that the function was not
defined. I get your point however.

> >  static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *hos=
t)
> >  {
> > -   int ret;
> > -   struct fc_lport *lp =3D shost_priv(host);
> > -   struct fnic *fnic =3D lport_priv(lp);
> > -   struct fc_host_statistics *stats =3D &lp->host_stats;
> > -   struct vnic_stats *vs;
> > -   unsigned long flags;
> > -
> > -   if (time_before(jiffies, fnic->stats_time + HZ / FNIC_STATS_RATE_LI=
MIT))
> > -           return stats;
> > -   fnic->stats_time =3D jiffies;
> > -
> > -   spin_lock_irqsave(&fnic->fnic_lock, flags);
> > -   ret =3D vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
> > -   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> > -
> > -   if (ret) {
> > -           FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num=
,
> > -                         "fnic: Get vnic stats failed"
> > -                         " 0x%x", ret);
> > -           return stats;
> > -   }
> > -   vs =3D fnic->stats;
> > -   stats->tx_frames =3D vs->tx.tx_unicast_frames_ok;
> > -   stats->tx_words  =3D vs->tx.tx_unicast_bytes_ok / 4;
> > -   stats->rx_frames =3D vs->rx.rx_unicast_frames_ok;
> > -   stats->rx_words  =3D vs->rx.rx_unicast_bytes_ok / 4;
> > -   stats->error_frames =3D vs->tx.tx_errors + vs->rx.rx_errors;
> > -   stats->dumped_frames =3D vs->tx.tx_drops + vs->rx.rx_drop;
> > -   stats->invalid_crc_count =3D vs->rx.rx_crc_errors;
> > -   stats->seconds_since_last_reset =3D
> > -                   (jiffies - fnic->stats_reset_time) / HZ;
> > -   stats->fcp_input_megabytes =3D div_u64(fnic->fcp_input_bytes, 10000=
00);
> > -   stats->fcp_output_megabytes =3D div_u64(fnic->fcp_output_bytes, 100=
0000);
> > -
> > +   struct fnic *fnic =3D *((struct fnic **) shost_priv(host));
> > +   struct fc_host_statistics *stats =3D &fnic->fnic_stats.host_stats;
> >     return stats;
>
> This is a checkpatch warning because there should be a blank line after
> the decarations.  It's a bit tricky because you will need to apply the
> patch and then re-run checkpatch.pl -f on the patched file to see this
> warning.

Thanks for pointing it out Dan. I was not aware of this.

> >  }
> >
> > @@ -311,8 +316,7 @@ void fnic_dump_fchost_stats(struct Scsi_Host *host,
> >  static void fnic_reset_host_stats(struct Scsi_Host *host)
> >  {
> >     int ret;
> > -   struct fc_lport *lp =3D shost_priv(host);
> > -   struct fnic *fnic =3D lport_priv(lp);
> > +   struct fnic *fnic =3D *((struct fnic **) shost_priv(host));
> >     struct fc_host_statistics *stats;
> >     unsigned long flags;
> >
> > @@ -527,9 +531,23 @@ static void fnic_set_vlan(struct fnic *fnic, u16 v=
lan_id)
> >     vnic_dev_set_default_vlan(fnic->vdev, vlan_id);
> >  }
> >
> > +static void fnic_scsi_init(struct fnic *fnic)
> > +{
> > +   struct Scsi_Host *host =3D fnic->lport->host;
> > +
> > +   snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
>
> The - 1 is wrong.  It should be:
>
> snprintf(fnic->name, sizeof(fnic->name), "%s%d", DRV_NAME,
>
> > +                    host->host_no);
> > +

Thanks for your comment Dan.
This will be addressed in a future patch.

> > +   host->transportt =3D fnic_fc_transport;
> > +}
> > +
> >  static int fnic_scsi_drv_init(struct fnic *fnic)
> >  {
> >     struct Scsi_Host *host =3D fnic->lport->host;
> > +   int err;
> > +   struct pci_dev *pdev =3D fnic->pdev;
> > +   struct fnic_iport_s *iport =3D &fnic->iport;
> > +   int hwq;
> >
> >     /* Configure maximum outstanding IO reqs*/
> >     if (fnic->config.io_throttle_count !=3D FNIC_UCSM_DFLT_THROTTLE_CNT=
_BLD)
> > @@ -540,7 +558,7 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
> >     fnic->fnic_max_tag_id =3D host->can_queue;
> >     host->max_lun =3D fnic->config.luns_per_tgt;
> >     host->max_id =3D FNIC_MAX_FCP_TARGET;
> > -   host->max_cmd_len =3D FCOE_MAX_CMD_LEN;
> > +   host->max_cmd_len =3D FNIC_FCOE_MAX_CMD_LEN;
> >
> >     host->nr_hw_queues =3D fnic->wq_copy_count;
> >
> > @@ -550,13 +568,62 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
> >     dev_info(&fnic->pdev->dev, "fnic: max_id: %d max_cmd_len: %d nr_hw_=
queues: %d",
> >                     host->max_id, host->max_cmd_len, host->nr_hw_queues=
);
> >
> > +   for (hwq =3D 0; hwq < fnic->wq_copy_count; hwq++) {
> > +           fnic->sw_copy_wq[hwq].ioreq_table_size =3D fnic->fnic_max_t=
ag_id;
> > +           fnic->sw_copy_wq[hwq].io_req_table =3D
> > +                   kzalloc((fnic->sw_copy_wq[hwq].ioreq_table_size + 1=
) *
> ^^^^^^^^^^^^^^^^^^^^
>
> The name of this variable is "table_size" but apparently it is the size -=
 1.
> This is only used in debug output so just change the previous line to:
>
> fnic->sw_copy_wq[hwq].ioreq_table_size =3D fnic->fnic_max_tag_id + 1;
>
> > +                                   sizeof(struct fnic_io_req *), GFP_K=
ERNEL);
> > +   }

Thanks Dan. We will address this in a future patch.

> > +   dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table size:=
 %d\n",
> > +                   fnic->wq_copy_count, fnic->sw_copy_wq[0].ioreq_tabl=
e_size);
>
> dev_dbg().  This patch has a number of these debug printks which are at
> dev_info() levels.

Thanks Dan. We will address this in a future patch.

> > +
> > +   fnic_scsi_init(fnic);
> > +
> > +   err =3D scsi_add_host(fnic->lport->host, &pdev->dev);
> > +   if (err) {
> > +           dev_err(&fnic->pdev->dev, "fnic: scsi add host failed: abor=
ting\n");
> > +           return -1;
>
> Propogate the error code.  Don't return -EPERM.  Do we need to clean up
> the fnic->sw_copy_wq[hwq].io_req_table allocations?

Thanks Dan. We will address this in a future patch.

> > +   }
> > +   fc_host_maxframe_size(fnic->lport->host) =3D iport->max_payload_siz=
e;
> > +   fc_host_dev_loss_tmo(fnic->lport->host) =3D
> > +           fnic->config.port_down_timeout / 1000;
> > +   sprintf(fc_host_symbolic_name(fnic->lport->host),
> > +                   DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
> > +   fc_host_port_type(fnic->lport->host) =3D FC_PORTTYPE_NPORT;
> > +   fc_host_node_name(fnic->lport->host) =3D iport->wwnn;
> > +   fc_host_port_name(fnic->lport->host) =3D iport->wwpn;
> > +   fc_host_supported_classes(fnic->lport->host) =3D FC_COS_CLASS3;
> > +   memset(fc_host_supported_fc4s(fnic->lport->host), 0,
> > +              sizeof(fc_host_supported_fc4s(fnic->lport->host)));
> > +   fc_host_supported_fc4s(fnic->lport->host)[2] =3D 1;
> > +   fc_host_supported_fc4s(fnic->lport->host)[7] =3D 1;
> > +   fc_host_supported_speeds(fnic->lport->host) =3D 0;
> > +   fc_host_supported_speeds(fnic->lport->host) |=3D FC_PORTSPEED_8GBIT=
;
>
> Just say:
>
> fc_host_supported_speeds(fnic->lport->host) =3D FC_PORTSPEED_8GBIT;
>
> > +
> > +   dev_info(&fnic->pdev->dev, "shost_data: 0x%p\n", fnic->lport->host-=
>shost_data);
>
> Delete this line.

Thanks Dan. We will address this in a future patch.

>
> > +   if (fnic->lport->host->shost_data !=3D NULL) {
>
> Checkpatch.

Thanks Dan. We will address this in a future patch.

> > +           if (fnic_tgt_id_binding =3D=3D 0) {
> > +                   dev_info(&fnic->pdev->dev, "Setting target binding =
to NONE\n");
> > +                   fc_host_tgtid_bind_type(fnic->lport->host) =3D FC_T=
GTID_BIND_NONE;
> > +           } else {
> > +                   dev_info(&fnic->pdev->dev, "Setting target binding =
to WWPN\n");
> > +                   fc_host_tgtid_bind_type(fnic->lport->host) =3D FC_T=
GTID_BIND_BY_WWPN;
> > +           }
> > +   }
> > +
> > +   fnic->io_req_pool =3D mempool_create_slab_pool(2, fnic_io_req_cache=
);
> > +   if (!fnic->io_req_pool) {
> > +           scsi_remove_host(fnic->lport->host);
>
> Do we need to clean up the fnic->sw_copy_wq[hwq].io_req_table
> allocations?

Thanks Dan. We have not seen any issues so far.
We will re-examine this for a future patch.

> > +           return -ENOMEM;
> > +   }
> > +
> >     return 0;
> >  }
> >
> >  void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
> >  {
> > -   struct fc_lport *lp =3D shost_priv(host);
> > -   struct fnic *fnic =3D lport_priv(lp);
> > +   struct fnic *fnic =3D *((struct fnic **) shost_priv(host));
> >     struct pci_dev *l_pdev =3D fnic->pdev;
> >     int intr_mode =3D fnic->config.intr_mode;
> >     struct blk_mq_queue_map *qmap =3D &host->tag_set.map[HCTX_TYPE_DEFA=
ULT];
> > @@ -581,31 +648,27 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *ho=
st)
> >
> >  static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id=
 *ent)
> >  {
> > -   struct Scsi_Host *host;
> > -   struct fc_lport *lp;
> > +   struct Scsi_Host *host =3D NULL;
>
> I can't see how this is required or related but I could be wrong.

Thanks Dan. I see your point.

> >     struct fnic *fnic;
> >     mempool_t *pool;
> > +   struct fnic_iport_s *iport;
> >     int err =3D 0;
> >     int fnic_id =3D 0;
> >     int i;
> >     unsigned long flags;
> > -   int hwq;
> >     char *desc, *subsys_desc;
> >     int len;
> >
> >     /*
> > -    * Allocate SCSI Host and set up association between host,
> > -    * local port, and fnic
> > +    * Allocate fnic
> >      */
> > -   lp =3D libfc_host_alloc(&fnic_host_template, sizeof(struct fnic));
> > -   if (!lp) {
> > -           dev_err(&pdev->dev, "Unable to alloc libfc local port\n");
> > +   fnic =3D kzalloc(sizeof(struct fnic), GFP_KERNEL);
> > +   if (!fnic) {
> >             err =3D -ENOMEM;
> > -           goto err_out;
> > +           goto err_out_fnic_alloc;
>
> This patch renames all the error labels from describing what they do, to
> being in ComeFrom style.  In my opinion, the original names were MUCH
> better.  I added a section on label names to the
> Documentation/process/coding-style.rst file but I wasn't going to
> complain about here.  Except, the issue is that it's totally unrelated to
> FDLS and unrelated changes should have been flagged during review.

Thanks Dan. I understand.
I have reviewed the file. This can be addressed in a future patch.

> >     }
> >
> > -   host =3D lp->host;
> > -   fnic =3D lport_priv(lp);
> > +   iport =3D &fnic->iport;
> >
> >     fnic_id =3D ida_alloc(&fnic_ida, GFP_KERNEL);
> >     if (fnic_id < 0) {
> > @@ -613,17 +676,9 @@ static int fnic_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
> >             err =3D fnic_id;
> >             goto err_out_ida_alloc;
> >     }
> > -   fnic->lport =3D lp;
> > -   fnic->ctlr.lp =3D lp;
> > -   fnic->link_events =3D 0;
> > -   fnic->pdev =3D pdev;
> >
> > -   snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
> > -            host->host_no);
> > -
> > -   host->transportt =3D fnic_fc_transport;
> > +   fnic->pdev =3D pdev;
> >     fnic->fnic_num =3D fnic_id;
> > -   fnic_stats_debugfs_init(fnic);
> >
> >     /* Find model name from PCIe subsys ID */
> >     if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) =3D=3D 0) {
> > @@ -645,13 +700,13 @@ static int fnic_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
> >     err =3D pci_enable_device(pdev);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "Cannot enable PCI device, aborti=
ng.\n");
> > -           goto err_out_free_hba;
> > +           goto err_out_pci_enable_device;
> >     }
> >
> >     err =3D pci_request_regions(pdev, DRV_NAME);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "Cannot enable PCI resources, abo=
rting\n");
> > -           goto err_out_disable_device;
> > +           goto err_out_pci_request_regions;
> >     }
> >
> >     pci_set_master(pdev);
> > @@ -666,7 +721,7 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
> >             if (err) {
> >                     dev_err(&fnic->pdev->dev, "No usable DMA configurat=
ion "
> >                                  "aborting\n");
> > -                   goto err_out_release_regions;
> > +                   goto err_out_set_dma_mask;
> >             }
> >     }
> >
> > @@ -674,7 +729,7 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
> >     if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
> >             dev_err(&fnic->pdev->dev, "BAR0 not memory-map'able, aborti=
ng.\n");
> >             err =3D -ENODEV;
> > -           goto err_out_release_regions;
> > +           goto err_out_map_bar;
> >     }
> >
> >     fnic->bar0.vaddr =3D pci_iomap(pdev, 0, 0);
> > @@ -685,7 +740,7 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
> >             dev_err(&fnic->pdev->dev, "Cannot memory-map BAR0 res hdr, =
"
> >                          "aborting.\n");
> >             err =3D -ENODEV;
> > -           goto err_out_release_regions;
> > +           goto err_out_fnic_map_bar;
> >     }
> >
> >     fnic->vdev =3D vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
> > @@ -693,43 +748,68 @@ static int fnic_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
> >             dev_err(&fnic->pdev->dev, "vNIC registration failed, "
> >                          "aborting.\n");
> >             err =3D -ENODEV;
> > -           goto err_out_iounmap;
> > +           goto err_out_dev_register;
> >     }
> >
> >     err =3D vnic_dev_cmd_init(fnic->vdev);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "vnic_dev_cmd_init() returns %d, =
aborting\n",
> >                             err);
> > -           goto err_out_vnic_unregister;
> > +           goto err_out_dev_cmd_init;
> >     }
> >
> >     err =3D fnic_dev_wait(fnic->vdev, vnic_dev_open,
> >                         vnic_dev_open_done, CMD_OPENF_RQ_ENABLE_THEN_PO=
ST);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "vNIC dev open failed, aborting.\=
n");
> > -           goto err_out_dev_cmd_deinit;
> > +           goto err_out_dev_open;
> >     }
> >
> >     err =3D vnic_dev_init(fnic->vdev, 0);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "vNIC dev init failed, aborting.\=
n");
> > -           goto err_out_dev_close;
> > +           goto err_out_dev_init;
> >     }
> >
> > -   err =3D vnic_dev_mac_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
> > +   err =3D vnic_dev_mac_addr(fnic->vdev, iport->hwmac);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "vNIC get MAC addr failed\n");
> > -           goto err_out_dev_close;
> > +           goto err_out_dev_mac_addr;
> >     }
> >     /* set data_src for point-to-point mode and to keep it non-zero */
> > -   memcpy(fnic->data_src_addr, fnic->ctlr.ctl_src_addr, ETH_ALEN);
> > +   memcpy(fnic->data_src_addr, iport->hwmac, ETH_ALEN);
> >
> >     /* Get vNIC configuration */
> >     err =3D fnic_get_vnic_config(fnic);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "Get vNIC configuration failed, "
> >                          "aborting.\n");
> > -           goto err_out_dev_close;
> > +           goto err_out_fnic_get_config;
> > +   }
> > +
> > +   switch (fnic->config.flags & 0xff0) {
> > +   case VFCF_FC_INITIATOR:
> > +           {
> > +                   host =3D
> > +                           scsi_host_alloc(&fnic_host_template,
> > +                                                           sizeof(stru=
ct fnic *));
>
> White space.

Addressed above.

>
> > +                   if (!host) {
> > +                           dev_err(&fnic->pdev->dev, "Unable to alloca=
te scsi host\n");
> > +                           err =3D -ENOMEM;
> > +                           goto err_out_scsi_host_alloc;
> > +                   }
> > +                   *((struct fnic **) shost_priv(host)) =3D fnic;
> > +
> > +                   fnic->lport->host =3D host;
> > +                   fnic->role =3D FNIC_ROLE_FCP_INITIATOR;
> > +                   dev_info(&fnic->pdev->dev, "fnic: %d is scsi initia=
tor\n",
> > +                                   fnic->fnic_num);
>
> dev_dbg()

Thanks Dan. We would like to keep this as it is.

>
> > +           }
> > +           break;
> > +   default:
> > +           dev_info(&fnic->pdev->dev, "fnic: %d has no role defined\n"=
, fnic->fnic_num);
>
> dev_err()

Thanks Dan. We will address this in a future patch.

>
> > +           err =3D -EINVAL;
> > +           goto err_out_fnic_role;
> >     }
> >
> >     /* Setup PCI resources */
> > @@ -741,23 +821,14 @@ static int fnic_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "Failed to set intr mode, "
> >                          "aborting.\n");
> > -           goto err_out_dev_close;
> > +           goto err_out_fnic_set_intr_mode;
> >     }
> >
> >     err =3D fnic_alloc_vnic_resources(fnic);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "Failed to alloc vNIC resources, =
"
> >                          "aborting.\n");
> > -           goto err_out_clear_intr;
> > -   }
> > -
> > -   fnic_scsi_drv_init(fnic);
> > -
> > -   for (hwq =3D 0; hwq < fnic->wq_copy_count; hwq++) {
> > -           fnic->sw_copy_wq[hwq].ioreq_table_size =3D fnic->fnic_max_t=
ag_id;
> > -           fnic->sw_copy_wq[hwq].io_req_table =3D
> > -                                   kzalloc((fnic->sw_copy_wq[hwq].iore=
q_table_size + 1) *
> > -                                   sizeof(struct fnic_io_req *), GFP_K=
ERNEL);
> > +           goto err_out_fnic_alloc_vnic_res;
> >     }
> >     dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table size:=
 %d\n",
> >                     fnic->wq_copy_count, fnic->sw_copy_wq[0].ioreq_tabl=
e_size);
> > @@ -775,14 +846,9 @@ static int fnic_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
> >             fnic->fw_ack_index[i] =3D -1;
> >     }
> >
> > -   err =3D -ENOMEM;
> > -   fnic->io_req_pool =3D mempool_create_slab_pool(2, fnic_io_req_cache=
);
> > -   if (!fnic->io_req_pool)
> > -           goto err_out_free_resources;
> > -
> >     pool =3D mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_=
DFLT]);
> >     if (!pool)
> > -           goto err_out_free_ioreq_pool;
> > +           goto err_out_free_resources;
> >     fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] =3D pool;
> >
> >     pool =3D mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_=
MAX]);
> > @@ -810,8 +876,7 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
> >             /* enable directed and multicast */
> >             vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
> >             vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
> > -           vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
> > -           fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_AUTO);
> > +           vnic_dev_add_addr(fnic->vdev, iport->hwmac);
> >             spin_lock_init(&fnic->vlans_lock);
> >             INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
> >             INIT_LIST_HEAD(&fnic->fip_frame_queue);
> > @@ -823,8 +888,6 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
> >             fnic->set_vlan =3D fnic_set_vlan;
> >     } else {
> >             dev_info(&fnic->pdev->dev, "firmware uses non-FIP mode\n");
> > -           fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_NON_FIP);
> > -           fnic->ctlr.state =3D FIP_ST_NON_FIP;
> >     }
> >     fnic->state =3D FNIC_IN_FC_MODE;
> >
> > @@ -838,7 +901,7 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
> >     err =3D fnic_notify_set(fnic);
> >     if (err) {
> >             dev_err(&fnic->pdev->dev, "Failed to alloc notify buffer, a=
borting.\n");
> > -           goto err_out_free_max_pool;
> > +           goto err_out_fnic_notify_set;
> >     }
> >
> >     /* Setup notify timer when using MSI interrupts */
> > @@ -851,80 +914,43 @@ static int fnic_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
> >             if (err) {
> >                     dev_err(&fnic->pdev->dev, "fnic_alloc_rq_frame can'=
t alloc "
> >                                  "frame\n");
> > -                   goto err_out_rq_buf;
> > +                   goto err_out_alloc_rq_buf;
> >             }
> >     }
> >
> > -   /* Enable all queues */
> > -   for (i =3D 0; i < fnic->raw_wq_count; i++)
> > -           vnic_wq_enable(&fnic->wq[i]);
> > -   for (i =3D 0; i < fnic->rq_count; i++) {
> > -           if (!ioread32(&fnic->rq[i].ctrl->enable))
> > -                   vnic_rq_enable(&fnic->rq[i]);
> > -   }
> > -   for (i =3D 0; i < fnic->wq_copy_count; i++)
> > -           vnic_wq_copy_enable(&fnic->hw_copy_wq[i]);
> > +   init_completion(&fnic->reset_completion_wait);
> >
> > -   err =3D fnic_request_intr(fnic);
> > -   if (err) {
> > -           dev_err(&fnic->pdev->dev, "Unable to request irq.\n");
> > -           goto err_out_request_intr;
> > -   }
> > -
> > -   /*
> > -    * Initialization done with PCI system, hardware, firmware.
> > -    * Add host to SCSI
> > -    */
> > -   err =3D scsi_add_host(lp->host, &pdev->dev);
> > -   if (err) {
> > -           dev_err(&fnic->pdev->dev, "fnic: scsi_add_host failed...exi=
ting\n");
> > -           goto err_out_scsi_add_host;
> > -   }
> > -
> > -
> > -   /* Start local port initiatialization */
> > -
> > -   lp->link_up =3D 0;
> > -
> > -   lp->max_retry_count =3D fnic->config.flogi_retries;
> > -   lp->max_rport_retry_count =3D fnic->config.plogi_retries;
> > -   lp->service_params =3D (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
> > -                         FCP_SPPF_CONF_COMPL);
> > +   /* Start local port initialization */
> > +   iport->max_flogi_retries =3D fnic->config.flogi_retries;
> > +   iport->max_plogi_retries =3D fnic->config.plogi_retries;
> > +   iport->plogi_timeout =3D fnic->config.plogi_timeout;
> > +   iport->service_params =3D
> > +           (FNIC_FCP_SP_INITIATOR | FNIC_FCP_SP_RD_XRDY_DIS |
> > +            FNIC_FCP_SP_CONF_CMPL);
> >     if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
> > -           lp->service_params |=3D FCP_SPPF_RETRY;
> > -
> > -   lp->boot_time =3D jiffies;
> > -   lp->e_d_tov =3D fnic->config.ed_tov;
> > -   lp->r_a_tov =3D fnic->config.ra_tov;
> > -   lp->link_supported_speeds =3D FC_PORTSPEED_10GBIT;
> > -   fc_set_wwnn(lp, fnic->config.node_wwn);
> > -   fc_set_wwpn(lp, fnic->config.port_wwn);
> > -
> > -   if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, FCPIO_HOST_EXCH_RANGE_START,
> > -                          FCPIO_HOST_EXCH_RANGE_END, NULL)) {
> > -           err =3D -ENOMEM;
> > -           goto err_out_fc_exch_mgr_alloc;
> > -   }
> > +           iport->service_params |=3D FNIC_FCP_SP_RETRY;
> >
> > -   fc_lport_init_stats(lp);
> > -   fnic->stats_reset_time =3D jiffies;
> > +   iport->boot_time =3D jiffies;
> > +   iport->e_d_tov =3D fnic->config.ed_tov;
> > +   iport->r_a_tov =3D fnic->config.ra_tov;
> > +   iport->link_supported_speeds =3D FNIC_PORTSPEED_10GBIT;
> > +   iport->wwpn =3D fnic->config.port_wwn;
> > +   iport->wwnn =3D fnic->config.node_wwn;
> >
> > -   fc_lport_config(lp);
> > +   iport->max_payload_size =3D fnic->config.maxdatafieldsize;
> >
> > -   if (fc_set_mfs(lp, fnic->config.maxdatafieldsize +
> > -                  sizeof(struct fc_frame_header))) {
> > -           err =3D -EINVAL;
> > -           goto err_out_free_exch_mgr;
> > +   if ((iport->max_payload_size < FNIC_MIN_DATA_FIELD_SIZE) ||
> > +           (iport->max_payload_size > FNIC_FC_MAX_PAYLOAD_LEN) ||
> > +           ((iport->max_payload_size % 4) !=3D 0)) {
> > +           iport->max_payload_size =3D FNIC_FC_MAX_PAYLOAD_LEN;
> >     }
> > -   fc_host_maxframe_size(lp->host) =3D lp->mfs;
> > -   fc_host_dev_loss_tmo(lp->host) =3D fnic->config.port_down_timeout /=
 1000;
> >
> > -   sprintf(fc_host_symbolic_name(lp->host),
> > -           DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
> > +   iport->flags |=3D FNIC_FIRST_LINK_UP;
> >
> > -   spin_lock_irqsave(&fnic_list_lock, flags);
> > -   list_add_tail(&fnic->list, &fnic_list);
> > -   spin_unlock_irqrestore(&fnic_list_lock, flags);
> > +   timer_setup(&(iport->fabric.retry_timer), fdls_fabric_timer_callbac=
k,
> > +                           0);
> > +
> > +   fnic->stats_reset_time =3D jiffies;
> >
> >     INIT_WORK(&fnic->link_work, fnic_handle_link);
> >     INIT_WORK(&fnic->frame_work, fnic_handle_frame);
> > @@ -935,71 +961,110 @@ static int fnic_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *ent)
> >     INIT_LIST_HEAD(&fnic->tx_queue);
> >     INIT_LIST_HEAD(&fnic->tport_event_list);
> >
> > -   fc_fabric_login(lp);
> > +   INIT_DELAYED_WORK(&iport->oxid_pool.schedule_oxid_free_retry,
> > +   fdls_schedule_oxid_free_retry_work);
> > +
> > +   /* Initialize the oxid reclaim list and work struct */
> > +   INIT_LIST_HEAD(&iport->oxid_pool.oxid_reclaim_list);
> > +   INIT_DELAYED_WORK(&iport->oxid_pool.oxid_reclaim_work, fdls_reclaim=
_oxid_handler);
> > +
> > +   /* Enable all queues */
> > +   for (i =3D 0; i < fnic->raw_wq_count; i++)
> > +           vnic_wq_enable(&fnic->wq[i]);
> > +   for (i =3D 0; i < fnic->rq_count; i++) {
> > +           if (!ioread32(&fnic->rq[i].ctrl->enable))
> > +                   vnic_rq_enable(&fnic->rq[i]);
> > +   }
> > +   for (i =3D 0; i < fnic->wq_copy_count; i++)
> > +           vnic_wq_copy_enable(&fnic->hw_copy_wq[i]);
> >
> >     vnic_dev_enable(fnic->vdev);
> >
> > +   err =3D fnic_request_intr(fnic);
> > +   if (err) {
> > +           dev_err(&fnic->pdev->dev, "Unable to request irq.\n");
> > +           goto err_out_fnic_request_intr;
> > +   }
> > +
> > +   fnic_notify_timer_start(fnic);
> > +
> > +   fnic_fdls_init(fnic, (fnic->config.flags & VFCF_FIP_CAPABLE));
> > +
> > +   if (IS_FNIC_FCP_INITIATOR(fnic) && fnic_scsi_drv_init(fnic))
>
> We know that IS_FNIC_FCP_INITIATOR() is true.  Presumably this is stub
> code which will make sense in the future.  These kinds of known true
> stub code conditions are discouraged because we can not predict the
> future or review future code which we have not seen.  For exmample,
> this call to fnic_scsi_drv_init() is cleaned up by
>
> scsi_remove_host(fnic->lport->host);
>
> But we would expect the condition to be consistent in both the allocation
> code and the tear down code.
>
> if (IS_FNIC_FCP_INITIATOR(fnic))
> scsi_remove_host(lp->host);
>
> In fact, ideally the tear down here would match the code in the remove
> function.
>
> if (IS_FNIC_FCP_INITIATOR(fnic))
> fnic_scsi_unload(fnic);
>
> Does that matter?  It doesn't matter *now* but to answer that question
> properly depends on the future code which has not been writtten.

Thanks Dan. You are right.
As mentioned in the cover letter, we have a feature that we are planning to=
 submit
upstream: NVME initiator.
I understand your point. This will be addressed in a future patch.

> > +           goto err_out_scsi_drv_init;
> > +
> > +   err =3D fnic_stats_debugfs_init(fnic);
> > +   if (err) {
> > +           dev_err(&fnic->pdev->dev, "Failed to initialize debugfs for=
 stats\n");
> > +           goto err_out_free_stats_debugfs;
>
> This goto frees the fnic_stats_debugfs_init() stuff which we failed to
> allocate.  It's harmless, but generally, we would only free resources
> which have been successfully allocated.

Thanks Dan. So far, we have not faced any issues w.r.t this, even while dev=
 testing.
We would like to keep this as it is.

> > +   }
> > +
> >     for (i =3D 0; i < fnic->intr_count; i++)
> >             vnic_intr_unmask(&fnic->intr[i]);
> >
> > -   fnic_notify_timer_start(fnic);
> > +   spin_lock_irqsave(&fnic_list_lock, flags);
> > +   list_add_tail(&fnic->list, &fnic_list);
> > +   spin_unlock_irqrestore(&fnic_list_lock, flags);
> >
> >     return 0;
> >
> > -err_out_free_exch_mgr:
> > -   fc_exch_mgr_free(lp);
> > -err_out_fc_exch_mgr_alloc:
> > -   fc_remove_host(lp->host);
> > -   scsi_remove_host(lp->host);
> > -err_out_scsi_add_host:
> > +err_out_free_stats_debugfs:
> > +   fnic_stats_debugfs_remove(fnic);
> > +   scsi_remove_host(fnic->lport->host);
> > +err_out_scsi_drv_init:
> >     fnic_free_intr(fnic);
> > -err_out_request_intr:
> > -   for (i =3D 0; i < fnic->rq_count; i++)
> > +err_out_fnic_request_intr:
> > +err_out_alloc_rq_buf:
> > +   for (i =3D 0; i < fnic->rq_count; i++) {
> > +           if (ioread32(&fnic->rq[i].ctrl->enable))
> > +                   vnic_rq_disable(&fnic->rq[i]);
> >             vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
> > -err_out_rq_buf:
> > +   }
> >     vnic_dev_notify_unset(fnic->vdev);
> > +err_out_fnic_notify_set:
> >     mempool_destroy(fnic->frame_elem_pool);
> >  err_out_fdls_frame_elem_pool:
> >     mempool_destroy(fnic->frame_pool);
> >  err_out_fdls_frame_pool:
> > -err_out_free_max_pool:
> >     mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX]);
> >  err_out_free_dflt_pool:
> >     mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT]);
> > -err_out_free_ioreq_pool:
> > -   mempool_destroy(fnic->io_req_pool);
> >  err_out_free_resources:
> > -   for (hwq =3D 0; hwq < fnic->wq_copy_count; hwq++)
> > -           kfree(fnic->sw_copy_wq[hwq].io_req_table);
> >     fnic_free_vnic_resources(fnic);
> > -err_out_clear_intr:
> > +err_out_fnic_alloc_vnic_res:
> >     fnic_clear_intr_mode(fnic);
> > -err_out_dev_close:
> > +err_out_fnic_set_intr_mode:
> > +   if (IS_FNIC_FCP_INITIATOR(fnic))
> > +           scsi_host_put(fnic->lport->host);
> > +err_out_fnic_role:
> > +err_out_scsi_host_alloc:
> > +err_out_fnic_get_config:
> > +err_out_dev_mac_addr:
> > +err_out_dev_init:
> >     vnic_dev_close(fnic->vdev);
> > -err_out_dev_cmd_deinit:
> > -err_out_vnic_unregister:
> > +err_out_dev_open:
> > +err_out_dev_cmd_init:
> >     vnic_dev_unregister(fnic->vdev);
> > -err_out_iounmap:
> > +err_out_dev_register:
> >     fnic_iounmap(fnic);
> > -err_out_release_regions:
> > +err_out_fnic_map_bar:
> > +err_out_map_bar:
> > +err_out_set_dma_mask:
> >     pci_release_regions(pdev);
> > -err_out_disable_device:
> > +err_out_pci_request_regions:
> >     pci_disable_device(pdev);
> > -err_out_free_hba:
> > -   fnic_stats_debugfs_remove(fnic);
> > +err_out_pci_enable_device:
> >     ida_free(&fnic_ida, fnic->fnic_num);
> >  err_out_ida_alloc:
> > -   scsi_host_put(lp->host);
> > -err_out:
> > +   kfree(fnic);
> > +err_out_fnic_alloc:
> >     return err;
> >  }
> >
> >  static void fnic_remove(struct pci_dev *pdev)
> >  {
> >     struct fnic *fnic =3D pci_get_drvdata(pdev);
> > -   struct fc_lport *lp =3D fnic->lport;
> >     unsigned long flags;
> > -   int hwq;
> >
> >     /*
> >      * Sometimes when probe() fails and do not exit with an error code,
> > @@ -1009,26 +1074,21 @@ static void fnic_remove(struct pci_dev *pdev)
> >     if (!fnic)
> >             return;
> >
> > -   /*
> > -    * Mark state so that the workqueue thread stops forwarding
> > -    * received frames and link events to the local port. ISR and
> > -    * other threads that can queue work items will also stop
> > -    * creating work items on the fnic workqueue
> > -    */
> >     spin_lock_irqsave(&fnic->fnic_lock, flags);
> >     fnic->stop_rx_link_events =3D 1;
> >     spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> >
> > -   if (vnic_dev_get_intr_mode(fnic->vdev) =3D=3D VNIC_DEV_INTR_MODE_MS=
I)
> > -           del_timer_sync(&fnic->notify_timer);
> > -
> >     /*
> >      * Flush the fnic event queue. After this call, there should
> >      * be no event queued for this fnic device in the workqueue
> >      */
> >     flush_workqueue(fnic_event_queue);
> > -   fnic_free_txq(&fnic->frame_queue);
> > -   fnic_free_txq(&fnic->tx_queue);
> > +
> > +   if (IS_FNIC_FCP_INITIATOR(fnic))
> > +           fnic_scsi_unload(fnic);
> > +
> > +   if (vnic_dev_get_intr_mode(fnic->vdev) =3D=3D VNIC_DEV_INTR_MODE_MS=
I)
> > +           del_timer_sync(&fnic->notify_timer);
> >
> >     if (fnic->config.flags & VFCF_FIP_CAPABLE) {
> >             del_timer_sync(&fnic->retry_fip_timer);
> > @@ -1043,19 +1103,6 @@ static void fnic_remove(struct pci_dev *pdev)
> >     if ((fnic_fdmi_support =3D=3D 1) && (fnic->iport.fabric.fdmi_pendin=
g > 0))
> >             del_timer_sync(&fnic->iport.fabric.fdmi_timer);
> >
> > -   /*
> > -    * Log off the fabric. This stops all remote ports, dns port,
> > -    * logs off the fabric. This flushes all rport, disc, lport work
> > -    * before returning
> > -    */
> > -   fc_fabric_logoff(fnic->lport);
> > -
> > -   spin_lock_irqsave(&fnic->fnic_lock, flags);
> > -   fnic->in_remove =3D 1;
> > -   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> > -
> > -   fcoe_ctlr_destroy(&fnic->ctlr);
> > -   fc_lport_destroy(lp);
> >     fnic_stats_debugfs_remove(fnic);
> >
> >     /*
> > @@ -1069,11 +1116,9 @@ static void fnic_remove(struct pci_dev *pdev)
> >     list_del(&fnic->list);
> >     spin_unlock_irqrestore(&fnic_list_lock, flags);
> >
> > -   fc_remove_host(fnic->lport->host);
> > -   scsi_remove_host(fnic->lport->host);
> > -   for (hwq =3D 0; hwq < fnic->wq_copy_count; hwq++)
> > -           kfree(fnic->sw_copy_wq[hwq].io_req_table);
> > -   fc_exch_mgr_free(fnic->lport);
> > +   fnic_free_txq(&fnic->frame_queue);
> > +   fnic_free_txq(&fnic->tx_queue);
> > +
> >     vnic_dev_notify_unset(fnic->vdev);
> >     fnic_free_intr(fnic);
> >     fnic_free_vnic_resources(fnic);
> > @@ -1083,8 +1128,13 @@ static void fnic_remove(struct pci_dev *pdev)
> >     fnic_iounmap(fnic);
> >     pci_release_regions(pdev);
> >     pci_disable_device(pdev);
> > +   pci_set_drvdata(pdev, NULL);
> >     ida_free(&fnic_ida, fnic->fnic_num);
> > -   scsi_host_put(lp->host);
> > +   if (IS_FNIC_FCP_INITIATOR(fnic)) {
> > +           fnic_scsi_unload_cleanup(fnic);
> > +           scsi_host_put(fnic->lport->host);
> > +   }
> > +   kfree(fnic);
> >  }
> >
> >  static struct pci_driver fnic_driver =3D {
> > @@ -1236,8 +1286,10 @@ static void __exit fnic_cleanup_module(void)
> >  {
> >     pci_unregister_driver(&fnic_driver);
> >     destroy_workqueue(fnic_event_queue);
> > -   if (fnic_fip_queue)
> > +   if (fnic_fip_queue) {
> > +           flush_workqueue(fnic_fip_queue);
> >             destroy_workqueue(fnic_fip_queue);
>
> I don't think this change is necessary or related.  But if it is then it
> needs to be split into its own patch with a Fixes tag.

Thanks Dan.
We believe it is necessary to flush the frames in the fip queue before clea=
ning up.
We would like to keep this as it is.

> > +   }
> >     kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
> >     kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
> >     kmem_cache_destroy(fnic_io_req_cache);
> > diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.=
c
> > index dd24e25574db..763475587b7f 100644
> > --- a/drivers/scsi/fnic/fnic_res.c
> > +++ b/drivers/scsi/fnic/fnic_res.c
> > @@ -58,6 +58,11 @@ int fnic_get_vnic_config(struct fnic *fnic)
> >     GET_CONFIG(intr_mode);
> >     GET_CONFIG(wq_copy_count);
> >
> > +   if ((c->flags & (VFCF_FC_INITIATOR)) =3D=3D 0) {
> > +           dev_info(&fnic->pdev->dev, "vNIC role not defined (def role=
: FC Init)\n");
>
> dev_dbg() perhaps?  I'm not sure on this one.

Thanks Dan. This helps us catch issues exposed potentially from UCSM GUI,
that we would normally not see. We would like to keep this as is.

> > +           c->flags |=3D VFCF_FC_INITIATOR;
> > +   }
> > +
> >     c->wq_enet_desc_count =3D
> >             min_t(u32, VNIC_FNIC_WQ_DESCS_MAX,
> >                   max_t(u32, VNIC_FNIC_WQ_DESCS_MIN,
> > @@ -137,29 +142,28 @@ int fnic_get_vnic_config(struct fnic *fnic)
> >
> >     c->wq_copy_count =3D min_t(u16, FNIC_WQ_COPY_MAX, c->wq_copy_count)=
;
> >
> > -   dev_info(&fnic->pdev->dev, "vNIC MAC addr %pM "
> > -                "wq/wq_copy/rq %d/%d/%d\n",
> > -                fnic->ctlr.ctl_src_addr,
> > +   dev_info(&fnic->pdev->dev, "fNIC MAC addr %p wq/wq_copy/rq %d/%d/%d=
\n",
> > +                   fnic->data_src_addr,
> >                  c->wq_enet_desc_count, c->wq_copy_desc_count,
> >                  c->rq_desc_count);
> > -   dev_info(&fnic->pdev->dev, "vNIC node wwn %llx port wwn %llx\n",
> > +   dev_info(&fnic->pdev->dev, "fNIC node wwn 0x%llx port wwn 0x%llx\n"=
,
> >                  c->node_wwn, c->port_wwn);
> > -   dev_info(&fnic->pdev->dev, "vNIC ed_tov %d ra_tov %d\n",
> > +   dev_info(&fnic->pdev->dev, "fNIC ed_tov %d ra_tov %d\n",
> >                  c->ed_tov, c->ra_tov);
> > -   dev_info(&fnic->pdev->dev, "vNIC mtu %d intr timer %d\n",
> > +   dev_info(&fnic->pdev->dev, "fNIC mtu %d intr timer %d\n",
> >                  c->maxdatafieldsize, c->intr_timer);
> > -   dev_info(&fnic->pdev->dev, "vNIC flags 0x%x luns per tgt %d\n",
> > +   dev_info(&fnic->pdev->dev, "fNIC flags 0x%x luns per tgt %d\n",
> >                  c->flags, c->luns_per_tgt);
> > -   dev_info(&fnic->pdev->dev, "vNIC flogi_retries %d flogi timeout %d\=
n",
> > +   dev_info(&fnic->pdev->dev, "fNIC flogi_retries %d flogi timeout %d\=
n",
> >                  c->flogi_retries, c->flogi_timeout);
> > -   dev_info(&fnic->pdev->dev, "vNIC plogi retries %d plogi timeout %d\=
n",
> > +   dev_info(&fnic->pdev->dev, "fNIC plogi retries %d plogi timeout %d\=
n",
> >                  c->plogi_retries, c->plogi_timeout);
> > -   dev_info(&fnic->pdev->dev, "vNIC io throttle count %d link dn timeo=
ut %d\n",
> > +   dev_info(&fnic->pdev->dev, "fNIC io throttle count %d link dn timeo=
ut %d\n",
> >                  c->io_throttle_count, c->link_down_timeout);
> > -   dev_info(&fnic->pdev->dev, "vNIC port dn io retries %d port dn time=
out %d\n",
> > +   dev_info(&fnic->pdev->dev, "fNIC port dn io retries %d port dn time=
out %d\n",
> >                  c->port_down_io_retries, c->port_down_timeout);
> > -   dev_info(&fnic->pdev->dev, "vNIC wq_copy_count: %d\n", c->wq_copy_c=
ount);
> > -   dev_info(&fnic->pdev->dev, "vNIC intr mode: %d\n", c->intr_mode);
> > +   dev_info(&fnic->pdev->dev, "fNIC wq_copy_count: %d\n", c->wq_copy_c=
ount);
> > +   dev_info(&fnic->pdev->dev, "fNIC intr mode: %d\n", c->intr_mode);
> >
> >     return 0;
> >  }
> > diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scs=
i.c
> > index a38672ac224e..09d0ad597b3a 100644
> > --- a/drivers/scsi/fnic/fnic_scsi.c
> > +++ b/drivers/scsi/fnic/fnic_scsi.c
> > @@ -1944,6 +1944,45 @@ void fnic_terminate_rport_io(struct fc_rport *rp=
ort)
> >     }
> >  }
> >
> > +/*
> > + * FCP-SCSI specific handling for module unload
> > + *
> > + */
> > +void fnic_scsi_unload(struct fnic *fnic)
> > +{
> > +   unsigned long flags;
> > +
> > +   /*
> > +    * Mark state so that the workqueue thread stops forwarding
> > +    * received frames and link events to the local port. ISR and
> > +    * other threads that can queue work items will also stop
> > +    * creating work items on the fnic workqueue
> > +    */
> > +   spin_lock_irqsave(&fnic->fnic_lock, flags);
> > +   fnic->iport.state =3D FNIC_IPORT_STATE_LINK_WAIT;
> > +   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> > +
> > +   if (fdls_get_state(&fnic->iport.fabric) !=3D FDLS_STATE_INIT)
> > +           fnic_scsi_fcpio_reset(fnic);
> > +
> > +   spin_lock_irqsave(&fnic->fnic_lock, flags);
> > +   fnic->in_remove =3D 1;
> > +   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> > +
> > +   fnic_flush_tport_event_list(fnic);
> > +   fnic_delete_fcp_tports(fnic);
> > +}
> > +
> > +void fnic_scsi_unload_cleanup(struct fnic *fnic)
> > +{
> > +   int hwq =3D 0;
>
> This initialization is not required.

Thanks Dan. We will address this in a future patch.

> > +
> > +   fc_remove_host(fnic->host);
> > +   scsi_remove_host(fnic->host);
> > +   for (hwq =3D 0; hwq < fnic->wq_copy_count; hwq++)
> > +           kfree(fnic->sw_copy_wq[hwq].io_req_table);
> > +}
> > +
> >  /*
> >   * This function is exported to SCSI for sending abort cmnds.
> >   * A SCSI IO is represented by a io_req in the driver.
> > diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_st=
ats.h
> > index 1f1a1ec90a23..817b27c7d023 100644
> > --- a/drivers/scsi/fnic/fnic_stats.h
> > +++ b/drivers/scsi/fnic/fnic_stats.h
> > @@ -3,6 +3,7 @@
> >  #ifndef _FNIC_STATS_H_
> >  #define _FNIC_STATS_H_
> >  #define FNIC_MQ_MAX_QUEUES 64
> > +#include <scsi/scsi_transport_fc.h>
> >
> >  struct stats_timestamps {
> >     struct timespec64 last_reset_time;
> > @@ -116,6 +117,7 @@ struct fnic_stats {
> >     struct reset_stats reset_stats;
> >     struct fw_stats fw_stats;
> >     struct vlan_stats vlan_stats;
> > +   struct fc_host_statistics host_stats;
> >     struct misc_stats misc_stats;
> >  };
> >
> > diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_tr=
ace.c
> > index aaa4ea02fb7c..d717886808df 100644
> > --- a/drivers/scsi/fnic/fnic_trace.c
> > +++ b/drivers/scsi/fnic/fnic_trace.c
> > @@ -458,6 +458,12 @@ int fnic_get_stats_data(struct stats_debug_info *d=
ebug,
> >
> >  }
> >
> > +int fnic_get_debug_info(struct stats_debug_info *info, struct fnic *fn=
ic)
> > +{
> > +   /* Placeholder function */
> > +   return 0;
> > +}
>
> We don't add placeholder functions.  There was a better way to break
> this up and someone should have helped you with this.

Thanks Dan.
As mentioned above, and in our cover letter, this patch is a part of a seri=
es.
Emphasis was placed on preventing compilation errors and warnings for=20
each patch in the series, and these placeholders were added for that sake.
Warnings were mentioned above.

> regards,
> dan carpenter
>
> > +
> >  /*
> >   * fnic_trace_buf_init - Initialize fnic trace buffer logging facility
> >   *
> > --
> > 2.47.0
> >
>

Thanks for taking the time in reviewing this code Dan.
Appreciate your help.

Regards,
Karan
