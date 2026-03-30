Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E6D3DBD4B;
	Mon, 30 Mar 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774889618; cv=fail; b=RvscJOrrGLVykH1tkzbBjlPqE7EP/NH/gB3t3ZG3+Lubkviq1662o4OyshGKXZa68R7tNqhdivzc3sxqAJsTp8+HD5uRMIybXsaETAKfEHKyJ+xYLbv5+4MYiZlvUwYUh7p/rh6jIeNU+PC0odMFOkjzISsHqmKVQaqR/29v6vY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774889618; c=relaxed/simple;
	bh=KY8LHBZCH3Z6rU9MW4hhYLVQAwUobjQ6oTtaRBxTW14=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VDO2pin2AAmjH9EwzJLrDMTlxHbOGCUcc1Mz+C0PN/EQOI6nMmsh7SqP/w8JEqNhfIMw4OY/K158L+9HxcVIDPEG2mXLoq/XHLtq4VFgZo7e1rI16EYInDzjBuNWGx6ym7fgJW3tq/yzueHALjGtDNhaY87N22TQZf399vhT8MM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=H1OwDImI; arc=fail smtp.client-ip=40.93.196.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="H1OwDImI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vj9cWeFhRT2UVlkRbPeeRKtkpttnDJpRykXYV6Ur34tvan2rQScHHPJemvzXhVv5yE/rbPHTRMwDYOOFmr1vMwUMtU/VnBgvNNiPNmbbFm24IRieJQ1C6C8Rcdc8NRsqVRx0t+DC5ylPdzTPvxjLwihLRPpKdHuRAxbzjcwwqadigzZUgXwO1Lbxz3sG4nNNqH7JSL/+uZH2e18PUbF7qUzSzXsPsDznil2XFoE5aCz7vtKjJSP0wAdaG/Wb58FJLq5eRBHjYOSKIQIeX127l7GkBdtjksByZjgk9XLDtqVwfQgrJMwvUws2apFXCTqlTpzPofqw726yyr44l2SUpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KY8LHBZCH3Z6rU9MW4hhYLVQAwUobjQ6oTtaRBxTW14=;
 b=JY4UyuW3Jw+Sr27/qfDixJcAWdApz5RgOboWmZN7+k96F880IaKlJK+KfRRlHtlVBzUwX07Fl/K0p+5NH73/1Ex8h2LHNU35U9OeOnqDQuOx4pQwV6OWE+cAUgBYC/XQHIdRK8HaB2MmaolN4MIXa0vQ3mm3IuFHRgQGD+kJZj3lGDkBR+g08Zg8QFSrrf0xj3ZXslaFgI7PeHRv9Ha4JRPOBGUJFIxA8lMWI+FaB0ozBZ+RSZxPlJDU1jxSgnuLDx9iqkEtTZSyGIt3wUjiQ2P20NsWVeRF1LjuEOI8unf+R6Z1hbc0O0mlg/FLDTcXW+IFTcJvobUU2bfEikV92w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KY8LHBZCH3Z6rU9MW4hhYLVQAwUobjQ6oTtaRBxTW14=;
 b=H1OwDImItl68R0aB+iBUCu65joW8D4hOfs5DX+qPR0etsYMv7F01YpdvjaWT9M9QU7e1JMVgJuS2UzfpSTuz40urTb8JPShIaFLl0pYxfuxZtNX9jyMds2i+4ViSjzPi3KP4ZegKz/MOZOth5B8c72u5UJIbxvGSPq4Qr85aK6VwX3k6dHIvF602rkdHwKtNQwI3xTVPhTVe4pwKxbEMPbkSND4VpXYuzZZU51IJbJMdUJpLZ4+btEmOMVAYKWtHq3cEbL1quTVpbqEDihQGKJKiJD5KYOuh1FsTfiV/1pxxppcLGpxgdReq3poYmnmT1naJabQnij03kLVfCn0OZQ==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by IA4PR11MB8890.namprd11.prod.outlook.com (2603:10b6:208:55d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 16:53:33 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%5]) with mapi id 15.20.9745.019; Mon, 30 Mar 2026
 16:53:33 +0000
From: <Don.Brace@microchip.com>
To: <pengpeng@iscas.ac.cn>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>
CC: <elliott@hp.com>, <kevin.barnett@pmcs.com>, <JBottomley@Odin.com>,
	<thenzl@redhat.com>, <scott.teel@pmcs.com>, <hare@Suse.de>,
	<storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: hpsa: use bounded formatting for controller and IRQ
 names
Thread-Topic: [PATCH] scsi: hpsa: use bounded formatting for controller and
 IRQ names
Thread-Index: AQHcvymHInmxUfaqZEKk3rVHzVs3pLXHQkqw
Date: Mon, 30 Mar 2026 16:53:33 +0000
Message-ID:
 <SJ2PR11MB83699C29BF895EE85EDC1200E152A@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260329030947.32427-1-pengpeng@iscas.ac.cn>
In-Reply-To: <20260329030947.32427-1-pengpeng@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|IA4PR11MB8890:EE_
x-ms-office365-filtering-correlation-id: 9c0761fb-0bdf-4e90-8c98-08de8e7ce0c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 Vd45iiPYAIvXSaRSE4AhHwGYvaz4PSef5rImrEXKozaCDYXdYKK7sSY1haANmYFawF7keX+rPTSo5o9YnpDR5A98KZh1OruzeXDyUzlrnrtsxd7tOcFBrFW0I04b83yb9dtaWLMa1SmFnpmIIZHhSwr3o9KdXQ2lDQ9yAHzsS4Vv4U9j0pj/RIWihAq1VBroe+gSB+vSKsA1mhcL6QLRQ5WWDWqoAqAfIF29x+1H/C7oJu2IJkm+rsL7vZHnxzri08km4uEAVwVEKY9n97Pw5sWXQGPjs41Fnyj0++PqdjsTAvys5fW237D6J4FNZITOL29+IFbqmJZfKtlZBFKdxwxOM3u0lO/wXVqYH7bXOBCG0JleFIvKLLyfH6tpFyG+c2ADzkp1h3p4IBJC/um8fNWfU3uHNb6MFREv3BYsX/X7KxIP3Nz8UYadrSL4NMSPuGaTt6NBj+FK3cpYXHeRcxGcdLKJFv+3K/31MsM5H+pN+0CBF+OPwskrmEpaU/XYXFPZMj7NY82VFYDmFPgLHsN5YoCKPAShNoMNuJOv/0NfuV3/+O+wQTsxOXgFrb+ClxcJDGQ3+sL8UsfqM+vqmedWFI3HTc8e/tbAlfyemKtytzQlq49LqUke3KXrNuVBj44ZRlhKQGEnc62olu+FIBsvqIDhG3CgdDnOtmd/csNOHwNO6DstFHYS+InycEe6Nzh+Rp5VrzM8T98IKFF+7jbDu2CiG+vx/Y47wbZ8aZiMgN+JPzU8qISrrmbzWtEOeG6PaJV/eL0exAn6JezoRvCdKcvmkYF1jSlY1lbfPTo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Mq2yVV78IKGh1zbLEIzJ2n/NwcQf8LoNL6ts41yzQpFtJf2Sp8OJ/CK8f8?=
 =?iso-8859-1?Q?shWWBhj40CRwpgXa4I43EWmMz8hbcWe0nIUoE9nA4XWkim8hJ4ItlThCYw?=
 =?iso-8859-1?Q?jP0DwNXuAHRASmkAoQHmYb58xVRbrVbrxRvfGYCLdp9WEcJXIENNj69N9p?=
 =?iso-8859-1?Q?fGNxeLp9o34xep+8m2DoFn8gqsRnrOgtptoh1+2LsOaLRvOHxtO0ZAanDV?=
 =?iso-8859-1?Q?VZCv0KQvcICDVE2ShS8emd6SV3LiS8gocI9R9sS2zEXiVUdvElPYLOovUX?=
 =?iso-8859-1?Q?QFbiYEOGl5XYKXXCxs3+X1V+q8oK2ql3REfKApaa5DoAoMb9BgPJptbieb?=
 =?iso-8859-1?Q?/8dwB87Djmvs4+iupDQg2BQGZ9tZBEaWx4qoEz9sXZ1hGolml2nQe46xxt?=
 =?iso-8859-1?Q?qiOgDuPrz5L2sjOGp4pTVH9koy627c0VTSx+IyQEwESFQzTpFsbmpkkp4u?=
 =?iso-8859-1?Q?F1ECasmRgLbxKrl5/SpK9FQ8s2rgUCGSv2SEBTy/BpC0pUQDJ9+WIseTfr?=
 =?iso-8859-1?Q?PgpAyvnHyIRTdRUitZ7k2dY29oW3kWezSAWNeOv+FI1VWJ7nWN59Z+5UK1?=
 =?iso-8859-1?Q?nIZ3qWt5tNdF6AlwEqaA8KxAUg6/w2SaXL8qzTNt2dm2Hpx6zRyK8rrjkw?=
 =?iso-8859-1?Q?IBpOFwlNz/rvHpw5mrfzS9sKNAHNWgL/jxiQnX/OP0+ipdzecQfycQEMRn?=
 =?iso-8859-1?Q?S+xjTQ4w19u6AJdXESg+EzqlF4t69kHu7PHyQb1RkZdoM9IUHOcXad/t+3?=
 =?iso-8859-1?Q?wHtCedI/h4lDZfNI4LcbmvRrRrhg0hWHJOqPkqwkLKeSj/dtUdbrK5N8G4?=
 =?iso-8859-1?Q?ZaU+UD93kin3brnyI4Tl3Ep8yDXe0ACb6M7vMl4qohOd2/gmuy6Yd8GbBT?=
 =?iso-8859-1?Q?JMkpkRAzdnoznMUP7u2xczcJUCgmyhEbcAI/gPW0UForHDmkpKCSldv8p8?=
 =?iso-8859-1?Q?NAQdLr1aQMWkRjFCfxQA+R3KANVe8EofwFjCPWPuZicyvQ+WYfW30F3Hhb?=
 =?iso-8859-1?Q?4rRZlTZbM169auMjxyQjEM3868bWu1N8B08YHwioUrdQlMYnuk1cxqJ/Rz?=
 =?iso-8859-1?Q?y4HeKFzm/3d33Pu0a0O8WyzqZMM7gya+e67qaGwB/WgJMYjy9Q5A/hoiya?=
 =?iso-8859-1?Q?GMQRWZeAuiQi83MN7MKq4RRkZoBKxsRS87c8RkOwRNEfGd8kQQ/J9X3t3A?=
 =?iso-8859-1?Q?3gSfvt9QLyqJ7wsruG417tgm6atJqbm2XQwH3dNW1vSBpLR+0I9JsIuV50?=
 =?iso-8859-1?Q?+fG127yARrNJPl0GqlC8dxvMRPd0WKEIWl/ZVAVx2ZYEY98EkWVlFQPATl?=
 =?iso-8859-1?Q?HCFj57vG5si2HTFpybe/vZd3sSbZMCU12V6hxLV/873ikF19ZrgqtHvCYQ?=
 =?iso-8859-1?Q?ZwpBl348nx8SOwDxe5NGBamnM6Y1kl/GmUpOAp+P1ZNljuN7mgX1q4mF5g?=
 =?iso-8859-1?Q?42dwLz6KmLR96ouikvnbKBnTBnEyY1cJn6cnmaCXlLPIsdNR7XeK7Xio33?=
 =?iso-8859-1?Q?yTsnCqTkT0YdDbG2OYtjtJoNEptDmRQHrPZ734cvGlPZSeE6efH6oZwFh2?=
 =?iso-8859-1?Q?ocqIEHXE/lbE8N0p49KmrV635yitMms7vlHeZpeKL3xSjlDRk/ifEUWGsF?=
 =?iso-8859-1?Q?f6A66N59Qune91Nj4SlMHtVi+BJNn7gCfqBvvJtGi8zQst7cw1rFQlojRu?=
 =?iso-8859-1?Q?0iKNfX8tg6sPxKtoonaQbjOHwI9dYd45+Ma8blr88zDLJlCpWMJ9VnOyYC?=
 =?iso-8859-1?Q?/2UWrG2Bh1HbFVcBTTpBabYt1sHiUuALScBbGmHrRgUccg8KoGGmTsfNaY?=
 =?iso-8859-1?Q?xXTOHwIxkw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0761fb-0bdf-4e90-8c98-08de8e7ce0c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2026 16:53:33.0905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fsofO+IB1kiuYWZOZg9fjqYzdEK+SyleRcebGda3gotvoOmRFN7bpodpIA2wLmQMvQEfmpjrg8BucnY6kdYPWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8890

=0A=
From:=A0Pengpeng Hou <pengpeng@iscas.ac.cn>=0A=
Sent:=A0Saturday, March 28, 2026 10:09 PM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>; James.Bottomley@HansenP=
artnership.com <James.Bottomley@HansenPartnership.com>; martin.petersen@ora=
cle.com <martin.petersen@oracle.com>=0A=
Cc:=A0elliott@hp.com <elliott@hp.com>; kevin.barnett@pmcs.com <kevin.barnet=
t@pmcs.com>; JBottomley@Odin.com <JBottomley@Odin.com>; thenzl@redhat.com <=
thenzl@redhat.com>; scott.teel@pmcs.com <scott.teel@pmcs.com>; hare@Suse.de=
 <hare@Suse.de>; storagedev <storagedev@microchip.com>; linux-scsi@vger.ker=
nel.org <linux-scsi@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-k=
ernel@vger.kernel.org>; pengpeng@iscas.ac.cn <pengpeng@iscas.ac.cn>=0A=
Subject:=A0[PATCH] scsi: hpsa: use bounded formatting for controller and IR=
Q names=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
hpsa stores the controller name in h->devname[8] and derives fixed=0A=
16-byte interrupt names from it with sprintf(). Once host_no reaches=0A=
four digits, h->devname no longer fits and the derived IRQ names then=0A=
build on top of that already overlong string.=0A=
=0A=
Switch these name builders to scnprintf() so they stay inside the fixed buf=
fers.=0A=
=0A=
=0A=
Fixes: 2946e82bdd76 ("hpsa: use scsi host_no as hpsa controller number")=0A=
Fixes: 8b47004a5512 ("hpsa: add interrupt number to /proc/interrupts interr=
upt name")=0A=
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>=0A=
=0A=
Thanks for your patch.=0A=
=0A=
Is there a bug filed for this patch? This patch does eliminates possible me=
mory corruption that is perhaps covered up by structure padding...=0A=
=0A=
However, now names are truncated. Hopefully no installations relying on the=
 dev name and interrupt name will be affected? (admin scripts...)=0A=
Perhaps enlarging the buffers would help.=0A=
There are some formatting changes mixed in...=0A=
=0A=
So, follow up with enlarging the buffers.=0A=
Acked-by: Don Brace <don.brace@microchip.com>=
