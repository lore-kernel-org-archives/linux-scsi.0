Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D773217FE;
	Fri, 24 Jan 2025 05:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737696989; cv=fail; b=uyp1WDWkEU/KAWs9xSxsH7XBdlsMFnPvC+uy0vYCGTPCPQ9If78Lixpo9bgfLbhnX1Mnnf1k/YR15AvS81c+rmJQ1j64ju253uRXgVlp9nmQam4qhRJd2O8xH6E3vvMH7NMCiLUKGThPodKhJKS8nStflW67xgXR6ZJvj1h1NK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737696989; c=relaxed/simple;
	bh=SEXO5nSG9n98tVcSuInGE9uCx9fmq3OZeTyo9qKnF90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oOy1+ee560SokoTKIEL8qfiqxx6LrAOZ+kqlWeqejs/Wq8nDW/Q2ddC8ztPflK8pa0OsP/h4Y2WwBc3ZKwWZAqCC+ebM5+Es4n4jPuNxSF+5CNgZr37nNPXxcUIa3f1mbFq+N79m8O8DrQkOPjDffABWZ42WN2HRnjhsyIZ8Lkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=grcOSRf+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pwqHa3Hr; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="grcOSRf+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pwqHa3Hr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737696986; x=1769232986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SEXO5nSG9n98tVcSuInGE9uCx9fmq3OZeTyo9qKnF90=;
  b=grcOSRf+i/Bhxvxy5jQ5w/WOBLPU8ru7CIFs+E0ltBz1SOoKOSPbEoCM
   //geOHAk0AZV9QfynrP9EEXn1JLHNh6O/OvU2sKBADrBGUgMvIt9/SDHw
   KfPxlYG47OmEKltmSs902+aRsqLEOBHQq/5fA7wgWOHSTGJqZVn25VBXC
   IQfjmdby9vKc1oaG3Bl2Cg7GsLqJU1EidDvZMymVwZO1G8+jshXHKmq06
   lPxMyQD/j6WEtE/V032oA3eRdi0KSPp3Q3ts8KItW3MkUJ1oDGlCw3u/3
   mqJjF61KR8FrtMFImai/ZmVdAvKqK+x+qRIfIk0+g2hlPcuNFUwG22HCR
   w==;
X-CSE-ConnectionGUID: p7jx8WFSRi2DTOF5NAm2KQ==
X-CSE-MsgGUID: VAA0x9atQMGSVty+QJJ9TA==
X-IronPort-AV: E=Sophos;i="6.13,230,1732550400"; 
   d="scan'208";a="37218029"
Received: from mail-westcentralusazlp17011026.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.26])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jan 2025 13:36:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CeKZPnLPJo4dsMYOGALJf9fKytiU8mbt0Xb6x4Z2Lp6BqKi1MvBM2GLPnNsOH9u10E3awbOCbn+Rr0i7eHNy7jy2Fc5gZ1fdRprtCcAuiH7v7irDcTNFbHXxXRVPJkk/yy/9+Q9Ky1ADqYJQ5gop1Bk+aNClivwl9S79OFrwWx1BGgOOeN2TjjP4wgq6qy+V2kyZ7mPFUjB5c68MGqunnbQW9o1JvJi3hK92yHSKmojIZuGwFMkf2oTUNpeQLYJFdoOpQN198WlCmVb68ZnPe2xcX0oFPrMfawsnWE29xKuZ2LruzXoZpB1mEzNOfPPwmkY3TKDQB9vy0/LyHKdTPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppkStwoN32/awE5MecCD0pPBHiJ8n7Lfl9VKf+ojwWU=;
 b=uMrrJvsOECPqCs6LnVje2J/gh1sP7CS1Zb+yTZaXBG1/cuiOsJr9ktOfXD52mXkyWeqyPigsn9Rg8v6U5oPphs6NPNuzjd3omvo5DaD9/93jx7tiOyRtKg15eozfzejwsF95G+YCPXbGwrEzOvVXv2XDf+97iHi0+B5BNht7rqh0CghliAT5nRSYIESH8S4Ku3HJwkEKAErTpJBdlg18GP02CrnaMESfWV/P5lx3N9DiCiRm/L9THAJpF7fH5pBYQf2Kt9ObiwFL3IPsUEcCqKfrdD3G/Bl6VJEyFEhl/glooQJDLZFxwO9seO4sfWTiO3V09k4WZkzNAEyycOZSZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppkStwoN32/awE5MecCD0pPBHiJ8n7Lfl9VKf+ojwWU=;
 b=pwqHa3HrmasufHO4jBwoE8Ge7dJcon3hOJq7zDHKLPMYHe1wua69Tz8Tq6l6irDaf2zm4FgA7w7DvdO7bk5TH6KrFZlHSOk+BvoB0kjoT2UReKfRM7ZxoFEpBESGOhOEgPt+w6qWXQwLpQoSjuyAN2Ac7Gl2tiPEgGyzXIXSUjk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH0PR04MB7704.namprd04.prod.outlook.com (2603:10b6:510:4c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.16; Fri, 24 Jan 2025 05:36:18 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%6]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 05:36:18 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC: Alan Adamson <alan.adamson@oracle.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Subject: Re: [PATCH blktests 1/2] scsi/009: add atomic write tests
Thread-Topic: [PATCH blktests 1/2] scsi/009: add atomic write tests
Thread-Index: AQHbbFI6cGOdyGm4iUyywl/pJR3X07Mh9uAAgAN0QoA=
Date: Fri, 24 Jan 2025 05:36:17 +0000
Message-ID: <zwtv2kp2e422c7ryc5gucf5qfbdf2iqg7vcvm5haldykbjo26c@wnqhfm2uksts>
References: <20250121222530.2824516-1-alan.adamson@oracle.com>
 <20250121222530.2824516-2-alan.adamson@oracle.com>
 <4b78a64d-bdb8-411b-ac5d-13f1df3f8f11@nvidia.com>
In-Reply-To: <4b78a64d-bdb8-411b-ac5d-13f1df3f8f11@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH0PR04MB7704:EE_
x-ms-office365-filtering-correlation-id: cd2b677d-3c61-47d1-caa2-08dd3c3906bd
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?EgkB2Pyo6C0zQ//rNkaesgDs33v4S4ToLTi8JDvIjkcdbK9aEClwmXp6gJ/1?=
 =?us-ascii?Q?wL6x59CiUlciQ8la8jFc9j2Ov6+UZsYt47g/xxCkhRX4mpZp1TwVF8YxWXFF?=
 =?us-ascii?Q?fHpmt+JTgzFD3b2GGCSFuAXGnFfGBJW/42cGR8/MZB1FPGxe35RLDR2tJb7x?=
 =?us-ascii?Q?NY9kXSNmnnU1FM6ktdOmUdeHirC5LsNEpDpeJs5A24moc/qM/WaZt9Khp4F1?=
 =?us-ascii?Q?lI8NxWyLR1a4N41y70xxKmJYaVmCbha1b+ugSZEbq0IRkub7ZUW36ptCoUNS?=
 =?us-ascii?Q?qhqbSxtSQ/053oezdHxGVFsfo1sjbyV1+nNoGjBNf9sSkCVKT8roOsSIsXRK?=
 =?us-ascii?Q?gLphcXXKJwkosR8DuQ7f2c/yJC0mW0vbDWqZG3rCzTGkFFF0ID85vrexwtLd?=
 =?us-ascii?Q?m6L4Hbvx1BBAt/28kNDld/2fgGwpriSGEhac8ky0jHWpF43eygywPz6UlzdA?=
 =?us-ascii?Q?FWmwRo9F5kq74bv630fSzve9oThoinT+a3SdK2ZmQQbC+tsAYPmebxiArG6j?=
 =?us-ascii?Q?ieOoa1ZiwXAWQPFii2OV98mxa03PBz99yErBt0UowfB9mk3RrNmmLoPmuYjr?=
 =?us-ascii?Q?clI3tESzYkugjDFWrtTvFQRU74qmg0e+DV9n9p91Fi0YNbOBhqO75rmcXU9B?=
 =?us-ascii?Q?hQsr+7eeUZTxUZmdswmM66+6wvDLlnNxRBVF0FdRV8IztZz1hzAmLSkxNqEj?=
 =?us-ascii?Q?vy7owFPCkCqhGk2XPxVliR8TRfFoNoRWwHS2Ejlny7txB2UZ59RegTe+3ssu?=
 =?us-ascii?Q?9kJLMvH6BLZT8Ui4XO4pDxpqetdQxtVYXtX6wRroYuEk+MfBGyphwmz53d6b?=
 =?us-ascii?Q?WmM2zCJi965EbRf8xBr7lHXCB1YX0NMidO9JT/Voy1HRoDDqiP8augfVa+I6?=
 =?us-ascii?Q?aXlxc7lckkkqtjpH9TSDT67M685BwzXPFWH4mirgCj/Nn+zlVGV6u0vS8fDn?=
 =?us-ascii?Q?BYVsKnTFmrevkPTClCq0ZIcCWogzq4Lmv35QeZYCgpM3yx8BFWYU1F3xlGUI?=
 =?us-ascii?Q?YsV18ULUnDxLqizs01g1WqVoKVKHD5R73mavyq3fkQJ/9RDFEJ7GRvl974mL?=
 =?us-ascii?Q?3GGnNcOpxyrjNUUPrcMQZSGM5rHF6rHHRgL7tr1qV27eMf/RnziPViaSdUOd?=
 =?us-ascii?Q?MbrGhY+KHYL2mYB88dgrB8u6eFuT1UmqsayaqbAunFNsVXOEETopCHsB/Hml?=
 =?us-ascii?Q?BUB8tSYH7j1vUJodlwiXRVcJo/pmR6Y+WD6Xn9A/l4inLbHFRo4x6FRC9ilY?=
 =?us-ascii?Q?zGI13z7Snw2+iv4ZAXQrOIAqVvy1rlWIdHwW5YsMIQDRzZIFsSoDP0qQQ/LX?=
 =?us-ascii?Q?VWHTqkbuY0dgxzq+ZWVITq2Byn6jkhPPQXVZ0OM6kETligOAmA+VDW33DBht?=
 =?us-ascii?Q?JP9AlvLDsw5GTFS/MKWBhTt5RcppvNGwfzJuOxX5/Ng0VZmqYrIDBdI1leFE?=
 =?us-ascii?Q?7V6kBxNpLqxJNUlw0B4Pfu/XuXw/kNFs?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qusyoNnDIBqBP7TGgcQJrGEI8x5X10MmR5IkOfu+DZP8eASDqhW8/2VXaSWz?=
 =?us-ascii?Q?SkRvMV0sU1ARc4gZIILVwM8bSTZA2qaomSQCXVsrQGLTg+nMBvv7QgdEOh5X?=
 =?us-ascii?Q?acHjZPDHz4a+LBshKMZS3C/r9gqBRlOafLgpN+IPLhf9+zwEiXqF9yet8G8X?=
 =?us-ascii?Q?i/qCPuxeGR5S/JZX1FfjzeNsUEuugHe7TjCGuJO+01UkmvfNppPuBsEKjujV?=
 =?us-ascii?Q?3cxF3XhybUOZChkBxc4sTRXqh6zU8AeoccbJ1Osw5jtJIP9RuTJBUZzsQBQC?=
 =?us-ascii?Q?O6YxU79WMGQ4c4iYqDXu0a0xuY15djfxqGPPSuTZFRHC7dRk7EApleBNICAz?=
 =?us-ascii?Q?nCmZ0yDWzqd9S34fbHLWeXLByTkbEfghu7A7nEnaLgjUM8nZdwz4laksGlqq?=
 =?us-ascii?Q?tr2gTifkpDClD5ufDuQtvP857XAmnb01+uNDYzL6dI3aqpp7Vlec0G6AIzey?=
 =?us-ascii?Q?YL1aXpWvsnzturuRCJYdBVJU6u47SBPwBY3CYpAlpYXa8q9h0cwk6CiprZOo?=
 =?us-ascii?Q?gojfjU8hbEVlu0uoXLk5caGXXuCFBfXsd41bLuyRxqx0AVoQL6+5VCHw6Fi8?=
 =?us-ascii?Q?6hl1MbV0AYpfLckY89715sL7MX9s781jdNmkPtFY9yGJquu1ZWIy0K+fnKlW?=
 =?us-ascii?Q?I6ML1+dUuBKB7Xp3+oLVDufn6HP6TQNJ3HK3HIOtwjWOCT2xJE1cCugL6WA7?=
 =?us-ascii?Q?whyH0o+2vnGIoNYSk0YUVd3ISWS4jkzPoKA66qfN64JiGgycU4GpEjipA7JS?=
 =?us-ascii?Q?dXeztjScq3wL8q4IaSnSvEU/jMwYI7kHX+rtrkDcavsq/QyY3qFFBBzmLHi9?=
 =?us-ascii?Q?nwAPMplKawN/HSVcmo5VTbKO/7yy57U+ndIOl/zWCwjvYAQwLY4zWqUM4ZSm?=
 =?us-ascii?Q?ooIYB5MX9mcMa3pvN/PJzjV4J5Ac+RucimCFwJdHpAmNXhb0RZGnBq8sxLhu?=
 =?us-ascii?Q?RHw30tioDUZ5cJvtCd+cqyvNXoJQFuWyTS8kcs15byq89yGtjRbGK0IhC3yl?=
 =?us-ascii?Q?e5omUxnsSTtT+h56+b1zInKxk/TwiWtiDuCOqK7t3qGCU/lJ+ZLMB89Dm8Oi?=
 =?us-ascii?Q?oY922ZeliYr2NmKEZRxEtfgfNOf+q5J2di6YUtAYVDh8xZtSmMrQiTEY/5ho?=
 =?us-ascii?Q?QIXiQxcbH1MogJ0Reie6BWWT722LQpgzl/RqxPgXzfEFN54UJfz+DgdYUN4D?=
 =?us-ascii?Q?LrfcT+FOZC6Csb6hgO5KWDo6xplPf0/Qu4uRj4GEf/nWURxgNbn+v9dgKIi4?=
 =?us-ascii?Q?zFSqqXn11wzeypWc1IkpQVkXGtKub5WlAwaNY8lLvcFoQBb5hb8l643Ztl8J?=
 =?us-ascii?Q?UAYLUeAGpFg//CZlMdF0jIVKKjdwdQzO3kcuqy9ypQ7addDzMZrqW1kvUz+S?=
 =?us-ascii?Q?C1M1+98OA/FsUUCxbFTzhEIZQc/ooJvqKJQZkUjX68I1zsZe8BCx9zp8Zs+y?=
 =?us-ascii?Q?bjBY+I/HH6O8iXfq6E1A2H2FyHKRBhFuoWTNlYTXhwJJosbZOsWliD1JwMf6?=
 =?us-ascii?Q?pAwav32DjIRPccz9yPbmrDhIi9Fv8Vo9MGp5wKRCaa+8wXxiSw9Ygb/1XuKC?=
 =?us-ascii?Q?hmoxHQzW8mTNSmt/ERLVCrfLR4ZJXVw5wQAQLjY38vRYz3RFXc34EmX/AXi/?=
 =?us-ascii?Q?oTIsj762onYgJSEK4B8UQp4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <607E9A1BE020DB409A7F5A7864675292@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	md3GGvK2OuXfA6FeCG6Zub0YjiOk/8zCxA1wUmsIbhYDKq7SjplRvLu7ZV+w06WXI/EpuFUJunBo8zBBz1Jq9JIy/APQGxCz5ER0NBj91QAqpWHjgCVDUjlxPEvrvFR9xN3w4PI5IEDrthj/N4QJPDrQgkxJ7UHz+UYUUjptHsH15v07kYGH7qVhmglw1o8yJwLIAkdBtagcBxLjIMWNC4KTV79HUQ6dlKj5s+APvLigpuHekP9S6eeTa0xDO7gRE0drg5AJ3v9J/U4dub2Xv3L7m1CzrgTFBFOHeRfCyyBSxKxtdX1fnO+vPJv5vax//OOg9hhxPQ14OhDP2bRGBzyMS2hPKzN/B30I+3l7LYqz58UnJxBjLXudZCYfCJW/li1QZ0MeXLr+kdV7tptJ2sy4qTxPwo9FKZ+ylmSymF6OoLjX3YvMcJHh1rlc+PEB3PCJ9Vx6vAfpu29nY4tbOwq66OhIIea86rkc43EcKp8Ylr7LeOnWyAWcrP53c2Lan7+yuZHcYe2Ftv2RKt9sXNJiTI1L7VYmoPUWIWENs/JYuEI+zI0t6uLfHddWHX6XhbuWPcTmwFaog3WWiqxnc9GW6u4/OMXCHzlRnyQH8a16JDZq8DX9zmIRLl3lXdrl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2b677d-3c61-47d1-caa2-08dd3c3906bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2025 05:36:18.0150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: odJcGd5f8+BvY3n1BDuhn6WdjiRmsh/fIjIixzdqcMnP9AEPIEz42QGubOOPNHKCe2og2170Hh74ylXXs7Ygy3PS471C6wBIxPnXRQP/ErM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7704

On Jan 22, 2025 / 00:51, Chaitanya Kulkarni wrote:
> On 1/21/25 14:25, Alan Adamson wrote:
> > Uses scsi_debug to test basic atomic write functionality. Testing
> > areas include:
> >
> > - Verify sysfs atomic write attributes are consistent with
> >    atomic write attributes advertised by scsi_debug.
> > - Verify the atomic write paramters of statx are correct using
> >    xfs_io.
> > - Perform a pwritev2() (with and without RWF_ATOMIC flag) using
> >    xfs_io:
> >      - maximum byte size (atomic_write_unit_max_bytes)
> >      - minimum byte size (atomic_write_unit_min_bytes)
> >      - a write larger than atomic_write_unit_max_bytes
> >      - a write smaller than atomic_write_unit_min_bytes
> >
> > Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
>=20
> Thanks a lot for the testcase, this is really useful based on
> amount of work has been done on the kernel side.

Agreed, I also think these test cases are valuable :)

>=20
> > ---
> >   common/xfs         |  49 +++++++++++
> >   tests/scsi/009     | 213 ++++++++++++++++++++++++++++++++++++++++++++=
+
> >   tests/scsi/009.out |  18 ++++
> >   3 files changed, 280 insertions(+)
> >   create mode 100755 tests/scsi/009
> >   create mode 100644 tests/scsi/009.out
> >
> > diff --git a/common/xfs b/common/xfs
> > index 569770fecd53..284c6d7cdc40 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -6,6 +6,28 @@
> >  =20
> >   . common/shellcheck
> >  =20
> > +_have_xfs_io() {
> > +	if ! _have_program xfs_io; then
> > +		return 1
> > +	fi
> > +	return 0
> > +}
> > +
> > +# Check whether the version of xfs_io is greater than or equal to $1.$=
2.$3
> > +_have_xfs_io_ver() {
> > +	local d=3D$1 e=3D$2 f=3D$3
> > +
> > +	_have_xfs_io || return $?
> > +
> > +	IFS=3D'.' read -r a b c < <(xfs_io -V | sed 's/xfs_io version *//')
> > +	if [ $((a * 65536 + b * 256 + c)) -lt $((d * 65536 + e * 256 + f)) ];
>=20
> can we add some comments for above calculations ?

These are checking xfs_io command version, and I think the numbers and the =
logic
were copied form _have_kver().

Anyway, I wonder if we really need this helper function. In general, versio=
n
dependency is not the best approach and we should avoid them as much as we =
can.
Instead, I suggest to check output of "xfs_io -c help" command. The old ver=
sion,
the output is as follows and the -A option is not printed.

$ xfs_io -c help | grep pwrite
pwrite [-i infile [-qdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V=
 N] off len -- writes a number of bytes at a specified offset

With this approach, we can implement a helper function with name
_have_xfs_io_atomic_write() or something, and call it from requires() in
scsi/009 and nvme/059.

>=20
> > +	then
> > +		SKIP_REASONS+=3D("xfs_io version too old")
> > +		return 1
> > +	fi
> > +	return 0
> > +}
> > +
> >   _have_xfs() {
> >   	_have_fs xfs && _have_program mkfs.xfs
> >   }
> > @@ -52,3 +74,30 @@ _xfs_run_fio_verify_io() {
> >  =20
> >   	return "${rc}"
> >   }
> > +
> > +run_xfs_io_pwritev2() {
> > +	local dev=3D$1
> > +	local bytes_to_write=3D$2
> > +	local bytes_written
> > +
> > +	bytes_written=3D$(xfs_io -d -C "pwrite -b ${bytes_to_write} -V 1 -D 0=
 ${bytes_to_write}" "$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $=
2 }')
>=20
> same here little comment would be really useful
>=20
> > +	echo "$bytes_written"
> > +}
> > +
> > +run_xfs_io_pwritev2_atomic() {
> > +	local dev=3D$1
> > +	local bytes_to_write=3D$2
> > +	local bytes_written
> > +
> > +	bytes_written=3D$(xfs_io -d -C "pwrite -b ${bytes_to_write} -V 1 -A -=
D 0 ${bytes_to_write}" "$dev" | grep "wrote" | sed 's/\// /g' | awk '{ prin=
t $2 }')
>=20
> same here
>=20
> > +	echo "$bytes_written"
> > +}
> > +
> > +run_xfs_io_xstat() {
> > +	local dev=3D$1
> > +	local field=3D$2
> > +	local statx_output
> > +
> > +	statx_output=3D$(xfs_io -c "statx -r -m 0x00010000" "$dev" | grep "$f=
ield" | awk '{ print $3 }')
>=20
> same here
>=20
> > +	echo "$statx_output"
> > +}
> > diff --git a/tests/scsi/009 b/tests/scsi/009
> > new file mode 100755
> > index 000000000000..f3ab00f61369
> > --- /dev/null
> > +++ b/tests/scsi/009
> > @@ -0,0 +1,213 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-3.0+
> > +# Copyright (C) 2025 Oracle and/or its affiliates
> > +#
> > +# Test SCSI Atomic Writes with scsi_debug
> > +
> > +. tests/scsi/rc
> > +. common/scsi_debug
> > +. common/xfs
> > +
> > +DESCRIPTION=3D"test scsi atomic writes"
> > +QUICK=3D1
> > +
> > +requires() {
> > +	_have_driver scsi_debug
> > +	_have_kver 6 11

I suggest to remove this kernel version dependency also. Let me describe ho=
w to
do it below.

> > +	_have_xfs_io_ver 6 12 0
> > +}
> > +
> > +test() {
> > +	local dev
> > +	local scsi_debug_atomic_wr_max_length
> > +	local scsi_debug_atomic_wr_gran
> > +	local scsi_atomic_max_bytes
> > +	local scsi_atomic_min_bytes
> > +	local sysfs_max_hw_sectors_kb
> > +	local max_hw_bytes
> > +	local sysfs_logical_block_size
> > +	local sysfs_atomic_max_bytes
> > +	local sysfs_atomic_unit_max_bytes
> > +	local sysfs_atomic_unit_min_bytes
> > +	local statx_atomic_min
> > +	local statx_atomic_max
> > +	local bytes_to_write
> > +	local bytes_written
> > +
> > +	echo "Running ${TEST_NAME}"
> > +
> > +	local scsi_debug_params=3D(
> > +		delay=3D0
> > +		atomic_wr=3D1
> > +	)
> > +	_configure_scsi_debug "${scsi_debug_params[@]}"
> > +	dev=3D"/dev/${SCSI_DEBUG_DEVICES[0]}"
> > +	sysfs_logical_block_size=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}=
"/queue/logical_block_size)
>=20
> you can also use the local variable for following path to trim down the
> cat operations where :-
>=20
> /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/queue
>=20
> makes the code easy to read ...
>=20
> > +	sysfs_max_hw_sectors_kb=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"=
/queue/max_hw_sectors_kb)
> > +	max_hw_bytes=3D$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
> > +	sysfs_atomic_max_bytes=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/=
queue/atomic_write_max_bytes)
> > +	sysfs_atomic_unit_max_bytes=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[=
0]}"/queue/atomic_write_unit_max_bytes)
> > +	sysfs_atomic_unit_min_bytes=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[=
0]}"/queue/atomic_write_unit_min_bytes)

I agree that these lines are lengthy.

Taking this chance, let me suggest to use fallback_device() and
cleanup_fallback_device(). (They are not well documented, but are used in s=
ome
test cases like zbd/001 or block/007). When a test case with test_device()
implements these hooks, blktests runs the test case even when TEST_DEVS is
empty. It calls fallback_device() to set up the test target TEST_DEV then r=
un
test_device(). After the test completion, it calls cleanup_fallback_device(=
) to
clean up TEST_DEV. For this test case, fallback_device() can call
_configure_scsi_debug with atmoic_wr=3D1 option. With this approach, we can=
 refer
to TEST_DEV and TEST_DEV_SYSFS in test_device().

This approach has following benefits:

- Using TEST_DEV_SYSFS, the sysfs attribute reference codes will simpler an=
d
  similar as nvme/059 in the next patch.
- We can call "_require_test_dev_sysfs queue/atomic_write_max_bytes" in
  device_requires to check that the kernel supports amotic writes. This wil=
l
  avoid the kernel version dependency.
- If users have real scsi devices with atomic write support, the users can
  specify the devices in TEST_DEVS and run this test case with them.
  (We need to skip the test if the devices do not support atomic writes,
   by checking the queue/atomic_write_max_bytes value in device_requires())

For your reference, here I share the change needed for this approach. It is
untested. I hope it is enough to convey my idea.

diff --git a/tests/scsi/009 b/tests/scsi/009
index f3ab00f..686cc8a 100755
--- a/tests/scsi/009
+++ b/tests/scsi/009
@@ -13,12 +13,34 @@ QUICK=3D1
=20
 requires() {
 	_have_driver scsi_debug
-	_have_kver 6 11
-	_have_xfs_io_ver 6 12 0
 }
=20
-test() {
-	local dev
+device_requires() {
+	_require_test_dev_sysfs queue/atomic_write_max_bytes
+	if (( $(< ${TEST_DEV_SYSFS}/queue/atomic_write_max_bytes) =3D=3D 0 )); th=
en
+		SKIP_REASONS+=3D("${TEST_DEV} does not support atomic write")
+		return 1
+	fi
+}
+
+fallback_device() {
+	local scsi_debug_params=3D(
+		delay=3D0
+		atomic_wr=3D1
+	)
+	if ! _configure_scsi_debug "${scsi_debug_params[@]}"; then
+		return 1
+	fi
+	echo "/dev/${SCSI_DEBUG_DEVICES[0]}"
+}
+
+cleanup_fallback_device() {
+	_exit_scsi_debug
+
+}
+
+test_device() {
 	local scsi_debug_atomic_wr_max_length
 	local scsi_debug_atomic_wr_gran
 	local scsi_atomic_max_bytes
@@ -36,20 +58,14 @@ test() {
=20
 	echo "Running ${TEST_NAME}"
=20
-	local scsi_debug_params=3D(
-		delay=3D0
-		atomic_wr=3D1
-	)
-	_configure_scsi_debug "${scsi_debug_params[@]}"
-	dev=3D"/dev/${SCSI_DEBUG_DEVICES[0]}"
-	sysfs_logical_block_size=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/qu=
eue/logical_block_size)
-	sysfs_max_hw_sectors_kb=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/que=
ue/max_hw_sectors_kb)
+	sysfs_logical_block_size=3D$(< "${TEST_DEV_SYSFS}"/queue/logical_block_si=
ze)
+	sysfs_max_hw_sectors_kb=3D$(< "${TEST_DEV_SYSFS}"/queue/max_hw_sectors_kb=
)
 	max_hw_bytes=3D$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
-	sysfs_atomic_max_bytes=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/queu=
e/atomic_write_max_bytes)
-	sysfs_atomic_unit_max_bytes=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"=
/queue/atomic_write_unit_max_bytes)
-	sysfs_atomic_unit_min_bytes=3D$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"=
/queue/atomic_write_unit_min_bytes)
-	scsi_debug_atomic_wr_max_length=3D$(cat /sys/module/scsi_debug/parameters=
/atomic_wr_max_length)
-	scsi_debug_atomic_wr_gran=3D$(cat /sys/module/scsi_debug/parameters/atomi=
c_wr_gran)
+	sysfs_atomic_max_bytes=3D$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_max_b=
ytes)
+	sysfs_atomic_unit_max_bytes=3D$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_=
unit_max_bytes)
+	sysfs_atomic_unit_min_bytes=3D$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_=
unit_min_bytes)
+	scsi_debug_atomic_wr_max_length=3D$(< /sys/module/scsi_debug/parameters/a=
tomic_wr_max_length)
+	scsi_debug_atomic_wr_gran=3D$(< /sys/module/scsi_debug/parameters/atomic_=
wr_gran)
 	scsi_atomic_max_bytes=3D$(( "$scsi_debug_atomic_wr_max_length" * "$sysfs_=
logical_block_size" ))
 	scsi_atomic_min_bytes=3D$(( "$scsi_debug_atomic_wr_gran" * "$sysfs_logica=
l_block_size" ))
=20
@@ -102,7 +118,7 @@ test() {
 	fi
=20
 	# TEST 5 - check statx stx_atomic_write_unit_min
-	statx_atomic_min=3D$(run_xfs_io_xstat "$dev" "stat.atomic_write_unit_min"=
)
+	statx_atomic_min=3D$(run_xfs_io_xstat "$TEST_DEV" "stat.atomic_write_unit=
_min")
 	if [ "$statx_atomic_min" =3D "$scsi_atomic_min_bytes" ]
 	then
 		echo "TEST 5 - pass"
@@ -111,7 +127,7 @@ test() {
 	fi
=20
 	# TEST  6 - check statx stx_atomic_write_unit_max
-	statx_atomic_max=3D$(run_xfs_io_xstat "$dev" "stat.atomic_write_unit_max"=
)
+	statx_atomic_max=3D$(run_xfs_io_xstat "$TEST_DEV" "stat.atomic_write_unit=
_max")
 	if [ "$statx_atomic_max" =3D "$sysfs_atomic_unit_max_bytes" ]
 	then
 		echo "TEST 6 - pass"
@@ -121,7 +137,7 @@ test() {
=20
 	# TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes wi=
th no RWF_ATOMIC flag - pwritev2 should
 	# be succesful.
-	bytes_written=3D$(run_xfs_io_pwritev2 "$dev" "$sysfs_atomic_unit_max_byte=
s")
+	bytes_written=3D$(run_xfs_io_pwritev2 "$TEST_DEV" "$sysfs_atomic_unit_max=
_bytes")
 	if [ "$bytes_written" =3D "$sysfs_atomic_unit_max_bytes" ]
 	then
 		echo "TEST 7 - pass"
@@ -131,7 +147,7 @@ test() {
=20
 	# TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes wi=
th RWF_ATOMIC flag - pwritev2 should
 	# be succesful.
-	bytes_written=3D$(run_xfs_io_pwritev2_atomic "$dev" "$sysfs_atomic_unit_m=
ax_bytes")
+	bytes_written=3D$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_u=
nit_max_bytes")
 	if [ "$bytes_written" =3D "$sysfs_atomic_unit_max_bytes" ]
 	then
 		echo "TEST 8 - pass"
@@ -142,7 +158,7 @@ test() {
 	# TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + =
512 bytes with no RWF_ATOMIC flag - pwritev2
 	# should be succesful.
 	bytes_to_write=3D$(( "${sysfs_atomic_unit_max_bytes}" + "$sysfs_logical_b=
lock_size" ))
-	bytes_written=3D$(run_xfs_io_pwritev2 "$dev" "$bytes_to_write")
+	bytes_written=3D$(run_xfs_io_pwritev2 "$TEST_DEV" "$bytes_to_write")
 	if [ "$bytes_written" =3D "$bytes_to_write" ]
 	then
 		echo "TEST 9 - pass"
@@ -152,7 +168,7 @@ test() {
=20
 	# TEST 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes +=
 512 bytes with RWF_ATOMIC flag - pwritev2
 	# should not be succesful.
-	bytes_written=3D$(run_xfs_io_pwritev2_atomic "$dev" "$bytes_to_write")
+	bytes_written=3D$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$bytes_to_write=
")
 	if [ "$bytes_written" =3D "" ]
 	then
 		echo "TEST 10 - pass"
@@ -162,7 +178,7 @@ test() {
=20
 	# TEST 11 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes w=
ith no RWF_ATOMIC flag - pwritev2 should
 	# be succesful.
-	bytes_written=3D$(run_xfs_io_pwritev2 "$dev" "$sysfs_atomic_unit_min_byte=
s")
+	bytes_written=3D$(run_xfs_io_pwritev2 "$TEST_DEV" "$sysfs_atomic_unit_min=
_bytes")
 	if [ "$bytes_written" =3D "$sysfs_atomic_unit_min_bytes" ]
 	then
 		echo "TEST 11 - pass"
@@ -172,7 +188,7 @@ test() {
=20
 	# TEST 12 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes w=
ith RWF_ATOMIC flag - pwritev2 should
 	# be succesful.
-	bytes_written=3D$(run_xfs_io_pwritev2_atomic "$dev" "$sysfs_atomic_unit_m=
in_bytes")
+	bytes_written=3D$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_u=
nit_min_bytes")
 	if [ "$bytes_written" =3D "$sysfs_atomic_unit_min_bytes" ]
 	then
 		echo "TEST 12 - pass"
@@ -191,14 +207,14 @@ test() {
 		echo "TEST 13 - pass"
 		echo "TEST 14 - pass"
 	else
-		bytes_written=3D$(run_xfs_io_pwritev2 "$dev" "$bytes_to_write")
+		bytes_written=3D$(run_xfs_io_pwritev2 "$TEST_DEV" "$bytes_to_write")
 		if [ "$bytes_written" =3D "$bytes_to_write" ]
 		then
 			echo "TEST 13 - pass"
 		else
 			echo "TEST 13 - fail $bytes_written - $bytes_to_write"
 		fi
-		bytes_written=3D$(run_xfs_io_pwritev2_atomic "$dev" "$bytes_to_write")
+		bytes_written=3D$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$bytes_to_writ=
e")
 		if [ "$bytes_written" =3D "" ]
 		then
 			echo "TEST 14 - pass"
@@ -207,7 +223,5 @@ test() {
 		fi
 	fi
=20
-	_exit_scsi_debug
-
 	echo "Test complete"
 }=
