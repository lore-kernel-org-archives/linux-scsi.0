From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] Thin provisioning SOFT_THRESHOLD error handling
Date: Tue, 29 Jan 2013 09:14:22 +0100
Message-ID: <510784DE.3000509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab3A2IOY (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2013 03:14:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: Linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi all,

Thin-provisioned devices have the ability to set a 'soft threshold',=20
which is triggered if the real free space for this device is beyond=20
this mark.

The intention behind this is to allow the system to induce some=20
garbage collection with possibly freeing up unused space.

Initially it would be possible to execute garbage collection on=20
filesystems (eg for btrfs).

However, as this concept applies to other areas within the kernel
(like dm-thinp or even btrfs itself) it might be an idea to have
a general mechanism / error handling etc in place.

I would like to discuss at LSF the possible implementations
and handling mechanism for this kind of failure scenarios.

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
