From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] ZAC/ZBC Update
Date: Fri, 19 Dec 2014 15:40:49 +0100
Message-ID: <549438F1.8070604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbaLSOkv (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2014 09:40:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

Hi all,

(my favourite topic again :-)

I'd like to give a short update for ZAC/ZBC implementation.
The T10 and T13 standards have been updated with some features
like SATA autosense which requires changes to the various subsystems
and the implementation itself.

These features would also allow for a simpler ZBC implementation,
but would require a more in-depth analysis of the filesystem
behaviour. Additionally the zone model has been modified, which
would require some changes to the block layer when formatting the I/O.

Also I'd like to discuss if and how generic filesystems could be
supported on ZBC drives.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
