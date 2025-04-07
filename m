Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2082.outbound.protection.outlook.com [40.107.255.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951A0229B05;
	Mon,  7 Apr 2025 08:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015923; cv=fail; b=ESfJlFgywXAhjeX4ujQbtKlhPqEklDooKpPtD6jWVVNySZUfz6V41Oi/C1/6EZ9Y12fXz6yUX7YTR54PWZTPHm7o0yQHS7KRe7FhFrTOPiQM/9/I/fU/oFyLSFT9PH2n2d4xDCn1xKwyUNhG/Ugr8BMrtx0kAEqa8RRTnKN5wzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015923; c=relaxed/simple;
	bh=IMT9GUPObLHpQf0kXvYVMjhv78sTS3o45ks1bQ1xyTk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=nLdZTHY2NuVnokg9y8jPqBx/2kc+0uir+Z5ZjgvVQGQWR4A/bSHTMgHHSosy7wuyTyHaE8V1Gwl4GHMpgZfBDNroex9VU30bpf/7kamceoUd96Tg8CZ5JWMgkgQCJhtsViHd4NCErDMPv92jHNgfO5u8MCULOdN8Gqg2IYoBBdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=k3YdDeie; arc=fail smtp.client-ip=40.107.255.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="k3YdDeie"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZablMcgGNVDgKXIzujTZfT8peQsDOdziuz2OJHfZENkR4doMEuilxnn3R99P6NzvB31Tw/FWGz63Kb6pINuRYdMlr3cp2BmjStFzfp4UpGmKymvxOPaWugTFFQCWjyKRVPMf4EfKoaQGHoF9ortiw0E3gzcm631qSqfbY/z2abUdeJMhXSvdfUBxtbe8CEtbOzHZE8by7OSUw5zTXwIxZGsQdaPWu4AcL3zaMTDpF3sEYwv5NSfMqNgSpfRLiS6mGCLKIfdo1oD1lHz5JV1uy5ljOJR2uhJio/9gv0RTPGcO//JQ3bzqRDLfiZ54KGD/HOkZrspFdQA0qRmq5AZjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RaBYS5VdGxEXvA4tJQsHdpqa3Q49abSY6AjWgW0RP14=;
 b=yXIxf51gJqNpbUcawjz2PC6mDMEUwT6QbUkJs7ukIu8XwbijczbdBLy+lCzBkXsOHyJFW886/A5cywbNRTeIM5DgbdI1Y5O85PUT2MIzkQi7uPNIoAFSllkJPIvR38XzN5sC1dMGjNJ7eIkJIUUs+jfxm1p2UQUx7V2EEoSvkjoGPP3yZptStdHTaMDS/5A+/4PU6vsmRPfq9HrYYn0W6DDwABIuAy7Xm3lk1I7Yp8pZzF90jJwz+gb9RoJfSCC0A5LyZfPNcNOwe35yPrrxA/84NDfwhr2P7ryWFj80QWjDL7rP2SOY7/6EfCffTJF765XGEnSHbRUfGQDI83vc+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaBYS5VdGxEXvA4tJQsHdpqa3Q49abSY6AjWgW0RP14=;
 b=k3YdDeieB+Gs7vgVPI4VgQiqfaU9J8UMKhJej6Wtbd6N3AxcCU3gKUP0xup10CuZ1X9B5tkRsrXTYIFuxdMsTf6MloFF+gBE+rklQcsSD+5Ip+5JoOjuJP7vi0tyM/oiOla3miY2/VRs7Q7C3OzlHYsu0B7vAQs2N9NcMG85qmZOVRNHB1ajc5BKQMroCw9iGvHqP4XnnD9Scomxcwp6rVeEg/I+KECJH2/pxfYGz7G4Y1NAP74Z8mif+9VoRwWVIC/9NnNb6C2jVAzyW9HlonwbzV5CB2QNjZVZ8AYCRSumM3t9xtTtp2vGlkTnzNf/pRs6vsJtA7zeA7vZLSuBjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by JH0PR06MB6703.apcprd06.prod.outlook.com (2603:1096:990:36::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.29; Mon, 7 Apr
 2025 08:51:56 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8583.047; Mon, 7 Apr 2025
 08:51:55 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	beanhuo@micron.com,
	luhongfei@vivo.com,
	quic_cang@quicinc.com,
	keosung.park@samsung.com,
	viro@zeniv.linux.org.uk,
	quic_mnaresh@quicinc.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_nguyenb@quicinc.com,
	linux@weissschuh.net,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH v9] ufs: core: Add WB buffer resize support
Date: Mon,  7 Apr 2025 16:51:43 +0800
Message-Id: <20250407085143.173-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:196::12) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|JH0PR06MB6703:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cfafbe6-4c9c-4ec1-2ff5-08dd75b172e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|52116014|366016|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kfje0EMoXcPxTN3ZHGy1cev/DOc1Se50xR5yhcENhRA4WF4y5wlZ3A/CcvU7?=
 =?us-ascii?Q?34zF+Hi6I1vyd/mrCDGNmK9eHNTkwLkCpb7/Ix5dGjRnliZd8Q6+DtkOVvzF?=
 =?us-ascii?Q?gofxtYEFERMiepgw+6fGvoyicMKlVkESRVN6yNntSzk1Jtzg1ozyofLOUU7o?=
 =?us-ascii?Q?p3SXAPt4tNh5XkH0GmN9G3n7Y1XqzlEQSny1vfBlpslgXp1+C1oEl/+FVwy7?=
 =?us-ascii?Q?UOcF3ksDM5dfpJA7KSZYEYq/lKcBcPcIHPTaDfAT0rl28dInR93iBuPd2TlC?=
 =?us-ascii?Q?A5UkXdVSdx7xSzU0Oc1VmOT5Z2qugUwQ+Ra8ZAOquOm+oBS6sTpNh2fIDWFX?=
 =?us-ascii?Q?mYXcFLksjRcKovaYvy2XY2AZmn/LOhIqVcSZMfxM8Fk4InzorRfTvSn3Kkx3?=
 =?us-ascii?Q?c9rPsAaNFSXs/jwePVqr4XB/mwrlCuCylBVbhzDJIvJ4kKHCWbCAdmvycnMF?=
 =?us-ascii?Q?Q5WldQlY6+WFcIbZA/22UZLX1j0FBDl87894qWZ35v1aGCZZ5QLzPX+5HiuP?=
 =?us-ascii?Q?m01H6q38SqbJBQ7gT8CrEQxnoSMZPsYXhjukcfw4VHHElP0/tjzBksAvM4RN?=
 =?us-ascii?Q?81po8zXqzHXJ6Uxgyfhpx0eXjHbGGya0tK3obQTwQhwQV90IUE0qwH62WNur?=
 =?us-ascii?Q?Jmlt98iSKBg7Q0V7/zJaLEYtQB4YkAWqebebBxQ3JUO58yaDhbivyRHhT5JL?=
 =?us-ascii?Q?nSq6r2fz3HGpqGNUEA/8STeJ/jlL0jbCFMqjIIjKfUVeaWvVKjPB62hciKX5?=
 =?us-ascii?Q?Oq4l24y7Lx6McOFcvkyXpoAmjo0Fnp+YF/hMUcUp53qSXV6Mtd7MowVHmRyr?=
 =?us-ascii?Q?97RgsV3YEro2egKczysF9jfbZY/A53rl+MXxeuuK75tT8fQmO40Cib/fU36L?=
 =?us-ascii?Q?9Q81veHVozRqSM8clb+JPUt/SuvgYjGFisYG/kpNRhGpsXEtvrKp651n4x9d?=
 =?us-ascii?Q?0nInzApSvvUpXfT6zHl+tDliqAIk2UAOH2rIcyGFwhwegYvlVV3EgGlChwsZ?=
 =?us-ascii?Q?Y07Dd5v+K84Oyr+F8jzDY3xm6L+Xw46xtlENlR75KHgBZ/hbMoayNg+T7Ock?=
 =?us-ascii?Q?AUpVQx1Slc9ZIMJ+vvrMEmryVAfsKQ9CVbTxAJ+RvUskftEM1E5sZ5FaTWO9?=
 =?us-ascii?Q?Pgh4SRXsbB4HatVOTirUpsvDwVr7BsazspIgD8YxUyYxjG6lhjQI2CoC5uhz?=
 =?us-ascii?Q?MHLi4d/NbhTX1e9hQnMVO3TMGRkGlBBxY9GYCO6ZTJ0ELYvnNT2oxQ5kjAlA?=
 =?us-ascii?Q?U3jAzy982mDfsFbRq/JvEeLu5NRalNlHRmO6hoMRvTSW+TKBil3SF1JDQzxU?=
 =?us-ascii?Q?BzmiXAac7q4Y+JgXCvG4nzYeYGSSN4Tk8iCjO3YrpuUAyEazIPD8/JUcsNLr?=
 =?us-ascii?Q?ALuvlBLUGHyW8U+ikTZ7A9I1rckWAIDoiSiVNnVr7BYn1BnP5kT1JrRgr5Wg?=
 =?us-ascii?Q?QzcUqUDc84kAvvjPabIwhdsk6hA2/cOZRS8fh4d/UA6ASM9VwSv8LQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(52116014)(366016)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hgKpMLgTbUbTRusTbbws53dguX8qV+jRuciV9lQKPkeYWxFA1ib5FVwIaV+M?=
 =?us-ascii?Q?p1fkRmVBwHTDOBuCXVv8CMj9XrwvCwTR3hP7jL21c2C2AyYDZ9YSdk6Ze1Ir?=
 =?us-ascii?Q?HUkQVVCDgrYAgXWFKrYYSUxHhXEZiUMp6fw4dY1fD0EfVGx/xZprnzAk+YDE?=
 =?us-ascii?Q?+5ZUVznkAEhgsFD+DKkrclCw5JTyNkPj0DidrFCOWseXI/vWp9DllN9hFoze?=
 =?us-ascii?Q?XsQefOEc/pbJh1pxvaeWZFl15o7vBr/hkzDTV2ttx06Pv6Sw3hwvMqRURLvj?=
 =?us-ascii?Q?sVtmSJBkXK1IjFROObe5Tpw1L4qFg+BhNBrQwEg9KMdtoVlACMsGYJph9E3S?=
 =?us-ascii?Q?oYU9ZTtCU7hc0FkKyAOaW7PBgZgoFXVNM27LT9QIW8kgpiHYsQm07DN1W6NW?=
 =?us-ascii?Q?aXz2hwJxGXOyYyU8pAIVW0HUeCeWA8S+sHG5QjbndiXkIwMpixyuyzwWzbM/?=
 =?us-ascii?Q?GhlcX/qDS4OBoLUETgA72HIplO6IKV4n41byQHkMtOitKvZ+g/8mtL5ieaBu?=
 =?us-ascii?Q?jTV7Q66tdWTCqJPe/E3mODeLOY+tNIp8FwRFHt/knFY0QhgDsIrTAJnNvoHg?=
 =?us-ascii?Q?dP+Rkg3AROcYZ2ygXlFPdsGMwbi2HVeDEqB950w99sRpLKyR/ZaPPGPeei12?=
 =?us-ascii?Q?MDda7o6dH1595Zs5JpxvP1u8xt65Q+N3+QGbXBRbtKGiJ7rGuKqTOWGvE+mR?=
 =?us-ascii?Q?hgSHtUuwYO6sSbhQ2R9mF2AgGtsfuC57KXe2lM3JBhhIvnqTOZkocxuurq7I?=
 =?us-ascii?Q?oArAqkIXCg3QOEV6OEJxfz5KieqLVZ48Unycg2BzK+vkI3x+FSGS6VN1PRgH?=
 =?us-ascii?Q?+Civdf5QjCFYlYYhBL08BYSBAT1XZ+EKVc4QbQwzVnBWoOZlwOOBPA/hHK+U?=
 =?us-ascii?Q?9VgyzIRn/rGvCGFDCPIuCsTNMXg+4XEGS9lqm2yLVzinDP3Y1mToJcSVTTTy?=
 =?us-ascii?Q?rIcPz9wW3gbY1JyWIK+uf1X0OP/L9PHwBiU1njHXI97DOMrptYq7WMMp7obu?=
 =?us-ascii?Q?xH/45HTDdCElWZR+RbraOOrNqkbT5RDY0TY+Hp36+bDk9RhCWDughpLybRTU?=
 =?us-ascii?Q?1dSlyiHM9cSC4EEZ/K1RTHnBVKtUkYw0z4FJp4wL7uBGlz7xRjrs8IWPgAXP?=
 =?us-ascii?Q?7rqp8IQ+a7urlRRHLhR92terpD+fMTNUeANjQGb389uI20HWtysZ2oRNhPH2?=
 =?us-ascii?Q?hXzl5c+gIcb17DurIAIhQ2hFVDlsLbJPICwMlAfcS7TihXlXkgKbXmrECcC/?=
 =?us-ascii?Q?ZnsWq4KbtakOdHpf8HwaWNiVcmTIXMJqcnGbbFVuoXMMSE+H5lG8TUsmPmQs?=
 =?us-ascii?Q?wp3EziolDjRv16izEnJwTbDPc9G6OcukitevLTk9Dc+BJO1VAR4DIxieL0NW?=
 =?us-ascii?Q?xPizx0hzOHWrWLVy6OyLoDATq43Bp98p1Ffb6xDYN/sKVY6TnBitBL+GQrhU?=
 =?us-ascii?Q?boUTxQyoytg9ui30AmpfV512wNZDwBdHKSMqkruVe7lGDoXMx9BedNmuM/hj?=
 =?us-ascii?Q?F2C62oazY4l//L1hA2XflzcX6UDAMZ1YvmqXKG5LH9bOe5bNIBrSgMCsLPNr?=
 =?us-ascii?Q?swuixkMXLZ8c4ZI7YALa5x+77ZO2FT/bgmjasBjO?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfafbe6-4c9c-4ec1-2ff5-08dd75b172e4
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 08:51:55.6195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1npsxzKLiCEbAWj2OqArv4/Ec9qlGmku1ClNu5O2sb38aTCnPVK+kmcXtG6kXfw2qZlVzVUTZqNhIfoJ3XKHOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6703

Follow JESD220G, support WB buffer resize feature through sysfs;=0D
Query bit0 of ext_wb_sup to determine whether the device supports=0D
WB resize;Query wb_resize_hint and wb_resize_status to get the=0D
device's resize hint and resize status; Set wb_resize_enable to=0D
enable resize operation. To achieve this goals, four sysfs nodes=0D
have been added:=0D
	1. ext_wb_sup=0D
	2. wb_resize_enable=0D
	3. wb_resize_hint=0D
	4. wb_resize_status=0D
The detailed definition of the four nodes can be found in the sysfs=0D
documentation.=0D
=0D
Changelog=0D
=3D=3D=3D=0D
v8 - > v9:=0D
	1.Add "ext_wb_sup" node=0D
	2.Fix some coding errors,for example: "gerneral" -> "general"=0D
	3.Add a check bit0 of ext_wb_sup=0D
	4.Following Bean's advice: use enum in ufshcd_wb_set_resize_en=0D
=0D
v7 - > v8:=0D
	1.Optimized the description in the sysfs-driver-ufs file=0D
	2.Replace uppercase with lowercase, for example: "KEEP" -> "keep"=0D
	3.Fix coding style issues with switch/case statements=0D
 =0D
v6 - > v7:=0D
	1.Use "xxxx_to_string" for string convert=0D
	2.Use uppercase characters, for example: "keep" -> "KEEP"=0D
	3.Resize enable mode support "IDLE"=0D
=0D
v5 - > v6:=0D
	1.Fix mistake: obtain the return value of "sysfs_emit"=0D
=0D
v4 - > v5:=0D
	1.For the three new attributes: use words in sysfs instead of numbers=0D
=0D
v3 - > v4:=0D
	1.modify three attributes name and description in document=0D
	2.add enum wb_resize_en in ufs.h=0D
	3.modify function name and parameters in ufs-sysfs.c, ufshcd.h, ufshcd.c=0D
=0D
v2 - > v3:=0D
	Remove needless code:=0D
	drivers/ufs/core/ufs-sysfs.c:441:2:=0D
	index =3D	ufshcd_wb_get_query_index(hba)=0D
=0D
v1 - > v2:=0D
	Remove unused variable "u8 index",=0D
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'=0D
	set but not used.=0D
=0D
v1=0D
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/=0D
v2=0D
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/=0D
v3=0D
	https://lore.kernel.org/all/20241028135205.188-1-tanghuan@vivo.com/=0D
v4=0D
	https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/=0D
v5=0D
	https://lore.kernel.org/all/20241104134612.178-1-tanghuan@vivo.com/=0D
v6=0D
	https://lore.kernel.org/all/20241104142437.234-1-tanghuan@vivo.com/=0D
v7=0D
	https://lore.kernel.org/all/20250402014536.162-1-tanghuan@vivo.com/=0D
v8=0D
	https://lore.kernel.org/all/20250402075710.224-1-tanghuan@vivo.com/=0D
=0D
Signed-off-by: Huan Tang <tanghuan@vivo.com>=0D
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  59 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 144 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  18 +++
 include/ufs/ufs.h                          |  34 ++++-
 include/ufs/ufshcd.h                       |   1 +
 5 files changed, 255 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI=
/testing/sysfs-driver-ufs
index ae0191295d29..ea9d6186cefd 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,62 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
=20
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ext_wb_sup
+What:		/sys/bus/platform/devices/*.ufs/device_descriptor/ext_wb_sup
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		This file shows extended WriteBooster features supported by
+		the device.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_resize_enable
+What:		/sys/bus/platform/devices/*.ufs/wb_resize_enable
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable the WriteBooster buffer resize by setting this
+		attribute.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		idle      There is no resize operation
+		decrease  Decrease WriteBooster buffer size
+		increase  Increase WriteBooster buffer size
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_hint
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_resize_hint indicates hint information about which type of resize
+		for WriteBooster buffer is recommended by the device.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		keep       Recommend keep the buffer size
+		decrease   Recommend to decrease the buffer size
+		increase   Recommend to increase the buffer size
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_status
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the resize operation status of the WriteBooster
+		buffer by reading this attribute.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+		idle              Resize operation is not issued
+		in_progress       Resize operation in progress
+		complete_success  Resize operation completed successfully
+		general_fail      Resize operation general failure
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab60f5ae..71e8454d07d1 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -57,6 +57,36 @@ static const char *ufs_hs_gear_to_string(enum ufs_hs_gea=
r_tag gear)
 	}
 }
=20
+static const char *ufs_wb_resize_hint_to_string(enum wb_resize_hint hint)
+{
+	switch (hint) {
+	case WB_RESIZE_HINT_KEEP:
+		return "keep";
+	case WB_RESIZE_HINT_DECREASE:
+		return "decrease";
+	case WB_RESIZE_HINT_INCREASE:
+		return "increase";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *ufs_wb_resize_status_to_string(enum wb_resize_status st=
atus)
+{
+	switch (status) {
+	case WB_RESIZE_STATUS_IDLE:
+		return "idle";
+	case WB_RESIZE_STATUS_IN_PROGRESS:
+		return "in_progress";
+	case WB_RESIZE_STATUS_COMPLETE_SUCCESS:
+		return "complete_success";
+	case WB_RESIZE_STATUS_GENERAL_FAIL:
+		return "general_fail";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -411,6 +441,44 @@ static ssize_t wb_flush_threshold_store(struct device =
*dev,
 	return count;
 }
=20
+static const char * const wb_resize_en_mode[] =3D {
+	[WB_RESIZE_EN_IDLE]		=3D "idle",
+	[WB_RESIZE_EN_DECREASE]		=3D "decrease",
+	[WB_RESIZE_EN_INCREASE]		=3D "increase",
+};
+
+static ssize_t wb_resize_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int mode;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled
+		|| !hba->dev_info.b_presrv_uspc_en
+		|| !(hba->dev_info.ext_wb_sup & UFS_DEV_WB_BUF_RESIZE))
+		return -EOPNOTSUPP;
+
+	mode =3D sysfs_match_string(wb_resize_en_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res =3D -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res =3D ufshcd_wb_set_resize_en(hba, mode);
+	ufshcd_rpm_put_sync(hba);
+
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 /**
  * pm_qos_enable_show - sysfs handler to show pm qos enable value
  * @dev: device associated with the UFS controller
@@ -476,6 +544,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_resize_enable);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
@@ -491,6 +560,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_resize_enable.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
@@ -991,6 +1061,7 @@ UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, 2);
 UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, 1);
 UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, 4);
 UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, 1);
+UFS_DEVICE_DESC_PARAM(ext_wb_sup, _EXT_WB_SUP, 2);
 UFS_DEVICE_DESC_PARAM(ext_feature_sup, _EXT_UFS_FEATURE_SUP, 4);
 UFS_DEVICE_DESC_PARAM(wb_presv_us_en, _WB_PRESRV_USRSPC_EN, 1);
 UFS_DEVICE_DESC_PARAM(wb_type, _WB_TYPE, 1);
@@ -1023,6 +1094,7 @@ static struct attribute *ufs_sysfs_device_descriptor[=
] =3D {
 	&dev_attr_number_of_secure_wpa.attr,
 	&dev_attr_psa_max_data_size.attr,
 	&dev_attr_psa_state_timeout.attr,
+	&dev_attr_ext_wb_sup.attr,
 	&dev_attr_ext_feature_sup.attr,
 	&dev_attr_wb_presv_us_en.attr,
 	&dev_attr_wb_type.attr,
@@ -1495,6 +1567,76 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn =
idn)
 		idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
=20
+static int wb_read_resize_attrs(struct ufs_hba *hba,
+			enum attr_idn idn, u32 *attr_val)
+{
+	u8 index =3D 0;
+	int ret;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled
+		|| !hba->dev_info.b_presrv_uspc_en
+		|| !(hba->dev_info.ext_wb_sup & UFS_DEV_WB_BUF_RESIZE))
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+	if (ret)
+		ret =3D -EINVAL;
+
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t wb_resize_hint_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
+	if (ret)
+		goto out;
+
+	ret =3D sysfs_emit(buf, "%s\n", ufs_wb_resize_hint_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_hint);
+
+static ssize_t wb_resize_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS, &value);
+	if (ret)
+		goto out;
+
+	ret =3D sysfs_emit(buf, "%s\n", ufs_wb_resize_status_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_status);
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1568,6 +1710,8 @@ static struct attribute *ufs_sysfs_attributes[] =3D {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 83b092cbb864..a73838062ddf 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6068,6 +6068,21 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, =
bool enable)
 	return ret;
 }
=20
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en_mode)
+{
+	int ret;
+	u8 index;
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ret =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &en_mode);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
 						u32 avail_buf)
 {
@@ -8067,6 +8082,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, cons=
t u8 *desc_buf)
 	 */
 	dev_info->wb_buffer_type =3D desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
=20
+	dev_info->ext_wb_sup =3D  get_unaligned_be16(desc_buf +
+						DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+
 	dev_info->b_presrv_uspc_en =3D
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
=20
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed59ec46..9dc8b872b24d 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       =3D 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    =3D 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        =3D 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	=3D 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		=3D 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	=3D 0x3E,
 };
=20
 /* Descriptor idn for Query requests */
@@ -289,6 +292,7 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PRDCT_REV		=3D 0x2A,
 	DEVICE_DESC_PARAM_HPB_VER		=3D 0x40,
 	DEVICE_DESC_PARAM_HPB_CONTROL		=3D 0x42,
+	DEVICE_DESC_PARAM_EXT_WB_SUP		=3D 0x4D,
 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	=3D 0x4F,
 	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	=3D 0x53,
 	DEVICE_DESC_PARAM_WB_TYPE		=3D 0x54,
@@ -383,6 +387,11 @@ enum {
 	UFSHCD_AMP		=3D 3,
 };
=20
+/*  Possible values for wExtendedWriteBoosterSupport */
+enum {
+	UFS_DEV_WB_BUF_RESIZE	=3D BIT(0),
+};
+
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
 	UFS_DEV_HIGH_TEMP_NOTIF		=3D BIT(4),
@@ -454,6 +463,28 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	=3D -1,
 };
=20
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	=3D 0,
+	WB_RESIZE_EN_DECREASE	=3D 1,
+	WB_RESIZE_EN_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeHint attribute */
+enum wb_resize_hint {
+	WB_RESIZE_HINT_KEEP	=3D 0,
+	WB_RESIZE_HINT_DECREASE	=3D 1,
+	WB_RESIZE_HINT_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeStatus attribute */
+enum wb_resize_status {
+	WB_RESIZE_STATUS_IDLE	           =3D 0,
+	WB_RESIZE_STATUS_IN_PROGRESS       =3D 1,
+	WB_RESIZE_STATUS_COMPLETE_SUCCESS  =3D 2,
+	WB_RESIZE_STATUS_GENERAL_FAIL      =3D 3,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    =3D 0x00,
@@ -578,6 +609,7 @@ struct ufs_dev_info {
 	bool    wb_buf_flush_enabled;
 	u8	wb_dedicated_lu;
 	u8      wb_buffer_type;
+	u16	ext_wb_sup;
=20
 	bool	b_rpm_dev_flush_capable;
 	u8	b_presrv_uspc_en;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f56050ce9445..722307182630 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1471,6 +1471,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *=
hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en_mode=
);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
--=20
2.39.0

