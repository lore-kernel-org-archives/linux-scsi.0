Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022081.outbound.protection.outlook.com [40.107.209.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD5B31F99D;
	Tue,  5 May 2026 23:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778022814; cv=fail; b=ccqdoQrmcECrvps+XQi67/snO3ZhyhkrS2pgfWGXHgeuWxtzb6LgkiWyZv1bqS7qw5CMmVNfH/JodF1odyTVpOpLrAx86U7Wj958UmJ/qXOPYbzqg/k9yY21GQGD6VIYVqt6O2u7hCPnPFRaZfNw5tPcXDg8xP+GlsY53wxINpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778022814; c=relaxed/simple;
	bh=2IqOIYx4Lv4LQ2AodlrnVJPCJ7H75Km5Kmmdn2+UnoU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ba4osth5iZdgQe9Qss/1pzbPICZiVbrZfB7shDrKeCwjBlvhQq9C4Kc2jGohY4PTTg9ew6o3Wq7qJ3AjoCuHhqid/dSFJvGdsrakEv8JPfLHjvUKY0Qhh4DLhnN6XEbf97BFMdFrwcMtZDc6PXUQSjpZ84LSU25ELkydpPH6utA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=MWDQWEp8; arc=fail smtp.client-ip=40.107.209.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="MWDQWEp8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSkDP80AkQyV9jvYo18UhIzKYjb3h6/dZ/MQ8kZwXJJjDqiajh1/zgSbxaukGecQ+UF7l6nkd+CdoOvUYFHW/JN1bDVYnrBGVx6KOL6w0SfHjyWmIfPihOXtCmekPFGwjgiindErgn1dU+5FngHz2Ag93jLkwLU2QJlbYsHN7Bx8GnNW7Fc/8XclS63dIJCCr40Stw49gnIFUQyy7+NJESvPvfYT4H6d8l4UUaGiK8NaNh+Yso0lCz5vTua/pFU2+2cyS4loKhC3FhVZ/Hro/aEnzLdBVPAB1gMgM3IzOTJsCWmXjNJdDU0ouWQgHr1lMcMbuUeIEckga2CGH/H1mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbKFXgfB3/yrIjdvnMGRJQ7+QkvgOIReeOBQj4QZhHw=;
 b=AGlQ+4ct3HTjO7F4nQjxxPx9Q8UVHKfvwI3X1we3dJl2yqE7cwfLguCkX30+Pb+FDDNgkj4jXPCCmgHxieTKZBa/BPrQxfOUoaDeLT1gbaSa20QywfH25JFDEVyyvpCXo8yQC5FOVD67Nrr4kSGMoLnR0lzOIE7kFt4hIuVtSL4D1O+L9F5wSwvTFa0QzjPT3K/lCFoq52Z6LNjb2nl8RwUvxbD3w86vwfV8PHqIa5JXzcPPR2/yGlM5johHS0qPcFL57LUEM/SEb1vPxa/irQvlVKUTBWVffUO8jPVZr12vlo3zMfvdy5KEL8uptuEOUQok7sN1DEe7wY+NC96zuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbKFXgfB3/yrIjdvnMGRJQ7+QkvgOIReeOBQj4QZhHw=;
 b=MWDQWEp8cFCiLrd7zgUyGsUKUaskuD+MGzvPQ7zj1SY0qVHOOtEL+Qggk2KUfO/JUueZnhkL3k5YVPVfSxfrrfK42lkHBBSgz81tWguZXVsfvko74wG4P6F4DAiDfOUVFrIr/vS6dPwdZzwemWVWZoeYXAW/Cu/tX58MID/g2sU=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6753.namprd21.prod.outlook.com (2603:10b6:806:4b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.13; Tue, 5 May
 2026 23:13:30 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::879f:eec1:ca0e:d219]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::879f:eec1:ca0e:d219%6]) with mapi id 15.20.9891.008; Tue, 5 May 2026
 23:13:30 +0000
From: Long Li <longli@microsoft.com>
To: Md Shofiqul Islam <shofiqtest@gmail.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH] scsi: storvsc: Replace symbolic permissions
 with octal
Thread-Topic: [EXTERNAL] [PATCH] scsi: storvsc: Replace symbolic permissions
 with octal
Thread-Index: AQHc3OH8zueBsqfOXkioWnp4NjsmM7YAD4jw
Date: Tue, 5 May 2026 23:13:30 +0000
Message-ID:
 <SA1PR21MB6683F45CFC641AD530A7193BCE3E2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260505225321.6785-1-shofiqtest@gmail.com>
In-Reply-To: <20260505225321.6785-1-shofiqtest@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8702d200-6a45-4aef-a525-b4f3008a85fb;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-05-05T23:12:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6753:EE_
x-ms-office365-filtering-correlation-id: 41bcc08b-1b9f-4477-ed48-08deaafbebbc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 Nirt747lp3oXRXjajruNTaFaMatbdCyCg0xYYmUprhfxcHfvUpQtaZDxnNQCkC7X9cyTryDLKBLe0FT+r8XFaXU+gea2+7STMjItteGSD9TMpqK0q6/FH1RwIHzinqWIpyv81QYKtE+DoezmfyvC1nqJzJdetiYqphVDa/8pcF4a2WUDdoW4IcuT1hAMi2ZysMjw/Pqr7722vuzI0xrs0Bzsf114aHFNFYBt54QyF190cVjFGGSj87WFGiB4fjt43RueZ7tdr8PlIynp2UUzRCsLcso9lxr+rbTqpYMOxTJHJzd/k56PyvK5QGX5a2ExH0Oql/QoQK5n76ByBoAvCt1evMv3DXbo3uhu1yxuLv/9HWgwPsTWVcXfdZJxE48pkOMXAEiX6fELCo9TcuUlIMD4heJQET7lC22s/ewnFJn8Q7VYrAIr3A3Jv9pjRXzPwqH9IomPjBW5UAtiSHvqhdetz3xpa+NLIjrTWBbHwEcDt2e9VuIm6Hevi20BR31t9PxrBAYYjm9MKtrswvLN1dWNWkm8p2FsQs+IDQlZKgPoDG9AEONkQ0tWZyjq1luzg341n6qqDauXUcLRRvFwmX8dcvkTUztIMAmWYDQHg2Esym/wheXji/TRgGYP8VMFu5sLktzCRlO18sfzb4MfrAwkn+IQhLj/5RAB/FeOoVEzwUSp2f3dPc7S9EXNFnQQtTJSNV3V0/DYuLJOrDwyg/UDca/hukTuk9xo7vJdtRE4UY7jHiTyjCvYil2qiULG
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Tp7DYdhz/2ufLXVUkEvaN+MmUeKRT6fPomnVapt8GzldHGJ3OO72GYgq2mfg?=
 =?us-ascii?Q?bzli+PuC/OTSHQHtX78FteGsYjiK6ayb/pGm1hU8TIzAfehMXRJHh1ILxhsk?=
 =?us-ascii?Q?SgAsILZbTXkhGAZmx6Y+0H6ijP/TEUlJ643P0TuqzGaW4uugpDrs0SHzuGEO?=
 =?us-ascii?Q?/VQjgGhG7GxXTMvJUtSDI5swQxoZeBIuT2jL+u790/96YYDVW94353Sp9GfI?=
 =?us-ascii?Q?3EpGs5N97nbUsnLxeI2f61hLovHOdjq+ONThjjknpyRmStXRClAoxVHBe08E?=
 =?us-ascii?Q?K1QrglHYfYue8mlXlkVtkpn2upn1KGg9UGVMHjXaYAydfs34tkyL3gZ4TeLu?=
 =?us-ascii?Q?a7Ty+S9T6brGOqnKpuyvtcwvy0AOjzBN+AsqZuadLMO4gp96C0gQDr2XURue?=
 =?us-ascii?Q?3G96uOYbw0/4W5UwaE6pl5sACBU7QNrSVh9wIn7Iwe40VV8KD/JP8pdFmlzN?=
 =?us-ascii?Q?KyjrT/1pFeOKARm6kzSLTWK/I1m7ZDThZu4iPmmMKLYus+Cs/RUpuImFWkDy?=
 =?us-ascii?Q?V+baUIedjCqK0Fm3Yqer9mTFrm9ymlbUuhP8frAInc7qocMdhxrr9183QTb4?=
 =?us-ascii?Q?L2tAjEMuQfon8cqPjD6rdgQyZyKPJTPO5AXnWv3qXNH3UV7hXbo1Y+rTZ4e6?=
 =?us-ascii?Q?mNvTciGDzFHm2WR4dHrcDDxBPhVEa+ZHm3osjTNPSNsK8+JdL+kNirWQln/h?=
 =?us-ascii?Q?AHK0gu0OMRAPcE3K1UtyXk8Z5aHcpB0SOxANtni/xVzTawbyu9ZNpBH/pNyS?=
 =?us-ascii?Q?fCnN92bPHELOhmPdrAPjmymW4zzBOwTe5ZM+whtGGIgm6m9TrXqcAJROlCBv?=
 =?us-ascii?Q?nTUaUfA02NnTtrVP2PZ94w4UbJ/ASEXfsKebOBOZRr9sI/QQ485w7e2TGlQB?=
 =?us-ascii?Q?B5uURXr5Ot7Vk/LEjLhdI88wAYJodcDjFlWzY4mxitsHF2xYeHAjlJeGceYl?=
 =?us-ascii?Q?stmFE1/jiHTPp5LZXSTjWwcxFhN/wbSCg3JjiDiShieHC8RYEQmAPhVT+/p5?=
 =?us-ascii?Q?mF6crYNl1ySpRRrFNMnG5nGZcEsn93IDKP4exmztZM8YelrzfNE4Rdad5+QJ?=
 =?us-ascii?Q?hcIOMfdNvD5/MVuoqajIVCzU1Jgv3bDAnEbodznus53Yc5IaVGpxBf7V6FPB?=
 =?us-ascii?Q?C01D0h00VAG0fzuLtq39ANIpvoBf1yoxThgE3eOMIPKXsmnF+SkElGl5GgDN?=
 =?us-ascii?Q?0qk+MHOuedSZcuteP7bUZENjkTibLhd18gTjLB9XoQqVfc9Avkbhu8geUdPc?=
 =?us-ascii?Q?EVCgxiYl4rfsxIk685psUGegnow/PtumppPHg8BepMcVL/iOWTyEVIBOuS5p?=
 =?us-ascii?Q?6ZVihV5BCQMXUll8tkGzcnYTRxsvZs9s6HLx3VkjsoZRwZLxOJ31OsefDPV2?=
 =?us-ascii?Q?AJMv5FNXCcW63rWp/aQWJ8wCeU/kjw+3DXNsNE8elctMxCULCS8cMRyya35Q?=
 =?us-ascii?Q?Ba1qp3u4CmI9lSY3eaGIu2p+39QyuLmCQ0wAyytl39wcv1oPEIJLrqCrzjks?=
 =?us-ascii?Q?NQzPaSYW8/WI/4+J+QXJsOdQfn7Zp8QYAviFFyekvy3Ff3Yg2v+G4Yxz1erR?=
 =?us-ascii?Q?tI7YCerWyVeNHqZdIR9GbWZweQEKXHUC3VCgzq65NuwoVKu51cKWTXna7IBx?=
 =?us-ascii?Q?o+dPw0NoyZCc4AkpxNc5U0uC51B+hpyMo4HCUZ47grj0N3GsphI9AZEa4dMw?=
 =?us-ascii?Q?EXU5ohY+MZLqfnMWGO6PEM/Ol43R7QS9HmP10MPOTDirbfjk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB6683.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bcc08b-1b9f-4477-ed48-08deaafbebbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2026 23:13:30.1219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zcRA+8V7rncT9WuDtNHlj/Er+xj+LxXndczHwRsQwWHap8wfocA0rZ0hoo81G2d4tVAlfd9trTerq/AL24g5AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6753

This patch is missing "Signed-off-by:".

"deprecated" is inaccurate - Symbolic permissions are not deprecated; they =
still compile fine. The message should say something like "not preferred".

Thanks,
Long

>=20
> Symbolic permissions like S_IRUGO and S_IWUSR are deprecated.
> Replace with their octal equivalents as preferred by checkpatch:
>  - S_IRUGO|S_IWUSR -> 0644
>  - S_IRUGO         -> 0444 (3 instances)
> ---
>  drivers/scsi/storvsc_drv.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c inde=
x
> 6977ca8a0..571ea5491 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -156,7 +156,7 @@ static bool hv_dev_is_fc(struct hv_device *hv_dev);
>  #define STORVSC_LOGGING_WARN   2
>=20
>  static int logging_level =3D STORVSC_LOGGING_ERROR; -
> module_param(logging_level, int, S_IRUGO|S_IWUSR);
> +module_param(logging_level, int, 0644);
>  MODULE_PARM_DESC(logging_level,
>         "Logging level, 0 - None, 1 - Error (default), 2 - Warning.");
>=20
> @@ -345,17 +345,17 @@ static int storvsc_change_queue_depth(struct
> scsi_device *sdev, int queue_depth)  static int storvsc_vcpus_per_sub_cha=
nnel =3D
> 4;  static unsigned int storvsc_max_hw_queues;
>=20
> -module_param(storvsc_ringbuffer_size, int, S_IRUGO);
> +module_param(storvsc_ringbuffer_size, int, 0444);
>  MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
>=20
>  module_param(storvsc_max_hw_queues, uint, 0644);
> MODULE_PARM_DESC(storvsc_max_hw_queues, "Maximum number of
> hardware queues");
>=20
> -module_param(storvsc_vcpus_per_sub_channel, int, S_IRUGO);
> +module_param(storvsc_vcpus_per_sub_channel, int, 0444);
>  MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to
> subchannels");
>=20
>  static int ring_avail_percent_lowater =3D 10; -
> module_param(ring_avail_percent_lowater, int, S_IRUGO);
> +module_param(ring_avail_percent_lowater, int, 0444);
>  MODULE_PARM_DESC(ring_avail_percent_lowater,
>                 "Select a channel if available ring size > this in percen=
t");
>=20
> --
> 2.51.1

