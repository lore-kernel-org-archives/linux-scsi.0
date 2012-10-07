From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH 0/20][SCSI] mpt3sas: Driver submission
 v01.100.00.00
Date: Sun, 07 Oct 2012 13:07:30 +0100
Message-ID: <1349611650.2541.27.camel@dabdike.int.hansenpartnership.com>
References: <20120929141853.GA20768@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54454 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055Ab2JGMHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 08:07:36 -0400
In-Reply-To: <20120929141853.GA20768@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com

On Sat, 2012-09-29 at 19:48 +0530, sreekanth.reddy@lsi.com wrote:
> This is new scsi lld device driver from LSI supporting the SAS 3.0
> standard.
>=20
> Here is list of new 12gb host controllers:
>=20
>   LSI SAS3004
>   LSI SAS3008
>   LSI SAS3108
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>

This doesn't seem to compile:

drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function
=E2=80=98_scsih_sas_broadcast_primitive_event=E2=80=99:
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: error: =E2=80=98event_data=
=E2=80=99
undeclared (first use in this function)
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: note: each undeclared
identifier is reported only once for each function it appears in
drivers/scsi/mpt3sas/mpt3sas_ctl.c: In function
=E2=80=98mpt3sas_ctl_reset_handler=E2=80=99:
drivers/scsi/mpt3sas/mpt3sas_ctl.c:475:3: error: expected =E2=80=98)=E2=
=80=99 before
=E2=80=98MPT3SAS_FMT9=E2=80=99
make[3]: *** [drivers/scsi/mpt3sas/mpt3sas_scsih.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: *** [drivers/scsi/mpt3sas/mpt3sas_ctl.o] Error 1
make[2]: *** [drivers/scsi/mpt3sas] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

Did you miss something in the split?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
