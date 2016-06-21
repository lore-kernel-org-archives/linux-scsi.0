From: Hannes Reinecke <hare@suse.de>
Subject: 4.8/scsi-queue sligthly outdated
Date: Tue, 21 Jun 2016 10:33:08 +0200
Message-ID: <5768FBC4.5030802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbcFUIdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2016 04:33:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Martin,

your 4.8/scsi-queue branch sadly is missing the libata zac fixes which
got pulled into upstream with commit
e4f7bdc2ec0d0dcc27f7d70db27a620dfdc1f697.

At the same time, upstream hasn't yet pulled in the request flags split
from Mike Christie.
So I'm having a hard time trying to rebase my ZBC patches on top of the
scsi-queue branch or upstream, always missing one set of patches or the
other.
Do think it'd be possible to update 4.8/scsi-queue to latest linus tree=
?

Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
