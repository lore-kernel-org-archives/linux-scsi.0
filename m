From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [RESEND PATCH 2/3] dm mpath: add 'default_hw_handler'
 feature
Date: Wed, 27 Jun 2012 08:16:55 +0200
Message-ID: <4FEAA557.7050501@suse.de>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com> <1340735525-21083-3-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab2F0GQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jun 2012 02:16:57 -0400
In-Reply-To: <1340735525-21083-3-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 06/26/2012 08:32 PM, Mike Snitzer wrote:
> When specifying the feature 'default_hw_handler' multipath will use
> the currently attached hardware handler instead of trying to attach t=
he
> one specified during table load.  If no hardware handler is attached =
the
> specified hardware handler will be used.
>=20
> Leverages scsi_dh_attach's ability to increment the scsi_dh's referen=
ce
> count if the same scsi_dh name is provided when attaching -- currentl=
y
> attached scsi_dh name is determined with scsi_dh_attached_handler_nam=
e.
>=20
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Tested-by: Babu Moger <babu.moger@netapp.com>
> Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Acked-by: Hannes Reinecke <hare@suse.de>
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
