Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020112.outbound.protection.outlook.com [52.101.84.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05862368974;
	Fri,  4 Sep 2026 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530085; cv=fail; b=u0TiOR360JzbDSwobxqk7m9Q5bpD7cFtYxvtecGIA5Yoan9YcWDwtMINfLYn8vN1ueRc1a9RMaEyAwb6PSQ1wHQ6gwTKPs1oekTKnMnjJzbyS/2fuBoWDhby8bGdcqOnU1AfPYeVATMqYxZQPcaxFFdnfgPDHUEuB7AK7qrWCmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530085; c=relaxed/simple;
	bh=p3hEreqki7xtJCq9/i8+7mTf+U18d/TxyLGZn3jZa/I=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=i/jr+A22CwYPIhnZI9DVzK4NpfwZMS2cMh2zsTrThbbjzIEeZgEpTBQONuk6gXC2K/fT6l3cATa7/ryjbO+ZFjo5clkpHFUMTGNZd0gOHze8TfsIpLfW6xlAs2stLqDNplOw8+Ah7nM58iuLdeaWBTToFMild3/0lxg2ipkpd+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=drivesec.com; spf=pass smtp.mailfrom=drivesec.com; dkim=pass (2048-bit key) header.d=drivesec.com header.i=@drivesec.com header.b=AATGinbC; arc=fail smtp.client-ip=52.101.84.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=drivesec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drivesec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=drivesec.com header.i=@drivesec.com header.b="AATGinbC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j46//F8IDoRztHR2Xpj0Fx0CKii9eO4GwQKtRPHdW3qqyeJ2JIz/J1w2rx1fTr+xQlWo6WfhjTpyWW+ReupEdA4est6cme4cZ5cfZp42s5eHRo8SLG0Xw0dUQ6GU42YHiaaNZv1HWqWINYAwWGHCKpoPMvTYgEyAxRQByHAOlM4UC8Wix2OeJqFSJ8HQq3CV99OWdbESFkniPZnPqZqC0z7Fjajedhz+dP8YdTQHMO3JhmsTD3UKvEDeuUSzFvQZwz/BVavKzKwit5EUtzCGcxQoIT7PiOFexPoJEgL1ox/UQShNOX9zrhs1XJ0xFtd3ZyIPQHjO/d4Y/yk87IwKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLMtsV1bNn7InwDGkMAdLRgw2TXBSQngCT/g0xZRqxw=;
 b=wPCOvfmNTDfzkXAKWy9cBohtNg//KxTGnnudds49tonmp8aLWiUtyXpRqcpJ+DN3UVDq3eh+gCrzoPHQQ9OcbVmEcUhjQB3uZ5NikE8J/X0GJdsCoVx5/hL9VSUoq50M8g3GJxWcA1AHh1j63gDaEouw1O99P233Hp4dR03dH9fIzw8mvodSOnCDGMcNcPn3cRqlezLsAzw6mdDJlEabC2w32PoqN0zfz8e8S3axKtoLluat2MBd6Yx5FWaHYn4Zy68SMbytuc8hOJWJQe3OWMuFt7QiW0HFfrWOXTLmBXHM98OzL+e70yHDTaZ5C9nR1wk7XnUSVS/XkGnBiVO1Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivesec.com; dmarc=pass action=none header.from=drivesec.com;
 dkim=pass header.d=drivesec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=drivesec.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLMtsV1bNn7InwDGkMAdLRgw2TXBSQngCT/g0xZRqxw=;
 b=AATGinbCREioEGSsl+jsVTGOW019RxEl3hIICTdbNFx3mXOXymy3TunWACLKDfLOPmKoOlO9rimtdVrNEAnAhLDAdwQrwpZbAILhtn3fJTdknLFHKcJTAbEtPxWWwZxtzOEfkkuCfFXC2nQQE5DNAJeJGPQALXVWAdjjphoj4MQ5W97VACwOgu5WcGVBeg9QCZT7I+80dkK2GDg+sQFlA2iXbewFVl2fChMj3Ifa7SO+hIAZWTgOND4DDmkdOWCiNNnwJv6tYizpfgsSwV6hNlMkUGQlHzHJxFtRsBp44htx0zfZnnqf75sfDQDQQzCcHM5LBtot3iLvlijobL/00g==
Received: from DU4P193MB3185.EURP193.PROD.OUTLOOK.COM (2603:10a6:10:63e::21)
 by AM9P193MB1048.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:1f2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 13:54:37 +0000
Received: from DU4P193MB3185.EURP193.PROD.OUTLOOK.COM
 ([fe80::95bc:70d1:d001:69a9]) by DU4P193MB3185.EURP193.PROD.OUTLOOK.COM
 ([fe80::95bc:70d1:d001:69a9%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 13:54:37 +0000
From: Alberto Carboneri <acarboneri@drivesec.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K . Petersen" <mkp@kernel.org>
CC: Flavian Dei <fdei@drivesec.com>, Willy Tarreau <w@1wt.eu>, Hannes Reinecke
	<hare@suse.de>, Niklas Cassel <niklas.cassel@wdc.com>, Damien Le Moal
	<dlemoal@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()
Thread-Topic: [PATCH] scsi: core: Validate MODE SENSE lengths in
 scsi_cdl_enable()
Thread-Index: AQHdPHTsccjEq9C3OkWhHO9dT1wahg==
Date: Fri, 4 Sep 2026 13:54:37 +0000
Message-ID: <20260904135410.360314-1-acarboneri@drivesec.com>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivesec.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU4P193MB3185:EE_|AM9P193MB1048:EE_
x-ms-office365-filtering-correlation-id: ed18777f-35f3-413a-927b-08df0a8c0f0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|6133799003|56012099006|18002099003|38070700021;
x-microsoft-antispam-message-info:
 B0QxlRpx2QfYjINjzBztnUBT2RtnppDcSd465EuzJkXwe1MWemwuAn3E6+/TCBcPp/9Uh3hQYLif5YmuX0csDiyt/R+tO1E2/HuxbSamgz9KAT/neQy0mVlyOPWN5a0U7zmuT1/frH8EJrNWdmWYEWYC746Sv/cS6pAG34jrOFYUD/poALN12ukm++bsMQ4Xopm8KcVKTIi1SKh5EMwHWyC/+Q1CBdNLtHGcV78qzI51gWHAmzxjyXlbYlxd7T4N5edzaemtLwP8u+ufLlfjHvHlAnpE1KvyYQX+lE/PpmBwFrCrb7Y+y8gqyw16sJoh8GucLaQdKdRI6hhj6nLdTYTvKef9L3TJkz9HmF7q2uHD6VsgO+idHgEON7956f2P1DXMsM6uXUDUf1jY0MgDHSv6X/fAOK+Juu9p6SbwLkVN1G4LqBXWsingPE17xHvcfRzWypkdzv/gnszLAaXG8CHmldyzfwias3zMInO+DvVWIWLm3puw0LPHn7R8fgx2vtq+9DdIV+ruNTkj3WYL8FEQ+OzPBZWEvk7p+HKLGZS3iTUwufXnKuRRJFN2+8zlC3iwiOE6FegxU1mOBfWnPZX5Lo4BO76CfX+6CoJsQ7c0NR3WPNamCVdtkx9mvOrbt7vXhrA6OlKwWWHuyzqLavOubMNf8nGVwB9nbpm17IuEfSGA26SQRvw/9rN3DFSmRnN4qQQtrjrvG4vktBtFVdKm/B+qQy1HTNGauDrilRM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4P193MB3185.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(6133799003)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?FWstsQkxP8cy1uDYSFj/8KnW8QrtSE6dgTMkGVk9iAdOeWQTifEB5PQlL1?=
 =?iso-8859-1?Q?z6eBRyD28teCPnBvfPNI7PkGTma+PeoXPbh4lpGekk18ESe/7lXVBVrrxE?=
 =?iso-8859-1?Q?wzBQRzYOeipGALVW4qQUuse/TrfPPf335z6iADIyiK439SBGLyaUsxKerX?=
 =?iso-8859-1?Q?iYJXbvqY/N314LPQ80WDotPkHENae1QDZ0ZkhfcLSVsDHd8sjLDhuH61kH?=
 =?iso-8859-1?Q?/NUJf5YayMMmgZ0+YXNnRhanbkm04N3SefucHr9SM9pAAFNb5+9aSUV7hR?=
 =?iso-8859-1?Q?vNUEUkDaPY6zoJsjEWCPLfbIQLCSpSskX57n0LQ8bXAhZ4mFzYgNT3HHIo?=
 =?iso-8859-1?Q?zsD9fnsfnxysBqyPf6xlkScnaqCgrqsmUplJRq+tGhw/Vnzg4GsPnoJtCi?=
 =?iso-8859-1?Q?ePNHYC1DDFFn0Vo25h2pE5rtCpPOEcrJkR95VZmngExJyli+nRkSpZJAHR?=
 =?iso-8859-1?Q?m0wVTBLGHcYbPbKRqrVNWbJHlkO3hS8FqkCnuZMBnYnbXV6mJsUZ6mdp1B?=
 =?iso-8859-1?Q?ZMGVYIrNJcEsJRBlt6ZJzIPe/6JU+DmpB7JEH3wqPX5aYf6j5Xqfm5XON3?=
 =?iso-8859-1?Q?NUKK3hvZqFBgkq80W0/dIPu9Px5ZlxUFNsTTL+c+jlxs1PK1ImsN/4WWPK?=
 =?iso-8859-1?Q?EQs7EQ6Hvwcc44O9irbmKoZHjsMxdQTcJMcxjOnfe1N+WtsLErKn4H7FMx?=
 =?iso-8859-1?Q?njaa6gkkmRtdKNuoaIdkFYuTl7+TNd26OJN2AUqQecXPw90y7euwgTHTJM?=
 =?iso-8859-1?Q?oYwMMdzCQA14UwHYZTxLgVnatbe4KOdWwGAiKjC9QjyTa6yK9wD1bz0HJS?=
 =?iso-8859-1?Q?0aVXGI3S4jJfBQ1QIy5FB+TirkDAHSwGLQ3Gjl3Y+BOcQOoNbenNjn4T3h?=
 =?iso-8859-1?Q?oqjQreedJKLpTaxDkkE/KV9KvjXvKMpiZ4UGA5O2AsrYM/d291AUJwA7K8?=
 =?iso-8859-1?Q?WFPx6TsbslD2Y0D9oZgb/XJVt4/rlQY8+MN5AiLEaqhzP+tvVt5/P0FW0c?=
 =?iso-8859-1?Q?Y1NbNI0aUX9VaxeeSBuLNJCJ87ZHC69elA+oguAiMkCDX0JVULAclCr3k7?=
 =?iso-8859-1?Q?aDm6tdJR14LBjgH9vpF3HVdLWjBHfL8fF+QTZpWVOkXNkpPxP1qQpkvkwZ?=
 =?iso-8859-1?Q?A4UhSgB1PFwzEXhBi46OdU1OqGlm+6DT6eYgPWNlbwNxbQtAISDCbTdQ0C?=
 =?iso-8859-1?Q?grm2PetuN5XQSy8/UiUnB+Wdh8j6AgXypiJSZZaGsysOQgdzkldTZjrupd?=
 =?iso-8859-1?Q?NpnhRvbReX8tfYpR0Y8eEocDNGoCtwvnNSi4HMFgfJkuVPSlQBQfCkTMHP?=
 =?iso-8859-1?Q?20zIkIkFRjrtHr0SP2BsKzKa9MQGEKGmLiHq/sXYnCyi5ZeR9i+xWwavAb?=
 =?iso-8859-1?Q?VqZjm1ViCNIPRno0+ywxOZqyToIqrsUpDiv5/9hAZmkp8ry8ofMvlm6mQI?=
 =?iso-8859-1?Q?nkMTA7DzFwmfSfqvYtKDeCdgkEnmnyMSdKH1S+Rn9YqSpPdR60SKaDBH2b?=
 =?iso-8859-1?Q?f5Uiobvackw3+WJyxlmtncSjUfqtTSisiuXQYQKkcbtJqx+x1cxZQYr854?=
 =?iso-8859-1?Q?IS/K/Re03cM+WNz+HhXnup0fkBkNJvXzA7kwOcCxddBhoJZAiCeuLtr255?=
 =?iso-8859-1?Q?psqQh+NGW36GydZdMiCdW5Rs2m6PpQWfkNNMqdT5Lhh4Yw43sKJukh7Xk3?=
 =?iso-8859-1?Q?M4Vm21QbiPLjDB6GQQdBWye+6fuKNMtIFiAiTxS9pMAtp9hRGfxyjWys7C?=
 =?iso-8859-1?Q?taL7FDqAfYhcD+tD3cV/28k79vjVhNPiUvWebLqxv0XxOB?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: drivesec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU4P193MB3185.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ed18777f-35f3-413a-927b-08df0a8c0f0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 13:54:37.3735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 366e08b4-8687-488d-b967-a9f52a74f642
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0VzsiMffEcxoAJ67NICUuM1+D/lK6H8GxEM7IOLb9kjuw98maRbrGz4i4UQJcHBj6TNEmOvdGh2I80uThBbG+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P193MB1048

scsi_cdl_enable() uses length fields returned by MODE SENSE to locate the=
=0A=
ATA feature mode page in a 64-byte stack buffer. A target can report a=0A=
total length shorter than its mode header and block descriptors. The=0A=
unsigned subtraction used for the MODE SELECT length can wrap, and the=0A=
separately computed buf_data can point beyond buf.=0A=
=0A=
During automatic scan, enable is false, so the read-modify-write of=0A=
buf_data[4] can clear the low two bits of a target-selected out-of-bounds=
=0A=
stack byte. scsi_mode_select() can then copy up to 64 bytes from outside=0A=
the buffer into the outgoing MODE SELECT payload, disclosing stack contents=
=0A=
to the target.=0A=
=0A=
This is reachable while scanning a USB storage device that identifies as=0A=
an ATA device and advertises CDL support. No filesystem mount or userspace=
=0A=
access to the block device is required.=0A=
=0A=
On upstream commit cee9395acd80 ("Linux 7.3-rc1"), a build-specific,=0A=
one-vCPU QEMU/Raw Gadget proof using QEMU-only multi-UDC allocator=0A=
sampling executed a fixed proof command inside the guest and created a=0A=
UID-0-owned marker during automatic enumeration, with KASLR and NX=0A=
enabled.=0A=
=0A=
The issue was independently found during security research at Drivesec=0A=
S.r.l.=0A=
=0A=
Cap the available length to the buffer size. Validate and consume the mode=
=0A=
header and block descriptor lengths before using the page, and require the=
=0A=
five bytes needed to access the CDL field.=0A=
=0A=
Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command dura=
tion limits")=0A=
Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>=0A=
Closes: https://lore.kernel.org/linux-scsi/20260717192313.93D791F000E9@smtp=
.kernel.org/=0A=
Link: https://lore.kernel.org/linux-scsi/20260717222931.AC4EE1F000E9@smtp.k=
ernel.org/=0A=
Link: https://lore.kernel.org/linux-scsi/df13ec87ac9b28e3b0a2d9eb26477e276f=
f0278a.camel@HansenPartnership.com/=0A=
Cc: stable@vger.kernel.org=0A=
Assisted-by: LLM=0A=
Co-developed-by: Pimen Flavian Dei (Drivesec S.r.l.) <fdei@drivesec.com>=0A=
Signed-off-by: Pimen Flavian Dei (Drivesec S.r.l.) <fdei@drivesec.com>=0A=
Signed-off-by: Alberto Carboneri (Drivesec S.r.l.) <acarboneri@drivesec.com=
>=0A=
---=0A=
Tested on x86-64:=0A=
- GCC 13.3.0, W=3D1 drivers/scsi/scsi.o=0A=
- Clang 18.1.3, W=3D1 drivers/scsi/scsi.o=0A=
- Malformed BDL92 MODE SENSE regression, 3/3 fresh QEMU boots:=0A=
  scan continued with no MODE SELECT, disclosure, Oops, or panic=0A=
- Applies cleanly to v6.12.107=0A=
=0A=
 drivers/scsi/scsi.c | 24 +++++++++++++++++++-----=0A=
 1 file changed, 19 insertions(+), 5 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c=0A=
index 76cdad063f7b..f285521d9de6 100644=0A=
--- a/drivers/scsi/scsi.c=0A=
+++ b/drivers/scsi/scsi.c=0A=
@@ -727,6 +727,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enab=
le)=0A=
 		struct scsi_mode_data data;=0A=
 		struct scsi_sense_hdr sshdr;=0A=
 		char *buf_data;=0A=
+		size_t avail, offset;=0A=
 		int len;=0A=
 =0A=
 		ret =3D scsi_mode_sense(sdev, 0x08, 0x0a, 0xf2, buf, sizeof(buf),=0A=
@@ -735,11 +736,24 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool en=
able)=0A=
 			return -EINVAL;=0A=
 =0A=
 		/* Enable or disable CDL using the ATA feature page */=0A=
-		len =3D min_t(size_t, sizeof(buf),=0A=
-			    data.length - data.header_length -=0A=
-			    data.block_descriptor_length);=0A=
-		buf_data =3D buf + data.header_length +=0A=
-			data.block_descriptor_length;=0A=
+		avail =3D min_t(size_t, data.length, sizeof(buf));=0A=
+		if (data.header_length > avail)=0A=
+			return -EINVAL;=0A=
+=0A=
+		offset =3D data.header_length;=0A=
+		avail -=3D data.header_length;=0A=
+=0A=
+		if (data.block_descriptor_length > avail)=0A=
+			return -EINVAL;=0A=
+=0A=
+		offset +=3D data.block_descriptor_length;=0A=
+		avail -=3D data.block_descriptor_length;=0A=
+=0A=
+		if (avail < 5)=0A=
+			return -EINVAL;=0A=
+=0A=
+		buf_data =3D buf + offset;=0A=
+		len =3D avail;=0A=
 =0A=
 		/*=0A=
 		 * If we want to enable CDL and CDL is already enabled on the=0A=
=0A=
base-commit: af8c27375733fb6a6df9fa484cda77cc3dd0cb80=0A=
-- =0A=
2.43.0=0A=
