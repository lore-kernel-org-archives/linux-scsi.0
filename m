Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DED013DB9F;
	Wed, 28 Aug 2024 06:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724824966; cv=fail; b=MQnZdlyBznPK4f0tc0XBBAvdqktj3NKME+Ur9Bn+gIbwfRaOHDUKsD8Dh0QgncfKPwkYbfJ+7Lm7yxI39z3URfT9lyvdGstZ7LeWcVdN0XHKeKgFLon6SKlZe4azFUFd2UwPgIOIayLMR/31Vba/B8teKpYa5QZIZB7bf3m4LN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724824966; c=relaxed/simple;
	bh=3BelCtSIHqSiXKuKF6doWaxTdu9QXvmsYFD7shlBmR4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ro0rcWoLXwApi1CSMItilHggFzW7A/xW6tSlGKVRXO3p4GruxAy/6+MM4uXsy3atKWpILakBGLgCAiUTfD7RabiVdXQ47N++Ec3JcsJyxC4XHkf63XWcI4znDC5SpEAQiZyS+uJg8/pKGbbjALlOltP2M06tnrucSEG8fFWq354=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mzge7vzf; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Zo5ShCsY; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mzge7vzf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Zo5ShCsY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724824964; x=1756360964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3BelCtSIHqSiXKuKF6doWaxTdu9QXvmsYFD7shlBmR4=;
  b=mzge7vzfv3BFwVBPns9VPhIGOWOaA0yrBd8uspdu5YAVNonZ0X7ggdBg
   +SfQmI4CEgdHPAnwtSsYe2t1iDIQ2KlfvUSA5uTHNT0elEqEAcR2L2eNq
   OQSir8C/ccrxKya56cOGZrnFgfPvBMg8bj7oZL/eDZ+/ThuPAN3AUMKj4
   2UtRoyS8mDupnY4D3rpzoYCtw6x5EA560qTYq9LSadwwOZccP9LNdTAjJ
   zm4B/52A1qDw54F368EECGyNLbNocPtXR1yvlpkje+TqFXuxhhSUiy+nK
   YlAQG9kxHXfwLW0wnbQiMRWDOK2be8n07m8PCCcymtBxgWm6OKF5Uo8YU
   A==;
X-CSE-ConnectionGUID: 0lbKuGFSQt+rv9pf5bvDwg==
X-CSE-MsgGUID: p9IuYl7UTcm4yIsN2wo9FQ==
X-IronPort-AV: E=Sophos;i="6.10,181,1719849600"; 
   d="scan'208";a="25690863"
Received: from mail-westusazlp17010007.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([40.93.1.7])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2024 14:02:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BTy3d8EhEpNiq1KnTea6rRm4FG53BWY4dZbZVOLZzbVN6r5Pp8W7u5PUBLQxTFggs4fx5tlQ0Kt9s8mXFVUxnw+T9ShQIaww5dDXM8AWuQqg1ep2urYsI3/OI1+skuaOxRRd4dHyu8IWFcUPQHiY+FkIEgK5IWtEfxSG84mdUDpSAjZypOtSrqcVdcQYGvQHE/U9RQrkacFaITQxaKfueKUflHtLgIUXF8JUjUf9DCA3VGs1FclDAx+Gwr29DGCinasY826Eyvbdg5Jner68C43fI1gKVNmYCVJiTNDd5lAHuOKlOAdyZKSRSg2ILp3OiKhcBjZEJxTiDBGqDqJztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3BelCtSIHqSiXKuKF6doWaxTdu9QXvmsYFD7shlBmR4=;
 b=qxmQ93/N7AmFq+ee8Z7icvJiWI+Q7DI60nTNb8nJMzsCGeggpixhF+1U0m61ziMCVJ44reIcYoP2Ht5CQr4HW1yNzBlmLeIEhTT0CkQKG3l8uN3CTX/eKCstoDakMIXH1IVGwExKenIhbzZrzkqeDFuI12BWFOg1dE9M4611UTGyC3e+lSCxiCCUEoViwBZSZRPuDKUfdpeukVGeAGFMlUJtIu5i7GVCLRsecHcA1Z8ynICRN25rgm7HcYE8b3T0IVaG4m6Inw4a+i/nwcfX6cY4cH36pwFneudK3INf8+rQT1RcUQQObXS6DqJbdfhMV4KAn7kOHWBeR2UnoP6RDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BelCtSIHqSiXKuKF6doWaxTdu9QXvmsYFD7shlBmR4=;
 b=Zo5ShCsYCOpvY5KwWc0hjBNACa8OEdcOYJNRsa3onslIlgiKYv8lwdznTl82yIw7A5AJqKpq0sAAY64RrMASL5CAbA+8jgXPVgRUlSrjB7OYUXJC50brNEcd+theQtNRXPcQAuo0aby8RwS/gMwWSFxiEnFv83LwJOeYTyFzg/I=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB6835.namprd04.prod.outlook.com (2603:10b6:a03:22e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 06:02:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7897.021; Wed, 28 Aug 2024
 06:02:41 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Bean
 Huo <beanhuo@micron.com>, ChanWoo Lee <cw9316.lee@samsung.com>, Maramaina
 Naresh <quic_mnaresh@quicinc.com>, open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: core: Remove ufshcd_urgent_bkops()
Thread-Topic: [PATCH v1 1/1] scsi: ufs: core: Remove ufshcd_urgent_bkops()
Thread-Index: AQHa+NbuggsabfppFkCp7WdE0/XIr7I8Ldfw
Date: Wed, 28 Aug 2024 06:02:41 +0000
Message-ID:
 <DM6PR04MB65751E59D4DBB590008D2055FC952@DM6PR04MB6575.namprd04.prod.outlook.com>
References:
 <0c7f2c8d68408e39c28e3e81addce09cc0ee3969.1724800328.git.quic_nguyenb@quicinc.com>
In-Reply-To:
 <0c7f2c8d68408e39c28e3e81addce09cc0ee3969.1724800328.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY5PR04MB6835:EE_
x-ms-office365-filtering-correlation-id: a79e1e44-9408-487e-36bf-08dcc72706d8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?yI6Q4sNK/CH52pYo8yRleV0kI8NUAcijwNCJr5TP6CBaAfrT6lq90/gclj/3?=
 =?us-ascii?Q?H38xTEKQd5m5/avelzI5urYjkd3G5R9snmyryzriblO79N0J85zJv6HNRwiy?=
 =?us-ascii?Q?9C9x+iOmcYld5/PNg2+E3a2tJAbqhMfd/OMR84Bm9whTdpoohqmRBCFaW/Aa?=
 =?us-ascii?Q?Lnyof8TqLUAqy+FemEjORRwFmUna0x1ppXkpd6O33p6cNJ2gQbMQNvzsbkIS?=
 =?us-ascii?Q?U5aWgA7vuHZEFEwV5ccv4Rbo/oleksEgOTvUX6CPl4G6eCGIlssVuGWby0+d?=
 =?us-ascii?Q?8QqnJItp90WaWGh5BVJrT8q+KJF9VsJhyeGYMuYHo6aFKv1sp5jsTR1wk11T?=
 =?us-ascii?Q?kZGspbAJeveSSOG0stzo/Bvo2Q3YHViZmzKEG69fbrxM18VmIm/e6EYuozjR?=
 =?us-ascii?Q?LNN5deAMady0YwsrseIK2dfPkb1l6RMzWmxl44/9Ub2p9Tsimo2TNQRQE6Xd?=
 =?us-ascii?Q?WO6XWaY9RlDzziE3vsHThtAek9329kOraKmPNKgkp+pHUXI0yhiq35qc4eQw?=
 =?us-ascii?Q?S+4SD9TdvoJLXFRnVk2Hz1l+ZbeI1/H+Ly9F8qN7oE+UfG/ZBk8pYVCXQGWk?=
 =?us-ascii?Q?QV3R0BssNsVeFw2VAT/uMBuDlhnNlAa29C+JVqekbN44oUN6sMkS0JRusbrU?=
 =?us-ascii?Q?s3Tj2O4JJiOmZdEz4tikBXThFy7pYLlX95hEpOXUBVKZ7W1BqDQHDPmp+R2I?=
 =?us-ascii?Q?lqjYd2z/rw0WbCiZrw2qyzUF5mRAJV1sb2KqiZjji3pHT3/OpFGucvN+0xa2?=
 =?us-ascii?Q?+dKKhFKoULj3sgfGF8wtqqV64PWbfMW3Omqmf3GMh3PPOzrrVwPOwMjvTAQZ?=
 =?us-ascii?Q?zAMUxN5OxQOAHBl2GtuhOY3rRGX7x6s1nhPmQfKg7sZMxt/NduK1mGZWZVmZ?=
 =?us-ascii?Q?IgebNmNrYcpS0FufbLaENzge7Tp6bibF/pFq+9irGUEv9IM1Hy6SLhfZOSev?=
 =?us-ascii?Q?gQRPAzUL/OM0mi0tMKe2Dd3cFqkT1uxxO63n4INp3CaLqpKwz+DZV+7vPyTR?=
 =?us-ascii?Q?lLOrFMWZZMFFkPaMaibF7TExK3w+dwzbxtEkQHrCHZixPCWjjLi+VrClAbVH?=
 =?us-ascii?Q?iSpjKKV5R3hLjF0ZPNS5oSiihp0Ilv9n6SOcatROUhe2ZhVJVKD1YIaWc5mL?=
 =?us-ascii?Q?1JCnVsmaZXDZK+pVRhIbYTmF/7GGNT6sEwEifU6TWqe9pHVue1OKOQnUentw?=
 =?us-ascii?Q?BrJfytHPmuKg6Xlipc2C0Pd0/oF7Efjcg6Z2uyKz7XVbyNZi7J8X84V9xvk+?=
 =?us-ascii?Q?XllPyDsRNPtK98ljMYbIrb0x7L2kcY+ydyBGzNPI+BcHbaxofYH263HtmqUH?=
 =?us-ascii?Q?JMERTC7KG7CpniNZnSGN8Vpf8T5IAAysXN7KAaOGGxisy5PAPOS0ovRfs4E5?=
 =?us-ascii?Q?MHBPDgCxX7HzmINgUy8gnvhr7geAEuFwmE0cmw8/hq9/wH0Hyg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yTTTZI0XanVHrA4/RerMBKoSb6pNBSQN21heNVSSZJ/+6curI+H/Y2PK3VCS?=
 =?us-ascii?Q?zB5jOML2QXp3fcrO+wvv1sHAncL078Q3Oe+kr3jnyujkb1w1uKxR0qk0eGYM?=
 =?us-ascii?Q?bYFjmgVyYxN6H21zSRJdXijwsh+eRsmcF5eOt+MpbRvmAELRP8FNEVAnqHvZ?=
 =?us-ascii?Q?8JPqQ262Tb7Mes/CGm9MeI88swYdG5GGcecuvV36TE/36h8Bn6w7Ec23T4Dq?=
 =?us-ascii?Q?4DkpvxYAYoVpNNFfIR0l02hhEg1x4hog2pppGWDIaXQIdXZHlEIt2tvgUlBb?=
 =?us-ascii?Q?zZsfN5OCNvCiq4s1EjX0INXWlB3pi+nMW/6uGd8O/eMgyUrI05kLR07o8SY9?=
 =?us-ascii?Q?N3fNqwtdjvvpMAEiygZWrQ9uR2ADxFgDcf7g4GUOUSdjU4QRpmg5CKlkUpaF?=
 =?us-ascii?Q?X381DTluUXOlXtrqo/z8VL+rEZzKJI+kvxEXP1EWLXdVT8dcXjoKZQaA3GfC?=
 =?us-ascii?Q?d17r5MZtgQfr5whDpFvTml93x/5zHF0Zcb2i2YIcpgUwj9vWHd53cUKYkp0z?=
 =?us-ascii?Q?gmF+zdkl5K36Rxuf2fgRBm2mgmNlKyOznAVP7w8Qv1GelNxKhhr2oc25Jwkk?=
 =?us-ascii?Q?1TGOxPTNuohR9WHBOpNz76EycrAgg7dEoinn1Opv/QyJRgasnKIod1MBoYUP?=
 =?us-ascii?Q?X6BFievwgvyeay6Now27WF/PIDo4NRX5paMqwjvmB9Ts2Li/S5xXz0EkkR1B?=
 =?us-ascii?Q?/AVk52yZzLjd/LP7gjPFFmv02gnEG2TFNfZTUBak69+ta70VoUzPYIXS8b0X?=
 =?us-ascii?Q?Kuf8tT42zrMtlKEnsDt01HRCNKVZwcsKCktD8qqeypdNR8IFDDo5dMNQ1QE1?=
 =?us-ascii?Q?a3zSwIKxRIH/a9kuyzj5o8thEE1OhyA8rq+RB/kJPF/g6bx0RYCXZ4oUAx2c?=
 =?us-ascii?Q?QekTYoCBCVRkIpiVS/J7tqNTRGrcfqNEkbqqmadJVitsDvp8jnPU/5q5T3ht?=
 =?us-ascii?Q?UDPqu6iNnBu6lWXJ0N035dYBs8+VPI7HhB9iTaB71fqHURX7IGP2jV8yH9R4?=
 =?us-ascii?Q?QQTVyvRi6tbiO2NqkF+EOAXqG3YhDMPtNJDOrfuOFERKivoUNcngJnwBkSLe?=
 =?us-ascii?Q?ssFwoc09U+0nTqhHMzGeevCPHgyyNmBxGB2c5QC6zVK6qY+mqdEOPCAVeJdP?=
 =?us-ascii?Q?/CTH06xy2YUaAB6tpNQi2NcRah/bUWrAe5Vqs4q6xO1Eae1XdODnZjt5oZbY?=
 =?us-ascii?Q?EwN+H4oc4T4kQRDZzyQhr6LuqAHQJ1aETGNUcI2k/NnpNXnzxv2AYnp9I+s2?=
 =?us-ascii?Q?qpXsRpUQp0G3zV6Fd/A/sDeQ3MUbxtyi2RK8Buc1jZI06+W0gtpAZ78Y46r/?=
 =?us-ascii?Q?RhOs0bgcEpQ4YIdAmb9Xtom3dHrAqDZJZl/Es1SuN+gPxsiTVGyQSlYEoKjm?=
 =?us-ascii?Q?yfjH2hHe2evjE1NeoaY+U5cP9Fe2YSseoVNd491ML2Q7z9bmQeX3JClpOiIh?=
 =?us-ascii?Q?dDKoB32MK4Jo8xQfespfMPXqSfuHlr8IbnGb8rbYbD0OfiMk5Kt3zl7D9gO5?=
 =?us-ascii?Q?cdtR9fTyrhuvgY5nPHuXUo277XoX8DOhJeCZa+XipK80/c/48pSCugHD/YNo?=
 =?us-ascii?Q?4VttAc6aK2nYaitc2QnFHhbHx6liunNj0GuD2Jje?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5Iywht4S4E7Erj1XFImM40GN4pAK7D8KYtNSIcD1X6r0ne2Uai8IXIH5ORh41CCg3uUpwqT0wvxtBl5nwxa8uEB166/wndB+GhXOhPzAnx6RttAXu6vkb3EduqK/IWh19kVBjsJLUxv/Lc9p5JAkiulw5zJiCyiwIs9jCWsSo22uDUjqKmGn7VexP2UCwBqPdjRulE26y2LGXZ/hgTe6V2m9khH6UMit5Zy4M0fwj0wAKT/wuID9JpBaTfxBns7m187meHoSGL2+CB2IFrxoBppMqZ47p3wr5tbbf/gZ4DjOfcBGAC6AtThvDavIL0pPrDKzgaal4TDVnKhcGrl4oZ8YKhMrUk974gR+tHcvrX0Yug2Hpl+FZc5fbhNzNtl9360KTjmGl2p/RmiLD1oVlUGs3FtEsbrY+3WGRjD+lEiYKrwJuaJXrJGQTip96xw24vR2+/f9Zw+zmHA0cdy8BRVOTNqqaoL0X3JgaYGhqVxjv87eD/FWSjvWTVwdKc5BqkPyd8IST8EdFQ9l63poQqcnm9RIB3fpmY02bhf7R6uPlEMHoMbwFtOnKW0aIBtOqwW/V5sgVgji4GFdulSlcyB4iVL34hULd9lrmTP/0bIt/y6PpDmQonx1AAqhgnr1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79e1e44-9408-487e-36bf-08dcc72706d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2024 06:02:41.1782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wqC+jb5pIK8mFOdj3Bb4zXjs089WiRBpg8KVgGKbAlp1V798h7oLErLDwqAHCb3d8CEkPnGf3SddhFgHVw4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6835

> The ufshcd_urgent_bkops() is a wrapper function.
> It only calls the ufshcd_bkops_ctrl(). Remove it to simplify the ufs core=
 driver.
> Replace any references to ufshcd_urgent_bkops() with ufshcd_bkops_ctrl().
>=20
> In addition, remove the second parameter in the
> ufshcd_bkops_ctrl() because the information can be retrieved from the fir=
st
> parameter.
>=20
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
