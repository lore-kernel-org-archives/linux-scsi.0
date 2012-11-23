From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH 11/20][SCSI] mpt3sas: Ioctl Support for MPT
 based controller
Date: Fri, 23 Nov 2012 17:05:22 +0400
Message-ID: <1353675922.2381.1.camel@dabdike.int.hansenpartnership.com>
References: <20121008005821.GA2868@dhcp-135-24-192-117.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43501 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab2KWQrT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Nov 2012 11:47:19 -0500
In-Reply-To: <20121008005821.GA2868@dhcp-135-24-192-117.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com

On Mon, 2012-10-08 at 06:28 +0530, sreekanth.reddy@lsi.com wrote:
> At the line number 475 of mpt3sas.ctl file(i.e at line number 488 in =
patch file)
> and in the function "mpt3sas_ctl_reset_handler" there was type mistak=
e.
> i.e instead of MPT3SAS_FMT it is typed as MPT3SAS_FMT9/13/2012.
> So because of this type mistake there was a compilation error.
>=20
> This patch provide ioctl Support for MPT (Message Passing Technology)
> based controller

This still doesn't seem to fix the compile failure:

drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function
=E2=80=98_scsih_sas_broadcast_primitive_event=E2=80=99:
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: error: =E2=80=98event_data=
=E2=80=99
undeclared (first use in this function)
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5368:2: note: each undeclared
identifier is reported only once for each function it appears in
make[3]: *** [drivers/scsi/mpt3sas/mpt3sas_scsih.o] Error 1

Could you please build against scsi.git scsi-misc and see if you can
find the actual problem.

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
