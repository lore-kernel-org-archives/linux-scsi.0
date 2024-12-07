Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C6A2556E;
	Sat,  7 Dec 2024 04:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545849; cv=fail; b=mHqpT6x1SAprdrYbib2QmAFTcCMrg5Rp3rDSt/ot4l47jgb9FmzB3UjXl/l7nHWXOHTUkD4qgCGplRJPC0kpHzbIt4MTsRu5Y8uK41qV+hB0oRm/1KsoOG4KYrqJD/F3kQ1WghaG9+j636drNRGjysdo7G9Iv1SR5gWZQTU+ajI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545849; c=relaxed/simple;
	bh=U7nbGo2PZnO+Ny3c0y9xAscZokyjbiBwk3tPi7DmO4A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HZto3WmG7OZS6sLX9kQDX6F+JunUOqxfXnEjKl7r8CYa7aPQdG6lC07EGXtQhHZvqAZi5aruAzcD2hHrbXvdXqDLLeEuBDbt0khLuk38blaFtE9cMnGfrRWaq0X8p7F0Tn/yZlx/3wfRxEWPK9vc3l3Dx48llmu5spw2S16tqcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=U/CVbtxu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Kt3cW/YV; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="U/CVbtxu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Kt3cW/YV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1733545848; x=1765081848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U7nbGo2PZnO+Ny3c0y9xAscZokyjbiBwk3tPi7DmO4A=;
  b=U/CVbtxuIBbNQKIPK6zwwawOsFCC2mbS20fipY7e0pbuvmpR8PJhWS/e
   s012IaLMc0EVoLGI3kel6k9fj+tYsy5hUAq0Qt3WBDq9ikk2mrgmRFIMs
   Ud5JfZTamL+/g3UVbD5tCuamUiqkEbDWg5lfmjDLYMGN7ZvxkbvI0Q0s1
   gBnEXt4ZBaP+SUIabb6DudJnUi21TJeO0HQq/ANweYkXNx6hC2DhXJc1Z
   csLcTrViYWiuPk/W7fwt0v6bB3v4SS14Nff8HfxPtpw0UxaChWPwdX++M
   zIN5WU99fKJqOlJekY2FudmMgXnzgWKNVtbH3dDdBwOTBa4523/ZztRIV
   Q==;
X-CSE-ConnectionGUID: CVHJn0EtTsqQZsTVtOXN/g==
X-CSE-MsgGUID: /Wha15u/Qoe4q0ey0RZ7YQ==
X-IronPort-AV: E=Sophos;i="6.12,214,1728921600"; 
   d="scan'208";a="33312625"
Received: from mail-southcentralusazlp17012013.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.13])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2024 12:30:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBR5XxFBqbWLJV0E4JmI6dlSgUh20q1LOEOjHPZg9U8k/7L7sMX9Znd+iSU7OYZT1NKLuWYnA/gSYoMuQuBAF2lsHUOC/cW45m0tv3ykwONumhzZi4qry1c95rpoD30S4c3nBWa2JXDCrqk2zDBM+9XGPQCZ4jPqmjm9WUk+8R7DHUkLIOZmWN6FjThevyfOBt9AtLOun2f6wjWMDDCtBenZrfSvf26LBlbT3FmdJQWuI1ra6c4Dx86Nvq5IlDe5rqCGPRFceKV/bLkNaxAMvHMf0K/+enL/9euLqT8RheBF+1gddBLtuJesq8VBmg8j6gZNbRS18CxNNHZssZJqrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7nbGo2PZnO+Ny3c0y9xAscZokyjbiBwk3tPi7DmO4A=;
 b=nun84atO1pRcQQuq8EIrOjW1JyKF4QoK26oZhMZ9AQxioTuxP6YgmNbjR0eh452xwxa9+eT+/+ql9na2iAyopo6tP3twJHTfDGFXHe1Sn5BTWZPjrld9uwzgkOiWciuRGArTK37uHdX3YqFGr71dW4bVESg23Exuqfa4d2afG77skx8Av3OtH5fv7ZlxXakkC8NoQgOfoWtf4fFCG4NZziZLlW160yOR607fzfxw8i36ZuCFrVncV363DFf/EcpeyxxHYrgv12WLxrg4meuBXcolSYpVA7P7aj9q+DWejhb9jirE6OrbaCNP69KfVvcf3Y4cmjGwJKrUjWfiQPO5Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7nbGo2PZnO+Ny3c0y9xAscZokyjbiBwk3tPi7DmO4A=;
 b=Kt3cW/YVHdHX9CYpKTqh8jukqxopTrl1rNrY8i5uC9gWz+Uz7g7iChdA4TzHnnYNTqLNpVw762qGz+Qq98Um+jV3CfY/5JnqkyIVYi2d0qIPzn997nEBB8BdZU+brNidfCjWWAWeYcUIVlWffkwaSBX068sGIUS4kWB6C/fiQLc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7842.namprd04.prod.outlook.com (2603:10b6:5:354::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.17; Sat, 7 Dec 2024 04:30:37 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.8230.010; Sat, 7 Dec 2024
 04:30:37 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "liuderong@oppo.com" <liuderong@oppo.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi:ufs:core: update compl_time_stamp_local_clock
 after complete a cqe
Thread-Topic: [PATCH v2] scsi:ufs:core: update compl_time_stamp_local_clock
 after complete a cqe
Thread-Index: AQHbR7DIp+fPhIYiDU6zI+EdQDtx2bLaMaOQ
Date: Sat, 7 Dec 2024 04:30:37 +0000
Message-ID:
 <DM6PR04MB6575B5B28B6222253CC23DC9FC322@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1733470182-220841-1-git-send-email-liuderong@oppo.com>
In-Reply-To: <1733470182-220841-1-git-send-email-liuderong@oppo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB7842:EE_
x-ms-office365-filtering-correlation-id: 3efc27f7-8ca6-477b-1166-08dd1677e601
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|921020|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?+2wcCqLCxuGNX/zgHSPuQKFcTHiIdnLG/DfK8xHK77OXHAtcORGzzKSgxNns?=
 =?us-ascii?Q?yla8A1d2mPk/MH24ZSRj5bo1R6Y0fhBkD9biNgYUn4hnnplT7p2R/BUvx7Ya?=
 =?us-ascii?Q?2pGQj3aRh+LJyB2GaliyvjcpbjxlGtWdl23UUrVbIXo0qezy3PmcZP4cnb1s?=
 =?us-ascii?Q?cPpkEX7ZO4Ckm+pBvn0iPweuHs64qGKrBxCgKEhKHoGuU53bQ1oPXZkL/6ph?=
 =?us-ascii?Q?spr6EWjIs7oYVnYcRi1XUMiCGiZ6PW86OcNK0c7J1R89DUjXYIFlib/E+Jah?=
 =?us-ascii?Q?0q8EvTf/LuwiT4OZag51hYeIaXrqKaqD5m7YFRttiSnHubZBtaOWl3ByFsjr?=
 =?us-ascii?Q?e1TbIO4X4QbkDOl81I7pASBkMBrdCRFYlI3EzqPpE8jL5bkTXYfCc/xC8Ob6?=
 =?us-ascii?Q?AADyCWMBZmVTVOBnoWGGQsnydwLz00rR1G6+DGiJR7Gi5FsL92Ywv33N4ly+?=
 =?us-ascii?Q?SWfS2XQYB444B7Lk0v/Ja1su4Np7uqjYfF4MetWfmOoK9YYMHieS7o7q2RPk?=
 =?us-ascii?Q?dxEFG3wmxyPui+R3eiwNLVsVhlS5unI7O7Ga43k5UMAVlruam/EKStR9NxaW?=
 =?us-ascii?Q?lwFAMuBRLUiu+40GtncnyjnR9PslCZoG36Q7jmihFOIN07Y+cSoblVunPUSO?=
 =?us-ascii?Q?S5rMT4LrI5jYyVfgZ1SwAPksfiA7kiNQ5DCUoLdybH+9LJpFTD5YbG6FFj6z?=
 =?us-ascii?Q?7092JWGoGmUsYFpbwOTl0c33UZGnqqKOWb1nGUWIF/LN/xnOFNw/eNAh1ZUZ?=
 =?us-ascii?Q?587eRNVT4VJCbymDgYvShRFpAfnsJoewp1B49afhuw12BcUr//MxltpOTFRI?=
 =?us-ascii?Q?VhEix6HPjKP44UXhofzI2KdyRPRY0QY5qOq6nQXPjh5fpk1b8GBliMTrsXCq?=
 =?us-ascii?Q?E/hGMxi98x4GCKa3wuAKioyctg/MFm6hUNChy5+znrUENqOQwcPL220dLQ7/?=
 =?us-ascii?Q?Qk6x+zMfs9vMw8OPqjUAsQzBlQjfcXhVV1CToyNkpqxHb0jJetP6cThMR5qO?=
 =?us-ascii?Q?QZQ7HPok1d/JfyA1fokWmu17cQPgr3v4XUTxcrxo5ieqZPje2mz+Ni/XEip4?=
 =?us-ascii?Q?2ZuFwl2Dyrhf7eLFH5g7//senxSvN5bpQTen8dFNuS0P7OBTs99enNh42nWH?=
 =?us-ascii?Q?Ld0P1Jo5384DhW5QeHd5mgy6CTtQZ0TNPLG8AkGq+F1XPp2i/KfDU1PFB/KE?=
 =?us-ascii?Q?/B4vc8yie6KblZhBZpT0NbWeNSpbCU6iN+gMYDIxvNyc4x1ldw05snrfkufx?=
 =?us-ascii?Q?oNlTbEftRryi1u+a0fyo4QOPQn3zaYU5drYz6kOaAGrhKIHcSu1ONvjTxsGj?=
 =?us-ascii?Q?oW/h/2eDD+i8vyQThiAx41zXQKY9HQBOJThtgOE/74H8N+5kPl+TEjLLEm5y?=
 =?us-ascii?Q?QOX0b6t7a+lsOnQ++ptVyw1YoxXE8Ew578Iq/+jElWvb176znuXeSaaWRCyE?=
 =?us-ascii?Q?nyCjFeIDMak=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cRz4MiHYwIXnvxwBVH401Cf8Hpjv8XjuNz07xMSwQhdMW0bz69iySDhQQwXB?=
 =?us-ascii?Q?mUod1oUX8acbUsgYFb4XK7OH5u14Chjpa1mycGkuX8QReWtMvNnaifikSuDn?=
 =?us-ascii?Q?lf03dH93+IloD7orbV3QT1kkpAzd250fx+5n+qtyE65hGSI4jq8DQWV5yz3B?=
 =?us-ascii?Q?8kh+C2uH/jHhXXgKxCzQ4LKmshErO4rktsWYYr2HoBOrhabNJ5SQh0DqKTX3?=
 =?us-ascii?Q?R9cpGuCHIqUocHh4ltNljXsShONfHY3s0RGyXVk/SrjE7fzDGxn2MRqgejp7?=
 =?us-ascii?Q?PnzXw9sxM8OXaLhILDhBLFHCg2vxKW8E0wLfF1/CD2gmVsoHJxYscyflZD3K?=
 =?us-ascii?Q?2INJjYlGT/C4b40fanb9JHkc09ZgF9M1CkJpO8SYO8eC3eM+/4KcfN/pr/pG?=
 =?us-ascii?Q?l1FCYVE4bDkbdA0fcT9/BiyMf4l+mc89ozECyBPfDNJNXKOwzML9S++v060J?=
 =?us-ascii?Q?bcRecBhfWVaKI9Ot2xnlom5F7MtVuvLpMpzKjwhkH0F2TDnAscPgXsHdhMIb?=
 =?us-ascii?Q?wVBQIN9NP+tp0ZzX3V3dlum7au5c4+0yXP2N58qjjTGsDshVZsTQFT0VRszT?=
 =?us-ascii?Q?AeqAZmMP5+Dmqn93+x1FuAjclYShzJX2TzMOkgqf+RitPdCPBwFl9DUtDePj?=
 =?us-ascii?Q?9CUgRMx8SNg83EJgzG4FFUxttcTiu0Cg/Qy97rdtBhDsEvB42LGoWo3TxcC0?=
 =?us-ascii?Q?VxbEiJoQfI1XrbM9z15CsYXLTEMWZITHJ51cEHcsn24tI1U5zOFlRjuf3MSS?=
 =?us-ascii?Q?ztdNGaeU8IEJFdfMH2wGVSROUyWSz94M3rCH4UFCabkJxnOGXhGWKK3N1xZy?=
 =?us-ascii?Q?2IrjAE7qzFaVdhc6+3OMJV2AzJ1tGDb10ToKImX4xHOmblmCFslsJ4SKgpJ3?=
 =?us-ascii?Q?+QumCcu1f0rfZdx9HljOCHL5zVqKoQNN3Oe3h5dLfysyr5KueyqDLkX/u06e?=
 =?us-ascii?Q?dFgiAsABDr4NWgNuE/vs9LUENWtFQBhEByhiJC5CFByj+xSEv3B1qgTUvdFb?=
 =?us-ascii?Q?H5LjWLxnIMB+psYTDtaTkXSApZpPelFdPd77gi2PWG+OoGqyR7IkERA2jIS6?=
 =?us-ascii?Q?9evIcFxWjQfgubcvGJ7GVJ8D1MXlZ08fp8Kj3JYzmeWF6j1LR3saC9O34XkG?=
 =?us-ascii?Q?Zq7ufcOco9zYD9TIye+1pEq9i+zJ2v7Cl4Eju5dBnt//lXjiC1ryDB1l/fvb?=
 =?us-ascii?Q?TFeAI0OZZ4O0ESpLz43KsBohmQRVMDOs+tKGDJr/M3iroF9KzFRTjm+UZOj2?=
 =?us-ascii?Q?JgaXrblQleWTQSQ77O8qSW3Qpi8O6RN9QMfLzKWfwpQVlNSrqvM+W8Z4hPWB?=
 =?us-ascii?Q?+GiDUPkthSs7dh1C8ykpl4iccxgdhBuN0AHLa4QePxJoDsVVfEib8A8rnFSD?=
 =?us-ascii?Q?h2BvF7y+u03OlXNWOyA2BKRFmLzXkAM8BtugFExSrkfqyiKwo97ZehQvpClB?=
 =?us-ascii?Q?CQ3A6GFgUfX0nl03mlHKT4Bieg102YskFBgynAs+/sooy7bhRTnQ8ma8Pru0?=
 =?us-ascii?Q?GeU/mW3+MVfwnrY+Epe4AuiXmXpan4Z5VLUfRzezNL4478/BlDU8aH2gPQqt?=
 =?us-ascii?Q?7XbJF0GvKhEypvnMRZtZVwJzeHLPwz37P90Kw83yfIeUYZ/z7NnE00IJw/YC?=
 =?us-ascii?Q?FniRE5dtqlNgPX0/sOioBe86pXcrIarI3B2WD4lb8mWf?=
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
	5WVZDHJgEI+oIjRuA1WpuIxf7KA0gQhmfRR8hU35+izJRjPNPqY9/Zn/6VoKUGULKRJZrAFVmREb4Kyd4AedgWiAFZdbCCtxUdtaIe/TNh4vWR+0bKFBV/FxSvd6d5nnWwy4tN6GzXq4nTr2LwF+2kJaPHJ4ZI9HQgZf+zOSyUeLCAxTfjEUASS7EXdtwV1C6QMk48/eSvRzIRTsxyZNIzpYvTKcaRYAwYtpZW52Azl1dbae6BH2XPjz7OYMyJgfijSIen/huQKkOO7+tmmDT2pJPWtVtm2B5WCswhklcyBXBR7AyFV5L1QTFqa8svSVKAO3Sln2KyC71+l4nL2soQ1zIft26oGkxAG/1LWuCxoNibjJWL+u1hNDbpNnICcBtDvysOnDuAr6DS4f/+Kb3x8zsPqfIQ1C97yeNZJgmFCC/9dh34OlaDvwdbNyDsIbQQRu0jh8RTsiA3B6fpzf2533T5Yk+rJlVHB7K3ScqK4/WM1/eK1Mg0dzRdPCfHT/pz2gqR6Q2ENhfWck00BK2kDbVtgV4dZGb5c+8hljiRnV0oVJnYIc/H3rdaobWc4J+auvt1Ig6FHXmxKCqdVwhNsEAgg6w6Ss9tkv4kG0ZE/XstLHm0T9YyfLXiC7JgxY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efc27f7-8ca6-477b-1166-08dd1677e601
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2024 04:30:37.2119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UYeeRzMBDdY/Q3iix6ZCM8x3v72owSLIGvcON5UqIcSQzc86d/T31KrnR5y00CL5iH0AXL5S8xD+/1uvV50mdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7842

> From: liuderong <liuderong@oppo.com>
>=20
> For now, lrbp->compl_time_stamp_local_clock is set to zero
> after send a sqe, but it is not updated after complete a cqe,
> the printed information in ufshcd_print_tr will always be zero.
> So update lrbp->cmpl_time_stamp_local_clock after complete a cqe.
>=20
> Log sample:
> ufshcd-qcom 1d84000.ufshc: UPIU[8] - issue time 8750227249 us
> ufshcd-qcom 1d84000.ufshc: UPIU[8] - complete time 0 us
>=20
> Fixes: c30d8d010b5e ("scsi: ufs: core: Prepare for completion in MCQ")
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: liuderong <liuderong@oppo.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
