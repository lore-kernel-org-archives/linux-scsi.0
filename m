Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5030F2E4241;
	Tue, 23 Sep 2025 16:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644241; cv=fail; b=KWujTufpUxS2TOe8oUP9vucOOM2rp44vnT7bi5jqBkUNU9t5OWUp/n7q+flhJIxEwet1ut2UeVk9CrsMaFGLkXq87p84c7HzPFhCzkAzddMpA0V06muhANJfWX9dn4AIaqV2FEJaW7xJXes83Xznxv1pCkarJn/plmBxmeQrZ4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644241; c=relaxed/simple;
	bh=QDtwXJrjp0Vj76lB8FNUVJrahMMHO3H9hDBBVzafn9o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XLXk9jg9uBASNcN1tdngloIQyR9N2Og2bm157c5yzbkx836Ll+MerBumGmrgYW4dcD5LdU2XxiysnxwW7CR9mCzyvHgAvJ5nr9sr/PiSm97aa1HCobxa/VZa/qFREEaA7+G1Aq1CYNhu1P3SJQLNWZvberqcld79KvYZxLG5vZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=Q591q43v; arc=fail smtp.client-ip=52.101.43.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Q591q43v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4ryPLxJVftYVKbt42aM2Lsiavf5kwVS6L8wXg8R2xSrc6xewTiViCypn8PE1G3lUVvKhRx/ASwW9p4BW0cS6jSgbIzhrscS/5aaD0MYOriwFoN/k6yaUBPJdOH3btj6BIo5JGgJZpU9LJdTGxMEb4w+SbEsDxQUVU77cKVGdFr70c88afRzxJY06rbeZaT8wGMuOKxltvvn4/RlKnHnEOaRGMWz/9YsWyukBzSlKTsolnwthtcS2qCIGOUIsH59jaKAEsS6PI1Jtzv1bjqTvL9G9USKTci3cvV3ggqJJymcdkYUYD/DSqSi+lnkBeOwvlpLZYXu00lBqbuJDlTWKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDtwXJrjp0Vj76lB8FNUVJrahMMHO3H9hDBBVzafn9o=;
 b=YwcAccHWID97Ufa7VFXUBsrforFHAtipmsTrL3MgyVJ9HTNpu5etLhwfAEzDVd+DlIlxOm8dr8Wi1DYIW5kuNgD5mX2zQnjBtDAVdyzzglkI0c/hAN4/riwMms5sM1rh4RAHL6sZPEOYmuJVEbJNMKbvI8Zn9jwh1vXVP2P7ZNR8WbgH0cKcP61E9TZeI2c/JT2HDm8TYHrLXkikk/4vH4POMAFX97FE8NBQxB6gF1I44T2KI5dm1/i6xdkwwfU+NAup9LDqc0XvKORgMDASa+amjMCnHQhgKUm4Jl8g0P+jeyldhyBMuYUjV+P60kJkkWeMsE3k3473EZqNuNQ8/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDtwXJrjp0Vj76lB8FNUVJrahMMHO3H9hDBBVzafn9o=;
 b=Q591q43v0vmvKqhI1aBWMCDvxDnuRLraNfYXlZsFnqcV2/LVaYgiBG3AKHfr3c3hZFsPOy98XPe4jaHMkg07YMHZk3gj18Agg7V7vh3gTU0ZhGNMbm8aAxvonNfYi2AOspzc3DfM1D1kFP1UnX3F7bFrtrwKk9u+UnduU0yddMEK7w9073QViiXuJObGrDXlfG+95nEiFtl+2NIe32Q7Q24T+EBTzm2C5sN0Yc80TRdJ9hYg53at5gctvz5QZjM6UxUdaDWQI3HiDU4m3lkynAhz3o686yc72qxmk2N233i7ZgTVmkqLE19xqPOmdcFrOH4Qg9cy2Fw/40w1iVD0+g==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by CY5PR11MB6212.namprd11.prod.outlook.com (2603:10b6:930:24::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 16:17:07 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628%4]) with mapi id 15.20.9137.017; Tue, 23 Sep 2025
 16:17:07 +0000
From: <Don.Brace@microchip.com>
To: <thorsten.blum@linux.dev>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>
CC: <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: smartpqi: Replace kmalloc + copy_from_user with
 memdup_user
Thread-Topic: [PATCH] scsi: smartpqi: Replace kmalloc + copy_from_user with
 memdup_user
Thread-Index: AQHcK/4yAcAjUz3KOUqSl5Z6khDgGrSg8kDi
Date: Tue, 23 Sep 2025 16:17:07 +0000
Message-ID:
 <SJ2PR11MB83697AF910EED3F2C5D3C082E11DA@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20250922201832.1697874-2-thorsten.blum@linux.dev>
In-Reply-To: <20250922201832.1697874-2-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|CY5PR11MB6212:EE_
x-ms-office365-filtering-correlation-id: c997e6e5-b619-4603-d193-08ddfabca466
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ypKnTmFYbQmbFRPBs9irrF3y/X4mPZAcZKGSFHrXqvnVz86A7Llpx1Q5fI?=
 =?iso-8859-1?Q?XpJt76txFOF6nqOleSTbfdmWxgRi7SqHamSbFglW14rwUxc66n4Qgp0V7W?=
 =?iso-8859-1?Q?U0WuZiCYaj83gDu3FV7h+z5pxMGIVaKIgrlWUQvtcyl342sYyuSgKTttzB?=
 =?iso-8859-1?Q?k4pqf5UTQWdfkFLFvNHxTDUr9g0iGWLIm/+Tfdlu/5sFoh9GgLAEsWnjyc?=
 =?iso-8859-1?Q?PJxfWJW4bluee+ScisJB2+wOSbao/Er2WFRMy1jDP7oQCuI9odptDZ2qBs?=
 =?iso-8859-1?Q?dsY1HoRtVsAMgRrDyqzk1+L5apqQdATxAcwchsO6pXBeMDyunrg59Rqk8Z?=
 =?iso-8859-1?Q?MtUt4vSNooDyf7pQaGV281WxvJgoYhMi2H3k5sSCRW5PJUf5rxPUKG3vuq?=
 =?iso-8859-1?Q?V9vgZpGQ+VAgb0HPZrmjW+Yb/hGJ6u+zXF4PEuV/a5GfWtkdipy7mbXxU7?=
 =?iso-8859-1?Q?93YQynxLVVcDBIm7XnTPvpiun18Ut+HYnsKVlmzsaumoFf5nlPGjV1Z6XM?=
 =?iso-8859-1?Q?PWhsfvZ1w6HxP1bHM+FqVqo3gMXOEFH0+VPB34R31tVYmzQmBJCwp00WzV?=
 =?iso-8859-1?Q?xyzubJfGJTFX8eepaQcP0aP1AcgGzPmvvLEbXN8h53vufwLk0ZSlphxZnM?=
 =?iso-8859-1?Q?7plMhxBrMBlSjdfHWD0+to7NjN46fSkxjGzDaKHWXcAjoJZ1qPexjqDYzU?=
 =?iso-8859-1?Q?QBHCvPrv/o3PYKcApmhapz8c06NRDdcavof/pbL0HnUknek0jIGQdsxlYX?=
 =?iso-8859-1?Q?tLK0ZwZSziHz4jbWvp+Z3KdQSYUGiryGORiFp3lIsFz2b0PtB+O7lXLxru?=
 =?iso-8859-1?Q?ZNnvRgVT/j9sOmCC9Y4slDR5ANrLgv/cB8ea/z+ajv817irytuZoVewL23?=
 =?iso-8859-1?Q?wKR+9XoSXQRoecsCAw8KqlASGP631ux0i7JH64CRggZV+Vww0nQTuIR4KN?=
 =?iso-8859-1?Q?R7pExVAnP3zjZDPE56h/AyjxsEcBsGeBq6kByfVpc1ZKMLkgTywb33QZS6?=
 =?iso-8859-1?Q?p6DeAeAR/6vSECiMOimqCq2bHWu1FUy7m/Jbxow25GVVwqKs88ztFHAPbB?=
 =?iso-8859-1?Q?wc6CLtUTKknSMK5BZ8CMwff/8Ok7AKcNTuPqHAnZ3u5zunqoFW4u1xNn55?=
 =?iso-8859-1?Q?sxetaRWRIbVwJTa1lmWsxJgh6UH7yrR/ReUFAcFAdGwL2lFu2uIFwy/V/M?=
 =?iso-8859-1?Q?dL5O+tJXqCDx6MR84UENIhBTq1pZp7qc5PYPU2P+UwyykUlgr+kDqhzjJ0?=
 =?iso-8859-1?Q?spRWLdTbY9Rplhqc5Ox7lpuiITlvj1rAzLb6v5nPiZqGSW5n8R+VYx1MjH?=
 =?iso-8859-1?Q?KA+0mZIjq4/tb3NB/JyQ9ovMlcXGYvFB+Xf+RtJuPSuzvYPaNwHJfSRfYc?=
 =?iso-8859-1?Q?fiOJr/gy/7OQK1Gs6Wewc4Gl2lJVhWDcHpXRzNXNPvxjzHgCbn7+W9tUgW?=
 =?iso-8859-1?Q?/uxtgPjdsdlE1aI0hEJtvXc/Pm6BPOrP+7TBLu/kpX1H7tRiXHHR7iZVbV?=
 =?iso-8859-1?Q?dqvf/CWn/qZFoAVqRobWRE5cNtwWC1NSl4LKAnRvYsQw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+igJYquJI3nDTo+YTTjnl2Wb2q0R1+pECplKfbgfzR6sGU7F+dJCD8vXOq?=
 =?iso-8859-1?Q?DZDQxZGHPA+4JpyOdb22Fkc5mOM3J/T7uBdOin9T6oGEPkHcg1IGLo5LOA?=
 =?iso-8859-1?Q?ZJAy5/rezNnoF4Ahgtzb2m0mMkTXI4yIolc5Y027QkZANzFOXluVo1zCaA?=
 =?iso-8859-1?Q?N1qHyuMMXvOko6xwPEwlAeEFytBxMv7efm7lBxRIqGm4IkLUSoNoYJv9YQ?=
 =?iso-8859-1?Q?mFgGPGfkLGW0jjTmAkCgo3W6cQjmVVyjvWtuhWw3Tcwoz/hZ2QOAxWGX5c?=
 =?iso-8859-1?Q?1gV/kTrr9GcIas1T70/aZHWhRDZdJJHbTUUk+/o+UIQyHWD5r+W4uIhdHY?=
 =?iso-8859-1?Q?wS4CnthZwRFYp+tg/U8Z0qLyBvxpY62ybKgC4yYR3aQDuG00cRkp8qUtLq?=
 =?iso-8859-1?Q?3iUr0MY1Jmley4MD1hIMrPm1Doa2D5naWegjK/AzR3Xtw2cDImDKnSABpj?=
 =?iso-8859-1?Q?IQKFE631rWe7oPhiYMb7WzBKJopGz4CzL7U964Z7jGqPNUgXDq7K1hmiPG?=
 =?iso-8859-1?Q?Whe8nHoXFFFsRRJZUm2q5xhfAzemB8ywWA4kSNu5y5e437/T3qHyb+qqdy?=
 =?iso-8859-1?Q?z/WAZd8jYS89f5w4ByzN0wd/O2+NhNTp31scyhL3VqZRZG3KKqLCdzCKTa?=
 =?iso-8859-1?Q?ujdnBgDqEW5HVteTzxg8ZydJ1V8ksSNFKrLbvkHlR63hh6Iis7TITZYnkE?=
 =?iso-8859-1?Q?elknyLyZyPWOdU5bVTTKvDFYnaNd4bzShBSOWNWRZ4QveZqXNEY/FkiCIj?=
 =?iso-8859-1?Q?pl3QBQC6CDH+wwP4R48UgjgPUB63ozGpOMGlIZZY40SDYo4aW35R+ga/YV?=
 =?iso-8859-1?Q?pCovgKzjBdg3suy//Ug5zf9MruNyLHWmiwCdDlBAULVLtqSgtX+i1SZ+eK?=
 =?iso-8859-1?Q?iA8ZNlTcLPojLY/1xKu3TyZ5o7pQ2vmoHdCIUTTJUBF5HNGJmSpGuBsNwq?=
 =?iso-8859-1?Q?U8vgf06mvhHv+PGoyOZBcXHOGAF6LiHOp6cM/+v/vh1W+l/VMfwWRgBexY?=
 =?iso-8859-1?Q?iNwyu+CWnf4ierEyCacqyq3JerWPwZb7pXnGUGvg99ufSgvpkkiO49/3k1?=
 =?iso-8859-1?Q?lGRdxcWNrU4UBOgXSebA+s3FNbfqzPAwqxwloY1idoHjAwxziDRYxaoLOj?=
 =?iso-8859-1?Q?Uk3vwKMXJlGie43YU3+DEDISwxOAGJRkPRcteLOMLTtPUMA9aeoTfoe7Rh?=
 =?iso-8859-1?Q?WS6JJWwpjUZRB1RWB8PPLsFDUFNHDbyqJlOcaCdN738jAzH4lSkfsRE0FB?=
 =?iso-8859-1?Q?2Fy5EdojIMWleAT8fgX4thbSEnwEhIY1kk+ARUj6CfupGdwYUCpy89Rzm3?=
 =?iso-8859-1?Q?fFl7SFHbBmjKbuLcDw1F/ohGo4bIIXDY1ZT91+I/HkRlxA7ECaKy9fEKF3?=
 =?iso-8859-1?Q?hCcvriUZqnHMIiTG/vT5XelRfCPovUsRn1ZZFyFjxqVLRKwR+N7mVpwMrR?=
 =?iso-8859-1?Q?fAFsIZ0Ye7vOb5542WlQUWSEbarlH8JZNoFDavwUIzvswpK7S/LwpqIQjX?=
 =?iso-8859-1?Q?BPkf/hQolqe6wFeLPjMlqaCiGzKlwNI8zKcnrAfGWSDwrJFCelyVHz29n0?=
 =?iso-8859-1?Q?E7pt91c0Sdg6dWimg/I5xcuvpnWZdRBlNghErTRbl62WXm2lxFpbKTJGLH?=
 =?iso-8859-1?Q?uCzBwiLlinPf2kewuHKe7uL5REfXpDoFtP?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c997e6e5-b619-4603-d193-08ddfabca466
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 16:17:07.5441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VA/1WW2gW/7PV4xJVRhYdQ/vt7gMSWeUGLQ5dzgTskbgazNK9dnIAh7oTZVSaVQUpyJUeQp0RxyO8ytd7BDAdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6212

=0A=
________________________________________=0A=
From:=A0Thorsten Blum <thorsten.blum@linux.dev>=0A=
Sent:=A0Monday, September 22, 2025 3:18 PM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>; James E.J. Bottomley <J=
ames.Bottomley@HansenPartnership.com>; Martin K. Petersen <martin.petersen@=
oracle.com>=0A=
Cc:=A0Thorsten Blum <thorsten.blum@linux.dev>; storagedev <storagedev@micro=
chip.com>; linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; linux-k=
ernel@vger.kernel.org <linux-kernel@vger.kernel.org>=0A=
Subject:=A0[PATCH] scsi: smartpqi: Replace kmalloc + copy_from_user with me=
mdup_user=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
Replace kmalloc() followed by copy_from_user() with memdup_user() to=0A=
simplify and improve pqi_passthru_ioctl().=0A=
=0A=
Since memdup_user() already allocates memory, use kzalloc() in the else=0A=
branch instead of manually zeroing 'kernel_buffer' using memset(0).=0A=
=0A=
Return early if an error occurs.=A0 No functional changes intended.=0A=
=0A=
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>=0A=
---=0A=
=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
Sorry about duplicate e-mail, forgot to switch to text-only.=0A=
