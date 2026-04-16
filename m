Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CFB41C72
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776348853; cv=fail; b=lW369/NG7VA6ChKVJPfTJTi8j0Qi4XS5I5dxFm1sE50AYMeER2P4jxEm3R7sXyvjZHwiRvMaLTH3Ux5MyE5tSW5/BrYYS52YHDFRSoqPp0fv4/N5jL6xj+vffHdwL/XZcnZnJEuO+tTDqBEdcFr9t6i+XaQjcVJ3GZWfQ3O4KV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776348853; c=relaxed/simple;
	bh=k2jO3nQfrvBQeYB999Mh7RV8npzDk+JeBp40uL+X1Es=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=duKjVmgbRfoJsSVvaDxrZGAaPgy8Zo+imsZVJY1mHwQYYJ3TUe+DiJ87/zgP8vFGqHzF8revdp5bnPnRIeW43U+yBVe2Z/QDZYcBUCu/b0WjfoYtlQpZowEk4tXkJBqZQQlI0K5qV1zf0rz+fdLe7zN86M19om+3EOP7gOjKNyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=guHW10Qg; arc=fail smtp.client-ip=40.107.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="guHW10Qg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9Nm8Cfja1TmtZCPN73w1CsXXGzbVlPTWzQ7ax4Edm6AN5T1jngqAEWIc7ze7kbtf/nvxiIqeK10wfRExCQ/gdXZrBGjVyjoFeS1zZ35BLaAq3dxJ5WCxpPC2qigGLXpwV4AK/TVPMcTz8Y5urVF91S+CQ+qjqyI74PF5Rg8zRc2usC4yO/b8o0u1R/VX7VISP2YDnLLlQIWiVTybuQy38iwL9/SvH1WW1wEkx/uPcjeuvxi7TJZYNH6M2wC29Xr8lVZsCcAK4WZXYM/EhmMf7PUWIfDsBpjoCJGu964F5475K2r61KFxertFE5IwI9QptqaxAL46og0jdx97jxFsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2jO3nQfrvBQeYB999Mh7RV8npzDk+JeBp40uL+X1Es=;
 b=n546MhQ7O8Zl9pavd0jgxhhNWSGs49l494bdscIG4d59T6uIhroh6G9ACnS26Q42KJGGwSoFzbL0I3NViIN+GHWrhriJaRU6czSo6my6RAcymSqtkr0ebWt0aZ6CeXv9/5pPFj0JiZQV00sAMggITbOj1T/9aRx2RPMeETiBXMxkrVML9WP9J6OEm8SIzvfgfXBS3ftYFE9h4HZ3giXH8jdTF5OLIiS7HqahyvU7/B3HWaLX3XjMViycIaMAERbUD2hTM09n19FCR2uXR1WTlW2VsKSVQPTD/WUjGuEpKTxtlc7I8/5y4IZCQy5thETlJcv/a0IMm/5e0lrBnQY4Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2jO3nQfrvBQeYB999Mh7RV8npzDk+JeBp40uL+X1Es=;
 b=guHW10Qgk0IQlsvpxvQYHQPHiiGliszalu8Ab02T4s8IeiFsMN6Ds5Gx8Kpo4VtMZRLB2BzSngwDSRRwrHeUk2EF7jdeT9UgAp5RCOc0x4YRpaN7hZ1m6hBN85xKA4wVkotFg8tK830WVvYZvzorBGHUg2P7XmNSxXoEctVIsojarxds9yuPDc4RNqicbR7Acb+qu8IlMsRto5/SXBmxrTXpwkVaETKr1UFJ+UK23BhZ9/7XsPKYEXAp7/LWF2wYuv8YXzTLH4Kg/IGdKp4f129IAdfZVYq6euylpvcKQGpDoca2NngmYzGV3s3hybHkAdwCnowKRNaqn/qVGGBhEA==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by PH0PR11MB7165.namprd11.prod.outlook.com (2603:10b6:510:1e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Thu, 16 Apr
 2026 14:14:05 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%5]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 14:14:05 +0000
From: <Don.Brace@microchip.com>
To: <thenzl@redhat.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: smartpqi silence a recursive lock warning
Thread-Topic: [PATCH] scsi: smartpqi silence a recursive lock warning
Thread-Index: AQHczAwF++wxSzVA8UG6FnpkORS8QrXhvavm
Date: Thu, 16 Apr 2026 14:14:05 +0000
Message-ID:
 <SJ2PR11MB8369F674FE68B41AFDDF5AB2E1232@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260414124118.23661-1-thenzl@redhat.com>
In-Reply-To: <20260414124118.23661-1-thenzl@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|PH0PR11MB7165:EE_
x-ms-office365-filtering-correlation-id: d53c83d5-569c-4aec-1d44-08de9bc26afc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 0VAyxu8HM0coAdv1TOlhWDqxTFPlf1Cz6ZSqdBltEZ4WaGolVGIbmX4jo+PumZzk+cUJA0bWv5iha/0/SAAk1TFrFVH/wgMCXqeZ74IxLAbGs8VNXpKkWGUoZFlutInceXk22tygMH7NWMgdyjQ2SZmfaKetxGvPUQC0xBpF3+JdKprNsbbBMeGLD/lvC5Zj680o/pPrHgKbUQRm8I8KKhO5BCj9sMlBIAZn8XYP+xLNvN+9iUkPAPZXMgbX8hJi/ceKxbkJ2t9oOT4b06XbraFC4dwavcmnw5yq//LWvKY8sjdM5ZG2y87j7L4Dx0xViNrz5JF4AUZYe7kBlBUUoPOC9Bv4SP5XfNseBvNTllkwFRo/QpSXNCK3UNXvMYq19UCrEJaLGGqSU5eTtGgofnWrPj9YkQmJwAo6FE+jPeS80jyPePLQ4Q4xXjqwNVF56Sk44V/Kxop8lKfiyFP6aKFUa6siT6OiQl74zewchr02wB0v6EZqcATsFm2nCGSBiLAsCsb/ZqLh07WRcObxIW6AaynbiiKw9dPHGWPfmOHCouuMPyNVN/nAxrPYKpSjF3nSx67pwrrdSUq1yuuE7JE0Qczs5CPw+LQMYsZwpDw02Aw8WooKLLE5zXTfI++ePhTX7bvyLUp714hMIElF57cLtbepDKWrJSERyzlwSjhgePZKTjAsX9rKVBj9Q2K4CmHOWu9RjnQCtU7IK78TZiFE3MPcT+NyknR4d6kDHWbWFuFH9B9v/BnkzqleYbWdje9heEnyfG12s0NSm/+Ug19i2b6T56YWHfDkwTAuZ6k=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?iIvgBEWn4ccPgt0ZPtvUulCIXSSbsdM/sLV7zJ9TVYllzr3Kp13skkCz0h?=
 =?iso-8859-1?Q?q8WVjbEOUbbpX8hyTbwpXVFXxyMGX50NeYWlXUZ6hp+L86iTKC4FaU6czD?=
 =?iso-8859-1?Q?R8vvZhH+agDsJSmk6txC5Aw8aBOTIbOzKWa++aG++ewXbmhrbgBh4Dquoz?=
 =?iso-8859-1?Q?7DXisr6LTsgFcS2IfobKCJMHz0PUzL9z6lH6N42+zhnF8+zIL33Y1uhRDk?=
 =?iso-8859-1?Q?1V57p2Al+mJEPi3XqiZCKGslIsWghzRd/YFaidBMAezRj001hAdNg/vIMH?=
 =?iso-8859-1?Q?j35CVdkCO40he5wZ9iYd6/5a3XZHU0pAWC07tnomK5n2n/4jQaE88ioHi6?=
 =?iso-8859-1?Q?Y1UVgSEUsdeAlFGjXb9Lpt9ndFMl+uCTZoHxXVP5FmW2AIiHv3xNhhbESN?=
 =?iso-8859-1?Q?ltvsXGgSKpthsB51OaptyL9w+Vv/Jb/+7f0GMy3STCzfUY5rDvz79HBd4s?=
 =?iso-8859-1?Q?Am4+D7tmsuQDQ90fcV8QNfwqqgZyhWPajx2ZzQg971Q9EevjjCiMWdcXUi?=
 =?iso-8859-1?Q?WSb8ZIIo7lJTbr/dsn30L+++or+8KafM/x2NEvOETEu4JbWHFzzXo7x+9K?=
 =?iso-8859-1?Q?4BKv4HCoVvmTd3AHXV06lpSU739SPCTVkMJFzJj83f2fE9Q3duauAdPFg2?=
 =?iso-8859-1?Q?26+Wz78IOExzdQJIS637gCGUu4hM7ytF44/641TFSju7mK9CTtGX5EJ4Iz?=
 =?iso-8859-1?Q?jDUn65cSxoy3GtTzdWRNQgnau9VgkXIM7BOtbf9Uv6oLg0uZsYSGWT4+hQ?=
 =?iso-8859-1?Q?RH/mR80wactcD82DSts1Mtkw1SjSCK8vMwkaWCYY7dFbMOMNIIVZiT0Enz?=
 =?iso-8859-1?Q?rQBcC21kCYU7ecZWJSASZC7/5TP0w8qm/eiITivs6BHHZBErhZAuLzUgaA?=
 =?iso-8859-1?Q?CDbfXFBisDuS33SF31DIq3XWG4dHuRPN0hiE6I0wNRDsYhj0CwmfjZUZFE?=
 =?iso-8859-1?Q?ccAHk/E5cZRE8cRFj9ZZxJFufSzi4GkKN8Rw+/Id41ndkXSlUZF+Y6nSNK?=
 =?iso-8859-1?Q?YlYWYbSOQEu+AbwtUoZypApg7XClV7nB94lBioIN1W2XPFuVZqF8ISz6H/?=
 =?iso-8859-1?Q?pIlb2pB0f5/z91ltEHKu7HVsTAJlGF7sev96fcWGJGP+Gwh1efxx14Mk8b?=
 =?iso-8859-1?Q?r0rZSrYFVwYXPtEi8oC8ELdIdmYleGuX+J9ovMWIKPdfeMX2yI7zymPP+4?=
 =?iso-8859-1?Q?ynLLpCfaR0LZjNpEgFIYa6Kp2lKns/Etn94+ypoDfXEOlTt9Rq/DZhB1sy?=
 =?iso-8859-1?Q?PmfvTCy9gog5xt3cyWO/2NAYZcOKhqLpMJ2h0ZOwZjD8VtKTHY9FJqZK6y?=
 =?iso-8859-1?Q?AQrjoKGjFXal2GzSifXHAcL7GS5AYPvDo9Y/QRv/mPqnN2LSdZFDRKUdsE?=
 =?iso-8859-1?Q?yslsMhwjRVzQnJ+iLBKTsxjACDIvkGF8aDMkwz+vDyiurR9lBFHUqn1OZR?=
 =?iso-8859-1?Q?oUYYpNxAHguImeo2Lz4eDC1kYt5n8yflpJrN/2XHSvBU/n7ZcmoIaldFL1?=
 =?iso-8859-1?Q?R2JjXQVzDWry+PcD9gOBX8jRBVaa0q4yrZzjXIeUxnk/yHbipXV/3DIODD?=
 =?iso-8859-1?Q?zoP0SoHoBtGtIEIBPFCkyEuLFNtqkduG0Momk0oWyb1IpQT5FEowiOhgje?=
 =?iso-8859-1?Q?5qt8V1j01ucinNhURZOJnKxwqPoUGUQFp0xMCZNAMPNvGu+iURf+7f5SGq?=
 =?iso-8859-1?Q?8kVKOibS5R9BtrtWwrTLvZl/GkF/DxMCMSO89jineK8FoSqMDmXbvbwgxw?=
 =?iso-8859-1?Q?eNw8MnuOvAYYn+k/8TH/x9Vc19qazFG/93BS3aa8icLAUKzMZFCKj/1XFM?=
 =?iso-8859-1?Q?RqztNZe0bg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d53c83d5-569c-4aec-1d44-08de9bc26afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2026 14:14:05.3587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OBU7Ve6xY9dwhnNOV711pTZjqL7dnVfk2T3yVGD/oHID4YgdiVayODqK0gtgEBlhTdXqvzX6xtcRMzUc7eiiEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7165

________________________________________=0A=
From:=A0Tomas Henzl <thenzl@redhat.com>=0A=
Sent:=A0Tuesday, April 14, 2026 7:41 AM=0A=
To:=A0linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>=0A=
Cc:=A0Don Brace - C33706 <Don.Brace@microchip.com>=0A=
Subject:=A0[PATCH] scsi: smartpqi silence a recursive lock warning=0A=
=A0=0A=
=0A=
On systems with multiple controllers debug kernel shows=0A=
WARNING: possible recursive locking detected=0A=
during shutdown.=0A=
Each controller does have its own ctrl_info (and mutex)=0A=
and that isn't correctly recognized by debug kernel.=0A=
Supress the warning by releasing the mutex at the end of pqi_shutdown.=0A=
=0A=
Signed-off-by: Tomas Henzl <thenzl@redhat.com>=0A=
=0A=
Please fix spelling: Supress --- Suppress.=0A=
Thank-you for your patch.=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
---=0A=
=A0drivers/scsi/smartpqi/smartpqi_init.c | 1 +=0A=
=A01 file changed, 1 insertion(+)=0A=
=0A=
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c=0A=
index b4ed991976d0..2026ac645d6a 100644=0A=
--- a/drivers/scsi/smartpqi/smartpqi_init.c=0A=
+++ b/drivers/scsi/smartpqi/smartpqi_init.c=0A=
@@ -9427,6 +9427,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 pqi_crash_if_pending_command(ctrl_info);=0A=
=A0=A0=A0=A0=A0=A0=A0 pqi_reset(ctrl_info);=0A=
+=A0=A0=A0=A0=A0=A0 pqi_ctrl_unblock_device_reset(ctrl_info);=0A=
=A0}=0A=
=0A=
=A0static void pqi_process_lockup_action_param(void)=0A=
--=0A=
2.53.0=0A=
