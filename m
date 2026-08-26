Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011012.outbound.protection.outlook.com [40.107.130.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489C1448382;
	Wed, 26 Aug 2026 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787756747; cv=fail; b=UtAtf0R/mpA2SxbOo/rmfp9v0UuTL8hoVEGnqVRUmkaE1nH6B6nypu5n/a+96VGA8ORbTs0zR7R93KAjKst297TDoJBl6EBwYGCnjohTMXshAjRX8TuzecDDiSXLop60VzGFk4SjMjgsmiLlN0x6LpkEmvLiQnhhgxq4ODi2dfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787756747; c=relaxed/simple;
	bh=VLEbu/QvPLykJrttRzum4/4dJqJNXuLujmLW4LrieDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dIphTlSWAByf8Fn3DXa7UBuP0ozZmH7CCm53hfpDwOKsKlh6le043KPE63hXX15M1ZSjjwPvtkehOry1lnEXVwLB9lhXLafoZFb1nJuZszL3PGk5EPbdhWO/t8pkVRGzy7+5wWZcrM7aWD76FmxaqbfXrjfGgV5HY0h5zs4mcb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=dqd3AfNv; arc=fail smtp.client-ip=40.107.130.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="dqd3AfNv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bX96TS5kcFKXsjYBn1goPT6c0GQYQkDNJmtylAB8B8o6xd89u5MQL08PZrBkD7gHybqyIOf4pLKV9Zy/pD4OKjFwoWLKDkqfjluhSXIQpwlIlvdA27CJOZgDKkilKvcrrxVCKgzJfhpCmJ3blvVPc9qY8YPy+uEvjQQnxIFKdcOq4pwtAt4IkVoaIF68bmn1EEoe+9xkK/fp1243HtzOnp1P65VRIQt1qmkgsMolRL6vNdYy4dI8d54oGh+GBxgiBY2NKoe6n4rWRAej8MpUEJnb7uWO3Jc6KOiH6h/sP4DjvoRtxiikGWcJEFmtb3tAouO9K+0lSnJHDajc1XTHiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLjsRmVRvxKWk2GpFV4WTDdqB2V85R1PFvCdHj7WBJw=;
 b=wU7SJy68YurOW1+CdIQ5arQayL6rx0cxSI6+UTEKf3TMsUHvI7mVedIlKIv+voTd+6d8YqVe4I/xj70fDPnVZnvLII1xtXE0MZWadxVOtfDNT+2Cif5nlS2SuICWM2vZ7QXde6BHFQ3O+9MrGyoLcAc86jINxWjvQJfmOo+iTnwJmb7e5x+6I2kR0mpgUZcHqmDvrCOtOI3rBbUEnqUx3UoghIa1b/9eFvRL5aDRzaBoEYlpkhGK7Qtnd+ZpQlF07GByg7IH0e2BOIgWmRSc9Sy8E0CwH6/o7JKjW8cavGHpwx4L/qKdyd3cgXo3mvnHTG4KtAyAKsn+ZRPFp3iCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLjsRmVRvxKWk2GpFV4WTDdqB2V85R1PFvCdHj7WBJw=;
 b=dqd3AfNvXYCGo7E/2oWUwUckSlxBYIqIf8ABfQhg08e5igL0SXqWDn/1qEERdfszu0teDb0MF/lWofz/WvDcHg9BklJvA3E9tjk5k9zr5LJ5731hQczzj5iLFQkVMAC7ZcnDpaC3HzaJhdKAJKCyjysVC1WPKOcYpkRDR971Y+VrlFR7uNRUsvcnp2qWt7TPceE5sVyjkSVRuQfbFrH2rjpvC45Av1YZA/Q/DnVROWmmgScJvzgNhDYOCPftfZ4cGriU02Oj2Waciid8xlrZlOwYo9KA2FYSuat3MgEBAJfVXy3kW3HX7vMOX2eglsjz/EMV8Zn770BekZ6UJNANxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by VI0PR04MB11537.eurprd04.prod.outlook.com (2603:10a6:800:2cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 15:05:37 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 15:05:37 +0000
Date: Wed, 26 Aug 2026 10:05:24 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 01/10] ufs: unipro: Move Tx/Rx FSM state definitions to
 unipro.h
Message-ID: <ao8AtFsYdr26rHVc@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-2-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-2-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH8P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::32) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|VI0PR04MB11537:EE_
X-MS-Office365-Filtering-Correlation-Id: d730ed86-9a3d-407d-147d-08df03837c56
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|19092799006|376014|7416014|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 gKFs5mi8D0ZQyHauTzAoKAr6DPJcSCHf8/4hAk6p+q+4Ens1/ZgFsLK6RoCoElAQW2dNOhq8gUwynsPfNOY9JpNavNeclHVC4xXaA5HFwRDp5R/WtYbmRZoGbd3TPBNb6P+zvnd6TR9NXccxjyUV7j3PhUPOLvul7EOVWIWin4yt+JTq6YzINRRY3a+Qj25/SpKDIrh/NuD2iNSBxtz5XA8f19Fm5JesOTW3LfWtZJnQZbl7PltwnNSwl0toqYRaT++dazoqcY6aDmaT77zAq8GJDJlVvfaJD9bdl/avSYBPfi2ldPKE1yFQTI2LETtRibgPVUIZBhIdpzjbKjjK/eqSnm76Gsr8DIbO8ZBC3Nc/0YJpMNhE6LPXfRYmGf+wP/tWe7GDJp0IXnSME9O+JWv+Z2A2c++wmkk5dfb6x5HeAWQF2qSbIVY0y3o+lruOs6Mbv837V/qyhmMK9xoTbc9fIuaZaEmOrdoodQQJwUcbzd+gHj2rXq3kJL711DAhcB8ErIyeclLTl3tMI1yeAuNFbHA+ZJyQ3S6YKDPgw/KCMaVeE1kgfnx7Dpm64cjgu/SP6OPnvi2JUyldosFdaQSiuGX4X5Ytf21Lo4t//Z8DAApIBsIPaqVC+lbHjvUPQMyE1WcS7JXD/3w76aNOoXSAQ/k6VpT91iB4q5xxXnU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(19092799006)(376014)(7416014)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?AQ67tbSASZ9kDP5CH1O0iXYvA/F/KNJYYyjnv6bBP9pmA1cwfSoQpp490zSO?=
 =?us-ascii?Q?c3NFvms23Fllxooz5hJUd5BEMPVfQQw7odLLE0EhaGxK7xsn15lUyIK8rEge?=
 =?us-ascii?Q?Dso/f2Ulx3uJuv4lD0sL69f1NUPLoOSSVRYoF2WiJEASpb09DH56dBJ00sp6?=
 =?us-ascii?Q?sTcY/4ylDMxB7eg1HhAm1D6fN/HyuiGPma0FScfQwUpjjAHJZ+hodLcM6IjV?=
 =?us-ascii?Q?6zb2z9vIv/QxBIouI75tvBRGfGxv7ZcSVnVwgzRd2aAxsTTNW5G+azr9NUuH?=
 =?us-ascii?Q?NIDStwu/QNX4EEljJG+tW4LuXpBHCZwYwqSfWOU/DOi/OhEPCFWPzpNVr1VY?=
 =?us-ascii?Q?m/iR1Swmgq5HrFkwkI1F23HIP/85YUhqLkmAcbuC/A+AuuIqCjYPmmqtRmmi?=
 =?us-ascii?Q?vQDgLH7eFuWUA7cc5ABfUboLZH97AWndH1A5jXwjayoeVWK9dHM6N7waQEKK?=
 =?us-ascii?Q?TGLe8Nqv779D4xhihLxlOKYQhRWLP/uwoEytRq7JYVLIhhQnHwblB1onznWP?=
 =?us-ascii?Q?AV1fdSz+IU0Y3ZxI+HDccBdTETS7CUkZsWreA+wI2RzgktD9L25OPuZLxO4b?=
 =?us-ascii?Q?CTqJgqv2rZD1K1MW7TeW+EJVaSxT+y/ol4VfCDB2DOgQw7hPIDPsjL5Aqkjt?=
 =?us-ascii?Q?/qgVz5QhhCkjDv+X/66ZI9Xn6+dqFy4nKgM1TvKLPv5cLMbqhyaqbqF5ic5N?=
 =?us-ascii?Q?Lk19QApqugEgfZGQaGSffM1ffLPqJU/HDxq6v8uCzxwJgm83cPfjl6Tpltdj?=
 =?us-ascii?Q?k+ptT0olYCVZkqu+jOFwfdcKQ/aS0nl3cJpRiredPx2p3K/b4uT0d/aU0OTU?=
 =?us-ascii?Q?WO8s4a1RNdi+0V9ili1fun/FaG0mfqC21Letx9SDvO3G5kM7J4H4Zb8GDsmh?=
 =?us-ascii?Q?rzHIatcXN3vR1zJYLu8SnEQSvCeZoUpFTEwXSJbeT5ERRzgWYUzgYD2STD8y?=
 =?us-ascii?Q?j+KdmGC+0jzhH4fcf9gf2EsYYo3V3wkGqAT1ILnDwOs9shk+9jG3CNe4gz4w?=
 =?us-ascii?Q?8bdLMjo4VJfqeHod7xG3uaRSKp8np4RcHnpDb/WTUN0zAXWBwrRIxwbdz9fy?=
 =?us-ascii?Q?dm/TSaxgxsFrE5UoEhWYPBJqC7Tcs8BejG+oAeLBFTH+tO6aNjZQzg8sKb0M?=
 =?us-ascii?Q?AwYSadqDy/iGydrMwUyZ5XZcfcBbsuqPdXCXeyOUrgLQ4ymibDtBnCUMNq61?=
 =?us-ascii?Q?hFQKbGznKhAuY75oZPSzHRhF22R9HvYq+uD0S4A/LKpnUUq0QySx1HDhb1ay?=
 =?us-ascii?Q?0JGZnlsQKAx6g4vaRC3shYlnMN1vbcjfCuebjKnWeFtzYW/l4ocd6A3hQl9F?=
 =?us-ascii?Q?jdnLQv1tvrl4ErCuTJC69QwPMbJjxe7vQsq4oofC+ywigcGfB0RiAD2Etuni?=
 =?us-ascii?Q?KCN2DJnpfe00swqKMX/ZUEwZsOjSbRUkw6xqt9c4fMQFOayX2Xg6QwIVUxH5?=
 =?us-ascii?Q?IUJByNTAiGJjFWm/6u06xbbWOivmIWsSpQVm7N8WYAutLiGeD51DFdOJxY5l?=
 =?us-ascii?Q?j27PXFsmdfKWp9CYXDVOO60q2+2DoFoMPk4JnVAQsstktqCCGnDZbabS/M0+?=
 =?us-ascii?Q?joRT2NhSb3brWWRLHxcHZUq7e0kuMVI54zxQ5Dd8Lpc/URv6AASGpM88TWWB?=
 =?us-ascii?Q?XxbpcQNT1kwOvzrDbGdJna2pkcsv1yp5UNozQpiroylfVLlOVLgvk6Jj2vuL?=
 =?us-ascii?Q?MNxtzeIfwt3HO7aPbzyAvR9tVh5CynIHtzOfNo1ZIYuS3oEFCEqNegguN32A?=
 =?us-ascii?Q?keuuIqy4PqygRFtGb3Mnfv8adZ0s2zZKSsFzYQpYHhyUXnzfoPyT?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d730ed86-9a3d-407d-147d-08df03837c56
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 15:05:37.5051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQedrkXSHk2Ws9m+VCVXRVEHEr2+tyZnH1H/I9us0J1uSjtzcLyFEO/rnRiw6avj4cbvo2RMalWKlnRPYEJSdMpu9nTJZmW15qKbsTZn8Ur1fIAadDHJRP7hTzAB1dHG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB11537

On Wed, Aug 26, 2026 at 03:40:39PM +0200, Larisa Grigore wrote:
> [You don't often get email from larisa.grigore@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
> include/ufs/unipro.h.
>
> These state values are UniPro/M-PHY related and are not specific to
> the DesignWare UFS host controller implementation, so unipro.h is a
> more appropriate location for sharing them.
>
> As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
> ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
> TX_STATE_HIBERN8 enum constant. This is a no-op change: TX_FSM_HIBERN8
> was 0x1 and TX_STATE_HIBERN8 is 1, so the compared values are identical.
>
> This also prepares for using these definitions in a subsequent commit.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
...
> -enum rx_fsm_state {
> -       RX_STATE_DISABLED = 0,
> -       RX_STATE_HIBERN8 = 1,
> -       RX_STATE_SLEEP = 2,
> -       RX_STATE_STALL = 3,
> -       RX_STATE_LSBURST = 4,
> -       RX_STATE_HSBURST = 5,
> -};
> -
> -enum tx_fsm_state {
> -       TX_STATE_DISABLED = 0,
> -       TX_STATE_HIBERN8 = 1,
> -       TX_STATE_SLEEP = 2,
> -       TX_STATE_STALL = 3,
> -       TX_STATE_LSBURST = 4,
> -       TX_STATE_HSBURST = 5,
> -};
> -
>  struct ufshcd_dme_attr_val {
>         u32 attr_sel;
>         u32 mib_val;
> diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
> index 9c168703b104..bf063edc284d 100644
> --- a/include/ufs/unipro.h
> +++ b/include/ufs/unipro.h
> @@ -466,4 +466,23 @@ enum {
>         CPORT_CONNECTED,
>  };
>
> +/* Tx/Rx FSM state */
> +enum ufs_rx_fsm_state {
> +       RX_STATE_DISABLED = 0,
> +       RX_STATE_HIBERN8 = 1,
> +       RX_STATE_SLEEP = 2,
> +       RX_STATE_STALL = 3,
> +       RX_STATE_LSBURST = 4,
> +       RX_STATE_HSBURST = 5,
> +};
> +
> +enum ufs_tx_fsm_state {
> +       TX_STATE_DISABLED = 0,
> +       TX_STATE_HIBERN8 = 1,
> +       TX_STATE_SLEEP = 2,
> +       TX_STATE_STALL = 3,
> +       TX_STATE_LSBURST = 4,
> +       TX_STATE_HSBURST = 5,
> +};

Suppose ref RX(TX)_FSM_State in mipi m-phy speci v6.0, table 50 M-RX status
attributes. you add ref to mipi M-phy to let reader know it is really
defined by spec, not dwc implementation.

Both value are the same, why need define two copy.

Frank

> +
>  #endif /* _UNIPRO_H_ */
> --
> 2.43.0
>
>
