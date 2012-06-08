From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 2/5] scsi_dh: add scsi_dh_attached_handler_name
Date: Fri, 08 Jun 2012 17:03:44 +0200
Message-ID: <4FD21450.9020103@suse.de>
References: <1336612366-30794-1-git-send-email-snitzer@redhat.com> <20120510213112.GA7374@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab2FHPDr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jun 2012 11:03:47 -0400
In-Reply-To: <20120510213112.GA7374@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, babu.moger@netapp.com, sekharan@us.ibm.com, dm-devel@redhat.com

On 05/10/2012 11:31 PM, Mike Snitzer wrote:
> Introduce scsi_dh_attached_handler_name() to retrieve the name of the
> scsi_dh that is attached to the scsi_device associated with the provi=
ded
> request queue.  Returns NULL if a scsi_dh is not attached.
>=20
> Also, fix scsi_dh_{attach,detach} function header comments to documen=
t
> @q rather than @sdev.
>=20
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Tested-by: Babu Moger <babu.moger@netapp.com>
> Cc: Hannes Reinecke <hare@suse.de>

Acked-by: Hannes Reinecke <hare@suse.de>

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
