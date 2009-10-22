From: Yugendranath R Singh <yugendranath.s@hcl.in>
Subject: [PATCH] drivers/scsi/mvsas: Support for Adaptec ASC-1045/1405
 SAS/SATA HBA on mvsas
Date: Thu, 22 Oct 2009 15:12:59 +0530
Message-ID: <4CA9DA403FFEC64AA62B3C295F8D47B721268A6601@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4CA9DA403FFEC64AA62B3C295F8D47B721268A6601CHNHCLTEVS07H_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:48838 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZJVJnG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Oct 2009 05:43:06 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>


--_002_4CA9DA403FFEC64AA62B3C295F8D47B721268A6601CHNHCLTEVS07H_
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi=20James,
The=20attached=20patch=20submitted=20on=20Oct=2015=20didn't=20get=20into=
=202.6.32-rc5.=20Please=20let=20me=20know=20if=20there=20are=20any=20issu=
es=20so=20that=20I=20can=20correct=20and=20re-send=20the=20same=20and=20g=
et=20this=20included=20in=20subsequent=20rc=20release.

Thanks,
Yugen.

-----Original=20Message-----
From:=20linux-scsi-owner@vger.kernel.org=20[mailto:linux-scsi-owner@vger.=
kernel.org]=20On=20Behalf=20Of=20Yugendranath=20R=20Singh
Sent:=20Tuesday,=20October=2013,=202009=209:45=20PM
To:=20linux-scsi@vger.kernel.org
Cc:=20James=20Bottomley;=20Andy=20Yan;=20Ke=20Wei
Subject:=20[PATCH]=20drivers/scsi/mvsas:=20Support=20for=20Adaptec=20ASC-=
1045/1405=20SAS/SATA=20HBA=20on=20mvsas

From:=20Yugendranath=20R=20Singh<yugendranath.s@hcl.in>

This=20is=20support=20for=20Adaptec=20ASC-1045/1405=20SAS/SATA=20HBA=20on=
=20mvsas,=20which=20is=20based=20on=20Marvell=2088SE6440=20chipset.
Signed-off-by:=20Yugendranath=20R=20Singh<yugendranath.s@hcl.in>
---
Patch=20being=20sent=20as=20attachment,=20as=20my=20mailer=20would=20mang=
le=20the=20contents=20if=20sent=20inline.=20



DISCLAIMER:
-------------------------------------------------------------------------=
----------------------------------------------

The=20contents=20of=20this=20e-mail=20and=20any=20attachment(s)=20are=20c=
onfidential=20and=20intended=20for=20the=20named=20recipient(s)=20only.=
=20
It=20shall=20not=20attach=20any=20liability=20on=20the=20originator=20or=
=20HCL=20or=20its=20affiliates.=20Any=20views=20or=20opinions=20presented=
=20in=20
this=20email=20are=20solely=20those=20of=20the=20author=20and=20may=20not=
=20necessarily=20reflect=20the=20opinions=20of=20HCL=20or=20its=20affilia=
tes.=20
Any=20form=20of=20reproduction,=20dissemination,=20copying,=20disclosure,=
=20modification,=20distribution=20and=20/=20or=20publication=20of=20
this=20message=20without=20the=20prior=20written=20consent=20of=20the=20a=
uthor=20of=20this=20e-mail=20is=20strictly=20prohibited.=20If=20you=20hav=
e=20
received=20this=20email=20in=20error=20please=20delete=20it=20and=20notif=
y=20the=20sender=20immediately.=20Before=20opening=20any=20mail=20and=20
attachments=20please=20check=20them=20for=20viruses=20and=20defect.

-------------------------------------------------------------------------=
----------------------------------------------

--_002_4CA9DA403FFEC64AA62B3C295F8D47B721268A6601CHNHCLTEVS07H_
Content-Type: application/octet-stream; name="mv_init.patch"
Content-Description: mv_init.patch
Content-Disposition: attachment; filename="mv_init.patch"; size=530;
	creation-date="Wed, 14 Oct 2009 02:24:54 GMT";
	modification-date="Wed, 14 Oct 2009 07:23:48 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtdXByTiBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9pbml0LmMgYi9kcml2ZXJzL3Njc2kv
bXZzYXMvbXZfaW5pdC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9pbml0LmMJMjAwOS0x
MC0xNCAwMTo0MDo1Mi4wMDAwMDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9zY3NpL212c2FzL212
X2luaXQuYwkyMDA5LTEwLTE0IDAxOjUyOjE0LjAwMDAwMDAwMCArMDUzMApAQCAtNjU3LDYgKzY1
Nyw3IEBAIHN0YXRpYyBzdHJ1Y3QgcGNpX2RldmljZV9pZCBfX2RldmluaXRkYXQKIAl7IFBDSV9W
REVWSUNFKE1BUlZFTEwsIDB4OTE4MCksIGNoaXBfOTE4MCB9LAogCXsgUENJX1ZERVZJQ0UoQVJF
Q0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTMwMCksIGNoaXBfMTMwMCB9LAogCXsgUENJX1ZERVZJ
Q0UoQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTMyMCksIGNoaXBfMTMyMCB9LAorCXsgUENJ
X1ZERVZJQ0UoQURBUFRFQzIsIDB4MDQ1MCksIGNoaXBfNjQ0MCB9LAogCiAJeyB9CS8qIHRlcm1p
bmF0ZSBsaXN0ICovCiB9Owo=

--_002_4CA9DA403FFEC64AA62B3C295F8D47B721268A6601CHNHCLTEVS07H_--
