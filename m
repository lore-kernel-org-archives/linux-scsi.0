From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 3/11]: megaraid_sas: Add MSI-X support and msix_disable
 module parameter
Date: Tue, 21 Dec 2010 10:10:49 -0600
Message-ID: <1292947849.3034.10.camel@mulgrave.site>
References: <AANLkTi=KXg1a3ft-t3wDuxD80JcFkSWE=b8BfWVUjzqY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab0LUQK5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 11:10:57 -0500
In-Reply-To: <AANLkTi=KXg1a3ft-t3wDuxD80JcFkSWE=b8BfWVUjzqY@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Tue, 2010-12-14 at 18:53 -0800, adam radford wrote:
> James/linux-scsi,
>=20
> This patch adds MSI-X support and 'msix_disable' module parameter to
> the megaraid_sas driver.
>=20
> Signed-off-by: Adam Radford <aradford@gmail.com>

This patch doesn't compile after applying:

  CC [M]  drivers/scsi/megaraid/megaraid_sas_base.o
drivers/scsi/megaraid/megaraid_sas_base.c: In function
=E2=80=98megasas_probe_one=E2=80=99:
drivers/scsi/megaraid/megaraid_sas_base.c:3882:34: error: =E2=80=98stru=
ct
megasas_instance_template=E2=80=99 has no member named =E2=80=98service=
_isr=E2=80=99
drivers/scsi/megaraid/megaraid_sas_base.c: In function =E2=80=98megasas=
_resume=E2=80=99:
drivers/scsi/megaraid/megaraid_sas_base.c:4146:34: error: =E2=80=98stru=
ct
megasas_instance_template=E2=80=99 has no member named =E2=80=98service=
_isr=E2=80=99
drivers/scsi/megaraid/megaraid_sas_base.c: At top level:
drivers/scsi/megaraid/megaraid_sas_base.c:2450:20: warning:
=E2=80=98megasas_isr=E2=80=99 defined but not used
make[1]: *** [drivers/scsi/megaraid/megaraid_sas_base.o] Error 1
make: *** [drivers/scsi/megaraid/megaraid_sas.ko] Error 2

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
