Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010051.outbound.protection.outlook.com [52.101.193.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EFA25B091;
	Fri, 14 Aug 2026 21:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786741380; cv=fail; b=TL0zmxq0rSYYCKtFNqtvp7LBEHSIEPE872sNGKoFQ5+CymbMzg4ajPXhU38X5gSI5grlqJUi5ezY3bVI4QyJSHHyETJeKnXGy3m4HbDRw5FxAj4Yz4Xa+hZ2HEQZQPE06Z2a3uV9vv5uRpyXLu+wMH675d2H5CJ3Xd1/RpQDDS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786741380; c=relaxed/simple;
	bh=PBpw9d7MskhXMYgYA7OM0RjdvmSN+y33NXzt1D5K+l0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O7Os9n2HIqGx9V3AnIZVPLHhSBY3Lc3gnZAYkps0FMulZzOwsfs2ouBbNnXLI4Qinkf+ph9z/24oWNMyZ3Q62BkQrGIOM233eo9Qyupwdy/j09ifeThDVohay6U1o2PMCgmvWCd6v6sOVaXh6mFtKfeHfhuESEZF+myhQFZR7eY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=Li0+0kuC; arc=fail smtp.client-ip=52.101.193.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Li0+0kuC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpdmvgcJCTE/eRzaWQ5QyTW5t/sLafKE97u7bk7vkvz6iTEFl2zsI5zEx/42fQkEhEJenBSiVO0qjK7qumKTUIrBue7Yjt8o+dpYyhPi8/CeodOdEhDn007YIY6R5wLyTkjzC/zuQlZsmGiIxpD8ngF9hiZA+wq5wLtEcvYqcPkUqEtBQRtoAdQ1YZQ/5kDjGn2jRNU0em3ndUyxiDBTdyC3knvX1I9TYVOcxjVZ1Al/ddhhIb5js0DxNUX0Psl2pzzepMMIeJXXBSC4gEea9ORXAo2q4R1dAIwY0PCqaiGVdxL0ln7X0bg7UjdZ8bk+dErS4s7bbNBnNeytVrEV9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d34o8m7KAKYamTniwFXoops6iFDpLzsBBu8q4Zk47jo=;
 b=Is6zh7nrNKW6tJeiIEtdXIRblcxUdl/YVZNW6mwas0HFmocDiXCgFL4nJ0u8sr3TH9cN49xnuCxbrhRQc9i968UBZjUQ1M5G/294AiorumfiEBUCtl9Gf3ogGNwGsdyTQrSaqQLmjYYFlybRfvk3lccaddeMvPEqqNP8GHBc0XQ73hx2FKBZsB+IGEU0aZyTW6jYgUiAfU75EwiiOWO17gH9XMbhVX9DsrumqciBYjHrLfZsaIYEhbfjrVp3SrsoP13CBR0YQI8jo8vEHTXUwtFltPXVsNZurW1CMKu26nY+PXE/vtF+XE0kB+9E/PrvNmjlkw2JIs1xmaCmp2zVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d34o8m7KAKYamTniwFXoops6iFDpLzsBBu8q4Zk47jo=;
 b=Li0+0kuCxbg9y2fMmOjfew2eNBw2Zuv2kdgyABeomV90jGCR6Ciq/gy3oHVj27BeHhpfEsyXA/86Iw6j4Xay59XST3EMPbQKOUCgr6XbfzijVsKBPA7KsRm3ghS+RBRNXi9KXcuY1+Di+PoFx/EdXRKLbR39xmnjuzLPPxb+8wJYZmmnFoHC+ZoG53Uin7rZrzZMasVP/Zgf4JClkjBK4R0LmjpWn+RU/eEDOBDF2/G5Dmb5Ggn9c8E76z5JDwMx1KXSHxQ8z6IoRvsEMs7uDCUBUybht+7XHwTItaLR1uUsPH7neU6bPHysTn0Uh0/11O1RERXP1HwsueIsq9ugmA==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by PH0PR11MB5904.namprd11.prod.outlook.com (2603:10b6:510:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 21:02:54 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%4]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 21:02:54 +0000
From: <Don.Brace@microchip.com>
To: <vulab@iscas.ac.cn>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>
CC: <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: hpsa: fix divide-by-zero in
 hpsa_scsi_ioaccel_raid_map
Thread-Topic: [PATCH] scsi: hpsa: fix divide-by-zero in
 hpsa_scsi_ioaccel_raid_map
Thread-Index: AQHdK8910m6L64ofS0e/D11qoWUanraeBrGK
Date: Fri, 14 Aug 2026 21:02:54 +0000
Message-ID:
 <SJ2PR11MB836968B883E0A657E695FB7CE1DA2@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260814090015.10207-1-vulab@iscas.ac.cn>
In-Reply-To: <20260814090015.10207-1-vulab@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|PH0PR11MB5904:EE_
x-ms-office365-filtering-correlation-id: c79519a0-26f1-448c-a565-08defa4768cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|56012099006|10067099003|18002099003|22082099003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 qZ6QIAzy++AoBmfna1irYXotivqJ+eXP02ayl6vVQaaGn6zP/+/ZwvUuCZ1PBkSm4gTbNP6Vf7gsktySOwXuAE4nav5aULKnp49TPHm8B93osSacvNxMiaQuVcPJRTnf6I92ygq9lD8qCXknFygWm7sc5xD5xmXjZOm8DFpuRl5Ahx6bJtnTy1AzrterbSpDxCYZ45YczIvLoFUdIH2KtjS/at23tYZKH/kXtwrOQoz+/W0IMZgATLdh9M3luWffS2o8Kl8rcF3BBRRWxt92ns0EZ/ZJLLraVb4youuZ5WVFiG4qPh8ZBOv5bsMFKHk6MtZf+3YmQBGCVyQMdClJhOt0af8QN78im7cm9nZXQkUb7PKShNNyaC+f0/NBFWPwni/Sy0O98ILgI+GbzDWalq9RNvH9xWkM4vB5luPvEKYSCn9SbGPkjVObBnH+REG1V9v5LFpTu4rhLuhQGviLxtUbZGy5hrNG41K2kb0bon1O3nQnnCAo5lwrR7tXGMGZwylFGAvANIkT7hWyKsVkDCYcQZ2xTFidq0dFUelAwxX6i0WPyBREhvJSBKPTcTE85jfs/gTJ8dFvttbd4BPZ3dgU/xbnsgSTpFsHhklJ8M/9h5cx3u4JN/cZgtBnLwQ8ENb5Ay0ZDBZ1FEhS7PjnsJO0ZzcAUBvk6hRpizV5viGTSTEyxAjwnFDz4JbjZ9bpAE0sJzKvtGMB8GSxDNaKsw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(56012099006)(10067099003)(18002099003)(22082099003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Yugrg8YvH3aqmT71X2gF49UL5K0vp/gGEQ+5NYXJgbkdURq8WjQYFaE0Zh?=
 =?iso-8859-1?Q?lVUtRl35vbG41PkRTax/imIPlOIv38UONizNC0FV/JhyRPAKP63AAYlpJC?=
 =?iso-8859-1?Q?M0WqDl/W/rSxRG6uAV30aIoFgW/0vbADfakyueAdztciSvrB+2405YoWGA?=
 =?iso-8859-1?Q?Z3u4RSBnY43UWYIsjnglArltWM6SkQTiOziCpUl3ZHoNKpWqXe7NmwIpmB?=
 =?iso-8859-1?Q?F6qKz0qzvEFoZQl5XmYSU1heP12mK0Q6S29czpgWVl0P2JgBpoelwGOqEn?=
 =?iso-8859-1?Q?pksnmhK6sxz4PDOW6dvY4yAqZpwTDH6TvwD0O827WfNYgFfi6NUBg+NAMq?=
 =?iso-8859-1?Q?kUUkj1V2ZZ+QAECtd464fPNk4kBiC78fr6HbKFHIJc6Ndni8M19mSnHTUP?=
 =?iso-8859-1?Q?gTe1aHIHiG1HdhFaO3Bf1osA79IKR/4wlaStHwTZQANPPg4z94EecHrVYs?=
 =?iso-8859-1?Q?HpFuoE6mLMkuKtNF/8pJpxpgtvonCbT+Q6/1yR38bfpyVLtEdr0vHxI5l2?=
 =?iso-8859-1?Q?ijST0dKpl4AAuA1FTXV685G064runr36AJ0gm0w9X0hZKuNRm1izPwHc6h?=
 =?iso-8859-1?Q?YOThO5IpWRj/TJ4X8WdFXFfRgUTDbeWmW/A5gePeEra49V/7WVMnZeMifz?=
 =?iso-8859-1?Q?ZuHX7mAXXIYgIacyrL5Ba3Tpo3cQa2YOL9I0g9EgPoKHqOssPtFRhAYQX9?=
 =?iso-8859-1?Q?f3DtEDFh/SixY/nO880TJpwiSAAg9GyQroRNM1aOF/6t8kg3KBXn39440E?=
 =?iso-8859-1?Q?MexTlYoWakvkSnsa/VY+2YIfDZVu2A0VTyBY4oYn3ktXuVEld5s68vWGp1?=
 =?iso-8859-1?Q?cDD+P87t925+rkk0KDjtkWVgP6HLXvCebVbVEKwO8B3QZIDOincYLQ2vGU?=
 =?iso-8859-1?Q?0goGEdNAL2i/vv/sEwY5r8qQHHbPxXz2eFoyUy7dQlrcvOTEn/9roYNg9L?=
 =?iso-8859-1?Q?gjo5MiA6JiEmZv6CrG5ZEqYPi5tcIiKpARFnV5VTE76NUBdrmEafcBYvCE?=
 =?iso-8859-1?Q?bPUWTSqqTKyhCCH2a06w+fsSmX1XiYg69O1IyqyrcpKbnsLdMWnG718p6D?=
 =?iso-8859-1?Q?E5XwjI4rifY0HLsnC2sCQIGNWfAkI6VPEVw2OEzoIJqaRi3Pu9WQTgvu0U?=
 =?iso-8859-1?Q?IGUWhWdxhUgcbrY7kV/phInXlq6OdBj6HhgTHcaaphaXYtrNMsbh/vJygU?=
 =?iso-8859-1?Q?XBxQwLOzcIq4WrC8IwCORi8+z4a9otyF29UiCtRXEkAurw8iQXKbsFTgzh?=
 =?iso-8859-1?Q?zAzzhf1HyjiKi5cpYDdcJbwHAveOdISbzc26MaIxqNeHwleF7Miho8OB44?=
 =?iso-8859-1?Q?YNEL4AeRiyoTwFfASTPRkoEhuYo7r1J49EMXE2O2pcjh8n3klhtTXTvUxY?=
 =?iso-8859-1?Q?gyBRFn+xQqpHXW8rw9K2miH7pQHv5E6Jgt4eDxcAfXPeaQ2+4uylaop/mI?=
 =?iso-8859-1?Q?MfIVIo97yDN1Krp4ViWcKwtF3GJdy75uWTxvHbG2g/O4fgYOummzWX9ZyG?=
 =?iso-8859-1?Q?Ig2KggbmNP9B9Osn00KBYr1kmTR3MfdCzBwmrQ0chjsZ3efFH25LiV/C7L?=
 =?iso-8859-1?Q?ZKU2vE5U4/vczUuMnvxZc6+RjkiFowtEdAjQ6OOatTEnSBpA9ihT4Vor12?=
 =?iso-8859-1?Q?HYDNWWScFumO4R3N+6fXMgeoAzm6fbgqaZi1oC1x3qdl8Hav5aClhHXn+w?=
 =?iso-8859-1?Q?wrJ1fwTgnKW4AuwwITVLKCkn93m3XB4QgjXKOj9qNOrCoBY0dgRLCdTbc4?=
 =?iso-8859-1?Q?lFXDyN3BrKoro03DA4wS0oFwXfeFREiQ3aQJSUDmK1rZ35CY35Cverh/TE?=
 =?iso-8859-1?Q?Toqk5P2rjA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c79519a0-26f1-448c-a565-08defa4768cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2026 21:02:54.0885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yFVCPbNqhVY1xFZoeyXa//51StCzyDxeMXUX+0qLWKqqyxb/XzSPa/MFrKSu39wku/Isdi3CycesWGE/dE6bBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5904

=0A=
________________________________________=0A=
From: Haotian Zhang <vulab@iscas.ac.cn>=0A=
Sent: Friday, August 14, 2026 4:00 AM=0A=
To: Don Brace - C33706 <Don.Brace@microchip.com>; James.Bottomley@HansenPar=
tnership.com <James.Bottomley@HansenPartnership.com>; martin.petersen@oracl=
e.com <martin.petersen@oracle.com>=0A=
Cc: storagedev <storagedev@microchip.com>; linux-scsi@vger.kernel.org <linu=
x-scsi@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.ke=
rnel.org>; Haotian Zhang <vulab@iscas.ac.cn>=0A=
Subject: [PATCH] scsi: hpsa: fix divide-by-zero in hpsa_scsi_ioaccel_raid_m=
ap=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
hpsa_scsi_ioaccel_raid_map() divides by blocks_per_row, the product of=0A=
data_disks_per_row and strip_size, two controller-supplied RAID map=0A=
fields that are never validated.=A0 If either field is zero, the=0A=
unguarded division raises a divide-by-zero exception on every I/O to an=0A=
offload-enabled logical volume.=0A=
=0A=
Check blocks_per_row for zero as soon as it is computed.=A0 If it is=0A=
zero, turn off ioaccel for the device and return IO_ACCEL_INELIGIBLE.=0A=
=0A=
Fixes: 283b4a9b98b1 ("[SCSI] hpsa: add ioaccell mode 1 RAID offload support=
.")=0A=
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>=0A=
=0A=
=0A=
The division is already shielded by the check a few lines above it:=0A=
=0A=
      if (last_block >=3D le64_to_cpu(map->volume_blk_cnt) ||=0A=
              last_block < first_block)=0A=
              return IO_ACCEL_INELIGIBLE;=0A=
=0A=
block_cnt is always >=3D 1, so last_block >=3D first_block >=3D 0.=0A=
On a self-consistent RAID map, data_disks_per_row =3D=3D 0 or strip_size =
=3D=3D 0=0A=
implies volume_blk_cnt =3D=3D 0, and every I/O returns IO_ACCEL_INELIGIBLE=
=0A=
there without reaching the division.=0A=
=0A=
Faulting requires an internally contradictory map: volume_blk_cnt > 0 with=
=0A=
a zero strip size or zerodata disks per row. No controller firmware produce=
s=0A=
that, and we have not seen it in the ~17 years this code has been in the fi=
eld.=0A=
=0A=
Do you have any known bugs filed regarding your patch?=0A=
If not Please reword to say the condition is found by inspection=0A=
and has not been observed in practice.=0A=
=0A=
---=0A=
=A0drivers/scsi/hpsa.c | 4 ++++=0A=
=A01 file changed, 4 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c=0A=
index 3654b12c5d5a..fd1e07079a9c 100644=0A=
--- a/drivers/scsi/hpsa.c=0A=
+++ b/drivers/scsi/hpsa.c=0A=
@@ -5206,6 +5206,10 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_in=
fo *h,=0A=
=A0=A0=A0=A0=A0=A0=A0 /* calculate stripe information for the request */=0A=
=A0=A0=A0=A0=A0=A0=A0 blocks_per_row =3D le16_to_cpu(map->data_disks_per_ro=
w) *=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 le16_to_cpu(map->strip_size);=0A=
+=A0=A0=A0=A0=A0=A0 if (blocks_per_row =3D=3D 0) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hpsa_turn_off_ioaccel_for_devic=
e(dev);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return IO_ACCEL_INELIGIBLE;=0A=
+=A0=A0=A0=A0=A0=A0 }=0A=
=A0=A0=A0=A0=A0=A0=A0 strip_size =3D le16_to_cpu(map->strip_size);=0A=
=A0#if BITS_PER_LONG =3D=3D 32=0A=
=A0=A0=A0=A0=A0=A0=A0 tmpdiv =3D first_block;=0A=
--=0A=
2.43.0=0A=
