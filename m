Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFA0392C2A;
	Wed,  9 Sep 2026 19:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788980553; cv=fail; b=hDUT07mmj82OCk6lhR6H19gDWxqLlrAJuO7nPk7zJnDq07pvXKM2Dl+oXimySWNXZ/C2yvqkHz+bw8J5phmt8u/K151dx0/H/Z7ljLQ16Kgat7q9aYw4tf0HloA/64ePQYxTm2Oc362d39AMy3QYhwby4Sr+WCZdYIF7vfbJnzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788980553; c=relaxed/simple;
	bh=I4+89MiL1t3AK8h8ZY9jhD4YGaUcTri1uX5SEE0SRSU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ok4PBU8xLbtMn6SkOVgp6PGAaSzO3lWerXhznUXI9jlcaKHT4sUshzknS6BnIWg3x5jpY1yRdcUbMmClMhPHufS2gU9CdwPxhvBzVEko8ZFJfW5xiVCdkidoI467pT/wr9TCzYJSpW4VUh2ssHDismBMLZYvsuZRUyAZAOlBEeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=HXd4tcW8; arc=fail smtp.client-ip=40.93.194.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="HXd4tcW8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zz1pi2Z8/swrQ2eQr2p9eY8sIB3nQmbHZyXEj2x4XldSxhowSGjkXvubncxXIOD0J+/JHpxunkvNMQitcNSaWTZoI5eszaNp47O2bnvTTEm1rxI+zooE/Ac6CBVU2ApSy2aLn9MZb9YymjcOWaz2/AELUKO+XRapbugmyz6Y39XUkk0MoJhDAisYLI8lFp+hdJ+Sxl1SHa9Ih2EWm7HagWYwOmwPOBRU5Am1L2rD2hvS+OYnIoF5reJLf16tda1vQ84+T94T9Nk6J8g+grRCFjdEFSqTkkndzVC8lZK2NueTx5DGBBf15/QN4zvUOrzRYirOjmrK2BQ14Cf4j4tvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4+89MiL1t3AK8h8ZY9jhD4YGaUcTri1uX5SEE0SRSU=;
 b=eaoBRXgVj8PEoMdkA4rnxb9wYb04Sns05vfOCZA731nfGGdYoGi/121JiztRII+56pGUWm+pbFqfKcFubiChCdkZ/VuuV+rX573Hskszk4SkOtgIc87d8Rzdk1Ofa7KVLHAHBUrwuFo7SoW5IsSvJGEbKSZjbdqy8H42xsL3fIUIqQOSJjLYiK9lUykGmyGpz+vY2Am8ZsfBgH4cU/GnA4WQ/4ZE+0wnANmPI/ZsWo8m8igfQrcDX77i1iusOq69ylEy6UtGaXNtCdAzos3zNAYtQcA79mRHGl/rLH2pRxoi/aIgrx8gGAGIxNzt9FOS6fwptZ6JnBqCInkHM1iFeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4+89MiL1t3AK8h8ZY9jhD4YGaUcTri1uX5SEE0SRSU=;
 b=HXd4tcW8WOKgBvykZbZCO1maMivzX91MTC3bw1+q6gP+IgOTZbfK8BuqsyCeyIyDOADvF800Ty2DvtIy83fLF52edXQc/ZIuaDMWoSt/r2kUy+2j04u6etHWDHTiIBffDwu+P6QHgxDnKRJ9pU6odhUDsvNGsmMVkpV1nExL69i5VzPv2Dabuv8mvWTUeQN5LSE0DsifcUf9vbH2GITKSm/Jqf6zeFIR+ZfFtQvsxWZaK8jWHJYSsuYRJ+YFK1KDlgOnY9NVOYKGGgv9Xy3M6XZraO8w6NmCmv0Xo6sHko5ji5wLLv7pX4IdTnPtOOF+fsrae7xjTXNFI3V92RaJIA==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DS0PR11MB6349.namprd11.prod.outlook.com (2603:10b6:8:ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 19:02:26 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%4]) with mapi id 15.21.0382.014; Wed, 9 Sep 2026
 19:02:26 +0000
From: <Don.Brace@microchip.com>
To: <dlemoal@kernel.org>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <linux-scsi@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <cassel@kernel.org>,
	<linux-usb@vger.kernel.org>, <stern@rowland.harvard.edu>,
	<gregkh@linuxfoundation.org>, <linux-s390@vger.kernel.org>,
	<hca@linux.ibm.com>
Subject: Re: [PATCH v6 32/40] scsi: hpsa: use 16-bits defined sense codes
Thread-Topic: [PATCH v6 32/40] scsi: hpsa: use 16-bits defined sense codes
Thread-Index: AQHdP3J2W+8tAW/djE6cvScNrIQCCLbGnBhz
Date: Wed, 9 Sep 2026 19:02:25 +0000
Message-ID:
 <SJ2PR11MB8369387FD288B23A40A3955DE1B02@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-33-dlemoal@kernel.org>
In-Reply-To: <20260908090308.1085097-33-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DS0PR11MB6349:EE_
x-ms-office365-filtering-correlation-id: fba16887-a457-4147-dee4-08df0ea4e339
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|10067099003|4143699003|3023799007|22082099003|18002099003|11063799006|56012099006|38070700021|921020;
x-microsoft-antispam-message-info:
 6YXE8hknq+32Wz3PD+JwERnNjGba6Nh/bP2ALNfxNucQ6g/CMMCxz/ZLRQlRcYiHYP0w0pHEXQg99atSy7m10UCAxnbSCiuYfqDMWyVQ4Jz3T1bO0KzU2Eqpea19iima4uuIwTGpBKyS0NFHSBFsOSZiwJSQ4uyh2wdLqhJwZ66vv2FQ2UNqjXapN8Wp0JtE7jmN1o6lKm1f2Y+XvkpRuDGMCgNkexmPcRbI/eXuq//jUaaLuH7Cqj6QZ7c3HVnsY9a26tGTribi/9YgOrU9wjNa4mLHL7unHq9TxnzZuPrIcF4/PnT5VWNu6xyjFF4O72Pb+qh1U+h6NRbWRF9CaiXB1ywEM/oOHgX8oDK7/vqCvx2J/UvL3uLqlU0xeBOfOM4GmRM4vr3UbnxFz/5h3gxKiEj1WTEJnaHRJ8KQuBPB/YLrbXzaS012yEY0gfzMmmpp6mijumMV6i1SRLEbpiAbOmQVIhPD+wbR6MVn8qoWJ0uB3EggDSKTag6yGOlkTKJ9CtRtLsByerNfOpNsP9Nw0rc17Rd4zWQwV1kGwN5WTJD55kpfBqGD6GyYWkwy9wL3oNwxkkHv/WuYl7BQ96H7Tgo6Lv+wCr/htoN4mKL9k+ZZeugsBNLeGumKgohs+BHgXCtX9aTDFoiuxlCfDAJ4hsEfnNWse30q2HsT4trRpSKs8djlavyiPgWk6UPllj8jFWUKsB6bwN0TlnlJseMYxuuvbkdB64TtHnnJSgwEADP5zxq9yUvnrUR6nXfa
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(10067099003)(4143699003)(3023799007)(22082099003)(18002099003)(11063799006)(56012099006)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?4B8Z2kscM6MxGyNP/qgc4TVQxyYIEj/aI9VYQ0LAtqkWgWYT72bSseJZ?=
 =?Windows-1252?Q?5Oj6xTshj5eNgpu0ts2uOJ4PW459yOZ57Qn/BCiDnGK1WUDUobV6glYz?=
 =?Windows-1252?Q?TgnPwd1BsbSX67cANTUWk/p+wK63YLAm/BxA4D6KS0M4yKKPMttnvzzJ?=
 =?Windows-1252?Q?PDhKEAzRMjNBRfuuKJM+jCNSnAvNsInnXa70sz6JPJGNGWS2HZH7q5WU?=
 =?Windows-1252?Q?F5yhryDxx74xzlgHfATqFWLc1aQE28fDzAPVfiHwXI9LTb5dxpX+8jDr?=
 =?Windows-1252?Q?jCPuC4u2S6lD5UuijF2Tdojon9Wda9aEGRVxNojL4k0v1r3lDaQ4okId?=
 =?Windows-1252?Q?3jERPGjBKfb28ezwkHpfzfL5jjC6V7F8ku3Kr8p60ZBwGc3UD0daH7Z1?=
 =?Windows-1252?Q?YffyHomSOrPuBkzrsX8QsoREFpsQth7v8LsvKfyS3Mk86PvsAgVCWBpR?=
 =?Windows-1252?Q?ZvarNgHX6Hx1TZi6rwY7MWGv1zI6H8uLWMhKeRjJ8eRsc9VTbH6OLy/b?=
 =?Windows-1252?Q?YjE87OyHw+sJkG9iDJTjTHeoSTPBk13ieTmzBnfN/ECyiDWSFcafZgxv?=
 =?Windows-1252?Q?AqTQlhLIV5U+Ac2TdEhmchLLbVHIaxyWbSqs4jgI5ZtKpomDZx/1GncT?=
 =?Windows-1252?Q?XMTTJiEUAsp1mF7/Hmkcw0VvXYdm801Al/fKpsqxRuEqfgRYkNY3tQXh?=
 =?Windows-1252?Q?t6B4v0UyhX/3VHbICAlP6Fq7S4LvUT6ZPoevtH1fx34+xGpCqDoY5bE6?=
 =?Windows-1252?Q?Uz+jG4cvazPqzlicwUa0KGbzmxrcnMjToYDBcTCBRgVGewhgzQk942Lr?=
 =?Windows-1252?Q?/IYjyJjo9yUqiNJ1Msc8+6M8nCG6KDYYWLi/YTtg3LCYHdT4yNGIaUFj?=
 =?Windows-1252?Q?nk/MkvP+JMhwqxF2Tk8Wd7kW7tPihxl62iWO2wzUffB254YntThg9uUK?=
 =?Windows-1252?Q?wG0rHx+mqoVfUQ8esl/LSSno3r263ousgvsXFaHe9DprQktXztUJtMWO?=
 =?Windows-1252?Q?AnB+SoHHKIm4VNBUrFpk4Qjr7EqFfN16B9nC7umwIUqRdtuZVbSMkYHH?=
 =?Windows-1252?Q?HawRfpOXWzzaBm5h0F9GgCDsQKPpBDs2QG/ilslJTJlEHqIAiWoVC4WC?=
 =?Windows-1252?Q?V1GPkKfVeHBFnaOZag6U5hTiXd7g7w4gIxa/hX8xl+pv7q0bIqUKPU9j?=
 =?Windows-1252?Q?Z7vndLCN63OEXE3FLC8kXlo7y4itkuK3q/5J6tfML4iFHx/uXK35s6f1?=
 =?Windows-1252?Q?dVCrDdm1SswGJXXsD1HkuhOwJ+eTktoJBRQwBBwODqCosL0bCWWSHSjg?=
 =?Windows-1252?Q?QgFD9tW644WaM2IPXU1dBZZVIcCN0ZGmmqnmjxuwkSLW1lC02L2OLdoW?=
 =?Windows-1252?Q?K3ZvkBjJmGqA+sh6JL0o3xZFZ2eN0yWNlM5vnwLjK/Pzc1j9DPeobQIZ?=
 =?Windows-1252?Q?d59n1Pug0OXsHUehuiuzHP5eu0zzTyUUQvEMwwNjImozS03LRaG4R74h?=
 =?Windows-1252?Q?OhnBhjr0cID77sbPNv86a5TP6ZVic+61Ops9wBYbm4d4Cip0CifBvICg?=
 =?Windows-1252?Q?hHIQBX4DXhoBrUHq3k4sl60Ww/R4NH4lJZWm82xQNUmbMb18tVUaJEkl?=
 =?Windows-1252?Q?SfHHTuUad3KYPXFnmwBkNdVcl6Q85SXm5dRSxUXtfc0kO9OMY+GcbNt1?=
 =?Windows-1252?Q?OFWRGN3u3zUVcd3D0O2VJRsEVumAGMvNUP2qwFqPQCwvh2ViDp8rHkBT?=
 =?Windows-1252?Q?DtQuGB8TuU4VgRs2tbvxI3E7yVk48ZWV5CNXk2nNUWe+UT8tXoXCkFsc?=
 =?Windows-1252?Q?sVrtYGyV5MRCCoPqUc9p2OPKoiNgq7bbEMtqA87LATWVow9/LyRr8aVq?=
 =?Windows-1252?Q?px9JKOo7vrX+MQ=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fba16887-a457-4147-dee4-08df0ea4e339
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2026 19:02:25.9211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mWoH7pQxT1F8dS6JYmF+0lRDMNm0+UxSqiYsnAlq9YBfeZZawIkrRwCw/76MwCYpLZ6yZ2zfKwE4qa3IbvKPKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6349

________________________________________=0A=
From: Damien Le Moal <dlemoal@kernel.org>=0A=
Sent: Tuesday, September 8, 2026 4:03 AM=0A=
To: Martin K . Petersen <martin.petersen@oracle.com>; James E . J . Bottoml=
ey <James.Bottomley@HansenPartnership.com>; linux-scsi@vger.kernel.org <lin=
ux-scsi@vger.kernel.org>; linux-ide@vger.kernel.org <linux-ide@vger.kernel.=
org>; Niklas Cassel <cassel@kernel.org>; linux-usb@vger.kernel.org <linux-u=
sb@vger.kernel.org>; Alan Stern <stern@rowland.harvard.edu>; Greg Kroah-Har=
tman <gregkh@linuxfoundation.org>; linux-s390@vger.kernel.org <linux-s390@v=
ger.kernel.org>; Heiko Carstens <hca@linux.ibm.com>=0A=
Subject: [PATCH v6 32/40] scsi: hpsa: use 16-bits defined sense codes=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
Refactor the hpsa driver to replace all hard-coded additional sense codes=
=0A=
and additional sense code qualifiers with the enum values defined in=0A=
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes=
=0A=
being processed are easier to test and self-documented.=0A=
=0A=
The function decode_sense_data() is also modified to take a pointer to a=0A=
16-bits sense_code variable in place of the two pointers to the additional=
=0A=
sense code and its code qualifier. The local definitions of ASCs and ASCQs=
=0A=
are deleted too.=0A=
=0A=
No functional change intended, but the function hpsa_volume_offline() was=
=0A=
checking only the addditional sense code qualifier with checking the=0A=
additional sense code. This change assumes that the intended additional=0A=
sense code to check is ASC_LU_NOT_READY.=0A=
=0A=
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
Reviewed-by: Hannes Reinecke <hare@kernel.org>=0A=
=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
On the hpsa_volume_offline() change you flag in the commit message: the=0A=
ASCQ-only test predates me, and checking the full 0x0404/0x0402 is what=0A=
was intended there.=0A=
=0A=
The tightening is only reachable on a non-legacy board with an LU that=0A=
does not advertise VPD page 0xC3 =97 on legacy boards the caller overrides=
=0A=
the result back to online regardless. Those controllers only report NOT=0A=
READY with ASC 0x04, so there is no behavior change in practice.=0A=
=0A=
The rest is value-exact substitution; I checked the constants against=0A=
scsi_sense.h and *sense_code =3D -1 still trips the asc =3D=3D 0xff invalid=
=0A=
sense guard through scsi_sense_code_asc().=0A=
=0A=
Two typos in the commit message: "addditional", and "was checking only=0A=
the additional sense code qualifier with checking" should read "without=0A=
checking".=0A=
=0A=
Thanks,=0A=
Don=0A=
---=0A=
=A0drivers/scsi/hpsa.c=A0=A0=A0=A0 | 69 +++++++++++++++++++++--------------=
------=0A=
=A0drivers/scsi/hpsa_cmd.h | 23 --------------=0A=
=A02 files changed, 35 insertions(+), 57 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c=0A=
index 8edad1830abe..795e8c7592af 100644=0A=
--- a/drivers/scsi/hpsa.c=0A=
+++ b/drivers/scsi/hpsa.c=0A=
@@ -353,14 +353,13 @@ static inline bool hpsa_is_cmd_idle(struct CommandLis=
t *c)=0A=
=0A=
=A0/* extract sense key, asc, and ascq from sense data.=A0 -1 means invalid=
. */=0A=
=A0static void decode_sense_data(const u8 *sense_data, int sense_data_len,=
=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 *sen=
se_key, u8 *asc, u8 *ascq)=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 u8 *sense_key, u16 *sense_code)=0A=
=A0{=0A=
=A0=A0=A0=A0=A0=A0=A0 struct scsi_sense_hdr sshdr;=0A=
=A0=A0=A0=A0=A0=A0=A0 bool rc;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 *sense_key =3D -1;=0A=
-=A0=A0=A0=A0=A0=A0 *asc =3D -1;=0A=
-=A0=A0=A0=A0=A0=A0 *ascq =3D -1;=0A=
+=A0=A0=A0=A0=A0=A0 *sense_code =3D -1;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 if (sense_data_len < 1)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;=0A=
@@ -368,15 +367,15 @@ static void decode_sense_data(const u8 *sense_data, i=
nt sense_data_len,=0A=
=A0=A0=A0=A0=A0=A0=A0 rc =3D scsi_normalize_sense(sense_data, sense_data_le=
n, &sshdr);=0A=
=A0=A0=A0=A0=A0=A0=A0 if (rc) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *sense_key =3D sshdr.sense_ke=
y;=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *asc =3D sshdr.asc;=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *ascq =3D sshdr.ascq;=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *sense_code =3D sshdr.sense_cod=
e;=0A=
=A0=A0=A0=A0=A0=A0=A0 }=0A=
=A0}=0A=
=0A=
=A0static int check_for_unit_attention(struct ctlr_info *h,=0A=
=A0=A0=A0=A0=A0=A0=A0 struct CommandList *c)=0A=
=A0{=0A=
-=A0=A0=A0=A0=A0=A0 u8 sense_key, asc, ascq;=0A=
+=A0=A0=A0=A0=A0=A0 u8 sense_key;=0A=
+=A0=A0=A0=A0=A0=A0 u16 sense_code;=0A=
=A0=A0=A0=A0=A0=A0=A0 int sense_len;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 if (c->err_info->SenseLen > sizeof(c->err_info->Sense=
Info))=0A=
@@ -385,34 +384,35 @@ static int check_for_unit_attention(struct ctlr_info =
*h,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense_len =3D c->err_info->Se=
nseLen;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 decode_sense_data(c->err_info->SenseInfo, sense_len,=
=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 &sense_key, &asc, &ascq);=0A=
-=A0=A0=A0=A0=A0=A0 if (sense_key !=3D UNIT_ATTENTION || asc =3D=3D 0xff)=
=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &=
sense_key, &sense_code);=0A=
+=A0=A0=A0=A0=A0=A0 if (sense_key !=3D UNIT_ATTENTION ||=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_sense_code_asc(sense_code) =3D=3D 0xff=
)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0 switch (asc) {=0A=
-=A0=A0=A0=A0=A0=A0 case STATE_CHANGED:=0A=
+=A0=A0=A0=A0=A0=A0 switch (scsi_sense_code_asc(sense_code)) {=0A=
+=A0=A0=A0=A0=A0=A0 case ASC_PARAMETERS_CHANGED:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_warn(&h->pdev->dev,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "%s: =
a state change detected, command retried\n",=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 h->de=
vname);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
-=A0=A0=A0=A0=A0=A0 case LUN_FAILED:=0A=
+=A0=A0=A0=A0=A0=A0 case ASC_LU_HAS_NOT_SELF_CONFIGURED_YET:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_warn(&h->pdev->dev,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "%s: =
LUN failure detected\n", h->devname);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
-=A0=A0=A0=A0=A0=A0 case REPORT_LUNS_CHANGED:=0A=
+=A0=A0=A0=A0=A0=A0 case ASC_TARGET_OPERATING_CONDITIONS_HAVE_CHANGED:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_warn(&h->pdev->dev,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "%s: =
report LUN data changed\n", h->devname);=0A=
=A0=A0=A0=A0=A0=A0=A0 /*=0A=
-=A0=A0=A0=A0=A0=A0=A0 * Note: this REPORT_LUNS_CHANGED condition only occu=
rs on the external=0A=
-=A0=A0=A0=A0=A0=A0=A0 * target (array) devices.=0A=
+=A0=A0=A0=A0=A0=A0=A0 * Note: this ASC_TARGET_OPERATING_CONDITIONS_HAVE_CH=
ANGED condition=0A=
+=A0=A0=A0=A0=A0=A0=A0 * only occurs on the external target (array) devices=
.=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
-=A0=A0=A0=A0=A0=A0 case POWER_OR_RESET:=0A=
+=A0=A0=A0=A0=A0=A0 case ASC_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED:=
=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_warn(&h->pdev->dev,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "%s: =
a power on or device reset detected\n",=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 h->de=
vname);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
-=A0=A0=A0=A0=A0=A0 case UNIT_ATTENTION_CLEARED:=0A=
+=A0=A0=A0=A0=A0=A0 case ASC_COMMANDS_CLEARED_BY_ANOTHER_INITIATOR:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_warn(&h->pdev->dev,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "%s: =
unit attention cleared by another initiator\n",=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 h->de=
vname);=0A=
@@ -2562,10 +2562,8 @@ static void complete_scsi_command(struct CommandList=
 *cp)=0A=
=A0=A0=A0=A0=A0=A0=A0 struct ErrorInfo *ei;=0A=
=A0=A0=A0=A0=A0=A0=A0 struct hpsa_scsi_dev_t *dev;=0A=
=A0=A0=A0=A0=A0=A0=A0 struct io_accel2_cmd *c2;=0A=
-=0A=
=A0=A0=A0=A0=A0=A0=A0 u8 sense_key;=0A=
-=A0=A0=A0=A0=A0=A0 u8 asc;=A0=A0=A0=A0=A0 /* additional sense code */=0A=
-=A0=A0=A0=A0=A0=A0 u8 ascq;=A0=A0=A0=A0 /* additional sense code qualifier=
 */=0A=
+=A0=A0=A0=A0=A0=A0 u16 sense_code;=0A=
=A0=A0=A0=A0=A0=A0=A0 unsigned long sense_data_size;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 ei =3D cp->err_info;=0A=
@@ -2666,18 +2664,19 @@ static void complete_scsi_command(struct CommandLis=
t *cp)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memcpy(cmd->sense_buffer, ei-=
>SenseInfo, sense_data_size);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ei->ScsiStatus)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 decod=
e_sense_data(ei->SenseInfo, sense_data_size,=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 &sense_key, &asc, &ascq);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 &sense_key, &sense_code);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ei->ScsiStatus =3D=3D SAM=
_STAT_CHECK_CONDITION) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 switc=
h (sense_key) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case =
ABORTED_COMMAND:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 cmd->result |=3D DID_SOFT_ERROR << 16;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 break;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case =
UNIT_ATTENTION:=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 if (asc =3D=3D 0x3F && ascq =3D=3D 0x0E)=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 if (sense_code =3D=3D=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 REPORTED_LUNS_DATA_HAS_CHANGED)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 h->drv_req_rescan =3D 1;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 break;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case =
ILLEGAL_REQUEST:=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 if (asc =3D=3D 0x25 && ascq =3D=3D 0x00) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 if (sense_code =3D=3D LU_NOT_SUPPORTED) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev->removed =3D 1;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd->result =3D DID_NO_CONNECT <=
< 16;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 }=0A=
@@ -2693,7 +2692,9 @@ static void complete_scsi_command(struct CommandList =
*cp)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 "Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 "Returning result: 0x%x\n",=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 cp, ei->ScsiStatus,=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 sense_key, asc, ascq,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 sense_key,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 scsi_sense_code_asc(sense_code),=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 scsi_sense_code_ascq(sense_code),=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 cmd->result);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {=A0 /* scsi status is=
 zero??? How??? */=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_w=
arn(&h->pdev->dev, "cp %p SCSI status was 0. "=0A=
@@ -2919,7 +2920,8 @@ static void hpsa_scsi_interpret_error(struct ctlr_inf=
o *h,=0A=
=A0{=0A=
=A0=A0=A0=A0=A0=A0=A0 const struct ErrorInfo *ei =3D cp->err_info;=0A=
=A0=A0=A0=A0=A0=A0=A0 struct device *d =3D &cp->h->pdev->dev;=0A=
-=A0=A0=A0=A0=A0=A0 u8 sense_key, asc, ascq;=0A=
+=A0=A0=A0=A0=A0=A0 u8 sense_key;=0A=
+=A0=A0=A0=A0=A0=A0 u16 sense_code;=0A=
=A0=A0=A0=A0=A0=A0=A0 int sense_len;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 switch (ei->CommandStatus) {=0A=
@@ -2928,12 +2930,13 @@ static void hpsa_scsi_interpret_error(struct ctlr_i=
nfo *h,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense=
_len =3D sizeof(ei->SenseInfo);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense=
_len =3D ei->SenseLen;=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 decode_sense_data(ei->SenseInfo=
, sense_len,=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &sense_key, &asc, &ascq);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 decode_sense_data(ei->SenseInfo=
, sense_len, &sense_key,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 &sense_code);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hpsa_print_cmd(h, "SCSI statu=
s", cp);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ei->ScsiStatus =3D=3D SAM=
_STAT_CHECK_CONDITION)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_w=
arn(d, "SCSI Status =3D 02, Sense key =3D 0x%02x, ASC =3D 0x%02x, ASCQ =3D =
0x%02x\n",=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 sense_key, asc, ascq);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 sense_key, scsi_sense_code_asc(sense_code),=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 scsi_sense_code_ascq(sense_code));=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_w=
arn(d, "SCSI Status =3D 0x%02x\n", ei->ScsiStatus);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ei->ScsiStatus =3D=3D 0)=
=0A=
@@ -3868,12 +3871,10 @@ static unsigned char hpsa_volume_offline(struct ctl=
r_info *h,=0A=
=A0{=0A=
=A0=A0=A0=A0=A0=A0=A0 struct CommandList *c;=0A=
=A0=A0=A0=A0=A0=A0=A0 unsigned char *sense;=0A=
-=A0=A0=A0=A0=A0=A0 u8 sense_key, asc, ascq;=0A=
+=A0=A0=A0=A0=A0=A0 u8 sense_key;=0A=
+=A0=A0=A0=A0=A0=A0 u16 sense_code;=0A=
=A0=A0=A0=A0=A0=A0=A0 int sense_len;=0A=
=A0=A0=A0=A0=A0=A0=A0 int rc, ldstat =3D 0;=0A=
-#define ASC_LUN_NOT_READY 0x04=0A=
-#define ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS 0x04=0A=
-#define ASCQ_LUN_NOT_READY_INITIALIZING_CMD_REQ 0x02=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 c =3D cmd_alloc(h);=0A=
=0A=
@@ -3889,7 +3890,7 @@ static unsigned char hpsa_volume_offline(struct ctlr_=
info *h,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense_len =3D sizeof(c->err_i=
nfo->SenseInfo);=0A=
=A0=A0=A0=A0=A0=A0=A0 else=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense_len =3D c->err_info->Se=
nseLen;=0A=
-=A0=A0=A0=A0=A0=A0 decode_sense_data(sense, sense_len, &sense_key, &asc, &=
ascq);=0A=
+=A0=A0=A0=A0=A0=A0 decode_sense_data(sense, sense_len, &sense_key, &sense_=
code);=0A=
=A0=A0=A0=A0=A0=A0=A0 cmd_free(h, c);=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 /* Determine the reason for not ready state */=0A=
@@ -3912,8 +3913,8 @@ static unsigned char hpsa_volume_offline(struct ctlr_=
info *h,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* If VPD status page isn't a=
vailable,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * use ASC/ASCQ to determin=
e state=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((ascq =3D=3D ASCQ_LUN_NOT_R=
EADY_FORMAT_IN_PROGRESS) ||=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (ascq =
=3D=3D ASCQ_LUN_NOT_READY_INITIALIZING_CMD_REQ))=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sense_code =3D=3D LU_NOT_RE=
ADY_FORMAT_IN_PROGRESS ||=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sense_code =3D=3D L=
U_NOT_READY_INITIALIZING_COMMAND_REQUIRED)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retur=
n ldstat;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
=A0=A0=A0=A0=A0=A0=A0 default:=0A=
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h=0A=
index ba6a3aa8d954..0dbfbec37ce2 100644=0A=
--- a/drivers/scsi/hpsa_cmd.h=0A=
+++ b/drivers/scsi/hpsa_cmd.h=0A=
@@ -63,29 +63,6 @@=0A=
=A0#define CISS_TMF_WRONG_LUN=A0=A0=A0=A0 0x09=0A=
=A0#define CISS_TMF_OVERLAPPED_TAG 0x0a=0A=
=0A=
-/* Unit Attentions ASC's as defined for the MSA2012sa */=0A=
-#define POWER_OR_RESET=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x2=
9=0A=
-#define STATE_CHANGED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=
x2a=0A=
-#define UNIT_ATTENTION_CLEARED=A0=A0=A0=A0=A0=A0=A0=A0 0x2f=0A=
-#define LUN_FAILED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0x3e=0A=
-#define REPORT_LUNS_CHANGED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x3f=0A=
-=0A=
-/* Unit Attentions ASCQ's as defined for the MSA2012sa */=0A=
-=0A=
-=A0=A0=A0=A0=A0=A0 /* These ASCQ's defined for ASC =3D POWER_OR_RESET */=
=0A=
-#define POWER_ON_RESET=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x0=
0=0A=
-#define POWER_ON_REBOOT=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0x01=0A=
-#define SCSI_BUS_RESET=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x0=
2=0A=
-#define MSA_TARGET_RESET=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x03=0A=
-#define CONTROLLER_FAILOVER=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x04=0A=
-#define TRANSCEIVER_SE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x0=
5=0A=
-#define TRANSCEIVER_LVD=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0x06=0A=
-=0A=
-=A0=A0=A0=A0=A0=A0 /* These ASCQ's defined for ASC =3D STATE_CHANGED */=0A=
-#define RESERVATION_PREEMPTED=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x03=0A=
-#define ASYM_ACCESS_CHANGED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x06=0A=
-#define LUN_CAPACITY_CHANGED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x09=0A=
-=0A=
=A0/* transfer direction */=0A=
=A0#define XFER_NONE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x00=0A=
=A0#define XFER_WRITE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x01=0A=
--=0A=
2.55.0=0A=
=0A=
