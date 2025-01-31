Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129551B0F21;
	Fri, 31 Jan 2025 12:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738327483; cv=fail; b=bf2kzyyKSEVO4SOj5piPo12ZdRuLPNWnxKlQTfAZjQeSQYNavnWJxdkQxR2J7S0HJSe+FPgk3R6u/zJn0VKivJROjFWMGq71gVT9VdTeOkY80ZiqPQ9kge3E0s0t3nDC0Lm3g7LCGb+fh8zVM9iQtQtuu6FNlhUo0iZqSBAa/HU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738327483; c=relaxed/simple;
	bh=IikZO79EeJ6//pS68mTgxUdV71LeCUqOW2rcBMs8h6M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iqLeUZiFyYQOc6oItM4z2nzqmqey6bjtTa+qfX604nSZXoTLU2sN/eyDLJJV3BbUdjWfx+wkuEVA9kAYxvDYYVzvXybEJCjpmfYhCM3rotPOmwFTQl0g5ocgYV1cgqUPHG0kMmNxcAK04gUWQInLhZeYc+nNTY9vVj8EVBgQClg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=n5u8pw4F; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Y0Lh22Je; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="n5u8pw4F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Y0Lh22Je"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738327481; x=1769863481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IikZO79EeJ6//pS68mTgxUdV71LeCUqOW2rcBMs8h6M=;
  b=n5u8pw4F5D9D9BTW805dHdTwgrWckcGAR4RNgDrO+NKGLnokMroiyj1H
   WyXSytjU/+U4NsrjWgydD1GnsqtbVjhyewAFfvYEHQRd1n73sO/W/nAz5
   K1dDFHXixWps1NYLbQMvJ8jhsHnvWoghd12XSTzP+HM5/FYJnzd/5Q8tT
   IiOdjmJdsjuueK6XuZzOIwkURDFmr6dYh9qytavAMGMdYXVgSneJERybp
   8n1MVesIyoTQMH/4xOGLa2jN7+shLPyFxDIZjByhSI6JVohuONia8HGEn
   rdfh0B4QXdiIxfhsag19JFaUglCsRcTcY3969n7NMVpI6jBcrbxeNEW7P
   A==;
X-CSE-ConnectionGUID: c7wxdUDOQiySTJZ/Hdqqtg==
X-CSE-MsgGUID: LgSLh8bBQTW4g9VZZVAtIw==
X-IronPort-AV: E=Sophos;i="6.13,248,1732550400"; 
   d="scan'208";a="37035616"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2025 20:44:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/ycPg93Xp2gd9plr93Vugk3FQOJbo3n+g0tKlIqAGrXPZ9Ww1poYsiZnBIBmmjn3nw1meKQ555oWdomnHj81z9bxiod7DcKZ/lfT9BcEwEqHBpnrtdN7MwoIfYgiB+PGjtmZJQ8Ck/6eX8CxePZaWf7i18x7wxDHVMg523xn7yTEnGswRvTQWw6Av/0LJQCnsnerCYRTgDQGbJlhZIzGcC7FeXvZMf7zX82nzWqnviJRR0gGbwgBF7Ov3cZQ0RHLsM4YK3uC6zNEaPfvsWp0HxrXLL5/pwZ3vLGezd/VEAgNmnUGM5Ict2dAjZ6lmAhJAJfVUasdt7vTGKQtJxNQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzswtgKWHCoHNwjZrb07amAYN40MKQpRw6if4pQq1Mg=;
 b=ikhgjdxvU6fLcJFiPj6CjYSgzlVzLiesepcyk4nW40MS11cwy0vv8rlYWLJFABTh99/MP3iooXH7ay0LX9QyuemAv4xRbzWRQdnjVL/G+Z4HnwA28U/SATHFyP7dpFMygnmPzFJk+t6ieJclLqcINHzBaz3pUP9ISwzK18P/k+Msua8qjt5dc3GAVRWEyTXtv32b4u+riqoHS5b2hP5uVsxv2vaFLHZo4YpxOteE1yK0P382bT+8WXC/V11YYKVxzNJ6OCXbS7VC95zomO2m+ValtB62FRBAR6/Me4pkgP2psGiBKVAzZWrV8/bzaAanjYYb+PVPSR5iVlBPdw/vkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzswtgKWHCoHNwjZrb07amAYN40MKQpRw6if4pQq1Mg=;
 b=Y0Lh22Jern+plFoc9k6xhie9z61zxBaN68uBZ1doELW0bwxMZzhibznKYDen23MdtIb+yqFLipesWttkrwo/nC78bXgeDkdlhqDjnLATCKfueMSOvNmgo028a6PCXFegRRz4F2qPMEUfHDQ9b+gKlBd3uMlA/ShBopKYyzrcNl0=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DS1PR04MB9539.namprd04.prod.outlook.com (2603:10b6:8:220::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.22; Fri, 31 Jan 2025 12:44:32 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8398.020; Fri, 31 Jan 2025
 12:44:32 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Alan Adamson <alan.adamson@oracle.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v2 blktests 1/2] scsi/009: add atomic write tests
Thread-Topic: [PATCH v2 blktests 1/2] scsi/009: add atomic write tests
Thread-Index: AQHbcd5FaCQGiJOl+k+FSoEEiVwKXLMw2AKA
Date: Fri, 31 Jan 2025 12:44:32 +0000
Message-ID: <l4ennpc73pgbvxs53jeqj4cxk5nwctpuotbju4kmi2h2jmpkbq@ibdhzbuv4fxy>
References: <20250128235034.307987-1-alan.adamson@oracle.com>
 <20250128235034.307987-2-alan.adamson@oracle.com>
In-Reply-To: <20250128235034.307987-2-alan.adamson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DS1PR04MB9539:EE_
x-ms-office365-filtering-correlation-id: c3e92d88-b3fd-4045-28d0-08dd41f502be
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?6uWgQsXhrSRJKVYv19tyx7NKntmZYFh/Dw0MxKX5XrEaC407kS48oG3ydoEZ?=
 =?us-ascii?Q?QNulsjmLBOPWftKOuP2djFCsvqgdQamAphhw+f7pA4dVHBug5Lphcp0WmMAt?=
 =?us-ascii?Q?CA9bdefjtnPbsqu6l1hXmYd2cCQYqY+3QTUHW3TeZNIZ/FRnHFj3h6Gp1dlJ?=
 =?us-ascii?Q?0iowmoz9IQgwQSXYCQ3Q46fux3AtB9tFLwtoFwp6fLKJk1mlheTRDwcw9Ff7?=
 =?us-ascii?Q?/d2TGyt3uP3G+kwtU71dmZ4ktn81tjOy6NBgj2MNj+dj3nkAJa7pDYVBO1lp?=
 =?us-ascii?Q?br3WNqkxRmLx1e9bfrE4U8mKuFDIoyOdEBsvlmo8NVLhCSmvzb8NcHcHNjU3?=
 =?us-ascii?Q?jXEuO5c+aX6oosQN3VLM3qLhbETGzST1HwMxEhT9I6r+EAi7CUZuzgMbNTtJ?=
 =?us-ascii?Q?jzbs9OQA+RiaWTLAW9E4htxDREi1GYPovO3F1RANiuOV0ydPL9iVc2yaD4Yu?=
 =?us-ascii?Q?iNoiBEaLYjnT2yargC+Ir10qv06PPUSGEsHx7LA+funyXVv0Zu8q370yqgoZ?=
 =?us-ascii?Q?BPvktdsGq9pSqu7eRSmwvBCu1ni1URC9+64VkuXFL3WTvyGErgCX6ouXjh26?=
 =?us-ascii?Q?UHKZYVu+e25a+PfBpjQzfEYoWTu0v0ElhqubFsxmg9Exbu53rmSiz+IPjVp6?=
 =?us-ascii?Q?8HkIPrWD8PZkYS8tmtbzmNvm29jCbrtNt6ZMyB+Xd5lSr5xs4SpUoBAjQdRG?=
 =?us-ascii?Q?NCojOloowcOTkrFwQDKu+jfYfP5SRrWzLhUr+K5r7DIiKIkZZJLNfSVOJYOV?=
 =?us-ascii?Q?As23wkgcEj5R7PSut7i9IOlS/vRZm7VY/0WzL4v+Nc/zfQQ6iyGwgBwrHy3C?=
 =?us-ascii?Q?mo6aOcXx6ZTO1sKu1OiFDJjz/vzaZOIcAUXEqsXReVN0cEy0PD9X/ttobEX+?=
 =?us-ascii?Q?dcMjORf2Kja6gjIhAcpVA+mOwM8GYPTPQt5pdkG6bsiJO+cVs8ToVzXZayK5?=
 =?us-ascii?Q?tV25dUpvXyMx9YUXtqTzqUtQ2E4vXut4gacunS1HHGH8iTdPxBm+stEpejRl?=
 =?us-ascii?Q?nFqsMHbWkeIwta05BqqkGdFJ/1+ozlyxWwuEDrsvijGobNArDl11MT4p2JU+?=
 =?us-ascii?Q?E43XKDhTTu6RhfXY3Z9oABXKdtWVJOOZSKRyOHlbiUvWx0baNZHmPCvx1W/Q?=
 =?us-ascii?Q?ybMU6hTdohTdPyFYnudBtK5uXNchBIDBN2QjvLaH8thCncETEMIKYarEpAKq?=
 =?us-ascii?Q?wwtXH1D9Q/pNq3cbS+v+QP1hBa7pMURcw2aMPS1bS73eN7ItO5lBGxlfPcn1?=
 =?us-ascii?Q?iRvhaFj7ncInt3lU7JoN0ZdEecqf41bBXVorQOYKwEwY7aDUMGGoMwmIxUVq?=
 =?us-ascii?Q?jgivt+gGCSXnLW3Ew/d7sc8wsNyn70JpXoiqFXP8x28Dhkfg2FQ7Lxl9UAak?=
 =?us-ascii?Q?AXaOeVXx9FImzxVx5m+yu8iXw7VUeXti/Yt8JpGPrB08rQVNYg/ZJxH6LS3M?=
 =?us-ascii?Q?nqjctbIBecTlG40ic0kwOdyOezyE/1QA?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uNcZAsYNDam5BAZ5SpD+fzjnhhMjBTZQw/B8pqoN5hPonWIMLThV60gU32D3?=
 =?us-ascii?Q?U+dCF8dl/gxHmvq4ah2jaLCSrrWPkniFIxDwyAaDMvRh539U77jEGbjfsG6T?=
 =?us-ascii?Q?x+6cmJSkyk6gCpTjzQqN3bITnJqUUQPKysjtMpmsPU2rWjL1mkN57WSFw6f5?=
 =?us-ascii?Q?9sBp4Qe97zGpGbyg+wDs+vZl5DomXnq9KTdUXn8sQQohBmB/Tu3GDZgENobC?=
 =?us-ascii?Q?b6pKENojcWx3K9dg1QLaMIkg2JRlFoMETs5kaoEOr9GSmeLTKzYs1IufYlr/?=
 =?us-ascii?Q?+biX3axQMq/iZqQgRTrsVFpL81i3dkcXo3PgXi9ZYcjK8zlIwzQ2NFSjD4+j?=
 =?us-ascii?Q?JUutxuEFVjhfEaypdVTxK70ML6pTQm9qIqYXOTCBz8l2PIjCP2McXsRETFIB?=
 =?us-ascii?Q?iztNfjVXsItOUrEW7sBz3nVZm6RGkMyHd8LhCwe6aezrOL2BgfFzbxX65riF?=
 =?us-ascii?Q?PIOMEBXo2HlevsxNP0SSYz7pP9cFY+A+ZHM7+Xyd9f7+mavD3PsTCcRRn5sO?=
 =?us-ascii?Q?FzFcrNZPi+oZ6NKUXwyt9SAFYFcgnR6MZYhSiqPoMRsq6STj/YUYlzJGxJmz?=
 =?us-ascii?Q?xRBNnNecrHj+O76GthwIYb/K6kpm6fKX6na/7taWywfui1S/vDbbsLIK73kw?=
 =?us-ascii?Q?kfAlBFAOzdXFAf+WQvLgQ2NDqw3D48dpeLhBw5F7OHLUuYG3dwN0eUM8Teh6?=
 =?us-ascii?Q?nR6/RvEC3i3Yhzp7axWw4bAye/lRJVEMpizI/WZifIkYJdDykXSvX3dw2EBd?=
 =?us-ascii?Q?DyQgVN6rVzlZLWz30inm6EGMdJG95ptYb9n9JbxHwFtWFqdaVmGBsbc0lT3P?=
 =?us-ascii?Q?V7hV/omr8Z/bE3bVzQmadGa6bGb+uwo4J7tL6HRRrSad3NmMyxlNkNZtXlU1?=
 =?us-ascii?Q?9RUtGTyUtDXo49vTpsdUT74rdNPN7w0FokEqh0QSEeAVCYgejFGwkr7XgZXh?=
 =?us-ascii?Q?V3Q9Rt8LLq1ALYleRyEweFrHMJazmr9izfvNegaI7AF1h21diSWhclG5y4+q?=
 =?us-ascii?Q?srmv36qt0Siz4ua9ST9z6z9D8ix2rs5/FcPJDc55yK6nYa0nlJFu85PrFKUU?=
 =?us-ascii?Q?Rwy/+KB8gI2AdXX+48JE5SbtGAgqfjDMhzO0yr5p6tFqK/ahR00osRXfqcfN?=
 =?us-ascii?Q?jJa02M8+u3pBEmNczMfTgLQygSc7DAkfhfPADwUJbsu2F2Bp8O2qSMDVo0zX?=
 =?us-ascii?Q?rfcMN2jVEshCMLxezfRDA6yl7uLN7yyVYQFz2Jv5rTvv71MCUvqS1DUYE0dX?=
 =?us-ascii?Q?gOAWGtbow/vZUwjipBDMU0j7p8p768gb8Tue+SRRs1GdMlfTi4ygyzvQPcpp?=
 =?us-ascii?Q?SBIeQrS/BRu0v2S7OuEtIl9yDephHyY2KrLadfIncJTtSTFocehpEKJiTeQp?=
 =?us-ascii?Q?FvIIPSj7Yx8VQi77e3Jdrrj+xHnltDpB/Dk2YSVNEyljPKt6Q7OIXeR+R+Pt?=
 =?us-ascii?Q?AcVJ0rlwje6FrLLJvShBdOa95SMt7AzX0Qq1MOEg3+A/jeehGZaxcL7iZcsO?=
 =?us-ascii?Q?Uo8gZzqTN2aImu4EEKyFW9dhncyOFmVvQBieYXrMyD3g7Cwc/bV3oqYEpyPV?=
 =?us-ascii?Q?b/XydqM5yOxfY1vyJGiogM+jx8JNs0iCCDbkGmLjTvKojjyySXLHhOtu+/uE?=
 =?us-ascii?Q?Caq9b5RxqPpGCeXtE4+I3UE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A96FE7D57756D54F953C4D3A320EB348@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zchQxtsU4TaAxwoj/fS+E7B/ZBI4xUFJ9mGLRHlhh2suymmK18WpLYTvV6I06bUTb2P0Uj0knRVC/r5j7xrUD6BBTNwCr6w8geZgr8vlQjn/r0/TUfC83o+5JfdjvNmP2RRFs8iMouPgHfleVoKOfwK3HKFcdih0BC6qp4Ot/XJnjJgmx+7rgW1uVQhViFdFGtrX64o3thyv5hi8x3rA+2EF1x2Rmc3Vj4acZX6mt6Y2r9rUJxzoYC8Qy8f5tAddsXxpagglGX7XUudp7h1GXWcHKr70YPTbRUlqqlbqv7G7z3dZTOq7xELkxA85x+W5yd5icn6Xsb1uSH/1222VXma0vjshfPGtDz1bfjbFnNa7vLJQe4QLnyrcIoWKe7PwGP+JdNfYw42meHX2pH4jYKDgP3rY8JZixcWdJvp5TARTXuy4bWwHKw5F9T8tt2heRnZ4LHCf9/a9UGei+mzrWiVTBSEr9NnptS3ODM8bib41oiyKEpY5aRJgEHiGzVrdJGgeN7NlMGU+zuy9tMbLY7IgWTnzpCgjeX5kSlE0KkKsoscFRmRgzrq80/+Nlnfot936rJugkc8Ag1/6Hb1EvyE0stUqVKrSTfGYHfsE4AZtoWmF7YC6tIRCV+dgHYvj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e92d88-b3fd-4045-28d0-08dd41f502be
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2025 12:44:32.4650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LhZ/dp5M89BKLUkRIx0H9CjTVKEc17K0RHG6D7nASbNqLzRyGzkpPhwkf49VJ+7hfVolm6ycfmQeIUAcmMD9hRsH8if6k38Vff5ig1Ni66A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9539

Thanks for the v2 patches. Please find my comments below.

On Jan 28, 2025 / 15:50, Alan Adamson wrote:
> Tests basic atomic write functionality. If no scsi test device is provide=
d,
> a scsi_debug device will be used. Testing areas include:
>=20
> - Verify sysfs atomic write attributes are consistent with
>   atomic write attributes advertised by scsi_debug.
> - Verify the atomic write paramters of statx are correct using
>   xfs_io.
> - Perform a pwritev2() (with and without RWF_ATOMIC flag) using
>   xfs_io:
>     - maximum byte size (atomic_write_unit_max_bytes)
>     - minimum byte size (atomic_write_unit_min_bytes)
>     - a write larger than atomic_write_unit_max_bytes
>     - a write smaller than atomic_write_unit_min_bytes
>=20
> Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
> ---
>  common/xfs         |  61 ++++++++++++
>  tests/scsi/009     | 233 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/scsi/009.out |  18 ++++
>  3 files changed, 312 insertions(+)
>  create mode 100755 tests/scsi/009
>  create mode 100644 tests/scsi/009.out
>=20
> diff --git a/common/xfs b/common/xfs
> index 569770fecd53..5db052be7e1c 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -6,6 +6,30 @@
> =20
>  . common/shellcheck
> =20
> +_have_xfs_io() {
> +	if ! _have_program xfs_io; then
> +		return 1
> +	fi
> +	return 0
> +}

This helper function is used only one place, so it does not add much value.
I think "_have_program xfs_io" is enough for this patch. I would say null_b=
lk
and scsi_debug are exceptions. They are used at many places in blktests, so
they have the value to have special helper _have_null_blk and _have_scsi_de=
bug.

> +
> +# Check whether the version of xfs_io is greater than or equal to $1.$2.=
$3

This line should be removed.

> +
> +_have_xfs_io_atomic_write() {
> +	local s
> +
> +	_have_xfs_io || return $?
> +
> +	# If the pwrite command supports the -A option then this version
> +	# of xfs_io supports atomic writes.
> +	s=3D$(xfs_io -c help | grep pwrite | awk '{ print $4}')
> +	if [[ $s =3D=3D *"A"* ]];
> +	then
> +		return 0
> +	fi

SKIP_REASONS+=3D("..") should be set here, or the test cases are not skippe=
d
even with older xfs_io.

> +	return 1
> +}
> +
>  _have_xfs() {
>  	_have_fs xfs && _have_program mkfs.xfs
>  }
> @@ -52,3 +76,40 @@ _xfs_run_fio_verify_io() {
> =20
>  	return "${rc}"
>  }
> +
> +# Use xfs_io to perform a non-atomic write using pwritev2().
> +# Args:    $1 - device to write to
> +#          $2 - number of bytes to write
> +# Returns: Number of bytes written
> +run_xfs_io_pwritev2() {
> +	local dev=3D$1
> +	local bytes_to_write=3D$2
> +	local bytes_written
> +
> +	# Perform write and extract out bytes written from xfs_io output
> +	bytes_written=3D$(xfs_io -d -C "pwrite -b ${bytes_to_write} -V 1 -D 0 $=
{bytes_to_write}" "$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $2 =
}')

This line is lengthy and hard to read. Can we split it with \ to fit in 80
characters?

> +	echo "$bytes_written"
> +}
> +
> +# Use xfs_io to perform an atomic write using pwritev2().
> +# Args:    $1 - device to write to
> +#          $2 - number of bytes to write
> +# Returns: Number of bytes written
> +run_xfs_io_pwritev2_atomic() {
> +	local dev=3D$1
> +	local bytes_to_write=3D$2
> +	local bytes_written
> +
> +	# Perform atomic write and extract out bytes written from xfs_io output
> +	bytes_written=3D$(xfs_io -d -C "pwrite -b ${bytes_to_write} -V 1 -A -D =
0 ${bytes_to_write}" "$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print =
$2 }')

Same here.

> +	echo "$bytes_written"
> +}
> +
> +run_xfs_io_xstat() {
> +	local dev=3D$1
> +	local field=3D$2
> +	local statx_output
> +
> +	statx_output=3D$(xfs_io -c "statx -r -m 0x00010000" "$dev" | grep "$fie=
ld" | awk '{ print $3 }')

Same here.

> +	echo "$statx_output"
> +}
> diff --git a/tests/scsi/009 b/tests/scsi/009
> new file mode 100755
> index 000000000000..7624447a6633
> --- /dev/null
> +++ b/tests/scsi/009
> @@ -0,0 +1,233 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2025 Oracle and/or its affiliates
> +#
> +# Test SCSI Atomic Writes with scsi_debug
> +
> +. tests/scsi/rc
> +. common/scsi_debug
> +. common/xfs
> +
> +DESCRIPTION=3D"test scsi atomic writes"
> +QUICK=3D1
> +
> +requires() {
> +	_have_driver scsi_debug
> +	_have_xfs_io_atomic_write
> +}
> +
> +device_requires() {
> +	_require_test_dev_sysfs queue/atomic_write_max_bytes
> +	if (( $(< "${TEST_DEV_SYSFS}"/queue/atomic_write_max_bytes) =3D=3D 0 ))=
; then
> +		SKIP_REASONS+=3D("${TEST_DEV} does not support atomic write")
> +		return 1
> +	fi
> +}

This check in device_requires() looks exactly same as that in nvme/059. I
suggest factor it out to a helper function in common/rc.

Other than the above comments, this patch looks good to me.=
