Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013014.outbound.protection.outlook.com [40.93.196.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B78B3E0741;
	Thu, 14 May 2026 14:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778768695; cv=fail; b=GPyH+1MmU5rdxud8VE1vjSKE50e2rVn9K0Uo6Ly4UQ+IhfH4YLc7iNmYLX6NDdCp19Ny5WW1K4mWa+avgdQIUc5w14/G2lUsBzCqu032KsDhhc9vzEYKsTefscfV+L1JYfgOohbcw26Pi2/Ps+cl31Nx9OO6OT19qyxMPQCdREk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778768695; c=relaxed/simple;
	bh=V0rufbqnP3ToY3WnxQCCgcpyvxuYLOPHltdJIVzakXA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rj4wQQD2cTPWQ1SlqOGHW9WTc025Zl5ymaFp7hbkoE4m3JmMvLHGKhE6giBKZYdq/IPzqbBHxuJCOByX2L+4q+y5Sb7G3FZalAJAg8869Ut2Ojn98FQVG+sZEImrKM4mWryc6u4ES6dNQqJjZeKBCtyR4PANNGJszYRE5G3equU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=mnMt1Wdr; arc=fail smtp.client-ip=40.93.196.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="mnMt1Wdr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gs8KLpZlcJvNWdAwn1/0rTkkElr12LzAF2iywCcyixjxwnMj/5VEwETP9jgOvYQo5SuHz8oU4x0V9qo65GKlid9v0e5HagbPfL3f15bxho6qGz+NNKec/Y7TU/zg6+Rejh4Z4gKRT09Gav4JQ8rMr/9Wdi5MC1ayuk67UNT5C4wY+H7JPGi8MMqeWVm3eU5uuDPPbMVYnL1C6DItEG4JjDKU6tLgwcedOTBjiZeOMKX5vnMLvZ/s+QF1JcU0azotUAVMqc5PX647pRYuACAY4/vWPko5kcIazIgS1LY9WhqQmUvBrlDDaiQzA0A2HoPENNY4pW0g9NWL++6nxf6IqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkXwiG3DwbvjUAulYlfM+SvN7H2UljKDdKf471gkjvU=;
 b=NAeHrYD43kkPQjmfbbTG1o1YYwPmik/NpIxZfWIlTWIiq1Jo5werUb3x34mFuLbeZ7FA6qpyVfqJ5mvDBtYjMaz8iRtlMnOddjlHwRusebNmZ+D2Cm1lXowVpCnYAyjGopgVRM1J1vIQjq0Sfb76ROUwnUzaSFMGTV41/Y40HaaB9mkKQTmhqOyi/yQQgnCy0jZv8WZNkwiIS3SuJU8iww6aTNnYkEmjNNoky4tI748+GrctvuApxYS4arrOjcWKY3zvRldHTHA+PSm9r7JGohmhYnFZDMhdY5dH/wQ0gW0tiyrR2UAWvLJELWNeGP8ebVRlf5tsmMNx2zYWUHPwjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkXwiG3DwbvjUAulYlfM+SvN7H2UljKDdKf471gkjvU=;
 b=mnMt1WdrWjSAkbeIPwXtWyCN8NP6PvsEwmZ1pvSOsUQlWvrIG1yrc0GwH1Xg6CPTWUKlBRQMclk904LrJ0dBTEKSOhw69dftFg3n5iOHYaOrMPSwrZkHeRkFwm31msH8OdLV1rLR5/5R78WjWLtprERJ0c8oZ0CACPZ6gZaDmBcrjvx5dsbeAmsnD9zkxbMEqPV7xDJMcdT+1Bi0Gkp8TPK6lEr6JlhcKSB4Y6obkDMjsGrrpoO8llVO7EPEj1qWRMSq30tKYFAquI/IONBL2WA6OXk2tgwb28Q4In/mbGHKcW1nfNAOuL9SNT0BcFg9uj/+zvvnSCYTYKQeymbqQw==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by IA1PR11MB7294.namprd11.prod.outlook.com (2603:10b6:208:429::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 14 May
 2026 14:24:48 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 14:24:48 +0000
From: <Don.Brace@microchip.com>
To: <mateusz.nowicki@posteo.net>
CC: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
Thread-Topic: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
Thread-Index: AQHc3WDg78fpqGHAHUOQRv7RACSNAbYNm/gQ
Date: Thu, 14 May 2026 14:24:48 +0000
Message-ID:
 <SJ2PR11MB8369F3008C15A2E56DB7B429E1072@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
In-Reply-To: <cover.1778075755.git.mateusz.nowicki@posteo.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|IA1PR11MB7294:EE_
x-ms-office365-filtering-correlation-id: 6f8f0977-b542-4a39-fd6f-08deb1c48da1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|11063799003|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 blxdapciTp+au99ybgAw6d4EP1ivAYinzCMUvjiJimZ3jTmVZfvCWLc8t/aZO215asJuXpSE7rerJq9DV11pH6MsDXzBbPaAdSb4TqDK8ZnOdnnj4iBG8QJV6iA/HlDVVTyWExIAsXkfGj4Whai0PNSjuUMIv3HS447HsGi0XmD7EhaiTRVk2vAjmYZ1cHYqp+ctiq5RwRkIZXv3/KNLa/V/BWGmhnhwwdzu7VE6SZKy//fKUMWmnLCfzCzuuV55x2DjwvaWDPSZbB6FOQePcjB5FhVtfMpkDN76LNUH9qat2+Msw9uvB0EC+m2A6in69hIKOKRzEK5XuGotpS5lGHvI2M7iOE1bmm13mMVQECyb6VtXUslH89fvo4QdL/DY0bh4SSrzi8+e1jJPwRqiNSgj0oc1+9aXu111D4uMERT/ss+p9UkP/Y9wq0o/E/f7nVmsrlZx/Xv78cdyZWMFrB5ezeohIj94NyzkX8PhM9KZLE+T6S4DP53zkXbWn9vbhe4KQvX4BBLCVeTz12Y3PPNKSMTvqHFDcsPKlXGCTQSzdpjhjHgAXXAwHB4NGymGXGMku7QYpL6yI4QyhbGa4RQ6JJLMyW4RqqkMikPd9kl/dUoZIPZVTsAWSPVin+tq6XhGQbdiUqcRnwsm5cydaTrby1Ae0w3SQJ/HSxXQRZ3NfKvhTrduWqLhZl6rsOOm6MkYVUDWkrmmBElLnudLYfYL02KDCAFpPVBQgJVjmaQxdlMd46rqF82cb3NjfO/m
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(11063799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?SExjDBW400murIvanvOs8FU1ocsw/7EsCiDAoxHi/IsuiF8jI/25j48P?=
 =?Windows-1252?Q?FGTTrAoNFaF9voj7cWuGIkCniQDNKyI186ce7SyRJE6YAwY6PcVr9/X/?=
 =?Windows-1252?Q?6m9CXvjeGPdlZ9eOij42ZtXFm4x8bbIp8k0oJgC+djq/nsifvpJnhzkx?=
 =?Windows-1252?Q?KabdSckE1a0wjcw/qqBNVQFuSZYbG7To9h/oykEXovd31xU86IzcOjOF?=
 =?Windows-1252?Q?2SQcg1s56OLnTz08kPN/XHH8GRUmT0U0b2RSksiR5YnmXUJk754Ktfw1?=
 =?Windows-1252?Q?3Bi1lNUNRF9QV7caGG0Th8qbGAelTip7iOJPwZueTQuGcrXWwhRH3xEN?=
 =?Windows-1252?Q?bUy/Glhd/8UU51M+/228QKE0myWbjgk09NG+XdW3Gs++eWomEPRAoK8P?=
 =?Windows-1252?Q?Duz9s0u8HUO5FQhb+I5ldwbf9ev4UgPX2j2lcq1/J1kHdPomZ5610OHH?=
 =?Windows-1252?Q?8pR4JpBu6CGCVqNpokSPymIImVW4yO2elQYS8d5vRMQTri9nSxV9Tjd/?=
 =?Windows-1252?Q?g8ILrohmyl75EyWh0cX/+12r9tYL9bOo4bBJxDlSPFaQeubJnsH3Jj93?=
 =?Windows-1252?Q?PTCMQI3Q+7C6GThMsO3u30xO8999jYj3EuR/R5QXpp4w+9TDJnu8meQ1?=
 =?Windows-1252?Q?yfMHU1lMKvqijmQhhCORVAUBSoRyde5eY50mKmIaLn64y+ydTykVMdMh?=
 =?Windows-1252?Q?K21Gnm6yEx+CrqwkeJTlqp/nQ7XlAZkmEnzEcF3vIvHRRQRWCS5ZvhvS?=
 =?Windows-1252?Q?URDyYcH7xFoWcG6clbwzanPvU82NI4WV7b8UR9XI1pRezZe2z+9J4jdq?=
 =?Windows-1252?Q?rGIVv8xPQWuZRdyGblTDoMI1p3BDGAt+XU+R05MKaBoEMFXzFDapz5ky?=
 =?Windows-1252?Q?mzGRL/N758VFp14WGHOi1QFQAWyMENQaI793reQOOHKMw1Kje2Pgbbqu?=
 =?Windows-1252?Q?kfk0VNKz1XlC/yu+KOIZAuYKG0IQR/6kopdQr3kc5Zu0bpdyqADFbab1?=
 =?Windows-1252?Q?EtqqdoAhc21fJq42NpjrR37O6CHi7PiFYAZin1RInNE39acViFPUbZb+?=
 =?Windows-1252?Q?n5mBNwLSijmKdKaveX88QLpNfJBX+jrPBruMESVsme5LTxLqrl8zy9fK?=
 =?Windows-1252?Q?ojSlGvO6q8cfFFra6sQ1DWqmVsA1NIMjleMEI4kWuL8CnYaoEnc6gEfu?=
 =?Windows-1252?Q?5xxulsBKM+3CmJVzcQOLomd7SnERsQQPeGqzwiNlmx8e982Slhk/uhfN?=
 =?Windows-1252?Q?OaNPP1GC/k0oq65G3JszCN5NNJ78Iis0W02C1RLfeo49zV/S2EWuUHy7?=
 =?Windows-1252?Q?eDH05xytu2J9j30fJr5y+fBJwUpd8m57D8mYnp+gl04m3zTjFKBVRXqV?=
 =?Windows-1252?Q?xJZ2cfknjLYHsuE+KvTuS5o1Yejcz0lGwxBSGe6+cUZH2NU6XlTZ+SlK?=
 =?Windows-1252?Q?Nrxly2ktTOVHl3CxWouNCJT4e0spPPNMHXhdAgbEBeWjb7XaqUg7qedE?=
 =?Windows-1252?Q?A9adelJ0MAwQ0/WTwHVEG9pnpPeaKN9vVhFmCvKSVB8ErD2SonsMK2bv?=
 =?Windows-1252?Q?Tf1qp85pSnEgtzx2e4KyhcXW+g7Z7GfD13QMXkW3NdIERKriamzpeIHs?=
 =?Windows-1252?Q?vHO2wFimR3aVTQ1KHX0j0MCpqzGyZ++V9wC891Jdz6qFoL7g3LgqQ6r4?=
 =?Windows-1252?Q?oTZPpz+VdA9R/hq25G3yK7hmhuDXU63ZJAiUgIsDZBwRfUr7OQEZLBlR?=
 =?Windows-1252?Q?A+FAP2D6fNKedlt58NgY+B10vaZ8J493om2TOYwn8BBYlMRJq9IQ56e9?=
 =?Windows-1252?Q?9JTrnNTI/fOZCDqsYTGYO1IauO2IaeKD+2hCwupN+K0J6Pn9/2CyGURp?=
 =?Windows-1252?Q?2YdUBbg0EVkzYg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8f0977-b542-4a39-fd6f-08deb1c48da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2026 14:24:48.0396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0rlSA3fSzh3NwoQeYct4yXw0ZOh8Xs1+iYD5Uy8UwsH81JdPl09cYtGliFyGRUKU6YeRiH42qcl5Qk5dzMC4eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7294

________________________________________=0A=
From:=A0Mateusz Nowicki <mateusz.nowicki@posteo.net>=0A=
Sent:=A0Wednesday, May 6, 2026 9:01 AM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>=0A=
Cc:=A0martin.petersen@oracle.com <martin.petersen@oracle.com>; James.Bottom=
ley@HansenPartnership.com <James.Bottomley@HansenPartnership.com>; storaged=
ev <storagedev@microchip.com>; linux-scsi@vger.kernel.org <linux-scsi@vger.=
kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>=0A=
Subject:=A0[PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
A PCIe bus reset (e.g. "echo 1 > /sys/bus/pci/devices/<bdf>/reset") on a=0A=
controller without FLR support leaves the HPE SR932i-p Gen10+ unusable=0A=
until reboot: smartpqi registers no pci_error_handlers, so the driver=0A=
is not notified, firmware reverts to SIS mode, and all queue mappings=0A=
are dropped while the driver still drives PQI.=0A=
=0A=
Patch 1 adds .reset_prepare / .reset_done reusing=0A=
pqi_ofa_ctrl_quiesce() / _unquiesce() / pqi_ctrl_init_resume().=0A=
=0A=
Patch 2 raises SIS_CTRL_READY_RESUME_TIMEOUT_SECS from 90s to 180s,=0A=
matching the cold-boot path; without this patch 1 fails at the SIS=0A=
ready check because firmware boot after reset takes ~125s on the=0A=
SR932i-p Gen10+.=0A=
=0A=
Tested on HPE SR932i-p Gen10+ against Linus' master at 74fe02ce122a.=0A=
=0A=
Thanks for the patch. =0A=
NAK for now.=0A=
=0A=
Before we ack, we want to run this through internal regression on the SR-se=
ries =0A=
=97 particularly the OFA + bus-reset interaction in patch 1 and whether the=
 180s timeout in patch 2 should apply universally or=0A=
     be controller-gated. This may lead to changes in your patches.=0A=
=0A=
=0A=
