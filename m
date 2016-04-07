From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 2/4] dm mpath: use atomic_t for counting members of
 'struct multipath'
Date: Thu, 7 Apr 2016 17:02:28 +0200
Message-ID: <57067684.7090307@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <1459454666-76428-3-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbcDGPCa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 11:02:30 -0400
In-Reply-To: <1459454666-76428-3-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, sagig@dev.mellanox.co.il

On 03/31/2016 10:04 PM, Mike Snitzer wrote:
> The use of atomic_t for nr_valid_paths, pg_init_in_progress and
> pg_init_count will allow relaxing the use of the m->lock spinlock.
>=20
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 61 ++++++++++++++++++++++++++++-------------=
----------
>  1 file changed, 33 insertions(+), 28 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
