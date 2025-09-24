Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B218B0A;
	Wed, 24 Sep 2025 13:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721441; cv=fail; b=G0RPADfrKT8NPSVFAEucddEGGZsguXevNTQmECyOV0dAOldyl5K3bLLeoRIRvgiWzCpkoHvrhRAKTerPZj+Uto13BUJ5/s99WU8raTLdpoPFFD+wE57A0DI5bilcQzqArzOWT03neFqGFiLxXHsmN0PSciJ+8GeEoWBGgClr+i4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721441; c=relaxed/simple;
	bh=Z68AZywqTdGjqtzv1WE5tKYK3bColIyUpRDmk5Bqtrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iv12gTtuOXWw0SwZ3D4kv6t57lblDiLGt09ki3F+QTQDnNkzfnYUbXDdhEUgrUNktwwfNVibLU7wzUQmJ8+9C8c+GUmItc/rmRoMrRwrNfG4qvvuVQwJacLoA/TCcJVk8BBVPLwI+EYB+Tgx2IjwSUswxsp9voyIsiqw31FDQUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=wJJqjoWW; arc=fail smtp.client-ip=40.107.209.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="wJJqjoWW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dKlUnxGCigrP2Z1aSOXKes7qqhC7KnqumbrBF7maxN4OtLyI0bsuW1IIp9fiRqUarMs8lNzUl0PpTzumm9nMDP2wGbG6jsRuumf+/bWQxBFUJSvSVR7Vh8HB0f5HRpVVn74CpvjCoCCHSejQAQgB1E51dJzd+K8KQxUzDyUH47DJwckTmGixnK0cKVeuYfhOF5X9SK0ssGVP+s82yjuz472Ush9IkJNRhdwkBa5Qz7RNTjfRNjHpd5xRkqCMSaodzaoRohLp2dReOmtqTtZT2UnRWgFZJKmqGu5P1IXFndtK39XfU2hvr7JtjLr/rXHhICrrMf6TpDne30FSVTC7Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z68AZywqTdGjqtzv1WE5tKYK3bColIyUpRDmk5Bqtrs=;
 b=S4+mtSsdBB7cqkx4QUzW0P5/D9kU6/7blLfJRJMCH2fc4Eq9MV1rUEl5Xhn6ygM+NptIxv6rHtlCVL8qX+lK65Ag5iGOd7dW4dhA9kk75MfzboBMvXeh48Or1NAzXG+0hOjfOjHpemnOKPNOoY2N7Dh0PFlMCMokeefzDluy1ZkLEwT1LwVQ3q7sxdMcRdxm4NdGIRV8N1Y24Kwi3VU70vKfUVNFvRkzqYXSePdOLYDYsH0wrHKnQh17k0pvonY/gSF2MrdmVL0sXXNm4oRnSMdQ5CqwT9bz4Croh8O/uNvt0H53tyKn6t2oAppoc8KUS8tCJVhqn5TjELk731wH/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z68AZywqTdGjqtzv1WE5tKYK3bColIyUpRDmk5Bqtrs=;
 b=wJJqjoWWpprd0l1XSU85GwKWZcDoRm8ZnNGaAOmvm0sssmbwtngUHcOAnOfNSipVWT5jvSdiHE28PiCxxSqeiQGztQwag5bNG0sx1R4zrTLSFUzSJ0MJE8pIvmtj0Y6LumCIy2FDdr/qhn6pS7H+PZpOIrXMI+rXcNCo8PmBLpZNaUVGTrXWFM+h/YnGutLAN8ZICdEGT1DWeeP1RYJmtaoA0fGhtVNejowZ/WffVIa+L+pNd7y/7I/YlcxgigVVPzmcK9d3Oy9ClovXLsxObftM2Br8mhN6tFH1+EnTHN2n+BWAkzWeYqGWkXDS6Wn0+3HpL9uQkAgVP4Ay1NWtIg==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DM3PPF49E43CAC1.namprd11.prod.outlook.com (2603:10b6:f:fc00::f1c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 24 Sep
 2025 13:43:56 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628%4]) with mapi id 15.20.9137.017; Wed, 24 Sep 2025
 13:43:55 +0000
From: <Don.Brace@microchip.com>
To: <thorsten.blum@linux.dev>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <mikem@beardog.cce.hp.com>,
	<James.Bottomley@suse.de>, <akpm@linux-foundation.org>, <achiang@hp.com>,
	<scameron@beardog.cce.hp.com>
CC: <stable@vger.kernel.org>, <storagedev@microchip.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] scsi: hpsa: Fix potential memory leak in
 hpsa_big_passthru_ioctl()
Thread-Topic: [PATCH RESEND] scsi: hpsa: Fix potential memory leak in
 hpsa_big_passthru_ioctl()
Thread-Index: AQHcKUeIgHd9bYC6Q02W+zTNErhyoLSiX6gg
Date: Wed, 24 Sep 2025 13:43:55 +0000
Message-ID:
 <SJ2PR11MB836938BF289336E5CFC6FFE0E11CA@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20250919092637.721325-1-thorsten.blum@linux.dev>
In-Reply-To: <20250919092637.721325-1-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DM3PPF49E43CAC1:EE_
x-ms-office365-filtering-correlation-id: 41f2e893-8de7-46e3-55e8-08ddfb706819
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?BM5nUYsuK+GuBtocNHiATH34REfDDrJ+n9SzirN3C4pjupdtxZKrzcdudM?=
 =?iso-8859-1?Q?sPWBlFSBvpa4sURmYt9gAg81kCw6D8Hqx8MZ51vhd1GoVqO+FAFdrxsFVB?=
 =?iso-8859-1?Q?NR+KG6OZTqQdGuYJut8SquW9WbA5sjQTNdVCFulKW9TgWR5esXAOn2XYzC?=
 =?iso-8859-1?Q?p8vXfzYZ+JlqvMuBKQQmLqxtz78+uVKMrolpKh9qqlsMU+ByWx2XAJMyQK?=
 =?iso-8859-1?Q?Kh3GtloEFO9AGD609Nvs1NYz0BtAQ8a7KV0dXhbON677H5K4K4qI0mBU72?=
 =?iso-8859-1?Q?TzwWSp8KsiWpqT/p6ksweMMLryjcKrkfGvnpL+cSVrKqTucJ+4x0wzc6XE?=
 =?iso-8859-1?Q?u8SnhMxz4I+hueC8QN/520zu4S6tT6ptrZ/lBSH0QcWslPGdMCE0Em9WDD?=
 =?iso-8859-1?Q?bRofQZj1L8OKMZYXUqANU4t7VkpV9h5JPH68ND9DDNS8VXGJYQMlZpWjwi?=
 =?iso-8859-1?Q?MQYapmBx8yGKRC2dgElm9+0hLwUTLMeaa/1iAgZZNcIDBSh/ptRLgsYK4i?=
 =?iso-8859-1?Q?wYpYLVIi16hZjskTbnfP1ol/MEAW4GSHwpcZWiehq+wTXLIhEj3sFkjWOD?=
 =?iso-8859-1?Q?yt+15QB38prjKfxplpqO9eyPw3UEwhrjKYwSYDt9jDgZEMyXrU7Qjx0lnR?=
 =?iso-8859-1?Q?dRK8LySGqdFTZ16h5qOMdJaXwZtdZmY1EetDeNKwOLpvTIZ02F5uNBxMd4?=
 =?iso-8859-1?Q?egdcdraRXjXbGdewZQHanfW8H+LFwjDsW5bLPGNcAwCBRubegiyuQeWcS7?=
 =?iso-8859-1?Q?bFxOxUYkD7V/MnftqQC6+244FNMwditYE6vcGeW4r0F055QF81ebvpVw2A?=
 =?iso-8859-1?Q?lkmvHvn6Vvgm6bRsvPcdPYA9Yn0AMcgsAZkGo1jB93z9Tt+YXwkGGEVD5n?=
 =?iso-8859-1?Q?4/2FmtCeJkSBg5/ApEaQNzBVMUpSjBkawuS8L/cJgj6ggliGjFN7hePp+I?=
 =?iso-8859-1?Q?AmqYZFlj2j1/V5ghiCcehv2hSSdBZCQ5kCJyFgS5lc9mOu+s5Ac3Cr7z3T?=
 =?iso-8859-1?Q?c6BE1DTrT9wM609IvZhNohSN3fV43COeizEhP8f9ERJYV188eDphVifUJV?=
 =?iso-8859-1?Q?L+FDv5rBZkWFDzwfUr5y7qsSgub7vvA02lDMe/Czz8F94Rth7Sct9YAva7?=
 =?iso-8859-1?Q?N1t5o80BuJInlwRVvUR6qPGu0eORzvU+wSQRoO4mSC1ZS/aknHFzhbAz5U?=
 =?iso-8859-1?Q?OctW/5ChFsUqePuFDNVbBe+Lqel1UX/p2NObcmo6hLMW3edBKLQmcQgWcJ?=
 =?iso-8859-1?Q?uj3Y/PZWOZD6AJVm0U0Xu0//3IKukMpdaJpxWMRjTrahbGOwneCyPSXWwT?=
 =?iso-8859-1?Q?EXowcB2LSA4J7udmOftCnHRQsJFqr+HRosA4l+eHqccEf5TZ11xWL4qWXL?=
 =?iso-8859-1?Q?+xpg9MR2QvZ3IXKiHOyJyBQbbT65rN1PMnXE590fvODgHZb1hXEYtgJ27H?=
 =?iso-8859-1?Q?Y2AfWrsbhwqpf9Lg6R3xBcYhb7MYoPJlZ7t/s4XhAV/laGmIWCokgb+kB5?=
 =?iso-8859-1?Q?KeiHAYK20Fp+qDryP2pQqiRPWOijh5dxuQ3oKhFI8LsX/Jk6hGXqJHpB5W?=
 =?iso-8859-1?Q?6qFmHYY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?clZoa9a7Udnzb3LvGvhNd/8VvqvuJMP9VKLzsERlyoDXwXqqsNY16wNbKC?=
 =?iso-8859-1?Q?jrmm4Pkj0W1LLY4hrThNGUTHd4OZ5COU0AV+KcaC4oiEwDx8Guo30+RI1i?=
 =?iso-8859-1?Q?Jr+WzjM2bJOMSbhUUbIbW0caeIhqvFdbyfnF9yqUhhafNInC58uh/BtP1l?=
 =?iso-8859-1?Q?ufIZ12aTXihtrbqy+L3YfhrdetyTVYDM90N7EY4pzUOrwROPeoVzDvC1MR?=
 =?iso-8859-1?Q?3kzJIdgKAwfUGxKRoB947sgNMJKgbGsFIllsV9J1hEXFnfxHx1kfYa1c2J?=
 =?iso-8859-1?Q?XXLUJKOeDzGm177eYmmjPIPHkizDCevJdKEbNKnWi20cKmtxBcED/nniiz?=
 =?iso-8859-1?Q?PxTPPpvuA9aOgDng2y2Lxj8BZ33y75tWAwW7mFwdzDo/nmrCcFIhZ1TmRL?=
 =?iso-8859-1?Q?Pp4JYy8RMzhYkyTBGPQLk9XLk5Y8W8To5pXUX7hM7YKXY2r874He2ym7Fo?=
 =?iso-8859-1?Q?g5A4cjJ7bCZ34YV/uhSEEcL2S8scbwkX0U/tb05759WfXhkM7/CuiAqx46?=
 =?iso-8859-1?Q?VL9NB48XznzvOpnTkqar4QAtJAdVqOlg3axlw/YYJ5dOWBLjPbnfII6Y6j?=
 =?iso-8859-1?Q?u3pAnjzfJBijEiB1te0hwXLapan/ntKDpZW0Xj9RW+TrO4+wcuE+xUxKkv?=
 =?iso-8859-1?Q?A92DPr9ogjoBngfw6vyLrsnjUyPbSKguqY2DABpA2Knm6ED0rS+h7VSqRZ?=
 =?iso-8859-1?Q?S2Vz07cvX8nHzLwQAiSJMJl1kvRbrQaOA56A4uGgrb1/1koA9CoQ4bu3yA?=
 =?iso-8859-1?Q?ZHRGpOKNHC3kI/c1I+4Xok4mS2tQBxfHCgoPyI9YCuCHVr8jXIZs74qmFZ?=
 =?iso-8859-1?Q?eLmDU0pCUVaZvM+vSfOizlFRnxUCrmz4WGnFWst2SjNzYIvAFwqcJ5vO3A?=
 =?iso-8859-1?Q?KXUZza84z5jPD6wLa+DwLAqvKlHwqES+NW06tDS31HsBAyzSLCz484Vmd7?=
 =?iso-8859-1?Q?weeuzGpugeOI3Ysaih58b25SSfyZSH8VS+PQ79m004XgKFiWrtd/IR64Hl?=
 =?iso-8859-1?Q?8LJq5LbcD6ptyOB9vi+P2g6dwDVq2Es5wUqbLyzk8ET0sS5LMrfzslNh3f?=
 =?iso-8859-1?Q?ATPTizaCph6fu+d3mM0OUT5nREqbkIjRLEFbEpLqQHt9cR0Zln3nW5Fiby?=
 =?iso-8859-1?Q?n49t/WvwmUdC/PcrNvf17NtOSeEwjc06ro2S+fVwqMUr4hbXXCes01h/+2?=
 =?iso-8859-1?Q?dfjRecSRCXAXak8P9OUq1L6888AKdf3QOCUreX2WK7uaXxwQcDN1XVSFcF?=
 =?iso-8859-1?Q?HGWdyuvv3FBwdI3PEpV6VNlH0oh+PkclWS5KtosQoQQjenlgmnoHqcJdC0?=
 =?iso-8859-1?Q?csbplG2GjFLrLkYo+Zi71cLDB6BZvSPKbwiQsq8VBojDk1jgRc5J4pC9Lr?=
 =?iso-8859-1?Q?zX2riqvHckIAjkMiFUVCfa/4VDNU6SGf+oTJPIhCoeZkrvIKQdkYbWI6HC?=
 =?iso-8859-1?Q?CZkipxRew2DVGkjEL4tXjul6FuQFirZltsK7w8If1wg8o1/Kk9+36xNQRm?=
 =?iso-8859-1?Q?cfDVeGr438lmGJdt3HJzTA923b7mAlEysYrjws+MFsBu6cdGfZciOFQDaB?=
 =?iso-8859-1?Q?gTa6+rRONlXhtSfZMxHo14ctplwZ8K+Pr/MeHQI6f+SvT8+EOALE6NrgLI?=
 =?iso-8859-1?Q?C5vOgsKtK8XYxt45S8Cf45zzooqpy4cx5W?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f2e893-8de7-46e3-55e8-08ddfb706819
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 13:43:55.7637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HglfQXNoo1lT2cXkBEmUhXP5VR+4Eplx6kx85L6l2Jmw6OYS/u+KVmeXi+bJzJPgzgVaveHM3qC/OKvsatKrrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF49E43CAC1

=0A=
________________________________________=0A=
From:=A0Thorsten Blum <thorsten.blum@linux.dev>=0A=
Sent:=A0Friday, September 19, 2025 4:26 AM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>; James E.J. Bottomley <J=
ames.Bottomley@HansenPartnership.com>; Martin K. Petersen <martin.petersen@=
oracle.com>; Mike Miller <mikem@beardog.cce.hp.com>; James Bottomley <James=
.Bottomley@suse.de>; Andrew Morton <akpm@linux-foundation.org>; Alex Chiang=
 <achiang@hp.com>; Stephen M. Cameron <scameron@beardog.cce.hp.com>=0A=
Cc:=A0Thorsten Blum <thorsten.blum@linux.dev>; stable@vger.kernel.org <stab=
le@vger.kernel.org>; storagedev <storagedev@microchip.com>; linux-scsi@vger=
.kernel.org <linux-scsi@vger.kernel.org>; linux-kernel@vger.kernel.org <lin=
ux-kernel@vger.kernel.org>=0A=
Subject:=A0[PATCH RESEND] scsi: hpsa: Fix potential memory leak in hpsa_big=
_passthru_ioctl()=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
Replace kmalloc() followed by copy_from_user() with memdup_user() to fix=0A=
a memory leak that occurs when copy_from_user(buff[sg_used],,) fails and=0A=
the 'cleanup1:' path does not free the memory for 'buff[sg_used]'. Using=0A=
memdup_user() avoids this by freeing the memory internally.=0A=
=0A=
Since memdup_user() already allocates memory, use kzalloc() in the else=0A=
branch instead of manually zeroing 'buff[sg_used]' using memset(0).=0A=
=0A=
Cc: stable@vger.kernel.org=0A=
Fixes: edd163687ea5 ("[SCSI] hpsa: add driver for HP Smart Array controller=
s.")=0A=
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>=0A=
=0A=
Acked-By: Don Brace <don.brace@microchip.com>=0A=
=0A=
Thanks for your patch.=0A=
