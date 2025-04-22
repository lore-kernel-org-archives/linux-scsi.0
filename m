Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F291E5B99;
	Tue, 22 Apr 2025 08:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745309516; cv=fail; b=K1oyl8Z1CHxqa3kM/psd+ozeMmL6MtamJdoMFvGORLQg+43PxyPRDYSmk/6Z5exNW3ArSOD+65cDqLId1zdliie7Tp9tWaFc2SuPYXGjWw500sVN9L4yvr+oENqfvKPfxjst6ZcSY+8tTos+DDnU3V26QSIaLy9n7ruJke0Oj0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745309516; c=relaxed/simple;
	bh=nOrGfS9O85Uh8dFGdFtP+85Cq0h72jkJQ4ScoIevRjw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QsI4an91dG3E4y2NiJqisZOnFTSTIpPk+DDzyj5UfnaPaah4gxHWWSPJzoF82fUESA+Xr0Gy2hKVfFAUJRObDV0yx+P0Dua5ZLblDIbUga3UYju9mpo6yIPhZcTnTSmLIphnRGma6ewXglAkvB12SHQ0YCajSR+/ruadU+/GC7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=kkvvCtfq; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="kkvvCtfq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1745309515; x=1776845515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nOrGfS9O85Uh8dFGdFtP+85Cq0h72jkJQ4ScoIevRjw=;
  b=kkvvCtfqWR/W77kk/p/RKe5Og7O74NbQMKBg+1q78ECIpkvP0uq1TG/o
   ZRDW2MXdyXQE7buq6yR1TaTtnDjBKty59kbpQKRPSmwWZVe9scj9q0f9x
   gql0ValLHg0D6Iibi7rMeOp6rIAPlcrh15ybGOREYRAYrod0j2QaKo4kT
   D37ItVSSq1fDmhgKAzCQ4ZRpIU31kvgm7c3GZv6Y5FlpACAEpMm7Duj9X
   4Rl1GxOwMmjPIERg39SHgA0/SliOlpsYb2/TwacmWStowtBp0E8uYAZzJ
   PW823Inqn7jjEG047YBGmoblxt+rXY9zcETtDOwrJ3tN+lNZ4O1hY6sOi
   g==;
X-CSE-ConnectionGUID: jIzkW1YCT3SSWJ5Z5RAP+Q==
X-CSE-MsgGUID: NzeHlFkkQUWmy8IV6YrAeg==
X-IronPort-AV: E=Sophos;i="6.15,230,1739808000"; 
   d="scan'208";a="77423627"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2025 16:11:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vJ4THXOYCe5M8VSLnL7ekS3djAH7mRtGqWFGl242eUU4+TWzF5SU17oEFy/XF6PajfTYHhvPfVkDjr7ILbOibaTgP2tcu2oDdSrLDC7m+PjRcx5T5hciftmIqwp48/QWuHi2kckLjxaTx1HrRIQ8csA4oDdUk5WpyjXiLE025CpuhVRVBbeqrsTFffo0qL5ySnHZXB1e0MszPMrIvmN14T1RhiwePpEIdT4LMd0HheXB1T7WHrvqpkqWpZZ3Z/ZAmypAppdHcJ4LUdjb3R7ej8GaIYWApUmuCZp5IOjn+vAJRQsdU1d0ieYojUi+hdn5MsD+udpjDRK8RNGNfTsuqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOrGfS9O85Uh8dFGdFtP+85Cq0h72jkJQ4ScoIevRjw=;
 b=NAyX7sJyA4jjbdEnKMTcsPykw6plXfFwAu/uV05d74r27tf6CooMe5Z1tKy+ses2QAfyJYPycP0xJ5bEF/mujmoNE+1mA3Rqg92PK9eyxmYzFI/W3e9ow8Qy8V3vjViFI+cGlhU03+66gQMyn4YzR1dQNxv9xogazjrkEaHuXdfbZWyfMwGylhcGyDQ8YGkgZRKN1Bdrz+4spn0qDa215jJcbO32lYpmDCWAgJiZUv0C6GFF0zFQy1aQ19Y37HkXM8/l2dsZQdGnfF55K2hVCBcjyXlS7uw2oKxbVQbuqfNL2LHIkM9OBKNFB8wFf5hy7njzd02CKHsvuOoLCXdEVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SJ2PR16MB6208.namprd16.prod.outlook.com (2603:10b6:a03:583::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Tue, 22 Apr
 2025 08:11:45 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 08:11:44 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Huan Tang <tanghuan@vivo.com>
CC: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "ebiggers@google.com"
	<ebiggers@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "opensource.kernel@vivo.com"
	<opensource.kernel@vivo.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>
Subject: RE: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Topic: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Index: AQHbssSLc9WQg4rlL0i8HmFOHJYfrbOu/piAgAA6rICAAAe6UIAAA7GAgAAPuDA=
Date: Tue, 22 Apr 2025 08:11:44 +0000
Message-ID:
 <PH7PR16MB6196FCF8E7C26C4A94920FF1E5BB2@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <PH7PR16MB619679B002E0AB4CD28CE93DE5BB2@PH7PR16MB6196.namprd16.prod.outlook.com>
 <20250422070647.794-1-tanghuan@vivo.com>
In-Reply-To: <20250422070647.794-1-tanghuan@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SJ2PR16MB6208:EE_
x-ms-office365-filtering-correlation-id: e5cfa2ce-952c-42d1-41c5-08dd81755255
x-ms-exchange-atpmessageproperties: SA
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?oh1RCk4C85RvoaRxym9gmPts80I2eRB0LSkuEMJbwT+xwcKTy0KXKbGWk7Kc?=
 =?us-ascii?Q?jfSqOqYv8qedZXiy0yxT33VMuMxLSxhDNZt4f33KOfZ+5NsTU9m+U2ATSwJc?=
 =?us-ascii?Q?iS9R6nvEf4ZGbbkRGqmLHBDYmoVSnLeTY11LV3/9Rs6qkI5gdJgB7fmwkg1V?=
 =?us-ascii?Q?airjSHQct7et22GUUIrYumrL48TT6XHoMXchI2t5UADe/lUf2fjnynK89w1V?=
 =?us-ascii?Q?Ie9hhcIT5751zwnzQFpAKuMLRYktrUHreOp2inftrcAdBDi4jdGntoKYOFUg?=
 =?us-ascii?Q?5GYSVatd9tylJlUBRcxEYOpMhsygAui2P42tiA/hU1m1RPIva3tyHk6sufEl?=
 =?us-ascii?Q?I+IxJGwZAL006QAtaLV75HJlxdA1iikeQT8awf+53hAA9X2bDsnZKZLLC6dH?=
 =?us-ascii?Q?1hy/k6qqbKimgPhcBMIfgUS99OjwuswN6yXEF7+xkBLYTY8+U46Xd/30nkQa?=
 =?us-ascii?Q?/E9KDRP3TshszZr1WfQWZGN5Y/KU16UPRH61K1MwKUn51oEDK3G75UxhniRK?=
 =?us-ascii?Q?CkwmtUwZXVtsTVoljNppixpxgI2B46FhR5vp1XUr3Uz/upD0rmdVJxEG4u6m?=
 =?us-ascii?Q?Vw7bqaGBzQw5oX/hLGIwbGJMSfvswiJJJ0QBX3eJYJirrcWOQ1WWX+z/1wva?=
 =?us-ascii?Q?3oGmdn4DTp/pxPUaMzdrM1yXuVNlC6gmyMV9VLERg30/FfwlWqVd9VsLyieB?=
 =?us-ascii?Q?ElW5RTXexX+/CcdtVZhcNWNaTYyreXEqmyq+2K3yOXKr5zaKb62M2qRtYIOU?=
 =?us-ascii?Q?pHhxF/BrONFG1jJmpoxtO1X+v24/xCTN6YsTbQ2iZ+RbdT6G3JyF0iD2HlWM?=
 =?us-ascii?Q?Yp0I6Oe6e2GHpTg5AJxK/PqCN93oyWS7oxOZ2U6Kn2ArOHXJtUJwqU2PxcVB?=
 =?us-ascii?Q?f+PSUhanLLtMU7f8QrG+u32Vz7JekEghrOJKiH/gUkBkuoIP/W5f9agiNySr?=
 =?us-ascii?Q?JKD0wOnv57ZFX5H0V/B3AztEssIN1vEYuxRMSOdfJpfPu1hKksWDr2EDQN4f?=
 =?us-ascii?Q?8y3feziblAfq8r+A4ztJVEjmvSUQnoCE6X1hzI19sNoZY9pZ73Az+wMhCW/O?=
 =?us-ascii?Q?0uZqqK5YvCrvjbdj2rculqdkDU+8EQ77CYaTM2EGk/RU5yf2sWLTnYZQv6/7?=
 =?us-ascii?Q?KfBDR4tXMWtm7WtCuXLZaRrNf2DNzXXt5STmY7rnLzEdi0N9wayQKVD0Q+Ix?=
 =?us-ascii?Q?V9v6XqERRYx4l+uVvYIvORtNXSoOnHIJ0XKobTs5r3V9QA5LWsWo3JVW3fBS?=
 =?us-ascii?Q?vmnEvaZbYktlayzhrT/IZ/f7ppUJyuy5Xt1sAv9uOgRxGhlAgq/oQkanQWp/?=
 =?us-ascii?Q?PrVS15cUYb0kl32j01rzfMtJJLHbpwYNIFMccZ4/RY6Jm4a4pHOQ9OSDuttV?=
 =?us-ascii?Q?o0daPHUp9rB30bVGfNrPemLA9vzArLDEpFfxbvccpJ0hiH9fKXwmx6DVqU5R?=
 =?us-ascii?Q?3BaM0N9gtLK8vnC9PISgucQHuu46VolmJdvwsm1nZtEsgqWkXAF/Bw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nzBkypWBYbDDRJF6z8dWa6V142F+AD3fCn1Y/iqratBKerJJA01AHHskj49L?=
 =?us-ascii?Q?qhuI2SVluLI5loYl2lGu5fh0CQ4LFAi/6UYeNG2IzmLDSaJJyqMGbyqYPyvV?=
 =?us-ascii?Q?m4tnDA5HM2JK3B7d60/UrmzbaUR8h73N6JdAEC7V7n6QgAKBZ/8DdOJwHg0T?=
 =?us-ascii?Q?eDQ8woggooko0jf1LiZ4GGNsaqLGtAwV3OmrJwLZQ3OOqxTijzj6tQIGFGqt?=
 =?us-ascii?Q?q19W6b+gK3drYaKK/4MSsm9A9+aKul/9u6+M9tMLlPyTyxGu+WBgPlddJWgb?=
 =?us-ascii?Q?ZFLvPPKPdGALQYM+vBS1UXLdwusahBVcAjnwOBtpXVMZqdsx7ovsDTwPFP/o?=
 =?us-ascii?Q?HgPFIGFPCJNpgLzf87bvVoZ6y/wcOO9L+dZ9SdEeHfmZchEEiAHSrzX0yqwo?=
 =?us-ascii?Q?TDk802BWlSkaKuSM4T3VdWYoYiYwxbpx1Ihek9Ky+EKqvxF3AJvyjqvIvCSs?=
 =?us-ascii?Q?5EesmStFw5Q4fvQoTxKFYqyZSTnpMng2cs7SVCN9QfhGdYFbrkL7PtNooE3Q?=
 =?us-ascii?Q?KTs0ap+e/ZQ1nz50f8xxro4u8K0wutfnH8f4Bz/zMweWdYXW0MIMG2SWvF15?=
 =?us-ascii?Q?41jO61qm1gKRI74DgHtMTJRCLTmOBF24AX5u+rjDgbYhTaj6qYD3sjLyqr5a?=
 =?us-ascii?Q?vlWff6hGXg6K2KrmQd/ubGI7igXR841/L7qMyrzM00hk72wOKvf9yMkdCY1Q?=
 =?us-ascii?Q?TMngpZ+hnSXjW0elrMTrBXPp5yhdfw1ll2t2u1qA513XcdTg2VWpFeRYua+Z?=
 =?us-ascii?Q?T8sikfQXDGb9qns166DKjYQdqTh4xrOYk8IDxEeRBQKJg/MVLbvK8Wg8s8rF?=
 =?us-ascii?Q?W81eD+/JumGL4ybQHmBfsMpmk/jZMJR2rFFXJDdAJ0GoQ8bxM4wLPssRvw9D?=
 =?us-ascii?Q?rRWKRi4BpUcP+QN061lOXhgOgK7IrlzJvk7JL80UPBwg2BcUL7QR+CnWecyf?=
 =?us-ascii?Q?JQaaZe2vaNRizmLNs0qvMemNXuFgcU5z0D+V39PXql06zvR+FyufZ8DxRU2H?=
 =?us-ascii?Q?5b3BPNCwJjNsPBQGDv5p6aCg1PzoaiLmEw8Ahq1Onu1CVTpOV2+RyVzdoVPw?=
 =?us-ascii?Q?5Dwt2O7/sGXC7UA4JJir9RVUHmeZbpWIcbBWgz3s3mKzjhd90WByuaLus+yd?=
 =?us-ascii?Q?wb8X80lK9aXTlCls2YfUf/kczCEnNt0BDfMcvrGA5LXEDDekiCp7OY5rNsWV?=
 =?us-ascii?Q?USoLhAeHAaU2eN9S9f0HKop/xBJGd33D0OJSRjvY9kUJnlZoxw2v9ZMqzmTJ?=
 =?us-ascii?Q?smJuDG1eRpl2Glytr31x1wOBrEC1FiJ3FOzB6OG1GFQ1yLl6SMEo1Q6dfZxZ?=
 =?us-ascii?Q?Bz2NFM/hmZxwKX3V6z7AjY9CFJVIhYrXKoKb8Ae5OO1RN8Ki+S2J5JftsKK2?=
 =?us-ascii?Q?LCdWuSCVpc1YvYFg267vkXEX4ANQ9KohUoENulCEIvQ4/9opMRGY7Dwb6tmq?=
 =?us-ascii?Q?habxEX7cU+ORGtJjTwgRLOvCky1sTiUr0ceqiAh1KdQHRZNSA9I5IbQkwbKF?=
 =?us-ascii?Q?xkdF2kFYRqpW9NmhkJLzq9cTbEOLV3Kfc/gTgSFTYe9AKd/lq84OFsVO8oEm?=
 =?us-ascii?Q?HteoXKfJq/ujCR/zLP53Vyv1fgQZBLNrg7u6sXYk?=
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
	MlKDJjOvbMPQdbySvykXlm3peXeLrW4xXRKHLkB+eBbfubCvoheoY3Xh3lz5/JNYqmRccojCOizDRET+jlwFXxpGvzpM8NgWo2dyqGsSxe83PuR2HsqBq6PLKgnOFep+vlNlL480gC8MCut5LUrHmmOiUNkgT5BoREUDRjEDBxIo8+d+bT2GRHM3G9nNMJTqOHc2Hoxf7aAl0012BpQ0G5hjoaDfYkuguXbliaewaGs07bUrrrVYDLRLVIv0ydEhMgvDODQxdRYs9MpsXJMR/y2M0bUd27XtNzP+vOFjyeTfh9g3R/pkHA3sW09zOMfX0hUcrv0FSG0uk/PBytPswOskoxEY+WSlNxz2ZbG8R6mXXB+UeCrbbtZ3yUdp8A+qYOXYIkQGIMeNUVpx3y2HUUi8IGDMLN1sWSK+F+2b3RC1kGIXGSC3qtH64JHcxb8ViMbpFyfZP6IobiU5crb1GAKBnOJ9inkrRcs+DKcQh/BgKIEu7FFQhAsNjo5u9y45u5iH5MdRTLmmpf+VgbPW7+a7jXlfqrfRf7j6MnwzJgyhTkDkITU/s+EUuuCo04P6sEHyivsHZTu+W6ev8yTf729NvoKReU4N0ObfMgGZ2pJ9UImB/mnlM8F15Pvnc0RPnICVAl0zDIVFVj0f5F0dsA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5cfa2ce-952c-42d1-41c5-08dd81755255
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 08:11:44.8704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g4F5HOkrMFH4I5g0ARUWZr+LrTGJ5T5+R3p+vwTJejclToQK0ta+f4tkRWtJSlSui8RzAYQFCh65n7KU/r4gBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR16MB6208

> This means that the soc is UFSHCI 4.x, but the ufs device uses ufs2.x.
Ahha - ok.
One more thing you can try, is to wave the if (dev_info->wspecversion < 0x4=
00) in ufshcd_set_rtt().
Originally it was designed for gear 5, but it would also help to maximize t=
he device performance.

Thanks,
Avri
