From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] [SCSI] Fix spurious request sense in error handling
Date: Mon, 31 Mar 2014 08:59:30 +0200
Message-ID: <53391252.8010909@suse.de>
References: <1396028874.15365.30.camel@dabdike> <1396029017.15365.32.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbaCaG7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 02:59:31 -0400
In-Reply-To: <1396029017.15365.32.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On 03/28/2014 06:50 PM, James Bottomley wrote:
> We unconditionally execute scsi_eh_get_sense() to make sure all faile=
d
> commands that should have sense attached, do.  However, the routine f=
orgets
> that some commands, because of the way they fail, will not have any s=
ense code
> ... we should not bother them with a REQUEST_SENSE command.  Fix this=
 by
> testing to see if we actually got a CHECK_CONDITION return and skip a=
sking for
> sense if we don't.
>=20
> Tested-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Acked-by: Hannes Reinecke <hare@suse.de>

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
