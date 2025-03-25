Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8436625A323;
	Tue, 25 Mar 2025 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742920443; cv=fail; b=VbegRqQFgght159v3ITOGNMHGNyPi9Msso+P6mA0YmZZVri/3vkMFq6ifzJ2N0aZR3igYLBpkzMs4UAluWQo1XTrAOMsGsvpFTHHNXqCfmOunYsUKvLnES95kkS8NEMddQbbTRn3tkfyZJqSB77ZWlerNLjUpWmatuguON44POk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742920443; c=relaxed/simple;
	bh=McGIPB5TJmfxlA8IuiBToRmakxgQB/aPveGDanWjJqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IrC+B4YFuZFwBO+0ZkWPdWHhzoJ67OouvDn0WyCnzt0Zf7ETfl5M0V6WWoQIe72QbwWNJboGrEaCHBQOQ0YSorKTPi5nC+38mjHu27pDig+Gpcl1D/5XSih4fZhFlbPQtdf+bZv8bKIx9yQFAF/xSOIZDhGem60AlwxHt2NKx8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=tK0TkSQt; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="tK0TkSQt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1742920437; x=1774456437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=McGIPB5TJmfxlA8IuiBToRmakxgQB/aPveGDanWjJqw=;
  b=tK0TkSQtOWAmTzlyWvPWwof//GFeeWVrsLYsJWSboj1DaZj7/kx/oapR
   0t1mdCQDiDvDBIzEfuPYGsnk8zSfMUV2msF6Q/fkKoouZoQb/mq08ZezY
   X/JZZKuh9lVgfbA8TRYCrEZZkYsaGPNlPnL65fnzuCMUsoMYgne7Ui7Df
   J6NwQGJmJ01aZoFP3C2t8xgcb0yNtRxv/rxO5Q6Vd/3wRp7fjBtTT89GD
   5JQsSaZrd9xSs0PDGx4ne+kTBuaXDYjQMZRtYB8t6KKSm2rVIfP44CAVH
   g3034DptjyqaSYYBoMyidgfWW2El3DYDeWqBaUE6sxppl6cXDyPBf5fXP
   w==;
X-CSE-ConnectionGUID: EkeOOIkLQSKifrWP2QeFUg==
X-CSE-MsgGUID: stT4YQ3/Qeyl5+fDbH0JWQ==
X-IronPort-AV: E=Sophos;i="6.14,275,1736784000"; 
   d="scan'208";a="59856635"
Received: from mail-dm3nam02lp2041.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.41])
  by ob1.hgst.iphmx.com with ESMTP; 26 Mar 2025 00:33:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RTanBfymKacrEMd/IBvpm+DvqCUF4goEV68jT9OFlFg+Us0YY4/7NhLKkm5B4/ACBJaKCPqBU9/CIvAHojpTLEZcJBZ4d57vhuHtIjXgbkgKoGoO/kyof4848r1JUWaN9l5/eiY/JmDCWuHndSd5/NmTYCMcCvnBCaa01Ss64kxxhpyY6lXiaw55BgiXozM895KeM12zlX1SwPh9u9FZjm+XI3NGrhArUccYZZg0XqlJptOlQjRIFQ2JeQylcxvXJmH1dOrNllQ+pNhR1lI3GskmufdZBP5wO/6dVPLluS4Djrw55/gce5UBeG7jIEds8qL71fKH1BIyUyohesrdzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNeZecqcj48I+kBdHVaRTl7XQqRu6of+cOcULg/If9E=;
 b=oXQg+kyijQAZDoy9fnkY3XMtMZChr6xM3P5MUFGo8OyOk+mftHnfGDg7v2Aa9B8kW0gamTPsFtC2CIEOJWdCqF7jRwhA9rbG3ber1QFckYUhswB3TvHQ8q4fvN0diH4B7lijsY3nA1W7vUZY/LMFNecZLlbrjt8e+KUKMKUxhj2m3bv1ugsuOFbPodZNlkYxyDBs+2LVQ5SbgwrkyE6DgAdIKvshM5j5ic2j3k5HYrZ2N0vkbvayqFyPoD1i6+OTxdIvbnD+qQztOT/aRZXafLPcO8V62ANdCGCInkqj//3sxtxGdAEY8LtltIUqQBv3Gdz+fhwmBJXYWKAq6S4Djg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from SA2PR16MB4251.namprd16.prod.outlook.com (2603:10b6:806:136::8)
 by IA2PR16MB6478.namprd16.prod.outlook.com (2603:10b6:208:4ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 16:33:47 +0000
Received: from SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2]) by SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2%5]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 16:33:46 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Bean Huo <beanhuo@micron.com>,
	Keoseong Park <keosung.park@samsung.com>, Ziqi Chen
	<quic_ziqichen@quicinc.com>, Al Viro <viro@zeniv.linux.org.uk>, Gwendal
 Grignou <gwendal@chromium.org>, Eric Biggers <ebiggers@google.com>, open list
	<linux-kernel@vger.kernel.org>, "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>, "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Thread-Topic: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Thread-Index: AQHbmhAfUxUsnAjyAUq7uGmV7Mzy/bOEEBbA
Date: Tue, 25 Mar 2025 16:33:46 +0000
Message-ID:
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
References:
 <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
In-Reply-To:
 <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR16MB4251:EE_|IA2PR16MB6478:EE_
x-ms-office365-filtering-correlation-id: f44660da-006b-46bb-185a-08dd6bbad0e9
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?jpJgeNj/Go40lG8d+0W8wh2LbelOskhGE9mlLTg6oe9xoQSv5fn8HrGIzoun?=
 =?us-ascii?Q?pYON/FJVGhNZfYxMYJSncX3i5GjosCsnO1/bCGocG6/vn9seEF7BInNk+wsf?=
 =?us-ascii?Q?04vSdgbeKPVGhYbMJuXpQlNowrk7j4x+MLlxBNRfCQZxCyXk09zmE2Ajf3fq?=
 =?us-ascii?Q?aqeOhg447W9NF/6sM3ruHmtLqVTBwcEglUp/SZCvMD+y2iSIgxSaBvwHINgO?=
 =?us-ascii?Q?wL4eKywDUM5GL84Z/3jscMfI1Nh8AubCOYMR041Xm7UUhkvK1ffNuc+fotUD?=
 =?us-ascii?Q?qW8EgU8NiHhKJnYXJjfVuex8B407xj+xQts23OrNmbS4ZRmhiMsDcZ8sqvmp?=
 =?us-ascii?Q?dI9N+kd0dbhmHGP0v24GtE9MsAkfA0bdC/4T6wgkzIiu2agmGrg2fv4OYthq?=
 =?us-ascii?Q?WA4renCiDZ8bk+FSveZRCSsoRCStgtiR4q1tOUkVp6WzJ62Jv/iBUZfzZzjm?=
 =?us-ascii?Q?ftG6aCIHk1W06rk9N5eippceb5mYSxPThKPXz+LHoAHkiFNcRTbSRpzGvJGU?=
 =?us-ascii?Q?i90psazdVWybydf8drJKaa6clGNWAXnFI/3YkM6bFov/EnlsB4GCkntBjUjR?=
 =?us-ascii?Q?3uuN+uNguKxSoQExyhO+6eAK3rrqMDTL4VKkX86Hz7Hov54cCTUPT3UGXuMg?=
 =?us-ascii?Q?cXlo1XKEOTV+LzeMy/Tm96mPGNJfUYQbcgy/6YlqrSxdInos8qpLAPEK+wNA?=
 =?us-ascii?Q?+6P9ouYOop3H4rIAXyp1OakMUGOTjhnp2gUsFw40GILs1LS14JVjyqjzZCrb?=
 =?us-ascii?Q?KHt5dBmcqdsQCBz6+hIJJrL34I6sgS8Re59tTyjdgBZi1ID3d6QW+uRtdzuF?=
 =?us-ascii?Q?EhLfOTSTp6pFR5JRTyK3v8Q+W4AdJxri5gAMNvskOzoBFc8N0IRKrnjfFWpr?=
 =?us-ascii?Q?zsOOyl05Es/t5OJQkkZvG5m3CDVXzWY7N7qzcMcaq6HfDplIBNZ0emlEzmL0?=
 =?us-ascii?Q?oN6RiJrmTuHlm7uEIZUQhtnkcl4XsPnxkKWEvMXRAwCnWutQRNiiczS4YLTN?=
 =?us-ascii?Q?5AnrmbffUWe7bKq3ig4/i/1uCmOKlgsNnfYpoEQaRUv31PqAzsgq8X1zjVJM?=
 =?us-ascii?Q?x9Bozf4nWjBgvFFs6ci7vnnO48HsuJxALcYwFGzmeIUY4ANlkC+jM8BNqJlt?=
 =?us-ascii?Q?fQnCkpbU5KRan3tbJDEL8kup8oL0afxNgZLSA2fbb17wrWPuToWsqo6LDOv4?=
 =?us-ascii?Q?0bgQiVdsorDr/GaAXKNgacJ86l+K6V5kZiXu1s7pEj6mH7edz/gGoCuGtGGf?=
 =?us-ascii?Q?OTmNJvZxe7cyWMOEcg0vGqZiKQ/CZYMN7rvCa5tTMgOXA0p5w1t6sbsLdTXl?=
 =?us-ascii?Q?I4ul0xMM4BoKfmI1RkvNx2Q6Qoh9hkj0UOXnrmrsJeFFr2orU365AQeERYmm?=
 =?us-ascii?Q?Nc/o+7myI7UYAP00QLw9dn3N2OnSmnblfsZu8rVksASCwL5Mb7Z4+kptqLA4?=
 =?us-ascii?Q?8nEKK1qWrDidCVERX9XCl8JnTei+NbkU0RQongmrqxsFbuv5I3NxKA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR16MB4251.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Vpg4dngh4+CJC6lsHFCKKez20999tQTheVOtIUfZLdc492EkgYlqTE3jgVRB?=
 =?us-ascii?Q?8ClGF3srIlwCoCgBnNKegKFCpyKpEbk255SrKi6mX6WwZgCcmccCAwPUIyt+?=
 =?us-ascii?Q?i17xn1fJ9zn4+p62zc5w7KiVyVzLypQfah3UMmGtjlqDfrMOv1n2ehjfAXzl?=
 =?us-ascii?Q?JfE+pQBztQ+nlfYs0+Ybq3kG0icifFqqQkscKfVyfwxmrU3S5wigm729hLz/?=
 =?us-ascii?Q?8TsWWCkHRuW4Ela8KkS4BJaqT1OyUvtiRbiazy2BQcrTOZ5MFHGjPgCQ/0Qc?=
 =?us-ascii?Q?E+Hlq4r/Gsd7fio02kup+4enawlVsVhAzggjxkQCYqG361Gk1ijMq9P+Szyw?=
 =?us-ascii?Q?B0o+7CRzQL3VNimQGgjROalH+P3ytGntxSuAMnlT86bD7WJLXfM0iFhVYmZx?=
 =?us-ascii?Q?DW06xmrvTXfGA6q3Matdx1HTauBqoaDJRkyeA7N5/DQONUzJklI06Hcx8poG?=
 =?us-ascii?Q?D9R+PHyJa2w97dydA6FKJ0jOoWZkGxoRQz0jZF3tvc28Nx5jMwLi29FV+g6m?=
 =?us-ascii?Q?bSxuKNOyPOOnbGW+SFvYxf/VRfleIW2K6fv5iithKjcJapos1A5U23IwgQ5X?=
 =?us-ascii?Q?nQOhXFpQtvC/l0DQjRVriOHuWf2L0cJ29+e8a0anixkz2zx6t58navaFDVHx?=
 =?us-ascii?Q?jTcb0gR0M3oKeAXCdze/6zIYf7tGbsBirxyNAa6aQemzOAftp7Oa4hGlLQC5?=
 =?us-ascii?Q?VO329Bui3AY3XHTtPT9CSlnmLF8dCXbX5MkSRqv0Zgsfr+bfqE6UpF9rhJrf?=
 =?us-ascii?Q?QJjkOOp+G8elVSeNNwXMGKKG5s2fUsPPiTke42wv/cMJJ5e+W2anfrYXIcRg?=
 =?us-ascii?Q?VTgjBdc2lCefBt76YX5PIxW7EmHOQtf118IhBpldfbiYyM9UuNRyhFBoT+T+?=
 =?us-ascii?Q?mXWXeEgo4XDbpvmbyLBtR/+JovsLisBf8g8gA/EouHPuBMuDpKGf5fd36nDp?=
 =?us-ascii?Q?+dqIWuNXDUw7IKiAqz1nVjkZQcNYgTf3S5jRelfJpgG3zqVFUrnDAWI3VsSt?=
 =?us-ascii?Q?YPE8QJ3yrHuI0049NlS81e2k3flpfjkk6PJTOrzn++pd3sjo7Fr7f/4HP7XL?=
 =?us-ascii?Q?SbdZ+KqRT2LDUeryPi2k2cOWY6MoLzbd533Hb4t4nBDObpYupBhLFM1h36Cu?=
 =?us-ascii?Q?ysfFE5TSUMAgb3q/y+mVAKGCp1W3krLMcYFEyaMbz5XtyWLTMxo2wbigVRQh?=
 =?us-ascii?Q?ht55Qa0KVhxL+xCzeXzWMOT9RfdLU76T9XydTXR+fb3qHaC+nQLLJpyenyN+?=
 =?us-ascii?Q?oRap17IxLv7RQnc4vQB/72GLGv5sQU6gHgPTqyLW+aVvV+7DoJRbNSKabdQv?=
 =?us-ascii?Q?I9GFC0F2ReOwBoM6xELUIU0inxcFJOVOXQIevDycdHJZXlQTyE0XqKa6eBvh?=
 =?us-ascii?Q?b7qqyoCRktei1oqYXLnMQk9NJoA3jnjzjnispkvIywdLZmghYJDLBIJV4Ch2?=
 =?us-ascii?Q?Ibwl6G7B40ITnV433vnte8MBsxn5NbDVPEiGjsJs1dDe97CZA14i8Rkr1KBC?=
 =?us-ascii?Q?9VJ1r6A4Vn0992kL5Xaf/VOOSEKCJV+o3KeNQ8vP9lirXJV/3VmbJwquWbqI?=
 =?us-ascii?Q?WdrRgjW8KbWetdWUWBIuBvvUt+hJUdpyg6CNS7erhP/Al+tNIpmURxMNU/O/?=
 =?us-ascii?Q?kQ=3D=3D?=
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
	t06S+lvwMYwY5kx5mFgR4Mpo2rYVS3wU5/01k+OWkPLKPzt6JF6fHnpfBydhAONtr0lXLki6w0yaKE4DPvlEJdBcDUiwpkNbgdGY7ZT65ijYx2JbulKoh7Zq091+DSVnXwQZreIbhbkzO7dvrpNrir7DS2wW2/I0WWdMG6BNKvxaIhMrwy8c/9hMz5s+cu6wOb9c5I0faaAfCxj6jgVcqV55O+8HuUxsG4ycWu4bFWlCQzV0uxMgcZstr/eTLHFYuMWzZFR6cBJHrD1xDO+f5GeBftMYJAhWMRMKh0lusIEUqEYDnKqdxcUOo/LhEcaViqD5hbrfkzRdM2W6R6ht04o3Z83sGQB2yjJ5PRC5TFf+aVmQot/PnZRuE4DGTM3mbA/DeKPF4NFCLc5jEC7xqLpA2rN5sgvk3V+86prLJVfgA0Z1InjeI7lAchz1Vgn6svRF9edAMTD1EEexUND2VAm6UR6lCybtdQC4YRzY10SvrIdSfGiq8ukghBn7yZgKugUKV296qSlnOGSdY6dQvl3bIs+4m8Tg4z8dqTasfrVWC2PEn8yEEWMIVmEADR4VrtlV7Ofau0DU0GdBGJ7FcFdi7ASVpJQ2M3k2kbVDTKl5hfVB7VTiwuroWJeuPOkQaYAbMIUm5s+i+61yJY2y2w==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR16MB4251.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44660da-006b-46bb-185a-08dd6bbad0e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2025 16:33:46.8873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVtm6WTCXPvlOqVhzX2mF4qW65CC1zQlkHotzLncuCzTPN08ezxMg5xVcUBGkWfTiKvIpymbJUC9WDQ1ynXkTk19OOI8su2jpezRAurnF0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA2PR16MB6478

Hi Bao

I think adding "struct utp_upiu_query_response_v4_0" is redundant and not c=
orrect for flags upiu response .=20
You can use "struct utp_upiu_query_v4_0"=20

Regards
Arthur

> -----Original Message-----
> From: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Sent: Friday, March 21, 2025 5:18 AM
> To: quic_cang@quicinc.com; quic_nitirawa@quicinc.com;
> bvanassche@acm.org; avri.altman@wdc.com; peter.wang@mediatek.com;
> manivannan.sadhasivam@linaro.org; minwoo.im@samsung.com;
> adrian.hunter@intel.com; martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; Bao D. Nguyen <quic_nguyenb@quicinc.com>;
> Alim Akhtar <alim.akhtar@samsung.com>; James E.J. Bottomley
> <James.Bottomley@HansenPartnership.com>; Matthias Brugger
> <matthias.bgg@gmail.com>; AngeloGioacchino Del Regno
> <angelogioacchino.delregno@collabora.com>; Bean Huo
> <beanhuo@micron.com>; Keoseong Park <keosung.park@samsung.com>;
> Ziqi Chen <quic_ziqichen@quicinc.com>; Al Viro <viro@zeniv.linux.org.uk>;
> Gwendal Grignou <gwendal@chromium.org>; Eric Biggers
> <ebiggers@google.com>; open list <linux-kernel@vger.kernel.org>; moderate=
d
> list:ARM/Mediatek SoC support:Keyword:mediatek <linux-arm-
> kernel@lists.infradead.org>; moderated list:ARM/Mediatek SoC
> support:Keyword:mediatek <linux-mediatek@lists.infradead.org>
> Subject: [PATCH v4 1/1] scsi: ufs: core: add device level exception suppo=
rt
>=20
> The ufs device JEDEC specification version 4.1 adds support for the devic=
e level
> exception events. To support this new device level exception feature, exp=
ose
> two new sysfs nodes below to provide the user space access to the device =
level
> exception information.
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
>=20
> The device_lvl_exception_count sysfs node reports the number of device le=
vel
> exceptions that have occurred since the last time this variable is reset.=
 Writing
> a value of 0 will reset it.
> The device_lvl_exception_id reports the exception ID which is the
> qDeviceLevelExceptionID attribute of the device JEDEC specifications vers=
ion
> 4.1 and later. The user space application can query these sysfs nodes to =
get
> more information about the device level exception.
>=20
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> ---
> Changes in v4:
> 1. Changed the hba->dev_lvl_exception_count to atomic_t type. Removed the
> spinlock() around hba->dev_lvl_exception_count accesses (Peter's and Bart=
's
> comments).
>=20
> Changes in v3:
> 1. Add protection for hba->dev_lvl_exception_count accesses in different
> contexts (Bart's comment).
>=20
> Changes in v2:
> 1. Addressed Mani's comments:
>    - Update the documentation of dev_lvl_exception_count to read/write.
>    - Rephrase the description of the Documentation and commit text.
>    - Remove the export of ufshcd_read_device_lvl_exception_id().
> 2. Addressed Bart's comments:
>    - Rename dev_lvl_exception sysfs node to dev_lvl_exception_count.
>    - Update the documentation of the sysfs nodes.
>    - Skip comment about sysfs_notify() being used in interrupt
>      context because Avri already addressed it.
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 27 ++++++++++++++
>  drivers/ufs/core/ufs-sysfs.c               | 54 ++++++++++++++++++++++++=
+++
>  drivers/ufs/core/ufshcd-priv.h             |  1 +
>  drivers/ufs/core/ufshcd.c                  | 60
> ++++++++++++++++++++++++++++++
>  include/uapi/scsi/scsi_bsg_ufs.h           |  9 +++++
>  include/ufs/ufs.h                          |  5 ++-
>  include/ufs/ufshcd.h                       |  5 +++
>  7 files changed, 160 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index ae01912..6a6c35a 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1604,3 +1604,30 @@ Description:
>  		prevent the UFS from frequently performing clock
> gating/ungating.
>=20
>  		The attribute is read/write.
> +
> +What:
> 	/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_count
> +Date:		March 2025
> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
> +Description:
> +		This attribute is applicable to ufs devices compliant to the
> JEDEC
> +		specifications version 4.1 or later. The
> device_lvl_exception_count
> +		is a counter indicating the number of times the device level
> exceptions
> +		have occurred since the last time this variable is reset.
> +		Writing a 0 value to this attribute will reset the
> device_lvl_exception_count.
> +		If the device_lvl_exception_count reads a positive value, the
> user
> +		application should read the device_lvl_exception_id attribute
> to know more
> +		information about the exception.
> +		This attribute is read/write.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
> +Date:		March 2025
> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
> +Description:
> +		Reading the device_lvl_exception_id returns the
> qDeviceLevelExceptionID
> +		attribute of the ufs device JEDEC specification version 4.1. The
> definition
> +		of the qDeviceLevelExceptionID is the ufs device vendor
> specific implementation.
> +		Refer to the device manufacturer datasheet for more
> information
> +		on the meaning of the qDeviceLevelExceptionID attribute
> value.
> +		The attribute is read only.
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c =
index
> 90b5ab6..634cf16 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device
> *dev,
>  	return sysfs_emit(buf, "%d\n", hba->critical_health_count);  }
>=20
> +static ssize_t device_lvl_exception_count_show(struct device *dev,
> +					       struct device_attribute *attr,
> +					       char *buf)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +
> +	if (hba->dev_info.wspecversion < 0x410)
> +		return -EOPNOTSUPP;
> +
> +	return sysfs_emit(buf, "%u\n",
> +atomic_read(&hba->dev_lvl_exception_count));
> +}
> +
> +static ssize_t device_lvl_exception_count_store(struct device *dev,
> +						struct device_attribute *attr,
> +						const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	unsigned int value;
> +
> +	if (kstrtouint(buf, 0, &value))
> +		return -EINVAL;
> +
> +	/* the only supported usecase is to reset the dev_lvl_exception_count
> */
> +	if (value)
> +		return -EINVAL;
> +
> +	atomic_set(&hba->dev_lvl_exception_count, 0);
> +
> +	return count;
> +}
> +
> +static ssize_t device_lvl_exception_id_show(struct device *dev,
> +					    struct device_attribute *attr,
> +					    char *buf)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	u64 exception_id;
> +	int err;
> +
> +	ufshcd_rpm_get_sync(hba);
> +	err =3D ufshcd_read_device_lvl_exception_id(hba, &exception_id);
> +	ufshcd_rpm_put_sync(hba);
> +
> +	if (err)
> +		return err;
> +
> +	hba->dev_lvl_exception_id =3D exception_id;
> +	return sysfs_emit(buf, "%llu\n", exception_id); }
> +
>  static DEVICE_ATTR_RW(rpm_lvl);
>  static DEVICE_ATTR_RO(rpm_target_dev_state);
>  static DEVICE_ATTR_RO(rpm_target_link_state);
> @@ -479,6 +529,8 @@ static DEVICE_ATTR_RW(wb_flush_threshold);
>  static DEVICE_ATTR_RW(rtc_update_ms);
>  static DEVICE_ATTR_RW(pm_qos_enable);
>  static DEVICE_ATTR_RO(critical_health);
> +static DEVICE_ATTR_RW(device_lvl_exception_count);
> +static DEVICE_ATTR_RO(device_lvl_exception_id);
>=20
>  static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
>  	&dev_attr_rpm_lvl.attr,
> @@ -494,6 +546,8 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D=
 {
>  	&dev_attr_rtc_update_ms.attr,
>  	&dev_attr_pm_qos_enable.attr,
>  	&dev_attr_critical_health.attr,
> +	&dev_attr_device_lvl_exception_count.attr,
> +	&dev_attr_device_lvl_exception_id.attr,
>  	NULL
>  };
>=20
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index 10b4a19..d0a2c96 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -94,6 +94,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>  			     enum query_opcode desc_op);
>=20
>  int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
> +int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64
> +*exception_id);
>=20
>  /* Wrapper functions for safely calling variant operations */  static in=
line const
> char *ufshcd_get_var_name(struct ufs_hba *hba) diff --git
> a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 4e1e214..86ef716 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6013,6 +6013,43 @@ static void
> ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>  				__func__, err);
>  }
>=20
> +int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64
> +*exception_id) {
> +	struct utp_upiu_query_response_v4_0 *upiu_resp;
> +	struct ufs_query_req *request =3D NULL;
> +	struct ufs_query_res *response =3D NULL;
> +	int err;
> +
> +	if (hba->dev_info.wspecversion < 0x410)
> +		return -EOPNOTSUPP;
> +
> +	ufshcd_hold(hba);
> +	mutex_lock(&hba->dev_cmd.lock);
> +
> +	ufshcd_init_query(hba, &request, &response,
> +			  UPIU_QUERY_OPCODE_READ_ATTR,
> +			  QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID, 0, 0);
> +
> +	request->query_func =3D
> UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
> +
> +	err =3D ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
> QUERY_REQ_TIMEOUT);
> +
> +	if (err) {
> +		dev_err(hba->dev, "%s: failed to read device level exception
> %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	upiu_resp =3D (struct utp_upiu_query_response_v4_0 *)response;
> +	*exception_id =3D get_unaligned_be64(&upiu_resp->value);
> +
> +out:
> +	mutex_unlock(&hba->dev_cmd.lock);
> +	ufshcd_release(hba);
> +
> +	return err;
> +}
> +
>  static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_i=
dn
> idn)  {
>  	u8 index;
> @@ -6240,6 +6277,11 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  		sysfs_notify(&hba->dev->kobj, NULL, "critical_health");
>  	}
>=20
> +	if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
> +		atomic_inc(&hba->dev_lvl_exception_count);
> +		sysfs_notify(&hba->dev->kobj, NULL,
> "device_lvl_exception_count");
> +	}
> +
>  	ufs_debugfs_exception_event(hba, status);  }
>=20
> @@ -8139,6 +8181,22 @@ static void ufshcd_temp_notif_probe(struct
> ufs_hba *hba, const u8 *desc_buf)
>  	}
>  }
>=20
> +static void ufshcd_device_lvl_exception_probe(struct ufs_hba *hba, u8
> +*desc_buf) {
> +	u32 ext_ufs_feature;
> +
> +	if (hba->dev_info.wspecversion < 0x410)
> +		return;
> +
> +	ext_ufs_feature =3D get_unaligned_be32(desc_buf +
> +
> 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
> +	if (!(ext_ufs_feature & UFS_DEV_LVL_EXCEPTION_SUP))
> +		return;
> +
> +	atomic_set(&hba->dev_lvl_exception_count, 0);
> +	ufshcd_enable_ee(hba, MASK_EE_DEV_LVL_EXCEPTION); }
> +
>  static void ufshcd_set_rtt(struct ufs_hba *hba)  {
>  	struct ufs_dev_info *dev_info =3D &hba->dev_info; @@ -8339,6
> +8397,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>=20
>  	ufs_init_rtc(hba, desc_buf);
>=20
> +	ufshcd_device_lvl_exception_probe(hba, desc_buf);
> +
>  	/*
>  	 * ufshcd_read_string_desc returns size of the string
>  	 * reset the error value
> diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bs=
g_ufs.h
> index 8c29e49..8b61dff 100644
> --- a/include/uapi/scsi/scsi_bsg_ufs.h
> +++ b/include/uapi/scsi/scsi_bsg_ufs.h
> @@ -143,6 +143,15 @@ struct utp_upiu_query_v4_0 {
>  	__be32 reserved;
>  };
>=20
> +struct utp_upiu_query_response_v4_0 {
> +	__u8 opcode;
> +	__u8 idn;
> +	__u8 index;
> +	__u8 selector;
> +	__be64 value;
> +	__be32 reserved;
> +} __attribute__((__packed__));
> +
>  /**
>   * struct utp_upiu_cmd - Command UPIU structure
>   * @exp_data_transfer_len: Data Transfer Length DW-3 diff --git
> a/include/ufs/ufs.h b/include/ufs/ufs.h index 8a24ed5..1c47136 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -180,7 +180,8 @@ enum attr_idn {
>  	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       =3D 0x1D,
>  	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    =3D 0x1E,
>  	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        =3D 0x1F,
> -	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30
> +	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30,
> +	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     =3D 0x34,
>  };
>=20
>  /* Descriptor idn for Query requests */ @@ -390,6 +391,7 @@ enum {
>  	UFS_DEV_EXT_TEMP_NOTIF		=3D BIT(6),
>  	UFS_DEV_HPB_SUPPORT		=3D BIT(7),
>  	UFS_DEV_WRITE_BOOSTER_SUP	=3D BIT(8),
> +	UFS_DEV_LVL_EXCEPTION_SUP       =3D BIT(12),
>  };
>  #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
>=20
> @@ -419,6 +421,7 @@ enum {
>  	MASK_EE_TOO_LOW_TEMP		=3D BIT(4),
>  	MASK_EE_WRITEBOOSTER_EVENT	=3D BIT(5),
>  	MASK_EE_PERFORMANCE_THROTTLING	=3D BIT(6),
> +	MASK_EE_DEV_LVL_EXCEPTION       =3D BIT(7),
>  	MASK_EE_HEALTH_CRITICAL		=3D BIT(9),
>  };
>  #define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP |
> MASK_EE_TOO_LOW_TEMP) diff --git a/include/ufs/ufshcd.h
> b/include/ufs/ufshcd.h index e3909cc..5888463 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -968,6 +968,9 @@ enum ufshcd_mcq_opr {
>   * @pm_qos_req: PM QoS request handle
>   * @pm_qos_enabled: flag to check if pm qos is enabled
>   * @critical_health_count: count of critical health exceptions
> + * @dev_lvl_exception_count: count of device level exceptions since
> + last reset
> + * @dev_lvl_exception_id: vendor specific information about the
> + * device level exception event.
>   */
>  struct ufs_hba {
>  	void __iomem *mmio_base;
> @@ -1138,6 +1141,8 @@ struct ufs_hba {
>  	bool pm_qos_enabled;
>=20
>  	int critical_health_count;
> +	atomic_t dev_lvl_exception_count;
> +	u64 dev_lvl_exception_id;
>  };
>=20
>  /**
> --
> 2.7.4
>=20

