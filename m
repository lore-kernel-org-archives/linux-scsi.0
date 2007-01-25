From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Add VPD support to aacraid
Date: Thu, 25 Jan 2007 10:07:02 +0100
Message-ID: <45B87336.5070707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:58849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965719AbXAYJHF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jan 2007 04:07:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mark,

I found to my surprise that the aacraid driver does not support VPD
pages at all. I'm somewhat used to modern SCSI HBAs export SCSI-2 disks=
,
but not supporting VPD pages at all is really a bit .. hmm .. SCSI-1-is=
h.
And it makes it really impossible to assign a persistent device ID to
those drives.

And it really made my eyes hurt. Now that I have the latest, top-of-the
range SAS drives with a real HW RAID controller and the disks are
exported as

SCSI-2.

Just as I thought we'd been finally past those days. Sigh.

Anyway, I don't think that it should be too hard to add proper VPD page
support (ie page 0x83), but for that one would have some documentation
how to ask the controller for it. I'll leave that to you :-)
You can use the page 0x80 support as a template.

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
