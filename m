Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.137
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793949310;
	b=vSnxGivK9XKwkXjXE4h9BbyEzmyXuNlJAkf/wIj5Uj/Grj5NOCnyeL0HzE0xBw51NTjq
	 VDcEA6H52xUeen0JbgIYs/gucNOXPe/CZ92Qb0SBQP+/YoyL0A0xTOWVh0D2W2FP1Ylga
	 dq0n9U3gbqPPhxp8b6xwTAxCH8U7tn4FYpgQk8cFk+VY6lOWe85GII8i9TtiRKWAN+TUf
	 hglrwfbFClYW2sFUD+bApwSjKACIH9DRZ26Ojk+6OUsovvR8J4k6ydxhAewRUBelVAG1i
	 iPqAO0o0lCxfgXKZj0xiRo4SmkrTzjVStVO9bGSF4faFNJtDdAE7NX6xlBejjKHBt7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949310;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=3tohazWjggFfzZCP/hyHAbKtNMPul9G4nJph0HeJ5co=;
	b=4xjMIojUaulVY1cRZZDoGA1E6N4nDppQMhIjSC+NgCEPhr2VYIrYeSpNQR0/QdqNAqj1
	 DOaJpAbOQxiRIZZ7b+z2uk+rDIASJQNGwXVMiz23cnN3Gj7jn2NuASACM0K4Yh2ktHPRB
	 Dv84/XrLJ/k+6GlcyJF5XuUUPwb06QATtA8tVN/oVudyvr2I/9JSbseInv2TV+Bd4lBrv
	 2ChCSwqQrJfgqiE9OyGLQK4kUhxotGPo+XJlQ5UjK9+Nb49O6qtrpx4ZKo1G4miHhlwTv
	 6WsGO6eEEiXswdiGX0GCATgxah6E7Hh+qSL9z3jakeNicH9axxqAng1T/GjlTJ7ygMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smu.edu.sg;
	spf=pass smtp.mailfrom=smu.edu.sg;
	dkim=pass header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b="SHM+/8oh";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.137
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023137.outbound.protection.outlook.com [52.101.127.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDDF606A33D
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 07:15:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CDDF606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=SHM+/8oh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfkoeUTzBQTXQwWLi4dEueet94T+48QaRT9/yeApHjsbPdoCVrcMAHAUdnEX9hsUoW3dyo/8WXfaT2h3CqipIPwd/uPR4FZyXSv5Yo99VVQmYiOUy9/OO2SKD6iDGK6Y5b+FLJ2WkumUuc/k3qMJ2zmDAYdh27nDOw8s8xfoI4SbZM5h3UPAf453UGtA619h3kjkwMPLU63X/wiK4IgSu4VQx2VdboNmOFleMvLURGnNA0u7rSxMbJx4qk+Er/R6hXFX6GQgP8SNl6SyorrJLBVVBUj4OwQw489WuAc8UPsS25b2VqbKRqCkn1ix9rFDSVKViOWM4e9Kjs2DSIdJ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tohazWjggFfzZCP/hyHAbKtNMPul9G4nJph0HeJ5co=;
 b=fFsMt4AnodC4pGtvGFThCoCDbzITf3BzKCbg2MlzFCbkJsL0cDpcuJ+baTXh3YjdoyvBw4zNWA+F+B/67NsGYyADbfM6sR9VCFeVUUD/qv/I4vwLZIdXKyS6sQH67wdqjbdH8kZPAWHv92rdwXeYOjaS5lNsX4fPonRQU3BpATiJVajzuFcFkFIRcTQu97viBmqqzX2STtCtAbr921GFWedATY8hq/CmIJlUEB3ZrhZ/XSIKQELerDBVl1BiztapRkF6LGmu5jXSjpI3m0hwy4lIMTabNNR9p+nxEdZg/y//6xBGsMrEAJk8ps3MThX/cu9Y+Yw3zKQznWPF9WoOmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=smu.edu.sg; dmarc=pass action=none header.from=smu.edu.sg;
 dkim=pass header.d=smu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tohazWjggFfzZCP/hyHAbKtNMPul9G4nJph0HeJ5co=;
 b=SHM+/8ohEqwBb34AhZQCPhzchgCingfhAVooS5CwVqOtrEpU6xpUWMotFwpxV0F0ro2hjWfCgOy2gaigH8QkF0BuZSCg2NN+niC9JaNX6545sW3WrUJimmEdg8rkNOkxfRkVJDcp0jG+7xOsoYFkBJTbaLsWo400plPJiUkefhw4us2T69d0HRzk+A41Se4msT52jLCUdei6Ifj97NiM4fbNxGuNupvMKy/sVsvpwXIT3fNXbrvtdCuwWpdtB2arri13pw95U/htPIx3+oASc0/RFJb1Y4fAo2cLTFea3FaorXuJ+MxEWM7gERN7cZh8tumz4Ob2yRWLDhzIaPrFXw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=smu.edu.sg;
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11) by SEYPR01MB4999.apcprd01.prod.exchangelabs.com
 (2603:1096:101:b0::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Fri, 6 Nov 2026
 07:15:05 +0000
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382]) by
 TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382%4]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 07:15:01 +0000
From: Huihui Huang <hhhuang@smu.edu.sg>
To: linux-scsi@vger.kernel.org
Cc: Huihui Huang <hhhuang@smu.edu.sg>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-ETH-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH] scsi: qedf: Bound the FIP descriptor walks to the received frame
Date: Fri,  6 Nov 2026 15:14:47 +0800
Message-ID: <20261106071448.1698507-1-hhhuang@smu.edu.sg>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JH0PR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:990:74::21) To TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4264:EE_|SEYPR01MB4999:EE_
X-MS-Office365-Filtering-Correlation-Id: 336deba5-e3a9-4a70-026f-08df3bd5ac16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|786006|23010399003|376014|1800799024|52116014|366016|10067099003|18002099003|261021121427099003|11063799006|56012099006|261026121527099003|261022105027099003|261102123227099003|261026140227099003|261009223027099003|38350700014|261022075727099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	zluBleWDoAHeMdIdFU2lmR5GJ42iyj2PthK7MbFdZbK47/+zoMeIMVR29cO1kKsJRspj/izaZ8ZvSZpaR+DHLZMfCVfg4AqrO7800INZLzjUzVFEHsf8OWT0Vzro6s9JbiUCzN/a9ZaNECaeBPJb9bYQoAHu9LMgw9vvy5r7CL7lKeKdMEq5opKMJSHVmkEl4Imx6cmvsiq0OF392bk64jeQWVIdgsh7eP/42X49PV/YrxzkQTpbfWr6AxdyTbnRhxnVKxMG6CoDiUUiatg3+HsKmufpCCOHeCsFf1lQ2jhAtFTtKSwdLrvJsHPpFmNhP0h8Mf9oYLHHcH7rFC6Qc6tZp/w7YbjA0doi6OlNpXd+GouZrFyDyj9xKc2lx0RjsOJC2r2KoXJn79vJrrWoX+OR6tuocQMsz2ykhVwxV/zTYafBLiYoEV8OQs5ytuQg0OiSqCWSNHO7ruT5yz3vDDg/tujQ4dFMMvf4yQVfuzicZ7Ne0Kw1g1rJk2TXT5oVXBrvuUlLkRUiZ0cUNOW4AlgFiaTWjjW4/+8roN8DYpbPx9WhUEID/CW3pzBWmCrmdX/x8RCiZlb54O8sDgCteo5z2b/RjebnTLuTsVAmu2bsFkhieritBqnipn+Y0oN3oDalACH2bxeT0VLgpD5y3in2VqsnE0Tg9FPiMIwiki4ybnnl6b6VTUdrVVtYWGSIvdYF1ixsvOUD3ZsAoAw7kQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR0101MB4264.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(23010399003)(376014)(1800799024)(52116014)(366016)(10067099003)(18002099003)(261021121427099003)(11063799006)(56012099006)(261026121527099003)(261022105027099003)(261102123227099003)(261026140227099003)(261009223027099003)(38350700014)(261022075727099003)(261028144727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kp/PZvWThsLpXjJ/qmdJc5HBjSLKUpr5L/QJldcZ7ZAdM/7nMb5YAz1nX/CH?=
 =?us-ascii?Q?CLsBfgcSMZzaE2CyWksrngEF05FfSSdjDRUyLIeObj4paCulp0I2NN0r97oD?=
 =?us-ascii?Q?p+TsUspWgXkB8z22xZ3Di1GG/GcPHk85hx0HE7bpW7hThe2LS3VCgw8fsJVa?=
 =?us-ascii?Q?roBtKBsBQ+GW8c9r6Q2q9xCl9TRGY8LMEGu3DbZDtGfqz0ul46VfHyeV6Agt?=
 =?us-ascii?Q?zSEb62n++4WtP+55ksgVycOXanaP8dF+nGNY4sSCg4/pgoXsdSasnA48eE/3?=
 =?us-ascii?Q?6FMFy1+uARGr6jlhaBjf7vvws6KUrNMkPiYT1YUrH7S8wXBsi/PxQRBG8owW?=
 =?us-ascii?Q?ZWNC3/2OSuKyWxt/GYHsttKMrCD9O87yD+wdLUMyd6NNuhUT86Rt5d8zqpC1?=
 =?us-ascii?Q?+vyev1KDVHVTNxwdhTIhhAAfkza+PIovYhjASOK6C+i7+t9BoIY9j3Kpm843?=
 =?us-ascii?Q?nV53OLcgTWPt9WyB4LxZeg2jH2hSlVfikWPw9IZ7G+Xo8hBo0On/U90sohvY?=
 =?us-ascii?Q?XQtgbEEK+BwV48QrYoX3Z5tJ/LIzMBEbpJs1G04MDLO+dqphZivUQVKb89sT?=
 =?us-ascii?Q?LYnFOAMaa4Q5n+Rgs5AEZOA0XNt1l7Wg63dgtGmDnK3oY96c2Sq/88tMEbxk?=
 =?us-ascii?Q?JkODPAqC7vXXGLJdxTrbsPhBv6zVJBgwH3+0KSn0/aiCD0SjdvIybvFPO0ox?=
 =?us-ascii?Q?76wcXEBdMOdhrhX0ruW4a/SDGn0IlZTq4u64b2Y9I51DbUy8mXLOZr3y9oeF?=
 =?us-ascii?Q?L6aqbrAkNrpYd390SgItkMqPdekxhRThuR/ZmSE+0h+y1sNkK5/MFf126+SP?=
 =?us-ascii?Q?jUeOEQ6E7DBpybjmSl1vSjjSBC2W3m9rYlo3J4/0koEDgefAK2GONWjXKgdz?=
 =?us-ascii?Q?2k8csI9JyuRVzAyTl+XZSb89dVUQ2OUMdBDupXkDNcDC82dit+fXCGcRtzDq?=
 =?us-ascii?Q?BPCXBWOkYZpX+U/yg4eYyKon43mv99uo77Z9LeoPrcG/8uYHAwvfrx+AQkrJ?=
 =?us-ascii?Q?mqCskick8dpWat6+dSmH0ff4ZwAKMNC/+fOhifZSwgtVb8hsPOnrLMDDkk6t?=
 =?us-ascii?Q?MBNtsdwKPaaeShsRKVCleV7J+7RXx1G9kPvTK3EgtNhveuct6AP09+s4z1ux?=
 =?us-ascii?Q?a2u1Zv0hWNS+cFhrdpQZ3qy1rwV/XO21P5kNM1CFlqXa9mF/3Mw5UTD0V9PH?=
 =?us-ascii?Q?IkxYK5RTqTzYH8weE1ldCWacTQT8qvhfwjxzt+4ZFe3Wju5xsGGI++ly0Cq4?=
 =?us-ascii?Q?lQ3xfRmEjC6q24G0kbM0iOlYPAm19lGyvnmOzoKujFhwnWBRY4ztbs9QPgFI?=
 =?us-ascii?Q?JPTDr938C2M8vMZnYoAN/79zWaUFw9qilnw+qF5iaaZU3hFndAgaR0IL/z7l?=
 =?us-ascii?Q?KLxhm8skj3R7LfR6Wa0EJoaAXin/WherAOD0jNqRqYFUorNJadfRLpQ7hFDQ?=
 =?us-ascii?Q?02ei7GOwH4oLuUOH6B2RGPC7Zc1nmvH65tbsCqiMYGeCCFtiGCDAwTweZnBu?=
 =?us-ascii?Q?nsixRtVsWHef0qlCxVjxeQzvgpzB0JrhgbmvKSbbVW9ii5R48g1aicccjqEu?=
 =?us-ascii?Q?U25FPhDF6nLKOdwIa77DBWrP67G/urEq0WMF1KzHPenFUKb493/4UNOcgZU3?=
 =?us-ascii?Q?G9/tOZT7qAPROgTAAAPOWT5UW+iSffA8PmisQMmP3yJ3NJ5mv0y2sXJ4mVAk?=
 =?us-ascii?Q?pS+w/UOUgSOCGqxLI4lrXuk/pVuuzJxNe0A9DKpcFqqMJPHZahW5FiiHy39l?=
 =?us-ascii?Q?iWm9VYsG/w=3D=3D?=
X-OriginatorOrg: smu.edu.sg
X-MS-Exchange-CrossTenant-Network-Message-Id: 336deba5-e3a9-4a70-026f-08df3bd5ac16
X-MS-Exchange-CrossTenant-AuthSource: TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 07:15:01.2994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c98a79ca-5a9a-4791-a243-f06afd67464d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZTqH2CvJfzWy4amBwpwi+MBBZXJzIagvMO4eUf8/SykOg54UC1eKmpnVWSq5argLeFz71Efqx59q+DU1I/NUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR01MB4999

qedf_fcoe_process_vlan_resp() and the Clear Virtual Link (CVL) branch of
qedf_fip_recv() walk the FIP descriptor list using fip_dl_len and each
descriptor's fip_dlen without checking them against the frame:

 - fip_dlen 0 does not advance the walk, so the ll2_recv_wq worker
   loops forever;
 - in the CVL loop, a descriptor longer than the rest of the list wraps
   the size_t rlen;
 - a fip_dl_len larger than the frame reads beyond skb->len;
 - the CVL MAC, Name and VN_Port ID fields are read without checking
   the descriptor length, and the FIP header itself is read without
   checking the frame length.

qedf_ll2_process_skb() passes FIP frames received on the LL2 queue to
qedf_fip_recv(). Before walking the descriptors, qedf_fip_recv() only
checks that the destination MAC is the ENode MAC, the All-ENode-MACs
address or the FCoE data source MAC, and for a CVL that an FCF has been
selected.

Drop such frames, using the same length checks libfcoe applies to these
descriptors in fcoe_ctlr_vlan_parse() and fcoe_ctlr_recv_clr_vlink().

This issue was found with an LLM-based analysis tool.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: stable@vger.kernel.org
Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
---
 drivers/scsi/qedf/qedf_fip.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Compile-tested with W=1 (x86_64, CONFIG_QEDF=m) on 7.4/scsi-queue.
Not tested on hardware (needs a FastLinQ 41000 adapter; qedf cannot be
built for UML KUnit).

The header checks and descriptor loops were copied into a userspace
program and run under ASan on an exact-size frame buffer, with and
without this change ("hang" = still looping after 10^8 iterations):

  case                                         before     after
  VLAN resp, fip_dlen 0                        hang       dropped
  VLAN resp, fip_dl_len > frame                OOB read   dropped
  CVL, fip_dlen 0                              hang       dropped
  CVL, fip_dl_len > frame                      OOB read   dropped
  CVL, VN_Port ID descriptor too short         OOB read   dropped
  CVL, dlen > rlen, list inside the frame      OOB read   dropped
  FIP header truncated (20-byte frame)         OOB read   dropped
  valid VLAN resp (VLAN ID 5)                  vid 5      vid 5
  valid CVL (MAC, Name, VN_Port ID)            3 walked   3 walked

This tests copies of the code, not the driver; the reads are beyond an
exact-size buffer, not necessarily beyond a real LL2 skb allocation.

The patch, this description and the userspace test were written with
LLM assistance.

diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index ad6a56ce72a8..b0dfb81be605 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -88,9 +88,13 @@ static void qedf_fcoe_process_vlan_resp(struct qedf_ctx *qedf,
 	fiph = (struct fip_header *)(((void *)skb->data) + 2 * ETH_ALEN + 2);
 
 	rlen = ntohs(fiph->fip_dl_len) * 4;
+	if (ETH_HLEN + sizeof(*fiph) + rlen > skb->len)
+		return;
 	desc = (struct fip_desc *)(fiph + 1);
 	while (rlen > 0) {
 		dlen = desc->fip_dlen * FIP_BPW;
+		if (dlen < sizeof(*desc) || dlen > rlen)
+			return;
 		switch (desc->fip_dtype) {
 		case FIP_DT_VLAN:
 			vid = ntohs(((struct fip_vlan_desc *)desc)->fd_vlan);
@@ -183,6 +187,11 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 	u64 switch_name;
 	u16 vlan = 0;
 
+	if (skb->len < ETH_HLEN + sizeof(*fiph)) {
+		kfree_skb(skb);
+		return;
+	}
+
 	eth_hdr = (struct ethhdr *)skb_mac_header(skb);
 	fiph = (struct fip_header *) ((void *)skb->data + 2 * ETH_ALEN + 2);
 	op = ntohs(fiph->fip_op);
@@ -229,12 +238,18 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 		 * if we want to reset the fcoe link
 		 */
 		rlen = ntohs(fiph->fip_dl_len) * FIP_BPW;
+		if (ETH_HLEN + sizeof(*fiph) + rlen > skb->len)
+			goto drop_cvl;
 		desc = (struct fip_desc *)(fiph + 1);
 		while (rlen >= sizeof(*desc)) {
 			dlen = desc->fip_dlen * FIP_BPW;
+			if (dlen < sizeof(*desc) || dlen > rlen)
+				goto drop_cvl;
 			switch (desc->fip_dtype) {
 			case FIP_DT_MAC:
 				mp = (struct fip_mac_desc *)desc;
+				if (dlen < sizeof(*mp))
+					goto drop_cvl;
 				QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
 					  "Switch fd_mac=%pM.\n", mp->fd_mac);
 				if (ether_addr_equal(mp->fd_mac,
@@ -243,6 +258,8 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 				break;
 			case FIP_DT_NAME:
 				wp = (struct fip_wwn_desc *)desc;
+				if (dlen < sizeof(*wp))
+					goto drop_cvl;
 				switch_name = get_unaligned_be64(&wp->fd_wwn);
 				QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
 					  "Switch fd_wwn=%016llx fcf_switch_name=%016llx.\n",
@@ -255,6 +272,8 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 			case FIP_DT_VN_ID:
 				fabric_id_valid = false;
 				vp = (struct fip_vn_desc *)desc;
+				if (dlen < sizeof(*vp))
+					goto drop_cvl;
 
 				QEDF_ERR(&qedf->dbg_ctx,
 					 "CVL vx_port fd_fc_id=0x%x fd_mac=%pM fd_wwpn=%016llx.\n",
@@ -285,6 +304,7 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 			  fcf_valid, fabric_id_valid, fc_wwpn_valid);
 		if (fcf_valid && fabric_id_valid && fc_wwpn_valid)
 			qedf_ctx_soft_reset(qedf->lport);
+drop_cvl:
 		kfree_skb(skb);
 	} else {
 		/* Everything else is handled by libfcoe */

base-commit: b8d0bb6a8ba0d3878940a914a19336844101867b
-- 
2.43.0

