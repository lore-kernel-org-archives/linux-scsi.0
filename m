Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879943CECB;
	Wed,  1 Apr 2026 13:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775051039; cv=fail; b=aMmLimVYStNhUlHRl+PMTvnnp2YkOQAgOu8IvxJtxj4jtO/2npdwGXsyKDrZ6OrYmw5maysWzFU37F7MbOU4UIBnlU9nSraJxErZTz+vgtUazdZ43z+4PzVuAHMTtOc7JFpDVX2Y3n408cnMGUAbwumIgsTz9kQq0Cydem6M1S4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775051039; c=relaxed/simple;
	bh=D8ow7/BfOOoMNPASR5aPdTvWnHsObjDxdv1IWI+mnrI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BLDVt8OqGqpj7KlyFEadnqpsN4vLrrlWn/Fb4G8ZsRhatTx0yEoM9Te1MX5mQVpMKAhIUsukL+7X4L+nQmg303YzhPA2sm4urouUiGAY+M/tSPs4dk0HDiWV9yWSSTE/Aa2gQoVJLMQqVxVpUukK996RWMN33PddmsGeANpmMys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=fbPY48gd; arc=fail smtp.client-ip=52.101.61.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="fbPY48gd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XovfVeOE7IUAJXK6BAGbAdoIB5odwYoou5GkUAgOpYitbWsr+1qnMMwkpNGSE8y0jQB2sMCkJz20RRal5ak+T7NceQsj8YwQpaYLdW1aiEeHvVmpSbRgF/6Za7T8upvvgdS7xvhKy5DGCPbAvLjQwfsFcNdjWfg/hZ8Wox7adNmZPvD6pfYKEogkWGj2rkEwc4I7gFn9pZHbkE7SJzzUguhwqbeRnCsMZ9ke5twi3OpFyvpRf596BLzFwtfYz7VkApCNM89lX79b04c7CeZYyVJgSRgLoxMKYYbQM9Vwd1XqZQz8pmrLJR77/8dD6Dfg1plV1i5vHvQbAxGzUPWi6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRBeCKV28LGDC5KO4qAHDwJtsoDnc0L2XBoHdHoUZwM=;
 b=MpXW7rXdXZ5ezGQp+9JfNVCWxahpL3S2+MgZoColJq1eYcPVR6EE4Y1IqyVM5xBCMdOBlMDseaIbiBU8PcZGcHZx85ugDDO6kYO9deQa0Q3d6dNrV11WUbLVHZkGtJ2u325OeGojyjhd1Ul+IU7yYuLLJVO0vOiyJTDfkHalOmA5KmQOlx54+cRAdbp7qvl8OT8acdBcqlbYS2Z2m4q/X0eNcC5maRU+E8JKxSt0iQyHrqpM1h197QNHxnMZ56Dw5SwNq7wSOl0WrDw3Y4lvDy5DC0TpThttnOkgGhzCdZHiB/4xLdSfDLY3DUYODdy3ktSUIC2lnADVOEnHxa/KDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRBeCKV28LGDC5KO4qAHDwJtsoDnc0L2XBoHdHoUZwM=;
 b=fbPY48gdnImHdRipcs+RvJKsdoEKZtDSpEZUtNQb1JO4C/aUgcf0klWBNc6jXEGL30xey133kKfcCXccp2XcchXajIBtpxT2AGWKF0Mw1JGkm4NZBzIKnMLBP/LVGDCNUJcOt9a3u9ljeXcFnFu4INRGtd66a8eM4W5GXJthzNrY4s+3evmM9v9eiysySBETGmk7y2xkqePC3bx4wzWyFqRf1NV+wifbLb/wdIkUE1hp3uF3rzG0gPCugw/EGC46Ksup3zPmMHsIjciJjvuI1JPAjTHo1RUZvyOVV2JtdZP3KukAJv9ExAN7W3ScbckeNTBMCPXeu3+h5YHj+ggPAA==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DS4PPFA08475C7D.namprd11.prod.outlook.com (2603:10b6:f:fc02::3f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 1 Apr
 2026 13:43:55 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%5]) with mapi id 15.20.9745.019; Wed, 1 Apr 2026
 13:43:54 +0000
From: <Don.Brace@microchip.com>
To: <pengpeng@iscas.ac.cn>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>
CC: <kevin.barnett@pmcs.com>, <thenzl@redhat.com>, <scott.teel@pmcs.com>,
	<hare@Suse.de>, <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: hpsa: enlarge controller and IRQ name buffers
Thread-Topic: [PATCH v2] scsi: hpsa: enlarge controller and IRQ name buffers
Thread-Index: AQHcwc/rcnUh7WK/gUC4TgcuvqBE/7XKNgif
Date: Wed, 1 Apr 2026 13:43:54 +0000
Message-ID:
 <SJ2PR11MB8369BA4975A9328C27A51CD4E150A@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260329030947.32427-1-pengpeng@iscas.ac.cn>
 <20260401120552.78541-1-pengpeng@iscas.ac.cn>
In-Reply-To: <20260401120552.78541-1-pengpeng@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DS4PPFA08475C7D:EE_
x-ms-office365-filtering-correlation-id: 2ba46efe-7609-4d39-13f2-08de8ff4b795
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 GI7ANUyWGwH1j0M1nhWKIDthaVZv6fl06D1TOI1WzKhj3UATfiopn6Lz4BFxYGHxkwiViLB23vT4LpzpIS6YmQXVD64dwgZyWwJD1uH+zeYo/Mo/QbBqb8tb/4j4dI9DEG4jQXwSGd0DkdcXq3/kGFInWGtqOrqwALbIn9pygM7H/pr3DXDcU91k1NnMWoJ2r7qQlevq3FO4G2WAo/octy53eZzwcTliE19rucXJEN9CmLnTHr9E6o/WOrYzFz+gZ7scM8NAuyh3mXjJkiciUxv4H/rGgBMB2ROWBQv0kv4cOryI+eYSrqcmtM79nsc1VV62mXk65st2soXC3xNwK7NADtHTC3zQJYcI5T6ytTAkywbjECRo0Cnz8A9sSCkLRjCfNNggODafdHv4XWHzYLmk7DQVnCYY3SJmnHc1Vkl0J+Jh3LYgd1SbxGq0bxMaOvCFPicycf/52dOLCBqABmXGiDkQKTCYlmByNyYIf6glxcI4N+26JIbUQWkNi/Eyh718QdUUYvAlzAjssu8XtidUGEi7LZsrqVOsENjq8u1/zx80AHrHqbZFG/kz9YelmH8kJhHhDuzHkIbqj+aZOrQFoyiSDmdAR3heqgndnxrisMTnPwJZT37QebcjN1YeyfsCZEASLLaO/e7Fm/Rn8y5r9CNpCKr4iqds2RJfSudbV2jAi8ZhpsML5bcp5KG1BsnxSQWV+SyIrD3pAHnpwhD6p8hbgkhxPH5y4QIbH2MRb1XuZjKX1Faq/cjljaNw3zijNvjJV+/8Br/F4MAegillRT04+S5t2vCtbRacph8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+BKTcp9Bp7nl8O36o8Au48oEZCLBxherSPHtIiFzIy+ZKFtMgpWlxD5iP6?=
 =?iso-8859-1?Q?1PQQgUvKQHzkATv/OquaxC86UwR5rNpwSVRQODzkxqKOOaU13rHL3U8KK2?=
 =?iso-8859-1?Q?ZSi/ocdTbQvcNZbI/sFYZ3wagAHhx+9f1yKnvnciI1kf8E4iOLEzDv6qkY?=
 =?iso-8859-1?Q?myXPN5jRdTwiaF4gmEADYrPcx205o7yaquOCSvZBgv/Ha/GmlSXy1kCZG9?=
 =?iso-8859-1?Q?Dlj3RDu6nPAMNE8a0FlS4UkGnAy0XXIwvRF9ZTlRNWOP9CKbYUfZ24NDR3?=
 =?iso-8859-1?Q?BEvhvHQiTyYogS43OXT/SB6lWq90yS6syVMnlSpcyUEetjOcYPK2myG4J/?=
 =?iso-8859-1?Q?9HLLWYWul/h4H57x6MT140p/xbehaq7CM5u8LhgWT7vGRt2sbXa3aEO+0Q?=
 =?iso-8859-1?Q?izpMTh5hTcVW/yBJhcECvgy53nIQxCbwAqoTDIfAMoACiIKgPINoFp+w/k?=
 =?iso-8859-1?Q?m8oCtwiynkVaBb+08j/34SPKSIhu8uiPJ+4+dldHbJnhdHVR9xHYF6NEvi?=
 =?iso-8859-1?Q?pWojnxFYzoQLAYU1GxFB+l/QRMPuF6PmeewskCxhPfL81dvTSsVhtmMY89?=
 =?iso-8859-1?Q?U9RJTcKDBDeScmmBSszOsAD7SBEMuEGccEww93iLDz5xK2ZrAqnma9qDC5?=
 =?iso-8859-1?Q?tTzlBqr9pc0eDDFtRatwcb5v7kZyZIYlGl8CNtMlHO2qORFqyARlyTy4Pl?=
 =?iso-8859-1?Q?0TJijw2EvpZROQAVOogHwW7vpd2hbbC0jJqKWHF4rOeSE9fFs/Rpp8oAUc?=
 =?iso-8859-1?Q?Q9s5lFn2cA3VMvSEVwbhhW0Iy5913SEOSndR8OfRXJhgC10W0IWBG7MnNm?=
 =?iso-8859-1?Q?yQ5yW6/gfS7obSeKFB/L4LLt3z22L7oYNDLNlg89N1bUTDhFS5h6pEcWwt?=
 =?iso-8859-1?Q?yg7QmRkpGE+w8EbGEJFG3iLdsky9ziNLTzuvKOmtFVEX4egyFJVoFOQ9kM?=
 =?iso-8859-1?Q?7Y6Y7PWwZxf4ZaXPepBT2Jnn7aubKp9M3X9O0VKAIqe3OgkqKbom0rbtWr?=
 =?iso-8859-1?Q?Oy0VufXdSZeFEuTFZQIG/egQZfBGvjrhYh5Xwcri5mJtdgbszjMiH6uK33?=
 =?iso-8859-1?Q?vuJNj4tPGTHkcsutfbXLYZRKDfHjftego9++gm+6X04iAz43aCKh/GzwPF?=
 =?iso-8859-1?Q?9sAC0QFDLQRnjYzis7wQE7enBvmn45vjdifqR/y+LSRU9WKrNRroiWZhS5?=
 =?iso-8859-1?Q?TbGGZnR0i5lTBjea4aNro5zkxEmv7LoLqKxgM0+TXF9/5TopNrW4nKZWmJ?=
 =?iso-8859-1?Q?0IyimtNZ7/Ye2iEsvxrAITfNs6mY+sb6C0DPIaJYSubarplkC/fFn/Hcmz?=
 =?iso-8859-1?Q?1dqtlDafyIFVjUARd2f9jNMr5/2mTwn57mTXjYBzmqPCTtMfCVssYB+0BD?=
 =?iso-8859-1?Q?vWvUQSiwh0RPIkH4GzbWRqz3qFrIjp1Z5oWuJlPncAzEUJbmuNnqy7vEnk?=
 =?iso-8859-1?Q?MjgI0Yq0mZ9OPb4kZ7Er6E64Tt/bm2GcoPzpR5tlBEqlQnCXhbJJ30sh3n?=
 =?iso-8859-1?Q?BKl3bRmu5uMXynyJ4CnerH1OZWyXIbYfRqa09xLkzASNyejOmy6xnafoCD?=
 =?iso-8859-1?Q?CLqWkTVevEwaHCVEhV36jY7L/oYFiQhGinNnkETySAMa4Cl9J5Ra93XtBg?=
 =?iso-8859-1?Q?S5FaeCQV9NRTQrXAemvxyY9WDqWVueV+YGcHz7sIPs56kjNvJccg++lRl8?=
 =?iso-8859-1?Q?VukOWIsQMjNPQDiwbYbULGrPNB9AyaGxgKzPKR9W0RoQb7pDErc8DlIWbo?=
 =?iso-8859-1?Q?b2geX1oRYPxkK+YCp+fzRvnoJEpTHk3i48Y57q5hSpg8lqXOhML6o0hmYk?=
 =?iso-8859-1?Q?GYQwt9L1Bg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba46efe-7609-4d39-13f2-08de8ff4b795
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 13:43:54.7552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ALL3f0pku9OyjTT7t3dMH3jpCMMau3ipdXJaGoTrOyODQKkU1MqQU6OEnSDAiVCGzU2dC82l3hCrMVucj/4nhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA08475C7D

=0A=
From:=A0Pengpeng Hou <pengpeng@iscas.ac.cn>=0A=
Sent:=A0Wednesday, April 1, 2026 7:05 AM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>; James.Bottomley@HansenP=
artnership.com <James.Bottomley@HansenPartnership.com>; martin.petersen@ora=
cle.com <martin.petersen@oracle.com>=0A=
Cc:=A0kevin.barnett@pmcs.com <kevin.barnett@pmcs.com>; thenzl@redhat.com <t=
henzl@redhat.com>; scott.teel@pmcs.com <scott.teel@pmcs.com>; hare@Suse.de =
<hare@Suse.de>; storagedev <storagedev@microchip.com>; linux-scsi@vger.kern=
el.org <linux-scsi@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-ke=
rnel@vger.kernel.org>; pengpeng@iscas.ac.cn <pengpeng@iscas.ac.cn>=0A=
Subject:=A0[PATCH v2] scsi: hpsa: enlarge controller and IRQ name buffers=
=0A=
=A0=0A=
=0A=
=0A=
hpsa formats the controller name into h->devname[8] and derives=0A=
interrupt names from it in h->intrname[][16]. Once host_no reaches four=0A=
digits, "hpsa%d" no longer fits in devname, and the derived IRQ names=0A=
can then overrun the interrupt-name buffers as well.=0A=
=0A=
The previous fix switched these builders to bounded formatting, but that=0A=
would truncate user-visible controller and IRQ names. Keep the existing=0A=
names intact instead by enlarging the fixed buffers to cover the current=0A=
formatted strings.=0A=
=0A=
Fixes: 2946e82bdd76 ("hpsa: use scsi host_no as hpsa controller number")=0A=
Fixes: 8b47004a5512 ("hpsa: add interrupt number to /proc/interrupts interr=
upt name")=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>=0A=
=0A=
Thanks for your patch. =0A=
=0A=
You already have  my Acked-by tag...=0A=
=0A=
---=0A=
v2:=0A=
- enlarge the fixed buffers instead of truncating the formatted names=0A=
- drop the mixed formatting-only changes=0A=
=0A=
=A0drivers/scsi/hpsa.h | 4 ++--=0A=
=A01 file changed, 2 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h=0A=
index 99b0750850b2..bf33868a63d9 100644=0A=
--- a/drivers/scsi/hpsa.h=0A=
+++ b/drivers/scsi/hpsa.h=0A=
@@ -164,7 +164,7 @@ struct bmic_controller_parameters {=0A=
=A0struct ctlr_info {=0A=
=A0=A0=A0=A0=A0=A0=A0 unsigned int *reply_map;=0A=
=A0=A0=A0=A0=A0=A0=A0 int=A0=A0=A0=A0 ctlr;=0A=
-=A0=A0=A0=A0=A0=A0 char=A0=A0=A0 devname[8];=0A=
+=A0=A0=A0=A0=A0=A0 char=A0=A0=A0 devname[16];=0A=
=A0=A0=A0=A0=A0=A0=A0 char=A0=A0=A0 *product_name;=0A=
=A0=A0=A0=A0=A0=A0=A0 struct pci_dev *pdev;=0A=
=A0=A0=A0=A0=A0=A0=A0 u32=A0=A0=A0=A0 board_id;=0A=
@@ -255,7 +255,7 @@ struct ctlr_info {=0A=
=A0=A0=A0=A0=A0=A0=A0 int remove_in_progress;=0A=
=A0=A0=A0=A0=A0=A0=A0 /* Address of h->q[x] is passed to intr handler to kn=
ow which queue */=0A=
=A0=A0=A0=A0=A0=A0=A0 u8 q[MAX_REPLY_QUEUES];=0A=
-=A0=A0=A0=A0=A0=A0 char intrname[MAX_REPLY_QUEUES][16];=A0=A0=A0 /* "hpsa0=
-msix00" names */=0A=
+=A0=A0=A0=A0=A0=A0 char intrname[MAX_REPLY_QUEUES][32];=A0=A0=A0 /* contro=
ller and IRQ names */=0A=
=A0=A0=A0=A0=A0=A0=A0 u32 TMFSupportFlags; /* cache what task mgmt funcs ar=
e supported. */=0A=
=A0#define HPSATMF_BITS_SUPPORTED=A0 (1 << 0)=0A=
=A0#define HPSATMF_PHYS_LUN_RESET=A0 (1 << 1)=0A=
--=0A=
2.50.1 (Apple Git-155)=0A=
