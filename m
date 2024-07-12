Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F79D512;
	Fri, 12 Jul 2024 10:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720780418; cv=fail; b=dEzhLZgZYFB/IM34nQeSTfyW8QL+v4LOG158wJCGerbxzL9YCTQ7zLsLLBsXph82qk4QN8z7A88vEFV/YV5MwtDrXxY/e/DZJn4HuFsYBuF8WzdtDSMh6tCScZn0/OezpUiF2sE5/oNhz4LGugSAVAwceW3kjJhdfW4Fv+T2wDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720780418; c=relaxed/simple;
	bh=HySETp0jHzsCsTzFoCXLzD/dibR1daB8IcXhIhJ7Bvc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kg5gh6dEG+NODOYrKaYCZPNcy4YZ+KijqVJ9L7GVM1UVOxOcUMQj3RhDA8H+ivDNA2rkdn5ZKhPpP1pntKYqJzPBQnGlfrQ0fEvQRRX1QZmgYACO1CkSIS/CHKTQx2olQnjT6h5wUs78GOPGCaYv9TDHCZKOAezQbd1tVGnZDuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=aQGwG8ZN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yJMp7+tY; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aQGwG8ZN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yJMp7+tY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1720780416; x=1752316416;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HySETp0jHzsCsTzFoCXLzD/dibR1daB8IcXhIhJ7Bvc=;
  b=aQGwG8ZNGO83UVK8ogmposaNfOV7LKteXHXe2gxnls/OrbVPgDY274GL
   fXZ9DZIlTapw4YYkB+WM7FM4akd3tRBO9wmQnJjcxmXldmS4YdA2s6L/F
   ACgT3mEg5sIWc9x2bLBaYbDlcNynfTt4errxVOFtNsPI097OMa67uQsHk
   bbzQkp92GWpeAJr7THtWO2vUW4k3S4nj1cVKLdJvlSZFmAGTrz6iJyu3q
   KV6k5hw8oqrEVgN2J5ZExJ/VN27ONBCCzM8TdpnY6kgLotkld031ch8k+
   2mO1KNE7gdYhqpushAYyiCLhup+gncx6hH4FR+lqOiT5A/rp7Io3JDrvQ
   Q==;
X-CSE-ConnectionGUID: l77/eIFHTIKcKkdyYW/esA==
X-CSE-MsgGUID: B7MzdXsaQR+vGw0Y5g0MPA==
X-IronPort-AV: E=Sophos;i="6.09,202,1716220800"; 
   d="scan'208";a="21823571"
Received: from mail-centralusazlp17011031.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([40.93.13.31])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2024 18:33:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vczsiyL2C1oI8hskjWf8XcB1zQaEfBN4b6ghu652W4qEdheppKLHzFoMe4FJPMC/lO8VTUWscbjg/9edv+BYcXD3P8NFWKRVeMw1g2aq1CuBUrGi3dyqUhz/jUg3XG0fvdTdhG2KHtl16j/l+xhzzuGf8j5tjad4dR1zivvAibR+ONQd+E1/jcO8bIftei4XQF1XrlI2sOhaI6klx3p1c+6I69n78V0C4R9UDCV/7gJf32gnTn/PnkXi1CiMnBRiFvxTknmgIhkMSMy7umcN+dmW1xEyo8VSw0LJAKnsHH4Tr8KwlBeEMdDT8qNUxV5RqMj8IKHpUF6eDh9X08AUEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auAw/hFB9NVHhC3vdLTQmRhr5RvZUoqPMjSsN6ZgcLc=;
 b=WdWHoPubyFjEel/kE3sNNuyLTh1yKkvinQZ7laWBsLyOn4yb4WOSsaByUROyNSoOIvQz5idEj8hiYsgCgKd+iv4cZhRPRpwEcEqhSODKo4q2/tkFiexJfHcbuqRUvJn1QWoClnXkPLzE537iXKSVaOhearZnxIQDH8u7/mvrmIPOyjcRfewLl7EuRRH9u5v7ohExzCbZ++ab5zvQnLDRVxxKoFZQdgd4mjkKFy3hp4ym69jvEeuP4beA9gjrVJBEEg+VDL+T2fWmB2CDp5I2x9FrkOnP6Tp8d/7p/VJS/KoLSMRBB/cW/TlAye1Evl05Xm7LEHXZPBxUFAYonY431Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auAw/hFB9NVHhC3vdLTQmRhr5RvZUoqPMjSsN6ZgcLc=;
 b=yJMp7+tYDmAf/qJX5n8zsdVZqUFRneyhU5FN7R7FN0pD0HXappPv688IrBB8bwu00lTABlasRCadVFIfIsVD9TlTlGiQPkkvhk/uo84OZKMnV5EMblTm1YhD3qiMrKc+iJg+qDoYJzpAxqMRbUmQ6aKG787D9SpvGW/jNZOtH4Q=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA6PR04MB9189.namprd04.prod.outlook.com (2603:10b6:806:411::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Fri, 12 Jul
 2024 10:33:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%5]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 10:33:32 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>
CC: "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
	"alice.chao@mediatek.com" <alice.chao@mediatek.com>, "cc.chou@mediatek.com"
	<cc.chou@mediatek.com>, "chaotian.jing@mediatek.com"
	<chaotian.jing@mediatek.com>, "jiajie.hao@mediatek.com"
	<jiajie.hao@mediatek.com>, "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
	"qilin.tan@mediatek.com" <qilin.tan@mediatek.com>, "lin.gui@mediatek.com"
	<lin.gui@mediatek.com>, "tun-yu.yu@mediatek.com" <tun-yu.yu@mediatek.com>,
	"eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
	"naomi.chu@mediatek.com" <naomi.chu@mediatek.com>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v1] ufs: core: fix deadlock when rtc update
Thread-Topic: [PATCH v1] ufs: core: fix deadlock when rtc update
Thread-Index: AQHa1EAMhMEqtVpRCkuCtX1cIaukurHy5Cbg
Date: Fri, 12 Jul 2024 10:33:32 +0000
Message-ID:
 <DM6PR04MB6575B81B788F260A8C640684FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
In-Reply-To: <20240712094355.21572-1-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA6PR04MB9189:EE_
x-ms-office365-filtering-correlation-id: 1cdf8179-4f9b-428a-f007-08dca25e13e3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?uXIM/wqknuoQGJN+HjvWxdO195BteUNAazhxHTl2J7/Sz+RllZXQgUL3tx5U?=
 =?us-ascii?Q?8cnpygRPicVdBMx8BYJ+tqBhJRAkWCqdtiAkaZT1KYkEh+ZqQgLQ7VGnpe86?=
 =?us-ascii?Q?HcL49ueFT08181DNcCGH9D3HotlJJ8+eLZwPE4x6dSYp9KO/M2jwdZR0hCw0?=
 =?us-ascii?Q?sddGWA8+4AIwLVVZta1pe4ZiUf/sHE5feoZ+HQAySbTyB2/aFY8XkDMnS8Xe?=
 =?us-ascii?Q?LYHxaFqMzqpkRDjlYM7F832vZs3f/P6hC6t+DN6fc14ma4PVnD1g0efrZAy+?=
 =?us-ascii?Q?qoAcogrFKDLeZd6u4pPd2ADePNBBZJyAYjx7o79DTMStCS5JQjAy1V+/0CVh?=
 =?us-ascii?Q?ojklVaOMTIaUXtFF1q1uoG9FvOx6AacSqrNMtaRfEm5prvIoksPehY1N43pn?=
 =?us-ascii?Q?9PG3U8VD1P+S5N78OkEK0TXPkI2U9nZoXQWL0rTWVZkLkJK6YXFo/OOvpi6n?=
 =?us-ascii?Q?r7Hsrm5WzRgcva+Jj4RtG4XURSho4HDxnq7LVf2pveVnPHGKVOfxaKllrlb/?=
 =?us-ascii?Q?3aSCvD/n2XR0JrkOVOYKbvtaF0ce/Dsu/jnByjDKTScgCNSVEgkeBdmB6P7o?=
 =?us-ascii?Q?8J62XtO+Xuym7PbMi1Ob8luIh0ZNtoZF/b/nusIgpERwAoQxgrZrVSIgJ3RP?=
 =?us-ascii?Q?uF4mBn5rGNxlGIQOYRhCWP8IjF49g1uLFIAEi4lJ6lQuPEXtqNqdQ5bIJViy?=
 =?us-ascii?Q?m1Z9QW4pKEcHFpqHVZfhcYRBAHXTheC9h+pmKQ8DYIuUlQG7FFkIimHTddnB?=
 =?us-ascii?Q?gAbOwtRAhxwozGZrUijE0xGzAVoIZIh6Ipf3uSGpP0qFvp8Yur9PoxKFXQbW?=
 =?us-ascii?Q?6WHnXUAdf1biB/uGngB5RXfh1ev5zMBQy6fRNr5Ud1L2wtAVdxAF53sh4s6w?=
 =?us-ascii?Q?dXt4xxNsA+I6j2pivEHIf/4vRrJGMBEXX/pHd/Ghc762/KcJpjCX/Jx1jZlE?=
 =?us-ascii?Q?lraC+r/39GxVrIQCSEkAPGrOeNc4kkx7o6iJdk9M03xowvTwhIidng0MP7Y0?=
 =?us-ascii?Q?LBG4/GmAjFpJPI9x/SQ5zk2yTykqi/QaMktqJRBPvZpLhrMFWkkBnsQK8Wrk?=
 =?us-ascii?Q?5QqkGKb5rx1oXR0wad+9C1mJ7W2TQsHJVxyOkxu2O9kvlyjYbcW0Zp8ptpes?=
 =?us-ascii?Q?PkuNory1oHyUO9ve6JSY00jLyVOmJcGpCDS4OU3K4ehdhf0hCzlO497LSPgN?=
 =?us-ascii?Q?+YAl6fo3VY7r14IdPvcDk4WcmKaL5EFATPA1GWSmAfwRP2V0PhVu+YOOnQ7I?=
 =?us-ascii?Q?OKI97WeJst42mnRex6vIHrfP2qbAs4XFHDe3MDlkC14+tX71zQQPp11DKk8P?=
 =?us-ascii?Q?fE362vVh4gruzGS68wU63friO6Gfzqcy+XCPMBH5GVcgVV4PQ58iSe5PPdJx?=
 =?us-ascii?Q?HajTAQD05QdH1eHk/NhVh0fBwMva1QAn7RciJhcuk73qNIXF5Q=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?RP934v4C+cNRy/maj3nPW46YWS8BP9jPei+sO2Qf6ta8nPjpaDb7nvtTQ2XP?=
 =?us-ascii?Q?A6g483SijArF9gKrKA/5q2MPZlcXgMVjqv5+6HAHgCXCcvHwad22XTv8yveZ?=
 =?us-ascii?Q?wCd3mPIZRi64TxqvyUxzZHVPTdaJELq4cTwfEtUE6ODGcfNjoitpPQqe58Vj?=
 =?us-ascii?Q?iTFhndtGnaz0eU+EVrzXhcDNM6vKqxdKG6TtfSXerifllNx4Yqdd9celq+x8?=
 =?us-ascii?Q?SqKa+M0Cp6CAIBtK0dZ4TcQto8bRJ1R/LuD0rAB5U8Fhl4D1qRoHHnJjSLr8?=
 =?us-ascii?Q?ro/9I9JdUzqF8e8y6917dzSpQem8PNxU3wQsg4wOlBgF6NGIgjZi+4GbPjg+?=
 =?us-ascii?Q?GuivsGtiLL+LALkLzf9DznDLEXcO+nwt0yM2Fdkvlly+oKatIPOKyPaNhkv8?=
 =?us-ascii?Q?NW5azVUfcOqoQS/ud7VWNrcDybcc1dR0IjcSn5wvzqCdmHSzEy9DBUN38+c5?=
 =?us-ascii?Q?qvpVKDTmjSZx4wDGVhd7/NfyA6i8G+MNRI0ck0lYl3iJ8b3ecrWj8p+kAG3x?=
 =?us-ascii?Q?4tBdfLFvRpTy1LeXIG+gUaYf43k1K+0fUDQbwBUA38bcYqdh44/QTI3y7/Y2?=
 =?us-ascii?Q?oRRqF+ywWXgABTbnwscbVRyRwx5tHziwUd9flP4HiUnScFcXxd6Xn+oxYzzD?=
 =?us-ascii?Q?TnMRKvffxWOqpX9a0p+ym58Yvy+M0qCtM3prbJNbkk7YXdolRvVN0zb/awW8?=
 =?us-ascii?Q?TIbTP5ic1hCtC3+M6SwMc235zte8TSA0YaSvo1aNnLudeUlYqSrWYt8GCVc6?=
 =?us-ascii?Q?0mSik4Q1xdZGbR0vPbBhPPZ6Cvqglu8D/Y6927iPndUnjrvGcoAEW3e+NiD2?=
 =?us-ascii?Q?Cv4KrfETchOz+GTfAsjjuLvrk3Lm3SrfJUDEkG6sxCFZlWNHjfSr/BxnPCDB?=
 =?us-ascii?Q?hkkb5F5FK11AsANy4UrbBR9HIZl4OoFPwjrRB5q+4l0qWEuePlvnuHgUiEZI?=
 =?us-ascii?Q?jxFzfPAVagCjhCpx4QDMHabf2nbNHTkTXfFlUxwff80bdM3byRNwC7iJZIke?=
 =?us-ascii?Q?I3dhcPdkVVq4FkIFKLXSmQ7jz8DvsPFyO/taGSBuNSuWt8p6jD+J5Sp3bcwy?=
 =?us-ascii?Q?J+9nCk7I/wY5QzFciNBaFcHy1QGpnAD1HWTbnFqnsdCQLydYigcnku9Mu0su?=
 =?us-ascii?Q?Zrfliuw5pUISksAOmB/tsADqwJe1ubGdXukRK9Lfeqk95XYz+azlRTEkFMv+?=
 =?us-ascii?Q?ttfA5Tg6sWVAWEcaf0RbqQhyQ67rx5QoSj5b2g8nmcds1TETtrTO5AgPITZe?=
 =?us-ascii?Q?BjxfMcIGjr2xry77/K/7K9lUS/HJ/uBCWLqjMnyKUqDnVPKQi0m4BCjTiCba?=
 =?us-ascii?Q?ZI99v8SiuTO5jpq7NwibCb0lr0OWm4OQYtP+ZLvlTMhcFoGhR7MSoPCHOABi?=
 =?us-ascii?Q?kqNpWtUKnCdegRPx3m/yi1PVmecsCr30FB3INs0zvfbOKFqxBMJ2tdXmVjKp?=
 =?us-ascii?Q?OsJbXhjaVR7eTzr85gUW8jJZe5m1Z1SgYXx4e6ZPw/nhuKVFYhAwqoeHBypM?=
 =?us-ascii?Q?O4ovOn96CB6+EpJ3ynMWp+ij8mvM3hBPOfAa6oCUR+B94kIuP07g1y0Zx6HG?=
 =?us-ascii?Q?Co/dtLHJikUNAKV1lIlhy91x+cuFC+yZlJC8R1vsp6144foTWptV3k7CgcNb?=
 =?us-ascii?Q?8OgLYiWxQnDHbiS4A8cqjbJcdysjJN24FzlmFoFhp2yX?=
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
	P3jKkucKYXrJqnBved8+G0WCW/XMsTI7Syk+cikvY7JQRdseE2AsRkc8TkqnZo46ariVCyHseMhUZvcHemcKvQUyDbthfs72NiyTi6eCXrVAELPRUBITn5q7HI43anMyeQaha/xSS50itiwIHlVjnIqNuuN0fltVDCATMKRFB6JbszUFzQ8URoOqlM43T98b2jwJI0jJ6LNKtF/dp0ngXagQxHwd5bEl8gVOXlLtwzH2Sc/6+r4Nrbpe4VFYtP8eguF7Vd2SVUPZFDftocBDi/dCx65iy9GKZQUP7mTa0eTTHOwH9V4U6p9Wdo5qM5SiauoMcwg97/ajlaTmKiqgvHRKLFO7JpmIpoohvvbyGib1VYEdUAJsyLjcrmnlW1CYIRhAPecbIvUL0rqHdqSKUxoGvqYdlH3ZkFghgehVH9byzcIeH5Cr8urhwJaPtVOSvVPYcX75Sb2WcO1M6l2Qtq+tAs9a6aMmBZ7dToN/IPxIUkz4CogaFaYGSm5d+eNqou9hDe3Dx39dq7fCeh8EMKAZquU+tEcY9uB+WpM+Zka5ebhBidlfHPlJjvT0B9iz6wGBmEMvvwLZhSrCRwE5smopkHeEpx9Lp1MwN6ELaHkJupYhh9ugBOfgZOVid6W8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdf8179-4f9b-428a-f007-08dca25e13e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 10:33:32.3697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nx9xlcv2jDdfIalOsar4xd2i8ccBboON57USJ4xTQQJWtzufNvY8qCJT05U+3Bl7Tyq5+8xE+UpdlOxb0sEDSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9189

> @@ -8188,8 +8188,15 @@ static void ufshcd_rtc_work(struct work_struct
> *work)
>=20
>         hba =3D container_of(to_delayed_work(work), struct ufs_hba,
> ufs_rtc_update_work);
Will returning here If (!ufshcd_is_ufs_dev_active(hba)) works?
And remove it in the 2nd if clause?

Thanks,
Avri
>=20
> -        /* Update RTC only when there are no requests in progress and UF=
SHCI is
> operational */
> -       if (!ufshcd_is_ufs_dev_busy(hba) && hba->ufshcd_state =3D=3D
> UFSHCD_STATE_OPERATIONAL)
> +        /*
> +         * Update RTC only when
> +         * 1. there are no requests in progress
> +         * 2. UFSHCI is operational
> +         * 3. pm operation is not in progress
> +         */
> +       if (!ufshcd_is_ufs_dev_busy(hba) &&
> +           hba->ufshcd_state =3D=3D UFSHCD_STATE_OPERATIONAL &&
> +           !hba->pm_op_in_progress)
>                 ufshcd_update_rtc(hba);
>=20
>         if (ufshcd_is_ufs_dev_active(hba) && hba->dev_info.rtc_update_per=
iod)
> --
> 2.18.0

