Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302A01F3B98;
	Thu, 12 Jun 2025 21:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749762507; cv=fail; b=MHxd495x63F8BGm+JTkqGPvDdkTS/hYX5Cfyq44AKeLwTttucS1hHmTP91zKejYCIjZl7U8eKUiULEyvMdhAgjEsxoIdGM6/+6CRY3eHKGsmAJpWw4X8oUVaISGXDY2GU4YApg0xOsdJspnq9av+brhUGnXXrfzYNLpw6Om0V4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749762507; c=relaxed/simple;
	bh=/tkC0n2xM7b3iBaswrPKH3698u1ld1GvQLMsKMhTOJs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KdA7yu0NivSMw7puZnpehsXu2rS54pjkyutChw+zDodX+N2nvHACO2NoA1wdi9B0QsawIOMxHBpWqaI5pUmtqB77t2PqdV6f1DjZVAddn+6x89sI/XGgi9RpxW8tLloDvEHxTF5kScV8Ifx1HwSeLsLuOoAjEZ//w27yjR2oz8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=kxmdzP0v; arc=fail smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="kxmdzP0v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2927; q=dns/txt;
  s=iport01; t=1749762505; x=1750972105;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nKMY+o+s4akthpU9XBTiORGV6RD4LQlMJ3sAH/UjsxI=;
  b=kxmdzP0vYZmOS018CTVgy6HNWDSHvjEMcAPGgxkuxTQk4rzMKR3r65Sp
   KOzcEIfKXYfepwAzJ+5kHxOX9rSiQSNJAXL7fkWI3CysSkN3OezqodbZ8
   Zom6epDkk1Gib7NGlSjJUSf/0lZlB5Y98Rq24AY1kfZBRcgKamLQ1L3OV
   ds48TTZHESucxYlG5W3q/uicHNh8svgUJT8/J5MtGVpsWZvyKc79bwQDH
   J1hGKjEBN7+Dn1QTAqR8ubc/gQQcTXOxTq5hj+jN+hOR6RUZSxCuku1FO
   5OhJzdBDkS+vttiTuxnPAorf8h/IxFk4Ghsj587VJrnA9kgp/se5b6qG9
   g==;
X-CSE-ConnectionGUID: i1A97vrnTTeoxlqBY+64Ag==
X-CSE-MsgGUID: kJ47jRd9SluS8wbqc5uPGA==
X-IPAS-Result: =?us-ascii?q?A0AoAAAKQUto/47/Ja1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEaBwEBCwGBcVIHeYEcSYggA4RNX4ZVgiSYOoVcgSUDVw8BAQENAjEgBAEBh?=
 =?us-ascii?q?QcCi2YCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4Th?=
 =?us-ascii?q?XsNhloBAQEBAgESKD8FCwIBCBgeEDElAgQOBQgagmGCSiQDAaQKAYFAAoore?=
 =?us-ascii?q?IE0gQHgJYFJAYhPAYVshHcnG4INgRVCgmg+hEWEE4IvBIIkRFKNFoEahwOLa?=
 =?us-ascii?q?1J4HANZLAFVExcLBwWBIEMDgQ8jDzwFLR2CDYUZH4FzgVkDAxYQhAIchGWES?=
 =?us-ascii?q?StPgyKBf2VBg2ESDAZyDwZHQAMLbT03FBsFBIE1BZd/gw6CBIIVFgEeC5Npg?=
 =?us-ascii?q?meuX4EzCoQbjB2VbBeEBIFXizaZUC6HZZBxo2eFJgIEAgQFAhABAQaBaDyBW?=
 =?us-ascii?q?XAVO4JnCUkZD45fiFWyRHg8AgcLAQEDCZFyAQE?=
IronPort-PHdr: A9a23:MOn2jhceVh/suVlzV1//yAZtlGM/gIqcDmcuAtIPgrZKdOGk55v9e
 ReZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:c8G216nOxfJOZ02mBnJyy8Xo5gyCJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xIWXWjTPq3bMGuneI8jPonk9kpQ6MSAm4JhTVc+/nw0EltH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raP649CMUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+pO31GONgWYubzpKsvjb8nuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FYxB07coH3tIy
 cAVLyAJdzqyxLzq6b3uH4GAhux7RCXqFJkUtnclyXTSCuwrBMieBa7L/tRfmjw3g6iiH96HO
 JFfMmUpNkmdJUQTYD/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKOKo3aFZsExR7wS
 mTu/EalXRMgOI2kzSe+om2mn+SSgBvUcddHfFG/3rsw6LGJ/UQXCRsLRR64rOO/h0qWRd1SM
 QoX9zAooKx081akJvH5XhulsDuftQUdc8RfHvd86wyXzKfQpQGDCQAsVSJIYtgrnNE5SCZs1
 VKTmd7tQzt1v9WopWm17LyYq3a2fCMSN2JHPXJCRgoe6N6lq4Y25v7Scute/GeOpoSdMRn7w
 iuBq241gLB7sCLB//zTEYzv6950mqX0cw==
IronPort-HdrOrdr: A9a23:lbPz6q6PqgpxRscLegPXwYeCI+orL9Y04lQ7vn2ZFiYlEfBwxv
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
X-Talos-CUID: =?us-ascii?q?9a23=3Aa0Y3f2j5LhbR8l4EgJRnVXxNcTJucyT0nSjOOUm?=
 =?us-ascii?q?ENWtuWLmMY27Tpv9NnJ87?=
X-Talos-MUID: =?us-ascii?q?9a23=3AltICSQ2ocp7t1So5sAwvlqFqSTUj4IbyV0I3ncQ?=
 =?us-ascii?q?9v9S/ZTN6IjzAkQyYa9py?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-05.cisco.com ([173.37.255.142])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 21:08:22 +0000
Received: from alln-opgw-3.cisco.com (alln-opgw-3.cisco.com [173.37.147.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-05.cisco.com (Postfix) with ESMTPS id CE82A18000223;
	Thu, 12 Jun 2025 21:08:22 +0000 (GMT)
X-CSE-ConnectionGUID: 7RaaJQaWTEW//9H8MmwjnQ==
X-CSE-MsgGUID: MZLD1TBnQ6usQdDgwwHfGQ==
Authentication-Results: alln-opgw-3.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.16,231,1744070400"; 
   d="scan'208";a="28221576"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by alln-opgw-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 21:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGg7YCKRAOEPXRf/D6XVbjiz9xAyo3V6zVYsLKfD+/DxROat/5+jmFrpu2k8/8dLEspwlbx1Iy3zSL+Ibd6lFvUmgeGCfp/AoVDGkBIdtr6eKsNFUzJUC+jTF64W47NQVMcAlAaweIMVOU94j0PMe+sW+H+/L1m59by1fwiOtU9aPz93hcyd53ePcUbSlytaQnRpPxp28TME2NTbzyBUQxWRSue+IBrHvUEq89V5oSdMWXwr/I1uBff7Dxti5BxQXOUZ2H3dG+JfzrgBvVTx+shhrrIlyRO8yBgRzU0ZtJ6wSdA6+Rc1t+mD8xuETjWz5rmH8id2xMvseW6NV9PsdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKMY+o+s4akthpU9XBTiORGV6RD4LQlMJ3sAH/UjsxI=;
 b=G+zqwpe48cWyT7yDnP3xirSAhgFsFfdWuZsw5sCkL+prJKc7kB9tWQSR83hqHEyA+u3gKYKHQN5VjR98QWDL8C5xfOKCyfL5uf1Iw1nrJ6ayLgU00Wn4lUx3X6KO/TjFkP5PoKqaB549gl2Epbx61l6NWA36bGycZ2KL/YawcwCLkaXmDzLU0mG8lIqN6ABnKFZjNJ+Uz9jr/EN9sE2b/tpn6PD3d5mvYSBsRsq7atQQxG+nACURTkyesq4Pf8yC+ew5wj5uXgd+/as3vfqnuCY5SaUxX3zPqqaPqQCm/ZQFcIlpAS/Fi7/SNZI9S7LfqhaYzJJ/ObHblzfUS92NSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA2PR11MB4939.namprd11.prod.outlook.com (2603:10b6:806:115::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Thu, 12 Jun
 2025 21:08:20 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 21:08:19 +0000
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
	<linux-kernel@vger.kernel.org>, "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
	"revers@redhat.com" <revers@redhat.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH v3 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when
 FDMI times out
Thread-Topic: [PATCH v3 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler
 when FDMI times out
Thread-Index: AQHb2zNAAiZf1ytsb0Gol9XLaQ5e7LP/JLMAgAAP54CAAM+wMA==
Date: Thu, 12 Jun 2025 21:08:19 +0000
Message-ID:
 <SJ0PR11MB5896816AD0F602EC6354A399C374A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250612004426.4661-1-kartilak@cisco.com>
 <20250612004426.4661-2-kartilak@cisco.com>
 <aEqE5okf2jfV9kwt@stanley.mountain> <aEqSPahh0b5h39J0@stanley.mountain>
In-Reply-To: <aEqSPahh0b5h39J0@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA2PR11MB4939:EE_
x-ms-office365-filtering-correlation-id: 7f5362a8-520b-4960-f455-08dda9f54212
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?PQHE2n0UEXoTgBjQf74j+Ct7C0e17gw3Pc2TnPNOPdiZY/SYJ/LQ5TwvX6WB?=
 =?us-ascii?Q?Q7tDde7H5n7r++Qzwp/m177cgEaLVZHFwBM9y75TiLZPFCtw1JxVte5BsGfB?=
 =?us-ascii?Q?ZhcV2yiEfOSnTzPJGB3FLV9x1u+HVr7Bn07V+uk3NBTi4zFGkNZmJ7eOa5NE?=
 =?us-ascii?Q?bJHByOPg3bzdFkiu0pnLL17t9hwjFMuOH70vUAXAfFqTqWLtOYNHzc9ziD4Q?=
 =?us-ascii?Q?4GndkiVTyj+tpilvcIH7geFogVSQer4LcNCGiVssN8Zr9eIoFJ6ikWd7c0kC?=
 =?us-ascii?Q?ERY7OABvLc6lp65SudOwHtcujYu3W5XvGZAPuAtelAn22NKV9+wxy0U1saiH?=
 =?us-ascii?Q?UoHHcpKKCEiFqP69WaDjLNB9QlYctWgVDbH3Ta9Gyfm1SBI4a7X1MWMh49vm?=
 =?us-ascii?Q?hYpMZTVoKYvzTrC3ID3qOM5zRnWvLOtEC6dWaXaTw2phTJQEYLx4NNd/t2D3?=
 =?us-ascii?Q?1GINqLu5QKPXd69qUGzxJc+u45EMcNffz2LfkiI4KA0yZ6wBNZdJvXjT2LRk?=
 =?us-ascii?Q?AAx7rIHQWMtFUSXrUyc87wTucszO6HImAvcyfNH31G2W640f1pb94IODVP6W?=
 =?us-ascii?Q?Ni+D9QF/Jj0ljUXq17MvWzqFQC352o2K5ADs09czF2VsoKojpRNEEM3gV7Gr?=
 =?us-ascii?Q?lhaSwA0akday6V00x9NxIFcScQFTtLBBhB6wYGHX7y/dl1TSyx0f2xEXiv7T?=
 =?us-ascii?Q?4y+ybgZTnPVvZUMYgMXXnxhab4SYCp9Z93rSc30I/XwP8TFV2hXOZd4a/ecM?=
 =?us-ascii?Q?T4xz/iqdkZDioCuIUYx9STJo9DoG7sCado0OISddq08t+xxY34fpYqVlT++f?=
 =?us-ascii?Q?bxf5B+52B6P3WCG2Ye6zt/oIPlINmbJddZo6yMmoLMMxz5YHhJ28p27ANTGy?=
 =?us-ascii?Q?FdkzhAly9w0JaMYHN4n+0DUk4BqrA705En4WfDzWGRFCCb+T7MarxH//NX73?=
 =?us-ascii?Q?U9mzzT3jhr7xM9msPg9zHzWkjs7pj85jlnE9TUHDfbbrukVKcCarPipchAU5?=
 =?us-ascii?Q?RJsZfE6TZcUWQHps9AooEs8Xxgp4DNHA3hpP+l8ozo1jjcipjxBLnCBxg4Fj?=
 =?us-ascii?Q?/VYOqi/VsRbyzKQkfqZ87BccvU3lo6uuIaVVK4qDOfD1NPr9qSnGCDsjy8tr?=
 =?us-ascii?Q?NJW1L/xR8W0wvaLT6pKvMbIFRq9+unBVa98Fsqb/YtN9Vurd5v2dKYf9nvu8?=
 =?us-ascii?Q?W2fZIOxaEr2+WuYipTeC6ylaWQcd3bzTneb8G5Xglj2fj8cfDpKAFcfLppkQ?=
 =?us-ascii?Q?zcHy93WyFPYPHaF/FrtLvuV0jRC41bhw8KJoew7zkNpA/XZFGXkhm884PCQu?=
 =?us-ascii?Q?kCX2/5sMPy6k6usdwFlceRD1Tid84QRnYNFX1wj1jXwXrp3afdB+j7wsOAKe?=
 =?us-ascii?Q?+P/2QCRWJxGmELdD1zcFgG7qomzdB9w23a9CXwgZYw0YKKTaxEEDDM6jp6gl?=
 =?us-ascii?Q?hW/uD7m6MYE3KQTJIPIgrLOmSVuT/PnHzXQw83eH9wOqMaPMvPVWjg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?pApWyoVr+n1PtNb3YWURvWyszoSpBrI8F8TIIX9p1p/pZqhOV3iiRdgOj+2C?=
 =?us-ascii?Q?ztImKMPcyAYYvXnPlFuLRQ1brw/zKYJxJGgnRGaoBI39AGqvy/69qq6CwZsw?=
 =?us-ascii?Q?y3iI2B8hxVjO+IUdUZD7Fj08FBfL5KUwn0WXwomi90v43xKnoYanSn2uQcg6?=
 =?us-ascii?Q?gC9TKCGW8OnidHjxwlUJY6EZRNi8KEoL2EvrneaguvQ3LUP2cVMDVm/qj/VB?=
 =?us-ascii?Q?26tSRZTbJIbC/LCvZiIs8jV7RZTRiq8E6q34Hm8fxWfcS3qie/ViXJqu2LLd?=
 =?us-ascii?Q?yh7uiT/i+jnjbAVrwaDXJk0ZjRRuL3U6/rY6ZjVC+l6peVsu27JVyQQjqum7?=
 =?us-ascii?Q?Mc+y68xwJF4bfPUGDGYyAlfldTsHO2FHK0EeFdECuDnhRwGinjBTfqLR0/fR?=
 =?us-ascii?Q?VpGbDE7vUZBwEmFOWO3jYFcz80HjoEF0LYM5D6YyLhAi75SWblwLRUoqa2Jp?=
 =?us-ascii?Q?x7N7Ofzze5uE7UaU6VgRVKkWT7Uz9ZpECw4QWzleSF/0t1LpSNWgRasAEpQm?=
 =?us-ascii?Q?+k2p+5P8kLLLrcdTFNFN3m3d0Wb5n395rG0JW3e3qPbWvIQashxOA7hvJoPw?=
 =?us-ascii?Q?xn/J2GVnDLNKIZkswxFCTjioU6pgUiDgdH/2BBRb+xVqIsjg3jXQP/SpLFPD?=
 =?us-ascii?Q?12UiXmUFi6T2id0EpoB+2b+YF1Lq3pr2b6wODp/kyJbAPcxHhWCUjis+W9QU?=
 =?us-ascii?Q?MnFBDXtcOBfRZZBuXRueDlE0MWUiqbKYZ1IGfMqqHnzaTi5fVYWnqDq1mywK?=
 =?us-ascii?Q?8khUbfCzvIINzVVFdM4LSa2kJPZDm+3tNZgK+NeLP70QFbu/aKso0bJl0arU?=
 =?us-ascii?Q?PH3bvs+toLcQfSP+mpfrJdVhmTiLjvfXl52b6GeN020mHI7fTAbWN5O14TIA?=
 =?us-ascii?Q?/VD4lDLuSlsUt5BCEPFkIVo4BaQmMGHnGw2Sd45DRBg+G8zwPwTJ2QyjFJRp?=
 =?us-ascii?Q?I6IhTXdO72gRVeosJcxrwzywa0+qAb7aYuJwq2wc5qyMdA8k0SfMwqTYxaCu?=
 =?us-ascii?Q?IrLz1oLscDPmP5EesIRQkBNgzGWU5gAaWwjiZnQ8Cr8/0tq+zD376MMC6buH?=
 =?us-ascii?Q?cwjggxSBlqI1hcdmmPbUj/Ita3eBEqsB6LZjqoqmIsMmzLbeFFScVpxbwU3/?=
 =?us-ascii?Q?dYZgeIj8r04Z6kW+9f+v/IYmDLinmZeIU8dOHo8UYD9C8ko1FAMin/mlHlPo?=
 =?us-ascii?Q?jq/lLzad2PVm10ZmRizjOhisif7c2UUO6GEQ6S9N54OWzz8Dlcl44nAXh27L?=
 =?us-ascii?Q?FqXgx/0WB5rPuUH7qGtsoCe8UB0JsgIp07Ef8V690wEwuK91NZ8RcDZkdT3e?=
 =?us-ascii?Q?ULOSbvJiwzoq6+pRlfBw5D3KDgxQQSOlshaZNKpc+yQx3E52PS4hzkZT3Bz2?=
 =?us-ascii?Q?CO26WwO4DQJG4f4eLmPgbp+eS5DyLMv99BVz2VYgMeZXLlzMjPWy6uMULva8?=
 =?us-ascii?Q?r13O2oWhB09l3EGdx048ckOLqrcZE+t1l+7OVOKKXvTSO6UbqsmsSc6X4ZRp?=
 =?us-ascii?Q?WWHsyxtAiDwV+fxgnqbvoaOCTMQbbpzzZYlH4G5oeCFqw/qiqpq7uXQdb0QE?=
 =?us-ascii?Q?yRXylBkeNJcyoXhVe4UfsId/50HitUcmzqtGHM7/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5362a8-520b-4960-f455-08dda9f54212
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 21:08:19.6759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /O1vS5BClnYiXgzPPRjLPvB5HAMy7tQ/Zdh5yJMpAjmt0e+ARdvO4ePEjxkfWFhDDnzbAKXiB2MZov02S04tuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4939
X-Outbound-SMTP-Client: 173.37.147.251, alln-opgw-3.cisco.com
X-Outbound-Node: rcdn-l-core-05.cisco.com

On Thursday, June 12, 2025 1:39 AM, Dan Carpenter <dan.carpenter@linaro.org=
> wrote:
>
> On Thu, Jun 12, 2025 at 10:42:30AM +0300, Dan Carpenter wrote:
> > On Wed, Jun 11, 2025 at 05:44:23PM -0700, Karan Tilak Kumar wrote:
> > > When both the RHBA and RPA FDMI requests time out, fnic reuses a fram=
e
> > > to send ABTS for each of them. On send completion, this causes an
> > > attempt to free the same frame twice that leads to a crash.
> > >
> > > Fix crash by allocating separate frames for RHBA and RPA,
> > > and modify ABTS logic accordingly.
> > >
> > > Tested by checking MDS for FDMI information.
> > > Tested by using instrumented driver to:
> > > Drop PLOGI response
> > > Drop RHBA response
> > > Drop RPA response
> > > Drop RHBA and RPA response
> > > Drop PLOGI response + ABTS response
> > > Drop RHBA response + ABTS response
> > > Drop RPA response + ABTS response
> > > Drop RHBA and RPA response + ABTS response for both of them
> > >
> > > Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI"=
)
> > > Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> > > Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> > > Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> > > Tested-by: Arun Easi <aeasi@cisco.com>
> > > Co-developed-by: Arun Easi <aeasi@cisco.com>
> > > Signed-off-by: Arun Easi <aeasi@cisco.com>
> > > Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> > > Cc: <stable@vger.kernel.org> # 6.14.x Please see patch description
> >
> > I'm a bit confused.  Why do we need to specify 6.14.x?  I would have
> > assumed that the Fixes tag was enough information.  What are we suppose=
d
> > to see in the patch description?
> >
> > I suspect you're making this too complicated...  Just put
> > Cc: <stable@vger.kernel.org> and a Fixes tag and let the scripts figure
> > it out.  Or put in the commit description, "The Fixes tag points to
> > an older kernel because XXX but really this should only be backported
> > to 6.14.x because YYY."
>
> But here even with the comment in the commit description, you would still
> just say:
>
> Cc: <stable@vger.kernel.org> # 6.14.x
>
> The stable maintainers trust you to list the correct kernel and don't
> need to know the reasoning.

Thanks for clarifying this Dan.=20

> I much prefer to keep it simple whenever possible.  We had bad CVE where
> someone left off the Fixes tag and instead specified
> "Cc: <stable@vger.kernel.org> # 4.1" where 4.1 was the oldest supported
> kernel on kernel.org.  The patch should have been applied to the older
> vendor kernels but it wasn't because the the tag was wrong.
>

I understand and agree with you. I prefer to keep it simple as well.
In V4, as you suggested, I'll keep the fixes tag and the Cc: tag and
remove the comments section.

> regards,
> dan carpenter
>
>

Thanks for your review comments.

Regards,
Karan
