Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010004.outbound.protection.outlook.com [40.93.198.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EC3E0C50;
	Thu, 16 Apr 2026 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776348639; cv=fail; b=F/id9PSPtbyHc7cZDVXXV9wYeg9e8niH8R2QHf6Ayk3kVGiNrFDiZo/DsP8HGfwHm/wFUplj2Sq/pQuLoOuSBglDnZH7UL31+hiMObhajuwwxilpkAT6Q9TXhWGpO8j2woFz9TUKsJYYpg/OGnnQQdU8vFoi/dnS5gUpmnwAIMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776348639; c=relaxed/simple;
	bh=yJaKoVN6vKBHD4IyWI/vbGT/9ZnKAAH4n7aNevIS9dk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aW3M761FXm6bsWWw7+GUPzkHvdVDpvEM9lL9/QfITbnCvN4RPzx09LjPyl9O/HjVtGl+51ozmhcvq8W5nQpctAr8gwuNld0O7JcXahEX3mh48RLXPRJE5gc/ERtJOHXcEbGQCOhve93K0u4+IfSVUk8AVwaDW52VbkqppYWDSoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=NJHRndHl; arc=fail smtp.client-ip=40.93.198.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="NJHRndHl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eU9uY3VaPdx3WkK15jSJUsUwYsOnOEDjJhDiGEveDUjFXr9HtyXdDEO8CYnaJNxRCcXv6+fhenjPVm799BC+pfP7aL+PZj7PsR9R22Te5gMWV5P0jlCJtekZ+n5ynpGS5C+9dwa7iu0HLdLLYoDc6/NAiJ5kKS/KuFJtT9LaFUg9fyHSuGQKWXG87OgL2wplNdZudbggJVFhOf76LV47A2S9Q5vg+pLf2ztP63CyPbzlz8UXjYTeVMQpVHVqbzfrp+7d/r+j/NSsfFXL8tYVSDLV7HtrRPGz7mb/VNVlEAsI5XmpogDZ8clbPhnBwLTAePSSaPv0FGjWRzY+Pq0UhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJaKoVN6vKBHD4IyWI/vbGT/9ZnKAAH4n7aNevIS9dk=;
 b=VBtMH/46uVd6JlGhPQxc3luRjY89iOJzY2aPIBo9Ms9v4PvdMHoRuJkGnfT+Ug49kPAbco8YAeIau5rIS9BOC1GJmhCE8qoKIjZsi6cQyGnCi+h1gVPtmVLlt6CgNcVmZLH3XYw7kVusVUwUIKjZUCCCoV409C+aUFXJHxtIC7qjh1AKAB9lSfQEomGy7KevtPMIjXp76ARykLuWXOl68+vip4Dh53xQrLctZvznLs3duBiDflG9gn7Ok7FRFQPX08dsWVGFb97aDAWtcX+hf2JfLQpKClwERKpgCroGthrTLsj2ZWTCnxiWQ8GIpD1RzpbqSr/riHfxQP1gmqfnJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJaKoVN6vKBHD4IyWI/vbGT/9ZnKAAH4n7aNevIS9dk=;
 b=NJHRndHl6axaZIVC8EjDLUpGnhCqnHT3vBEc9REeKG9ZGD2q+XLQKdPjZmzn9gntM9fwt17iE/Rse9ZZcB+8jVWO5zcormJBtrFhJUwo7DCK3E8HWxHkAHMRzvY6sRGPXgKYRc4mBMuj/ptCmHrZJfMipbYEdL5y2z0DSkvlaSyy4/+HUDW+MmauWDuAXACjIIxMGcRVzxP4XSqwxJaIebkWH/3Th928VwZxO9uRDLB4mK8jtLciD5H0DGdRXLieJuTFMjCppY3G7OmY2m+fYTQvOTxi1RFYbNiYeTWMUZwgpFfOI49xBfwx+WIrXB278qGMR2SSTJPS5mdivkP/ig==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by PH7PR11MB6676.namprd11.prod.outlook.com (2603:10b6:510:1ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Thu, 16 Apr
 2026 14:10:34 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%5]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 14:10:34 +0000
From: <Don.Brace@microchip.com>
To: <martin.wilck@suse.com>, <martin.petersen@oracle.com>, <hch@lst.de>
CC: <linux-scsi@vger.kernel.org>, <hare@suse.de>, <lduncan@suse.com>,
	<mwilck@suse.com>, <storagedev@microchip.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: smartpqi: use shost_to_hba() in
 pqi_scan_finished()
Thread-Topic: [PATCH 1/2] scsi: smartpqi: use shost_to_hba() in
 pqi_scan_finished()
Thread-Index: AQHczRlQlfa+i2sIeky8XsR+W662erXhuZdv
Date: Thu, 16 Apr 2026 14:10:34 +0000
Message-ID:
 <SJ2PR11MB8369BEE9FF784E978B3A422DE1232@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260415204850.799431-1-mwilck@suse.com>
 <20260415204850.799431-2-mwilck@suse.com>
In-Reply-To: <20260415204850.799431-2-mwilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|PH7PR11MB6676:EE_
x-ms-office365-filtering-correlation-id: e705ff1e-f01c-4bf4-c652-08de9bc1ed22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 XpBikAi5kvxWLgS2LLTlgH2PnoqceM094muEsmVleeQSa6QJjpiZwW4/dUVuyzapSmzXhJk1xcgjjOAlbjdY2ql+OSP1zakbVxwtBDmKEUmvvPYATrBKnlw52+x0jlo8g9mtFCUkyPNUy7HcKnNaRdP5r4cZMxz2ILa0xYj8S9IcsRzfHr8Eyvkw/5jg/yez1Jem7LhkZwv+EAmuI/y/sY/fkB8VSKTxLsNu365fJbWYINLXVgtiuqVGRy3dUM6UaTgatYkJcQ8IBk1otCboaZoa8SKrPdfA6/Fl6l53h1RtOw1fbvUEeblsmbtngSSxgumvImFm6LMfgIqSA6gw2XTx8FN9yF1DNf2BUojsA1IVcB5B0A+Zrj9U+4Da+QCm2u/dk3wuqEKC9et4Zc9oAutYQW+GWkSgSa6fety8aiFNfzXHtTglcxorkwtswcs62fA2bgkvdi3wbR/ZGtRZ1Is45jOGhGGz1jWsDm4i0C105yZ7l/Psq4odOYhA0tQfpCmWX7scX/tj/5AFUcrHpqXGfpJv3ooHfDWsK3oIRN9OshV2pKxAOkbGRdWtztG864ANXc4+dND7RgzemoiTfeY+i6nyOPxuUDW5ZHyHXHgjcZfs6VipKH/A3p+BPmHqK0mJvgDeO32tvVesPlerDmeyLdlIc8Oir89Cu3DVwZpMy5NvD3qygTmTnG6xfB2qlrxzzq/JhlHe/BNEPd/eXCSh3zNAKqXYa1z2hbW+Itgbc9emSGqgLlCKtk0pvR0hbd+Tm+eu/+Dhrbida9WBLcg3PXqiBkOrDW8q4JwmCOs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?tDC36vsbL6HU+NOzMSaEqEREgZVhe0TKpARsL0+C9b3bKOYpzXG8zS163P?=
 =?iso-8859-1?Q?z268CC1OEbtPFHBuHhSyq0waslkDoBnCFBQnqokIvHp2ZRGp4uQLL8SXA4?=
 =?iso-8859-1?Q?ZyT4bhx085ydjV8mrSAJWdDmC3LAWOlLQNAN8Tl3aB095mJ/e3GviwD1Ab?=
 =?iso-8859-1?Q?dHpZ330RtXZ6f+5E1uWvpFpUKtGNCKjZEwigdviwEMEoiHCjX7UkA863+I?=
 =?iso-8859-1?Q?NaJ3RiIwjS+FPlfYi15e6b5EObUjlX87iXnTG9IdeKu2XkbCRVmS3v/pyx?=
 =?iso-8859-1?Q?hGtJwpnUroGMAUkRqLtdinYnCjjgvNVr1sOJVMmS7l77TA6beVs9wgKsOy?=
 =?iso-8859-1?Q?DYJdMJhKtcLPUMcU5p7GnLla7Bg70lRgD7GjoRpiUD9e2gM7zZdVEHMPKF?=
 =?iso-8859-1?Q?1WAimybYhM44+OxVLVPJB8776A023k7/LK9jsQaO7qRyCnTLTAn/0ipbm6?=
 =?iso-8859-1?Q?0Nsq6b6hCS9IMNT2/Vf5SajI5+98m2Z7h1M21Vfm1n6sCf5rZNCB7PVHRB?=
 =?iso-8859-1?Q?J/0HFh+hVIiK7HgB4wq+lP1AZZKhiAPg4XAR7ZMnhxlfhE/bKi/BecdIFp?=
 =?iso-8859-1?Q?g1OYX16CyWJIVWR74+wIap2rNjwV/vEs59MlFFBCqd8GSVOq0jumRy9Zyd?=
 =?iso-8859-1?Q?qoiftxjnMJOHs3Tdtuw+PVNboaiyMbnPqieN2MLeyqO8lvhEASgD/w7mZb?=
 =?iso-8859-1?Q?7KgtVSCLEgsDwooD29yHIIaB6bkMum2oMuABci7r8aKMq/qLk6AmjxZtxq?=
 =?iso-8859-1?Q?R7K95twxHc0/6v3Sa4buGCF9niqxAKlH0rNoupP+3r4MKgZmRP4FpZsOA+?=
 =?iso-8859-1?Q?Pi+J/zEAihDTlWoOCDPL0HUk/SEHXCL1G0zat2VEXvUuw4rfVeg+gvFsm+?=
 =?iso-8859-1?Q?GJv0LvhTm2KHAii+X5BgNEOKJdFbJmJHQzsEAPj95y5T8eMuCTSix4JO4d?=
 =?iso-8859-1?Q?moJqryVQnPbgr0AJWEcBAyCNJj3975MHpqm0xR8mcvfVVz9aFsWVddjglj?=
 =?iso-8859-1?Q?4wwpm1PS3NzOOQ05NE0wfReFxeNCIb7sbrfBqJeOLoTlPBXIPe8195nSQ+?=
 =?iso-8859-1?Q?L4RwylDPkHxxnaISodT9MfGpJ0zHXwX1plbXgxxZxQrJQuPBfk6yzPyL57?=
 =?iso-8859-1?Q?1kklTisXlMOP0uv+kJH0D+eELMGaEUNbZdvGqJ3b05X2sCAhYji/UP9aqx?=
 =?iso-8859-1?Q?5MJkQ0fDxsSDZFNvKlhBZd/iefjmn817XPDwiB+yWo0rP6MIXHYFULBBde?=
 =?iso-8859-1?Q?0e6GiG4vzRTSvv/0N1J0hr8YTs8jMiJigZdpnXVo6NlNscOzI7ZuJVZ22h?=
 =?iso-8859-1?Q?PjRlaP6VbYlOYRqsriWn/d7oXb4MzM8B6+Mtg1YCcAZY/ras/AwyppgDMg?=
 =?iso-8859-1?Q?+w6lIABvNFLhlTI68tHPzaBtfXQrc2lXOBOqwvmH66adqiKSu0dnWXb/dT?=
 =?iso-8859-1?Q?L4mVsFTclNFhwxVroNZBQq91DbRZtHnJcYRL0vWNmMSQF2ga5J026lKkS/?=
 =?iso-8859-1?Q?ecA27h//BXXbmGKrkov9GJMmjwTPPD1PVgFaubsFRIGpvkEsmBLDJEAy8C?=
 =?iso-8859-1?Q?H9viFIIySi3WjkaGQwtUmqrtSvSr7DUmufueJkdT4z//NIJLuzhjiDNHGl?=
 =?iso-8859-1?Q?R55VVfHaUH7bD8wHQqIpVOh4RffvRG7vLdWq6dS5y0RfNndh6N32OT2vx1?=
 =?iso-8859-1?Q?kNxSfaCsRP4YpXX5Iwe8PbJubJCM89KfgSTmUzl9hqbw4vysB6FOLBepCJ?=
 =?iso-8859-1?Q?HC032Visk8OhpZxTI8c6YJ9Qc8Bdf3hCNhecQ7SSF4+zJ9N2pN7ykxAsGI?=
 =?iso-8859-1?Q?+gFij42kdg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e705ff1e-f01c-4bf4-c652-08de9bc1ed22
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2026 14:10:34.2319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5gW6glpV+23c923JaDkv43VxMDOZZeRx7bzHJjvFQScHlbWB2rMQ9D7+oA6T3FjxRJiwxmUBJOHvInpMd2/DXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6676

=0A=
________________________________________=0A=
From:=A0Martin Wilck <martin.wilck@suse.com>=0A=
Sent:=A0Wednesday, April 15, 2026 3:48 PM=0A=
To:=A0Martin K. Petersen <martin.petersen@oracle.com>; Christoph Hellwig <h=
ch@lst.de>; Don Brace - C33706 <Don.Brace@microchip.com>=0A=
Cc:=A0linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; Hannes Reine=
cke <hare@suse.de>; Lee Duncan <lduncan@suse.com>; Martin Wilck <mwilck@sus=
e.com>; storagedev <storagedev@microchip.com>; stable@vger.kernel.org <stab=
le@vger.kernel.org>=0A=
Subject:=A0[PATCH 1/2] scsi: smartpqi: use shost_to_hba() in pqi_scan_finis=
hed()=0A=
=A0=0A=
=0A=
shost_to_hba() is used everywhere except to obtain pqi_ctrl_info=0A=
from shosti, except in pqi_scan_finished(), where shost_priv() is used.=0A=
This causes one pointer dereference to be missed, as shost->hostdata=0A=
is a pointer in smartpqi. Fix it.=0A=
=0A=
Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver=
")=0A=
Signed-off-by: Martin Wilck <mwilck@suse.com>=0A=
=0A=
Thanks for your patch. Makes sense.=0A=
Reviewed-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
Cc: Don Brace <don.brace@microchip.com>=0A=
Cc: storagedev@microchip.com=0A=
Cc: stable@vger.kernel.org=0A=
---=0A=
=A0drivers/scsi/smartpqi/smartpqi_init.c | 2 +-=0A=
=A01 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c=0A=
index b4ed991..65ff509 100644=0A=
--- a/drivers/scsi/smartpqi/smartpqi_init.c=0A=
+++ b/drivers/scsi/smartpqi/smartpqi_init.c=0A=
@@ -2642,7 +2642,7 @@ static int pqi_scan_finished(struct Scsi_Host *shost,=
=0A=
=A0{=0A=
=A0=A0=A0=A0=A0=A0=A0 struct pqi_ctrl_info *ctrl_info;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0 ctrl_info =3D shost_priv(shost);=0A=
+=A0=A0=A0=A0=A0=A0 ctrl_info =3D shost_to_hba(shost);=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 return !mutex_is_locked(&ctrl_info->scan_mutex);=0A=
=A0}=0A=
--=0A=
2.51.0=0A=
