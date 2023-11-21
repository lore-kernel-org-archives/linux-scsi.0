Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c7fspq/E";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DmkfVtoW"
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B57394;
	Tue, 21 Nov 2023 01:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1700558894; x=1732094894;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TK4daTsTWzO0o22yiK5QGLiaAOh4HOC2Drk/FY8Z/vU=;
  b=c7fspq/EtQnKb/Ubvs/LaMe9vehC9td10fCYFhYLthrlqM9RUZafUnN0
   6r5iQFlQBdq07HBJrnHFNPdA2isl7bj9qhVl4NK3Dnpx/lkkViLWUj9gz
   Nlue3OHRw2qxaczZzLsxH90OTpkJuvnrEdxzpmExNsbAp8Rr/R11doC94
   D/NyvoMfCYRkUao1GelyK2hb5+IhEEAN05e3U/WSwRLU6rASZ0P7AIy8Y
   cFodb6bFPOnHhm4IrJtKJlXuzZNPCJYfnJ78l4cRooUZnjnbvfvov05D9
   suuMsOxyoje+R5WVzP79S2cScepI5xmyv21TUAjhg2Rp9aNpCEqLm2PuM
   w==;
X-CSE-ConnectionGUID: O9SRw58CQb2PgS1WzAxxmw==
X-CSE-MsgGUID: CXSQdZWhQvmQciWcuw/Pmg==
X-IronPort-AV: E=Sophos;i="6.04,215,1695657600"; 
   d="scan'208";a="2912972"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 21 Nov 2023 17:28:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVKiY0keBb87nipeN8aNuHBe3RwCEzbVEmXJj7ZiM4kHNrotNPMcYta7/QerezQRUjsnxrYkcUjPFgojs+AqMB9ziK+V33/oFnn/gPvOwkFjuceuY/IP5fgXVP8FEHlyptJfkm8NLSq0fdLave1lASvr6Js+pudw2pp4gIm2b1JrknCgVCZQ/X4yLbgU3sf2a5+0jkhe7xhK6hiMOHAX8pi2Fpc9QwSwlJScQJsPo7Q0kkmwSmxgwxF6j3niF9TkkqpfM0PveH0ziu8FlOh8P/sSPqDSxT6FfrJzyevK3j8xWRtPe+UnRia9yFzKycAOK7ZIo5DONxreoGbuWL691A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqdkrZozIJvpKclvas6997eWj0FASL8YphdCrbBd+xI=;
 b=ZofDx1euWbF8T3p19R/qICu8cUQNoBpNsQ9ZFFiu0uNG8k8JfbEOg/wSCZlbCy8qJshRSG8/tBZqHh8pbCXHZoNDcemiVzoYM5qPMchs23DvfYw+v4leJRRMA0H8v4PD0f6nVDL8vftp4BF7BT4sAaVvkfT9infvZD06cvcwAr+YYea/VeAWpMP4rAUG+ZWMO4x8mC19wr1zdidLUDdtGBSTmWMjwmrGcG/AYr+H4gLueHNOc7beOXru9Iv8wtWB6MwovWYz0uZK3cQtVhxdfNgUJUxCGJXJ8WoHLGsTahm9Ih4DTp6NrlnHR66zf2BwUdrBUGUstOkuD4sO4T5pUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqdkrZozIJvpKclvas6997eWj0FASL8YphdCrbBd+xI=;
 b=DmkfVtoWgA3kN13c9vAymaWxAgHttPfjS5++vaZdiOdlce3mkBNpsScAhEbN7ZZ3DgUJH+x6bD5Y+ynayXafIlao5SJHj+91EhSVXNxocM29fcEak4ZiBu/igPKXgm/8OPXDYao+P7AZUhUpZpfIKzLn3NWvZ1/ZXFpl7vdXhK0=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CYYPR04MB8839.namprd04.prod.outlook.com (2603:10b6:930:c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.27; Tue, 21 Nov
 2023 09:28:11 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0%4]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 09:28:11 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley
	<James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org"
	<linux-ide@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, Phillip
 Susi <phill@thesusis.net>
Subject: Re: [PATCH v2 1/2] scsi: Change scsi device boolean fields to single
 bit flags
Thread-Topic: [PATCH v2 1/2] scsi: Change scsi device boolean fields to single
 bit flags
Thread-Index: AQHaHF0LQyMIfoRcdkSyI2VgPwcBtA==
Date: Tue, 21 Nov 2023 09:28:10 +0000
Message-ID: <ZVx4Hf18KxroooB+@x1-carbon>
References: <20231120225631.37938-1-dlemoal@kernel.org>
 <20231120225631.37938-2-dlemoal@kernel.org>
In-Reply-To: <20231120225631.37938-2-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CYYPR04MB8839:EE_
x-ms-office365-filtering-correlation-id: eccd7a70-6aae-45ea-79be-08dbea742ddf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 DlsPKNhZO+fK/CeTUeTZuwknEEhIJJ3wwiVH5GoAHJ67tq5yan+ACLvH/DQl0zdkjbR5PLzayNaKkreJCGjyEUOFJSyEe8ZHZJ7LksWSZDTc2iKF/WrzVpgoTZXPbHMvHdKb7WrLuP9M7LaHxR/Qn+26N5A7gxAE95MRpInMRv+iCPXzhvKX+bK+41sQzk/nW5J+vSnfGACnBH6OLzrjaMHmlyM4LY1tcy8BSGP/8sfm0cnodM/Bsz8my54hxabfwDejTpO3kULW07Q69gyl7jyHLI+uVkBdJ1hEa5SDiPCqNroX4YbTqWTk093Gf5UjJQ4MUSp+iPt/sFyHu+vkweMn5vcVDN90YKEUokKEid0romEVEblM2d7EifhrN+Pvvd1sKHzFIWwZ5jWdhAceUvy/JL0PBYLU4zIkoRv7xiF4nxFkULSfB9H6W6ynVERY4Slgs41wQtcgNgMDVPj/e7UU1jDmPFWOHAWhrAXtnBjNm6opdM7xpBiXHIatL3xfpa2er85fP5smx0dk38yRnw2LEaPxS7NP7khNENbvvjRN90rvLXHjwvzgBnkoLHWZ/nra+sfCsmH6HvRiwFKpqpGzUYnVlBTKzoktk+Oa+9E5uurkudjF2xQRtPAwT/Gwej7Py49xcXiWLjRZ/g8mhg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(366004)(39860400002)(396003)(376002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(26005)(41300700001)(86362001)(5660300002)(2906002)(38070700009)(33716001)(9686003)(6512007)(6486002)(478600001)(122000001)(6506007)(71200400001)(83380400001)(8936002)(66946007)(38100700002)(8676002)(316002)(6916009)(4326008)(82960400001)(91956017)(76116006)(64756008)(54906003)(66556008)(66476007)(66446008)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?8VedHpSMj7hBoantapFRAPESoVs4WYgPuhtGJrlxgoKSwhPjw06aEjsHUjX0?=
 =?us-ascii?Q?meb14fsCUB7FmYIEYm7wuEiV9KLi+Okgg+ts1lkqKbDMlI446m0sw40FXwmh?=
 =?us-ascii?Q?84eZNSj4bzZ21OMkQLFhyhV2CkcHneM9/oBQF6GLClzYJ+l2eDJ8uGoCCn/g?=
 =?us-ascii?Q?4COiBXbOV4JVHhiDIhv8HTKLO7El/9RkQFfNYaDu6vGKY8Bs3isnz6CFvt/C?=
 =?us-ascii?Q?Fl5mhSrThz5fyK9fXkwJZHytJoZ+fv7JeWYiyW81FUD+a2gISdMEcPuZesWC?=
 =?us-ascii?Q?XNryVf/f8h2urWlWVbWJSxn7ysXnrF/aTPnK7YDGgYuWHiS4lOjV7Sm+h2hd?=
 =?us-ascii?Q?Y5lM2Pj+8DCjH4Vey9Y9YmGX8JhXfRQVGGrsN0hbvB1K72Jd0cYsdXHNC1gq?=
 =?us-ascii?Q?kNk2o63mA39/cTAuaOcqLAfGjAGPckh0Av11PKhuywzx23K3WBa4Cn0DsiVw?=
 =?us-ascii?Q?3qImzPLyzFGtexRFRxiuUKedKDIXZoWmHDFBYmHCfv73L8EoTyy4jXCsQPJW?=
 =?us-ascii?Q?kxDQqPTErUF5+YqMISFfxhQzJXnVLx7PSHaR+ikQgaUrCFda6YJPZVcdH3XK?=
 =?us-ascii?Q?xe1AmP+pJ9qHZUZsNGr/96FYIz9k4uEcq/e5zb4l6cowL1yoX9w7EzWNC6IE?=
 =?us-ascii?Q?m+zGbxccj+as+0OXSlzs5HtyONDxqMVGiootWmXJ4/shgu6Q3cyfYGjDSXfM?=
 =?us-ascii?Q?vzCv8Eph8pVaYIELyFjYtLoez8Cxahn689pk2lcn/JLCwtakuUwLKQkh2geZ?=
 =?us-ascii?Q?TSRvGsWgSiy0TOa4ygW05ryoQfsPOVaHkMmXdJ2Jk3SobLfLcKLsSIn47I98?=
 =?us-ascii?Q?0n0VIaJlPZV+wHIPKhrqVGVLocAIRnG+mgfMGPjMcIKeeivb3XJDhxDer7tV?=
 =?us-ascii?Q?HIvARXtbq3A6aaVrdPOf/ul9wmYVje7jhG2rgRTwS/Xzr9evD5BN3KdRbeAq?=
 =?us-ascii?Q?GL86HAioQ+RX4PNqbHJxZN19mfeNdwZcoru1lqLI/4IK161R1IUx0uqBYEkO?=
 =?us-ascii?Q?7SweRGbNSbz2DZrKIRyPwYVlbAN817RVCGNdss/8dlUjNK09wFl3/1z0XuNc?=
 =?us-ascii?Q?nhvz3gZW0CjZUMt34Ja0IpGNYkmqm3hra1fH6wdpc18pk+QapYuB7Y4FlIBP?=
 =?us-ascii?Q?e7VL8F9iILJa15xFMwfRFyTI+JcpeVcTmdclUxrQDGwXjgMC6XhXIG+ZHRds?=
 =?us-ascii?Q?sHaLP13yxWTl6LgXm95NRXuG/cvpSw1cN9qRFLfgrl+euoZl82YHztnEaYdV?=
 =?us-ascii?Q?mBfDppoORCCzRhpZlE71kw1xmGnJnyLp3g+KZG3319Q+wyqTOkV/NwTqgmUZ?=
 =?us-ascii?Q?+oVgb6vtI+RcfhVTAaulljKdB7E2MKha+tbjeUZuakRRgehW3gjWGLtmNBeM?=
 =?us-ascii?Q?OxTD0Fb/qEhfZZim/xwNwcSE820mtAXMOjcMXLlglTQy58oA63I2lo2HhDnF?=
 =?us-ascii?Q?F9F67DcU2SkYbSPt9YafIu/zTbIjFSMAEDBoFD0tnuj0arczw2LtC025a/hZ?=
 =?us-ascii?Q?PEIwK5kF5ePTsaTrtEfu/KxJlfI8qkFTm8UnKjim0V1w2Fjhf/0+Yfpzu6IP?=
 =?us-ascii?Q?IYPG6lUaTJIejh7/q6IMHeiugzylcXZEo2Be8mE4He73ttqHNPomGmyRj/1b?=
 =?us-ascii?Q?4A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <888FD790D23DDE48B8D88D3D5F23C294@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	=?us-ascii?Q?I+4GPr02OWc/1p9XdDvTHQgCxdvIDv0BdvU7icDJpAorerIyjMJwg0dELnoQ?=
 =?us-ascii?Q?SWruaUp/wsXXyDeOsxl7D9RtT6P7HIUaKZaQKtkhfM0JPLpjFs4F2iotRG5j?=
 =?us-ascii?Q?vz8Uid7kAp7Jao6PXfyJzgJE4xwn3ekbfRgLLNZOz5gK7onOnho0JqbaESsk?=
 =?us-ascii?Q?KQ96grnGihwsfwVpNTEexj6CXuVmnbbvA79XnFratjlWGD1EuLcN3LVZUrmz?=
 =?us-ascii?Q?VCqrQNSJppBDcJichmO206Ao+CpSJrVFq/a8h0NNDiv0fSIaXEgJ24rgQpK0?=
 =?us-ascii?Q?JL9+7PbesUb513m7TimfwGIOEaG+Ds4ZQ6+ucxEFTy2f88nTIo64ZTw3w4eq?=
 =?us-ascii?Q?laQEbK9P9foqRvfJRC50kcj6TCJ+eoG4ogbEXR7UuHGhKk0eieSvpkqocOBQ?=
 =?us-ascii?Q?ZHRDF/s72jVAoXEhItgm0rC2Gq7ccDgCU4bXij+dmWLFWmbXIACWmECVWWo6?=
 =?us-ascii?Q?vmC9NI62wHVa3r+pxV0xgwQaYp/nfQ/iVXt/q+2z+wBl2KOae9m95wXy0H8v?=
 =?us-ascii?Q?dKRpSufMun0wZmMUA4CgDzHeLmfNXNaWamCAfd0+GOxR8C1SWf55IvqGQ6E/?=
 =?us-ascii?Q?VA3nxUxupAIchWoOOnvbjFJiTCNkbUvHY0IGtXUA4n4vmAJGg5aSE36Y6EXf?=
 =?us-ascii?Q?AfZ0X5oO1Magh4RT0mjPZ0+yQuy/Phg6BPJDMdcaCcapiSC7ue7ZmTCqmRfH?=
 =?us-ascii?Q?OzrhX/tLHTaLYGKLDbvg2gICYDJ1ViKmFj1QedlI3YtFt9i8RwUgFSmadlHU?=
 =?us-ascii?Q?onpQphWsa9fPah6rFhl633Xf3V59KopG4yGeRGPsJVeTBd1bhfefAv2Hol6z?=
 =?us-ascii?Q?/CXfdOlQ/fU+W+JdUoFh584IAv0G9B83Wz08LvBl/xs77qw8TmdmUGVlBtex?=
 =?us-ascii?Q?DKWjDoZHSPQ7sUC9ZpGrXyKh7P/KRtvfGgBZr6gTtlqfspyiMgzD1b6F/ayD?=
 =?us-ascii?Q?veFnhF6YOzcHJrNdWug7dA=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eccd7a70-6aae-45ea-79be-08dbea742ddf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2023 09:28:10.9683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4fzHelRov60SNDalW97q0o18InReL1o1mleCj6YdC8xvN/On/xAM2Vh5IUUbxMU59ruv4Oknjb+8a7Tm+eQk3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8839

On Tue, Nov 21, 2023 at 07:56:30AM +0900, Damien Le Moal wrote:
> Commit 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime
> start/stop management") changed the single bit manage_start_stop flag
> into 2 boolean fields of the SCSI device structure. Commit 24eca2dce0f8
> ("scsi: sd: Introduce manage_shutdown device flag") introduced the
> manage_shutdown boolean field for the same structure. Together, these 2
> commits increase the size of struct scsi_device by 8 bytes by using
> booleans instead of defining the manage_xxx fields as single bit flags,
> similarly to other flags of this structure.
>=20
> Avoid this unnecessary structure size increase and be consistent with
> the definition of other flags by reverting the definitions of the
> manage_xxx fields as single bit flags.
>=20
> Fixes: 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime start/st=
op management")
> Fixes: 24eca2dce0f8 ("scsi: sd: Introduce manage_shutdown device flag")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-scsi.c  | 4 ++--
>  drivers/firewire/sbp2.c    | 6 +++---
>  include/scsi/scsi_device.h | 6 +++---
>  3 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index c10ff8985203..63317449f6ea 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1056,8 +1056,8 @@ int ata_scsi_dev_config(struct scsi_device *sdev, s=
truct ata_device *dev)
>  		 * and resume and shutdown only. For system level suspend/resume,
>  		 * devices power state is handled directly by libata EH.
>  		 */
> -		sdev->manage_runtime_start_stop =3D true;
> -		sdev->manage_shutdown =3D true;
> +		sdev->manage_runtime_start_stop =3D 1;
> +		sdev->manage_shutdown =3D 1;
>  	}
> =20
>  	/*
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index 7edf2c95282f..e779d866022b 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1519,9 +1519,9 @@ static int sbp2_scsi_slave_configure(struct scsi_de=
vice *sdev)
>  	sdev->use_10_for_rw =3D 1;
> =20
>  	if (sbp2_param_exclusive_login) {
> -		sdev->manage_system_start_stop =3D true;
> -		sdev->manage_runtime_start_stop =3D true;
> -		sdev->manage_shutdown =3D true;
> +		sdev->manage_system_start_stop =3D 1;
> +		sdev->manage_runtime_start_stop =3D 1;
> +		sdev->manage_shutdown =3D 1;
>  	}
> =20
>  	if (sdev->type =3D=3D TYPE_ROM)
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 10480eb582b2..1fb460dfca0c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -167,19 +167,19 @@ struct scsi_device {
>  	 * power state for system suspend/resume (suspend to RAM and
>  	 * hibernation) operations.
>  	 */
> -	bool manage_system_start_stop;
> +	unsigned manage_system_start_stop:1;
> =20
>  	/*
>  	 * If true, let the high-level device driver (sd) manage the device
>  	 * power state for runtime device suspand and resume operations.
>  	 */
> -	bool manage_runtime_start_stop;
> +	unsigned manage_runtime_start_stop:1;
> =20
>  	/*
>  	 * If true, let the high-level device driver (sd) manage the device
>  	 * power state for system shutdown (power off) operations.
>  	 */
> -	bool manage_shutdown;
> +	unsigned manage_shutdown:1;
> =20
>  	unsigned removable:1;
>  	unsigned changed:1;	/* Data invalid due to media change */
> --=20
> 2.42.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
