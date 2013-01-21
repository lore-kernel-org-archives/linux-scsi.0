From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] I_T Nexus loss SCSI error handling
Date: Mon, 21 Jan 2013 12:18:46 +0100
Message-ID: <50FD2416.3070500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3AULSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 06:18:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

here's a topic I'd like to discuss at LSF/MM:

SCSI error handling update to handle I_T Nexus loss.

The current error handler still uses a 'target reset' (or, rather,=20
bus reset) strategy, although the respective TMF  has been obsoleted=20
since SAM-3. SAM-5 defines an I_T nexus loss event instead, which so=20
far has only been implemented in libsas.

There has been some discussions on the mailing list, but so far=20
there hasn't been any conclusion.

So I would like to discuss a possible implementation of a I_T Nexus=20
loss strategy and how to keep compability with SAM-2 targets.

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
