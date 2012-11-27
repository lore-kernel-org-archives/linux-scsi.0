From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH 15/20][SCSI] mpt3sas: This patch is part 2 of
 mpt3sas_scsih.c
Date: Tue, 27 Nov 2012 13:41:43 +0400
Message-ID: <1354009303.2276.10.camel@dabdike>
References: <20121126211612.GA10454@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54190 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758342Ab2K0Jlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2012 04:41:50 -0500
In-Reply-To: <20121126211612.GA10454@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com

On Tue, 2012-11-27 at 02:46 +0530, sreekanth.reddy@lsi.com wrote:
> This patch contains code related to Scsi Host Layer for
> MPT (Message Passing Technology) based controllers
> This patch is part 2 of mpt3sas_scsih.c
>=20
> This patch also Fixes the error:
>=20
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: error: =E2=80=98event_da=
ta=E2=80=99
> undeclared (first use in this function)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: note: each undeclared
> identifier is reported only once for each function it appears in

And now we get this:

drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function =E2=80=98_scsih_sas_b=
roadcast_primitive_event=E2=80=99:
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: warning: dereferencing =E2=
=80=98void *=E2=80=99 pointer [enabled by default]
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: error: request for member =
=E2=80=98PhyNum=E2=80=99 in something not a structure or union
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: warning: dereferencing =E2=
=80=98void *=E2=80=99 pointer [enabled by default]
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: error: request for member =
=E2=80=98PortWidth=E2=80=99 in something not a structure or union
make[3]: *** [drivers/scsi/mpt3sas/mpt3sas_scsih.o] Error 1

I'm not your compile service.  prepare the whole series against
scsi-misc, please, *compile* and test it and then resubmit.

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
