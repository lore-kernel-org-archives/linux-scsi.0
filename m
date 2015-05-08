From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 2/5] Move code that is used both by initiator and target
 drivers
Date: Fri, 08 May 2015 14:37:19 +0200
Message-ID: <554CADFF.7090006@suse.de>
References: <554C6E79.7020501@sandisk.com> <554C6ED4.7070106@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbbEHMhV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2015 08:37:21 -0400
In-Reply-To: <554C6ED4.7070106@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On 05/08/2015 10:07 AM, Bart Van Assche wrote:
> Move the functions that are used by both the initiator and target
> subsystems into scsi_common.c/.h. This change will allow to remove
> the initiator SCSI header include directives from most SCSI target
> source files in a later patch.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
