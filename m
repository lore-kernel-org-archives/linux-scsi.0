From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/8] pm80xx: wait a minimum of 500ms before issuing
 commands to SPCv
Date: Mon, 2 Nov 2015 09:00:11 +0100
Message-ID: <5637180B.3030003@suse.de>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
 <1446216811-2248-8-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbKBIAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 03:00:14 -0500
In-Reply-To: <1446216811-2248-8-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>, linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

On 10/30/2015 03:53 PM, Benjamin Rood wrote:
> The documentation for the 8070 and 8072 SPCv chip explicitly states t=
hat
> a minimum of 500ms must elapse before issuing commands, otherwise the
> SPCv may not process them and the firmware may get into an unrecovera=
ble
> state requiring a reboot.  While the Linux guys will probably think t=
his
> is 'racy', it is called out in the chip documentation and inserting t=
his
> delay makes power management function properly.
>=20
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
Can you please add a comment in the code, too?
Just to clarify why this is done, lest that someone else tries to
'optimize' this away.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
