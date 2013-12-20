From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] [ATTEND] scsi_eh updates
Date: Fri, 20 Dec 2013 15:54:13 +0100
Message-ID: <52B45A15.4090009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3LTOyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 09:54:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

(before leaving for holiday ...)

I'd like to attend LSF 2014.

During that I'd like to discuss the current status of the SCSI EH
and the future planned updates.

As discussed during last year's LSF the SCSI error handler should be
updated to handle modern SCSI transports better.
While some patchsets are already merged, there are some issues which
are still open:
- Handling of requests during host reset:
  Do we need to keep hold of outstanding requests during host reset?
  Or is it save to return them prior to host reset?
- Check for transport status prior to sending TMFs.
  Task management functions typically need a working I_T nexus,
  so it does make sense to first check the transport status
  prior to attempting any TMFs
- Further steps for updating SCSI EH
As these are tricky issues which have possible repercussions on the
entire subsystem and LLDDs it'd be good to have a broader discussion
here.

Happy X-mas,

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
