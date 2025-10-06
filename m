Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C75262FC0;
	Mon,  6 Oct 2025 12:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759753885; cv=fail; b=sQTzkakOZsXzd4BFd4wPK+WxwxOHgK7M7w92bd/1K68rJ6107l7qk4d7sv8bk8ZCGIxxlkLIysroGciMqKqcFTLnYHFYRO3vB2Ci3T12sHKgkz/vgQoixmqLGZ7kFOOChcKKRdgqoed1IR7RPITjVMq9m3EZ9ErAbIoH299/rPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759753885; c=relaxed/simple;
	bh=baFIg+AOOx1h/0Ssiq7TpWYauLqYwVk+xaQLcIX/MLA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LiiYlxNEojy4+vWtIZwbjbiSVR6UqMU559Saj697+RgWuKIEaxOr7aFnITYhqhus5GgxwoRyLev3a8dgSFd5XAedhMMGWUEd3aDM8Bn1vdrYu00GzwizR1sWJEh8qadcXwxXAS8MpAqjhsKtPz9fk7Myw4QrnFpJ8NVjtzQlOtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CK8FYbb8; arc=fail smtp.client-ip=40.107.200.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CK8FYbb8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lllhlhajo+laVN8lR7W1RlBAY1FoendCZVHkcnPsAIVIYvA+uFrErfZUQebxEgAzXZ0Km5bJKFhDW0+slhTI4TWjX6jYsBVh0k4ELYwpBt3sn3UFJAUTgmg4cqbiYoKajT9EEAcoblaaxf8KAU+pVOAIN7RDZdDrrTOGtWYaMMNxdrsf+I+V1qSrm31Qqx0mjVnM+MkTUp5QQbIFd01PBVG47GQWDLbUqfMK1oXg/bElh0ZbHmIDkzv51dJ9k/NXbyG9UZayfUSbpQfvLYPigMYTS8bNi2PfLtVRtBng+1F+XqwN5YJ+xmhuwiXNC+bOqXzUMZ6zdpAZVAuZD8o5gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbTH2Zq7/hCGE6HebyODRcztI/lnECpKl0VoJ0L0HtY=;
 b=xEVOHAz2l9E7YdAJeqeE0hu1Yu9X4K4oMN9D7TtCyiWgtIpIMeu8dnE/g2pKD9wYOXqKYn5PvV6uwE1slJUuunTghyDtLZSDQWo1U2F2P/wWgMm8//c/0cfPuf57oJgglLycXRt/mOMWP66cBwsu/h5KYs0wSQsiFrPJu6xwG329SjZpogOxkOU3zYwm5cpm+BhSJP9PfF88w2tog197sSHBIgEgsfn04B/rffAc90rcpBpD+O0uQbp37jwFbVH4ql0wvrm2ZfelEiKyNwnfv0+Gj0Ciuc62PI5YW9px1IcDo5Ygye3I5mBjIGdKvXdbxkPxSwU5xdrw+cKiuHNiiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbTH2Zq7/hCGE6HebyODRcztI/lnECpKl0VoJ0L0HtY=;
 b=CK8FYbb89xBzvWopGfk5NrFBNh906z8DotyGEdiluip42GvrcIhSIu5M6mk6GgOQmpKXSyqj3dKKedr+K6Hxn0qNcqz9SIUhA7+cMzp3Ypf85ZtlW6kf2MkibKNG5gd3gbBTxoP8VC20qMZ6yF9qZ7aqP82HedZd5iuHLhluJMI=
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6933.namprd12.prod.outlook.com (2603:10b6:510:1b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.17; Mon, 6 Oct
 2025 12:31:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b5c5:3390:35bc:eb9f]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b5c5:3390:35bc:eb9f%6]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 12:31:13 +0000
From: "Neeli, Ajay" <Ajay.Neeli@amd.com>
To: Rob Herring <robh@kernel.org>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "git (AMD-Xilinx)"
	<git@amd.com>, "Simek, Michal" <michal.simek@amd.com>, "Goud, Srinivas"
	<srinivas.goud@amd.com>, "Pandey, Radhey Shyam"
	<radhey.shyam.pandey@amd.com>, "Potthuri, Sai Krishna"
	<sai.krishna.potthuri@amd.com>
Subject: RE: [PATCH 1/5] dt-bindings: ufs: amd-versal2: Add support for AMD
 Versal Gen 2 UFS Host Controller
Thread-Topic: [PATCH 1/5] dt-bindings: ufs: amd-versal2: Add support for AMD
 Versal Gen 2 UFS Host Controller
Thread-Index: AQHcKWJxIOB0aY7Zpk2EHMe+jthb9LSfoGiAgBUbX6A=
Date: Mon, 6 Oct 2025 12:30:57 +0000
Deferred-Delivery: Mon, 6 Oct 2025 12:30:00 +0000
Message-ID:
 <LV2PR12MB58690ABF92ACB3A33AAA75B08BE3A@LV2PR12MB5869.namprd12.prod.outlook.com>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
 <20250919123835.17899-2-ajay.neeli@amd.com>
 <20250922194629.GA905336-robh@kernel.org>
In-Reply-To: <20250922194629.GA905336-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-10-06T06:15:25.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR12MB5869:EE_|PH7PR12MB6933:EE_
x-ms-office365-filtering-correlation-id: 2a229fa6-a595-45aa-4d27-08de04d43cbe
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?XJqzk5GR3UZ/myz81h+QgtDSW3fGt34VJcBgmeaaNmg+XlROL4MQWIQvJpgI?=
 =?us-ascii?Q?VJz2RAcUxuFvmoyJAq7r93BRLBwnQzkDq4aiPU5ubefmI+FMjzB3DcLh71+O?=
 =?us-ascii?Q?hSwzRrSGhsPZ4QfCnfZ1nq1Xd7Vj4yykadzUoqG6r/WRg98hResEa75H+Gi6?=
 =?us-ascii?Q?2EGwYVSCf1AcEguYrdFJXTMXQoeBUbIpH7RL+uUlX6iVlUnMLV4ilZmlpghZ?=
 =?us-ascii?Q?vm78rIJRh7QAbo4gmjXs5jEfq31F6nxanRjZBNpfxmMpqQfyvZxGQ+soJ9Y9?=
 =?us-ascii?Q?WZSfririGbegvIzFTPliGAifiaXeFvPadMz3YNofaeNhGoGt4ttL981N0PGF?=
 =?us-ascii?Q?Ijdco88LSd3fuSpnAi1ivTlnIZna79x65FNh596yAIryubY6sN/TG0arEyk/?=
 =?us-ascii?Q?VRCSsr0fKrFqBgCpLRo4xZ96Oj4Nf54RPqrkqFKUi+r2eHQ2LmldXUuig+KS?=
 =?us-ascii?Q?jA6AESqMViyod/qx0dd8F9gB9wD3EEplpelsmt1qar8FCmdSZgPfQnPF7FVk?=
 =?us-ascii?Q?BJeIboqe1Vvw1vFWNQlu/5OD1yzOUDbIixg7JYHDQdSaqn8YoSy75JkxpGXJ?=
 =?us-ascii?Q?H6jbkd4HwbNcAq74Y2GMVQnj7u8jaPsdagP6Lj/eHMwpmN6jJBKzGKHg7ozK?=
 =?us-ascii?Q?XB3G4KrNzp8sqjEUpIg5Xcp1Nih28pA0KLbXj0bQUvcHjdRVg6qaxrkVsGcP?=
 =?us-ascii?Q?Q1UFlCwGyuR9uQ1cW/3LK/s/fb7tNeoBGe91kp2D5F/0EvRVrQbPxMgv6BoW?=
 =?us-ascii?Q?KaS+2lnIvTAD+2kesrADX8dUVVlV1eJZQI3LQ2A469D4JSeoUHfRtIbn62Q2?=
 =?us-ascii?Q?iZxpsMmxkD8kCKZC627WDirHbECOSVd3DpcohEATxxJdP0zeGuNTCpZiPs+P?=
 =?us-ascii?Q?2ppFStKTLKAULPO9SaKK+Nj6EmqqElPb/MBDFloi5nXzkg4bR4O93CXGpRMm?=
 =?us-ascii?Q?YKE0Fs3Fmzkr/Z+GrhND4u090n2fRzfNASqDFNrLEJz9AIlYouI6uyXcGAzc?=
 =?us-ascii?Q?ZDwRefk2waimny4n+RB/Y+ErkXQjB88MmpCLdDUcMyw9HqO+xwRKKYe6mfX0?=
 =?us-ascii?Q?3xsfgY1k0tUPFI69o0Nu5sq9tO46Rm88iuYYiJOZeqQbfpc67CS69tDe5zZ2?=
 =?us-ascii?Q?WNAUcXxEnoirxqFsR435t+bsByBeXRz042OYq6kovhJgeCNC0BoBqY4ipuA/?=
 =?us-ascii?Q?M71sVGpgYhOcTbvC3awzxQBl2MhWbSLtsEHj//mA4+tRRyMBllBvdCypucdb?=
 =?us-ascii?Q?oxInBpzLYOAeVcsYJJiX6DFiPLJi17UTzWhIhsT9ZFyUBXsQiNhRs2N+BjdV?=
 =?us-ascii?Q?r3D9/uUzl/19VxszEeJX2jjuyNOzQeSum3Lvi1oCHdhkY37CrlnPWvqZ7SNi?=
 =?us-ascii?Q?seRx8El+wo9KrT36NazSexXtNy26zRd8nncf9wrxEvtpxLDZFcSW63v8S0Lk?=
 =?us-ascii?Q?Uq8V9ySXmFrgrv1UVdCo0ufIxndjxhgH5G33MH7ff/yfPZGiGArDdA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0qZc14CNMSdhYRwrZZatE2BfISw+li31XcYh24Pq+WWP5exTh+BrHdZMN8c4?=
 =?us-ascii?Q?uidIlXirl6BHQK41Dl0Y8x7XpBI2X5UL22V5oHi/xlevNMx4qamFGhZYquAv?=
 =?us-ascii?Q?VD3yrp1kEOUU2nt63fEC6Y2Lzi4BalC0JgdiB7Wb/I/Qom0lmKOzt1t81jnf?=
 =?us-ascii?Q?ry9d0fUawBBuciEIKnyWN1zqIFDOAgPjsYkHThvC84FMrsr5S0XB/RG/NQsQ?=
 =?us-ascii?Q?kBl+7NvqjJE09pL9IYAZIGEzpLuTyF22PUGiLk4UwW6p0YWLPt0Po+xJfmWs?=
 =?us-ascii?Q?DokW8vakIC58Lmr4CH7YUKzkqkMRXuptGNR8rjJ0UcHPE8rUAO7pxlkDnWFt?=
 =?us-ascii?Q?0HWM1Zx+zavscNsAqOFWYH+pyDtnMPjVTinVyKfAWtX2hMDPkJ2vRS3tVi1d?=
 =?us-ascii?Q?V/NTSfhNv7rcVRU51IC0U55w1RgyPblqdWLKz2XYGRkfBoexC+ypwiaBgez5?=
 =?us-ascii?Q?XstYVWw+28gAcOqFXsriPEujmkdIbXgPVQwUbGBPjMGNrgwRBPfBq7Jd3wpj?=
 =?us-ascii?Q?QhNzLmhmp7Edv2NwIh0UU1koeSvJtXwJUa9IWot7fRcvE8JSvTfZRiQ0pFqq?=
 =?us-ascii?Q?omXo+2xuXd6E10UBpLkPwoDXeaQnj/mNvbzPmt51v/EycIPdtKm3RgO9S2yC?=
 =?us-ascii?Q?aQNNk0EEsP5tKYQet2IiXIMzGeWg+3AdqJq06y4H4kXHDNvvirNseFVniZ4r?=
 =?us-ascii?Q?+WbyyhfsPZwD148XpphKxq0HOSkAq5pSJz47r84cOKuO0jxdznj8oUN94gyy?=
 =?us-ascii?Q?LafC4s951MUoVu11jSZA02wneRbwXzli8/tMgdhsY0BgnhwiATBgI1lkbw6J?=
 =?us-ascii?Q?wUJ6ypyFsrg3BVc9fwASVMEOaXKE2RFyxhFC68uq1Ir10N3W0qBnqmmzPoqJ?=
 =?us-ascii?Q?lz8pKyGMx+trBCRuF87/fSQVsw9WeUMactrgi5EWzjynMcmh3ywtik1cuaBD?=
 =?us-ascii?Q?Xf8nbGNS9STEwcPvDVU4UIigsi0dP5wwS2AsZTlAbsOA2i//KJNUjmYccTHZ?=
 =?us-ascii?Q?wcHV4944JcCIn1j471pr3uY95Pp4wzKLvMIX73mMThxmL94GJZbEmIieiceV?=
 =?us-ascii?Q?CxVMzSfmvMf3kSzs2qfzqY1qJJfsfQnKjbbw3jmICmdw8gNHkJ8s4oQ6I/IV?=
 =?us-ascii?Q?XPuvnhxgZUSDdj7T1L8xvYyBaivwTuUCkE1uZ/RRiEvQ92dXodUAOGTwbZur?=
 =?us-ascii?Q?r9Lbchd7KNdNfUxsG5Pp+M66AmoQ7HNYgOaVCsYNPN2N/waZFle+R2gtQSM+?=
 =?us-ascii?Q?ckz4lMjW8QXG4Uio5cEdSVA8magr41YMm95uOgLmMIaGXO6O1djqKWHG0HPO?=
 =?us-ascii?Q?vQaZhPwIvQJTrsupzw5cZYj3z4FyyBRHMl0L6TYdgW5bcaUlZCHREYcbbhOp?=
 =?us-ascii?Q?81HxBvI8aRiu/zUhX9xK2xcPOEhi75c6fKFCue/AHbEoahxm4RCX3zR1k9xp?=
 =?us-ascii?Q?LKyi4yXNJicwQgPME+onkhRKYyrBN3jeqTKIMWHQsmAWtHEKLqL2SnrNjmZv?=
 =?us-ascii?Q?WDWSlu4bQzFWC3o9nWD/qCpXXaQI9a7iMLARpCUdzc+fSqwIuVZjoi5548CR?=
 =?us-ascii?Q?SDCuMMDvnzP5fGStqS8Y006ZioQ0Urh4DJd4yFkH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a229fa6-a595-45aa-4d27-08de04d43cbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2025 12:31:13.1222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eSo7BjtA/IntUxI/Xt9AVGUrkGlm2uJwBxlo1PitRsH5+Je3c/V73v0RfGr5beJWjEK9KO9KwrrLQbpbDXdUNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6933

[Public]

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Tuesday, September 23, 2025 1:16 AM
> To: Neeli, Ajay <Ajay.Neeli@amd.com>
> Cc: martin.petersen@oracle.com; James.Bottomley@hansenpartnership.com; kr=
zk+dt@kernel.org; conor+dt@kernel.org;
> pedrom.sousa@synopsys.com; alim.akhtar@samsung.com; avri.altman@wdc.com; =
bvanassche@acm.org; linux-
> scsi@vger.kernel.org; devicetree@vger.kernel.org; git (AMD-Xilinx) <git@a=
md.com>; Simek, Michal
> <michal.simek@amd.com>; Goud, Srinivas <srinivas.goud@amd.com>; Pandey, R=
adhey Shyam
> <radhey.shyam.pandey@amd.com>; Potthuri, Sai Krishna <sai.krishna.potthur=
i@amd.com>
> Subject: Re: [PATCH 1/5] dt-bindings: ufs: amd-versal2: Add support for A=
MD Versal Gen 2 UFS Host Controller
>
> Caution: This message originated from an External Source. Use proper caut=
ion when opening attachments, clicking links, or
> responding.
>
>
> On Fri, Sep 19, 2025 at 06:08:31PM +0530, Ajay Neeli wrote:
> > From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
> >
> > Add devicetree document for AMD Versal Gen 2 UFS Host Controller.
> > This includes clocks and clock-names as mandated by UFS common bindings=
.
> >
> > Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
> > Co-developed-by: Ajay Neeli <ajay.neeli@amd.com>
> > Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
> > ---
> >  .../devicetree/bindings/ufs/amd,versal2-ufs.yaml   | 61 ++++++++++++++=
++++++++
> >  1 file changed, 61 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/ufs/amd,versal2-u=
fs.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> > new file mode 100644
> > index 0000000..9f55949
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> > @@ -0,0 +1,61 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/ufs/amd,versal2-ufs.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: AMD Versal Gen 2 UFS Host Controller
> > +
> > +maintainers:
> > +  - Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
> > +
> > +allOf:
> > +  - $ref: ufs-common.yaml
> > +
> > +properties:
> > +  compatible:
> > +    const: amd,versal2-ufs
>
> 2 is versal2 or gen 2? I read it as the former, but everything else in
> this patchset says the latter. compatibles should be based on SoC names,
> not versions. Or does "gen 2" mean Gen 2 UFS specification (if there is
> such a thing)?

Both "versal2" and "AMD Versal Gen 2" refer to the AMD Versal SoC generatio=
n, not the UFS specification.
As per AMD team guidelines, we use "versal2" for short names and in compati=
bility strings,
while "AMD Versal Gen 2" is used in commit messages and documentation

We will maintain the compatibility name as amd,versal2-ufs but add document=
ation to specify
that "versal2" refers to the AMD Versal SoC generation, not the UFS specifi=
cation.

>
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  clock-names:
> > +    items:
> > +      - const: core
> > +
> > +  power-domains:
> > +    maxItems: 1
> > +
> > +  resets:
> > +    maxItems: 2
> > +
> > +  reset-names:
> > +    items:
> > +      - const: ufshc
> > +      - const: ufsphy
>
> "ufs" part is redundant. Drop.

Sure, will drop

>
> > +
> > +required:
> > +  - reg
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +  - reset-names
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    ufs@f10b0000 {
> > +        compatible =3D "amd,versal2-ufs";
> > +        reg =3D <0xf10b0000 0x1000>;
> > +        clocks =3D <&ufs_core_clk>;
> > +        clock-names =3D "core";
> > +        resets =3D <&scmi_reset 4>, <&scmi_reset 35>;
> > +        reset-names =3D "ufshc", "ufsphy";
> > +        interrupts =3D <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
> > +        freq-table-hz =3D <0 0>;
> > +    };
> > --
> > 1.8.3.1
> >

Regards,
Ajay
