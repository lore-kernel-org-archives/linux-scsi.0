From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 11/11]: megaraid_sas:
 Documentation/scsi/ChangeLog.megaraid_sas update
Date: Tue, 21 Dec 2010 12:58:52 -0600
Message-ID: <1292957932.3034.17.camel@mulgrave.site>
References: <AANLkTikKhNaBpxLiwENzEL+LkFdG+bnbpxv41MhNixb-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0LUS66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 13:58:58 -0500
In-Reply-To: <AANLkTikKhNaBpxLiwENzEL+LkFdG+bnbpxv41MhNixb-@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Tue, 2010-12-14 at 19:11 -0800, adam radford wrote:
> James/Linux-scsi,
>=20
> The following patch updates the Documentation/scsi/ChangeLog.megaraid=
_sas file.

now something in 6-11 doesn't work:

  CC [M]  drivers/scsi/megaraid/megaraid_sas_fusion.o
drivers/scsi/megaraid/megaraid_sas_fusion.c: In function
=E2=80=98megasas_fusion_ocr_wq=E2=80=99:
drivers/scsi/megaraid/megaraid_sas_fusion.c:2232:10: error: =E2=80=98st=
ruct
megasas_instance=E2=80=99 has no member named =E2=80=98scmd=E2=80=99
drivers/scsi/megaraid/megaraid_sas_fusion.c:2232:35: error: =E2=80=98st=
ruct
megasas_instance=E2=80=99 has no member named =E2=80=98dev=E2=80=99
drivers/scsi/megaraid/megaraid_sas_fusion.c:2233:10: error: =E2=80=98st=
ruct
megasas_instance=E2=80=99 has no member named =E2=80=98dev=E2=80=99
drivers/scsi/megaraid/megaraid_sas_fusion.c:2234:32: error: =E2=80=98st=
ruct
megasas_instance=E2=80=99 has no member named =E2=80=98scmd=E2=80=99
make[1]: *** [drivers/scsi/megaraid/megaraid_sas_fusion.o] Error 1

Just send the redo as a single file ... it looks like the whole patch
series is 125k; that should be just under the reflector limit.

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
