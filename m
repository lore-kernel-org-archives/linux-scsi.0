From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] [RESEND] aic79xx update
Date: Tue, 24 Jan 2006 10:40:50 +0100
Message-ID: <43D5F622.104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51409 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1030412AbWAXJkv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 04:40:51 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 662E41CC31
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 10:40:50 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

this is a resend of my earlier patchset to update aic79xx with the fixe=
s
from the latest 'official' driver from adaptec.
As suggested by hch, I've redone the patches to follow a more logical o=
rder.
- 1/4: Update aicasm
- 2/4: Update aic79xx sequencer code
- 3/4: aic79xx SLOWCRC fix for certain adapters
- 4/4: Update documentation, mainly adaptec contact addresses.
I've added slowcrc as a new inline option for now. Of course it would b=
e
better to use individual MODULE_PARM lines for each parameter, but this
should be done with aic7xxx and aic79xx simultaneously so a not to
confuse the users.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
