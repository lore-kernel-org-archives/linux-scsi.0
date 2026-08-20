Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1AA362138;
	Thu, 20 Aug 2026 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787252512; cv=fail; b=n2Rd2i2RnCwCYHlJN6IMfO0yploAf1HEAF0x3t+HOO0vmRMsBvE+5a5wjpMqKgT0x9JMKWadkjg+LMDrR0DI0iWcRu3CmN4wNZSqYj2s+SKdYQdTMjHHbNdXTSLZrKM9fUkR7blG9JbJCs0egesSVIBF6HTZ6Zl4Lr/kOGjv3m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787252512; c=relaxed/simple;
	bh=qSHdvXRQ5r+rtPFEKuhoqWuzkmp176h3C21viVh/Tis=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iRsBf4A30ePCLDESkZOVN5DVHJR/eSp5TDasbZfLL0VBI8X3yeQORvb5dcNL7BQbpdNZaYwnsRUY51eDF39M6ssVKpi4ci2MLlaNDbj4QiCW3Lkaj/iJA2KXpNuE7J6Rcy518/fudblwy1w+HHiESORGj0vz/Z7Bbj1jUTtpMws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=mH4KeGf8; arc=fail smtp.client-ip=40.93.195.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="mH4KeGf8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GExh/G48emroFIU/hhydjgwSxAODBC/xw3zSBqE9rd9u22WA9FXMudK7yW1Yir8+zYzyY3biCoUtdj7YXm3sq3qCE8XZ1dGYMwmeKFDcNQa6Y41Gmg1BZA4jbDiuzS6h5LVKwY/jfgJwyuJtUavvmUOv2cUyVDiw6JCpvF7rHMyuJnAgsY5RmAuL0iRVCNglFWa8cFvLxD4m2Bc7qpaNjHPVW9+G3i+TnPgjZIa/QccSElFOqTBN2i+RTgc6Y4zaPSltbbpn8veaCq2GdV53NBO/K19pOtwYu7HaBDeVmpUWt/8WwrCaMiOIMsZ9BoROI42KBF+Tpq8mFzM0emPOeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSHdvXRQ5r+rtPFEKuhoqWuzkmp176h3C21viVh/Tis=;
 b=MEhZ/OxHwE6+KeXXSMaOYxTe1yp+bFnr2wV+U3eo2PtS57pnLqYv7K352Q4+UZ6IQO8I5smEyMYDNSzBrFQUMSM6Qaa+rgssTntqUYwNnvUD/LNx4A4PixvrI5ey8d4tXWT1TKNFmuCWlDvp+TNxCcHZMBA8PdC8Prz/MsTcG/XfWq0m7TwYOFTsOPTdVoZzkGhI77YjFSf1viSF5kSb2UK8+1GaWANI3Aya6lf16/FNDT3lxvA5yPEbBqM6B4crLfgPmniUTGWBnkpWnMOON49mORAWRSozv4EE9xZOHcoGwx/tCeJuAXNDPGtMhGDRvZ7uHQRzNZtxXtZ9Cw2neg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSHdvXRQ5r+rtPFEKuhoqWuzkmp176h3C21viVh/Tis=;
 b=mH4KeGf82o4DxMP5MY1iI/nFwnu2KkknAOaYPAcAlOVMptPq79tMdC6inqsVd/2MZPcYzlJ0FfU1JuIg2sSqqoAWJHqwnSR9pmluPzbcnsj9rcQ61n/yGhyuSx/FJkT3o9ArmO13ZwJajfNR0aAVYY5f4+6ouOo2R5LsBQvoNNcQgTZilpruLp+UyKu2pyD4jnxFip8IHPYNJ0tzV8J1IYIZ2rGnF/xeaEzJnweVkGlm+QaMMMbjc/eHssBVNbG1eza5/RRlMdu7sJLPT/NIlKX8i9USiunkTANhGB4D8v0b12gDDzfr62GITiWpl2OcpZ9WrKlKYrZFCz2Q2u9CeQ==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by CYYPR11MB8329.namprd11.prod.outlook.com (2603:10b6:930:c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 19:01:45 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%4]) with mapi id 15.21.0315.016; Thu, 20 Aug 2026
 19:01:42 +0000
From: <Don.Brace@microchip.com>
To: <triet.hoang.dev@gmail.com>
CC: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: smartpqi: Handle pqi_alloc_io_request() failure
Thread-Topic: [PATCH] scsi: smartpqi: Handle pqi_alloc_io_request() failure
Thread-Index: AQHdLflxQRVUVBuUTku4BVkAo5p+nLanTlM6
Date: Thu, 20 Aug 2026 19:01:42 +0000
Message-ID:
 <SJ2PR11MB8369306620893ADE4A71E5C3E1A42@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260817033505.736519-1-triet.hoang.dev@gmail.com>
In-Reply-To: <20260817033505.736519-1-triet.hoang.dev@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|CYYPR11MB8329:EE_
x-ms-office365-filtering-correlation-id: ce83d214-1153-448c-eab0-08defeed793d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|38070700021|56012099006|11063799006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 ffhl5g++BwyGuZJYh6lwHKVSk0QlCf0CDzNYz+yoqh51uiXKTdW6X+SKcb20nIIbOv1QOpLUkqPohi848PlVmKsG/X6XhFGwCKbieIMqBhB9HSREaAvFyCDAkUsG2dUku3eY+XKmSXmwVmwMW12rrwbpVuEmqH5Eldl/qhLK1JWS/YQsvv+cYWu5bOz/DlKp3OOY2WOXtfKXr3RFdvhGHA8OBO4Mdy3ov97LGEihntJbTAjFOpTp/KqNIfP0FKIcmhQ2HHNqBfGAY7YN4sucUHjUFSPZltuNEmo+hPnW6CaZZeWr45ZCnr94bAWHNILSAdSDMfva+VA+8jJmxq0MRdjraC34cOswx0E+c+vrBh/WIratCViIS1O/8Q5z3enbOHPXX0aEhVWMHpWSxr2CJPqwrRa9YXAQlW7gqC2sc3mTBEE4WpAYOO2nxhbvYbZugyLxNppQn1hjiYpsdKq/jy8BFDmNqJRFp0awMOTzjiagdXtZAzEENObKVlFn6tvLNNJrNWkZqtu4swbusPyxmpSvsCnnMvIK0TzQNNz20vlvSSW5Oclp5pxPyQ1SofKvDCxyfAD4VQcg7iiWkodBjxZuZoRBjGMcBcuFnl9gbXPcogSfVxp5V3Vx0oXLmRVA/8pGXuziPITY0TvZ+6c8SF4RkkxhQFo/UkK2jx3j8UtOadlfLyqTZpER3lUB7yq6KTcZZO4QJf7M1gdRJ6k2mluBtSd5dCtG5X0rOUevyU8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(38070700021)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?YSYCODY8kChA8k2YnKmaI5USVvbjSD/5gNjYPv9T2ImCNkBNn3KTYL6rJS?=
 =?iso-8859-1?Q?F1236Xs2mXEs6UM2NQJdy1bqWKD1IYfxzDc5W4zX0n7AQ1oI/eBfUnXxRy?=
 =?iso-8859-1?Q?mXU37RfC4moNr5h+M8ZYzr45rHdG7KV8xKN7Rh2Z+4dB6xRlh1EFIIRySi?=
 =?iso-8859-1?Q?eVSf404ANzsfhEjAQHLJhUX5ZlNo1OS7mRUpAA4nxWdujE0XTJGtOWWK1z?=
 =?iso-8859-1?Q?jtLi1V+OLy/GLZN0X0stQn0vy5moFQCZ+QaAHMJytFs//eKTWsvW6G7+4Y?=
 =?iso-8859-1?Q?H1vC05/zSide51g077DncqYUUcxR5PgIgEBS92/cpMGhF0KsSVwKsZXD6w?=
 =?iso-8859-1?Q?sKK7mU1XHO/Dyu5JHcZmjTZxqrZ65iUo39obmOuvCFVmrwHAziQ+lej1qx?=
 =?iso-8859-1?Q?wgERGeMGA4tOHkE36qaWI/28P3qmBEeNym4KcNCU5y7bcu37ek4W/goY/3?=
 =?iso-8859-1?Q?4sWqqdX1CC92/7syhYWM37Y7H4mVH2pr/d8uF63Sn5BU8hlMnHHmuSWUmg?=
 =?iso-8859-1?Q?8sehFE1b49pYcnsZ1VN4YfD4OaWyA2dTQ+Eq4lXKjqbPOD0XHlxFQgYcuk?=
 =?iso-8859-1?Q?Fi1EeaWi4QrWQQ6nVBehqaYfVF0LxGbnQmXP4970mzEuenuDI/Q5zp0DU6?=
 =?iso-8859-1?Q?ajFSmMnAVFEh+mQ3hUixqFWSXt9rrzNrMRvkBBP/ARsdZFX5M8oS0yE9jq?=
 =?iso-8859-1?Q?RqJk72DHgAi1+r/I/zCv6OTZCcEus83tWhx2ag9XlviaXdWfxDpq80aAar?=
 =?iso-8859-1?Q?ExOPYqjHzj216TX+n+I7kd+hC719DoMxu4KlKKihw9pFTIn4amESdSzk1s?=
 =?iso-8859-1?Q?371mXDwAf53nSQLzXY+acv6yPMdrVAc21luDlptLtCgHG6Oodj3YdCWnyR?=
 =?iso-8859-1?Q?1+Hn/HMQY1BzUNSr1C8iCCr0HptlxMa7V3bVnUVWP/4N5Cn3daPglqjrmn?=
 =?iso-8859-1?Q?tISjpQBQl6R0KcD0AdImzDovAvZgK+tFKiWh5+u5fyNWuW3VIaYN4NwuyG?=
 =?iso-8859-1?Q?q8BPW+RvHtTg5Bs2NB7EszPagMkKAupE7KYLM2fNshDDw67EfXe5RdiPkd?=
 =?iso-8859-1?Q?tUyX02R80v0OSGvDpXoJZqP3Pqnlf3QSgcOe7UD2PMC4V8e8JdoLG0mNbV?=
 =?iso-8859-1?Q?ndFJuiutSgpco0xEit+RJ7Br62RZkRhUxIi2ZrnpKmQbInf1Jk9J/h6wKU?=
 =?iso-8859-1?Q?jnAzOCeEea3l+kVUT0t303K04eJdA4nqgIZ+M9/j8JonIN2on8PsdsxcAv?=
 =?iso-8859-1?Q?dDRdhzW75T0lPsHtc8A/vOmhmuF1eDx9vyoR3ig6mv8L+ih/jPncYdbVuy?=
 =?iso-8859-1?Q?BhbPl7KvHcTSvlwCrPZTYN3TxciyX+bPEXxJzpSW6r3OQ8ZVIe5QS0lJbh?=
 =?iso-8859-1?Q?/rVIy+TPOBE1Is1ZVKD2CXmzSbhQtGNpRHNLobJWO8aroec09OTy4qZcm1?=
 =?iso-8859-1?Q?zNCNjyS54ZDqMf97tZx1VsnXAyTRlbcHEljj/T1gmRjXo28w7cdMyEEbo8?=
 =?iso-8859-1?Q?S/QYpKgN4FO7MlTZiqsTzgmRL7VHwIbrg5ZfxL/9/IweaNMSNvqDEutqeI?=
 =?iso-8859-1?Q?d0J9+9ZTH4uejyXvVUghXI9RH3Ilbb6MT9EzKGDm3uM8690/sv9JrnKXH8?=
 =?iso-8859-1?Q?bJIKloDwlznx/IqhmxPQqUbgEcfz5lX1teMRwLasJuUVrQENTooB8jIr+6?=
 =?iso-8859-1?Q?XqT/jKdM53+fZ5Xwh8xi3LTlxxPWunQOFc0MkI/h5Nj21hFuQuwu9DpOie?=
 =?iso-8859-1?Q?6W2NFRvNI1F3c9KdIGn01CV/JOSq5L/jm5sSDI+r2t9DQqzcpy7yDEf3NC?=
 =?iso-8859-1?Q?iPQxjstn9g=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ce83d214-1153-448c-eab0-08defeed793d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 19:01:42.7441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yZmLO158/D3IQsoMZP8uBpeb8UYwLc39Ug0DVVA++k40Tl3o7rPHi+H6SQXOCMzhHkPjC5qTdEjr2RNiPUbzlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8329

=0A=
________________________________________=0A=
From: Triet Hoang <triet.hoang.dev@gmail.com>=0A=
Sent: Sunday, August 16, 2026 10:35 PM=0A=
To: Don Brace - C33706 <Don.Brace@microchip.com>=0A=
Cc: James.Bottomley@HansenPartnership.com <James.Bottomley@HansenPartnershi=
p.com>; martin.petersen@oracle.com <martin.petersen@oracle.com>; storagedev=
 <storagedev@microchip.com>; linux-scsi@vger.kernel.org <linux-scsi@vger.ke=
rnel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; Tri=
et Hoang <triet.hoang.dev@gmail.com>=0A=
Subject: [PATCH] scsi: smartpqi: Handle pqi_alloc_io_request() failure=0A=
=A0=0A=
=0A=
Check the return value of pqi_alloc_io_request() before dereferencing=0A=
the returned request in pqi_submit_raid_request_synchronous() and=0A=
pqi_lun_reset().=0A=
=0A=
Return SCSI_MLQUEUE_HOST_BUSY when a request cannot be allocated so that=0A=
the operation can be retried instead of dereferencing a NULL pointer.=0A=
=0A=
Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>=0A=
=0A=
For internal/IOCTL requests (scmd =3D=3D NULL), pqi_alloc_io_request() bloc=
ks until=0A=
one of the reserved slots is free rather than failing, so these two call si=
tes=0A=
can never observe NULL. Only the scmd !=3D NULL path can return NULL, and t=
hose=0A=
four callers -- pqi_raid_submit_io(), pqi_aio_submit_io(),=0A=
pqi_aio_submit_r1_write_io() and pqi_aio_submit_r56_write_io() -- already c=
heck=0A=
for it.=0A=
=0A=
SCSI_MLQUEUE_HOST_BUSY (0x1055) is also only meaningful as a queuecommand()=
=0A=
return value. pqi_submit_raid_request_synchronous() returns 0/-errno to its=
=0A=
callers, and in pqi_lun_reset() a 0x1055 return would fall into the retry l=
oop=0A=
in pqi_lun_reset_with_retries(), adding 30 seconds of msleep() to error=0A=
recovery before failing.=0A=
=0A=
Nacked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
---=0A=
=A0drivers/scsi/smartpqi/smartpqi_init.c | 7 +++++++=0A=
=A01 file changed, 7 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c=0A=
index 5ec583dc2e7d..0930decef404 100644=0A=
--- a/drivers/scsi/smartpqi/smartpqi_init.c=0A=
+++ b/drivers/scsi/smartpqi/smartpqi_init.c=0A=
@@ -4667,6 +4667,10 @@ static int pqi_submit_raid_request_synchronous(struc=
t pqi_ctrl_info *ctrl_info,=0A=
=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 io_request =3D pqi_alloc_io_request(ctrl_info, NULL);=
=0A=
+=A0=A0=A0=A0=A0=A0 if (!io_request) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D SCSI_MLQUEUE_HOST_BUSY;=
=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;=0A=
+=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 put_unaligned_le16(io_request->index,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &(((struct pqi_raid_path_requ=
est *)request)->request_id));=0A=
@@ -6353,6 +6357,9 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_i=
nfo, struct pqi_scsi_dev *d=0A=
=A0=A0=A0=A0=A0=A0=A0 struct pqi_task_management_request *request;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 io_request =3D pqi_alloc_io_request(ctrl_info, NULL);=
=0A=
+=A0=A0=A0=A0=A0=A0 if (!io_request)=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return SCSI_MLQUEUE_HOST_BUSY;=
=0A=
+=0A=
=A0=A0=A0=A0=A0=A0=A0 io_request->io_complete_callback =3D pqi_lun_reset_co=
mplete;=0A=
=A0=A0=A0=A0=A0=A0=A0 io_request->context =3D &wait;=0A=
=0A=
--=0A=
2.53.0=0A=
