From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] Update aic79xx
Date: Thu, 22 Dec 2005 15:02:00 +0100
Message-ID: <43AAB1D8.4010700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:1923 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S965032AbVLVOCD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 09:02:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

this is a patchset to update aic7xx / aic79xx to the version
2.0.12-6.3.9 as found on Adaptecs website.
Most important will be the addition of two new (well, not really new)
IDs to the driver and some sequencer fixes. Don't ask me about any
details there, I just took them as is from adaptec.

That having said, it omits all Adaptec specifica like installing their
own workqueue for timeout commands et al.

Tested here on Adaptec 29320 Ultra320.

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
